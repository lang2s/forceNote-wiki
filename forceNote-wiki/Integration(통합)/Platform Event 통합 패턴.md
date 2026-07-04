---
tags: [integration, platform-event, event-bus, lwc, apex, pattern]
source: apex-recipes/PlatformEventRecipes.cls, lwc-recipes/lmsSubscriber, ebikes-lwc-main/force-app/main/default/lwc/orderStatusPath, ebikes-lwc-main/force-app/main/default/objects/Manufacturing_Event__e
created: 2026-05-17
aliases: [Platform Event 통합, EventBus, 이벤트 기반 통합, empApi, isEmpEnabled, setDebugFlag]
---

# Platform Event 통합 패턴

> 시스템 간 느슨한 결합(Loose Coupling)을 위한 이벤트 기반 통합.
> Apex·Flow·외부 시스템이 이벤트를 발행하고, Apex Trigger·LWC·외부 시스템이 수신.

---

## 아키텍처 개요

```
발행자 (Publisher)              수신자 (Subscriber)
─────────────────               ───────────────────
Apex (EventBus.publish)  ──┐
Flow (Publish Message)     ├──▶ Apex Trigger (after insert)
외부 시스템 (REST API)    ──┘    LWC (empApi subscribe)
                                외부 시스템 (CometD)
```

---

## Apex 발행 패턴

```apex
// 단건
OrderEvent__e event = new OrderEvent__e(
    OrderId__c = order.Id,
    Status__c  = 'Created',
    Amount__c  = order.TotalAmount
);
Database.SaveResult result = EventBus.publish(event);

// 다건 — bulkify
List<OrderEvent__e> events = new List<OrderEvent__e>();
for (Order o : orders) {
    events.add(new OrderEvent__e(
        OrderId__c = o.Id,
        Status__c  = o.Status
    ));
}
List<Database.SaveResult> results = EventBus.publish(events);

// 결과 확인
for (Database.SaveResult sr : results) {
    if (!sr.isSuccess()) {
        System.debug('발행 실패: ' + sr.getErrors()[0].getMessage());
    }
}
```

> [!note] 트랜잭션 동작
> `EventBus.publish()`는 메인 트랜잭션 **커밋 이후** 이벤트를 발행.
> 트랜잭션이 롤백되면 이벤트도 발행되지 않음 — 데이터 일관성 자동 보장.

---

## Apex Trigger 수신 패턴

```apex
trigger OrderEventTrigger on OrderEvent__e (after insert) {
    List<Order_Log__c> logs = new List<Order_Log__c>();

    for (OrderEvent__e event : Trigger.new) {
        logs.add(new Order_Log__c(
            Order_Id__c  = event.OrderId__c,
            Status__c    = event.Status__c,
            Event_UUID__c = event.EventUuid  // 중복 방지용 고유 ID (시스템 필드)
        ));
    }

    insert logs;

    // 다음 이벤트 처리 재개 (에러 없이 계속)
    EventBus.TriggerContext.currentContext().setResumeCheckpoint(
        Trigger.new[Trigger.new.size() - 1].ReplayId
    );
}
```

> [!tip] setResumeCheckpoint()
> 트리거 실패 시 재시도 기준 ReplayId를 명시. 생략하면 실패 시 처음부터 재처리.
> 이미 처리한 이벤트를 `EventUuid`로 중복 체크하여 멱등성 확보.

---

## LWC 구독 패턴

```javascript
// orderStatusMonitor.js
import { LightningElement, wire } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

const CHANNEL = '/event/OrderEvent__e';

export default class OrderStatusMonitor extends LightningElement {
    subscription = {};

    connectedCallback() {
        onError((error) => console.error('EMP API error:', error));

        // -1: 이 시점부터 새 이벤트만 수신
        // -2: 24시간 이내 보관된 이벤트부터 수신
        subscribe(CHANNEL, -1, (event) => {
            this.handleEvent(event.data.payload);
        }).then((sub) => {
            this.subscription = sub;
        });
    }

    handleEvent(payload) {
        console.log('Order updated:', payload.OrderId__c, payload.Status__c);
        // UI 갱신 로직
    }

    disconnectedCallback() {
        unsubscribe(this.subscription, (response) => {
            console.log('Unsubscribed:', response);
        });
    }
}
```

---

## LWC 실전 라이프사이클 — empApi로 실시간 UI 갱신 (ebikes)

위 패턴은 최소 골격이다. 프로덕션 컴포넌트는 **가용성 사전 체크·디버그 플래그·async/await 구독·에러 리포팅·수신 payload로 UI 갱신**까지 전체 라이프사이클을 다룬다. ebikes-lwc의 `orderStatusPath`는 `Manufacturing_Event__e` 플랫폼 이벤트를 구독해 **커스텀 SLDS Path 컴포넌트의 주문 상태를 실시간으로 갱신**하는 실제 사례다. (아래는 실제 소스 발췌 — 동작 코드)

> [!note] 컴포넌트 주석 (ebikes)
> *"Consider using the native path component in production. This custom component adds support for the streaming API for the sake of a demo, it may not scale."*
> 커스텀 Path + Streaming API 조합은 데모 목적이며, 대규모에서는 네이티브 Path 컴포넌트 권장.

### empApi 전체 import

기본 3개(`subscribe`/`unsubscribe`/`onError`)에 더해 **`setDebugFlag`·`isEmpEnabled`** 를 함께 import한다.

```javascript
import {
    subscribe,
    unsubscribe,
    onError,
    setDebugFlag,
    isEmpEnabled
} from 'lightning/empApi';

const MANUFACTURING_EVENT_CHANNEL = '/event/Manufacturing_Event__e';
```

### 가용성 사전 체크 + 디버그 + async 구독

`connectedCallback`을 `async`로 선언하고, **구독 전 `isEmpEnabled()`로 EMP API 사용 가능 여부를 먼저 확인**한다. 비활성 조직/컨텍스트(예: 게스트 사용자)에서 구독 시도로 인한 무음 실패를 방지한다.

```javascript
async connectedCallback() {
    // 1) EMP API 사용 가능 여부 사전 체크
    const isEmpApiEnabled = await isEmpEnabled();
    if (!isEmpApiEnabled) {
        this.reportError('The EMP API is not enabled.');
        return;
    }
    // 2) 디버그 로깅 + 전역 에러 핸들러 등록
    setDebugFlag(true);
    onError((error) => {
        this.reportError('EMP API error', error);
    });

    // 3) async/await + try/catch 구독 (replayId -1 = 구독 시점 이후 새 이벤트만)
    try {
        this.subscription = await subscribe(
            MANUFACTURING_EVENT_CHANNEL,
            -1,
            (event) => {
                this.handleManufacturingEvent(event);
            }
        );
    } catch (error) {
        this.reportError('EMP API error: failed to subscribe', error);
    }
}
```

| 단계 | API | 목적 |
|---|---|---|
| 사전 체크 | `isEmpEnabled()` | Promise\<boolean\> — 구독 시도 전 EMP API 가용성 확인 |
| 디버그 | `setDebugFlag(true)` | 브라우저 콘솔에 empApi 스트리밍 상세 로그 출력 |
| 에러 | `onError(cb)` | 구독 후 발생하는 스트리밍 에러 전역 처리 |
| 구독 | `await subscribe(ch, -1, cb)` | replayId `-1` = 구독 이후 신규 이벤트만 수신 |

### 안전한 해제 — subscription 가드

`disconnectedCallback`에서 **구독이 실제로 존재할 때만** `unsubscribe` 호출. `isEmpEnabled` 실패로 구독을 건너뛴 경우 `this.subscription`이 `undefined`이므로 가드가 필요하다.

```javascript
disconnectedCallback() {
    if (this.subscription) {
        unsubscribe(this.subscription);
    }
}
```

### 수신 payload → UI(Path 상태) 갱신

콜백은 payload의 `Order_Id__c`가 **현재 레코드일 때만** 처리(브로드캐스트 채널에서 자기 레코드 필터링)하고, 수신한 `Status__c`로 Path의 현재 값을 갱신한다.

```javascript
handleManufacturingEvent(event) {
    // 현재 레코드에 대한 이벤트만 처리
    if (event.data.payload.Order_Id__c === this.recordId) {
        this.setPicklistValue(event.data.payload.Status__c);
    }
}

async setPicklistValue(value) {
    // 수신한 상태값으로 Order__c 레코드 업데이트 → LDS가 Path UI 재렌더
    const fields = { Id: this.recordId };
    fields['Status__c'] = value;
    try {
        await updateRecord({ fields });
        this.dispatchEvent(new ShowToastEvent({
            title: 'Order Updated',
            message: `Order status set to "${value}"`,
            variant: 'success'
        }));
    } catch (error) {
        this.reportError(`Failed to update order status to "${value}"`, error);
    }
}
```

> [!tip] 데이터 흐름
> `Manufacturing_Event__e` 수신 → payload 필터링(`Order_Id__c === recordId`) → `updateRecord`로 `Order__c.Status__c` 갱신 → `getRecord`/`getPicklistValues` wire가 반응 → 커스텀 SLDS Path 재렌더. 이벤트 발행자(제조 시스템)와 UI가 완전히 분리된 채 실시간 동기화된다.

### 구독 대상 이벤트 정의 (`Manufacturing_Event__e`)

```xml
<!-- objects/Manufacturing_Event__e/Manufacturing_Event__e.object-meta.xml -->
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <deploymentStatus>Deployed</deploymentStatus>
    <eventType>HighVolume</eventType>
    <label>Manufacturing Event</label>
    <pluralLabel>Manufacturing Events</pluralLabel>
    <publishBehavior>PublishAfterCommit</publishBehavior>
</CustomObject>
```

필드는 `Order_Id__c`(Text 18, required)·`Status__c`(Text 255, required) 두 개. `publishBehavior`가 `PublishAfterCommit`이라 발행 트랜잭션 커밋 후에만 구독자에게 전달된다.

| `publishBehavior` | 의미 |
|---|---|
| `PublishAfterCommit` | 트랜잭션 커밋 후 발행 — 롤백 시 이벤트도 미발행 (데이터 일관성) |
| `PublishImmediately` | 커밋과 무관하게 즉시 발행 |

---

## 외부 시스템 → Salesforce 발행 (REST API)

```bash
# 외부에서 Platform Event 발행 (Salesforce REST API 사용)
POST /services/data/v59.0/sobjects/OrderEvent__e/
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "OrderId__c": "001xxxxxxxxxxxx",
  "Status__c": "Shipped"
}
```

> 외부 시스템이 Salesforce에 직접 Platform Event를 발행할 때 사용.
> `@RestResource` Custom Endpoint 대신 이 방식을 쓰면 수신 로직이 Trigger로 일원화됨.

---

## Platform Event vs 다른 통합 방식

| 기준 | Platform Event | @RestResource | Streaming API PushTopic |
|---|---|---|---|
| 방향 | 양방향 | Inbound | Outbound |
| 동기/비동기 | 비동기 | 동기 | 비동기 |
| 수신 측 | Trigger, LWC, 외부 | 외부 시스템 | LWC, 외부 |
| 커스텀 로직 | Trigger에 집중 | Endpoint에 집중 | 별도 없음 |
| 재처리 | ReplayId로 가능 | ❌ | 제한적 |
| 권장 | 시스템 간 이벤트 | 단순 REST API | 레거시 (deprecated 예정) |

---

## Platform Event 메타데이터 정의

```xml
<!-- force-app/main/default/objects/OrderEvent__e/OrderEvent__e.object-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <deploymentStatus>Deployed</deploymentStatus>
    <eventType>HighVolume</eventType>
    <label>Order Event</label>
    <pluralLabel>Order Events</pluralLabel>
    <fields>
        <fullName>OrderId__c</fullName>
        <label>Order Id</label>
        <type>Text</type>
        <length>18</length>
    </fields>
    <fields>
        <fullName>Status__c</fullName>
        <label>Status</label>
        <type>Text</type>
        <length>50</length>
    </fields>
</CustomObject>
```

| eventType | 설명 |
|---|---|
| `HighVolume` | 대용량, ReplayId 지원, 72시간 보존 |
| `StandardVolume` | 소용량, 레거시 |

---

## 테스트

```apex
@isTest
static void testOrderEventPublish() {
    OrderEvent__e event = new OrderEvent__e(
        OrderId__c = '001xxxxxxxxxxxx',
        Status__c  = 'Created'
    );

    Test.startTest();
    Database.SaveResult result = EventBus.publish(event);
    Test.stopTest(); // ← Trigger 동기 실행

    Assert.isTrue(result.isSuccess());

    // Trigger가 생성한 레코드 확인
    List<Order_Log__c> logs = [SELECT Status__c FROM Order_Log__c];
    Assert.areEqual(1, logs.size());
    Assert.areEqual('Created', logs[0].Status__c);
}
```

---

## 관련 노트

- [[Platform Event 발행]] — EventBus.publish 기본 발행·수신 패턴
- [[Custom REST Endpoint]] — Inbound 동기 통합
- [[Queueable + Callout 패턴]] — 이벤트 처리 후 외부 Callout 연결
- [[Named Credential]] — Outbound 연동
- [[sfdc_surveys Namespace]] — Survey 응답 이벤트를 Platform Event로 발행하는 사례
- [[Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널)]] — 플랫폼 이벤트·CDC를 Amazon EventBridge로 중계하는 EventRelayConfig Tooling sObject 정본.
- [[integration-connectivity-generate]] (sf-skill — 실행형) — Platform Event·통합 런타임 플러밍 구성 실행형 스킬
