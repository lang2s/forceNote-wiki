---
tags: [admin, org-setup, monitoring, security, login-history, email-log, audit, compliance]
source: help.salesforce.com (Login History; Email Log Reference; Request an Email Log) + developer.salesforce.com Object Reference (LoginHistory) — 라이브 공식 문서, Tier 2, 접속 2026-07-12
official_doc: [Login History] https://help.salesforce.com/s/articleView?id=platform.users_login_history.htm&type=5 · [LoginHistory 오브젝트] https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_loginhistory.htm · [Email Log Reference] https://help.salesforce.com/s/articleView?id=sales.email_logs_format.htm&type=5 · [Request an Email Log] https://help.salesforce.com/s/articleView?id=sales.email_logs_edit.htm&type=5
created: 2026-07-12
aliases: [Login History, LoginHistory, 로그인 이력, 로그인 기록, Email Log Files, Email Log, 이메일 로그, 감사 로그, login audit, email delivery log]
---

# Login History & Email Log Files (로그인·이메일 감사 로그)

> 조직의 **사용자 로그인 이력(Login History)** 과 **보낸 이메일 메타데이터(Email Log Files)** 를 조회·다운로드하는 두 감사 로그. [[Setup Audit Trail (설정 감사 추적)]](설정 변경)의 짝으로, "누가 로그인했나 / 이 메일이 실제로 전달됐나"를 답한다.

> [!note] Setup 라벨 캐비엇
> Setup 메뉴 라벨·화면 문구는 릴리스·에디션·언어에 따라 달라질 수 있다. 아래 경로/라벨은 공식 문서 기준이며, 실제 org에서는 Quick Find 검색어로 찾는 것이 안전하다.

---

## 1. Login History (로그인 이력)

### 개념

**Login History**는 조직과 활성화된 포털/Experience Cloud 사이트에 대한 **모든 성공·실패 로그인 시도**를 기록하는 감사 로그다. 각 로그인 시도에 대해 다음을 기록한다.

- **사용자(Username)** 와 **일시(Date/Time)** — 로그인 시각은 GMT
- **소스 IP(IP address)** — Salesforce에 처음 도달한 클라이언트 요청 IP
- **로그인 타입(Login Type)** — Application, SAML, OAuth, Certificate, Portal, AppExchange 등
- **애플리케이션 / 브라우저 / 플랫폼(OS)** — 접속에 사용된 앱·브라우저 버전·운영체제
- **상태(Status)** — 성공(success) 또는 실패 사유

### Setup 조회·다운로드

Setup에서 로그인 이력을 조회하고, 더 많은 레코드가 필요하면 파일로 다운로드한다.

```
// 구조 예시 — Login History 조회 흐름(실제 동작 코드 아님)
Setup → Quick Find "Login History" → Login History
   화면: 최근 로그인 시도(사용자·일시·IP·상태·타입·앱/브라우저/플랫폼)
   최대 20,000 레코드 · 최근 6개월치 표시
   Download:
     • CSV 파일
     • GZIP 파일 ← 압축되어 다운로드 가장 빠름(권장)
   "All Logins" 옵션 = API 액세스 로그인도 포함
```

- **표시 상한:** 최근 **6개월**의 **최대 20,000 레코드**를 화면에서 볼 수 있다.
- **다운로드:** 그 이상/전체를 받으려면 **CSV** 또는 **GZIP**로 다운로드한다. GZIP은 압축되어 다운로드가 가장 빠르므로 대량일 때 권장.
- **보존:** Login History는 **최대 6개월**만 보관한다. 회사 보존 정책이 더 긴 기간을 요구하면 **주기적으로 수동 다운로드해 외부 보관**해야 한다(6개월 경과 이력은 네이티브로 복구 불가).
- **API 로그인 포함:** "All Logins" 옵션을 쓰면 API 액세스 로그인까지 포함된다.

### `LoginHistory` 오브젝트 (SOQL 조회)

로그인 이력은 **`LoginHistory` 표준 오브젝트**로도 노출되어 SOQL로 조회할 수 있다(API 21.0+). 읽기 중심 오브젝트로 `query()` · `retrieve()` · `describeSObjects()` 를 지원하며, API 42.0+에서는 (활성화 시) `delete()` 도 가능하다.

- **접근 권한:** **Manage Users** 또는 **Monitor Login History** 권한이 필요. 단 API 37.0+에서는 **모든 사용자가 자신의 로그인 이력**은 조회할 수 있다.

```apex
// 구조 예시 — LoginHistory SOQL(실제 org 데이터 없이 형태만)
List<LoginHistory> recent = [
    SELECT UserId, LoginTime, LoginType, SourceIp, Status,
           Application, Browser, Platform, LoginUrl, CountryIso, TlsProtocol
    FROM LoginHistory
    WHERE LoginTime = LAST_N_DAYS:7
    ORDER BY LoginTime DESC
];
```

주요 필드(공식 Object Reference):

| 필드 | 타입 | 설명 |
|---|---|---|
| `UserId` | reference | 로그인한 사용자 ID |
| `LoginTime` | dateTime | 로그인 시각(GMT) |
| `LoginType` | picklist | 세션 접근에 사용된 로그인 타입(Application, SAML, OAuth, Certificate, Portal, AppExchange 등) |
| `LoginSubType` | picklist | 로그인 플로우 세부 타입(OAuth·SOAP 변형 등) |
| `SourceIp` | string | 로그인 시 Salesforce에 처음 도달한 클라이언트 요청 IP |
| `ForwardedForIp` | string | `X-Forwarded-For` 헤더 값(최대 256자, OAuth/SSO 로그인엔 미기록; API 61.0+) |
| `Status` | string | 로그인 시도 상태 — success 또는 실패 사유 |
| `Application` | string | 조직 접근에 사용된 애플리케이션 |
| `Browser` | string | 브라우저 버전 |
| `Platform` | string | 로그인 머신의 운영체제 |
| `LoginUrl` | string | 로그인 요청이 온 URL |
| `ApiType` / `ApiVersion` / `ClientVersion` | string | API 타입·버전·클라이언트 버전 |
| `CountryIso` | string | IP의 물리적 위치 국가 ISO 3166 코드(API 37.0+) |
| `LoginGeoId` | reference | 지리 위치 레코드 ID(Manage Users 권한 필요; API 34.0+) |
| `NetworkId` | reference | 로그인 대상 Experience Cloud 사이트 ID(API 31.0+) |
| `AuthenticationServiceId` | reference | SAML/Auth Provider 구성 식별 18자 ID(API 34.0+) |
| `TlsProtocol` | picklist | 로그인에 사용된 TLS 프로토콜(1.0/1.1/1.2/1.3/Unknown; API 37.0+) |
| `CipherSuite` | picklist | 로그인 TLS 암호 스위트(OpenSSL 명명; API 37.0+) |
| `OptionsIsGet` / `OptionsIsPost` | boolean | 세션 로그인 HTTP 메서드(GET/POST) |

> **Login Forensics(고급)와 구분:** 위의 Login History / `LoginHistory`는 **모든 에디션에서 기본 제공되는 간단한 로그인 이력**이다. 반면 **Login Forensics** 는 **Event Monitoring** 애드온에 속한 고급 분석 기능으로, `LoginEvent`·평균 로그인 수·비정상 IP 등 심층 지표를 추가로 제공한다(별도 라이선스). 이 노트가 다루는 것은 기본 Login History다.

---

## 2. Email Log Files (이메일 로그 파일)

### 개념

**Email Log Files**는 Salesforce에서 **보낸 이메일의 메타데이터 로그**다. 최근 **30일** 이내에 발송된 메시지에 대해 각 이메일의 정보를 담는다.

- **발신자(Sender) / 수신자(Recipient)** 이메일 주소
- **일시(Date/Time)** — GMT 기준(요청 시엔 로컬 타임존 입력)
- **전달 상태 / 메일 이벤트(Mail Event)** — 성공 전달, 메일 서버 수신, 실패(바운스) 등
- **오류 코드(error codes)** 및 troubleshooting용 **Message ID**

Mail Event(메일 이벤트) 값은 최종 메일 서버 이벤트를 나타낸다. 공식 문서 기준 대표 값:

| 이벤트 | 의미 |
|---|---|
| `R` | Reception — 메일 서버가 메시지를 수신함 |
| `D` | Delivery — 수신자에게 성공적으로 전달됨 |
| `P` | Permanent failure — 영구 실패(하드 바운스) |
| `T` | Transient failure — 일시 실패(소프트 바운스, 재시도 대상) |

> 전체 컬럼(예: Message ID, Message Size, Bytes Transferred, Remote Host, Delivery Stage 등) 정의는 공식 **[Email Log Reference](https://help.salesforce.com/s/articleView?id=sales.email_logs_format.htm&type=5)** 가 정본이다. (SPA 렌더 실패로 이 노트에는 검증된 핵심 컬럼만 수록했다.)

### 요청 방식 (비동기)

Email Log는 실시간 조회가 아니라 **요청 → 비동기 생성 → 다운로드** 방식이다.

```
// 구조 예시 — Email Log 요청 흐름(실제 동작 설정 아님)
Setup → Quick Find "Email Log Files" → Email Log Files → Request an Email Log
   시간 범위 선택:  최근 30일 이내 · 1회 요청당 최대 7일 범위
   (선택) 특정 수신자/발신자로 필터
   → 요청은 받은 순서대로 큐잉 → 약 30분 내 생성 완료
   → 압축(zip) 안의 CSV 파일로 다운로드
```

| 항목 | 값 | 비고 |
|---|---|---|
| **조회 가능 기간(보존)** | 요청 시점 기준 **최근 30일** 이내 발송분만 | 30일 지난 메시지는 로그 없음 |
| **1회 요청 범위** | 최대 **7일** | 7일 넘게 보려면 요청을 여러 번 나눠 제출 |
| **생성 방식** | 비동기 · 받은 순서로 큐잉 | 요청 후 **약 30분** 내 사용 가능 |
| **동시 요청 한도** | 최대 **3건** | 동시에 3개 요청까지 |
| **파일 형식** | 압축 파일 내 **CSV** | 캠페인 직후 등 고트래픽 구간은 파일이 커질 수 있음 |

> 대량·장기 이메일 감사가 필요하면 30일 한도에 걸리기 전 주기적으로 요청·보관하고, 심층 분석은 Event Monitoring(`EventLogFile`)을 고려한다.

---

## 3. 감사 로그 4종 구분

Salesforce의 "로그/감사" 기능은 목적이 서로 다르다. 헷갈리기 쉬우므로 대비한다.

| 기능 | 무엇을 추적 | 위치 | 보존 |
|---|---|---|---|
| **Login History** (이 노트) | 사용자 **로그인 시도**(성공/실패·IP·타입) | Setup → Login History / `LoginHistory` SOQL | **6개월**(최대 20,000행 표시) |
| **Email Log Files** (이 노트) | **보낸 이메일**의 전달 메타데이터 | Setup → Email Log Files(요청) | 최근 **30일**, 1요청 최대 7일 |
| **[[Setup Audit Trail (설정 감사 추적)]]** | **설정(Setup) 변경** — 누가·무엇을·언제 | Setup → View Setup Audit Trail | UI 최근 20건 / Download 180일 |
| **[[Apex Debug Log]]** | **코드 실행**(Apex/트리거/플로우 등) 상세 실행 로그 | Setup → Debug Logs(트레이스 플래그) | 트레이스 플래그 유효기간·크기 한도 |

- **Login History ≠ Setup Audit Trail:** 전자는 *로그인 이벤트*, 후자는 *구성 변경*.
- **Login History ≠ Debug Logs:** Debug Logs는 *코드 실행* 내부를 본다.

### Event Monitoring(EventLogFile)과의 관계

Login History는 **가벼운 로그인 이력**이다. 더 상세한 이벤트 감사가 필요하면 **Event Monitoring**의 `EventLogFile`(로그인·로그아웃·API·리포트 내보내기·URI 등 40+ 이벤트 타입)을 쓴다. `EventLogFile`은 별도 애드온 라이선스가 필요하며, Login History보다 훨씬 세분화된 이벤트·필드를 제공한다. (Event Monitoring 상세 노트가 있으면 그쪽 참조 — 없으면 콘텐츠 갭.)

---

## 관련 노트
- [[Setup Audit Trail (설정 감사 추적)]] — **설정 변경** 감사(이 노트의 짝: 로그인/이메일 vs 설정)
- [[Apex Debug Log]] — **코드 실행** 로그(로그인/이메일 메타데이터와 대비)
- [[Login IP Ranges & Login Hours (로그인 IP·시간 제한)]] — 로그인 접근 제어(어디서·언제 로그인 허용) → 로그인 결과가 Login History에 남음
- [[Field History Tracking (필드 이력 추적)]] — **레코드 필드 데이터 변경** 추적(또 다른 감사 축)
- [[Password Policies (비밀번호 정책)]] — 실패 로그인·잠금 정책 → Login History의 실패 상태와 연계
- [[Organization-Wide Email Addresses & Deliverability (조직 전체 이메일·전달성)]] — 이메일 전달성 설정 → Email Log로 전달 결과 확인
