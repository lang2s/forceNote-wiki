---
tags: [field-service, fsl, sobject, object-reference, work-plan, work-step, work-type, 현장서비스, 작업계획, 작업단계, 작업유형]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-24
aliases: [WorkPlan, WorkPlanSelectionRule, WorkPlanTemplate, WorkPlanTemplateEntry, WorkStep, WorkStepStatus, WorkStepTemplate, WorkType, WorkTypeGroup, WorkTypeGroupMember, 작업 계획, 작업 계획 선택 규칙, 작업 계획 템플릿, 작업 단계, 작업 단계 상태, 작업 단계 템플릿, 작업 유형, 작업 유형 그룹, 작업 유형 그룹 멤버]
---

# 객체 레퍼런스 — WorkPlan·WorkStep·WorkType

> Field Service의 작업 계획(Work Plan)·작업 단계(Work Step)·작업 유형(Work Type) 클러스터 SOAP API 객체 10종 전수 레퍼런스 — 작업 계획(WorkPlan)과 그 선택 규칙(WorkPlanSelectionRule)·템플릿(WorkPlanTemplate·WorkPlanTemplateEntry), 작업 단계(WorkStep)와 상태(WorkStepStatus)·템플릿(WorkStepTemplate), 작업 유형(WorkType)과 그룹(WorkTypeGroup·WorkTypeGroupMember). 각 객체의 설명·API 도입 버전·Supported Calls·Special Access Rules·전 필드·Enum/Picklist 값·Associated Objects를 담는다.

> 이 노트는 Field Service의 **작업 절차(Work Plan/Step) 및 작업 유형(Work Type) 데이터 모델** 도메인 SOAP API 객체 정의를 다룬다. 전체 데이터 모델 개요와 객체 간 관계도(ER diagram)는 [[Field Service 개요와 데이터 모델]], 객체 카탈로그 요약은 [[Field Service Objects]]를 참조한다.

---

## 객체 한눈에 (10)

| # | 객체 | 한 줄 | 필드 수(전수) | API 도입 |
|---|---|---|---|---|
| 1 | WorkPlan | 작업 주문 또는 작업 주문 라인 항목에 대한 작업 계획 | 11 | v52.0+ |
| 2 | WorkPlanSelectionRule | 작업 주문/라인 항목에 대한 작업 계획 선택 규칙 | 12 | v52.0+ |
| 3 | WorkPlanTemplate | 작업 계획에 대한 템플릿 | 7 | v52.0+ |
| 4 | WorkPlanTemplateEntry | 작업 단계 템플릿을 작업 계획 템플릿과 연결 | 6 | v52.0+ |
| 5 | WorkStep | 작업 계획의 작업 단계 | 17 | v52.0+ |
| 6 | WorkStepStatus | 작업 단계 상태 카테고리의 피크리스트 | 5 | v52.0+ |
| 7 | WorkStepTemplate | 작업 단계에 대한 템플릿 | 8 | v52.0+ |
| 8 | WorkType | Field Service·Lightning Scheduler에서 수행할 작업 유형(템플릿) | 14 | v38.0+ |
| 9 | WorkTypeGroup | 작업 유형의 그룹 | 8 | v45.0+ |
| 10 | WorkTypeGroupMember | 작업 유형과 그 작업 유형 그룹 간의 관계 | 5 | v45.0+ |

> 필드 표 형식: PDF는 2열(Field Name | Details)이고 Details 셀 안에 Type/Properties/Description/Relationship Name/Relationship Type/Refers To가 세로 나열돼 있다. 본 노트는 이를 4열(Field · Type · Properties · Description)로 펼치고, 관계 필드는 Description 끝에 `RelName / RelType / Refers To`를 표기했다.
>
> **[sic] 보존:** PDF 원문의 오기·비일관 표기를 의도적으로 그대로 둔 곳에 `[sic]`을 달았다(WorkStep.WorkPlanExecutionOrder의 "ID of the plan execution order", WorkStepStatus.StatusCode Properties의 "Required." 혼입, WorkStepTemplate.IsActive의 괄호 없는 true/false, WorkType·WorkTypeGroup·WorkTypeGroupMember의 LastReferencedDate 설명 비일관 등).
>
> **추출 범위 주의:** PDF상 WorkPlanTemplateEntry와 WorkStep 사이에 **WorkOrderStatus**가 끼어 있으나, 본 클러스터 10객체 목록에 없어 제외했다(별도 사이클).

---

## 1. WorkPlan

작업 주문(work order) 또는 작업 주문 라인 항목(work order line item)에 대한 **작업 계획(work plan)**을 나타낸다. v52.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | The description of the work plan. |
| ExecutionOrder | int | Create, Filter, Group, Nillable, Sort, Update | The order in which the work plan is executed. Only positive values or null are supported. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last interacted with this record, directly or indirectly. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, it's possible that the user only accessed this record or list view (LastReferencedDate), but not viewed it. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the work plan. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The ID of the user who created the work plan. RelName: Owner; RelType: Lookup; Refers To: Group, User. |
| ParentRecordId | reference | Create, Filter, Group, Sort | The ID of the work order, work order line item, or change request that the work plan is associated with. Available in API version 54.0 and later. This field is a polymorphic relationship field. RelName: ParentRecord; RelType: Lookup; Refers To: ChangeRequest, WorkOrder, WorkOrderLineItem. |
| ParentRecordType | string | Filter, Group, Nillable, Sort | Describes whether the parent record is a work order, work order line item, or change request. Available in API version 54.0 and later. |
| WorkOrderId | reference | Create, Filter, Group, Nillable, Sort, Update | Required. The ID of the work order. RelName: WorkOrder; RelType: Lookup; Refers To: WorkOrder. |
| WorkOrderLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the work order line item. RelName: WorkOrderLineItem; RelType: Lookup; Refers To: WorkOrderLineItem. |
| WorkPlanTemplateId | reference | Filter, Group, Nillable, Sort | The ID of the work plan template record. Available in API version 54.0 and later. This field is a relationship field. RelName: WorkPlanTemplate; RelType: Lookup; Refers To: WorkPlanTemplate. |

**Associated Objects:** `WorkPlanChangeEvent` (v54.0) — change events; `WorkPlanFeed` — feed tracking; `WorkPlanHistory` — 추적 필드 히스토리; `WorkPlanOwnerSharingRule` — sharing rules; `WorkPlanShare` — sharing.

**SOQL 예시 — 작업 주문의 작업 계획·단계 조회:**

```sql
-- 구조 예시 — 실제 동작 코드 아님
SELECT Id, Name, ExecutionOrder, ParentRecordType, WorkPlanTemplateId,
       (SELECT Id, Name, ExecutionOrder, Status, StatusCategory
        FROM WorkSteps ORDER BY ExecutionOrder)
FROM WorkPlan
WHERE WorkOrderId = :workOrderId
ORDER BY ExecutionOrder
```

---

## 2. WorkPlanSelectionRule

작업 주문 또는 작업 주문 라인 항목에 대한 작업 계획을 **선택하는 규칙**을 나타낸다. v52.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| AssetId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the asset. |
| Description | string | Create, Filter, Group, Nillable, Sort, Update | The description of the selection rule. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Controls whether this selection rule is active (true) or not (false). Default is false. Label is Active. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last interacted with this record, directly or indirectly. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, it's possible that the user only accessed this record or list view (LastReferencedDate), but not viewed it. |
| LocationId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the location. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The ID of the owner. |
| Product2Id | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the product. Label is Product. |
| ServiceTerritoryId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the service territory. |
| WorkPlanSelectionRuleNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | The auto-generated number of the work plan selection rule, for example, WPSR-0001. |
| WorkPlanTemplateId | reference | Create, Filter, Group, Sort, Update | Required. The ID of the work plan template. |
| WorkTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the work type. |

**Associated Objects:** `WorkPlanSelectionRuleChangeEvent` — change events; `WorkPlanSelectionRuleFeed` — feed tracking; `WorkPlanSelectionRuleHistory` — 추적 필드 히스토리; `WorkPlanSelectionRuleOwnerSharingRule` — sharing rules; `WorkPlanSelectionRuleShare` — sharing.

---

## 3. WorkPlanTemplate

작업 계획에 대한 **템플릿**을 나타낸다. v52.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | The description of the work plan template. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Controls whether the specific template is available for application (true) or not (false). Default is false. Label is Active. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last interacted with this record, directly or indirectly. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, it's possible that the user only accessed this record or list view (LastReferencedDate), but not viewed it. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The user-defined name of the work plan template. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The ID of the owner who created the work plan template. |
| RelativeExecutionOrder | int | Create, Filter, Group, Nillable, Sort, Update | The relative execution order for sorting the work plan when it's applied to the work order or work order line item. Only positive integers are supported. |

**Associated Objects:** `WorkPlanTemplateChangeEvent` — change events; `WorkPlanTemplateFeed` — feed tracking; `WorkPlanTemplateHistory` — 추적 필드 히스토리; `WorkPlanTemplateOwnerSharingRule` — sharing rules; `WorkPlanTemplateShare` — sharing.

---

## 4. WorkPlanTemplateEntry

작업 단계 템플릿(work step template)을 작업 계획 템플릿(work plan template)과 **연결하는 객체**를 나타낸다. v52.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| ExecutionOrder | int | Create, Filter, Group, Nillable, Sort, Update | The sequence number of when this entry is executed. Only positive values are supported. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last interacted with this record, directly or indirectly. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, it's possible that the user only accessed this record or list view (LastReferencedDate), but not viewed it. |
| WorkPlanTemplateEntryNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | The auto-generated number of the work plan template entry, for example, WPTE-0001. |
| WorkPlanTemplateId | reference | Create, Filter, Group, Sort | Required. The ID of the work plan template. |
| WorkStepTemplateId | reference | Create, Filter, Group, Sort, Update | Required. The ID of the work step template. |

**Associated Objects:** `WorkPlanTemplateEntryChangeEvent` — change events; `WorkPlanTemplateEntryFeed` — feed tracking; `WorkPlanTemplateEntryHistory` — 추적 필드 히스토리.

---

## 5. WorkStep

작업 계획의 **작업 단계(work step)**를 나타낸다. v52.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| ActionDefinition | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The platform action that the work step executes. The possible values are the names of the flow and quick actions configured in your org. To launch Lightning Web Components from Work Steps, you must use QuickAction on the action definition. |
| ActionType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The type of platform action that the work step is associated with. (값: 아래 Enum 참조) |
| Description | textarea | Create, Filter, Nillable, Sort, Update | The description of the work step. |
| EndTime | dateTime | Create, Filter, Nillable, Sort, Update | The date and time the work step ends. The value must be greater than or equal to StartTime. |
| ExecutionOrder | int | Create, Filter, Group, Nillable, Sort, Update | The order in which the work step is executed. Only positive integer values or null are supported. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last interacted with this record, directly or indirectly. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, it's possible that the user only accessed this record or list view (LastReferencedDate), but not viewed it. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | Required. The user-defined name of the work step. |
| PausedFlowInterviewId | reference | Create, Filter, Group, Nillable, Sort, Update | The auto-populated ID of the flow interview paused by a user. |
| ProcessType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The flow process type launched from the work step. (값: 아래 Enum 참조) |
| StartTime | dateTime | Create, Filter, Nillable, Sort, Update | The date and time the work step starts. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The customizable status of the work order. Every status must be mapped to a status category, but there can be status categories not mapped to a status. (값: 아래 Enum 참조) |
| StatusCategory | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The category that each status value belongs to. Each default status category is mapped to the corresponding default status. If you create a custom status, you must indicate which status category it belongs to. To learn which processes reference StatusCategory, see How are Status Categories Used?. (값: 아래 Enum 참조) |
| WorkOrderId | reference | Filter, Group, Sort | The ID of the work order. |
| WorkOrderLineItemId | reference | Filter, Group, Nillable, Sort | The ID of the work order line item. |
| WorkPlanExecutionOrder | int | Filter, Group, Nillable, Sort | The ID of the plan execution order. [sic — type=int인데 설명이 "ID of the plan execution order"로 표기됨. 원문 그대로] |
| WorkPlanId | reference | Create, Filter, Group, Sort | The ID of the work plan. |

**Enum / Picklist 값:**
- **ActionType:** Flow, QuickAction
- **ProcessType:**
  - `DataCaptureFlow` — Data Capture Flow
  - `DiscoveryFrameworkFlow` — Discovery Framework Data Capture Flow (Beta)
  - `FieldServiceMobileFlow` — Field Service Mobile Flow
  - The default value is `DataCaptureFlow`.
- **Status:** Completed, In Progress, New, Not Applicable, Paused
- **StatusCategory:** Completed, InProgress, New, NotApplicable, Paused

**Associated Objects:** `WorkStepChangeEvent` — change events; `WorkStepFeed` — feed tracking; `WorkStepHistory` — 추적 필드 히스토리.

---

## 6. WorkStepStatus

작업 단계의 **상태 카테고리에 대한 피크리스트(picklist)**를 나타낸다. v52.0+.

**Supported Calls:** `describeSObjects()`, `query()`, `retrieve()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiName | string | Filter, Group, idLookup, Sort | Required. The name of the work step status. |
| IsDefault | boolean | Defaulted on create, Filter, Group, Sort | Controls whether this status is the default value of the picklist of the corresponding status category (true) or not (false). Default is false. |
| MasterLabel | string | Filter, Group, Nillable, Sort | Required. The label of the work step status. |
| SortOrder | int | Filter, Group, Nillable, Sort | Required. The order in which the work step statuses are displayed in the status category's picklist. |
| StatusCode | picklist | Required. Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The status category that this status belongs to. (값: 아래 Enum 참조) [sic — Properties 셀 첫머리에 "Required."가 포함됨. 원문 그대로] |

**Enum / Picklist 값:**
- **StatusCode:** Completed, InProgress, New, NotApplicable, Paused

**Associated Objects:** (PDF에 Associated Objects 섹션 없음 — 바로 WorkStepTemplate로 이어짐)

---

## 7. WorkStepTemplate

작업 단계에 대한 **템플릿**을 나타낸다. v52.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| ActionDefinition | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The platform action that the work step executes. The possible values are the names of the flow and quick actions configured in your org. |
| ActionType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The type of platform action that the work step is associated with. (값: 아래 Enum 참조) |
| Description | textarea | Create, Filter, Nillable, Sort, Update | The description of the work step template. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Controls whether this work step template is active true or not false. Default is false. [sic — true/false에 괄호 없음. 원문 그대로] |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last interacted with this record, directly or indirectly. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, it's possible that the user only accessed this record or list view (LastReferencedDate), but not viewed it. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The user-defined name of the work step template. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The ID of the owner who created the work step template. |

**Enum / Picklist 값:**
- **ActionType:** Flow, QuickAction

**Associated Objects:** `WorkStepTemplateChangeEvent` — change events; `WorkStepTemplateFeed` — feed tracking; `WorkStepTemplateHistory` — 추적 필드 히스토리; `WorkStepTemplateOwnerSharingRule` — sharing rules; `WorkStepTemplateShare` — sharing.

---

## 8. WorkType

Field Service 및 Lightning Scheduler에서 수행할 **작업 유형(work type)**을 나타낸다. 작업 주문/작업 주문 라인 항목에 적용할 수 있는 템플릿이다. v38.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | The description of the work type. Try to add details about the task or tasks that this work type represents. |
| DurationType | picklist | Create, Filter, Group, Defaulted on create, Restricted picklist, Sort, Update | The unit of the Estimated Duration: Minutes or Hours. (값: 아래 Enum 참조) |
| EstimatedDuration | double | Create, Filter, Sort, Update | The estimated length of the work. The estimated duration is in minutes or hours based on the value selected in the Duration Type field. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the work type was last modified. Its label in the user interface is Last Modified Date. [sic — LastReferencedDate인데 설명이 "last modified"로 다른 객체와 다름. 원문 그대로] |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the work type was last viewed by the current user. |
| MinimumCrewSize | int | Create, Filter, Group, Nillable, Sort, Update | The minimum crew size allowed for a crew assigned to the work. Work orders and work order line items inherit their work type's minimum crew size. If you're not using the Field Service managed package, this field serves as a suggestion rather than a rule. If you are using the managed package, the scheduling optimizer counts the number of service crew members on a service crew to determine whether it fits the minimum crew size requirement. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the work type. Try to use a name that helps users quickly understand the type of work orders that can be created from the work type. For example, "Annual Refrigerator Maintenance" or "Valve Replacement." |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The work type's owner. This is a polymorphic relationship field. RelName: Owner; RelType: Lookup; Refers To: Group, User. |
| RecommendedCrewSize | int | Create, Filter, Group, Nillable, Sort, Update | The recommended number of people on the service crew assigned to the work. For example, you might have a Minimum Crew Size of 2 and a Recommended Crew Size of 3. Work orders and work order line items inherit their work type's recommended crew size. |
| SaDocumentTemplate | string | Create, Filter, Group, Nillable, Sort, Update | The document template ID. If ServiceDocumentTemplateId isn't specified, this document template ID determines which service document template is used for service documents generated from a service appointment. The ID is 15 to 18 characters long. |
| ServiceReportTemplateId | reference | Create, Filter, Group, Nillable, Sort, Update | The service report template associated with the work type. When users create service reports from a work order or work order line item that uses this work type, the reports use this template. |
| ShouldAutoCreateSvcAppt | boolean | Create, Filter, Group, Defaulted on create, Sort, Update | Select this option to have a service appointment automatically created on work orders and work order line items that use the work type. (아래 Note 참조) |
| WoDocumentTemplate | string | Create, Filter, Group, Nillable, Sort, Update | The document template ID. If ServiceDocumentTemplateId isn't specified, this document template ID determines which service document template is used for service documents generated from a work order. The ID is 15 to 18 characters long. |
| WoliDocumentTemplate | string | Create, Filter, Group, Nillable, Sort, Update | The document template ID. If ServiceDocumentTemplateId isn't specified, this document template ID determines which service document template is used for service documents generated from a work order line item. The ID is 15 to 18 characters long. |

**Enum / Picklist 값:**
- **DurationType:** Minutes, Hours

**Field-level Note (ShouldAutoCreateSvcAppt, 원문):**
> Note:
> - By default, the Due Date on auto-created service appointments is seven days after the created date. Admins can adjust this offset from the Field Service Settings page in Setup.
> - If a work type with the Auto-Create Service Appointment option selected is added to an existing work order or work order line item, a service appointment is only created for the work order or work order line item if it doesn't yet have one.
> - If someone updates an existing work type by selecting the Auto-Create Service Appointment option, service appointments aren't created on work orders and work order line items that were already using the work type.

**Usage:**
> Adding a work type to a work order or work order line item causes the record to inherit the work type's duration values and required skills and products.
> Note:
> - If needed, you can update the duration values and required skills and products on a work order or work order line item after they're inherited from the work type.
> - If a work order or work order line item already has required skills or products, associating it with a work type doesn't cause it to inherit the work type's requirements.
> - If a work order or work order line item already has a duration value in its Duration field, associating it with a work type doesn't cause it to inherit the work type's duration value.
> - Customizations to required skills or products, such as validation rules or Apex triggers, are not carried over from work types to work orders and work order line items.

**Associated Objects:** `WorkTypeChangeEvent` (v48.0) — change events; `WorkTypeFeed` — feed tracking; `WorkTypeHistory` — 추적 필드 히스토리; `WorkTypeOwnerSharingRule` — sharing rules; `WorkTypeShare` — sharing.

---

## 9. WorkTypeGroup

작업 유형의 **그룹**을 나타낸다. Lightning Scheduler에서 가능한 약속 유형을 분류하거나 Field Service에서 스케줄링 한도(work capacity limit)를 정의하는 데 사용한다. v45.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** (PDF에 Special Access Rules 섹션 없음 — Supported Calls 다음 바로 Fields)

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| AdditionalInformation | multipicklist | Create, Filter, Nillable, Update | Additional information about the types of appointments this work type group represents. |
| Description | textarea | Create, Nillable, Update | A description of this work type group. |
| GroupType | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | The category of this work type group. (값: 아래 Enum 참조) |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether this work type group can be used for appointment scheduling or work capacity limits. A work type can belong to only one active work type group of type Capacity. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date and time that the current user last viewed a record related to this object. [sic — LastReferencedDate인데 설명이 "last viewed". 원문 그대로] |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed this object. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of this work type group. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The ID of the user who created this record. This is a polymorphic relationship field. RelName: Owner; RelType: Lookup; Refers To: Group, User. |

**Enum / Picklist 값:**
- **GroupType:**
  - `Capacity` — A group of work types used to define a work capacity limit in Field Service.
  - `Default` — A non-capacity group of work types used in Lightning Scheduler.

**Associated Objects:** `WorkTypeGroupFeed` — feed tracking; `WorkTypeGroupHistory` — 추적 필드 히스토리; `WorkTypeGroupOwnerSharingRule` — sharing rules; `WorkTypeGroupShare` — sharing.

---

## 10. WorkTypeGroupMember

작업 유형(work type)과 그것이 속한 **작업 유형 그룹(work type group) 간의 관계**를 나타낸다. v45.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** (PDF에 Special Access Rules 섹션 없음 — Supported Calls 다음 바로 Fields)

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date and time that the current user last viewed a record related to this object. [sic — LastReferencedDate인데 설명이 "last viewed". 원문 그대로] |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed this object. |
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Autogenerated number identifying the work type group membership. It uses the format ########. |
| WorkTypeGroupId | reference | Create, Filter, Group, Sort | The ID of the work type group that this record belongs to. This is a relationship field. RelName: WorkTypeGroup; RelType: Lookup; Refers To: WorkTypeGroup. |
| WorkTypeId | reference | Create, Filter, Group, Sort | The ID of the work type that this record corresponds to. This is a relationship field. RelName: WorkType; RelType: Lookup; Refers To: WorkType. |

**Associated Objects:** `WorkTypeGroupMemberFeed` — feed tracking; `WorkTypeGroupMemberHistory` — 추적 필드 히스토리.

---

## [sic] 보존 표기 모음

PDF 원문의 오기·비일관 표기를 교정하지 않고 그대로 옮긴 5개 지점:

1. **WorkStep.WorkPlanExecutionOrder** — type=int인데 Description="The ID of the plan execution order." (ID 표현이 int 필드에 부자연).
2. **WorkStepStatus.StatusCode** — Properties 셀 첫머리에 "Required."가 포함됨("Required. Defaulted on create, …").
3. **WorkStepTemplate.IsActive** — "active true or not false. Default is false." (true/false 괄호 없이 표기).
4. **WorkType.LastReferencedDate** — Description="The date when the work type was last modified. … Last Modified Date." (다른 객체의 표준 LastReferencedDate 설명과 다르게 "last modified"로 기재).
5. **WorkTypeGroup.LastReferencedDate** 및 **WorkTypeGroupMember.LastReferencedDate** — 둘 다 Description="last viewed a record related to this object"로 LastViewedDate스러운 설명.

---

## 관련 노트

- [[Field Service 개요와 데이터 모델]] — Field Service 데이터 모델·ER 다이어그램과 이 클러스터(Work Plan/Step → Work Order, Work Type 템플릿)의 위치
- [[Field Service Objects]] — FSL 표준 객체(WorkOrder·ServiceAppointment·WorkType 등) 색인
- [[객체 레퍼런스 — Work Order·WorkOrderLineItem·Status]] — WorkPlan.WorkOrderId·WorkStep.WorkOrderId·WorkType이 적용되는 작업 주문 도메인
- [[객체 레퍼런스 — Service Appointment·Resource]] — WorkType.ShouldAutoCreateSvcAppt가 생성하는 ServiceAppointment·리소스 도메인 객체
- [[객체 레퍼런스 — Service Report·Layout·DigitalSignature]] — WorkType.ServiceReportTemplateId가 참조하는 서비스 리포트 템플릿 도메인
