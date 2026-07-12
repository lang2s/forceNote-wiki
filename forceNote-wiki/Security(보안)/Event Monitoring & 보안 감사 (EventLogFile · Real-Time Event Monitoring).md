---
tags: [security, event-monitoring, eventlogfile, shield, audit, monitoring, observability, compliance]
source: developer.salesforce.com — Object Reference (EventLogFile · EventLogFile Supported Event Types) + help.salesforce.com — Event Monitoring / Retain Event Log Files (Tier 2, 2026-07-12 접속)
created: 2026-07-12
aliases: [Event Monitoring, EventLogFile, Event Log File, 이벤트 모니터링, 이벤트 로그 파일, 보안 감사, ELF, Shield Event Monitoring, 관찰 축]
---

# Event Monitoring & 보안 감사 (EventLogFile · Real-Time Event Monitoring)

> Salesforce의 **관찰·감사 축**(observation) — "누가·언제·무엇을 보고/내보냈나"를 로그로 수집한다. EventLogFile(배치 로그)이 이 축의 코어이며, 실시간 스트림·위협 탐지는 [[Real-Time Event Monitoring & Threat Detection (실시간 이벤트 모니터링 · 위협 탐지)]]로 이어진다. **강제·차단**([[TxnSecurity Namespace]])과 짝을 이루는 반대 축이다.

---

## 개념 — 관찰(observe) vs 강제(enforce)

**Event Monitoring**은 Salesforce Shield 제품군(및 별도 Event Monitoring add-on)의 일부로, 조직에서 일어나는 **운영·보안 이벤트를 관찰·기록**하는 기능이다. 사용 추세와 사용자 행동, 데이터 노출(조회·내보내기)을 분석해 성능·채택·보안 감사에 쓴다.

Salesforce 보안 모니터링은 두 축으로 나뉜다.

| 축 | 대표 기능 | 성격 | 위키 노트 |
|---|---|---|---|
| **관찰·감사(observe)** | EventLogFile · Real-Time Event Monitoring | 무슨 일이 있었나를 **기록·조회**. 사후 감사·이상탐지 | 이 노트 · [[Real-Time Event Monitoring & Threat Detection (실시간 이벤트 모니터링 · 위협 탐지)]] |
| **강제·차단(enforce)** | Transaction Security Policy | 조건에 맞으면 실시간으로 **Block/Notify/MFA** | [[TxnSecurity Namespace]] |

두 축은 데이터를 공유한다 — Transaction Security Policy는 Real-Time Event Monitoring 이벤트를 **조건 소스**로 사용하고, 관찰된 이벤트에 대해 강제 액션을 붙인다.

Event Monitoring이 다루는 **3대 도구**:
1. **Event Log Files (EventLogFile)** — 배치(시간별/일별)로 생성되는 로그 파일. 이 노트의 주제.
2. **Real-Time Event Monitoring** — 스트리밍 플랫폼 이벤트 + 저장(big object) + 위협 탐지. → 별도 노트.
3. **Transaction Security** — 강제/차단 정책. → [[TxnSecurity Namespace]].

---

## EventLogFile — 이벤트 로그 파일 (배치)

### 개념·생성 주기

`EventLogFile`은 **이벤트 모니터링용 로그 파일**을 나타내는 표준 오브젝트다. **API v32.0 이상**에서 사용 가능하며 **읽기 전용**(쿼리·다운로드만, 생성/수정 불가)이다.

- 이벤트가 조직에서 발생하면 로그 파일이 생성되고, **약 24시간 후** 조회·다운로드할 수 있다(일별 생성분은 비피크 시간대에 새로고침·전달).
- Event Monitoring add-on이 있으면 **시간별(Hourly)** 이벤트 로그도 받을 수 있어 near-real-time에 가깝다(`Interval` 필드로 구분).
- 로그 파일 자체(`LogFile`)는 **CSV**로 인코딩된 base64 blob이며, 한 파일은 하나의 `EventType`·하나의 `LogDate`에 대응한다.

### 주요 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `EventType` | picklist | 이 로그 파일이 담는 이벤트 종류(Login·API·URI·ReportExport 등). 하단 카탈로그 참조 |
| `LogDate` | dateTime | 이벤트가 발생한 날짜(로그가 커버하는 기간의 시작) |
| `LogFile` | base64 | 실제 로그 데이터(CSV). 여기서 찾는 정보가 들어 있음. `EventType`에 따라 컬럼 구성이 다름 |
| `LogFileLength` | double | 로그 파일 크기(바이트) |
| `LogFileContentType` | string | 로그 파일 콘텐츠 타입(예: `text/csv`) |
| `LogFileFieldNames` | textarea | `LogFile` CSV의 컬럼명 목록 |
| `LogFileFieldTypes` | textarea | 각 컬럼의 데이터 타입 목록 |
| `Interval` | picklist | 로그 생성 주기 — `Hourly`(add-on) 또는 `Daily` |
| `Sequence` | int | 같은 날짜·타입의 시간별 로그를 구분하는 순번(Hourly일 때 의미) |
| `ApiVersion` | double | 로그를 생성한 API 버전 |
| `CreatedDate` | dateTime | 로그 파일 레코드 생성 시각 |

> 근거: [EventLogFile — Object Reference](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_eventlogfile.htm) · [EventLogFile — Field Reference](https://developer.salesforce.com/docs/atlas.en-us.sfFieldRef.meta/sfFieldRef/salesforce_field_reference_EventLogFile.htm). (SPA 렌더 — 필드 목록은 Object/Field Reference 정적 문서 기준.)

### 조회·다운로드 방법 (3경로)

```apex
// 구조 예시 — 실제 동작 코드지만 org 환경에 따라 필드/타입 확인 필요

// (1) SOQL — 어떤 로그가 있는지 메타데이터로 조회
List<EventLogFile> logs = [
    SELECT Id, EventType, LogDate, Interval, LogFileLength, Sequence
    FROM   EventLogFile
    WHERE  EventType = 'Login' AND LogDate = LAST_N_DAYS:1
    ORDER BY LogDate DESC
];
```

```bash
# (2) REST API — LogFile blob(CSV) 실제 다운로드
#     blob 필드는 SOQL로 못 받고 전용 엔드포인트로 받는다
curl "https://<INSTANCE>.salesforce.com/services/data/v60.0/sobjects/EventLogFile/<Id>/LogFile" \
     -H "Authorization: Bearer <token>" -o login_events.csv
```

- **(3) Event Monitoring Analytics App** — CRM Analytics(구 Tableau CRM)의 사전 구축 앱. EventLogFile 데이터를 대시보드로 시각화(로그인·API·리포트 내보내기 추세 등). 자세한 오브젝트 목록은 [[Analytics Objects]] 참조.
- 커뮤니티 도구: ELF Browser, Salesforce CLI, `sfdx` 플러그인 등으로 CSV를 일괄 다운로드하기도 한다(비공식).

### 보존 기간·라이선스 전제

| 라이선스/에디션 | 이벤트 타입 범위 | 보존(retention) |
|---|---|---|
| **Developer Edition** | 모든 로그 타입 무료 | **1일** |
| **EE / UE / PE (add-on 없음)** | **일부** 이벤트 타입만 무료 | **1일** |
| **Event Monitoring add-on / Shield** | 전체 이벤트 타입 | **30일** (Interval `Hourly` 가능) |
| **확장 보존(Extended Retention) 설정** | add-on 필요 | **최대 1년** — Setup의 Event Monitoring Settings에서 "Retain event log files" 토글 + `EventSettings` 메타데이터(`eventLogRetentionDuration`)로 기간 설정 |

- 기본 보존은 **1일**(에디션 무관 무료 범위), Event Monitoring 라이선스가 있으면 **30일**, 확장 보존을 켜면 **최대 1년**까지 늘릴 수 있다.
- 규정 준수·장기 감사 목적이면 보존 한도에 걸려 로그가 소실되기 전에 주기적으로 **외부(SIEM 등)로 export**해 보관한다.

> 근거: [Retain Event Monitoring Event Log Files for Up to One Year](https://help.salesforce.com/s/articleView?id=005123903&type=1) — 확장 보존 최대 1년 / Event Monitoring Settings + `EventSettings` 메타데이터. 기본 1일·add-on 30일은 Object Reference·Trailhead Event Monitoring 모듈 기준.

### 지원 EventType 카탈로그 (대표)

`EventType`은 50종 안팎으로 대량이므로 대표만 싣는다. 전체는 [Supported Event Types](https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_eventlogfile_supportedeventtypes.htm) 참조.

| EventType | 무엇을 기록하나 |
|---|---|
| `Login` / `Logout` | 사용자 로그인·로그아웃 |
| `URI` | Classic UI 페이지 요청(웹 리소스 접근) |
| `LightningPageView` / `LightningInteraction` / `LightningError` / `LightningPerformance` | Lightning Experience 페이지뷰·상호작용·오류·성능 |
| `API` / `RestApi` / `SoapApi` / `BulkApi` / `BulkApiV2` / `CompositeApi` / `GraphQL` | API 호출(종류별) |
| `ApiTotalUsage` | 전체 API 소비량 집계 |
| `ReportExport` / `Report` / `AsyncReportRun` / `Dashboard` | 리포트 내보내기·실행·대시보드 |
| `ApexExecution` / `ApexTrigger` / `ApexCallout` / `ApexSoap` / `ApexRestApi` / `ApexUnexpectedException` | Apex 실행·트리거·콜아웃·예외 |
| `FlowExecution` | Flow 런타임 실행 |
| `AuraRequest` | Aura 컴포넌트 요청 |
| `ContentTransfer` / `ContentDistribution` / `ContentDocumentLink` | 파일 전송·공유·첨부 |
| `BlockedRedirect` | 차단된 리다이렉트(피싱 방어) |
| `CorsViolation` / `CspViolation` | CORS·CSP 위반 |
| `MetadataApiOperation` / `ChangeSetOperation` | 메타데이터·체인지셋 배포 작업 |
| `Console` | 서비스 콘솔 사용 |

> `ReportExport`·`ContentTransfer`·`BlockedRedirect` 같은 타입이 "누가 데이터를 내보냈나"를 답하는 감사 핵심이다.

---

## EventLogFile (배치) vs Real-Time Event Monitoring (실시간)

| 구분 | EventLogFile | Real-Time Event Monitoring |
|---|---|---|
| **전달 방식** | 배치 로그 파일(CSV blob) | 스트리밍 플랫폼 이벤트 + 저장 big object |
| **지연** | 시간별(add-on) 또는 일별 · 약 24h | **실시간**(발생 즉시 pub/sub 게시) |
| **접근** | SOQL(메타데이터) + REST(LogFile blob) | Pub/Sub API · Streaming API(CometD) 구독 / 저장 오브젝트 SOQL |
| **강제 연계** | 없음(관찰만) | Transaction Security Policy와 연계해 Block/Notify/MFA |
| **위협 탐지** | 없음 | SessionHijacking·CredentialStuffing·Report/Api Anomaly 등 |
| **용도** | 사후 감사·추세 분석·규정 준수 | 실시간 대응·SIEM 스트리밍·자동 차단 |
| **라이선스** | 일부 무료(1일) / add-on(30일~1년) | **Shield 또는 Event Monitoring add-on 필수** |

→ 실시간 이벤트 카탈로그·위협 탐지 상세: [[Real-Time Event Monitoring & Threat Detection (실시간 이벤트 모니터링 · 위협 탐지)]]

---

## 인접 감사 기능과의 관계

Event Monitoring은 "데이터 접근·API·앱 사용"을 본다. 아래 두 기능은 **다른 감사 표면**을 커버하며 상호 보완한다.

| 기능 | 무엇을 기록 | 접근 | 위키 노트 |
|---|---|---|---|
| **Setup Audit Trail** | **설정(Setup) 변경** 이력 — 누가 무슨 구성을 바꿨나 | UI 최근 20건 · Download 최근 180일 CSV | [[Setup Audit Trail (설정 감사 추적)]] |
| **Login History** | **로그인 이력** — 시각·IP·상태·소스·인증 방법. `LoginHistory` 오브젝트(읽기 전용, SOQL 가능) + `LoginGeo`(지리) | Setup UI + SOQL | [[Platform Admin Objects]] · [[6 Standard Objects]] |
| **Event Monitoring** | 데이터 접근·API·리포트 내보내기·Apex·페이지뷰 | EventLogFile / RTEM | 이 노트 |

- **Login History**는 add-on 없이도 기본 제공되며(보존 6개월), `LoginHistory`·`LoginGeo` 오브젝트로 SOQL 쿼리한다. Real-Time Event Monitoring의 `LoginEvent`/`LoginEventStream`은 그보다 풍부한 필드·실시간성을 제공하는 상위 기능이다.
- **Setup Audit Trail**은 데이터가 아닌 **구성 변경**을 감사한다 — Event Monitoring과 겹치지 않는 별도 축.

---

## 관련 노트
- [[Real-Time Event Monitoring & Threat Detection (실시간 이벤트 모니터링 · 위협 탐지)]] — 실시간 이벤트 스트림·저장·위협 탐지(관찰 축의 실시간 절반)
- [[TxnSecurity Namespace]] — Transaction Security Policy(강제·차단 축). RTEM 이벤트를 조건 소스로 사용
- [[Setup Audit Trail (설정 감사 추적)]] — 설정 변경 감사(인접 감사 표면)
- [[Platform Admin Objects]] — `LoginHistory`·`LoginGeo` 등 로그인/관리 오브젝트
- [[Analytics Objects]] — Event Monitoring Analytics App이 쓰는 분석 오브젝트
- [[Salesforce 권한 모델 개요]] — View Real-Time Event Monitoring Data 등 권한 맥락
