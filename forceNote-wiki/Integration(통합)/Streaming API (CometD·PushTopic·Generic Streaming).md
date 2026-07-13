---
tags: [integration, streaming-api, cometd, bayeux, pushtopic, generic-streaming, durable-streaming, replayid, legacy]
source: developer.salesforce.com/docs/atlas.en-us.api_streaming.meta/api_streaming/
created: 2026-07-07
aliases: [Streaming API, CometD, Bayeux, PushTopic, Generic Streaming, StreamingChannel, Durable Streaming, replayId, long polling, 스트리밍 API, 코멧D, 푸시토픽, 제네릭 스트리밍]
---

# Streaming API (CometD·PushTopic·Generic Streaming)

> **CometD/Bayeux(long-polling)** 기반의 레거시 push 구독 API. PushTopic·Generic Streaming·Platform Event·CDC가 모두 이 Streaming 인프라 위에서 동작하며, 브라우저/Visualforce/레거시 UI 구독에 쓰인다. 서버-투-서버 신규 구축은 [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]]으로 대체됐다.

---

## 개요 — CometD/Bayeux push 구독

Streaming API는 서버가 클라이언트로 이벤트를 **push**하는 API다. 폴링(주기적 조회)으로 API 콜을 낭비하지 않고, 변경이 발생했을 때만 통지를 받는다.

| 항목 | 내용 |
|---|---|
| 전송 프로토콜 | HTTP/1.1 request-response + **Bayeux 프로토콜** |
| 구현 라이브러리 | **CometD** — Bayeux를 구현한 HTTP 기반 이벤트 라우팅 버스 |
| 연결 방식 | **long polling**(Comet 패턴) — 클라이언트가 연결을 열어두고 서버가 이벤트 발생 시 응답 |
| 데이터 포맷 | JSON |
| 방향 | 서버 → 클라이언트 단방향 push (구독) |

CometD는 브라우저/JS 클라이언트가 서버 push를 받을 수 있게 하는 오래된 기술이라, LWC의 `lightning/empApi`, Visualforce, 레거시 자바 클라이언트가 이 위에서 구독한다.

### Streaming 인프라 위의 4가지 채널 종류

Streaming API는 단일 API가 아니라 **여러 이벤트 종류가 공유하는 전송 계층**이다. 아래 4종이 모두 CometD 채널로 구독된다.

| 채널 종류 | 채널 URL 접두사 | 발행 주체 | 용도 |
|---|---|---|---|
| **PushTopic** | `/topic/<PushTopicName>` | SOQL 쿼리 매칭 레코드 변경 | 특정 sObject 레코드 변경 통지 |
| **Generic Streaming** | `/u/<StreamingChannel Name>` | Apex/REST가 임의 payload 발행 | 데이터와 무관한 사용자 정의 알림 |
| **Platform Event** | `/event/<EventName>__e` | 정의된 이벤트 발행 | 이벤트 기반 통합 → [[Platform Event 통합 패턴]] |
| **Change Data Capture** | `/data/<ChangeEventName>` (예: `/data/AccountChangeEvent`, `/data/ChangeEvents`) | 레코드 CRUD 자동 캡처 | 데이터 동기화 |

> PushTopic·Generic은 Streaming API 고유 기능이고, Platform Event·CDC는 자체 발행 모델을 갖되 구독 전송만 이 인프라(또는 Pub/Sub API)를 공유한다.

### 언제 쓰나 — 레거시 UI 구독

| 상황 | 권장 |
|---|---|
| **브라우저/LWC/Visualforce UI**가 실시간 갱신을 받아야 함 | Streaming API (CometD `empApi`) — 프론트엔드는 gRPC를 못 쓴다 |
| 레거시 CometD 자바/노드 클라이언트가 이미 있음 | 유지 가능 (계속 동작) |
| **신규 서버-투-서버 구독**(Java·Python·Node 등 외부 백엔드) | ✅ **Pub/Sub API (gRPC)** — CometD는 신규 구축 비권장 |

---

## 레퍼런스 1 — PushTopic

SOQL 쿼리에 매칭되는 레코드가 변경되면 `/topic/<Name>` 채널로 통지를 push한다. **PushTopic sObject**를 Apex/API로 insert해 정의한다.

```apex
// 구조 예시 — PushTopic 정의
PushTopic pt = new PushTopic();
pt.Name = 'InvoiceStatementUpdates';           // 채널명 → /topic/InvoiceStatementUpdates
pt.Query = 'SELECT Id, Name, Status__c FROM Invoice_Statement__c';
pt.ApiVersion = 64.0;
pt.NotifyForOperationCreate  = true;
pt.NotifyForOperationUpdate  = true;
pt.NotifyForOperationDelete  = true;
pt.NotifyForOperationUndelete = true;
pt.NotifyForFields = 'Referenced';
insert pt;
```

### PushTopic 필드

| 필드 | 설명 |
|---|---|
| `Name` | 채널명(최대 25자). 구독 채널 = `/topic/<Name>` |
| `Query` | 통지 대상을 정의하는 SOQL 쿼리 |
| `ApiVersion` | 쿼리 평가에 쓰는 API 버전(예: 64.0) |
| `NotifyForOperationCreate` | 생성 시 통지 여부 (Boolean) |
| `NotifyForOperationUpdate` | 수정 시 통지 여부 |
| `NotifyForOperationDelete` | 삭제 시 통지 여부 |
| `NotifyForOperationUndelete` | 복원 시 통지 여부 |
| `NotifyForFields` | 어떤 필드 변경이 통지를 유발하는지 (아래) |

### NotifyForFields 옵션

| 값 | 통지 유발 조건 |
|---|---|
| `All` | 레코드의 **모든 필드** 중 하나라도 변경 시 |
| `Referenced` (기본) | SOQL의 **SELECT 또는 WHERE**에 참조된 필드 변경 시 |
| `Select` | **SELECT 절** 필드 변경 시 |
| `Where` | **WHERE 절** 필드 변경 시 |

> update 통지는 `NotifyForFields` + 변경 후 레코드가 여전히 WHERE를 만족하는지에 따라 발생한다.

### PushTopic SOQL 제약

- **SELECT에 반드시 `Id`** 포함, 단일 sObject만(조인 불가), 서브쿼리(부모→자식) 불가.
- 지원 대상: **모든 커스텀 오브젝트** + 표준 오브젝트의 **부분 집합**(Account, Contact, Lead, Opportunity, Task 등).
- 집계 함수(`COUNT()` 등), `GROUP BY`, `LIMIT`, 시맨틱 조인 미지원 (Unsupported PushTopic Queries).
- 참조 필드는 `WHERE`에서만 제한적으로 사용.

---

## 레퍼런스 2 — Generic Streaming (StreamingChannel)

레코드 변경과 **무관한** 임의 payload를 발행한다. **StreamingChannel** sObject로 채널을 정의하고, REST(또는 Apex `StreamingChannelPush`)로 payload를 push한다.

```apex
// 구조 예시 — Generic Streaming 채널 정의
StreamingChannel ch = new StreamingChannel();
ch.Name = '/u/Notifications';   // 사용자 정의 채널 (반드시 /u/ 접두사)
ch.Description = 'System-wide notices';
insert ch;
```

```json
// 구조 예시 — REST로 payload 발행: POST /services/data/vXX.X/sobjects/StreamingChannel/<id>/push
{
  "pushEvents": [
    { "payload": "Broadcast message to all subscribers", "userIds": [] }
  ]
}
```

| 특징 | 내용 |
|---|---|
| 채널 sObject | `StreamingChannel` (`Name`은 `/u/` 접두사 필수) |
| payload | 데이터 스키마 없이 **개발자가 자유롭게 정의**한 문자열/JSON |
| 대상 지정 | `userIds` 지정 시 특정 사용자에게만, 빈 배열이면 전체 구독자 |
| 용도 | 레코드와 무관한 시스템 공지, 사용자 정의 알림 |

---

## 레퍼런스 3 — Durable Streaming / replayId

구독 시점에 연결이 끊겨도 **이벤트가 보존창 동안 저장**되므로 재구독하며 놓친 이벤트를 재생(replay)할 수 있다. 구독 요청에 `replayId`를 지정한다.

| replayId 값 | 동작 |
|---|---|
| `-1` (기본) | 구독 **이후** 발생하는 **새 이벤트만** 수신 |
| `-2` | 보존창 내 **저장된 과거 이벤트 전부** + 새 이벤트 수신 (저장 이벤트가 많으면 성능 저하 — 신중히 사용) |
| 특정 `replayId` | 그 replayId **이후**의 저장 이벤트 + 새 이벤트 수신 (연결 실패 후 이어받기) |

### 이벤트 보존창

| 이벤트 종류 | 보존 기간 |
|---|---|
| **PushTopic · Generic** | **24시간** |
| **Platform Event · CDC** (high-volume) | **72시간** |

> - 각 이벤트는 시스템이 부여한 **불투명(opaque) `replayId`**를 가지며 스트림 내 위치를 나타낸다.
> - **replayId는 연속 이벤트에서 순차적(contiguous)임이 보장되지 않는다** — 숫자로 가정해 증감하지 말고 받은 값을 그대로(바이트로) 저장·전달한다.
> - 보존창은 **rolling 24시간이 아니라 절대 시간**이므로, 클라이언트는 만료 전에 이벤트를 가져와야 한다.

---

## 레퍼런스 4 — CometD 연결 흐름과 채널 URL

```
// 구조 예시 — 실제 동작 코드 아님 (Bayeux 메시지 흐름)
엔드포인트: https://<myDomain>.my.salesforce.com/cometd/64.0/

1. Handshake  → POST /meta/handshake   (지원 transport 협상, clientId 발급)
2. Subscribe  → POST /meta/subscribe   { "subscription": "/topic/InvoiceStatementUpdates" }
3. Connect    → POST /meta/connect     (long polling — 이벤트 발생 시 응답으로 push)
4. Disconnect → POST /meta/disconnect
```

| 메타 채널 | 역할 |
|---|---|
| `/meta/handshake` | 최초 연결·재연결, transport 협상, clientId 발급 |
| `/meta/subscribe` | 이벤트 채널 구독 요청 |
| `/meta/connect` | long-polling 유지 (이벤트 전달 통로) |
| `/meta/disconnect` | 연결 종료 |

- 엔드포인트는 **버전 포함**: `/cometd/64.0/` (API 버전에 맞춤).
- 인증은 OAuth 액세스 토큰을 `Authorization: Bearer` 헤더로 전달.
- LWC에서는 이 흐름을 `lightning/empApi`(`subscribe`, `unsubscribe`, `setReplayId`)가 감싼다 — 직접 CometD를 다루지 않는다.

---

## 한도

| 항목 | 한도(대략) |
|---|---|
| 채널당 동시 클라이언트(구독자) | Enterprise/Unlimited 기준 제한 있음(에디션·기능 라이선스별) |
| 조직당 동시 CometD 클라이언트 | 에디션별 상한 |
| PushTopic 채널 수 | 조직당 상한 |
| 이벤트 통지/일 | 이벤트 종류별 일일 전달 allocation |
| 보존창 | PushTopic·Generic 24h / Platform Event·CDC 72h |

> 정확한 수치는 에디션·기능 라이선스에 따라 다르므로 공식 "Streaming API Limits"(Streaming API Developer Guide) 표를 확인한다. Platform Event/CDC의 일일 전달 한도는 [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] 및 Platform Event allocation 문서를 참조.

---

## 마이그레이션 — CometD → Pub/Sub API (gRPC)

Streaming API(CometD)는 **레거시 경로**다. Salesforce는 신규 서버-투-서버 구독을 [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]]으로 안내한다.

| 관점 | Streaming API (CometD) | Pub/Sub API (gRPC) |
|---|---|---|
| 프로토콜 | HTTP/1.1 + Bayeux long polling | **gRPC + HTTP/2** 양방향 스트리밍 |
| 데이터 포맷 | JSON | **Apache Avro**(바이너리, 스키마) |
| 흐름 제어 | 서버 push (클라이언트 속도 제어 불가) | **pull/flow control**(클라이언트가 fetch 수 지정) |
| 다루는 이벤트 | PushTopic·Generic·PE·CDC | PE·CDC·실시간 이벤트 모니터링 (PushTopic·Generic 제외) |
| replay | replayId(-1/-2/특정) | ReplayPreset(LATEST/EARLIEST/CUSTOM) |
| 신규 구축 | 비권장 | ✅ 권장 |

**이유:** gRPC/HTTP2는 다중 스트림·낮은 오버헤드, Avro는 payload 축소, pull 방식은 구독자 과부하를 막는다. **주의:** Pub/Sub API는 **PushTopic·Generic Streaming을 지원하지 않는다** — 이 둘에 의존하는 UI 구독은 CometD에 남거나, Platform Event/CDC 기반으로 재설계해야 한다.

**마이그레이션 경로:**
1. 브라우저/LWC UI 구독(`empApi`) → **그대로 CometD 유지**(프론트엔드는 gRPC 불가).
2. PushTopic 기반 서버 구독 → **CDC**(레코드 변경) 또는 **Platform Event**로 이벤트 소스를 옮긴 뒤 Pub/Sub API로 구독.
3. Generic Streaming 서버 구독 → **Platform Event** 발행으로 대체 후 Pub/Sub API 구독.

---

## 관련 노트

- [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] — CometD를 대체하는 현대 gRPC 구독 API
- [[Platform Event 통합 패턴]] — Streaming 위에서 동작하는 이벤트 기반 통합 (empApi 포함)
- [[Change Data Capture — 개요·채널 구독]] — CometD로 구독하는 CDC(`/data/…ChangeEvent`)의 개념·채널·복제 허브
- [[통합 MOC]] — Integration 섹션 전체 목차
