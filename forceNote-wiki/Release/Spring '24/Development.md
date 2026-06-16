---
tags: [release, spring_24, development, apex, lwc, api]
source: salesforce_spring24_release_notes.pdf
created: 2026-06-16
aliases: [Spring '24 Development, 스프링 24 개발, Apex LWC API v60]
---

# Spring '24 — Development (Apex · LWC · API)

> 허브: [[Spring '24]]
> Spring '24(API v60.0, LWC OSS v5.0.0 대응)의 개발자 영역 전수 정리 — Apex null 병합 연산자(`??`)·UUID·`Database.releaseSavepoint`·Compression/FormulaEval Developer Preview, LWC Workspace API/record-picker/logger GA·Mixed Shadow Mode Beta·v60.0 breaking change 4종, API v60.0·Bulk API 2.0 PK chunking·GraphQL·Pub/Sub Managed Subscriptions Beta, 거버너 한도 변경과 은퇴 일정.

---

## 개요

이 노트는 Spring '24 릴리즈 노트의 **Development 섹션(PDF p.220~306)**을 Apex·LWC·API 축으로 정리한 spoke다. 깊이 원칙에 따라 네임스페이스별 신규 클래스/메서드/enum, 컴포넌트별 변경, API 카탈로그를 전수 기록한다.

| 항목 | 값 |
|---|---|
| API 버전 | v60.0 |
| LWC API 버전 | 60.0 (= LWC OSS v5.0.0, v4.0.0 변경 포함) |
| 출시 | 2024년 02월 |

- 상위 허브: [[Spring '24]]
- 강제 적용 항목(Release Updates): [[Spring '24/Release Updates]]
- 거버너 한도 일반 참조: [[Governor Limits]]

> **시각 자료 안내(Pattern C):** 원본 PDF의 record-picker UI 이미지(p.222)와 AppExchange Marketplace Analytics 스크린샷(p.257)은 pdftotext로 추출되지 않았다. 본 노트는 텍스트 설명만 담으며 이미지를 재현하지 않는다.

---

## Apex

### 신규

#### Null 병합 연산자 `??` (IdeaExchange)

`??` 연산자는 좌측 피연산자가 null이 아니면 좌측을, null이면 우측을 반환한다. binary operator이며 **left-associative**다. 좌측은 1회만 평가되고, 우측은 좌측이 null일 때만 평가된다. 타입 호환이 필수다 — `objectZ result = objectA ?? objectB`에서 `objectA`·`objectB` 모두 `objectZ`의 instance여야 한다.

```apex
// 이전 방식
Integer notNullReturnValue = (anInteger != null) ? anInteger : 100;
```

```apex
// 새 방식
Integer notNullReturnValue = anInteger ?? 100;
```

연산자 우선순위 주의: `top ?? 100 - bottom ?? 0`은 `top ?? (100 - bottom ?? 0)`로 평가되며, `(top ?? 100) - (bottom ?? 0)`가 **아니다.** 원하는 결과를 위해 괄호가 필요할 수 있다.

SOQL 단일 레코드 assignment에서 결과가 없을 때 graceful하게 처리한다. 좌측 SOQL이 행을 반환하면 그 결과를, 행이 없으면 우측 피연산자를 반환한다.

```apex
Account defaultAccount = new Account(name = 'Acme');
// Left operand SOQL is empty, return defaultAccount from right operand:
Account a = [SELECT Id FROM Account
WHERE Id = '001000000FAKEID'] ?? defaultAccount;
Assert.areEqual(defaultAccount, a);

// If there isn't a matching Account or the Billing City is null, replace the value
string city = [Select BillingCity
From Account
Where Id = '001xx000000001oAAA']?.BillingCity;
System.debug('Matches count: ' + (city?.countMatches('San Francisco') ?? 0) );
```

**제약:**
- assignment의 좌변에 사용 불가: `foo??bar = 42;` 은 valid assignment가 아니다.
- **SOQL bind expression은 `??`를 미지원한다.** 아래에서 `acctName`은 `??`로 미리 평가한 뒤 bind한다.

```apex
String primaryName;
String secondaryName = 'Acme';
String acctName = primaryName ?? secondaryName;
List<Account> accounts = [SELECT Name FROM Account WHERE Name = :acctName];
List<List<SObject>> moreAccounts = [
FIND :acctName
IN ALL FIELDS
RETURNING Account(Name)
];
```

#### UUID 클래스 — v4 UUID (IdeaExchange)

새 `UUID` 클래스가 cryptographically strong pseudo-random number generator로 v4 UUID를 생성한다. 32개 hexadecimal 값으로 표현된다.

**UUID 메서드 (전수):**

| 메서드 | 반환 | 설명 |
|---|---|---|
| `randomUUID()` | UUID | object를 고유 식별하는 UUID를 무작위 생성 |
| `equals(obj)` | Boolean | UUID instance를 지정 object와 비교, 같으면 true |
| `hashcode()` | — | UUID instance의 hashcode 반환 |
| `fromString(string)` | UUID | string 표현으로부터 UUID instance 반환 |
| `toString()` | String | UUID instance의 string 표현 반환 |

```apex
UUID randomUuid = UUID.randomUUID();
// Prints the UUID string that was randomly generated
system.debug(randomUuid);
String uuidStr = randomUUID.toString();
UUID fromStr = UUID.fromString(uuidStr);
Assert.areEqual(randomUuid, fromStr);
```

#### `Database.releaseSavepoint` — savepoint 해제 후 callout (IdeaExchange)

savepoint로 uncommitted DML을 rollback한 뒤, 새 `Database.releaseSavepoint` 메서드로 savepoint를 명시적 release하고 callout할 수 있다. 이전에는 savepoint 생성 후 callout이 무조건 `CalloutException`이었다.

```apex
Savepoint sp = Database.setSavepoint();
try {
// Try a database operation
insert new Account(name='Foo');
integer bang = 1 / 0;
} catch (Exception ex) {
Database.rollback(sp);
Database.releaseSavepoint(sp); // Also releases any savepoints created after 'sp'
makeACallout(); // Callout is allowed because uncommitted work is rolled back and savepoints
are released
}
```

savepoint를 release하지 않고 callout하면 예외가 발생한다.

```apex
Savepoint sp = Database.setSavepoint();
try {
makeACallout();
} catch (System.CalloutException ex) {
Assert.isTrue(ex.getMessage().contains('All active Savepoints must be released before
making callouts.'));
}
```

savepoint를 release했더라도 pending DML이 남아 있으면 callout이 실패한다.

```apex
Savepoint sp = Database.setSavepoint();
insert new Account(name='Foo');
Database.releaseSavepoint(sp);
try {
makeACallout();
} catch (System.CalloutException ex) {
Assert.isTrue(ex.getMessage().contains('You have uncommitted work pending. Please
commit or rollback before calling out.'));
}
```

> **거버너 한도 변경(Note):** `Database.rollback(Savepoint)`와 `Database.setSavepoint()`는 이제 **DML row limit에는 미카운트, 단 DML statement limit에는 카운트**된다(모든 API 버전 적용). Spring '24 이전에는 둘 다 DML row usage limit을 증가시켰다.
> - `Database.releaseSavepoint()` 호출 시 savepoint가 발견·release되면 `SAVEPOINT_RELEASE`가 로깅된다.
> - **API v60.0+ Apex test:** `Test.startTest()`·`Test.stopTest()`에서 모든 savepoint가 release되며, reset되면 `SAVEPOINT_RESET` 이벤트가 로깅된다.

#### Compression 네임스페이스 (Developer Preview)

새 `Compression` 네임스페이스로 zip 파일을 생성·추출한다. compression method·level을 지정하고, 여러 attachment/document를 zip archive Apex blob으로 압축하며, 전체 압축 해제 없이 특정 데이터를 추출할 수 있다.

- **Note:** Developer Preview. production 사용 금지.
- **Where:** `ZipSupportInApex` feature가 활성화된 scratch org. 미활성화 시 compile은 되나 실행 불가.

`ZipWriter`로 email attachment를 압축하는 예:

```apex
Compression.ZipWriter writer = new Compression.ZipWriter();
List<id> contentDocumentIds = new List<id>();
// Add IDs of documents to be compressed to contentDocumentIds
for ( ContentVersion cv : [SELECT PathOnClient, Versiondata
FROM ContentVersion
WHERE ContentDocumentId IN :contentDocumentIds])
{
writer.addEntry(cv.PathOnClient, cv.versiondata);
}
blob zipAttachment = writer.getArchive();
Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
efa.setFileName('attachments.zip');
efa.setBody(zipAttachment);
List<Messaging.EmailFileAttachment> fileAttachments = new
List<Messaging.EmailFileAttachment>();
fileAttachments.add(efa);
Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
// Set all the other email fields, such as addresses, subject, and body
email.setFileAttachments(fileAttachments);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
```

`ZipReader`로 callout 응답에서 특정 translation을 추출하는 예:

```apex
HttpRequest request = new HttpRequest();
request.setEndpoint('callout:My_Named_Credential/translationService');
request.setMethod('POST');
// Set translation service request payload for input to translate
// The translation endpoint will return translations to the requested languages as JSON
in a Zip archive
HttpResponse response = new Http().send(request);
Blob translationZip = response.getBodyAsBlob();
Compression.ZipReader reader = new Compression.ZipReader(translationZip);
ZipEntry frTranslation = reader.getEntry('translations/fr.json');
Blob frTranslationData = reader.extractEntry(frTranslation);
```

> 클래스 상세는 [[Compression Namespace]] 참조(해당 노트는 Spring '25 GA 기준).

#### FormulaEval 네임스페이스 (Developer Preview)

새 `FormulaEval` 네임스페이스로 Apex object·sObject의 user-defined formula를 평가한다. formula field 재계산용 불필요한 DML을 회피한다.

- **Note:** Developer Preview. production 사용 금지.
- **Where:** `FormulaEvalInApex` feature가 활성화된 scratch org. 미활성화 시 compile은 되나 실행 불가.
- **How:** `FormulaBuilder`의 static `builder()` 메서드로 formula text·return type·context object를 지정하고, `build()`로 검증한다(실패 시 `FormulaValidationException`). `FormulaInstance`의 `evaluate()`로 계산한다(실패 시 `FormulaEvaluationException`).

```apex
global class MotorYacht {
global Integer lengthInYards;
global Integer numOfGuestCabins;
global String name;
global Account owner;
}
MotorYacht aBoat = new MotorYacht();
aBoat.lengthInYards = 52;
aBoat.numOfGuestCabins = 4;
aBoat.name = 'RV Foo';
FormulaEval.FormulaInstance isItSuper = FormulaEval.FormulaBuilder.builder()
.withReturnType(FormulaEval.FormulaReturnType.STRING)
.withType(MotorYacht.class)
.withFormula('IF(lengthInYards < 100, "Not Super", "Super")')
.build();
isItSuper.evaluate(aBoat); //=> "Not Super"
aBoat.owner = new Account(Name='Acme Watercraft', Site='New York');
FormulaEval.FormulaInstance ownerDetails = FormulaEval.FormulaBuilder.builder()
.withReturnType(FormulaEval.FormulaReturnType.STRING)
.withType(MotorYacht.class)
.withFormula('owner.Name & " (" & owner.Site & ")"')
.build();
ownerDetails.evaluate(aBoat); //=> "Acme Watercraft (New York)"
```

`withType`의 context type은 global·user-defined Apex class여야 하며, formula가 참조하는 field·property도 global이어야 한다.

#### `@InvocableMethod` `capabilityType` 수정자 — Prompt Builder 연동

Apex invocable action을 Prompt Builder의 prompt template과 통합한다. dynamic 로직·action으로 output text를 생성해 prompt template resolution에 merge한다.

- **Where:** Lightning Experience — Enterprise, Unlimited, Unlimited+ editions.
- **How:** `@InvocableMethod` annotation에 `capabilityType` modifier를 사용하는 Apex 메서드를 생성한다.

### 변경

- **`Type.forName()` — invalid namespace 시 null 반환** — `Type.forName('InvalidNamespace', 'OuterClass.InnerClass')` 또는 `Type.forName('OuterClass', 'InnerClass')`(outer class를 namespace로 전달)처럼 잘못된 namespace를 지정하면 이제 **null을 반환**한다. 이전에는 indeterminate 결과였다. (모든 edition, **API v60.0+ versioned behavior change.**)
- **외부 오브젝트 DML 검증·한도 회계 개선** — Spring '24부터 **external object만** `Database.insertImmediate()`·`Database.insertAsync()` 등 DML 메서드를 사용할 수 있다. external/big object 외의 타입을 사용하면 catchable `TypeException`이 발생한다. 이 DML 작업은 **DML statement·record limit을 미증가**한다. 이전에는 external/non-external mixing 검증이 없었다.
- **Quiddity 기본값 변경 (R → UD)** — descriptive quiddity가 미할당된 event의 새 default가 **Undefined (UD)**로 변경됐다. 이전 default는 Synchronous Uncategorized (R)였다. (**API v60.0+ versioned behavior change.**)
- **`FOR UPDATE` lock 해제 시 로깅 개선** — Apex `FOR UPDATE` lock이 callout 시 자동 release되며 debug log에 최근 lock entity type과 함께 기록된다. 예: `FOR_UPDATE_LOCKS_RELEASE FOR UPDATE locks released due to a callout. The most recent lock was Account.`
- **Apex REST API HTTP ACCEPT 헤더 JSON 기본값** — Apex REST API의 HTTP ACCEPT header가 이제 JSON을 기본값으로 사용한다. missing/malformed ACCEPT header 시 JSON을 반환한다. valid 값은 `application/json` 또는 `application/xml`(case sensitive)다. v59.0 이하 Apex 클래스는 missing/malformed(예: `application/Xml`) 시 에러를 반환했다. (BEHAVIOR CHANGE)

### Release Update (Spring '24 강제)

- **`RestResponse.addHeader()` RFC 7230 검증 강제** — Spring '23 제공, **Spring '24 enforced.** update가 활성화되면 API 버전과 무관하게 `RestResponse.addHeader(name, value)`로 정의된 응답 header 이름을 RFC 7230 기준으로 검증한다. invalid 문자(예: `/`)는 더 이상 허용되지 않으며, 비준수 header name 시 runtime `InvalidHeaderException`이 발생한다. (모든 edition)
- **`@JsonAccess` annotation 검증 (Visualforce JavaScript Remoting API)** — Winter '23 제공, **Spring '24 enforced.** Visualforce Remoting API가 JS로 Apex controller 메서드를 직접 호출할 때, packaging namespace 간 무단 serialization/deserialization을 방지하기 위해 Apex 클래스의 `JsonAccess` annotation을 검증한다. (Lightning Experience·Salesforce Classic 모든 edition)

### 은퇴/폐기

- **Salesforce Functions** — **2025년 1월 31일 retiring.** 기존 Order Term까지 구독 사용 가능하며, Order Term 종료 전 대체 솔루션 배포가 필요하다. EOL timeline·migration은 Heroku Dev Center의 Salesforce Functions Retirement 참조. (Professional, Unlimited, Developer editions)

---

## LWC

### LWC API v60.0 (= LWC OSS v5.0.0)

`.js-meta.xml`의 `apiVersion` 키로 컴포넌트 API 버전을 지정한다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
<apiVersion>58.0</apiVersion>
</LightningComponentBundle>
```

- `apiVersion`을 58.0으로 두면 컴포넌트가 Summer '23처럼 동작하지만 v59.0+ 버그픽스/개선을 받지 못한다. Winter '24부터 58.0 이하 모든 버전은 58.0(Summer '23)으로 취급된다.
- **한 버전씩 업그레이드 권장**(58.0 → 59.0 에러 수정 → 60.0).
- v60.0은 LWC OSS v5.0.0에 대응하며 v4.0.0 변경도 포함한다. 플랫폼 외부 LWC 개발자는 추가 breaking change의 영향을 받는다.

v60.0의 breaking change는 4가지다 — Empty Comment Nodes, Light DOM Whitespace, Decorators Syntax Error, Object Rest/Spread Transpilation 제거.

#### 변경 1: Empty Comment Nodes가 Empty Text Nodes를 대체

light DOM slots·scoped slots·`lwc:if`에 virtual DOM node를 구현하기 위한 변경이다. SSR(open source만)에서 empty text node가 zero-width space로 렌더링되어 hydration 이슈가 발생했다. v60.0+에서는 empty text node(`''`) 대신 empty comment node(`<!---->`)를 사용한다.

```html
<template>
<template lwc:if={expression}>Some content here</template>
</template>
```

v60.0+ 렌더 결과는 content 앞뒤로 comment node가 붙고, v59.0 이하는 text만 렌더된다.

#### 변경 2: Light DOM이 추가 Whitespace 문자를 렌더링

영향받는 Web API: `childNodes`, `firstChild`, `lastChild`.

```js
renderedCallback() {
const myExpectedChildNode = this.childNodes[0];
}
```

- v59.0 이하: `this.childNodes[0]`은 light DOM의 첫 slotted element.
- v60.0+: empty text node로 resolve.
- **권장:** `lwc:ref` 또는 `this.querySelector`. 대안 element-only API: `children`, `firstElementChild`, `lastElementChild`.

#### 변경 3: non-LightningElement 클래스의 데코레이터는 SyntaxError

non-LightningElement 클래스에서 `@api`·`@track`·`@wire` 데코레이터를 제거해야 한다.

```js
// Don't do this
class MyCustomClass {
@track myName = { firstName: "", lastName: "" };
}
```

```js
// Do this instead
import { LightningElement } from 'lwc';
export default class DecoratorExample extends LightningElement {
@track fullName = { firstName : '', lastName : ''};
}
```

데코레이터는 LightningElement를 extend하는 클래스(예: LightningDatatable)에서만 사용 가능하다. `HTMLElement`를 extend해 `customElements.define()`로 custom element를 생성하는 것은 가능하다.

#### 변경 4: Object Rest/Spread Transpilation 제거

v60.0+는 `...obj` rest/spread를 Babel transpiled 대신 native syntax로 처리한다.

```js
let count = 0;
const {
foo: {
bar,
...obj
}
} = {
get foo() {
count++;
return { bar: 42 }
}
};
```

Babel transform 후에는 `count`가 2를 반환했지만(Babel bug), native syntax는 1을 반환한다.

### GA (Generally Available)

#### LWC Workspace API — `lightning/platformWorkspaceApi` (GA)

LWC Workspace API가 Lightning console app의 workspace tab/subtab 관리 메서드를 제공한다. beta 이후 minor 버그픽스/개선을 포함해 GA됐다.

- **Where:** Lightning console apps — Enterprise, Performance, Unlimited, Developer editions.
- **How:** `lightning/platformWorkspaceApi` 모듈 import. **Lightning Web Security 필수**(Lightning Locker는 LWC Workspace API 미지원).

**API 메서드 (전수):**

| 메서드 | 설명 |
|---|---|
| `closeTab()` | workspace tab/subtab 닫기 |
| `disableTabClose()` | workspace tab/subtab 닫힘 방지 |
| `focusTab()` | workspace tab/subtab 포커스 |
| `getAllTabInfo()` | 모든 열린 탭 정보 반환 |
| `getFocusedTabInfo()` | 포커스된 workspace tab/subtab 정보 반환 |
| `getTabInfo()` | 지정된 탭 정보 반환 |
| `openSubtab()` | workspace tab 내 subtab 열기(이미 열려있으면 포커스) |
| `openTab()` | 새 workspace tab 열기(이미 열려있으면 포커스) |
| `refreshTab()` | tab ID로 지정된 workspace tab/subtab 새로고침 |
| `setTabHighlighted()` | 지정 탭을 다른 배경색·badge로 강조(reload 후 미유지) |
| `setTabIcon()` | 지정 탭의 아이콘·대체 텍스트 설정 |
| `setTabLabel()` | 지정 탭의 label 설정 |

**Wire adapters:**

| Wire adapter | 설명 |
|---|---|
| `EnclosingTabId()` | enclosing tab의 ID 반환 |
| `IsConsoleNavigation()` | 사용 중인 app이 console navigation을 사용하는지 판별 |

**Lightning message channels (Aura application event 대응):**

| 채널 | 설명 |
|---|---|
| `lightning__tabClosed` | 탭 닫힘 |
| `lightning__tabCreated` | 탭 생성 성공 |
| `lightning__tabFocused` | 탭 포커스됨 |
| `lightning__tabRefreshed` | 탭 새로고침됨 |
| `lightning__tabReplaced` | 탭 교체 성공 |
| `lightning__tabUpdated` | 탭 업데이트 성공 |

#### `lightning-record-picker` (GA)

`lightning-record-picker`로 desktop·mobile 사용자가 레코드를 검색·선택한다. GA 변경: **최대 100 레코드 조회 가능(이전 50)**, invalid spec 시 명확한 에러 메시지, 새 attribute 지원. GraphQL wire adapter를 사용해 offline을 지원한다.

- **Where:** Lightning Experience 모든 edition.
- 새 attribute: `field-level-help`(help text), `disabled`(컴포넌트 비활성). `display-info`에 새 property `primaryField`(record suggestion 첫 field, default Name).

```html
<lightning-record-picker
label="Select a record"
placeholder="Search..."
object-api-name="Contact"
value={initialValue}
onchange={handleChange}
></lightning-record-picker>
```

`value` attribute에 record ID를 제공하면 default selected record가 표시된다.

#### Custom Component Instrumentation API — `lightning/logger` (GA)

Custom Component Instrumentation API로 LWC observability를 추가한다. org의 Event Monitoring에서 custom LWC 이벤트/상호작용을 직접 모니터·추적한다. GA 변경: 이제 **browser console에서 custom component log 조회 가능**. **Aura 컴포넌트 미지원.**

- **Where:** Lightning Experience — Enterprise, Performance, Unlimited, Developer editions(Event Monitoring 활성화).
- **Who:** Salesforce Shield 또는 Event Monitoring add-on 구매 고객.
- **How:** Setup → Event Monitoring Settings → **Lightning Logger Events** 켜기. 컴포넌트에서 `lightning/logger`의 `log` import. `log()`는 새 EventLogFile event type(Lightning Logger Event)에 데이터를 publish한다.

```js
// myComponent.js
import { LightningElement } from 'lwc';
import { log } from 'lightning/logger';
export default class MyComponent extends LightningElement {
handleClick() {
let msg = {
type: 'click',
action: 'Approve'
}
log(msg);
}
}
```

### Beta

#### Mixed Shadow Mode — `shadowSupportMode = 'native'` (Beta)

native shadow DOM 준비로 성능·웹 표준 정렬을 개선한다. 플랫폼에서 custom 컴포넌트는 기본 synthetic shadow(polyfill)를 사용하며, native shadow로 점진 마이그레이션한다.

- **Note:** Beta Service. Beta Services Terms 적용.
- **Where:** Lightning Experience, Experience Builder, mobile app의 custom LWC.

```js
export class MyComponent extends LightningElement {
static shadowSupportMode = 'native';
}
```

- 이전 mixed shadow developer preview의 `shadowSupportMode = 'any'`는 **deprecated**되며 `shadowSupportMode = 'native'`로 대체된다.
- native/synthetic 확인: `this.template.synthetic`(native에서 `undefined`, synthetic에서 `true`).
- 가이드라인: leaf node부터 마이그레이션 권장. 포함된 모든 컴포넌트가 native를 지원할 때만 native로 렌더한다. **base Lightning component를 포함하면 `shadowSupportMode = 'native'`를 설정하지 말 것**(base 컴포넌트는 아직 native 미지원).

#### `wave-wave-dashboard-lwc` (Beta)

Lightning Experience 페이지(Home, Accounts, Opportunities) 및 다른 LWC에 CRM Analytics dashboard를 임베드한다. header·title visibility 등 customization parameter를 제공한다. (Beta Service)

### 그 외 변경

#### Native Shadow 준비 — 추가 컴포넌트 (전수)

Spring '23 이후 33개 컴포넌트가 native shadow 준비를 완료했으며, Spring '24에서 다음 컴포넌트가 추가됐다. protected internal DOM 구조에 의존하는 테스트는 즉시 재작성해야 한다(UTAM·UTAM Page Objects, Selenium은 Webdriver Shadow DOM). base 컴포넌트는 Mixed Shadow Mode(Developer Preview)를 미지원한다.

`lightning-alert`, `lightning-badge`, `lightning-button-group`, `lightning-confirm`, `lightning-formatted-address`, `lightning-formatted-date-time`, `lightning-formatted-email`, `lightning-formatted-location`, `lightning-formatted-phone`, `lightning-formatted-rich-text`, `lightning-formatted-text`, `lightning-formatted-time`, `lightning-formatted-url`, `lightning-input-address`, `lightning-input-name`, `lightning-input-location`, `lightning-input-rich-text`, `lightning-layout`, `lightning-layout-item`, `lightning-menu-subheader`, `lightning-modal`, `lightning-modal-body`, `lightning-modal-footer`, `lightning-modal-header`, `lightning-prompt`, `lightning-rich-text-toolbar-button`, `lightning-rich-text-toolbar-button-group`, `lightning-toast`, `lightning-toast-container`.

> 별도로 `lightning-input`의 내부 DOM 구조도 native shadow 준비를 위해 변경됐다(protected internal DOM 의존 테스트 재작성 필요).

#### ARIA Property Reflection 확대

property reflection이 가능한 ARIA 속성이 추가됐다.

- `aria-colindextext` — 숫자 aria-colindex의 human-readable 대체 텍스트
- `aria-rowindextext` — 숫자 aria-rowindex의 human-readable 대체 텍스트
- `aria-description` — 현재 요소 설명
- `aria-braillelabel` — Braille 변환용 string 값
- `aria-brailleroledescription` — Braille 변환용 role의 human-readable, author-localized 축약 설명

```js
import { LightningElement } from 'lwc';
export default class extends LightningElement {
get ariaBrailleLabel() {
return this._ariaBrailleLabel
}
set ariaBrailleLabel(val) {
console.log('I am in the setter!')
this._ariaBrailleLabel = val
}
}
```

`this.aria*` 호출이 가능하며, 브라우저가 ARIA reflection을 미지원하면 `this.ariaBraille*`는 `undefined`를 반환한다. **Safari·Firefox는 ariaBraille* property reflection을 미지원한다.**

#### Lightning Web Security (LWS)

- **API distortion 변경** — 새 distortion 추가: `Selection.prototype.collapse`, `Selection.prototype.extend`, `Selection.prototype.selectAllChildren`, `Selection.prototype.setBaseAndExtent`, `Selection.prototype.setPosition event`. 변경된 distortion: `Document.prototype.execCommand`. 제거된 distortion·ESLint rule: `Element.prototype.attributes getter`, `HTMLIFrameElement.prototype.allowPaymentRequest`·`csp`·`featurePolicy`·`referrerPolicy`.
- **Closed Shadow Root 자동 적용** — LWC가 open shadow root를 생성하면 LWS가 closed로 변경한다(이전엔 error 메시지). closed mode는 shadow root 내부를 JS 조작으로부터 보호한다.

#### 새/변경 컴포넌트 (New and Changed LWC, p.263~266)

| 컴포넌트 | 변경 |
|---|---|
| `lightning-datatable` | 새 attribute `wrap-table-header`(컬럼 너비 초과 시 header text wrap, 최대 3줄, default false). custom data source component를 `customdatatypes` slot으로 child 전달 지원(custom data type을 런타임 context 기반 동적 결정) |
| `lightning-input` | 새 attribute `role`(`role="combobox"` + `type="text"`로 accessible combo box 생성, role의 유일 valid 값은 combobox). aria 속성 추가 전달: `aria-keyshortcuts`, `aria-disabled`, `aria-roledescription`, `aria-autocomplete`, `aria-expanded`. 일부 타입에서 `role="alert"` 제거 |
| `lightning-input-field` | multiple currency org 지원. currency 값 field가 currency symbol 미표시(decimal number 포맷) |
| `lightning-modal` | focus 배치 규칙 변경: header 있으면 title text, header 없으면 modal body 첫 interactive element, interactive element 없으면(또는 tooltip만) close button. 이전엔 항상 modal body 첫 interactive element |
| `lightning-pill` | 키보드 navigation은 Tab key만(arrow key 아님). remove button focus 시 Enter·Spacebar만 활성화(이전엔 Delete·Backspace도) |
| `lightning-pill-container` | 새 attribute `href`(pill에 link 추가). 키보드 navigation Tab key만. remove button Enter·Spacebar만 |
| `lightning-record-form` | multiple currency 지원. currency field currency symbol 미표시(decimal 포맷) |
| `lightning-record-picker` | 새 attribute `field-level-help`, `disabled`. `display-info`에 새 property `primaryField`(default Name) |
| `lightning-tabset` | 새 attribute `heading-label`(default는 h2의 "Tabs"), `heading-level`(1~6, default 2), `heading-visible`(default false). More menu 키보드 navigation에 Tab·arrow key 사용(이전엔 Tab만) |

#### 새/변경 LWC 모듈 (p.266~267)

- **`lightning/industriesEducationPublicApi`** (New) — Industries Education Public API로 mentor·mentee 매칭, Education Cloud record 생성. 새 메서드 `postBenefitAssignment`(Education Cloud Mentoring record 업데이트).
- **`lightning/navigation`** (Changed) — `NavigationMixin.Navigate(pageReference, [replace])`의 `replace` property가 quick action navigation을 변경한다. `replace=false`(default)면 modal로 새 레코드 저장 시 이전 record page로 복귀, `replace=true`면 새 레코드 저장 시 post-save navigation 발생.
- **`lightning/logger`** (GA) — 새 EventLogFile event type(Lightning Logger Event)에 메시지 로깅.
- **`lightning/platformWorkspaceApi`** (GA) — workspace tab/subtab 제어. Lightning Web Security 필수.

#### 새/변경 Aura 컴포넌트 (p.267)

- **`lightning:navigation`** (Changed) — `navigate(pageReference, replace)`의 `replace` property가 quick action navigation을 변경한다. `replace=false`(default)면 modal 저장 시 이전 record page 복귀, `replace=true`면 post-save navigation 발생.

#### 모바일 전용 / 기타

- **`DocumentScanner` API** — device 카메라·OCR로 문서 스캔(Salesforce Mobile·Field Service Mobile 전용, 웹 미지원).
- **`NFCService` API** — device NFC로 NFC 태그 read/erase/write(mobile 전용).
- **LWC Offline Test Harness** — Home tab의 developer-centric 도구를 새 Debug tab으로 이동.

#### 개발 환경 — LWC.studio → StackBlitz

**LWC.studio는 2024년 1월 1일 online IDE를 종료**하며 StackBlitz(https://playground.lwc.dev)로 이전한다. StackBlitz는 third-party 제품이며 SLDS 스타일·base 컴포넌트를 미포함하고, `@salesforce/*` import·LDS wire adapter를 미지원하므로 Salesforce data에 접근할 수 없다.

---

## Visualforce

- **`JsonAccess` Annotation Validation (Visualforce JavaScript Remoting API) (Release Update)** — Visualforce Remoting API가 JS로 Apex controller 메서드를 직접 호출할 때 Apex 클래스의 `JsonAccess` annotation을 검증해 packaging namespace 간 무단 serialization/deserialization을 방지한다. **Winter '23 제공, Spring '24 enforced.** (Lightning Experience·Salesforce Classic 모든 edition. Setup → Release Updates에서 testing·activation 수행.)

> 같은 Release Update가 Apex 섹션(Visualforce Remoting)에도 영향을 미친다. 위 [Apex › Release Update] 참조.

---

## API

API 버전은 **v60.0**이다.

### 신규 / 변경

| 항목 | 내용 |
|---|---|
| **신규 user profile** | `Minimum Access - API Only Integrations` — Salesforce Integration user license와 함께 최소 권한 원칙 적용. Minimum Access - Salesforce profile 기반, API Enabled·Api Only User permission 제공. Spring '24부터 새로 provisioning되는 org에 기존 `Salesforce API Only Systems Integration` profile 미제공. (Integration license는 Enterprise, Unlimited, Performance, Developer editions 기본 제공) |
| **XML 역직렬화 제어** | managed package의 Apex 클래스를 XML deserialization으로 API call 구성 시 `@JsonAccess` annotation으로 명시적 접근 필요. annotation 권한 없이 시도 시 400 응답 + `XML_PARSER_ERROR` 코드. (모든 API 버전) |
| **Metadata API 배포 한도** | SOAP retrieve·REST deployment의 uncompressed folder 최대 크기 **400 MB → 600 MB.** (모든 API 버전) |
| **REST API — DateTime result type** | REST API composite subrequest에 `DateTime` result type 가용(String·Boolean·Byte·Character·Short·Integer·Long·Double·Float에 합류). (Enterprise, Performance, Unlimited, Developer editions) |
| **REST API — MRU 헤더** | `MRU` header로 record 생성·update·upsert·retrieve 시 MRU(Most Recently Used) item 업데이트 여부 제어. SOAP API의 MruHeader와 유사. |
| **REST API — ACCEPT 헤더 JSON 기본값** | Apex REST API HTTP ACCEPT header가 JSON 기본값. missing/malformed 시 JSON 반환(이전엔 에러). valid 값 `application/json`/`application/xml`(case sensitive). (BEHAVIOR CHANGE — 위 Apex 섹션 참조) |

### Bulk API 2.0

- **`isPkChunkingSupported` 신규 (PK chunking 조회)** — "Get Job Info Query" API가 새 Boolean field `isPkChunkingSupported`를 반환해 객체의 PK chunking 지원 여부를 알려준다(이전엔 문서 참조). Winter '24에 PK chunking 지원 객체가 thousands로 증가했다.
- **Query Processing 개선** — 실패한 batch를 더 작은 batch·chunk size로 split해 처리 성공률을 높인다(이전엔 fixed chunk size, 실패 시 retry 후 failed 마킹).

### GraphQL API

GraphQL API에 localized label·locale 정보, object name suffix 충돌 회피, aggregate query referential integrity, page 결과 record 수, polymorphic field displayable 값, upper-bound limit pagination, child relationship pagination이 추가됐다.

- **Localized labels / locale 정보:** `objectInfos`에 새 `locale` argument(default 사용자 locale). `ObjectInfo` type에 새 `locale` field.

```graphql
type UIAPI {
query: RecordQuery
objectInfos(apiNames: [String!]!, locale: String): [ObjectInfo!]
}
```

- **Object name suffix로 collision 회피:** API v60.0+에 추가된 sObject는 `_Record` suffix GraphQL object name으로 매핑된다(예: FeedItem → `FeedItem_Record`). RecordEdge type의 node field도 동일 패턴이다.
- **Aggregate query referential integrity:** object·field 이름이 변경돼도 aggregate query 참조가 정상 검증된다.
- **Page의 record 수:** `RecordConnection` type에 새 `pageResultCount` field(page의 record 수). `totalCount`는 전체 record 수를 유지한다.

```graphql
{
uiapi {
query {
Account(first: 4) {
totalCount
pageResultCount
edges {
node {
Id
}
}
}
}
}
}
```

- **Polymorphic field의 displayable 값:** Record interface의 `DisplayValue` field query 가능(이전엔 polymorphic은 null).
- **Record connection → upper-bound limit pagination 전환:** record connection은 최대 **4,000 records**다. 초과가 필요하면 returned cursor 정보로 `upperBound` argument와 함께 재query한다(이전엔 초기 query에 upperBound 필수였다).

초기 query(2,000 accounts):

```graphql
{
uiapi {
query {
Account(first:2000) {
totalCount
pageInfo {
hasPreviousPage
hasNextPage
startCursor
endCursor
}
edges {
cursor
node {
Id
}
}
}
}
}
}
```

upper-bound limit pagination 전환 query(`after`는 첫 query의 `endCursor`, `upperBound`는 retrieve 한도 — 초기 2,000 요청해도 최대 5,000 반환):

```graphql
{
uiapi {
query {
Account(first:2000, after:"djE6MTk5OQ==", upperBound:5000) {
totalCount
pageInfo {
hasPreviousPage
hasNextPage
startCursor
endCursor
}
edges {
cursor
node {
Id
}
}
}
}
}
}
```

- **Child relationship upper-bound pagination:** parent를 `upperBound`로 query해 child page가 가능하다. parent가 upperBound를 사용하면 child도 사용해야 하며, parent가 미사용해도 child에 upperBound 사용은 가능하다. parent·child 동시 paging은 미지원이며, 큰 upper-bound limit은 성능에 영향을 준다.

### 은퇴

- **Platform API v21.0~30.0 은퇴 (Release Update)** — 최초 Summer '23 → **Summer '25로 연기.** 그때까지 사용 가능하나 미지원이며, Summer '25부터 요청이 실패한다(endpoint deactivated 에러). 영향 버전: **Bulk API / SOAP API / REST API의 v21.0~30.0.** `/services/data/vXX.X/` 이하 모든 REST API(Bulk, Connect REST, IoT REST, Lightning Platform REST, Metadata, Place Order REST, Reports and Dashboards REST, Tableau CRM REST, Tooling API)에 영향. Professional(API 활성화)·Enterprise·Performance·Unlimited·Developer editions, Sandbox·Scratch org 포함 모든 API-enabled org 적용. API Total Usage event로 old/unsupported 버전 요청을 식별할 수 있다.

---

## Packaging

- **`scopeProfiles` 설정 (신규)** — `sfdx-project.json`의 새 `scopeProfiles` setting으로 `sf package version create` 실행 시 새 package version에 포함될 profile setting을 제어한다(unlocked packages, 2GP). `scopeProfiles=true`면 해당 package directory의 profile setting만 포함하고 외부는 무시하며, `false`(default)면 sfdx-project.json의 모든 package directory의 관련 profile setting을 포함한다. `scopeProfiles`는 `packageDirectory`의 child다.

```json
{
"packageDirectories": [
{
"path": "force-app",
"package": "TV_unl",
"scopeProfiles": "true",
"versionName": "ver 0.1",
"versionNumber": "0.1.0.NEXT",
"default": true,
"unpackagedMetadata": {
"path": "my-unpackaged-directory"
}
}
],
"namespace": "",
"sfdcLoginUrl": "https://login.salesforce.com",
"sourceApiVersion": "60.0"
}
```

- **2GP에서 Custom Metadata Type 레코드 제거 (신규, IdeaExchange)** — 2GP에서 custom metadata type의 protected·public record를 제거할 수 있다. 제거 후 subscriber org 동작은 record visibility에 의존한다 — **visible이면 deprecated 마킹, invisible이면 삭제.** deprecated record는 subscriber org limit에 카운트된다. managed package에서 metadata 제거는 Salesforce 승인이 필요하며 Partner Community에 support case를 등록한다.
- **Push Upgrade 대상 org 표시 (변경)** — Package Manager 페이지가 Target Organization 목록에 valid production org만 표시한다(trial·free·active 상태). (1GP)

---

## 개발 환경 / 플랫폼 개발 도구

- **Selective Sandbox Access (신규)** — sandbox refresh/생성 시 public group으로 접근 사용자를 subset으로 제한한다. group 내 사용자는 email 원본 형식을 유지하고, group 외 사용자는 sandbox에서 unfrozen이 필요하다. (Professional·Enterprise·Performance·Unlimited·Database.com editions sandbox. **현재 public group 60개 미만인 production org에서만 활성화.** Manage Sandboxes permission 필요.)
- **Scratch Org Snapshots (Beta)** — scratch org configuration의 point-in-time snapshot을 캡처해 replica를 생성한다. Dev Hub org에서 활성화하고 CLI `org create snapshot`·`org list snapshot`로 관리한다. (Developer·Enterprise·Performance·Unlimited editions)
- **Setup에서 모든 샌드박스 로그인 (변경, IdeaExchange)** — Sandboxes Setup 페이지 login이 sandbox의 My Domain login URL을 사용한다(이전엔 instanced URL).
- **Code Builder (GA)** — 웹 기반 IDE가 generally available.
- **ApexGuru Insights (GA, Scale Center)** — AI/ML로 Apex 클래스·entry point를 분석해 code recommendation을 제공한다. (Scale Center — Unlimited Edition, Signature Success.)
- **Einstein for Developers (Beta)** — CodeGen 기반 AI VS Code extension. 모든 org 기본 활성화.
- **Workbench 대체 권고** — Workbench(open-source)는 미유지보수. Code Builder·Salesforce CLI·VS Code Extensions로 전환 권장.

---

## AppExchange Partners (App Analytics)

- **Trial Org Subscriber Snapshot의 `UsersWithMFA` 미제공 (변경)** — Spring '24에 trial org의 subscriber snapshot에서 `UsersWithMFA` 속성이 미제공된다. active·demo org는 `attribute_name`=UsersWithMFA일 때 `attribute_value`로 MFA 비율을 확인할 수 있다.
- **Custom Interaction 로깅 (신규)** — Apex enum + `IsvPartners.AppAnalytics.logCustomInteraction` 메서드로 custom interaction을 생성한다. `custom_entity_type`=CustomInteractionLabel, `log_record_type`=CustomInteraction으로 필터한다. (security review 통과 managed package ISV partner. Developer Edition.)
- **Cloud Security Website 은퇴** — `https://security.my.salesforce-sites.com/`가 **2024년 early February retiring.** 대체 리소스: ISV Partner Program/Portal, Security Review Documentation/Requirements, Force.com Security Source Code Scanner, Force.com Secure Coding Guidelines, ISV Security Office Hours. 문의 securecloud@salesforce.com.
- **Marketplace Analytics Dashboard 업데이트 / Co-Marketing 리브랜딩 (변경)** — AppExchange Explore traffic source가 시각화에 포함되고, AMP(AppExchange Marketing Program)가 **Partner Co-Marketing Program**으로 리브랜딩됐다. **2024년 3월 26일 이후** AppExchange Categories는 listing activity data를 미캡처한다.
- **AppExchange Lead의 Traffic Source 연관 (변경)** — AppExchange lead의 Description field에 traffic source 상세를 포함하며, lead source data를 text string 대신 **JSON 형식**으로 공유한다. (2024년 4월 30일부터)

```json
{
"lead_description": {
"allow_contact_other_products": true,
"listing_url":
"https://appexchange.salesforce.com/appxListingDetail?listingId=a0NXXXXXXXXXXXXXXX",
"utm_parameters": {
"utm_campaign": "example-campaign",
"utm_content": "example-content",
"utm_medium": "example-medium",
"utm_source": "example-source",
"utm_term": "example-term"
},
"referral_code": "example-code"
}
}
```

---

## Platform Events / Event Bus / Change Data Capture

### Platform Events

- **Uncaught Exception을 Event Log File에서 조회 (변경)** — platform event Apex trigger 실행 중 unhandled exception(uncatchable limit exception, trigger 미catch exception) 정보를 Event Monitoring의 event log file에서 조회할 수 있다. event type은 **Apex Unexpected Exception Event Type (`ApexUnexpectedException`)**이다. (Enterprise·Performance·Unlimited·Developer editions)
- **Streaming API v23.0~36.0 은퇴** — **Winter '25 retirement 예정.** deprecated·미지원이며 v37.0 이상(Durable Streaming) 사용을 권장한다.

### Event Bus

- **Pub/Sub API Managed Subscriptions (Beta)** — managed event subscription으로 subscriber client가 소비한 event를 추적하고, client disconnect 후 마지막 committed Replay ID 이후부터 재개한다. platform event·change event, custom channel, 표준 CDC channel(`ChangeEvents`)을 구독한다. `ManagedEventSubscription`(Tooling API/Metadata API)에서 config한다. (Enterprise·Performance·Unlimited·Developer editions. Non-Hyperforce Public Cloud·Government Cloud 미지원. Beta Service.)

새 bidirectional streaming RPC:

```
rpc ManagedSubscribe (stream ManagedFetchRequest) returns (stream ManagedFetchResponse)
```

추가 Protobuf message: `ManagedFetchRequest`, `ManagedFetchResponse`, `CommitReplayRequest`, `CommitReplayResponse`. client는 `ManagedEventSubscription`의 ID로 `ManagedSubscribe`를 호출한다. subscription ID는 client당 고유하며 동일 org 다른 client와 공유할 수 없다. pull-based로 `ManagedFetchRequest`에서 event 수를 지정하고 `ManagedFetchResponse`로 반환받으며, `CommitReplayRequest` field로 Replay ID를 commit한다.

- **Pub/Sub API Global Endpoint 지역 확대 (변경)** — global endpoint `api.pubsub.salesforce.com:{port}`에 **India region**이 추가됐다(기존 US·EU). (Enterprise·Performance·Unlimited·Developer editions. Government Cloud 미지원.)
- **Event Relay 지역 확대 (변경)** — Event Relay가 **European Union region**에서 처리된다(이전 US만). (Enterprise·Unlimited·Developer editions. Government Cloud 미지원.)

### Change Data Capture

더 많은 객체의 change event를 수신한다(OpportunityLineItem change event는 IdeaExchange 기여). Setup의 Change Data Capture 페이지에서 객체를 선택하거나 custom channel을 생성한다. (Enterprise·Performance·Unlimited·Developer editions)

**change event가 추가된 객체 (전수):**

Accreditation, AssessmentConfiguration, AssessmentEnvelope, AssessmentEnvelopeItem, BoardCertification, CareBarrierDeterminant, CareBarrierType, CareBenefitVerifyRequest, CareBenefitVerifySettings, CareDeterminantType, CareInterventionType, CareLimitType, CarePreauth, CarePreauthItem, CareProviderAdverseAction, CareProviderFacilitySpecialty, CareProviderSearchableField, CareProviderSearchConfig, CareRegisteredDevice, CareTaxonomy, CoverageBenefitItemLimit, DigitalSignature, HealthCareDiagnosis, HealthcareFacilityNetwork, HealthcarePayerNetwork, HealthCareProcedure, HealthcareProviderNpi, HealthcareProviderTaxonomy, LearningItemProgress, OpportunityLineItem, PlanBenefit, PlanBenefitItem, PurchaserPlanAssn, ReceivedDocumentType, TimelineObjectDefinition.

---

## New and Changed Apex Namespaces (전수)

> 깊이 원칙에 따라 "New and Changed Items for Developers"(p.267~274)의 Apex 카탈로그를 전수 기록한다. Development 도메인 직접 관련 외 Commerce·Tax 등 타 도메인 네임스페이스도 카탈로그로 포함한다.

### Auth Namespace

**New Classes:**
- `Auth.Oauth2TokenExchangeHandler` — external IdP token 검증 + OAuth 2.0 token exchange flow 시 Salesforce 사용자 매핑. `validateIncomingToken(appDeveloperName, appType, incomingToken, tokenType)`(access/refresh/ID token·SAML 2.0 assertion·JWT 검증), `getUserForTokenSubject(networkId, result, canCreateUser, appDeveloperName, appType)`(token subject를 사용자에 매핑).
- `Auth.JWTUtil` — `parseJWTFromStringWithoutValidation(incomingJWT)`(header·payload·signature 파싱), `validateJWTWithKeysEndpoint(incomingJWT, keysEndpoint, shouldUseCache)`(remote JWKS endpoint callout으로 검증).
- `Auth.TokenValidationResult` — constructor `TokenValidationResult(isValid, data, userData, token, tokenType, customErrorMsg)`, `getUserData()`.
- `Auth.OauthToken` — `revokeToken(type, AuthToken)`(Salesforce 발행 opaque OAuth token revoke/delete).

**New Enums:** `Auth.OAuth2TokenExchangeType`, `Auth.IntegratingAppType`, `Auth.OauthTokenType`.
**New Exceptions:** `Auth.JWTValidationException`.

### IsvPartners Namespace (신규)

- `AppAnalytics` — overload 메서드 `logCustomInteraction(interactionLabel)`, `logCustomInteraction(interactionLabel, interactionId)`, `logCustomInteraction(interactionLabel, interactionUuid)`. 상세는 [[IsvPartners Namespace]] 참조.

### System Namespace

- **New Class:** `UUID` — `randomUUID()`(v4 UUID 생성, 위 Apex 섹션의 메서드 표 참조).
- **New/Changed Methods:** `Database.insertImmediate()`·`Database.insertAsync()`(non-external object validation), `Database.releaseSavepoint`, `DomainCreator.getSetupHostname()`, `Type.forName()`(invalid namespace 시 null), `UserInfo.getCurrentUvid()`(guest user의 UVID).
- **New Enum 값:** `System.Quiddity`의 새 default `Undefined(UD)`.
- **Changed Enum 값:** `System.DomainType`의 새 값 `SETUP_DOMAIN`(`System.DomainParser`가 Setup 페이지 host domain 표현).

### CommerceOrders Namespace

**New Classes:** `ConfigurationOptionsInput`, `GraphRequest`(constructor), `PlaceOrderExecutor`, `PlaceOrderResult`, `RecordResource`(constructor), `RecordWithReferenceRequest`(constructor). **New Enums:** `ConfigurationInputEnum`, `PricingPreferenceEnum`. 상세는 [[CommerceOrders Namespace]] 참조.

### CommerceTax Namespace

**New Classes (전수):** `AbstractTransactionResponse`, `AddressesResponse`, `AddressResponse`, `AmountDetailsResponse`, `CalculateTaxRequest`, `CalculateTaxResponse`, `ErrorResponse`(constructor), `HeaderTaxAddressesRequest`(constructor), `ImpositionResponse`, `JurisdictionResponse`, `LineItemResponse`, `LineTaxAddressesRequest`(constructor), `RuleDetailsResponse`, `TaxAddressesRequest`(constructor), `TaxAddressRequest`(constructor), `TaxApiException`(constructor), `TaxCustomerDetailsRequest`(constructor), `TaxDetailsResponse`, `TaxEngineContext`, `TaxLineItemRequest`(constructor), `TaxSellerDetailsRequest`(constructor), `TaxTransactionRequest`(constructor).
**New Interface:** `TaxEngineAdapter`(`processRequest`).
**New Enums:** `CalculateTaxType`, `RequestType`, `ResultCode`, `TaxTransactionStatus`, `TaxTransactionType`. 상세는 [[CommerceTax Namespace]] 참조.

### PlaceQuote Namespace

**New Classes:** `ConfigurationOptionsInput`, `GraphRequest`(constructor), `PlaceQuoteExecutor`·`PlaceQuoteRLMApexProcessor`, `PlaceQuoteException`, `PlaceQuoteResponse`, `RecordResource`(constructor), `RecordWithReferenceRequest`(constructor). **New Enums:** `ConfigurationInputEnum`, `PricingPreferenceEnum`. 상세는 [[PlaceQuote Namespace]] 참조.

### Compression Namespace (Developer Preview)

**New Classes:** `ZipWriter`(`getArchive()`), `ZipReader`(`extract(ZipEntry entry)`/`extract(String name)`), `ZipEntry`(`getcontent()`, `getName()`, `getCompressedSize()` 등). **New Enums:** `Level`, `Method`. **New Exception:** `compression.ZipException`. 상세는 [[Compression Namespace]] 참조.

### FormulaEval Namespace (Developer Preview)

**New Classes:** `FormulaBuilder`(`withFormula`, `withReturnType`, `withType`, `withGlobalVariables`, `treatNumericNullAsZero`, `builder()`, `build()`), `FormulaInstance`(`evaluate()`). **New Enums:** `FormulaReturnType`, `FormulaGlobal`.

### ConnectApi (Connect in Apex)

> ConnectApi 하위 항목은 Chatter·Commerce·Data Cloud·Einstein·Order Management·Salesforce CMS·Salesforce Scheduler 등 여러 클라우드 도메인에 걸쳐 있다. Development 도메인 직접 관련은 아니나 카탈로그의 일부이므로 핵심만 기록한다.

- *Chatter*: `ConnectApi.ChatterFeeds`의 일부 overload(`getFeed`, `getFeedElementsFromFeed`, `getFeedWithFeedElements`, `searchFeedElementsInFeed`)가 isolated feed·post·comment 지원(admin만 보임).
- *Commerce*: `ConnectApi.CommerceCart`에 `cloneCart`, `getProductCartItem`, `getProductCartItems`, `preserveGuestCart` 추가. `ConnectApi.CommerceStorePricing.getProductPrices`는 제거(어떤 버전에서도 미가용).
- *Data Cloud*: `ConnectApi.CdpSegment`에 `deactivateSegmentByApiName`, `deactivateSegmentById`(v59.0 도입).
- *Einstein*: 새 `ConnectApi.EinsteinLLM`의 `generateMessagesForPromptTemplate`.
- *Order Management*: `ConnectApi.Exchanges`에 `previewCartToExchangeOrder`/`submitCartToExchangeOrder`, `ConnectApi.OMSAnalytics`에 `productsReturnRate`.
- *Salesforce CMS*: `ConnectApi.ManagedContent`에 `publish`/`unpublish`/`createManagedContent`/`replaceManagedContentVariant`/`deleteManagedContentVariant` 등.
- **Changed Enums:** `ConnectApi.CartType`(`PayNowReadOnly`), `CredentialAuthenticationProtocol`(`Basic`), `CredentialAuthenticationProtocolVariant`(`ClientCredentialsClientSecretBasic`), `FeedEntityStatus`(`Isolated`), `FeedType`(`Isolated`).

---

## 거버너 한도 변경 (표)

| 항목 | 변경 내용 |
|---|---|
| `Database.rollback(Savepoint)`, `Database.setSavepoint()` | DML **row** limit 미카운트(Spring '24~, 모든 API 버전). 단 DML **statement** limit에는 카운트 |
| External object DML (`insertImmediate`/`insertAsync` 등) | DML statement·record limit 미증가 |
| Metadata API 배포 최대 크기 | 400 MB → 600 MB (SOAP retrieve·REST deploy) |
| `lightning-record-picker` 조회 최대 건수 | 50건 → 100건 |
| GraphQL record connection | 최대 4,000 records → `upperBound` argument로 최대 5,000 records |

> PDF 원문: *"The number of DML statements you can run is unaffected, but `Database.rollback(Savepoint)` and `Database.setSavepoint()` no longer count against the DML row limit."* (Spring '24부터, 모든 API 버전)

---

## 은퇴/폐기 일정

| 항목 | 일정 |
|---|---|
| **Salesforce Functions** | 2025년 1월 31일 retiring |
| **LWC.studio (online IDE)** | 2024년 1월 1일 종료 → StackBlitz 이전 |
| **Cloud Security Website** | 2024년 early February retiring |
| **Streaming API v23.0~36.0** | Winter '25 retirement |
| **Platform API v21.0~30.0** (Bulk/SOAP/REST) | Summer '25로 연기 |
| **`shadowSupportMode = 'any'`** | deprecated → `'native'`로 대체 |
| **`enableXssProtection`** (SecuritySettings, Metadata API) | API v60.0에서 deprecated → CSPTrustedSite metadata type 사용 |
| **`ConnectApi.CommerceStorePricing.getProductPrices`** | REMOVED(어떤 버전에서도 미가용) |

---

## 관련 노트

- [[Spring '24]] — 상위 릴리즈 허브
- [[Spring '24/Einstein]] — Prompt Builder GA·ConnectApi.EinsteinLLM·capabilityType invocable·PromptFlow 개발자 통합의 기능 맥락
- [[Spring '24/Automation]] — `@InvocableMethod` `capabilityType`(Apex)과 연결되는 Template-Triggered Prompt Flow의 Flow 쪽 구성
- [[Spring '24/Release Updates]] — 강제 적용 항목 spoke
- [[Release MOC]]
- [[Governor Limits]] — 거버너 한도 일반 참조
- [[Compression Namespace]] — Apex Zip 압축(Spring '25 GA)
- [[CommerceOrders Namespace]]
- [[CommerceTax Namespace]]
- [[PlaceQuote Namespace]]
- [[IsvPartners Namespace]] — AppExchange App Analytics Apex
