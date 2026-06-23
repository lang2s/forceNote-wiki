---
tags: [field-service, fsl, sobject, object-reference, service-contract, entitlement, milestone, contract-line-item, contract-line-outcome, entity-milestone, 현장서비스, 객체레퍼런스]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [ServiceContract, ContractLineItem, ContractLineOutcome, ContractLineOutcomeData, Entitlement, EntityMilestone, 서비스 계약, 계약 라인 항목, 엔타이틀먼트, 객체 마일스톤]
---

# 객체 레퍼런스 — Service Contract·Entitlement·Milestone

> Field Service Developer Guide v67.0 기준, 서비스 계약·엔타이틀먼트·마일스톤 클러스터 6개 표준 객체(ContractLineItem·ContractLineOutcome·ContractLineOutcomeData·Entitlement·EntityMilestone·ServiceContract)의 Supported Calls·전 필드·접근 규칙 전수 레퍼런스.

---

이 노트는 서비스 계약 라인업의 6개 객체를 다룬다. 데이터 모델 전체 그림과 핵심 객체(WorkOrder·ServiceAppointment 등) 관계는 [[Field Service 개요와 데이터 모델]], 객체 카탈로그 색인은 [[Field Service Objects]]를 참조한다.

```apex
// 구조 예시 — 실제 동작 코드 아님
// 서비스 계약과 그 라인 항목·엔타이틀먼트를 한 번에 조회하는 SOQL 형태
List<ServiceContract> contracts = [
    SELECT Id, Name, AccountId, StartDate, EndDate, GrandTotal,
           (SELECT Id, LineItemNumber, Product2Id, Quantity, UnitPrice
            FROM ContractLineItems),
           (SELECT Id, Name, Status, StartDate, EndDate FROM Entitlements)
    FROM ServiceContract
    WHERE Status = 'Active'
];
```

> 표기 규칙: 아래 모든 Fields 표는 소스 PDF의 Type / Properties / Description을 그대로 옮긴 전수 목록이다. `Special Access Rules` 섹션은 **원문에 해당 섹션이 존재하는 객체에만** 둔다(ContractLineOutcome·ContractLineOutcomeData·EntityMilestone). 나머지 3개 객체에는 원문에 섹션 자체가 없어 작성하지 않는다.

---

## ContractLineItem

서비스 계약(고객 지원 계약)이 보장하는 제품을 나타낸다. API version 18.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Fields (전 20필드):**

| Field | Type | Properties | Description |
|---|---|---|---|
| AssetId | reference | Create, Filter, Nillable, Update | Required. ID of the Asset associated with the contract line item. Must be a valid asset ID. |
| Description | textarea | Create, Nillable, Update | Description of the contract line item. |
| Discount | percent | Create, Filter, Nillable, Update | The discount for the product as a percentage. When updating, if you specify Discount without specifying TotalPrice, the TotalPrice will be adjusted to accommodate the new Discount value, and the UnitPrice will be held constant. If you specify both Discount and Quantity, you must also specify either TotalPrice or UnitPrice so the system can determine which one to automatically adjust. |
| EndDate | date | Create, Filter, Nillable, Update | The last day the contract line item is in effect. |
| LastReferencedDate | date | Filter, Nillable, Sort, Update | The timestamp when the current user last accessed this record, a record related to this record, or a list view. |
| LastViewedDate | date | Filter, Nillable, Sort, Update | The timestamp when the current user last viewed this record or list view. If this value is null, the user might have only accessed this record or list view (LastReferencedDate) but not viewed it. |
| LineItemNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Update | Automatically-generated number that identifies the contract line item. |
| ListPrice | currency | Filter, Nillable | Corresponds to the UnitPrice on the PricebookEntry that is associated with this line item, which can be in the standard pricebook or a custom pricebook. A client application can use this information to show whether the unit price (or sales price) of the line item differs from the pricebook entry list price. |
| LocationId | reference | Create, Filter, Group, Nillable, Sort, Update | The location associated with the contract line item. If you have access to the location entity, it doesn't necessarily mean you can access the location id field. To access the location, you must have userHasLocation user access. |
| ParentContractLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | The line item's parent line item, if it has one. |
| PricebookEntryId | reference | Create, Filter, Update | Required. ID of the associated PricebookEntry. Only exists if Product2 is enabled. |
| Product2Id | reference | Filter, Group, Nillable, Sort | The product related to the contract line item. |
| Quantity | double | Create, Filter, Update | Number of units of the contract line item (product) included in the associated service contract. |
| RootContractLineItemId | reference | Filter, Group, Nillable, Sort | (Read only) The top-level line item in a contract line item hierarchy. Depending on where a line item lies in the hierarchy, its root could be the same as its parent. |
| ServiceContractId | reference | Create, Filter | Required. ID of the ServiceContract associated with the contract line item. Must be a valid service contract ID. |
| StartDate | date | Create, Filter, Nillable, Update | The first day the contract line item is in effect. |
| Status | picklist | Filter, Nillable | Status of the contract line item. |
| Subtotal | currency | Filter, Nillable | Contract line item's sales price multiplied by the Quantity. |
| TotalPrice | currency | Filter, Nillable | This field is available only for backward compatibility. It represents the total price of the ContractLineItem. If you specify Discount and Quantity, this field or UnitPrice is required. This field is nillable, but you can't set both TotalPrice and UnitPrice to null in the same update request. To insert the TotalPrice for a contract line item via the API (given only a unit price and the quantity), calculate this field as the unit price multiplied by the quantity. |
| UnitPrice | currency | Create, Filter, Update | The unit price for the contract line item. In the user interface, this field's value is calculated by dividing the total price of the contract line item by the quantity listed for that line item. Label is Sales Price. This field or TotalPrice is required. You can't specify both. If you specify Discount and Quantity, this field or TotalPrice is required. |

**Associated Objects:** ContractLineItemChangeEvent (API version 44.0) — Change events. / ContractLineItemFeed — Feed tracking. / ContractLineItemHistory — History (tracked fields).

---

## ContractLineOutcome

Represents information on a contract line outcome's captured data and other related parameters that are used when capturing data. API version 58.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:**
- Field Service must be enabled.
- Entitlements must be enabled.

**Fields (전 14필드):**

| Field | Type | Properties | Description |
|---|---|---|---|
| CalculationMethod | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The method used for calculating the contract line outcome's captured data to determine the outcome value. Select Average or As Captured to calculate the contract line outcome. Average calculates the outcome value based on the average of all data captured to date. As Captured calculates the outcome value based on the asset's current data at the time of the compliance check. Possible values are: AsCaptured / Average |
| CaptureFrequency | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The frequency at which data capturing and contract compliance check for the contract line outcome occurs. Possible values are: Daily / Monthly / Weekly |
| ComplianceStatus | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | Indicates if the criteria were met. Compliant–The outcome is compliant with the contract. Not Compliant–The outcome isn't compliant with the contract. Not Available–The outcome's compliance information isn't available yet. Invalid–The outcome isn't valid because the option selected for the Criteria Field of the recordset filter criteria was deleted. To restart the calculation, create a new contract line outcome. Possible values are: Compliant / Invalid / NotAvailable / NotCompliant. The default value is NotAvailable. |
| ContractLineItemId | reference | Create, Filter, Group, Sort, Update | The contract line item associated with the contract line outcome. This field is a relationship field. Relationship Name: ContractLineItem · Type: Lookup · Refers To: ContractLineItem |
| Description | textarea | Create, Nillable, Update | A description of the contract line outcome. |
| EndDate | dateTime | Create, Filter, Sort, Update | The contract line outcome's data capture end date. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date and time when the contract line outcome was last modified. Its UI label is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date and time when the contract line outcome was last viewed. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The name of the contract line outcome. |
| NextDataCaptureDate | dateTime | Filter, Nillable, Sort | The date of the next data capture and compliance check based on the capture frequency. The date is auto-populated and updated after each capture |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The contract line outcome's owner. By default, the owner is the user who created the contract line outcome record. Its UI label is Contract Line Outcome Owner. This field is a polymorphic relationship field. Relationship Name: Owner · Type: Lookup · Refers To: Group, User |
| RecordsetFilterCriteriaId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the recordset filter criteria in which the contract line outcome's conditions are defined. This field is a relationship field. Relationship Name: RecordsetFilterCriteria · Type: Lookup · Refers To: RecordsetFilterCriteria |
| ServiceContractId | reference | Filter, Group, Nillable, Sort | The service contract associated with the contract line item and the contract line outcome. This field is a relationship field. Relationship Name: ServiceContract · Type: Lookup · Refers To: ServiceContract |
| StartDate | dateTime | Create, Filter, Sort, Update | The contract line outcome's data capture start date. |

**Usage:** Use this object to define the data capture frequency and other related parameters that are used when capturing data in order to evaluate a service contract's compliance.

**Associated Objects:** ContractLineOutcomeChangeEvent — Change events. / ContractLineOutcomeFeed — Feed tracking. / ContractLineOutcomeHistory — History. / ContractLineOutcomeOwnerSharingRule — Sharing rules. / ContractLineOutcomeShare — Sharing.

**SEE ALSO:** ContractLineOutcomeData

---

## ContractLineOutcomeData

Represents the contract line outcome's captured data. It stores the data that was captured between the contract line outcome's start date and end date. API version 58.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:**
- Field Service must be enabled.
- Entitlements must be enabled.

**Fields (전 8필드):**

| Field | Type | Properties | Description |
|---|---|---|---|
| CalculatedValue | double | Filter, Nillable, Sort | The value calculated based on the contract line outcome's calculation method and the captured data. |
| CaptureDate | dateTime | Create, Filter, Sort, Update | The date and time when the data was captured. |
| ContractLineOutcomeId | reference | Create, Filter, Group, Sort | The contract line outcome associated with the contract line outcome data record. This field is a relationship field. Relationship Name: ContractLineOutcome · Type: Lookup · Refers To: ContractLineOutcome |
| KeyPerformanceIndicator | string | Create, Filter, Group, Nillable, Sort, Update | The key performance indicators (fields or asset attributes) that define the contract line outcome's compliance status. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date and time when the contract line outcome data record was last modified. Its UI label is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date and time when the contract line outcome data record was last viewed. |
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | The name of the contract line outcome data record. |
| Value | double | Create, Filter, Nillable, Sort, Update | The actual value of the key performance indicator. |

**Associated Objects:** ContractLineOutcomeDataChangeEvent — Change events. / ContractLineOutcomeDataFeed — Feed tracking. / ContractLineOutcomeDataHistory — History. / ContractLineOutcomeDataOwnerSharingRule — Sharing rules. / ContractLineOutcomeDataShare — Sharing.

---

## Entitlement

고객 계정 또는 연락처가 받을 자격이 있는 고객 지원을 나타낸다. API version 18.0 이상에서 사용 가능. 엔타이틀먼트는 자산(asset)·제품(product)·서비스 계약(service contract)에 기반할 수 있다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Fields (전 22필드):**

| Field | Type | Properties | Description |
|---|---|---|---|
| AccountId | reference | Create, Filter, Group, Sort | ID of the Account associated with the entitlement. |
| AssetId | reference | Filter, Group, Nillable, Sort | Required. ID of the Asset associated with the entitlement. Must be a valid asset ID. |
| AssetWarrantyID | reference | Create, Filter, Group, Nillable, Sort, Update | The identifier of the asset warranty record. Must be a valid asset warranty ID. AssetWarranty is available only with Field Service. |
| BusinessHoursId | reference | Filter, Group, Nillable, Sort | Required. ID of the BusinessHours associated with the entitlement. Must be a valid business hours ID. |
| CasesPerEntitlement | int | Filter, Group, Nillable, Sort | The total number of cases the entitlement supports. This field is only available if IsPerIncident is true. |
| ContractLineItemId | reference | Filter, Group, Nillable, Sort | Required. ID of the ContractLineItem associated with the entitlement. Must be a valid ID. |
| EndDate | date | Create, Filter, Nillable, Update | The last day the entitlement is in effect. |
| IsPerIncident | boolean | Defaulted on create, Filter, Update | Indicates whether the entitlement is limited to supporting a specific number of cases (true) or not (false). |
| LastReferencedDate | date | Filter, Nillable, Sort, Update | The timestamp when the current user last accessed this record, a record related to this record, or a list view. |
| LastViewedDate | date | Filter, Nillable, Sort, Update | The timestamp when the current user last viewed this record or list view. If this value is null, the user might have only accessed this record or list view (LastReferencedDate) but not viewed it. |
| LocationID | reference | Create, Filter, Group, Nillable, Sort, Update | ID of the Location associated with the entitlement. Must be a valid location ID. |
| Name | string | Create, Filter, Update | Required. Name of the entitlement. |
| SvcApptBookingWindowsId | reference | Create, Filter, Group, Sort, Nillable, Update | The operating hours that the entitlement's work orders should respect. The label in the user interface is Operating Hours. Available only if Field Service is enabled. |
| RemainingCases | int | Create, Filter, Nillable, Update | The number of cases the entitlement can support. This field decreases in value by one each time a case is created with the entitlement. This field is only available if IsPerIncident is selected. |
| RemainingWorkOrders | int | Create, Filter, Group, Nillable, Sort, Update | The number of agreed work orders remaining to be created. |
| ServiceContractId | reference | Create, Filter, Nillable, Update | Required. ID of the ServiceContract associated with the entitlement. Must be a valid ID. |
| SlaProcessId | reference | Create, Filter, Nillable, Update | ID of the SlaProcess associated with the entitlement. This field is available in version 19.0 and later. |
| StartDate | date | Create, Filter, Nillable, Update | The first date the entitlement is in effect. |
| Status | picklist | Filter, Nillable | Status of the entitlement, such as Expired. |
| SvcApptBookingWindows | reference | Create, Filter, Group, Sort, Nillable, Update | The operating hours of the entitlement. This field is visible only if Field Service is enabled. |
| Type | picklist | Create, Defaulted on create, Filter, Nillable, Update | The type of entitlement, such as Web or phone support. |
| WorkOrdersPerEntitlement | int | Create, Filter, Group, Nillable, Sort, Update | Total number of work orders available for this entitlement. |

> [!note] `SvcApptBookingWindowsId`(reference, `...Id` 접미)와 `SvcApptBookingWindows`(reference, 접미 없음)는 원문상 **별개의 두 필드**다 [sic].

**Associated Objects:** EntitlementChangeEvent (API version 44.0) — Change events. / EntitlementFeed (API version 23.0) — Feed tracking. / EntitlementHistory — History.

---

## EntityMilestone

Represents a required step in a customer support process on a work order. The Salesforce user interface uses the term "object milestone. This object is available in API version 37.0 and later.

> [sic] 원문에서 `"object milestone` 의 닫는 따옴표가 누락되어 있다. 위 설명은 원문을 그대로 보존한 것이다.

> [!note] Milestones on cases use the CaseMilestone object type.

**Supported Calls:** `delete()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`

**Special Access Rules:**
- As of Summer '20 and later, only Salesforce admins, users with access to the Case, Entitlement, or Work Order objects, and users with the View Setup and Configuration permission can access this object.
- Entitlement management must be enabled.
- Work orders or Field Service must be enabled.

**Fields (전 29필드):**

| Field | Type | Properties | Description |
|---|---|---|---|
| ActualElapsedTimeInDays | double | Filter, Nillable, Sort | The number of days that it took to complete a milestone. (Elapsed Time) – (Stopped Time) = (Actual Elapsed Time). Note: To display this field, select Enable stopped time and actual elapsed time on the Entitlement Settings page and add the field to the object milestone page layout. |
| ActualElapsedTimeInHrs | double | Filter, Nillable, Sort | The number of hours that it took to complete a milestone. (Elapsed Time) – (Stopped Time) = (Actual Elapsed Time). Note: To display this field, select Enable stopped time and actual elapsed time on the Entitlement Settings page and add the field to the object milestone page layout. |
| ActualElapsedTimeInMins | int | Filter, Group, Nillable, Sort | The number of minutes that it took to complete a milestone. (Elapsed Time) – (Stopped Time) = (Actual Elapsed Time). Note: To display this field, select Enable stopped time and actual elapsed time on the Entitlement Settings page and add the field to the object milestone page layout. |
| BusinessHoursId | reference | Filter, Group, Nillable, Sort | The business hours on the milestone. If business hours aren't specified, the entitlement process business hours are used. If business hours are also not specified on the entitlement process, the business hours on the record are used. |
| CompletionDate | dateTime | Filter, Nillable, Sort, Update | The date and time the milestone was completed. |
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Available only for orgs with the multicurrency feature enabled. Contains the ISO code for any currency allowed by the organization. |
| ElapsedTimeInDays | double | Filter, Nillable, Sort | The number of days it took to complete a milestone, including time during which the milestone was stopped. Automatically calculated to include the business hours on the record. Elapsed time is calculated only after the Completion Date field is populated. (Elapsed Time) – (Stopped Time) = (Actual Elapsed Time). |
| ElapsedTimeInHrs | double | Filter, Nillable, Sort | The number of hours it took to complete a milestone, including time during which the milestone was stopped. Automatically calculated to include the business hours on the record. Elapsed time is calculated only after the Completion Date field is populated. (Elapsed Time) – (Stopped Time) = (Actual Elapsed Time). |
| ElapsedTimeInMins | int | Filter, Group, Nillable, Sort | The number of minutes it took to complete a milestone, including time during which the milestone was stopped. Automatically calculated to include the business hours on the record. Elapsed time is calculated only after the Completion Date field is populated. (Elapsed Time) – (Stopped Time) = (Actual Elapsed Time). |
| IsCompleted | boolean | Defaulted on create, Filter, Group, Sort | Green checkmark icon that indicates a milestone completion. |
| IsViolated | boolean | Defaulted on create, Filter, Group, Sort | Red exclamation point icon that indicates a milestone violation. |
| MilestoneTypeId | reference | Filter, Group, Nillable, Sort | The ID of the milestone (for instance, First Response). |
| Name | string | Filter, Group, Sort, Update | The name of the milestone. |
| ParentEntityId | reference | Filter, Group, Sort | The ID of the record—for example, a work order—that contains the milestone. |
| SlaProcessId | reference | Filter, Group, Nillable, Sort | The entitlement process associated with the milestone. |
| StartDate | dateTime | Filter, Nillable, Sort, Update | The date and time that milestone tracking started. |
| StoppedTimeInDays | double | Filter, Nillable, Sort | The number of days that an agent has been blocked from completing a milestone. For example, an agent may be waiting for a customer to reply with more information. Note: To display this field, select Enable stopped time and actual elapsed time on the Entitlement Settings page and add the field to the object milestone page layout. |
| StoppedTimeInHrs | double | Filter, Nillable, Sort | The number of hours that an agent has been blocked from completing a milestone. For example, an agent may be waiting for a customer to reply with more information. Note: To display this field, select Enable stopped time and actual elapsed time on the Entitlement Settings page and add the field to the object milestone page layout. |
| StoppedTimeInMins | int | Filter, Group, Nillable, Sort | The number of minutes that an agent has been blocked from completing a milestone. For example, an agent may be waiting for a customer to reply with more information. Note: To display this field, select Enable stopped time and actual elapsed time on the Entitlement Settings page and add the field to the object milestone page layout. |
| TargetDate | dateTime | Filter, Nillable, Sort | The date and time to complete the milestone. |
| TargetResponseInDays | double | Filter, Nillable, Sort | The number of days to complete the milestone. Automatically calculated to include the business hours on the record. |
| TargetResponseInHrs | double | Filter, Nillable, Sort | The number of hours to complete the milestone. Automatically calculated to include the business hours on the record. |
| TargetResponseInMins | int | Filter, Group, Nillable, Sort | The number of minutes to complete the milestone. Automatically calculated to include the business hours on the record. |
| TimeRemainingInDays | string | Filter, Nillable, Sort | The days that remain before a milestone violation. Automatically calculated to include the business hours on the record. |
| TimeRemainingInHrs | string | Filter, Group, Nillable, Sort | The hours that remain before a milestone violation. Automatically calculated to include the business hours on the record. |
| TimeRemainingInMins | string | Group, Nillable, Sort | The minutes that remain before a milestone violation. Automatically calculated to include the business hours on the record. |
| TimeSinceTargetInDays | string | Filter, Nillable, Sort | The days that have elapsed since a milestone violation. Automatically calculated to include the business hours on the record. |
| TimeSinceTargetInHrs | string | Filter, Nillable, Sort | The hours that have elapsed since a milestone violation. Automatically calculated to include the business hours on the record. |
| TimeSinceTargetInMins | string | Group, Nillable, Sort | The minutes that have elapsed since a milestone violation. Automatically calculated to include the business hours on the record. |

**Usage:** When you create an entitlement process, you select its type based on the type of record that you want the process to run on: Case or Work Order. Processes created before Summer '16 use the Case type. When a Work Order entitlement process runs on a work order, the resulting milestones on the work order are object milestones. Conversely, when a Case entitlement process runs on a case, the resulting milestones are case milestones, a separate standard object.

> [!tip] If an entitlement has an entitlement process associated with it, don't use the entitlement for multiple types of support records. An entitlement process works only on records that match the process's type. For example, when a Case entitlement process is applied to an entitlement, the process runs only on cases associated with that entitlement. If a work order is also associated with the entitlement, the process doesn't run on the work order. To ensure that the milestones you set up work as expected, associate a customer's work orders and cases with different entitlements.

Customize page layouts, validation rules, and more for object milestones from the Object Milestones node in Setup under Entitlement Management.

**Associated Objects:** EntityMilestoneFeed — Feed tracking. / EntityMilestoneHistory — History.

---

## ServiceContract

고객 지원 계약(비즈니스 합의)을 나타낸다. API version 18.0 이상에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Fields (전 45필드):**

| Field | Type | Properties | Description |
|---|---|---|---|
| AccountId | reference | Filter, Group, Nillable, Sort | ID of the account associated with the service contract. |
| ActivationDate | dateTime | Filter, Nillable, Sort | The initial day the service contract went into effect (whereas StartDate may include a renewal date). |
| AdditionalDiscount | percent | Create, Filter, Nillable, Sort, Update | Extra discount percentage for the service contract. Available in API version 55.0 and later. |
| ApprovalStatus | picklist | Defaulted on create, Filter, Group, Nillable, Sort | Approval status of the service contract. |
| BillingAddress (beta) | address | Filter, Nillable | The compound form of the billing address. Read-only. See Address Compound Fields for details on compound address fields. |
| BillingCity | string | Filter, Group, Nillable, Sort | Details for the billing address. Maximum size is 40 characters. |
| BillingCountry | string | Filter, Group, Nillable, Sort | Details for the billing address. Maximum size is 40 characters. |
| BillingCountryCode | picklist | Create, Filter, Group, Nillable, Sort, Update | The ISO country code for the service contract's billing address. |
| BillingLatitude | double | Create, Filter, Nillable, Sort, Update | Used with BillingLongitude to specify the precise geolocation of a billing address. Acceptable values are numbers between –90 and 90 with up to 15 decimal places. |
| BillingLongitude | double | Create, Filter, Nillable, Sort, Update | Used with BillingLatitude to specify the precise geolocation of a billing address. Acceptable values are numbers between –180 and 180 with up to 15 decimal places. |
| BillingPostalCode | string | Filter, Group, Nillable, Sort | Details for the billing address. Maximum size is 20 characters. |
| BillingState | string | Group, Sort, Filter, Nillable | Details for the billing address. Maximum size is 20 characters. |
| BillingStateCode | picklist | Create, Filter, Group, Nillable, Sort, Update | The ISO state code for the service contract's billing address. |
| BillingStreet | textarea | Filter, Group, Nillable, Sort | Street address for the billing address. |
| ContactId | reference | Filter, Group, Nillable, Sort | Required. ID of the Contact associated with the service contract. Must be a valid ID. |
| ContractNumber | string | Autonumber, Defaulted on create, Filter, Sort | Unique number automatically assigned to the service contract. |
| Description | textarea | Nillable | Description of the service contract. |
| Discount | percent | Filter, Nillable, Sort | Discount percentage for the service contract. |
| EndDate | date | Filter, Group, Nillable, Sort | The last day the service contract is in effect. |
| GrandTotal | currency | Filter, Nillable, Sort | Total price of the service contract plus shipping and taxes. |
| IsDeleted | boolean | Defaulted on create, Filter | Indicates whether the object has been moved to the Recycle Bin (true) or not (false). Label is Deleted. |
| LastReferencedDate | date | Filter, Nillable, Sort, Update | The timestamp when the current user last interacted with this record, directly or indirectly. Some sample scenarios are: |
| LastViewedDate | date | Filter, Nillable, Sort, Update | The timestamp when the current user last viewed this record or list view. If this value is null, it's possible that the user only accessed this record or list view (LastReferencedDate), but not viewed it. |
| LineItemCount | int | Filter, Nillable, Group, Sort | Number of ContractLineItem records associated with the service contract. |
| Name | string | Create, Filter, Group, Sort, Update | Name of the service contract. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The ID of the user who currently owns the service contract. |
| ParentServiceContractId | reference | Create, Filter, Group, Nillable, Sort, Update | The service contract's parent service contract, if it has one. |
| Pricebook2Id | reference | Create, Filter, Group, Nillable, Sort, Update | ID of the Pricebook2 associated with the service contract. Must be a valid ID. |
| RootServiceContractId | reference | Filter, Group, Nillable, Sort | (Read only) The top-level service contract in a service contract hierarchy. Depending on where a service contract lies in the hierarchy, its root could be the same as its parent. |
| ShippingAddress (beta) | address | Filter, Nillable | The compound form of the shipping address. Read-only. See Address Compound Fields for details on compound address fields. |
| ShippingCity | string | Filter, Group, Nillable, Sort | Details of the shipping address. Maximum size is 40 characters. |
| ShippingCountry | string | Filter, Group, Nillable, Sort | Details of the shipping address. Country maximum size is 40 characters. |
| ShippingCountryCode | picklist | Create, Filter, Group, Nillable, Sort, Update | The ISO country code for the service contract's shipping address. |
| ShippingLatitude | double | Create, Filter, Nillable, Sort, Update | Used with ShippingLongitude to specify the precise geolocation of a shipping address. Acceptable values are numbers between –90 and 90 with up to 15 decimal places. |
| ShippingLongitude | double | Create, Filter, Nillable, Sort, Update | Used with ShippingLatitude to specify the precise geolocation of an address. Acceptable values are numbers between –180 and 180 with up to 15 decimal places. |
| ShippingPostalCode | string | Create, Filter, Nillable, Update | Details of the shipping address. Postal code maximum size is 20 characters. |
| ShippingState | string | Create, Filter, Nillable, Update | Details of the shipping address. State maximum size is 20 characters. |
| ShippingStateCode | picklist | Create, Filter, Group, Nillable, Sort, Update | The ISO state code for the service contract's shipping address. |
| ShippingStreet | textarea | Create, Filter, Nillable, Update | The street address of the shipping address. Maximum of 255 characters. |
| SpecialTerms | textarea | Create, Nillable, Update | Any terms specifically agreed to and tracked in the service contract. |
| StartDate | date | Create, Filter, Nillable, Update | The first day the service contract is in effect. |
| Status | picklist | Filter, Nillable | The status of the service contract, such as Inactive. |
| Subtotal | currency | Filter, Nillable | Total of the service contract line items (products) before discounts, taxes, and shipping are applied. |
| Tax | currency | Create, Filter, Nillable, Update | Total taxes for the service contract. |
| Term | int | Create, Filter, Nillable, Update | Number of months that the service contract is valid. |
| TotalPrice | currency | Filter, Nillable | Total of the contract line items (products) after discounts and before taxes and shipping. |

> [sic] `LastReferencedDate` 의 Description이 원문에서 "Some sample scenarios are:" 까지만 적히고 그 뒤 문장이 끊겨 있다. 위 표는 끊긴 그대로 보존한 것이다.

**Associated Objects:** ServiceContractChangeEvent (API version 44.0) — Change events. / ServiceContractFeed (API version 23.0) — Feed tracking. / ServiceContractHistory — History. / ServiceContractOwnerSharingRule — Sharing rules. / ServiceContractShare — Sharing.

---

## 관련 노트
- [[Field Service 개요와 데이터 모델]]
- [[Field Service Objects]]
