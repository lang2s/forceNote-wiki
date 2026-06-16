---
tags: [release, winter_24, platform, admin, security, mobile, hyperforce]
source: salesforce_winter24_release_notes.pdf
created: 2026-06-16
aliases: [Winter '24 Platform, 윈터 24 플랫폼, Admin Security Enhanced Domains MFA Hyperforce, Enhanced Domains 강제, Enhanced Domains enforcement, MFA 자동 활성화, Named Credentials JWT, Dynamic Forms 표준 객체, Hyperforce Assistant GA]
---

# Winter '24 — Platform (Salesforce Overall · Customization/Admin · Security/Identity · Mobile · Hyperforce)

> 허브: [[Winter '24]]
> Winter '24(API v59.0) 플랫폼 영역 — Salesforce Overall(MFA 자동 활성화 3단계·Summer '24 강제 시작·새 Setup 도메인)·Customization(Dynamic Forms on LWC-Enabled Standard Objects·모바일 Dynamic Forms GA·User Access Policy Beta)·Security(Enhanced Domains 강제 적용·Named Credentials JWT/Client Credentials·Headless Identity·Shield·Event Monitoring 신규 event type)·Mobile·Hyperforce(Hyperforce Assistant GA).

---

## 개요

이 노트는 Winter '24 릴리즈 노트의 **플랫폼 영역**(Salesforce Overall · Customization/Admin · Security, Identity & Privacy · Mobile · Hyperforce)을 정리한 spoke다. enforce 시점이 있는 Release Update는 → [[Winter '24/Release Updates]]도 함께 참조한다.

> 범례: **GA**=Generally Available · **Beta** · **Pilot** · **RU**=Release Update · **변경**=Enhancement

---

## Salesforce Overall

### MFA — 자동 활성화 3단계 + Summer '24 강제 시작

(verbatim) *"As of February 1, 2022, users are contractually required to use MFA when they access Salesforce orgs… Salesforce is automatically enabling MFA for direct logins to production orgs in several phases. The process started with Spring '23 and concludes with Spring '24. Enforcement… is scheduled to begin with Summer '24."*

**MFA Auto-Enablement Continues (Release Update)** (verbatim): *"With Winter '24, MFA is auto-enabled for the third phase of orgs. The final phase in Spring '24 includes all orgs that weren't previously auto-enabled."*

- 자동 활성화: Spring '23 시작 → **Winter '24 = 3번째 phase** → Spring '24 = 마지막 phase(이전에 자동 활성화되지 않은 모든 org).
- **강제(enforcement)는 Summer '24에 시작 예정.** (Winter '24는 강제가 아니라 자동 활성화 3단계임에 유의.)
- 관련: U2F Security Key를 WebAuthn 인증으로 업데이트(Summer '22 이전 등록된 U2F key는 Winter '24 전에 로그인 필요).

### 그 외 Salesforce Overall

- **See Improved Color Contrast in UI Elements** — Winter '24에 모든 Lightning Experience 페이지.
- **Set a Password or Expiration Date on a Public Link to a Salesforce File** — link expiration 기본 활성화, 30일.
- **News, Automated Account Fields, and Account Logos Are Being Retired** — 2023년 10월 13일.
- **Disable Keyboard Shortcuts.**
- **Experience Improved Performance on More Record Home Pages** — 더 많은 LWC-enabled object.
- **Create From Lookup Changes; Other Changes to Record Pages.**
- **Prepare for the New Setup Domain** — allowlist에 `*.salesforce-setup.com` 추가.

---

## Customization / Admin

### Dynamic Forms on LWC-Enabled Standard Objects

(verbatim) *"Dynamic Forms is now supported on hundreds of LWC-enabled standard objects. Dynamic Forms gives you a streamlined admin experience, enhanced page performance, and the option of visibility rules… until now, you could use Dynamic Forms only on custom objects and a limited number of standard objects."*

- **Where:** Group, Professional, Enterprise, Performance, Unlimited, Developer editions.
- **How:** 대부분의(전부는 아닌) standard LWC-enabled object에서 지원(Fields 탭이 없으면 미지원 — 예: Note는 고정 레이아웃). non-LWC-enabled object(Campaign·Product·Task)는 여전히 page layout 사용.

> ⚠️ **표기 주의:** PDF는 **"hundreds of LWC-enabled standard objects"**라고만 한다 — "300+"나 "300"이라는 표현은 PDF에 없다. 또한 이 standard-objects 기능 자체에는 "(Generally Available)" 라벨이 붙지 않는다. GA 라벨은 아래 **모바일** Dynamic Forms 기능에 붙는다.

### Give Your Mobile Users the Dynamic Forms Experience (GA)

(verbatim) *"Dynamic Forms on Mobile was offered as a beta feature for use with limited objects in Summer '23. It's now generally available on all Dynamic Forms-supported objects."* **GA.** Group/Professional/Enterprise/Performance/Unlimited/Developer.

- **How:** Salesforce Mobile App Setup → Dynamic Forms on Mobile 활성화. 업그레이드된 페이지에서 `Record Detail - Mobile` 컴포넌트 제거.
- (모바일 챕터에서 **Enable Dynamic Forms on Mobile (Generally Available)** 로도 등장.)

### Permission Set / User Access 관리

- **See the Count of Permission Set Groups a Permission Set Is Added To / See What's Enabled in a Permission Set More Easily (Beta)** — Permission Set 페이지에 "Permission Set Groups Added To" 필드, "View Summary (Beta)"가 그룹 목록 표시. **Beta.**
- **Automate and Migrate User Access with Improved User Access Policy Filters (Beta)** — **Beta.** user access policy filter에서 permission set/permission set group/managed package license를 **총 3개**까지 참조 가능(이전엔 각 1개). Enterprise + Unlimited. Setup → User Management Settings → Enable User Access Policies (Beta). 모든 filter를 충족하는 사용자에게만 정책 적용. Summer '23 전에 활성화했다면 재활성화 필요.

---

## Security · Identity · Privacy

### Enhanced Domains (Release Update) — Winter '24 강제 적용

(verbatim) *"…This update, originally named Enable Enhanced Domains, was first available in Summer '21 and is enforced in Winter '24."*

- enhanced domains를 사용하면 회사별 My Domain 이름이 Salesforce가 호스팅하는 URL에 포함되며, third-party cookie를 차단하는 브라우저에서도 사용자가 Salesforce에 접근할 수 있다.
- 이 업데이트는 application·login URL(Experience Cloud 사이트, Salesforce Sites, Visualforce 페이지 포함)에 영향을 미친다. 아직 배포하지 않았다면 org가 이 릴리즈를 받기 전에 배포할 것을 권장.
- **Where:** Group, Essentials, Professional, Enterprise, Performance, Unlimited, Developer editions.
- **When:** "first available in Summer '21 and is enforced in Winter '24."

**관련 도메인 항목:**
- **Notify Users During My Domain Redirections** — 새 URL로 redirect 전에 메시지 표시.
- **Prepare for the End of Some My Domain Redirections** — Salesforce는 이 hostname들의 redirection을 **Winter '25**에 중단한다(deployment는 sandbox 2024년 8월, production 2024년 9월 시작).

### Named Credentials

- **Authenticate Named Credential Callouts with Client Credentials Flow** — server-to-server용 OAuth 2.0 client credentials flow. external credential → OAuth 2.0 → "Client Credentials with Client Secret Flow" 또는 "Client Credentials with JWT Assertion Flow." Metadata·Tooling·Apex ConnectApi API로 사용 가능.
- **Use JWT Authentication Protocol with Named Credentials** — external credential용 JWT auth protocol. 서명 알고리즘 **RS256·RS512**; custom claim 정의; expiration time 지정.
- **Grant Permission to Manage Named Credentials and External Credentials** — 새 **Manage Named Credentials** admin permission(이전엔 Customize Applications).
- **Grant Guest Users Access to Make Callouts Using Named Credentials.**
- **Access Public Information with No Authentication Protocol** — protocol로 "No Authentication" 선택.

### Headless Identity / Identity & Access

- **Take Advantage of New and Improved Headless Identity Features** — guest user용 새 flow + passwordless login; 모든 Headless Identity flow에 reCAPTCHA Enterprise 옵션; headless registration handler용 Apex 클래스 템플릿; headless registration용 새 email template. LWR·Aura·Visualforce 사이트; Enterprise/Unlimited/Developer.
- **Streamline the Login Experience in Headless Apps** — Headless Passwordless Login Flow(email/phone → OTP).
- **Improve Authorization Flow Performance with JSON Web Token-Based Access Tokens (Generally Available)** — **GA.** connected app이 Salesforce REST API용 JWT 기반 access token을 발행. LWR/Aura/Visualforce 사이트; Enterprise/Performance/Unlimited/Developer. (Experience 노트에도 동일 기능 등장 → [[Winter '24/Clouds]])
- **Create and Distribute External Client Apps** — connected app의 차세대. 2GP managed packaging용 설계.
- **Update U2F Security Keys to Support WebAuthn Authentication** — Summer '22 이전 등록된 U2F key는 Winter '24 전에 로그인 필요.
- **SMS Identity Verification Is No Longer Available in Free Salesforce Orgs.**
- **Verify Email Addresses to Send Email Through Salesforce** — Spring '24에 SSO production org로 확대 예정.

### Shield Platform Encryption

- Connect to Third-Party Key Stores with External Key Management; Encrypt Consent Data; Encrypt Gift Entry Data; Encrypt Healthcare Provider Data; Manage Keys More Easily with an Improved UI; Encrypt Inputs for Flow Orchestration Work Items; Encrypt Grantmaking Compliant Data Sharing Comments. **New Shield Platform Encryption for Health Cloud.**

### Event Monitoring — 신규 event type

- **Group Membership** event type(EventLogFile) — public group·queue에 멤버 추가/제거.
- **Insufficient Access** event type(EventLogFile) — account/case/contact/opportunity 레코드 접근 오류.
- **Lightning Logger Event** type(EventLogFile) — custom Lightning component event(LWC Custom Component Instrumentation API Beta → [[Winter '24/Development]]).
- **Enjoy Efficient Dataset Updates in the Event Monitoring Analytics App (Generally Available)** — **GA.**
- View Knowledge Article Event Data in Event Monitoring Analytics Apps; See More Informative Column Header Log Data; Spot Event Monitoring Analytics App Datasets with User Ids.

### Security Center

- Customize Security Center Tenant Name; View Tenant Instance Names; Get Insight Into License Usage Information for Tenants; Monitor Login IP Ranges.
- 그 외: **Allow Only Trusted Cross-Org Redirections (Release Update** → [[Winter '24/Release Updates]]); Secure Access to Your Users' Camera and Microphone; Protect More Users from Clickjacking.

### Privacy Center

- **Privacy Policies on Core; Privacy Center App; Privacy Holds for Sensitive Data.** Privacy Center는 privacy policy·hold·data-subject request를 위한 managed package/새 앱이다. (상세 페이지는 이미지 위주라 텍스트가 제한적.)

---

## Hyperforce

- **Migrate to Hyperforce with Hyperforce Assistant (Generally Available)** — **GA.**

---

## Mobile

- **Enable Dynamic Forms on Mobile (Generally Available)** — **GA**(위 Customization과 동일 기능).
- **Salesforce Mobile App Plus** — Briefcase search, swipe action, Landing Page의 list filter, 빠른 address 구성.
- **Mobile Publisher for Experience Cloud** — default URL 동작, location 기반 permission/push. Briefcase Builder custom metadata type.
- **Set the Default Method for How Your Mobile Publisher for Experience Cloud App Opens URLs (Pilot)** — **Pilot**(이전에 GA로 발표됐다가 pilot으로 변경됨).

---

## 동작 예시 (구조 참고)

```text
// 구조 예시 — 실제 PDF 다이어그램 아님
// MFA 단계: 자동 활성화(auto-enable) vs 강제(enforcement) 분리
자동 활성화 phase :  Spring '23(시작) … Winter '24(3rd phase) … Spring '24(final phase)
강제(enforcement) :  Summer '24 시작 예정
주의: Winter '24는 "강제"가 아니라 "자동 활성화 3단계"다.
```

> 위 타임라인은 MFA의 auto-enable과 enforcement를 구분하기 위한 구조 예시다. PDF의 실제 다이어그램이 아니다.

---

## 기타 (footnote)

- **Legal Terms / Other Salesforce Products and Services (Heroku·IdeaExchange)** — Winter '24 릴리즈 노트의 이 섹션들은 거의 빈 내용(near-empty)으로, 별도 spoke를 만들지 않는다. Heroku는 Heroku Changelog, IdeaExchange는 IdeaExchange 페이지를 참조.

---

## 관련 노트

- [[Winter '24]] — 상위 릴리즈 허브
- [[Winter '24/Development]] — Event Monitoring Lightning Logger Event와 연결되는 LWC Custom Component Instrumentation API
- [[Winter '24/Clouds]] — Experience Cloud의 JWT access token·Headless Identity 맥락
- [[Winter '24/Clouds-Industries]] — Shield Platform Encryption for Health Cloud 등 산업 보안
- [[Winter '24/Release Updates]] — Enhanced Domains·CSRF·MFA·Cross-Org Redirection 등 강제 적용 시점 맵
- [[Release MOC]]
