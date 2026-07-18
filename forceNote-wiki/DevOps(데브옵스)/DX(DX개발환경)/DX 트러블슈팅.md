---
tags: [devops, salesforce-dx, troubleshoot, error, jwt, authorization, cli]
source: sfdx_dev.pdf v67.0 Summer '26 — Ch.15 (p.344–353)
created: 2026-05-23
aliases: [DX 트러블슈팅, DX 오류 해결, DX troubleshoot, org login 오류, JWT 오류, authorization error, CLI 버전 확인]
---

# DX 트러블슈팅

> Salesforce DX 사용 중 발생하는 일반적인 인증 오류·Dev Hub 오류·Connected App 오류의 원인과 해결 방법 전수.

---

## 시작 전 — CLI 최신 버전 업데이트

모든 오류 해결의 첫 번째 단계는 CLI 최신 버전 확인이다. Salesforce는 매주 새 CLI 버전을 릴리스한다.

```bash
# 인스톨러로 설치한 경우
sf update

# npm으로 설치한 경우
npm install --global @salesforce/cli

# 현재 CLI 버전 및 플러그인 버전 확인
sf plugins --core    # CLI + 설치된 플러그인 전체 버전
sf --version         # CLI 버전만
```

---

## org login web 오류

브라우저를 통한 org 인증(`org login web`) 실행 시 발생하는 오류들.

### Error: authentication failure

```
Invalid client credentials. Verify the OAuth client secret and ID.
Error authenticating with auth code due to: invalid_grant::authentication failure
```

- **Error name**: `AuthCodeExchangeError`
- **원인**: Connected App 설정 문제, org 설정 문제, 또는 인증 전에 실행되어야 하는 게스트 플로우 커스터마이징 문제.
- **해결 방법**:
  1. CLI와 core 플러그인을 최신 버전으로 업데이트 후 재시도 (`sf doctor` 실행)
  2. org가 API 접근을 허용하는지 + 본인에게 API 접근 권한이 있는지 확인
  3. 올바른 instance URL 사용 — Enhanced My Domain 형식 (Setup > Company Settings > My Domain > Current My Domain URL)
  4. Connected App 설정 확인 (기본 Salesforce CLI Connected App 대신 직접 생성한 경우)

### Error: unable to get local issuer certificate

```
Error authenticating with auth code due to: request to
https://test.salesforce.com//services/oauth2/token failed,
reason: unable to get local issuer certificate
```

- **Error name**: `AuthCodeExchangeError` 또는 `AuthCodeUsernameRetrievalError`
- **원인**: Node.js가 로컬 인증서 스토어에서 HTTPS 트래픽용 인증서를 찾지 못함. 프록시·방화벽·VPN의 deep inspection(SSL 인증서 교체)이 원인일 수 있음.
- **해결 방법**:
  - `NODE_EXTRA_CA_CERTS` 환경 변수에 신뢰할 인증서 추가
  - 프록시 사용 시 `HTTPS_PROXY`, `HTTP_PROXY` 환경 변수 설정 확인
  - 프록시 인증서 설정 확인
- **금지 사항**:
  - `NODE_TLS_REJECT_UNAUTHORIZED=0` 설정 금지 (중간자 공격 취약)
  - `strict-ssl=false` npm 설정 금지 (HTTP 허용, 암호화 없음)

### Error: grant type not supported

```
Error authenticating with auth code due to:
unsupported_grant_type::grant type not supported
```

- **Error name**: `AuthCodeExchangeError`
- **원인**: 잘못된 instance URL 사용. 기본 CLI Connected App 사용 시 이 오류는 대개 잘못된 instance URL이 원인.
- **해결 방법**:
  1. 올바른 instance URL 사용 (Enhanced My Domain 형식)
  2. Lightning URL 사용 금지: `https://MyDomainName.lightning.force.com` 대신 `https://MyDomainName.my.salesforce.com`
  3. 항상 `https` (not `http`) 사용
  4. org의 API 접근 권한 확인
  5. 로컬 컴퓨터 시계가 정확한지 확인 (auth code 생성 후 3분 이상 경과 시 오류 발생 가능)

### Error: ECONNRESET

```
Error authenticating with auth code due to: request to
https://test.salesforce.com//services/oauth2/token failed, reason: read ECONNRESET
```

- **Error name**: `AuthCodeExchangeError`
- **원인**: org가 연결을 리셋함.
- **해결 방법**:
  1. `org login web` 재실행 (일시적 오류인 경우가 많음)
  2. CLI 최신 버전 업데이트
  3. 올바른 instance URL 확인

### Error: ETIMEDOUT

```
Error authenticating with auth code due to: request to
https://test.salesforce.com//services/oauth2/token failed,
reason: connect ETIMEDOUT
```

- **Error name**: `AuthCodeExchangeError`
- **원인**: org 연결이 타임아웃됨.
- **해결 방법**:
  1. `org login web` 재실행 (일시적 오류)
  2. CLI 최신 버전 업데이트
  3. 올바른 instance URL 확인

### Error: self-signed certificate in certificate chain

```
Error authenticating with auth code due to: request to
https://login.salesforce.com//services/oauth2/token failed,
reason: self-signed certificate in certificate chain
```

- **Error name**: `AuthCodeExchangeError` 또는 `AuthCodeUsernameRetrievalError`
- **원인**: 인증서 검증 중 신뢰할 수 없는 인증서 발견. 프록시 deep inspection이 원인일 수 있음.
- **해결 방법**:
  - 알 수 없는 인증서 신뢰하지 말 것
  - 모든 인증서가 올바르게 생성됐는지 확인
  - trust store에 인증서 추가 또는 `NODE_EXTRA_CA_CERTS` 환경 변수 설정
  - 프록시 사용 시 `HTTPS_PROXY`, `HTTP_PROXY` 환경 변수 확인
- **금지 사항**:
  - `NODE_TLS_REJECT_UNAUTHORIZED=0` 설정 금지
  - `strict-ssl=false` npm 설정 금지

### Error: IP restricted

```
Error authenticating with auth code due to: ip restricted
```

- **Error name**: `AuthCodeExchangeError`
- **원인**: org에 IP 제한이 설정되어 있고, CLI가 허용되지 않는 IP에서 실행 중.
- **해결 방법**: CLI가 사용하는 IP 주소를 org의 **Trusted IP Ranges**에 추가.

### Error: ENOTFOUND

```
Error authenticating with auth code due to: request to
https://login.salesforce.com/services/oauth2/token failed,
reason: getaddrinfo ENOTFOUND login.salesforce.com
```

- **Error name**: `AuthCodeExchangeError` 또는 `AuthCodeUsernameRetrievalError`
- **원인**: 도메인 이름이 제한 시간 내에 확인되지 않음. 잘못된 instance URL, DNS 문제, 또는 프록시 문제.
- **해결 방법**:
  1. CLI 최신 버전 업데이트
  2. 올바른 instance URL 사용 (Enhanced My Domain 형식)
  3. Lightning URL 사용 금지
  4. `nslookup`으로 도메인이 수동으로 확인되는지 테스트
  5. 프록시 사용 시 `HTTPS_PROXY`, `HTTP_PROXY` 환경 변수 확인

---

## org login jwt 오류

JWT 플로우를 통한 org 인증(`org login jwt`) 실행 시 발생하는 오류들.

### Error: user hasn't approved this consumer

```
We encountered a JSON web token error, which is likely not an issue with Salesforce CLI.
Here's the error: Error authenticating with JWT. Errors encountered:
user hasn't approved this consumer
```

- **Error name**: `JwtGrantError`
- **원인**: Connected App 설정이 잘못됐거나, 새로 생성한 Connected App이 아직 복제 완료되지 않음.
- **해결 방법**:
  1. CLI 최신 버전 업데이트
  2. 최근 Connected App을 생성했다면 몇 분 기다린 후 재시도
  3. Connected App 설정 확인:
     - **Permitted Users**: `Admin approved users are pre-authorized` 설정
     - **Manage Profiles**: 인증할 사용자의 프로필 추가
  4. 올바른 instance URL 사용 (Enhanced My Domain 형식)
  5. Lightning URL 사용 금지

### Error: client identifier invalid

```
We encountered a JSON web token error, which is likely not an issue with Salesforce CLI.
Here's the error: Error authenticating with JWT. Errors encountered:
client identifier invalid
```

- **Error name**: `JwtGrantError`
- **원인**: `--client-id` 플래그에 전달한 OAuth client ID(consumer key)가 Connected App에 설정된 값과 불일치.
- **해결 방법**:
  1. CLI 최신 버전 업데이트
  2. Connected App 설정의 client ID/secret과 `org login jwt` 명령에 전달한 값이 일치하는지 확인
  3. 올바른 instance URL 사용

### Error: ENOENT (private key 파일 없음)

```
We encountered a JSON web token error, which is likely not an issue with Salesforce CLI.
Here's the error: ENOENT: no such file or directory, open
'/workspace/my-repository/server.key'
```

- **Error name**: `JwtGrantError`
- **원인**: `--jwt-key-file` 플래그에 지정한 private key 파일이 존재하지 않거나 위치가 다름. CI 환경에서 특정 액션에서만 파일에 접근 가능한 경우 자주 발생.
- **해결 방법**: private key 파일이 지정된 경로에 존재하는지 확인. org와 상호작용하는 모든 CLI 명령에서 접근 가능해야 함.

### Error: HTML response (정비 중)

```
Data Not Available webpage.
"The data you were trying to access could not be found..."
```

- **Error name**: `JwtGrantError`
- **원인**: org가 유지보수를 위해 일시적으로 다운됐거나 API 요청을 받을 준비가 되지 않음.
- **해결 방법**: 몇 분 후 재시도. 반복 발생 시 Salesforce Customer Support에 문의.

### Error: audience is invalid

```
We encountered a JSON web token error, which is likely not an issue with Salesforce CLI.
Here's the error: Error authenticating with JWT. Errors encountered:
audience is invalid [audience=https://login.salesforce.com
login=https://test.salesforce.com/]
```

- **Error name**: `JwtGrantError`
- **원인**: 주로 다른 오류(예: `user hasn't approved this consumer`)와 함께 발생. 잘못된 instance URL 사용도 원인.
- **해결 방법**:
  1. CLI 최신 버전 업데이트
  2. 올바른 instance URL 사용. `--instance-url` 플래그 또는 `SF_AUDIENCE_URL` 환경 변수로 지정 가능 (프로덕션 환경에서는 보통 불필요)
  3. Lightning URL 사용 금지
  4. 프록시 사용 시 환경 변수 확인
  5. 추가 오류가 있으면 해당 오류의 해결 방법도 참조

---

## Error: No default dev hub found

```
Error (1): No default dev hub found.
Use -v or --target-dev-hub to specify an environment.
```

**발생 시나리오**: `--set-default-dev-hub` 플래그로 Dev Hub를 성공적으로 인증했지만, 다른 디렉토리에서 `org create scratch`를 실행하면 이 오류가 발생한다.

**원인**: `--set-default-dev-hub` 플래그로 설정된 `target-dev-hub` 설정 변수는 **로컬(프로젝트 디렉토리 기준)**으로 저장된다. 다른 디렉토리에서 실행하면 로컬 설정이 적용되지 않는다.

**해결 방법 (셋 중 선택)**:

```bash
# 방법 1: 글로벌로 target-dev-hub 설정 (모든 디렉토리에서 유효)
sf config set target-dev-hub=<devhubusername> --global

# 방법 2: Dev Hub를 인증한 동일 프로젝트 디렉토리에서 org create scratch 실행

# 방법 3: org create scratch 시 --target-dev-hub 플래그 명시
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --target-dev-hub <devhubusername> \
  --alias my-scratch-org

# 현재 설정 확인 (Location 컬럼에서 글로벌/로컬 구분)
sf config list
```

---

## Unable to Work After Failed Org Authorization (포트 점유 문제)

org 인증 시도가 실패하면 포트 `1717`에 stray 프로세스가 남아 CLI/IDE를 사용할 수 없는 상태가 된다.

### macOS / Linux에서 포트 해제

```bash
# 포트 1717을 사용 중인 프로세스 찾기
lsof -i tcp:1717

# 출력에서 PID 확인 후 종료
kill -9 <the process ID>
```

### Windows에서 포트 해제

```
1. Ctrl+Alt+Delete → Task Manager 클릭
2. Process 탭 선택
3. "Node" 프로세스 찾기 (Node.js 개발자라면 여러 개가 있을 수 있음)
4. 종료할 프로세스 선택 → End Process 클릭
```

---

## Error: The consumer key is already taken

**발생 시나리오**: 한 org에서 Connected App을 포함한 소스를 `project retrieve start`로 검색한 후, 다른 org에 배포하면 이 오류가 발생한다.

```
The consumer key is already taken
```

**원인**: Connected App의 consumer key는 Salesforce 생태계 전체에서 고유해야 한다. 검색한 소스 파일을 변경 없이 새 org에 배포하면 중복 consumer key로 배포가 실패한다.

**해결 방법 (둘 중 선택)**:

```bash
# 방법 1: Connected App 소스 파일을 배포에서 제외
# (Connected App이 새 org에 생성되지 않음)
rm force-app/main/default/connectedApps/MyConnApp.connectedApp-meta.xml

# 방법 2: consumerKey 값을 고유한 값으로 변경
```

Connected App 소스 파일 예시:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ConnectedApp xmlns="http://soap.sforce.com/2006/04/metadata">
  <contactEmail>john@doecompany.com</contactEmail>
  <contactPhone>5556789</contactPhone>
  <label>MyConnApp</label>
  <oauthConfig>
    <callbackUrl>http://localhost:1717/OauthRedirect</callbackUrl>
    <!-- 이 값을 고유한 값으로 변경 -->
    <consumerKey>3MVG9PG9sFc71i9n55UWbx2</consumerKey>
    <isAdminApproved>false</isAdminApproved>
    ...
  </oauthConfig>
</ConnectedApp>
```

---

## CLI 버전 정보 확인

```bash
# CLI 및 설치된 모든 플러그인 버전
sf plugins --core

# CLI 버전만
sf --version
```

---

## 관련 노트
- [[DX 인증 방식]] — org login web·JWT Flow·External Client App·Connected App 설정 전수
- [[DX 도구 접근 권한]] — Dev Hub 활성화·권한 설정
- [[DX 제약사항]] — DX 사용 중 알려진 한계
- [[CI 통합 전수 (CircleCI·Jenkins·Travis)]] — CI 환경에서의 JWT 인증 자동화
