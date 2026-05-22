---
tags: [devops, metadata-api, metadata-types, ch13, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 13 (Metadata Types)
created: 2026-05-22
aliases: [Metadata Types 개요, 메타데이터 타입 목록, Metadata API 타입 분류, Metadata Components and Types, 메타데이터 컴포넌트]
---

# Metadata Types — 개요 및 분류

> Salesforce Metadata API v67.0이 지원하는 300개 이상의 메타데이터 타입 전체 목록 및 그룹별 분류. 각 타입의 상세 필드 정의는 그룹별 서브페이지 참조.

---

## Ch13 핵심 개념

### 메타데이터 타입 vs 컴포넌트

- **메타데이터 타입(Metadata Type):** `ApexClass`, `CustomObject` 같은 템플릿/클래스. Metadata WSDL에서 `Metadata`를 extends하는 complexType.
- **컴포넌트(Component):** 특정 메타데이터 타입의 인스턴스. 예: `MyCustomObject__c`는 `CustomObject` 타입의 컴포넌트.

```xml
<!-- 메타데이터 타입의 WSDL 정의 방식 -->
<xsd:extension base="tns:Metadata">
<!-- CustomObject, BusinessProcess → Metadata 타입
     ActionOverride → Metadata 타입 아님 (Metadata를 extend하지 않음) -->
```

**주의 사항:**
- 메타데이터 타입 이름은 **대소문자 구분** (`apexclass` 대신 `ApexClass` 사용)
- 메타데이터 타입과 데이터 타입이 항상 1:1 대응하지 않음 (예: 종속 피클리스트는 별도 타입 없이 피클리스트 타입으로 접근)
- 기능 설정(AccountSettings 등)에는 와일드카드(`*`) 미적용. Settings 전체 검색 시에만 와일드카드 가능

### Field Data Types

각 컴포넌트 필드는 특정 필드 타입을 가진다. WSDL에서 정의된 다른 컴포넌트 타입이거나 `string`, `boolean`, `double` 같은 기본 데이터 타입.

### Enumeration Fields

일부 필드는 열거형(enumeration)으로, 피클리스트에 해당한다. 유효한 값이 제한된 집합으로 고정된다.

```xml
<!-- 열거형 WSDL 정의 예시 -->
<xsd:simpleType name="DashboardComponentFilter">
  <xsd:restriction base="xsd:string">
    <xsd:enumeration value="RowLabelAscending"/>
    <xsd:enumeration value="RowLabelDescending"/>
    <xsd:enumeration value="RowValueAscending"/>
    <xsd:enumeration value="RowValueDescending"/>
  </xsd:restriction>
</xsd:simpleType>
```

### Supported Calls

모든 메타데이터 타입은 기본적으로 다음 호출을 지원한다 (개별 타입에서 예외 명시):
- CRUD calls: `createMetadata()`, `deleteMetadata()` 등
- File-based calls: `deploy()`, `retrieve()`
- Utility calls: `listMetadata()`, `describeMetadata()`

---

## Metadata Type Limits (배포/검색 한도)

특정 타입은 개별 트랜잭션 및 일일 한도가 있다.

| 한도 유형 | 한도 |
|---|---|
| Individual Metadata Deploy | 50 |
| Daily Metadata Deploys | 100 |
| Individual Metadata Retrieve | 100 |
| Daily Metadata Retrievals | 200 |

한도 적용 타입:
- `AIAuthoringBundle`
- `AnalyticsDashboard`
- `AnalyticsVisualization`
- `AnalyticsWorkspace`

---

## Metadata Coverage Report

Metadata Coverage report에서 채널별(Metadata API, scratch org source tracking, unlocked packages, 2GP, classic managed packages 등) 지원 여부를 확인한다. 로그인 없이 열람 가능.

---

## Unsupported Metadata Types

일부 기능의 메타데이터 타입은 Metadata API에서 지원되지 않는다. 이 타입은 각 조직에서 수동으로 변경해야 한다. source tracking, packaging, change set에서도 미지원일 수 있다.

→ 전체 목록: [Salesforce Metadata Coverage](https://developer.salesforce.com/tools/forcemigrationtool/coveragereport)

---

## 전체 타입 목록 (알파벳순)

| 타입명 | 설명 요약 | 그룹 |
|---|---|---|
| AccountPlanObjMeasCalcDef | 계정 플랜 목표 측정 계산 정의 | Other |
| AccountRelationshipShareRule | 계정 관계 기반 공유 규칙 | Security & Access |
| AccountingFieldMapping | 회계 필드 매핑 (Data 360) | Integration & Platform |
| AccountingModelConfig | 회계 모델 설정 (Data 360) | Integration & Platform |
| ActionLinkGroupTemplate | 액션 링크 그룹 템플릿 (피드 버튼) | UI & Layout |
| ActionPlanTemplate | 액션 플랜 템플릿 | Automation |
| ActionableListDefinition | 실행 가능한 목록 데이터 소스 정의 | UI & Layout |
| AdvAccountForecastSet | 계정 예측 세트 (Account Forecasting) | Automation |
| AffinityScoreDefinition | 어피니티 점수 정의 (마케팅) | Einstein & Analytics |
| AIApplication | AI 애플리케이션 인스턴스 (Einstein Prediction Builder) | Einstein & Analytics |
| AIApplicationConfig | AI 애플리케이션 추가 예측 정보 | Einstein & Analytics |
| AiAuthoringBundle | AI 저작 번들 (Agentforce Agent Script 등) | Einstein & Analytics |
| AiEvaluationDefinition | 에이전트 평가 정의 | Einstein & Analytics |
| AIScoringModelDefinition | 머신러닝 점수 모델 정의 | Einstein & Analytics |
| AIUsecaseDefinition | 머신러닝 유스케이스 정의 | Einstein & Analytics |
| AnalyticsDashboard | Tableau Next 대시보드 | Einstein & Analytics |
| AnalyticSnapshot | 보고 스냅샷 (Reporting Snapshot) | Einstein & Analytics |
| AnalyticsVisualization | Tableau Next 시각화 | Einstein & Analytics |
| AnalyticsWorkspace | Tableau Next 작업공간 | Einstein & Analytics |
| AnimationRule | Path 사용자 애니메이션 표시 기준 | UI & Layout |
| AppFrameworkTemplateBundle | Data 360 및 Tableau Next 앱 프레임워크 템플릿 | Integration & Platform |
| ApexClass | Apex 클래스 | Apex & Code |
| ApexComponent | Visualforce 컴포넌트 | Apex & Code |
| ApexEmailNotifications | Apex 오류 이메일 알림 수신자 정의 | Apex & Code |
| ApexPage | Visualforce 페이지 | Apex & Code |
| ApexTestSuite | Apex 테스트 스위트 | Apex & Code |
| ApexTrigger | Apex 트리거 | Apex & Code |
| AppMenu | 앱 메뉴 / Salesforce 모바일 네비게이션 메뉴 (Reserved) | UI & Layout |
| AppointmentAssignmentPolicy | 자원 배정 규칙 (Lightning Scheduler) | Automation |
| AppointmentSchedulingPolicy | 예약 스케줄링 정책 | Automation |
| ApprovalProcess | 승인 프로세스 | Automation |
| ArticleType | 기사 타입 (Knowledge) | Objects & Fields |
| AssessmentQuestion | 평가 질문 컨테이너 | Objects & Fields |
| AssessmentQuestionSet | 평가 질문 세트 | Objects & Fields |
| AssignmentRules | 케이스/리드 배정 규칙 | Automation |
| Audience | Experience Builder 사이트 대상자 | UI & Layout |
| AuraDefinitionBundle | Aura 컴포넌트 번들 | Apex & Code |
| AuthProvider | OAuth 인증 공급자 | Security & Access |
| AutoResponseRules | 자동 응답 규칙 | Automation |
| BatchCalcJobDefinition | Data Processing Engine 정의 | Automation |
| BatchProcessJobDefinition | Batch Management 작업 정의 | Automation |
| BillingSettings | Salesforce Billing 설정 | Integration & Platform |
| BlacklistedConsumer | 차단된 연결 앱 | Security & Access |
| Bot | Einstein Bot 구성 정의 | Einstein & Analytics |
| BotBlock | Einstein Bot 블록 구성 | Einstein & Analytics |
| BotTemplate | Einstein Bot 템플릿 | Einstein & Analytics |
| BotVersion | Einstein Bot 버전 | Einstein & Analytics |
| BrandingSet | Experience Builder 사이트 브랜딩 속성 세트 | UI & Layout |
| BriefcaseDefinition | 브리프케이스 정의 (Field Service 오프라인) | Objects & Fields |
| BusinessProcessGroup | 고객 경험 설문 | Automation |
| CallCenter | CTI 시스템 연동 콜센터 정의 | Integration & Platform |
| CallCenterRoutingMap | 콜센터 라우팅 맵 | Integration & Platform |
| CallCoachingMediaProvider | Einstein Conversation Insights 음성 제공자 | Einstein & Analytics |
| CampaignInfluenceModel | 캠페인 영향 모델 | Automation |
| CareProviderSearchConfig | 케어 공급자 검색 설정 | Objects & Fields |
| CareRequestConfiguration | 케어 요청 구성 | Objects & Fields |
| CareBenefitVerifySettings | 보험 혜택 검증 설정 | Integration & Platform |
| CareLimitType | 혜택 한도 특성 정의 | Objects & Fields |
| CareSystemFieldMapping | 소스 시스템 필드 → Salesforce 필드 매핑 | Integration & Platform |
| CaseSubjectParticle | 소셜 게시물로 생성된 케이스 제목 형식 | Objects & Fields |
| CatalogedApi | API Catalog에 가져온 외부 API | Integration & Platform |
| CatalogedApiArtifactVersionInfo | API Catalog API 버전 정보 | Integration & Platform |
| CatalogedApiVersion | API Catalog 소비 가능 API 버전 | Integration & Platform |
| Certificate | 디지털 서명용 인증서 | Security & Access |
| ChatterExtension | Rich Publisher App (Chatter) | Integration & Platform |
| ChoiceList | 프리챗 드롭다운 | UI & Layout |
| ClaimFinancialSettings | 보험 청구 금융 서비스 설정 | Integration & Platform |
| ClauseCatgConfiguration | 조항 카테고리 설정 | Objects & Fields |
| CleanDataService | 표준 오브젝트 데이터 추가·업데이트 서비스 | Integration & Platform |
| CMSConnectSource | 외부 CMS 연결 정보 | Integration & Platform |
| Community (Zone) | Ideas/Chatter Answers 존 | UI & Layout |
| CommerceSettings | Commerce 기능 설정 | Integration & Platform |
| CommunityTemplateDefinition | Experience Builder 사이트 템플릿 정의 | UI & Layout |
| CommunityThemeDefinition | Experience Builder 사이트 테마 정의 | UI & Layout |
| ConnectedApp | 연결된 앱 구성 (OAuth/SAML/OpenID) | Security & Access |
| ContentAsset | Asset 파일 메타데이터 | Objects & Fields |
| ContentTypeBundle | 강화된 CMS 커스텀 콘텐츠 타입 정의 | UI & Layout |
| ContextDefinition | 컨텍스트 정의 (Context Service) | Integration & Platform |
| ConversationMessageDefinition | Enhanced Messaging / MIAW 메시징 컴포넌트 | Integration & Platform |
| ConversationMessageDefinitionTranslation | 메시징 컴포넌트 번역 | Integration & Platform |
| ConversationVendorInfo | 파트너 벤더 시스템 연결 (Service Cloud Voice 등) | Integration & Platform |
| ConvIntelligenceSignalRule | 대화 인텔리전스 신호 규칙 | Einstein & Analytics |
| CorsWhitelistOrigin | CORS 허용 목록 원본 | Security & Access |
| CspTrustedSite | CSP 신뢰 URL | Security & Access |
| CustomApplication | 커스텀/표준 앱 | UI & Layout |
| CustomApplicationComponent | 콘솔 커스텀 컴포넌트 (VF 페이지) | UI & Layout |
| CustomFeedFilter | 커스텀 피드 필터 | UI & Layout |
| CustomFieldDisplay | 제품 속성 커스텀 필드 뷰 타입 | Objects & Fields |
| CustomHelpMenuSection | Lightning Experience 도움말 메뉴 섹션 | UI & Layout |
| CustomIndex | 쿼리 속도 향상을 위한 인덱스 | Objects & Fields |
| CustomLabels | 다국어 커스텀 레이블 | Objects & Fields |
| Custom Metadata Types (CustomObject) | 커스텀 메타데이터 타입 | Objects & Fields |
| CustomNotificationType | 커스텀 알림 타입 | Automation |
| CustomObject | 커스텀 오브젝트 / 외부 오브젝트 | Objects & Fields |
| CustomObjectTranslation | 커스텀 오브젝트 번역 | Objects & Fields |
| CustomPageWebLink | 홈 페이지 컴포넌트 커스텀 링크 | UI & Layout |
| CustomPermission | 커스텀 기능 접근 권한 | Security & Access |
| CustomSite | Salesforce Sites (공개 웹사이트) | UI & Layout |
| CustomTab | 커스텀 탭 | UI & Layout |
| CustomValue | 글로벌 값 세트 / 로컬 피클리스트 값 | Objects & Fields |
| Dashboard | 대시보드 | Einstein & Analytics |
| DataCategoryGroup | 데이터 카테고리 그룹 | Objects & Fields |
| DataObjectSearchIndexConf | Data 360 DMO 검색 인덱스 설정 | Integration & Platform |
| DataWeaveResource | DataWeave 스크립트 리소스 | Apex & Code |
| DecisionTable | 의사결정 테이블 | Automation |
| DecisionTableDatasetLink | 의사결정 테이블 데이터셋 링크 | Automation |
| DecisionMatrixDefinition | 의사결정 매트릭스 정의 | Automation |
| DelegateGroup | 동일 관리 권한 사용자 그룹 | Security & Access |
| DgtAssetMgmtProvider | 외부 콘텐츠 공급자 (DAM 시스템) | Integration & Platform |
| DgtAssetMgmtPrvdLghtCpnt | DAM 시스템 LWC 설정 | Integration & Platform |
| DigitalExperienceBundle | 조직 작업공간 코드 구조 | UI & Layout |
| DigitalExperienceConfig | 조직 작업공간 세부 정보 | UI & Layout |
| DisclosureDefinition | 공개 타입 정보 | Objects & Fields |
| DisclosureDefinitionVersion | 공개 정의 버전 정보 | Objects & Fields |
| DisclosureType | 공개 타입 메타데이터 | Objects & Fields |
| DiscoveryAIModel | Einstein Discovery 모델 | Einstein & Analytics |
| DiscoveryGoal | Einstein Discovery 예측 정의 | Einstein & Analytics |
| DiscoveryStory | Einstein Discovery 스토리 | Einstein & Analytics |
| Document | Document 파일 | Objects & Fields |
| DocumentCategory | 문서 카테고리 | Objects & Fields |
| DocumentCategoryDocumentType | DocumentCategory-DocumentType 연결 | Objects & Fields |
| DocumentChecklistSettings | DocumentChecklistItem 설정 | Objects & Fields |
| DocumentType | 문서 타입 | Objects & Fields |
| DuplicateRule | 중복 레코드 감지 규칙 | Automation |
| EclairGeoData | Analytics 커스텀 지도 차트 | Einstein & Analytics |
| EmailServicesFunction | 이메일 서비스 | Automation |
| EmailTemplate | 이메일 템플릿 (1GP only) | Automation |
| EmbeddedServiceBranding | Embedded Service 배포 브랜딩 | UI & Layout |
| EmbeddedServiceConfig | Embedded Service for Web 설정 | Integration & Platform |
| EmbeddedServiceFieldService | Appointment Management 임베디드 배포 | Integration & Platform |
| EmbeddedServiceFlowConfig | 임베디드 플로우 배포 | Integration & Platform |
| EmbeddedServiceLiveAgent | 임베디드 Chat 배포 | Integration & Platform |
| EmbeddedServiceMenuSettings | Channel 메뉴 배포 | Integration & Platform |
| EnablementMeasureDefinition | Enablement 측정 정의 | Automation |
| EnablementProgramDefinition | Enablement 프로그램 정의 | Automation |
| EnblProgramTaskSubCategory | Enablement 커스텀 훈련 타입 | Automation |
| EntitlementProcess | 자격 프로세스 설정 | Automation |
| EntitlementTemplate | 자격 템플릿 | Automation |
| EscalationRules | 케이스 에스컬레이션 규칙 | Automation |
| EventDelivery | 이벤트 전달 매핑 (v46.0에서 삭제됨) | Integration & Platform |
| EventRelayConfig | 이벤트 릴레이 설정 (Amazon EventBridge) | Integration & Platform |
| EventSubscription | 이벤트 구독 (v46.0에서 삭제됨) | Integration & Platform |
| ExperienceBundle | Experience Builder 사이트 코드 구조 | UI & Layout |
| ExperiencePropertyTypeBundle | 속성 타입 (Spring '26에서 LightningPropertyType으로 대체) | UI & Layout |
| ExplainabilityMsgTemplate | 의사결정 설명 메시지 템플릿 | Einstein & Analytics |
| ExpressionSetDefinition | 표현식 세트 정의 | Automation |
| ExpressionSetMessageToken | 표현식 세트 메시지 토큰 | Automation |
| ExpressionSetObjectAlias | 표현식 세트 소스 오브젝트 별칭 | Automation |
| ExternalAuthIdentityProvider | 외부 인증 ID 공급자 | Security & Access |
| ExternalClientApplication | 외부 클라이언트 앱 헤더 파일 | Security & Access |
| ExternalCredential | Salesforce → 외부 시스템 인증 세부 정보 | Security & Access |
| ExternalAIModel | Einstein for Service 모델 상태 | Einstein & Analytics |
| ExternalServiceRegistration | 외부 서비스 설정 | Integration & Platform |
| ExtlClntAppCanvasSettings | 외부 클라이언트 앱 Canvas 설정 | Security & Access |
| ExtlClntAppConfigurablePolicies | 외부 클라이언트 앱 플러그인 정책 | Security & Access |
| ExtlClntAppGlobalOauthSettings | 외부 클라이언트 앱 전역 OAuth 설정 | Security & Access |
| ExtlClntAppMobileConfigurablePolicies | 외부 클라이언트 앱 모바일 정책 | Security & Access |
| ExtlClntAppMobileSettings | 외부 클라이언트 앱 모바일 설정 | Security & Access |
| ExtlClntAppNotificationSettings | 외부 클라이언트 앱 알림 구독 | Security & Access |
| ExtlClntAppOauthConfigurablePolicies | OAuth 외부 클라이언트 앱 정책 | Security & Access |
| ExtlClntAppOauthSettings | 외부 클라이언트 앱 OAuth 플러그인 설정 | Security & Access |
| ExtlClntAppPushConfigurablePolicies | 푸시 알림 정책 | Security & Access |
| ExtlClntAppPushSettings | 푸시 알림 설정 | Security & Access |
| ExtlClntAppSamlConfigurablePolicies | SAML SSO 정책 | Security & Access |
| FeatureParameterBoolean | 기능 파라미터 Boolean (FMA) | Integration & Platform |
| FeatureParameterDate | 기능 파라미터 Date (FMA) | Integration & Platform |
| FeatureParameterInteger | 기능 파라미터 Integer (FMA) | Integration & Platform |
| FieldMappingConfig | 소스→대상 필드 매핑 (v63.0+) | Objects & Fields |
| FieldRestrictionRule | 필드 가시성 제한 규칙 | Security & Access |
| FlexiPage | Lightning 페이지 (레코드·홈·앱 페이지) | UI & Layout |
| Flow | 플로우 (자동화·Screen Flow·Record-Triggered 등) | Automation |
| FlowCategory | 플로우 카테고리 (Lightning Bolt) | Automation |
| FlowDefinition | 플로우 정의 (설명·활성 버전) | Automation |
| FlowTest | 플로우 테스트 | Automation |
| FlowValueMap | Reserved for future use | Automation |
| Folder | 폴더 | Objects & Fields |
| ForecastingFilter | 예측 커스텀 필터 | Automation |
| ForecastingFilterCondition | 예측 필터 조건 | Automation |
| ForecastingSourceDefinition | 예측 소스 정의 | Automation |
| ForecastingType | 예측 타입 | Automation |
| ForecastingTypeSource | 예측 소스 타입 매핑 | Automation |
| FuelType | 커스텀 연료 타입 | Other |
| FuelTypeSustnUom | 연료 타입 ↔ UOM 매핑 | Other |
| FunctionReference | 배포된 Salesforce Function 참조 | Apex & Code |
| FundraisingConfig | Fundraising 설정 | Other |
| GatewayProviderPaymentMethodType | 결제 게이트웨이 공급자 결제 방법 타입 | Integration & Platform |
| GenAiFunction | AI 에이전트 액션 | Einstein & Analytics |
| GenAiPlanner | AI 에이전트 플래너 (LLM 주제·액션 컨테이너) | Einstein & Analytics |
| GenAiPlannerBundle | AI 에이전트 플래너 번들 | Einstein & Analytics |
| GenAiPlugin | AI 에이전트 주제 (Agent Topic) | Einstein & Analytics |
| GenAiPluginInstructionDef | 주제 지침 정의 | Einstein & Analytics |
| GenAiPromptTemplate | 프롬프트 템플릿 정의 | Einstein & Analytics |
| GenAiPromptTemplateActv | Salesforce 제공 프롬프트 템플릿 활성화 상태 | Einstein & Analytics |
| GiftEntryGridTemplate | Fundraising 선물 입력 그리드 템플릿 | Other |
| GlobalPicklist | 글로벌 피클리스트 | Objects & Fields |
| GlobalPicklistValue | 글로벌 피클리스트 값 | Objects & Fields |
| GlobalValueSet | 글로벌 값 세트 | Objects & Fields |
| GlobalValueSetTranslation | 글로벌 값 세트 번역 | Objects & Fields |
| GoogleAppsSettings | Google Apps 설정 | Integration & Platform |
| Group | 공개 그룹 | Security & Access |
| HomePageComponent | 홈 페이지 컴포넌트 | UI & Layout |
| HomePageLayout | 홈 페이지 레이아웃 | UI & Layout |
| IdentityVerificationProcDef | 신원 확인 프로세스 정의 | Security & Access |
| IdentityVerificationProcDtl | 신원 확인 검색·최소 검증 설정 | Security & Access |
| IdentityVerificationProcFld | 신원 확인 검색·검증 필드 | Security & Access |
| InboundCertificate | 상호 인증 인증서 | Security & Access |
| InboundNetworkConnection | 제3자 데이터 서비스 → Salesforce 인바운드 연결 | Integration & Platform |
| IndustriesPricingSettings | Salesforce Pricing 설정 | Integration & Platform |
| IndustriesRatingSettings | Rate Management 설정 | Integration & Platform |
| IndustriesUnifiedInventorySettings | Industries Unified Inventory 설정 | Integration & Platform |
| InsPlcyLimitConsumptionRule | 보험 정책 한도 소비 규칙 | Other |
| InstalledPackage | 1GP 관리 패키지 설치/제거 | Integration & Platform |
| IntegArtifactDef | Internal use only | Integration & Platform |
| IntegrationProviderDef | 서비스 프로세스 통합 정의 | Integration & Platform |
| IPAddressRange | IP 주소 범위 | Security & Access |
| InvocableActionExtension | 액션 입력 UI 표시 방법 설정 | Automation |
| KeywordList | Experience Cloud 사이트 키워드 목록 (모더레이션) | UI & Layout |
| Layout | 페이지 레이아웃 | UI & Layout |
| LearningItemType | Enablement 커스텀 훈련 타입 (사용자 Guidance Center) | Automation |
| Letterhead | 이메일 템플릿 레터헤드 | UI & Layout |
| LightningBolt | Lightning Bolt Solution 정의 | UI & Layout |
| LightningComponentBundle | Lightning Web Component 번들 | Apex & Code |
| LightningExperienceTheme | 커스텀 Lightning Experience 테마 | UI & Layout |
| LightningMessageChannel | Lightning Message Channel | Apex & Code |
| LightningOnboardingConfig | Salesforce Classic 전환 시 피드백 설정 | UI & Layout |
| LightningTypeBundle | 커스텀 Lightning 타입 번들 | Apex & Code |
| LiveChatAgentConfig | Chat 에이전트 설정 | Integration & Platform |
| LiveChatButton | Chat 버튼 설정 | Integration & Platform |
| LiveChatDeployment | Chat 배포 설정 | Integration & Platform |
| LiveChatSensitiveDataRule | 민감한 데이터 마스킹/삭제 규칙 | Security & Access |
| LoyaltyProgramSetup | 로열티 프로그램 프로세스 설정 | Automation |
| ManagedContentType | Salesforce CMS 커스텀 콘텐츠 타입 | UI & Layout |
| ManagedEventSubscription | Pub/Sub API 관리 이벤트 구독 (Beta) | Integration & Platform |
| ManagedTopics | Experience Cloud 사이트 네비게이션·추천 주제 | UI & Layout |
| MarketingAppExtension | 서드파티 마케팅 앱 연동 | Integration & Platform |
| MatchingRule | 중복 레코드 식별 매칭 규칙 | Automation |
| MessagingChannel | Embedded Service Messaging 채널 | Integration & Platform |
| Metadata | 모든 메타데이터 타입의 기본 클래스 (편집 불가) | Other |
| MetadataWithContent | 콘텐츠 포함 메타데이터 기본 타입 (편집 불가) | Other |
| MfgProgramTemplate | Manufacturing Program 정의 | Automation |
| MilestoneType | 자격 프로세스 마일스톤 | Automation |
| MlDomain | Einstein Intent Set | Einstein & Analytics |
| MLDataDefinition | 모델링 데이터 정의 | Einstein & Analytics |
| MLPredictionDefinition | 예측 정의 | Einstein & Analytics |
| MobileApplicationDetail | 모바일 연결 앱 패키징 속성 | Integration & Platform |
| MobileSecurityAssignment | 모바일 보안 정책 ↔ 프로파일 배정 | Security & Access |
| MobileSecurityPolicy | Salesforce 모바일 앱 보안 정책 | Security & Access |
| MobSecurityCertPinConfig | 모바일 보안 인증서 핀 설정 | Security & Access |
| ModerationRule | Experience Cloud 사이트 모더레이션 규칙 | Security & Access |
| MutingPermissionSet | 비활성화된 권한 세트 (PermissionSetGroup용) | Security & Access |
| MyDomainDiscoverableLogin | My Domain 로그인 페이지 Discovery 설정 | Security & Access |
| NamedCredential | Named Credential (외부 엔드포인트 + 인증) | Integration & Platform |
| NavigationMenu | Experience Builder 사이트 네비게이션 메뉴 | UI & Layout |
| Network | Experience Cloud 사이트 | UI & Layout |
| NetworkBranding | Experience Cloud 사이트 로그인 페이지 브랜딩 | UI & Layout |
| NotificationTypeConfig | 표준·커스텀 알림 타입 org 수준 설정 | Automation |
| OauthCustomScope | OAuth 커스텀 스코프 | Security & Access |
| OauthTokenExchangeHandler | OAuth 2.0 토큰 교환 핸들러 | Security & Access |
| OcrSampleDocument | OCR 샘플 문서 | Integration & Platform |
| OcrTemplate | Intelligent Form Reader 필드 매핑 | Integration & Platform |
| OmniSupervisorConfig | Omni-Channel 슈퍼바이저 설정 | Integration & Platform |
| OrchestrationPlanCtxMapping | Dynamic Revenue Orchestrator 컨텍스트 매핑 | Automation |
| OutboundNetworkConnection | Salesforce → 서드파티 아웃바운드 연결 | Integration & Platform |
| OnboardingDataObjectGroup | 온보딩 데이터 오브젝트 그룹 | Objects & Fields |
| Package | 검색/배포용 메타데이터 컴포넌트 패키지 정의 | Integration & Platform |
| ParticipantRole | 참가자 역할 정의 | Objects & Fields |
| PathAssistant | Path 레코드 | UI & Layout |
| PaymentGatewayProvider | 결제 게이트웨이 공급자 | Integration & Platform |
| PermissionSet | 권한 세트 | Security & Access |
| PermissionSetGroup | 권한 세트 그룹 | Security & Access |
| PermissionSetLicenseDefinition | 커스텀 권한 세트 라이선스 정의 (Developer Preview) | Security & Access |
| PersonAccountOwnerPowerUser | 대규모 포털 계정 소유 사용자 (v57.0+) | Security & Access |
| PipelineInspMetricConfig | Pipeline Inspection 예측 카테고리 지표 설정 | Automation |
| PlatformCachePartition | Platform Cache 파티션 | Integration & Platform |
| PlatformEventChannel | Platform Event 채널 | Integration & Platform |
| PlatformEventChannelMember | Change Data Capture 엔티티 선택 | Integration & Platform |
| PlatformEventMigration | 표준→고용량 플랫폼 이벤트 마이그레이션 설정 | Integration & Platform |
| PlatformEventSubscriberConfig | 플랫폼 이벤트 Apex 트리거 설정 | Integration & Platform |
| Portal | 파트너 포털 | UI & Layout |
| PortalDelegablePermissionSet | 외부 사용자/쇼퍼 위임 가능 권한 세트 | Security & Access |
| PostTemplate | Chatter 승인 게시물 템플릿 | Automation |
| ProductAttributeSet | 제품 속성 세트 | Objects & Fields |
| PresenceDeclineReason | Omni-Channel 거부 사유 | Integration & Platform |
| PresenceUserConfig | Omni-Channel 현재 상태 사용자 설정 | Integration & Platform |
| PricingActionParameters | 가격 책정 액션 파라미터 | Automation |
| PricingRecipe | 가격 책정 데이터 레시피 | Automation |
| Profile | 사용자 프로파일 | Security & Access |
| ProfileActionOverride | 프로파일별 ActionOverride 재정의 | Security & Access |
| ProfilePasswordPolicy | 프로파일 암호 정책 | Security & Access |
| ProfileSessionSetting | 프로파일 세션 설정 | Security & Access |
| Prompt | 인앱 가이던스 (프롬프트·워크스루) | UI & Layout |
| PublicKeyCertificate | 공개 키 인증서 | Security & Access |
| PublicKeyCertificateSet | 공개 키 인증서 세트 | Security & Access |
| Queue | 작업 대기열 | Automation |
| QueueRoutingConfig | 작업 라우팅 설정 | Automation |
| QuickAction | Quick Action (생성/업데이트 액션) | UI & Layout |
| RedirectWhitelistUrl | 리다이렉션 신뢰 URL | Security & Access |
| RecommendationStrategy | 추천 전략 | Einstein & Analytics |
| RecordActionDeployment | Actions & Recommendations 설정 | UI & Layout |
| RecordAggregationDefinition | 레코드 집계 정의 | Objects & Fields |
| RecordAlertCategory | 레코드 알림 카테고리 | Objects & Fields |
| RegisteredExternalService | 등록된 외부 서비스 | Integration & Platform |
| ReferencedDashboard | CRM Analytics 외부 참조 대시보드 | Einstein & Analytics |
| RelatedRecordAssocCriteria | 관련 레코드 자동 연결 기준 | Automation |
| RelationshipGraphDefinition | 오브젝트 계층 탐색 그래프 정의 | Objects & Fields |
| RemoteSiteSetting | 원격 사이트 설정 (Apex Callout / XHR 허용) | Integration & Platform |
| Report | 커스텀 리포트 | Einstein & Analytics |
| ReportType | 커스텀 리포트 타입 | Einstein & Analytics |
| RestrictionRule | 제한 규칙 / 범위 규칙 | Security & Access |
| RetrievalSummaryDefinition | 데이터 검색 패턴 설정 | Objects & Fields |
| Role | 사용자 역할 | Security & Access |
| RoleOrTerritory | 역할 또는 영역 공통 기반 타입 | Security & Access |
| RpaRobotPoolMetadata | Reserved for future use | Other |
| SalesWorkQueueSettings | Sales Engagement 작업 큐 설정 | Automation |
| SamlSsoConfig | SAML SSO 설정 | Security & Access |
| SchedulingObjective | Workforce Engagement 스케줄링 목표 | Automation |
| SchedulingRule | Workforce Engagement 스케줄링 규칙 | Automation |
| Scontrol | Deprecated. S-control 컴포넌트 | Other |
| SearchCustomization | Search Manager 검색 설정 | UI & Layout |
| SearchOrgWideObjectConfig | 검색 인덱스 오브젝트 | UI & Layout |
| ServiceAISetupDefinition | Einstein for Service 기능 설정 | Einstein & Analytics |
| ServiceAISetupField | Einstein 기사 추천용 케이스/Knowledge 필드 | Einstein & Analytics |
| ServiceChannel | Omni-Channel 작업 채널 | Integration & Platform |
| ServicePresenceStatus | Omni-Channel 현재 상태 | Integration & Platform |
| ServiceProcess | Service Process Studio 프로세스 | Automation |
| Settings | 조직 설정 (SecuritySettings 등) | Integration & Platform |
| SharedTo | 목록 뷰/폴더 공유 접근 정의 | Security & Access |
| SharingBaseRule | 공유 규칙 기본 설정 | Security & Access |
| SharingRules | 공유 규칙 (기준 기반·소유권 기반·영역 기반·게스트 액세스) | Security & Access |
| SharingSet | 포털/커뮤니티 사용자 공유 세트 | Security & Access |
| SiteDotCom | Sites 배포 | UI & Layout |
| Skill | Field Service / Chat 라우팅 스킬 | Integration & Platform |
| StandardValueSet | 표준 피클리스트 필드 값 세트 | Objects & Fields |
| StandardValueSetTranslation | 표준 피클리스트 번역 | Objects & Fields |
| StaticResource | 정적 리소스 파일 (ZIP/이미지/JS/CSS) | Apex & Code |
| StageAssignment | 레코드 스테이지 자동 배정 | Automation |
| StageDefinition | Stage Management 상태·전환 설정 | Automation |
| SustainabilityUom | 커스텀 연료 타입 UOM | Other |
| SustnUomConversion | UOM 변환 정보 | Other |
| SvcCatalogCategory | Service Catalog 카테고리 그룹 | UI & Layout |
| SvcCatalogFulfillmentFlow | Service Catalog 아이템 연결 플로우 | Automation |
| SvcCatalogItemDef | Service Catalog 개별 서비스 | Automation |
| SynonymDictionary | 검색 동의어 사전 | UI & Layout |
| Tag | Reserved for future use | Other |
| TagSet | Reserved for future use | Other |
| Territory | 영역(Territory) | Security & Access |
| Territory2 | Sales Territories 영역 메타데이터 | Security & Access |
| Territory2Model | Sales Territories 영역 모델 | Security & Access |
| Territory2Rule | Sales Territories 영역 배정 규칙 | Security & Access |
| Territory2Type | Sales Territories 영역 타입 | Security & Access |
| TimelineObjectDefinition | Timeline 구성 컨테이너 | Objects & Fields |
| TimeSheetTemplate | Field Service 타임시트 템플릿 | Automation |
| TopicsForObjects | 오브젝트 주제 배정/제거 | Objects & Fields |
| TransactionSecurityPolicy | 트랜잭션 보안 정책 | Security & Access |
| Translations | 다국어 번역 (Translation Workbench) | Objects & Fields |
| UIBundle | Salesforce Multi-Framework 앱 (React 등) (Beta) | UI & Layout |
| UiFormatSpecificationSet | Dynamic Forms 조건부 필드 서식 규칙 | UI & Layout |
| UIObjectRelationConfig | 오브젝트 관계 UI 컴포넌트 설정 | UI & Layout |
| UiPreviewMessageTabDef | Marketing Cloud Preview 커스텀 탭 등록 | UI & Layout |
| UserAccessPolicy | 사용자 접근 정책 | Security & Access |
| UserAuthCertificate | PEM 인코딩 사용자 인증서 | Security & Access |
| UserCriteria | Experience Cloud 사이트 모더레이션 멤버 기준 | Security & Access |
| UserProfileSearchScope | Internal use only | Other |
| UserProvisioningConfig | 사용자 프로비저닝 요청 플로우 정보 | Security & Access |
| VirtualVisitConfig | 외부 비디오 공급자 설정 | Integration & Platform |
| WaveAnalyticAssetCollection | Analytics 자산 컬렉션 | Einstein & Analytics |
| WaveApplication | Analytics 애플리케이션 | Einstein & Analytics |
| WaveComponent | Analytics 컴포넌트 | Einstein & Analytics |
| WaveDataflow | Analytics 데이터플로우 | Einstein & Analytics |
| WaveDashboard | Analytics 대시보드 | Einstein & Analytics |
| WaveDataset | Analytics 데이터셋 | Einstein & Analytics |
| WaveLens | Analytics Lens | Einstein & Analytics |
| WaveRecipe | Analytics 레시피 | Einstein & Analytics |
| WaveTemplateBundle | Analytics 템플릿 번들 | Einstein & Analytics |
| WaveXmd | Analytics XMD | Einstein & Analytics |
| WebStoreBundle | Internal use only | Integration & Platform |
| WebStoreTemplate | Commerce Store 생성 설정 | Integration & Platform |
| Workflow | 워크플로우 규칙 | Automation |
| WorkSkillRouting | Omni-Channel 스킬 라우팅 설정 | Integration & Platform |

---

## 그룹별 서브페이지

| 그룹 | 파일 |
|---|---|
| Apex & Code | → [[Metadata Types — Apex & Code]] |
| Objects & Fields | → [[Metadata Types — Objects & Fields]] |
| Automation | → [[Metadata Types — Automation]] |
| Security & Access | → [[Metadata Types — Security & Access]] |
| UI & Layout | → [[Metadata Types — UI & Layout]] |
| Integration & Platform | → [[Metadata Types — Integration & Platform]] |
| Einstein & Analytics | → [[Metadata Types — Einstein & Analytics]] |
| Other | → [[Metadata Types — Other]] |

---

## 관련 노트

- [[Metadata API 개요]] — Metadata API 전체 개념
- [[Metadata API File-Based 호출]] — package.xml에서 타입 이름 사용
- [[Metadata API Utility Calls]] — describeMetadata()로 타입 목록 조회
- [[Metadata API CRUD 호출]] — 개별 타입 CRUD
- [[Metadata API MCP Tool]] — AI 도구로 타입 컨텍스트 조회
