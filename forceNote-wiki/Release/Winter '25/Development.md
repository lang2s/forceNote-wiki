---
tags: [release, winter_25, development, apex, lwc, api]
api_version: v62.0
release_date: 2024-10
created: 2026-06-16
source: salesforce_winter25_release_notes.pdf (Salesforce Winter '25 Release Notes, Tier 2)
aliases: [Winter '25 Development, 윈터25 개발, v62 Apex 변경, Apex New and Changed v62, LWC v62, ConnectApi 변경, API v62 New and Changed, 윈터25 개발자 항목, LWC API 62.0, this.style, this.hostElement, SoqlStubProvider, Parallel Subscriptions, Auth Namespace v62, DataSource Namespace v62]
---

# Winter '25 — Development (Apex · LWC · API)

> Winter '25 (API v62.0)의 개발자 변경 전수 기록 — LWC API 62.0(클래스 객체 바인딩·`this.style`·`this.hostElement`), Apex(Free-tier Event Monitoring·SOQL 에러 메시지 변경·Set 반복 일관성·외부 객체 Mock SOQL), API(CORS allowlist 확대·Apex Metadata API enqueued 배포 한도·Platform API 21.0~30.0 폐기 연기), 그리고 New&Changed 레퍼런스(Apex 네임스페이스·LWC 컴포넌트/모듈/타깃/Aura·ConnectApi·Objects·Metadata/Tooling/UI API).

---

## 개요

이 노트는 Winter '25 릴리즈 노트의 **Development** 섹션 전체를 전수 전사한 spoke다. 허브 [[Winter '25]]에서 진입하며, 형제 spoke [[Winter '25/Release Updates]]·[[Winter '25/Platform]]과 함께 Winter '25을 구성한다. Apex 레퍼런스 심화는 [[Apex MOC]], LWC 레퍼런스 심화는 [[LWC MOC]], Connect in Apex는 [[ConnectApi Namespace 개요]]를 참고한다.

핵심 한 줄 요약:

- **Lightning Components** — LWC API 버전 62.0이 HTML 클래스 바인딩, `this.style`(host `CSSStyleDeclaration`), `this.hostElement`(부모 요소) 접근을 제공한다. LWS distortion을 off/on으로 전환해 동작 차이를 관찰할 수 있다. LWS 자동 활성화는 무기한 연기된다.
- **Apex** — Event Monitoring 무료 등급으로 Apex 미처리 예외를 추적하고, 예외 데이터 로깅 범위가 확장된다. SOQL 에러/기능 변경을 검토하고, set 반복 시 더 일관된 결과를 경험한다.
- **API** — My Domain URL에 정의한 CORS allowlist가 `api.salesforce.com` 도메인 API에도 적용된다. Salesforce Platform API 버전 21.0~30.0 폐기는 Summer '25로 연기된다.
- **Visualforce** — 모든 unmanaged Visualforce 페이지가 `force.com` 도메인에서 서빙될 때 영향을 받는지 확인한다.

---

## Apex 신규/변경

> Apex 미처리 예외를 Event Monitoring 무료 등급으로 추적하고, 이벤트 로그 파일에 기록되는 예외 데이터 커버리지가 확장된다. SOQL 에러·기능 변경을 검토하고, set 반복 시 더 일관된 결과를 얻는다. 자세한 내용은 Apex Developer Guide와 Apex Reference Guide 참조.

### Track Apex Unexpected Exceptions with Free-Tier Event Monitoring

Event Monitoring 무료 등급에 접근하여, 미처리 예외 이메일에만 의존하지 않고 Apex 코드 실행의 미처리 예외를 추적한다. **Apex Unexpected Exception** 이벤트 타입의 이벤트 로그 파일에 캡처된 정보를 분석해 Apex 코드를 트러블슈팅한다.

**Where:** 모든 에디션에 적용.

### Get More Coverage for Unexpected Exceptions in Apex Code Execution

진입점(entry point)이 `@AuraEnabled`, `@RestResource`, `@InvocableAction` 어노테이션인 트랜잭션에서 트리거된 예외가 이제 **Apex Unexpected Exception** 이벤트 타입에 캡처된다. 이러한 트랜잭션에서 트리거된 예외 정보를 제공하는 이벤트 로그 파일을 분석한다. 커버리지 확장으로 인해 이벤트 로그 파일에 기록되는 예외 데이터가 급증할 수 있다.

**Where:** 모든 에디션에 적용.

### Understand SOQL Error and Functionality Changes to Update Your Code

이번 릴리즈의 업데이트는 오래된 SOQL 에러 메시지·기능에 의존하는 기존 Apex 코드, 특히 동적 SOQL 쿼리의 에러 메시지를 파싱하는 코드에 영향을 줄 수 있다.

**Where:** 모든 에디션에 적용.

**How:** 기능 변경과 에러 메시지 업데이트는 다음과 같다. (아래 목록은 PDF 본문 11846–11913 전체를 그대로 전사 — old → new 매핑)

- 다중 통화(multi-currency) org의 동적 SOQL 쿼리에서 음수 통화 값을 지원한다. 예: `SELECT Name FROM Invoice__c WHERE Balance__c < USD-500`.
- 유효하지 않은 동적 SOQL 쿼리에 대한 새 에러 메시지.

```sql
-- (PDF 발췌, 11849–11863) old → new 에러 메시지 매핑
-- SELECT Id FROM Account USING everything
Old: unexpected token: '<EOF>'
New: unexpected token: 'everything'

-- SELECT ParentId, Value FROM InteractionRefOrValue WHERE ParentId IN ()
Old: unexpected token: ')'
New: unexpected token: 'ParentId IN ()'

-- SELECT FROM ServicePresenceStatus
Old: unexpected token: 'FROM'
New: unexpected token: 'SELECT FROM'

-- SELECT Id from $casecomment WHERE isdeleted = false
Old: line 1:15 no viable alternative at character '$'
New: line 1:15 unexpected token: '$'

-- SELECT lastmodifieddate, companyna fr$om user
Old: unexpected token: user
New: missing value at 'user'
```

- 동적 SOQL 쿼리에서 예상치 못한 토큰을 따옴표로 둘러싸는 새 에러 메시지.

```sql
-- (PDF 발췌, 11865–11880)
SELECT annualrevenue , parentid
FROM Account
WHERE
(isDeleted = false AND NumberOfEmployees != 100)
OR (isDeleted = false AND Site = '999')
AND ParentId = '000000000000000' LIMIT 50000

Old: unexpected token: AND
New: unexpected token: 'AND'
```

- 동적 SOQL 쿼리의 `WHERE` 문에서 `LIKE` 키워드와 함께 NULL 리터럴을 사용할 때의 새 에러 메시지.

```sql
-- (PDF 발췌, 11882–11886)
SELECT Id, Name, Country__c, State__c, City__c, PAN_Number__c
FROM Account WHERE PAN_Number__c LIKE NULL AND Name LIKE '%a%'

Old: invalid operator
New: unexpected token: 'NULL'
```

- 동적 SOQL 쿼리에서 2개를 초과하는 중첩 함수를 사용할 때의 새 에러 메시지.

```sql
-- (PDF 발췌, 11888–11892)
SELECT convertCurrency(calendar_year(convertTimezone(lastmodifieddate))) FROM
account

Old: expecting a right parentheses, found '('
New: unexpected token: '('
```

- 동적 SOQL 쿼리의 유효하지 않은 datetime 리터럴에 대한 새 에러 메시지.

```sql
-- (PDF 발췌, 11896–11907)
SELECT Id FROM Account WHERE SystemModstamp >
2020-12-12t12:12:00-25:00

Old: line 1:67 mismatched character '5' expecting set '0'..'3'
New: Invalid datetime: 2020-12-12t12:12:00-25:00

SELECT Id FROM Account WHERE SystemModstamp >
2020-52-12t12:12:00-05:00

Old: line 1:51 no viable alternative at character '5'
New: Invalid datetime: 2020-52-12t12:12:00-05:00
```

- 동적 SOQL 쿼리에서 콜론(`:`) 뒤에 유효한 바인드 변수 참조가 없을 때의 새 에러 메시지.

```sql
-- (PDF 발췌, 11909–11913)
SELECT Id FROM Custom_User_Attribute__c WHERE User__c =:
0050W000007Jz7jQAC

Old: Only variable references are allowed in dynamic SOQL/SOSL
New: unexpected token: '0050'
```

### See Improved Consistency When Iterating Sets

API 버전 **62.0 이상**에서, `for` 또는 `foreach()` 루프로 set을 반복하는 동안 set의 요소를 수정하면 예외가 발생한다. 이 동작은 버전 종속(versioned)이다. API 61.0 이하에서는 반복 중 set 수정이 때때로 허용되어 예상치 못한 결과를 생성했다.

**Where:** 모든 에디션에 적용.

**How:** 다음 샘플 코드는 set을 반복하는 동안 요소를 제거하여 예외 `System.FinalException: Cannot modify a collection while it is being iterated.` 를 던진다.

```apex
// (PDF 발췌, 11929–11935) — set 반복 중 수정 시 FinalException
Set<String> set_string = new Set<String>{'one', 'two', 'three'};
for (String str : set_string) {
System.debug(str);
set_string.remove(str);
System.debug(set_string.contains(str));
}
System.debug(set_string);
```

### Write Mock SOQL Tests for External Objects

코드 커버리지와 품질을 높이기 위해, 새 SOQL stub 메서드와 새 테스트 클래스를 사용해 외부 객체(external objects)에 대한 더 나은 Apex 단위 테스트를 작성하고 SOQL 쿼리 응답을 mock할 수 있다. 외부 객체에 대한 기본·조인 SOQL 쿼리를 사용하고 테스트 컨텍스트에서 mock 레코드를 반환한다.

**Where:** Lightning Experience와 Salesforce Classic(일부 org에서는 불가)의 Enterprise, Performance, Unlimited, Developer 에디션에 적용.

**How:** 새 `System.SoqlStubProvider` 클래스를 확장하고 `handleSoqlQuery()` 클래스 메서드를 오버라이드하여 mock 테스트 클래스를 생성한다. `Test.createStubQueryRow()` 또는 `Test.createStubQueryRows()`를 사용해 외부 객체 레코드를 생성한다. `Test.createSoqlStub()`을 사용해 테스트에 mock provider를 등록하고 테스트 코드를 실행한다.

> Note: Apex governor limit이 stub된 레코드에 적용된다.

SOQL 쿼리는 `FROM` 절로 직접이든 서브쿼리를 통해서든 **외부 객체에 대한 것이어야 한다.** stub 구현 내에서 다음 기능은 허용되지 않는다.

- SOQL
- SOSL
- Callouts
- Future methods
- Queueable jobs
- Batch jobs
- DML
- Platform events

---

## New & Changed 개발자 항목 (Apex 클래스 — namespace별)

> 이 클래스·enum·인터페이스는 신규이거나 변경되었다. 자세한 내용은 Apex Developer Guide와 Apex Reference Guide 참조.

영향받는 네임스페이스: **Auth, ConnectApi, DataSource, fsccashflow, Sfdc_Enablement, CommerceOrders, industriesNlpSvc, PlaceQuote.** (ConnectApi의 상세 클래스/메서드/enum은 아래 [New & Changed API](#new--changed-api-connectapi--restmetadatatoolinguibulk--soql) 섹션의 ConnectApi 항목 참조)

### Auth Namespace

Auth 네임스페이스에 신규·변경 클래스, 메서드, 인터페이스, enum, 예외가 있다.

**New Classes**

- **`Auth.HeadlessUserDiscoveryResponse`** — headless user discovery 핸들러로 사용자를 찾을 때 사용자 ID 또는 커스텀 에러 메시지를 반환한다. 새 `(userIds, customErrorMessage)` 생성자를 사용한다.

**New Enums**

- **`Auth.VerificationAction`** — headless passwordless 로그인 중 사용자에게 일회용 비밀번호(OTP)를 전송하는 방법을 지정한다.
- **`Auth.CustomOneTimePasswordDeliveryResult`** — 커스텀 OTP 전달 핸들러의 성공·예외 응답을 지정한다.

**Changed Enums**

- **`Auth.OauthTokenType`** — JSON Web Token(JWT) 기반 액세스 토큰을 폐기(revoke)하려는 경우 새 `ORG_JWT` 값을 사용한다.

**New Interfaces**

- **`Auth.CustomOneTimePasswordDeliveryHandler`** — Experience Cloud 유스케이스에 커스텀 OTP provider를 사용한다(generally available).
- **`Auth.HeadlessUserDiscoveryHandler`** — headless passwordless 로그인 중 선택한 식별자(identifier)를 기준으로 사용자를 찾는다.

### DataSource Namespace

DataSource 네임스페이스에 신규·변경 클래스, 메서드, 인터페이스, enum, 예외가 있다.

**New or Changed Methods in Existing Classes — `Column` 클래스**

Apex Connector Framework를 사용해 더 많은 외부 데이터 타입을 Salesforce 외부 객체에 매핑한다. `DataSource.Table`에 새 컬럼을 생성하기 위한 `Column` 클래스의 새 메서드:

- `multipicklist(name, picklistValues, isPicklistAlphabeticallySorted, isPicklistRestricted)`
- `multipicklist(name, picklistValues)`
- `picklist(name, picklistValues, isPicklistAlphabeticallySorted, isPicklistRestricted)`
- `picklist(name, picklistValues)`
- `time(name)`

Salesforce 외부 객체 필드에 대한 더 많은 정보를 얻기 위한 `Column` 클래스의 새 `get` 메서드:

- `get(name, label, description, isSortable, isFilterable, type, length, decimalPlaces, referenceTo, referenceTargetField, picklistValuesObj, isPicklistAlphabeticallySorted, isPicklistRestricted)`

**New Properties — `Column` 클래스**

데이터 테이블의 picklist·multi-select picklist 컬럼 정보를 조회하기 위한 새 프로퍼티:

- `isPicklistAlphabeticallySorted`
- `isPicklistRestricted`
- `picklistValues`

**Changed Enums**

- **`DataType` enum** — Apex Connector Framework가 지원하는 새 데이터 타입을 지정하는 새 값: `PICKLIST_MULTISELECT_TYPE`, `PICKLIST_TYPE`, `TIME_TYPE`.
- **`Capability` enum** — 외부 시스템이 데이터 테이블의 picklist·multi-select picklist 필드를 지원하는지 지정하는 새 값: `MULTI_PICKLIST`, `PICKLIST`.

### fsccashflow Namespace

fsccashflow 네임스페이스에 새 클래스가 있다.

**New Class**

- **`FSCCashFlowUtil`** — action과 해당 인수를 전달하여 party income·expense 엔티티의 데이터를 관리·검증한다.

### Sfdc_Enablement Namespace

Sfdc_enablement 네임스페이스에 신규·변경 클래스, 메서드, 인터페이스, enum, 예외가 있다.

**New and Changed Classes**

- **`LearningEvaluation`, `LearningEvaluationResult`, `LearningItemEvaluationHandler`** — Enablement program의 learning item에 대한 사용자 진행도를 추적한다.
- **`LearningItemSerializeDeserializer`** (클래스 메서드) — Enablement program을 마이그레이션할 때 커스텀 exercise에 연결된 콘텐츠를 직렬화·역직렬화한다.

**New Enums**

- **`LearningItemProgressStatus`** — learning item에 대한 사용자의 진행 상태(progress status)를 지정한다.

### CommerceOrders Namespace

CommerceOrders 네임스페이스에 새 enum이 있다.

**New Enum**

- **`CatalogRatesPreferenceEnum`** — 카탈로그에 정의된 rate card entry를 order item에 대해 가져와야 하는지 지정한다. `PlaceOrderExecutor` 클래스 메서드에서 사용한다.

### industriesNlpSvc Namespace

industriesNlpSvc 네임스페이스에 새 클래스 2개가 있다.

**New Classes**

- **`NlpResponse` 클래스의 새 `summarizationResult` 필드** — `SurveyLongSummarization`, `SurveyShortSummarization` 같은 요약 유스케이스를 포함하는 NLP Operation에 대해 수행된 NLP Summarization 결과를 저장한다.
- **`NlpSummarizationResult` 클래스의 새 `summary` 필드** — NLP Operation 결과로 얻은 summary를 가져온다.

### PlaceQuote Namespace

PlaceQuote 네임스페이스에 새 enum이 있다.

**New Enum**

- **`CatalogRatesPreferenceEnum`** — 카탈로그에 정의된 rate card entry를 quote line item에 대해 가져와야 하는지 지정한다. `PlaceQuoteRLMApexProcessor` 클래스 메서드에서 사용한다.

---

## LWC 신규 / 변경 (컴포넌트 · 모듈 · 타깃 · Aura)

> LWC API 버전 62.0은 HTML 클래스 바인딩 지원, `this.style`로 컴포넌트 host `CSSStyleDeclaration` 객체 접근, `this.hostElement`로 부모 요소 접근을 제공한다. LWS에서 컴포넌트를 디버그하고 특정 distortion을 off/on으로 전환해 동작 차이를 관찰한다. LWS 자동 활성화는 무기한 연기된다.

### LWC API Version 62.0

최신 수정·개선을 받으려면 컴포넌트 API 버전을 **한 번에 한 버전씩** 업그레이드하는 것을 권장한다. 예: 58.0 → 59.0으로 올리고, 발생하는 에러·경고를 수정한 뒤 최신 API 버전에 도달할 때까지 반복한다. LWC API 버전 58.0 이하를 사용하는 컴포넌트는 Summer '23의 LWC framework 동작을 기준으로 계속 작동한다. 컴포넌트의 API 버전은 `.js-meta.xml` 파일에서 업데이트한다.

#### Manage Styles with Class Object Binding

LWC API 버전 **62.0 이상**에서, JavaScript 배열 또는 객체로 요소에 여러 클래스를 제공할 수 있다. 클래스 객체 바인딩을 사용하면 여러 클래스를 전달하기 위해 문자열을 연결할 필요가 없다.

**Where:** Lightning Experience, Experience Builder 사이트, 모든 버전의 Salesforce 모바일 앱의 커스텀 LWC에 적용. 오픈소스 LWC에도 적용.

**How:** 여러 프로퍼티를 가진 객체를 평가하는 버튼이 있다고 하자. 그 프로퍼티들이 어떤 클래스가 렌더링될지 결정한다.

```html
<!-- (PDF 발췌, 11417) -->
<button onclick={doSomething} class={computedClassNames}>Submit</button>
```

여러 클래스로 작업하려면 배열 또는 객체를 `class` 속성에 전달한다. 예:

```javascript
// (PDF 발췌, 11420–11438)
import { LightningElement } from 'lwc';
export default class extends LightningElement {
variant = null;
position = "left";
fullWidth = true;
disabled = false;
// Class binding with an object
get computedClassNames() {
return [
"button__icon",
this.variant && `button_${this.variant}`,
this.position && `button_${this.position}`,
{
"button_full-width": this.fullWidth,
"button_disabled": this.disabled,
},
];
}
}
```

LWC API 버전 **62.0 이상**에서, 요소는 다음과 같이 렌더링된다.

```html
<!-- (PDF 발췌, 11441) -->
<button class="button__icon button_left button_full-width">Submit</button>
```

LWC API 버전 **61.0 이하**에서는 다르게 렌더링된다(렌더 아티팩트 그대로 보존).

```html
<!-- (PDF 발췌, 11444) — v61.0 이하 렌더 아티팩트 -->
<button class="button__icon,,button_left,[object Object]">Submit</button>
```

클래스 객체 바인딩 변경의 영향을 고려한다.

- Boolean, number, function은 문자열로 변환되지 않고 **제거**된다.
- 배열과 객체는 더 이상 문자열로 변환되지 않는다.

`class` 속성이 string, null, undefined를 렌더링하면 변경 사항이 없다. 예를 보자.

```html
<!-- (PDF 발췌, 11458–11460) -->
<template>
<div class={myClass}></div>
</template>
```

LWC API 버전 **62.0 이상**에서, `myClass`가 `false`, `true`, 또는 숫자로 평가되면 템플릿은 다음과 같이 렌더링된다.

```html
<!-- (PDF 발췌, 11463) -->
<div class=""></div>
```

LWC API 버전 **61.0 이하**에서는 값을 문자열로 변환한다(렌더 아티팩트 그대로 보존).

```html
<!-- (PDF 발췌, 11466–11469) — v61.0 이하 렌더 아티팩트 -->
<!--LWC API version 61.0 and earlier-->
<div class="false"></div>
<div class="true"></div>
<div class="1"></div>
```

LWC API 버전 **62.0 이상**에서, 배열과 객체는 클래스 객체 바인딩 의미론(semantics)을 따른다. 이전 버전에서는 문자열로 변환되었다. `{myClass}`가 배열 `["highlight", "yellow"]`를 평가하면, 요소는 `class="highlight,yellow"` 대신 `class="highlight yellow"`를 렌더링한다. 마찬가지로 `{myClass}`가 객체 `{ highlight: true, yellow: false }`를 평가하면, 요소는 `class="[object Object]"` 대신 `class="highlight"`를 렌더링한다.

#### Access the Parent Element on a Component

LWC API 버전 **62.0 이상**에서, `renderedCallback` 또는 다른 콜백에서 `this.hostElement`를 사용해 부모 요소에 접근한다.

**Where:** Lightning Experience, Experience Builder 사이트, 모든 버전의 Salesforce 모바일 앱의 커스텀 LWC에 적용. 오픈소스 LWC에도 적용.

**How:** `this.hostElement`를 사용하면 `HTMLElement` 클래스의 프로퍼티를 조회할 수 있다.

```javascript
// (PDF 발췌, 11486–11494)
// c-light
import { LightningElement } from "lwc";
export default class extends LightningElement {
static renderMode = "light"; // default is 'shadow'
renderedCallback() {
console.log(this.hostElement); // logs <c-light>
console.log(this.hostElement.tagName); // logs C-LIGHT
}
}
```

light DOM에서 `this.template.host`는 `undefined`를 반환한다. shadow DOM에서 `this.hostElement`는 `this.template.host`와 상호 교환 가능하다.

> Note: `this.hostElement`를 사용했고 그 초기 `undefined` 값에 의존했다면, LWC API 버전 62.0으로 업그레이드 시 코드 변경이 필요하다. 이제 `this.hostElement` 프로퍼티는 더 이상 `undefined`가 아니며 초기에 truthy 값이다. `this.hostElement` 프로퍼티의 이름을 예를 들어 `this.myHostElement`로 변경하는 것을 권장한다. 또는 값을 할당하기 전에 `hostElement`를 `undefined`로 설정한다.

#### Access the Component's Style Information

LWC API 버전 **62.0 이상**에서, `this.style`을 사용해 컴포넌트의 host `CSSStyleDeclaration` 객체에 접근한다. `this.style`로 런타임에 컴포넌트 스타일을 쉽게 변경할 수 있다.

**Where:** Lightning Experience, Experience Builder 사이트, 모든 버전의 Salesforce 모바일 앱의 커스텀 LWC에 적용. 오픈소스 LWC에도 적용.

**How:** `this.style`로 컴포넌트의 스타일 정보에 접근한다.

```javascript
// (PDF 발췌, 11518–11520)
renderedCallback() {
this.style.color = 'red';
}
```

`this.style`을 사용하면 `CSSStyleDeclaration` 클래스의 메서드도 사용할 수 있다.

```javascript
// (PDF 발췌, 11523–11531) — 원본의 smart-quote 오타 'border' 그대로 보존
import { LightningElement } from "lwc";
export default class extends LightningElement {
static renderMode = "light"; // default is 'shadow'
setStyle() {
this.style.setProperty('color', 'red');
this.style.setProperty(’border', '1px solid eee');
console.log(this.style.color); // logs "red"
}
}
```

LWC API 버전 **61.0 이하**에서, `this.style`은 light DOM에서 `undefined`를 반환하며 `this.children[0].parentElement.style`을 대안으로 사용할 수 있다. shadow DOM에서는 `this.template.host.style`과 `this.style`을 상호 교환 가능하게 사용할 수 있다.

> Note: `this.style`을 사용했고 그 초기 `undefined` 값에 의존했다면, LWC API 버전 62.0으로 업그레이드 시 코드 변경이 필요하다. 이제 `this.style` 프로퍼티는 더 이상 `undefined`가 아니며 초기에 truthy 값이다. `this.style` 프로퍼티의 이름을 예를 들어 `this.customStyle`로 변경하는 것을 권장한다. 또는 값을 할당하기 전에 `style`을 `undefined`로 설정한다.

#### Stricter ESLint Rules for Imports and Exports

LWC API 버전 **62.0 이상**에서, 유효한 import·export를 가진 컴포넌트만 org에 배포할 수 있다. "invalid import" 또는 "invalid export" 에러를 받으면 배포 전 import·export를 확인한다.

**Where:** Lightning Experience, Experience Builder 사이트, 모든 버전의 Salesforce 모바일 앱의 커스텀 LWC에 적용.

**Why:** 더 엄격한 규칙은 이 ESLint 규칙들의 의도(개발자가 `lwc` 패키지에서 internal·private API를 import하는 것을 방지)에 더 잘 부합한다. 이전에는 개발자가 이 제한들의 잘못된 동작에 의존할 수 있었다.

**How:** LWC API 버전 62.0 이상에서, 다음 import 문은 더 이상 유효하지 않다.

```javascript
// (PDF 발췌, 11558–11562)
// Don't do this
import 'lwc';
export * as lwc from 'lwc';
export {} from 'lwc';
export { privateFunction } from 'lwc';
```

다음 가이드라인을 고려한다.

- `lwc`에 bare import는 허용되지 않는다. `import { LightningElement } from 'lwc'` 같은 named import를 사용한다.
- `lwc`에서 export는 허용되지 않는다.
- `lwc`에 bare export는 허용되지 않는다. `export { LightningElement } from 'lwc'` 같은 named export를 사용한다.

#### Create Components with Larger JavaScript File Sizes

LWC JavaScript 파일의 최대 파일 크기가 이제 **1 MB (1,000,000 bytes)** 이다. 이전 파일 크기 한도는 128 KB (131,072 bytes)였다.

**Where:** Lightning Experience, Experience Builder 사이트, 모든 버전의 Salesforce 모바일 앱의 커스텀 LWC에 적용.

#### Improve Accessibility with Base Lightning Components

베이스 Lightning 컴포넌트를 사용해 사용자 접근성 요구사항 충족을 돕는다. 여러 릴리즈에 걸쳐 Web Content Accessibility Guidelines(WCAG)를 충족하도록 컴포넌트를 업데이트해왔다. 접근성 업데이트를 받은 최신 컴포넌트는 **`lightning-input`**과 **`lightning-modal`**이다.

**Where:** 모든 에디션의 Lightning Experience와 모든 버전의 모바일 앱에 적용.

**How:**

- `lightning-input` 컴포넌트는 이제 input 타입 `date`·`datetime`에 대해 텍스트 입력 필드 아래에 예상되는 날짜 형식을 표시한다. 이전에는 잘못 입력 시 에러 메시지로만 형식을 알렸다.
- `lightning-modal` 컴포넌트는 이제 X 닫기 버튼을 흰색 배경으로 표시한다(이전에는 투명). `slds-button_icon-inverse` 클래스가 더 이상 닫기 아이콘에 적용되지 않는다.

#### Lightning Web Security Enablement Rollout Remains Postponed

Spring '22부터 일부 고객 org에서 LWS를 활성화하기 시작했다. 고도로 커스터마이즈된 환경의 고객 혼란을 최소화하기 위해 자동 활성화를 **무기한 연기**한다. 향후 LWS 활성화를 재개하면 릴리즈 노트로 발표한다.

**Where:** 모든 에디션의 Lightning Experience에 적용.

#### Gain Insight into Component Code by Switching LWS Distortions Off and On

LWS에서 컴포넌트를 디버그하고 특정 distortion을 off/on으로 전환해 동작 차이를 관찰한다. distortion을 일시적으로 비활성화하려면 브라우저에서 컴포넌트가 실행 중인 페이지를 열고 브라우저 개발자 콘솔에서 flag를 설정하는 명령을 입력한다.

**Where:** debug mode가 활성화된 경우 모든 에디션의 Lightning Experience에 적용.

**How:** org에서 debug mode를 활성화한다. 브라우저에서 컴포넌트·애플리케이션을 로드·실행한 뒤 개발자 도구 콘솔을 열고 코드에 breakpoint를 설정하거나 `debugger` 문을 추가한다. `c` 기본 네임스페이스에서 distortion을 비활성화·활성화하는 데 사용하는 flag를 나열하려면 브라우저 개발자 콘솔에 다음 명령을 입력하고 Enter를 누른다.

```javascript
// (PDF 발췌, 11621)
$LWS.namespaces.c.distortions
```

나열된 distortion 중 하나를 비활성화하려면 관련 flag를 `false`로 설정한다. 예를 들어 `XMLHttpRequest` API의 distortion을 비활성화하려면 다음 명령을 입력하고 Enter를 누른다.

```javascript
// (PDF 발췌, 11625)
$LWS.namespaces.c.distortions.xhr = false
```

개발자 콘솔의 Sources 뷰에서 debugger 패널을 사용해 지정한 LWS distortion이 비활성화된 채 실행되는 컴포넌트를 관찰한다. 현재 세션에서 distortion을 다시 활성화하려면 flag를 `true`로 설정한다. 또한 페이지를 새로고침하면 모든 flag가 `true`로 리셋된다.

#### API Distortion Changes in Lightning Web Security

LWS는 web API에 대한 추가 distortion으로 새 보안 보호를 포함한다. distortion에 매칭되는 ESLint 규칙도 제공된다.

**Where:** LWS가 활성화된 경우, 모든 에디션의 Lightning Experience, LWR 기반 Experience Cloud 사이트, Aura 사이트의 LWC에 적용.

**How:** 다음 API에 LWS Distortion Viewer에 문서화된 새 distortion이 있다. 대응되는 ESLint 규칙은 ESLint 패키지에 포함된다.

- `DataTransfer.moz*` (Firefox 전용 API)
- `Document.prototype.parseHTMLUnsafe`
- `Element.prototype.setHTMLUnsafe`

#### Develop Lightning Web Components with TypeScript (Developer Preview)

개발자 생산성·코드 품질 향상을 위해, 이제 TypeScript로 새 LWC를 작성할 수 있다. 기존 JavaScript 컴포넌트를 TypeScript로 변환할 수도 있다. 이전에는 LWC 프로젝트가 JavaScript 컴포넌트만 지원했다.

**Where:** 모든 에디션의 Lightning Experience와 모든 버전의 모바일 앱에 적용.

> Note: LWC의 TypeScript 지원은 developer preview로 제공된다. Salesforce가 문서·보도자료·공식 발표로 GA를 알리기 전까지는 GA가 아니다.

**How:** LWC 프로젝트에 TypeScript 지원을 구성하려면 TypeScript v5.4.5 이상을 설치하고, 프로젝트에 `tsconfig.json` 파일이 있는지 확인한다. 그 파일의 `compilerOptions` 섹션에서 `target`을 `"ESNext"`로 설정한다. 그리고 `experimentalDecorators` 컴파일러 옵션이 unset이거나 `false`로 설정되어 있는지 확인한다. LWC 모듈 해석은 TypeScript 모듈 해석과 다르게 동작하므로 `paths` 컴파일러 옵션을 구성해야 한다. 프로젝트에서 사용하는 모든 LWC 모듈에 대해, 각 모듈을 파일에 매핑하는 레코드가 `paths` 설정에 있어야 한다. Salesforce DX 프로젝트에서 작업한다면 VS Code용 Lightning Language Server 확장이 이 단계를 자동 처리한다.

#### Develop Lightning Web Components Faster in a Real-Time Preview (Beta)

**Local Dev (beta)**로, Lightning 앱 또는 Experience Cloud LWR 사이트의 실시간 프리뷰에서 LWC를 개발할 수 있다. Local Dev가 소스 코드 변경을 감지할 때마다 프리뷰가 브라우저에서 자동 업데이트되므로, 코드 배포나 수동 새로고침 없이 LWC를 더 빠르게 반복할 수 있다. 제한된 테스트·프리뷰 기능을 가진 LWC Local Development Server가 결국 deprecate되기 전에 새 Local Dev 경험으로 마이그레이션한다.

**Where:** 모든 에디션의 Lightning Experience와 모든 버전의 모바일 앱에 적용.

**Who:** Local Dev는 **Winter '25 sandbox org** 사용자에게만 open beta로 제공되며 기본적으로 off다.

**How:** org에 Local Dev를 켜려면 Setup의 Quick Find 박스에 `Local Dev`를 입력하고 Local Dev를 선택한다. **Enable Local Dev (Beta)**를 선택해 모든 org 사용자에게 켠다. 현재 이 기능은 CLI에서만 사용할 수 있다. 컴포넌트·페이지 테스트 전에 Salesforce CLI를 설치한다.

#### Be Aware of Base Lightning Component Internal DOM Structure Changes for Future Native Shadow Support

Salesforce는 성능 향상과 Web Components 표준 준수를 위해 베이스 Lightning 컴포넌트가 native shadow DOM을 채택하도록 준비하고 있다. 이 업데이트는 internal DOM 구조를 변경한다. 테스트가 이 컴포넌트들의 이전 internal 구조에 의존하지 않도록 한다.

**Where:** 모든 에디션의 Lightning Experience와 모든 버전의 모바일 앱에 적용.

**Why:** Spring '23 릴리즈 이후 71개 컴포넌트가 native shadow DOM 준비를 위해 적응되었다(Summer '24 릴리즈 노트에서 발표). Winter '25에서 다음 추가 컴포넌트가 native shadow DOM 준비를 위해 적응되었다.

- `lightning-checkbox-group`
- `lightning-map`
- `lightning-progress-indicator`
- `lightning-progress-step`
- `lightning-relative-date-time`
- `lightning-slider`
- `lightning-tile`
- `lightning-tree`

> Important: 테스트가 이 보호된 internal DOM 구조에 의존한다면 가능한 한 빨리 테스트를 다시 작성한다.

**How:** internal DOM 구조 변경에 대비하려면 integration 테스트와 selenium 기반 테스트를 검토한다. 지원되는 integration 테스트에는 UI Test Automation Model(UTAM)과 UTAM Page Objects를 사용한다.

#### Scan Barcodes with Inverted Colors

`BarcodeScanner` LWC가 색 반전(inverted colors) 바코드 스캔을 지원하도록 업데이트되었다.

**Where:** Salesforce Mobile과 Field Service Mobile 앱에 적용.

**How:** `BarcodeScannerOptions` 객체에 `supportInvertedColors`가 추가되어, 표준 black-on-white 대신 white-on-black 바코드를 스캔할 수 있다.

### New and Changed Lightning Web Components

> 다음 컴포넌트가 변경되었다.

#### `lightning-datatable`

**Changed behavior**

- 인라인 편집 중 validation 에러가 datatable 전체가 아니라 cell 자체에 표시된다.
- row-level 에러 메시지 추가에 사용되는 `fieldNames` 프로퍼티가 이제 cell 아래에 표시되는 커스텀 에러 메시지를 지원한다. 표준 validation 에러 메시지를 오버라이드할 수 있다.

**New attribute**

- **`single-row-selection-mode`** — 선택 컬럼에 체크박스 또는 라디오 버튼을 렌더링할지 지정한다. `max-row-selection="1"`로 한 행 선택으로 제한할 때만 사용한다. 유효 값: `radio`, `checkbox`. 기본값: `radio`.

**Changed attribute**

- **`wrap-table-header`** — 이제 boolean이 아닌 string이다. 모든 테이블 헤더를 clip·wrap하는 것 외에, 개별 컬럼의 wrap·clip 설정에 따라 헤더를 wrap·clip할 수 있다. 허용 값: `all`, `none`, `by-column`. 기본값: `none`(모든 테이블 헤더를 clip).

#### `lightning-input`

**New behavior for `type="number"`**

- 입력이 숫자가 아닐 때 **`badNumericInput`** validity 에러가 발생한다. 기본 에러 메시지: "Enter a valid numeric value." `message-when-bad-input` 속성으로 기본 메시지를 오버라이드할 수 있다.

**New accessibility behavior (모든 input 타입, `type="datetime"`·`type="time"` 제외)**

- validity 에러 발생 시, input label이 이제 에러 메시지 바로 앞에 hidden assistive text로 추가된다.

**New accessibility behavior (`type="date"` 및 `type="datetime"`의 date 필드)**

- date 필드가 포커스를 받으면 예상되는 날짜 형식을 보여주는 메시지가 필드 아래 인라인으로 표시된다. 표시되는 형식은 사용자 locale과 `date-style` 속성 기반이다.
  - `date-style="medium"` (기본) — `Format: Dec 31, 2024`
  - `date-style="short"` — `Format: 12/31/2024`
  - `date-style="long"` — `Format: December 31, 2024`
- date 필드에서 포커스가 제거되면 메시지가 숨겨지고 assistive text로 제공된다.

**Changed accessibility behavior (`type="date"` 및 `type="datetime"`의 date 필드)**

- `valueMissing`에 대한 에러 메시지가 이제 예상되는 날짜 형식을 포함한다. 형식은 사용자 locale과 `date-style` 속성에 대응한다. 예: "Complete this field with format Dec 31, 2024."
- 모든 커스텀 에러 메시지에 이제 예상 날짜 형식이 괄호로 부가된다. 예: "This is a custom message (Use format Dec 31, 2024)".

#### `lightning-record-form`

**Changed behavior**

- 이제 Salesforce Event 객체를 요청할 수 있으나, `Event.IsRecurrence`, `Event.IsRecurrence2`, `Event.IsReminderSet`는 렌더링되지 않는다.

#### `lightning-record-edit-form`

**Changed behavior**

- 이제 Salesforce Event 객체를 요청할 수 있으나, `Event.IsRecurrence`, `Event.IsRecurrence2`, `Event.IsReminderSet`는 렌더링되지 않는다.

#### `lightning-record-picker`

`matching-info` 객체의 `primaryField`·`additionalFields` 프로퍼티가 이제 `mode` 프로퍼티를 지원한다. matching mode를 지정하면 org 내 대규모 데이터셋 검색 시 성능 문제 해결에 유용하다. `mode`를 다음 중 하나로 설정한다.

- **`contains`** — (기본) 검색어를 포함하는 결과를 매칭한다.
- **`startsWith`** — 검색어로 시작하는 결과를 매칭한다. 검색 범위를 좁혀 성능을 개선하려면 이 옵션을 사용한다.

#### `lightning-modal`

**Changed accessibility behavior**

- 닫기 아이콘이 이제 WCAG 2.1의 비텍스트 대비 비율 요구사항 준수를 위해 흰색 배경 fill을 가진다. `slds-button_icon-inverse` 클래스가 더 이상 닫기 아이콘에 적용되지 않는다.

#### `lightning-record-view-form`

**Changed behavior**

- 이제 Salesforce Event 객체를 요청할 수 있으나, `Event.IsRecurrence`, `Event.IsRecurrence2`, `Event.IsReminderSet`는 렌더링되지 않는다.

### New and Changed Modules for Lightning Web Components

#### New Modules

- **`lightning/uiLayoutApi`** — 새 함수 `getLayout`: 하나 이상의 레코드에 대한 UI를 빌드하기 위한 layout 정보, 메타데이터, 데이터를 가져온다.
- **`lightning/uiLearningPlatformApi`** — 새 wire adapter `evaluateLearningItem`: Enablement program에서 커스텀 exercise 완료 기준이 충족되었는지 확인한다.

#### Changed Modules

- **`lightning/uiGraphQLApi`** — GraphQL wire adapter가 이제 Experience Cloud 사이트에서 지원된다.
- **`lightning/uiListsApi`** — 다음 새 wire adapter를 포함한다.
  - `createListInfo` — 객체에 연결된 list view를 생성한다.
  - `deleteListInfo` — list view를 삭제한다.
  - `getListInfosByObjectName` — 객체에 연결된 list view들을 가져온다.
  - `getListObjectInfo` — list view 객체의 메타데이터를 가져온다.
  - `getListPreferences` — list view의 preference를 가져온다.
  - `getListRecordsByName` — list view의 레코드 데이터를 가져온다.
  - `updateListInfoByName` — list view의 메타데이터를 업데이트한다.
  - `updateListPreferences` — list view의 preference를 업데이트한다.
- **`experience/cmsDeliveryApi`** — 새 wire adapter `getContents`: Experience Cloud의 enhanced LWR 사이트용 enhanced CMS workspace에서 게시된 콘텐츠 목록을 조회한다.

### New and Changed Targets for Lightning Web Components

#### New Targets

- **`lightning__ECSFSApp`** — 컴포넌트를 Field Service Mobile App Builder에서 사용할 수 있게 한다.
- **`lightning__EnablementProgram`** — 컴포넌트를 Program Builder에서 Enablement program의 커스텀 exercise 타입으로 사용할 수 있게 한다.

### New and Changed Aura Components

> 다음 컴포넌트가 변경되었다. (LWC의 kebab-case 대응 Aura 컴포넌트)

#### `lightning:datatable`

**Changed behavior**

- 인라인 편집 중 validation 에러가 datatable 전체가 아니라 cell 자체에 표시된다.
- `fieldNames` 프로퍼티가 이제 cell 아래에 표시되는 커스텀 에러 메시지를 지원한다. 표준 validation 에러 메시지를 오버라이드할 수 있다.

**New attribute**

- **`singleRowSelectionMode`** — 선택 컬럼에 체크박스 또는 라디오 버튼을 렌더링할지 지정한다. `maxRowSelection="1"`로 한 행 선택으로 제한할 때만 사용한다. 유효 값: `radio`, `checkbox`. 기본값: `radio`.

**Changed attribute**

- **`wrapTableHeader`** — 이제 boolean이 아닌 string이다. 개별 컬럼의 wrap·clip 설정에 따라 헤더를 wrap·clip할 수 있다. 허용 값: `all`, `none`, `by-column`. 기본값: `none`.

#### `lightning:input`

**New behavior for `type="number"`**

- 입력이 숫자가 아닐 때 **`badNumericInput`** validity 에러가 발생한다. 기본 메시지: "Enter a valid numeric value." `messageWhenBadInput` 속성으로 오버라이드한다.

**New accessibility behavior (모든 input 타입, `type="datetime"`·`type="time"` 제외)**

- validity 에러 발생 시, input label이 에러 메시지 바로 앞에 hidden assistive text로 추가된다.

**New accessibility behavior (`type="date"` 및 `type="datetime"`의 date 필드)**

- date 필드 포커스 시 예상 날짜 형식 메시지가 인라인으로 표시된다. 형식은 사용자 locale과 `dateStyle` 속성 기반이다.
  - `dateStyle="medium"` (기본) — `Format: Dec 31, 2024`
  - `dateStyle="short"` — `Format: 12/31/2024`
  - `dateStyle="long"` — `Format: December 31, 2024`
- 포커스 제거 시 메시지가 숨겨지고 assistive text로 제공된다.

**Changed accessibility behavior (`type="date"` 및 `type="datetime"`의 date 필드)**

- `valueMissing` 에러 메시지가 예상 날짜 형식을 포함한다. 형식은 사용자 locale과 `dateStyle` 속성에 대응한다. 예: "Complete this field with format Dec 31, 2024."
- 모든 커스텀 에러 메시지에 예상 날짜 형식이 괄호로 부가된다. 예: "This is a custom message (Use format Dec 31, 2024)".

#### `lightning:recordEditForm`

**Changed behavior**

- 이제 Salesforce Event 객체를 요청할 수 있으나, `Event.IsRecurrence`, `Event.IsRecurrence2`, `Event.IsReminderSet`는 렌더링되지 않는다.

#### `lightning:recordForm`

**Changed behavior**

- 이제 Salesforce Event 객체를 요청할 수 있으나, `Event.IsRecurrence`, `Event.IsRecurrence2`, `Event.IsReminderSet`는 렌더링되지 않는다.

#### `lightning:recordViewForm`

**Changed behavior**

- 이제 Salesforce Event 객체를 요청할 수 있으나, `Event.IsRecurrence`, `Event.IsRecurrence2`, `Event.IsReminderSet`는 렌더링되지 않는다.

### Lightning Design System Component Blueprints Updates

SLDS 컴포넌트 blueprint·utility에 향상·버그 수정이 있다.

**Where:** SLDS와 Lightning Experience에 적용.

**How:**

- **datepickers** blueprint를 날짜 입력에 필요한 형식이 시각적으로 표시되도록 업데이트(접근성 향상·WCAG 충족).
- **datetime picker** blueprint를 날짜 입력에 필요한 형식이 시각적으로 표시되도록 업데이트(접근성 향상·WCAG 충족).
- **modals** blueprint를 닫기 버튼(X)에 흰색 배경을 표시하도록 업데이트(저시력 사용자 가시성 향상). 구체적으로 `slds-button_icon-inverse` 클래스를 제거해 닫기 버튼 색을 흰색에서 회색으로 변경.

> Note: modal 닫기 버튼을 올바르게 표시하려면 닫기 버튼 마크업에 `slds-button_icon-inverse` 클래스를 사용하지 않는다. button icon 또는 icon을 modal 닫기 버튼에 사용하면 inverse variant 대신 bare variant를 사용한다.

### Visualforce — Update References to Visualforce Pages Served on Salesforce.com

unmanaged Visualforce 페이지가 `salesforce.com` 도메인에서 서빙된다면, 하드코딩된 참조·링크·북마크·외부 통합을 업데이트한다. 브라우저가 third-party 쿠키를 차단할 때도 계속 접근 가능하도록, 모든 Visualforce 페이지는 `force.com` 도메인 또는 site 도메인에서 서빙된다.

**Where:** Contact Manager, Group, Professional, Enterprise, Performance, Unlimited, Developer 에디션의 Lightning Experience와 Salesforce Classic에 적용.

---

## New & Changed API (ConnectApi · REST/Metadata/Tooling/UI/Bulk · SOQL)

> My Domain URL에 정의한 CORS allowlist가 `api.salesforce.com` 도메인 API에도 적용된다. Salesforce Platform API 버전 21.0~30.0 폐기는 Summer '25로 연기된다.

### Update API Calls to Use Your My Domain Login URL

서비스 중단 방지를 위해, **2025년 6월 14일 전까지** API 호출의 인스턴스 포함 URL(instanced URL)을 My Domain 로그인 URL로 업데이트한다. instanced URL은 Salesforce 인스턴스를 포함한다(예: `https://ap2.salesforce.com`은 인스턴스 `ap2` 포함). org 마이그레이션·인스턴스 refresh로 인스턴스가 변경된 후, 이전 인스턴스를 포함하는 URL을 사용하는 API 트래픽은 더 이상 새 인스턴스로 라우팅되지 않는다. My Domain 로그인 URL은 항상 올바른 인스턴스를 사용한다.

**Where:** 모든 API 버전에 적용.
**When:** 잘못된 instanced URL을 사용하는 API 트래픽은 2025년 6월 14일에 작동을 멈춘다.

예: My Domain 로그인 URL이 `mycompany.my.salesforce.com`이고 API 호출이 `https://ap2.salesforce.com/services/Soap/class/DemoService`를 사용하면, `https://mycompany.my.salesforce.com/services/Soap/class/DemoService`로 업데이트한다.

### Benefit from Faster Metadata API Deployment Cancellations

field type 변경 같은 작업이 관여하면 Metadata API 배포 취소가 너무 오래 걸리는 경우가 있어, 이 긴 취소 시간을 단축하는 새 프레임워크를 구현했다.

**Where:** 모든 Salesforce 에디션에 적용.

### Service Protection Limit on Enqueued Apex Metadata API Deployments

서버의 모든 고객에 대한 서비스 기능·리소스를 보존하기 위해, 이제 **Apex Metadata API에서 한 번에 enqueue될 수 있는 배포 수를 제한**한다. 이전에는 한도가 없었다. 일상 운영에 영향을 주지 않도록 신중한 분석을 기반으로 한도를 설정했다. **이 한도는 Apex에서 발생하는 enqueued Metadata API 배포에만 적용된다.** Salesforce CLI, change set, packaging에서의 Metadata API 배포에는 영향을 주지 않는다.

> PDF 원문(11982–11986/12027–12031): "we now limit the number of deployments that can be enqueued at a time from Apex Metadata API... This limit applies only to enqueued Metadata API deployments that originate from Apex. It doesn't affect Metadata API deployments from Salesforce CLI, change sets, or packaging."

**Where:** 모든 Salesforce 에디션에 적용.

### Enforce the CORS Allowlist on More Salesforce APIs

My Domain URL에 노출된 API에 대해 정의한 CORS allowlist가 이제 `api.salesforce.com` 도메인에 노출된 API에도 적용된다.

**Where:** 모든 Salesforce 에디션에 적용.

### Salesforce Platform API Versions 21.0 Through 30.0 Retirement (Release Update)

Salesforce Platform API 버전 21.0~30.0 폐기는 처음에 Summer '23로 예정되었다. 이제 **Summer '25로 연기**된다. 이 API 버전을 계속 사용할 수 있으나 지원되지 않으며 Summer '25부터 사용 불가능해진다. 이를 소비하는 애플리케이션은 중단된다. 요청은 endpoint가 비활성화되었다는 에러 메시지와 함께 실패한다.

**Where:** 다음 API 버전에 영향을 준다.

- **Bulk API:** 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0
- **SOAP API:** 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0
- **REST API:** v21.0, v22.0, v23.0, v24.0, v25.0, v26.0, v27.0, v28.0, v29.0, v30.0

> Note: 이 변경은 `/services/data/vXX.X/` 아래의 URI를 사용하는 모든 REST API에 영향을 준다.
> - Bulk API
> - Connect REST API
> - IoT REST API
> - Lightning Platform REST API
> - Metadata API
> - Place Order REST API
> - Reports and Dashboards REST API
> - Tableau CRM REST API
> - Tooling API

Professional(API access 활성화), Enterprise, Performance, Unlimited, Developer 에디션에 적용. 이 변경은 sandbox와 scratch org를 포함한 모든 API-enabled org에 영향을 준다.

**How:** API Total Usage 이벤트를 사용해 SOAP API, REST API, Bulk API의 구형·미지원 버전에서 만들어진 요청을 식별한다. Setup의 Release Updates에서 "Salesforce Platform API Versions 21.0 Through 30.0 Retirement"를 찾아 **Get Started**를 클릭한다. 폐기 예정 API 버전 호출을 거부하려면 **Enable Test Run**, 강제를 해제하려면 **Disable Test Run**을 클릭한다.

### ConnectApi (Connect in Apex): New and Changed Classes and Enums

#### ConnectApi Rate Limit Changes

잠재적으로 제한적인 **per user, per namespace, per hour** ConnectApi rate limit을 피하기 위해, org를 **per org, per 24-hour** Salesforce Platform API rate limit으로 마이그레이션한다. Summer '24 이후 생성된 org는 이미 Salesforce Platform API rate limit을 사용한다. 마이그레이션된·신규 org에서는 Chatter가 필요한 메서드 호출만 per user, per namespace, per hour rate limit의 대상이다.

**Where:** 모든 API 버전, 모든 에디션의 Lightning Experience, Salesforce Classic, 모든 버전의 Salesforce 모바일 앱에 적용.
**When:** Salesforce Platform API rate limit으로의 org 마이그레이션은 Winter '25부터 rolling 방식으로 진행되며 알림 없이 백그라운드에서 발생한다.

#### New and Changed Connect in Apex Classes

**Commerce — `ConnectApi.CommerceCart` 클래스의 새 메서드**

- cart 계산 수행: `calculateCart(webstoreId, activeCartOrId, effectiveAccountId)`
  - New output class: `ConnectApi.CalculateCartResult`
  - New output class: `ConnectApi.CommerceResultRepresentationBase`

**Commerce — `ConnectApi.CommerceCatalogManagement` 클래스의 새 메서드**

- variation product 생성: `compositeCommerceVariationCreate(webstoreId, compositeCommerceVariationInputRepresentation)`
  - New input class: `ConnectApi.CompositeCommerceVariationInputRepresentation`
  - New output class: `ConnectApi.CompositeCommerceVariationOutputRepresentation`

**Einstein — `ConnectApi.EinsteinLlm` 클래스의 새 메서드**

- prompt template 목록 조회: `getPromptTemplates(query, sortBy, offset, pageLimit, fields, type, relatedEntity, isActive)`
  - New output class: `ConnectApi.EinsteinPromptRecordCollectionOutputRepresentation`

**Named Credentials — `ConnectApi.NamedCredentials` 클래스의 새 메서드**

external auth identity provider를 get/create/update/delete:

- `createExternalAuthIdentityProvider(requestBody)`
- `deleteExternalAuthIdentityProvider(fullName)`
- `getExternalAuthIdentityProvider(fullName)`
- `updateExternalAuthIdentityProvider(fullName, requestBody)`
  - New input class: `ConnectApi.ExternalAuthIdentityProviderInput`
  - New output class: `ConnectApi.ExternalAuthIdentityProvider`

org 내 external auth identity provider 목록 조회:

- `getExternalAuthIdentityProviders()`
  - New output class: `ConnectApi.ExternalAuthIdentityProviderList`

external auth identity provider credentials를 get/create/update:

- `createExternalAuthIdentityProviderCredentials(fullName, requestBody)`
- `getExternalAuthIdentityProviderCredentials(fullName)`
- `updateExternalAuthIdentityProviderCredentials(fullName, requestBody)`
  - New input class: `ConnectApi.ExternalAuthIdentityProviderCredentialsInput`
  - New output class: `ConnectApi.ExternalAuthIdentityProviderCredentials`

**Salesforce CMS — `ConnectApi.ManagedContent` 클래스의 변경 메서드**

- managed content delivery 채널 조회: `getAllDeliveryChannels(pageParam, pageSize)`
  - 이 메서드는 더 이상 사용할 수 없다. 대신 `ConnectApi.ManagedContentDelivery` 클래스의 `getChannels(pageParam, pageSize)`를 사용한다.

**Salesforce CMS — 새 `ConnectApi.ManagedContentChannels` 클래스의 새 메서드**

- managed content 채널 조회: `getManagedContentChannels(pageParam, pageSize, showDetails)`
  - New output class: `ConnectApi.ManagedContentChannelsRepresentation`
- managed content 채널 생성: `postManagedContentChannel(ManagedContentCreateInputParam)`
  - New input class: `ConnectApi.ManagedContentChannelCreateRepresentation`
- managed content 채널 조회: `getManagedContentChannel(channelId)`
- managed content 채널 업데이트: `patchManagedContentChannel(channelId, ManagedContentChannelInput)`
  - New input class: `ConnectApi.ManagedContentChannelUpdateRepresentation`
- managed content 채널 삭제: `deleteManagedContentChannel(channelId)`

**Salesforce CMS — `ConnectApi.ManagedContentDelivery` 클래스의 신규·변경 메서드**

- managed content delivery 채널 조회: `getChannels(pageParam, pageSize)`
  - New output class: `ConnectApi.ManagedContentDeliveryChannelsRepresentation`
- managed content delivery 채널 조회: `getManagedContentChannel(channelId)`
  - 이 메서드는 더 이상 사용할 수 없다. 대신 `getManagedContentDeliveryChannel(channelId)`를 사용한다.
- managed content delivery 채널 조회: `getManagedContentDeliveryChannel(channelId)`
  - New output class: `ConnectApi.ManagedContentDeliveryChannelRepresentation`

**Salesforce CMS — 새 `ConnectApi.ManagedContentSpaces` 클래스의 새 메서드**

- managed content space의 채널 조회: `getManagedContentSpaceChannels(contentSpaceId, pageParam, pageSize)`
  - New output class: `ConnectApi.ManagedContentSpaceChannelsRepresentation`
- managed content space의 채널 추가·제거: `patchManagedContentSpaceChannels(contentSpaceId, spaceChannels)`
  - New input class: `ConnectApi.ManagedContentSpaceChannelsInputRepresentation`
  - New output class: `ConnectApi.ManagedContentSpaceChannelsRepresentation`

#### Changed Connect in Apex Input Classes

**Einstein — `ConnectApi.EinsteinPromptTemplateGenerationsInput`**

- `citationMode` — 지정된 prompt template의 citation 모드. (새 프로퍼티)
- `outputLanguage` — LLM 응답을 생성할 언어의 language code. (버전 61.0 이상에서 사용 가능하나 이전에 미문서화)

#### Changed Connect in Apex Output Classes

**Einstein — `ConnectApi.EinsteinPromptTemplateGenerationsRepresentation`**

- `citations` — 생성된 응답에 연결된 source 정보(있는 경우). (새 프로퍼티)
- 다음 프로퍼티는 버전 61.0 이상에서 사용 가능하나 이전에 미문서화:
  - `generationErrors` — 생성된 응답에 연결된 에러 목록(있는 경우).
  - `isSummarized` — 생성된 응답에 요약 텍스트가 포함되는지 여부.
  - `requestMessages` — masked 데이터·masking 정보를 가진 resolved prompt template 목록.
  - `responseMessages` — 지정된 prompt template에 대한 masked 데이터·masking 정보를 가진 생성된 응답 목록.
  - `slotsMaskingInformation` — masked 데이터의 original·placeholder 값 목록.

**Commerce — `ConnectApi.AbstractCartItem`** (새 프로퍼티)

- `childProductCount` — item에 연결된 cart의 child product 수. item의 `productClass`가 `Bundle`이면 child product를 가질 수 있다. nested bundle(child product가 또한 bundle)의 경우 `childProductCount`는 모든 child product를 포함한다.
- `parentCartItemId` — item의 parent cart item ID. top-level cart item이면 값이 비어 있다.

**Commerce — `ConnectApi.CartItem`** (새 프로퍼티)

- `productClass` — product의 class.

**Commerce — `ConnectApi.OCIInventoryRecordOutputRepresentation`** (새 프로퍼티)

- `exists` — SKU가 inventory에 존재하는지 여부.

**Commerce — `ConnectApi.ProductChild`** (새 프로퍼티)

- `isEntitled` — child product를 product detail 페이지에서 볼 수 있는지(`true`) 여부(`false`).

**Experience Cloud Sites — `ConnectApi.Community`** (새 프로퍼티)

- `contentSpaceId` — enhanced 사이트에 연결된 managed content space의 ID.

**Flow Orchestration — Orchestration Work Item** (새 프로퍼티)

- `flowType` — orchestration work item을 생성한 orchestration의 flow type.

**Salesforce CMS — `ConnectApi.ManagedContentChannel`** (변경·신규 프로퍼티)

- `channelId` — 더 이상 반환되지 않음.
- `channelName` — 더 이상 반환되지 않음.
- `channelType` — 더 이상 반환되지 않음.
- `domain` — 더 이상 반환되지 않음.
- `domainName` — 더 이상 반환되지 않음.
- `id` — managed content channel의 ID.
- `isChannelSearchable` — 더 이상 반환되지 않음.
- `isDomainLocked` — 더 이상 반환되지 않음.
- `isSearchable` — 채널의 텍스트 콘텐츠가 검색 가능한지 여부.
- `managedContentChannelDomain` — 채널에 연결된 domain.
- `name` — managed content channel의 이름.
- `targetId` — managed content channel에 연결된 target의 ID.
- `type` — managed content channel의 type.

**Salesforce CMS — `ConnectApi.ManagedContentChannelSummary`** (변경·신규 프로퍼티)

- `domainUrl` — 더 이상 반환되지 않음.
- `id` — managed content channel의 ID.
- `resourceUrl` — 더 이상 반환되지 않음.
- `target` — 더 이상 반환되지 않음.
- `type` — managed content channel의 type.
- `url` — 채널 리소스 URL.

**Salesforce CMS — `ConnectApi.ManagedContentCollectionItems`** (변경·신규 프로퍼티)

- `channelInfo` — 더 이상 반환되지 않음. 대신 `channelSummary` 사용.
- `channelSummary` — managed content delivery channel의 요약 정보.

**Salesforce CMS — `ConnectApi.ManagedContentDeliveryDocument`** (변경·신규 프로퍼티)

- `channelInfo` — 더 이상 반환되지 않음. 대신 `channelSummary` 사용.
- `channelSummary` — managed content delivery channel의 요약 정보.

**Salesforce CMS — `ConnectApi.ManagedContentDeliveryDocumentCollection`** (변경·신규 프로퍼티)

- `channelInfo` — 더 이상 반환되지 않음. 대신 `channelSummary` 사용.
- `channelSummary` — managed content delivery channel의 요약 정보.

#### Changed Connect in Apex Enums

**`ConnectApi.ProductClass`** — 새 값:

- `Bundle` — product의 class가 bundle.
- `Set` — product의 class가 set.

### New and Changed Objects (API v62.0)

> 이 새·변경 standard object를 통해 더 많은 데이터에 접근한다.

**Salesforce Overall**

- person account·contact을 보고 대상(report to)인 다른 person account·contact에 연결: 기존 **Account** 객체의 새 `PersonReportsToId` 필드.

**Analytics**

- 멀티 컴포넌트 필드를 단일 컬럼으로 카운트한 리포트의 컬럼 수: 기존 **Report Event Type** 객체의 새 `UI_NUMBER_COLUMNS` 필드.

**Campaigns**

- 영향받은 opportunity와 관련된 campaign member ID: 기존 **CampaignInfluence** 객체의 새 `CampaignMemberId` 필드.
- 영향받은 opportunity와 관련된 contact의 role ID: 기존 **CampaignInfluence** 객체의 새 `OpportunityContactRoleId` 필드.

**Commerce**

- BEHAVIOR CHANGE: **ShippingConfigurationSet** 객체의 `TargetRecordId`가 더 이상 update를 지원하지 않음(Update 프로퍼티가 `false`로 변경).
- 조정을 유발하는 coupon 설정: 기존 **CartDeliveryGroupMethodAdj** 객체의 새 `AdjustmentBasisReferenceId` 필드(기본적으로 FLS로 숨김).
- tax 계산에 연결된 reference number: 기존 **OrderItemTaxLineItemSummary** 객체의 새 `CalculationReferenceNumber` 필드.
- tax transaction commit 요청에 연결된 reference number: 기존 **OrderItemTaxLineItemSummary** 객체의 새 `TransactionReferenceNumber` 필드.
- order 취소·반품 시 tax revert: 기존 **OrderItemTaxLineItemSummary** 객체의 새 `ReferenceNumber` 필드.
- delivery estimation setup 구성 생성: 새 **DeliveryEstimationSetup** 객체.
- shipping carrier method를 location group에 할당: 새 **LocationShippingCarrierMethod** 객체.
- delivery weight 기반 조건으로 shipping rate에 영향: 기존 **StandardShippingRate** 객체의 `ConditionFactor` 필드에 새 `OrderWeightFactor` 값.
- cart item의 weight 정보: 새 `WeightUnit` 필드(기존 **StandardShippingRate**), 새 `PerUnitWeight`·`TotalWeight`·`WeightUnit` 필드(기존 **CartItem**).
- 각 payment intent에 billing·shipping 주소 포함: **PaymentIntent** 객체의 새 `BillingAddress`·`ShippingAddress` 및 관련 address 필드.
- 분쟁(disputed) payment의 amount·fee·status 확인: **PaymentIntent** 객체의 새 `DisputeEvidenceDueDate`·`DisputeFee`·`DisputeStatus`·`DisputedAmount` 필드.
- 저장된 payment method의 bank account holder 타입: **SavedPaymentMethod** 객체의 새 `BankAccountHolderType` 필드.
- 저장된 payment method의 billing 주소: **SavedPaymentMethod** 객체의 새 `BillingAddress` 및 관련 address 필드.
- merchant가 고객 대신 payment를 시작했는지: **PaymentIntent** 객체의 새 `EntryMode`·`SubmittedById` 필드, **SavedPaymentMethod** 객체의 `IsMerchantCreated`.
- orphaned payment의 status: **PaymentIntent** 객체의 새 `IncurrenceStatus` 필드.
- ACH payment 방식·인증 code: **SavedPaymentMethod**·**AlternativePaymentMethod** 객체의 새 `StandardEntryClassCode` 필드.
- BEHAVIOR CHANGE: Commerce용 bundle을 만들 수 있는 product 생성 — **ProductRelatedComponent** 객체가 이제 Commerce bundle 생성을 지원. 기존 객체의 새 `DoesBundlePriceIncludeChild`·`QuantityScaleMethod`·`ParentProductRole`·`ChildProductRole`·`ProductRelationshipTypeId` 필드.
- cart item의 class: **CartItem** 객체의 새 `ProductClass` 필드.
- cart item의 parent·child product 정보: **CartItem** 객체의 새 `ChildProductCount`·`ParentCartItemId`·`ProductRelatedComponentId`·`ProductValidationKey` 필드.
- product 재고 수준 확인: **Product2** 객체의 새 `StockCheckMethod` 필드.
- cart item의 재고 수준: **CartItem** 객체의 새 `StockCheckMethod` 필드.

**Customization**

- public group·queue에 description 추가: 기존 **Group** 객체의 새 `Description` 필드.

**Data Kit**

- data kit 컴포넌트 배포 status 모니터링: **DataKitDeployEvent** 객체.
- data kit 컴포넌트 배포 세부 확인: **DataKitDeploymentLog** 객체.

**Development**

- platform event Apex trigger가 parallel subscription을 사용하는지 판단: 기존 **EventBusSubscriber** 객체의 새 `IsPartitioned` 필드.
- Lightning Platform 앱에서 Bitbucket에 연결: 기존 **AuthProvider** 객체의 기존 `providerType` 필드에 새 `Bitbucket` 값.

**Einstein**

- agent action·topic이 표준 action·topic의 편집 버전인지 판단: **GenAiFunctionDefinition**·**GenAiPluginDefinition** 객체의 새 `IsLocal` 필드.
- agent action·topic을 소유한 객체의 ID: **GenAiFunctionDefinition**·**GenAiPluginDefinition** 객체의 새 `ParentId` 필드.

**Event Monitoring**

- legacy hostname의 차단된 redirection 식별: **Hostname Redirects** 이벤트 타입의 `REDIRECT_REASON` 필드의 새 값 `Redirection was blocked because redirections for the legacy SOURCE_HOSTNAME are no longer supported.`.
- profile·permission set·permission set group의 권한 변경 모니터링: 새 **Permission Update** 이벤트 타입.

**Experience Cloud**

- enhanced CMS workspace에서 새 콘텐츠 생성 시 API Name 추가: 기존 **ManagedContent** 객체의 새 `ApiName` 필드.
- CMS 콘텐츠·content variant의 content type 정의: 기존 **ManagedContent**·**ManagedContentVariant** 객체의 새 `ContentTypeFullyQualifiedName` 필드.
- public 파일에 대한 검색 방지: 기존 **ContentDocument** 객체의 새 `IsInternalOnly` 필드.

**Field Service**

- 고객에게 quote 발송: **Document Recipient** 객체의 새 `QuoteDocumentId` 필드.
- mobile worker에게 다가오는 work order 브리핑 표시: **Work Order** 객체의 새 `Pre-Work Brief Prompt Template ID` 필드.
- 완료된 work order 요약: **Work Order** 객체의 새 `Post-Work Summary` 필드.
- platform alert 기반 geolocation 액션 설정: **Geolocation-Based Action** 객체의 `Action Type` 필드의 새 `Platform Alert` 값.

**Mobile**

- Offline App(beta)에서 파일 첨부 접근: 기존 **BriefcaseRule** 객체의 새 `OptionsIsRelatedFilesRule` 필드(Offline App / Salesforce Mobile App Plus 전용).

**Revenue**

- invoice batch run 처리 합계 추적: 기존 **InvoiceBatchRun** 객체의 새 `TotalDraftInvoiceAmount`·`TotalDraftInvoices`·`TotalPostedInvoices`·`TotBillSchdUpdtDurDrftToPost` 필드.

**Sales**

- 특정 시점의 forecast 캡처: 새 **ForecastingSubmission**·**ForecastingSubmissionItem** 객체.
- 모든 forecast manager에 대해 manager judgment 값 롤업: 새 **ForecastingCustomCategory** 객체.
- Enablement program용 커스텀 exercise 타입 생성: 새 **EnblProgramTaskSubCategory**·**LearningItemType** 객체, 기존 **EnblProgramTaskDefinition** 객체의 새 `CustomEnblPgmTaskSubCategoryId` 필드, 기존 `TaskSubCategory` 필드의 새 `CustomExercise` 값, 기존 **LearningItem** 객체의 새 `CustomLearningItemTypeId` 필드, 기존 `Type` 필드의 새 `CustomContent` 값.
- 2GP 관리 패키지로 Enablement program·종속성을 org 간 이동: 기존 **EnablementMeasureDefinition**·**EnablementProgramDefinition**·**EnblMeasureObjectDefinition** 객체의 새 `NamespacePrefix` 필드.
- BEHAVIOR CHANGE: **PromptVersion** 객체의 `Body` 필드가 모든 prompt 타입에 대해 최대 4,000자 허용(이전에는 floating·docked prompt에 240자만 허용, API 60.0에서 도입).
- Partner Connect를 통한 partner-vendor org 간 external record share export 추적: **ExtlRecShrCnct**·**ExtlRecShrCnctAccnt**·**ExtlRecShrField**·**ExtlRecShrFieldMap**·**ExtlRecShrLead**·**ExtlRecShrObject**·**ExtlRecShrOpportunity**·**ExtlRecShrPcklstOptn**·**ExtlRecShrRecordMap**·**ExtlRecShrPicklistMap**, 기존 **ObjectDataImport** 객체의 `Type` 필드의 새 `External Record Import` 값, **Lead**·**Opportunity** 객체의 `ExportStatus` 필드.
- account plan 생성·관리: 새 **AccountPlan**·**AccountPlanObjective**·**AccountPlanObjectiveMeasure** 객체.
- Opportunity Split·Opportunity Product Split의 Territory Assignment 추적: **OpportunitySplit**·**OpportunityLineItemSplit** 객체의 새 `ArchivedTerritoryName`·`Territory2Id` 필드(API 62.0 이상).
- account·contact relation 변경 이력 조회: **AccountContactRelation** 객체의 새 `AccountContactRelationHistory` associated 객체.
- territory 할당·해제 시점 상세 조회: 새 **UserTerritory2AssocLog** 객체(API 57.0 도입, 이번에 Object Reference에 추가).
- territory에 할당된 user·object 조회: 새 **ObjectUserTerritory2View** 객체(API 58.0 도입).
- action cadence·action cadence tracker의 share·owner sharing rule 조회: 새 **ActionCadenceOwnerSharingRule**·**ActionCadenceShare**·**ActionCadenceTrackerOwnerSharingRule**·**ActionCadenceTrackerShare** associated 객체(API 45.0 도입).
- action cadence tracker가 일시정지·wait step 이후 재개되는 시점 스케줄: **Contact**·**Lead** 객체의 새 `ScheduledResumeDateTime` 필드(API 54.0 도입).
- contact·lead에 연결된 action cadence의 ID·assignee·state 조회: **Contact**·**Lead** 객체의 새 `ActionCadenceAssigneeId`·`ActionCadenceId`·`ActionCadenceState` 필드(API 48.0·50.0 도입).
- contact·lead에서 실행 중인 cadence 수 추적: **Contact**·**Lead** 객체의 새 `ActiveTrackerCount` 필드(API 57.0 도입).
- duplicate rule의 last viewed date 조회: **DuplicateRule** 객체의 새 `LastViewedDate` 필드(API 41.0 도입).
- duplicate rule의 object subtype 지정: **DuplicateRule** 객체의 새 `SobjectSubtype` 필드(API 39.0 도입).
- list email의 monthly engagement metric 조회: 새 **ListEmailMonthlyMetric** 객체(API 49.0 도입).

**Salesforce Flow**

- orchestration definition 상세 조회: 새 **FlowOrchestration** 객체(API 62.0 이상).
- orchestration 버전 조회: 새 **FlowOrchestrationVersion** 객체(API 62.0 이상).
- step에서 호출한 action의 에러로 orchestration instance가 일시정지·실패했을 때 실행 중이던 stage의 API name 조회: 기존 **FlowOrchestrationInstance** 객체의 새 `CurrentStage` 필드.
- orchestration instance 시작부터 완료·취소·실패까지의 duration(초) 조회: 기존 **FlowOrchestrationInstance** 객체의 새 `Duration` 필드.
- orchestration instance를 트리거한 레코드 ID 조회: 기존 **FlowOrchestrationInstance** 객체의 새 `TriggeringRecordId` 필드.
- flow의 각 요소에 대한 analytics 조회: 새 **FlowRecordElementOccurence** 객체.
- flow의 사용 한도를 결정하는 category 조회: 기존 **FlowDefinitionView**·**FlowRecord**·**FlowRecordVersion**·**FlowVersionView** 객체의 새 `CapacityCategory` 필드.
- automation event를 flow trigger로 식별: 기존 **FlowDefinitionView** 객체의 `TriggerType` 필드의 새 `AutomationEvent` 값, 기존 **FlowRecord**·**FlowRecordVersion** 객체의 `FlowType` 필드의 새 `AutomationEventTrig` 값.

**Security and Identity**

- 외부 사용자 identity 검증용 커스텀 OTP provider delivery handler 구성(GA): 기존 **NetworkAuthApiSettings** 객체의 새 `CustomOtpDeliveryHandlerId` 필드.
- OAuth 2.0 authorization challenge endpoint를 사용하는 headless username-password 로그인 플로우에 reCAPTCHA 요구: 기존 **NetworkAuthApiSettings** 객체의 새 `DoesPasswordLoginRequireAuth` 필드.
- OAuth 2.0 authorization challenge endpoint로 headless username-password 로그인·passwordless 로그인·등록 활성화: 기존 **NetworkAuthApiSettings** 객체의 새 `isFirstPartyAppsAllowed` 필드.
- passwordless 로그인 중 사용자 조회용 headless user discovery Apex handler 구성: 기존 **NetworkAuthApiSettings** 객체의 새 `HeadlessDiscoveryHandlerId` 필드.
- headless user discovery Apex handler를 실행할 execution user 설정: 기존 **NetworkAuthApiSettings** 객체의 새 `HeadlessDiscoveryExecutionUserId` 필드.
- client configuration URL에 URL 파라미터를 동적으로 추가해 auth provider 기능 제어: 새 **AuthProvParamFwdAllowlist** 객체.
- TenantSecurityCustomMetricStat drill down 세부 저장: 새 **TenantSecurityCustomMetricDetail** 객체.
- Security Center 내 커스텀 metric 구성 저장: **TenantSecurityCustomMetricSetup** 객체.
- Security Center 내 커스텀 metric 데이터 저장: **TenantSecurityCustomMetricStat** 객체.
- standard object에 저장된 이벤트 데이터 노출: 새 event log 객체(beta) — **ContentTransferEventLog**·**MetadataApiOpEventLog**·**PackageInstallEventLog**·**SandboxStatusEventLog**·**SiteEventLog**.
- Database Encryption key material을 프로그래밍 방식으로 생성: 기존 **TenantSecret** 객체의 `Type` 필드의 새 `Database` 값.

**Service**

- enhanced messaging session의 agent·end user 응답 시간 추적: 새 **MessagingSessionMetrics** 객체.
- unified Messaging 채널을 여러 애플리케이션에 연결: 기존 **MessagingChannelUsage** 객체의 새 `MessagingChannel` 필드.
- Messaging 채널에 필요한 consent level 설정: 기존 **MessagingChannelUsage** 객체의 새 `ConsentType` picklist 필드.
- messaging end user에게 보낼 messaging 컴포넌트 지정: 기존 **ConvMessageSendRequest** 객체의 새 `MessageDefinition` 필드.
- messaging user에게 자동 전송할 messaging 컴포넌트 선택: 기존 **ConvMessageSendRequest** 객체의 새 `MessageDefinition` 필드.
- voicemail 구성의 routing 세부 지정 및 BYOC for CCaaS Messaging 채널을 contact center에 연결: **ContactCenterChannel** 객체(API 56.0 도입, 새 필드와 함께 추가).
- 커스텀 Messaging 채널 통합을 로고로 식별: 기존 **ConversationChannelDefinition** 객체의 `CustomIconId` 필드(API 61.0 도입).
- BYOC·BYOC for CCaaS의 커스텀 채널 파라미터 지원 표시: 기존 **ConversationChannelDefinition** 객체의 `CapabilitiesSupportsCustomChannelParameters` 필드(API 61.0 도입).
- BYOC의 connected app owner 지정: 기존 **ConversationChannelDefinition** 객체의 새 `ConnectedAppType` 필드.
- BYOC용 customer가 만든 connected app의 OAuth link 기록: 기존 **ConversationChannelDefinition** 객체의 새 `CustomerConnectedAppOauthLink` 필드.
- 커스텀 CCaaS·partner telephony 통합을 로고로 식별: 기존 **ConversationVendorInfo** 객체의 새 `CustomIconId` 필드.
- enhanced call type 분석 수행: 기존 **VoiceCall** 객체의 새 `callSubtype` 필드 및 기존 `CallerContactInfo`·`RecipientContactInfo` 필드(`ToPhoneNumber`→`CallerContactInfo`, `FromPhoneNumber`→`RecipientContactInfo`로 rename).
- survey 질문의 choice 수 조회: 기존 **SurveyQuestion** 객체의 새 `QuestionChoiceCount` 필드.
- 전화 통화 sentiment 분석: 기존 **VoiceCall** 객체의 새 `AgentSentimentScore`·`CustomerSentimentScore` 필드.

### New and Changed Data Model Objects (DMOs)

**Salesforce Flow**

- 스케줄로 실행되는 recurring flow의 instance 조회: 새 **Flow Version Occurrence** DMO.

### New and Changed Standard Platform Events

**Data Cloud**

- **SearchIndexJobStatusEvent** — Data Cloud search index job의 status 변경(index refresh status, index run-time status 등) 알림. Data Cloud가 활성화된 경우에만 사용 가능(API 60.0 도입, 이번에 Platform Events Developer Guide에 추가).

**Sales**

- Partner Connect를 통한 partner-vendor org 간 external record share export 추적: 새 **ExtlRecShrEvent**·**ExtlRecShrResultEvent** platform event.

### Bulk API (v62.0)

- **Bulk API Request Event** — Bulk API 요청 수신 시점을 나타내는 새 event log type. create job, update job, create batch, update batch, job 완료 요청 수신을 포함한다. 이전에는 Bulk API Event event log type만 batch 처리 시마다 1개의 이벤트를 캡처했다. 둘 중 하나 또는 둘 다를 사용해 Bulk API job을 모니터링한다.

### Bulk API 2.0 (v58.0)

- **`resultPages`** — query job 결과 여러 페이지를 병렬로 조회하는 새 resource. 이전에는 `results` resource를 직렬로만 사용해 결과를 조회할 수 있었다.

### Connect REST API

#### Connect REST API Rate Limit Changes

제한적인 **per user, per application, per hour** Connect REST API rate limit을 피하기 위해, org를 **per org, per 24-hour** Salesforce Platform API rate limit으로 마이그레이션한다. Summer '24 이후 생성된 org는 이미 사용 중. 마이그레이션된·신규 org에서는 Chatter가 필요한 요청만 per user, per application, per hour rate limit 대상이다.

**Where:** 모든 API 버전, 모든 에디션에 적용.
**When:** Winter '25부터 rolling 방식으로 백그라운드 마이그레이션.

#### New and Changed Connect REST API Resources

**Commerce**

- 비동기 product import 사용: `/commerce/management/webstores/webstoreId/product-import` resource가 버전 63.0에서 제거됨. 대신 `/commerce/management/import/product/jobs` 사용.
- cart 계산: 새 `/commerce/webstores/webstoreId/carts/activeCartOrId/actions/calculate` resource에 POST. 새 response body: Cart Summary Result.
- variation product 생성: 새 `/commerce/management/webstores/webstoreId/composite-variations` resource에 POST. 새 request body: Composite Commerce Variation Input. 새 response body: Composite Product Variation.
- KPI 목록 및 각 KPI가 지원하는 insight 조회: 새 `/commerce/intelligence/kpis` resource에 GET.
- 특정 KPI 정보 조회: 새 `/commerce/intelligence/kpis/{kpiName}` resource에 GET.
- 새 promotion 생성: 새 `/commerce/promotions/composite-promotions` resource에 POST. 새 request body: Composite Promotion Input. 새 response body: Composite Promotion.
- 특정 promotion 정보 조회: 새 `/commerce/promotions/composite-promotions` resource에 GET. 새 request parameter: `promotionId`, `templateId`, `webstoreId`. 새 response body: Composite Promotion.
- inventory record를 Omnichannel Inventory에 batch update: 새 `/commerce/oci/availability-records/actions/batch-update` resource에 POST. 새 request body: OCI Batch Update Input. 새 response body: OCI Batch Update.

**Data Cloud**

- API name으로 segment count 트리거: 새 `/ssot/segments/segmentAPIName/actions/count` resource에 POST(2024년 10월부터 사용 가능). 새 request body: Segment Action Input.

**Einstein**

- prompt template 목록 조회: 새 `/einstein/prompt-templates` resource에 GET. 새 response body: Einstein Prompt Record Collection.

**Named Credentials**

- external auth identity provider 생성: 새 `/named-credentials/external-auth-identity-providers` resource에 POST. (request: External Auth Identity Provider Input / response: External Auth Identity Provider)
- org 내 external auth identity provider 목록 조회: 새 `/named-credentials/external-auth-identity-providers` resource에 GET. (response: External Auth Identity Provider List)
- external auth identity provider 정보 조회: 새 `/named-credentials/external-auth-identity-providers/fullName` resource에 GET. (response: External Auth Identity Provider)
- external auth identity provider 업데이트: 새 `/named-credentials/external-auth-identity-providers/fullName` resource에 PUT. (request: External Auth Identity Provider Input / response: External Auth Identity Provider)
- external auth identity provider 삭제: 새 `/named-credentials/external-auth-identity-providers/fullName` resource에 DELETE.
- external auth identity provider credentials 정보 조회: 새 `/named-credentials/external-auth-identity-provider-credentials/fullName` resource에 GET. (response: External Auth Identity Provider Credentials)
- external auth identity provider credentials 생성: 새 `/named-credentials/external-auth-identity-provider-credentials/fullName` resource에 POST. (request·response: External Auth Identity Provider Credentials Input·Credentials)
- external auth identity provider credentials 업데이트: 새 `/named-credentials/external-auth-identity-provider-credentials/fullName` resource에 PUT. (request·response 동일)

**Platform**

- custom domain의 custom URL 목록 조회: 새 `/connect/custom-domain/domains/domainId/custom-urls` resource에 GET. (response: Custom Domain Custom URL Collection)
- 특정 custom URL 정보 조회: 새 `/connect/custom-domain/domains/domainId/custom-urls/customUrlId` resource에 GET. (response: Custom URL Detail)

**Salesforce CMS**

- managed content 채널 조회: 새 `/connect/cms/channels` resource에 GET. (response: Managed Content Channels)
- managed content 채널 생성: 새 `/connect/cms/channels` resource에 POST. (request: Managed Content Create)
- managed content 채널 조회: 새 `/connect/cms/channels/channelId` resource에 GET.
- managed content 채널 업데이트: 새 `/connect/cms/channels/channelId` resource에 PATCH. (request: Managed Content Update)
- managed content 채널 삭제: 새 `/connect/cms/channels/channelId` resource에 DELETE.
- managed content delivery 채널 조회: 기존 `/connect/cms/delivery/channels/channelId` resource에 GET. (새 response body: Managed Content Delivery Channel — 이전에는 Managed Content Channel Detail 반환)
- managed content delivery 채널 조회: 기존 `/connect/cms/delivery/channels` resource에 GET. (새 response body: Managed Content Delivery Channels — 이전에는 Managed Content Channel Collection 반환)
- managed content space의 채널 조회: 새 `/connect/cms/spaces/contentSpaceId/channels` resource에 GET. (response: Managed Content Space Channels)
- managed content space의 채널 추가·제거: 새 `/connect/cms/spaces/contentSpaceId/channels` resource에 PATCH. (request·response: Managed Content Space Channels Input·Channels)

**Salesforce Files**

- file upload config 조회: 새 `/connect/file/upload/config` resource에 GET. (response: File Upload Config)
- guest user 파일 업로드: 기존 `/connect/files/users/me` resource에 POST.

#### Changed Connect REST API Request Bodies

**Commerce — Checkout Start Input** (새 프로퍼티)

- `customFields` — sObject와 커스텀 필드 배열. 현재 WebCart·CartDeliveryGroup sObject만 지원. 커스텀 필드 타입: Checkbox, Currency, Date, Email, LongTextArea, Number, Percent, Phone, Text, TextArea, Url. Aura 템플릿 기반 store에서는 미지원.

**Commerce — Composite Product Input** (새 프로퍼티)

- `attributeSetInfo` — variation parent product의 attribute set 정보.

**Commerce — Payment Method Tokenization Input** (새 프로퍼티)

- `savedByMerchant` — 고객 payment 정보가 merchant에 의해 미래 구매를 위해 저장되는지 여부.

**Commerce — Sale Input** (새 프로퍼티)

- `legalEntityId` — legal entity 레코드의 ID.
- `submittedByMerchant` — 고객 payment sale 정보가 merchant에 의해 payment sale service에 제출되는지 여부.

**Einstein — Einstein Prompt Template Generations Input** (새 프로퍼티)

- `citationMode` — 지정된 prompt template의 citation 모드.
- `outputLanguage` — LLM 응답 생성 언어 code(버전 61.0 이상에서 사용 가능하나 이전 미문서화).

**Salesforce Files — File Input** (새 프로퍼티)

- `contentBodyId` — content body의 ID.
- `fieldName` — ContentVersion 객체의 커스텀 필드 이름.
- `fieldValue` — `fieldName`에 지정된 커스텀 필드에 저장할 값.
- `firstPublishLocationId` — 파일이 처음 게시된 location의 ID.
- `networkId` — 파일이 originate한 Experience Cloud 사이트의 ID.
- `pathOnClient` — 파일의 전체 경로.

#### Changed Connect REST API Response Bodies

**Commerce — Application Context** (새 프로퍼티)

- `orderStatuses` — Order Summary 객체의 Status picklist에서 사용 가능한 order status.

**Commerce — Cart Item** (새 프로퍼티)

- `childProductCount` — item에 연결된 cart의 child product 수(`productClass`가 `Bundle`이면; nested bundle 시 모든 child 포함).
- `parentCartItemId` — item의 parent cart item ID(top-level이면 비어 있음).
- `productClass` — product의 class.

**Commerce — Checkout** (새 프로퍼티)

- `customFields` — sObject와 커스텀 필드 배열(WebCart·CartDeliveryGroup만 지원, 타입 동일, Aura 템플릿 미지원).

**Commerce — Checkout Settings** (새 프로퍼티)

- `shippingMethodsEnabled` — web store에 shipping method 계산이 활성화되어 있는지 표시.

**Commerce — OCI Update Reservation Output** (새 프로퍼티)

- `exists` — SKU가 inventory에 존재하는지 표시.

**Commerce — Order Item Summary Lookup Output** (새 프로퍼티)

- `associatedLineItems` — order item summary에 연결된 child product line item.
- `itemClass` — product가 개별 판매되는지 또는 variation을 가질 수 있는지 판단.

**Commerce — Order Summary** (새 프로퍼티)

- `orderProductTopLevelLineCount` — top-level order product line summary의 수.

**Commerce — Order to Cart Failed Product** (새 프로퍼티)

- `media` — product에 연결된 media.

**Commerce — Product Child Collection** (새 프로퍼티)

- `productClass` — product의 class.

**Commerce — Timeline Output** (새 프로퍼티)

- `activityCode` — payment event의 code.
- `providerGateway` — payment service provider.

**Einstein — Einstein Prompt Template Generations** (새 프로퍼티)

- `citations` — 생성된 응답에 연결된 source 정보(있는 경우).
- (버전 61.0 이상에서 사용 가능하나 이전 미문서화) `generationErrors`, `isSummarized`, `requestMessages`, `responseMessages`, `slotsMaskingInformation`.

**Experience Cloud Sites — Community** (새 프로퍼티)

- `contentSpaceId` — enhanced 사이트에 연결된 managed content space의 ID.

**Flow Orchestration — Orchestration Work Item** (새 프로퍼티)

- `flowType` — orchestration work item을 생성한 orchestration의 flow type.

**Platform — Custom Domain Detail** (새 프로퍼티)

- `customUrls` — 이 domain의 custom URL 목록.

**Salesforce CMS — Managed Content Channel / Managed Content Channel Summary / Managed Content Collection Items / Managed Content Delivery Document / Managed Content Delivery Document Collection**

- 위 Apex output class의 CMS 변경과 동일한 프로퍼티 변경(여러 프로퍼티 제거, `id`·`isSearchable`·`channelSummary` 등 신규). 상세 매핑은 [Changed Connect in Apex Output Classes](#changed-connect-in-apex-output-classes)의 Salesforce CMS 항목과 동일.

**Salesforce Files — File Detail** (새 프로퍼티)

- `contentVersionId` — content version의 ID.

**Salesforce Files — File Summary** (새 프로퍼티)

- `contentVersionId` — content version의 ID.

### Invocable Actions

**Commerce** (Salesforce Commerce에서 사용 가능)

- **`recordTaxTransaction`** — order summary에서 외부 시스템으로 tax transaction을 기록.
- **`recordTaxReversal`** — order 반품·취소 후 외부 시스템에서 기록된 tax transaction을 reverse.

### Metadata API

> 이 새·변경 metadata type을 통해 더 많은 메타데이터에 접근한다.

**Salesforce Overall**

- person account·contact을 보고 대상에 연결 허용: 기존 **AccountSettings** metadata type의 새 `enableReportsToOnPersonAccount` 필드.

**Commerce**

- Order Management용 Delivery Estimation 활성화: 기존 **OrderManagementSettings** metadata type의 새 `deliveryEstimationEnabled` 필드.

**Customization**

- External Application Settings 페이지로 Lightning Experience transition tool 접근: 기존 **UserEngagementSettings** metadata type의 새 `canUseAdoptionApps` 필드.
- Dynamic Forms 레코드 페이지 필드에 조건부 서식 추가: 새 **UiFormatSpecificationSet** metadata type, 기존 **FlexiPage** metadata type의 **FieldInstanceProperty** subtype의 `name` 필드의 새 `conditionalFormatRuleset` 값.
- REMOVED: **UserEngagementSettings** metadata type의 `canGovCloudUseAdoptionApps` 필드 제거. 대신 새 `canUseAdoptionApps` 사용.
- public group·queue에 description 추가: 기존 **Group** metadata type의 새 `description` 필드.
- 업데이트된 UI로 사용자 관리: 기존 **UserManagementSettings** metadata type의 새 `enhancedUserListView` 필드.
- group summary 페이지로 public group member 관리: 기존 **UserManagementSettings** metadata type의 새 `groupSummaryUIEnhancement` 필드.

**Development**

- platform event Apex trigger의 parallel subscription 설정: `numPartitions` 필드. subscription partition의 hash 값 생성에 사용할 platform event 필드를 `partitionKey` 필드로 지정.
- Heroku 앱으로 External Services에서 action 생성(pilot): 기존 **ExternalServiceRegistration** metadata type의 기존 `ExternalServiceRegistrationProviderType` 필드의 새 `Heroku` 값.
- Lightning Platform 앱에서 Bitbucket에 연결: 기존 **AuthProvider** metadata type의 기존 `providerType` 필드의 새 `Bitbucket` 값.
- Agentforce for Developers 설정 관리: 새 **AgentforceForDevelopersSettings** metadata type. 현재 한 필드 `agentforceForDevelopersOptOut`(Agentforce For Developers 활성화·비활성화).

**Einstein**

- Agent topic 관리: 새 **GenAiPlugin**·**GenAiPluginInstructionDef** type.
- DEPRECATED: **SearchCustomization** metadata type의 `profile` 필드가 API 62.0 이상에서 deprecate. 대신 새 `selectedProfile` 필드 사용.

**Marketing Cloud**

- landing page·email 조회·배포: 기존 **DigitalExperienceBundle** type 사용.
- landing page·form·email을 change set·2GP로 org 간 이동: 기존 **DigitalExperienceBundle** type 사용.

**Mobile**

- Offline App(beta)에서 파일 첨부 접근: 기존 **BriefcaseRule** metadata type의 새 `isRelatedFilesRule` 필드(Offline App / Salesforce Mobile App Plus 전용).

**Manufacturing**

- REMOVED: **AdvAccountForecastSet** metadata type의 `forecastContextFieldName` 필드 제거(API 62.0에서 deprecate, 62.0 이상에서 제거).

**Sales**

- filter 기반 opportunity territory 할당 job을 multithreading으로 실행: 기존 **Territory2Settings** metadata type의 **Territory2SettingsOpportunityFilter** subtype의 새 `runMultiThreaded` 필드(API 62.0 도입).
- Lightning Experience에서 Apex로 lead owner 업데이트 시 이메일 알림 전송: 기존 **LeadConfigSettings** metadata type의 새 `shouldSendNotificationEmailWhenLeadOwnerUpdatesViaApexInLEX` 필드(API 53.0 도입).
- Forecast Submission으로 특정 시점 forecast 캡처: 기존 **ForecastingType** metadata type의 새 `forecastSubmissionSettings` 필드.
- Enablement program의 커스텀 exercise 타입을 change set·2GP로 org 간 이동: 새 **EnablementProgramTaskCustomContent**·**EnblProgramTaskSubCategory**·**LearningItemType** metadata type, 기존 **EnablementProgramTask** metadata type의 `taskSubCategory` 필드의 새 `CustomExercise` 값, 기존 **EnablementProgramTaskExercise** metadata type의 새 `customContent` 필드.
- BEHAVIOR CHANGE: 기존 **EnablementProgramTaskCmsContent** metadata type의 `contentKey` 필드가 더 이상 사용되지 않음. 대신 `apiName` 필드 사용.
- BEHAVIOR CHANGE: **Prompt** metadata type의 `body` 필드가 모든 prompt 타입에 대해 최대 4,000자 허용(이전 floating·docked prompt 240자, API 60.0 도입).
- forecasting 배포 성공·값 계산 보장: 이전 API 버전의 ForecastingSettings 파일 사용 시 **ForecastingSettings** metadata type의 다음 필드에 `customcategory` 값을 수동 추가 — **ForecastingCategoryMapping** subtype의 `forecastingItemCategoryApiName`·`weightedSourceCategories`, **ForecastingTypeSettings** subtype의 `forecastingCategoryApiNames`, **WeightedSourceCategory** subtype의 `sourceCategoryAPIName`.
- 여러 price book을 참조하는 order item을 가진 order 생성: 기존 **OrderSettings** metadata type의 새 `enableOrderWithMultiplePriceBooks` 필드(API 60.0 도입).
- calendar·activity 뷰에서 child event 숨김: 기존 **ActivitiesSettings** metadata type의 새 `enableHideChildEventsPreference` 필드(API 50.0 도입).
- ML로 client profile 생성: 기존 **ActivitiesSettings** metadata type의 새 `enableMLSingleClientProfile` 필드(API 50.0 도입).

**Salesforce Flow**

- BEHAVIOR CHANGE: **FlowStageStepAssignee** metadata type의 `assignee` 필드가 더 이상 필수가 아님(API 61.0 갱신).
- interactive step에 연결된 assignee 타입이 유효하지 않음을 지정: 기존 **FlowStageStepAssignee** metadata type의 `assigneeType` 필드의 새 `invalid` 값(API 61.0 도입).
- screen 컴포넌트용 template 지정(beta): 기존 **FlowScreenField** subtype(Flow metadata type의 FlowScreen subtype 내)의 새 `sourceTemplateApiName`·`sourceTemplateProviderType` 필드.
- Create Records element로 기존 레코드 업데이트: 기존 **FlowRecordCreate** subtype의 새 `doesUpsert`·`upsertExternalIdField`·`upsertStandardIdField`·`doesUpsertAllOrNone` 필드.
- flow Start element의 input 파라미터 정의: 기존 **FlowStart** subtype의 새 `inputs` 필드.
- automation event로 flow가 트리거됨을 지정: 기존 **FlowStart** subtype의 `triggerType` 필드의 새 `AutomationEvent` 값.
- action 완료까지 flow를 pause하는 timeout 설정: 기존 Flow metadata type의 `FlowCallAction` 필드의 새 `isWaitUntilCompleted` 값.
- action 완료 대기 중 flow pause 최대 시간 설정: `FlowCallAction` 필드의 새 `offset` 값.
- 비동기 action 실행 시 대기에 사용할 time unit 설정: `FlowCallAction` 필드의 새 `offsetUnit` 값.
- 비동기 action 실행이 timeout될 때 실행할 node 설정: `FlowCallAction` 필드의 새 `timeoutConnector` 값.
- DEPRECATED: `nameSegment` 값이 API 62.0 이상에서 deprecate. 대신 **FlowCallAction**의 새 `versionString` 필드 사용.
- DEPRECATED: `versionSegment` 값이 API 62.0 이상에서 deprecate. 대신 `versionString` 필드 사용.
- 레코드 우선순위 지정을 위한 레코드 데이터·필드 메타데이터 조회: Flow metadata type의 `actionType` 필드의 새 `getRecPrioData` 값.
- 레코드에 연결된 activity 데이터 요약 조회: `actionType` 필드의 새 `getActivitySummary` 값(API 60.0 도입).

**Security and Identity**

- credentials REST API로 OAuth Client Credentials 접근: 기존 **ExternalClientAppSettings** metadata type의 새 `enableClientSecretInRestApiAccess` 필드.
- 더 많은 org 타입에 External Client App 패키징: 기존 **ExternalClientAppSettings** metadata type의 새 `enablePackageEcaOauthFromDevOrg` 필드.
- OAuth 2.0 authorization challenge endpoint를 사용하는 headless identity flow에 external client app 활성화: 기존 **ExtlClntAppOauthSettings** metadata type의 새 `isFirstPartyAppEnabled` 필드.
- headless identity flow용 client attestation JWT 서명 certificate 업로드: 기존 **ExtlClntAppOauthSettings** metadata type의 새 `clientAssertionCertificate` 필드.
- OAuth 2.0 authorization challenge endpoint로 headless username-password 로그인·passwordless 로그인·등록 활성화: 기존 **Network** metadata type의 **NetworkAuthApiSettings** subtype의 새 `isFirstPartyAppsAllowed` 필드.
- 위 endpoint로 구성된 headless username-password 로그인에 reCAPTCHA 요구: **NetworkAuthApiSettings** subtype의 새 `doesPasswordLoginRequireAuth` 필드.
- passwordless 로그인 중 사용자 조회용 headless user discovery Apex handler 구성: **NetworkAuthApiSettings** subtype의 새 `headlessDiscoveryHandler` 필드.
- headless user discovery Apex handler 실행 user 설정: **NetworkAuthApiSettings** subtype의 새 `headlessDiscoveryExecutionUser` 필드.
- client config URL에 URL 파라미터 동적 추가로 auth provider 기능 제어: **AuthProvider** metadata type의 새 **AuthProvParamFwdAllowlist** subtype.
- named credential이 사용하는 auth provider 구성 단순화: 새 **ExternalAuthIdentityProvider** metadata type, 기존 **ExternalCredential** metadata type의 subtype인 **ExternalCredentialParameter**의 새 `externalAuthIdentityProvider` 필드.
- static username·password로 외부 시스템 인증: 기존 **ExternalCredential** metadata type의 `authenticationProtocol` 필드의 `Basic` 값(API 60.0 도입).
- Experience Builder preview 도메인에서 cross-domain 쿠키 허용: 기존 **MyDomainSettings** type의 새 `enableCrossDomainPreviewCookies` 필드.
- legacy hostname redirect: 기존 **MyDomainSettings** type의 새 `enableLegacyRedirections` 필드.

**Service**

- Embedded Messaging 채널의 client 설정 접근: 기존 **MessagingChannel** metadata type의 새 **EmbeddedConfig** subtype.
- Embedded Messaging 채널이 지원하는 다양한 authorization 방법 구성: 새 **EmbeddedConfig**의 새 **MessagingAuthorization** subtype.
- `deploymentFeature`가 EmbeddedMessaging인 Embedded Service 배포 설정 생성·업데이트: 기존 **EmbeddedServiceConfig** metadata type의 새 **EmbeddedServiceMessagingChannel** subtype.
- 위 배포의 pre-chat form 생성·편집: **EmbeddedServiceConfig**의 새 **EmbeddedServiceForm** subtype.
- 위 form의 개별 필드 생성·편집: 새 **EmbeddedServiceForm**의 새 **EmbeddedServiceFormField** subtype.
- pre-chat form의 dropdown 필드 생성·편집: 새 **ChoiceList** metadata type.
- dropdown 필드 옵션 설정·편집: **ChoiceList**의 새 **ChoiceListValue** subtype.
- Embedded Messaging 채널의 text response·auto-response messaging definition 설정: 기존 **MessagingChannel** metadata type의 새 **MessagingAutoResponse** subtype.
- text response의 keyword 설정: 기존 **MessagingChannel** metadata type의 새 **MessagingKeyword** subtype.
- User Verification에서 end user JWT 토큰을 JSON Web Key로 검증: 새 **PublicKeyCertificate** metadata type.
- public certificate·JSON web key set 접근: 새 **PublicKeyCertificateSet** type.
- public certificate key를 keyset에 매핑: **PublicCertificateSet** metadata type의 새 **PublicKeyCertificateSetKey** subtype.
- 커스텀 Messaging 채널 통합을 로고로 식별: 기존 **ConversationChannelDefinition** type의 `customIcon` 필드(API 61.0 도입).
- admin이 Messaging 채널의 커스텀 파라미터·매핑 구성 가능 여부 지정: 기존 **ConversationChannelDefinition** type의 `supportsCustomChannelParameters` 필드(API 61.0 도입).
- BYOC의 connected app owner 지정: 기존 **ConversationChannelDefinition** type의 새 `connectedAppType` 필드.
- BYOC용 customer connected app의 OAuth link 기록: 기존 **ConversationChannelDefinition** type의 새 `customerConnectedAppOauthLink` 필드.
- Messaging 채널을 contact center에 연결하고 voicemail routing 지정: 기존 **CallCenter** type의 **ContactCenterChannel** subtype(API 56.0 도입).
- partner vendor 시스템을 Service Cloud에 연결: **ConversationVendorInfo** type(API 52.0 도입).
- Generative AI로 survey 생성·번역: 기존 **SurveySettings** metadata type의 새 `enableGenerativeAISurveys` 필드(API 62.0 도입).
- 고객에게 refund 시작: 기존 Flow metadata type의 **FlowActionCall** subtype의 `actionType` 필드의 새 `automateRefund` 값(API 60.0 도입).
- Data Cloud에서 calculated insight 실행: **FlowActionCall** subtype의 `actionType` 필드의 새 `cdpPublishCalculatedInsight` 값(API 60.0 도입).
- Data Cloud에서 segment 게시: **FlowActionCall** subtype의 `actionType` 필드의 새 `cdpPublishSegment` 값(API 60.0 도입).
- Data Cloud에서 data stream refresh: **FlowActonCall** subtype의 `actionType` 필드의 새 `cdpRefreshDataStream` 값(API 60.0 도입).

### SOQL

#### Changed Error Messages

적절한 Apex 컨텍스트 설정 없이 `WITH SECURITY ENFORCED`를 사용하면 에러 메시지 `SECURITY_ENFORCED not allowed in this context`가 발생한다. 이 에러 메시지는 Summer '24에 다른 메시지로 변경되었으나, 그 변경이 **Winter '25에서 revert**되었다.

### Tooling API New and Changed Objects

**Customization**

- public group·queue에 description 추가: 기존 **Group** 객체의 새 `Description` 필드.

**Development**

- platform event Apex trigger의 parallel subscription 설정: `NumPartitions` 필드(parallel subscription 수 지정), `PartitionKey` 필드(hash 값 생성용 platform event 필드 지정).
- Heroku 앱으로 External Services에서 action 생성(pilot): 기존 **ExternalServiceRegistration** 객체의 기존 `ExternalServiceRegistrationProviderType` 필드의 새 `Heroku` 값.
- Developer·Developer Pro sandbox 생성·refresh 시 public group 지정으로 sandbox 보안 강화: **Behavior change announcement** — Spring '25부터 **SandboxInfo** 객체의 `ActivationUserGroupId` 필드가 Developer·Developer Pro sandbox 생성·refresh 시 필수가 된다. 생성·refresh 능력을 잃지 않으려면 API 버전 60.0 이상을 사용한다.
- sandbox 생성·refresh 시 적용할 add-on feature 지정: 기존 **SandboxInfo**·**SandboxProcess** 객체의 새 `Features` 필드.

**Sales**

- territory가 지원하는 object type 지정: 새 **Territory2SupportedObject** 객체.

**Security and Identity**

- named credential이 사용하는 auth provider 구성 단순화: 새 **ExternalAuthIdentityProvider** 객체, 기존 **ExternalCredentialParameter** 객체의 새 `ExtlAuthIdentityProvider` 필드.
- static username·password로 외부 시스템 인증: 기존 **ExternalCredential** 객체의 `AuthenticationProtocol` 필드의 `Basic` 값(API 60.0 도입).
- BYOK certificate로 Database tenant secret 업로드: 기존 **Certificate** 객체의 `OptionIsUsingKMS` 필드(API 50.0 도입).

**Service**

- 커스텀 Messaging 채널 통합을 로고로 식별: 기존 **ConversationChannelDefinition** 객체의 `customIconId` 필드(API 61.0 도입).
- admin이 커스텀 파라미터·매핑 구성 가능 여부 지정: 기존 **ConversationChannelDefinition** 객체의 `CapabilitiesSupportsCustomChannelParameters` 필드(API 61.0 도입).
- BYOC의 connected app owner 지정: 기존 **ConversationChannelDefinition** 객체의 새 `ConnectedAppType` 필드.
- BYOC용 customer connected app의 OAuth link 기록: 기존 **ConversationChannelDefinition** 객체의 새 `CustomerConnectedAppOauthLink` 필드.
- Messaging 채널을 contact center에 연결하고 voicemail routing 지정: **ContactCenterChannel** 객체(BYOC for CCaaS, API 56.0 도입).
- partner vendor 시스템을 Service Cloud에 연결: **ConversationVendorInfo** 객체(API 52.0 도입).

### User Interface API

#### New and Changed User Interface API Resources

**Lists**

- related list records 조회: 기존 `/ui-api/related-list-records/${parentRecordId}/${relatedListId}` resource에 GET 또는 PATCH. `relatedListId` query 파라미터가 이제 child relationship의 API name을 지원한다.

**Lookups**

- lookup 필드 suggestion 조회: 기존 `/ui-api/lookups/{objectApiName}/{fieldApiName}` resource에 POST.
- `/ui-api/lookups/{objectApiName}/{fieldApiName}` 및 `/ui-api/lookups/{objectApiName}/{fieldApiName}/{targetApiName}` resource에 대한 GET 요청은 더 이상 지원되지 않는다.

#### Changed User Interface API Response Bodies

**Lists — List Info** (새 프로퍼티)

- `hasMassActions` — list에 mass action이 있는지 표시.

#### Supported Objects

모든 새 standard object는 User Interface API용으로 자동 활성화된다.

org에 새롭지는 않으나 User Interface API에 새로 지원되는 standard object:

- `CampaignInfluence`
- `Profile`
- `TenantSecurityNotificationRule`

이미 User Interface API에서 지원되며, list view·most recently used list view에 새로 지원되는 standard object:

- `AssociatedLocation`
- `DelegatedAccount`
- `MaintenanceWorkRule`
- `ResourceAbsence`
- `User`
- `WorkCapacityLimit`
- `WorkCapacityUsage`

이미 User Interface API와 list view에서 지원되며, most recently used list view에 새로 지원되는 standard object:

- `PaymentTerm`
- `PaymentTermItem`

---

## 거버너 한도 변경

Winter '25 Development 섹션에서 직접 명시된 한도·할당량 변경:

- **LWC JavaScript 파일 최대 크기:** 128 KB (131,072 bytes) → **1 MB (1,000,000 bytes)**.
- **Apex Metadata API enqueued 배포:** 이전에는 한도 없음 → 이제 **Apex에서 enqueue 가능한 배포 수에 service protection limit** 적용(Apex 발생분에만, CLI·change set·packaging 제외). (PDF는 구체 수치를 명시하지 않음)
- **Parallel Subscriptions (Apex platform event trigger):** 플랫폼 이벤트당 최대 **10개 parallel subscription(partition)** 지정 가능. (Platform Events 섹션 — `NumPartitions`/`PartitionKey`로 설정)
- **Schedule-Triggered Flow:** 단일 schedule-triggered flow가 이제 최대 **250,000 레코드**까지만 접근 가능(이전에는 한도 없음). → 아래 Flow 개발자 항목 참조.
- **ConnectApi / Connect REST API rate limit:** per user, per namespace(또는 application), per hour → **per org, per 24-hour** Salesforce Platform API rate limit으로 마이그레이션(Winter '25부터 rolling).

> Note: Apex governor limit이 SoqlStubProvider로 stub된 레코드에도 적용된다(위 Apex 섹션 참조).

---

## Salesforce Flow 개발자 항목 (versioned behavior + Release Updates)

> 이 항목들은 Flow의 개발자 관점 변경이다. Release Update 강제 타이밍은 [[Winter '25/Release Updates]]를 함께 참조한다.

### Versioned Flow Behavior (API 버전 종속)

- **Enforce Sharing Rules when Apex Launches a Flow (API 62.0 이상):** `with sharing` 키워드로 선언된 Apex 클래스가 default 컨텍스트에서 실행되는 autolaunched flow를 실행할 때 sharing rule을 강제한다. sharing을 강제하려면 Apex 클래스가 `with sharing`으로 선언되어야 한다. 이전에는 `with sharing` Apex 클래스가 flow를 실행해도 flow가 sharing 없이 system 컨텍스트로 실행되었다. 이 versioned update로 flow는 Apex 클래스를 실행한 사용자의 sharing rule을 강제한다(예: 쿼리가 더 적은 row 반환, 권한 부족으로 작업 실패 가능).
- **Evaluate Null Text Values (API 61.0 이상):** flow가 null text 값을 반환하는 invocable action을 실행하면 null text 값이 `null`로 평가된다(이전에는 빈 문자열 값으로 평가).
- **Set Screen Action Outputs to Null Correctly (API 62.0 이상):** screen action으로 실행된 flow의 출력이 Assignment element로 설정되지 않은 경우, 출력이 기대대로 `null`로 설정된다. 해당 출력을 사용하는 screen 컴포넌트는 이제 자동 업데이트된다.
- **Set Conditionally Hidden Screen Component Outputs to Null Correctly (API 62.0 이상):** 조건부로 숨겨진 screen 컴포넌트가 컬렉션을 출력으로 가지면, 그 출력이 기대대로 `null`로 설정된다.

### Flow Management — Run Schedule-Triggered Flows on Limited Records to Improve Performance

단일 schedule-triggered flow가 이제 최대 **250,000 레코드**까지 접근하도록 제한된다(이전에는 한도 없음).

**Where:** Essentials, Professional, Enterprise, Unlimited, Developer 에디션의 Lightning Experience와 Salesforce Classic에 적용.

### Flow and Process Release Updates (Apex 관련 — 강제 타이밍)

Salesforce Flow에는 향후 릴리즈에서 강제 예정인 여러 release update가 있다(아래는 PDF 32692–32782 전사, Apex 관련 강조).

- **Enforce Sharing Rules When Apex Launches a Flow (Release Update):** Winter '25에 강제 예정이었으나, Winter '25부터 Salesforce가 더 이상 강제하지 않음(활성화 권장). Spring '24부터 사용 가능. 활성화하지 않으면 대안으로 API 62.0 이상에서 flow나 Apex 실행 시 sharing rule을 강제할 수 있다.
- **Prevent Guest User from Editing or Deleting Approval Requests (Release Update):** Winter '23 최초 제공, Summer '23 강제 예정 → Spring '24 연기 → Winter '25 재연기. **Winter '25에 강제됨.**
- **Restrict User Access to Run Flows (Release Update):** Winter '24 최초 제공, Winter '25 강제 예정이었으나 **Winter '26으로 연기.** 활성화 시 사용자가 flow를 실행하려면 올바른 profile·permission set이 필요. `FlowSites` org 권한이 deprecate됨.
- **Enable Secure Redirection for Flows (Release Update):** Spring '25 강제 예정이었으나, Spring '25부터 Salesforce가 더 이상 강제하지 않음(권장). flow URL 파라미터에 엄격한 validation 적용.
- **Enforce Rollbacks for Apex Action Exceptions in REST API (Release Update):** Spring '25 강제 예정이었으나, Spring '25부터 강제하지 않음(권장). REST API로 Apex action 실행 시 예외 발생하면 트랜잭션을 rollback해 데이터 무결성 보존.
- **Run Flows in User Context via REST API (Release Update):** Spring '22에 이전 강제됨. 일부 사용자에서 preference가 의도치 않게 revert되어 재출시. 영향받은 사용자는 **Winter '25에 재강제.** REST API로 실행되는 flow가 실행 사용자의 profile·permission set으로 object 권한·FLS를 결정.
- **Evaluate Criteria Based on Original Record Values in Process Builder (Release Update):** 여러 criteria와 record update를 가진 process의 평가 criteria 버그 수정. Summer '19 최초 제공.
- **Make Flows Respect Access Modifiers for Legacy Apex Actions (Release Update):** Spring '21 이전 강제됨, 일부 사용자 revert로 재출시 → 영향받은 사용자는 **Winter '25에 재강제.** public legacy Apex action을 포함하면 flow가 실패하게 함.
- **Disable Access to Session IDs in Flows (Release Update):** Winter '24 이전 강제됨, 일부 사용자 revert로 재출시 → 영향받은 사용자는 **Winter '25에 재강제.** flow interview가 런타임에 `$Api.Session_ID` 변수를 resolve하지 못하게 함.
- **Enable Partial Save for Invocable Actions (Release Update):** Spring '20 이전 강제됨, 일부 사용자 revert로 재출시 → 영향받은 사용자는 **Winter '25에 재강제.** 대량 외부 REST API 호출에서 단일 invocable action 실패가 전체 트랜잭션을 실패시키지 않게 함.
- **Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs (Release Update):** Apex action 입력으로 사용되는 built-in Apex 클래스의 권한 요구사항 강제. Summer '24 최초 제공, Spring '25 강제 예정이었으나 **Winter '26으로 연기.**
- **Sort Apex Batch Action Results by Request Order (Release Update):** Apex batch action 결과를 요청 순서대로 반환.
- **Enable EmailSimple Invocable Action to Respect Organization-Wide Profile Settings (Release Update):** Send Email invocable action이 org-wide email 주소 profile 설정을 준수. Summer '23 최초 제공, Spring '24 강제 예정 → **Winter '25로 연기.**
- **Enhance Flexibility and Reusability in Prompt Flows (Release Update):** template-triggered prompt flow에서 flex prompt template 타입 지정 기능 제거. 대신 manual input을 사용. Winter '25부터 사용 가능.

---

## Mobile (LWC/offline dev)

> mobile·offline LWC 개발 관련 항목.

### Validate Mobile Lightning Web Components with ESLint Rules

새 ESLint 규칙 plugin을 사용해 mobile·offline LWC와 작동하는 코드 개발을 돕는다.

> Note: Salesforce는 offline LWC 개발에 VS Code + Salesforce Extensions for VS Code 사용을 권장한다.

**Where:** Database.com을 제외한 모든 에디션의 iOS·Android용 Salesforce Mobile App Plus에 적용.

**How:** ESLint 규칙은 다음 위반을 flag한다.

- Apex 사용
- Offline GraphQL feature 제한
- Offline GraphQL hard limit

> Note: PDF 27245에 "Here you can see the popup for an Offline GraphQL lint rule violation."라는 다이어그램/스크린샷 단서가 있음 — 본 wiki에는 텍스트 설명만 포함(원본 스크린샷 미재현).

### Offline GraphQL Pagination Support

Offline GraphQL이 이제 pagination을 부분 지원한다.

**Where:** Database.com을 제외한 모든 에디션의 iOS·Android용 Salesforce Mobile App Plus에 적용.

**How:** Pagination은 top-level 레코드 쿼리에 지원되나, nested child 쿼리에는 지원되지 않는다.

### Scan Barcodes with Inverted Colors (BarcodeScanner)

`BarcodeScanner` LWC가 색 반전 바코드 스캔을 지원하도록 업데이트됨(`BarcodeScannerOptions`의 새 `supportInvertedColors`). 상세는 위 LWC 섹션 참조.

**Where:** Salesforce Mobile과 Field Service Mobile 앱에 적용.

### Mobile Publisher for Experience Cloud LWR Sites (Generally Available)

Experience Cloud LWR 사이트용 Mobile Publisher가 이제 GA다. Build Your Own(BYO) LWR 사이트에서 브랜드 모바일 앱을 개발할 수 있으며, 속도·확장성·디자인 유연성이 향상된다.

---

## 관련 노트

- [[Winter '25]] — Winter '25 허브
- [[Winter '25/Release Updates]] — Release Update 강제 타이밍 형제 spoke
- [[Winter '25/Platform]] — Platform 형제 spoke
- [[Apex MOC]] — Apex 섹션 전체 목차
- [[LWC MOC]] — LWC 섹션 전체 목차
- [[ConnectApi Namespace 개요]] — Connect in Apex 네임스페이스 레퍼런스
