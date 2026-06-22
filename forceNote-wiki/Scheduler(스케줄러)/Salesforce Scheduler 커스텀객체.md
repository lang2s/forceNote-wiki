---
tags: [scheduler, salesforce-scheduler, custom-objects, engagement-channel, shift-worktopic, sobject-reference]
source: salesforce_scheduler_dev_guide.pdf (Salesforce Scheduler Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Scheduler 커스텀객체, EngagementChannelType, ShiftWorkTopic, WaitlistServiceResource, WorkTypeGroupMember, junction 객체]
---

# Salesforce Scheduler 커스텀객체

> Salesforce Scheduler가 약속(appointment) 예약을 위해 사용하는 커스텀객체(custom objects) 10종 — 다수가 표준객체를 잇는 junction(중간관계) 객체 — 의 필드·picklist·Supported Calls·관계필드를 공식 Developer Guide(v67.0)에서 전수 정리한다.

---

## 개요 — 객체 10종 한눈에

이 10개 객체는 대부분 두 표준객체를 잇는 **junction(중간관계) 객체**다. 예를 들어 `EngagementChannelWorkType`은 EngagementChannelType ↔ WorkType을, `WorkTypeGroupMember`는 WorkType ↔ WorkTypeGroup을 연결한다.

| 객체 | 역할 | API 버전 | `search()` 지원 | Salesforce Scheduler 활성화 필요 |
|---|---|---|---|---|
| `ActionableListMbrInvitation` | Actionable List Member ↔ Appointment Invitation 관계 | 59.0+ | ✅ 있음 | 필요 |
| `AppointmentTopicTimeSlot` | time slot의 work type / work type group 조회 | 52.0+ | ❌ 없음 | (Special Access Rules 없음) |
| `EngagementChannelType` | 고객 연락 채널(대면·전화·영상) | 48.0+ | ✅ 있음 | 필요 |
| `EngagementChannelWorkType` | EngagementChannelType ↔ WorkType 관계 | 56.0+ | ❌ 없음 | 필요 |
| `ServiceTerritoryWorkType` | ServiceTerritory ↔ WorkType 관계 | 45.0+ | ❌ 없음 | (Special Access Rules 없음) |
| `ShiftEngagementChannel` | Shift ↔ EngagementChannelType 관계 | 56.0+ | ❌ 없음 | 필요 |
| `ShiftWorkTopic` | Shift ↔ WorkType / WorkTypeGroup 관계 | 56.0+ | ❌ 없음 | 필요 |
| `WaitlistServiceResource` | Waitlist ↔ ServiceResource 관계 | 58.0+ | ❌ 없음 | 필요 |
| `WaitlistWorkType` | Waitlist ↔ WorkType 관계 | 58.0+ | ❌ 없음 | 필요 |
| `WorkTypeGroupMember` | WorkType ↔ WorkTypeGroup 관계 | 45.0+ | ✅ 있음 | 필요 |

> `search()`는 10개 중 **`ActionableListMbrInvitation`·`EngagementChannelType`·`WorkTypeGroupMember` 3개만** 지원한다. 나머지 7개의 Supported Calls에는 `search()`가 없다.
>
> Special Access Rules("Salesforce Scheduler must be enabled.")는 **`AppointmentTopicTimeSlot`·`ServiceTerritoryWorkType` 2개를 제외한 전부**에 적용된다.

---

## 1. ActionableListMbrInvitation

Represents a relationship between an Actionable List Member and an Appointment Invitation. This object is available in API version 59.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `ActionableListMemberId` | `reference` | Create, Filter, Group, Sort, Update | The ID of the actionable list member that's associated with the actionable list member invitation record. This field is a relationship field. |
| `AppointmentInvitationId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the appointment invitation that's associated with the actionable list member invitation record. This field is a relationship field. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date and time when the current user last viewed a related record. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date and time when the current user last viewed this record. |
| `Name` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | Auto-assigned number that identifies the actionable list member invitation record. |
| `ServiceAppointmentId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the service appointment that's associated with the actionable list member invitation. This field is a relationship field. |

### 관계필드 (Relationship Name / Type / Refers To)

| Field | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| `ActionableListMemberId` | ActionableListMember | Lookup | `ActionableListMember` |
| `AppointmentInvitationId` | AppointmentInvitation | Lookup | `AppointmentInvitation` |
| `ServiceAppointmentId` | ServiceAppointment | Lookup | `ServiceAppointment` |

**Associated Objects** — `ActionableListMbrInvitationFeed`(Feed tracking), `ActionableListMbrInvitationHistory`(History).

---

## 2. AppointmentTopicTimeSlot

Represents a lookup to a work type or a work type group for a time slot This object is available in API version 52.0 and later. *([sic] — 원문 "time slot" 뒤 마침표 누락)*

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()` *(`search()` 없음)*

**Special Access Rules**: (없음 — 이 객체는 Salesforce Scheduler 활성화 규칙이 명시되지 않음)

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `AppointmentTopicTimeSlotKey` | `string` | Create, Filter, Group, idLookup, Nillable, Sort, Update | Non-editable validating field used to ensure no two rows have the same time slot and work type or work type group values in an instance. |
| `Name` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | Name or ID of the AppointmentTopicTimeSlot object. |
| `OperatingHoursId` | `reference` | Filter, Group, Nillable, Sort | The operating hours that contain the time slot. This is a relationship field. |
| `TimeSlotId` | `reference` | Create, Filter, Group, Sort, Update | The ID of the time slot. This is a relationship field. |
| `WorkTypeGroupId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The work type group associated with this time slot. This is a relationship field. |
| `WorkTypeId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The work type associated with this time slot. This is a relationship field. |

### 관계필드 (Relationship Name / Type / Refers To)

| Field | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| `OperatingHoursId` | OperatingHours | Lookup | `OperatingHours` |
| `TimeSlotId` | TimeSlot | Lookup | `TimeSlot` |
| `WorkTypeGroupId` | WorkTypeGroup | Lookup | `WorkTypeGroup` |
| `WorkTypeId` | WorkType | Lookup | `WorkType` |

**Associated Objects** — `AppointmentTopicTimeSlotChangeEvent`(Change events), `AppointmentTopicTimeSlotFeed`(Feed tracking), `AppointmentTopicTimeSlotHistory`(History), `AppointmentTopicTimeSlotOwnerSharingRule`(Sharing rules), `AppointmentTopicTimeSlotShare`(Sharing).

---

## 3. EngagementChannelType

Represents a channel through which a customer can be reached for communication. The Engagement Channel Type object supports only the English language. This object is available in API version 48.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `ContactPointType` | `picklist` | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The contact point type of the channel. |
| `IsActive` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the engagement channel type is active (true) or not (false). This field is available in API version 56.0 and later. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed a record related to this record. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed this record. If this value is null, it's possible that this record was referenced (LastReferencedDate) and not viewed. |
| `Name` | `string` | Create, Filter, Group, idLookup, Sort, Update | Required. Name of the communication subscription consent record. |
| `OwnerId` | `reference` | Create, Defaulted on create, Filter, Group, Sort, Update | The ID of the account owner associated with this customer. This field is a polymorphic relationship field. |
| `UsageType` | `multipicklist` | Create, Filter, Nillable, Update | Specifies the usage of the engagement channel type. This field is available in API version 56.0 and later. |

**`ContactPointType` picklist 값 (전수)**:
- `InPerson`—In Person
- `Phone`
- `Video`

**`UsageType` multipicklist 값 (전수)**:
- `Salesforce Scheduler`

### 관계필드 (Relationship Name / Type / Refers To)

| Field | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| `OwnerId` | Owner | Lookup | `Group`, `User` (polymorphic) |

**Associated Objects** — `EngagementChannelTypeFeed`(Feed tracking), `EngagementChannelTypeHistory`(History), `EngagementChannelTypeShare`(Sharing).

---

## 4. EngagementChannelWorkType

Represents the relationship between an Engagement Channel Type object and a Work Type object for Salesforce Scheduler. This object is available in API version 56.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()` *(`search()` 없음)*

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `AreAllEngmtChnlSupported` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the work type supports all engagement channels (true) or not (false). |
| `EngagementChannelTypeId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the engagement channel type that's related to the work type indicated in the WorkTypeId field. This field is a relationship field. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date and time that the current user last viewed a record related to this object. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed this object. |
| `Name` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | The name of this engagement channel-work type relationship. |
| `WorkTypeId` | `reference` | Create, Filter, Group, Sort | The ID of the work type that's related to the engagement channel type indicated in the EngagementChannelTypeId field. This field is a relationship field. |

### 관계필드 (Relationship Name / Type / Refers To)

| Field | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| `EngagementChannelTypeId` | EngagementChannelType | Lookup | `EngagementChannelType` |
| `WorkTypeId` | WorkType | Lookup | `WorkType` |

**Associated Objects** — `EngagementChannelWorkTypeFeed`(Feed tracking), `EngagementChannelWorkTypeHistory`(History).

---

## 5. ServiceTerritoryWorkType

Represents the relationship between a ServiceTerritory object and a WorkType object for Salesforce Scheduler appointments. This object is available in API version 45.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()` *(`search()` 없음)*

**Special Access Rules**: (없음 — 이 객체는 Salesforce Scheduler 활성화 규칙이 명시되지 않음)

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `IsSlotPublished` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicate whether records in the Shift object are created for the selected Service Territory and Work Type. The default value is false. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date and time that the current user last viewed a record related to this object. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed this object. |
| `Name` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | The name of this service territory-work type relationship. |
| `ServiceTerritoryId` | `reference` | Create, Filter, Group, Sort | The ID of the service territory that's related to the work type indicated in the WorkTypeId field. This is a relationship field. |
| `TeamId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | Represents the team associated with the service territory for a specific work type. This field is a relationship field and is available in API version 58.0 and later. |
| `WorkTypeId` | `reference` | Create, Filter, Group, Sort | The ID of the work type that's related to the service territory indicated in the ServiceTerritoryId field. This is a relationship field. |

### 관계필드 (Relationship Name / Type / Refers To)

| Field | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| `ServiceTerritoryId` | ServiceTerritory | Lookup | `ServiceTerritory` |
| `TeamId` | Team | Lookup | `Team` |
| `WorkTypeId` | WorkType | Lookup | `WorkType` |

**Associated Objects** *(원문 헤더: "Unless noted, they are available in the same API version as this object.")* — `ServiceTerritoryWorkTypeFeed`(Feed tracking), `ServiceTerritoryWorkTypeHistory`(History).

---

## 6. ShiftEngagementChannel

Represents the relationship between a Shift object and an Engagement Channel Type object for Salesforce Scheduler. This object is available in API version 56.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()` *(`search()` 없음)*

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `AreAllEngmtChnlSupported` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the shift supports all engagement channels (true) or not (false). |
| `EngagementChannelTypeId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the engagement channel type that's related to the shift indicated in the ShiftId field. This field is a relationship field. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date and time that the current user last viewed a record related to this object. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed this object. |
| `Name` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | The name of this shift-engagement channel type relationship. |
| `ShiftId` | `reference` | Create, Filter, Group, Sort | The ID of the shift that's related to the engagement channel type indicated in the EngagementChannelTypeId field. This field is a relationship field. |

### 관계필드 (Relationship Name / Type / Refers To)

| Field | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| `EngagementChannelTypeId` | EngagementChannelType | Lookup | `EngagementChannelType` |
| `ShiftId` | Shift | Lookup | `Shift` |

**Associated Objects** — `ShiftEngagementChannelFeed`(Feed tracking), `ShiftEngagementChannelHistory`(History).

---

## 7. ShiftWorkTopic

Represents the relationship between a Shift object and a Work Type or Work Type Group object for Salesforce Scheduler. This object is available in API version 56.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()` *(`search()` 없음)*

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `AreAllTopicsSupported` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the shift supports all work type or work type groups (true) or not (false). The default value is false. |
| `AttendeeLimit` | `int` | Create, Defaulted on create, Filter, Group, Sort, Update | The maximum number of attendees for a group service appointment in a shift. This field is considered when the appointment mode is Group. Available in API version 61.0 and later. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date and time that the current user last viewed a record related to this object. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed this object. |
| `MaxAppointments` | `int` | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The maximum number of appointments allowed for each time slot for a shift. This field is considered when WorkTypeId or WorkTypeGroupId is provided. This field is available in API version 60.0 and later. |
| `Name` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | The name of this shift-work topic relationship. |
| `ShiftId` | `reference` | Create, Filter, Group, Sort | The ID of the shift that's related to the work type indicated in the WorkTypeId field or the work type group indicated in the WorkTypeGroupId field. This field is a relationship field. |
| `WorkTypeGroupId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the work type group that's related to the shift indicated in the ShiftId field. This field is a relationship field. |
| `WorkTypeId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the work type that's related to the shift indicated in the ShiftId field. This field is a relationship field. |

### 관계필드 (Relationship Name / Type / Refers To)

| Field | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| `ShiftId` | Shift | Lookup | `Shift` |
| `WorkTypeGroupId` | WorkTypeGroup | Lookup | `WorkTypeGroup` |
| `WorkTypeId` | WorkType | Lookup | `WorkType` |

### Usage

For a ShiftWorkTopic record, you must specify either a work type or a work type group (based on the Salesforce Scheduler for Health Cloud option), or set `AreAllTopicsSupported` as true. Use `WorkTypeGroupId` for Salesforce Scheduler and use `WorkTypeId` only when the Salesforce Scheduler for Health Cloud option is enabled.

**Associated Objects** — `ShiftWorkTopicChangeEvent`(Change events), `ShiftWorkTopicFeed`(Feed tracking), `ShiftWorkTopicHistory`(History), `ShiftWorkTopicOwnerSharingRule`(Sharing rules), `ShiftWorkTopicShare`(Sharing).

---

## 8. WaitlistServiceResource

Represents the relationship between the Waitlist object and the Service Resource object for Salesforce Scheduler. This object is available in API version 58.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()` *(`search()` 없음)*

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `AccessLevel` | `picklist` | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | The access level of the user. The level determines the information that's masked from the service resource for a drop-in participant. |
| `IsAvailable` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the service resource is available to accept a drop-in participant from the waitlist (true) or not (false). The default value is false. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the waitlist service resource record was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the waitlist service resource record was last viewed. |
| `Name` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | Auto-generated number that identifies the waitlist-service resource type record. For example, WSR-0001 and WSR-0002. |
| `ServiceResourceId` | `reference` | Create, Filter, Group, Sort | The ID of the service resource that's related to the waitlist. This field is a relationship field. |
| `WaitlistId` | `reference` | Create, Filter, Group, Sort | The ID of the waitlist that's related to the service resource. This field is a relationship field. |

**`AccessLevel` picklist 값 (전수)**:
- `Default`
- `Enhanced`

The default value is `Default`.

### 관계필드 (Relationship Name / Type / Refers To)

| Field | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| `ServiceResourceId` | ServiceResource | Lookup | `ServiceResource` |
| `WaitlistId` | Waitlist | Lookup | `Waitlist` |

**Associated Objects** — `WaitlistServiceResourceFeed`(Feed tracking), `WaitlistServiceResourceHistory`(History).

---

## 9. WaitlistWorkType

Represents the relationship between the Waitlist object and the Work Type object for Salesforce Scheduler. This object is available in API version 58.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()` *(`search()` 없음)*

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the waitlist work type record was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the waitlist work type record was last viewed. |
| `Name` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | Auto-generated number that identifies the waitlist-work type record. For example, WWT-0001 and WWT-0002. |
| `WaitlistId` | `reference` | Create, Filter, Group, Sort | The ID of the waitlist that's related to the wok type. This field is a relationship field. *([sic] — 원문 "wok type", work 오타)* |
| `WorkTypeId` | `reference` | Create, Filter, Group, Sort, Update | The ID of the work type that's related to the waitlist. This field is a relationship field. |

### 관계필드 (Relationship Name / Type / Refers To)

| Field | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| `WaitlistId` | Waitlist | Lookup | `Waitlist` |
| `WorkTypeId` | WorkType | Lookup | `WorkType` |

**Associated Objects** — `WaitlistWorkTypeFeed`(Feed tracking), `WaitlistWorkTypeHistory`(History).

---

## 10. WorkTypeGroupMember

Represents the relationship between a work type and the work type group it belongs to. This object is available in API version 45.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date and time that the current user last viewed a record related to this object. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed this object. |
| `Name` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | Autogenerated number identifying the work type group membership. It uses the format ########. |
| `WorkTypeGroupId` | `reference` | Create, Filter, Group, Sort | The ID of the work type group that this record belongs to. *([sic] — 다른 관계필드와 달리 "This is a relationship field." 문장이 원문에 없음)* |
| `WorkTypeId` | `reference` | Create, Filter, Group, Sort | The ID of the work type that this record corresponds to. This is a relationship field. |

### 관계필드 (Relationship Name / Type / Refers To)

| Field | Relationship Name | Relationship Type | Refers To |
|---|---|---|---|
| `WorkTypeGroupId` | WorkTypeGroup | Lookup | `WorkTypeGroup` |
| `WorkTypeId` | WorkType | Lookup | `WorkType` |

**Associated Objects** *(원문 헤더: "Unless noted, they're available in the same API version as this object.")* — `WorkTypeGroupMemberFeed`(Feed tracking), `WorkTypeGroupMemberHistory`(History).

---

## SOQL 예시

```sql
-- 구조 예시 — 실제 동작 쿼리 아님
-- 특정 Shift에 연결된 work type / work type group 조회 (ShiftWorkTopic junction)
SELECT Id, Name, ShiftId, WorkTypeId, WorkTypeGroupId, AreAllTopicsSupported, MaxAppointments
FROM ShiftWorkTopic
WHERE ShiftId = '08p000000000000AAA'

-- WorkType ↔ WorkTypeGroup 멤버십 조회 (WorkTypeGroupMember junction)
SELECT Id, Name, WorkTypeId, WorkTypeGroupId
FROM WorkTypeGroupMember
WHERE WorkTypeGroupId = '0VS000000000000AAA'
```

---

## 관련 노트

- [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]] — Scheduler 개발자 진입점·데이터 모델·인증·toLabel SOQL
- [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]] — ServiceResource·ServiceTerritory·Shift 등 junction이 참조하는 표준객체
- [[Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형]] — WorkType·WorkTypeGroup·OperatingHours·TimeSlot 등 이 커스텀객체가 잇는 표준객체
- [[Salesforce Scheduler 표준객체 — 핵심 예약]] — ServiceAppointment·Waitlist 등 예약 흐름 핵심 표준객체
- [[Salesforce Scheduler 표준객체 — 초대·집계·로그]] — AppointmentInvitation·AppointmentInvitee 등 초대/집계 객체
- sObject/API Field Properties.md — Field Properties(Create/Filter/Group/Nillable/Restricted picklist/Sort/Update 등) 의미
