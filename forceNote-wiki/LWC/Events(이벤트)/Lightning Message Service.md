---
tags: [lwc, lms, message-service, pubsub, pattern]
source: lwc-recipes/lmsPublisherWebComponent, lmsSubscriberWebComponent
created: 2026-05-17
aliases: [LMS, Lightning Message Service, publish subscribe]
---

# Lightning Message Service (LMS)

> 컴포넌트 계층 밖의 통신 (형제, 전혀 다른 DOM 트리, Aura/Visualforce와 호환). `pubsub` 오픈소스 컴포넌트의 공식 대체제 (Summer '20 GA).

---

## 언제 LMS?

| 상황 | 권장 |
|---|---|
| 부모 → 자식 | @api property |
| 자식 → 부모 | CustomEvent |
| 형제 컴포넌트 | **LMS** |
| DOM 경계 초월 | **LMS** |
| Aura / Visualforce 통신 | **LMS** |

---

## Message Channel 정의

```xml
<!-- messageChannels/Record_Selected__c.messageChannel-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<LightningMessageChannel xmlns="http://soap.sforce.com/2006/04/metadata">
    <masterLabel>Record Selected</masterLabel>
    <isExposed>true</isExposed>
    <fields>
        <fieldName>recordId</fieldName>
        <description>Id of the selected record</description>
    </fields>
</LightningMessageChannel>
```

---

## Publisher 패턴

```javascript
import { publish, MessageContext } from 'lightning/messageService';
import RECORD_SELECTED_CHANNEL from '@salesforce/messageChannel/Record_Selected__c';

export default class LmsPublisher extends LightningElement {
    @wire(MessageContext)
    messageContext; // 생명주기 관리 — @wire 필수

    handleContactSelect(event) {
        const payload = { recordId: event.target.contact.Id };
        publish(this.messageContext, RECORD_SELECTED_CHANNEL, payload);
    }
}
```

---

## Subscriber 패턴

```javascript
import { subscribe, unsubscribe, MessageContext } from 'lightning/messageService';
import RECORD_SELECTED_CHANNEL from '@salesforce/messageChannel/Record_Selected__c';

export default class LmsSubscriber extends LightningElement {
    subscription = null;
    recordId;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscription = subscribe(
            this.messageContext,
            RECORD_SELECTED_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    disconnectedCallback() {
        unsubscribe(this.subscription); // 방어적 명시 해제 (dreamhouse 공식 패턴)
        this.subscription = null;
    }

    handleMessage(message) {
        this.recordId = message.recordId;
    }
}
```

> [!note] 구독 해제
> `MessageContext` @wire가 컴포넌트 제거 시 자동 해제하지만, 공식 프로젝트(dreamhouse-lwc)는 `disconnectedCallback`에서 명시적 `unsubscribe`를 사용. 방어적 패턴으로 권장.

---

## APPLICATION_SCOPE (앱 전체 범위)

```javascript
import { subscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';

// 기본: 현재 active area만 수신
this.subscription = subscribe(this.messageContext, CHANNEL, handler);

// APPLICATION_SCOPE: 비활성 탭 포함 앱 전체 수신
this.subscription = subscribe(
    this.messageContext,
    CHANNEL,
    handler,
    { scope: APPLICATION_SCOPE }
);

// APPLICATION_SCOPE는 수동 해제 필요
disconnectedCallback() {
    unsubscribe(this.subscription);
}
```

---

## 듀얼 입력 패턴 (@api recordId + LMS)

레코드 페이지에서는 `@api recordId`로 받고, 목록 페이지의 타일 클릭은 LMS로 받는 컴포넌트:

```javascript
export default class PropertyMap extends LightningElement {
    propertyId;
    subscription = null;

    @wire(MessageContext)
    messageContext;

    // 레코드 페이지 진입 — @api recordId
    @api
    get recordId() { return this.propertyId; }
    set recordId(propertyId) { this.propertyId = propertyId; }

    // 목록 페이지 — LMS 구독
    connectedCallback() {
        this.subscription = subscribe(
            this.messageContext,
            PROPERTYSELECTEDMC,
            (message) => { this.propertyId = message.propertyId; }
        );
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }
}
```

---

## Debounce + LMS (입력 최적화)

```javascript
const DELAY = 350;

handleSearchKeyChange(event) {
    this.searchKey = event.detail.value;
    this.fireChangeEvent();
}

fireChangeEvent() {
    window.clearTimeout(this.delayTimeout);
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    this.delayTimeout = setTimeout(() => {
        const filters = { searchKey: this.searchKey, maxPrice: this.maxPrice };
        publish(this.messageContext, FILTERSCHANGEMC, filters);
    }, DELAY);
}
```

> 검색/필터 UI에서 사용자 입력 완료 350ms 후에만 publish — Apex 호출 횟수 대폭 감소.

---

## pubsub와의 차이

| | 구형 pubsub (오픈소스) | LMS (공식) |
|---|---|---|
| 지원 | 커뮤니티 | Salesforce 공식 |
| Aura 통신 | ❌ | ✅ |
| 생명주기 관리 | 수동 | MessageContext 자동 |
| 배포 | 컴포넌트 직접 포함 | 메타데이터 채널 정의 |

> [!tip] pubsub 사용 중이면 LMS로 마이그레이션
> lwc-recipes에서 pubsub는 공식적으로 retired. 신규 프로젝트는 LMS만 사용.

---

## 관련 노트

- [[CustomEvent 패턴]] — 부모-자식 직접 통신
- [[상태 관리]] — @lwc/state 공유 상태
