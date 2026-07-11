---
tags: [salesforce, integration, security, identity, auth-provider, sso, oauth, apex]
source: help.salesforce.com — Authentication Providers·Create a Custom External Authentication Provider (sso_authentication_providers·sso_provider_plugin_custom, Tier 2); developer.salesforce.com Apex Reference — Auth.AuthProviderPluginClass·Auth.RegistrationHandler (Tier 2); Metadata API / Object Reference — AuthProvider ProviderType (Tier 2); developer.salesforce.com — Metadata API ExternalAuthIdentityProvider (v62.0 Winter '25 — "use an externalAuthIdentityProvider instead of an authProvider", Tier 2)
created: 2026-07-06
aliases: [Auth Provider, Auth. Provider, 인증 공급자, 인증공급자, Authentication Provider, Social Sign-On, 소셜 로그인, Registration Handler, AuthProviderPluginClass, Custom Auth Provider]
---

# Auth Provider (인증 공급자)

> 외부 IdP(Google·Microsoft·Salesforce·OpenID Connect·Custom Apex 등)를 통한 인증 게이트웨이. 두 용도로 쓴다 — (1) 외부 사용자가 외부 계정으로 Salesforce/Experience Cloud에 **로그인**(소셜 로그인·SSO), (2) Named Credential이 참조해 외부 시스템 콜아웃용 **OAuth 토큰을 획득·자동 갱신**.

---

## 개념

Auth Provider(인증 공급자)는 Salesforce와 외부 OAuth/OpenID Connect 기반 IdP 사이의 **인증 브로커**다. Salesforce가 OAuth 흐름의 클라이언트가 되어 외부 서비스에 인증을 위임하고, 그 결과로 받은 정보(토큰·사용자 프로필)를 Salesforce에서 쓸 수 있게 한다. Setup → **Auth. Providers** 에서 설정한다.

핵심은 이 하나의 기능이 방향이 다른 **두 용도**를 동시에 커버한다는 점이다.

| 용도 | 흐름 방향 | 설명 |
|---|---|---|
| **소셜 로그인 / SSO** | 사용자 → Salesforce | 외부 사용자가 Google·Microsoft 등 기존 계정으로 Salesforce/Experience Cloud에 로그인. Auth Provider가 IdP로부터 사용자 정보를 받아 **Registration Handler**로 Salesforce 사용자를 생성·매핑·로그인시킨다. |
| **외부 시스템 인증 토큰 공급** | Salesforce → 외부 시스템 | [[Named Credential]]이 Auth Provider를 참조해 콜아웃에 필요한 OAuth access token을 획득하고 만료 시 refresh token으로 자동 갱신. Apex 콜아웃 코드는 토큰을 직접 다루지 않는다. |

즉 Auth Provider는 "누가 Salesforce에 들어오는가"(inbound SSO)와 "Salesforce가 누구에게 나가는가"(outbound callout 인증) 양쪽에서 OAuth 흐름의 신뢰 앵커 역할을 한다.

---

## 지원 Provider 유형

Salesforce는 아래 유형을 프리셋으로 제공한다. 유형별로 표준 OAuth/OpenID Connect 엔드포인트가 내장돼 있어, 대부분 외부 앱의 Consumer Key/Secret만 입력하면 된다.

| 유형 | 비고 |
|---|---|
| **Salesforce** | 다른 Salesforce org(또는 Experience Cloud)를 IdP로. org 간 SSO. |
| **OpenID Connect** | 표준 OIDC를 지원하는 임의의 IdP(Okta·Auth0·Ping·Azure AD 등). 가장 범용. |
| **Microsoft** | Microsoft Identity Platform(Azure AD / 개인 계정). |
| **Microsoft Access Control Service** | ACS 기반(레거시). |
| **Google** | Google 계정 소셜 로그인. |
| **Facebook** | Facebook 계정. |
| **LinkedIn** | LinkedIn 계정. |
| **X (구 Twitter)** | X/Twitter 계정. |
| **Slack** | Slack 계정. |
| **Janrain** | Janrain(소셜 아이덴티티 애그리게이터). |
| **Custom** | OAuth은 지원하나 OIDC는 아닌 외부 서비스용. **Apex 플러그인**(`Auth.AuthProviderPluginClass`)으로 흐름을 직접 구현. → 아래 "Custom Auth Provider" 참조. |

> 유형별 정확한 라벨은 org 버전에 따라 소폭 다를 수 있다(예: Twitter → X 리브랜딩). 프리셋에 없는 IdP라도 OIDC를 지원하면 **OpenID Connect** 유형으로, OAuth만 지원하면 **Custom** 플러그인으로 커버한다.

---

## 설정 절차 (Setup → Auth. Providers)

```
// 구조 예시 — 실제 org 화면 순서 요약(동작 코드 아님)
1. 외부 앱 사전 등록
   · IdP(Google Cloud Console·Azure AD 앱 등록 등)에서 앱을 만들고
     Consumer Key(Client ID) / Consumer Secret(Client Secret) 발급
   · 이 단계에서는 Callback URL을 아직 모르므로 임시로 두거나, Salesforce 저장 후 되돌아와 등록

2. Salesforce에서 New Auth. Provider
   · Provider Type 선택 (Google / OpenID Connect / Custom / ...)
   · Name·URL Suffix 입력 (URL Suffix는 Callback URL 경로에 들어가는 고유 식별자)
   · Consumer Key / Consumer Secret 입력
   · (OIDC/Custom) Authorize Endpoint URL·Token Endpoint URL·User Info Endpoint·Default Scopes 등 입력
   · Registration Handler: SSO로 쓸 경우 사용자 생성/매핑 Apex 클래스 지정
     (Automatically create a registration handler template 로 뼈대 자동 생성 가능)
   · Execute Registration As: Registration Handler를 실행할 컨텍스트 사용자
     (Manage Users 권한 필요 — 보통 추적용 전용 시스템 사용자 지정)

3. 저장 후 생성된 URL 확인 (Salesforce Configuration 섹션)
   · Callback URL 을 복사해 2단계의 외부 IdP 앱에 Redirect URI로 등록
```

### 주요 필드

| 필드 | 역할 |
|---|---|
| **Provider Type** | IdP 유형. 저장 후 변경 불가에 준함(재생성 권장). |
| **Name / URL Suffix** | 표시 이름과 URL 경로 식별자. Suffix가 Callback URL·Initialization URL에 삽입됨. |
| **Consumer Key / Consumer Secret** | 외부 IdP에 등록한 앱의 Client ID / Secret. Salesforce가 OAuth 클라이언트로서 자신을 증명. |
| **Registration Handler** | `Auth.RegistrationHandler`를 구현한 Apex 클래스. SSO 로그인 시 사용자 생성·업데이트를 담당. 토큰 공급 전용(Named Credential)만 쓸 땐 필수 아님. |
| **Execute Registration As** | Registration Handler가 실행되는 사용자 컨텍스트. **Manage Users** 권한 보유자여야 함. |
| **Custom Error URL / Logout URL / Icon URL** | 오류 리다이렉트·SSO 로그아웃 목적지·로그인 화면 아이콘(선택). |

---

## 생성되는 URL

저장하면 Salesforce가 여러 엔드포인트를 자동 생성한다. 값은 `URL Suffix`와 org 도메인에 따라 결정된다.

| URL | 용도 |
|---|---|
| **Callback URL** | 외부 IdP가 인증 후 사용자를 되돌려 보내는 리다이렉트 목적지. 형태: `https://login.salesforce.com/services/authcallback/<URL_Suffix>` (org의 My Domain을 쓰면 해당 도메인). 외부 IdP 앱의 Redirect URI에 등록해야 함. |
| **Test-Only Initialization URL** | 설정이 올바른지 관리자가 **테스트**하는 용도. 이 URL을 열면 실제 로그인/사용자 생성 없이 IdP가 반환하는 raw 속성(access token·user attributes)을 브라우저에 그대로 표시. 디버깅에 유용. |
| **Single Sign-On Initialization URL** | 실제 **SSO 로그인** 진입점. 이 URL로 사용자를 보내면 IdP 인증 → Registration Handler 실행 → Salesforce 세션 생성까지 완주. 로그인 페이지·Experience Cloud 로그인 위젯이 이 URL을 사용. |
| **Existing User Linking URL** | 이미 존재하는 Salesforce 사용자를 외부 IdP 계정과 **연결(link)** 하는 용도. |
| **OAuth-Only Initialization URL** | 로그인이 아니라 **OAuth 토큰만 획득**하는 진입점(토큰 공급 용도). |

> Callback URL 경로 형태는 릴리스에 따라 `.../authcallback/<id>/<URL_Suffix>` 처럼 org id 세그먼트를 포함하는 형태로 표시되기도 한다. **실제 org의 Auth. Provider 상세 화면에 표시된 값을 그대로 복사**해 외부 IdP에 등록하는 것이 원칙이다(값을 손으로 조립하지 말 것).

---

## Registration Handler (SSO 사용자 매핑)

소셜 로그인/SSO 용도로 쓸 때, IdP가 인증한 외부 사용자를 Salesforce 사용자로 어떻게 만들지/이을지는 **`Auth.RegistrationHandler`** 인터페이스를 구현한 Apex 클래스가 결정한다.

```apex
// 구조 예시 — Auth.RegistrationHandler 표준 인터페이스 골격
global class MyRegHandler implements Auth.RegistrationHandler {

    // 최초 로그인: 외부 사용자에 대응하는 Salesforce User를 생성해 반환
    global User createUser(Id portalId, Auth.UserData data) {
        // data.email, data.firstName, data.lastName, data.username,
        // data.identifier(외부 고유 ID), data.attributeMap 등을 사용해 User 구성
        User u = new User();
        u.Email     = data.email;
        u.FirstName = data.firstName;
        u.LastName  = data.lastName;
        // Profile / Role / Username 등 세팅 후 insert 하거나 반환
        return u;
    }

    // 재로그인: 기존 User를 IdP 최신 속성으로 갱신
    global void updateUser(Id userId, Id portalId, Auth.UserData data) {
        User u = [SELECT Id FROM User WHERE Id = :userId];
        u.Email = data.email;
        update u;
    }
}
```

- `createUser`는 **User(sObject)** 를 반환하고, `updateUser`는 반환값이 없다(`void`).
- `Auth.UserData`는 IdP가 넘긴 사용자 정보(email·이름·고유 identifier·`attributeMap` 등)를 담은 객체다.
- 이 클래스가 실행되는 권한 컨텍스트가 **Execute Registration As** 사용자(Manage Users 권한)다.

---

## Custom Auth Provider — `Auth.AuthProviderPluginClass`

프리셋 유형(Google·OIDC 등)으로 커버되지 않는 IdP(표준 OAuth은 지원하나 OpenID Connect는 아닌 서비스 등)는 **Custom** 유형으로 만들고, 인증 흐름 자체를 Apex로 구현한다. 추상 클래스 **`Auth.AuthProviderPluginClass`** 를 상속하고 아래 5개 메서드를 구현한다. 설정 값은 **Custom Metadata Type** 레코드에 저장하고 플러그인이 이를 읽는다.

| 메서드 | 시그니처 | 역할 |
|---|---|---|
| `getCustomMetadataType` | `String getCustomMetadataType()` | 이 플러그인의 설정을 담는 Custom Metadata Type의 API 이름 반환. |
| `initiate` | `System.PageReference initiate(Map<String,String> config, String stateToPropagate)` | 사용자를 인증하러 보낼 IdP authorize URL로의 `PageReference` 반환(OAuth 흐름 시작). |
| `handleCallback` | `Auth.AuthProviderTokenResponse handleCallback(Map<String,String> config, Auth.AuthProviderCallbackState state)` | IdP 콜백을 처리, authorization code를 access/refresh token으로 교환해 반환. |
| `getUserInfo` | `Auth.UserData getUserInfo(Map<String,String> config, Auth.AuthProviderTokenResponse response)` | 토큰으로 IdP에서 사용자 프로필을 조회해 `Auth.UserData`로 반환(Registration Handler가 이 데이터를 사용). |
| `refresh` | `Auth.OAuthRefreshResult refresh(Map<String,String> config, String refreshToken)` | refresh token으로 만료된 access token을 갱신. Named Credential 토큰 자동 갱신에 사용. |

```apex
// 구조 예시 — Custom Auth Provider 플러그인 골격(동작 코드 아님)
global class MyCustomAuthProvider extends Auth.AuthProviderPluginClass {

    global String getCustomMetadataType() {
        return 'My_Auth_Provider_Setting__mdt';
    }

    global PageReference initiate(Map<String,String> config, String state) {
        String url = config.get('Authorize_URL__c')
            + '?client_id=' + config.get('Client_Id__c')
            + '&redirect_uri=' + config.get('Callback_URL__c')
            + '&response_type=code&state=' + state;
        return new PageReference(url);
    }

    global Auth.AuthProviderTokenResponse handleCallback(
        Map<String,String> config, Auth.AuthProviderCallbackState state) {
        // state.queryParameters의 code로 토큰 엔드포인트 콜아웃 → 토큰 파싱
        return new Auth.AuthProviderTokenResponse(
            'MyCustomAuthProvider', accessToken, refreshToken, state.queryParameters.get('state'));
    }

    global Auth.UserData getUserInfo(
        Map<String,String> config, Auth.AuthProviderTokenResponse response) {
        // 토큰으로 userinfo 콜아웃 → Auth.UserData 구성해 반환
        return userData;
    }

    global override Auth.OAuthRefreshResult refresh(
        Map<String,String> config, String refreshToken) {
        // refresh token으로 새 access token 발급
        return new Auth.OAuthRefreshResult(newAccessToken, refreshToken);
    }
}
```

---

## 관계 — Connected App · Named Credential 과 구분

Auth Provider는 **Salesforce가 OAuth 클라이언트일 때**(외부 IdP에 인증을 요청하는 쪽) 쓰는 개념이다. 방향이 반대이거나 목적이 다른 인접 기능과 헷갈리기 쉽다.

| 기능 | Salesforce의 역할 | 목적 |
|---|---|---|
| **Auth Provider** | OAuth **클라이언트** (외부 IdP를 신뢰) | 외부 계정으로 Salesforce 로그인(SSO), 또는 콜아웃 토큰 공급 |
| **External Auth Identity Provider** | OAuth **클라이언트** (외부 IdP를 신뢰) | 신모델 콜아웃 전용 OAuth 토큰 엔드포인트 컴포넌트 — External Credential이 참조. **패키징 가능** |
| **Connected App** | OAuth **서버/리소스** (외부 앱을 신뢰) | 외부 앱이 Salesforce API에 접근하도록 Salesforce가 토큰을 발급 |
| **Named Credential** | 콜아웃 **발신자** | 외부 시스템 URL+인증정보 저장. OAuth 인증이 필요하면 **Auth Provider 또는 External Auth Identity Provider를 참조**해 토큰 획득·갱신 |

핵심 연결: **Named Credential의 인증 방식으로 "Authentication Provider"를 선택하면**, 그 Named Credential을 쓰는 Apex 콜아웃(`callout:NC_Name`)은 Auth Provider가 관리하는 OAuth 토큰을 자동으로 붙이고, 만료 시 `refresh`로 갱신한다. 이 경우 Auth Provider는 로그인용이 아니라 순수 **토큰 공급기**로 동작하며 Registration Handler는 필요 없다.

### Auth Provider vs External Auth Identity Provider — 콜아웃 토큰 공급 갈림길

신모델(Named Credential → External Credential) 콜아웃 인증에서 OAuth 토큰을 공급하는 컴포넌트는 두 가지고, **콜아웃 토큰 공급 용도라면 Salesforce는 External Auth Identity Provider를 권장**한다.

| | **Auth Provider** (레거시 브로커) | **External Auth Identity Provider** (신모델) |
|---|---|---|
| 정체 | 인증 브로커. inbound SSO와 outbound 토큰을 겸함 | 콜아웃 전용 OAuth 토큰 엔드포인트 컴포넌트 |
| 소셜 로그인 / SSO | ✅ (Registration Handler 보유) | ❌ (콜아웃 토큰 공급만) |
| Registration Handler | 보유 (`Auth.RegistrationHandler`) | 없음 |
| 관리형 패키지 배포 | ❌ 불가 | ✅ 가능 |
| custom Apex | Custom 유형은 `Auth.AuthProviderPluginClass` 필요 | 표준 OAuth IdP면 custom Apex 불필요 옵션 |
| Metadata 타입 | `AuthProvider` | `ExternalAuthIdentityProvider` (v62.0 Winter '25 도입) |

Salesforce 공식 권고 원문은 *"use an externalAuthIdentityProvider instead of an authProvider"* — 즉 콜아웃 인증에서는 **신 External Auth Identity Provider가 권장 대체제, Auth Provider가 레거시**다. 단, **소셜 로그인·SSO(inbound)나 Registration Handler를 통한 사용자 생성·매핑**이 목적이면 그 용도는 여전히 Auth Provider(및 Custom 플러그인)의 몫이다. External Auth Identity Provider의 개념·필드·배선 절차는 [[Named Credential]]의 "External Auth Identity Provider" 절 참조.

---

## 관련 노트

- [[Named Credential]] — Auth Provider를 참조해 콜아웃 OAuth 토큰을 획득·갱신하는 발신 측 짝
- [[REST API]] — Auth Provider로 인증한 외부 사용자가 접근하는 Salesforce REST 표면
- [[Queueable + Callout 패턴]] — Named Credential(→ Auth Provider) 기반 비동기 외부 호출
- [[Secure Communications (TLS)]] — OAuth 콜아웃의 TLS/HTTPS 강제
- [[민감 데이터 저장]] — Consumer Secret·토큰 등 자격증명 보관 위협
- [[Auth Provider 소셜 로그인·SSO 구축 가이드]] — 이 개념을 실제로 세우는 절차(IdP 등록→Registration Handler→로그인 버튼)
- [[Connected App (연결된 앱) — OAuth 클라이언트]] — 방향이 반대인 OAuth 서버 측 개념
