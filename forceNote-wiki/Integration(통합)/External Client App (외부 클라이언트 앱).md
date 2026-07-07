---
tags: [integration, security, oauth, external-client-app, connected-app, api, packaging, spring26]
source: developer.salesforce.com — ExternalClientApplication (Metadata API Developer Guide, meta_externalclientapplication) · help.salesforce.com — External Client Apps (xcloud.external_client_apps), Configure the External Client App OAuth Settings (xcloud.configure_external_client_app_oauth_settings), Configure OAuth 2.0 JWT Bearer Flow for External Client Apps (xcloud.meta_configure_oauth_jwt_flow_external_client_apps), New Connected Apps can no longer be created in Spring '26 (Known Issue 005228017) — Tier 2
created: 2026-07-07
aliases: [External Client App, ECA, 외부 클라이언트 앱, ExternalClientApplication, ExtlClntAppOauthSettings, ExtlClntAppOauthConfigurablePolicies, Connected App 후속, OAuth 클라이언트 차세대]
---

# External Client App (외부 클라이언트 앱)

> Connected App의 차세대 후속 프레임워크. 외부 시스템이 OAuth 2.0으로 Salesforce에 접근하도록 정의하는 OAuth 클라이언트로, 개발자의 OAuth 설정과 관리자의 정책을 **별도 메타데이터 파일로 분리**하고 **2GP 패키징을 네이티브 지원**한다. Spring '26부터 신규 Connected App 생성이 차단되면서 새 통합의 권장 경로가 됐다.

---

## 개념 · 왜 도입됐나

**External Client App(ECA)** 은 외부 애플리케이션(서버 통합, 미들웨어, 모바일 앱, ISV 패키지)이 표준 OAuth 2.0 프로토콜로 Salesforce API·SSO에 접근하도록 정의하는 **OAuth 클라이언트 등록**이다. 기능적 목적은 [[Connected App (연결된 앱) — OAuth 클라이언트]]와 같다 — Consumer Key/Secret 발급, OAuth Scope·Callback URL·Flow·정책 정의. 다른 것은 **내부 구조와 거버넌스 모델**이다.

Connected App은 등장한 지 오래됐고 두 가지 고질적 문제가 있었다. ECA는 이를 겨냥해 재설계됐다.

| 개선 축 | Connected App의 문제 | External Client App의 해법 |
|---|---|---|
| **보안(secure-by-default)** | Connected App은 org에 만들면 **기본적으로 모든 org에서 사용 가능(open-by-default)** 한 모델. | ECA는 **사용할 각 org에 명시적으로 설치**돼야 접근 가능(secure-by-default). |
| **역할 분리** | 개발자 설정(OAuth)과 관리자 정책(누가 쓰나·IP·세션)이 **한 메타데이터 파일에 뒤섞임**. | 개발자의 OAuth 설정 파일과 관리자의 정책 파일을 **분리** — 개발자는 OAuth를, 관리자는 접근 정책을 독립적으로 관리. |
| **패키징·라이프사이클** | 1GP 전제로 설계돼 **2GP 패키징에 수동 우회가 필요**하고 배포에 며칠씩 걸리기도 했다. | 처음부터 **2GP를 위해 설계** — 버전 관리·배포·업그레이드가 표준 패키징 흐름에 올라탄다. |

> 근거: developer.salesforce.com — [ExternalClientApplication (Metadata API Developer Guide)](https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_externalclientapplication.htm), help.salesforce.com — [External Client Apps](https://help.salesforce.com/s/articleView?id=xcloud.external_client_apps.htm). ECA는 API v59.0(Summer '24)부터 사용 가능하며, `ExternalClientApplication` 메타데이터 타입 접근에는 Setup에서 **"Opt in to External Client Apps"** 권한 활성화가 필요하다.

---

## Connected App vs External Client App

같은 목적(OAuth 클라이언트 정의)을 서로 다른 구조로 달성한다.

| 항목 | Connected App | External Client App (ECA) |
|---|---|---|
| **메타데이터 모델** | 단일 `ConnectedApp` 파일에 OAuth 설정 + 정책 통합 | **다중 컴포넌트로 분리**: `ExternalClientApplication`(헤더) + `ExtlClntAppOauthSettings`(OAuth 설정, 개발자) + `ExtlClntAppOauthConfigurablePolicies`(OAuth 정책, 관리자) 등 |
| **접근 기본값** | open-by-default(모든 org에서 기본 사용 가능) | **secure-by-default**(각 org에 명시적 설치 필요) |
| **설정 vs 정책** | 한 파일에 혼재 | **개발자 OAuth 설정 파일 ↔ 관리자 정책 파일 분리** |
| **패키징** | 1GP 전제, 2GP는 수동 우회 필요 | **2GP 네이티브** |
| **정책 위치** | App 저장 후 Manage → OAuth Policies | 별도 정책(policy) 파일 (IP relaxation·session·refresh token) |
| **신규 생성(Spring '26~)** | **UI·API 양쪽에서 기본 차단**(패키지 설치 제외, Support 예외 한시) | **권장 경로 — 새 통합은 ECA로 생성** |
| **미지원 OAuth 플로우** | (대부분 지원) | **SAML Bearer Assertion Flow · Username-Password Flow 미지원** |
| **기존 자산** | 계속 동작·관리 가능(은퇴 아님) | 신규 표준 |

### 메타데이터 컴포넌트 (구조)

ECA는 하나의 파일이 아니라 여러 메타데이터 타입의 묶음이다. 일부만 패키징 가능하다.

| 메타데이터 타입 | 담는 내용 | 성격 | 패키징 |
|---|---|---|---|
| **`ExternalClientApplication`** | ECA 헤더(연락처·설명·아이콘/로고 URL·org 스코프 ID·distributionState 등) | 앱 정의(개발자) | ✅ 패키징 가능 |
| **`ExtlClntAppOauthSettings`** | OAuth 설정 — Consumer Key/Secret·Callback URL·Scope·PKCE 등 | OAuth 설정(개발자) | ✅ 패키징 가능 |
| **`ExtlClntAppGlobalOauthSettings`** | 소스 org의 글로벌 OAuth 설정(키·시크릿 등을 저장) | 글로벌 설정 | (글로벌 연관) |
| **`ExtlClntAppOauthConfigurablePolicies`** | OAuth 정책 — Permitted Users·IP relaxation·refresh token·session | 정책(관리자) | 정책 파일 |
| **`ExtlClntAppConfigurablePolicies`** | 일반 구성 정책 | 정책(관리자) | 정책 파일 |

```xml
<!-- 구조 예시 — package.xml 발췌, 실제 배포 매니페스트 아님 -->
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <types>
    <members>*</members>
    <name>ExternalClientApplication</name>
  </types>
  <types>
    <members>*</members>
    <name>ExtlClntAppOauthSettings</name>
  </types>
  <types>
    <members>*</members>
    <name>ExtlClntAppOauthConfigurablePolicies</name>
  </types>
  <version>59.0</version>
</Package>
```

> 핵심: 패키징 가능한 타입은 **`ExternalClientApplication` + `ExtlClntAppOauthSettings`** 두 개다. 정책(policy) 파일은 org별 관리자가 소유하는 로컬 설정으로, 개발자 설정과 분리돼 있다.

---

## 생성 · 구성 개요

Setup → **App Manager** → **New External Client App**(또는 Metadata API로 배포)에서 만든다. 상세 필드 전수는 별도 필드 레퍼런스 노트로 위임한다(현재 미작성).

```
// 구조 예시 — ECA 구성 흐름 요약 (동작 코드 아님)
External Client App
 ├─ (개발자) OAuth Settings  →  ExtlClntAppOauthSettings
 │    · Enable OAuth ☑
 │    · Callback URL / Selected OAuth Scopes
 │    · Require PKCE / Require Secret ...
 │    → Consumer Key / Consumer Secret
 └─ (관리자) Policies        →  ExtlClntAppOauthConfigurablePolicies
      · Permitted Users (Admin approved users are pre-authorized 등)
      · IP Relaxation / Enforce Refresh Token IP Allowlist
      · Refresh Token Policy (idle/absolute expiry)
      · Session Policies (Timeout)
```

### OAuth Settings (개발자 영역)

- **Consumer Key / Consumer Secret** — 앱 식별·증명 자격(client_id / client_secret).
- **Callback URL** — Authorization Code/토큰 리다이렉트 URI.
- **Selected OAuth Scopes** — `api`·`refresh_token`·`openid` 등(Connected App과 동일한 scope 체계).
- **Require PKCE / Require Secret** — Authorization Code flow 보안 옵션.

### Policies (관리자 영역)

- **Permitted Users** — `Admin approved users are pre-authorized`로 두면 self-authorize를 막고 **Permission Set 배정으로만** 접근을 부여한다.
- **IP Relaxation / Enforce Refresh Token IP Allowlist** — 켜면 허용 IP 범위에서만 web server flow·refresh token flow가 완료된다.
- **Refresh Token Policy** — idle/absolute 만료를 정책 파일에서 설정(휴면 통합의 공격 표면 축소).
- **Session Policies** — 세션 Timeout.

### 지원 OAuth 플로우

| Flow | 지원 | 비고 |
|---|---|---|
| **Web Server (Authorization Code) + PKCE** | ✅ | UI 있는 위임 접근 |
| **JWT Bearer** | ✅ | 서버간 무대화 통합 1순위(인증서 서명, secret 불필요) |
| **Client Credentials** | ✅ | 앱 자신의 자격으로 서버간 접근(Run-As user 필요) |
| **User-Agent / Token Exchange / Device** | ✅ | 공개 클라이언트·페더레이션 identity·입력 제한 기기 |
| **SAML Bearer Assertion** | ❌ 미지원 | ECA가 커버하지 않는 CA 기능 |
| **Username-Password** | ❌ 미지원 | ECA 자체가 지원하지 않음(레거시·기본 차단 flow) |

> 근거: help.salesforce.com — [Configure the External Client App OAuth Settings](https://help.salesforce.com/s/articleView?id=xcloud.configure_external_client_app_oauth_settings.htm), [Configure OAuth 2.0 JWT Bearer Flow for External Client Apps](https://help.salesforce.com/s/articleView?id=xcloud.meta_configure_oauth_jwt_flow_external_client_apps.htm). Scope·Consumer Key/Secret·PKCE 등 OAuth 개념 자체는 [[Connected App (연결된 앱) — OAuth 클라이언트]]와 동일하므로, 그 노트의 Scope·Flow·JWT 트러블슈팅을 그대로 참고한다.

---

## 현재 상태 · 타임라인

- **GA / 도입**: ECA는 API v59.0(Summer '24)부터 제공되며 이후 확장됐다.
- **Spring '26 — 신규 Connected App 생성 차단**: Spring '26부터 **새 Connected App은 UI·API 양쪽에서 기본 생성 불가**(패키지 설치는 예외). 고객은 이 동작을 스스로 켤 수 없고, **한시적으로 Salesforce Support에 요청해야만** 신규 Connected App을 만들 수 있다. **향후 릴리스에서는 이 Support 예외 경로도 제거**될 예정이다.
- **기존 Connected App은 계속 동작**: Spring '26 제한은 **신규 생성만** 막는다. 이미 존재하는 Connected App은 그대로 작동·관리된다. **은퇴(retire)가 아니다.**
- **마이그레이션 경로**: 패키징으로 배포되지 않는 **로컬 Connected App**은 자동 마이그레이션이 제공된다 — **App Manager**에서 해당 앱의 **"Migrate to External Client App"** 을 선택하면 OAuth·SAML 활성 Connected App을 ECA로 변환한다. ISV·패키지 배포용 CA는 별도 마이그레이션 가이드를 따른다.

> 근거: help.salesforce.com — [New Connected Apps can no longer be created in Spring '26](https://help.salesforce.com/s/articleView?id=005228017&type=1). 요약: 신규 생성 차단(UI+API, 패키지 설치 예외) · Support 예외 한시 후 제거 · 기존 앱 유지 · 로컬 CA는 App Manager에서 ECA로 마이그레이션.

---

## ⚠️ 주의

- **새 통합은 ECA로.** Spring '26 이후 새 Connected App 생성은 기본 차단이므로, 신규 OAuth 클라이언트가 필요하면 External Client App으로 만든다.
- **secure-by-default = 각 org 설치 필요.** ECA는 CA와 달리 자동으로 모든 org에서 쓸 수 없다. 사용할 org마다 명시적으로 설치·활성화한다.
- **Username-Password / SAML Bearer는 못 쓴다.** 이 두 flow가 필요한 레거시 통합은 ECA로 그대로 옮길 수 없다 — JWT Bearer·Client Credentials 등으로 재설계한다.
- **정책과 설정이 분리돼 있다.** OAuth 설정을 바꾸는 주체(개발자)와 접근 정책을 바꾸는 주체(관리자)가 다른 파일을 만진다. 배포 시 두 파일의 소유·버전을 구분한다.
- **"Opt in to External Client Apps" 권한.** `ExternalClientApplication` 메타데이터에 접근하려면 Setup에서 이 옵션을 켜야 한다.

---

## 관련 노트
- [[Connected App (연결된 앱) — OAuth 클라이언트]] — 전신(前身). OAuth Scope·Flow·Policy·JWT/Client Credentials 트러블슈팅의 상세는 이 노트가 정본이며 ECA도 동일 개념을 따른다
- [[Named Credential]] — 아웃바운드 콜아웃에 인증 자동 주입(`callout:`), OAuth Client Credentials 설정 짝
- [[Auth Provider (인증 공급자)]] — OAuth 클라이언트 자격으로 외부 IdP에서 토큰 획득 / SSO IdP 등록
- [[통합 MOC]] — Integration 섹션 목차
