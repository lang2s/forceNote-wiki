---
tags: [Service, Chat, ChatREST, Resources, SessionId, ChasitorInit, ReconnectSession, REST-API]
source: chat_rest
created: 2026-06-18
aliases: [SessionId, ChasitorInit, ReconnectSession, ChasitorResyncState, 채팅 세션 생성, 방문자 세션, 503 재연결, affinity token, Chasitor, 채시터, Live Agent 세션, 채팅 세션 재연결, 채팅 세션 종료]
---

# Chat REST API 리소스 — 세션 생성 & 방문자 세션

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며, **Messaging for In-App and Web**로 이전하세요. 이 노트는 마이그레이션·이력 참조용입니다.

> Chat 세션을 생성·재연결하는 리소스(SessionId, ChasitorInit, ReconnectSession, ChasitorResyncState)의 HTTP 메서드·URI·헤더·파라미터를 전수 정리한다.

---

## Ch6 개요

> *"To perform a POST or GET request, create and send an HTTP request with the appropriate parameters or request body."*
>
> *"The Chat REST API requests let you begin new chat sessions between agents and chat visitors and monitor the chat activity that occurs."*

Ch6의 최상위 섹션: **Create a Chat Session · Create a Chat Visitor Session · Monitor Chat Activity · Customize the Chat Visitors' Experience.** (뒤의 두 섹션은 [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]] 및 [[Chat REST API 리소스 — 방문자 경험 커스터마이즈]] 참조.)

---

## 1. Create a Chat Session

### SessionId

> *"Establishes a new Chat session. The SessionId request is required as the first request to create every Chat session."*

새 Chat 세션을 생성한다. SessionId 요청은 모든 Chat 세션을 만드는 **첫 번째 요청으로 필수**다.

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/System/SessionId/` 그리고 `https://hostname/chat/rest/System/SessionId/X-LIVEAGENT-SESSION-KEY` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | `GET` — 세션을 생성한다. URL에 X-LIVEAGENT-SESSION-KEY를 전달하지 않는다. · `DELETE` — 세션을 삭제한다. 세션 키인 X-LIVEAGENT-SESSION-KEY를 URL에 전달한다. |
| **Request headers** | X-LIVEAGENT-AFFINITY · X-LIVEAGENT-API-VERSION |
| **Request body** | None |
| **Request parameters** | None |
| **Response Body** | SessionId response (→ [[Chat REST API 요청 & 응답 바디]]) |

**SEE ALSO (PDF):** Your Message Long Polling Loop → [[Chat REST API 메시지 롱폴링 & 대기시간]]

---

## 2. Create a Chat Visitor Session

> *"To create or reestablish a chat visitor session using the Chat REST API, you must make certain requests."*

서브 섹션: ChasitorInit · ReconnectSession · ChasitorResyncState.

### 2-1. ChasitorInit

> *"Initiates a new chat visitor session. The ChasitorInit request is always required as the first POST request in a new chat session."*

새 chat 방문자 세션을 개시한다. ChasitorInit 요청은 새 chat 세션에서 **항상 첫 번째 POST 요청으로 필수**다.

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Chasitor/ChasitorInit` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | POST |
| **Request headers** | X-LIVEAGENT-API-VERSION · X-LIVEAGENT-AFFINITY · X-LIVEAGENT-SESSION-KEY · X-LIVEAGENT-SEQUENCE |
| **Request parameters** | None |
| **Query parameters** | None |
| **Request body** | ChasitorInit request (→ [[Chat REST API 요청 & 응답 바디]]) |
| **Response body** | None |

### 2-2. ReconnectSession

> *"Reconnect a customer's chat session on a new server if the session is interrupted and the original server is unavailable."*

세션이 중단되고 원래 서버를 사용할 수 없을 때, 고객의 chat 세션을 새 서버에서 재연결한다.

#### 503 처리 (PDF 원문)

> This request should only be made if you receive a 503 response status code, indicating that the affinity token has changed for your Chat session. When you receive a 503 response status code, you must cancel any existing inbound or outbound requests. The data in outbound requests will be temporarily stored and resent once the session is reestablished. Upon receiving the response for the ReconnectSession request, you can start polling for messages. The first response will be a ChasitorSessionData message containing the data from the previous session that will be restored once the session is reestablished. After receiving that message, you can proceed to send the existing messages that were canceled upon receiving the 503 response status code.

즉 이 요청은 **503 응답 상태 코드**(Chat 세션의 affinity token이 변경됨)를 받았을 때만 해야 한다. 503을 받으면 기존 inbound/outbound 요청을 모두 취소해야 한다. outbound 요청의 데이터는 임시 저장되었다가 세션이 재확립되면 재전송된다. ReconnectSession 응답을 받으면 메시지 polling을 시작할 수 있고, 첫 응답은 이전 세션 데이터를 담은 `ChasitorSessionData` 메시지다. 그 메시지를 받은 후 503 시점에 취소했던 기존 메시지들을 전송할 수 있다.

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/System/ReconnectSession` |
| **Available since release** | API versions 37.0 and later |
| **Formats** | JSON |
| **HTTP methods** | GET |
| **Request headers** | X-LIVEAGENT-API-VERSION · X-LIVEAGENT-AFFINITY · X-LIVEAGENT-SESSION-KEY |
| **Query parameters** | None |
| **Request body** | None |
| **Response body** | ReconnectSession (→ [[Chat REST API 요청 & 응답 바디]]) |

**Request parameters:**

| Name | Type | Description |
|---|---|---|
| `ReconnectSession.offset` | Number | The event offset from the most recent Messages request that your client received. |

#### Example (PDF 원문)

> Your REST client can get a 503 Invalid Affinity Token response, for example, to a long poll request (`/chat/rest/System/Messages`). No matter which kind of request gets the 503 response, you must send a `/chat/rest/System/ReconnectSession` request to finish the handover process.

```text
Method: GET
URL:
<!-- Change the live agent pool to the correct one for your org. -->
https://LiveAgentPool.salesforceliveagent.com/chat/rest/System/ReconnectSession?ReconnectSession.offset=54647226
Headers:
X-LIVEAGENT-AFFINITY:
null [the literal string "null"]
X-LIVEAGENT-API-VERSION:
42
X-LIVEAGENT-SESSION-KEY:
4eb90106-3410-4dd0-8f04-c4facf90a929!1519169434766!IbjEwmJkIIyqalZS3YBU8WO3nSM=
```

> The ReconnectSession.offset query parameter has to be set to the "offset" parameter of the most recent long poll response that actually contained messages. Empty long poll responses don't come with an "offset". The response to this ReconnectSession request looks like this:

```json
{
    "messages": [
      {
        "type": "ReconnectSession",
        "message": {
          "resetSequence": true, [This may be undefined]
          "affinityToken": "efae1fa0"
        }
      }
    ]
}
```

> The resetSequence is always set to true. Therefore, reset the sequence number of the next request and store the value in affinityToken to use in the X-LIVEAGENT-AFFINITY header for all future requests. Once another handover process occurs the resetSequence is updated again.

즉 `resetSequence`는 항상 true다. 따라서 다음 요청의 sequence 번호를 리셋하고, `affinityToken` 값을 저장해 이후 모든 요청의 `X-LIVEAGENT-AFFINITY` 헤더에 사용한다. 또 다른 handover가 발생하면 `resetSequence`가 다시 갱신된다.

#### Testing (PDF 원문)

> To test that your client handles this process correctly, check that your client sends a ReconnectSession request when it receives a 503 response from the server. You can use a proxy tool of your choice to mimic the 503 response or you can wait until the Salesforce server sends one. When the proxy tool sends a 503 response, you can test that your client sends the ReconnectSession request and reconnects the chat session to a new server, as expected. To get an actual 503 response from the server, you can leave a session connected and wait until the server is restarted during scheduled maintenance. Then see if the chat session reconnects to a new server. However, the maintenance schedule is not announced in advance.

클라이언트가 이 과정을 올바르게 처리하는지 테스트하려면, 서버에서 503을 받았을 때 ReconnectSession 요청을 보내는지 확인한다. 원하는 proxy 도구로 503 응답을 흉내 내거나 Salesforce 서버가 보낼 때까지 기다릴 수 있다. 실제 503을 받으려면 세션을 연결된 상태로 두고 예정된 유지보수 중 서버 재시작을 기다리면 되는데, **유지보수 일정은 사전에 공지되지 않는다.**

**SEE ALSO (PDF):** Status Codes and Error Responses (→ [[Chat REST API 데이터 타입 & 상태 코드]]) · ChasitorSessionData (→ [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]]) · ChasitorResyncState

### 2-3. ChasitorResyncState

> *"Reestablishes the chat visitor's state, including the details of the chat, after a ReconnectSession request is completed."*

ReconnectSession 요청이 완료된 후 chat의 상세 내용을 포함한 chat 방문자의 상태를 재확립한다.

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Chasitor/ChasitorResyncState` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | POST |
| **Request headers** | X-LIVEAGENT-API-VERSION · X-LIVEAGENT-AFFINITY · X-LIVEAGENT-SESSION-KEY |
| **Request parameters** | None |
| **Query parameters** | None |
| **Request body** | ChasitorResyncState (→ [[Chat REST API 요청 & 응답 바디]]) |
| **Response body** | None |

**SEE ALSO (PDF):** ReconnectSession

---

## 관련 노트
- [[Chat REST API 개요 & 시작]]
- [[Chat REST API 메시지 롱폴링 & 대기시간]]
- [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]]
- [[Chat REST API 리소스 — 방문자 경험 커스터마이즈]]
- [[Chat REST API 요청 & 응답 바디]]
- [[Chat REST API 데이터 타입 & 상태 코드]]
