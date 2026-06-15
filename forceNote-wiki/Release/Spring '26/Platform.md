---
tags: [release, spring_26, platform]
source: salesforce_spring26_release_notes.pdf (Salesforce Spring '26 Release Notes, Tier 2)
created: 2026-06-15
aliases: [Spring 26 Platform, 스프링26 플랫폼, Spring '26 Platform, Email Domain Verification mandatory, Connected App creation disabled, Passwordless Passkeys GA, Database Encryption GA, DX Inspector GA, Files Priming GA, Mobile Builder GA, Open Screen Flows URL GA, MuleSoft for Flow GA, Hyperforce 17 regions, Idle Refresh Token TTL 30 days, 스프링26 보안, 스프링26 자동화]
---

# Spring '26 — Platform (Overall · Automation · Customization · Deployment · Hyperforce · Mobile · Security/Identity/Privacy)

> Spring '26(API v66.0) 플랫폼 영역 전수 — GA 13건(Passwordless Passkeys·Database Encryption·DX Inspector·Files Priming·Mobile Builder·Open Screen Flows URL·MuleSoft for Flow 5건 등), Beta 22·Pilot 1·Dev Preview 2·Release Update 11. **이메일 도메인 검증 필수화**, **신규 Connected App 생성 기본 비활성화**, idle refresh token TTL 30일 제한 등 보안 강제 변경 포함.

---

## 개요

이 노트는 [[Spring '26]] 릴리즈의 **플랫폼(Salesforce Overall · Automation · Customization · Deployment · Hyperforce · Mobile · Salesforce Flow · Security/Identity/Privacy)** 영역을 공식 Release Notes PDF에서 전수 추출한 것이다.

- 강제 적용(enforce) 시점이 있는 Release Update는 → [[Spring '26/Release Updates]]도 함께 참조 (단일 권위 출처)
- 개발자(Apex·LWC·API) 변경은 → [[Spring '26/Development]]
- 클라우드별 기능은 → [[Spring '26/Clouds]] · Agentforce는 → [[Spring '26/Agentforce]]

### 도메인별 등급 집계

| 도메인 | 페이지 | GA | Beta | Pilot | Dev Preview | Release Update |
|---|---|---|---|---|---|---|
| Salesforce Overall | 165–186 | 0 | 2 | 0 | 0 | 3 |
| Automation | 339–411 | 8 | 3 | 0 | 0 | 2 |
| Customization | 466–490 | 0 | 13 | 1 | 0 | 2 |
| Deployment | 539–540 | 1 | 0 | 0 | 1 | 0 |
| Hyperforce | 723–726 | 0 | 1 | 0 | 0 | 0 |
| Mobile | 1014–1024 | 2 | 3 | 0 | 1 | 0 |
| Salesforce Flow | 1187 | — | — | — | — | — (이동 공지만) |
| Security, Identity & Privacy | 1187–1228 | 2 | 0 | 0 | 0 | 4 |
| **합계** | | **13** | **22** | **1** | **2** | **11** |

> Beta/Pilot/Dev Preview 항목은 (Beta Services Terms 등) 비-GA 약관이 적용된다. 이름 + 1~2줄 요약만 싣는다.

---

## 1. Salesforce Overall (p.165–186)

### 필수화·공지 (보안/인프라)

- **Verify Your Email Domain Ownership [필수화]** (p.167–168) — 이메일 도메인 검증이 **이제 필수(mandatory)**. Salesforce는 검증되지 않은 도메인에서 이메일을 더 이상 발송하지 않는다(개별 이메일 주소가 verified여도 무관). 소유 도메인을 DKIM 키 또는 authorized email domain으로 검증해야 한다. Gmail/Office365 통합, Einstein Activity Capture, @gmail/@hotmail/@outlook 주소, Marketing Cloud는 면제. 적용 시점: **신규 도메인은 2026-02-25 이후 즉시**, **샌드박스 allowlisted 도메인 2026-04-14부터**, **프로덕션 2026-05-04부터**. Where: Lightning Experience + Salesforce Classic 전 에디션(Salesforce Free Suite·Database.com 제외).
- **Prepare for Shorter Certificate Lifespans [공지]** (p.169) — CA/Browser Forum이 TLS 인증서 최대 수명을 **398일 → 200일(2026-03-15) → 100일(2027-03-15) → 47일(2029-03-15)**로 단축. Salesforce는 public certificate rotation 공지를 중단할 예정. Metadata API의 Certificate 타입으로 갱신 자동화 가능.
- **Get Ready for IPv6 [공지]** (p.170) — Salesforce가 IPv6 지원 작업 중. IP allowlist에 IPv6 주소 포함 준비. 현재 IPv6는 Experience Cloud CDN만 지원, Government Cloud orgs부터 단계적 롤아웃. **IP allowlist는 IPv4 또는 IPv6 중 하나만 포함 가능(혼합 불가)**.
- **Update Your mTLS Certificates [공지]** (p.170–171) — Google Chrome이 publicly trusted 인증서를 TLS server authentication 전용으로 제한. Chrome Root Program Policy v1.7이 dual-use 인증서를 차단하며 **정책 변경 시점은 2027-03-15**. mTLS용 인증서 + Public Root CA가 Chrome Trusted Root List에 있으면 별도 인증서 계층으로 전환해야 한다.

### 접근성 (Release Update 3건 포함)

- **Styling Change to Highlighted and Selected Content [접근성 변경]** (p.173) — WCAG 1.4.11 충족을 위해 Lightning UI의 highlighted/selected 콘텐츠가 이제 user agent(브라우저/디바이스) 스타일을 사용, color contrast ratio를 user agent가 결정.
- **Styling Change to Read-Only Checkboxes [접근성 변경]** (p.173) — read-only 체크박스가 더 이상 `disabled` 속성을 지정하지 않아 스크린리더가 상태·값을 읽음. hover text "True"/"False" 표시. Aura 컴포넌트 레코드 페이지(Campaign·Task 등)는 기존 회색 테두리 유지(LWC 사용 레코드 페이지에 적용).
- **Enable Accessibility Enhancements for Page Headers and Modal Windows When Zoom Is Greater Than 200% (Release Update)** (p.173–174) — 고배율(200%+)에서 page headers·modal windows 동작 적응(WCAG 2.2 Resize and Reflow). **Summer '26 enforce**.
- **Enable Accessibility Enhancements for Cards, Docked Containers, Menu Lists, and Panels (Release Update)** (p.174) — 위 "Page Headers and Modal Windows" release update에 의존(먼저 활성화 필요). 1280px·400%에서 header 콘텐츠가 잘리지 않고 다음 줄로 wrap. **Winter '27 enforce**.
- **Enable Accessibility Enhancements for Date Pickers, Popovers, Bottom Utility Bars, Record Headers (Release Update)** (p.175) — 고배율에서 date pickers·popovers·bottom utility bars·record headers 동작 적응. "Page Headers and Modal Windows" release update에 의존. **Summer '26 enforce**.

### Salesforce Go · 사용자/직원

- **Elevate Your Salesforce Go Experience with Smarter Filters and Enhanced Search [개선]** (p.171–172) — Go 홈페이지 섹션 재배열·제거, cloud 필터 시 subvertical 필터 추가, enhanced search로 동일 이름 feature 구별. Who: 보기 = View Setup and Configuration, 켜기 = Customize Application.
- **Capture Employee Details for Unified Employee License Holders [개선]** (p.172) — Unified Employee 라이선스 보유 직원을 employee user로 지정, employee status·number 등 캡처. How: Person Account 생성 → Employee2 레코드 연결 → User 페이지에서 Enable Employee User. Where: Enterprise·Performance·Unlimited.

### Digital Wallet / 소비 추적 (개선)

- **Track Your Data 360 Flex Credits Consumption in Digital Wallet** (p.175–176) — Data 360 Services Credits → Flex Credits 이동 시 Data 360·Agentforce 공용 단일 fungible 크레딧 풀, volume-based multipliers 제공. **Volume-Based Multipliers 기능은 영어 외 언어에서 beta(부분 beta)**.
- **Gain Business-Specific Insights with Digital Wallet Custom Consumption Tags** (p.176) — custom consumption tags로 department·cost center 등 카테고리별 추적. When: 2026-03-03부터 staggered.
- **Track Your MuleSoft Automation Credits 3.0 in Digital Wallet** (p.176–177) — MuleSoft Automation Credits 3.0 일·월 소비 추적 + custom notifications.
- **Monitor Data 360 Profiles with Digital Wallet** (p.177) — 프로덕션 Data 360 profiles 일별 소비 모니터링.
- **Track Your Service Cloud Automated Asset Discovery Consumption in Digital Wallet** (p.177) — CMDB 자동 발견 asset 소비 추적(MAX aggregation method).

> 위 Digital Wallet 항목 공통 Where: Lightning Experience (Enterprise·Unlimited). Who: View Consumption 권한.

### Archive App · 데이터 마이그레이션

- **Expand Data Residency Options in Japan and India with Hyperforce [개선]** (p.178) — **Archive App이 일본·인도 Hyperforce에서 이용 가능**. 신규 고객이 로컬 데이터 저장으로 residency 충족, OAuth 2.0 flow 요구사항 제거로 온보딩 간소화.
- **Migrate to the Archive App for Enhanced Infrastructure [개선]** (p.178–179) — Archive Managed Package → Archive app 전환. 2단계 마이그레이션(자동 준비 + zero downtime cutover), cutover 후 **30일 grace period**.
- **Anonymize Archived PII - for Compliance (Beta)** (p.179) — archived 레코드 내 PII를 익명화하여 RTBF 요청·데이터 보존 의무 준수. sensitive 필드를 non-identifiable placeholder로 대체.
- **Import Data from Your Local Drive [개선]** (p.179) — 로컬 드라이브에서 직접 데이터 import(데이터 전용).

### Salesforce Foundations · Data Pipelines · Scheduler

- **Create Audience Segments and Send Emails Directly from List Views (Salesforce Foundations) [개선]** (p.180) — Lead·Contact 리스트에서 audience segment 정의, Send Email 클릭 시 자동 생성.
- **Automate Your Outreach with a Lighter, Faster Email Builder App (Salesforce Foundations) [신규]** (p.180) — 새 **Email Builder Lite**로 contacts·leads에 batch email 생성·발송. ready-made 레이아웃 라이브러리 또는 component-based authoring, CMS Content Workspace 자동 저장. How: Setup → Salesforce Foundations → Email Builder Lite for Sales 활성화.
- **Gain Deeper, More Intuitive Insights from Your Marketing Data with Tableau in the Marketing App (Salesforce Foundations) [개선]** (p.181) — Foundations marketing dashboards에 Tableau 시각화(Performance Tab) 추가. When: early December부터.
- **Securely Connect Your Private Redshift Data to CRM Analytics (Salesforce Data Pipelines) [신규]** (p.181–182) — private Amazon Redshift 데이터를 Data Pipelines에 통합(VPC). Salesforce Private Connect 필요.
- **Use OAuth Security with Your Microsoft Azure SQL Database Connection (Salesforce Data Pipelines) [개선]** (p.182) — Azure SQL Database에 OAuth 2.0 인증, 별도 external authentication provider setup 불필요.
- **Upgrade to OAuth Security for Your Salesforce External Connections (Salesforce Data Pipelines) [변경]** (p.182–183) — Salesforce external connector에 OAuth 2.0 인증. **SOAP `login()` API는 v64 이후 미지원**. Winter '27 전까지 모든 기존 Salesforce external connection을 OAuth로 업그레이드 필요.
- **Accelerate Data Updates Using Unique IDs for External Objects (Salesforce Data Pipelines) [신규]** (p.183) — external object 필드를 unique ID(primary key)로 지정, 변경된 레코드만 처리(20억 행 중 변경 50만 레코드만). When: 2026-02부터.
- **Run Salesforce Scheduler Flows More Efficiently in Lightning Web Runtime (LWR) Sites [개선]** (p.184) — **모든 Salesforce Scheduler flow component가 이제 LWR 호환 LWC로 제공**(이전엔 일부 Aura).
- **Add More Service Resources to Appointments (Salesforce Scheduler) [개선]** (p.184–185) — 단일 appointment에 최대 **20개 mandatory service resource** 추가(tribunal·court hearing·panel review 등).
- **Easily View Waitlist Participants With a Flat List (Salesforce Scheduler) [개선]** (p.185) — 대형 waitlist를 check-in time 순 단일 평면 리스트로 관리.
- **Aura Components in Salesforce Scheduler Flows Are Scheduled for Retirement [Retirement]** (p.185) — **2027-02-14 retirement**, LWR 사이트 전환 권장.
- **Other Changes to Salesforce Scheduler [변경]** (p.185–186) — Connect REST API request body: Waitlist Participants Input의 `position`이 이제 waitlist의 모든 값 지원.

> Scheduler 공통 Where: Lightning Experience (Enterprise·Unlimited, Salesforce Scheduler 활성화).

### Trust Site

- **Personalized Trust Is Now Salesforce My Trust Center (Beta)** (p.186) — 인증된 서비스 health 정보 접근, notifications 구독, 1년 incident·maintenance history, org location·MyDomain 정보. public Status site가 Heroku·Spiff 지원. (my.trust.salesforce.com·Status.salesforce.com)

---

## 2. Automation (p.339–411)

### 2.1 Flow Builder (p.342–351)

- **Get More Accurate Draft Flows with AI (Generally Available)** (p.342–343) — Agentforce가 비즈니스 요구사항을 task로 분해해 record-triggered/schedule-triggered flow를 더 정확히 생성. **generative AI 크레딧 미소비**. How: Data 360 provision·enable → Einstein generative AI 켜기 → Flow Builder "Let AI Help You Build" → Draft with AI. Where: Lightning Experience (Essentials·Pro Suite·Professional·Enterprise·Performance·Unlimited·Developer + Foundations/Agentforce 1).
- **Evolve Flows Iteratively with Agentforce [개선]** (p.343–344) — 자연어로 기존 record/schedule-triggered flow 개선. generative AI 크레딧 미소비. 예시 프롬프트(PDF p.343–344 verbatim):
  > "Add a decision element to check if the opportunity stage is Closed Won"
  > "Remove the loop element that processes inactive accounts"
  > "Add a fault path to handle errors in the Create Records element"
- **Simplify Your Flow Builder Layout by Collapsing Branching Elements [개선]** (p.344–345) — Wait·Decision·Loop·Path Experiment·Async Actions 분기 요소 collapse/expand, 브라우저 로컬 자동 저장.
- **Navigate Large Flows Faster by Collapsing or Expanding All Elements [개선]** (p.345–346) — 모든 multi-path 요소 1클릭 collapse/expand. 키보드 단축키(PDF p.346 verbatim — Collapse·Expand 둘 다 `2`로 기재됨):
  - Collapse all: `Ctrl+Alt+2` (Windows) / `Cmd+Option+2` (MacOS)
  - Expand all: `Ctrl+Alt+2` (Windows) / `Cmd+Option+2` (MacOS)
- **Set Up the Agentforce Panel Without Admin Configuration [개선]** (p.347) — admin 설정 없이 Agentforce 패널 전환·flow 생성/요약/evolve. generative AI 크레딧 미소비. Who: Agentforce 활성화 + AgentforceEmployeeAgent 또는 AIEmployeeAgents org 권한.
- **View Subflow Input and Output Variable Descriptions More Easily [개선]** (p.348–349) — subflow output variable infobubble가 custom description 표시, input resource description도 활성화 없이 조회.
- **View Action Input Descriptions More Easily [개선]** (p.350) — action input variable infobubble로 description 조회.
- **Navigate Flow Builder Faster with Enhanced Scrolling [개선]** (p.351) — 마우스 스크롤·트랙패드·키보드 화살표·스크롤바로 캔버스 pan.
- **Decision Logic Labels Were Updated for Clarity [변경]** (p.351) — Decision element 라벨이 "Define Manually (Default)"·"Define with AI (Advanced)"로 변경. Where: Enterprise·Performance·Unlimited + Einstein for Sales/Service/Platform add-on.

### 2.2 Screen Flow (p.352–363)

- **Organize Data Table Records with Column Sorting at Runtime [개선]** (p.353–354) — runtime에 column header 클릭 정렬. 정렬은 selected/edited row collection 순서에 영향 없음.
- **Edit Records Directly in the Data Table at Runtime [개선]** (p.355–356) — Data Table을 runtime 레코드 편집 지원하도록 구성, 확정 변경은 `editedRows` output parameter에 저장. 화면 뒤 Update Records element에서 `{!YourDataTableName.editedRows}` 사용.
- **Tailor Screen Flows to Your Audience with Component-Level Styling Overrides [개선]** (p.357) — background/border color·border weight·border radius·text color·buttons 등 커스터마이즈, org/Experience Cloud 기본 테마 override. 지원 컴포넌트: Checkbox, Checkbox Group, Currency, Date, Date/Time, Display Text, Number, Long Text Area, Multi-Select Picklist, Password, Picklist, Radio Button, Repeater, Section, Text.
- **Add Visually Distinct and Accessible Messages to Screen Flows [신규]** (p.358) — 새 **Message** screen component(information·success·error·warning). message type이 색상·아이콘 결정, 스크린리더가 읽음.
- **Visualize and Track Record Progress with Kanban Boards in Screen Flows (Beta)** (p.359–361) — 새 **Kanban Board** component, 레코드를 workflow stage 컬럼의 카드로 표시. read-only(런타임 드래그 불가), column header는 picklist 필드만, object metadata 필드 순서가 컬럼 표시 순서를 결정. (PDF에 UI 스크린샷 있음 — 본 wiki에는 텍스트 설명만)
- **Preview Files Natively in Screen Flows [신규]** (p.362) — 새 **File Preview** screen component, 다운로드 없이 화면 내 파일 미리보기(Content Document ID 참조). When: Winter '26 도입.
- **Find and Select Flow Resources More Easily in Screen Flows [개선]** (p.362) — screen element로 enhanced resource selection 확장(그룹화·라벨·tooltip·중첩 검색).
- **Open Screen Flows in Lightning Experience with a URL (Generally Available)** (p.363) — 새 표준 URL 형식으로 screen flow를 Lightning Experience·console app에서 실행. Cosmos 테마·flow local actions 지원. URL 형식(PDF p.363 verbatim):

```
/lightning/flow/YourFlowNameHere
/lightning/flow/YourFlowNameHere/versionId
?flow__variableIdHere=value
/lightning/flow/YourFlowNameHere?flow__variableIdHereID={!Case.CaseNumber}
/lightning/flow/YourFlowNameHere?flow__varUserFirst={!$User.FirstName}&flow__varUserLast={!$User.LastName}
```

### 2.3 Flow for Marketing Cloud (p.363–372)

- **Automate Marketing Cloud Engagement Emails from Flow Builder [신규]** (p.366) — Send Marketing Cloud Engagement Email action.
- **Ensure Recipients Don't Get Duplicate Messages [개선]** (p.366–367) — contact point selection rules.
- **Send Email Messages Using Activation Data [개선]** (p.367) — activation-triggered flow에서 `$ActivationData` 변수 사용.
- **Run Segment-Triggered Flows at The Right Time with More Scheduling Options [개선]** (p.367–368) — Hourly·Daily on Weekdays·Weekly·Monthly·Yearly.
- **Get More Targeted Segments in Segment-Triggered Flows [개선]** (p.368) — Individual DMO·Engagement 레코드 기반 세그먼트.
- **Test Multiple Records in Segment-Triggered Flows in Debug [개선]** (p.369) — 동시 최대 10 레코드 테스트.
- **Trigger Automation Event-Triggered Flows When CRM Records Change [개선]** (p.369) — prospect/lead/contact 또는 관련 레코드 변경 시 트리거.
- **Stay Informed About Path Experiment Outcomes [개선]** (p.370) — path experiment 완료 시 in-app 알림.
- **View Path Comparison Analytics in Path Experiment Element [개선]** (p.370) — Analytics 탭.
- **Control Path Selection When Debugging Path Experiments [개선]** (p.371) — randomize 또는 manual winning path 선택.
- **View Path Experiment History [개선]** (p.371–372) — History 탭.
- **Trace Individual Paths Through Flows with View Flow Run for Individual [개선]** (p.372) — 개별 실행 경로 조회.
- **Personalize and Debug On-Demand Flows with Apex [개선]** (p.372–373) — Apex로 on-demand flow 개인화.
- **Remove Individuals from Flows Externally via API [개선]** (p.373) — REST API endpoint로 flow exit.

### 2.4 Flow for Data 360 (p.373–375)

- **Send Mass Notifications or Wait for Events with Asynchronous Broadcast Flows [개선]** (p.374) — broadcast flow를 Async 실행, Wait element 추가.
- **Use Decisions, Add Exit Rules, and More with Enhancements to Activation-Triggered Flows [개선]** (p.374–375) — Decision element·exit/reentry conditions·pause·Transform 5단계 매핑. **Can Rejoin Flow 값: Always(기본)·After completion·Never.**
- **Use Flows with Data 360 Licenses and Increased Rate Limits [개선]** (p.375) — Data 360 라이선스로 segment/automation event/on-demand flow 사용, **시간당 최대 1,500만 actions/org**.
- **Label for Custom Real-Time Data Graph Event Was Changed [변경]** (p.375) — "Custom Real-Time Data Graph Event" → "Real-Time Data Graph Record Change".

### 2.5 Flow Testing and Debugging (p.376–377)

- **Retain Debug Configurations Within Flow Editing Sessions [개선]** (p.376) — flow 저장 시 debug 구성 유지, Reset Debug Settings로 수동 초기화.
- **Assign Flow Tests to Specific Flow Versions for More Control [개선]** (p.376) — Spring '26부터 동일 테스트를 여러 flow 버전에 연결.
- **Test Record-Triggered and Autolaunched Flows with Isolated Test Data [개선]** (p.377) — Apex Test Setup으로 isolated test data(record-triggered·autolaunched flow만). When: 2026-04부터.

### 2.6 Flow Runtime — API v66.0 변경 (p.378)

**Flow and Process Run-Time Changes in API Version 66.0 [변경/versioned]** — API v66.0+ flow/process에만 적용:

- **Enforce No-Argument Constructor on Apex Classes** — invocableVariable 포함 모든 Apex 클래스의 no-argument constructor 가시성 강제. managed package의 public no-argument constructor는 동일 패키지 코드에서만 가시.
- **Record-Triggered Flows Issue with Non-Insertable Fields Was Fixed** — before-save record-triggered flow가 non-insertable 필드의 writeable 상태 존중. 수정 불가 필드 업데이트 시도 시 `Invalid target field for field update` 에러.

### 2.7 Flow Management (p.379–382)

- **Monitor Flow Performance with View Flow Version Run Analytics [신규]** (p.379–380) — version-level 분석(completion rate·run status·execution data, Tableau dashboard). Where: Marketing Cloud Growth·Advanced (Data 360 element-level logging).
- **Compare Screen Flow Versions to Track Changes More Efficiently [신규]** (p.380–381) — Compare Versions로 두 버전 간 elements·resources·fields·properties·components·styles 변경 추적, direct link 공유.
- **View Flow Usage in the Automation Lightning App [신규]** (p.382) — Usage subtab로 bidirectional 의존성. Who: Manage Flow.

### 2.8 Flow Extensions (p.383–385)

- **Transcribe Spoken Audio with the Convert Base64 Speech To Text action [신규]** (p.383) — Base64 오디오 → 텍스트. autolaunched·record-triggered·event-triggered flow에 추가 가능.
- **Synthesize Speech with the Text To Speech Action (Beta)** (p.384) — 텍스트(최대 500자) → Base64 오디오, `fileOutput` parameter로 파일 출력. REST·Flow·Apex 사용 가능. 입력: input text·voice speed·voice stability·voice ID.
- **Convert Speech to Text in Flow with the Speech To Text Action [신규]** (p.384) — 오디오 파일 → transcript(Content Document ID 사용). 모든 flow type 추가 가능.
- **Navigate to Flows in Lightning Experience from Custom Lightning Components [신규]** (p.385) — Aura `lightning:navigation` 또는 LWC `lightning/navigation`으로 새 Standard Flow PageReference type 네비게이션.

### 2.9 Flow and Process Release Updates (p.385–386)

- **Enforcing No-Argument Constructor on Apex Classes Used for Invocable Action Parameters (Release Update)** (p.385–386) — Summer '26 enforce 예정이었으나 **Spring '26부터 Salesforce가 더 이상 강제하지 않음**(권장 enable). 이전 이름 "Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs". API v66.0부터 invocable action parameter용 Apex 클래스는 visible no-argument constructor 필요(non-packaged=public, packaged=global).
- **Sort Apex Batch Action Results by Request Order (Release Update)** (p.386–387) — Apex batch action 결과를 요청 순서대로 표시. **Summer '26 enforce**.

### 2.10 Flow Approval Processes (p.387–391)

- **Add Approval Submissions to Record Pages Without Custom Buttons [신규]** (p.388) — **Request Approval** component(Lightning App Builder·Experience Builder), `firstApprover`·`submissionComments` input variable. Classic Approval Processes가 아닌 **Flow Approval Processes에서만 작동**.
- **Complete Approval Work Items in Flow Builder While Debugging [개선]** (p.388–389) — 디버깅 중 캔버스에서 approval work item 열기. Who: Manage Flow.
- **View Flow Approval Process Automation Usage in the Approvals Lightning App [신규]** (p.389) — Usage subtab.
- **Debug Specific Segments of Flow Approval Processes [개선]** (p.390) — start/end point 지정.
- **Control Which Flow Approval Process Steps to Run in Debug Mode with Test Output [개선]** (p.390) — "Manually Set Output" → Configure Test Output 탭.
- **Other Changes to Flow Approval Processes [변경]** (p.390–391) — 세션당 1회 input 설정·Reset Debug Settings; "Send approval work item emails only to queue members" 설정; "Use Test Output" 라벨; Orchestration Work Guide 명칭 변경; Decision Logic 라벨.

### 2.11 Flow Orchestration (p.391–394)

- **Create Orchestrations from the Automation Lightning App [신규]** (p.391–392) — Setup 거치지 않고 Orchestrations 탭에서 New.
- **Complete Orchestration Work Items in Flow Builder While Debugging [개선]** (p.392) — interactive step 카드에서 work item 열기.
- **View Orchestration Automation Usage in the Automation Lightning App [신규]** (p.393) — Usage subtab.
- **Debug Specific Segments of Flow Orchestrations [개선]** (p.393) — start/end point.
- **Control Which Orchestration Steps to Run in Debug Mode with Test Output [개선]** (p.393–394) — Configure Test Output 탭.
- **Other Changes to Flow Orchestration [변경]** (p.394–395) — 세션당 1회 input; "Send orchestration work item queue emails only to queue members" 설정; "Use Test Output"; Orchestration Work Guide 명칭; Decision Logic 라벨.

> Approval Processes·Orchestration 공통 Where: Lightning Experience (Enterprise·Performance·Unlimited·Developer; 일부 + all Einstein 1).

### 2.12 Automation Lightning App (p.395–397)

- **See Where Actions Are Used in Agentforce Builder and Prompt Builder (Beta)** (p.395–396) — Action Hub 탭으로 invocable action을 참조하는 Agentforce agent·prompt template 확인, 최근 14일 execution metrics.
- **Set Up and Monitor Flow Logging in One Place [신규]** (p.397) — 새 Flow Logs 탭(Data 360가 flow run metrics 저장).

### 2.13 MuleSoft for Flow: Integration (p.398–409)

> 공통 Where: Salesforce Classic + Lightning Experience (Professional with API access add-on·Performance·Enterprise·Unlimited + MuleSoft for Flow: Integration add-on license + Agentforce 1 editions).

- **Enhance Data Exchange with Newly Added Third-Party Connectors [신규]** (p.399–400) — 신규 third-party connector 목록(PDF p.400 verbatim, (Beta) 표기는 베타 커넥터):

```
Ably Control API (Beta), Ably Platform (Beta), Adobe Analytics, Adobe Experience Platform,
Adobe Target Admin, Adobe Target Profile, Attio (Beta), Automox, Bitbucket, BoldSign (Beta),
Canvas, Community, Deputy, DocSpring Form (Beta), Dropbox Sign, Figma, Files.com (Beta),
Flotiq (Beta), HappyFox Chat (Beta), Instapage (Beta), Iterable, Jira OAuth, Jumpseller (Beta),
Logz.io (Beta), Microsoft Sharepoint, NetBox (Beta), NetLicensing (Beta), Neutrino (Beta),
Nutshell (Beta), OnePageCRM (Beta), Open Science Framework (Beta), Pabbly (Beta), PandaDoc,
Paperform (Beta), Papertrail (Beta), PDF.co (Beta), Plaid, Planview AgilePlace,
Planview ProjectPlace, Postman (Beta), Rally, QuickBooks Online GraphQL, ReadMe (Beta),
Rebrandly (Beta), Shippo (Beta), SYSTRAN, Teamwork (Beta), WireMock (Beta), Workable (Beta),
Yeeflow (Beta), Zoom, Zuva DocAI (Beta)
```

- **Use Third-Party Connectors with Full Support (Generally Available)** (p.401) — 이전 beta였던 connector가 이제 GA(PDF p.401 verbatim): **Bird, Freshservice, Sumo Logic**.
- **Trigger Flows with Third-Party Connector Triggers [신규]** (p.402–403) — External System Change-Triggered flow에서만 third-party connector trigger 사용. trigger 보유 커넥터(p.402 verbatim): Google Calendar, Jamf Pro, HubSpot, Microsoft Outlook, QuickBooks Online.
- **Integrate Flows with External Systems by Using Third-Party Connector Actions [신규]** (p.403) — action 보유 커넥터(p.403 verbatim): 15Five, Asana, BambooHR, Bird, Freshservice, HashiCorp Terraform, HubSpot, Infoblox, Microsoft Azure, Microsoft Entra ID, NetSuite, Notion, Okta, OneLogin, QuickBooks Online, Sumo Logic.
- **Return Records from External Systems by Using Filters [신규]** (p.404) — Microsoft Dynamics 365 Business Central Connector의 Get Records action에 custom filter logic.
- **Limit the Number of Records Returned in a Flow Using QuickBooks Online Connector [개선]** (p.404–405) — Get Records action에 Sort Records 섹션.
- **Use Custom Fields in More Third-Party Connectors [개선]** (p.405) — custom field 매핑 지원 커넥터(p.405 verbatim): Asana, HubSpot, Notion, Zendesk.
- **Generate MuleSoft for Flow: Integration Flows with AI Pre-Built Templates (Generally Available)** (p.406) — Agentforce가 curated prompt 기반 통합 자동화 생성. Prereq: 유효 연결·Setup에서 generative AI 켜기·Data 360 provision·enable.
- **Create, Evolve, and Summarize MuleSoft for Flow: Integration Flows with Agentforce (Generally Available)** (p.406–407) — 자연어 prompt로 통합 flow 생성·수정·요약, generative AI 크레딧 미소비.
- **Authenticate Third-Party Connector Connections with Named Credentials (Generally Available)** (p.407–408) — Integrations 탭에서 기존 named credential 재사용. FIPS 준수상 **Government Cloud에서 미제공 커넥터**(p.408 verbatim): Abstract Email Validator, Abstract Phone Validator, Alfresco, Anthropic, Cisco Meraki, Kaseya VSA, Pluralsight, Salesforce Commerce Cloud, SurveyMonkey (그리고 모든 Beta 커넥터).
- **Extend Automation Capabilities with Binary File Actions (Generally Available)** (p.408–409) — 최대 **15MB binary file** 전송(ContentDocument로 임시 저장). 지원 커넥터(p.408 verbatim): Jira, Jira OAuth, Salesforce.

### 2.14 MuleSoft for Flow: IDP (p.409)

- **Extract Data from Digital and Scanned Documents by Using MuleSoft for Flow: IDP (Generally Available)** (p.409) — 비구조·반구조 데이터를 구조화 출력으로 변환, confidence threshold 설정(낮은 신뢰도는 human review로 라우팅). Automation app의 Document Processing 탭에서 관리. Where: + MuleSoft for Flow: IDP add-on license.

### 2.15 Agentforce Supply Chain (p.410–411)

- **Streamline Your Business Processes with Agentforce Supply Chain [신규]** (p.410–411) — Agentforce Supply Chain(구 Regrello) — 자동화 워크플로우로 공급망 비즈니스 프로세스 변환, AI 생성 blueprint·email-integrated work. Salesforce 외부 workspace(추가 비용). When: **2026-02부터**.

---

## 3. Customization (p.466–490)

### 3.1 Setup with Agentforce (Beta) (p.467–471)

모든 하위 항목은 **Beta**(Pilot 1건 포함). Data 360 크레딧을 소비하며 (Beta Services Terms + Non-GA Credit Consumption) 약관이 적용된다.

- **Streamline Administrative Tasks with Setup with Agentforce (Beta)** (p.470–471) — Setup에 AI assistant 통합. When: early January 2026부터. Who: Use Setup with Agentforce + Execute Prompt Template 권한. Where: Enterprise·Performance·Unlimited·Developer + Foundations/Agentforce 1.
- **Chat with the Setup Agent in More Languages (Beta)** (p.468) — 신규 베타 언어: Catalan, Danish, Dutch, Finnish, French, German, Italian, Japanese, Norwegian, Portuguese, Spanish, Swedish (이전 영어만).
- **Open Setup Pages in a Dedicated Tab (Beta)** (p.468) — Setup 페이지가 전용 탭에서 열림.
- **Updated Permission Requirements for Setup with Agentforce (Beta)** (p.468) — Execute Prompt Templates 또는 Customize Application 권한 / Prompt Template User 표준 permission set. Use Setup with Agentforce 권한은 여전히 필수.
- **Get Enhanced Conversation Recommendations in Setup with Agentforce (Beta)** (p.469) — engagement insights로 추천 개선(Data 360 사용).
- **Get Information About Key Org Health and Usage Metrics with Setup with Agentforce (Beta)** (p.469) — Org Health and Usage 대시보드(Security Health Check score·Apex health·login errors).
- **Quickly Create a Salesforce Mobile App and Pages in Setup with Agentforce (Pilot)** (p.469) — Agentforce가 역할·데이터·컴포넌트별 custom mobile app·home page 생성.
- **Open Newly Created Flows in Flow Builder from Setup with Agentforce (Beta)** (p.469) — 생성 flow를 Flow Builder에서 직접 열기.
- **Troubleshoot Access Using the Setup Audit Trail (Beta)** (p.469) — Setup Audit Trail 검토로 접근 변경 원인 분석.
- **Build Data Models Faster with Data Model Management Enhancements (Beta)** (p.469) — Percent·Currency 필드 타입, tabular 포맷, object/field 라벨·API명 독립 업데이트.
- **Explore Setup with Agentforce Capabilities (Beta)** (p.469) — agent 기능 요약("What can you do?").
- **Manage Queues with Setup with Agentforce (Beta)** (p.469–470) — 대화로 queue 생성·관리.
- **Use Both API Names and Labels to Reference Features (Beta)** (p.469) — API명·라벨로 formula·permission set 참조.
- **Reference Users with More Flexibility in Setup with Agentforce (Beta)** (p.470) — email·username·이름·role로 사용자 참조.
- **Troubleshoot External Client App Access in Setup with Agentforce (Beta)** (p.470) — External Client App 접근 확인.

### 3.2 Globalization — Translation Workbench (p.480–483)

- **Export and Import Translated Files with Ease [개선]** (p.480–481) — Translation Workbench export filter(metadata component·date range), invalid record 포함 import 시 valid record import. 이전엔 최대 50 에러만 보고. Who: Manage Translation + Create Documents.
- **Speed Up Custom Label Updates in Translation Workbench [개선]** (p.481) — UI에서 custom label 직접 업데이트.
- **Use Updated State Codes for Picklists [변경]** (p.482) — Canada Yukon(YT), Japan state codes 02(Aomori)·05(Akita)·23(Aichi) 변경(Spring '26 이후 구성 org).
- **Review Updated Label Translations [변경]** (p.482) — Chinese(Simplified·Traditional)·Dutch·Finnish·French·Japanese·Korean·Norwegian·Polish·Slovenian·Thai·Turkish 표준 object/tab/field명 번역 업데이트.
- **Enable ICU Locale Formats (Release Update)** (p.483) — ICU locale가 JDK locale 대체(Winter '20 최초). **Spring '26 enforce 안 됨(수동 enable 권장)**. en_CA는 별도 활성화 필요.

### 3.3 List Views (p.484)

- **List View Edit Limits Are Communicated More Clearly [변경]** (p.484) — LWC 렌더 list view가 200 레코드 초과 선택·편집을 편집 과정 초기에 차단.
- **Use Updated Empty Value Placement in List View Sorting [변경]** (p.484) — 정렬 시 빈 필드(null)를 **최고값**으로 처리. 예: 5,9,null,2 오름차순 → 2,5,9,null (이전엔 null이 최저값).

### 3.4 AppExchange (p.484–485)

- **Configure New Trialforce Login Pages Before Summer '26 [공지]** (p.485) — Summer '26 전 TSO branded login page 구성. **.cloudforce.com 호스트명 retire 예정**. When: Summer '26 deploy 2026-05-15. Where: Salesforce Classic (Developer Edition).

### 3.5 General Setup (p.489–490)

- **Submit Records for Approval by Using the Request Approval Component [신규]** (p.489) — record page에 Request Approval component(autolaunched flow approval process). **Flow Approval Processes에서만**.
- **Button Order Was Updated on User Records [변경]** (p.489) — user record 편집 시 Cancel 버튼이 먼저 표시.
- **Update Apex Code and Flows for Changed Sharing Recalculation Behavior (Release Update)** (p.490) — 일부 sharing recalculation을 비동기 처리. 즉시 share 업데이트에 의존하는 Apex·flow는 깨질 수 있음. Spring '26부터 available, **Spring '27 enforce**.

### 3.6 DX Inspector (p.490)

- **Track Development Activities in Your Org with DX Inspector Activity History [신규]** (p.490) — commits·deployments·reviews timeline, activity name·type·status·date 검색. When: 2026-04-22부터 rolling. Who: Customize Application. Where: 모든 샌드박스·scratch org.

---

## 4. Deployment (p.539–540)

- **Streamline Metadata and Data Deployment with DX Inspector (Generally Available)** (p.540) — metadata·configuration 데이터 변경을 단일 orchestration으로 target org에 이동. 의존성 스캔으로 배포 실패 방지. When: 2026-04-22부터. Who: source·target org에서 Customize Application. How: DX Inspector Panel → Change Management 탭. Where: 모든 샌드박스·scratch org (Professional·Enterprise·Performance·Unlimited·Developer).
- **Accelerate DX Inspector Data Deployment with SOQL (Developer Preview)** (p.539–540) — DX Inspector에서 SELECT 쿼리로 배포 레코드 정의(filter 대비 빠름). **SOQL filtering은 developer preview**(GA 아님). When: 2026-02-01부터.

---

## 5. Hyperforce (p.723–726)

### 5.1 Access Salesforce in More Regions (p.723–725)

- **Access Salesforce in More Regions with Hyperforce [개선]** — Hyperforce가 **17개국**에서 이용 가능. Salesforce Customer 360 application suite(Sales Cloud·Service Cloud·B2B Commerce·Platform·Industries clouds) 제공 국가: Australia, Brazil, Canada, France, Germany, India, Indonesia, Israel, Italy, Japan, Singapore, South Korea, Sweden, Switzerland, UAE, UK, US.

**신규 region 가용성 매트릭스 (p.724–725, PDF 원문 방향 = row 제품 / col 속성):**

| 제품 (Cloud) | Now available in | Also available in |
|---|---|---|
| Data 360 (Agentforce·Data 360·Einstein) | Italy, Sweden | Australia, Brazil, Canada, France, Germany, India, Indonesia, Japan, Singapore, South Korea, Switzerland, UAE, UK, US |
| Marketing Cloud (MC Advanced·MC Growth) | Italy, Sweden | Australia, Brazil, Canada, France, Germany, India, Indonesia, Japan, Singapore, South Korea, Switzerland, UAE, UK, US |
| MuleSoft | (select features) US Cloud, EU Cloud, Canada Cloud, Japan Cloud | — |
| Platform — Salesforce Advanced Cross-Region Continuity¹ | Japan (Hyperforce commercial customers) | United States (Hyperforce commercial customers) |
| Platform — Shield Platform Encryption Database Encryption | all commercial Hyperforce regions | — |
| Tableau — Tableau Cloud | South Korea | Australia, Canada, Germany, India, Indonesia, Japan, Singapore, Switzerland, UK, US |

¹ 구 Salesforce Out of Region Disaster Recovery. (PDF에 5열 표가 있으나 pdftotext가 Description 컬럼을 풀어 흩어버려, 위 표는 Product + Available In 셀만 재구성. 셀 값은 p.724–725 원문 그대로.)

### 5.2 Hyperforce 기타 변경 (p.725–726)

- **Find Hard-Coded References Using the Updated Hyperforce Assistant Process [변경]** (p.725–726) — Hyperforce Assistant step 1의 자동 체크가 교체됨(underlying tool 업데이트). Salesforce Labs Org Check 패키지 설치·실행으로 hard-coded reference 확인.
- **Hyperforce Public IP Ranges Now Include Inbound Addresses [변경]** (p.726) — Hyperforce public IP 범위에 **inbound 주소** 추가(이전엔 outbound만). mTLS 권장하나 allowlist 필요 고객용 JSON 제공: `https://ip-ranges.salesforce.com/ip-ranges.json`. Sales·Service·Industries·Tableau·MuleSoft Anypoint 지원(email·Marketing Cloud·Commerce Cloud·Slack 제외).
- **Prepare for IPv6 in Hyperforce Public IPs [공지]** (p.726) — IP allowlist 사용 시 IPv6 주소 포함 준비.
- **Scan Files for Malware (Beta)** (p.726) — Salesforce Files의 파일 malware 스캔. 대부분 신규 파일은 업로드 시, 기존 파일은 다운로드 시 스캔. When: Spring '26부터 rolling. (Hyperforce 호스팅)

---

## 6. Mobile (p.1014–1024)

### 6.1 Salesforce Mobile App (p.1015–1020)

- **Salesforce Mobile App Requirements Have Changed [변경]** (p.1015–1017) — Mobile Platform Requirements: **Android 11.0+ (Android WebView 90.0+), iOS 17.0+**. 테스트 디바이스 목록 갱신(Android: Pixel 10/9/7·Galaxy S24~S20 시리즈·Galaxy Tab S6/S7·Tab A 8"; iOS: iPhone 17 Pro/Pro Max~iPhone SE·iPad Pro 10.5–12.9"·iPad Air 3rd Gen·iPad Mini 5th Gen 등).
- **Complete Tasks Directly from Custom Phone Notifications (Beta)** (p.1017) — custom phone notification에서 직접 task 완료(actionable notifications). When: 2026-03부터.
- **Access Record Attachments in the Offline App with Files Priming (Generally Available)** (p.1018) — briefcase prime 시 첨부 파일 포함. **Files Priming이 이전 beta에서 GA**. How: Setup → Briefcase Builder → object rule에서 Enable file attachments. Where: Salesforce Mobile App Plus (iOS·Android). Who: Salesforce Mobile App Plus 라이선스 + Mobile Offline for Salesforce Mobile App Plus 권한.
- **Easily Configure Offline App Landing Pages with Mobile Builder (Generally Available)** (p.1018) — code 없이 offline landing page 커스터마이즈. **Mobile Builder가 Spring '24 beta에서 GA**. Where: Salesforce Mobile App Plus. Who: + Mobile Offline 권한.
- **Log In to the Salesforce Mobile App with Email by Default [변경]** (p.1018–1019) — email 기반 인증 기본값. When: iOS 2026-03-23·Android 2026-04-06 (프로덕션 org만).
- **Log In Faster with Single Sign-On [개선]** (p.1019) — email 주소 로그인 시 SSO 지원. When: iOS 2026-01-12·Android 2026-02-23 (프로덕션 org만).
- **Elevate In-Person Meetings with Mobile AI Transcription [신규]** (p.1019) — AI 기반 모바일 transcription(Einstein Conversation Insights). When: iOS 2026-03-25·Android 2026-04-06.
- **Access React Apps Directly Within the Salesforce Mobile App (Beta)** (p.1020) — 플랫폼 배포 React app이 mobile App Launcher에 자동 노출. When: 2026-04-15부터.

### 6.2 Mobile Publisher (p.1021–1022)

- **Experience a Consistent URL Handling Journey Across Platforms [변경]** (p.1021–1022) — Android·iOS URL 처리 로직 통일(Intercepted Login URLs → In-App interception → Improved Path Validation precedence). Where: Mobile Publisher for Experience Cloud apps.
- **Access Near Field Communication (NFC) Capabilities on Mobile Publisher Apps [신규]** (p.1022) — NFC로 tag read·erase·write. How: Setup → Mobile Publisher → [app] → Near Field Communication 권한 → LWC 생성 → Experience Builder 추가.

### 6.3 General Mobile Updates (p.1022–1024)

- **Mobile MCP Tools Now Available on Salesforce DX MCP Server (Beta)** (p.1022–1023) — Mobile MCP tools로 Mobile Offline 디자인 패턴·device-native LWC 생성(Salesforce MCP DX Server Beta v0.21.2). toolset: `mobile`·`mobile-core`.
- **New Version of Test Harness Now Available [개선]** (p.1023) — Android용 Test Harness가 Android 15(API level 35)+ edge-to-edge 지원.
- **Generate Salesforce Mobile Native Apps with MAGE (Developer Preview)** (p.1024) — Mobile App Generation Ecosystem(MAGE) — MCP 기반 pro-code 도구로 iOS·Android project scaffold 생성(Salesforce Mobile SDK·Agentforce Mobile SDK 통합).

---

## 7. Salesforce Flow (p.1187)

- **Salesforce Flow Release Notes Have Moved [공지]** (p.1187) — Salesforce Flow release note가 이제 release note의 **Automation 섹션**(위 §2)에 위치. 별도 콘텐츠 없음.

---

## 8. Security, Identity, and Privacy (p.1187–1228)

### 8.1 Backup & Recover Next (p.1188)

- **Protect and Recover Your Data with Backup & Recover Next [신규]** (p.1188) — Salesforce Backup & Recover Next가 이제 **네이티브 앱**, 일별 자동 백업. When: Spring '26부터 rolling. Who: GovCloud·Japan 지역.

### 8.2 Domains (p.1189–1191)

- **Update References to Legacy Host Names (Release Update)** (p.1189) — legacy(non-enhanced) host name redirection 종료(Spring '25 최초). **Spring '26 enforce**.
- **Replace Instanced URLs in API Traffic [변경]** (p.1190) — API traffic의 instanced URL을 My Domain login URL로 교체. **Winter '27에 instanced URL 지원 종료**.
- **Switch to a Stable Target Host Name for Your Custom Domain [변경]** (p.1190) — third-party/CDN serving custom domain의 target host name을 My Domain login URL로.
- **A Warning Was Added for Potential Custom Domain Disruption [개선]** (p.1191) — Salesforce Edge Network 이동 시 disruption 경고를 My Domain Setup에 추가.
- **Regional Edge Routing Label Was Changed [변경]** (p.1191) — Edge Network regional method 라벨에 region 이름 포함. Who: Japan Hyperforce instance.

### 8.3 Identity and Access Management (p.1192–1214)

핵심 보안 강제 변경:

- **Creation of New Connected Apps Is Disabled by Default [변경/보안]** (p.1195) — **모든 Salesforce org에서 신규 connected app 생성이 기본 비활성화**. 기존 connected app·패키지 배포 앱은 영향 없음, external client app 사용 권장. How: "Allow creation of connected apps" 설정이 제거됨 — 활성화하려면 Salesforce Customer Support에 연락. Where: Essentials·Professional·Enterprise·Performance·Unlimited·Developer.
- **Device Activation Is Required for Single Sign-On [변경/보안]** (p.1198–1199) — SSO provider가 Salesforce 보안 기준 미충족 시 device activation 요구. When: **2026-01-20부터 phase 1 staggered**. Phase 1 predefined auth provider type(p.1198 verbatim): Apple, Bitbucket, Concur, Facebook, GitHub, Google, Janrain, LinkedIn, Microsoft, Microsoft Access Control Service, MuleSoft, OpenID Connect, Salesforce, Slack, Twitter (X). Custom type은 phase 1 제외. AMR claim 검사, oversized IP range(>16,777,216) 기준 적용.
- **API-Only Users Are Blocked from Bridging into UI Sessions [변경/보안]** (p.1199) — API Only User 권한 사용자가 frontdoor URL(`/services/oauth2/singleaccess`, UI Bridge API)로 UI 세션 bridge 불가. 실패 시 `Bad_OAuth_Token` 에러.
- **Set Up Passwordless Login with Passkeys (Generally Available)** (p.1200) — passkey 기반 passwordless login(Touch ID·Face ID·YubiKey 등). **Spring '26 beta에서 2026-04 GA**. MFA 요구사항 충족. **내부 사용자만**(Experience Cloud 사용자 제외). How: Identity Verification 페이지에서 enable.

연결 앱 마이그레이션·SAML·OAuth:

- **Configure Canvas Plugin for External Client App [신규]** (p.1195–1196) — external client app framework로 Canvas app 생성.
- **Track Attempts to Use Uninstalled Connected Apps [개선]** (p.1196–1197) — 미설치 connected app의 거부된 시도 추적(Connected Apps OAuth Usage 페이지의 Denied Attempts Due to Usage Restriction 컬럼).
- **New and Updated Security Alerts for OAuth Flows [개선]** (p.1197) — OAuth 2.0 device flow 연결 시 보안 alert 추가.
- **Migrate SAML-Enabled Connected Apps to External Client Apps [개선]** (p.1200) — SAML-enabled connected app을 external client app으로 변환(기존은 read-only). How: App Manager → Migrate to External Client App.
- **Migrate to a Multiple-Configuration SAML Framework (Release Update)** (p.1201–1202) — single-config SAML → multiple-config(login URL 변경·audience attribute 필요·신규 self-signed cert). **Summer '26 enforce**(샌드박스 Summer '24 완료). Where: Enterprise·Unlimited·Developer.
- **Salesforce-Managed X (Formerly Twitter) Authentication Provider Retirement (Release Update)** (p.1202) — Salesforce-managed X app retire, custom X app + consumer key/secret 필요. **Summer '26 enforce**.
- **New LinkedIn Authentication Providers Use LinkedIn API v2 [변경]** (p.1203) — 신규 LinkedIn auth provider가 v2 사용(이전 생성·Salesforce-managed는 v1).
- **Triple DES for SAML Single Sign-On Stops Working in Summer '26 [공지/변경]** (p.1203–1204) — **Summer '26에 Triple DES SAML SSO 중단**, AES 128/256 사용 권장.
- **Sandbox Users with Non-Unique Usernames Can't Be Unfrozen [변경]** (p.1204) — 다른 샌드박스에 username 존재 시 unfreeze 불가(샌드박스만).
- **Create an External Client App in a Scratch Org [신규]** (p.1204) — scratch org에서 local external client app 생성. When: Winter '26 rolling.
- **Verification Method Order Is Changed [변경]** (p.1204–1205) — 신규 precedence: **built-in authenticators → security keys → Salesforce Authenticator → third-party**. 설정 라벨 변경.
- **Retirement of OAuth 2.0 Username-Password Flow for Connected Apps (Release Update)** (p.1205) — **Winter '27에 username-password flow 지원 중단**. web-server flow(PKCE) 또는 client credentials flow 사용.
- **Check Authentication Method Strength with the SAML Assertion Validator [개선]** (p.1206) — SAML Assertion Validator로 AMR·ACR 값 강도 확인.
- **Heading Was Added to Salesforce Login Pages [변경]** (p.1206–1207) — "Salesforce login" heading 추가(login/test.salesforce.com·기본 브랜딩 My Domain·Experience Cloud·mobile app login).
- **Improved Support for IPv6 and Private IPs [변경]** (p.1207) — IPv6 trusted/profile IP range 한도 대폭 증가(**2^99**), private IP(10.0.0.0–10.255.255.255) 제외. IPv4 한도는 여전히 16,777,216.
- **Prepare for Email to Become the Default Login Experience [공지]** (p.1208) — **9월부터** login/test.salesforce.com UI 기본 로그인이 email 기반. My Domain 미영향. Spring '26 초기 미포함.

토큰·인증 강제 변경(보안):

- **Allow OAuth Refresh Tokens Only in Certain IP Ranges [신규/보안]** (p.1208) — refresh token을 정의된 IP range로 제한(Enforce Refresh Token IP Allowlist). When: Winter '26 rolling.
- **Troubleshoot Formatting Issues in SCIM Payloads [개선]** (p.1209) — SCIM 잘못된 payload 시 descriptive 에러. 신규 에러 메시지(PDF p.1209 verbatim):

```json
{
  "message": "Processing/execution error: check the format of your request payload. If you still have issues, contact Support and share this error ID: {error ID}",
  "errorCode": "UNKNOWN_EXCEPTION"
}
```

  올바른 PATCH 예(p.1209 verbatim, `https://mycompany.my.salesforce.com/services/scim/v2/Users/<userid>`):

```json
{
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:PatchOp"],
  "Operations": [{ "op": "replace", "value": { "nickName": "user2" } }]
}
```

  (잘못된 형식 `"value": [ { "nickName": "user2"}]` → 올바른 형식 `"value": { "nickName": "user2"}`)

- **Limit the Idle Refresh Token TTL (Time-to-Live) to 30 Days [신규/보안]** (p.1210–1212) — idle refresh token TTL을 **30일로 제한**(sliding window). How: "Limit Idle Refresh Token Time-to-Live (TTL) to 30 Days" 켜기.

  **Refresh Token Policy별 동작 변경 (p.1211–1212, PDF row = policy / col = Behavior Changes):**

  | Refresh Token Policy | idle TTL 적용 시 동작 |
  |---|---|
  | Refresh token is valid until revoked | 무효화 → UI에서 hidden, "Expire refresh token if not used for specific time"(30일)로 변경. metadata 자동 업데이트 안 됨 |
  | Immediately expire refresh token | validity period 사용. 30일 초과 시 idle TTL 적용(예: 1년 설정 → idle 30일 후 만료, 지속 사용 시 최대 1년) |
  | Expire refresh token after specific time (ECA) / after {number}{unit} (connected app) | 동일 동작 |
  | Expire refresh token if not used for specific time (ECA) / if not used for {number}{unit} (connected app) | 이미 sliding window idle TTL. validity period가 30일 초과 불가(초과 시 저장 에러) |

- **Lock OAuth Security Controls [신규/보안]** (p.1212) — PKCE·refresh token rotation 등 OAuth 보안 control 잠금. When: 2026-04부터(late April UI 라벨 업데이트). Partner Application은 필수 lock, lock 후 Salesforce Customer Support만 변경.
- **Stay Informed About MFA Changes with an In-App Reminder [신규]** (p.1213) — MFA 비준수 org에 in-app 배너. When: 2026-05부터 rolling(MFA 보안 control 2026-06 enforce). 배너 조건: SSO 구성·MFA 설정 비활성화·Waive MFA 권한·phishing-resistant MFA 미활성화.
- **Prepare for Step-Up Authentication with an In-App Prompt [신규]** (p.1213–1214) — 민감 작업(report export 등) 시 step-up auth prompt. When: 2026-05부터 rolling(step-up 요구사항 2026-06부터, report export 시작). 필요 method: Salesforce MFA·verified phone·verified email.

### 8.4 Named Credentials (p.1214–1215)

- **Extend Your Custom Apps with the Ability to Update and Delete Named Credentials from Apex [신규]** (p.1214–1215) — Apex로 named credential·external credential·external auth identity provider 업데이트·삭제. endpoint URL 변경 시 Enabled for Callouts 자동 off. **API v66.0+**. 신규 Apex 메서드(PDF p.1215 verbatim):

```
deleteExternalAuthIdentityProvider
updateExternalAuthIdentityProvider
deleteExternalCredential
updateExternalCredential
deleteNamedCredential
updateNamedCredential
```

- **Enhanced Security for Named Credentials in Managed Packages [변경/보안]** (p.1215) — managed package에 추가된 named credential이 **developer-controlled, 업데이트 불가**(subscriber 편집 불가). When: 2026-02부터 rolling. (API v66.0+)

### 8.5 Health Check (p.1215–1217)

- **New Configurable Settings Added to Health Check [개선]** (p.1216) — 7개 신규 구성 가능 보안 설정(MFA status·SAML enablement·session management 포함). When: 3월부터 staggered.
- **Stay Secure with Proactive Health Check Notifications [신규]** (p.1216) — Health Check score 하락 시 weekly 알림. **2026-04-15부터 프로덕션 org System Admins에 기본 활성화**(GovCloud 미지원).
- **New Signals for Health Check Scores [변경]** (p.1217) — 신규 7개 signal(p.1217 verbatim): MFA Enabled, SAML Enabled, Allow access to External Client App consumer secrets via Metadata API, Terminate all of a user's sessions when an admin resets that user's password, Lock sessions to the IP address from which they originated, Percentage of active internal users with System Administrator profile, Number of trusted IP ranges.

> Health Check 공통 Where: Lightning Experience (Enterprise·Performance·Unlimited·Developer).

### 8.6 Privacy Center (p.1217–1219)

- **Delete Records in Your Org and Data 360 with Privacy Requests [신규]** (p.1218) — RTBF 요청 시 org·Data 360 레코드를 단일 통합 솔루션(Privacy Requests)으로 삭제.
- **Ignore Errors While Processing Records [개선]** (p.1218) — object processing error 무시 옵션.
- **Bypass Automations While Processing Records [개선]** (p.1218) — object/policy 레벨 bypass(trigger·validation 우회).
- **Customize Batch Sizes to Optimize Privacy Policy Jobs [개선]** (p.1218–1219) — batch size 수동 지정(**1–2,000**).

> Privacy Center 공통 Where: Lightning Experience (Enterprise·Performance·Unlimited·Developer).

### 8.7 Salesforce Shield (p.1219–1226)

- **Get Shield Setup Assistants and Usage Insights [개선]** (p.1219) — Shield app에 Data Detect·Field Audit Trail·Event Monitoring·Platform Encryption Setup Assistant.
- **Simplify How Users Access the Shield App [변경]** (p.1219) — Data Detect/Event Monitoring/Platform Encryption 권한 보유 시 기본 Shield app 조회. View Shield App Pages 권한은 다른 접근 없는 사용자만 필요.

**Event Monitoring:**

- **APIEvent Record IDs [변경]** (p.1220) — APIEvent Record 필드가 모든 operation에 record ID + 총 record count 캡처.
- **Automatic Storage for Select Real-Time Events [변경]** (p.1220) — Report·ListView·Login·LoginAs·Logout Event 데이터 저장 기본 활성화.
- **Track Grant Login Access Activity With Login As Event [신규]** (p.1220–1221) — Grant Account Login Access를 Login As event로 추적.
- **Delete Operation Tracking for ApiEvent [변경]** (p.1221) — ApiEvent가 delete operation 추적(Operation 필드 확장).
- **Universal Anomaly Event [신규]** (p.1221–1222) — 다중 도메인 anomaly threat detection event 표준 분류, subtype 필드로 anomaly type 식별.

**Data Detect:**

- **Increase Data Detect Scan Scope and Scale [개선]** (p.1222) — **100 objects, 무제한 fields·historical records** 스캔.
- **Scan for Custom Keywords with Data Detect [신규]** (p.1222) — structured sensitive data와 함께 custom keyword 스캔.
- **Purchase a Standalone License for Data Detect [신규]** (p.1223) — full Shield bundle 없이 Data Detect 단독 라이선스.
- **Access and Run Data Detect Scans and Results with REST APIs [신규]** (p.1223) — 2개 신규 REST API(Retrieve = GET 정책 목록, Scan = POST 정책 스캔 실행).
- **Data Detect Legacy-Managed Package End of Support on February 1, 2026 [Retirement]** (p.1224) — Data Detect Legacy-Managed Package(구 Einstein Data Detect) 지원 **2026-02-01 종료**, 신규 Data Detect app 권장.

**Field Audit Trail:**

- **Enhancements to Field History Tracking [개선]** (p.1224) — Field History Explorer로 tracked field 변경 revert·metadata 다운로드.
- **Increasing the Field Audit Trail Limit Beyond 60 [개선]** (p.1224) — **tracked field 한도 60 → 200**.

**Shield Platform Encryption:**

- **Encrypt Your Entire Database (GA Release)** (p.1225) — **Database Encryption이 전 세계 GA**(Winter '26 배포 시작). 암호화 데이터 sort·filter·reference 가능(기능·성능 trade-off 없음). How: Encryption Settings → Encrypt the Transactional Database 토글. Where: Enterprise·Performance·Unlimited·Developer (**Database Encryption 활성화 Hyperforce cell**).
- **Bring Your Own Key to Data 360 [신규]** (p.1225) — Data 360 customers가 Shield Platform Encryption BYOK 사용. Data 360는 root key만(DEK 생성·wrapping은 Data 360 관리). **PKCS#8 encrypted·Base64 encoded 4096 RSA** key pair.
- **Encrypt Newly Supported Fields with Shield Platform Encryption [개선]** (p.1225–1226) — 신규 암호화 가능 필드: Comments(Business Operations Process Participant·Compliance Control Participant·Compliance Policy Participant·Validation Procedure Participant·Financial Account Participant·Regulation Participant), Case의 Rich Text Area Case Description, Provider Activity Goal Limit의 Source System Identifier.

### 8.8 Security Center (p.1227–1228)

- **Monitor Login Anomaly Events Across Environments [신규]** (p.1227) — Login Anomaly event를 Threat Detection metric·dashboard에 추가. Who: Event Monitoring + Security Center add-on.
- **New Permission Metrics for Comprehensive Monitoring [신규]** (p.1227) — 신규 permission metric(p.1228 verbatim): API Enabled, Exempt Users from Transaction Security Policies(*requires EM license), Manage Agentforce Default Agent, Manage Agent for Setup, Manage AI Agents, ManageDataspaceScope, ManageAccessPolicies, ModifyAllDataGovPolicies, ModifyAccessAllowPolicies, ModifyAccessDenyPolicies. Who: Security Center add-on.
- **Set Alerts at the Child Tenant Level [신규]** (p.1228) — parent·child tenant 전반 alert 설정. Who: Security Center add-on.

### 8.9 Other Security Changes (p.1228)

- **Distinguish Between Blocked and Reported CSP Violations [개선]** (p.1228) — Trusted URL and Browser Policy Violations 리스트에 Impact 필드(Reported/Blocked) 추가.
- **Salesforce Sites Display the Specified Favicon Only [변경]** (p.1228) — Site Favorite Icon 필드 empty 값 지원.

---

## 관련 노트

- [[Spring '26]] — Spring '26 릴리즈 허브
- [[Spring '26/index]] — 폴더 인덱스
- [[Spring '26/Development]] — 개발자(Apex·LWC·API) 영역
- [[Spring '26/Clouds]] — 클라우드별 기능
- [[Spring '26/Agentforce]] — Agentforce 영역
- [[Spring '26/Release Updates]] — enforce 시점 단일 권위 출처
- [[Release MOC]] — 전체 릴리즈 목차
