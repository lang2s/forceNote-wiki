---
tags: [scheduler, salesforce-scheduler, standard-objects, worktype, scheduling-policy, operatinghours, sobject-reference]
source: salesforce_scheduler_dev_guide.pdf (Salesforce Scheduler Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [WorkType 필드, AppointmentSchedulingPolicy, OperatingHours, TimeSlot, WorkTypeGroup, 작업유형 정책 객체]
---

# Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형

> Salesforce Scheduler가 약속(appointment) 스케줄링에 사용하는 10개 표준객체의 필드·picklist·Supported Calls를 공식 Developer Guide(v67.0)에서 전수 정리한다.

---

이 노트는 Salesforce Scheduler Developer Guide의 **Standard Objects** 챕터 중 정책(policy)·운영시간(operating hours)·작업유형(work type) 계열 10개 객체를 다룬다. 각 객체는 `Field` / `Type` / `Properties` / `Description` 네 칼럼의 필드 표로 정리했으며, picklist 값은 빠짐없이 옮겼다.

> 표기 규칙: 필드 `Properties`의 콤마 구분 토큰(`Create, Filter, Group, Sort, Update` 등)은 PDF 원문 그대로다. 일부 객체(AppointmentAssignmentPolicy, AppointmentSchedulingPolicy, WorkTypeGroup, WorkTypeGroupDataTranslation)에는 **PDF 원문 자체의 렌더 결함**(중복된 `Possible values are:` 줄, Properties의 빈 토큰 등)이 있어 `[sic]`로 표시하고 원문 그대로 보존했다. 이는 pdftotext 추출 오류가 아니라 원본 PDF의 렌더 결함임을 pdftoppm 이미지로 확인했다.

---

## AppointmentAssignmentPolicy

Stores information about resource assignment rules. This object is available in **API version 52.0 and later**.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `FullName` | `string` | Create, Filter, Group, Sort, Update | The API name of the AppointmentAssignmentPolicy object. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| `Language` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The language of the appointment assignment policy. Possible values are (아래 picklist 참조). |
| `MasterLabel` | `string` | Create, Filter, Group, Sort, Update | The label for the appointment assignment policy. |
| `PolicyApplicableDuration` | `picklist` | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | The frequency at which the utilization of service resources is calculated. This field is available in API version 53.0 and later. The default value is `Parameter-Based`. |
| `PolicyType` | `picklist` | Create, Filter, Group, Restricted picklist, Sort, Update | The type of appointment assignment policy. |
| `UtilizationFactor` | `picklist` | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | Specifies the count type for the resource utilization. This field is available in API version 53.0 and later. The default value is `TotalAppointmentDuration`. |

### Picklist 값

**`Language`** — Possible values are: `[sic]` (PDF 원문에 `Possible values are:` 줄이 중복 출력됨)

```
Possible values are:
• Possible values are:        ← [sic] 원문 렌더 결함, 중복 줄 그대로 보존
• da (Danish)
• de (German)
• en_US (English)
• es (Spanish)
• es_MX (Spanish - Mexican)
• fi (Finnish)
• fr (French)
• it (Italian)
• ja (Japanese)
• ko (Korean)
• nl_NL (Dutch)
• no (Norwegian)
• pt_BR (Portuguese - Brazilian)
• ru (Russian)
• sv (Swedish)
• th (Thai)
• zh_CN (Chinese - Simplified)
• zh_TW (Chinese - Traditional)
```

**`PolicyApplicableDuration`** — Possible values are: `Parameter-Based`, `Monthly`, `Weekly` (default: `Parameter-Based`)

**`PolicyType`** — Possible values are: `loadBalancing`

**`UtilizationFactor`** — Possible values are: `NumberOfAppointments`, `TotalAppointmentDuration` (default: `TotalAppointmentDuration`)

---

## AppointmentCategory

Represents the category of work types and shifts. This object is available in **API version 58.0 and later**.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`

**Special Access Rules:** Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `IsDropIn` | `boolean` | Create, Defaulted on create, Filter, Group, Sort | Indicates whether the appointment mode is drop-in (`true`) or not (`false`). The default value is `false`. |
| `IsGroup` | `boolean` | Create, Defaulted on create, Filter, Group, Sort | Indicates whether the appointment mode is group (`true`) or not (`false`). It also indicates whether work types and shifts support the group category. The default value is `false`. Available in API version 61.0 and later. |
| `IsScheduled` | `boolean` | Create, Defaulted on create, Filter, Group, Sort | Indicates whether the appointment mode is regular (`true`) or not (`false`). It also indicates whether work types and shifts support the group category. The default value is `false`. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the appointment category record was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the appointment category record was last viewed. |
| `Name` | `string` | Create, Filter, Group, idLookup, Sort, Update | Name of the appointment category. |

### Usage

Use appointment categories to differentiate between various types of appointments, such as drop in, regular, and group. To define the work types and shifts available for these categories, assign appointment categories to work types and shifts.

### Associated Objects

- **AppointmentCategoryFeed** — Feed tracking is available for the object.
- **AppointmentCategoryHistory** — History is available for tracked fields of the object.

---

## AppointmentSchedulingPolicy

Represents a set of rules for scheduling appointments using Salesforce Scheduler. This object is available in **API version 45.0 and later**.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `AppointmentAssignmentPolicyId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The name or ID of the appointment assignment policy. This is a relationship field, available in version 52.0 and later. Relationship Name: `AppointmentAssignmentPolicy`; Type: Lookup; Refers To: AppointmentAssignmentPolicy. |
| `AppointmentStartTimeInterval` | `picklist` | Create, Filter, Group, Restricted picklist, Sort, Update | The proposed time interval in minutes between appointment start times. For example, set the interval to 15. Appointments can then begin at the top of the hour and at 15-minute intervals thereafter (10:00 AM, 10:15 AM, 10:30 AM, and so on). (값은 아래 picklist 참조) |
| `DeveloperName` | `string` | Create, Filter, Group, Sort, Update | The API name of the AppointmentSchedulingPolicy object. |
| `ExtCalEventHandlerId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The API name of the custom Apex class that checks service resources' external calendar events and returns the time slots where service resources are already booked. Available in API version 50.0 and later. This is a relationship field. Relationship Name: `ExtCalEventHandler`; Type: Lookup; Refers To: ApexClass. |
| `IsOrgDefault` | `boolean` | Defaulted on create, Filter, Group, Sort | Indicates whether this scheduling policy is the default appointment scheduling policy for Lightning Scheduler appointments in this org. |
| `IsSvcTerrOpHoursWithShiftsUsed` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether this scheduling policy considers the intersection of shifts and service territory operating hours when determining the availability of service resources for appointments (`true`). The default value is `false`. Available in API version 56.0 and later. |
| `IsSvcTerritoryMemberShiftUsed` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether this scheduling policy considers shifts of service territory members when determining the availability of service resources for appointments (`true`). The default value is `false`. Available in API version 56.0 and later. |
| `Language` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The language of the appointment scheduling policy. Possible values are (아래 picklist 참조). |
| `MasterLabel` | `string` | Create, Filter, Group, Sort, Update | The label for the appointment scheduling policy. |
| `ShouldConsiderCalendarEvents` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether this policy checks the Salesforce calendar for resource availability. The default value is `'false'`. |
| `ShouldEnforceExcludedResource` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether this appointment scheduling policy prevents excluded service resources from being assigned to appointments. |
| `ShouldEnforceRequiredResource` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether this appointment scheduling policy allows only required service resources to be assigned to appointments. |
| `ShouldMatchSkill` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether this appointment scheduling policy allows only required service resources who have certain skills to be assigned to appointments. |
| `ShouldMatchSkillLevel` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether this appointment scheduling policy allows only required service resources who have certain skills and skill levels to be assigned to appointments. |
| `ShouldRespectVisitingHours` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether this appointment scheduling policy prevents users from scheduling appointments outside of an account's visiting hours. |
| `ShouldUsePrimaryMembers` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether this appointment scheduling policy allows only service resources who are primary members of a service territory to be assigned to appointments. |
| `ShouldUseSecondaryMembers` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether this appointment scheduling policy allows service resources who are secondary members of a service territory to be assigned to appointments. |

### Picklist 값

**`AppointmentStartTimeInterval`** — Possible values are (분 단위):

```
• 5     • 10    • 15    • 20
• 30    • 45    • 60    • 90
• 120   • 150   • 180   • 240
• 300   • 360   • 420   • 480
```

**`Language`** — Possible values are: `[sic]` (PDF 원문에 `Possible values are:` 줄이 중복 출력됨)

```
Possible values are:
• Possible values are:        ← [sic] 원문 렌더 결함, 중복 줄 그대로 보존
• da (Danish)
• de (German)
• en_US (English)
• es (Spanish)
• es_MX (Spanish - Mexican)
• fi (Finnish)
• fr (French)
• it (Italian)
• ja (Japanese)
• ko (Korean)
• nl_NL (Dutch)
• no (Norwegian)
• pt_BR (Portuguese - Brazilian)
• ru (Russian)
• sv (Swedish)
• th (Thai)
• zh_CN (Chinese - Simplified)
• zh_TW (Chinese - Traditional)
```

---

## Holiday

Represents the fields in the Holiday object that are used by Salesforce Scheduler. A holiday is a period during which your service resource is unavailable for appointment scheduling.

**Supported Calls:** `create()`, `delete()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `update()`, `upsert()`

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `ActivityDate` | `date` | Create, Filter, Group, Nillable, Sort, Update | If the Holiday IsAllDay flag is set to `true` (indicating that it is an all-day holiday), then the holiday due date information is contained in the ActivityDate field. This field is a date field with a timestamp that is always set to midnight in the Coordinated Universal Time (UTC) time zone. The timestamp is not relevant, and you must not attempt to alter it to account for any time zone differences. |
| `Description` | `string` | Create, Filter, Group, Nillable, Sort, Update | Text description of the holiday. |
| `EndTimeInMinutes` | `int` | Create, Filter, Group, Nillable, Sort, Update | The end time of the holiday in minutes. |
| `IsAllDay` | `boolean` | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the duration of the holiday is all day (`true`) or not (`false`). |
| `Name` | `string` | Create, Filter, Group, idLookup, Sort, Update | The name of the holiday. |
| `StartTimeInMinutes` | `int` | Create, Filter, Group, Nillable, Sort, Update | The start time of the holiday in minutes. |

---

## OperatingHours

Represents the hours in which a service territory, service resource, or account is available for work in Salesforce Scheduler. This object is available in **API version 38.0 and later**.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `Description` | `textarea` | Create, Nillable, Update | The description of the operating hours. Add any details that aren't included in the name. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the operating hours record was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the operating hours record was last viewed. |
| `Name` | `string` | Create, Filter, Group, idLookup, Sort, Update | The name of the operating hours. For example, Summer Hours, Winter Hours, or Peak Season Hours. |
| `TimeZone` | `picklist` | Create, Filter, Group, Restricted picklist, Sort, Update | The time zone that the operating hours fall within. |

### Usage

By default, only System Administrators can view, create, and assign operating hours.

Service territory members—which are service resources who can work in the territory—automatically use their service territory's operating hours. If a resource needs different operating hours than their territory, create separate operating hours for them from the Operating Hours tab. Then, select the desired hours in the Operating Hours lookup field on the service territory member detail page.

To view a service resource's operating hours for a particular territory, navigate to their Service Territories related list and click the Member Number for the territory. This takes you to the service territory member detail page, which lists the member's operating hours and dates during which they belong to the territory.

### Associated Objects

- **OperatingHoursFeed** — Feed tracking is available for the object.

---

## OperatingHoursHoliday

Represents the day or hours for which a service territory and service resources exclusive to the service territory are unavailable in Salesforce Scheduler. This object is available in **API version 54.0 and later**.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules:** Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `DateAndTime` | `string` | Filter, Group, Nillable, Sort | (Read-Only) The date or time for the holiday. |
| `HolidayId` | `reference` | Create, Filter, Group, Sort, Update | The ID of the holiday that's related to the operating hours indicated in the OperatingHoursId field. This is a relationship field. Relationship Name: `Holiday`; Type: Lookup; Refers To: Holiday. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date and time that the current user last viewed a record related to this object. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed this object. |
| `OperatingHoursHolidayNumber` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | (Read-Only) An auto-generated number identifying the operating hours holiday. |
| `OperatingHoursId` | `reference` | Create, Filter, Group, Sort | The ID of the operating hours that's related to the holiday indicated in the HolidayId field. This is a relationship field. Relationship Name: `OperatingHours`; Type: Lookup; Refers To: OperatingHours. |

---

## TimeSlot

Represents a period of time on a specified day of the week during which work can be performed in Salesforce Scheduler. Operating hours consist of one or more time slots. This object is available in **API version 38.0 and later**.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `update()`, `upsert()`

**Special Access Rules:** Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `DayOfWeek` | `picklist` | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | The day of the week when the time slot takes place. |
| `EndTime` | `time` | Create, Filter, Sort, Update | The time when the time slot ends. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed a record related to this record. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed this record. If this value is null, this record can only have been referenced (LastReferencedDate) and not viewed. |
| `MaxAppointments` | `int` | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | Maximum number of appointments for a single time slot. Available in API version 47.0 and later. |
| `OperatingHoursId` | `reference` | Create, Filter, Group, Sort | The operating hours that the time slot belongs to. An operating hours' time slots appear in the Operating Hours related list. This is a relationship field. Relationship Name: `OperatingHours`; Type: Lookup; Refers To: OperatingHours. |
| `StartTime` | `time` | Create, Filter, Sort, Update | The time when the time slot starts. |
| `TimeSlotNumber` | `string` | Autonumber, Defaulted on create, Filter, idLookup, Sort | The name of the time slot. The name is auto-populated to a day and time format—for example, Monday 9:00 AM - 10:00 PM—but you can manually update it. |
| `Type` | `picklist` | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | The type of time slot. Possible values are `Normal` and `Extended`. Default value must be `Normal`. You can choose to use `Extended` to represent overtime shifts. |
| `WorkTypeGroupId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | Work type group assigned to the time slot. Available in API version 47.0 and later. This is a relationship field. Relationship Name: `WorkTypeGroup`; Type: Lookup; Refers To: WorkTypeGroup. |

### Usage

Operating hours are composed of time slots, which indicate the hours of operation for a particular day. After you create operating hours, create time slots for each day. For example, if the operating hours must be 8 AM to 5 PM Monday through Friday, create five time slots, one per day. To reflect breaks such as lunch hours, create multiple time slots in a day: for example, `Monday 8:00 AM – 12:00 PM` and `Monday 1:00 PM – 5:00 PM`.

> **Tip:** Time slots don't come with any built-in rules, but you can create Apex triggers that limit time slot settings in your org. For example, you can want to restrict the start and end times on time slots to half-hour increments, or to prohibit end times later than 8 PM.

---

## WorkType

Represents a type of work to be performed in Salesforce Scheduler. This object is available in **API version 38.0 and later**.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

Work types are templates representing an appointment topic (work type group) with an appointment location (service territory). Defines key appointment parameters such as appointment duration, prep and wrap-up buffers, and availability timings.

**Special Access Rules:** Salesforce Scheduler must be enabled.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `AppointmentCategoryId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the appointment category that's assigned to the work type. This field is available in API version 58.0 and later. This field is a relationship field. Relationship Name: `AppointmentCategory`; Type: Lookup; Refers To: AppointmentCategory. |
| `ApptStartTimeIntvlInMin` | `int` | Create, Filter, Group, Nillable, Sort, Update | Specify the time interval in minutes between appointment start times. For example, if you set the interval as 15, appointments can then begin at the top of the hour and at 15-minute intervals thereafter (10:00 AM, 10:15 AM, 10:30 AM). Valid values can be between 5 through 720. **Note:** If you don't specify a value for this field, Salesforce Scheduler considers the value specified in the default scheduling policy. This field is available in API version 57.0 and later. |
| `AttendeeLimit` | `int` | Create, Filter, Group, Sort, Update | The maximum number of attendees for a group service appointment in a shift. This field is considered when the appointment mode is Group. Available in API version 61.0 and later. |
| `BlockTimeAfterAppointment` | `int` | Create, Filter, Group, Nillable, Sort, Update | Specify the after buffer time for the service appointment. **Note:** In Salesforce Scheduler, during appointment scheduling, the number of available time slots is automatically adjusted to accommodate the after buffer time. |
| `BlockTimeAfterUnit` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Specify the unit of time for BlockTimeAfterAppointment. Possible values are `Hours`, `Minutes`. The default value is `'Minutes'`. |
| `BlockTimeBeforeAppointment` | `int` | Create, Filter, Group, Nillable, Sort, Update | Specify the before buffer time for the service appointment. **Note:** In Salesforce Scheduler, during appointment scheduling, the number of available time slots is automatically adjusted to accommodate the before buffer time. |
| `BlockTimeBeforeUnit` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Specify the unit of time for BlockTimeBeforeAppointment. Possible values are `Hours`, `Minutes`. The default value is `'Minutes'`. |
| `DefaultAppointmentType` | `picklist` | Create, Filter, Group, Nillable, Sort, Update | The default appointment type of the work type. Possible values are `Phone`, `At Branch`, `Video`. In Lobby Management, the Scheduled Service Appointments list only shows appointments that are set to At Branch. |
| `Description` | `textarea` | Create, Nillable, Update | The description of the work type. Try to add details about the task or tasks that this work type represents. |
| `DurationInMinutes` | `double` | Filter, Nillable, Sort | The estimated duration of the work type in minutes. |
| `DurationType` | `picklist` | Create, Filter, Group, Defaulted on create, Restricted picklist, Sort, Update | The unit of the Estimated Duration: Minutes or Hours. |
| `EstimatedDuration` | `double` | Create, Filter, Sort, Update | The estimated length of the work. The estimated duration is in minutes or hours based on the value selected in the Duration Type field. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date when the work type was last modified. Its label in the user interface is Last Modified Date. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The date when the work type was last viewed by the current user. |
| `Name` | `string` | Create, Filter, Group, idLookup, Sort, Update | The name of the work type. |
| `OperatingHoursId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | The ID of the operating hours that's assigned to the work type. If a service resource needs special operating hours, create them in Setup and select them in the Operating Hours lookup field on the member's detail page. This is a relationship field. Relationship Name: `OperatingHours`; Type: Lookup; Refers To: OperatingHours. |
| `OwnerId` | `reference` | Create, Defaulted on create, Filter, Group, Sort, Update | The work type's owner. This is a polymorphic relationship field. Relationship Name: `Owner`; Type: Lookup; Refers To: Group, User. |
| `ProductId` | `reference` | Create, Filter, Group, Nillable, Sort, Update | References the product associated with the work type. This field is available in API version 63.0 and later. This field is a relationship field. Relationship Name: `Product`; Refers To: Product2. |
| `TimeFrameEndUnit` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Specify the unit of time for TimeFrame End. Possible values are `Days`, `Hours`. The default value is `'Days'`. |
| `TimeFrameStartUnit` | `picklist` | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Specify the unit of time for TimeFrame Start. Possible values are `Days`, `Hours`. The default value is `'Days'`. |
| `TimeframeEnd` | `int` | Create, Filter, Group, Nillable, Sort, Update | Specify the timeframe end to show only time slots that end before the duration that is set in Timeframe End. |
| `TimeframeStart` | `int` | Create, Filter, Group, Nillable, Sort, Update | Specify the timeframe start to show only time slots that start after the duration that is set in Timeframe Start. |

> `[sic]` 대소문자 주의: 단위 필드는 `TimeFrameEndUnit` / `TimeFrameStartUnit`(F 대문자)인데, 값 필드는 `TimeframeEnd` / `TimeframeStart`(f 소문자)로 PDF 원문에서 대소문자가 일관되지 않다. 원문 그대로 보존했다.
>
> `[sic]` `ProductId`의 Relationship 블록은 다른 reference 필드와 달리 `Relationship Type` 줄 없이 `Relationship Name`(Product) → `Refers To`(Product2)로 바로 이어진다(PDF 원문 그대로).

### Usage

You can specify meeting preparation and wrap-up time by specifying `BlockTimeBeforeAppointment` and `BlockTimeAfterAppointment`. Specify the units of time as minutes or hours. During appointment scheduling, the number of available time slots is automatically adjusted to accommodate the before and after buffer time. By default, the before and after appointment buffers aren't reflected on the service resource's Salesforce calendar. Enable the Block Resource Availability setting to reflect the before and after appointment buffers on the Salesforce calendar.

> **Note:** Don't specify more than 24 hours as buffer time.

`Timeframe Start` and `Timeframe End` show time slots in a dynamic time frame based on when a user books an appointment. Salesforce Scheduler shows only time slots that start after the duration that is set in Timeframe Start and end before the duration that is set in Timeframe End. For example, you've set Timeframe Start to 2 days and Timeframe End to 5 days and a user schedules an appointment on Sep 13, 10:00 AM. Then, only time slots that start on or after Sep 15, 10:00 AM and end on or before Sep 18, 10:00 AM are shown.

### Associated Objects

- **WorkTypeChangeEvent** (API version 48.0) — Change events are available for the object.
- **WorkTypeFeed** — Feed tracking is available for the object.
- **WorkTypeHistory** — History is available for tracked fields of the object.
- **WorkTypeOwnerSharingRule** — Sharing rules are available for the object.
- **WorkTypeShare** — Sharing is available for the object.

---

## WorkTypeGroup

Represents a grouping of work types used to categorize types of appointments available in Salesforce Scheduler. This object is available in **API version 45.0 and later**.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Salesforce Scheduler must be enabled.

> `[sic]` 이 객체의 여러 필드는 PDF 원문 Properties 셀에 **빈 토큰**(콤마 사이가 비어 있음)이 그대로 출력되어 있다. 아래 표의 Properties는 PDF 원문 토큰을 그대로 보존했다(예: `Create, , , Group, Restricted picklist, Sort,`). 이는 pdftotext 추출 오류가 아니라 원본 PDF 렌더 결함이며 pdftoppm 이미지로 확인했다.

### Fields

| Field | Type | Properties (PDF 원문 그대로 `[sic]`) | Description |
|---|---|---|---|
| `AdditionalInformation` | `multipicklist` | Create, Filter, Nillable, Update | Additional information about the types of appointments this work type group represents. |
| `Description` | `textarea` | `, Nillable,` `[sic]` | A description of this work type group. |
| `GroupType` | `picklist` | `Create, , , Group, Restricted picklist, Sort,` `[sic]` | The category of this work type group. Possible values are: `Default` — A non-capacity group of work types used in Salesforce Scheduler. |
| `IsActive` | `boolean` | `Create, Defaulted on create, Filter, Group, Sort,` `[sic]` | Indicates whether this work type group can be used for appointment scheduling. |
| `LastReferencedDate` | `dateTime` | Filter, Nillable, Sort | The date and time that the current user last viewed a record related to this object. |
| `LastViewedDate` | `dateTime` | Filter, Nillable, Sort | The timestamp for when the current user last viewed this object. |
| `Name` | `string` | Create, Filter, Group, idLookup, Sort, Update | The name of this work type group. |
| `OwnerId` | `reference` | `, Defaulted on create, Filter, Group, Sort, Update` `[sic]` | The ID of the user who created this record. This is a polymorphic relationship field. Relationship Name: `Owner`; Type: Lookup; Refers To: Group, User. |

**`GroupType`** picklist — Possible values are: `Default` (A non-capacity group of work types used in Salesforce Scheduler.)

### Associated Objects

- **WorkTypeGroupFeed** — Feed tracking is available for the object.
- **WorkTypeGroupHistory** — History is available for tracked fields of the object.
- **WorkTypeGroupOwnerSharingRule** — Sharing rules are available for the object.
- **WorkTypeGroupShare** — Sharing is available for the object.

---

## WorkTypeGroupDataTranslation

Represents the translated values of the data stored within a WorkTypeGroup record's fields. This object is available in **API version 54.0 and later**.

**Supported Calls:** `create()`, `delete()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:**
- Your organization must be using Enterprise, Performance, Unlimited, or Developer edition.
- Translation Workbench and data translation must be enabled in your org.
- To view this object, you must have the "View Setup and Configuration" permission.

### Fields

| Field | Type | Properties | Description |
|---|---|---|---|
| `Description` | `textarea` | `Create, Nillable,Update` `[sic]` (PDF 원문에 `Nillable,Update` 사이 공백 없음) | The translated value for the WorkTypeGroup description. |
| `IsOutOfDate` | `boolean` | Defaulted on create, Filter, Group, Sort | Indicates whether the translation is out-of-date (`true`) or current (`false`). A translation is out-of-date if the parent WorkTypeGroup record is updated after the last translation was filed. |
| `Language` | `picklist` | Create, Filter, Group, Restricted picklist, Sort | The language for these translated values. |
| `Name` | `string` | Create, Filter, Group, idLookup, Sort, Update | The translated value for the WorkTypeGroup record name. This field is required to translate the text in other fields. |
| `ParentId` | `reference` | Create, Filter, Group, Sort, Update | The record ID of the WorkTypeGroup associated with the data that is being translated. This field is a relationship field. Relationship Name: `Parent`; Type: Lookup; Refers To: WorkTypeGroup. |

### Usage

Use this object to translate the data stored in a WorkTypeGroup record into the different languages supported by Salesforce. If data translation is enabled for custom fields on the WorkTypeGroup object, additional WorkTypeGroupDataTranslation fields exist for translating the data contained within those fields.

You can't use a custom external id field in an upsert call for a WorkTypeGroupDataTranslation object.

> SEE ALSO: Salesforce Help — Manage Objects' Data Translations

---

## 관련 노트

- [[Salesforce Scheduler 표준객체 — 핵심 예약]] — ServiceAppointment·AssignedResource·Waitlist 등 예약 흐름. WorkTypeId·AppointmentSchedulingPolicyId가 이 객체들을 참조한다.
- [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]] — ServiceResource·ServiceTerritory·Skill·Shift. ServiceTerritory의 OperatingHoursId, Shift의 WorkTypeGroupId가 이 노트의 객체를 참조한다.
- [[Salesforce Scheduler 표준객체 — 초대·집계·로그]] — AppointmentInvitation·AppointmentInvitee. AppointmentTopicId가 WorkType·WorkTypeGroup을 참조한다.
- [[Salesforce Scheduler 커스텀객체]] — WorkTypeGroupMember 등 WorkType·WorkTypeGroup을 잇는 junction 객체.
- [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]] — Scheduler 개요·데이터 모델·셋업.
- sObject/6 Standard Objects.md — Salesforce 표준객체 레퍼런스 전반
- sObject/API Field Properties.md — Field Properties(Create/Filter/Group/Nillable/Sort/Update 등) 의미
- sObject/Field Service Objects.md — OperatingHours·TimeSlot·WorkType을 공유하는 Field Service 계열 객체
