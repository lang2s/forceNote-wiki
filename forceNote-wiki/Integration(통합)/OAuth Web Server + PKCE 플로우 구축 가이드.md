---
tags: [integration, security, oauth, web-server-flow, pkce, authorization-code, refresh-token, how-to]
source: help.salesforce.com — OAuth 2.0 Web Server Flow for Web App Integration (remoteaccess_oauth_web_server_flow), Proof Key for Code Exchange (PKCE) Extension (remoteaccess_pkce), Enabling PKCE for OAuth for Salesforce External Client and Connected Apps (005316703), OAuth Tokens and Scopes (remoteaccess_oauth_tokens_scopes), Configure the External Client App OAuth Settings (xcloud.configure_external_client_app_oauth_settings) · trailhead.salesforce.com — Implementing OAuth 2.0 Web Server Flow for Salesforce — Tier 2
created: 2026-07-07
aliases: [OAuth Web Server Flow, Web Server Flow, Authorization Code Flow, PKCE, code_verifier, code_challenge, S256, 웹 서버 플로우, 인가 코드 플로우, 사용자 위임 OAuth, 브라우저 OAuth]
---

# OAuth Web Server + PKCE 플로우 구축 가이드

> 브라우저에서 **사용자가 직접 로그인·승인**하는 웹앱용 OAuth를 처음부터 세우는 실전 절차. 인가 코드(authorization code) + PKCE로 access/refresh 토큰을 받는 5단계를 따라 한다. 개념·필드 상세는 링크로 위임하고 여기서는 "따라 하면 되는 단계"만 다룬다.

---

## 1. 언제 이 플로우인가 (server-to-server와 대비)

**UI가 있는 웹앱**이 로그인한 **사용자 컨텍스트로** Salesforce에 접근할 때 — 즉 각 사용자를 브라우저로 Salesforce에 리디렉트해 로그인·동의를 받아야 할 때 이 Web Server(Authorization Code) 플로우를 쓴다. 반대로 사용자 개입 없는 배치·백엔드 통합(서버간)은 JWT Bearer / Client Credentials → **[[서버간 통합 구축 가이드 - External Client App·JWT Bearer·Client Credentials]]**.

| 축 | 이 노트 (Web Server + PKCE) | 서버간 (JWT / Client Credentials) |
|---|---|---|
| 브라우저 로그인 | **있음** (사용자 승인) | 없음 |
| 토큰 주체 | 로그인한 사용자 | 실행 사용자(고정) |
| refresh_token | 발급 가능 | 없음(재요청) |

---

## 2. 준비 — OAuth 클라이언트 생성 (필드 상세는 링크 위임)

Setup에서 **External Client App**(Spring '26부터 신규 Connected App 생성 차단 → 권장 경로) 또는 기존 Connected App을 만들고 OAuth를 활성화한다. 필드 하나하나의 의미는 아래로 위임하고, 이 플로우에 **필수인 항목만** 짚는다.

- **Enable OAuth Settings** 체크
- **Callback URL** — 인가 코드를 되받을 앱의 정확한 리디렉트 URL. token 교환의 `redirect_uri`와 **문자 단위로 일치**해야 함(뒤 슬래시·포트 포함). 복수 등록 가능.
- **Selected OAuth Scopes** — 최소 필요 scope만. refresh_token을 받으려면 `refresh_token`(=`offline_access`) scope 포함, API 접근엔 `api`, OpenID엔 `openid`.
- **Require Proof Key for Code Exchange (PKCE)** — 체크 권장(ISV 클라이언트 앱은 **필수**). 이 가이드는 PKCE 사용을 전제로 함.
- **Require Secret for Web Server Flow** — 서버 측에서 client_secret을 안전히 보관하는 confidential 클라이언트면 체크. SPA 등 secret을 숨길 수 없는 public 클라이언트면 해제하고 PKCE로만 보호.

> 필드 전수·정책 상세 → **[[Connected App (연결된 앱) — OAuth 클라이언트]]** · **[[External Client App (외부 클라이언트 앱)]]**. Named Credential로 이 토큰을 관리한다면 → **[[Named Credential·External Credential 생성 필드 전수 레퍼런스]]**.

엔드포인트는 org의 My Domain을 씀:
- authorize: `https://MyDomainName.my.salesforce.com/services/oauth2/authorize`
- token: `https://MyDomainName.my.salesforce.com/services/oauth2/token`

---

## 3. 단계별 절차

### (a) code_verifier → code_challenge (S256)

`code_verifier`는 43–128자의 강한 랜덤 문자열([A-Z a-z 0-9 - . _ ~]). `code_challenge`는 그 verifier를 SHA-256 해시 후 **base64url(패딩 제거)** 인코딩한 값. Salesforce는 해시 알고리즘으로 **S256만** 지원한다.

```js
// 구조 예시 — Node.js. 실제 배포 시 crypto 안전 랜덤 사용
import crypto from 'crypto';

const base64url = (buf) =>
  buf.toString('base64').replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');

const code_verifier  = base64url(crypto.randomBytes(64));           // 43~128자
const code_challenge = base64url(crypto.createHash('sha256')
                                       .update(code_verifier).digest());
// code_verifier는 세션에 저장 → (d) 단계에서 다시 씀
```

### (b) authorize 엔드포인트로 리디렉트 (GET)

사용자 브라우저를 authorize 엔드포인트로 보낸다. `state`는 CSRF 방지용 랜덤값(콜백에서 대조).

```http
GET https://MyDomainName.my.salesforce.com/services/oauth2/authorize
  ?response_type=code
  &client_id=<Consumer Key>
  &redirect_uri=https%3A%2F%2Fapp.example.com%2Fcallback
  &scope=api%20refresh_token
  &state=<random-anti-csrf>
  &code_challenge=<code_challenge>
  &code_challenge_method=S256
```

| 파라미터 | 필수 | 값 |
|---|---|---|
| `response_type` | ✅ | `code` (인가 코드 요청) |
| `client_id` | ✅ | 앱의 Consumer Key |
| `redirect_uri` | ✅ | Callback URL과 일치(URL 인코딩) |
| `scope` | 선택 | 공백(`%20`) 구분. 모든 scope엔 `id` 포함됨 |
| `state` | 권장 | CSRF 방지 랜덤 문자열 |
| `code_challenge` | PKCE | (a)에서 만든 challenge |
| `code_challenge_method` | PKCE | `S256` (유일 지원) |
| `prompt` | 선택 | `login`(강제 재로그인)·`consent`(동의 재요청) 등 |

### (c) 사용자 승인 → 콜백에 code 도착

사용자가 로그인·동의하면 Salesforce가 `redirect_uri`로 리디렉트하며 쿼리스트링에 `code`(임시 인가 코드)와 `state`를 붙여 돌려준다.

```http
GET https://app.example.com/callback?code=<authorization_code>&state=<random-anti-csrf>
```

앱은 받은 `state`가 (b)에서 보낸 값과 같은지 먼저 검증한다(다르면 폐기). 사용자가 거부하면 `?error=access_denied&...`가 온다.

### (d) token 엔드포인트로 코드 교환 (POST)

인가 코드를 access/refresh 토큰으로 교환한다. **`application/x-www-form-urlencoded`** 본문. `code_verifier`는 (a)에서 저장한 원본 verifier.

```http
POST https://MyDomainName.my.salesforce.com/services/oauth2/token
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code
&code=<authorization_code>
&client_id=<Consumer Key>
&redirect_uri=https://app.example.com/callback
&code_verifier=<code_verifier>
&client_secret=<Consumer Secret>
```

- `redirect_uri`는 (b)와 **동일**해야 함.
- **confidential 클라이언트**(Require Secret 체크): `client_secret` 포함. PKCE와 병행 가능.
- **public 클라이언트**(secret 없음): `client_secret` 생략하고 `code_verifier`만으로 증명 — PKCE가 secret을 대체.

### (e) 토큰 응답

성공 시 JSON. 이후 API 호출은 `Authorization: Bearer <access_token>`, 베이스 URL은 `instance_url`.

```json
{
  "access_token": "00D...!AQ...",
  "refresh_token": "5Aep861...",
  "signature": "base64-hmac",
  "scope": "api refresh_token",
  "id": "https://login.salesforce.com/id/00D.../005...",
  "instance_url": "https://MyDomainName.my.salesforce.com",
  "token_type": "Bearer",
  "issued_at": "1700000000000"
}
```

`refresh_token`은 `refresh_token`/`offline_access` scope가 있을 때만 발급된다. 안전 저장소에 보관.

### (f) access_token 갱신 (refresh)

access_token 만료 시 사용자를 다시 로그인시키지 않고 refresh_token으로 새 access_token을 받는다.

```http
POST https://MyDomainName.my.salesforce.com/services/oauth2/token
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token
&refresh_token=<refresh_token>
&client_id=<Consumer Key>
&client_secret=<Consumer Secret>
```

응답에 새 `access_token`이 온다(보통 refresh_token은 재발급 안 됨). refresh 요청에는 PKCE 파라미터가 필요 없다.

---

## 4. 검증 · 트러블슈팅

| 증상 / 에러 | 원인 | 조치 |
|---|---|---|
| `redirect_uri_mismatch` | (b)/(d)의 `redirect_uri`가 Callback URL과 불일치(슬래시·포트·http/https·인코딩 차이) | Connected App/ECA의 Callback URL에 정확히 등록, 세 곳(등록·b·d)을 문자 단위로 통일 |
| `invalid_grant` (token 단계) | 코드 만료·재사용, verifier 불일치, redirect_uri 불일치, client_secret 오류 | 코드는 1회성·단수명 → 즉시 교환. `code_verifier`가 (a) 원본인지 확인 |
| PKCE 실패 (`invalid_grant`/challenge 관련) | `code_challenge_method`가 S256 아님, challenge/verifier 인코딩 오류(base64url 패딩 제거 누락), verifier 43–128자 위반 | S256 사용, base64url 패딩 제거, verifier 길이·문자셋 확인 |
| `invalid_client_id` / `invalid_client` | Consumer Key/Secret 오타, secret 요구 설정과 전송 불일치 | Require Secret 설정과 실제 전송 여부 정합 |
| authorize에서 계속 로그인 화면 | scope에 `refresh_token` 없음 → 재접속마다 로그인 | scope에 `refresh_token`/`offline_access` 추가 |

정책·에러 원인 상세 → **[[Connected App (연결된 앱) — OAuth 클라이언트]]**.

---

## 5. 보안 체크리스트

- **PKCE 필수** — 인가 코드 가로채기(interception) 공격 방어. public 클라이언트(SPA·모바일)는 secret 대신 PKCE로만 보호. `S256`만 사용(`plain` 금지).
- **state 검증** — CSRF 방어. (b)에서 랜덤 발급 → (c) 콜백에서 대조, 불일치 시 폐기.
- **최소 scope** — 필요한 scope만 선택. 불필요한 `full`·과도 권한 금지.
- **secret·토큰 보관** — client_secret과 refresh_token은 서버 측 안전 저장소에. 브라우저(localStorage 등)에 refresh_token 노출 금지.
- **redirect_uri 고정** — 와일드카드·오픈 리디렉트 금지, 정확 매칭.

---

## 관련 노트

- [[Connected App (연결된 앱) — OAuth 클라이언트]] — OAuth 클라이언트 개념·정책·scope·에러 레퍼런스
- [[External Client App (외부 클라이언트 앱)]] — Connected App 후속, 신규 통합 권장 클라이언트
- [[OAuth 클라이언트(Connected App·External Client App) 생성 필드 전수 레퍼런스]] — 이 플로우용 클라이언트 생성 시 채우는 필드(Callback URL·Scopes·Require PKCE) 전수
- [[서버간 통합 구축 가이드 - External Client App·JWT Bearer·Client Credentials]] — 사용자 개입 없는 서버간 대비 플로우
- [[Named Credential·External Credential 생성 필드 전수 레퍼런스]] — 발급 토큰을 Named Credential로 관리할 때
- [[통합 MOC]] — 통합 패턴 인덱스
