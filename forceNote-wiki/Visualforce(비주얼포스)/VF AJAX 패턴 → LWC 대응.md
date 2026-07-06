---
tags: [visualforce, lwc, migration, ajax, actionPoller, polling, empApi, refreshApex]
source: Visualforce Developer Guide v67.0 Ch24 + sf-skills(experience-lwc-generate)/async-notification-patterns.md + ebikes-lwc orderStatusPath + LWC Dev Guide(Lifecycle Hooks·RefreshView API)
created: 2026-07-05
aliases: [actionPoller LWC 대체, LWC 폴링, LWC polling, setInterval LWC, VF AJAX LWC 마이그레이션, actionFunction LWC, actionSupport LWC, rerender LWC, 주기적 갱신 LWC, 주기적 서버 폴링]
---

# VF AJAX 패턴 → LWC 대응

> Visualforce의 AJAX/액션 컴포넌트(`apex:actionPoller`·`actionFunction`·`actionSupport`·`reRender`·`actionStatus`)를 LWC로 옮길 때의 대응 패턴 — 주기 폴링은 `setInterval` + imperative Apex(해제는 `disconnectedCallback`에서 `clearInterval` 필수), 가능하면 폴링 대신 `lightning/empApi` Platform Events 푸시로 전환한다.

---

## 매핑 요약표 — VF AJAX 컴포넌트 → LWC 대응

VF 측 각 컴포넌트의 attribute 전수 레퍼런스는 [[apex 컴포넌트 — AJAX·액션·Remote Objects·기타]], 표준 *출력/입력* 컴포넌트(pageBlock·inputField 등)의 base component 매핑은 [[Visualforce 개요 — 도구·퀵스타트]]의 매핑 표 참조. 이 노트는 그 표에 없는 **AJAX/액션 계열**을 다룬다.

| Visualforce | LWC 대응 | 비고 |
|---|---|---|
| `apex:actionPoller` | `setInterval()` + imperative Apex 호출 | `disconnectedCallback`에서 `clearInterval` **필수**. 실시간성이 목적이면 `lightning/empApi` 푸시 전환 권장 |
| `apex:actionFunction` | JS 클래스 메서드에서 imperative Apex 호출 | `apex:param` 순서 바인딩 대신 메서드 인자 객체로 파라미터 전달 |
| `apex:actionSupport` | 템플릿 이벤트 핸들러 (`onchange`·`onblur` 등) | DOM 이벤트 → 핸들러 → 반응형 프로퍼티 변경으로 자동 리렌더 |
| `reRender` 속성 | 반응형 리렌더 (자동) + `refreshApex()` / `RefreshViewEvent` | 클라이언트 상태는 반응성으로 자동, **서버 데이터 재조회**는 refreshApex |
| `apex:actionStatus` | 로딩 플래그 프로퍼티 + `lightning-spinner` | `isLoading = true` → 호출 → `.finally(() => isLoading = false)` |
| `apex:actionRegion` | 불필요 — 컴포넌트 분해 | LWC는 폼 전체 서버 왕복이 없어 부분 처리 경계 개념 자체가 사라짐 |
| `onsubmit` / `oncomplete` | Promise `.then()` / `.finally()` (또는 async/await) | imperative 호출이 Promise를 반환 |

> 위 대응은 1:1 치환이 아니라 **모델 전환**이다. VF는 "폼 전체를 서버로 보내고 지정 영역을 다시 그리는" 서버 중심 모델, LWC는 "데이터만 주고받고 반응형 프로퍼티가 변하면 프레임워크가 알아서 다시 그리는" 클라이언트 중심 모델이다.

---

## 1. `apex:actionPoller` → `setInterval` + imperative Apex

### VF 측 동작 (레퍼런스 요건 recap)

`apex:actionPoller`는 지정 간격으로 서버에 AJAX 요청을 보내는 타이머다. VF Developer Guide v67.0 기준:

- `interval` — 초 단위, **5초 이상 필수, 미지정 시 기본 60초**. interval은 요청 사이 간격일 뿐이고, 요청이 서버 큐에 들어간 뒤 처리·표시까지는 추가 시간이 걸릴 수 있다.
- action 메서드는 **경량(lightweight)** 유지 — DML·외부 서비스 호출·리소스 집약 작업 회피 (반복 호출되므로).
- 페이지의 **로그인 세션을 계속 살려둔다** (inactivity timeout이 발생하지 않음).
- 다른 AJAX 요청 컴포넌트와 같은 페이지에서 쓰면 동시 요청이 서로 덮어써 페이지가 깨질 수 있음.
- 다른 액션의 결과로 re-render되면 **스스로 리셋**된다.

```html
<!-- VF 원문 예제 (Visualforce Developer Guide v67.0) — 15초마다 카운터 갱신 -->
<apex:page controller="exampleCon">
<apex:form>
<apex:outputText value="Watch this counter: {!count}" id="counter"/>
<apex:actionPoller action="{!incrementCounter}" reRender="counter" interval="15"/>
</apex:form>
</apex:page>
```

### LWC 구현 — 폴링 패턴 (실제 소스 발췌)

LWC에는 내장 폴러 컴포넌트가 없다. 표준 JavaScript `setInterval()`로 주기를 만들고, 매 tick마다 imperative Apex(`@AuraEnabled`)를 호출한다. 아래는 Salesforce 공식 sf-skills 레포의 폴링 폴백 패턴 원문이다 ([[async-notification-patterns]]).

```javascript
// pollingFallback.js — 실제 소스 발췌 (sf-skills experience-lwc-generate)
import { LightningElement, api } from 'lwc';
import checkJobStatus from '@salesforce/apex/JobStatusController.checkJobStatus';

export default class PollingFallback extends LightningElement {
    @api jobId;

    pollingInterval = null;
    pollFrequencyMs = 3000;
    maxAttempts = 60;
    attemptCount = 0;

    connectedCallback() {
        this.startPolling();
    }

    disconnectedCallback() {
        this.stopPolling();
    }

    startPolling() {
        this.pollingInterval = setInterval(() => {
            this.checkStatus();
        }, this.pollFrequencyMs);
    }

    stopPolling() {
        if (this.pollingInterval) {
            clearInterval(this.pollingInterval);
            this.pollingInterval = null;
        }
    }

    async checkStatus() {
        this.attemptCount++;

        if (this.attemptCount >= this.maxAttempts) {
            this.stopPolling();
            this.handleTimeout();
            return;
        }

        try {
            const result = await checkJobStatus({ jobId: this.jobId });

            if (result.status === 'COMPLETE' || result.status === 'ERROR') {
                this.stopPolling();
                this.handleCompletion(result);
            }
        } catch (error) {
            console.error('Polling error:', error);
        }
    }

    handleCompletion(result) {
        this.dispatchEvent(new CustomEvent('complete', { detail: result }));
    }

    handleTimeout() {
        this.dispatchEvent(new CustomEvent('timeout'));
    }
}
```

### 폴링 구현 시 필수 규율

| # | 규율 | 이유 |
|---|---|---|
| 1 | **`disconnectedCallback`에서 `clearInterval` 필수** | 컴포넌트가 DOM에서 제거돼도 interval은 살아서 계속 서버를 때린다 (메모리 누수 + 불필요한 서버 부하). [[Lifecycle Hooks]]의 "disconnectedCallback에서 connectedCallback 작업 정리" 원칙 그대로 |
| 2 | `connectedCallback` **중복 fire 가드** | `connectedCallback`은 요소가 제거 후 재삽입되면 1회 이상 fire될 수 있다 — interval 핸들이 이미 있으면 새로 만들지 않거나, 시작 전 `stopPolling()` 호출 |
| 3 | **상한(maxAttempts) 설정** | VF actionPoller처럼 무한 폴링하면 방치된 탭이 서버를 계속 때린다. 시도 횟수·시간 상한 후 중단 + 타임아웃 이벤트 |
| 4 | Apex 메서드는 **경량 유지** | VF 시절 규칙과 동일 — 폴링 대상 메서드에서 DML·콜아웃·무거운 SOQL 회피 |
| 5 | 완료 조건에서 **즉시 중단** | 상태가 확정되면(`COMPLETE`/`ERROR`) 다음 tick을 기다리지 말고 `stopPolling()` |
| 6 | 간격은 상황에 맞게 | VF의 5초 하한 같은 플랫폼 강제는 없지만, 지나치게 짧은 간격은 서버 부하·거버너 소비만 늘린다 (sf-skills 잡 상태 확인 예제는 3초) |

> ⚠️ VF actionPoller는 "연결을 주기적으로 갱신해 로그인 세션을 살려두고 페이지가 inactivity로 타임아웃되지 않는다"는 부수효과가 문서화돼 있었다. LWC `setInterval` 폴링에는 그런 보장이 문서화돼 있지 않으므로 그 부수효과에 의존하던 설계는 재검토하고, 호출 실패는 `catch`에서 직접 처리한다.

---

## 2. 폴링 대신 푸시 — `lightning/empApi` 전환 권장 기준

주기 폴링은 "변화가 없어도 계속 물어보는" 낭비 구조다. **서버 측에서 변화 시점을 알 수 있다면**(예: 비동기 잡 완료, 레코드 상태 변경) Platform Event를 발행하고 LWC가 `lightning/empApi`로 구독하는 **푸시 모델**이 우선이다.

### 선택 기준

| 상황 | 권장 |
|---|---|
| 서버가 변화 시점에 이벤트를 발행할 수 있음 (Apex `EventBus.publish`, Flow, CDC) | **empApi 푸시** — 지연 최소·서버 부하 최소 |
| 실시간 갱신이 여러 클라이언트에 동시에 필요 (대시보드·모니터링·협업 UI) | **empApi 푸시** (브로드캐스트) |
| empApi를 쓸 수 없는 컨텍스트 (Experience Cloud/Communities, 일부 모바일 컨텍스트 — sf-skills 기준) | **setInterval 폴링 폴백** |
| 짧고 유한한 대기 (잡 1건 완료 확인 등 수십 초 내 종료가 보장) + 이벤트 인프라 만들 가치가 없음 | 폴링 (maxAttempts 상한 필수) |
| 외부 시스템 변화를 조직이 감지 못함 (이벤트 발행 주체가 없음) | 폴링 외 대안 없음 |

> 구독 가능 채널 (sf-skills 예시 기준): `/event/{EventName}__e`(Platform Event), `/data/{Object}ChangeEvent`(Change Data Capture). `lightning/empApi`는 streaming 채널 구독용 모듈이며 최소 API 버전 45.0 — [[LWC API Modules 레퍼런스]].

### empApi 구독 골격 (프로덕션 라이프사이클)

전체 코드·단계별 해설(가용성 사전 체크 `isEmpEnabled()` → `setDebugFlag` → `onError` → `await subscribe(ch, -1, cb)` → 가드된 `unsubscribe`)은 [[Platform Event 통합 패턴]]에 실제 소스(ebikes)로 전수 정리돼 있다. 핵심 골격만:

```javascript
// 구조 예시 — 실제 동작 코드 아님 (전체 프로덕션 코드는 [[Platform Event 통합 패턴]] 참조)
import { subscribe, unsubscribe, onError, isEmpEnabled } from 'lightning/empApi';

const CHANNEL = '/event/OrderEvent__e';

export default class OrderMonitor extends LightningElement {
    subscription;

    async connectedCallback() {
        if (!(await isEmpEnabled())) return;      // 가용성 사전 체크 (미지원 컨텍스트 무음 실패 방지)
        onError((e) => console.error('EMP API error:', e));
        this.subscription = await subscribe(CHANNEL, -1, (event) => {
            this.handleEvent(event.data.payload);  // 폴링 없이 서버가 밀어줌
        });                                        // replayId -1 = 구독 이후 신규 이벤트만
    }

    disconnectedCallback() {
        if (this.subscription) {                   // isEmpEnabled 실패로 구독 안 했을 수 있으므로 가드
            unsubscribe(this.subscription);
        }
    }
}
```

폴러 → 푸시 전환의 대칭성: `setInterval` ↔ `subscribe`, `clearInterval` ↔ `unsubscribe` — **둘 다 `connectedCallback`에서 열고 `disconnectedCallback`에서 닫는 라이프사이클 자원**이라는 점은 동일하다.

---

## 3. `apex:actionFunction` · `apex:actionSupport` → 이벤트 핸들러 + 반응형 리렌더

### actionFunction — "JS에서 부를 수 있는 서버 액션"

VF의 `actionFunction`은 컨트롤러 액션 메서드를 감싸는 전역 JavaScript 함수를 만들어 페이지 JS에서 호출하게 했다(파라미터는 `apex:param` **순서 바인딩**). LWC에서는 이 우회가 필요 없다 — 클래스 메서드에서 imperative Apex를 직접 호출하고, 파라미터는 **이름 있는 객체**로 넘긴다 ([[Imperative 호출 패턴]]).

```javascript
// 구조 예시 — 실제 동작 코드 아님
// VF: <apex:actionFunction name="sayHello" action="{!sayHello}" rerender="out"/>
//     + <script>window.setTimeout(sayHello, 2000)</script>
// LWC 대응:
import sayHello from '@salesforce/apex/ExampleController.sayHello';

export default class Example extends LightningElement {
    username;                                   // 반응형 프로퍼티 — 값이 바뀌면 자동 리렌더

    connectedCallback() {
        setTimeout(() => this.callServer(), 2000);
    }

    async callServer() {
        this.username = await sayHello({ firstParam: 'Yes!' }); // apex:param 순서 바인딩 → 이름 있는 인자
    }                                            // rerender="out" → 프로퍼티 대입만으로 해당 부분 자동 갱신
}
```

### actionSupport — "DOM 이벤트로 서버 액션 트리거"

VF의 `actionSupport`는 `event="onchange"` 등으로 특정 컴포넌트의 DOM 이벤트에 서버 액션을 붙였다. LWC에서는 템플릿 이벤트 핸들러가 그 자리다.

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<!-- VF: <apex:inputField value="{!opp.stageName}">
           <apex:actionSupport event="onchange" rerender="thePageBlock"/>
         </apex:inputField> -->
<lightning-input-field field-name="StageName" onchange={handleStageChange}>
</lightning-input-field>
```

핸들러에서 반응형 프로퍼티를 바꾸거나 imperative Apex를 호출하면 된다. **`rerender` 대상을 지정할 필요가 없다** — 템플릿이 참조하는 프로퍼티가 바뀌면 그 부분만 프레임워크가 다시 그린다. 연타 입력(검색어 등)에는 [[Imperative 호출 패턴]]의 debouncing 패턴을 함께 쓴다.

---

## 4. `reRender` → `refreshApex()` · RefreshView API

VF의 `reRender`는 두 가지 일을 한꺼번에 했다: ① 서버에서 새 뷰 상태를 받아 ② 지정 영역의 DOM을 다시 그림. LWC에서는 이 둘이 분리된다.

| reRender가 하던 일 | LWC 대응 |
|---|---|
| 클라이언트 상태 변경 반영 (DOM 다시 그리기) | **자동** — 반응형 프로퍼티/`@wire` 결과가 바뀌면 프레임워크가 리렌더. 명시 지정 불필요 |
| **서버 데이터 재조회** 후 반영 | `refreshApex(wiredResult)` (`@salesforce/apex`) — Apex `@wire`로 프로비저닝된 데이터 재조회. GraphQL wire는 `refreshGraphQL()` |
| 다른 컴포넌트/뷰 계층까지 갱신 | `RefreshViewEvent` (`lightning/refresh`) dispatch — view(컴포넌트 계층) 단위 갱신. 단 **RefreshView API 자체는 데이터를 다시 가져오지 않으며** 각 컴포넌트가 `refreshApex()` 등으로 refresh를 직접 개시해야 한다 — [[RefreshView API]] |
| record 데이터 최신화 | `@wire(getRecord)` + `notifyRecordUpdateAvailable` — LDS가 `@wire` 데이터를 fresh하게 유지 |

```javascript
// 구조 예시 — 실제 동작 코드 아님 (imperative 저장 후 wire 데이터 재조회)
import { refreshApex } from '@salesforce/apex';

@wire(getOpportunities) wiredOpps;   // 프로비저닝된 값 전체를 보관해야 refreshApex에 넘길 수 있음

async handleSave() {
    await saveRecord({ ... });        // imperative DML
    await refreshApex(this.wiredOpps); // VF의 reRender에 해당하는 "서버 재조회 + 자동 리렌더"
}
```

---

## 5. 나머지 대응 — actionStatus · actionRegion · oncomplete

- **`apex:actionStatus`** (요청 진행 표시) → 로딩 플래그 + 스피너. `this.isLoading = true` → 호출 → `.finally(() => { this.isLoading = false; })`, 템플릿에서 `<template lwc:if={isLoading}><lightning-spinner ...>`.
- **`apex:actionRegion`** (서버가 처리할 폼 영역 한정 — 부분 검증 회피용) → 대응물 자체가 불필요. LWC는 폼 전체를 서버로 보내는 뷰스테이트 왕복이 없고, 검증은 `lightning-input`의 `reportValidity()` 등으로 필드/컴포넌트 단위 제어한다. 화면 조각의 독립 처리가 필요하면 컴포넌트를 분해한다.
- **`onsubmit` / `oncomplete` / `onbeforedomupdate`** → imperative 호출 Promise의 전후 훅으로 대체: 호출 직전 코드(=onsubmit), `.then()`(=oncomplete), 렌더 후 시점이 필요하면 `renderedCallback()` ([[Lifecycle Hooks]]).
- **`status`·`focus` 속성** → 로딩 프로퍼티 / `this.template.querySelector(...).focus()`.
- 페이지 수준 JS 통신(VF ↔ LWC 공존 기간의 크로스 DOM 통신)은 [[JavaScript·Remoting·LMS across DOM]]의 LMS(Lightning Message Service) 참조.

---

## 관련 노트

- [[apex 컴포넌트 — AJAX·액션·Remote Objects·기타]] — VF 측 원본 레퍼런스 (actionPoller·actionFunction·actionSupport·actionRegion·actionStatus attribute 전수)
- [[Visualforce 개요 — 도구·퀵스타트]] — 표준 VF 컴포넌트 ↔ base LWC 매핑 표 (출력·입력 계열)
- [[Imperative 호출 패턴]] — LWC에서 Apex 직접 호출 + debouncing
- [[Wire 패턴]] / [[Wire vs Imperative 선택]] — 폴링 대상 데이터를 wire로 둘지 imperative로 둘지
- [[RefreshView API]] — `RefreshViewEvent`·`refreshApex`·`notifyRecordUpdateAvailable`
- [[Lifecycle Hooks]] — `connectedCallback`/`disconnectedCallback` (자원 정리 원칙·중복 fire 주의)
- [[Platform Event 통합 패턴]] — empApi 프로덕션 라이프사이클 전수 (isEmpEnabled·setDebugFlag·onError·subscribe·unsubscribe)
- [[Platform Event 정의와 구독]] — 이벤트 정의·발행·구독 방식 비교 (Apex 트리거·Pub/Sub API·CometD·empApi)
- [[LWC API Modules 레퍼런스]] — `lightning/empApi` 모듈 (최소 API 버전 45.0)
- [[async-notification-patterns]] — sf-skills 원본 (empApi 패턴 4종 + 폴링 폴백)
