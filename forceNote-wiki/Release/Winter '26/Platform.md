---
tags: [release, winter_26, platform, admin, security, flow, devops, architecture, mobile]
api_version: v65.0
release_date: 2025-10
created: 2026-06-15
source: salesforce_release_notes_5-17-2026 (2).pdf (Salesforce Winter '26 Release Notes, Tier 2)
aliases: [Winter '26 Platform, 윈터26 플랫폼, Database Encryption GA, Secure Roles Behavior, 새 Setup 도메인, JWT 12시간, IPv6 준비, Hyperforce 리전 확장, Flow Transform 인라인, External Services 한도 증가]
---

# Winter '26 — Platform (Admin · Security · Automation/Flow · Mobile · DevOps · Architecture)

> Winter '26(v65.0)의 정책·설정·인프라 변경 — 리스트뷰 다중컬럼 정렬(GA), Database Encryption(GA), 새 Setup 도메인(*.salesforce-setup.com), JWT 토큰 12시간, Secure Roles 프로덕션 강제, Flow 인라인 Transform·중첩 루프(Beta)·LWC Local Action, Hyperforce 리전 확장·IPv6 준비·CloudFront 전환 등. 코드·CLI는 Development, 강제 시점은 Release Updates spoke로 분리.

---

## 개요

이 노트는 **정책·설정·인프라(Admin/Setup, Security 정책, Automation/Flow, Mobile, DevOps, Architecture)** 관점의 Winter '26 변경을 다룬다.

- **상위 허브:** [[Winter '26]] — 전체 릴리즈 요약·주요 신기능
- **개발자(코드·클래스·API) 변경:** [[Winter '26/Development]] — Apex·LWC·ConnectApi·CLI·MCP·패키징·SDK 코드성 항목
- **강제 적용(Release Update) 시점:** [[Winter '26/Release Updates]] — 강제 시점 단일 출처. 본 노트에서 강제성 항목은 한 줄 요약 후 그쪽으로 위임
- **AI/에이전트 변경:** [[Winter '26/Agentforce]] — Agentforce 빌더·모델·Agent Script 등 (단 Security Center의 Agentforce *보안 메트릭*은 정책 맥락이라 본 노트에 둠)

> **분류 원칙:** 정책·설정·인프라 = Platform / 코드·CLI·클래스·SDK = Development. 따라서 DX MCP Tools·`sf package version retrieve`·Mobile SDK 13.1·BarcodeScanner·ESLint 9·2GP 패키징 같은 코드성 변경은 본 노트에서 "정책 맥락"만 한 줄 위임하고 코드 상세는 [[Winter '26/Development]]에 둔다.

---

## Admin / Setup

### 리스트 뷰

- **Sort List Views by Multiple Columns (Generally Available)** — 리스트 뷰를 **최대 5개 컬럼** 기준으로 오름/내림차순 정렬. 단일 컬럼 정렬로 복귀하려면 정렬에 미포함된 컬럼 헤더를 클릭. 마지막 릴리스 이후 일부 변경 포함. Starter·Pro Suite를 제외한 전 에디션. (인쇄 p.285–286)
- **Speed Up List View Configuration with Type-Ahead Search** — 리스트 뷰 필드 편집 시 type-ahead 검색. 첫 글자를 입력하면 알파벳순 첫 필드로 포커스되고 `Ctrl+space`로 선택. 중국어·일본어 등 멀티바이트 언어는 미지원. 전 에디션. (p.286–287)
- **Ensure Visual Consistency in Dynamic Related Lists for Mobile** — 모바일에서 Dynamic Related List–Single 컴포넌트의 related list 아바타가 더 이상 표시되지 않아 오정렬을 방지(데스크톱은 아바타 유지). 전 에디션. (p.287–288)
- **Move between Classic and Lightning with Enhanced List View Editing** — Case 리스트 뷰 필터 편집 일관성 향상. Date Opened·Date/Time Opened 같은 복합/레거시 필터를 편집·클론 가능. Essentials·Starter·Professional·Enterprise·Performance·Unlimited. 자동 제공. (p.288)

### 권한 및 공유

- **Permission Set Licenses Are Removed After Unassigning Permission Sets and Permission Set Groups** — 권한 세트/그룹 해제 시 관련 PSL이 자동 회수되어 수동 제거가 불필요. **단, 자동 회수되지 않는 예외:** user access policy 경유 할당, 다른 권한 세트가 동일 라이선스를 요구하는 경우, 그룹에서 라이선스된 권한 세트만 제거한 경우, **50개 이상을 일괄 해제하는 경우.** Contact Manager·Group·Essentials·Professional·Enterprise·Performance·Unlimited·Developer·Database.com. (p.289)
- **Enable Secure Roles Behavior and Update Sharing Group References in Production (Release Update)** — 기본 공유 그룹이 "Roles and Subordinates" 대신 "Roles and Internal Subordinates"로 표시됨(디지털 익스피리언스 사이트의 외부 사용자가 의도치 않게 내부 레코드에 접근하는 것을 방지). Summer '25 최초 제공, **프로덕션은 Winter '26 강제(enforced).** 코드·커스터마이제이션의 그룹명 참조 업데이트 필수. Enterprise·Performance·Unlimited·Developer. → 강제 시점 [[Winter '26/Release Updates]]. (p.289–290)
- **Sharing Recalculations Run Asynchronously After Large-Scale Changes** — 대규모 역할/그룹 업데이트 후 owner-based 공유 규칙·account owner share 레코드가 성능에 유리할 때 비동기로 재계산됨(이전엔 항상 동기). Setup Audit Trail에서 단계 모니터링. Summer '25 도입, rolling. Professional·Enterprise·Performance·Unlimited·Developer. (p.290–291)

### External Services

- **Build More Robust Integrations with Increased External Services Limits** — External Services 최대 한도 증가. Enterprise·Performance·Unlimited·Developer. (p.291)

```text
# 출처: salesforce_release_notes_5-17-2026 (2).pdf — Customization 섹션 (인쇄 p.291, verbatim)
active objects per org                : 1,250 → 3,000
active operations per org             : 1,250 → 3,000
external service registrations per org:   150 →   700
```

- **Upload and Download Files with External Services Binary File Support** — External Service 등록 시 OpenAPI spec에 PUT/GET operation을 정의해 이미지·PDF 등 바이너리 파일을 외부 시스템에 업로드/다운로드. 파일은 ContentDocument로 저장되며 Flow·Apex의 invocable action에서 사용. Enterprise·Performance·Unlimited·Developer. (p.291–292)

> External Services 개념·OpenAPI 등록 절차는 [[External Services]] 참조.

### 필드 및 오브젝트

- **Create More Custom Fields with the Increased Limit of Activities** — 활동(activities)이 **7억 건(700 million) 미만**일 때 커스텀 필드를 **최대 300개**까지 생성 가능(이전 한도 기준은 활동 400 million). Enterprise·Performance·Unlimited. (p.295)
- **Leverage Enhanced Field History Tracking** — data classification 세부 정보를 포함한 업데이트된 field history tracking UI로 감사·컴플라이언스 프로세스 간소화. Enterprise·Performance·Unlimited·Developer. (p.297)
- **Enable Field History Tracking for Users (Beta)** — User 오브젝트에서 **최대 20개 필드**의 변경 이력을 추적(UI·bulk·Apex·API). old/new 값·timestamp·작성자를 로그. Enterprise·Performance·Unlimited·Developer. (p.296–298)

### Lightning App Builder

- **Configure Salesforce Flow Default Record Pages in Lightning App Builder** — Salesforce Flow 오브젝트의 기본 레코드 페이지를 모든 앱에 사용. Essentials·Professional·Enterprise·Unlimited·Developer. (p.294)
- **View Details About Orchestration Runs** — Orchestration Run 레코드 페이지에 Orchestration Run Details 컴포넌트를 추가해 각 step의 name·type·status를 항상 표시하고, background step 완료 후 Completed By/Completion Time을 표시. Tab 컴포넌트에 추가. Enterprise·Performance·Unlimited·Developer. (p.294–295)
- **Get More Components for Lightning App Builder from Avonni** — 14개 사전 빌드 LWC AppExchange 패키지 제공. Group·Essentials·Professional·Enterprise·Performance·Unlimited·Developer. (p.295)

### Setup 홈 / 글로벌라이제이션

- **Complete Tasks More Efficiently with the New Setup Home Page** — 재설계된 Setup Home(최근 항목 + 추천 작업 타일 + 기능 탐색 타일). **Create 버튼 제거.** SLDS 1 테마/브랜딩만 제한 지원(배경색=SLDS 1 팔레트 최연색, 배경 이미지 미지원). Data Cloud·Service Cloud 등 자체 홈 페이지가 있는 앱에는 미제공. 전 에디션. (p.296–297)
- **Enable ICU Locale Formats (Release Update)** — ICU 로케일 포맷이 JDK 포맷을 대체. Winter '20 최초 제공. **Winter '26에 미강제(not enforced)** — 수동 활성화 권장. en_CA는 별도 활성화 필요. → [[Winter '26/Release Updates]]. (p.292–293)
- **Review Updated Label Translations** — 표준 오브젝트·탭·필드 번역 갱신: Arabic, Chinese(Simplified/Traditional), Czech, Danish, Dutch, Finnish, French, German, Italian, Japanese, Norwegian, Portuguese(Brazil), Russian, Slovenian, Swedish. (p.293)
- **Adopt New Currency for Bulgaria** — **2026년 1월 1일** 불가리아 EU 가입으로 **lev(BGN) → euro(EUR)** 통화 전환. 트랜잭션에서 lev를 사용 중이면 통화 설정 업데이트. (p.293–294)

### DX Inspector (코드/CLI — Development 위임)

다음 3종은 Customization 섹션에 있으나 코드·소스 추적성 항목이므로 정책 맥락만 남기고 상세는 위임한다. → [[Winter '26/Development]]

- **Enhance Trust and Security with the DX Inspector Opt-In** — DX Inspector의 Change Management 페이지 접근 전 약관 동의(opt-in) 필요. (p.298)
- **Streamline Change Management with Commits from DX Inspector** — DX Inspector Change Management에서 source repo로 직접 커밋. (p.298)
- **Add Metadata Manually for Comprehensive Change Tracking** — source-tracked 되지 않은 메타데이터를 수동 추가. (p.298)

---

## Automation / Flow

> Salesforce Flow는 Winter '26에서 대규모로 갱신됐다(인쇄 p.1069–1159). 본 노트는 **정책·설정·기능 관점의 GA/Beta/Release Update**를 정리하고, Test Discovery/Runner API·On-Demand Flow REST 같은 코드성 호출은 [[Winter '26/Development]]로 위임한다.

### GA

- **Activate Data Cloud Segments to Any API-Based Destination with Activation-Triggered Flow (Generally Available)** — activation-triggered flow가 Data Cloud activation 완료 후 실행되어 external services·MuleSoft connector로 contact/lead/opportunity를 생성·업데이트. Data Cloud Enterprise·Performance·Unlimited·Developer. 2025년 10월부터. (p.1071, 1078–1080)
- **Trigger a Flow When a File Is Attached to a Record (Generally Available)** — 파일 타입·확장자·파일명·Created By 기준으로 flow를 트리거(Automation Event-Triggered Flow + File Attach event). Salesforce Classic·Lightning(Professional API add-on·Performance·Enterprise·Unlimited). (p.1071, 1080–1081)
- **Add Individuals to Marketing Journeys with the Send to Journey Action (Generally Available)** — Send to Journey action으로 Marketing Cloud Engagement journey에 개인을 전송. MC Engagement + MC Next. (p.1091–1092, 1098)
- **Find Resources Faster with Updates to the Resource Menu** — 현재 위치/데이터 타입에 관련된 옵션만 표시. 중첩 리소스를 포함하는 expanded search가 GA. Essentials·Professional·Enterprise·Performance·Unlimited·Developer. (p.1070–1074)

### Flow Builder (신규/변경)

- **Automate Complicated Decisions in Flows with Generative AI** — Decision element가 생성형 AI로 비정형 데이터 기반 결정을 수행("Let AI Determine Conditions"). Einstein for Sales/Service/Platform add-on, Einstein Requests credit 소비. **AI Decision은 MC flow·record-triggered flow·record-triggered orchestration·flow approval process에서 미지원.** Enterprise·Performance·Unlimited. (p.1070, 1072–1073)
- **Add Newly Created Records Immediately to a Flow** — Create Records element 후 Get Records 없이 생성된 레코드의 필드를 즉시 참조. **주의: API v64 이하는 string을 반환하나 v65부터 field ID를 반환** → 기존 참조를 ID 필드로 변경해야 함. 전 에디션. (p.1071, 1074–1075)
- **Process Unstructured Data with Vector Search Data Actions** — automation-event triggered flow가 vector search data action으로 PDF·text·audio·video·image 등 비정형 데이터를 처리. Data 360 Enterprise·Performance·Unlimited·Developer. 2025년 12월부터. (p.1071, 1074)
- **Send Messages to Dynamic Audiences with Broadcast Flows** — dynamic segment로 대규모 메시지 전송(Broadcast flow는 wait element 미지원). Data Cloud Enterprise·Performance·Unlimited·Developer. 2025년 10월부터. (p.1071, 1080)
- **Track Your Keyboard Focus in Flow Builder** — 항목 추가/삭제 시 포커스 항목에 파란 외곽선(WCAG 2.4.7). Essentials·Professional·Enterprise·Performance·Unlimited·Developer. (p.1071, 1078–1079)

### Flow Actions / Runtime

- **Let Flows Decide Whether a Transaction Is Required** — wait/async action의 트랜잭션 제어를 flow가 동적으로 결정. **Winter '26 이후 기본값 "Let the flow decide".** Essentials·Professional·Enterprise·Unlimited·Developer. (p.1101–1110)
- **Transform Data for Actions in Element Setup** — 별도 Transform 요소 없이 Element Setup의 Transform Data Mapping으로 다중 소스를 단일 입력으로 변환(허브의 "인라인 Transform 처리"에 해당). (p.1101–1110)
- **Include Email Address Collections and Lists in One Recipient Field** — Send Email action v2.0.1: 이메일 collection과 개별 주소를 동일 필드에 입력. API v65 미만으로 export 시 v1.0.1로 다운그레이드. (p.1101–1110)
- **Use the Updated Request an Approval Action** — Record ID·Submitter ID 필수 입력. firstApprover가 group/queue API name을 허용. (p.1101–1110)
- **Flow and Process Run-Time Changes in API Version 65.0** — API v65.0+ flow/process에 적용: Data Tables가 Field/Language 변경 후 자동 갱신, Data Table 사용 필드 삭제 방지, Section 컴포넌트 spacing 개선, LWR 사이트 버튼 스타일, Apex Invocable Action의 Null ID 평가, Data Table 컴포넌트 복합 데이터 표시. (p.1115–1116)

### Flow Management

- **Compare Flow Versions to Track Changes More Efficiently** — 두 flow 버전을 비교(autolaunched/scheduled/platform event/record-triggered). Essentials·Pro Suite·Professional·Enterprise·Performance·Unlimited·Developer·Einstein 1. (p.1116)
- **Use Persistent Logging to Log Flow Data with More Flow Type Support and Enhanced Details** — persistent logging이 record-triggered·platform event-triggered flow까지 지원. FlowRun/FlowElementRun report type, Data Cloud credit 소비. Essentials~Einstein 1. (p.1116–1123)
- **Simplify Packaged Subflow Installations** — 2GP managed package flow 설치 시 draft subflow를 참조할 때 Manage Flow 권한이 불필요. (p.1116–1123)
- **Manage Your Time-Based Automations** — Setup의 "Time-Based Workflow" 페이지가 "Time-Based Automations"로 개명(schedule-triggered flow + scheduled path + workflow action 통합 뷰). 2025년 7월부터. (p.1116–1123)

### Flow Extensions

- **Enhance Invocable Apex Configuration Designs with New Action Extension Metadata** — `InvocableActionExtension` 메타데이터 타입으로 입력 순서·collapsible section·conditional visibility를 정의. Essentials·Pro Suite·Professional·Enterprise·Performance·Unlimited·Developer. (코드 상세 → [[Winter '26/Development]]) (p.1123–1124)
- **Select API Connections for Each Action in Flow** — API Catalog의 activated action별 API connection을 선택. Developer·Enterprise·Performance·Unlimited. 2025년 9월부터. (p.1123–1124)

### Flow Release Updates (강제 시점 → Release Updates 위임)

아래 항목은 강제 시점이 핵심이므로 시점은 [[Winter '26/Release Updates]]에 둔다.

- **Restrict User Access to Run Flows (Release Update)** — 올바른 Profile/Permission Set 없는 사용자는 Flow 실행 불가, FlowSites org 권한 deprecate. Winter '24 최초 제공, **Winter '26 강제.** 전 에디션. (p.1124–1127)
- **Enforcing No-Argument Constructor on Apex Classes Used for Invocable Action Parameters (Release Update)** — `invocableVariable`로 쓰이는 Apex 클래스의 no-arg constructor visibility 강제. Summer '24 최초, **Summer '26로 연기.** Enterprise·Performance·Unlimited·Developer. (p.1124–1127)
- **Sort Apex Batch Action Results by Request Order (Release Update)** — Apex 배치 액션 결과를 요청 순서대로 정렬(현재 오류 우선 정렬에서 변경). **Summer '26 적용.** Enterprise·Performance·Unlimited·Developer. (p.1124–1127)
- **Control NBA Widget Refresh in Lightning Console Tabs (Release Update)** — NBA widget이 탭 전환 시 새로고침되는 것을 비활성화하는 옵션. Enterprise·Performance·Unlimited·Developer. (p.1124–1127)

### Flow Approval Processes / Orchestration (주요)

- **Flow Approval Processes** — Flow Builder에서 디버그/롤백 모드 트러블슈팅, Manual Output으로 디버그 step 제어, autolaunched 승인 프로세스 관리(Approval Designer + View Orchestration 권한), 활성화 관리(Submit for Activation), **외부 시스템에서 승인 프로세스 트리거**(MuleSoft for Flow add-on, NetSuite 예시), Resource assignee type으로 쉬운 할당, 큐 이메일 알림 제어. 모두 Enterprise·Performance·Unlimited·Developer. (p.1127–1136)
- **Flow Orchestration** — Flow Builder 트러블슈팅, Manual Output 디버그, **외부 시스템 변경 트리거**(External System Change-Triggered Orchestrations, MuleSoft for Flow add-on, Jira/NetSuite 예시), Dynamic Resource Assignment, 큐 이메일 알림 제어, 생성형 AI Decision, Orchestration Run Details 컴포넌트, Orchestration Work Guide 개명. (p.1136–1141)

### Automation App / Flow 기본 레코드 페이지

- **Find Where Actions Are Used (Beta)** — Action Hub 탭에서 invocable action 검색·사용처 확인. Essentials~Developer. (p.1141)
- **Navigate to the Automation App from Setup** — Setup에 Automation app 링크 추가("Automation Home (beta)" 페이지 대체). (p.1141–1145)
- **Use Updated Salesforce Flow Default Record Page Layouts** — Flow 오브젝트의 기본 레코드 페이지 표준화. 아래는 PDF 매트릭스(인쇄 p.1144)를 셀 단위로 옮긴 것이다.

```text
# 출처: salesforce_release_notes_5-17-2026 (2).pdf — Automation App (인쇄 p.1144, verbatim 매핑)
# 컬럼: Lightning App Builder Page Label | Change | Object Label | Object API Name
Flow Page Default              | Related tab → Versions 로 개명                          | Flow Record         | FlowRecord
Orchestration Page Default     | Details tab 추가                                         | Orchestration       | FlowOrchestration
Orchestration Run Page Default | Work Items related list + Orchestration Run Details 추가 | Orchestration Run   | FlowOrchestrationInstance
Orchestration Version Page Def | Orchestration Work Guide 컴포넌트 추가                    | Orchestration Version | FlowOrchestrationVersion
```

### Beta / Pilot / Dev Preview (Flow)

| 제목 | 성숙도 | 한 줄 | 인쇄p |
|---|---|---|---|
| Get Related Records Across All Levels with Nested Loops | Beta | nested loop으로 다단계 관련 레코드 접근("Also add related records (beta)") | p.1075 |
| Get More Accurate Draft Flows with Einstein Next Generation | Beta | AI가 record/schedule-triggered flow draft 정확도 향상(Einstein Requests credit) | p.1077 |
| Use Static Resource Images in Display Text Components | Beta | static resource 이미지로 환경 간 영속·packageable | p.1088 |
| Find Where Actions Are Used | Beta | Action Hub로 invocable action 사용처 검색 | p.1141 |
| Display Complex Data with Apex-Defined Collection Support in Data Tables | 신규 | Data table에 Apex-defined collection(Unique Identifier 필드 필요) | p.1081–1090 |
| Make Screen Flows More Powerful with LWC Local Actions | 신규 | screen flow에서 LWC local action(toast·레코드 이동 등). 코드 상세 → [[Winter '26/Development]] | p.1081–1090 |

> **MuleSoft for Flow: Integration** — 약 150개 서드파티 connector 추가(일부 Beta, 대부분 GA), 더 잦은 poll trigger, 조건부 트리거, 통합 템플릿(Salesforce↔Salesforce Case Replication, OpenAI Case Urgency Classification) 등. Professional(API add-on)·Performance·Enterprise·Unlimited + MuleSoft for Flow add-on. (p.1145–1159)

---

## 보안 / 정책

> Security/Identity/Privacy 섹션(인쇄 p.1161–1196). GA 항목은 "(Generally Available)" 마커를 명시한다.

### Identity & Access Management

- **Improve JWT-Based Access Token Timeout Management** — JWT 기반 액세스 토큰 timeout 옵션 확장: app-specific 값을 **최대 12시간**까지 설정 가능(이전 30분 제한), 또는 profile/org session 설정을 적용. named·guest user 토큰 모두. 전 에디션. (p.1166)
- **Stage and Rotate External Client App Credentials** — External Client App의 consumer key/secret을 OAuth Credentials endpoint로 주기적으로 staging/rotate/delete. Group·Essentials·Professional·Enterprise·Performance·Unlimited·Developer. (p.1166)
- **Set Up or Migrate Mobile Features and Notifications by Using the External Client App Framework** — ECA 프레임워크로 모바일 기능·알림 구성(mobile app plugin: screen lock / push notification plugin / notifications plugin). Professional·Performance·Unlimited·Developer. (p.1166) → [Mobile](#mobile) 참조
- **Keep Your Favorite Accounts Together in Environment Switcher** — Environment Switcher Favorites(star 아이콘) + log in with email 경험. (p.1166)
- **Reset Your Password with Your Email Address** — username을 잊은 경우 이메일만으로 비밀번호 재설정("Use Your Email Address"). Personal·Essentials·Professional·Enterprise·Performance·Unlimited·Developer. Winter '26 rolling. (p.1167)
- **Validation and Usability Changes for Security Questions** — 보안 질문 답변은 **최소 5자**(Winter '26 이후 설정분에만 적용). 전 에디션. (p.1167, 1177)
- **All Available Verification Methods Are Displayed in New Orgs** — 신규 org(Winter '26+)에서 모든 verification method를 기본 표시(built-in authenticators·physical security keys·Salesforce Authenticator). (p.1167, 1176)
- **Usernames Can't Contain Zero-Width Space Characters** — username에 zero-width space 유니코드 문자를 저장하면 에러. 전 에디션. (p.1176)
- **Spend Less Time Helping Users with Account Setup** — welcome email의 verification link를 **7일 내** 재클릭하면 account setup 재개. 2025년 10월부터. 전 에디션. (p.1167)
- **Log In to a Sandbox with Your Email Address** — test.salesforce.com에서 이메일로 로그인. Winter '26 rolling. (p.1167)
- **Step Added to Verification Process for Email Address Changes** — 이메일 변경 검증에 "Verify Email Address" 버튼 단계가 추가됨. 전 에디션. (p.1167)
- **Custom Welcome Email Templates for Internal Users Now Use Your Default No-Reply Email Address** — custom welcome email이 verified Default No-Reply Address로 발송(support@/no-reply@salesforce.com 미사용). 전 에디션. (p.1167)

### OAuth / SAML

- **Identify Issues with Invalid Scopes in the Client Credentials Flow** — OAuth 2.0 client credentials flow가 unsupported scope만 포함하면 access token을 반환하지 않고 `invalid_grant` 에러. `web`·`refresh_token`·`full` scope 미지원. 전 에디션. (p.1173)

```json
// 출처: salesforce_release_notes_5-17-2026 (2).pdf — Identity & Access (인쇄 p.1173, verbatim 응답)
{
  "error": "invalid_grant",
  "error_description": "no valid scopes defined"
}
```

- **Troubleshoot SAML Errors Caused by the InResponseTo Attribute** — SAML Assertion Validator가 만료된 `InResponseTo` timestamp를 명시. 전 에디션. (p.1167, 1174)
- **Migrate to a Multiple-Configuration SAML Framework (Release Update)** — single-configuration SAML 프레임워크 제거, multiple-configuration만 지원. **프로덕션은 Spring '26 강제**(샌드박스는 Summer '24 강제). Enterprise·Unlimited·Developer. → [[Winter '26/Release Updates]]. (p.1175)
- **Changes to Triple DES Support Are Postponed** — Triple DES SAML SSO 중단이 **연기됨**(Winter '26에 계속 동작). AES 128/256으로 전환 권장. 전 에디션. (p.1167)
- **Review Changes to Device Activation** — 2025년 11월부터 허용 IP가 16,777,216개를 초과하면 unrecognized browser/device에서만 verification. 2026년 1월부터 SSO에도 device activation 적용. 프로덕션·샌드박스. (p.1167)

### 도메인 / 네트워크

- **Update References to Legacy Host Names (Release Update)** — 레거시(non-enhanced) host name 리다이렉션 종료. 프로덕션·데모 org. Spring '25 최초, **Winter '26 자동 활성화, Spring '26 강제.** Group·Essentials·Professional·Enterprise·Performance·Unlimited·Developer. → [[Winter '26/Release Updates]]. (p.1162)
- **Test the End of Legacy Host Name Redirections in New Sandboxes** — Winter '26 patch 11부터 신규 샌드박스에서 "Redirect previous My Domain URLs" 설정 사용 가능. (p.1162–1166)
- **Replace Instanced URLs in API Traffic** — API 트래픽의 instanced URL을 My Domain login URL로 교체. **Summer '26 중단.** Database.com 제외 전 에디션. (p.1164)
- **Route Traffic Through Salesforce Edge Network Locations in Japan Only** — 일본 instance org의 regional routing(데이터 거주). 일본 Hyperforce instance만. My Domain → Routing and Policies → `Regional`. (p.1164–1165) → [Architecture](#architecture--infrastructure)
- **A Warning Was Added for Potential Custom Domain Disruption** — Salesforce Edge Network 이동 시 custom domain 중단 경고를 My Domain Setup 페이지에 표시. Enterprise·Performance·Unlimited. (p.1165)

### Named Credentials

- **Simplify Integrations with External Auth Identity Provider Support for Client Credentials** — external auth IdP가 OAuth 2.0 client credentials flow를 완전 지원(audience 등 custom request parameter). Apex 코드 불필요. `Client Credentials Flow` / `Client Credentials Flow Managed by External Auth Provider` 옵션. 전 에디션. (p.1182–1183)
- **Keep OAuth Credentials Secret with AWS Secrets Manager** — AWS Secrets Manager managed external secrets로 client secret을 노출 없이 staging/rotate. Group·Essentials·Professional·Enterprise·Performance·Unlimited·Developer. Winter '26 rolling. (p.1181)

### Salesforce Shield

- **Get to Know the New Shield Experience** — Shield app(중앙 앱)에 Event Monitoring·Field Audit Trail·Platform Encryption Setup 페이지 + Data Detect·Field History Explorer를 native로 통합. View Shield App Pages 권한. Enterprise·Performance·Unlimited·Developer + Shield/Event Monitoring/Field Audit Trail/Shield Platform Encryption add-on. (p.1183–1192)

#### Shield Platform Encryption

- **Encrypt Your Entire Database (GA Release)** — **Database Encryption 정식 출시(GA).** Hyperforce cell에서 Database Encryption을 활성화하면 암호화된 데이터를 기능·성능 trade-off 없이 정렬·필터·참조 가능. 필요 시 개별 필드에 Field Level Encryption도 적용. tenant-specific Shield key 사용. 모든 Hyperforce instance에 배포 중. Enterprise·Performance·Unlimited·Developer. (p.1190–1191) — Hyperforce 섹션(p.573, 576)에도 중복 정의됨. → [Architecture](#architecture--infrastructure), 개념은 [[Platform Encryption]]

```text
# 출처: salesforce_release_notes_5-17-2026 (2).pdf — Shield Platform Encryption (인쇄 p.1191, verbatim)
Encryption Settings → "Encrypt the Transactional Database" 토글
(cell이 Database Encryption 활성화 상태일 때만 토글 표시)
```

- **Encrypt Tableau Personal Orgs with Platform Encryption for Data Cloud** — Tableau Next personal org 암호화 지원. (p.1191)
- **Encrypt Fields on New Credit Profile Objects in Automotive Cloud** — Party Credit Profile 등 5개 오브젝트의 필드 암호화. (p.1183–1192)

#### Data Detect

- **Data Detect (Generally Available)** — **Data Detect 정식 출시(GA).** native 플랫폼 기술로 민감 데이터를 식별. 마지막 릴리스 이후 변경 포함. Enterprise·Unlimited·Developer + Salesforce Shield add-on. (p.1183–1186)
  - **Expand Data Scanning with 100 Objects and 200 Fields** — 단일 정책으로 100개 오브젝트·200개 필드 스캔(1–365일 주기). (p.1184)
  - **Customize Sensitive Data Types** — 커스텀 민감 데이터 타입 정의. (p.1184)
  - **Use Data Cloud with Data Detect (Beta)** — Data Cloud로 대량 민감 데이터 스캔. (p.1186)
  - **Data Detect Managed Package End of Support in Spring '26** — 관리형 패키지 버전은 **Spring '26 retirement.** Shield app 버전으로 전환. (p.1186)

#### Field Audit Trail

- **Define Retention Policies Declaratively with Field Audit Trail** — 코드 없이 선언적 field history tracking UI로 보존 정책 설정. Enterprise·Performance·Unlimited·Developer. (p.1189)
- **Explore History Changes for Tracked Fields** — Field History Explorer로 추적 필드 이력 탐색. Shield app에서 접근. (p.1183–1192)

#### Event Monitoring

- **Store and Query Even More Event Data in Standard Objects** — Event Log Objects 프레임워크 — Canada·India·Singapore에 신규 가용. (p.1187)
- **Track Agent Activity with New Fields in Event Log Objects and Event Log File Types** — 신규 필드 `BotId`·`BotSessionId`·`PlannerId`를 Rest API·API Total Usage·Unique Query·Invocable Action·Flow Execution·Apex Execution·Apex Callout Event 7종에 추가. (p.1187)
- **Track Agent Activity with Real-Time Events** — ApiEvent·ReportEvent에 신규 필드 추가로 에이전트의 데이터 접근을 Real-Time Event로 추적, Transaction Security Policy 작성 가능. (p.1188)
- **Spot Trends in Object Data with New Event Log Object Analytics Dashboards (Beta)** — CRM Analytics Event Log Object Analytics 템플릿 대시보드. (p.1187–1188)

### Security Center — Agentforce 보안 메트릭

> **Track Agentforce Metrics to Enhance Your Security Posture** — Agentforce 구성·배포 가시성을 위한 신규 보안 메트릭으로 AI 리스크를 식별·완화. Security Center 좌측 nav에 신규 **Agentforce** 카테고리 추가. **Data 360 powered이며 메트릭 페이지 토글로 수동 활성화 필요.** Enterprise·Performance·Unlimited·Developer + Security Center & Agentforce Platform add-on. (인쇄 p.1192–1194)

| 메트릭 | 핵심 | 인쇄p |
|---|---|---|
| **View AI Gateway Usage Event Details** | AI Gateway 사용량 시각 트렌드 + 개별 AI Gateway usage event 상세 테이블(패턴·메타데이터) | p.1192 |
| **Monitor the Number of Detected Prompt Injection Attacks** | 탐지된 **prompt injection 공격 수** 추적. 2025-10-23부터 | p.1193 |
| **Track Agent Versions Across All Tenants** | 모든 tenant의 활성 **agent 버전**·agent topic 상세 추적(권한 보안 검토 우선순위) | p.1193 |

> **객체 API name 표기:** 위 3개 메트릭은 다음 API 객체로 뒷받침된다 — `TenantScrAIPrmptInjection`(탐지된 prompt injection data 저장)·`TenantSecurityAIGtwyUsage`(Einstein gen AI gateway usage)·`TenantSecurityConfigAgent`(Agentforce Agent metric). (API objects 카탈로그, 인쇄 p.437에서 확인. 상세 필드는 [[Winter '26/Development]]의 API New&Changed Objects 참조.)

### Agentforce for Security

- **Streamline your security tasks by creating a dedicated Security Agent** — Security Assistance template로 Security Agent를 생성하고, Summarize User Activity agent action으로 사용자 활동 스냅샷을 얻으며, Security Center app 내에서 Agentforce에 접근. Enterprise·Performance·Unlimited·Developer + Security Center & Agentforce Platform add-on. (p.1193–1195)

### Platform Tracing / 기타 보안 변경

- **Get Detailed Visibility Into Every Platform Action (Platform Tracing)** — 모든 Platform Action(Flow·Apex)을 end-to-end로 추적해 agent activity 가시성 확보, Data Cloud에 저장. 2025-08-04부터(account exec 통해 활성화). Setup → Einstein Generative AI → Einstein Feedback & Monitoring Setup → End-to-End Platform Tracing 토글. Enterprise·Performance·Unlimited. (p.1195)
- **Review and Update Your Referrer Policy** — `referrer-policy` HTTP header 기본값이 `origin-when-cross-origin` → `strict-origin-when-cross-origin`으로 변경(Firefox·Safari는 origin-when-cross-origin 미지원). 전 에디션. (p.1196)
- **Troubleshoot Only Relevant Trusted URL and Browser Policy Violations** — Trusted URL and Browser Policy Violations 리스트가 최근 7일 violation만 표시(last violation date 일별 갱신). Winter '26 patch 9(샌드박스)/patch 12(기타). Enterprise·Performance·Unlimited·Developer. (p.1196)
- **An Unused Domain Was Removed from the Delivered Content Security Policy** — 미사용 `my-salesforce-cms.com`을 delivered CSP에서 제거. 전 에디션. (p.1196)

---

## Mobile

> Mobile 섹션(인쇄 p.912–920)에는 명시적 "(Generally Available)" 마커 항목이 없다(ESLint 9만 GA). 코드성(Mobile SDK·MCP·BarcodeScanner·ESLint)은 [[Winter '26/Development]]로 위임한다.

### 정책 / 설정

- **Log In Without Your Username** — 모바일 앱에서 이메일만으로 로그인(이전엔 데스크톱 한정). 프로덕션 org만, "Production - Log in with email, no SSO" 선택. 다중 계정 시 이메일로 verification code. 전 에디션·전 버전. (p.915)
- **Create and Distribute Mobile Publisher Apps by Using External Client Apps** — External Client Apps가 Mobile Publisher 신규 앱 표준이 됨(Connected App 대체). 거의 모든 Connected App이 Winter '26 동안 rolling 마이그레이션. OAuth/Session Policies가 Manage Connected Apps → External Client App Settings로 이동. Mobile Publisher for Experience Cloud + Salesforce Mobile App(iOS/Android). Enterprise·Performance·Unlimited. (p.915–916)
- **Set Up or Migrate Mobile Features and Notifications by Using the External Client App Framework** — ECA 프레임워크로 모바일 기능·알림 구성(mobile app plugin: screen lock / push notification plugin / notifications plugin). 알림 구성된 Connected App이 ECA 마이그레이션 대상. Professional·Performance·Unlimited·Developer. (p.916–917)
- **Assign a Briefcase to an External Client App** — Briefcase Builder로 ECA 포함 모든 앱의 레코드 데이터를 선택(Briefcase Priming API 오프라인 동기화). (p.917)
- **Bring Conversational AI to Your Mobile App Users** — Agentforce Mobile SDK로 네이티브 앱에 generative AI 임베드. Enterprise·Performance·Unlimited·Agentforce 1·Developer. (SDK 코드 → [[Winter '26/Development]]) (p.915)
- **Updated Requirements for Mobile Publisher Apps on Android Devices** — Mobile Publisher Android 앱의 최소 OS가 **Android 10.0 이상**으로 상향. 전 버전. (p.916, 918)
- **New Version of Test Harness Improves Performance for Switching Applications and Service Documents** — Salesforce Mobile App ↔ Field Service app 전환 성능 향상(Mobile SDK 13 기반). iOS(app file)·Android(APK). PDF에 폰 스크린샷 있음 — 본 노트는 텍스트 설명만. (p.917–919)

### 플랫폼 요구사항 (verbatim)

```text
# 출처: salesforce_release_notes_5-17-2026 (2).pdf — Mobile (인쇄 p.913, verbatim)
Operating System and Version Requirements:
  Android 11.0 or later, Android WebView 90.0 or later
  iOS 17.0 or later
```

> **테스트 디바이스 목록(인쇄 p.914)** 및 **Salesforce App Enhancements 매트릭스(p.913)** 도 PDF에 verbatim으로 존재한다. 매트릭스의 unique 값은 `Yes`/`No`/`NA`/(빈칸)이며, Updated Requirements for Mobile Publisher(Android Yes / iOS No / NA) · Log In Without Your Username(Android Yes / iOS Yes)으로 매핑된다. 디바이스 전체 목록은 본 spoke 범위를 넘어 생략한다.

### Beta (Mobile)

| 제목 | 한 줄 | 인쇄p |
|---|---|---|
| Mobile MCP Tools Now Available on Salesforce DX MCP Server (Beta) | Mobile Offline 패턴 준수 LWC용 MCP toolsets(`mobile`/`mobile-core`, DX MCP Server v0.21.2). 코드 → [[Winter '26/Development]] | p.919–920 |

---

## DevOps / CLI

> 코드·CLI·패키징·MCP 항목은 [[Winter '26/Development]]에 둔다. 본 노트는 **배포 정책·샌드박스·서비스 종료** 같은 정책/인프라 관점만 정리한다.

### Deployment (정책 관점)

- **Deploy Metadata (Beta) and Data (Developer Preview) More Efficiently Between Salesforce Orgs** — 단일 오케스트레이션으로 메타데이터·구성 데이터를 source org → target org로 이동. 모든 샌드박스/scratch org(Lightning). Metadata/data deployment은 Professional·Enterprise·Performance·Unlimited·Developer. **2025-10-30**부터 활성화 가능, Customize Application 권한 필요. 활성화 경로: Setup → Change Management → `Org-to-org Metadata Deployment (Beta)` → `Data Deployment (Developer Preview)`. 코드/명령 상세 → [[Winter '26/Development]]. (인쇄 p.357)

### 허브 인라인 항목 (이 추출 범위 밖 — 표기 유지)

다음은 기존 [[Winter '26]] 허브의 DevOps/CLI·Architecture 절에 있으나, 본 추출(Platform 지정 페이지 범위 = Customization·Deployment·Hyperforce·Mobile·Flow·Security)에서는 **PDF로 직접 확인되지 않았다.** 코드성·패키징·환경 섹션은 [[Winter '26/Development]] 소관이므로 삭제하지 않고 위임 표기만 남긴다.

- **DevOps Center MCP Tools / Apex·Flow Unit Testing 통합 (DevOps Testing)** — LLM 머지 충돌 분석, Apex/Flow 테스트를 DevOps Testing 프로바이더로 등록. → [[Winter '26/Development]]
- **Salesforce DX MCP Server (Beta) / LWC MCP Tools (Beta) / `sf package version retrieve`** — 자연어 DX 작업, IDE LWC 개발, 패키지 버전 메타데이터 다운로드. → [[Winter '26/Development]]
- **2GP 완전 전환("Move to 2GP") / 1GP Released → Beta 되돌리기** — 패키징 항목. → [[Winter '26/Development]]
- **Full Sandbox Quick Create / Quick Clone(전체 타입, Hyperforce)** — 샌드박스 생성·복제 2~3배 향상(Environments 섹션, 범위 밖). [Architecture](#architecture--infrastructure)에 인프라 맥락 정리.
- **Salesforce Functions 서비스 종료** — 신규 구매·갱신 불가, 기존 계약 기간 내 사용 후 마이그레이션 필요. (허브에만 있음 — 이 추출 범위 밖, 미확인)
- **Change Data Capture 커스텀 Formula 필드 포함 / Data Export 다운로드 속도 제한(파일 1개씩, 60초 대기)** — (허브에만 있음 — 이 추출 범위 밖, 미확인)

> Apex/Flow Test Discovery & Runner API(REST로 테스트 탐색·실행, API v65.0+)는 Flow Testing 섹션(p.1114)에서 확인됐으나 코드성 호출이므로 [[Winter '26/Development]]에 둔다. 본 노트는 "CI/CD에 Apex·Flow 테스트 통합" 정책 맥락만 언급한다.

---

## Architecture / Infrastructure

> Hyperforce·CDN·IPv6·TLS·새 Setup 도메인·Edge Network·ACRC 등 인프라 변경(인쇄 Hyperforce p.573–576, Salesforce Overall p.171–177).

### 새 Setup 도메인

- **Add the New Setup Domain** — Setup 페이지가 `*.salesforce-setup.com` 도메인으로 호스팅됨. **방화벽/allowlist에 `*.salesforce-setup.com` 추가 필요.** Winter '26부터 프로덕션 롤아웃 재개(Spring '24 시작, Winter '25 샌드박스/비프로덕션, Spring/Summer '25 일시 중단). 전 에디션. (p.171)

```text
# 출처: salesforce_release_notes_5-17-2026 (2).pdf — Salesforce Overall (인쇄 p.171, verbatim)
allowlist 추가: *.salesforce-setup.com
```

### Hyperforce

- **Access Salesforce in More Regions with Hyperforce** — Hyperforce가 **17개국**에서 가용. Customer 360 suite(Sales·Service·B2B Commerce·Platform·Industries Cloud)가 자동 가용: Australia, Brazil, Canada, France, Germany, India, Indonesia, Israel, Italy, Japan, Singapore, South Korea, Sweden, Switzerland, UAE, UK, US. (p.573–574)
- **Encrypt Your Database With Salesforce Database Encryption (Generally Available)** — Salesforce Shield로 Hyperforce 상 전체 org 암호화. **이전 beta → 현재 GA.** Enterprise·Performance·Unlimited·Developer(Database Encryption 활성화된 cell의 Hyperforce). Security 섹션(p.1190–1191)에 상세. → [보안/정책 § Shield Platform Encryption](#보안--정책) (p.573, 576)
- **New Products and Features Available in Government Cloud Plus** — GovCloud org에 Agentforce Service Agent·Employee Agent, Data Cloud, Digital Engagement and Enhanced Messaging, Marketing Cloud, Service Cloud Voice, Tableau Next 신규 제공. Enterprise·Unlimited(GovCloud). (p.575–576)
- **Add Direct Network Connectivity to Hyperforce with AWS Direct Connect (DX)** — 기업 네트워크 → Hyperforce org 직접 연결(규제·보안 요건). telecom 서비스 제공자가 전달. 데이터 거주 제한 시 자국 Edge로 ingress 제한 가능(My Domain → Routing and Policies → `Regional`, 현재 일본 Hyperforce instance만). (p.576)
- **Salesforce Out of Region Disaster Recovery Renamed to Advanced Cross-Region Continuity (ACRC)** — Hyperforce 호스팅 org만 해당. (p.576)

#### Hyperforce Geo Expansion 매트릭스 (인쇄 p.574–575)

PDF 표 방향은 row=Cloud, 컬럼=Cloud / Product or Feature / Description / Available In. "Now available"(신규 리전)과 "Also available"(기존 리전)을 구분해 옮긴다.

```text
# 출처: salesforce_release_notes_5-17-2026 (2).pdf — Hyperforce (인쇄 p.574–575, verbatim 매핑)
Data Cloud   (Agentforce, Data Cloud, UMA, Einstein)
  Now : France, Indonesia, South Korea, UAE
  Also: Australia, Brazil, Canada, Germany, India, Japan, Singapore, Switzerland, UK, US
Marketing Cloud (Engagement / Advanced / Growth)
  Now : Growth·Advanced editions in India
  Also: Australia, Canada, India, Japan
Platform     (Event Log Objects — 표준 object에 event data 저장·쿼리)
  Now : Canada, India, Singapore
  Also: Australia, France, Germany, Italy, Japan, Sweden, Switzerland, UK, US
Tableau      (Tableau Cloud — 풀호스팅 enterprise-grade 분석)
  Now : India, Switzerland
  Also: Australia, Canada, Germany, Indonesia, Japan, Singapore, UK, US
```

> **샌드박스(Hyperforce):** Full Sandbox Quick Create·Quick Clone(전체 타입)이 Hyperforce에서 2~3배 빨라진다(프로덕션 포인트-인-타임 스냅샷 기반). 단 이는 Environments 섹션 항목으로 이 추출 페이지 범위 밖이라 허브 인라인 기준으로만 표기한다(PDF 미확인).

### CDN / 인증서 / IPv6

- **Lightning CDN Uses CloudFront and Is Activated for All Orgs** — Lightning CDN이 기존 org에 자동 활성화되고 CloudFront를 사용(Spring '25 마이그레이션 시작, 현재 완료). Setup → Session Settings에서 "Enable CDN for Lightning Component framework" 해제로 끌 수 있으나 비권장. **방화벽 allowlist에 `static.lightning.force.com`이 있으면 `a.static.lightning.force.com`·`b.static.lightning.force.com` 추가 필요.** 전 에디션. (p.174–175)
- **Prepare for Shorter Certificate Lifespans** — CA/Browser Forum이 TLS 인증서 최대 수명 단축 발표: **398일 → 200일(2026-03-15) → 100일(2027-03-15) → 47일(2029-03-15).** Salesforce는 1P 프로덕션 org 인증서 변경 공지를 중단 예정(최소 90일 전 공지). 인증서 핀닝 중단 권장, Certificate Metadata API 타입 사용 권장. 전 에디션. (p.173–174)
- **Get Ready for IPv6** — IPv4 주소 부족 완화를 위해 IPv6 지원 준비. IP allowlist 사용 시 IPv6 주소 추가 권장. 현재는 Experience Cloud CDN만 IPv6 지원. **Government Cloud 우선 롤아웃 — 2025-12-31까지 GovCloud org에 IPv6 제공 예정.** IPv4 allowlist는 유지되나 org가 IPv6 지원 시 사용자는 프로필이 허용한 IPv6로만 로그인 가능. 전 에디션. (p.172)

### Edge Network (네트워크)

- **Route Traffic Through Salesforce Edge Network Locations in Japan Only** — 일본 instance org의 트래픽을 일본 내 로케이션으로만 라우팅(데이터 거주·규정 준수). 일본 Hyperforce instance만, 기본값은 글로벌 라우팅. My Domain → Routing and Policies → `Regional`. (p.1164–1165)
- **A Warning Was Added for Potential Custom Domain Disruption** — custom domain이 서드파티 CDN으로 호스팅되는 경우 Edge Network 이전 시 My Domain Setup 페이지에 경고. Enterprise·Performance·Unlimited. (p.1165)

### License / Wallet / 접근성

- **View License Utilization Information in the Digital Wallet App (Generally Available)** — Digital Wallet에서 좌석 기반 제품·라이선스의 통합·실시간 데이터(총 프로비저닝/할당/잔여). 2025-12-17 staggered 롤아웃. Enterprise·Unlimited. (p.172)
- **Streamline Access to Resources in the Help Menu** — Help Menu를 최대 4개 링크로 단순화(View Keyboard Shortcuts, Go to Trailhead, Go to Salesforce Help, View Release Notes[어드민만]). "More Resources" → "Resources" 개명, Get Support → Go to Salesforce Help(`https://help.salesforce.com/`). Group·Professional·Enterprise·Performance·Unlimited·Developer. (p.175–176)
- **Enable Accessibility Enhancements for Page Headers and Modal Windows When Zoom Is Greater Than 200% (Release Update)** — WCAG 2.2 Resize/Reflow 대응. Summer '25 최초 제공, **Spring '26 예정에서 Summer '26로 연기.** 전 에디션. → [[Winter '26/Release Updates]]. (p.176–177)
- **Enable Accessibility Enhancements for Date Pickers, Popovers, Bottom Utility Bars, Record Headers (Release Update)** — WCAG 2.2 Resize/Reflow 대응. Page Headers/Modal Windows 릴리즈 업데이트에 의존(먼저 활성화). **Summer '26 적용.** 전 에디션. → [[Winter '26/Release Updates]]. (p.176–177)

---

## 관련 노트

- [[Winter '26]] — 상위 릴리즈 허브 (전체 요약·주요 신기능)
- [[Winter '26/Development]] — 개발자 spoke (Apex·LWC·CLI·MCP·SDK·패키징 코드성 항목; Test Discovery/Runner API·On-Demand Flow REST·InvocableActionExtension 코드 상세)
- [[Winter '26/Release Updates]] — 강제 적용(Release Update) 시점 단일 출처 (Secure Roles·Restrict Run Flows·Legacy Host Names·SAML·접근성)
- [[Winter '26/Agentforce]] — AI/에이전트 빌더·모델·Agent Script (Agentforce 일반 변경)
- [[Winter '26/Clouds]] — 클라우드 제품 spoke (Sales·Service·Commerce·Data 360·Industries — Data 360 리브랜드·Commerce Payments 등 제품 맥락)
- [[Release MOC]] — 릴리즈 노트 전체 목차
- [[External Services]] — External Services 개념·OpenAPI 등록 (한도 증가·Binary File 지원 연계)
- [[Platform Encryption]] — Shield Platform Encryption·Database Encryption 개념 (Database Encryption GA 연계)
- [[SLDS LWC 디자인 시스템]] — SLDS 디자인 시스템 (새 Setup Home의 SLDS 1 테마 제한 맥락)
