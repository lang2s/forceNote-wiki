---
tags: [scheduler, salesforce-scheduler, standard-objects, appointment-invitation, appointment-schedule, sobject-reference]
source: salesforce_scheduler_dev_guide.pdf (Salesforce Scheduler Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [AppointmentInvitation, AppointmentInvitee, AppointmentScheduleAggr, AppointmentScheduleLog, 약속 초대 객체, load balancing 활용도]
---

# Salesforce Scheduler 표준객체 — 초대·집계·로그

> 고객 셀프 부킹용 약속 초대(AppointmentInvitation / AppointmentInvitee)와 Load Balancing 배정 정책의 리소스 활용도 집계·로그(AppointmentScheduleAggr / AppointmentScheduleLog) 4개 표준객체의 필드 전수.

---

이 노트는 Salesforce Scheduler 표준객체 중 **초대(invitation)** 와 **리소스 활용도(utilization)** 계열 4종을 다룬다. 모든 객체는 `Salesforce Scheduler must be enabled` 또는 별도 접근 규칙이 적용되며, 각 객체의 Supported Calls·필드 표·picklist·연관 객체를 소스 그대로 전사했다.

- 약속 초대: [AppointmentInvitation](#appointmentinvitation) (API 55.0+), [AppointmentInvitee](#appointmentinvitee) (API 55.0+)
- 리소스 활용도: [AppointmentScheduleAggr](#appointmentscheduleaggr) (API 52.0+), [AppointmentScheduleLog](#appointmentschedulelog) (API 52.0+)

---

## AppointmentInvitation

Represents information about an appointment invitation that's created for customers who can use it for booking appointments. This object is available in **API version 55.0 and later**.

**Supported Calls**

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), search(), undelete(), update(), upsert()
```

**Special Access Rules**
Salesforce Scheduler must be enabled.

### 필드 (15)

| Field | Type | Properties | Description |
|---|---|---|---|
| `AppointmentTopicId` | `reference` | Create, Filter, Group, Nillable, Sort | Appointment topic that's associated with this invitation. This field is a polymorphic relationship field. |
| `AppointmentTopicType` | `string` | Filter, Group, Nillable, Sort | Type of appointment topic that's related to this invitation. For example, work type or work type group. |
| `AppointmentType` | `picklist` | Create, Filter, Group, Nillable, Sort | Appointment type for the appointment invitation. This field is available in API version 57.0 and later. (picklist — 아래 참조) Salesforce Scheduler verifies whether the API name of a picklist value matches the name of a utility icon that Lightning Design System provides. If the names match, Salesforce Scheduler uses the icon with the same name. If the names don't match, Salesforce Scheduler uses the default groups icon. |
| `BookingEndDate` | `date` | Create, Filter, Group, Nillable, Sort, Update | Date until which an appointment can be booked by using the appointment invitation URL. |
| `BookingStartDate` | `date` | Create, Filter, Group, Nillable, Sort, Update | Date from which an appointment can be booked by using the appointment invitation URL. Default value: current date. |
| `EngagementChannelTypeId` | `reference` | Create, Filter, Group, Nillable, Sort | Engagement channel type for the appointment invitation. For example, users can choose video call as the engagement channel type when they create an appointment invitation. This field is available in API version 57.0 and later. This field is a relationship field. |
| `InvitationIdentifier` | `string` | Filter, Group, Nillable, Sort | Invitation URL identifier that's used to book an appointment in a flow. |
| `InvitationNumber` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | Auto-assigned number that identifies the appointment invitation. |
| `InvitationUrl` | `url` | Create, Filter, Group, Nillable, Sort | Appointment invitation URL that's shared with users to book appointments. |
| `IsActive` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the invitation URL is available for a customer to book an appointment. The default value is `true`. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | Date on which the appointment invitation was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | Date on which the appointment invitation was last viewed. |
| `OwnerId` | `reference` | Create, Defaulted on create, Filter, Group, Sort, Update | Owner of the appointment invitation. This field is a polymorphic relationship field. |
| `ServiceTerritoryId` | `reference` | Create, Filter, Group, Nillable, Sort | Service territory that's associated with the appointment invitation. This field is a relationship field. |
| `UrlExpiryDate` | `date` | Create, Filter, Group, Nillable, Sort, Update | Expiration date of the appointment invitation URL. |

**`AppointmentType` picklist 권장값 (Recommended values)** — API version 57.0 and later:

| API name | Label |
|---|---|
| `groups` | Group |
| `resource_territory` | In Person |
| `phone_portrait` | Phone |
| `video` | Video call |

**관계 필드 (Relationship Name / Type / Refers To)**

| Field | Relationship Name | Type | Refers To |
|---|---|---|---|
| `AppointmentTopicId` | AppointmentTopic | Lookup | `WorkType`, `WorkTypeGroup` |
| `EngagementChannelTypeId` | EngagementChannelType | Lookup | `EngagementChannelType` |
| `OwnerId` | Owner | Lookup | `Group`, `User` |
| `ServiceTerritoryId` | ServiceTerritory | Lookup | `ServiceTerritory` |

**Usage**
An appointment invitation can show the availability of one or more resources represented in the Appointment Invitee object.

**Associated Objects**
API version이 명시되지 않으면 이 객체와 동일한 API 버전부터 사용 가능하다. 그 외에는 명시된 API 버전 이상에서 사용 가능하다.

- `AppointmentInvitationChangeEvent` — Change events are available for the object.
- `AppointmentInvitationFeed` — Feed tracking is available for the object.
- `AppointmentInvitationHistory` — History is available for tracked fields of the object.
- `AppointmentInvitationOwnerSharingRule` — Sharing rules are available for the object.
- `AppointmentInvitationShare` — Sharing is available for the object.

---

## AppointmentInvitee

Represents information about the participant and resources required for creating an appointment invitation URL. This object is available in **API version 55.0 and later**.

**Supported Calls**

```
create(), delete(), describeLayout(), describeSObjects(), getDeleted(), getUpdated(), query(),
retrieve(), search(), undelete(), update(), upsert()
```

**Special Access Rules**
Salesforce Scheduler must be enabled.

### 필드 (7)

| Field | Type | Properties | Description |
|---|---|---|---|
| `AppointmentInvitationId` | `reference` | Create, Filter, Group, Sort | ID of the appointment invitation. This field is a relationship field. |
| `IsPrimaryResource` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether a service resource that's used to book an appointment is a primary resource. The default value is false. |
| `IsRequiredResource` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether a service resource is required to book an appointment. The default value is false. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | Date on which the appointment invitee record was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | Date on which the appointment invitee record was last viewed. |
| `Name` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | Auto-assigned number that identifies the appointment invitee. |
| `ParticipantServiceResourceId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | Service resource who's assigned to the appointment invitation. This field is a relationship field. |

**관계 필드 (Relationship Name / Type / Refers To)**

| Field | Relationship Name | Type | Refers To |
|---|---|---|---|
| `AppointmentInvitationId` | AppointmentInvitation | Lookup | `AppointmentInvitation` |
| `ParticipantServiceResourceId` | ParticipantServiceResource | Lookup | `ServiceResource` |

> 이 객체에는 별도의 Usage 섹션이 없다 (소스 미수록).

**Associated Objects**

- `AppointmentInviteeChangeEvent` — Change events are available for the object.
- `AppointmentInviteeFeed` — Feed tracking is available for the object.
- `AppointmentInviteeHistory` — History is available for tracked fields of the object.
- `AppointmentInviteeOwnerSharingRule` — Sharing rules are available for the object.
- `AppointmentInviteeShare` — Sharing is available for the object.

---

## AppointmentScheduleAggr

Records the utilization of a service resource, by date, for the Load Balancing appointment assignment policy. This object is available in **API version 52.0 and later**.

**Supported Calls**

```
create(), delete(), describeSObjects(), getDeleted(), getUpdated(), query(), retrieve(),
undelete(), update(), upsert()
```

> Special Access Rules 섹션이 소스에 없다.

### 필드 (6)

| Field | Type | Properties | Description |
|---|---|---|---|
| `AppointmentDate` | `date` | Create, Filter, Group, Nillable, Sort, Update | The date of the appointment. |
| `Name` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | The name or ID of the AppointmentScheduleAggr object. |
| `ResourceUtilizationCount` | `integer` | Filter, Group, Nillable, Sort | The number of appointments scheduled for a service resource. Available in API version 53.0 and later. This is a calculated field. |
| `ServiceResourceId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The service resource associated with the appointment scheduling aggregate. This is a relationship field. |
| `TotalResourceUtilization` | `double` | Filter, Nillable, Sort | The number of minutes for which the service resource has scheduled appointments. This is a calculated field. |
| `UsageType` | `picklist` | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | Specify the usage type of the AppointmentScheduleAggr object. (possible values — 아래 참조) The default value is `'LightningScheduler'`. |

**`UsageType` picklist — Possible values:**

- `FSL_Daily`
- `FSL_Monthly`
- `FSL_Weekly`
- `LightningScheduler`

**관계 필드 (Relationship Name / Type / Refers To)**

| Field | Relationship Name | Type | Refers To |
|---|---|---|---|
| `ServiceResourceId` | ServiceResource | Lookup | `ServiceResource` |

**Associated Objects**

- `AppointmentScheduleAggrOwnerSharingRule` — Sharing rules are available for the object.
- `AppointmentScheduleAggrShare` — Sharing is available for the object.

---

## AppointmentScheduleLog

Stores service appointments of each service Resource. This object is used to calculate the utilization of a service resource for the AppointmentScheduleAggr object. This object is available in **API version 52.0 and later**.

**Supported Calls**

```
create(), delete(), describeSObjects(), getDeleted(), getUpdated(), query(), retrieve(),
undelete(), update(), upsert()
```

> Special Access Rules 섹션이 소스에 없다.

### 필드 (8)

| Field | Type | Properties | Description |
|---|---|---|---|
| `AppointmentDate` | `date` | Create, Filter, Group, Nillable, Sort, Update | The date of the appointment. |
| `AppointmentScheduleAggrId` | `reference` | Create, Filter, Group, Sort | The appointment scheduling aggregate associated with the appointment scheduling log. This is a relationship field. |
| `IsUsedForResourceUtilization` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the appointment scheduling log is used for deriving the appointment scheduling aggregate. The default value is `'false'`. |
| `Name` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | The name or ID of the AppointmentScheduleLog object. |
| `RelatedRecordId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The service appointment, resource absence, event, or any other related record associated with the appointment scheduling log. This is a polymorphic relationship field. |
| `ResourceUtilization` | `double` | Create, Filter, Nillable, Sort, Update | The number of minutes the service resource already has scheduled appointments for. |
| `ServiceResourceId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The service resource associated with the appointment scheduling log. This is a relationship field. |
| `UsageType` | `picklist` | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | Specify the product associated with the AppointmentScheduleLog object. (possible values — 아래 참조) The default value is `'LightningScheduler'`. |

**`UsageType` picklist — Possible values (값—라벨):**

| API name | Label |
|---|---|
| `FSL_Daily` | FSL - Daily |
| `FSL_Monthly` | FSL - Monthly |
| `FSL_Weekly` | FSL - Weekly |
| `LightningScheduler` | Lightning Scheduler |

**관계 필드 (Relationship Name / Type / Refers To)**

| Field | Relationship Name | Type | Refers To |
|---|---|---|---|
| `AppointmentScheduleAggrId` | AppointmentScheduleAggr | Lookup | `AppointmentScheduleAggr` |
| `RelatedRecordId` | RelatedRecord | Lookup | `Event`, `ServiceAppointment` |
| `ServiceResourceId` | ServiceResource | Lookup | `ServiceResource` |

**Associated Objects**

- `AppointmentScheduleLogChangeEvent` — Change events are available for the object.
- `AppointmentScheduleLogFeed` — Feed tracking is available for the object.
- `AppointmentScheduleLogHistory` — History is available for tracked fields of the object.
- `AppointmentScheduleLogOwnerSharingRule` — Sharing rules are available for the object.
- `AppointmentScheduleLogShare` — Sharing is available for the object.

---

## 두 UsageType picklist 형식 차이 (소스 그대로)

소스에서 `AppointmentScheduleAggr.UsageType`과 `AppointmentScheduleLog.UsageType`은 **표기 형식이 다르다** — 통일하지 않고 원문 그대로 보존한다.

- `AppointmentScheduleAggr.UsageType` — API name만 나열 (`FSL_Daily` / `FSL_Monthly` / `FSL_Weekly` / `LightningScheduler`)
- `AppointmentScheduleLog.UsageType` — API name—Label 쌍 (`FSL_Daily—FSL - Daily` 등)

default 표기도 객체마다 다르다: `IsActive`는 평문 `The default value is true.`, `IsPrimaryResource`/`IsRequiredResource`는 평문 `false`, `IsUsedForResourceUtilization`은 따옴표 포함 `'false'`, UsageType 두 곳은 `'LightningScheduler'`.

---

## 관련 노트

- [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]] — ServiceResource·ServiceTerritory 등. 이 노트의 ServiceResourceId/ParticipantServiceResourceId/ServiceTerritoryId가 참조하는 리소스·영역 객체.
- [[Salesforce Scheduler 표준객체 — 핵심 예약]] — ServiceAppointment·AssignedResource 등 예약 흐름. RelatedRecordId가 ServiceAppointment를 참조한다.
- [[Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형]] — WorkType·WorkTypeGroup. AppointmentTopicId가 이 둘을 참조한다.
- [[Salesforce Scheduler 커스텀객체]] — EngagementChannelType·WorkTypeGroupMember 등 junction 커스텀객체.
- [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]] — 개요·데이터 모델·셋업.
- sObject/6 Standard Objects.md — 전체 표준객체 레퍼런스 (sObject 폴더 — 폴더 간 plain-text 참조)
- sObject/API Field Properties.md — Field Properties(Create/Filter/Group/Nillable/Sort/Update 등) 의미
