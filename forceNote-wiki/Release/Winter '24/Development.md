---
tags: [release, winter_24, development, apex, lwc, api]
source: salesforce_winter24_release_notes.pdf
created: 2026-06-16
aliases: [Winter '24 Development, 윈터 24 개발, Apex LWC API v59, Queueable max depth, Queueable 체이닝 깊이, 체이닝 깊이, AsyncOptions, MaximumQueueableStackDepth, AsyncInfo getMaximumQueueableStackDepth, getCurrentQueueableStackDepth, Queueable stack depth GA, DataWeave in Apex, Toast GA, Winter 24 GA]
---

# Winter '24 — Development (Apex · LWC · API)

> 허브: [[Winter '24]]
> Winter '24(API v59.0) 개발자 영역 전수 정리 — Apex(Queueable stack depth GA·중복 enqueue 방지·DataWeave in Apex GA·Comparator/Collator·Iterable for-loop·permission-set user mode Dev Preview·`getSalesforceBaseUrl` 폐기), LWC(Toast GA·Workspace API Beta·third-party web components Beta·Custom Component Instrumentation Beta·컴포넌트 수준 apiVersion), Visualforce, API v59.0(GraphQL mutations·Bulk API 2.0·JWT access token), Packaging, DevOps Center, 개발 도구, 거버너 한도.

---

## 개요

이 노트는 Winter '24 릴리즈 노트의 **Development 섹션**(physical p.198~286)을 Apex·LWC·API 축으로 정리한 spoke다. 깊이 원칙에 따라 신규 클래스/메서드/enum, 컴포넌트별 변경, API 카탈로그를 전수 기록한다.

| 항목 | 값 |
|---|---|
| API 버전 | v59.0 |
| LWC API 버전 | 59.0 (58.0 이하는 모두 v58.0(Summer '23)으로 처리) |
| 출시 | 2023년 10월 |

- 상위 허브: [[Winter '24]]
- 강제 적용 항목(Release Updates): [[Winter '24/Release Updates]]
- 거버너 한도 일반 참조: [[Governor Limits]]
- Queueable 패턴 일반 참조: [[Queueable]] · [[Queueable 체이닝]]

> **시각 자료 안내(Pattern C):** 원본 PDF의 일부 기능(예: DataWeave Setup UI, Toast UI)에는 스크린샷이 포함돼 있으나 pdftotext로 추출되지 않았다. 본 노트는 텍스트 설명만 담으며 이미지를 재현하지 않는다.

---

## Apex

### 신규

#### Queueable 체이닝 최대 깊이 설정 (GA)

이 기능의 정식 명칭은 **"Set the Maximum Depth of Chained Queueable Jobs (Generally Available)"**이며, 본문에서는 "the Configure Stack Depth of Chained Queueable Jobs feature"로도 불린다. Developer·Trial Edition org의 기본 한도 5를 override해 Queueable job의 최대 stack depth를 설정할 수 있다. runaway recursive job이 일일 async Apex 한도를 소진하는 것을 막는 더 큰 안전장치를 제공한다.

- **Where:** Lightning Experience·Salesforce Classic — Enterprise, Performance, Unlimited, Developer editions.
- **How:** 새 `System.enqueueJob()` overload로 enqueue한다. 이 overload는 optional `AsyncOptions` 파라미터를 받아 최대 stack depth와 최소 queue delay를 지정한다.

**`System.AsyncInfo` 클래스 메서드 (전수 — 정확한 API명):**

| 메서드 | 설명 |
|---|---|
| `getCurrentQueueableStackDepth()` | 현재 Queueable stack depth 반환 |
| `getMaximumQueueableStackDepth()` | 최대 Queueable stack depth 반환 |
| `getMinimumQueueableDelayInMinutes()` | 최소 Queueable delay(분) 반환 |
| `hasMaxStackDepth()` | 최대 stack depth가 설정돼 있는지 여부 반환 |

**property + overload:**
- `AsyncOptions.MaximumQueueableStackDepth` — Integer depth로 설정하는 property.
- `System.enqueueJob(queueable, asyncOptions)` — `AsyncOptions` 인스턴스를 받는 overload.

> ⚠️ `System.maxQueueableDepth`라는 API는 **존재하지 않는다.** 실제 API는 위의 `AsyncOptions.MaximumQueueableStackDepth` property와 `System.AsyncInfo` 메서드들이다.

```apex
// Fibonacci
public class FibonacciDepthQueueable implements Queueable {
private long nMinus1, nMinus2;
public static void calculateFibonacciTo(integer depth) {
AsyncOptions asyncOptions = new AsyncOptions();
asyncOptions.MaximumQueueableStackDepth = depth;
System.enqueueJob(new FibonacciDepthQueueable(null, null), asyncOptions);
}
private FibonacciDepthQueueable(long nMinus1param, long nMinus2param) {
nMinus1 = nMinus1param;
nMinus2 = nMinus2param;
}
public void execute(QueueableContext context) {
integer depth = AsyncInfo.getCurrentQueueableStackDepth();
// Calculate step
long fibonacciSequenceStep;
switch on (depth) {
when 1, 2 {
fibonacciSequenceStep = 1;
}
when else {
fibonacciSequenceStep = nMinus1 + nMinus2;
}
}
System.debug('depth: ' + depth + ' fibonacciSequenceStep: ' + fibonacciSequenceStep);

if(System.AsyncInfo.hasMaxStackDepth() &&
AsyncInfo.getCurrentQueueableStackDepth() >=
AsyncInfo.getMaximumQueueableStackDepth()) {
// Reached maximum stack depth
Fibonacci__c result = new Fibonacci__c(
Depth__c = depth,
Result = fibonacciSequenceStep
);
insert result;
} else {
System.enqueueJob(new FibonacciDepthQueueable(fibonacciSequenceStep, nMinus1));
}
}
}
```

#### 중복 Queueable Job enqueue 방지 (신규)

signature 기반으로 동일 async Queueable job 인스턴스를 단 하나만 enqueue해 resource contention과 race condition을 줄인다. 동일 signature를 가진 Queueable job을 처리 큐에 둘 이상 추가하려 하면, 이후 job들은 enqueue 시 예외가 발생한다.

- **Where:** Enterprise, Performance, Unlimited, Developer editions.
- **How:** `QueueableDuplicateSignature` 클래스의 `addId()`·`addInteger()`·`addString()` 메서드로 고유 signature를 빌드하고, `AsyncOptions` 클래스의 `DuplicateSignature` property에 저장한 뒤, `AsyncOptions` 파라미터와 함께 `System.enqueueJob()`으로 enqueue한다.

**System Namespace 신규 항목:**
- 신규 클래스 `QueueableDuplicateSignature` — 메서드 `addId()`·`addInteger()`·`addString()`. `QueueableDuplicateSignature.Builder()...build()`로 빌드.
- `AsyncOptions.DuplicateSignature` property.
- 신규 예외 `System.DuplicateMessageException` — 동일 signature가 이미 존재할 때 `System.enqueueJob()`에서 throw.

```apex
AsyncOptions options = new AsyncOptions();
options.DuplicateSignature = QueueableDuplicateSignature.Builder()
.addId(UserInfo.getUserId())
.addString('MyQueueable')
.build();
try {
System.enqueueJob(new MyQueueable(), options);
} catch (DuplicateMessageException ex) {
//Exception is thrown if there is already an enqueued job with the same signature
Assert.areEqual('Attempt to enqueue job with duplicate queueable signature',
ex.getMessage());
}
```

```apex
AsyncOptions options = new AsyncOptions();
options.DuplicateSignature = QueueableDuplicateSignature.Builder()
.addInteger(System.hashCode(someAccount))
.addId([SELECT Id FROM ApexClass
WHERE Name='MyQueueable'].Id)
.build();
System.enqueueJob(new MyQueueable(), options);
```

#### DataWeave in Apex (GA)

DataWeave in Apex가 GA됐다. MuleSoft DataWeave 라이브러리를 Apex 런타임에 통합해 native Apex 데이터 변환을 강화한다. DataWeave 스크립트를 metadata로 생성하고 Apex에서 직접 invoke한다. Apex와 마찬가지로 DataWeave 스크립트는 Salesforce 애플리케이션 서버 내에서 실행되며, 동일한 heap·CPU 한도가 적용된다.

- **Where:** Enterprise, Performance, Unlimited, Developer editions.
- **How:** 새 overload `DataWeave.createScript(namespace, scriptName)`로 namespace 간 스크립트를 공유한다. binary input(Apex Blob)을 string으로 강제할 때는 encoding을 지정해야 한다: `binaryVariable as String {encoding: 'utf8'}`. 모든 DataWeave 스크립트마다 `DataWeave.Script`를 extend하는 inner class `DataWeaveScriptResource.ScriptName`이 생성된다. 생성된 클래스를 global로 만들려면 `DataWeaveResource` metadata object의 `isGlobal` 필드를 설정한다.

**실제 클래스·메서드:** `DataWeave.Script`, `DataWeave.Result`, `DataWeaveScriptResource.ScriptName`, `DataWeave.createScript(namespace, scriptName)`, 인스턴스 메서드 `.execute(Map<String,Object>)`, `Result.getValue()`.

```apex
// CSV data for Contacts
String inputCsv = 'first_name,last_name,email\nCodey,"The Bear",codey@salesforce.com';
DataWeave.Script dwscript = new DataWeaveScriptResource.csvToContacts();
DataWeave.Result dwresult = dwscript.execute(new Map<String, Object>{'records' => inputCsv});
List<Contact> results = (List<Contact>)dwresult.getValue();
Assert.areEqual(1, results.size());
Contact codeyContact = results[0];
Assert.areEqual('Codey', codeyContact.FirstName);
Assert.areEqual('The Bear', codeyContact.LastName);
```

DataWeave 스크립트 `csvToContacts.dwl` (verbatim):

```
%dw 2.0
input records application/csv
output application/apex
--records map(record) -> {
FirstName: record.first_name,
LastName: record.last_name,
Email: record.email
} as Object {class: "Contact"}
```

**View DataWeave Scripts in Setup UI** — DataWeave 리소스용 list view를 만들어 namespace 내 배포된 DataWeave 스크립트를 조회한다. DataWeave Resource ID·Name·Namespace Prefix·API Version 같은 필드를 모니터링한다. 경로: Setup → Quick Find "DataWeave" → DataWeave Resources.

#### Comparator 인터페이스 + Collator 클래스로 정렬

List 클래스가 새 `Comparator` 인터페이스를 지원해, `Comparator` 파라미터와 함께 `List.sort()`를 사용하면 다양한 정렬 순서를 구현할 수 있다. locale-sensitive 비교·정렬은 새 `Collator` 클래스의 `getInstance` 메서드를 사용한다. locale-sensitive 정렬은 실행하는 사용자에 따라 결과가 달라질 수 있으므로, **trigger나 특정 정렬 순서를 기대하는 코드에서는 사용을 피한다.**

- **How:** `System.Comparator` 인터페이스의 `compare()` 메서드를 구현하고 이를 `List.sort()`의 파라미터로 지정한다. null 입력은 `compare()`에서 명시적으로 처리해야 null pointer exception을 피한다.

**신규 인터페이스 `System.Comparator` — 메서드 `Integer compare(T e1, T e2)`. 신규 클래스 `Collator` — static `Collator.getInstance()`. 신규 `List.sort(Comparator)` overload.**

```apex
public class Employee {
private Long id;
private String name;
private Integer yearJoined;
// Constructor
public Employee(Long i, String n, Integer y) {
id = i;
name = n;
yearJoined = y;
}
public String getName() { return name; }
public Integer getYear() { return yearJoined; }
}
// Class to compare Employees by name
public class NameCompare implements Comparator<Employee> {
public Integer compare(Employee e1, Employee e2) {
if(e1?.getName() == null && e2?.getName() == null) {
return 0;
} else if(e1?.getName() == null) {
return -1;
} else if(e2?.getName() == null) {
return 1;
}
return e1.getName().compareTo(e2.getName());
}
}
// Class to compare Employees by year joined
public class YearCompare implements Comparator<Employee> {
public Integer compare(Employee e1, Employee e2) {
// Guard against null operands for '<' or '>' operators because
// they will always return false and produce inconsistent sorting
Integer result;
if(e1?.getYear() == null && e2?.getYear() == null) {
result = 0;
} else if(e1?.getYear() == null) {
result = -1;
} else if(e2?.getYear() == null) {
result = 1;
} else if (e1.getYear() < e2.getYear()) {
result = -1;
} else if (e1.getYear() > e2.getYear()) {
result = 1;
} else {
result = 0;
}
return result;
}
}
@isTest
private class EmployeeSortingTest {
@isTest
static void sortWithComparators() {
List<Employee> empList = new List<Employee>();
empList.add(new Employee(101,'Joe Smith', 2020));
empList.add(new Employee(102,'J. Smith', 2020));
empList.add(new Employee(25,'Caragh Smith', 2021));
empList.add(new Employee(105,'Mario Ruiz', 2019));
// Sort by name
NameCompare nameCompare = new NameCompare();
empList.sort(nameCompare);
// Expected order: Caragh Smith, J. Smith, Joe Smith, Mario Ruiz
Assert.areEqual('Caragh Smith', empList.get(0).getName());
// Sort by year joined
YearCompare yearCompare = new YearCompare();
empList.sort(yearCompare);
// Expected order: Mario Ruiz, J. Smith, Joe Smith, Caragh Smith
Assert.areEqual('Mario Ruiz', empList.get(0).getName());
}
}
```

locale-sensitive 정렬(`Collator`) 예:

```apex
@IsTest
static void userLocaleSort() {
string userLocale = 'fr_FR';
User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
LocaleSidKey=userLocale, TimeZoneSidKey='America/Los_Angeles',
ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User'].Id,
UserName='standarduser' + DateTime.now().getTime() + '@testorg.com');
System.runAs(u) {
List<String> shoppingList = new List<String> {
'épaule désosé Agneau',
'Juice',
'à la mélasse Galette 5 kg',
'Bread',
'Grocery'
};
// Default sort
shoppingList.sort();
Assert.areEqual('Bread', shoppingList[0]);
// Sort based on user Locale
Collator myCollator = Collator.getInstance();
shoppingList.sort(myCollator);
Assert.areEqual('à la mélasse Galette 5 kg', shoppingList[0]);
Assert.areEqual('Bread', shoppingList[1]);
Assert.areEqual('épaule désosé Agneau', shoppingList[2]);
Assert.areEqual('Grocery', shoppingList[3]);
Assert.areEqual('Juice', shoppingList[4]);
}
}
```

#### `Iterable` 변수로 For 루프 순회

이제 `Iterable` 변수를 사용해 list나 set을 for 루프에서 쉽게 순회할 수 있다.

```apex
Iterable<String> stringIterator = new List<String>{'Hello', 'World!'};
for (String str : stringIterator) {
System.debug(str);
}
```

```apex
public class MyIterable implements Iterable<String> {
public Iterator<String> iterator() {
return new Set<String>{'Hello', 'World!'}.iterator();
}
}
for (String str : new MyIterable()) {
System.debug(str);
}
```

#### Permission Set 기반 User Mode DB 작업 (Developer Preview)

새 `AccessLevel.withPermissionSetId()` 메서드는 permission set에 지정된 권한으로 실행되는 database·search 작업을 지원한다. 새 `Security.stripInaccessible()` overload 메서드에도 permission set ID를 파라미터로 지정할 수 있다. Apex는 실행 사용자의 권한에 더해 지정된 permission set의 FLS·object permission을 강제한다.

- **Note:** Developer Preview. production 사용 금지.
- **Where:** `ApexUserModeWithPermset` feature가 활성화된 scratch org. 미활성화 시 compile은 되나 실행 불가.
- **How:** 지정된 permission set ID로 `AccessLevel.withPermissionSetId()`를 실행한다.

**System Namespace 신규/변경 메서드:** `Security.stripInaccessible()` permission set ID overload (Developer Preview), `AccessLevel.withPermissionSetId()` (Developer Preview).

```apex
@isTest
public with sharing class ElevateUserModeOperations_Test {
@isTest
static void objectCreatePermViaPermissionSet() {
Profile p = [SELECT Id FROM Profile WHERE Name='Minimum Access - Salesforce'];
User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
LocaleSidKey='en_US', ProfileId = p.Id,
TimeZoneSidKey='America/Los_Angeles',
UserName='standarduser' + DateTime.now().getTime() + '@testorg.com');
System.runAs(u) {
try {
Database.insert(new Account(name='foo'), AccessLevel.User_mode);
Assert.fail();
} catch (SecurityException ex) {
Assert.isTrue(ex.getMessage().contains('Account'));
}
//Get ID of previously created permission set named 'AllowCreateToAccount'
Id permissionSetId = [Select Id from PermissionSet
where Name = 'AllowCreateToAccount' limit 1].Id;
Database.insert(new Account(name='foo'),
AccessLevel.User_mode.withPermissionSetId(permissionSetId));
// The elevated access level in not persisted to subsequent operations
try {
Database.insert(new Account(name='foo2'), AccessLevel.User_mode);
Assert.fail();
} catch (SecurityException ex) {
Assert.isTrue(ex.getMessage().contains('Account'));
}
}
}
}
```

### 변경

- **`getSalesforceBaseUrl()` 폐기** — API v59.0 이상에서 `getSalesforceBaseUrl()` 메서드가 deprecated되어 더 이상 사용할 수 없다. 대신 org URL은 `getOrgDomainUrl()`, Salesforce 인스턴스의 전체 요청 URL은 `getCurrentRequestUrl()`을 사용한다. v59.0 이상에서 폐기된 메서드를 사용하면 **컴파일 에러**가 발생한다.
- **Async Apex Job 한도 사용량 모니터링** — Setup → Apex Jobs 페이지가 24시간 org 한도 대비 사용된 async Apex %와 Apex operation 수를 표시한다.
- **Apex 컴파일러 메시지·Setup·처리 개선** — 에러 메시지에 진행 중인 scheduled job의 CronTrigger ID가 포함되고, Apex Jobs list view에 10,000-record 한도가 강제되며, 역직렬화는 직렬화에 사용된 동일 API 버전을 사용한다.
- **`AuthConfiguration` 신규 메서드** — `getHeadlessPasswordlessLoginEnabled()` (Auth Namespace).

### Release Update (Apex)

- **Enforce RFC 7230 Validation for Apex RestResponse Headers (Release Update)** — `RestResponse.addHeader(name, value)`로 정의된 응답 header 이름을 API 버전과 무관하게 RFC 7230 기준으로 검증한다. Spring '23부터 first available. 상세·시점은 → [[Winter '24/Release Updates]]

### 은퇴

- **Developer Console 전체 Apex 자동완성 은퇴** — org가 Winter '24로 업그레이드될 때(2023년 10월 중순 시작) Developer Console의 전체 Apex 자동완성이 은퇴한다. custom Apex class·SObject에 대한 자동완성은 계속 제공된다.

---

## LWC

### LWC 컴포넌트 수준 API 버전 지정

`.js-meta.xml`의 `apiVersion` 구성 요소로 컴포넌트 API 버전을 지정한다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
<apiVersion>58.0</apiVersion>
</LightningComponentBundle>
```

- **Winter '24부터 58.0 이하 모든 API 버전은 58.0(Summer '23)으로 취급된다.** 신규 기능을 적용하려면 컴포넌트 API 버전을 59.0으로 올린다. 가용 버전보다 높은 버전을 지정하면 알려진 최신 버전이 사용된다.

#### 동적으로 LWC import·인스턴스화

런타임에 알 수 없는 컴포넌트 생성자를 사용해 LWC를 동적으로 로드한다. Lightning Web Security를 활성화하고 구성 파일의 `apiVersion`을 55.0 이상으로 설정한다. Experience Cloud의 LWR 사이트는 statically analyzable한 동적 import만 지원한다 — `import("c/analyzable")`은 동작하지만 `import("c/" + "analyzable")`은 동작하지 않는다.

`lwc:is` 디렉티브는 import된 생성자를 런타임에 `<lwc:component>` managed element에 제공해 동적 인스턴스화를 가능하게 한다.

```html
<template>
<div class="container">
<lwc:component lwc:is={componentConstructor}></lwc:component>
</div>
</template>
```

LWS가 활성화돼 있어야 한다.

### GA

#### Toast 알림 생성·관리 — `lightning/toast` (GA)

`lightning/toast` + `lightning/toastContainer`로 LWR 사이트에서 toast를 생성·관리한다. Enterprise/Performance/Unlimited/Developer.

```javascript
// c/myToastComponent.js
import { LightningElement } from 'lwc';
import ToastContainer from 'lightning/toastContainer';
import Toast from 'lightning/toast';
export default class MyToastComponent extends LightningElement {
connectedCallback() {
const toastContainer = ToastContainer.instance();
toastContainer.maxToasts = 5;
toastContainer.toastPosition = 'top-right';
}
Toast.show({
label: 'This is a toast title with a {0} placeholder link that gets replaced
by labelLinks',
labelLinks : [{
'url': 'https://www.lightningdesignsystem.com/components/toast/',
'label': 'Toast link'
}],
message: 'This message has a {0} placeholder link that gets replaced by from
messageLinks',
messageLinks: [{
url: 'http://www.salesforce.com',
label: 'Salesforce link'
}],
mode: 'sticky',
variant: 'info',
onclose: () => {
// Do something after the toast is closed
}
}, this);
}
}
```

`lightning/toastContainer` attribute: `maxToasts`, `containerPosition`, `toastPosition`. 참고: `lightning/platformShowToastEvent`는 LWR 사이트에서 미지원이다.

### Beta

#### Workspace Tab·Subtab 제어 — `lightning/platformWorkspaceApi` (Beta)

Lightning console app용 LWC Workspace API. `lightning/platformWorkspaceApi` 모듈을 import한다. **LWS 필수**(Lightning Locker는 미지원).

**API 메서드:** `closeTab()`, `disableTabClose()`, `focusTab()`, `getAllTabInfo()`, `getFocusedTabInfo()`, `getTabInfo()`, `openSubtab()`, `openTab()`, `refreshTab()`, `setTabHighlighted()`, `setTabIcon()`, `setTabLabel()`.
**Wire adapter:** `EnclosingTabId()`, `IsConsoleNavigation()`.
**Lightning message channel:** `lightning__tabClosed`, `lightning__tabCreated`, `lightning__tabFocused`, `lightning__tabRefreshed`, `lightning__tabReplaced`, `lightning__tabUpdated`.

#### Custom Component Instrumentation API — `lightning/logger` (Beta)

Shield / Event Monitoring add-on 고객용. Setup → Event Monitoring Settings → **Lightning Logger Events** 켜기. `lightning/logger`의 `log`를 import하면 `log()`가 새 EventLogFile event type **Lightning Logger Event**에 publish한다. **Aura는 미지원.**

```html
<!-- myComponent.html -->
<template>
<lightning-button label="Approve"
onclick={handleClick}>
</lightning-button>
</template>
```

```javascript
// myComponent.js
import { LightningElement } from 'lwc';
import { log } from 'lightning/logger';
export default class HelloWorld extends LightningElement {
constructor() {
super();
}
let msg = {
type: "click",
action: "Approve"
}
handleClick() {
log(msg);
}
}
```

#### Third-Party Web Component 사용 (Beta)

`lwc:external` 디렉티브로 third-party web component를 추가한다. LWS 필수.

```html
<template>
<my-custom-element lwc:external></my-custom-element>
</template>
```

```javascript
customElements.define('my-custom-element', class extends HTMLElement {
constructor() {
super();
this.attachShadow({ mode: 'closed' }).innerHTML = '<div>Custom Element
Constructor</div>';
}});
```

두 가지 방법: (1) static resource로 업로드(resource당 최대 5MB, org cap 250MB) 후 `lightning/platformResourceLoader`의 `loadScript`로 로드하고 `lwc:external`로 추가. (2) `.js-meta.xml`이 있는 LWC 모듈로 추가(JS 파일 최대 128KB). 알려진 제약: closed shadow mode만 지원, `loadScript`는 ECMAScript module 미지원(IIFE/UMD만), npm 의존성·컴파일 미지원, ID로 참조되는 element는 shadow DOM에서 미지원, Experience Builder 사이트는 LWS와 함께 third-party web component 미지원.

#### LWS로 Custom Element 생성 (Beta)

LWS가 활성화되면 `customElements.define()`으로 custom element를 생성할 수 있다. LWS가 `CustomElementRegistry`를 virtualize해 namespace sandbox로 격리한다.

### 그 외 변경

- **HTTP Caching TTL 최대 10분** — custom Aura/LWC 코드 변경이 반영되기까지 최대 10분이 걸릴 수 있다. HTTP `Cache-Control` 헤더를 사용한다 — 모든 브라우저는 최소 5분 캐싱을 받고, Safari를 제외한 모든 브라우저는 `stale-while-revalidate`로 최대 5분을 추가로 받는다.
- **RefreshView API + Lightning Locker** — `lightning/refresh` 모듈 + RefreshView API가 이제 Lightning Locker에서도 동작한다(이전엔 LWS 필요). Lightning Locker가 활성화되면 `registerRefreshHandler(this.template.host, this.refreshHandler.bind(this));`로 등록한다.
- **Base Lightning 컴포넌트 내부 DOM 구조 변경** — native shadow DOM 지원 준비로 Winter '24에 다수 base 컴포넌트(`lightning-accordion`, `lightning-accordion-section`, `lightning-avatar`, `lightning-button-icon` 등 — 전체 목록은 PDF physical p.201~202)와 `lightning-input`의 내부 DOM 구조가 변경됐다. 내부 DOM 구조에 의존하는 테스트는 재작성이 필요하다. **base 컴포넌트는 Mixed Shadow Mode(Developer Preview)를 미지원한다.**
- **API Distortion 변경 (LWS)** — 신규 distortion(ESLint rule 포함): `Element.prototype.getInnerHTML`, `Element.prototype.setHTML`, `Event.prototype.explicitOriginalTarget`, `Event.prototype.originalTarget`, `HTMLBodyElement rejectionhandled/storage/unhandledrejection events`, `HTMLFrameSetElement rejectionhandled/storage/unhandledrejection events`, `HTMLScriptElement.prototype.text setter`, `UIEvent.prototype.rangeParent`(Firefox 전용), `window.find`, `Window rejectionhandled/storage/unhandledrejection events`. 제거: `WindowEventHandler.onstorage`.
- **CSS Scope Token 난독화** — LWC API 59.0+에서 format이 `cmpName_cmpName`에서 `lwc-hashstring`으로 변경됐다. 예: `<c-cmp lwc-2s44vctlls4-host><span lwc-2s44vctlls4></span></c-cmp>`.
- **잘못된 HTML 사용 시 컴포넌트 에러** — API 59.0+에서 HTML 검증이 엄격해져 trailing `</template>` 등은 에러를 일으킨다.
- **지원 브라우저만 Lightning Experience 접근** — Winter '24 이후 IE11에서 더 이상 사용 불가.
- **기타** — Custom Property Editor에서 대응 invocable action 이름 조회(`elementInfo`의 새 `actionName` property), LWC Offline Test Harness 신규 기능(Global Quick Action·Offline Briefcase·customizable home tab), LWR 사이트의 static resource를 LWS가 보호, Aura 사이트에서 LWC에 Custom Property Editor 추가(Beta), top-level slotted content를 native shadow에서 렌더, third-party 사이트의 Lightning 앱에 cookie 대신 session token 사용, global color styling hook(`--slds-g-*`).
- **Security Enhancements for CSRF Tokens for Lightning Apps (Release Update)** — → [[Winter '24/Release Updates]]

### Lightning Components: New and Changed Items

- **New Component:** `lightning-record-picker (Beta)` — GraphQL wire adapter로 Salesforce 레코드를 검색한다(Field Service 앱에서 가장 잘 동작). API 59.0+ 필요.
- **Changed Component:** `lightning-input` — native shadow DOM 준비로 내부 DOM 구조 변경.
- **New Module:** `lightning/toast`(GA), `lightning/platformWorkspaceApi`(Beta), `lightning/logger`.
- **Changed Module:**
  - `lightning/navigation` — `NavigationMixin.Navigate(pageReference, [replace])`: `replace` 기본값 false. 동작 변경 — 이제 modal을 auto-close하지 않고 **stack**(열려 있으나 inactive)한다. `replace=true`로 설정하면 auto-close.
  - `lightning/toastContainer` (GA).
  - `lightning/uiGraphQLApi` (GA) — 이제 지원: aggregate query, 부모/자식 관계가 있는 custom object, referencing LWC와 동일 package의 custom object 배포, namespaced package의 object/field 참조, namespaced package 컴포넌트에서 GraphQL 사용. **미지원:** Experience Cloud 사이트, 런타임 동적 GraphQL query 구성, string interpolation `${}`, `@skip`/`@include` directive의 변수, mutation, aggregate query의 referential integrity.
  - `lightning/uiRecordApi` — deprecated API 지원 종료: `getRecordUi (Deprecated)`, `getRecordInput (Deprecated)`, `refresh (Deprecated)`.
- **New Directive:** `lwc:external (Beta)`(third-party web component를 native web component로 렌더), `lwc:is`(동적 인스턴스화).
- **Changed Aura Component:** `lightning:navigation`(`navigate(pageReference, replace)` modal stacking 동작 변경 — LWC navigation과 동일), `lightning:omniToolkitAPI`(`getAgentWorkload` 신규 응답 `configuredInterruptibleCapacity`·`currentInterruptibleWorkload`).
- **Changed Aura Component Event:** `force:navigateToURL`(`isredirect` 기본 false, 이제 modal stack), `force:navigateToSObject`(`replace` 기본 false, 이제 modal stack), `lightning:omniChannelWorkloadChanged`(신규 응답 `configuredInterruptibleCapacity`·`previousInterruptibleWorkload`·`newInterruptibleWorkload`).

---

## Visualforce

- **Enable JsonAccess Annotation Validation for the Visualforce JavaScript Remoting API (Release Update)** — `JsonAccess` annotation을 검증한다. Winter '23 first available, Winter '24 예정이었으나 **Spring '24로 연기.** → [[Winter '24/Release Updates]]
- **모달 윈도우 navigation 변경** — `navigateToURL(url[, isredirect])` modal이 더 이상 auto-close되지 않는다. `isredirect`는 optional, 기본 false, 이제 modal을 stack한다.

---

## API

API 버전은 **v59.0**이다. 개요: JWT 기반 access token으로 REST 호출을 인증해 외부 시스템 호환성을 개선한다. 그리고 앞서 예고된 Salesforce Platform API v21.0~30.0 은퇴는 **Summer '25로 연기**됐다.

### 신규 / 변경

| 항목 | 내용 |
|---|---|
| **Bulk API 2.0 — PK chunking 객체 확대** | 이제 4,800개 초과 객체를 PK chunking으로 최적화한다("Use Thousands of PK Chunking Enabled Objects") |
| **Bulk API 2.0 — query 처리 개선** | 실패한 batch를 더 작은 chunk로 split해 처리한다 |
| **Bulk API 2.0 — SELECT 문자 수 한도 제거** | 이전 32,000자 한도가 제거됐다 |
| **Connect REST API** | 신규/변경 리소스, 변경된 request/response body(Commerce `getCartItems(...)` 포함) |
| **CRM Analytics REST API** | DMO → dataset 변환, table widget pagination, grid layout widget의 파라미터 override |
| **Invocable Actions** | REST API를 통해 사용 가능 |
| **Metadata API** | 신규 type/field(API 54~58의 다수 backfilled 값 포함) |
| **Reports and Dashboards REST API** | Lightning dashboard 소유권 변경 |
| **User Interface API** | 더 많은 리소스에서 idempotent record write, 더 많은 객체 지원 |

### GraphQL API

- **mutation** 지원.
- **aggregate function + ordering** — `RecordQueryAggregate`, `functionName` = COUNT·COUNT_DISTINCT·MAX·MIN. 특정/다중 필드에 대한 aggregate ordering, null last/first.
- **namespace 지원.**
- **Task·Event 객체**가 GraphQL에 추가됨(UI API는 이 둘을 미지원).
- `ObjectName__FieldName__CompoundField` type.
- `displayValue` 필드가 Integer/Double에 대해 UI API와 일치.

### 은퇴

- **Salesforce Platform API Versions 21.0 Through 30.0 Retirement (Release Update)** — 최초 Summer '23 예정 → **Summer '25로 연기.** 요청이 "endpoint is deactivated" 에러로 실패하게 된다. → [[Winter '24/Release Updates]]

---

## Packaging

- **Managed Packaging 개발자 가이드 재편** — Second-Generation Managed Packaging Developer Guide + First-Generation Managed Packaging Developer Guide로 재구성됐다. ISVforce Guide는 이제 business/marketplace 내용만 다룬다.

---

## DevOps Center

- **Deploy Changes Using Salesforce CLI (Beta)** — `sf project deploy pipeline` 명령. DevOps Center package v6.0+ 호환. Who: DevOps Center Release Manager permission set. **Beta.**
- **Promote Confidently When Work Items Share Components** — metadata component를 공유하는 work item을 결합한다.
- **Perform Validate-Only Deployments in the Bundling Stage** — bundling stage에서 validate-only/quick deployment. DevOps Center package v6.3.0+.

---

## 개발 환경 / 플랫폼 개발 도구

- **Develop from Anywhere using Code Builder (Generally Available)** — **GA.** 웹 기반 개발 환경, 로컬 다운로드 불필요. Professional/Enterprise/Performance/Unlimited + Government Cloud Plus(상호운용). production org에서 활성화하고 라이선스 동의 후 managed package를 설치한다.
- **Scale Center** — 모든 Unlimited Edition Full Copy Sandbox org + Signature 고객에 무료 GA. org당 standard user 5명, 주당 org당 Deep Dive investigation 15회.
- **Scale Testing Service (Pilot)** — production 피크 부하 재현 테스트. **Pilot.**
- **Sandbox License Compliance 변경** — 초과 sandbox를 잠근다. 60일 넘게 잠긴 sandbox는 삭제된다. 2023년 12월 중순 production 적용.
- **Select Who Has Access To a Sandbox** — Selective Sandbox Access(public group 기반). **이 기능의 Winter '24 릴리즈는 연기됐다("We're delaying the release of this feature in Winter '24").** → 본 노트에서는 Winter '24 신기능으로 다루지 않는다.

> 같은 이유로 Tooling API의 `ActivationUserGroupId` 필드(SandboxInfo/SandboxProcess)도 Winter '24에서 지연됐다.

---

## Platform Events / Event Bus / 기타

- **병렬 Apex trigger 구독으로 platform event 처리 (Pilot)** — custom platform event Apex trigger에서 병렬 구독 처리. **Pilot.**
- **Hyperforce Enhanced Usage Metrics.**
- **Streaming API Versions 23.0 Through 36.0 Are Being Retired** — 은퇴 예정.

---

## 거버너 한도 변경 (표)

| 항목 | 변경 내용 |
|---|---|
| Queueable 체이닝 최대 깊이 | Developer/Trial Edition 기본 5를 `AsyncOptions.MaximumQueueableStackDepth` property로 override (GA). `System.AsyncInfo` 메서드로 현재/최대 depth 조회 |
| Apex Jobs list view 레코드 수 | 10,000 records 한도 강제 |
| Bulk API 2.0 — PK chunking 객체 | 4,800개 초과 객체로 확대 |
| Bulk API 2.0 — SELECT 문자 수 | 이전 32,000자 한도 제거 |
| Metadata API backfill | API 54~58의 다수 type/field 값 backfill |

> Queueable 체이닝 깊이 관련 API는 `AsyncOptions.MaximumQueueableStackDepth` + `System.AsyncInfo.getMaximumQueueableStackDepth()` / `getCurrentQueueableStackDepth()` / `getMinimumQueueableDelayInMinutes()` / `hasMaxStackDepth()` + `System.enqueueJob(queueable, asyncOptions)` overload다. `System.maxQueueableDepth`는 존재하지 않는다.

---

## 관련 노트

- [[Winter '24]] — 상위 릴리즈 허브
- [[Winter '24/Automation]] — Flow Builder의 Transform·Reactive·HTTP Callout(개발자 연동 맥락)
- [[Winter '24/Platform]] — Named Credentials(JWT·Client Credentials), Headless Identity, Event Monitoring 신규 event type
- [[Winter '24/Einstein]] — Develop Platform Apps with Ease 등 개발자 대상 생성형 AI
- [[Winter '24/Release Updates]] — RFC 7230·JsonAccess·CSRF·API 은퇴 등 강제 적용 항목
- [[Queueable]] — Queueable 일반 패턴
- [[Queueable 체이닝]] — Queueable 체이닝 패턴
- [[Governor Limits]] — 거버너 한도 일반 참조
- [[Release MOC]]
