---
tags: [Service, Chat, LiveAgent, Visualforce, DirectToAgent, FallbackRouting, PostChat, QuickText, 채팅]
source: chat_dev_guide
created: 2026-06-18
aliases: [Custom Chat Window, liveAgent components, clientChatMessages, clientChatInput, clientChatQueuePosition, clientChatEndButton, clientChatAlertMessage, clientChatSaveButton, clientChatStatusMessage, clientChatLog, clientChatFileTransfer, post-chat page, post-chat variables, disconnectedBy, abandoned chat, direct-to-agent routing, fallback routing, domainMatcher, startChatWithWindow, agentId_buttonId, chat with me link, ChatWithMe, Quick Text chat link, 커스텀 채팅 윈도우, 포스트챗, 다이렉트 투 에이전트, 폴백 라우팅, 비주얼포스 채팅 컴포넌트, 에이전트 직접 라우팅, VF로 채팅창 커스터마이즈, 채팅창 비주얼포스로 만들기, 채팅 끝나고 설문으로 보내기, post-chat 리다이렉트, 채팅 종료 후 페이지, abandoned 채팅 처리, 채팅 중단 처리, 상담원 직접 채팅 링크, chat with me 링크, 특정 상담원에게 채팅 연결, 에이전트 오프라인이면 다른 큐로 폴백, 상담원 없으면 버튼으로 폴백, 채팅 대기열 위치 표시, Quick Text로 채팅 링크 배포]
---

# 커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며, **Messaging for In-App and Web**로 이전하세요. 이 노트는 마이그레이션·이력 참조용입니다.

> chat_dev_guide v67.0 Ch6–8 — VF 커스텀 chat window·post-chat 페이지·direct-to-agent/fallback 라우팅.

---

## Ch6 — Create a Custom Chat Window with Visualforce (개요)

Chat 윈도우의 모양과 동작을 완전히 커스터마이즈하려면 Visualforce 페이지 안에서 `liveAgent:*` 컴포넌트를 조합한다. 모든 컴포넌트는 단일 부모 컨테이너인 `liveAgent:clientChat` 안에서 사용되어야 하며, `liveAgent:clientChat` 자체는 한 Chat deployment에서 한 번만 사용할 수 있다.

### liveAgent:* Visualforce 컴포넌트 (13종 전수)

| 컴포넌트명 | 설명 |
|---|---|
| `liveAgent:clientChat` | The main parent element for any chat window. This element is necessary to do any additional customization of Chat. This component can only be used once in a Chat deployment. |
| `liveAgent:clientChatAlertMessage` | The area in a chat window that displays system alert messages (such as "You have been disconnected"). |
| `liveAgent:clientChatMessages` | The area in a chat window that displays system status messages, such as "Chat session has been disconnected." Must be used within liveAgent:clientChat. Each chat window can have only 1 message area. |
| `liveAgent:clientChatStatusMessage` | The area in a chat window that displays system status messages (such as "You are being reconnected"). |
| `liveAgent:clientChatQueuePosition` | A text label indicating a visitor's position in a queue for a chat session that's initiated by a button that uses push routing. (This component has no effect on buttons that use pull routing.) Must be used within liveAgent:clientChat. For more information on this component, see Using liveAgent:clientChatQueuePosition. |
| `liveAgent:clientChatCancelButton` | The button within a chat window when the chat is in a waiting state that allows the visitor to cancel the chat. Must be used within liveAgent:clientChat. |
| `liveAgent:clientChatSaveButton` | The button in a chat window that a visitor clicks to save the chat transcript as a local file. Must be used within liveAgent:clientChat. Each chat window can have multiple save buttons. |
| `liveAgent:clientChatEndButton` | The button within a chat window that a visitor clicks to end a chat session. Must be used within liveAgent:clientChat. |
| `liveAgent:clientChatLog` | The area in a chat window that displays the chat conversation to a visitor. Must be used within liveAgent:clientChat. Each chat window can have only 1 chat log. |
| `liveAgent:clientChatInput` | The text box in a chat window where a visitor types messages to a support agent. Must be used within liveAgent:clientChat. Each chat window can have only 1 input box. |
| `liveAgent:clientChatSendButton` | The button in a chat window that a visitor clicks to send a chat message to an agent. Must be used within liveAgent:clientChat. Each chat window can have multiple send buttons. |
| `liveAgent:clientChatLogAlertMessage` | The area in a chat window that displays the idle time-out alert (customer warning) to a visitor. |
| `liveAgent:clientChatFileTransfer` | The file upload area in a chat window where a visitor can send a file to an agent. Must be used within liveAgent:clientChat. |

### Using liveAgent:clientChatQueuePosition

The `liveAgent:clientChatQueuePosition` component shows where in the chat queue a visitor is. In order for a chat to enter the queue:

- The button from which the chat was requested must have queuing enabled.
- All online agents (with the relevant skills, if applicable) must be at capacity, causing a queue to form.
- The chat must be in the queue and not yet assigned to an agent.

If all three of these conditions aren't met, `liveAgent:clientChatQueuePosition` doesn't display a value.

### 커스텀 Chat 윈도우 VF 코드 샘플

[코드샘플 1] — 대기(waiting)·진행(engaged)·종료(ended) 3-state CSS와 컴포넌트 배치를 포함한 전체 윈도우 코드.

```html
<apex:page showHeader="false">
<style>
#liveAgentClientChat.liveAgentStateWaiting {
// The CSS class that is applied when the chat request is waiting to be accepted
// See "Waiting State" screenshot below
}
#liveAgentClientChat {
// The CSS class that is applied when the chat is currently engaged
// See "Engaged State" screenshot below
}
#liveAgentClientChat.liveAgentStateEnded {
// The CSS class that is applied when the chat has ended
// See "Ended State" screenshot below
}
body { overflow: hidden; width: 100%; height: 100%; padding: 0; margin: 0 }
#waitingMessage { height: 100%; width: 100%; vertical-align: middle; text-align: center;
display: none; }
#liveAgentClientChat.liveAgentStateWaiting #waitingMessage { display: table; }
#liveAgentSaveButton, #liveAgentEndButton { z-index: 2; }
.liveAgentChatInput {
height: 25px;
border-width: 1px;
border-style: solid;
border-color: #000;
padding: 2px 0 2px 4px;
background: #fff;
display: block;
width: 99%;
}
.liveAgentSendButton {
display: block;
width: 60px;
height: 31px;
padding: 0 0 3px;
position: absolute;
top: 0;
right: -67px;
}
#liveAgentChatLog {
width: auto;
height: auto;
top: 0px;
position: absolute;
overflow-y: auto;
left: 0;
right: 0;
bottom: 0;
}
</style>
<div style="top: 0; left: 0; right: 0; bottom: 0; position: absolute;">
<liveAgent:clientChat>
<liveAgent:clientChatSaveButton />
<liveAgent:clientChatEndButton />
<div style="top: 25px; left: 5px; right: 5px; bottom: 5px; position: absolute; z-index: 0;">
<liveAgent:clientChatAlertMessage />
<liveAgent:clientChatStatusMessage />
<table id="waitingMessage" cellpadding="0" cellspacing="0">
<tr>
<td>Please wait while you are connected to an available agent.</td>
</tr>
</table>
<div style="top: 0; right: 0; bottom: 41px; left: 0; padding: 0; position: absolute; word-wrap: break-word; z-index: 0;">
<liveAgent:clientChatLog />
</div>
<div style="position: absolute; height: auto; right: 0; bottom: 0; left: 0; margin-right: 67px;">
<liveagent:clientChatInput /><liveAgent:clientChatSendButton />
</div>
</div>
</liveAgent:clientChat>
</div>
</apex:page>
```

원문 그대로 — `<style>` 블록 안 `//` 주석과 `<liveagent:clientChatInput>` 소문자 표기는 PDF 원문 그대로다. 컴포넌트 태그는 대소문자 비구분.

> 스크린샷(PDF 그림, 위키 미수록): "Chat Waiting" / "Chat in Progress" / "Chat Ended"

## Ch7 — Create Post-Chat Pages (개요)

Post-chat 페이지는 채팅이 끝난 직후 방문자에게 보여지는 Visualforce 페이지로, 채팅 세션에 대한 컨텍스트 변수가 URL 파라미터로 전달된다. 이 변수들을 `{!$CurrentPage.parameters.<변수명>}`으로 읽어 종료 후 경험을 커스터마이즈한다.

### post-chat 변수 (전수)

| 변수 | 설명 |
|---|---|
| `requestTime` | The timestamp when the system received the chat request. |
| `startTime` | The timestamp when the agent accepted the chat. |
| `deploymentId` | The ID of the deployment. |
| `buttonId` | The Id of the button that originated the chat. |
| `chatKey` | The unique chat key. |
| `lastVisitedPage` | The last visited page value sent to the agent. |
| `originalReferrer` | The first page the customer visited containing the deployment code. |
| `latitude` | Geo location latitude of the chat visitor. |
| `longitude` | Geo location longitude of the chat visitor. |
| `city` | Geo location city of the chat visitor. |
| `region` | Geo location region of the chat visitor. |
| `country` | Geo location country of the chat visitor. |
| `organization` | Salesforce organization ID that hosted the chat. |
| `disconnectedBy` | Reason for ending the chat. Possible values: (아래 `disconnectedBy` 값 표 참조) |
| `windowLanguage` | Language of the window as configured in the chat button. |
| `chatDetails` | A JSON representation of the chat data. |
| `transcript` | A plain text copy of the transcript. |
| `attachedRecords` | A list of IDs attached to the chat session in JSON array format. |
| `error` | Description of any errors that occurred during the chat. |

### disconnectedBy 값 (5종)

| 값 | 설명 |
|---|---|
| `agent` | the agent terminated the chat |
| `client` | the chat visitor terminated the chat |
| `error` | the system encountered an error that disconnected the chat |
| `clientIdleTimeout` | the chat visitor didn't answer within the allotted time (must have Idle Timeout configured) |
| `agentsUnavailable` | there are no agents available to receive the chat or there is no room in the queue |

### 세션 타임아웃 Note

> **Note:** If the post-chat page is hosted on a site that requires an active session, long-running chats can lead to session timeout. If the customer is on the post-chat page and is redirected to a login page, the post-chat context variables are lost.

### Post-Chat VF 코드 샘플

[코드샘플 2] — 모든 post-chat 파라미터를 렌더하고, `startTime`이 비어 있으면(채팅 미시작 = abandoned) 별도 메시지로 전환하는 JavaScript 포함.

```html
<apex:page showHeader='false'>
      <div id='details'>
      <!-- This will present all the post chat parameters available to this page -->
            <h1>Post Chat Page</h1>
            <p>
            <!-- These variables are passed to the post-chat page and can be used to customize your post-chat experience -->
                  Request Time: <apex:outputText id='c_rt' value='{!$CurrentPage.parameters.requestTime}' /><br/>
                  Start Time: <apex:outputText id='c_st' value='{!$CurrentPage.parameters.startTime}' /><br/>
                  Deployment Id: <apex:outputText value='{!$CurrentPage.parameters.deploymentId}' /><br/>
                  Button Id: <apex:outputText value='{!$CurrentPage.parameters.buttonId}' /><br/>
                  Chat Key: <apex:outputText value='{!$CurrentPage.parameters.chatKey}' /><br />
                  Last Visited Page: <apex:outputText value='{!$CurrentPage.parameters.lastVisitedPage}' /><br/>
                  Original Referrer: <apex:outputText value='{!$CurrentPage.parameters.originalReferrer}' /><br/>
                  <!-- When the GeoLocation is not available this will appear as Unknown -->
                  Latitude: <apex:outputText value='{!$CurrentPage.parameters.latitude}' /><br/>
                  Longitude: <apex:outputText value='{!$CurrentPage.parameters.longitude}' /><br/>
                  City: <apex:outputText value='{!$CurrentPage.parameters.city}' /><br/>
                  Region: <apex:outputText value='{!$CurrentPage.parameters.region}' /><br/>
                  Country: <apex:outputText value='{!$CurrentPage.parameters.country}' /><br/>
                  <!-- End of GeoLocation information -->
                  Organization: <apex:outputText value='{!$CurrentPage.parameters.organization}' /><br/>
                  Disconnected By: <apex:outputText value='{!$CurrentPage.parameters.disconnectedBy}' /><br/>
                  Window Language: <apex:outputText value='{!$CurrentPage.parameters.windowLanguage}' /><br/>
                  Chat Details: <apex:outputText value='{!$CurrentPage.parameters.chatDetails}' /><br />
                  Transcript: <apex:outputText value='{!$CurrentPage.parameters.transcript}' /><br/>
                  Attached Records : <apex:outputText value='{!$CurrentPage.parameters.attachedRecords}' /><br />
                  Error: <apex:outputText value='{!$CurrentPage.parameters.error}' /><br />
            </p>
      </div>
      <hr/>
      <!-- Message to show if chat is abandoned -->
      <div id='abandoned' style='display: none;'>
          We are sorry you decided to leave the chat. Feel free to initiate a new session.
      </div>
      <!-- Code to decide if we show the abandoned block or the full data -->
      <script type='text/javascript'>
            var requestTime = '{!$CurrentPage.parameters.requestTime}';
            var startTime = '{!$CurrentPage.parameters.startTime}';
            // when startTime doesn't have a value, it means the chat never started
            if (!startTime) {
                  document.getElementById('details').style.display = 'none';
                  document.getElementById('abandoned').style.display = 'block';
            }
      </script>
</apex:page>
```

> 스크린샷(PDF 그림, 위키 미수록): post-chat 페이지 렌더(에이전트용) / abandoned-chat 메시지 렌더

## Ch8 — Route Chats to a Specific Agent (개요)

Direct-to-agent 라우팅은 채팅 요청을 버튼의 일반 라우팅 규칙이 아니라 특정 에이전트에게 직접 보낸다. JavaScript Deployment API 호출에 `agentId`(15자 user ID)를 추가 인자로 전달하면 된다.

### Deployment API 메서드 (4종)

이 장에서 사용하는 메서드: `startChat`, `startChatWithWindow`, `showWhenOnline`, `showWhenOffline`.

이들 메서드의 기본 동작·시그니처는 [[Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼]] 참조. 여기서는 direct-to-agent 변형만 다룬다.

샘플 사용 기준(direct-to-agent usage):

- `liveagent.startChat(buttonId)` / `liveagent.startChat(buttonId, agentId)` — agentId = 15자 user ID, 둘째 인자 optional
- `liveagent.showWhenOnline(id, element)` / `liveagent.showWhenOffline(id, element)` — id = 15자 user ID 또는 button ID
- `liveagent.init(chatEndpointUrl, deploymentId, orgId)`
- `startChatWithWindow`은 메서드 목록엔 있으나 샘플에선 미시연

### agentId_buttonId 언더스코어 구문

pre-chat 폼의 `<option>` value에서 `<agentId>_<buttonId>` 형태로 언더스코어 결합하면 "agent로 라우팅하되, 불가능할 경우 button으로 폴백"을 의미한다. (Fallback Routing 섹션의 코드 샘플 참조)

### Direct-to-Agent VF 코드 샘플

[코드샘플 3] — 특정 에이전트의 온라인/오프라인 상태에 따라 직접 채팅 링크, 다른 에이전트로의 버튼 채팅 링크, 전체 불가 메시지를 표시.

```html
<apex:page standardController="User" showHeader="false">
  <h1>Direct-to-Agent Chat with {!user.name}</h1>

  <!-- dta_online is displayed whenever the specific agent is available to chat. -->
  <div id="dta_online" style="display: none;">

    <!-- A valid button is required here even though it's direct-to-agent - some button settings still apply. -->
    <!-- {!left(user.id,15)} is needed to truncate an 18-char ID to the 15-char version that Chat uses. -->
    <a href="javascript://Chat" onclick="liveagent.startChat('573D01234567890', '{!left(user.id,15)}')">Chat with {!user.name}!</a>

  </div>

  <!-- dta_offline is displayed if the specific agent is unavailable. -->
  <div id="dta_offline" style="display: none;">

      <!-- button_online is displayed if any agents are available to chat for the button. -->
    <div id="button_online" style="display: none;">Sorry, {!user.name} is not available. If you&rsquo;d like, you can
      <a href="javascript://Chat" onclick="liveagent.startChat('573D01234567890')">start a chat with another agent</a>.
    </div>

      <!-- button_offline is displayed if no agents are available to chat for the button. -->
    <div id="button_offline" style="display: none;">Sorry, all agents (including {!user.name}) appear to be unavailable.</div>

  </div>

  <!-- Change the live agent pool to the correct one for your org. -->
  <script type='text/javascript' src='https://LiveAgentPool.salesforceliveagent.com/content/g/deployment.js'></script>

  <script type='text/javascript'>
    /* The following calls pass the user ID as the first argument and show whether the agent is online.*/
    liveagent.showWhenOnline('{!left(user.id,15)}', document.getElementById('dta_online'));
    liveagent.showWhenOffline('{!left(user.id,15)}', document.getElementById('dta_offline'));

    /* The following calls pass the button ID as the first argument and show whether
    any agents are available to handle chats from the button. */
    liveagent.showWhenOnline('573D01234567890', document.getElementById('button_online'));
    liveagent.showWhenOffline('573D01234567890', document.getElementById('button_offline'));

    /* The live agent pool and these IDs are specific to your org, so replace these with your own. */
    liveagent.init('https://LiveAgentPool.salesforceliveagent.com/chat', '572D01234567890', '00DD01234567890');
  </script>
</apex:page>
```

When you use this code sample with your org and call it ChatWithMe, agents can create a link that sends a chat request directly to them.

```
http://your.website/ChatWithMe?id=005D01234567890
```

You can make it even easier for agents to send a "chat with me" link by creating a Quick Text message that any agent can use:

```
http://your.website/ChatWithMe?id={!User_ID}
```

The User ID spot in the link is automatically filled with the User ID of any agent who uses the Quick Text.

> **ID legend (예시용 가짜 ID):** `573D...` = LiveChatButton ID · `572D...` = deployment ID · `00DD...` = org ID · `005D...` = User(agent) ID

### Fallback Routing

What if you set up direct-to-agent routing, but the agent you specified to receive the chats isn't available? If the agent is offline, those chats might be lost. Luckily, if your organization uses pre-chat forms to gather customer information, you can set up fallback routing options for a button that uses direct-to-agent routing.

발췌(원문에서 의도적으로 미닫힘) — pre-chat 폼의 라우팅 `<option>` 부분만 발췌:

```html
<h1>Pre-chat Form</h1>
<form method='post' id='prechatForm'>
      Name: <input type='text' name='liveagent.prechat.name' id='prechat_field' /><br />

      Email Address: <input type='text' name='liveagent.prechat:Email' /><br />
      Department: <select name="liveagent.prechat.buttons">
          <!-- Values are LiveChatButton and/or User IDs. -->
          <option value="573D01234567890">Route through button 573D01234567890</option>
          <option value="005D01234567890">Route to agent 005D01234567890</option>
          <option value="005D01234567890_573D01234567890">Route to agent 005D01234567890
            with Fallback to button 573D01234567890</option>
```

In this section, we specify that chats originating from the button should be routed to an agent with agent ID 005xx000001Sv1m. If that agent isn't available, incoming chats are routed based on the default routing rules for the button with button ID 573xx0000000001.

> 주: 원문에서 설명 문장의 ID(`005xx000001Sv1m` / `573xx0000000001`)와 코드의 ID(`005D01234567890` / `573D01234567890`)가 불일치한다 — PDF 원문 그대로.

Key syntax: `<option>` value `005D01234567890_573D01234567890` = `<agentId>_<buttonId>` 언더스코어 결합 = "agent로 라우팅, 불가 시 button으로 폴백".

This sample creates a pre-chat form with fallback routing rules enabled. This form:

- Requests a visitor's name and email address.
- Displays that information in the chat log and in the chat request window.
- Displays either a new or existing Contact record with the customer's information in a new tab in the Salesforce console. The customer's name and email address are used to find an existing record. If no existing record is found, a new record is created and populated with the customer's information.
- Displays a drop-down list that lets visitors choose a different Chat button through which to route their chat request.
- Routes chats directly to a specific agent, or, if that agent is unavailable, routes those chats based on the button's default routing rules.

[코드샘플 4] — Fallback Routing 전체 코드. `domainMatcher` 정규식은 PDF 원문 그대로 character-for-character 복사했다.

```html
<apex:page showHeader="false">

<!-- This script takes the endpoint URL parameter passed from the deployment page
    and makes it the action for the form -->
<script type="text/javascript">

(function() {
      function handlePageLoad() {
            var endpointMatcher = new RegExp("[\\?\\&]endpoint=([^&#]*)");
            var domainMatcher = new RegExp("^(https?:\\/\\/(.+?\\.)?(salesforce|salesforceliveagent)\\.com(\\/[A-Za-z0-9\\-\\._~:\\/\\?#\[\\]@!$&'\\(\\)\*\\+,;\\=]*)?)");

            var endpointAttr = endpointMatcher.exec(document.location.search)[1];
            // if the endpoint domain is valid
            if (domainMatcher.test(decodeURIComponent(endpointAttr))) {
                document.getElementById('prechatForm').setAttribute('action',
                    decodeURIComponent(endpointAttr.replace("javascript:", "")));
            } else {
                // invalid endpoint domain, set the action to empty
                console.error("invalid domain: " + endpointAttr);
                document.getElementById('prechatForm').setAttribute('action', "");
            }
    }
    if (window.addEventListener) {
        window.addEventListener('load', handlePageLoad, false);
    } else {
        window.attachEvent('onload', handlePageLoad, false);
    }
})();
</script>

<h1>Pre-chat Form</h1>
<form method='post' id='prechatForm'>
      Name: <input type='text' name='liveagent.prechat.name' id='prechat_field' /><br />

      Email Address: <input type='text' name='liveagent.prechat:Email' /><br />
      Department: <select name="liveagent.prechat.buttons">
          <!-- Values are LiveChatButton and/or User IDs. -->
          <option value="573D01234567890">Route through button 573D01234567890</option>
          <option value="005D01234567890">Route to agent 005D01234567890</option>
          <option value="005D01234567890_573D01234567890">Route to agent 005D01234567890
        with Fallback to button 573D01234567890</option>
      </select><br />
      <input type='submit' value='Request Chat' id='prechat_submit'/>
</form>

</apex:page>
```

> 주: `domainMatcher` 정규식의 비대칭 이스케이프(`#\[` 는 백슬래시 1개, `\\]` 는 2개; `\*` 1개, `\\+` 2개)는 PDF 원문 그대로이며 정규화하지 말 것. form 필드명 `liveagent.prechat.name`(점) vs `liveagent.prechat:Email`(콜론) 차이도 원문 그대로.

### Quick Text 링크 패턴

Direct-to-agent 페이지(예: 위 ChatWithMe)를 만든 뒤, 에이전트가 자신에게 직접 채팅을 거는 링크를 Quick Text로 손쉽게 배포할 수 있다.

```
http://your.website/ChatWithMe?id={!User_ID}
```

링크의 User ID 자리는 Quick Text를 사용하는 에이전트의 User ID로 자동 채워진다. 따라서 모든 에이전트가 동일한 Quick Text 메시지를 공유하면서도, 각자 자신에게 향하는 "chat with me" 링크를 만들 수 있다.

## 관련 노트
- [[Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼]]
- [[Deployment API — 레코드 자동 검색·생성·자동 채팅 초대 & 코드 샘플]]
- [[Pre-Chat API — 방문자 정보 수집 & 컨텍스트 설정]]
- [[Chat REST API 개요 & 시작]]
- [[Chat REST API 리소스 — 방문자 경험 커스터마이즈]]
- [[Service Cloud Objects]]

> 이 노트(chat_dev_guide) = JavaScript Deployment/Pre-Chat API·Visualforce 기반 웹페이지 임베드 관점. ING-13a(chat_rest) = 네이티브 앱·커스텀 클라이언트용 REST API 관점.
