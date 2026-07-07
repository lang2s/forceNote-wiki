---
tags: [integration, security, oauth, connected-app, api, sso, authentication]
source: help.salesforce.com — Connected Apps / OAuth Tokens and Scopes (remoteaccess_oauth_tokens_scopes), Manage OAuth Access Policies (connected_app_manage_oauth), Enable OAuth Settings for API Integration (connected_app_create_api_integration), OAuth 2.0 JWT Bearer Flow (remoteaccess_oauth_jwt_flow), Client Credentials Flow Setup (connected_app_client_credentials_setup), Rotate Consumer Key/Secret (connected_app_rotate_consumer_details) — Tier 2
created: 2026-07-06
aliases: [Connected App, 연결된 앱, Consumer Key, Consumer Secret, OAuth Client, OAuth Scopes, External Client App, OAuth Flow, Callback URL]
---

# Connected App (연결된 앱) — OAuth 클라이언트

> 외부 애플리케이션이 OAuth 2.0 · SAML · OpenID Connect로 Salesforce API와 SSO에 접근하도록 정의하는 클라이언트 등록. App Manager에서 만들고, Consumer Key/Secret·OAuth Scope·Callback URL·정책을 설정한다.

---

## 개념

**Connected App**은 외부 애플리케이션(모바일 앱, 서버 통합, 미들웨어, 타 시스템)이 표준 프로토콜(OAuth 2.0, SAML, OpenID Connect)을 통해 Salesforce에 연결하도록 **인증·권한 정보를 정의한 레코드**다. 외부 앱은 Salesforce에 "이 앱은 누구이고, 어떤 프로토콜로, 어떤 범위(scope)까지 접근하는가"를 Connected App으로 등록한 뒤에야 API 호출이나 SSO를 수행할 수 있다.

핵심은 **Connected App 자체는 인증을 수행하는 주체가 아니라 "OAuth 클라이언트의 신원(identity)과 정책"을 담은 정의**라는 점이다. 앱을 등록하면 Salesforce가 **Consumer Key**(client_id)와 **Consumer Secret**(client_secret) 쌍을 발급한다. 외부 앱은 이 자격 증명을 OAuth 토큰 요청 시 제출해 자신을 식별하고, Salesforce는 Connected App에 정의된 Scope·정책에 따라 접근을 허용한다.

Connected App은 크게 두 방향으로 쓰인다.

- **인바운드(inbound)**: 외부 앱 → Salesforce. 외부 시스템이 Salesforce REST/Bulk/SOAP API를 호출하거나 Salesforce를 IdP로 SSO 로그인. (이 노트의 주 초점)
- **아웃바운드(outbound)**: Salesforce → 외부. Salesforce가 다른 서비스에 OAuth로 콜아웃할 때는 [[Auth Provider (인증 공급자)]] + [[Named Credential]] 조합을 쓴다(아래 "관계" 섹션 참조).

> [!note] Spring '26 이후 — External Client App 권장
> Spring '26부터 Salesforce는 **신규 Connected App 생성을 제한**하고 후속 프레임워크인 **External Client App**을 권장한다. 기존 Connected App은 계속 사용·관리할 수 있다. External Client App은 OAuth 설정을 앱 정의와 정책(policy)으로 분리하고 패키징·버전 관리를 개선한 구조로, 개념(Consumer Key/Secret·Scope·Flow)은 동일하다. 새 통합을 만들 때는 External Client App을, 기존 자산은 Connected App을 이해하면 된다.

---

## 생성 절차 (App Manager)

Setup → **App Manager** → **New Connected App**(또는 New External Client App)에서 생성한다.

```
// 구조 예시 — 실제 Setup 화면 흐름 요약 (동작 코드 아님)
Setup
 └─ Apps → App Manager → [New Connected App]
     ├─ Basic Information
     │    · Connected App Name / API Name / Contact Email  (필수)
     ├─ API (Enable OAuth Settings)   ← OAuth로 API 접근 시 체크
     │    · Enable OAuth Settings ☑
     │    · Callback URL              (인증 코드/토큰을 돌려받을 URL, 여러 개 줄바꿈 구분)
     │    · Selected OAuth Scopes     (api, refresh_token, openid ...)
     │    · Require PKCE / Require Secret for Web Server Flow 등 보안 옵션
     │    → 저장 후 Consumer Key / Consumer Secret 발급
     ├─ Web App Settings (SAML)       ← SSO에 Salesforce를 서비스로 쓸 때
     └─ (저장 후) Manage → OAuth Policies / Session Policies
```

저장 직후에는 Consumer Key/Secret이 즉시 활성화되지 않고 **수 분(최대 약 10분) 전파 지연**이 있을 수 있다.

### OAuth 설정 핵심 필드

| 필드 | 설명 |
|---|---|
| **Enable OAuth Settings** | OAuth로 API에 접근하려면 반드시 체크. 이 체크가 있어야 Consumer Key/Secret이 발급된다. |
| **Callback URL** | Authorization Code/토큰을 돌려받을 리다이렉트 URI. 여러 개를 줄바꿈으로 등록 가능(누적 2000자 제한). 서버간 flow(JWT·Client Credentials)에서는 형식상 값만 필요하고 실제 리다이렉트는 없다. |
| **Selected OAuth Scopes** | 발급 토큰에 부여할 권한 범위(아래 표). |
| **Consumer Key** (client_id) | 앱을 식별하는 공개 식별자. |
| **Consumer Secret** (client_secret) | 앱을 증명하는 비밀 값. 노출 금지·회전 가능. |
| **Require Secret for Web Server Flow / Refresh Token Flow** | 토큰 교환 시 secret 요구 여부. |
| **Require Proof Key for Code Exchange (PKCE)** | Authorization Code flow에 PKCE 강제(공개 클라이언트 보안 권장). |

---

## OAuth Scopes (접근 범위)

Scope는 발급된 토큰이 가질 수 있는 권한을 정의한다. 앱이 요청하고 사용자가 승인한 scope에 한해 토큰이 접근을 갖는다.

| Scope | 의미 | 관련 토큰 |
|---|---|---|
| `api` | 로그인한 사용자 계정에 API로 접근 | Access Token |
| `refresh_token` (= `offline_access`) | Refresh Token 반환 허용(오프라인/장기 접근) | Refresh Token |
| `full` | 로그인 사용자가 접근 가능한 **모든 데이터** 접근(단, refresh_token은 별도) | Access Token |
| `web` | 웹에서 access_token 사용 허용 | Access Token |
| `openid` | OpenID Connect 규격의 서명된 ID Token 수신 | ID Token |
| `id` | Identity URL 서비스 접근 | Access Token |
| `chatter_api` | Connect REST API 일부 리소스 접근 | Access Token |
| `custom_permissions` | 조직의 Custom Permission 정보 접근 | Access Token |
| `visualforce` | 고객이 만든 Visualforce 페이지 접근 | Access Token |
| `content` | 하이브리드 앱의 content child session 획득 | Access Token |
| `lightning` | 하이브리드 앱의 Lightning child session 획득 | Access Token |
| `wave_api` | Analytics(Wave) REST API 리소스 접근 | Access Token |
| `eclair_api` | Analytics Charts Geodata 리소스 접근 | Access Token |
| `cdp_query_api` / `cdp_profile_api` / `cdp_ingest_api` | Data Cloud 쿼리 / 프로필 / 인제스트 API 접근 | Access Token |
| `pardot_api` | Marketing Cloud Account Engagement(Pardot) API 접근 | Access Token |
| `chatbot_api` | Einstein Bot API 접근 | Access Token |

> 최소 권한 원칙: 통합이 실제로 필요한 scope만 선택한다. API 호출만 하는 서버 통합이면 보통 `api` + (필요 시) `refresh_token`이면 충분하고, `full`은 지양한다.

---

## OAuth Flows — 언제 무엇을 쓰나

Connected App은 여러 OAuth 2.0 인증 flow를 지원한다. UI 유무·사용자 대화 필요 여부로 선택한다.

| Flow | 시나리오 | 사용자 대화(로그인) | 자격 증명 | 언제 |
|---|---|---|---|---|
| **Web Server (Authorization Code) + PKCE** | 서버측 웹앱이 사용자를 대신해 접근 | 필요(브라우저 리다이렉트) | Consumer Key/Secret + code | 사용자가 명시적으로 앱을 승인해야 하는 웹앱. **UI 있는 앱의 표준** |
| **User-Agent** | SPA·모바일 등 secret 저장 불가한 공개 클라이언트 | 필요 | Consumer Key (secret 없음) | 브라우저/모바일에서 클라이언트가 직접 토큰 수신(PKCE 병용 권장) |
| **JWT Bearer** | 서버간 무대화 통합(ETL·미들웨어) | 불필요 | 인증서로 서명한 JWT(secret 불필요) | **서버간 통합의 1순위.** UI 없이 API만 쓰는 백엔드. 사전 사용자 승인 후 인증서 신뢰로 무인 갱신 |
| **Client Credentials** | 앱 자신의 자격으로 서버간 접근 | 불필요 | Consumer Key/Secret | JWT를 못 쓸 때의 서버간 차선. **Run-As user**(실행 사용자)를 Connected App에 지정 필요. secret 유출 위험 유의 |
| **Device** | 입력 제한 기기(TV·IoT·CLI) | 별도 기기에서 코드 입력 | Consumer Key | 브라우저를 띄우기 어려운 기기 |
| **Username-Password** | 사용자명/비번을 직접 교환 | 불필요 | Key/Secret + username/password | **Summer '23 이후 생성된 org에서 기본 차단(blocked by default)** — 자격 증명을 앱이 보관해 보안이 취약하고, **External Client App에서는 아예 미지원**이다. 신규 통합 사용 금지, 레거시 한정. |

**선택 가이드:** 서버간(무 UI)이면 **JWT Bearer 우선 → 안 되면 Client Credentials**. UI가 있고 사용자 위임이 필요하면 **Web Server (Authorization Code) + PKCE**. Username-Password는 쓰지 않는다.

> [!warning] Username-Password Flow는 기본 차단된다
> **Summer '23(2023) 이후 생성된 org에서는 Username-Password flow가 기본 차단**되어, org의 Setup → OAuth and OpenID Connect Settings에서 명시적으로 허용하지 않는 한 토큰을 발급받지 못한다(`invalid_grant`). 후속 프레임워크인 **External Client App은 이 flow 자체를 지원하지 않는다.** 서버간 무대화 통합은 반드시 JWT Bearer(1순위) 또는 Client Credentials로 전환한다.
> 근거: help.salesforce.com — [Username-Password Flow Blocked by Default](https://help.salesforce.com/s/articleView?id=sf.remoteaccess_oauth_username_password_flow.htm), [Block Authorization Flows](https://help.salesforce.com/s/articleView?id=sf.security_authorization_flow_block.htm).

### Client Credentials flow의 Run-As user

Client Credentials flow에는 사용자 대화가 없으므로 토큰이 어느 사용자 컨텍스트로 동작할지 정해야 한다. Connected App의 **Manage → Client Credentials Flow → Run-As user**에 통합 전용 사용자를 지정하면, 발급된 access_token이 그 사용자의 권한으로 API를 수행한다.

### JWT Bearer flow — `Invalid JWT Signature` 트러블슈팅

JWT Bearer flow는 secret 대신 **인증서(개인 키)로 서명한 JWT**를 제출해 무인 인증한다. 이때 Connected App에는 **JWT 서명에 사용한 개인 키에 대응하는 인증서(공개 키)** 가 등록돼 있어야 하고, Salesforce가 그 인증서로 JWT 서명을 검증한다. 검증 실패 시 `HTTP 400 {"error":"invalid_grant","error_description":"Invalid JWT Signature."}`가 반환된다.

**외부에서 받은 개인 키를 쓸 때 (핵심 함정).** Salesforce에서 "Self-Signed Certificate"를 새로 생성하면 그 개인 키는 org 안에만 있어 외부로 내보낼 수 없다. 그래서 **외부(파트너·다른 시스템)에서 발급받은 개인 키/인증서 쌍**으로 JWT를 서명해야 하는 경우, self-signed로 새로 만들지 말고 그 키 쌍을 **Java Keystore(JKS)로 변환해 org에 import**해야 한다. Salesforce의 Certificate and Key Management는 **JKS 형식만** 개인 키 import를 지원한다.

```bash
# 구조 예시 — 실제 값은 발급받은 키/인증서로 대체 (동작 코드 아님)
# 1) 개인 키 + 인증서를 PKCS12로 묶는다 (OpenSSL)
openssl pkcs12 -export -in cert.pem -inkey private.key -out keystore.p12 -name jwtkey
# 2) PKCS12 → JKS로 변환 (keytool)
keytool -importkeystore \
  -srckeystore keystore.p12 -srcstoretype pkcs12 \
  -destkeystore server.jks -deststoretype JKS \
  -alias jwtkey
# ⚠️ 소스·대상 keystore 비밀번호를 동일하게 맞춘다 — 다르면 Salesforce가 업로드를 거부한다.
```

변환한 JKS를 **Setup → Security → Certificate and Key Management → Import from Keystore**로 올린 뒤, Connected App의 **Use digital signatures**에 그 인증서를 지정한다. JWT 헤더의 서명 알고리즘(RS256)과 org에 올린 인증서가 짝을 이뤄야 서명 검증이 통과한다.

**`Invalid JWT Signature`의 대표 원인:**

| 원인 | 설명 | 해결 |
|---|---|---|
| **잘못된 인증서 참조** | Connected App에 올린 인증서가 JWT를 서명한 개인 키와 다른 쌍(다른 self-signed를 올림). | JWT 서명 키에 **대응하는** 인증서를 import하고 앱의 "Use digital signatures"에 지정. |
| **인증서 만료** | Certificate and Key Management의 인증서가 만료. | 유효한 인증서로 교체(회전) 후 앱에 다시 지정. |
| **서명 알고리즘 불일치** | JWT를 RS256이 아닌 방식으로 서명하거나 키 형식이 안 맞음. | RS256으로 서명, JKS로 정상 import된 키 사용. |
| **keystore 비밀번호 불일치** | `-srcstorepass`와 `-deststorepass`가 달라 import 거부. | 소스·대상 비밀번호를 동일하게. |
| **잘못된 claim** | `iss`(Consumer Key)·`sub`(사용자명)·`aud`(로그인/테스트 도메인)가 안 맞아도 `invalid_grant`(서명과 별개). | Consumer Key·Run-As 사용자명·`aud`(`https://login.salesforce.com` 또는 `test.salesforce.com`) 확인. |

> 공식 참고: [Salesforce OAuth JWT Connection fails with invalid_grant / Invalid JWT Signature](https://help.salesforce.com/s/articleView?id=001122219&type=1) — 인증서/키 import 및 서명 검증 실패 원인. JKS import 절차는 [OAuth 2.0 JWT Bearer Flow (remoteaccess_oauth_jwt_flow)](https://help.salesforce.com/s/articleView?id=sf.remoteaccess_oauth_jwt_flow.htm) 참조.

---

## OAuth Policies (Manage → OAuth Policies)

앱 저장 후 **Manage**에서 접근 정책을 조정한다.

### Permitted Users (누가 앱을 쓸 수 있나)

| 옵션 | 의미 |
|---|---|
| **All users may self-authorize** (기본) | 로그인 성공한 모든 사용자가 최초 접근 시 앱을 스스로 승인해 사용. |
| **Admin approved users are pre-authorized** | 연결된 **Profile 또는 Permission Set**을 배정받은 사용자만 접근(사전 승인). 통합을 특정 사용자에 한정할 때 권장. |

### IP Relaxation (IP 제한 완화)

| 옵션 | 의미 |
|---|---|
| **Enforce IP restrictions** (기본) | 프로필의 조직 IP 범위 제한 적용. |
| **Enforce IP restrictions, but relax for refresh tokens** | 최초 접근엔 IP 제한, refresh token으로 새 access token 받을 땐 완화. |
| **Relax IP restrictions for activated devices** | 활성화된(인증된) 기기·허용 IP 범위에 대해 완화. |
| **Relax IP restrictions** | 앱 접근에 대한 조직 IP 제한 전부 해제. |

### Refresh Token Policy (Refresh Token 만료)

| 옵션 | 의미 |
|---|---|
| **Refresh token is valid until revoked** (기본) | 수동 폐기 전까지 무기한 유효. |
| **Immediately expire refresh token** | 즉시 무효화(기존 세션은 유지, 새 세션 발급 불가). |
| **Expire refresh token if not used for n** | n 기간 미사용 시 만료(사용 시 타이머 리셋). |
| **Expire refresh token after n** | 사용 여부와 무관하게 n 후 만료(고정 수명). |

이 외 **Session Policies**(Timeout Value 등)로 세션 지속 시간을 앱 단위로 조정할 수 있다.

### `invalid_grant: expired access/refresh token` 실전 원인

"몇 달 잘 돌던 통합이 어느 날 갑자기 죽는다"의 대표 증상이 refresh token 요청에 대한 `HTTP 400 {"error":"invalid_grant","error_description":"expired access/refresh token"}`이다. Refresh Token Policy를 "valid until revoked"로 둬서 만료를 꺼도 아래 사유로 토큰이 **폐기(revoke)** 되면 같은 에러가 난다. 원인별로 증상과 해결이 다르다.

| 원인 | 왜 발생 | 증상 | 해결 |
|---|---|---|---|
| **① 사용자·앱당 access grant 5개 한도 초과 (가장 흔한 함정)** | Salesforce는 **한 사용자 × 한 Connected App**에 대해 **access grant(= refresh token) 최대 5개**만 유지한다. 6번째 OAuth 승인이 발급되면 **가장 오래된 refresh token이 자동으로 무효화**된다. 통합 사용자로 여러 곳(여러 서버·재인증·다른 도구)이 같은 앱에 반복 로그인하면 오래된 통합의 토큰이 소리 없이 밀려나 폐기된다. | 멀쩡하던 통합이 어느 순간 `invalid_grant`. 코드·비밀·정책 변화가 전혀 없는데 실패. | 통합마다 **전용 Integration User를 분리**하거나 **Connected App을 분리**해 5개 한도를 공유하지 않게 한다. 폐기된 쪽은 재인증 필요. 한도 자체는 조정 불가. |
| **② 사용자 비밀번호 변경/리셋** | 사용자가 비밀번호를 바꾸거나 관리자가 리셋하면 Salesforce가 **그 사용자의 모든 access/refresh token을 폐기**한다. 끌 수 있는 옵션이 없다. | 비밀번호 변경 직후부터 토큰 갱신 실패. | 통합 전용 사용자의 비밀번호는 만료 정책에서 제외(비밀번호 만료 안 함)하고, 변경이 불가피하면 **재인증으로 새 토큰 쌍을 받는다.** |
| **③ Refresh Token Policy가 idle/absolute expiry** | 정책이 "Expire refresh token if not used for n"(유휴)이거나 "Expire refresh token after n"(고정 수명)이면 그 조건 도달 시 만료. | 일정 유휴/기간 후 규칙적으로 실패. | 정책을 "valid until revoked"로 바꾸거나, 유휴 기준을 통합 호출 주기보다 길게 잡는다. |

> [!warning] ①은 refresh token 만료를 꺼도 발생한다
> 5개 한도는 Refresh Token Policy와 **무관한 하드 한도**다. "valid until revoked"로 둬도 6번째 승인이 오면 최고참이 밀려난다. 여러 통합/서버가 하나의 사용자·앱 조합을 공유하지 않도록 설계하는 것이 근본 해법이다. 공식: [Manage OAuth Access Policies for a Connected App](https://help.salesforce.com/s/articleView?id=sf.connected_app_manage_oauth.htm) — access token/refresh token 폐기 조건. (Spring '24+부터는 External Client App에서 "갱신마다 새 refresh token 발급" 옵션을 켤 수 있으며, 이 경우 갱신 응답의 새 refresh token을 반드시 저장해야 이전 값이 폐기돼도 이어진다.)

---

## Connected App · Auth Provider · Named Credential 관계

세 개념은 자주 혼동되지만 역할이 다르다. OAuth "클라이언트 정의 → 토큰 획득 → 콜아웃 사용"의 사슬로 이해하면 명확하다.

```
// 구조 예시 — 아웃바운드(Salesforce → 외부) OAuth 콜아웃 체인
[Connected App / External Client App]   ← OAuth 클라이언트 정의(Consumer Key/Secret·Scope·Callback)
            │  (Key/Secret을 참조)
            ▼
[Auth Provider (인증 공급자)]            ← 그 자격으로 IdP에서 토큰을 획득/갱신하는 러너
            │  (인증 방식으로 연결)
            ▼
[Named Credential + External Credential] ← 콜아웃 시 인증을 자동 주입 (callout:NC_Name)
            │
            ▼
   Apex / Flow / External Services 콜아웃 (외부 API 호출)
```

| 개념 | 역할 | 방향 |
|---|---|---|
| **Connected App** | OAuth **클라이언트의 신원·정책**을 정의(Consumer Key/Secret 발급). "이 앱이 누구인가." | 인바운드 접근에 필수 / 아웃바운드에선 클라이언트 정의로 참조됨 |
| **[[Auth Provider (인증 공급자)]]** | Connected App의 Key/Secret을 참조해 **외부 IdP에서 토큰을 획득/갱신**. SSO 로그인의 IdP 등록에도 사용. | 주로 아웃바운드/SSO |
| **[[Named Credential]]** | 획득한 인증을 **아웃바운드 콜아웃에 자동 주입**(`callout:` 머지필드). URL·인증 분리. | 아웃바운드 |

정리:
- **외부 → Salesforce**(인바운드 API/SSO): Connected App만 있으면 성립. 외부 앱이 Consumer Key/Secret으로 토큰을 받아 API 호출.
- **Salesforce → 외부**(아웃바운드 콜아웃): Connected App(또는 외부 앱 정의)은 클라이언트 신원 역할, Auth Provider가 토큰 획득, Named Credential이 콜아웃에 그 인증을 붙인다.

---

## 배포·관리

- **패키징**: Connected App은 메타데이터(`ConnectedApp`)로 1GP/2GP 패키지에 포함해 배포할 수 있다. External Client App도 패키징을 지원한다.
- **Consumer Secret 회전**: 노출·주기적 갱신을 위해 **Manage Consumer Details → Rotate**로 Consumer Key/Secret을 회전할 수 있다. 회전 시 기존 값이 무효화되므로 소비 측 시스템의 자격 증명을 함께 갱신해야 한다.
- **모니터링**: Connected App Usage / OAuth 사용 로그로 어떤 앱이 어떤 사용자로 접근하는지 추적하고, 필요 시 특정 앱의 접근을 폐기(revoke)한다.

---

## ⚠️ 주의

- **`full` scope 남용 금지.** 통합이 필요로 하는 최소 scope만 선택한다. `full`은 로그인 사용자의 모든 데이터를 노출한다.
- **Username-Password flow는 쓰지 않는다.** Summer '23 이후 생성된 org에서 **기본 차단**되고 **External Client App은 미지원**이다. 자격 증명을 외부 앱이 보관하게 되어 취약하다. 서버간이면 JWT Bearer를 우선한다.
- **Consumer Secret은 비밀이다.** 소스·클라이언트 사이드(SPA/모바일)에 하드코딩하지 않는다. 공개 클라이언트는 secret 없는 flow(User-Agent·PKCE)를 쓴다.
- **Callback URL은 정확히 일치해야 한다.** OAuth flow에서 앱이 보내는 redirect_uri가 등록된 Callback URL과 정확히 일치하지 않으면 `redirect_uri_mismatch` 에러가 난다.
- **저장 후 전파 지연.** 새 Connected App/회전한 secret은 즉시 유효하지 않을 수 있다(수 분 대기).
- **Spring '26 신규 생성 차단.** Spring '26부터 새 Connected App은 **UI·API 양쪽에서 기본 생성 불가**하며, 한시적으로 Salesforce Support를 통해서만 예외 허용된다(이 예외 경로도 추후 제거 예정). 새 통합은 **External Client App**으로 만드는 것이 권장 경로다(개념 동일). 근거: help.salesforce.com — "New Connected Apps can no longer be created in Spring '26".
- **인바운드 API 접근에도 Connected App이 필요.** 외부에서 Salesforce API를 호출하려면 OAuth 클라이언트로 등록된 Connected App이 있어야 한다.

---

## 관련 노트
- [[External Client App (외부 클라이언트 앱)]] — Connected App의 차세대 후속(Spring '26부터 신규 OAuth 앱은 이걸로 생성)
- [[Named Credential]] — 아웃바운드 콜아웃에 인증을 자동 주입(`callout:`), OAuth Client Credentials 설정 짝
- [[Auth Provider (인증 공급자)]] — Connected App 자격으로 외부 IdP에서 토큰 획득 / SSO IdP 등록
- [[CSP와 RemoteSite]] — 외부 엔드포인트 호출 허용(CSP Trusted Site·Remote Site Setting) 보안 설정
- [[REST API]] — Connected App으로 인증한 뒤 호출하는 대표 인바운드 API
- [[Bulk API 2.0]] — 대량 데이터 인바운드 통합(동일한 OAuth 인증 사용)
- [[External Services]] — 외부 REST를 선언적으로 등록(Named Credential 인증 사용)
