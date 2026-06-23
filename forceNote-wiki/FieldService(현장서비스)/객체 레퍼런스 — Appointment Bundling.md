---
tags: [field-service, fsl, sobject, object-reference, appointment-bundling, 현장서비스, 예약번들, 객체레퍼런스]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [ApptBundleAggrDurDnscale, ApptBundleAggrPolicy, ApptBundleConfig, ApptBundlePolicy, ApptBundlePolicySvcTerr, ApptBundlePropagatePolicy, ApptBundleRestrictPolicy, ApptBundleSortPolicy, Appointment Bundling, 예약 번들, 번들 정책]
---

# 객체 레퍼런스 — Appointment Bundling

> Field Service Appointment Bundling(예약 번들링)을 구성하는 8개 표준 객체의 필드 전수 레퍼런스. `ApptBundlePolicy`를 허브로 집계·전파·제한·정렬·서비스영역 정책이 연결된다.

---

## 데이터 모델 개요

Appointment Bundling은 여러 서비스 약속(Service Appointment)을 하나의 번들로 묶어 처리하는 기능이다. 정책 객체들은 `ApptBundlePolicy`를 중심으로 구성된다.

- **`ApptBundlePolicy`** — 허브. 다음 객체들이 `BundlePolicyId`(Lookup → ApptBundlePolicy)로 연결된다: `ApptBundleAggrPolicy`, `ApptBundlePolicySvcTerr`, `ApptBundlePropagatePolicy`, `ApptBundleRestrictPolicy`, `ApptBundleSortPolicy`.
- **3단 체인:** `ApptBundlePolicy` → `ApptBundleAggrPolicy` → `ApptBundleAggrDurDnscale`. (`ApptBundleAggrDurDnscale`은 `BundleAggregationPolicyId`로 `ApptBundleAggrPolicy`에 연결)
- **`ApptBundleConfig`** — `BundlePolicyId`가 없는 독립 설정 객체. `OwnerId`(Group/User), `CriteriaForAutoUnbundlingId`(→ RecordsetFilterCriteria)를 보유.
- **`FilterCriteriaId`**(→ RecordsetFilterCriteria): `ApptBundleAggrPolicy`, `ApptBundlePolicy`에 존재.
- **`OwnerId`**(polymorphic → Group, User): `ApptBundleConfig`, `ApptBundlePolicy`에 존재.
- **API 버전:** 7개 객체는 API 54.0 이상, `ApptBundlePropagatePolicy`만 API 55.0 이상.

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (PDF는 알파벳순 카탈로그로 다이어그램 없음)
ApptBundlePolicy (허브)
├── ApptBundleAggrPolicy ──── ApptBundleAggrDurDnscale
├── ApptBundlePolicySvcTerr ─ ServiceTerritory
├── ApptBundlePropagatePolicy
├── ApptBundleRestrictPolicy
└── ApptBundleSortPolicy

ApptBundleConfig (독립 — BundlePolicyId 없음)
```

> **공통 항목 (8객체 전부 동일)**
>
> **Supported Calls (8객체 전부 동일):**
> `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
>
> **Special Access Rules (8객체 전부 동일, 3불릿):**
> - Field Service must be enabled.
> - Bundling must be enabled in the Field Service Settings.
> - The Field Service Admin, Field Service Bundle for Dispatcher, and Field Service Integration permission sets must be enabled.
>
> **Associated Objects:** 본 8객체 섹션에는 인라인 Associated Objects 언급 없음(이 PDF 카탈로그는 별도 Supplementary Objects 섹션에서 History/Feed/Share를 처리).
>
> **표준 시스템 필드:** `LastReferencedDate` / `LastViewedDate`는 8객체 전부에 존재(Type `dateTime`, Properties: Filter, Nillable, Sort). 설명 문구도 전부 동일하다.

---

## ApptBundleAggrDurDnscale

Sums the duration of the bundle members, reduced by a predefined percentage. This object is available in API version 54.0 and later.

**Supported Calls:** 8객체 공통 (위 참조)

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| BundleAggregationPolicyId | reference | Create, Filter, Group, Sort | The ID of the parent appointment bundle aggregation policy. This is a relationship field. (Name: BundleAggregationPolicy · Type: Lookup · Refers To: ApptBundleAggrPolicy) |
| FromBundleMemberNumber | int | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The number of the first bundle member to which the downscale is applied. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last accessed this record, a record related to this record, or a list view. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, the user might have only accessed this record or list view (LastReferencedDate) but not viewed it. |
| MaxReduction | int | Create, Filter, Group, Nillable, Sort, Update | The maximum reduction that can be applied to a bundle member. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the appointment bundle aggregation downscale policy. |
| PercentageOfReduction | int | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The percentage of duration reduction. |
| ToBundleMemberNumber | int | Create, Filter, Group, Nillable, Sort, Update | The number of the last bundle member to which the downscale is applied. |

**Special Access Rules:** 8객체 공통 (위 참조)

---

## ApptBundleAggrPolicy

Policy that defines how the property values of the bundle members are aggregated and assigned to the bundle. This object is available in API version 54.0 and later.

**Supported Calls:** 8객체 공통 (위 참조)

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| AggregationAction | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The aggregation action to be performed. Possible values are: All default and custom Service Appointment fields. |
| AggregationFieldType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The target field type in the bundle to which the aggregation is directed. Possible values are: • Boolean • Date • Numeric • Picklist • Picklist-Multi • Skills • String |
| AggregationOrder | int | Create, Defaulted on create, Filter, Group, idLookup, Nillable, Sort, Update | The order the aggregation is triggered. |
| BundleFieldName | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Name of the target field in the bundle where the value is taken from the bundle member. Possible values are: All default and custom Service Appointment fields. |
| BundleMemberAddiFieldName | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Name of an additional source field that is connected to the initial source field in the bundle member from which the value is taken. Possible values are: All default and custom Service Appointment fields. |
| BundleMemberFieldName | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Name of the source field in the bundle member from which the value is taken. Possible values are: All default and custom Service Appointment fields. |
| BundlePolicyId | reference | Create, Filter, Group, Sort | ID of the parent bundle policy. This is a relationship field. (Name: BundlePolicy · Type: Lookup · Refers To: ApptBundlePolicy) |
| ConstantValue | string | Create, Filter, Group, Nillable, Sort, Update | The constant value that is used in the aggregation. |
| DateValue | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Represents how the date value will be determined. Possible values are: • End of Day • Now • Null • Start of Day |
| DoesAllowDuplicateStrings | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if you want to allow the same string to appear more than once when using the 'Sum based on Bundle Members' action type. |
| DownscaleSortDirection | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Applies only if the Set Downscaled Duration action is set. The downscaling sorting direction of the bundle member service appointments, according to their duration. Possible values are: • Ascending • Descending |
| FilterCriteriaId | reference | Create, Filter, Group, Nillable, Sort, Update | The active recordset filter criteria used for aggregating the bundle members. This is a relationship field. (Name: FilterCriteria · Type: Lookup · Refers To: RecordsetFilterCriteria) |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last accessed this record, a record related to this record, or a list view. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, the user might have only accessed this record or list view (LastReferencedDate) but not viewed it. |
| MaxBundleDuration | int | Create, Filter, Group, Nillable, Sort, Update | The maximum bundle duration that can be accumulated from the bundle members (after downscaling). |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the appointment bundle aggregation policy. |
| ShouldUpdateOnCreationOnly | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if you want to update the field in the bundle only when it is created. |

**Special Access Rules:** 8객체 공통 (위 참조)

---

## ApptBundleConfig

Represents the general parameters that define the behavior of the bundle. This object is available in API version 54.0 and later.

**Supported Calls:** 8객체 공통 (위 참조)

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| AddToBundleStatuses | multipicklist | Create, Defaulted on create, Filter, Nillable, Update | The statuses of service appointment that are allowed to be bundled. Possible values are: • Accepted • Canceled • Cannot Complete • Completed • Dispatched • In Progress • None • Rejected • Scheduled. The default value is None. |
| BundleStatusesToPropagate | multipicklist | Create, Defaulted on create, Filter, Nillable, Update | The bundle statuses that when updated are inherited by the bundle members. Possible values are: • Accepted • Canceled • Cannot Complete • Completed • Dispatched • In Progress • None • Rejected • Scheduled. The default value is None. |
| CriteriaForAutoUnbundlingId | reference | Create, Filter, Group, Nillable, Sort, Update | The criteria that causes a bundle service appointment to be unbundled. This is a relationship field. (Name: CriteriaForAutoUnbundling · Type: Lookup · Refers To: RecordsetFilterCriteria) |
| DoesAddTravelTime | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If the bundle members aren't in the same location, add travel time between them to the bundle's duration according to their sort order. The default value is false. |
| DoesDeleteEmptyBundles | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If the bundle has no remaining bundle members, the bundle is deleted. |
| EmptyBundleStatus | picklist | Create, Defaulted on create, Filter, Group, Sort, Update | The status from the Canceled category that a bundle service appointment changes to if it has no remaining bundle members, but still appears in the appointment list. Possible values are determined by the org's statuses. The default value is None. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last accessed this record, a record related to this record, or a list view. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, the user might have only accessed this record or list view (LastReferencedDate) but not viewed it. |
| MemberStatusesNotToPropagate | multipicklist | Create, Defaulted on create, Filter, Nillable, Update | The bundle member statuses that aren't overridden when the bundle's status is updated. Possible values are: • Accepted • Canceled • Cannot Complete • Completed • Dispatched • In Progress • None • Rejected • Scheduled. The default value is None. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the Appointment Bundle Config. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | ID of the owner of this object. This is a polymorphic relationship field. (Name: Owner · Type: Lookup · Refers To: Group, User) |
| RemoveFromBundleStatuses | multipicklist | Create, Defaulted on create, Filter, Nillable, Update | The statuses of service appointments that are allowed to be removed from a bundle. Possible values are: • Accepted • Canceled • Cannot Complete • Completed • Dispatched • In Progress • None • Rejected • Scheduled. The default value is None. |
| StatusOnRemovalFromBundle | picklist | Create, Defaulted on create, Filter, Group, Sort, Update | The status that a service appointment is given when it's removed from a bundle. Possible values are: • Accepted • Canceled • Cannot Complete • Completed • Dispatched • In Progress • None • Rejected • Scheduled. The default value is None. |
| StatusesNotToUpdateOnUnbundle | multipicklist | Create, Defaulted on create, Filter, Nillable, Update | The statuses that aren't updated when a bundle is unbundled. Possible values are: • Accepted • Canceled • Cannot Complete • Completed • Dispatched • In Progress • None • Rejected • Scheduled. The default value is None. |

**Special Access Rules:** 8객체 공통 (위 참조)

---

## ApptBundlePolicy

Policy that defines how the bundling of service appointments should be handled. This object is available in API version 54.0 and later. 이 객체가 Appointment Bundling 데이터 모델의 허브다.

**Supported Calls:** 8객체 공통 (위 참조)

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| BundleEndTimeFieldName | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | If IsTimeCalcByBundleDurationField is true, this field represents the name of the field used for entering the end time of the bundle. |
| BundleStartTimeFieldName | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | If IsTimeCalcByBundleDurationField is true, this field represents the name of the field used for entering the start time of the bundle. |
| CanAllowSchleDepndInBundle | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | This field is reserved for future use. |
| ConstantTimeValue | int | Create, Filter, Group, Nillable, Sort, Update | If IsTimeCalcByBundleDurationField is true, this field represents the total time of the bundle as a preset constant value. |
| FilterCriteriaId | reference | Create, Filter, Group, Nillable, Sort, Update | The active recordset filter criteria used for the bundle members. Only service appointments that meet the criteria can be bundled. This is a relationship field. (Name: FilterCriteria · Type: Lookup · Refers To: RecordsetFilterCriteria) |
| IsAutomaticBundling | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if the policy is relevant for automatic bundling. |
| IsManualBundling | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if the policy is relevant for manual bundling. The default value is 'false'. |
| IsTimeCalcByBundleDurationFld | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if the bundle's duration is validated. If true, the bundle's start time is subtracted from the bundle's end time. If the result is a negative value, it uses ConstantTimeValue as the bundle's duration. The default value is 'false'. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last accessed this record, a record related to this record, or a list view. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, the user might have only accessed this record or list view (LastReferencedDate) but not viewed it. |
| LimitAmountOfBundleMembers | int | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The maximum number of bundle members that can be included in a bundle. |
| LimitDurationOfBundle | int | Create, Filter, Group, Nillable, Sort, Update | The maximum duration of a bundle. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | Name of the bundle policy. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | ID of the owner of this object. This is a polymorphic relationship field. (Name: Owner · Type: Lookup · Refers To: Group, User) |
| Priority | int | Create, Filter, Group, idLookup, Sort, Update | The priority level that this bundle policy should be given when the bundle policies are analyzed using the automatic mode. |

> **[sic] 원문 표기 보존:** 필드명은 `IsTimeCalcByBundleDurationFld`(끝이 `Fld`)이나, 설명 본문에서는 `IsTimeCalcByBundleDurationField`(`Field`)로 표기 — 둘 다 PDF 원문 그대로다. `CanAllowSchleDepndInBundle`도 원문의 축약 표기 그대로 보존.

**Special Access Rules:** 8객체 공통 (위 참조)

---

## ApptBundlePolicySvcTerr

Represents a link between the BundlePolicy and the ServiceTerritory. This object is available in API version 54.0 and later.

**Supported Calls:** 8객체 공통 (위 참조)

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| BundlePolicyId | reference | Create, Filter, Group, Sort | The ID of the parent bundle policy. This is a relationship field. (Name: BundlePolicy · Type: Lookup · Refers To: ApptBundlePolicy) |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last accessed this record, a record related to this record, or a list view. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, the user might have only accessed this record or list view (LastReferencedDate) but not viewed it. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the appointment bundle service territory. |
| ServiceTerritoryId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the service territory. This is a relationship field. (Name: ServiceTerritory · Type: Lookup · Refers To: ServiceTerritory) |

**Special Access Rules:** 8객체 공통 (위 참조)

---

## ApptBundlePropagatePolicy

Policy that defines which property values are inherited from the bundle to the bundle members or are assigned as constant values in the bundle members. This object is available in API version **55.0** and later. (8객체 중 유일하게 API 55.0 — 나머지 7개는 54.0)

**Supported Calls:** 8객체 공통 (위 참조)

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| AdditionalConstantValue | string | Create, Filter, Group, Nillable, Sort, Update | The additional constant value that is connected to the initial constant value to be added to the bundle members. |
| BundleFieldName | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Name of the source field in the bundle from which the value is taken. Possible values are: All default and custom Service Appointment fields. |
| BundleMemberFieldName | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Name of the target field in the bundle member where the value is inherited from the bundle. Possible values are: All default and custom Service Appointment fields. |
| BundlePolicyId | reference | Create, Filter, Group, Sort | ID of the parent bundle policy. This field is a relationship field. *([sic] — 원문이 "This **field is**", 다른 객체는 "This is")* (Name: BundlePolicy · Type: Lookup · Refers To: ApptBundlePolicy) |
| ConstantValue | string | Create, Filter, Group, Nillable, Sort, Update | The constant value to be added to the bundle members. |
| DateValue | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Represents how the date value is determined. Possible values are: • End of Day • Now • Null • Start of Day |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last accessed this record, a record related to this record, or a list view. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, the user might have only accessed this record or list view (LastReferencedDate) but not viewed it. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the appointment bundle propagation policy. |
| ShouldAddConstantValue | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if you want to enable adding a constant value to the bundle members. |
| ShouldUpdateOnAdd | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if you want to enable updating the fields of the bundle members when they are added to the bundle. |
| ShouldUpdateOnRemove | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if you want to enable updating the fields of the bundle members when they are removed from the bundle. |
| ShouldUpdateOnUnbundle | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if you want to enable updating the fields of the bundle members when performing the Unbundle action. |

**Special Access Rules:** 8객체 공통 (위 참조)

---

## ApptBundleRestrictPolicy

Policy that defines the restrictions that are considered while forming a bundle. This object is available in API version 54.0 and later.

**Supported Calls:** 8객체 공통 (위 참조)

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| BundlePolicyId | reference | Create, Filter, Group, Sort | ID of the parent bundle policy. This is a relationship field. (Name: BundlePolicy · Type: Lookup · Refers To: ApptBundlePolicy) |
| DoesAllowEmpty | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Allows a bundle member service appointment with an empty Restriction Field Name to be bundled. |
| DoesRestrictAutomaticMode | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if you want to apply this restriction when using the automatic mode. |
| DoesRestrictManualMode | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if you want to apply this restriction when using the manual mode. |
| IsRestrictByDateOnly | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if you want the bundle to be restricted according to the calendar date only, ignoring the time of day. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last accessed this record, a record related to this record, or a list view. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, the user might have only accessed this record or list view (LastReferencedDate) but not viewed it. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the appointment bundle restriction policy. |
| RestrictionFieldName | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Name of the field in the service appointment used for applying the restriction. Possible values are: All default and custom Service Appointment fields. |

**Special Access Rules:** 8객체 공통 (위 참조)

---

## ApptBundleSortPolicy

Policy that defines the properties by which the bundle members are sorted within the bundle. Can also be used in the automatic mode for determining the order of the automatic selection of bundle members. This object is available in API version 54.0 and later.

**Supported Calls:** 8객체 공통 (위 참조)

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| BundlePolicyId | reference | Create, Filter, Group, Sort | The ID of the parent bundle policy. This is a relationship field. (Name: BundlePolicy · Type: Lookup · Refers To: ApptBundlePolicy) |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last accessed this record, a record related to this record, or a list view. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, the user might have only accessed this record or list view (LastReferencedDate) but not viewed it. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | Name of the appointment bundle sort policy. |
| SortDirection | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The order of the appointments in a bundle. Possible values are: • Ascending • Descending |
| SortFieldName | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Name of the field in the service appointment used for sorting the bundle members. Possible values are: All default and custom Service Appointment fields. |
| SortOrder | int | Create, Defaulted on create, Filter, Group, idLookup, Nillable, Sort, Update | The order of fields used for sorting the bundle members. |
| SortType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The applied sort type for arranging the bundle. Sort for Automatic Bundling defines the order that automated bundling uses to examine the candidate service appointments to be bundled. Sort Within a Bundle defines the order of bundle members. It's also used when you unbundle to define the order that the service appointments are scheduled on the Gantt. Possible values are: • SortForAutomaticBundling—Sort For Automatic Bundling • SortWithinaBundle—Sort Within a Bundle |

**Special Access Rules:** 8객체 공통 (위 참조)

---

## 관련 노트
- [[Field Service 개요와 데이터 모델]] — Field Service 전체 데이터 모델 허브
- [[Field Service Objects]] — FSL 표준 객체 카탈로그 색인(ApptBundle* 계열 요약)
- [[Field Service REST API]] — Appointment Bundling 관련 REST 리소스
