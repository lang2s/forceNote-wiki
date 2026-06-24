---
tags: [field-service, fsl, sobject, object-reference, custom-fields, managed-package, 현장서비스, 커스텀필드]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-24
aliases: [FSL Custom Fields, Field Service Custom Fields on Standard Objects, FSL__ 커스텀필드, 현장서비스 관리패키지 커스텀필드, FSL managed package fields, Slot_Color, FSL__Scheduling_Policy_Used__c, FSL__IsFillInCandidate__c]
---

# 객체 레퍼런스 — Custom Fields on Standard Objects

> Field Service 관리패키지(managed package)가 9개 표준객체에 추가하는 `FSL__` 접두 커스텀필드 58개 + Internal 필드 12개 전수.

---

이 노트는 **표준필드가 아니라 Field Service 관리패키지가 추가하는 `FSL__` 커스텀필드만** 다룬다. 각 표준객체의 **표준필드는 해당 객체 본노트**를 참조한다.

- AssignedResource·ServiceAppointment 표준필드 → [[객체 레퍼런스 — Service Appointment·Resource]]
- ServiceResource·ResourceAbsence·ServiceResourceCapacity 표준필드 → [[객체 레퍼런스 — Service Resource·Crew·Skill]]
- ServiceTerritory·TimeSlot 표준필드 → [[객체 레퍼런스 — Service Territory·OperatingHours·Shift]]
- WorkOrder·WorkOrderLineItem 표준필드 → [[객체 레퍼런스 — Work Order·WorkOrderLineItem·Status]]

> PDF 섹션 개요: *"A list of custom fields on standard Salesforce objects installed with the Field Service managed package. See the Field Service Apex Namespace section for more API references related to the managed package."*

## 모든 객체 공통

- **Special Access Rules:** Field Service managed package must be installed.
- **Internal Fields:** 일부 객체에는 관리패키지 전용 Internal 필드가 있다. publicly accessible이지만 관리패키지만 갱신한다.
- `FSL__` 접두는 관리패키지 네임스페이스다. 추가 API 레퍼런스는 [[FSL Apex Namespace]] 참조.

---

## 1. AssignedResource Custom Fields

> Custom fields associated with a service resource who is assigned to a service appointment in Field Service. Assigned resources appear in the Assigned Resources related list on service appointments. This object is available in API version 38.0 and later.

표준필드는 AssignedResource object reference 참조.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`

**Fields (5):**

| 필드 API명 | Type | Properties | Description |
|---|---|---|---|
| `FSL__EstimatedTravelDistanceFrom__c` | double | Create, Filter, Nillable, Sort, Update | The estimated travel distance from the service resource's assigned appointment location to their home base. For this field, the assigned appointment location must have latitude and longitude coordinates and be the last location of the day. If it doesn't have coordinates, isn't the last location of the day, or the travel calculations are disabled, this field is 0. |
| `FSL__EstimatedTravelDistanceTo__c` | double | Create, Filter, Nillable, Sort, Update | The estimated travel distance to the service resource's assigned appointment location from a service appointment, another resource absence location, or their home base. For this field, the assigned appointment location must have latitude and longitude coordinate. If it doesn't have latitude and longitude coordinates or the travel calculations are disabled, this field is 0. |
| `FSL__EstimatedTravelTimeFrom__c` | double | Create, Filter, Nillable, Sort, Update | The estimated travel time from the service resource's assigned appointment location to their home base. For this field, the assigned appointment location must have latitude and longitude coordinates and be the last location of the day. If it doesn't have coordinates, isn't the last location of the day, or the travel calculations are disabled, this field is 0. |
| `FSL__Estimated_Travel_Time_From_Source__c` | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The method used to calculate the travel time from the service resource's assigned appointment location to their home base. For this field, the assigned appointment location must have latitude and longitude coordinates and be the last location of the day. If it doesn't have coordinates, isn't the last location of the day, or the travel calculations are disabled, this field is None. |
| `FSL__Estimated_Travel_Time_To_Source__c` | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The method used to calculate the travel time to the service resource's assigned appointment location from a service appointment, another resource absence location, or their home base. For this field, the assigned appointment location must have latitude and longitude coordinates. If it doesn't have latitude and longitude coordinates or the travel calculations are disabled, this field is None. |

**Possible values** (`FSL__Estimated_Travel_Time_From_Source__c`, `FSL__Estimated_Travel_Time_To_Source__c`): `Aerial` / `None` / `Predictive` / `SLR`

**Internal Fields (3):** 관리패키지 전용 (publicly accessible이나 패키지만 갱신)

- `FSL__Last_Updated_Epoch__c` — Used to prevent the overlapping of multiple concurrent scheduling requests.
- `FSL__UpdatedByOptimization__c` — Equals true if the record was updated by the optimization engine.
- `FSL__calculated_duration__c` — Indicates the duration (start to end time) of the service appointment assigned to the resource in minutes.

---

## 2. ResourceAbsence Custom Fields

> Custom fields associated with a time period in which a service resource is unavailable to work in Field Service.

표준필드는 ResourceAbsence object reference 참조.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Fields (11):**

| 필드 API명 | Type | Properties | Description |
|---|---|---|---|
| `FSL__Approved__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | When this field is true and the Activate approval confirmation on resource absences setting is enabled, the resource absence appears in the dispatcher console's Gantt chart and is considered by the scheduler. When this field is false and the setting is enabled, the resource absence doesn't appear in the Gantt chart and is ignored by the scheduler. The default value is false. For more info, view the View Resource Absences on the Gantt and Map Help article. |
| `FSL__Duration_In_Minutes__c` | double | Filter, Nillable, Sort | The duration of the resource absence in minutes. This field is automatically populated after the resource absence is created. This is a calculated field. |
| `FSL__EstTravelTimeFrom__c` | double | Create, Filter, Nillable, Sort, Update | The estimated travel time from the service resource's absence location to their home base. For this field, the absence location must have latitude and longitude coordinates and be the last location of the day. If it doesn't have coordinates, isn't the last location of the day, or the travel calculations are disabled, this field is 0. |
| `FSL__EstTravelTime__c` | double | Create, Filter, Nillable, Sort, Update | The estimated time to the service resource's absence location from a service appointment or another resource absence location. For this field, the absence location must have latitude and longitude coordinates. If it doesn't have latitude and longitude coordinates or the travel calculations are disabled, this field is 0. |
| `FSL__EstimatedTravelDistanceFrom__c` | double | Create, Filter, Nillable, Sort, Update | The estimated travel distance from the service resource's absence location to their home base. For this field, the absence location must have latitude and longitude coordinates and be the last location of the day. If it doesn't have coordinates, isn't the last location of the day, or the travel calculations are disabled, this field is 0. |
| `FSL__EstimatedTravelDistanceTo__c` | double | Create, Filter, Nillable, Sort, Update | The estimated travel distance to service resource's absence location from a service appointment or another resource absence location. For this field, the absence location must have latitude and longitude coordinate. If it doesn't have latitude and longitude coordinates or the travel calculations are disabled, this field is 0. |
| `FSL__Estimated_Travel_Time_From_Source__c` | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The method used to calculate the travel time from the service resource's absence location to a service appointment or another resource absence location. For this field, the absence location must have latitude and longitude coordinates and be the last location of the day. If it doesn't have coordinates, isn't the last location of the day, or the travel calculations are disabled, this field is None. |
| `FSL__Estimated_Travel_Time_To_Source__c` | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The method used to calculate the travel time to this service resource's absence location from a service appointment or another resource absence location. For this field, the absence location must have latitude and longitude coordinates. If it doesn't have latitude and longitude coordinates or the travel calculations are disabled, this field is None. |
| `FSL__GanttLabel__c` | string | Create, Filter, Group, Nillable, Sort, Update | The label of the resource absence in the Field Service dispatcher console's Gantt chart and resource calendar. This replaces the resource absence's number in the chart. |
| `FSL__Gantt_Color__c` | string | Create, Filter, Group, Nillable, Sort, Update | The Hex color of the resource absence in Field Service dispatcher console's Gantt chart and resource calendar. |
| `FSL__Scheduling_Policy_Used__c` | reference | Create, Filter, Group, Nillable, Sort, Update | A scheduling policy used by the scheduler for the service appointment. This policy overrides the default one in the Field Service Settings page or the one that the scheduler would otherwise select. This is used for travel calculations. This is a relationship field. |

**Possible values** (`FSL__Estimated_Travel_Time_From_Source__c`, `FSL__Estimated_Travel_Time_To_Source__c`): `Aerial` / `None` / `Predictive` / `SLR`

**Formula** (`FSL__Duration_In_Minutes__c`):

```
// 원본 발췌 — PDF Formula
IF (ISBLANK(Start), 0, (End - Start)*24*60)
```

**Relationship** (`FSL__Scheduling_Policy_Used__c`): Relationship Name `FSL__Scheduling_Policy_Used__r` / Relationship Type `Lookup` / Refers To `FSL__Scheduling_Policy__c`

**Internal Fields (3):** Street Level Routing calculations 전용

- `FSL__InternalSLRGeolocation__Latitude__s`
- `FSL__InternalSLRGeolocation__Longitude__s`
- `FSL__InternalSLRGeolocation__c`

---

## 3. ServiceAppointment Custom Fields

> Custom fields associated with an appointment to complete work for a customer in Field Service.

표준필드는 ServiceAppointment object reference 참조.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Fields (20):**

| 필드 API명 | Type | Properties | Description |
|---|---|---|---|
| `FSL__Appointment_Grade__c` | double | Create, Filter, Nillable, Sort, Update | The appointment grade of the scheduled appointment using the Appointment Booking feature. |
| `FSL__Auto_Schedule__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if the appointment is created and scheduled in the same action. The default value is false. For more info, view the Schedule an Appointment Automatically Help article. |
| `FSL__Duration_In_Minutes__c` | double | Filter, Nillable, Sort | The duration in minutes of the scheduled appointment. It calculates the time between the scheduled start and end times in minutes. This is a calculated field. |
| `FSL__Emergency__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if the Emergency Wizard global action schedules the appointment. If true, the service appointment has an emergency icon in the Field Service dispatcher console's Gantt chart. The default value is false. |
| `FSL__GanttColor__c` | string | Create, Filter, Group, Nillable, Sort, Update | The Hex color of the service appointment in the Field Service dispatcher console's Gantt chart and the resource calendar. |
| `FSL__GanttIcon__c` | textarea | Create, Nillable, Update | A custom icon for the service appointment that appears in the Gantt chart, map, and appointment list. This helps dispatchers quickly identify appointment characteristics. For example, use a custom icon to indicate that an appointment is for a VIP or first-time customer. The format is a URL ending in an image suffix, such as .png or .gif. The image is scaled to 16 x 16 pixels. For more info, view the Create Custom Appointment Icons Help article. |
| `FSL__GanttLabel__c` | string | Create, Filter, Group, Nillable, Sort, Update | The label of the scheduled service appointment in the Field Service dispatcher console's Gantt chart. This replaces the service appointment number in the chart. |
| `FSL__Gantt_Display_Date__c` | dateTime | Create, Filter, Nillable, Sort, Update | The Gantt Display Date filter in the date field dropdown menu in the Field Service dispatcher console to control which appointments are visible in the appointment list. When a service appointment's Gantt Display Date falls within the Gantt time frame, the appointment is visible on the Gantt. For example, if a maintenance appointment must be completed within the next six months, you can set the date so that you see it on the Gantt every day. You can set up this field to update an important appointment's Gantt Display Date to today's date on a daily basis. For more info, view the Control Which Appointments Appear in the Dispatcher Console Help article. |
| `FSL__InJeopardyReason__c` | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The reason for when the service appointment is in jeopardy. Use this field only when the FSL__InJeopardy__c status is true. You can add custom picklist values. |
| `FSL__InJeopardy__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines if a service appointment is in jeopardy. This helps dispatchers gain visibility to service appointments at risk. A user can manually set the service appointment status to In Jeopardy or this can be done automatically using, for example, process builders or triggers. The default value is false. |
| `FSL__IsFillInCandidate__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines if this service appointment is considered as a candidate when filling in a schedule with the Fill-In Schedule feature. If a service appointment's parent record is a work order or work order line item, the parent record's FSL__IsFillInCandidate__c field must also be set to true for the appointment to be a candidate. Alternatively, instead of using this field, you can create a custom checkbox field, including formula fields, to evaluate whether this appointment is considered as a candidate. This can be done through the Field Service Settings page. The default value is true. For more info, view the Fill Schedule Gaps Help article. |
| `FSL__IsMultiDay__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines if this service appointment spans over multiple days. Alternatively, instead of using this field, you can create a checkbox formula field through the Field Service Settings page to evaluate whether it spans over multiple days or not. The default value is false. For more info, view the Enable Multiday Service Appointments Help article. |
| `FSL__Pinned__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines if this service appointment is pinned to the Field Service dispatcher console's Gantt chart. Pinned service appointments can't be manually dragged or automatically scheduled by any scheduling operation. Pinned service appointments have a lock icon in the Field Service dispatcher console's Gantt chart. The default value is false. |
| `FSL__Prevent_Geocoding_For_Chatter_Actions__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines if the service appointment's BeforeUpdate Platform Apex trigger disables the Chatter Actions's geolocation cleanup on address change. When this field is set to true, it prevents Chatter Actions to geocode the address and waits until Field Service does it after the address changes. This field is set to false after the cleanup completes. The default value is false. |
| `FSL__Schedule_Mode__c` | picklist | Create, Defaulted on create, Filter, Group, Nillable, Unrestricted picklist, Sort, Update | The type of the scheduling operation. For example, when not using Enhanced Scheduling and Optimization, if the service appointment is scheduled using drag and drop, the value is Manual. If the service appointment is scheduled using the Appointment Booking feature, the value is Automatic. When using Enhanced Scheduling and Optimization, if the service appointment is scheduled using drag and drop, the value is Drag and Drop. If the service appointment is scheduled using the Appointment Booking feature, the value is Schedule. This field is populated by the system. Don't edit this field. |
| `FSL__Schedule_over_lower_priority_appointment__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines whether you can schedule critical service appointments over lower priority appointments. The default value is false. For more info, view the Schedule Appointments Using Priorities Help article. |
| `FSL__Scheduling_Policy_Used__c` | reference | Create, Filter, Group, Nillable, Sort, Update | A scheduling policy used by the scheduler for the service appointment. If you edit this field, the policy overrides the default one on the Field Service Settings page. If this field is empty, the field populates with the policy used by the scheduler after the service appointment gets scheduled. This is a relationship field. |
| `FSL__UpdatedByOptimization__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines if the service appointment is updated by the optimizer. This field is populated by the system. Don't edit this field. The default value is false. |
| `FSL__Use_Async_Logic__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines if the scheduling features related to the service appointment run asynchronously. If you use UI features, such as the Appointment Booking global action, the managed package takes care of this async response for you. The default value is false. |
| `FSL__Virtual_Service_For_Chatter_Action__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines if the service appointment is a candidate or dummy appointment. If the value is true, the appointment is ignored by your custom triggers. This field is populated by the system. Don't edit this field. The default value is false. |

**Possible values:**

- `FSL__InJeopardyReason__c`: `Delayed Finish` / `Delayed Start` / `Due Date Approaching` / `No Response` / `Rejected by Contractor`
- `FSL__Schedule_Mode__c`: `Automatic` / `Manual` / `None` / `Optimization`. Additional values for each scheduling operation, available only with Enhanced Scheduling and Optimization: `Drag and Drop` / `Schedule` / `Global Optimization` / `In-Day Optimization` / `Resource Optimization`. The default value is `None`.

**Formula** (`FSL__Duration_In_Minutes__c`):

```
// 원본 발췌 — PDF Formula
IF (ISBLANK(SchedStartTime), 0, (SchedEndTime - SchedStartTime)*24*60)
```

**Relationship** (`FSL__Scheduling_Policy_Used__c`): Relationship Name `FSL__Scheduling_Policy_Used__r` / Relationship Type `Lookup` / Refers To `FSL__Scheduling_Policy__c`

**Internal Fields (3):** Street Level Routing calculations 전용

- `FSL__InternalSLRGeolocation__Latitude__s`
- `FSL__InternalSLRGeolocation__Longitude__s`
- `FSL__InternalSLRGeolocation__c`

---

## 4. ServiceResource Custom Fields

> Custom fields associated with a field service technician or crew in Field Service.

표준필드는 ServiceResource object reference 참조.

**Supported Calls:** `create()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

> [sic] 이 객체의 Supported Calls는 9객체 중 유일하게 `delete()`·`undelete()`가 없다(`create()` 다음 바로 `describeLayout()`로 이어짐). PDF 원문 그대로 보존 — 오타인지 의도된 제약인지는 PDF에서 확정되지 않는다.

**Fields (6):** (Internal Fields 없음)

| 필드 API명 | Type | Properties | Description |
|---|---|---|---|
| `FSL__Efficiency__c` | double | Create, Filter, Nillable, Sort, Update | The efficiency score or the work pace of the service resource. Enter a value from 0.1 to 10. An efficiency of 1 (default) means that the mobile worker works at a typical or average speed. An efficiency greater than 1 means that the mobile worker works faster than average. Less than 1 means that the mobile worker works slower than average. For more info, view the Estimate a Service Resource's Efficiency Help article. |
| `FSL__GanttLabel__c` | string | Create, Filter, Group, Nillable, Sort, Update | The description of the service resource in the Field Service dispatcher console's Gantt chart. This is shown under the service resource's name in the chart. |
| `FSL__Online_Offset__c` | double | Create, Filter, Nillable, Sort, Update | The offset of how long the service resource is considered online since they last used or logged into the mobile app. This overrides the default value in the Field Service Settings page. |
| `FSL__Picture_Link__c` | url | Create, Filter, Group, Nillable, Sort, Update | The URL link to the customer's picture used as the avatar in the Field Service dispatcher console's Gantt chart. If no URL is provided here, the Gantt chart uses the user avatar. |
| `FSL__Priority__c` | double | Create, Filter, Nillable, Sort, Update | The priority of the service resource used to rank their appointments. The lower the number the higher the priority. |
| `FSL__Travel_Speed__c` | double | Create, Filter, Nillable, Sort, Update | The average aerial travel speed of the service resource used to calculate the aerial travel time. This field overrides the default value in the Field Service Settings page. The units, selected in the Field Service Settings page, are KPH or MPH. Street level routing and predictive travel calculations don't use this field. They have their own settings. |

---

## 5. ServiceResourceCapacity Custom Fields

> Custom fields associated with the maximum number of scheduled hours or number of service appointments that a capacity-based service resource can complete within a specific time period.

표준필드는 ServiceResourceCapacity object reference 참조.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Fields (4):** (Internal Fields 없음)

| 필드 API명 | Type | Properties | Description |
|---|---|---|---|
| `FSL__HoursInUse__c` | double | Filter, Nillable, Sort | The total number of hours of scheduled services occupied by the service resource. This is used by the Field Service dispatcher console to show how much resource capacity is used up and by the scheduler to prevent offering resources whose capacity is full. This field is updated when the scheduler runs and updates the FSL__MinutesUsed__c field. This is a calculated field. |
| `FSL__Last_Updated_Epoch__c` | double | Create, Filter, Nillable, Sort, Update | The date and time, in Epoch format, that the Capacity object was last updated. The Capacity object is updated when a service is scheduled on a capacity-based resource. This field is used by the Field Service dispatcher console. |
| `FSL__MinutesUsed__c` | double | Create, Filter, Nillable, Sort, Update | The total number of minutes of scheduled services occupies [sic] by the service resource. This is used by the Field Service dispatcher console to show how much resource capacity is used up and by the scheduler to prevent offering resources whose capacity is full. |
| `FSL__Work_Items_Allocated__c` | double | Create, Filter, Nillable, Sort, Update | The number of scheduled service appointments that fill the capacity. This is used by the Field Service dispatcher console to show how much resource capacity is used up. |

> [sic] `FSL__MinutesUsed__c` Description의 "minutes of scheduled services **occupies** by"는 문법상 occupied가 맞으나 PDF 원문 그대로 보존.

**Formula** (`FSL__HoursInUse__c`):

```
// 원본 발췌 — PDF Formula
FSL__MinutesUsed__c / 60
```

---

## 6. ServiceTerritory Custom Fields

> Custom fields associated with a geographic or functional region in which field service work can be performed in Field Service.

표준필드는 ServiceTerritory object reference 참조.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Fields (4):**

| 필드 API명 | Type | Properties | Description |
|---|---|---|---|
| `FSL__Hide_Emergency_Map__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Controls if the Emergency Wizard map used by the Emergency Wizard global action is hidden for a service territory. This is for privacy purposes. If this is true, it shows a list of appointments with estimated time of arrivals instead. The default value is false. |
| `FSL__NumberOfServicesToDripFeed__c` | double | Create, Filter, Nillable, Sort, Update | The drip feed rate to dispatch appointments. This is part of the drip feed dispatching feature. This value overrides the default value in the Field Service Settings page. For more info, view the Drip Feed Service Appointments Help article. |
| `FSL__System_Jobs__c` | multipicklist | Create, Filter, Nillable, Update | The list of automators for scheduling jobs associated with a single territory. Possible values are the default or custom automator names configured in the Field Service Settings page. For example, if you create an optimization automator for Los Angeles called "LA_Optimize_1", this field is populated with LA_Optimize_1 for the LA service territory. This field is populated by the system. Don't edit this field. |
| `FSL__TerritoryLevel__c` | double | Create, Filter, Nillable, Sort, Update | The territory hierarchy level of the polygon defining the service territory. A polygon is a custom shape drawn on the map to define the area of the territory. It can be nested inside another polygon creating a hierarchy. This field is populated by the system. Don't edit this field. |

**Internal Fields (3):** Street Level Routing calculations 전용

> 주의: 이 객체의 Internal 필드는 다른 객체(`FSL__InternalSLRGeolocation...`)와 달리 `FSL__Internal_SLRGeolocation...` (Internal 뒤 언더스코어 있음) 형태다. PDF 원문 그대로 보존.

- `FSL__Internal_SLRGeolocation__Latitude__s`
- `FSL__Internal_SLRGeolocation__Longitude__s`
- `FSL__Internal_SLRGeolocation__c`

---

## 7. TimeSlot Custom Fields

> Custom fields associated with a period of time on a specified day of the week during which field service work can be performed in Field Service. Operating hours consist of one or more time slots.

표준필드는 TimeSlot object reference 참조.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `update()`, `upsert()`

> 참고: 이 객체는 `search()`가 없다 (PDF 원문 그대로 — 객체별 호출 차이는 정상).

**Fields (2):** (Internal Fields 없음)

| 필드 API명 | Type | Properties | Description |
|---|---|---|---|
| `FSL__Designated_Work_Boolean_Fields__c` | multipicklist | Create, Filter, Nillable, Update | The type of designated work time slot. To convert a regular time slot to a designated one, use the calendar editor in the Visualforce page instead of editing this field manually in the record page. |
| `FSL__Slot_Color__c` | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The time slot color as it appears on the calendar editor in the Visualforce page. This field is populated by the system. |

**Possible values:**

- `FSL__Designated_Work_Boolean_Fields__c`: `None—Default`. Additional values are added by the managed package when a time slot is converted to a designated work type. The values are the API names of the designated work boolean fields on the service appointment.
- `FSL__Slot_Color__c` (16색): `Amber` / `Asphalt` / `Black` / `Blue` / `Brown` / `Cyan` / `Green` / `Grey` / `Indigo` / `Lime` / `Orange` / `Pink` / `Purple` / `Red` / `Teal` / `Yellow`

---

## 8. WorkOrder Custom Fields

> Custom fields associated with field service work to be performed for a customer.

표준필드는 WorkOrder object reference 참조.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Fields (4):** (Internal Fields 없음)

| 필드 API명 | Type | Properties | Description |
|---|---|---|---|
| `FSL__IsFillInCandidate__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines if this work order is considered as a candidate when filling in a schedule with the Fill-In Schedule feature. If a service appointment's parent record is a work order, this field must also be set to true for the appointment to be a candidate. Alternatively, you can create a custom checkbox field through the Field Service Settings page, instead of using this field, to evaluate whether this appointment is considered as a candidate. The custom checkbox field includes formula fields. The default value is true. For more info, view the Fill Schedule Gaps Help article. |
| `FSL__Prevent_Geocoding_For_Chatter_Actions__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines if the work order's BeforeUpdate trigger disables the Chatter Action's geolocation cleanup on address change. This field is set to false after the cleanup completes. The default value is false. |
| `FSL__Scheduling_Priority__c` | double | Filter, Nillable, Sort | The work order priority. The lower the value, the higher the priority. For more info, view the Schedule Appointments Using Priorities Help article. This is a calculated field. |
| `FSL__VisitingHours__c` | reference | Create, Filter, Group, Nillable, Sort, Update | The visiting hours that define when service appointments associated with the work order can be scheduled. The visiting hours are enforced as long as the Visiting Hours work rule complies with the scheduling policy. Visiting hours are enforced only if the Visiting Hours work rule is part of the scheduling policy. For more info, view the Work Rule Type: Service Appointment Visiting Hours Help article. This is a relationship field. |

**Formula** (`FSL__Scheduling_Priority__c`):

```
// 원본 발췌 — PDF Formula
CASE(TEXT(Priority), 'Critical' , 1 , 'High' ,2,'Medium' ,3 , 'Low', 4, null)
```

**Relationship** (`FSL__VisitingHours__c`): Relationship Name `FSL__VisitingHours__r` / Relationship Type `Lookup` / Refers To `OperatingHours`

---

## 9. WorkOrderLineItem Custom Fields

> Custom fields associated with a subtask on a work order in field service.

표준필드는 WorkOrderLineItem object reference 참조.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Fields (2):** (Internal Fields 없음)

| 필드 API명 | Type | Properties | Description |
|---|---|---|---|
| `FSL__IsFillInCandidate__c` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Determines if this work order line item is considered as a candidate when filling in a schedule with the Fill-In Schedule feature. If a service appointment's parent record is a work order line item, this field must also be set to true for the appointment to be a candidate. Alternatively, you can create a custom checkbox field through the Field Service Settings page, instead of using this field, to evaluate whether this appointment is considered as a candidate. The custom checkbox field includes formula fields. The default value is true. For more info, view the Fill Schedule Gaps Help article. |
| `FSL__VisitingHours__c` | reference | Create, Filter, Group, Nillable, Sort, Update | The visiting hours that define when service appointments associated with the work order line item can be scheduled. Visiting hours are enforced only if the Visiting Hours work rule is part of the scheduling policy. For more info, view the Work Rule Type: Service Appointment Visiting Hours Help article. This is a relationship field. |

**Relationship** (`FSL__VisitingHours__c`): Relationship Name `FSL__VisitingHours__r` / Relationship Type `Lookup` / Refers To `OperatingHours`

---

## 객체별 커스텀필드 수 요약

| 객체 | Fields (외부) | Internal Fields | 비고 |
|---|---|---|---|
| AssignedResource | 5 | 3 | API 38.0+ |
| ResourceAbsence | 11 | 3 | |
| ServiceAppointment | 20 | 3 | 최대 |
| ServiceResource | 6 | 0 | Supported Calls에 `delete()`/`undelete()` 없음 [sic] |
| ServiceResourceCapacity | 4 | 0 | "occupies" 오타 [sic] |
| ServiceTerritory | 4 | 3 | Internal 필드명 `FSL__Internal_SLR...` (언더스코어 위치 다름) |
| TimeSlot | 2 | 0 | `Slot_Color` 16색 enum |
| WorkOrder | 4 | 0 | |
| WorkOrderLineItem | 2 | 0 | |
| **합계** | **58** | **12** | |

## [sic] / 원문 이상 후보 (3건)

1. **ServiceResourceCapacity `FSL__MinutesUsed__c`** — Description "minutes of scheduled services **occupies** by the service resource" (occupied가 문법상 정답). PDF 원문 그대로 [sic].
2. **ServiceResource Supported Calls** — 9객체 중 유일하게 `delete()`/`undelete()` 누락. 오타인지 의도된 제약인지 불명. PDF 원문 그대로 보존.
3. **ServiceTerritory Internal Fields 명명 불일치** — 다른 객체는 `FSL__InternalSLRGeolocation__...`인데 ServiceTerritory만 `FSL__Internal_SLRGeolocation__...` (Internal 뒤 언더스코어). PDF 원문 그대로 보존.

## 관련 노트

- [[Field Service 개요와 데이터 모델]] — Field Service 데이터 모델·관리패키지 개요
- [[Field Service Objects]] — FSL 표준 객체 색인 허브
- [[FSL Apex Namespace]] — 관리패키지 관련 추가 API 레퍼런스
- [[객체 레퍼런스 — Service Appointment·Resource]] — ServiceAppointment·AssignedResource 표준필드
- [[객체 레퍼런스 — Service Resource·Crew·Skill]] — ServiceResource·ResourceAbsence·ServiceResourceCapacity 표준필드
- [[객체 레퍼런스 — Service Territory·OperatingHours·Shift]] — ServiceTerritory·TimeSlot 표준필드
- [[객체 레퍼런스 — Work Order·WorkOrderLineItem·Status]] — WorkOrder·WorkOrderLineItem 표준필드
