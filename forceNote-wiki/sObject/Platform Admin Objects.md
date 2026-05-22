---
tags: [sobject-reference, standard-objects, platform-admin, user, permission-set, profile, record-type, flow, setup]
source: object_reference.pdf (v67.0 Summer '26)
created: 2026-05-22
aliases: [Platform Admin Objects, User, PermissionSet, Profile, RecordType, FlowRecord, Group, Organization, SetupAuditTrail]
---

# Platform Admin Objects — 플랫폼·Admin·보안 오브젝트

> Object Reference v67.0 Ch6 — Salesforce 플랫폼 관리·보안·Apex/Dev 메타데이터 도메인 오브젝트 목록

---

## User·역할 계열

| Object | 설명 |
|---|---|
| `User` | Salesforce 사용자 |
| `UserRole` | 역할 계층 |
| `Group` | Public Group / Queue |
| `GroupMember` | Group 멤버 |
| `QueueSobject` | Queue에 연결된 Object 타입 |
| `Organization` | Org 설정 정보 |
| `OutOfOffice` | 자리 비움 상태 |
| `DelegatedAccount` | 위임된 계정 |
| `Name` | 사람·그룹 등 이름 검색 가상 뷰 |

---

## Profile · Permission 계열

| Object | 설명 |
|---|---|
| `Profile` | 프로필 |
| `PermissionSet` | 권한 집합 |
| `PermissionSetAssignment` | 권한 집합 배정 |
| `PermissionSetGroup` | 권한 집합 그룹 |
| `PermissionSetGroupComponent` | 권한 집합 그룹 컴포넌트 |
| `PermissionSetLicense` | 권한 집합 라이선스 |
| `PermissionSetLicenseAssign` | 권한 집합 라이선스 배정 |
| `PermissionSetLicenseDefinition` | 권한 집합 라이선스 정의 (Developer Preview) |
| `PermissionSetTabSetting` | 권한 집합 탭 설정 |
| `CustomPermission` | 커스텀 권한 |
| `CustomPermissionDependency` | 커스텀 권한 의존성 |
| `MutingPermissionSet` | 음소거 권한 집합 |
| `SessionPermSetActivation` | 세션 권한 집합 활성화 |
| `ObjectPermissions` | Object CRUD 권한 |
| `FieldPermissions` | 필드 수준 보안 권한 |
| `SetupEntityAccess` | 권한 기반 Setup 엔티티 접근 |
| `PortalDelegablePermissionSet` | Portal 위임 가능 권한 집합 |
| `FieldSecurityClassification` | 필드 보안 분류 |
| `LicenseDefinitionCustomPermission` | 라이선스 정의 커스텀 권한 (Developer Preview) |

---

## Auth·Session·Login 보안

| Object | 설명 |
|---|---|
| `AuthConfig` | 인증 설정 |
| `AuthConfigProviders` | 인증 공급자 설정 |
| `AuthProvider` | 소셜 인증 공급자 |
| `AuthProvParamFwdAllowlist` | 인증 공급자 파라미터 포워딩 허용 목록 |
| `AuthSession` | 현재 세션 정보 |
| `LoginHistory` | 로그인 이력 |
| `LoginIp` | 로그인 IP |
| `LoginGeo` | 로그인 지리 정보 |
| `LoginEvent` | 로그인 이벤트 |
| `LogoutEventStream` | 로그아웃 이벤트 스트림 |
| `SamlSsoConfig` | SAML SSO 설정 |
| `OauthCustomScope` | OAuth 커스텀 스코프 |
| `OauthCustomScopeApp` | OAuth 커스텀 스코프 앱 |
| `OauthToken` | OAuth 토큰 |
| `OauthTokenExchangeHandler` | OAuth 토큰 교환 핸들러 |
| `OauthTokenExchHandlerApp` | OAuth 토큰 교환 핸들러 앱 |
| `ConnectedApplication` | Connected App |
| `ExternalClientApplication` | 외부 클라이언트 앱 |
| `ExtlClntAppOauthPlcyCnfg` | 외부 클라이언트 앱 OAuth 정책 설정 |
| `ExtlClntAppOauthSettings` | 외부 클라이언트 앱 OAuth 설정 |
| `ExtlClntAppPlcyCnfg` | 외부 클라이언트 앱 정책 설정 |
| `MyDomainDiscoverableLogin` | My Domain 검색 가능 로그인 |
| `NetworkDiscoverableLogin` | Network 검색 가능 로그인 |
| `DataEncryptionKey` | 데이터 암호화 키 |
| `ExternalEncryptionRootKey` | 외부 암호화 루트 키 |
| `TenantSecret` | Tenant Secret (Shield Platform Encryption) |
| `SecurityCustomBaseline` | 보안 커스텀 기준선 |

---

## RecordType · Assignment · Business Process

| Object | 설명 |
|---|---|
| `RecordType` | 레코드 타입 |
| `RecordTypeLocalization` | 레코드 타입 현지화 |
| `BusinessProcess` | 비즈니스 프로세스 (Stage 값 서브셋) |
| `BusinessProcessDefinition` | 비즈니스 프로세스 정의 |
| `BusinessProcessFeedback` | 비즈니스 프로세스 피드백 |
| `BusinessProcessGroup` | 비즈니스 프로세스 그룹 |
| `AssignmentRule` | 케이스/Lead 배정 규칙 |
| `DuplicateRule` | 중복 규칙 |
| `DuplicateJob` | 중복 작업 |
| `DuplicateJobDefinition` | 중복 작업 정의 |
| `DuplicateJobMatchingRule` | 중복 작업 매칭 규칙 |
| `DuplicateJobMatchingRuleDefinition` | 중복 작업 매칭 규칙 정의 |
| `DuplicateRecordItem` | 중복 레코드 항목 |
| `DuplicateRecordSet` | 중복 레코드 집합 |
| `MatchingRule` | 매칭 규칙 |
| `MatchingRuleItem` | 매칭 규칙 항목 |

---

## Apex · Dev · Metadata

| Object | 설명 |
|---|---|
| `ApexClass` | Apex 클래스 메타데이터 |
| `ApexTrigger` | Apex 트리거 메타데이터 |
| `ApexPage` | Visualforce 페이지 |
| `ApexPageInfo` | Visualforce 페이지 정보 |
| `ApexComponent` | Visualforce 컴포넌트 |
| `ApexEmailNotification` | Apex 이메일 알림 설정 |
| `ApexLog` | Apex 디버그 로그 |
| `ApexTestQueueItem` | Apex 테스트 큐 아이템 |
| `ApexTestResult` | Apex 테스트 결과 |
| `ApexTestResultLimits` | 테스트 결과 거버너 한도 |
| `ApexTestRunResult` | 테스트 실행 결과 |
| `ApexTestSuite` | 테스트 스위트 |
| `ApexTypeImplementor` | Apex 인터페이스 구현체 목록 |
| `AsyncApexJob` | 비동기 Apex 작업 |
| `BatchApexErrorEvent` | Batch 오류 이벤트 (Platform Event) |
| `FlexQueueItem` | Flex Queue 작업 항목 |
| `StaticResource` | 정적 리소스 |
| `AuraDefinition` | Aura 컴포넌트 정의 |
| `AuraDefinitionBundle` | Aura 컴포넌트 번들 |
| `AuraDefinitionBundleInfo` | Aura 번들 정보 |
| `AuraDefinitionInfo` | Aura 정의 정보 |
| `FlexiPage` | Lightning 페이지 |
| `DataWeaveResource` | DataWeave 리소스 |
| `NamespaceRegistry` | 네임스페이스 레지스트리 |

---

## Flow · Process 자동화

| Object | 설명 |
|---|---|
| `FlowRecord` | Flow 레코드 (Flow Definition) |
| `FlowRecordElement` | Flow 레코드 요소 |
| `FlowRecordElementOccurrence` | Flow 레코드 요소 발생 |
| `FlowRecordRelation` | Flow 레코드 관계 |
| `FlowRecordVersion` | Flow 레코드 버전 |
| `FlowRecordVersionOccurrence` | Flow 레코드 버전 발생 |
| `FlowDefinitionView` | Flow 정의 뷰 |
| `FlowInterview` | Flow 인터뷰 (실행 중 Screen Flow 상태) |
| `FlowInterviewLog` | Flow 인터뷰 로그 |
| `FlowInterviewLogEntry` | Flow 인터뷰 로그 항목 |
| `FlowInterviewLogOwnerSharingRule` | Flow 인터뷰 로그 소유자 공유 규칙 |
| `FlowInterviewOwnerSharingRule` | Flow 인터뷰 소유자 공유 규칙 |
| `FlowInterviewShare` | Flow 인터뷰 공유 |
| `FlowOrchestration` | Flow Orchestration 정의 |
| `FlowOrchestrationInstance` | Flow Orchestration 인스턴스 |
| `FlowOrchestrationLog` | Flow Orchestration 로그 |
| `FlowOrchestrationStageInstance` | Flow Orchestration Stage 인스턴스 |
| `FlowOrchestrationStepInstance` | Flow Orchestration Step 인스턴스 |
| `FlowOrchestrationVersion` | Flow Orchestration 버전 |
| `FlowOrchestrationWorkItem` | Flow Orchestration 작업 항목 |
| `FlowStageRelation` | Flow Stage 관계 |
| `FlowTestResult` | Flow 테스트 결과 |
| `FlowTestView` | Flow 테스트 뷰 |
| `FlowVariableView` | Flow 변수 뷰 |
| `FlowVersionView` | Flow 버전 뷰 |
| `ProcessDefinition` | 승인 프로세스 정의 |
| `ProcessException` | 프로세스 예외 |
| `ProcessFlowMigration` | 프로세스 Flow 마이그레이션 |
| `ProcessInstance` | 프로세스 인스턴스 |
| `ProcessInstanceHistory` | 프로세스 인스턴스 이력 |
| `ProcessInstanceNode` | 프로세스 인스턴스 노드 |
| `ProcessInstanceStep` | 프로세스 인스턴스 단계 |
| `ProcessInstanceWorkitem` | 프로세스 인스턴스 작업 항목 |
| `ProcessNode` | 프로세스 노드 |
| `ActionLinkGroupTemplate` | 액션 링크 그룹 템플릿 |
| `ActionLinkTemplate` | 액션 링크 템플릿 |
| `ActionPlan` | 액션 플랜 |
| `ActionPlanItem` | 액션 플랜 항목 |
| `ActionPlanTemplate` | 액션 플랜 템플릿 |
| `ActionPlanTemplateItem` | 액션 플랜 템플릿 항목 |
| `ActionPlanTemplateItemValue` | 액션 플랜 템플릿 항목 값 |
| `ActionPlanTemplateVersion` | 액션 플랜 템플릿 버전 |

---

## Approval(승인) 계열

| Object | 설명 |
|---|---|
| `Approval` | 승인 |
| `ApprovalAlertContentDef` | 승인 알림 콘텐츠 정의 |
| `ApprovalSubmission` | 승인 제출 |
| `ApprovalSubmissionDetail` | 승인 제출 상세 |
| `ApprovalWorkItem` | 승인 작업 항목 |
| `ApprovalWorkItemCondition` | 승인 작업 항목 조건 |
| `ApprovalWorkItemCriteria` | 승인 작업 항목 기준 |

---

## Setup · Org·Admin 설정

| Object | 설명 |
|---|---|
| `SetupAuditTrail` | Setup 변경 감사 추적 |
| `SetupAssistantStep` | Setup 보조 단계 |
| `OrgWideEmailAddress` | Org 전체 이메일 주소 |
| `OrgEmailAddressSecurity` | Org 이메일 주소 보안 |
| `OrgMetric` | Org 지표 |
| `OrgMetricScanResult` | Org 지표 스캔 결과 |
| `OrgMetricScanSummary` | Org 지표 스캔 요약 |
| `OrgSnapshot` | Org 스냅샷 |
| `OrgDeleteRequest` | Org 삭제 요청 |
| `WorkflowRule` | 워크플로우 규칙 (구형) |
| `AutomatedAction` | 자동화된 액션 |
| `AutomatedActionCondition` | 자동화된 액션 조건 |
| `AutomatedActionOverride` | 자동화된 액션 재정의 |
| `AutomatedActionParameter` | 자동화된 액션 매개변수 |
| `AutomatedActionReminder` | 자동화된 액션 알림 |
| `RecordAction` | 레코드 액션 |
| `RecordActionHistory` | 레코드 액션 이력 |
| `RecordsetFilterCriteria` | 레코드 집합 필터 조건 |
| `RecordsetFilterCriteriaRule` | 레코드 집합 필터 조건 규칙 |
| `RecordsetFltrCritMonitor` | 레코드 집합 필터 조건 모니터 |
| `RecordVisibility` | 레코드 가시성 (Pilot) |
| `BusinessAlert` | 비즈니스 알림 |
| `BusinessAlertStatus` | 비즈니스 알림 상태 |

---

## License · Metric 계열

| Object | 설명 |
|---|---|
| `ActiveFeatureLicenseMetric` | 기능 라이선스 사용 현황 |
| `ActivePermSetLicenseMetric` | 권한 집합 라이선스 사용 현황 |
| `ActiveProfileMetric` | 프로필 사용 현황 |
| `PackageLicense` | 패키지 라이선스 |
| `PackagePushError` | 패키지 푸시 오류 |
| `PackagePushJob` | 패키지 푸시 작업 |
| `PackagePushRequest` | 패키지 푸시 요청 |
| `PackageSubscriber` | 패키지 구독자 |
| `MetadataPackage` | 메타데이터 패키지 |
| `MetadataPackageVersion` | 메타데이터 패키지 버전 |
| `AppDefinition` | 앱 정의 |
| `AppExtension` | 앱 확장 |
| `AppMenuItem` | 앱 메뉴 항목 |
| `AppTabMember` | 앱 탭 멤버 |
| `AppUsageAssignment` | 앱 사용 배정 |
| `AppAnalyticsQueryRequest` | 앱 분석 쿼리 요청 |
| `ActiveScratchOrg` | 활성 Scratch Org |
| `ScratchOrgInfo` | Scratch Org 정보 |
| `SignupRequest` | Signup 요청 |
| `EnvironmentHubMember` | Environment Hub 멤버 |

---

## Scratch Org · DevOps

| Object | 설명 |
|---|---|
| `ActiveScratchOrg` | 활성 Scratch Org |
| `ScratchOrgInfo` | Scratch Org 정보 |
| `OrgSnapshot` | Org 스냅샷 |
| `DataKitDeployEvent` | Data Kit 배포 이벤트 |
| `DataKitDeploymentLog` | Data Kit 배포 로그 |
| `FunctionConnection` | Function 연결 (Salesforce Functions) |
| `FunctionInvocationRequest` | Function 호출 요청 |
| `FunctionReference` | Function 참조 |

---

## Branding · UI

| Object | 설명 |
|---|---|
| `BrandingSet` | 브랜딩 집합 |
| `BrandTemplate` | 브랜드 이메일 템플릿 |
| `CustomBrand` | 커스텀 브랜드 |
| `CustomBrandAsset` | 커스텀 브랜드 에셋 |
| `LightningExperienceTheme` | Lightning Experience 테마 |
| `LightningOnboardingConfig` | Lightning 온보딩 설정 |
| `ColorDefinition` | 색상 정의 |
| `IconDefinition` | 아이콘 정의 |
| `Image` | 이미지 Object |
| `EnhancedLetterhead` | 향상된 레터헤드 |

---

## PlatformAction · Notification · Custom

| Object | 설명 |
|---|---|
| `PlatformAction` | 플랫폼 액션 (Quick Action, Flow 등 포함) |
| `PlatformEventUsageMetric` | Platform Event 사용량 지표 |
| `PlatformStatusAlertEvent` | Salesforce 서비스 상태 알림 이벤트 |
| `CustomNotificationType` | 커스텀 알림 타입 |
| `CustomFieldDisplayValue` | 커스텀 필드 표시 값 |
| `CustomHelpMenuItem` | 커스텀 도움말 메뉴 항목 |
| `CustomHelpMenuSection` | 커스텀 도움말 메뉴 섹션 |
| `CustomHttpHeader` | 커스텀 HTTP 헤더 |
| `CustomMsgChannel` | 커스텀 메시징 채널 |
| `PicklistValueInfo` | 피클리스트 값 정보 |
| `ContextParamMap` | 컨텍스트 파라미터 맵 |
| `FormulaFunction` | 수식 함수 |
| `FormulaFunctionAllowedType` | 수식 함수 허용 타입 |
| `FormulaFunctionCategory` | 수식 함수 카테고리 |
| `StreamingChannel` | Streaming Channel (CometD) |
| `PushTopic` | PushTopic (Streaming API) |
| `EventBusSubscriber` | Event Bus 구독자 |
| `EventRelayConfig` | Event Relay 설정 |
| `EventRelayFeedback` | Event Relay 피드백 |
| `BackgroundOperation` | 백그라운드 작업 |
| `BackgroundOperationResult` | 백그라운드 작업 결과 |

---

## SOQL 패턴

```apex
// User + PermissionSetAssignment 조회
List<User> users = [
    SELECT Id, Name, Email, Profile.Name, IsActive,
           (SELECT PermissionSetId, PermissionSet.Label
            FROM PermissionSetAssignments
            WHERE PermissionSet.IsOwnedByProfile = false)
    FROM User
    WHERE IsActive = true
    AND Profile.Name LIKE '%Admin%'
    WITH USER_MODE
    LIMIT 200
];

// SetupAuditTrail — 최근 Setup 변경 조회
List<SetupAuditTrail> changes = [
    SELECT Id, Action, Section, CreatedByContext,
           CreatedBy.Name, CreatedDate, Display
    FROM SetupAuditTrail
    ORDER BY CreatedDate DESC
    LIMIT 50
];

// AsyncApexJob — 실행 중 Batch 조회
List<AsyncApexJob> jobs = [
    SELECT Id, ApexClass.Name, Status, JobType,
           NumberOfErrors, JobItemsProcessed, TotalJobItems,
           CreatedDate, CompletedDate
    FROM AsyncApexJob
    WHERE Status IN ('Processing', 'Queued', 'Preparing')
    ORDER BY CreatedDate DESC
    WITH USER_MODE
];
```

---

## 관련 노트

- [[6 Standard Objects]] — Ch6 전체 도메인 카탈로그 (상위 파일)
- [[Core CRM Objects]] — Account·Contact·Lead 기반 데이터
- [[Analytics Objects]] — Report·Dashboard
- [[Files Objects]] — ContentDocument
- [[Object Groups]] — Object 그룹 분류 체계
- [[1 Overview]] — Field 타입·Object 기본 개념
