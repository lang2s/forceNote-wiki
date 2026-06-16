---
tags: [release, spring_24, platform, admin, security, mobile, hyperforce]
source: salesforce_spring24_release_notes.pdf
created: 2026-06-16
aliases: [Spring '24 Platform, 스프링 24 플랫폼, Admin Security Hyperforce]
---

# Spring '24 — Platform (Salesforce Overall · Customization/Admin · Security/Identity/Privacy · Mobile · Hyperforce · Architecture)

> Spring '24(API v60.0) 플랫폼 영역 전수 — Hyperforce 무중단 업그레이드·새 Setup 도메인 `salesforce-setup.com`, Permission Set Groups 전 에디션, OAuth 2.0 Token Exchange·Refresh Token Rotation·External Client App, MFA 자동 활성화 최종 단계, 한국·스웨덴 리전 GA, Metadata 배포 한도 600MB·Scratch Org Snapshots/Pub/Sub Managed Subscriptions Beta 등.
> 허브: [[Spring '24]]

---

## 개요

이 노트는 [[Spring '24]] 릴리즈의 **플랫폼(Salesforce Overall · Customization/Admin · Security, Identity & Privacy · Mobile · Hyperforce · Architecture/인프라)** 영역을 공식 Release Notes PDF(API v60.0)에서 전수 추출한 것이다.

- enforce 시점이 있는 Release Update는 → [[Spring '24/Release Updates]]도 함께 참조
- 개발자(Apex·LWC·API) 변경은 [[Spring '24]] 허브의 Apex/LWC/API 섹션 참조
- Beta/Pilot/Dev Preview 항목은 비-GA 약관(Beta Services Terms 등)이 적용된다. 이름 + 1~2줄 요약만 싣는다.

---

## Salesforce Overall (p.91–108)

### 인프라 / 도메인

- **Get Core Major Releases with No Downtime [인프라]** — Summer '24부터 Hyperforce의 major release 업그레이드가 **무중단(no service downtime)**으로 전환. 온라인 사용자는 보안 요건상 재로그인 프롬프트를 받는다. 기존엔 **5분 maintenance window + downtime**이 필요했다. Where: Lightning Experience·Salesforce Classic, all editions. When: Summer '24 시작 — major release 날짜는 1년 전, 릴리즈는 **60일 전 통보되는 1시간 window** 동안 진행.
- **Allow the New Setup Domain to Ensure Access to Salesforce Setup Pages [인프라]** — Salesforce Setup 페이지가 이제 `*.salesforce-setup.com`에서 호스팅된다. 방화벽/allowlist 사용 시 IT 부서는 이 도메인을 허용 목록에 추가해야 한다. When: **Spring '24부터 rolling basis** — 먼저 sandbox/non-production org, 그다음 production org. (관련: New Setup Domain Rollout FAQ, Google's Privacy Sandbox Initiative)
- **Temporarily Opt Out of Google Chrome Storage Partitioning [인프라]** — Google Chrome storage partitioning이 Summer '24에 Salesforce 도메인에 활성화된다. Chrome 115에서 Google이 third-party context의 storage partitioning을 강제하며, Salesforce는 현재 Google deprecation trial에 참여 중이다. 신규 설정으로 opt out 시 Google deprecation trial이 영구 종료되는 **2024년 9월 3일**까지 unpartitioned storage를 유지할 수 있으나, 그 날짜 이후엔 설정과 무관하게 활성화된다. localStorage·sessionStorage 등 다수 web API에 영향. Where: Lightning Experience·Salesforce Classic(일부 org 미지원), all editions.
  - How (verbatim 경로): Setup → User Interface → **Disable Google Chrome Storage Partitioning for Salesforce Domains** 선택 후 저장. 이후 모든 browser cookie/history 삭제 → 브라우저 닫고 재로그인.

> [!note] MFA 관련 두 항목(Salesforce Overall)
> - **MFA Enforcement Is Shifting to In-App Notifications Starting in Summer '24** — MFA 채택률이 높아 Summer '24에 기술적 강제 milestone 대신 **알림 모델**로 전환. admin은 "Require multi-factor authentication (MFA) for all direct UI logins to your Salesforce org" 설정이 비활성화되면 in-app 메시지를 받는다. 계약 요건은 유효하며 채택률 하락 시 기술적 강제 프로그램 재개 계획.
> - **MFA Is Turned On by Default Starting April 2024** — **2024년 4월 8일 이후 생성 production org**에 MFA 기본 ON. Spring '23~Spring '24 자동 활성화 단계에 포함되지 않은 기존 production org에도 적용. Sandbox 영향 없음, Trial org은 구독 전환 전까지 영향 없음. org에 **30일 grace period** 부여, admin은 Identity Verification 페이지에서 임시 비활성화 가능.

### 성능 / Your Account

- **Experience Improved Performance on More Record Home Pages [LWC enablement]** — Spring '24에 **120개 이상 객체**가 LWC-enabled(AdverseEventAction·IssuedCard·ResearchStudy·Visit 등). 단, breaking change 방지를 위해 **WorkOrder·WorkOrderLineItem·ServiceAppointment**는 성능 개선을 임시 제거. Where: Lightning Experience·Salesforce mobile app(Field Service mobile 제외).

```
# LWC-enabled record home URL 패턴 (verbatim, PDF line 5542–5545)
https://MyDomainName.my.salesforce.com/lightning/r/ObjectApiName/RecordId/ViewOrEdit
https://my-dev-org.my.salesforce.com/lightning/r/Account/0012L00001OCuehQAD/view
```

- **Create From Lookup Changes** — lookup 필드로 레코드 생성 시 나타나는 record create modal 변경. 모든 record page에서 lookup 필드 생성 시 **Save & New 버튼 미표시**(비-lookup Create/Edit modal엔 계속 표시). LWC-enabled page에서는 create-from-lookup modal이 LWC로 표시되며 URL addressable·Dynamic Forms 지원. When: Spring '24부터 rolling basis, **2024년 6월 종료 예상**.
- **Upgrade from Starter to Pro Suite in Your Account** — Starter 고객이 Your Account의 Product Catalog에서 Pro Suite 업그레이드 요청. Who: Manage Billing 또는 Your Account App Admin permission set. Where: Salesforce Starter edition.
- **Find Transactions Faster with the Your Account Home Page** — Your Account home page 사용성 개선. Who: Manage Billing 또는 Your Account App Admin User permission set.

### Trust Site Enhancements

- Trust.salesforce.com / Status.salesforce.com 개선: **17개 platform-supported 언어 full localization** 추가 / Sales·Support 연계 제품 표시 일관성 / Well-Architected Framework·Quip Prod Status 링크 / Status site는 Marketing Cloud Personalization·Account Engagement 지원 추가 및 알림 이메일에 영향받는 instance만 표시.

---

## Customization / Admin (p.175–194)

### Lightning App Builder · Dynamic Forms

- **Add Fields from Related Objects to Dynamic Forms-Enabled Pages** (IdeaExchange Delivered) — component palette에서 lookup relationship field로 drill-in하여 related object 필드에 접근, cross-object field를 record page에 drag. Fields 탭 상단 breadcrumb이 drill-in span을 표시하고 cross-object field는 arrow icon(>)으로 표시. **2단계까지 drill-down 가능, polymorphic relationship field는 미지원.** Where: Group/Professional/Enterprise/Performance/Unlimited/Developer.
- **Set Field Visibility by Device in Dynamic Forms** — 개별 field에도 device form factor(desktop/phone) 기반 visibility rule 설정 가능. canvas에서 field 선택 → properties pane에서 **Device** context로 visibility rule filter 생성.
- **See a Field's Object Relationship and API Name in Dynamic Forms** — 모든 field에 신규 property 2개 추가: **Object**, **API Name**.
- **Use Dynamic Forms on Pinned Region Pages** — pinned region page template 기반 Lightning page에서 Dynamic Forms 사용. 기존 pinned region page에 Record Detail component가 있으면 component 클릭 → **Upgrade Now**로 migration wizard 실행.
- **Dynamic Forms on Mobile Is Enabled by Default in New Orgs** — **Spring '24 이후 생성 신규 org는 Dynamic Forms on Mobile 기본 활성화.** (Setup → Quick Find "Mobile" → Salesforce Mobile App)
- **Use Dynamic Actions with Standard Objects on Mobile** (IdeaExchange Delivered) — mobile에서 standard object에 dynamic action 사용. Lightning App Builder에서 action 할당, filter(user field·form factor 등) 적용. Where: Lightning Experience desktop + Salesforce mobile app, Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer.
- **Translate the Related List Label in the Dynamic Related List - Single Component** (IdeaExchange Delivered) — custom label로 번역 후 Related List Label 필드에 다음을 입력:

```
# verbatim (PDF line 8224)
{!$Label.customLabelName}
```

- **Preview Mobile Actions on Record Pages Before Activating** — Lightning App Builder의 Phone preview 옵션으로 mobile action 표시 확인. Where: Lightning Experience desktop.
- **Create a Custom Omni Supervisor Page** — 신규 **Omni Supervisor Page** Lightning page type으로 supervisor용 custom tab 생성. Where: Professional/Enterprise/Performance/Unlimited/Developer.

### Salesforce Connect

- **Salesforce Connect Adapter for Amazon Athena Is Now Salesforce Connect Adapter for SQL** — Amazon Athena adapter가 **Salesforce Connect adapter for SQL**로 rename. Amazon Athena 외에도 REST API로 query/DML(SQL)을 노출하는 외부 소스를 지원. 기존 Amazon Athena 매핑 external data source는 기능 동일. Where: Lightning Experience·Salesforce Classic, Enterprise/Performance/Unlimited/Developer.
- **Connect Securely to Snowflake and Perform Interactive Queries from Salesforce** — Salesforce Connect adapter for SQL로 Snowflake 데이터를 복사·sync 없이 접근(query·DML·metadata 관리). How: type **SQL**의 external data source 정의 → provider로 **Snowflake** 선택.

### Sharing

- **Update Organization-Wide Defaults Faster** — 대량 parent account/person account/portal account 시 OWD 변경이 더 빨리 처리되고 Background Jobs 페이지에서 진행을 모니터링. When: Spring '24부터 rolling basis, **Summer '24 완료**. Where: Professional/Enterprise/Performance/Unlimited/Developer/Database.com.
- **Enable Faster Account Sharing Recalculation by Not Storing Opportunity Implicit Child Shares (Release Update)** — Opportunity의 account sharing recalculation 방식 변경. account와 child opportunity 간 implicit child share record를 더 이상 저장하지 않고 접근 시 동적 판정한다. **Winter '24 최초 제공, Spring '24 enforce.** Winter '24 이전 생성 production org은 Spring '24부터 rolling basis, 이후 생성 production/scratch org은 기본 활성화, sandbox는 Winter '24 rolling. 주의: implicit child opportunity share record를 query하는 SOQL/Apex test는 더 이상 결과를 반환하지 않는다.

### Permissions

- **Use Permission Set Groups in All Editions** — **permission set group이 전 에디션에서 제공**(Contact Manager·Group·Essentials·Professional·Enterprise·Performance·Unlimited·Developer·Database.com).
- **Get Notified Before Deleting Permission Sets Assigned to Users** — 사용자에게 직접 또는 permission set group을 통해 할당된 permission set 삭제 시도 시 **error**. 미할당 permission set만 삭제 가능.
- **Reference Picklists, Groups, and Queues in User Access Policies (Beta)** — policy의 user criteria filter에서 user picklist field·group·queue 참조 가능 + 개선된 UI. Where: Enterprise/Unlimited. How: Setup → User Management Settings → **Enable User Access Policies (Beta)**. 개선 UI는 기본 활성화이나 **Enhanced Interface for User Access Policies (Beta)** 설정으로 비활성화 가능.

### Globalization

- **Enable ICU Locale Formats (Release Update)** — ICU(International Components for Unicode) locale format 채택. 활성화 시 Oracle JDK locale format을 ICU로 대체(날짜/시간/통화/주소/이름/숫자). **Winter '20 최초 제공, Spring '24부터 rolling basis로 enforce.** Winter '20 이후 생성 org은 ICU 기본. admin은 org ICU 활성화 **30~60일 전** 이메일로 통보받으며, **UI로 Spring '25까지 enforcement 연기 가능**. **English (Canada) locale(en_CA)는 별도 활성화 필요**(Setup → User Interface → "Enable ICU formats for en_CA"). Where: all editions(Database.com 제외).
- **Present Your Custom Functionality in English (Italy) and Three Mayan Platform-Only Languages** — platform-only **English (Italy)** + **Mayan 3개 언어: Chuj, Kaqchikel, Kiche**로 앱/custom label/custom object/field name localization. 모든 표준 Salesforce label은 English 기본이며 Translation Workbench로 번역 커스텀. Where: all editions(Database.com 제외).
- **Changed CustomObjectTranslation and ValueSetTranslations Behavior** — CustomObjectTranslation·ValueSetTranslations 접근 시 local/packaged translation 중 지정 가능. 미지정 시 이전 버전과 동일 동작.
- **Evaluate the Impact of the Latest ICU Locale Updates** — 기본 통화 변경: Spanish (Ecuador), Spanish (Puerto Rico), Spanish (El Salvador), Spanish (United States).
- **Review Updated Label Translations** — 다음 언어의 일부 표준 object/tab/field name 번역 업데이트: Arabic, Chinese (Simplified), Portuguese (Brazil), Czech, Danish, Dutch, Finnish, French, German, Greek, Hebrew, Hungarian, Italian, Japanese, Korean, Spanish, Spanish (Mexico), Norwegian, Polish, Romanian, Slovenian, Thai, Slovak, Russian, Chinese (Traditional), Turkish, Vietnamese, Portuguese (European). Where: 모든 edition.

### Fields · AppExchange

- **Confirmation Message When You Select the Multi-Select Picklist Field Type** (IdeaExchange Delivered) — multi-select picklist field type 선택 시 제약 검토 안내 확인 메시지 표시. Where: all editions.
- **Explore AppExchange Solutions Based on Your Interests** — 신규 **Explore** 탐색 방식(category: business need·industry·Salesforce product·corporate impact·Salesforce Labs). Where: AppExchange website.
- **Navigate AppExchange More Efficiently** — 간소화된 navigation bar(Explore 탭, Collections 탭(구 Latest Collections)). **Solutions by Type·Product Collections·Industry Collections 탭 retire/제거.**

> [!note] 시각 자료 경고 — AppExchange Explore(p.188–190)는 PDF에 "How:" 스크린샷 단계 설명이 있으나 이미지 자체는 pdftotext로 추출되지 않음. 본 노트는 텍스트 단서만 기재한다.

### General Setup

- **Get a Natural-Language Explanation of Your Formulas** — Einstein for Formulas가 formula(Formula field·default field value·validation rule)의 자연어 설명을 제공. Formula Editor에서 **Explain Formula** 클릭. **Einstein for Formulas 라이선스 필요.** Where: Enterprise/Performance/Unlimited.
- **Handle Callbacks Asynchronously in Apex** — OpenAPI spec에 valid callback operation 포함 시 External Services가 callback interface를 가진 typesafe Apex class를 생성, Apex callback interface로 비동기 callout을 처리한다. **외부 시스템 지연 응답을 최대 24시간 대기**(기존 동기 callout은 HTTP 응답 최대 **2분** 후 timeout). Background Operations app 또는 Apex Debug log로 상태 모니터링. Where: Enterprise/Performance/Unlimited/Developer.
- **Enforce View Roles and Role Hierarchy Permission When Editing Public List View Visibility (Release Update)** — **View Roles and Role Hierarchy** permission 가진 사용자만 public list view visibility 편집 시 org role 목록을 조회/선택. **Spring '24 최초 제공, Winter '25 enforce.** Manage Public List Views만 가진 사용자는 list view를 편집할 수 있으나 Public Group/완전공개/비공개만 설정 가능. role 미사용 org은 영향 없음.
- **Remove Updates to Most Recently Used Items to Improve API Performance** — user 기반 MRU item 업데이트를 자동 제거하여 API 성능 향상(API 전용 integration user에만 권장). How: Setup → Users → 사용자 선택 → **No MRU Updates**.
- **See Required Fields at a Glance on Dynamic Forms-Enabled Page Views** — create/edit/clone 시 asterisk = required 안내 메시지("* = Required Information"). Where: all editions.
- **Large Images No Longer Run Off the Page in Record Printable View** — rich text area field의 large image가 Printable View에서 page width로 제한.
- **Get Improved Accessibility in List Views** — Pin List View 버튼 keyboard focus indicator 강화 / List View header link keyboard 선택 / Charts panel 닫기 버튼 "Close charts" assistive label + tooltip / Benefit Type record page의 Benefits list view accessible label / 빈 list view keyboard focus 논리적 패턴 / split view records list infobubble / inline edit 저장 오류 screen reader 안내 + assistive text / related list 항목 record preview icon(Tab 키 navigation). Where: Group/Professional/Enterprise/Performance/Unlimited/Developer.

---

## Security, Identity, and Privacy (p.669–703)

### Domains

- **Update References to Your Previous Salesforce Domains** — legacy Salesforce domain 임시 redirection이 2024년 종료. site URL 및 instance 포함 URL 참조를 업데이트해야 한다. When: **Winter '25에 redirection 중단** — 배포는 sandbox **2024년 8월**, production **2024년 9월**.
- **Use Partitioned Domains in More Orgs [인프라]** — My Domain이 신규 **Developer Edition org·patch org·scratch org·demo org·Trailhead Playground**에 **partitioned domain**을 사용한다. partitioned domain은 org type 관련 단어를 포함하여 점진적 service delivery 변경 rollout을 가능하게 하며 allowlist 업데이트가 필요하다. **demo partition은 신규**, develop/scratch partition은 Salesforce Edge Network 사용 시 신규. Government Cloud—Defense org은 sandbox partition만. Salesforce Edge Network의 Trailhead Playground는 partitioned domain 미제공. How: My Domain Setup → My Domain Details의 **Use partitioned domains** 옵션 활성화 → 미리보기 → 저장·배포.

### Identity and Access Management

- **Migrate to a Multiple-Configuration SAML Framework (Release Update)** — 원래 single-configuration SAML framework(외부 IdP 1개만 SSO) 지원을 제거하고 **multiple-configuration SAML framework만** 지원한다. 미적용 시 enforce 시점에 SSO가 중단된다. **Spring '24 최초 제공, Summer '24 enforce.** 변경 사항: IdP의 SAML response에 **audience attribute** 포함 필수 / Salesforce Login URL 변경 / SAML response parse 실패 시 login history 미기록. Where: Enterprise/Unlimited/Developer.
- **Improve Compatibility with Third-Party Services with the Token Exchange Flow** — **OAuth 2.0 token exchange flow**로 third-party IdP 토큰을 Salesforce 토큰으로 교환. app이 Salesforce token endpoint에 request하면, Metadata API로 정의하고 Apex로 개발하는 **token exchange handler**가 토큰을 검증하고 subject를 매핑한다. Where: Enterprise/Performance/Unlimited/Developer.
- **Expand Branding Options and Improve Security for Headless Identity Flows** — headless registration/passwordless login/forgot password flow에 다중 branded email template. OTP email template **allowlist**를 생성하고, 초기 request의 `emailtemplate` parameter는 allowlist 템플릿만 허용. How: Metadata API로 각 allowlist 템플릿에 **NetworkEmailTmplAllowlist** metadata type 생성. Headless Forgot Password는 추가로 Login & Registration 페이지에서 "Use only allowlisted email templates" 선택. Where: Enterprise/Unlimited/Developer.
- **Monitor Changes to Login Pages in the Setup Audit Trail** — My Domain/Experience Cloud login page의 login option 표시·숨김 변경 추적(username-password form·auth provider·external SAML IdP; My Domain은 certificate-based auth 추가). My Domain auth provider는 Enterprise/Performance/Unlimited/Developer.
- **Find Experience Cloud SAML Endpoints More Easily** — SSO setting detail 페이지에 Experience Cloud SAML endpoint를 **For Experience Cloud** heading으로 표시(구 "For Communities" 그룹). Where: Enterprise/Performance/Unlimited/Developer.
- **Salesforce-Managed App for the Twitter Authentication Provider is Being Retired** — Twitter auth provider용 Salesforce-managed app이 **Spring '24에 retire**. X(구 Twitter) developer platform에서 자체 app을 생성하고 consumer key/secret 값을 업데이트해야 저장 가능.
- **Generate Parameters for the Proof Key for Code Exchange (PKCE) Extension** — 신규 **PKCE Generator endpoint**로 `code_challenge`·`code_verifier` parameter 생성(authorization code injection 방지). web server flow·hybrid web server flow·headless Authorization Code/Credentials Flow에 권장이며, public client(SPA·mobile app)에 특히 중요. Where: all editions.

```
# PKCE generator — GET request (verbatim 경로)
GET services/oauth2/pkce/generator
# (My Domain 또는 Experience Cloud site URL 기준)
```

- **Rotate Refresh Tokens** — connected app에 **refresh token rotation** 활성화. flow 호출마다 새 refresh token을 발급하고 이전 토큰을 자동 무효화한다. 회전된 이전 토큰 재사용 시도 시 현재 refresh token + 연관 access token이 무효화된다. **connected app + external client app 모두 지원.** Where: all editions.
- **Responses from the SCIM Users Endpoints Use 24-Hour Format for Created and Last Modified Dates** — SCIM `/services/scim/v2/Users` 및 `/Users/<user_Id>` 응답의 `created`·`lastModified`가 UTC 12시간 → **UTC 24시간 format**으로 변경(REST API의 User object와 일치).

```json
GET https://mycompany.my.salesforce.com/services/scim/v2/Users/<userId>

"meta": {
"created": "2023-10-30T14:30:15Z",
"lastModified: "2023-11-01T15:20:10Z",
"location: "https://mycompany.my.salesforce.com/services/scim/v2Users/<userId>",
"resourceType": "User",
"version": "d959e2db34c46435d2c1321126dc54ef25f2ca39"
}
```

> 변경 전 값: created `2023-10-30T02:30:15Z`, lastModified `2023-10-30T03:20:10Z` (UTC 12시간). 위 JSON은 PDF line 8669–8691 verbatim 인용. 유사하게 `https://mycompany.my.salesforce.com/services/data/v60.0/sobjects/User/<userId>` GET도 CreatedDate·LastModifiedDate를 UTC 24시간으로 반환한다.

#### External Client App

- **Get OAuth 2.0 Credentials for Consumers Associated with an External Client App** — 신규 Connect API endpoint로 external client app의 OAuth consumer credential 조회: **Consumer Credentials by App**(모든 consumer), **Credentials by Consumer**(특정 consumer의 consumer key/secret). Who: **View External Client App Consumer Secrets in Metadata** permission(external client app enabled org). How: Setup에서 **Opt In to External Client Apps** 활성화. OAuth consumer 정보는 source control commit 금지 — metadata pull 대신 Connect REST API로 client ID/secret 조회. packageable external client app은 developer hub org에서만 개발.
- **Configure an OAuth 2.0 Client Credentials Flow for an External Client App** — 신규 metadata field로 client credentials flow 설정.
- **Configure an OAuth 2.0 Device Flow for External Client Apps** — 신규 **isDeviceFlowEnabled** field로 device flow 제어.
- **Configure an OAuth 2.0 JWT Bearer Flow for External Client Apps** — external client app global OAuth settings file의 신규 **certificate** field에 digital certificate를 추가하여 JWT flow 생성(CI 시스템용).
- **Disable or Enable an External Client App Plugin** — 신규 **ExtlClntAppConfigurablePolicies** metadata type으로 plugin 제어(전체 app+plugin 또는 OAuth plugin만 비활성화).

#### MFA / Authenticator

- **MFA Auto-Enablement Concludes for All Remaining Orgs (Release Update)** — MFA 자동 활성화의 **4번째이자 마지막 단계가 Spring '24 rollout 시 발효**(1단계는 Spring '23 시작). 이전에 미활성화된 모든 org를 포함한다. "Require multi-factor authentication (MFA) for all direct UI logins to your Salesforce org"가 자동 ON. **30일 grace period**(org 자동 활성화일에 시작, 전 사용자 동일 window — 예: 5일 후 로그인 시 25일 남음). 임시 비활성화는 가능하나 계약 요건이다. Where: all editions.
- **UI Text Improvements for the MFA Registration Experience** — Choose a Verification Method / Connect Salesforce Authenticator / Connect an Authenticator App 화면 텍스트 개선.
- **Salesforce Authenticator Is Disabled for External Users in Newly Created Orgs** — **Spring '24 이후 생성 org**은 external user에게 Salesforce Authenticator를 기본 미제공(활성화는 Customer Support 문의). Spring '24 이전 org는 영향 없음.
- **Revert Seamlessly to One-Time Passcodes for Identity Verification in Salesforce Authenticator** — push 불가 시 TOTP 화면으로 자동 redirect, Having Trouble? 링크로 직접 이동.
- **Update the Salesforce Authenticator App to Version 4.1 in Summer '24** — Summer '24에 최소 지원 버전을 상향한다. **버전 4.1 이상에서만 push 수신**, 4.1 미만은 TOTP만 가능. **버전 4.1 출시 목표 2024년 3월.** 구버전 로그인 시 6자리 TOTP code를 요구하고, Lightning Login도 push 불가 시 username-password로 revert.
- **Use Email Verifications to Back Up and Restore Connected Accounts in Salesforce Authenticator** — 버전 4.0부터 backup/restore가 mobile number 대신 **email 주소 검증**(6자리 code) 사용(SMS보다 안전). email 미검증 시 기존 backup은 mobile number로 restore 가능.
- **Stay on Top of Push Notifications for Salesforce Authenticator** — app에서 알림 활성화 여부 확인 + one-tap 링크. Focus mode 대응을 위해 push가 **time-sensitive**. When: 버전 4.1.0 이상.

#### 세션 / 로그인

- **Terminate a User's UI Sessions Automatically When Resetting Their Password** — password reset 시 사용자 UI session 전체 자동 종료(다중 reset에도 적용). How: Session Settings → **Terminate all of a user's sessions when an admin resets that user's password** 활성화.
- **Login History Entries Are Reduced When Login Rate Limiting Is Active** — 사용자가 **시간당 3,600 login request** 초과 시 rate limiting이 발동하고 신규 Login History entry가 감소한다(주로 API integration user). 3,600 미만으로 복귀하면 표준 동작 재개.
- **Set Up Registration and Login for Pay Now** — one-click checkout용 registration/login. Where: Pay Now, Enterprise/Unlimited.
- **Upgrade to Identity Connect 7.1.6** — **Identity Connect 7.1.6**로 업그레이드(7.1.1 보안 개선 추가). 2.1 또는 3.0.X.X 사용 시 권장이며 **Winter '22부터 2.1·3.0.X.X 다운로드 불가**. **Developer edition은 10개 Identity Connect permission set license 포함.** 2.1/3.0.X.X 업그레이드 전 최신 managed package 설치.
- **Receive Additional Status Information During Headless Forgot Password Flow** — Headless Forgot Password flow 성공 메시지에 `status_code` 외 `status` parameter 추가.
- **See Password Resets in the Login History** — Login History의 Login Subtype 컬럼에 password reset 시 **Change Password** 표시(기존엔 GET request로 기록).

### Named Credentials

- **Use the Basic Authentication Protocol with Named Credentials** — external credential을 **Basic authentication protocol**로 구성(enhanced named credential schema 보안 + legacy Password protocol 기능 결합). external credential 생성 시 Basic Authentication 선택 → principal 생성, identity type 지정(**Named Principal**: 사용자 대신 인증 / **Per User**: 각 사용자 자체 username·password). Metadata/Tooling/Apex ConnectApi API로도 생성·편집 가능.
- **Distribute Named Credentials with Second-Generation Managed and Unlocked Packages** — named credential + **external credential** component를 managed 2GP/unlocked package에 추가(기존엔 named credential만 지원). 
- **Do More with Named Credential Formula Functions** — **SIGN·SIGN_WITH_CERTIFICATE** formula function이 named/external credential custom header 지원 값으로 추가. **`$Credential.Endpoint.URL`** 변수가 callout HTTP header/request body 구성 시 지원.
- **Experience Improvements to Sandbox Cloning and Org Migrations for Named Credentials** — sandbox clone 시 named/external credential parameter 포함, org migration 시 암호화된 access token 저장 user external credential 포함.

### Privacy Center

> 공통 조건: Enterprise/Performance/Unlimited/Developer, Privacy Center add-on subscription.

- **Automatically Run Right to Be Forgotten Jobs** — **Right to Be Forgotten Daily Job** 활성화 시 policy job이 **24시간마다** 자동 실행(queue). How: Privacy Center home → Right to Be Forgotten Daily Job tile → Enable.
- **View Error Details for Failed Policy Jobs** — Privacy Job Session 탭 → 실패 job 선택 → **Related** 탭 → Failures의 Error Message 컬럼.
- **Copy Privacy Center Policies Between Sandbox and Production Orgs** — policy configuration import/export(Privacy Policies 탭 → Import/Export).
- **Share Data Between Preference Manager and Data Cloud (Beta)** — Data Cloud(beta)용 subscription consent template 생성, 제출 시 consent data가 Data Cloud에 sync. Who: Data Cloud 라이선스 + Privacy Center add-on.
- **Add an Unsubscribe All Button to Preference Forms** — 한 번 선택으로 전체 unsubscribe(Preference Builder → Properties panel → Unsubscribe All).
- **UI Text and Functionality Improvements in Privacy Center** — filter operator 변경: **is before → is within the last**(policy 실행일 이전 지정 일수 이내 record, 예: 45일이면 45일 이내) / **is after → is beyond the last**(지정 일수보다 더 이전, 예: 45일이면 45일 초과) / **Number of Days → Number of Days Relative to Policy Execution Date** / **Preview → Summary**(정보용이며 유효 SOQL 아님 disclaimer 삽입) / permanently delete 적용 시 경고 banner.
- **Permission Requirements for the Consent Event Stream Are Enforced** — Consent Event Stream 알림 수신에 **ReadAllData 또는 PrivacyDataAccess** permission 필요(기존엔 문서화만, 미강제). 미보유 사용자는 알림 중단.

### Salesforce Backup

> 공통 조건: Enterprise/Professional/Unlimited, Backup and Restore add-on subscription.

- **Find Records More Efficiently When Restoring Backups** — backup/modified 날짜로 filter, 사용자별 또는 **15/18자리 ID**로 record 검색. **managed package version 2.15** 필요(Restore 탭 → Record Activity Date 섹션).
- **Back Up New Data On Demand** — **version 2.13**부터 on-demand backup(신규 데이터만 capture). How: policy menu → **Run Delta Backup**. 정기 daily backup은 **오후 5시 Central Time (GMT -05:00)** 유지.
- **Back Up Files and Attachments** — **version 2.13**부터 files/attachment backup(start date 선택, export·import 가능). Backup 탭 → Configure Policy Defaults에서 기본 설정 ON.
- **Control Formula Field Data Backups at the Object Level** — object별 formula field data backup 제어(기존엔 global 설정).

> [!note] 시각 자료 경고 — Salesforce Backup 탭 화면(p.692–693)은 PDF 스크린샷이며 pdftotext로 미추출. 위 항목은 텍스트 단서만 기재한다.

### Salesforce Shield — Event Monitoring

- **See Detailed Information About Unusual Guest User Activity with the Guest User Anomaly Event** — Experience Cloud guest user의 aura controller 통한 악의적 추출을 **Guest User Anomaly Event**(Threat Detection app)로 탐지. Who: Salesforce Shield 또는 Event Monitoring add-on.
- **Access and Download Event Log File Data with the Event Log File Browser (Beta)** — Setup의 **Event Log File Browser (beta)**로 ELF 데이터 탐색/다운로드(날짜 범위 선택 → Download as CSV File). 또는 File Download servlet 사용:

```
/servlet/servlet.FileDownload?file=<ELF_ID_NUMBER>
https://mycompany.my.salesforce.com/servlet/servlet.FileDownload?file=0ATRM000000dcbH0A0
```

- **Monitor Custom Component Usage with Custom Component Instrumentation API (Generally Available)** — **Enable Lightning Logger Events** ON으로 custom component data 접근·상호작용·성능 모니터링. Lightning Logger event는 API에만 있고 Event Monitoring Analytics app엔 없음(Event Monitoring Settings).
- **Query 1 Year's Worth of Event Log File Data** — Government Cloud 고객이 **Query Background Event Log Files** permission(Salesforce CSIRT가 활성화)으로 1년치 ELF data를 query. 1개월 초과 데이터는 permission 없으면 숨김.
- **Generate Event Log Files by Default** — Government Cloud 고객은 **Generate event log files** 설정 기본 활성화(Event Monitoring Settings).

### Salesforce Shield — Platform Encryption

- **Use External Key Management in All Commercial Zones** (IdeaExchange Delivered) — Shield Platform Encryption **External Key Management (EKM)** 서비스가 **모든 commercial zone**에서 가용. AWS KMS와 secure connection을 맺고 Salesforce가 AWS KMS의 key로 암호화/복호화한다. EKM key pair는 standard/custom field·CRM Analytics data·search index·event bus data를 암호화. Who: Salesforce Shield 또는 Shield Platform Encryption + Cache-Only Key Service add-on.
- **Configure Your Encryption Policy with Fewer Clicks** — 신규 **Encryption Settings** 페이지가 모든 encryption policy + advanced customization 설정을 통합(기존 Advanced Settings + Encryption Policy 페이지 분리). Encryption Policy 섹션(data store), Advanced Encryption Settings 섹션(개별 field 등).
- **Enjoy Clearer Names for Probabilistic and Deterministic Tenant Secrets** — tenant secret 명칭 변경: **Fields and Files (Probabilistic)**, **Fields (Deterministic)**. 기능은 불변이며 **TenantSecret Type field의 API 값도 불변**(자동화 프로세스 보존).
- **Encrypt Financial Account Name and Number in Automotive Cloud** — Financial Account 객체의 **Name·Financial Account Number** field 암호화(probabilistic·case-sensitive deterministic·case-insensitive deterministic). Where: Vehicle and Asset Finance enabled.
- **Encrypt Grantmaking Compliant Data Sharing Comments** — **Funding Opportunity Participant** 객체의 **Comments** field 암호화(3가지 scheme). Where: Grantmaking enabled.
- **Encrypt Nonprofit Cloud Payment Information** — **Payment Instrument** 객체의 **Bank Account Number** + **Gift Entry** 객체의 **Last 4·Expiry Month·Expiry Year** field 암호화(3가지 scheme). Where: Nonprofit Cloud enabled.
- **Encrypt Applicant and Application Form Fields** — **Application Form** 객체의 **Submission Date**, **Applicant** 객체의 **Email·First Name·Last Name·Middle Name·Prefix·Suffix·Birth Date·Phone·Unique Reference Number** field 암호화. Where: Financial Services Cloud enabled.
- **Encrypt Fields Used to Train Generative AI Models** — **AINtrlLangProcChunkRslt**(AI Natural Language Process Chunk Result)·**AINaturalLangProcessRslt**(AI Natural Language Process Result) 객체의 **Response·Additional Information** field 암호화(probabilistic). Who: Contracts AI 또는 NLP Insights product + Shield/Shield Platform Encryption add-on.

### Security Center

> 공통 조건: Enterprise/Performance/Unlimited/Developer, Security Center add-on subscription.

- **Review Guest User Anomaly Threat Detection Data in Security Center** — Threat Detection app에서 guest user threat 데이터 평가(Summary 페이지 → Threat Detection / Monitoring 카테고리).
- **Benefit from More Relevant Information in Security Center** — 권한 관련 탭만 표시, session-based permission set 표시, Managed Package metric의 정확한 설치 정보.
- **Monitor Additional System Permissions** — 신규 system permission 모니터링: **API Only User Access·Access Data Cloud Data Explorer·Allows User Access Data Cloud·Allows User Access Data Cloud Setup Menu**(Security Center dashboard → Permissions 카테고리).

### Other Security Changes

- **Update Your Content Security Policy (CSP) for Upcoming Changes** — Salesforce가 **Winter '25**에 system-defined trusted URL을 업데이트한다(XSS 방지). 신규 **CSP Violations** list로 영향받는 CSP directive 검토. 배포: sandbox **2024년 8월**, production **2024년 9월**. How: Setup → CSP Violations → Manage Trusted URLs.
- **Allow Only Trusted Cross-Org Redirections (Release Update)** — 다른 Salesforce org로의 redirection 제한. 신뢰 org URL을 **Trusted URLs for Redirects** allowlist에 추가. **Winter '24 최초 제공, Summer '24 enforce.** Winter '24를 2023년 10월 이전 받은 org은 기본 활성화. How: Trusted URLs for Redirects → "Allow untrusted cross-org redirections" 비활성화(Lightning만), 또는 SecuritySettings metadata의 `enableCrossOrgRedirects` = false.
- **Enter New Firebase Information for Android Push Notifications** — Android mobile connected app이 Firebase project의 **Admin SDK private key + project ID**를 수집. Where: Group/Professional/Enterprise/Essentials/Performance/Unlimited/Developer.
- **XSS Protection Setting Was Removed** — HTTP **X-XSS-Protection** 헤더 deprecated로 **Enable XSS Protection** 설정을 Session Settings 및 Health Check에서 제거. 대신 Trusted URLs의 CSP directive를 구성한다. (Trusted URLs는 Enterprise/Performance/Developer/Unlimited.)

---

## Mobile (p.506–518)

> 신규 Salesforce mobile app은 Database.com 제외 모든 edition에서 추가 라이선스 없이 제공. 대부분 기능은 **2024년 2월 12일 주**부터 가용.

### Salesforce Mobile App

- **Streamline Everyday Activities with Einstein Copilot on the Salesforce Mobile App** — Einstein에 record 요약·이메일 초안·관련 record 표시·custom Copilot action 실행을 요청. iOS는 Siri/Dictation 음성 명령 가능. Where: Salesforce mobile app(iOS/Android), Enterprise/Performance/Unlimited(Einstein for Sales/Service 또는 Einstein Platform add-on). Einstein Copilot Setup은 desktop.
- **Generate Content on Record Pages with the Salesforce Mobile App** — field generation prompt template로 field description 등 콘텐츠 생성. How: Field Generation prompt template 추가 → Dynamic Forms on Mobile 활성화 → Lightning page 활성화 → prompt를 field에 할당 → 저장. When: **2024년 3월 10일 주**.
- **Salesforce Mobile App Requirements Have Changed** — 플랫폼 요건: **Android 10.0 이상**, **iOS 16.0 이상**. Spring '24 테스트 기기:
  - Android phones: Pixel 6/6 Pro, Pixel 7/7 Pro, Samsung Galaxy S20/S20+, S10/S10e/S10+, Note 10+, Note 9, S9, S21, S22/S22 Ultra
  - Android tablets: Samsung Galaxy Tab S6, Tab S7, Tab A (8 inch)
  - iOS phones: iPhone 15/15 Plus, 15 Pro/Pro Max, 14 Pro/Pro Max, 14/14 Plus, 13 Pro/Pro Max, 13, 12 Pro/Pro Max, 12, 11 Pro/Pro Max, 11, X, 8, XR, SE
  - iOS tablets: iPad Pro (10.5–12.9 inch), iPad Pro (9.7 inch, 6th gen 이후), iPad Air 3rd Gen, iPad Mini 5th Gen
- **Save Dashboard Views on Your Mobile Devices** — 신규 Save View 기능으로 mobile에서 dashboard view 저장. Where: Professional/Developer/Enterprise/Unlimited. When: **2024년 2월 12일 주**.
- **Uncover Answers to Business Questions with Data Cloud Reports** — single/multiple DMO 또는 Calculated Insights 표준 report를 mobile에서 group/filter/summarize/실행/공유. Where: Professional/Developer/Enterprise/Unlimited.

### Mobile Offline (Salesforce Mobile App Plus)

- **Easily Configure Offline Landing Pages with Mobile Builder (beta)** — 신규 **Mobile Builder for Salesforce Mobile App (beta)**로 code 없이 offline landing page 커스텀. Who: Salesforce Mobile App Plus 라이선스 + **Mobile Offline for Salesforce Mobile App Plus** user permission. How: Setup → Quick Find "Mobile Builder" → Mobile Builder for Salesforce Mobile App. Where: all editions(Database.com 제외).
- **Offline App Onboarding Wizard v2 Enhancements** — preconfigured landing page template 선택 + sObject LWC quick action 생성 가이드. Who: Salesforce Mobile App Plus 라이선스 + **OfflineForMobilePlus** user permission. How: **Salesforce Offline App Onboarding Wizard Visual Studio Code Extension** 다운로드(또는 VS Code Extensions에서 "Salesforce Offline Starter Kit Wizard" 검색 후 Install).
- **Offline App Developer Starter Kit Enhancements** — predefined LWC code sample 포함(각 sample은 docs 폴더에 .md 파일). 샘플: **Offline Lookups·Related Records·Barcode Scanner·Custom Object**.
- **Defined Global Actions Now Primed for Offline Use** — Actions card의 global action이 offline 사용 가능.
- **Better Error Handling When Quick Actions Haven't Been Deployed** — briefcase 설정 객체에 quick action 미배포 시 오류 메시지.

### Mobile Publisher

- **Avoid Disrupting Your Mobile Publisher Android App's Push Notifications** — Google의 Android push 처리 변경으로 Mobile Publisher가 Firebase project 정보를 요구한다. **Firebase Admin SDK private key + Firebase config file**을 Setup for Mobile Publisher에 업로드. Where: Mobile Publisher Android apps(all app versions). Setup은 Enterprise/Performance/Unlimited.
- **Add Biometric ID Checks for Mobile Publisher for Experience Cloud App Features** — **BiometricsService API (Nimbus plugin)** 사용 LWC로 biometric ID check 프롬프트. device 로컬 검증이며 서비스 인증은 아니다(web·desktop 미지원). Where: Android/iOS **app version 12.0 이상**.
- **Set the Default Method for How Your Mobile Publisher for Experience Cloud App Opens URLs (Beta)** — in-app web view / in-app browser / external browser / cookie 공유 in-app browser 중 선택, 예외 URL별 method 지정. 기존 pilot → 이제 **beta**(Setup for Mobile Publisher project → **URL Management** 섹션). Where: Aura/LWR sites, Enterprise/Performance/Unlimited/Developer.

### Briefcase Builder

- **View All Rules and Filters on a Briefcase** — briefcase 상세에서 모든 rule expand/collapse(Data Sets/Run As User 탭에 **Expand All / Collapse All** 버튼). Where: Field Service(SFS) enabled. (Setup → Quick Find "Briefcase Builder")

### General Mobile Updates

- **Update Your Android Mobile Connected App's Information for Push Notifications** — Android mobile connected app이 Google Firebase project에서 **Admin SDK private key + project ID**를 수집. 신규 **Firebase Cloud Messaging API (HTTP v1)** 요구. App Manager에서 정보 제출. Where: Group/Professional/Enterprise/Essentials/Performance/Unlimited/Developer.

---

## Hyperforce (p.357–358)

- **Access Salesforce in More Regions with Hyperforce [GA]** — Salesforce Customer 360 application suite(Sales Cloud·Service Cloud·B2B Commerce·Platform·Industries Cloud)가 **신규로 South Korea(한국)·Sweden(스웨덴)**에서 제공된다. 기존 제공 리전: Australia·Canada·France·Germany·India·Indonesia·Italy·Japan·Singapore·United Kingdom·United States. **by request only: Switzerland·United Arab Emirates.**
- **Migrate to Hyperforce with Hyperforce Assistant (Generally Available)** — Hyperforce Assistant가 production/sandbox org 대상으로 **GA**. Prepare 페이지가 Salesforce Optimizer tool 안내, IP allowlist 섹션에 **mTLS 또는 2-way SSL with IP domain** 권장 추가, Marketing Cloud connection 섹션의 최신 제품명 업데이트. How: Setup → Quick Find "Hyperforce Assistant" → Hyperforce Assistant. Where: all editions.

> [!warning] 시각 자료/표 경고 — Hyperforce 제품별 가용 리전 표(p.357–358, 4컬럼: Cloud / Product or Feature / Description / Available In)는 pdftotext가 column 순서와 Description·Available In 값을 섞어 출력하여 셀별 매핑을 신뢰할 수 없다. 본 노트는 산문(위 GA 항목)에서 verbatim 확인된 리전 목록만 기재하며, 제품×리전 매트릭스는 **재현하지 않는다**(fabricate 금지). 정확한 제품별 가용 리전은 원본 PDF 표를 직접 확인할 것.

---

## Architecture / 인프라 (Development 섹션 발췌)

> 아래 항목은 PDF의 Development 섹션에 위치하나 플랫폼 인프라·메타데이터·이벤트 성격으로 본 노트에서 다룬다.

### Metadata API

- **Deploy and Retrieve More Metadata via REST and SOAP Metadata API** — SOAP retrieve / REST deployment의 **maximum uncompressed folder size가 400 MB → 600 MB**로 증가. Where: **all API versions.**

### Packaging

- **Remove Custom Metadata Type Records from a Second-Generation Managed Package** (IdeaExchange Delivered) — managed 2GP에서 custom metadata type의 protected/public record를 제거할 수 있다. 제거 후 subscriber org 동작: subscriber에게 visible이면 **deprecated 마킹**, invisible이면 **삭제**. deprecated record는 subscriber org limit에 계산되므로 삭제가 권장된다. How: managed package에서 metadata 제거는 **Salesforce 승인 필요** — Salesforce Partner Community에 support case 등록. Where: second-generation managed packages.

### Development Environments

- **Capture a Scratch Org's Configuration with Scratch Org Snapshots (Beta)** — scratch org configuration의 snapshot(= point-in-time copy)을 capture하여 scratch org replica를 생성. Dev Hub org이 Spring '24로 업그레이드 시 가용. How: Dev Hub org에서 **Scratch Org Snapshots** 활성화 후 Salesforce CLI로 관리:

```
sf org create snapshot
sf org list snapshot
```

> 위 CLI 명령은 PDF가 명시한 토픽 `org create snapshot`·`org list snapshot`이다(`sf` 접두는 표준 Salesforce CLI 호출 형식). Where: Developer/Enterprise/Performance/Unlimited.

### Event-Driven (Pub/Sub API)

- **Manage Your Event Subscriptions with Pub/Sub API (Beta)** — **managed event subscription**으로 consumed event를 추적하고 client 연결이 끊긴 후 재개한다. 신규 **ManagedSubscribe RPC method**가 resubscribe 시 마지막 commit된 Replay ID 이후부터 재개. platform event·change event·custom platform event channel·change data capture channel·표준 CDC channel(**ChangeEvents**)을 구독. configuration은 Tooling API 또는 Metadata API의 **ManagedEventSubscription**으로 설정. Where: Enterprise/Performance/Unlimited/Developer. **Pub/Sub API는 Non-Hyperforce Public Cloud 및 Government Cloud 미제공.** When: Spring '24 이후 가용.

```protobuf
// verbatim (PDF line 11680)
rpc ManagedSubscribe (stream ManagedFetchRequest) returns (stream ManagedFetchResponse)
```

  - 신규 Protobuf message: **ManagedFetchRequest·ManagedFetchResponse·CommitReplayRequest·CommitReplayResponse.** client는 ManagedEventSubscription ID로 ManagedSubscribe를 호출하며, subscription ID는 client별 고유로 동일 org 다른 client와 공유 불가. pull-based — client가 ManagedFetchRequest에 요청 event 수를 지정하고 ManagedFetchResponse로 반환받으며, Replay ID commit은 ManagedFetchRequest의 CommitReplayRequest field로 설정한다.
- **Expanded Regional Processing for the Pub/Sub API Global Endpoint** — global endpoint `api.pubsub.salesforce.com:{port}`에 **신규 India region** 추가(기존 United States·European Union). **Government Cloud 미제공.**
- **Expanded Regional Processing for Event Relays** — Event Relay 서비스가 **신규 European Union region** 처리(기존 United States만). **Government Cloud 미제공.** Where: Enterprise/Unlimited/Developer.

---

## 관련 노트

- [[Spring '24]] — Spring '24 릴리즈 허브
- [[Release MOC]] — 전체 릴리즈 목차
- [[Spring '24/Release Updates]] — enforce 시점 단일 권위 출처
