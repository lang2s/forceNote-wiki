---
tags: [scheduler, salesforce-scheduler, standard-objects, serviceresource, serviceterritory, shift, sobject-reference]
source: salesforce_scheduler_dev_guide.pdf (Salesforce Scheduler Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [ServiceResource 필드, ServiceTerritory, Shift RRULE, ServiceResourceSkill, SkillRequirement, 리소스 시프트 객체]
---

# Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트

> Salesforce Scheduler의 핵심 표준객체 9종(ResourcePreference·ResourceAbsence·ServiceResource·ServiceResourceSkill·ServiceTerritory·ServiceTerritoryMember·Shift·Skill·SkillRequirement)의 필드·picklist·RRULE 레퍼런스 전수.

---

이 노트는 Salesforce Scheduler Developer Guide(v67.0 Summer '26)의 "Salesforce Scheduler Standard Objects" 챕터를 객체별로 전수 전사한 레퍼런스다. 각 객체는 설명·Supported Calls·Special Access Rules·필드 표·picklist 값·Usage·Associated Objects 순으로 정리한다. 필드 표는 `Field Name | Type | Properties | Description` 4열이며, 관계 필드는 Description 아래에 `Relationship Name / Relationship Type / Refers To`를 함께 기록한다.

대부분의 객체는 다음 Special Access Rule을 공유한다.

```
// 구조 예시 — 실제 동작 코드 아님
Special Access Rules: Salesforce Scheduler must be enabled.
```

---

## ResourcePreference

Represents an account's preference for a specified service resource.

Resource preferences indicate which service resources should be assigned to a service appointment. You can designate service resources as preferred, required, or excluded on accounts.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `update()`, `upsert()`

### Fields

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the resource preference was last modified. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the resource preference was last viewed. |
| `PreferenceType` | `picklist` | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | Resource preference type. Values include Preferred / Required / Excluded (아래 picklist 참조). Resource preferences serve more as a suggestion than a requirement. You can still assign a service appointment to any resource regardless of the related account's resource preferences. |
| `RelatedRecordId` | `reference` | Create, Filter, Group, Sort | The account with the resource preference. This is a polymorphic relationship field. — Relationship Name: `RelatedRecord` / Relationship Type: Lookup / Refers To: `Account` |
| `ResourcePreferenceNumber` | `string` | Autonumber, Defaulted on create, Filter, Sort | An auto-generated number identifying the resource preference. |
| `ServiceResourceId` | `reference` | Create, Filter, Group, Sort, Update | The service resource that is preferred, required, or excluded. This is a relationship field. — Relationship Name: `ServiceResource` / Relationship Type: Lookup / Refers To: `ServiceResource` |

### PreferenceType picklist 값 (전수)

- **Preferred** — Indicates that the user would like their appointment assigned to the resource.
- **Required** — Indicates that the resource must be assigned to the appointment.
- **Excluded** — Indicates that the resource must not be assigned to the appointment.

### Associated Objects

This object has the following associated objects. Unless noted, they are available in the same API version as this object.

- `ResourcePreferenceFeed` — Feed tracking is available for the object.
- `ResourcePreferenceHistory` — History is available for tracked fields of the object.

---

## ResourceAbsence

Represents a time period in which a service resource is unavailable to work in Salesforce Scheduler. This object is available in API version 38.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `AbsenceNumber` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | (Read only) An auto-generated number identifying the absence. |
| `Description` | `textarea` | Create, Nillable, Update | The description of the absence. |
| `End` | `dateTime` | Create, Filter, Sort, Update | The date and time when the absence ends. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the resource absence was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the resource absence was last viewed. |
| `ResourceId` | `reference` | Create, Filter, Group, Sort | The absent service resource. This is a relationship field. — Relationship Name: `Resource` / Relationship Type: Lookup / Refers To: `ServiceResource` |
| `Start` | `dateTime` | Create, Filter, Sort, Update | The date and time when the absence begins. |

### Usage

Resource absences you define periods of time when a service resource is unavailable to work.

> **Tip**: Create a trigger that sends an approval request to a supervisor when a service resource creates an absence.

### Associated Objects

This object has the following associated objects. If the API version isn't specified, they're available in the same API versions as this object. Otherwise, they're available in the specified API version and later.

- `ResourceAbsenceChangeEvent` (API version 48.0) — Change events are available for the object.
- `ResourceAbsenceFeed` — Feed tracking is available for the object.
- `ResourceAbsenceHistory` — History is available for tracked fields of the object.

---

## ServiceResource

Represents a technician or an asset. This object is available in API version 38.0 and later.

A technician represents an employee from your organization, such as a loan officer, investment advisor, doctor, nurse practitioner, or retail store specialist, who attends appointments with clients. An asset represents an item of commercial value, such as a product sold by your company or a competitor, that a customer has purchased and installed.

**Supported Calls**: `create()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `AssetId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | ID of the Asset. This is a relationship field. — Relationship Name: `Asset` / Relationship Type: Lookup / Refers To: `Asset` |
| `Description` | `textarea` | Create, Nillable, Update | The description of the resource. |
| `IsActive` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | When selected, this option means that the resource can be assigned to appointments. For service tracking purposes, resources can't be deleted, so deactivating a resource is the best way to send them into retirement. Deactivating a user doesn't deactivate the related service resource. You can't create a service resource that is linked to an inactive user. |
| `IsPrimary` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicate whether Salesforce Scheduler must consider the service resource record for scheduling appointments (true) or not (false). Note: This field is applicable only if the Main Service Resource setting is enabled in your Salesforce org. This field is available in API version 57.0 and later. The default value is false. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the service resource was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the service resource was last viewed. |
| `RelatedRecordId` | `reference` | Create, Filter, Group, Sort, Nillable, Update | The associated user. Its label in the UI is User. If the service resource represents a service crew rather than a user, leave the User field blank and select the related crew in the ServiceCrewId field. |
| `ResourceType` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Indicates whether the resource is a Technician (T) or Asset (S). The default value is Technician (T). You can't add additional resource types. |

> [sic] 원문 그대로: IsActive 설명의 "this option means that" 표현, RelatedRecordId의 Refers To 명시 없음(설명만 존재).

### ResourceType picklist 값 (전수)

- **Technician (T)** — 기본값. 직원(employee)을 나타낸다.
- **Asset (S)** — 상업적 가치가 있는 자산을 나타낸다.

(You can't add additional resource types — 추가 값 정의 불가.)

### Associated Objects

This object has the following associated objects. If the API version isn't specified, they're available in the same API versions as this object. Otherwise, they're available in the specified API version and later.

- `ServiceResourceChangeEvent` (API version 48.0) — Change events are available for the object.
- `ServiceResourceFeed` — Feed tracking is available for the object.
- `ServiceResourceHistory` — History is available for tracked fields of the object.
- `ServiceResourceOwnerSharingRule` — Sharing rules are available for the object.
- `ServiceResourceShare` — Sharing is available for the object.

---

## ServiceResourceSkill

Represents a skill that a service resource possesses in Salesforce Scheduler. This object is available in API version 38.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `EffectiveEndDate` | `datetime` | Create, Filter, Nillable, Sort, Update | The date when the skill expires. For example, if a service resource must be recertified after six months, the end date would be the date their certification expires. |
| `EffectiveStartDate` | `datetime` | Create, Filter, Sort, Update | The date when the service resource gains the skill. For example, if the skill represents a certification, the start date would be the date of certification. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the resource skill was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the resource skill was last viewed. |
| `ServiceResourceId` | `reference` | Create, Filter, Group, Sort | The service resource who possesses the skill. This is a relationship field. — Relationship Name: `ServiceResource` / Relationship Type: Lookup / Refers To: `ServiceResource` |
| `SkillId` | `reference` | Create, Filter, Group, Sort, Update | The skill the service resource possesses. This is a relationship field. — Relationship Name: `Skill` / Relationship Type: Lookup / Refers To: `Skill` |
| `SkillLevel` | `double` | Create, Defaulted on create, Filter, Nillable, Sort, Update | The service resource's skill level. Skill level can range from zero to 99.99. |
| `SkillNumber` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-generated number identifying the resource skill assignment. |

> [sic] 원문 그대로: `EffectiveEndDate`·`EffectiveStartDate`의 Type이 소문자 `datetime`(타 필드의 `dateTime`과 표기 불일치).

### Usage

You can assign skills to all service resources in your org to indicate their certifications and areas of expertise, and specify each resource's skill level from 0 to 99.99. For example, you can assign Maria the "Welding" skill, level 50.

If you intend to use the skills feature, determine which skills you want to track and how skill level must be determined. For example, you can want the skill level to reflect years of experience, certification levels, or license classes.

### Associated Objects

This object has the following associated objects. Unless noted, they're available in the same API version as this object.

- `ServiceResourceSkillFeed` — Feed tracking is available for the object.
- `ServiceResourceSkillHistory` — History is available for tracked fields of the object.

---

## ServiceTerritory

Represents a geographic or functional region in which work can be performed in Salesforce Scheduler. This object is available in API version 38.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `Address` | `address` | Filter | An address to associate with the territory. You can want to list the address of the territory's headquarters. |
| `City` | `string` | Create, Filter, Group, Nillable, Sort, Update | The city of the associated address. Maximum length is 40 characters. |
| `Country` | `string` | Create, Filter, Group, Nillable, Sort, Update | The country to associate with the territory. Maximum length is 80 characters. |
| `Description` | `textarea` | Create, Nillable, Update | The description of the territory. |
| `IsActive` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the service territory is meant to be used. If a territory is inactive, you can't add members to it or link it to service appointments. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the territory was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the territory was last viewed. |
| `Name` | `string` | Create, Filter, Group, idLookup, Sort, Update | The name of the territory. |
| `OperatingHoursId` | `reference` | Create, Filter, Group, Sort, Update | The territory's operating hours, which indicate when service appointments within the territory can occur. Service resources who are members of a territory automatically inherit the territory's operating hours unless different hours are specified on the resource record. This is a relationship field. — Relationship Name: `OperatingHours` / Relationship Type: Lookup / Refers To: `OperatingHours` |
| `PostalCode` | `string` | Create, Filter, Group, Nillable, Sort, Update | The postal code of the address associated with the territory. Maximum length is 20 characters. |
| `PricebookId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | This field creates a foreign key relationship with the PriceBook record, storing data related to pricing. This is a relationship field. — Relationship Name: `PriceBook` / Relationship Type: Lookup / Refers To: `PriceBook2` |
| `State` | `string` | Create, Filter, Group, Nillable, Sort, Update | The state of the address associated with the territory. Maximum length is 80 characters. |
| `Street` | `textarea` | Create, Filter, Group, Nillable, Sort, Update | The street number and name of the address associated with the territory. |

> [sic] 원문 그대로: `Address` 설명의 "You can want to list the address of the territory's headquarters."

### Usage

If you want to use service territories, determine which territories you must create. Depending on how your business works, you can decide to create territories based on cities or counties, or on functional categories such as sales versus service. If you plan to build out a hierarchy of service territories, create the highest-level territories first.

For example, you can create a hierarchy of territories to represent the areas where your team works in California. Include a top-level territory named California, three child territories named Northern California, Central California, and Southern California, and a series of third-level territories corresponding to California counties. Assign service resources to each county territory to indicate who is available to work in that county.

### Associated Objects

This object has the following associated objects. If the API version isn't specified, they're available in the same API versions as this object. Otherwise, they're available in the specified API version and later.

- `ServiceTerritoryChangeEvent` (API version 48.0) — Change events are available for the object.
- `ServiceTerritoryFeed` — Feed tracking is available for the object.
- `ServiceTerritoryHistory` — History is available for tracked fields of the object.
- `ServiceTerritoryOwnerSharingRule` — Sharing rules are available for the object.
- `ServiceTerritoryShare` — Sharing is available for the object.

---

## ServiceTerritoryMember

Represents a service resource who can be assigned to service appointments in a service territory in Salesforce Scheduler. This object is available in API version 38.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `Address` | `address` | Filter | The member's address. You can want to list the related service resource's address in this field. |
| `EffectiveEndDate` | `datetime` | Create, Filter, Nillable, Sort, Update | The date when the service resource is no longer a member of the territory. If the resource will be working in the territory for the foreseeable future, leave this field blank. This field is useful for indicating when a temporary relocation ends. |
| `EffectiveStartDate` | `datetime` | Create, Filter, Sort, Update | The date when the service resource becomes a member of the service territory. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the territory member was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the territory member was last viewed. |
| `OperatingHoursId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The operating hours assigned to the service territory member. If no operating hours are specified, the member is assumed to use their parent service territory's operating hours. If a member needs special operating hours, create them in Setup and select them in the Operating Hours lookup field on the member's detail page. This is a relationship field. — Relationship Name: `OperatingHours` / Relationship Type: Lookup / Refers To: `OperatingHours` |
| `Role` | `picklist` | Create, Filter, Group, Nillable, Sort, Update | The role associated with the service resource. |
| `ServiceResourceId` | `reference` | Create, Filter, Group, Sort, Update | The service resource assigned to the service territory. This is a relationship field. — Relationship Name: `ServiceResource` / Relationship Type: Lookup / Refers To: `ServiceResource` |
| `ServiceTerritoryId` | `reference` | Create, Filter, Group, Sort | The service territory that the service resource is assigned to. This is a relationship field. — Relationship Name: `ServiceTerritory` / Relationship Type: Lookup / Refers To: `ServiceTerritory` |
| `TerritoryType` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Primary, Secondary, or Relocation (아래 picklist 참조). |

> [sic] 원문 그대로: `Address` 설명의 "You can want to list the related service resource's address"; `EffectiveEndDate`·`EffectiveStartDate`의 Type이 소문자 `datetime`.

### TerritoryType picklist 값 (전수, 각 설명 원문)

- **Primary** — The primary territory is typically the territory where the resource works most often — for example, near their home base. Service resources can only have one primary territory.
- **Secondary** — Secondary territories are territories where the resource can be assigned to appointments, if needed. Service resources can have multiple secondary territories.
- **Relocation** — Relocation territories represent temporary moves for service resources.

예시 (For example, a service resource can have the following territories):

- Primary territory: West Chicago
- Secondary territories: East Chicago / South Chicago
- Relocation territory: Manhattan, for a three-month period

### Usage

If you delete a service territory with members, the service resources who were members no longer have any connection to the territory.

### Associated Objects

This object has the following associated objects. If the API version isn't specified, they're available in the same API versions as this object. Otherwise, they're available in the specified API version and later.

- `ServiceTerritoryMemberChangeEvent` (API version 48.0) — Change events are available for the object.
- `ServiceTerritoryMemberFeed` — Feed tracking is available for the object.
- `ServiceTerritoryMemberHistory` — History is available for tracked fields of the object.

---

## Shift

Represents a shift for service resource scheduling. This object is available in API version 46.0 and later.

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules**: Salesforce Scheduler is enabled. Users have Shift permission.

### Fields

> [sic] 원문 그대로: Shift 필드 표의 첫 열 헤더는 다른 객체와 달리 "Field Name"이 아니라 "Field"다. (pdftoppm 시각 검증 완료 — 물리 페이지 74, 인쇄 페이지 66)

| Field | Type | Properties | Description |
|---|---|---|---|
| `AppointmentCategoryId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | This field is a relationship field. Available in API version 61.0 and later. — Relationship Name: `ShiftAppointmentCategory` / Relationship Type: Lookup / Refers To: `AppointmentCategory` |
| `BackgroundColor` | `string` | Create, Filter, Group, Nillable, Sort, Update | Sets a background color for shifts shown in the UI. Use a 3- or 6-digit hexadecimal format. For example, #FF00FF. Available in API version 55.0 and later. |
| `EndTime` | `dateTime` | Create, Filter, Sort, Update | The date and time that the shift ends. |
| `Label` | `string` | Create, Filter, Group, Nillable, Sort, Update | The label that a shift is given. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date and time when the current user last viewed a related record. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date and time when the current user last viewed this record. |
| `OwnerId` | `reference` | Create, Defaulted on create, Filter, Group, Sort, Update | The owner of the shift. This is a polymorphic relationship field. — Relationship Name: `Owner` / Relationship Type: Lookup / Refers To: `Group`, `User` |
| `RecurrenceEndDate` | `date` | Create, Group, Nillable, Sort, Update | The date when the recurrence period ends. The date must be after the Recurrence Start Date. The value for this field is retrieved from the pattern defined in the RecurrencePattern field. You can define the end date by using the COUNT or UNTIL parameter in the RecurrencePattern field. If you specify a value in this field and define a recurrence pattern, Salesforce Scheduler overrides the value with the end date in the recurrence pattern. The recurrence period is limited to 180 days. This field is available in API version 56.0 and later. |
| `RecurrencePattern` | `string` | Create, Group, Nillable, Sort, Update | The RRULE that describes the recurrence pattern for recurring shifts. Supports a subset of the RFC 5545 standard for internet calendaring and scheduling. See the Salesforce Scheduler Recurring Shifts section in this topic for usage examples. The period for the recurrence pattern is limited to 180 days. This field is available in API version 56.0 and later. |
| `RecurrenceStartDate` | `date` | Create, Group, Nillable, Sort, Update | The date when the recurrence period begins. The date must be before the Recurrence End Date. The value for this field is retrieved from the StartTime field. Don't modify the value for this field. This field is available in API version 56.0 and later. |
| `ServiceResourceId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the service resource the shift belongs to. Available in API versions 47.0 and later. This is a relationship field. — Relationship Name: `ServiceResource` / Relationship Type: Lookup / Refers To: `ServiceResource` |
| `ServiceTerritoryId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the service territory the shift belongs to. Available in API versions 47.0 and later. This is a relationship field. — Relationship Name: `ServiceTerritory` / Relationship Type: Lookup / Refers To: `ServiceTerritory` |
| `ShiftNumber` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | The number automatically given to the shift upon creation. |
| `StartTime` | `dateTime` | Create, Filter, Sort, Update | The date and time that the shift starts. |
| `Status` | `picklist` | Create, Defaulted on create, Filter, Group, Sort, Update | Describes the status of the shift. Users can create custom values. Possible values are Confirmed / Fixed / Published / Tentative. The default value is 'Tentative'. |
| `StatusCategory` | `picklist` | Filter, Group, Nillable, Restricted picklist, Sort | Describes the status of the shift using static values. This field is derived from Status using the mapping defined in setup. Possible values are Confirmed / Published / Tentative. |
| `TimeSlotType` | `picklist` | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | Type of time slot for the shift. The same setup values as the TimeSlot field in the OperatingHours object. Possible values are Extended / Normal (default value). The default value is 'Normal'. |
| `Type` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Type of shift. Possible values are Recurring / Regular. The default value is Regular. This field is available in API version 56.0 and later. |
| `WorkTypeGroupId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the work type group the shift belongs to. Available in API versions 54.0 and later. This is a relationship field. — Relationship Name: `WorkTypeGroup` / Relationship Type: Lookup / Refers To: `WorkTypeGroup` |

### picklist 값 (전수)

**Status** — Users can create custom values. 기본 정의 값:

- Confirmed
- Fixed
- Published
- Tentative (default value `'Tentative'`)

**StatusCategory** — static 값. Status로부터 setup에 정의된 매핑으로 파생:

- Confirmed
- Published
- Tentative

> 주의: Status에는 4값(Confirmed/Fixed/Published/Tentative)이 있으나 StatusCategory에는 3값(Confirmed/Published/Tentative)만 존재한다. Status의 Fixed는 StatusCategory 목록에 없다 — 원문 그대로 보존.

**TimeSlotType** — OperatingHours 객체의 TimeSlot 필드와 동일한 setup 값:

- Extended
- Normal (default value `'Normal'`)

**Type** — (API version 56.0+):

- Recurring
- Regular (default value)

### Usage — Salesforce Scheduler Recurring Shifts

Use the `RecurrencePattern` field to specify the recurrence pattern for recurring shifts. These recurrence patterns, called reference rules or "RRULES", support a subset of the RFC 5545 standards. This table includes common RRULE examples.

| Recurrence Pattern | RRULE Example |
|---|---|
| Every day for five days | `RRULE:FREQ=DAILY;INTERVAL=1;COUNT=5` |
| Every two weeks on Monday and Friday for 10 occurrences | `RRULE:FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,FR;COUNT=10` |
| Monthly on the first day of the month until August 1, 2022 | `RRULE:FREQ=MONTHLY;INTERVAL=1;BYMONTHDAY=1;UNTIL=20220801T100000Z` |

The RRULE defined by `RecurrencePattern` supports a subset of the RFC 5545 standard for internet calendaring and scheduling. Supported RRULE parts include FREQ, BYMONTH, BYMONTHDAY, BYDAY, BYSETPOS, INTERVAL, UNTIL, and COUNT.

When the event record is saved, the RRULE might be modified to follow the required format:

- The RRULE parts are placed in the following order: FREQ, BYMONTH, BYMONTHDAY, BYDAY, BYSETPOS, INTERVAL, UNTIL, and COUNT.
- Any missing default values are inserted. For example, if the RRULE doesn't include INTERVAL, then `INTERVAL=1` is added.
- The RRULE is prefaced with `RRULE:` if that preface is missing.

#### RRULE Part 표 (전수, Supported RFC 5545 Implementation)

**FREQ** — Required. Indicates the type of recurrence rule. Allowed values are:

- **DAILY** — supported parts include FREQ, INTERVAL, UNTIL, and COUNT.
- **WEEKLY** — supported parts include INTERVAL, UNTIL, COUNT, and BYDAY. BYDAY is required, but can't be preceded by a number. For example, to indicate weekly on Tuesday and Thursday until September 1 2022, use `RRULE:FREQ=WEEKLY;UNTIL=20220901T000000Z;BYDAY=TU,TH`
- **MONTHLY** — supported patterns include:
  - BYMONTHDAY — For example, to indicate monthly on the third day of the month use: `RRULE:FREQ=MONTHLY;BYMONTHDAY=3`
  - BYDAY and BYSETPOS — For example, to indicate the last weekday of the month, use `RRULE:FREQ=MONTHLY;BYDAY=MO,TU,WE,TH,FR;BYSETPOS=-1`
  - BYDAY, where the BYDAY values are specified with a numeric value — For example, to indicate monthly on the first Friday for 10 occurrences, use `RRULE:FREQ=MONTHLY;COUNT=10;BYDAY=1FR`

**BYMONTH** — The month. Valid values are 1 to 12.

**BYMONTHDAY** — The day of the month. Valid values are 1 to 31. If BYMONTHDAY is 31 and the month has fewer than 31 days, the event is created on the last day of the month.

**BYDAY** — A comma-separated list of days of the week. Valid values are SU, MO, TU, WE, TH, FR, SA. For RRULES with monthly frequency, BYDAY must be one of:

- a single day
- weekend days
- week days
- every day of the week

Each BYDAY value can be preceded by an integer that indicates the nth occurrence of a specific day within the monthly RRULE. Allowed values are -1, 1, 2, 3, and 4. You can't use different numbers in the BYDAY values. For example, this RRULE isn't supported: `RRULE:FREQ=MONTHLY;INTERVAL=2;COUNT=10;BYDAY=1SU,-1SU` If BYDAY values are prefaced with a number, the RRULE can't include BYSETPOS.

**BYSETPOS** — A comma-separated list of values that correspond to the nth occurrence within the set of recurrence instances specified by the rule. Valid values are -1, 1, 2, 3, or 4. Default value is 1. For example, to indicate the last weekday of the month, use: `RRULE:FREQ=MONTHLY;BYDAY=MO,TU,WE,TH,FR;BYSETPOS=-1`

**INTERVAL** — The repetition interval. Valid values are:

- an integer between 1 and 31 if FREQ=DAILY
- an integer between 1 and 26 if FREQ=WEEKLY
- an integer between 1 and 12 if FREQ=MONTHLY

Default value is 1.

**UNTIL** — Specifies the datetime in UTC format when the recurrence rule stops. The supported format is `yyyyMMddTHHmmssZ`, for example: `20210419T083000Z`. An RRULE can't contain both UNTIL and COUNT. A recurring event without either UNTIL or COUNT leads to an error.

**COUNT** — The number of occurrences. Allowed values are 1–120. An RRULE can't contain both UNTIL and COUNT. A recurring event without either UNTIL or COUNT leads to an error.

---

## Skill

Represents a skill that service resources have. This object is available in API version 24.0 and later.

> **Note**: For information about WDC skills on a user's profile, see the ProfileSkill topic.

**Supported Calls**: `create()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`

### Fields

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `Description` | `textarea` | Create, Nillable, Update | The description of the skill. |
| `DeveloperName` | `string` | Create, Filter, Group, Sort, Update | The unique name of the object in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. In managed packages, this field prevents naming conflicts on package installations. With this field, a developer can change the object's name in a managed package and the changes are reflected in a subscriber's organization. When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance slows down while Salesforce generates one for each record. |
| `LastViewedDate` | `datetime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed the skill. |
| `MasterLabel` | `string` | Create, Filter, Group, idLookup, Sort, Update | The name of the skill. |

> [sic] 원문 그대로: `LastViewedDate`의 Type이 소문자 `datetime`.

---

## SkillRequirement

Represents a skill that is required to complete a particular task in Salesforce Scheduler. Skill requirements can be added to work types Salesforce Scheduler. This object is available in API version 38.0 and later.

> [sic] 원문 그대로: "Skill requirements can be added to work types Salesforce Scheduler." — 전치사 "in"이 누락된 문장(원문 그대로 보존).

**Supported Calls**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules**: Salesforce Scheduler must be enabled.

### Fields

| Field Name | Type | Properties | Description |
|---|---|---|---|
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed a record related to this record. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed this record. If this value is null, this record can only have been referenced (LastReferencedDate) and not viewed. |
| `RelatedRecordId` | `reference` | Create, Filter, Group, Sort | The record that the skill is required for. The related record can be a work type. This is a polymorphic relationship field. — Relationship Name: `RelatedRecord` / Relationship Type: Lookup / Refers To: `PendingServiceRouting`, `WorkOrder`, `WorkOrderLineItem`, `WorkType` |
| `SkillId` | `reference` | Create, Filter, Group, Sort, Update | The skill that is required. This is a relationship field. — Relationship Name: `Skill` / Relationship Type: Lookup / Refers To: `Skill` |
| `SkillLevel` | `double` | Create, Defaulted on create, Filter, Nillable, Sort, Update | The level of the skill required. Skill levels can range from zero to 99.99. Depending on your business needs, you can want the skill level to reflect years of experience, certification levels, or license classes. |
| `SkillNumber` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-generated number identifying the skill requirement. |

`RelatedRecordId`의 Refers To 4종 (polymorphic): `PendingServiceRouting`, `WorkOrder`, `WorkOrderLineItem`, `WorkType`.

### Usage

Skill requirements help dispatchers assign work to service resources with the proper expertise. You can still assign a service appointment to a service resource that doesn't possess the specified skills, so skill requirements serve more as a suggestion than a rule.

Add skill requirements to work types to save time and keep your processes consistent. When you add a skill requirement to a work type that use that type automatically inherits the skill requirement. For example, if all annual maintenance visits for your Classic Refrigerator product require a Refrigerator Maintenance skill level of at least 50, add that skill requirement to the Annual Maintenance Visit work type. When you create a service appointment for a customer's annual fridge maintenance, applying that work type adds the skill requirement as well.

### Associated Objects

This object has the following associated objects. Unless noted, they're available in the same API version as this object.

- `ServiceRequirementFeed` — Feed tracking is available for the object.
- `ServiceRequirementHistory` — History is available for tracked fields of the object.

> [sic] 원문 그대로: SkillRequirement의 Associated Objects 이름이 객체명(SkillRequirement)과 불일치하는 `ServiceRequirementFeed` / `ServiceRequirementHistory`(Service-로 시작). 원문 그대로 보존.

---

## 관련 노트

- [[Salesforce Scheduler 표준객체 — 핵심 예약]] — ServiceAppointment·AssignedResource·Waitlist 등 예약 흐름 객체. 이 노트의 ResourcePreference/ServiceResource가 배정 후보가 된다.
- [[Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형]] — OperatingHours·TimeSlot·WorkType·WorkTypeGroup. ServiceTerritory의 OperatingHoursId, Shift의 WorkTypeGroupId가 이 객체들을 참조한다.
- [[Salesforce Scheduler 표준객체 — 초대·집계·로그]] — AppointmentScheduleLog 등. ServiceResourceId/ServiceTerritoryId가 이 노트의 리소스·영역 객체를 참조한다.
- [[Salesforce Scheduler 커스텀객체]] — ShiftWorkTopic 등 리소스·시프트를 잇는 junction 객체.
- [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]] — Scheduler 개요·데이터 모델·셋업.
- [[LxScheduler Namespace]] — Salesforce Scheduler의 Apex 네임스페이스(예약 후보 리소스/슬롯 조회, 외부 캘린더 연동).
- sObject/6 Standard Objects.md — 전체 표준객체 레퍼런스 (sObject 폴더 — 폴더 간 plain-text 참조)
- sObject/API Field Properties.md — Field Properties(Create/Filter/Group/Nillable/Sort/Update 등) 의미
- sObject/Field Service Objects.md — OperatingHours·TimeSlot·WorkType을 공유하는 Field Service 계열 객체
- [[Tooling API 객체 — Service·OmniChannel (라우팅·대화채널·서비스카탈로그·스케줄링)]] — Skill 등 라우팅 sObject의 Tooling API facet
