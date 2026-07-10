---
tags: [apex, platform-events, pub-sub, trigger, subscribe, event-driven]
source: platform_events.pdf (Platform Events Developer Guide v67.0, Summer '26, Tier 2) · extend_click_automate.pdf (Automate Your Business Processes with Salesforce Flow, Spring '26, Tier 2 — Platform Event-Triggered Flow 소절)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/
created: 2026-06-14
aliases: [Platform Event 정의, Platform Event 구독, Publish Behavior, high-volume platform event, Low_Ink__e, after insert trigger, ReplayId, EventUuid, setResumeCheckpoint, RetryableException, Platform Event-Triggered Flow, 플랫폼 이벤트 트리거 플로우]
---

# Platform Event 정의와 구독

> 커스텀 플랫폼 이벤트를 정의(`__e`)하고, Apex `after insert` 트리거·Pub/Sub API·CometD로 구독하는 방법. 발행 동작·고볼륨/표준볼륨·ReplayId/EventUuid·재시도까지.

> [!note] 공식 *Platform Events Developer Guide v67.0* 발췌. 발행(EventBus.publish)은 [[Platform Event 발행]]·[[EventBus Namespace]] 참조.

---

## 정의 (Setup)

Setup → **Platform Events** → New. 표준 필드 입력 후 **Publish Behavior** 선택, 커스텀 필드 추가. 이벤트 객체는 `__e` 접미사(예: `Low_Ink__e`).

### Publish Behavior
| 옵션 | 동작 |
|---|---|
| **Publish Immediately** (기본·권장) | publish 호출 시점에 발행 — 트랜잭션 성공 여부 무관. 구독자가 데이터 커밋 **전에** 받을 수 있음. 발행이 트랜잭션 데이터와 무관할 때 |
| **Publish After Commit** | 트랜잭션 **커밋 성공 후에만** 발행, 실패 시 미발행. 구독자가 커밋된 데이터를 필요로 할 때만 |

> Pub/Sub API로 발행한 메시지에는 Publish Behavior가 적용되지 않는다.

### 고볼륨 vs 표준볼륨
- **High-volume**(고볼륨) — API v45.0+ 신규 커스텀 이벤트의 **기본값**. 비동기 발행, 더 나은 확장성. 메시지 **72시간(3일)** 보관.
- **Standard-volume** — **Summer '27 은퇴 예정**. 마이그레이션 필요.
- 플랫폼 이벤트 필드는 **기본적으로 read-only**, 필드 레벨 보안 적용 안 됨(메시지에 전 필드 포함).

### 시스템 필드
- **ReplayId** — 스트림 내 이벤트 위치를 가리키는 불투명 ID. 재구독(replay) 시 사용. **유일성 보장 안 됨**(org 마이그레이션 등 유지보수 시).
- **EventUuid** — 이벤트 메시지를 **고유 식별**할 때는 ReplayId가 아니라 이 필드 사용.

---

## 구독 — Apex `after insert` 트리거

이벤트 구독은 **이벤트 객체에 `after insert` 트리거**를 작성한다. 이벤트가 발행되면 after insert 트리거가 발화한다.

```apex
// Trigger for catching Low_Ink events. (Tier 2 원문)
trigger LowInkTrigger on Low_Ink__e (after insert) {
    List<Case> cases = new List<Case>();
    User adminUser = [SELECT Id FROM User WHERE Username='admin@acme.org'];

    // 발행된 각 이벤트 순회 (Trigger.New = 이벤트 메시지 목록)
    for (Low_Ink__e event : Trigger.New) {
        System.debug('Printer model: ' + event.Printer_Model__c);
        if (event.Printer_Model__c == 'MN-123') {
            Case cs = new Case();
            cs.Priority = 'Medium';
            cs.Subject = 'Order new ink cartridge for SN ' + event.Serial_Number__c;
            cs.OwnerId = adminUser.Id;   // 미지정 시 Automated Process가 소유
            cases.add(cs);
        }
    }
    insert cases;
}
```

> 트리거 실행 사용자는 기본 **Automated Process**. 생성 레코드 소유자를 명시하거나 실행 사용자를 오버라이드한다.

### 다른 구독 방식
- **Pub/Sub API** — gRPC / HTTP2 기반, 이벤트를 **Apache Avro 바이너리**로 효율 전송. 발행 RPC: `Publish`(unary) / `PublishStream`(양방향 스트리밍, 높은 발행률). 구독·발행·스키마 조회를 1 API로. **11개 언어**(Python·Java·Go·Node 등) 클라이언트 지원. ReplayId로 스트림 재생(replay). → 구독 플로우·ManagedSubscribe·ReplayPreset 상세는 [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] 참조.
- **CometD** — Streaming API 구독(롱폴링)
- **Flow / Process** — 선언적 구독 (플랫폼 이벤트 트리거 플로우)
- **Lightning Components** — `lightning/empApi`로 구독

### 이벤트 스트림 그룹·필터 (커스텀 채널)
- **커스텀 채널**에 **필터 표현식**을 설정하면, 구독자는 표현식에 맞는 이벤트만 받는다(서버측 필터링 → 트래픽·처리 절감).
- **지원 구독자**: **Pub/Sub API · Streaming API(CometD) · event relay 만**. ❌ Apex 트리거·Flow·Process는 커스텀 채널을 지원하지 않아 스트림 필터링 불가(표준 채널 `/event/{EventName}__e`만).
- 여러 이벤트를 묶는 **채널 그룹**으로 한 구독에서 여러 이벤트 타입 수신 가능.

---

## 재시도 — 일시적 오류 처리

트리거 처리 중 일시적 오류·외부 조건 대기 시 **재시도**한다(이벤트 레코드 외부 요인이고 곧 해소될 때).

| 방법 | 특징 |
|---|---|
| **`EventBus.RetryableException`** | 트리거가 이 예외를 던지면 재시도. 최대 재시도 초과 시 **error 상태**(구독 끊김·발행 중단) → 이메일 알림 |
| **`setResumeCheckpoint(replayId)`** | DML 커밋 후 체크포인트 설정 → 재시작 시 그 ReplayId 이후부터 순차 재처리 (트리거를 즉시 중단하진 않음) |

```apex
// 체크포인트 방식 — 커밋된 지점 이후부터 재개
EventBus.TriggerContext.currentContext().setResumeCheckpoint(replayId);
```

---

## 구독 — Platform Event-Triggered Flow (선언적)

> 출처: *Automate Your Business Processes with Salesforce Flow* (ECA, Spring '26, Tier 2). Apex `after insert` 트리거 대신 **선언적(no-code)** 으로 플랫폼 이벤트를 구독하는 방식.

**Platform Event-Triggered Flow**는 플랫폼 이벤트가 발생하면 실행되는 플로우 타입이다. ECA 원문:

> "Platform Event Triggered Flow — Launches when a platform event occurs. This type of flow runs in the background without user interaction." (참조: *Platform Events in Setup*)

- **실행 방식** — 사용자 상호작용 없이 **백그라운드**에서 실행된다(화면 없음).
- **예시(ECA)** — "When an integrated printer is out of ink, it publishes a platform event message." → 이벤트 발행이 플로우를 실행한다.
- **구독 요소** — 실행 중인 플로우가 이벤트를 기다리게 하려면 **Wait 요소**를 추가한다. 플로우에서 이벤트를 **발행**하려면 대상 객체를 플랫폼 이벤트로 지정한 **Create Records 요소**를 추가한다.

### 실행 사용자 (running user)

ECA 원문 그대로:

> "In event-triggered flows, you can set the flow to run as the **default workflow user**. If the default workflow user gets unset, the flow runs as the **automated process user**."

즉 event-triggered flow의 실행 사용자는 **기본 워크플로 사용자(default workflow user)** 이며, 이 값이 해제되면 **Automated Process User** 로 실행된다. (Apex `after insert` 트리거의 기본 실행 사용자 Automated Process 와는 지정 경로가 다르다 — 위 Apex 트리거 소절 참조.)

### Flow가 구독할 수 있는 표준 플랫폼 이벤트

플로우는 **커스텀 플랫폼 이벤트**와 아래 표준 플랫폼 이벤트를 구독할 수 있다(ECA 전수):

- AIPredictionEvent
- BatchApexErrorEvent
- FlowExecutionErrorEvent
- FOStatusChangedEvent
- OrderSummaryCreatedEvent
- OrderSumStatusChangedEvent
- PlatformStatusAlertEvent

### 고려사항 (ECA)

| 항목 | 내용 |
|---|---|
| **Value Truncation** | 플랫폼 이벤트 메시지를 필터링할 때, 조건 값은 **765자**를 넘을 수 없다. |
| **Subscriptions Related List** | 플랫폼 이벤트 상세 페이지의 *Subscriptions* 관련 목록에 대기 중인 구독 엔터티가 표시된다. 대기 중인 플로우 인터뷰가 있으면 **"Process"** 구독자 1건으로 나타난다. |
| **Formulas** | 수식에서 플랫폼 이벤트를 참조하려면 Wait 요소에서 이벤트 데이터를 record 변수로 전달한 뒤 그 변수의 필드를 참조한다. |
| **Uninstalling Events** | 플랫폼 이벤트가 포함된 패키지를 제거하기 전, 그 이벤트를 대기 중인 인터뷰를 먼저 삭제해야 한다. |

### Apex 트리거와의 차이

| 구분 | Apex `after insert` 트리거 | Platform Event-Triggered Flow |
|---|---|---|
| 구현 | `__e` 객체의 `after insert` 코드 | 선언적(no-code) 플로우 |
| 실행 사용자 | 기본 Automated Process (레코드 소유자·실행 사용자 오버라이드 가능) | default workflow user → 미설정 시 Automated Process User |
| 커스텀 채널 필터 | ❌ 미지원(표준 채널만) | ❌ 미지원(표준 채널만) — 위 "이벤트 스트림 그룹·필터" 참조 |
| 재시도 제어 | `EventBus.RetryableException` · `setResumeCheckpoint` (위 재시도 소절) | ECA(Spring '26)는 platform-event-triggered flow 고유의 재시도 정책을 명시하지 않음 |

> [!note] **재시도** — ECA는 플로우 트랜잭션 실패 시 "트랜잭션은 플로우 인터뷰를 포함해 어떤 작업도 재시도하지 않는다"고만 서술하며, 플랫폼 이벤트 트리거 플로우 전용 재시도/재전달 정책은 명시하지 않는다. 재시도가 필요한 구독은 위 Apex `EventBus.RetryableException` 방식을 사용한다.

---

## 관련 노트

- 📖 공식: [Platform Events Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/)
- [[Platform Event 발행]] — EventBus.publish, apex-recipes 발행 패턴
- [[EventBus Namespace]] — publish/TriggerContext API 시그니처
- [[EventBus Publish Callbacks]] — onSuccess/onFailure 콜백
- [[Platform Event Apex 테스트]] — Test.getEventBus deliver/fail
- [[Platform Event 한도와 고려사항]] — allocations·이벤트 종류 비교
- [[ChangeEventHeader]] — CDC(Change Data Capture) 변경 이벤트
- [[Record-Triggered Flow]] — 자매 트리거 플로우 타입(레코드 변경 기반). 플랫폼 이벤트 트리거 플로우와 같은 이벤트 기반 선언적 자동화 계열
- [[Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널)]] — 플랫폼 이벤트 채널·구독 설정의 Tooling sObject 정본(PlatformEventChannel(Member)·PlatformEventSubscriberConfig·EventRelayConfig를 SOQL로 조회).
- [[integration-eventing-cdc-configure]] (sf-skill — 실행형) — CDC 채널·구독 메타데이터 구성 실행형 스킬
