---
tags: [Service, Chat, ChatREST, LiveAgent, REST-API, retirement, Salesforce]
source: chat_rest
created: 2026-06-18
aliases: [Chat REST API Overview, Chat REST Getting Started, 채팅 REST API 개요, 채팅 세션 시작, Request Headers, SessionId, 라이브에이전트 REST, Live Agent REST API, Live Agent visitor API, Chasitor, 채시터, Chat 은퇴, Live Agent 종료, Chat retirement, Chat EOL, Messaging for In-App and Web 마이그레이션, Live Agent 마이그레이션]
---

# Chat REST API 개요 & 시작

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며, **Messaging for In-App and Web**로 이전하세요. 이 노트는 마이그레이션·이력 참조용입니다.

> 네이티브 모바일 앱이나 커스텀 클라이언트에서 Chat을 사용하기 위한 REST API의 개요, 세션 시작·확인·종료 흐름, 그리고 모든 요청 헤더를 정리한다.

---

## 1. 개요 (Ch1 — Overview)

> *"Take Chat to a native mobile app or a custom client using the Chat REST API."*

이 가이드의 REST 리소스를 사용하면 단순한 HTML/JavaScript 환경을 넘어, 회사 자체 애플리케이션에 매끄럽게 통합되는 커스텀 chat 윈도우를 만들 수 있다. Visualforce에 의존할 필요가 없다.

> You don't have to rely on Visualforce to develop customized chat windows. With the REST resources in this guide, you can extend the functionality of chat windows beyond simple HTML and JavaScript environments that merge seamlessly into your company's own applications.

### Retirement Note (PDF 원문 — 거의 모든 챕터 상단에 반복 등장, 본 위키에서는 N1에서 1회만 원문 인용)

> **Note:** The legacy chat product is scheduled for retirement on February 14, 2026, and is in maintenance mode until then. During this phase, you can continue to use chat, but we no longer recommend that you implement new chat channels. To avoid service interruptions to your customers, migrate to Messaging for In-App and Web. Messaging offers many of the chat features that you love plus asynchronous conversations that can be picked back up at any time. Learn about chat retirement in Help.

즉 레거시 chat은 **2026년 2월 14일 은퇴 예정**이며 그 전까지 유지보수 모드다. 그 기간 동안 chat을 계속 사용할 수는 있으나 **새로운 chat 채널 구현은 권장되지 않으며**, 고객 서비스 중단을 피하려면 **Messaging for In-App and Web**(미작성 — 가이드 PDF 미입수)로 이전해야 한다.

### Einstein Bots 미지원 (PDF 원문)

> **Note:** Chat REST API doesn't support building custom clients that work with Einstein Bots. See Einstein Bots API and SDK.

Chat REST API는 Einstein Bots와 함께 동작하는 커스텀 클라이언트 구축을 **지원하지 않는다.**

### SEE ALSO (PDF)
- Embedded Service SDK for iOS Developer Guide
- Embedded Service SDK for Android Developer Guide

### EDITIONS (PDF 원문)

- Available in: **Salesforce Classic** and **Lightning Experience**
- Available in: **Performance Editions** and in **Developer Edition** orgs that were created after **June 14, 2012**
- Available in: **Essentials, Unlimited, and Enterprise Editions** with **Service Cloud** or **Sales Cloud**

> Ch1에는 별도의 인증(auth) 개요 섹션이 없다.

---

## 2. 시작하기 (Ch2 — Getting Started)

> *"Learn how to start, confirm, and end a Chat session with the Chat REST API."*

### 2-1. Chat API 엔드포인트 가져오기

> Your Chat API endpoint is a unique URL that lets you access data from your organization's Chat sessions.

조직의 Chat API 엔드포인트를 찾는 방법:

1. Setup에서 Quick Find 상자에 `Chat Settings`를 입력하고 **Chat Settings**를 선택한다.
2. **Chat API Endpoint**에서 hostname을 가져온다. hostname은 끝의 `/chat/rest/`를 제외한 URL이다. 예: `https://yourChatApiEndpoint.com`. Chat API 엔드포인트의 `hostname`을 이 URL로 치환한다.

### 2-2. Chat 세션 시작

> To start a Chat session, send a SessionId request.

`hostname`을 Chat API Endpoint에서 가져온 URL로 교체한다.

```
GET https://hostname/chat/rest/System/SessionId/
```

사용 Request Headers:
- `X-LIVEAGENT-AFFINITY`
- `X-LIVEAGENT-API-VERSION`

### 2-3. Chat 세션 시작 확인

> A ChatRequestSuccess response tells you that the Chat session started.

`ChatRequestSuccess` 응답은 Chat 세션이 시작되었음을 알려준다.

```json
{
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
}
```

그 다음 `ChatEstablished` 응답을 기다린다. 이 응답은 agent가 chat 세션을 수락했음을 알려준다.

```json
{
name: "Andy L.",
userId: "f1dda237-57f8-4816-b8e8-59775f1e44c8",
sneakPeekEnabled: true
}
```

> Now you're ready to send, for example, Messages requests. Before you send further requests, wait until you receive the ChatRequestSuccess and ChatEstablished responses, otherwise the API throws a Null Pointer exception, and you receive a 500 error.

즉 이후 요청(예: `Messages`)을 보내기 전에 반드시 `ChatRequestSuccess`와 `ChatEstablished` 두 응답을 모두 받을 때까지 기다려야 한다. 그렇지 않으면 API가 Null Pointer 예외를 던지고 **500 에러**를 받게 된다.

### 2-4. Chat 세션 종료

> The Chat session ends when you send a ChatEnd request or send a DELETE SessionId request.

두 요청 모두에서 `X-LIVEAGENT-SESSION-KEY`는 종료하려는 Chat 세션의 고유 ID다.

**ChatEnd 요청:**

```
https://hostname/chat/rest/Chasitor/ChatEnd
```

Headers: `X-LIVEAGENT-AFFINITY` · `X-LIVEAGENT-API-VERSION` · `X-LIVEAGENT-SESSION-KEY` · `X-LIVEAGENT-SEQUENCE`

**SessionId 요청:**

```
DELETE https://hostname/chat/rest/System/SessionId/X-LIVEAGENT-SESSION-KEY
```

Headers: `X-LIVEAGENT-AFFINITY` · `X-LIVEAGENT-API-VERSION`

---

## 3. 요청 헤더 (Ch3 — Request Headers)

> *"Each Chat REST API resource requires one or more headers to make a request."*

모든 리소스가 모든 헤더를 요구하는 것은 아니다. 각 리소스는 요청에 필요한 헤더를 명시한다. 사용 가능한 헤더는 다음 4가지다.

| Header Syntax | Description |
|---|---|
| `X-LIVEAGENT-API-VERSION` | The Salesforce API version for the request. (요청에 사용할 Salesforce API 버전.) |
| `X-LIVEAGENT-AFFINITY` | The system-generated ID used to identify the Chat session on the Chat servers. This affinity token is included in the response body of the SessionId request. (Chat 서버에서 세션을 식별하는 시스템 생성 ID. 이 affinity 토큰은 SessionId 요청의 응답 바디에 포함된다.) |
| `X-LIVEAGENT-SESSION-KEY` | The unique ID associated with your Chat session. **Note:** Your session key shouldn't be shared or sent over insecure channels, as it allows access to potentially sensitive chat information. (Chat 세션의 고유 ID. 세션 키는 민감한 chat 정보에 접근을 허용하므로 공유하거나 안전하지 않은 채널로 전송하면 안 된다.) |
| `X-LIVEAGENT-SEQUENCE` | The sequence of messages you have sent to the Chat server to help the Chat server avoid processing duplicate messages. This number should be increased by one with every new request. (서버가 중복 메시지를 처리하지 않도록 돕는, 전송한 메시지의 순번. 새 요청마다 1씩 증가시켜야 한다.) |

---

## 관련 노트
- [[Chat REST API 메시지 롱폴링 & 대기시간]]
- [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]]
- [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]]
- [[Chat REST API 리소스 — 방문자 경험 커스터마이즈]]
- [[Chat REST API 요청 & 응답 바디]]
- [[Chat REST API 데이터 타입 & 상태 코드]]
- [[Service Cloud Objects]] — Chat REST API가 다루는 LiveChatVisitor·LiveChatTranscript 등 Live Agent/Live Chat sObject 카탈로그
- [[Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼]] — 같은 Chat 제품의 JavaScript Deployment/Pre-Chat API·Visualforce 웹페이지 임베드 관점 (REST = 네이티브 앱·커스텀 클라이언트 관점)
- Messaging for In-App and Web (미작성 — 후속 마이그레이션 대상, 가이드 PDF 미입수)
- Embedded Service SDK (미작성 — iOS/Android Embedded Service SDK 가이드, PDF 미입수)
