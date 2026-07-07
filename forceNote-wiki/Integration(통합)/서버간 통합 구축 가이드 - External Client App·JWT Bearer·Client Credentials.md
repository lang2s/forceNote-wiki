---
tags: [integration, security, oauth, jwt-bearer, client-credentials, external-client-app, server-to-server, named-credential, how-to]
source: help.salesforce.com — OAuth 2.0 JWT Bearer Flow for Server-to-Server Integration (remoteaccess_oauth_jwt_flow), Configure OAuth 2.0 JWT Bearer Flow for External Client Apps (xcloud.meta_configure_oauth_jwt_flow_external_client_apps), Configure a Connected App for the OAuth 2.0 Client Credentials Flow (connected_app_client_credentials_setup), OAuth 2.0 Client Credentials Flow for Server-to-Server Integration (remoteaccess_oauth_client_credentials_flow), Create or Edit an OAuth External Credential with the JWT Bearer Flow (nc_create_edit_oath_jwt_bearer_ext_cred) · developer.salesforce.com — Create a Private Key and Self-Signed Digital Certificate (sfdx_dev_auth_key_and_cert), Using the Client Credentials Flow for Easier API Authentication (blog 2023-03) — Tier 2
created: 2026-07-07
aliases: [서버간 통합 구축, server-to-server integration, headless integration, JWT Bearer 설정, Client Credentials 설정, JWT vs Client Credentials, 서버 투 서버 OAuth, 배치 통합 인증, integration setup guide]
---

# 서버간 통합 구축 가이드 - External Client App·JWT Bearer·Client Credentials

> 사용자 개입이 없는 서버간(server-to-server)/헤드리스/배치 통합을 **처음부터 끝까지** 세우는 실전 절차. 인증 클라이언트는 **[[External Client App (외부 클라이언트 앱)]]**(Spring '26부터 신규 Connected App 생성 차단으로 권장 경로), 플로우는 브라우저 로그인이 없는 **JWT Bearer** 또는 **Client Credentials** 둘 중 하나. 개념 상세는 링크로 위임하고 여기서는 "따라 하면 되는 단계"만 다룬다.

---

## 1. 언제 이 조합인가 & 플로우 선택

**대상:** 미들웨어(MuleSoft·Boomi)·ERP·CI/CD 파이프라인·야간 배치·백엔드 마이크로서비스처럼 **사람이 브라우저에서 로그인하지 않는** 통합. 이런 흐름은 authorization code / device flow처럼 사용자 상호작용을 요구하는 플로우를 쓸 수 없다. 남는 선택지는 **JWT Bearer**(비대칭 인증서 서명)와 **Client Credentials**(Consumer Secret + Run-As 사용자) 둘이다.

두 플로우 모두 **refresh token을 발급하지 않는다** — access token 만료 시마다 다시 토큰을 받는다(JWT는 새 assertion 서명, Client Credentials는 재요청).

### JWT Bearer vs Client Credentials — 선택 기준표

| 기준 | JWT Bearer | Client Credentials |
|---|---|---|
| **신뢰 모델** | 비대칭 — 클라이언트가 **private key**로 JWT 서명, Salesforce가 업로드된 인증서(공개키)로 검증. 비밀이 네트워크로 전송되지 않음 | 대칭 — **Consumer Secret**을 토큰 요청 본문에 직접 전송 |
| **인증서 관리** | 필요 — 키페어 생성·인증서 업로드·**만료 갱신** 부담 | 불필요 — secret 문자열만 |
| **사용자 컨텍스트** | JWT `sub` 클레임의 **특정 사용자**로 실행 (사용자별 데이터 가시성/공유 규칙 적용) | 앱에 고정된 **Run-As 사용자** 하나로 실행 (요청마다 바꿀 수 없음) |
| **secret 유출 위험** | 낮음 — private key는 전송되지 않음. 유출 시 인증서만 교체 | 상대적으로 높음 — secret이 매 요청 본문에 담김. 유출 시 즉시 rotate 필요 |
| **사전 승인 필요** | **필요** — 통합 사용자를 profile/permission set로 pre-authorize (안 하면 `user hasn't approved this consumer`) | 불필요 — Run-As 사용자 지정이 곧 승인 |
| **설정 난이도** | 높음(키/인증서 파이프라인) | 낮음(체크박스 + Run-As 지정) |
| **적합 상황** | 여러 통합 사용자를 오가야 하거나, secret을 절대 전송하지 않는 고보안 요건, CI/CD | 단일 시스템 계정으로 충분하고 빠르게 세우고 싶을 때 |

> 요약: **인증서를 관리할 수 있고 사용자 컨텍스트/최고 보안이 중요하면 JWT Bearer**, **가장 단순하게 단일 시스템 계정으로 API를 부르면 Client Credentials.**

---

## 2. 사전 준비 (두 경로 공통)

1. **전용 통합 사용자 생성** — 사람 라이선스가 아니라 API-Only 통합 사용자로 실행한다. UI 로그인 차단, 최소권한 프로파일 + Permission Set. 상세는 **[[Integration User & API-Only User (통합 사용자)]]**. Client Credentials의 Run-As, JWT Bearer의 `sub`가 모두 이 사용자를 가리킨다.
2. **My Domain 활성화 확인** — 토큰 엔드포인트는 `https://<MyDomain>.my.salesforce.com/services/oauth2/token`을 쓴다(로그인 URL은 `login`/`test`도 가능하나 org별 My Domain 권장).
3. **scope 최소화 원칙** — 통합이 실제로 하는 일만 준다. REST/SOQL만 하면 `api`, 토큰 재발급 흐름이 필요없으니 `refresh_token`은 서버간에선 대개 불필요. 과도한 `full`·`web` scope 지양.

---

## 3. 경로 A — JWT Bearer 전 과정

### 3a. 키/인증서 생성

**옵션 1 — openssl로 self-signed 인증서 만들기** (CI/CD에서 흔함). 공식 SFDX 가이드 절차:

```bash
# 1) passphrase 붙은 RSA 개인키 생성
openssl genrsa -des3 -passout pass:SomePass -out server.pass.key 2048
# 2) passphrase 제거한 실사용 개인키
openssl rsa -passin pass:SomePass -in server.pass.key -out server.key
rm server.pass.key
# 3) CSR 생성 (대화형 입력)
openssl req -new -key server.key -out server.csr
# 4) 365일 유효한 self-signed 인증서 (RS256/SHA-256)
openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt
```

결과물: `server.key`(**JWT 서명용 개인키 — 클라이언트가 안전 보관**), `server.crt`(**Salesforce에 업로드할 인증서**).

**옵션 2 — Setup의 Certificate and Key Management에서 자체서명 인증서 생성** — Setup → Security → Certificate and Key Management → **Create Self-Signed Certificate**. 개인키가 Salesforce 밖으로 나오지 않는 대신, 클라이언트가 서명하려면 개인키가 필요하므로 외부 서명 클라이언트에는 옵션 1이 일반적이다.

**외부에서 만든 키를 org에 JKS로 넣어야 할 때** — Certificate and Key Management는 **JKS 형식만** 임포트한다(인증서 4KB 이하; 초과 시 DER 인코딩으로 축소). PKCS12로 묶은 뒤 keytool로 변환:

```bash
# server.crt + server.key → PKCS12 → JKS
openssl pkcs12 -export -in server.crt -inkey server.key -out keystore.p12
keytool -importkeystore -srckeystore keystore.p12 -srcstoretype pkcs12 \
        -destkeystore cert.jks -deststoretype JKS
# alias 1은 Salesforce가 거부하므로 재명명
keytool -keystore cert.jks -changealias -alias 1 -destalias jwt_cert
```

### 3b. External Client App 생성

Setup → **App Manager** → **New External Client App**. OAuth Settings에서:

| 설정 | 값 |
|---|---|
| **Callback URL** | 서버간에는 실제로 리다이렉트가 없지만 폼상 필수 — `https://login.salesforce.com/services/oauth2/callback` 같은 placeholder 입력 |
| **Selected OAuth Scopes** | 최소 필요분. 예: `Manage user data via APIs (api)`. 필요 시 `refresh_token` |
| **Use digital signatures** | 체크 → **3a의 `server.crt` 업로드** (Salesforce가 JWT 서명 검증에 사용) |
| **Consumer Key** | 저장 후 발급됨 — JWT의 `iss` 클레임에 사용. (Consumer Details에서 확인) |

> ECA는 개발자의 OAuth 설정(`ExtlClntAppGlobalOauthSettings`)과 관리자의 정책을 **별도 메타데이터**로 분리한다. 필드·메타데이터 구조 상세는 **[[External Client App (외부 클라이언트 앱)]]**.

### 3c. 정책 / 사전 승인 (JWT의 핵심 함정)

JWT Bearer는 사용자 상호작용이 없으므로 **클라이언트 앱이 사전 승인**돼 있어야 한다. ECA 정책에서:

1. **Permitted Users = Admin approved users are pre-authorized** 로 설정.
2. 통합 사용자에게 **Permission Set(또는 Profile)** 을 만들어 이 ECA를 할당(assign) → 사전 승인.

이 단계를 빼면 토큰 요청이 다음 에러로 실패한다:

```
{ "error": "invalid_grant", "error_description": "user hasn't approved this consumer" }
```

### 3d. 토큰 요청

**JWT assertion 구성** (header + claims, RS256으로 서명):

```jsonc
// 구조 예시 — 실제 서명된 JWT 아님 (라이브러리로 base64url 인코딩·RS256 서명)
// Header
{ "alg": "RS256" }
// Claims
{
  "iss": "<Consumer Key>",                     // ECA의 Consumer Key
  "sub": "integration.user@example.com",       // 실행할 통합 사용자 username
  "aud": "https://login.salesforce.com",       // 프로덕션. 샌드박스는 https://test.salesforce.com
  "exp": 1751000000                            // 현재+최대 5분 (epoch seconds). Salesforce는 3분 clock skew 허용
}
```

- **서명:** `base64url(header) + "." + base64url(claims)` 문자열을 **개인키(`server.key`)로 RS256 서명** → base64url 서명을 뒤에 붙여 완성된 JWT.
- `exp`는 발급 시점 기준 최대 **5분** 이내여야 한다(초과 시 `invalid_grant`).

**토큰 엔드포인트 호출:**

```bash
curl https://<MyDomain>.my.salesforce.com/services/oauth2/token \
  -d 'grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer' \
  --data-urlencode 'assertion=<완성된 JWT>'
```

**응답 (refresh_token 없음):**

```jsonc
// 구조 예시 — 실제 토큰 값 아님
{
  "access_token": "00D...!AR8...",
  "scope": "api",
  "instance_url": "https://<MyDomain>.my.salesforce.com",
  "id": "https://login.salesforce.com/id/00D.../005...",
  "token_type": "Bearer"
}
```

이후 API 호출은 `Authorization: Bearer <access_token>` + `instance_url` 기준.

---

## 4. 경로 B — Client Credentials 전 과정

### 4a. External Client App 설정

New External Client App → OAuth Settings:

| 설정 | 값 |
|---|---|
| **Selected OAuth Scopes** | 최소 필요분 (예: `api`) |
| **Enable Client Credentials Flow** | 체크 (OAuth 설정 저장 후 정책에서 활성) |
| **Consumer Key / Consumer Secret** | Consumer Details에서 확보 → 토큰 요청의 `client_id`/`client_secret` |

**Run-As 사용자 지정** — 정책(Policies) 편집에서 **Client Credentials Flow → Run As**에 **통합 사용자**를 지정한다. 사용자 상호작용이 없어도 Salesforce의 모든 실행은 사용자 컨텍스트가 필요하므로, 발급되는 토큰은 이 Run-As 사용자로 동작한다. Enterprise Edition에서는 **API Only User** 권한을 가진 실행 사용자를 권장.

> ⚠️ ECA 배포 순서: ECA 배포 → OAuth 활성화 → 정책 배포. OAuth 활성화 전에 정책을 먼저 배포하면 `The OAuth settings are missing for this external client app` 에러.

### 4b. 토큰 요청

```bash
curl https://<MyDomain>.my.salesforce.com/services/oauth2/token \
  -d 'grant_type=client_credentials' \
  -d 'client_id=<Consumer Key>' \
  -d 'client_secret=<Consumer Secret>'
```

**응답 (refresh_token 없음):**

```jsonc
// 구조 예시 — 실제 토큰 값 아님
{
  "access_token": "00D...!AQ4...",
  "token_type": "Bearer",
  "instance_url": "https://<MyDomain>.my.salesforce.com",
  "issued_at": "1678896515748"
}
```

---

## 5. Apex 콜아웃 소비 측 배선 (Named Credential + External Credential)

토큰을 코드에서 손수 관리하지 말고 **[[Named Credential]] + External Credential**로 감싸면 Salesforce가 토큰 획득·갱신·헤더 주입을 대신한다. Apex/Flow는 `callout:<NamedCredential>/path` 만 부른다.

1. **External Credential 생성** — Setup → Named Credentials → External Credentials → New.
   - **Authentication Protocol = OAuth 2.0**
   - **Authentication Flow Type = JWT Bearer** (경로 A) **또는 Client Credentials** (경로 B)
   - JWT Bearer면 `iss`/`sub`/`aud`·**서명 인증서(Signing Certificate)**·scope를, Client Credentials면 Consumer Key/Secret·scope를 채운다.
   - **Principal**(Named Principal) 지정 → 실행 컨텍스트.
2. **Named Credential 생성** — 이 External Credential을 참조하고 **URL**(외부 시스템 base URL)을 지정.
3. **Permission Set에 External Credential Principal 접근 부여** — 통합 사용자/러닝 사용자에게 principal access를 줘야 콜아웃이 인증된다.
4. **Apex에서 사용:**

```apex
// 구조 예시 — Named Credential 이름·경로는 실제 org 값으로 대체
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:My_Server_NC/services/data/v61.0/sobjects/Account');
req.setMethod('GET');
HttpResponse res = new Http().send(req);   // 토큰 헤더는 플랫폼이 자동 주입
```

> External Credential/Named Credential의 **필드 전수**(Identity Type, Named vs Per-User Principal, Authentication Parameter, Allowed Namespaces 등)는 **[[Named Credential·External Credential 생성 필드 전수 레퍼런스]]**로 위임.

---

## 6. 검증 · 트러블슈팅

**성공 확인:** 받은 access token으로 identity 호출 → 실행 사용자 확인.

```bash
curl https://<MyDomain>.my.salesforce.com/services/oauth2/userinfo \
  -H "Authorization: Bearer <access_token>"
# → 통합 사용자(JWT sub 또는 Client Credentials Run-As)의 신원이 나오면 정상
```

| 에러 | 원인 | 해결 |
|---|---|---|
| `invalid_grant` + `user hasn't approved this consumer` | JWT Bearer에서 통합 사용자가 사전 승인 안 됨 | 3c — Permitted Users = admin pre-authorized + Permission Set 할당 |
| `invalid_grant` (JWT 일반) | `exp`가 5분 초과 / `aud` 불일치(login vs test) / `sub` username 오타 / 클럭 skew | claims 재점검, 샌드박스는 `aud=https://test.salesforce.com` |
| `Invalid JWT Signature` | 업로드한 인증서와 서명 개인키 불일치 / 잘못된 알고리즘 | 3b에서 올린 `server.crt`가 서명에 쓴 `server.key`의 짝인지 확인, RS256 사용 |
| `invalid_client` / `invalid_client_id` | Client Credentials에서 Consumer Key/Secret 오타 또는 rotate됨 | Consumer Details 재확인, secret 재발급 시 갱신 |
| `INVALID_SESSION_ID` (API 호출 시) | 만료된 access token 재사용 / 잘못된 `instance_url` | 응답의 `instance_url`로 호출, 만료 시 재발급 |

플로우별 OAuth 클라이언트 설정·정책 트러블슈팅 상세는 **[[Connected App (연결된 앱) — OAuth 클라이언트]]** 참조.

---

## 7. 보안 베스트 프랙티스

- **최소 scope** — 통합이 실제로 쓰는 것만(`api` 위주). `full`·`web`·불필요한 `refresh_token` 지양.
- **통합 사용자 격리** — 사람 계정 재사용 금지. API-Only 전용 사용자에 최소권한 Permission Set. JWT `sub`/Client Credentials Run-As 모두 이 사용자로.
- **secret/키 보관** — Client Credentials Secret과 JWT private key는 시크릿 매니저(Vault·환경변수)에 저장, 소스/로그에 하드코딩 금지. 가능하면 소비 측을 Named Credential로 감싸 org가 자격증명을 보관하게 한다.
- **인증서 만료 관리** — JWT 인증서는 유효기간(예 365일)이 있어 **만료 전 롤오버** 필요. 만료되면 전 통합이 `Invalid JWT Signature`로 중단된다. 갱신 알림/자동화 구축.
- **secret rotate 절차** — 유출·정기 교체 시 Consumer Secret rotate 후 클라이언트 즉시 갱신. JWT는 인증서 교체로 대응(전송되는 비밀이 없어 노출면이 작음).
- **신규 통합은 External Client App** — Spring '26부터 신규 Connected App 생성이 차단되므로 새 서버간 통합은 ECA로 시작한다.

---

## 관련 노트
- [[External Client App (외부 클라이언트 앱)]]
- [[Connected App (연결된 앱) — OAuth 클라이언트]]
- [[Integration User & API-Only User (통합 사용자)]]
- [[Named Credential]]
- [[Named Credential·External Credential 생성 필드 전수 레퍼런스]]
- [[통합 MOC]]
