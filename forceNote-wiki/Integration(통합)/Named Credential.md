---
tags: [salesforce, integration, named-credential, security, pattern]
source: apex-recipes/RestClient.cls, NamedCredentialRecipes.cls; help.salesforce.com — Enable External Credential Principals (nc_enable_ext_cred_principal, Tier 2); salesforce_apex_developer_guide.pdf — Merge Fields for Apex Callouts That Use Named Credentials (Tier 2); api_meta.pdf v67.0 — ExternalCredential·ExternalAuthIdentityProvider + salesforce_apex_reference_guide.pdf — ConnectApi NamedCredentials (Tier 2)
created: 2026-05-17
aliases: [Named Credential, 네임드 크레덴셜, callout:, External Credential, OAuth Client Credentials 설정, Credential merge field]
---

# Named Credential

> 외부 시스템 URL과 인증 정보를 Salesforce에 저장하고 Apex에서 `callout:{NC_Name}` 형식으로 참조. 코드에 URL/비밀번호를 하드코딩하지 않는 Salesforce 표준 방식.

---

## 개념

외부 시스템을 Apex callout으로 연동할 때 URL과 인증 정보를 코드에 직접 쓰면 두 가지 문제가 생긴다. 첫째, 비밀번호나 API Key가 소스 코드에 노출되어 버전 관리 시스템에 평문으로 저장된다. 둘째, Sandbox와 Production이 서로 다른 엔드포인트를 써야 할 때 코드를 배포해야 변경된다.

Named Credential은 이 두 문제를 모두 해결하는 Salesforce 표준 메커니즘이다. URL과 인증 정보를 Setup에 저장하고, Apex 코드에서는 `callout:NC_Developer_Name` 형식의 논리적 이름만 사용한다. 환경별로 Named Credential 레코드의 URL만 바꾸면 코드 변경 없이 엔드포인트를 교체할 수 있다. OAuth 2.0 프로토콜을 사용할 경우 Salesforce가 토큰 갱신을 자동으로 처리해 만료된 토큰 관련 에러를 직접 처리하지 않아도 된다.

Spring '23부터 Legacy Named Credential과 신형 Named Credential + External Credential 구조로 분리되었다. 신형 구조에서는 인증 정보(External Credential)와 엔드포인트 URL(Named Credential)을 각각 독립적으로 관리할 수 있다.

---

## Apex에서 사용하는 형식

```apex
// 기본 형식
req.setEndpoint('callout:GoogleBooksAPI/volumes?q=' + keyword);

// Named Credential 이름 + 경로
// callout:{DeveloperName}/{path}?{querystring}

// 예시
req.setEndpoint('callout:MyRestApi/api/v1/accounts/');
req.setEndpoint('callout:Stripe/v1/charges?limit=10');
```

### Merge Field로 커스텀 헤더/바디에 자격증명 주입 — `{!$Credential.…}`

기본적으로 Salesforce가 표준 **Authorization 헤더를 자동 생성**해 callout에 붙인다(`Generate Authorization Header` 옵션, 기본 켜짐). 원격 엔드포인트가 표준 Authorization 헤더를 지원하지 않거나(보안 토큰을 커스텀 헤더로 요구, username/password를 XML·JSON 바디로 요구 등) 코드에서 직접 헤더를 구성해야 할 때는, merge field로 저장된 자격증명을 헤더/바디에 주입한다.

**전제 조건 (필수):** 관리자가 Named Credential의 콜아웃 옵션에서 **Allow Merge Fields in HTTP Header** / **Allow Merge Fields in HTTP Body** 를 체크해야 코드의 merge field가 실행 시점에 치환된다 (신형 Named Credential UI에서는 Callout Options의 *Allow Formulas in HTTP Header/Body* 체크박스). 이 옵션들은 External Data Source에서 Named Credential을 참조할 때는 사용할 수 없다.

| Merge Field | 값 | 사용 가능 조건 |
|---|---|---|
| `{!$Credential.Username}` | 실행 사용자의 username | Password 인증일 때만 |
| `{!$Credential.Password}` | 실행 사용자의 password | Password 인증일 때만 |
| `{!$Credential.OAuthToken}` | 실행 사용자의 OAuth 토큰 | OAuth 인증일 때만 |
| `{!$Credential.AuthorizationMethod}` | `Basic`(password) / `Bearer`(OAuth 2.0) / `null`(no auth) | 프로토콜에 따라 결정 |
| `{!$Credential.AuthorizationHeaderValue}` | Base-64 인코딩된 username:password(password) / OAuth 토큰(OAuth 2.0) / `null`(no auth) | 프로토콜에 따라 결정 |
| `{!$Credential.OAuthConsumerKey}` | Consumer key | OAuth 인증일 때만 |

```apex
// 커스텀 헤더 주입 — Allow Merge Fields in HTTP Header 필요
req.setHeader('X-Username', '{!$Credential.Username}');
req.setHeader('X-Password', '{!$Credential.Password}');
req.setHeader('Authorization', '{!$Credential.OAuthToken}');
req.setHeader('X-API-Key', '{!$Credential.Password}'); // API Key를 Password 필드에 저장하는 패턴

// 바디 주입 — Allow Merge Fields in HTTP Body 필요.
// HTMLENCODE 수식으로 특수문자 이스케이프 가능 (바디 전용 — 헤더의 merge field에는 사용 불가)
req.setBody('Username:{!HTMLENCODE($Credential.Username)}');
req.setBody('Password:{!HTMLENCODE($Credential.Password)}');
```

- 바디의 merge field에 적용 가능한 수식 함수는 `HTMLENCODE` **하나뿐**이며, 수식은 반드시 `HTMLENCODE`로 시작해야 한다.
- 이 merge field들을 **SOAP API 호출**에 사용하면 OAuth access token이 자동 갱신되지 않는다.

---

## RestClient에서의 활용

```apex
// RestClient 상속 서비스 클래스
public with sharing class BookApiService extends RestClient {

    public BookApiService() {
        namedCredentialName = 'GoogleBooksAPI'; // ← Named Credential Developer Name
    }

    public List<BookModel> searchBooks(String keyword) {
        // RestClient.get()이 내부적으로 callout:GoogleBooksAPI/{path} 구성
        HttpResponse response = get('volumes?q=' + EncodingUtil.urlEncode(keyword, 'UTF-8'));
        // 응답 처리...
    }
}
```

---

## Named Credential 종류

| 종류 | 설명 |
|---|---|
| Legacy Named Credential | URL + 인증 정보 통합 (구형) |
| Named Credential (신형) | URL + External Credential 분리 |
| External Credential | 인증 정보만 별도 관리 |
| Per-User Principal | 사용자별 인증 정보 |

---

## 설정 경로

```
Setup → Security → Named Credentials → New Named Credential

필드:
- Label: 화면 표시명
- Name (Developer Name): Apex에서 참조하는 이름
- URL: 외부 시스템 Base URL
- Identity Type: Named Principal / Per-User
- Authentication Protocol: No Auth / Password / OAuth 2.0 / JWT / AWS Signature V4
```

---

## ⚠️ 신형 모델 필수 셋업 — External Credential Principal 접근 권한 부여

신형 Named Credential + External Credential 구조에서는 논리적 이름(`callout:NC`)만 맞아도 **callout 실행 사용자에게 External Credential Principal 접근 권한이 없으면 인증 callout이 접근 오류로 실패**한다. 신형 구조를 쓴다면 아래 권한 부여 단계를 반드시 완료해야 한다.

```
1. Permission Set 생성 (Setup → Permission Sets → New)
2. 해당 Permission Set의 Apps 섹션 → External Credential Principal Access 열기
3. 대상 Principal을 Available → Enabled 로 이동
4. callout을 실행할 사용자에게 이 Permission Set 할당
   (User External Credentials 오브젝트 접근 권한이 부여됨)
```

이 매핑을 하지 않으면 Named Credential URL·External Credential 설정이 모두 올바르고 Apex의 `callout:NC` 이름이 맞더라도 런타임에 인증 접근 오류로 막힌다. Legacy Named Credential에는 이 단계가 없지만, External Credential을 분리한 신형 모델(Per-User Principal 포함)에서는 필수다.

> 근거: [Enable External Credential Principals](https://help.salesforce.com/s/articleView?id=xcloud.nc_enable_ext_cred_principal.htm) — "create a permission set granting users access to the principal… select External Credential Principal Access and move the principal to Enabled". User External Credential 오브젝트 접근이 필요하다.

---

## ConnectApi를 통한 Named Credential 생성 (코드)

```apex
// 코드로 Named Credential 생성 (apex-recipes/NamedCredentialRecipes.cls 패턴)
ConnectApi.ExternalCredentialInput credInput = new ConnectApi.ExternalCredentialInput();
credInput.developerName = 'MyExternalCred';
credInput.label = 'My External Credential';
credInput.authenticationProtocol = ConnectApi.CredentialAuthenticationProtocol.NoAuthentication;

ConnectApi.ExternalCredential cred =
    ConnectApi.NamedCredentials.createExternalCredential(credInput);
```

> [!note] ConnectApi 테스트 제약
> `ConnectApi.NamedCredentials`는 `@isTest(SeeAllData=true)` 없이 호출 불가.
> → 래퍼 클래스로 감싸서 `TestDouble`로 모킹. ([[StubProvider]] 참조)

---

## 인증 프로토콜별 선택

| 프로토콜 | 사용 시점 |
|---|---|
| No Authentication | API Key를 헤더로 직접 전달 (코드에서) |
| Password | 기본 인증 (Basic Auth) |
| OAuth 2.0 | OAuth flow (Salesforce가 토큰 관리) — 설정 절차는 아래 [[#OAuth 2.0 설정 절차 (Client Credentials · Browser Flow)|OAuth 2.0 설정 절차]] 참조 |
| JWT Token Bearer | JWT 기반 M2M |
| AWS Signature V4 | AWS 서비스 |

---

## OAuth 2.0 설정 절차 (Client Credentials · Browser Flow)

신형 모델에서 OAuth 2.0 인증은 **External Credential 쪽에서 설정**한다. Named Credential은 엔드포인트 URL만 들고 External Credential을 참조할 뿐이다.

### Client Credentials 플로우 — 서버-투-서버 (사용자 컨텍스트 없음)

```
1. Setup → Security → Named Credentials → External Credentials 탭 → New
2. Authentication Protocol = OAuth 2.0
3. Authentication Flow Type = Client Credentials with Client Secret
4. Identity Provider URL = 외부 시스템의 토큰 엔드포인트 URL
   (token endpoint — 모든 OAuth 2.0 플로우에서 필수 입력)
5. Scope = 필요한 최소 OAuth scope
6. 저장 → Principals 섹션 → New: Named Principal 생성,
   Authentication Parameters에 Client ID · Client Secret 입력 (플랫폼 암호화 저장)
7. Permission Set → External Credential Principal Access에 이 Principal을 Enabled로 매핑
   → callout 실행 사용자에게 할당 (위 "신형 모델 필수 셋업" 절차와 동일)
8. Named Credential(신형) 생성 — URL 입력 + 이 External Credential 연결
   → Apex는 callout:{NC_DeveloperName}만 쓰면 토큰 발급·만료 갱신을 Salesforce가 자동 처리
```

**Client Secret 전달 방식 variant** (`ConnectApi.CredentialAuthenticationProtocolVariant` — Apex Reference 검증):

| Variant | Client Secret 전달 위치 |
|---|---|
| `ClientCredentialsClientSecret` | 토큰 요청의 **request body** |
| `ClientCredentialsClientSecretBasic` | Basic 인증처럼 **Authorization 헤더** |
| `ClientCredentialsJwtAssertion` | client secret 대신 **JWT assertion** |

### Browser Flow — Authorization Code (사용자 대화형)

- Authentication Flow Type = **Browser Flow** (OAuth 2.0 Authorization Code). 토큰 엔드포인트에 더해 **Authorization URL**(authorize endpoint)이 필수다 — Metadata API `ExternalAuthIdentityProvider`에서 `authenticationFlow=AuthorizationCode`일 때 `AuthorizeUrl` 파라미터 필수, `ClientCredentials`일 때는 `TokenUrl`만으로 충분.
- 외부 IdP(인증 서버)에 Salesforce 콜백 URL을 등록해야 한다: `https://[인스턴스].salesforce.com/services/authcallback/[NC_Name]` (아래 주의사항 참조).
- **Per-User Principal**과 결합하면 각 사용자가 개별적으로 OAuth 인증을 수행하고, 각자의 토큰으로 callout이 나간다. Named Principal이면 공유 서비스 계정 하나로 최초 1회 관리자가 인증한다.

> 배포 관점: OAuth 엔드포인트 구성은 Metadata API v62.0+에서 `ExternalAuthIdentityProvider` 타입(`authenticationFlow` = `AuthorizationCode` | `ClientCredentials`, `TokenUrl`·`AuthorizeUrl` 파라미터)으로 분리 관리할 수 있고, External Credential(v56.0+, `.externalCredential`)이 이를 참조한다.

---

## 보안 모범 사례

> [!tip] Named Credential 사용 이유
> 1. URL/비밀번호가 Apex 코드에 노출되지 않음
> 2. 환경별(Sandbox/Production) URL 분리 관리
> 3. Salesforce가 토큰 갱신 자동 처리 (OAuth)
> 4. 감사 로그에서 추적 가능

---

## 주의사항

- **Remote Site Setting 불필요** — Named Credential을 사용하는 Apex callout은 Remote Site Setting을 별도로 등록하지 않아도 된다. Named Credential 자체가 허용 목록 역할을 한다.
- **경로(path)는 코드에서 지정** — Named Credential에는 Base URL만 저장한다. 리소스 경로(`/api/v1/users`)는 `callout:NC_Name/api/v1/users` 형태로 Apex 코드에서 이어 붙인다.
- **Per-User Principal과 실행 컨텍스트** — Per-User Identity Type을 사용할 때 배치/큐어블 등 비동기 컨텍스트에서는 사용자 컨텍스트가 없어 인증 정보를 찾지 못할 수 있다. Named Principal을 사용하거나 실행 컨텍스트를 확인한다.
- **테스트에서의 callout 모킹** — `@isTest`에서도 `HttpCalloutMock`을 구현해 callout을 모킹해야 한다. Named Credential을 사용해도 테스트 메서드에 `Test.setMock()`은 필수.
- **외부 인증 흐름 (OAuth)** — OAuth 2.0 설정 시 콜백 URL을 외부 시스템에 등록해야 한다. Salesforce 콜백 URL은 `https://[인스턴스].salesforce.com/services/authcallback/[NC_Name]` 형식.

## 관련 노트

- [[RestClient 패턴]]
- [[Custom REST Endpoint]]
- [[StubProvider]] — ConnectApi 래퍼 테스트
- [[Queueable + Callout 패턴]] — Named Credential을 사용하는 비동기 외부 호출 패턴
- [[Secure Communications (TLS)]] — 외부 callout의 TLS·HTTPS 강제와 인증서 검증
- [[민감 데이터 저장]] — 자격증명·토큰 등 비밀 정보 보관 위협과 secure storage
- [[integration-connectivity-generate]] (sf-skill — 실행형) — Named/External Credential·통합 런타임 구성 실행형 스킬

