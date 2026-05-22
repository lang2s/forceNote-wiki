---
tags: [devops, salesforce-dx, authorization, jwt, oauth, connected-app, external-client-app, sfdx-auth-url]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 4
created: 2026-05-22
aliases: [DX 인증, JWT 인증, org login jwt, org login web, SFDX Auth URL, Connected App 설정, External Client App 설정]
---

# DX 인증 방식

> Salesforce CLI로 org에 접근하기 위한 인증(Authorization) 전수 레퍼런스 — 브라우저 로그인, JWT Flow, External Client App/Connected App 설정, SFDX Auth URL, Access Token, Logout 모든 시나리오 수록.

---

## 인증 방식 선택 가이드

| 방식 | 명령 | 사용 시나리오 |
|---|---|---|
| 브라우저 로그인 (Web Server Flow) | `sf org login web` | 대화형 개발 환경. MFA·SSO 지원 |
| JWT Bearer Flow | `sf org login jwt` | CI/CD, 자동화 환경 (브라우저 없음) |
| SFDX Authorization URL | `sf org login sfdx-url` | 이미 인증된 org를 다른 환경에 빠르게 재인증 |
| 기존 Access Token 직접 사용 | `--target-org <token>` | 인증 과정 없이 단발성 명령 실행 |

> **중요:** 고보안(high assurance / stepped-up) 인증이 설정된 org에서는 JWT Flow와 SFDX Auth URL을 사용할 수 없다. 사용자 신원 재확인 프롬프트가 headless 환경에서 처리 불가하기 때문이다.

---

## 1. 브라우저 인증 (org login web)

### 기본 사용법

```bash
# 기본 인증 + 별칭 설정
sf org login web --alias my-org

# Dev Hub로 인증
sf org login web --set-default-dev-hub --alias DevHub

# 기본 org로 설정
sf org login web --set-default --alias my-org

# consumer key를 지정해 custom app 사용
sf org login web --client-id 04580y4051234051 --set-default-dev-hub --alias my-hub-org

# 인스턴스 URL 명시 (My Domain 또는 Sandbox)
sf org login web --alias my-hub-org \
  --instance-url https://exciting.sandbox.my.salesforce.com
```

### 주요 플래그

| 플래그 | 설명 |
|---|---|
| `--alias` `-a` | org에 별칭 부여 (이후 명령에서 사용 편의) |
| `--set-default` | `--target-org` 기본값으로 설정 |
| `--set-default-dev-hub` | Dev Hub 기본값으로 설정 |
| `--client-id` | Custom External Client App 또는 Connected App의 consumer key |
| `--instance-url` `-r` | 로그인 URL 직접 지정 (sfdx-project.json의 sfdcLoginUrl 오버라이드) |

### My Domain URL 사용 권고

- 브라우저 창이 자동으로 열리고, 로그인 후 "Allow" 클릭으로 완료된다.
- `login.salesforce.com`이 아닌 My Domain URL을 사용할 경우 `sfdx-project.json`에 `sfdcLoginUrl`을 설정하거나 `--instance-url` 플래그를 사용한다.

```json
// sfdx-project.json — Production / Developer Org
{ "sfdcLoginUrl": "https://MyDomainName.my.salesforce.com" }

// Sandbox
{ "sfdcLoginUrl": "https://MyDomainName--SandboxName.sandbox.my.salesforce.com" }
```

- `.lightning.force.com` URL(Lightning Experience에서 보이는 URL)이 아닌 `.my.salesforce.com`으로 끝나는 My Domain URL을 사용해야 org 마이그레이션에도 영향을 받지 않는다.

---

## 2. JWT Flow 인증 (org login jwt)

### 전체 절차 개요

```
1. Private Key(server.key) + Self-Signed Certificate(server.crt) 생성 (OpenSSL)
2. External Client App 또는 Connected App 생성 + server.crt 업로드
3. sf org login jwt 실행
```

> **Dev Hub + Scratch Org/Sandbox 생성 예정** → Connected App 필수.
> **그 외 일반 org** → External Client App 사용 (권장).

### JWT 인증 명령

```bash
# 기본 JWT 인증
sf org login jwt \
  --client-id 04580y4051234051 \
  --jwt-key-file /Users/jdoe/JWT/server.key \
  --username jdoe@myorg.com \
  --alias my-hub-org

# Dev Hub 인증
sf org login jwt \
  --client-id 04580y4051234051 \
  --jwt-key-file /Users/jdoe/JWT/server.key \
  --username jdoe@myorg.com \
  --set-default-dev-hub \
  --alias HubOrg

# 인스턴스 URL 명시 (Sandbox 또는 My Domain)
sf org login jwt \
  --client-id 04580y4051234051 \
  --jwt-key-file /Users/jdoe/JWT/server.key \
  --username jdoe@myorg.com \
  --alias my-hub-org \
  --instance-url https://mydomain--mysandbox.sandbox.my.salesforce.com
```

### 주요 플래그

| 플래그 | 필수 | 설명 |
|---|---|---|
| `--client-id` `-i` | ✅ | External Client App 또는 Connected App의 consumer key |
| `--jwt-key-file` `-f` | ✅ | private key 파일 경로 (server.key) |
| `--username` `-u` | ✅ | 인증할 org 사용자명 |
| `--alias` `-a` | — | org 별칭 |
| `--set-default` | — | 기본 target-org로 설정 |
| `--set-default-dev-hub` | — | Dev Hub 기본값으로 설정 |
| `--instance-url` `-r` | — | 로그인 URL 직접 지정. sfdcLoginUrl 오버라이드 |
| `--json` | — | JSON 형식 출력 |

### Scratch Org를 JWT로 인증하기

Dev Hub org를 JWT로 인증했다면, 동일한 Consumer Key와 Private Key로 연관 Scratch Org도 인증할 수 있다.

```bash
# 1. Scratch Org의 instance URL 조회 (Dev Hub에서)
sf data query \
  --target-org my-dev-hub \
  --query "SELECT SignupUsername,LoginUrl FROM ScratchOrgInfo WHERE SignupUsername='test-wvkpnfm5z113@example.com'"

# 2. Scratch Org JWT 인증
sf org login jwt \
  --client-id 3MVG9szVa2Rx_sqBb444p50Yj \
  --jwt-key-file /Users/jdoe/JWT/server.key \
  --username test-wvkpnfm5z113@example.com \
  --instance-url https://energy-enterprise-2539-dev-ed.scratch.my.salesforce.com
```

> **Hyperforce 주의:** Scratch Org가 Hyperforce에서 실행되고 `--username`이 non-admin 사용자라면 Dev Hub의 인증서/private key를 재사용할 수 없다. 이 경우 표준 JWT Flow 절차를 따른다.

---

## 3. Private Key와 Self-Signed Certificate 생성 (OpenSSL)

JWT Flow에는 digital certificate와 private key가 필요하다. 공인 인증 기관(CA) 발급 인증서 사용을 권장하지만, 시작용으로 OpenSSL로 자체 서명 인증서를 생성할 수 있다.

> **경고:** 아래 절차는 샘플용이다. 프로덕션 환경 사용 전 회사 보안 정책을 확인한다.

생성 결과물:
- `server.key` — private key. `org login jwt --jwt-key-file`에 지정
- `server.crt` — digital certificate. External Client App 또는 Connected App에 업로드

### 단계별 OpenSSL 명령

```bash
# 1. OpenSSL 설치 확인
which openssl       # macOS/Linux
# where openssl     # Windows

# 2. 작업 디렉토리 생성
mkdir /Users/jdoe/JWT
cd /Users/jdoe/JWT

# 3. Private Key 생성 (AES-256-CBC 암호화, 2048비트 RSA)
openssl genpkey -aes-256-cbc -algorithm RSA \
  -pass pass:SomePassword \
  -out server.pass.key \
  -pkeyopt rsa_keygen_bits:2048

# 4. 암호화 해제된 key 추출
openssl rsa -passin pass:SomePassword \
  -in server.pass.key \
  -out server.key

# 5. Certificate Signing Request(CSR) 생성 (회사 정보 입력 프롬프트)
openssl req -new -key server.key -out server.csr

# 6. Self-Signed Digital Certificate 생성 (SHA-256, 유효 365일)
openssl x509 -req -sha256 -days 365 \
  -in server.csr \
  -signkey server.key \
  -out server.crt
```

이후 `server.crt`를 External Client App 또는 Connected App에 업로드한다.

---

## 4. External Client App 생성 (권장)

External Client App은 Salesforce CLI가 org와 통합할 수 있게 해주는 패키지 가능한 프레임워크다. Connected App이 deprecated 예정이므로 **이 방식을 권장**한다.

> **Dev Hub + Scratch Org/Sandbox 생성 예정** → Connected App 필수 (External Client App 불가).

### 생성 절차

```
1. org 로그인
2. Setup → Quick Find → "App Manager" → [App Manager] 클릭
3. [New External Client App] 클릭
4. 앱 이름, 연락처 이메일 등 기본 정보 입력
5. "API (Enable OAuth Settings)" → [Enable OAuth] 클릭
6. "App Settings" → Callback URL: http://localhost:1717/OauthRedirect
   (포트 1717이 사용 중이면 다른 포트 지정 후 sfdx-project.json에 oauthLocalPort 설정)
7. OAuth Scopes 추가:
   • Manage user data via APIs (api)
   • Manage user data via Web browsers (web)
   • Perform requests at any time (refresh_token, offline_access)
8. [Required for JWT] "Flow Enablement" → [Enable JWT Bearer Flow] 선택
9. [Required for JWT] [Upload Files] → server.crt 업로드
10. [Create] 클릭
```

> 앱이 생성된 후 추가 설정이 필요하다.

```
11. [Edit] 클릭
12. [Required for JWT] Policies 탭 클릭
    a. OAuth Policies 열기
    b. "Plugin Policies" → Permitted Users: "Admin approved users are pre-authorized" 선택
    c. [OK]
    d. 사전 인가할 Profile 및 Permission Set 선택
13. Policies 탭 → "App Authorization" → "OAuth Policies"
    → "Expire refresh token after a specific time" 선택
14. Refresh Token Validity Period: 90, Unit: Day(s)  ← 보안 모범 사례
15. Session Timeout in Minutes: 15  ← 보안 모범 사례
16. [Save]
```

### Consumer Key 가져오기

```
1. Setup → Quick Find → "App Manager" → [External Client App Manager]
2. 앱 클릭 → Settings 탭 → "OAuth Settings" → [Consumer Key and Secret]
3. 이메일로 발송된 인증 코드 입력 → [Verify]
4. [Copy] (Consumer Key 옆)
```

Consumer Key 사용법:

```bash
sf org login web --client-id 04580y4051234051 --set-default-dev-hub --alias my-hub-org
```

---

## 5. Connected App 생성 (Dev Hub 전용)

> **경고:** Connected App은 deprecated 예정이다. Dev Hub에서 Scratch Org 또는 Sandbox를 생성할 경우에만 사용한다. 그 외에는 External Client App을 사용한다.
> Connected App 생성은 기본적으로 비활성화되어 있다. Salesforce Customer Support를 통해 org perm을 활성화해야 한다(org당 1회).

### 생성 절차

```
1. Salesforce Customer Support에 connected app 생성 활성화 요청
2. org 로그인
3. Setup → Quick Find → "External Client Apps" → Settings → "Allow creation of connected apps" 활성화
4. [New Connected App] 클릭
5. 앱 이름, 이메일 입력
6. [Enable OAuth Settings] 체크
7. Callback URL: http://localhost:1717/OauthRedirect
   (포트 변경 시 sfdx-project.json의 oauthLocalPort 업데이트)
8. [Required for JWT] [Use digital signatures] 체크
9. [Required for JWT] [Choose File] → server.crt 업로드
10. OAuth Scopes 추가:
    • Manage user data via APIs (api)
    • Manage user data via Web browsers (web)
    • Perform requests at any time (refresh_token, offline_access)
11. [Save] → [Continue]
12. [Manage Consumer Details] → 이메일 인증 코드 입력 → [Verify]
13. Consumer Key 복사 (이후 org login 명령에서 --client-id에 사용)
14. [Back to Manage Connected Apps] → [Manage] → [Edit Policies]
15. OAuth Policies → Refresh Token Policy: "Expire refresh token after: 90 days"  ← 보안
16. Session Policies → Timeout Value: 15 minutes  ← 보안
17. [Required for JWT] OAuth Policies → Permitted Users: "Admin approved users are pre-authorized" → [OK]
18. [Save]
19. [Required for JWT] [Manage Profiles] → 사전 인가할 Profile 선택 → [Save]
    [Required for JWT] [Manage Permission Sets] → Permission Set 선택 → [Save]
```

---

## 6. 기본 Connected App 보안 설정 (Salesforce CLI 기본 앱)

`org login web --client-id` 없이 인증하면 Salesforce CLI가 "Salesforce CLI"라는 기본 connected app을 생성한다. 이 앱의 refresh token 만료 기간이 기본값 "무기한"으로 설정된다. 보안을 위해 다음 절차로 수정한다.

```
1. org 로그인
2. Setup → Quick Find → "OAuth" → "Connected Apps OAuth Usage"
3. "Salesforce CLI" 앱 선택 → [Install] → [Install] 확인
4. [Edit Policies]
5. OAuth Policies → Refresh Token Policy: "Expire refresh token after: 90 Days"
6. Session Policies → Timeout Value: 15 minutes
7. [Save]
```

만료된 refresh token 오류:

```
ERROR running org open: Error authenticating with the refresh token due to: expired access/refresh token
```

이 오류 발생 시 `org login web` 또는 `org login jwt`로 재인증한다.

---

## 7. SFDX Authorization URL 사용 (org login sfdx-url)

SFDX Auth URL은 이미 인증된 org를 CI 환경 등 다른 머신에서 빠르게 재인증할 때 사용한다.

> **주의:** `org login web`으로 인증한 org에서만 SFDX Auth URL이 제공된다. `org login jwt`로 인증한 org에서는 `--verbose` 출력에 Auth URL이 포함되지 않는다.

```bash
# 1. 현재 인증된 org에서 SFDX Auth URL 추출 (JSON 파일로 저장)
sf org display \
  --target-org my-org \
  --verbose \
  --json > authFile.json
# JSON 출력에 "sfdxAuthUrl" 키가 포함됨

# 2. CI 환경에서 해당 파일로 org 인증
sf org login sfdx-url --sfdx-url-file authFile.json
```

> **경고:** `org display --verbose` 출력은 현재 인증 세션을 그대로 노출하므로 다른 사람과 공유하면 무단 접근이 발생할 수 있다. 보안에 주의한다.

---

## 8. 기존 Access Token으로 인증

인증 과정 없이 이미 알고 있는 Access Token으로 단발성 CLI 명령을 실행하는 방법이다.

> **예외:** `org display user` 명령은 access token을 `--target-org` 값으로 사용할 수 없다.

```bash
# 1. org의 Access Token과 Instance URL 조회
sf org display --target-org myorg
# 출력 예:
# Access Token   00D8H0000007wprAQkAQAlOT5H (truncated)
# Instance Url   https://creative-impala-20hx3-dev-ed.my.salesforce.com

# 2. instance URL을 config에 설정
sf config set org-instance-url=https://creative-impala-20hx3-dev-ed.my.salesforce.com --global

# 3. access token을 --target-org 값으로 직접 사용
sf project deploy start \
  --source-dir <source-dir> \
  --target-org 00D8H0000007wprAQkAQAlOT5H
```

> **팁:** access token에 `!` 문자가 포함된 경우 백슬래시로 이스케이프한다.
> 예: `--target-org 00007wpr\!AQkAQA`

Salesforce CLI는 access token을 내부 파일에 저장하지 않는다. 이 명령 실행 시에만 사용된다.

---

## 9. 인증 정보 조회 (org display / org list)

```bash
# 단일 org 정보 조회
sf org display --target-org my-scratch-org

# SFDX Auth URL 포함 조회 (org login web으로 인증한 org만 표시됨)
sf org display --target-org my-org --verbose

# 전체 인증 org 및 Scratch Org 목록
sf org list

# 목록 + 상세 정보 (만료된 org CONNECTED STATUS 확인 가능)
sf org list --verbose
```

`org display` 출력 필드:

| 필드 | 설명 |
|---|---|
| Access Token | 현재 액세스 토큰 (truncated) |
| Alias | 설정된 별칭 |
| Api Version | API 버전 |
| Client Id | Connected App/External Client App의 consumer key |
| Created By | 생성 사용자 (Scratch Org) |
| Created Date | 생성 일시 |
| Dev Hub Id | 연결된 Dev Hub (Scratch Org) |
| Edition | org 에디션 |
| Expiration Date | 만료일 (Scratch Org) |
| Id | org ID |
| Instance Url | org 인스턴스 URL |
| Org Name | org 이름 |
| Signup Username | 가입 사용자명 |
| Status | Active / 만료 여부 |
| Username | 인증 사용자명 |

> **보안 주의:** `org display` 출력에는 client secret과 refresh token이 포함되지 않는다.

---

## 10. Logout (org logout)

```bash
# 특정 org에서 로그아웃
sf org logout --target-org my-hub-org

# 모든 org(Scratch Org 포함)에서 로그아웃
sf org logout --all
```

> **중요:** 로그아웃 이후 org에 다시 접근하려면 비밀번호가 필요하다.
> Scratch Org는 기본적으로 관리자 비밀번호가 없다. 따라서:
> - 나중에 다시 접근할 Scratch Org라면 → 로그아웃 전에 사용자 비밀번호를 설정한다.
> - 더 이상 필요 없는 Scratch Org라면 → 로그아웃 대신 `sf org delete scratch`로 삭제한다.

로그아웃한 org는 `org list` 출력에서 사라진다. Dev Hub에서 로그아웃하면 연관 Scratch Org는 `--all` 플래그 사용 시에만 표시된다. 재접근 시 `org login web` 또는 `org login jwt`로 재인증한다.

---

## External Client App vs Connected App 비교

| 항목 | External Client App | Connected App |
|---|---|---|
| 권장 여부 | ✅ 권장 | ⚠️ Deprecated 예정 |
| Dev Hub + Scratch Org/Sandbox 생성 | ❌ 사용 불가 | ✅ 필수 |
| 생성 방법 | Setup → App Manager → New External Client App | Customer Support 활성화 후 Setup |
| 기본 활성화 | ✅ | ❌ (Customer Support 요청 필요) |
| JWT Bearer Flow | ✅ (JWT Bearer Flow 활성화 필요) | ✅ (Digital Signatures 체크 필요) |
| Packageable | ✅ | ❌ |

---

## oauthLocalPort 포트 충돌 처리

기본 callback port `1717`이 사용 중이면 다른 포트를 사용하고 `sfdx-project.json`을 업데이트한다.

```json
// sfdx-project.json
{
  "oauthLocalPort": "1919"
}
```

Callback URL도 동일하게 `http://localhost:1919/OauthRedirect`로 설정한다.

---

## 보안 모범 사례 요약

```
□ server.key를 VCS(Git)에 절대 커밋하지 않는다
□ CI 환경에서 server.key는 암호화하거나 시크릿 관리자(Vault 등)에 저장한다
□ Refresh Token 만료: 90일 이하로 설정
□ Access Token 세션 타임아웃: 15분으로 설정
□ org display --verbose 출력을 다른 사람과 공유하지 않는다
□ 더 이상 필요 없는 Scratch Org는 logout 대신 delete로 정리한다
```

---

## 관련 노트

- [[Salesforce DX 개요]] — JWT 인증 명령 요약, sf CLI 기본 워크플로
- [[CI CD 패턴]] — Jenkins/CircleCI에서 JWT 인증 자동화 파이프라인
- [[Scratch Org 패턴]] — Scratch Org 생성·관리 (JWT 인증 후 사용)
- [[sfdx-project.json 레퍼런스]] — sfdcLoginUrl, oauthLocalPort 필드 전수
- [[DX 개발 워크플로]] — CLI 소스 파일 생성·배포·Anonymous Apex·테스트 실행·Debug Logs 전수
- [[DX 트러블슈팅]] — org login web/jwt 오류 전수 (AuthCodeExchangeError·JwtGrantError 등)
- [[DX MCP Server (Beta)]] — MCP 서버 사용을 위한 org 인증 전제 조건
