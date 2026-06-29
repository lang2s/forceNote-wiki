---
tags: [Service, Chat, LiveAgent, DeploymentAPI, JavaScript, Visualforce, 채팅]
source: chat_dev_guide
created: 2026-06-18
aliases: [Chat Developer Guide, Deployment API, enableLogging, showWhenOnline, showWhenOffline, startChat, addButtonEventHandler, 채팅 배포 API, 채팅 로깅, 채팅 버튼]
---

# Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며, **Messaging for In-App and Web**로 이전하세요. 이 노트는 마이그레이션·이력 참조용입니다.

> Chat 개발자 가이드(chat_dev_guide v67.0 Summer '26)의 출발점. 가이드 개요·전제조건·API 버전과, Deployment API의 로깅(`enableLogging`)·윈도우 크기·버튼/시작 메서드(`showWhenOnline/Offline`, `addButtonEventHandler`, `startChat`, `startChatWithWindow`)를 다룬다.

---

## Ch1 — About This Guide (가이드 개요)

Chat은 service 조직이 고객·웹사이트 방문자와 **웹 기반 텍스트 전용 실시간 라이브 채팅**으로 연결되게 한다. 커스텀 코드로 개인화된 채팅 경험을 만들 수 있다. 이 가이드는 커스텀 chat window·button·form·page를 만드는 예제를 제공한다.

**4개 커스터마이즈 영역 (가이드가 보여주는 것):**

- **Deployment API**로 deployment 커스터마이즈
- **Visualforce 페이지·컴포넌트**로 고객용 chat window 외관 커스터마이즈
- 에이전트와 채팅을 시작하기 전에 고객 정보를 모으는 **pre-chat form** 생성
- 채팅 완료 후 고객에게 보여줄 **post-chat page** 생성

이외 컴포넌트는 Salesforce 설정으로 커스터마이즈 가능(Salesforce Help의 "Chat with Customers on Your Website" 참조).

**SEE ALSO:** Salesforce Help: Chat with Customers on Your Website / Embedded Service for Web Developer Guide / Embedded Service SDK for Mobile Devices

> PDF 원문 Important 콜아웃 (이 가이드 전반에 20회 이상 반복 등장 — 본 위키 4노트 중 여기서만 1회 인용):
>
> *"Important: The legacy chat product is scheduled for retirement on February 14, 2026, and is in maintenance mode until then. During this phase, you can continue to use chat, but we no longer recommend that you implement new chat channels. To avoid service interruptions to your customers, migrate to Messaging for In-App and Web before that date. Messaging offers many of the chat features that you love plus asynchronous conversations that can be picked back up at any time. Learn about chat retirement in Help."*

---

## Ch2 — Prerequisites (전제조건)

Chat을 커스터마이즈하기 전에 다음을 확인한다 (전수):

- 조직에서 **Chat이 활성화**되어 있다.
- 관리자가 **Chat feature license**를 부여했다. feature license 없이도 제품을 커스터마이즈할 수는 있으나, 라이선스가 있어야 커스터마이즈를 접근·테스트할 수 있다.
- **Salesforce site를 만들고**, chat 버튼·윈도우용 이미지를 static resource로 업로드했다. Salesforce site 없이 Chat을 커스터마이즈하려면 이 단계는 건너뛴다.

> Note: Chat 커스텀 chat 페이지에 Salesforce site를 사용할 때 URL에 `/liveagent` 경로를 쓰지 마라. 이 경로는 incoming/outgoing 채팅 알림음에서 오류를 일으켜 에이전트가 채팅 업데이트를 듣지 못하게 할 수 있다.

---

## Ch3 — API Versions

Chat API의 버전마다 사용 가능한 메서드·파라미터가 다르다. Deployment API나 Pre-Chat API로 개발하기 전에 코드에서 올바른 API 버전 번호를 쓰는지 확인한다.

> 방문자측 REST API의 버전 헤더와는 별개다. REST 관점은 [[Chat REST API 개요 & 시작]] 참조.

### Deployment API Versions

조직의 Deployment API 버전은 deployment 생성 후 자동 생성된 deployment code에서 확인한다.

- **Summer '13 이전** → **version 28.0** 지원. URL (28.0):
  `https://MyDomainName.my.salesforce-scrt.com/content/g/deployment.js`
- **Winter '14** → **version 29.0** 지원. URL (29.0, 경로에 버전 번호 포함):
  `https://MyDomainName.my.salesforce-scrt.com/content/g/js/29.0/deployment.js`

> Note: deployment에서 새 메서드·파라미터를 쓰려면 각 웹 페이지의 deployment code를 version 29.0 URL로 업데이트해야 한다.

### Pre-Chat Information API Versions

- **Winter '14** → Pre-Chat API **version 29.0** 지원. URL (29.0, 경로에 버전 번호 포함):
  `https://MyDomainName.my.salesforce-scrt.com/content/g/js/29.0/prechat.js`
- 조직의 hostname은 deployment 생성 후 생성되는 deployment code에서 확인한다.

---

## Ch4 — Customize Deployments with the Deployment APIs

deployment 생성 시 자동 생성되는 코드에 추가 스크립트로 아래 메서드들을 넣어 deployment를 커스터마이즈한다.

### enableLogging

특정 deployment에서 로깅을 활성화한다. **API versions 28.0 이상.**

**Usage:** 특정 deployment에서 로깅을 활성화하여, 웹 브라우저의 JavaScript 콘솔이 해당 deployment 내에서 일어나는 활동 정보를 저장하게 한다. 브라우저 개발자 콘솔에서 정보를 조회할 수 있다.

**Syntax:** `liveagent.enableLogging();`

**Parameters:** None

#### Messages for Logged Events (36행 전수 — Message / Triggered / Meaning)

> 표 dimension: 36행 × 3열. row = 개별 로그 메시지, col1 = Message, col2 = Triggered, col3 = Meaning. (scout/task의 "30행"은 오기 — PDF 실제 36행.)

| # | Message | Triggered | Meaning |
|---|---|---|---|
| 1 | System initialized. Waiting for the DOM to be ready. | When liveagent.init() is called, usually at page load | Chat endpoint URL, org ID and deployment ID have been set, now waiting for DOM to be ready before continuing. |
| 2 | No available event model. Exiting. | During liveagent.init(), if there is an error | This means no DOM event listener was found, which would be very rare. We would not be able to continue at this point, so it would be a hard stop. |
| 3 | DOM is ready. Setting up environment. | Upon DOM ready of the page | The page has fully loaded and the DOM is ready, so we perform our first "ping" to the server, which is to get the settings/information about the given deployment ID. |
| 4 | Setting state for button {Button ID} to online | When the state of a button has changed to online | The button is available for a chat request to be made. |
| 5 | Setting state for button {Button ID} to offline | When the state of a button has changed to offline | The button is not available for a chat request to be made. |
| 6 | Requesting new session | During the first ping to the server | No session ID cookie was found, so a new one must be generated. This means it was the first time visiting the site with this deployment code for this browsing session. |
| 7 | Reusing existing session | During the first ping to the server | A session cookie exists, so it is reused. This means the visitor has already been to this site during this browsing session (e.g., going from one page to another). |
| 8 | Received new session ID | As a response to the first ping | The server generated a new session ID, and it is being stored as a session cookie named "liveagent_sid." |
| 9 | Ping rate set to {Rate}ms | As a response to the first ping | Indicates how frequently (in milliseconds) the page will ping the Chat server. The default is 50000 (50 seconds). This effectively indicates when button refreshes will occur. |
| 10 | Pinging server to keep presence | When a ping to the server is made | Indicates the visitor is still connected to and pinging the Chat server, meaning no errors or disconnects have occurred. |
| 11 | Disconnecting from Chat | When an error occurs | An error was thrown, whether in response from the server or due to network connectivity issues. Indicates that the visitor will no longer ping Chat for this page load (i.e., they will need to refresh). |
| 12 | Received updated Chat server url: {URL}! Consider updating this site's deployment code. | When an org has moved to a new core instance | The Chat instance specified in the deployment code is no longer valid for this org, so the new URL has been provided. For better performance, we recommend updating the deployment code if they receive this. |
| 13 | Server Warning: {Message} | A non-fatal exception occurred | A warning condition was encountered, but processing can continue. The message provides further details. |
| 14 | Server sent an anonymous warning | A non-fatal exception occurred | A warning condition was encountered, but processing can continue. No message was provided. |
| 15 | Server Error: {Message} | A fatal exception occurred | An error condition was encountered, and processing cannot be continued. The message provides further details. |
| 16 | Server responded with an error | A fatal exception occurred | An error condition was encountered, and processing cannot be continued. No message was provided. |
| 17 | Group Start: Invite {Button ID} Rule Evaluation | Rule evaluation has been triggered | Evaluation of the filter logic for the given invite button ID has begun. This means the button is online and available for chat, and the filter logic will be used to determine if it should be displayed/presented or not. |
| 18 | Filter Logic: {Filter Logic} | Rule evaluation has been triggered | An information log containing the string representation of the filter logic of the invite rules as specified in the admin setup area. Useful to understand how the rules will be evaluated. |
| 19 | Evaluating StandardInviteRule | When a standard rule is being evaluated | Standard rules are "Number of Page Views" and "URL Match." They are part of the out-of-the-box rules that are provided in the admin setup area. |
| 20 | Evaluating TimerInviteRule | When a timer-based rule is being evaluated | Timer-based rules are "Seconds on Page" and "Seconds on Site." They are part of the out-of-the-box rules as well, except these rules will be re-evaluated again in the future when the required number of seconds has passed if the criteria was not met the first time (e.g., on page load). |
| 21 | Evaluating CustomInviteRule | When a custom rule is being evaluated | "Custom Variable" rules allow variable names to be specified which will be compared against upon evaluating these rules. The "setCustomVariable" API is used in conjunction with these to specify the value to compare with against the value specified in the admin setup area. |
| 22 | CustomInviteRule evaluation failed due to missing custom variable | When a custom rule is being evaluated | A "Custom Variable" rule was set up, but the "setCustomVariable" API was never called with this variable name specified, therefore the rule can not be evaluated. |
| 23 | Evaluate: {From Value} == {To Value} | When a rule with an "equals" comparator is being evaluated | A rule is being evaluated by comparing that the two values match exactly. |
| 24 | Not Equals - Evaluate: {From Value} != {To Value} | When a rule with a "not equal to" comparator is being evaluated | A rule is being evaluated by comparing that the two values do not match. |
| 25 | Starts With - Evaluate: {From Value} indexOf {To Value} == 0 | When a rule with a "starts with" comparator is being evaluated. | A rule is being evaluated by comparing that the first value starts with the second value. |
| 26 | Contains - Evaluate: {From Value} indexOf {To Value} != -1 | When a rule with a "contains" comparator is being evaluated | A rule is being evaluated by comparing that the first value contains the second value. |
| 27 | Does Not Contain - Evaluate: {From Value} indexOf {To Value} == -1 | When a rule with a "does not contain" comparator is being evaluated | A rule is being evaluated by comparing that the first value does not contain the second value. |
| 28 | Less Than - Evaluate: {From Value} < {To Value} | When a rule with a "less than" comparator is being evaluated | A rule is being evaluated by comparing that the first value is less than the second value. |
| 29 | Greater Than - Evaluate: {From Value} > {To Value} | When a rule with a "greater than" comparator is being evaluated | A rule is being evaluated by comparing that the first value is greater than the second value. |
| 30 | Less or Equal - Evaluate: {From Value} <= {To Value} | When a rule with a "less or equal" comparator is being evaluated | A rule is being evaluated by comparing that the first value is less than or equal to the second value. |
| 31 | Greater or Equal - Evaluate: {From Value} >= {To Value} | When a rule with a "greater or equal" comparator is being evaluated | A rule is being evaluated by comparing that the first value is greater than or equal to the second value. |
| 32 | Evaluating Atom Node: {Rule ID} | When a rule is being evaluated | Indicates that an actual rule is being evaluated. |
| 33 | Group Start: Evaluating And Node | When two rules are being evaluated with an "AND" clause | When multiple rules are used, this indicates when the criteria of a pair of rules must both be "true." |
| 34 | Group Start: Evaluating Or Node | When two rules are being evaluated with an "OR" clause | When multiple rules are used, this indicates when the criteria of a pair of rules must be "true" for one of them. |
| 35 | Group Start: Evaluating Not Node | When two rules are being evaluated with a "NOT" clause | This indicates to check for the opposite of what the criteria evaluates to. |
| 36 | Setting invite delay to: {Invite Delay} | When a timer-based rule has not yet met the criteria | If the criteria for a timer-based rule is not met, a delay is set to attempt to evaluate the rules again in the future when the criteria will have been met. |

### Customize Your Chat Window with the Deployment APIs (윈도우 크기)

고객용 chat window의 크기를 커스터마이즈한다. **모바일 브라우저에는 적용되지 않는다**(모바일에서는 채팅이 전체 페이지로 열린다). 아래 메서드를 deployment 생성 시 자동 생성된 코드에 추가 스크립트로 넣는다.

#### setChatWindowHeight

chat window의 높이를 커스터마이즈한다.

**Usage:** 고객에게 보이는 chat window의 높이를 픽셀 단위로 설정한다. API versions 28.0 이상.

**Syntax:** `void setChatWindowHeight(Number height)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| height | Number | The height in pixels of your custom chat window. | Available in API versions 28.0 and later. |

#### setChatWindowWidth

chat window의 너비를 커스터마이즈한다.

**Usage:** 고객에게 보이는 chat window의 너비를 픽셀 단위로 설정한다. API versions 28.0 이상.

**Syntax:** `void setChatWindowWidth(Number width)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| width | Number | The width in pixels of your custom chat window. | Available in API versions 28.0 and later. |

### Customize Chat Buttons with the Deployment APIs (버튼·채팅 시작)

각 chat button에는 웹사이트에 배치하는 코드가 포함되어 고객이 채팅을 시작할 수 있다. Chat은 에이전트 가용성과 조직 설정에 따라 버튼 가용성을 자동으로 처리하고, 버튼에서의 채팅 요청 시작도 처리한다. 아래 메서드를 deployment 코드에 추가 스크립트로 넣는다.

#### showWhenOnline

특정 버튼이 온라인일 때 고객에게 무엇을 보여줄지 지정한다.

**Usage:** 지정한 버튼·에이전트·에이전트(버튼 fallback 포함)가 온라인일 때 특정 element를 표시한다. API versions 28.0 이상.

**Syntax (3 forms):**

```javascript
// 버튼용 — userId는 선택
void showWhenOnline(String buttonId, Object element, (optional) String userId)
// 에이전트용 — buttonId 대신 userId 사용
void showWhenOnline(String userId, Object element)
// 에이전트 + 버튼 fallback — 두 ID 모두 사용 (에이전트 또는 버튼 중 하나라도 온라인이면 element 표시)
void showWhenOnline(String buttonId, Object element, String userId)
```

> Note: buttonId와 userId를 함께 쓸 때는 항상 buttonId가 먼저 와야 한다.

| Name | Type | Description | Available Versions |
|---|---|---|---|
| buttonId | String | The ID of the chat button for which to display the specified element object when agents that are associated with the button are available to chat. | Available in API versions 28.0 and later |
| element | Object | The element to be displayed when the specified button is online. | Available in API versions 28.0 and later |
| userId | String | The ID of the agent to associate with the button. The element object is displayed when that agent is available. | Available in API versions 28.0 and later |

- buttonId만 있고 userId가 없으면 → 버튼이 온라인일 때만 element 표시.
- userId만 있고 buttonId가 없으면 → 에이전트가 온라인일 때만 element 표시. 예 (에이전트 온라인 상태를 추적해 가용 시 버튼을 온라인으로 설정):

```javascript
liveagent.showWhenOnline('005xx000001Sv1m',
document.getElementById('liveagent_button_toAgent_online'));
```

- buttonId와 agentId를 모두 지정하면 → 버튼 또는 에이전트 중 하나라도 온라인이면 element 표시. 예 (적어도 한 명의 skilled 에이전트가 가용하면 표시):

```javascript
liveagent.showWhenOnline('573xx0000000006',
document.getElementById('liveagent_button_online_573xx0000000006_USER1'), '005xx000001Sv1m');
```

#### showWhenOffline

특정 버튼이 오프라인일 때 고객에게 무엇을 보여줄지 지정한다.

**Usage:** 지정한 버튼·에이전트·에이전트(버튼 fallback 포함)가 오프라인일 때 특정 element를 표시한다. API versions 28.0 이상.

**Syntax (3 forms):**

```javascript
// 버튼용 — userId는 선택
void showWhenOffline(String buttonId, Object element, (optional) String userId)
// 에이전트용 — buttonId 대신 userId 사용
void showWhenOffline(String userId, Object element)
// 에이전트 + 버튼 fallback — 두 ID 모두 사용 (에이전트 또는 버튼 중 하나라도 오프라인이면 element 표시)
void showWhenOffline(String buttonId, Object element, String userId)
```

> Note: buttonId와 userId를 함께 쓸 때는 항상 buttonId가 먼저 와야 한다.

| Name | Type | Description | Available Versions |
|---|---|---|---|
| buttonId | String | The ID of the chat button for which to display the specified element object when no agents are available to chat. | Available in API versions 28.0 and later |
| element | Object | The element to display when the specified button is offline. | Available in API versions 28.0 and later |
| userId | String | The ID of the agent to associate with the button. The element object is displayed when that agent is unavailable. | Available in API versions 28.0 and later |

- buttonId만 있고 userId가 없으면 → 버튼이 오프라인일 때만 element 표시.
- userId만 있고 buttonId가 없으면 → 에이전트가 오프라인일 때만 element 표시. 예:

```javascript
liveagent.showWhenOffline('005xx000001Sv1m',
document.getElementById('liveagent_button_toAgent_offline'));
```

- buttonId와 agentId를 모두 지정하면 → 버튼도 에이전트도 가용하지 않을 때 element 표시. 예:

```javascript
liveagent.showWhenOffline('573xx0000000006',
document.getElementById('liveagent_button_offline_573xx0000000006_USER1'),
'005xx000001Sv1m');
```

#### addButtonEventHandler (버튼판)

특정 이벤트 발생 시 chat button의 동작을 정의한다. API versions 28.0 이상.

> 자동 채팅 초대용 `addButtonEventHandler` 오버로드(BUTTON_ACCEPTED/BUTTON_REJECTED 포함 4개 event type)는 [[Deployment API — 레코드 자동 검색·생성·자동 채팅 초대 & 코드 샘플]] 참조. 여기서는 버튼판(2개 event type)만 다룬다.

**Usage:** 다음 이벤트 발생 시 chat button의 동작을 정의한다.

- An agent is available to chat.
- No agents are available to chat.

"No agents are available to chat" 이벤트는 설정된 chat button으로 채팅이 에이전트에 도달할 수 없을 때 발생하며, 구체적으로 다음 경우다:

- No agents are online.
- No agents assigned to the skills associated with the button are online.
- Online agents have the status Away.
- Online agents are at capacity (set with Chat Configurations, or Presence Configurations with Omni-Channel).
- Online agents are using Omni-Channel and are only available for other service channels.

**Syntax:** `void addButtonEventHandler(String buttonId, Function callback)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| buttonId | String | The ID of the chat button for which to define the behavior when certain events occur. | Available in API versions 28.0 and later |
| callback | function | The function to call when a particular event occurs. You must specify the button's behavior for each of the required event types. | Available in API versions 28.0 and later |

**Event Types (버튼판 — 2행):**

| Function | Event Type | Syntax | Description |
|---|---|---|---|
| callback | BUTTON_AVAILABLE | `liveagent.BUTTON_EVENT.BUTTON_AVAILABLE` | Specifies the behavior of the button when the criteria are met for customers to be able to chat with an agent, such as when an agent with the correct skills is available to chat. |
| callback | BUTTON_UNAVAILABLE | `liveagent.BUTTON_EVENT.BUTTON_UNAVAILABLE` | Specifies the behavior of the button when no agents are available to chat. |

#### startChat

새 윈도우에서 버튼으로부터 채팅을 요청한다.

**Usage:** 제공된 버튼에서 새 윈도우로 채팅을 요청한다. 선택적으로 특정 버튼에서의 채팅을 지정한 `userId`의 에이전트로 직접 라우팅할 수 있다. 그 에이전트가 가용하지 않으면 버튼의 라우팅 규칙으로 fallback할지(`true`) 아닐지(`false`)를 지정해 추가 에이전트로 라우팅할 수 있다.

**Syntax:** `void startChat(String buttonId, (optional) String userId, (optional) Boolean fallback)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| buttonId | String | The ID of the chat button for which to request a chat in a new window. | Available in API versions 28.0 and later |
| (Optional) userId | String | The Salesforce user ID of the agent to whom to directly route chats from the button. | Available in API versions 29.0 and later. |
| (Optional) fallback | Boolean | Specifies whether to fall back to the button's routing rules (true) or not (false) if the agent with the specified sfdcUserId is unavailable. | Available in API versions 29.0 and later. |

> direct-to-agent 라우팅의 실제 구현·코드 샘플은 [[커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅]] 참조.

#### startChatWithWindow

윈도우 이름을 사용해 버튼으로부터 채팅을 요청한다.

**Usage:** 제공된 버튼에서 제공된 윈도우 이름을 사용해 채팅을 요청한다. API versions 28.0 이상.

**Syntax:** `void startChatWithWindow(String buttonId, String windowName, (optional) String userId, (optional) Boolean fallback)`

| Name | Type | Description | Available Versions |
|---|---|---|---|
| buttonId | String | The ID of the chat button for which to request a chat in a new window. | Available in API versions 28.0 and later. |
| windowName | String | The name of the window. | Available in API versions 28.0 and later. |
| (Optional) userId | String | The Salesforce user ID of the agent to whom to directly route chats from the button. | Available in API versions 29.0 and later |
| (Optional) fallback | Boolean | Specifies whether to fall back to the button's routing rules (true) or not (false) if the agent with the specified sfdcUserId is unavailable. | Available in API versions 29.0 and later |

#### Corresponding Calls for Chat Buttons

채팅이 올바르게 시작되도록 button·direct-to-agent·agent with fallback-to-button 사용 시 호출을 정렬한다. `startChat`의 syntax는 `startChatWithWindow`에도, `showWhenOnline`의 syntax는 `showWhenOffline`에도 동일하게 적용된다.

> 표 dimension: 3행 × 4열. row = Scenario, col = 각 메서드 호출.

| Scenario | Call to startChat (or startChatWithWindow) | Call to showWhenOnline (or showWhenOffline) | Call to addButtonEventHandler |
|---|---|---|---|
| Button | `startChat(String buttonId)` | `showWhenOnline(String buttonId, Object element, (optional) String userId)` | `addButtonEventHandler(String buttonId, Function callback)` |
| Agent (no fallback) | `startChat(String buttonId, String userId, false)` | `showWhenOnline(String userId, Object element)` | `addButtonEventHandler(String userId, Function callback)` |
| Agent (fallback to button) | `startChat(String buttonId, String userId, true)` | `showWhenOnline(String buttonId, Object element, String userId)` | Use multiple handlers. |

---

## 관련 노트

- [[Deployment API — 레코드 자동 검색·생성·자동 채팅 초대 & 코드 샘플]]
- [[Pre-Chat API — 방문자 정보 수집 & 컨텍스트 설정]]
- [[커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅]]
- [[Chat REST API 개요 & 시작]]
- [[Tooling API 객체 — Embedded Service (임베디드 챗·채널 메뉴·약속관리)]] — 임베디드 챗·스냅인 위젯의 Tooling API 설정 sObject(EmbeddedServiceLiveAgent 등)

> 이 노트(chat_dev_guide) = JavaScript Deployment/Pre-Chat API·Visualforce 기반 웹페이지 임베드 관점. ING-13a(chat_rest) = 네이티브 앱·커스텀 클라이언트용 REST API 관점.
