---
tags: [scheduler, salesforce-scheduler, platform-events, metadata-api, industriessettings, appointmentschedulingevent]
source: salesforce_scheduler_dev_guide.pdf (Salesforce Scheduler Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [ServiceAppointmentEvent, AppointmentSchedulingEvent, IndustriesSettings, Scheduler 플랫폼 이벤트, Industries.settings, 외부 캘린더 이벤트]
---

# Salesforce Scheduler — Platform Events·Metadata API Types

> Salesforce Scheduler가 제공하는 플랫폼 이벤트 2종(`ServiceAppointmentEvent`·`AppointmentSchedulingEvent`)과 공유 자식 이벤트 2종(`AsgnRsrcApptSchdEvent`·`SvcApptSchdEvent`), 그리고 Scheduler 조직 설정을 담는 Metadata API 타입 `IndustriesSettings`(`Industries.settings`)를 소스 그대로 전수 정리한다.

---

## ServiceAppointmentEvent (Platform Event)

서비스 약속이 이벤트 플랫폼에서 생성될 때 그 세부 정보를 구독자에게 알리는 플랫폼 이벤트.

> Notifies subscribers of the service appointment details that are generated from the event platform.

| 항목 | 값 |
|---|---|
| 종류 | Platform Event |
| API version | 59.0 이상 |
| Supported Calls | `describeSObjects()` |
| Subscription Channel | `/event/ServiceAppointmentEvent` |
| Special Access Rules | This object is available when Salesforce Scheduler is enabled. |

### Supported Subscribers

| Subscriber | Supported? |
|---|---|
| Apex Triggers | ✅ |
| Flows | ❌ |
| Processes | ❌ |
| Pub/Sub API | ✅ |
| Streaming API (CometD) | ✅ |

### Fields (5)

| Field | Type | Properties | Description |
|---|---|---|---|
| `AsgnRsrcApptSchdDtlEvent` | `AsgnRsrcApptSchdEvent[]` | Nillable | One or multiple assigned resource records related to the scheduler appointment event. |
| `ChangeType` | `string` | Nillable | The operation that caused the change. For example: CREATE, UPDATE, DELETE. |
| `EventUuid` | `string` | Nillable | A universally unique identifier (UUID) that identifies a platform event message. |
| `ReplayId` | `string` | Nillable | Represents an ID value that is populated by the system and refers to the position of the event in the event stream. Replay ID values aren't guaranteed to be contiguous for consecutive events. A subscriber can store a replay ID value and use it on resubscription to retrieve missed events that are within the retention window. |
| `ServiceApptSchduleEvent` | `SvcApptSchdEvent[]` | Nillable | The service appointment related to the scheduler appointment event. |

> [!note] 철자 보존: 필드명 `ServiceApptSchduleEvent`는 PDF 원문 그대로다(`Schdule` — `Schedule`이 아님). 위키에서 임의로 정정하지 않는다.

---

## IndustriesSettings (Metadata API Type)

Salesforce Scheduler의 조직 설정을 나타내는 Metadata API 타입.

> Represents settings for Salesforce Scheduler.

| 항목 | 값 |
|---|---|
| 종류 | Metadata API Type |
| 상속 | `Metadata` 타입을 확장하며 `fullName` 필드를 상속 |
| Manifest 접근 이름 | `Settings` |
| 파일 | `Industries.settings` (`settings` 디렉터리) |
| API version | 47.0 이상 |

### Fields (17, 모두 `boolean`)

| Field Name | Description |
|---|---|
| `appointmentDistributionOrgPref` | Indicates whether to schedule appointments for service resources based on appointment distribution (`true`) or not (`false`). Default `false`. API 52.0+. |
| `captureResourceUtilizationOrgPref` | Indicates whether to use a background process to calculate the usage of service resources from service appointments (`true`) or not (`false`). Default `false`. API 52.0+. |
| `enableAnyResourceTypeOrgPref` | Indicates whether to enable Salesforce Scheduler to consider service resource records with Agent resource type (`true`) or not (`false`). Before enabling, create a service resource record as Main for each user, or update one as Main for each user. Default `false`. API 57.0+. |
| `enableAppFrmAnywhereOrgPref` | Indicates whether to use engagement channels for setting up shifts, work types, and booking a service appointment (`true`) or not (`false`). Default `false`. API 56.0+. See the prerequisites before you enable this setting. |
| `enableBlockResourceAvailabilityOrgPref` | Indicates whether Salesforce Scheduler service appointments are added to users' Salesforce calendars. For example, if set to `false`, users don't see their service appointments on their calendars. Default `false`. API 47.0+. This setting is used in Financial Services Cloud. |
| `enableCapacitySchedulingPref` | Indicates whether users can use capacity-based scheduling (`true`) or not (`false`). Use capacity-based scheduling to control the number of appointments that can be scheduled for a given shift and type of work. API 62.0+. See the prerequisite before you enable this setting. |
| `enableCreateMultiAttendeeEventOrgPref` | Indicates whether users can group individual events, and view the list of all attendees under a single event `true` or not `false`. Default `false`. See the prerequisites. API 55.0+. This setting is used in Financial Services Cloud. |
| `enableDropInAppointmentsOrgPref` | Indicates whether users can manage drop-in participants (`true`) or not (`false`). Default `false`. API 58.0+. See the prerequisite. |
| `enableDropInSkillMatchingOrgPref` | Indicates whether skill and skill level matching is enabled for service resources that are assigned to waitlists for a service territory (`true`) or not (`false`). Default `false`. API 58.0+. |
| `enableEventManagementOrgPref` | Indicates whether users can add Salesforce Scheduler service appointments to their Salesforce calendars. Default `false`. API 47.0+. This setting is used in Financial Services Cloud. |
| `enableEventWriteOrgPref` | Indicates whether to publish high-volume platform events when users create, update, or delete service appointments in Salesforce Scheduler (`true`) or not (`false`). If enabled, write these events to an external system to update it with Salesforce Scheduler service appointments. Default `false`. API 49.0+. |
| `enableMultipleTopicsForShiftsOrgPref` | Indicates whether the multiple topics for shifts feature is enabled (`true`) or disabled (`false`). Default `false`. API 56.0+. See the prerequisite. |
| `enableMultiResourceOrgPref` | Indicates whether users can add multiple service resources to a service appointment. Default `false` Available in API version 47.0 and later. This setting is used in Financial Services Cloud. |
| `enableOverbookingOrgPref` | Indicates whether users can add multiple service appointments to a single time slot for a service resource. If set to `false`, concurrent time slots are visible, but can't be modified. Default `false` API 47.0+. This setting is used in Financial Services Cloud. |
| `enableShareSaWithArOrgPref` | Indicates whether to share service appointments with assigned resources (`true`) or not (`false`). Default `false`. API 55.0+. |
| `enableTopicOrTemplate` | Indicates whether to use Salesforce Scheduler to manage Health Cloud appointments (`true`) or not (`false`). Default `false`. You must enable the `enableTopicTimeSlot` field before enabling this setting. API 52.0+. |
| `enableTopicTimeSlot` | Indicates whether to set operating hours for Service Territory Members for Work Type Groups (`true`) or not (`false`). Default `false`. See the prerequisites. After you enable this setting, you can't disable it. API 52.0+. |

> [!note] 원문 보존: `enableMultiResourceOrgPref`·`enableOverbookingOrgPref`의 `Default false` 뒤 마침표 누락은 PDF 원문 그대로다.

### Declarative Metadata Sample — `Industries.settings`

다음은 PDF에 수록된 선언적 메타데이터 샘플이다. 원문 그대로이며, 17개 필드 중 `enableCapacitySchedulingPref`는 샘플에 포함돼 있지 않다(PDF 원문 그대로 — 임의로 추가하지 않음).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<IndustriesSettings xmlns="http://soap.sforce.com/2006/04/metadata">
    <appointmentDistributionOrgPref>true</appointmentDistributionOrgPref>
    <captureResourceUtilizationOrgPref>true</captureResourceUtilizationOrgPref>
    <enableBlockResourceAvailabilityOrgPref>true</enableBlockResourceAvailabilityOrgPref>
    <enableCreateMultiAttendeeEventOrgPref>true</enableCreateMultiAttendeeEventOrgPref>
    <enableDropInSkillMatchingOrgPref>true</enableDropInSkillMatchingOrgPref>
    <enableEventManagementOrgPref>true</enableEventManagementOrgPref>
    <enableAppFrmAnywhereOrgPref>true</enableAppFrmAnywhereOrgPref>
    <enableAnyResourceTypeOrgPref>true</enableAnyResourceTypeOrgPref>
    <enableDropInAppointmentsOrgPref>true</enableDropInAppointmentsOrgPref>
    <enableEventWriteOrgPref>true</enableEventWriteOrgPref>
    <enableMultipleTopicsForShiftsOrgPref>true</enableMultipleTopicsForShiftsOrgPref>
    <enableMultiResourceOrgPref>true</enableMultiResourceOrgPref>
    <enableOverbookingOrgPref>true</enableOverbookingOrgPref>
    <enableShareSaWithArOrgPref>true</enableShareSaWithArOrgPref>
    <enableTopicOrTemplate>true</enableTopicOrTemplate>
    <enableTopicTimeSlot>true</enableTopicTimeSlot>
</IndustriesSettings>
```

### package.xml

`IndustriesSettings`는 manifest에서 `Settings` 이름과 `Industries` 멤버로 참조한다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>Industries</members>
        <name>Settings</name>
    </types>
    <version>47.0</version>
</Package>
```

---

## AppointmentSchedulingEvent (Platform Event — 외부 캘린더용)

약속 일정이 추가·수정·삭제될 때 구독자에게 알리는 플랫폼 이벤트. 외부 캘린더 연동에 사용한다.

> Notifies subscribers when an appointment schedule is added, updated, or deleted.

| 항목 | 값 |
|---|---|
| 종류 | Platform Event |
| API version | 50.0 이상 |
| Supported Calls | `describeSObjects()` |
| Subscription Channel | `/event/AppointmentSchedulingEvent` |
| Event Delivery Allocation Enforced | Yes |
| Special Access Rules | AppointmentSchedulingEvent is available as part of Salesforce Scheduler. |
| SEE ALSO | Platform Events Developer Guide |

### Supported Subscribers

| Subscriber | Supported? |
|---|---|
| Apex Triggers | ✅ |
| Flows | ❌ |
| Processes | ❌ |
| Pub/Sub API | ✅ |
| Streaming API (CometD) | ✅ |

### Fields (6)

| Field | Type | Properties | Description |
|---|---|---|---|
| `AssignedResourceFields` | `AsgnRsrcApptSchdEvent[]` | Nillable | The assigned resources associated with the appointment. |
| `ChangeType` | `string` | Nillable | The operation that caused the change. For example: CREATE, UPDATE, DELETE. |
| `CorrelationId` | `string` | Nillable | The universally unique identifier (UUID) that correlates the appointment with the platform event. |
| `EventUuid` | `string` | Nillable | A universally unique identifier (UUID) that identifies a platform event message. API 52.0+. |
| `ReplayId` | `string` | Nillable | Represents an ID value that is populated by the system and refers to the position of the event in the event stream. Replay ID values aren't guaranteed to be contiguous. A subscriber can store a replay ID value and use it on resubscription to retrieve missed events within the retention window. |
| `ServiceAppointmentFields` | `SvcApptSchdEvent[]` | Nillable | The service appointments associated with the appointment. |

### Example event message

PDF에 수록된 이벤트 메시지 예시(verbatim).

```json
{
  "schema": "Zog7FKcPWV9DeEIEVHsoug",
  "payload": {
    "CreatedById": "005xx000001X7dlAAC",
    "ChangeType": "CREATE",
    "ServiceAppointmentFields": {
      "ParentRecordId": "001RM000003rwkfYAA", "ContactId": "003RM000006EpajYAC", "Status": "None",
      "AdditionalInformation": "Sample additional information", "ServiceTerritoryId": "0Hhxx0000004mu4",
      "Comments": "Sample comment", "Email": "abc@example.com",
      "Address": "1 Market Street San Francisco CA 94105 United States", "WorkTypeId": "08qxx0000004C92",
      "WorkTypeBlockTimeBeforeAppointment": 30, "WorkTypeBlockTimeAfterAppointment": 1,
      "WorkTypeBlockTimeBeforeUnit": "minutes", "WorkTypeBlockTimeAfterUnit": "hours",
      "ServiceAppointmentId": "08pxx0000005Ip6", "ScheduledEndTime": "2020-02-28T00:45:00.000Z",
      "Subject": "Apply for Privileged Customer Card", "AppointmentType": "null", "StatusCategory": "None",
      "DurationInMinutes": 60, "Phone": "4155551212", "ScheduledStartTime": "2020-02-27T23:45:00.000Z"
    },
    "AssignedResourceFields": [
      { "IsPrimaryResource": true, "ServiceResourceUserName": "Rachel Adams", "ServiceResourceUserId": "005xx000001X7dl", "AssignedResourceId": "03rxx0000004gLc", "ServiceResourceId": "0Hnxx0000004C92", "ServiceResourceUserEmail": "ra@example.com", "IsRequiredResource": true },
      { "IsPrimaryResource": false, "ServiceResourceUserName": "Andrew Collins", "ServiceResourceUserId": "005xx000001XPNl", "AssignedResourceId": "03rxx0000004gNE", "ServiceResourceId": "0Hnxx0000006z8q", "ServiceResourceUserEmail": "ac@example.com", "IsRequiredResource": false }
    ],
    "CreatedDate": "2020-02-25T01:57:39.936Z", "CorrelationId": "d7c0bbGiUObLF6BD3NaG"
  },
  "event": { "replayId": 3 }
}
```

---

## 공유 자식 이벤트

`ServiceAppointmentEvent`와 `AppointmentSchedulingEvent`는 아래 두 자식 이벤트를 공유한다. 각 자식의 **Parent Platform Events**에 두 부모가 모두 명시된다. 두 자식 채널에는 직접 구독할 수 없으며, 부모 플랫폼 이벤트 채널의 스트리밍 알림에 포함되어 전달된다.

### AsgnRsrcApptSchdEvent

> Represents the assigned resources that are part of various platform events. Included in a streamed notification on the channels for the parent platform events. You can't subscribe to the AsgnRsrcApptSchdEvent channel directly.

- API version 50.0 이상 · Supported Calls `describeSObjects()`
- Parent Platform Events: `AppointmentSchedulingEvent`, `ServiceAppointmentEvent`

| Field | Type | Properties | Description |
|---|---|---|---|
| `AssignedResourceId` | `string` | Nillable | ID of the assigned resource. |
| `ChangedFields` | `complexvalue` | Nillable | A list of fields that changed. |
| `EventUuid` | `string` | Nillable | A UUID that identifies a platform event message. API 52.0+. |
| `IsPrimaryResource` | `boolean` | Defaulted on create | Indicates whether the resource is primary. |
| `IsRequiredResource` | `boolean` | Defaulted on create | Indicates whether the resource is required. |
| `ServiceResourceId` | `string` | Nillable | ID of the service resource assigned to the event. |
| `ServiceResourceUserEmail` | `string` | Nillable | Email of the service resource user assigned to the event. |
| `ServiceResourceUserId` | `string` | Nillable | ID of the user record associated with the service resource assigned to the event. |
| `ServiceResourceUserName` | `string` | Nillable | Username as per the user record associated with the service resource assigned to the event. |

### SvcApptSchdEvent

> Represents the service appointment event. Included in a streamed notification on the channels for the parent platform events. You can't subscribe to the SvcApptSchdEvent channel directly.

- API version 50.0 이상 · Supported Calls `describeSObjects()`
- Parent Platform Events: `AppointmentSchedulingEvent`, `ServiceAppointmentEvent`

| Field | Type | Properties | Description |
|---|---|---|---|
| `AdditionalInformation` | `string` | Nillable | Additional information about the service appointment. |
| `Address` | `string` | Nillable | The address of the service appointment. |
| `AppointmentType` | `string` | Nillable | The service appointment type. |
| `ChangedFields` | `complexvalue` | Nillable | List of fields that changed. |
| `Comments` | `string` | Nillable | Comments about the service appointment. |
| `ContactId` | `string` | Nillable | ID of the contact associated with the service appointment. |
| `DurationInMinutes` | `double` | Nillable | The duration of the service appointment in minutes. |
| `Email` | `string` | Nillable | The email associated with the service appointment. |
| `EventUuid` | `string` | Nillable | A UUID that identifies a platform event message. API 52.0+. |
| `ParentRecordId` | `string` | Nillable | ID of the parent record associated with the service appointment. |
| `Phone` | `string` | Nillable | The phone number associated with the service appointment. |
| `ScheduledEndTime` | `dateTime` | Nillable | The scheduled end time of the service appointment. |
| `ScheduledStartTime` | `dateTime` | Nillable | The scheduled start time of the service appointment. |
| `ServiceAppointmentId` | `string` | Nillable | ID of the service appointment. |
| `ServiceTerritoryId` | `string` | Nillable | ID of the service territories associated with the service appointment. |
| `Status` | `string` | Nillable | The status of the service appointment. |
| `StatusCategory` | `string` | Nillable | The status category of the service appointment. |
| `Subject` | `string` | Nillable | The subject of the service appointment. |
| `WorkTypeBlockTimeAfterAppointment` | `int` | Nillable | The period of time occurring after the appointment that is typically blocked for this work type. |
| `WorkTypeBlockTimeAfterUnit` | `string` | Nillable | The unit of the period specified for WorkTypeBlockTimeAfterAppointment. Values include `hour` and `minute`. |
| `WorkTypeBlockTimeBeforeAppointment` | `int` | Nillable | The period of time occurring before the appointment that is typically blocked for this work type. |
| `WorkTypeBlockTimeBeforeUnit` | `string` | Nillable | The unit of the period specified for WorkTypeBlockTimeBeforeAppointment. Values include `hour` and `minute`. |
| `WorkTypeId` | `string` | Nillable | ID of the work type associated with the service appointment. |

> 참고: 위 두 자식 이벤트는 `ServiceAppointmentEvent`의 `AsgnRsrcApptSchdDtlEvent`(`AsgnRsrcApptSchdEvent[]`)·`ServiceApptSchduleEvent`(`SvcApptSchdEvent[]`) 필드 타입의 상세이기도 하다.

---

## 관련 노트

- [[Salesforce Scheduler 표준객체 — 핵심 예약]] — ServiceAppointment·AssignedResource 등 자식 이벤트의 원본 객체
- [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]] — Scheduler 개요·셋업·데이터 모델
- [[Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형]] — AppointmentSchedulingPolicy·OperatingHours·WorkType
- [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]] — ServiceResource·ServiceTerritory·Skill·Shift
- [[Platform Event 정의와 구독]]
- [[Metadata Types — 개요 및 분류]]
