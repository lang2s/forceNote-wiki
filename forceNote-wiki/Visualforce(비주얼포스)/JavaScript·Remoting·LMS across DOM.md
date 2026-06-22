---
tags: [visualforce, vf, javascript-remoting, RemoteAction, lms, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26)
created: 2026-06-21
aliases: [JavaScript Remoting, @RemoteAction, Visualforce.remoting.invokeAction, sforce.one publish subscribe, $RemoteAction, VF LMS]
---

# JavaScript · Remoting · LMS across the DOM (Visualforce)

> Visualforce 페이지에서 JavaScript를 쓰는 법 — `$Component`로 DOM ID 참조, JS 라이브러리 포함, **JavaScript Remoting**으로 Apex `@RemoteAction` 메서드 직접 호출, 그리고 **Lightning message service**(`sforce.one`)로 DOM 경계를 넘는 통신.

> [!note] 레거시 안내 — Visualforce는 레거시 UI 기술이다. 신규 개발은 Lightning Web Components를 우선 고려하고, 기존 VF 페이지 유지·보수 시 이 노트를 참조한다.

---

## Visualforce 페이지에서 JavaScript 쓰기

JavaScript를 쓰면 JS 라이브러리 등 기존 기능에 접근할 수 있다. `<apex:actionFunction>`·`<apex:actionSupport>` 같은 Action 태그도 Ajax 요청을 지원한다.

> **Warning** (원문): *"By including JavaScript in a page, you are introducing the possibility of cross-browser and maintenance issues that you do not have when using Visualforce. Before writing any JavaScript, you should be sure that there is not an existing Visualforce component that can solve your problem."*

JavaScript를 포함하는 가장 좋은 방법은 static resource에 넣고 거기서 호출하는 것이다.

```xml
<apex:includeScript value="{!$Resource.MyJavascriptFile}"/>
```

그 다음 `<script>` 태그 안에서 그 JS 파일에 정의된 함수를 쓴다.

> **Tip** (원문): 표현식 안에서 JavaScript를 쓸 때는 따옴표를 백슬래시(backslash, 아래 코드 참조)로 escape해야 한다.
>
> ```text
> onclick="{!IF(false, 'javascript_call(\"js_string_parameter\")', 'else case')}"
> ```

---

## `$Component` — JavaScript에서 컴포넌트 참조

`$Component` global 변수는 Visualforce 컴포넌트에 대해 생성되는 DOM ID를 간단히 참조하게 해주고, 전체 페이지 구조에 대한 의존을 줄여 준다.

- 모든 Visualforce 태그에는 `id` 속성이 있다. 한 태그의 `id`는 다른 태그가 두 태그를 묶는 데 쓸 수 있다 (예: `<apex:outputLabel>`의 `for` ↔ `<apex:inputField>`의 `id`). `<apex:actionFunction>`·`<apex:actionSupport>` 등의 `reRender`·`status` 속성도 다른 컴포넌트의 `id` 값을 쓴다.
- 이 ID는 페이지가 렌더링될 때 컴포넌트의 **DOM ID** 일부를 형성한다.
- JavaScript(또는 다른 웹 언어)에서 Visualforce 컴포넌트를 참조하려면 그 컴포넌트에 `id` 속성을 지정해야 한다. DOM ID는 해당 컴포넌트의 `id` 속성과 그것을 포함하는 모든 컴포넌트의 `id` 속성 조합으로 구성된다.

### Component Access Example

페이지에 두 패널이 있다. 첫째는 DOM 이벤트를 발생시키는 체크박스를 담고, 둘째는 그 이벤트에 반응해 바뀌는 텍스트를 담는다. 상단 `<script>`는 이벤트를 발생시킨 요소(`input`)와 대상 패널의 DOM ID(`textid`)를 인자로 받는다.

```xml
<apex:page id="thePage">
<!-- A simple function for changing the font. -->
<script>
function changeFont(input, textid) {
if(input.checked) {
document.getElementById(textid).style.fontWeight = "bold";
}
else {
document.getElementById(textid).style.fontWeight = "normal";
}
}
</script>
<!-- This outputPanel calls the function, passing in the
checkbox itself, and the DOM ID of the target component. -->
<apex:outputPanel layout="block">
<label for="checkbox">Click this box to change text font:</label>
<input id="checkbox" type="checkbox"
onclick="changeFont(this,'{!$Component.thePanel}');"/>
</apex:outputPanel>
<!-- This outputPanel is the target, and contains
text that will be changed. -->
<apex:outputPanel id="thePanel" layout="block">
Change my font weight!
</apex:outputPanel>
</apex:page>
```

`{!$Component.thePanel}` 표현식은 `<apex:outputPanel id="thePanel">` 컴포넌트가 생성한 HTML 요소의 DOM ID를 얻는다.

---

## JavaScript 라이브러리 사용

JS 라이브러리를 포함하는 가장 좋은 방법은 static resource를 만들고 `<apex:includeScript>` 컴포넌트로 포함하는 것이다. 예를 들어 jQuery를 `jquery`라는 static resource로 만든 뒤:

```xml
<apex:page>
<apex:includeScript value="{!$Resource.jquery}"/>
</apex:page>
```

그 다음 `<script>`로 라이브러리 함수를 호출한다.

### `$` 충돌 — jQuery.noConflict()

라이브러리가 `$`를 특수 문자로 정의하면 이 사용을 override해야 한다. jQuery에서는 `jQuery.noConflict()` 함수로 `$` 정의를 override한다.

```xml
<apex:page >
<apex:includeScript value="{!$Resource.jquery}"/>
<html>
<head>
<script>
jQuery.noConflict();
jQuery(document).ready(function() {
jQuery("a").click(function() {
alert("Hello world, part 2!");
});
});
</script>
</head>
...
</apex:page>
```

> **Note** (원문):
> - 서드파티 JS 라이브러리·프레임워크 사용은 Salesforce가 지원·권장한다. 단 Salesforce는 Salesforce 기능과 직접 관련된 경우를 제외하고 당신의 JavaScript 코드 디버깅을 도와줄 수 없다.
> - Chatter 컴포넌트·`<apex:enhancedList>`·`<knowledge:articleCaseToolbar>`·`<knowledge:articleRendererToolbar>`를 쓰는 페이지에서 버전 3 미만의 Ext JS를 쓰지 말 것.

---

## JavaScript Remoting for Apex Controllers

JavaScript remoting을 쓰면 Visualforce 페이지에서 JavaScript로 Apex 컨트롤러의 메서드를 호출할 수 있다. 표준 Visualforce AJAX 컴포넌트로는 불가능한 복잡하고 동적인 동작의 페이지를 만든다.

JavaScript remoting 기능은 세 요소를 필요로 한다.
- 페이지에 추가하는 **remote method 호출** (JavaScript).
- 컨트롤러 클래스의 **remote method 정의** (Apex — 일반 action 메서드와 중요한 차이 있음).
- 페이지에 추가하는 **response handler callback 함수** (JavaScript).

### What Is JavaScript Remoting?

JavaScript remoting은 프론트엔드 개발자가 Visualforce 페이지에서 **Apex 컨트롤러로 직접 AJAX 요청**을 보내는 도구다. 페이지를 컨트롤러에서 분리해 비동기 동작을 실행하고, 전체 페이지를 다시 로드하지 않고 작업을 수행한다. 또한 view state 이슈를 완화할 수 있으며, 페이지를 보는 사용자의 컨텍스트에서 실행된다. 매 호출 시 필요한 데이터만 전달하므로 컨트롤러 호출·데이터 전달의 가장 효율적인 방식이다.

**When to Use** — 모바일 페이지와 서드파티 JS 라이브러리를 쓰는 페이지에 최적화되어 있다. 표준 Visualforce AJAX 컴포넌트와 Visualforce Remote Objects의 대안이다. 비동기이므로 초기 페이지와 표시에 필요한 데이터만 로드하고, 즉시 쓰지 않는 추가 데이터는 lazy load하거나 사용자가 아직 접근하지 않은 페이지/뷰의 데이터를 pre-load할 수도 있다. 단 한계도 있다 — 개발에 시간이 더 들고, form·view state가 없으므로 페이지 상태를 클라이언트 쪽에서 직접 관리해야 한다. 표준 Visualforce MVC와 결합하는 것을 막는 것은 없다.

### `<apex:actionFunction>`과의 비교

`<apex:actionFunction>` 컴포넌트도 JavaScript로 컨트롤러 action 메서드를 호출하게 해준다. 일반적으로 `<apex:actionFunction>`은 쓰기 쉽고 코드가 적게 들며, JavaScript remoting은 더 많은 유연성을 제공한다.

| `<apex:actionFunction>` 태그 | JavaScript remoting |
|---|---|
| rerender 대상을 지정할 수 있음 | 파라미터를 전달할 수 있음 |
| form을 submit함 | callback을 제공함 |
| JavaScript를 작성할 필요 없음 | JavaScript를 작성해야 함 |

### Remote Objects와의 비교

JavaScript Remoting과 Remote Objects는 유사한 기능을 제공하며 둘 다 동적·반응형 페이지에 유용하다. 일반적으로 Remote Objects는 단순 CRUD 객체 접근만 하는 페이지에 적합하고, JavaScript Remoting은 higher-level 서버 action에 접근하는 페이지에 더 적합하다. Remote Objects는 격식 없이 빠르게 시작하게 해주고, JavaScript Remoting은 사전에 API-스타일 설계 작업이 필요한 복잡한 애플리케이션에 적합하다.

| Visualforce Remote Objects | JavaScript Remoting |
|---|---|
| 기본 "CRUD" 객체 접근을 쉽게 만듦 | JavaScript와 Apex 코드 둘 다 필요 |
| Apex 코드 불필요 | 복잡한 서버측 애플리케이션 로직 지원 |
| 최소한의 서버측 애플리케이션 로직 지원 | 복잡한 객체 관계를 더 잘 처리 |
| 자동 관계 traversal 미제공 — 관련 객체를 직접 lookup해야 함 | 네트워크 연결을 (더욱) 효율적으로 사용 |

> Remote Objects 상세(`<apex:remoteObjects>`·`SObjectModel`·`create()`/`retrieve()`/`update()`/`upsert()`/`del()`·query criteria·callback)는 이 노트 범위 밖이다 — 별도 노트 권장.

---

## 페이지에 JavaScript Remoting 추가

Apex 클래스를 custom controller 또는 controller extension으로 페이지에 추가한다.

```xml
<apex:page controller="MyController" extension="MyExtension">
```

> **Warning** (원문): 컨트롤러/확장을 추가하면 그 Apex 클래스의 **모든 `@RemoteAction` 메서드에 접근이 부여**된다 — 페이지에서 쓰이지 않는 메서드까지. 페이지를 볼 수 있는 누구나 모든 `@RemoteAction` 메서드를 실행하고 가짜·악의적 데이터를 컨트롤러에 제공할 수 있다.

요청은 JavaScript 함수 호출로 추가한다. 단순한 호출 형태는 다음과 같다.

```text
[namespace.]MyController.method(
[parameters...,]
callbackFunction,
[configuration]
);
```

### Table 2 — Remote Request Elements

| Element | Description |
|---|---|
| `namespace` | 컨트롤러 클래스의 namespace. org에 namespace가 정의되어 있거나 클래스가 설치된 패키지에서 온 경우 필수. |
| `MyController, MyExtension` | Apex 컨트롤러 또는 확장의 이름. |
| `method` | 호출하는 Apex 메서드의 이름. |
| `parameters` | 메서드가 받는 파라미터의 콤마 구분 목록. |
| `callbackFunction` | 컨트롤러의 응답을 처리하는 JavaScript 함수 이름. 인라인 anonymous 함수로도 선언 가능. `callbackFunction`은 메서드 호출의 status와 result를 파라미터로 받는다. |
| `configuration` | remote 호출·응답 처리를 구성. Apex 메서드 응답을 escape할지 등 remoting 호출의 동작을 바꾸는 데 쓴다. |

remote method 호출은 **동기적으로 실행**되지만 응답을 기다리지는 않는다. 응답이 돌아오면 callback 함수가 **비동기적으로** 처리한다.

---

## Remoting 요청 구성 (configuration)

remoting 요청 선언 시 configuration 설정 객체를 제공한다. 기본 configuration은 다음과 같다.

```javascript
{ buffer: true, escape: true, timeout: 30000 }
```

configuration 파라미터는 순서가 없고, 기본값에서 바꾸지 않을 파라미터는 생략할 수 있다.

| Name | Data Type | Description |
|---|---|---|
| `buffer` | Boolean | 시간상 가까이 실행되는 요청들을 하나의 요청으로 그룹화할지 여부. 기본 `true`. JavaScript remoting은 시간상 가까이 실행되는 요청을 최적화해 하나의 요청으로 묶는다. 이 buffering은 전체 request-and-response cycle의 효율을 *improve* [sic]하지만, 때로는 모든 요청을 독립적으로 실행하도록 보장하는 것이 유용하다. |
| `escape` | Boolean | Apex 메서드 응답을 escape할지 여부. 기본 `true`. |
| `timeout` | Integer | 요청의 timeout(밀리초). 기본 30,000 (30초). **최대 120,000** (120초 = 2분). |

요청 timeout은 `Visualforce.remoting` 객체로 페이지 단위 전체에 설정할 수도 있다.

```javascript
<script type="text/javascript">
Visualforce.remoting.timeout = 120000; // Set timeout at page level
function getRemoteAccount() {
var accountName = document.getElementById('acctSearch').value;
// This remoting call will use the page's timeout value
Visualforce.remoting.Manager.invokeAction(
'{!$RemoteAction.AccountRemoter.getAccount}',
accountName,
handleResult
);
}
function handleResult(result, event) { ... }
</script>
```

페이지 단위 timeout은 해당 요청의 configuration 객체에 `timeout`을 설정해 요청별로 override한다.

---

## Namespaces와 `$RemoteAction`

`$RemoteAction` global을 쓰면 remote action의 올바른 namespace(있으면)를 자동 해석한다. 패키지가 제공하는 메서드로 remoting 호출하는 페이지에서 특히 namespace 작업이 쉬워진다.

이 기능을 쓰려면 JavaScript remoting을 **명시적으로 invoke**해야 한다.

```text
Visualforce.remoting.Manager.invokeAction(
'fully_qualified_remote_action',
invocation_parameters
);
```

fully qualified remote action은 namespace·base class 등을 포함한 remote action 메서드의 완전한 경로 문자열이다 — `namespace[.BaseClass][.ContainingClass].ConcreteClass.Method`. 표현식에서 `$RemoteAction`을 쓰면 namespace를 자동 해석한다 (예: `{!$RemoteAction.MyController.getAccount}`).

invocation parameters는 표준 remoting 호출과 동일하다 — `@RemoteAction` 메서드에 보낼 파라미터(있으면), 결과를 처리하는 callback 함수, 호출의 configuration(있으면).

```javascript
<script type="text/javascript">
function getRemoteAccount() {
var accountName = document.getElementById('acctSearch').value;
Visualforce.remoting.Manager.invokeAction(
'{!$RemoteAction.MyController.getAccount}',
accountName,
function(result, event){
if (event.status) {
document.getElementById('acctId').innerHTML = result.Id
document.getElementById('acctName').innerHTML = result.Name;
} else if (event.type === 'exception') {
document.getElementById("responseErrors").innerHTML = event.message;
} else {
document.getElementById("responseErrors").innerHTML = event.message;
}
},
{escape: true}
);
}
</script>
```

이 호출은 컨트롤러가 정의된 namespace 세부(자기 namespace인지 설치된 패키지가 제공한 것인지)를 알 필요가 없고, org에 namespace가 없는 상황도 처리한다.

> **Note** (원문): `invokeAction` 호출 시 만난 에러는 JavaScript console에만 보고된다. 예를 들어 `$RemoteAction`이 여러 namespace에서 일치하는 `@RemoteAction` 메서드를 찾으면 첫 번째 일치 메서드를 반환하고 console에 warning을 남긴다. 일치하는 컨트롤러나 action을 찾지 못하면 호출은 **silently fail**하고 에러를 JavaScript console에 남긴다.

---

## OAuth 2.0 인증 (JavaScript Remoting)

표준 username/password 로그인 대신 OAuth 2.0으로 JavaScript remoting 요청을 인증할 수 있다. OAuth는 표준 인증으로는 안전하게 할 수 없는 cross-application·cross-organization 통합을 가능하게 한다. OAuth를 쓰는 페이지는 페이지 단위로 설정하고 모든 JavaScript remoting 요청에 OAuth를 쓴다 — 설정 외에는 사용법이 동일하다.

```javascript
<script type="text/javascript">
Visualforce.remoting.oauthAccessToken = <access_token>;
// ...
</script>
```

`oauthAccessToken`이 설정되면 모든 JavaScript remoting 요청이 OAuth를 쓴다. 나머지 코드는 동일하게 유지한다.

`oauthAccessToken`은 페이지 코드가 얻은 OAuth 인증 토큰이다. access token을 얻고 갱신하는 것은 표준 OAuth이되 한 가지 추가가 있다 — JavaScript remoting OAuth 인증은 **"visualforce" scope**를 요청하므로, 토큰은 이 scope 또는 이를 포함하는 scope(`"web"` 또는 `"full"`)로 생성해야 한다. OAuth 요청에 `scope=visualforce`(또는 `"web"`·`"full"`)를 설정한다.

---

## Apex에서 Remote Method 선언 (`@RemoteAction`)

거의 모든 Apex 메서드를 JavaScript remoting remote action으로 호출할 수 있다. 메서드는 간단한 규칙을 따라야 한다. 컨트롤러에서 Apex 메서드 선언 앞에 `@RemoteAction` annotation을 붙인다.

```apex
@RemoteAction
global static String getItemId(String objectName) { ... }
```

**규칙 (전수):**
- Apex `@RemoteAction` 메서드는 **`static`**이어야 하고 **`global` 또는 `public`**이어야 한다.
- 메서드는 인자로 Apex primitives, collections, typed·generic sObjects, 사용자 정의 Apex 클래스·인터페이스를 받을 수 있다. Generic sObject는 실제 타입 식별을 위해 `ID` 또는 `sobjectType` 값을 가져야 한다. Interface 파라미터는 실제 타입 식별을 위해 `apexType`을 가져야 한다.
- 메서드는 Apex primitives, sObjects, collections, 사용자 정의 Apex 클래스·enums, `SaveResult`, `UpsertResult`, `DeleteResult`, `SelectOption`, 또는 `PageReference`를 반환할 수 있다.
- JavaScript remoting에 쓰이는 메서드는 **이름과 파라미터 개수로 고유하게 식별**되어야 한다 — **오버로딩 불가**. 예를 들어 위 메서드가 있으면 `getItemId(Integer productNumber)`를 추가로 가질 수 없다. 대신 다른 이름의 메서드를 선언한다.
  - `getItemIdFromName(String objectName)`
  - `getItemIdFromProductNumber(Integer productNumber)`

### Scope and Visibility of `@RemoteAction` Methods

`@RemoteAction` 메서드는 `static`이고 `global` 또는 `public`이어야 한다. 전역 노출된 remote action으로 민감한 작업을 하거나 비공개 데이터를 노출하지 말 것. **Global remote action은 다른 global 메서드만 호출할 수 있다.** **Global 컴포넌트나 global scope에서 public remote action을 쓸 수 없다.** Scope escalation은 컴파일 에러를, 런타임에 해석되는 참조의 경우 런타임 실패를 일으킨다.

> 표 검증 (Pattern B) — row=method scope, col=context. PDF 원문 방향 그대로 유지(transpose 안 함). PDF의 unique 값: `Allowed`, `Error`, 그리고 Public×Access의 산문 셀.

| @RemoteAction Scope | Visualforce Page | Non-Global Component | Global Component | iframe Component | Access Across Packages |
|---|---|---|---|---|---|
| Global Remote Method | Allowed | Allowed | Allowed | Allowed | Allowed |
| Public Remote Method | Allowed | Allowed | **Error** | **Error** | Packages must share the namespace. Method must have the `@namespaceAccessible` annotation. |

> **Note** (원문): managed package 안의 `@RemoteAction` 메서드가 Visualforce Remoting에 쓰이고 user profile 또는 permission set 접근이 사용되면, 그 메서드는 **global visibility**를 가져야 한다.

remote action이 markup을 통해 접근되어 컴포넌트·`<apex:include>`·`<apex:composition>` 태그로 간접 포함되면, remote method의 scope가 **top-level container**(포함 계층의 최상위 항목)로 carry forward되며, 그 container는 scope escalation 규칙을 지켜야 한다.

> 표 검증 (Pattern B) — row=accessed from, col=top-level container. PDF 원문 방향 그대로 유지. PDF unique 값: `Allowed`, `Error`, `n/a`, 그리고 두 개의 조건부 산문 셀.

| @RemoteAction Accessed From | Visualforce Page | Non-Global Component | Global Component | iframe |
|---|---|---|---|---|
| Global Component | Allowed | Allowed | Allowed | Allowed |
| Non-Global Component | Allowed | Allowed | Allowed only if non-global component doesn't include public remote methods. | Allowed only if non-global component doesn't include public remote methods. |
| `<apex:include>` `<apex:composition>` | Allowed within the same namespace; error if namespaces are different and the included page or its child hierarchy contains public remote methods. | n/a | n/a | Error |

### Remote Methods and Inheritance

상속된 메서드인 remote action도 호출할 수 있다. `@RemoteAction` 메서드를 lookup하거나 호출할 때 Visualforce는 페이지 컨트롤러의 상속 계층을 검사해 조상 클래스의 `@RemoteAction` 메서드를 찾는다. 다음 Apex 클래스는 3계층 상속 계층을 이룬다.

```apex
global with sharing class ChildRemoteController
extends ParentRemoteController { }
global virtual with sharing class ParentRemoteController
extends GrandparentRemoteController { }
global virtual with sharing class GrandparentRemoteController {
@RemoteAction
global static String sayHello(String helloTo) {
return 'Hello ' + helloTo + ' from the Grandparent.';
}
}
```

이 Visualforce 페이지는 단순히 `sayHello` remote action을 호출한다.

```xml
<apex:page controller="ChildRemoteController" >
<script type="text/javascript">
function sayHello(helloTo) {
ChildRemoteController.sayHello(helloTo, function(result, event){
if(event.status) {
document.getElementById("result").innerHTML = result;
}
});
}
</script>
<button onclick="sayHello('Jude');">Say Hello</button><br/>
<div id="result">[Results]</div>
</apex:page>
```

remote method는 `ChildRemoteController`에 존재하지 않는다 — `GrandparentRemoteController`에서 상속된 것이다.

### Interface Parameters로 Remote Method 선언

concrete 클래스로 제한되지 않고 interface 파라미터·반환 타입으로 `@RemoteAction` 메서드를 선언할 수 있다. 패키지 제공자가 remote method와 관련 interface를 패키징하면, subscriber org가 자기 클래스(패키지된 interface 구현)를 전달해 Visualforce 페이지에서 호출할 수 있다.

> **Note** (원문): managed package 안의 `@RemoteAction` 메서드가 Visualforce Remoting에 쓰이고 user profile 또는 permission set 접근이 사용되면 global visibility를 가져야 한다.

```apex
public class RemoteController {
public interface MyInterface { String getMyString(); }
public class MyClass implements MyInterface {
private String myString;
public String getMyString() { return myString; }
public void setMyString(String s) { myString = s; }
}
@RemoteAction
public static MyInterface setMessage(MyInterface i) {
MyClass myC = new MyClass();
myC.setMyString('MyClassified says "' + i.getMyString() + '".');
return myC;
}
}
```

interface 파라미터를 선언한 `@RemoteAction`으로 보내는 객체는 **`apexType` 값**을 포함해야 하며, 이는 concrete 클래스에 대한 fully qualified path여야 한다 — `namespace[.BaseClass][.ContainingClass].ConcreteClass`.

```javascript
Visualforce.remoting.Manager.invokeAction(
'{!$RemoteAction.RemoteController.setMessage}',
{'apexType':'thenamespace.RemoteController.MyClass', 'myString':'Lumos!'},
handleResult
);
```

클래스 정의가 자기 org 안에 있으면 호출을 단순화하고 기본 `c` namespace를 쓸 수 있다.

```javascript
RemoteController.setMessage(
{'apexType':'c.RemoteController.MyClass', 'myString':'Lumos!'},
handleResult
);
```

---

## Remote Response 처리 (event 객체)

remote method 호출에 대한 응답은 callback 함수에서 비동기로 처리한다. callback 함수는 다음 파라미터를 받는다.
- remote 호출의 status를 나타내는 **`event` 객체**
- remote Apex 메서드가 반환한 **`result` 객체**

`event` 객체는 remote 호출의 성공/실패에 따라 행동할 수 있게 한다.

| Field | Description |
|---|---|
| `event.status` | 성공 시 `true`, 에러 시 `false`. |
| `event.type` | 응답 타입 — 성공한 호출은 `rpc`, remote 메서드가 예외를 던지면 `exception`. |
| `event.message` | 반환된 에러 메시지를 담음. |
| `event.where` | remote 메서드가 생성한 경우 Apex stack trace가 참조됨. |

`result`가 반환한 Apex primitive(string·number 등)는 JavaScript 등가물로 변환된다. 반환된 Apex 객체는 JavaScript 객체로, collection은 JavaScript array로 변환된다. JavaScript는 **case-sensitive**이므로 `id`·`Id`·`ID`는 서로 다른 필드로 간주된다.

> 원문 [sic]: *"if the Apex method response contains references to the same object., the object is not duplicated in the returned JavaScript object."* — Apex 메서드 응답이 같은 객체에 대한 참조를 포함하면 반환되는 JavaScript 객체에서 그 객체는 중복되지 않고 동일 객체에 대한 참조를 담는다. (예: 같은 객체를 두 번 담은 list를 반환하는 Apex 메서드.)

### Date·Time 직렬화

Date·time 값은 Visualforce remoting으로 전달될 때 **epoch time**으로 직렬화된다. RemoteAction 함수에서 반환되는 `Date`·`DateTime`·`Time` 객체는 long integer로 serialize된다.

```text
[{
"statusCode": 200,
"type": "rpc",
"tid": 8,
"ref": false,
"action": "DateTestController",
"method": "add",
"result": 1432047600000
}]
```

### Debugging JavaScript Remoting

JavaScript remoting을 쓰는 페이지 디버깅은 Visualforce·Apex·JavaScript를 모두 디버깅해야 한다.

> **Important** (원문): JavaScript remoting을 쓸 때 개발 중에는 JavaScript console을 열어 둘 것. JavaScript remoting이 만난 에러·예외는 (활성화 시) JavaScript console에 기록되고, 그렇지 않으면 silently ignore된다.

`@RemoteAction` 메서드가 프로그래밍 에러 등으로 예외를 던지면 Apex stack trace가 `event` 객체에 담겨 브라우저로 반환된다.

```javascript
<script type="text/javascript">
function getRemoteAccount() {
var accountName = document.getElementById('acctSearch').value;
Visualforce.remoting.Manager.invokeAction(
'{!$RemoteAction.MyController.getAccount}',
accountName,
function(result, event){
if (event.status) {
document.getElementById('acctId').innerHTML = result.Id
document.getElementById('acctName').innerHTML = result.Name;
} else if (event.type === 'exception') {
document.getElementById("responseErrors").innerHTML =
event.message + "<br/>\n<pre>" + event.where + "</pre>";
} else {
document.getElementById("responseErrors").innerHTML = event.message;
}
}
);
}
</script>
```

---

## JavaScript Remoting — Limits and Considerations (전수)

JavaScript remoting은 일부 resource limit의 대상은 아니지만 다른 한도가 있다.

| 항목 | 값 / 규칙 |
|---|---|
| API 한도 | JavaScript remoting 호출은 **API limit 대상이 아님**. 단 JavaScript remoting을 쓰는 Visualforce 페이지는 **모든 표준 Visualforce 한도** 대상. |
| 기본 timeout | 기본적으로 remote 호출 응답은 **30초** 안에 돌아와야 하며, 이후 timeout. |
| 최대 timeout | 더 오래 걸리면 longer timeout을 구성 — **최대 120초**. |
| 요청 최대 크기 | headers 포함 **4 MB**. |
| 응답 최대 크기 | **15 MB**. |
| nonbatched 옵션 | 응답이 한도를 초과하면 옵션 중 하나로 nonbatched 요청 사용 — remoting 요청 configuration 블록에 `{ buffer: false }` 설정. |

응답 15MB 한도 초과 시 옵션 (원문):
- 각 요청의 응답 크기를 줄여라 — 필요한 데이터만 반환.
- 큰 데이터 조회를 더 작은 chunk를 반환하는 요청들로 쪼개라.
- batch 크기를 줄이려면 더 자주 batched 요청을 보내라.
- nonbatched 요청을 써라. remoting 요청 configuration 블록에 `{ buffer: false }` 설정.

추가 considerations (원문):
- Salesforce는 일부 JavaScript remoting 호출의 에러 메시지를 로깅한다. 에러 메시지에 customer data를 포함하지 않으면 개인정보 로깅을 막을 수 있다. 예외를 catch해 전체 메시지를 로깅하고, Visualforce 페이지에는 user-friendly 메시지를 반환하라.
- JavaScript remoting 요청이 만들어지면 Session Settings Setup 페이지의 org-wide timeout 값으로 access timeout 값이 생성된다. 이 timeout은 후속 요청에서 **refresh되지 않는다.** 바람직하지 않으면 User Profile access 또는 Permission Set access를 쓸 수 있다.
- JavaScript remoting은 `referrer-policy` HTTP header가 `no-referrer`로 설정되면 동작하지 않는다.

---

## JavaScript Remoting Example

Apex 컨트롤러 `AccountRemoter`:

```apex
global with sharing class AccountRemoter {
public String accountName { get; set; }
public static Account account { get; set; }
public AccountRemoter() { } // empty constructor
@RemoteAction
global static Account getAccount(String accountName) {
account = [SELECT Id, Name, Phone, Type, NumberOfEmployees
FROM Account WHERE Name = :accountName];
return account;
}
}
```

이 remote method를 쓰는 Visualforce 페이지:

```xml
<apex:page controller="AccountRemoter">
<script type="text/javascript">
function getRemoteAccount() {
var accountName = document.getElementById('acctSearch').value;
Visualforce.remoting.Manager.invokeAction(
'{!$RemoteAction.AccountRemoter.getAccount}',
accountName,
function(result, event){
if (event.status) {
// Get DOM IDs for HTML and Visualforce elements like this
document.getElementById('remoteAcctId').innerHTML = result.Id
document.getElementById(
"{!$Component.block.blockSection.secondItem.acctNumEmployees}"
).innerHTML = result.NumberOfEmployees;
} else if (event.type === 'exception') {
document.getElementById("responseErrors").innerHTML =
event.message + "<br/>\n<pre>" + event.where + "</pre>";
} else {
document.getElementById("responseErrors").innerHTML = event.message;
}
},
{escape: true}
);
}
</script>
<input id="acctSearch" type="text"/>
<button onclick="getRemoteAccount()">Get Account</button>
<div id="responseErrors"></div>
<apex:pageBlock id="block">
<apex:pageBlockSection id="blockSection" columns="2">
<apex:pageBlockSectionItem id="firstItem">
<span id="remoteAcctId"/>
</apex:pageBlockSectionItem>
<apex:pageBlockSectionItem id="secondItem">
<apex:outputText id="acctNumEmployees"/>
</apex:pageBlockSectionItem>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:page>
```

주목할 점 (원문):
- JavaScript는 명시적 `invokeAction` remoting 호출을 쓰고, `$RemoteAction` global로 remote action 메서드의 namespace를 해석한다.
- `event.status`는 호출이 성공했을 때만 `true`. 예시의 에러 처리는 의도적으로 단순하며 `event.message`·`event.where`로 에러 메시지·stack trace를 출력한다.
- `result`는 Apex `getAccount` 메서드가 반환한 객체.
- 평범한 HTML 요소의 DOM ID 접근은 단순하다 — 그 항목의 ID를 쓰면 된다.
- Visualforce 컴포넌트의 DOM ID는 고유성 보장을 위해 동적 생성되므로 `$Component` global로 조회한다.

---

## Common Remoting API Validation Errors

다음 메시지는 **Apex 컨트롤러 validation**에 적용된다.
- *"The concrete implementation "CLASS" in namespace "NAMESPACE" for Apex interface "METHOD_PARAMETER" doesn't have permission to be used. The Apex object can't be instantiated."*
  → deserialize된 객체가 관련 namespace에서 쓰일 permission이 없음. Apex 클래스에서 incompatible annotation을 제거하거나 누락된 보안 요건을 충족하라.
- *"The concrete implementation "CLASS" in namespace "NAMESPACE" doesn't implement the Apex interface "METHOD_PARAMETER." The Apex object can't be instantiated."*
  → deserialize된 Apex 객체의 데이터 타입이 Apex 컨트롤러 메서드가 기대하는 입력 인자 타입과 같은지 확인하라.

다음 메시지는 **CSRF token validation**에 적용된다.
- *"Remoting request had invalid authorization. Try again later."* → CSRF token이 성공적으로 발급됐는지 확인. 필요하면 새 token 요청.
- *"Remoting request authorization expired. Refresh the page and try again."* → CSRF token 만료. 새 token을 요청해 사용.
- *"Remoting request could not be authorized. Refresh the page and try again."* → CSRF token validation 중 예기치 못한 실패. console log·server log로 실패 지점을 식별.
- *"Remoting request authorization invalid for requested method."* → CSRF token이 유효한지 확인. 그리고 그 token이 발급 검증된 동일 메서드에 쓰이는지 확인.
- *"You do not have the level of access necessary to perform the operation you requested. Please contact the owner of the record or your administrator if access is necessary."* → token·authorization 접근이 실패했으나 이유 정보가 없음. console·server log 확인.
- *"Error occurred while authorizing the remoting request. Refresh the page and try again."* → validation 중 미명시 이슈. 접근이 유효한지 확인하고 console·server log 확인.

---

## Lightning Message Service (LMS) in Visualforce — Across the DOM

> ⚠️ **API surface 차이** — VF의 LMS는 **`sforce.one` 라이브러리**(`sforce.one.publish/subscribe/unsubscribe`)와 **`$MessageChannel` global**을 쓴다. LWC의 LMS는 `lightning/messageService` 모듈(`publish`·`subscribe`·`MessageContext`)을 쓴다. 같은 message channel·동일 개념이지만 호출 API가 다르다. LWC 측 상세는 [[Lightning Message Service]] 참조.

Lightning message service로 한 Lightning 페이지 안에서 DOM을 넘어 통신한다 — 같은 Lightning 페이지에 임베드된 Visualforce 페이지, Aura 컴포넌트, Lightning web components(utility bar·pop-out utility의 컴포넌트 포함) 간 통신. 컴포넌트가 전체 애플리케이션에서 메시지를 구독할지, 활성 영역에서만 구독할지 선택한다. Open CTI를 통해 softphone과도 통신할 수 있다.

> **Important** (원문): Lightning message service는 Lightning Experience에서 사용 가능하며, Experience Builder sites에 쓰이는 Lightning components에서는 **beta** 기능이다.

Visualforce에서 LMS에 접근하려면 **`$MessageChannel` global 변수**를 쓴다. message는 serializable JSON 객체다 — string·number·object·boolean을 전달할 수 있으나 function·symbol은 담을 수 없다. `$MessageChannel` global 변수는 **Lightning Experience에서만 사용 가능**하다.

### org 안에서 만든 Message Channel 사용

```xml
<apex:page>
<script>
// Load the MessageChannel token in a variable
var SAMPLEMC = "{!$MessageChannel.SampleMessageChannel__c}";
</script>
</apex:page>
```

formula expression `{!$MessageChannel.SampleMessageChannel__c}`로 custom message channel을 참조한다. 이 표현식은 custom message channel에 고유한 **token**을 생성하며, 변수 `SAMPLEMC`에 할당해 LMS API 메서드에서 쓴다. `SampleMessageChannel__c`는 `LightningMessageChannel` metadata type의 custom 인스턴스를 가리킨다. `__c` 접미사는 custom임을 뜻하지만 **custom object는 아니다.**

org에 namespace가 있어도 message channel 표현식에 포함하지 말 것. 예를 들어 org namespace가 `MyNamespace`라도 표현식은 `"{!$MessageChannel.SampleMessageChannel__c}"`로 유지한다.

### org 밖에서 만든 Message Channel 사용

org 밖의 개발자가 만든 패키지의 message channel은 `{!$MessageChannel.Namespace_name__c}` 구문으로 참조한다. 예를 들어 `SampleMessageChannel`이 namespace `SamplePackageNamespace` 패키지에서 왔다면 구문은 다음과 같다 (원문 [sic] — `!` 누락).

```text
{$MessageChannel.SamplePackageNamespace__SampleMessageChannel__c}
```

### Message Channel 생성

org에 Lightning Message Channel을 만들려면 **`LightningMessageChannel` metadata type**을 쓴다. (자세히는 Metadata API Developer Guide의 `LightningMessageChannel` 참조.)

배포하려면 Salesforce DX 프로젝트를 만들고 XML 정의를 `force-app/main/default/messageChannels/` 디렉터리에 둔다. 파일명 형식은 `messageChannelName.messageChannel-meta.xml`이다. scratch org·sandbox·Developer Edition org에 추가하려면 `sf project deploy start` CLI 명령을 실행한다.

### Publish — `sforce.one.publish()`

Visualforce 페이지에서 publish하려면 페이지 JavaScript에 `$MessageChannel` global을 포함하고 `sforce.one.publish()`를 호출하는 메서드를 작성한다. `publish()`는 두 파라미터를 받는다 — message channel token 문자열, 그리고 message payload.

> Example (원문): `lmsPublisherVisualforce` 페이지 — github.com/trailheadapps/lwc-recipes repo.

```xml
<apex:page >
<script>
// Load the MessageChannel token in a variable
var SAMPLEMC = "{!$MessageChannel.SampleMessageChannel__c}";
function handleClick() {
const payload = {
recordId: "some string",
recordData: {value: "some value"}
}
sforce.one.publish(SAMPLEMC, payload);
}
</script>
<div>
<p>Publish SampleMessageChannel</p>
<button onclick="handleClick()">Publish</button>
</div>
</apex:page>
```

### Subscribe / Unsubscribe — `sforce.one.subscribe()` · `unsubscribe()`

subscribe·unsubscribe에는 `sforce.one.subscribe()`·`sforce.one.unsubscribe()` 메서드를 쓴다. `sforce.one.subscribe()`는 두 파라미터를 받는다 — 구독할 message channel, 그리고 message 출력을 처리하는 메서드(`onMCPublished()`). 반환된 subscription 객체를 변수에 보관한다. `unsubscribe()`에는 그 subscription 객체를 전달한다.

> Example (원문): `lmsSubscriberVisualforceRemoting` 페이지 — github.com/trailheadapps/lwc-recipes repo.

**기본 scope** — 기본적으로 message channel 통신은 active navigation tab, active navigation item, 또는 utility item 안의 컴포넌트끼리만 발생한다. Utility item은 항상 active다. Navigation tab/item은 선택됐을 때 active다. 여기 포함되는 것:
- Standard navigation tabs
- Console navigation workspace tabs
- Console navigations subtabs
- Console navigation items

**APPLICATION scope** — 애플리케이션 어디서나 메시지를 받으려면 `sforce.one.subscribe()`의 optional 네 번째 파라미터 `subscriberOptions`를 쓴다. `subscriberOptions`의 `scope`를 `"APPLICATION"`으로 설정한다.

```javascript
sforce.one.subscribe(messageChannel, listener, {scope: "APPLICATION"});
```

전체 예시 (Publish 예시의 연속):

```xml
<apex:page >
<div>
<p>Subscribe to SampleMessageChannel </p>
<button onclick="subscribeMC()">Subscribe</button>
<p>Unsubscribe from subscription</p>
<button onclick="unsubscribeMC()">Unsubscribe</button>
<br/>
<br/>
<p>Received message:</p>
<textarea id="MCMessageTextArea" rows="10"
style="disabled:true;resize:none;width:100%;"/>
</div>
<script>
// Load the MessageChannel token in a variable
var SAMPLEMC = "{!$MessageChannel.SampleMessageChannel__c}";
var subscriptionToMC;
function onMCPublished(message) {
var textArea = document.querySelector("#MCMessageTextArea");
textArea.innerHTML = message ? JSON.stringify(message, null, '\t') : 'no message
payload';
}
function subscribeMC() {
if (!subscriptionToMC) {
subscriptionToMC = sforce.one.subscribe(SAMPLEMC, onMCPublished);
}
}
function unsubscribeMC() {
if (subscriptionToMC) {
sforce.one.unsubscribe(subscriptionToMC);
subscriptionToMC = null;
}
}
</script>
</apex:page>
```

### LMS in VF — Considerations and Limitations

**Considerations** (원문):
- Lightning message service는 `<chatter:feed showPublisher="true"/>`를 쓰는 **Chatter Publisher**에서 로드되는 페이지의 Visualforce `sforce.one` 라이브러리에 대해 동작하지 않는다. 대신 native Lightning Publisher를 쓸 것.
- **iframe**으로 Lightning Experience에 포함된 Visualforce 페이지에서는 동작하지 않는다 — `<wave:dashboard>`·`<apex:iframe>`·표준 HTML `<iframe>` 태그 포함. 대신 Lightning App Builder를 통해 또는 utility bar item으로 Visualforce 페이지를 추가할 것.
- Visualforce는 **`isExposed`가 `true`인 Lightning Message Channel만 지원**한다. (자세히는 Metadata API Developer Guide의 `LightningMessageChannel` 참조.)
- **Salesforce Classic**에서, 또는 Setup에서 Visualforce를 미리보기할 때는 동작하지 않는다.

**Limitations** — LMS는 다음 경험만 지원한다 (원문):
- Lightning Experience standard navigation
- Lightning Experience console navigation
- Aura·Lightning Web Components용 Salesforce mobile app — **단 Visualforce 페이지는 지원 안 함**
- Experience Builder sites에 쓰이는 Lightning components — Experience Builder sites 지원은 beta

> **Note** (원문): Lightning Message Service는 **Salesforce Tabs + Visualforce sites**나 **Experience Builder sites의 Visualforce 페이지**와는 동작하지 않는다.

---

## 관련 노트

- [[Lightning Message Service]] — LWC 측 LMS (`lightning/messageService`·`MessageContext`·`@wire`). VF의 `sforce.one` API와 차이 비교 (위 LMS 섹션 참조)
- [[Visualforce 개요 — 도구·퀵스타트]] (같은 폴더)
- [[동적 Visualforce — 바인딩·동적 컴포넌트]] (같은 폴더)
- [[커스텀 컨트롤러·컨트롤러 확장]] (같은 폴더) — `@RemoteAction`을 두는 컨트롤러/확장
- [[페이지 출력 제어 — HTML·PDF·SLDS]] (같은 폴더)
- [[apex 컴포넌트 — AJAX·액션·Remote Objects·기타]] — Remote Objects vs JavaScript Remoting·`apex:actionFunction` 컴포넌트 레퍼런스
