---
tags: [apex, platform-events, limits, considerations, allocations, cdc]
source: platform_events.pdf (Platform Events Developer Guide v67.0, Summer '26, Tier 2) · salesforce_change_data_capture.pdf (Change Data Capture Developer Guide — Allocations·Enrich, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/
created: 2026-06-14
aliases: [Platform Event 한도, Platform Event 고려사항, Platform Event Allocations, 디커플드 발행 구독, decoupled publishing, PE vs CDC, 이벤트 종류 비교, 72시간 보관]
---

# Platform Event 한도와 고려사항

> 플랫폼 이벤트의 할당량(allocations)·보관 기간, 정의/발행/구독 시 고려사항, 그리고 **Publish Immediately의 디커플드(decoupled) 발행-구독** 함정과 다른 Salesforce 이벤트와의 차이.

> [!note] 공식 *Platform Events Developer Guide v67.0* 발췌. 정의·구독은 [[Platform Event 정의와 구독]] 참조.

---

## 할당량·보관 (Allocations)

- **고볼륨(High-volume)** 이벤트: 메시지 **72시간(3일)** 보관. 비동기 발행.
- **표준볼륨(Standard-volume)**: 보관 **24시간**. **Summer '27 은퇴 예정**(v45.0+ 신규 이벤트는 고볼륨이 기본).
- 한도는 REST **`/limits`** 엔드포인트로 조회 가능 (아래 코드 참조).

### 발행·전달 기본 할당량 — 고볼륨 (add-on 라이선스 없을 때)

*platform_events.pdf v67.0 "Default Platform Event Allocations for Event Publishing and Delivery" 원문 수치.*

| 항목 | Performance·Unlimited | Enterprise·Professional(API Add-On) | Developer |
|---|---|---|---|
| **이벤트 발행(Publishing)** — 최근 1시간 발행 메시지 수. 모든 발행 수단(Apex·Pub/Sub API·REST·SOAP·Bulk·Flow·Process) 합산 | **250,000 /시간** | **250,000 /시간** | **50,000 /시간** |
| **이벤트 전달(Delivery)** — 최근 24시간 전달 메시지 수, 전 구독 클라이언트 합산 | **50,000 /24h** | **25,000 /24h** | **10,000 /24h** |

- 두 한도 모두 **롤링(rolling)** — 고정 리셋 시각이 아니라 "최근 1시간/최근 24시간" 사용량으로 계산.
- **전달 할당량 적용 대상**: Pub/Sub API·CometD·empApi Lightning 컴포넌트·Event Relay. **Apex 트리거·Flow·Process Builder 구독에는 전달 할당량이 적용되지 않는다**(발행 할당량만 소비) — 발행 한도가 전달 한도보다 높은 이유.
- 전달 할당량은 **고볼륨 플랫폼 이벤트 + CDC(Change Data Capture) 이벤트가 공유**한다.
- 전달 사용량은 구독 클라이언트별로 합산: 예) Unlimited(50,000/24h)에서 2개 클라이언트에 각 20,000개 전달 → 40,000 소비, 잔여 10,000.
- **초과 시:** 발행 초과 → `LIMIT_EXCEEDED` 에러, 이벤트는 발행도 큐잉도 안 됨(사용량 감소 후 재발행 필요). 전달 초과 → 에러 반환 + 구독 끊김 — CometD `403::Organization total events daily limit exceeded`, Pub/Sub API `sfdc.platform.eventbus.grpc.subscription.limit.exceeded`.
- 라이선스별 별도 전달 할당(24h): Salesforce Order Management 라이선스 **100**, Bring Your Own Channel for Messaging/CCaaS 라이선스당 **25,000**. Platform Event **add-on** 구매 시 전달 사용량이 월 단위 usage-based entitlement로 전환(스파이크용 grace 허용).

### 공통 할당량 (Common Allocations — 표준·고볼륨 공통)

| 항목 | Perf·Unlimited | Enterprise | Developer | Professional(API Add-On) |
|---|---|---|---|---|
| org당 플랫폼 이벤트 **정의** 최대 수 (관리 패키지 이벤트도 org 할당 공유) | 100 | 50 | 5 | 5 |
| 동시 CometD 클라이언트(구독자) — 전 채널·전 이벤트 타입 합산 | 2,000 | 1,000 | 20 | 20 |
| 플랫폼 이벤트를 구독할 수 있는 Process/Flow 수 | 4,000 | 4,000 | 4,000 | 5 |
| 플랫폼 이벤트를 구독하는 **활성** Process/Flow 수 | 2,000 | 2,000 | 2,000 | 5 |
| 커스텀 채널 수 — 플랫폼 이벤트용 (Real-Time Event Monitoring 제외) | 100 | 100 | 100 | 100 |
| 커스텀 채널 수 — CDC 이벤트용 | 100 | 100 | 100 | 100 |
| 커스텀 채널 수 — Real-Time Event Monitoring 이벤트용 | 3 | 3 | 3 | 3 |
| 채널 멤버로 추가 가능한 서로 다른 커스텀 플랫폼 이벤트 수 (여러 채널 중복 추가는 1회만 계산) | 50 | 50 | 5 | 5 |
| 채널 멤버로 추가 가능한 Real-Time Event Monitoring 이벤트 수 | 10 | 10 | 10 | 10 |
| **발행 가능한 이벤트 메시지 최대 크기** | **1 MB** | **1 MB** | **1 MB** | **1 MB** |

- 메시지 1MB 초과(커스텀 필드 수백 개, long text area 다수)면 발행 호출이 에러를 받는다.
- 동시 클라이언트 할당은 CometD 전용(플랫폼·change·PushTopic·generic 이벤트 전부 합산). empApi도 CometD로 계산 — 로그인 사용자 1명 = 클라이언트 1개(같은 사용자의 여러 브라우저 탭은 스트리밍 연결 공유로 1개).

### 표준볼륨 할당량 (API v44.0 이전 정의 이벤트 — Summer '27 은퇴)

| 항목 | Perf·Unlimited | Enterprise | Developer·Professional(API Add-On) |
|---|---|---|---|
| 전달 — 최근 24시간, 전 CometD 클라이언트 합산 | 50,000 | 25,000 | 10,000 |
| 발행 — 시간당 | 100,000 | 100,000 | 1,000 |

- 표준볼륨은 전달 한도 초과 후 생성된 메시지도 이벤트 버스에 저장 — **24시간 보존 기간 내**면 나중에 조회 가능. add-on 1개당 일일 전달 +100,000 (예: Unlimited 50,000 → 150,000, 복수 구매 가능. CometD 클라이언트 일 500만 건 이하 권장).
- 고볼륨과 표준볼륨의 **에디션 묶음이 다름** 주의: 고볼륨 전달표는 Enterprise=Professional(API Add-On) 묶음, 표준볼륨은 Developer=Professional(API Add-On) 묶음 (PDF 원문 그대로).

```bash
# 플랫폼 이벤트 사용량/할당량 조회 — REST /limits (응답 키 이름은 가이드 원문)
curl https://MyDomain.my.salesforce.com/services/data/v67.0/limits/ \
  -H "Authorization: Bearer <access_token>"
# 고볼륨:  DailyDeliveredPlatformEvents (일일 전달, Max/Remaining) ·
#          HourlyPublishedPlatformEvents (시간당 발행) ·
#          MonthlyPlatformEventsUsageEntitlement (add-on 월 entitlement, v48.0+)
# 표준볼륨: DailyStandardVolumePlatformEvents · HourlyPublishedStandardVolumePlatformEvents
# Apex로도 조회 가능: System.OrgLimit 클래스에서 DailyDeliveredPlatformEvents 값 확인
```

---

## 정의 고려사항

| 항목 | 내용 |
|---|---|
| 필드 read-only | 모든 플랫폼 이벤트 필드는 **기본 read-only**, 필드 레벨 보안 적용 안 됨(메시지에 전 필드 포함) |
| 필드 속성 강제 | Required·Default·숫자 정밀도·텍스트 최대 길이 등 커스텀 필드 속성이 검증됨 |
| **영구 삭제** | 이벤트 정의 삭제 시 **복구 불가**. 삭제 전 연결 트리거 먼저 삭제. 해당 정의의 발행된 이벤트도 삭제됨 |
| **이름 변경 → 재구독** | 이벤트 이름 변경 시 구독 클라이언트는 **재구독 필요**(새 토픽). 변경 전 트리거 삭제 |
| 탭 없음 | 플랫폼 이벤트는 UI에서 레코드를 볼 수 없어 **연결 탭 없음** |
| **SOQL 불가** | 이벤트 메시지를 SOQL로 **쿼리할 수 없음** |
| Lightning App Builder | 레코드 페이지 생성 목록에 보이지만 **레코드 페이지 생성 불가**(UI에 레코드 없음) |
| 패키지 | uninstall 시 데이터 보존(48h) 옵션 켜도 플랫폼 이벤트는 export 안 됨 |

---

## 디커플드 발행-구독 (Publish Immediately)

**Publish Immediately** 이벤트는 DB 트랜잭션 **밖에서** 발행된다 → 발행·구독 프로세스가 **분리(decoupled)**. 구독자는 발행 트랜잭션의 변경이 **커밋됐다고 가정할 수 없다.**

> [!warning] **발행자는 트랜잭션 경계를 존중하지 않는다.** 예: ① Process가 이벤트 발행 + Task 생성 → ② Task 트리거가 커밋을 지연 → ③ 이벤트를 구독한 다른 Process가 그 Task를 조회하면 **아직 커밋 전이라 못 찾음**(에러). API·트리거로 발행/구독해도 동일.
>
> **해결:** publish behavior를 **Publish After Commit**으로 변경 → 트랜잭션 커밋 후 발행되어 구독자가 레코드를 찾을 수 있다.

(이 디커플드 동작은 Publish After Commit 이벤트와 Pub/Sub API 발행에는 적용되지 않는다.)

---

## 다른 Salesforce 이벤트와의 차이

Salesforce에는 이벤트 기반 기능이 여러 가지이며, 일부는 표준 플랫폼 이벤트 기반이고 일부는 "이벤트 같지만" 알림이 아니다.

| 이벤트 | 용도 |
|---|---|
| **Platform Events** (커스텀 `__e`) | 직접 정의한 커스텀 메시지 발행/구독 (본 시리즈) |
| **Change Data Capture (CDC)** | 레코드 변경(생성/수정/삭제/언델리트)을 자동 이벤트로 — 필드 정의 불필요. → [[ChangeEventHeader]] |
| **(기타)** | PushTopic, Generic Event 등 레거시 스트리밍 — 신규는 플랫폼 이벤트/Pub-Sub 권장 |

### 선택 기준 — Platform Events vs CDC (외부 시스템 통합 시)

| 기준 | Platform Events (커스텀 `__e`) | Change Data Capture (CDC) |
|---|---|---|
| **트리거 계기** | 앱이 **직접 발행** — `EventBus.publish` / Pub/Sub·REST·SOAP·Bulk API / Flow·Process | 레코드 **CRUD(생성·수정·삭제·언델리트) 시 Salesforce가 자동 발행** — 발행 코드 불필요 |
| **페이로드** | **커스텀 필드로 자유 설계** — 비즈니스 메시지 스키마를 직접 정의 | **레코드 필드 + ChangeEventHeader로 고정** — 커스텀 페이로드 불가. 생성/언델리트=전 필드, 수정=변경 필드만(Apex 수신 시 나머지는 null), 삭제=전 필드 null |
| **활성화·정의 한도** | 이벤트 **정의** 수: 에디션별 100/50/5 (위 공통 할당량 표) | 선택 엔티티 **기본 최대 5개**(전 채널 합산, AppExchange 패키지 선택 제외) — [[ChangeEventHeader]] 전제조건 참조. add-on 구매 시 무제한 |
| **발행 할당량** | 시간당 250,000/250,000/50,000 (위 표) — 초과 시 `LIMIT_EXCEEDED` | **발행 한도 없음** — 발행량을 사용자가 제어할 수 없어(레코드 변경에 자동 반응) 미적용 |
| **전달 할당량** | 24시간 50,000/25,000/10,000 — **고볼륨 PE + CDC가 하나의 전달 할당량을 공유** | 동일한 공유 할당량 소비 (CDC add-on: 일 +100,000 entitlement) |
| **구독 수단** | Apex 트리거 · **Flow/Process Builder** · CometD · Pub/Sub API · empApi · Event Relay | Apex 트리거 · CometD · Pub/Sub API · empApi · Event Relay — **Flow/Process Builder 구독은 플랫폼 이벤트만 가능, change 이벤트는 불가** |
| **필터링·보강** | 커스텀 채널 + 필터 표현식으로 구독 스트림 필터링(전달 할당량은 필터 적용 **후** 이벤트 수로 계산) | 커스텀 채널 필터 + **enriched fields**(채널 멤버당 최대 10개 필드를 변경 여부와 무관하게 항상 포함 — 예: 외부 ID로 외부 시스템 레코드 매칭) |
| **대표 사용례** | 커스텀 비즈니스 이벤트 알림(주문 생성 알림, 시스템 간 커스텀 메시지), 페이로드 설계가 필요한 통합 | 외부 데이터 스토어와 **레코드 동기화·복제** — 변경 감지 코드 없이 CRUD를 그대로 스트리밍 |

> **요약:** 외부 시스템에 "레코드 데이터 변경을 그대로" 흘려보내 동기화하려면 **CDC**(자동 발행·발행 한도 없음·단 엔티티 5개 기본 한도), 자유 설계한 커스텀 메시지·비즈니스 이벤트를 보내려면 **Platform Events**(페이로드 자유·단 발행 코드와 시간당 발행 한도 존재). 전달 할당량은 둘이 공유하므로 혼용 시 합산 사용량을 모니터링한다.

---

## 표준 플랫폼 이벤트 객체 & 에러 코드

- **표준 플랫폼 이벤트 객체**: Salesforce 제공 표준 이벤트(예: 로그인/로그아웃 이벤트 등). 공통 시스템 필드 — `EventUuid`(메시지 고유 UUID, v52.0+), `ReplayId`, `LoginKey`(로그인 세션 묶음), `Message` 등. 전체 목록·필드는 공식 가이드 *Standard Platform Event Objects* 참조.
- **발행 상태 코드**: 비동기 발행 시 `EventBus.publish`의 `Database.SaveResult`에 즉시 결과로 **`OPERATION_ENQUEUED`**(큐잉 성공) 반환(최종 결과 아님). 콜백 사용 시 `OPERATION_WITH_CALLBACK_ENQUEUED`. 최종 결과는 [[EventBus Publish Callbacks]] 참조.

---

## 관련 노트

- 📖 공식: [Platform Events Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/)
- [[Platform Event 정의와 구독]] — 정의·Publish Behavior·구독 트리거
- [[Platform Event Apex 테스트]] — Test.getEventBus
- [[Platform Event 발행]] · [[EventBus Namespace]] — Apex 발행
- [[ChangeEventHeader]] — CDC 변경 이벤트
- [[Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널)]] — 구독 트리거 배치 크기·실행 사용자를 구성하는 PlatformEventSubscriberConfig Tooling sObject 정본.
- [[Governor Limits]] — 거버너 한도 일반
