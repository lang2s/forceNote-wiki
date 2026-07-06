---
tags: [visualforce, vf, component-reference, ajax, actionfunction, remote-objects, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [apex:actionFunction, apex:actionSupport, apex:remoteObjects, apex:dynamicComponent, Visualforce AJAX 컴포넌트, apex:iframe]
---

# apex 컴포넌트 — AJAX·액션·Remote Objects·기타

> [!note] Visualforce는 레거시 기술이다. 신규 개발은 Lightning Web Components(LWC) 권장.

> Visualforce 컴포넌트 레퍼런스 중 AJAX/액션 계열(`apex:actionFunction`·`apex:actionPoller`·`apex:actionRegion`·`apex:actionStatus`·`apex:actionSupport`), Remote Objects 계열(`apex:remoteObjects`·`apex:remoteObjectModel`·`apex:remoteObjectField`), 그리고 기타 컴포넌트(`apex:canvasApp`·`apex:scontrol`·`apex:dynamicComponent`·`apex:stylesheet`·`apex:includeScript`·`apex:includeLightning`·`apex:slds`·`apex:flash`·`apex:iframe`)를 attribute 표 전수로 정리한다.

---

이 노트는 Visualforce Developer Guide(v67.0 Summer '26) 컴포넌트 레퍼런스(Ch24) 중 위 17개 컴포넌트를 다룬다. 코드 예제는 모두 PDF 원문 verbatim이며, attribute 표는 PDF 6열(Attribute Name · Type · Description · Required? · API Version · Access)을 그대로 옮긴다. PDF에서 `Required?`가 빈칸이면 No, `Access`가 빈칸이면 `—`로 표기한다. 원문의 오타도 `[sic]`로 보존한다.

> Case Feed 전용 publisher 컴포넌트(`apex:emailPublisher`·`apex:logCallPublisher`)는 이 노트 범위 밖이다 — [[Case Feed Visualforce 커스터마이즈]] 참조.

---

## apex:actionFunction

A component that provides support for invoking controller action methods directly from JavaScript code using an AJAX request.

- `<apex:actionFunction>` must be a child of an `<apex:form>` component. Because binding between the caller and `<apex:actionFunction>` is done based on parameter order, ensure that the order of `<apex:param>` is matched by the caller's argument list.
- Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields.
- Unlike `<apex:actionSupport>`, which only provides support for invoking controller action methods from other Visualforce components, `<apex:actionFunction>` defines a new JavaScript function which can then be called from within a block of JavaScript code.
- **Note:** Beginning with API version 23 you can't place `<apex:actionFunction>` inside an iteration component — `<apex:pageBlockTable>`, `<apex:repeat>`, and so on. Put the `<apex:actionFunction>` after the iteration component, and inside the iteration put a normal JavaScript function that calls it.

```html
<!-- Page: -->
<apex:page controller="exampleCon">
<apex:form>
<!-- Define the JavaScript function sayHello-->
<apex:actionFunction name="sayHello" action="{!sayHello}" rerender="out"
status="myStatus"/>
</apex:form>
<apex:outputPanel id="out">
<apex:outputText value="Hello "/>
<apex:actionStatus startText="requesting..." id="myStatus">
<apex:facet name="stop">{!username}</apex:facet>
</apex:actionStatus>
</apex:outputPanel>
<!-- Call the sayHello JavaScript function using a script element-->
<script>window.setTimeout(sayHello,2000)</script>
<p><apex:outputText value="Clicked? {!state}" id="showstate" /></p>
<!-- Add the onclick event listener to a panel. When clicked, the panel triggers
the methodOneInJavascript actionFunction with a param -->
<apex:outputPanel onclick="methodOneInJavascript('Yes!')" styleClass="btn">
Click Me
</apex:outputPanel>
<apex:form>
<apex:actionFunction action="{!methodOne}" name="methodOneInJavascript"
rerender="showstate">
<apex:param name="firstParam" assignTo="{!state}" value="" />
</apex:actionFunction>
</apex:form>
</apex:page>
/*** Controller ***/
public class exampleCon {
String uname;
public String getUsername() {
return uname;
}
public PageReference sayHello() {
uname = UserInfo.getName();
return null;
}
public void setState(String n) {
state = n;
}
public String getState() {
return state;
}
public PageReference methodOne() {
return null;
}
private String state = 'no';
}
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| action | ApexPages.Action | The action method invoked when the actionFunction is called by a DOM event elsewhere in the page markup. Use merge-field syntax to reference the method. For example, action="{!save}" references the save method in the controller. If an action is not specified, the page simply refreshes. | No | 12.0 | global |
| focus | String | The ID of the component that is in focus after the AJAX request completes. | No | 12.0 | global |
| id | String | An identifier that allows the actionFunction component to be referenced by other components in the page. | No | 12.0 | global |
| immediate | Boolean | A Boolean value that specifies whether the action associated with this component should happen immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false. See Use the immediate Attribute Carefully. | No | 12.0 | global |
| name | String | The name of the JavaScript function that, when invoked elsewhere in the page markup, causes the method specified by the action attribute to execute. When the action method completes, the components specified by the reRender attribute are refreshed. | Yes | 12.0 | global |
| namespace | String | The namespace to use for the generated JavaScript function. The namespace attribute must be a simple string, beginning with a letter, and consisting of only letters, numbers, or the underscore ("_") character. For example, "MyOrg" and "Your_App_Name_v2" are supported as namespaces. If not set, no namespace is added to the JavaScript functions generated by `<apex:actionFunction>`, preserving existing behavior. | No | 12.0 | global |
| onbeforedomupdate | String | The JavaScript invoked when the onbeforedomupdate event occurs--that is, when the AJAX request has been processed, but before the browser's DOM is updated. | No | 12.0 | global |
| oncomplete | String | The JavaScript invoked when the result of an AJAX update request completes on the client. | No | 12.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 12.0 | global |
| reRender | Object | The ID of one or more components that are redrawn when the result of the action method returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | No | 12.0 | global |
| status | String | The ID of an associated component that displays the status of an AJAX update request. See the actionStatus component. | No | 12.0 | global |
| timeout | Integer | The amount of time (in milliseconds) before an AJAX update request should time out. | No | 12.0 | global |

SEE ALSO: apex:form · Comparing JavaScript Remoting and `<apex:actionFunction>`

---

## apex:actionPoller

A timer that sends an AJAX request to the server according to a time interval that you specify. Each request can result in a full or partial page update.

- An `<apex:actionPoller>` must be within the region it acts upon. For example, to use an `<apex:actionPoller>` with an `<apex:actionRegion>`, the `<apex:actionPoller>` must be within the `<apex:actionRegion>`.
- **Considerations When Using `<apex:actionPoller>`:**
  - Action methods used by `<apex:actionPoller>` should be lightweight. It's a best practice to avoid performing DML, external service calls, and other resource-intensive operations in action methods called by an `<apex:actionPoller>`. Consider carefully the effect of your action method being called repeatedly by an `<apex:actionPoller>` at the interval you specify, especially if it's used on a page that will be widely distributed, or left open for long periods.
  - `<apex:actionPoller>` refreshes the connection regularly, keeping login sessions alive. A page with `<apex:actionPoller>` on it won't time out due to inactivity.
  - To prevent concurrent AJAX requests from overriding each other and breaking your Visualforce page, don't use `<apex:actionPoller>` on a page with other components that submit AJAX requests.
  - If an `<apex:actionPoller>` is ever re-rendered as the result of another action, it resets itself.
  - You can't use a Visualforce expression to define the time interval for server requests from an Apex controller.
  - Avoid using this component with enhanced lists.

```html
<!--
Page -->
<apex:page controller="exampleCon">
<apex:form>
<apex:outputText value="Watch this counter: {!count}" id="counter"/>
<apex:actionPoller action="{!incrementCounter}" reRender="counter" interval="15"/>
</apex:form>
</apex:page>

/***
Controller: ***/
public class exampleCon {
Integer count = 0;
public PageReference incrementCounter() {
count++;
return null;
}
public Integer getCount() {
return count;
}
}
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| action | ApexPages.Action | The action method invoked by the periodic AJAX update request from the component. Use merge-field syntax to reference the method. For example, action="{!incrementCounter}" references the incrementCounter() method in the controller. If an action is not specified, the page simply refreshes. | No | 10.0 | global |
| enabled | Boolean | A Boolean value that specifies whether the poller is active. If not specified, this value defaults to true. | No | 10.0 | global |
| id | String | An identifier that allows the component to be referenced by other components in the page. | No | 10.0 | global |
| interval | Integer | The time interval between AJAX update requests, in seconds. This value must be 5 seconds or greater, and if not specified, defaults to 60 seconds. Note that the interval is only the amount of time between update requests. Once an update request is sent to the server, it enters a queue and can take additional time to process and display on the client. | No | 10.0 | global |
| oncomplete | String | The JavaScript invoked when the result of an AJAX update request completes on the client. | No | 10.0 | global |
| onsubmit | String | The JavaScript invoked before an AJAX update request has been sent to the server. | No | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| reRender | Object | The ID of one or more components that are redrawn when the result of an AJAX update request returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | No | 10.0 | global |
| status | String | The ID of an associated component that displays the status of an AJAX update request. See the actionStatus component. | No | 10.0 | global |
| timeout | Integer | The amount of time (in milliseconds) before an AJAX update request should time out. | No | 10.0 | global |

---

## apex:actionRegion

An area of a Visualforce page that demarcates which components should be processed by the Force.com server when an AJAX request is generated.

- Only the components in the body of the `<apex:actionRegion>` are processed by the server, thereby increasing the performance of the page.
- Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields.
- **Note:** Note that an `<apex:actionRegion>` component only defines which components the server processes during a request—it doesn't define what areas of the page are re-rendered when the request completes. To control that behavior, use the rerender attribute on an `<apex:actionSupport>`, `<apex:actionPoller>`, `<apex:commandButton>`, `<apex:commandLink>`, `<apex:tab>`, or `<apex:tabPanel>` component.

```html
<!-- For this example to render fully, associate the page
with a valid opportunity record in the URL.
For example: https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53 -->
<apex:page standardController="Opportunity">
<apex:form >
<apex:pageBlock title="Edit Opportunity" id="thePageBlock" mode="edit">
<apex:pageBlockButtons >
<apex:commandButton value="Save" action="{!save}"/>
<apex:commandButton value="Cancel" action="{!cancel}"/>
</apex:pageBlockButtons>
<apex:pageBlockSection columns="1">
<apex:inputField value="{!opportunity.name}"/>
<apex:pageBlockSectionItem>
<apex:outputLabel value="{!$ObjectType.opportunity.fields.stageName.label}"
for="stage"/>
<!-Without the actionregion, selecting a stage from the picklist would cause
a validation error if you hadn't already entered data in the required name
and close date fields. It would also update the timestamp.
-->
<apex:actionRegion>
<apex:inputField value="{!opportunity.stageName}" id="stage">
<apex:actionSupport event="onchange" rerender="thePageBlock"
status="status"/>
</apex:inputField>
</apex:actionRegion>
</apex:pageBlockSectionItem>
<apex:inputfield value="{!opportunity.closedate}"/>
{!text(now())}
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | No | 10.0 | global |
| immediate | Boolean | A Boolean value that specifies whether the action associated with this component should happen immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false. See Use the immediate Attribute Carefully. | No | 11.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| renderRegionOnly | Boolean | A Boolean value that specifies whether AJAX-invoked behavior outside of the actionRegion should be disabled when the actionRegion is processed. If set to true, no component outside the actionRegion is included in the AJAX response. If set to false, all components in the page are included in the response. If not specified, this value defaults to true. | No | 10.0 | global |

SEE ALSO: Apex Developer Guide: Using the transient Keyword

---

## apex:actionStatus

A component that displays the status of an AJAX update request. An AJAX request can either be in progress or complete.

- Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields.

```html
<!--
Page: -->
<apex:page controller="exampleCon">
<apex:form>
<apex:outputText value="Watch this counter: {!count}" id="counter"/>
<apex:actionStatus startText=" (incrementing...)"
stopText=" (done)" id="counterStatus"/>
<apex:actionPoller action="{!incrementCounter}" rerender="counter"
status="counterStatus" interval="15"/>
</apex:form>
</apex:page>
/*** Controller: ***/
public class exampleCon {
Integer count = 0;
public PageReference incrementCounter() {
count++;
return null;
}
public Integer getCount() {
return count;
}
}
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | No | 10.0 | global |
| for | String | The ID of an actionRegion component for which the status indicator is displaying status. | No | 10.0 | global |
| id | String | An identifier that allows the actionStatus component to be referenced by other components in the page. | No | 10.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | No | 10.0 | global |
| layout | String | The manner with which the actionStatus component should be displayed on the page. Possible values include "block", which embeds the component in a div HTML element, or "inline", which embeds the component in a span HTML element. If not specified, this value defaults to "inline". | No | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the component is clicked. | No | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the component is clicked twice. | No | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | No | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | No | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | No | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | No | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the component. | No | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the component. | No | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | No | 10.0 | global |
| onstart | String | The JavaScript invoked at the start of the AJAX request. | No | 10.0 | global |
| onstop | String | The JavaScript invoked upon completion of the AJAX request. | No | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| startStyle | String | The style used to display the status element at the start of an AJAX request, used primarily for adding inline CSS styles. | No | 10.0 | global |
| startStyleClass | String | The style class used to display the status element at the start of an AJAX request, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| startText | String | The status text displayed at the start of an AJAX request. | No | 10.0 | global |
| stopStyle | String | The style used to display the status element when an AJAX request completes, used primarily for adding inline CSS styles. | No | 10.0 | global |
| stopStyleClass | String | The style class used to display the status element when an AJAX request completes, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| stopText | String | The status text displayed when an AJAX request completes. | No | 10.0 | global |
| style | String | The style used to display the status element, regardless of the state of an AJAX request, used primarily for adding inline CSS styles. | No | 10.0 | global |
| styleClass | String | The style class used to display the status element, regardless of the state of an AJAX request, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | No | 10.0 | global |

**Facets** (actionStatus 전용):

| Facet Name | Description | API Version |
|---|---|---|
| start | The components that display when an AJAX request begins. Use this facet as an alternative to the startText attribute. Note that the order in which a start facet appears in the body of an actionStatus component does not matter, because any facet with the attribute name="start" controls the appearance of the actionStatus component when the request begins. | 10.0 |
| stop | The components that display when an AJAX request completes. Use this facet as an alternative to the stopText attribute. Note that the order in which a stop facet appears in the body of an actionStatus component does not matter, because any facet with the attribute name="stop" controls the appearance of the actionStatus component when the request completes. | 10.0 |

---

## apex:actionSupport

A component that adds AJAX support to another component, allowing the component to be refreshed asynchronously by the server when a particular event occurs, such as a button click or hover.

- Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields.

```html
<!-- Page: -->
<apex:page controller="exampleCon">
<apex:form>
<apex:outputpanel id="counter">
<apex:outputText value="Click Me!: {!count}"/>
<apex:actionSupport event="onclick"
action="{!incrementCounter}"
rerender="counter" status="counterStatus"/>
</apex:outputpanel>
<apex:actionStatus id="counterStatus"
startText=" (incrementing...)"
stopText=" (done)"/>
</apex:form>
</apex:page>
/*** Controller: ***/
public class exampleCon {
Integer count = 0;
public PageReference incrementCounter() {
count++;
return null;
}
public Integer getCount() {
return count;
}
}
```

> `disabled` 행의 Access 칸은 PDF 원문에서도 비어 있다(sic) — 이 표에서 유일하게 `global`이 아닌 컴포넌트.

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| action | ApexPages.Action | The action method invoked by the AJAX request to the server. Use merge-field syntax to reference the method. For example, action="{!incrementCounter}" references the incrementCounter() method in the controller. If an action is not specified, the page simply refreshes. | No | 10.0 | global |
| disabled | Boolean | A Boolean value that allows you to disable the component. When set to "true", the action is not invoked when the event is fired. | No | 16.0 | — |
| disableDefault | Boolean | A Boolean value that specifies whether the default browser processing should be skipped for the associated event. If set to true, this processing is skipped. If not specified, this value defaults to true. | No | 10.0 | global |
| event | String | The DOM event that generates the AJAX request. Possible values include "onblur", "onchange", "onclick", "ondblclick", "onfocus", "onkeydown", "onkeypress", "onkeyup", "onmousedown", "onmousemove", "onmouseout", "onmouseover", "onmouseup", "onselect", and so on. These values are case sensitive. | No | 10.0 | global |
| focus | String | The ID of the component that is in focus after the AJAX request completes. | No | 10.0 | global |
| id | String | An identifier that allows the component to be referenced by other components in the page. | No | 10.0 | global |
| immediate | Boolean | A Boolean value that specifies whether the action associated with this component should happen immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false. See Use the immediate Attribute Carefully. | No | 11.0 | global |
| onbeforedomupdate | String | The JavaScript invoked when the onbeforedomupdate event occurs--that is, when the AJAX request has been processed, but before the browser's DOM is updated. | No | 11.0 | global |
| oncomplete | String | The JavaScript invoked when the result of an AJAX update request completes on the client. | No | 10.0 | global |
| onsubmit | String | The JavaScript invoked before an AJAX update request has been sent to the server. | No | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| reRender | Object | The ID of one or more components that are redrawn when the result of an AJAX update request returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | No | 10.0 | global |
| status | String | The ID of an associated component that displays the status of an AJAX update request. See the actionStatus component. | No | 10.0 | global |
| timeout | Integer | The amount of time (in milliseconds) before an AJAX update request should time out. | No | 10.0 | global |

SEE ALSO: apex:actionFunction · Refreshing Chart Data Using `<apex:actionSupport>`

---

## apex:remoteObjects

Use this component, along with child `<apex:remoteObjectModel>` and `<apex:remoteObjectField>` components, to specify the sObjects and fields to access using Visualforce Remote Objects. These components generate models in JavaScript that you can use for basic create, select, update, and delete operations in your client-side JavaScript code.

> 예제 없음 — 컴포넌트 레퍼런스 섹션엔 Attributes만 수록. 사용 예제는 가이드 본문 "Visualforce Remote Objects" 챕터에 있으며 이 노트 범위 밖이다.

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| create | String | $RemoteAction override for the create method. Applies to all remote object types. | No | 43.0 | — |
| delete | String | $RemoteAction override for the create method. Applies to all remote object types. `[sic — PDF reads "create"]` | No | 43.0 | — |
| id | String | An identifier that allows the component to be referenced by other components in the page. | No | 14.0 | global |
| jsNamespace | String | The JavaScript namespace for the generated models. | No | 43.0 | — |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 14.0 | global |
| retrieve | String | $RemoteAction override for the retrieve method. Applies to all remote object types. | No | 43.0 | — |
| update | String | $RemoteAction override for the create method. Applies to all remote object types. `[sic — PDF reads "create"]` | No | 43.0 | — |

SEE ALSO: apex:remoteObjectField · apex:remoteObjectModel · Visualforce Remote Objects

---

## apex:remoteObjectModel

Defines an sObject and its fields to make accessible using Visualforce Remote Objects. This definition can include a shorthand name for the object, which you can use in JavaScript instead of the full API name. This is especially useful if your organization has a namespace, and makes your code more maintainable. Use as child of `<apex:remoteObjects>`.

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| create | String | $RemoteAction override for the create method. Applies to all remote object types. | No | 43.0 | — |
| delete | String | $RemoteAction override for the create method. Applies to all remote object types. `[sic — PDF reads "create"]` | No | 43.0 | — |
| fields | String | A list of the object's fields to make accessible. Only these fields are available when existing objects are loaded from the server. The list is a comma-delimited string of the full API names of the fields. | No | 43.0 | — |
| id | String | An identifier that allows the component to be referenced by other components in the page. | No | 14.0 | global |
| jsShorthand | String | A shorthand name, or 'nickname', that you can use in your JavaScript code, instead of the full object name. | No | 43.0 | — |
| name | String | The API name of the sObject to access. The full API name includes your organization's namespace, if you have one. | Yes | 43.0 | — |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 14.0 | global |
| retrieve | String | $RemoteAction override for the retrieve method. Applies to all remote object types. | No | 43.0 | — |
| update | String | $RemoteAction override for the create method. Applies to all remote object types. `[sic — PDF reads "create"]` | No | 43.0 | — |

SEE ALSO: apex:remoteObjectField · apex:remoteObjects · Visualforce Remote Objects

---

## apex:remoteObjectField

Defines the fields to load for an sObject. Fields defined using this component, instead of the fields attribute of `<apex:remoteObjectModel>`, can have a shorthand name, which allows the use of a "nickname" for the field in client-side JavaScript code, instead of the full API name. Use as child of `<apex:remoteObjectModel>`.

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | No | 14.0 | global |
| jsShorthand | String | The shorthand, or nickname, that can be used instead of the full field name in JavaScript code. | No | 43.0 | — |
| name | String | The API name of the sObject field. | Yes | 43.0 | — |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 14.0 | global |

SEE ALSO: apex:remoteObjectModel · apex:remoteObjects · Visualforce Remote Objects

---

## apex:canvasApp

Renders a canvas app identified by the given developerName/namespacePrefix or applicationName/namespacePrefix value pair. The developerName attribute takes precedence if both developerName and applicationName are set.

- **Requirements:** Force.com Canvas should be enabled in the organization.
- Keep the following considerations in mind:
  - A development organization is an organization in which a canvas app is developed and packaged.
  - An installation organization is an organization in which a packaged canvas app is installed.
  - The `<apex:canvasApp>` component usage in a Visualforce page isn't updated if a canvas app's application name or developer name is changed.
  - A canvas app can be deleted even if there's a Visualforce page referencing it via `<apex:canvasApp>`.
- **Note:** The canvas app is rendered within a div element, the div element id can be retrieved by `{!$Component.genContainer}`.

```html
<apex:page showHeader="false">
<apex:canvasApp developerName="canvasAppDeveloperName"/>
</apex:page>

<apex:page showHeader="false">
<apex:canvasApp applicationName="canvasAppName"/>
</apex:page>

<apex:page showHeader="false">
<apex:canvasApp developerName="canvasAppDeveloperName"
namespacePrefix="fromDevOrgNamespacePrefix"/>
</apex:page>

<apex:page showHeader="false">
<apex:canvasApp applicationName="canvasAppName"
namespacePrefix="fromDevOrgNamespacePrefix"/>
</apex:page>

<apex:page showHeader="false">
<apex:outputPanel layout="block" id="myContainer">
<apex:canvasApp developerName="canvasAppName"
namespacePrefix="fromDevOrgNamespacePrefix" containerId="{!$Component.myContainer}"/>
</apex:outputPanel>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| applicationName | String | Name of the canvas app. Either applicationName or developerName is required. | No | 43.0 | — |
| border | String | Width of the canvas app border, in pixels. If not specified, defaults to 0 px. | No | 43.0 | — |
| canvasId | String | Unique ID of the canvas app window. Use this attribute when targeting events to the canvas app. | No | 43.0 | — |
| containerId | String | An HTML element ID in which the canvas app is rendered. If not specified, defaults to null. The container specified by this can't appear after the `<apex:canvasApp>` component. | No | 43.0 | — |
| developerName | String | Developer name of the canvas app. This name is defined when the canvas app is created and can be viewed in the Canvas App Previewer. Either developerName or applicationName is required. | No | 43.0 | — |
| entityFields | String | Specifies the fields returned in the signed request Entity object when the component appears on a Visualforce page placed on an object. If this attribute isn't specified or is blank, then only Id and type information is provided. Valid attribute values include: • Comma-separated list of field names. For example, to return the Account Phone and Fax fields, the attribute would look like: entityFields="Phone,Fax" • Asterisk "*" to return all fields from the associated object. | No | 43.0 | — |
| height | String | Canvas app window height, in pixels. If not specified, defaults to 900 px. | No | 43.0 | — |
| id | String | An identifier that allows the component to be referenced by other components in the page. | No | 14.0 | global |
| maxHeight | String | The maximum height of the Canvas app window in pixels. Defaults to 2000 px; 'infinite' is also a valid value | No | 43.0 | — |
| maxWidth | String | The maximum width of the Canvas app window in pixels. Defaults to 1000 px; 'infinite' is also a valid value | No | 43.0 | — |
| namespacePrefix | String | Namespace value of the Developer Edition organization in which the canvas app was created. Optional if the canvas app wasn't created in a Developer Edition organization. If not specified, defaults to null. | No | 43.0 | — |
| onCanvasAppError | String | Name of the JavaScript function to be called if the canvas app fails to render. | No | 43.0 | — |
| onCanvasAppLoad | String | Name of the JavaScript function to be called after the canvas app loads. | No | 43.0 | — |
| parameters | String | Object representation of parameters passed to the canvas app. This should be supplied in JSON format or as a JavaScript object literal. Here's an example of parameters in a JavaScript object literal: `{param1:'value1',param2:'value2'}` If not specified, defaults to null. **Note:** If the value of parameters exceeds approximately 8KB, your Canvas app may fail to load in Chromium-based browsers. This is due to an internal response header size limit. The redirect used by Canvas passes parameters via the Location: header, which has a maximum size. If exceeded, an HTTP 500 error is returned. To avoid this issue, keep parameters small or use a token-based approach where large data is fetched server-side by the Canvas app after loading. | No | 43.0 | — |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 14.0 | global |
| scrolling | String | Specifies whether the canvas app window should use scroll bars. Valid values are auto\|yes\|no. If not specified or set to an invalid value, it will default to no. | No | 43.0 | — |
| width | String | Canvas app window width, in pixels. If not specified, defaults to 800 px. | No | 43.0 | — |

SEE ALSO: Canvas Developer Guide: Canvas Apps and Visualforce Pages

---

## apex:scontrol

An inline frame that displays an s-control.

- **Note:** s-controls have been superseded by Visualforce pages. After March 2010 organizations that have never created s-controls, as well as new organizations, won't be allowed to create them. Existing s-controls remain unaffected.

```html
<!-- For this component to work, you must have a valid s-control defined. -->
<apex:page>
<apex:scontrol controlName="HelloWorld" />
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| controlName | String | The name of the s-control displayed. For this value, use the s-control's name field, not its label. | No | 10.0 | global |
| height | Integer | The height of the inline frame that should display the s-control, expressed either as a percentage of the total available vertical space (for example height="50%"), or as the number of pixels (for example, height="300px"). | No | 10.0 | global |
| id | String | An identifier that allows the s-control component to be referenced by other components in the page. | No | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| scrollbars | Boolean | A Boolean value that specifies whether the s-control can be scrolled. If not specified, this value defaults to true. | No | 10.0 | global |
| subject | Object | The ID of the record that should provide data for this s-control. | No | 10.0 | global |
| width | Integer | The width of the inline frame that should display the s-control, expressed either as the number of pixels or as a percentage of the total available horizontal space. To specify the number of pixels, set this attribute to a number followed by px, (for example, width="600px"). To specify a percentage, set this attribute to a number preceded by a hyphen (for example width="-80"). | No | 10.0 | global |

---

## apex:dynamicComponent

This tag acts as a placeholder for your dynamic Apex components. It has one required parameter—componentValue—which accepts the name of an Apex method that returns a dynamic component.

- The following Visualforce components do not have dynamic Apex representations: `<apex:attribute>`, `<apex:component>`, `<apex:componentBody>`, `<apex:composition>`, `<apex:define>`, `<apex:dynamicComponent>`, `<apex:include>`, `<apex:insert>`, `<apex:param>`, `<apex:variable>`.

```html
<apex:page controller="SimpleDynamicController">
<apex:dynamicComponent componentValue="{!dynamicDetail}" />
</apex:page>
/* Controller */
public class SimpleDynamicController {
public Component.Apex.Detail getDynamicDetail() {
Component.Apex.Detail detail = new Component.Apex.Detail();
detail.expressions.subject = '{!acct.OwnerId}';
detail.relatedList = false;
detail.title = false;
return detail;
}
// Just return the first Account, for example purposes only
public Account acct {
get { return [SELECT Id, Name, OwnerId FROM Account LIMIT 1]; }
}
}
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| componentValue | UIComponent | Accepts the name of an Apex method that returns a dynamic Visualforce component. | Yes | 22.0 | — |
| id | String | An identifier that allows the attribute to be referenced by other tags in the custom component definition. | No | 22.0 | global |
| invokeAfterAction | Boolean | A Boolean value that, when true, specifies that componentValue's Apex method is called after the page's or submit's action method is invoked. | No | 31.0 | — |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 22.0 | — |

SEE ALSO: Creating and Displaying Dynamic Components

---

## apex:stylesheet

A link to a stylesheet that can be used to style components on the Visualforce page. When specified, this component injects the stylesheet reference into the head element of the generated HTML page.

- This component supports HTML pass-through attributes using the "html-" prefix. Pass-through attributes are attached to the generated `<link>` tag.

```html
<apex:stylesheet value="/resources/htdocs/css/basic.css"/>
```
The example above renders the following HTML:
```html
<link rel="stylesheet"
type="text/css" href="/resources/htdocs/css/basic.css"/>
```
Zip Resource Example:
```html
<apex:stylesheet value="{!URLFOR($Resource.StyleZip, 'basic.css')}"/>
```
The example above renders the following HTML:
```html
<link rel="stylesheet"
type="text/css" href="[generatedId]/basic.css"/>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows other components in the page to reference the stylesheet component. | No | 10.0 | global |
| value | Object | The URL to the style sheet file. Note that this can be a reference to a static resource. | Yes | 10.0 | global |

SEE ALSO: apex:slds · Using Custom Styles · Extending Salesforce Styles with Stylesheets

---

## apex:includeScript

A link to a JavaScript library that can be used in the Visualforce page. When specified, this component injects a script reference into the `<head>` element of the generated HTML page.

- Multiple references to the same script are de-duplicated, making this component safe to use inside an iteration component. This might occur if, for example, you use an `<apex:includeScript>` inside a custom component, and then use that component inside an `<apex:repeat>` iteration.
- For performance reasons, you might choose to use a static JavaScript tag before your closing `<apex:page>` tag, rather than this component. If you do, you'll need to manage de-duplication yourself.
- This component supports HTML pass-through attributes using the "html-" prefix. Pass-through attributes are attached to the generated `<script>` tag.

```html
<apex:includeScript value="{!$Resource.example_js}"/>
```
The example above renders the following HTML:
```html
<script type='text/javascript' src='/resource/1233160164000/example_js'>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows other components in the page to reference the component. | No | 13.0 | global |
| loadOnReady | Boolean | Specify whether the script resource is loaded immediately, or after the document model is constructed. The default value of "false" loads the script immediately. Set to "true" to cause JavaScript referenced by the component to wait to be loaded until the page is "ready." Scripts loaded this way will be added to the DOM after the onload event is triggered, instead of immediately. This event occurs after the DOM is constructed, but might be before child frames or external resources, such as images, have finished loading. | No | 29.0 | global |
| value | Object | The URL to the JavaScript file. This can be a reference to a static resource, a best practice, but can also be a plain URL. | Yes | 13.0 | global |

---

## apex:includeLightning

Includes the Lightning Components for Visualforce JavaScript library, lightning.out.js, from the correct Salesforce domain.

- **Note:** The Lightning Components for Visualforce JavaScript library loads from the org that the Visualforce page is in, so your Lightning Out app must exist in the same org as the Visualforce page.

> 예제 없음 — 컴포넌트 레퍼런스 섹션엔 Attributes만 수록.

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | No | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 14.0 | global |

SEE ALSO: Render Lightning Runtime for Flows in a Visualforce Page

---

## apex:slds

Allows Visualforce pages to reference Lightning Design System styling and to include custom themes. Use this component instead of uploading the Lightning Design System as a static resource.

- Include `<apex:slds />` in a Visualforce page to use Lightning Design System stylesheets in the page.
- In general, the Lightning Design System is already scoped. Visualforce pages that have showHeader="true" already apply a scoping CSS class slds-scope to the content of the page, so that your content is styled with the Lightning Design System. Additionally, pages with showHeader="false" and applyBodyTag="true" have the scoping class added to the `<body>` element in the page. If you set applyBodyTag or applyHtmlTag to false, however, you must include the scoping class slds-scope. Within the scoping class, your markup can reference Lightning Design System styles and assets.
- To reference assets in the Lightning Design System, such as SVG icons and other images, use the URLFOR() formula function and the $Asset.SLDS global variable. To use SVG icons, add the required XML namespaces by using `xmlns="http://www.w3.org/2000/svg"` and `xmlns:xlink="http://www.w3.org/1999/xlink"` in the html tag.
- Currently, if you are using the Salesforce sidebar, header, or built-in stylesheets, you can't add attributes to the html tag. SVG icons aren't supported on your page if you don't have showHeader, standardStylesheets, and sidebar set to false.
- **Note:** The `<apex:slds>` component has known issues when creating PDF files from Visualforce pages. This component isn't supported for creating PDF files using `<apex:page renderAs="pdf">` or in calls to `PageReference.getContentAsPDF()`.

```html
<apex:page showHeader="false" applyHtmlTag="true" applyBodyTag="false">
<head>
<apex:slds />
</head>
<body class="slds-scope" xmlns="http://www.w3.org/2000/svg"
xmlns:xlink="http://www.w3.org/1999/xlink">
<!-- Your SLDS-styled content -->
<span class="slds-icon_container slds-icon-utility-announcement" title="Description
of icon when needed">
<svg class="slds-icon slds-icon-text-default" aria-hidden="true">
<use xlink:href="{!URLFOR($Asset.SLDS,
'/assets/icons/utility-sprite/svg/symbols.svg#announcement')}"></use>
</svg>
<span class="slds-assistive-text">Description of icon when needed</span>
</span>
</body>
</apex:page>
```

> `rendered` 행의 Access 칸은 PDF 원문에 미표기되어 있다(sic).

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the SLDS component to be referenced by other components in the page. | No | 14.0 | global |
| lightningStyleMode | String | Specify the version of SLDS to use within this component block. Allowed values are: • Auto (default) • SLDS1. The default value of Auto uses your org theme settings to determine which version of SLDS to use. For more details, see Customize the User Interface in the Salesforce Help. SLDS1 is available for backwards compatibility as you adopt the latest version of Lightning Design System. Use SLDS1 when your org is using the latest version of SLDS, but this page hasn't been updated for the new design and depends on the older version of SLDS. | No | 65.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 39.0 | — |

SEE ALSO: apex:stylesheet · Using the Lightning Design System

---

## apex:flash

A Flash movie, rendered with the HTML object and embed tags.

- **Note:** This component is supported only on Visualforce pages with an API version 49.0 or earlier. Flash itself isn't supported in any modern browser supported by Salesforce.

```html
<apex:page sidebar="false" showheader="false">
<apex:flash src="http://www.adobe.com/devnet/flash/samples/drawing_1/1_coordinates.swf"
height="300" width="100%" />
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| flashvars | String | The flashvars attribute can be used to import root level variables to the movie. All variables are created before the first frame of the SWF is played. The value should consist of a list of ampersand-separated name-value pairs. | No | 14.0 | — |
| height | String | The height at which this movie is displayed, expressed either as a relative percentage of the total available vertical space (for example, 50%) or as a number of pixels (for example, 100). | Yes | 14.0 | — |
| id | String | An identifier that allows the component to be referenced by other components in the page. | No | 14.0 | global |
| loop | Boolean | A Boolean value that specifies whether the flash movie plays repeatedly or just once. If set to true, the flash movie plays repeatedly. If not specified, this value defaults to false. | No | 14.0 | — |
| play | Boolean | A Boolean value that specifies whether the flash movie automatically begins playing when displayed. If set to true, the flash movie automatically begins playing. If not specified, the value defaults to false. | No | 14.0 | — |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 14.0 | global |
| src | String | The path to the movie displayed, expressed as a URL. Note that a flash movie can be stored as a static resource in Salesforce. | Yes | 14.0 | — |
| width | String | The width at which this movie is displayed, expressed either as a relative percentage of the total available horizontal space (for example, 50%) or as a number of pixels (for example, 100). | Yes | 14.0 | — |

---

## apex:iframe

A component that creates an inline frame within a Visualforce page. With a frame, you can keep some information visible while other information is scrolled or replaced.

- This component supports HTML pass-through attributes using the html prefix. Pass-through attributes are attached to the generated `<iframe>` tag.
- **Note:** External websites included in Salesforce use iframes, which restrict features that can track users. When the external website is in an iframe, browser settings can prevent the external website from using local storage and receiving or writing third-party cookies in callouts to APIs.
- To prevent clickjacking attacks, many websites, including https://salesforce.com, restrict browsers from rendering their pages in an inline frame. For example, if a page has its X-Frame-Options HTTP response header set to sameorigin, a browser can only load that page in an inline frame if the frame has the same origin as the page.
- Also, to frame content from an external website that requires authentication, the authentication process can require a cookie. Because the external website is on a different domain than the Visualforce page, that cookie is a third-party cookie. When browsers block third-party cookies, you can't load the authenticated content unless the website owner provides another authentication method.

```html
<apex:iframe src="https://amazon.com" scrolling="true" id="theIframe"/>
```
The previous example renders the following HTML:
```html
<iframe height="600px" id="theIframe" name="theIframe" src="https://amazon.com"
width="100%"></iframe>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| frameborder | Boolean | A Boolean value that specifies whether a border surrounds the inline frame. If not specified, this value defaults to false. | No | 10.0 | global |
| height | String | The height of the inline frame expressed either as a percentage of the total available vertical space (for example, height="50%") or as the number of pixels (for example, height="300px"). If not specified, this value defaults to 600 px. | No | 10.0 | global |
| id | String | An identifier that allows other components in the page to reference the inline frame component. | No | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| scrolling | Boolean | A Boolean value that specifies whether the inline frame can be scrolled. If not specified, this value defaults to true. | No | 10.0 | global |
| src | String | The URL that specifies the initial contents of the inline frame. This URL can either be an external website or another page in the application. For example, to render the static resource MyAsset on a separate domain from Visualforce: `<apex:iframe src="{$IFrameResource.MyAsset}" scrolling="true" id="theIframe"/>` | No | 10.0 | global |
| title | String | The text to display as a tooltip when the user's pointer hovers over this component. | No | 10.0 | global |
| width | String | The width of the inline frame expressed either as a percentage of the total available horizontal space (for example, width="80%") or as the number of pixels (for example, width="600px"). | No | 10.0 | global |

SEE ALSO: Put Visualforce Pages on External Domains · Referencing Untrusted Third-Party Content with iframes

---

## Case Feed Publisher 컴포넌트 (위임)

아래 2개 컴포넌트는 Case Feed 전용으로, 속성표는 [[Case Feed Visualforce 커스터마이즈]]에 정리돼 있다.

- **apex:emailPublisher** — The email publisher lets support agents who use Case Feed compose and send email messages to customers. You can customize this publisher to support email templates and attachments. This component can only be used in organizations that have Case Feed and Email-to-Case enabled. Ext JS versions less than 3 should not be included on pages that use this component. → 속성표는 [[Case Feed Visualforce 커스터마이즈]] 참조.
- **apex:logCallPublisher** — The Log a Call publisher lets support agents who use Case Feed create logs for customer calls. This component can only be used in organizations that have Case Feed, Chatter, and feed tracking on cases enabled. → 속성표는 [[Case Feed Visualforce 커스터마이즈]] 참조.

---

## 관련 노트

- [[Case Feed Visualforce 커스터마이즈]] — apex:emailPublisher · apex:logCallPublisher 속성표
- [[apex 컴포넌트 — 입력·폼]] (apex:inputField · apex:form 등 — `<apex:actionFunction>`의 부모 컴포넌트)
- [[apex 컴포넌트 — 출력·데이터·반복·차트]] (apex:outputPanel · apex:repeat 등)
- [[apex 컴포넌트 — 페이지·레이아웃 구조]] (apex:page · apex:pageBlock 등)
- [[동적 Visualforce — 바인딩·동적 컴포넌트]] (apex:dynamicComponent의 Apex 측 Component.Apex.* 동적 생성)
- [[페이지 출력 제어 — HTML·PDF·SLDS]] (apex:slds · renderAs="pdf" 제약)
- [[JavaScript·Remoting·LMS across DOM]] (Remote Objects vs JavaScript Remoting)
- [[VF AJAX 패턴 → LWC 대응]] — actionPoller·actionFunction·actionSupport·reRender를 LWC로 옮길 때의 대응 패턴
