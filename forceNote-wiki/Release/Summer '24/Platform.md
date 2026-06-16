---
tags: [release, summer_24, platform, admin, security, devops, architecture]
source: salesforce_summer24_release_notes.pdf
created: 2026-06-16
aliases: [Summer '24 Platform, 서머 24 플랫폼, Admin Security DevOps External Client App Scratch Org Snapshots]
---

# Summer '24 — Platform (Salesforce Overall · Admin/Customization · Security/Identity · DevOps/CLI · Architecture)

> 허브: [[Summer '24]]

> Summer '24(API v61.0) 플랫폼 영역 전수 — User Access Policy/Permission Set Summary/Search Manager Generally Available, External Client App Manager·OAuth 2.0 Token Exchange Handler·Single-Access UI Bridge API, New Setup Domain `*.salesforce-setup.com`·first-party Salesforce cookie·Chrome Storage Partitioning, MFA production default-on(2024-04-08)·in-app reminder, Scratch Org Snapshots Generally Available(90일)·Data Mask Job Scheduler·2GP for Data Cloud, SAML multiple-configuration RU(sandbox Summer '24 / production Spring '25) 등.

---

## 성숙도 범례 (Maturity Legend)

| 표기 | 의미 |
|---|---|
| **(Generally Available)** | 정식 출시 — 전 고객 사용 가능 (GA 약어 미사용, 항상 spell out) |
| **(Beta)** | Beta Services Terms 적용. 이름 + 요약만 기재 |
| **(Pilot)** | 특정 고객 한정, 추가 약관 적용. "use at your sole risk" |
| **(Release Update)** | enforce 시점 존재 — 상세·일자는 [[Summer '24/Release Updates]] |

---

## 개요

이 노트는 [[Summer '24]] 릴리즈의 **플랫폼(Salesforce Overall · Admin/Customization · Security, Identity & Privacy · DevOps/CLI · Architecture/메타데이터)** 영역을 공식 Release Notes PDF(API v61.0, Last updated September 30 2024)에서 전수 추출한 것이다.

PDF 페이지 범위(printed page 기준):
- **Salesforce Overall** p.99–119 (General Enhancements / Salesforce Scheduler / Einstein Search / Salesforce Data Pipelines)
- **Customization / Admin** p.185–201 (Permissions and Sharing / Lightning App Builder / Globalization / General Setup)
- **Security, Identity, and Privacy** p.736–765 (Salesforce Backup / Domains / Identity and Access Management / Privacy Center / Salesforce Shield / Security Center / Other Security Changes)
- **DevOps / Development** — Development Environments / Data Mask / Platform Development Tools / Packaging / New and Changed Items
- **Mobile** p.580–588 (참고 페이지 범위 — **Mobile 챕터 본문(Salesforce Mobile App · Mobile Publisher · General Mobile Updates) 전수는 [[Summer '24/Clouds]]의 `## Mobile` 섹션이 단일 소유**; 본 노트는 Android Firebase 등 platform 보안 연계 항목만 cross-ref)

탐색 원칙:
- enforce 시점이 있는 Release Update는 → [[Summer '24/Release Updates]]가 단일 권위 출처. 본 노트는 enforce 일자만 요약하고 상세는 위임한다.
- 개발자(Apex·LWC·API) 변경은 [[Summer '24/Development]] 참조.
- Cloud별 기능(Sales/Service/Experience/Data Cloud 등)은 [[Summer '24/Clouds]] 참조.
- Beta/Pilot/Dev Preview 항목은 비-GA 약관이 적용된다. 이름 + 1~2줄 요약만 싣는다.

> [!note] 중복 방지 규칙
> DevOps/패키징과 Architecture에 함께 등장하는 항목(2GP for Data Cloud, External Client Apps in 2GP, New Setup Domain, retirement 등)은 **기능 설명을 DevOps/패키징에 1회만** 둔다. Architecture에는 **메타데이터 타입/인프라 각도(metadata field name 등)만** 남긴다. New Setup Domain + Chrome Storage Partitioning의 1차 배치는 **Admin / 일반 Setup**이며, Security/도메인·Architecture에는 1줄 cross-ref만 둔다.

---

## Admin / Setup

### 권한 및 사용자 관리

- **Get a Summary of a User's Permissions and Access** (IdeaExchange Delivered) — **User Access Summary**로 user detail 페이지에서 사용자의 permission·public group·queue를 직접 조회(query/profile 탐색 불필요). Where: Lightning Experience + Classic(일부 미제공) 모든 에디션. How: Setup → Users → user 선택 → **View Summary**.
- **See Where a Public Group Is Used** (IdeaExchange Delivered) — **Public Group Access Summary**로 public group이 참조된 object sharing rule, 공유된 list view, 접근 가능 report/dashboard folder, 포함된 다른 public group을 조회. Where: Lightning Experience + Classic(일부 미제공), Professional/Enterprise/Performance/Unlimited/Developer. How: Setup → Public Groups → 선택 → **View Summary**.
- **See What's Enabled in Permission Sets and Permission Set Groups (Generally Available)** (IdeaExchange Delivered) — permission set/group에 포함된 모든 enabled object/user/field/custom permission을 한 페이지에서 조회. 어떤 permission set group이 해당 permission set을 포함하는지, 그 역도 조회. beta 이후 변경: 개선된 인터페이스 + 포함된 custom permission/permission set 조회 추가. Where: Lightning Experience + Classic(일부 미제공) 모든 에디션. How: Setup → Permission Sets 또는 Permission Set Groups → 선택 → **View Summary**.
- **Automate and Migrate User Access with User Access Policies (Generally Available)** (IdeaExchange Delivered) — permission set·package license·public group 등을 user 생성/수정 시 자동 grant/remove. 대규모 user 마이그레이션을 단일 작업으로 수행. Spring '24 이후 개선: **active 정책을 200개로 증가(기존 20개)**, active 정책 실행 순서 설정 가능. Where: Lightning Experience + Classic(일부 미제공), Enterprise/Unlimited. How: Setup → User Management Settings → User Access Policies turn on → Setup → User Access Policies.
  > PDF 원문: *"You can now create 200 active policies, up from 20, and set the order in which active policies are run."*
- **Update the Order Field for Existing User Access Policies** — 다중 정책을 동시 충족하는 user에 적용될 active 정책을 새 **Order** 필드로 지정(lowest order 값 적용). Summer '24 전 생성된 active 정책은 last-update date 기반 order 값을 받으므로 편집 권장. 자동화 안 된 manual 정책은 order 값 미부여. Where: Enterprise/Unlimited. How: Setup → User Access Policies → 정책 선택 → Edit Details.
- **Allow Users to Freeze Users and Monitor Login History Without the Manage Users Permission** (IdeaExchange Delivered) — 세분화된 신규 permission 2개로 Manage Users 권한 없이도 일부 기능 허용.
  - **Freeze Users** permission — user를 freeze/unfreeze.
  - **Monitor Login History** permission — Login History related list 접근 + Login History report 데이터 조회(report 권한 필요).
  - 기존 **Manage Users**를 가진 사용자는 두 permission이 자동 enable된다. Where: Professional/Enterprise/Performance/Unlimited/Developer. How: permission set에 추가 후 사용자 할당.
- **Find Content on Managing Users and Data Access in One Place** — user/data access 관련 Help 콘텐츠를 Salesforce Help 단일 위치로 이동(external user 관리·접근 troubleshooting 포함). Where: 모든 에디션.

### Lightning App Builder / 레코드 페이지

- **Use Blank Spaces to Align Fields on Dynamic Forms-Enabled Pages** (IdeaExchange Delivered) — 새 **Blank Space** 컴포넌트로 Dynamic Forms field section의 필드를 정렬. field section 내 수직 분리 + "Align fields horizontally" property와 결합. Where: Group/Professional/Enterprise/Performance/Unlimited/Developer.
  > 주의: blank space는 필드로 간주되어 **region당 100 필드 limit에 카운트**된다(component page limit엔 미카운트).
- **Set Conditional Visibility for Individual Tabs in Lightning App Builder** (IdeaExchange Delivered) — Tabs 컴포넌트 내 개별 tab을 조건부로 dynamic show/hide. **LWC-enabled record page의 tab에 적용.** Where: Professional/Enterprise/Unlimited/Pro Suite/Developer. LWC-enabled object 목록은 "LWC Migration for Record Home Pages" 참조.
- **Create Rich Text Headings in Lightning App Builder** — Rich Text 컴포넌트 editor의 새 dropdown으로 Heading 1/Heading 2 등 style 값 부여(screen reader 접근성 향상). 일반 텍스트는 Normal. Where: Group/Professional/Enterprise/Performance/Unlimited/Developer.
- **Add New Custom Fields to Dynamic Forms-Enabled Pages** — custom-field creation wizard의 새 step으로 새 custom field를 Dynamic Forms-enabled page에 추가. 선택한 page의 first field section 마지막 필드로 추가된다. Dynamic Forms-enabled page가 없으면 step 미표시. Where: Group/Professional/Enterprise/Performance/Unlimited/Developer.
- **See Fields in Compact Density When Configuring a Lightning Record Page** — Compact density 설정이 App Builder preview(Dynamic Forms-enabled page)에 반영(field section 필드 높이 축소). Where: Group/Professional/Enterprise/Performance/Unlimited/Developer.
- **See Record Fields in Two Columns on Tablets** — Dynamic Forms on Mobile enable 시 Record Detail - Mobile + Field Section 컴포넌트가 tablet에서 2열 표시(기존 tablet 1열). Where: Group/Professional/Enterprise/Performance/Unlimited/Developer.
- **See Dynamic Forms-Enabled Lightning Page Information for Custom Fields** (버그 수정) — "Where is this used?" 버튼으로 custom field의 Lightning page 정보 조회 시 FlexipageFieldInstance reference type 링크가 올바르게 라우팅(기존 error). How: Object Manager → Object → Fields & Relationships → custom field → "Where is this used?".
- **Rich Text Field Images No Longer Overflow Their Column Boundaries** (버그 수정) — Spring '24에 수정. Aura Record Detail 컴포넌트의 Rich Text Area 필드 이미지(열보다 넓은)가 인접 열로 overflow 안 함.

### 일반 Setup

- **Add the New Setup Domain** — Salesforce Setup 페이지가 이제 **`*.salesforce-setup.com`** 에 호스팅된다. 브라우저가 third-party 쿠키를 차단해도 Setup 페이지가 정상 로드된다. 일반 인터넷 접근 사용자는 조치 불필요. **방화벽/allowlist로 접근 제어하는 회사는 IT가 이 도메인을 허용 목록에 추가해야 한다.** Where: Lightning Experience 모든 에디션. When: Summer '24 staggered rollout 계속 — 먼저 sandbox/nonproduction org, 그다음 production org. *(1차 배치 위치 — Security/도메인·Architecture에서는 cross-ref만)*
- **Prepare for Restrictions on Salesforce Cookie Use** — 브라우저가 third-party 쿠키를 완전 차단하기 전, Salesforce session 쿠키를 사용하는 custom 기능을 테스트하고 My Domain 설정 **"Require first-party use of Salesforce cookies"** 를 활성화. 예: third-party 웹사이트 iframe에서 authenticated Visualforce 페이지 로드 시 session 쿠키 사용. Where: Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer. How: Setup → My Domain → Routing and Policies → Edit → 해당 설정 활성화.
  > PDF 원문: *"Google plans to fully block third-party access to Salesforce cookies in Chrome in December 2024."* 이 설정은 Salesforce 쿠키만 영향한다.
- **Temporarily Opt Out of Google Chrome Storage Partitioning** — Google Chrome storage partitioning이 Summer '24에 Salesforce 도메인에 enable된다. 새 설정으로 **Chrome 111–126 사용자에 대해 September 2024까지** partitioning을 비활성화하는 전환 시간을 추가 제공. Where: Lightning Experience + Classic(일부 org 미제공) 모든 에디션. localStorage·sessionStorage 등 다수 web API에 영향. How: Setup → User Interface → **"Disable Google Chrome Storage Partitioning for Salesforce Domains"** 선택 → 저장 → 모든 쿠키/history clear → 브라우저 닫고 재로그인.
  > PDF 원문 (두 deprecation trial 종료 일자 — 혼동 주의):
  > - *"Chrome 111–126 사용자는 **September 3, 2024**에 Google deprecation trial이 영구 종료 — 이후 설정 무관하게 partitioning enable."*
  > - *"opt out 시 Chrome 127 업그레이드를 피할 것 — **Chrome 127 deprecation trial은 July 23, 2024**에 종료, 설정 무관하게 partitioning enable."*
- **Better Error Handling for Outdated Pages in Lightning Experience** — 페이지 JS 버전이 서버 버전과 어긋날 때 정밀 error handling. 서버가 outdated page를 처리 시도 → 성공 시 warning(편할 때 refresh) / 드물게 처리 불가 시 error(refresh 유도). Salesforce 데이터와 무관(client-out-of-sync). Where: Lightning Experience 모든 에디션. When: Summer '24부터 rolling basis.
  > 메시지 verbatim — Warning: *"This page has changes since the last refresh. To get the latest updates, save your work and finish your conversations before refreshing the page."* / Error: *"We couldn't process your request. Refresh the page and try again. Any unsaved changes are discarded when you refresh the page."*
- **System Informational Banners Are Now Gray** — 모든 system informational banner(예: sandbox logout confirmation)가 blue → gray. Where: Lightning Experience 모든 에디션.
- **See Improved Contrast in Focus States** — SLDS blueprint + Lightning base component에 new focus state styling(컴포넌트 perimeter에 dark blue line). 기본 on, 끌 수 없음. WCAG non-text contrast/focus appearance 기준 충족. Where: Lightning Experience 모든 에디션.
  > [!note] 시각 자료 경고 — "Old focus state styling" vs "New focus state styling"은 PDF에 이미지 비교만 있고 텍스트 본문이 없다. 이미지 자체는 재현하지 않는다.
- **Get a Natural-Language Explanation / Fix Formula Syntax Errors with Einstein for Formulas** — Einstein for Formulas가 formula(Formula field/default field value/validation rule)의 **syntax error 수정 + explanation**을 제공. Where: Enterprise/Performance/Unlimited(Einstein generative AI). How: Formula Editor → **"Use Formula Assistant"** → Einstein이 fixed formula 제안.
- **Register More API Specifications with Support for YAML** — External Services-compliant OpenAPI 2.0/3.0 spec을 JSON 또는 **YAML** 로 등록(기존 JSON만). Where: Enterprise/Performance/Unlimited/Developer.
  > PDF 원문: *"YAML-formatted specifications are subject to a maximum size limit of 3 MB."*
- **Access More External Data Types with the Custom Adapter for Salesforce Connect** — Apex Connector Framework 개선 — custom adapter로 더 많은 external data 연결. **새 지원 external object field type: Currency, Date, Email, Percent, Phone.** Where: Enterprise/Unlimited/Developer/Performance. How: **DataSource.Connection** Apex class 생성/업데이트.
- **See Required Fields at a Glance on Aura-Based Page Views** — Aura-based page(desktop)에서 record create/full edit/clone 시 우상단에 **"* = Required Information"** 메시지. inline edit 시 LWC-enabled object는 우하단, Aura-based(예: Campaigns, Products, Tasks)는 우상단. Where: Lightning Experience 모든 에디션.
- **Get Better Performance for List Views** — **sandbox의 custom object list view가 Aura → LWC 렌더**(standard object list view는 여전히 Aura). Where: sandbox, Lightning Experience 모든 에디션. When: Summer '24부터 rolling basis. 변경: List Views dropdown 최대 100 list 표시(초과 시 검색), keyboard navigation top 시작, Filters panel 새 Cancel/Save 버튼, location-based field filter 값이 저장 후 약어로(CA, NV), column/field header icon 미렌더, error 메시지 위치/형식 변경.
- **Review Updated URLs for List Views** — list view URL이 ID 대신 **API Name**으로 식별. Recently Viewed list URL은 `Recent` 대신 `__Recent` 파라미터. LWC 렌더 custom object는 새 URL로 redirect, Aura 렌더 object는 이전 URL 허용. Where: Lightning Experience 모든 에디션.
- **Get Improved Accessibility in List Views** — screen reader 논리적 순서 announce; pin list 버튼이 list view 이름 포함; chart/filter 버튼 focus 시 tooltip; Spring '24 도입 단축키 **Ctrl+Alt+arrow(Win) / Cmd+Option+arrow(macOS)** 로 related list 탐색. Where: Group/Professional/Enterprise/Performance/Unlimited/Developer.
- **Enforce View Roles and Role Hierarchy Permission When Editing Public List View Visibility (Release Update)** — **View Roles and Role Hierarchy** permission을 가진 사용자만 public list view visibility 편집 시 role 목록을 조회/선택. role 미사용 org은 무영향. Where: Enterprise/Performance/Unlimited/Developer. When: Spring '24 최초 제공, **Winter '25 enforce 예정이었으나 Spring '25로 연기.** 상세 → [[Summer '24/Release Updates]].
- **Enable LWC Stacked Modals (Release Update)** — Aura → LWC 내부 마이그레이션 일환으로 Lightning Experience의 더 많은 modal이 LWC로 렌더(record create/edit modal 성능 개선). Where: Lightning Experience 모든 에디션. When: Summer '24 available, **Spring '25 enforce.** 동작 변경: lookup으로 record 생성 시 Save & New 버튼 사라짐, custom quick action modal의 post-save navigation 없어짐, stacked modal에서 record 생성 시 생성 레코드로 이동 대신 record page로 복귀. 상세·enforce → [[Summer '24/Release Updates]].
  > custom quick action 가이드 — LWC quick actions: `lightning/navigation` 사용 시 newer modal이 이전 modal 위에 stack(기본), 자동 닫으려면 `replace`를 true로. Aura quick actions: `force:createRecord`/`force:editRecord`를 `lightning:navigation`으로 업데이트 권장 — `navService.navigate(pageRef, true);`(replace=true).
- **Create and Verify Your Default No-Reply Organization-Wide Email Address to Send Email (Release Update)** — 이메일 보안 준수를 위해 Organization-Wide Email Address 설정에 **Default No-Reply 주소를 생성·검증** 필수(없으면 일부 이메일 발송 실패). Where: Lightning Experience + Classic, 모든 에디션 except Database.com. When: Summer '24 도입, **Winter '25 enforce 예정.** 상세 → [[Summer '24/Release Updates]].
- **MFA Is On by Default for Direct Logins to Production Orgs** — 새 production org go-live 시 direct login 과정에 MFA가 default. Sandbox·trial org(subscription 전환 전)은 미영향. **SSO 사용자도 MFA 필수**(SSO IdP에서 MFA 활성화하거나 Salesforce 무료 MFA 사용). Where: Lightning Experience + Classic + 모든 mobile app 버전, 모든 에디션. When: **April 8, 2024 발효.** verification 방법: authenticator app, security key, built-in authenticator. **30-day grace period** — 첫 사용자 로그인 시 시작, 이후 모든 사용자에 uniform 적용.
- **Salesforce Admins Get In-App Reminders If MFA Is Turned Off** — MFA 계약 요건이 full effect(2022-02-01부터)이며, 기술적 enforce 대신 **notification 모델**. customer가 org-wide MFA 설정을 비활성화하면 모든 admin이 재활성화까지 주기적 in-app 경고를 받는다(off 옵션은 테스트 목적 유지되나 계약 위반). Where: Lightning Experience + 모든 mobile app 버전, 모든 에디션. How: 설정 비활성화 시 Setup에서 **"Turn On MFA"** 버튼으로 재활성화 페이지 직행(dismiss 가능하나 주기적 재등장).

### Search Manager (Generally Available)

> Einstein Search 하위(Salesforce Overall p.116–117). Search Manager beta → Summer '24 Generally Available.

- **Improve Search for Users with Search Manager (Generally Available)** (IdeaExchange Delivered) — Search Manager에서 사용자 search를 customize — search channel 구성, rule로 filter, always-search object 구성. beta 이후 일부 변경 포함. Where: Professional/Enterprise/Performance/Unlimited/Developer.
- **Other Improvements in Search Manager** — object 필드 add/remove로 **search index** 관리, configuration 편집/삭제, org 간 configuration 마이그레이션. Where: Professional/Enterprise/Performance/Unlimited/Developer.
- **Provide Relevant Results with Objects to Always Search in Search Manager (Generally Available)** — global search configuration에서 always-search object 선택, 특정 user profile별 tailor. always-search object 선택 페이지가 Search Manager로 이동. Where: Professional/Enterprise/Performance/Unlimited/Developer.
- **Ensure Security in Search with Search Manager** (FLS in Search) — sensitive custom 필드에 **field-level security** 적용. **모든 standard 필드는 기본 보호.** object당 **최대 100 custom 필드 선택**(100 초과 시 unprotected 추가 필드 기반 매칭). Where: Professional/Enterprise/Performance/Unlimited/Developer. When: **After June 5, 2024** sandbox Search Manager에서 index configuration 테스트, **After June 12** production migrate.
  > PDF 원문: *"All standard fields are protected by default. You can select up to 100 custom fields per object. If an object has more than 100 custom fields, the search engine matches…(unprotected 필드 기반)."*
- **Improve Search with Insights from Search Analytics (Pilot)** — built-in dashboard 또는 자체 dashboard로 search 데이터 분석. Where: Lightning Experience 모든 에디션. Who: Data Cloud license + Data Cloud credits. How: Setup → Einstein Search → Settings.
  > PDF Pilot 면책 verbatim: *"This feature is not generally available and is being piloted with certain Customers subject to additional terms and conditions… use of this feature is at your sole risk."*

### 기타 Setup

- **Work More Efficiently with the Improved Your Account Interface** — Your Account 인터페이스에 새 horizontal navigation menu(product/license count 증가, quotes/contracts/renewals 관리, invoice 결제). Where: Lightning Experience, Starter/Pro Suite/Professional/Enterprise/Performance/Unlimited. Who: Manage Billing 권한 또는 Your Account App Admin User permission set. **모든 Your Account tab을 Default On 해야 접근 가능**(Product Catalog tab이 Tab Hidden이면 접근 불가).
- **Find and Buy Salesforce Products Faster with the Improved Product Catalog** — Your Account App의 **Product Catalog** — Shop Available Products tab(계약 추가 가능 제품), Manage Your Products tab(보유 제품, 추가 license/resource 구매). Where: Lightning Experience + Classic, Starter/Pro Suite/Professional/Enterprise/Performance/Unlimited.
- **Monitor Product Consumption in Near Real-Time with Digital Wallet** — **Digital Wallet**로 consumption-based 제품 사용량/trend 모니터링(App Launcher 또는 Your Account app의 Consumption Cards). Where: Lightning Experience, Enterprise/Unlimited. Data Cloud consumption-based 제품에 available. Who: **View Consumption** user permission(Digital Wallet).
- **Show Users Recommendations with Suggested for You** — 비즈니스 needs 기반 personalized suggestion(새 feature 채택·제품 추천). Where: Lightning Experience 모든 에디션 except Essentials. When: **July 12, 2024 available.** How: Setup → Adoption Assistance.
- **Experience Improved Performance for Big Objects** — max 허용 크기 초과 데이터는 write 시 encode/validate 안 함, read 시 UI layer가 metadata 명시대로 precision/scale 해석. Where: Enterprise/Performance/Unlimited/Developer. When: May 2024 rollout.
- **Monitor Net Zero Cloud Changes with Field History Tracking** — Field History Tracking으로 주요 Net Zero Cloud 필드 변경 조회(**NZC object당 최대 20 필드/object** 추가). Where: Classic(일부 미제공) + Lightning Experience + Salesforce app. Who: Net Zero Cloud enabled customer.

> [!note] Globalization (참고) — ICU Locale Formats(Release Update, Spring '24부터 rolling enforce, UI로 Spring '25까지 defer 가능, en_CA 별도 활성화), Zimbabwe Gold (ZiG) currency, Review Updated Label Translations(Chinese Simplified·Danish·Dutch·Finnish·German·Greek·Hungarian·Japanese·Spanish·Spanish Mexico·Norwegian·Russian·Slovenian·Turkish), ICU/JDK locale update 영향(Thai/Arabic Saudi Arabia/Serbian/Tagalog/Chinese Malaysia date format) 항목이 Customization 섹션에 포함된다. ICU enforce 상세 → [[Summer '24/Release Updates]].

---

## Security / Identity & Privacy

### Identity and Access Management

- **Create External Client Apps While Maintaining Security and Defined User Roles** — 새 **External Client App Manager**로 external client app을 생성/관리/업데이트(기존엔 Metadata API). Connected Apps의 차세대로 2GP managed packaging 보안 강화. Where: Lightning Experience, Professional/Performance/Unlimited. Who: External Client Apps opt-in org만. How: Setup → External Client App → Settings → **"Opt in to External Client Apps".**
- **Use More OAuth Features with External Client Apps** — external client app framework가 **headless login, passwordless login, guest user flow(Authorization Code and Credentials Flow)** 지원 + **JWT-based access token** 발급 구성. **headless registration 제외 모든 Authorization Code and Credentials Flow variation 지원.** Where: Authorization Code and Credentials Flow는 LWR/Aura/Visualforce site, Enterprise/Unlimited/Developer; JWT-based access token은 Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer. How: External Client App Manager 또는 Metadata API.
- **Use REST API for Access to External Client App OAuth Consumer Credentials (Release Update)** — Metadata API 대신 새 **`credentials`** Connect REST API resource로 External Client App OAuth consumer credential 접근. **source control에 consumer secret 실수 commit 방지.** Where: Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer. When: **Winter '25 enforce** — 이후 Salesforce Customer Support 연락 없이는 Metadata API로 consumer secret 접근 불가. 상세 → [[Summer '24/Release Updates]].
- **Create Token Exchange Handlers More Easily** — OAuth 2.0 **token exchange handler**를 Setup에서 정의/enable(기존 Metadata API). handler definition 생성 → Apex class 연결 → property 설정(지원 token type, user 생성 여부). Where: Enterprise/Performance/Unlimited/Developer. How: Setup → **Token Exchange Handlers.** definition 편집은 Metadata API.
- **Use the Token Exchange Flow with More Identity Providers** — OAuth 2.0 token exchange flow를 더 많은 third-party IdP와 사용. Where: Enterprise/Performance/Unlimited/Developer. How: POST `/services/oauth2/token`, provider token을 `subject_token` 파라미터에.
  > PDF 원문: *"the value can be up to 10,000 characters long. Previously, …(2,000자)."*
- **Integrate Custom App Experiences with the Salesforce UI** (Single-Access UI Bridge API) — 새 **Single-Access UI Bridge API** — 기존 access token으로 Salesforce UI(Visualforce site/mobile app)에 새 session 로드(재로그인 불필요). 예: headless app 로그인 사용자를 Experience Cloud site로 redirect. Where: Lightning Experience + Classic 모든 에디션. How: POST로 access token을 **`/services/oauth2/singleaccess`** endpoint에 전송 → frontdoor.jsp URL JSON 응답 → redirect.
- **Grant Specific Permission to Manage Custom Domains** — custom domain/custom URL add/edit/delete를 broader admin 권한 없이 허용(기존 Customize Application 필요). Where: Enterprise/Performance/Unlimited (+ Professional with Marketing Cloud Account Engagement/Pardot). How: 새 **Custom Domain Management** user permission을 permission set에 추가.
- **Migrate to a Multiple-Configuration SAML Framework (Release Update)** — single-configuration SAML framework(외부 IdP 1개) 지원 제거, **multiple-configuration만** 지원. 미적용 시 enforce 시점에 SSO 중단. Spring '24 최초 제공. Where: Enterprise/Unlimited/Developer. 변경: IdP의 SAML 응답에 **audience attribute** 포함 필수, Salesforce Login URL 변경, SAML 응답 parse 불가 시 login history 미기록.
  > **enforce 일자 (양쪽 모두 기록 — collapse 금지):** PDF verbatim: *"This update is enforced for production instances in **Spring '25** and is enforced for sandboxes in **Summer '24**. This update was scheduled to be enforced for all instances in Summer '24 but was postponed to Spring '25 for production instances only."*
  > 전체 Release Update 상세 → [[Summer '24/Release Updates]].
- **Enter New Firebase Information Required for Android Push Notifications** — legacy Firebase Cloud Messaging API server key를 더 이상 미수용. Android mobile connected app이 Firebase project의 **Admin SDK private key + project ID**를 요구. Where: mobile connected app(Android push), Group/Professional/Enterprise/Essentials/Performance/Unlimited/Developer. How: Firebase Console에서 획득 → App Manager의 mobile connected app 설정에 제출.
- **Verify Email Addresses to Meet the Email Verification Requirement** — Spring '22 도입 email verification 요건 enforcement 완료 — **모든 org/Experience Cloud site의 모든 user 이메일 검증 필수**(unverified 주소 발송 reject). Spring '24에 paid production SSO(Spring '24 이후 생성)만 enforce 시작, **Summer '24에 생성 시점 무관 모든 org/site enforce.** 주로 SSO user 영향. How: Setup → Users → Email 필드(Verify → Verified), 또는 async email method / DKIM 도메인 검증.
- **Stay on Top of MFA Compliance** — MFA가 **April 8, 2024**부터 production direct login default-on, **Summer '24**부터 미준수 admin in-app reminder. *(상세는 Admin/일반 Setup의 MFA 항목 참조)*
- **Forced Login is Permanently Disabled in Winter '25** — **Winter '25**에 username/password를 URL query string으로 전달하는 forced login(autologin)을 영구 비활성화. forced login URL 사용 구현/third-party 통합 break. Where: Lightning Experience(일부 미제공) + Classic 모든 에디션. How: Setup → Login History → 6개월 history 다운로드 → HTTP method 열 확인(GET + Login Subtype 없음 = forced login). external client app/connected app으로 마이그레이션.
- **Users Must Approve Access Every Time They Trigger the Device Flow** — OAuth 2.0 **device flow** — flow 시작 action마다 데이터 접근 허용 prompt(기존 일부 통합 미prompt). Where: Lightning Experience(일부 미제공) + Classic 모든 에디션. How: Permitted Users policy가 "All users may self-authorize"일 때만 적용("Admin approved users are pre-authorized"면 미prompt).
- **Simultaneous Token Requests Are Blocked During the Refresh Token Flow** — OAuth 2.0 refresh token flow에서 동일 refresh token의 동시 token request 차단(한 번에 1 request). Where: 모든 에디션. 동시 시 Login History Status에 **"Failed: Token request is already being processed".** 권장: access token 캐시·재사용.
- **Refresh Token Rotation Now Works As Expected for Instances on Salesforce's First-Party Infrastructure** (버그 수정) — OAuth refresh token rotation이 **first-party infra 모든 인스턴스**에서 정상 작동(Hyperforce는 항상 정상). 제대로 개발 안 된 app은 break 가능. Where: 모든 에디션.
  > PDF 원문(지역별 일자): *"For sandboxes, this change is available on August 6, 2024 or August 7, 2024. For production orgs, this change is available on August 7, 2024 or August 8, 2024."*
- **Take Advantage of Apex Enhancements for Processing JSON Web Tokens (JWTs)** — **Auth.JWTUtil** class 메서드로 JWT 데이터 추출 용이, JWT 처리 시 HTTP callout mock 가능. Where: Enterprise/Performance/Unlimited/Developer. 상세 → [[Summer '24/Development]] (Auth Namespace).
- **Identify the Origin IP Address for Logins with One or More Proxies** — proxy redirect 로그인의 origin IP를 새 **Forwarded for IP** 열(Login History)로 추적(X-Forwarded-For header 값). **OAuth/SSO 로그인 미제공.** Where: Lightning Experience(일부 미제공) + Classic 모든 에디션.
- **Password Reset Login Subtype Label Is Changed** — Login Subtype 열이 "Change Password" → **"UI Password Reset".** Where: Lightning Experience(일부 미제공) + Classic 모든 에디션.
- **Enable Embedded Login** — **Summer '24에 Embedded Login default 비활성화**(OAuth 2.0 Web Server/User-Agent Flow 권장). Embedded Login은 third-party 쿠키 의존(대부분 브라우저 차단). Where: Lightning communities, Professional/Enterprise/Performance/Unlimited/Developer. How: Login & Registration → "Allow embedded login on your Experience Cloud site".
- **Customize SMS One-Time Password Delivery for Experience Cloud Sites (Beta)** — external user용 branded identity verification — Apex handler로 OTP를 선택한 SMS provider로 발송(MFA·passwordless login 등 모든 verification use case). Where: LWR/Aura/Visualforce site, Enterprise/Unlimited/Developer.
- **Brand the Welcome Email for Passwordless Registration** — 새 **Welcome New Member for Passwordless Registration** 이메일 template으로 OTP 이메일 customize. Where: LWR/Aura/Visualforce site, Professional/Enterprise/Unlimited/Developer.

### Salesforce Backup

> 공통 조건: Enterprise/Professional/Unlimited, Salesforce Backup add-on subscription.

- **Set a Custom Backup Schedule** — backup 일정 customize — **monthly/weekly/daily/hourly**, start time + time zone 선택. **v2.19 managed package.** How: Salesforce Backup app → Backup tab → Configure Policy Defaults.
- **Add Read-Only Objects to Your Backup Policy** — **v2.19** managed package가 일부 read-only object 지원(**History associated object + Activities object** 추가)으로 감사 목적 record 보존. How: Backup tab → available object 목록에 read-only object 표시 → 선택 → policy enable.
- **Get More Information from Backup and Restore Logs** — Logs 페이지 메시지 단순화(Log Name 열이 job start/complete만 표시) + 새 job status 카테고리(severity별: Customer Support 필요 error, fix 가능 alert, informational). object status code 개선(예: `NOT_VISIBLE` → `MISSING_PERMISSIONS`). Where: Professional/Enterprise/Unlimited.

### Salesforce Shield / Event Monitoring

- **Access and Download Event Log File Data with the Event Log File Browser (Generally Available)** — **Event Log File Browser**(Setup)로 third-party tool 없이 ELF 데이터 접근. Where: Enterprise/Performance/Unlimited/Developer(Event Monitoring enabled). How: Setup → Event Log File Browser → date range 선택 → "Download as CSV File", 또는 File Download servlet.

```
# verbatim — File Download servlet (PDF p.755)
/servlet/servlet.FileDownload?file=<ELF_ID_NUMBER>
https://mycompany.my.salesforce.com/servlet/servlet.FileDownload?file=0ATRM000000dcbH0A0
```

- **Query Low-Latency Event Data with Event Log Objects (Beta)** — 새 **event log object framework (beta)** — event data를 standard object에 캡처, API로 직접 query. Where: Enterprise/Performance/Unlimited(Event Monitoring enabled). When: **US East Hyperforce customer는 at least June 2024까지 미작동.** Who: US East Hyperforce customer 일부.
- **Download Up to 1 Year of Event Log Files** — retention period 조정으로 **최대 1년** ELF 데이터 다운로드. Where: Enterprise/Performance/Unlimited(Event Monitoring enabled). How: Setup → Event Monitoring Settings → "Retain event log files" enable → **`eventLogRetentionDuration`** field(EventSettings Metadata API type)로 일수 지정.
- **Track Network Performance Metrics** — 새 **UI Telemetry Timing** events: **Resource Timing** ELF type(원격 서버 리소스 로드 시간), **Navigation Timing** ELF type(page navigation·DOM 구성 시간). API + Event Log Browser에 available(Event Monitoring Analytics app 아님). Where: Enterprise/Performance/Unlimited/Developer.
- **Track Pricing Data Using Event Log Files** — 새 **Pricing** ELF type(pricing API 실행 시간·status·error code·pricing procedure). Where: Enterprise/Unlimited/Developer(Event Monitoring + Salesforce Pricing enabled).
- **Audit Net Zero Cloud Field Changes** (Field Audit Trail) — archived NZC field history 값 retention period 연장, 모든 NZC object field history tracking을 **single click** enable. **기본 18개월 retention.** Who: Field Audit Trail 또는 Salesforce Shield add-on + Net Zero Cloud enabled.
- **Einstein Data Detect Is Now Data Detect** — **Einstein Data Detect → Data Detect** rename(동작 불변, transition 중 이전 이름 잔존 가능). Where: Enterprise/Performance/Unlimited. Who: Salesforce Shield add-on.

#### Shield Platform Encryption (FLS 암호화 확장)

- **Encrypt Search Index Keys with Manageable Root Keys** — search index를 암호화하는 key material 제어 추가(envelope encryption). search index의 DEK를 생성·암호화하는 **root key** 제어. Where: Enterprise/Performance/Unlimited/Developer. When: Summer '24 rolling basis. How: Encryption Settings에서 search index encryption on(root key/DEK rotation 가능).
- **See Fewer Encryption Statistics and Sync Timeouts** — encryption statistics 수집 + active key historical data sync 속도 개선(개선된 indexing). Where: Enterprise/Performance/Unlimited/Developer.
- **Access the Bring Your Own Key Pages with Assistive Technologies** — BYOK 페이지(Setup)가 Lightning Experience styling(contrast/keyboard/screen reader 개선). Where: Enterprise/Performance/Unlimited/Developer.
- **신규 암호화 가능 필드 (모두 probabilistic·case-sensitive deterministic·case-insensitive deterministic scheme):**
  - **Encrypt Grantmaking Compliant Data Sharing Comments** — Individual Application Task Participant 객체의 **Comments** field (Grantmaking enabled).
  - **Encrypt Application Form Seller Item Fields** — Application Form Seller Item 객체: Vehicle Identification Number, Engine Number, Vehicle Registration Number, Property Address, Scheduled Delivery Date, Property Unit Identifier, Make, Model, Trim (FSC enabled).
  - **Encrypt Party Income and Party Expense Fields** — Party Income 객체 **Income As Of Date**, Party Expense 객체 **Expenses As Of Date** (FSC enabled).
  - **Encrypt Party Financial Liability, Party Financial Asset, and Party Financial Asset Lien Fields** — Party Financial Liability(Start Date, Term, Lender, Liability Account Identifier), Party Financial Asset(OwnershipStartDateTime, ValuationDateTime, Description, SerialNumber, MakeName, ModelName, ModelYear), Party Financial Asset Lien(Lien Holder, Maturity Date) (FSC enabled).

#### Security Center

> 공통 조건: Enterprise/Performance/Unlimited/Developer, Security Center add-on subscription.

- **Create Custom Metrics in Security Center (Beta)** — custom object 데이터를 monitor하는 custom metric 생성(Security Center → Custom Metrics tab).
- **View Pertinent Data with an Enhanced Security Center Dashboard Page** — Security Landscape 내 더 engaging한 chart.
- **View Your Data Cloud Encryption Policy Status from the Security Center Encryption Policy Metric** — **Encryption Policies metric**에서 Data Cloud encryption key status 접근. Who: Shield Platform Encryption + Security Center add-on. How: Security Center dashboard → Security Landscape의 Configuration category.
- **View Fields That Are Encrypted Under Your Shield Platform Encryption Policy** — **Field Level Encryption metric**으로 Shield Platform Encryption policy 암호화 필드 접근.

### 도메인 / 쿠키

- **Maximize Availability with Partitioned Domains in More Orgs** — My Domain이 새 **Developer Edition·patch·scratch·demo org + Trailhead Playground**에 **partitioned domain** 사용(org type 단어 포함). 새 qualifying org default-on, enhanced domain sandbox는 항상 partitioned. **scratch partition은 Salesforce Edge Network 사용 시 newly available.** Government Cloud—Defense org는 sandbox partition만. **Trailhead Playground(Salesforce Edge Network)는 partitioned domain 미제공.** Where: non-production org(enhanced domain), Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer. How: allowlist 업데이트 + My Domain Setup → "Use partitioned domains" → preview → 저장·deploy. *(metadata/인프라 각도는 Architecture 섹션 참조)*
- **Update References to Your Previous Salesforce Domains** — legacy Salesforce domain 임시 redirection 종료 대비(site URL + instance 포함 URL 업데이트). Where: Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer. When: **Winter '25에 redirection 중단** — 배포는 sandbox **August 2024**, production **September 2024** 시작 예정.
- **Identify Redirections for Your Instanced My Domain Hostnames** — hard-coded instanced My Domain URL을 **Hostname Redirects event type** 필드(**SOURCE_HOSTNAME**)로 식별(Winter '25 redirection 종료 전). 예: instance IND76 → `ind76.salesforce.com`, `ind76.lightning.force.com`. API에서만, 무료, **24시간 retention.** Where: Enterprise/Performance/Unlimited/Developer.
- **first-party Salesforce cookie / Chrome Storage Partitioning** — *(1차 설명은 Admin / 일반 Setup의 "Prepare for Restrictions on Salesforce Cookie Use" 및 "Temporarily Opt Out of Google Chrome Storage Partitioning" 참조 — Chrome storage partitioning 2024-09-03 deprecation trial 종료, My Domain "Require first-party use of Salesforce cookies" 설정 포함)*
- **The BrowserId_sec Cookie Was Removed** — **BrowserId_sec 쿠키가 더 이상 렌더되지 않음**(BrowserId 쿠키가 동일 목적 수행). Where: Lightning Experience + Classic + 모든 mobile app, 모든 에디션.

### Other Security Changes

- **Allow Only Trusted Cross-Org Redirections (Release Update)** — 다른 Salesforce org로의 redirection 제한 — **Trusted URLs for Redirects** allowlist에 신뢰 org URL 추가. Winter '24 최초 제공(October 2023 이전 받은 org은 default enabled). Where: 모든 에디션. When: **Summer '24 enforce.** 상세 → [[Summer '24/Release Updates]].
- **Adopt Updated Content Security Policy (CSP) Directives (Release Update)** — Lightning page CSP directive 업데이트(외부 host font/image·iframe 외부 웹사이트 로드 차단 가능). Summer '24 available. Where: Enterprise/Performance/Developer/Unlimited. When: **Winter '25 enforce 예정이었으나 Spring '25로 연기.** **August 2024에 CSP violation 샘플링 recalibration**(새 violation 감지 가능, September 2024 재검토 권장). 상세 → [[Summer '24/Release Updates]].
- **Review and Resolve Blocked External Redirections** — **Trusted URL and Browser Policy Violations** Setup 페이지가 blocked external redirection + CSP violation을 한 view에 표시(기존 페이지명 "CSP Violations"). Where: Enterprise/Performance/Unlimited/Developer.
- **Limit Who Receives Notifications About Certificate Expiration** (IdeaExchange Delivered) — 새 **Receive Certificate Expiration Notifications** user permission. 권한 사용자는 만료 **60/30/10일 전** 이메일, System Administrator/Modify All Data는 만료 **전날·당일** 이메일. 아무도 할당 안 하면 System Administrator/Modify All Data가 모든 이메일 계속 수신. Where: Enterprise/Performance/Unlimited/Developer.
- **Control Which HTTP Status Codes Refresh Access Tokens for Named Credentials** — standard 401 외 다른 **4xx** code를 token refresh trigger로 지정. How: Setup → Named Credentials → external credential → **"Additional Status Codes for Token Refresh"** field(예: 400, 403).
- **Confirm Access to External Systems When Named Credentials Use the OAuth 2.0 Browser Flow** — Browser Flow OAuth 2.0 external credential에 인증 후 external system 상호작용을 confirm하는 새 step 추가. Where: 모든 에디션.
- **Create 3072-Bit Sized Certificates** — self-signed/CA-signed certificate에 **3072-bit** key length 옵션 추가(**2048-bit, 3072-bit, 4096-bit**). 2048/3072-bit는 **1년 만료**, 4096-bit는 **2년 만료**(Shield Platform Encryption BYOK 권장). Where: Enterprise/Performance/Unlimited/Developer.
- **Audit More Changes to Salesforce Sites and Visualforce Sites** — Site History에 더 많은 설정 추적(site default record owner, public Visualforce page cache 옵션, Support API guest access 등). Salesforce Sites 미enable 시 Setup Audit Trail이 Sites domain 등록·새 site 생성 추적. Where: Enterprise/Performance/Unlimited/Developer.
  > [!note] 시각 자료 경고 — "Here are examples of the new and improved audit trail events" 이후 스크린샷은 PDF 이미지로 텍스트 미추출. 본 노트는 텍스트 단서만 기재.
- **Enjoy Faster Load Times for Cached Salesforce Site Pages** — public Salesforce Site page caching 동작 업데이트(page load 개선). Where: Enterprise/Performance/Unlimited/Developer.
- **Visualforce Section Header Components Are Secure by Default** — 기본적으로 secure HTML element만 `<apex:sectionHeader>`의 `description` attribute에서 평가(uncommon HTML/insecure attribute/JavaScript 제거). Where: 모든 에디션.

> [!note] Privacy Center (참고) — Retain Data with Privacy Center(platform-native 버전 data retention, Government Cloud 미제공, August 2024부터 rolling), UI Text and Functionality Improvements("is before"→"is within the last", "is after"→"is beyond the last", "Number of Days"→"Number of Days Relative to Policy Execution Date", "Preview"→"Summary"), Permission Requirements for the Consent Event Stream Are Enforced(ReadAllData 또는 PrivacyDataAccess 필요) 항목이 Security 섹션에 포함된다.

---

## DevOps / CLI

### 개발 환경 (Development Environments)

- **Capture a Scratch Org's Configuration with Scratch Org Snapshots (Generally Available)** — scratch org configuration의 **snapshot**(= point-in-time copy)을 capture하여 scratch org replica를 생성. beta 이후 새 기능: **Salesforce Platform 및 Limited Access user license 지원, snapshot expiration period를 90일로 연장, snapshot language 변경.** Where: Developer/Enterprise/Performance/Unlimited. When: **late June 2024부터 rolling basis.** How: Dev Hub org에서 Setup으로 **Scratch Org Snapshots** 활성화 후 Salesforce CLI로 관리.

```
# CLI 토픽 — PDF가 명시한 명령 (sf 접두는 표준 Salesforce CLI 호출 형식)
org create snapshot
org list snapshot
```

  > PDF 원문: *"New features since beta include support for Salesforce Platform and Limited Access user licenses, the extension of the snapshot expiration period to 90 days, and the ability to change the snapshot's language."*
- **Increase Sandbox Security with Inactive User Freezing** — Developer 또는 Developer Pro sandbox에서 user 생성 시점 기준 **첫 60일** 내 미로그인 user를 자동 freeze하여 sandbox 보안 강화. **비활성화 불가.** Where: Developer/Developer Pro sandbox. When: **July 2024부터 rolling basis.** How: 자동 실행 — frozen user는 unfreeze로 접근 제공.
- **New User Permission: Manage Dev Sandboxes** — 새 **Manage Dev Sandboxes** permission으로 **Developer/Developer Pro sandbox만** create/clone/refresh/delete(Partial Copy·Full sandbox는 기존 Manage Sandboxes 필요). Where: Professional/Enterprise/Performance/Unlimited/Database.com. When: production org이 Summer '24로 업그레이드 시 available. How: profile 또는 permission set로 할당.
- **Select Who Has Sandbox Access for Production Orgs with 60 or More Public Groups** (Selective Sandbox Access) — **production org에 public group이 60개 이상**이어도 public group을 통한 sandbox access 제공 지원(기존엔 60개 미만 org만). Where: Professional/Enterprise/Performance/Unlimited/Database.com sandbox. How: production org에 public group 60개 이상이면 sandbox 생성/refresh 시 Sandbox Access에 public group 이름 입력.
- **Test Data Cloud Features in a Sandbox (Beta)** — testing/staging/training용 sandbox에서 Data Cloud feature 접근(sandbox 생성 시 production Data Cloud metadata/configuration 복제, data kit + change set으로 production 배포). Where: Data Cloud, Enterprise/Performance/Unlimited(production org에 Data Cloud license). When: July 2024.

### Data Mask

> Lightning Experience + Classic, Enterprise/Unlimited/Developer(Data Mask installed). 최신 managed package **2.1000.**

- **Access Information About Specific Data Mask Job** — Data Mask의 **Run Logs tab이 Jobs tab으로 변경.** Jobs tab list view에서 Data Mask 이름 클릭 → configured objects, current job progress, error 조회.
- **Automate the Running of Data Mask Processes with Job Scheduler** — Data Mask 실행 빈도를 **daily/weekly/monthly**로 구성하여 sandbox의 모든 신규 데이터 mask.
- **Other Improvements to Salesforce Data Mask** — record loading/transformation 최적화로 job 완료 속도 개선. job 완료 시 **automation을 deactivate/reactivate 대신 bypass**, field-history tracking을 끄지 않고 삭제, serial mode 제거(row-lock 시 record 자동 retry).

### Salesforce CLI / 도구 (Platform Development Tools)

- **Salesforce CLI Enhancements** — Salesforce CLI는 주 단위 릴리스. 아래 변경은 **CLI version 2.44.8 이상** 적용:
  - **Source Mobility (Beta)** — `SF_BETA_TRACK_FILE_MOVES` 환경 변수를 true로 설정 시, local Salesforce DX project 내 source file 이동을 삭제+재생성으로 오인하지 않음(rename은 미지원, child source file은 동일 이름 parent로만 이동).
  - **Improved `data` Commands (Beta)** — `data import|export tree` 개선(2단계 초과 child object export, 200 record 초과 파일 처리). `data import beta tree`·`data export beta tree`로 시험.
  - **Decompose More Metadata Types (Beta)** — custom label·permission set·sharing rule·workflow의 큰 metadata 파일을 작은 source file로 decompose.
  - **Refresh a Sandbox from Salesforce CLI** — 새 `org refresh sandbox` 명령.
  - **Store Flag Values in Local Text Files** — `--flags-dir`로 긴 CLI 명령의 flag 값을 local text file에 저장.
  - **More Colorful Help** — `--help` 출력에 색상 강조(커스터마이즈 가능).
- **Salesforce Extensions for Visual Studio Code** — Salesforce extension pack 주 단위 릴리스. 새 문서 사이트(developer.salesforce.com)로 통합.
- **Code Builder** — VS Code·Salesforce Extensions·Salesforce CLI를 웹 브라우저에서 제공하는 web-based IDE. 새 문서 사이트로 통합.
- **Einstein for Developers (Beta)** — CodeGen 기반 AI 개발 도구(VS Code extension). **모든 Salesforce org에 기본 enable.**
- **Deploy Scalable Apps with Scale Center** — connection pool·Visualforce·sync/async callout error org 성능 metric 추가, database CPU investigation의 SOQL 성능 추천, ApexGuru insight PDF export.
- **Plan and Test with Scale Test** — sandbox instance calendar에 슬롯 예약하여 production peak load 테스트, 최근 테스트 성능 비교, in-app 알림/이메일 확인.

### 패키징 (Packaging)

> 기능 설명의 1차 위치 — Architecture에는 metadata/infra 각도만 둔다.

- **Use Second-Generation Managed Packaging to Build Data Cloud Apps** — Data Cloud feature에 2GP 적용. Data Cloud metadata는 **data kit에 먼저 추가한 뒤 package에 추가**, Data Cloud app은 Data Cloud metadata만 포함. Where: second-generation managed packages. When: April 2024부터. Who: Data Cloud Second-Generation Managed Packaging은 Salesforce Partner만.
- **Quickly Iterate Package Development Using Async Validation** — 새 package version 생성 시 **async validation** 지정 — package validation 완료 전에 version을 먼저 생성하여 즉시 install/test(CI run time 단축). Where: unlocked package + 2GP. When: **June 15, 2024부터.**

```
# verbatim — async validation (PDF p.255)
sf package version create --async-validation <rest of command syntax>
```

- **Shorten Package Install Time in Scratch Orgs by Skipping a Handler** — scratch org 설치 시 **FeatureEnforcement** skip handler 지정으로 install time 단축(feature enforcement는 scratch org에 critical하지 않음). PackageInstallRequest object의 `SkipHandler` field를 `FeatureEnforcement`로 설정하거나 CLI:

```
# verbatim — skip handler (PDF p.256)
sf package install --skip-handlers FeatureEnforcement <rest of command syntax>
```

- **Package External Client Apps In Second-Generation Managed Packages** — external client apps framework가 headless login·passwordless login·guest user flow(Authorization Code and Credentials Flow)를 지원하며 **2GP managed package에 포함 가능.** guest user flow에는 JWT-based access token 발급 구성이 필요.
- **Benefit from Simplified Org Migration with Automatically Migrated Change Sets** — Salesforce가 org를 한 instance에서 다른 instance로 마이그레이션할 때 **change set이 자동 마이그레이션**(기존엔 metadata 변경 목록을 수동 보존). Where: 모든 에디션.
- **Remove Custom Metadata Type Records from a Second-Generation Managed Package** — *(Development 발췌, Architecture/Packaging 인접)* — 자세한 항목은 [[Summer '24/Development]] 참조.

---

## Architecture (메타데이터 / 인프라)

> 위 DevOps·Security 섹션과 중복되는 항목은 **메타데이터 타입/인프라 각도(metadata field name 등)만** 둔다. 기능 설명은 해당 섹션 1회 기재. retirement 예고는 → [[Summer '24/Release Updates]] cross-ref.

### 인프라 / 도메인

- **Partitioned Domains** — My Domain partitioned domain이 신규 Developer Edition·patch·scratch·demo org + Trailhead Playground로 확대. **scratch partition은 Salesforce Edge Network 사용 시 newly available**(Edge Network의 Trailhead Playground는 partitioned domain 미제공). *(기능 설명 → Security/도메인 섹션)*
- **New Setup Domain `*.salesforce-setup.com`** — Setup 페이지 호스팅 도메인. allowlist 추가 필요. *(1차 설명 → Admin/일반 Setup)*

### 신규 / 변경 Metadata Type (New and Changed Items)

> PDF "New and Changed Items for Developers"의 Metadata API 항목 중 Platform/DevOps 관련. metadata type 이름과 적용 영역만 기재.

| Metadata Type / Field | 용도 (verbatim) | 연결 기능 |
|---|---|---|
| **DevHubSettings.`enableScratchOrgSnapshotPref`** (new field) | *"This field enables Scratch Orgs for Snapshots in your Dev Hub org so you can create snapshots of a fully configured scratch org."* | Scratch Org Snapshots (DevOps/개발 환경) |
| **SearchOrgWideObjectConfig** (new type) | *"Use the new SearchOrgWideObjectConfig metadata type to configure the org-wide search index."* | Search Manager / Objects to Always Search (Admin) |
| **SearchCustomization** (new type) | *"Use the new SearchCustomization metadata type to migrate Search Manager configurations."* | Search Manager 마이그레이션 (Admin) |
| **PlatformEventChannel.`eventType`** (new field) | *"Create a channel that can hold Real-Time Event Monitoring events by setting the new eventType field on the PlatformEventChannel metadata type."* — Metadata API/Tooling API로 채널 구성(`PlatformEventChannelMember`로 event 추가), 최대 3 custom event monitoring channel | Event Monitoring (Security/Shield) |
| **EventSettings.`eventLogRetentionDuration`** (field) | ELF retention 일수 지정 | Download Up to 1 Year of Event Log Files (Security/Shield) |
| **EventSettings.`enableLightningLoggerEvents`** (existing field) | custom LWC logging enable (Salesforce Shield/Event Monitoring add-on) | Event Monitoring (Security/Shield) |
| **UserAccessPolicy.`order`** (new field) | 다중 정책 충족 시 적용될 active user access policy 지정 | User Access Policies (Admin) |

### API / Connect REST 리소스 (인프라 각도)

| 리소스 / 클래스 | 용도 | 연결 기능 |
|---|---|---|
| **Connect REST API `credentials`** | External Client App OAuth consumer credential 접근 (Metadata API 대체, Winter '25 enforce) | Identity (Security) |
| **`/services/oauth2/singleaccess`** | Single-Access UI Bridge API — access token → frontdoor.jsp URL JSON | Identity (Security) |
| **`/services/oauth2/token`** (`subject_token` 최대 10,000자) | Token exchange flow 확대 | Identity (Security) |
| **`DataSource.Connection`** Apex class | Custom Adapter for Salesforce Connect 새 field type(Currency/Date/Email/Percent/Phone) | General Setup (Admin) |
| **`Auth.JWTUtil`** class | JWT 처리 Apex 개선 → [[Summer '24/Development]] (Auth Namespace) | Identity (Security) |

> retirement 예고 (Salesforce Platform API v21.0–30.0, Mobile metadata subtype 제거 등)는 enforce/일자 권위 출처인 [[Summer '24/Release Updates]]를 참조.

---

## 관련 패턴 노트 (업데이트 필요)

> 본 릴리즈에서 GA/신규로 전환되어 reference 노트 작성·보완이 필요한 항목(PM/cross-linker 검토 대상):

- **Scratch Org Snapshots (Generally Available)** — Salesforce DX/DevOps reference 노트 작성 또는 보완 후보(`org create snapshot`·`org list snapshot`, 90일, `DevHubSettings.enableScratchOrgSnapshotPref`).
- **External Client Apps** — Connected Apps 차세대. OAuth flow(headless/passwordless/guest user, JWT-based access token)·External Client App Manager·2GP 패키징 reference 노트 후보.
- **Search Manager (Generally Available)** — Search/검색 reference 노트(FLS in Search 100 custom fields/object, `SearchOrgWideObjectConfig`·`SearchCustomization`) 후보.
- **User Access Policies (Generally Available)** — 권한 관리 reference 노트(200 active policy, order field) 후보.

---

## 관련 노트

- [[Summer '24]] — Summer '24 릴리즈 허브
- [[Summer '24/Development]] — 개발자(Apex·LWC·API) 변경
- [[Summer '24/Clouds]] — Cloud별 기능
- [[Summer '24/Release Updates]] — enforce 시점 단일 권위 출처
- [[Release MOC]] — 전체 릴리즈 목차
