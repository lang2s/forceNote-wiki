---
tags: [release, summer_25, platform, admin, security, flow, devops, architecture]
api_version: v64.0
release_date: 2025-06
created: 2026-06-15
source: salesforce_release_notes_5-17-2026 (3).pdf (Salesforce Summer '25 Release Notes, Tier 2)
aliases: [Summer '25 Platform, 서머25 플랫폼, Flow Approval Process GA, Autolaunched Screen Actions GA, ICU 로케일 자동 활성화, Hyperforce 하이데라바드, Salesforce Channels Slack]
---

# Summer '25 — Platform (Admin · Security · Automation/Flow · Mobile · DevOps · Architecture · Slack)

> Summer '25(API v64.0)의 플랫폼·설정 기능을 한곳에 모은 spoke. Flow 승인 프로세스/자동 트리거 화면 액션 GA, ICU 로케일 자동 활성화, Shield 데이터베이스 암호화 Beta, Hyperforce 하이데라바드 리전, Salesforce Channels(Slack) 등을 다룬다. 코드성 변경(Apex 클래스·API)은 개발자 spoke로, 강제 적용 시점은 Release Updates spoke로 분리한다.

---

## 개요

이 노트는 **정책·설정(Admin/Setup, Security 정책, Automation/Flow, Mobile, DevOps, Architecture, Slack)** 관점의 Summer '25 변경을 다룬다.

- **상위 허브:** [[Summer '25]] — 전체 릴리즈 요약·주요 신기능
- **개발자(코드·클래스·API) 변경:** [[Summer '25/Development]] — Apex 네임스페이스·LWC·ConnectApi·거버너 한도
- **강제 적용(Release Update) 시점:** [[Summer '25/Release Updates]] — 강제 시점 단일 출처. 본 노트에서 강제성 항목은 한 줄 요약 후 그쪽으로 위임

> **분류 원칙:** 정책·설정 = Platform / 코드·클래스 = Development. 따라서 Apex Crypto AES-GCM, `Auth.UserData`, Apex callout span 같은 코드성 변경은 본 노트에서 "정책 맥락"만 한 줄 언급하고 코드 상세는 [[Summer '25/Development]]에 둔다.

---

## Admin / Setup

### 권한 관리 — "Delivered Idea" 5종 (전부 GA)

IdeaExchange에서 유래한 권한 편집 효율화 기능 5종. 모두 일반 제공(GA)이며 별도 "Generally Available" 라벨은 없다.

| 기능 | 내용 | 위치 |
|---|---|---|
| Update Object Permissions for All Custom Permission Sets or Profiles in One Step | 한 객체의 접근 권한을 모든 커스텀 권한 집합·프로파일에서 동시에 추가/검토/제거. (Lightning Experience, 전 에디션) | Setup → Object Manager → 객체 → Object Access → Permission Sets/Profiles 탭 → Edit |
| Edit Permissions Faster in the Permission Set Summary | 권한 집합 요약 뷰에서 사용자·객체·필드·커스텀 권한을 직접 수정. 이전에는 요약 뷰에서 최소한의 편집만 가능했음 | Setup → 권한 집합 → View Summary |
| Manage Included Permission Sets in the Permission Set Group Summary | 권한 집합 그룹 요약 뷰를 벗어나지 않고 포함된 권한 집합을 편집. 이전에는 읽기 전용 | View Summary → Included Permission Sets 탭 → Add/Remove |
| Review Tab Settings in Access Summaries | 사용자/권한 집합/권한 집합 그룹이 접근 가능한 탭을 요약에서 확인 | View Summary |
| View and Manage a User's Permission Sets, Groups, and Queues More Easily | 사용자 접근 요약에서 권한 집합·그룹·큐를 추가/제거하고, 각 섹션을 검색·정렬·새로고침 | Setup → 사용자 → View Summary |

대상 에디션: Edit Permissions Faster 외 일부는 Contact Manager/Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer/Database.com에서 사용 가능(LEX & Classic, 일부 조직 제외).

### List Views — LWC 전환

- **Get Better Performance for List Views** — 커스텀·표준 객체의 리스트 뷰가 Aura 대신 Lightning Web Components(LWC)로 렌더링. Starter·Pro Suite를 제외한 전 에디션. Spring '25 롤링 시작 → Summer '25 전면 제공
- **Enhance Accessibility with the Improved List Views Dropdown Menu** — 전 객체의 리스트 뷰 드롭다운 메뉴가 LWC 사용. 최대 100개 리스트 표시
- **Select Record Type Quick Filters from a Picklist** — Record Type 필드 빠른 필터를 텍스트 입력 대신 피클리스트에서 선택. (Spring '25 출시, 미문서화였음)

### Salesforce Connect

- **Access External Data in Prompt Builder** — 프롬프트 템플릿 작성 시 외부 객체를 선택하고 그 필드를 커스텀/표준 객체처럼 접근해 Agentforce 워크플로우를 보강. (LEX Enterprise/Performance/Einstein 1 + Einstein for Sales/Platform/Service add-on)
- **Access Data Without Limits with Salesforce Connect** — OData 2.0/4.0/4.01, Custom, GraphQL, Amazon DynamoDB, Amazon Athena·Snowflake용 SQL 어댑터의 신규 행(new rows)·콜아웃(callout) 한도 제거. **Hyperforce에 호스팅된 조직만 해당.** Enterprise/Performance/Unlimited/Developer. 2025년 7월 14일까지 모든 고객에 롤링 (→ 인프라 측면은 [Architecture](#architecture--infrastructure) 참조)

### 글로벌라이제이션

- **Enable ICU Locale Formats (Release Update)** — ICU(International Components for Unicode) 로케일 형식이 Oracle JDK 로케일 형식을 대체. Winter '20 최초 제공 → **Summer '25에 아직 전환 안 한 조직 중 Apex 클래스/트리거/Visualforce 페이지가 API v45 이상인 조직에 자동 활성화.** en_CA는 별도 활성화 필요. Summer '25 이후 활성화는 일시 중단. → [[Summer '25/Release Updates]]
- **Clear State and Country Picklist Mappings** — 복구 불가능한 주/국가 피클리스트 매핑의 변환 프로세스를 시작하기 위해 매핑을 일괄 삭제. 개별 편집이 불가능할 때만 사용. (Setup → State and Country/Territory Picklists → Scan → Clear Scanned and Mapped Data)
- **Review Updated Label Translations** — 아랍어·불가리아어·중국어(간체/번체)·크로아티아어·체코어·덴마크어·네덜란드어·핀란드어·프랑스어·독일어·그리스어·히브리어·헝가리어·인도네시아어·이탈리아어·일본어·한국어·폴란드어·포르투갈어(브라질/유럽)·루마니아어·러시아어·슬로바키아어·슬로베니아어·스페인어·스페인어(멕시코)·스웨덴어·태국어·터키어·우크라이나어 등 표준 객체·탭·필드 명칭 번역 갱신

### 필드 / 객체

- **Troubleshoot a Deployment That Contains a Custom Field Type Conversion** — 메타데이터 `deploy()` 또는 패키지 업그레이드에 커스텀 필드 데이터 타입 변환이 포함되면 오류가 날 수 있음. **한도: 8,500만 건(85 million) 커스텀 필드 타입 변환**
- **Easily Remove Relationships Before Deleting a Custom Object** — 다른 표준/커스텀 객체 또는 Data Cloud DMO가 해당 커스텀 객체를 참조하는 lookup 필드를 가지면, 객체 API 이름(하이퍼링크)·필드 API 이름을 보여주는 상세 페이지 제공

### Lightning App Builder / 접근성

- **Some Record Page Text Is No Longer Truncated** — Record Detail 컴포넌트와 Dynamic Forms 필드 섹션의 섹션 헤더 텍스트 잘림(특히 고배율 줌)이 제거됨
- **Select, Cut, and Paste Components More Easily When Using a Keyboard** — App Builder에서 키보드로 컴포넌트 잘라내기/붙여넣기 시 Enter 키로 삽입 아이콘 활성화
- **Understand Page Structure Better with Screen Reader Enhancements** — 스크린 리더가 페이지 템플릿의 영역 정보에 접근, 컴포넌트 제목과 지정 영역을 함께 안내 (예: "Highlights Panel in the Header template region")

### Heroku / Salesforce Go / Digital Wallet

- **Generate Actions from External Services with Heroku Apps (Generally Available)** — 기존 `ExternalServiceRegistration` 객체의 `RegistrationProviderType` 필드에 새 `Heroku` 값 사용. External Services 등록에서 Heroku 앱으로부터 액션 생성. (→ Integration/DevOps 경계)
- **Simplify Feature Discovery and Setup with Salesforce Go** — Salesforce 에디션에서 사용 가능한 기능을 Setup 한곳에서 발견·설정. 사용자 권한 할당, 전제 조건·필수 구성 단계 완료, 기능 사용량 모니터링. (LEX Pro Suite/Pro/Enterprise/Performance/Unlimited/Developer. 보기=View Setup and Configuration, 켜기=Customize Application. gear menu → Salesforce Go)
  - **Sales Cloud Go is Now Salesforce Go** — Sales Cloud Go가 Salesforce Go로 통합·개명
- **Digital Wallet (소비량 모니터링)**
  - **Monitor Flex Credits Consumption with Digital Wallet** — Flex Credits는 여러 Salesforce 소비 서비스 간 호환되는 새로운 유연 결제 단위. Digital Wallet이 근실시간 사용 투명성과 에이전트 액션 레벨 소비 인사이트 제공. (Enterprise/Unlimited; View Consumption 권한)
  - **Internal Data Pipeline Data No Longer Appears in Digital Wallet** — 2025년 8월 7일부터 Internal Data Pipeline 데이터는 Data Services 소비 카드에 표시되지 않음. 해당 데이터 수집은 크레딧을 소비하지 않음
  - **Monitor Salesforce Message Credits - Mobile App in Digital Wallet** — Marketing Cloud Engagement+의 Mobile App 메시지 사용량 모니터링
  - **Get Actionable Insights with Digital Wallet Consumption Tags** — 순수 사용 지표와 함께 적용되는 추가 메타데이터(consumption tag)로 세분화된 가시성. 2025년 8월 22일부터 단계적 적용

### AppExchange / AgentExchange

- **Boost Agentforce Capabilities with AgentExchange** — AgentExchange 마켓플레이스의 사전 빌드된 프롬프트·액션·토픽을 코딩 없이 Agentforce에 탐색·설치·배포
- **Discover Agentforce Solutions Faster Using Filters in the Improved AgentExchange** — 솔루션을 에이전트·토픽·액션 기준으로 필터링하고 리스팅 타일에서 세부 정보 확인
- **Identify Partner Product Dependencies for AppExchange Solutions** — AppExchange 리스팅의 새 Required Partner Products 필드로 동일 공급자의 다른 솔루션이 전제 조건인지 확인

### Sharing

- **Review Changing Sharing Recalculation Behavior** — 그룹 멤버십/역할 업데이트 후, 성능에 유리할 때 소유자 기반 공유 규칙을 비동기로 재계산. Setup Audit Trail에서 단계 모니터링. Summer '25 롤링, 조치 불필요
- **Enable Secure Roles Behavior (Release Update)** — 기본 공유 그룹이 "Roles and Subordinates" 대신 "Roles and Internal Subordinates"로 표시됨. 프로덕션은 Winter '26 강제, 비프리뷰 샌드박스는 Summer '25 강제. → [[Summer '25/Release Updates]]

---

## Security / 정책

> Security 섹션에는 명시적 "(Generally Available)" 라벨 항목이 없다. 전부 일반 GA 변경 또는 Release Update 또는 Beta/Pilot이다.

### 강제 성격(Release Update) — 한 줄 + 위임

아래 항목은 강제 적용 시점이 핵심이므로 [[Summer '25/Release Updates]]에 시점을 둔다.

- **Migrate to a Multiple-Configuration SAML Framework (Release Update)** — 단일 구성 SAML 프레임워크 지원 제거. 프로덕션 Spring '26 강제, 샌드박스 Summer '24 강제. (Spring '24 최초 제공) → [[Summer '25/Release Updates]]
- **Verify SAML Integrations (Release Update)** — Salesforce가 SAML 프레임워크를 정기 유지보수로 업그레이드. Winter '25 최초 발표 → Summer '25 강제. 약 6주 윈도우 내 통합 테스트 권장 → [[Summer '25/Release Updates]]
- **Triple DES for SAML SSO Stops Working in Winter '26** — Winter '26에 Triple DES 알고리즘 사용 SAML SSO 구성 작동 중지. AES 128/256으로 전환. (Spring '25에 신규 구성은 이미 제거) → [[Summer '25/Release Updates]]
- **Salesforce Platform API v21.0–30.0 폐기 (Release Update)** — Summer '23 예정 → Summer '25로 연기. 해당 API 버전 미지원·사용 불가 시작 → [[Summer '25/Release Updates]]

### Identity & Access Management (IAM)

- **Build Single Sign-On Registration Handlers Without Code** — Apex 대신 Flow Builder로 등록 핸들러 작성. 두 개의 새 invocable action(Get User Data from JSON String, Generate User Data) + Authentication Provider User Registration 템플릿(새 Identity User Registration Flow 타입). (Enterprise/Performance/Unlimited/Developer)
- **Get Information from Identity Providers More Easily** — 전체 user info 응답을 Apex `Auth.UserData` 객체의 `userInfoJsonString` 프로퍼티에, ID 토큰을 `idToken`(인코딩된 JWT)·`idTokenJsonString`(디코딩) 프로퍼티에 자동 노출. 커스텀 auth provider는 `Auth.AuthProviderTokenResponse`의 새 `idToken`에 저장. JWT 서명은 Salesforce가 검증하지 않으므로 `Auth.JWTUtil` 사용. (코드 상세 → [[Summer '25/Development]])
- **Control JWT-Based Access Token Enablement as an App Developer** — 구독자가 앱 정책에서 JWT 기반 액세스 토큰 활성화 여부를 제어하던 기능 제거. SOAP API(Salesforce DX)·Pub/Sub API·Streaming API 등을 쓰는 통합이 깨질 수 있음
- **See Which Sessions Are Associated with JWT-Based Access Tokens** — 새 "Associated with JWT" 필드를 포함하는 뷰 생성 가능
- **Login Type Is Changed for a Session Associated With Lightning Experience Logins** — 이전 Unknown → 이제 Application. (Spring '25에 API 세션 타입 추가됨)
- **Take Advantage of Accessibility Improvements for Login Error Messages** — 두 오류 메시지가 "Error" 접두사로 시작

### External Client App / Connected App

- **Create External Client Apps in App Manager** — Setup의 App Manager에 New External Client App 버튼 추가. OAuth 외에 SAML도 사용 가능. (Pro/Performance/Unlimited)
- **Integrate Service Providers as External Client Apps with SAML 2.0** — 외부 클라이언트 앱의 SAML 설정으로 서비스 공급자 통합(SP/IdP-initiated flow 모두)
- **Create an External Client App by Using Agentforce (Agentforce for Identity)** — Agent for Setup가 Create External Client App 액션으로 외부 클라이언트 앱 생성. (Enterprise/Performance/Unlimited/Developer; Use Agentforce Default Agent 권한)
- **Control Connected App Creation on New Orgs** — "Allow creation of connected apps" 환경설정이 신규 조직에서 기본 비활성화. (Pro/Performance/Unlimited)
- **Create Connected Apps in Lightning Experience** — 연결된 앱은 이제 LEX에서만 생성. Salesforce Classic에서 생성 불가. (Pro/Performance/Unlimited)
- **Warning Message Is Added to the OAuth App Approval Page** / **Security Alert Is Added to the Device Flow Connection Page** — OAuth 2.0 device flow 연결 페이지에 보안 경고 추가. Summer '25 롤링
- **Prepare for Connected App Usage Restriction** — 2025년 9월 초부터 미설치 연결된 앱 사용 제한 시작. 새 "Approve Uninstalled Connected Apps" 사용자 권한이 2025년 8월 18일 제공. API Access Control 활성화 시 Use Any API Client 권한 필요. 2025년 9월 2일부터 롤링 강제

### 로그인 / 인증 정책

- **Built-In Authenticators and WebAuthn Security Keys Are Allowed by Default in New Orgs** — Touch ID/Windows Hello 및 U2F 같은 물리 보안 키. Summer '25 이후 생성된 조직, 전 에디션
- **Device Activation is Required for Some Production and Sandbox Org Users** — 허용된 IP 주소 범위가 16,777,216개를 초과하면 디바이스 활성화 필요. 전 revenue 조직. Summer '25 롤링
- **Device Activation Is Always Required for Non-Revenue Orgs** — 모든 비revenue(trial) 조직. Summer '25 롤링
- **Email Verification via Password Reset Is No Longer Supported by Default for Experience Cloud Sites** — Aura/LWR/VF 사이트. Enterprise/Performance/Unlimited/Developer. 2025년 6월 롤아웃

### Policy Center / Privacy Center

- **Manage More Policy Types in Policy Center** — Data Cloud의 Data Security 정책 타입과 Data Detect 정책을 Policy Center 앱에서 직접 제어. 기존 Data Management 정책 타입을 명확성을 위해 Data Retention으로 개명. (Enterprise/Unlimited/Developer)
- **Retain Files and Attachments with Privacy Policies** / **See Policy Preview Metrics for Files and Attachments** — 개인정보 정책으로 파일·첨부 보존 및 정책 미리보기 지표 확인. (Enterprise/Performance/Unlimited/Developer)

### Salesforce Shield — Event Monitoring

- **Explore Information About Suspicious Login Activity with the Login Anomaly Event** — Threat Detection 앱의 새 Login Anomaly 이벤트로 비정상적 시간대·드문 엔드포인트 등 비정상 로그인 시도 조사. (Enterprise/Performance/Unlimited/Developer)
- **Store Data for Threat Detection Events by Default** — 모든 위협 탐지 이벤트에 대해 데이터 저장이 자동 활성화
- **Access Real Time Events in Flows** — Platform Event 트리거 Flow가 select Real Time Events로 구동. (Setup → Flows → New Flow → Platform Event-Triggered Flow → Login, List View, Report, File, Bulk Api Result, Login As 이벤트)
- **Leverage ListViewEvent for Recently Viewed List Views** — 사용자가 Recently Viewed 리스트 뷰에 접근할 때 실시간 이벤트 생성 및 Transaction Security Policy 작성

> **참고:** Event Log Objects 프레임워크(Hyperforce 고객이 이벤트 데이터를 30일 저장·15일 윈도우 쿼리)는 [Architecture](#architecture--infrastructure)에 둔다.

#### 표준 오브젝트에 저장되는 이벤트 데이터 노출 (Surface more event data stored in standard objects)

표준 오브젝트에 저장되는 이벤트 데이터를 더 노출하기 위한 신규 이벤트 로그 오브젝트:

- **LightningErrorEventLog**
- **DatabaseSaveEventLog**
- **GroupMembershipEventLog**
- **UiTelemetryNavTmEventLog**
- **UiTelemetryRsrcTmEventLog**
- **InvocableActionEventLog**

관련 신규 필드·이벤트 타입:

- **Monitor actions invoked during Agentforce flows** — `EventLogFile` 오브젝트의 신규 Invocable Action Event Type 사용
- **Set a default account for new external users** — 인증 공급자 사용자 등록 플로우에서 `AuthProvider` 오브젝트의 신규 `FlowDefaultAccountId` 필드 사용
- **Set a default profile for new users** — `AuthProvider` 오브젝트의 신규 `FlowDefaultProfileId` 필드 사용
- **See which sessions are associated with JWT-based access tokens** — `AuthSession` 오브젝트의 신규 `IsAssociatedWithJwtAccessToken` 필드 사용

### Shield Platform Encryption (Crypto)

- **Encrypt Your Entire Database (Beta / Sandbox Release)** — 특정 Hyperforce 조직의 샌드박스에서 데이터베이스 암호화 테스트 가능(Beta). 암호화된 데이터를 기능·성능 trade-off 없이 정렬·필터·참조. 필요 시 개별 필드에 Field Level Encryption도 적용 가능. ("Encrypt the Transactional Database" 토글)
- **Enhance Security with AES-GCM Mode and P1363 Signing** — Apex `Crypto` 클래스가 256-bit 암호화용 AES-GCM(Galois Counter Mode) 지원. 매 암호화마다 다른 IV 사용. 256/384/512-bit P1363 서명 형식도 지원. (Shield Platform Encryption 라이선스 / 정책 맥락. Apex 코드 상세 → [[Summer '25/Development]])

```apex
// 구조 예시 — 실제 동작 코드 아님
// Crypto AES-GCM: 메서드명·algorithmName·파라미터는 릴리즈 노트 본문 인용
// AES256-GCM 사용 시 aaData(additional authentication data) Blob 파라미터 추가
Crypto.encrypt('AES256-GCM', key, iv, data, aaData);
Crypto.decrypt('AES256-GCM', key, iv, encrypted, aaData);
Crypto.encryptWithManagedIV('AES256-GCM', key, data, aaData);
Crypto.decryptWithManagedIV('AES256-GCM', key, encrypted, aaData);
// P1363 서명: sign / signWithCertificate / signXML / verify (256/384/512-bit)
```

> **주의:** 위 algorithm 문자열(`'AES256-GCM'`)과 메서드 시그니처는 Summer '25 릴리즈 노트 본문에 명시되지 않은 예시다. 릴리즈 노트는 개념 수준에서 "AES-GCM 256-bit 암호화 및 256/384/512-bit P1363 서명"만 기술한다. 정확한 문자열·시그니처는 Apex 레퍼런스로 확인할 것.

- **Increase Control of Data Cloud Encryption Keys with External Key Management** — 외부 AWS KMS가 데이터 암호화 키(DEK)를 생성·보호하는 External Key Management(EKM). (Shield Platform Encryption + External Key Management + Data Cloud 라이선스 + Platform Encryption for Consumption 필요)
- **Benefit from an Improved Deterministic Tenant Secret Workflow** — 결정론적 테넌트 시크릿의 동기화 작업 문제를 방지하는 인앱 도우미
- **Upload Search Index Data Encryption Keys via API** — 검색 인덱스 DEK를 API로 업로드. DEK는 256-bit이며 PKCS#11 CKM-RSA-AES-KEY-WRAP에 정렬
- **Implement Field-Level Encryption Faster with Platform Encryption Analyzer** — Own from Salesforce의 Platform Encryption Analyzer를 모든 Shield Platform Encryption 고객에 제공
- **Get More out of Shield Products with Shield Extension** — Shield Extension 관리형 패키지에 Platform Encryption Analyzer, Field History Explorer, History Retention Policy Manager 포함 (2025년 3월)

### Data Detect (Beta)

- **Get the Beta Version of Data Detect as an App in Salesforce (Beta)** — Salesforce 앱 버전 Data Detect가 Beta로 제공(관리형 패키지 버전도 유지). 2025년 5월 풀 베타
- **Improve Sensitive Data Detection in Text Fields Across Your Salesforce Org (Beta)** — 확장된 패턴 매칭으로 기본 21개 민감 데이터 타입 식별. 객체 레벨 스캔 또는 개별 필드 선택

### Security Center

- **Implement Multi-Organization Support in Government Cloud Plus Instances** — 모든 Government Cloud Plus 조직의 보안 설정을 중앙 Security Center 대시보드에서 모니터·관리. (Enterprise/Performance/Unlimited/Developer; Gov Cloud Plus + Security Center add-on)
- **Add Depth to Your Security Posture with Security Center Extension** — Who Sees What Explorer, Data Classification, Security Insights. (2025년 3월)

### Agentforce for Security (전수)

모두 LEX Enterprise/Performance/Unlimited/Developer; Security Center add-on + Agentforce Platform add-on(또는 Einstein Platform add-on); Use Agentforce Default Agent 권한.

- **Identify Security Deviations by Using Agentforce** — Get Security Alerts 에이전트 액션
- **Unlock Insights from Your Security Data** — Get Security Metric Data 에이전트 액션
- **Leverage Risk and Remediation Insights** — Classify Security Risk 에이전트 액션
- **Gain Insights About Policies with Agentforce** — Get Policy Details 액션 (Einstein Platform add-on)
- **Identify Policies by Policy Type** — Get Policies by Policy Type 액션
- **Compile Policies by Object** — Get Policies by Object 액션

### Beta (Shield → Data Cloud)

- **Import Event Data from Shield's Event Monitoring into Data Cloud (Beta)** — Platform Events Connector로 Salesforce Event Monitoring의 실시간 이벤트를 Data Cloud로 가져옴. (Enterprise/Performance/Unlimited, Event Monitoring 활성 조직. 2025년 3월. Shield/Event Monitoring add-on)

### Pilot

- **Utilize Near Real-Time Apex Callout Spans (Pilot)** — Apex callout span을 Platform Event로 게시해 MTTR(평균 복구 시간) 단축. (Shield/Event Monitoring. 코드성 → [[Summer '25/Development]] 경계)

### Other Security Changes

- **Monitor Blocked Redirections / CSP Violations** — Salesforce Classic의 URL·Long Text Area 필드 하이퍼링크에서 발생하는 차단된 리디렉션을 모니터링. Setup의 Trusted URL and Browser Policy Violations 리스트에 더 많은 CSP 위반이 표시됨. (개별 상세 항목 본문은 추출 범위 밖이라 요약만)

---

## Automation (Flow)

### GA

- **Keep Users on One Flow Screen with Automatically Triggered Screen Actions (Generally Available)** — 백그라운드로 flow를 자동 실행해 화면을 동적으로 만듦. 입력 값이 갱신될 때마다, 그리고 화면 로드 시마다 실행됨(단 다음 화면에서 Previous 버튼으로 도달한 경우 제외). (LEX & Classic 일부 조직 제외; Essentials/Pro/Enterprise/Performance/Unlimited/Developer. **Lightning runtime 전용**)
- **Prompt Template Batch Processing (GA 8/25)** — Prompt Template Batch Processing Invocable Action으로 수백~수천 입력 레코드에 걸쳐 비동기 대규모 프롬프트 응답 생성. 큐잉·배칭·실행을 처리해 LLM rate limit 회피. 2025년 8월 25일 GA. (LEX & Classic 일부 제외; Essentials/Pro/Enterprise/Unlimited/Developer)

### Flow Approval Process (신규 GA — 전수)

코드 없이 Flow Builder에서 승인 프로세스를 생성·실행·회수한다. (LEX Enterprise/Performance/Unlimited/Einstein 1/Developer)

| 항목 | 내용 | 권한 |
|---|---|---|
| Create a Flow Approval Process from the Approvals App | Approvals 앱 내 마법사로 최대 3단계 승인·최종 액션·recall path를 가진 draft 프로세스 생성 | Manage Flow |
| Create a Flow Approval Process with an Action | 사용자 입력을 받은 뒤 Create Flow Approval Process 액션으로 **최대 20단계** 승인의 autolaunched 프로세스 초안 작성(최종 액션·recall path 포함 가능) | Manage Flow |
| Run a Flow Approval Process from a Flow | 비동기 경로를 지원하는 flow에서 새 dynamic "Request an Approval" 액션 호출. 이후 Action 요소로 활성 autolaunched 승인 프로세스 호출 | — |
| Add a Recall Path to a Flow Approval Process | recall path는 제출 회수 시 실행되는 background step 스테이지를 포함. 회수 시 실행 중이던 스테이지·step·열린 승인 work item이 취소되고 recall path 스테이지가 실행됨 | Modify Flow |
| Complete Approval Work Items in the Work Guide as a Delegate | Work Guide가 객체 레코드 페이지에 추가되면 승인자에게 할당된 열린 승인 work item을 나열. 이제 delegate도 Work Guide에서 확인·완료 가능. 이메일 회신으로도 완료(screen flow 미실행) | — |
| Cancel an In-Progress Approval Submission | 진행 중 승인 제출에 문제가 있거나 불필요하면 취소 가능. recall path가 구성된 프로세스라도 취소 시 recall path 액션은 수행하지 않음 | Approval Admin |
| Other Changes to Flow Approval Processes | 새 Process Simple Approval 프로세스를 Request an Approval 동적 액션과 함께 사용(단일 승인 step이 새 Review Approval Request screen flow 호출). orchestration 스테이지 레이블 번역 | — |

```yaml
# 구조 예시 — 실제 동작 설정 아님
# Flow Approval Process를 호출하는 Action 요소의 actionType 구조 개념도
# (릴리즈 노트의 동작 설명을 기반으로 한 개념 예시 — 실제 메타데이터 스키마 아님)
- actionType: createFlowApprovalProcess   # 최대 20단계 승인 초안 생성
  inputs:
    approvalLevels: 20
    finalActions: [...]
    recallPath: true
- actionType: requestAnApproval           # 활성 autolaunched 승인 프로세스 호출
  inputs:
    approvalProcess: <Active_Autolaunched_Flow_Approval_Process>
```

### Flow Orchestration

- **Control Orchestration Error Handling by Using Fault Paths** — orchestration이 오류를 만났을 때의 동작을 fault path로 정의. 각 스테이지에 fault path를 구성하고, 해당 스테이지(또는 그 안의 step)에 오류가 나면 실행될 요소를 추가. orchestration이 오류로 끝날 위험을 줄임. (LEX Enterprise/Performance/Unlimited/Developer; Modify Flow 권한. 스테이지 선택 → Add Fault Path)
- **Other Changes to Flow Orchestration** — step 시작/완료 조건을 **최대 10개**까지 정의(이전 최대 3개). orchestration 스테이지 레이블 번역
- **FlowOrchestrationLog — `Kind` 필드에 새 `RunRecallPath` 값** — `FlowOrchestrationLog` 객체의 기존 `Kind` 필드에 추가된 `RunRecallPath` 값을 사용한다(승인 제출이 회수(recall)될 때의 마일스톤을 기록).
- **FlowOrchestrationInstance — 새 `TriggeringRecordType` 필드** — `FlowOrchestrationInstance` 객체의 새 `TriggeringRecordType` 필드로 orchestration을 트리거한 레코드의 객체(object)를 지정한다.

### MuleSoft for Flow

- **Enhance Data Exchange with Newly Added Third-Party Connectors (GA)** — ClickUp, Google BigQuery, Google Calendar, Google Sheets, Mitto (Chat), Mitto (SMS), Salesforce Commerce Cloud. (Manage Integration Connections 권한)
- **Explore Connector Capabilities with the New Integrations Tab** — 기존 Connections 탭을 Integrations 탭으로 대체
- **Accelerate Integrations with Templates (GA)** — Salesforce to Salesforce Account Sync, Salesforce to Salesforce Contact Sync, Salesforce to NetSuite Account Sync, Create Ticket in Zendesk, Create Customer in QuickBooks
- **Streamline Data Retrieval with Configurable Get Records Actions** — Salesforce·NetSuite 커넥터의 구성 가능한 Get Records 액션
- **Show Apex APIs in API Catalog for Salesforce (Beta)** — Apex REST 액션으로부터 커스텀 액션 생성(베타 통합). 2025년 3월 도입
- **Show Heroku APIs in API Catalog for Salesforce (GA)** — 2025년 7월. (Heroku AppLink add-on)

#### Deprecated

- **Direct Publishing from MuleSoft RPA to Salesforce Is Being Retired** — Anypoint Platform 자동화 개발자가 **MuleSoft RPA 또는 MuleSoft Composer**에서 invocable action을 Salesforce에 직접 게시(directly publish)하던 기능이 **2025년 5월 30일(May 30, 2025)** 에 폐기(retirement) 예정이다. 표준 external services 플로우를 사용해 MuleSoft RPA 프로세스를 Salesforce에서 external service로 등록하는 것은 계속 가능하다.

### Screen Flow

- **Get Better Usability with the File Upload Enhanced Flow Screen Component (Beta)** — 기존 File Upload 컴포넌트와 유사하나 향상됨. Aura·LWR 사이트와 LEX에서 파일 업로드. 진행 전 문서 업로드를 필수로 요구 가능(Required=true). (Setup → Salesforce Files → General Settings → Use the File Upload Enhanced Lightning web component (Beta))
- **Display Choices in Tiles with the Visual Picker Component in Screen Flows** — Visual Picker 컴포넌트로 아이콘+텍스트 조합 선택지를 타일로 표시(긴 리스트/드롭다운 스크롤 회피). 크기 구성 + 다중 선택
- **Help Users Make Selections Faster by Adding Icons to Choice Resources** — choice 리소스 각 항목에 아이콘 추가(Choice Lookup·Visual Picker 컴포넌트 한정, text 데이터 타입). Utility/Doctype/Standard SLDS 아이콘
- **Get More Control Over Component and Field Layout in Screen Flows** — 섹션 컬럼 내외 화면 컴포넌트·레코드 필드 너비 및 수직 정렬 커스터마이즈
- **See How Your Screen Looks in Real Time on Different Screen Sizes** — Preview Size 기능으로 large/medium/small 디바이스 미리보기

### Flow Builder (Beta / Pilot)

- **Get Related Records Faster (Beta)** — Get Records 요소에서 관련 객체 관계를 선택해 단일 쿼리로 관련 레코드 조회(autolaunched flow). ("Also add related records (beta)")
- **Find More Resources with Expanded Search (Beta)** — 레코드 필드·관련 액션·컴포넌트·출력 등 확장된 리소스 검색. (Winter '25 출시 후 제거되었다 재도입)
- **Activate Data Cloud Segments to Any API-Based Destination with Activation-Triggered Flow (Pilot)** — Data Cloud activation 완료 후 activation-triggered flow 실행. external service·MuleSoft 커넥터로 액션 수행. (Data Cloud 에디션. 2025년 7월)

### Flow Builder — 일반/GA (주요)

- **Manage Time-Specific Data Easily (Time 데이터 타입)** — 날짜 없이 시간만 다루는 Time 데이터 타입 리소스·필드. 밀리초 단위. flow 요소·formula·expression builder·subflow·resource 전반 지원(offline flow 미지원). API v64.0+. Time 함수: `HOUR()`, `MINUTE()`, `SECOND()`, `MILLISECOND()`, `TIMENOW()`, `TIMEVALUE()`. 형식 hh:mm:ss.SSS AM/PM
- **Test Flows for Error Handling (Has Error operator)** — 새 Has Error 연산자로 flow 테스트에서 부정 단언. record-triggered·data cloud-triggered flow 테스트의 Create/Update/Delete Records·Action 요소에 사용
- **View Picklist Selections as Pills** / **Select an Entire Resource More Efficiently (Entire Resource 메뉴)** / **Enjoy the new Einstein Panel in Flow Builder** (드래그·핀·대화 기록 삭제) / **Zoom Through the Canvas with Touch Gestures and Keyboard Shortcuts** (핀치 줌, Zoom In `Cmd+Option++`/`Ctrl+Alt++`, Zoom Out `Cmd+Option+-`/`Ctrl+Alt+-`, Zoom to Fit `Cmd+Option+1`/`Ctrl+Alt+1`, Reset `Cmd+Option+0`/`Ctrl+Alt+0`)
- **Build on Your Successes by Saving an Existing Flow as a Template** (Save as Template) / **Manage Elements Faster in Auto-Layout Mode** / **Easily Discover and Add an Asynchronous Path in Record-Triggered Flows** / **Transform Data Graph Data in Flows** (Transform 요소에서 data graph 실시간 접근. Data Cloud Ent/Perf/Unl/Dev. 2025년 6월 13일)

### Flow Management / 통합 테스트

- **Test Flows Faster with Integrated Tests** — Flow 테스트를 회귀·단위·CI/CD 프로세스에 통합. Salesforce CLI로 flow 테스트 실행(Salesforce CLI flow 플러그인 또는 CLI v2.86.9+).

```bash
# 출처: salesforce_release_notes_5-17-2026 (3).pdf — Flow Management 섹션 (CLI 명령 직접 인용)
sf flow run test
sf flow run test --help
```

- **Debug Flows More Easily by Viewing Output Resources in Flow Builder** — Flow Builder 구성 패널에 새 **View Output Resources** 섹션이 추가되어 출력 파라미터·리소스(출력 이름/레이블, 데이터 타입, 설명)를 표시한다. flow 디버깅과 올바른 출력 확인에 도움이 되며, 출력 파라미터를 정렬하고 변수를 수동으로 할당할 수 있다.
- **Log More Flow Data to Data Cloud** — schedule-triggered flow와 트리거 없는 autolaunched flow의 실행을 Data Cloud에 직접 로깅. FlowRun 커스텀 리포트 타입, Flow Run DMO
- **Manage Your Time-Based Automations** — Setup의 Time-Based Workflow 페이지가 Time-Based Automations로 개명. schedule-triggered flow·scheduled path·workflow action을 통합 뷰로 표시

### Flow Actions — Send Email (주요)

Send Email 액션 업데이트(전 항목 Essentials/Pro/Enterprise/Unlimited/Developer): 입력 정리, 버전 전환(v1.0.0/v1.0.1), 템플릿 선택, **CC/BCC collection 지원(총 최대 150 수신자)**, sender/content 입력 구성, Log Email on Send 기본 숨김, threading token 제한, Attachment ID Collection(텍스트 collection 변수)으로 추가 처리 없이 파일 첨부.

### Flow Configuration / Release Updates

- **Enhance Invocable Apex Configuration Designs with Action Extension Metadata (Developer Preview)** — `InvocableActionExt` 메타데이터 타입. Scratch Org 전용
- **Flow Release Updates** — Enforcing No-Argument Constructor on Apex Classes for Invocable Action Parameters(Summer '26 강제), Restrict User Access to Run Flows(Winter '26 강제, FlowSites org 권한 deprecated), Enforce Rollbacks for Apex Action Exceptions in REST API(Spring '25부터 미강제). → [[Summer '25/Release Updates]]

### Flow — Marketing Cloud (경계, 요약)

Marketing Cloud 한정 Flow 기능 다수: Einstein Decision element(이메일 engagement 기반 경로), 커스텀 Data Space 자동화, custom engagement signal 트리거, Can Rejoin Flow?=Never, Wait Until Event element, out-of-the-box 이메일 템플릿 등. (MC Growth/Advanced 에디션. 상세는 Marketing Cloud spoke 소관)

---

## Mobile

### GA

- **Explore Real-Time Analytics Anywhere with Tableau Next Mobile (Generally Available)** — 모바일에서 실시간 Agentforce 기반 분석. (LEX + Data Cloud; iOS/Android Enterprise/Performance/Unlimited)
- **Access Record Attachments in the Offline App with Files Priming (Generally Available)** — Offline App(Salesforce Mobile App Plus)용 briefcase에 레코드를 prime할 때 첨부 파일도 포함. (이전 베타 → GA. Briefcase Builder → object rule → Enable file attachments)
- **Use External Client Apps to Manage Your App's Push Notifications (Generally Available)** — External Client Apps for Mobile Publisher가 신규 Experience Cloud 앱에 GA. External Client Apps 프레임워크가 Connected App 프레임워크를 대체. 기존 MP for Experience Cloud 앱과 기존·신규 Mobile App Plus 앱은 계속 connected app 프레임워크 사용. (Enterprise/Performance/Unlimited)
- **Customize Seller-Focused Mobile Experience (Generally Available)** — 커스텀 객체용 네이티브 페이지 추가 및 레코드 홈 페이지 레이아웃 커스터마이즈(Mobile Builder for Seller-Focused Experience, 영어 전용). Spring '25 베타 → Summer '25 GA. 앱 버전 254.000+

### Beta

- **Use Dynamic Related Lists on Mobile (Beta)** — 모바일에서 Dynamic Related List 사용. 이전에는 Dynamic Related List - Single 컴포넌트가 데스크탑 레코드 페이지에서만 렌더링되고 모바일은 Single Related List 컴포넌트를 별도 구성해야 했음. 이제 한 컴포넌트로 양쪽 모두 구성. (LEX 전 에디션. Salesforce Mobile App Setup → Dynamic Related Lists for Mobile (Beta))
- **Set Up Mobile Features and Notifications By Using the External Client App Framework (Beta)** — 세 가지 새 플러그인: mobile app plugin(커스텀 타임아웃 화면 잠금), push notification plugin(Android/iOS), notifications plugin(커스텀 알림). (Pro/Performance/Unlimited/Developer)

### 기타 Mobile (주요)

- **Further Enhance Mobile Security with Two New Policies** — Block Custom Keyboard, Enable Strict Data Leak Protection Controls 정책. (Salesforce Mobile App Plus 추가 비용; Enforce Enhanced Mobile App Security 권한)
- **Align Mobile Publisher Release Numbering with Salesforce** — 구 넘버링 마지막 버전 14.0, 현재 버전 256
- **Integrate Agentforce into Your Native Mobile Apps with the Agentforce Mobile SDK** — 네이티브 iOS/Android 앱에 Agentforce 연결·대화형 경험 임베드. 사전 빌드 UI 또는 headless 통합 선택. 2025년 6월 20일 초기 릴리스. (SDK 코드성 → [[Summer '25/Development]] 경계)
- 그 외: Seller-Focused Experience 권한 불필요화(앱 256.000+), 가로 모드 뷰, Android PDF 미리보기, Android OS 15+ 인터페이스 중첩 해소, 새 Test Harness(Salesforce Mobile App Plus ↔ Field Service App 전환) 등

---

## DevOps / CLI / Packaging

### Performance / Scale tools

- **Book Sandbox Slots for Peak Load Testing with Scale Test** — DevOps Testing이 이제 Full 샌드박스에서 Scale Test days를 구매하고 해당 기능을 켜면 Scale Test를 테스트 제공자(test provider)로 포함한다. Scale Test 예약 플로우는 **초당 최대 50,000 requests (RPS)** 와 무제한 사용자 로그인을 지원한다. 테스트 중에는 Live Test View로 리포트를 생성한다. (Lightning Experience, 전 에디션. Scale Test는 **싱가포르를 제외한** 모든 Hyperforce 리전의 Full-sandbox 고객에 제공. Setup → Quick Find "Scale" → Scale Test)
- **Generate Improved Apex Investigations, Provide In-App Feedback, and View Search Insights with Scale Center** — 처방적(prescriptive) 가이드로 Apex 성능을 개선하고, Feedback 버튼으로 피드백을 제공하며, search insights를 얻는다. (Lightning Experience, **Unlimited Edition**. Government Cloud Plus에서는 **미지원**. Unlimited Edition Full 샌드박스·Signature·Scale Test 고객에 추가 비용 없이 GA. 조직당 **SysAdmin이 아닌 Standard 사용자 5명(five Standard non-SysAdmin users per org)** 까지 활성화 가능. Setup → Quick Find "Scale" → Scale Center)
- **Optimize Code with ApexGuru** — 안티패턴 탐지: 루프 안의 SOQL 쿼리 확인, 비효율적 쿼리 필터·연산 식별, 비용이 큰 문자열 연산·디버그 구문 축소 권고. (ApexGuru가 활성화된 Full 샌드박스·프로덕션. ApexGuru는 **모든 Unlimited Edition Full Sandbox·Signature·Scale Test 고객에 추가 비용 없이 일반 제공(generally available at no additional cost)**. Setup → Quick Find "Scale" → Scale Center → Scale Insights → ApexGuru Insights)

### Agentforce for Developers

- **Agentforce for Developers** — VS Code 데스크탑과 Code Builder에서 VS Code 확장으로 제공되는 AI 기반 개발자 도구. Salesforce의 보안·커스텀 AI 모델인 **CodeGen·xGen-Code**를 사용해 구축됨. **Enterprise·Performance·Unlimited·Partner Developer·Developer 에디션**에서 기본 활성화.

### Sandbox tools (Data Mask Beta)

- **Access Information About Specific Data Mask Job (Beta)** — Data Mask의 Run Logs 탭이 이제 **Jobs 탭**으로 바뀌었다. Data Mask 이름을 클릭하면 구성된 객체, 현재 작업 진행 상황, 오류를 확인할 수 있다.
- **Automate the Running of Data Mask Processes with Job Scheduler (Beta)** — Data Mask 빈도(daily, weekly, monthly)를 구성해 모든 신규 샌드박스 데이터를 마스킹한다.
- **Other Improvements (Data Mask Beta)** — 레코드 로딩·변환을 최적화해 작업 속도 향상. 작업 완료 시 Data Mask가 자동화를 비활성화/재활성화하는 대신 **자동화를 우회(bypasses automation)** 한다. 필드 히스토리 추적을 끄는 대신 삭제한다. Serial 모드가 제거되었다(작업이 행 잠금(row-locked) 레코드를 자동 재시도). (Enterprise/Performance 등)

### CLI / 패키징 / 기타 (다른 섹션 연계)

- **Salesforce CLI / Extensions for VS Code / Code Builder — 주간 연속 업데이트** — Salesforce CLI, VS Code 확장, Code Builder는 매주 연속적으로 업데이트된다(continuous weekly updates).
- **2GP 패키지 변환 (Tooling API)** — `Package2` 객체의 새 `ConvertedFromPackageId` 필드로 2GP 관리형 패키지가 1GP에서 변환되었는지 확인. 추가: `Package2Version.ConvertedFromPackageVersionId`, `Package2VersionCreateRequest.IsConversionRequest`. (2GP 마이그레이션 GA 연계 — 패키지 변환 절차 자체는 [[Summer '25/Development]], 푸시 업그레이드는 [[2GP — Push Upgrade]])
- **Test Flows Faster with Integrated Tests (CLI)** — `sf flow run test`(CLI v2.86.9+)로 flow 테스트를 CI/CD에 통합. (위 [Automation/Flow Management](#automation-flow) 참조)
- **Access Scratch Org Metadata Quickly (DX Inspector)** — scratch org에서 DX Inspector가 페이지 상단에 표시되어 Changes 탭에서 메타데이터 변경 확인. (scratch org via LEX; Customize Application 권한)
- **Improve Salesforce External Connector Sync Performance with Incremental and Periodic Full Syncs (GA)** — CRM Analytics/Data Pipelines. API Type BULKV2
- **Improve Snapshot Data Recipe Performance with Optimized Upsert and Delete Actions (Beta)** — Data Pipelines

> **참고:** "Sandbox Deployment Status banner / Synchronous Compile on Deploy"는 [[Summer '25/Development]]에서 다루므로 여기서 중복하지 않는다.

---

## Architecture / Infrastructure

### Hyperforce

- **Access Salesforce in More Regions with Hyperforce** — Hyperforce가 **17개국**에서 제공되어 데이터 레지던시 선택·제어 폭 확대. **2025년 4월 인도 하이데라바드(Hyderabad)에 신규 Hyperforce 리전 개설.**
  - 17개국(자동 제공): 호주, 브라질, 캐나다, 프랑스, 독일, 인도, 인도네시아, 이스라엘, 이탈리아, 일본, 싱가포르, 대한민국, 스웨덴, 스위스, 아랍에미리트(UAE), 영국, 미국. (Salesforce Customer 360 제품군 — Sales Cloud·Service Cloud·B2B Commerce·Platform·Industries Cloud — Hyperforce 경유 제공)
  - Data Cloud(Agentforce·Data Cloud·UMA·Einstein): 싱가포르·스위스에 신규 제공. 호주·브라질·캐나다·독일·인도·일본·영국·미국에도 제공
  - Tableau Cloud: 호주·인도네시아·일본에 신규 제공. 캐나다·독일·싱가포르·영국·미국에도 제공
- **Query Event Data with Salesforce Shield Event Log Objects (Hyperforce)** — Event Log Objects 프레임워크로 Hyperforce 고객이 이벤트 데이터를 **표준 객체에 최근 30일 저장**하고, 저장 데이터 내 **임의의 15일 윈도우를 API로 쿼리**
- **Access Data Without Limits with Salesforce Connect (Hyperforce)** — Salesforce Connect 어댑터 한도 제거(Hyperforce 호스팅 조직). (상세 → [Admin/Salesforce Connect](#admin--setup))
- **Deliver All Media Content Types at High Scale (CMS, Hyperforce)** — Hyperforce 호스팅 조직이 Dedicated Content Delivery로 document·audio·video 콘텐츠 타입을 Hyperforce 경유 전달. (Enterprise/Performance/Unlimited/Developer on Hyperforce)

> **소스 갭 표기:** 기존 허브에 있던 **"Pub/Sub API 글로벌 엔드포인트"** 항목은 이 릴리즈 노트 PDF의 Hyperforce 섹션(p570–572)에서 확인되지 않았다(미확인). 출처 불명이므로 본 노트에서는 작성하지 않는다.

### Domains / CDN / API

- **Update References to Legacy Host Names (Release Update)** — 프로덕션·데모 조직의 레거시 호스트 이름 리디렉션 종료. Spring '25 최초 제공, Summer '25 자동 활성화, Spring '26 강제 → [[Summer '25/Release Updates]]
- **Update Instanced URLs in API Traffic** — API 트래픽의 instanced URL을 조직의 My Domain 로그인 URL로 교체. (Database.com 제외 전 에디션)
- **Add the New Setup Domain (`*.salesforce-setup.com`)** — `*.salesforce-setup.com`을 허용 도메인 목록에 추가. (Summer '25 일시 중단 → Winter '26 재개)
- **Switch to a Single Domain Certificate for Your Salesforce CDN (Release Update)** — 공유 도메인 인증서 폐기. 단일 도메인 인증서로 마이그레이션하지 않으면 사이트가 작동 중지. Summer '24 최초 제공, Spring '26 강제 → [[Summer '25/Release Updates]]
- **Enhanced Security for Sites Using the Salesforce CDN (Cloudflare)** — Salesforce CDN 고객이 악성 트래픽 자동 방어 보안 강화. 정상 봇·검색 엔진 크롤러는 허용

---

## Slack

> Slack 섹션에는 GA/Beta 라벨이 없다. 전부 신규 GA 기능(제공 날짜 명시).

- **Set Up Slack Confidently in the Slack Section of Salesforce Setup** — Setup에서 "Slack in Salesforce" 페이지가 먼저 나열되고 전용 Slack 앱은 별도 하위 섹션으로 그룹화. (Essentials/Starter/Pro/Enterprise/Performance/Unlimited/Developer. 2025년 6월 12일. Connect Salesforce with Slack 권한. Setup → Slack)
- **Get Started with Slack in Salesforce Using Guided Setup** — 워크스페이스 생성, Salesforce 채널 구성, 사용자 초대 단계 제공. (2025년 6월 12일. Setup → Guided Slack Setup)
- **Use Salesforce Channels to Collaborate Directly in Records Via Slack** — Salesforce 레코드에 Slack 컴포넌트를 추가해 Salesforce·Slack 양쪽에서 대화 접근. (2025년 6월 12일. Setup → Slack Channels for Records)
- **Quickly See Unread Message in Salesforce Channels** — Salesforce 채널의 읽지 않은 메시지 표시. (2025년 8월 19일)
- **Use Agentforce Agents in Salesforce Channels** — Salesforce 채널에서 Agentforce 에이전트를 멘션하면 Slack처럼 응답. (2025년 8월 19일. 채널 헤더 Manage Members)

---

## 관련 노트

- [[Summer '25]] — 상위 릴리즈 허브 (전체 요약·주요 신기능)
- [[Summer '25/Release Updates]] — 강제 적용(Release Update) 시점 단일 출처 (SAML·API v21–30·ICU·CDN·Legacy Host Names 등)
- [[Summer '25/Development]] — 개발자 spoke (Apex 네임스페이스·Crypto·`Auth.UserData`·LWC·ConnectApi·2GP 패키지 변환 GA)
- [[2GP — Push Upgrade]] — 2GP 마이그레이션 GA 연계 (푸시 업그레이드 절차)
