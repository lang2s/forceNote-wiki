---
tags: [Service, Chat, ChatREST, LongPolling, EstimatedWaitTime, Beta, REST-API]
source: chat_rest
created: 2026-06-18
aliases: [Chat long polling, Message long polling loop, Estimated Wait Time, 메시지 롱폴링, 예상 대기시간, clientPollTimeout, needEstimatedWaitTime]
---

# Chat REST API 메시지 롱폴링 & 대기시간

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며, **Messaging for In-App and Web**로 이전하세요. 이 노트는 마이그레이션·이력 참조용입니다.

> Chat 서버 이벤트를 수신하는 메시지 롱폴링 루프(200/204 응답, clientPollTimeout, 타임아웃 경고)와, queue position 대신 예상 대기시간(Beta)을 사용하는 방법을 정리한다.

---

## 1. 메시지 롱폴링 루프 (Ch4 — Your Message Long Polling Loop)

> *"Message long polling notifies you of events that occur on the Chat server for your Chat session."*

메시지 롱폴링은 Chat 세션에서 Chat 서버에 발생하는 이벤트를 알려준다.

### PDF 원문 (VERBATIM)

> When you start a request, all pending messages get immediately delivered to your session. If there are no pending messages, the connection to the server will remain open. The Messages poll will return one payload of messages from the server when they become available, and you'll have to open a new Messages connection to receive future data.
>
> You'll receive a 200 ("OK") response code and a resource that contains an array of the remaining messages. If no messages were received, you will receive a 204 ("No Content") response code.
>
> When you receive a 200 ("OK") or 204 ("No Content") response code, immediately perform another Messages request to continue to retrieve messages that are registered on the Chat server.
>
> **Warning:** If you don't make another Messages request to continue the messaging loop, your session will end after a system timeout on the Chat server.
>
> If you don't receive a response within the number of seconds indicated by the `clientPollTimeout` property in your SessionId request, your network connection to the server is likely experiencing an error, so you should terminate the request.
>
> To initiate a long polling loop, perform a Messages request.

### 핵심 포인트

- 요청을 시작하면 보류 중인 모든 메시지가 즉시 세션으로 전달된다. 보류 메시지가 없으면 서버 연결이 열린 채 유지된다.
- `Messages` poll은 메시지가 사용 가능해지면 **하나의 payload**를 반환하며, 이후 데이터를 받으려면 새 `Messages` 연결을 열어야 한다.
- 남은 메시지 배열이 있으면 **200("OK")**, 받은 메시지가 없으면 **204("No Content")** 응답 코드를 받는다.
- **200 또는 204** 응답 코드를 받으면 즉시 다음 `Messages` 요청을 수행해 서버에 등록된 메시지를 계속 가져온다.
- **Warning:** 다음 `Messages` 요청으로 메시징 루프를 이어가지 않으면, Chat 서버의 시스템 타임아웃 후 세션이 종료된다.
- SessionId 요청의 `clientPollTimeout` 속성이 가리키는 초(seconds) 안에 응답을 받지 못하면 네트워크 연결 오류일 가능성이 높으므로 요청을 종료해야 한다.

### 롱폴링 루프 시퀀스 (PDF 산문에서 재구성)

```text
// 구조 예시 — 실제 PDF 다이어그램/코드 아님
1. Messages (GET) 요청을 수행해 롱폴링 루프를 개시한다.
2. 보류 메시지는 즉시 전달된다. 없으면 메시지가 도착할 때까지 연결을 유지한다.
3. 서버가 하나의 payload를 반환 → 메시지 배열이 있으면 200(OK), 없으면 204(No Content).
4. 200 또는 204 어느 쪽이든 → 즉시 다음 Messages 요청을 수행한다 (안 하면 세션이 타임아웃).
5. clientPollTimeout 초 안에 응답이 없으면 → 네트워크 오류이므로 요청을 종료한다.
```

### SEE ALSO (PDF)
- Messages → [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]]
- SessionId → [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]]
- Status Codes and Error Responses → [[Chat REST API 데이터 타입 & 상태 코드]]

---

## 2. Queue Position 대신 예상 대기시간 사용 (Beta) (Ch5 — Estimated Wait Time)

> *"By default, the Chat API returns queue position information that you can relay to customers. However, you can also receive the estimated wait time in addition to the queue position. Sometimes, the estimated wait time more effectively conveys the right information to customers than a queue position number. **This feature is available in API version 47.0 and later.**"*

기본적으로 Chat API는 고객에게 전달할 수 있는 queue position 정보를 반환한다. 추가로 예상 대기시간(estimated wait time)도 받을 수 있는데, queue position 숫자보다 더 효과적으로 정보를 전달할 때가 있다. **이 기능은 API 버전 47.0 이상에서 사용 가능하다.**

### Beta 고지 (PDF 원문 — VERBATIM)

> **Note:** As a beta feature, Estimated Wait Time is a preview and isn't part of the "Services" under your main subscription agreement with Salesforce. Use this feature at your sole discretion, and make your purchase decisions only on the basis of generally available products and features. Salesforce doesn't guarantee general availability of this feature within any particular time frame or at all, and we can discontinue it at any time. This feature is for evaluation purposes only, not for production use. It's offered as is and isn't supported, and Salesforce has no liability for any harm or damage arising out of or in connection with it. All restrictions, Salesforce reservation of rights, obligations concerning the Services, and terms for related Non-Salesforce Applications and Content apply equally to your use of this feature.

### 대기시간 계산 알고리즘 (PDF 원문)

> The following algorithm is used to calculate the wait time:

```text
A = (0.9 * A′) + (0.1 * W)
```

Where:
- **A′** is the previous value for A. If no previous value exists, this value is W. (A의 이전 값. 이전 값이 없으면 W를 사용.)
- **W** is the wait time of the chat that has most recently been accepted. (가장 최근에 수락된 chat의 대기시간.)

> The value returned is the value of A minus the time already spent waiting.

반환되는 값은 **A에서 이미 대기한 시간을 뺀 값**이다.

**추가 알고리즘 세부사항 (Additional algorithm details):**
- This value is calculated separately for each chat button. (각 chat 버튼별로 따로 계산된다.)
- A is recalculated each time a chat is accepted. (chat이 수락될 때마다 A를 재계산한다.)
- **0** is returned if the result is less than 0. (결과가 0보다 작으면 0을 반환.)
- **-1** is returned when the value cannot be calculated. (값을 계산할 수 없으면 -1을 반환.)

### 활성화 방법 (PDF 원문)

> To use this feature, specify that you want the estimated wait time from the Settings request (by setting `Settings.needEstimatedWaitTime` to 1) and the Availability request (by setting `Availability.needEstimatedWaitTime` to 1). When this value is set to 1, the response includes the estimated wait time for each button ID requested.
>
> If `receiveQueueUpdates` is set when initializing the session, ChatRequestSuccess and QueueUpdate will both contain the estimated wait time (in seconds) in their responses.

- `Settings` 요청에서 `Settings.needEstimatedWaitTime`를 **1**로, `Availability` 요청에서 `Availability.needEstimatedWaitTime`를 **1**로 설정하면 사용한다. 이 값이 1이면 응답에 요청한 각 버튼 ID의 예상 대기시간이 포함된다.
- 세션 초기화 시 `receiveQueueUpdates`가 설정되어 있으면, `ChatRequestSuccess`와 `QueueUpdate` 응답 모두에 예상 대기시간(초)이 포함된다.

---

## 관련 노트
- [[Chat REST API 개요 & 시작]]
- [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]]
- [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]]
- [[Chat REST API 리소스 — 방문자 경험 커스터마이즈]]
- [[Chat REST API 요청 & 응답 바디]]
- [[Chat REST API 데이터 타입 & 상태 코드]]
