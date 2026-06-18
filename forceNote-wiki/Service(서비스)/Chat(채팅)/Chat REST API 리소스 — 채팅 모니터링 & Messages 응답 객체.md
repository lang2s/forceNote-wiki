---
tags: [Service, Chat, ChatREST, Resources, Messages, MonitorChat, REST-API]
source: chat_rest
created: 2026-06-18
aliases: [Monitor Chat Activity, Messages, ChatMessage, ChatEnd, MultiNoun, Messages Response Objects, 채팅 모니터링, 메시지 응답 객체, ChasitorTyping]
---

# Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며, **Messaging for In-App and Web**로 이전하세요. 이 노트는 마이그레이션·이력 참조용입니다.

> chat 활동을 모니터링하는 9개 리소스(typing, sneak peek, ChatEnd, ChatMessage, CustomEvent, Messages, MultiNoun 등)와, Messages 요청이 반환하는 14개 응답 객체를 전수 정리한다.

---

## 3. Monitor Chat Activity (Ch6 그룹 3)

> *"Chat requests indicate when certain activities occurred during a chat session."*

서브 섹션: ChasitorNotTyping · ChasitorSneakPeek · ChasitorTyping · ChatEnd · ChasitorIdleTimeoutWarningEvent · ChatMessage · CustomEvent · Messages · MultiNoun.

### 3-1. ChasitorNotTyping

> *"Indicates that the chat visitor is not typing in the chat window."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Chasitor/ChasitorNotTyping` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | POST |
| **Request headers** | X-LIVEAGENT-API-VERSION · X-LIVEAGENT-AFFINITY · X-LIVEAGENT-SESSION-KEY · X-LIVEAGENT-SEQUENCE |
| **Request parameters** | None |
| **Query parameters** | None |
| **Request body** | None |
| **Response body** | None |

### 3-2. ChasitorSneakPeek

> *"Provides a chat visitor's message that was viewable through Sneak Peek."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Chasitor/ChasitorSneakPeek` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | POST |
| **Request headers** | X-LIVEAGENT-API-VERSION · X-LIVEAGENT-AFFINITY · X-LIVEAGENT-SESSION-KEY · X-LIVEAGENT-SEQUENCE |
| **Request parameters** | None |
| **Query parameters** | None |
| **Request body** | ChasitorSneakPeek request (→ [[Chat REST API 요청 & 응답 바디]]) |
| **Response body** | None |

### 3-3. ChasitorTyping

> *"Indicates that a chat visitor is typing a message in the chat window."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Chasitor/ChasitorTyping` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | POST |
| **Request headers** | X-LIVEAGENT-API-VERSION · X-LIVEAGENT-AFFINITY · X-LIVEAGENT-SESSION-KEY · X-LIVEAGENT-SEQUENCE |
| **Request parameters** | None |
| **Query parameters** | None |
| **Request body** | None |
| **Response body** | None |

### 3-4. ChatEnd

> *"Indicates that a chat visitor has ended the chat."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Chasitor/ChatEnd` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | POST |
| **Request headers** | X-LIVEAGENT-API-VERSION · X-LIVEAGENT-AFFINITY · X-LIVEAGENT-SESSION-KEY · X-LIVEAGENT-SEQUENCE |
| **Request parameters** | None |
| **Query parameters** | None |

**Request body:**
- `ChatEndReason` — Include the ChatEndReason parameter in the request body of your request to specify the reason that the chat ended. This parameter is **required**. For example: `{reason: "client"}`.

**Response properties:**
- `attachedRecords` — Includes attached record IDs. You can use this Visualforce component to display the attached record IDs in the post-chat page: `<apex:outputText value="{!$CurrentPage.parameters.attachedRecords}"/><br />`.

### 3-5. ChasitorIdleTimeoutWarningEvent

> *"Informs the server when a warning is shown or cleared so that a transcript event can be created."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Chasitor/ChasitorIdleTimeoutWarningEvent` |
| **Available since release** | API versions 35.0 and later |
| **Response body** | ChasitorIdleTimeoutWarningEvent response (→ [[Chat REST API 요청 & 응답 바디]]) |

> PDF는 이 리소스에 대해 URI · Available since release · Response body 만 나열한다. Formats / HTTP methods / Request headers 블록은 없다.

### 3-6. ChatMessage

> *"Returns the body of the chat message sent by the chat visitor."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Chasitor/ChatMessage` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | POST |
| **Request headers** | X-LIVEAGENT-API-VERSION · X-LIVEAGENT-AFFINITY · X-LIVEAGENT-SESSION-KEY · X-LIVEAGENT-SEQUENCE |
| **Request parameters** | None |
| **Query parameters** | None |
| **Request body** | ChatMessage request (→ [[Chat REST API 요청 & 응답 바디]]) |
| **Response body** | None |

### 3-7. CustomEvent

> *"Indicates a custom event was sent from the chat visitor during the chat."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Chasitor/CustomEvent` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | POST |
| **Request headers** | X-LIVEAGENT-API-VERSION · X-LIVEAGENT-AFFINITY · X-LIVEAGENT-SESSION-KEY · X-LIVEAGENT-SEQUENCE |
| **Request parameters** | None |
| **Query parameters** | None |
| **Request body** | CustomEvent request (→ [[Chat REST API 요청 & 응답 바디]]) |
| **Response body** | None |

### 3-8. Messages

> *"Returns all messages that were sent between agents and chat visitors during a chat session."*
>
> For a complete list of responses for the Messages resource, see Chat REST API Messages Response Objects.

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/System/Messages` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | GET |
| **Request headers** | X-LIVEAGENT-API-VERSION · X-LIVEAGENT-AFFINITY · X-LIVEAGENT-SESSION-KEY |
| **Request parameters** | None |
| **Request body** | None |
| **Response body** | Messages response (→ [[Chat REST API 요청 & 응답 바디]]) |

**Query parameters:**
- `ack` — The ack query parameter is a sequencing mechanism that allows you to poll for messages on the Live Agent server. The first time you make the Messages request, the ack parameter is set to **–1**. To guarantee that you receive the messages from the server in the correct order, update the ack value in the next request with the sequence value from the preceding response. You receive a sequence value only if the response code is **200**, which is the response if there are new messages. If the response code is **204**, there are no messages and the client doesn't provide a sequence value. In this case, run the Messages request with the same ack value as the previous request.

**Troubleshooting (PDF 원문):**

> If your request doesn't receive an HTTP response and fails, retry the request. If you don't retry the request before the chat session times out, the session expires. The timeout value that determines how long you have to attempt to send requests before the server expires the session is configured in Chat Deployment in Salesforce Setup.

#### Chat REST API Messages Response Objects

> *"The Messages request returns an array of objects that represent all the events that occurred during an agent's chat with a chat customer. This request can return several subtypes with unique response bodies, depending on the events that occurred within the chat."*

**예시 Messages 응답 배열 구조 (PDF 원문 — VERBATIM):**

```json
{
      "messages":{
          "type":"array",
          "description":"The messages sent over the course of a chat.",
          "items":{
              "name":"Message",
              "type":"object",
              "properties": {
                  "type": {
                      "type":"string",
                      "description":"The type of message that was received.",
                      "required":true,
                      "version":29.0
              },
              "message": {
                  "type":"object",
                  "description":"A placeholder object for the message that was received.
                   Can return any of the responses available for the Messages request.",
                  "required":true,
                  "version":29.0
              }
          }
      },
      "required":true,
      "version":29.0
},
"sequence":{
    "type":"integer",
    "description":"The sequence of the message as it was received over
     the course of a chat.",
    "required":true,
    "version":29.0
    }
}
```

**14개 Messages 응답 객체** (별도 표기가 없으면 각각 `Available since release: API versions 29.0 and later`):

| # | Object | Description | Response body | Response properties |
|---|---|---|---|---|
| 1 | **AgentDisconnect** | Indicates that the agent has been disconnected from the chat. **Note:** Though the agent has been disconnected from the chat, the chat session is still active on the server. A new agent may accept the chat request and continue the chat. | None | None |
| 2 | **AgentNotTyping** | Indicates that the agent is not typing a message to the chat visitor. | None | None |
| 3 | **AgentTyping** | Indicates that the agent is typing a message to the chat visitor. | None | None |
| 4 | **ChasitorSessionData** | Returns the current chat session data for the chat visitor. This request is used to restore the session data for a chat visitor's chat session after a ReconnectSession request is sent. *The ChasitorSessionData request is the first message sent after a ReconnectSession request is delivered.* **Note:** No messages should be sent after a 503 status code is encountered until this message is processed. | ChasitorSessionData request | — |
| 5 | **ChatEnded** | Indicates that the chat has ended. | ChatEndReason (on page 39) response | None |
| 6 | **ChatEstablished** | Indicates that an agent has accepted a chat request and is engaged in a chat with a visitor. | ChatEstablished response | — |
| 7 | **ChatMessage** | Indicates a new chat message has been sent from an agent to a chat visitor. | ChatMessage response | — |
| 8 | **ChatRequestFail** | Indicates that the chat request was not successful. | ChatRequestFail response | — |
| 9 | **ChatRequestSuccess** | Indicates that the chat request was successful and routed to available agents. **Note:** The ChatRequestSuccess response only indicates that a request has been routed to available agents. The chat hasn't been accepted until the ChatEstablished response is received. | ChatRequestSuccess response | — |
| 10 | **ChatTransferred** | Indicates the chat was transferred from one agent to another. | ChatTransferred response | — |
| 11 | **CustomEvent** | Indicates a custom event was sent from an agent to a chat visitor during a chat. | `CustomEven response` <!-- [PDF verbatim — typo/quirk] should be "CustomEvent response" --> | — |
| 12 | **NewVisitorBreadcrumb** | Indicates the URL of the Web page the chat visitor is currently viewing. | NewVisitorBreadcrumb response | — |
| 13 | **QueueUpdate** | Indicates the new position of the chat visitor in the chat queue when the visitor's position in the queue changes. | QueueUpdate response | — |
| 14 | **SensitiveDataRules** | Lists the sensitive data rules. | SensitiveDataRules response | None |

> 위 #11의 `CustomEven`은 PDF 원문에 그대로 적힌 오타다 (정상 표기는 `CustomEvent response`). 본 위키는 원문을 재현한다.

각 응답 바디의 속성·JSON 예시는 [[Chat REST API 요청 & 응답 바디]]에서 전수 정리한다.

**SEE ALSO (PDF):**
- ChasitorSessionData → ReconnectSession (→ [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]]) · Status Codes and Error Responses (→ [[Chat REST API 데이터 타입 & 상태 코드]])
- ChatEstablished → ChatRequestSuccess
- ChatRequestSuccess → ChatEstablished

### 3-9. MultiNoun

> *"Batches multiple POST requests together if you're sending multiple messages at the same time."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/System/MultiNoun` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | POST |
| **Request headers** | X-LIVEAGENT-API-VERSION · X-LIVEAGENT-AFFINITY · X-LIVEAGENT-SESSION-KEY · X-LIVEAGENT-SEQUENCE |
| **Request parameters** | None |
| **Query parameters** | None |
| **Request body** | MultiNoun request (→ [[Chat REST API 요청 & 응답 바디]]) |
| **Response body** | None |

---

## 관련 노트
- [[Chat REST API 개요 & 시작]]
- [[Chat REST API 메시지 롱폴링 & 대기시간]]
- [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]]
- [[Chat REST API 리소스 — 방문자 경험 커스터마이즈]]
- [[Chat REST API 요청 & 응답 바디]]
- [[Chat REST API 데이터 타입 & 상태 코드]]
