---
tags: [security, event-monitoring, real-time-event-monitoring, threat-detection, shield, platform-events, streaming, anomaly-detection]
source: developer.salesforce.com — Platform Events Developer Guide (Real-Time Event Monitoring Objects · LoginEvent · SessionHijackingEvent 등) + help.salesforce.com — Real-Time Event Monitoring Data Streaming (Tier 2, 2026-07-12 접속)
created: 2026-07-12
aliases: [Real-Time Event Monitoring, RTEM, 실시간 이벤트 모니터링, Threat Detection, 위협 탐지, SessionHijackingEvent, CredentialStuffingEvent, ReportAnomalyEvent, ApiAnomalyEvent, LoginEventStream, 이상 탐지]
---

# Real-Time Event Monitoring & Threat Detection (실시간 이벤트 모니터링 · 위협 탐지)

> Event Monitoring 관찰 축의 **실시간 절반** — 발생 즉시 게시되는 플랫폼 이벤트(스트리밍) + 저장 big object + 머신러닝 기반 위협 탐지. 배치 로그([[Event Monitoring & 보안 감사 (EventLogFile · Real-Time Event Monitoring)]]의 EventLogFile)와 달리 실시간 대응·자동 차단([[TxnSecurity Namespace]])이 가능하다.

---

## 개념 — 스트리밍(streaming) + 저장(storage)

**Real-Time Event Monitoring(RTEM)**은 Salesforce가 게시하는 **표준 플랫폼 이벤트**를 구독해 로그인·리포트 실행 등 사용자 활동을 **실시간으로** 모니터링하는 기능이다. 각 이벤트는 두 형태로 소비할 수 있다.

| 형태 | 오브젝트 | 소비 방법 | 특징 |
|---|---|---|---|
| **스트리밍(streaming)** | `...EventStream` (예: `LoginEventStream`) | Pub/Sub API · Streaming API(CometD) 구독 · Event Relay(Amazon EventBridge) | 발생 즉시 게시. **저장 안 됨**(구독 안 하면 소실) |
| **저장(storage)** | `...Event` big object (예: `LoginEvent`) | SOQL 쿼리 | big object에 저장돼 사후 조회 가능 |

- 대부분의 RTEM 이벤트는 스트리밍·저장 **둘 다** 지원한다. 예: `LoginEvent`(저장 big object) + `LoginEventStream`(실시간 스트림).
- **라이선스 전제:** RTEM 오브젝트 접근은 **Salesforce Shield 또는 Event Monitoring add-on 구독 + `View Real-Time Event Monitoring Data` 사용자 권한**이 필요하다.

> 근거: [Real-Time Event Monitoring Data Streaming — Salesforce Help](https://help.salesforce.com/s/articleView?id=xcloud.real_time_event_monitoring_streaming.htm&type=5) · [LoginEvent — Platform Events Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/sforce_api_objects_loginevent.htm).

### 구독 예시

```java
// 구조 예시 — Pub/Sub API 구독 개념(실제 클라이언트 코드 아님)
// 스트리밍: 채널 구독 → 실시간 이벤트 수신
subscribe("/event/LoginEventStream", event -> {
    // event.Username, event.SourceIp, event.LoginType, event.Status ...
    forwardToSiem(event);   // SIEM으로 실시간 포워딩
});
```

```apex
// 구조 예시 — 저장 big object는 SOQL로 사후 조회
List<LoginEvent> logins = [
    SELECT Username, EventDate, SourceIp, LoginType, Status
    FROM   LoginEvent
    WHERE  EventDate = LAST_N_DAYS:1
];
```

---

## 실시간 이벤트 카탈로그 (Real-Time Event Monitoring Objects)

Platform Events Developer Guide가 나열하는 RTEM 오브젝트(각각 `...Event` 저장 + `...EventStream` 스트림 형태가 있을 수 있음).

| 이벤트 | 무엇을 관찰하나 |
|---|---|
| `LoginEvent` / `LogoutEvent` | 로그인·로그아웃(IP·상태·인증 방법 등 상세) |
| `LoginAsEvent` | 관리자의 "Login As User" 위임 로그인 |
| `ApiEvent` | API 쿼리·호출(누가 어떤 SOQL을 실행했나) |
| `UriEvent` / `LightningUriEvent` | Classic URI · Lightning 페이지 접근 |
| `ReportEvent` | 리포트 실행·내보내기 |
| `ListViewEvent` | 리스트뷰 조회 |
| `PermissionSetEvent` | 권한 집합 할당 변경 |
| `BulkApiResultEvent` | Bulk API 결과 다운로드 |
| `ConcurLongRunApexErrEvent` | 동시 장기 실행 Apex 한도 오류 |
| `FileEvent` | 파일 다운로드·접근 |
| `IdentityVerificationEvent` | 아이덴티티 검증(MFA 등) 활동 |
| `MobileEmailEvent` · `MobileEnforcedPolicyEvent` · `MobileScreenshotEvent` · `MobileTelephonyEvent` | 모바일 앱 활동(이메일·정책·스크린샷·통화) |
| **위협 탐지(아래 별도 섹션)** | `ApiAnomalyEvent` · `CredentialStuffingEvent` · `GuestUserAnomalyEvent` · `LoginAnomalyEvent` · `ReportAnomalyEvent` · `SessionHijackingEvent` · `UniversalAnomalyEvent` |

> 근거: [LoginEvent 페이지의 "Real-Time Event Monitoring Objects" 목록](https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/sforce_api_objects_loginevent.htm) — ApiAnomalyEvent, ApiEvent, BulkApiResultEvent, ConcurLongRunApexErrEvent, CredentialStuffingEvent, FileEvent, GuestUserAnomalyEvent, IdentityVerificationEvent, LightningUriEvent, ListViewEvent, LoginAnomalyEvent, LoginAsEvent, LoginEvent, LogoutEvent, MobileEmailEvent, MobileEnforcedPolicyEvent, MobileScreenshotEvent, MobileTelephonyEvent, PermissionSetEvent, ReportAnomalyEvent, ReportEvent, SessionHijackingEvent, UniversalAnomalyEvent, UriEvent.

---

## Threat Detection — 위협 탐지 이벤트

일반 RTEM 이벤트가 "무슨 일이 있었나"를 원시 기록한다면, **Threat Detection**은 Salesforce의 **머신러닝**이 사용자의 과거 행동 대비 이상(anomaly)을 판정해 게시하는 파생 이벤트다. 각 위협 이벤트는 스트림 + 대응 저장 오브젝트(`...EventStore`)를 갖는다. Threat Detection GA는 Winter/Spring '21 전후에 도입됐다.

| 위협 이벤트 | 탐지 내용 | 저장 오브젝트 |
|---|---|---|
| `SessionHijackingEvent` | **세션 하이재킹** — 탈취된 세션 식별자로 다른 사용자가 세션을 점유. 세션 내 **브라우저 지문(fingerprint) 편차**로 판정 | `SessionHijackingEventStore` |
| `CredentialStuffingEvent` | **크리덴셜 스터핑** — 탈취된 자격증명 대입 공격. 트래픽 패턴·시간 버킷 분석으로 판정. 탐지 시 사용자에게 아이덴티티 챌린지·비밀번호 재설정 요구 | `CredentialStuffingEventStore` |
| `ReportAnomalyEvent` | **리포트 이상** — 사용자의 과거 리포트 활동과 크게 다른 실행(대량 조회 등) | `ReportAnomalyEventStore` |
| `ApiAnomalyEvent` | **API 이상** — 동일 사용자의 과거 활동과 충분히 다른 API 활동 | `ApiAnomalyEventStore` |
| `GuestUserAnomalyEvent` | **게스트 사용자 이상** — 게스트 사용자 권한 오구성으로 인한 데이터 접근 이상 | `GuestUserAnomalyEventStore` |
| `LoginAnomalyEvent` · `UniversalAnomalyEvent` | 로그인 이상 · 범용 이상 탐지 | 대응 `...EventStore` |

### SessionHijackingEvent 상세 (예시)

세션 하이재킹은 **브라우저 지문 편차**로 판정한다. 주요 필드:

| 필드 | 설명 |
|---|---|
| `Score` | 0.0~1.0 편차 크기. **0.8+** 이면 같은 세션을 서로 다른 브라우저가 접근했을 가능성 → 하이재킹 의심 |
| `SecurityEventData` | JSON 형태의 브라우저 지문 특징(user agent·IP·platform·screen·window) |
| `Current*` / `Previous*` 쌍 | IP·platform·screen·user agent·window의 현재 vs 이전 값 비교 |
| `SessionKey` | 사용자 세션 식별자 |
| `EventDate` | 탐지 시각 |

> 근거: [SessionHijackingEvent — Platform Events Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/sforce_api_objects_sessionhijackingevent.htm) · [GuestUserAnomalyEvent](https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/sforce_api_objects_guestuseranomalyevent.htm). 접근 권한: Shield/Event Monitoring add-on + `View Real-Time Event Monitoring Data`.

---

## Transaction Security와의 연계 (관찰 → 강제)

RTEM은 **관찰**만 한다. 여기에 **강제**를 붙이는 것이 Transaction Security Policy다.

```
[RTEM 이벤트 발생] → (Transaction Security Policy 조건 평가) → Block / Notify / MFA 요구
   예: ReportEvent(대량 리포트 실행) 관찰 → 정책 조건 매칭 → 내보내기 Block + 관리자 Notify
```

- Transaction Security Policy는 **Real-Time Event Monitoring 이벤트**(`ApiEvent`·`ReportEvent`·`LoginEvent` 등)를 조건 소스로 사용한다.
- 조건 로직을 UI로 표현할 수 없으면 Apex `TxnSecurity.EventCondition`(현행)을 구현해 코드로 지정한다 → [[TxnSecurity Namespace]].
- 즉, **관찰(RTEM) + 강제(TxnSecurity)** 가 하나의 실시간 보안 루프를 이룬다.

---

## 관련 노트
- [[Event Monitoring & 보안 감사 (EventLogFile · Real-Time Event Monitoring)]] — 관찰 축 허브 + EventLogFile 배치 로그(이 노트의 상위)
- [[TxnSecurity Namespace]] — RTEM 이벤트를 조건으로 강제/차단하는 Transaction Security(Apex API)
- [[Setup Audit Trail (설정 감사 추적)]] — 설정 변경 감사(인접 감사 표면)
- [[Platform Admin Objects]] — `LoginHistory`·`LoginGeo` 등 기본 로그인 오브젝트(add-on 불필요)
- [[Salesforce 권한 모델 개요]] — `View Real-Time Event Monitoring Data` 권한 맥락
