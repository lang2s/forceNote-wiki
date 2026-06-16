---
tags: [release, spring_25, platform, admin, security, flow, automation, mobile, devops, mulesoft, orchestration]
api_version: v63.0
release_date: 2025-02
created: 2026-06-16
source: salesforce_spring25_release_notes.pdf (Salesforce Spring '25 Release Notes, Tier 2)
aliases: [Spring '25 Platform, 스프링25 플랫폼, Einstein for Flow GA, Flow Approval Process, Flow Orchestration Fault Path, MuleSoft for Flow GA, Transform Element Join, Screen Flow 개선, Automation Lightning App Monitor]
---

# Spring '25 — Platform (Admin · Security · Automation/Flow · Orchestration · Approval · MuleSoft · Mobile · DevOps · Architecture)

> Spring '25(API v63.0, 2025년 2월)의 플랫폼·설정 기능을 한곳에 모은 spoke. List View LWC 전환·권한 요약 편집·ICU 로케일 강제·Legacy Host Names 리디렉션 종료, Einstein for Flow GA, Flow Approval Process(신규)·Orchestration Fault Path, MuleSoft for Flow: Integration GA, Mobile·Hyperforce 확장 등을 다룬다. 코드성 변경(Apex 클래스·API)은 개발자 spoke로, 강제 적용(Release Update) 시점은 Release Updates spoke로 분리한다.

---

## 개요

이 노트는 **정책·설정(Admin/Setup, Security 정책, Automation/Flow, Orchestration, Approval, MuleSoft, Mobile, DevOps, Architecture)** 관점의 Spring '25 변경을 다룬다.

- **상위 허브:** [[Spring '25]] — 전체 릴리즈 요약·주요 신기능
- **개발자(코드·클래스·API) 변경:** [[Spring '25/Development]] — Apex 네임스페이스·LWC·ConnectApi·거버너 한도
- **강제 적용(Release Update) 시점:** [[Spring '25/Release Updates]] — 강제 시점 단일 출처. 본 노트에서 강제성 항목은 한 줄 요약 후 그쪽으로 위임
- **AI/Agentforce 상세:** [[Spring '25/Agentforce]] — Einstein 생성형 AI·에이전트 액션 코드/구성 상세

> **분류 원칙:** 정책·설정 = Platform / 코드·클래스 = Development / 강제 적용 시점 = Release Updates. 따라서 Lightning Web Security distortion, Auth Apex 핸들러 인터페이스, Einstein for Flow의 AI 내부 같은 코드/AI 상세는 본 노트에서 "정책 맥락"만 한 줄 언급하고 상세는 각 spoke에 둔다.

---

## Admin / Setup

Customization 영역 하위: List Views · Permissions · Fields · Globalization · Salesforce Connect · Sharing · External Services · Einstein Builders · DX Inspector · General Setup.

### List Views

- **Get Improved Performance with the Enhanced Role List View** — 사용자 역할(role)을 리스트 형식으로 보기·정렬·필터하고 인라인 편집. (LEX + Salesforce Classic, 일부 조직 제외; Professional/Enterprise/Performance/Unlimited/Developer. Setup → Users → User Management Settings → Enable Enhanced Role List View → Roles Setup 페이지)
- **Manage Permissions Sets with the Enhanced List View** — 권한 집합 리스트 뷰의 탐색·필터·검색·레이아웃 개선, 고급 필터링, 핵심 액션 빠른 접근. (LEX + Classic, 일부 제외; Professional/Enterprise/Performance/Unlimited/Developer. User Management Settings → Enable Enhanced Permission Set List View)
- **View and Filter on More Fields in the Enhanced User List View** — 사용자 리스트 뷰에 추가 가능한 신규 필드: **Delegated Approver, End of Day, Is Partner, Start of Day, User Verified Email, User Verified Mobile Number, Password Expiration Date**. (LEX + Classic, 일부 제외; Enterprise/Performance/Unlimited/Developer. Select Fields to Display로 컬럼 변경·재정렬)
- **Get Better Performance for List Views** — 커스텀·표준 객체의 리스트 뷰가 **Aura 대신 Lightning Web Components(LWC)로 렌더링**. 이전에는 LWC 리스트 뷰가 샌드박스에만 있었음. Starter·Pro Suite를 제외한 전 에디션(LEX). **"This update is available on a rolling basis starting in Spring ’25."**
- **Organize Your Data with Multi-Column Sorting for Related Lists** (Delivered Idea) — 관련 리스트를 **최대 5개 컬럼(up to five columns)** 까지 정렬(이전 단일 컬럼). Starter·Pro Suite 제외 전 에디션(LEX). 관련 리스트 → View All → 컬럼 선택 → Apply(예: Account의 Opportunities를 Stage 다음 Amount로 정렬). Reset Column Sorting으로 기본 복원. 사용자 환경설정에만 영향, 기본값 저장 불가
- **Enforce View Roles and Role Hierarchy Permission When Editing Public List View Visibility (Release Update)** — 공개 리스트 뷰 가시성 편집 시 **View Roles and Role Hierarchy** 권한 보유자만 역할을 보고 선택. Spring '24 최초 제공. Spring '25 강제 → [[Spring '25/Release Updates]]
- **Simplify Related List Component Configuration** — Dynamic Related List–Single / Related List–Single 컴포넌트 구성에서 사용 가능한 관련 리스트의 API 이름을 표시. (LEX 전 에디션)
- **Edit List Filters Option Is No Longer Available** — List Views Control의 **Edit List Filters** 옵션이 모든 리스트 뷰에서 제거됨. 대신 Filters 아이콘 사용. (LEX 전 에디션)

### Permissions

- **Manage Included Permission Sets in Permission Set Groups via Summaries** (Delivered Idea) — 권한 집합 요약에서 해당 권한 집합을 포함하는 권한 집합 그룹을 직접 지정. (LEX + Classic, 일부 제외; Contact Manager/Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer/Database.com. 권한 집합 → View Summary → Related Permission Set Groups 탭 → Add/Remove)
- **Allow Users to View All Fields for a Specified Object** (Delivered Idea) — 객체 레벨 **View All Fields** 권한으로 특정 객체의 모든 필드·필드 데이터에 접근. 필드 권한을 지원하는 모든 표준/커스텀 객체 대상. 신규 필드 접근을 자동 부여. (LEX + Classic, 일부 제외; 전 에디션. 권한 집합 → Object Settings → enable View All Fields)
- **The View All and Modify All Object Permissions Have New Names** — 객체 권한 **View All → View All Records**, **Modify All → Modify All Records** 로 개명. 자동 적용, 조치 불필요. (LEX + Classic, 일부 제외; 전 에디션)
- **Remove User and Custom Permissions in Permission Set Summaries** — 권한 집합 요약 뷰에서 사용자·커스텀 권한을 제거 가능(편집성 도입). 객체/필드 권한은 여전히 Object Settings 페이지에서. (LEX + Classic, 일부 제외; Contact Manager/Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer/Database.com. View Summary → User Permissions / Custom Permissions 탭 → Remove)

### Fields

- **Use Keyboard Shortcuts to Select Calendar Dates in Salesforce Classic** — Salesforce Classic의 Date/DateTime 필드 datepicker가 키보드 단축키 지원(접근성). Classic 페이지 및 `<apex:inputField>`가 Date/DateTime 필드에 연결된 Visualforce 페이지에서 동작. (Salesforce Classic, 일부 조직 제외; 전 에디션)

  | Action | Keyboard Shortcut |
  |---|---|
  | Open the datepicker. | Tab to the date input field. Tab again to focus the datepicker. |
  | Cycle focus through the calendar, the Today button, the Previous Month button, the Month dropdown, the Next Month button, and the Year dropdown. | Tab |
  | Select a day. | Tab to the calendar. Then use the arrow keys to navigate between days. To select the day in focus, press Enter, and then close the datepicker. |
  | Select a month. | Tab to the Month dropdown. To navigate between months, use the Up and Down arrow keys. To select the month, press Enter. Alternatively, tab to the Previous/Next Month button. |
  | Select a year. | Tab to the Year dropdown. To navigate between years, use the Up and Down arrow keys. To select a year, press Enter. |
  | Select today's date. | Tab to the Today button, and then press Enter. |
  | Close the datepicker without selecting a date. | Esc |
  | Close the datepicker after selecting a date. | Enter |

  > **참고(Pattern C):** PDF의 Previous/Next Month 버튼은 이미지 글리프(아이콘)로 표시되며 pdftotext에 잡히지 않았다. 위 표에서는 아이콘 이름을 추측하지 않고 "Previous/Next Month button"으로만 표기한다.

- **Capture More Data with the Increased Limit of Custom Fields for Activities** — **활동(activity) 4억 건 미만(fewer than 400 million activities)** 조직은 활동에 **커스텀 필드 300개**(이전 한도 **100개**) 사용 가능. (LEX; Enterprise/Performance/Unlimited)

### Globalization

- **Enable ICU Locale Formats (Release Update)** — ICU(International Components for Unicode) 로케일 형식이 Oracle JDK 로케일 형식을 대체(날짜·시간·통화·주소·이름·숫자값 제어). **Winter '20 최초 제공, Spring '25 강제.** Winter '20 이후 생성 조직은 기본 ICU. **English (Canada)(en_CA)는 별도 활성화 필요**(User Interface → Enable ICU formats for en_CA). **UI에서 Summer '25까지 강제 연기 가능**(User Interface → "Enable ICU locale formats as part of the scheduled rollout" 해제). Salesforce는 ICU 활성화 30~60일 전 관리자에게 이메일. 강제 시점 → [[Spring '25/Release Updates]]
- **Present Your Custom Functionality in New English Language Variations** — 신규 플랫폼 전용 언어 **German (Liechtenstein), Spanish (Andorra), Svenska (Finland)** 와 **30개 신규 영어 변형(language variations)**. 모든 표준 라벨은 영어가 기본이며 Translation Workbench로 커스터마이즈. (LEX/Classic/전 모바일 버전; Database.com 제외 전 에디션)
- **Review Updated Label Translations** — 표준 객체·탭·필드 명칭 번역 갱신: Chinese (Simplified/Traditional), Czech, Danish, Finnish, French, German, Greek, Hungarian, Indonesian, Japanese, Korean, Polish, Portuguese (Brazil), Russian, Slovenian, Spanish, Spanish (Mexico), Swedish, Thai, Ukrainian. (LEX/Classic/전 모바일 버전, 전 에디션)

### Salesforce Connect

- **Access Data Without Limits with Salesforce Connect** — **OData 4.01 어댑터, GraphQL 어댑터, Amazon Athena·Snowflake용 SQL 어댑터**의 신규 행(new rows) 한도 제거(이전 시간당 최대 100,000행). 콜아웃 한도에는 영향 없음. **Hyperforce에 호스팅된** Enterprise/Performance/Unlimited/Developer 조직만 해당. **"available to orgs hosted on Hyperforce on a rolling basis starting in Spring ’25."** (인프라 측면 → [Architecture](#architecture--infrastructure))
- **See Snowflake Views with the Salesforce Connect SQL Adapter** — Salesforce Connect SQL 어댑터로 Snowflake 쿼리 결과를 뷰(view)로 직접 접근(이전에는 뷰에서 동적 테이블 필요). (LEX + Classic, 일부 제외; Enterprise/Performance/Unlimited/Developer)

### Sharing

- **Manage Public Groups More Easily with Improvements to the Access Summary** — 공개 그룹에 대해 모든 객체의 공유 규칙·리스트 뷰를 보고, 그룹에 속한 모든 큐를 확인. (LEX + Classic, 일부 제외; Enterprise/Performance/Unlimited/Developer. Public Groups → View Summary → Object Name 드롭다운 → All Objects)
- **Get Notified When Your Sharing Rule Targets External Users** — 다음 카테고리(**Portal Roles, Portal Roles and Subordinates, Roles, Internal and Portal Subordinates**)로 공유 규칙 저장 시 경고 팝업. (LEX + Classic, 일부 제외; Enterprise/Performance/Unlimited/Developer)
- **Enable Secure Roles Behavior and Update Sharing Group References in Sandboxes (Release Update)** — 역할/하위(디지털 경험 활성화 전)의 기본 공유 그룹이 **"Roles and Subordinates" 대신 "Roles and Internal Subordinates"** 로 표시. 이전 그룹명을 참조하는 코드/커스터마이징을 갱신해야 함(Salesforce가 전환 기간 중 동적으로 변환하나 모두 갱신 필요). **이 release update는 샌드박스 대상**이며, 프로덕션은 별도 release update를 Summer '25에 제공하고 Winter '26에 강제. 샌드박스 강제는 Summer '25. → [[Spring '25/Release Updates]]

### External Services

- **Expose External Services as Custom Agent Actions** — OpenAPI 스키마를 등록하면 그 작업이 Agentforce의 invocable action / 커스텀 에이전트 액션이 됨. (LEX; Enterprise/Performance/Unlimited/Developer. AI 상세 → [[Spring '25/Agentforce]])
- **Handle Errors with Changes to External Services Responses** — **Spring '25부터** 외부 서비스 등록 후 콜아웃 시 **응답 상태 코드 300 이상은 오류(error)로 반환**(이전에는 모든 응답이 성공으로 반환). 외부 서비스 액션 콜아웃을 가진 모든 flow에 적용되며 Agentforce·Einstein Bots·Omnistudio·프로그래밍 호출에도 영향 가능. fault path로 오류 처리. (LEX; Enterprise/Performance/Unlimited/Developer)

### Einstein Builders

- **Try Einstein Prediction Builder Is Being Deprecated** — Try Einstein 버전의 Prediction Builder를 **Summer '25에 폐기**. 신규 사용자에게 더 이상 활성화 불가, 기존 활성 조직은 중단 시까지 계속 사용 가능. Data Cloud의 Einstein Studio Model Builder로 업그레이드 권장. **"notifying users starting in April 2025 and shutting off the feature in Summer ’25."** CRM Analytics Plus·Einstein Predictions·Platform Plus 라이선스 관리자는 풀버전 계속 사용. (LEX; Enterprise/Performance/Unlimited)

### DX Inspector

- **Access Sandbox Metadata Quickly** — DX Inspector가 샌드박스의 상단 바를 대체해 현재 샌드박스 이름을 표시하고 DX Inspector Panel(Changes 탭 포함)을 엶. (LEX로 접근하는 모든 샌드박스, Developer 에디션 제외; **Customize Application** 권한)
- **Track Sandbox Metadata Changes Easily** — DX Inspector의 **Changes 탭**에서 메타데이터 변경을 보고·관리(단일 통합 요약, 변경자·시점 표시). (LEX 샌드박스, Developer 제외; Customize Application 권한)

### General Setup

- **Add AI-Powered Quick Actions to Record Pages** — Setup에서 에이전트 quick action을 만들어 레코드 페이지에 추가. (LEX + iOS/Android 모바일 앱; Enterprise/Performance/Unlimited. AI 상세 → [[Spring '25/Agentforce]])
- **Better Understand Your Custom Metadata Type Usage** — System Overview 페이지가 커스텀 메타데이터 타입 사용량을 **두 범주**로 표시: **Your Custom Metadata Types**(인증된 관리형 패키지 외 출처) / **Total Custom Metadata Types**(설치된 관리형 패키지 포함 총계). (LEX/Classic/전 모바일 버전; Personal Edition 제외)
- **The Default User Profile Photo Has Been Changed** — 기본 사용자 프로필 사진이 **Astro 아바타에서 Codey 아바타로** 변경(글로벌 헤더의 신규 Agentforce 아이콘과 혼동 방지). (LEX/Classic/전 모바일 버전, 전 에디션. 신규 기본 사진 이미지는 PDF에만 존재 — Pattern C)

> **Salesforce Overall 참고:** 위 Customization 영역 외에도 Spring '25 Salesforce Overall에는 SLDS 2 테마(Beta), Digital Wallet 소비 모니터링, Salesforce Archive GA, Einstein Search/Search Analytics 등 일반 설정 변경이 다수 있다. 강제성(LWC Stacked Modals, Verify Return Email)·도메인/CDN성 항목은 각각 [[Spring '25/Release Updates]]·[Architecture](#architecture--infrastructure)로 분류한다.

---

## Security / 정책

> Security 섹션에는 명시적 "(Generally Available)" 라벨이 거의 없다(Event Log Objects GA 제외). 전부 일반 GA 변경 또는 Release Update 또는 정책 강화다.

### Lightning Web Security distortion

- **Lightning Web Security — API Distortion 추가** — LWS에 신규 보안 distortion 추가(ESLint 규칙 동반). 신규 대상: `Document.prototype.requestStorageAccess`, `Element.prototype.setHTMLUnsafe`, `HTMLIFrameElement.prototype.sandbox`. 변경 대상: `HTMLIFrameElement.prototype.src`(setter), `Window.open`, `Window: securitypolicyviolation` 이벤트. (정책 1줄만 — distortion 코드/대상 목록 상세는 → [[Spring '25/Development]])

### My Domain / Instance URL → My Domain

#### Update References to Legacy Host Names (Release Update)

레거시 호스트 이름 리디렉션이 프로덕션·데모 조직에서 종료된다. 날짜는 PDF 원문 그대로 인용한다.

> PDF 원문: "legacy host name redirections end in production and demo orgs. Those redirections already ended in all other orgs in **Winter ’25**. This update is available starting in **Spring ’25**."

- **영향 조직:** "affects production and demo orgs created in **June 2022 or earlier**" (2022년 6월 또는 그 이전 생성된 프로덕션·데모 조직). (LEX + Classic, 일부 제외; Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer)

> PDF 원문(자동 비활성화·강제): "In **Summer ’25** and in **Winter ’26**, Salesforce automatically disables legacy host name redirections unless you opt out of that change before your org gets each release. In those releases, you can enable and disable legacy host name redirections. **Salesforce enforces this update in Spring ’26. With that enforcement, you can’t reenable legacy host name redirections.** To get the major-release upgrade date for your instance, go to Trust Status, search for your My Domain name or instance, and then click the maintenance tab."

> PDF 원문(opt-out): "You can opt out of the automatic enablement of this change in **Summer ’25**. From the My Domain page in Setup, in the Redirections section, click Edit. Turn on **Maintain legacy redirections during the Summer ’25 upgrade**, and then save your changes. Repeat that step in each production or demo org where you want to opt out of that behavior. **That setting has no impact on the final enforcement of this update.**"

**날짜 요약(전부 word-form):** 비프로덕션·비데모 조직은 이미 **Winter '25**에 리디렉션 종료 / update 제공 = **Spring '25** / 자동 비활성화(opt-out 가능) = **Summer '25 및 Winter '26** / 최종 강제(재활성화 불가) = **Spring '26** / 영향 = **2022년 6월 또는 그 이전** 생성 조직. 강제 시점 단일 출처 → [[Spring '25/Release Updates]]

#### Disable Redirections for Legacy Host Names

- 신규 My Domain 설정 **Redirect legacy (non-enhanced) My Domain hostnames**(기본 활성화). 데모 조직을 제외한 비프로덕션 조직에는 미제공. 이전에는 레거시 호스트 이름 리디렉션을 끄려면 모든 이전 My Domain 호스트 이름 리디렉션을 꺼야 했음. (LEX + Classic, 일부 제외; Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer. Setup → My Domain → Redirections → Edit → 해당 설정 해제. 해제 시 force.com 사이트 URL 리디렉션 불가, Instanced URL 리디렉션 옵션은 Don't redirect로 고정)

#### Trailhead Playgrounds Use Salesforce Edge Network

- 신규 생성된 Trailhead Playground는 Salesforce Edge Network를 사용. 기존 Playground는 My Domain Setup 페이지에서 활성화. (파티션 도메인을 쓰는 Trailhead Playground; LEX + Classic, 일부 제외; Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer)

### Identity and Access Management (IAM)

- **Log In with Your Email Address** — login.salesforce.com에 **Log in with Email** 버튼(이전에는 Salesforce Starter·Base Suite Pro 한정). 여러 조직용 Environment Switcher 대시보드. **"not part of the initial Spring '25 release and may be included at a later date"** — Spring '25 출시 이후 롤아웃(버튼이 보일 때까지 이메일 로그인 시도 금지). 샌드박스·공유 이메일·이메일 미접근·My Domain 강제 사용자는 미지원
- **Brand the Welcome Email for Internal Users** (Delivered Idea) — 내부 사용자 환영 이메일 커스터마이즈, 신규 병합 필드 **`{!NewUserWelcomeEmailLink}`**. (LEX + Classic, 일부 제외; 전 에디션. 커스텀 Classic 이메일 템플릿 작성 → Session Settings → Welcome Email Template)
- **Use Multi-Factor Authentication for Password Reset** — 비밀번호 재설정 중 등록된 MFA 방법으로 신원 확인. 내부 사용자만(외부/Experience Cloud 제외). (LEX + Classic, 일부 제외; 전 에디션)
  > PDF 원문(롤아웃): "This change is available on a rolling basis starting on **February 17, 2025**. The rollout concludes on **April 15, 2025**. It was originally scheduled to conclude on **March 31, 2025**, but we postponed it."
- **Password Reset Link Stays Valid After Multiple Clicks** — 비밀번호 재설정 링크가 클릭·스캔되어도 **24시간(24 hours)** 유효. Identity Verification 페이지 신규 설정(기본 활성화). (LEX + Classic, 일부 제외; 전 에디션)
- **Control Access to the setPassword() API More Easily** — Password Policies의 **Allow use of setPassword() API for self-resets** 설정을 다시 활성화 가능. (LEX + Classic, 일부 제외; 전 에디션)
- **Give Headless App Users More Ways to Log In** — Headless user discovery로 임의 식별자(이메일·전화·주문번호·케이스번호)+비밀번호로 로그인. Apex 클래스가 **`Auth.HeadlessUserDiscoveryHandler`** 인터페이스 구현. (Apex 코드 상세 → [[Spring '25/Development]]. LEX + Classic, 일부 제외; Enterprise/Unlimited/Developer)
- **Troubleshoot Errors with the Headless Registration Apex Handler** — `/services/oauth2/authorize` 엔드포인트가 headless 등록 핸들러(**`Auth.HeadlessSelfRegistrationHandler`** 인터페이스)의 Apex 오류 정보를 `apex_error` 필드로 반환. (LEX + Classic, 일부 제외; Enterprise/Unlimited/Developer)

```json
// 출처: salesforce_spring25_release_notes.pdf (lines 44200–44204, 1:1 인용 — JSON 오류 응답)
{
"error": "registration_error",
"error_description": "user was unable to be created in apex",
"apex_error": "MyException: exception message"
}
```

```apex
// 출처: salesforce_spring25_release_notes.pdf (line 44207, 1:1 인용 — Apex 커스텀 메시지)
throw new MyException('exception message');
```

- **Issue JSON Web Token (JWT)-Based Access Tokens in Hybrid OAuth Flows** — 하이브리드 OAuth 2.0 플로우에서 opaque 토큰 대신 JWT 기반 액세스 토큰 발급. **hybrid web server flow**·**hybrid refresh token flow**에 적용(hybrid user-agent flow는 미지원). refresh token rotation 활성 시 하이브리드 플로우용 JWT 토큰 발급 불가. (LEX + Classic, 일부 제외; 전 에디션)
- **Manage Sessions Associated with JSON Web Token (JWT)-Based Access Tokens** — JWT 기반 액세스 토큰이 세션으로 뒷받침됨. Session Settings 페이지에서 JWT 토큰의 timeout 제어 불가(external client app/connected app 정책에서 구성). 세션 종료 시 일부 서비스는 폐기까지 최대 30분. (LEX + Classic, 일부 제외; 전 에디션)
- **Additional Session Is Established When a User Logs In to the UI** — UI 로그인 시 추가 세션(타입 **API**, login type **Unknown**) 생성. 이전: Aura/Content/TempAuraExchange/TempContentExchange/TempUiFrontdoor/UI(모두 Application login type). Session Management 페이지 또는 **AuthSession** 객체로 확인. (LEX 전 에디션)
- **GET Requests with Access Tokens in the URL Query String Are Blocked for the Single Access Endpoint** — `services/oauth2/singleaccess` 엔드포인트에 액세스 토큰을 URL 쿼리 문자열로 포함한 GET 요청을 차단. (LEX + Classic, 일부 제외; 전 에디션)

```
# 출처: salesforce_spring25_release_notes.pdf (lines 44299–44301, 1:1 인용 — 차단되는 비보안 요청)
https://mydomainname.my.salesforce.com/services/oauth2/singleaccess?access_tok
en=<access token>
&redirect_uri=lightning/setup/ManageUsers/home
```

```
# 출처: salesforce_spring25_release_notes.pdf (lines 44304–44307, 1:1 인용 — 보안 GET)
GET /services/oauth2/singleaccess? HTTP 1.1
Host: mydomainname.my.salesforce.com
Authorization: Bearer <access token>
redirect_uri=lightning/setup/ManageUsers/home
```

```
# 출처: salesforce_spring25_release_notes.pdf (lines 44310–44313, 1:1 인용 — 보안 POST)
POST /services/oauth2/singleaccess? HTTP 1.1
Host: mydomainname.my.salesforce.com
access_token=<access token>&
redirect_uri=lightning/setup/ManageUsers/home
```

- **Enjoy Usability Improvements for Token Exchange Setup** — Token Exchange Handlers 페이지 텍스트 갱신. (LEX; Enterprise/Performance/Unlimited/Developer)
- **Integrate Single Sign-On Service Providers with the External Client Apps Framework** — 외부 클라이언트 앱 프레임워크로 Salesforce를 SAML SSO ID 공급자로 구성. SAML 지원 메타데이터 타입: **ExternalClientApplication, ExtlClntAppConfigurablePolicies, ExtlClntAppSamlConfigurablePolicies**(서브타입 **ExtlClntAppSamlConfigurablePoliciesAttribute** 포함 가능). Setup의 External Client App Manager에서 SAML 구성 불가, 패키징/배포 불가. (LEX + Classic, 일부 제외; Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer)
- **Triple DES Encryption Is No Longer Supported for SAML Single Sign-On** — SAML 응답에 **Triple DES** 암호화 알고리즘 미지원. **Spring '25부터 이 알고리즘으로 새 구성 생성 불가**(기존 pre-Spring '25 구성은 깨지지 않음). **AES 128 또는 AES 256** 사용. (LEX + Classic, 일부 제외; 전 에디션. connected app Web App Settings → Block Encryption Algorithm 확인)
- **Verify SAML Integrations (Release Update)** — SAML 프레임워크 업그레이드(유지보수). SSO·single logout에 영향. Winter '25 최초 발표 → Summer '25 강제(약 6주 윈도우). → [[Spring '25/Release Updates]]
- **Migrate to a Multiple-Configuration SAML Framework (Release Update)** — 단일 구성 SAML 프레임워크 지원 제거, 다중 구성만 지원. 프로덕션 Spring '26 강제, 샌드박스 Summer '24 강제(Spring '24 최초 제공). → [[Spring '25/Release Updates]]
- **Enable Embedded Login** — **Spring '25에 Embedded Login 설정이 기본 제거됨.** 활성화하려면 Support 문의. OAuth 2.0 Web Server Flow 또는 User-Agent Flow 권장. (Lightning communities via LEX + Classic, 일부 제외; Professional/Enterprise/Performance/Unlimited/Developer)
- **Asset Token Certificates Have Been Removed from the Public Keys Endpoint** — OAuth 2.0 asset token flow 서명 인증서의 공개 키가 `/id/keys`에서 제거. **`Auth.JWTUtil`** Apex 메서드 **`validateJWTWithCert(incomingJWT, certDeveloperName)`** / **`validateJWTWithKey(incomingJWT, publicKey)`** 사용. (코드 상세 → [[Spring '25/Development]]. LEX + Classic 전 에디션)
- **Select an OAuth Scope for External Client Apps** — OAuth 사용 외부 클라이언트 앱은 이제 scope 필수(OAuth scope validation). scope 없이 저장 불가(Metadata API 또는 App Manager). **"OAuth scope validation is available later in Spring ’25."** (LEX + Classic, 일부 제외; Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer)

### Named Credentials

- **Simplify OAuth Configurations with External Auth Identity Providers** — 외부 auth ID 공급자를 만들어 external credential에 연결. PKCE 확장, 커스텀 요청 파라미터, 관리형 2GP·unlocked 패키지에 추가. 현재 OAuth 2.0 authorization code browser flow만 지원. (LEX + Classic 전 에디션. Named Credentials 페이지·Connect REST API·Apex로 생성)
- **Refresh Access Tokens for Named Credentials with More HTTP Status Codes** — 표준 401·기타 4xx 외에 외부 시스템이 **6xx HTTP 상태 코드 이상**을 반환할 때도 토큰 갱신. (LEX + Classic 전 에디션. external credential → **Additional Status Codes for Token Refresh** 필드에 601·701 등 입력)

### Privacy Center

- **Process the User Object with Privacy Policies** — Data Management 또는 Right to Be Forgotten(RTBF) 정책으로 비활성 사용자를 익명화/마스킹. Anonymize = 모든 표준 필드 난독화(username 변경 알림 없음), Mask = 필드 처리 지정. 활성 사용자 처리·사용자 레코드 삭제는 불가. (LEX; Enterprise/Performance/Unlimited/Developer)
- **Bypass Triggers and Validation Rules While Processing Records** — 트리거/유효성 규칙에 커스텀 권한을 추가해 우회, 세션 기반 권한 집합으로 할당. (LEX; Enterprise/Performance/Unlimited/Developer)

### Salesforce Shield — Event Monitoring

- **Query Low-Latency Event Data with Event Log Objects (Generally Available)** — 이벤트 데이터를 표준 객체에 **최근 30일(past 30 days) 저장**하고, 저장 데이터 내 **임의의 15일 윈도우(any 15-day window)** 를 API로 쿼리(Event Log Object 프레임워크 GA). (LEX + Classic, 일부 제외; Enterprise/Performance/Unlimited에서 Event Monitoring 활성. 권한: **View Event Log Object Data** 또는 **Event Monitoring User**)
  > PDF 원문(미지원 리전·Beta 라벨): "Translated user interface labels in localized versions of Event Log Objects are currently in Beta release status. Additionally, Event Log Objects is not yet available in these regions: Asia Pacific (Jakarta, Hyderabad, Mumbai, Osaka, Singapore, and Seoul), Canada (Central), South America (São Paulo), and Middle East (UAE and Israel)."
  > **대상:** Salesforce Shield 또는 Salesforce Event Monitoring add-on을 구매한 **Hyperforce 고객**. **Government Cloud 고객에는 미제공.**
- **Correlate Logs with a Custom Request Identifier** — 모든 Event Monitoring 로그에 커스터마이즈 가능한 **Request Identifier** 필드. API 호출 시 **X-SFDC-REQUEST-ID** 헤더에 32자 OTEL 호환 TraceID 또는 22자 영숫자 ID 설정. (LEX + Classic, 일부 제외; Enterprise/Performance/Unlimited에서 Event Monitoring 활성; Shield/Event Monitoring add-on)
- **Access All Event Monitoring Data with One Permission Set** — 신규 **Event Monitoring User** 권한(Event Log Files·Objects·Real-Time Events·Threat Detection). (LEX + Classic, 일부 제외; Enterprise/Performance/Unlimited에서 Event Monitoring 활성)
- **Monitor Content Security Policy (CSP) Violations** — Lightning 페이지의 **CSP Violation** 이벤트 타입. API에서만 제공(Event Monitoring Analytics 앱 미포함). 디렉티브: font-src·frame-src·img-src(Trusted URL 리스트), media-src·style-src. **모든 고객에게 무료, 24시간 데이터 보존.** (LEX + Classic, 일부 제외; Enterprise/Unlimited/Developer)
- **Dig into Details About Blocked Redirections** — **Blocked Redirect** 이벤트 타입(차단 발생 페이지·대상 URL 형식 오류 여부 캡처, Salesforce Classic 컴포넌트/페이지 포함). API에서만 제공. **모든 고객 무료, 24시간 보존.** (LEX + Classic, 일부 제외; Enterprise/Unlimited/Developer)

### Salesforce Shield — Platform Encryption

- **Bring Your Own Data Encryption Keys for Search Indexes** — 검색 인덱스용 데이터 암호화 키(DEK)에 BYOK. **DEK는 256-bit 크기.** (LEX + Classic, 일부 제외; Enterprise/Performance/Unlimited/Developer. Key Management → Search Index 탭 → Bring Your Own Key → 인증서 생성·다운로드 → 공개키로 DEK 래핑 → 업로드)
- **Encrypt Data Cloud Search Indexes** — Platform Encryption for Data Cloud가 Data Cloud의 검색 인덱스를 암호화. **"available starting in January 2025."** (LEX; Enterprise/Performance/Unlimited/Developer. Encryption Settings → Manage Data Cloud Keys)
- **Used Named Principal Authentication with Cache-Only Keys** [sic — PDF 헤딩] — Cache-Only Keys가 외부 키 서비스 인증에 named principal 지원(신규 named principal 기반 자격증명 및 레거시 모두). (LEX; Enterprise/Performance/Unlimited/Developer + Shield/Shield Platform Encryption + **Cache-Only Key Service add-on**. 6단계 구성 절차)

### Security Center

- **Monitor Certificates Across Your Salesforce Landscape** — **Certificates** 메트릭(만료일·인증서 타입·생성일·활성 상태). (LEX; Enterprise/Performance/Unlimited/Developer; Security Center add-on. 대시보드 → Configuration 범주)
- **Track your Transactional Database Encryption status with the Existing Encryption Policies metric** — **Encryption Policy** 메트릭으로 트랜잭션 데이터베이스 tenant secret 모니터링. (LEX; Enterprise/Performance/Unlimited/Developer; Security Center add-on. Database Encryption은 Shield/Shield Platform Encryption + Cache-Only Key add-on, select Hyperforce 환경, Transactional Database Encryption 활성 필요)
- **Discover More Ways to Optimize Security Center** — Security Landscape 페이지의 신규 프롬프트(Alerts 설정, 테넌트 연결). (LEX; Enterprise/Performance/Unlimited/Developer)
- **Streamline Navigation with New Icons** — 갱신된 아이콘의 신규 탐색 메뉴. (LEX; Enterprise/Performance/Unlimited/Developer)

### Policy Center

- **Manage Privacy and Security Policies in Policy Center** — Policy Center에서 정책(Data Mask·Privacy Center)을 한 곳에서 보기·편집·생성. (LEX; Enterprise/Performance/Unlimited/Developer; **Modify All Policy Center Policies**·**View All Policy Center Policies** 권한. App Launcher → Policy Center → 신규 Home 탭 또는 Policies 탭)

### Other Security Changes

- **Diagnose Failed Redirections Faster** — Trusted URL and Browser Policy Violation 리스트가 형식 오류(malformed) URL 리디렉션과 차단(blocked)을 구분. 신뢰되지 않은 URL로의 차단 리디렉션은 **Blocked Redirection** 으로 재명명(이전엔 둘 다 External Redirection). (LEX; Enterprise/Performance/Unlimited/Developer)
- **Locate the Source of Content Security Policy (CSP) Violations and Blocked Redirections** — Blocked Redirect·CSP Violation 이벤트 타입. (LEX + Classic, 일부 제외; Enterprise/Unlimited/Developer)
- **Test Automation That Generates Trusted URLs** — Trusted URLs·Trusted URLs for Redirects allowlist의 신규/갱신 항목 구문을 Salesforce가 검증. **CspTrustedSite**·**RedirectWhitelistUrl** 객체를 생성하는 자동화를 확인. (LEX + Classic, 일부 제외; Enterprise/Performance/Unlimited/Developer)
- **Secure Cross-Cloud Integrations Across Asia with Private Connect** — Private Connect가 아시아 신규 리전의 AWS 지원. 최신 직접 연결 AWS 리전: **ap-northeast-3**, **il-central-1**. (LEX; Enterprise/Unlimited/Developer/Performance. Setup → Private Connect → AWS Regions)
- **Update Your Trusted URLs for the Latest CSP Directives (Release Update)** — **이 update는 취소됨(canceled).** Trusted URL 리스트 작업 및 Session Settings의 **Adopt updated CSP directives**(신규 조직 기본 활성화) 권장. → [[Spring '25/Release Updates]]
- **Blocked Redirection Logging Is Throttled** — 볼륨이 많을 때 생성 이벤트를 throttle하여 일부 차단 리디렉션이 blocked redirect 이벤트를 생성하지 못할 수 있음.

### Metadata API 서비스 보호 강화

- **Service Protection for Metadata API Read and Retrieve Endpoints** — `readMetadata()`·`retrieve()` 요청이 **Winter '25 이후 생성된 신규 조직**에서 서버 과부하 시 오류를 반환할 수 있음. (LEX + Classic; Enterprise/Performance/Unlimited/Developer. 본 항목은 PDF의 Development 섹션에 상세가 있어 코드/동작 상세는 → [[Spring '25/Development]])

---

## Automation (Flow)

### Einstein for Flow GA

- **Get Help Building Flows Faster and More Accurately with Einstein (Generally Available)** — Einstein 생성형 AI가 지시문으로 flow를 생성(GA, 베타 이후 변경 포함). flow 생성은 **Einstein Requests** 크레딧을 소비(프로덕션·샌드박스). (LEX; Enterprise/Performance/Unlimited + Einstein for Sales/Service/Platform add-on. AI 내부·크레딧 상세 → [[Spring '25/Agentforce]])
- **Get Help Creating Flow Formulas with Einstein (Generally Available)** — Einstein이 flow 수식을 생성(Flow Formula Builder 한정, GA). → [[Spring '25/Agentforce]]
- **Generate a Detailed Description of a Flow with Einstein** — Einstein이 flow를 요약(스텝·입출력 변수·변경 객체·subflow)하여 설명에 추가. → [[Spring '25/Agentforce]]

### Transform Element — 컬렉션 Join

- **Join Collections with the Transform Element** — 관련 flow 리소스의 소스 컬렉션들을 하나의 타깃 컬렉션으로 결합. (LEX + Classic; Essentials/Professional/Enterprise/Unlimited/Performance/Developer)

### Send Email with Attachments (최대 35MB)

- **Send Emails with Attachments in Flow Builder** — **Send Email** 액션이 파일 ID로 첨부 파일을 첨부. **이메일 최대 크기(첨부 포함) 35 MB.** ID는 Document·Content Version·Attachment 항목 가능, 여러 개는 콤마 구분 리스트. 첨부 사용 시 호출 API가 바뀌어 일일 발송 한도가 **Daily Workflow Email Limit 대신 General Email Limit** 으로 변경됨. (LEX + Classic, 일부 제외; Essentials/Professional/Enterprise/Performance/Unlimited/Developer)

### Get Records 레코드 수 제한 옵션

- **Enhance Flow Performance by Controlling the Number of Records Retrieved with Get Records** — Get Records 요소에 **All records, up to a specified limit** 옵션. (LEX + Classic, 일부 제외; Essentials/Professional/Enterprise/Performance/Unlimited/Developer)

### Screen Flow 개선

- **Create Responsive Screens with Automatically Triggered Screen Actions (Beta)** — 화면 액션의 입력값이 바뀔 때 버튼 클릭 없이 autolaunched flow를 백그라운드 실행. **Lightning runtime 전용.** (LEX + Classic, 일부 제외; Essentials/Professional/Enterprise/Performance/Unlimited/Developer. Beta Services Terms 적용)
- **View Immediate Feedback from Screen Components with Invalid Values** — 사용자가 컴포넌트 밖으로 포커스를 옮길 때 컴포넌트 유효성 검사 결과를 즉시 표시. **API 버전 63.0 이상 flow만.** Classic runtime 미지원. 유효성 수식이 같은 화면 요소의 리소스를 참조하면 일부 함수(REGEX 등) 미지원. (Professional/Enterprise/Performance/Unlimited/Developer)
- **Guide Users Through Screen Flows with Built-In Visual Progress Indicators** — 내장 진행 표시기(simple 스타일 또는 path 스타일; path 스타일은 화면 상단만). `$Flow.CurrentStage`·`$Flow.ActiveStages` 사용. **Spring '25 이후 생성 flow는 기본 활성화, Winter '25 이전 생성 flow는 수동 활성화.** Lightning runtime 전용, Field Service Mobile·Salesforce Scheduler flow 미지원. (Professional/Enterprise/Performance/Unlimited/Developer)
- **Assign Stages to Screen Elements More Efficiently** — assignment 요소 대신 화면 속성 에디터에서 스테이지 할당. (Classic, 일부 제외 + LEX; Professional/Enterprise/Performance/Unlimited/Developer)

### Flow URL 파라미터 포커스

- **Create Flow Builder URLs that Focus on an Element** — URL 파라미터로 특정 요소에 포커스. auto-layout flow에만 적용, Start 요소 미지원. (LEX + Classic; Professional/Enterprise/Unlimited/Performance/Developer)

```
# 출처: salesforce_spring25_release_notes.pdf (lines 44661–44662, 1:1 인용 — 요소 포커스 URL 파라미터)
?flowId=myFlowId&urlAction=openelement&openElementApiName=myElementApiName
# myElementApiName을 요소 API 이름으로 치환
```

### Data Cloud 연동 확장 (데이터 타입)

- **Retrieve More Information from Data Cloud by Using Newly Supported Data Types** — Flow Builder의 신규 Data Cloud 데이터 타입: **Email, URL, Phone, Percent, Boolean, Currency**(DMO·CIO 필드). `$Record` 리소스에 나타남. (LEX + Classic, 일부 제외; Data Cloud 활성 전 에디션)

### Flow Builder UX 개선 (템플릿·수식 / Collection Filter / 단축키)

- **Create Flows with a New Streamlined Creation Experience** — flow 생성 창 재구성, **4개 주 범주**, 필터/검색. (LEX + Classic 전 에디션. Automation Lightning 앱의 New Flow)
- **Access Flow Versions in Flow Builder** — 버전 관리·상태 보기(탐색 헤더의 flow 이름 클릭). (LEX + Classic 전 에디션)
- **Troubleshoot Your Flow Configuration with Improvements to the Errors and Warnings Pane** — 오류/경고를 요소별로 그룹화, 캔버스 소스로 가는 링크 제공. (LEX + Classic, 일부 제외; Essentials/Professional/Enterprise/Unlimited/Developer)
- **Create New Text Template and Formula Flow Resources More Easily** — 리소스 선택 개선, 브레드크럼 경로, 직관적 아이콘. (LEX + Classic, 일부 제외; Essentials/Professional/Enterprise/Unlimited/Developer)
- **Navigate Collection Filter Flow Child Resources Efficiently** — Collection Filter 요소의 자식 리소스를 갱신된 리소스 메뉴에서 검색·선택. (LEX + Classic, 일부 제외; Essentials/Professional/Enterprise/Unlimited/Developer)
- **Undo, Redo, and Save As with Keyboard Shortcuts** — Flow Builder 캔버스·요소 구성 패널에서 단축키. 요소 창 팝업에서는 미적용. 단축키 보기는 **Ctrl+/ 또는 Cmd+/**. (LEX + Classic; Professional/Enterprise/Unlimited/Performance/Developer)

  | Command | Shortcut |
  |---|---|
  | Undo | Windows: Ctrl+Z / macOS: Cmd+Z |
  | Redo | Windows: Ctrl+Y / macOS: Cmd+Y |
  | Save As | Windows: Shift+Ctrl+S / macOS: Shift+Cmd+S |

### Prompt Flow 내 Autolaunched Subflow 참조

- **Launch an Active Autolaunched Flow as a Subflow Within a Prompt Flow** — prompt flow에 활성 autolaunched flow를 참조 flow로 포함. Wait 요소를 가진 참조 autolaunched flow는 미지원. (LEX; Enterprise/Performance/Unlimited)

### Flow Runtime 버전 변경 (Data Table 반응성 / 동명 변수 상속 금지)

- **Flow and Process Run-Time Changes** — **API 버전 63.0 이상으로 실행되는 flow만** 영향. (LEX/Classic/전 모바일 버전; Essentials/Professional/Enterprise/Performance/Unlimited/Developer)
  - **Clear a Reactive Data Table If the Source Collection Isn't Set** — Data Table 소스 컬렉션이 화면 액션의 출력이고 autolaunched flow가 출력 컬렉션을 설정하지 않으면 Data Table 내용이 초기화됨(이전엔 유지).
  - **See Feedback from Screen Components with Invalid Values** — 위 View Immediate Feedback 참조.
  - **Variables with Same Names in Parent and Referenced Flows Were Changed** — 참조 flow와 부모 flow에 동일 API명 변수가 있어도 참조 flow 변수가 부모 값을 더 이상 상속하지 않음.

### Flow Management (Data Cloud 트리거 배포 / Automation Lightning App Monitor 탭)

- **Copy Data Cloud-Triggered Flows from Sandbox to Production** — change set으로 Data Cloud-triggered flow 변경을 프로덕션에 통합. (LEX + Classic 전 에디션, Data Cloud 활성)
- **Monitor All Failed and Paused Flow Interviews from the Automation Lightning app** — Automation Lightning 앱의 신규 **Monitor 탭**에서 실패 flow 인터뷰 디버그, 일시정지 인터뷰 재개. (LEX; Essentials/Professional/Enterprise/Performance/Unlimited/Developer)

### Flow Extensions — 커스텀 컴포넌트 유효성 검사 API

- **Design Component Errors for a Better Experience** — flow 화면의 LWC가 오류 렌더링을 제어. `@api` 인터페이스로 기존 **`validate()`** 와 신규 **`setCustomValidity(externalErrorMessage: string)`**·**`reportValidity()`** 메서드 구현. flow는 next/finish 시 `validate()`를 호출하고, 입력 유효성 오류 시 `setCustomValidity(...)`로 메시지를 저장하며, 오류를 렌더링할 시점에 `reportValidity()`를 호출. Classic runtime 미지원. (LEX + Classic, 일부 제외; Professional/Enterprise/Performance/Unlimited/Developer)

```javascript
// 구조 예시 — 실제 동작 코드 아님 (PDF는 시그니처만 명시; 클래스 본문은 발명 구조)
// 출처: salesforce_spring25_release_notes.pdf — Flow Extensions 섹션 (시그니처만 PDF 일치)
// @api 인터페이스로 구현
// 1) validate() — 기존 동작 유지 (다음 화면 이동 전 호출)
// 2) setCustomValidity(externalErrorMessage: string) — Flow의 입력 유효성 에러 메시지를 컴포넌트가 저장
// 3) reportValidity() — 에러 렌더링 시점을 컴포넌트가 제어
import { LightningElement, api } from 'lwc';
export default class MyScreenComponent extends LightningElement {
    _externalError = '';

    @api validate() { /* 기존 유효성 로직 */ return { isValid: true }; }
    @api setCustomValidity(externalErrorMessage) {
        this._externalError = externalErrorMessage;
    }
    @api reportValidity() {
        // 에러 표시 로직
        this.template.querySelector('.error-msg').textContent = this._externalError;
    }
}
```

> **참고:** 위 클래스 본문(`_externalError`·`import`·`querySelector` 구현)은 PDF가 메서드 시그니처(`validate()`, `setCustomValidity(externalErrorMessage: string)`, `reportValidity()`)만 명시한 것을 flat hub에서 구조 예시로 채운 것이다. 시그니처 3개는 PDF 본문과 1:1 일치하며, 내부 구현 디테일은 동작 코드가 아니라 예시다.

### Flow Release Updates (강제 시점 위임)

아래는 강제 적용 성격이므로 시점을 [[Spring '25/Release Updates]]에 둔다.

- **Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs (Release Update)** — Apex 액션 입력으로 쓰이는 내장 Apex 클래스의 권한 요구 강제. Summer '24 최초 제공 → Summer '26 강제. → [[Spring '25/Release Updates]]
- **Enforce Rollbacks for Apex Action Exceptions in REST API (Release Update)** — REST API로 Apex 액션 실행 시 예외 종료 트랜잭션 롤백. Spring '23 최초 제공, **Spring '25부터 더 이상 강제하지 않음**(자발적 활성화 권고). → [[Spring '25/Release Updates]]
- **Enhance Flexibility and Reusability in Prompt Flows (Release Update)** — template-triggered prompt flow에서 flex prompt template 타입 지정 기능 제거, manual input으로 전환. Winter '25 제공 → Spring '25 강제. → [[Spring '25/Release Updates]]
- **Evaluate Criteria Based on Original Record Values in Process Builder (Release Update)** — 프로세스를 시작시킨 필드의 원래 값(null 포함)으로 평가. Summer '25 강제 예정이었으나 **Spring '25부터 더 이상 강제하지 않음**(Flow Builder 마이그레이션 권장, Summer '19 최초 제공). → [[Spring '25/Release Updates]]
- **Restrict User Access to Run Flows (Release Update)** — flow 실행에 올바른 프로필/권한 집합 필요. **FlowSites** org 권한 폐기. Winter '24 최초 제공 → Winter '26 강제. → [[Spring '25/Release Updates]]
- **Sort Apex Batch Action Results by Request Order (Release Update)** — 성능 우려로 **무기한 연기(postponed until further notice)**. 토글 활성화는 영향 없음. → [[Spring '25/Release Updates]]

---

## Flow Orchestration

### 인터랙티브 스텝 커스텀 이메일 알림

- **Customize Email Notifications for Interactive Steps** — 각 interactive step이 work item 생성 시 고유 커스텀 이메일 알림(제목+본문)을 보내도록 구성. 재배정된 work item은 여전히 기본 이메일을 받음. Process Automation Settings의 **Stop Sending Orchestration Work Item Email Notifications**를 선택하지 말 것. (LEX; Enterprise/Performance/Unlimited/Developer)

### Fault Path

- **Control Orchestration Error Handling by Using Fault Paths** — 스테이지별 fault path를 구성해 해당 스테이지(또는 그 안의 step)에 오류가 나면 실행될 요소를 정의. orchestration이 오류로 끝날 위험 감소. **"This change is available after March 17, 2025."** (LEX; Enterprise/Performance/Unlimited/Developer; **Modify Flow** 권한. 스테이지 선택 → Add Fault Path)

### 개선된 Orchestration Run Details

- **View Improved Orchestration Run Details** — 신규 레이아웃: Run Details 탭(스테이지/스텝·완료 시간·배정자), Work Items 탭, quick menu(취소·디버그·일시정지), 재개. (LEX; Enterprise/Performance/Unlimited/Developer)
- **Other Changes to Flow Orchestration** — Enhanced Sales To Do List(work item 링크 → 관련 레코드 페이지/Work Guide), Automatically Detect Background Step Processing("Contains external callouts or wait elements" 체크박스 제거), Updated Process Automation Setting(알림 설정명 변경), Improved Step Properties Panel, Improved Validation Messages. (LEX; Enterprise/Performance/Unlimited/Developer)

---

## Flow Approval Processes

Flow Orchestration 기반의 신규 승인 워크플로우. 클래식 Approval Processes보다 동적 라우팅·상세 로깅을 지원하고, Lightning App Builder의 레코드 트리거/커스텀 버튼을 사용. (LEX; Enterprise/Performance/Unlimited/Developer)

### 주요 기능 (그룹·Queue 배정 / 알림 이메일 / 이메일 회신 승인)

| 기능 | 내용 |
|---|---|
| Assign Approval Steps to Groups or Queues | 승인 스텝을 큐 또는 공개 그룹에 배정. 최초 승인/반려자가 스텝을 완료. 공개 그룹 = 타입 Regular, 큐 = 타입 Queue |
| Send Notifications to Approval Users | 각 승인 스텝이 레코드 상세를 담은 이메일 알림을 보내도록 구성. 이메일 끄기 가능 |
| Reply to Emails to Approve or Reject Approval Work Item | 승인자가 연결된 screen flow를 실행하거나 알림 이메일에 회신해 처리 |

> 모두 LEX; Enterprise/Performance/Unlimited/Developer.

---

## MuleSoft for Flow: Integration GA

- **Streamline External System Integration with MuleSoft for Flow: Integration (Generally Available)** — 서드파티 커넥터(트리거 또는 액션)를 통한 외부 시스템 노코드 연동, 인라인 필드 매핑, Automation Lightning 앱의 **Connections 탭**.

### 핵심 기능 (커넥터 / Connections 탭 / External System Triggered Flow / Field Mapping)

| 기능 | 내용 |
|---|---|
| Enhance Data Exchange with Third-Party Connectors | 서드파티 커넥터를 트리거 또는 액션으로 사용. 예: NetSuite의 새 Contact → Salesforce Lead 생성, Salesforce Order → NetSuite Sales Order 생성 |
| Manage External System Integrations in the Connections Tab | Automation Lightning 앱의 Connections 탭에서 통합 관리 (Process Automation Settings → Enable the Automation Lightning app → Connections 탭) |
| Trigger Flows from External Systems | **External System Change-Triggered flows** — 서드파티 시스템 폴링 결과 변경 감지 시 트리거 |
| Map Flow Fields to Fields in Third-Party Systems | 각 커넥터 액션에 임베드된 인라인 transform 기능 |

- **라이선스:** **MuleSoft for Flow: Integration add-on license** 필요. **권한:** **Manage Integration Connections**. 대상: Salesforce Classic + LEX; Professional(API access add-on)/Performance/Enterprise/Unlimited. Connections는 Automation Lightning 앱에서만 편집·삭제.
- **MuleSoft API Catalog for Salesforce** — MuleSoft API의 액션을 Salesforce에서 보기·활성화(자격증명·권한 집합 자동 생성). **"available starting in February 2025."** (LEX; Enterprise/Performance/Unlimited/Developer)
- **MuleSoft Composer for Salesforce** — 클릭으로 데이터 통합, 임의 flow에서 프로세스 호출. (Enterprise/Performance/Unlimited, LEX 활성, 추가 비용)

### GA 커넥터 목록 (39종)

> PDF 원문 헤딩: "The following connectors are generally available:" — 아래는 1:1 전수 인용(총 39개).

Abstract Company Enrichment · Abstract Email Validator · Abstract Phone Validator · Anthropic · Asana · Bloomfire · Calendly · Clockify · Courier · DHL Tracking · Discord · Eventbrite · Freshdesk · Google Gemini · Guru · HubSpot · Intercom · Jira · Maxio (Chargify) · Microsoft Entra ID · Microsoft Excel · Microsoft Outlook · Microsoft Power BI · Moosend · NetSuite · OpenAI · OpenWeatherMap · PagerDuty · PayPal · Qualtrics · QuickBooks Online · Salesforce · Salesforce Marketing Cloud · SignUpGenius · Square · SurveyMonkey · Twilio · WordPress · Zendesk · Zuora

> **참고:** flat hub는 "40여 개"로 요약했으나, PDF 본문 verbatim 리스트는 **정확히 39개**다. 위 전수 목록을 정본으로 한다.

---

## Mobile

### Salesforce Mobile App

- **Everything That's New in the Salesforce Mobile App** — 신규 모바일 앱은 Database.com을 제외한 전 에디션에서 추가 라이선스 없이 제공. **"Most features become available for the Salesforce mobile app the week of February 18, 2025."** 주요 변경: Files → **Send Attachments in Messaging on the Salesforce Mobile App**, Access and Security → **Malware Detection Security Policy for Android is Being Retired**.
  > **참고(Pattern B/C):** PDF의 "Salesforce App Enhancements and Changes" 표는 Android/iOS/Set Up in the Full Site 컬럼의 체크마크가 이미지 글리프로 pdftotext에 잡히지 않았다. 어느 플랫폼 컬럼이 체크되는지는 추측하지 않는다.
- **Malware Detection Security Policy for Android is Being Retired** — Android용 Malware Detection 보안 정책을 **2025년 1월 31일(January 31, 2025)에 폐기**. Android SafetyNet API에 의존(Google이 폐기, 2025년 1월 31일 이후 호출 실패). 대안: **Block Jailbroken Device**, **Minimum Security Patch Version**. 조치하지 않으면 Spring '25 릴리즈로 자동 비활성화(구성 불가). (Salesforce Mobile App Plus·Mobile Publisher for Android 전 에디션)
- **Send Attachments in Messaging on the Salesforce Mobile App** — 서비스 담당자가 메시징 중 첨부 파일 전송. (Enhanced messaging channels·Messaging for In-App and Web. 에이전트 콘솔 → agent actions launcher → 카메라 아이콘 → Upload Files)

### Mobile Publisher

- **Download Files Your Way in Mobile Publisher for Experience Cloud** — 추가 다운로드 방법: 서드파티 URL(Google·Box, 인증/게스트 사용자), Messaging for In-App and Web의 채팅 트랜스크립트를 **Binary Large Object(Blob)** 로 다운로드(인증된 iOS 사용자 한정). 이전엔 지정 SObject의 인증 다운로드만. (Mobile Publisher for Experience Cloud 앱 **버전 13.010 이상**; LEX Enterprise/Performance/Unlimited)
- **Remove Unwanted /s Elements in Older Experience Cloud LWR Site URLs** — Experience Cloud Administration 워크스페이스에서 사이트 URL의 후행 `/s` 제거. (LWR 사이트, LEX + Classic, 일부 제외; Enterprise/Performance/Unlimited/Developer)
- **Set Up Opt-In Biometric Login for Fast and Secure Experience Cloud App Logins (Generally Available)** — **User Opt-In Biometric Login** GA — Experience Cloud 앱에서 얼굴/지문 인식 로그인. (앱 **버전 14.000 이상**. Connected App → 커스텀 속성 추가)
  > **플래그:** 헤딩은 GA지만 See Also 링크 라벨은 여전히 "User Opt-In Biometric Login **(Beta)**"·"Enable User Opt-In Biometric Login **(Beta)**" — Help 문서 라벨이 GA 헤딩보다 늦게 갱신됨.
- **Customize Mobile Publisher Android App Permission Requests to Post Notifications** — Android 알림 게시 권한 요청 텍스트 커스터마이즈(Google Play prominent disclosure 충족). (Mobile Publisher for Experience Cloud Android 앱; LEX Enterprise/Performance/Unlimited. **Post Notifcation**[sic] 앱 권한 활성화 → 설명 편집)
- **Customize the Style of Your Experience Cloud App's Security Alerts** — Enhanced Mobile App Security와 함께 알림 스타일(버튼 색·텍스트 색·커스텀 폰트) 커스터마이즈. (앱 **버전 14.000 이상**; LEX Enterprise/Performance/Unlimited. Security Alert Settings)

### General Mobile Updates

- **Assign Briefcases to Users by Profile** — 프로파일별 briefcase 배정(이전엔 사용자/사용자 그룹만). (LEX 데스크탑, Field Service(SFS) 활성. Briefcase Builder는 SFS iOS/Android 앱·Salesforce Mobile App Plus 지원)
- **Do More with Seller-Focused Mobile Experience** — 미팅 준비, Mobile Builder for Seller-Focused Experience로 커스터마이즈. (Android/iOS 폰·태블릿; Database.com 제외 전 에디션)
- **Validate Mobile Lightning Web Components with ESLint Rules** — 모바일/오프라인 LWC용 신규 ESLint 규칙 플러그인. Apex 사용, Offline GraphQL 기능 제한·하드 한도 위반을 플래그. (Salesforce Mobile App Plus iOS/Android; Database.com 제외 전 에디션. ESLint 규칙 코드 상세 → [[Spring '25/Development]] 경계)
- **Reduce Mobile Performance Issues with the Salesforce Extensions Pack** — 최신 VS Code 확장의 진단 개선. 32KB 초과 다수 필드, 모바일 오프라인 미최적화 Base LWC, 오프라인 중 wire adapter **getRelatedListRecords**·**getRelatedListCount** 사용을 플래그. (Salesforce Mobile App Plus iOS/Android; Database.com 제외 전 에디션)
- **Accept On-Site Payments with Tap-to-Pay** — **PaymentsService API** → Payments 플러그인의 Tap-to-Pay 기능을 쓰는 LWC. Field Service 모바일 앱이 Pay Now와 통합. PaymentsService는 웹 브라우저(데스크탑/모바일)에서 동작 불가. (Field Service 모바일 앱 Android/iOS; **Salesforce Payments·Pay Now 라이선스**)
- **Disable Apple Intelligence Writing Tools in Salesforce Apps** — 조직 단위로 iOS 18.1 Apple Intelligence Writing Tools 비활성화(Salesforce 문의). (iOS 폰·태블릿 전 에디션. iPhone 15 Pro/15 Pro Max/16 시리즈, M1+ iPad/Mac, iOS 18.1+)
- **Find the Tab Bar on iPad Mobile Apps at the Top of the Screen** — iOS 18.1 이상에서 탭 바가 상단으로 이동(이전 하단). (iOS 태블릿 전 에디션. iOS 18.1 업그레이드 시 적용)
- **New Version of Test Harness Supports Switching Applications and Service Documents** — Salesforce Mobile App Plus ↔ Field Service App 전환, 샘플 페이지 참조(service document) 테스트. 앱 전환 시 앱 세션 종료. (Test Harness는 iOS 앱 파일·Android APK로 다운로드)

---

## DevOps / CLI / Packaging

> 정책성 항목만 다룬다. CLI 명령·플러그인 코드(`sf agent ...`, Salesforce CLI v2.53.6+ data/api 명령 등)와 OpenAPI/Database Access 디버그 카테고리 등 코드성 상세는 → [[Spring '25/Development]].

- **DevOps Testing (Generally Available)** — DevOps Center를 확장하는 AI 기반 테스트·QA. DevOps Testing Manager 또는 DevOps Testing User 권한 집합 + DevOps Center 접근. AppExchange의 관리형 패키지 설치. (PDF의 Development 섹션에 상세 — 설치/플러그인 절차는 → [[Spring '25/Development]])
- **Access Sandbox Metadata Quickly (DX Inspector)** — 샌드박스에서 DX Inspector가 상단 바를 대체, Changes 탭에서 메타데이터 변경 확인. (LEX 샌드박스; Customize Application 권한. 위 [Admin/DX Inspector](#admin--setup)에도 기재 — 동일 기능)
- **Data Mask 개선(정책 맥락)** — Einstein 커스텀 라이브러리 자동 생성, Run on Refresh(샌드박스 리프레시 시 마스킹 자동 실행, 다운타임 없음), FedRAMP High 인증(Government Cloud Plus). 구성 절차/플러그인 상세는 → [[Spring '25/Development]]

> **참고:** Agentforce DX(Beta), Salesforce CLI 세부 명령, OpenAPI Document for sObjects(Beta) 등은 코드성이므로 본 노트에서 중복하지 않고 [[Spring '25/Development]]에 둔다.

---

## Architecture / Infrastructure

### Hyperforce

- **Access Salesforce in More Regions with Hyperforce** — Hyperforce가 이제 **17개국**에서 제공. 신규 리전: **Israel(2024년 6월부터)**, **Osaka, Japan(2024년 10월부터)**.
  - **17개국(자동 제공):** Australia, Brazil, Canada, France, Germany, India, Indonesia, Israel, Italy, Japan, Singapore, South Korea, Sweden, Switzerland, the United States, the United Arab Emirates, the United Kingdom. (Salesforce Customer 360 제품군 — Sales Cloud·Service Cloud·B2B Commerce·Platform·Industries Cloud)
  - **Hyperforce에 최근 제공된 클라우드/제품:**

    | Cloud | Product or Feature | Available In |
    |---|---|---|
    | Commerce | B2C Commerce | United States |
    | Marketing | Marketing Cloud Engagement | Now available in Brazil, Canada, Japan, and the United Kingdom. Also available in Germany, India, and the United States |
    | MuleSoft | MuleSoft Anypoint Platform | Now available in Canada. Also available in Australia, India, and Japan |
    | Data Cloud | Salesforce Data Cloud | Canada and Japan |
    | Tableau | Tableau Cloud | Canada, Germany, United Kingdom, United States |

    > **참고(Pattern B):** 위 표는 PDF p.497–498에서 Description·Available In 컬럼이 페이지 경계를 넘어 섞여 출력되었다. Available In 매핑은 Product 순서에 맞춰 재정렬했으며(Data Cloud = "Canada and Japan", MuleSoft = Canada/Australia/India/Japan), 셀 단위로 재검증한 값이다.

- **Improved Instructions in Hyperforce Assistant** — Optimizer 하드코딩 참조·MyDomain·IP allowlisting 대안 지침을 명확화. (Hyperforce Assistant, LEX 전 에디션; **Customize Application·Manage Users·Modify All Data** 권한. Setup → Hyperforce Assistant)
- **Access Hyperforce Outbound IP Lists** — Hyperforce egress IP를 인증 없이 JSON으로 제공: **`https://ip-ranges.salesforce.com/ip-ranges.json`**. 신규 IP는 프로덕션 사용 30일 전 추가(2주마다 확인). Sales·Service·Industries·Tableau 클라우드 대상(Marketing Cloud·Commerce Cloud·Slack·MuleSoft 제외). Government Cloud Plus는 별도 문서.

```
# 출처: salesforce_spring25_release_notes.pdf (line 25180, 1:1 인용 — Hyperforce egress IP JSON 엔드포인트)
https://ip-ranges.salesforce.com/ip-ranges.json
```

- **Salesforce Out Of Region Disaster Recovery (OORDR)** — Hyperforce 프리미엄 제품, 지리적으로 먼 리전에 데이터 백업. Hyperforce 호스팅 조직만, account representative 문의. 대상: **United States·Japan**의 Hyperforce 상용 조직(GovCloud 미지원).
- **Scale Test** — 샌드박스 인스턴스 캘린더에 scale test day 예약, 프로덕션급 스케일로 고트래픽 시뮬레이션. **Singapore를 제외한 모든 Hyperforce 리전의 Full 샌드박스 고객.** (LEX 전 에디션. Setup → Scale → Scale Test)
- **Swiss Operating Zone** — 고객 데이터를 Switzerland에 유지, in-region EU 지원. **"Swiss OZ is available in the first half of 2025."** (account executive 문의)

### Domains / Cookie / CDN

- **Add the New Setup Domain (`*.salesforce-setup.com`)** — 서드파티 쿠키 차단 시 Setup 페이지가 정상 로드되도록 Setup 페이지를 `*.salesforce-setup.com`에 호스팅. 방화벽/allowlist를 쓰면 IT가 해당 도메인을 허용 추가. **"Rollout began in Spring ’24 and continues through Spring ’25. First enabled in sandboxes/nonproduction, then production."** (LEX 전 에디션)
- **Prepare for Upcoming Restrictions on Salesforce Cookie Use** — Salesforce 세션 쿠키를 쓰는 커스텀 기능/코드를 테스트. My Domain의 **"Require first-party use of Salesforce cookies."** 설정으로 테스트. Salesforce는 그 설정을 **미래 릴리즈(future release)** 에 강제 예정(시점 미명시). (LEX + Classic, 일부 제외; Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer)
- **Cloudfront Is Replacing Akamai as the Lightning CDN Partner** — Lightning CDN 사용 조직이 Akamai에서 **Cloudfront**로 자동 마이그레이션(롤링). 신규 조직은 자동 Cloudfront. `static.lightning.force.com`이 allowlist에 있으면 `a.static.lightning.force.com`·`b.static.lightning.force.com` 추가(Lightning Out 사용 시 CSP가 차단하지 않도록). (LEX 전 에디션)
- **Allow the Required Domain for Maps and Location Services** — Google Maps용으로 **`*.forceusercontent.com`** 을 네트워크/방화벽/프록시 allowlist에 추가. 이전엔 enhanced 도메인 미사용 조직 전용으로 잘못 표기됨. (LEX/Classic/전 모바일 버전; Professional/Enterprise/Performance/Unlimited)

---

## 관련 노트

- [[Spring '25]] — 상위 릴리즈 허브 (전체 요약·주요 신기능)
- [[Spring '25/Release Updates]] — 강제 적용(Release Update) 시점 단일 출처 (Legacy Host Names·ICU·SAML·CSP·Flow RU 등)
- [[Spring '25/Development]] — 개발자 spoke (Apex 네임스페이스·LWS distortion·Auth 핸들러·CLI/패키징 코드·LWC v63.0)
- [[Spring '25/Agentforce]] — Einstein 생성형 AI·에이전트 액션 (Einstein for Flow·Flow Formula·External Services 에이전트 액션 상세)
