---
tags: [apex, auth, namespace, jwt, jws, oauth, session-management, mfa, registration-handler, auth-provider, saml, token-exchange, login-discovery]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [Auth Namespace, Auth.JWT, Auth.JWS, Auth.JWTBearerTokenExchange, Auth.SessionManagement, JWT bearer token, OAuth JWT flow, MFA TOTP, 세션 관리, Auth.AuthProviderPluginClass, Auth.RegistrationHandler, Auth.SamlJitHandler, Auth.LoginDiscoveryHandler, Auth.ConnectedAppPlugin, Auth.Oauth2TokenExchangeHandler]
---

# Auth Namespace

> Salesforce SSO, 커스텀 인증 공급자, OAuth/JWT, 세션 보안, 로그인 디스커버리, SAML JIT 프로비저닝, 토큰 교환 등을 처리하는 Apex API.

---

## 전체 클래스 목록

| 클래스 / 인터페이스 / Enum | 역할 |
|---|---|
| `Auth.AuthConfiguration` | Experience Cloud 사이트·My Domain 인증 설정 조회 |
| `Auth.AuthProviderCallbackState` | 커스텀 인증 공급자 콜백 요청 정보 (헤더·본문·쿼리) |
| `Auth.AuthProviderPlugin` | ⚠️ deprecated — `AuthProviderPluginClass` 사용 권장 |
| `Auth.AuthProviderPluginClass` | OAuth 기반 커스텀 인증 공급자 플러그인 추상 클래스 |
| `Auth.AuthProviderTokenResponse` | 커스텀 인증 공급자 콜백 응답 (토큰 저장) |
| `Auth.AuthToken` | SSO 인증 공급자 액세스/리프레시 토큰 조회·갱신·폐기 |
| `Auth.CommunitiesUtil` | Experience Cloud 사용자 정보 조회 |
| `Auth.ConfigurableSelfRegHandler` | Experience Cloud 자기등록 핸들러 인터페이스 |
| `Auth.ConfirmUserRegistrationHandler` | SSO 사용자 매핑 확인 핸들러 인터페이스 |
| `Auth.ConnectedAppPlugin` | Connected App 동작 확장 추상 클래스 |
| `Auth.CustomOneTimePasswordDeliveryHandler` | 커스텀 SMS 공급자로 OTP 전송 인터페이스 |
| `Auth.CustomOneTimePasswordDeliveryResult` | OTP 전송 결과 Enum |
| `Auth.ExternalClientAppOauthHandler` | External Client App 동작 확장 추상 클래스 |
| `Auth.GeneratedUserData` | "Generate User Data" Invocable Action 출력 데이터 |
| `Auth.HeadlessSelfRegistrationHandler` | Headless Registration Flow 사용자 생성 인터페이스 |
| `Auth.HeadlessUserDiscoveryHandler` | Headless 로그인/비밀번호 없는 로그인 사용자 탐색 인터페이스 |
| `Auth.HeadlessUserDiscoveryResponse` | Headless 사용자 탐색 결과 |
| `Auth.HttpCalloutMockUtil` | Auth 네임스페이스 클래스용 HTTP 모킹 유틸리티 |
| `Auth.IntegratingAppType` | Connected App / External Client App 구분 Enum |
| `Auth.InvocationContext` | Connected App 호출 컨텍스트 Enum |
| `Auth.JsonValueOutput` | "Get User Data from JSON String" Invocable Action 출력 |
| `Auth.JWS` | JWT 서명 (JSON Web Signature) |
| `Auth.JWT` | JWT 클레임 셋 생성 |
| `Auth.JWTBearerTokenExchange` | JWT Bearer Token을 액세스 토큰으로 교환 |
| `Auth.JWTUtil` | 외부 IdP의 JWT 검증 유틸리티 |
| `Auth.LightningLoginEligibility` | Lightning Login 적격성 Enum |
| `Auth.LoginDiscoveryHandler` | 이메일·전화번호 기반 로그인 디스커버리 인터페이스 |
| `Auth.LoginDiscoveryMethod` | 로그인 디스커버리 확인 방법 Enum |
| `Auth.MyDomainLoginDiscoveryHandler` | My Domain 인터뷰 기반 로그인 디스커버리 인터페이스 |
| `Auth.Oauth2TokenExchangeHandler` | OAuth 2.0 토큰 교환 핸들러 추상 클래스 |
| `Auth.OAuth2TokenExchangeType` | 교환되는 토큰 타입 Enum |
| `Auth.OAuthRefreshResult` | AuthProviderPluginClass.refresh() 결과 |
| `Auth.OauthToken` | OAuth 액세스·리프레시 토큰 폐기 |
| `Auth.OauthTokenType` | 폐기할 토큰 타입 Enum |
| `Auth.RegistrationHandler` | SSO 인증 후 사용자 프로비저닝 인터페이스 |
| `Auth.SamlJitHandler` | SAML JIT 사용자 프로비저닝 인터페이스 |
| `Auth.SessionManagement` | 세션 보안 레벨, MFA, 로그인 플로우 |
| `Auth.SessionLevel` | 세션 보안 레벨 Enum |
| `Auth.TokenValidationResult` | 토큰 교환 핸들러의 토큰 검증 결과 |
| `Auth.UserData` | SSO 인증 공급자가 반환하는 사용자 정보 |
| `Auth.VerificationAction` | Headless 비밀번호 없는 로그인 OTP 전송 방법 Enum |
| `Auth.VerificationMethod` | 사용자 인증 방법 Enum |
| `Auth.VerificationPolicy` | 신원 확인 정책 Enum |
| `Auth.VerificationResult` | 인증 챌린지 결과 |

---

## 섹션 1 — OAuth 2.0 JWT Bearer Token Flow

### 전체 흐름

```
Auth.JWT  →  (클레임 셋 생성)
    ↓
Auth.JWS  →  (인증서로 서명 → compact serialization)
    ↓
Auth.JWTBearerTokenExchange  →  (토큰 엔드포인트에 POST → access token)
```

### Auth.JWT — JWT 클레임 셋

```apex
Auth.JWT jwt = new Auth.JWT();
jwt.setIss('3MVG99OxTyEMCQ3...ConnectedAppConsumerKey');
jwt.setSub('user@example.com');
jwt.setAud('https://login.salesforce.com');
jwt.setValidityLength(180);  // 초 단위, 기본 3분

Map<String, Object> claims = new Map<String, Object>();
claims.put('scope', 'api refresh_token');
jwt.setAdditionalClaims(claims);
```

| 메서드 | 설명 |
|---|---|
| `setIss(iss)` | issuer (Connected App Consumer Key) |
| `setSub(sub)` | subject (사용자 이름) |
| `setAud(aud)` | audience (토큰 엔드포인트 URL) |
| `setNbfClockSkew(seconds)` | not-before 클럭 스큐 허용 시간 |
| `setValidityLength(seconds)` | 유효 기간 (기본 3분) |
| `setAdditionalClaims(map)` | scope 등 추가 클레임 |
| `getIss()` / `getAud()` / `getSub()` | 클레임 조회 |
| `getAdditionalClaims()` | 추가 클레임 맵 |
| `getNbfClockSkew()` / `getValidityLength()` | 시간 설정 조회 |
| `toJSONString()` | JWT JSON 직렬화 |
| `clone()` | 복사본 생성 |

---

### Auth.JWS — JWT 서명

```apex
// 방법 A — Auth.JWT 객체로 생성
Auth.JWS jwsA = new Auth.JWS(jwt, 'CertDevName');

// 방법 B — Base64 payload 문자열로 직접 생성
Auth.JWS jwsB = new Auth.JWS(base64EncodedPayload, 'CertDevName');

// compact serialization: header.payload.signature (Base64URL)
String serialized = jwsA.getCompactSerialization();
```

- `certDevName`: Setup → Certificate and Key Management의 **Unique Name**
- 반환값: `header.payload.signature` 형식의 Base64URL 문자열

| 메서드 | 설명 |
|---|---|
| `getCompactSerialization()` | `header.payload.signature` 형태의 서명된 JWT |
| `clone()` | 복사본 생성 |

---

### Auth.JWTBearerTokenExchange — 토큰 교환

```apex
String tokenEndpoint = 'https://login.salesforce.com/services/oauth2/token';
Auth.JWTBearerTokenExchange bearer = new Auth.JWTBearerTokenExchange(tokenEndpoint, jws);

String accessToken = bearer.getAccessToken();
// 또는 전체 응답:
System.HttpResponse fullResponse = bearer.getHttpResponse();
```

| 메서드 | 설명 |
|---|---|
| `new JWTBearerTokenExchange(endpoint, jws)` | 생성자 (빈 생성자도 존재) |
| `getAccessToken()` | `access_token` 값 추출 |
| `getHttpResponse()` | 전체 System.HttpResponse |
| `getJWS()` | 사용된 JWS 반환 |
| `getTokenEndpoint()` | 엔드포인트 반환 |
| `getGrantType()` | grant_type 반환 |
| `setGrantType(type)` | grant_type 재정의 (기본: `urn:ietf:params:oauth:grant-type:jwt-bearer`) |
| `setJWS(jws)` | JWS 재설정 |
| `setTokenEndpoint(endpoint)` | 엔드포인트 설정 |
| `clone()` | 복사본 생성 |

---

### Auth.JWTUtil — JWT 검증 유틸리티

OAuth 2.0 토큰 교환 흐름에서 외부 IdP가 보낸 JWT를 검증할 때 사용.

| 메서드 | 설명 |
|---|---|
| `parseJWTFromStringWithoutValidation(jwt)` | 서명 검증 없이 JWT 파싱 (디버깅용) |
| `validateJWTWithCert(jwt, certDeveloperName)` | 인증서로 JWT 서명 검증 |
| `validateJWTWithKey(jwt, publicKey)` | 공개키로 JWT 서명 검증 |
| `validateJWTWithKeysEndpoint(jwt, endpoint)` | JWKS 엔드포인트로 JWT 서명 검증 |

```apex
// 토큰 교환 핸들러 내에서 JWT 검증
Auth.JWT parsedJwt = Auth.JWTUtil.validateJWTWithCert(incomingToken, 'MyCertDevName');
String subject = parsedJwt.getSub();
```

---

## 섹션 2 — 세션 보안 및 MFA (Auth.SessionManagement)

```apex
// 현재 세션 속성 조회
Map<String, String> sessionInfo = Auth.SessionManagement.getCurrentSession();
// 키: 'SessionId', 'SessionType', 'UserType', 'LoginType' 등

// 세션 보안 레벨 상승
Auth.SessionManagement.setSessionLevel(Auth.SessionLevel.HIGH_ASSURANCE);

// TOTP 검증
Boolean valid = Auth.SessionManagement.validateTotpTokenForUser(totpCode, 'MFA 앱');
Boolean validKey = Auth.SessionManagement.validateTotpTokenForKey(sharedKey, totpCode, 'MFA Setup');

// QR 코드 및 shared secret 생성
Map<String, String> qrData = Auth.SessionManagement.getQrCode();
String qrUrl  = qrData.get('qrcode');
String secret = qrData.get('secret');

// IP 범위 검증
Boolean inRange = Auth.SessionManagement.inOrgNetworkRange('203.0.113.10');
Boolean allowed = Auth.SessionManagement.isIpAllowedForProfile(profileId, '203.0.113.10');

// 로그인 플로우 완료
PageReference pr = Auth.SessionManagement.finishLoginFlow();
PageReference pr2 = Auth.SessionManagement.finishLoginFlow('/apex/myPage');

// 재인증 URL 생성
String verifyUrl = Auth.SessionManagement.generateVerificationUrl(
    Auth.VerificationPolicy.MEDIUM_ASSURANCE,
    'Accessing Sensitive Data',
    '/apex/SensitiveDetails'
);

// 로그인 디스커버리 완료
PageReference loginPr = Auth.SessionManagement.finishLoginDiscovery(
    Auth.LoginDiscoveryMethod.MAIL, startUrl, null
);
```

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getCurrentSession()` | `Map<String,String>` | 현재 세션 속성 |
| `setSessionLevel(level)` | `void` | HIGH_ASSURANCE / STANDARD |
| `validateTotpTokenForUser(code, desc)` | `Boolean` | 현재 사용자 TOTP 검증 |
| `validateTotpTokenForUser(code)` | `Boolean` | desc 없이 TOTP 검증 |
| `validateTotpTokenForKey(key, code, desc)` | `Boolean` | 공유 키로 TOTP 검증 |
| `validateTotpTokenForKey(key, code)` | `Boolean` | desc 없이 공유 키 검증 |
| `getQrCode()` | `Map<String,String>` | TOTP QR URL + shared secret |
| `inOrgNetworkRange(ip)` | `Boolean` | 조직 신뢰 IP 범위 내 여부 |
| `isIpAllowedForProfile(profileId, ip)` | `Boolean` | 프로필 신뢰 IP 허용 여부 |
| `finishLoginFlow()` | `PageReference` | 로그인 플로우 완료 → 홈 |
| `finishLoginFlow(startUrl)` | `PageReference` | 로그인 플로우 완료 → URL |
| `finishLoginDiscovery(method, startUrl, attribs)` | `PageReference` | 로그인 디스커버리 완료 |
| `generateVerificationUrl(policy, desc, destUrl)` | `String` | 신원 확인 URL 생성 |
| `getLightningLoginEligibility(userId)` | `Auth.LightningLoginEligibility` | Lightning Login 적격성 |
| `getRequiredSessionLevelForProfile(profileId)` | `Auth.SessionLevel` | 프로필 요구 세션 레벨 |
| `ignoreForConcurrentSessionLimit(sessions)` | `Map<String,String>` | 동시 세션 한도 예외 처리 |
| `verifyDeviceFlow(userCode, startUrl)` | `PageReference` | 디바이스 플로우 검증 |

### Auth.SessionLevel Enum

| 값 | 설명 |
|---|---|
| `HIGH_ASSURANCE` | 높은 보증 수준 (MFA 완료 후) |
| `STANDARD` | 표준 보증 수준 |

---

## 섹션 3 — SSO RegistrationHandler

```apex
global class MyRegHandler implements Auth.RegistrationHandler {
    global User createUser(Id portalId, Auth.UserData data) {
        User u = new User();
        u.Username = data.username ?? data.email;
        u.Email    = data.email;
        u.LastName = data.lastName ?? 'Unknown';
        u.FirstName = data.firstName;
        u.Alias    = data.email.left(8);
        u.ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id;
        return u;
    }
    global void updateUser(Id userId, Id portalId, Auth.UserData data) {
        User u = new User(Id = userId, Email = data.email);
        update u;
    }
}
```

| 메서드 | 설명 |
|---|---|
| `createUser(portalId, userData) → User` | 신규 사용자 생성 (기존 사용자 반환 가능) |
| `updateUser(userId, portalId, userData) → void` | 기존 사용자 속성 갱신 |

### Auth.UserData — SSO 사용자 정보

```apex
// Auth.UserData 프로퍼티
data.identifier         // 인증 공급자가 반환하는 고유 ID
data.firstName          // 이름
data.lastName           // 성
data.fullName           // 전체 이름
data.email              // 이메일
data.link               // 프로필 링크
data.username           // Salesforce 사용자명 (선택)
data.locale             // 로케일 코드
data.provider           // 인증 공급자 이름
data.siteLoginUrl       // Experience Cloud 사이트 로그인 URL
data.attributeMap       // 추가 속성 Map<String, String>
data.idToken            // ID 토큰 문자열 (선택)
data.userInfoJSONString // userinfo JSON 문자열 (선택)
data.idTokenJSONString  // ID 토큰 JSON 문자열 (선택)
```

---

## 섹션 4 — 커스텀 인증 공급자 (AuthProviderPluginClass)

Salesforce가 기본 제공하지 않는 OAuth 기반 외부 인증 공급자를 구현할 때 사용.

```apex
global class MyConcurProvider extends Auth.AuthProviderPluginClass {

    // 커스텀 메타데이터 타입 이름 반환
    public String getCustomMetadataType() {
        return 'Concur_Auth_Provider__mdt';
    }

    // 1단계: 외부 IdP 로그인 페이지로 리디렉션
    public PageReference initiate(Map<String,String> config, String stateToPropagate) {
        String authUrl = config.get('Auth_Endpoint__c')
            + '?response_type=code'
            + '&client_id=' + config.get('Client_Id__c')
            + '&state=' + stateToPropagate;
        return new PageReference(authUrl);
    }

    // 2단계: 콜백 처리 → 토큰 교환
    public Auth.AuthProviderTokenResponse handleCallback(
            Map<String,String> config, Auth.AuthProviderCallbackState callbackState) {
        String code = callbackState.queryParameters.get('code');
        String state = callbackState.queryParameters.get('state');
        // HTTP callout으로 access/refresh token 교환...
        return new Auth.AuthProviderTokenResponse('Concur', accessToken, refreshToken, state);
    }

    // 3단계: 사용자 정보 조회
    public Auth.UserData getUserInfo(Map<String,String> config,
            Auth.AuthProviderTokenResponse response) {
        // access token으로 userinfo endpoint 호출...
        return new Auth.UserData(userId, firstName, lastName, fullName,
            email, profileLink, username, locale, 'Concur', null, null);
    }

    // 토큰 갱신 (선택 구현)
    public Auth.OAuthRefreshResult refresh(Map<String,String> config, String refreshToken) {
        // refresh token으로 새 access token 획득...
        return new Auth.OAuthRefreshResult(newAccessToken, newRefreshToken);
    }
}
```

| 메서드 | 설명 |
|---|---|
| `getCustomMetadataType()` | 커스텀 메타데이터 타입 API 이름 반환 (필수) |
| `initiate(config, state)` | 인증 공급자 로그인 URL로 리디렉션 (필수) |
| `handleCallback(config, callbackState)` | 콜백 처리 및 토큰 교환 (필수) |
| `getUserInfo(config, tokenResponse)` | 사용자 정보 조회 (필수) |
| `refresh(config, refreshToken)` | 액세스 토큰 갱신 (선택) |

### Auth.AuthProviderCallbackState

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `headers` | `Map<String,String>` | 요청 HTTP 헤더 |
| `body` | `String` | 요청 본문 |
| `queryParameters` | `Map<String,String>` | 쿼리 파라미터 (`code`, `state` 등) |

### Auth.AuthProviderTokenResponse

```apex
// 생성자 — provider, oauthToken, oauthSecretOrRefreshToken, state
new Auth.AuthProviderTokenResponse('ProviderName', accessToken, refreshToken, state);

// 4파라미터 생성자 (id_token 포함)
new Auth.AuthProviderTokenResponse('ProviderName', accessToken, refreshToken, state, idToken);
```

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `provider` | `String` | 인증 공급자 이름 |
| `oauthToken` | `String` | 액세스 토큰 |
| `oauthSecretOrRefreshToken` | `String` | 리프레시 토큰 (OAuth) 또는 시크릿 |
| `state` | `String` | CSRF 방지 상태 값 |
| `idToken` | `String` | OIDC ID 토큰 (선택) |

### Auth.OAuthRefreshResult

```apex
// 성공
return new Auth.OAuthRefreshResult(newAccessToken, newRefreshToken);
// 오류
return new Auth.OAuthRefreshResult(null, null, 'invalid_grant');
```

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `accessToken` | `String` | 새 액세스 토큰 |
| `refreshToken` | `String` | 새 리프레시 토큰 |
| `error` | `String` | 오류 코드 (실패 시) |

---

## 섹션 5 — 기존 토큰 관리

### Auth.AuthToken — SSO 인증 공급자 토큰 조회

```apex
// 특정 인증 공급자의 액세스 토큰
String accessToken = Auth.AuthToken.getAccessToken(authProviderId, 'Facebook');

// 모든 토큰 맵 (provider → token 매핑)
Map<String,String> tokenMap = Auth.AuthToken.getAccessTokenMap(authProviderId, 'Facebook');

// 액세스 토큰 갱신
Map<String,String> refreshed = Auth.AuthToken.refreshAccessToken(authProviderId, 'Facebook', null);

// 토큰 폐기
Boolean revoked = Auth.AuthToken.revokeAccess(authProviderId, 'Facebook', userId);
```

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getAccessToken(authProviderId, providerName)` | `String` | 현재 사용자의 액세스 토큰 |
| `getAccessTokenMap(authProviderId, providerName)` | `Map<String,String>` | 토큰 상세 맵 |
| `refreshAccessToken(authProviderId, providerName, userId)` | `Map<String,String>` | 토큰 갱신 |
| `revokeAccess(authProviderId, providerName, userId)` | `Boolean` | 토큰 폐기 |

### Auth.OauthToken — OAuth 토큰 폐기

```apex
// 액세스 토큰 폐기
Boolean revoked = Auth.OauthToken.revokeToken(Auth.OauthTokenType.ACCESS, myAccessToken);
```

| 메서드 | 설명 |
|---|---|
| `revokeToken(type, authToken)` | OAuth 토큰 폐기 |

### Auth.OauthTokenType Enum

| 값 | 설명 |
|---|---|
| `ACCESS` | 액세스 토큰 |
| `REFRESH` | 리프레시 토큰 |

---

## 섹션 6 — OAuth 2.0 토큰 교환 (Oauth2TokenExchangeHandler)

외부 IdP 토큰을 Salesforce 액세스 토큰으로 교환할 때 구현.

```apex
global class MyTokenExchangeHandler extends Auth.Oauth2TokenExchangeHandler {

    // 외부 IdP 토큰 검증
    global override Auth.TokenValidationResult validateIncomingToken(
            String appDeveloperName,
            String incomingToken,
            Auth.OAuth2TokenExchangeType tokenType,
            Auth.IntegratingAppType integratingAppType) {

        // JWT 검증
        try {
            Auth.JWT parsedJwt = Auth.JWTUtil.validateJWTWithCert(incomingToken, 'IdPCert');
            Auth.UserData userData = new Auth.UserData(
                parsedJwt.getSub(), null, null, null, parsedJwt.getSub(),
                null, parsedJwt.getSub(), null, null, null, null
            );
            return new Auth.TokenValidationResult(true, null, userData, incomingToken, tokenType);
        } catch (Exception e) {
            Auth.TokenValidationResult result = new Auth.TokenValidationResult(false);
            result.customErrorMsg = 'Token validation failed: ' + e.getMessage();
            return result;
        }
    }

    // 토큰 교환 후 Salesforce 사용자 매핑 (선택)
    global override User getUserForTokenSubject(Id networkId,
            Auth.TokenValidationResult result,
            Auth.IntegratingAppType integratingAppType) {
        return [SELECT Id FROM User WHERE Username = :result.userData.username LIMIT 1];
    }
}
```

### Auth.TokenValidationResult

```apex
// 생성자 1: 유효 여부만
new Auth.TokenValidationResult(Boolean valid)

// 생성자 2: 전체 결과
new Auth.TokenValidationResult(Boolean isValid, Object data, Auth.UserData userData,
    String token, Auth.OAuth2TokenExchangeType tokenType)
```

| 프로퍼티 / 메서드 | 타입 | 설명 |
|---|---|---|
| `isValid` | `Boolean` | 검증 성공 여부 |
| `data` | `Object` | 추가 데이터 |
| `userData` | `Auth.UserData` | 검증된 사용자 정보 |
| `token` | `String` | 원본 토큰 |
| `tokenType` | `Auth.OAuth2TokenExchangeType` | 토큰 타입 |
| `customErrorMsg` | `String` | 오류 메시지 |
| `isValid()` | `Boolean` | 성공 여부 메서드 |
| `getData()` | `Object` | 데이터 메서드 |
| `getUserData()` | `Auth.UserData` | 사용자 정보 메서드 |
| `getToken()` | `String` | 토큰 메서드 |
| `getTokenType()` | `Auth.OAuth2TokenExchangeType` | 토큰 타입 메서드 |
| `getCustomErrorMessage()` | `String` | 오류 메시지 메서드 |

### Auth.OAuth2TokenExchangeType Enum

| 값 | 설명 |
|---|---|
| `ACCESS` | 액세스 토큰 |
| `ID` | ID 토큰 |
| `REFRESH` | 리프레시 토큰 |
| `SAML1` | SAML 1.1 assertion |
| `SAML2` | SAML 2.0 assertion |

### Auth.IntegratingAppType Enum

| 값 | 설명 |
|---|---|
| `CONNECTED_APP` | 연결된 앱 (Connected App) |
| `EXTERNAL_CLIENT_APP` | 외부 클라이언트 앱 |

---

## 섹션 7 — Connected App 확장 (ConnectedAppPlugin)

```apex
global class MyConnectedAppPlugin extends Auth.ConnectedAppPlugin {

    // 사용자가 Connected App을 승인할 수 있는지 결정
    global override Boolean authorize(Id userId, Id connectedAppId,
            Boolean isAdminApproved, Auth.InvocationContext context) {
        // false 반환 시 접근 거부
        return true;
    }

    // 커스텀 속성 추가 (SAML assertion, ID 토큰에 포함)
    global override Map<String,String> customAttributes(Id userId, Id connectedAppId,
            Map<String,String> formulaDefinedAttributes, Auth.InvocationContext context) {
        formulaDefinedAttributes.put('department', 'Engineering');
        return formulaDefinedAttributes;
    }

    // 토큰 갱신 시 커스텀 처리
    global override void refresh(Id userId, Id connectedAppId, Auth.InvocationContext context) {
        // 갱신 시 추가 처리
    }

    // SAML 응답 XML 수정 (SAML SSO 커스터마이징)
    public override dom.XmlNode modifySAMLResponse(Map<String,String> authSession,
            Id connectedAppId, dom.XmlNode samlResponseNode) {
        return samlResponseNode; // 수정 없이 반환
    }
}
```

| 메서드 | 설명 |
|---|---|
| `authorize(userId, connectedAppId, isAdminApproved)` | 앱 승인 여부 결정 (2-param 버전도 있음) |
| `authorize(userId, connectedAppId, isAdminApproved, context)` | 4-param 버전 |
| `customAttributes(userId, connectedAppId, attrs)` | 커스텀 속성 반환 (3-param 버전) |
| `customAttributes(userId, connectedAppId, attrs, context)` | 4-param 버전 |
| `refresh(userId, connectedAppId)` | 토큰 갱신 처리 (2-param 버전) |
| `refresh(userId, connectedAppId, context)` | 3-param 버전 |
| `modifySAMLResponse(authSession, connectedAppId, node)` | SAML 응답 XML 수정 |

### Auth.InvocationContext Enum

| 값 | 설명 |
|---|---|
| `REFRESH_TOKEN_FLOW` | 리프레시 토큰 갱신 플로우 |
| `SAML_IDP_INITIATED` | SAML IdP 시작 플로우 |
| `SAML_SP_INITIATED` | SAML SP 시작 플로우 |
| `TOKEN_EXCHANGE` | 토큰 교환 플로우 |
| ... | 기타 플로우 |

---

## 섹션 8 — SAML JIT 프로비저닝 (SamlJitHandler)

```apex
global class MySamlJitHandler implements Auth.SamlJitHandler {

    // 신규 사용자 생성 (JIT)
    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
            String federationIdentifier, Map<String,String> attributes, String assertion) {
        User u = new User();
        u.Username = attributes.get('email');
        u.Email    = attributes.get('email');
        u.LastName = attributes.get('lastName') ?? 'Unknown';
        u.FirstName = attributes.get('firstName');
        u.FederationIdentifier = federationIdentifier;
        u.ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id;
        return u;
    }

    // 기존 사용자 갱신
    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
            String federationIdentifier, Map<String,String> attributes, String assertion) {
        User u = new User(Id = userId, Email = attributes.get('email'));
        update u;
    }
}
```

| 메서드 | 설명 |
|---|---|
| `createUser(samlSsoProviderId, communityId, portalId, federationId, attributes, assertion)` | JIT 신규 사용자 생성 |
| `updateUser(userId, samlSsoProviderId, communityId, portalId, federationId, attributes, assertion)` | JIT 사용자 속성 갱신 |

---

## 섹션 9 — 로그인 디스커버리

### Auth.LoginDiscoveryHandler

이메일·전화번호·Federation ID 등으로 사용자를 찾고 인증 방법을 결정.

```apex
global class MyLoginDiscoveryHandler implements Auth.LoginDiscoveryHandler {
    global PageReference login(String identifier, String startUrl,
            Map<String,String> requestAttributes) {
        List<User> users = [SELECT Id FROM User WHERE Email = :identifier LIMIT 1];
        if (!users.isEmpty()) {
            // 비밀번호 로그인으로 진행
            return Auth.SessionManagement.finishLoginDiscovery(
                Auth.LoginDiscoveryMethod.PASSWORD, startUrl, requestAttributes
            );
        }
        return null;
    }
}
```

| 메서드 | 설명 |
|---|---|
| `login(identifier, startUrl, requestAttributes)` | 사용자 식별자로 인증 방법 결정 |

### Auth.LoginDiscoveryMethod Enum

| 값 | 설명 |
|---|---|
| `MAIL` | 이메일 링크로 인증 |
| `PASSWORD` | 비밀번호 로그인 |
| `SAML` | SAML SSO |
| `SSO` | OAuth SSO |
| `TOTP` | TOTP 기기 인증 |

### Auth.MyDomainLoginDiscoveryHandler

My Domain 2단계 인터뷰 기반 로그인 디스커버리. `login(identifier, startUrl, attributes)` 구현.

---

## 섹션 10 — Experience Cloud 등록 핸들러

### Auth.ConfigurableSelfRegHandler — 자기등록 핸들러

```apex
global class MyRegHandler implements Auth.ConfigurableSelfRegHandler {
    global Id createUser(Id accountId, Id profileId,
            Map<Schema.SObjectField, String> registrationAttributes,
            String password) {
        // 등록 양식 데이터로 사용자 생성
        User u = new User(
            Email    = registrationAttributes.get(Schema.User.Email),
            Username = registrationAttributes.get(Schema.User.Email),
            LastName = registrationAttributes.get(Schema.User.LastName),
            ProfileId = profileId
        );
        Site.validatePassword(u, password, password);
        return Site.createPortalUser(u, accountId, password);
    }
}
```

| 메서드 | 설명 |
|---|---|
| `createUser(accountId, profileId, attributes, password)` | 자기등록 사용자 생성 → 사용자 ID 반환 |

### Auth.HeadlessSelfRegistrationHandler — Headless 등록

```apex
global class MyHeadlessReg implements Auth.HeadlessSelfRegistrationHandler {
    global User createUser(Id profileId, Auth.UserData data,
            String customUserDataMap, Boolean generatePassword) {
        User u = new User();
        u.Username  = data.email;
        u.Email     = data.email;
        u.LastName  = data.lastName ?? 'Unknown';
        u.FirstName = data.firstName;
        u.ProfileId = profileId;
        return u;
    }
}
```

| 메서드 | 설명 |
|---|---|
| `createUser(profileId, userData, customDataMap, generatePassword)` | Headless 등록 사용자 생성 |

### Auth.HeadlessUserDiscoveryHandler / HeadlessUserDiscoveryResponse

```apex
global class MyDiscoveryHandler implements Auth.HeadlessUserDiscoveryHandler {
    global Auth.HeadlessUserDiscoveryResponse discoverUserFromLoginHint(
            Id networkId, String loginHint, Map<String,String> requestAttributes) {
        List<User> users = [SELECT Id FROM User WHERE Email = :loginHint LIMIT 1];
        Set<Id> ids = new Set<Id>();
        for (User u : users) { ids.add(u.Id); }
        return new Auth.HeadlessUserDiscoveryResponse(ids, null);
    }
}

// HeadlessUserDiscoveryResponse 생성자
new Auth.HeadlessUserDiscoveryResponse(Set<Id> userIds, String customErrorMessage)
```

| HeadlessUserDiscoveryResponse 프로퍼티 | 설명 |
|---|---|
| `userIds` | 탐색된 사용자 ID 집합 |
| `customErrorMessage` | 오류 메시지 (선택) |

---

## 섹션 11 — 커스텀 OTP 전송

```apex
global class TelesignMessaging implements Auth.CustomOneTimePasswordDeliveryHandler {
    global Auth.CustomOneTimePasswordDeliveryResult sendOneTimePassword(
            Id userId, String oneTimePassword) {
        // 외부 SMS API로 OTP 전송
        Boolean sent = sendSms(userId, oneTimePassword);
        return sent
            ? Auth.CustomOneTimePasswordDeliveryResult.SUCCESS
            : Auth.CustomOneTimePasswordDeliveryResult.ERROR;
    }
}
```

### Auth.CustomOneTimePasswordDeliveryResult Enum

| 값 | 설명 |
|---|---|
| `SUCCESS` | OTP 전송 성공 |
| `ERROR` | OTP 전송 실패 |
| `INVALID_PHONE_NUMBER` | 유효하지 않은 전화번호 |

---

## 섹션 12 — Auth.AuthConfiguration

Experience Cloud 사이트 또는 My Domain의 인증 설정을 조회.

```apex
Auth.AuthConfiguration authConfig =
    new Auth.AuthConfiguration('MyDomainName.my.site.com', '/apex/HomePage');

List<AuthProvider> providers = authConfig.getAuthProviders();
String bgColor = authConfig.getBackgroundColor();
Boolean selfRegEnabled = authConfig.getSelfRegistrationEnabled();

// 정적 메서드 — SSO URL 생성
String ssoUrl = Auth.AuthConfiguration.getAuthProviderSsoUrl(
    communityUrl, startUrl, 'FacebookProvider'
);
String ssoDomainUrl = Auth.AuthConfiguration.getAuthProviderSsoDomainUrl(
    communityUrl, startUrl, 'FacebookProvider'
);
```

| 메서드 (인스턴스) | 반환 타입 |
|---|---|
| `getAllowInternalUserLoginEnabled()` | `Boolean` |
| `getAuthConfig()` | `AuthConfig` |
| `getAuthConfigProviders()` | `List<AuthConfigProviders>` |
| `getAuthProviders()` | `List<AuthProvider>` |
| `getBackgroundColor()` | `String` |
| `getCertificateLoginEnabled(domainUrl)` | `Boolean` |
| `getCertificateLoginUrl(domainUrl, startUrl)` | `String` |
| `getDefaultProfileForRegistration()` | `String` |
| `getFooterText()` | `String` |
| `getForgotPasswordUrl()` | `String` |
| `getHeadlessForgotPasswordEnabled()` | `Boolean` |
| `getHeadlessPasswordlessLoginEnabled()` | `Boolean` |
| `getHeadlessRegistrationEnabled()` | `Boolean` |
| `getLogoUrl()` | `String` |
| `getLoginRightFrameUrl()` (= getRightFrameUrl) | `String` |
| `getSamlProviders()` | `List<SamlSsoConfig>` |
| `getSelfRegistrationEnabled()` | `Boolean` |
| `getSelfRegistrationUrl()` | `String` |
| `getStartUrl()` | `String` |
| `getUsernamePasswordEnabled()` | `Boolean` |
| `isCommunityUsingSiteAsContainer()` | `Boolean` |

| 메서드 (정적) | 반환 타입 |
|---|---|
| `getAuthProviderSsoUrl(communityUrl, startUrl, devName)` | `String` |
| `getAuthProviderSsoDomainUrl(communityUrl, startUrl, devName)` | `String` |
| `getSamlSsoUrl(communityUrl, startUrl, samlId)` | `String` |

---

## 섹션 13 — ConfirmUserRegistrationHandler

SSO 사용자 매핑 확인 핸들러.

```apex
global class MyConfirmHandler implements Auth.ConfirmUserRegistrationHandler,
                                          Auth.RegistrationHandler {
    // ConfirmUserRegistrationHandler 메서드
    global Id confirmUser(Id userId, Id tpalId, Id portalId, Auth.UserData data) {
        // 기존 사용자와 SSO 계정 매핑 확인
        return userId; // 확인된 사용자 ID 반환
    }
    // RegistrationHandler 메서드
    global User createUser(Id portalId, Auth.UserData data) { return null; }
    global void updateUser(Id userId, Id portalId, Auth.UserData data) { }
}
```

| 메서드 | 설명 |
|---|---|
| `confirmUser(userId, tpalId, portalId, userData)` | 사용자-SSO 매핑 확인 → 사용자 ID 반환 |

---

## 섹션 14 — Auth.CommunitiesUtil

```apex
// Experience Cloud 사용자 로그아웃 URL 획득
String logoutUrl = Auth.CommunitiesUtil.getLogoutUrl();
String displayName = Auth.CommunitiesUtil.getUserDisplayName();
Boolean isGuest    = Auth.CommunitiesUtil.isGuestUser();
Boolean isInternal = Auth.CommunitiesUtil.isInternalUser();
```

| 메서드 | 설명 |
|---|---|
| `getLogoutUrl()` | 로그아웃 URL |
| `getUserDisplayName()` | 현재 사용자 표시명 |
| `isGuestUser()` | 게스트 사용자 여부 |
| `isInternalUser()` | 내부 사용자 여부 |

---

## 섹션 15 — Auth.HttpCalloutMockUtil (테스트)

```apex
@IsTest
static void testAuthCallback() {
    Auth.HttpCalloutMockUtil.setHttpMock(new MyCalloutMock());
    // Auth namespace 클래스가 호출하는 HTTP callout 모킹
}
```

| 메서드 | 설명 |
|---|---|
| `setHttpMock(mock)` | Auth 네임스페이스 HTTP callout 모킹 설정 |

---

## 섹션 16 — 검증 결과 및 관련 Enum

### Auth.VerificationResult

```apex
// System.UserManagement.verifyPasswordlessLogin() 또는
// System.UserManagement.verifySelfRegistration() 결과
VerificationResult(PageReference redirect, Boolean success, String message)
```

| 프로퍼티 | 타입 |
|---|---|
| `redirect` | `PageReference` |
| `success` | `Boolean` |
| `message` | `String` |

### Auth.VerificationPolicy Enum

| 값 | 설명 |
|---|---|
| `MEDIUM_ASSURANCE` | 보통 수준 — `generateVerificationUrl`에서 사용 |
| `HIGH_ASSURANCE` | 높은 수준 |

### Auth.VerificationAction Enum

Headless 비밀번호 없는 로그인에서 OTP 전송 방법.

| 값 | 설명 |
|---|---|
| `EMAIL_OTP_VERIFICATION` | 이메일로 OTP |
| `TOTP_VERIFICATION` | TOTP 앱 |
| ... | 기타 |

### Auth.VerificationMethod Enum

사용자 인증 방법 목록 (등록/해제용).

| 값 | 설명 |
|---|---|
| `EMAIL` | 이메일 |
| `MOBILE` | SMS |
| `TOTP` | TOTP 앱 |
| ... | 기타 |

---

## 섹션 17 — 기타 클래스 / Enum

### Auth.GeneratedUserData

Flow의 "Generate User Data" Invocable Action 출력을 담는 클래스.

```apex
new Auth.GeneratedUserData(firstName, lastName, email, username, ...)
```

### Auth.JsonValueOutput

Flow의 "Get User Data from JSON String" Invocable Action 출력.

```apex
new Auth.JsonValueOutput(stringValue, booleanValue, integerValue, ...)
```

| 프로퍼티 | 타입 |
|---|---|
| `stringValue` | `String` |
| `booleanValue` | `Boolean` |
| `integerValue` | `Integer` |
| `doubleValue` | `Double` |
| `jsonArrayValue` | `String` |
| `jsonStringValue` | `String` |

### Auth.LightningLoginEligibility Enum

`Auth.SessionManagement.getLightningLoginEligibility(userId)`가 반환하는 값.

| 값 | 설명 |
|---|---|
| `Eligible` | Lightning Login 사용 가능 |
| `Ineligible` | 사용 불가 |
| `NotEnabled` | 조직에서 미활성화 |

---

## Auth 예외 (Exceptions)

| 예외 클래스 | 설명 |
|---|---|
| `Auth.NoAccessException` | 액세스 거부 |
| 기타 | Auth 네임스페이스 고유 예외 |

---

## 관련 노트

- [[Named Credential]] — JWT 교환에 사용할 외부 자격증명 관리
- [[RestClient 패턴]] — Bearer token을 Authorization 헤더로 전달
- [[CanTheUser]] — Apex 내 권한 체크 (인증과 구분)
- [[HttpCalloutMock]] — Auth namespace HTTP callout 테스트
