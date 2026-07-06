---
tags: [integration, platform-event, cdc, pub-sub-api, grpc, streaming, avro, event-driven]
source: developer.salesforce.com/docs/platform/pub-sub-api/guide/
created: 2026-07-06
aliases: [Pub/Sub API, PubSub API, gRPC 구독, ManagedSubscribe, ReplayPreset, FetchRequest, Avro, CometD 대체, Platform Event 외부 구독, CDC 구독 API]
---

# Pub/Sub API (gRPC) — Platform Event·CDC 구독

> 외부 클라이언트가 **gRPC/HTTP2 + Apache Avro**로 Platform Event·CDC·실시간 이벤트 모니터링을 발행/구독/스키마조회하는 단일 API. CometD(Streaming API)를 대체하며, 구독은 클라이언트가 처리 속도를 제어하는 **pull(flow control)** 방식이다.

---

## 개요

Pub/Sub API는 이벤트를 발행·구독·스키마조회하는 **단일 gRPC 인터페이스**다. Streaming API의 CometD(long-polling) 방식을 대체하는, Salesforce 외부(Java·Python·Node·C++ 등)에서 이벤트 스트림을 다루기 위한 관문이다.

| 항목 | 내용 |
|---|---|
| 프로토콜 | **gRPC API + HTTP/2** (양방향 스트리밍 지원) |
| 페이로드 포맷 | **Apache Avro 바이너리** (압축, 고성능 실시간 스트리밍) |
| 엔드포인트 | `api.pubsub.salesforce.com` : **7443** (또는 443) |
| 클라이언트 언어 | gRPC가 지원하는 **11개 언어** (Python·Java·Node·C++ 등) |
| 지원 이벤트 | High-volume Platform Event(custom·standard)·Change Data Capture·실시간 이벤트 모니터링 |
| 미지원 | 레거시 이벤트 — standard-volume PE·PushTopic·generic streaming |
| 구독 모델 | **Pull** — 클라이언트가 `FetchRequest`로 원하는 수만큼 당겨감(flow control). 서버가 밀어붙이지(push) 않음 |

CometD와의 관계: 위키 내 CometD/Streaming 기반 구독은 [[Platform Event 정의와 구독]]·[[Platform Event 통합 패턴]]에 정리돼 있고, Pub/Sub API는 그 gRPC 대체재다.

---

## 인증 — gRPC 메타데이터 (Named Credential 아님)

Pub/Sub API는 **외부 클라이언트**가 붙는 API이므로 Apex의 [[Named Credential]]이 아니라 **gRPC 호출 메타데이터(헤더)**로 자격을 전달한다. 각 RPC 호출마다 세 개의 메타데이터 키를 실어 보낸다.

| 메타데이터 키 | 값 |
|---|---|
| `accesstoken` | 액세스 토큰 — **세션 ID** 또는 **OAuth 액세스 토큰** |
| `instanceurl` | org의 인스턴스 URL (예: `https://MyDomainName.my.salesforce.com`) |
| `tenantid` | org(테넌트) ID |

토큰은 세션 토큰(username/password 로그인으로 얻은 세션 ID)이나 OAuth 플로우로 획득한다. 토큰이 만료되면 스트리밍 RPC의 경우 `FetchRequest.auth_refresh`로 갱신 토큰을 흘려보낼 수 있다(내부용 필드).

---

## 핵심 RPC 메서드

`PubSub` gRPC 서비스는 6개 RPC를 노출한다.

| RPC | 종류 | 설명 |
|---|---|---|
| `GetTopic` | unary | 토픽 정보(`TopicInfo`) 조회 — 최신 `schema_id`, 발행/구독 가능 여부 포함 |
| `GetSchema` | unary | `schema_id`로 Avro 스키마(JSON) 조회 — payload 인코딩/디코딩에 사용 |
| `Subscribe` | **양방향 스트리밍** | 이벤트 구독. 클라이언트가 `FetchRequest`를 보내고 서버가 `FetchResponse`로 이벤트를 흘려줌 |
| `ManagedSubscribe` | **양방향 스트리밍** | 서버가 replay 오프셋을 관리하는 durable 구독(아래 별도 절) |
| `Publish` | unary | 이벤트 배치 1회 발행 → `PublishResponse` |
| `PublishStream` | **양방향 스트리밍** | 스트리밍 발행 — 한 스트림으로 연속 발행 (고처리량) |

### 주요 메시지 필드 (proto)

```protobuf
// 구조 예시 — forcedotcom/pub-sub-api pubsub_api.proto 발췌 요약
message FetchRequest {
  string       topic_name    = 1;  // 구독 채널명
  ReplayPreset replay_preset = 2;  // LATEST / EARLIEST / CUSTOM
  bytes        replay_id     = 3;  // CUSTOM일 때 시작 지점(불투명 bytes)
  int32        num_requested = 4;  // 이번에 받을 이벤트 수 (최대 100)
  string       auth_refresh  = 5;  // 내부용 토큰 갱신
}

message FetchResponse {
  repeated ConsumerEvent events               = 1;  // Avro 바이너리 payload 포함
  bytes                  latest_replay_id     = 2;
  string                 rpc_id               = 3;
  int32                  pending_num_requested = 4; // 아직 안 보낸 잔여 수
}

enum ReplayPreset { LATEST = 0; EARLIEST = 1; CUSTOM = 2; }
```

발행 측 `ProducerEvent`는 `id`·`schema_id`·`payload`(Avro)·`headers`를 담고, `PublishResponse`는 `PublishResult` 배열과 사용된 `schema_id`·`rpc_id`를 돌려준다.

---

## 구독 플로우 — Pull & Flow Control (핵심)

CometD의 push와 달리 Pub/Sub API 구독은 **클라이언트가 처리 능력만큼 당겨오는 pull 모델**이다. 발행 스파이크가 나도 클라이언트가 밀리지 않는다.

```
// 구조 예시 — Subscribe 스트림 상호작용
클라이언트 → 서버 : Subscribe 스트림 open
클라이언트 → 서버 : FetchRequest{ topic_name, replay_preset, num_requested = N }   // N ≤ 100
서버 → 클라이언트 : FetchResponse{ events[...], pending_num_requested }
클라이언트          : events 디코드·처리
클라이언트 → 서버 : FetchRequest{ num_requested = M }   // 처리한 만큼 보충(credit)
...반복 (스트림 유지)
```

| 개념 | 규칙 |
|---|---|
| `num_requested` | 이번에 받을 **처리 가능 이벤트 수**. **최대 100** — 초과 요청 시 서버가 100으로 캡. 배치 크기가 아니라 **크레딧** 개념 |
| 보충(replenish) | 서버는 밀어붙이지 않으므로, 소진하면 다시 `FetchRequest`로 크레딧을 채워야 계속 받음 |
| `pending_num_requested` | 응답에 실린 **아직 미전달 잔여 수** → 얼마나 더 요청할지 판단 근거 |
| 흐름 제어 전략 | ① 1개씩 순차 ② 100개 요청 후 전부 수신 대기 ③ 응답 관찰하며 pending 소진 전에 미리 추가 요청(adaptive) |
| 스트림 유지 | 모두 전달돼 `pending=0`이면 **60초 내** 새 `FetchRequest` 필요(안 보내면 스트림 종료 → 재 Subscribe). pending이 남아 있으면 서버가 **270초** 내 keepalive로 유지 |
| replay 확정 시점 | 최초 `FetchRequest`의 replay 옵션만 적용. **이후 FetchRequest의 replay 옵션은 무시** — 위치를 바꾸려면 `Subscribe`를 다시 호출 |

---

## Replay — 재생 위치 지정

구독 시작 위치는 최초 `FetchRequest`의 `replay_preset`(+`replay_id`)로 정한다. `replayId`는 **불투명(opaque) bytes**로, 스트림 내 위치를 가리키는 핸들이다.

| ReplayPreset | 시작 지점 |
|---|---|
| `LATEST` (기본) | 스트림의 **tip** — 구독 이후 새로 발행되는 이벤트만 |
| `EARLIEST` | **보존창(retention window)의 가장 이른** 이벤트부터 |
| `CUSTOM` | 지정한 `replay_id` **직후**부터 — 다운타임 후 마지막 처리 지점 재개에 사용 |

- **보존창 안에서만** 재생 가능. High-volume Platform Event·CDC는 **72시간**, 표준 보존은 **24시간**(상세·정확 수치는 [[Platform Event 한도와 고려사항]] 참조 — 여기서 중복하지 않음).
- 보존창을 벗어난 `replay_id`로 `CUSTOM` 구독하면 실패한다.

---

## ManagedSubscribe — durable(서버 관리) 구독

`Subscribe`는 클라이언트가 마지막 `replayId`를 **직접 저장**해야 재개할 수 있다. `ManagedSubscribe`는 그 오프셋 관리를 **Salesforce 서버가 대신** 맡는 durable 구독이다.

| 항목 | 내용 |
|---|---|
| 오프셋 저장 | 클라이언트가 `CommitReplayRequest`로 커밋하면 **서버에 replayId 저장** → 재구독 시 그 지점부터 자동 재개. 클라이언트가 replayId를 보관할 필요 없음 |
| 커밋 방식 | **자동 아님 — 명시적 커밋.** 받은 `ManagedFetchResponse`마다 replayId를 커밋 권장(이벤트 수신 후 30분, 잔여 없을 때 신규 요청 시 60초 내) |
| 설정 메타데이터 | **Managed Event Subscription** — Metadata API/Tooling API로 만드는 구성 레코드. 에러 발생 후 재시도 동작과 구독 상태를 제어 |
| 구독 식별 | 개발자 이름 등으로 지정하는 서버측 named 구독 |

> 정리: 여러 인스턴스에서 안정적으로 이어받는 durable 구독이 필요하면 `ManagedSubscribe`, 클라이언트가 오프셋을 스스로 다루는 가벼운 구독이면 `Subscribe`.

---

## Avro 디코드 & 스키마 캐싱

수신 payload는 **Avro 바이너리**이므로 스키마 없이 못 읽는다. 각 이벤트는 `schema_id`를 달고 오며, `GetSchema(schema_id)`로 받은 Avro 스키마(JSON)로 디코드한다.

```
// 구조 예시 — 수신 처리 흐름
1) FetchResponse.events[i].schema_id 확인
2) 캐시에 없으면 GetSchema(schema_id) → Avro 스키마 획득 → 캐시
3) 스키마로 events[i].payload(Avro 바이너리) 디코드 → 필드 값 사용
```

- 이벤트 정의가 바뀌면 `schema_id`가 달라지므로 **schema_id를 키로 캐싱**하면 스키마 변경을 자동 감지한다.
- 발행 시에도 동일 스키마로 payload를 Avro 인코딩해 `ProducerEvent.payload`에 넣는다.

---

## 지원 채널

| 채널 유형 | 형식 | 비고 |
|---|---|---|
| Platform Event | `/event/{Name}__e` | custom·standard high-volume PE |
| CDC — 개별 객체 | `/data/{Object}ChangeEvent` | 예: `/data/AccountChangeEvent` ([[ChangeEvent Objects]]·[[ChangeEventHeader]]) |
| CDC — 전체 | `/data/ChangeEvents` | CDC로 활성화된 모든 객체 |
| 커스텀 채널 | `/event/{Name}__chn` | 여러 이벤트 묶음 + **서버측 필터** |

### 커스텀 채널 필터 (서버측 필터링)

커스텀 채널의 **ChannelMember**에 `filterExpression`을 걸면, 서버가 조건에 맞는 이벤트만 스트림으로 내려보낸다(클라이언트에서 거르는 게 아니라 **서버측 필터링**).

- 필터 표현식은 **SOQL 부분집합**(일부 연산자·필드 타입) 기반. 여러 field expression을 논리 연산자로 결합 가능. 예: `City = 'San Francisco' AND Amount < 1000`.
- **지원 클라이언트: Pub/Sub API·CometD 클라이언트·Event Relay만.** Apex 트리거·Flow 구독은 이 필터를 **미지원**.

---

## Event Relay와의 관계

**Event Relay**는 코드 없이 Platform Event/CDC를 **AWS EventBridge**로 흘려보내는 관리형 대안이다. Pub/Sub API가 외부 클라이언트가 직접 gRPC로 당겨오는 방식이라면, Event Relay는 클라이언트 구현 없이 Salesforce가 이벤트를 밀어주는 관리형 경로다(별도 주제).

---

## 관련 노트
- [[Platform Event 정의와 구독]]
- [[Platform Event 발행]]
- [[Platform Event 통합 패턴]]
- [[Platform Event 한도와 고려사항]]
- [[ChangeEventHeader]]
- [[ChangeEvent Objects]]
- [[Named Credential]]
