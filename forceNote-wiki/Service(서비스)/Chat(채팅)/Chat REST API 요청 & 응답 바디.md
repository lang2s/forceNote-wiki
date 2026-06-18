---
tags: [Service, Chat, ChatREST, RequestBody, ResponseBody, JSON, REST-API]
source: chat_rest
created: 2026-06-18
aliases: [Chat REST request bodies, Chat REST response bodies, ChasitorInit body, Settings response, SwitchServer, 요청 바디, 응답 바디, button enum]
---

# Chat REST API 요청 & 응답 바디

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며, **Messaging for In-App and Web**로 이전하세요. 이 노트는 마이그레이션·이력 참조용입니다.

> Ch7의 9개 요청 바디와 Ch8의 19개 응답 바디 각각에 대해, 속성 표(이름/타입/설명/버전)와 JSON 예시를 전수 정리한다. PDF 원문에 있던 오타·포맷 quirk도 마커와 함께 그대로 재현한다.

---

## Ch7 — Request Bodies for Chat REST API

> *"To perform a POST or GET request, pass query parameters or create a request body that's formatted in JSON. Request bodies can contain one or more other request bodies that are nested inside. Each request body can contain unique request properties."*

### 1. Breadcrumb

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| location | String | The URL of the web page that the chat visitor is viewing. | 29.0 |

```json
"location":{
    "type":"string",
    "description":"The current location or URL of the visitor",
    "required":true,
    "version":29.0
}
```

### 2. ChasitorInit

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| organizationId | String | The chat visitor's Salesforce organization ID. | 29.0 |
| deploymentId | String | The ID of the deployment from which the chat originated. | 29.0 |
| buttonId | String | The ID of the button from which the chat originated. | 29.0 |
| agentId | String | The ID of the agent of a direct-to-agent chat request. For normal chat requests, leave this field empty. | 29.0 |
| doFallback | Boolean | Specifies the fallback mode if agentId is present. If the value is false, it attempts to route the chat session back to that specific agent. If the value is true, it attempts to route the chat session back to the specific agent first but, if the agent is unavailable, it attempts to route to the button next. | 29.0 |
| sessionId | String | The chat visitor's Chat session ID. | 29.0 |
| userAgent | String | The chat visitor's browser user agent. | 29.0 |
| language | String | The chat visitor's spoken language. | 29.0 |
| screenResolution | String | The resolution of the chat visitor's computer screen. | 29.0 |
| visitorName | String | The chat visitor's custom name. | 29.0 |
| prechatDetails | Array of CustomDetail objects | The pre-chat information that was provided by the chat visitor. | 29.0 |
| prechatEntities | Array of Entity objects | The records created, searched for, or both depending on what EntityFieldsMaps (on page 56) has enabled. | 29.0 |
| buttonOverrides | Array of Strings | The button override is an ordered list of routing targets and overrides the buttonId, agentId, and doFallback modes. The possible options are: • `buttonId`—Normal routing • `agentId`—Direct-to-agent routing with no fallback • `agentId_buttonId`—Direct-to-agent routing with fallback to the button. You can list one or more of these options, where the order specifies the routing target order. The second or third target is attempted only if the previous one fails. | 29.0 |
| receiveQueueUpdates | Boolean | Indicates whether the chat visitor receives queue position updates (true) or not (false). | 29.0 |
| isPost | Boolean | Indicates whether the chat request was made properly through a POST request (true) or not (false). | 29.0 |

```json
{
    organizationId: "00DD0000000JVXs",
    deploymentId: "572D000000000J6",
    buttonId: "573D000000000OC",
    agentId: "005B0000000F3b2",
    doFallback: true,
    sessionId: "5503f854-0203-4324-8ed5-f793a367426f",
    userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36",
    language: "en-US",
    screenResolution: "2560x1440",
    visitorName: "Jon A.",
    prechatDetails: [
        {
            label: "E-mail Address",
            value: "jon@example.com",
            entityFieldMaps: [
               {
                    entityName: "Contact",
                    fieldName: "Email",
                    isFastFillable: false,
                    isAutoQueryable: true,
                    isExactMatchable: true
               }
            ],
            transcriptFields: [
                    "c__EmailAddress"
            ],
            displayToAgent: true
        }
    ],
    prechatEntities: [],
    buttonOverrides: [
            "573D000000000OD"
    ],
    receiveQueueUpdates: true,
    isPost: true
}
```

### 3. ChasitorResyncState

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| organizationId | String | The chat visitor's Salesforce organization ID. | 29.0 |

```json
{
    organizationId: "00DD0000000JVXs"
}
```

### 4. ChasitorSneakPeek

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| position | integer | The position of the Sneak Peek update in the chat. | 29.0 |
| text | String | The text that the chat visitor is typing in the text input area of the chat window. | 29.0 |

```json
{
    position: 3,
    text: "Hi there."
}
```

### 5. ChatMessage

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| text | String | The text of the chat visitor's message to the agent. | 29.0 |

```json
{
    text: "I have a question about my account."
}
```

### 6. CustomEvent

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| type | String | The type of custom event that occurred, used for adding the event listener on the agent's side. | 29.0 |
| data | String | Data that's relevant to the event that was sent to the agent. | 29.0 |

```json
{
    type: "PromptForCreditCard",
    data: "Visa"
}
```

### 7. MultiNoun

| Name | Type | Description | Available Versions |
|---|---|---|---|
| nouns | Array of NounWrapper objects | An array of noun objects and their properties that are batched in the MultiNoun request. | 29.0 |

```json
{
    nouns: [
        {
            prefix: "Chasitor",
            noun: "ChatMessage",
            object: {
                text: "Goodbye"
            }
        },
        {
            prefix: "Chasitor",
            noun: "ChatEnd",
            object: {}
        }
    ]
}
```

### 8. SensitiveDataRuleTriggered for Agents

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| rules | Array of Rule objects | A list of sensitive data rules applied to the chat session. | 29.0 |
| chatId | String | The ID of the chat session. | *(PDF에 이 행의 Available Versions 값 없음)* |

```json
{
    "rules": [
        { "name": "Replace-Bad-Word" },
        { "name": "Filter-Out-Digits" }
    ],
    "chatId": "1a240b1a-f60e-456d-9f77-41cbfa7b9159"
}
```

### 9. SensitiveDataRuleTriggered for Chasitors

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| rules | Array of Rule objects | A list of sensitive data rules applied to the chat session. | 29.0 |

```json
{
    "rules": [
        { "id": "0GORM00000001dM", "name": "Replace-Bad-Word" },
        { "id": "0GORM00000001dW", "name": "Filter-Out-Digits" }
    ]
}
```

---

## Ch8 — Response Bodies for Chat REST API

> *"A request to a Chat REST API resource returns a response code. The successful execution of a resource request can also return a response body in JSON format."*

> Ch8에는 **19개의 응답 바디**가 있다. PDF 순서: Availability, ChasitorSessionData, ChasitorIdleTimeoutWarningEvent, ChatEndReason, ChatEstablished, ChatMessage, ChatRequestFail, ChatRequestSuccess, ChatTransferred, CustomEvent, Messages, NewVisitorBreadcrumb, QueueUpdate, ReconnectSession, SensitiveDataRules, SessionId, Settings, SwitchServer, VisitorId.

### 1. Availability

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| results | Array of Result objects | A list of Salesforce IDs that correspond to agents and chat buttons and their respective availability to receive new chat requests. | 29.0 |

```json
{
"results":{
    "type":"array",
    "description":"List of valid patterns of IDs and their availability.",
    "items":{
       "name":"result",
       "type":"object",
       "properties":{
           "id":{
               "type":"string",
               "description":"ID of the entity.",
               "required":true,
               "version":29.0
           },
           "isAvailable":{
               "type":"boolean",
               "description":"Whether or not the entity is available for chat.",
               "version":29.0
           }
       }
    },
    "required":true,
    "version":29.0
    }
}
```

### 2. ChasitorSessionData

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| queuePosition | integer | The position of the chat visitor in the chat queue. | 29.0 |
| geoLocation | GeoLocation object | The chat visitor's location, based on the IP address from which the request originated. | 29.0 |
| url | String | The URL that the chat visitor is visiting. | 29.0 |
| oref | String | The original URL that the chat request came from. | 29.0 |
| postChatUrl | String | The URL to which to redirect the chat visitor after the chat has ended. | 29.0 |
| sneakPeekEnabled | Boolean | Whether Sneak Peek is enabled for the agent who accepts the chat. | 29.0 |
| chatMessages | Array of TranscriptEntry objects | The chat message structure that's synchronized across the agent.js and chasitor.js files. | 29.0 |

```json
{
    queuePosition: 1,
    geoLocation: {
        countryCode: "US",
        countryName: "United States of America",
        region: "CA",
        city: "San Francisco",
        organization: Salesforce,
        latitude: 37.793880,
        longitude: -122.395114
    },
    url: "http://yoursite",
    oref: "http://www.google.com?q=yoursite",
    postChatUrl: "http://yoursite/postchat",
    sneakPeekEnabled: true,
    chatMessages: [
        {
            type: "Agent",
            name: "Andy L.",
            content: "Hello, how can I help you?",
            timestamp: 1376596367548,
            sequence: 1
        },
        {
            type: "Chasitor",
            name: "Jon A.",
            content: "I have a question for you.",
            timestamp: 1376596349132
            sequence: 2
        }
    ]
}
```
<!-- [PDF verbatim — typo/quirk] 위 timestamp 1376596349132 뒤의 콤마가 PDF 원문에 누락되어 있음 -->

### 3. ChasitorIdleTimeoutWarningEvent

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| idleTimeoutWarningEvent | String | Informs the server when a warning is triggered or cleared. Possible values: `triggered` and `cleared`. | 35.0 |

### 4. ChatEndReason

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| reason | String | The reason that the chat ended. | 29.0 |
| attachedRecords | String | Returns a list of record IDs mapped to the chat's transcript object with the corresponding transcript field names containing those mappings. This mapping data is useful for enhancing your post chat implementation. Available if post-chat is enabled on the chat button. If the client uses attachedRecords post chat and a chasitor ends the chat without the client receiving the ChatEnded response, call Messages again after calling ChatEnd. | 29.0 |

### 5. ChatEstablished

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| name | String | The name of the agent who is engaged in the chat. | 29.0 |
| userId | String | The user ID of the agent who is engaged in the chat. | 29.0 |
| sneakPeekEnabled | Boolean | Whether Sneak Peek is enabled for the agent who accepts the chat. | 29.0 |
| chasitorIdletimeout | ChasitorIdleTimeoutSettings | Gives the settings for chat visitor idle time-out. | 35.0 |

```json
{
    name: "Andy L.",
    userId: "f1dda237-57f8-4816-b8e8-59775f1e44c8",
    sneakPeekEnabled: true
}
```

> `chasitorIdletimeout`의 타입 `ChasitorIdleTimeoutSettings`는 타입으로만 참조되며, Ch9에 **독립 정의(standalone Data Type 섹션)가 PDF에 없다.** 따라서 이 타입의 필드를 임의로 작성하지 않는다.

### 6. ChatMessage

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| name | String | The name of the agent who is engaged in the chat. | 29.0 |
| text | String | The text of the chat message that the agent sent to the chat visitor. | 29.0 |

```json
{
    name: "Andy L."
    text: "Hello, how can I help you?"
}
```
<!-- [PDF verbatim — typo/quirk] 위 "Andy L." 뒤의 콤마가 PDF 원문에 누락되어 있음 -->

### 7. ChatRequestFail

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| reason | String | The reason why the chat request failed—for example, no agents were available to chat or an internal error occurred. | 29.0 |
| postChatUrl | String | The URL of the post-chat page to which to redirect the chat visitor after the chat has ended. | 29.0 |

```json
{
    reason: "Unavailable",
    postChatUrl: "http://yoursite/postChat"
}
```

### 8. ChatRequestSuccess

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| queuePosition | integer | The position of the chat visitor in the chat queue. | 29.0 |
| estimatedWaitTime | number | The estimated wait time for the button in seconds. If the server cannot retrieve the wait time, this property returns -1. | 47.0 |
| geoLocation | GeoLocation object | The chat visitor's location, based on the IP address from which the request originated. | 29.0 |
| url | String | The URL that the chat visitor is visiting. | 29.0 |
| oref | String | The original URL that the chat request came from. | 29.0 |
| postChatUrl | String | The URL to which to redirect the chat visitor after the chat has ended. | 29.0 |
| customDetails | Array of CustomDetail objects | The custom details of the deployment from which the chat request was initiated. | 29.0 |
| visitorId | String | The ID of the chat visitor. | 29.0 |

```json
"{
    queuePosition: 1,
    estimatedWaitTime: 120,
    geoLocation: {
        countryCode:"US",
        countryName: "United States of America",
        region: "CA",
        city: "San Francisco",
        organization: Salesforce,
        latitude: 37.793880,
        longitude: -122.395114
    },
    url: "http://yoursite",
    oref: "http://www.google.com?q=yoursite",
    postChatUrl: "http://yoursite/postchat",
    customDetails: [
        {
            label: "E-mail Address",
            value: "jon@example.com",
            transcriptFields: [
                 "c__EmailAddress"
            ],
            displayToAgent: true
        }
    ],
    visitorId: "acd47048-bd80-476e-aa33-741bd5cb05d3"
}"
```
<!-- [PDF verbatim — typo/quirk] PDF가 이 예시 전체를 stray 큰따옴표 "{ ... }" 로 감싸고 있음 -->

### 9. ChatTransferred

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| name | String | The name of the agent to whom the chat was transferred. | 29.0 |
| userId | String | The ID of the chat visitor. | 29.0 |
| sneakPeekEnabled | Boolean | Whether Sneak Peek is enabled for the agent to whom the chat was transferred. | 29.0 |
| chasitorIdletimeout | ChasitorIdleTimeoutSettings | Gives the settings for chat visitor idle time-out. | 35.0 |

```json
{
    name: "Ryan S.",
    userId: "edacfa56-b203-43d5-9e1b-678278b61263",
    sneakPeekEnabled: false
}
```

### 10. CustomEvent

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| type | String | The type of custom event that occurred, used for adding the event listener on the chat visitor's side. | 29.0 |
| data | String | Data that's relevant to the event that was sent to the chat visitor. | 29.0 |

```json
{
    type: "CreditCardEntered",
    data: "5105105105105100"
}
```

### 11. Messages

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| messages | Array of Message objects | The messages that were sent over the course of a chat. | 29.0 |
| offset | integer | An internal number to be used with a ReconnectSession request that tracks which messages your client has received. | 29.0 |
| sequence | integer | The sequence of the message as it was received over the course of a chat. | 29.0 |

```json
{
    messages: [
        {
            type: "ChatEstablished",
            message: {
                name: "Andy L.",
                userId: "f1dda237-57f8-4816-b8e8-59775f1e44c8",
                sneakPeekEnabled: true
            }
        }
    ],
    sequence: 1,
    offset: 1234567890
}
```

### 12. NewVisitorBreadcrumb

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| location | String | The URL of the web page that the chat visitor is viewing. | 29.0 |

```json
{
    location: "http://yoursite/page2"
}
```

### 13. QueueUpdate

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| position | integer | The updated position of the chat visitor in the chat queue. | 29.0 |
| estimatedWaitTime | number | The estimated wait time for the button in seconds. If the server cannot retrieve the wait time, this property returns -1. | 47.0 |

```json
{
    position: 3,
    estimatedWaitTime: 120
}
```

### 14. ReconnectSession

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| resetSequence | Boolean | If true, the sequence for the next request should be reset. | 37.0 |
| affinityToken | String | The affinity token for the session that's passed in the header for all future requests. | 37.0 |

```json
{
    resetSequence: true,
    affinityToken: "73061fa0"
}
```

### 15. SensitiveDataRules

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| sensitiveDataRules | SensitiveDataRule object | List of sensitive data rules and their details. | 29.0 |

```json
{
    "sensitiveDataRules": [
        {
            "name": "Replace-Bad-Word",
            "pattern": "bad",
            "id": "0GORM00000001dM",
            "replacement": "bad word",
            "actionType": "Replace"
        },
        {
            "name": "Filter-Out-Digits",
            "pattern": "[0-9]+",
            "id": "0GORM00000001dW",
            "replacement": "<DIGIT>",
            "actionType": "Replace"
        }
    ]
}
```

### 16. SessionId

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| id | String | The session ID for the new session. | 29.0 |
| key | String | The session key for the new session. | 29.0 |
| affinityToken | String | The affinity token for the session that's passed in the header for all future requests. | 29.0 |
| clientPollTimeout | integer | The number of seconds before you must make a Messages request before your Messages long polling loop times out and is terminated. | 29.0 |

```json
{
    id: "241590f5-2e59-44b5-af89-9cae83bb6947",
    key: "f6c1d699-84c7-473f-b194-abf4bf7cccf8!b65b13c7-f597-4dd2-aa3a-cbe01e69f19c",
    affinityToken: "73061fa0"
    clientPollTimeout: "30"
}
```
<!-- [PDF verbatim — typo/quirk] 위 affinityToken 값 뒤의 콤마가 PDF 원문에 누락되어 있음 -->

### 17. Settings

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| pingrate | number | The rate at which the visitor must ping the server to maintain the Chat visitor session. | 29.0 |
| contentServerUrl | String | The URL of the content server. | 29.0 |
| buttons | Array of button objects | A list of chat buttons, along with their settings information, that were specified when you made the Settings request. | 29.0 |

Response body (PDF 원문 — `button` 객체 스키마, 모든 enum 포함):

```json
{
    "pingRate":{
        "type":"number",
        "description":"The rate at which the visitor should ping the server to maintain presence",
        "required":true,
        "version":29.0
    },
    "contentServerUrl":{
        "type":"string",
        "description":"The content server URL",
        "required":true,
        "version":29.0
    },
    "buttons":{
        "type":"array",
        "description":"The list of buttons",
        "items":{
           "name":"button",
           "type":"object",
           "properties":{
               "id":{
                   "type":"string",
                   "description":"The id of the button",
                   "required":true,
                   "version":29.0
               },
               "type":{
                   "type":"string",
                   "description":"The type of the button",
                   "required":true,
                   "version":29.0,
                   "enum":["Standard","Invite","ToAgent"]
               },
               "endpointUrl":{
                   "type":"string",
                   "description":"The custom chat window url of the button",
                   "required":false,
                   "version":29.0
               },
               "prechatUrl":{
                   "type":"string",
                   "description":"The prechat url of the button",
                   "required":false,
                   "version":29.0
               },
               "language":{
                   "type":"string",
                   "description":"The language setting of the button",
                   "required":false,
                   "version":29.0
               },
               "isAvailable":{
                   "type":"boolean",
                   "description":"Whether or not the button is available for chat",
                   "version":29.0
               },
               /* Invite related settings */
               "inviteImageUrl":{
                   "type":"string",
                   "description":"The image of the button",
                   "required":false,
                   "version":29.0
               },
               "inviteImageWidth":{
                   "type":"number",
                   "description":"The width of the button image",
                   "required":false,
                   "version":29.0
               },
               "inviteImageHeight":{
                   "type":"number",
                   "description":"The height of the button image",
                   "required":false,
                   "version":29.0
               },
               "inviteRenderer":{
                   "type":"string",
                   "description":"The animation option of the invite",
                   "required":false,
                   "version":29.0,
                   "enum":["Slide","Fade","Appear","Custom"]
               },
               "inviteStartPosition":{
                   "type":"string",
                   "description":"The start position of the animation",
                   "required":false,
                   "version":29.0,
                   "enum":["TopLeft","TopLeftTop","Top","TopRightTop","TopRight",
                         "TopRightRight","Right","BottomRightRight","BottomRight",
                         "BottomRightBottom","Bottom","BottomLeftBottom","BottomLeft",
                         "BottomLeftLeft","Left","TopLeftLeft"]
               },
               "inviteEndPosition":{
                   "type":"string",
                   "description":"The end position of the animation",
                   "required":false,
                   "version":29.0,
                   "enum":["TopLeft","Top","TopRight","Left","Center","Right","BottomLeft","Bottom","BottomRight"]
               },
               "hasInviteAfterAccept":{
                   "type":"boolean",
                   "description":"Whether or not invite will trigger after accepting",
                   "required":false,
                   "version":29.0
               },
               "hasInviteAfterReject":{
                   "type":"boolean",
                   "description":"Whether or not invite will trigger after rejecting",
                   "required":false,
                   "version":29.0
               },
               "inviteRejectTime":{
                   "type":"number",
                   "description":"The auto reject setting of the invite",
                   "required":false,
                   "version":29.0
               },
               "inviteRules":{
                   "type":"object",
                   "description":"The rules of the invite",
                   "required":false,
                   "version":29.0
               }
               /* Invite related settings */
           }
        },
        "required":true,
        "version":29.0
    }
}
```

### 18. SwitchServer

> *"This response is returned for requests to Visitor resources if the Live Agent instance URL is not correct for the Organization ID provided."*

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| newUrl | String | The new Chat API endpoint for your org if your org is moved. It can be moved due to a planned org migration or during a Site Switch to a different instance. | 29.0 |

```json
{
    "messages": [
        "type": "SwitchServer"
        "message": {
            "newUrl": "https://LiveAgentPool.salesforceliveagent.com/chat"
        }
    ]
}
```
<!-- [PDF verbatim — typo/quirk] PDF의 이 JSON은 콤마/중괄호가 누락된 malformed 상태 그대로임 -->

### 19. VisitorId

| Property Name | Type | Description | Available Versions |
|---|---|---|---|
| sessionId | String | The session ID for the new session. | 29.0 |

```json
"sessionId":{
    "type":"string",
    "description":"The session id of the visitor",
    "required":true,
    "version":29.0
}
```

**SEE ALSO (PDF):** Status Codes and Error Responses (→ [[Chat REST API 데이터 타입 & 상태 코드]])

---

## 관련 노트
- [[Chat REST API 개요 & 시작]]
- [[Chat REST API 메시지 롱폴링 & 대기시간]]
- [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]]
- [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]]
- [[Chat REST API 리소스 — 방문자 경험 커스터마이즈]]
- [[Chat REST API 데이터 타입 & 상태 코드]]
