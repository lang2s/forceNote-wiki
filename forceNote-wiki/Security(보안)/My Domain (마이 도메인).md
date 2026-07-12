---
tags: [Security, Identity, My-Domain, Login, SSO, Branding, Authentication, Redirection]
source: help.salesforce.com — My Domain (xcloud.domain_name_overview.htm / faq_domain_name_what.htm) · Set the My Domain Login Policy (domain_name_setting_login_policy.htm) · Configure My Domain Settings (domain_name_settings.htm) · Customize Your My Domain Login Page with Your Brand (domain_name_login_branding.htm) · Manage My Domain Redirections (domain_name_redirections_manage.htm) · Customize Your My Domain Login Page for Mobile Auth Methods (domain_name_login_mobile_auth_methods.htm) (Tier 2, 2026-07-11 접속) · developer.salesforce.com Metadata API Developer Guide — MyDomainSettings (meta_mydomainsettings.htm, Tier 2, 2026-07-11 접속)
created: 2026-07-11
aliases: [My Domain, 마이 도메인, MyDomain, 내 도메인, My Domain Login URL, Authentication Configuration, MyDomainSettings, 로그인 정책, Login Policy]
---

# My Domain (마이 도메인)

> org 고유의 서브도메인(`MyDomainName.my.salesforce.com`)으로 로그인·앱 URL을 브랜딩하고, 커스텀 로그인 페이지·로그인 정책·SSO·소셜 로그인을 구성하는 Salesforce ID 기반 기능.

---

## 개념 — My Domain이란

**My Domain 이름**은 Salesforce 로그인 URL과 애플리케이션 URL에서 org 고유의 **서브도메인**으로 쓰인다. 모든 org는 기본으로 My Domain을 갖는다. 프로덕션 로그인 URL의 표준 형식은 다음과 같다.

```
# 구조 예시 — 실제 org 값 아님
https://MyDomainName.my.salesforce.com     # 프로덕션 로그인/앱 URL
https://MyDomainName--sandboxName.sandbox.my.salesforce.com   # 샌드박스
```

### 왜 필요한가 (공식 이점, Tier 2)

| 이점 | 내용 |
|---|---|
| **브랜딩** | org URL에 회사 고유 서브도메인 노출 (`https://mycompany.my.salesforce.com`) |
| **커스텀 로그인 페이지** | 로고·배경·우측 프레임·푸터를 브랜딩 |
| **커스텀 로그인 정책** | 어떤 URL·인증 서비스로 로그인할 수 있는지 org가 통제 |
| **SSO(Single Sign-On) 전제** | SSO를 활성화하려면 My Domain이 필요 — 로그인 페이지에 SSO 옵션을 노출 |
| **소셜 로그인** | Auth. Provider를 통한 소셜 계정 로그인 허용 |
| **동시 다중 org** | 같은 브라우저에서 여러 Salesforce org에 동시에 로그인 |
| **코드로 로그인** | My Domain 로그인 URL로 코드 기반 로그인 등 추가 보안 |

> My Domain은 SSO·Auth Provider·Lightning 등 다수 기능의 **전제**다.

### Enhanced Domains와의 관계

My Domain이 **어떤 서브도메인 이름을 쓰느냐**를 정한다면, **Enhanced Domains**는 그 My Domain 이름을 **모든 URL 유형(Visualforce·Experience Cloud·Content 등)에 일관되게 포함**시키는 도메인 정책이다. 구체적 URL 형식(`.vf.force.com`, `.my.site.com` 등)과 서드파티 쿠키 대응은 [[Enhanced Domains]] 노트가 정본이므로 여기서는 다루지 않는다.

---

## 설정 절차 — 이름 등록·배포

My Domain 설정은 **Setup → 빠른 찾기 "My Domain" → My Domain**에서 관리한다.

```
# 구조 예시 — Setup UI 흐름 (릴리스·org에 따라 라벨이 다를 수 있음, Tier 2, 2026-07-11 접속)
1. Setup > My Domain
2. My Domain Details 섹션에서 원하는 서브도메인 이름 입력 → 사용 가능 여부 확인(Check Availability)
3. 등록(Register) — 프로비저닝 진행 (준비되면 이메일 통지)
4. 로그인해 새 My Domain URL 테스트
5. Deploy to Users — 배포하면 org 전체가 새 My Domain URL을 사용
```

- 배포 전까지는 새 My Domain을 관리자가 테스트만 하고, 배포(Deploy) 시점에 전 사용자에게 적용된다.
- 프로덕션 로그인 URL: `https://MyDomainName.my.salesforce.com`.

> ⚠️ Setup UI의 정확한 버튼/섹션 라벨은 릴리스·org에 따라 다를 수 있음 (Tier 2, 접속일 2026-07-11).

---

## 로그인 정책 (Login Policy)

**Setup → My Domain → Authentication Configuration → Edit**(또는 My Domain 정책 섹션)에서 로그인 정책을 설정한다. 정책은 Metadata API의 **`MyDomainSettings`** 타입 필드로도 관리된다(아래 값·기본값은 Metadata API Developer Guide 기준, Tier 2).

| 정책 | Metadata 필드 | 기본값 | 동작 |
|---|---|---|---|
| **My Domain URL로만 로그인 강제** (예: `login.salesforce.com`에서의 로그인 차단) | `canOnlyLoginWithMyDomainUrl` | `false` | `true`면 사용자는 org의 My Domain 로그인 URL로만 로그인할 수 있다 |
| **API 로그인에 My Domain(org 도메인) URL 요구** | `doesApiLoginRequireOrgDomain` | `false` | `true`면 API 접근 시에도 My Domain URL을 요구 |

- 로그인 정책을 My Domain 전용으로 강제하면, 일반 `https://login.salesforce.com`을 통한 로그인 경로를 막아 **피싱·자격증명 오용 표면을 축소**할 수 있다.
- 정책 변경 시 SSO·MFA 등 기존 인증 방법이 영향받을 수 있으므로, 로그인 접근을 사전에 보존(관리자 접근 유지)한 뒤 적용한다.

---

## 인증 서비스 (Authentication Service)

**Authentication Configuration** 섹션에서 **로그인 페이지에 어떤 인증 옵션을 표시할지**를 선택한다. 각 인증 서비스는 체크박스로 켜고 끈다.

| 인증 서비스 | 설명 |
|---|---|
| **Login Form** (표준 로그인 폼) | username/password 표준 로그인 폼. 체크 해제 시 로그인 페이지에서 표준 로그인 폼이 **숨겨진다**(SSO 전용 페이지 구성에 사용) |
| **Single Sign-On (SSO)** | 설정된 SAML SSO IdP 로그인 옵션을 표시 |
| **Authentication Providers** | 설정된 Auth. Provider(소셜/OpenID Connect 등)를 로그인 옵션으로 표시 → [[Auth Provider (인증 공급자)]] |
| **External Authentication / 기타** | org에 구성된 외부 인증 옵션을 노출 |

- 선택한 서비스가 로그인 페이지에 버튼/옵션으로 렌더링된다.
- **주의:** Login Form을 해제한 상태에서 SSO가 정상 동작하지 않으면 사용자가 로그인 불가 상태에 빠질 수 있으므로, SSO 검증 후 해제한다.

### 모바일 인증 (고급 브라우저 기반 인증)

My Domain Setup에서 **모바일 앱 인증을 네이티브 브라우저로 처리**하도록 구성할 수 있다(보안·성능 향상). Metadata 필드로는 `enableNativeBrowserForAuthOnIos`, `enableNativeBrowserForAuthOnAndroid`(기본 `false`). 이를 통해 보안 키 등 **phishing-resistant MFA**를 로그인 흐름에 연계할 수 있다.

---

## 로그인 페이지 브랜딩

**Authentication Configuration → Edit**에서 로그인 페이지를 브랜딩한다. 아래 값은 공식 문서 기준(Tier 2).

| 항목 | 값·제약 |
|---|---|
| **로고(Logo)** | Choose File로 업로드. `.jpg` / `.gif` / `.png`, **최대 100 KB**, 최대 크기 **250 px × 125 px** |
| **배경(Background)** | 16진수(hex) 색상 코드 |
| **우측 프레임 URL (Right Frame URL)** | 우측 프레임에 표시할 콘텐츠 URL. 비워 두면 Salesforce 기본 로그인 페이지의 프레임을 사용 |
| **푸터(Footer)** | 회사명(company name)과 폰트 색상 지정 |

- 이 브랜딩은 로그인 페이지뿐 아니라 **본인 확인(identity verification) 페이지·비밀번호 재설정 페이지·로그인 플로우(Login Flow)** 전반에 적용된다.

---

## 리디렉션 정책 (Redirection)

My Domain 이름을 바꾸거나 Enhanced Domains로 전환하면 **이전 URL로 들어오는 방문**을 어떻게 처리할지 정한다. 동작은 `MyDomainSettings` 필드로 관리된다(Tier 2, Metadata API Developer Guide).

| Metadata 필드 | 기본값 | 동작 |
|---|---|---|
| `redirectPriorMyDomain` | `true` | 이전 My Domain 이름 → 현재 My Domain으로 리디렉트 |
| `doesWarnOnRedirect` | `false` | 사용자가 이전 My Domain URL에 접근할 때 경고 메시지 표시 |
| `doesWarnOnForceComRedirect` | `false` | `.force.com` 사이트 리디렉션에 대한 경고 메시지 표시 |
| `instancedUrlRedirectHandling` | — (`OrgDomainRedirectOption`) | org의 인스턴스 URL 방문 처리 방식 |
| `enableLegacyRedirections` | — | 비-Enhanced(레거시) 호스트명 리디렉트 활성화 |
| `areLegacyRedirectsMaintained` / `areLgcyRdirMaintainedWntr26` | `false` | 릴리스 업그레이드 시 레거시 리디렉트 유지 여부 |

- Setup의 **My Domain Redirections** UI는 이전 호스트명 처리 방식을 **리디렉트 / 경고와 함께 리디렉트 / 리디렉트 안 함** 형태의 옵션으로 노출한다. Salesforce는 마이그레이션 완료 후 **리디렉트를 끄는 방향**을 권장한다.

> ⚠️ 위 리디렉션 UI의 정확한 라벨 텍스트는 릴리스·org에 따라 다를 수 있음(Tier 2, 접속일 2026-07-11). 표의 **동작·기본값은 Metadata API `MyDomainSettings` 필드 기준으로 검증됨**.

---

## 게스트/커뮤니티 도메인 관계

- Experience Cloud(구 Community) 사이트는 My Domain을 기반으로 한 사이트 URL(`MyDomainName.my.site.com`)을 사용하며, 게스트 사용자 인증·CSP 등 사이트 보안은 별도 노트가 정본이다 → [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]].
- URL 형식·서드파티 쿠키·`.force.com`/`.my.site.com` 도메인 전환은 [[Enhanced Domains]] 참조.

---

## 관련 노트
- [[Enhanced Domains]] — My Domain 이름을 모든 URL 유형에 포함시키는 도메인 정책·URL 형식(정본)
- [[Auth Provider (인증 공급자)]] — 로그인 페이지의 소셜/OpenID 인증 옵션 구성
- [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]] — My Domain 기반 사이트의 게스트/인증 보안
- [[Secure Communications (TLS)]] — 로그인·세션 통신 보안
