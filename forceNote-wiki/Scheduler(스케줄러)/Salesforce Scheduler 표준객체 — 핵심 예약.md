---
tags: [scheduler, salesforce-scheduler, standard-objects, serviceappointment, waitlist, sobject-reference]
source: salesforce_scheduler_dev_guide.pdf (Salesforce Scheduler Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [ServiceAppointment 필드, ServiceAppointmentAttendee, AssignedResource, Waitlist, WaitlistParticipant, Scheduler 예약 객체]
---

# Salesforce Scheduler 표준객체 — 핵심 예약

> Salesforce Scheduler 예약 흐름의 핵심 5개 표준객체 — 예약(ServiceAppointment), 그룹 예약 참석자(ServiceAppointmentAttendee), 리소스 배정(AssignedResource), 대기열(Waitlist), 대기열 참가자(WaitlistParticipant) — 의 필드를 전수 정리한다.

```sql
-- 구조 예시 — 실제 동작 코드 아님
-- 예약(ServiceAppointment)에 배정된 리소스(AssignedResource) 조회 골격
SELECT Id, ServiceResourceId, ServiceAppointmentId
FROM AssignedResource
WHERE ServiceAppointmentId = :appointmentId
```

---

## AssignedResource

Salesforce Scheduler에서 서비스 약속(service appointment)에 배정된 서비스 리소스를 나타낸다. 배정된 리소스는 서비스 약속의 Assigned Resources 관련 목록에 표시된다. **available in API version 38.0 and later.**

### Supported Calls

`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`

### Fields

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `AssignedResourceNumber` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-generated number identifying the resource assignment. |
| `EventId` | `reference` | Filter, Group, Nillable, Sort | The ID of the event that is added to the assigned resources calendar when the service appointment is created. This is a relationship field. (Relationship Name: Event · Relationship Type: Lookup · Refers To: Event) |
| `IsPrimaryResource` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the service resource is a primary resource or not. The default value is false. Available in API version 47.0 and later. |
| `IsRequiredResource` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the service resource is a required resource or not. The default value is 'false'. If this field is set to false, Salesforce Scheduler considers the resource as available for other appointments. |
| `ServiceAppointmentId` | `reference` | Create, Filter, Group, Sort | The service appointment that the resource is assigned to. This is a relationship field. (Relationship Name: ServiceAppointment · Relationship Type: Lookup · Refers To: ServiceAppointment) |
| `ServiceResourceId` | `reference` | Create, Update, Filter, Group, Sort | The resource who is assigned to the service appointment. This is a relationship field. (Relationship Name: ServiceResource · Relationship Type: Lookup · Refers To: ServiceResource) |

### Usage

You can assign multiple service resources to a service appointment. Service resources who are assigned to service appointments can't be deactivated until they're removed from the appointments.

### Associated Objects

API version이 지정되지 않으면 이 객체와 동일한 API version에서 사용 가능하고, 지정되면 해당 version 이상에서 사용 가능하다.

- **AssignedResourceChangeEvent** (API version 48.0) — Change events are available for the object.
- **AssignedResourceFeed** — Feed tracking is available for the object.

---

## ServiceAppointment

Salesforce Scheduler를 통해 예약된 약속을 나타낸다. **available in API version 38.0 and later.**

### Supported Calls

`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete`, `update()`, `upsert()`

> 원문 그대로(sic): `undelete`는 다른 콜과 달리 괄호가 없다.

### Special Access Rules

Salesforce Scheduler must be enabled.

### Fields (47)

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `AccountId` | `reference` | Filter, Group, Nillable, Sort | (Read only) The account associated with the appointment. This is a relationship field. (Relationship Name: Account · Relationship Type: Lookup · Refers To: Account) |
| `ActualDuration` | `double` | Create, Filter, Nillable, Sort, Update | The number of minutes that it took the resource to complete the appointment. When values are first added to the Actual Start and Actual End fields, the Actual Duration is automatically populated to list the difference between the Actual Start and Actual End. If the Actual Start and Actual End fields are subsequently updated, the Actual Duration field doesn't re-update, but you can manually update it. |
| `ActualEndTime` | `dateTime` | Create, Filter, Nillable, Sort, Update | The actual date and time the appointment ended. |
| `ActualStartTime` | `dateTime` | Create, Filter, Nillable, Sort, Update | The actual date and time the appointment started. |
| `AdditionalInformation` | `string` | Create, Filter, Group, Nillable, Sort, Update | Represents additional information about the service appointment, |
| `Address` | `address` | Filter | The address where the appointment is taking place. |
| `AppointmentCategoryId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the appointment category related to the service appointment. For example, for customers who visit the branch without an appointment, the drop in category is applicable. For pre-booked appointments, the scheduled category is applicable. This field is available in API version 58.0 and later. This is a relationship field. (Relationship Name: AppointmentCategory · Relationship Type: Lookup · Refers To: AppointmentCategory) |
| `AppointmentInvitationId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the appointment invitation related to the appointment. This field is available in API version 55.0 and later. This field is a relationship field. (Relationship Name: AppointmentInvitation · Relationship Type: Lookup · Refers To: AppointmentInvitation) |
| `AppointmentMode` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The mode of the service appointment.. This field is available in API version 60.0 and later. Possible values are: Group · Regular. The default value is Regular. |
| `AppointmentNumber` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-assigned number that identifies the appointment. |
| `AppointmentType` | `picklist` | Create, Filter, Group, Nillable, Sort, Update | The type of appointment. Possible values are: call—Phone · company—At a branch · video—Video call. |
| `ApptBookingInfoUrl` | `textarea` | Create, Nillable, Update | The appointment booking URL related to the appointment. This field is available in API version 57.0 and later. For Amazon Chime, this field has an encrypted appointment ID. |
| `ArrivalWindowEndTime` | `dateTime` | Create, Filter, Nillable, Sort, Update | The end of the window of time in which the technician is scheduled to arrive at the site. This window is typically larger than the Scheduled Start and End window to allow time for delays and scheduling changes. You can choose to share the Arrival Window Start and End with the customer, but keep the Scheduled Start and End internal-only. |
| `ArrivalWindowStartTime` | `dateTime` | Create, Filter, Nillable, Sort, Update | The beginning of the window of time in which the technician is scheduled to arrive at the site. This window is typically larger than the Scheduled Start and End window to allow time for delays and scheduling changes. You can choose to share the Arrival Window Start and End with the customer, but keep the Scheduled Start and End internal-only. |
| `AttendeeCount` | `int` | Filter, Group, Nillable, Sort | The number of attendees associated with the service appointment. This field is available in API version 60.0 and later. |
| `AttendeeLimit` | `int` | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The maximum number of customers allowed to attend the service appointment. This field is considered when the appointment mode is Group. This field is available in API version 60.0 and later. |
| `CancellationReason` | `string` | Create, Filter, Group, Nillable, Sort, Update | The reason for the service appointment cancellation. |
| `CheckedInTime` | `dateTime` | Create, Filter, Nillable, Sort, Update | The date and time when the service appointment status changed to CheckedIn. This field is available in API version 60.0 and later. |
| `City` | `string` | Create, Filter, Group, Nillable, Sort, Update | The city where the appointment is completed. The maximum length is 40 characters. |
| `Comments` | `string` | Create, Filter, Group, Nillable, Sort, Update | The comments for the service appointment. |
| `ContactId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The contact associated with the parent record. If needed, you can manually update the service appointment contact. This is a relationship field. (Relationship Name: Contact · Relationship Type: Lookup · Refers To: Contact) |
| `Country` | `string` | Create, Filter, Group, Nillable, Sort, Update | The country where the appointment is completed. The maximum length is 80 characters. |
| `Description` | `textarea` | Create, Nillable, Update | The description of the appointment. |
| `DueDate` | `dateTime` | Create, Filter, Sort, Update | The date by which the appointment must be completed. Earliest Start Permitted and Due Date typically reflect terms in the customer's service-level agreement. |
| `Duration` | `double` | Create, Nillable, Filter, Sort, Update | The estimated length of the appointment. The duration is in minutes or hours based on the value selected in the Duration Type field. |
| `DurationType` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The unit of duration. Possible values are: Hours · Minutes. The default value is Hours. |
| `EarliestStartTime` | `dateTime` | Create, Filter, Sort, Update | The date after which the appointment must be completed. Earliest Start Permitted and Due Date typically reflect terms in the customer's service-level agreement. |
| `Email` | `email` | Create, Filter, Group, Nillable, Sort, Update | The email address. |
| `EngagementChannelTypeId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The engagement channel type that's associated with the service appointment. This field is available in API version 56.0 and later. This field is a relationship field. (Relationship Name: EngagementChannelType · Relationship Type: Lookup · Refers To: EngagementChannelType) |
| `GroupAppointmentAccessType` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The users who can access the group service appointment. Valid values are: AddedAndExperienceSiteAndInvitedUsers—Added, Experience Site, and Invited Users · AddedAndExperienceSiteUsers—Added and Experience Site Users · AddedUsers—Added Users. The default value is AddedUsers. Available in API version 61.0 and later. |
| `IsAnonymousBooking` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether a service resource was automatically assigned to the appointment (true) or not (false). The default value is false. This field is available in API version 49.0 and later. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the service appointment was last modified. Its label in the user interface is LastModifiedDate. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the service appointment was last viewed. |
| `OwnerId` | `reference` | Create, Defaulted on create, Filter, Group, Sort, Update | The owner of the service appointment. This is a polymorphic relationship field. (Relationship Name: Owner · Relationship Type: Lookup · Refers To: Group, User) |
| `ParentRecordId` | `reference` | Create, Filter, Group, Nillable, Sort | The parent record associated with the appointment. The parent record can't be updated after the service appointment is created. This is a polymorphic relationship field. (Relationship Name: ParentRecord · Relationship Type: Lookup · Refers To: Account, Case, Lead, Opportunity) |
| `ParentRecordType` | `string` | Filter, Group, Nillable, Sort | (Read only) The type of parent record: Account. |
| `Phone` | `phone` | Create, Filter, Group, Nillable, Sort, Update | The phone number. |
| `PostalCode` | `string` | Create, Filter, Group, Nillable, Sort, Update | The postal code where the appointment is completed. The maximum length is 20 characters. |
| `SchedEndTime` | `dateTime` | Create, Filter, Nillable, Sort, Update | The time at which the appointment is scheduled to end. ScheduledEnd – ScheduledStart = EstimatedDuration. |
| `SchedStartTime` | `dateTime` | Create, Filter, Nillable, Sort, Update | The time at which the appointment is scheduled to start. |
| `ServiceTerritoryId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The service territory associated with the appointment. This is a relationship field. (Relationship Name: ServiceTerritory · Relationship Type: Lookup · Refers To: ServiceTerritory) |
| `State` | `string` | Create, Filter, Group, Nillable, Sort, Update | The state where the service appointment is completed. The maximum length is 80 characters. |
| `Status` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Sort | The status of the appointment. The picklist includes the following values, which can be customized: None—Default value. · CheckedIn—Checked In · Scheduled—Appointment has been assigned to a service resource. · Dispatched—Assigned service resource has been notified about their assignment. · In Progress—Work has begun. · Completed—Work is complete. · Cannot Complete—Work couldn't be completed. · Canceled—Work is canceled, typically before any work began. The values of the Status picklist appear in the org's default language. |
| `StatusCategory` | `picklist` | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The category that each Status value falls into. The StatusCategory field's values are identical to the default Status values except CheckedIn. Use the CheckedIn value for drop-in customers. If you create custom Status values, you must indicate which category it belongs to. For example, if you create a Customer Absent value, you can decide that it belongs in the Cannot Complete category. To learn which processes reference StatusCategory, see How are Status Categories Used? |
| `Street` | `textarea` | Create, Filter, Group, Nillable, Sort, Update | The street number and name where the service appointment is completed. |
| `Subject` | `string` | Create, Filter, Group, Nillable, Sort, Update | A short phrase describing the appointment. |
| `WorkTypeId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The work type associated with the service appointment. This is a relationship field. (Relationship Name: WorkType · Relationship Type: Lookup · Refers To: WorkType) |

#### 주요 picklist 정리

- **Status** (8값): `None` / `CheckedIn` / `Scheduled` / `Dispatched` / `In Progress` / `Completed` / `Cannot Complete` / `Canceled`
- **AppointmentType** (3값): `call` (Phone) / `company` (At a branch) / `video` (Video call)
- **GroupAppointmentAccessType** (3값): `AddedAndExperienceSiteAndInvitedUsers` / `AddedAndExperienceSiteUsers` / `AddedUsers` (기본값 AddedUsers)
- **DurationType** (2값): `Hours` (기본값) / `Minutes`
- **AppointmentMode** (2값): `Group` / `Regular` (기본값 Regular)

### Usage

Service appointments always have a parent record, which can be an account. Service appointments on accounts represent work being performed for the account.

### Associated Objects

- **ServiceAppointmentChangeEvent** (API version 48.0) — Change events are available for the object.
- **ServiceAppointmentFeed** — Feed tracking is available for the object.
- **ServiceAppointmentHistory** — History is available for tracked fields of the object.
- **ServiceAppointmentOwnerSharingRule** — Sharing rules are available for the object.
- **ServiceAppointmentShare** — Sharing is available for the object.

---

## ServiceAppointmentAttendee

Service Appointment of type Group과 연관된 Lead, Contact, 또는 Person Account를 나타낸다. **available in API version 60.0 and later.**

### Supported Calls

`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

### Special Access Rules

Salesforce Scheduler must be enabled.

### Fields (10)

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `AttendeeId` | `reference` | Create, Filter, Group, Sort | The customer who is attending the associated service appointment. This field is a polymorphic relationship field. (Relationship Name: Attendee · Relationship Type: Lookup · Refers To: Person Account, Contact, Lead) |
| `AttendeeIdentifier` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | The alphanumeric unique identifier of the appointment attendee. For example, D101, E63, A5015. |
| `AttendeeType` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Specifies the role of an appointment attendee. Possible values are: Guest · Patient. The default value is Patient. |
| `Email` | `email` | Create, Filter, Group, Nillable, Sort, Update | The email of the attendee. |
| `HasAttended` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the attendee has attended the associated service appointment (true) or not (false). The default value is false. Available in API version 61.0 and later. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the service appointment attendee record was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the service appointment attendee record was last viewed. |
| `OwnerId` | `reference` | Create, Defaulted on create, Filter, Group, Sort, Update | The owner of the service appointment attendee record. This field is a polymorphic relationship field. (Relationship Name: Owner · Relationship Type: Lookup · Refers To: Group, User) |
| `ServiceAppointmentId` | `reference` | Create, Filter, Group, Sort | The service appointment associated with the appointment attendee. This field is a relationship field. (Relationship Name: ServiceAppointment · Relationship Type: Lookup · Refers To: ServiceAppointment) |
| `Status` | `picklist` | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The status of the service appointment attendee. Valid value are: Enrolled · Unenrolled. The default value is Enrolled. These values are available in API version 61.0 and later. |

> 원문 그대로(sic): Status 설명의 "Valid value are" (단복수 불일치).

#### picklist 정리

- **AttendeeType** (2값): `Guest` / `Patient` (기본값 Patient)
- **Status** (2값): `Enrolled` (기본값) / `Unenrolled`

### Associated Objects

- **ServiceAppointmentAttendeeFeed** — Feed tracking is available for the object.
- **ServiceAppointmentAttendeeHistory** — History is available for tracked fields of the object.
- **ServiceAppointmentAttendeeOwnerSharingRule** — Sharing rules are available for the object.
- **ServiceAppointmentAttendeeShare** — Sharing is available for the object.

---

## Waitlist

이미 예약된 약속 없이 지점을 방문한 drop in 고객이 추가되는 대기열을 나타낸다. **available in API version 58.0 and later.**

### Supported Calls

`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

### Special Access Rules

Salesforce Scheduler must be enabled.

### Fields (8)

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `Description` | `textarea` | Create, Nillable, Update | The description of the waitlist. |
| `IsActive` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the waitlist is available to add drop in customers (true) or not (false). The default value is false. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the waitlist was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the waitlist was last viewed. |
| `Name` | `string` | Create, Filter, Group, idLookup, Sort, Update | The name of the waitlist. |
| `OwnerId` | `reference` | Create, Defaulted on create, Filter, Group, Sort, Update | The owner of the waitlist. This field is a polymorphic relationship field. (Relationship Name: Owner · Relationship Type: Lookup · Refers To: Group, User) |
| `ServiceTerritoryId` | `reference` | Create, Filter, Group, Nillable, Sort | The ID of the service territory to which the waitlist belongs. This field is a relationship field. (Relationship Name: ServiceTerritory · Relationship Type: Lookup · Refers To: ServiceTerritory) |
| `Type` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Specifies the appointment type. Possible values are: DropIn · Queued. The default value is DropIn. |

#### picklist 정리

- **Type** (2값): `DropIn` (기본값) / `Queued`

### Usage

Use waitlists to manage drop in customers. You can create multiple waitlists for a service territory. Depending on your business set up, assign work type groups and service resources to a waitlist. When customers visit the branch, the greeter can check them in to a specific waitlist based on the reason they're visiting the branch. Depending on the availability of service resources on a particular day, you can choose to enable or disable a waitlist.

### Associated Objects

- **WaitlistFeed** — Feed tracking is available for the object.
- **WaitlistHistory** — History is available for tracked fields of the object.
- **WaitlistOwnerSharingRule** — Sharing rules are available for the object.
- **WaitlistShare** — Sharing is available for the object.

---

## WaitlistParticipant

대기열에 추가된 고객을 나타낸다. **available in API version 58.0 and later.**

### Supported Calls

`create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

### Special Access Rules

Salesforce Scheduler must be enabled.

### Fields (13)

> 원문 필드 순서 그대로(sic) — `RelatedRequestId`가 `ParticipantIdentifier` 앞에 온다.

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `AcceptanceTime` | `dateTime` | Create, Filter, Nillable, Sort, Update | The date and time the service resource accepts the appointment request of the waitlist participant. This field is available in API version 59.0 and later. |
| `Description` | `textarea` | Create, Filter, Nillable, Sort, Update | The description of the waitlist participant. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the waitlist participant record was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the waitlist participant record was last viewed. |
| `ParticipantId` | `reference` | Create, Filter, Group, Sort, Update | The ID of the participant that's associated as a parent for the service appointment. This field is a polymorphic relationship field. (Relationship Name: Participant · Relationship Type: Lookup · Refers To: Account, Contact, Lead) |
| `RelatedRequestId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | This field is a relationship field. (Relationship Name: RelatedRequest · Refers To: ClinicalServiceRequest) |
| `ParticipantIdentifier` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | The alphanumeric unique identifier of the participant in a waitlist. For example, D101, E63, A5015 |
| `ServiceAppointmentId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the service appointment that's related to the waitlist participant. This field is a relationship field. (Relationship Name: ServiceAppointment · Relationship Type: Lookup · Refers To: ServiceAppointment) |
| `ServiceResourceId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the service resource that's related to the service appointment for the waitlist participant. This field is a relationship field. (Relationship Name: ServiceResource · Relationship Type: Lookup · Refers To: ServiceResource) |
| `ServiceTerritoryId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | This field is a relationship field. (Relationship Name: ServiceTerritory · Refers To: ServiceTerritory) |
| `Status` | `picklist` | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | The status of waitlist participant. Possible values are: Assigned - Assigned to a service resource. · Unassigned - Waiting to be assigned. The default value is Unassigned. |
| `WaitlistId` | `reference` | Create, Filter, Group, Sort | The ID of the Waitlist that's related to the participant. This field is a relationship field. (Relationship Name: Waitlist · Relationship Type: Lookup · Refers To: Waitlist) |
| `WorkTypeId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the work type that's associated with the service appointment. This field is a relationship field. (Relationship Name: WorkType · Relationship Type: Lookup · Refers To: WorkType) |

> 원문 그대로(sic): `RelatedRequestId`와 `ServiceTerritoryId`는 **Relationship Type 줄이 없다** — Relationship Name과 Refers To만 있고, Description도 "This field is a relationship field." 한 문장뿐이다(다른 관계 필드의 Lookup 표기 없음).

#### picklist 정리

- **Status** (2값): `Assigned` (Assigned to a service resource.) / `Unassigned` (Waiting to be assigned. — 기본값)

### Associated Objects

- **WaitlistParticipantFeed** — Feed tracking is available for the object.
- **WaitlistParticipantHistory** — History is available for tracked fields of the object.

---

## 관련 노트

- [[LxScheduler Namespace]] — Salesforce Scheduler의 Apex 네임스페이스(예약 후보 리소스/슬롯 조회, 외부 캘린더 연동)
- [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]] — ResourcePreference·ServiceResource·ServiceResourceSkill·ServiceTerritory·ServiceTerritoryMember·Shift·Skill·SkillRequirement (배정 후보 리소스/영역/스킬/시프트)
- [[Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형]] — WorkType·AppointmentSchedulingPolicy·OperatingHours. ServiceAppointment의 WorkTypeId가 참조한다.
- [[Salesforce Scheduler 표준객체 — 초대·집계·로그]] — AppointmentInvitation·AppointmentScheduleLog. RelatedRecordId가 ServiceAppointment를 참조한다.
- [[Salesforce Scheduler 커스텀객체]] — WaitlistServiceResource 등 예약 흐름을 잇는 junction 객체.
- [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]] — Scheduler 개요·데이터 모델·셋업.
- sObject/6 Standard Objects.md — 전체 표준객체 참조
