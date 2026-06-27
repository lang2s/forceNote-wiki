---
tags: [agent-skill, sf-skills, integration, named-credential, platform-events, callout]
source: forcedotcom/sf-skills (skills/integration-connectivity-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [integration-connectivity-generate, 통합 런타임 구성, Named Credential, External Credential, External Services, Platform Events, CDC, REST SOAP callout]
---

# integration-connectivity-generate — Salesforce 통합 아키텍처 / 런타임 플러밍

> Named Credential·External Credential·External Services·REST/SOAP callout·Platform Events·CDC 등 통합 아키텍처와 런타임 배선을 120점 채점과 함께 생성한다.

## 목적과 활성화 조건

`metadata.version: 1.1`

**TRIGGER:** Named Credentials, External Services, REST/SOAP callouts, Platform Events, CDC 셋업, `.namedCredential-meta.xml` 파일 작업.

**DO NOT TRIGGER:**
- Connected App/OAuth 구성 → [[integration-connectivity-connected-app-configure]]
- Apex-only 로직 → `platform-apex-generate`
- data import/export → `platform-data-manage`
- CDC channel-membership metadata(`PlatformEventChannel`, `PlatformEventChannelMember`, `EnrichedField`) → [[integration-eventing-cdc-configure]]

**이 스킬이 소관하는 작업:** `.namedCredential-meta.xml` / External Credential metadata, outbound REST/SOAP callout, OpenAPI spec 기반 External Service 등록, Platform Events·CDC·event-driven 아키텍처, sync vs async 패턴 선택.

## 워크플로 / 단계

### 1. 통합 패턴 선택

| 필요 | 기본 패턴 |
|---|---|
| 인증된 outbound API 호출 | Named Credential / External Credential + Apex 또는 Flow |
| spec 기반 API client | External Service |
| trigger 발생 callout | async callout 패턴 |
| 디커플드 event 발행 | Platform Events |
| change-stream 소비 | CDC |

### 2. Auth 모델 선택

런타임이 관리하는 안전한 auth 선호:
- Named Credentials / External Credentials
- 적절한 credential 모델을 통한 OAuth 또는 JWT
- 코드에 하드코딩된 secret 없음

### 3. 올바른 템플릿에서 생성

`assets/` 하위 제공 자산 사용:
- `assets/named-credentials/` — Named Credential XML(OAuth, JWT, Certificate, Custom auth)
- `assets/external-credentials/` — External Credential XML(OAuth, JWT)
- `assets/external-services/` — External Service 등록 템플릿 + operations guide
- `assets/callouts/` — REST sync, Queueable, retry handler, HTTP response handler Apex
- `assets/platform-events/` — Platform Event 정의·publisher·subscriber
- `assets/cdc/` — CDC handler·subscriber trigger
- `assets/soap/` — SOAP callout service + wsdl2apex guide
- `assets/endpoint-security/` — Remote Site Setting / CSP Trusted Site XML

OAuth JWT bearer Named Credential 템플릿(verbatim 발췌):

```xml
<NamedCredential xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>{{CredentialName}}</fullName>
    <label>{{CredentialLabel}}</label>
    <endpoint>{{BaseEndpoint}}</endpoint>
    <principalType>NamedUser</principalType>
    <protocol>Oauth</protocol>
    <oauthTokenEndpoint>{{TokenEndpoint}}</oauthTokenEndpoint>
    <oauthScope>{{Scopes}}</oauthScope>
    <certificate>{{CertificateName}}</certificate>
    <generateAuthorizationHeader>true</generateAuthorizationHeader>
    <allowMergeFieldsInBody>true</allowMergeFieldsInBody>
    <allowMergeFieldsInHeader>true</allowMergeFieldsInHeader>
</NamedCredential>
```

External Credential(JWT, API 61.0+ 필요) 템플릿 발췌 — JWT 인증은 `externalCredentialParameters` 블록으로 claim을 정의:

```xml
<ExternalCredential xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>{{CredentialLabel}}</label>
    <authenticationProtocol>Jwt</authenticationProtocol>
    <externalCredentialParameters>
        <parameterName>issuer</parameterName>
        <parameterType>SigningCertificate</parameterType>
        <parameterValue>{{CertificateName}}</parameterValue>
    </externalCredentialParameters>
    <principals>
        <principalName>{{PrincipalName}}</principalName>
        <principalType>NamedPrincipal</principalType>
        <sequenceNumber>1</sequenceNumber>
    </principals>
</ExternalCredential>
```

### 4. 운영 안전성 검증

확인:
- timeout·retry 처리
- trigger 발생 작업에 대한 async 전략
- logging / observability
- event retention 및 subscriber 영향

### 5. 배포·구현 핸드오프

- `platform-metadata-deploy` — 배포
- `platform-apex-generate` — 더 깊은 service / retry 코드
- `automation-flow-generate` — 선언적 HTTP callout 오케스트레이션

## 핵심 규칙·가드레일

**High-Signal Rules:**
- credential 하드코딩 금지
- trigger에서 synchronous callout 금지
- timeout 동작을 명시적으로 정의
- transient 실패에 retry 계획
- outbound volume이 높으면 middleware / event-driven 패턴 사용
- 지원될 때 신규 개발은 External Credentials 아키텍처 선호

**Common anti-patterns:**
- sync trigger callout
- retry·dead-letter 전략 부재
- request/response logging 부재
- auth 셋업 책임과 런타임 통합 설계의 혼합

### Output Expectations

이 스킬 완료 시 산출물:
1. **Credential metadata** — org 값으로 채운 `named-credentials/` 또는 `external-credentials/` 파일
2. **Callout Apex class** — Named Credential 패턴 사용 `.cls`, 컨텍스트 기반 async/sync 선택
3. **Event/CDC artifacts** — Platform Event `.object-meta.xml`, subscriber trigger, CDC config(event-driven 선택 시)
4. **Endpoint security metadata** — Remote Site Setting / CSP Trusted Site XML
5. **Scoring report** — 6개 카테고리(Security, Error Handling, Bulkification, Architecture, Best Practices, Documentation) 120점
6. **Next step** — 배포 또는 테스트 지시

### Score Guide

| Score | 의미 |
|---|---|
| 108+ | 강력한 production-ready 통합 설계 |
| 90–107 | 좋은 설계, 일부 하드닝 남음 |
| 72–89 | 동작하나 아키텍처 검토 필요 |
| < 72 | unsafe / 배포에 불완전 |

## 번들 파일

- **assets/** — `named-credentials/`, `external-credentials/`, `external-services/`, `callouts/`, `platform-events/`, `cdc/`, `soap/`, `endpoint-security/`
- **references/** — `named-credentials-guide.md`, `named-credentials-automation.md`, `external-services-guide.md`, `callout-patterns.md`, `rest-callout-patterns.md`, `security-best-practices.md`, `event-patterns.md`, `platform-events-guide.md`, `cdc-guide.md`, `event-driven-architecture-guide.md`, `messaging-api-v2.md`, `cli-reference.md`, `scoring-rubric.md`
- **scripts/** — `configure-named-credential.sh`, `set-api-credential.sh`, `templates/setup-credentials-with-csp.sh`, `README.md`
- **hooks/scripts/** — `suggest_credential_setup.py`(통합 파일 감지 시 credential 구성 단계 제안), `validate_integration.py`(응답 전 통합 패턴 검증)
- 그 외: `CREDITS.md`, `README.md`

## 관련 노트
- [[integration-connectivity-connected-app-configure]]
- [[integration-eventing-cdc-configure]]
- [[integration-eventing-subscription-configure]]
