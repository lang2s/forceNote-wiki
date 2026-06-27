---
tags: [agent-skill, sf-skills, integration, connected-app, oauth, external-client-app]
source: forcedotcom/sf-skills (skills/integration-connectivity-connected-app-configure/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [integration-connectivity-connected-app-configure, 커넥티드 앱 OAuth 구성, Connected App, External Client App, ECA, JWT Bearer, PKCE]
---

# integration-connectivity-connected-app-configure — 커넥티드 앱 / External Client App OAuth 구성

> Salesforce OAuth 앱(Connected App / External Client App)의 OAuth flow·JWT bearer·PKCE·scope·마이그레이션을 120점 보안 채점과 함께 구성한다.

## 목적과 활성화 조건

`metadata.version: 1.1`

**TRIGGER:** OAuth flow 구성, JWT bearer auth, Connected App / External Client App(ECA) 작업, `.connectedApp-meta.xml` / `.eca-meta.xml` 파일 편집.

**DO NOT TRIGGER:**
- callout용 Named Credential 구성 → [[integration-connectivity-generate]]
- permission policy 검토 → `platform-metadata-deploy`
- Apex token-handling 코드 작성 → `platform-apex-generate`

**In scope:** `.connectedApp-meta.xml` / `.eca-meta.xml`, OAuth flow 선택·callback·scope, JWT bearer / device / client credentials / auth-code 결정, Connected App vs ECA 아키텍처, consumer key/secret/certificate 전략.

## 워크플로 / 단계

### 1. 앱 모델 선택 — Connected App vs External Client App

| 필요 | 선호 |
|---|---|
| 단순 single-org OAuth 앱 | Connected App |
| 더 나은 secret 처리가 필요한 신규 개발 | External Client App |
| multi-org / packaging / 강한 운영 제어 | External Client App |
| 단순 legacy 호환 | Connected App |

- 신규 regulated·packageable·automation 중심 솔루션 → **ECA**.
- 단순성·legacy 호환이 더 중요 → **Connected App**.
- **Spring '26 노트:** orgs에서 신규 Connected App 생성이 기본 비활성화. 신규 통합은 Connected App 호환이 명시적으로 필요하지 않으면 ECA 선호.

### 2. OAuth flow 선택

| Use case | 기본 flow |
|---|---|
| backend web app | Authorization Code |
| SPA / mobile / public client | Authorization Code + PKCE |
| server-to-server / CI/CD | JWT Bearer |
| device / CLI auth | Device Flow |
| service account 스타일 앱 | Client Credentials (보통 ECA) |

### 3. 올바른 템플릿에서 시작

scratch에서 만들지 말고 적절한 템플릿을 먼저 읽는다.

| 템플릿 | Use case |
|---|---|
| `assets/connected-app-basic.xml` | 단순 API 통합, 최소 OAuth |
| `assets/connected-app-oauth.xml` | 전체 OAuth 2.0 구성 web app |
| `assets/connected-app-jwt.xml` | JWT bearer / server-to-server |
| `assets/connected-app-canvas.xml` | Canvas — Salesforce UI에 외부 앱 임베드 |
| `assets/external-client-app.xml` | ECA 헤더 파일 — 모든 신규 ECA 빌드 시작점 |
| `assets/eca-global-oauth.xml` | ECA 글로벌 OAuth 설정(scope, PKCE, rotation) |
| `assets/eca-oauth-settings.xml` | ECA per-app OAuth 설정 |
| `assets/eca-policies.xml` | ECA configurable policies |

source-controlled ECA OAuth security metadata가 필요하면 org에서 먼저 retrieve하고 그 파일을 schema의 source of truth로 취급한다:

```
sf project retrieve start --metadata ExtlClntAppOauthSecuritySettings:<AppName> --target-org <alias>
```

`assets/connected-app-jwt.xml` 구조(verbatim 발췌 — JWT bearer flow는 callback URL이 불필요하지만 Salesforce가 요구):

```xml
<ConnectedApp xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>{{APP_NAME}}</label>
    <contactEmail>{{CONTACT_EMAIL}}</contactEmail>
    <description>{{DESCRIPTION}} - JWT Bearer Authentication</description>
    <oauthConfig>
        <!-- JWT Bearer flow doesn't require callback URL, but Salesforce requires one -->
        <callbackUrl>https://localhost/oauth/callback</callbackUrl>
        <!-- Certificate for JWT signing -->
        <certificate>{{CERTIFICATE_NAME}}</certificate>
        <isAdminApproved>true</isAdminApproved>
        <isConsumerSecretOptional>true</isConsumerSecretOptional>
        <scopes>Api</scopes>
    </oauthConfig>
    <oauthPolicy>
        <ipRelaxation>ENFORCE</ipRelaxation>
        <refreshTokenPolicy>zero</refreshTokenPolicy>
    </oauthPolicy>
    <permissionSetLicense>
        <license>Salesforce</license>
    </permissionSetLicense>
</ConnectedApp>
```

### 4. 보안 하드닝

`references/security-checklist.md`의 전체 120점 체크리스트를 적용. 선호:
- Least-privilege scopes
- 명시적 callback URL
- public client에 PKCE
- 적절할 때 certificate 기반 auth
- rotation-ready secret/key 처리
- 현실적·유지 가능할 때 IP 제한

### 5. 배포 준비 검증

`references/testing-validation-guide.md`를 읽고 확인:
- metadata 파일 네이밍 정확성(아래 Gotchas)
- scope 정당화 여부
- callback·auth model이 실제 client type과 일치
- secret이 source에 임베드되지 않음

### 6. 에러 처리

배포 실패 시 에러 출력 확인:
- `DUPLICATE_VALUE` — 동일 이름의 Connected App/ECA가 이미 존재; rename 또는 retrieve-then-update
- `INVALID_CROSS_REFERENCE_KEY` — ECA settings 파일의 `externalClientApplication` 이름이 `.eca-meta.xml` 파일명과 정확히 불일치
- `INSUFFICIENT_ACCESS_OR_READONLY` — "Manage Connected Apps" 권한 부재
- 어떤 단계든 실패하면 다음 단계로 진행하지 말고 위 구체적 메시지로 사용자에게 surface

## 핵심 규칙·가드레일

| 규칙 | 근거 |
|---|---|
| consumer secret을 source control에 절대 commit 금지 | credential 노출 위험 |
| 기본으로 `Full` scope 사용 금지 | 불필요한 권한; 앱이 필요한 것만 요청 |
| public client(mobile, SPA)는 항상 PKCE 사용 | auth code 가로채기 방지 |
| wildcard·과도하게 넓은 callback URL 사용 금지 | token 가로채기 위험 |
| ECA OAuth security settings는 편집 전 org에서 retrieve 필수 | 파일 schema가 완전히 문서화되지 않음; retrieve-first가 정확성 보장 |
| CLI 명령에 `<alias>` placeholder 사용, org URL 하드코딩 금지 | org URL은 환경마다 다름 |
| 파일 작성 전 `sfdx-project.json`에서 실제 `packageDirectory` 감지 | 프로젝트가 기본 `force-app/main/default/` 레이아웃이 아닐 수 있음 |

### Metadata Notes That Matter

**Connected App** 기본 source 위치(`sfdx-project.json → packageDirectories`로 검증): `<packageDir>/connectedApps/`

**External Client App** — ECA metadata는 여러 top-level source 디렉토리에 걸침:

| 디렉토리 | Metadata type | 파일 suffix |
|---|---|---|
| `<packageDir>/externalClientApps/` | `ExternalClientApplication` | `.eca-meta.xml` |
| `<packageDir>/extlClntAppGlobalOauthSets/` | `ExtlClntAppGlobalOauthSettings` | `.ecaGlblOauth-meta.xml` |
| `<packageDir>/extlClntAppOauthSettings/` | `ExtlClntAppOauthSettings` | `.ecaOauth-meta.xml` |
| `<packageDir>/extlClntAppOauthSecuritySettings/` | `ExtlClntAppOauthSecuritySettings` | `.ecaOauthSecurity-meta.xml` |
| `<packageDir>/extlClntAppOauthPolicies/` | `ExtlClntAppOauthConfigurablePolicies` | `.ecaOauthPlcy-meta.xml` |
| `<packageDir>/extlClntAppPolicies/` | `ExtlClntAppConfigurablePolicies` | `.ecaPlcy-meta.xml` |

### Gotchas

| Gotcha | 상세 |
|---|---|
| `.ecaGlblOauth` (`.ecaGlobalOauth` 아님) | global OAuth suffix는 축약형 — long form은 배포 실패 |
| `.ecaPlcy` (`.ecaPolicy` 아님) | 동일 축약 패턴 — general policy suffix는 short form |
| `.ecaOauthSecurity` (`.ecaSecurity` 아님) | security settings suffix |
| ECA OAuth security settings는 retrieve-only | source에서 scratch 생성 불가 — 항상 org에서 retrieve |
| Spring '26: 신규 Connected App 기본 비활성화 | 신규 orgs는 Connected App 생성 차단; 명시 요구 없으면 ECA |
| consumer key는 배포 후 생성 | metadata에 consumer key 설정 불가 — 첫 배포 후 retrieve |

### Score Guide

| Score | 의미 |
|---|---|
| 80+ | production-ready OAuth 앱 구성 |
| 54–79 | 동작하나 하드닝 검토 필요 |
| < 54 | 수정 전까지 배포 차단 |

## 번들 파일

- **assets/** — `connected-app-basic.xml`, `connected-app-oauth.xml`, `connected-app-jwt.xml`, `connected-app-canvas.xml`, `external-client-app.xml`, `eca-global-oauth.xml`, `eca-oauth-settings.xml`, `eca-policies.xml`
- **references/** — `oauth-flows-reference.md`(flow 비교·결정), `security-checklist.md`(120점 채점), `testing-validation-guide.md`(배포 전 검증), `migration-guide.md`(Connected App→ECA 마이그레이션), `example-usage.md`(end-to-end 예시)
- 그 외: `CREDITS.md`, `README.md`

## 관련 노트
- [[integration-connectivity-generate]]
- [[platform-metadata-deploy]]
- [[platform-apex-generate]]
- [[Auth Namespace]] — JWT·OAuth·SessionManagement Apex API 위키 노트
- [[DX 인증 방식]] — Connected App/External Client App JWT·web 로그인
- [[2GP — Components - Security & Access]] — ConnectedApp 패키징 규칙
