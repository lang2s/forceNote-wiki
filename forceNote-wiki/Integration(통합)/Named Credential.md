---
tags: [salesforce, integration, named-credential, security, pattern]
source: apex-recipes/RestClient.cls, NamedCredentialRecipes.cls; help.salesforce.com — Enable External Credential Principals (nc_enable_ext_cred_principal, Tier 2); salesforce_apex_developer_guide.pdf — Merge Fields for Apex Callouts That Use Named Credentials (Tier 2); api_meta.pdf v67.0 — ExternalCredential·ExternalAuthIdentityProvider + salesforce_apex_reference_guide.pdf — ConnectApi NamedCredentials (Tier 2); developer.salesforce.com — Metadata API ExternalAuthIdentityProvider·ExternalCredential (v62.0 Winter '25, Tier 2); help.salesforce.com — Named Credentials / Create or Edit an External Auth Identity Provider (Tier 2); developer.salesforce.com — Using Certificates for Apex Callouts (client certificate·two-way SSL, Tier 2); developer.salesforce.com — Populate External Credential Principals (Named vs Per-User Principal, Tier 2)
created: 2026-05-17
aliases: [Named Credential, 네임드 크레덴셜, callout:, External Credential, External Auth Identity Provider, ExternalAuthIdentityProvider, 외부 인증 아이덴티티 공급자, OAuth Client Credentials 설정, Credential merge field]
---

# Named Credential

> 외부 시스템 URL과 인증 정보를 Salesforce에 저장하고 Apex에서 `callout:{NC_Name}` 형식으로 참조. 코드에 URL/비밀번호를 하드코딩하지 않는 Salesforce 표준 방식.

---

## 개념

외부 시스템을 Apex callout으로 연동할 때 URL과 인증 정보를 코드에 직접 쓰면 두 가지 문제가 생긴다. 첫째, 비밀번호나 API Key가 소스 코드에 노출되어 버전 관리 시스템에 평문으로 저장된다. 둘째, Sandbox와 Production이 서로 다른 엔드포인트를 써야 할 때 코드를 배포해야 변경된다.

Named Credential은 이 두 문제를 모두 해결하는 Salesforce 표준 메커니즘이다. URL과 인증 정보를 Setup에 저장하고, Apex 코드에서는 `callout:NC_Developer_Name` 형식의 논리적 이름만 사용한다. 환경별로 Named Credential 레코드의 URL만 바꾸면 코드 변경 없이 엔드포인트를 교체할 수 있다. OAuth 2.0 프로토콜을 사용할 경우 Salesforce가 토큰 갱신을 자동으로 처리해 만료된 토큰 관련 에러를 직접 처리하지 않아도 된다.

**Winter '23 (API v56.0)** 부터 Legacy Named Credential과 신형 Named Credential + External Credential 구조로 분리되었다(2022-10 발표·GA). 신형 구조에서는 인증 정보(External Credential)와 엔드포인트 URL(Named Credential)을 각각 독립적으로 관리할 수 있다.

> 근거: developer.salesforce.com — [Announcing the Next Generation of Named Credentials](https://developer.salesforce.com/blogs/2022/10/announcing-the-next-generation-of-named-credentials)(2022-10). frontmatter의 `ExternalCredential v56.0`과 일치.

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

### Custom 인증 프로토콜 + 사용자 정의(Named) 인증 파라미터 — `{!$Credential.<ExtCred>.<Param>}`

위 표의 6개 merge field(`Username`·`Password`·`OAuthToken`·`AuthorizationMethod`·`AuthorizationHeaderValue`·`OAuthConsumerKey`)는 **표준 프로토콜(Password·OAuth)** 이 자동으로 채워주는 고정 값이다. 외부 시스템이 이 틀에 안 맞는 자격증명(예: 테넌트 ID, HMAC 서명 키, 커스텀 API Key 이름, 지역 코드)을 요구하면, External Credential의 **Authentication Protocol을 `Custom`으로** 두고 **임의의 Named Authentication Parameter를 직접 정의**한다. 표준 6개와 달리 파라미터 이름을 개발자가 정하고, 참조 구문도 External Credential 이름을 명시하는 확장 형식을 쓴다.

```
표준(프로토콜 자동)  : {!$Credential.Username}                        ← 이름 고정, 값 자동
Custom(직접 정의)   : {!$Credential.<외부자격증명DeveloperName>.<파라미터명>}  ← 이름·값 모두 사용자 정의
```

**설정 순서:**

```
1. Setup → Security → Named Credentials → External Credentials 탭 → New
2. Authentication Protocol = Custom
3. 저장 → Principals 섹션 → New: Principal 생성
   → Authentication Parameters에 원하는 이름·값을 행 단위로 추가
     (예: TenantId = 12345 · SigningKey = <secret> — 값은 암호화 저장, 사용자에게 비노출)
4. Callout Options에서 Allow Formulas in HTTP Header / Body 체크
   (Custom 파라미터도 merge field로 치환되므로 표준 merge field와 동일 전제)
5. Permission Set → External Credential Principal Access에 이 Principal을 Enabled로 매핑
   → callout 실행 사용자에게 할당 (아래 "신형 모델 필수 셋업"과 동일)
```

```apex
// Custom 파라미터를 헤더에 참조 — External Credential DeveloperName 을 반드시 명시
// (표준 6개와 달리 <ExtCred> 세그먼트가 추가된다)
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:MyCustomNC/api/v1/resource');
req.setMethod('GET');
req.setHeader('X-Tenant-Id',  '{!$Credential.MyExternalCred.TenantId}');
req.setHeader('X-Signature',  '{!$Credential.MyExternalCred.SigningKey}');
HttpResponse res = new Http().send(req);
```

- 참조 구문은 `{!$Credential.<외부자격증명 DeveloperName>.<파라미터명>}` — 표준 merge field(`{!$Credential.Username}`)와 달리 **External Credential DeveloperName 세그먼트가 하나 더** 들어간다. 파라미터명은 Principal의 Authentication Parameter에 정의한 이름과 **정확히 일치**해야 한다.
- 바디에서도 동일하게 참조하며 `Allow Formulas in HTTP Body`가 필요하다. 값은 실행 시점에 치환되고, Named Principal이면 조직 공유 1개 값, Per-User이면 사용자별 값이 들어간다.
- Custom 파라미터 값은 Principal에 암호화 저장되어 실행 사용자에게 노출되지 않는다 — Apex에서 값 자체를 문자열로 읽어오는 게 아니라 **callout 치환 시점에만** 주입된다.

> 근거: [Authentication Protocols for Named Credentials](https://help.salesforce.com/s/articleView?id=xcloud.nc_auth_protocols.htm) — Custom 프로토콜은 permission set·sequence number·authentication parameter(각 name/value)로 구성. [Use Custom Headers for Basic Authentication](https://help.salesforce.com/s/articleView?id=xcloud.nc_custom_headers_basic_auth.htm) — 커스텀 헤더에서 `{!$Credential.<ExternalCredName>.<ParamName>}` 형식으로 Principal 파라미터를 참조하며 *Allow Formulas in HTTP Header* 활성화 필요.

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

### Identity Type — Named Principal vs Per-User Principal

External Credential의 Principal은 **누가 외부 시스템에 인증하는가**를 결정한다. Named Credential(또는 Legacy Named Credential)의 Identity Type과 동일한 축이다.

| 구분 | Named Principal | Per-User Principal |
|---|---|---|
| 인증 주체 | 관리자가 조직당 **자격증명 1개**로 최초 1회 인증 | **각 사용자**가 자신의 자격증명으로 개별 인증 |
| 토큰 저장 | 조직 단위 공유 자격증명 1개 | **사용자별 개별 토큰** (User External Credentials 레코드) |
| 외부 시스템이 보는 신원 | 공유 서비스 계정 1개 — 모든 callout이 동일 신원으로 나감 | 실제 호출 사용자 각각의 신원 |
| 사용 시나리오 | 시스템 통합, 전체 데이터 접근이 필요하거나 팀·조직 단위 집계를 볼 때 | 외부 시스템의 **사용자별 권한**이 중요할 때 (예: 각 사용자의 메일함·문서 접근을 그 사용자 권한으로) |
| Permission Set 매핑 | External Credential Principal Access에 Principal 1개를 Enabled로 이동 | 위와 동일 + **각 사용자에게 User External Credentials sObject 접근 권한**이 추가로 필요(토큰이 사용자별로 저장되므로) |

> Per-User Principal은 위 "[[#⚠️ 신형 모델 필수 셋업 — External Credential Principal 접근 권한 부여|신형 모델 필수 셋업]]"의 Permission Set 매핑에 더해, 사용자가 자신의 `User External Credentials` 레코드를 읽을 수 있어야 토큰이 조회된다. 비동기(Batch·Queueable) 컨텍스트에서는 사용자 컨텍스트가 없어 Per-User 토큰을 찾지 못할 수 있으므로 Named Principal을 쓴다(아래 "주의사항" 참조).
>
> 근거: [Populate External Credential Principals](https://developer.salesforce.com/docs/platform/named-credentials/guide/nc-populate-external-credentials.html) — Named Principal은 조직당 공유 자격증명 1개, Per-User는 사용자별 개별 자격증명. Per-User는 `User External Credentials` 오브젝트 접근이 필요.

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

> [!warning] Profile이 아니라 Permission Set에 매핑하라 — 배포 안 됨
> External Credential Principal Access는 **Profile에도** 매핑할 수 있지만, Profile로 매핑하면 그 매핑이 **Metadata API에 노출되지 않아** sandbox↔production 배포(change set·Metadata API·CI/CD)로 옮겨지지 않는다. **Permission Set에 매핑**할 때만 `externalCredentialPrincipalAccesses` 메타데이터로 노출되어 배포 가능하다. 위 절차대로 항상 Permission Set을 쓰고, 각 환경마다 Profile 매핑을 수동 재설정하는 함정을 피한다.
>
> 근거: [ExternalCredential (Metadata API)](https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_externalcredential.htm) 및 [Map External Credential Principals to Permission Sets](https://help.salesforce.com/s/articleView?id=release-notes.rn_security_map_principals_to_permsets.htm) — Principal Access를 Permission Set에 할당하면 Metadata API로 배포되지만 Profile 할당은 대응 메타데이터가 없어 배포되지 않는다.

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

## External Auth Identity Provider — OAuth 토큰 엔드포인트를 재사용 컴포넌트로 분리

신모델 콜아웃 인증은 **Named Credential → External Credential → External Auth Identity Provider** 3계층이다. 앞의 두 계층(엔드포인트 URL·Principal 자격증명)은 위에서 다뤘고, 이 절은 세 번째 계층인 **External Auth Identity Provider**를 다룬다.

### 무엇 · 왜

**External Auth Identity Provider**는 External Credential에 링크되어 **아웃바운드 콜아웃용 OAuth 토큰을 발급받는** 재사용 컴포넌트다. OAuth의 토큰/인증 엔드포인트(TokenUrl·AuthorizeUrl 등)와 흐름 종류를 한 곳에 정의해 두고, 여러 External Credential이 이를 룩업으로 공유한다.

레거시 [[Auth Provider (인증 공급자)]]도 콜아웃용 토큰을 공급할 수 있지만, External Auth Identity Provider는 두 가지 차별점이 있다.

| 차별점 | 설명 |
|---|---|
| **패키징 가능** | 관리형 패키지(2GP/1GP)로 배포 가능. 레거시 Auth Provider는 관리형 패키지에 넣을 수 없었다. |
| **custom Apex 불필요 옵션** | 표준 OAuth IdP라면 `Auth.AuthProviderPluginClass` 같은 커스텀 Apex 없이 엔드포인트만 배선해 토큰을 받을 수 있다. |

> Salesforce 공식 권고 원문: *"use an externalAuthIdentityProvider instead of an authProvider"* — **신 IdP가 권장 대체제이고 authProvider가 레거시**다. 다만 소셜 로그인·SSO(inbound)나 Registration Handler가 필요하면 그 용도는 여전히 Auth Provider의 몫이다(→ [[Auth Provider (인증 공급자)]]).

### 언제 쓰나

- 표준 OAuth IdP(토큰 엔드포인트가 명확한 서비스)를 **Auth Provider 없이 직접** External Credential에 배선하고 싶을 때.
- 이 인증 구성을 **관리형 패키지로 배포**해야 할 때(2GP 패키징 대상). Auth Provider는 패키징이 안 되므로 이 컴포넌트가 유일한 선택.

### 도입 버전

Metadata API `ExternalAuthIdentityProvider` 타입은 **v62.0(Winter '25)에 도입**되었고, 관련 릴리즈노트 "Simplify OAuth Configurations with External Auth Identity Provider"는 **Spring '25**에 나왔다. 즉 "Metadata v62.0(Winter '25) 도입, Spring '25 OAuth 구성 간소화"로 이해한다(단일 시즌으로 단정하지 않는다). `ConnectApi.NamedCredentials`는 v66.0+에서 `deleteExternalAuthIdentityProvider`·`updateExternalAuthIdentityProvider`를 추가해 코드로도 관리할 수 있다(→ Release 노트).

### Metadata 구조 (필드·enum)

| 필드 | 필수 | 값 |
|---|---|---|
| `label` | ✅ | 표시명 |
| `description` | — | 설명 |
| `authenticationFlow` | — | enum: `AuthorizationCode` · `ClientCredentials` · `SalesforceDefined` |
| `authenticationProtocol` | — | enum: `OAuth` · `SalesforceDefined` |
| `externalAuthIdentityProviderParameters[]` | — | 엔드포인트·파라미터 목록(아래) |

**⚠️ Token/Authorize URL은 독립 명명 필드가 아니다.** 엔드포인트·설정은 `externalAuthIdentityProviderParameters` 항목의 반복으로 표현되며, 각 항목은 **속성**(`parameterName` · `parameterType` · `parameterValue` · `sequenceNumber` · `description`)을 갖고, 그중 `parameterType`이 아래 **엔드포인트 종류 값**을 취한다:

```
# parameterType 값 (엔드포인트·요청 파라미터 종류)
TokenUrl · AuthorizeUrl · UserInfoUrl · ClientAuthentication
TokenRequestBodyParameter · TokenRequestHttpHeader · TokenRequestQueryParameter
RefreshRequestBodyParameter · RefreshRequestHttpHeader · RefreshRequestQueryParameter
IdentityProviderOptions · StandardExternalIdentityProvider
```

즉 "Token Endpoint URL 필드"처럼 옮겨 적지 말고 **`parameterType=TokenUrl`인 파라미터 항목**으로 이해한다. (파라미터 속성·값 목록이 패키징 맥락으로 [[2GP — Components - Security & Access]]에도 있다.)

### 설정·배선 절차

접근 권한: **Customize Application** 또는 **Manage Named Credentials**.

```
// 구조 예시 — 실제 org 화면 순서 요약(동작 코드 아님)
1. Setup → Named Credentials 영역
   → "Create or Edit an External Auth Identity Provider"
2. authenticationFlow 선택
   · AuthorizationCode  (= Browser Flow, 사용자 대화형)
   · ClientCredentials  (서버-투-서버)
3. 파라미터 입력 (parameterType 값으로)
   · TokenUrl     — 필수 (모든 흐름에서 토큰 엔드포인트)
   · AuthorizeUrl — authenticationFlow=AuthorizationCode일 때 필수
   · UserInfoUrl·ClientAuthentication 등 — 필요 시
4. External Credential(OAuth 2.0 프로토콜) 편집 화면에서
   "External Authentication Identity Provider" 룩업으로 이 컴포넌트를 연결
   (같은 자리에 있는 Auth Provider 룩업과 택일 — 신모델은 이쪽 권장)
5. 이후는 위 OAuth 절차와 동일 — Principal·Permission Set 매핑까지 완료하면
   Apex는 callout:{NC_DeveloperName}만 쓰면 토큰 발급·갱신 자동
```

> [!note] Setup 라벨은 라이브 org에서 다를 수 있음 (Tier 2)
> 위 절차의 필드명은 Metadata/Tooling API의 필드·enum 기준으로 기술했다. 실제 Setup UI의 라벨 문구는 릴리스·org에 따라 다를 수 있으므로 화면에 표시된 라벨을 그대로 따른다. 생성 화면의 필드 전수 카탈로그는 [[Named Credential·External Credential 생성 필드 전수 레퍼런스]] §4-1(OAuth 2.0)로 위임한다.

---

## 아웃바운드 상호 TLS (Mutual TLS · Two-Way SSL) — 클라이언트 인증서 제시

일반 HTTPS callout은 **단방향 TLS**다 — Salesforce가 서버 인증서만 검증한다. 외부 시스템이 상호 인증(mTLS)을 요구하면, Salesforce가 TLS handshake 중에 **자신의 클라이언트 인증서를 제시**해 서버가 Salesforce를 검증하게 해야 한다. 이는 앞의 인증 프로토콜(OAuth·Password 등)과 **직교하는 전송 계층 인증**으로, 필요하면 함께 쓸 수 있다.

**셋업 경로:**

```
1. Setup → Security → Certificate and Key Management
   · Create Self-Signed Certificate  (자체 서명), 또는
   · Create CA-Signed Certificate Request → CA 서명본을 다시 import
   → 생성된 인증서의 Unique Name 기록
2. (자체 서명인 경우) 이 Salesforce 인증서를 외부 시스템의
   truststore/keystore에 등록해 신뢰시킨다.
3. 콜아웃에 클라이언트 인증서를 지정 — 두 경로 중 하나:
```

| 지정 방법 | 설명 |
|---|---|
| **Named Credential의 `Certificate` 필드** | Legacy Named Credential(및 신형에서는 External Credential의 Custom · Mutual TLS 인증) 편집 화면의 **Certificate** 룩업에서 1번의 인증서를 선택. 이후 `callout:{NC}` 호출이 handshake에서 인증서를 자동 제시 → Apex 코드 수정 불필요 |
| **Apex 직접 — `HttpRequest.setClientCertificateName()`** | 코드에서 인증서 Unique Name을 지정. Named Credential의 Certificate 필드를 안 쓰는 경우에 사용 |

```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:MyMutualTLS/api/v1/secure');
req.setMethod('GET');

// Named Credential의 Certificate 필드로 인증서를 지정했다면 아래 줄은 불필요.
// 코드에서 직접 클라이언트 인증서를 붙이려면:
req.setClientCertificateName('DocSampleCert'); // ← Certificate and Key Management의 Unique Name과 정확히 일치

HttpResponse res = new Http().send(req);
```

- 인수 값은 **Certificate and Key Management에서 생성한 인증서의 Unique Name과 정확히 일치**해야 한다.
- mTLS 엔드포인트가 별도 포트(예: `8443`)를 쓰면 Named Credential URL에 포트를 명시한다.
- 자체 서명 인증서는 외부 시스템이 명시적으로 신뢰해야 하고, CA 서명 인증서는 서버가 CA 체인으로 검증한다. mTLS로 인증하는 상대는 보통 CA 서명 인증서를 요구한다.

> 근거: [Using Certificates (Apex Developer Guide)](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_callouts_client_certs.htm) — 인증서 생성 → 코드 연동 → (자체 서명 시) 외부 keystore 공유 → (Named Credential 미사용 시) Remote Site 등록. HTTP 요청은 `HttpRequest.setClientCertificateName(uniqueName)`로 클라이언트 인증서를 붙인다. 전송 계층 개념은 [[Secure Communications (TLS)]] 참조.

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

- [[Named Credential·External Credential 생성 필드 전수 레퍼런스]] — 생성 화면의 모든 필드·프로토콜별 조건부 필드 카탈로그
- [[서버간 통합 구축 가이드 - External Client App·JWT Bearer·Client Credentials]] — Named Credential을 서버간 인증에 배선하는 전체 절차
- [[RestClient 패턴]]
- [[Custom REST Endpoint]]
- [[StubProvider]] — ConnectApi 래퍼 테스트
- [[Queueable + Callout 패턴]] — Named Credential을 사용하는 비동기 외부 호출 패턴
- [[Secure Communications (TLS)]] — 외부 callout의 TLS·HTTPS 강제와 인증서 검증
- [[민감 데이터 저장]] — 자격증명·토큰 등 비밀 정보 보관 위협과 secure storage
- [[integration-connectivity-generate]] (sf-skill — 실행형) — Named/External Credential·통합 런타임 구성 실행형 스킬

