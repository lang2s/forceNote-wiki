---
tags: [index, search, navigation]
created: 2026-06-26
---

# SEARCH INDEX — 에이전트 스킬 (Agent Skills)
> 에이전트 스킬(SKILL.md 기반 단계별 안내 절차) 키워드 → 파일
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.

## SLDS 2 Starter Kit 스킬 → 파일

| 키워드 | 파일 |
|---|---|
| repo-setup, first-time-deploy, gh CLI 저장소 생성, GitHub Pages 설정, gh-pages 브랜치, gh api pages, 에이전트 스킬, agent skill SKILL.md, 저장소 백업 배포 스킬, gh로 깃허브 저장소 만들고 배포하는 법 | `AgentSkills(에이전트스킬)/SLDS 2 Starter Kit - 저장소 설정과 배포 스킬.md` |

---

## forcedotcom/sf-skills 라이브러리 → 파일

> 도메인별 카탈로그(브라우즈)는 `AgentSkills(에이전트스킬)/sf-skills/index.md`. 설치: `npx skills add forcedotcom/sf-skills`.

### Platform — Apex · Metadata · 선언적 빌드

| 키워드 | 파일 |
|---|---|
| platform-apex-generate, Apex 생성·리팩터링·리뷰, Apex 클래스 만들기, 서비스/셀렉터/배치/큐어블 작성, Apex authoring | `AgentSkills(에이전트스킬)/sf-skills/platform-apex-generate.md` |
| platform-apex-test-generate, Apex 테스트 생성, TestDataFactory, bulk 테스트, mocking, 테스트 클래스 만들기 | `AgentSkills(에이전트스킬)/sf-skills/platform-apex-test-generate.md` |
| platform-apex-test-run, Apex 테스트 실행, code coverage 분석, 실패 테스트 수정, test-fix 루프 | `AgentSkills(에이전트스킬)/sf-skills/platform-apex-test-run.md` |
| platform-apex-logs-debug, 디버그 로그 분석, governor limit 진단, stack trace 해석, Apex 로그 troubleshooting | `AgentSkills(에이전트스킬)/sf-skills/platform-apex-logs-debug.md` |
| platform-soql-query, SOQL 쿼리 생성·최적화, relationship/aggregate query, selectivity 분석, SOSL | `AgentSkills(에이전트스킬)/sf-skills/platform-soql-query.md` |
| platform-data-manage, 데이터 작업, sf data CLI, bulk import export, 테스트 데이터 생성, 레코드 정리 | `AgentSkills(에이전트스킬)/sf-skills/platform-data-manage.md` |
| platform-custom-object-generate, 커스텀 오브젝트 생성, CustomObject 메타데이터, sharingModel, object-meta.xml | `AgentSkills(에이전트스킬)/sf-skills/platform-custom-object-generate.md` |
| platform-custom-field-generate, 커스텀 필드 생성, Roll-Up Summary, Master-Detail, Lookup, formula field | `AgentSkills(에이전트스킬)/sf-skills/platform-custom-field-generate.md` |
| platform-custom-tab-generate, 커스텀 탭 생성, CustomTab, object/web/Visualforce tab | `AgentSkills(에이전트스킬)/sf-skills/platform-custom-tab-generate.md` |
| platform-custom-application-generate, 커스텀 Lightning App 생성, CustomApplication, navType, action override | `AgentSkills(에이전트스킬)/sf-skills/platform-custom-application-generate.md` |
| platform-flexipage-generate, Lightning 페이지 생성, FlexiPage, RecordPage/AppPage/HomePage 만들기 | `AgentSkills(에이전트스킬)/sf-skills/platform-flexipage-generate.md` |
| platform-list-view-generate, 리스트 뷰 생성, List View 메타데이터, filterScope, booleanFilterLogic | `AgentSkills(에이전트스킬)/sf-skills/platform-list-view-generate.md` |
| platform-validation-rule-generate, 검증 규칙 생성, ValidationRule, errorConditionFormula, 데이터 품질 강제 | `AgentSkills(에이전트스킬)/sf-skills/platform-validation-rule-generate.md` |
| platform-permission-set-generate, 권한 집합 생성, PermissionSet, FLS, objectPermissions, tabSettings | `AgentSkills(에이전트스킬)/sf-skills/platform-permission-set-generate.md` |
| platform-custom-lightning-type-generate, Custom Lightning Type 생성, CLT, JSON Schema, Einstein Agent action 입출력 스키마 | `AgentSkills(에이전트스킬)/sf-skills/platform-custom-lightning-type-generate.md` |
| platform-lightning-app-coordinate, Lightning 앱 전체 생성, end-to-end 앱 오케스트레이션, dependency 순서 빌드 | `AgentSkills(에이전트스킬)/sf-skills/platform-lightning-app-coordinate.md` |
| platform-metadata-deploy, 메타데이터 배포, sf project deploy, dry-run, CI/CD, deployment order | `AgentSkills(에이전트스킬)/sf-skills/platform-metadata-deploy.md` |
| platform-metadata-api-context-get, Metadata API 참조, 604 metadata types, meta.xml 작성 컨텍스트, wsdl_segment | `AgentSkills(에이전트스킬)/sf-skills/platform-metadata-api-context-get.md` |
| platform-docs-get, 공식 문서 검색, Salesforce docs retrieval, help/developer.salesforce.com 추출, 문서 grounding | `AgentSkills(에이전트스킬)/sf-skills/platform-docs-get.md` |
| platform-agentexchange-partner-offers-configure, 파트너 오퍼 org 설정, Transactable Marketplace partner offers, TransactableMarketplacePrivateOfferSettings, 마켓플레이스 org preference | `AgentSkills(에이전트스킬)/sf-skills/platform-agentexchange-partner-offers-configure.md` |
| platform-trust-archive-manage, Salesforce Archive 운영, Trusted Services Archive, ArchiveActivity, RTBF 잊힐 권리, archive 마스킹 unarchive | `AgentSkills(에이전트스킬)/sf-skills/platform-trust-archive-manage.md` |

### Experience — LWC · React UI Bundle

| 키워드 | 파일 |
|---|---|
| experience-lwc-generate, LWC 생성, Lightning Web Component, wire/Apex/GraphQL, SLDS2 dark mode, Jest, PICKLES | `AgentSkills(에이전트스킬)/sf-skills/experience-lwc-generate.md` |
| experience-ui-bundle-app-coordinate, React UI bundle 앱 전체 빌드, end-to-end UI bundle 오케스트레이션 | `AgentSkills(에이전트스킬)/sf-skills/experience-ui-bundle-app-coordinate.md` |
| experience-ui-bundle-metadata-generate, UI bundle 스캐폴딩, uibundle-meta.xml, ui-bundle.json, CSP Trusted Site | `AgentSkills(에이전트스킬)/sf-skills/experience-ui-bundle-metadata-generate.md` |
| experience-ui-bundle-features-generate, UI bundle 기능 설치, authentication/search feature, ui-bundle-features CLI | `AgentSkills(에이전트스킬)/sf-skills/experience-ui-bundle-features-generate.md` |
| experience-ui-bundle-salesforce-data-access, UI bundle 데이터 접근, sdk-data, uiapi GraphQL query mutation, REST | `AgentSkills(에이전트스킬)/sf-skills/experience-ui-bundle-salesforce-data-access.md` |
| experience-ui-bundle-frontend-generate, UI bundle UI 수정, 페이지/컴포넌트/레이아웃/스타일링, shadcn tailwind | `AgentSkills(에이전트스킬)/sf-skills/experience-ui-bundle-frontend-generate.md` |
| experience-ui-bundle-agentforce-client-generate, Agentforce 채팅 위젯 임베드, AgentforceConversationClient | `AgentSkills(에이전트스킬)/sf-skills/experience-ui-bundle-agentforce-client-generate.md` |
| experience-ui-bundle-file-upload-generate, UI bundle 파일 업로드 API, ContentVersion, 진행률 추적 onProgress | `AgentSkills(에이전트스킬)/sf-skills/experience-ui-bundle-file-upload-generate.md` |
| experience-ui-bundle-deploy, UI bundle 배포, post-deploy setup, GraphQL schema fetch codegen, permission set 할당 | `AgentSkills(에이전트스킬)/sf-skills/experience-ui-bundle-deploy.md` |
| experience-ui-bundle-site-generate, Digital Experience Site 생성, React UI bundle 외부 호스팅, Network CustomSite | `AgentSkills(에이전트스킬)/sf-skills/experience-ui-bundle-site-generate.md` |
| experience-ui-bundle-custom-app-generate, UI bundle용 Custom Application, App Launcher 등록, 내부 호스팅 | `AgentSkills(에이전트스킬)/sf-skills/experience-ui-bundle-custom-app-generate.md` |
| experience-cms-brand-apply, CMS 브랜드 적용, brand voice tone, 브랜드 가이드라인, sfdc_cms__brand | `AgentSkills(에이전트스킬)/sf-skills/experience-cms-brand-apply.md` |
| experience-content-media-search, CMS 미디어 검색, 이미지 로고 검색, Data 360 hybrid search, electronic media | `AgentSkills(에이전트스킬)/sf-skills/experience-content-media-search.md` |

### Agentforce — 에이전트

| 키워드 | 파일 |
|---|---|
| agentforce-generate, Agent Script, .agent 파일, AiAuthoringBundle, 에이전트 작성·배포, subagent | `AgentSkills(에이전트스킬)/sf-skills/agentforce-generate.md` |
| agentforce-test, Agentforce 테스트, ADLC Test, sf agent test, 테스트 spec YAML, AiEvaluationDefinition | `AgentSkills(에이전트스킬)/sf-skills/agentforce-test.md` |
| agentforce-observe, Agentforce 관측성, 프로덕션 에이전트 분석, STDM session 분석, Observe-Reproduce-Improve | `AgentSkills(에이전트스킬)/sf-skills/agentforce-observe.md` |
| agentforce-architecture-analyze, 에이전트 아키텍처 스냅샷, 선언적 아키텍처 분석, planner topic 인벤토리 | `AgentSkills(에이전트스킬)/sf-skills/agentforce-architecture-analyze.md` |
| agentforce-d360-analyze, Data Cloud 360 세션 뷰, 세션 트레이스 재구성, STDM GenAI DMO | `AgentSkills(에이전트스킬)/sf-skills/agentforce-d360-analyze.md` |

### Data 360 / Data Cloud

| 키워드 | 파일 |
|---|---|
| data360-orchestrate, Data Cloud 오케스트레이터, 데이터 스페이스, data kit, 다단계 파이프라인 조율 | `AgentSkills(에이전트스킬)/sf-skills/data360-orchestrate.md` |
| data360-connect, Data Cloud 소스 연결, connector, 커넥터, sf data360 connection | `AgentSkills(에이전트스킬)/sf-skills/data360-connect.md` |
| data360-prepare, Data Cloud Prepare, data stream, DLO, 데이터 스트림, ingestion, Document AI | `AgentSkills(에이전트스킬)/sf-skills/data360-prepare.md` |
| data360-harmonize, Data Cloud Harmonize, DMO, identity resolution, 통합 프로파일, data graph | `AgentSkills(에이전트스킬)/sf-skills/data360-harmonize.md` |
| data360-segment, Data Cloud Segment, calculated insight, 세그먼트, 오디언스, audience | `AgentSkills(에이전트스킬)/sf-skills/data360-segment.md` |
| data360-activate, Data Cloud Act, activation, activation target, data action, 다운스트림 전달 | `AgentSkills(에이전트스킬)/sf-skills/data360-activate.md` |
| data360-query, Data Cloud Retrieve, Data Cloud SQL, vector/hybrid search, 검색 인덱스, async query | `AgentSkills(에이전트스킬)/sf-skills/data360-query.md` |
| developing-datacloud-code-extension, 데이터클라우드 코드 익스텐션, Python transformation, datacustomcode, sf data-code-extension | `AgentSkills(에이전트스킬)/sf-skills/developing-datacloud-code-extension.md` |
| getting-datacloud-schema, 데이터클라우드 스키마 조회, DLO/DMO schema, SSOT REST API, 데이터레이크/데이터모델 객체 | `AgentSkills(에이전트스킬)/sf-skills/getting-datacloud-schema.md` |

### OmniStudio

| 키워드 | 파일 |
|---|---|
| omnistudio-omniscript-generate, OmniScript 생성, 가이드형 디지털 경험, OmniProcess, Type SubType Language | `AgentSkills(에이전트스킬)/sf-skills/omnistudio-omniscript-generate.md` |
| omnistudio-flexcard-generate, FlexCard 생성, OmniUiCard, DataSourceConfig, at-a-glance UI 카드 | `AgentSkills(에이전트스킬)/sf-skills/omnistudio-flexcard-generate.md` |
| omnistudio-integration-procedure-generate, Integration Procedure 생성, IP 오케스트레이션, server-side 다단계 | `AgentSkills(에이전트스킬)/sf-skills/omnistudio-integration-procedure-generate.md` |
| omnistudio-datamapper-generate, Data Mapper 생성, DataRaptor, Extract Transform Load Turbo, OmniDataTransform | `AgentSkills(에이전트스킬)/sf-skills/omnistudio-datamapper-generate.md` |
| omnistudio-dependencies-analyze, OmniStudio 의존성 분석, 네임스페이스 감지, 영향 분석, Mermaid 의존성 그래프 | `AgentSkills(에이전트스킬)/sf-skills/omnistudio-dependencies-analyze.md` |
| omnistudio-callable-apex-generate, Callable Apex 생성, System.Callable, VlocityOpenInterface 마이그레이션, Industries | `AgentSkills(에이전트스킬)/sf-skills/omnistudio-callable-apex-generate.md` |
| omnistudio-datapacks-deploy, OmniStudio DataPack 배포, Vlocity Build, packDeploy packRetry packExport, DataPack 마이그레이션 | `AgentSkills(에이전트스킬)/sf-skills/omnistudio-datapacks-deploy.md` |
| omnistudio-epc-catalog-generate, EPC 제품 카탈로그 생성, Product2 offer bundle, ProductChildItem, CME Enterprise Product Catalog | `AgentSkills(에이전트스킬)/sf-skills/omnistudio-epc-catalog-generate.md` |

### Integration — 커넥티비티 · 이벤팅

| 키워드 | 파일 |
|---|---|
| integration-connectivity-generate, 통합 런타임 구성, Named/External Credential, External Services, REST/SOAP callout, Platform Events, CDC | `AgentSkills(에이전트스킬)/sf-skills/integration-connectivity-generate.md` |
| integration-connectivity-connected-app-configure, 커넥티드 앱 OAuth 구성, Connected App, External Client App ECA, JWT Bearer, PKCE | `AgentSkills(에이전트스킬)/sf-skills/integration-connectivity-connected-app-configure.md` |
| integration-eventing-cdc-configure, CDC 활성화 구성, Change Data Capture, PlatformEventChannelMember, 변경 이벤트 필터 | `AgentSkills(에이전트스킬)/sf-skills/integration-eventing-cdc-configure.md` |
| integration-eventing-subscription-configure, 관리형 이벤트 구독, ManagedEventSubscription, event replay, Pub/Sub API | `AgentSkills(에이전트스킬)/sf-skills/integration-eventing-subscription-configure.md` |

### DevOps / Testing — DevOps Center

| 키워드 | 파일 |
|---|---|
| analyzing-test-failures, 테스트 실패 분석, Code Analyzer 위반 해석, 테스트 왜 실패했는지, 개선 제안 | `AgentSkills(에이전트스킬)/sf-skills/analyzing-test-failures.md` |
| automation-flow-generate, Flow 생성 스킬, Salesforce Flow 메타데이터 생성, execute_metadata_action, 3-step pipeline | `AgentSkills(에이전트스킬)/sf-skills/automation-flow-generate.md` |
| checking-devops-prerequisites, DevOps 사전조건 검증, DevOps Center prerequisites, org pipeline 검증, 공유 게이트 | `AgentSkills(에이전트스킬)/sf-skills/checking-devops-prerequisites.md` |
| configuring-quality-gate, quality gate 설정, 품질 게이트, coverage threshold, PASS_PERCENTAGE SEVERITY ESSENTIAL | `AgentSkills(에이전트스킬)/sf-skills/configuring-quality-gate.md` |
| configuring-test-provider, 테스트 프로바이더 설정, test provider 구성, Apex/Code Analyzer/Flow/Provar, Connect API | `AgentSkills(에이전트스킬)/sf-skills/configuring-test-provider.md` |
| creating-fix-work-item, fix work item 생성, 수정 작업 항목, WorkItem 추적, remediation task | `AgentSkills(에이전트스킬)/sf-skills/creating-fix-work-item.md` |
| managing-suite-assignments, 테스트 스위트 할당 관리, suite assignment, testSuiteStages, 파이프라인 스테이지 스위트 | `AgentSkills(에이전트스킬)/sf-skills/managing-suite-assignments.md` |
| polling-test-results, 테스트 결과 폴링, runId 폴링, DevopsTestExecution, async test polling | `AgentSkills(에이전트스킬)/sf-skills/polling-test-results.md` |
| recommending-devops-tests, 데브옵스 테스트 추천, commit diff suite recommendation, coverage gap | `AgentSkills(에이전트스킬)/sf-skills/recommending-devops-tests.md` |
| running-devops-test-suite, 데브옵스 테스트 스위트 실행, stage execute, quality gate 재실행 | `AgentSkills(에이전트스킬)/sf-skills/running-devops-test-suite.md` |
| syncing-test-providers, 테스트 프로바이더 재싱크, provider sync, DevopsPipelineTestProvider, 신규 스위트 끌어오기 | `AgentSkills(에이전트스킬)/sf-skills/syncing-test-providers.md` |

### Design Systems — SLDS

| 키워드 | 파일 |
|---|---|
| design-systems-slds-apply, SLDS 적용, SLDS blueprints, styling hooks, utility classes, 컴포넌트 빌드 | `AgentSkills(에이전트스킬)/sf-skills/design-systems-slds-apply.md` |
| design-systems-slds-validate, SLDS 품질 감사, SLDS scorecard, quality audit, 컴포넌트 점수, production-readiness | `AgentSkills(에이전트스킬)/sf-skills/design-systems-slds-validate.md` |
| design-systems-slds2-migrate, SLDS 2 마이그레이션, SLDS uplift, lwc-token-to-slds-hook, 스타일링 훅 교체 | `AgentSkills(에이전트스킬)/sf-skills/design-systems-slds2-migrate.md` |

### Diagram — 다이어그램

| 키워드 | 파일 |
|---|---|
| external-diagram-mermaid-generate, Mermaid 다이어그램 생성, 텍스트 다이어그램, ERD/sequence/flowchart, ASCII fallback | `AgentSkills(에이전트스킬)/sf-skills/external-diagram-mermaid-generate.md` |
| external-diagram-visual-generate, 비주얼 이미지 생성, Nano Banana Pro, PNG SVG mockup wireframe, 비주얼 ERD | `AgentSkills(에이전트스킬)/sf-skills/external-diagram-visual-generate.md` |

### Mobile — 네이티브 · 오프라인

| 키워드 | 파일 |
|---|---|
| mobile-apps-create, 세일즈포스 모바일 앱 생성, Salesforce mobile app, Mobile SDK, Agentforce SDK, iOS Android | `AgentSkills(에이전트스킬)/sf-skills/mobile-apps-create.md` |
| mobile-platform-native-capabilities-integrate, 모바일 네이티브 기능 통합, lightning/mobileCapabilities, 바코드 스캐너 생체인증 위치 NFC, LWC | `AgentSkills(에이전트스킬)/sf-skills/mobile-platform-native-capabilities-integrate.md` |
| mobile-platform-offline-validate, 모바일 오프라인 검증, Komaci 오프라인 분석, offline priming, lwc-graph-analyzer, inline GraphQL | `AgentSkills(에이전트스킬)/sf-skills/mobile-platform-offline-validate.md` |

### DX 툴링 — CLI · Code Analyzer · Analytics

| 키워드 | 파일 |
|---|---|
| dx-app-analytics-query, App Analytics 쿼리, AppAnalyticsQueryRequest, AppAnalyticsSettings, ISV 패키지 사용량 | `AgentSkills(에이전트스킬)/sf-skills/dx-app-analytics-query.md` |
| dx-code-analyzer-configure, 코드 애널라이저 구성, code-analyzer.yml, 엔진 활성화 비활성화, CI/CD 파이프라인 | `AgentSkills(에이전트스킬)/sf-skills/dx-code-analyzer-configure.md` |
| dx-code-analyzer-run, 코드 애널라이저 실행, sf code-analyzer run, 정적 분석 스캔, 위반 필터링, 자동 수정 | `AgentSkills(에이전트스킬)/sf-skills/dx-code-analyzer-run.md` |
| dx-org-switch, 기본 org 전환, target-org 변경, sf config set target-org, default org switch | `AgentSkills(에이전트스킬)/sf-skills/dx-org-switch.md` |

### Commerce — B2B

| 키워드 | 파일 |
|---|---|
| commerce-b2b-open-code-components-integrate, B2B 오픈코드 컴포넌트 통합, open source B2B commerce components, Experience Builder, sfdc_cms__lwc | `AgentSkills(에이전트스킬)/sf-skills/commerce-b2b-open-code-components-integrate.md` |
| commerce-b2b-store-create, B2B 커머스 스토어 생성, B2B Commerce Store, Storefront 메타데이터 retrieve, DigitalExperienceBundle | `AgentSkills(에이전트스킬)/sf-skills/commerce-b2b-store-create.md` |

---

## sf-mcp (Salesforce DX MCP Server)

> 공식 `salesforcecli/mcp`(`@salesforce/mcp`) 모노레포 — AI 에이전트가 Model Context Protocol로 Salesforce에 접근하는 MCP 서버. 카탈로그(브라우즈): `AgentSkills(에이전트스킬)/sf-mcp/index.md`.

| 키워드 | 파일 |
|---|---|
| sf-mcp 개요, Salesforce DX MCP Server, @salesforce/mcp, MCP 서버 모노레포, Model Context Protocol Salesforce, MCP 서버가 뭐야, MCP로 Salesforce 접근하는 법, provider 아키텍처 개요 | `AgentSkills(에이전트스킬)/sf-mcp/sf-mcp - 개요.md` |
| mcp, @salesforce/mcp 서버 패키지, MCP 서버 본체, MCP 서버 진입점 CLI, toolset 등록, provider 로딩, MCP 서버 어떻게 띄우나 | `AgentSkills(에이전트스킬)/sf-mcp/mcp.md` |
| mcp-provider-api, MCP Provider SDK, provider 작성 API, provider 추상 클래스 인터페이스, 툴 등록 계약, 커스텀 MCP provider 만드는 SDK | `AgentSkills(에이전트스킬)/sf-mcp/mcp-provider-api.md` |
| mcp-provider-dx-core, DX 코어 provider, deploy_metadata, run_soql_query, org 인증 메타데이터 배포 조회, MCP로 SOQL 실행하는 법, MCP 메타데이터 배포 도구 | `AgentSkills(에이전트스킬)/sf-mcp/mcp-provider-dx-core.md` |
| mcp-provider-code-analyzer, 코드 애널라이저 provider, run_code_analyzer, 정적 분석 도구, Apex 안티패턴 탐지, 규칙 위반 스캔, MCP로 코드 분석하는 법 | `AgentSkills(에이전트스킬)/sf-mcp/mcp-provider-code-analyzer.md` |
| mcp-provider-devops, DevOps provider, DevOps Center work item, 작업 항목 관리, 파이프라인 릴리즈 도구, MCP로 work item 다루는 법 | `AgentSkills(에이전트스킬)/sf-mcp/mcp-provider-devops.md` |
| mcp-provider-metadata-enrichment, 메타데이터 보강 provider, enrich_metadata, 메타데이터 컨텍스트 보강 도구, MCP 메타데이터 enrich | `AgentSkills(에이전트스킬)/sf-mcp/mcp-provider-metadata-enrichment.md` |
| mcp-provider-mobile-web, 모바일 웹 provider, mobile web 도구, MCP 모바일/웹 도구 노출 | `AgentSkills(에이전트스킬)/sf-mcp/mcp-provider-mobile-web.md` |
| mcp-provider-scale-products, Scale Products provider, 스케일 제품 도구, MCP Scale Products 도구 노출 | `AgentSkills(에이전트스킬)/sf-mcp/mcp-provider-scale-products.md` |
| sf-mcp 프로바이더 개발, provider 개발 가이드, example provider 작성, MCP Test Client, MCP provider 만들고 테스트하는 법, provider 검증 | `AgentSkills(에이전트스킬)/sf-mcp/sf-mcp - 프로바이더 개발 (Example + Test Client).md` |

---

## sf-skills 샘플 앱 (Reference Apps)

> `forcedotcom/sf-skills`의 `samples/` 폴더에 동기화된 5종 부동산/임대(property rental) 레퍼런스 앱. 카탈로그(브라우즈): `AgentSkills(에이전트스킬)/sf-skills-samples/index.md`.

| 키워드 | 파일 |
|---|---|
| sf-skills 샘플 앱 개요, property rental 레퍼런스 앱, 부동산 임대 샘플 앱, ui-bundle webapp native mobile, b2e b2x 변형, 에이전트 스킬이 만드는 앱 예시, 어떤 샘플 앱이 있나 | `AgentSkills(에이전트스킬)/sf-skills-samples/sf-skills 샘플 앱 - 개요.md` |
| sf-skills 샘플 앱 Apex 패턴, MaintenanceRequestTriggerHandler, TenantTriggerHandler, 트리거 핸들러 패턴, headless auth, 헤드리스 인증 REST, Site 기반 로그인 가입 비밀번호, 샘플 앱 Apex 코드 어떻게 생겼나 | `AgentSkills(에이전트스킬)/sf-skills-samples/sf-skills 샘플 앱 - Apex 패턴.md` |
| sf-skills 샘플 앱 데이터 모델, Property__c Tenant__c Lease__c, Maintenance_Request__c, 17개 커스텀 객체 127필드, 부동산 임대 스키마, 샘플 앱 커스텀 오브젝트 구조 | `AgentSkills(에이전트스킬)/sf-skills-samples/sf-skills 샘플 앱 - 데이터 모델.md` |
| sf-skills 샘플 앱 React UI GraphQL 패턴, UI Bundle React 구조, Vite React TypeScript SPA, ui-bundle frontend, Salesforce GraphQL Data SDK 데이터 접근, tsx 컴포넌트 구조, 샘플 앱 프론트엔드 어떻게 생겼나 | `AgentSkills(에이전트스킬)/sf-skills-samples/sf-skills 샘플 앱 - React UI·GraphQL 패턴.md` |
