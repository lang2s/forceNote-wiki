---
tags: [integration, platform-event, event-driven, how-to, guide, pub-sub, idempotency, hub]
source: forceNote-wiki 기존 Platform Event 노트 종합(Platform Event 정의와 구독·발행·통합 패턴·한도) + help.salesforce.com Platform Events 검증 (Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/
created: 2026-07-07
aliases: [Platform Event 구축 가이드, 이벤트 기반 통합 how-to, event-driven integration end-to-end, Platform Event end-to-end, 이벤트 통합 절차, Platform Event 처음부터 끝까지, 이벤트 통합 시작]
---

# 이벤트 기반 통합 구축 가이드 (Platform Event end-to-end)

> Platform Event로 이벤트 기반 통합을 **정의 → 발행 → 구독 → 멱등 소비 → 재시도·복구** 한 흐름으로 처음부터 끝까지 따라가는 **절차 허브**. 각 단계의 상세(API 시그니처·한도·필드)는 기존 노트로 위임하고, 여기서는 **어느 단계에 무엇을 하고 어디를 읽어야 하는지**만 엮는다.

> [!note] 이 노트는 흩어진 Platform Event 노트들의 **진입점**이다. 개념·레퍼런스는 각 링크가 정본이며, 여기서 중복 서술하지 않는다.

---

## 0. 언제 이벤트 기반을 고르나

이벤트 기반(Platform Event)은 **발행자와 구독자를 분리(decoupling)** 하고, 한 이벤트를 **여러 구독자에게 팬아웃(fan-out)** 하며, 처리를 **비동기**로 미루고 싶을 때 쓴다. 반대로 응답값을 즉시 소비해야 하거나(동기 요청·응답), 단일 엔드포인트로 무코드 push면 다른 메커니즘이 낫다.

- 위상(직결 vs 미들웨어)·통지 메커니즘(Platform Event vs Outbound Message vs REST 콜아웃) 선택은 → **[[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]]** 2절 비교표에서 먼저 결정한다.
- "레코드 변경을 그대로" 외부에 흘려보내는 동기화라면 커스텀 Platform Event 대신 **CDC**가 맞을 수 있다 — 선택 기준은 [[Platform Event 한도와 고려사항]] "Platform Events vs CDC" 표 참조.

이벤트 기반으로 가기로 했다면 아래 5단계를 순서대로 밟는다.

---

## 1. 전체 흐름 (5단계 파이프라인)

```text
// 구조 예시 — 실제 원본 다이어그램 아님
(a) 정의            (b) 발행                  (c) 구독                   (d) 멱등 소비        (e) 재시도·복구
─────────           ─────────                 ─────────                  ─────────           ─────────
Setup에서 __e   →   EventBus.publish     →    Apex after insert    →    EventUuid로       →   RetryableException
객체·필드           Flow / REST / Pub-Sub      LWC empApi                중복 차단(upsert)      setResumeCheckpoint
Publish Behavior    (SaveResult 확인)          Pub/Sub API(외부)         (Processed 로그)       replayId 재생
```

각 단계는 아래에서 한 문단씩 짚고, **상세는 위임 링크**로 넘긴다.

### (a) Platform Event 객체 정의

Setup → **Platform Events** → New. 표준 필드 입력 후 **Publish Behavior**(Publish Immediately 기본 / Publish After Commit)를 고르고 커스텀 필드를 추가한다. 이벤트 객체는 `__e` 접미사(예: `Order_Event__e`). 새 이벤트는 **고볼륨(High-volume)** 이 기본(표준볼륨은 Summer '27 은퇴 예정).

- Publish Behavior 선택(즉시 vs 커밋 후)의 함정 — 구독자가 커밋된 데이터를 조회해야 하면 **After Commit** 필수. → 디커플드 발행-구독 함정은 [[Platform Event 한도와 고려사항]] "디커플드 발행-구독" 절.
- 필드·시스템 필드(ReplayId·EventUuid)·정의 상세 → **[[Platform Event 정의와 구독]]** "정의(Setup)" 절.
- SFDX 메타데이터(`__e.object-meta.xml`, `<eventType>HighVolume</eventType>`) 정의 예시 → [[Platform Event 발행]] · [[Platform Event 통합 패턴]].

### (b) 발행

발행 수단은 네 가지: **Apex `EventBus.publish()` / Flow(Publish Message) / REST API / Pub/Sub API**. Apex 발행은 메인 트랜잭션 커밋 시 실제 발행되고 롤백 시 취소된다(단 Pub/Sub API 발행엔 Publish Behavior 미적용).

```apex
// 다건 발행 + 결과 확인 (핵심 골격 — 상세는 위임 링크)
List<Order_Event__e> events = new List<Order_Event__e>();
for (Order o : orders) {
    events.add(new Order_Event__e(OrderId__c = o.Id, Status__c = o.Status));
}
List<Database.SaveResult> results = EventBus.publish(events);
for (Database.SaveResult sr : results) {
    if (!sr.isSuccess()) System.debug('발행 실패: ' + sr.getErrors()[0].getMessage());
}
```

- Apex 발행 패턴·트랜잭션 동작·REST 발행(외부→SF) → **[[Platform Event 통합 패턴]]** (발행 패턴·REST API 발행 절).
- `EventBus.publish` 시그니처·`OPERATION_ENQUEUED` 상태 → [[EventBus Namespace]], 비동기 최종 결과 콜백 → [[EventBus Publish Callbacks]].

### (c) 구독 선택

구독 수단을 **워크로드에 맞게** 고른다. 세 갈래:

| 구독 수단 | 실행 위치 | 언제 |
|---|---|---|
| **Apex `after insert` 트리거** | Salesforce 내부 | SF 안에서 이벤트를 받아 DML·후속 로직 실행. 서버측 커스텀 채널 필터 **미지원**(표준 채널만) |
| **LWC `lightning/empApi`** | 브라우저(Lightning 세션) | 실시간 UI 갱신. 세션이 살아있는 동안만 구독 유지 |
| **Pub/Sub API (gRPC, 외부)** | Salesforce 외부 클라이언트 | 외부 시스템(Java·Python·Node 등)이 pull(flow control)로 당겨감. CometD 대체 |

- Apex 트리거 수신 패턴 → **[[Platform Event 정의와 구독]]** "구독 — Apex after insert 트리거" 절.
- LWC empApi 전체 라이프사이클(`isEmpEnabled`·`setDebugFlag`·async 구독·안전 해제) → **[[Platform Event 통합 패턴]]** "LWC 실전 라이프사이클" 절.
- 외부 gRPC 구독(FetchRequest·num_requested≤100·ManagedSubscribe·Avro 디코드) → **[[Pub-Sub API (gRPC) — Platform Event·CDC 구독]]**.

### (d) 멱등 소비 (중복 안전)

이벤트는 **at-least-once**(최소 한 번) — 같은 이벤트가 두 번 도착하거나 순서가 뒤바뀔 수 있다. 이건 버그가 아니라 계약이므로 **수신자를 멱등하게** 설계한다. 각 이벤트가 실어오는 **`EventUuid`**(메시지 고유 UUID, v52.0+)를 Unique External Id 필드에 upsert해 중복을 차단한다.

```apex
// 구조 예시 — EventUuid를 처리 로그에 upsert해 중복 소비 차단
trigger OrderEventTrigger on Order_Event__e (after insert) {
    List<Processed_Message__c> logs = new List<Processed_Message__c>();
    for (Order_Event__e e : Trigger.new) {
        logs.add(new Processed_Message__c(External_Message_Id__c = e.EventUuid));
    }
    // Unique External_Message_Id__c 로 upsert → 이미 처리한 이벤트는 no-op
    Database.upsert(logs, Processed_Message__c.External_Message_Id__c, false);
    // 신규 삽입분만 실제 부수효과 실행(1회 보장)
}
```

- 고유 식별은 **ReplayId가 아니라 EventUuid** 를 쓴다(ReplayId는 org 유지보수 시 유일성 보장 안 됨) → [[Platform Event 정의와 구독]] "시스템 필드".
- External Id + upsert 멱등 설계 원리·소비자 멱등 처리 → **[[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]]** 4절.

### (e) 재시도·복구

일시적 오류나 외부 조건 대기 시 **재시도**하고, 다운타임 후에는 **replay** 로 놓친 이벤트를 복구한다.

| 방법 | 동작 |
|---|---|
| **`EventBus.RetryableException`** | Apex 트리거가 이 예외를 던지면 플랫폼이 재전달. 최대 재시도 초과 시 error 상태(구독 끊김) + 이메일 알림 |
| **`setResumeCheckpoint(replayId)`** | DML 커밋 후 체크포인트 설정 → 재시작 시 그 ReplayId **이후부터** 순차 재처리 |
| **replay (재생)** | 구독 시작 위치를 지정해 보존창 내 과거 이벤트 재수신 — Apex/LWC는 `-1`(새 이벤트만)/`-2`(보존창 내 저장분), Pub/Sub API는 `ReplayPreset`(LATEST/EARLIEST/CUSTOM) |

```apex
// 트리거에서 커밋된 지점 이후부터 재개
EventBus.TriggerContext.currentContext().setResumeCheckpoint(
    Trigger.new[Trigger.new.size() - 1].ReplayId
);
```

- RetryableException·setResumeCheckpoint 상세 → **[[Platform Event 정의와 구독]]** "재시도" 절, 재시도↔멱등 짝 원칙 → [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] 4절.
- 외부 durable 재생(ManagedSubscribe·CommitReplayRequest·CUSTOM replay) → [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] "ManagedSubscribe·Replay" 절.
- 보존창: 고볼륨 **72시간** / 표준 24시간 — 이 창을 벗어난 replay는 실패 → [[Platform Event 한도와 고려사항]] "할당량·보관".

---

## 2. 단계 ↔ 정본 노트 매핑

각 단계를 더 깊이 파려면 그 단계의 정본 노트로 간다. 이 표가 라우팅의 핵심이다.

| 단계 | 무엇을 | 정본 노트 |
|---|---|---|
| **선택 전** | 이벤트 기반이 맞나·통지 메커니즘 비교·CDC vs PE | [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] · [[Platform Event 한도와 고려사항]] |
| **(a) 정의** | Setup·`__e`·Publish Behavior·시스템 필드·SFDX 메타데이터 | [[Platform Event 정의와 구독]] · [[Platform Event 통합 패턴]] |
| **(b) 발행** | `EventBus.publish`·SaveResult·트랜잭션·REST 발행 | [[Platform Event 발행]] · [[Platform Event 통합 패턴]] · [[EventBus Namespace]] · [[EventBus Publish Callbacks]] |
| **(c) 구독 — Apex** | after insert 트리거·커스텀 채널 제약 | [[Platform Event 정의와 구독]] |
| **(c) 구독 — LWC** | empApi 라이프사이클·isEmpEnabled·replayId | [[Platform Event 통합 패턴]] |
| **(c) 구독 — 외부** | Pub/Sub API gRPC·flow control·Avro·ManagedSubscribe | [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] |
| **(d) 멱등 소비** | EventUuid·External Id upsert·중복 차단 | [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] · [[Platform Event 정의와 구독]] |
| **(e) 재시도·복구** | RetryableException·setResumeCheckpoint·replay | [[Platform Event 정의와 구독]] · [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] |
| **테스트·한도** | Test.getEventBus·할당량·보관·정의 한도 | [[Platform Event Apex 테스트]] · [[Platform Event 한도와 고려사항]] |

---

## 3. 테스트·한도 — 배포 전 체크

- **테스트**: 테스트에서 이벤트를 발행하면 `Test.stopTest()` 시점에 구독 트리거가 동기 실행된다. 강제 전달·실패 시뮬레이션은 `Test.getEventBus().deliver()` — 상세 → **[[Platform Event Apex 테스트]]**.
- **한도(배포 전 반드시 확인)**: 시간당 **발행** 할당량(고볼륨 250k/250k/50k)·24시간 **전달** 할당량(50k/25k/10k, PE+CDC 공유)·org당 정의 수(100/50/5)·메시지 최대 **1 MB**. Apex 트리거·Flow 구독은 전달 할당량 미소비(발행만). 정확 수치·에디션별 표·`/limits` 조회 → **[[Platform Event 한도와 고려사항]]**.
- **주의 함정**: 이벤트 정의 삭제는 **복구 불가**, 이름 변경 시 구독자 **재구독 필요**, 이벤트 메시지는 **SOQL 쿼리 불가**. → [[Platform Event 한도와 고려사항]] "정의 고려사항".

---

## 관련 노트

- [[Platform Event 통합 패턴]] — 발행·Apex 트리거 수신·LWC empApi 실전 라이프사이클·REST 발행
- [[Platform Event 정의와 구독]] — 정의(Setup·Publish Behavior)·Apex 트리거 구독·재시도
- [[Platform Event 발행]] — `EventBus.publish` 기본 패턴·SFDX 메타데이터
- [[Platform Event 한도와 고려사항]] — 할당량·보관·정의 함정·PE vs CDC
- [[Platform Event Apex 테스트]] — Test.getEventBus deliver/fail
- [[EventBus Namespace]] — publish/TriggerContext API 시그니처
- [[EventBus Publish Callbacks]] — onSuccess/onFailure 콜백
- [[Pub-Sub API (gRPC) — Platform Event·CDC 구독]] — 외부 gRPC 구독·발행·replay·ManagedSubscribe
- [[통합 아키텍처 결정 - 미들웨어·재시도·멱등성]] — 이벤트 기반 선택·멱등성·재시도 설계 프레임
- [[ChangeEventHeader]] — CDC(레코드 변경 자동 이벤트) 대안
- [[통합 MOC]] — 통합 패턴 인덱스(방향·동기/비동기 축)
