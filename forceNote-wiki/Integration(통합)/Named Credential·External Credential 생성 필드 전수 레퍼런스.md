---
tags: [salesforce, integration, named-credential, external-credential, setup, field-reference, oauth, security]
source: developer.salesforce.com — Metadata API NamedCredential·ExternalCredential·ExternalAuthIdentityProvider (meta_namedcredential.htm·meta_externalcredential.htm, ExternalAuthIdentityProvider v62.0 Winter '25, Tier 2); help.salesforce.com — Create Named Credentials and External Credentials·Authentication Protocols for Named Credentials (nc_named_creds_and_ext_creds·nc_auth_protocols, Tier 2); developer.salesforce.com — Populate External Credential Principals (nc-populate-external-credentials, Tier 2)
created: 2026-07-07
aliases: [Named Credential 생성 필드, External Credential 생성 필드, 네임드 크레덴셜 필드 카탈로그, Authentication Protocol 필드, OAuth Authentication Flow Type, Principal Authentication Parameters, Enabled for Callouts, Generate Authorization Header, Allow Formulas in HTTP Header]
---

# Named Credential·External Credential 생성 필드 전수 레퍼런스

> Setup에서 Named Credential·External Credential을 만들 때 화면에 나오는 **모든 입력·선택·체크박스 필드**를 프로토콜별 분기까지 빠짐없이 카탈로그화한 필드 레퍼런스. 개념·Apex 사용법은 [[Named Credential]]로 위임하고, 이 노트는 "무슨 칸을 채우나"만 다룬다.

---

## 이 노트의 범위와 매핑 원칙

Setup UI의 필드 라벨은 **Metadata API 타입(`NamedCredential`·`ExternalCredential`)의 필드/enum과 1:1로 대응**한다. 아래 표는 UI 라벨(사람이 보는 이름)과 Metadata 필드(배포·API명)를 함께 실어 어느 쪽에서 봐도 찾을 수 있게 했다. Metadata 필드명·enum 값은 공식 Metadata API 문서에서 verbatim 추출한 Tier 2다.

> 근거: [NamedCredential (Metadata API)](https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_namedcredential.htm) · [ExternalCredential (Metadata API)](https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_externalcredential.htm) · [Authentication Protocols for Named Credentials](https://help.salesforce.com/s/articleView?id=xcloud.nc_auth_protocols.htm)

**신모델은 두 오브젝트로 분리된다:** **Named Credential**(엔드포인트 URL + 콜아웃 옵션) → **External Credential**(인증 방식 + Principal)을 룩업으로 참조. Legacy Named Credential은 이 둘을 한 레코드에 합친 구형이다.

```
// 구조 예시 — 실제 원본 다이어그램 아님
신모델:  Named Credential ──(External Credential 룩업)──▶ External Credential
          · URL                                            · Authentication Protocol
          · Enabled for Callouts                           · Principals (Named/Per-User)
          · Generate Authorization Header                    └ Authentication Parameters
          · Allow Formulas in HTTP Header/Body             · Custom Headers
          · Custom Headers                                 → Permission Set: External Credential
          · Outbound Network Connection                       Principal Access (필수 후속)
```

---

## 1. Named Credential (신모델 · `namedCredentialType = SecuredEndpoint`) 생성 필드

Setup → Security → **Named Credentials** → New. 신모델에서 Named Credential은 **엔드포인트와 콜아웃 동작 옵션**만 들고, 인증은 External Credential에 위임한다.

| # | UI 필드 | 유형 | 필수 | 값/옵션 | 의미 · on/off 효과 | Metadata |
|---|---|---|---|---|---|---|
| 1 | **Label** | 텍스트 입력 | ✅ | 자유 문자열 | 화면 표시명 | `label` |
| 2 | **Name** (API/Developer Name) | 텍스트 입력 | ✅ | 영숫자+`_` | Apex `callout:{Name}`에서 참조하는 논리명 | (fullName) |
| 3 | **URL** | 텍스트 입력 | ✅ | `https://host[:port]` (base URL, path 제외) | 외부 시스템 base URL. 경로는 코드에서 이어 붙임 | `parameterType=Url`의 `parameterValue` |
| 4 | **External Credential** | 룩업(선택) | ⛳ 인증 필요 시 | 기존 External Credential 1개 | 이 NC가 쓸 인증 정보. No-Auth 순수 공개 API면 생략 가능 | `parameterType=Authentication`의 `externalCredential` |
| 5 | **Enabled for Callouts** | 체크박스 | — | on/off (기본 on) | **on**: Apex/Flow/External Service의 HTTP callout에서 이 NC 사용 가능. **off**(`Disabled`): 존재하되 callout 차단 | `calloutStatus` = `Enabled`\|`Disabled` (API 59.0+) |
| 6 | **Generate Authorization Header** | 체크박스 | — | on/off (기본 on) | **on**: Salesforce가 프로토콜에 맞는 `Authorization` 헤더를 자동 생성해 붙임. **off**: 자동 헤더 없음 → 코드/Custom Header로 직접 인증 주입해야 함 | `generateAuthorizationHeader` (API 41.0+) |
| 7 | **Allow Formulas in HTTP Header** | 체크박스 | — | on/off (기본 off) | **on**: Apex 코드가 `setHeader`에서 merge field(`{!$Credential...}`)로 헤더 값을 채울 수 있음. off면 merge field 미치환 | `allowMergeFieldsInHeader` (API 41.0+) |
| 8 | **Allow Formulas in HTTP Body** | 체크박스 | — | on/off (기본 off) | **on**: Apex `setBody`에서 merge field로 바디를 채울 수 있음(`HTMLENCODE`만 허용). off면 미치환 | `allowMergeFieldsInBody` (API 41.0+) |
| 9 | **Outbound Network Connection** | 룩업(선택) | 선택 | Private Connect 연결 1개 | Private Connect/AWS PrivateLink 경유 아웃바운드. `namedCredentialType=PrivateEndpoint`일 때 사용 | `parameterType=OutboundNetworkConnection`의 `outboundNetworkConnection` |
| 10 | **Allowed Namespaces** (Namespace) | 텍스트/멀티 입력 | 선택 | 관리형 패키지 네임스페이스 목록 | 이 NC를 참조할 수 있는 managed package 네임스페이스 제한 | `parameterType=AllowedManagedPackageNamespaces` |
| 11 | **Custom Headers** (섹션) | 반복 name/value | 선택 | Name + Value(merge field 가능) | NC 레벨 고정 헤더. → 아래 [6. Custom Headers](#6-custom-headers-섹션-필드) | `parameterType=HttpHeader` (+ `sequenceNumber`) |

- **Type 선택**(신규 생성 첫 화면): 화면에서 `namedCredentialType`을 고른다 — `SecuredEndpoint`(신모델·인증 있음), `Standard`(인증 없는 신모델), `PrivateEndpoint`(Outbound Network Connection 사용), `Legacy`(구모델). Tier 2 (`namedCredentialType` enum, API 56.0+).

---

## 2. Legacy Named Credential (`namedCredentialType = Legacy`) 필드 — 신모델과 차이

Legacy는 URL·인증·Principal을 **한 레코드에** 담는다. 아래 필드들은 **v56.0에서 deprecated**(신모델은 External Credential로 이동)지만, 기존 Legacy 레코드 편집 화면에는 여전히 나온다.

| UI 필드 | 유형 | 값/옵션 | 신모델과 차이 | Metadata (deprecated v56.0+) |
|---|---|---|---|---|
| **Label / Name / URL** | 텍스트 | — | 신모델과 동일 | `label` / (fullName) / `endpoint` |
| **Identity Type** | 선택(picklist) | Anonymous / Named Principal / Per User Principal | 신모델은 External Credential의 Principal로 이동 | `principalType` = `Anonymous`\|`NamedUser`\|`PerUser` |
| **Authentication Protocol** | 선택 | No Authentication / Password Authentication / OAuth 2.0 / AWS Signature Version 4 / JWT / JWT Token Exchange | 신모델은 External Credential로 이동. **No Authentication은 legacy에서 사용 불가** | `protocol` = `NoAuthentication`\|`Password`\|`Oauth`\|`AwsSv4`\|`Jwt`\|`JwtExchange` |
| **Username / Password** | 텍스트/암호 | Password 프로토콜일 때 | Principal로 이동 | `username` / `password` |
| **Auth Provider** | 룩업 | OAuth 2.0일 때 [[Auth Provider (인증 공급자)]] 선택 | 신모델은 External Credential 파라미터 | `authProvider` |
| **Scope** | 텍스트 | OAuth scope | 신모델은 External Credential 파라미터 | `oauthScope` (+ `oauthToken`·`oauthRefreshToken`) |
| **AWS Access Key / Access Secret / Region / Service** | 텍스트/암호 | AWS Sig v4일 때 | Principal의 Authentication Parameters로 이동 | `awsAccessKey`·`awsAccessSecret`·`awsRegion`·`awsService` |
| **Token Endpoint URL** | 텍스트 | JWT Token Exchange일 때 access token 교환 URL | External Credential로 이동 | `authTokenEndpointUrl` |
| **JWT Issuer / Subject / Audience / Signing Certificate / Validity(초)** | 텍스트/룩업 | JWT일 때 | External Credential 파라미터로 이동 | `jwtIssuer`·`jwtTextSubject`/`jwtFormulaSubject`·`jwtAudience`·`jwtSigningCertificate`·`jwtValidityPeriodSeconds` |
| **Certificate** | 룩업 | 아웃바운드 mTLS 클라이언트 인증서 | 신모델은 NamedCredentialParameter `ClientCertificate` | `certificate` |
| **Generate Authorization Header / Allow Merge Fields in Header / Body** | 체크박스 | 신모델과 동일 3체크박스 | 동일 | `generateAuthorizationHeader`·`allowMergeFieldsInHeader`·`allowMergeFieldsInBody` |

> [!note] Legacy vs 신모델 핵심 차이
> ① Legacy = 1레코드에 URL+인증. 신모델 = Named Credential(URL) + External Credential(인증) 2레코드. ② **No Authentication은 신모델(External Credential) 전용** — legacy엔 없음. ③ **JWT Token Exchange(`JwtExchange`)는 legacy 지원, External Credential은 미지원**(External Credential은 JWT까지만). ④ 신모델은 Principal을 Permission Set에 매핑(배포 가능), legacy는 레코드 자체에 자격증명 저장.

---

## 3. External Credential 공통 필드 + Authentication Protocol (선택값 전수)

Setup → Security → Named Credentials → **External Credentials** 탭 → New.

| UI 필드 | 유형 | 필수 | 값/옵션 | 의미 | Metadata |
|---|---|---|---|---|---|
| **Label** | 텍스트 | ✅ | 자유 문자열 | 표시명 | `label` |
| **Name** | 텍스트 | ✅ | 영숫자+`_` | Developer Name. merge field `{!$Credential.<Name>.<Param>}`에서 참조 | (fullName) |
| **Description** | 텍스트 | 선택 | 자유 문자열 | 설명 | `description` |
| **Authentication Protocol** | 선택(picklist) | ✅ | 아래 8종 | 외부 시스템과의 인증 방식. 선택에 따라 하위 필드·Principal 파라미터가 달라짐 | `authenticationProtocol` |

### Authentication Protocol 선택값 전수 (`authenticationProtocol` enum)

| UI 라벨 | enum 값 | 요약 | External Credential 지원 | Legacy 지원 |
|---|---|---|---|---|
| **No Authentication** | `NoAuthentication` | 인증 없음(공개 API·API Key를 Custom Header로) | ✅ | ❌ (legacy 불가) |
| **Basic** | `Basic` | username/password 정적 자격증명(Password를 Permission Set 매핑으로 강화) | ✅ | — (legacy는 `Password`) |
| **(Password)** | `Password` | Basic의 legacy 계열 값 | — | ✅ |
| **OAuth 2.0** | `Oauth` | OAuth 2.0 토큰 발급·자동 갱신 | ✅ | ✅ |
| **AWS Signature Version 4** | `AwsSv4` | AWS 서명 v4 | ✅ | ✅ |
| **JWT** | `Jwt` | JSON Web Token | ✅ | ✅ |
| **JWT Token Exchange** | `JwtExchange` | JWT를 access token으로 교환 | ❌ (미지원) | ✅ |
| **Custom** | `Custom` | 사용자 정의 Authentication Parameter | ✅ | ❌ |

> 근거: `authenticationProtocol` valid values = `AwsSv4·Basic·Custom·Jwt·JwtExchange·NoAuthentication·Oauth·Password` (ExternalCredential Metadata). External Credential은 legacy 프로토콜을 거의 그대로 지원하되 **JWT Token Exchange만 예외로 미지원**, 대신 **Custom** 옵션을 추가로 제공 (Authentication Protocols for Named Credentials).

---

## 4. Authentication Protocol별 조건부 하위 필드 전수

프로토콜을 고르면 나타나는 필드가 다르다. 신모델에서 실제 자격증명(키·비번·토큰)은 대부분 **External Credential 레코드 자체가 아니라 그 아래 Principal의 Authentication Parameters**에 입력한다(암호화 저장). 아래는 프로토콜 레벨 설정 + Principal 파라미터를 함께 정리했다. Metadata에서 각 값은 `ExternalCredentialParameter.parameterType`으로 표현된다.

### 4-1. OAuth 2.0 (`Oauth`)

| UI 필드 | 유형 | 값/옵션 | 의미 | `parameterType` |
|---|---|---|---|---|
| **Authentication Flow Type** | 선택 | Browser Flow / Client Credentials with Client Secret / Client Credentials with JWT Assertion / JWT Bearer Token(JWT Bearer Flow) | OAuth grant 종류 결정 | `AuthProtocolVariant` |
| **Identity Provider / Auth Provider** | 룩업 | 기존 [[Auth Provider (인증 공급자)]] | Browser Flow에서 로그인 서비스 정의 | `AuthProvider` |
| **Identity Provider URL** (Auth Provider URL) | 텍스트 | 토큰/authorize 엔드포인트 URL | 외부 IdP 엔드포인트 | `AuthProviderUrl` (+ `AuthProviderUrlQueryParameter`) |
| **External Authentication Identity Provider** | 룩업 | `ExternalAuthIdentityProvider` 컴포넌트 | v62.0+ 분리 관리(TokenUrl/AuthorizeUrl) | `ExternalAuthIdentityProvider` |
| **Scope** | 텍스트 | 공백 구분 scope (Browser Flow는 비워도 됨) | 요청 OAuth scope | (Principal Auth Parameter) |
| **PKCE** | 체크박스 | on/off | Authorization Code 플로우 보안 강화(권장) | (플로우 옵션) |
| Principal: **Client ID / Client Secret** | 텍스트/암호 | Client Credentials·Browser Flow | 클라이언트 자격증명(Principal에 암호화 저장) | `AuthParameter` |
| Principal: **Signing Certificate** | 룩업 | Client Credentials with JWT Assertion·JWT Bearer | assertion 서명 인증서 | `SigningCertificate` |

- **Authentication Flow Type 옵션 전수**(Tier 2): **Browser Flow**, **Client Credentials with Client Secret**, **Client Credentials with JWT Assertion**, **JWT Bearer Token(JWT Bearer Flow)**. Apex `ConnectApi.CredentialAuthenticationProtocolVariant`의 `ClientCredentialsClientSecret`·`ClientCredentialsClientSecretBasic`·`ClientCredentialsJwtAssertion` variant과 대응.
- **Browser Flow**: 대화형(Authorization Code) — authorize URL 필요, 콜백 `https://<instance>.salesforce.com/services/authcallback/<NC_Name>`을 IdP에 등록. Per-User Principal과 결합하면 사용자별 개별 인증.
- **Client Credentials**: 서버-투-서버(사용자 컨텍스트 없음), refresh token 없음.

#### 4-1a. External Authentication Identity Provider 룩업 (신모델 권장)

OAuth 2.0 External Credential은 토큰 공급 IdP를 **Auth Provider 룩업**과 **External Authentication Identity Provider 룩업** 중 하나로 배선한다 — **택일**이며 콜아웃 인증에서는 **신모델인 External Auth Identity Provider가 권장**이다(공식 권고: *"use an externalAuthIdentityProvider instead of an authProvider"*). 이 컴포넌트는 Metadata `ExternalAuthIdentityProvider`(v62.0 Winter '25 도입)로, 토큰/authorize 엔드포인트를 재사용 가능한 별도 레코드로 분리한다.

| 항목 | 값 | 비고 |
|---|---|---|
| `authenticationFlow` (enum) | `AuthorizationCode` · `ClientCredentials` · `SalesforceDefined` | OAuth grant 종류 |
| `authenticationProtocol` (enum) | `OAuth` · `SalesforceDefined` | 프로토콜 |
| **핵심 `parameterType`** | `TokenUrl`(필수) · `AuthorizeUrl`(`AuthorizationCode`일 때) · `UserInfoUrl` · `ClientAuthentication` | 엔드포인트·인증 파라미터. **독립 필드가 아니라 `externalAuthIdentityProviderParameters`의 `parameterType` 값** |

- ⚠️ Token/Authorize URL은 별도 명명 필드가 아니라 `parameterType` 값(`TokenUrl`·`AuthorizeUrl`)으로 표현된다. 파라미터 전체 목록(약 15개: `UserInfoUrl`·`ClientAuthentication`·`TokenRequestBodyParameter`·`RefreshRequest*` 등)은 패키징 맥락으로 [[2GP — Components - Security & Access]]에, 개념·배선 절차는 [[Named Credential]]의 "External Auth Identity Provider" 절에 있다.
- 설정 위치는 Setup의 **Named Credentials** 영역("Create or Edit an External Auth Identity Provider"), 접근 권한은 Customize Application 또는 Manage Named Credentials.

### 4-2. Basic (`Basic`) / Password

| UI 필드 | 유형 | 위치 | `parameterType` |
|---|---|---|---|
| **Username** | 텍스트 | Principal의 Authentication Parameters | `AuthParameter` |
| **Password** | 암호 입력 | Principal의 Authentication Parameters | `AuthParameter` |

- Named Principal이면 조직 공유 1쌍, Per-User Principal이면 사용자별 입력. `Generate Authorization Header` on이면 `Authorization: Basic base64(user:pass)` 자동 생성.

### 4-3. AWS Signature Version 4 (`AwsSv4`)

variant(서명 방식)에 따라 필드가 다르다.

| Variant | 필요 필드 | `parameterType` |
|---|---|---|
| **Standard** | AWS **Access Key** · **Secret** · **Region** · **Service** | `AuthParameter` (Principal) |
| **STS (STS principal type)** | Access Key · Secret (+ 임시 자격증명) | `AwsStsPrincipal` |
| **STS (Named principal type)** | **Role ARN** 인증서(certificate) | `AwsStsPrincipal` + `SigningCertificate` |
| **STS Roles Anywhere** | Role ARN 인증서 | `AwsStsPrincipal` |

- Region 예: `us-east-1`, Service 예: `s3`·`execute-api`. Standard variant은 Access Key + Secret로 서명. (근거: Populate External Credential Principals — standard=access key/secret, STS named principal=Role ARN certificate.)

### 4-4. JWT (`Jwt`) / JWT Token Exchange (`JwtExchange`, legacy 전용)

| UI 필드 | 유형 | 의미 | Metadata |
|---|---|---|---|
| **Issuer (iss)** | 텍스트 | JWT 발급자 식별자(대소문자 구분) | `jwtIssuer` / `JwtBodyClaim` |
| **Subject (sub)** | 텍스트/수식 | 정적 텍스트 또는 per-user 수식 | `jwtTextSubject`/`jwtFormulaSubject` / `JwtBodyClaim` |
| **Audience (aud)** | 텍스트 | 수신자(JSON) | `jwtAudience` / `JwtBodyClaim` |
| **Signing Certificate** | 룩업 | JWT 서명·검증 인증서 | `jwtSigningCertificate` / `SigningCertificate` |
| **Validity Period (초)** | 숫자 | 토큰 유효 기간 | `jwtValidityPeriodSeconds` |
| **Token Endpoint URL** | 텍스트 | (JwtExchange) JWT→access token 교환 URL | `authTokenEndpointUrl` |
| Custom JWT claims | 반복 name/value | header/body 커스텀 클레임 | `JwtHeaderClaim`·`JwtBodyClaim` |

- External Credential은 **`Jwt`까지 지원**, **`JwtExchange`(JWT Token Exchange)는 legacy Named Credential에서만** 사용 가능.

### 4-5. Custom (`Custom`)

| UI 필드 | 유형 | 의미 | `parameterType` |
|---|---|---|---|
| **Authentication Parameters** | 반복 name/value | 개발자가 이름·값을 임의 정의(테넌트 ID·HMAC 키·지역 코드 등). 암호화 저장 | `AuthParameter` / `CustomPrincipal` |
| **Custom Headers** | 반복 name/value | merge field로 커스텀 파라미터 주입 (`{!$Credential.<ExtCred>.<Param>}`) | `AuthHeader` |

- 표준 프로토콜이 자동 채우는 6개 merge field 틀에 안 맞는 자격증명을 다룰 때 사용. 참조 구문은 External Credential DeveloperName 세그먼트가 추가된 확장형(`{!$Credential.<ExtCred>.<ParamName>}`). 상세는 [[Named Credential]]의 Custom 프로토콜 절 참조.

### 4-6. API Key (Custom Header 패턴)

전용 "API Key" 프로토콜은 별도 enum이 아니라 **No Authentication + Custom Header** 조합으로 구현한다.

| 방법 | 필드 |
|---|---|
| No Authentication + Custom Header | External Credential Protocol = No Authentication → Custom Headers에 `X-API-Key` = `{!$Credential.<ExtCred>.ApiKey}`, Principal의 Authentication Parameter `ApiKey`에 실제 키 저장 |
| Custom 프로토콜 | 위 4-5와 동일, 키를 `AuthParameter`로 정의 |

> 근거: [Use API Keys in Custom Headers with Named Credentials](https://help.salesforce.com/s/articleView?id=sf.nc_custom_headers_and_api_keys.htm) — API Key는 Custom Header + Principal 파라미터로 저장/주입.

---

## 5. Principals 섹션 필드

External Credential 저장 후 **Principals** 섹션에서 New. Principal은 "누가 외부 시스템에 인증하는가"를 정의하고, **실제 자격증명은 여기 Authentication Parameters에 입력**한다.

| UI 필드 | 유형 | 필수 | 값/옵션 | 의미 | Metadata |
|---|---|---|---|---|---|
| **Parameter Name / Principal Name** | 텍스트 | ✅ | 자유 문자열 | Principal 식별명 | `parameterName` |
| **Identity Type** | 선택 | ✅ | Named Principal / Per User Principal | 조직 공유 1자격 vs 사용자별 자격 | `parameterType` = `NamedPrincipal`\|`PerUserPrincipal` (+ `GlobalNamedPrincipal`·`SystemUserPrincipal`) |
| **Sequence Number** | 숫자 입력 | 선택 | 정수(낮을수록 우선) | 사용자가 여러 Principal에 속할 때 어느 매핑을 쓸지 정렬 순서(낮은 값 우선) | `sequenceNumber` |
| **Authentication Parameters** | 반복 name/value | 프로토콜별 | Name + Value(암호화 저장) | 프로토콜별 실제 자격증명 — Basic: Username/Password · OAuth: Client ID/Secret/Scope · AWS: Access Key/Secret/Region/Service · JWT: claims · Custom: 임의 name/value | `AuthParameter` (각 name/value) |
| (**Parameter Group**) | 내부 | — | 기본 `parameterName` 또는 `DEFAULT_GROUP` | 파라미터를 해당 Principal에 그룹핑 | `parameterGroup` |

- **Sequence Number 규칙**(Tier 2): 사용자가 여러 Permission Set을 통해 복수 Principal에 매핑되면, sequence number **낮은→높은** 순으로 정렬해 callout에 쓸 매핑을 결정. (근거: Populate External Credential Principals.)
- Named Principal = 조직당 자격증명 1개(모든 사용자 공유). Per-User Principal = 사용자별 개별 토큰(`User External Credentials` 오브젝트 접근 필요). 상세 비교는 [[Named Credential]].

---

## 6. Custom Headers 섹션 필드

Named Credential **또는** External Credential 양쪽에 Custom Headers 섹션이 있다(NC=엔드포인트 고정 헤더, EC=인증 관련 헤더).

| UI 필드 | 유형 | 값/옵션 | 의미 | Metadata |
|---|---|---|---|---|
| **Name** | 텍스트 | HTTP 헤더 이름(예: `X-API-Key`) | 붙일 헤더 키 | `parameterName`, `parameterType=HttpHeader`(NC) / `AuthHeader`(EC) |
| **Value** | 텍스트 | 리터럴 또는 merge field | 헤더 값. `{!$Credential.<ExtCred>.<Param>}`로 Principal 파라미터 주입 가능 | `parameterValue` |
| (**Sequence**) | 내부 | 정수 | 여러 HttpHeader의 순서 | `sequenceNumber` |

```apex
// 구조 예시 — 실제 동작 설정 아님 (Custom Header에 API Key 주입)
// External Credential Protocol = No Authentication
// Custom Header:  Name = X-API-Key   Value = {!$Credential.MyExtCred.ApiKey}
// Principal Authentication Parameter:  ApiKey = <실제 키, 암호화 저장>
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:MyNC/api/v1/resource');  // 헤더는 NC/EC 설정이 자동 부착
req.setMethod('GET');
HttpResponse res = new Http().send(req);
```

---

## 7. 생성 후 필수 후속 — External Credential Principal Access (Permission Set)

신모델은 필드를 다 채워도 **Principal 접근 권한이 없으면 런타임 인증 오류**로 막힌다. 아래는 UI상 "필드"라기보다 필수 매핑 단계다.

| 단계 | 화면 위치 | 설정 값 |
|---|---|---|
| Permission Set 생성 | Setup → Permission Sets → New | 임의 이름 |
| **External Credential Principal Access** | Permission Set → Apps 섹션 | 대상 Principal을 **Available → Enabled**로 이동 |
| 사용자 할당 | Permission Set → Manage Assignments | callout 실행 사용자 |

> ⚠️ **Profile이 아니라 Permission Set에 매핑**해야 `externalCredentialPrincipalAccesses` 메타데이터로 배포된다. Profile 매핑은 Metadata API에 안 나와 sandbox↔prod 이전 시 누락. (상세·근거는 [[Named Credential]]의 "신형 모델 필수 셋업" 절.)

---

## 요약 — 프로토콜별 "무슨 칸을 채우나" 한눈에

| Protocol | External Credential 레벨 | Principal Authentication Parameters |
|---|---|---|
| No Authentication | (없음) | (없음) — 필요 시 Custom Header에 API Key |
| Basic / Password | (없음) | Username, Password |
| OAuth 2.0 | Auth Flow Type, (Auth Provider/URL), Scope, PKCE | Client ID, Client Secret / Signing Certificate |
| AWS Sig v4 | variant 선택 | Access Key, Secret, Region, Service / Role ARN cert |
| JWT | Issuer, Subject, Audience, Signing Cert, Validity | (per-user subject 수식) / custom claims |
| JWT Token Exchange (legacy) | 위 + Token Endpoint URL | 위와 동일 |
| Custom | Custom Headers | 임의 name/value |

---

## 관련 노트

- [[Named Credential]] — 개념·Apex `callout:` 사용법·merge field·mTLS·OAuth 설정 절차 (이 노트는 필드 카탈로그, 개념은 여기로 위임)
- [[Auth Provider (인증 공급자)]] — OAuth 2.0 Browser Flow의 Identity Provider로 참조되는 인증 공급자
- [[Connected App (연결된 앱) — OAuth 클라이언트]] — Client ID/Secret을 발급하는 OAuth 클라이언트 정의
