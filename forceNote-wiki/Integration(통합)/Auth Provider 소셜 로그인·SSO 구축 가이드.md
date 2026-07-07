---
tags: [salesforce, integration, security, identity, auth-provider, sso, social-sign-on, how-to, apex]
source: help.salesforce.com — Configure a Google Authentication Provider (sso_provider_google), Social Sign-On, Create a Registration Handler (Tier 2, https://help.salesforce.com/s/articleView?id=xcloud.sso_provider_google.htm); developer.salesforce.com Apex Reference — Auth.RegistrationHandler (Tier 2, https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_auth_plugin.htm)
created: 2026-07-07
aliases: [소셜 로그인 구축, Social Sign-On setup, Auth Provider 설정 절차, Experience Cloud SSO 구축, Google 로그인 Salesforce, JIT 사용자 프로비저닝, Registration Handler 작성]
---

# Auth Provider 소셜 로그인·SSO 구축 가이드

> 외부 IdP(예: Google)로 Salesforce/Experience Cloud에 로그인하고 사용자를 JIT(Just-In-Time) 자동 프로비저닝하는 **처음부터 끝까지의 절차**. 개념·필드·URL 종류는 [[Auth Provider (인증 공급자)]]에 위임하고, 여기서는 "무엇을 어떤 순서로 클릭·작성하는가"만 다룬다.

---

## 언제 이 절차를 쓰나

- 외부 사용자가 **기존 Google/Microsoft/OIDC 계정**으로 Salesforce 또는 Experience Cloud 사이트에 로그인하게 하고 싶을 때(소셜 로그인 / inbound SSO).
- 그 사용자가 아직 Salesforce User가 아니면 **첫 로그인 순간 자동으로 User를 생성**(JIT 프로비저닝)하고, 재로그인 시 프로필 속성을 최신으로 갱신하고 싶을 때.

> 반대 방향(Salesforce가 외부 API를 호출할 때 토큰만 받는 용도)이면 Registration Handler가 필요 없다 — [[Named Credential]] + Auth Provider 조합을 참조. 여기서는 **로그인(inbound)** 시나리오만 다룬다.

**전제조건:** org에 **My Domain**이 배포·활성화돼 있어야 한다(소셜 로그인 버튼은 My Domain 로그인 페이지 또는 Experience Cloud 로그인 페이지에서만 노출된다).

---

## 단계별 구축

### (a) 외부 IdP 측 앱 등록 — Client ID / Secret 발급

Google을 예로 든다(다른 IdP도 원리 동일).

```
// 구조 예시 — Google Cloud Console 화면 순서 요약(동작 코드 아님)
1. Google Cloud Console → 프로젝트 생성/선택
2. APIs & Services → OAuth consent screen 구성(앱 이름·지원 이메일·범위)
3. APIs & Services → Credentials → Create Credentials → OAuth client ID
   · Application type = Web application
   · Authorized redirect URIs = (이 시점엔 아직 모름 → (c)에서 되돌아와 채운다)
4. 생성 후 표시되는 Client ID / Client Secret 을 복사해 둔다
   → Salesforce의 Consumer Key / Consumer Secret 로 쓴다
```

이 단계에서 Callback URL(리다이렉트 URI)은 아직 없다. 임시 저장하거나 (c)에서 되돌아와 등록한다.

### (b) Salesforce Auth Provider 생성

Setup → 빠른 찾기 **Auth. Providers** → **New**.

```
// 구조 예시 — New Auth. Provider 입력값(동작 코드 아님)
Provider Type            = Google      (프리셋; OIDC IdP면 OpenID Connect)
Name                     = Google Login
URL Suffix               = GoogleLogin  (Callback URL 경로에 삽입되는 고유 식별자)
Consumer Key             = <Google Client ID>
Consumer Secret          = <Google Client Secret>
Default Scopes           = openid email profile   (Google 기본; IdP별로 다름)
Registration Handler     = (아래 (d)에서 만든 Apex 클래스 지정)
Execute Registration As  = (아래 (d) 참조 — Manage Users 권한 사용자)
```

> Registration Handler를 아직 안 만들었으면, 화면의 **"Automatically create a registration handler template"** 체크로 뼈대 클래스를 자동 생성한 뒤 (d)에서 채워도 된다. 이 경우 Execute Registration As도 함께 지정한다.

저장한다.

### (c) 생성된 Callback URL을 IdP에 등록

저장 후 상세 페이지의 **Salesforce Configuration** 섹션에 여러 URL이 생성된다(종류는 [[Auth Provider (인증 공급자)]]의 "생성되는 URL" 표 참조). 이 중 **Callback URL**을 복사한다.

- 형태 예: `https://<MyDomain>.my.salesforce.com/services/authcallback/GoogleLogin`
- **화면에 표시된 값을 그대로 복사**한다(손으로 조립 금지 — 릴리스에 따라 org id 세그먼트가 붙기도 함).

복사한 값을 (a)의 Google OAuth client → **Authorized redirect URIs**에 붙여넣고 저장한다. Salesforce의 Callback URL과 IdP의 Redirect URI가 **문자 단위로 정확히 일치**해야 한다.

### (d) Registration Handler Apex 작성·배선

IdP가 인증한 외부 사용자를 Salesforce User로 만드는(createUser) / 재로그인 시 갱신하는(updateUser) 로직. `Auth.RegistrationHandler`를 구현한다. 시그니처는 공식 Apex Reference와 일치한다:

- `User createUser(Id portalId, Auth.UserData data)` — User 반환(플랫폼이 자동 insert)
- `void updateUser(Id userId, Id portalId, Auth.UserData data)` — 반환 없음

```apex
// JIT 프로비저닝 Registration Handler — 최소권한 프로필로 User 생성
global class GoogleRegistrationHandler implements Auth.RegistrationHandler {

    // 최초 로그인: 대응 User가 없으면 새로 만들어 반환
    global User createUser(Id portalId, Auth.UserData data) {
        // (권장) 신뢰 도메인만 프로비저닝 — 아니면 null 반환 시 로그인 거부
        if (data == null || String.isBlank(data.email)
                || !data.email.endsWithIgnoreCase('@example.com')) {
            return null;
        }

        // 최소권한 프로필 선택 (라이선스에 맞는 프로필로 교체)
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User u = new User();
        u.Username        = data.email;                 // org 전역 유일해야 함
        u.Email           = data.email;
        u.LastName        = data.lastName;
        u.FirstName       = data.firstName;
        u.Alias           = (data.firstName == null ? 'x' : data.firstName.left(1))
                            + data.lastName.left(4);
        u.ProfileId       = p.Id;
        u.EmailEncodingKey     = 'UTF-8';
        u.LanguageLocaleKey    = 'en_US';
        u.LocaleSidKey         = 'en_US';
        u.TimeZoneSidKey       = 'America/Los_Angeles';
        // FederationIdentifier로 외부 고유 ID를 묶어 두면 재로그인 매핑이 안정적
        u.FederationIdentifier = data.identifier;
        return u;                                        // insert는 플랫폼이 수행
    }

    // 재로그인: 기존 User를 IdP 최신 속성으로 갱신 (Existing User Linking)
    global void updateUser(Id userId, Id portalId, Auth.UserData data) {
        User u = new User(Id = userId);
        u.Email     = data.email;
        u.LastName  = data.lastName;
        u.FirstName = data.firstName;
        update u;
    }
}
```

> `Auth.UserData`는 IdP가 넘긴 `email·firstName·lastName·username·identifier(외부 고유 ID)·attributeMap` 등을 담는다. **개인정보(GDPR)** 라 어디에도 저장하지 말고 핸들러 내에서 실시간으로만 쓴다.

배선: Auth Provider 상세 → Edit → **Registration Handler**에 이 클래스를 지정.

**Execute Registration As** — 핸들러가 실행되는 사용자 컨텍스트를 지정한다. 이 사용자는 **Manage Users** 권한이 있어야 하며(User를 insert/update 하므로), 보통 감사 추적용 **전용 통합 사용자(integration user)**를 만들어 지정한다(개인 관리자 계정 대신).

### (e) 테스트 URL로 검증

실제 로그인 전에 **Test-Only Initialization URL**로 설정을 검증한다. 이 URL을 브라우저로 열면 실제 사용자 생성 없이 IdP가 반환한 raw 속성(access token·user attributes)을 화면에 그대로 표시한다 → 매핑이 맞는지 확인한다.

- 정상: IdP 로그인 → 되돌아와 사용자 속성 JSON 표시.
- 실패: (트러블슈팅) 참조.

검증되면 **Single Sign-On Initialization URL**이 실제 로그인 진입점이 된다.

### (f) Experience Cloud / My Domain 로그인 페이지에 소셜 로그인 버튼 연결

**My Domain 로그인(내부 사용자):**
Setup → **My Domain** → Authentication Configuration → Edit → **Authentication Service**에서 방금 만든 Auth Provider(예: Google Login)를 체크 → Save. 로그인 화면에 해당 버튼이 나타난다.

**Experience Cloud 사이트(외부 사용자):**
Setup → **All Sites** → 대상 사이트 **Workspaces** → **Administration → Login & Registration** (또는 Experience Builder → Settings → Login) → **Login** 섹션에서 Auth Provider를 추가 → Save. 사이트 로그인 페이지에 소셜 로그인 버튼이 노출된다.

---

## 트러블슈팅

| 증상 | 원인 | 조치 |
|---|---|---|
| `redirect_uri_mismatch` (IdP 오류 화면) | IdP의 Authorized redirect URI ≠ Salesforce Callback URL | (c) 재확인 — Callback URL을 화면에서 그대로 복사했는지, 후행 슬래시·http/https·My Domain 여부까지 일치시킨다 |
| 로그인 후 "Registration Handler 오류"/로그인 실패 | createUser 미스매핑·필수 필드 누락·프로필 없음·중복 Username | Test-Only URL로 반환 속성 확인 → createUser의 필수 필드(Username·Alias·ProfileId·*Key 4종) 전부 세팅 확인 |
| 로그인은 되는데 User가 안 생김 | createUser가 `null` 반환(도메인 필터에 걸림) 또는 라이선스 소진 | 필터 조건·라이선스 수량 확인. 의도된 거부면 정상 |
| "insufficient access"/User insert 실패 | Execute Registration As 사용자에 **Manage Users** 권한 없음 | 해당 사용자 권한 부여 또는 권한 있는 사용자로 교체 |
| 재로그인마다 새 User가 또 생김(중복) | 기존 User 매핑 실패 → updateUser 대신 createUser 재실행 | createUser에서 `FederationIdentifier = data.identifier` 저장 → 플랫폼이 다음 로그인에 매핑해 updateUser 경로 사용 |
| 로그인 화면에 버튼이 안 보임 | My Domain 미배포 / (f) 미설정 | My Domain 활성화 확인, Authentication Configuration에 Auth Provider 체크 확인 |

---

## 보안 — JIT 사용자 최소권한·프로필 매핑

- **최소권한 프로필로 프로비저닝.** createUser에서 부여하는 Profile은 그 사용자가 실제로 필요한 최소 권한만 담은 것으로 한다(관리자·강한 프로필 자동부여 금지). 외부 로그인이면 Experience Cloud용 외부 사용자 프로필/권한 집합을 쓴다.
- **프로비저닝 대상 제한.** createUser에서 신뢰 이메일 도메인·IdP 속성으로 화이트리스트를 걸고, 조건 미달이면 `null` 반환해 계정 남발을 막는다.
- **전용 Execute Registration As 사용자.** 개인 관리자 계정 대신 감사 가능한 전용 통합 사용자를 지정한다(Manage Users 권한만).
- **UserData 비저장.** `Auth.UserData`(개인정보)를 커스텀 오브젝트·로그 등에 남기지 않는다(GDPR). 매핑에 필요한 최소 필드(예: identifier)만 표준 User 필드로 저장한다.
- **속성 매핑 검증.** attributeMap의 값을 그대로 신뢰해 권한 필드(ProfileId·PermissionSet 배정)를 정하지 말고, 서버 측 화이트리스트로 결정한다.

---

## 관련 노트

- [[Auth Provider (인증 공급자)]] — 개념·Provider 유형·필드·생성 URL 종류·Custom 플러그인(정본)
- [[Connected App (연결된 앱) — OAuth 클라이언트]] — 방향이 반대인 OAuth 서버 측(외부 앱 → Salesforce)
- [[통합 MOC]] — Integration 섹션 전체 목차
