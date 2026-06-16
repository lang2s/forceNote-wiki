---
tags: [release, summer_24, development, apex, lwc, api]
source: salesforce_summer24_release_notes.pdf
created: 2026-06-16
aliases: [Summer '24 Development, 서머 24 개발, Apex LWC API v61]
---

# Summer '24 — Development (Apex · LWC · API)

> 허브: [[Summer '24]]
> Summer '24(API v61.0, LWC OSS v6.0.0 대응)의 개발자 영역 전수 정리 — Apex Cursors·Dynamic Formula·Data Cloud SOQL/Mock·5단계 관계 쿼리·Private Method Override 방지·ApexTestResult @testSetup, LWC URL-Addressable·Utility Bar API·Third-Party Web Components Beta·Light DOM Slot Forwarding·ElementInternals, API v61.0 updateOnly·OpenAPI Spec sObjects Beta·Connect REST rate limit·My Domain Login URL·SOQL 에러 코드, Pub/Sub Managed Subscriptions Beta·Publishing Stream Timeout, Packaging 2GP Data Cloud·Async Validation·External Client Apps, 거버너 한도 변경과 은퇴 일정.

---

**Maturity legend:** GA=Generally Available · Beta · Pilot · DevPrev=Developer Preview · RU=Release Update · 변경=Enhancement.
*(Summer '24 릴리즈 노트는 `(GA)` 약어를 쓰지 않고 `(Generally Available)`로 풀어 쓴다.)*

---

## 개요

이 노트는 Summer '24 릴리즈 노트의 **Development 섹션(printed p.230~312)**을 Apex·LWC·API 축으로 정리한 spoke다. 깊이 원칙에 따라 네임스페이스별 신규 클래스/메서드/enum, 컴포넌트별 변경, API 카탈로그를 전수 기록한다.

| 항목 | 값 |
|---|---|
| API 버전 | v61.0 |
| LWC API 버전 | 61.0 (= LWC OSS v6.0.0) |
| 출시 | 2024년 06월 |

**Development 섹션 페이지 매핑 (printed page = physical − 4):**

| 서브섹션 | printed page |
|---|---|
| Lightning Components (LWC) | p.232~239 |
| Visualforce | p.240~241 |
| Apex | p.242~251 |
| API / Metadata API | p.252~254 |
| Packaging | p.255~256 |
| Development Environments (Sandboxes/Scratch Orgs) | p.257~260 |
| Development Tools (CLI/VS Code/Code Builder) | p.261~263 |

- 상위 허브: [[Summer '24]]
- 강제 적용 항목(Release Updates): [[Summer '24/Release Updates]]
- 거버너 한도 일반 참조: [[Governor Limits]]

> **시각 자료 안내(Pattern C):** researcher 추출 시 pdftotext에 `Syntax Error: Missing 'endstream'` 등 경고가 있었으나 본문 텍스트·코드 블록은 모두 정상 추출됐다. 이 Development 챕터는 코드 블록·표 위주로 다이어그램/이미지 자료가 사실상 없다. UI API의 "Deprecated Resources" 표는 셀 단위로 풀려 추출됐다.

---

## Apex

> 출처: printed p.242~252 (narrative), New & Changed Apex p.278~283.
> 섹션 인트로(p.242): *"Use new Apex cursors to break up the processing of a SOQL query result... Formula evaluation in Apex is now in beta. Use SOQL in Apex and mock SOQL tests for Data Cloud objects. ... Apex now supports SOQL relationship queries that traverse up to five levels of parent-child records."*

### 신규

#### Use Cursors for Expanded SOQL Query Result Support (Beta)

SOQL 쿼리 결과 처리를 단일 트랜잭션에서 처리 가능한 조각으로 분할한다. 앞/뒤로 traverse 가능하며 batch Apex의 대안이고, queueable Apex job 체인에서도 사용할 수 있다.

- **Where:** all editions. Beta Service note (피드백은 Trailblazer Community).
- **How:** Apex cursor는 stateless다. `Cursor.fetch(integer position, integer count)`의 offset부터 결과를 반환한다. cursor는 `Database.getCursor()` 또는 `Database.getCursorWithBinds()`에서 SOQL이 실행될 때 생성된다. 커서당 최대 행은 **5천만(sync·async 모두)**. `Cursor.getNumRecords()`는 cursor row 수를 반환한다.
- 새 System exception: `System.FatalCursorException`, `System.TransientCursorException`(TransientCursorException은 재시도 가능).
- Apex cursor의 만료 한도는 API Query cursor와 동일하다.

**새 Limits 메서드 (전수):**
- `Limits.getApexCursorRows()` / upper bound `Limits.getLimitApexCursorRows()`
- `Limits.getFetchCallsOnApexCursor()` / upper bound `Limits.getLimitFetchCallsOnApexCursor()`

**갱신된 거버너 한도 4종 (전수):**
- 커서당 최대 행: **50 million** (sync·async 모두)
- 트랜잭션당 최대 fetch 호출: **10** (sync·async 모두)
- 일일 최대 cursor 수: **10,000** (sync·async 모두)
- 일일 최대 행 수(aggregate limit): **100 million**

```apex
public class QueryChunkingQueuable implements Queueable {
private Database.Cursor locator;
private integer position;
public QueryChunkingQueuable() {
locator = Database.getCursor
('SELECT Id FROM Contact WHERE LastActivityDate = LAST_N_DAYS:400');
position = 0;
}
public void execute(QueueableContext ctx) {
List<Contact> scope = locator.fetch(position, 200);
position += scope.size();
// do something, like archive or delete the scope list records
if(position < locator.getNumRecords() ) {
// process the next chunk
System.enqueueJob(this);
}
}
}
```

#### Evaluate Dynamic Formulas in Apex (Beta)

dynamic formula가 이제 SObject를 context object로 사용할 수 있다. 새 `Formula.builder()` 메서드가 FormulaBuilder instance를 생성한다. `getReferencedFields()`는 formula가 참조하는 field 이름 list를 반환한다. character limit에는 묶이나 compile size limit에는 묶이지 않는다.

- **Where:** all editions. Beta Service note (Trailblazer Community 피드백).

```apex
FormulaEval.FormulaInstance likelyBuyer = Formula.builder()
.withType(Account.SObjectType)
.withReturnType(FormulaEval.FormulaReturnType.BOOLEAN)
.withFormula('AnnualRevenue > 10000 AND ISPICKVAL(Industry, "Biomechanical")');
```

> SEE ALSO: Apex Reference Guide — FormulaEval Namespace. 상세는 [[FormulaEval Namespace]] 참조.

#### Use SOQL in Apex with Data Cloud Objects

static SOQL이 이제 Data Cloud data model object(DMO)와 함께 지원된다 — dynamic SOQL이나 ConnectAPI의 대안이다. `Database.QueryLocator` 또는 FOR loop를 사용하는 SOQL은 **API v61.0+**에서 지원된다. 61.0 이전 버전에서는 첫 **201 records**만 반환된다. Batch Apex는 **QueryLocator 사용 시 DMO에 대해 blocked**, 단 **Iterable 사용 시 supported**다.

- **Where:** all editions.
- **Warning:** DMO에 대한 SOQL 실행은 Data Services credit을 소비할 수 있다. FOR loop·query locator·recursion 사용 시 주의.

```apex
//Static SOQL example
List<UnifiedIndividual__dlm> unifiedIndividuals = [
SELECT
Id,
ssot__FirstName__c,
ssot__LastName__c,
ssot__Email__c,
ssot__SkyMilesBalance__c,
ssot__MedallionStatus__c
FROM UnifiedIndividual__dlm
WHERE ssot__CompanyId__c = :companyId
];
```

> **Field- and Record-Level Access 고려:** 모든 data space의 DMO는 Apex에서 **system mode**로 접근 가능하다(data space에 대한 explicit permission set 없이도). data space 접근 권한이 있으면 read-only object-level access check가 지원된다. **field-level security 또는 record-level access control은 지원되지 않는다.** `WITH USER_MODE`·`WITH SECURITY_ENFORCED`·describe call·`Security.stripInaccessible()`은 DMO에 대해 object-level access만 체크할 수 있다. API v61.0부터 특정 DMO에 `SObjectType.getDescribe()`를 사용한다. `Schema.getGlobalDescribe()`로 DMO를 discover할 수 없으며, 대신 알려진 DMO API name으로 `Schema.describeSObjects(List<String>)`를 사용한다.

#### Mock SOQL Tests for Data Cloud Objects

새 SOQL stub 메서드와 새 test class로 DMO의 SOQL query 응답을 mock한다. DMO에 대한 static·dynamic SOQL을 testing context에서 mock record로 반환한다.

- **Where:** all editions.
- **How:** 새 `System.SoqlStubProvider` class를 extend하고 `handleSoqlQuery()` class method를 override해 mock test class를 만든다. `Test.createStubQueryRow()` 또는 `Test.createStubQueryRows()`로 DMO instance를 생성한다. `Test.createSoqlStub()`로 mock provider를 등록한다.
- Note: stub된 record에도 Apex governor limit이 적용된다. SOQL query는 DMO에 대한 것이어야 한다(직접 FROM 또는 subquery).
- **stub 구현 내에서 허용되지 않는 것 (전수):** SOQL, SOSL, Callouts, Future methods, Queueable jobs, Batch jobs, DML, Platform Events.

```apex
@IsTest
public class SkyMilesForBusinessOptInController_Test {
@IsTest
public static void mockSoql() {
SoqlStubProvider stub = new UnifiedIndividualSoqlStub();
Test.createSoqlStub(UnifiedIndividualSoqlStub__dlm.sObjectType, stub);
Assert.isTrue(Test.isSoqlStubDefined(UnifiedIndividualSoqlStub__dlm.sObjectType));

Test.startTest();
string companyId = 'SampleCompanyId';
// Performs SOQL query against Data Model Object
List<SkyMilesMember> members =
SkyMilesForBusinessOptInController.getSkyMilesProfilesFromDataCloud(companyId);
Test.stopTest();
Assert.areEqual(1, members.size());
SkyMilesMember member = members[0];
Assert.areEqual(companyId, member.CompanyId);
Assert.areEqual(5000, member.SkyMilesBalance);
}
class UnifiedIndividualSoqlStub extends SoqlStubProvider {
public override List<sObject> handleSoqlQuery(sObjectType sot, string stubbedQuery,
Map<string, object> bindVars) {
Assert.areEqual(UnifiedIndividual__dlm.sObjectType, sot);
// Stub assumes that the SOQL query is searching for a single record by company
id
string companyId = 'Default';
if(bindVars.containsKey('tmpVar1')) {
companyId = (string)bindVars.get('tmpVar1');
}
UnifiedIndividual__dlm dmo = (UnifiedIndividual__dlm)Test.createStubQueryRow(
sot,
new Map<string, object> {
'ssot__FirstName__c' => 'Codey',
'ssot__LastName__c' => 'Bear',
'ssot__Email__c' => 'developer@salesforce.com',
'ssot__SkyMilesBalance__c' => 5000,
'ssot__MedallionStatus__c' => 'Gold',
'ssot__CompanyId__c' => companyId
}
);
return new List<sObject> { dmo };
}
}
}
public with sharing class SkyMilesForBusinessOptInController {
public static List<SkyMilesMember> getSkyMilesProfilesFromDataCloud(String companyId)
{
List<UnifiedIndividual__dlm> unifiedIndividuals = [
SELECT
Id,
ssot__FirstName__c,
ssot__LastName__c,
ssot__Email__c,
ssot__SkyMilesBalance__c,
ssot__MedallionStatus__c,
ssot__CompanyId__c
FROM UnifiedIndividual__dlm
WHERE ssot__CompanyId__c = :companyId
];
List<SkyMilesMember> skyMilesMembers = new List<SkyMilesMember>();
for (UnifiedIndividual__dlm individual : unifiedIndividuals) {
skyMilesMembers.add(
new SkyMilesMember(
individual.Id,
individual.ssot__FirstName__c,
individual.ssot__LastName__c,
individual.ssot__Email__c,
individual.ssot__SkyMilesBalance__c,
individual.ssot__MedallionStatus__c,
individual.ssot__CompanyId__c
)
);
}
return skyMilesMembers;
}
}
```

#### Support for Five-Level Parent-to-Child Relationship SOQL Queries in Apex

Apex가 이제 **5단계**까지 parent-child record를 traverse하는 SOQL relationship query를 지원한다. 각 parent-child relationship subquery는 처리된 aggregate query 수에 카운트된다.

- **Where:** all editions.
- **How:** API v61.0+에서 parent root가 첫 level + parent root로부터 **four levels deep**까지 child relationship. `Limits.getAggregateQueries()`로 추적한다. `Limits.getLimitAggregateQueries()`는 **300**(SOQL statement 포함 총 aggregate query)을 반환한다.

```apex
List<Account> accts =
[SELECT Name,
(SELECT LastName,
(SELECT AssetLevel,
(SELECT Description,
(SELECT LineItemNumber FROM WorkOrderLineItems)
FROM WorkOrders)
FROM Assets)
FROM Contacts)
FROM Account];
```

#### Make Invocable Actions Easier to Configure with New InvocableVariable Modifiers

새 `defaultValue` modifier가 input parameter의 default 값을 설정한다. 새 `placeholderText` modifier가 custom placeholder text + 예시/가이드를 설정한다. 둘 다 invocable method에 대응하는 Action element의 Flow Builder에 나타난다.

- **Where:** Lightning Experience·Salesforce Classic in Performance, Unlimited, Developer, Enterprise, Database.com editions.

#### IdeaExchange Delivered: Monitor Apex Scheduled Jobs More Efficiently

사용된 scheduled job의 percentage를 추적한다. All Scheduled Jobs 페이지에서 Apex job을 scheduling하고, cron expression으로 scheduled된 job을 관리하며, details list에서 CronTrigger object의 ID를 조회한다.

- **Where:** all editions.
- **How:** Setup → Scheduled Jobs → All Scheduled Jobs 페이지가 현재 소비 통계 + 허용 org limit을 표시한다.

### 변경

- **Update the API Version of Abstract or Virtual Classes to Prevent Overriding Private Methods (v61.0)** — API v61.0+에서 private method는 subclass의 동일 signature instance method에 의해 **더 이상 override되지 않는다.** Versioned. private method를 포함한 abstract/virtual class를 v61.0+로 업데이트한다. API v60.0 이하에서는 subclass instance method가 동일 signature의 private method를 override했다. (all editions)
- **IdeaExchange Delivered: Monitor Setup Methods Using ApexTestResult** — `@testSetup`으로 실행된 Apex test에 대해 `ApexTestResult` 행이 이제 생성된다. 새 **IsTestSetup** 컬럼이 true로 설정된다. `ApexTestRunResult`의 새 **TestSetupTime** 컬럼이 모든 setup method의 누적 시간을 추적한다(TestTime이 test method를 추적하듯). Opt out: Setup → Apex Settings → "Do not create Apex test results for @TestSetup methods"; 또는 Metadata API `ApexSettings`의 `enableTestSetupSkipTestResults` 옵션. (all editions)
- **View CronTrigger and Batch Job IDs in Improved Error Messages with Scheduled and Batch Apex** — scheduled/batch job이 사용하는 class를 삭제할 때 error message에서 CronTrigger·batch job ID를 본다. batch job이 사용하는 class를 포함한 package를 uninstall할 때 error에 Apex batch job ID가 포함된다. 최대 **five IDs**까지 나열한다. batch job이 사용하는 class를 modify할 때 error에 AsyncApexJob ID가 포함된다. (all editions)
- **Ensure More Secure Compilation of Apex Classes** — Setup의 Apex Classes 페이지의 "Compile all classes"가 더 신뢰할 수 있는 compilation을 달성한다(metadata deployment / on-demand compilation 대비 일관된 출력). 이전에는 org가 접근 권한이 없는 Salesforce entity를 참조하는 class를 compile할 수 있었으나, 이제 `Invalid Type: SomeEntity` 같은 compilation error가 발생한다. (all editions)
- **See Improved Logging When FOR UPDATE Locks Are Released** — `FOR UPDATE`로 얻은 record lock이 `Database.setSavePoint()`로 설정한 savepoint로 rollback될 때 자동 release되며, 이제 debug log에 기록된다(database category message가 가장 최근 lock된 entity type을 포함). 예: `FOR_UPDATE_LOCKS_RELEASE | FOR UPDATE locks released due to a savepoint rollback. The most recent lock was Account.` (all editions)
- **Resolve Unhandled Exceptions Faster with Additional Information in Apex Exception Emails** — Apex exception email이 이제 exception이 발생한 **org name**과 **My Domain name**을 포함한다. 이전에는 Apex stack trace, exception message, customer org·user ID만 포함했다. (all editions)
- **See Improved Behavior with Custom Exceptions** — API v61.0+에서 custom exception의 override된 `equals()`·`hashcode()` method가 올바르게 처리된다. Versioned. API 60.0 이하에서는 일부 경우(Set, Map, custom exception instance의 object reference)에서 호출되지 않았다. (all editions)
- **Support for Standard Fields in the getRelationshipOrder Method** — standard field에 대한 `DescribeFieldResult.getRelationshipOrder`가 이제 primary relationship field면 **0**, secondary relationship field면 **1**을 반환한다. Versioned. API 60.0 이하에서는 standard field에 대해 항상 **null**을 반환했다. (all editions)
- **EventBus.publish — non-platform-event 시 예외** — `EventBus.publish(event)`와 `EventBus.publish(events)`가 platform event가 아닌 sObject를 publish할 때 이제 `System.UnexpectedException`을 반환한다.

### Deprecated / 폐기

- **Data Cloud DMO — FLS·record-level access 미지원** — DMO는 Apex에서 system mode로 접근되며 field-level security 또는 record-level access control이 **지원되지 않는다.** object-level access만 체크 가능하다. (위 [Apex › Use SOQL in Apex with Data Cloud Objects] 참조)

---

## LWC

> 출처: printed p.231~239 (intro/narrative), New & Changed LWC p.274~277.
> 섹션 인트로(p.231): *"Salesforce is modifying internal implementations of components and styles to prepare for SLDS architecture updates. LWC API version 61.0 provides ElementInternals Web API support and several bug fixes. Support for third-party web components is still in beta, and open mode now gives you access to the shadowRoot object. You can also navigate to a URL-addressable component and use the Utility Bar API in LWC."*

### 신규

#### Navigate to a URL-Addressable Lightning Web Component

`lightning__UrlAddressable` target을 사용한다. LWC를 Aura component에 embed할 필요가 더 이상 없다.

- **Where:** Lightning Experience와 모든 mobile version의 custom LWC; Lightning console apps in Enterprise/Performance/Unlimited/Developer editions. **Experience Builder sites에서는 사용 불가**(custom domain·CDN support와 충돌).
- **How:** `.js-meta.xml`에 `lightning__UrlAddressable` target을 포함하고 `<isExposed>`를 true로 설정한다. `<apiVersion>`은 영향이 없으며 earlier/later 모두 가능하다.

```xml
<!-- myComponent.js-meta.xml -->
<?xml version="1.0" encoding="UTF-8" ?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
<apiVersion>59.0</apiVersion>
<isExposed>true</isExposed>
<targets>
<target>lightning__UrlAddressable</target>
</targets>
</LightningComponentBundle>
```

```javascript
// navToComponentWithState.js
import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class NavToComponentWithState extends NavigationMixin(LightningElement) {
navigateToComponent() {
this[NavigationMixin.Navigate]({
// Pass in pageReference
type: 'standard__component',
attributes: {
componentName: 'c__myComponent',
},
state: {
c__propertyValue: '2000',
},
});
}
}
```

- `standard__component` page reference type의 attribute: **componentName** — `namespace__componentName` 형식의 LWC 이름. state object: 임의 key/value; key는 namespace를 포함해야 하고; value는 string이어야 하며; 등록된 namespace가 없으면 default `c__` namespace를 쓴다.

```javascript
// myComponent.js
import { LightningElement, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
export default class MyComponent extends LightningElement {
@wire(CurrentPageReference)
currentPageRef;
@api propertyValue;
get propertyValue() {
return this.currentPageRef.state.c__propertyValue;
}
}
```

- URL 형식: `/lightning/cmp/c__MyComponent?c__mystate=value`

#### Control Utilities Within the Utility Bar

LWC에서 Utility Bar API 메서드를 사용한다.

- **Where:** Lightning Experience in Group, Essentials, Professional, Enterprise, Performance, Unlimited, Developer editions.
- **How:** `lightning/platformUtilityBarApi` 모듈을 import한다. **Lightning Locker와 Lightning Web Service 모두 지원.** `.js-meta.xml`에 `lightning__UtilityBar` target을 포함한다.

**Utility Bar API methods for LWC (Lightning console apps) — 전수:**

| 메서드 | 설명 |
|---|---|
| `enableModal()` | Toggles modal mode for a utility. |
| `enablePopout()` | Toggles pop-out mode on a utility. |
| `getAllUtilityInfo()` | Returns the state of all utilities. |
| `getInfo()` | Returns the state of the current utility. |
| `minimize()` | Minimizes a utility. |
| `onUtilityClick()` | Registers an event handler for the utility. |
| `open()` | Opens a utility or minimizes a utility if it's already open. |
| `updatePanel()` | Specifies a label and icon on the utility panel, and provides a height and width for the panel. |
| `updateUtility()` | Specifies a label and icon on the utility bar, and sets a utility as highlighted. |

- `EnclosingUtilityId()` wire adapter — Lightning console apps에서 가용; enclosing utility의 ID를 반환한다.
- `CurrentPageReference` wire adapter — utility 내 component에서 record context를 retrieve한다.

#### Use Third-Party Web Components in LWC (Beta)

Open mode가 이제 `shadowRoot` object에 대한 접근을 제공한다. beta로 계속된다.

- **Where:** Lightning Experience, Experience Builder sites, 모든 mobile version의 custom LWC. Beta Service note.
- **How:** 많은 third-party web component는 `appendChild`·`adoptedStyleSheets` 등 web API를 호출하기 위해 open shadow root가 필요하다. custom element는 constructor에서 `attachShadow()` web API 메서드를 사용해 shadow root를 생성한다.
- 이전에는 LWS가 open mode를 자동으로 closed mode로 변경했다; closed mode에서는 shadow DOM tree에 대한 JS 접근이 차단되고 `shadowRoot`가 null을 반환한다.

#### ElementInternals Web API Support (LWC API v61.0)

LWC API version 61.0이 새 기능과 여러 bug fix를 제공한다 — ElementInternals Web API support + bug fixes. LWC API 61.0 = LWC OSS의 v6.0.0이다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
<apiVersion>58.0</apiVersion>
</LightningComponentBundle>
```

- **Where:** Lightning Experience, Experience Builder sites, 모든 mobile app version의 custom LWC. apiVersion key는 `.js-meta.xml`에 둔다.
- 주의: LWC API 58.0 이하는 전부 58.0(Summer '23)으로 취급된다(Winter '24부터). 한 버전씩 업그레이드 권장. v6.0.0(off-platform)의 breaking change는 LWC OSS v6.0.0 release notes 참조.

### 변경 (API v61.0 = LWC OSS v6.0.0)

#### Update Your Light DOM Components for Improved Slot Forwarding

LWC API v61.0+에서, shadow DOM `<slot>`으로 content를 forward하는 light DOM `<slot>` element에 `slot` attribute를 설정해야 한다. component를 light DOM `<slot>`에 pass하면 LWC가 component의 `slot` attribute를 제거해 render되지 않게 한다. Jest snapshot에 영향이 있다.

- **Where:** Lightning Experience, Experience Builder sites, 모든 mobile version의 custom LWC + LWC open source.

```html
<!-- container.html -->
<template>
<c-outer>
<span slot="namedSlot">Named slot content</span>
into forwardedSlot
</c-outer>
</template>
<!-- outer.html -->
<template lwc:render-mode="light">
<c-inner>
<slot name="namedSlot" slot="forwardedSlot"></slot>
</c-inner>
</template>
<!-- inner.html -->
<template>
<slot name="forwardedSlot"></slot>
</template>

// Content to pass from namedSlot

// The namedSlot slot

// The forwardedSlot slot
```

rendered output:

```html
<c-outer>
<c-inner>
<span slot="namedSlot">Named slot content</span>
</c-inner>
</c-outer>
```

named light DOM slot 입력:

```html
<template>
<c-light-child>
<div slot='lightSlot'>Slotted content</div>
</c-light-child>
</template>
<!-- c-light-child -->
<template render:mode="light">
<slot name="lightSlot"></slot>
</template>
```

slot attribute 없이 rendered:

```html
<c-light-child>
<div>Slotted content</div>
</c-light-child>
```

CSS selector 가이드:

```html
<!-- Don’t rely on CSS selectors like this -->
const foo = this.querySelector('[slot="foo"]');
<!-- Instead, use lwc:ref -->
<c-child>
<div slot="foo" lwc:ref="foo">hello</div>
</c-child>
```

#### Class and Style Attributes Render with Extra Whitespaces

더 많은 component가 `class`·`style` attribute에 extra whitespace를 render한다(Spring '23 static-element optimization 부작용). 정확한 class로 query하지 말고 whitespace-insensitive selector를 사용한다.

- **Where:** Lightning Experience, Experience Builder sites, 모든 mobile version의 custom LWC + LWC open source.

```javascript
// Don’t do this
document.querySelector('[class="highlight yellow"]')

// Do this instead
document.querySelector('.highlight.yellow')
```

#### Lightning Web Security Enablement Rollout Postponed

Spring '22 이후 Salesforce가 일부 org에서 LWS를 활성화하기 시작했다. 자동 활성화가 **추가 공지가 있을 때까지 연기된다.** 아직 활성화되지 않았다면 sandbox에서 테스트하기 위해 활성화한다. (Lightning Experience, all editions)

#### API Distortion Changes in Lightning Web Security

새 distortion·ESLint rule이 추가되고, 일부 distortion이 변경되며, 하나가 제거된다.

- **Where:** Lightning Experience(all editions), LWR-based Experience Cloud sites, LWS 활성화 시 Aura sites의 LWC.
- **NEW distortions (LWS Distortion Viewer에 문서화):** `Window.requestFileSystem`, `Window.webkitRequestFileSystem`.
- **CHANGED distortions:** `CustomElementRegistry.prototype.define`, `Element.prototype.attachShadow`, `Element.prototype.shadowRoot getter`, `HTMLIFrameElement.prototype.src setter`, `HTMLObjectElement.prototype.data setter`.
- **REMOVED distortion + 연관 ESLint rule:** `ShadowRoot.prototype.mode getter`.

#### Be Aware of Base Lightning Component Internal DOM Structure Changes for Future Native Shadow Support

base Lightning component가 native shadow DOM 채택을 준비하면서 internal DOM structure가 변경된다. 테스트가 이전 internal structure에 의존하지 않아야 한다.

- **Where:** Lightning Experience와 모든 mobile version, all editions.
- Spring '23 이후 62개 component가 적응됐고, Summer '24에 다음 component가 추가로 적응됐다 (전수): `lightning-button`, `lightning-file-upload`, `lightning-formatted-name`, `lightning-formatted-number`, `lightning-navigation`, `lightning-progress-bar`, `lightning-progress-ring`, `lightning-select`, `lightning-textarea`.
- **How:** integration test·Selenium-based test 검토; UTAM / UTAM Page Objects 사용; "Working With Shadow DOM Elements Using Webdriver"; SLDS로 component style.

#### Confirm Your Components Use Supported Design System Customizations (SLDS Customization caution)

Salesforce가 SLDS architecture update를 위해 Lightning component·SLDS style·custom property의 internal implementation을 수정한다. CSS/JS로 Salesforce component의 DOM element를 수정하거나 unit test에서 SLDS class를 target하지 말 것. "Salesforce Component Internals Are Protected" / "SLDS Architecture Updates FAQ" 참조.

- **Where:** Lightning Experience, Experience Cloud sites, 모든 mobile version, all editions.

#### `lightning/platformWorkspaceApi` — Locker + LWS

`lightning/platformWorkspaceApi`가 이제 Lightning Locker와 LWS 모두 지원한다(이전에는 LWS 활성화가 먼저 필요했다).

### 신규 모듈

**New and Changed Modules for LWC (p.276~277):**

- **`lightning/analyticsWaveApi`** — 새 함수:
  - `deleteWaveFolder(folderId)` — 특정 CRM Analytics folder 삭제.
  - `getWaveFolder(folderId, mobileOnlyFeaturedAssets, disableMru)` — CRM Analytics folder를 ID로 요청(optional param).
  - `postWaveFolders(waveFolder)` — CRM Analytics folder 생성.
  - `updatePartialWaveFolder(folderId, folder)` — patch/partial update 적용.
  - `updateWaveFolder(folderId, folder)` — folder 전체 업데이트.
- **`lightning/platformUtilityBarApi`** (New) — LWC Utility Bar API; Lightning Locker와 LWS 모두 지원.
- **`lightning/platformWorkspaceApi`** (Changed) — Lightning Locker와 LWS 모두 지원(이전엔 LWS 먼저 활성화 필요).
- **`experience/mobilePublisherConfigApi`** (Beta) — 새 wire adapter `getNavigationConfig`(Experience Cloud LWR site의 Mobile Publisher에서 hamburger menu·back button 활성/비활성).

#### Changed Lightning Web Components (p.274~276)

| 컴포넌트 | 변경 |
|---|---|
| `lightning-combobox` | 새 a11y: Tab/Enter로 선택; combobox label string이 input·button의 `aria-label`에 사용. Changed attr: `spinner-active`(wrapping div role을 `role="presentation"` → `role="option"`), `required`(error message가 매 focus마다 읽힘) |
| `lightning-datatable` | 새 a11y: unsaved cell 새 색상·assistive text; custom data type이 keyboard nav 지원(`data-navigation="enable"` + `tab-index={internalTabIndex}` 설정); non-td에서 `role="gridcell"` 제거. 새 attr: `aria-describedby`, `data-navigation`, `tabindex`. Changed attr: `aria-selected`(`hide-checkbox-column` 시 모든 tr에서 제거) |
| `lightning-helptext` | 새 a11y: focus 시 Escape로 tooltip dismiss; tooltip 위로 mouse 이동해도 dismiss 안 됨 |
| `lightning-input` | 새 a11y(전체 input): error message에 `role="status"` + `aria-live="polite"`; 새 attr `aria-live`. `type="color"`: hue slider가 input value 반영, SR "Current Color: None Selected", focus 시 hue selector 항상 visible, hex code 읽음; changed attr `aria-disabled`(button+input 모두), `aria-keyshortcuts`(input에 전달), `role`(role="status" 설정 가능). `type="datetime"`: aria-attribute 업데이트(month 다중 announce 방지), date 선택 후 focus가 input으로 복귀, aria-disabled가 date+time 모두에 전달; 새 attr `date-access-key`, `time-access-key` |
| `lightning-input-address` | 새 attr: `show-compact-address`(street를 two input으로; `street-label`·`subpremise-label` 사용), `subpremise`(max 80자; 보조 street 정보; show-compact-address와 함께; submission에 required 아님), `subpremise-label`, `subpremise-placeholder`. Changed attr: `street`(show-compact-address 시 two input, max 80, 두 번째는 subpremise), `show-address-lookup`(first street field = lookup field) |
| `lightning-progress-indicator` | 새 a11y: type="path"면 `role="presentation"`, type="base"면 `role="listitem"`; path type ul이 `aria-labelledby`("Stage:" + 현재 step label)로 render |
| `lightning-progress-step` | 새 a11y: button 대신 `tabindex="0"`의 div 사용; div가 aria-describedby와 title을 동시에 render 안 함. Changed attr: `label`(error step은 assistive text에 "Error" append) |
| `lightning-select` | 새 attr: `aria-describedby`, `aria-labelledby` |
| `lightning-textarea` | 새 attr: `aria-labelledby` |
| `lightning-tree` (Beta) | data를 `key`·`expand` property로 change event에서 동적 추가; dynamic loading으로 성능 개선. Beta Service note |

#### New and Changed Aura Components (p.277)

- **`lightning:inputAddress`** — 새 attr: `showCompactAddress`(street를 two input으로; `streetLabel`·`subpremiseLabel`), `subpremise`(max 80자; 보조 street 정보; showCompactAddress와 함께; required 아님), `subpremiseLabel`, `subpremisePlaceholder`.

### Deprecated

- **Visualforce Section Header escape 기본값 변경** — 새 `description` attribute 동작이 `<apex:sectionHeader>`를 secure by default로 만든다. commonly used·secure HTML element만 평가되며(이전엔 모든 markup 평가), XSS 방지. 새 `escape` attribute로 override한다.
  - **not set** — `description`이 commonly used secure HTML 허용; uncommon HTML element·insecure attribute·모든 JavaScript 제거; 잉여 markup은 plain text로 render.
  - **`true`** — description의 모든 markup이 escape됨; plain text로 보임.
  - **`false`** — 모든 markup 평가. **Warning:** XSS에 취약해진다.
  - Org-wide User Interface 설정: "Set the default value of the escape attribute in `<apex:sectionHeader>` components to false"(Setup → User Interface). **Warning:** 미선택 유지 권장.
  - ISV 권고: 사용하는 모든 `<apex:sectionHeader>`의 `escape` attribute를 명시적으로 설정한다(설정 시 subscriber org 기본값을 override).
- (Visualforce 인트로 p.240) Update References to Visualforce Pages Served on Salesforce.com — third-party cookie 차단 시에도 접근 보장을 위해 unmanaged VF page가 **force.com domain 또는 site domain**에서 served된다. hard-coded reference·link·bookmark·external integration을 업데이트한다. KB "Ensure Access to Your Visualforce Pages in Summer '24 and Winter '25" 참조.

---

## API (v61.0)

> 출처: printed p.248 (intro), p.252~254 (narrative), New & Changed p.287~312.
> 섹션 인트로(p.248): *"Update records using external IDs and interact with an improved OpenAPI spec sObjects REST API. The previously announced retirement of API versions 21.0 through 30.0 of the Salesforce Platform API is delayed until Summer '25."*

### 신규 / 변경

| 항목 | 내용 |
|---|---|
| **REST API — `updateOnly` 파라미터** | external ID 값으로 record를 update한다. 이전엔 external ID로 upsert만 가능했다. URL에 `updateOnly` 파라미터를 추가해 target이 없으면 새 record 생성을 방지한다. composite REST API·composite graph REST API에서도 동작. (API v61.0+) |
| **OpenAPI Spec sObjects (Beta)** | OpenAPI Spec sObjects REST API에 Details page + 더 usable한 응답. Details page는 request state 정보·error 상세를 포함. behavior change(전수): OpenAPI document를 얻으려면 `/locatorID/results`로 끝나는 URI 사용(`/locatorID`로 끝나는 URI 금지); 성공 POST 시 서버는 HTTP **202**(Accepted) + Details page URI·OpenAPI document URI를 담은 JSON body 응답; 6시간 내 1회 초과 요청 → HTTP **429** + error message(이전엔 HTTP 202 + non-error body). Developer Editions·Partner Developer Editions·sandbox·scratch org(API Enabled). Beta Service. (API v61.0+) |
| **Connect REST API — Rate Limit Changes for New Orgs** | Summer '24+ 생성 org의 요청은 per org/per 24-hour Salesforce Platform API rate limit에 카운트된다. Chatter가 필요한 요청만 per user/per application/per hour rate limit 적용. (Lightning Experience·Salesforce Classic·모든 mobile·all editions·all API versions) |
| **Update API Calls to Use Your My Domain Login URL** | API call의 instanced URL을 My Domain login URL로 업데이트한다. instance 변경(org migration/instance refresh) 후 old-instance URL의 API traffic은 더 이상 routing되지 않는다. My Domain login URL은 항상 올바른 instance를 사용한다. **incorrect instanced URL 사용 API traffic은 2024년 10월 12일에 동작 중단.** Setup → My Domain → Current My Domain URL. 예: `https://ap2.salesforce.com/services/Soap/class/DemoService` → `https://mycompany.my.salesforce.com/services/Soap/class/DemoService`. (all API versions) |
| **API Only Integrations profile** | 구식 "Salesforce API Only Systems Integration" user profile을 standard → custom으로 업데이트해 삭제 가능하게 만든다. Spring '24에 "Minimum Access - API Only Integrations" profile로 대체됐다. (Salesforce Integration user license — Enterprise, Unlimited, Performance, Developer editions) |
| **Automatically Migrated Change Sets** | metadata 변경 목록을 보관할 필요가 없다. Salesforce가 org를 instance-to-instance migrate할 때 change set이 자동 migration된다. (all editions) |

> **REST API 추가 항목** — REST API composite subrequest에 `DateTime` result type 가용(String·Boolean 등에 합류). `MRU` header로 MRU(Most Recently Used) item 업데이트 제어(SOAP API MruHeader와 유사). *(이 항목들은 dump의 New&Changed Items reference 영역에 위치하며 Spring '24와 동일 카탈로그 패턴이다.)*

### New and Changed Items reference (p.287~312, 발췌)

- **Development objects (p.289):** 새 `OrgSnapshot` standard object(다른 scratch org 생성에 사용 가능한 scratch org snapshot 조회); `ActiveScratchOrg`·`ScratchOrgInfo`에 새 `Snapshot` field(scratch org이 생성된 org snapshot 판별).
- **Event Monitoring (p.289):** 새 UI Telemetry Resource Timing·UI Telemetry Navigation Timing event type.
- **Security and Identity (p.293~294):** 새 beta event log object 다수(AnalyticsChangeEventLog, ApexCalloutEventLog, ApexExecutionEventLog, ApexUnexpectedExcpEventLog, ApiTotalUsageEventLog, BulkApiEventLog, LightningLoggerEventLog, LoginEventLog, RestApiEventLog, SoapApiEventLog, VisualforceRequestEventLog 등).
- **Metadata API (p.303~307) — Development 관련:** `LightningExperienceSettings.enableStackedModalManagerEnabled`(Enable LWC Stacked Modals RU); `PlatformEventChannel.eventType`(Real-Time Event Monitoring event를 custom channel에 추가); `EventSettings.enableLightningLoggerEvents`(custom LWC logging — Salesforce Shield 또는 Event Monitoring 필요); `DevHubSettings.enableScratchOrgSnapshotPref`(Enable Scratch Orgs for Snapshots); 새 `GenAiFunction`·`GenAiPlanner` type; 다수 `ExtlClntApp*` external client app field.
- **Invocable Actions (p.302):** `deployDataKitComponents`(new, Data Cloud), `transformNlpActionResult`(new), `processDataUsingGenAi`(new), `vlocity_cmt__MediaIntegrationProcedureInvocable`(changed).
- **Tooling API (p.309~310):** `PlatformEventChannel.EventType`; `PackageInstallRequest.SkipHandlers`(`FeatureEnforcement` 지정으로 scratch org package install 시간 단축); `GenAiFunctionDefinition`·`GenAiPlannerDefinition` object.

### SOQL (p.307~309)

- **Changed Error Code:** 새 error code `MALFORMED_QUERY`가 `INVALID_QUERY_FIILTER_OPERATOR`를 **대체**한다. *(원문 verbatim 스펠링 "FIILTER")*
- **Changed Functionality:** Negative currency value를 지원한다. 예: `SELECT Name FROM Invoice__c WHERE Balance__c < USD-500`.
- **Changed Error Messages (verbatim Old/New, 전수):**

```text
SELECT Id FROM Account USING everything
  Old: unexpected token: '<EOF>'
  New: unexpected token: 'everything'

SELECT ParentId, Value FROM InteractionRefOrValue WHERE ParentId IN ()
  Old: unexpected token: ')'
  New: unexpected token: 'ParentId IN ()'

SELECT FROM ServicePresenceStatus
  Old: unexpected token: 'FROM'
  New: unexpected token: 'SELECT FROM'

SELECT Id from $casecomment WHERE isdeleted = false
  Old: line 1:15 no viable alternative at character '$'
  New: line 1:15 unexpected token: '$'

SELECT lastmodifieddate, companyna fr$om user
  Old: unexpected token: user
  New: missing value at 'user'

SELECT annualrevenue , parentid FROM Account
WHERE (isDeleted = false AND NumberOfEmployees != 100)
OR (isDeleted = false AND Site = '999')
AND ParentId = '000000000000000' LIMIT 50000 OFFSET 0
  Old: unexpected token: AND
  New: unexpected token: 'AND'

SELECT Id, HP_Lead_ID__c,ResponseId__c, Status, ... FROM Lead
WHERE RecordType.name='Commercial'
AND ProductFamily__c<>'IA – Software'
AND Company LIKE '%GM%' OR Domain__c='gm.com'
  Old: unexpected token: OR
  New: unexpected token: 'OR'

SELECT Id, Name, Country__c, State__c, City__c, PAN_Number__c
FROM Account WHERE PAN_Number__c LIKE NULL AND Name LIKE '%a%'
  (Using NULL literals in WHERE with LIKE)
  Old: invalid operator
  New: unexpected token: 'OR'

SELECT convertCurrency(calendar_year(convertTimezone(lastmodifieddate))) FROM account
  (More than two nested functions)
  Old: expecting a right parentheses, found '('
  New: unexpected token: '('

SELECT Id FROM Account WHERE SystemModstamp > 2020-12-12t12:12:00-25:00
  Old: line 1:67 mismatched character '5' expecting set '0'..'3'
  New: Invalid datetime: 2020-12-12t12:12:00-25:00

SELECT Id FROM Account WHERE SystemModstamp > 2020-52-12t12:12:00-05:00
  Old: line 1:51 no viable alternative at character '5'
  New: Invalid datetime: 2020-52-12t12:12:00-05:00

SELECT Id FROM Account WITH SECURITY_ENFORCED
  (WITH SECURITY_ENFORCED without proper Apex context)
  Old: SECURITY_ENFORCED not allowed in this context
  New: rule soqlWithIdentifierClause failed predicate:
       {this.helper.allowApexSyntax() && this.helper.hasApexContext()}?
```

### 은퇴

> 자세한 강제 적용 일정은 [[Summer '24/Release Updates]] 참조.

- **Salesforce Platform API Versions 21.0~30.0 Retirement (Release Update)** — 최초 Summer '23 → **Summer '25로 연기.** 사용 가능하나 미지원이며, Summer '25부터 요청 실패("endpoint is deactivated"). 영향 버전: **Bulk API / SOAP API / REST API의 21.0~30.0.** `/services/data/vXX.X/` 이하 모든 REST API(Bulk, Connect REST, IoT REST, Lightning Platform REST, Metadata, Place Order REST, Reports and Dashboards REST, Tableau CRM REST, Tooling API). Professional(API enabled)·Enterprise·Performance·Unlimited·Developer editions, Sandbox·Scratch org 포함. API Total Usage event로 old/unsupported 버전 요청 식별.
- **Standard-Volume Platform Events 은퇴** — legacy custom event, **Summer '25 retirement 예정.** Spring '19(API v45.0) 이후 high-volume platform event만 definable. high-volume으로 대체 필요.
- **Streaming API Versions 23.0~36.0 은퇴** — **Winter '25 retirement 예정.** deprecated·미지원. v37.0 이상(Durable Streaming) 사용 권장.
- **Salesforce Functions 은퇴** — **2025년 1월 31일 retiring.** 대체 솔루션으로 migration 필요.

---

## Pub/Sub API / Event Bus

> 출처: printed p.264~268 (Change Data Capture, Platform Events, Event Bus).

### Pub/Sub API (Event Bus)

- **Manage Your Event Subscriptions with Pub/Sub API (Beta)** — managed event subscription이 소비한 event를 추적하고 client disconnect 후 마지막 committed Replay ID 이후부터 subscription을 재개한다. 새 `ManagedSubscribe` RPC method가 마지막 committed Replay ID 이후 재개한다. **Where:** Enterprise, Performance, Unlimited, Developer editions. **Pub/Sub API는 Government Cloud에서 사용 불가.** Beta Service note. **How:** `ManagedEventSubscription`(Tooling API 또는 Metadata API)에서 config.

```protobuf
rpc ManagedSubscribe (stream ManagedFetchRequest) returns (stream ManagedFetchResponse)
```

추가 Protobuf message (전수): `ManagedFetchRequest`, `ManagedFetchResponse`, `CommitReplayRequest`, `CommitReplayResponse`. client는 `ManagedEventSubscription`의 ID로 `ManagedSubscribe`를 호출한다. subscription ID는 client당 고유하며 동일 org 다른 client와 공유 불가. pull-based로 `ManagedFetchRequest`에서 event 수를 지정하고 `ManagedFetchResponse`로 반환받으며, `ManagedFetchRequest`의 `CommitReplayRequest` field로 Replay ID를 commit한다.

- **Keep the Pub/Sub API Publishing Stream Alive More Easily** — `PublishStream` RPC method의 timeout이 **60초 → 30분**으로 증가한다(마지막 PublishRequest 전송 또는 마지막 PublishResponse 기준). **Where:** Enterprise, Performance, Unlimited, Developer editions(Government Cloud 미지원).
- **Generate a Client Trace ID to Troubleshoot Non-Pub/Sub API Errors** — RPC ID가 없는 error를 위해 모든 RPC request에 custom `x-client-trace-id` metadata header(authorization header에 포함)를 사용한다. **Where:** Enterprise, Performance, Unlimited, Developer editions(Government Cloud 미지원).
- **Send Real-Time Event Monitoring Events to Amazon EventBridge with Event Relays** — real-time event monitoring event를 이제 event relay로 사용 가능; custom channel을 통해 Amazon EventBridge로 stream. **Where:** Lightning Experience in Enterprise, Performance, Unlimited, Developer editions.
- **AWS Region Validation for Seamless Event Relay Execution** — event relay named credential의 AWS region이 이제 **upper case**로 validate된다; 대문자 아니면 생성 실패. URL 형식 `arn:aws:aws_region:aws_account_number`; 예: `US-WEST-2`(`us-west-2` 아님). **Where:** Lightning Experience in Enterprise, Unlimited, Developer editions.

### Platform Events

- **Add Real-Time Event Monitoring Events to a Custom Channel** — 여러 real-time event monitoring event type을 custom platform event channel을 통해 하나의 stream으로 수신한다. `PlatformEventChannel` metadata type의 새 `eventType` field 설정; Metadata API 또는 Tooling API 사용; `PlatformEventChannelMember`로 event 추가. **최대 3개 custom event monitoring channel, 각 최대 10 member**(real-time event monitoring event 참조). **Where:** Enterprise, Performance, Unlimited, Developer editions.

### Change Data Capture (Receive Change Event Notifications for More Objects)

더 많은 object의 change event를 수신한다. **Where:** Enterprise, Performance, Unlimited, Developer editions.

**change event가 추가된 object (전수):**
- **Industries:** Award, IdentityDocument, InsurancePolicy, PersonEmployment, AuthorNote, CareObservationComponent, CarePerformer, CategorizedCareFeeAgreement, ClinicalAlert, ClinicalDetectedIssue, ClinicalDetectedIssueDetail, ClinicalEncounterFacility, ClinicalEncounterIdentifier, ClinicalEncounterProvider, ClinicalEncounterReason, ClinicalEncounterSvcRequest, ClinicalServiceRequest, ClinicalServiceRequestDetail, DiagnosticSummaryDetail, HealthConditionDetail, Identifier, PatientHealthReaction, PatientImmunizationProtocol, PersonLanguage, PersonName, ProblemDefinition, ResearchStdyCndtStatusPrd.
- **Security and Identity:** AuthorizationForm, AuthorizationFormText, CommSubscription, CommSubscriptionChannelType, EngagementChannelType.
- **Service:** Survey, SurveyPage, SurveyQuestion, SurveyQuestionChoice, SurveyQuestionResponse, SurveyResponse, SurveyVersion.

---

## Packaging

> 출처: printed p.251 (intro), p.255~256.

- **Use Second-Generation Managed Packaging to Build Data Cloud Apps** — 2GP의 모든 이점을 Data Cloud feature에 적용한다. Data Cloud metadata를 packaging할 때 먼저 **data kit**에 추가한 뒤 data kit을 package에 추가한다. Data Cloud app은 오직 Data Cloud metadata만 포함해야 한다. **Where:** second-generation managed packages. **When:** 2024년 4월부터. **Who:** Data Cloud 2GP는 Salesforce Partner만.
- **Quickly Iterate Package Development Using Async Validation** — 새 package version 생성 시 **async validation** 옵션 — package validation 완료 전에 새 package version을 생성한다. 즉시 install/test 가능; CI run time 단축. **Where:** unlocked packages·second-generation managed packages. **When:** 2024년 6월 15일부터.

```bash
sf package version create –-async-validation <rest of command syntax>
```

- **Shorten Package Install Time in Scratch Orgs by Skipping a Handler** — `PackageInstallRequest` object 또는 `sf package install` 사용 시 `FeatureEnforcement` skip handler를 지정한다. Feature enforcement handler는 subscriber org에 object/feature validation을 추가하나(admin이 app을 깨는 feature를 disable하는 것 방지) scratch org에서는 critical하지 않다. `PackageInstallRequest`의 `SkipHandler` field를 `FeatureEnforcement`로 설정. **Where:** unlocked·2GP·scratch org에 설치된 1GP managed packages.

```bash
sf package install --skip-handlers FeatureEnforcement <rest of command syntax>
```

- **Package External Client Apps In Second-Generation Managed Packages** — external client apps framework. headless login, passwordless login, guest user flow(Authorization Code and Credentials Flow)를 지원한다. external client app을 JWT-based access token 발행하도록 config 가능(guest user flow에 required). external client app을 2GP에 포함 가능. **Where:** second-generation managed packages.
- **Explore the Updated Documentation for Components in Managed Packages** — 어떤 component가 2GP·1GP·둘 다에서 packaging 가능한지 더 쉽게 discover한다. component 문서가 이제 2GP·1GP developer guide 양쪽에 있으며, 각 guide는 자기 component만 보여주고 둘 다 packageable인지 표시한다.

---

## 거버너 한도 변경

| 항목 | 변경 내용 |
|---|---|
| SOQL 부모-자식 관계 쿼리 최대 깊이 | 4단계 → **5단계** (parent root + child 4단계) |
| Apex Cursor — 커서당 최대 행 | **5천만 행** (sync·async 모두) |
| Apex Cursor — 트랜잭션당 fetch 호출 | **최대 10회** (sync·async 모두) |
| Apex Cursor — 일일 최대 커서 수 | **10,000개** (sync·async 모두) |
| Apex Cursor — 일일 최대 행 수 (aggregate) | **1억 행** |
| SOQL aggregate query 상한 | **300** (5단계 쿼리 subquery 포함) |
| 일시정지·대기 Flow 인터뷰 수 | 제한 있음 → **무제한** (unlimited paused/waiting Flows) |

> PDF 원문(Cursors): *"Maximum number of rows per cursor: 50 million (both sync and async). Maximum number of fetch calls per transaction: 10 (both sync and async). Maximum number of cursors per day: 10,000 (both sync and async). Maximum number of rows per day (aggregate limit): 100 million."*
>
> PDF 원문(Five-level): *"`Limits.getLimitAggregateQueries()` returns the total number of aggregate queries with SOQL statements: 300."*

> **Pattern B 검증(single source → N metrics):** Cursors의 50M/10/10,000은 모두 *"both sync and async"* 한 값을 각 metric에 적용한다(sync·async 따로 값이 있는 것이 아니라 동일 값을 양쪽에 적용). 일일 1억 행만 aggregate limit으로 별도.

---

## 관련 패턴 노트 (업데이트 필요)

- [ ] SOQL 패턴 — 5단계 부모-자식 쿼리 예시 및 Apex Cursor 패턴 추가
- [ ] Batch Apex — Apex Cursor와 Batch Apex 대용량 처리 비교 (Cursor = Batch 대안, Queueable 체인 사용 가능)
- [ ] Queueable — Apex Cursor + Queueable 체이닝 패턴 추가
- [ ] @InvocableMethod / @InvocableVariable 패턴 — `defaultValue`, `placeholderText` 수식자 사용법 추가
- [ ] [[FormulaEval Namespace]] — `Formula.builder()`·`getReferencedFields()`·SObject context overload(Beta) 반영
- [ ] [[Compression Namespace]] — Summer '24 카탈로그와 직접 관련 없음(참조용 링크)
- [ ] LWC 패턴 — URL-Addressable LWC, Utility Bar API, Light DOM Slot Forwarding 변경, ElementInternals 추가
- [ ] Testing 패턴 — `SoqlStubProvider`·`Test.createSoqlStub()`·`@testSetup` ApexTestResult 추가
- [ ] Pub/Sub API 패턴 — Managed Subscriptions(Beta), `ManagedSubscribe` RPC 추가

---

## 관련 노트

- [[Summer '24]] — 상위 릴리즈 허브
- [[Summer '24/Automation]] — Flow/Automation spoke (Transform GA·Einstein Draft Flow·Repeater 등). `@InvocableVariable` 수식자와 연결
- [[Summer '24/Platform]] — Admin·Security·DevOps·Architecture spoke. My Domain Login URL·Auth.JWTUtil 등 API/보안 연계
- [[Summer '24/Einstein]] — Einstein/AI spoke (Prompt Builder·Copilot·Models API 등). Models API의 REST/Apex 개발자 상세 연계
- [[Summer '24/Release Updates]] — 강제 적용 항목 spoke
- [[Release MOC]]
- [[Governor Limits]] — 거버너 한도 일반 참조
- [[Compression Namespace]] — Apex Zip 압축
- [[FormulaEval Namespace]] — Apex 동적 수식 평가
