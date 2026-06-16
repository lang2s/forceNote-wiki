---
tags: [release, winter_25, platform, admin, security, flow, mobile]
api_version: v62.0
release_date: 2024-10
created: 2026-06-16
source: salesforce_winter25_release_notes.pdf (Salesforce Winter '25 Release Notes, Tier 2)
aliases: [Winter '25 Platform, 윈터25 플랫폼, Salesforce Overall, Customization, Security and Identity, Hyperforce, Flow v62, 윈터25 보안, 윈터25 어드민, DevOps Center, Scale Center, Salesforce CLI v62]
---

# Winter '25 — Platform

> Winter '25 (API v62.0)의 Platform 영역 전수 기록 — Salesforce Overall(Foundations·쿠키 제한·이메일 처리·Scheduler·Einstein Search·Data Pipelines·Archive), Customization(권한·List View·Lightning App Builder·Sharing·Globalization·Salesforce Connect·Setup), Security/Identity/Privacy(TLS 1.3·legacy My Domain redirect 폐기·external client app 마이그레이션·headless/passwordless identity·MFA·Shield event log objects·Security Center 커스텀 메트릭), Hyperforce, Flow(선언적 자동화), Mobile(어드민).

---

## 개요

이 노트는 Winter '25 릴리즈 노트의 **Platform** 영역(Salesforce Overall, Customization, Security/Identity/Privacy, Hyperforce, Flow 선언적 항목, Mobile 어드민)을 전수 전사한 spoke다. 허브 [[Winter '25]]에서 진입하며, 형제 spoke [[Winter '25/Development]]·[[Winter '25/Release Updates]]와 함께 Winter '25을 구성한다.

- **Salesforce Overall** — Salesforce Foundations로 360도 고객 뷰 제공, Salesforce 쿠키 사용 제한 테스트, 신규 Setup 도메인, No-Reply 주소 강제, 이메일 처리 RFC 준수, Scheduler·Einstein Search·Data Pipelines·Archive(Pilot) 강화.
- **Customization** — 사용자/오브젝트 접근 요약 뷰, LWC 기반 List View 전환, Dynamic Highlights Panel·Conditional Formatting, 공개 그룹 관리, Globalization(영어 지역 변형 11종), Salesforce Connect.
- **Security · Identity · Privacy** (depth-critical) — **TLS 1.3 outbound callout 지원**, legacy My Domain URL redirect 폐기(Winter '25 시작, Winter '26 종료), local connected app → local external client app 마이그레이션, headless/passwordless identity, MFA Assistant 폐지, Shield event log objects(Beta), Security Center 커스텀 메트릭(GA).
- **Hyperforce** — 본 릴리즈에 별도 feature 항목 없음(섹션 intro만 존재).
- **Flow** — 선언적 자동화 항목(개발자/invocable Flow 항목은 [[Winter '25/Development]]에 위치). Flow and Process Release Updates 클러스터는 [[Winter '25/Release Updates]]와 겹친다.
- **Mobile** — Salesforce Mobile App·Offline·Mobile Publisher 어드민 항목.

> 참고: PDF는 각 feature를 두 번 출력한다(개요 teaser + Where/When/Who/Why/How 전체 항목). 아래는 전체 항목을 전사한 것이다.

---

## Salesforce Overall

> 섹션 intro (PDF p.119): "Learn about new features and enhancements that affect your Salesforce experience overall."

### General Enhancements

| Feature | Status | Where / When / Edition | Description |
|---|---|---|---|
| **Unlock a 360-Degree Customer View with New Foundational Features (Salesforce Foundations)** | GA | 지원 edition 참조. Sales & Service 2024-09-17부터, Industries 2024-11-11부터. Who: View Setup and Configuration + Customize Application + Modify All Data 권한 | 필수 Sales·Service·Marketing·Commerce·Data Cloud 기능 모음. 단일 고객 뷰. Unified Home 앱(1), 수직 navigation bar(2), Quick Settings(3). Setup의 Salesforce Foundations 페이지 + Your Account에서 제품 추가로 활성화. |
| **Test Restrictions on Salesforce Cookie Use** | GA | LEX + Classic(전 org 아님); Group, Essentials, Pro, Ent, Perf, Unl, Dev. Winter '25 샌드박스에서 두 My Domain 설정이 다음 instance에 기본 활성화: USA796, USA794, USA246s, USA222s, USA198s, USA196s, USA18s, USA16s, USA14s, USA12, USA10s, USA6s, USA4s | 신규 My Domain 설정: **Require first-party use of Salesforce cookies** + **Allow cross-domain use of Salesforce cookies on the preview domain**(첫 설정이 켜져 있으면 기본 활성화). 서드파티 쿠키를 차단하는 브라우저 지원. 브라우저가 이미 서드파티 쿠키를 차단하면 두 설정 모두 효과 없음. |
| **Add the New Setup Domain** | GA (staggered) | LEX 전 edition. 롤아웃 Spring '24 → Summer '24 → Winter '25; 샌드박스/비프로덕션 먼저, 그다음 프로덕션 | IT가 `*.salesforce-setup.com`을 allowlist에 추가해야 함. Setup 페이지가 해당 도메인에서 호스팅됨. |
| **Create and Verify Your Default No-Reply Org-Wide Email Address (Release Update)** | GA / Release Update | LEX + Classic 전 edition(Database.com 제외). Summer '24 도입, **Winter '25 강제** | Org-Wide Email Address 설정에서 Default No-reply 주소를 생성+검증 필수. 없으면 일부 이메일 발송 실패. |
| **Verify Your Return Email Address for Sender Verification (Release Update)** | Release Update | (Spoke 참조 — Spring '25 강제, [[Winter '25/Release Updates]]) | Spring '25 이후 My Email Settings에서 Email Address 검증 필수. |
| **Enable LWC Stacked Modals (Release Update)** | Release Update | (Spoke 참조 — 전체 표는 [[Winter '25/Release Updates]]) | 더 많은 modal이 LWC로 렌더링. Summer '24 최초 제공. |
| **Get Flexible Access to Custom Apps with the Salesforce Platform Login License** | GA | Ent, Perf, Unl, Dev. 2024-10-15 제공 | seat 기반 라이선스 없이 custom Platform 앱 접근 할당; 일일 고유 로그인당 과금. AE 문의. |
| **Inbound Email Limit Increased** | GA | LEX + Classic; Ent, Pro, Unl, Dev | 일일 한도 도달 후 큐잉되는 inbound 이메일 한도. 큐 = 일일 이메일 rate limit. 한도 후 inbound 이메일 반송. 고우선 서비스에만 Requeue Message 사용. 예: 라이선스 10개 = 일일 한도 전 inbound 이메일 10,000건. |
| **Review Your Integrations for a Change to Email Handling** | GA | LEX + Classic; Ent, Pro, Unl, Dev | RFC 표준에 따라, contact 이메일의 local-part에 잘못된 점이 있으면 따옴표로 감쌈. 예: `consecutive..dots@example.com` → `"consecutive..dots"@example.com`; `trailingdot.@example.com` → `"trailingdot."@example.com`. |
| **Allow the Required Domain for Maps and Location Services** | GA | LEX + Classic + mobile; Pro, Ent, Perf, Unl | Google Maps 기능을 위해 `*.forceusercontent.com`을 allowlist에 추가. |
| **Sender ID Deprecated for Email Security Compliance** | GA (deprecation) | LEX + Classic 전 edition(Database.com 제외) | Email Deliverability 설정에서 Sender ID 더 이상 제공 안 함. Winter '25+ 생성 org는 활성화 불가. 기존 통합은 Summer '24 이후에도 동작. 레코드는 `v=spf2.0` 접두사로 식별. RFC7208(2015)의 결과. |

> 이메일 처리 RFC 변환 예시 (PDF 원문 발췌):
```text
consecutive..dots@example.com   →  "consecutive..dots"@example.com
trailingdot.@example.com        →  "trailingdot."@example.com
```

### Salesforce Scheduler

| Feature | Status | Where | Description |
|---|---|---|---|
| **Manage Service Resource Capacity at the Shift Level** | GA | LEX; Ent, Unl + Salesforce Scheduler. 겹치는 shift capacity 지원 2024-09부터 | Service resource가 shift 레벨당 appointment 수를 정의; territory 관리자가 Work type 레벨에서 capacity 조회. |
| **Verify Your Queue Position with QR-Code-Based Check-In** | GA | LEX + Classic; Ent, Unl + Salesforce Core | QR 코드 waitlist check-in; 고객이 큐 위치 조회·이메일 추적; greeter가 고객을 앞/뒤로 이동. |
| **Easily Notify Waitlist Participants Through Email** | GA | LEX; Ent, Unl + Salesforce Scheduler | 신규 Service Appointment Enrollment Confirmation Email 템플릿. Salesforce Scheduler Settings → Drop In Appointments에서 활성화. |

### Einstein Search

| Feature | Status | Where | Description |
|---|---|---|---|
| **Search Query Limit Is Applied to Improve Performance** | GA | LEX + Classic + mobile; Pro, Ent, Perf, Unl, Dev. Apex/REST/SOSL도 포함 | 한도: 사용자당 **5분 구간 내 3,000 query 및 200,000ms 누적 CPU time**. 초과 시 오류. |

### Salesforce Data Pipelines

| Feature | Status | Where | Description |
|---|---|---|---|
| **Transfer Your Snowflake Data to CRM Analytics Using VPC on AWS** | GA | Data Pipelines(추가 비용) Ent, Perf, Unl | AWS의 Snowflake용 VPC 커넥터; AWS 내부 네트워크, 공용 인터넷 미경유. |
| **Give Users Read-Only Access to Recipes** | Beta | 동일 | Recipes View Only 권한(BETA). |
| **Add Billing Information for Google BigQuery Connections** | GA | 동일 | 프로젝트 billing ID; compute/storage 분리. |
| **Download Data Sync Job Logs in Data Manager** | GA | 동일 | 다운로드 가능한 상세 job 로그. |
| **Improve Snapshot Data Recipe Performance with Advanced Append Output** | Beta | 동일 | Output 노드에 Existing Dataset(Append) 옵션. |
| **Event Monitoring Platform Events Connector** | Pilot | LEX+Classic; Ent, Perf, Unl + Event Monitoring | Platform Events 커넥터로 Real-Time Event Monitoring을 Data Cloud에 import. Events: ListViewEventStream, FileEvent, ApiEventStream, LoginEventStream, ReportEventStream. |
| **Connectors for Google Universal Analytics Have Been Removed** | GA (removal) | 동일 | Universal Analytics 2024-07-01 종료. Google Analytics + Google Analytics Core Reporting v4 커넥터 제거. Google Analytics 4 커넥터 사용. |

### Salesforce Archive

| Feature | Status | Description |
|---|---|---|
| **Save on Storage and Boost Performance with Salesforce Archive** | **Pilot** | LEX Ent/Perf/Unl/Dev; 샌드박스 전용 pilot. 만료/미사용 레코드를 외부 저비용 store에 archive, org에서 시각화, 반복 archive job. 미지원 instance(2024-11): kor\*, idn\*, bra\*, are\*. GA 시 add-on 라이선스. Archive 정책 생성+실행; Salesforce Connect로 조회. |

### Trust Site Enhancements

| Feature | Status | Description |
|---|---|---|
| **Trust Site Enhancements** | GA | Trust.salesforce.com + Status.salesforce.com. Spiff status site 링크 추가; 캐나다 Hyperforce 고객 MuleSoft 지원; Tableau 지원. |

---

## Customization (Setup·선언적)

> 섹션 intro (PDF p.217): "New and improved access summary views… Manage list view items more easily… conditional formatting."

### Permissions

| Feature | Status | Where | Description |
|---|---|---|---|
| **Delivered Idea: Get Insight into How a User's Permissions Are Granted** | GA | LEX 전 edition | profile·perm set·perm set group이 사용자에게 권한을 부여하는 방식 가시화. User Access Summary 내. Setup→Users→View Summary→Access Granted By. |
| **Delivered Idea: See How Object Access Is Granted in Object Manager** | GA | LEX 전 edition | Object Manager 내 읽기 전용 **Object Access Summary**. Object Manager→오브젝트 선택→Object Access. |
| **Track Permission Changes with Event Monitoring** | GA | LEX + Classic(전 org 아님); Ent, Perf, Unl, Dev. API만, Event Monitoring Analytics 앱에는 없음 | EventLogFile 오브젝트의 신규 **Permission Update** event type. |

### List Views

| Feature | Status | Where | Description |
|---|---|---|---|
| **Delivered Idea: Make Inline Edits with the Enhanced User List View** | GA | LEX 전 edition | 사용자 레코드 조회/정렬/필터, 신규 항목 inline 편집. Setup→User Management Settings→Enable Enhanced User List View. |
| **Get Better Performance for List Views on Custom and Standard Objects** | GA (Winter '25 롤링) | LEX 전 edition | List view가 **Aura 대신 LWC**로 렌더링. 다수 UI 동작 변경(드롭다운 100개 list, 키보드 navigation, 필터 패널 Cancel/Save, 암호화 텍스트 inline 편집, lookup 하이퍼링크, "Nothing to see here" 빈 상태 등). |
| **Sort List Views by Multiple Columns** | **Beta** | LEX 전 edition(Starter & Pro Suite 제외) | 최대 **5개 컬럼** 정렬. Setup→User Interface→Enable sort by multiple columns(Beta). opt-in 시 지원되는 모든 list view가 LWC로 렌더링. |
| **Manage List Views with New LWC Wire Adapters** | GA | LEX 전 edition | `lightning/uiListsApi` 신규 wire adapter: `createListInfo`, `deleteListInfo`, `getListInfosByObjectName`, `getListObjectInfo`, `getListPreferences`, `getListRecordsByName`, `updateListInfoByName`, `updateListPreferences`. (이전에는 getListInfoByName, getListInfosByName만.) |
| **Enforce View Roles and Role Hierarchy Permission When Editing Public List View Visibility (Release Update)** | Release Update | LEX + Classic; Ent, Perf, Unl, Dev. Spring '24 최초, **Spring '25 강제** | public list view visibility 편집 시 View Roles and Role Hierarchy 권한 보유자만 role 조회/선택 가능. |

### Lightning App Builder

| Feature | Status | Where | Description |
|---|---|---|---|
| **Delivered Idea: Configure Record Highlights in Lightning App Builder (Dynamic Highlights Panel)** | GA | LEX Group, Pro, Ent, Perf, Unl, Dev | 신규 **Dynamic Highlights Panel** 컴포넌트, 최대 **12개 필드**, 반응형, Fields 탭. mobile은 Setup → Salesforce Mobile App에서 활성화. |
| **Delivered Idea: Make Record Fields Stand Out with Conditional Formatting** | GA (롤링, 2024-10 pre-release/샌드박스) | LEX Group, Pro, Ent, Perf, Unl, Dev | Dynamic Forms 활성화 페이지의 필드에 커스텀 아이콘/색상. **ruleset**(rule 모음) + 조건 사용. Object Manager의 신규 **Conditional Field Formatting** 노드. **Metadata type: `UiFormatSpecificationSet`**. 예: Customer Sentiment 필드 → 초록/회색/빨강 얼굴. |
| **Use Agentforce Sales Coach to Give Users a Personal Coach** | GA | LEX Ent, Perf, Unl + Agentforce Sales Coach add-on | Opportunity 페이지용 신규 Agentforce Sales Coach 표준 Lightning page 컴포넌트. |

### Sharing

| Feature | Status | Where | Description |
|---|---|---|---|
| **Manage Public Group Membership More Easily** | GA | LEX 전 edition | public group summary 페이지; 모든 멤버 검색; 한 번에 최대 100명 추가/제거; summary 페이지에서 편집/삭제. |
| **Delivered Idea: Add a Description for Public Groups** | GA | LEX (How 섹션상 Pro, Ent, Perf, Unl, Dev) | public group에 Description 필드. |
| **Reference Multiple Picklist Values in Restriction and Scoping Rules** | GA | Restriction rule: LEX Ent, Perf, Unl, Dev. Scoping rule: LEX Perf, Unl, Dev | 레코드 기준에 다중 picklist 값. Object Manager→Restriction/Scoping Rules→Choose values. |
| **Update Apex Code and Sharing Rules in Metadata Deployments that Target Roles and Subordinates in Preview Sandboxes** | GA | LEX + Classic; Pro, Ent, Perf, Unl, Dev | 기본 sharing group이 이제 "Roles and Internal Subordinates". Apex에서 `roleAndSubordinates` 대신 `roleAndSubordinatesInternal` 사용. |

### Globalization

| Feature | Status | Description |
|---|---|---|
| **Discover 11 New Regional English Variations** | GA | LEX+Classic+mobile 전 edition. 신규: English (Czechia) en_CZ, (Denmark) en_DK, (France) en_FR, (Hungary) en_HU, (Norway) en_NO, (Poland) en_PL, (Romania) en_RO, (Slovakia) en_SK, (Spain) en_ES, (Sweden) en_SE, (Switzerland) en_CH. |
| **Enjoy a Streamlined State and Country Picklist Setup Process** | GA | LEX+Classic+mobile 전 edition. 단계 축소; 표준 state/country 자동 매핑. |
| **Review Updated Label Translations** | GA | LEX+Classic+mobile 전 edition. 33개 언어 번역 업데이트(Arabic, Bulgarian, Chinese Simplified/Traditional, Croatian, Czech, Danish, Dutch, Finnish, French, German, Greek, Hebrew, Hungarian, Indonesian, Italian, Japanese, Korean, Norwegian, Polish, Portuguese Brazil/European, Romanian, Russian, Slovak, Slovenian, Spanish, Spanish Mexico, Swedish, Thai, Turkish, Ukrainian, Vietnamese). |
| **Enable ICU Locale Formats (Release Update)** | Release Update | LEX+Classic+mobile 전 edition(Database.com 제외). Winter '20 최초; Spring '24부터 롤링 강제; UI로 Summer '25까지 연기 가능. en_CA는 별도 활성화 필요(Setup→User Interface→Enable ICU formats for en_CA). |
| **Some Supported Time Zones No Longer Available** | GA (removal) | 전 edition. 제거: Cuba Daylight Time (America/Havana), Cuba Standard Time (America/Havana), Korean Standard Time (Asia/Pyongyang). |

### Salesforce Connect

| Feature | Status | Description |
|---|---|---|
| **Use a Private Connection with the Salesforce Connect SQL Adapter for Snowflake** | GA | LEX+Classic; Ent, Perf, Unl, Dev. AWS VPC, Private Connect, callout가 공용 인터넷 미경유. |
| **Enhance Your Custom Adapter for Salesforce Connect with More External Data Types** | GA | LEX+Classic; Ent, Perf, Unl, Dev. `DataSource.Connection` Apex 클래스로 모든 external object 필드 타입 지원. 신규 타입: Picklist, Picklist (Multi-Select), Time. |
| **Salesforce Connect OData 2.0 Adapter HTTP Library Is Updated** | GA | LEX+Classic; Ent, Perf, Unl, Dev. OData4J Jersey HTTP 라이브러리가 **버전 2.4.2**로 업데이트(Apache Olingo 사용). |

### AppExchange

| Feature | Status | Description |
|---|---|---|
| **Try AppExchange Solutions with Ease** | GA | AppExchange 웹사이트. 신규 **Try It Free** 액션; test drive·Trialforce trial·샌드박스 설치를 한 곳에서. |

### General Setup

| Feature | Status | Description |
|---|---|---|
| **Manage Details About a User in One Place** | GA | LEX+Classic 전 edition. 통합 User Access Summary 페이지; 표준+커스텀 필드가 User Details 섹션과 일치. |
| **Enable Dynamic Highlights Panel and Dynamic Forms on Mobile with One Click** | GA | LEX Group, Pro, Ent, Perf, Unl, Dev. Setup→Salesforce Mobile App. |
| **Restore Only the Latest Entity History Records for a Deleted Entity** | GA | LEX+Classic; Ent, Perf, Unl, Dev. Field History Tracking으로 가장 최근 history 레코드 **상위 20,000건** 복원. |

---

## Security · Identity · Privacy

> 섹션 intro (PDF p.807): "Migrate your local connected apps to local external client apps. Monitor vital data from custom objects by creating custom metrics. Legacy My Domain URLs are no longer redirected in most non-production orgs. And Salesforce now supports TLS 1.3 for outbound HTTPS callouts."

### Salesforce Backup

| Feature | Status | Where | Description |
|---|---|---|---|
| **Restore Files from a Backup** | GA | LEX Pro, Ent, Unl | Managed package v2.25+. export/import 없이 파일 복원; 특정 버전 선택. Restore & Export 탭 → Data Category → Restore Files. |
| **Restore Files More Efficiently with Bulk Actions** | GA | LEX Pro, Ent, Unl | Managed package **v2.27**. Bulk Actions 메뉴 → Select Latest Version. |

### Domains (My Domain / legacy redirect 폐기)

| Feature | Status | Where / When | Description |
|---|---|---|---|
| **Update References to Your Previous Salesforce Domains** | GA | LEX+Classic; Group, Essentials, Pro, Ent, Perf, Unl, Dev | 2022년 6월 이전 생성 org: enhanced domain이 URL 변경. **Winter '25: 대부분의 비프로덕션 org에서 legacy URL이 더 이상 redirect 안 됨.** My Domain redirection logging으로 영향받는 URL 탐지. **When:** Winter '25에 샌드박스·Dev Edition org·patch org·scratch org·Trailhead Playground에서 redirection 중단. 프로덕션/데모 org: **Winter '25 patch 9**부터 legacy My Domain hostname redirection이 기본 활성화; **모든 legacy URL은 Winter '26에 중단.** |
| **Identify and Update Instanced Legacy Hostnames** | GA | 동일; **Winter '25 patch 9** | 잘못된 instance 이름을 가진 non-enhanced hostname에 대한 redirection + logging. 프로덕션/데모: My Domain redirection 설정 활성화 시에만 redirect. 예시 hostname: `MyDomainName--c.usa61.content.force.com`, `c.usa61.content.force.com` → `MyDomainName.file.force.com`. Hostname Redirects event type 사용. 모든 legacy redirection 종료 **Winter '26**. |
| **Disable Redirections for Legacy Hostnames** | GA | 동일; **Winter '25 patch 9** 신규 설정이 프로덕션/데모에 기본 활성화 | 신규 My Domain 설정: **Redirect legacy (non-enhanced) My Domain hostnames**(데모 외 비프로덕션에는 없음). Setup→My Domain→Redirections→Edit→비활성화. 비활성화 시: force.com site URL redirection 불가; Instanced URL redirection이 "Don't redirect"로 설정(잠김). |
| **Get Help with Custom Domains Directly in Setup** | GA | LEX+Classic; Ent, Perf, Unl (+ Pardot 있는 Pro) | Domain Detail 페이지의 solution; 검색/브라우즈; Create a Case 버튼. |

### Identity and Access Management

> connected app → external client app 마이그레이션, headless/passwordless, MFA, SAML 항목. depth-critical.

| Feature | Status | Where / When | Description |
|---|---|---|---|
| **The Multi-Factor Authentication Assistant in Setup Is No Longer Needed and Discontinued** | GA (retirement) | LEX. MFA learning map 2024-09-06 제공 | MFA가 신규+기존 프로덕션 org에서 자동 활성화. MFA Assistant 제거; MFA learning map으로 대체. |
| **Migrate to a Local External Client App from Your Local Connected App** | GA | LEX; Group, Essentials, Pro, Ent, Perf, Unl, Dev | 자동 마이그레이션이 external client app 생성(전체 metadata 준수, 2GP). connected app은 App Manager에서 읽기 전용으로 잔존. App Manager→Migrate to External Client App. |
| **Manage OAuth Usage for External Client Apps** | GA | LEX+Classic; Group, Essentials, Pro, Ent, Perf, Unl, Dev | active access/refresh token이 있는 ECA 조회; 개별/전체/사용자별 revoke. external client app 기본 off — Setup→External Client Apps→Settings→Opt in. External Client App Usage 페이지; External Client App Usage by User 페이지. |
| **Create an External Client App from App Manager** | GA | LEX+Classic; Group, Essentials, Pro, Ent, Perf, Unl, Dev | New Connected App 클릭 시 ECA 생성 옵션. |
| **Assign and Package OAuth Custom Scopes for External Client Apps** | GA | LEX+Classic; Group, Essentials, Pro, Ent, Perf, Unl, Dev | custom scope 패키지 가능; 패키지 기본값으로 설정. 별도 2GP managed package로 패키지. |
| **Configure the Start URL for External Client Apps** | GA | LEX+Classic; Group, Essentials, Pro, Ent, Perf, Unl, Dev | Policies 탭: OAuth 전용 start URL + custom start URL. ECA가 App Manager에 나타나려면 start URL 필요. |
| **Show an External Client App in App Launcher** | GA | LEX+Classic; Group, Essentials, Pro, Ent, Perf, Unl, Dev | App Menu에서 Visible in App Launcher 표시. start URL 필요. |
| **Delivered Idea: Customize User Experience and Functionality for Authentication Providers** | GA | LEX+Classic; Ent, Perf, Unl, Dev | auth provider용 URL 파라미터 allowlist(예: `ui_locales`). Metadata type **`AuthProvParamFwdAllowlist`**(allowlist 파라미터 1개씩). |
| **Customize SMS One-Time Password Delivery for Experience Cloud Sites** | GA | LWR, Aura, Visualforce site; Ent, Unl, Dev | custom SMS provider로 OTP 발송하는 Apex 핸들러. 활성화는 Support 문의. Apex: `CustomOneTimePasswordDeliveryHandler` 인터페이스. |
| **Forced Login Is Permanently Disabled** | GA | LEX+Classic 전 edition | URL query string으로 username/password 불가. Forced login 기준: HTTP Method GET, Login Type Application, Login Subtype empty, Status Success. |
| **Forgot Password Invalid Username Error Message Was Changed** | GA | Org: LEX+Classic 전 edition. Exp Cloud: LWR+Aura; Ent, Perf, Unl, Dev | 신규 메시지: "Enter a valid username. Your username is in the format of an email address, such as username@company.com." |
| **Make the Most of Enhancements for the Headless Registration Flow** | GA | LEX+Classic; Ent, Unl, Dev | external client apps 프레임워크로 설정(2GP, metadata 노출). 자동 생성 핸들러에 contact/account 메서드 추가. Apex: `HeadlessSelfRegistrationHandler` 인터페이스. |
| **Get Ready for a New Login Experience** | GA (announcement) | LEX+Classic+mobile 전 edition. Winter '25 후반 login.salesforce.com에 배너 | 향후 로그인 경험을 알리는 배너. forward-looking statement 적용. |
| **Get More Flexibility with Headless Identity Flows** | GA | LEX+Classic; Ent, Unl, Dev | Authorization 헤더에 **JWT 기반 access token** 전송(이전에는 opaque token만). |
| **Be an Early Adopter of a Headless Identity Draft Standard** | GA | LEX+Classic; Ent, Unl, Dev | **OAuth 2.0 for First-Party Applications** draft 표준을 따르는 headless username-password·passwordless·registration flow. 신규 OAuth 2.0 authorization challenge 엔드포인트. |
| **Revoke Individual JWT-Based Access Tokens** | GA | LEX+Classic 전 edition | 사용자별 JWT token revoke(guest + named user). REST: `/services/oauth2/revoke`에 POST. Apex: `Auth.OauthToken` 클래스의 `revokeToken` 메서드. |
| **Migrate to a Multiple-Configuration SAML Framework (Release Update)** | Release Update | LEX+Classic; Ent, Unl, Dev. Spring '24 최초. 전 instance Summer '24 스케줄; **샌드박스는 Summer '24 강제, 프로덕션은 Spring '25로 연기** | single-config SAML 제거, multiple-config만 지원. 변경: SAML response가 audience attribute 포함 필수; Login URL 변경; 파싱 불가 SAML response는 login history에 미기록. single-config 프레임워크 사용 시에만 표시. |
| **Manage Token Exchange Handlers with Ease** | GA | LEX+Classic 전 edition | OAuth token exchange handler용 신규 UI. Setup의 Token Exchange Handlers 페이지. |
| **Give Users More Ways to Log In** | GA | LEX+Classic; Ent, Unl, Dev | headless user discovery로 headless passwordless 로그인(임의 식별자). Apex: `Auth.HeadlessUserDiscoveryHandler` 클래스; `login_hint` 파라미터. |
| **Use REST API for Access to External Client App OAuth Consumer Credentials (Release Update)** | Release Update | Group, Essentials, Pro, Ent, Perf, Unl, Dev. **Winter '25 강제** | Metadata API 대신 신규 `credentials` Connect REST API 리소스 사용. Winter '25 이후 ECA는 Metadata API로 consumer secret 접근 불가(Support 문의 시 제외). |
| **API Error Response for Refresh Token Flow Was Changed** | GA | LEX+Classic 전 edition | 동시에 동일한 refresh token 요청 시 이제 정확한 오류 반환. |
| **Verify SAML Integrations (Release Update)** | Release Update | LEX+Classic 전 edition. Winter '25 표시. Spring '25 스케줄이나 **Summer '25로 연기** | SAML 프레임워크 업그레이드. SSO + single logout에 영향. Summer '25 샌드박스에서 테스트. |
| **Salesforce Authenticator Users Are Automatically Guided to a Workaround if Push Notifications Time Out** | GA | LEX+Classic 전 edition | push가 **30초** 내 승인 안 되면 6자리 TOTP 자동 프롬프트(이전에는 90초 timeout 오류). |
| **Identify the Salesforce Authenticator App More Easily** | GA | iOS+Android Authenticator 앱 v4.4.0+ | Salesforce 로고가 포함된 재디자인된 앱 아이콘. |
| **Update the Salesforce Authenticator App to Version 4.3** | GA | LEX+Classic 전 edition | push notification 최소 지원 버전 4.3. 4.3 미만 = TOTP만. Lightning Login에 영향. |

> **Refresh Token Flow API 오류 응답 변경 (PDF 원문 verbatim, lines 33990–34010):**

**이전(부정확) 응답:**
```http
HTTP/1.1 400 Bad Request
Content-Type: application/json
Cache-Control: no-store
{
"error":"invalid_grant",
"error_description":"expired authorization code"
}
```

**신규 응답:**
```http
HTTP/1.1 400 Bad Request
Content-Type: application/json
Cache-Control: no-store
{
"error":"invalid_grant",
"error_description":"token request is already being processed"
}
```

### Privacy Center

| Feature | Status | Where | Description |
|---|---|---|---|
| **Avoid Accidental Data Impact by Previewing Data Management Policies** | GA | LEX Ent, Perf, Unl, Dev | 실행 전 preview 생성+acknowledge. 메트릭: 영향받는 전체 레코드, 삭제된 전체 파일/첨부, 오브젝트별 영향 레코드. "Bypass previewing for Data Management Policies" 설정으로 우회. |
| **Retain Data with Privacy Center** | GA | LEX Ent, Perf, Unl, Dev. Government Cloud 제외. 2024-11부터 대부분 instance | 플랫폼 네이티브 Privacy Center; 마스킹/삭제하며 레코드를 외부 store에 복사; Salesforce Connect로 조회. 미지원 instance: kor\*, idn\*, bra\*, are\*. **파일·첨부 retention = Pilot.** |
| **Policy Validation Improvements in Privacy Center** | GA | LEX Ent, Perf, Unl, Dev | 신규/개정 오류 메시지: 누락된 object/field; 구성된 object 없음; 다중 top-level object를 가진 RTBF 정책. |

### Named Credentials

| Feature | Status | Description |
|---|---|---|
| **Control Who Can Perform Authenticated Callouts with Ease** | GA | LEX+Classic 전 edition. 대부분의 표준 perm set/profile이 이제 User External Credentials object 접근을 기본 보유. Guest user profile + 기존 custom perm set/profile은 여전히 수동 부여 필요. |

### Salesforce Shield

> Event log objects, custom metrics, LoginAsEvent, encryption. depth-critical.

**Event Monitoring:**

| Feature | Status | Where | Description |
|---|---|---|---|
| **Generate Test Events for Threat Detection** | Beta | LEX+Classic; Ent, Perf, Unl + Event Monitoring; Shield/Event Monitoring add-on | Test Threat Detection Events (Beta) 기능. |
| **Get Notified and Block Activity When a User Logs In as Someone Else with Transaction Security** | GA | LEX+Classic; Ent, Perf, Unl + Event Monitoring; Shield/EM add-on | **LoginAsEvent** 기반 Transaction Security 정책(Condition Builder 또는 Apex). |
| **Import Real-Time Event Monitoring Event Data Into Data Cloud** | Pilot | LEX; Dev, Ent, Perf, Unl + Event Monitoring; Shield/EM add-on | Platform Events 커넥터 pilot. Support로 `CdpConnectorsPilot` 권한 활성화. Events: ListViewEventStream, FileEvent, ApiEventStream, LoginEventStream, ReportEventStream. |
| **Track Network Performance Metrics** | GA | LEX Ent, Perf, Unl, Dev + Event Monitoring; Shield/EM add-on. API + Event Log Browser, Analytics 앱 아님 | 신규 **UI Telemetry Timing** events: **Resource Timing** event log file type + **Navigation Timing** event log file type. |
| **Identify Blocked Redirections for Legacy Hostnames** | GA | LEX+Classic; Ent, Perf, Unl, Dev. HostnameRedirects event(API, 24시간 retention, 무료) | Hostname Redirects event type의 **REDIRECT_REASON** 필드 사용. 신규 값: "Redirection was blocked because redirections for the legacy SOURCE_HOSTNAME are no longer supported." |
| **Get Information About Permission Changes** | GA | LEX+Classic; Ent, Perf, Unl, Dev. API만. Shield/EM add-on | EventLogFile의 신규 **Permission Update** event type. object/field/user 권한 변경, profile cloning, session activation 변경 추적. |
| **Query Low-Latency Event Data with Event Log Objects** | Beta | LEX+Classic; Ent, Perf, Unl + Event Monitoring. **US Hyperforce 고객** + Shield/EM add-on 대상 | 신규 **event log object 프레임워크(beta)** — event 데이터를 표준 object에 캡처; API 또는 CRM Analytics로 query. |

**Shield Platform Encryption:**

| Feature | Status | Where | Description |
|---|---|---|---|
| **Manage Encryption Keys for Data Cloud** | GA | LEX+Classic; Ent, Perf, Unl. 2024-09 제공. Government Cloud 제외 | **Data Cloud root key** 관리. Encryption Settings → Manage Data Cloud Keys. Generate Root Key로 rotate. |
| **Set Up Shield Platform Encryption with Fewer Clicks** | GA | LEX+Classic; Ent, Perf, Unl, Dev | Encryption Settings 페이지에서 초기 **probabilistic** + **deterministic** tenant secret 생성. |
| **Encrypt the Comments Field on New Participant Objects for Compliant Data Sharing in Public Sector Solutions** | GA | LEX Ent, Perf, Unl, Dev + Public Sector Solutions | 다음 object의 Comments 필드 암호화: Application Form Evaluation Participant, Case Proceeding Participant, Complaint Participant, Recruitment Requisition Participant. 스킴: probabilistic, case-sensitive deterministic, case-insensitive deterministic. |

### Security Center

| Feature | Status | Where | Description |
|---|---|---|---|
| **Create Custom Metrics in Security Center** | **GA** | LEX Ent, Perf, Unl, Dev; Security Center add-on | custom object로부터 custom metric 생성. Security Center의 Custom Metrics 탭. |
| **Monitor Additional User Permissions** | GA | Ent, Perf, Unl, Dev; Security Center add-on | 신규 user permission 메트릭: Retain Field History, View Real-time Event Monitoring Data, View Threat Detection Events, Access Event Monitoring Analytics Templates & Apps, Monitor Login History, Freeze Users, Export Reports. |
| **View Fields That Are Encrypted Under Your Shield Platform Encryption Policy** | GA | LEX Ent, Perf, Unl, Dev; Shield Platform Encryption + Security Center add-on | **Field Level Encryption** 메트릭. Security Landscape의 Configuration 카테고리. |
| **View Pertinent Data with an Enhanced Security Center Dashboard Page** | GA | LEX Ent, Perf, Unl, Dev; Security Center add-on | connected tenant status 포함 개선된 대시보드. |
| **Check the Status of Your Connected Tenants From the Dashboard Page** | GA | Ent, Perf, Unl, Dev; Security Center add-on | parent org 내 모든 connected tenant의 status 조회. |

> **API 객체명 주의:** 본 Security Center 커스텀 메트릭 항목에 대해, PDF 본문은 literal 문자열 `TenantSecurityCustomMetric`을 어디에도 사용하지 않는다. PDF는 "Create Custom Metrics in Security Center (GA)" 기능을 "custom objects" 표현으로만 기술한다. 따라서 본 노트는 PDF 본문에 없는 API object 명칭을 단정하지 않는다.

### Other Security Changes

| Feature | Status | Where | Description |
|---|---|---|---|
| **Delivered Idea: Improve Data Transmission Speed and Security with TLS 1.3** | GA | LEX+Classic+mobile 전 edition | **Salesforce가 이제 outbound HTTPS callout에 TLS 1.3을 지원.** 더 강한 암호화, 단순화된 handshake. 기존 TLS 1.2 callout에 영향 없음. endpoint 소유자와 협의해 TLS 1.3 활성화 후 선택적으로 TLS 1.2 비활성화. |
| **New Hyperforce Orgs Use Salesforce Edge Network** | GA | LEX+Classic; Group, Essentials, Pro, Ent, Perf, Unl, Dev. 2024-10-04부터 | 신규 Hyperforce org가 기본으로 Salesforce Edge Network 사용. Support로 opt out. |
| **Adopt Updated Content Security Policy (CSP) Directives (Release Update)** | **CANCELED** | LEX+Classic; Ent, Perf, Dev, Unl | **이 업데이트는 취소됨.** Release Updates 페이지에 더 이상 표시 안 됨. Salesforce는 현재 "Adopt updated CSP directives"를 강제하지 않음. |
| **Security Was Tightened for the retUrl Parameter for My Domain Redirects** | GA | LEX+Classic 전 edition | `retUrl` 파라미터: 브라우저가 retUrl로만 redirect, 추가 redirect 차단. |
| **Violation Type Label Was Changed for Blocked Redirections** | GA | LEX Ent, Perf, Unl, Dev | violation type이 **Blocked Redirection**으로 변경(이전 External Redirection) — Trusted URL and Browser Policy Violations List. |

---

## Hyperforce · 인프라

> Hyperforce intro (PDF p.425, 원문): "Hyperforce is the next-generation Salesforce infrastructure architecture built for the public cloud. It provides Salesforce applications with compliance, security, privacy, agility and scalability, and gives customers more choice over data residency."

본 릴리즈의 Hyperforce 섹션 범위에는 별도 feature 항목이 없다(섹션 intro만 존재). Hyperforce 관련 변경은 Security의 *New Hyperforce Orgs Use Salesforce Edge Network*(GA, 2024-10-04부터)와 Shield의 *Query Low-Latency Event Data with Event Log Objects (Beta)*("available to US Hyperforce customers")에 분산되어 있다.

> DevOps Center, Salesforce CLI, Code Builder, Scale Center/ApexGuru, Heroku, Functions 등 DevOps·개발 도구 항목은 본 spoke의 Platform 추출 범위(SPOKE 1) 본문에 별도 전체 항목으로 등장하지 않았다. 추출되지 않은 항목을 fabricate하지 않으며, Development 영역의 개발자 도구는 [[Winter '25/Development]]를 참조한다.

---

## Flow (선언적 자동화)

> 섹션 intro (PDF p.765): "Compose intelligent workflows with Flow Builder and Flow Orchestration. Integrate across any system with MuleSoft Composer."
>
> Apex/invocable/versioned Flow 항목은 [[Winter '25/Development]]에 위치한다. 단, "Flow and Process Release Updates" 클러스터(사용자 플래그된 "Restrict User Access to Run Flows" 연기 포함)는 이 섹션 본문의 일부이고 [[Winter '25/Release Updates]]와 겹치므로 여기서 전체 전사한다.

### Flow Builder Updates (declarative)

| Feature | Status | Where | Description |
|---|---|---|---|
| **Troubleshoot Configuration Issues Systematically with the Errors and Warning Pane** | GA | LEX+Classic; Essentials, Pro, Ent, Unl, Dev | 신규 Errors and Warnings pane; notification badge가 있는 Show Error 버튼. |
| **Find Flow Child Resources More Easily** | GA | LEX+Classic; Essentials, Pro, Ent, Perf, Unl, Dev | child resource 직접 검색(Screen 컴포넌트, screen action, Decision outcome, Wait config). |
| **Create New Variable and Constant Flow Resources More Easily** | GA | LEX+Classic; Essentials, Pro, Ent, Unl, Dev | Text, Number, Currency, Boolean, Date, Date/Time에 대한 resource 그룹화. |
| **Find Flow Resource Variables More Easily in Assignment and Create Records Elements** | GA | LEX+Classic; Essentials, Pro, Ent, Unl, Dev | Assignment + Create Records에서 강화된 resource 선택. |
| **Identify Inefficient Flow Designs with New Tips** | GA | LEX+Classic; Pro, Ent, Unl, Perf, Dev | 성능/governor limit에 대한 Flow Builder canvas 팁. |
| **Get Help Creating Flow Formulas with Einstein** | **Beta** | LEX 전 Einstein 1 edition; Ent/Perf/Unl + Einstein for Sales/Service/Platform add-on | Einstein generative AI가 Flow Formula Builder에서 formula 생성. Setup→Process Automation Settings→Einstein이 생성한 formula 활성화. |
| **Edit Your Einstein Instructions in Flow Builder** | **Beta** | 위와 동일 | Einstein window에서 Einstein 지시 편집. Setup→Einstein for Flow (Beta). |
| **Launch Another Active Prompt Flow as a Subflow Within a Prompt Flow** | GA | LEX Ent, Perf, Unl | prompt flow용 Subflow 요소(다른 prompt flow만 참조). |
| **Create or Update Records Efficiently with the Create Records Element** | GA | LEX+Classic; Pro, Ent, Unl, Perf, Dev | 기존 필드 값 기반으로 레코드 생성 또는 업데이트. Update Existing Records 활성화. |
| **Transform Data into More Target Resource Types** | GA | LEX+Classic; Pro, Ent, Unl, Perf, Dev | Transform 요소 타깃이 이제 Text, Numbers, Currency, Boolean, Date, Date/Time(이전에는 복합 Record/Apex-defined만). |

### Screen Flow Updates (declarative)

| Feature | Status | Where | Description |
|---|---|---|---|
| **Provide a Better Screen Flow Experience with Action Buttons** | **GA** | LEX+Classic; Essentials, Pro, Ent, Perf, Unl, Dev. Classic runtime 제외 | Action Button 컴포넌트가 screen action(active autolaunched flow) 트리거. 신규: running indicator, input/output refresh, **In Progress** output, system-context notification, criteria 기반 disable, accessibility. |
| **Collect User Input to Modify a List of Records from a Screen** | GA | LEX+Classic; Pro, Ent, Perf, Unl, Dev. Classic runtime 제외 | Repeater 컴포넌트가 기존 record collection 업데이트. Output collection: Added, All, Prepopulated, Removed Items. |
| **Disable More Screen Component Fields at Run Time** | GA | LEX+Classic; Essentials, Pro, Ent, Perf, Unl, Dev. Classic runtime 제외 | Action Button, Dependent Picklist, Lookup, Phone, Slider 컴포넌트에 Disabled 속성. |
| **Select Multiple Choices with Choice Lookup Component** | GA | LEX+Classic; Pro, Ent, Perf, Unl, Dev. Classic runtime 제외 | Choice Lookup 단일 또는 다중(최대 25개) 선택. |
| **Recognize and Differentiate Between Custom Components Instantly in Screen Elements** | GA | LEX+Classic; Pro, Ent, Perf, Unl, Dev | custom 컴포넌트에 label/API 이름 표시. |
| **Deselect Data Table Rows When in Single-Row Selection Mode** | GA | LEX+Classic; Essentials, Pro, Ent, Perf, Unl, Dev. Classic runtime 제외 | radio 대신 checkbox; "Require user to make a selection"으로 되돌리기. |

### Flow Marketing Cloud Updates

| Feature | Status | Where | Description |
|---|---|---|---|
| **Visualize Flow Data with On-Canvas Insights** | GA | LEX Ent + Unl + Marketing Cloud Advanced | canvas의 flow analytics; element run/duration/error 데이터; Analytics 탭. Flow Reports Analytics Package 필요. |
| **Test and Optimize Engagement with Path Experiments** | GA | LEX Ent + Unl + Marketing Cloud Advanced | segment-triggered flow의 신규 **Path Experiment** 요소; percentage split으로 최대 10개 path. |
| **Automate Your Responses to Common Customer Actions with Out-of-the-Box Automation Event-Triggered Flows** | GA | LEX Marketing Cloud Growth(form submission은 Salesforce Starter도) | automation event-triggered flow; Event Library(예: Email Subscription); `$Event` flow 변수. form-triggered flow 대체. |
| **Preserve References to Data Graph Values in Campaign Flows** | GA | LEX Marketing Cloud Growth | segment-triggered flow를 data graph에 연결; 값 저장. |

### Flow Actions

| Feature | Status | Where | Description |
|---|---|---|---|
| **Expand Your Email Reach by Using CC and BCC Options in Send Email Action** | GA | LEX+Classic; Essentials, Pro, Ent, Perf, Unl, Dev | 최대 수신자 **5 → 150**으로 증가; CC + BCC 옵션. |

### Flow Testing and Debugging

| Feature | Status | Where | Description |
|---|---|---|---|
| **See Scheduled Flows Limit in Debug Details** | GA | LEX+Classic; Essentials, Pro, Ent, Unl, Dev | debug 패널에서 일일 최대 scheduled flow 수 조회. |
| **Test and Troubleshoot Your Template-Triggered Prompt Flows with the Debug Tool** | GA | LEX Ent, Perf, Unl | template-triggered prompt flow용 debug 도구. |

### Flow Management

| Feature | Status | Where | Description |
|---|---|---|---|
| **Run Schedule-Triggered Flows on Limited Records to Improve Performance** | GA | LEX+Classic; Essentials, Pro, Ent, Unl, Dev | 단일 schedule-triggered flow가 **250,000개 레코드**로 제한(이전에는 무제한). |

### Flow Extensions

| Feature | Status | Where | Description |
|---|---|---|---|
| **Create Personalized Recommendations Using Einstein Next Best Action in Experience Cloud Sites** | GA | LEX+Classic+mobile; Essentials, Pro, Ent, Perf, Unl, Dev | Exp Cloud 페이지의 Einstein Next Best Action 컴포넌트. |

### Flow Runtime (versioned — [[Winter '25/Development]] 참조)

"Flow and Process Run-Time Changes" — API v62.0 versioned 업데이트: Enforce Sharing Rules when Apex Launches a Flow (v62.0); Evaluate Null Text Values (v61.0); Set Screen Action Outputs to Null Correctly (v62.0); Set Conditionally Hidden Screen Component Outputs to Null Correctly (v62.0).

### Flow and Process Release Updates (전체 타이밍 — [[Winter '25/Release Updates]]와 겹침)

| Release Update | First available | Enforcement / status |
|---|---|---|
| **Enforce Sharing Rules When Apex Launches a Flow** | Spring '24. Winter '25 스케줄 | **Winter '25부터 더 이상 강제 안 함**(recommended). 대안: API v62.0+. |
| **Prevent Guest User from Editing or Deleting Approval Requests** | Winter '23. Summer '23 스케줄 → Spring '24 연기 → 재연기 | **Winter '25 강제.** |
| **Restrict User Access to Run Flows** | Winter '24. Winter '25 스케줄 | **Winter '26으로 연기.** FlowSites org 권한 deprecate. perm set에 Run Flows 권한 추가. |
| **Enable Secure Redirection for Flows** | Summer '24. Spring '25 스케줄 | **Spring '25부터 더 이상 강제 안 함**(recommended). |
| **Enforce Rollbacks for Apex Action Exceptions in REST API** | Spring '23. Spring '25 스케줄 | **Spring '25부터 더 이상 강제 안 함**(recommended). |
| **Run Flows in User Context via REST API** | Spring '22 강제; 재출시 | **Winter '25 재강제**(subset의 preference 복원). |
| **Evaluate Criteria Based on Original Record Values in Process Builder** | Summer '19 | **Summer '25 강제.** |
| **Make Flows Respect Access Modifiers for Legacy Apex Actions** | Spring '21 강제; 재출시 | **Winter '25 재강제.** |
| **Disable Access to Session IDs in Flows** | Winter '24 강제; 재출시 | **Winter '25 재강제.** |
| **Enable Partial Save for Invocable Actions** | Spring '20 강제; 재출시 | **Winter '25 재강제.** partial save 미지원 action type 11종: Cancel Fulfillment Order, Cancellation Orders, Capture Funds, Content Workspaces, Create Fulfillment Order, Create Invoice from Fulfillment Order, Create Service Report, External Services, Generate Work Orders, Invocable Apex, Skills-based Routing, Submit Digital Form Response. |
| **Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs** | Summer '24. Spring '25 스케줄 | **Winter '26으로 연기.** |
| **Sort Apex Batch Action Results by Request Order** | — | **Spring '25 강제.** |
| **Enable EmailSimple Invocable Action to Respect Organization-Wide Profile Settings** | Summer '23. Spring '24 스케줄 | **Winter '25로 연기(Winter '25 강제).** |
| **Enhance Flexibility and Reusability in Prompt Flows** | Winter '25 | **Spring '25 강제.** flex prompt template type 제거; manual input 사용. |

### Flow Orchestration (declarative)

- **View Orchestration Details in the Automation Lightning App** (GA, LEX Ent/Perf/Unl/Dev) — 신규 Orchestrations 탭 + Runs 탭. 권한: View Orchestration in Automation App, Orchestration Process Manager perm set, Manage Orchestration Runs / Manage Orchestration Runs and Work Items.
- **Manage Steps in an Orchestration Stage** (GA) — step 복사/붙여넣기/드래그; hover description.
- **Customize the Flow Orchestration Work Guide Component** (GA) — 레코드 페이지별 config, title, sort order, visibility 토글.
- **View Orchestrations Directly from the Automation Lightning App** (GA) — View Flow in Flow Builder.
- **Add New Fields in Orchestration Run List Views** (GA) — current stage, duration, triggering record.
- **Other Changes to Flow Orchestration:** Easier Access to Debugging a Failed Orchestration (14일); Orchestration Run Log Object (Object Manager에서 커스터마이즈 가능); Updates to Orchestration Resource Pickers; Updated Orchestration Packaging Error Messages; New Quick Menu on Orchestration Run Details Page; New Debug Error Message; Completed By Field in Orchestration Run Log; Flows Called by Orchestrations Can Update Orchestration Records; Updates to Automation Credit Usage (Apex test-triggered orchestration은 더 이상 credit 비용 없음).

### MuleSoft Composer for Salesforce

GA — Ent, Perf, Unl(LEX)에서 추가 비용. (intro만.)

---

## Mobile (admin)

### Salesforce Mobile App / Offline Access

| Feature | Status | Where | Description |
|---|---|---|---|
| **Access Linked Resources Anytime in Enhanced Reports on Salesforce Mobile** | GA | LEX + iOS/Android; Pro, Dev, Ent, Unl. 2024-10-14 주 | mobile의 Enhanced Reports에서 하이퍼링크 열기. |
| **Restart Offline Draft Syncs with One Tap** | GA | Salesforce Mobile App Plus iOS/Android phone+tablet 전 edition(Database.com 제외) | 멈춘 업로드를 재시작하는 force sync 버튼. Mobile Offline + Salesforce Mobile App Plus 라이선스 필요. |
| **Access Record Attachments in the Offline App with Files Priming** | **Beta** | Salesforce Mobile App Plus v252.000+ iOS/Android 전 edition(Database.com 제외) | 파일 첨부를 오프라인용으로 prime. Briefcase Builder → object rule → Enable file attachments. |
| **Messaging in the Salesforce Mobile App Is Now Generally Available** | **GA** (Summer '24 Beta였음) | 모든 enhanced messaging 채널 + Messaging for In-App and Web. Messaging User PSL + Message on Mobile 권한 | agent가 mobile 앱에서 고객에게 메시지. |
| **Send Messaging Components and Transfer Messaging Sessions with Messaging for Mobile** | GA | 위와 동일 | session 전송; 호환 컴포넌트 전송. |
| **Boost Your Sales Productivity with a Seller-Focused Mobile App** | **GA** | Seller-Focused Sales Mobile Experience Android/iOS phone+tablet 전 edition(Database.com 제외). 2024-10 | account·contact·lead·opportunity 추적/업데이트. |
| **Mobile Home Tab Setting Is Now on by Default** | GA | LEX+Classic+mobile 전 edition | Mobile Home 탭이 모든 profile에 기본 On(이전에는 custom profile 제외). |
| **Verify Briefcase Settings by Using the Count of Total Unique Records** | GA | Field Service가 있는 LEX desktop. SFS mobile용 Briefcase Builder + Salesforce Mobile App Plus | Run As User 뷰에서 전체 고유 레코드 수. |
| **Validate Mobile Lightning Web Components with ESLint Rules** | GA | Salesforce Mobile App Plus iOS/Android 전 edition(Database.com 제외) | ESLint rule 플러그인이 Apex 사용, Offline GraphQL 기능 제한 + hard limit 플래그. |
| **Offline GraphQL Pagination Support** | GA | Salesforce Mobile App Plus iOS/Android 전 edition(Database.com 제외) | top-level record query만 pagination, nested child query는 아님. |

### Mobile Publisher

| Feature | Status | Where | Description |
|---|---|---|---|
| **Create LWR Apps with Mobile Publisher for Experience Cloud** | **GA** | LWR site; Ent, Perf, Unl, Dev | BYO LWR site로 브랜드 mobile 앱. |
| **Preview Your Experience Cloud LWR Site as an App with Publisher Playground** | **Beta** | Publisher Playground 앱 v13.000+ + MP Exp Cloud 앱 v13.000+ | 구매 전 LWR site를 앱으로 preview. |
| **Android Experience Cloud Apps Now Require Android 9 or Later** | GA | Aura + LWR; Ent, Perf, Unl, Dev | v12.6+는 Android 9 필요; Android 8 미지원. |
| **Conceal Sensitive Information When Your Experience Cloud App Is in the Background** | GA | MP Exp Cloud 앱 v12.6+; Ent, Perf, Unl | Snapshot Prevention(splash/blank 화면), 기본 활성화. |
| **Protect Your Experience Cloud App from Reverse Engineering** | GA | MP Exp Cloud 앱 v13.000+; Ent, Perf, Unl | Enhanced Mobile App Security를 통한 code obfuscation(Android) + string obfuscation(iOS). |
| **Secure Your Experience Cloud iOS App with Two New Enhanced Mobile App Security Policies** | GA | MP Exp Cloud 앱 v13.000+; Ent, Perf, Unl. Log Security Policy Evaluation Result는 Platform Events 라이선스 필요 | Log Security Policy Evaluation Result + Log Out User After Device Restart(이제 iOS도). |
| **Set Up Marketing Cloud Notifications on Experience Cloud Android Apps More Simply** | GA | — | Firebase 정보를 Marketing Cloud notification에 재사용. |
| **Configure Mobile Publisher Android Push Notifications with Only Two Firebase Files** | GA | — | Firebase config 파일 + Admin SDK private key만 필요. |
| **Experience Cloud App Version Numbering Has Changed** | GA | v13.000+ | 소수점 3자리; minor release당 +0.010. |

---

## 관련 노트

- [[Winter '25]] — Winter '25 허브
- [[Winter '25/Development]] — Apex·LWC·API 개발자 항목 형제 spoke
- [[Winter '25/Release Updates]] — Release Update 강제 타이밍 형제 spoke
