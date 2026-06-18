---
tags: [Service, Chat, LiveAgent, DeploymentAPI, findOrCreate, JavaScript, 채팅]
source: chat_dev_guide
created: 2026-06-18
aliases: [findOrCreate, addCustomDetail, doKnowledgeSearch, setName, setCustomVariable, rejectChat, Automated Chat Invitation, Deployment API Code Sample, 레코드 자동 생성, 자동 채팅 초대]
---

# Deployment API — 레코드 자동 검색·생성·자동 채팅 초대 & 코드 샘플

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며, **Messaging for In-App and Web**로 이전하세요. 이 노트는 마이그레이션·이력 참조용입니다.

> Deployment API로 채팅 시작 시 Salesforce 레코드(case·contact·account·lead)를 자동 검색·생성하는 메서드(`addCustomDetail`·`findOrCreate` 계열·`setName`·`doKnowledgeSearch`)와, 자동 채팅 초대(`setCustomVariable`·`rejectChat`·`addButtonEventHandler` 초대판), 그리고 코드 샘플 3종을 다룬다.

---

## Find and Create Records Automatically with the Deployment APIs (개요)

Deployment API로 에이전트가 고객과 채팅을 시작할 때 Salesforce 레코드(case·contact·account·lead 등)를 자동으로 검색하거나 생성한다. 아래 메서드를 deployment 생성 시 자동 생성된 코드에 추가 스크립트로 넣는다.

### findOrCreate Limitations (제한)

`findOrCreate`의 핵심 제한:

- 보안상 이 API는 **신규 조직에서 기본 비활성화**다. Setup의 Chat Settings 페이지에서 활성화할 수 있다. 이 페이지에서 허용 객체의 allowlist도 만들 수 있다.
  > Note: 이 기능이 활성화되어 있고 allowlist에 객체가 하나도 선택되지 않으면, 모든 유효한 객체가 허용된다.
- `findOrCreate` 호출은 **bot session이 아니라 agent session에서** 구현한다. `findOrCreate`가 여러 레코드를 매칭하면 에이전트는 첨부할 레코드를 선택할 수 있으나 bot은 그럴 방법이 없다.
- find: **profile·permission set은 검색 불가**.
- create: **profile·permission set은 생성 불가**.

---

## addCustomDetail

각 chat 방문자에 대한 custom detail을 추가한다.

**Usage:** chat 방문자의 새 custom detail을 추가한다. Custom Detail은 채팅이 active인 동안 Salesforce Console의 footer widget과 Chat Details 페이지에서 에이전트에게 표시된다. API versions 28.0 이상.

**Syntax:** `addCustomDetail(String label, String value, (optional) Boolean displayToAgent)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| label | String | The label for the custom detail—for example, "Name". | Available in API versions 28.0 and later. |
| value | String | The value of the custom detail—for example, "John Doe". | Available in API versions 28.0 and later. |
| (Optional) displayToAgent | Boolean | Specifies whether to display the custom details that customers provide in a pre-chat form to the agent (true) or not (false). | Available in API versions 29.0 and later. |

---

## findOrCreate

특정 기준에 따라 기존 레코드를 찾거나 레코드를 생성한다.

**Usage:** 채팅이 Omni-Channel로 라우팅되거나, 에이전트가 Live Agent routing으로 라우팅된 채팅 요청을 수락할 때 지정 타입의 레코드를 찾거나 생성한다. Omni-Channel로 라우팅된 채팅의 경우, **에이전트가 수락하기 전에 방문자가 채팅을 취소해도** `findOrCreate` 코드가 트리거된다. Live Agent routing으로 라우팅된 채팅의 경우, 에이전트가 채팅 요청을 수락할 때만 코드가 트리거된다.

> Note: `findOrCreate` 메서드는 에이전트가 고객과 채팅을 시작할 때 기존 레코드를 찾거나 레코드를 생성하는 API 호출을 시작한다. **다른 `findOrCreate` 서브메서드를 호출하기 전에 이 메서드를 먼저 호출**한다.

API versions 29.0 이상.

**Syntax:** `liveagent.findOrCreate(String EntityName)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| EntityName | String | The type of record to search for or create when an agent accepts a chat with a customer—for example, a contact record. | Available in API versions 29.0 and later. |

**서브메서드:** `findOrCreate.map`, `findOrCreate.saveToTranscript`, `findOrCreate.showOnCreate`, `findOrCreate.linkToEntity`.

### findOrCreate.map (Deployment판)

특정 고객 detail을 포함하는 레코드를 검색·생성한다.

**Usage:** `addCustomDetail`로 지정된 고객 데이터를 포함하는 레코드를 검색·생성한다. 이 메서드는 custom detail의 값을 Salesforce console의 지정 레코드 필드에 매핑한다. 적절한 레코드를 찾기 위해 필요한 만큼 여러 번 호출할 수 있다 — 검색하려는 각 필드와 그에 대응하는 custom detail 값마다 한 번씩 호출한다. agent session에서 구현한다(bot session 아님). API versions 29.0 이상.

**Syntax:** `liveagent.findOrCreate(Object EntityName).map(String FieldName, String DetailName, Boolean doFind, Boolean isExactMatch, Boolean doCreate)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| FieldName | String | The API name of the field in the record EntityName to which to map the corresponding custom detail DetailName. | Available in API versions 29.0 and later. |
| DetailName | String | The value of the custom detail to map to the corresponding field FieldName. | Available in API versions 29.0 and later. |
| doFind | Boolean | Specifies whether to search for a record that contains the custom detail DetailName in the field FieldName (true) or not (false). | Available in API versions 29.0 and later. |
| isExactMatch | Boolean | Specifies whether to search for a record that contains the exact value of the custom detail DetailName you specified in the field FieldName (true) or not (false). | Available in API versions 29.0 and later. |
| doCreate | Boolean | Specifies whether to create a new record with the custom detail DetailName in the field FieldName if one isn't found (true) or not (false). | Available in API versions 29.0 and later. |

### findOrCreate.saveToTranscript (Deployment판)

찾거나 생성한 레코드를 채팅과 연결된 chat transcript에 저장한다.

**Usage:** `findOrCreate`·`findOrCreate.map`으로 찾거나 생성한 레코드를 채팅과 연결된 chat transcript에 저장한다. API versions 29.0 이상.

**Syntax:** `liveagent.findOrCreate(String EntityName).saveToTranscript(String TranscriptFieldName)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| TranscriptFieldName | String | The name of the field on the chat transcript record to which to save the ID of the record you found or created. | Available in API versions 29.0 and later. |

### findOrCreate.showOnCreate (Deployment판)

생성한 레코드를 Salesforce console의 subtab에 자동으로 연다.

**Usage:** `findOrCreate`·`findOrCreate.map`으로 생성한 레코드를 Salesforce console의 subtab에 자동으로 연다. API versions 29.0 이상.

**Syntax:** `liveagent.findOrCreate(String EntityName).showOnCreate()`

**Parameters:** (없음)

### findOrCreate.linkToEntity (Deployment판)

찾거나 생성한 레코드를 다른 record type에 링크한다.

**Usage:** `findOrCreate`·`findOrCreate.map`으로 찾거나 생성한 레코드를, 별도의 `findOrCreate` API 호출로 생성한 다른 record type의 레코드에 링크한다. 예를 들어 조직에서 찾은 case 레코드를 생성한 contact 레코드에 링크할 수 있다.

> Note: 부모 레코드가 `findOrCreate` API 호출로 **생성된** 경우에만 레코드를 링크할 수 있다. `findOrCreate.linkToEntity`로 찾은 레코드에는 자식 레코드를 링크할 수 없다.

API versions 29.0 이상.

**Syntax:** `liveagent.findOrCreate(String EntityName).linkToEntity(String EntityName, String FieldName)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| EntityName | String | The type of record to which to link the child record you found or created. | Available in API versions 29.0 and later. |
| FieldName | String | The name of the API field in the record EntityName to which to save the ID of the child record you found or created. | Available in API versions 29.0 and later. |

> Pre-Chat 폼 기반의 `findOrCreate` 계열(숨은 `doFind`/`isExactMatch`/`doCreate` 포함 9메서드) 및 Deployment vs Pre-Chat 비교표는 [[Pre-Chat API — 방문자 정보 수집 & 컨텍스트 설정]] 참조.

---

## setName

Chat console 또는 Salesforce console에 표시되는 방문자 이름을 설정한다.

**Usage:** Salesforce console에 표시되는 방문자 이름을 설정한다. 이름은 채팅의 primary tab, chat transcript가 있는 에이전트의 chat log, Live Agent Supervisor 패널에 표시된다. API versions 28.0 이상.

**Syntax:** `setName(String name)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| name | String | The visitor name that appears in the Chat console or the Salesforce console. | Available in API versions 28.0 and later. |

---

## doKnowledgeSearch (addCustomDetail.doKnowledgeSearch)

Deployment API로 고객이 pre-chat 폼에 제공한 정보를 기준으로 Knowledge article을 검색한다.

**Usage:** 고객이 채팅을 요청할 때 pre-chat 폼에서 custom detail 값을 가져온다. 에이전트가 채팅 요청을 수락하면, 이 값을 검색 키워드로 사용해 Knowledge One widget에서 article을 찾는다. `doKnowledgeSearch()` 메서드는 `addCustomDetail` 메서드의 `value` 파라미터를 사용해 검색한다. API version 31.0 이상.

**Syntax:** `liveagent.addCustomDetail(String label, String value, (optional) Boolean displayToAgent).doKnowledgeSearch()`

> Knowledge 데이터 모델·검색 API 전반은 [[Knowledge 데이터 모델 & API 개요]] 참조.

---

## 코드 샘플 1 — Find and Create Records Deployment API Code Sample

다음 코드는 `addCustomDetail`, `findOrCreate`, `findOrCreate.map`, `findOrCreate.saveToTranscript`, `findOrCreate.linkToEntity`, `findOrCreate.showOnCreate`를 사용해 에이전트가 고객과 채팅을 시작할 때 레코드를 검색·생성한다.

```html
<script type='text/javascript'>
/* Creates a custom detail called First Name and sets the value to "Jane" */
liveagent.addCustomDetail("First Name", "Jane");

/* Creates a custom detail called Last Name and sets the value to "Doe" */
liveagent.addCustomDetail("Last Name", "Doe");

/* Creates a custom detail called Phone Number and sets the value to "555-1212" */
liveagent.addCustomDetail("Phone Number", "415-555-1212");

/* Creates a custom detail called Case Subject and sets the value to "Best snowboard for
a beginner" and will perform a knowledge search when the chat is accepted for the agent
*/

liveagent.addCustomDetail("Case Subject", "Best snowboard for a
beginner").doKnowledgeSearch();

/* Creates a custom detail called Case Status and sets the value to "New" */
liveagent.addCustomDetail("Case Status", "New");

/* This does a non-exact search on cases by the value of the "Case Subject" custom detail.

 If no results are found, it will create a case and set the case's subject and status
 The case that's found or created will be associated to the chat and the case will open in
 the Console for the agent when the chat is accepted */
liveagent.findOrCreate("Case").map("Subject","Case
Subject",true,false,true).map("Status","Case
Status",false,false,true).saveToTranscript("CaseId").showOnCreate();

/* This searches for a contact whose first and last name exactly match the values in the
custom details for First and Last Name
 If no results are found, it will create a new contact and set it's first name, last name,
 and phone number to the values in the custom details */
liveagent.findOrCreate("Contact").map("FirstName","First
Name",true,true,true).map("LastName","Last Name",true,true,true).map("Phone","Phone
Number",false,false,true);

/* The contact that's found or created will be saved or associated to the chat transcript.
The contact will be opened for the agent in the Console and the case is linked to the
contact record */
liveagent.findOrCreate("Contact").saveToTranscript("ContactId").showOnCreate().linkToEntity("Case","ContactId");
</script>
```

---

## Customize Automated Chat Invitations with the Deployment APIs (자동 채팅 초대)

웹사이트에서 고객에게 나타나는 자동 채팅 초대를 커스터마이즈한다. 아래 메서드를 사용한다: `setCustomVariable`, `rejectChat`, `addButtonEventHandler`.

### setCustomVariable

자동 초대가 고객에게 전송되기 위해 충족되어야 하는 sending rule의 커스텀 기준을 만든다.

**Usage:** sending rule에 커스텀 기준을 만들고, sending rule 기준에 쓰이는 custom variable의 비교 값을 지정한다. API versions 28.0 이상.

**Syntax:** `void setCustomVariable(String variableName, Object value)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| variableName | String | The name of the customized criteria for your custom sending rule. | Available in API versions 28.0 and later. |
| value | Object | The comparison value for your custom sending rule. | Available in API versions 28.0 and later. |

### rejectChat

고객에게 전송된 초대를 거부하고 회수한다.

**Usage:** 초대를 거부하여 회수되게 한다. API versions 28.0 이상.

**Syntax:** `void rejectChat(String buttonId)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| buttonId | String | The ID of the chat button for which to reject chats. | Available in API versions 28.0 and later. |

### addButtonEventHandler (초대판)

자동 초대가 특정 이벤트 발생 시의 동작을 정의한다.

> 버튼판 `addButtonEventHandler`(2개 event type만)는 [[Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼]] 참조. 여기서는 초대판(4개 event type, BUTTON_ACCEPTED/BUTTON_REJECTED 포함)을 다룬다.

**Usage:** 다음 이벤트 발생 시 초대의 동작을 정의한다.

- The criteria are met for the invitation to appear on-screen.
- The criteria are not met for the invitation to appear on-screen.
- A customer accepts an invitation to chat.
- A customer rejects an invitation to chat.

"the criteria are not met for the invitation to appear on the screen" 이벤트는 설정된 chat button 또는 자동 초대로 채팅이 에이전트에 도달할 수 없을 때 발생하며, 구체적으로:

- No agents are online.
- No agents assigned to the skills associated with the button are online.
- Online agents have the status Away.
- Online agents are at capacity (set with Chat Configurations, or Presence Configurations with Omni-Channel).
- Online agents are using Omni-Channel and are only available for other service channels.

API versions 28.0 이상.

**Syntax:** `void addButtonEventHandler(String buttonId, Function callback)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| buttonId | String | The ID of the chat button associated with the automated invitation for which to define the behavior when certain events occur. | Available in API versions 28.0 and later. |
| callback | function | The function to call when a particular event occurs. You must specify the invitation's behavior for each of the required event types. | Available in API versions 28.0 and later. |

**Event Types (초대판 — 4행):**

| Function | Event Type | Syntax | Description |
|---|---|---|---|
| callback | BUTTON_AVAILABLE | `liveagent.BUTTON_EVENT.BUTTON_AVAILABLE` | Specifies the behavior of the automated invitation when the criteria are met for the invitation to appear on-screen. |
| callback | BUTTON_UNAVAILABLE | `liveagent.BUTTON_EVENT.BUTTON_UNAVAILABLE` | Specifies the behavior of the automated invitation when the criteria are not met for the invitation to appear on-screen. |
| callback | BUTTON_ACCEPTED | `liveagent.BUTTON_EVENT.BUTTON_ACCEPTED` | Specifies the behavior of the automated invitation when a customer accepts the invitation. This event type is only available for automated chat invitations. |
| callback | BUTTON_REJECTED | `liveagent.BUTTON_EVENT.BUTTON_REJECTED` | Specifies the behavior of the automated invitation when a customer rejects the invitation. This event type is only available for automated chat invitations. |

> Note: 같은 타입의 이벤트를 여러 번 받을 수 있다.

### 코드 샘플 2 — Automated Chat Invitation Code Sample

다음 코드는 `addButtonEventHandler()`를 사용해 웹사이트에 커스텀 초대를 표시한다. 올바른 skill의 에이전트가 가용할 때 고객이 채팅을 시작할 수 있게 한다.

```html
<!-- // 구조 예시 — pdftotext 레이아웃 복원 (원문 PDF의 -layout 추출에서 일부 주석과 if문이 한 줄로 붙어 있던 것을 정상 JS 구조로 복원. 메서드명·ID·로직은 PDF 원문 그대로) -->
<apex:page>

<!-- This section creates the div with the UI for chat invitation whose id is 573D01234567890 -->
<!-- For this usage, the "Animation" type of this invitation should be set to "Custom",
otherwise two invitations will appear (the Salesforce-provided one and this custom one). -->
<div id="liveagent_invite_button_573D01234567890" style="display: none; position: fixed;
border: 2px solid darkblue; border-radius: 5px; background-color: lightblue; height: 100px;
 width: 200px;">
 <!-- Creates an "X" option to reject or close the invitation if it's offered -->
 <div style="cursor: pointer; padding: 5px; right: 0px; position: absolute; color: darkred;
 font-weight: bold;" onclick="liveagent.rejectChat('573D01234567890')">X</div>
<!-- Provides the Start Chat option for the customer to accept or start the chat for the invitation -->
<div style="cursor: pointer; top: 42px; left: 65px; position: absolute;font-weight: bold;
 font-size: 16px;" onclick="liveagent.startChat('573D01234567890')">Start Chat</div>
</div>

<!-- Chat Deployment Code that makes chat available -->
<script type='text/javascript'
src='https://MyDomainName.my.salesforce-scrt.com/content/g/js/36.0/deployment.js'></script>

<script type='text/javascript'>
 // Creates the callback function used for the Chat invitation to present it or not based
 // on availability and the customer's interaction with it
 function buttonCallback(e) {

  // When the chat invitation is online (i.e. at least one available, skilled agent),
  // display it at position top 200px and left 300px
  if (e == liveagent.BUTTON_EVENT.BUTTON_AVAILABLE) {
    document.getElementById('liveagent_invite_button_573D01234567890').style.display = '';
    document.getElementById('liveagent_invite_button_573D01234567890').style.left = '300px';
    document.getElementById('liveagent_invite_button_573D01234567890').style.top = '200px';
  }

  // When the chat invitation is offline, don't display it
  if (e == liveagent.BUTTON_EVENT.BUTTON_UNAVAILABLE) {
    document.getElementById('liveagent_invite_button_573D01234567890').style.display = 'none';
  }

  // When the chat invitation is accepted, stop displaying it
  if (e == liveagent.BUTTON_EVENT.BUTTON_ACCEPTED) {
    document.getElementById('liveagent_invite_button_573D01234567890').style.display = 'none';
  }

  // When the chat invitation is rejected, stop displaying it
  if (e == liveagent.BUTTON_EVENT.BUTTON_REJECTED) {
    document.getElementById('liveagent_invite_button_573D01234567890').style.display = 'none';
  }
 }

 // Registers the function buttonCallback() above as the callback for the chat invitation
 // whose id is 573D01234567890
 liveagent.addButtonEventHandler('573D01234567890', buttonCallback);

 // Let's say there is data available in JavaScript that you want to use in a custom sending rule.
 var shoppingCartValue = 123.45;
 // To pass this data so it can be used in Sending Rules in Salesforce setup, call setCustomVariable.
 liveagent.setCustomVariable('shoppingCartValue', shoppingCartValue);

 // Chat deployment code that initializes chat for the deployment whose id is 572D01234567890
 // and org is 00DD01234567890
 liveagent.init('https://MyDomainName.my.salesforce-scrt.com/chat', '572D01234567890', '00DD01234567890');

 // Enable Chat advanced logging to be available through the Browser's Developer Console
 liveagent.enableLogging();
</script>

</apex:page>
```

이 코드는 JavaScript에서 사용 가능한 데이터를 Setup의 초대 sending rule에 전달할 수 있게 한다.

> Setup의 Sending Rules 설정 결과는 PDF에 스크린샷으로 제공된다 ("This is an example of how your settings might look:"). pdftotext가 추출하지 못해 본 위키에는 캡션만 옮긴다 — 이미지는 fabricate하지 않는다.

---

## 코드 샘플 3 — Deployment API Code Sample (종합)

이 샘플은 `startChat`, `showWhenOnline`, `showWhenOffline`, `addCustomDetail`, `setName`, `map`, `setChatWindowWidth`, `setChatWindowHeight`, `doKnowledgeSearch`를 사용하는 chat window를 만든다.

> Warning: Deployment API로 추가된 detail은 **Visitor**에 연결된다. 채팅이 시작되면 Chasitor는 최초 visitor에 연결된다. 후속 요청은 같은 visitor에 연결된 새 Chasitor다. **하나의 Chasitor에만 연결된 detail을 만들려면 Prechat API를 사용해야 한다.** (Visitor·Chasitor·SessionId 등 방문자측 개념은 [[Chat REST API 개요 & 시작]] 참조.)

```html
<apex:page showHeader="false">
<style> body { margin: 25px 0 0 25px; } </style>

<h1>Welcome to Support</h1>

<br />
Thank you for your interest.
<br /><br />

<!-- START Button code, Replace this section with your Chat button code snippet -->
<a id="liveagent_button_online_573B0000000033Y" href="javascript://Chat" style="display:
none;" onclick="liveagent.startChat('573B0000000033Y')">Chat Now</a>
<div id="liveagent_button_offline_573B0000000033Y" style="display: none;">Chat is currently
 unavailable</div>
<script type="text/javascript">
    if (!window._laq) { window._laq = []; }
    window._laq.push(function(){
        liveagent.showWhenOnline('573B0000000033Y',
document.getElementById('liveagent_button_online_573B0000000033Y'));
        liveagent.showWhenOffline('573B0000000033Y',
document.getElementById('liveagent_button_offline_573B0000000033Y'));
});</script>

<!-- END Button code -->

<!-- Chat Deployment Code, replace with your org's values -->
<script type='text/javascript'
src='https://c.la.gus.salesforce.com/content/g/js/36.0/deployment.js'></script>

<!-- Deployment Code API examples -->
<script type='text/javascript'>
/* Adds a custom detail called Contact Email and sets it value to jane@doe.com */
liveagent.addCustomDetail('Contact E-mail', 'jane@doe.com');

/* Creates a custom detail called First Name and sets the value to Jane */
liveagent.addCustomDetail('First Name', 'Jane');

/* Creates a custom detail called Last Name and sets the value to Doe */
liveagent.addCustomDetail('Last Name', 'Doe');

/* Creates a custom detail called Phone Number and sets the value to 415-555-1212 */
liveagent.addCustomDetail('Phone Number', '415-555-1212');

/* An auto-query that searches Contacts whose Email field exactly matches 'jane@doe.com'.
 If no result is found, it will create a Contact record with the email, first name, last
name, and phone number fields set to the custom detail values. */
liveagent.findOrCreate('Contact').map('Email','Contact
E-mail',true,true,true).map('FirstName','First Name',false,false,true).map('LastName','Last
 Name',false,false,true).map('Phone','Phone Number',false,false,true);

/* The contact that's found or created will be saved or associated to the chat transcript.
 The contact will be opened for the agent in the Console and the case is linked to the
contact record */
liveagent.findOrCreate('Contact').saveToTranscript('ContactId').showOnCreate().linkToEntity('Case','ContactId');

/* Creates a custom detail called Case Subject and sets the value to 'Refund policy for
products' and will perform a knowledge search when the chat is accepted for the agent */
liveagent.addCustomDetail('Case Subject','Refund policy for products').doKnowledgeSearch();

/* Creates a custom detail called Case Status and sets the value to 'New' */
liveagent.addCustomDetail('Case Status','New');

/* This does a non-exact search on cases by the value of the 'Case Subject' custom detail
 If no results are found, it will create a case and set the case's subject and status.
The case that's found or created will be associated to the chat and the case will open in
 the Console for the agent when the chat is accepted */
liveagent.findOrCreate('Case').map('Subject','Case
Subject',true,false,true).map('Status','Case
Status',false,false,true).saveToTranscript('CaseId').showOnCreate();

/* Saves the custom detail to a custom field on LiveChatTranscript at the end of a chat.
 Assumes a custom field called Company__c was added to the Live Chat Transcript object */
liveagent.addCustomDetail('Company', 'Acme').saveToTranscript('Company__c');

/* For internal or technical details that don't concern the agent, set showToAgent to false
 to hide them from the display. */
liveagent.addCustomDetail('VisitorHash', 'c6f440178d478e4326a1', false);

/* Sets the display name of the visitor in the agent console when engaged in a chat */
liveagent.setName('Jane Doe');

/* Sets the width of the chat window to 500px */
liveagent.setChatWindowWidth(500);

/* Sets the height of the chat window to 500px */
liveagent.setChatWindowHeight(500);

<!-- Chat Deployment Code to initialize, replace with your org's values -->
liveagent.init('https://d.la.gus.salesforce.com/chat', '572B000000003KL', '00DB00000000Rr8');
</script>
</apex:page>
```

이 코드가 에이전트 콘솔에 만드는 결과: `setName`으로 설정한 고객 이름(예: Jane Doe)이 콘솔에 표시되고(1), `addCustomDetail.doKnowledgeSearch`를 호출하면 검색이 Knowledge widget에 자동 표시되며(2), 에이전트가 채팅을 받으면 설정된 Custom Details가 hover window에 표시된다.

> 위 콘솔 결과·hover window는 PDF에 스크린샷으로 제공된다(인쇄 p.31). pdftotext가 추출하지 못해 캡션만 옮긴다 — 이미지는 fabricate하지 않는다.

### Optional Cookies (선택 쿠키 — Deployment API Code Sample 하위)

consent manager로 사용자가 optional cookie를 opt in/out 하게 할 수 있다. opt in이면 `liveagent.init()`의 **4번째 파라미터**에 `true`를 넘겨 optional cookie 추적을 활성화한다. opt out이면 `false`를 넘긴다. 4번째 파라미터를 생략하면 `true`를 넘긴 것과 같다.

> Note: optional cookie opt-out 제공 기능은 Deployment API **version 52.0 이상**에서 지원된다.

```javascript
/* Enable optional cookies*/
liveagent.init('https://d.la.gus.salesforce.com/chat', '572B000000003KL', '00DB00000000Rr8',
 true);
liveagent.init('https://d.la.gus.salesforce.com/chat', '572B000000003KL', '00DB00000000Rr8');

/* Disable optional cookies */
liveagent.init('https://d.la.gus.salesforce.com/chat', '572B000000003KL', '00DB00000000Rr8',
 false);
```

사용자가 opt out하면 `liveagent.disableOptionalCookies()`도 호출할 수 있다. 이는 optional cookie를 삭제하고 추적을 중단한다. `liveagent.init()`에 `false`를 넘기는 것과 같지만, `true`를 넘긴 `liveagent.init()`보다 **우선순위가 높다**. 예: `disableOptionalCookies()`를 먼저 호출한 뒤 `init()`에 `true`를 넘겨도 optional cookie는 여전히 비활성화된다. `init()`과 달리 `disableOptionalCookies()`는 페이지 로드 후 언제든 호출할 수 있다.

```javascript
/* Disable optional cookies.*/
liveagent.disableOptionalCookies()
```

사용자가 opt out 후 다시 opt in하면 다음 페이지 로드에서 `init()`에 `true`를 넘긴다.

```html
<apex:page showHeader="false">
<style> body { margin: 25px 0 0 25px; } </style>

...

<!-- Chat Deployment Code to initialize, replace with your org's values -->
/* To enable tracking optional cookies, pass `true` to the fourth parameter. To disable
them, pass `false` to the fourth parameter or call liveagent.disableOptionalCookies().*/
liveagent.init('https://d.la.gus.salesforce.com/chat', '572B000000003KL',
'00DB00000000Rr8',true);
</script>
</apex:page>
```

---

## 관련 노트

- [[Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼]]
- [[Pre-Chat API — 방문자 정보 수집 & 컨텍스트 설정]]
- [[커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅]]
- [[Chat REST API 개요 & 시작]]
- [[Service Cloud Objects]]
- [[Knowledge 데이터 모델 & API 개요]]

> 이 노트(chat_dev_guide) = JavaScript Deployment/Pre-Chat API·Visualforce 기반 웹페이지 임베드 관점. ING-13a(chat_rest) = 네이티브 앱·커스텀 클라이언트용 REST API 관점.
