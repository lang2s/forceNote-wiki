---
tags: [devops, metadata-api, metadata-types, flow, workflow, approval-process, assignment-rules, v67, v68]
source: api_meta.pdf v67.0 Summer '26 — Chapter 13 (Metadata Types) + Winter27-v68-Docs/api_meta.pdf v68.0 Winter '27 (PREVIEW, 2026-08-21) pp.1242·1258–1259·1278·1290–1291·1319
created: 2026-05-22
aliases: [Flow 메타데이터, WorkflowRule 메타데이터, ApprovalProcess 메타데이터, AssignmentRules 메타데이터, AutoResponseRules 메타데이터, 자동화 메타데이터 타입, FlowDataLookup, FlowNodeGroup, FlowNode group, Flow 노드 그룹, 데이터 룩업 Start 요소, Commerce Checkout Flow 액션 타입, b2cGetShippingMethods, b2cInitiatePayment]
---

# Metadata Types — Automation

> Flow, WorkflowRule, ApprovalProcess, AssignmentRules, EscalationRules, AutoResponseRules, BatchCalcJobDefinition 등 자동화 관련 메타데이터 타입 상세 필드 정의.

---

## 이 그룹의 타입 목록

| 타입명 | 설명 |
|---|---|
| ActionPlanTemplate | 액션 플랜 템플릿 |
| AdvAccountForecastSet | 계정 예측 세트 |
| AppointmentAssignmentPolicy | 자원 배정 규칙 |
| AppointmentSchedulingPolicy | 예약 스케줄링 정책 |
| ApprovalProcess | 승인 프로세스 |
| AssignmentRules | 케이스/리드 배정 규칙 |
| AutoResponseRules | 자동 응답 규칙 |
| BatchCalcJobDefinition | Data Processing Engine 정의 |
| BatchProcessJobDefinition | Batch Management 작업 정의 |
| BusinessProcessGroup | 고객 경험 설문 |
| CampaignInfluenceModel | 캠페인 영향 모델 |
| CustomNotificationType | 커스텀 알림 타입 |
| DecisionTable | 의사결정 테이블 |
| DecisionTableDatasetLink | 의사결정 테이블 데이터셋 링크 |
| DecisionMatrixDefinition | 의사결정 매트릭스 정의 |
| DuplicateRule | 중복 레코드 감지 규칙 |
| EmailServicesFunction | 이메일 서비스 |
| EmailTemplate | 이메일 템플릿 (1GP only) |
| EnablementMeasureDefinition | Enablement 측정 정의 |
| EnablementProgramDefinition | Enablement 프로그램 정의 |
| EnblProgramTaskSubCategory | Enablement 커스텀 훈련 타입 |
| EntitlementProcess | 자격 프로세스 |
| EntitlementTemplate | 자격 템플릿 |
| EscalationRules | 케이스 에스컬레이션 규칙 |
| ExpressionSetDefinition | 표현식 세트 정의 |
| ExpressionSetMessageToken | 표현식 세트 메시지 토큰 |
| ExpressionSetObjectAlias | 표현식 세트 오브젝트 별칭 |
| Flow | 플로우 |
| FlowCategory | 플로우 카테고리 |
| FlowDefinition | 플로우 정의 |
| FlowTest | 플로우 테스트 |
| FlowValueMap | Reserved for future use |
| ForecastingFilter | 예측 커스텀 필터 |
| ForecastingFilterCondition | 예측 필터 조건 |
| ForecastingSourceDefinition | 예측 소스 정의 |
| ForecastingType | 예측 타입 |
| ForecastingTypeSource | 예측 소스-타입 매핑 |
| InvocableActionExtension | 액션 입력 UI 표시 방법 |
| LearningItemType | Enablement 훈련 타입 (Guidance Center) |
| LoyaltyProgramSetup | 로열티 프로그램 프로세스 설정 |
| MatchingRule | 중복 레코드 매칭 규칙 |
| MfgProgramTemplate | Manufacturing Program 정의 |
| MilestoneType | 자격 프로세스 마일스톤 |
| NotificationTypeConfig | org 수준 알림 설정 |
| OrchestrationPlanCtxMapping | Dynamic Revenue Orchestrator 컨텍스트 매핑 |
| PipelineInspMetricConfig | Pipeline Inspection 예측 지표 설정 |
| PostTemplate | Chatter 승인 게시물 템플릿 |
| PricingActionParameters | 가격 책정 액션 파라미터 |
| PricingRecipe | 가격 책정 데이터 레시피 |
| Queue | 작업 대기열 |
| QueueRoutingConfig | 작업 라우팅 설정 |
| RecordActionDeployment | Actions & Recommendations 설정 |
| RelatedRecordAssocCriteria | 관련 레코드 자동 연결 기준 |
| SalesWorkQueueSettings | Sales Engagement 작업 큐 설정 |
| SchedulingObjective | Workforce Engagement 스케줄링 목표 |
| SchedulingRule | Workforce Engagement 스케줄링 규칙 |
| ServiceProcess | Service Process Studio 프로세스 |
| StageAssignment | 레코드 스테이지 자동 배정 |
| StageDefinition | Stage Management 상태·전환 |
| SvcCatalogFulfillmentFlow | Service Catalog 플로우 |
| SvcCatalogItemDef | Service Catalog 개별 서비스 |
| TimeSheetTemplate | Field Service 타임시트 템플릿 |
| Workflow | 워크플로우 규칙 |

---

## Flow

플로우 메타데이터. Screen Flow, Record-Triggered Flow, Autolaunched Flow 등 모든 Flow 타입 포함. `Metadata` 타입을 extends.

**파일 경로:** `flows/FlowName.flow`

**주의 사항:**
- 관리 패키지에서 설치된 플로우는 템플릿이 아니면 Metadata API로 접근 불가
- 파일명에 공백 포함 시 배포 오류 발생 (이름 앞뒤 공백은 배포 시 제거됨)
- 비생산 org(scratch, sandbox)에서는 활성 플로우에도 변경 배포 가능. 생산 org는 "Deploy processes and flows as active" 설정 필요
- 비활성 플로우 버전이고 일시 중단 인터뷰가 없는 경우에만 삭제 가능
- **경고:** Process Builder(Workflow/InvocableProcess processType) 프로세스 메타데이터 편집 금지. 배포 후 빌더에서 열 수 없음

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `actionCalls` | FlowActionCall[] | - | 액션 호출 노드 배열 (v31.0+) |
| `apexPluginCalls` | FlowApexPluginCall[] | - | Apex 플러그인 호출 노드 배열 |
| `apiVersion` | number | - | 플로우 실행 API 버전 (v50.0+). v50.0 이전 생성 플로우는 0으로 표시 |
| `areMetricsLoggedToDataCloud` | boolean | - | Data Cloud 지표 로깅 여부 (기본: false, v63.0+) |
| `assignments` | FlowAssignment[] | - | 배정 노드 배열 |
| `choices` | FlowChoice[] | - | 정적 선택 옵션 배열 |
| `collectionFilterCriteria` | FlowCollectionFilterCriteria[] | - | Reserved for future use |
| `collectionProcessors` | FlowCollectionProcessor[] | - | 컬렉션 처리 노드 배열 (v50.0+) |
| `constants` | FlowConstant[] | - | 상수 배열 |
| `customErrors` | FlowCustomError[] | - | 커스텀 오류 배열 |
| `customProperties` | FlowCustomProperty[] | - | 커스텀 속성 (예: Screen Flow 진행 표시기, v63.0+) |
| `decisions` | FlowDecision[] | - | 의사결정 노드 배열 |
| `description` | string | - | 플로우 설명 |
| `dynamicChoiceSets` | FlowDynamicChoiceSet[] | - | DB 조회 기반 동적 선택 옵션 세트 |
| `environments` | FlowEnvironment (enum) | - | 플로우 실행 가능 환경. `Default` / `Offline`(v62.0+) / `Slack` (v55.0+) |
| `exitRules` | FlowExitRule[] | - | 세그먼트 트리거 플로우 종료 규칙 (v61.0+) |
| `experiments` | FlowExperiment[] | - | 실험 배열 (v61.0+) |
| `formulas` | FlowFormula[] | - | 수식 배열 |
| `fullName` | string | Required | 플로우 고유 이름. 버전 지정: `sampleFlow-3`. v44.0+에서 버전 번호 미포함 |
| `groups` | FlowNodeGroup[] | - | **그룹 노드 배열 (v68.0+).** v67까지 "Reserved for future use"였다가 v68에서 실제 기능으로 전환 (아래 `FlowNodeGroup` 절 참조) |
| `interviewLabel` | string | - | 인터뷰 레이블 (일시 중단 인터뷰 구분용) |
| `isAdditionalPermissionRequiredToRun` | boolean | - | 프로파일/권한 세트 접근 제한 여부 (기본: false, v47.0+) |
| `isTemplate` | boolean | - | 템플릿 여부. 관리 패키지 구독자가 복제·수정 가능 (기본: false, v45.0+) |
| `label` | string | Required | 플로우 레이블 |
| `loops` | FlowLoop[] | - | 컬렉션 반복 노드 배열 (v30.0+) |
| `migratedFromWorkflowRuleName` | string | - | 마이그레이션된 워크플로우 규칙 이름 (v54.0+) |
| `orchestratedStages` | FlowOrchestratedStage[] | - | 오케스트레이션 스테이지 노드 (v53.0+) |
| `processMetadataValues` | FlowMetadataValue[] | - | 플로우 메타데이터 값 (v31.0+) |
| `processType` | FlowProcessType (enum) | - | 플로우 타입 (아래 표 참조) |
| `recordCreates` | FlowRecordCreate[] | - | 레코드 생성 노드 |
| `recordDeletes` | FlowRecordDelete[] | - | 레코드 삭제 노드 |
| `recordLookups` | FlowRecordLookup[] | - | 레코드 조회 노드 |
| `recordRollbacks` | FlowRecordRollback[] | - | 레코드 롤백 노드 |
| `recordUpdates` | FlowRecordUpdate[] | - | 레코드 업데이트 노드 |
| `runInMode` | FlowRunInMode (enum) | - | 플로우 실행 모드. `DefaultMode` / `SystemModeWithSharing` / `SystemModeWithoutSharing` |
| `screens` | FlowScreen[] | - | 화면 노드 배열 |
| `sourceTemplate` | string | - | 이 플로우의 원본 템플릿 이름 (v45.0+) |
| `stages` | FlowStage[] | - | 스테이지 배열 (v46.0+) |
| `start` | FlowStart | - | 플로우 시작 요소 (v50.0+) |
| `startElementReference` | string | - | 첫 번째 요소 참조 (v50.0 이전) |
| `status` | FlowVersionStatus (enum) | - | `Active` / `Draft` / `Obsolete` / `InvalidDraft` |
| `steps` | FlowStep[] | - | 스텝 노드 배열 |
| `subflows` | FlowSubflow[] | - | 서브플로우 호출 노드 배열 |
| `textTemplates` | FlowTextTemplate[] | - | 텍스트 템플릿 배열 |
| `timeZoneSidKey` | string | - | 시간대 ID (v57.0+) |
| `transforms` | FlowTransform[] | - | 변환 노드 배열 (v54.0+) |
| `triggerOrder` | int | - | 동일 트리거 이벤트에서의 실행 순서 (v51.0+) |
| `variables` | FlowVariable[] | - | 변수 배열 |
| `waits` | FlowWait[] | - | 대기 노드 배열 |

### processType 주요 값

| 값 | 설명 | 버전 |
|---|---|---|
| `AutoLaunchedFlow` | 사용자 상호작용 없이 자동 실행 | - |
| `Flow` | Screen Flow (사용자 인터랙션) | - |
| `Workflow` | Process Builder (프로세스) — 편집 금지 | - |
| `InvocableProcess` | 호출 가능 프로세스 — 편집 금지 | - |
| `CustomEvent` | 플랫폼 이벤트 수신 프로세스 | v41.0+ |
| `RecordTriggeredFlow` | 레코드 트리거 플로우 | - |
| `ScheduledFlow` | 스케줄 트리거 플로우 | - |
| `Appointments` | Lightning Scheduler 플로우 | v44.0+ |
| `CheckoutFlow` | Lightning B2B Commerce 체크아웃 | v48.0+ |
| `Orchestrator` | 오케스트레이션 | v53.0+ |
| `ApprovalWorkflow` | 승인 프로세스 오케스트레이션 | v63.0+ |

---

## Flow 서브타입 — v68.0 (Winter '27) 신규

> 출처: `Winter27-v68-Docs/api_meta.pdf` v68.0 Winter '27 (**PREVIEW**) pp.1242 · 1278 · 1290–1291 · 1319. 표지에 PREVIEW 배너가 있으므로 GA 가이드 배포 시 재확인 대상.

v68에서 Flow 메타데이터에 서브타입 2개(`FlowDataLookup` · `FlowNodeGroup`)와 이를 참조하는 부모 필드 3개(`Flow.groups` · `FlowNode.group` · `FlowStart.dataLookups`)가 추가됐다.

### FlowDataLookup 서브타입 (v68.0 신규)

플로우의 **Start 요소에서의 데이터 룩업**을 정의한다. `FlowElement`를 extends하고 그 모든 필드를 상속한다. (p.1278)

**부모 필드:** `FlowStart.dataLookups` — `FlowDataLookup[]`, *"런타임에 관련 레코드를 어떻게 조회할지 정의하는 데이터 룩업 배열"* (p.1319, v68.0+)

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `lookupField` | string | **Required** | `sourceApiName`으로 지정된 오브젝트에서 **lookup join에 사용할 필드** |
| `lookupReference` | string | **Required** | 기본(primary) 레코드로부터의 lookup 관계에 대한 **참조 표현식** |
| `sourceApiName` | string | **Required** | 데이터 룩업이 정의된 **오브젝트의 API 이름** |
| `sourceType` | string | **Required** | `sourceApiName`으로 지정된 오브젝트의 타입. 유효 값은 `DataModelObject` |

> ⚠️ `sourceType`은 enum이 아니라 **`string` 타입**이며, 가이드가 명시한 유효 값은 `DataModelObject` **하나뿐**이다 (p.1278).

### FlowNodeGroup 서브타입 (v68.0 신규)

**조직화 목적의 플로우 노드 그룹.** `FlowNode`를 extends하고 그 모든 필드를 상속한다. (p.1290)

**부모 필드:** `Flow.groups` — `FlowNodeGroup[]`, *"An array of group nodes. Available in API version 68.0 and later."* (p.1242)

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `faultConnector` | FlowConnector | - | **Reserved for future use.** (v68에서도 아직 미사용) |
| `groupType` | GroupType (enum of type string) | **Required** | 그룹의 타입. 유효 값은 **`generic` 하나뿐** |
| `sourceBranchApiName` | string | - | 그룹이 위치한 커넥터 분기. 유효 값은 `sourceReference` 값에 따라 달라진다 (아래 표) |
| `sourceReference` | string | - | 그룹 **바로 앞** 노드의 이름. 앞 노드가 Start 요소면 `__Start`를 사용 |

**`sourceBranchApiName` 유효 값 — `sourceReference`가 가리키는 노드 종류별 (p.1291)**

| `sourceReference`가 가리키는 노드 | `sourceBranchApiName` 값 |
|---|---|
| Start (immediate path) | `immediate` |
| Start (scheduled path) | 해당 path의 API 이름 |
| Standard element | `regular` |
| Decision (outcome) | 해당 outcome의 API 이름 |
| Decision (default path) | `default` |
| Loop (for each item) | `forEach` |
| Loop (after last item) | `noMoreValues` |
| Fault path | `fault` |

**같이 추가된 `FlowNode.group` 필드 (p.1290)**

| Field Name | Field Type | Description |
|---|---|---|
| `group` | string | 이 노드가 속한 **그룹의 이름**. v68.0+ |

#### 📌 "Reserved for future use" → 실제 기능 전환 사례

`FlowNodeGroup` 토큰 자체는 **v67에도 존재했다.** 다만 v67에서는 `Flow.groups` 필드 설명이 그냥 `Reserved for future use.` 였고 **`FlowNodeGroup` 서브타입 섹션 자체가 없었다.**

| | v67.0 (Summer '26) | v68.0 (Winter '27) |
|---|---|---|
| `Flow.groups` 설명 | `Reserved for future use.` | "An array of group nodes. Available in API version 68.0 and later." |
| `FlowNodeGroup` 서브타입 섹션 | **없음** | 있음 (필드 4개, p.1290–1291) |
| `FlowNode.group` 필드 | 없음 | 있음 (v68.0+) |

> **읽는 법:** 예약 자리표시자(placeholder)가 실제 기능으로 승격된 케이스다. "타입 이름이 v67 PDF에도 grep된다"는 사실만으로 "신규 아님"이라 판정하면 이런 전환을 놓친다. **토큰 존재 여부가 아니라 섹션·필드 설명의 실질**을 봐야 한다.
>
> 또한 이 전환은 Winter '27 릴리즈 노트(`rn_api_meta`)에 **언급되지 않는다** — 가이드에는 있고 릴리즈 노트에는 없는 항목. → [[Winter '27/Development]]

### Commerce Checkout Flow 액션 타입 — v68.0 신규 값 6개

`FlowActionCall.actionType`(`InvocableActionType` enum, p.1251)의 **Commerce Checkout Flow 그룹**에 B2C Commerce 배송·결제 값 6개가 추가됐다. (pp.1258–1259)

> 그룹 머리말 원문: *"These values are used in the Commerce Checkout Flow. If no version is specified, the value is available in API version 55.0 and later."* — 아래 6개는 모두 **"available in API version 68.0 and later"** 로 개별 명시돼 있다.

| Valid Value | 설명 |
|---|---|
| `b2cGetShippingMethods` | B2C Commerce 바스켓의 **기본 shipment**에 사용 가능한 **배송 방법을 조회** |
| `b2cSetShippingAddress` | B2C Commerce 바스켓의 기본 shipment에 **배송 주소를 설정** |
| `b2cSetShippingMethod` | B2C Commerce 바스켓의 기본 shipment에 **배송 방법을 설정** |
| `b2cInitiatePayment` | 바스켓이 체크아웃 준비 상태인지 검증하고 **Apple Pay 결제 요청을 개시** |
| `b2cPreProcessPayment` | **결제 전(pre-payment) 훅** 실행 — 초안 주문 생성 같은 결제 전 로직을 Apex가 수행하게 함 |
| `b2cPostProcessPayment` | **결제 후(post-payment) 훅** 실행 — 주문 상태 업데이트 같은 결제 후 로직을 Apex가 수행하게 함 |

> 이 6개 값 역시 Winter '27 릴리즈 노트에 **언급되지 않는다** (가이드 전용 변경).

---

## ApprovalProcess

승인 프로세스. 레코드가 승인되는 방식을 자동화.

**파일 경로:** `approvalProcesses/ObjectName.ProcessName.approvalProcess`

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `active` | boolean | - | 활성화 여부 |
| `allowRecall` | boolean | - | 제출자의 승인 취소 허용 여부 |
| `allowedSubmitters` | ApprovalSubmitter[] | - | 승인 제출 가능 사용자/역할/큐 |
| `approvalPageFields` | ApprovalPageField | - | 승인 페이지에 표시될 필드 |
| `approvalStep` | ApprovalStep[] | - | 승인 단계 목록 |
| `description` | string | - | 프로세스 설명 |
| `emailTemplate` | string | - | 이메일 템플릿 이름 |
| `enableMobileDeviceAccess` | boolean | - | 모바일에서 승인 가능 여부 |
| `entryCriteria` | ApprovalEntryCriteria | - | 제출 기준 |
| `finalApprovalActions` | ApprovalAction | - | 최종 승인 시 액션 |
| `finalApprovalRecordLock` | boolean | - | 최종 승인 후 레코드 잠금 여부 |
| `finalRejectionActions` | ApprovalAction | - | 최종 거절 시 액션 |
| `finalRejectionRecordLock` | boolean | - | 최종 거절 후 레코드 잠금 여부 |
| `fullName` | string | Required | 프로세스 고유 이름 (ObjName.ProcessName 형식) |
| `initialSubmissionActions` | ApprovalAction | - | 초기 제출 시 액션 |
| `label` | string | Required | 표시 레이블 |
| `nextAutomatedApprover` | NextAutomatedApprover | - | 다음 자동 승인자 설정 |
| `postTemplate` | string | - | Chatter 게시물 템플릿 |
| `recallActions` | ApprovalAction | - | 취소 시 액션 |
| `recordEditability` | RecordEditability (enum) | Required | 승인 중 편집 가능 여부. `AdminOnly` / `AdminOrCurrentApprover` |
| `showApprovalHistory` | boolean | - | 레코드 페이지에 승인 이력 표시 여부 |

---

## AssignmentRules

케이스 또는 리드를 적절한 사용자/큐에 자동 라우팅.

**파일 경로:** `assignmentRules/ObjectName.assignmentRules`

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `assignmentRule` | AssignmentRule[] | - | 배정 규칙 배열 |
| `fullName` | string | Required | `Case` 또는 `Lead` |

### AssignmentRule 서브타입

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `active` | boolean | - | 규칙 활성화 여부 (오브젝트당 하나의 활성 규칙만 가능) |
| `fullName` | string | - | 규칙 이름 |
| `ruleEntry` | RuleEntry[] | - | 배정 항목 목록 |

---

## AutoResponseRules

리드 또는 케이스 제출 속성에 따라 자동 이메일 응답을 보내는 규칙.

**파일 경로:** `autoResponseRules/ObjectName.autoResponseRules`

---

## EscalationRules

일정 시간 내 해결되지 않은 케이스를 자동 에스컬레이션.

**파일 경로:** `escalationRules/Case.escalationRules`

---

## Workflow

워크플로우 규칙. 지정 조건이 충족되면 워크플로우 액션 실행. `Metadata` 타입을 extends.

**파일 경로:** `workflows/ObjectName.workflow`

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `alerts` | WorkflowAlert[] | - | 이메일 알림 액션 목록 |
| `fieldUpdates` | WorkflowFieldUpdate[] | - | 필드 업데이트 액션 목록 |
| `flowActions` | WorkflowFlowAction[] | - | Flow 트리거 액션 목록 (v43.0+) |
| `fullName` | string | Required | 오브젝트 API 이름 |
| `knowledgePublishes` | WorkflowKnowledgePublish[] | - | Knowledge 게시 액션 |
| `outboundMessages` | WorkflowOutboundMessage[] | - | 아웃바운드 메시지 액션 목록 |
| `rules` | WorkflowRule[] | - | 워크플로우 규칙 목록 |
| `send` | WorkflowSend[] | - | 전송 액션 목록 |
| `tasks` | WorkflowTask[] | - | 태스크 액션 목록 |

### WorkflowRule 서브타입

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `active` | boolean | Required | 규칙 활성화 여부 |
| `actions` | WorkflowActionReference[] | - | 즉시 실행 액션 목록 |
| `booleanFilter` | string | - | 항목별 필터 논리 |
| `criteriaItems` | FilterItem[] | - | 필터 기준 항목 |
| `description` | string | - | 규칙 설명 |
| `formula` | string | - | 규칙 조건 수식 |
| `fullName` | string | - | 규칙 이름 |
| `timeTriggers` | WorkflowTimeTrigger[] | - | 시간 트리거 목록 |
| `triggerType` | WorkflowTriggerType (enum) | Required | `onCreateOnly` / `onCreateOrTriggeringUpdate` / `onAllChanges` / `onOpportunityClose` |
| `workflowTimeTriggers` | WorkflowTimeTrigger[] | - | 시간 기반 트리거 (deprecated, `timeTriggers` 사용 권장) |

---

## CustomNotificationType

커스텀 알림 타입. 데스크탑·모바일 활성화 여부 설정.

**와일드카드(`*`) 지원:** 미지원

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `actionGroups` | CustomNotificationActionGroup[] | Optional | 모바일 액션 그룹 활성화 여부 — 사용자가 **모바일 알림에서 직접 액션을 수행**하게 한다. 필드 표기는 v68에서도 여전히 `(Beta)` (v68 p.759) |
| `customNotifTypeName` | string | Required | 알림 타입 이름. 최대 80자 (v68 p.759) |
| `description` | string | - | 알림 타입 이름과 함께 표시되는 일반 설명. 최대 255자 (v68 p.759) |
| `desktop` | boolean | Required | 데스크탑 전달 채널 활성화 여부 |
| `masterLabel` | string | Required | 마스터 레이블 |
| `mobile` | boolean | Required | 모바일 전달 채널 활성화 여부 |
| `slack` | boolean | - | **Reserved for future use.** (v68 p.759) |

**Version:** `CustomNotificationType` components are available in API version 46.0 and later. (v68 p.759)

```xml
<!-- 예시 -->
<CustomNotificationType xmlns="http://soap.sforce.com/2006/04/metadata">
  <customNotifTypeName>Custom Notification</customNotifTypeName>
  <desktop>true</desktop>
  <masterLabel>Custom Notification</masterLabel>
  <mobile>true</mobile>
</CustomNotificationType>
```

### CustomNotificationActionGroup 서브타입 — Winter '27에 Beta → GA

`CustomNotificationActionGroup`은 **액션 그룹**을 나타내는 서브타입이다.

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `actions` | CustomNotificationActionDefinition[] | - | 모바일 액션 그룹 안의 액션들 |
| `groupName` | string | **Required** | 모바일 액션 그룹의 **고유 이름** |

**상태 전환 (v67 → v68)**

| | v67.0 (Summer '26) | v68.0 (Winter '27) |
|---|---|---|
| 섹션 제목 | `CustomNotificationActionGroup (Beta)` | `CustomNotificationActionGroup` (**Beta 표기 제거 = GA**) |
| Beta 법적 고지 문단 | 있음 (Beta Services Terms 문단) | **삭제됨** |
| 부모 필드 `CustomNotificationType.actionGroups` 표기 | `actionGroups (Beta)` | `actionGroups (Beta)` — **그대로 남아 있음** |

> ⚠️ **문서 드리프트:** 서브타입 제목에서는 Beta가 걷혔는데 **부모 필드 행의 `(Beta)` 라벨은 v68에서도 남아 있다**(v68 p.759). 두 표기가 어긋난 상태이므로, GA(비-PREVIEW) 가이드가 나오면 어느 쪽이 정정되는지 재확인한다.

---

## DuplicateRule

중복 레코드 감지 규칙. `Metadata` 타입을 extends.

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `actionOnInsert` | DuplicateActionType (enum) | Required | 삽입 시 액션. `Allow` / `Block` / `Report` |
| `actionOnUpdate` | DuplicateActionType (enum) | Required | 업데이트 시 액션 |
| `active` | boolean | Required | 규칙 활성화 여부 |
| `alertText` | string | - | 사용자 표시 알림 텍스트 |
| `description` | string | - | 설명 |
| `duplicateRuleFilter` | DuplicateRuleFilter | - | 필터 조건 |
| `duplicateRuleMatchRules` | DuplicateRuleMatchRule[] | - | 매칭 규칙 목록 |
| `fullName` | string | - | 규칙 이름 |
| `isActive` | boolean | - | 규칙 활성화 여부 |
| `masterLabel` | string | Required | 마스터 레이블 |
| `operationsOnInsert` | string[] | - | 삽입 시 실행 작업 |
| `operationsOnUpdate` | string[] | - | 업데이트 시 실행 작업 |
| `securityOption` | DuplicateSecurityOptionType (enum) | Required | `EnforceSharingRules` / `BypassSharingRules` |
| `sortOrder` | int | Required | 규칙 정렬 순서 |

---

## BatchCalcJobDefinition

Data Processing Engine 정의.

---

## EntitlementProcess

자격 프로세스 설정.

---

## EntitlementTemplate

자격 템플릿 — 제품에 빠르게 추가할 수 있는 사전 정의 고객 지원 조건.

---

## FlowDefinition

플로우 정의 — 설명과 활성 플로우 버전 번호.

---

## FlowCategory

Lightning Bolt Solution에 포함되는 플로우 카테고리. `Metadata` 타입을 extends.

---

## FlowTest

플로우 테스트. 레코드 트리거, 자동 실행, Data Cloud 트리거 플로우 활성화 전 검증.

---

## MatchingRule

중복 레코드 식별 매칭 규칙. DuplicateRule에서 참조.

---

## Queue

작업 대기열.

---

## 관련 노트

- [[Metadata Types — 개요 및 분류]] — 전체 타입 목록
- [[Metadata Types — Objects & Fields]] — CustomObject, ValidationRule
- [[Metadata Types — Security & Access]] — Profile, PermissionSet
- [[Metadata API File-Based 호출]] — package.xml Flow 배포
- [[Metadata API 에러 처리]] — 배포 오류 처리
- [[2GP — Components - Automation]] — Flow·Workflow·Decision Table·Batch 등 자동화 컴포넌트 2GP Manageability Rules 전수
- [[Winter '27/Development]] — v68.0 Metadata API 변경 릴리즈 노트 원문 (⚠️ `FlowNodeGroup`·Commerce Checkout 액션 값 6개는 릴리즈 노트에 **없는** 가이드 전용 변경)
