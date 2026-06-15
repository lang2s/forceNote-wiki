---
tags: [release, summer_26, platform, admin, security, devops, architecture]
api_version: v67.0
release_date: 2026-06
created: 2026-06-15
source: salesforce_summer26_release_notes.pdf (Salesforce Summer '26 Release Notes, Tier 2)
aliases: [Summer '26 Platform, 서머26 플랫폼, Hyperforce, Edge Network 강제, 엣지 네트워크 의무화, Chatter off, 챗터 기본 비활성, mTLS 인증서 200일]
---

# Summer '26 — Platform (Admin · Security · Automation · Mobile · DevOps · Architecture)

> Summer '26(API v67.0) 플랫폼 영역: Admin/Setup·보안 정책·Flow 자동화·모바일·DevOps/패키징·인프라(Hyperforce·Edge Network·Chatter OFF) 변경 전수.

이 노트는 [[Summer '26]] 릴리즈의 플랫폼 스포크다. Apex/LWC 개발자 변경은 [[Summer '26/Development]], 강제 적용(Release Update) 시점 표는 [[Summer '26/Release Updates]]를 참조한다.

---

## Admin / Setup

- **필드 접근 권한 검토 (Object Manager Field Access Summary)** — Object Manager의 각 필드에서 Profile·Permission Set·Permission Set Group 전체에 걸친 필드 접근 권한(Read/Edit)을 한 화면에서 일괄 확인. 필드별로 누가 어떤 접근 권한을 갖는지 추적하기 쉬워진다.
- **권한 의존성 추적 (Permission Dependency Tracking)** — 한 권한이 다른 권한에 의존하는 관계를 시각화. 권한 부여·회수 시 연쇄 영향을 파악할 수 있다.
- **External Services — Enum 지원 (v67.0+)** — External Services 등록 시 OpenAPI 스키마의 `enum` 타입을 인식·지원. v67.0 이상에서 적용.
- **External Services — Binary File 한도 16 MB → 100 MB** — External Services에서 처리하는 바이너리 파일 크기 한도가 16 MB에서 100 MB로 증가. 요청·응답 양쪽 바이너리 파일에 적용.
  > PDF 원문: "The file size limit for binary files is now 100 MB, increased from 16 MB. This limit applies to both [requests and responses]."
- **27개 표준 시간대 추가** — IANA 표준 기반으로 추가 시간대를 지원. 글로벌 조직의 시간대 정합성 향상.
- **Profile Filtering (Winter '27 강제)** — 프로필 목록을 필터링하는 기능. **Winter '27에 강제 적용**되며 View All Profiles 권한이 필요한 사용자에게 미리 권한을 부여해야 한다. 상세·조치는 [[Summer '26/Release Updates]] 참조.
- **리스트뷰 공유 권한 (List View Sharing Permissions)** — 리스트뷰 공유를 권한 기반으로 제어.
- **표준 엔티티에 커스텀 필드 (Custom Fields on Standard Entities)** — 일부 표준 엔티티에 커스텀 필드를 추가할 수 있도록 확장.

### Beta

- **Setup with Agentforce (Beta)** — Setup용 신규 AI 에이전트로 관리 작업을 단순화. 구 Agent for Setup(2025-03)을 대체하며 Data 360 credit을 소비한다(2026-04). (※ [[Summer '26/Development]]의 "Apex Metrics in Setup with Agentforce"는 이 상위 항목의 하위 기능)
  > PDF 원문: "Setup with Agentforce (Beta) — Simplify administrative tasks by using the new AI-powered agent in Setup."
- **End-User Language Translations → Catalan·Basque 확대 (Beta)** — Catalan·Basque UI 텍스트를 beta 지원 언어로 추가. 번역이 없는 경우 Spanish로 fallback. Summer '26 in-app으로 테스트.
  > PDF 원문: "Expand End-User Language Translations to Catalan and Basque (Beta) … Catalan and Basque UI text, now available as beta-supported languages, falls back to Spanish when translations aren't available."

---

## Security / 정책

### Release Update 성격 항목 (강제 시점은 [[Summer '26/Release Updates]])

아래 항목은 모두 강제 적용(Release Update) 성격이다. 강제 시점·영향·조치 표는 [[Summer '26/Release Updates]]에만 둔다.

- **OAuth 2.0 Username-Password Flow 폐기** — Connected App에서 폐기 예정. (강제 시점: Winter '27 → [[Summer '26/Release Updates]])
- **Triple DES for SAML SSO 종료** — SAML SSO에서 Triple DES 암호화 더 이상 지원 안 함.
- **Salesforce-Managed X(Twitter) Authentication Provider 폐기** — Salesforce 관리형 X 인증 공급자 폐기. 커스텀 X 앱으로 재구성 필요. (Summer '26 강제 → [[Summer '26/Release Updates]])
- **SAML 단일구성 → 다중구성 마이그레이션** — 단일구성 SAML SSO를 다중구성 프레임워크로 마이그레이션. (Summer '26 강제 → [[Summer '26/Release Updates]])

### 인프라 보안 (도메인·인증서·정책)

- **mTLS 인증서 전환 필요** — Chrome Trusted Root List의 Public Root CA를 사용하는 mTLS 인증서를 별도 PKI 계층 구조로 전환해야 한다. Google Chrome이 **2027년 3월 15일**부터 서버 인증과 mTLS를 겸하는 이중 사용 인증서를 제한한다.
- **TLS 인증서 수명 200일로 단축** — **2026년 3월 15일**부터 신규 TLS 인증서의 최대 수명이 200일로 단축(기존 398일). Salesforce는 2026년 7월 6일부터 1P 프로덕션 org 인증서 변경 공지를 중단하므로 인증서 핀닝(certificate pinning) 중단을 권장.
- **Domain Control Validation(DCV) 주기 200일로 단축** — TLS 인증서의 도메인 유효성 재사용 기간이 200일로 단축(**2026년 3월 15일** 시행). 자체 인증서 사용 시 DCV 주기를 조정해야 한다.
- **Salesforce Edge Network 강제 적용 (2026년 7월 11일)** — My Domain URL을 Salesforce Edge Network를 통해 라우팅하는 것이 필수화된다. **2026년 7월 11일**부터 단계적 적용(샌드박스 → 프로덕션). Setup → My Domain → Routing and Policies에서 "Use Salesforce Edge Network"를 활성화한다. 활성화 후 **7일 이내 롤백 가능**.
  > PDF 원문: "Salesforce enforces this change in phases beginning July 11, 2026. Sandbox orgs are enabled [first]."
- **Health Check 신규 시그널 (several / 이번 업데이트는 7개)** — Security Health Check에 여러(several) 신규 시그널 추가로 점검 범위 확대. 개요 산문은 "several new signals"로 서술하지만, "When" 섹션은 "The seven new signals for this update are:"로 이번 업데이트분을 **7개**로 명시한다. 신규 production org는 출시 시점부터 주간 알림이 기본 활성화된다. 이번 업데이트의 7개 시그널:
  - MFA Enabled
  - SAML Enabled
  - Allow access to External Client App consumer secrets via Metadata API
  - Terminate all of a user's sessions when an admin resets that user's password
  - Lock sessions to the IP address from which they originated
  - Percentage of active internal users with System Administrator profile
  - Number of trusted IP ranges
  > PDF 원문: "Health Check has received several new signals to help keep your org secure … The seven new signals for this update are:" (Enterprise·Performance·Unlimited·Developer 에디션 Lightning Experience, GovCloud 미지원)
- **CSP 헤더 12 KB 권장** — Content Security Policy 헤더 크기를 12 KB 이내로 유지할 것을 권장.
- **Malformed Trusted URLs 처리 개선** — 잘못 구성된 Trusted URL을 식별·정리. `CspTrustedSite` 오브젝트의 `EndpointUrl` 필드로 추적.
- **Security Center with Agentforce (Beta)** — Security Center에 Agentforce를 결합해 보안 인사이트를 자연어로 조회·요약(Beta). 하위 Beta 기능 3건:
  - **Focus Security Investigations with Anomaly Triage (Beta)** — Security Agent가 동일 사용자 세션·활동의 이상 징후를 24시간 내로 상관 분석해 단일 investigation으로 통합, 고유 위협일 때만 investigation 생성(알림 피로 감소).
  - **Follow Incident Timelines for Investigations (Beta)** — Event Monitoring 로그를 분석해 이상 징후 탐지 전·중·후 관련 활동을 Incident Timeline으로 제공(수동 데이터 상관 작업 제거).
  - **Get Remediation Plans for Security Incidents (Beta)** — 조사 완료 후 탐지된 이상 징후에 맞춘 표준화된 단계별 복구 계획(remediation plan)을 제공.
- **Data Detect 개선** — 민감 데이터 탐지(Data Detect) 기능 개선.

---

## Automation (Flow)

### GA

- **Static Resource Images in Display Text (GA)** — Display Text 컴포넌트에서 정적 리소스(Static Resource) 이미지를 직접 삽입(GA).

### 신규

- **Scheduled Flow 커스텀 배치 크기 (1–200)** — Start 요소 → Advanced Options에서 배치 크기를 1–200 범위로 설정.
- **날짜 연산자 추가 (Decision 요소)** — Is Today, Is Anniversary of Today, Last Number of Days 연산자 추가.
- **Show Toast Message 액션** — Flow에서 화면 토스트 메시지를 표시하는 신규 액션.
- **Open a Page 액션** — Flow에서 레코드 페이지 또는 외부 URL을 여는 신규 액션.
- **Compare Flow Versions** — Flow Builder에서 두 버전을 비교하는 도구.
- **Flow Orchestration 표준 기능화** — 별도 애드온 없이 기본 기능으로 제공.
- **Flow Extensions** — CPE(커스텀 프로퍼티 에디터)를 개별 입력 파라미터 단위로 지정, Picklist Values 지원, `stylingHook` 지원.
- **Flow Runtime Version 노출 (Expose Flow Runtime Version)** — Flow가 실행되는 런타임 버전을 확인할 수 있도록 노출.

### Beta

- **Update Screen Flows with Natural Language Prompts (Beta)** — 자연어 프롬프트로 화면 Flow를 수정(Agentforce for Flow가 GA에서 Beta로 복귀).
- **Troubleshoot Flow Errors with Agentforce (Beta)** — Agentforce가 Flow 오류를 진단·해결 지원.
- **Excel-Based Automations (Beta)** — Excel 기반 자동화.
- **Document Reader Agent (Beta)** — 문서를 읽어 처리하는 에이전트.

---

## Mobile

### GA

- **Custom Phone Notifications Actions (GA)** — 모바일 푸시 알림에 커스텀 액션을 추가(GA).
- **Agentforce Voice (GA)** — 모바일에서 Agentforce 음성 기능 GA.

### Beta

- **Customize Mobile Home Page (Beta)** — 모바일 홈 페이지 커스터마이즈.
- **React Apps in Mobile App (Beta)** — Salesforce 모바일 앱 내에서 React 앱 실행.

### 기타

- **React Native Agentforce SDK** — React Native용 Agentforce SDK 제공.
- **Lightning Types 모바일 지원** — Lightning Types를 모바일에서 사용.

---

## DevOps / Packaging

- **Managed Package Push Upgrade 만료 기간 설정** — 커스텀 Push Upgrade에 만료 일수(days)를 설정할 수 있다. 1GP/2GP 관리 패키지 모두에 적용. 1GP는 패키징 org, 2GP는 Dev Hub org에서 시스템 관리자로 로그인해 Developer Console에서 `PushUpgradeCustomizationRepository` 레코드를 생성하고 구독자에게 커스텀 푸시 업그레이드가 제공되는 일수를 입력한다. 아래 예시는 90일 후 만료 설정이다.

```apex
// PDF 원문 발췌 — salesforce_summer26_release_notes.pdf
String pucId1 = PushUpgradeCustomizationRepository.create('packageID', 'subscriberOrgID', true, 90);
System.debug('pucId1 =' + pucId1);
```

  자세한 메커니즘은 [[2GP — Push Upgrade]] 참조.

- **Scratch Org 데이터 스토리지 한도 200 MB → 500 MB** — 스크래치 org 데이터 스토리지 한도가 200 MB에서 500 MB로 증가.
  > PDF 원문: "The data storage limit for a scratch org is now 500 MB. Previously, the limit was 200 MB."
- **Non-Preview Sandbox 생성 옵션** — 릴리즈 전환 기간 중 기본값인 Preview Sandbox 대신 Non-Preview Sandbox를 선택 생성 가능(고객지원팀 경유). Preview 샌드박스는 프로덕션보다 약 6주 먼저 업그레이드되지만, Non-Preview 샌드박스는 메이저 릴리즈 업그레이드 완료 시점에 업그레이드되어 프로덕션과 동일 환경에서 출시 준비 상태를 검증할 수 있다.
- **Salesforce CLI 개선** — `template generate` 명령에 `ui-bundle` / `flexpage` 템플릿 추가, `reactinternalapp` 템플릿 추가, `--lwc-language typescript` 플래그(TypeScript LWC 생성) 추가.
- **Agentforce DX** — Agentforce 에이전트를 DX 워크플로로 개발·배포.
- **DX MCP Server** — Salesforce DX용 MCP Server.

---

## Architecture / Infrastructure

- **Hyperforce 리전 확장 — Cape Town 신규** — 2026년 5월 남아프리카(케이프타운) Hyperforce 리전 오픈. 현재 **18개국**에서 제공.
  > PDF 원문: "Salesforce opened a new Hyperforce region in Cape Town, South Africa, in May 2026."
- **ACRC RTO/RPO 12h/4h (EU·India 추가)** — Advanced Cross-Region Continuity가 EU·India 리전에 추가 제공. 복구 목표가 RTO 12시간, RPO 4시간으로 개선.
- **Hyperforce — B2C Commerce US 추가** — Salesforce B2C Commerce가 Hyperforce 미국 리전에서 제공 시작.
- **IPv6 준비 단계** — Government Cloud org 대상 2026년 중 IPv6 지원 예정, 기타 org는 2027년 이후 예상. IP 허용 목록 → 도메인 허용 목록 전환 권장.
- **Chatter — 신규 org 기본 비활성화 (OFF)** — Summer '26 이후 생성된 Enterprise/Unlimited/Developer org에서 Chatter 기본값이 OFF. Slack 채널이 기본 협업 수단으로 대체된다. Case Feed·Experience Cloud 등 Chatter 의존 기능 사용 시 Setup → Chatter Settings에서 수동 활성화 필요(기존 org 미영향).
- **Own Archive Managed Package 은퇴** — Own Archive 관리 패키지 갱신이 2026년 5월 4일 종료, Legacy Archive 갱신은 2027년 2월 2일 종료. **Archive 2.0**으로 마이그레이션 필요(확장성·성능 개선).

---

## 관련 노트

- [[Summer '26]] — Summer '26 릴리즈 허브
- [[Summer '26/Release Updates]] — 강제 적용(Release Update) 시점 표
- [[2GP — Push Upgrade]] — Push Upgrade 메커니즘 상세
