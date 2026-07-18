---
tags: [index, devops, packaging, unlocked-package, managed-package-2gp]
created: 2026-07-18
---

# Packaging2GP(2세대패키징) — 로컬 인덱스

> 2세대 패키징 — Unlocked Package + 2GP Managed Package(개념·워크플로·컴포넌트 Manageability Rules·Develop/Install·Push Upgrade·LMA·FMA·App Analytics)

**상위:** [[DevOps(데브옵스)/index]]

---

## 파일 목록

### Unlocked Package

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Unlocked Package 패턴]] | sf package create/version create/install, 2GP, Org-Dependent, packageAliases | #pattern |
| [[Unlocked Package 개념과 준비]] | 패키지 개념·불변 버전·Org 역할·Org-Dependent 비교·사전 준비 체크리스트 전수 | #reference |
| [[Unlocked Package 생성과 설정]] | sf package create·sfdx-project.json 18개 파라미터·Keywords·Installation Key·Namespace·Profile Settings 전수 | #reference |
| [[Unlocked Package 개발과 버전]] | 버전 생성 3가지 옵션·버전 번호 가이드·코드 커버리지·브랜치·Hard-Delete 컴포넌트 전수 | #reference |
| [[Unlocked Package 릴리스와 설치]] | Push Upgrade·CLI/URL 설치·업그레이드 타입·의존성 스크립트·언인스톨·패키지 이전 전수 | #reference |

### 2GP Managed Package — 개념·워크플로

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[2GP Managed Package 개념과 1GP 비교]] | managed 2GP 개념·1GP 8가지 변화·Dev Hub/PBO/namespace org·권한 세트·Limited Access 라이선스·Unlocked와의 차이 | #reference |
| [[2GP Managed Package 개발 환경과 사전 준비]] | Limited Access User 추가·Know Your Orgs·namespace 생성과 Link to Dev Hub·Key Concepts·Manageability Rules·Package Ancestry·의존성 매트릭스 전수 | #reference |
| [[2GP Managed Package Scratch Org 워크플로]] | Develop(namespaced) vs Test(no-namespace)·ancestor seeding·Definition File vs Org Shape·Snapshot·Agentforce·Data Cloud scratch org·PBO 할당량·Partner edition 전수 | #reference |
| [[2GP Managed Package — Workflow]] | 2GP 표준 CLI 워크플로 10단계·sfdx-project.json 자동 업데이트·Manageability Rules 4속성·Editable Properties 3카테고리·Supported Components 전수 목록 | #reference |
| [[2GP — Develop]] | sf package create·sf package version create 3가지 옵션·MAJOR.MINOR.PATCH.BUILD·NEXT 키워드·Project Configuration File 파라미터 전수·Package Ancestor·beta→released 75% 커버리지·promote 전수 | #reference |
| [[2GP — Install · Uninstall]] | sf package install·uninstall·--publish-wait/--wait 타임아웃·Installation URL·InstallHandler·InstallContext·System.Version·PostInstallScript·의존성 설치 스크립트·Uninstall 제약사항 전수 | #reference |
| [[2GP — Prepare to Distribute]] | beta→released 승격 전 코드 커버리지 75%·Installation Key 설정·promote·Release Notes URL·postInstallUrl·AppExchange 파트너 콘솔 연결·패키지 등록·권장 버전 설정 전수 | #reference |
| [[2GP — Push Upgrade]] | ISV가 subscriber org에 강제 업그레이드를 Push하는 전 과정·CLI 명령·SOAP API·Customized Push Upgrade·Best Practices 전수 | #reference |
| [[2GP — Advanced Features Part 1]] | Package Ancestors·비선형 버전·Patch Version 제약·Dependencies·calculateTransitiveDependencies·Advanced sfdx-project.json 파라미터·Keywords·Target Release·Branches·Unpackaged Metadata 전수 | #reference |
| [[2GP — Advanced Features Part 2]] | Package IDs 4종(033/04t/0Ho/08c)·Namespace Collision 설치 조합 테이블·Remove Metadata Components·Delete Package·Frequently Used Operations·Transfer Dev Hub 전 과정·Partner Support 케이스 | #reference |
| [[2GP — Best Practices]] | Dev Hub owner 지정·--tag 옵션·Alias 생성·non-GA 컴포넌트 주의·LMA 기능별 접근 요약 | #reference |

### 2GP 컴포넌트 Manageability Rules (도메인별)

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[2GP — Components - Apex & Code]] | Apex Class·Trigger·Sharing Reason·Aura·LWC·Static Resource·Visualforce 컴포넌트·페이지 8종 Manageability Rules 4속성 전수·Editable Properties·패키징 고려사항·IP Protection | #reference |
| [[2GP — Components - Automation]] | Flow·Workflow·Decision Table·Expression Set·Batch·Business Process Group 등 자동화 컴포넌트 Manageability Rules 4속성 전수·IP Protection·2GP-only 제한 | #reference |
| [[2GP — Components - Einstein & Analytics]] | AffinityScoreDefinition·AIApplication·BotTemplate·Dashboard·DiscoveryAI·GenAiFunction·GenAiPlugin·GenAiPlannerBundle·GenAiPromptTemplate·RecommendationStrategy·Report·ReportType 등 Einstein·Analytics·Agentforce 도메인 Manageability Rules 4속성 전수 | #reference |
| [[2GP — Components - Integration & Platform]] | AppFrameworkTemplateBundle·ChatterExtension·ContextDefinition·EmbeddedServiceConfig·EventRelayConfig·ExternalDataSource·ExternalServiceRegistration·FeatureParameter 3종·NamedCredential·PlatformCachePartition·RemoteSiteSetting 21종 Manageability Rules 4속성 전수 | #reference |
| [[2GP — Components - Objects & Fields]] | AssessmentQuestion·CustomField·CustomIndex·CustomLabels·CustomMetadata·CustomObject·CustomPermission·FieldSet·GlobalValueSet·RelationshipGraphDefinition 등 오브젝트·필드 도메인 컴포넌트 Manageability Rules 4속성 전수 | #reference |
| [[2GP — Components - Security & Access]] | ConnectedApp·CorsWhitelistOrigin·CspTrustedSite·ExternalCredential·PermissionSet·PermissionSetGroup 10종 Manageability Rules 4속성 전수·Certificate 패키징 불가·Profile 2GP 미지원 상세·Permission Set vs Profile Settings 비교 | #reference |
| [[2GP — Components - UI & Layout]] | FlexiPage·CustomApplication·CustomTab·BrandingSet·DigitalExperienceBundle·LightningMessageChannel·Layout·CompactLayout·QuickAction·PathAssistant·Prompt 21종 UI 레이아웃 도메인 Manageability Rules 4속성 전수 | #reference |
| [[2GP — Components - Other]] | FuelType·EmailTemplate·Letterhead·Translation·ServiceCatalog·SlackApp·WebStoreTemplate·SustainabilityUom 등 Other 도메인 컴포넌트 Manageability Rules 4속성 전수 | #reference |

### 2GP Specific Behavior · LMA · Feature Management · App Analytics

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[2GP — Specific Metadata Behavior]] | Agentforce Agent Template 패키징·Data Cloud 패키지 요건·보호 컴포넌트·Platform Cache Provider Free 3MB·Metadata Access Apex·Permission Set vs Profile Settings 전수·IP 보호·@NamespaceAccessible·Connected App 패키징·New Order Save Behavior 대응 | #reference |
| [[2GP — Feature Management App]] | FMA 개요·Feature Parameters 3종·XML 예제·System.FeatureManagement API·Custom Objects 숨기기·Considerations | #reference |
| [[2GP — LMA Part 1 Get Started]] | LMA 설치·패키지 연결·권한 설정·Lead·License 레코드 관리·License Custom Object Fields 전수 | #reference |
| [[2GP — LMA Part 2 Troubleshoot]] | LMA 트러블슈팅·구독자 Org 로그인·ISV Customer Debugger·LMA 이전·모범 사례 | #reference |
| [[2GP — App Analytics Part 1 - Overview & Setup]] | AppExchange App Analytics 개요·활성화·Use Cases·제품 기능 매핑·CustomInteractions 구현 (LWC+Apex 전체 예제) | #reference |
| [[2GP — App Analytics Part 2 - Best Practices & Query Strategy]] | 데이터 흐름·FileType/FileCompression 조합·쿼리 자동화·Catch-Up Queries·AvailableSince·소/중/대 파트너 권장 전수 | #reference |
| [[2GP — App Analytics Part 3 - Data Types & Schemas]] | Package Usage Logs·Summaries·Subscriber Snapshots 전수 스키마·log_record_type 11종·custom_entity_type 전수·Simulation Mode | #reference |
| [[2GP — App Analytics Part 4 - Developer Cookbook]] | CRM Analytics 레시피(LMAJoin·DailyAggregation) 전수 단계·Daily/Weekly/Monthly Unique Users SAQL·Custom Object CRUD SAQL | #reference |
