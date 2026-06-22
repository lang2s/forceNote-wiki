---
tags: [visualforce, vf, global-variables, functions, operators, reference, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26)
created: 2026-06-21
aliases: [Visualforce Global Variables, $Action, $Resource, $ObjectType, VF 표현식 함수, VF 연산자, $User $Label]
---

# Visualforce Global Variables · 함수 · 표현식 연산자

> Visualforce 표현식 `{! }` 안에서 쓸 수 있는 전역 변수($User·$Action·$Resource 등), formula 함수(80개), 그리고 표현식 연산자를 한 곳에 정리한 레퍼런스. (Visualforce Developer Guide v67.0 Appendix A 전수)

> 레거시 안내: Visualforce는 Salesforce의 1세대 페이지 기술이다. 신규 UI 개발은 Lightning Web Components(LWC)/Aura가 표준이며, 본 노트는 기존 VF 페이지 유지보수와 formula/머지 필드 참조 목적의 레거시 레퍼런스다.

Visualforce 페이지는 formula와 동일한 표현식 언어를 쓴다. `{! }` 안의 모든 것은 현재 컨텍스트의 레코드 값에 접근할 수 있는 표현식으로 평가된다. 이 노트는 그 표현식에서 쓸 수 있는 **변수(Global Variables)**, **함수(Functions)**, **연산자(Operators)** 세 가지를 다룬다.

---

## PART 1 — Global Variables

전역 변수는 현재 사용자와 조직에 대한 일반 정보를 페이지에서 참조할 때 쓴다. 반드시 Visualforce 표현식 구문으로 참조해야 평가된다. 예: `{!$User.FirstName}`.

PDF Appendix A "IN THIS SECTION" 순서의 전역 변수 전체 목록(전수):

`$Action` · `$Api` · `$Asset` · `$Cache.Org` · `$Cache.Session` · `$Component` · `$ComponentLabel` · `$CurrentPage` · `$FieldSet` · `$Label` · `$Label.Site` · `$MessageChannel` · `$Network` · `$ObjectType` · `$Organization` · `$Page` · `$Permission` · `$Profile` · `$Resource` · `$SControl` · `$Setup` · `$Site` · `$System.OriginDateTime` · `$User` · `$User.UITheme and and $User.UIThemeDisplayed` [sic] · `$UserRole`

---

### $Action

표준 Salesforce 액션(계정 탭 홈 표시, 계정 생성/편집/삭제 등)을 참조하는 글로벌 머지 필드 타입.

**Usage:** Use dot notation to specify an object and an action, for example, `$Action.Account.New`

```html
<apex:outputLink value="{!URLFOR($Action.Account.New)}">
Create New Account
</apex:outputLink>
```

다음 마크업은 첨부파일 다운로드 링크를 추가한다.

```html
<apex:page standardController="Attachment">
<apex:outputLink
value="{!URLFOR($Action.Attachment.Download,
attachment.id)}">
Download Now!
</apex:outputLink>
</apex:page>
```

**SEE ALSO:** Dynamic References to Action Methods Using $Action

#### Valid Values for the $Action Global Variable

> 표 구조: **Value | Description | Objects** (3열). 아래는 PDF p.682–689 표를 셀별 재검증해 그대로 옮긴 것.

| Value | Description | Objects |
|---|---|---|
| Accept | Accept a record. | Ad group, Case, Event, Google campaign, Keyword, Lead, Search phrase, SFGA version, Text ad |
| Activate | Activate a contract. | Contract |
| Add | Add a product to a price book. | Product2 |
| AddCampaign | Add a member to a campaign. | Campaign |
| AddInfluence | Add a campaign to an opportunity's list of influential campaigns. | Opportunity |
| AddProduct | Add a product to price book. | OpportunityLineItem |
| AddToCampaign | Add a contact or lead to a campaign. | Contact, Lead |
| AddToOutlook | Add an event to Microsoft Outlook. | Event |
| AdvancedSetup | Launch campaign advanced setup. | Campaign |
| AltavistaNews | Launch www.altavista.com/news/. | Account, Lead |
| Cancel | Cancel an event. | Event |
| CaseSelect | Specify a case for a solution. | Solution |
| ChangeOwner | Change the owner of a record. | Account, Ad group, Campaign, Contact, Contract, Google campaign, Keyword, Opportunities, Search phrase, SFGA version, Text ad |
| ChangeStatus | Change the status of a case. | Case, Lead |
| ChoosePricebook | Choose the price book to use. | OpportunityLineItem |
| Clone | Clone a record. | Ad group, Asset, Campaign, Campaign member, Case, Contact, Contract, Event, Google campaign, Keyword, Lead, Opportunity, Product, Search phrase, SFGA version, Text ad, Custom objects |
| CloneAsChild | Create a related case with the details of a parent case. | Case |
| CloseCase | Close a case. | Case |
| Convert | Create a new account, contact, and opportunity using the information from a lead. | Lead |
| ConvertLead | Convert a lead to a campaign member. | Campaign Member |
| Create_Opportunity | Create an opportunity based on a campaign member. | Campaign Member |
| Decline | Decline an event. | Event |
| Delete | Delete a record. | Ad group, Asset, Campaign, Campaign member, Case, Contact, Contract, Event, Google campaign, Keyword, Lead, Opportunity, Opportunity product, Product, Search phrase, SFGA version, Solution, Task, Text ad, Custom objects |
| DeleteSeries | Delete a series of events or tasks. | Event, Task |
| DisableCustomerPortal | Disable a Customer Portal user. | Contact |
| DisableCustomerPortalAccount | Disable a Customer Portal account. | Account |
| DisablePartnerPortal | Disable a Partner Portal user. | Contact |
| DisablePartnerPortalAccount | Disable a Partner Portal account. | Account |
| Download | Download an attachment. | Attachment, Document |
| Edit | Edit a record. | Ad group, Asset, Campaign, Campaign member, Case, Contact, Contract, Event, Google campaign, Keyword, Lead, Opportunity, Opportunity product, Product, Search phrase, SFGA version, Solution, Task, Text ad, Custom objects |
| EditAllProduct | Edit all products in a price book. | OpportunityLineItem |
| EnableAsPartner | Designate an account as a partner account. | Account |
| EnablePartnerPortalUser | Enable a contact as a Partner Portal user. | Contact |
| EnableSelfService | Enable a contact as a Self-Service user. | Contact |
| FindDup | Display duplicate leads. | Lead |
| FollowupEvent | Create a follow-up event. | Event |
| FollowupTask | Create a follow-up task. | Event |
| HooversProfile | Display a Hoovers profile. | Account, Lead |
| IncludeOffline | Include an account record in Connect Offline. | Account |
| GoogleMaps | Plot an address on Google Maps. | Account, Contact, Lead |
| GoogleNews | Display www.google.com/news. | Account, Contact, Lead |
| GoogleSearch | Display www.google.com. | Account, Contact, Lead |
| List | List records of an object. | Ad group, Campaign, Case, Contact, Contract, Google campaign, Keyword, Lead, Opportunity, Product, Search phrase, SFGA version, Solution, Text ad, Custom objects |
| LogCall | Log a call. | Activity |
| MailMerge | Generate a mail merge. | Activity |
| ManageMembers | Launch the Manage Members page. | Campaign |
| MassClose | Close multiple cases. | Case |
| Merge | Merge contacts. | Contact |
| New | Create a new record. | Activity, Ad group, Asset, Campaign, Case, Contact, Contract, Event, Google campaign, Keyword, Lead, Opportunity, Search phrase, SFGA version, Solution, Task, Text ad, Custom objects |
| NewTask | Create a task. | Task |
| RequestUpdate | Request an update. | Contact, Activity |
| SelfServSelect | Register a user as a Self Service user. | Solution |
| SendEmail | Send an email. | Activity |
| SendGmail | Open a blank email in Gmail. | Contact, Lead |
| Sort | Sort products in a price book. | OpportunityLineItem |
| Share | Share a record. | Account, Ad group, Campaign, Case, Contact, Contract, Google campaign, Keyword, Lead, Opportunity, Search phrase, SFGA version, Text ad |
| Submit for Approval | Submit a record for approval. | Account, Activity, Ad group, Asset, Campaign, Campaign member, Case, Contact, Contract, Event, Google campaign, Keyword, Lead, Opportunity, Opportunity product, Product, Search phrase, SFGA version, Solution, Task, Text ad |
| Tab | Access the tab for an object. | Ad group, Campaign, Case, Contact, Contract, Google campaign, Keyword, Lead, Opportunity, Product, Search phrase, SFGA version, Solution, Text ad |
| View | View a record. | Activity, Ad group, Asset, Campaign, Campaign member, Case, Contact, Contract, Event, Google campaign, Keyword, Lead, Opportunity, Opportunity product, Product, Search phrase, SFGA version, Solution, Text ad, Custom objects |
| ViewAllCampaignMembers | List all campaign members. | Campaign |
| ViewCampaignInfluenceReport | Display the Campaigns with Influenced Opportunities report. | Campaign |
| ViewPartnerPortalUser | List all Partner Portal users. | Contact |
| ViewSelfService | List all Self-Service users. | Contact |
| YahooMaps | Plot an address on Yahoo! Maps. | Account, Contact, Lead |
| YahooWeather | Display http://weather.yahoo.com/. | Contact |

---

### $Api

API URL을 참조하는 글로벌 머지 필드 타입.

**Usage:** Use dot notation to specify an API URL from either the Enterprise or Partner WSDL, or to return the session ID.

> **Important:** `$Api.Session_ID` and `GETSESSIONID()` return the same value, an identifier for the current session in the current context. This context varies depending on where the global variable or function is evaluated. For example, if you use either in a custom formula field, and that field is displayed on a standard page layout in Salesforce Classic, the referenced session is a basic Salesforce session. That same field (or the underlying variable or formula result), when used in a Visualforce page, references a Visualforce session instead.
>
> Session contexts are based on the domain of the request. That is, the session context changes whenever you cross a hostname boundary, such as from .salesforce.com to .vf.force.com or .lightning.force.com.
>
> Session identifiers from different contexts, and the sessions themselves, are different. When you transition between contexts, the old session is replaced by the new one, and the old session is no longer valid. The session ID also changes at this time.
>
> Normally Salesforce transparently handles session hand-off between contexts, but if you're passing the session ID around yourself, you might need to re-access `$Api.Session_ID` or `GETSESSIONID()` from the new context to ensure a valid session ID.
>
> Not all sessions are created equal. In particular, sessions obtained in a Lightning Experience context have reduced privileges, and don't have API access. You can't use these session IDs to make API calls. `{!$Api.Session_ID}` isn't generated for guest users.
>
> If you use a JWT-based access token for session authentication, you can't use `$Api.Session_ID`. To use `$Api.Session_ID`, use an opaque access token instead. Make sure that the "Issue JSON Web Token (JWT)-based access tokens for named users" setting isn't selected for your external client app or connected app.

- `{!$Api.Enterprise_Server_URL__xxx}` — The Enterprise WSDL SOAP endpoint where xxx represents the version of the API. For example, `{!$Api.Enterprise_Server_URL_260}` is the expression for the endpoint for version 26.0 of the API.
- `{!$Api.Partner_Server_URL__xxx}` — The Partner WSDL SOAP endpoint where xxx represents the version of the API. `{!$Api.Partner_Server_URL_250}` is the expression for the endpoint for version 25.0 of the API.
- `{!$Api.Session_ID}` — The session ID.

---

### $Asset

Lightning Design System(SLDS)의 이미지·아이콘·아바타를 참조하는 글로벌 머지 필드.

**Usage:** In a Visualforce page that uses `<apex:slds>`, `$Asset.SLDS` allows you to use the images, icons, and avatars that are part of the Lightning Design System. Use the `URLFOR()` formula function to reference assets using `$Asset` with dot notation.

To use SVG icons, add the required XML namespaces by using `xmlns="http://www.w3.org/2000/svg"` and `xmlns:xlink="http://www.w3.org/1999/xlink"` in the html tag.

> **Note:** If you're using the Salesforce sidebar, header, or built-in style sheets, you can't add attributes to the html. VG icons are supported only if showHeader, standardStylesheets, and sidebar are set to false. [sic — "VG icons"]

아바타 참조 예제:

```html
<apex:page>
<apex:slds />
<span class="slds-icon_container slds-icon--small slds-icon-standard-account"
title="Contact Avatar">
<img src="{!URLFOR($Asset.SLDS, 'assets/images/profile_avatar_96.png')}" alt="Contact
Avatar" />
</span>
</apex:page>
```

SVG account icon 참조 예제:

```html
<apex:page>
<html xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
lang="en">
<apex:slds />
<span class="slds-icon_container slds-icon-standard-account">
<svg aria-hidden="true" class="slds-icon">
<use xlink:href="{!URLFOR($Asset.SLDS,
'assets/icons/standard-sprite/svg/symbols.svg#account')}"></use>
</svg>
<span class="slds-assistive-text">Account Icon</span>
</span>
</html>
</apex:page>
```

**SEE ALSO:** Using the Lightning Design System

---

### $Cache.Org

지정 파티션의 org 캐시에서 캐시된 값을 조회하는 글로벌 머지 필드.

**Usage:** Use `{!$Cache.Org}` to reference an existing org cache. An org cache consists of data that's shared across the org. Use dot notation to specify the namespace, partition name, or properties of a cached value.

```html
<apex:outputText value="{!$Cache.Org.myNamespace.myPartition.output}"/>
```

값이 프로퍼티/메서드를 가진 데이터 구조(Apex list, custom class 등)면 dot notation으로 접근한다. 다음은 `numbersList`가 List로 선언된 경우 `List.size()` Apex 메서드 호출 예제다.

```html
<apex:outputText value="{!$Cache.Org.myNamespace.myPartition.numbersList.size}"/>
```

CacheBuilder 사용 시, namespace·partition 이름에 더해 CacheBuilder 인터페이스 구현 클래스명과 리터럴 문자열 `_B_`로 키 이름을 한정한다(예시 클래스: `CacheBuilderImpl`).

```html
<apex:outputText value="{!$Cache.Org.myNamespace.myPartition.CacheBuilderImpl_B_key1}"/>
```

**SEE ALSO:** Cache.Org Class · Cache.CacheBuilder Interface

---

### $Cache.Session

지정 파티션의 session 캐시에서 캐시된 값을 조회하는 글로벌 머지 필드.

**Usage:** Use `{!$Cache.Session}` to reference an existing session cache. A session cache consists of cached data that can be reused from one session to the next. Use dot notation to specify the namespace, partition name, or properties of a cached value.

```html
<apex:outputText value="{!$Cache.Session.myNamespace.myPartition.output}"/>
```

```html
<apex:outputText value="{!$Cache.Session.myNamespace.myPartition.numbersList.size}"/>
```

```html
<apex:outputText value="{!$Cache.Session.myNamespace.myPartition.CacheBuilderImpl_B_key1}"/>
```

**SEE ALSO:** Cache.Session Class · Cache.CacheBuilder Interface

---

### $Component

Visualforce 컴포넌트를 참조하는 글로벌 머지 필드 타입.

**Usage:** Each component in a Visualforce page has its own Id attribute. When the page is rendered, this attribute is used to generate the Document Object Model (DOM) ID. Use `$Component.Path.to.Id` in JavaScript to reference a specific component on a page, where Path.to.Id is a component hierarchy specifier for the component being referenced.

`msgpost` 컴포넌트를 참조하는 JavaScript 예제:

```javascript
function beforeTextSave() {
document.getElementById('{!$Component.msgpost}').value =
myEditor.getEditorHTML();
}
```

해당 마크업:

```html
<apex:page>
<apex:outputText id="msgpost" value="Emacs"/> is great.
</apex:page>
```

중첩(nested) 컴포넌트의 경우 더 완전한 경로 지정자를 사용한다.

```html
<apex:page>
<apex:pageBlock id="theBlock">
<apex:pageBlockSection id="theSection" columns="1">
<apex:pageBlockSectionItem id="theSectionItem">
<apex:outputText id="theText">
Heya!
</apex:outputText>
</apex:pageBlockSectionItem>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:page>
```

함수에서 참조:

```javascript
document.getElementById(
"{!$Component.theBlock.theSection.theSectionItem.theText}")
```

**SEE ALSO:** Using $Component to Reference Components from JavaScript · Best Practices for Accessing Component IDs

---

### $ComponentLabel

message와 연결된 inputField 컴포넌트의 label을 참조하는 글로벌 머지 필드.

**Usage:** Return the label of an inputField component that is associated with a message.

```html
<apex:datalist var="mess" value="{!messages}">
<apex:outputText value="{!mess.componentLabel}:" style="color:red"/>
<apex:outputText value="{!mess.detail}" style="color:black" />
</apex:datalist>
```

---

### $CurrentPage

현재 Visualforce 페이지/페이지 요청을 참조하는 글로벌 머지 필드 타입.

**Usage:** Use this global variable in a Visualforce page to reference the current page name (`$CurrentPage.Name`) or the URL of the current page (`$CurrentPage.URL`). Use `$CurrentPage.parameters.parameterName` to reference page-request parameters and values, where parameterName is the request parameter being referenced. parameterName isn't case-sensitive.

```html
<apex:page standardController="Account">
<apex:pageBlock title="Hello {!$User.FirstName}!">
You belong to the {!account.name} account.<br/>
You're also a nice person.
</apex:pageBlock>
<apex:detail subject="{!account}" relatedList="false"/>
<apex:relatedList list="OpenActivities"
subject="{!$CurrentPage.parameters.relatedId}"/>
</apex:page>
```

**SEE ALSO:** Getting Query String Parameters

---

### $FieldSet

org에 정의된 field set에 대한 접근을 제공한다.

**Usage:** Use this in your Visualforce pages to dynamically iterate over fields in a field set. You must prefix this global variable with a reference to the standard or custom object that has the field set.

```html
<apex:page standardController="Account">
<apex:repeat value="{!$ObjectType.Account.FieldSets.myFieldSetName}" var="field">
<apex:outputText value="{!field}" />
</apex:repeat>
</apex:page>
```

---

### $Label

커스텀 레이블을 참조하는 글로벌 머지 필드 타입.

**Usage:** Use this expression in a Visualforce page to access a custom label. The returned value depends on the language setting of the contextual user. The value returned is one of the following, in order of precedence:

> (참고: PDF 본문에서 precedence 리스트가 본문에 이어지지 않고 바로 Example로 넘어간다 — 원문 그대로. 리스트 항목이 텍스트로 추출되지 않음.)

```html
<apex:page>
<apex:pageMessage severity="info"
strength="1"
summary="{!$Label.firstrun_helptext}"
/>
</apex:page>
```

**SEE ALSO:** Salesforce Help: Custom Labels

---

### $Label.Site

Visualforce 페이지에서 표준 Sites label을 참조하는 글로벌 머지 필드 타입. 모든 표준 label처럼 사용자 언어/로케일에 따라 message가 표시된다. 표준 Sites label의 message는 수정할 수 없다. 커스텀 message가 필요하면 custom label을 만들어 `$Label`로 참조한다.

**Usage:** Use this expression in a Visualforce page to access a standard Sites label. When the application server constructs the page to be presented to the end-user's browser, the value returned depends on the language and locale of the user.

```html
<apex:page>
<apex:pageMessage severity="info"
strength="1"
summary="{!$Label.Site.temp_password_sent}"
/>
</apex:page>
```

---

### $MessageChannel

org에 정의된 message channel에 대한 접근을 제공하는 글로벌 머지 필드 타입.

**Usage:** Use this expression in your Visualforce page to access a message channel and use the Lightning Message Service APIs.

```html
<apex:page>
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

---

### $Network

Visualforce 이메일 템플릿에서 Experience Cloud site 정보를 참조하는 글로벌 머지 필드 타입.

**Usage:** Use dot notation to access your Experience Cloud site's name and login page URL. The login page URL depends on whether the site uses the standard or a custom login page.

> **Note:** The `$Network` global merge field type works only in the context of Visualforce emails for Experience Cloud sites.
>
> For more flexibility, you can create custom Experience Cloud site email templates in Visualforce. For a Visualforce email template, use the `$Network` global merge field type and its properties, as described in this table. These fields are populated only in Visualforce Experience Cloud site email templates.

| Field Name | Description |
|---|---|
| `$Network.ActionForVerificationEmail` | Used in one-time password (OTP) and device activation emails to specify the action that prompted sending a verification email. |
| `$Network.AsyncVerificationLink` | Used in asynchronous emails to send a verification link (URL) to users. Users click the link to verify their email address with Salesforce. After verifying their email address, external users can log in with a one-time password (OTP) via email (passwordless login). |
| `$Network.BrowserForVerificationEmail` | Used in OTP and device activation emails to specify the browser where the action occurred that prompted sending a verification email. |
| `$Network.CodeForVerificationEmail` | The verification code sent in the OTP or device activation email. |
| `$Network.ChgEmailVerOldEmail` | The user's old email address, when they change it. |
| `$Network.ChgEmailVerNewEmail` | The user's new email address, when they change it. |
| `$Network.ChgEmailVerLink` | The link, sent to the user's new email address, that the user follows to verify their email address change. |
| `$Network.Name` | The name of the Experience Cloud site. |
| `$Network.NetworkUrlForUserEmails` | The URL to the login page of the Experience Cloud site, for example, `https://MyDomainName.my.site.com/partners/login`. If this merge field is in the welcome email to new members, the URL is appended with a link to a reset password page. |
| `$Network.OperatingSystemForVerificationEmail` | Used in OTP and device activation emails to specify the operating system where the action occurred that prompted sending a verification email. |
| `$Network.passwordLockTime` OR `{!PASSWORD_LOCK_TIME}` | Used in the formula field for lockout emails to specify how long a user must wait until logging in again after being locked out. |

```
{!$Network.Name}
{!$Network.NetworkUrlForUserEmails}
```

---

### $ObjectType

표준/커스텀 오브젝트와 그 필드 값을 참조하는 글로벌 머지 필드 타입.

**Usage:** Use dot notation to specify an object, such as `{!$ObjectType.Case}`. Optionally, select a field on that object using the following syntax: `{!$ObjectType.Role_Limit__c.Fields.Limit__c}`.

Account Name 필드 label 조회 예제:

```
{!$ObjectType.Account.Fields.Name.Label}
```

dynamic reference로도 정보를 조회할 수 있다.

```
{!$ObjectType.Account.Fields['Name'].Type}
```

**SEE ALSO:** Dynamic References to Schema Details Using $ObjectType

#### Object Schema Details Available Using $ObjectType

> "The information available using $ObjectType is a subset of the information available using the Apex describe result, the DescribeSObjectResult system object."

| Name | Data Type | Description |
|---|---|---|
| fields | Special | This attribute can't be used by itself. Instead, fields should be followed by a field member variable name, and then a field attribute. For example, `{!$ObjectType.Account.fields.Name.Label}` |
| fieldSets | Special | This attribute can't be used by itself. Instead, fieldSets should be followed by a field set name, and used in an iteration component. For example, `<apex:repeat value="{!$ObjectType.Contact.FieldSets.properNames}" var="f">` |
| keyPrefix | String | The three-character prefix code for the object. Record IDs are prefixed with three-character codes that specify the object type. For example, accounts have a prefix of 001 and opportunities have a prefix of 006). $ObjectType returns a value for objects that have a stable prefix. For object types that don't have a stable or predictable prefix, this field is blank. Pages that rely on these codes can use this way of determining object types to ensure forward compatibility. |
| label | String | The object's label, which often matches the object name. For example, an organization in the medical industry might change the label for Account to Patient. This label matches the one used in the Salesforce user interface. |
| labelPlural | String | The object's plural label, which often matches the object name. For example, an organization in the medical industry might change the plural label for Account to Patients. This label matches the one used in the Salesforce user interface. |
| name | String | The name of the object. |
| accessible | Boolean | true if the current user can see this object, false otherwise. |
| createable | Boolean | true if the object can be created by the current user, false otherwise. |
| custom | Boolean | true if the object is a custom object, false if it's a standard object. |
| deletable | Boolean | true if the object can be deleted by the current user, false otherwise. |
| mergeable | Boolean | true if the object can be merged with other objects of its type by the current user, false otherwise. |
| queryable | Boolean | true if the object can be queried by the current user, false otherwise |
| searchable | Boolean | true if the object can be searched by the current user, false otherwise. |
| undeletable | Boolean | true if the object can't be undeleted by the current user, false otherwise. |
| updateable | Boolean | true if the object can be updated by the current user, false otherwise. |

#### Field Schema Details Available Using $ObjectType

> **Important:** Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.
>
> "The information available using $ObjectType parallels but is a subset of the details available using the Apex describe result, the DescribeFieldResult object."

| Name | Data Type | Description |
|---|---|---|
| byteLength | Integer | For variable-length fields (including binary fields), the maximum size of the field, in bytes. |
| calculatedFormula | String | The formula specified for this field. |
| controller | Schema.sObjectField (as a string) | The controlling field, if this is a dependent field. |
| defaultValueFormula | String | The default value specified for this field if a formula isn't used. |
| digits | Integer | The maximum number of digits specified for the field, or zero for non-numeric fields. |
| inlineHelpText | String | The content of the field-level help. |
| label | String | The text label that's displayed next to the field in the Salesforce user interface. This label can be localized. |
| length | Integer | For string fields, the maximum size of the field in Unicode characters (not bytes). |
| localName | String | The name of the field. |
| name | String | The field name used in Apex. |
| picklistValues | List <Schema.PicklistEntry> | A list of the field's picklist items, or an empty list if the field is not a picklist. |
| precision | Integer | For fields of type Double, the maximum number of digits that can be stored, including all numbers to the left and to the right of the decimal point (but excluding the decimal point character). |
| referenceTo | List <Schema.sObjectType> | A list of the parent objects of this field. If the namePointing attribute is true, there's more than one entry in the list, otherwise there's only one. |
| relationshipName | String | The name of the relationship. For more information about relationships and relationship names, see Understanding Relationship Names in the SOQL and SOSL Reference. |
| relationshipOrder | Integer | This attribute is 1 if the field is a child, 0 otherwise. For more information about relationships and relationship names, see Understanding Relationship Names in the SOQL and SOSL Reference. |
| scale | Integer | For fields of type Double, the number of digits to the right of the decimal point. Any extra digits to the right of the decimal point are truncated. |
| soapType | Schema.SOAPType (as a string) | One of the SoapType enum values, depending on the type of field. For more information, see SOAPType Enum in the Apex Developer Guide. |
| sObjectField | Schema.sObjectField (as a string) | A reference to this field. |
| type | Schema.DisplayType (as a string) | One of the DisplayType enum values, depending on the type of field. For more information, see DisplayType Enum in the Apex Developer Guide. |
| accessible | Boolean | true if the current user can see this field, false otherwise. |
| autoNumber | Boolean | true if the field is an Auto Number field, false otherwise. |
| calculated | Boolean | true if the field is a custom formula field, false otherwise. |
| cascadeDelete | Boolean | true if the child object is deleted when the parent object is deleted, false otherwise. |
| caseSensitive | Boolean | true if the field is case sensitive, false otherwise. |
| createable | Boolean | true if the field can be created by the current user, false otherwise. |
| custom | Boolean | true if the field is a custom field, false if it's a standard object. |
| defaultedOnCreate | Boolean | true if the field receives a default value when created, false otherwise. |
| dependentPicklist | Boolean | true if the picklist is a dependent picklist, false otherwise. |
| externalId | Boolean | true if the field is used as an external ID, false otherwise. |
| filterable | Boolean | true if the field can be used as part of the filter criteria of a WHERE statement, false otherwise. |
| groupable | Boolean | true if the field can be included in the GROUP BY clause of a SOQL query, false otherwise. |
| htmlFormatted | Boolean | true if the field has been formatted for HTML and should be encoded for display in HTML, false otherwise. One example of a field that is true for this attribute is a hyperlink custom formula field. Another example is a custom formula field that has an IMAGE text function. |
| idLookup | Boolean | true if the field can be used to specify a record in an upsert method, false otherwise. |
| nameField | Boolean | true if the field is a name field, false otherwise. This method is used to identify the name field for standard objects (such as AccountName for an Account object) and custom objects. Objects can only have one name field, except where the FirstName and LastName fields are used instead (such as on the Contact object). |
| namePointing | Boolean | true if the field can have multiple types of objects as parents. For example, a task can have both the Contact/Lead ID (WhoId) field and the Opportunity/Account ID (WhatId) field be true for this attribute because either of those objects can be the parent of a particular task record. This attribute is false otherwise. |
| nillable | Boolean | true if the field is nillable, false otherwise. |
| permissionable | Boolean | true if field permissions can be specified for the field, false otherwise. |
| restrictedDelete | Boolean | true if the parent object can't be deleted because it's referenced by a child object, false otherwise. |
| restrictedPicklist | Boolean | true if the field is a restricted picklist, false otherwise. |
| sortable | Boolean | true if a query can sort on the field, false otherwise. |
| unique | Boolean | true if the value for the field must be unique, false otherwise. |
| updateable | Boolean | true if: • The field can be edited by the current user, or • Child records in a master-detail relationship field on a custom object can be reparented to different parent records — false otherwise. |
| writeRequiresMasterRead | Boolean | true if writing to the detail object requires read sharing instead of read/write sharing of the parent. |

**SEE ALSO:** Dynamic References to Schema Details Using $ObjectType

---

### $Organization

회사 프로필(company profile) 정보를 참조하는 글로벌 머지 필드 타입. 조직의 city, fax, ID 등을 참조한다.

**Usage:** Use dot notation to access your organization's information. For example:

```
{!$Organization.Street}
{!$Organization.State}
```

> The organization merge fields get their values from whatever values are currently stored as part of your company information in Salesforce. Note that `{!$Organization.UiSkin}` is a picklist value, and so should be used with picklist functions such as `ISPICKVAL()` in custom fields, validation rules, Visualforce expressions, flow formulas, process formulas, and workflow rule formulas.

접근 가능한 값:

```
{!$Organization.Id}
{!$Organization.Name}
{!$Organization.Division}
{!$Organization.Street}
{!$Organization.City}
{!$Organization.State}
{!$Organization.PostalCode}
{!$Organization.Country}
{!$Organization.Fax}
{!$Organization.Phone}
{!$Organization.GoogleAppsDomain}
{!$Organization.UiSkin}
```

---

### $Page

Visualforce 페이지를 참조하는 글로벌 머지 필드 타입.

**Usage:** Use this expression in a Visualforce page to link to another Visualforce page.

```html
<apex:page>
<h1>Linked</h1>
<apex:outputLink value="{!$Page.otherPage}">
This is a link to another page.
</apex:outputLink>
</apex:page>
```

---

### $Permission

현재 사용자의 custom permission 접근 정보를 참조하는 글로벌 머지 필드 타입.

**Usage:**
1. Select the field type: `$Permission`.
2. Select a merge field such as `$Permission.customPermissionName`.

custom permission `seeExecutiveData` 보유자에게만 pageblock을 표시하는 예제:

```html
<apex:pageBlock rendered="{!$Permission.seeExecutiveData}">
<!-- Executive Data Here -->
</apex:pageBlock>
```

> **Note:** `$Permission` appears only if custom permissions have been created in your organization. For more information, see Custom Permissions.

---

### $Profile

현재 사용자의 profile 정보(license type, name 등)를 참조하는 글로벌 머지 필드 타입.

**Usage:** Use dot notation to access your organization's information.

> Note that you can't use the following `$Profile` values in Visualforce:
> - LicenseType
> - UserType

```
{!$Profile.Id}
{!$Profile.Name}
```

---

### $Resource

기존 static resource를 이름으로 참조하는 글로벌 머지 필드 타입. URLFOR 함수와 함께 쓰면 static resource archive 내 특정 파일도 참조할 수 있다.

**Usage:** Use `{!$Resource}` to reference an existing static resource. The format is `{!$Resource.nameOfResource}`, such as `{!$Resource.TestImage}`.

`TestImage`라는 이름으로 업로드된 이미지 참조:

```html
<apex:image url="{!$Resource.TestImage}" width="50" height="50"/>
```

archive(.zip/.jar) 내 파일 참조 — URLFOR 사용:

```html
<apex:image url="{!URLFOR($Resource.TestZip,
'images/Bluehills.jpg')}" width="50" height="50"/>
```

dynamic reference로도 참조할 수 있다: `{!$Resource[appLogo]}` (페이지 컨트롤러에 `appLogo` 프로퍼티 또는 `getAppLogo()` 메서드가 있다고 가정).

**SEE ALSO:** Styling Visualforce Pages

---

### $SControl

기존 custom s-control을 이름으로 참조하는 글로벌 머지 필드 타입. s-control이 실행되는 페이지의 URL을 반환한다.

> **Important:** Visualforce pages supersede s-controls. Organizations that haven't previously used s-controls can't create them. Existing s-controls are unaffected and can still be edited.

**Usage:** Use dot notation to access an existing s-control by its name.

`HelloWorld` s-control 링크 예제:

```html
<apex:page>
<apex:outputLink
value="{!$SControl.HelloWorld}">Open the HelloWorld s-control</apex:outputLink>
</apex:page>
```

> Note that if you simply want to embed an s-control in a page, you can use the `<apex:scontrol>` tag without the `$SControl` merge field. For example:

```html
<apex:page>
<apex:scontrol controlName="HelloWorld" />
</apex:page>
```

---

### $Setup

"hierarchy" 타입 custom setting을 참조하는 글로벌 머지 필드 타입.

**Usage:** Use `$Setup` to access hierarchical custom settings and their field values using dot notation. For example, `$Setup.App_Prefs__c.Show_Help_Content__c`.

Hierarchical custom settings allow values at any of three different levels:
1. Organization, the default value for everyone
2. Profile, which overrides the Organization value
3. User, which overrides both Organization and Profile values

> Salesforce automatically determines the correct value for this custom setting field based on the running user's current context.
>
> Custom settings of type "list" aren't available on Visualforce pages using this global variable. You can access list custom settings in Apex.

```html
<apex:page>
<apex:inputField value="{!usr.Workstation_Height__c}"/>
<apex:outputPanel id="helpWorkstationHeight"
rendered="{!$Setup.App_Prefs__c.Show_Help_Content__c}">
Enter the height for your workstation in inches, measured from the
floor to top of the work surface.
</apex:outputPanel>
...
</apex:page>
```

> If the organization level for the custom setting is set to true, users see the extended help message by default. If an individual prefers to not see the help messages, they can set their custom setting to false, to override the organization (or profile) value.

---

### $Site

현재 Salesforce site 정보를 참조하는 글로벌 머지 필드 타입.

**Usage:** Use dot notation to access information about the current Salesforce site. Note that only the following site fields are available:

| Merge Field | Description |
|---|---|
| `$Site.Name` | Returns the API name of the current site. |
| `$Site.Domain` | Returns your Salesforce Sites based URL. |
| `$Site.CustomWebAddress` | Returns the request's custom URL if it doesn't end in force.com or returns the site's primary custom URL. If neither exist, then this returns an empty string. Note that the URL's path is always the root, even if the request's custom URL has a path prefix. If the current request is not a site request, then this field returns an empty string. This field's value always ends with a / character. Use of `$Site.CustomWebAddress` is discouraged and we recommend using `$Site.BaseCustomUrl` instead. |
| `$Site.OriginalUrl` | Returns the original URL for this page if it's a designated error page for the site; otherwise, returns null. |
| `$Site.CurrentSiteUrl` | Returns the base URL of the current site that references and links should use. Note that this field might return the referring page's URL instead of the current request's URL. This field's value includes a path prefix and always ends with a / character. If the current request is not a site request, then this field returns an empty string. Use of `$Site.CurrentSiteUrl` is discouraged. Use `$Site.BaseUrl` instead. |
| `$Site.LoginEnabled` | Returns true if the current site is associated with an active login-enabled portal; otherwise returns false. |
| `$Site.RegistrationEnabled` | Returns true if the current site is associated with an active self-registration-enabled Customer Portal; otherwise returns false. |
| `$Site.IsPasswordExpired` | For authenticated users, returns true if the currently logged-in user's password is expired. For non-authenticated users, returns false. |
| `$Site.AdminEmailAddress` | Returns an empty string. This merge field is deprecated. |
| `$Site.Prefix` | Returns the URL path prefix of the current site. For example, if your site URL is MyDomainName.my.salesforce-sites.com/partners, /partners is the path prefix. Returns null if the prefix isn't defined. If the current request is not a site request, then this field returns an empty string. |
| `$Site.Template` | Returns the template name associated with the current site; returns the default template if no template has been designated. |
| `$Site.ErrorMessage` | Returns an error message for the current page if it's a designated error page for the site and an error exists; otherwise, returns an empty string. |
| `$Site.ErrorDescription` | Returns the error description for the current page if it's a designated error page for the site and an error exists; otherwise, returns an empty string. |
| `$Site.AnalyticsTrackingCode` | The tracking code associated with your site. Services such as Google Analytics can use this code to track page request data for your site. |
| `$Site.BaseCustomUrl` | Returns a base URL for the current site that doesn't use a subdomain. The returned URL uses the same protocol (HTTP or HTTPS) as the current request if at least one non-force.com custom URL that supports HTTPS exists on the site. The returned value never ends with a / character. If all the custom URLs in this site end in force.com or salesforce-sites.com, or this site has no custom URLs, then this returns an empty string. If the current request is not a site request, then this method returns an empty string. This field replaces CustomWebAddress and includes the custom URL's path prefix. |
| `$Site.BaseInsecureUrl` | This merge field is deprecated. Returns a base URL for the current site that uses HTTP instead of HTTPS. The current request's domain is used. The returned value includes the path prefix and never ends with a / character. If the current request is not a site request, then this method returns an empty string |
| `$Site.BaseRequestUrl` | Returns the base URL of the current site for the requested URL. This isn't influenced by the referring page's URL. The returned URL uses the same protocol (HTTP or HTTPS) as the current request. The returned value includes the path prefix and never ends with a / character. If the current request is not a site request, then this method returns an empty string. |
| `$Site.BaseSecureUrl` | Returns a base URL for the current site that uses HTTPS instead of HTTP. The current request's domain is preferred if it supports HTTPS. Domains that are not force.com subdomains are preferred over force.com subdomains. A force.com subdomain, if associated with the site, is used if no other HTTPS domains exist in the current site. If there are no HTTPS custom URLs in the site, then this method returns an empty string. The returned value includes the path prefix and never ends with a / character. If the current request is not a site request, then this method returns an empty string. |
| `$Site.BaseUrl` | Returns the base URL of the current site that references and links should use. Note that this field may return the referring page's URL instead of the current request's URL. This field's value includes the path prefix and never ends with a / character. If the current request is not a site request, then this field returns an empty string. This field replaces `$Site.CurrentSiteUrl`. |
| `$Site.MasterLabel` | Returns the value of the Master Label field for the current site. If the current request is not a site request, then this field returns an empty string. |
| `$Site.SiteId` | Returns the ID of the current site. If the current request is not a site request, then this field returns an empty string. |
| `$Site.SiteType` | Returns the API value of the Site Type field for the current site. If the current request is not a site request, then this field returns an empty string. |
| `$Site.SiteTypeLabel` | Returns the value of the Site Type field's label for the current site. If the current request is not a site request, then this field returns an empty string. |

`$Site.Template` 사용 예제:

```html
<apex:page title="Job Application Confirmation" showHeader="false"
standardStylesheets="true">
<!-- The site template provides layout & style for the site -->
<apex:composition template="{!$Site.Template}">
<apex:define name="body">
<apex:form>
<apex:commandLink value="<- Back to Job Search"
onclick="window.top.location='{!$Page.PublicJobs}';return false;"/>
<br/>
<br/>
<center>
<apex:outputText value="Your application has been saved.
Thank you for your interest!"/>
</center>
<br/>
<br/>
</apex:form>
</apex:define>
</apex:composition>
</apex:page>
```

---

### $System.OriginDateTime

리터럴 값 1900-01-01 00:00:00을 나타내는 글로벌 머지 필드.

**Usage:** Use this global variable when performing date/time offset calculations, or to assign a literal value to a date/time field.

1900년 1월 1일 이후 경과 일수 계산 예제:

```
{!NOW() - $System.OriginDateTime}
```

---

### $User

현재 사용자 정보(alias, title, ID 등)를 참조하는 글로벌 머지 필드 타입. "Most of the fields available on the User standard object are also available on $User."

**Usage:** Use dot notation to access the current user's information. For example:

```
{!IF (CONTAINS($User.Alias, Smith) True, False)}
```

회사명과 active 상태(Boolean)를 표시하는 예제:

```html
<apex:page>
<h1>Congratulations</h1>
This is your new Apex Page
<p>The current company name for this
user is: {!$User.CompanyName}</p>
<p>Is the user active?
{!$User.isActive}</p>
</apex:page>
```

---

### $User.UITheme and and $User.UIThemeDisplayed [sic — "and"가 두 번]

사용자가 보는 Salesforce look and feel을 식별한다.

> The difference between the two variables is that `$User.UITheme` returns the look and feel the user is supposed to see, while `$User.UIThemeDisplayed` returns the look and feel the user actually sees. For example, a user can have the preference and permissions to see the Lightning Experience look and feel, but if they're using a browser that doesn't support that look and feel, for example, older versions of Internet Explorer, `$User.UIThemeDisplayed` returns a different value.

**Usage:** Use these variables to identify the CSS used to render Salesforce web pages to a user. Both variables return one of the following values. Valid values include:

- **Theme1** — Obsolete Salesforce theme
- **Theme2** — Salesforce Classic 2005 user interface theme
- **Theme3** — Salesforce Classic 2010 user interface theme
- **Theme4d** — Modern "Lightning Experience" Salesforce theme
- **Theme4t** — Salesforce mobile app theme
- **Theme4u** — Lightning Console theme
- **PortalDefault** — Salesforce Customer Portal theme that applies to Customer Portals only and not to Experience Builder sites
- **Webstore** — AppExchange theme

테마 기반 레이아웃 렌더링 예제:

```html
<apex:page>
<apex:pageBlock title="My Content" rendered="{!$User.UITheme == 'Theme2'}">
// this is the old theme...
</apex:pageBlock>
<apex:pageBlock title="My Content" rendered="{!$User.UITheme == 'Theme3'}">
// this is the classic theme ...
</apex:pageBlock>
</apex:page>
```

---

### $UserRole

현재 사용자의 role 정보(role name, description, ID 등)를 참조하는 글로벌 머지 필드 타입.

**Usage:** Use dot notation to access information about the current user's role.

> Note that you can't use the following `$UserRole` values in Visualforce:
> - CaseAccessForAccountOwner
> - ContactAccessForAccountOwner
> - OpportunityAccessForAccountOwner
> - PortalType

```
{!$UserRole.LastModifiedById}
```

---

## PART 2 — Functions

함수는 레코드 데이터를 변환하거나, 계산을 수행하거나, Visualforce 속성에 값을 제공할 때 쓴다. 함수는 평가되려면 Visualforce 표현식 안에서 사용해야 한다.

> **Note:** Within an email template, merge fields can only be used in formula functions and operations when the merge field belongs to the record the email will be related to, otherwise these fields won't resolve.

함수는 5개 카테고리(Date and Time, Logical, Math, Text, Advanced)로 나뉜다.

### 2-1. Date and Time Functions

> **Note:** The date/time data type might not evaluate correctly in formula expressions for Visualforce pages with an API version less than 20.0. It may be incorrectly interpreted as just a date type.

| Function | Description | Use |
|---|---|---|
| ADDMONTHS | Returns the date that is the indicated number of months before or after a specified date. If the specified date is the last day of the month, the resulting date is the last day of the resulting month. Otherwise, the result has the same date component as the specified date. | `ADDMONTHS(date, num)` and replace date with the start date and num with the number of months to be added. |
| DATE | Returns a date value from year, month, and day values you enter. Salesforce displays an error on the detail page if the value of the DATE function in a formula field is an invalid date, such as February 29 in a non-leap year. | `DATE(year,month,day)` and replace year with a four-digit year, month with a two-digit month, and day with a two-digit day. |
| DATEVALUE | Returns a date value for a date/time or text expression. | `DATEVALUE(expression)` and replace expression with a date/time or text value, merge field, or expression. |
| DATETIMEVALUE | Returns a year, month, day, and GMT time value. | `DATETIMEVALUE(expression)` and replace expression with a date/time or text value, merge field, or expression. |
| DAY | Returns a day of the month in the form of a number between 1 and 31. | `DAY(date)` and replace date with a date field or value such as TODAY(). |
| HOUR | Returns the local time hour value without the date in the form of a number from 1 through 24. | `HOUR(time)` and replace time with a time value or value such as TIMENOW(). |
| MILLISECOND | Returns a milliseconds value in the form of a number from 0 through 999. | `MILLISECOND(time)` and replace time with a time value or value such as TIMENOW(). |
| MINUTE | Returns a minute value in the form of a number from 0 through 60. | `MINUTE(time)` and replace time with a time value or value such as TIMENOW(). |
| MONTH | Returns the month, a number between 1 (January) and 12 (December) in number format of a given date. | `MONTH(date)` and replace date with the field or expression for the date containing the month you want returned. |
| NOW | Returns a date/time representing the current moment. The NOW function returns the current date and time in the GMT timezone. (예: `Today's date and time is: {!NOW()}` → `Today's date and time is: Mon Jul 21 16:12:10 GMT 2008`) **Tips:** • Don't remove the parentheses. • Keep the parentheses empty. They do not need to contain a value. • Use addition or subtraction operators and a number with a NOW function to return a different date and time. For example `{!NOW() +5}` calculates the date and time five days ahead of now. • If you prefer to use a date time field, use TODAY. | `NOW()` |
| SECOND | Returns a seconds value in the form of a number from 0 through 60. | `SECOND(time)` and replace time with a time value or value such as TIMENOW(). |
| TIMENOW | Returns a time value in GMT representing the current moment. Use this function instead of the NOW function if you only want to track time, without a date. | `TIMENOW()` |
| TIMEVALUE | Returns the local time value without the date, such as business hours. | `TIMEVALUE(value)` and replace value with a date/time or text value, merge field, or expression. |
| TODAY | Returns the current date as a date data type. The TODAY function returns the current day. (예: `Today's date is: {!TODAY()}` → `Today's date is: Mon Jul 21 00:00:00 GMT 2008`) **Tips:** • Do not remove the parentheses. • Keep the parentheses empty. They do not need to contain a value. • Use addition and subtraction operators with a TODAY function and numbers to return a date. For example `{!TODAY() +7}` calculates the date seven days ahead of now. • If you prefer to use a date time field, use NOW. | `TODAY()` |
| WEEKDAY | Returns the day of the week for the given date, using 1 for Sunday, 2 for Monday, through 7 for Saturday. | `WEEKDAY(date)` |
| YEAR | Returns the four-digit year in number format of a given date. | `YEAR(date)` and replace date with the field or expression that contains the year you want returned. |

### 2-2. Logical Functions

| Function | Description | Use |
|---|---|---|
| AND | Returns a TRUE response if all values are true; returns a FALSE response if one or more values are false. (예: `{!IF(AND(Price < 1, Quantity < 1), "Small", null)}` displays "Small" if price and quantity are less than one.) You can use `&&` instead of the word AND in your Visualforce markup. For example, `AND(Price < 1, Quantity < 1)` is the same as `(Price < 1) && (Quantity < 1)`. • Make sure the value_if_true and value_if_false expressions have the same data type. | `AND(logical1,logical2,...)` and replace logical1,logical2,... with the values that you want evaluated. |
| BLANKVALUE | Determines if an expression has a value and returns a substitute expression if it doesn't. If the expression has a value, returns the value of the expression. | `BLANKVALUE(expression, substitute_expression)` and replace expression with the expression you want evaluated; replace substitute_expression with the value you want to replace any blank values. |
| CASE | Checks a given expression against a series of values. If the expression is equal to a value, returns the corresponding result. If it isn't equal to any values, it returns the else_result. | `CASE(expression,value1, result1, value2, result2,..., else_result)` and replace expression with the field or value you want compared to each specified value. Replace each value and result with the value that must be equivalent to return the result entry. Replace else_result with the value you want returned when the expression doesn't equal any values. |
| IF | Determines if expressions are true or false. Returns a given value if true and another value if false. (예: `{!IF(opportunity.IsPrivate, "Private", "Not Private")}` returns "Private" if the opportunity IsPrivate field is set to true; "Not Private" if false.) | `IF(logical_test, value_if_true, value_if_false)` and replace logical_test with the expression you want evaluated; replace value_if_true with the value you want returned if the expression is true; replace value_if_false with the value you want returned if the expression is false. |
| ISBLANK | Determines if an expression has a value and returns TRUE if it does not. If it contains a value, this function returns FALSE. | `ISBLANK(expression)` and replace expression with the expression you want evaluated. |
| ISCLONE | Checks if the record is a clone of another record and returns TRUE if one item is a clone. Otherwise, returns FALSE. | `ISCLONE()` |
| ISNEW | Checks if the formula is running during the creation of a new record and returns TRUE if it is. If an existing record is being updated, this function returns FALSE. | `ISNEW()` |
| ISNULL | Determines if an expression is null (blank) and returns TRUE if it is. If it contains a value, this function returns FALSE. | `(IF(ISNULL(Maint_Amount__c), 0, 1) + IF(ISNULL(Services_Amount__c), 0,1) + IF(ISNULL(Discount_Percent__c), 0, 1) + IF(ISNULL(Amount), 0, 1) + IF(ISNULL(Timeline__c), 0, 1)) / 5` |
| ISNUMBER | Determines if a text value is a number and returns TRUE if it is. Otherwise, it returns FALSE. | `ISNUMBER(text)` and replace text with the merge field name for the text field. |
| NOT | Returns FALSE for TRUE and TRUE for FALSE. (예: `{!IF(NOT(Account.IsActive)ReportAcct, SaveAcct)}` returns ReportAcct if IsActive is false, SaveAcct if true.) You can use `!` instead of the word NOT in your Visualforce markup. For example, `NOT(Account.IsActive)` is the same as `!Account.IsActive)`. | `NOT(logical)` and replace logical with the expression that you want evaluated. |
| NULLVALUE | Determines if an expression is null (blank) and returns a substitute expression if it is. If the expression is not blank, returns the value of the expression. | `NULLVALUE(expression, substitute_expression)` and replace expression with the expression you want to evaluate; replace substitute_expression with the value you want to replace any blank values. |
| OR | Determines if expressions are true or false. Returns TRUE if any expression is true. Returns FALSE if all expressions are false. (예: `{!IF(OR(Account.IsActive__c, Account.IsNew__C)) VerifyAcct, CloseAcct)}` returns VerifyAcct if either IsActive__c or IsNew__c is true.) You can use `||` instead of the word OR in your Visualforce markup. For example, `OR(Price < 1, Quantity < 1)` is the same as `((Price < 1) || (Quantity < 1))`. | `OR(logical1, logical2...)` and replace any number of logical references with the expressions you want evaluated. |
| PRIORVALUE | Returns the previous value of a field. | `PRIORVALUE(field)` |

### 2-3. Math Functions

| Function | Description | Use |
|---|---|---|
| ABS | Calculates the absolute value of a number. The absolute value of a number is the number without its positive or negative sign. | `ABS(number)` and replace number with a merge field, expression, or other numeric value that has the sign you want removed. |
| CEILING | Rounds a number up to the nearest integer, away from zero if negative. | `CEILING(number)` and replace number with the field or expression you want rounded. |
| EXP | Returns a value for e raised to the power of a number you specify. | `EXP(number)` and replace number with a number field or value such as 5. |
| FLOOR | Returns a number rounded down to the nearest integer, towards zero if negative. | `FLOOR(number)` and replace number with a number field or value such as 5.245. |
| LN | Returns the natural logarithm of a specified number. Natural logarithms are based on the constant e value of 2.71828182845904.= [sic — 끝에 "=" 부호] | `LN(number)` and replace number with the field or expression for which you want the natural logarithm. |
| LOG | Returns the base 10 logarithm of a number. | `LOG(number)` and replace number with the field or expression from which you want the base 10 logarithm calculated. |
| MAX | Returns the highest number from a list of numbers. | `MAX(number, number,...)` and replace number with the fields or expressions from which you want to retrieve the highest number. |
| MCEILING | Rounds a number up to the nearest integer, towards zero if negative. | `MCEILING(number)` |
| MFLOOR | Rounds a number down to the nearest integer, away from zero if negative. | `MFLOOR(number)` |
| MIN | Returns the lowest number from a list of numbers. | `MIN(number, number,...)` and replace number with the fields or expressions from which you want to retrieve the lowest number. |
| MOD | Returns a remainder after a number is divided by a specified divisor. | `MOD(number, divisor)` and replace number with the field or expression you want divided; replace divisor with the number to use as the divisor. |
| ROUND | Returns the nearest number to a number you specify, constraining the new number by a specified number of digits. | `ROUND(number, num_digits)` and replace number with the field or expression you want rounded; replace num_digits with the number of decimal places you want to consider when rounding. |
| SQRT | Returns the positive square root of a given number. | `SQRT(number)` and replace number with the field or expression you want computed into a square root. |

### 2-4. Text Functions

| Function | Description | Use |
|---|---|---|
| BEGINS | Determines if text begins with specific characters and returns TRUE if it does. Returns FALSE if it doesn't. (예: `{!BEGINS(opportunity.StageName, 'Closed')}` returns true if StageName begins with "Closed" — "Closed Won"/"Closed Lost" both return true.) This function is case-sensitive so be sure your compare_text value has the correct capitalization. Also, this function only works with text, not with numbers or other data types. | `BEGINS(text, compare_text)` and replace text, compare_text with the characters or fields you want to compare. |
| BR | Inserts a line break in a string of text. | `BR()` |
| CASESAFEID | Converts a 15-character ID to a case-insensitive 18-character ID. | `CASESAFEID(id)` and replace id with the object's ID. |
| CONTAINS | Compares two arguments of text and returns TRUE if the first argument contains the second argument. If not, returns FALSE. (예: `{!IF(contains(opportunity.Product_Type__c, "part"), "Parts", "Service")}` returns "Parts" for any product with the word "part" in it, else "Service".) This function is case-sensitive so be sure your compare_text value has the correct capitalization. | `CONTAINS(text, compare_text)` and replace text with the text that contains the value of compare_text. |
| FIND | Returns the position of a string within a string of text represented as a number. | `FIND(search_text, text[, start_num])` and replace search_text with the string you want to find, replace text with the field or expression you want to search, and replace start_num with the number of the character from which to start searching from left to right. |
| GETSESSIONID | Returns the user's session ID. | `GETSESSIONID()` |
| HTMLENCODE | Encodes text and merge field values for use in HTML by replacing characters that are reserved in HTML, such as the greater-than sign (>), with HTML entity equivalents, such as `&gt;`. | `{!HTMLENCODE(text)}` and replace text with the merge field or text string that contains the reserved characters. |
| ISPICKVAL | Determines if the value of a picklist field is equal to a text literal you specify. | `ISPICKVAL(picklist_field, text_literal)` and replace picklist_field with the merge field name for the picklist; replace text_literal with the picklist value in quotes. text_literal cannot be a merge field or the result of a function. |
| JSENCODE | Encodes text and merge field values for use in JavaScript by inserting escape characters, such as a backslash (\), before unsafe JavaScript characters, such as the apostrophe ('). | `{!JSENCODE(text)}` and replace text with the merge field or text string that contains the unsafe JavaScript characters. |
| JSINHTMLENCODE | Encodes text and merge field values for use in JavaScript inside HTML tags by replacing characters that are reserved in HTML with HTML entity equivalents and inserting escape characters before unsafe JavaScript characters. `JSINHTMLENCODE(someValue)` is a convenience function that is equivalent to `JSENCODE(HTMLENCODE((someValue))`. That is, JSINHTMLENCODE first encodes someValue with HTMLENCODE, and then encodes the result with JSENCODE. | `{!JSINHTMLENCODE(text)}` and replace text with the merge field or text string that contains the unsafe JavaScript characters. |
| LEFT | Returns the specified number of characters from the beginning of a text string. | `LEFT(text, num_chars)` and replace text with the field or expression you want returned; replace num_chars with the number of characters from the left you want returned. |
| LEN | Returns the number of characters in a specified text string. (예: `{!LEN(Account.name)}` returns the number of characters in the Account name. LEN counts spaces as well as characters. `{!LEN("The Spot")}` returns 8.) | `LEN(text)` and replace text with the field or expression whose length you want returned. |
| LOWER | Converts all letters in the specified text string to lowercase. Any characters that are not letters are unaffected by this function. Locale rules are applied if a locale is provided. | `LOWER(text, [locale])` and replace text with the field or text you wish to convert to lowercase, and locale with the optional two-character ISO language code or five-character locale code, if available. |
| LPAD | Inserts characters you specify to the left-side of a text string. | `LPAD(text, padded_length[, pad_string])` and replace the variables: • text is the field or expression you want to insert characters to the left of. • padded_length is the number of total characters in the text that will be returned. • pad_string is the character or characters that should be inserted. pad_string is optional and defaults to a blank space. If the value in text is longer than pad_string, text is truncated to the size of padded_length. |
| MID | Returns the specified number of characters from the middle of a text string given the starting position. | `MID(text, start_num, num_chars)` and replace text with the field or expression to use when returning characters; replace start_num with the number of characters from the left to use as a starting position; replace num_chars with the total number of characters to return. |
| RIGHT | Returns the specified number of characters from the end of a text string. | `RIGHT(text, num_chars)` and replace text with the field or expression you want returned; replace num_chars with the number of characters from the right you want returned. |
| RPAD | Inserts characters that you specify to the right-side of a text string. | `RPAD(text, padded_length[, 'pad_string'])` and replace the variables: • text is the field or expression after which you want to insert characters. • pad_length is the number of total characters in the text string that will be returned. • pad_string is the character or characters to insert. pad_string is optional and defaults to a blank space. If the value in text is longer than pad_string, text is truncated to the size of padded_length. |
| SUBSTITUTE | Substitutes new text for old text in a text string. | `SUBSTITUTE(text, old_text, new_text)` and replace text with the field or value for which you want to substitute values, old_text with the text you want replaced, and new_text with the text you want to replace the old_text. |
| TEXT | Converts a percent, number, date, date/time, or currency type field into text anywhere formulas are used. Also, converts picklist values to text in approval rules, approval step rules, workflow rules, escalation rules, assignment rules, auto-response rules, validation rules, formula fields, field updates, and custom buttons and links. | `TEXT(value)` and replace value with the field or expression you want to convert to text format. Avoid using any special characters besides a decimal point (period) or minus sign (dash) in this function. |
| TRIM | Removes the spaces and tabs from the beginning and end of a text string. | `TRIM(text)` and replace text with the field or expression you want to trim. |
| UPPER | Converts all letters in the specified text string to uppercase. Any characters that are not letters are unaffected by this function. Locale rules are applied if a locale is provided. | `UPPER(text, [locale])` and replace text with the field or expression you wish to convert to uppercase, and locale with the optional two-character ISO language code or five-character locale code, if available. |
| URLENCODE | Encodes text and merge field values for use in URLs by replacing characters that are illegal in URLs, such as blank spaces, with the code that represent those characters as defined in RFC 3986, Uniform Resource Identifier (URI): Generic Syntax. For example, blank spaces are replaced with %20, and exclamation points are replaced with %21. | `{!URLENCODE(text)}` and replace text with the merge field or text string that you want to encode. |
| VALUE | Converts a text string to a number. | `VALUE(text)` and replace text with the field or expression you want converted into a number. |

### 2-5. Advanced Functions

| Function | Description | Use |
|---|---|---|
| CURRENCYRATE | Returns the conversion rate to the corporate currency for the given currency ISO code. If the currency is invalid, returns 1.0. | `CURRENCYRATE(currency_ISO_code)` and replace currency_ISO_code with a currency ISO code, such as "USD". |
| GETRECORDIDS | Returns an array of strings in the form of record IDs for the selected records in a list, such as a list view or related list. | `{!GETRECORDIDS(object_type)}` and replace object_type with a reference to the custom or standard object for the records you want to retrieve. |
| IMAGEPROXYURL | Securely retrieves external images and prevents unauthorized requests for user credentials. | `<apex:image value="{!IMAGEPROXYURL("http://exampledomain.com/pic.png")}"/>` and replace http://exampledomain.com/pic.png with your image. |
| INCLUDE | Returns content from an s-control snippet. Use this function to reuse common code in many s-controls. | `{!INCLUDE(source, [inputs])}` and replace source with the s-control snippet you want to reference. Replace inputs with any information you need to pass the snippet. |
| ISCHANGED | Compares the value of a field to the previous value and returns TRUE if the values are different. If the values are the same, this function returns FALSE. | `ISCHANGED(field)` and replace field with the name of the field you want to compare. |
| JUNCTIONIDLIST | Returns a JunctionIDList based on the provided IDs. | `JUNCTIONIDLIST(id, id,...)` and replace id with the Salesforce ID you want to use. |
| LINKTO | Returns a relative URL in the form of a link (href and anchor tags) for a custom s-control or Salesforce page. | `{!LINKTO(label, target, id, [inputs], [no override]}` and replace label with the text for the link, target with the URL, and id with a reference to the record. Inputs are optional and can include any additional parameters you want to add to the link. The no override argument is also optional and defaults to "false." It applies to targets for standard Salesforce pages such as $Action.Account.New. Replace no override with "true" when you want to display a standard Salesforce page regardless of whether you have defined an override for it elsewhere. |
| PREDICT | Returns an Einstein Discovery prediction for a record based on the specified record ID or for a list of fields and their values. | `PREDICT(PredDefId, [recordId] | [field, value, ...])`. Replace PredDefId with the Prediction Definition ID of a deployed prediction in your org. Specify the recordId of the record to predict or a list of fields and their associated values (`[field, value, ...]`). |
| REGEX | Compares a text field to a regular expression and returns TRUE if there is a match. Otherwise, it returns FALSE. A regular expression is a string used to describe a format of a string according to certain syntax rules. | `REGEX(text, regex_text)` and replace text with the text field, and regex_text with the regular expression you want to match. |
| REQUIRESCRIPT | Returns a script tag with source for a URL you specify. Use this function when referencing the Lightning Platform AJAX Toolkit or other JavaScript toolkits. | `{!REQUIRESCRIPT(url)}` and replace url with the link for the script that is required. |
| URLFOR | Returns a URL for an action, an s-control, a Visualforce page, or a file in a static resource archive. URLFOR is available for use in custom buttons and links, s-controls, and Visualforce pages. **Note:** As of Winter '25, all Visualforce pages are served on the force.com domain or a site domain. URLFOR currently returns an absolute URL for all Visualforce pages. See Ensure Access to Your Visualforce Pages in Summer '24 and Winter '25. | `{!URLFOR(target, [id], [inputs], [no override])}` and replace target with the URL or action, s-control, or static resource merge variable; id with an optional reference to the record; and inputs with any optional parameters. The no override argument is also optional and defaults to false. It applies to targets for standard Salesforce pages such as $Action.Account.New. Replace no override with true when you want to display a standard Salesforce page regardless of whether you have defined an override for it elsewhere. (자세한 Use 본문은 아래 참조) |

#### URLFOR — Use 칼럼 상세

표 셀이 길어 별도로 보존한다 (verbatim).

> To access a Visualforce page, enter the page name preceded by `$Page`. For example, if your Visualforce page is named myTestPage, use:
> `{!URLFOR($Page.myTestPage)}`
>
> To return a reference to a file contained in a static resource archive (such as a .zip or .jar file), use the format `{!URLFOR(resource, path)}`. Replace resource with the name of the static resource archive expressed as a merge variable (for example, `$Resource.resourceName`), and path with the local path to the file in the archive that you want to reference.
>
> Use the `[inputs]` array to provide name-value pairs, which are added to the URL as query string parameters. Input values can be dynamic. For example, to include an account ID, specify:
> `{!URLFOR($Page.myVisualforcePage, null, [accountId=Account.Id])}`
> The resulting URL would include a parameter with the ID, such as:
> `https://MyDomainName--PackageName.vf.force.com/apex/myVisualforcePage?accountId=001B0000002txol`
>
> **Note:** Parameter names are static This means you can't use a variable to determine the parameter name. For example, if you use `[myVariable="value1"]` and set myVariable to "param1", the resulting URL includes `?myVariable=value1` and not the param1 value.
> Query string parameters are intended for short, simple values. Don't try to be clever, for example, by encoding complex values as JSON. If your request needs to pass more data, use a Visualforce form component, and send the data in the POST request body.

| Function | Description | Use |
|---|---|---|
| VLOOKUP | Returns a value by looking up a related value on a custom object similar to the VLOOKUP() Excel function. | `VLOOKUP(field_to_return, field_on_lookup_object, lookup_value)` and replace field_to_return with the field that contains the value you want returned, field_on_lookup_object with the field on the related object that contains the value you want to match, and lookup_value with the value you want to match. You can only use VLOOKUP() in validation rules. If the function fails because, for example, the field_on_lookup_object doesn't exist, you can specify an error message in the validation rule itself. |

---

## PART 3 — Expression Operators

연산자는 표현식들을 연결해 복합 표현식을 만들 때 쓴다. 연산자는 평가되려면 Visualforce 표현식 구문 안에서 사용해야 한다.

### 3-1. Math Operators

| Operator | Description | Use |
|---|---|---|
| `+` | Calculates the sum of two values. | `value1 + value2` and replace each value with merge fields, expressions, or other numeric values. |
| `-` | Calculates the difference of two values. | `value1 - value2` and replace each value with merge fields, expressions, or other numeric values. |
| `*` | Multiplies its values. | `value1 * value2` and replace each value with merge fields, expressions, or other numeric values. |
| `/` | Divides its values. | `value1 / value2` and replace each value with merge fields, expressions, or other numeric values. |
| `^` | Raises a number to a power of a specified number. | `number^integer` and replace number with a merge field, expression, or another numeric value; replace integer with a merge field that contains an integer, expression, or any integer. |
| `()` | Specifies that the expressions within the open parenthesis and close parenthesis are evaluated first. All other expressions are evaluated using standard operator precedence. | `(expression1) expression2...` and replace each expression with merge fields, expressions, or other numeric values. |

### 3-2. Logical Operators

> **Note:** You can't have a relative comparison expression that includes a null value. Doing so results in an exception. Specifically, you can't have a null value on either side of the following operators:
> - `<` (less than)
> - `<=` (less than or equals)
> - `>` (greater than)
> - `>=` (greater than or equals)

| Operator | Description | Use |
|---|---|---|
| `= and ==` | Evaluates if two values are equivalent. The = and == operators are interchangeable. | `expression1=expression2` or `expression1 == expression2`, and replace each expression with merge fields, expressions, or other numeric values. |
| `<> and !=` | Evaluates if two values aren't equivalent. | `expression1 <> expression2` or `expression1 != expression2`, and replace each expression with merge fields, expressions, or other numeric values. |
| `<` | Evaluates if a value is less than the value that follows this symbol. | `value1 < value2` and replace each value with merge fields, expressions, or other numeric values. |
| `>` | Evaluates if a value is greater than the value that follows this symbol. | `value1 > value2` and replace each value with merge fields, expressions, or other numeric values. |
| `<=` | Evaluates if a value is less than or equal to the value that follows this symbol. | `value1 <= value2` and replace each value with merge fields, expressions, or other numeric values. |
| `>=` | Evaluates if a value is greater than or equal to the value that follows this symbol. | `value1 >= value2` and replace each value with merge fields, expressions, or other numeric values. |
| `&&` | Evaluates if two values or expressions are both true. Use this operator as an alternative to the logical function AND. | `(logical1) && (logical2)` and replace logical1 and logical2 with the values or expressions that you want evaluated. |
| `\|\|` | Evaluates if at least one of multiple values or expressions is true. Use this operator as an alternative to the logical function OR. | `(logical1) \|\| (logical2)` and replace any number of logical references with the values or expressions you want evaluated. |

### 3-3. Text Operators

| Operator | Description | Use |
|---|---|---|
| `&` | Connects two or more strings. | `string1&string2` and replace each string with merge fields, expressions, or other values. |

---

## 관련 노트
- [[Visualforce 개요 — 도구·퀵스타트]]
- [[동적 Visualforce — 바인딩·동적 컴포넌트]]
- [[버튼·링크 오버라이드·Static Resource·커스텀 컴포넌트]]
- [[페이지 출력 제어 — HTML·PDF·SLDS]]
- [[표준 컨트롤러·표준 리스트 컨트롤러]]
- [[커스텀 컨트롤러·컨트롤러 확장]]
