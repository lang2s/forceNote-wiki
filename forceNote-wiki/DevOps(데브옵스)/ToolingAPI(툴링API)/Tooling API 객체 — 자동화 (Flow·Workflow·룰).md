---
tags: [tooling-api, devops, automation, flow, workflow, validation]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-28
aliases: [AssignmentRule, AutoResponseRule, BusinessProcess, DuplicateJobDefinition, DuplicateJobMatchingRuleDefinition, Flow, FlowDefinition, FlowElementTestCoverage, FlowTest, FlowTestCoverage, FlowTestResult, MatchingRule, ProcessFlowMigration, ValidationRule, WorkflowAlert, WorkflowFieldUpdate, WorkflowOutboundMessage, WorkflowRule, WorkflowTask, 자동화, 플로우, 워크플로우, 검증 규칙, 배정 규칙, 자동 응답 규칙, 매칭 규칙, 중복 잡, 플로우 테스트, 워크플로우 마이그레이션]
---

# Tooling API 객체 — 자동화 (Flow·Workflow·룰)

> 선언적 자동화 Tooling sObject 19종 전수 — Flow·Flow테스트·Workflow 액션·검증/배정/매칭 룰. 플로우 정의·버전·테스트 커버리지, 레거시 워크플로우 룰+액션, 배정/자동응답/매칭 룰, ValidationRule을 SOQL로 조회·구성한다.

이 노트는 Tooling API Reference & Developer Guide v67.0(Summer '26)의 "Tooling API Objects" 챕터 중 **선언적 자동화 도메인 sObject 군**을 다룬다. 이 군은 Flow definition/version·Flow 테스트(FlowTest·FlowTestCoverage·FlowElementTestCoverage)·Process→Flow 마이그레이션, 레거시 Workflow rule + 액션(Alert·FieldUpdate·OutboundMessage·Task), 배정(AutoResponse·Assignment)/매칭(MatchingRule·DuplicateJob*) 룰, 그리고 ValidationRule Tooling sObject로, 대부분 `query()`로 SOQL 조회가 가능한 메타데이터다.

> [!warning] Tooling Ch4에 없는 자동화 객체 (Metadata API/런타임 전용)
> 아래 객체들은 자동화 객체로 흔히 기대되지만 **Tooling API Ch4(Tooling API Objects)에는 존재하지 않는다.** Metadata API 전용이거나 표준 런타임 sObject이므로 "Tooling API로 다룰 수 있다"고 쓰면 안 된다. 이는 실제 coverage gap 신호이지 누락이 아니다(검색 시 혼동 방지).
> - EscalationRule
> - DuplicateRule
> - MatchingRuleItem
> - FlowInterview (런타임 표준 sObject)
> - WorkflowTimeTrigger
> - ApprovalProcess
> - ProcessInstance / ProcessDefinition (승인 런타임)
> - FlowCategory
> - FlowDefinitionView
> - WorkflowOutboundMessageMember
> - FlowElementTest

> [!note] 도메인 경계 — 다른 그룹/노트 소관
> - **ValidationRule** 은 이 노트가 정본이다([[Tooling API 객체 — Entity·Field·스키마]]에는 `EntityDefinition.ValidationRules` 자식 관계 필드로 *언급만* 됨).
> - **BusinessProcessDefinition** 은 이 노트 밖이며 이미 [[Tooling API 객체 — Entity·Field·스키마]]에 작성되어 있다(여기서는 `BusinessProcess` 객체 경계에서 STOP). **Feedback · Group** 등 나머지는 차기 운영 사이클 소관.
> - 이연(차기 사이클): ModerationRule → Experience, RecommendationStrategy → Einstein/AI, RecordActionDeployment → UI(C4-4), EmbeddedServiceFlow(+Config)·SvcCatalogFulfill* → Service.
> - **CleanRule · TimeSheetTemplate** 은 DELEGATE(Field Service 소관) — 이 노트에서 재작성하지 않는다.

> [!note] thin / reserved 객체 (필드 fabricate 금지)
> - **AssignmentRule** — PDF 본문 전체가 "Don't use this object." + "This object is exposed in API version 35.0, however AssignmentRule is reserved for future use." 뿐이다. **Supported Calls 라인·필드 테이블 없음.**
> - **FlowTestResult** — PDF 본문 전체가 "This object is reserved for internal use." 뿐이다. Supported Calls·필드 없음.
> 두 객체 모두 원문 그대로만 기록하며 필드를 만들어내지 않는다.

> 표기 규약: 필드표는 PDF `-layout` 추출본의 충실 transcription이며, 원문 오타/quirk는 `[sic]` 인라인으로 보존한다.

---

## 객체 빠른 색인

| 객체 | 분류 | 필드 수 | API 최소 버전 |
|---|---|---|---|
| [AssignmentRule](#assignmentrule) | 룰 (reserved) | 0 | 35.0 (reserved) |
| [AutoResponseRule](#autoresponserule) | 룰 | 3 | 35.0 |
| [BusinessProcess](#businessprocess) | 기타 | 5 | 33.0 |
| [DuplicateJobDefinition](#duplicatejobdefinition) | 룰 | 5 | 42.0 (Tooling) |
| [DuplicateJobMatchingRuleDefinition](#duplicatejobmatchingruledefinition) | 룰 | 2 | 42.0 (Tooling) |
| [Flow](#flow) | Flow & Flow 테스트 | 15 | 34.0 |
| [FlowDefinition](#flowdefinition) | Flow & Flow 테스트 | 11 | 34.0 |
| [FlowElementTestCoverage](#flowelementtestcoverage) | Flow & Flow 테스트 | 3 | 44.0 |
| [FlowTest](#flowtest) | Flow & Flow 테스트 | 8 | 55.0 |
| [FlowTestCoverage](#flowtestcoverage) | Flow & Flow 테스트 | 5 | 44.0 |
| [FlowTestResult](#flowtestresult) | Flow & Flow 테스트 (internal) | 0 | — |
| [MatchingRule](#matchingrule) | 룰 | 11 | 42.0 (Tooling) |
| [ProcessFlowMigration](#processflowmigration) | Flow & Flow 테스트 | 10 | 58.0 |
| [ValidationRule](#validationrule) | 룰 | 12 (+서브) | 34.0 |
| [WorkflowAlert](#workflowalert) | Workflow (레거시) | 11 | 32.0 |
| [WorkflowFieldUpdate](#workflowfieldupdate) | Workflow (레거시) | 12 | 32.0 |
| [WorkflowOutboundMessage](#workflowoutboundmessage) | Workflow (레거시) | 9 | 32.0 |
| [WorkflowRule](#workflowrule) | Workflow (레거시) | 6 | 30.0 |
| [WorkflowTask](#workflowtask) | Workflow (레거시) | 9 | 32.0 |

> 필드 수 합계 = **137** (AutoResponseRule 3 · BusinessProcess 5 · DuplicateJobDefinition 5 · DuplicateJobMatchingRuleDefinition 2 · Flow 15 · FlowDefinition 11 · FlowElementTestCoverage 3 · FlowTest 8 · FlowTestCoverage 5 · MatchingRule 11 · ProcessFlowMigration 10 · ValidationRule 12 · WorkflowAlert 11 · WorkflowFieldUpdate 12 · WorkflowOutboundMessage 9 · WorkflowRule 6 · WorkflowTask 9) + ValidationRule Metadata 서브객체 1행. AssignmentRule·FlowTestResult는 필드 0.

---

## Flow & Flow 테스트 (Flow / Flow Tests)

> 플로우 버전·정의·테스트 커버리지·Process→Flow 마이그레이션. 플로우 종류·런타임 개념은 [[Flow MOC]]·[[Flow 종류와 변수]], 런타임 인터뷰는 [[Flow Interview API]] 참조.

### Flow

Use the Flow object to retrieve and update specific flow versions. With Flow, you can create an application that navigates users through a series of screens to query and update records in the database. You can also execute logic and provide branching capability based on user input to build dynamic applications. For information about the corresponding UI-based flow building tool, see Flow Builder in Salesforce Help.

When using the Tooling API to work with flows, consider that:

> **Note:** Legacy flows created with the Desktop Flow Designer can't be modified with the API. Update your flow by recreating it with Flow Builder.

- You can describe information for a flow installed from a managed package but not its metadata.
- Every time you update a flow version, you actually delete the existing flow version and create a flow version from it, with a new ID.
- To activate a flow, change the Status field to active.

You can delete a flow version as long as it isn't active and has no paused interviews. If the flow version has paused interviews, wait for those interviews to resume and finish, or delete them.

> 플로우 종류·변수·런타임 개념은 [[Flow 종류와 변수]] / [[Flow MOC]] 참조.

- **Version:** This object is available in API version 34.0 and later.
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), update(), upsert()
- **Supported REST API HTTP Methods:** DELETE, GET, HEAD, PATCH, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiVersion | double | Nillable | The API version that defines the execution behavior of the flow. Available in API version 50.0 and later. Flows created before API version 50.0 display an API version of 0 on the Flows list view in Setup. To display the correct API version number, create another version of the flow, and set the API version for running the flow to 49.0 or later. |
| Definition | FlowDefinition | Filter, Group, Nillable, Sort | This flow's definition object. |
| DefinitionId | ID | Filter, Group, Sort | The ID of this flow's FlowDefinition. |
| Description | string | Filter, Group, Nillable, Sort | A description of the flow, such as what it's meant to do or how it works. |
| Environments | multipicklist | Filter, Nillable | Indicates where a flow can run. (값 목록은 아래 별도 블록 참조) |
| FullName | string | Create, Group, Nillable | The full name of the flow in the Metadata API. (규칙·전문은 아래 별도 블록 참조) |
| IsTemplate | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the process or flow is a template. (전문은 아래 별도 블록 참조) Available in API version 45.0 and later. Default: false |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state 값(아래 별도 블록 참조). |
| MasterLabel | string | Filter, Group, idLookup, Sort | Label for the flow. In the UI, this field is Flow Label. |
| Metadata | mns:Flow | Create, Nillable, Update | The flow's metadata. Query this field only if the query result contains no more than one record... If the flow is part of a managed package, this field is Null. Metadata isn't returned for flows in managed packages, unless the flows are templates. |
| ProcessType | Restricted picklist | Filter, Group, Nillable, Sort | The type of the flow (값 목록은 아래 별도 블록 참조). |
| RunInMode | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The mode that the flow runs in (값 목록은 아래 별도 블록 참조). |
| Status | Restricted picklist | Filter, Group | The flow's status (값 목록은 아래 별도 블록 참조). |
| TimeZoneSidKey | string | Nillable | The ID that defines the time zone in which the flow runs. Available in API version 56.0 and later. |
| VersionNumber | int | Filter, Group, Sort | The flow's version number. |

**Flow.Environments — multipicklist 값 (verbatim):**
- **Default** — The flow can run from a Visualforce component, Lightning page, flow action, or custom Aura component.
- **Offline** — The flow can run only offline. Flow types that support offline flows must set this value. This value is available in API version 62.0 and later.
- **Slack** — The flow can run in Slack and the default environment. You specify the Slack flow environment when you save the flow. Available in API version 55.0 and later.

**Flow.FullName — Description 전문 (verbatim):**
> The full name of the flow in the Metadata API. A unique name for the flow that contains only underscores and alphanumeric characters. The name must be unique across the org, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. To deploy or retrieve a version, you can specify the version number. For example, sampleFlow-3 specifies version 3 of the flow whose unique name is sampleFlow. If you don't specify a version number, the flow is the latest version.

**Flow.IsTemplate — Description 전문 (verbatim):**
> Indicates whether the process or flow is a template. When installed from managed packages, processes and flows can't be viewed or cloned by subscribers because of intellectual property (IP) protection. But when those processes and flows are templates, subscribers can open them in a builder, clone them, and customize the clones. Available in API version 45.0 and later. Default: false

**Flow.ManageableState — enum (verbatim):**
beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged

**Flow.ProcessType — Restricted picklist 값 (verbatim, 전수):**

유효 값:
- **ActivityObjectMatchingFlow** — A flow that launches when Einstein Activity Capture detects and captures a new activity, such as an email. This type of flow runs in the background without user interaction. This value is available with Sync Email as Salesforce Activity in API version 64.0 and later.
- **Appointments** — A flow for Lightning Scheduler. This value is available in API version 44.0 and later.
- **ApprovalWorkflow** — A flow that's used to manage Approval Processes in Revenue Cloud. This value is available in API version 61.0 and later.
- **AutoLaunchedFlow** — A flow that doesn't require user interaction.
- **CheckoutFlow** — A flow used in Lightning B2B Commerce to create a checkout in a store. This value is available in API version 48.0 and later.
- **ContactRequestFlow** — A flow that lets customers request that customer support get back to them. This flow is used to create contact request records. This value is available in API version 45.0 and later.
- **CustomerLifecycle** — A Salesforce Surveys flow that lets you associate survey questions with different stages in customer lifecycles. This value is available in API version 49.0 and later and only when the Customer Lifecycle Designer license is enabled.
- **CustomEvent** — A process that is invoked when it receives a platform event message. In the UI, it's an event process. This value is available in API version 41.0 and later.
- **FieldServiceMobile** — A flow for the Field Service mobile app. This value is available in API version 39.0 and later.
- **FieldServiceWeb** — A flow for embedded Appointment Booking. Its UI label is Field Service Embedded Flow. This value is available in API version 41.0 and later.
- **Flow** — A flow that requires user interaction because it contains one or more screens or local actions, choices, or dynamic choices. In the UI and Salesforce Help, it's a screen flow. Screen flows can be launched from the UI, such as with a flow action, Lightning page, or web tab.
- **FSCLending** — A flow for Financial Services Cloud Mortgage. This value is available in API version 46.0 and later. `[sic — FSCLending appears twice; second entry below]`
- **IndicatorResultFlow** — A flow for Outcome Management that calculates and creates indicator results for a selected indicator performance period. This value is available with the Outcome Management license in API version 60.0 and later.
- **FSCLending** — A flow for login. This value is available in API version 51.0 and later. `[sic — duplicate label "FSCLending" in source; description says "for login", likely a doc typo but transcribed verbatim]`
- **IdentityUserRegistrationFlow** — A flow that creates users when they register and updates existing users when they log in via a single sign-on process that uses the authentication provider framework. Available in API version 64.0 and later.
- **InvocableProcess** — A process that can be invoked by another process or the Invocable Actions resource in REST API. This value is available in API version 38.0 and later.
- **LoyaltyManagementFlow** — A flow for the Loyalty Management app and can be invoked by loyalty program processes. This value is available in API version 54.0 and later.
- **PromptFlow** — A flow for Prompt Builder. Pass data between Prompt Builder and the flow. This value is available in API version 60.0 and later.
- **RoutingFlow** — A flow for Salesforce Omni-Channel routing and other business logic. This value is available in API version 52.0 and later.
- **Survey** — A flow for Salesforce Surveys. From the UI, this type of flow is created in Survey Builder. This value is available in API version 42.0 and later.
- **SurveyEnrich** — A Salesforce Surveys flow that uses the Survey Data Mapper. From the UI, this type of flow is created in the Survey Builder and requires an associated survey flow type. This value is available in API version 49.0 or later and only when the Customer Lifecycle Designer license is enabled.
- **Workflow** — A process that is invoked when a record is created or edited. In the UI and Salesforce Help, it's a record change process.

These values are **reserved for future use**:
- ActionPlan
- AppProcess
- CartAsyncFlow
- DigitalForm
- Journey
- JourneyBuilderIntegration
- LoginFlow
- ManagedContentFlow
- OrchestrationFlow
- RecommendationStrategy
- SalesEntryExperienceFlow
- TransactionSecurityFlow
- UserProvisioningFlow

추가 설명 (verbatim):
> This value has significant impact on validation when saving the flow and on the flow's runtime behavior. Don't change this value unless you understand the flow properties of the specified type. Across flow versions, you can change the type only from Flow to AutoLaunchedFlow or vice versa. Before you change the flow type, make sure that the flow contains only elements, resources, and functionality that the new flow type supports.

**Flow.RunInMode — picklist 값 (verbatim):**
- **DefaultMode** — The flow version runs in system or user context, depending on how the flow is launched.
- **SystemModeWithSharing** — The flow version always runs in system mode with sharing. The flow respects org-wide default settings, role hierarchies, sharing rules, manual sharing, teams, and territories. But it doesn't respect object permissions, field-level access, or other permissions of the running user.
- **SystemModeWithoutSharing** — The flow version always runs in system mode without sharing. The flow can access all data. Available in API version 48.0 and later.

**Flow.Status — Restricted picklist 값 (verbatim, 전수 — 5개 값, 숨은 값 없음 확인):**
- Active
- Draft
- Obsolete
- UnderReview
- InvalidDraft

### FlowDefinition

The parent of a set of flow versions.

> **Important:** Where possible, we changed noninclusive terms to align with our company value of Equality. Because changing terms in our code can break current implementations, we maintained this object's name.

When using the Tooling API to work with flow definitions, consider that:

> **Note:** Legacy flows created with the Desktop Flow Designer can't be modified with the API. Update your flow by recreating it with Flow Builder.

- You can activate and deactivate flows with the Metadata field.
  > **Important:** In API version 44.0, we recommend upgrading your flows to flow metadata file names without version numbers and discontinue using the FlowDefinition object to activate or deactivate a flow. Then use the Flow object to activate or deactivate a flow. For more information, see Upgrade Flow Files to API Version 44.0. If you deploy with flow definitions, the active version numbers in the flow definitions override the status fields in the flows. For example, the active version number in the flow definition is version 3, and the latest version of the flow is version 4 with the status field as Active. After you deploy your flow, the active version is version 3.
- You can update masterlabel and description of a FlowDefinition.
- FlowDefinition are implicitly created when the Flow object is created, which means FlowDefinition objects can only be updated.

- **Version:** This object is available in API version 34.0 and later.
- **Supported SOAP API Calls:** query(), retrieve(), update()
- **Supported REST API HTTP Methods:** GET, HEAD, PATCH, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| ActiveVersion | Flow | Filter, Group, Nillable, Sort | The active flow version object. |
| ActiveVersionId | ID | Filter, Group, Nillable, Sort | The ID of the active flow version. |
| Description | string | Nillable | Flow definition information, specified by the org's admin. |
| DeveloperName | string | Filter, Group, Sort | Developer name of this flow definition. In the UI, the label is Flow API Name. |
| FullName | string | Create, Group, Nillable | The full name of the flow definition in the Metadata API. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| LatestVersion | Flow | Filter, Group, Nillable, Sort | The latest flow version object, regardless of the status. |
| LatestVersionId | ID | Filter, Group, Nillable, Sort | ID of the latest flow version, regardless of the flow's status. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. This field is available in API version 38.0 and later. |
| MasterLabel | string | Filter, Group, Nillable, Sort | Label for the flow definition. In the UI, this field's label is Flow Label. |
| Metadata | mns:FlowDefinition | Create, Nillable, Update | The flow definition's metadata object, containing information about which flow version is active and the flow definition's description. Query this field only if the query result contains no more than one record... This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace associated with this flow definition. |

### FlowTest

Represents the description of a flow test associated with a flow definition. This object is available in API version 55.0 and later.

> **Important:** Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

- **Version:** API version 55.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Nillable | The description of the flow test. This field can be useful to describe the reason for creating the test or its intended use. |
| DeveloperName | string | Filter, Group, Sort | Required. The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. In managed packages, this field prevents naming conflicts on package installations. With this field, a developer can change the object's name in a managed package and the changes are reflected in a subscriber's organization. Label is Record Type Name. This field is automatically generated, but you can supply your own value if you create the record using the API. **Note:** When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance may slow while Salesforce generates one for each record. |
| FullName | string | Create, Group, Nillable | The full name of the associated FlowTest type in Metadata API. The full name can include a namespaceprefix. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the flow test. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| MasterLabel | string | Filter, Group, Sort | Label for the flow test. In the UI, this field is Label. |
| Metadata | FlowTest | Create, Nillable, Update | The flow test's metadata. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix associated with this object. Each Developer Edition organization that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values: (1) In Developer Edition organizations, the namespace prefix is set to the namespace prefix of the organization for all objects that support it. There is an exception if an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition organization of the package developer. (2) In organizations that are not Developer Edition organizations, NamespacePrefix is only set for objects that are part of an installed managed package. There is no namespace prefix for all other objects. |

### FlowTestCoverage

Represents test coverage for a flow or process by a given Apex method. Available in API version 44.0 and later.

- **Version:** API version 44.0 and later.
- **Supported SOAP Calls:** delete(), describeSObjects(), query(), retrieve(), update()
- **Supported REST HTTP Methods:** GET, HEAD

| Field | Type | Properties | Description |
|---|---|---|---|
| ApexTestClassId | ID | Filter, Group, Sort, Update | The ID of the Apex test class. |
| FlowVersionId | ID | Filter, Group, Sort | The ID of the flow version that was executed by the test method. |
| NumElementsCovered | int | Filter, Group, Nillable, Sort, Update | The number of elements that were executed by the test method. |
| NumElementsNotCovered | int | Filter, Group, Nillable, Sort, Update | The number of elements that weren't executed by the test method. |
| TestMethodName | string | Filter, Group, Nillable, Sort, Update | The name of the Apex method that executed the flow version. |

**Usage:** To deploy a process or autolaunched flow as active in production orgs, you must meet the flow test coverage requirement for your org. At least one Apex test must cover the flow test coverage percentage of the active processes and autolaunched flows. Flow test coverage requirements don't apply to flows that have screens. FlowTestCoverage records are deleted when changes are saved to the associated flow version.

A flow version corresponds to a process built in Process Builder or a flow built in Flow Builder. For a process, Apex tests execute only the active version. For a flow, Apex tests execute the active version. When a flow has no active version, Apex tests execute the latest version.

> **Tip:** Make sure that Deploy processes and flows as active is enabled in your org's process automation settings. Otherwise, when you deploy active flows and processes via change sets or Metadata API, they're deployed as inactive.

To calculate your org's flow test coverage, Salesforce divides the number of covered flows and processes by the sum of the number of active processes and active autolaunched flows.

**Sample Query:**
```sql
-- Get the names of all flows and processes that have test coverage.
SELECT FlowVersion.Definition.DeveloperName
FROM FlowTestCoverage
GROUP BY FlowVersion.Definition.DeveloperName

-- Get the names of all active autolaunched flows and processes that don't have test coverage.
SELECT Definition.DeveloperName
FROM Flow
WHERE Status = 'Active'
      AND (ProcessType = 'AutolaunchedFlow' OR ProcessType = 'Workflow' OR ProcessType = 'CustomEvent' OR ProcessType = 'InvocableProcess')
      AND Id NOT IN (SELECT FlowVersionId FROM FlowTestCoverage)

-- Get overall test coverage for a flow version.
SELECT Id, ApexTestClassId, TestMethodName, FlowVersionId, NumElementsCovered, NumElementsNotCovered
FROM FlowTestCoverage
WHERE flowversionid='301RM0000004GiK'
```

**SEE ALSO:** Salesforce Help: Deploy Processes and Flows as Active

### FlowElementTestCoverage

Represents a flow element that was executed by a given Apex test method. Available in API version 44.0 and later.

- **Version:** API version 44.0 and later.
- **Supported SOAP Calls:** query(), delete(), retrieve(), update()
- **Supported REST HTTP Methods:** GET, HEAD

| Field | Type | Properties | Description |
|---|---|---|---|
| ElementName | string | Filter, Group, Nillable, Sort, Update | The unique name of the flow element that's executed by the test method. |
| FlowTestCoverageId | ID | Filter, Group, Sort | The ID of the parent FlowTestCoverage record. |
| FlowVersionId | ID | Filter, Group, Sort, Update | The ID of the flow version that's executed by the test method. |

**Usage:** FlowElementTestCoverage records are deleted when changes are saved to the associated flow version.

> **Tip:** A flow version corresponds to a process built in Process Builder or a flow built in Flow Builder. When you create a process, Salesforce names each element for you. To understand which criteria node or action corresponds with an element name, see Troubleshoot Processes with Apex Debug Logs.

**Sample Queries:**
```sql
-- Get the executed elements that were executed by any test
SELECT Id, Elementname, FlowTestCoverageId
FROM FlowElementTestCoverage
WHERE FlowVersionId='301RM0000004GiK'

-- Get the number of elements that were executed by any test
SELECT count_distinct(ElementName)
FROM FlowElementTestCoverage
WHERE FlowVersionId='301RM0000004GiK'

-- Get the names of the elements that were executed by any test
SELECT ElementName, count(Id)
FROM FlowElementTestCoverage
WHERE FlowVersionId='301RM0000004GiK'
GROUP BY ElementName
```

### FlowTestResult

This object is reserved for internal use.

> 런타임 플로우 인터뷰 결과 조회는 [[Flow Interview API]] 참조. PDF 원문은 이 한 문장뿐이며 Supported Calls·필드 라인이 없다 — 필드를 fabricate하지 않는다.

### ProcessFlowMigration

Represents a process's migrated criteria and the resulting migrated flow. This object is available in API version 58.0 and later.

> **Important:** Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

- **Version:** API version 58.0 and later.
- **Supported SOAP API Calls:** describeSObjects(), query(), retrieve()
- **Supported REST API Methods:** GET, HEAD, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| DestinationFlowDefinitionId | reference | Filter, Group, Sort | The ID of the resulting migrated flow. This field is a relationship field. **Relationship Name:** DestinationFlowDefinition; **Relationship Type:** Lookup; **Refers To:** FlowDefinition |
| DestinationFlowVersionId | reference | Filter, Group, Nillable, Sort | The version ID of the migrated flow. This field is a relationship field. **Relationship Name:** DestinationFlowVersion; **Relationship Type:** Lookup; **Refers To:** Flow |
| DeveloperName | string | Filter, Group, Sort | The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. |
| Language | picklist | Filter, Group, Restricted picklist, Sort | Lanaguage [sic] of the MasterLabel. (전체 값 목록은 아래 별도 블록 참조) |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package. Possible values: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| MasterLabel | string | Filter, Group, Sort | The label for the ProcessFlowMigration. |
| MigratedCriteriaLabel | string | Filter, Group, Nillable, Sort | The label of the criteria that was migrated. |
| MigratedCriteriaName | string | Filter, Group, Nillable, Sort | The name of the criteria that was migrated. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace of the package containing the process flow migration object. |
| ProcessVersionId | reference | Filter, Group, Sort | The version ID of the originating process. This field is a relationship field. **Relationship Name:** ProcessVersion; **Relationship Type:** Lookup; **Refers To:** Flow |

**ProcessFlowMigration.Language — picklist 값 (verbatim, 전수 — `code—Name`):**

af—Afrikaans; am—Amharic; ar—Arabic; ar_AE—Arabic (United Arab Emirates); ar_BH—Arabic (Bahrain); ar_DZ—Arabic (Algeria); ar_EG—Arabic (Egypt); ar_IQ—Arabic (Iraq); ar_JO—Arabic (Jordan); ar_KW—Arabic (Kuwait); ar_LB—Arabic (Lebanon); ar_LY—Arabic (Libya); ar_MA—Arabic (Morocco); ar_OM—Arabic (Oman); ar_QA—Arabic (Qatar); ar_SA—Arabic (Saudi Arabia); ar_SD—Arabic (Sudan); ar_SY—Arabic (Syria); ar_TN—Arabic (Tunisia); ar_YE—Arabic (Yemen); bg—Bulgarian; bn—Bengali; bs—Bosnian; ca—Catalan; cs—Czech; cy—Welsh; da—Danish; de—German; de_AT—German (Austria); de_BE—German (Belgium); de_CH—German (Switzerland); de_LU—German (Luxembourg); el—Greek; el_CY—Greek (Cyprus); en_AE—English (United Arab Emirates); en_AU—English (Australian); en_BE—English (Belgium); en_CA—English (Canadian); en_CY—English (Cyprus); en_DE—English (Germany); en_GB—English (UK); en_HK—English (Hong Kong); en_IE—English (Ireland); en_IL—English (Israel); en_IN—English (Indian); en_MT—English (Malta); en_MY—English (Malaysian); en_NL—English (Netherlands); en_NZ—English (New Zealand); en_PH—English (Phillipines); en_SG—English (Singapore); en_US—English; en_ZA—English (South Africa); es—Spanish; es_AR—Spanish (Argentina); es_BO—Spanish (Bolivia); es_CL—Spanish (Chile); es_CO—Spanish (Colombia); es_CR—Spanish (Costa Rica); es_DO—Spanish (Dominican Republic); es_EC—Spanish (Ecuador); es_GT—Spanish (Guatemala); es_HN—Spanish (Honduras); es_MX—Spanish (Mexico); es_NI—Spanish (Nicaragua); es_PA—Spanish (Panama); es_PE—Spanish (Peru); es_PR—Spanish (Puerto Rico); es_PY—Spanish (Paraguay); es_SV—Spanish (El Salvador); es_US—Spanish (United States); es_UY—Spanish (Uruguay); es_VE—Spanish (Venezuela); et—Estonian; eu—Basque; fa—Farsi; fi—Finnish; fr—French; fr_BE—French (Belgium); fr_CA—French (Canadian); fr_CH—French (Switzerland); fr_LU—French (Luxembourg); fr_MA—French (Morocco); ga—Irish; gu—Gujarati; haw—Hawaiian; hi—Hindi; hmn—Hmong; hr—Croatian; ht—Haitian Creole; hu—Hungarian; hy—Armenian; in—Indonesian; is—Icelandic; it—Italian; it_CH—Italian (Switzerland); iw—Hebrew; ja—Japanese; ji—Yiddish; ka—Georgian; kk—Kazakh; kl—Greenlandic; km—Khmer; kn—Kannada; ko—Korean; lb—Luxembourgish; lt—Lithuanian; lv—Latvian; mi—Te reo; mk—Macedonian; ml—Malayalam; mr—Marathi; ms—Malay; mt—Maltese; my—Burmese; nl_BE—Dutch (Belgium); nl_NL—Dutch; no—Norwegian; pa—Punjabi; pl—Polish; pt_BR—Portuguese (Brazil); pt_PT—Portuguese (European); rm—Romansh; ro—Romanian; ro_MD—Romanian (Moldova); ru—Russian; ru_AM—Russian (Armenia); ru_BY—Russian (Belarus); ru_KG—Russian (Kyrgyzstan); ru_KZ—Russian (Kazakhstan); ru_LT—Russian (Lithuania); ru_MD—Russian (Moldova); ru_PL—Russian (Poland); ru_UA—Russian (Ukraine); sh—Serbian (Latin); sh_ME—Montenegrin; sk—Slovak; sl—Slovene; sm—Samoan; sq—Albanian; sr—Serbian (Cyrillic); sv—Swedish; sw—Swahili; ta—Tamil; te—Telugu; th—Thai; tl—Tagalog; tr—Turkish; uk—Ukrainian; ur—Urdu; vi—Vietnamese; xh—Xhosa; zh_CN—Chinese (Simplified); zh_HK—Chinese (Hong Kong); zh_MY—Chinese (Malaysia); zh_SG—Chinese (Singapore); zh_TW—Chinese (Traditional); zu—Zulu

---

## Workflow (레거시)

> 레거시 워크플로우 룰과 그 액션(Alert·FieldUpdate·OutboundMessage·Task). 다수 신규 자동화는 Flow로 대체되었으나 Tooling sObject로 여전히 조회/구성된다. 일부 액션 객체의 설명문에는 PDF 원문의 "WebLink"/"validation rule" copy-paste 흔적이 남아 있어 `[sic]`로 보존한다.

### WorkflowRule

Represents a workflow rule that is used to fire off a specific workflow action when the specified criteria is met. Includes access to the associated WorkflowRule object in Salesforce Metadata API.

- **Version:** Available from API version 30.0 or later.
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), search(), update(), upsert()
- **Supported REST HTTP Methods:** Query, DELETE, GET, PATCH, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| FullName | string | Create, Group, Nillable | The full name of the associated metadata object in Metadata API. Query this field only if the query result contains no more than one record... This limit protects performance. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| Metadata | mns:WorkflowRule | Create, Nillable, Update | Workflow rule metadata. Query this field only if the query result contains no more than one record... This limit protects performance. |
| Name | string | Filter, Group, Sort | The enum name or ID of entity this rule is associated with. |
| NamespacePrefix | string | Filter, Group, idLookup, Sort | The namespace of the package containing the workflow rule object. |
| TableEnumOrId | picklist | Filter, Group, Restricted picklist, Sort | The enum (for example, Account) or ID of the object for this workflow rule. |

> 참고: 실제 WorkflowRule 객체에는 별도 trigger-type enum 필드가 없다. 객체↔레코드 연관은 **TableEnumOrId** picklist(Account 등 enum 또는 ID)로 표현되며, trigger type 자체는 Metadata 필드(mns:WorkflowRule) 내부에 있어 Tooling Fields 테이블에는 노출되지 않는다.

### WorkflowAlert

Represents a workflow alert. A workflow alert is an email generated by a workflow rule or approval process and sent to designated recipients. This object is available in API version 32.0 and later.

- **Version:** API version 32.0 and later.
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), search(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| CcEmails | string | Filter, Nillable, Sort | Additional CC email addresses. |
| Description | string | Filter, Group, idLookup, Sort | A description of the workflow alert. |
| DeveloperName | string | Filter, Group, Sort | The unique name of the workflow alert in the API. |
| EntityDefinition | EntityDefinition | Filter, Group, Sort. | Required. Available in version 34.0. The entity definition for the object associated with this WebLink. [sic — "WebLink" in source] |
| EntityDefinitionId | string | Filter, Group, Sort | The ID of the entity containing the alert. |
| FullName | string | Create, Group, Nillable | The full name of the associated metadata object in Metadata API. Query this field only if the query result contains no more than one record... This limit protects performance. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| Metadata | mns:WorkflowAlert | Create, Nillable, Update | Alert definition metadata. Query this field only if the query result contains no more than one record... This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Sort | The namespace of the package to uniquely identify the workflow alert. |
| SenderType | ActionEmailSenderType enumerated list | Defaulted on create, Filter, Group, Restricted picklist, Sort | The type of sender. Values are: CurrentUser, OrgWideEmailAddress, DefaultWorkflowUser |
| TemplateId | ID | Filter, Group, Sort | A reference to an email template. |

### WorkflowFieldUpdate

Represents a workflow field update. This object is available in API version 32.0 and later.

- **Version:** API version 32.0 and later.
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), search(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| EntityDefinition | EntityDefinition | Filter, Group, Sort. | Required. Available in API version 34.0. The entity definition for the object associated with this workflow field update. |
| EntityDefinitionId | string | Filter, Group, Sort | The ID of the entity containing the workflow field update. |
| FieldDefinition | FieldDefinition | Filter, Group, Sort | Required. The definition of this field. |
| FieldDefinitionId | string | Filter, Group, Sort | The ID of the field for the workflow field update. |
| FullName | string | Create, Group, Nillable | The full name of the associated metadata object in Metadata API. Query this field only if the query result contains no more than one record... This limit protects performance. |
| LiteralValue | string | Filter, Group, Nillable, Sort | If the update uses a literal value, this is that value. |
| LookupValueId | ID | Filter, Group, Nillable, Sort | If the update looks up a value, this lookup value is referenced. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| Metadata | mns:WorkflowFieldUpdate | Create, Nillable, Update | The workflow field update metadata. Query this field only if the query result contains no more than one record... This limit protects performance. |
| Name | string | Filter, Group, idLookup, Sort | The name of the workflow field update. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace of the package containing the workflow field update object. |
| SourceTableEnumOrId | picklist | Filter, Group, Restricted picklist, Sort | The enum (for example, Account) or ID of the object this workflow field update is on. |

### WorkflowOutboundMessage

Represents an outbound message. An outbound message sends information to a designated endpoint, like an external service. Outbound messages are configured from Setup. You must configure the external endpoint and create a listener for the messages using the SOAP API. This object is available in API version 32.0 and later.

- **Version:** API version 32.0 and later.
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), search(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiVersion | double | Filter, Sort | The API version is automatically generated and set to the current API version when the outbound message was created. |
| EntityDefinition | EntityDefinition | Filter, Group, Sort. | Required. Available in version 34.0. The entity definition for the object associated with this WebLink. [sic — "WebLink" in source] |
| EntityDefinitionId | string | Filter, Group, Sort | The ID of the entity containing the outbound message. |
| FullName | string | Create, Group, Nillable | The full name of the associated metadata object in Metadata API. Query this field only if the query result contains no more than one record... This limit protects performance. |
| IntegrationUserId | ID | Filter, Group, Sort | The ID of the user under which this message is sent. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| Metadata | mns:WorkflowOutboundMessage | Create, Nillable, Update | Outbound message definition metadata. Query this field only if the query result contains no more than one record... This limit protects performance. |
| Name | string | Filter, Group, idLookup, Sort | The name of the outbound message. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace of the package containing the outbound message. |

### WorkflowTask

Represents a workflow task that is used to fire off a specific workflow action when the specified criteria is met. Includes access to the associated WorkflowRule object in Salesforce Metadata API.

- **Version:** Available from API version 32.0 or later.
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), search(), update(), upsert()
- **Supported REST HTTP Methods:** Query, DELETE, GET, PATCH, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| EntityDefinition | EntityDefinition | Filter, Group, Sort. | Required. The entity definition for the object associated with the validation rule. [sic — source says "validation rule"] |
| EntityDefinitionId | string | Filter, Group, Sort | The ID of the entity containing the workflow task. |
| FullName | string | Create, Group, Nillable | The full name of the associated metadata object in Metadata API. Query this field only if the query result contains no more than one record... This limit protects performance. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| Metadata | mns:WorkflowTask | Create, Nillable, Update | Workflow task metadata. Query this field only if the query result contains no more than one record... This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace of the package containing the workflow task object. |
| Priority | picklist | Filter, Group, Sort | The task's priority. Values are: High, Normal, Low |
| Status | picklist | Filter, Group, Sort | The task's status. Values are: Not Started, In Progress, Completed, Waiting on someone else, Deferred |
| Subject | string | Filter, Group, idLookup, Sort | A subject for the workflow task. It is used if an email notification is sent when the task is assigned. |

---

## 룰 (배정·자동응답·매칭·중복·검증)

> 배정(Assignment·AutoResponse)·매칭/중복(MatchingRule·DuplicateJob*)·검증(ValidationRule) Tooling sObject 군. 중복/매칭 관리의 선언적 설정 how-to 전용 노트는 위키에 아직 없음(ADMIN-7 갭) — 여기서는 Tooling sObject 필드만 다룬다.

### AssignmentRule

Don't use this object.

This object is exposed in API version 35.0, however AssignmentRule is reserved for future use.

> PDF 원문은 위 두 문장뿐이며 Supported Calls 라인·필드 테이블이 없다. 필드를 fabricate하지 않는다.

### AutoResponseRule

Specifies whether the autoresponse rule is active (true). This object is available in API version 35.0 and later.

- **Version:** API version 35.0 and later.
- **Supported SOAP API Calls:** query()
- **Supported REST API HTTP Methods:** Query, GET

| Field | Type | Properties | Description |
|---|---|---|---|
| Active | boolean | Defaulted on create Filter, Group, Sort | If true, the autoresponse rule is active. |
| EntityDefinitionId | string | Filter, Group, Sort | Represents the object associated with this autoresponse rule. |
| Name | string | Filter, Group, Nillable, Sort | Represents the name of the autoresponse rule. |

**Usage:** Use this object to query whether an autoresponse rule is active.
```sql
SELECT Name, Active
FROM AutoResponseRule
```
More information about the autoresponse rule is available by querying the metadata type AutoResponseRules.

### MatchingRule

Setup object specifying a MatchingRule to use with DuplicateJob instances that share a DuplicateJobDefinition. Available in Tooling API version 42.0 and later.

- **Version:** Tooling API 42.0 and later.
- **Supported SOAP Calls:** query(), retrieve()
- **Supported REST HTTP Methods:** GET and POST

| Field | Type | Properties | Description |
|---|---|---|---|
| BooleanFilter | string | Filter, Group, Nillable, Sort | Boolean logic between conditions for the MatchingRule. |
| Description | textarea | Filter, Group, Nillable, Sort | The description of the MatchingRule. |
| DeveloperName | string | Filter, Group, Sort | The developer name for the MatchingRule. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| Language | picklist | Filter, Group, Restricted picklist, Sort | The language in the user's personal settings. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| MasterLabel | string | Filter, Group, Sort | The label of the MatchingRule. |
| MatchEngine | picklist | Filter, Group, Nillable, Restricted picklist, Sort | This field can contain one value: the match engine used by the matching rule. Valid values are ExactMatchEngine and FuzzyMatchEngine. Default value is ExactMatchEngine. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix associated with this object. |
| RuleStatus | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | The status of the MatchingRule. Valid values are Active or Inactive. |
| SobjectSubtype | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The object subtype. Valid values are Person Account or None. |
| SobjectType | picklist | Filter, Group, Restricted picklist, Sort | The object type: Account, Contact, or Lead. |

### DuplicateJobDefinition

Setup object defining a job that identifies duplicate record items globally. Available in Tooling API version 42.0 and later.

- **Version:** Tooling API 42.0 and later.
- **Supported SOAP Calls:** create(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** GET and POST

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Create, Filter, Group, Sort, Update | The developer name of the DuplicateJobDefinition. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The language in the user's personal settings. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | The label of the DuplicateJobDefinition. |
| SobjectSubtype | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | The object subtype. Valid values are PersonAccount and None. |
| SobjectType | picklist | Create, Filter, Group, Restricted picklist, Sort | The object type: Account, Contact, or Lead. |

### DuplicateJobMatchingRuleDefinition

Setup object specifying a MatchingRule to use with DuplicateJob instances that share a DuplicateJobDefinition. Available in Tooling API version 42.0 and later.

- **Version:** Tooling API 42.0 and later.
- **Supported SOAP Calls:** create(), query(), retrieve()
- **Supported REST HTTP Methods:** GET and POST

| Field | Type | Properties | Description |
|---|---|---|---|
| DuplicateJobDefinitionId | reference | Create, Filter, Group, Sort | The ID of the duplicate job definition. |
| MatchingRuleId | reference | Create, Filter, Group, Nillable, Sort | The ID of the matching rule specified for a duplicate job. |

### ValidationRule

Represents a validation rule or workflow rule which specifies the formula for when a condition is met. Available from API version 34.0 or later.

> 검증 규칙 작성 예제·패턴은 [[Validation Rules 예제]] 참조. 이 객체는 [[Tooling API 객체 — Entity·Field·스키마]]에서 `EntityDefinition.ValidationRules` 자식 관계로 언급만 되고, 본문 정본은 여기다.

- **Version:** API version 34.0 and later.
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH

| Field | Type | Properties | Description |
|---|---|---|---|
| Active | boolean | Defaulted on create, Filter, Group, Sort. | Required. Indicates whether this validation rule is active, (true), or not active (false). |
| Description | string | Filter, Nillable, Sort. | A description of the validation rule. |
| EntityDefinition | EntityDefinition | Filter, Group, Sort. | Required. The entity definition for the object associated with the validation rule. |
| EntityDefinitionId | string | Filter, Group, Sort. | Required. ID of the record in EntityDefinition. |
| ErrorDisplayField | string | Filter, Group, Nillable, Sort. | The fully specified name of a field in the application. If a value is supplied, the error message appears next to the specified field. If you do not specify a value or the field isn't visible on the page layout, the value changes automatically to Top of Page. |
| ErrorMessage | string | Filter, Group, Nillable, Sort . | Required. The message that appears if the validation rule fails. The message must be 255 characters or less. |
| FullName | string | Create, Group, Nillable. | The internal name of the object. White spaces and special characters are escaped for validity. The name must: Contain characters, letters, or the underscore (_) character; Must start with a letter; Can't end with an underscore; Can't contain two consecutive underscore characters. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Id | Id | Defaulted on create, Filter, Group, idLookup, Sort. | The unique system ID for this record. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| Metadata | ValidationRule Metadata | Create, Nillable, Update. | Validation rule metadata. Query this field only if the query result contains no more than one record... This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort. | The namespace prefix associated with this object. Each Developer Edition organization that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. (값 목록: (1) In Developer Edition organizations, the namespace prefix is set to the namespace prefix of the organization for all objects that support it. There is an exception if an object is in an installed managed package... This field's value is the namespace prefix of the Developer Edition organization of the package developer. (2) In organizations that are not Developer Edition organizations, NamespacePrefix is only set for objects that are part of an installed managed package. There is no namespace prefix for all other objects.) |
| ValidationName | string | Filter, Group, Namefield, Sort. | The name or ID of the object that this rule is associated with. |

**Sub-object: ValidationRule Metadata**

"active, description, errorDisplayField, and errorMessage are described in the previous table."

| Field | Type | Properties | Description |
|---|---|---|---|
| errorConditionFormula | string | Filter, Group, Nillable, Sort | Required. The formula defined in the validation rule. If the formula returns a value of true, an error message is displayed. |

---

## 기타 (Misc)

### BusinessProcess

Represents a business process. This object is available in API version 33.0 and later.

> 경계: PDF에서 이 섹션 뒤에 BusinessProcessDefinition 섹션이 이어지지만, 그 객체는 [[Tooling API 객체 — Entity·Field·스키마]]에 작성되어 있다. 여기서는 BusinessProcess 객체 경계에서 STOP.

- **Version:** API version 33.0 and later.
- **Supported SOAP Calls:**
  - getDeleted(), getUpdated(), query(), retrieve(), and upsert() are available in API version 33.0 and later.
  - create() and update() are available in API version 36.0 and later.
- **Supported REST HTTP Methods:** GET, PATCH, POST
- **Special Access Rules:** Access to this object requires the View Setup and Configuration permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | string | Create, Filter, Group, Nillable, Sort, Update | The business process description, limited to 255 characters. |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort, Update | Indicates whether this business process is active (true) or not (false). |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The process name. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | A unique string to distinguish this type from any others. |

---

## 관련 노트

- [[Tooling API — 개요·REST·SOAP 호출 기초]] — 폴더 허브. REST/SOQL 쿼리 리소스·헤더·composite·EOL 등 호출 기초.
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 객체↔네임스페이스 분류, SOQL/SOSL 한도, System Fields, ApiFault.
- [[Tooling API — SOAP·REST 헤더]] — 호출 시 사용하는 SOAP/REST 헤더.
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — 형제 Ch4 도메인 노트(Apex 코드·테스트 sObject 군).
- [[Tooling API 객체 — Entity·Field·스키마]] — 형제 Ch4 도메인 노트. ValidationRule을 `EntityDefinition.ValidationRules` 관계로 언급, BusinessProcessDefinition 본문 보유.
- [[Tooling API 객체 — 보안·권한]] — 형제 Ch4 도메인 노트(보안·권한 sObject 군).
- [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]] — UI·레이아웃·페이지·액션 sObject 22종(FlexiPage·Layout·QuickAction·WebLink·Path 등) 형제 Ch4 도메인 노트. 본 노트가 C4-4로 이연한 RecordActionDeployment의 정본.
- [[Flow MOC]] — Flow 섹션 전체 목차. Flow·FlowDefinition·플로우 종류의 응용·런타임 맥락.
- [[Flow 종류와 변수]] — ProcessType·RunInMode·Status 등 플로우 종류·변수 개념.
- [[Flow Interview API]] — 런타임 플로우 인터뷰(FlowTestResult/런타임 영역의 응용).
- [[Validation Rules 예제]] — ValidationRule의 검증 규칙 작성 예제·패턴.

> 콘텐츠 갭: 중복/매칭 관리(MatchingRule·DuplicateJobDefinition)의 선언적 설정 how-to 전용 노트는 위키에 아직 없음(ADMIN-7 갭) — 본 노트는 Tooling sObject 필드만 다룬다.
