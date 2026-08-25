---
tags: [release, winter_27, platform, security, automation, flow, hyperforce, admin]
api_version: v68.0
release_date: 2026-10
created: 2026-08-25
source: help.salesforce.com Salesforce Winter '27 Release Notes (release=264, Tier 2)
aliases: [Winter '27 Platform, 윈터27 플랫폼, Flow Test Mode Beta, Mock Outputs Beta, Flow Tags, Flow Edit History, Salesforce Cosmos Theme Flow Builder, User Context Enforces User Permissions, Tenant-Specific Trust Stores, Security Health Review, Data Detect Data 360, Hyperforce GCP, Experience Delivery 중단, Agentforce Voice Employee Agents GA, Advisements Beta, Salesforce Pricing Connect REST, Document Playbooks]
---

# Winter '27 — Platform (Security · Automation/Flow · Hyperforce · Experience Cloud · Mobile · CMS · Contracts)

> Winter '27(v68.0)의 정책·설정·인프라 변경 — Flow Builder 전면 개편(Cosmos 테마·Edit History·그룹화·Flow Tags)과 Test Mode(Beta)·Mock Outputs(Beta), `User Context–Enforces User Permissions` 실행 컨텍스트, Connected App → External Client App 전면 이행, Tenant-Specific Trust Store, Security Health Review, Data Detect의 Data 360 확장, Hyperforce 18개국·GCP 예고, Experience Delivery(Beta) 중단, Agentforce Voice for Employee Agents(GA). **이번 릴리즈부터 Customization · Deployment · Development · Experience Cloud · Mobile · Salesforce CMS 릴리즈 노트가 Platform 섹션으로 통합됐다.** 강제 시점은 [[Winter '27/Release Updates]]가 단일 출처.

---

## 개요

이 노트는 **정책·설정·인프라(Security/Identity/Privacy, Automation/Flow, Hyperforce, Salesforce Overall, Experience Cloud, Setup with Agentforce, Mobile, CMS, Connect, Contracts, Document Generation, Knowledge, Pricing)** 관점의 Winter '27 변경을 다룬다. 근거는 help.salesforce.com Winter '27 릴리즈 노트(`release=264`)에서 추출한 **140개 페이지(리프 및 허브)**다.

- **상위 허브:** [[Winter '27]] — 전체 릴리즈 요약·커버리지·주요 신기능
- **개발자(코드·클래스·API) 변경:** [[Winter '27/Development]] — Apex heap 한도·Elastic Limits(Beta)·Apex Symbol API(Beta)·LWC v68.0·API/Metadata/Tooling 카탈로그
- **강제 적용(Release Update) 시점:** [[Winter '27/Release Updates]] — **강제 시점 단일 출처.** 본 노트의 Release Update 항목은 내용만 요약하고 **날짜·강제 릴리즈는 일절 적지 않는다**(OAuth 항목처럼 양쪽에 등장하는 것은 그쪽 표가 정본)
- **AI/에이전트 변경:** [[Winter '27/Agentforce]] — Agentforce 빌더·모델·Voice 등
- **클라우드 제품 변경:** [[Winter '27/Clouds]] — Sales·Service·Marketing·Industries 등 클라우드 제품 spoke

> **분류 원칙:** 정책·설정·인프라 = Platform / 코드·CLI·클래스·SDK = Development. 따라서 Platform 섹션에 속하지만 코드성인 Apex·API·Lightning Components·Platform Development Tools 항목은 본 노트에서 위임 표기만 하고 상세는 [[Winter '27/Development]]에 둔다.

---

## 구조 변화 — Platform 섹션으로의 통합 (이번 릴리즈에서 바뀐 것)

Winter '27 릴리즈 노트의 **루트 랜딩 페이지**(Salesforce Winter '27 Release Notes)가 "Changes to the Release Notes" 항목에서 이 통합을 직접 밝힌다.

> "We consolidated sections so that Platform includes release notes for **Customization, Deployment, Development, Experience Cloud, and Mobile & Salesforce CMS**."
> — Winter '27 릴리즈 노트 루트 랜딩 페이지 원문

즉 이전 릴리즈에서 최상위 섹션이던 **여섯 개 영역**(Customization · Deployment · Development · Experience Cloud · Mobile · Salesforce CMS)이 Platform 섹션 안으로 들어왔다. 루트 랜딩 페이지의 목차는 이 여섯 영역 항목에 모두 같은 안내 문장을 달아 두었다. 그중 이번 추출에서 **각 영역의 최상위 페이지 자체를 확인한 세 곳**은 그 페이지에 안내 문장 + Platform 링크만 남아 있다.

| 영역 (최상위 페이지를 직접 확인) | 최상위 페이지 원문 |
|---|---|
| **Experience Cloud** | "Experience Cloud release notes now appear in a **dedicated Platform section**, making it easier to find infrastructure, API, and foundational updates." |
| **Mobile** | "Mobile release notes now appear in a **dedicated Platform section**, making it easier to find infrastructure, API, and foundational updates." |
| **Salesforce CMS** | "Salesforce CMS release notes now appear in a **dedicated Platform section**, making it easier to find infrastructure, API, and foundational updates." |

Platform 섹션이 직접 나열하는 하위 영역은 다음과 같다.

```text
// 구조 예시 — 실제 동작 코드 아님 (Winter '27 Platform 섹션의 하위 영역 맵)
Platform
├── AgentExchange · AgentExchange Partners
├── Apex ............................ → [[Winter '27/Development]]
├── API (v68.0) ..................... → [[Winter '27/Development]]
├── API Catalog (MCP 서버 등록·활성화)
├── Enterprise Messaging (CDC · Event Bus · Platform Events)
├── Experience Cloud ................ ← 이전 릴리즈에서는 별도 최상위 섹션
├── External Services (스키마가 any 타입 지원)
├── General Setup (Request Approvals · Orchestration Work Guide · 인라인 편집 설정 2종)
├── Globalization (12개 언어 라벨 번역 · ICU 로케일)
├── Lightning App Builder (Dynamic Highlights Panel의 Follow 버튼)
├── Lightning Components ............ → [[Winter '27/Development]]
├── Salesforce Lightning Design System (SLDS)
├── Mobile .......................... ← 이전 릴리즈에서는 별도 최상위 섹션
├── Platform Development Tools (Salesforce DX)
├── Platform Licensing and Digital Wallet
├── Permissions and Sharing (소유권 이전 시 수동 공유 유지 선택 · 관련 Release Update 2건)
├── Salesforce CMS .................. ← 이전 릴리즈에서는 별도 최상위 섹션
├── Salesforce Connect (cross-org 어댑터의 named credential 지원)
├── Salesforce Functions (구매·갱신 불가 — 은퇴 계획)
└── New and Changed Items for Developers → [[Winter '27/Development]]
```

> **읽는 법:** 위 여섯 영역은 이번 릴리즈에 **없어진 것이 아니라 Platform 섹션 안으로 들어갔다.** 릴리즈 노트 목차에서 Customization·Deployment 항목이 보이지 않아도 기능이 폐지된 것이 아니므로, 해당 내용은 Platform 트리 안에서 찾는다.

---

## ⚠️ 활성화 전제조건 한눈에 (Setup 토글만으로는 안 되는 것들)

아래 항목은 릴리즈 노트가 **명시적으로** 추가 라이선스·권한 세트·조직 preference·Salesforce 측 승인을 요구한다고 밝힌 것들이다. 기능 설명만 읽고 "Setup에서 켜면 된다"고 판단하면 막힌다.

| 기능 | 릴리즈 노트가 요구하는 전제 |
|---|---|
| **Security Health Review** | **Signature Success 고객으로 접근 제한.** Health Assessments Agent는 **Salesforce Foundations add-on** 필요. 접근 문의는 Salesforce account executive |
| **Scan Data 360 for Sensitive Data with Data Detect** | **Salesforce Shield add-on 구독 또는 Data Detect add-on 라이선스** + **Data 360 라이선스(Data Cloud Provisioning, Data Spaces, Storage Beyond Allocation)**. Data 360이 프로비저닝되고 DLO에 레코드가 있어야 함. 사용량은 **Data Queries usage type 크레딧** 소비 |
| **Create Data Detect Policies (Guided Flow)** | Salesforce Shield 또는 Data Detect **라이선스** |
| **Tenant-Specific Trust Stores** | **Manage Certificates** 사용자 권한 |
| **Build Flows Faster with Auto-Generated Element Labels** | **Agentforce 라이선스 필요** |
| **See Agent Actions and Tools Without Leaving Flow Builder** | **Agentforce for Sales · Agentforce for Service · Agentforce Platform add-on 중 하나.** 구매는 account executive |
| **Test Mode (Beta) · Mock Outputs (Beta)** | Setup → **Process Automation Settings → Flow Test Mode (Beta)** 를 먼저 켜야 함 |
| **Generate Flow Test Scenarios with Agentforce for Flow** | **Agentforce Platform Developer and Admin 권한 세트 라이선스(PSL)** + **Agentforce Developer and Admin Tools 권한 세트**. AI 터미널을 조직에 연결해야 하며, `use isolated data...` 프롬프트는 **Test Mode(Beta)가 켜져 있어야** 동작 |
| **Manage Marketing Object Records Directly in Flows** | Marketing Objects에 대한 **Read·Create·Edit·Delete** 권한 |
| **Personalize Paths** | **Marketing Cloud Advanced Edition 전용** + **Add Path Experiment Element to Flows** 권한(Marketing Admin·Marketing Manager 권한 세트에 포함). **engagement signal은 별도로 셋업**해야 함 |
| **Request Approvals · Orchestration Work Guide 구성** | Lightning App Builder는 **Customize Application**, Experience Cloud는 **사이트 멤버 + Create and Set Up Experiences 권한** 또는 사이트 멤버 + experience admin |
| **Delete Approval Submission Records** | **Approval Admin 또는 Modify All Data** 권한 |
| **동기 background step (승인·오케스트레이션)** | 자동 적용 아님 — **API 버전을 68.0 이상으로 올려야 opt-in**됨 |
| **Enforce User Permissions (User Context)** | **API 버전 68.0 이상**으로 실행되는 flow에만 적용 |
| **Global Selective Routing** | 최초 활성화는 **Salesforce Customer Support에 요청 → 승인 후** 자체 전환 가능 |
| **Hyperforce on GCP** | 인프라 배치는 Salesforce가 결정. 규제·계약상 특정 클라우드를 배제해야 하면 **account team에 문의** |
| **Cloudflare CDN 마이그레이션 · Setup with Agentforce · Org Health 대시보드** | Enterprise·Performance·Unlimited·Developer **+ Foundations 또는 Agentforce 1** |
| **Create Related List Enrichments with Agentforce for Setup** | **Data 360** Developer·Enterprise·Performance·Unlimited 에디션 |
| **Agentforce Voice for Employee Agents (GA)** | voice가 켜진 **employee agent 접근 권한** — 해당 **권한 세트 할당** 필요. **employee agent 전용**(다른 agent 타입 미지원) |
| **Document Playbooks** | **Agentforce Revenue Management(구 Revenue Cloud)** 의 Enterprise·Performance·Unlimited 에디션 + **Revenue Cloud Advanced 라이선스** 또는 **Salesforce Contracts 라이선스 + Data 360 라이선스**. **Document Playbook Management 조직 preference** ON. 권한 세트 **Document Playbook Designer**(작성)/**Document Playbook User**(사용) |
| **Contract Risk Analysis** | 위 라이선스 + **Data 360 · Einstein Foundations 라이선스**. 권한 세트 **CLM Runtime User · Prompt Template User · Contracts AI User · Microsoft 365 Word User · Document Playbook User** 전부. **활성 document playbook** 존재 + **Contract Risk Analysis 조직 preference** ON |
| **Author Contracts in Government Cloud** | **Agentforce Revenue Management(구 Revenue Cloud)** 의 Enterprise·Performance·Unlimited·Developer 에디션 + **Revenue Cloud Advanced 또는 Salesforce Contracts 라이선스**. 활성화 전에 **account team과 함께 Context Service·Document Processing Engine이 조직에 온보딩됐는지 확인** |
| **Add Clauses to Quotes from Your Clause Library** | **Agentforce Revenue Management(구 Revenue Cloud)** 의 Enterprise·Performance·Unlimited·Developer 에디션 + **Revenue Cloud Advanced 또는 Salesforce Contracts 라이선스** |
| **Track Recipient Signing Progress for Document Envelopes** | **Agentforce Revenue Management(구 Revenue Cloud)** 의 Enterprise·Performance·Unlimited·Developer 에디션 + **Revenue Cloud Advanced 또는 Salesforce Contracts 라이선스** |
| **Generate Documents That Include Tables in Rich Text Fields** | ⚠️ 위 Contracts 항목들과 **라이선스 조합이 다르다** — **Agentforce Revenue Management(구 Revenue Cloud)** 의 Enterprise·Performance·Unlimited·Developer 에디션 + **Revenue Events Starter Pack 라이선스** + **Revenue Cloud Advanced 또는 Revenue Cloud Billing 라이선스** |
| **Document Generation 클라우스 토큰** | **Revenue Events Starter Pack 라이선스** + **Revenue Cloud Advanced 또는 Revenue Cloud Billing 라이선스**. 작성자는 **DocGen Designer with Clause Management Permissions** |
| **Email Domain Substitution** | **기본 OFF, 사이트별 수동 ON.** sender 주소와 도메인이 **검증(verified)** 돼 있어야 하며 아니면 메일이 실패 |
| **Secondary Sender Email Address** | Setup에서 **email-sending 서브도메인 검증 선행**. 미검증 도메인의 시스템 메일은 From 주소를 검증해도 전달되지 않음 |

---

## Security · Identity · Privacy

> 이 영역의 이번 릴리즈 요지: MFA·이메일 도메인 검증 관련 보안 요구사항 예고, 패키지·배포된 connected app의 external client app 이행, Backup and Recover Next 개선, Shield의 Data Detect 확장.

### Security Enhancements — 다가오는 보안 요구사항 예고

- **Review and Comply with Upcoming Security Requirements** — 접근 제어·이메일 검증·OAuth 플로 관련 신규 요구사항 안내 페이지. Lightning Experience·Salesforce Classic·전 버전 모바일 앱. **Marketing Cloud Engagement은 요구사항이 다르다**(별도 문서 참조). 여기서 묶인 Release Update 목록:
  - 접근 제어: Block Apex Anonymous Code Execution from Managed Packages · Enable Profile Filtering · Remove Non-Public Fields from Custom Object Data in Aura Action Responses · Update Apex Code and Flows for Changed Sharing Recalculation Behavior (Aura·LWR·Visualforce 사이트를 쓰면 Conceal Personal Information Fields from Guest Users도 함께)
  - OAuth 계열: Migrate All Connected Apps to External Client Apps · Restrict the OAuth 2.0 Device Flow to Local External Client Apps · Retirement of OAuth 2.0 Username-Password Flow for Connected Apps · Salesforce Connect Cross-Org Adapter Legacy Authentication Is Being Retired · OAuth User-Agent and Hybrid User-Agent Flows Retirement
  - 이메일: 이전에 Salesforce Customer Support를 통해 사용자 이메일 검증을 껐다면 **Maintain Your Email Verification Exception (Release Update)**, Trialforce 조직 소유자는 **Identify Trialforce Email-Sending Domains That Need Verification**
  → **강제 시점은 전부 [[Winter '27/Release Updates]] 참조** (본 노트는 날짜를 적지 않는다)
- **Explore Features That Support MFA and Email Security** — Summer '26 말~Winter '27에 추가된 지원 기능 모음. Lightning Experience·Salesforce Classic·**전 버전 모바일 앱**. ⚠️ **범위와 에디션은 묶인 개별 릴리즈 노트마다 다르므로 각 항목의 릴리즈 노트를 확인해야 한다**(이 페이지 자체는 에디션을 특정하지 않는다). MFA 계열: Manage Passkeys and Security Keys With Ease · Passkey-First MFA Registration and Improved Passkey Experience · Usability Improvements for MFA Registration Pages · Enable Native Browser Authentication for iOS Before Passkey Enforcement · View Phishing-Resistant, Standard, and Weak MFA Methods in the SAML Assertion Validator · View Authentication Context Class Reference (ACR) Values in the Login History and Login Events. 이메일 계열: Track Email Address Verification Across User Domains · Set the From Address for Email Sent for Users with Unverified Domains · Send Site Emails from a Verified Address with Email Domain Substitution · Import Authorized Email Domains into a Sandbox · Specify Which Email Domains Require Address Verification.

### Identity & Access Management — Connected App의 종착지

- **Migrate All Connected Apps to External Client Apps (Release Update)** — Salesforce가 **connected app 지원을 종료**한다. Connected app은 계속 동작하지만 **버그 수정과, 이를 사용하는 통합·인가 플로에 대한 지원이 없어진다.** → 시점은 [[Winter '27/Release Updates]]
- **Restrict the OAuth 2.0 Device Flow to Local External Client Apps (Release Update)** — device flow를 **localhost 콜백 URL을 가진 local external client app으로만** 제한. 강제 후에는 connected app·packaged external client app·localhost 콜백이 없는 local external client app에서 device flow가 **동작하지 않는다.** device flow는 원래 스마트 TV·가전·IoT처럼 **입력/표시 능력이 제한된 기기용**이라는 것이 Salesforce의 설명. 전 에디션. → 시점은 [[Winter '27/Release Updates]]
- **Retirement of OAuth 2.0 Username-Password Flow for Connected Apps (Release Update)** — 이 플로를 쓰는 **모든 connected app 통합이 깨진다.** 대체: 최종 사용자 로그인은 **PKCE 확장을 적용한 OAuth 2.0 web-server flow**, 서버 간 통합은 **client credentials flow**. 직접 개발하지 않은 앱은 개발사에 문의. **Summer '26 이후 생성된 조직에서는 이미 username-password flow를 쓸 수 없고**, OAuth and OpenID Connect Settings 페이지의 허용 옵션이 비활성 회색으로 표시된다. 릴리즈 업데이트가 보이지 않는다면 이미 차단된 상태라 영향 없음. → 시점은 [[Winter '27/Release Updates]]
- **OAuth User-Agent and Hybrid User-Agent Flows Retirement (Release Update)** — user-agent / hybrid user-agent 플로 은퇴. 이유는 **액세스 토큰을 브라우저에 그대로 노출**하기 때문. 대체는 **PKCE를 적용한 web-server flow 또는 hybrid web-server flow.** 관리 패키지에서 설치한 앱 등 직접 개발하지 않은 앱은 개발사에 문의. → 시점은 [[Winter '27/Release Updates]]
- **Migrate Packaged and Distributed Connected Apps to External Client Apps** — connected app **migration tool**이 이제 **1GP·2GP 관리 패키지에 패키징된 connected app**과 **외부 조직/다른 내부 조직에 배포된 미패키지 connected app**까지 처리한다. **고객의 OAuth 플로·토큰·활성 세션은 패키지 업그레이드를 거쳐도 유효**하므로 재구성·재인가가 필요 없다. Group·Essentials·Professional·Enterprise·Performance·Unlimited·Developer. 실행: **Setup → App Manager → 해당 connected app → [Migrate to External Client App]** → 자동으로 packaged external client app 생성.

### Domains

- **Replace Instanced URLs in API Traffic** — 인스턴스명이 바뀌는 인프라 업데이트로 인한 장애를 막기 위해 API 트래픽의 instanced URL을 조직의 **My Domain 로그인 URL**로 교체. **이번 릴리즈에서 샌드박스의 해당 트래픽이 중단된다.** Lightning Experience·Salesforce Classic(모든 조직 제공 아님), **Database.com 제외 전 에디션.** 관련 Release Update(Update Instanced URLs in API Traffic) 시점은 [[Winter '27/Release Updates]]
- **Manage Custom Domains More Easily by Using a Stable Target Host Name** — 서드파티 프록시·CDN이 커스텀 도메인을 서비스하고 조직이 Salesforce Edge Network를 쓰는 경우, 서드파티 제공자와 함께 도메인의 **target host name을 조직의 My Domain 로그인 URL로 갱신**한다. 적용 범위는 Salesforce Sites와 Aura·LWR·Visualforce 사이트(Enterprise·Performance·Unlimited), **도메인 구성이 "Use a third-party service or CDN to serve the domain"인 커스텀 도메인만.** 상세는 아래 [Experience Cloud](#experience-cloud) 의 동일 항목 참조.

### Named Credentials · 인증서 신뢰 저장소

- **Expand Integrations with Named Credentials Support for Custom CA Certificates** — named credential이 **사설·내부 CA가 서명한 인증서를 쓰는 서버**와도 보안 연결을 맺을 수 있다. 이전에는 서버 인증서가 Salesforce가 신뢰하는 root authority로 체인되지 않으면 콜아웃이 실패했다. Lightning Experience·Salesforce Classic(모든 조직 제공 아님), Enterprise·Performance·Unlimited·Developer.
  - **원리(릴리즈 노트 설명):** TLS 핸드셰이크는 앱 수준 인증보다 **먼저** 일어난다. 엔드포인트 인증서가 Salesforce가 이미 신뢰하는 root CA로 체인되지 않으면 **OAuth 토큰·API 키 등 named credential에 무엇을 설정했든 요청 자체가 나가지 않고** 핸드셰이크가 실패한다. 발급 root 인증서를 업로드하면 이후 그 엔드포인트로의 모든 콜아웃에서 해당 trust store를 존중한다.
- **Manage Your Security Posture with Tenant-Specific Trust Stores** — 공유 글로벌 trust store 대신 **조직 자체의 root 인증서**를 관리. Setup의 **Certificate Trust Store** 페이지에서 목록·업로드·다운로드·삭제. Enterprise·Performance·Unlimited·Developer, **Manage Certificates 권한** 필요.

```text
// 구조 예시 — 실제 동작 코드 아님 (Certificate Trust Store의 수치·제약, 릴리즈 노트 기준)
조직당 non-expired 인증서 최대 :  50개
만료 사전 알림(관리자 이메일)  :  60일 · 30일 · 10일 전
업로드 지원 포맷               :  PEM(Privacy Enhanced Mail) · DER(Distinguished Encoding Rules)
적용 범위                      :  Named Credentials 통합 "전용"
                                 (그 밖의 모든 외부 연결은 Salesforce 관리 글로벌 trust store의 root 인증서 사용)
변경 기록                      :  Setup Audit Trail에 자동 로그
```

  - Setup 페이지 기능 순서(릴리즈 노트 How): ① 인증서 메타데이터 조회 ② 활성/만료 임박 기준 필터 ③ 만료 임박·비활성 등 중요 조건 하이라이트 ④ PEM/DER 업로드 ⑤ 다운로드·삭제.

### Security Health Review — PDF에서 Setup 내장 리포트 뷰어로

**Security Health Review**가 PDF 전용 경험을 대체해 **Setup에 내장된 인터랙티브 리포트 뷰어**로 바뀌었다. 조직 보안 태세를 지속적·실행 가능한 형태로 보여주고 findings 관리·remediation 추적·disposition 워크플로를 제공하며, 모든 리포트·disposition·remediation 작업이 **전체 audit trail**로 기록된다. Lightning Experience, Enterprise·Unlimited. **접근은 Signature Success 고객으로 제한**되고 Health Assessments Agent는 **Salesforce Foundations add-on**을 요구한다. 기본 접근 권한은 **Customize Application 또는 Modify All Data** 보유자이며, 추가 사용자에게는 **View Health Assessments** 또는 **Manage Health Assessments** 권한을 할당한다.

| 신규 기능 (New Capability) | 동작 (What It Does) |
|---|---|
| **Interactive report viewer** | Setup에서 리포트를 렌더링 — Executive Summary, severity 타일, remediation 진행 바, 전체 findings 테이블. 이전 리포트로 전환하려면 **Viewing** 드롭다운 사용 |
| **PDF and CSV export** | 임원 보고용 **PDF**, Salesforce 외부 데이터 분석용 **CSV**로 다운로드 |
| **Salesforce Mandated Critical Controls** | 필수 통제 항목이 severity 계층과 분리되어 리포트 **최상단**에 표시. **이 항목들은 disposition할 수 없다** |
| **Findings tab** | 활성 findings를 severity·security domain·remediation status로 필터·검색. CSV로 내보내기 |
| **Remediation tracking** | 개별 finding의 진행 상태(Open, In Progress, Blocked)를 기록 — **활성 severity 카운트에는 영향을 주지 않는다** |
| **Disposition** | finding을 공식적으로 제외할 때 **Accept Risk · Mitigated by Alternative Control · Not Applicable** 사용. disposition된 finding은 Customized Controls 탭으로 이동 |
| **Customized Controls tab** | disposition된 모든 finding을 disposition 유형·분류한 사용자·만료일과 함께 나열 |
| **Compliant Controls tab** | **Ideal Salesforce Org Security Hardening Benchmark**를 통과한 모든 통제 항목 나열 |
| **User Activity Log** | 리포트 생성·disposition·remediation 작업의 전체 audit trail — timestamp·사용자·finding ID 포함 |

### Salesforce Shield — Data Detect

- **Scan Data 360 for Sensitive Data with Data Detect** — Data Detect가 **Data 360의 Data Lake Object(DLO)** 를 스캔한다. DLO를 선택하면 **모든 text 필드를 자동 대상**으로 삼고, **단일 스캔 정책이 여러 data space에 걸쳐 최대 100개 DLO**를 지원해 민감 데이터 노출을 통합 뷰로 본다. 중단된 Data 360 스캔은 **재개(resume)** 가능. Lightning Experience, Enterprise·Performance·Unlimited·Developer. 전제조건과 크레딧 소비는 위 **활성화 전제조건 한눈에** 표 참조.
- **Create Data Detect Policies More Easily with a Guided Flow** — 정책 상세 입력·오브젝트 선택·스캔 기준 정의를 **하나의 guided flow**로 통합. 오브젝트를 한 번의 클릭으로 개별 선택하거나 일괄 선택하고, 필터가 오브젝트 목록·필드 수에 미치는 영향을 **같은 화면에서** 확인한다. 이전에는 정책을 먼저 만든 뒤 오브젝트 추가·스캔 기준 정의를 별도 작업으로 해야 했다. Lightning Experience, Enterprise·Unlimited·Developer(Shield 또는 Data Detect 라이선스). 실행: Data Detect → **Policies** 탭 → **New Policy**.

### Backup and Recover Next

- **Download Metadata from Backup Snapshot** — 백업의 메타데이터를 **XML 형식 unmanaged package를 담은 ZIP 파일**로 다운로드해, 선호하는 배포 도구로 삭제·손상된 컴포넌트를 수동 재구축 없이 복구한다. 패키지 메타데이터는 **Metadata API 또는 Salesforce CLI**로도 조회 가능. Lightning Experience, Enterprise·Unlimited·Developer. 실행: Backup and Recover Next 앱 → **Backups** 탭 → 대상 메타데이터 백업 선택 → **Download ZIP File**.
- **Find Specific Records Across Your Backup History** — 백업 데이터에서 키워드·문구를 포함한 레코드를 검색. 오브젝트·백업 날짜 범위·필드 조건으로 범위를 좁히고, 각 결과는 **레코드의 특정 버전**을 식별하며 그 버전이 발견된 백업 날짜들을 보여준다. 실행: **Activities** 탭 → **Search Data** → 검색어 입력 + 오브젝트·날짜 범위 선택. **Share·History·Feed 오브젝트를 포함**하거나 필드 조건을 추가해 결과를 정제할 수 있고, 백업 목록/백업 상세 페이지에서 시작하면 백업·오브젝트 선택이 미리 채워진다. Enterprise·Unlimited·Developer.
- **Reload Failed Child Objects Before Running a Restore** — 자식 오브젝트를 포함한 복원에서 일부 오브젝트가 로드에 실패하면, **복원 activity를 다시 시작하지 않고** 실패한 자식 오브젝트만 reload해 복원 실행 전에 포함시킨다. 이전에는 로드 실패한 오브젝트가 복원에서 **제외**됐다. 실행: preview restore에서 실패 오브젝트 선택 → **Reload Objects**.

### 기타 보안 변경

- **Allow Chrome Extensions as Trusted URLs** — **Chrome 확장 URI**를 trusted URL로 추가해 어떤 확장이 Experience Cloud 사이트와 상호작용할지 제어. Lightning Experience, Professional·Enterprise·Unlimited. Setup → Trusted URLs → **New Trusted URL** → **소문자 a–p만 사용하는 32자 Chrome extension ID** 입력. **와일드카드 미지원.**

```text
# 출처: Winter '27 릴리즈 노트 rn_security_allow_chrome_extensions (형식 예시 원문 그대로)
chrome-extension://abcdefghijklmnopabcdefghijklmnop
```

### Setup Audit Trail

- **View Setup Audit Trail Permission to Access Setup Audit Trail (Release Update)** — Setup Audit Trail 접근을 전용 **View Setup Audit Trail** 권한으로 제어한다. 관리자는 더 넓은 **View Setup** 권한을 주지 않고도 접근을 부여할 수 있어 **최소 권한 원칙**을 지원한다. **기존 접근 권한은 자동으로 보존**되며, Salesforce는 이미 View Setup을 가진 **모든 프로파일·권한 세트에 View Setup Audit Trail을 자동으로 활성화**한다. 신규 프로파일·권한 세트·사용자에게는 **명시적으로** 활성화해야 한다. **Salesforce 관리자(admin)는 영향받지 않는다.** Lightning Experience·Salesforce Classic, Professional·Enterprise·Performance·Unlimited·Developer. → 강제 시점은 [[Winter '27/Release Updates]]

> 개념·조회 방법은 [[Setup Audit Trail (설정 감사 추적)]] 참조.

---

## Automation / Flow

> Winter '27 Automation은 이번 릴리즈 Platform 영역에서 가장 큰 덩어리다(추출 51페이지). Flow Builder UI 전면 개편, 저장 시점 검증(에러 처리), 화면 플로우 대량 처리, Marketing Cloud 플로우, 그리고 **Test Mode(Beta)** 중심의 테스트·디버그 재편이 핵심이다.
>
> **8월 릴리즈 노트 변경 이력(원문 기록):** *Screen Flows: Set the Window Size for a Screen Flow Quick Action* 은 **2026년 8월 17일 주에 삭제됨**("This feature isn't quite ready yet, so we removed it for now"). *Flows: Group Elements to Organize and Simplify Flows* 는 같은 주에 When 섹션이 추가됨. — 상위 요약 문단에는 window size 항목이 아직 남아 있으나 **기능 자체는 철회된 상태**다.

### Flow Builder 업데이트

- **Find Flow Elements Faster with Intent-Based Categories and Smart Search** — 릴리즈 노트의 **Automation 허브와 Flow Builder 허브가 나란히 이번 릴리즈 Flow Builder의 첫 번째 변경으로 내세우는 항목**이다. 원문: *"Find flow elements faster with intent-based categories and smart search."* — 요소 목록이 **의도(intent) 기반 카테고리**로 묶이고 **smart search**가 더해져 원하는 요소를 더 빨리 찾는다. ⚠️ **두 허브의 요약 문장에만 등장하고 전용 리프 페이지가 없어**, Where(에디션)·How 등 상세는 릴리즈 노트에서 확인되지 않았다.
- **Experience Flow Builder in the Modern Salesforce Cosmos Theme** — Flow Builder가 조직의 활성 테마를 자동으로 따라가며 Salesforce 전체와 시각적으로 일관된 **Cosmos 테마**(넓어진 간격·갱신된 색상 팔레트)를 적용한다. 추가 구성·셋업 불필요. **단 Flow Builder는 SLDS 2 Dark Mode를 지원하지 않는다.** Lightning Experience, Essentials·Professional·Enterprise·Performance·Unlimited·Developer.
- **See More of Your Flow with a Denser Canvas** — 캔버스가 더 조밀해져 스크롤·줌 없이 더 많은 플로우를 본다. 요소 카드는 **element type과 API name을 info 툴팁**으로 표시(시각적 잡음 감소), **End 요소는 전체 카드가 아닌 아이콘**으로 바뀌어 구성할 것이 없음을 명확히 한다. Lightning Experience, Essentials·Professional·Enterprise·Performance·Unlimited·Developer. 실행: Flow Builder에서 아무 플로우나 열면 조밀해진 캔버스가 보이며, **요소 타입을 보려면 요소 카드의 info 아이콘 위에 마우스를 올린다.**
- **Track Flow Changes Over Time with Edit History** — 버전을 지원하는 플로우에서 **각 저장의 타임라인**을 보고, 변경 내용을 미리 보고, 이전 로직을 복원한다. 요소 수준 상세로 드릴다운하거나, 과거 저장 지점에서 **새 버전 생성(Save as New Version)** 또는 **다른 플로우로 로직 복사(Save as New Flow)**. Enterprise·Performance·Unlimited·Developer.
- **Build Flows Faster with Auto-Generated Element Labels** — 구성한 속성을 기반으로 요소 라벨을 **자동 생성**하고, 작업하는 동안 자동 갱신한다. **직접 수정한 라벨은 보존**된다. Group·Essentials·Starter Suite·Pro Suite·Professional·Enterprise·Performance·Unlimited·Developer. **⚠️ Agentforce 라이선스 필요.** 속성 패널을 닫을 때 라벨이 생성·갱신된다.
- **Group Elements to Organize and Simplify Flows** — 관련 요소를 **이름 붙인 접이식 그룹**으로 묶어 복잡한 플로우를 단순화. auto-layout 모드에서 **Add to Flow → Group** → 이름·설명 입력 → 그룹 안에 요소 추가. 그룹 헤더의 collapse 아이콘으로 내용 표시/숨김을 전환하며, **접힘/펼침 선호는 자동 저장**된다. Lightning Experience·Salesforce Classic, Essentials·Professional·Enterprise·Performance·Unlimited·Developer. **Winter '27부터 rolling 제공.**
- **Clean up Flows Faster with the Unused Resources Filter** — Toolbox의 새 **Unused** 필터로 사용 기록이 없는 리소스만 추려낸다. Toolbox의 **Filter → Unused**, 해제하면 원복되고 **Flow Builder를 닫아도 필터가 해제**된다. **auto-layout에서만 제공.** Essentials·Professional·Enterprise·Performance·Unlimited·Developer.
- **Navigate and Configure Decision Elements More Easily** — 경로 하이라이팅·크기 조절 가능한 패널·인라인 경로명 편집. 캔버스의 경로를 클릭하면 속성 패널에서 해당 outcome이 하이라이트되며 조건이 보이고, 패널 가장자리를 드래그해 크기를 조절하며, **경로 이름은 캔버스에서 더블클릭해 변경**한다. Lightning Experience, Essentials·Professional·Enterprise·Performance·Unlimited·Developer.
  - **왜(원문 Why):** Decision outcome이 많은 복잡한 플로우에서는 **캔버스 경로와 조건을 짝지어 보는 일과 속성 패널에서 경로 이름을 바꾸는 일에 추가 내비게이션이 든다.**
- **Navigate Flow Comparison Results More Easily** — Flow Version Comparison 결과 뷰 개선. 비교 테이블의 **요소 이름 라벨이 클릭 가능**해져 크기 조절 가능한 사이드 패널에 전체 변경 상세를 연다. 잡음을 줄이기 위해 **Change Details 컬럼은 제거**됐고, 선택 드롭다운의 플로우 버전이 **논리적 순서**로 나열된다. Professional·Enterprise·Performance·Unlimited·Developer.
- **Compare Versions of Data 360 and Agentforce Marketing Flows** — Flow Version Comparison이 **Data 360-triggered flow**와 **Agentforce Marketing flow 타입**(segment-triggered, automation event-triggered, API event-triggered)을 지원한다. segment-triggered flow의 **모든 audience source**에서 동작하며 **테이블 뷰와 캔버스 뷰 양쪽**에서 변경을 보여준다. Starter Suite·Marketing Cloud Growth·Marketing Cloud Advanced, **그리고 Data 360이 활성화된 모든 조직.**
- **Navigate Flow Builder More Efficiently with Keyboard Shortcuts** — auto-layout 캔버스를 **화살표 키**로 요소 간 이동(**fault path 및 기타 분기 경로 포함**), 요소의 **잘라내기·복사·붙여넣기**를 OS 표준 단축키로. Tab 내비게이션 대신 사용한다. Lightning Experience·Salesforce Classic, Starter Suite·Pro Suite·Essentials·Enterprise·Performance·Unlimited·Developer.
- **Keep End Elements Right Where You Placed Them** — auto-layout에서 저장할 때마다 **end 요소가 플로우 메타데이터에 자동 저장**된다(셋업·별도 조치 불필요). 이전에는 메타데이터에 end 요소가 없어 Flow Builder가 열 때마다 캔버스에 생성했고 저장·재로드 시 배치가 흐트러졌다. 이제 캔버스 레이아웃이 유지되고, **모든 end 요소가 XML에 명시적으로 나타나** 메타데이터를 읽는 도구가 플로우의 종료 지점을 완전히 파악한다. **기존 플로우는 다음 저장 시** 명시적 end 요소가 메타데이터에 추가되며, 저장 후 다시 열면 end 요소가 저장된 위치에 나타난다. Lightning Experience, Essentials·Professional·Enterprise·Performance·Unlimited·Developer.
- **See Agent Actions and Tools Without Leaving Flow Builder** — Flow Builder 캔버스의 agent 정보 패널에서 **action 이름·타입·설명(및 API 이름)** 을 직접 확인 — 전체 레코드를 열거나 Agentforce Builder로 이동할 필요가 없다. 이 뷰는 **Agentforce Builder에서 마지막으로 구성된 상태를 포함해 agent의 현재 상태**를 반영한다. 실행: **Run Agent** 요소 선택 → agent 선택 → 정보 패널 확장. Enterprise·Performance·Unlimited·Developer + **Agentforce for Sales / for Service / Agentforce Platform add-on.**
- **Enforce User Permissions No Matter How a Flow Runs** — 새 실행 컨텍스트 옵션 **User Context–Enforces User Permissions**. screen flow와 autolaunched flow에서 사용 가능하며, **무엇이 실행하든 항상 실행 사용자의 접근 수준으로 동작**한다. Professional·Enterprise·Performance·Unlimited·Developer.
  - **⚠️ API 버전 68.0 이상으로 실행되는 플로우에만 적용된다.**
  - **이전 동작:** user context로 구성된 플로우가 호출자(다른 flow·Apex·자동화)로부터 **system 수준의 상승된 권한을 상속**받아, system context 호출자가 실행하면 user context 플로우도 system context로 실행됐다.
  - 실행: Flow Builder → **Save → Show Advanced → How to Run the Flow → User Context–Enforces User Permissions** → 저장.
  - 민감한 작업을 다루거나 호출자의 상승된 권한을 **절대 상속하면 안 되는** 플로우에 사용한다.

### Flow 에러 처리 — 실행 전에 잡기

- **Catch Field Length Violations When You Save a Flow** — Assignment 요소가 레코드 필드에 **최대 길이를 초과하는 고정 텍스트 값**을 설정하면 저장 시 검증 패널에 경고를 표시하고 **문제 필드와 초과 값**을 알려준다. **Flow Builder는 그래도 저장하지만, 실행 시 플로우는 실패한다.** 더 짧은 값으로 바꾸거나 변수를 쓰고 다시 저장하면 경고가 사라진다. **검증 대상은 고정 텍스트 값을 쓰는 Assignment 요소뿐** — 변수 참조나 다른 리소스는 실행 전에 값을 알 수 없어 지원하지 않는다. Professional·Enterprise·Performance·Unlimited·Developer.
- **Catch Missing Required Fields When You Save a Flow** — **레코드 변수를 사용하는 Create Records 요소**에 필수 필드 할당이 빠지면 저장 시 경고. 이전에는 어떤 필수 필드가 빠졌는지 알려주지 않아 실행이 실패해야만 발견됐다. **디자인 타임에 판정 가능한 할당만 검사**하며, 필수 필드가 입력 변수나 subflow로 채워지는 경우에는 값을 알 수 없어 검사하지 못한다. Lightning Experience, Professional·Enterprise·Performance·Unlimited·Developer.
- **Reduce Limit Failures in Scheduled Flows with Dynamic Batch Sizing** — scheduled flow와 scheduled path가 **CPU·SOQL·heap 한도 오류**에 걸리면 **직전 배치 크기의 절반으로 자동 재시도**한다. 처리 가능한 크기를 찾을 때까지 계속 절반으로 줄인 뒤, 남은 레코드를 그 크기의 배치로 완료한다. Lightning Experience·Salesforce Classic, Group·Starter Suite·Pro Suite·Essentials·Professional·Enterprise·Performance·Unlimited·Developer. 실행: Flow Builder → **Start** 요소 구성에서 dynamic batch size 옵션을 켠다.
- **Reduce Flow Failures Caused by Record Lock Contention** — 트랜잭션 초기화 중 레코드 잠금 오류가 나면 플로우가 **10초 대기 후 자동 재시도**한다. 이전에는 다른 프로세스와 동시에 같은 레코드를 갱신할 때 `UNABLE_TO_LOCK_ROW` 오류로 실패했다. Lightning Experience·Salesforce Classic, Essentials·Professional·Enterprise·Performance·Unlimited·Developer.

> 기존 에러 처리 패턴(fault path·오류 이메일)은 [[Flow 에러 처리]], [[Flow 디버깅과 모니터링 - 오류 이메일·인터뷰]] 참조.

### Screen Flow

- **Process Multiple Records with Screen Flows from List Views and Related Lists** — **리스트 뷰 또는 관련 목록의 mass quick action**으로 screen flow를 트리거하고 **선택된 레코드 ID들**을 받아 대량 작업을 수행한다. 실행: Setup → **Object Manager** → 대상 오브젝트 → Buttons, Links, and Actions에서 기존 Flow 액션을 쓰거나 type이 **Flow**인 액션 생성 → **리스트 뷰**는 **List View Button Layout** 페이지에, **관련 목록**은 **Page Layouts**의 해당 related list에 액션을 추가. Professional·Enterprise·Performance·Unlimited·Developer.
- **Capture Time Values with the Time Component** — 화면에 **Time 컴포넌트**를 추가해 서비스 약속·예약 등 시간 값을 입력받고, 출력으로 레코드를 갱신하거나 후속 작업에 사용한다. 속성 패널에서 라벨·기본값을 구성하고, 선택적으로 **placeholder 텍스트**와 **최소/최대 시간**으로 선택 가능 범위를 제한한다. Starter Suite·Pro Suite·Enterprise·Performance·Unlimited·Developer.
- **Evaluate Conditional Visibility Rules with Reactive Formulas** — 화면의 **조건부 가시성 규칙에서 reactive formula를 직접 참조**할 수 있다. 이전에는 **같은 화면의 컴포넌트를 포함한 formula**를 조건부 가시성에서 참조할 수 없었다. Starter Suite·Pro Suite·Enterprise·Performance·Unlimited·Developer.
- **(철회) Set the Window Size for a Screen Flow Quick Action** — 상위 요약에는 남아 있으나 **2026-08-17 주에 릴리즈 노트에서 제거**됐다("아직 준비되지 않음").

> 화면 설계·컴포넌트 레퍼런스는 [[Screen Flow 설계]] 참조.

### Marketing Cloud 플로우

- **Trigger Flows Faster on Order Events with a REST API** — Event Library의 신규 이벤트 **Order Return · Order Shipment · Order Status Change** 가 주문 데이터를 담은 API 호출을 받아 플로우를 **직접** 시작한다. 처리 시간이 **7–10분 → 약 3초**로 단축된다. Event Library는 **계층형 주문 데이터용 사전 정의 스키마**를 제공해 중첩 line item을 커스텀 이벤트 구조 없이 Flow Builder에서 매핑할 수 있다. 실행: 해당 이벤트를 선택하고, 고객 정보·주문 상세·line item을 담은 **POST 요청**을 보낸다. Marketing Cloud Growth·Marketing Cloud Advanced.
- **Manage Marketing Object Records Directly in Flows** — **Get / Create / Update / Delete Records** 표준 레코드 요소에서 데이터 소스로 **Marketing Object**를 선택해 개인화 데이터를 플로우에서 직접 관리한다. Starter Suite·Marketing Cloud Growth·Marketing Cloud Advanced. **Marketing Objects에 대한 Read·Create·Edit·Delete 권한 필요.**
- **Copy an Audience Flow Without Disrupting Live Campaigns** — audience flow를 복사본으로 저장하면서 연결된 **이메일·SMS·WhatsApp·RCS 메시지**를 복제할지 원본에 연결할지 선택한다. **세그먼트와 list trigger 정의도 복사**해 각 복제본이 독립적인 시작점을 갖는다. 이전에는 복제 시 동일 자산을 재사용해 복사본을 수정하면 **운영 중인 캠페인이 의도치 않게 바뀔 수 있었다.** 기본값은 **콘텐츠(이메일·SMS 등)는 복사, 세그먼트는 조직 자산 한도를 아끼기 위해 링크**다. 복사 전에 Flow Builder가 **선택한 자산 유형에 대한 조직 quota가 충분한지 검증**한다. 실행: **Save as New Flow → Select Objects to Copy.**
- **Personalize Paths to Predict the Best Conversion Outcome** — 각 audience member를 **원하는 전환 결과를 낼 가능성이 가장 높은 경로**로 보낸다. 경로 선택은 머신러닝이 **실제 전환 결과로부터 계속 학습**해 개선된다. **Marketing Cloud Advanced Edition 전용.** 실행: **Personalize Paths** 요소 추가 → 기본 제공 성능 지표를 고르거나 커스텀 engagement signal을 성공 지표로 생성 → (선택) 관련 engagement signal 추가 → 테스트할 경로 정의(메시징 채널·콘텐츠 변형 등). **engagement signal은 별도 셋업이 필요하다.** 권한: **Add Path Experiment Element to Flows**(Marketing Admin·Marketing Manager 권한 세트에 포함).

### Flow 테스트·디버그 — Test Mode(Beta) 중심 재편

- **Test Flows in a Dedicated Test Mode (Beta)** — 빌드와 테스트를 **한 곳에서** 전환하며 수행하고, 저장한 테스트 시나리오를 재사용해 입력을 매번 다시 넣지 않는다. **autolaunched flow와 record-triggered flow**의 디버그·테스트 시나리오 저장 지원. Professional·Enterprise·Performance·Unlimited·Developer.
  - **활성화:** Setup → Quick Find `Process` → **Process Automation Settings** → **Flow Test Mode (Beta)** 선택.
  - Flow Builder에서 **Test** 클릭 → 캔버스가 테스트 뷰로 전환(테스트 시나리오 설정·기대 결과에 집중). **Test Mode에서는 플로우 편집이 제한적으로만 가능하다.**
  - 저장된 시나리오가 없으면 테스트 설정 패널이 열린다 → 입력(트리거 레코드·변수 값) 입력 → **Run Scenario** → 실행 후 **Save Scenario** 로 현재 설정을 새 시나리오로 저장. 저장된 시나리오가 있으면 열어서 설정을 보거나 편집하고, 단일 또는 **다중 시나리오 실행**이 가능하다.
  - **자동화 테스트:** **Scenario Testing Automation** 선택 → **assertion**(테스트 실행 중 평가할 조건) 추가 → 시나리오가 pass/fail을 보고한다.
  - **커버리지:** assertion이 있는 저장된 시나리오의 커버리지를 확인할 수 있다. 커버리지는 모든 요소·경로가 성공적으로 실행됐음을 보여주며, **실패한 테스트는 커버리지에 산입되지 않는다.**
  - **주의:** 저장하지 않고 테스트나 모드를 전환하면 **저장되지 않은 시나리오 변경 사항이 사라진다.** 빌드 모드로 돌아가려면 **Build** 클릭.
  - Beta 고지(원문): Beta Services Terms 또는 Unified Pilot Agreement 및 Product Terms Directory의 조건이 적용되며, 사용 여부는 고객 재량이다.
- **Test Flows in Isolation with Mock Outputs for Action and Subflow Elements (Beta)** — **Action·Subflow 요소의 mock output**을 정의해 외부 콜아웃·subflow 응답을 라이브 시스템 없이 일관되게 테스트한다. **autolaunched flow와 record-triggered flow**에서 제공. Professional·Enterprise·Performance·Unlimited·Developer.
  - **동작:** callout Action 요소를 mock하면 플로우가 **실제 HTTP 요청을 건너뛰고** 미리 정의한 응답을 사용한다. Subflow 요소를 mock하면 **참조된 플로우 실행 자체를 건너뛰고** 지정한 mock output을 사용한다.
  - **특히 유용한 경우(원문 목록):** ① rate-limit이 걸리거나 사용할 수 없는 외부 API로 HTTP 콜아웃하는 Action 요소 ② 복잡한 의존성을 가진 Apex 메서드를 호출하는 Action 요소 ③ 참조 플로우를 실행하지 않고 Subflow 요소를 포함한 플로우 테스트 ④ **라이브 데이터로 재현하기 어려운 fault path.**
  - 실행: Process Automation Settings에서 **Flow Test Mode (Beta)** 활성화 → 캔버스에서 **Test** → mock할 Action/Subflow 요소 클릭 → 속성 패널의 **Scenario Output** → **Use Mock Output** → 각 output의 mock 데이터를 정의하거나 **debug history의 이전 디버그 실행 값에서 복사** → 시나리오 저장·실행.
- **Generate Flow Test Scenarios with Agentforce for Flow** — **Agentforce for Flow Headless**가 터미널에서 Flow Builder를 열지 않고 테스트 시나리오를 작성한다. **record-triggered·autolaunched·Data Cloud-triggered flow** 지원, **success·fault·edge-case 경로**를 포괄. Professional·Enterprise·Performance·Unlimited·Developer.
  - 권한: Agentforce Vibes에서 사용하려면 **Agentforce Platform Developer and Admin 권한 세트 라이선스(PSL)** 와 **Agentforce Developer and Admin Tools 권한 세트**가 사용자에게 할당돼야 한다.
  - 사전 작업: **AI 터미널을 Salesforce 조직에 연결**하고 테스트할 플로우로 이동한 뒤 프롬프트를 입력한다.

```text
// 구조 예시 — 실제 동작 코드 아님 (릴리즈 노트에 제시된 프롬프트 문자열 그대로)
create flow tests
use isolated data for my flow tests     ← Process Automation Settings에서 Test Mode(Beta)가 켜져 있어야 함
```

  - 동작: 플로우 정의와 분기 로직을 분석해 **제안 시나리오 목록을 콘솔에 구조화해 반환** → 승인하면 시나리오를 생성해 플로우에 추가하고 **유효성 검사 후 실행**한다. 터미널이 **Flow Builder에서 시나리오를 열 수 있는 URL**을 제공한다. isolated data 프롬프트를 쓰면 조직 데이터와 분리된 **격리 테스트 데이터 세트**를 만들고 각 시나리오의 Test Scenario 패널에서 미리 볼 수 있다.
  - 릴리즈 노트가 밝힌 이점: 커버리지 보장, 사전 채워진 필드 값·정밀한 assertion으로 수작업·로직 공백 감소, **CI/CD 파이프라인에 AI 생성 시나리오 통합**, **Apex 없이** 격리 데이터 생성.
- **Test Flows with Specific Records by Entering a Record ID** — 디버거의 입력 변수에 **15자 또는 18자 정적 레코드 ID**를 직접 입력해 특정 레코드로 디버그한다. Case·Campaign Member처럼 **검색성이 제한된 오브젝트**를 lookup 결과를 뒤지지 않고 테스트할 때 유용하다. 실행 중 레코드 상세는 Flow Builder가 자동으로 가져온다. Starter Suite·Pro Suite·Enterprise·Performance·Unlimited·Developer.
- **Test Flows with Primitive and Record Collection Inputs** — 디버거에서 **레코드 컬렉션·기본형 컬렉션 입력 변수에 값을 직접 채워** 테스트한다. 이전에는 단일 입력 값만 테스트할 수 있었다. 디버거는 이 값들을 **플로우를 수정하지 않고** 테스트 실행에 사용한다. Starter Suite·Pro Suite·Enterprise·Performance·Unlimited·Developer.

> 기존 Flow 테스트 기능(Flow Test 레코드·어서션)은 [[Flow Tests (플로우 테스트)]] 참조. Beta인 Test Mode는 그 위에 얹히는 **별개의 UI 모드**다.

### Flow Runtime (버전별 업데이트)

- **Flow and Process Run-Time Changes in API Version 68.0** — **API 버전 68.0 이상으로 실행되도록 구성된 플로우·프로세스에만** 적용되는 versioned update. Professional·Enterprise·Performance·Unlimited·Developer. 실행 API 버전 변경: 플로우는 Flow Builder에서 **flow version properties**, 프로세스는 Process Builder에서 **properties** 편집.
  - **v68.0 versioned update 목록(릴리즈 노트가 나열한 항목):** **Enforce User Permissions No Matter How a Flow Runs** — 새 실행 컨텍스트 옵션이 호출자와 무관하게 실행 사용자의 접근 수준을 보장 (상세는 위 [Flow Builder 업데이트](#flow-builder-업데이트) 참조).

> 플로우 버전·활성화 수명주기는 [[Flow 버전 관리와 활성화 - 배포 수명주기]] 참조.

### Flow 관리

- **Classify and Discover Flows with Flow Tags** — 업무 도메인·팀·목적을 반영한 라벨인 **Flow Tags**로 플로우를 태깅하고, **하나 이상의 태그로 플로우 목록을 필터링**한다. 표준 플로우 목록에 구조적 분류 계층이 추가된다(이전에는 대규모 플로우 라이브러리를 **네이밍 컨벤션**으로만 정리했다). Lightning Experience·Salesforce Classic, Professional·Enterprise·Performance·Unlimited·Developer.
  - 실행: **Automation App → Tags 탭**에서 태그 생성·태그 그룹 구성 → **Flows 탭**에서 행 수준 **Assign Tags** 액션으로 개별 태깅하거나 여러 플로우를 선택해 **일괄 태깅** → Flow Builder에서는 **Save As 모달의 Tags 필드**로 태깅.

> 네이밍 컨벤션 기반 정리 방식은 [[Flow 네이밍 컨벤션]] 참조 — Flow Tags는 그 대안이 아니라 보완 계층이다.

### Flow Approval Processes

- **Add Multiple Flow Approval Processes to a Record with the Request Approvals Component** — **Request Approvals** 컴포넌트로 제출자에게 **최대 10개**의 autolaunched flow approval process 중 선택지를 제공한다. **Lightning App Builder와 Experience Builder 양쪽**에서 동작. Enterprise·Performance·Unlimited·**Einstein 1 Editions·Agentforce 1 Editions**·Developer.
  - 구성: 컴포넌트를 레코드 페이지(LAB) 또는 오브젝트 상세 페이지(Experience Builder)에 추가 → 속성 패널의 **+ Add Flow Approval Process** → 각 프로세스마다 사용자에게 보일 **label** 입력 → **Hide submitter comments**(제출자 코멘트 차단) / **Require the submitter to select an approver**(승인자 선택 필수) 옵션 → label 클릭 시 해당 프로세스 구성 보기·편집.
- **Open the Next Work Item from the Same Running Flow Approval Process** — 사용자가 work item을 완료하면 **Orchestration Work Guide**가 **같은 실행 중인 flow approval process의 다음 work item**을 연다(리스트 뷰로 돌아갈 필요 없음). 남은 work item이 없으면 현재 레코드에 대한 갱신된 work item 목록을 보여준다. **Automatically Open Next Work Item 옵션은 기본 OFF**이며 LAB·Experience Builder 양쪽에서 제공. Lightning Experience, Enterprise·Performance·Unlimited·Einstein 1 Editions·Agentforce 1 Editions·Developer.
- **Delete Approval Submission Records to Meet GDPR Requirements** — 승인 관련 고객 데이터 삭제 요구(GDPR 등)를 충족한다. **부모 레코드를 삭제하면 관련된 진행 중 approval submission과 그 진행 중 자식 레코드가 자동으로 취소**되어 삭제 가능 상태가 된다. **부모 레코드 삭제는 이미 종료 상태(terminal state)인 approval submission에는 영향을 주지 않으며**, 종료 상태 레코드는 레코드를 열고 **Delete**로 삭제한다. **approval submission 레코드를 삭제하면 그 모든 자식 레코드도 삭제된다.** Lightning Experience, Enterprise·Performance·Unlimited·Einstein 1 Editions·Agentforce 1 Editions·Developer. 권한: **Approval Admin 또는 Modify All Data.**
- **Update Existing Flow Approval Processes to Run Background Steps Synchronously When Actions Support It** — 동기 액션을 호출하는 background step이 **동기로 실행**되어 end-to-end 지연이 줄어든다. 이전에는 Action 요소를 포함한 background step은 **액션 자체가 동기인지와 무관하게 비동기**로 실행됐다. **기존 프로세스에 적용하려면 opt-in이 필요하다** — Flow Builder에서 version properties를 열고 **API Version for Running the Flow Approval Process를 68.0 이상**으로 설정. 이전 API 버전으로 실행되는 프로세스는 **기존 비동기 동작을 유지**한다. Lightning Experience, Enterprise·Performance·Unlimited·Einstein 1 Editions·Agentforce 1 Editions·Developer.
- **Flow Approval Processes Now Route Record-Change Events to a Dedicated Channel** — record-change 이벤트를 **전용 채널**로 라우팅해 step-completion 채널의 트래픽을 줄인다. 이전에는 단일 플랫폼 이벤트 채널에 record-change와 step-completion 이벤트가 함께 있어, **대량 데이터 작업이 수천 건의 record-change 이벤트를 유발하면** 그 이후 완료된 step의 step-completion 이벤트가 뒤에 큐잉되어 승인 work item 완료가 지연됐다. **자동 적용이며 구성 불필요.** Lightning Experience, Enterprise·Performance·Unlimited·Einstein 1 Editions·Agentforce 1 Editions·Developer.

> 승인 프로세스 개념·운영은 [[Approval Process — 운영·엔드유저·레퍼런스]] 참조.

### Flow Orchestration

- **Open the Next Work Item from the Same Orchestration Run** — 위 승인 프로세스와 동일한 동작의 오케스트레이션 판. work item 완료 시 **같은 orchestration run의 다음 work item**을 열고, 남은 항목이 없으면 현재 레코드의 갱신된 목록을 보여준다. **Automatically Open Next Work Item은 기본 OFF.** LAB·Experience Builder 양쪽. Enterprise·Performance·Unlimited·Einstein 1·Agentforce 1·Developer.
- **Update Existing Orchestrations to Run Background Steps Synchronously When Actions Support It** — 동기 액션을 호출하는 background step이 동기 실행된다. opt-in: version properties의 **API Version for Running the Orchestration을 68.0 이상**으로 설정. 이전 버전은 비동기 동작 유지. Lightning Experience, Enterprise·Performance·Unlimited·Einstein 1 Editions·Agentforce 1 Editions·Developer.
- **Orchestration Runs Now Route Record-Change Events to a Dedicated Channel** — 승인 프로세스와 동일한 이벤트 채널 분리. **자동 적용, 구성 불필요.** Lightning Experience, Enterprise·Performance·Unlimited·Einstein 1 Editions·Agentforce 1 Editions·Developer.

> 오케스트레이션 개념·운영은 [[Flow Orchestration]] / [[Flow Orchestration - 운영과 레퍼런스]] 참조.

### Automation for Customer 360 Apps and Industries (→ 타 spoke 위임)

이 영역은 클라우드·산업별 자동화라 본 노트에서는 목록만 남기고 상세는 [[Winter '27/Clouds]] 소관이다. 릴리즈 노트가 나열한 항목: **AI Relationship Research**(CRM 레코드·공개 웹 콘텐츠·Data 360을 동시 스캔해 상위 연결 관계 제시) · **Business Rules Engine**(Agentforce에서 expression set·decision table을 액션으로 실행, **List Branch 요소로 context-aware expression set의 리스트 데이터에 if-then-else 규칙 조건 구성**, Context Service 없이 표준 expression set에서 다중 decision table 결과 처리, expression set 조건에서 picklist 값을 타이핑 대신 드롭다운으로 선택, Omniscript에서 decision table 직접 호출, 병렬 처리·자동 증분 refresh로 decision table refresh 가속, CSV 기반 decision table의 데이터 타입 확대 **및 리스트 뷰에서 각 테이블의 상태 확인**) · **Context Service**(context definition·node·attribute·mapping·filter의 create/update/delete를 **Setup Audit Trail로 추적**, Data 360 DMO 간 부모-자식 관계를 해석해 **단일 hydration 호출로 다단계 계층 반환**, 외부 웨어하우스 기반 zero-copy DMO 포함) · **Data Processing Engine**(다중 통화 처리, 실행 속도·부분 실패 추적·활성 실행 보호, 롤업 합계에 부모 레코드를 포함할지 선택, **단계적으로 쌓이는 계산을 한 곳에 모아 유지**) · **Omnistudio**(업계 특화 디지털 경험을 만들기 위한 **로우코드 서비스·컴포넌트 종합 스위트**. 개발에서 프로덕션까지의 경로를 단축하고, Salesforce 데이터와 외부 소스를 함께 써서 **가이드형 고객 인터랙션**을 만들 수 있게 한다).

---

## Hyperforce / 인프라

- **Access Salesforce in More Regions with Hyperforce** — Hyperforce가 **18개국**에서 가용. AWS 상 Hyperforce로 제공되는 Salesforce Customer 360 애플리케이션 스위트(**Sales Cloud · Service Cloud · B2B Commerce · Platform · Industries Cloud**)의 가용 국가: **Australia, Brazil, Canada, France, Germany, India, Indonesia, Israel, Italy, Japan, Singapore, South Africa, South Korea, Sweden, Switzerland, the United Arab Emirates, the United Kingdom, the United States.** 최신 목록은 Salesforce Trust and Compliance Documentation(Hyperforce Security, Privacy and Architecture 문서)이 정본.

아래는 이번 릴리즈에 **새 Hyperforce 리전으로 확장된** 클라우드/제품 매트릭스다. PDF·웹 표의 원래 방향(row=Cloud, 컬럼=Cloud / Product or Feature / Description / Available In)을 유지하고, `Now available`(신규)과 `Also available`(기존)을 구분해 옮긴다.

```text
# 출처: Winter '27 릴리즈 노트 rn_hyperforce_access_salesforce_in_more_regions_with_hyperforce (셀 단위 매핑)
# 컬럼: Cloud | Product or Feature | Description | Available In

Data 360             | Agentforce, Data 360, and Einstein
  Description : Hyperforce Geo Expansion for Data Residency가 이 Data 360 제품들에 in-country 데이터 거주를 제공
  Now  : Israel, South Africa
  Also : all other Hyperforce countries

Agentforce Commerce  | Salesforce B2C Commerce
  Description : 글로벌 스케일, AI 기반 수익성, 디지털·물리 고객 경험의 연결
  Now  : Australia, Japan, Sweden
  Also : the United States

Agentforce Marketing | Marketing Cloud Advanced and Marketing Cloud Growth
  Description : 개인화된 마케팅 메시지와 자동화된 여정으로 고객 관계 구축
  Now  : Israel, South Africa
  Also : all other Hyperforce countries

Headless 360 platform| Event Log Objects
  Description : Hyperforce 고객이 Event Log Objects로 표준 오브젝트에 이벤트 데이터를 저장·쿼리
  Now  : Brazil, Indonesia, Israel, South Africa, South Korea
  Also : Australia, Canada, France, Germany, India, Italy, Japan, Singapore,
         Sweden, Switzerland, the United Kingdom, the United States
```

- **Hyperforce Is Coming to Google Cloud Platform (GCP)** — Salesforce가 Hyperforce를 **복수 클라우드 제공자**로 확장한다. GCP 상 Hyperforce는 특정 사업·계약 요건이 있는 고객에게 **AWS 대안**을 제공한다. **Where: 미국.** **When: 2026년 11월 예정**이며 **대부분의 Sales Cloud · Service Cloud · Service Cloud Real-Time 기능을 지원**한다. 인프라 배치는 Salesforce가 기술·운영 요인으로 결정하며, 특정 클라우드 제공자를 배제해야 하는 규제·계약 요건이 문서화돼 있다면 **account team에 문의**한다.
  - **IP allowlisting 사용 시:** 미국 Hyperforce GCP의 허용 IP는 `https://ip-ranges.salesforce.com/ip-ranges.json` 에서 확인. 이메일 IP는 *Ensure You Can Receive Email from Salesforce* 문서 참조.
- **Manage Salesforce Edge Network Options from Setup** — Salesforce Edge Network의 **셀프서비스 라우팅 옵션**이 My Domain Setup 페이지에 제공된다(지원 케이스를 열 필요 없이 관리자가 라우팅 방식 전환). **Regional Routing**(조직 리전 내 Edge 위치로 트래픽을 보냄)이 **일본 조직뿐 아니라 전 세계 모든 Hyperforce 조직**으로 확대됐다. **Global Selective Routing**은 **중동 네트워크 위치를 우회**해 방화벽 관련 연결 문제를 겪는 고객을 돕는다. Lightning Experience·Salesforce Classic, Group·Essentials·Professional·Enterprise·Performance·Unlimited·Developer.
  - 실행: Setup → **My Domain** → **Routing and Policies → Edit** → 선호 라우팅 옵션 선택. **Global Selective Routing 최초 활성화는 Salesforce Customer Support에 요청하고 승인받아야** 하며, 승인 후에는 My Domain 페이지에서 옵션을 자유롭게 전환할 수 있다.
  - **IP allowlisting 사용 시:** 모든 Hyperforce Edge IP 주소가 이제 `https://ip-ranges.salesforce.com/ip-ranges.json` 로 **통합**됐다.
- **Add Automation and Integration with MuleSoft on Government Cloud** — MuleSoft가 **Government Cloud Plus와 Government Cloud Plus – Defense**에 제공될 예정. **2026년 말까지** 제공 계획.
- **Sandbox Quick Create and Quick Clone Available for Government Cloud** — **Quick Create**는 Hyperforce 인스턴스의 프로덕션 조직에서 full sandbox를 레거시 방식보다 빠르게 생성하고, **Quick Clone**은 Developer·Developer Pro·partial·full 샌드박스를 빠르게 복제한다. 조직마다 편차는 있으나 **대부분 레거시 대비 2~3배 빠른 처리 시간**. Lightning Experience·Salesforce Classic, Professional·Enterprise·Performance·Unlimited·Database.com.

> My Domain·라우팅 설정 개념은 [[My Domain (마이 도메인)]] 참조.

---

## Salesforce Overall — General Enhancements · Foundations · Trust · Scheduler · Help Agent

### General Enhancements

- **Complete Pending Cloudflare Migrations for Content Delivery Networks (CDN)** — Cloudflare로 마이그레이션 중인 Experience 사이트 중 **활성화 대기(pending activation)** 상태가 **30일 지나면 자동 취소**된다. 사이트는 중단 없이 현재 제공자에서 계속 동작한다. 활성화하려면 프로비저닝 완료 후 도메인에서 **Activate** 클릭. **취소된 경우** 도메인을 편집해 CDN 파트너를 Cloudflare로 다시 지정하고 활성화 절차를 재시작한다. Enterprise·Performance·Unlimited·Developer **+ Foundations 또는 Agentforce 1.**
- **Turn on CDN for All Lightning App Static Resources** — Lightning 컴포넌트 프레임워크 CDN이 **Lightning 앱의 모든 static resource**를 서비스하도록 확장(이전에는 **Lightning 페이지**의 static resource만). 실행: **Setup → Security → Session Settings**에서 *Serve all Lightning app static resources through CDN* 체크. Group·Essentials·Starter Suite·Pro Suite·Professional·Enterprise·Performance·Unlimited·Developer.
- **Update and Customize Solutions Safely** — 배포된 솔루션을 신규 번들 설치나 상위 버전 업그레이드로 최신 상태 유지. 업데이트가 나오면 **자동 알림**을 받고, **custom input**으로 조직 고유 셋업에 맞게 배포를 조정하며, **설치 시작 전에 잠재적 메타데이터 충돌을 미리 확인**한다. 선택과 입력은 자동 저장되어 진행 상황을 잃지 않고 **중단·재개**할 수 있다.
- **WCAG 2.2 Resize and Reflow 접근성 Release Update 4건** — 고배율(zoom > 200%)에서 Lightning Experience UI 동작을 적응시키는 릴리즈 업데이트. 대상 UI는 각각 ① **페이지 헤더·모달 창** ② **날짜 선택기·팝오버·하단 유틸리티 바·레코드 헤더** ③ **카드·도킹 컨테이너·메뉴 리스트·패널** ④ **To Do 리스트·Lightning dual listbox**. **②와 ③은 ①(Page Headers and Modal Windows)에 의존하므로 ①을 먼저 활성화해야 한다.** 릴리즈 노트는 이것이 WCAG 2.2 Resize and Reflow 준수 노력의 **시작**이며 향후 릴리즈 업데이트에서 다른 UI 요소로 확장될 것이라고 밝힌다. → **최초 제공·연기·강제 시점은 전부 [[Winter '27/Release Updates]]**

### Salesforce Foundations

- **Skip the Wait When Sending Emails to Contact and Lead Lists in Foundations** — Contact·Lead 목록에 promotional·transactional·relational 이메일을 **기존의 추가 처리 단계 없이 즉시** 발송한다. 재설계된 **List Sends** 경험은 메시지 구성과 대상 선택을 **한 페이지로 통합**했다. Salesforce Foundations 지원 에디션. **8월 중순부터 제공**(릴리즈 노트 원문은 *"available starting mid-August"* 로 **연도를 밝히지 않는다** — Winter '27 사이클상 2026년으로 추정).
- **Simplify the Foundations Setup Experience with Salesforce Go** — **Salesforce Go**가 Foundations의 기본 셋업 경험이 되어 핵심 셋업 옵션이 한 페이지에 모인다. **Marketing Cloud enablement·Profile Unification 같은 마케팅 셋업 항목은 Foundations on Go 페이지에서 접근하는 전용 셋업 페이지로 이동**했다. 기존 **Foundations Setup 노드는 Setup에 남아 Foundations on Go 페이지로 리디렉션**하며, 이미 활성화된 기능은 켜짐으로 표시된다. **Salesforce Foundations 지원 에디션.**
  - **주의(원문):** 기능 그룹 내 개별 옵션을 꺼도 **기능 전체의 활성 상태는 바뀌지 않는다.** 기능을 비활성화하려면 **그 기능의 모든 옵션을 꺼야** 한다. 기능 활성화 후에는 Foundations on Go 페이지를 **새로고침**해야 갱신된 상태가 보인다.

### Salesforce My Trust Center

- **Track Salesforce My Trust Center Sandboxes, Read Translated Updates, and Extend Access** — My Trust Center가 **샌드박스 테넌트를 지원**하고, 자유 형식 이벤트 업데이트를 **거의 실시간으로 번역**하며, **전체 Salesforce 라이선스가 없는 사용자에게 view-only 접근**을 제공한다. My Trust Center는 Salesforce 제품·서비스·테넌트의 가용성에 관한 중요 업데이트·공지를 찾는 **단일 창구**다.

### Salesforce Scheduler

- **Salesforce Scheduler** — 릴리즈 노트 Salesforce Overall 허브가 이번 릴리즈 Scheduler 변경으로 두 가지를 든다. ① **새 Agentforce Builder에서 고객이 스스로 약속을 예약하도록 돕는 에이전트를 구축**한다. ② **파트너 사용자가 실제로 만날 수 있는 시간만 노출**해, 그 사용자가 Salesforce 밖에서 관리하는 미팅과 예약이 겹치지 않게 한다. (허브 요약 문장이 근거 — 이번 추출 배치에 전용 리프 페이지가 없어 Where/When 등 상세는 확인되지 않았다.)

### Help Agent · Advisements

- **Get Contextual Help in the Flow of Work** — 대화형 AI 어시스턴트 **Help Agent**가 Salesforce 플랫폼 **내부에서** 제공된다. 사용자의 **권한과 현재 워크플로에 맞춘** 컨텍스트 인식 가이드를 앱 안에서 받아, 도구를 전환하거나 맥락을 반복 설명할 필요가 없다. **영어**로, Lightning Experience의 **Free Suite·Starter Suite·Pro Suite 및 Professional·Enterprise 에디션.** Free/Starter/Pro Suite·Professional은 **2026년 5월부터**, Enterprise는 **2026년 8월부터** rolling 제공. 접근: Salesforce의 **? 아이콘**. **추가 셋업 불필요.**
- **Advisements (Beta)** — 조직별 지능형 권고를 **단계별 remediation 가이드와 함께** 관리자에게 앱 내에서 전달하는 경험. 각 advisement는 **완료 여부가 자동으로 추적·검증**되어 조직 상태 가시성을 제공한다. (릴리즈 노트에 전용 상세 페이지 없이 Salesforce Overall 개요에만 등장 — Where/When 정보 없음.)

---

## Setup with Agentforce

Setup의 AI 에이전트로 관리 작업을 단순화한다.

- **Manage Dynamic Actions on Mobile via the Setup Agent** — 자연어로 **Dynamic Actions on Mobile**을 활성/비활성화한다. Setup 메뉴를 탐색하는 대신 에이전트에게 구성 변경을 요청한다. Lightning Experience, Enterprise·Performance·Unlimited·Developer **+ Foundations 또는 Agentforce 1.** **2026년 8월부터 적용.**
- **Create Related List Enrichments with Agentforce for Setup** — 대화로 **Related List Enrichment**를 생성·검토한다. 원하는 관련 목록을 설명하면 에이전트가 필요한 세부 사항(어떤 **DMO**를 쓸지, 어떤 필드로 연결할지 등)을 되묻고 레코드 페이지에 추가한 뒤 **확인 카드**를 보여준다. **Data 360** Developer·Enterprise·Performance·Unlimited 에디션. 릴리즈 노트가 밝힌 배경: 소스 DMO 선택·lookup 필드 설정 같은 수동 구성은 관리자가 **Setup 구조를 미리 알아야** 했다.
- **Customize the Org Health and Usage Metrics Dashboard** — Org Health and Usage 대시보드에 표시할 메트릭을 정리한다. 기본적으로 모든 메트릭이 **Active Metrics** 페이지에 표시되며, **Favorite** 또는 **Hidden**으로 표시하면 각각 Favorite 탭에 추가되거나 Hidden 탭으로 이동한다. 모든 메트릭은 **severity 순서**로 표시되어 시급한 항목부터 조치할 수 있다. Enterprise·Performance·Unlimited·Developer **+ Foundations 또는 Agentforce 1.** **2026년 7월부터 적용.**

---

## Platform 섹션 — 개별 항목(Event Studio) · 릴리즈 노트 변경 이력

### Event Studio

- **Event Studio Now Shows More Configuration Details and Recommendations** — Event Studio가 더 많은 정보와 권고를 노출하며, **편집 가능한 Platform Events Subscriber Config**(UI 라벨은 **Apex Trigger Details**)를 포함한다. 이전에는 Platform Events Subscriber Config에 **Metadata API 또는 Tooling API를 통해서만** 접근할 수 있었다. Developer·Enterprise·Performance·Unlimited.

### Platform 릴리즈 노트 변경 이력 (Release Note Changes by Month — August 2026)

Platform 섹션 최상위 페이지도 초판 발행 이후의 변경을 **Release Note Changes by Month**로 기록한다. **August 2026** 블록에는 **6건**이 있고, 그중 코드가 아니라 **플랫폼 보안 정책**에 해당해 본 노트 소관인 것은 1건이다.

- **API: New and Changed Items: GraphQL API and Metadata API (2026년 8월 24일 주에 추가)** — **관리자가 GraphQL API에 대한 게스트 사용자 접근을 제어할 수 있다**는 사실을 알리는 릴리즈 노트가 추가됐다.

나머지 **5건은 전부 코드 영역(Lightning Components·Apex)이라 [[Winter '27/Development]] 소관으로 위임한다** — 아래는 위임 사실을 남기기 위한 항목명 포인터일 뿐이며 내용의 정본은 그 노트다(전부 2026년 8월 24일 주).

- *Lightning Components: Accelerate Lightning Development with LWC Skills* — 추가
- *Lightning Components: New and Changed Lightning Web Components* — 갱신(`lightning-input` color picker 업데이트 철회)
- *Lightning Components: Changed Aura Components* — 갱신(`lightning:input` color picker 업데이트 철회)
- *Apex: Handle Larger Datasets with Increased Apex Heap Limits* — 갱신
- *Apex: Reduce Overhead by Recompiling Only Invalid Apex Classes and Triggers* — 갱신

> Platform 섹션의 나머지 하위 영역(Apex · API v68.0 · API Catalog · Enterprise Messaging · Lightning Components · SLDS · Platform Development Tools · New and Changed Items for Developers)은 코드성이므로 [[Winter '27/Development]] 소관이다. **External Services 스키마의 any 타입 지원**, **Lightning App Builder의 Dynamic Highlights Panel Follow 버튼**, **Permissions and Sharing(소유권 이전 시 수동 공유 유지 선택)**, **Salesforce Functions 구매·갱신 종료**도 Platform 섹션의 하위 항목으로 나열돼 있으나, 이번 추출 배치에는 각 항목의 전용 리프 페이지가 포함되지 않아 **개요 문장 이상은 확인되지 않았다.**

---

## Experience Cloud

> **이번 릴리즈부터 Experience Cloud 릴리즈 노트는 Platform 섹션 안에 있다.** 요지: 서드파티가 서비스하는 커스텀 도메인 사이트의 유지보수 중 다운타임 리스크 감소, Aura·LWR 사이트 방문자의 레코드 제출·Orchestration Work Guide 사용 효율 향상, 게스트 사용자로부터 민감 정보 은폐, 사이트 이메일 보안 기능.

### 커스텀 도메인 — Stable Target Host Name

- **Simplify Custom Domain Management with a Stable Target Host Name** — 서드파티가 커스텀 도메인을 서비스하고 조직이 Salesforce Edge Network를 쓸 때, 도메인의 **target host name을 조직의 My Domain 로그인 URL로 갱신**하면 Salesforce 인스턴스가 바뀌어도 계속 동작한다. **현재의 target host name은 인스턴스 이름이나 Hyperforce cell이 바뀔 때까지만 유효**하므로, **다음 조직 마이그레이션 전에 갱신할 것을 권장**한다. Salesforce Sites와 Aura·LWR·Visualforce 사이트, Enterprise·Performance·Unlimited. **도메인 구성이 "Use a third-party service or CDN to serve the domain"인 커스텀 도메인만 해당.**
  - 확인: Setup → **Domains** → 도메인 이름 클릭 → **Target Host Name** 필드 값을 서드파티 제공자에게 전달해 갱신.
  - **Setup Audit Trail 표기:** 이 변경을 위해 백엔드 프로세스가 Salesforce Edge Network 구성을 게시하며, Setup Audit Trail에는 `Publish Edge For Byo Cdn Releasable Action` 으로 나타난다.

### Aura·LWR 사이트

- **Experience Delivery (Beta) Is Discontinued** — LWR 사이트용 **Experience Delivery 인프라(Beta 발표분)가 Winter '27부로 중단(discontinued)** 된다. **최선의 성능을 위해 사이트를 재게시(republish)** 할 것을 권장한다. Experience Delivery에 호스팅된 사이트를 게시하면 **자동으로 표준 LWR 인프라로 마이그레이션**된다. 게시된 사이트를 재게시하지 않으면 **사이트는 계속 이용 가능하지만 시간이 지나며 성능이 저하될 수 있다.** LWR 사이트, Enterprise·Performance·Unlimited·Developer. **When: 2026년 10월부로 중단.**
- **Add Multiple Flow Approval Processes to a Record with the Request Approvals Component in Experience Builder** — 인증된 사이트 방문자가 레코드를 승인 제출할 때 여러 프로세스 중 선택할 수 있다. Aura·LWR 사이트의 오브젝트 상세 페이지에서 **Request Approvals 컴포넌트가 최대 10개 flow approval process를 참조**하도록 구성한다. (구성 상세는 위 [Flow Approval Processes](#flow-approval-processes) 참조)
- **Open the Next Work Item from the Same Orchestration Run in Experience Builder** — Experience Builder에서 Orchestration Work Guide를 구성해 같은 orchestration run의 work item을 이어서 처리하도록 한다.
- **Launch a Native Agentforce Panel in Mobile Publisher Apps** — 아래 [Mobile](#mobile) 참조(Mobile Publisher 항목과 동일 기능).

### 보안 및 공유 (Experience Cloud)

- **Send Site Emails from a Verified Address with Email Domain Substitution** — **검증되지 않은 이메일 도메인의 사용자를 대신해 사이트가 보내는 이메일의 From 주소**를 사이트별로 지정한다. 조직에 사이트·브랜드가 여럿이면 각 사이트의 발신 이메일을 자체 브랜딩에 맞출 수 있다(단일 org-wide 주소를 쓰지 않아도 됨). **기본 OFF, 사이트별 수동 활성화.** Aura·LWR·Visualforce 사이트, Enterprise·Performance·Unlimited·Developer.
  - **우선순위 규칙(원문):** Salesforce는 두 가지 방식을 제공한다 — Deliverability Setup 페이지의 **org-wide substitute email address**(조직 전체 적용)와 이 **사이트별 설정**. 어느 쪽이든 **발신 이메일 주소가 검증돼 있고 검증된 이메일 도메인을 써야 하며, 아니면 이메일이 실패**한다.
    - 사이트에 email domain substitution을 켜면 → **그 사이트의 검증된 sender 주소가 우선**한다(조직이 substitute 주소를 쓰더라도).
    - 켜지 않으면 → 조직의 substitute 주소가 설정돼 있을 때 그것을 사용한다.
    - **둘 다 없으면 → Salesforce는 검증되지 않은 도메인 사용자를 대신한 이메일 발송을 억제(suppress)한다.**
  - 실행: Experience Workspaces → **Administration | Emails** → **Enable Email Domain Substitution**. 치환은 사이트의 **Sender Email Address** 필드 값을 사용하므로 **그 주소와 도메인을 먼저 검증**한다.
- **Pinpoint Fields with Sensitive Data to Hide from Guest Users** — **Guest User Sharing Rule Access Report**의 필드 이름 옆에 **경고 아이콘**이 추가되어 개인 정보를 노출할 가능성이 있는 필드를 식별한다. 예: Account 오브젝트에서 **매출 데이터, 주소·연락처 정보** 필드를 표시. 각 필드를 검토해 공유 규칙을 바꿔 **미인증 사용자로부터 필드와 데이터를 숨길지** 결정한다. Aura·LWR 사이트, Enterprise·Performance·Unlimited·Developer. 실행: Setup → Quick Find `Guest User` → **Guest User Sharing Rule Access Report** → 사이트 선택 → 오브젝트별로 플래그된 필드 검토.
- **Send Sensitive Emails Securely with a Secondary Sender Email Address** — 민감한 이메일(예: Forgot Password)을 **회사 이메일 릴레이 대신 Salesforce Mail Transfer Agent(MTA)에서 직접** 발송해 릴레이 가로채기를 방지한다. 기본 도메인의 **DKIM 설정을 바꾸지 않고도 DMARC 표준에 부합**시킬 수 있다. **late Summer '26에 최초 출시.** Aura·LWR·Visualforce 사이트, Enterprise·Performance·Unlimited·Developer.
  - 실행: Setup에서 **secondary sender 이메일 주소의 email-sending 서브도메인을 검증**한다. **검증되지 않은 이메일 발송 도메인의 시스템 생성 이메일은 From 주소를 검증해도 전달되지 않는다.** 이후 사이트의 **Workspaces | Administration | Emails → Secondary Sender Email** 에 주소 입력.
  - **동작 분기:** 주소 검증 후 **민감 정보를 포함한 이메일**은 회사 SMTP 서버를 거치지 않고 secondary sender 주소로 Salesforce에서 직접 발송된다. **민감 정보가 없는 사이트 이메일**(예: 비밀번호 자격증명이 필요 없는 기존 내부·SSO 사용자에게 보내는 Welcome New Member 메시지)은 **설정된 이메일 릴레이와 network sender 주소로** 발송된다.
- **Conceal Personal Information Fields from Guest Users (Release Update)** — 다른 외부 사용자 설정에 영향을 주지 않고 **게스트 사용자에 대해서만 필드 가시성**을 설정한다. **Independent Guest Field Masking**을 켜면 특정 필드를 게스트 사용자에게만 숨기며, 새 **`Guest_PersonalInfo_EPIM` 필드 세트**가 추가되어 포털 사용자가 보는 것을 바꾸지 않고 게스트 대상 필드를 보호한다. → 강제 시점은 [[Winter '27/Release Updates]]

> 게스트 사용자·사이트 인증 보안 개념은 [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]], 제품 개요는 [[Experience Cloud 개요]] 참조.

### 그 밖의 Experience Cloud 관련 변경 (타 제품 영역 릴리즈 노트로 연결)

릴리즈 노트가 "Other Changes"로 모아 둔 교차 참조 표. 각 항목의 상세는 해당 제품 영역 노트 소관이다(대부분 [[Winter '27/Clouds]]).

| Product Area | Feature | Release Note |
|---|---|---|
| Analytics | Lightning Reports and Dashboards | Embed Lightning Dashboards in Your Lightning Web Runtime Experience Cloud Sites **(Beta)** |
| Analytics | Lightning Reports and Dashboards | Embed Lightning Reports in Your Lightning Web Runtime Experience Cloud Sites **(Beta)** |
| Automotive | Agentforce | Help Customers Buy Vehicles with the Sales Concierge Agent on Your Website |
| Education | Agentforce | Share Billing Details with Your Students |
| Education | Payments | Spread Tuition Payments with Flexible Payment Plans |
| Education | Student Financials | Automate Refund Processing for Student Overpayments |
| Education | Transfer Credits | Accept Transfer Credit Requests from Current Students on an Experience Cloud Site |
| Industries: Common Features | Unified Catalog | Deploy Components on Lightning Web Runtime Experience Cloud Sites |
| Marketing | Loyalty Management | Simplify Loyalty Widget Deployment with Lightning Out 2.0 |
| Marketing | Referral Marketing | Simplify Referral Widget Deployment with Lightning Out 2.0 |
| Omnistudio | Flexcards | Reuse Autolaunched Flow Logic Across Your Flexcards **(Generally Available)** |
| Omnistudio | Flexcards and Omniscripts | Run Flexcards and Omniscripts Offline on Mobile Devices |
| Partners | Campaigns | Discover and Enroll in Vendor Campaigns from Campaign Marketplace |
| Partners | Partner Central | Enhance Partner Experiences with Loyalty and PEM Components in Partner Central |
| Partners | Partner Central (Enhanced) | Enhance Partner Experiences with PEM Components in Partner Central (Enhanced) |
| Public Sector | Outbound Payments | Customize Claims Submission Forms and AI-Based Invoice Extraction |
| Revenue Management | Payments and Refunds | Add Billing Self-Service Components in LWR Experience Cloud Sites |
| Security | Trusted URLs | Allow Chrome Extensions as Trusted URLs |
| Service | IT Service | Collaborate on Tickets with Comments on the Employee Services Portal |
| Service | IT Service | Help Employees Access the Portal in Their Preferred Language |
| Service | IT Service | Tailor Employee Portal Pages to Your Service Needs |
| Service | Self-Service | Set Up Your Agentic Portal Faster with a Guided Setup Wizard |
| Service | Self-Service | Deploy Messaging Automatically During Agentic Portal Setup |
| Service | Self-Service | Guide Customers Through Troubleshooting Steps with a Reusable Action |
| Service | Self-Service | Reach Customers with In-App Notifications for Proactive Service |

---

## Mobile

> **이번 릴리즈부터 Mobile 릴리즈 노트도 Platform 섹션 안에 있다.** 요지: AI 기반 미팅 후속 조치, 하이브리드 클라우드·온디바이스 오디오 처리, Post-Meeting Voice Notes, Mobile Publisher의 네이티브 Agentforce 패널.

### Salesforce 모바일 앱

- **Accelerate Meeting Follow-Ups with AI Suggested Actions** — 미팅 **transcript가 생성된 후**, 모바일 앱이 **미팅 요약·핵심 결정 사항·맥락 기반 다음 단계**를 이벤트 레코드에 직접 표시한다. 요청 자료 발송, 기회(opportunity) 갱신, 후속 미팅 예약 같은 후속 조치 권고를 검토할 수 있다. iOS·Android. **2026년 8월 24일부터 제공.** **Einstein Conversation Insights** 접근 권한과 모바일 앱이 있는 사용자에게 제공.
- **Leverage Hybrid Cloud and On-Device AI Audio Processing** — **In-Person Meeting Assistant**와 **Post-Meeting Voice Notes**에 하이브리드 Cloud·On-Device 오디오 처리를 적용한다. **기본은 Cloud AI**(최대 정확도·폭넓은 언어 지원)이며 **연결이 끊기면 자동으로 On-Device AI로 폴백**해 전사(transcription)를 계속 유지한다. iOS·Android. **2026년 10월 12일부터 제공.**
- **Capture Post-Meeting Insights with Voice Notes** — **전사되지 않은 미팅** 직후 짧은 음성 메모를 남긴다. **단일 사용자 기능이라 구두 동의(verbal consent) 워크플로가 필요 없고**, 앱이 오디오를 **로그인한 사용자에게 자동 귀속**시키며 **전사를 전적으로 온디바이스에서 처리**한 뒤 텍스트를 **Einstein Conversation Insights로 직접 동기화**한다. iOS·Android. **2026년 7월 27일부터 제공.** Einstein Conversation Insights 접근 권한 필요.
- **Use the Login for Admin Option in the Salesforce Mobile App for Secure Access** — 모바일 앱의 새 메뉴 옵션 **Login for Admin**이 고급 **브라우저 기반 인증**으로 **피싱 저항(phishing-resistant) MFA**를 가능하게 한다. 관리자로 로그인할 때 **passkey**를 쓸 수 있으며, 사용자명을 입력하면 앱이 passkey 또는 비밀번호로 신원 확인을 요청한다. iOS·Android. **2026년 6월 29일부터 제공.**
  - **예외(원문 Note):** 조직이 이미 **Advanced Authentication (Native Browser)** 로 구성돼 있고 앱이 해당 조직의 **My Domain 로그인 서버**를 사용 중이라면 **Login for Admin 옵션을 쓸 필요가 없다.**
  - **전체 사용자 대상 변경(원문 Note):** **2026년 6월부터 모든 사용자가 갱신된 로그인 경험**을 본다. 사용자명 입력 후 Log In을 탭하면 비밀번호 입력 또는 (활성화된 경우) passkey 사용을 요청하는 **2단계 플로**가 적용된다.
  - **대상(원문 Who):** **모든 Salesforce 모바일 앱 사용자에게 제공**되며, **Login for Admin 옵션은 피싱 저항 MFA 요구사항을 충족해야 하는 관리자 사용자를 위해 설계**됐다.
  - 실행: 로그인 화면의 **Settings 아이콘 → Login for Admin.** 조직에 passkey가 활성화돼 있으면 등록·로그인 과정을 앱이 안내한다.
- **Enable Agentforce Voice for Employee Agents in the Salesforce App (Generally Available)** — Salesforce 앱의 **employee agent가 음성 대화**를 지원한다. 현장 팀의 두 순간을 겨냥한다 — **Pre-Visit Prep**(방문 준비)과 **Post-Visit Updates**(방문 직후 기록, 운전 중 포함). 에이전트에 **voice 설정을 직접 추가**하면 되고 **추가 연결 셋업은 필요 없다.** 활성화하면 사용자에게 음성 옵션이 보이고, **운전 중 사용을 위한 mute·end-call 컨트롤**이 기본 제공된다. Salesforce 모바일 앱.
  - **CarPlay 없이:** Salesforce 앱이 **CallKit과 연동**해 별도 CarPlay 앱 없이 mute·close 같은 차량 내 컨트롤을 제공한다.
  - **⚠️ 범위 제한:** **이번 릴리즈는 employee agent만 다루며 다른 agent 타입은 아직 지원하지 않는다.**
  - 접근 조건: 사용자에게 **voice가 켜진 employee agent 접근 권한**이 필요하며, 해당 **권한 세트를 할당**해야 한다.

### Salesforce App Enhancements 매트릭스 (원본 셀 값 그대로)

> 릴리즈 노트 원문 표를 **셀 텍스트 그대로** 옮긴다. 체크 표시 셀은 이미지의 alt 텍스트가 `Checkmark icon indicating true` 이며, **표시가 없는 셀은 빈 칸**이다(✅/❌ 기호로 압축하지 않는다). 표 구조는 헤더 1행 + 데이터 4행 × 4컬럼.
>
> 원문 서두: *"The new Salesforce mobile app is available for all editions, except Database.com, without an additional license. Your org's Salesforce edition and licenses, as well as a user's assigned profile and permission sets, determines the Salesforce data and features that are available to each user."* — 즉 **Database.com을 제외한 전 에디션에서 추가 라이선스 없이** 제공되며, 실제 이용 가능한 데이터·기능은 **에디션·라이선스·프로파일·권한 세트**가 결정한다.

| Salesforce App Enhancements and Changes | Salesforce for Android | Salesforce for iOS | Set Up in the Full Site |
|---|---|---|---|
| Accelerate Meeting Follow-Ups with AI Suggested Actions | Checkmark icon indicating true | Checkmark icon indicating true | (빈 칸) |
| Use the Login for Admin Option in the Salesforce Mobile App for Secure Access | Checkmark icon indicating true | Checkmark icon indicating true | (빈 칸) |
| Leverage Hybrid Cloud and On-Device AI Audio Processing | Checkmark icon indicating true | Checkmark icon indicating true | Checkmark icon indicating true |
| Enable Agentforce Voice for Employee Agents in the Salesforce App (Generally Available) | Checkmark icon indicating true | Checkmark icon indicating true | (빈 칸) |

> **읽는 법:** *Set Up in the Full Site* 열에 표시가 있는 항목은 **하이브리드 클라우드·온디바이스 오디오 처리 1건뿐**이다 — 나머지 3건은 전체 사이트(데스크톱 Setup)에서의 별도 셋업 표시가 없다. **Capture Post-Meeting Insights with Voice Notes는 이 매트릭스의 행에 포함돼 있지 않다**(상세 설명 문단에는 있음).

### Mobile Publisher

- **Launch a Native Agentforce Panel in Mobile Publisher Apps** — Mobile Publisher 앱에서 **모바일 floating action button이 Embedded Messaging 컴포넌트를 통해 네이티브 Agentforce 패널**을 연다. 기존의 **웹 기반 Messaging for Web 모바일 플로를 대체**해 주변 네이티브 앱과 일관된 더 빠른 인앱 경험을 제공한다. Mobile Publisher 앱으로 접근하는 LWR·Aura Experience Cloud 사이트, Enterprise·Performance·Unlimited·Developer.
  - 구성: Experience Builder에서 **Embedded Messaging 컴포넌트를 템플릿 footer 영역에 추가** → 속성 편집기에서 **모바일 deployment 선택**.
  - **네이밍 규칙:** 각 모바일 deployment는 대응하는 웹 deployment 이름에 **`_mobile` 접미사**를 붙인다(예: 웹 `MyEmbeddedDeployment` ↔ 모바일 `MyEmbeddedDeployment_mobile`). **웹과 모바일이 별개 deployment이므로 공유 설정을 양쪽에서 일관되게 유지**해야 한다.
  - **검증:** 모든 모바일 deployment가 선택 목록에 나타난다. 선택한 모바일 deployment의 **messaging 채널이 웹 deployment의 채널과 다르면 속성 패널에 검증 오류**가 표시된다. 네이티브 Agentforce 경험을 끄려면 모바일 deployment에 **Null**을 선택한다.
  - **표시 제어:** 버튼이 나타나는 시점은 Setup에서 모바일 deployment의 **business hours**로 제어한다. **messaging 채널에 user verification이 활성화돼 있으면 미인증 게스트 사용자에게는 버튼이 숨겨진다.**
  - **위치 조정:** 탭 바를 피하려면 Experience Builder의 **Settings | Advanced | Edit Head Markup** 에서 CSS 커스텀 속성 `--mp-fab-bottom` · `--mp-fab-right` 를 override 한다.

---

## Salesforce CMS

> **이번 릴리즈부터 Salesforce CMS 릴리즈 노트도 Platform 섹션 안에 있다.**

- **Create and Manage Brands in Enhanced CMS Workspaces** — **Brand 콘텐츠 타입**이 **모든 enhanced CMS workspace**에서 제공된다. React 앱을 위한 브랜드를 CMS에서 만들고 **색상·타이포그래피·버튼·테두리** 등을 커스터마이즈한다. 이전에는 Brand 콘텐츠 타입이 **Marketing Cloud Next의 마케팅 workspace에만** 있었다. enhanced CMS workspace, Enterprise·Performance·Unlimited·Developer.
- **Delete Content and Folders in Bulk in Enhanced CMS Workspaces** — 폴더와 콘텐츠를 **일괄 삭제**한다. **게시된(published) 콘텐츠 항목도 삭제 가능**하고, **폴더를 삭제하면 그 안의 모든 것이 함께 삭제**된다. 이전에는 콘텐츠 상세 페이지에서 **미게시 콘텐츠 1건씩**, **빈 폴더만** 삭제할 수 있었다. (IdeaExchange 아이디어 기반 개발.) enhanced CMS workspace, Enterprise·Performance·Unlimited·Developer.
  - 실행: workspace에서 폴더·콘텐츠 선택 → **Manage | Delete** → 일괄 작업 확인. **25건 미만이면 즉시 삭제**된다. 대량 삭제는 **Job Status 페이지**에서 진행 상황을 추적한다(삭제·내보내기·가져오기 상태 표시). 이 페이지는 이전 이름이 **Export & Import Status**였고 명확성을 위해 **Job Statuses**로 개명됐다.
- **Improve Semantic Search with the Latest CMS Base Data Kit and Search Index** — **CMS Base data kit 2.0**을 배포해 AI 기반 검색 결과를 개선한다. 최신 버전은 **새 content taxonomy transform**을 포함하고 **taxonomy term 기반 검색 인덱스**를 구축해, **태그가 검색 키워드의 의미(semantic meaning)와 일치할 때** 태깅된 CMS 콘텐츠를 찾아낸다. 이전에는 **태그가 검색 키워드와 정확히 일치할 때만** 결과에 나왔다. Lightning Experience, **Data 360이 지원하는 모든 에디션.** **2026년 8월 최초 제공.**
  - 실행: Setup → Quick Find `CMS` → **CMS Base Data Kit** → data space 선택 → 데이터 킷 버전이 **1.0이면 Content Taxonomy 번들을 포함해 Deploy** 하여 2.0으로 갱신. 배포 후 **Advanced Settings**에서 **Search Indexes 설정을 켜고 저장**하면, Salesforce가 **미디어 콘텐츠와 content taxonomy 기반의 새 검색 인덱스**를 구축한다.

---

## Salesforce Connect

- **Salesforce Connect Cross-Org Adapter Legacy Authentication Is Being Retired (Release Update)** — cross-org 어댑터의 **password 및 OAuth 2.0 인증 방식이 은퇴**한다. 이 방식들이 **은퇴 예정인 SOAP `login()` 호출에 의존**하기 때문이다. cross-org 어댑터는 이제 **named credential 인증을 지원**하므로, cross-org 어댑터 external data source를 named credential로 마이그레이션한다. → 강제 시점은 [[Winter '27/Release Updates]]

> 어댑터 종류·Cross-Org 구성은 [[Salesforce Connect — 어댑터·Cross-Org·writable·External CDC]], named credential 구성은 [[Named Credential]] 참조.

---

## Salesforce Contracts

- **Apply Contract Governance Policies Consistently with Document Playbooks** — 기존 규칙 정의를 **PDF·DOCX·XLSX** 형식으로 업로드하면 Salesforce Contracts가 각 파일을 **버전 관리되는 document playbook**으로 저장한다. 정책이 진화하면 버전을 **생성·활성화·아카이브·삭제**해 수명주기를 관리하고, **contract record type별로 고유한 playbook**을 설계한다. Lightning Experience, **Agentforce Revenue Management(구 Revenue Cloud)** 의 Enterprise·Performance·Unlimited 에디션 + **Revenue Cloud Advanced 라이선스** 또는 **Salesforce Contracts 라이선스 + Data 360 라이선스**. 권한 세트·조직 preference 전제는 위 **활성화 전제조건 한눈에** 표 참조.
- **Reduce Contract Risks by Analyzing Every Redline with AI** — **Microsoft 365 Word 애드인에서 직접** redline 계약서의 변경 사항을 document playbook과 비교해 리스크를 식별·분류한다. 수정된 조항 검토, 회사 표준 대비 편차 탐지, **조항 수준 리스크 발견 사항 + 전체 리스크 등급(critical · high · medium · low)**, 권고 완화책 제시. **편집 라운드마다 리스크 분석을 재실행**해 계약 변경이 전체 등급에 미치는 영향을 확인한다.
  - **사전 조건:** document playbook 셋업이 완료되고 **활성 document playbook이 존재**해야 하며, **Contract Risk Analysis 조직 preference**를 켜야 한다.
- **Protect Sensitive Setup Data by Removing Elevated Permissions from Runtime Users** — 런타임 사용자가 **View Setup and Configuration 권한 없이** 계약 수명주기 작업(Word 애드인에서 문서 생성·편집, 견적에서 계약 생성, 전자 서명 관리)을 수행할 수 있다. 이전에는 org 수준 셋업 데이터 접근을 위해 이 상승 권한이 필요했다. **사용자 경험은 그대로이면서 민감한 셋업 구성 데이터는 보호**된다. Lightning Experience, **Agentforce Revenue Management(구 Revenue Cloud)** 의 Enterprise·Performance·Unlimited 에디션 + **Revenue Cloud Advanced 또는 Salesforce Contracts 라이선스**.
- **Track Recipient Signing Progress for Document Envelopes** — envelope의 상태를 갱신해 계약의 **수신자별 서명 진행 상황**을 확인한다. Lightning Experience, **Agentforce Revenue Management(구 Revenue Cloud)** 의 Enterprise·Performance·Unlimited·Developer 에디션 + **Revenue Cloud Advanced 또는 Salesforce Contracts 라이선스**. 실행: 계약 레코드에서 **Update Envelope Status** 클릭.
- **Author Contracts in Government Cloud** — 정부 기관·공공 부문 조직이 Salesforce Contracts로 계약을 작성·라우팅·생성할 수 있다. **활성화 전에 account team과 함께 Context Service와 Document Processing Engine이 조직에 온보딩됐는지 확인**해야 한다. Lightning Experience, **Agentforce Revenue Management(구 Revenue Cloud)** 의 Enterprise·Performance·Unlimited·Developer 에디션 + **Revenue Cloud Advanced 또는 Salesforce Contracts 라이선스**. **Release 264.11, 2026년 7월 1일부터 제공.**
- **Add Clauses to Quotes from Your Clause Library** — 문서 생성 전에 영업 담당자가 **사전 승인된 조항**(표준 보증 면책, 지급 조건, 인도 조건 등)을 검색해 견적에 추가하고, 표준 문구를 딜별 세부 사항으로 커스터마이즈한다. 사용할 조항은 Quote 페이지 레이아웃의 **Quote Special Terms 컴포넌트**에 추가해 결정한다. Lightning Experience, **Agentforce Revenue Management(구 Revenue Cloud)** 의 Enterprise·Performance·Unlimited·Developer 에디션 + **Revenue Cloud Advanced 또는 Salesforce Contracts 라이선스**.

### Document Generation·Contracts 신규/변경 오브젝트

**신규 오브젝트 (10)**

| 오브젝트 | 표현하는 것 |
|---|---|
| `CntrDocRiskElmntFinding` | 계약 문서 risk element에 대한 **AI 생성 risk finding** |
| `CntrDocRiskElmntRvwInpt` | 계약 문서 risk element에 대한 **1회 AI 리뷰의 입력** |
| `CntrDocRiskElement` | 리스크 분석 대상인 계약 문서의 **경계가 지정된 텍스트 블록** |
| `CntrDocRiskRun` | 계약 문서 버전에 대한 **계약 리스크 분석 1회 실행** |
| `CntrDocRiskRunItm` | document risk run 내 **계약 문서 risk element 1건의 처리 레코드** |
| `DocumentPlaybook` | 계약의 작성·검토·협상 방식을 표준화하는 **가이드라인 세트** |
| `DocumentPlaybookAssignment` | document playbook의 **특정 오브젝트·record type 할당** |
| `DocumentPlaybookVersion` | document playbook의 **읽기 전용 버전** |
| `DocumentClauseContentToken` | document clause 콘텐츠에 사용되는 **토큰** |
| `QuoteClause` | **견적에 연결된 조항** |

**변경 오브젝트 (필드 4)**

| 오브젝트 | 신규 필드 | 용도 |
|---|---|---|
| `DocumentClause` | `ClauseTmplVersionIdentifier` | 문서 생성 시 **특정 조항 버전**을 삽입. **이후 새 활성 버전이 게시돼도 항상 같은 버전**을 삽입한다. 조항 저장 시 **자동 채움·읽기 전용** |
| `DocumentClause` | `IsEligibleForTerms` | 해당 조항을 관련 Salesforce 오브젝트에 **추가할 수 있는지 여부** |
| `DocumentClause` | `LatestClauseTmplIdentifier` | 시스템 생성 토큰 식별자로 문서 생성 시 **최신 활성 버전**의 조항을 삽입. 조항 저장 시 **자동 채움·읽기 전용** |
| `DocumentTemplate` | `HasClauseToken` | 문서 템플릿이 **조항 내 토큰을 포함하는지** 표시. **기본값 false** |

### 신규 Connect REST API (Salesforce Contracts)

계약 워크플로에 AI 리스크 리뷰와 playbook 표준을 도입한다 — **계약 문서 버전에 대한 비동기 리스크 분석 시작 및 결과 폴링**, **content document로부터 playbook 버전 생성**, **계약 텍스트 구절에 가장 잘 맞는 playbook 콘텐츠 청크 조회.** (릴리즈 노트 요약 문단 기준. 개별 리소스 경로 카탈로그는 이번 추출 배치에 포함되지 않았다.)

---

## Salesforce Document Generation

- **Populate Clause Content with Merge and Placeholder Tokens** — 조항에 토큰을 추가해 계정명·지급 조건·할인액 등 데이터가 계약 문구에 자동으로 흘러들게 한다.
  - **Merge token** — **Omnistudio Data Mapper 또는 Context Service**를 통해 Salesforce 레코드에서 데이터를 가져온다.
  - **Placeholder token** — 문자열·날짜·통화·백분율 같은 **기본값(default value)** 을 담는다.
  - **범위 구분(원문):** Clause Library의 조항은 **merge token과 placeholder token을 모두 지원**하지만, **Quote Special Terms는 placeholder token만 지원**한다.
- **Eliminate Manual Template Updates When Clause Content Changes** — 문서 템플릿에 **clause token**을 적용하면 생성되는 모든 문서가 **현재 승인된 콘텐츠**를 사용한다. 조항이 바뀌면 생성 문서에 자동 반영된다. 실행: **clause template version identifier 또는 latest clause template identifier**를 조항이 들어갈 위치의 문서 템플릿에 복사 → 문서 생성 시 **clause token이 런타임에 해석**된다. 작성자 조건: **DocGen Designer with Clause Management Permissions.**
- **Generate Documents That Include Tables in Rich Text Fields** — 가격표·비교표·데이터 요약 같은 표 형식 콘텐츠를 생성 문서에 포함한다. 외부 소스에서 **정적 표를 rich text 필드에 복사**하면 생성된 Word 문서에서 **서식·구조·색상이 유지**된다. **⚠️ 정적 표 콘텐츠만 지원하며, 표 안에서 동적 토큰은 사용할 수 없다.** Lightning Experience, **Agentforce Revenue Management(구 Revenue Cloud)** 의 Enterprise·Performance·Unlimited·Developer 에디션 + **Revenue Events Starter Pack 라이선스** + **Revenue Cloud Advanced 또는 Revenue Cloud Billing 라이선스**(⚠️ 같은 절의 Contracts 항목들과 **라이선스 조합이 다르다** — Salesforce Contracts 라이선스로는 대체되지 않는다).

---

## Salesforce Knowledge

- **Reuse Modular Content Across Articles with Knowledge Blocks** — **Knowledge Blocks**는 법적 고지·회사 주소처럼 한 번 만들어 여러 아티클에 삽입하는 **모듈형 재사용 콘텐츠 단위**다. 아티클에는 **관리되는 읽기 전용 블록**으로 삽입되며, **블록의 새 버전을 게시하면 그 블록을 쓰는 모든 아티클에 자동 반영**된다.
- **Create Knowledge Articles from Any Record with Custom Prompt Templates** — 서비스 담당자가 **케이스·인시던트·작업 주문 등 어떤 레코드에서든** Knowledge 아티클 초안을 작성한다. **Prompt Builder**에서 평이한 지시문과 merge field로 **여러 커스텀 프롬프트 템플릿**을 만들어 레코드·시나리오에 맞는 템플릿을 고르게 하고, 레코드에서 직접 또는 **Agentforce를 통해 대화형으로** 아티클을 생성할 수 있다. 이전에는 Einstein Knowledge Creation이 **케이스와 메시징 세션에 한정된 단일 기본 템플릿**만 제공했다.
- **Prevent Duplicate Articles with Knowledge Similarity** — 작성자가 아티클 초안을 작성할 때 지식 베이스에서 **유사 아티클을 확인**한다. **Knowledge Similarity**가 일치하는 아티클을 **백분율 유사도 점수**와 함께 제시해, 중복 생성 대신 기존 아티클 재사용·갱신을 결정하게 한다.

---

## Salesforce Pricing

- **Reduce Pricing Errors and Improve Deal Transparency on Ramp Deals** — 각 세그먼트의 가격 인상률을 **원래 정가(list price)가 아니라 직전 세그먼트의 인상 결과**에서 계산한다(**복리 인상**). 이전에는 ramp deal의 인상이 항상 원래 정가 기준이라, 정가 $100·연 10% 인상의 3년 계약이 **매년 $10씩** 올랐다. 다년 계약 상당수는 **각 해의 인상이 전년의 이미 인상된 가격에 적용되는 복리 방식**을 요구하는데, 복리가 없으면 영업팀이 시스템 밖에서 수동 계산해 오류 위험과 승인자의 가시성 저하를 낳았다.
- **Keep Calculated Values in Context with Local List Variables** — pricing procedure 안에서 **local list variable**을 직접 정의해 계산 값을 요소 간에 저장·재사용한다. 이전에는 계산 값을 저장하려면 **Pricing Procedure Builder에서 context tag나 constant를 미리 생성**해야 했다. 이제 절차를 만들면서 list variable을 **생성·편집·매핑**하고 **Price Waterfall**에서 참조한다.
- **Tailor Pricing Rules for Multiple Industry Clouds** — **Subtype 필드**로 pricing recipe와 pricing procedure를 산업 클라우드별로 분리한다. 각 클라우드가 **자체 기본 recipe와 decision table**을 갖게 되어, 하나의 recipe를 공유하며 무관한 가격 규칙을 조율해야 했던 문제가 사라진다. 절차의 요소 lookup에는 **해당 subtype의 기본 recipe에 속한 decision table만** 표시되어 팀별로 메타데이터를 독립 관리한다.
- **Prorate with High-Velocity and Short-Term Sales Models** — 제품의 proration frequency로 **Weekly**를 설정한다(이전에는 annual·semiannual·quarterly·monthly만 지원). weekly로 설정하면 가격 엔진이 **단가 × 기간 내 7일 주기 수(부분 주 포함)** 로 소계를 계산한다.
- **Avoid Integration Parsing Errors from Pricing API Decimal Values** — Pricing Connect API가 숫자 값을 **과학적 표기법이 아닌 표준 십진 표기**로 반환한다. 예: `1E+7` 대신 **`10000000`**.

### New and Changed Connect REST APIs in Salesforce Pricing (전체 카탈로그)

pricing recipe를 **pricing recipe table mapping 레코드와 함께 복제**하고 복제본에 다른 pricing usage subtype을 선택적으로 지정한다. 특정 pricing usage subtype에 유효한 **pricing element type을 단일 API 요청으로 조회**해(선택된 컨텍스트가 지원하는 요소만 반환) 잘못된 구성을 줄인다. context definition과 pricing procedure를 **vertical 특화 옵션으로 제한**해 설계 시점 거버넌스와 멀티 클라우드 운영을 지원한다.

**New Connect REST API Resources**

| 목적 | 메서드 · 리소스 | 요청 바디 | 응답 바디 |
|---|---|---|---|
| pricing recipe를 그 pricing recipe table mapping 레코드와 함께 복제 | **POST** `/connect/core-pricing/pricing-recipe/clone` | 신규 `Pricing Recipe Clone Input` | 신규 `Pricing Recipe Clone` |
| pricing usage subtype에 유효한 pricing element 조회 | **GET** `/connect/core-pricing/revenue/pricing-recipe/valid-elements` | — | 신규 `Pricing Valid Elements` |

**Changed Connect REST API Request Bodies**

| 요청 바디 | 신규 프로퍼티 | 설명 |
|---|---|---|
| `Procedure Plan Definitions` | `subType` | procedure plan definition의 **vertical 또는 cloud 특화 하위 분류**를 지정 |
| `Procedure Plan Evaluation By Object` | `subType` | procedure plan definition의 **vertical 또는 cloud 특화 하위 분류**를 지정 |

> 카탈로그 총계(원문 확인): **신규 리소스 2개**(POST `.../pricing-recipe/clone`, GET `.../revenue/pricing-recipe/valid-elements`) + **신규 바디 3개** + **`subType` 프로퍼티가 추가된 변경 요청 바디 2개**. 상세는 Revenue Cloud Developer Guide의 *Salesforce Pricing Business APIs*.

---

## 관련 노트

- [[Winter '27]] — 상위 릴리즈 허브 (전체 요약·커버리지·주요 신기능)
- [[Winter '27/Release Updates]] — **강제 적용(Release Update) 시점 단일 출처.** 본 노트의 OAuth 플로 은퇴·Connected App 이행·Setup Audit Trail 권한·게스트 사용자 개인정보 은폐·WCAG 2.2 접근성 4건의 날짜는 모두 그쪽 표가 정본
- [[Winter '27/Development]] — 개발자 spoke (Apex heap 한도·Elastic Limits(Beta)·Apex Symbol API(Beta)·LWC v68.0·API/Metadata/Tooling 카탈로그)
- [[Winter '27/Agentforce]] — AI/에이전트 spoke (Agentforce 빌더·모델·Voice)
- [[Winter '27/Clouds]] — 클라우드 제품 spoke (Automation for Customer 360 Apps and Industries, Experience Cloud "Other Changes" 표의 제품별 항목)
- [[Winter '26/Platform]] — 직전 릴리즈의 같은 spoke
- [[Release MOC]] — 릴리즈 노트 전체 목차
- [[Flow Tests (플로우 테스트)]] — 기존 Flow 테스트 기능 (Test Mode(Beta)·Mock Outputs(Beta)의 배경)
- [[Flow 에러 처리]] — fault path·오류 처리 패턴 (저장 시점 검증·자동 재시도 연계)
- [[Flow 디버깅과 모니터링 - 오류 이메일·인터뷰]] — 디버그·모니터링 (정적 레코드 ID·컬렉션 입력 디버그 연계)
- [[Screen Flow 설계]] — 화면 플로우 설계 (Time 컴포넌트·mass quick action 연계)
- [[Flow 버전 관리와 활성화 - 배포 수명주기]] — 플로우 버전·활성화 (v68.0 versioned update 연계)
- [[Flow 네이밍 컨벤션]] — 네이밍 기반 정리 (Flow Tags 도입 배경)
- [[Flow Orchestration]] · [[Flow Orchestration - 운영과 레퍼런스]] — 오케스트레이션 개념·운영 (Work Guide·동기 background step 연계)
- [[Approval Process — 운영·엔드유저·레퍼런스]] — 승인 프로세스 운영 (Request Approvals 컴포넌트·GDPR 삭제 연계)
- [[Setup Audit Trail (설정 감사 추적)]] — 설정 감사 추적 (View Setup Audit Trail 권한 Release Update 연계)
- [[Named Credential]] — named credential 구성 (custom CA 인증서·trust store 연계)
- [[Certificate and Key Management (인증서·키 관리)]] — 인증서 관리 (Tenant-Specific Trust Store 연계)
- [[Salesforce Connect — 어댑터·Cross-Org·writable·External CDC]] — Salesforce Connect 어댑터 (cross-org 레거시 인증 은퇴 연계)
- [[My Domain (마이 도메인)]] — My Domain·라우팅 (Edge Network 셀프서비스 라우팅·target host name 연계)
- [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]] — 사이트 보안·게스트 사용자 (개인정보 필드 은폐 연계)
- [[Experience Cloud 개요]] — Experience Cloud 제품 개요 (Experience Delivery 중단 맥락)
- [[External Services]] — External Services 개념 (스키마 any 타입 지원 맥락)
