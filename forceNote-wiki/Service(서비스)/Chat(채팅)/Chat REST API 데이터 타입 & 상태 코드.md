---
tags: [Service, Chat, ChatREST, DataTypes, StatusCodes, REST-API]
source: chat_rest
created: 2026-06-18
aliases: [Chat REST data types, Button, TranscriptEntry, GeoLocation, Status Codes, Error Responses, 데이터 타입, 상태 코드, 503 affinity]
---

# Chat REST API 데이터 타입 & 상태 코드

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며, **Messaging for In-App and Web**로 이전하세요. 이 노트는 마이그레이션·이력 참조용입니다.

> 응답 바디가 반환하는 11개 데이터 타입(Button, GeoLocation, TranscriptEntry 등)의 속성 표(Required 포함)와, 모든 HTTP 상태 코드(200~503)를 전수 정리한다.

---

## Ch9 — Chat REST API Data Types

> *"A request to a Chat REST API resource returns a response code. The successful execution of a resource request can also return a response body in JSON format. Some response bodies return data types that contain their own properties. **All property values that refer to a name of an entity or field are case-sensitive.**"*

> **11개 데이터 타입** (PDF heading 순서): Button, CustomDetail, Entity, EntityFieldsMaps, GeoLocation, Message, NounWrapper, Result, Rule, SensitiveDataRule, TranscriptEntry.
> `Result`와 `Rule`은 인접해 있으나 **서로 다른 타입**이다 (Result = id/isAvailable/estimatedWaitTime; Rule = id/name).

### 1. Button

| Property Name | Type | Description | Required | Available Versions |
|---|---|---|---|---|
| id | String | The ID of the chat button object. | TRUE | 29.0 |
| type | String | The button type. Valid values are: • Standard • Invite • ToAgent | TRUE | 29.0 |
| endpointUrl | String | The URL of the custom chat window that's assigned to the chat button. | FALSE | 29.0 |
| prechatUrl | String | The URL of the pre-chat form that's assigned to the button. | FALSE | 29.0 |
| language | String | The chat button's default language. | FALSE | 29.0 |
| isAvailable | Boolean | Specifies whether the chat button is available to receive new chat requests (true) or not (false). If you don't see this property, the value is false. | FALSE | 29.0 |
| inviteImageUrl (for automated chat invitations only) | String | The URL to the automated invitation's static image resource. | FALSE | 29.0 |
| inviteImageWidth (for automated chat invitations only) | number | The width in pixels of the automated chat invitation's image. | FALSE | 29.0 |
| inviteImageHeight (for automated chat invitations only) | number | The height in pixels of the automated chat invitation's image. | FALSE | 29.0 |
| inviteRenderer (for automated chat invitations only) | String | The animation option that's assigned to the automated chat invitation. Valid values are: • Slide • Fade • Appear • Custom | FALSE | 29.0 |
| inviteStartPosition (for automated chat invitations only) | String | The position at which the automated chat invitation begins its animation. Valid values are: • TopLeft • TopLeftTop • Top • TopRightTop • TopRight • TopRightRight • Right • BottomRightRight • BottomRight • BottomRightBottom • Bottom • BottomLeftBottom • BottomLeft • BottomLeftLeft • Left • TopLeftLeft | FALSE | 29.0 |
| inviteEndPosition (for automated chat invitations only) | String | The position at which the automated chat invitation begins its animation. Valid values are: • TopLeft • Top • TopRight • Left • Center • Right • BottomLeft • Bottom • BottomRight | FALSE | 29.0 |
| hasInviteAfterAccept (for automated chat invitations only) | Boolean | Specifies whether the automated chat invitation can be sent again after the customer accepted a previous chat invitation (true) or not (false). | FALSE | 29.0 |
| hasInviteAfterReject (for automated chat invitations only) | Boolean | Specifies whether the automated chat invitation can be sent again after the customer rejected a previous chat invitation (true) or not (false). | FALSE | 29.0 |
| inviteRejectTime (for automated chat invitations only) | number | The amount of time in seconds that the invitation appears on a customer's screen before the invitation is automatically rejected. | FALSE | 29.0 |
| inviteRules (for automated chat invitations only) | Object | The custom rules that govern the behavior of the automated chat invitation, as defined in your custom Apex class. | FALSE | 29.0 |
| estimatedWaitTime | number | The estimated wait time for the button in seconds. If the server cannot retrieve the wait time, this property returns -1. | FALSE | 47.0 |

> `Button.type` enum: **Standard · Invite · ToAgent** · `inviteRenderer` enum: **Slide · Fade · Appear · Custom** · `inviteStartPosition` enum(16): **TopLeft · TopLeftTop · Top · TopRightTop · TopRight · TopRightRight · Right · BottomRightRight · BottomRight · BottomRightBottom · Bottom · BottomLeftBottom · BottomLeft · BottomLeftLeft · Left · TopLeftLeft** · `inviteEndPosition` enum(9): **TopLeft · Top · TopRight · Left · Center · Right · BottomLeft · Bottom · BottomRight**.

### 2. CustomDetail

| Property Name | Type | Description | Required | Available Versions |
|---|---|---|---|---|
| label | String | The customized label for the detail. | TRUE | 29.0 |
| value | String | The customized value for the detail. | TRUE | 29.0 |
| transcriptFields | Array of Strings | The names of fields to which to save the customer's details on the chat transcript. | TRUE | 29.0 |
| displayToAgent | Boolean | Specifies whether to display the customized detail to the agent (true) or not (false). | FALSE | 29.0 |

### 3. Entity

| Property Name | Type | Description | Required | Available Versions |
|---|---|---|---|---|
| entityName | String | The record to search for or create. | TRUE | 29.0 |
| showOnCreate | Boolean | Specifies whether to display the record after it's created (true) or not (false). | FALSE | 29.0 |
| linkToEntityName | String | The name of the record to which to link the detail. | FALSE | 29.0 |
| linkToEntityField | String | The field within the record to which to link the detail. | FALSE | 29.0 |
| saveToTranscript | String | The name of the transcript field to which to save the record. | FALSE | 29.0 |
| entityFieldsMaps | Array of EntityFieldsMaps objects | The fields to which to associate the detail on a record. | TRUE | 29.0 |

### 4. EntityFieldsMaps

| Property Name | Type | Description | Required | Available Versions |
|---|---|---|---|---|
| fieldName | String | The name of the field to which to associate the detail. | TRUE | 29.0 |
| label | String | The customized label for the detail. | TRUE | 29.0 |
| doFind | Boolean | Specifies whether to use the field fieldName to perform a search for matching records (true) or not (false). | TRUE | 29.0 |
| isExactMatch | Boolean | Specifies whether to only search for records that have fields that exactly match the field fieldName (true) or not (false). | TRUE | 29.0 |
| doCreate | Boolean | Specifies whether to create a record based on the field fieldName if one doesn't exist (true) or not (false). | TRUE | 29.0 |

### 5. GeoLocation

| Property Name | Type | Description | Required | Available Versions |
|---|---|---|---|---|
| countryCode | String | The ISO 3166-1 alpha-2 country code for the chat visitor's location. | TRUE | 29.0 |
| countryName | String | The name of the country that's associated with the chat visitor's location. | TRUE | 29.0 |
| region | String | The principal administrative division associated with the chat visitor's location—for example, the state or province. | FALSE | 29.0 |
| city | String | The name of the city associated with the chat visitor's location. | FALSE | 29.0 |
| organization | String | The name of the organization associated with the chat visitor's location. | FALSE | 29.0 |
| latitude | number | The latitude associated with the chat visitor's location. | FALSE | 29.0 |
| longitude | number | The longitude associated with the chat visitor's location. | FALSE | 29.0 |

### 6. Message

| Property Name | Type | Description | Required | Available Versions |
|---|---|---|---|---|
| type | String | The type of message that was received. | TRUE | 29.0 |
| message | Object | A placeholder object for the message that was received. Can return any of the responses that are available for the Messages request. | TRUE | 29.0 |

### 7. NounWrapper

| Property Name | Type | Description | Required | Available Versions |
|---|---|---|---|---|
| prefix | String | The prefix of the resource. | TRUE | 29.0 |
| noun | String | The name of the resource. | TRUE | 29.0 |
| data | String | The data to post to the resource. | FALSE | 29.0 |

### 8. Result

> `Result`와 `Rule`은 서로 다른 타입이다 — Result는 id/isAvailable/estimatedWaitTime를 가진다.

| Property Name | Type | Description | Required | Available Versions |
|---|---|---|---|---|
| id | String | The Salesforce ID of the agent or chat button. | TRUE | 29.0 |
| isAvailable | Boolean | Indicates whether the entity that's associated with the Salesforce ID `id` is available to receive new chat requests (true) or not (false). If you don't see this property, the value is false. | FALSE | 29.0 |
| estimatedWaitTime | number | The estimated wait time for the button in seconds. If the server cannot retrieve the wait time, this property returns -1. | FALSE | 47.0 |

### 9. Rule

> `Rule`은 `Result`와 별개의 타입으로 id/name만 가진다.

| Property Name | Type | Description | Required | Available Versions |
|---|---|---|---|---|
| id | String | The ID of the sensitive data rule record. Applies to SensitiveDataRuleTriggered for Chasitors only. | FALSE | 29.0 |
| name | String | The name of the sensitive data rules applied to the chat session. This property applies to both agent and chasitor. | TRUE | 29.0 |

### 10. SensitiveDataRule

| Property Name | Type | Description | Required | Available Versions |
|---|---|---|---|---|
| name | String | The name of the sensitive data rule. | TRUE | 29.0 |
| pattern | String | The pattern of the sensitive data rule pattern definition. | TRUE | 29.0 |
| id | String | The ID of the sensitive data rule. | FALSE | 29.0 |
| replacement | String | The replacement of the pattern in the message if actionType is Replace. | FALSE | 29.0 |
| actionType | String | The action type if the message matches the pattern. | FALSE | 29.0 |

### 11. TranscriptEntry

| Property Name | Type | Description | Required | Available Versions |
|---|---|---|---|---|
| type | Enumeration of type String | The type of message in the chat transcript. Valid values are: • **Agent**: a message from an agent to a chat visitor • **Chasitor**: a message from a chat visitor to an agent • **OperatorTransferred**: A request to transfer a chat to another agent | TRUE | 29.0 |
| name | String | The name of the person who sent the chat message. | TRUE | 29.0 |
| content | String | The body of the message. | TRUE | 29.0 |
| timestamp | number | The date and time when the message was sent. | TRUE | 29.0 |
| sequence | number | The sequence in which the message was received in the chat. | TRUE | 29.0 |

> `TranscriptEntry.type` enum: **Agent · Chasitor · OperatorTransferred**.

**SEE ALSO (PDF):** Status Codes and Error Responses · Salesforce Help: Block Sensitive Data in Chats

#### TranscriptEntry JSON 예시 (ChasitorSessionData 응답에서 발췌 — 참조용)

```json
{
    type: "Agent",
    name: "Andy L.",
    content: "Hello, how can I help you?",
    timestamp: 1376596367548,
    sequence: 1
}
```

---

## Ch10 — Status Codes and Error Responses

> *"Each request returns a status code or error response to indicate whether the request was successful. When an error occurs or when a response is successful, the response header contains an HTTP code, and the response body usually contains:"*
> - The HTTP response code
> - The message accompanying the HTTP response code

| HTTP response code | Description |
|---|---|
| **200** | "OK" success code. |
| **202** | "Accepted" success code, for POST request. |
| **204** | "No Content" success code for Message request; resend the request as part of the message loop. |
| **400** | The request couldn't be understood, usually because the JSON body contains an error. |
| **403** | The request has been refused because the session isn't valid. |
| **404** | The requested resource couldn't be found. Check the URI for errors. |
| **405** | The method specified in the Request-Line isn't allowed for the resource specified in the URI. |
| **409** | A duplicate long poll using the same session ID has caused the chat to terminate. Reestablish the chat in a new session. |
| **500** | An error has occurred within the Chat server, so the request couldn't be completed. Contact Customer Support. |
| **503** | The affinity token has changed. Make a ReconnectSession request to get a new affinity token, then make a ChasitorSessionData request to reestablish the chat visitor's data within the new session. |

> Ch10에는 위 prose 불릿(HTTP response code + accompanying message) 외에 별도의 "error response format" JSON 예시가 없다.

**SEE ALSO (PDF):** Your Message Long Polling Loop (→ [[Chat REST API 메시지 롱폴링 & 대기시간]]) · ReconnectSession · ChasitorSessionData (→ [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]]) · Response Bodies for Chat REST API · Chat REST API Data Types (→ [[Chat REST API 요청 & 응답 바디]])

---

## 관련 노트
- [[Chat REST API 개요 & 시작]]
- [[Chat REST API 메시지 롱폴링 & 대기시간]]
- [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]]
- [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]]
- [[Chat REST API 리소스 — 방문자 경험 커스터마이즈]]
- [[Chat REST API 요청 & 응답 바디]]
