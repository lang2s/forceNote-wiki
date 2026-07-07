---
tags: [salesforce, integration, oauth, connected-app, external-client-app, setup, field-reference, security]
source: developer.salesforce.com — Metadata API ConnectedApp (meta_connectedapp.htm, Tier 2)·ExtlClntAppOauthSettings (meta_extlclntappoauthsettings.htm, Tier 2)·ExtlClntAppOauthConfigurablePolicies (meta_extlclntappoauthconfigurablepolicies.htm, Tier 2); developer.salesforce.com — OAuth Scope Parameter Values (Mobile SDK, oauth-scope-parameter-values, Tier 2); help.salesforce.com — Enable OAuth Settings for API Integration (connected_app_create_api_integration)·Manage OAuth Access Policies (connected_app_manage_oauth)·Configure the External Client App OAuth Settings (configure_external_client_app_oauth_settings), Tier 2
created: 2026-07-07
aliases: [Connected App 생성 필드, External Client App 생성 필드, OAuth 클라이언트 필드 카탈로그, Enable OAuth Settings 필드, Selected OAuth Scopes 목록, Callback URL, Require Secret for Web Server Flow, Require PKCE, Permitted Users, IP Relaxation, Refresh Token Policy, ExtlClntAppOauthSettings 필드, ExtlClntAppGlobalOauthSettings, ExtlClntAppOauthConfigurablePolicies]
---

# OAuth 클라이언트(Connected App·External Client App) 생성 필드 전수 레퍼런스

> Setup에서 Connected App / External Client App을 OAuth 클라이언트로 만들 때 화면에 나오는 **모든 입력·선택·체크박스 필드**를 scope 목록·정책 값까지 빠짐없이 카탈로그화한 필드 레퍼런스. 개념은 [[Connected App (연결된 앱) — OAuth 클라이언트]]·[[External Client App (외부 클라이언트 앱)]]로, 구축 절차는 플로우별 가이드로 위임하고, 이 노트는 "무슨 칸을 채우나"만 다룬다.

---

## 이 노트의 범위와 매핑 원칙

Setup UI의 필드 라벨은 **Metadata API 타입의 필드/enum과 대응**한다. 아래 표는 UI 라벨(사람이 보는 이름)과 Metadata 필드(배포·API명)를 함께 실어 어느 쪽에서 봐도 찾을 수 있게 했다. Connected App은 `ConnectedApp` 한 타입에 OAuth 설정(`oauthConfig`)·정책(`oauthPolicy`)·세션(`sessionPolicy`)이 모두 들어가고, External Client App은 **개발자 설정과 관리자 정책을 별도 메타데이터 파일로 분리**한다.

> 근거: [ConnectedApp (Metadata API)](https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_connectedapp.htm) · [ExtlClntAppOauthSettings](https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_extlclntappoauthsettings.htm) · [ExtlClntAppOauthConfigurablePolicies](https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_extlclntappoauthconfigurablepolicies.htm) · [OAuth Scope Parameter Values](https://developer.salesforce.com/docs/platform/mobile-sdk/guide/oauth-scope-parameter-values.html)

```
// 구조 예시 — 실제 원본 다이어그램 아님
Connected App (1 메타데이터):        External Client App (3 메타데이터 분리):
  ConnectedApp                          ExternalClientApplication   ← 컨테이너(이름·연락처)
   ├ oauthConfig  (OAuth 설정)          ExtlClntAppGlobalOauthSettings ← Consumer Key/Secret(전역)
   ├ oauthPolicy  (접근 정책)           ExtlClntAppOauthSettings    ← 개발자 OAuth 설정(Callback·Scope·플래그)
   └ sessionPolicy(세션 정책)           ExtlClntAppOauthConfigurablePolicies ← 관리자 정책(Permitted Users·IP·Refresh)
   설정+정책이 한 파일             →   설정(개발자) ↔ 정책(관리자) 파일 분리 + 2GP 패키징
```

> ⚠️ **Spring '26부터 신규 Connected App 생성 차단** → 새 통합은 External Client App이 권장 경로. Connected App 필드는 기존 앱 유지·이해용으로 여전히 유효. (근거: [[External Client App (외부 클라이언트 앱)]])

---

## 1. Connected App — 기본 정보(Basic Information) 필드

Setup → App Manager → **New Connected App**(또는 New External Client App). 상단 Basic Information 섹션.

| # | UI 필드 | 유형 | 필수 | 값/옵션 | 의미 | Metadata (`ConnectedApp`) |
|---|---|---|---|---|---|---|
| 1 | **Connected App Name** | 텍스트 입력 | ✅ | 자유 문자열 | 화면 표시명(Label) | `label` |
| 2 | **API Name** | 텍스트 입력 | ✅ | 영숫자+`_` | Developer/API명. 저장 시 Name에서 자동 생성 | (fullName) |
| 3 | **Contact Email** | 텍스트 입력 | ✅ | 이메일 주소 | Salesforce가 앱/지원팀에 연락할 주소 | `contactEmail` |
| 4 | **Contact Phone** | 텍스트 입력 | 선택 | 전화번호 | 지원 연락처 | `contactPhone` |
| 5 | **Logo Image URL** | 텍스트/업로드 | 선택 | HTTPS URL (최대 125×200px) | 승인 화면에 뜨는 앱 로고 | `logoUrl` |
| 6 | **Icon URL** | 텍스트/선택 | 선택 | HTTPS URL | 앱 아이콘 | (logoUrl 계열) |
| 7 | **Info URL** | 텍스트 입력 | 선택 | URL | 앱 정보 안내 웹페이지 | `infoUrl` |
| 8 | **Description** | 텍스트 영역 | 선택 | 자유 문자열 | 앱 설명 | `description` |
| 9 | **Start URL** | 텍스트 입력 | 선택 | URL | 인증 후 (비모바일) 사용자 이동 URL | `startUrl` |
| 10 | **Mobile Start URL** | 텍스트 입력 | 선택 | URL | 인증 후 (모바일) 사용자 이동 URL | `mobileStartUrl` |

---

## 2. Connected App — API (Enable OAuth Settings) 섹션 필드

핵심 섹션. **Enable OAuth Settings** 체크박스를 켜야 나머지 OAuth 필드가 나타난다. 각 체크박스는 특정 OAuth 플로우를 열거나 보안 요건을 강제한다.

| # | UI 필드 | 유형 | 필수 | 값/옵션 | on/off 효과 | Metadata (`oauthConfig`) |
|---|---|---|---|---|---|---|
| 1 | **Enable OAuth Settings** | 체크박스 | — | on/off | **on**: 이 앱을 OAuth 클라이언트로 사용(아래 필드 노출). off면 OAuth 미사용 | (섹션 게이트) |
| 2 | **Callback URL** | 텍스트 영역(다중) | ✅ | 줄바꿈 구분 여러 `https://…` | OAuth redirect URI. authorization code 플로우에서 인증 후 브라우저가 리다이렉트될 엔드포인트(들) | `callbackUrl` |
| 3 | **Use digital signatures** | 체크박스 + 인증서 업로드 | 선택 | 인증서(.crt) | **on**: JWT Bearer 플로우용 인증서 등록(서명 검증) | `certificate` |
| 4 | **Selected OAuth Scopes** | 이중 리스트(Available→Selected) | ✅ | 아래 [3. Scope 전수](#3-selected-oauth-scopes-전수-scopes) | 발급 토큰에 부여할 권한 범위 | `scopes` (`ConnectedAppOauthAccessScope[]`) |
| 5 | **Require Secret for Web Server Flow** | 체크박스 | — | on/off (기본 on) | **on**: web server(authorization code) 플로우에서 access token 교환 시 client secret 필수. **off**(`isConsumerSecretOptional=true`): secret 없이 교환 가능(secret 보관 불가한 public client용) | `isConsumerSecretOptional` (true=off) |
| 6 | **Require Secret for Refresh Token Flow** | 체크박스 | — | on/off (기본 on) | **on**(`isSecretRequiredForRefreshToken=true`): refresh token으로 access token 갱신 시 client secret 필수(web-server 앱 권장). off면 secret 없이 갱신 | `isSecretRequiredForRefreshToken` |
| 7 | **Enable Client Credentials Flow** | 체크박스 | — | on/off (기본 off) | **on**: 사용자 컨텍스트 없는 서버-투-서버 client credentials 플로우 허용. 실행 사용자(`Run As`) 지정 필요 | `isClientCredentialEnabled` (+ `oauthClientCredentialUser`) |
| 8 | **Enable Authorization Code and Credentials Flow** | 체크박스 | — | on/off (기본 off) | **on**: headless identity(headless registration·passwordless login 등)용 Authorization Code and Credentials 플로우 허용 | `isCodeCredentialEnabled` (+ `isCodeCredentialPostOnly`) |
| 9 | **Require Proof Key for Code Exchange (PKCE) Extension for Supported Authorization Flows** | 체크박스 | — | on/off (기본 off·권장 on) | **on**: web server·hybrid·Authorization Code and Credentials 등 모든 지원 authorization code 변형에 PKCE 강제(public client 보안 권장) | `isPkceRequired` |
| 10 | **Enable Token Exchange Flow** | 체크박스 | — | on/off (기본 off) | **on**: 외부 IdP 토큰을 Salesforce 토큰으로 교환하는 OAuth 2.0 token exchange 플로우 허용. secret 요건은 별 플래그 | `isTokenExchangeEnabled` (+ `isSecretRequiredForTokenExchange`) |
| 11 | **Enable Refresh Token Rotation** | 체크박스 | — | on/off | **on**: refresh 플로우마다 새 refresh token 발급, 기존 것 자동 무효화 | `isRefreshTokenRotationEnabled` |
| 12 | **Issue JSON Web Token (JWT)-based access tokens** | 체크박스 | — | on/off (기본 off) | **on**: opaque 대신 JWT 형식 access token 발급(named-user) | `isNamedUserJwtEnabled` |
| 13 | **Introspect All Tokens** | 체크박스 | — | on/off | **on**: 이 앱이 org 전체의 모든 access/refresh token을 introspect(조회)하도록 인가 | `isIntrospectAllTokens` |
| 14 | **Configure ID Token** (섹션) | 체크박스+필드 | 선택 | Include Attributes·Custom Permissions·Standard Claims·Token Valid for(분) | OpenID Connect ID token 구성(attributes·custom perms·유효기간 1–720분, 기본 2) | `idTokenConfig` (`ConnectedAppOauthIdToken`) |
| 15 | **Include Asset Token in OAuth flows** (Asset Token) | 체크박스+필드 | 선택 | Audiences·Signing Certificate·Validity(초)·Include Attributes/Custom Perms | 자산(IoT 등) 토큰 발급 구성 | `assetTokenConfig` (`connectedAppOauthAssetToken`) |

> Enable OAuth Settings와 별개로 **Enable SAML**(SSO), **Enable for Device Flow**, **Enable Asset Tokens** 같은 추가 스위치가 앱 유형·라이선스에 따라 나타날 수 있다. SAML은 `samlConfig`(`ConnectedAppSamlConfig`)로 매핑.

---

## 3. Selected OAuth Scopes 전수 (`scopes`)

**Selected OAuth Scopes** 이중 리스트에서 고를 수 있는 전체 scope. UI 라벨(괄호 안이 실제 scope 파라미터 값) ↔ Metadata enum(`ConnectedAppOauthAccessScope`) 대응. (근거: OAuth Scope Parameter Values, ConnectedApp Metadata.)

| UI 라벨 | scope 파라미터 값 | Metadata enum | 의미 |
|---|---|---|---|
| **Full access** | `full` | `Full` | 로그인 사용자가 접근 가능한 모든 데이터(다른 scope는 이 상위집합의 부분). refresh_token은 별도 필요 |
| **Manage user data via APIs** | `api` | `Api` | REST·SOAP·Bulk 등 API로 데이터 접근·관리 |
| **Manage user data via Web browsers** | `web` | `Web` | 발급 access token을 웹 브라우저에서 사용(`web`) |
| **Perform requests at any time** | `refresh_token`, `offline_access` | `RefreshToken` | refresh token 발급 → 오프라인·재인증 없이 지속 접근 |
| **Access unique user identifiers** | `openid` | `OpenID` | OpenID Connect — user identity URL(고유 식별자) |
| **Access the identity URL service** | `id`, `profile`, `email`, `address`, `phone` | `Basic` | Identity URL 서비스(기본 프로필·이메일·주소·전화 클레임) |
| **Access custom permissions** | `custom_permissions` | `CustomPermissions` | 앱에 연결된 custom permission 노출 |
| **Access Connect REST API resources** | `chatter_api` | `Chatter` | Connect(Chatter) REST API |
| **Access content resources** | `content` | `Content` | 콘텐츠(Files) 리소스 |
| **Access Lightning applications** | `lightning` | `Lightning` | Lightning 앱 접근 |
| **Access Visualforce applications** | `visualforce` | `CustomApplications` | Visualforce 페이지 접근 |
| **Access Analytics REST API resources** | `wave_api` | `Wave` | CRM Analytics(Wave) REST API |
| **Access Analytics REST API Charts Geodata resources** | `eclair_api` | `Eclair` | Analytics 차트 geodata |
| **Manage Pardot services** | `pardot_api` | `Pardot` | Account Engagement(Pardot) API |
| **Manage Customer Data Platform Ingestion API data** | `cdp_ingest_api` | `CDPIngest` | Data Cloud Ingestion API |
| **Manage Customer Data Platform profile data** | `cdp_profile_api` | — | Data Cloud profile API |
| **Perform ANSI SQL queries on Customer Data Platform data** | `cdp_query_api` | — | Data Cloud query API |
| **Access all Data Cloud API resources** | `cdp_api` | — | Data Cloud 전체 API |
| **Access chatbot services** | `chatbot_api` | `Chatbot` | Einstein Bots API |
| **Access Headless Registration API** | `user_registration_api` | `UserRegistration` | Headless(Experience Cloud) 등록 |
| **Access Headless Forgot Password API** | `forgot_password` | `ForgotPassword` | Headless 비밀번호 재설정 |
| **Access the Salesforce API Platform** | `sfap_api` | — | Salesforce API Platform |
| **Access Interaction API resources** | `interaction_api` | — | Interaction API |

- 최소 권장 조합: 대부분의 앱은 `api` + `web` + `refresh_token`(offline_access)면 충분. `full`은 광범위하므로 필요할 때만.
- **custom scope**는 별도 `OauthCustomScope` 메타데이터로 정의 후 여기에 추가. (근거: OAuth Custom Scopes.)

---

## 4. Connected App — OAuth Policies 필드 (생성 후 Manage)

앱 저장 → App Manager → 앱 드롭다운 → **Manage** → Edit Policies. 관리자가 접근·세션 정책을 설정한다.

| # | UI 필드 | 유형 | 값/옵션(전수) | 의미 | Metadata (`oauthPolicy`) |
|---|---|---|---|---|---|
| 1 | **Permitted Users** | 선택(picklist) | **All users may self-authorize**(기본) / **Admin approved users are pre-authorized** | 누가 앱을 승인·사용할 수 있나. Admin approved면 Profile/Permission Set 할당 필요 | `isAdminApproved`(true=admin approved) + `permissionSetName`·`profileName` |
| 2 | **IP Relaxation** | 선택(picklist) | **Enforce IP restrictions**(기본) / Enforce IP restrictions, but relax for refresh tokens / Relax IP restrictions for activated devices(=BYPASS_2FACTOR) / Relax IP restrictions(=BYPASS) | org IP 제한을 이 앱에 어떻게 적용할지 | `ipRelaxation` = `ENFORCE`\|`ENFORCE_RELAXREFRESH`\|`BYPASS_2FACTOR`\|`BYPASS` |
| 3 | **Refresh Token Policy** | 선택+숫자 | **Refresh token is valid until revoked**(=infinite, 기본) / Immediately expire refresh token(=zero) / Expire refresh token if not used for N(specific_inactivity) / Expire refresh token after N(specific_lifetime). 단위 HOURS/DAYS/MONTHS | refresh token 유효 기간 | `refreshTokenPolicy` = `infinite`\|`zero`\|`specific_inactivity:N:UNIT`\|`specific_lifetime:N:UNIT` |
| 4 | **Timeout Value** (Session Policies) | 선택(picklist) | org Session Settings 값 / 15·30분 … 24시간 등 | access token(세션) 만료 시간. 미지정 시 org 기본 | `sessionPolicy.sessionTimeout`(분) |
| 5 | **High Assurance Session Required** | 체크박스/선택 | Block / Raise session level to high assurance | 세션 보안 레벨 강제 시 동작 | `sessionPolicy.sessionLevel`·`policyAction`(`Block`\|`RaiseSessionLevel`) |
| 6 | **Single Logout** (활성 시) | 체크박스+URL | HTTPS 절대 URL | SLO 활성화 시 로그아웃 요청 보낼 URL | `oauthConfig.singleLogoutUrl` / `oauthPolicy.singleLogoutUrl` |
| 7 | **Trusted IP Range for OAuth** (섹션) | 반복 start/end | IP 범위 목록 | 재인증 없이 접근 허용할 IP 범위 | `ipRanges` (`ConnectedAppIpRange`: `start`·`end`·`description`) |

> **IP Relaxation enum 대응**(Tier 2): UI "Relax IP restrictions for activated devices" = `BYPASS_2FACTOR`, "Relax IP restrictions" = `BYPASS`, "Enforce IP restrictions, but relax for refresh tokens" = `ENFORCE_RELAXREFRESH`. (근거: ConnectedAppOauthPolicy Metadata.)

---

## 5. External Client App 대응 필드 (3개 메타데이터로 분리)

External Client App은 Connected App의 필드를 **개발자 설정·관리자 정책·전역 자격증명 3개 파일로 쪼갠다.** 개발자가 배포하는 `ExtlClntAppOauthSettings`(설정)와 관리자가 org별로 붙이는 `ExtlClntAppOauthConfigurablePolicies`(정책)가 나뉘는 게 핵심 차이다.

### 5-1. `ExtlClntAppGlobalOauthSettings` — 전역 OAuth 자격증명

| UI/개념 필드 | 의미 | Metadata |
|---|---|---|
| **Consumer Key** | client_id(식별자) | `ExtlClntAppGlobalOauthSettings`(consumer key 보관) |
| **Consumer Secret** | client_secret | 동상(전역 자격증명 분리 파일) |
| **Callback URL** (전역 기본) | 기본 redirect URI | 동상 |

> Connected App의 `oauthConfig.consumerKey`/`consumerSecret`에 해당. ECA는 자격증명을 전역 파일로 분리해 패키징·회전 관리가 쉽다.

### 5-2. `ExtlClntAppOauthSettings` — 개발자 OAuth 설정

| UI 필드 | 유형 | Metadata 필드 | Connected App 대응 |
|---|---|---|---|
| **External Client Application** | 룩업 | `externalClientApplication` | (컨테이너 연결) |
| **Label** | 텍스트 | `label` | `label` |
| **Selected OAuth Scopes** | 이중 리스트 | `commaSeparatedOauthScopes`(쉼표구분 문자열) | `scopes` |
| **Callback URL** | 텍스트(다중) | (설정 파일 내) | `callbackUrl` |
| **Use Client Assertion Certificate** | 인증서 | `clientAssertionCertificate` | (headless identity 서명) |
| **Single Logout URL** | 텍스트 | `singleLogoutUrl` | `singleLogoutUrl` |
| **Custom Attributes** | 반복 name/value | `customAttributes`(최대 128) | ID/Asset token attributes |
| **Trusted IP Ranges** | 반복 start/end | `trustedIpRanges`(최대 128) | `ipRanges` |
| **Enable First-Party App** | 체크박스 | `isFirstPartyAppEnabled` | (신규 — CA엔 없음) |
| **Asset Token: Include Attributes / Custom Perms / Audiences / Signing Cert / Validity** | 체크박스·텍스트 | `areAttributesIncludedInAssetToken`·`areCustomPermsIncludedInAssetToken`·`assetTokenAudiences`·`assetTokenSigningCertificate`·`assetTokenValidity` | `assetTokenConfig` |

> ⚠️ ECA 설정 파일에는 **Require Secret / PKCE / Client Credentials 같은 플래그가 `ExtlClntAppOauthSettings`가 아닌 정책 파일(5-3)로 이동**한 것들이 있다 — 아래 참조. (근거: [Configure the External Client App OAuth Settings](https://help.salesforce.com/s/articleView?id=xcloud.configure_external_client_app_oauth_settings.htm).)

### 5-3. `ExtlClntAppOauthConfigurablePolicies` — 관리자 정책

| UI 필드 | Metadata 필드 | 값(전수) | Connected App 대응 |
|---|---|---|---|
| **Permitted Users** | `permittedUsersPolicyType` | `AllSelfAuthorized`\|`AdminApprovedPreAuthorized` | `isAdminApproved` |
| **IP Relaxation** | `ipRelaxationPolicyType` | `Enforce`\|`Bypass`\|`Bypass_2factor`\|`Enforce_RelaxRefresh` | `ipRelaxation` |
| **Refresh Token Policy** | `refreshTokenPolicyType` | `Infinite`\|`Zero`\|`SpecificInactivity`\|`SpecificLifetime` | `refreshTokenPolicy` |
| **Session Timeout** | `sessionTimeoutInMinutes` | 정수(분, opaque token만) | `sessionPolicy.sessionTimeout` |
| **High Assurance Action** | `policyAction` / `requiredSessionLevel` | `Block`\|`RaiseSessionLevel` / `HIGH_ASSURANCE`\|`STANDARD`\|`LOW` | `sessionPolicy` |
| **Enable Client Credentials Flow** | `isClientCredentialsFlowEnabled` | boolean | `isClientCredentialEnabled` |
| **Enable Token Exchange Flow** | `isTokenExchangeFlowEnabled` | boolean | `isTokenExchangeEnabled` |
| **Enable Guest Authorization Code and Credentials Flow** | `isGuestCodeCredFlowEnabled` | boolean | `isCodeCredentialEnabled`(guest 계열) |
| **JWT Session Timeout Type** (guest/named) | `guestJwtSessionTimeoutType`·`namedUserJwtSessionTimeoutType` | `UserSession`\|`Custom` | (신규 세분화) |
| **Permission Sets / Profiles** | `commaSeparatedPermissionSet`·`commaSeparatedProfile` | 쉼표구분 ID | `permissionSetName`·`profileName` |
| **Single Logout URL / Start URL** | `singleLogoutUrl`·`startUrl` | URL | `singleLogoutUrl`·`startUrl` |

---

## 6. Connected App ↔ External Client App 필드 대응표 (한눈에)

| 기능 | Connected App (`ConnectedApp`) | External Client App | 비고 |
|---|---|---|---|
| 이름/연락처 | `label`·`contactEmail`(한 파일) | `ExternalClientApplication`(컨테이너) | ECA는 컨테이너 분리 |
| Consumer Key/Secret | `oauthConfig.consumerKey`·`consumerSecret` | `ExtlClntAppGlobalOauthSettings` | ECA는 전역 자격증명 분리 |
| Callback URL·Scope·Cert | `oauthConfig.callbackUrl`·`scopes`·`certificate` | `ExtlClntAppOauthSettings`(개발자) | 개발자 설정 |
| Require Secret / PKCE / Client Cred / Token Exchange | `oauthConfig.is*`(개발자+정책 혼재) | `ExtlClntAppOauthConfigurablePolicies`(관리자) | ECA는 정책으로 이동 |
| Permitted Users·IP·Refresh·Timeout | `oauthPolicy`·`sessionPolicy` | `ExtlClntAppOauthConfigurablePolicies`(관리자) | 관리자 정책 |
| 패키징 | 2GP 제한적 | 2GP 네이티브 | ECA 장점 |
| 신규 생성 (Spring '26+) | ❌ 차단 | ✅ 권장 | 마이그레이션 경로 |

> **분리의 의미**: ECA는 "개발자가 앱을 정의(`ExtlClntAppOauthSettings`)"하고 "각 org 관리자가 정책을 붙임(`ExtlClntAppOauthConfigurablePolicies`)"으로 역할을 나눈다. 패키지로 배포된 앱을 설치 org 관리자가 자기 정책으로 통제할 수 있는 구조. (개념·차이 상세는 [[External Client App (외부 클라이언트 앱)]].)

---

## 관련 노트

- [[Connected App (연결된 앱) — OAuth 클라이언트]] — 개념·Consumer Key/Secret·OAuth 플로우 종류·정책의 의미 (이 노트는 필드 카탈로그, 개념은 여기로 위임)
- [[External Client App (외부 클라이언트 앱)]] — 차세대 후속 프레임워크 개념·CA와 차이·2GP 패키징·Spring '26 전환
- [[OAuth Web Server + PKCE 플로우 구축 가이드]] — Callback URL·Selected Scopes·Require PKCE를 실제로 채워 authorization code 플로우를 구축하는 절차 (병렬 작성)
- [[서버간 통합 구축 가이드 - External Client App·JWT Bearer·Client Credentials]] — Enable Client Credentials Flow·Use digital signatures를 서버-투-서버 통합에 적용하는 절차
- [[Auth Provider (인증 공급자)]] — Salesforce가 OAuth 클라이언트로서 외부 IdP에 붙을 때의 반대 방향 설정
- [[Named Credential·External Credential 생성 필드 전수 레퍼런스]] — 아웃바운드 콜아웃 인증(대칭 형식의 자매 필드 레퍼런스)
