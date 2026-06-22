---
tags: [visualforce, vf, component-reference, input, form, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26)
created: 2026-06-21
aliases: [apex:inputField, apex:selectList, apex:commandButton, apex:outputText, Visualforce 입력 컴포넌트, apex:pageMessages]
---

# Visualforce 표준 컴포넌트 레퍼런스 — 입력·폼 (27개)

> [!note] Visualforce는 레거시 기술이다. 신규 개발은 Lightning Web Components(LWC) 권장

> Visualforce Developer Guide v67.0 Summer '26 Ch.24 "Standard Component Reference" 중 입력·폼 관련 27개 `apex:` 태그의 설명·예제·속성표(전수).

---

## 개요

이 노트는 Visualforce의 입력·폼 계열 표준 컴포넌트 27개를 다룬다. 각 컴포넌트마다 원문 설명·코드 예제(verbatim)·속성표(전수, 6열)를 수록한다.

속성표는 6열이다 — **Attribute Name · Type · Description · Required? · API Version · Access**.

- **Required?** 열: 공란이면 No(필수 아님). `Yes`만 표시한다.
- **Access** 열: `global`이면 해당 속성을 컴포넌트 namespace 밖에서 사용할 수 있다. 공란이면 Access 지정 없음(namespace 밖 사용 비허용). 표에서는 공란을 `—`로 표기한다.

> 범위 안내: 이 노트는 Ch.24 중 입력·폼 27개 태그만 다룬다. `apex:dataTable`·`apex:pageBlock` 계열·`apex:chart` 계열·`apex:tab` 계열 등 나머지 표준 컴포넌트는 범위 밖이다.

대분류:

| 분류 | 컴포넌트 |
|---|---|
| 일반 입력 | `apex:input` `apex:inputCheckbox` `apex:inputField` `apex:inputFile` `apex:inputHidden` `apex:inputSecret` `apex:inputText` `apex:inputTextarea` |
| 선택 입력 | `apex:selectCheckboxes` `apex:selectList` `apex:selectOption` `apex:selectOptions` `apex:selectRadio` |
| 액션 | `apex:commandButton` `apex:commandLink` |
| 인라인 편집·파라미터·변수·속성 | `apex:inlineEditSupport` `apex:param` `apex:attribute` `apex:variable` |
| 출력 | `apex:outputField` `apex:outputLabel` `apex:outputLink` `apex:outputText` |
| 메시지 | `apex:message` `apex:messages` `apex:pageMessage` `apex:pageMessages` |

---

## apex:input

An HTML5-friendly general purpose input component that adapts to the data expected by a form field. It uses the HTML type attribute to allow client browsers to display type-appropriate user input widgets, such as a date picker or range slider, or to perform client-side formatting or validation, such as with a numeric range or a telephone number. Use this component to get user input for a controller property or method that does not correspond to a field on a Salesforce object. This component doesn't use Salesforce styling. Also, since it doesn't correspond to a Salesforce field, or any other data on an object, custom code is required to use the value the user enters. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<input>` tag.

```html
<apex:input value="{!inputValue}" id="theTextInput"/>
```

The example above renders the following HTML:

```html
<input id="theTextInput" type="text" name="theTextInput" />
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accesskey | String | The keyboard access key that puts the field in focus. When the text box is in focus, a user can select or deselect the field value. | | 29.0 | global |
| alt | String | An alternate text description of the field. | | 29.0 | global |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 29.0 | global |
| disabled | Boolean | A Boolean value that specifies whether this text box should be displayed in a disabled state. If set to true, the text box appears disabled. If not specified, this value defaults to false. | | 29.0 | global |
| id | String | An identifier that allows the field component to be referenced by other components in the page. | | 29.0 | global |
| label | String | A text value that allows to display a label next to the control and reference the control in the error message | | 29.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 29.0 | global |
| list | Object | A list of auto-complete values to be added to an HTML `<datalist>` block associated with the input field. The list attribute is specified as either a comma-delimited static string or a Visualforce expression. An expression can resolve to either a comma-delimited string, or a list of objects. List elements can be any data type, as long as that type can be coerced to a string, either as an Apex language feature or via a toString() method. | | 29.0 | global |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the field. | | 29.0 | global |
| onchange | String | The JavaScript invoked if the onchange event occurs--that is, if the user changes the content of the field. | | 29.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the field. | | 29.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the field twice. | | 29.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the field. | | 29.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 29.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 29.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 29.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 29.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 29.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the field. | | 29.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the field. | | 29.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 29.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 29.0 | global |
| required | Boolean | A Boolean value that specifies whether this field is a required field. If set to true, the user must specify a value for this field. If not selected, this value defaults to false. | | 29.0 | global |
| size | Integer | The width of the input field, as expressed by the number of characters that can display at a time. | | 29.0 | global |
| style | String | The style used to display the input component, used primarily for adding inline CSS styles. | | 29.0 | global |
| styleClass | String | The style class used to display the input component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 29.0 | global |
| tabindex | String | The order in which this field is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 29.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 29.0 | global |
| type | String | The HTML5 type attribute to add to the generated `<input>` element. Valid type values are: auto, date, datetime, datetime-local, month, week, time, email, number, range, search, tel, text, url | | 29.0 | global |
| value | Object | An expression that references the controller class variable that is associated with this field. For example, if the name of the associated variable in the controller class is myTextField, use value="{!myTextField}" to reference the variable. | | 29.0 | global |

---

## apex:inputCheckbox

An HTML input element of type checkbox. Use this component to get user input for a controller method that does not correspond to a field on a Salesforce object. Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<input>` tag.

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid opportunity record in the URL.
For example, if 001D000000IRt53 is the opportunity ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<apex:page standardController="Opportunity" recordSetVar="opportunities"
tabstyle="opportunity">
<apex:form id="changePrivacyForm">
<apex:pageBlock >
<apex:pageMessages />
<apex:pageBlockButtons>
<apex:commandButton value="Save" action="{!save}"/>
</apex:pageBlockButtons>
<apex:pageBlockTable value="{!opportunities}" var="o">
<apex:column value="{!o.name}"/>
<apex:column value="{!o.account.name}"/>
<apex:column headerValue="Private?">
<apex:inputCheckbox value="{!o.isprivate}"/>
</apex:column>
</apex:pageBlockTable>
</apex:pageBlock>
</apex:form>
</apex:page>
```

The example renders the following HTML:

```html
<!-- allows you to change the privacy option of your opportunity -->
<form id="j_id0:changePrivacyForm" name="j_id0:changeStatusForm" method="post"
action="/apex/sandbox" enctype="application/x-www-form-urlencoded">
<!-- opening div tags -->
<table border="0" cellpadding="0" cellspacing="0">
<tr>
<td class="pbTitle"> </td>
<td id="j_id0:changePrivacyForm:j_id1:j_id29" class="pbButton">
<input type="submit"
name="j_id0:changePrivacyForm:j_id1:j_id29:j_id30"
value="Save" class="btn"/>
</td>
</tr>
</table>
<div class="pbBody">
<table class="list" border="0" cellpadding="0" cellspacing="0">
<colgroup span="3"/>
<thead>
<tr class="headerRow ">
<th class="headerRow " scope="col">Opportunity Name</th>
<th class="headerRow " scope="col">Account Name</th>
<th class="headerRow " scope="col">Privacy?</th>
</tr>
</thead>
<tbody>
<tr class="dataRow even first ">
<td class="dataCell"><span>Burlington Textiles Weaving Plant
Generator</span></td>
<td class="dataCell"><span>Burlington Textiles Corp of
America</span></td>
<td class="dataCell"><input type="checkbox"
name="j_id0:changePrivacyForm:j_id1:j_id31:0:j_id35" checked="checked" /></td>
</tr>
<tr class="dataRow odd last ">
<td class="dataCell"><span>Edge Emergency Generator</span></td>
<td class="dataCell"><span>Edge Communications</span></td>
<td class="dataCell"><input type="checkbox"
name="j_id0:changePrivacyForm:j_id1:j_id31:0:j_id35" checked="checked" /></td>
</tr>
</tbody>
</table>
</div>
<!-- closing div tags -->
</form>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accesskey | String | The keyboard access key that puts the checkbox in focus. When the checkbox is in focus, a user can select or deselect the checkbox value. | | 10.0 | global |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| disabled | Boolean | A Boolean value that specifies whether this checkbox should be displayed in a disabled state. If set to true, the checkbox appears disabled. If not specified, this value defaults to false. | | 10.0 | global |
| id | String | An identifier that allows the checkbox component to be referenced by other components in the page. | | 10.0 | global |
| immediate | Boolean | A Boolean value that specifies whether the action associated with this component should happen immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false. See Use the immediate Attribute Carefully. | | 11.0 | global |
| label | String | A text value that allows to display a label next to the control and reference the control in the error message | | 23.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the checkbox. | | 10.0 | global |
| onchange | String | The JavaScript invoked if the onchange event occurs--that is, if the user changes the content of the checkbox field. | | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the checkbox. | | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the checkbox twice. | | 10.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the checkbox. | | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the checkbox. | | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the checkbox. | | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 10.0 | global |
| onselect | String | The JavaScript invoked if the onselect event occurs--that is, if the user selects the checkbox. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| required | Boolean | A Boolean value that specifies whether this checkbox is a required field. If set to true, the user must specify a value for this checkbox. If not selected, this value defaults to false. | | 10.0 | global |
| selected | Boolean | A Boolean value that specifies whether this checkbox should be rendered in its "checked" state. If not selected, this value defaults to false. | | 10.0 | global |
| style | String | The style used to display the inputCheckbox component, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the inputCheckbox component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| tabindex | String | The order in which this checkbox is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| value | Object | A merge field that references the controller class variable that is associated with this checkbox. For example, if the name of the associated variable in the controller class is myCheckbox, use value="{!myCheckbox}" to reference the variable. | | 10.0 | global |

**SEE ALSO:** `apex:input`

---

## apex:inputField

An HTML input element for a value that corresponds to a field on a Salesforce object. The `<apex:inputField>` component respects the attributes of the associated field, including whether the field is required or unique, and the user interface widget to display to get input from the user. For example, if the specified `<apex:inputField>` component is a date field, a calendar input widget is displayed. When used in an `<apex:pageBlockSection>`, `<apex:inputField>` tags automatically display with their corresponding output label.

Consider the following when using DOM events with this tag:

- For lookup fields, mouse events fire on both the text box and graphic icon.
- For multi-select picklists, all events fire, but the DOM ID is suffixed with `_unselected` for the left box, `_selected` for the right box, and `_right_arrow` and `_left_arrow` for the graphic icons.
- For rich text areas, no events fire.

**Note:**

- Read-only fields, and fields for certain Salesforce objects with complex automatic behavior, such as Event.StartDateTime and Event.EndDateTime, don't render as editable when using `<apex:inputField>`. Use a different input component such as `<apex:inputText>` instead.
- An `<apex:inputField>` component for a rich text area field can't be used for image uploads in Site.com sites, Salesforce Sites, or Visualforce sites due to security constraints. If you want to enable users to upload image files in either of those contexts, use an `<apex:inputFile>` component.
- If custom help is defined for the field in Setup, the field must be a child of an `<apex:pageBlock>` or `<apex:pageBlockSection>`, and the Salesforce page header must be displayed for the custom help to appear on your Visualforce page. To override the display of custom help, use the `<apex:inputField>` in the body of an `<apex:pageBlockSectionItem>`.

Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<input>` tag.

```html
<!-- For this example to render fully, associate the page
with a valid account record in the URL.
For example: https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53 -->
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
| id | String | An identifier that allows the inputField component to be referenced by other components in the page. | | 10.0 | global |
| ignoreEditPermissionForRendering | Boolean | If set to true, users can edit the field even when the underlying permission on the object doesn't allow edits. This override affects all users but is intended for guest users. This attribute works only with a custom controller in without sharing mode. Users must have entity read permissions and field-level security read access for the object. This attribute bypasses entity edit permissions and field-level security edit checks, so any form field that uses `<apex:inputField>` with this attribute is open for edit. To validate fields or block edit access when using this attribute, use additional checks in the page's custom Apex controller. **Warning: Salesforce is not responsible for any exposure of your data to unauthenticated users based on this change from default settings.** | | 49.0 | global |
| label | String | A text value that allows you to override the default label that is displayed for the field. You can set label to an empty string to hide the label on forms. Setting it to null is an error. | | 23.0 | — |
| list | Object | A list of auto-complete values to be added to an HTML `<datalist>` block associated with the input field. The list attribute is specified as either a comma-delimited static string or a Visualforce expression. An expression can resolve to either a comma-delimited string, or a list of objects. List elements can be any data type, as long as that type can be coerced to a string, either as an Apex language feature or via a toString() method. | | 29.0 | — |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off the field. | | 12.0 | global |
| onchange | String | The JavaScript invoked if the onchange event occurs--that is, if the user changes the content of the field. | | 12.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the field. | | 12.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the field twice. | | 12.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the field. | | 12.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 12.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 12.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 12.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 12.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 12.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the field. | | 12.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the field. | | 12.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 12.0 | global |
| onselect | String | The JavaScript invoked if the onselect event occurs--that is, if the user selects a checkbox associated with this field. | | 12.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| required | Boolean | A Boolean value that specifies whether this inputField is a required field. If set to true, the user must specify a value for this field. If not selected, this value defaults to false. If this input field displays a custom object name, its value can be set to nil and won't be required unless you set this attribute to true. The same doesn't apply to standard object names, which are always required regardless of this attribute. | | 10.0 | global |
| showDatePicker | Boolean | Whether to use the Visualforce date picker for this field, or suppress it in favor of a browser-based date picker. This attribute only affects date and datetime fields, and activating a browser-based type-appropriate selection widget requires the type attribute be set to one of these date- or time-compatible types: date, datetime, datetime-local, month, week, time | | 29.0 | — |
| style | String | The CSS style used to display the inputField component. This attribute may not work for all values. If your text requires a class name, use a wrapping span tag. | | 12.0 | global |
| styleClass | String | The CSS style class used to display the inputField component. This attribute may not work for all values. If your text requires a class name, use a wrapping span tag. | | 12.0 | global |
| taborderhint | Integer | A hint to indicate the relative order in which this field is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer from 1 through 3276, with component 1 being the first component that is selected when a user presses the Tab key. | | 23.0 | — |
| type | String | The HTML5 type attribute to add to the generated `<input>` element. Valid type values are: auto, date, datetime, datetime-local, month, week, time, email, number, range, search, tel, text, url | | 29.0 | — |
| value | Object | An expression that references the Salesforce field to associate with this inputField. For example, if you want to display an input field for an account's name field, use value="{!account.name}". You can't associate an inputField with a formula field of type currency if your organization is using dated exchange rates. | | 10.0 | global |

**SEE ALSO:** Community Cloud Practice Blog: Guest User Record Access Development Best Practices · `apex:input` · Displaying Record Types · Using Input Components in a Page

---

## apex:inputFile

A component that creates an input field to upload a file.

**Note:** The maximum file size that can be uploaded via Visualforce is 10 MB.

```html
<!-- Upload a file and put it in your personal documents folder-->
<!-- Page: -->
<apex:page standardController="Document" extensions="documentExt">
<apex:messages />
<apex:form id="theForm">
<apex:pageBlock>
<apex:pageBlockSection>
<apex:inputFile value="{!document.body}" filename="{!document.name}"/>
<apex:commandButton value="Save" action="{!save}"/>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
/*** Controller ***/
public class documentExt {
public documentExt(ApexPages.StandardController controller) {
Document d = (Document) controller.getRecord();
d.folderid = UserInfo.getUserId(); //this puts it in My Personal Documents
}
}
```

이 컴포넌트는 거의 모든 속성의 Access가 공란이다.

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accept | String | Comma-delimited set of content types. This list can be used by the browser to limit the set of file options that is made available for selection. If not specified, no content type list will be sent and all file types will be accessible. | | 14.0 | — |
| accessKey | String | The keyboard access key that puts the component in focus. | | 14.0 | — |
| alt | String | An alternate text description of the component. | | 14.0 | — |
| contentType | String | String property that stores the uploaded file's content type. | | 14.0 | — |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 14.0 | — |
| disabled | Boolean | A Boolean value that specifies whether this component should be displayed in a disabled state. If set to true, the component appears disabled. If not specified, this value defaults to false. | | 14.0 | — |
| fileName | String | String property that stores the uploaded file's name. | | 14.0 | — |
| fileSize | Integer | Integer property that stores the uploaded file's size. | | 14.0 | — |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information, see the W3C specification on this attribute: http://www.w3.org/TR/REC-html40/struct/dirlang.html | | 14.0 | — |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the component. | | 14.0 | — |
| onchange | String | The JavaScript invoked if the onchange event occurs--that is, if the user changes the content of the component field. | | 14.0 | — |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the component. | | 14.0 | — |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the component twice. | | 14.0 | — |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the component. | | 14.0 | — |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 14.0 | — |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 14.0 | — |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 14.0 | — |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 14.0 | — |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 14.0 | — |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the component. | | 14.0 | — |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the component. | | 14.0 | — |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| required | Boolean | A Boolean value that specifies whether this component is a required field. If set to true, the user must specify a value for this component. If not selected, this value defaults to false. | | 14.0 | — |
| size | Integer | Size of the file selection box to be displayed. | | 14.0 | — |
| style | String | The style used to display the component, used primarily for adding inline CSS styles. | | 14.0 | — |
| styleclass | String | The style class used to display the component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 14.0 | — |
| tabindex | Integer | The order in which this component is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 14.0 | — |
| title | String | The text displayed next to the component when the mouse hovers over it. | | 14.0 | — |
| value | Blob | A merge field that references the controller class variable that is associated with this component. For example, if the name of the associated variable in the controller class is myInputFile, use value="{!myInputFile}" to reference the variable. | Yes | 14.0 | — |

**SEE ALSO:** `apex:input`

---

## apex:inputHidden

An HTML input element of type hidden, that is, an input element that is invisible to the user. Use this component to pass variables from page to page. Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<input>` tag.

```html
<apex:inputHidden value="{!inputValue}" id="theHiddenInput"/>
```

Renders:

```html
<input id="theHiddenInput" type="hidden" name="theHiddenInput" />
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the inputHidden component to be referenced by other components in the page. | | 10.0 | global |
| immediate | Boolean | A Boolean value that specifies whether the action associated with this component should happen immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false. See Use the immediate Attribute Carefully. | | 11.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| required | Boolean | A Boolean value that specifies whether this inputHidden field is a required field. If set to true, the a value must be specified for this field. If not selected, this value defaults to false. [sic — "the a value"] | | 10.0 | global |
| value | Object | A merge field that references the controller class variable that is associated with this hidden input field. For example, if the name of the associated variable in the controller class is myHiddenVariable, use value="{!myHiddenVariable}" to reference the variable. | | 10.0 | global |

**SEE ALSO:** `apex:input` · Using Input Components in a Page

---

## apex:inputSecret

An HTML input element of type password. Use this component to get user input for a controller method that does not correspond to a field on a Salesforce object, for a value that is masked as the user types. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<input>` tag.

```html
<apex:inputSecret value="{!inputValue}" id="theSecretInput"/>
```

Renders:

```html
<input id="theSecretInput" type="password" name="theSecretInput" value="" />
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accesskey | String | The keyboard access key that puts the field in focus. When the field is in focus, a user can enter a value. | | 10.0 | global |
| alt | String | An alternate text description of the field. | | 10.0 | global |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| disabled | Boolean | A Boolean value that specifies whether this field should be displayed in a disabled state. If set to true, the field appears disabled. If not specified, this value defaults to false. | | 10.0 | global |
| id | String | An identifier that allows the checkbox component to be referenced by other components in the page. [sic — "checkbox"] | | 10.0 | global |
| immediate | Boolean | A Boolean value that specifies whether the action associated with this component should happen immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false. See Use the immediate Attribute Carefully. | | 11.0 | global |
| label | String | A text value that allows to display a label next to the control and reference the control in the error message | | 23.0 | — |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| maxlength | Integer | The maximum number of characters that a user can enter for this field, expressed as an integer. | | 10.0 | global |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the field. | | 10.0 | global |
| onchange | String | The JavaScript invoked if the onchange event occurs--that is, if the user changes the content of the field. | | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the field. | | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the field twice. | | 10.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the field. | | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the field. | | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the field. | | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 10.0 | global |
| onselect | String | The JavaScript invoked if the onselect event occurs--that is, if the user selects text in the field. | | 10.0 | global |
| readonly | Boolean | A Boolean value that specifies whether this field is rendered as read-only. If set to true, the field value cannot be changed. If not selected, this value defaults to false. | | 10.0 | global |
| redisplay | Boolean | A Boolean value that specifies whether a previously entered password is rendered in this form. If set to true, the previously entered value is displayed with its mask. If not specified, this value defaults to false. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| required | Boolean | A Boolean value that specifies whether this field is a required field. If set to true, the user must specify a value for this field. If not selected, this value defaults to false. | | 10.0 | global |
| size | Integer | The width of the field, as expressed by the number of characters that can display at a time. | | 10.0 | global |
| style | String | The style used to display the inputSecret component, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the inputSecret component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| tabindex | String | The order in which this field is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| value | Object | A merge field that references the controller class variable that is associated with this field. For example, if the name of the associated variable in the controller class is myPasswordField, use value="{!myPasswordField}" to reference the variable. | | 10.0 | global |

**SEE ALSO:** `apex:input` · Using Input Components in a Page

---

## apex:inputText

An HTML input element of type text. Use this component to get user input for a controller method that does not correspond to a field on a Salesforce object. Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields. This component doesn't use Salesforce styling. Also, since it doesn't correspond to a field, or any other data on an object, custom code is required to use the value the user enters. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<input>` tag.

```html
<apex:inputText value="{!inputValue}" id="theTextInput"/>
```

Renders:

```html
<input id="theTextInput" type="text" name="theTextInput" />
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accesskey | String | The keyboard access key that puts the field in focus. When the text box is in focus, a user can select or deselect the field value. | | 10.0 | global |
| alt | String | An alternate text description of the field. | | 10.0 | global |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| disabled | Boolean | A Boolean value that specifies whether this text box should be displayed in a disabled state. If set to true, the text box appears disabled. If not specified, this value defaults to false. | | 10.0 | global |
| id | String | An identifier that allows the field component to be referenced by other components in the page. | | 10.0 | global |
| label | String | A text value that allows to display a label next to the control and reference the control in the error message | | 23.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| list | Object | A list of auto-complete values to be added to an HTML `<datalist>` block associated with the input field. The list attribute is specified as either a comma-delimited static string or a Visualforce expression. An expression can resolve to either a comma-delimited string, or a list of objects. List elements can be any data type, as long as that type can be coerced to a string, either as an Apex language feature or via a toString() method. | | 29.0 | global |
| maxlength | Integer | The maximum number of characters that a user can enter for this field, expressed as an integer. | | 10.0 | global |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the field. | | 10.0 | global |
| onchange | String | The JavaScript invoked if the onchange event occurs--that is, if the user changes the content of the field. | | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the field. | | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the field twice. | | 10.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the field. | | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the field. | | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the field. | | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| required | Boolean | A Boolean value that specifies whether this field is a required field. If set to true, the user must specify a value for this field. If not selected, this value defaults to false. | | 10.0 | global |
| size | Integer | The width of the input field, as expressed by the number of characters that can display at a time. | | 10.0 | global |
| style | String | The style used to display the inputText component, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the inputText component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| tabindex | String | The order in which this field is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| value | Object | A merge field that references the controller class variable that is associated with this field. For example, if the name of the associated variable in the controller class is myTextField, use value="{!myTextField}" to reference the variable. | | 10.0 | global |

**SEE ALSO:** `apex:input` · Using Input Components in a Page

---

## apex:inputTextarea

A text area input element. Use this component to get user input for a controller method that does not correspond to a field on a Salesforce object, for a value that requires a text area. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<textarea>` tag.

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid contract record in the URL.
For example, if 001D000000IRt53 is the contract ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<apex:page standardController="Contract">
<apex:form id="changeDescription">
<apex:pageBlock>
<p>Current description: {!contract.description}</p>
<p>Change description to:</p>
<apex:inputTextarea id="newDesc" value="{!contract.description}"/><p/>
<apex:commandButton value="Save" action="{!save}"/>
</apex:pageBlock>
</apex:form>
</apex:page>
```

Renders:

```html
<!-- changes the value of {!contract.description} on save -->
<form id="j_id0:changeDescription" name="j_id0:changeDescription" method="post"
action="/apex/sandbox" enctype="application/x-www-form-urlencoded">
<input type="hidden" name="j_id0:changeDescription" value="j_id0:changeDescription"
/>
<!-- opening div tags -->
<p>Current description: To facilitate better deals</p>
<p>Change description to:</p>
<textarea id="j_id0:changeDescription:j_id1:newDesc"
name="j_id0:changeDescription:j_id1:newDesc"/>
<input type="submit" name="j_id0:changeDescription:j_id1:j_id4" value="Save"
class="btn" />
<!-- closing div tags -->
</form>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accesskey | String | The keyboard access key that puts the text area in focus. When the text area is in focus, a user can enter a value. | | 10.0 | global |
| cols | Integer | The width of the field, as expressed by the number of characters that can display in a single row at a time. | | 10.0 | global |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| disabled | Boolean | A Boolean value that specifies whether this text area should be displayed in a disabled state. If set to true, the text area appears disabled. If not specified, this value defaults to false. | | 10.0 | global |
| id | String | An identifier that allows the checkbox component to be referenced by other components in the page. [sic — "checkbox"] | | 10.0 | global |
| label | String | A text value that allows to display a label next to the control and reference the control in the error message | | 23.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the text area. | | 10.0 | global |
| onchange | String | The JavaScript invoked if the onchange event occurs--that is, if the user changes the content of the text area. | | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the text area. | | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the text area twice. | | 10.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the text area. | | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the text area. | | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the text area. | | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 10.0 | global |
| onselect | String | The JavaScript invoked if the onselect event occurs--that is, if the user selects text in the text area. | | 10.0 | global |
| readonly | Boolean | A Boolean value that specifies whether this text area should be rendered as read-only. If set to true, the text area value cannot be changed. If not selected, this value defaults to false. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| required | Boolean | A Boolean value that specifies whether this text area is a required field. If set to true, the user must specify a value for this text area. If not selected, this value defaults to false. | | 10.0 | global |
| richText | Boolean | A Boolean value that specifies whether this text area should save as rich text or plain text. If set to true, the value saves as rich text. If not selected, this value defaults to false. | | 10.0 | global |
| rows | Integer | The height of the text area, as expressed by the number of rows that can display at a time. | | 10.0 | global |
| style | String | The style used to display the text area component, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the text area component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| tabindex | String | The order in which this text area is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| value | Object | A merge field that references the controller class variable that is associated with this text area. For example, if the name of the associated variable in the controller class is myLongDescription, use value="{!myLongDescription}" to reference the variable. | | 10.0 | global |

**SEE ALSO:** `apex:input` · Using Input Components in a Page

---

## apex:selectCheckboxes

A set of related checkbox input elements displayed in a table. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated container `<table>` tag.

```html
<!-- Page: -->
<apex:page controller="sampleCon">
<apex:form>
<apex:selectCheckboxes value="{!countries}">
<apex:selectOptions value="{!items}"/>
</apex:selectCheckboxes><br/>
<apex:commandButton value="Test" action="{!test}" rerender="out" status="status"/>
</apex:form>
<apex:outputPanel id="out">
<apex:actionstatus id="status" startText="testing...">
<apex:facet name="stop">
<apex:outputPanel>
<p>You have selected:</p>
<apex:dataList value="{!countries}" var="c">{!c}</apex:dataList>
</apex:outputPanel>
</apex:facet>
</apex:actionstatus>
</apex:outputPanel>
</apex:page>
/*** Controller: ***/
public class sampleCon {
String[] countries = new String[]{};
public PageReference test() {
return null;
}
public List<SelectOption> getItems() {
List<SelectOption> options = new List<SelectOption>();
options.add(new SelectOption('US','US'));
options.add(new SelectOption('CANADA','Canada'));
options.add(new SelectOption('MEXICO','Mexico'));
return options;
}
public String[] getCountries() {
return countries;
}
public void setCountries(String[] countries) {
this.countries = countries;
}
}
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accesskey | String | The keyboard access key that puts the selectCheckboxes component in focus. When the selectCheckboxes component is in focus, users can use the keyboard to select and deselect individual checkbox options. | | 10.0 | global |
| border | Integer | The width of the frame around the rendered HTML table, in pixels. | | 10.0 | global |
| borderVisible | Boolean | Controls whether the border around the `<fieldset>` that wraps the checkboxes table is visible or hidden. The default value is false, there is no border. | | 29.0 | — |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| disabled | Boolean | A Boolean value that specifies whether the selectCheckboxes component should be displayed in a disabled state. If set to true, the checkboxes appear disabled. If not specified, this value defaults to false. | | 10.0 | global |
| disabledClass | String | The style class used to display the selectCheckboxes component when the disabled attribute is set to true, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| enabledClass | String | The style class used to display the selectCheckboxes component when the disabled attribute is set to false, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| id | String | An identifier that allows the selectCheckboxes component to be referenced by other components in the page. | | 10.0 | global |
| immediate | Boolean | A Boolean value that specifies whether the action associated with this component should happen immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false. See Use the immediate Attribute Carefully. | | 11.0 | global |
| label | String | A text value that allows to display a label next to the control and reference the control in the error message | | 23.0 | — |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| layout | String | The method by which checkboxes should be displayed in the table. Possible values include "lineDirection", in which checkboxes are placed horizontally, or "pageDirection", in which checkboxes are placed vertically. If not specified, this value defaults to "lineDirection". | | 10.0 | global |
| legendInvisible | Boolean | Controls whether the legend text is displayed or hidden. The default value is false, the legend text is displayed for all users. When set to true, the `<legend>` has a styling attribute added, class="assistiveText", which preserves the legend text in the DOM, but moves the display off-screen. This makes the text accessible to screen readers, without being displayed visually. | | 29.0 | — |
| legendText | String | The text to be displayed as a legend for the checkboxes group. When the border is visible, the legend is inlaid along the top-left edge of the border. When legendText is an empty string, or not set, no legend is added. | | 29.0 | — |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the selectCheckboxes component. | | 10.0 | global |
| onchange | String | The JavaScript invoked if the onchange event occurs--that is, if the value of any checkbox in the selectCheckboxes component changes. | | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the selectCheckboxes component. | | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the selectCheckboxes component twice. [sic — desc says "onclick"] | | 10.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the selectCheckboxes component. | | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the selectCheckboxes component. | | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the selectCheckboxes component. | | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 10.0 | global |
| onselect | String | The JavaScript invoked if the onselect event occurs--that is, if the user selects a checkbox in the selectCheckboxes component. | | 10.0 | global |
| readonly | Boolean | A Boolean value that specifies whether this selectCheckboxes component is rendered as read-only. If set to true, the checkbox values cannot be changed. If not selected, this value defaults to false. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| required | Boolean | A Boolean value that specifies whether this selectCheckboxes component is a required field. If set to true, the user must select one or more of these checkboxes. If not selected, this value defaults to false. | | 10.0 | global |
| style | String | The style used to display the selectCheckboxes component, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the selectCheckboxes component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| tabindex | String | The order in which this selectCheckboxes component is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| value | Object | A merge field that references the controller class variable that is associated with this selectCheckboxes component. For example, if the name of the associated variable in the controller class is myCheckboxSelections use value="{!myCheckboxSelections}" to reference the variable. | | 10.0 | global |

**SEE ALSO:** `apex:selectOption` · SelectOption Class

---

## apex:selectList

A list of options that allows users to select only one value or multiple values at a time, depending on the value of its multiselect attribute. Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<select>` tag.

```html
<!-- Page: -->
<apex:page controller="sampleCon">
<apex:form>
<apex:selectList value="{!countries}" multiselect="true">
<apex:selectOptions value="{!items}"/>
</apex:selectList><p/>
<apex:commandButton value="Test" action="{!test}" rerender="out" status="status"/>
</apex:form>
<apex:outputPanel id="out">
<apex:actionstatus id="status" startText="testing...">
<apex:facet name="stop">
<apex:outputPanel>
<p>You have selected:</p>
<apex:dataList value="{!countries}" var="c">{!c}</apex:dataList>
</apex:outputPanel>
</apex:facet>
</apex:actionstatus>
</apex:outputPanel>
</apex:page>
/*** Controller: ***/
public class sampleCon {
String[] countries = new String[]{};
//If multiselect is false, countries must be of type String
//String countries;
public PageReference test() {
return null;
}
public List<SelectOption> getItems() {
List<SelectOption> options = new List<SelectOption>();
options.add(new SelectOption('US','US'));
options.add(new SelectOption('CANADA','Canada'));
options.add(new SelectOption('MEXICO','Mexico'));
return options;
}
public String[] getCountries() {
//If multiselect is false, countries must be of type String
return countries;
}
public void setCountries(String[] countries) {
//If multiselect is false, countries must be of type String
this.countries = countries;
}
}
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accesskey | String | The keyboard access key that puts the selectList in focus. When the selectList is in focus, a user can select or deselect list options. | | 10.0 | global |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| disabled | Boolean | A Boolean value that specifies whether this selectList should be displayed in a disabled state. If set to true, the selectList appears disabled. If not specified, this value defaults to false. | | 10.0 | global |
| disabledClass | String | The style class used to display the selectList component when the disabled attribute is set to true, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| enabledClass | String | The style class used to display the selectList component when the disabled attribute is set to false, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| id | String | An identifier that allows the selectList component to be referenced by other components in the page. | | 10.0 | global |
| label | String | A text value that allows to display a label next to the control and reference the control in the error message | | 23.0 | — |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| multiselect | Boolean | A Boolean value that specifies whether users can select more than one option as a time from this selectList. If set to true, users can select more than one option at a time. If not specified, this value defaults to false. If multiselect is true, the value attribute must be of type String[] or a List of strings. Otherwise, it must be of type String. | | 10.0 | global |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the selectList component. | | 10.0 | global |
| onchange | String | The JavaScript invoked if the onchange event occurs--that is, if the value of the selectList component changes. | | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the selectList component. | | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the selectList component twice. [sic — "onclick"] | | 10.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the selectList component. | | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the selectList component. | | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the selectList component. | | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 10.0 | global |
| onselect | String | The JavaScript invoked if the onselect event occurs--that is, if the user selects an option in the selectList component. | | 10.0 | global |
| readonly | Boolean | A Boolean value that specifies whether this selectList component is rendered as read-only. If set to true, the list option selections cannot be changed. If not selected, this value defaults to false. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| required | Boolean | A Boolean value that specifies whether this selectList component is a required field. If set to true, the user must select at least one list option. If not selected, this value defaults to false. | | 10.0 | global |
| size | Integer | The number of selectList options displayed at one time. If this number is less than the total number of options, a scroll bar is displayed in the selectList. If not specified, all available options are displayed. | | 10.0 | global |
| skipValidationInRepeat | Boolean | A Boolean value that specifies whether to skip validation of a selected value. Set this to true if you're seeing validation errors when selecting a value in a selectList that's within a repeat component. | | — | — |
| style | String | The style used to display the selectList component, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the selectList component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| tabindex | String | The order in which this selectList component is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| value | Object | A merge field that references the controller class variable that is associated with this selectList. For example, if the name of the associated variable in the controller class is myListSelections, use value="{!myListSelections}" to reference the variable. If multiselect is true, the value attribute must be of type String[] or a List of strings. Otherwise, it must be of type String. | | 10.0 | global |

> `skipValidationInRepeat`의 API Version·Access 셀은 PDF 원문에서 공란이다(다른 selectList 속성과 달리 버전 토큰 없음).

**SEE ALSO:** `apex:selectOption` · SelectOption Class

---

## apex:selectOption

A possible value for an `<apex:selectCheckboxes>`, `<apex:selectRadio>`, or `<apex:selectList>` component. The `<apex:selectOption>` component must be a child of one of those components. Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<input>` tag for components within an `<apex:selectCheckboxes>` or `<apex:selectRadio>` parent component, or to the generated `<option>` tag for components within an `<apex:selectList>` parent component.

```html
<!-- Page: -->
<apex:page controller="chooseColor">
<apex:form>
<apex:selectList id="chooseColor" value="{!string}" size="1">
<apex:selectOption itemValue="red" itemLabel="Red"/>
<apex:selectOption itemValue="white" itemLabel="White"/>
<apex:selectOption itemValue="blue" itemLabel="Blue"/>
</apex:selectList>
</apex:form>
</apex:page>
/*** Controller ***/
public class chooseColor {
String s = 'blue';
public String getString() {
return s;
}
public void setString(String s) {
this.s = s;
}
}
```

Renders:

```html
<select id="chooseColor" name="chooseColor" size="1">
<option value="red">Red</option>
<option value="white">White</option>
<option value="blue" selected="selected">Blue</option>
</select>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| id | String | An identifier that allows the selectOption component to be referenced by other components in the page. | | 10.0 | global |
| itemDescription | String | A description of the selectOption component, for use in development tools. | | 10.0 | global |
| itemDisabled | Boolean | A Boolean value that specifies whether the selectOption component should be displayed in a disabled state. If set to true, the option appears disabled. If not specified, this value defaults to false. | | 10.0 | global |
| itemEscaped | Boolean | A Boolean value that specifies whether sensitive HTML and XML characters should be escaped in the HTML output generated by this component. If not specified, this value defaults to true. For example, the only way to add a ">" symbol to a label is by using the symbol's escape sequence and setting itemEscaped="false". If you do not specify itemEscaped="false", the character escape sequence displays as written. | | 10.0 | global |
| itemLabel | String | The label used to display this option to users. | | 10.0 | global |
| itemValue | Object | The value sent to the server if this option is selected by the user. | | 10.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the selectOption component. | | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the selectOption component twice. [sic — "onclick"] | | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the selectOption. | | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the selectOption. | | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| style | String | This attribute was deprecated in Salesforce API version 17.0 and has no effect on the page. | | 10.0 | global |
| styleClass | String | This attribute was deprecated in Salesforce API version 17.0 and has no effect on the page. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| value | Object | A merge field that references the controller class variable of type SelectOption that is associated with this selectOption component. For example, if the name of the associated variable in the controller class is myOption, use value="{!myOption}" to reference the variable. | | 10.0 | global |

**SEE ALSO:** `apex:selectList` · `apex:selectCheckboxes` · SelectOption Class

---

## apex:selectOptions

A collection of possible values for an `<apex:selectCheckBoxes>`, `<apex:selectRadio>`, or `<apex:selectList>` component. An `<apex:selectOptions>` component must be a child of one of those components. It must also be bound to a collection of selectOption objects in a custom Visualforce controller. Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<input>` tag for components within an `<apex:selectCheckboxes>` or `<apex:selectRadio>` parent component, or the generated `<option>` tag for components within an `<apex:selectList>` parent component.

```html
<!-- Page: -->
<apex:page controller="sampleCon">
<apex:form>
<apex:selectCheckboxes value="{!countries}" title="Choose a country">
<apex:selectOptions value="{!items}"/>
</apex:selectCheckboxes><br/>
<apex:commandButton value="Test" action="{!test}" rerender="out" status="status"/>
</apex:form>
<apex:outputPanel id="out">
<apex:actionstatus id="status" startText="testing...">
<apex:facet name="stop">
<apex:outputPanel>
<p>You have selected:</p>
<apex:dataList value="{!countries}" var="c">a:{!c}</apex:dataList>
</apex:outputPanel>
</apex:facet>
</apex:actionstatus>
</apex:outputPanel>
</apex:page>
/*** Controller: ***/
public class sampleCon {
String[] countries = new String[]{};
public PageReference test() {
return null;
}
public List<SelectOption> getItems() {
List<SelectOption> options = new List<SelectOption>();
options.add(new SelectOption('US','US'));
options.add(new SelectOption('CANADA','Canada'));
options.add(new SelectOption('MEXICO','Mexico'));
return options;
}
public String[] getCountries() {
return countries;
}
public void setCountries(String[] countries) {
this.countries = countries;
}
}
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the selectOptions component to be referenced by other components in the page. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| value | Object | A merge field that references the controller class collection variable of type SelectOption that is associated with this selectOptions component. For example, if the name of the associated variable in the controller class is mySetOfOptions, use value="{!mySetOfOptions}" to reference the variable. | Yes | 10.0 | global |

**SEE ALSO:** `apex:selectList` · `apex:selectCheckboxes` · `apex:selectRadio` · SelectOption Class

---

## apex:selectRadio

A set of related radio button input elements, displayed in a table. Unlike checkboxes, only one radio button can be selected at a time. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated container `<table>` tag.

```html
<!-- Page: -->
<apex:page controller="sampleCon">
<apex:form>
<apex:selectRadio value="{!country}">
<apex:selectOptions value="{!items}"/>
</apex:selectRadio><p/>
<apex:commandButton value="Test" action="{!test}" rerender="out"
status="status"/>
</apex:form>
<apex:outputPanel id="out">
<apex:actionstatus id="status" startText="testing...">
<apex:facet name="stop">
<apex:outputPanel>
<p>You have selected:</p>
<apex:outputText value="{!country}"/>
</apex:outputPanel>
</apex:facet>
</apex:actionstatus>
</apex:outputPanel>
</apex:page>
/*** Controller ***/
public class sampleCon {
String country = null;

public PageReference test() {
return null;
}
public List<SelectOption> getItems() {
List<SelectOption> options = new List<SelectOption>();
options.add(new SelectOption('US','US'));
options.add(new SelectOption('CANADA','Canada'));
options.add(new SelectOption('MEXICO','Mexico')); return options;
}
public String getCountry() {
return country;
}
public void setCountry(String country) { this.country = country; }
}
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accesskey | String | The keyboard access key that puts the radio buttons in focus. When the radio buttons are in focus, a user can select or deselect a radio button value. | | 10.0 | global |
| border | Integer | The width of the frame around the rendered HTML table, in pixels. | | 10.0 | global |
| borderVisible | Boolean | Controls whether the border around the `<fieldset>` that wraps the radio buttons table is visible or hidden. The default value is false, there is no border. | | 29.0 | — |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| disabled | Boolean | A Boolean value that specifies whether the selectRadio component should be displayed in a disabled state. If set to true, the radio buttons appear disabled. If not specified, this value defaults to false. | | 10.0 | global |
| disabledClass | String | The style class used to display the selectRadio component when the disabled attribute is set to true, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| enabledClass | String | The style class used to display the selectRadio component when the disabled attribute is set to false, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| id | String | An identifier that allows the selectRadio component to be referenced by other components in the page. | | 10.0 | global |
| immediate | Boolean | A Boolean value that specifies whether the action associated with this component should happen immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false. See Use the immediate Attribute Carefully. | | 11.0 | global |
| label | String | A text value that allows to display a label next to the control and reference the control in the error message | | 23.0 | — |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| layout | String | The method by which radio buttons should be displayed in the table. Possible values include "lineDirection", in which radio buttons are placed horizontally, or "pageDirection", in which radio buttons are placed vertically. If not specified, this value defaults to "lineDirection". | | 10.0 | global |
| legendInvisible | Boolean | Controls whether the legend text is displayed or hidden. The default value is false, the legend text is displayed for all users. When set to true, the `<legend>` has a styling attribute added, class="assistiveText", which preserves the legend text in the DOM, but moves the display off-screen. This makes the text accessible to screen readers, without being displayed visually. | | 29.0 | — |
| legendText | String | The text to be displayed as a legend for the radio buttons group. When the border is visible, the legend is inlaid along the top-left edge of the border. When legendText is an empty string, or not set, no legend is added. | | 29.0 | — |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the selectRadio component. | | 10.0 | global |
| onchange | String | The JavaScript invoked if the onchange event occurs--that is, if the value of any radio button in the selectRadio component changes. | | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the selectRadio component. | | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the selectRadio component twice. [sic — "onclick"] | | 10.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the selectRadio component. | | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the selectRadio component. | | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the selectRadio component. | | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 10.0 | global |
| onselect | String | The JavaScript invoked if the onselect event occurs--that is, if the user selects a radio button in the selectRadio component. | | 10.0 | global |
| readonly | Boolean | A Boolean value that specifies whether this selectRadio component is rendered as read-only. If set to true, the selected radio button is unchangeable. If not selected, this value defaults to false, and the selected radio button can be changed. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| required | Boolean | A Boolean value that specifies whether this selectRadio component is a required field. If set to true, the user must select a radio button. If not selected, this value defaults to false. | | 10.0 | global |
| style | String | The CSS style used to display the selectRadio component, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the selectRadio component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| tabindex | String | The order in which this selectRadio component is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| value | Object | A merge field that references the controller class variable that is associated with this selectRadio component. For example, if the name of the associated variable in the controller class is myRadioButtonSelection use value="{!myRadioButtonSelection}" to reference the variable. | | 10.0 | global |

**SEE ALSO:** `apex:selectOption` · SelectOption Class

---

## apex:commandButton

A button that is rendered as an HTML input element with the type attribute set to submit, reset, or image, depending on the `<apex:commandButton>` tag's specified values. The button executes an action defined by a controller, and then either refreshes the current page, or navigates to a different page based on the PageReference variable that is returned by the action. An `<apex:commandButton>` component must always be a child of an `<apex:form>` component. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<input>` tag.

```html
<apex:commandButton action="{!save}" value="Save" id="theButton"/>
```

Renders:

```html
<input id="thePage:theForm:theButton" type="submit" name="thePage:theForm:theButton"
value="Save" />
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accesskey | String | The keyboard access key that puts the command button in focus. When the command button is in focus, pressing the Enter key is equivalent to clicking the button. | | 10.0 | global |
| action | ApexPages.Action | The action method invoked by the AJAX request to the server. Use merge-field syntax to reference the method. For example, action="{!save}" references the save method in the controller. If an action isn't specified, the page simply refreshes. Note that command buttons associated with the save, edit, or delete actions in a standard controller are rendered only if the user has the appropriate permissions. Likewise, command buttons associated with the edit and delete actions are rendered only if a record is associated with the page. | | 10.0 | global |
| alt | String | An alternate text description of the command button. | | 10.0 | global |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| disabled | Boolean | A Boolean value that specifies whether this button should be displayed in a disabled state. If set to true, the button appears disabled. If not specified, this value defaults to false. | | 10.0 | global |
| id | String | An identifier that allows the commandButton component to be referenced by other components in the page. | | 10.0 | global |
| image | String | The absolute or relative URL of the image displayed as this button. If specified, the type of the generated HTML input element is set to "image". | | 10.0 | global |
| immediate | Boolean | A Boolean value that specifies whether the action associated with this component should happen immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false. See Use the immediate Attribute Carefully. | | 11.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the command button. | | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the command button. | | 10.0 | global |
| oncomplete | String | The JavaScript invoked when the result of an AJAX update request completes on the client. | | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the command button twice. | | 10.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the command button. | | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the command button. | | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the command button. | | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| reRender | Object | The ID of one or more components that are redrawn when the result of an AJAX update request returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | | 10.0 | global |
| status | String | The ID of an associated component that displays the status of an AJAX update request. See the actionStatus component. | | 10.0 | global |
| style | String | The style used to display the commandButton component, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the commandButton component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| tabindex | String | The order in which this button is selected compared to other page components when a user presses the Tab key repeatedly. This value must be a number between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 10.0 | global |
| timeout | Integer | The amount of time (in milliseconds) before an AJAX update request should time out. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| value | Object | The text displayed on the commandButton as its label. | | 10.0 | global |

**SEE ALSO:** `apex:commandLink`

---

## apex:commandLink

A link that executes an action defined by a controller, and then either refreshes the current page, or navigates to a different page based on the PageReference variable that is returned by the action. An `<apex:commandLink>` component must always be a child of an `<apex:form>` component. To add request parameters to an `<apex:commandLink>`, use nested `<apex:param>` components. See also: `<apex:commandButton>`, `<apex:outputLink>`. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<a>` tag.

```html
<apex:commandLink action="{!save}" value="Save" id="theCommandLink"/>
```

Renders:

```html
<a id="thePage:theForm:theCommandLink" href="#" onclick="generatedJs()">Save</a>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accesskey | String | The keyboard access key that puts the command link in focus. When the command link is in focus, pressing the Enter key is equivalent to clicking the link. | | 10.0 | global |
| action | ApexPages.Action | The action method invoked by the AJAX request to the server. Use merge-field syntax to reference the method. For example, action="{!save}" references the save() method in the controller. If an action isn't specified, the page simply refreshes. Note that command links associated with the save, edit, or delete actions in a standard controller are rendered only if the user has the appropriate permissions. Likewise, command links associated with the edit and delete actions are rendered only if a record is associated with the page. | | 10.0 | global |
| charset | String | The character set used to encode the specified URL. If not specified, this value defaults to "ISO-8859-1". | | 10.0 | global |
| coords | String | The position and shape of the hot spot on the screen used for the command link (for use in client-side image maps). The number and order of comma-separated values depends on the shape being defined. For example, to define a rectangle, use coords="left-x, top-y, right-x, bottom-y". To define a circle, use coords="center-x, center-y, radius". To define a polygon, use coords="x1, y1, x2, y2, ..., xN, yN", where x1 = nN and y1 = yN. Coordinates can be expressed in pixels or percentages, and represent the distance from the top-left corner of the image that is mapped. See also the shape attribute. | | 10.0 | global |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| hreflang | String | The base language for the resource referenced by this command link, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| id | String | An identifier that allows the commandLink component to be referenced by other components in the page. | | 10.0 | global |
| immediate | Boolean | A Boolean value that specifies whether the action associated with this component should happen immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false. See Use the immediate Attribute Carefully. | | 11.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the command link. | | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the command link. | | 10.0 | global |
| oncomplete | String | The JavaScript invoked when the result of an AJAX update request completes on the client. | | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the command link twice. | | 10.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the command link. | | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the command link. | | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the command link. | | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 10.0 | global |
| rel | String | The relationship from the current document to the URL specified by this command link. The value of this attribute is a space-separated list of link types. For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| reRender | Object | The ID of one or more components that are redrawn when the result of an AJAX update request returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. | | 10.0 | global |
| rev | String | The reverse link from the URL specified by this command link to the current document. The value of this attribute is a space-separated list of link types. For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| shape | String | The shape of the hot spot in client-side image maps. Valid values are default, circle, rect, and poly. See also the coords attribute. | | 10.0 | global |
| status | String | The ID of an associated component that displays the status of an AJAX update request. See the actionStatus component. | | 10.0 | global |
| style | String | The style used to display the commandLink component, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the commandLink component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| tabindex | String | The order in which this link is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 10.0 | global |
| target | String | The name of the frame where the resource retrieved by this command link should be displayed. Possible values for this attribute include "_blank", "_parent", "_self", and "_top". You can also specify your own target names by assigning a value to the name attribute of a desired destination. | | 10.0 | global |
| timeout | Integer | The amount of time (in milliseconds) before an AJAX update request should time out. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| type | String | The MIME content type of the resource designated by this command link. Possible values for this attribute include "text/html", "image/png", "image/gif", "video/mpeg", "text/css", and "audio/basic". For more information, including a complete list of possible values, see the W3C specifications. | | 10.0 | global |
| value | Object | The text that is displayed as the commandLink label. Note that you can also specify text or an image to display as the command link by embedding content in the body of the commandLink tag. If both the value attribute and embedded content are included, they are displayed together. | | 10.0 | global |

**SEE ALSO:** `apex:form` · `apex:commandButton` · `apex:outputLink`

---

## apex:inlineEditSupport

This component provides inline editing support to `<apex:outputField>` and various container components. In order to support inline editing, this component must also be within an `<apex:form>` tag. The `<apex:inlineEditSupport>` component can only be a descendant of the following tags:

- `<apex:dataList>`
- `<apex:dataTable>`
- `<apex:form>`
- `<apex:outputField>`
- `<apex:pageBlock>`
- `<apex:pageBlockSection>`
- `<apex:pageBlockTable>`
- `<apex:repeat>`

See also: the inlineEdit attribute of `<apex:detail>`

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid contact record in the URL.
For example, if 001D000000IRt53 is the contact ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<apex:page standardController="Contact">
<apex:form >
<apex:pageBlock mode="inlineEdit">
<apex:pageBlockButtons >
<apex:commandButton action="{!edit}" id="editButton" value="Edit"/>
<apex:commandButton action="{!save}" id="saveButton" value="Save"/>
<apex:commandButton onclick="resetInlineEdit()" id="cancelButton"
value="Cancel"/>
</apex:pageBlockButtons>
<apex:pageBlockSection >
<apex:outputField value="{!contact.lastname}">
<apex:inlineEditSupport showOnEdit="saveButton, cancelButton"
hideOnEdit="editButton" event="ondblclick"
changedStyleClass="myBoldClass" resetFunction="resetInlineEdit"/>
</apex:outputField>
<apex:outputField value="{!contact.accountId}"/>
<apex:outputField value="{!contact.phone}"/>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:form>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| changedStyleClass | String | The name of a CSS style class used when the contents of a field have changed. | | 21.0 | — |
| disabled | Boolean | A Boolean value that indicates whether inline editing is enabled or not. If not specified, this value defaults to true. | | 21.0 | — |
| event | String | The name of a standard DOM event, such as ondblclick or onmouseover, that triggers inline editing on a field. | | 21.0 | — |
| hideOnEdit | Object | A comma-separated list of button IDs. These buttons hide when inline editing is activated. | | 21.0 | — |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this defaults to true. | | 21.0 | — |
| resetFunction | String | The name of the JavaScript function that is called when values are reset. | | 21.0 | — |
| showOnEdit | Object | A comma-separated list of button IDs. These buttons display when inline editing is activated. | | 21.0 | — |

**SEE ALSO:** Knowledge Article: Apex:outputField No Longer Supported when Edit Permission is Disabled · `apex:detail` · `apex:form` · `apex:outputField` · Enabling Inline Editing

---

## apex:param

A parameter for the parent component. The `<apex:param>` component can only be a child of the following components:

- `<apex:actionFunction>`
- `<apex:actionSupport>`
- `<apex:commandLink>`
- `<apex:outputLink>`
- `<apex:outputText>`
- `<flow:interview>`

Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields. Within `<apex:outputText>`, there's support for the `<apex:param>` tag to match the syntax of the MessageFormat class in Java.

```html
<!-- For this example to render fully, associate the page
with a valid contact record in the URL.
For example: https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53 -->
<apex:page standardController="Contact">
<apex:outputLink value="http://google.com/search">
Search Google
<apex:param name="q" value="{!contact.name}"/>
</apex:outputLink>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| assignTo | Object | A setter method that assigns the value of this param to a variable in the associated Visualforce controller. If this attribute is used, getter and setter methods, or a property with get and set values, must be defined. | | 10.0 | global |
| id | String | An identifier that allows the param component to be referenced by other components in the page. | | 10.0 | global |
| name | String | The key for this parameter, for example, name="Location". | Yes | 10.0 | global |
| value | Object | The data associated with this parameter, for example, value="San Francisco, CA". The value attribute must be set to a string, number, or boolean value. | Yes | 10.0 | global |

---

## apex:attribute

A definition of an attribute on a custom component. The attribute tag can be a child of a component tag only.

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
| access | String | Indicates whether the attribute can be used outside of any page in the same namespace as the attribute. Possible values are "public" (default) and "global". Use global to indicate the attribute can be used outside of the attribute's namespace. If the access attribute on the parent apex:component is set to global, it must also be set to global on this component. If the access attribute on the parent apex:component is set to public, it cannot be set to global on this component. NOTE: Attributes with this designation are subject to the deprecation policies as described for managed packages in the appexchange. | | 14.0 | — |
| assignTo | Object | A setter method that assigns the value of this attribute to a class variable in the associated custom component controller. If this attribute is used, getter and setter methods, or a property with get and set values, must be defined. | | 12.0 | global |
| default | String | The default value for the attribute. | | 13.0 | global |
| description | String | A text description of the attribute. This description is included in the component reference as soon as the custom component is saved. | | 12.0 | global |
| encode | Boolean | This is a temporary option to address an issue affecting some package installations. It will be removed in the next release. Do not use unless advised to do so by Salesforce. | | 15.0 | — |
| id | String | An identifier that allows the attribute to be referenced by other tags in the custom component definition. | | 12.0 | global |
| name | String | The name of the attribute as it is used in Visualforce markup when the associated custom component includes a value for the attribute. The name must be unique across components and is case insensitive. For example, if two attributes are named "Model" and "model", the package treats them the same, potentially causing unexpected behavior. You can't define attributes named id, rendered, or action. These attributes are either automatically created for all custom component definitions, or otherwise not usable. | Yes | 12.0 | global |
| required | Boolean | A Boolean value that specifies whether a value for the attribute must be provided when the associated custom component is included in a Visualforce page. If set to true, a value is required. If not specified, this value defaults to false. | | 12.0 | global |
| type | String | The Apex data type of the attribute. If using the assignTo attribute to assign the value of this attribute to a controller class variable, the value for type must match the data type of the class variable. Only the following data types are allowed as values for the type attribute: Primitives, such as String, Integer, or Boolean. sObjects, such as Account, My_Custom_Object__c, or the generic sObject type. One-dimensional lists, specified using array-notation, such as String[], or Contact[]. Maps, specified using type="map". You don't need to specify the map's specific data type. Custom Apex types (classes). | Yes | 12.0 | global |

**SEE ALSO:** Custom Component Attributes

---

## apex:variable

A local variable that can be used as a replacement for a specified expression within the body of the component. Use `<apex:variable>` to reduce repetitive and verbose expressions within a page. Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields.

**Note:** `<apex:variable>` does not support reassignment inside of an iteration component, such as `<apex:dataTable>` or `<apex:repeat>`. The result of doing so, e.g., incrementing the `<apex:variable>` as a counter, is unsupported and undefined.

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid contact record in the URL.
For example, if 001D000000IRt53 is the contact ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<!-- Page: -->
<apex:page controller="variableCon">
<apex:variable var="c" value="{!contact}" />
<p>Greetings, {!c.LastName}.</p>
</apex:page>
/*** Controller ***/
public class variableCon {
Contact contact;
public Contact getContact() {
if (contact == null){
contact = [select LastName from Contact where
id = :ApexPages.currentPage().getParameters().get('id')];
}
return contact;
}
}
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| value | Object | The expression that can be represented by the variable within the body of the variable component. | Yes | 10.0 | global |
| var | String | The name of the variable that can be used to represent the value expression within the body of the variable component. | Yes | 10.0 | global |

---

## apex:outputField

A read-only display of a label and value for a field on a Salesforce object. An `<apex:outputField>` component respects the attributes of the associated field, including how it's displayed to the user. For example, if the specified `<apex:outputField>` component is a currency field, the appropriate currency symbol is displayed. Likewise, if the `<apex:outputField>` component is a lookup field or URL, the value of the field is displayed as a link. If custom help is defined for the field in Setup, the field must be a child of an `<apex:pageBlock>` or `<apex:pageBlockSectionItem>`, and the Salesforce page header must be displayed for the custom help to appear on your Visualforce page. To override the display of custom help, use the `<apex:outputField>` in the body of an `<apex:pageBlockSectionItem>`. The Rich Text Area data type can only be used with this component on pages running API versions greater than 18.0. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated container `<span>` tag.

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid opportunity record in the URL.
For example, if 001D000000IRt53 is the opportunity ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<apex:page standardController="Opportunity" tabStyle="Opportunity">
<apex:pageBlock>
<apex:pageBlockSection title="Opportunity Information">
<apex:outputField value="{!opportunity.name}"/>
<apex:outputField value="{!opportunity.amount}"/>
<apex:outputField value="{!opportunity.closeDate}"/>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| id | String | An identifier that allows the output field component to be referenced by other components in the page. | | 10.0 | global |
| label | String | A string value to be used as a component label. | | 23.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| style | String | The style used to display the output field component, used primarily for adding inline CSS styles. This attribute may not work for all values. If your text requires a class name, use a wrapping span tag. | | 10.0 | global |
| styleClass | String | The style class used to display the output field component, used primarily to designate which CSS styles are applied when using an external CSS style sheet. This attribute may not work for all values. If your text requires a class name, use a wrapping span tag. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| value | Object | An expression that references the Salesforce field that's associated with this output field. For example, if you want to display an output field for an account's name field, use value="{!account.name}". You can't associate an output field with a currency field if that field value is calculated using dated exchange rates. | | 10.0 | global |

---

## apex:outputLabel

A label for an input or output field. Use this component to provide a label for a controller method that does not correspond to a field on a Salesforce object. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<label>` tag.

```html
<apex:outputLabel value="Checkbox" for="theCheckbox"/>
<apex:inputCheckbox value="{!inputValue}" id="theCheckbox"/>
```

Renders:

```html
<label for="theCheckbox">Checkbox</label>
<input id="theCheckbox" type="checkbox" name="theCheckbox" />
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accesskey | String | The keyboard access key that puts the label and its associated field in focus. | | 10.0 | global |
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| escape | Boolean | A Boolean value that specifies whether sensitive HTML and XML characters should be escaped in the HTML output generated by this component. If you don't specify escape="false", the character escape sequence displays as written. For example, the only way to add a ">" symbol to a label is by using the symbol's character escape sequence and setting escape="false". If not specified, this value defaults to true. | | 10.0 | global |
| for | String | The ID of the component with which the label should be associated. When the label is in focus, the component specified by this attribute is also in focus. | | 10.0 | global |
| id | String | An identifier that allows the label component to be referenced by other components in the page. | | 10.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the label. | | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the label. | | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the label twice. | | 10.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the label. | | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the label. | | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the label. | | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| style | String | The style used to display the label component, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the label component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| tabindex | String | The order in which this label is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| value | Object | The text displayed as the label. | | 10.0 | global |

---

## apex:outputLink

A link to a URL. This component is rendered in HTML as an anchor tag with an href attribute. Like its HTML equivalent, the body of an `<apex:outputLink>` is the text or image that displays as the link. To add query string parameters to a link, use nested `<apex:param>` components. See also: `<apex:commandLink>`. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<a>` tag.

```html
<apex:outputLink value="https://www.salesforce.com"
id="theLink">www.salesforce.com</apex:outputLink>
```

Renders:

```html
<a id="theLink" name="theLink" href="https://www.salesforce.com">www.salesforce.com</a>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| accesskey | String | The keyboard access key that puts the link in focus. When the link is in focus, pressing the Enter key is equivalent to clicking the link. | | 10.0 | global |
| charset | String | The character set used to encode the specified URL. If not specified, this value defaults to ISO-8859-1. | | 10.0 | global |
| coords | String | The position and shape of the hot spot on the screen used for the output link (for use in client-side image maps). The number and order of comma-separated values depends on the shape being defined. For example, to define a rectangle, use coords="left-x, top-y, right-x, bottom-y". To define a circle, use coords="center-x, center-y, radius". To define a polygon, use coords="x1, y1, x2, y2, ..., xN, yN", where x1 = nN and y1 = yN. Coordinates can be expressed in pixels or percentages, and represent the distance from the top-left corner of the image that is mapped. See also the shape attribute. | | 10.0 | global |
| dir | String | The direction in which the generated HTML component is read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| disabled | Boolean | A Boolean value that specifies whether this link is displayed in a disabled state. If set to true, the field appears disabled because an HTML span tag is used in place of the normal anchor tag. If not specified, this value defaults to false. | | 10.0 | global |
| hreflang | String | The base language for the resource referenced by this command link, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| id | String | An identifier that allows the outputLink component to be referenced by other components in the page. | | 10.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| onblur | String | The JavaScript invoked if the onblur event occurs--that is, if the focus moves off of the output link. | | 10.0 | global |
| onclick | String | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the output link. | | 10.0 | global |
| ondblclick | String | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the output link twice. | | 10.0 | global |
| onfocus | String | The JavaScript invoked if the onfocus event occurs--that is, if the focus is on the output link. | | 10.0 | global |
| onkeydown | String | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. | | 10.0 | global |
| onkeypress | String | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. | | 10.0 | global |
| onkeyup | String | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. | | 10.0 | global |
| onmousedown | String | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. | | 10.0 | global |
| onmousemove | String | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. | | 10.0 | global |
| onmouseout | String | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the output link. | | 10.0 | global |
| onmouseover | String | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the output link. | | 10.0 | global |
| onmouseup | String | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. | | 10.0 | global |
| rel | String | The relationship from the current document to the URL specified by this command link. The value of this attribute is a space-separated list of link types. For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| rev | String | The reverse link from the URL specified by this command link to the current document. The value of this attribute is a space-separated list of link types. For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| shape | String | The shape of the hot spot in client-side image maps. Valid values are default, circle, rect, and poly. See also the coords attribute. | | 10.0 | global |
| style | String | The style used to display the output link component, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the output link component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| tabindex | String | The order in which this link is selected compared to other page components when a user presses the Tab key repeatedly. This value must be an integer between 0 and 32767, with component 0 being the first component that is selected when a user presses the Tab key. | | 10.0 | global |
| target | String | The name of the frame where the resource retrieved by this command link is displayed. Possible values for this attribute include "_blank", "_parent", "_self", and "_top". You can also specify your own target names by assigning a value to the name attribute of a desired destination. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| type | String | The MIME content type of the resource designated by this output link. Possible values for this attribute include "text/html", "image/png", "image/gif", "video/mpeg", "text/css", and "audio/basic". For more information, including a complete list of possible values, see the W3C specifications. | | 10.0 | global |
| value | Object | The URL used for the output link. **Warning: This value can also be supplied through a variable expression, which could contain an executable script.** | | 10.0 | global |

**SEE ALSO:** `apex:commandLink`

---

## apex:outputText

Displays text on a Visualforce page. You can customize the appearance of `<apex:outputText>` using CSS styles, in which case the generated text is wrapped in an HTML `<span>` tag. You can also escape the rendered text if it contains sensitive HTML and XML characters. Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields. Use with nested param tags to format the text values, where {n} corresponds to the n-th nested param tag. The value attribute supports the same syntax as the MessageFormat class in Java.

**Warning:** In API version 31.0 and earlier, encrypted custom field values that are embedded in the `<apex:outputText>` component display in clear text. The `<apex:outputText>` component doesn't respect the View Encrypted Data permission for users. To prevent showing sensitive information to unauthorized users, use the `<apex:outputField>` tag instead. In API version 32.0 and later, encrypted custom field values are masked.

Supports HTML pass-through attributes using the "html-" prefix; attached to the generated container `<span>` tag.

**예제 — 기본 포맷팅:**

```html
<apex:page>
<apex:outputText style="font-style:italic" value="This is {0} text with {1}.">
<apex:param value="my"/>
<apex:param value="arguments"/>
</apex:outputText>
</apex:page>
```

Renders:

```html
<span id="theText" style="font-style:italic">This is my text with arguments.</span>
```

**예제 — 날짜 포맷팅:**

```html
<apex:page>
<apex:outputText value="The unformatted time right now is: {! NOW() }" />
<br/>
<apex:outputText value="The formatted time right now is:
{0,date,yyyy.MM.dd G 'at' HH:mm:ss z}">
<apex:param value="{! NOW() }" />
</apex:outputText>
</apex:page>
```

Renders:

```html
The unformatted time right now is: 11/20/2004 3:49 PM
<br />
The formatted time right now is: 2004.11.20 AD at 23:49:02 GMT
```

**예제 — 통화 포맷팅:**

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL.
For example, if 001D000000IeChM is the account ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IeChM
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<apex:page standardController="Account">
It is worth:
<apex:outputText value="{0, number, 000,000.00}">
<apex:param value="{!Account.AnnualRevenue}" />
</apex:outputText>
</apex:page>
```

Renders:

```html
It is worth: 500,000,000.00
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| dir | String | The direction in which the generated HTML component is read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| escape | Boolean | A Boolean value that specifies whether sensitive HTML and XML characters should be escaped in the HTML output generated by this component. If you don't specify escape="false", the character escape sequence displays as written. Be aware that setting this value to "false" may be a security risk because it allows arbitrary content, including JavaScript, that could be used in a malicious manner. | | 10.0 | global |
| id | String | An identifier that allows the outputText component to be referenced by other components in the page. | | 10.0 | global |
| label | String | A text value that allows to display a label next to the output text | | 23.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| style | String | The style used to display the outputText component, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the outputText component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |
| value | Object | The text displayed when this component is rendered. This value supports the same syntax as the MessageFormat class in Java. | | 10.0 | global |

---

## apex:message

A message for a specific component, such as a warning or error. If an `<apex:message>` or `<apex:messages>` component is not included in a page, most warning and error messages are only shown in the debug log.

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL.
For example, if 001D000000IRt53 is the account ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<!-- Page: -->
<apex:page controller="MyController" tabStyle="Account">
<style>
.locationError { color: blue; font-weight: strong;}
.employeeError { color: green; font-weight: strong;}
</style>
<apex:form >
<apex:pageBlock title="Hello {!$User.FirstName}!">
This is your new page for the {!name} controller. <br/>
You are viewing the {!account.name} account.
<p>Number of Locations: <apex:inputField value="{!account.NumberofLocations__c}"
id="Location_validation"/>
(Enter an alphabetic character here, then click Save to see what happens.) </p>
<p>Number of Employees: <apex:inputField value="{!account.NumberOfEmployees}"
id="Employee_validation"/>
(Enter an alphabetic character here, then click Save to see what happens.) </p>
<p />
<apex:commandButton action="{!save}" value="Save"/>
<p />
<apex:message for="Location_validation" styleClass="locationError" /> <p />
<apex:message for="Employee_validation" styleClass="employeeError" />
<p />
</apex:pageBlock>
</apex:form>
</apex:page>
/*** Controller ***/
public class MyController {
Account account;
public PageReference save() {
try{
update account;
}
catch(DmlException ex){
ApexPages.addMessages(ex);
}
return null;
}
public String getName() {
return 'MyController';
}
public Account getAccount() {
if(account == null)
account = [select id, name, numberofemployees, numberoflocations__c from Account
where id = :ApexPages.currentPage().getParameters().get('id')];
return account;
}
}
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| for | String | The ID of the component with which the message should be associated. | | 10.0 | global |
| id | String | An identifier that allows the message component to be referenced by other components in the page. | | 10.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| style | String | The style used to display the message, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the message, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |

**SEE ALSO:** `apex:messages`

---

## apex:messages

All messages that were generated for all components on the current page. If an `<apex:message>` or `<apex:messages>` component is not included in a page, most warning and error messages are only shown in the debug log. Supports HTML pass-through attributes using the "html-" prefix; attached to the generated `<ul>` tag. (Each message is contained in a list item.)

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL.
For example, if 001D000000IRt53 is the account ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->

<!-- Page: -->
<apex:page controller="MyController" tabStyle="Account">
<apex:messages />
<apex:form >
<apex:pageBlock title="Hello {!$User.FirstName}!">
This is your new page for the {!name} controller. <br/>
You are viewing the {!account.name} account.
<p>Number of Locations: <apex:inputField value="{!account.NumberofLocations__c}"
id="Location_validation"/>
(Enter an alphabetic character here, then click save to see what happens.) </p>
<p>Number of Employees: <apex:inputField value="{!account.NumberOfEmployees}"
id="Employee_validation"/>
(Enter an alphabetic character here, then click save to see what happens.) </p>
<p />
<apex:commandButton action="{!save}" value="Save"/>
<p />
</apex:pageBlock>
</apex:form>
</apex:page>
/*** Controller ***/
public class MyController {
Account account;
public PageReference save() {
try{
update account;
}
catch(DmlException ex){
ApexPages.addMessages(ex);
}
return null;
}
public String getName() {
return 'MyController';
}
public Account getAccount() {
if(account == null)
account = [select id, name, numberofemployees, numberoflocations__c from Account
where id = :ApexPages.currentPage().getParameters().get('id')];
return account;
}
}
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| dir | String | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). | | 10.0 | global |
| globalOnly | Boolean | A Boolean value that specifies whether only messages that are not associated with any client ID are displayed. If not specified, this value defaults to false. | | 10.0 | global |
| id | String | An identifier that allows the message component to be referenced by other components in the page. | | 10.0 | global |
| lang | String | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. | | 10.0 | global |
| layout | String | The type of layout used to display the error messages. Possible values for this attribute include "list" or "table". If not specified, this value defaults to "list". | | 10.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 10.0 | global |
| style | String | The style used to display the messages, used primarily for adding inline CSS styles. | | 10.0 | global |
| styleClass | String | The style class used to display the messages, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. | | 10.0 | global |
| title | String | The text to display as a tooltip when the user's mouse pointer hovers over this component. | | 10.0 | global |

**SEE ALSO:** `apex:message`

---

## apex:pageMessage

This component should be used for presenting custom messages in the page using the Salesforce pattern for errors, warnings and other types of messages for a given severity. See also the pageMessages component.

```html
<apex:page standardController="Opportunity" recordSetVar="opportunities"
tabStyle="Opportunity" sidebar="false">
<p>Enter an alphabetic character for the "Close Date,"
then click Save to see what happens.</p>
<apex:form >
<apex:pageBlock >
<apex:pageMessage summary="This pageMessage will always display. Validation error
messages appear in the pageMessages component." severity="warning" strength="3"
/>
<apex:pageMessages />
<apex:pageBlockButtons >
<apex:commandButton value="Save" action="{!save}"/>
</apex:pageBlockButtons>
<apex:pageBlockTable value="{!opportunities}" var="opp">
<apex:column value="{!opp.name}"/>
<apex:column headerValue="Close Date">
<apex:inputField value="{!opp.closeDate}"/>
</apex:column>
</apex:pageBlockTable>
</apex:pageBlock>
</apex:form>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| detail | String | The detailed description of the information. | | 14.0 | — |
| escape | Boolean | A Boolean value that specifies whether sensitive HTML and XML characters should be escaped in the HTML output generated by this component. If you do not specify escape="false", the character escape sequence displays as written. Be aware that setting this value to "false" may be a security risk because it allows arbitrary content, including JavaScript, that could be used in a malicious manner. | | 14.0 | — |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| severity | String | The severity of the message. Values supported are: 'confirm', 'info', 'warning', 'error' | Yes | 14.0 | — |
| strength | Integer | The strength of the message. This controls the visibility and size of the icon displayed next to the message. Use 0 for no image, or 1-3 (highest strength, largest icon). | | 14.0 | — |
| summary | String | The summary message. | | 14.0 | — |
| title | String | The title text for the message. | | 14.0 | — |

**SEE ALSO:** `apex:pageMessages`

---

## apex:pageMessages

This component displays all messages that were generated for all components on the current page, presented using the Salesforce styling. Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields.

```html
<apex:page standardController="Opportunity" recordSetVar="opportunities"
tabStyle="Opportunity" sidebar="false">
<p>Enter an alphabetic character for the "Close Date,"
then click Save to see what happens.</p>
<apex:form >
<apex:pageBlock >
<apex:pageMessages />
<apex:pageBlockButtons >
<apex:commandButton value="Save" action="{!save}"/>
</apex:pageBlockButtons>
<apex:pageBlockTable value="{!opportunities}" var="opp">
<apex:column value="{!opp.name}"/>
<apex:column headerValue="Close Date">
<apex:inputField value="{!opp.closeDate}"/>
</apex:column>
</apex:pageBlockTable>
</apex:pageBlock>
</apex:form>
</apex:page>
```

| Attribute Name | Type | Description | Required? | API Version | Access |
|---|---|---|---|---|---|
| escape | Boolean | A Boolean value that specifies whether sensitive HTML and XML characters should be escaped in the HTML output generated by this component. If you do not specify escape="false", the character escape sequence displays as written. Be aware that setting this value to "false" may be a security risk because it allows arbitrary content, including JavaScript, that could be used in a malicious manner. | | 14.0 | — |
| id | String | An identifier that allows the component to be referenced by other components in the page. | | 14.0 | global |
| rendered | Boolean | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. | | 14.0 | global |
| showDetail | Boolean | A Boolean value that specifies whether to display the detail portion of the messages. If not specifed [sic] this value defaults to false. | | 14.0 | — |

**SEE ALSO:** `apex:pageMessage`

---

## 관련 노트

- [[버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트]] — `apex:component`/`apex:attribute`로 만드는 커스텀 Visualforce 컴포넌트 (이 노트의 `apex:attribute` 정의 태그와 짝)
- [[커스텀 컨트롤러·컨트롤러 확장]] — `apex:commandButton`/`apex:commandLink`의 `action`이 호출하는 컨트롤러 메서드
- [[표준 컨트롤러·표준 리스트 컨트롤러]] — `apex:inputField`/`apex:outputField`가 바인딩하는 sObject 필드와 `recordSetVar` 기반 폼
- [[페이지 출력 제어 — HTML·PDF·SLDS]] — 출력 컴포넌트 렌더링·escape·스타일 처리
- [[동적 Visualforce — 바인딩·동적 컴포넌트]] — `value="{!...}"` 표현식 바인딩과 동적 컴포넌트 생성
