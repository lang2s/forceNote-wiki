---
tags: [index, agent-skills, sf-skills, catalog]
created: 2026-06-26
---

# sf-skills — forcedotcom/sf-skills 스킬 카탈로그

> 공식 [`forcedotcom/sf-skills`](https://github.com/forcedotcom/sf-skills) 라이브러리의 에이전트 스킬(각 스킬은 `SKILL.md` 기반 단계별 절차)을 도메인별로 모은 허브. 설치: `npx skills add forcedotcom/sf-skills`. 각 노트는 스킬 1개(`<skill-id>.md`)에 대응한다.

**상위:** [[AgentSkills(에이전트스킬)/index|AgentSkills]] · **키워드 검색:** `_index/agent-skills.md`

> 📚 **레퍼런스 문서 카탈로그:** 각 스킬이 동작 중 참조하는 세부 레퍼런스 문서 **252개**(41개 부모 스킬)는 [[refs/index|sf-skills 레퍼런스 문서 카탈로그]]에 정리됨. 키워드 검색은 `_index/agent-skills-refs-*.md` 샤드.

---

## Platform (Apex · Metadata · 선언적 빌드)

| 스킬 | 한 줄 설명 |
|---|---|
| [[platform-apex-generate]] | 프로덕션급 Apex 생성·리팩터링·리뷰 — 일차 Apex authoring 스킬 |
| [[platform-apex-test-generate]] | Apex 테스트 클래스 생성·검증 (TestDataFactory·bulk·mocking) |
| [[platform-apex-test-run]] | Apex 테스트 실행·커버리지 분석·test-fix 루프 |
| [[platform-apex-logs-debug]] | 디버그 로그 근거 root-cause 분석 (거버너 한도·stack trace·heap/CPU) |
| [[platform-soql-query]] | SOQL/SOSL 작성·최적화·selectivity 분석 |
| [[platform-data-manage]] | 레코드 CRUD·bulk import/export·테스트 데이터·정리 |
| [[platform-custom-object-generate]] | 커스텀 오브젝트 메타데이터(.object-meta.xml) 생성 |
| [[platform-custom-field-generate]] | 커스텀 필드 메타데이터(Roll-Up/Master-Detail/Formula) 생성 |
| [[platform-custom-tab-generate]] | 커스텀 탭 메타데이터 생성 |
| [[platform-custom-application-generate]] | 커스텀 Lightning App 메타데이터 생성 |
| [[platform-flexipage-generate]] | Lightning 페이지(FlexiPage) 생성 (CLI bootstrap) |
| [[platform-list-view-generate]] | List View 메타데이터 생성·검증 |
| [[platform-validation-rule-generate]] | 검증 규칙(Validation Rule) 메타데이터 생성·검증 |
| [[platform-permission-set-generate]] | 권한 집합(PermissionSet/FLS) 메타데이터 생성 |
| [[platform-custom-lightning-type-generate]] | Einstein Agent action용 Custom Lightning Type(CLT/JSON Schema) 생성 |
| [[platform-lightning-app-coordinate]] | 완전한 Lightning 앱 end-to-end 오케스트레이션 |
| [[platform-metadata-deploy]] | sf CLI 메타데이터 배포 오케스트레이션 (dry-run·CI/CD) |
| [[platform-metadata-api-context-get]] | 604개 Metadata API 타입 참조 컨텍스트 (section-specific 소비) |
| [[platform-docs-get]] | 공식 Salesforce 문서 retrieval로 답변 grounding |
| [[platform-agentexchange-partner-offers-configure]] | Transactable Marketplace partner offer 수신 org preference 설정 |
| [[platform-trust-archive-manage]] | Salesforce Archive 운영 (search·unarchive·mask·RTBF erase, Connect API·ArchiveActivity) |

## Experience (LWC · React UI Bundle)

| 스킬 | 한 줄 설명 |
|---|---|
| [[experience-lwc-generate]] | LWC 생성 — PICKLES·wire·Apex/GraphQL·SLDS2·Jest (165점 채점) |
| [[experience-ui-bundle-app-coordinate]] | React UI bundle 앱 end-to-end 빌드 오케스트레이션 |
| [[experience-ui-bundle-metadata-generate]] | UI bundle 스캐폴딩·meta XML·ui-bundle.json·CSP Trusted Site |
| [[experience-ui-bundle-features-generate]] | 사전 빌드 기능(인증·검색) 설치 |
| [[experience-ui-bundle-salesforce-data-access]] | UI bundle 데이터 접근 (Data SDK·GraphQL·REST) |
| [[experience-ui-bundle-frontend-generate]] | UI bundle 페이지·컴포넌트·레이아웃·스타일링 수정 |
| [[experience-ui-bundle-agentforce-client-generate]] | UI bundle에 Agentforce 대화 클라이언트 임베드 |
| [[experience-ui-bundle-file-upload-generate]] | UI bundle 파일 업로드 API (ContentVersion·진행률 추적) |
| [[experience-ui-bundle-deploy]] | UI bundle 배포 (7단계 canonical 시퀀스·codegen) |
| [[experience-ui-bundle-site-generate]] | Digital Experience Site 인프라 생성 (외부 호스팅) |
| [[experience-ui-bundle-custom-app-generate]] | React UI bundle용 Custom Application 생성 (내부 호스팅) |
| [[experience-cms-brand-apply]] | CMS 브랜드 가이드라인(voice·tone·style) 검색·콘텐츠 적용 |
| [[experience-content-media-search]] | CMS·Data 360에서 시각 미디어(이미지·로고·배너) 검색 라우팅 |

## Agentforce (에이전트)

| 스킬 | 한 줄 설명 |
|---|---|
| [[agentforce-generate]] | Agent Script로 .agent(AiAuthoringBundle) build/modify/debug/deploy |
| [[agentforce-test]] | Agentforce 에이전트 테스트 스위트 작성·실행·분석 (ADLC Test) |
| [[agentforce-observe]] | 프로덕션 에이전트 관측성 (Observe-Reproduce-Improve, STDM) |
| [[agentforce-architecture-analyze]] | 선언적 design-time 메타데이터 기반 에이전트 아키텍처 스냅샷 |
| [[agentforce-d360-analyze]] | Data Cloud 360° 세션 뷰 (STDM session trace 재구성) |

## Data 360 / Data Cloud

| 스킬 | 한 줄 설명 |
|---|---|
| [[data360-orchestrate]] | connect→prepare→harmonize→segment→act→retrieve Data Cloud 상위 오케스트레이터 |
| [[data360-connect]] | Data Cloud 소스 연결 (커넥터·연결 메타데이터·소스 객체) |
| [[data360-prepare]] | Data Cloud ingestion·레이크 준비 (data stream·DLO·transform·Document AI) |
| [[data360-harmonize]] | 스키마 조화·통합 (DMO·매핑·identity resolution·data graph) |
| [[data360-segment]] | 오디언스·인사이트 (segment·calculated insight·publish) |
| [[data360-activate]] | 다운스트림 전달 (activation·activation target·data action) |
| [[data360-query]] | 질의·검색 (Data Cloud SQL·async query·vector/hybrid search·search index) |
| [[developing-datacloud-code-extension]] | SF CLI 플러그인으로 Data Cloud 커스텀 Python 변환 개발·테스트·배포 |
| [[getting-datacloud-schema]] | SSOT REST API로 DLO/DMO 스키마 조회 |

## OmniStudio

| 스킬 | 한 줄 설명 |
|---|---|
| [[omnistudio-omniscript-generate]] | 다단계 가이드형 디지털 경험(OmniScript) 생성·검증 |
| [[omnistudio-flexcard-generate]] | at-a-glance UI 카드(FlexCard/OmniUiCard) 생성·검증 |
| [[omnistudio-integration-procedure-generate]] | server-side 다단계 orchestration(Integration Procedure) 생성·검증 |
| [[omnistudio-datamapper-generate]] | Data Mapper(구 DataRaptor) Extract/Transform/Load/Turbo 생성·검증 |
| [[omnistudio-dependencies-analyze]] | 교차 컴포넌트 네임스페이스 감지·의존성 그래프·Mermaid 시각화 |
| [[omnistudio-callable-apex-generate]] | Industries Common Core용 System.Callable Apex 생성·검토·마이그레이션 |
| [[omnistudio-datapacks-deploy]] | Vlocity Build로 DataPack export·deploy·retry·diff·org-to-org 마이그레이션 |
| [[omnistudio-epc-catalog-generate]] | CME EPC Product2 카탈로그·오퍼 번들·DataPack JSON 생성 (120점) |

## Integration (커넥티비티 · 이벤팅)

| 스킬 | 한 줄 설명 |
|---|---|
| [[integration-connectivity-generate]] | 통합 런타임 플러밍 (Named/External Credential·External Services·callout·Platform Events·CDC) |
| [[integration-connectivity-connected-app-configure]] | Connected App / External Client App OAuth 구성 (JWT·PKCE·scope) |
| [[integration-eventing-cdc-configure]] | Change Data Capture 활성화 메타데이터 (PlatformEventChannel·Member) |
| [[integration-eventing-subscription-configure]] | ManagedEventSubscription 메타데이터 CRUD (replay 추적) |

## DevOps / Testing (DevOps Center)

| 스킬 | 한 줄 설명 |
|---|---|
| [[analyzing-test-failures]] | 테스트 실패·Code Analyzer 위반을 평이한 언어로 해석·개선 제안 (순수 추론) |
| [[automation-flow-generate]] | MCP 3-step 파이프라인으로 Salesforce Flow 메타데이터 생성 (유일 스킬) |
| [[checking-devops-prerequisites]] | DevOps Center 파이프라인 테스트 액션 전 org·플러그인·파이프라인 확인 (공유 게이트) |
| [[configuring-quality-gate]] | DevOps Center quality gate 생성·연결 (PASS_PERCENTAGE/SEVERITY/ESSENTIAL) |
| [[configuring-test-provider]] | test provider(Apex/Code Analyzer/Flow/Provar)를 파이프라인에 구성 |
| [[creating-fix-work-item]] | 테스트 실패·위반 fix 추적용 DevOps Center WorkItem 생성 |
| [[managing-suite-assignments]] | 파이프라인 스테이지에 테스트 스위트 할당·매핑 (testSuiteStages) |
| [[polling-test-results]] | 비동기 테스트 실행을 runId로 폴링해 완료까지 추적 |
| [[recommending-devops-tests]] | 커밋 diff 기반 관련 스위트 추천·coverage gap 플래그 (순수 추론) |
| [[running-devops-test-suite]] | 파이프라인 스테이지에서 테스트 스위트를 Connect API로 비동기 실행 |
| [[syncing-test-providers]] | 구성된 test provider를 재싱크해 신규 스위트 끌어오기 |

## Design Systems (SLDS)

| 스킬 | 한 줄 설명 |
|---|---|
| [[design-systems-slds-apply]] | SLDS v2 준수 UI 적용 (blueprint·styling hook·utility·icon) |
| [[design-systems-slds-validate]] | LWC SLDS 준수 품질 감사·scorecard |
| [[design-systems-slds2-migrate]] | SLDS 1→2 마이그레이션 (token·hardcoded value 교체) |

## Diagram (다이어그램)

| 스킬 | 한 줄 설명 |
|---|---|
| [[external-diagram-mermaid-generate]] | 텍스트 기반(Mermaid + ASCII) Salesforce 다이어그램 생성 |
| [[external-diagram-visual-generate]] | Nano Banana Pro로 PNG/SVG 비주얼(ERD·mockup·wireframe) 생성 |

## Mobile (네이티브 · 오프라인)

| 스킬 | 한 줄 설명 |
|---|---|
| [[mobile-apps-create]] | Salesforce 네이티브 모바일 앱 생성 진입점 (Mobile SDK vs Agentforce SDK · iOS/Android 라우팅) |
| [[mobile-platform-native-capabilities-integrate]] | `lightning/mobileCapabilities`로 바코드·생체인증·위치·NFC 등 네이티브 기능 LWC 통합 |
| [[mobile-platform-offline-validate]] | LWC 모바일 오프라인(Komaci) 정적 분석·검증 (Mobile App Plus·Field Service Mobile) |

## DX 툴링 (CLI · Code Analyzer · Analytics)

| 스킬 | 한 줄 설명 |
|---|---|
| [[dx-app-analytics-query]] | ISV 관리형 패키지 사용량 분석 조회 (AppAnalyticsQueryRequest·AppAnalyticsSettings) |
| [[dx-code-analyzer-configure]] | `code-analyzer.yml` 구성 — 엔진/규칙/억제/심각도·CI/CD 파이프라인 |
| [[dx-code-analyzer-run]] | `sf code-analyzer run`으로 정적 분석 스캔·위반 필터/랭킹·자동 수정 |
| [[dx-org-switch]] | 기본 org(default target-org) 전환 (`sf config set target-org`) |

## Commerce (B2B)

| 스킬 | 한 줄 설명 |
|---|---|
| [[commerce-b2b-open-code-components-integrate]] | 오픈소스 B2B Commerce 컴포넌트를 site 메타데이터로 복사해 Experience Builder 노출 |
| [[commerce-b2b-store-create]] | Commerce B2B 스토어 생성 + storefront 메타데이터 retrieve (대화형) |

---

> **등록 완료:** 13개 도메인 **85개 스킬** 전부 등록됨. 설치: `npx skills add forcedotcom/sf-skills`.
