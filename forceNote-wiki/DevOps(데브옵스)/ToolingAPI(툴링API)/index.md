---
tags: [index, devops, tooling-api]
created: 2026-06-27
---

# ToolingAPI — 로컬 인덱스

> Salesforce Tooling API v67.0 (Summer '26) — 개발 도구용 메타데이터에 SOQL·REST·SOAP로 세밀하게 접근하는 API 전체 레퍼런스

**상위:** [[DevOps(데브옵스)/index]] | [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Tooling API — 개요·REST·SOAP 호출 기초]] | When to Use·REST Overview·REST 리소스 12개·단위테스트 REST·Composite·API EOL·SOAP 호출 16개 | #overview #reference |
| [[Tooling API — Objects and Namespaces (객체 분류)]] | WSDL 네임스페이스 4종·네임스페이스 4분류(Programming/Setup/Tooling/Operational)·객체↔네임스페이스 매핑·System Fields·SOQL/SOSL 제약·ApiFault·Tooling API Faults | #reference #namespace #soql |
| [[Tooling API — SOAP·REST 헤더]] | SOAP 헤더 8개(AllOrNoneHeader·AllowFieldTruncationHeader·CallOptions·DebuggingHeader·DisableFeedTrackingHeader·MetadataWarningsHeader·PackageVersionHeader·SessionHeader)·REST 헤더 4개(Call Options·Limit Info·Package Version·Query Options)·debugLevel/LogCategory/LogCategoryLevel enum | #reference #soap #rest #header |
| [[Tooling API 객체 — Apex 코드·테스트·커버리지]] | Apex 코드·테스트·커버리지 객체 17개(ApexClass·ApexTrigger·ApexComponent·ApexPage·ApexPageInfo·ApexCodeCoverage·ApexCodeCoverageAggregate·ApexOrgWideCoverage·ApexTestQueueItem·ApexTestResult·ApexTestResultLimits·ApexTestRunResult·ApexTestSuite·TestSuiteMembership·ApexEmailNotification·ApexResult·SymbolTable) | #reference #apex #testing #coverage |
| [[Tooling API 객체 — Entity·Field·스키마]] | 스키마 객체 28개(EntityDefinition·EntityParticle·FieldDefinition·CustomField·CustomObject·CustomFieldDisplay·CustomFieldMember·DataType·RecordType·RelationshipDomain·RelationshipInfo·ObjectHierarchyRelationship·Index·IndexField·LookupFilter·FieldSet·FieldMapping·FormulaFunction·GlobalValueSet·EntityLimit·OwnerChangeOptionInfo·BusinessProcessDefinition·EnrichedField·ServiceFieldDataType(제거)) | #reference #schema #entity #field |
| [[Tooling API 객체 — 보안·권한]] | 보안·권한·접근통제 객체 38종(PermissionSet·PermissionSetAssignment·PermissionSetGroup·PermissionSetGroupComponent·PermissionSetTabSetting·PermissionDependency·Profile·ProfileLayout·NamedCredential·ExternalCredential·ExternalDataSource·ExternalDataSrcDescriptor·ExternalAuthIdentityProvider·ExternalClientAppSettings·ConnectedApplication·RemoteProxy·CspTrustedSite·Certificate·AuthorizedEmailDomain·RestrictionRule·FieldRestrictionRule·UserAccessPolicy·UserAccessPolicyAction·UserAccessPolicyFilter·UserEntityAccess·UserFieldAccess·SecurityHealthCheck·SecurityHealthCheckRisks·TransactionSecurityPolicy·IPAddressRange·InboundNetworkConnection·InboundNetworkConnProperty·OutboundNetworkConnection·OutboundNetworkConnProperty·DelegateGroup·DelegateGroupGrant·DelegateGroupMember·Group) | #reference #security #permissions |
| [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] | 선언적 자동화 sObject 19종(Flow·FlowDefinition·FlowTest·FlowTestResult·FlowTestCoverage·FlowElementTestCoverage·ProcessFlowMigration·BusinessProcess·WorkflowRule·WorkflowAlert·WorkflowFieldUpdate·WorkflowOutboundMessage·WorkflowTask·ValidationRule·AssignmentRule·AutoResponseRule·MatchingRule·DuplicateJobDefinition·DuplicateJobMatchingRuleDefinition) | #reference #automation #flow #workflow |
| [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]] | UI·레이아웃·페이지·액션 sObject 22종(AnimationRule·CompactLayout·CompactLayoutInfo·CustomApplication·CustomHelpMenuSection·CustomTab·FlexiPage·HomePageComponent·HomePageLayout·IconDefinition·Layout·PathAssistant·PathAssistantStepInfo·PathAssistantStepItem·QuickActionDefinition·QuickActionList·QuickActionListItem·RecordActionDeployment·RelatedListColumnDefinition·SearchLayout·TabDefinition·WebLink) | #reference #ui #layout #lightning-page |
| [[Tooling API 객체 — Lightning (Aura·LWC 번들)]] | Aura·LWC 컴포넌트 번들 sObject 5종(AuraDefinition(DefType 16값)·AuraDefinitionBundle·LightningComponentBundle·LightningComponentResource·LightningOutApp) | #reference #lightning #aura #lwc |
| [[Tooling API 객체 — 운영·라이프사이클 (Sandbox·배포·릴리즈)]] | org 운영·라이프사이클 sObject 18종(SandboxInfo·SandboxProcess·SandboxProcessStage·SourceMember·SourceMemberDeployRequest·DeployRequest·DeployDetails·PlatformEventMigration·ReleaseUpdate·ReleaseUpdateStep·HistoryRetentionJob·OperationLog·DomainProvision·OrgDomainLog·CustomHttpHeader·BusinessProcessFeedback·BusinessProcessGroup·BusProcessFeedbackConfig) | #reference #sandbox #deploy #release-update |
| [[Tooling API 객체 — 패키징·브랜딩 (1GP·2GP·정적콘텐츠)]] | 패키징·브랜딩·정적콘텐츠 sObject 20종(MetadataPackage·MetadataPackageVersion·InstalledSubscriberPackage·InstalledSubscriberPackageVersion·SubscriberPackage·SubscriberPackageVersion·SubscriberPackageVersionUninstallRequest·Package2·Package2Member·Package2Version·Package2VersionCreateRequest·Package2VersionCreateRequestError·PackageInstallRequest·PackageUploadRequest·PackageVersionUninstallRequestError·BrandingSet·BrandingSetProperty·ColorDefinition·StaticResource·Scontrol) | #reference #packaging #2gp #branding |
| [[Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널)]] | User·플랫폼이벤트·CDC 채널·이벤트 릴레이 Tooling sObject 7종 전수 — User identity·PlatformEventChannel(Member)·PlatformEventSubscriberConfig·EventRelayConfig(EventBridge) + 제거된 EventDelivery/EventSubscription(v46) | #reference #platform-event #cdc #user |
| [[Tooling API 객체 — Embedded Service (임베디드 챗·채널 메뉴·약속관리)]] | Embedded Service(스냅인) 배포 sObject 13종 전수 — 배포핵심(EmbeddedServiceConfig·Branding)·임베디드 챗(LiveAgent·QuickAction)·채널 메뉴(MenuSettings·MenuItem)·약속관리(FieldService)·Flow 임베딩(Flow·FlowConfig)·커스터마이즈(CustomComponent·CustomLabel·Customization·Resource) | #reference #embedded-service #snap-ins #channel-menu |
| [[Tooling API 객체 — Service·OmniChannel (라우팅·대화채널·서비스카탈로그·스케줄링)]] | Service Cloud/Omni-Channel setup sObject 25종 전수 — 라우팅·프레즌스·스킬 9(ServiceChannel·QueueRoutingConfig·PresenceUserConfig·OmniSupervisorConfig·WorkSkillRouting(+Attribute)·Skill·ServicePresenceStatus·PresenceDeclineReason)·대화/메시징 채널 6(ConversationChannelDefinition·ConversationVendorInfo·EngagementInsightType·ExtConvParticipantIntegDef·CustomMsgChannel·ContactCenterChannel)·서비스 카탈로그 5(SvcCatalogItemDef·SvcCatalogCategory·SvcCatalogCategoryItem·SvcCatalogFulfillmentFlow·SvcCatalogFulfillFlowItem)·스케줄링·워크포스 4(SchedulingObjective·SchedulingRule·ShiftSegmentType·TimeSheetTemplateAssignment)·가상 방문 1(VirtualVisitConfig) | #reference #omni-channel #routing #service-catalog #scheduling |
| [[Tooling API 객체 — 세일즈·예측·AI (포캐스팅·머신러닝·Einstein·Agentforce)]] | 세일즈·예측·AI/ML 도메인 sObject 25종 전수 — 세일즈·예측 14(AdvAccountForecastSet·AdvAcctFrcstDisplayGroup·AdvAcctForecastMeasureDef·ForecastingType·ForecastingTypeSource·ForecastingSourceDefinition·ForecastingFilter·ForecastingFilterCondition·ForecastingDisplayedFamily·AccountPlanObjMeasCalcCond·AccountPlanObjMeasCalcDef·OpportunitySplitType·PipelineInspMetricConfig·Territory2SupportedObject)·AI/ML/Agentforce 11(AIApplication·AIApplicationConfig·MLDataDefinition·MLField·MLFilter·MLPredictionDefinition·GenAiFunctionDefinition·GenAiPlannerDefinition·RecommendationStrategy·CleanDataService·InvocableActionExtension) | #reference #forecasting #sales #ai #machine-learning #einstein #agentforce |
| [[Tooling API 객체 — Experience·콘텐츠·커머스 (사이트·모더레이션·관리형콘텐츠·웹스토어)]] | Experience·콘텐츠·커머스 도메인 sObject 14종 전수(150필드) — ① Experience·모더레이션 6(ModerationRule·KeywordList·UserCriteria·CommunityWorkspacesNode·MenuItem·SiteDetail)·② 관리형콘텐츠·문서·템플릿 5(Document·EmailTemplate·ManagedContentType·ManagedContentNodeType·PostTemplate)·③ 커머스 2(WebStoreTemplate·ProductAttributeSet)·④ Field Service 1(BriefcaseDefinition). 공통 enum(Language 18값·ManageableState 8값) 블록 | #reference #experience-cloud #moderation #managed-content #commerce #email-template |

---

## 빠른 선택

- Tooling API가 뭔지, 언제 쓰는지? → [[Tooling API — 개요·REST·SOAP 호출 기초]]
- REST 리소스 URI·메서드 목록? → [[Tooling API — 개요·REST·SOAP 호출 기초]] → REST Resources
- 단위 테스트를 REST로 실행/조회? → [[Tooling API — 개요·REST·SOAP 호출 기초]] → REST Resources for Unit Testing
- SOAP 호출 목록? → [[Tooling API — 개요·REST·SOAP 호출 기초]] → SOAP Calls
- 네임스페이스 4분류·SOQL 제약·ApiFault가 필요하다 → [[Tooling API — Objects and Namespaces (객체 분류)]]
- SOAP/REST 호출에 세션·디버그·패키지 버전 헤더를 넣는 법, API 사용량 헤더? → [[Tooling API — SOAP·REST 헤더]]
- ApexClass·테스트 결과·코드 커버리지·SymbolTable이 필요하다 → [[Tooling API 객체 — Apex 코드·테스트·커버리지]]
- EntityDefinition·FieldDefinition·CustomField·스키마 메타데이터가 필요하다 → [[Tooling API 객체 — Entity·Field·스키마]]
- PermissionSet·Profile·NamedCredential·접근통제·보안 sObject가 필요하다 → [[Tooling API 객체 — 보안·권한]]
- Flow·Workflow·ValidationRule·자동화 sObject를 SOQL로 조회/배포? → [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]]
- FlexiPage·Layout·QuickAction·Path·WebLink·탭/앱 등 UI·레이아웃 sObject? → [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]]
- Aura/LWC 컴포넌트 번들(AuraDefinition·LightningComponentBundle 등)을 SOQL로 조회/배포? → [[Tooling API 객체 — Lightning (Aura·LWC 번들)]]
- Sandbox·메타데이터 배포·릴리즈 업데이트·소스 추적·My Domain 운영 sObject? → [[Tooling API 객체 — 운영·라이프사이클 (Sandbox·배포·릴리즈)]]
- 1GP/2GP 패키지·구독자 설치·브랜딩·StaticResource sObject? → [[Tooling API 객체 — 패키징·브랜딩 (1GP·2GP·정적콘텐츠)]]
- 플랫폼 이벤트 채널·CDC·이벤트 릴레이(EventBridge)·User Tooling sObject? → [[Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널)]]
- 임베디드 챗(채팅 위젯)·채널 메뉴·약속관리·Flow 임베딩 등 Embedded Service(스냅인) sObject? → [[Tooling API 객체 — Embedded Service (임베디드 챗·채널 메뉴·약속관리)]]
- 옴니채널 라우팅·프레즌스·스킬·대화/메시징 채널·서비스 카탈로그·스케줄링·가상 방문 sObject? → [[Tooling API 객체 — Service·OmniChannel (라우팅·대화채널·서비스카탈로그·스케줄링)]]
- 예측 유형·고급 계정 예측·어카운트 플랜·기회 분할·파이프라인 검사·테리토리 등 세일즈·예측 sObject? → [[Tooling API 객체 — 세일즈·예측·AI (포캐스팅·머신러닝·Einstein·Agentforce)]]
- Einstein 예측/추천·머신러닝 모델 정의(ML*)·Agentforce 액션/플래너(GenAi*)·데이터 정제 등 AI/ML sObject? → [[Tooling API 객체 — 세일즈·예측·AI (포캐스팅·머신러닝·Einstein·Agentforce)]]
- Experience Cloud 모더레이션(ModerationRule·KeywordList·UserCriteria)·사이트·관리형 콘텐츠·커머스 웹스토어 템플릿·이메일 템플릿·브리프케이스 sObject? → [[Tooling API 객체 — Experience·콘텐츠·커머스 (사이트·모더레이션·관리형콘텐츠·웹스토어)]]
- 컨테이너 기반 Apex 배포? → [[Tooling API 배포]]
- TraceFlag·ApexLog·체크포인트 등 디버그/로그? → [[Tooling API 디버그·로그·리플레이 sObject]]

---

## 관련 폴더

- 메타데이터 타입(declarative) 카탈로그 → [[DevOps(데브옵스)/MetadataAPI(메타데이터API)/index|MetadataAPI]]
- 배포 경로 비교 → [[Apex 배포 방법]]
