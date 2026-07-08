---
tags: [lwc, lds, lightning-data-service, ui-api, cache, hub, concept]
source: developer.salesforce.com (LWC Developer Guide — "Lightning Data Service" data-ui-api.html · "Data Guidelines" data-guidelines.html; 라이브 공식 문서, Tier 2, 접속 2026-07-08) + 기존 위키 종합
created: 2026-07-08
aliases: [Lightning Data Service, LDS, LDS 개념, LDS란, 공유 캐시, shared cache, LDS vs Apex, Apex vs LDS, UI API 데이터 레이어, 클라이언트 데이터 레이어]
---

# LDS 개념 (Lightning Data Service)

> LDS는 UI API 위에 얹힌 LWC의 클라이언트측 데이터 레이어다 — 컴포넌트들이 하나의 공유 캐시를 통해 레코드를 읽고 쓰며, FLS·공유·CRUD를 자동 준수하고, Apex 없이 데이터를 다룬다.

---

## LDS란 / 왜 쓰나

Lightning Data Service(LDS)는 LWC의 Salesforce 데이터 접근을 관리하는 프레임워크다. 공식 문서 표현으로 **"records loaded in Lightning Data Service are cached and shared across components"** — 레코드는 한 번만 로드되고 여러 컴포넌트가 공유한다.

| 이점 | 내용 (공식 문서) |
|---|---|
| **공유 캐시 · 성능** | "a record is loaded once, no matter how many components are using it." 같은 레코드를 보는 컴포넌트가 많아도 한 번만 로드하고, 결과를 클라이언트에 캐시한다. |
| **자동 변경 전파** | "If Lightning Data Service detects a change to a record ... all components using a relevant @wire adapter receive the new value." **한 컴포넌트의 변경이 같은 레코드를 wire한 다른 컴포넌트에 자동 반영**된다. |
| **보안 자동 준수** | "UI API responses also respect CRUD access, field-level security settings, and sharing settings." 접근 권한·FLS·공유가 자동 적용 — 코드로 직접 체크할 필요 없음. |
| **API 한도 없음** | "Lightning Data Service doesn't incur any API usage calls." UI API 호출은 org의 API 한도를 소모하지 않는다. |
| **Apex 불필요** | 조회·생성·수정·삭제를 Apex 클래스 없이 선언형/명령형으로 처리. |

LDS는 **User Interface API 위에 구축**된다("built on top of User Interface API"). UI API는 Salesforce UI를 쉽게 만들도록 설계된 공개 API이고, LDS는 그 위에 캐싱·공유·반응성을 얹은 클라이언트 레이어다.

```javascript
// 공유 캐시 예시 — 컴포넌트 A가 저장하면 컴포넌트 B가 코드 없이 자동 갱신
// 컴포넌트 A
import { updateRecord } from 'lightning/uiRecordApi';
await updateRecord({ fields: { Id: this.recordId, Name: this.newName } });

// 컴포넌트 B — 같은 recordId를 wire만 해두면 별도 코드 없이 리렌더
import { getRecord } from 'lightning/uiRecordApi';
@wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD] })
contact;   // A의 updateRecord 직후 새 Name으로 자동 갱신
```

---

## LDS를 쓰는 3가지 접근 (무코드 → 저수준)

같은 LDS 캐시를 공유하되 추상화 수준이 다르다. 위에서 아래로 갈수록 제어권은 커지고 작성 코드는 많아진다.

| 접근 | 모듈/컴포넌트 | 성격 | 상세 |
|---|---|---|---|
| **1. record-form 베이스 컴포넌트** | `lightning-record-form` · `lightning-record-edit-form` · `lightning-record-view-form` | 무코드(마크업만) — 폼 UI·저장까지 자동 | [[Record Form 선택]] |
| **2. wire 어댑터** | `lightning/uiRecordApi`의 `getRecord` 등, `lightning/uiObjectInfoApi` | 반응형 읽기 — 캐시 변경 시 자동 재프로비저닝 | [[getRecord 패턴]] · [[uiRecordApi]] |
| **3. LDS 함수(명령형)** | `createRecord` · `updateRecord` · `deleteRecord` · `notifyRecordUpdateAvailable` | 명령형 CRUD — 이벤트 핸들러에서 직접 호출 | [[uiRecordApi]] |

- 공식 가이드는 **"The easiest way to work with Salesforce data is to use base components built on Lightning Data Service"** — 가능하면 record-form(1번)에서 시작하라고 권한다.
- 3가지 모두 **동일한 클라이언트 캐시**를 통과하므로, 어느 방식으로 저장하든 그 레코드를 보는 다른 컴포넌트에 전파된다(아래 무효화 절 참조).
- 각 접근의 시그니처·필드 지정 방식·예제는 위 링크된 페이지에 위임한다.

---

## 캐시 전파 · 무효화 · 낙관적 업데이트

### 전파 — 무엇이 자동 갱신되는가

변경이 **LDS 캐시를 통과하느냐 우회하느냐**로 자동 갱신 여부가 갈린다.

| 변경 경로 | LDS 캐시 | 같은 레코드를 wire한 다른 컴포넌트 |
|---|---|---|
| `createRecord`/`updateRecord`/`deleteRecord` (uiRecordApi) | 직접 갱신 | ✅ 자동 리렌더 — 추가 코드 불필요 |
| record-form 저장 | LDS 경유 → 캐시 갱신 | ✅ 자동 리렌더 |
| **Apex DML** (명령형·`@AuraEnabled` 저장) | **우회** — 캐시는 변경을 모름 | ❌ → `notifyRecordUpdateAvailable([{recordId}])` 필요 |
| 외부 변경 (다른 사용자·자동화·통합) | 우회 | ❌ → 알게 된 시점에 무효화 호출 |

### 무효화 — 캐시가 우회됐을 때 알려주기

LDS를 우회한 변경(Apex DML·서버측 변경) 후에는 캐시를 명시적으로 무효화해 재조회를 유도한다.

```javascript
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';

async handleApexUpdate() {
    await updateContactApex({ recordId: this.recordId /* ... */ }); // LDS 우회
    // recordId 기반으로 캐시 무효화 → getRecord wire가 자동 재조회
    notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
}
```

- ⚠️ **`getRecordNotifyChange`(구명)는 deprecated** — 동일 모듈·시그니처의 `notifyRecordUpdateAvailable([{recordId}])`로 대체됐다.
- **`refreshApex(wiredResult)`** 는 특정 Apex wire 결과를 강제 새로고침한다. 단 공식 문서 경고: **"The use of refreshApex to refresh data from non-Apex wire adapters is deprecated"** — non-Apex(LDS) wire 데이터는 `notifyRecordUpdateAvailable`로 갱신한다.
- 컴포넌트 계층(view) 전체를 리로드 없이 동기화하려면 [[RefreshView API]] 참조.

### 낙관적 업데이트(optimistic update)

서버 응답을 기다리지 않고 클라이언트 상태를 먼저 반영해 즉각 반응성을 주고, 실패 시 이전 상태로 롤백하는 패턴. 3단계 — ① 이전 상태 보존 → ② 클라이언트 선반영 → ③ `.catch()`에서 롤백 + 에러 토스트. 실전 구현(ebikes orderBuilder)은 [[uiRecordApi]]의 "낙관적 UI 업데이트" 절 참조.

---

## Apex vs LDS 선택 기준

공식 Data Guidelines 기준으로, **기본은 LDS로 시작**하고 LDS가 못 하는 경우에만 Apex를 쓴다.

| 상황 | 선택 | 근거 (공식 문서) |
|---|---|---|
| 표준 레코드 CRUD, 폼 UI | **LDS** | 무코드/저코드 · API 한도 없음 · 자동 전파·FLS |
| 단일 레코드 + 관련 필드 반응형 조회 | **LDS** (`getRecord`) | 캐시·공유·자동 갱신 |
| UI API **미지원 객체** (예: Task, Event) | **Apex** | "objects that aren't supported by User Interface API, like Task and Event" |
| **조건으로 레코드 목록 로드** | **Apex** (SOQL) | "operations that User Interface API doesn't support, like loading a list of records by criteria" |
| **트랜잭션** 연산 (관련 레코드 원자적 생성) | **Apex** | "To perform a transactional operation" |
| wire 없이 **명령형 호출**이 필요 | **Apex** (imperative) | "To call a method imperatively, as opposed to via the wire service" |
| 한 번에 **여러 쿼리** 전송 | **GraphQL wire** | "send multiple queries in one operation" |

> [!warning] LDS·Apex 데이터 혼용 주의
> 공식 문서: "Data that you fetch using Apex can be inconsistent with data fetched using LDS wire adapters in both online and offline conditions." 두 경로를 섞으면 온·오프라인 모두에서 불일치가 생길 수 있으니, 같은 레코드는 한 경로로 통일하는 편이 안전하다.

---

## 관련 노트

- [[Record Form 선택]] — 접근 1: record-form 베이스 컴포넌트(무코드 CRUD)
- [[getRecord 패턴]] — 접근 2: wire 어댑터로 반응형 조회
- [[uiRecordApi]] — 접근 3: `createRecord`/`updateRecord`/`deleteRecord` 명령형 CRUD + 캐시 전파·낙관적 업데이트
- [[RefreshView API]] — 컴포넌트 계층(view) 데이터 refresh 개시
- [[UI API 개요]] — LDS가 얹힌 UI API 구조(캐시·ETag·HTTP 상태코드)
- [[getListUi·관련리스트 wire 패턴]] — 리스트뷰/관련 리스트 조회 wire 어댑터
- [[LWC MOC]]
