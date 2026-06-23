---
tags: [field-service, fsl, sobject, object-reference, service-appointment, assigned-resource, associated-location, address, 현장서비스, 객체레퍼런스]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [ServiceAppointment, AssignedResource, AssociatedLocation, Address, ServiceAppointmentStatus, 서비스 예약, 배정 리소스, 연결된 위치, 현장서비스 객체]
---

# 객체 레퍼런스 — Service Appointment·Resource

> Field Service Developer Guide의 객체 카탈로그 중 Address·AssignedResource·AssociatedLocation·ServiceAppointment·ServiceAppointmentStatus 5개 객체의 필드 전수 레퍼런스.

이 노트는 **Field Service의 약속(appointment)·리소스 배정·위치 연결** 도메인의 SOAP API 객체 정의를 다룬다. 전체 데이터 모델 개요와 객체 간 관계는 [[Field Service 개요와 데이터 모델]], 객체 카탈로그 요약은 [[Field Service Objects]]를 참조한다.

> ⚠️ **Field Service ≠ Salesforce Scheduler 구분:** `ServiceAppointment`는 Field Service에서 모바일 워커가 현장 작업을 완료하기 위한 예약을 나타낸다. 이름이 비슷한 Salesforce Scheduler(Lightning Scheduler)의 예약 모델과는 별개 도메인이다 — 다만 일부 객체(`ServiceAppointment`, `AssignedResource`)는 두 제품에서 공유된다.

각 필드 표의 행 순서는 **PDF 원문 표 순서 그대로**이며 알파벳순이 아니다.

---

## Address

**설명:** Represents a mailing, billing, or home address.

> ⚠️ **Apex에서 참조 주의 [Important]:** Salesforce의 "Address"는 많은 표준 객체에 있는 Address compound field를 가리킬 수도 있다. Apex 코드에서 Address **객체**를 참조할 때는 표준 Address compound field와의 혼동을 막기 위해 항상 `Address`가 아니라 `Schema.Address`를 사용한다. 같은 스니펫에서 address 객체와 Address 필드를 동시에 참조한다면 필드는 `System.Address`, 객체는 `Schema.Address`로 구분할 수 있다.

```apex
// 구조 예시 — 실제 동작 코드 아님
Schema.Address addrObj = new Schema.Address(); // Address 객체
System.Address addrField = someAccount.BillingAddress; // 표준 compound 필드
```

**Supported Calls:** create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(), retrieve(), search(), undelete(), update(), upsert()

**Special Access Rules:** 다음 access check 중 하나가 활성화돼야 한다.
- Industries Insurance
- Retail Execution
- Industries Visit
- Field Service
- Order Management
  - Perms: FulfillmentOrder, OrderSummary, AdvancedOrderManagement, OrderCCS
  - Prefs: OrdersEnabled, EnhancedCommerceOrders
- Public Sector
- Employee Experience
- Contact Tracing For Employees

You can create an address only when creating a location. (주소는 위치(location)를 생성할 때만 생성할 수 있다.)

### Fields (18)

| Field Name | Type | Properties | Description |
|---|---|---|---|
| Address | address | Filter, Nillable | The full address. |
| AddressType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | Picklist of address types. The values are: Mailing / Shipping / Billing / Home |
| City | string | Create, Filter, Group, Nillable, Sort, Update | The address city. |
| Country | string | Create, Filter, Group, Nillable, Sort, Update | The address country. |
| Description | string | Create, Filter, Group, Nillable, Sort, Update | A brief description of the address. |
| DrivingDirections | string | Create, Filter, Nillable, Sort, Update | Directions to the address. |
| GeocodeAccuracy | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The level of accuracy of a location's geographical coordinates compared with its physical address. A geocoding service typically provides this value based on the address's latitude and longitude coordinates. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The most recent date on which a user referenced this record. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The most recent date on which a user viewed this record. |
| Latitude | double | Create, Filter, Nillable, Sort, Update | Used with Longitude to specify the precise geolocation of the address. Acceptable values are numbers between –90 and 90 with up to 15 decimal places. |
| LocationType | picklist | Create, Defaulted on create, Filter, Filter, Group, Sort, Update [sic: Filter 중복] | Picklist of location types. The available values are: Warehouse (default) / Site / Van / Plant |
| Longitude | double | Create, Filter, Nillable, Sort, Update | Used with Latitude to specify the precise geolocation of the address. Acceptable values are numbers between –180 and 180 with up to 15 decimal places. |
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name of the address. |
| ParentId | reference | Create, Filter, Group, Sort | A lookup field to the parent location. (Relationship Name: Parent · Type: Lookup · Refers To: Location) |
| PostalCode | string | Create, Filter, Group, Nillable, Sort, Update | The address postal code. |
| State | string | Create, Filter, Group, Nillable, Sort, Update | The address state. |
| Street | textarea | Create, Filter, Group, Nillable, Sort, Update | The address street. |
| TimeZone | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Picklist of available time zones. |

**Associated Object:** AddressHistory (API version 62.0) — History is available for tracked fields of the object.

---

## AssignedResource

**설명:** Represents a service resource who is assigned to a service appointment in Field Service and Lightning Scheduler. Assigned resources appear in the Assigned Resources related list on service appointments. This object is available in API version 38.0 and later.

**Supported Calls:** create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(), retrieve(), undelete(), update(), upsert()

*(PDF 원문에 Special Access Rules 섹션 미기재)*

### Fields (10)

> 필드 순서 [sic] 주의: PDF 표 순서 그대로 — `LocationStatus` 다음에 `IsPrimaryResource`가 온다(알파벳순 아님).

| Field Name | Type | Properties | Description |
|---|---|---|---|
| ActualTravelTime | double | Create, Filter, Nillable, Sort, Update | The number of minutes that the service resource needs to travel to the assigned service appointment. You can enter a value with up to two decimal places. |
| ApptAssistantInfoUrl | textarea | Create, Nillable, Update | The URL that contains the status of the mobile worker approaching the service appointment, the Community URL, and the expiry of the URL. Available in version 51.0 and later. |
| AssignedResourceNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-generated number identifying the resource assignment. |
| EstimatedTravelTime | double | Create, Filter, Nillable, Sort, Update | The estimated number of minutes needed for the service resource to travel to the service appointment they're assigned to. You can enter a value with up to two decimal places. |
| LocationStatus | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The status of the mobile worker approaching the service appointment. When the location status changes to one of these values, a status update containing ApptAssistantInfoUrl is sent to the customer. Available in version 51.0 and later. Possible values are: EnRoute / LastMile |
| IsPrimaryResource | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the service resource is a primary resource or not. The default value is false. Available in API version 47.0 and later. |
| ServiceAppointmentId | reference | Create, Filter, Group, Sort | The service appointment that the resource is assigned to. (Relationship Name: ServiceAppointment · Type: Lookup · Refers To: ServiceAppointment) |
| ServiceCrewId | reference | Create, Update, Filter, Group, Sort, Nillable | The service crew that the resource is assigned to. *(Note 아래 참조)* |
| ServiceResourceId | reference | Create, Update, Filter, Group, Sort | The resource who is assigned to the service appointment. (Relationship Name: ServiceResource · Type: Lookup · Refers To: ServiceResource) |
| Transaction | string | Create, Filter, Group, Nillable, Sort, Update | The last transaction ID of the scheduling and optimization request that updated this object. The transaction ID is automatically generated and populated by the Enhanced Scheduling and Optimization engine. Available in API version 63.0 and later. |

> **ServiceCrewId Note:** Since service resources can represent crews or individuals, appointments are typically assigned to crews in the following way: 1. Create a service resource of the Crew type that represent the crew. 2. Create an assigned resource on the service appointment and select the crew resource in the ServiceResourceId field. As an alternative, you can assign appointments to crew members separately. This lets you track each member's travel time and see a list of the crew members in the Assigned Resources related list. To take this approach, create an assigned resource for each crew member. List the crew member in the ServiceResourceId field and the crew they belong to in the ServiceCrewId field.

**Usage:** You can assign multiple service resources to a service appointment. Service resources who are assigned to service appointments cannot be deactivated until they are removed from the appointments.

**Associated Objects:**
- AssignedResourceChangeEvent (API version 48.0) — Change events are available for the object.
- AssignedResourceHistory (API version 61.0) — History is available for tracked fields of the object. *(원문 "AssignedResourceHistory(API" 공백 누락 [sic])*
- AssignedResourceFeed — Feed tracking is available for the object.

---

## AssociatedLocation

**설명:** Represents a link between an account and a location in Field Service. You can associate multiple accounts with one location. For example, a shopping center location may have multiple customer accounts.

**Supported Calls:** create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(), retrieve(), undelete(), update(), upsert()

**Special Access Rules:** Field Service must be enabled.

### Fields (8)

| Field Name | Type | Properties | Description |
|---|---|---|---|
| ActiveFrom | dateTime | Create, Filter, Nillable, Sort, Update | Date and time the associated location is active. |
| ActiveTo | dateTime | Create, Filter, Nillable, Sort, Update | Date and time the associated location stops being active. |
| AssociatedLocationNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | Auto-generated number identifying the associated location. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date the associated location was last modified. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date the associated location was last viewed. |
| LocationId | reference | Create, Filter, Group, Sort, Update | The location associated with the address. (Relationship Name: Location · Type: Lookup · Refers To: Location) |
| ParentRecordId | reference | Create, Filter, Group, Sort | The account associated with the location. (Relationship Name: ParentRecord · Type: Lookup · Refers To: Account) |
| Type | picklist | Create, Filter, Group, Nillable, Sort, Update | Picklist of address types. The values are: Bill To / Ship To |

**Associated Objects:**
- AssociatedLocationChangeEvent (API version 62.0) — Change events are available for the object.
- AssociatedLocationHistory — History is available for tracked fields of the object.

---

## ServiceAppointment

**설명:** Represents an appointment to complete work for a customer in Field Service, Lightning Scheduler, Intelligent Appointment Management, and Virtual Care.This [sic: 원문 "Virtual Care.This" 공백 누락] This object is available in API version 38.0 and later.

**Supported Calls:** create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(), retrieve(), search(), undelete(), update(), upsert()

**Special Access Rules:** Field Service must be enabled.

### Fields (44)

| Field Name | Type | Properties | Description |
|---|---|---|---|
| AccountId | reference | Filter, Group, Nillable, Sort | (Read only) The account associated with the appointment. If the parent record is a work order or work order line item, this field's value is inherited from the parent. Otherwise, it remains blank. (Relationship Name: Account · Type: Lookup · Refers To: Account) |
| ActualDuration | double | Create, Filter, Nillable, Sort, Update | The number of minutes that it took the resource to complete the appointment after arriving at the address. When values are first added to the Actual Start and Actual End fields, the Actual Duration is automatically populated to list the difference between the Actual Start and Actual End. If the Actual Start and Actual End fields are subsequently updated, the Actual Duration field doesn't re-update, but you can manually update it. |
| ActualEndTime | dateTime | Create, Filter, Nillable, Sort, Update | The actual date and time the appointment ended. |
| ActualStartTime | dateTime | Create, Filter, Nillable, Sort, Update | The actual date and time the appointment started. |
| Address | address | Filter | The address where the appointment is taking place. The address is inherited from the parent record if the parent record is a work order or work order line item. |
| AppointmentNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-assigned number that identifies the appointment. |
| ArrivalWindowEndTime | dateTime | Create, Filter, Nillable, Sort, Update | The end of the window of time in which the technician is scheduled to arrive at the site. This window is typically larger than the Scheduled Start and End window to allow time for delays and scheduling changes. You may choose to share the Arrival Window Start and End with the customer, but keep the Scheduled Start and End internal-only. |
| ArrivalWindowStartTime | dateTime | Create, Filter, Nillable, Sort, Update | The beginning of the window of time in which the technician is scheduled to arrive at the site. This window is typically larger than the Scheduled Start and End window to allow time for delays and scheduling changes. You may choose to share the Arrival Window Start and End with the customer, but keep the Scheduled Start and End internal-only. |
| BundlePolicyId | reference | Create, Filter, Group, Nillable, Sort, Update | Reference to the bundle policy associated with this service appointment. (Relationship Name: BundlePolicy · Type: Lookup · Refers To: ApptBundlePolicy) |
| City | string | Create, Filter, Group, Nillable, Sort, Update | The city where the appointment is completed. Maximum length is 40 characters. |
| ContactId | reference | Create, Filter, Group, Nillable, Sort, Update | The contact associated with the parent record. If needed, you can manually update the service appointment contact. (Relationship Name: Contact · Type: Lookup · Refers To: Contact) |
| Country | string | Create, Filter, Group, Nillable, Sort, Update | The country where the work order is completed. Maximum length is 80 characters. |
| Description | textarea | Create, Nillable, Update | The description of the appointment. |
| DueDate | dateTime | Create, Filter, Sort, Update | The date by which the appointment must be completed. Earliest Start Permitted and Due Date typically reflect terms in the customer's service-level agreement. |
| Duration | double | Create, Nillable, Filter, Sort, Update | The estimated length of the appointment. If the parent record is work order or work order line item, the appointment inherits its parent's duration, but it can be manually updated. The duration is in minutes or hours based on the value selected in the Duration Type field. |
| DurationType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The unit of the Duration: Minutes or Hours. |
| EarliestStartTime | dateTime | Create, Filter, Sort, Update | The date after which the appointment must be completed. Earliest Start Permitted and Due Date typically reflect terms in the customer's service-level agreement. |
| GeocodeAccuracy | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The level of accuracy of a location's geographical coordinates compared with its physical address. Usually provided by a geocoding service based on the address's latitude and longitude coordinates. This field is available in the API only. |
| IsAnonymousBooking | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether a service resource was automatically assigned to the appointment. The default value is false. This field is available in API version 49.0 and later. |
| IsBundle | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if this service appointment is a bundle service appointment. The default value is false. This field is available in API version 54.0 and later. |
| IsBundleMember | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if this service appointment is a bundle member service appointment. The default value is false. This field is available in API version 54.0 and later. |
| IsManuallyBundled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if this bundle was created manually. The default value is false. This field is available in API version 54.0 and later. |
| IsOffsiteAppointment | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Any type of work that can be done remotely. This field is available in API version 58.0 and later. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the service appointment was last modified. Its label in the user interface is Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the service appointment was last viewed. |
| Latitude | double | Create, Filter, Nillable, Sort, Update | Used with Longitude to specify the precise geolocation of the address where the service appointments is completed. Acceptable values are numbers between –90 and 90 with up to 15 decimal places. To integrate data from an external data source for latitude, map your data to the ServiceAppointment.Latitude and not the ServiceAppointment.FSL__InternalSLRGeolocation__Latitude__s field. This field is available in the API only. |
| Longitude | double | Create, Filter, Nillable, Sort, Update | Used with Latitude to specify the precise geolocation of the address where the service appointment is completed. Acceptable values are numbers between –180 and 180 with up to 15 decimal places. To integrate data from an external data source for longitude, map your data to the ServiceAppointment.Longitude and not the ServiceAppointment.FSL__InternalSLRGeolocation__Longitude__s field. This field is available in the API only. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The owner of the service appointment. This is a polymorphic relationship field. (Relationship Name: Owner · Type: Lookup · Refers To: Group, User) |
| ParentRecordId | reference | Create, Filter, Group, Nillable, Sort | The parent record associated with the appointment. The parent record can't be updated after the service appointment is created. This is a polymorphic relationship field. (Relationship Name: ParentRecord · Type: Lookup · Refers To: Account, Asset, Lead, Opportunity, ServiceAppointmentGroup, WorkOrder, WorkOrderLineItem) |
| ParentRecordStatusCategory | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | (Read only) The Status Category of the parent record. If the parent record is a work order or work order line item, this field is populated; otherwise, it remains blank. |
| ParentRecordType | string | Filter, Group, Nillable, Sort | (Read only) The type of parent record: Account, Asset, Lead, Opportunity, Work Order, or Work Order Line Item. |
| PostalCode | string | Create, Filter, Group, Nillable, Sort, Update | The postal code where the work order is completed. Maximum length is 20 characters. |
| RelatedBundleId | reference | Create, Filter, Group, Nillable, Sort, Update | The bundle that this service appointment is a member of. (Relationship Name: RelatedBundle · Type: Lookup · Refers To: ServiceAppointment) |
| SchedEndTime | dateTime | Create, Filter, Nillable, Sort, Update | The time at which the appointment is scheduled to end. If you are using the Field Service managed package with the scheduling optimizer, this field is populated once the appointment is assigned to a resource. Scheduled End – Scheduled Start = Estimated Duration. |
| SchedStartTime | dateTime | Create, Filter, Nillable, Sort, Update | The time at which the appointment is scheduled to start. If you are using the Field Service managed package with the scheduling optimizer, this field is populated once the appointment is assigned to a resource. |
| ServiceDocumentTemplate | string | Create, Filter, Group, Nillable, Sort, Update | The template ID which sets the template for each service document for the Document Builder feature. |
| ServiceTerritoryId | reference | Create, Filter, Group, Nillable, Sort, Update | The service territory associated with the appointment. If the parent record is a work order or work order line item, the appointment inherits its parent's service territory. (Relationship Name: ServiceTerritory · Type: Lookup · Refers To: ServiceTerritory) |
| State | string | Create, Filter, Group, Nillable, Sort, Update | The state where the service appointment is completed. Maximum length is 80 characters. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The status of the appointment. The picklist includes the following values, which can be customized: None (Default value) / Scheduled (Appointment has been assigned to a service resource) / Dispatched (Assigned service resource has been notified about their assignment) / In Progress (Work has begun) / Completed (Work is complete) / Cannot Complete (Work could not be completed) / Canceled (Work is canceled, typically before any work began). While you can set the status to null via the API, setting the status to null returns an error. To prevent errors, use one of the picklist values. |
| StatusCategory | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The category that each Status value falls into. The Status Category field's values are identical to the default Status values. If you create custom Status values, you must indicate which category it belongs to. For example, if you create a Customer Absent value, you may decide that it belongs in the Cannot Complete category. To learn which processes reference StatusCategory, see How are Status Categories Used? |
| Street | textarea | Create, Filter, Group, Nillable, Sort, Update | The street number and name where the service appointment is completed. |
| Subject | string | Create, Filter, Group, Nillable, Sort, Update | A short phrase describing the appointment. |
| Transaction | string | Create, Filter, Group, Nillable, Sort, Update | The last transaction ID of the scheduling and optimization request that updated this object. The transaction ID is automatically generated and populated by the Enhanced Scheduling and Optimization engine. Available in API version 63.0 and later. |
| WorkTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | The work type associated with the service appointment. The work type is inherited from the appointment's parent record if the parent is a work order or work order line item. If Lightning Scheduler is also in use, this field is editable. However, users see an error if they update it to list a different work type than the parent record's work type. (Relationship Name: WorkType · Type: Lookup · Refers To: WorkType) |

**Usage:** Service appointments always have a parent record, which can be a work order, work order line item, opportunity, account, or asset. The type of parent record tells you about the nature of the service appointment:
- Service appointments on **work orders and work order line items** offer a more detailed view of the work being performed. While work orders and work order line items let you enter general information about a task, service appointments are where you add the details about scheduling and ownership.
- Service appointments on **assets** represent work being performed on the asset.
- Service appointments on **accounts** represent work being performed for the account.
- Service appointments on **opportunities** represent work that is related to the opportunity.
- Service appointments on **leads** represent work that is related to lead—for example, a site visit to pursue a promising lead.

**Associated Objects:**
- ServiceAppointmentChangeEvent (API version 48.0) — Change events are available for the object.
- ServiceAppointmentFeed — Feed tracking is available for the object.
- ServiceAppointmentHistory — History is available for tracked fields of the object.
- ServiceAppointmentOwnerSharingRule — Sharing rules are available for the object.
- ServiceAppointmentShare — Sharing is available for the object.

---

## ServiceAppointmentStatus

**설명:** Represents a possible status of a service appointment in field service. (read-only 객체)

**Supported Calls:** describeSObjects(), query(), retrieve() — 읽기 전용(create/update/delete 불가)

**Special Access Rules:** Field Service must be enabled.

### Fields (5)

| Field Name | Type | Properties | Description |
|---|---|---|---|
| ApiName | string | Filter, Group, idLookup, Sort | The API name of the status value. |
| IsDefault | boolean | Defaulted on create, Filter, Group, Sort | Indicates that the status value is the default status on service appointments. Only one status value can be the default. |
| MasterLabel | string | Filter, Group, Nillable, Sort | The label for the picklist value that appears in the UI. |
| SortOrder | int | Filter, Group, Nillable, Sort | The value's position in the drop-down list of values in the UI. |
| StatusCode | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The status category that the value corresponds to. The Status Category field has seven values which are identical to the default Status values. |

**Usage:** The Status field on service appointments comes with the following values:
- None—Default value.
- Scheduled—Appointment has been assigned to a service resource.
- Dispatched—Assigned service resource has been notified about their assignment.
- In Progress—Work has begun.
- Completed—Work is complete.
- Cannot Complete—Work could not be completed.
- Canceled—Work is canceled, typically before any work began
- CheckedIn—The customer has arrived for their scheduled appointment.

> [Important]: While you can set the status to null via the API, setting the status to null returns an error. To prevent errors, use one of the documented picklist values.

The ServiceAppointmentStatus object corresponds to the Status field. Adding a value to the Status field—for example, Waiting—creates a service appointment status record, and vice versa.

> [Note]: Service appointments also come with a StatusCategory field whose values are identical to the default Status values. If you create custom Status values, you must indicate which category it belongs to. For example, if you create a Customer Absent value, you may decide that it belongs in the Cannot Complete category. To learn which processes reference StatusCategory, see How are Status Categories Used?

> ⚠️ **[sic] 본문 자체 불일치 — 원문대로 보존:** PDF 안에서 status 값 개수가 일치하지 않는다.
> - `ServiceAppointment.Status` **필드 설명**: 7개 값만 나열 (None / Scheduled / Dispatched / In Progress / Completed / Cannot Complete / Canceled)
> - `ServiceAppointmentStatus`의 **Usage 섹션**: 8개 값 나열 (위 7개 + **CheckedIn**)
> - `ServiceAppointmentStatus.StatusCode` 필드 설명: "The Status Category field has **seven** values"라고 명시
>
> 즉 본문이 7값(필드 설명·StatusCode)과 8값(Usage)을 모두 주장한다. 이는 PDF 원문의 내부 불일치이며 위키에서 임의로 통일하지 않고 원문 그대로 보존한다.

---

## 관련 노트
- [[Field Service 개요와 데이터 모델]]
- [[Field Service Objects]]
