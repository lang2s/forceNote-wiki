---
tags: [field-service, fsl, sobject, object-reference, maintenance-plan, maintenance-asset, maintenance-work-rule, product-service-campaign, location, preventive-maintenance, 현장서비스, 예방유지보수]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [MaintenancePlan, MaintenanceAsset, MaintenanceWorkRule, ProductServiceCampaign, ProductServiceCampaignItem, ProductServiceCampaignItemStatus, ProductServiceCampaignStatus, Location, 유지보수 계획, 유지보수 자산, 제품 서비스 캠페인, 위치, 예방 유지보수 객체]
---

# 객체 레퍼런스 — Maintenance·Product Service Campaign·Location

> Field Service의 예방 유지보수(Preventive Maintenance), 제품 서비스 캠페인(Product Service Campaign, 리콜·결함 수정), 위치(Location) 클러스터 8개 표준 객체의 필드·Supported Calls·Associated Objects 전수 레퍼런스.

> 데이터 모델 전체 그림(Preventive Maintenance / Product Service Campaign / Core Data Model ER)과 이 클러스터의 위치는 [[Field Service 개요와 데이터 모델]] 참조. 다른 FSL 표준 객체(ServiceAppointment·WorkOrder 등) 색인은 [[Field Service Objects]] 참조. MaintenancePlan에서 Apex로 작업 지시서를 생성하는 예제는 [[Field Service Custom Triggers·Code Examples]] 참조.

---

## Location

현장 서비스 작업이 수행되는 지역의 창고·서비스 차량·작업장 등 요소를 나타낸다. API version 49.0 이상에서 특정 위치에 활동(activity)을 연결할 수 있고, 위치 상세 페이지의 활동 타임라인에 위치 관련 task·event가 표시된다. 49.0 이상에서 Work.com 사용자는 Location 레코드에서 Employees를 관련 목록으로 볼 수 있다. API version 51.0 이상에서는 Omnichannel Inventory에서 사용 가능하며 주문 이행을 위한 재고가 있는 물리적 위치를 나타낸다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** 다음 기능 중 최소 하나가 활성화되어야 한다 — Commerce Store, Contact Tracing for Employees, Employee Experience, Field Service, Fulfillment Orders, Health Cloud, Industries Insurance, Industries Visit, Locations, Omnichannel Inventory, Public Sector, Retail Execution, Work.com.

**Fields:**

| Field Name | Type | Properties | Description |
|---|---|---|---|
| AssignedFoCount | int | Create, Filter, Group, Nillable, Sort, Update | The number of fulfillment orders assigned to the location. Confirming held fulfillment order capacity increments this value. To reset the location's capacity, set this value to 0. Available when Order Management is installed and configured. By default, it's hidden by field-level security. Available in API version 55.0 and later. |
| CloseDate | date | Create, Filter, Group, Nillable, Sort, Update | Date the location closed or went out of service. |
| ConstructionEndDate | date | Create, Filter, Group, Nillable, Sort, Update | Date construction ended at the location. |
| ConstructionStartDate | date | Create, Filter, Group, Nillable, Sort, Update | Date construction began at the location. |
| DefaultPickupTime | time | Create, Filter, Group, Nillable, Sort, Update | Default pickup time at the location. Available when Order Management is installed and configured. By default, it's hidden by field-level security. Available in API version 61.0 and later. |
| DefaultProcessingTime | int | Create, Filter, Group, Nillable, Sort, Update | Default processing time at the location. Available when Order Management is installed and configured. By default, it's hidden by field-level security. Available in API version 61.0 and later. |
| DefaultProcessingTimeUnit | picklist | Create, Filter, Group, Nillable, Sort, Update | Default processing time unit at the location. Possible values are: Hours, Days, Weeks. Available when Order Management is installed and configured. By default, it's hidden by field-level security. Available in API version 61.0 and later. |
| Description | string | Create, Filter, Group, Nillable, Sort, Update | A brief description of the location. |
| DrivingDirections | string | Create, Filter, Nillable, Sort, Update | Directions to the location. |
| EarliestPickupTimeOffset | integer | Create, Filter, Nillable, Sort, Update | The earliest pickup time for BOPIS. This value is measured in minutes after the start of business hours. |
| ExternalReference | string | Create, Filter, Group, Nillable, Sort, Update | Identifier of a location. |
| FoCapacity | int | Create, Filter, Group, Nillable, Sort, Update | The maximum number of fulfillment orders that can be assigned to the location per time period. If this value is null, then this location's capacity isn't limited. Available when Order Management is installed and configured. By default, it's hidden by field-level security. Available in API version 55.0 and later. |
| FulfillingBusinessHours | reference | Create, Filter, Group, Nillable, Sort, Update | Fulfilling business hours at the location. Available when Order Management is installed and configured. By default, it's hidden by field-level security. Available in API version 61.0 and later. |
| FoCapacity [sic — PDF 원문에 두 번째로 중복 등장] | int | Create, Filter, Group, Nillable, Sort, Update | (동일 정의) The maximum number of fulfillment orders that can be assigned to the location per time period. If this value is null, then this location's capacity isn't limited. Available when Order Management is installed and configured. Hidden by FLS by default. Available in API version 55.0 and later. |
| IsEligibleForPickup | boolean | Create, Filter, Nillable, Sort, Update | Indicates whether the location supports BOPIS |
| IsInventoryLocation | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the location stores parts. Note: This field must be selected if you want to associate the location with product items. |
| IsMobile | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the location moves. For example, a truck or tool box. |
| LastReferencedDate | datetime | Filter, Nillable, Sort | The date when the location was last modified. Its label in the user interface is Last Modified Date. |
| LastViewedDate | datetime | Filter, Nillable, Sort | The date the location was last viewed. |
| LatestPickupTimeOffset | integer | Create, Filter, Nillable, Sort, Update | The latest pickup time for BOPIS. This value is measured in minutes before the end of business hours. |
| Latitude | double | Create, Filter, Nillable, Sort, Update | The latitude of the location. |
| Location | location | Nillable | The geographic location. |
| LocationLevel | int | Filter, Group, Nillable, Sort | The location's position in a location hierarchy. If the location has no parent or child locations, its level is 1. Locations that belong to a hierarchy have a level of 1 for the root location, 2 for the child locations of the root location, 3 for their children, and so forth. |
| LocationType | picklist | Create, Filter, Group, Sort, Update | Picklist of location types. It has no default values, so you must populate it before creating any location records. |
| LogoId | reference | Create, Filter, Group, Nillable, Sort, Update | A ContentAsset representing a logo for the location. Available in API version 50.0 and later. Relationship field. Relationship Name: Logo. Relationship Type: Lookup. Refers To: ContentAsset. |
| Longitude | double | Create, Filter, Nillable, Sort, Update | The longitude of the location. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the location. For example, Service Van #4. |
| OpenDate | date | Create, Filter, Group, Nillable, Sort, Update | Date the location opened or came into service. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The location's owner or driver. Polymorphic relationship field. Relationship Name: Owner. Relationship Type: Lookup. Refers To: Group, User. |
| ParentLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | The location's parent location. For example, if vans are stored at a warehouse when not in service, the warehouse is the parent location. Relationship field. Relationship Name: ParentLocation. Relationship Type: Lookup. Refers To: Location. |
| PickupProcessingTime | integer | Create, Filter, Nillable, Sort, Update | The processing time required for BOPIS orders at this location. |
| PossessionDate | date | Create, Filter, Group, Nillable, Sort, Update | The date the location was purchased. |
| Priority | picklist | Create, Filter, Group, Nillable, Sort, Update | The priority of the location when routing orders. No default values are included. Add values to the picklist and reference them in your custom routing logic. Available when Order Management is installed and configured. Hidden by FLS by default. Available in API version 55.0 and later. |
| RemodelEndDate | date | Create, Filter, Group, Nillable, Sort, Update | Date when remodel construction ended at the location. |
| RemodelStartDate | date | Create, Filter, Group, Nillable, Sort, Update | Date when remodel construction started at the location. |
| RootLocationId | reference | Filter, Group, Nillable, Sort | (Read Only) The top-level location in the location's hierarchy. Relationship field. Relationship Name: RootLocation. Relationship Type: Lookup. Refers To: Location. |
| ShouldSyncWithOci | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the location should sync its data with Omnichannel Inventory. The default value is false. Available in API version 51.0 and later. |
| ShouldTrackFoCapacity | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the location should track its fulfillment order capacity. The default value is false. Available when Order Management is installed and configured. Hidden by FLS by default. Available in API version 55.0 and later. |
| TimeZone | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Picklist of available time zones. |
| VisitorAddressId | reference | Create, Filter, Group, Nillable, Sort, Update | Lookup to an account's or client's address. Relationship field. Relationship Name: VisitorAddress. Relationship Type: Lookup. Refers To: Address. |

**Usage:** Location 레코드를 만들기 전 Location Type 픽리스트에 값을 최소 하나 추가해야 한다 — LocationType은 필수 필드다. Salesforce에서 재고를 추적하려면 product item을 생성한다(특정 위치의 특정 제품 재고를 나타냄). 예: Warehouse A 위치에 재고로 있는 볼트 500개를 나타내는 product item 생성. 각 product item은 위치에 연결되어야 한다. 더 세분화된 현장 서비스 운영 그림을 위해 위치를 service territory와 연결한다 — 예: 창고가 특정 service territory 안에 있다면 service territory location으로 추가한다.

> [!important] Salesforce의 "Location"은 많은 표준 객체에 있는 geolocation 복합 필드(compound field)를 가리킬 수도 있다. Apex 코드에서 Location **객체**를 참조할 때는 표준 Location 복합 필드와의 혼동을 막기 위해 항상 `Location` 대신 `Schema.Location`을 사용한다. 같은 스니펫에서 Location 객체와 Location 필드를 모두 참조하면, 필드에는 `System.Location`, 객체에는 `Schema.Location`을 써서 둘을 구분할 수 있다.

```apex
// 구조 예시 — 실제 동작 코드 아님 (PDF 본문 가이드를 코드로 표현)
Schema.Location loc = new Schema.Location();   // Location 객체
loc.Name = 'Service Van #4';
System.Location geo = loc.Location;            // geolocation 복합 필드
```

**Associated Objects:** (별도 명시 없으면 이 객체와 동일 API 버전부터 사용 가능)
- LocationChangeEvent (API version 48.0) — Change events are available for the object.
- LocationFeed — Feed tracking is available for the object.
- LocationHistory — History is available for tracked fields of the object.
- LocationOwnerSharingRule — Sharing rules are available for the object.
- LocationShare — Sharing is available for the object.

---

## MaintenanceAsset

현장 서비스에서 유지보수 플랜이 적용되는(covered) 자산을 나타낸다. 자산은 여러 유지보수 플랜과 연결될 수 있다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Field Service must be enabled.

**Fields:**

| Field Name | Type | Properties | Description |
|---|---|---|---|
| AssetId | reference | Create, Filter, Group, Sort, Update | The asset associated with the maintenance asset. |
| ContractLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | Contract line item associated with the maintenance asset. This field can only list a contract line item that is associated with the asset, and whose parent service contract is associated with the parent maintenance plan. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the maintenance asset was last modified. Its label in the user interface is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the product request was last viewed. [sic — PDF 원문 "product request"] |
| MaintenanceAssetNumber | string | Autonumber, Defaulted on create, Filter, Sort | An auto-assigned number that identifies the maintenance asset. |
| MaintenancePlanId | reference | Create, Filter, Group, Sort | Maintenance plan associated with the maintenance asset. |
| NextSuggestedMaintenanceDate | date | Create, Filter, Group, Nillable, Sort, Update | The suggested date of service for the maintenance asset's first work order (not the date the work order is created). This corresponds to the work order's SuggestedMaintenanceDate. If left blank when the maintenance asset is created, this field inherits its initial value from the related maintenance plan. This field auto-updates after each batch is generated. Its label in the user interface is Date of the first work order in the next batch. |
| WorkTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | Work type associated with the maintenance asset. Work orders generated from the maintenance plan inherit its work type's duration, required skills and products, and linked articles. Maintenance assets covered by the plan use the same work type, though you can update them to use a different one. |

**Associated Objects:** (API 버전이 명시되지 않으면 이 객체와 동일 API 버전부터 사용 가능)
- MaintenanceAssetChangeEvent (API version 48.0) — Change events are available for the object.
- MaintenanceAssetFeed — Feed tracking is available for the object.
- MaintenanceAssetHistory — History is available for tracked fields of the object.

---

## MaintenancePlan

하나 이상의 자산에 대한 예방 유지보수(preventive maintenance) 스케줄을 나타낸다. 이 객체에서 작업 지시서(work order) 배치를 자동/수동으로 생성한다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Field Service must be enabled.

**Fields:**

| Field Name | Type | Properties | Description |
|---|---|---|---|
| AccountId | reference | Create, Filter, Group, Nillable, Sort, Update | The associated account, which typically represents the customer receiving the maintenance service. |
| ContactId | reference | Create, Filter, Group, Nillable, Sort, Update | The associated contact. |
| Description | textarea | Create, Nillable, Update | A brief description of the plan. |
| DoesAutoGenerateWorkOrders | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Turns on auto-generation of work order batches for a maintenance plan and prohibits the manual generation of work orders via the Generate Work Orders action. If this option is selected, a new batch of work orders is generated for the maintenance plan on the NextSuggestedMaintenanceDate listed on each maintenance asset, or on the maintenance plan if no assets are included. If a GenerationHorizon is specified, the date of generation is that many days earlier. |
| DoesGenerateUponCompletion | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | If both this option and DoesAutoGenerateWorkOrders are set to true, a new batch of work orders isn't generated until the last work order generated from the maintenance plan is completed. A work order is considered completed when its status falls into one of the following status categories: Cannot Complete, Canceled, Completed, or Closed. If a maintenance plan covers multiple assets, work orders are generated per asset. If a maintenance asset's final work order is completed late, its work order generation is delayed, which may cause a staggered generation schedule between maintenance assets. |
| EndDate | date | Create, Filter, Group, Nillable, Sort, Update | The last day the maintenance plan is valid. |
| Frequency | int | Create, Filter, Group, Sort, Update | (Optional) Amount of time between work orders. The unit is specified in the FrequencyType field. |
| FrequencyType | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | (Optional) The unit of frequency: Days, Weeks, Months, Years. For example, to perform monthly maintenance visits you need a work order for each visit, so enter 1 as the Frequency and select Months. |
| GenerationHorizon | int | Create, Filter, Group, Nillable, Sort, Update | Moves up the timing of batch generation if DoesAutoGenerateWorkOrders is set to true. A generation horizon of 5 means the new batch of work orders is generated 5 days before the maintenance asset's (or maintenance plan's, if there are no assets) NextSuggestedMaintenanceDate. The generation horizon must be a whole number. |
| GenerationTimeframe | int | Create, Filter, Group, Sort, Update | (Required) How far in advance work orders are generated in each batch. The unit is specified in the GenerationTimeframeType field. |
| GenerationTimeframeType | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | (Required) The generation timeframe unit: Days, Weeks, Months, Years. For example, if you need work orders for six months, enter 6 and select Months. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last interacted with this record, directly or indirectly. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, it's possible that the user only accessed this record or list view (LastReferencedDate), but not viewed it. |
| LocationId | reference | Create, Filter, Group, Nillable, Sort, Update | Where the service takes place. |
| MaintenancePlanNumber | string | Autonumber, Defaulted on create, Filter, Sort | (Read Only) An auto-assigned number that identifies the maintenance plan. |
| MaintenancePlanTitle | string | Create, Filter, Group, Nillable, Sort, Update | A name for the maintenance plan. |
| MaintenanceWindowEndDays | int | Create, Filter, Group, Nillable, Sort, Update | Days after the suggested service date on the work order that its service appointment can be scheduled. |
| MaintenanceWindowStartDays | int | Create, Filter, Group, Nillable, Sort, Update | Days before the suggested service date on the work order that its service appointment can be scheduled. The maintenance window start and end fields affect the Earliest Start Permitted and Due Date fields on the maintenance plan's work orders' service appointments. For example, if you enter 3 for both the maintenance window start and end, the Earliest Start Permitted and the Due Date will be 3 days before and 3 days after, respectively, the Suggested Maintenance Date on each work order. If the maintenance window fields are left blank, the service appointment date fields list their work order's suggested maintenance date. |
| NextSuggestedMaintenanceDate | date | Create, Filter, Group, Sort, Update | The suggested date of service for the first work order (not the date the work order is created). This corresponds to the work order's SuggestedMaintenanceDate. You can use this field to enforce a delay before the first maintenance visit (for example, if monthly maintenance should begin one year after the purchase date). Its label in the user interface is Date of the first work order in the next batch. For example, if you want the first maintenance visit to take place on May 1, enter May 1. When you generate work orders, the earliest work order will list a suggested maintenance date of May 1, and the dates on the later work orders will be based on the GenerationTimeframe and Frequency. **Important:** Maintenance assets also list a NextSuggestedMaintenanceDate, which is initially inherited from the maintenance plan. If the plan has maintenance assets, this date auto-updates on the maintenance assets after each batch is generated, but doesn't update on the maintenance plan itself because batch timing is calculated at the maintenance asset level. If the plan doesn't have maintenance assets, this date auto-updates on the maintenance plan after each batch is generated. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The owner of the maintenance plan. |
| ServiceContractId | reference | Create, Filter, Group, Nillable, Sort, Update | The service contract associated with the maintenance plan. The service contract can't be updated if any child maintenance asset is associated with a contract line item from the service contract. |
| StartDate | date | Create, Filter, Group, Sort, Update | The first day the maintenance plan is valid. |
| SvcApptGenerationMethod | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | The service appointment generation method. • One service appointment per work order • One service appointment per work order line item. If your existing maintenance plans have work orders or work order line items associated with them, you can't change their generation methods. To change pre-existing maintenance plan generation methods, either delete the work orders and regenerate them or delete the maintenance plan and recreate it with the needed generation methods. If Work Order Generation Method is set to One work order per asset, you can't set a Service Appointment Generation Method. If Work Order Generation Method is set to One work order line item per asset, you must select a Service Appointment Generation Method. |
| WorkOrderGenerationMethod | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | The work order generation method. • One work order per asset • One work order line item per asset. If your existing maintenance plans have work orders or work order line items associated with them, you can't change their generation methods. To change pre-existing maintenance plan generation methods, either delete the work orders and regenerate them or delete the maintenance plan and recreate it with the needed generation methods. If Work Order Generation Method is left as None, the generation is defaulted to one work order per asset. When One work order line item per asset is set, and all maintenance assets have the same Next Suggested Maintenance Date on the maintenance plan, they are grouped in one work order. However, if maintenance assets have different Next Suggested Maintenance Dates, multiple work orders are created for each date. If Work Order Generation Method is set to One work order per asset, you can't set a Service Appointment Generation Method. |
| WorkOrderGenerationStatus | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | (Read Only) Indicates the status of work order generation: • NotStarted—the default value, work order generation has not started • InProgress—work order generation is underway • Completed—work order generation is complete • Unsuccessful—it was not possible to generate work orders. You can generate only one batch at a time. |
| WorkTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | The associated work type. Work orders generated from the maintenance plan inherit its work type's duration, required skills and products, and linked articles. Maintenance assets covered by the plan use the same work type, though you can update them to use a different one. |

**Associated Objects:** (API 버전이 명시되지 않으면 이 객체와 동일 API 버전부터 사용 가능)
- MaintenancePlanChangeEvent (API version 48.0) — Change events are available for the object.
- MaintenancePlanFeed — Feed tracking is available for the object.
- MaintenancePlanHistory — History is available for tracked fields of the object.
- MaintenancePlanOwnerSharingRule — Sharing rules are available for the object.
- MaintenancePlanShare — Sharing is available for the object.

---

## MaintenanceWorkRule

유지보수 레코드의 반복 패턴(recurrence pattern)을 나타낸다. API version 49.0 이상에서 사용 가능하다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

> Special Access Rules: PDF 원문에 이 객체의 Special Access Rules 섹션이 없다(누락이 아니라 원문에 존재하지 않음).

**Fields:** (PDF 원문 표 헤더가 다른 객체의 "Field Name"과 달리 "Field"임[sic])

| Field | Type | Properties | Description |
|---|---|---|---|
| DoesFloatingWorkOrder | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates that the maintenance plan uses the floating work order adjustment. The default is false. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the line item was last modified. Its label in the user interface is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the line item was last viewed. |
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of this maintenance work rule. |
| NextSuggestedMaintenanceDate | date | Create, Filter, Group, Nillable, Sort, Update | The next date on which this rule will generate maintenance items. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The assigned owner of the maintenance work rule. |
| ParentMaintenancePlanId | reference | Create, Filter, Group, Nillable, Sort, Update | The maintenance plan associated with the maintenance work rule. |
| ParentMaintenanceRecordId | reference | Create, Filter, Group, Nillable, Sort, Update | The maintenance record this work rule applies to. |
| RecordsetFilterCriteriaId | reference | Create, Filter, Group, Nillable, Sort, Update | ID of the recordset filter criteria associated with this maintenance work rule. Available in API version 52.0 and later. |
| RecurrencePattern | string | Create, Filter, Group, Nillable, Sort, Update | The RRULE that defines the pattern of recurrence for this work order rule. |
| SortOrder | int | Create, Filter, Group, Sort, Update | The sort order that applies to this work order rule. |
| Title | string | Create, Filter, Group, Sort, Update | The title of this work order rule. |
| Type | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The type of maintenance work rule. Available values are: • Criteria-based • Calendar-based (default). Available in API version 52.0 and later. |
| WorkTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the work type that this work order rule generates. |

**Associated Objects:** (별도 명시 없으면 이 객체와 동일 API 버전부터 사용 가능)
- MaintenanceWorkRuleChangeEvent — Change events are available for the object.
- MaintenanceWorkRuleFeed — Feed tracking is available for the object.
- MaintenanceWorkRuleHistory — History is available for tracked fields of the object.
- MaintenanceWorkRuleOwnerSharingRule — Sharing rules are available for the object.
- MaintenanceWorkRuleShare — Sharing is available for the object.

---

## ProductServiceCampaign

제품 서비스 캠페인 자산에 수행할 활동 집합을 나타낸다 — 예: 안전 문제나 제품 결함에 대한 제품 리콜. API version 51.0 이상에서 사용 가능하다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Field Service must be enabled.

**Fields:** (PDF 원문 표 헤더가 "Field"임[sic])

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | Description of the product service campaign. |
| EndDate | date | Create, Filter, Group, Nillable, Sort, Update | The date on which the product service campaign ends. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date and time that the asset was last modified. The UI label is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date and time that the asset was last viewed. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The product service campaign's owner. By default, the product service campaign owner is the user who created the product service campaign record. The UI label is Product Service Campaign Owner. |
| Priority | picklist | Create, Filter, Group, Nillable, Sort, Update | The priority of the product service campaign. Possible values are: • Critical • High • Low • Medium |
| Product2Id | reference | Create, Filter, Group, Nillable, Sort, Update | ID of the Product2 associated with this campaign. The UI label is Product. |
| ProductServiceCampaignName | string | Create, Filter, Group, idLookup, Sort, Update | The name of the product service campaign. |
| StartDate | date | Create, Filter, Group, Sort, Update | The date on which the product service campaign starts. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Sort, Update | The status of the product service campaign. The picklist includes the following values, which can be customized: • New—Product service campaign created, but there hasn't yet been any activity. • In Progress—Product service campaign has begun. • On Hold—Work is paused. • Completed—Work is complete. • Cannot Complete—Work couldn't be completed. • Closed—All work and associated activity is complete. • Canceled—Work is canceled, typically before any work began. |
| StatusCategory | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The category that each Status value falls into. The StatusCategory field has eight default values: seven values that are identical to the default Status values, and None for statuses without a status category. If you create custom Status values, you must indicate which category it belongs to. For example, if you create a Waiting for Response value, add it the On Hold category. [sic] To learn which processes reference StatusCategory, see How are Status Categories Used? |
| Type | picklist | Create, Filter, Group, Sort, Update | The type of the product service campaign. The picklist includes the following values, which can be customized: • Modification—The asset requires an on-site alteration. • Recall—The asset must be returned to the manufacturer for modification or upgrade. • Service—The asset needs to be serviced. • Upgrade—The asset needs updating. |
| WorkTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | The work type associated with the product service campaign. A customer uses this field as a guide when setting work type for work orders for the product service campaign. Duration, Duration Type, and required skills. |

**Associated Objects:** (별도 명시 없으면 이 객체와 동일 API 버전부터 사용 가능)
- ProductServiceCampaignFeed — Feed tracking is available for the object.
- ProductServiceCampaignHistory — History is available for tracked fields of the object.
- ProductServiceCampaignOwnerSharingRule — Sharing rules are available for the object.
- ProductServiceCampaignShare — Sharing is available for the object.

---

## ProductServiceCampaignItem

제품 서비스 캠페인의 자산을 나타낸다. API version 51.0 이상에서 사용 가능하다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Field Service must be enabled.

**Fields:** (PDF 원문 표 헤더가 "Field"임[sic])

| Field | Type | Properties | Description |
|---|---|---|---|
| AssetId | reference | Create, Filter, Group, Nillable, Sort, Update | The asset associated with the product service campaign. Must be present if Product2Id is not present. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date and time that the asset was last modified. Its UI label is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date and time that the asset was last viewed. |
| Product2Id | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the Product2 associated with this campaign. The UI label is Product. Must be present if AssetID is not present. |
| ProductServiceCampaignId | reference | Create, Filter, Group, Sort | Required. The item's parent product service campaign record. |
| ProductServiceCampaignItemNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | The ID of the product service campaign item. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Sort, Update | The status of the product service campaign item. The picklist includes the following values, which can be customized: • New—Product service campaign item created, but there hasn't yet been any activity. • In Progress—Product service campaign item has begun. • On Hold—Product service campaign item is paused. • Completed—Product service campaign item is complete. • Cannot Complete—Product service campaign item couldn't be completed. • Closed—All product service campaign item and associated activity is complete. • Canceled—Product service campaign item is canceled, typically before any work began. |
| StatusCategory | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The category that each Status value falls into. The StatusCategory field has eight default values: seven values that are identical to the default Status values, and None for statuses without a status category. If you create custom Status values, you must indicate which category it belongs to. For example, if you create a Waiting for Response value, add it to the On Hold category. To learn which processes reference StatusCategory, see How are Status Categories Used? |

**Associated Objects:** (별도 명시 없으면 이 객체와 동일 API 버전부터 사용 가능)
- ProductServiceCampaignItemFeed — Feed tracking is available for the object.
- ProductServiceCampaignItemHistory — History is available for tracked fields of the object.
- ProductServiceCampaignItemOwnerSharingRule — Sharing rules are available for the object.
- ProductServiceCampaignItemShare — Sharing is available for the object.

---

## ProductServiceCampaignItemStatus

현장 서비스에서 제품 서비스 캠페인 아이템의 상태값(status)을 나타내는 read-only 객체다. API version 51.0 이상에서 사용 가능하다.

**Supported Calls:** `describeSObjects()`, `query()`, `retrieve()` *(read-only 객체)*

**Special Access Rules:** Field Service must be enabled.

**Fields:** (PDF 원문 표 헤더가 "Field"임[sic])

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiName | string | Filter, Group, idLookup, Sort | The API name of the status value. |
| IsDefault | boolean | Defaulted on create, Filter, Group, Sort | Indicates that the status value is the default status on product service campaign items when true. Only one status value can be the default. |
| MasterLabel | string | Filter, Group, Nillable, Sort | The label for the picklist value in the UI. |
| SortOrder | int | Filter, Group, Nillable, Sort | The value's position in the dropdown list in the UI. |
| StatusCode | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The status category that the value corresponds to. The Status Category field has seven values that are identical to the default Status values. |

**Usage:** 제품 서비스 캠페인 아이템의 Status 필드는 다음 값을 기본 제공한다:
- New—Product service campaign item created, but there hasn't been any activity.
- In Progress—Work has begun.
- On Hold—Work is paused.
- Completed—Work is complete.
- Cannot Complete—Work couldn't be completed.
- Closed—All work and associated activity is complete.
- Canceled—Work is canceled, typically before any work began.

ProductServiceCampaignItemStatus 객체는 Status 필드에 대응한다. Status 필드에 값을 추가하면(예: Canceled By Supplier) product service campaign item status 레코드가 생성되며, 그 반대도 성립한다.

> Note: 제품 서비스 캠페인 아이템에는 기본 status 값과 동일한 값을 갖는 Status Category 필드도 함께 제공된다. 커스텀 status 값을 만들면 어느 카테고리에 속하는지 지정해야 한다 — 예: Customer Absent 값을 만들면 Cannot Complete 카테고리에 추가한다. StatusCategory를 참조하는 프로세스는 "How are Status Categories Used?" 참조.

> Associated Objects: PDF 원문에 이 객체의 Associated Objects 섹션이 없다.

---

## ProductServiceCampaignStatus

현장 서비스에서 제품 서비스 캠페인의 상태값(status)을 나타내는 read-only 객체다. API version 51.0 이상에서 사용 가능하다.

**Supported Calls:** `describeSObjects()`, `query()`, `retrieve()` *(read-only 객체)*

**Special Access Rules:** Field Service must be enabled.

**Fields:** (PDF 원문 표 헤더가 "Field"임[sic])

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiName | string | Filter, Group, idLookup, Sort | The API name of the status value. |
| IsDefault | boolean | Defaulted on create, Filter, Group, Sort | Indicates that the status value is the default status on product service campaigns when true. Only one status value can be the default. |
| MasterLabel | string | Filter, Group, Nillable, Sort | The label for the picklist value in the UI. |
| SortOrder | int | Filter, Group, Nillable, Sort | The value's position in the dropdown list in the UI. |
| StatusCode | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The status category that the value corresponds to. The Status Category field has seven values that are identical to the default Status values. |

**Usage:** 제품 서비스 캠페인의 Status 필드는 다음 값을 기본 제공한다:
- New—Product service campaign created, but there hasn't been any activity.
- In Progress—Work has begun.
- On Hold—Work is paused.
- Completed—Work is complete.
- Cannot Complete—Work couldn't be completed.
- Closed—All work and associated activity is complete.
- Canceled—Work is canceled, typically before any work began.

ProductServiceCampaignStatus 객체는 Status 필드에 대응한다. Status 필드에 값을 추가하면(예: Canceled By Supplier) product service campaign status 레코드가 생성되며, 그 반대도 성립한다.

> Note: 제품 서비스 캠페인에는 기본 status 값과 동일한 값을 갖는 Status Category 필드도 함께 제공된다. 커스텀 status 값을 만들면 어느 카테고리에 속하는지 지정해야 한다 — 예: Customer Absent 값을 만들면 Cannot Complete 카테고리에 추가한다. StatusCategory를 참조하는 프로세스는 "How are Status Categories Used?" 참조.

> Associated Objects: PDF 원문에 이 객체의 Associated Objects 섹션이 없다.

---

## 관련 노트
- [[Field Service 개요와 데이터 모델]] — Preventive Maintenance·Product Service Campaign·Core Data Model ER 다이어그램과 이 클러스터의 데이터 모델상 위치
- [[Field Service Objects]] — 다른 FSL 표준 객체(ServiceAppointment·WorkOrder·ServiceResource 등) 색인
- [[Field Service Custom Triggers·Code Examples]] — MaintenancePlan에서 작업 지시서를 생성하는 Generate Work Orders Apex 예제
- [[객체 레퍼런스 — Asset·Attribute·Warranty]] — MaintenanceAsset·ProductServiceCampaignItem이 참조하는 Asset 객체
- [[객체 레퍼런스 — Service Contract·Entitlement·Milestone]] — MaintenancePlan이 참조하는 ServiceContract·ContractLineItem
