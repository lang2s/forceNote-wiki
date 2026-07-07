---
tags: [integration, pub-sub-api, grpc, how-to, subscribe, publish, avro, flow-control, platform-event, cdc, python, java]
source: developer.salesforce.com/docs/platform/pub-sub-api/guide/ + github.com/forcedotcom/pub-sub-api
created: 2026-07-07
aliases: [Pub/Sub API 클라이언트, gRPC 클라이언트 구축, pubsub_api.proto, grpcio-tools stub, FetchRequest 루프, credit 보충, Avro 디코드 절차, Publish 발행 절차, ManagedSubscribe how-to, Pub Sub 구독 예제]
---

# Pub-Sub API 클라이언트 구축 가이드 (gRPC 구독·발행)

> 외부 시스템(Python·Java·Node 등)에서 **gRPC**로 Salesforce Platform Event·CDC를 실제로 구독/발행하는 클라이언트를 세우는 **절차(how-to)**. proto stub 생성 → 인증 메타데이터 → `GetTopic`/`GetSchema`/`Subscribe` 구독 루프(credit flow control·Avro 디코드) → `Publish` 발행 → 트러블슈팅 순. 개념·RPC 레퍼런스는 짝 노트 [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] 참조.

---

## 이 노트의 위치

| 노트 | 역할 |
|---|---|
| [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] | **개념·레퍼런스** — 6개 RPC, 메시지 필드, pull/flow control 이론, replay, ManagedSubscribe, 채널 종류 |
| **이 노트** | **절차** — 실제 클라이언트를 붙이는 단계별 구축 (stub 생성·인증 코드·구독 루프 코드·발행 코드·트러블슈팅) |

먼저 개념 노트로 "무엇/왜"를 잡고, 이 노트로 "어떻게 붙이나"를 실행한다.

---

## 0. 준비물 체크리스트

```
□ 통합 사용자 계정 (전용, API 활성) — [[Integration User & API-Only User (통합 사용자)]]
□ 인증 수단: OAuth 액세스 토큰 획득 경로 (JWT Bearer / Client Credentials)
   → [[서버간 통합 구축 가이드 - External Client App·JWT Bearer·Client Credentials]]
□ 구독/발행할 이벤트 채널이 org에 존재 (Platform Event __e 정의 or CDC 활성화)
□ proto 파일: pubsub_api.proto (forcedotcom/pub-sub-api 레포)
□ gRPC 툴체인: 언어별 (Python grpcio-tools / Java protobuf-gradle-plugin 등)
□ 엔드포인트 도달 가능: api.pubsub.salesforce.com:7443 (TLS 필수)
```

> Pub/Sub API는 **인증 RPC를 제공하지 않는다.** 액세스 토큰은 별도로(OAuth 또는 세션 로그인) 먼저 확보해 gRPC 메타데이터로 실어 보낸다.

---

## 1. proto 획득 & 언어별 stub 생성

클라이언트 코드는 `pubsub_api.proto`(공식 레포 `forcedotcom/pub-sub-api`)에서 언어별 stub을 생성해 만든다.

### 1-1. Python (grpcio-tools)

```bash
# 구조 예시 — 실제 동작 코드 아님(패키지 버전·경로는 환경에 맞춤)
pip install grpcio grpcio-tools protobuf avro-python3 requests

# pubsub_api.proto 로부터 stub 2개 생성
python -m grpc_tools.protoc \
  --proto_path=. \
  --python_out=. \
  --grpc_python_out=. \
  pubsub_api.proto
# → pubsub_api_pb2.py       (메시지 타입: FetchRequest, FetchResponse, TopicInfo ...)
# → pubsub_api_pb2_grpc.py  (PubSubStub: GetTopic/GetSchema/Subscribe/Publish ...)
```

```python
# 구조 예시 — 생성된 stub import
import pubsub_api_pb2 as pb2
import pubsub_api_pb2_grpc as pb2_grpc
```

### 1-2. Java (Gradle protobuf 플러그인)

```groovy
// 구조 예시 — 실제 동작 설정 아님(build.gradle 발췌)
plugins { id 'com.google.protobuf' version '0.9.x' }
dependencies {
  implementation 'io.grpc:grpc-netty-shaded:1.x'
  implementation 'io.grpc:grpc-protobuf:1.x'
  implementation 'io.grpc:grpc-stub:1.x'
  implementation 'org.apache.avro:avro:1.11.x'
}
protobuf {
  protoc { artifact = 'com.google.protobuf:protoc:3.x' }
  plugins { grpc { artifact = 'io.grpc:protoc-gen-grpc-java:1.x' } }
}
// pubsub_api.proto 를 src/main/proto/ 에 두면 build 시 PubSubGrpc.PubSubStub 등 생성
```

생성 결과: `PubSubGrpc.PubSubBlockingStub`(unary용), `PubSubGrpc.PubSubStub`(스트리밍용), 그리고 `FetchRequest`/`FetchResponse` 등 메시지 클래스.

> Node·C++·Go 등도 동일: 같은 proto에서 해당 언어 protoc 플러그인으로 stub만 바꿔 생성한다. gRPC 지원 11개 언어 모두 이 방식.

---

## 2. 인증 — 액세스 토큰 확보 + gRPC 메타데이터 3종

Pub/Sub API는 자격을 **각 RPC 호출의 gRPC 메타데이터(헤더)**로 받는다. Apex의 [[Named Credential]]이 아니다.

### 2-1. 토큰 획득 (사전 단계)

서버-서버 통합이면 브라우저 없는 플로우를 쓴다 — 상세 절차는 [[서버간 통합 구축 가이드 - External Client App·JWT Bearer·Client Credentials]]:

| 플로우 | 언제 | 산출물 |
|---|---|---|
| JWT Bearer | 인증서 기반, 특정 통합 사용자로 impersonate | `access_token` + `instance_url` |
| Client Credentials | External Client App에 "Run As" 통합 사용자 지정 | `access_token` + `instance_url` |

두 플로우 모두 token 응답에서 `access_token`과 `instance_url`을 얻는다. **`tenantid`(org ID)**는 org의 18자리 ID로, `/services/oauth2/userinfo`의 `organization_id`나 Identity URL에서 얻는다.

### 2-2. 메타데이터 3종 세팅

| 메타데이터 키 | 값 | 주의 |
|---|---|---|
| `accesstoken` | OAuth 액세스 토큰(또는 세션 ID) | **키 이름 소문자 필수** — `AccessToken`처럼 대문자면 인증 실패(에러 메시지 불친절) |
| `instanceurl` | `https://MyDomain.my.salesforce.com` | 토큰 응답의 `instance_url` |
| `tenantid` | org(테넌트) 18자리 ID | userinfo의 `organization_id` |

```python
# 구조 예시 — 실제 동작 코드 아님. TLS 채널 + 메타데이터
import grpc
creds   = grpc.ssl_channel_credentials()                      # TLS 필수
channel = grpc.secure_channel('api.pubsub.salesforce.com:7443', creds)
stub    = pb2_grpc.PubSubStub(channel)

# 매 RPC 호출에 실어 보낼 메타데이터 (키 이름 소문자)
auth_metadata = (
    ('accesstoken', access_token),
    ('instanceurl', instance_url),
    ('tenantid',    tenant_id),
)
```

```java
// 구조 예시 — 실제 동작 코드 아님. Java Metadata + attachHeaders
Metadata headers = new Metadata();
headers.put(Metadata.Key.of("accesstoken", Metadata.ASCII_STRING_MARSHALLER), accessToken);
headers.put(Metadata.Key.of("instanceurl", Metadata.ASCII_STRING_MARSHALLER), instanceUrl);
headers.put(Metadata.Key.of("tenantid",    Metadata.ASCII_STRING_MARSHALLER), tenantId);
PubSubGrpc.PubSubStub asyncStub =
    MetadataUtils.attachHeaders(PubSubGrpc.newStub(channel), headers);
```

> 토큰 만료: 세션 타임아웃(기본 2시간 무활동)에 걸리면 RPC가 인증 에러를 던진다 → 토큰을 재발급해 스트림을 다시 연다(3-5절 재구독).

---

## 3. 구독 루프 — GetTopic → GetSchema → Subscribe (flow control·Avro)

### 3-1. 스키마 조회 (구독 전 1회)

```python
# 구조 예시 — 실제 동작 코드 아님
import json, avro.schema, avro.io, io

TOPIC = "/event/Order_Event__e"          # 또는 /data/AccountChangeEvent

# 1) 토픽 정보 → 최신 schema_id
topic = stub.GetTopic(pb2.TopicRequest(topic_name=TOPIC), metadata=auth_metadata)
schema_id = topic.schema_id

# 2) schema_id → Avro 스키마(JSON). schema_id 키로 캐싱
schema_cache = {}
def get_schema(sid):
    if sid not in schema_cache:
        resp = stub.GetSchema(pb2.SchemaRequest(schema_id=sid), metadata=auth_metadata)
        schema_cache[sid] = avro.schema.parse(resp.schema_json)
    return schema_cache[sid]
```

### 3-2. Avro 디코드 함수

```python
# 구조 예시 — 실제 동작 코드 아님. 수신 payload(Avro 바이너리) 디코드
def decode(schema, payload_bytes):
    reader = avro.io.DatumReader(schema)
    decoder = avro.io.BinaryDecoder(io.BytesIO(payload_bytes))
    return reader.read(decoder)
```

### 3-3. Subscribe 스트림 + credit 보충 (핵심)

`Subscribe`는 **양방향 스트리밍**이다. 클라이언트가 `FetchRequest`(요청 스트림)를 흘려보내면 서버가 `FetchResponse`(응답 스트림)로 이벤트를 내려준다. `num_requested`는 배치 크기가 아니라 **크레딧**이라, 소진하면 다시 `FetchRequest`를 보내 보충해야 스트림이 계속 흐른다(최대 100).

```python
# 구조 예시 — 실제 동작 코드 아님. 세마포어로 credit 보충 (공식 Python 예제 패턴)
import threading, queue

semaphore = threading.Semaphore(1)   # 처리 여유 = 요청할 크레딧 신호
latest_replay_id = None              # 재개용으로 마지막 replay_id 보관

def fetch_req_stream(topic):
    """요청(FetchRequest) 스트림 제너레이터: 세마포어 획득할 때마다 크레딧 보충."""
    global latest_replay_id
    while True:
        semaphore.acquire()          # 처리 여유 생기면 잠금
        yield pb2.FetchRequest(
            topic_name    = topic,
            replay_preset = pb2.ReplayPreset.LATEST,   # 첫 요청에서만 적용됨
            num_requested = 1,                          # 이번에 받을 크레딧 (≤100)
        )

# 응답 스트림 소비
for response in stub.Subscribe(fetch_req_stream(TOPIC), metadata=auth_metadata):
    for event in response.events:
        schema = get_schema(event.event.schema_id)     # event별 schema_id로 디코드
        data   = decode(schema, event.event.payload)
        handle(data)                                    # 비즈니스 처리
        latest_replay_id = event.replay_id              # 매 이벤트 replay_id 저장
    # 이 배치 처리 끝 → 세마포어 release → fetch_req_stream이 다음 크레딧 요청
    semaphore.release()
    # response.pending_num_requested 로 서버 잔여를 보고 미리 더 요청(adaptive)도 가능
```

**flow control 규칙 요약** (상세는 [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]]):

| 항목 | 값 / 규칙 |
|---|---|
| `num_requested` 상한 | **100** (초과 요청 시 서버가 100으로 캡) |
| 의미 | 배치 크기 아님 — "지금 이만큼 처리할 수 있다"는 **크레딧** |
| 보충 안 하면 | 크레딧 소진 후 서버는 push하지 않음 → 스트림 정지 |
| `pending_num_requested` | 응답에 실린 미전달 잔여 수 → 추가 요청 판단 근거 |
| keepalive | 전부 전달돼 `pending=0`이면 **60초** 내 새 `FetchRequest` 필요(안 보내면 종료). 잔여 있으면 서버가 **270초** keepalive 유지 |
| replay 확정 | `replay_preset`/`replay_id`는 **첫 FetchRequest에만** 적용. 이후 요청의 replay 옵션은 무시 |

### 3-4. replayId로 재개 (다운타임 복구)

```python
# 구조 예시 — 실제 동작 코드 아님. 저장해둔 replay_id 직후부터 재개
yield pb2.FetchRequest(
    topic_name    = TOPIC,
    replay_preset = pb2.ReplayPreset.CUSTOM,
    replay_id     = saved_replay_id,   # 보존창(HVPE·CDC 72h) 안이어야 함
    num_requested = 100,
)
```

> 클라이언트가 replayId를 직접 저장/관리하기 싫으면 **ManagedSubscribe**로 오프셋을 서버에 맡긴다 — 개념·커밋 규칙은 짝 노트의 "ManagedSubscribe" 절.

---

## 4. 발행 — Publish / PublishStream (Avro 인코딩)

발행은 payload를 **동일 스키마로 Avro 인코딩**해 `ProducerEvent`에 넣고 `Publish`(1배치)나 `PublishStream`(연속·고처리량)을 호출한다.

```python
# 구조 예시 — 실제 동작 코드 아님. Avro 인코딩 후 Publish
def encode(schema, record_dict):
    writer = avro.io.DatumWriter(schema)
    buf = io.BytesIO()
    writer.write(record_dict, avro.io.BinaryEncoder(buf))
    return buf.getvalue()

# 발행할 이벤트의 schema_id 확보 (GetTopic → GetSchema, 3-1과 동일)
pub_topic  = stub.GetTopic(pb2.TopicRequest(topic_name=TOPIC), metadata=auth_metadata)
pub_schema = get_schema(pub_topic.schema_id)

payload = encode(pub_schema, {
    "CreatedDate":         int(time.time() * 1000),   # 필수 시스템 필드
    "CreatedById":         user_id,
    "Order_Number__c":     "SO-1001",                 # 커스텀 필드
    "Amount__c":           1299.00,
})

producer_event = pb2.ProducerEvent(schema_id=pub_topic.schema_id, payload=payload)
result = stub.Publish(
    pb2.PublishRequest(topic_name=TOPIC, events=[producer_event]),
    metadata=auth_metadata,
)
# result.results[i].replay_id / .correlation_key / (실패 시).error 확인
```

| RPC | 언제 |
|---|---|
| `Publish` (unary) | 이벤트 배치 1회 발행 → `PublishResponse` (건별 `PublishResult`) |
| `PublishStream` (양방향 스트리밍) | 한 스트림으로 연속 발행 — 고처리량. 각 `PublishRequest`마다 `PublishResponse` 수신 |

- `PublishResult`에 이벤트별 `replay_id`(성공)와 `error`(실패)가 담긴다 → **부분 실패**를 건별로 확인.
- `ProducerEvent.id`는 클라이언트가 부여하는 상관 키(correlation) — 응답에서 어느 이벤트 결과인지 매칭에 쓴다.

---

## 5. 트러블슈팅

| 증상 | 원인 | 처치 |
|---|---|---|
| 이벤트가 안 옴 / 스트림 곧 멈춤 | 크레딧 소진 후 `FetchRequest` 미보충 | 처리 끝날 때마다 `num_requested` 다시 전송(3-3 세마포어 패턴). `pending=0` 뒤 **60초** 넘기면 스트림 종료됨 |
| `num_requested`를 크게 줘도 100개까지만 | 서버가 **100으로 캡** | 정상. 배치가 아니라 크레딧이므로 반복 보충으로 흐름 유지 |
| 인증 실패(불친절한 에러) | 메타데이터 키 **대소문자** 오류 | `accesstoken`·`instanceurl`·`tenantid` **전부 소문자**. 값도 재확인 |
| 일정 시간 뒤 인증 만료 | 세션 타임아웃(기본 2h 무활동) | 토큰 재발급 후 채널/스트림 재생성. 장수명 통합은 갱신 로직 상시화 |
| payload가 깨져 읽힘 | 스키마 불일치 — 이벤트 정의 변경으로 `schema_id`가 바뀜 | **schema_id를 키로 캐싱**하고, event별 `schema_id`로 `GetSchema` 재조회(3-1). 토픽 단위로 한 번만 받아 고정하지 말 것 |
| `CUSTOM` replay 재개 실패 | `replay_id`가 **보존창 밖** (HVPE·CDC 72h / 표준 24h) | 창 안이면 CUSTOM, 벗어났으면 EARLIEST로 폴백. 다운타임이 길면 ManagedSubscribe 고려 |
| replay 위치를 바꿔도 무시됨 | replay 옵션은 **첫 FetchRequest에만** 적용 | 위치 변경은 새 `Subscribe` 스트림을 열어서 첫 요청에 지정 |
| 유휴 연결 끊김 | keepalive 시간 초과 | pending 있으면 서버가 270초 유지, pending=0이면 60초 내 재요청. 그래도 끊기면 재 Subscribe |

---

## 관련 노트
- [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]]
- [[Platform Event 통합 패턴]]
- [[서버간 통합 구축 가이드 - External Client App·JWT Bearer·Client Credentials]]
- [[Integration User & API-Only User (통합 사용자)]]
- [[Named Credential]]
- [[통합 MOC]]
