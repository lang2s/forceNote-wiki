---
tags: [Security, Identity, SSO, SAML, Authentication, JIT, Federation, InboundSSO]
source: help.salesforce.com — Single Sign-On (xcloud.sso_about.htm) · SAML Single Sign-On Flows (xcloud.identity_provider_about.htm) · SAML SSO with Salesforce as the Service Provider (xcloud.sso_saml_setting_up.htm) · Configure SSO with Salesforce as a SAML Service Provider (xcloud.sso_saml.htm) · Step 1 Gather Information from Your Identity Provider (xcloud.sso_saml_idp_prereqs.htm) · Step 2 Create a SAML Single Sign-On Setting (xcloud.sso_service_provider_configuration.htm) · Just-in-Time Provisioning for SAML (xcloud.sso_jit_about.htm) · Just-in-Time SAML Assertion Fields for Salesforce (xcloud.sso_jit_requirements.htm) (Tier 2, 2026-07-11 접속) · developer.salesforce.com Apex Reference — Auth.SamlJitHandler Interface (apex_interface_Auth_SamlJitHandler.htm, Tier 2, 2026-07-11 접속)
created: 2026-07-11
aliases: [SAML SSO, Single Sign-On, 싱글 사인온, 인바운드 SSO, Inbound SSO, SAML 로그인, Federated Authentication, 페더레이션 인증, JIT Provisioning, SamlJitHandler, SAML Identity Type, Federation ID]
---

# Single Sign-On (SAML SSO 인바운드)

> 외부 IdP(Okta·Azure AD·ADFS·PingFederate 등)가 발급한 **SAML 어설션**으로 사용자를 Salesforce org에 로그인시키는 인바운드 SSO. Salesforce가 **Service Provider(SP)** 가 되어 IdP를 신뢰하고, 자격 증명 검증은 IdP에 위임한다.

---

## 개념 — SSO란, 그리고 "인바운드"의 의미

**SSO(Single Sign-On)** 는 한 번의 로그인·한 벌의 자격 증명으로 여러 애플리케이션에 접근하는 인증 방식이다. 예를 들어 org에 로그인한 사용자는 App Launcher의 모든 앱을 다시 로그인하지 않고 열 수 있다 (help.salesforce.com — Single Sign-On, Tier 2).

두 역할을 구분한다:

| 역할 | 정의 |
|---|---|
| **Identity Provider (IdP)** | 사용자를 **인증하는** 시스템 (자격 증명 검증) |
| **Service Provider (SP)** | 인증을 위해 IdP를 **신뢰하는** 시스템 |

이 노트가 다루는 **인바운드 SSO**는 **외부 IdP → Salesforce(SP)** 방향이다. 즉 사용자가 회사 IdP(Okta·Azure AD 등) 계정으로 Salesforce에 로그인한다. Salesforce는 SAML(또는 OpenID Connect)로 이 흐름을 지원한다. (help.salesforce.com — Single Sign-On, Tier 2)

### 인바운드 vs 아웃바운드 vs 소셜 — 어느 노트를 볼 것인가

| 시나리오 | 방향 | 프로토콜/기능 | 담당 노트 |
|---|---|---|---|
| **인바운드 SSO** (외부 IdP로 Salesforce에 로그인) | 사용자 → Salesforce | **SAML** (SP 역할) | **이 노트** |
| **아웃바운드 SSO** (Salesforce가 IdP가 되어 다른 앱에 로그인시킴) | Salesforce → 외부 SP | SAML/OIDC (IdP 역할) | (별도 — Salesforce as Identity Provider) |
| **소셜 로그인 / OAuth·OIDC SSO** | 사용자 → Salesforce | OAuth 2.0 / OpenID Connect | [[Auth Provider (인증 공급자)]] |
| **외부 콜아웃 인증 토큰** | Salesforce → 외부 시스템 | OAuth (토큰 획득·갱신) | [[Auth Provider (인증 공급자)]] · Named Credential |

> **페더레이션 인증 vs 위임 인증(Delegated Authentication):** SAML SSO는 IdP가 서명한 어설션을 신뢰하는 **페더레이션 인증**이다. 이와 달리 **위임 인증**은 Salesforce가 로그인마다 외부 시스템(예: LDAP)에 자격 증명 검증을 요청하며, 사용자는 각 앱에 별도로 로그인해야 한다. Salesforce는 SSO를 **SAML과 OpenID Connect** 로 지원한다. (help.salesforce.com — Single Sign-On, Tier 2)

---

## SP-initiated vs IdP-initiated 흐름

SAML SSO는 로그인을 **SP에서 시작**하거나 **IdP에서 시작**할 수 있다. 두 흐름 모두 결과적으로 사용자를 SP(Salesforce)에 로그인시킨다. (help.salesforce.com — SAML Single Sign-On Flows, Tier 2)

**Service Provider-Initiated (SP-initiated)** — SP가 SAML **요청(request)** 으로 시작:

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (출처: SAML Single Sign-On Flows, Tier 2)
1. 사용자가 SP(Salesforce)의 보호된 리소스에 대한 보안 세션을 요청한다.
2. SP가 IdP에 사용자 인증을 요청하는 SAML request를 보낸다.
3. IdP가 로그인 페이지를 띄우고, 사용자가 IdP 자격 증명을 입력하면 IdP가 인증한다.
4. 사용자가 SP에 로그인되어 보호된 리소스에 접근한다.
```

**Identity Provider-Initiated (IdP-initiated)** — IdP가 SAML **응답(response)** 으로 시작 (SP-initiated의 축약형, SAML request 불필요):

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (출처: SAML Single Sign-On Flows, Tier 2)
1. 사용자가 IdP에 로그인한 뒤, SP 접근 버튼/링크를 클릭한다.
2. IdP가 암호학적으로 서명된 SAML response를 SP로 보낸다.
3. SP가 어설션을 검증하고 사용자를 로그인시킨다.
```

---

## 설정 절차 — Salesforce를 SAML Service Provider로 구성

경로: **Setup → Identity → Single Sign-On Settings** (Lightning Experience).
> Setup 라벨은 릴리스·org에 따라 다를 수 있음 (Tier 2, 2026-07-11).

공식 문서는 4단계로 안내한다 (help.salesforce.com — Configure SSO with Salesforce as a SAML Service Provider, Tier 2):

| 단계 | 내용 |
|---|---|
| **Step 1** | **IdP로부터 정보 수집** — Issuer(발급자 ID), IdP 인증 인증서(certificate), 그리고 IdP가 어설션에 담는 식별자 형식·위치. (xcloud.sso_saml_idp_prereqs.htm) |
| **Step 2** | **SAML Single Sign-On Setting 생성** — Single Sign-On Settings에서 **SAML Enabled** 체크 후 New. 아래 필드 레퍼런스 참조. (xcloud.sso_service_provider_configuration.htm) |
| **Step 3** | **SSO 구성을 IdP에 공유** — Salesforce가 생성한 Login URL(ACS URL)·Entity ID 등을 IdP에 등록. |
| **Step 4** | **로그인 페이지에 SSO 공급자 추가 후 연결 테스트** — My Domain 로그인 페이지에 SSO 옵션 노출 (아래 "My Domain 연계" 참조). |

---

## SAML Single Sign-On Settings — 필드 레퍼런스

Step 2에서 입력하는 주요 필드다. 어설션 서명은 업로드한 IdP 인증서에 대응하는 **개인 키(private key)** 로 생성돼야 검증을 통과한다. (help.salesforce.com — Step 2, Tier 2)

| 필드 | 설명 |
|---|---|
| **SAML Version** | `2.0` 선택. (Tier 2) |
| **Issuer** | IdP의 고유 식별자(issuer ID). IdP에서 복사해 그대로 입력. |
| **Entity ID** | 어설션의 `<Audience>` 값과 일치해야 하는 SP 식별자. 기본값 `https://saml.salesforce.com`. **My Domain이 활성화된 org는 My Domain URL을 Entity ID로 사용**한다. |
| **Identity Provider Certificate** | IdP의 인증 인증서를 업로드. 어설션 서명 검증에 사용. |
| **SAML Identity Type** | 어설션이 담은 사용자 식별자를 Salesforce 어느 필드와 매칭할지: **Salesforce Username** 또는 **User 객체의 Federation ID**(모든 사용자 프로필에 Federation ID가 채워져 있어야 함) 등. (help.salesforce.com, Tier 2) |
| **SAML Identity Location** | 식별자가 어설션의 어디에 있는지: **Subject 문의 NameIdentifier 요소** 또는 **Attribute 요소**. |
| **Attribute Name / Attribute URI / Name ID Format** | Identity Location이 **Attribute 요소**일 때만 필요. NameIdentifier에 있으면 불필요. |
| **Service Provider Initiated Request Binding** | SP-initiated 흐름에서 SAML request를 보낼 바인딩(HTTP POST / HTTP Redirect). *정확한 옵션 라벨은 릴리스·org에 따라 다를 수 있음 (Tier 2, 2026-07-11).* |
| **Identity Provider Login URL** | IdP-initiated 흐름에서 사용자를 보낼 IdP 로그인 URL. |
| **Custom Logout URL / Custom Error URL** | SAML 로그아웃·오류 시 이동할 URL(선택). |
| **Just-in-Time User Provisioning** | 아래 JIT 섹션 참조. |

> 위 표의 개별 Setup 필드 라벨은 릴리스·org에 따라 다를 수 있음 (Tier 2, 2026-07-11). `Federation ID`는 User 상세 페이지의 필드로, SAML SSO에서 Salesforce 사용자를 외부 IdP의 신원과 잇는 고유 식별자다. (help.salesforce.com, Tier 2)

---

## Just-in-Time (JIT) Provisioning

**JIT 프로비저닝**은 사용자가 SAML로 **처음 로그인할 때 어설션에 담긴 속성으로 Salesforce 사용자를 자동 생성**하고, 이후 로그인 시 자동 업데이트하는 기능이다. 사용자 계정을 미리 만들 필요가 없어 관리 부담이 준다. (help.salesforce.com — Just-in-Time Provisioning for SAML, Tier 2)

JIT는 어설션 속성명을 **`객체.필드`** 형식(예: `User.Username`, `Contact.Email`)으로 전달한다.

### 신규 사용자 생성에 필요한 어설션 필드 (Salesforce 표준 사용자)

(help.salesforce.com — Just-in-Time SAML Assertion Fields for Salesforce, Tier 2)

| 어설션 필드 | 필수 | 설명 |
|---|---|---|
| `User.Username` | 필수 | org 전체에서 유일한, 이메일 주소 형식의 문자열. |
| `User.LastName` | 필수 | 성(姓). |
| `User.Email` | 필수 | 이메일. |
| `User.ProfileId` | 필수 | 적절한 Profile의 Salesforce ID 문자열. |
| `User.FirstName` | 선택 | 이름. |

> Experience Cloud·포털 사용자는 별도 요구 필드 세트를 쓰며(예: `Contact.Email`은 모든 Account의 Contact 레코드 전체에서 유일해야 함, 아니면 프로비저닝 실패), 전체 목록은 "Just-in-Time SAML Assertion Fields for Experience Cloud / Portals" 문서를 따른다 (Tier 2). 위 목록은 표준 org 사용자 기준이며, 릴리스에 따라 필드가 추가될 수 있음 (Tier 2, 2026-07-11).

### 표준 JIT vs 커스텀 JIT (Apex 핸들러)

- **Standard JIT** — 위 표준 필드로 Salesforce가 사용자 생성/업데이트를 처리.
- **Custom SAML JIT with Apex Handler** — `Auth.SamlJitHandler` 인터페이스를 구현한 Apex 클래스로 생성/업데이트 로직을 완전히 제어. (developer.salesforce.com — Auth.SamlJitHandler Interface, Tier 2)

```apex
// 구조 예시 — 인터페이스 시그니처는 Apex Reference(Auth.SamlJitHandler) 발췌, Tier 2
global class MySamlJitHandler implements Auth.SamlJitHandler {

    // 지정한 Federation ID로 User 객체를 반환. 새 사용자(미삽입)이거나 기존 사용자일 수 있음.
    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
                           String federationId, Map<String, String> attributes,
                           String assertion) {
        // 어설션 attributes(예: attributes.get('User.Email'))로 User를 구성/삽입
        User u = new User();
        // ... 매핑 로직 ...
        return u;
    }

    // 이전에 SAML SSO로 로그인한 사용자가 다시 로그인하거나
    // Existing User Linking URL을 쓸 때 호출되어 사용자 정보를 갱신.
    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId,
                           Id portalId, String federationId,
                           Map<String, String> attributes, String assertion) {
        // ... 업데이트 로직 ...
    }
}
```

---

## My Domain·로그인 페이지 연계

인바운드 SAML SSO 옵션은 **My Domain 로그인 페이지의 Authentication Configuration** 을 통해 로그인 페이지에 노출된다. SP를 구성한 뒤 IdP(또는 SSO 설정)를 로그인 페이지에 추가해야 사용자가 SSO로 로그인할 수 있다. My Domain 로그인 URL은 IdP 구성 시 SP 엔드포인트(예: ACS URL) 기준으로도 쓰인다. 자세한 로그인 페이지·인증 서비스 구성은 [[My Domain (마이 도메인)]] 노트를 참조한다. (help.salesforce.com — Add an Authentication Provider to Your Org's Login Page / My Domain, Tier 2)

---

## 언제 무엇 — SAML vs OAuth·Auth Provider

| 목적 | 선택 | 이유 |
|---|---|---|
| 외부 IdP로 **Salesforce에 로그인**(직원·엔터프라이즈 IdP) | **SAML SSO (이 노트)** | 서명된 SAML 어설션 기반 페더레이션 인증. Salesforce = SP. |
| **소셜 로그인**(Google·Facebook·Microsoft·OIDC) 또는 OAuth 기반 로그인 | [[Auth Provider (인증 공급자)]] | OAuth 2.0 / OpenID Connect 브로커 + Registration Handler로 사용자 매핑. |
| Salesforce가 **외부 시스템 콜아웃 토큰**을 획득·갱신 | Named Credential + [[Auth Provider (인증 공급자)]] / External Auth IdP | 아웃바운드 인증(토큰), 로그인 아님. |
| Salesforce가 **IdP가 되어 다른 앱에 로그인**시킴 | Salesforce as SAML/OIDC Identity Provider | 아웃바운드 SSO — 이 노트 범위 밖. |

---

## 관련 노트
- [[Auth Provider (인증 공급자)]] — OAuth/OIDC 소셜 로그인·아웃바운드 토큰 (SAML 인바운드 SSO와 구분)
- [[My Domain (마이 도메인)]] — 로그인 페이지·Authentication Configuration·SSO 옵션 노출
- [[Salesforce 권한 모델 개요]] — 로그인 후 접근을 결정하는 프로파일·권한 집합
- [[Profiles (프로파일)]] — JIT `User.ProfileId`가 가리키는 프로파일
