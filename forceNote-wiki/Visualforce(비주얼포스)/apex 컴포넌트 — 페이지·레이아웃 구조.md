---
tags: [visualforce, vf, component-reference, apex-page, layout, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26)
created: 2026-06-21
aliases: [apex:page 속성, apex:pageBlock, apex:panelGrid, apex:tabPanel, Visualforce 페이지 레이아웃 컴포넌트, apex:form]
---

# apex 컴포넌트 — 페이지·레이아웃 구조

> [!note] Visualforce는 레거시 기술이다. 신규 개발은 Lightning Web Components(LWC) 권장.

> 표준 Visualforce 컴포넌트 레퍼런스(Ch24) 중 **페이지 골격·템플릿·레이아웃·패널·탭·툴바** 23개 컴포넌트의 설명·예제·attribute 전수. 소스: Visualforce Developer Guide v67.0 Summer '26, Ch24 "Standard Visualforce Component Reference".

---

## 읽는 법 (attribute 표 규약)

각 컴포넌트마다 6열 attribute 표를 둔다. PDF 원문 표를 셀 단위로 옮긴 것이다.

| 열 | 의미 |
|---|---|
| Attribute Name | 속성명 (대소문자 verbatim) |
| Type | 데이터 타입 (`Object`·`Boolean`·`ApexPages.PageReference` 등) |
| Description | 원문 설명 verbatim |
| Required? | 원문 공란이면 `No` |
| API Version | 도입 API 버전 |
| Access | 원문 공란이면 `—` (원문에 값 없음 — 임의로 `global` 채우지 않음) |

- 23개 컴포넌트 전부 PDF 페이지 이미지(`pdftoppm`)로 셀 단위 검증됨. pdftotext의 6열 collapse를 이미지로 우회.
- 일부 long description은 원문 셀 폭 클립으로 끝부분이 매끄럽지 않게 잘렸다(특히 `apex:page`의 `readOnly`·`deferLastCommandUntilReady`·`title`, `apex:pageBlock`의 `mode`·`tabStyle`). 타입·API·Required는 정확하다. 이런 잔재는 원문 그대로 두고 [sic]로 표기한다.
- HTML pass-through: 다수 컴포넌트가 `html-` prefix 속성을 지원해 생성된 container 태그(`<div>`/`<span>`/`<table>`/`<td>` 등 layout에 따름)에 부착한다 — 각 컴포넌트 설명에 명시.

---

## 1. apex:component

A custom Visualforce component. All custom component definitions must be wrapped inside a single `<apex:component>` tag. HTML pass-through attributes 지원("html-" prefix → 생성된 container `<div>`/`<span>`에 부착, layout attribute에 따름).

```html
<!-- Page: -->
<apex:page>
<c:myComponent myValue="My component's value" borderColor="red" />
</apex:page>
<!-- Component:myComponent -->
<apex:component>
<apex:attribute name="myValue" description="This is the value for the component."
type="String" required="true"/>
<apex:attribute name="borderColor" description="This is color for the border."
type="String" required="true"/>
<h1 style="border:{!borderColor}">
<apex:outputText value="{!myValue}"/>
</h1>
</apex:component>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| access | String | Indicates whether the component can be used outside of any page in the same namespace as the component. Possible values are "public" (default) and "global". Use global to indicate the component can be used outside of the component's namespace. If access is global, the access attribute on all required child apex:attributes must also be global. If access is public, child apex:attributes' access cannot be global. Note: Components with this designation are subject to the deprecation policies as described for managed packages. | No | 14.0 | — |
| allowDML | Boolean | If "true", you can include DML within the component. Default "false". Allowing DML can cause side-effects problematic for consumers using partial page updates. When allowing DML, include rerender attributes so the consumer can refresh. Detail in the description what data is manipulated by the DML. | No | 13.0 | global |
| controller | String | The name of the Apex controller used to control the behavior of this custom component. | No | 12.0 | global |
| extensions | String | The name of one or more controller extensions that add additional logic to this custom component. | No | 12.0 | global |
| id | String | An identifier that allows the component to be referenced by other tags in the component definition. | No | 12.0 | global |
| language | String | The language used to display labels that have associated translations in Salesforce. Overrides the language of the user viewing the component. Possible values include any language keys for languages supported by Salesforce, e.g. "en" or "en-US". See "Supported Languages" in Salesforce Help. | No | 12.0 | global |
| layout | String | The HTML layout style for the component. Possible values: "block" (wraps with HTML div tag), "inline" (wraps with HTML span tag), and "none" (no wrapping HTML tag). Defaults to "inline". | No | 12.0 | global |
| rendered | Boolean | Boolean specifying whether the custom component is rendered. Defaults to "true". | No | 12.0 | global |
| selfClosing | Boolean | Boolean specifying how the Visualforce editor closes this component. If "true", editor auto-completes as self-closing tag; if not, with open and close tags. E.g. on a component myComponent, "true" → `<c:myComponent/>`, "false" → `<c:myComponent></c:myComponent>`. If the component includes a componentBody, default is "false". If not, default is "true". | No | 15.0 | — |
| shouldAlwaysEscapeExpressionLanguage | Boolean | The attribute shouldAlwaysEscapeExpressionLanguage was deprecated in Salesforce API version 57.0 and has no effect on the page. If you already added this attribute in response to the Escape Expression Language Evaluations release update, please remove it. To ensure security: 1. Reintroduce any manual escaping that you removed for this release update. 2. Delete the attribute from your Visualforce pages or components. | No | 57.0 | — |

**SEE ALSO:** apex:componentBody · Creating and Using Custom Components · Using Custom Components in a Visualforce Page

---

## 2. apex:componentBody

Allows a custom component author to define a location where a user can insert content into the custom component (useful for custom iteration components). Valid only within `<apex:component>`, only a single definition per custom component.

**Simple Example:**
```html
<!-- Page: -->
<apex:page>
<apex:outputText value="(page) This is before the custom component"/><br/>
<c:bodyExample>
<apex:outputText value="(page) This is between the custom component" /> <br/>
</c:bodyExample>
<apex:outputText value="(page) This is after the custom component"/><br/>
</apex:page>
<!-- Component: bodyExample -->
<apex:component>
<apex:outputText value="First custom component output" /> <br/>
<apex:componentBody />
<apex:outputText value="Second custom component output" /><br/>
</apex:component>
```

**Advanced Example:**
```html
<!-- Page: -->
<apex:page >
<c:myaccounts var="a">
<apex:panelGrid columns="2" border="1">
<apex:outputText value="{!a.name}"/>
<apex:panelGroup >
<apex:panelGrid columns="1">
<apex:outputText value="{!a.billingstreet}"/>
<apex:panelGroup >
<apex:outputText value="{!a.billingCity},
{!a.billingState} {!a.billingpostalcode}"/>
</apex:panelGroup>
</apex:panelGrid>
</apex:panelGroup>
</apex:panelGrid>
</c:myaccounts>
</apex:page>
<!-- Component: myaccounts-->
<apex:component controller="myAccountsCon">
<apex:attribute name="var" type="String" description="The variable to represent
a single account in the iteration."/>
<apex:repeat var="componentAccount" value="{!accounts}">
<apex:componentBody >
<apex:variable var="{!var}" value="{!componentAccount}"/>
</apex:componentBody>
</apex:repeat>
</apex:component>
/*** Controller ***/
public class myAccountsCon {
public List<Account> accounts {
get {
accounts = [select name, billingcity, billingstate, billingstreet, billingpostalcode
from account where ownerid = :userinfo.getuserid()];
return accounts;
}
set;
}
}
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | No | 13.0 | global |
| rendered | Boolean | Boolean specifying whether the component is rendered on the page. Defaults to true. | No | 13.0 | global |

---

## 3. apex:composition

An area of a page that includes content from a second template page. Template pages include one or more `<apex:insert>` components. `<apex:composition>` names the associated template and provides body for the template's `<apex:insert>` components with matching `<apex:define>` components. Any content outside an `<apex:composition>` is not rendered. (Note: Use to get user input for a controller method that does not correspond to an sObject field. Only `<apex:inputField>`/`<apex:outputField>` can be used with sObject fields.)

```html
<!-- Page: composition -->
<!-- This page acts as the template. Create it first, then the page below. -->
<apex:page>
<apex:outputText value="(template) This is before the header"/><br/>
<apex:insert name="header"/><br/>
<apex:outputText value="(template) This is between the header and body"/><br/>
<apex:insert name="body"/>
</apex:page>
<!-- Page: page -->
<apex:page>
<apex:composition template="composition">
<apex:define name="header">(page) This is the header of mypage</apex:define>
<apex:define name="body">(page) This is the body of mypage</apex:define>
</apex:composition>
</apex:page>
```
renders:
```
(template) This is before the header<br/>
(page) This is the header of mypage<br/>
(template) This is between the header and body<br/>
(page) This is the body of mypage
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| rendered | String | This attribute has no effect on the display of this component. If you wish to conditionally display a `<apex:component>` wrap it inside a `<apex:outputPanel>` component, and add the conditional expression to its rendered attribute. | No | 10.0 | global |
| template | ApexPages.PageReference | The template page used for this component. For this value, specify the name of the Visualforce page or use merge-field syntax to reference a page or PageReference. | Yes | 10.0 | global |

**SEE ALSO:** apex:define · apex:insert · Defining Templates with `<apex:composition>`

---

## 4. apex:define

A template component that provides content for an `<apex:insert>` component defined in a Visualforce template page. (Note: Use to get user input for a controller method that does not correspond to an sObject field. Only `<apex:inputField>`/`<apex:outputField>` with sObject fields.)

```html
<!-- Page: composition -->
<!-- This page acts as the template. Create it first, then the page below. -->
<apex:page>
<apex:outputText value="(template) This is before the header"/><br/>
<apex:insert name="header"/><br/>
<apex:outputText value="(template) This is between the header and body"/><br/>
<apex:insert name="body"/>
</apex:page>
<!-- Page: page -->
<apex:page>
<apex:composition template="composition">
<apex:define name="header">(page) This is the header of mypage</apex:define>
<apex:define name="body">(page) This is the body of mypage</apex:define>
</apex:composition>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| name | String | The name of the insert component into which the content of this define component must be inserted. | Yes | 10.0 | global |

**SEE ALSO:** apex:composition · apex:insert

---

## 5. apex:facet

A placeholder for content that's rendered in a specific part of the parent component, such as the header or footer of an `<apex:dataTable>`. A `<apex:facet>` component can only exist in the body of a parent component if the parent supports facets.

**Note (verbatim):** "An `<apex:facet>` component can only exist in the body of a parent component if the parent supports facets. The name of each facet component must match one of the pre-defined facet names on the parent component. This name determines where the content of the facet component is rendered." (also: "Note: Although you can't represent an `<apex:facet>` directly in Apex, you can specify it in a dynamic component that has the facet. For example: `Component.apex.DataTable dt = new Component.apex.DataTable(); dt.facets.header = 'Header Facet';`")

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL.
For example, if 001D000000IRt53 is the account ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<apex:page standardController="Account">
<apex:pageBlock title="Contacts">
<apex:dataTable value="{!account.Contacts}" var="contact" cellPadding="4" border="1">
<apex:column >
<apex:facet name="header">Name</apex:facet>
{!contact.Name}
</apex:column>
<apex:column >
<apex:facet name="header">Phone</apex:facet>
{!contact.Phone}
</apex:column>
</apex:dataTable>
</apex:pageBlock>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| name | String | The name of the facet to be rendered. This name must match one of the pre-defined facet names on the parent component and determines where the content of the facet component is rendered. For example, the dataTable component includes facets named "header", "footer", and "caption". | Yes | 10.0 | global |

**SEE ALSO:** apex:dataTable · Best Practices for Using Component Facets

---

## 6. apex:form

A section of a Visualforce page that allows users to enter input and then submit it with an `<apex:commandButton>` or `<apex:commandLink>`. (Note: As of API version 18.0, the `<apex:form>` tag can't have a child component of `<apex:form>`. HTML pass-through attributes 지원("html-" prefix → 생성된 `<form>` tag에 부착).)

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accept | String | A comma-separated list of content types that a server processing this form can handle. Possible values for this attribute include "text/html", "image/png", "image/gif", "video/mpeg", "text/css", and "audio/basic". For more information, including a complete list of possible values, see the W3C specifications. | No | 10.0 | global |
| acceptcharset | String | A comma-separated list of character encodings that a server processing this form can handle. If not specified, this value defaults to "UNKNOWN". | No | 10.0 | global |
| dir | String | The direction in which the generated HTML output should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | No | 10.0 | global |
| enctype | String | The content type used to submit the form to the server. If not specified, this value defaults to "application/x-www-form-urlencoded". | No | 10.0 | global |
| forceSSL | Boolean | The form will be submitted using SSL, regardless of whether the page itself was served with SSL. The default is false. If the value is true, the form will be submitted using SSL, even when the form is submitted from an unsecured page. | No | 14.0 | — |
| id | String | An identifier that allows the form component to be referenced by other components in the page. | No | 10.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | No | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the form. | No | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the form twice. | No | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | No | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | No | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | No | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | No | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the form. | No | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the form. | No | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | No | 10.0 | global |
| onreset | String | The JavaScript invoked if the onreset event occurs--that is, if the user clicks the reset button on the form. | No | 10.0 | global |
| onsubmit | String | The JavaScript invoked if the onsubmit event occurs--that is, if the user submits the form. | No | 10.0 | global |
| prependId | Boolean | A Boolean value that specifies whether or not this form should prepend its ID to the IDs of its child components during the clientid generation process. If not specified, this value defaults to true. | No | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| style | String | The style used to display the form component, used primarily for adding inline CSS styles. | No | 10.0 | global |
| styleClass | String | The style class used to display the form component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| target | String | The name of the frame that displays the response after the form is submitted. Possible values for this attribute include "_blank", "_parent", "_self", and "_top". You can also specify your own target name by assigning a value to the name attribute of a desired component. | No | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | No | 10.0 | global |

**SEE ALSO:** apex:commandButton · apex:commandLink

---

## 7. apex:include

A component that inserts a second Visualforce page into the current page. The entire page subtree is injected into the Visualforce DOM at the point of reference, and the scope of the included page is maintained. (Note: If content should be stripped from the included page, use the `<apex:composition>` component instead.)

```html
<!-- Page: -->
<apex:page>
<apex:outputText value="(page) This is the page."/><br/>
<apex:include pageName="include"/>
</apex:page>
```
renders:
```
(page) This is the page.<br/>
<span id="thePage:include">(include) This is text from another page.</span>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the inserted page to be referenced by other components in the page. | No | 10.0 | global |
| pageName | ApexPages.PageReference | The Visualforce page whose content should be inserted into the current page. For this value, specify the name of the Visualforce page or use merge-field syntax to reference a page or PageReference. | Yes | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |

**SEE ALSO:** Referencing an Existing Page with `<apex:include>`

---

## 8. apex:insert

A template component that declares a named area that must be defined by an `<apex:define>` component in another Visualforce page. Use this component with the `<apex:composition>` and `<apex:define>` components to share data between multiple pages.

```html
<!-- Page: composition -->
<!-- This page acts as the template. Create it first, then the page below. -->
<apex:page>
<apex:outputText value="(template) This is before the header"/><br/>
<apex:insert name="header"/><br/>
<apex:outputText value="(template) This is between the header and body"/><br/>
<apex:insert name="body"/>
</apex:page>
<!-- Page: page -->
<apex:page>
<apex:composition template="composition">
<apex:define name="header">(page) This is the header of mypage</apex:define>
<apex:define name="body">(page) This is the body of mypage</apex:define>
</apex:composition>
</apex:page>
```
renders:
```
(template) This is before the header<br/>
(page) This is the header of mypage<br/>
(template) This is between the header and body<br/>
(page) This is the body of mypage
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| name | String | The name of the matching define tag that provides the content to be inserted into this Visualforce page. | Yes | 10.0 | global |

**SEE ALSO:** apex:composition · apex:define

---

## 9. apex:outputPanel

A set of content that is grouped together, rendered with an HTML `<span>` tag, `<div>` tag, or neither. Use an `<apex:outputPanel>` to group components together for AJAX refreshes. HTML pass-through attributes 지원("html-" prefix → 생성된 container tag(`<div>` 또는 `<span>`, layout attribute에 따름)에 부착).

**Span Example:**
```html
<!-- Specs do not add any additional formatting to the body of the outputPanel. -->
<apex:outputPanel id="thePane1">My span</apex:outputPanel>
```
renders: `<span id="thePane1">My span</span>`

**Div Example:**
```html
<!-- Div places the body of the outputPanel within the equivalent of an HTML paragraph tag. -->
<apex:outputPanel id="thePane1" layout="block">My div</apex:outputPanel>
```
renders: `<div id="thePane1">My div</div>`

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | No | 10.0 | global |
| id | String | An identifier that allows the outputPanel component to be referenced by other components in the page. | No | 10.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | No | 10.0 | global |
| layout | String | The layout style for the panel. Possible values include "block" (which generates an HTML div tag), "inline" (which generates an HTML span tag), and "none" (which does not generate an HTML tag). If not specified, this value defaults to "inline". Note: If layout is set to "inline", the outputPanel generates a span tag with the "html-id" value. If the component doesn't have an id attribute, the value defaults to "j_id" plus a number. | No | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the panel. | No | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the panel twice. | No | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | No | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | No | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | No | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | No | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the output panel. | No | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the output panel. | No | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | No | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| style | String | The style used to display the outputPanel component, used primarily for adding inline CSS styles. | No | 10.0 | global |
| styleClass | String | The style class used to display the outputPanel component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | No | 10.0 | global |

**SEE ALSO:** apex:outputLink

---

## 10. apex:page

A single Visualforce page. All pages must be wrapped inside a single `<apex:page>` component tag.

```html
<!-- Page: -->
<apex:page renderAs="pdf">
<style> body { font-family: 'Arial Unicode MS'} </style>
<h1>Congratulations</h1>
<p>This is your new PDF</p>
</apex:page>
```

> ⚠️ 원문 검증 주의: `apex:page` 표는 PDF 6페이지(인쇄 p.544–549)에 걸쳐 있고 좌측 마진에서 일부 속성명이 클립되어 text dump grep으로 33개 속성명을 교차확인했다. 셀 단위 이미지 확인 완료. 단, `readOnly`·`deferLastCommandUntilReady`·`title`·`applyBodyTag`·`docType` 등의 long description은 셀 폭 클립으로 끝 문장이 매끄럽지 않다(원문 그대로 보존, [sic] 성격). 타입·API·Required는 정확. description 끝 문장이 정밀히 필요하면 PDF 인쇄 p.544–549 원문 재확인.

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| action | ApexPages.Action | The action method invoked when this page is requested by the server. Use expression language to reference an action method (for example, action="{!doAction}", references the doAction() method of the controller). If an action isn't specified, the page loads as usual. If an action method returns null, the page simply refreshes. This method is called before the page is rendered and allows you to optionally redirect the user to another page. Important: Don't use this action for initialization or DML. | No | 10.0 | global |
| apiVersion | double | The version of the API used to render the page. This attribute can be used to access initialization or DML.[sic] | No | 10.0 | global |
| applyBodyTag | Boolean | A boolean value that specifies whether Visualforce automatically adds a `<body>` tag to the generated HTML. The output tag's false to disable adding the `<body>` tag to the response; for example, when the `<body>` tag is statically set in your markup. If not specified, this value defaults to the value of the applyHtmlTag attribute if it's set, or true, if applyHtmlTag isn't set.[sic] | No | 27.0 | — |
| applyHtmlTag | Boolean | A boolean value that specifies whether Visualforce automatically adds an `<html>` tag to the generated HTML. The output tag's false to disable adding the `<html>` tag to the response; for example, when the `<html>` tag is statically set in your markup. If not specified, this value defaults to true.[sic] | No | 27.0 | — |
| cache | Boolean | Indicates whether the browser should cache this page. If not specified, this value defaults to false. For Salesforce Sites pages, if the cache attribute isn't set to false, this value defaults to 600 seconds. | No | 10.0 | global |
| contentType | String | The MIME content type used to format the rendered page. Possible values for this attribute include text/html, text/csv, image/png, text/css, and audio/basic. For more information, including a complete list of possible values, see the W3C specifications. | No | 10.0 | global |
| controller | String | The name of the custom controller class written in Apex used to control the behavior of this page. This attribute can't be specified if the standardController attribute is also present. | No | 10.0 | global |
| cspHeader | Boolean | Indicates whether this Visualforce page uses your Content Security Policy (CSP) (true) to impose restrictions on content or not (false). If true, browsers only make requests from this Visualforce page to an external server if the server is defined as a CSPTrustedSite with a context of Visualforce or All. Additionally, the CSP `script-src` directive is added and set to self, so script resources must have the same origin as the Visualforce page. You can't modify or configure this directive with CSPTrustedSite. | No | 55.0 | — |
| deferLastCommandUntilReady | Boolean | A boolean value that specifies whether to prevent premature clicking command buttons and links. If true, the last click on a button or link is enqueued and processed when page is ready. This value defaults to false. | No | 26.0 | — |
| docType | String | The HTML document type definition (DTD), or doc type, that describes the structure of the rendered page. Possible values for this attribute include html-4.01-strict, xhtml-1.0-transitional, xhtml-1.1-basic, and html-5.0. If not specified, this value defaults to html-4.01-transitional, which results in a doc type of `<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">`. For more information about HTML doc type declarations, see the W3C specifications. | No | 23.0 | — |
| expires | Integer | The expiration period for the cache attribute in seconds. If the cache attribute is set to true, but this attribute isn't specified, this value defaults to 0. For Salesforce Sites pages, if the cache attribute isn't set to false, this value defaults to 600 seconds. | No | 14.0 | — |
| extensions | String | The name of one or more controller extension classes that add additional logic to this page. Use commas to separate multiple values. | No | 11.0 | global |
| id | String | An identifier for the page that allows it to be referenced by other components in the page. | No | 10.0 | global |
| label | String | The label that is referenced in Salesforce setup tools. | No | 10.0 | global |
| language | String | The language used to display labels that have associated translations in Salesforce. This value overrides the language of the user viewing the page. Possible values for this attribute include any of the language keys for languages supported by Salesforce, for example, en or en-US. | No | 10.0 | global |
| lightningStylesheets | Boolean | A boolean value that controls whether some standard Visualforce components are styled to resemble Lightning Experience when the page is viewed in Lightning Experience. Not all standard Visualforce components support this attribute. If set to true, Lightning Experience users are applied to the page when displayed in Lightning Experience, while Classic style sheets are applied in Salesforce Classic. If not specified or set to false, the Classic style sheets are always used. Note: The lightningStylesheets attribute, when true, overrides the standardStylesheets attribute.[sic] | No | 10.0 | global |
| manifest | String | Adds a manifest attribute to the generated `<html>` tag, which references a cache manifest file for offline use. Setting a manifest attribute requires also setting docType="html-5.0", and applyHtmlTag to not be set to false. | No | 27.0 | — |
| name | String | The unique name that is used to reference the page in the Lightning Platform API. | No | 10.0 | global |
| pageStyle | String | The pageStyle attribute was deprecated in Salesforce API version 16.0 and has no effect on the page. | No | 10.0 | global |
| readOnly | Boolean | A boolean value that enables read-only mode for a Visualforce page. In read-only mode, all of the SOQL queries (including those run from the controller, get methods, and so on) are subject to a relaxed limit on the number of returned rows. The cumulative limit is 1 million rows. In read-only mode, this value is relaxed from 50,000 to 1 million rows, that also increases the number of records that can be retrieved...[sic — 셀 클립으로 끝부분 잘림] | No | 23.0 | — |
| recordSetName | String | The recordSetName attribute was deprecated in Salesforce API version 16.0 and has no effect on the page. Use recordSetVar instead. | No | 14.0 | — |
| recordSetVar | String | This attribute indicates that the page uses a set-oriented standard controller. The value of the attribute indicates the name of the set of records passed to the page. This record set can be used in expressions to return values for display on the page or to perform actions on the set of records. For example, if your page is using the standard accounts controller, and recordSetVar is set to accounts, you can create a simple pageBlockTable of account records with the following code: `<apex:pageBlockTable value="{!accounts}" var="a"><apex:column value="{!a.name}"/></apex:pageBlockTable>` | No | 14.0 | — |
| renderAs | String | The name of any supported content converter. Currently PDF is the only supported content converter. Setting this attribute to pdf renders the page as a PDF. Rendering a Visualforce page as a PDF is intended for pages that are designed and optimized for print. Don't use standard components that aren't easily formatted for print or content from elements such as inputs, buttons, and any component that requires form interaction. Verify the format of your rendered page before deploying it. If the PDF fails to display all the characters, adjust the fonts in your CSS to use a font that supports them. For example, with this CSS rule: `body { font-family: "Arial Unicode MS" }`. Note that the pageBlock and sectionHeader components don't support double-byte fonts when rendered as a PDF. | No | 13.0 | global |
| rendered | Boolean | A boolean value that specifies whether the page is rendered. If not specified, this value defaults to true. | No | 10.0 | global |
| setup | Boolean | A boolean value that specifies whether the page uses the style of a standard Salesforce Setup page. If true, Setup styling is used. If not specified, this value defaults to false. | No | 10.0 | global |
| shouldAlwaysEscapeExpressionLanguage | Boolean | The attribute shouldAlwaysEscapeExpressionLanguage was deprecated in Salesforce API version 57.0 and has no effect on the page. If you already added this attribute to Visualforce code in response to the Escape Expression Language Evaluations release update, remove the shouldAlwaysEscapeExpressionLanguage attribute. To ensure the security of your Visualforce pages and components, complete the following steps. 1. Reintroduce any manual escaping that you removed from your Visualforce pages and components' code for this release update. 2. Delete the attribute shouldAlwaysEscapeExpressionLanguage from your Visualforce pages or components. | No | 57.0 | — |
| showChat | Boolean | A boolean value that specifies whether the Chatter Messenger chat widget is included in the page. If true, the chat widget is displayed. If not specified, this value defaults to false. The chat widget is only displayed for the Visualforce Settings selected from Setup in Customize \| Chat Settings. | No | 10.0 | global |
| showHeader | Boolean | A boolean value that specifies whether the Salesforce tab header is included in the page. If true, the tab header is displayed. If not specified, this value defaults to true. Note: In Lightning Experience and the Salesforce mobile app, the value of this attribute is overridden, and is always true. | No | 10.0 | global |
| showQuickActionVfHeader | Boolean | A boolean value that specifies whether to display the header of the quick action that calls this page. If true, the action header is displayed. If not specified, this value defaults to true. | No | 34.0 | — |
| sidebar | Boolean | A boolean value that specifies whether the Salesforce sidebar is included in the page. If true, the sidebar is displayed. If not specified, this value defaults to true. In Lightning Experience and the Salesforce mobile app, the value of this attribute is overridden, and is always false. | No | 10.0 | global |
| standardController | String | The name of the standard controller used to associate this page with an sObject. This attribute can't be used in conjunction with the controller attribute. | No | 10.0 | global |
| standardStylesheets | Boolean | A boolean value that specifies whether the standard Salesforce stylesheets are added to the generated page header if the showHeader attribute is set to false. If true, the standard stylesheets are added. If not specified, this value defaults to true. | No | 11.0 | global |
| tabStyle | String | The Salesforce object in Visualforce tab that controls the color, styling, and selected tab on the page for this page. To set the standard tab style, specify the name of the object associated with the tab, for example, "Account" or "my_object__c". If the page uses a standard controller, the tabStyle is the default to the Home tab. To use a custom Visualforce tab set, the attribute to the name (not label) of the Visualforce tab in the format "Source_tab".[sic] | No | 10.0 | global |
| title | String | A string value that specifies the contents of the HTML `<title>` element to be used by the page Visualforce. Use it to set the window or tab title for the page. In pages set to API 30.0 or later, the `<apex:page>` title attribute generates an HTML `<title>` element inside the Visualforce-generated `<head>` element. If there is more than one `<head>` element on a page, the title goes in the first one. Visualforce generates an HTML `<head>` element unless other attributes of `<apex:page>` are set in such a way that one isn't generated. For example, when applyHtmlTag or applyBodyTag is false, the value of the title attribute is set by the standardController used. These attributes interact with the title in subtle ways. In pages set to API 29.0 or lower, if the showHeader attribute of `<apex:page>` is set to false the showHeader attribute disables it. To override the standard behavior and set the title yourself, set showHeader to false and provide your own `<title>` element. Note: When you're editing a page in Developer Mode, the page title isn't displayed.[sic] | No | 10.0 | global |
| wizard | Boolean | A boolean value that specifies whether the page uses the style of a standard Salesforce wizard page. If true, wizard styling is used. If not specified, this value defaults to false. | No | 10.0 | global |

**SEE ALSO:** Standard controller / custom controller 관련 항목 (원문 SEE ALSO 다수)

---

## 11. apex:pageBlock

An area of a page that uses styling similar to the appearance of a Salesforce detail page, but without any default content. HTML pass-through attributes 지원("html-" prefix → 생성된 container `<div>` tag에 부착).

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL.
For example, if 001D000000IRt53 is the account ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<!-- Page: -->
<apex:page standardController="Account">
<apex:form>
<apex:pageBlock title="My Content" mode="edit">
<apex:pageBlockButtons>
<apex:commandButton action="{!save}" value="Save"/>
</apex:pageBlockButtons>
<apex:pageBlockSection title="My Content Section" columns="2">
<apex:inputField value="{!account.name}"/>
<apex:inputField value="{!account.site}"/>
<apex:inputField value="{!account.type}"/>
<apex:inputField value="{!account.accountNumber}"/>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | No | 10.0 | global |
| helpTitle | String | The text that displays when a user hovers the mouse over the help link for the pageBlock. If specified, you must also specify a value for helpUrl. | No | 12.0 | global |
| helpUrl | String | The URL of a webpage that provides help for the page. When this value is specified, a help link appears in the upper right corner of the page block. If specified, you must also specify a value for helpTitle. | No | 12.0 | global |
| id | String | An identifier that allows the pageBlock component to be referenced by other components in the page. | No | 10.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | No | 10.0 | global |
| mode | String | The default user mode for the pageBlock component's child elements. This value determines whether lines are drawn separating field values. Possible values are: "detail" — data is displayed to the user with colored lines; "maindetail" — data is displayed to the user with colored lines and a white background, just like the main detail page for records; "edit" — data is displayed to the user without field lines; "inlineEdit" — data is displayed to the user as a double-underscore and the word tab.For example, to use the styling of a Visualforce tab with the name Source and a label Sources, use tabStyle="Source__tab". Displayed lines have nothing to do with required fields; they are merely visual separators, which make it easier to scan a detail page. If not specified, this attribute defaults to detail.[sic — 셀 클립으로 inlineEdit 설명에 tabStyle 잔재 혼입] | No | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the page block. | No | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the page block twice. | No | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | No | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | No | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button on the page block. | No | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer over the page block. | No | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the page block. | No | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the page block. | No | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button on the page block. | No | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| tabStyle | String | The Salesforce object or custom Visualforce tab that controls the color scheme and icon for the page block. For an object, specify the name of the object (e.g. "Account"). If you do not want to use the styling associated with MyCustomObject, use tabStyle="MyCustomObject__c". To use a custom Visualforce tab, set the attribute to the name (not label) of the Visualforce tab in the format "Source_tab". This attribute provides a double-underscore and the word tab.For example, to use the styling of a Visualforce tab with the name Source, use tabStyle="Source__tab".[sic] | No | 10.0 | global |
| title | String | The text displayed as the title of the page block. Note that if a header facet is included in the body of the pageBlock component, its value overrides this attribute. | No | 10.0 | global |

**Facets:**
- **footer** — The components that appear at the bottom of the page block. If specified, the content of this facet overrides any pageBlockButton components in the pageBlock. Note that the order in which a footer facet appears in the body of a pageBlock component does not matter, because any facet with name="footer" will control the appearance of the final row in the table. (API 10.0)
- **header** — The components that appear in the title bar of the page block. If specified, the content of this facet overrides the pageBlock title attribute and any pageBlockButton components in the pageBlock. Note that the order in which a header facet appears in the body of a pageBlock component does not matter, because any facet with name="header" will control the appearance of the section title. (API 10.0)

---

## 12. apex:pageBlockButtons

A set of buttons that are styled like standard Salesforce buttons. This component must be a child component of an `<apex:pageBlock>`. HTML pass-through attributes 지원("html-" prefix → 생성된 `<td>` tag에 부착). Note: It's not necessary for the buttons themselves to be direct children of the `<apex:pageBlockButtons>` component — buttons that are located at any level within an `<apex:pageBlockButtons>` component are styled appropriately.

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL.
For example, if 001D000000IRt53 is the account ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<!-- Page: -->
<apex:page standardController="Account">
<apex:form>
<apex:pageBlock title="My Content" mode="edit">
<apex:pageBlockButtons>
<apex:commandButton action="{!save}" value="Save"/>
</apex:pageBlockButtons>
<apex:pageBlockSection title="My Content Section" columns="2">
<apex:inputField value="{!account.name}"/>
<apex:inputField value="{!account.site}"/>
<apex:inputField value="{!account.type}"/>
<apex:inputField value="{!account.accountNumber}"/>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | No | 11.0 | global |
| id | String | An identifier that allows the pageBlockButtons component to be referenced by other components in the page. | No | 11.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | No | 11.0 | global |
| location | String | The area of the page block where the buttons should be rendered. Possible values include "top", "bottom", or "both". If not specified, this value defaults to "both". Note: If a pageBlock header is defined, the buttons render the page block's manual normally appear at the top of the page block. Likewise, if a pageBlock footer facet is defined, the buttons override the buttons that would normally appear at the bottom of the page block.[sic] | No | 11.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the pageBlockButtons component. | No | 11.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the pageBlockButtons component twice. | No | 11.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | No | 11.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 11.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | No | 11.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | No | 11.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | No | 11.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the pageBlockButtons component. | No | 11.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the pageBlockButtons component. | No | 11.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | No | 11.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 11.0 | global |
| style | String | The style used to display the pageBlockButtons component, used primarily for adding inline CSS styles. | No | 11.0 | global |
| styleClass | String | The style class used to display the pageBlockButtons component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 11.0 | global |

---

## 13. apex:pageBlockSection

A section of data within an `<apex:pageBlock>` component, similar to a section in a standard Salesforce page layout definition. HTML pass-through attributes 지원("html-" prefix → 생성된 `<div>` tag에 부착). (Note: input/output components found in the body of a pageBlockSection are arranged automatically into 2 columns; field labels are auto-populated by default.)

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL.
For example, if 001D000000IRt53 is the account ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<!-- Page: -->
<apex:page standardController="Account">
<apex:form>
<apex:pageBlock title="My Content" mode="edit">
<apex:pageBlockButtons>
<apex:commandButton action="{!save}" value="Save"/>
</apex:pageBlockButtons>
<apex:pageBlockSection title="My Content Section" columns="2">
<apex:inputField value="{!account.name}"/>
<apex:inputField value="{!account.site}"/>
<apex:inputField value="{!account.type}"/>
<apex:inputField value="{!account.accountNumber}"/>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| collapsible | Boolean | A Boolean value that specifies whether the page block section can be expanded and collapsed by a user. If true, a user can expand and collapse the section. If not specified, this value defaults to true. | No | 11.0 | global |
| columns | Integer | The number of columns that can be included in a single row of the page block section. Note that a pageBlockSection always uses one for value, two cells — one for a field's label and one for its value. If you use child pageBlockSectionItem components in the pageBlockSection, each of the child components is displayed in one column, spanning both cells. With more than one column, components are displayed left to right then top to bottom. While you can specify one or more columns to a pageBlockSection, Salesforce stylesheets are optimized for one or two columns. If not specified, this value defaults to 2.[sic] | No | 11.0 | global |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | No | 10.0 | global |
| id | String | An identifier that allows the pageBlockSection component to be referenced by other components in the page. | No | 10.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | No | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the page block section. | No | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the page block section twice. | No | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | No | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | No | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | No | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | No | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the page block section. | No | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the page block section. | No | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | No | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| showHeader | Boolean | A Boolean value that specifies whether the section header is displayed. If not specified, this value defaults to true. | No | 11.0 | global |
| title | String | The text displayed as the title of the page block section. | No | 10.0 | global |

**Facets:**
- **body** — The components that appear in the body of the page block section. If specified, the content of this facet overrides the body of the pageBlockSection tag. Note that the order in which a body facet appears in the body of a page block section component does not matter, because any facet with name="body" will control the appearance of the section body. (API 11.0)
- **header** — The components that appear in the title bar of the page block section. If specified, the content of this facet overrides the title of a page block section component does not matter, because any facet with name="header" will control the appearance of the section title.[sic] (API 10.0)

---

## 14. apex:pageBlockSectionItem

A single piece of data in an `<apex:pageBlockSection>` that takes up one column in one row. An `<apex:pageBlockSectionItem>` component can include up to two child components. If no content is specified, the column is rendered as an empty space. HTML pass-through attributes 지원("html-" prefix → 생성된 container `<td>` tag에 부착). (Note: A `<apex:pageBlockSectionItem>` can't contain a `<apex:pageBlockSection>`. The body of an `<apex:pageBlockSectionItem>` is rendered into a single pageBlockSection column. If two child components are within the body, the first is considered the label and the second is the field; if more than two, they aren't given any special formatting.)

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL. ... -->
<!-- Page: -->
<apex:page standardController="Account">
<apex:form>
<apex:pageBlock title="My Content" mode="edit">
<apex:pageBlockButtons>
<apex:commandButton action="{!save}" value="Save"/>
</apex:pageBlockButtons>
<apex:pageBlockSection title="My Content Section" columns="2">
<apex:pageBlockSectionItem>
<apex:outputLabel value="Account Name" for="account__name"/>
<apex:inputText value="{!account.name}" id="account__name"/>
</apex:pageBlockSectionItem>
<apex:pageBlockSectionItem>
<apex:outputLabel value="Account Site" for="account__site"/>
<apex:inputText value="{!account.site}" id="account__site"/>
</apex:pageBlockSectionItem>
<apex:pageBlockSectionItem>
<apex:outputLabel value="Account Type" for="account__type"/>
<apex:inputText value="{!account.type}" id="account__type"/>
</apex:pageBlockSectionItem>
<apex:pageBlockSectionItem>
<apex:outputLabel value="Account Number" for="account__number"/>
<apex:inputText value="{!account.accountNumber}" id="account__number"/>
</apex:pageBlockSectionItem>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| dataStyle | String | The CSS style used to display the content of the right, "data" cell of the pageBlockSection item. | No | 11.0 | global |
| dataStyleClass | String | The CSS style class used to display the content of the right, "data" cell of the pageBlockSection item. | No | 11.0 | global |
| dataTitle | String | The text displayed when you hover over the right, "data" cell of the pageBlockSection item. | No | 11.0 | global |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | No | 11.0 | global |
| helpText | String | The help text that is displayed next to this field as a hover-based tooltip, similar to the text that is displayed next to standard Salesforce fields if custom help is defined for the field in Setup. Note that help text only displays if the showHeader attribute of the parent page is set to true. | No | 12.0 | global |
| id | String | An identifier that allows the pageBlockSectionItem component to be referenced by other components in the page. | No | 11.0 | global |
| labelStyle | String | The CSS style used to display the content of the left, "label" cell of the pageBlockSection item. | No | 11.0 | global |
| labelStyleClass | String | The CSS style class used to display the content of the left, "label" cell of the pageBlockSection item. | No | 11.0 | global |
| labelTitle | String | The text displayed when you hover over the left, "label" cell of the pageBlockSection item. | No | 11.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | No | 11.0 | global |
| onDataclick | String | The JavaScript invoked if the onDataclick event occurs--that is, if the user clicks the right, "data" cell of the pageBlockSection column. | No | 11.0 | global |
| onDatadblclick | String | The JavaScript invoked if the onDatadblclick event occurs--that is, if the user clicks the right, "data" cell of the pageBlockSection column twice. | No | 11.0 | global |
| onDatakeydown | String | The JavaScript invoked if the onDatakeydown event occurs--that is, if the user presses a keyboard key. | No | 11.0 | global |
| onDatakeypress | String | The JavaScript invoked if the onDatakeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 11.0 | global |
| onDatakeyup | String | The JavaScript invoked if the onDatakeyup event occurs--that is, if the user releases a keyboard key. | No | 11.0 | global |
| onDatamousedown | String | The JavaScript invoked if the onDatamousedown event occurs--that is, if the user clicks a mouse button. | No | 11.0 | global |
| onDatamousemove | String | The JavaScript invoked if the onDatamousemove event occurs--that is, if the user moves the mouse pointer over the right, "data" cell of the pageBlockSection column. | No | 11.0 | global |
| onDatamouseout | String | The JavaScript invoked if the onDatamouseout event occurs--that is, if the user moves the mouse pointer away from the right, "data" cell of the pageBlockSection column. | No | 11.0 | global |
| onDatamouseover | String | The JavaScript invoked if the onDatamouseover event occurs--that is, if the user moves the mouse pointer over the right, "data" cell of the pageBlockSection column. | No | 11.0 | global |
| onDatamouseup | String | The JavaScript invoked if the onDatamouseup event occurs--that is, if the user releases the mouse button. | No | 11.0 | global |
| onLabelclick | String | The JavaScript invoked if the onLabelclick event occurs--that is, if the user clicks the left, "label" cell of the pageBlockSection column. | No | 11.0 | global |
| onLabeldblclick | String | The JavaScript invoked if the onLabeldblclick event occurs--that is, if the user clicks the left, "label" cell of the pageBlockSection column twice. | No | 11.0 | global |
| onLabelkeydown | String | The JavaScript invoked if the onLabelkeydown event occurs--that is, if the user presses a keyboard key. | No | 11.0 | global |
| onLabelkeypress | String | The JavaScript invoked if the onLabelkeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 11.0 | global |
| onLabelkeyup | String | The JavaScript invoked if the onLabelkeyup event occurs--that is, if the user releases a keyboard key. | No | 11.0 | global |
| onLabelmousedown | String | The JavaScript invoked if the onLabelmousedown event occurs--that is, if the user clicks a mouse button. | No | 11.0 | global |
| onLabelmousemove | String | The JavaScript invoked if the onLabelmousemove event occurs--that is, if the user moves the mouse pointer over the left, "label" cell of the pageBlockSection column. | No | 11.0 | global |
| onLabelmouseout | String | The JavaScript invoked if the onLabelmouseout event occurs--that is, if the user moves the mouse pointer away from the left, "label" cell of the pageBlockSection column. | No | 11.0 | global |
| onLabelmouseover | String | The JavaScript invoked if the onLabelmouseover event occurs--that is, if the user moves the mouse pointer over the left, "label" cell of the pageBlockSection column. | No | 11.0 | global |
| onLabelmouseup | String | The JavaScript invoked if the onLabelmouseup event occurs--that is, if the user releases the mouse button. | No | 11.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 11.0 | global |

---

## 15. apex:panelBar

A page area that includes one or more `<apex:panelBarItem>` tags that can expand when a user clicks the associated header. When an `<apex:panelBarItem>` is expanded, the content of the item is displayed while the content of all other items is hidden. When an `<apex:panelBarItem>` is collapsed, the content of the item is hidden. An `<apex:panelBar>` can include up to 1,000 `<apex:panelBarItem>` tags. HTML pass-through attributes 지원("html-" prefix → 생성된 container `<div>` tag에 부착).

```html
<!-- Page: -->
<!-- Click on Item 1, Item 2, or Item 3 to display the content of the panel -->
<apex:page>
<apex:panelBar>
<apex:panelBarItem label="Item 1">data 1</apex:panelBarItem>
<apex:panelBarItem label="Item 2">data 2</apex:panelBarItem>
<apex:panelBarItem label="Item 3">data 3</apex:panelBarItem>
</apex:panelBar>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| contentClass | String | The style class used to display the content of a panelBarItem in the panelBar component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| contentStyle | String | The style used to display the content of a panelBarItem in the panelBar component, used primarily for adding inline CSS styles. | No | 10.0 | global |
| headerClass | String | The style class used to display panelBarItem headers in the panelBar component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| headerClassActive | String | The style class used to display the panelBarItem header which is expanded, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| headerStyle | String | The style used to display panelBarItem headers in the panelBar component, used primarily for adding inline CSS styles. | No | 10.0 | global |
| headerStyleActive | String | The style used to display the header of any panelBarItem when it is expanded, used primarily for adding inline CSS styles. | No | 10.0 | global |
| height | String | The height of the panel bar when expanded, expressed either as a percentage of the available vertical space (for example, height="50%") or as a number of pixels (for example, height="200px"). If not specified this value defaults to 100%. | No | 10.0 | global |
| id | String | An identifier that allows the panelBar component to be referenced by other components in the page. | No | 10.0 | global |
| items | Object | A collection of data processed when the panelBar is rendered. When used, the body of the panelBar component is repeated once for each member in the items collection, similar to a dataTable or repeat component. See also the var attribute. | No | 11.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| style | String | The style used to display all portions of the panelBar component, used primarily for adding inline CSS styles. | No | 10.0 | global |
| styleClass | String | The style class used to display all portions of the panelBar component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| switchType | String | The implementation method for switching to this tab. Possible values include "client", "server", and "ajax". If not specified, this value defaults to "server". | No | 10.0 | global |
| value | Object | The single value or list of values associated with the panelBar component. If specified, the panelBar component's body is repeated once for each value associated with the value attribute, as a member of the items collection. | No | 10.0 | global |
| var | String | The name of the variable that represents one element in the collection of data specified by the items attribute. You can then use this variable to display the element itself in the body of the panelBar component tag. | No | 11.0 | global |
| width | String | The width of the panel bar, expressed either as a percentage of the available horizontal space (for example, width="50%") or as a number of pixels (for example, width="800px"). If not specified, this value defaults to 100%. | No | 10.0 | global |

**SEE ALSO:** apex:panelBarItem · Best Practices for `<apex:panelBar>`

---

## 16. apex:panelBarItem

A section of an `<apex:panelBar>` that can expand or retract when a user clicks the section header. When expanded, the header and the content of the `<apex:panelBarItem>` displays; when retracted, only the header of the `<apex:panelBarItem>` displays. HTML pass-through attributes 지원("html-" prefix → 생성된 container `<div>` tag에 부착).

```html
<!-- Page: -->
<!-- Click on Item 1, Item 2, or Item 3 to display the content of the panel -->
<apex:page>
<apex:panelBar>
<apex:panelBarItem label="Item 1">data 1</apex:panelBarItem>
<apex:panelBarItem label="Item 2">data 2</apex:panelBarItem>
<apex:panelBarItem label="Item 3">data 3</apex:panelBarItem>
</apex:panelBar>
</apex:page>
<!-- Page: panelBarItemEvents -->
<apex:page >
<apex:panelBar>
<apex:panelBarItem label="Item One"
onenter="alert('Entering item one');"
onleave="alert('Leaving item one');">
Item one content
</apex:panelBarItem>
<apex:panelBarItem label="Item Two"
onenter="alert('Entering item two');"
onleave="alert('Leaving item two');">
Item two content
</apex:panelBarItem>
</apex:panelBar>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| contentClass | String | The style class used to display the content of the panelBarItem component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| contentStyle | String | The style used to display the content of the panelBarItem component, used primarily for adding inline CSS styles. | No | 10.0 | global |
| expanded | String | A Boolean value that specifies whether the content of this panelBarItem is displayed. | No | 10.0 | global |
| headerClass | String | The style class used to display the header of the panelBarItem component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| headerClassActive | String | The style class used to display the header of the panelBarItem component when the content of the panelBarItem is displayed, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| headerStyle | String | The style used to display the header of the panelBarItem component, used primarily for adding inline CSS styles. | No | 10.0 | global |
| headerStyleActive | String | The style used to display the header of the panelBarItem component when the content of the panelBarItem is displayed, used primarily for adding inline CSS styles. | No | 10.0 | global |
| id | String | An identifier that allows the panelBarItem to be referenced by other components in the page. | No | 10.0 | global |
| label | String | The text displayed as the header of the panelBarItem component. | No | 10.0 | global |
| name | Object | The name of the panelBarItem. Use the value of this attribute to specify the default expanded panelItem for the panelBar. | No | 11.0 | global |
| onenter | String | The JavaScript invoked when the panelBarItem is not selected and the user clicks on the component to select it. | No | 16.0 | — |
| onleave | String | The JavaScript invoked when the user selects a different panelBarItem. | No | 16.0 | — |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |

**SEE ALSO:** apex:panelBar

---

## 17. apex:panelGrid

Renders an HTML table element in which each component found in the body of the `<apex:panelGrid>` is placed into a corresponding cell in the first row of the table until the number of columns is reached. At that point, the next component wraps to the next row and is placed in the first cell. HTML pass-through attributes 지원("html-" prefix → 생성된 `<table>` tag에 부착). (Note: differs from `<apex:dataTable>` because it doesn't process a set of data with an iteration variable.)

```html
<apex:page>
<apex:panelGrid columns="3" id="theGrid">
<apex:outputText value="First" id="theFirst"/>
<apex:outputText value="Second" id="theSecond"/>
<apex:outputText value="Third" id="theThird"/>
<apex:outputText value="Fourth" id="theFourth"/>
</apex:panelGrid>
</apex:page>
```
renders:
```html
<table id="theGrid">
<tbody>
<tr>
<td><span id="theFirst">First</span></td>
<td><span id="theSecond">Second</span></td>
<td><span id="theThird">Third</span></td>
</tr>
<tr>
<td><span id="theFourth">Fourth</span></td>
</tr>
</tbody>
</table>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| bgcolor | String | The background color of the rendered HTML table. | No | 10.0 | global |
| border | Integer | The width of the frame around the rendered HTML table, in pixels. | No | 10.0 | global |
| captionClass | String | The style class used to display the caption for the rendered HTML table, if a caption facet is specified. This attribute is used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| captionStyle | String | The style used to display the caption for the rendered HTML table, if a caption facet is specified. This attribute is used primarily for adding inline CSS styles. | No | 10.0 | global |
| cellpadding | String | The amount of space between the border of each table cell and its contents. If the value of this attribute is a pixel length, all four margins are this distance from the contents. If the value of the attribute is a percentage length, the top and bottom margins are equally separated from the content based on a percentage of the available vertical space, and the left and right margins are equally separated from the content based on a percentage of the available horizontal space. | No | 10.0 | global |
| cellspacing | String | The amount of space between the border of each table cell and the border of the other cells surrounding it and/or the table's edge. This value must be specified in pixels or percentage. | No | 10.0 | global |
| columnClasses | String | A comma-separated list of one or more CSS classes associated with the table's columns, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. If more than one CSS class is specified in a repeating fashion for all columns. For example, specify columnClasses="classA, classB", the second column with classB, the third column with classA, and so on.[sic] | No | 10.0 | global |
| columns | Integer | The number of columns in this panelGrid. | No | 10.0 | global |
| dir | String | The direction in which the generated HTML component is read. Possible values include "RTL" (right to left) or "LTR" (left to right). | No | 10.0 | global |
| footerClass | String | The style class used to display the footer (bottom row) for the rendered HTML table, if a footer facet is specified. This attribute is used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| frame | String | The borders drawn for this table. Possible values include "none", "above", "below", "hsides", "vsides", "lhs", "rhs", "box", and "border". See also the rules attribute. | No | 10.0 | global |
| headerClass | String | The style class used to display the header for the rendered HTML table, if a header facet is specified. This attribute is used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| id | String | An identifier that allows the panelGrid component to be referenced by other components in the page. | No | 10.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | No | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the panel grid. | No | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the panel grid twice. | No | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | No | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | No | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | No | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | No | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the panel grid. | No | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the panel grid. | No | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | No | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| rowClasses | String | A comma-separated list of one or more CSS classes associated with the table's rows. If more than one CSS class is specified, the classes are applied in a repeating fashion for all rows. For example, if you specify columnClasses="classA, classB", the second row with classB, the third with classA, and so on.[sic] | No | 10.0 | global |
| rules | String | The borders drawn between cells in the table. Possible values include "none", "groups", "rows", "cols", and "all". See also the frames attribute. | No | 10.0 | global |
| style | String | The style used to display the panelGrid component, used primarily for adding inline CSS styles. | No | 10.0 | global |
| styleClass | String | The style class used to display the panelGrid component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| summary | String | A summary of the table's purpose and structure for Section 508 compliance. | No | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | No | 10.0 | global |
| width | String | The width of the entire table, expressed either as a relative percentage to the total amount of available horizontal space (for example, width="80%"), or as the number of pixels (for example, width="800px"). If not specified, this value defaults to 100%. | No | 10.0 | global |

**Facets:**
- **caption** — The components that appear in the caption for the table. Note that the order in which a caption facet appears in the body of a panelGrid component does not matter, because any facet with name="caption" will control the appearance of the table's caption. (API 10.0)
- **footer** — The components that appear in the footer row for the table. Note that the order in which a footer facet appears in the body of a panelGrid component does not matter, because any facet with name="footer" will control the appearance of the final row in the table. (API 10.0)
- **header** — The components that appear in the header row for the table. Note that the order in which a header facet appears in the body of a panelGrid component does not matter, because any facet with name="header" will control the appearance of the first row in the table. (API 10.0)

**SEE ALSO:** apex:panelGroup

---

## 18. apex:panelGroup

A container for multiple child components so that they can be displayed in a single `<apex:panelGrid>` cell. An `<apex:panelGroup>` must be a child component of an `<apex:panelGrid>`.

```html
<apex:page>
<apex:panelGrid columns="1" id="theGrid">
<apex:outputText value="First" id="theFirst"/>
<apex:panelGroup id="theGroup">
<apex:outputText value="Second" id="theSecond"/>
<apex:outputText value="Third" id="theThird"/>
</apex:panelGroup>
<apex:outputText value="Fourth" id="theFourth"/>
</apex:panelGrid>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the panelGroup component to be referenced by other components in the page. | No | 10.0 | global |
| layout | String | The layout style for the panel group. Possible values include "block" (which generates an HTML div tag), "inline" (which generates an HTML span tag), and "none" (which does not generate an HTML tag). If not specified, this value defaults to "inline". | No | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| style | String | The style used to display the panelGroup component, used primarily for adding inline CSS styles. | No | 10.0 | global |
| styleClass | String | The style class used to display the panelGroup component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |

**SEE ALSO:** apex:panelGrid

---

## 19. apex:sectionHeader

A title bar for a page. In a standard Salesforce page, the title bar is a colored header displayed directly under the tab bar. HTML pass-through attributes 지원("html-" prefix → 생성된 container `<div>` tag에 부착).

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL. ... -->
<apex:page standardController="Opportunity" tabStyle="Opportunity" sidebar="false">
<apex:sectionHeader title="One of Your Opportunities" subtitle="Editing {!?}"/>
<apex:detail subject="{!opportunity.ownerId}" relatedList="false" title="false"/>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| description | String | Descriptive text for the page that displays under the colored title bar. The escape attribute determines whether markup in the description is evaluated. | No | 10.0 | global |
| escape | Boolean | A Boolean value that specifies whether sensitive HTML and XML characters are escaped in the description attribute's output. If not specified, the description attribute is escaped properly when allows special HTML elements, scripts, and link elements. Uncommon HTML elements, insecure attributes, and JavaScript are removed. Optionally, you can set the default escape value to false with a setting on the User Interface Setup page. (Caution: Selecting the User Interface setting makes pages that contain `<apex:sectionHeader>` vulnerable to cross-site scripting (XSS) attacks; the removed that you keep this setting unselected. If true, markup characters in the description attribute aren't escaped. If false, markup characters in the description are escaped. We recommend that Independent Software Vendors (ISVs) explicitly set the escape attribute of any `<apex:sectionHeader>` components used.)[sic] | No | 10.0 | global |
| help | String | The URL for the page's help file. When this value is specified, a help link to the right of the colored title bar. If the URL is invalid, the help is not available. If not specified, this value defaults to true.[sic] | No | 10.0 | global |
| id | String | An identifier that allows the sectionHeader component to be referenced by other components in the page. | No | 10.0 | global |
| printUrl | String | The URL for the printable view. | No | 18.0 | — |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| subtitle | String | The text displayed just under the main title in the colored title bar. | No | 10.0 | global |
| title | String | The text displayed at the top of the colored title bar. | No | 10.0 | global |

**SEE ALSO:** apex:detail

---

## 20. apex:tab

A single tab in an `<apex:tabPanel>`. The `<apex:tab>` component must be a child of a `<apex:tabPanel>`. HTML pass-through attributes 지원("html-" prefix → 생성된 container `<td>` tag에 부착).

```html
<!-- Page: -->
<apex:page id="thePage">
<apex:tabPanel switchType="client" selectedTab="name2" id="theTabPanel">
<apex:tab label="One" name="name1" id="tabOne">content for tab one</apex:tab>
<apex:tab label="Two" name="name2" id="tabTwo">content for tab two</apex:tab>
</apex:tabPanel>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| disabled | Boolean | A Boolean value that specifies whether the tab can be selected and viewed and viewed. If not set, the tab cannot be selected. If not specified, this value defaults to false.[sic] | No | 10.0 | global |
| focus | String | The ID of the child component in focus when the tab content is displayed. | No | 10.0 | global |
| id | String | An identifier that allows the tab component to be referenced by other components in the page. | No | 10.0 | global |
| immediate | Boolean | A Boolean value that specifies whether the action associated with this component happens immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false. | No | 11.0 | global |
| label | String | The text to display in the tab header. | No | 10.0 | global |
| labelWidth | String | The length of the tab header, in pixels. If not specified, this value defaults to the width of the tabPanel. | No | 10.0 | global |
| name | Object | The name of the tab. Use the value of this attribute to specify the default selected tab for the tabPanel. | No | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the tab. | No | 10.0 | global |
| oncomplete | String | The JavaScript invoked if the oncomplete event occurs--that is, when an AJAX request associated with this tab has completed. | No | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the tab twice. | No | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | No | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | No | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | No | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer over the tab. | No | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the tab. | No | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the tab. | No | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | No | 10.0 | global |
| ontabenter | String | The JavaScript invoked if the ontabenter event becomes in focus.[sic] | No | 11.0 | global |
| ontableave | String | The JavaScript invoked if the ontableave event occurs--that is, if a component outside the tab becomes in focus. | No | 11.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| rerender | Object | The ID of one or more components that are redrawn when the result of an AJAX update request returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. Note that this attribute can't be used with the switchType attribute when set to "ajax". | No | 10.0 | global |
| status | String | The ID of an associated component that displays the status of an AJAX update request. See the actionStatus component. | No | 10.0 | global |
| style | String | The style used to display all portions of the tab component, used primarily for adding inline CSS styles. | No | 10.0 | global |
| styleClass | String | The style class used to display the tab component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| switchType | String | The implementation method for switching to this tab. Possible values include "client", "server", and "ajax". If not specified, this value defaults to the switchType attribute is set to "ajax".[sic] | No | 10.0 | global |
| timeout | Integer | The amount of time (in milliseconds) before an AJAX update request should time out. Note that this value is only applicable when the value of the switchType attribute is set to "ajax". | No | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | No | 10.0 | global |

**SEE ALSO:** apex:tabPanel

---

## 21. apex:tabPanel

A page area that displays as a set of tabs. When a user clicks a tab header, the tab's associated content displays, hiding the content of other tabs. HTML pass-through attributes 지원("html-" prefix → 생성된 `<table>` tag에 부착).

**Simple Example:**
```html
<!-- Page: -->
<apex:page id="thePage">
<apex:tabPanel switchType="client" selectedTab="name2" id="theTabPanel">
<apex:tab label="One" name="name1" id="tabOne">content for tab one</apex:tab>
<apex:tab label="Two" name="name2" id="tabTwo">content for tab two</apex:tab>
</apex:tabPanel>
</apex:page>
```

**Advanced Example:**
```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL. ... -->
<apex:page standardController="Account" showHeader="true">
<style>
.activeTab {background-color: #236FBD; color:white; background-image:none}
.inactiveTab { background-color: lightgrey; color:black; background-image:none}
</style>
<apex:tabPanel switchType="client" selectedTab="name2" id="AccountTabPanel"
tabClass="activeTab" inactiveTabClass="inactiveTab">
<apex:tab label="One" name="name1" id="tabOne">content for tab one</apex:tab>
<apex:tab label="Two" name="name2" id="tabTwo">content for tab two</apex:tab>
</apex:tabPanel>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| activeTabClass | String | The style class used to display a tab header in the tabPanel when it is selected, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| contentClass | String | The style class used to display the content of a tab in the tabPanel component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| contentStyle | String | The style used to display the content of a tab in the tabPanel component, used primarily for adding inline CSS styles. | No | 10.0 | global |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | No | 10.0 | global |
| disabledTabClass | String | The style class used to display a tab header in the tabPanel when it is disabled, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| headerAlignment | String | The side of the tabPanel on which tab headers display. Possible values include "left" or "right". If not specified, this value defaults to "left". | No | 10.0 | global |
| headerClass | String | The style class used to display all tab headers, regardless of whether or not they are selected, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 11.0 | global |
| headerSpacing | String | The distance between two adjacent tab headers, in pixels. If not specified, this value defaults to 5. | No | 10.0 | global |
| height | String | The height of the tab, expressed either as a percentage of the available vertical space (for example, height="50%") or as a number of pixels (for example, height="200px"). If not specified, this value defaults to 100%. | No | 10.0 | global |
| id | String | An identifier that allows the tabPanel component to be referenced by other components in the page. | No | 10.0 | global |
| immediate | Boolean | A Boolean value that specifies whether the action associated with this component happens immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false. | No | 11.0 | global |
| inactiveTabClass | String | The style class used to display a tab header in the tabPanel when it is not selected, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | No | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the tabPanel. | No | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the tabPanel twice. | No | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | No | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | No | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | No | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer over the tabPanel. | No | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the tabPanel. | No | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the tabPanel. | No | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | No | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| rerender | Object | The ID of one or more components that are redrawn when the result of an AJAX update request returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs that identifies the components to be refreshed. | No | 10.0 | global |
| selectedTab | Object | The name of the default selected tab when the page loads. This value must match the name attribute on a child tab component. If the value attribute is defined, the selectedTab attribute is ignored. | No | 10.0 | global |
| style | String | The style used to display the tabPanel component, used primarily for adding inline CSS styles. | No | 10.0 | global |
| styleClass | String | The style class used to display the tabPanel component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| switchType | String | The implementation method for switching between tabs. Possible values include "client", "server", and "ajax". If not specified, this value defaults to "server". | No | 10.0 | global |
| tabClass | String | The style class used to display the tabPanel component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | No | 10.0 | global |
| value | Object | The current value of the active tab. You can specify this with an expression so that the active tab is dynamically determined; the value must equal one of the name attributes of the child tab components. | No | 10.0 | global |
| width | String | The width of the entire table, expressed either as a relative percentage to the total amount of available horizontal space (for example, width="80%"), or as the number of pixels (for example, width="800px"). If not specified, this value defaults to 100%. | No | 10.0 | global |

---

## 22. apex:toolbar

A stylized, horizontal toolbar that can contain any number of child components. By default, all child components are aligned to the left side of the toolbar. Use an `<apex:toolbarGroup>` component to align one or more child components to the right. HTML pass-through attributes 지원("html-" prefix → 생성된 container `<div>` tag에 부착).

```html
<!-- Page: sampleToolbar-->
<apex:page id="thePage">
<!-- A simple example of a toolbar -->
<apex:toolbar id="theToolbar">
<apex:outputText value="Sample Toolbar"/>
<apex:toolbarGroup itemSeparator="line" id="toolbarGroupLinks">
<apex:outputLink value="https://salesforce.com">
salesforce
</apex:outputLink>
<apex:outputLink value="https://developer.salesforce.com">
apex developer network
</apex:outputLink>
</apex:toolbarGroup>
<apex:toolbarGroup itemSeparator="line" location="right" id="toobarGroupForm">
<apex:form id="theForm">
<apex:inputText id="theInputText">Enter Text</apex:inputText>
<apex:commandLink value="search" id="theCommandLink"/>
</apex:form>
</apex:toolbarGroup>
</apex:toolbar>
</apex:page>
<!-- Page: toolBarEvents-->
<apex:page id="anotherPage">
<!-- A simple toolbar that includes toolbar events. -->
<apex:pageMessages/>
<apex:form>
<apex:toolbar
onclick="alert('You clicked the mouse button on a component in the toolbar.')"
onkeydown="alert('You pressed a keyboard key in a component in the toolbar.')"
onitemclick="alert('You clicked the mouse button on a component that is ' +
'not in a toolbarGroup.')"
onitemkeydown="alert('You pressed a keyboard key in a component that is ' +
'not in a toolbarGroup.')">
<apex:inputText/>
Click outside of a toolbargroup
<apex:toolbarGroup><apex:inputText/>Click in a toolbarGroup</apex:toolbarGroup>
</apex:toolbar>
</apex:form>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| contentClass | String | The style class used to display each child component in the toolbar, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| contentStyle | String | The style used to display each child component in the toolbar, used primarily for adding inline CSS styles. | No | 10.0 | global |
| height | String | The height of the toolbar, expressed as a relative percentage of the total height of the screen (for example, height="5%") or as an absolute number of pixels (for example, height="10px"). If not specified, this value defaults to the height of the tallest component. | No | 10.0 | global |
| id | String | An identifier that allows the toolbar component to be referenced by other components in the page. | No | 10.0 | global |
| itemSeparator | String | The symbol used to separate toolbar components. Possible values include "none", "line", "square", "disc", and "grid". If not specified, this value defaults to "none". | No | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the toolbar. | No | 16.0 | — |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the toolbar twice. | No | 16.0 | — |
| onitemclick | String | The JavaScript invoked if the user clicks a component that is not in a toolbarGroup component. | No | 16.0 | — |
| onitemdblclick | String | The JavaScript invoked if the user clicks a mouse button on a component in the toolbar that is not in a toolbarGroup component. | No | 16.0 | — |
| onitemkeydown | String | The JavaScript invoked if the user presses a keyboard key on a component in the toolbar that is not in a toolbarGroup component. | No | 16.0 | — |
| onitemkeypress | String | The JavaScript invoked if the user presses or holds down a keyboard key on an item in the toolbar that is not in a toolbarGroup component. | No | 16.0 | — |
| onitemkeyup | String | The JavaScript invoked if the user releases a keyboard key on an item in the toolbar that is not in a toolbarGroup component. | No | 16.0 | — |
| onitemmousedown | String | The JavaScript invoked if the user clicks a mouse button on a component in the toolbar that is not in a toolbarGroup component. | No | 16.0 | — |
| onitemmousemove | String | The JavaScript invoked if the user moves the mouse pointer over an item in the toolbar that is not in a toolbarGroup component. | No | 16.0 | — |
| onitemmouseout | String | The JavaScript invoked if the user moves the mouse pointer away from an item in the toolbar that is not in a toolbarGroup component. | No | 16.0 | — |
| onitemmouseover | String | The JavaScript invoked if the user moves the mouse pointer over an item in the toolbar that is not in a toolbarGroup component. | No | 16.0 | — |
| onitemmouseup | String | The JavaScript invoked if the user releases a keyboard key on an item in the toolbar that is not in a toolbarGroup component.[sic] | No | 16.0 | — |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | No | 16.0 | — |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 16.0 | — |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | No | 16.0 | — |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | No | 16.0 | — |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer over the toolbar. | No | 16.0 | — |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the toolbar. | No | 16.0 | — |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the toolbar. | No | 16.0 | — |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | No | 16.0 | — |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 10.0 | global |
| separatorClass | String | The style class used to display the toolbar component separator, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| style | String | The style used to display the toolbar, used primarily for adding inline CSS styles. | No | 10.0 | global |
| styleClass | String | The style class used to display the toolbar component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 10.0 | global |
| width | String | The width of the toolbar, expressed either as a percentage of the available horizontal space (for example, width="50%") or as a number of pixels (for example, width="800px"). If not specified, this value defaults to 100%. | No | 10.0 | global |

**SEE ALSO:** apex:toolbarGroup

---

## 23. apex:toolbarGroup

A group of components within a toolbar that can be aligned to the left or right of the toolbar. The `<apex:toolbarGroup>` component must be a child component of an `<apex:toolbar>`.

```html
<!-- Page: -->
<apex:page id="thePage">
<apex:toolbar id="theToolbar">
<apex:outputText value="Sample Toolbar"/>
<apex:toolbarGroup itemSeparator="line" id="toolbarGroupLinks">
<apex:outputLink value="http://www.salesforce.com">salesforce</apex:outputLink>
</apex:toolbarGroup>
<apex:toolbarGroup itemSeparator="line" location="right" id="toobarGroupForm">
<apex:form id="theForm">
<apex:inputText id="theInputText">Enter Text</apex:inputText>
<apex:commandLink value="search" id="theCommandLink"/>
</apex:form>
</apex:toolbarGroup>
</apex:toolbar>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the toolbarGroup component to be referenced by other components in the page. | No | 10.0 | global |
| itemSeparator | String | The symbol used to separate toolbar components in the toolbarGroup. Possible values include "none", "line", "square", "disc", and "grid". If not specified, this value defaults to "none". | No | 10.0 | global |
| location | String | The position of the toolbarGroup in the toolbar. Possible values include "left" or "right". If not specified, this value defaults to "left". | No | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the toolbarGroup component. | No | 11.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the toolbarGroup component twice. | No | 11.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | No | 11.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | No | 11.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | No | 11.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | No | 11.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer over the toolbarGroup component. | No | 11.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the toolbarGroup component. | No | 11.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the toolbarGroup component. | No | 11.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | No | 11.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | No | 11.0 | global |
| separatorClass | String | The style class used to display toolbar component separator, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 11.0 | global |
| style | String | The style used to display the toolbarGroup component, used primarily for adding inline CSS styles. | No | 11.0 | global |
| styleClass | String | The style class used to display the toolbarGroup component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | No | 11.0 | global |

**SEE ALSO:** apex:toolbar

---

## 관련 노트

- [[apex 컴포넌트 — 입력·폼]] (Part B2 — 같은 Ch24 입력·폼 컴포넌트 레퍼런스)
- [[apex 컴포넌트 — 출력·데이터·반복·차트]] (Part B3 — 같은 Ch24 출력·데이터 반복·차트 컴포넌트 레퍼런스)
- [[apex 컴포넌트 — AJAX·액션·Remote Objects·기타]] (Part B4 — 같은 Ch24 AJAX·액션 컴포넌트 레퍼런스)
- [[Visualforce 개요 — 도구·퀵스타트]] (Part A — Visualforce 입문·도구·페이지 구조 개요)
- [[버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트]] (커스텀 컴포넌트 작성 — `apex:component`/`apex:attribute` 활용)
- [[동적 Visualforce — 바인딩·동적 컴포넌트]] (동적 컴포넌트로 facet 지정 등)
- [[페이지 출력 제어 — HTML·PDF·SLDS]] (`apex:page` renderAs="pdf"·docType·HTML 출력 제어)
