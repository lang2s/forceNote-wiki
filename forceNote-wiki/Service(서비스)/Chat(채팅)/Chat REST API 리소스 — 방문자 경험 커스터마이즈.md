---
tags: [Service, Chat, ChatREST, Resources, Settings, Availability, VisitorId, REST-API]
source: chat_rest
created: 2026-06-18
aliases: [Customize Chat Visitor Experience, Settings, Availability, Breadcrumb, VisitorId, SensitiveDataRuleTriggered, 방문자 경험 커스터마이즈, 채팅 설정, 가용성]
---

# Chat REST API 리소스 — 방문자 경험 커스터마이즈

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며, **Messaging for In-App and Web**로 이전하세요. 이 노트는 마이그레이션·이력 참조용입니다.

> 커스텀 모바일 앱에서 chat 방문자 경험을 구성하는 6개 리소스(Settings, Availability, Breadcrumb, VisitorId, 그리고 agent·chasitor용 SensitiveDataRuleTriggered)의 모든 파라미터를 정리한다.

---

## 4. Customize the Chat Visitors' Experience (Ch6 그룹 4)

> *"With the Chat visitor REST API resources, you can establish your chat visitors' experience with Chat in custom mobile applications."*

서브 섹션: Settings · Availability · Breadcrumb · VisitorId · SensitiveDataRuleTriggered for Agents · SensitiveDataRuleTriggered for Chasitors.

### 4-1. Settings

> *"Retrieves all settings information about the Chat deployment that's associated with your chat session. The Settings request is required as the first request to establish a chat visitor's session."*

Chat 세션과 연결된 Chat deployment의 모든 설정 정보를 가져온다. Settings 요청은 chat 방문자 세션을 확립하는 **첫 번째 요청으로 필수**다.

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Visitor/Settings` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | GET |
| **Request headers** | X-LIVEAGENT-API-VERSION |
| **Request parameters** | None |
| **Request body** | None |
| **Response body** | Settings response (on page 47) (→ [[Chat REST API 요청 & 응답 바디]]) |

**Query parameters (5):**

| Name | Description |
|---|---|
| `org_id` | The ID of the Salesforce organization that's associated with the Live Agent deployment. |
| `deployment_id` | The ID of the Chat deployment that the chat request was initiated from. |
| `Settings.buttonIds` | An array of chat button IDs for which to retrieve settings information. |
| `Settings.needEstimatedWaitTime` | Indicates whether the estimatedWaitTime property should be filled. Specify a value of 1 to request the estimated wait time. |
| `Settings.updateBreadcrumb` | Indicates whether to update the chat visitor's location with the URL of the Web page that the visitor is viewing. |

요청 예시 (query parameter 조합):

```text
// 구조 예시 — 실제 PDF 코드 아님 (위 URI·query parameter 조합 예시)
GET https://hostname/chat/rest/Visitor/Settings?org_id=00DD0000000JVXs&deployment_id=572D000000000J6&Settings.buttonIds=573D000000000OC&Settings.needEstimatedWaitTime=1
Header: X-LIVEAGENT-API-VERSION: 66
```

### 4-2. Availability

> *"Indicates whether a chat button is available to receive new chat requests."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Visitor/Availability` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | GET |
| **Request headers** | X-LIVEAGENT-API-VERSION |
| **Request parameters** | None |
| **Request body** | None |
| **Response body** | Availability response (→ [[Chat REST API 요청 & 응답 바디]]) |

**Query parameters (4):**

| Name | Description |
|---|---|
| `org_id` | The ID of the Salesforce organization that's associated with the Live Agent deployment. |
| `deployment_id` | The 15-digit ID of the Chat deployment that the chat request was initiated from. |
| `Availability.ids` | An array of object IDs for which to verify availability. |
| `Availability.needEstimatedWaitTime` | Indicates whether the estimatedWaitTime property should be filled. Specify a value of 1 to request the estimated wait time. |

### 4-3. Breadcrumb

> *"Sets a breadcrumb value to the URL of the Web page that the chat visitor is viewing as the visitor chats with an agent. The agent can then see the value of the breadcrumb to determine the page the chat visitor is viewing."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Visitor/Breadcrumb` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | POST |
| **Request headers** | X-LIVEAGENT-API-VERSION |
| **Request parameters** | None |
| **Query parameters** | None |
| **Request body** | Breadcrumb request (→ [[Chat REST API 요청 & 응답 바디]]) |
| **Response body** | None |

### 4-4. VisitorId

> *"Generates a unique ID to track a chat visitor when they initiate a chat request and tracks the visitor's activities as the visitor navigates from one Web page to another."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Visitor/VisitorId` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | GET |
| **Request headers** | X-LIVEAGENT-API-VERSION |
| **Request parameters** | None |
| **Request body** | None |
| **Response body** | VisitorId response (→ [[Chat REST API 요청 & 응답 바디]]) |

**Query parameters (2):**

| Name | Description |
|---|---|
| `org_id` | The Salesforce organization ID. |
| `deployment_id` | The ID of the Chat deployment that the chat request was initiated from. |

### 4-5. SensitiveDataRuleTriggered for Agents

> *"Sets the sensitive data rules for the chat agent, such as blocking the agent's credit card, Social Security, phone and account numbers, or even profanity."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Agent/SensitiveDataRuleTriggered` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | POST |
| **Request headers** | X-LIVEAGENT-API-VERSION |
| **Request parameters** | None |
| **Query parameters** | None |
| **Request body** | SensitiveDataRuleTriggered for Agents request (→ [[Chat REST API 요청 & 응답 바디]]) |
| **Response body** | None |

### 4-6. SensitiveDataRuleTriggered for Chasitors

> *"Sets the sensitive data rules for the chat visitor, such as blocking the visitor's credit card, Social Security, phone and account numbers, or even profanity."*

| 항목 | 값 |
|---|---|
| **URI** | `https://hostname/chat/rest/Chasitor/SensitiveDataRuleTriggered` |
| **Available since release** | API versions 29.0 and later |
| **Formats** | JSON |
| **HTTP methods** | POST |
| **Request headers** | X-LIVEAGENT-API-VERSION |
| **Request parameters** | None |
| **Query parameters** | None |
| **Request body** | SensitiveDataRuleTriggered for Chasitors request (→ [[Chat REST API 요청 & 응답 바디]]) |
| **Response body** | None |

**SEE ALSO (PDF):** Salesforce Help: Block Sensitive Data in Chats

---

## 관련 노트
- [[Chat REST API 개요 & 시작]]
- [[Chat REST API 메시지 롱폴링 & 대기시간]]
- [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]]
- [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]]
- [[Chat REST API 요청 & 응답 바디]]
- [[Chat REST API 데이터 타입 & 상태 코드]]
