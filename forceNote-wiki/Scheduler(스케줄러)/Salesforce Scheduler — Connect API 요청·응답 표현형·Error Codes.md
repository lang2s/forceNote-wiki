---
tags: [scheduler, salesforce-scheduler, connect-api, request-body, response-body, error-codes]
source: salesforce_scheduler_dev_guide.pdf (Salesforce Scheduler Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Scheduler Connect 표현형, Service Appointment Input, Available Territory Slots Output, Scheduler Error Codes, MISSING_ARGUMENT, Waitlist Result]
---

# Salesforce Scheduler — Connect API 요청·응답 표현형·Error Codes

> Salesforce Scheduler Connect REST API의 요청 바디(Request Bodies, 13종)·응답 바디(Response Bodies, 28종)·Error Codes(8개 리소스)의 속성표·JSON 예제·에러 행 정본. 엔드포인트의 URI·HTTP 메서드는 [[Salesforce Scheduler — Business REST·Connect 엔드포인트]] 소관이며, 이 노트는 각 엔드포인트가 주고받는 표현형(representation) 상세만 다룬다.

> [!note] 문서 구조 변경 예정 (PDF 응답 바디 섹션 도입부 Important, 2026-07)
> Salesforce는 2026년 7월에 Connect REST API 레퍼런스 콘텐츠를 개편한다. 리소스·요청 바디·응답 바디로 나뉜 개별 페이지를 단일 페이지 확장형 레이아웃으로 통합하며, 기존 리소스 페이지는 새 인터페이스의 해당 리소스로 자동 리디렉트된다. 요청/응답 바디 페이지는 메인 API 레퍼런스 페이지로 리디렉트된다(해당 정보가 리소스와 함께 맥락상 표시되기 때문). 미리보기는 Data 360 Connect REST API 참조.
>
> 응답 바디 섹션 도입부 원문 — "The successful execution of a request to a Connect REST API resource can return a response body in either JSON or XML format. ... A request to a Connect REST API resource always returns an HTTP response code, whether the request was successful or not."

> 엔드포인트(메서드·URI·요청/응답 파라미터)는 [[Salesforce Scheduler — Business REST·Connect 엔드포인트]] 참조.

**표 방향성:** 모든 Request 표는 행=속성, 열=`Name | Type | Description | Required or Optional | Available Version`. 모든 Response 표는 행=속성, 열=`Property Name | Type | Description | Filter Group and Version | Available Version`. Error Codes 표는 행=에러, 열=`HTTP Response Code | Error Code | Description`. Type명·속성명은 원문 표기 그대로(`code`) 보존하며, 일부 깨진 토큰/오타는 `[sic]`로 표시한다.

---

## PART 1 — Connect REST API Request Bodies (13종)

> 섹션 도입부 원문 없음(바로 representation 나열). 각 representation은 설명 1줄 + (Root XML tag) + JSON 예제 + Properties 표.

### 1-1. Available Territory Slots Input

*Input representation of the available territory slots request.*

**Request example:**
```json
{
"startTime": "2022-07-27T00:00:00.000Z",
"endTime": "2022-07-29T00:00:00.000Z",
"workTypeGroupId": "0VSB0000000KyjBOAS",
"accountId": "001B000000qAUAWIA4",
"territoryIds": [
  "0HhB0000000TO9WKAW"
],
"schedulingPolicyId": "0VrB0000000KyjB",
"requiredResourceIds": [
  "0HnB0000000TO8gKAK"
],
"engagementChannelTypeIds": [
  "0eFRM00000000CJ2AY"
]
}
```

**Request example with only required fields:**
```json
{
"workType": {
  "id": "08qS70000004DTsIAM"
},
"territoryIds": [
  "0HhS70000004DTdKAM"
],
"engagementChannelTypeIds": [
  "0eFRM00000000CJ2AY"
]
}
```

**Properties:**

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `accountId` | String | ID of the associated account. | Optional | 49.0 |
| `allowConcurrentScheduling` | Boolean | Indicates whether concurrent appointments are allowed (true) or not allowed (false). The default value is `false`. | Optional | 49.0 |
| `correlationId` | String | ID to pass custom information to the `ServiceResourceScheduleHandler` Apex interface. For example, you can use the correlation ID to identify the app, website, or any other external system that calls this Apex interface implementation. If you don't pass a custom value, a randomly generated identifier is passed. | Optional | 53.0 |
| `endTime` | String | Latest time that an appointment can end. **Note:** The API only returns time slots up to 31 days from the startTime. | Optional | 49.0 |
| `engagementChannelTypeIds` | String[] | The ID of the engagement channel type record. The resources and their associated time slots are filtered by the specified engagement channel type. **Note:** This field supports only one engagement channel type ID. You can use engagement channel types with the `available-territory-slots` API only if: • Schedule Appointments Using Engagement Channels is enabled in Salesforce Scheduler Settings in your Salesforce org. • Shifts are defined in the scheduling policy. For more information on setting up shifts in the scheduling policy, see Define Shift Rules in Scheduling Policy. **Note:** Engagement channel types are not supported with operating hours rules in the scheduling policy. | Optional | 56.0 |
| `filterByResources` | String[] | Comma-separated list of service resource IDs. API returns only eligible service resources that are both in the list and in the selected service territory. The resources are sorted by the order in which the resource IDs are passed. **Note:** You can either pass filterByResources or requiredResourceIds in a request. | Optional | 51.0 |
| `recordLimit` | Integer | The maximum number of earliest available slots across the specified territories. The API outputs the specified number of sorted slots across service territories. | Optional | 63.0 |
| `requiredResourceIds` | String[] | List of resource IDs that you want to get available time slots for. When you pass more than one resource ID, the API returns all the slots where any of the passed resources are available. For example, suppose that you have three qualified resources: A, B, and C. If you pass resource IDs A and B, the API returns all the slots where: • only A is available • only B is available • both A and B are available • both A and C are available • both B and C are available • A, B, and C are all available. The API doesn't return the slots where only C is available. If this field is empty, time slots for all qualified resources are returned. **Note:** The API request doesn't show time slots for the resource specified in requiredResourceIds if it does not appear in the list of least utilized resources set for resourceLimitAppointmentDistribution. For example, if you specify a resource A in requiredResourceIds and resourceLimitAppointmentDistribution is set to 15, the request doesn't show time slots for this resource, as A isn't among the top 15 least utilized resources. | Optional | 49.0 |
| `resourceLimitApptDistribution` | Integer | Specify the maximum number of service resources that you want to show during appointment scheduling when appointment distribution is enabled. Default value is 10. **Note:** The filterByResources field takes precedence over the resourceLimitApptDistribution field. | Optional | 53.0 |
| `schedulingPolicyId` | String | ID of the AppointmentSchedulingPolicy object. If not provided, the default configurations are considered. | Optional | 49.0 |
| `startTime` | String | Earliest time that an appointment can start. Defaults to the current time of the request, if empty. You can also use a time from the past. | Optional | 49.0 |
| `territoryIds` | String[] | List of IDs of service territories where the specified work is performed. | Required | 49.0 |
| `workType` | Work Type Input | Type of work performed. | Required if workTypeGroupId isn't provided | 49.0 |
| `workTypeGroupId` | String | ID of the work type group containing all work types performed. | Required if workType isn't provided | 49.0 |

### 1-2. Assigned Resource Input

*Input representation of the assigned resource details.*

**Root XML tag:** `<assignedResources>`

**JSON example:**
```json
{
"assignedResources": [
  {
    "serviceResourceId": "0HnRM0000004Gzy0AE",
    "isRequiredResource": true,
    "isPrimaryResource": true,
    "extendedFields": []
  },
  {
    "serviceResourceId": "0HnRM0000004Mln0AE",
    "isRequiredResource": true,
    "isPrimaryResource": false,
    "extendedFields": []
  }
]
}
```

**Properties:**

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `extendedFields` | Extended Fields Input[] | Custom fields. | Optional | 48.0 |
| `isPrimaryResource` | Boolean | Indicates whether the assigned resource is the primary resource. For multi-resource appointments, only one resource can be a primary resource. | Required if multi-resource scheduling is enabled. | 48.0 |
| `isRequiredResource` | Boolean | Indicates whether the assigned resource is a required resource. | Required | 48.0 |
| `serviceResourceId` | String | Resource who is assigned to the service appointment. | Required | 48.0 |

### 1-3. Estimated Wait Time Input

*Input representation of the request for the estimated wait time of a waitlist or waitlist participant.*

**Root XML tag:** `<estimatedWaitTime>`

**JSON example with waitlist ID:**
```json
{
"waitlistId": "11wfi700000262vAAA"
}
```

**JSON example with waitlist participant ID:**
```json
{
"waitlistParticipantId": "12oxx0000004FGiAAM"
}
```

**Properties:**

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `waitlistId` | String | ID of the waitlist. | Required if the waitlistParticipantId parameter isn't specified. | 65.0 |
| `waitlistParticipantId` | String | ID of the waitlist participant. | Required if the waitlistId parameter isn't specified. | 65.0 |

### 1-4. Extended Fields Input

*Input representation for extended fields.*

**Root XML tag:** `<extendedFields>`

**JSON example:**
```json
{
"extendedFields": [
  {
    "name": "assigned_to__c",
    "value": "abcd"
  },
  {
    "name": "ownership__c",
    "value": true
  }
]
}
```

**Properties:**

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `name` | String | Name of the custom field. | Optional | 48.0 |
| `value` | String | Value of the custom field. | Optional | 48.0 |

### 1-5. Group Appointments Input

*Input representation of the criteria to filter and retrieve group appointments.*

**JSON example:**
```json
{
"startTime": "2024-01-23T00:00:00.000Z",
"endTime": "2024-02-28T00:00:00.000Z",
"filterByWorkTypes": [
  "08qRM00000003fkYAA"
],
"filterByResources": [
  "0HnB0000000TO8gKAK"
],
"filterByTerritories": [
  "0HhRM00000003OZ0AY"
],
"filterByParentRecords": [
  "001B000000qAUAWIA4"
],
"filterByEngagementChannelTypes": [
  "0eFRM00000000Bv2AI"
],
"extendedFieldsToQuery": [
  "subject",
  "description"
]
}
```

**Properties:**

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `endTime` | String | Latest end time for the group appointments to be retrieved. | Optional | 61.0 |
| `excludeAssociatedAppts` | Boolean | Indicates whether the response excludes appointments where the current user is associated as an attendee or assigned resource (true) or not (false). | Optional | 61.0 |
| `extendedFieldsToQuery` | String[] | List of the extended custom fields to fetch in the output. | Optional | 61.0 |
| `filterByEngagementChannelTypes` | String[] | ID of the engagement channel type record. Group appointments are filtered based on the selected engagement channel type. | Optional | 61.0 |
| `filterByParentRecords` | String[] | The ID of the associated parent record. | Optional | 61.0 |
| `filterByResources` | String[] | List of the group appointments where all the given resources are present. | Optional | 61.0 |
| `filterByTerritories` | String[] | List of IDs of the service territories where the requested work is performed. | Optional | 61.0 |
| `filterByWorkTypeGroups` | String[] | IDs of the work type groups containing the work types that are being performed. | Optional | 61.0 |
| `filterByWorkTypes` | String[] | List of IDs of the work types to be performed. | Optional | 61.0 |
| `limit` | Integer | Maximum number of records to be fetched. | Optional | 61.0 |
| `offset` | Integer | Number of records to be skipped. | Optional | 61.0 |
| `startTime` | String | The earliest start time for the group appointments to be retrieved. If not provided, it defaults to the current time of the request. | Optional | 61.0 |

### 1-6. Lead Input

*Lead input.*

**Root XML tag:** `<lead>`

**JSON example:**
```json
{
"lead": {
  "firstName": "Rachel",
  "lastName": "Adams",
  "phone": "012-345-6789",
  "email": "rachel.adams@jpmc.com",
  "company": "Salesforce",
  "extendedFields": []
}
}
```

**Properties:**

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `company` | String | Lead's company. | Optional | 48.0 |
| `email` | String | Lead's email address. | Optional | 48.0 |
| `extendedFields` | Extended Fields Input[] | Custom fields. | Optional | 48.0 |
| `firstName` | String | Lead's first name. | Optional | 48.0 |
| `lastName` | String | Lead's last name. | Required | 48.0 |
| `phone` | String | Lead's phone number. | Optional | 48.0 |

### 1-7. Service Appointments Create Input

*Input representation for creating a service appointment. You can create service appointments, assign resources, and generate leads with either parentRecordId or lead but not both.*

**JSON example:**
```json
{
"serviceAppointment": {
  "parentRecordId": "0012w000004oZXgAAM",
  "workTypeId": "08q2w000000XmniAAC",
  "serviceTerritoryId": "0Hh2w000000XmoXCAS",
  "engagementChannelTypeId": "0eFRM00000000Bv2AI",
  "schedStartTime": "2020-02-26T15:00:00.000Z",
  "schedEndTime": "2020-02-26T16:00:00.000Z",
  "street": "1 Market Street",
  "city": "San Francisco",
  "state": "CA",
  "postalCode": "94105",
  "country": "USA",
  "appointmentType": "In Person",
  "appointmentMode": "Group",
  "attendeeLimit": "20",
  "extendedFields": [
    {
      "name": "Email",
      "value": "rachel.adams@salesforce.com"
    },
    {
      "name": "Phone",
      "value": "111111111"
    },
    {
      "name": "Description",
      "value": "Test Description"
    }
  ]
},
"assignedResources": [
  {
    "serviceResourceId": "0Hn2w000000gDWDCA2",
    "isRequiredResource": true,
    "isPrimaryResource": true,
    "extendedFields": []
  },
  {
    "serviceResourceId": "0Hn2w000000gCqnCAE",
    "isRequiredResource": true,
    "isPrimaryResource": false,
    "extendedFields": []
  }
]
}
```

**JSON example for unauthenticated user:**
```json
{
"serviceAppointment": {
  "workTypeId": "08q2w000000XmniAAC",
  "serviceTerritoryId": "0Hh2w000000XmoXCAS",
  "engagementChannelTypeId": "0eFRM00000000Bv2AI",
  "schedStartTime": "2020-02-26T15:00:00.000Z",
  "schedEndTime": "2020-02-26T16:00:00.000Z",
  "street": "1 Market Street",
  "city": "San Francisco",
  "state": "CA",
  "postalCode": "94105",
  "country": "USA",
  "appointmentType": "In Person",
  "appointmentMode": "Group",
  "attendeeLimit": "20",
  "extendedFields": []
},
"assignedResources": [
  {
    "serviceResourceId": "0Hn2w000000gDWDCA2",
    "isRequiredResource": true,
    "isPrimaryResource": true,
    "extendedFields": []
  }
],
"lead": {
  "firstName": "Rachel",
  "lastName": "Adams",
  "phone": "012-345-6789",
  "email": "rachel.adams@salesforce.com",
  "company": "Salesforce",
  "extendedFields": []
}
}
```

**Properties:**

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `assignedResources` | Assigned Resource Input[] | Service resource who is assigned to a service appointment. **Note:** When creating an appointment, you can use extendedFields to add values to any of the fields, including custom fields, in assignedResources as long as you have edit access to those fields. | Optional | 48.0 |
| `lead` | Lead Input[] | Prospect or lead. **Note:** Required to create a service appointment with unauthenticated guest users. | Required if serviceAppointment isn't provided | 48.0 |
| `schedulingPolicyId` | String | ID of the AppointmentSchedulingPolicy object. If no scheduling policy is passed in the request body, the default configurations are used. The only scheduling policy configuration that is used in determining time slots is the enforcement of account visiting hours. | Optional | 48.0 |
| `serviceAppointment` | Service Appointment Input[] | Appointment to complete a service work for a customer. **Note:** When creating an appointment, you can use extendedFields to add values to any of the fields, including custom fields, in serviceAppointment as long as you have edit access to those fields. | Required if lead isn't provided | 48.0 |

### 1-8. Service Appointment Update Input

*Input representation for updating a service appointment. Use to update the scheduled times, assigned resource(s), service territory or even work type for existing appointments.*

**Limitations:**
You cannot use the resource to modify the following:
- Parent record ID (parentRecordId) and Service appointment ID (serviceAppointmentId)
- Canceled appointments.
- Past date appointments.
- lead details.
- When multi-resource scheduling is enabled, you can't add a new resource and make it as the primary resource in a single request. Add the new resource in one request and then make another request to add the resource as a primary resource.

**JSON example:**
```json
{
"serviceAppointmentId": "08pxx0000004C92AAE",
"serviceAppointment": {
  "workTypeId": "08pxx0000004C92AAE",
  "serviceTerritoryId": "0Hh2xx0000004CAeCAM",
  "engagementChannelTypeId": "0eFRM0000004CC22AM",
  "schedStartTime": "2020-09-15T16:00:00+0000",
  "schedEndTime": "2020-09-15T17:00:00+0000",
  "street": "1 Market Street",
  "city": "San Francisco",
  "state": "CA",
  "postalCode": "94105",
  "country": "USA",
  "appointmentType": "In Person",
  "appointmentMode": "Group",
  "attendeeLimit": "20",
  "extendedFields": [
    {
      "name": "Email",
      "value": "rachel.adams@salesforce.com"
    },
    {
      "name": "Phone",
      "value": "111111111"
    },
    {
      "name": "Description",
      "value": "Test Description"
    }
  ],
"assignedResources": [
  {
    "serviceResourceId": "0Hnxx0000004CAeCAM",
    "isRequiredResource": true,
    "isPrimaryResource": false,
    "extendedFields": []
  },
]
}
```
> [sic] 원문 JSON — `extendedFields` 배열이 닫히고 `assignedResources`가 `serviceAppointment` 객체 내부에 중첩된 형태로 표기됨(들여쓰기·닫는 괄호 원문 그대로).

**Request example to update the scheduled time:**
> **Note:** The API updates the equivalent Salesforce calendar events and block times when the scheduled time is updated.
```json
{
"serviceAppointmentId": "08pxx0000004C92AAE",
"serviceAppointment": {
  "schedStartTime": "2020-09-15T16:00:00+0000",
  "schedEndTime": "2020-09-15T17:00:00+0000",
}
```

**Request example to update the work type:**
```json
{
"serviceAppointmentId": "08pxx0000004C92AAE",
"serviceAppointment": {
  "workTypeId": "08qxx0000004C92AAE",
}
```

**Request example to update the service territory:**
```json
{
"serviceAppointmentId": "08pxx0000004C92AAE",
"serviceAppointment": {
  "serviceTerritoryId": "0Hhxx0000004CAeCAM"
}
```
> [sic] 위 3개 짧은 예제는 원문에서 닫는 중괄호가 1개씩만 표기됨(원문 그대로 보존).

**Properties:**

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `assignedResources` | Assigned Resource Input[] | Service resource who is assigned to a service appointment. When updating an appointment, pass the complete list of resources needed. If you don't pass a resource that is assigned to a service appointment, the API deletes that assigned resource. For example, suppose that an existing service appointment has assigned resources: A and B and if you pass assigned resources: B and C. The API checks the resource availability of B and C for existing work type and service territory, and if both are available, the service appointment gets updated with: • Resource A—Deleted • Resource B—Updated • Resource C—Created. However, if you don't pass any of the assigned resources, the API assumes there is no change. **Note:** When updating an appointment, you can use extendedFields to add values to any of the fields, including custom fields, in assignedResources as long as you have edit access to those fields. | Optional | 51.0 |
| `schedulingPolicyId` | String | ID of the AppointmentSchedulingPolicy object. If no scheduling policy is passed in the request body, the default configurations are used. The only scheduling policy configuration that is used in determining time slots is the enforcement of account visiting hours. | Optional | 51.0 |
| `serviceAppointment` | Service Appointment Input[] | Appointment to complete a service work for a customer. When updating an appointment, pass only the fields that need to be updated. **Note:** When updating an appointment, you can use extendedFields to add values to any of the fields, including custom fields, in serviceAppointment as long as you have edit access to those fields. | Required | 51.0 |
| `serviceAppointmentId` | String | ID of the service appointment that you want to update. | Required | 51.0 |

### 1-9. Service Appointment Input

*Input representation of the service appointment details.*

**Root XML tag:** `<serviceAppointment>`

**JSON example:**
```json
{
"serviceAppointment": {
  "parentRecordId": "001RM000004PhDgYAK",
  "workTypeId": "08qRM0000004LyJYAU",
  "serviceTerritoryId": "0HhRM0000004MNd0AM",
  "schedStartTime": "2019-10-30T13:00:00.000Z",
  "schedEndTime": "2019-10-30T14:00:00.000Z",
  "street": "1 Market Street",
  "city": "San Francisco",
  "state": "CA",
  "postalCode": "94105",
  "country": "USA",
  "appointmentType": "In Person",
  "appointmentMode": "Group",
  "attendeeLimit": "20",
  "extendedFields": []
}
}
```

**Properties:**

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `additionalInformation` | String | Additional information about the service appointment. | Optional | 48.0 |
| `appointmentType` | String | Specifies the API name of the appointment type for the service appointment. | Optional | 48.0 |
| `appointmentMode` | String | Mode of the service appointment. Valid values are: • Group • Regular. The default value is Regular. | Optional | 60.0 |
| `attendeeLimit` | Integer | Maximum number of customers that's allowed to attend the service appointment. | Required if the appointment mode is Group. | 60.0 |
| `city` | String | City where the appointment is completed. | Optional | 48.0 |
| `comments` | String | Comments about the appointment. | Optional | 48.0 |
| `contactId` | String | Contact associated with the parent record. | Optional | 48.0 |
| `country` | String | Country where the appointment is completed. | Optional | 48.0 |
| `description` | String | Description of the appointment. | Optional | 48.0 |
| `engagementChannelTypeId` | String | ID of the engagement channel type to associate with the appointment. You can use engagement channel type only if: • Schedule Appointments Using Engagement Channels is enabled in Salesforce Scheduler Settings in your Salesforce org. • Shifts are defined in the scheduling policy. For more information on setting up shifts in the scheduling policy, see Define Shift Rules in Scheduling Policy. **Note:** Engagement channel types are not supported with operating hours rules in the scheduling policy. | Optional | 56.0 |
| `extendedFields` | Extended Fields Input[] | Custom fields. | Optional | 48.0 |
| `parentRecordId` | String | Parent record associated with the appointment. | Required | 48.0 |
| `postalCode` | String | Postal code where the appointment is completed. | Optional | 48.0 |
| `schedEndTime` | String | Time at which the appointment is scheduled to end. Ensure the scheduled start time and end time align with the available time slots. | Optional | 48.0 |
| `schedStartTime` | String | Time at which the appointment is scheduled to start. Ensure the scheduled start time and end time align with the available time slots. | Optional | 48.0 |
| `serviceTerritoryId` | String | Service territory associated with the appointment. | Optional | 48.0 |
| `state` | String | State where the service appointment is completed. | Optional | 48.0 |
| `street` | String | Street number and name where the service appointment is completed. | Optional | 48.0 |
| `subject` | String | Short phrase describing the appointment. | Optional | 48.0 |
| `workTypeId` | String | Work type associated with the service appointment. If specified, it is added to the service appointment record. | Optional | 48.0 |

### 1-10. Skill Requirement Input

*Skill requirement.*

(JSON 예제 없음 — Properties 표만)

**Properties:**

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `skillId` | String | ID of the skill required. | Required | 49.0 |
| `skillLevel` | Double | Level of the skill required. | Optional | 49.0 |

### 1-11. Waitlist Check In Input

*Input representation of the participant's waitlist check in request.*

**Root XML tag:** `<waitlistCheckIn>`

**JSON example:**
```json
{
"lead": {
  "firstName":"Tom",
  "lastName":"Scott",
  "phone":"012-345-6789",
  "email":"tom.scott@phoenix.com",
  "company":"Phoenix",
  "extendedFields":[]
},
"participantId":"00Q5h00000JdQWzEAN",
"waitlistId": "0D3B0000000S2SeNOP",
"workTypeId":"08q5h000000UuEcAAK",
"workTypeGroupId" : "0VSRM0000004MBk4AM",
"serviceResourceId":"0Hn0000000S2SeNOP",
"description": "Registration for a drop-in appointment.",
"extendedFields":[
  {
    "name":"Source__c",
    "value":"Email"
  }
]
}
```

**Properties:** (pdftoppm 셀검증 완료)

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `description` | String | Description of the participant. | Optional | 59.0 |
| `extendedFields` | Extended Field Input[] [sic] | Details of the extended custom fields. | Optional | 59.0 |
| `lead` | Lead Input | Details of the prospect or lead. | Required if the participantId parameter isn't specified. | 59.0 |
| `participantId` | String | ID of the participant with an appointment. The participant can be an account, a contact, or a lead. | Required if the lead parameter isn't specified. | 59.0 |
| `serviceResourceId` | String | ID of the service resource. | Optional | 59.0 |
| `waitlistId` | String | ID of the waitlist that the participant is checked in. | Required | 59.0 |
| `workTypeGroupId` | String | ID of the work type group. | Required if the workTypeId parameter isn't specified. | 59.0 |
| `workTypeId` | String | ID of the work type that represents the topic for the appointment. | Required if the workTypeGroupId parameter isn't specified. | 59.0 |

> [sic] Type 컬럼 주의: `lead`의 Type은 `Lead Input`(단수, 배열 아님). `extendedFields`는 `Extended Field Input[]`("Field" 단수형 — Request Bodies의 다른 곳 "Extended Fields Input"과 표기가 다름, 원문 그대로).

### 1-12. Waitlist Participants Input

*Input representation to move a waitlist participant to a specific position in a waitlist.*

**Root XML tag:** `<updateWaitlistParticipant>`

**JSON example:**
```json
{
"waitlistParticipantId": "12oRM0000004FGiYAM",
"targetPosition": 3
}
```

**Properties:** (pdftoppm 셀검증 — 정확히 2행)

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `targetPosition` | Integer | Position in the waitlist to move the participant to. A value of 1 moves the participant to the top, and -1 moves the participant to the bottom. In API version 65.0 and later, a positive integer n moves the participant to the nth position; if n exceeds the number of participants in the waitlist, the participant moves to the bottom. | Required | 62.0 |
| `waitlistParticipantId` | String | ID of the waitlist participant record to move. The participant's Status must be Unassigned. | Required | 62.0 |

### 1-13. Work Type Input

*Work type.*

**JSON example:**
```json
{
"id" : "08qRM00000003fkYAA"
}
```

**Properties:** (pdftoppm 셀검증 — 9행)

| Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| `blockTimeAfterAppointmentInMinutes` | Integer | Period after the appointment that is typically blocked for this work type. | Optional | 49.0 |
| `blockTimeBeforeAppointmentInMinutes` | Integer | Period before the appointment that is typically blocked for this work type. | Optional | 49.0 |
| `durationInMinutes` | Integer | Duration of the appointment in minutes. | Required if id isn't provided | 49.0 |
| `id` | String | ID of the work type. | Required if durationInMinutes isn't provided | 49.0 |
| `operatingHoursId` | String | ID of the operating hours. | Optional | 49.0 |
| `operatingHoursTimeZone` | String | Time zone for the operating hours. | Optional | 49.0 |
| `skillRequirements` | Skill Requirement Input[] | List of skills required to complete the tasks associated with this work type. | Optional | 49.0 |
| `timeFrameEndInMinutes` | Integer | Ending of the appointment in minutes. | Optional | 49.0 |
| `timeFrameStartInMinutes` | Integer | Beginning of the appointment in minutes. | Optional | 49.0 |

---

## PART 2 — Connect REST API Response Bodies (28종)

> Response 표 공통 컬럼: `Property Name | Type | Description | Filter Group and Version | Available Version`. 응답 바디 섹션 인덱스는 28개 representation을 나열하며, 아래는 Properties/JSON 상세를 보유한 전 28종이다.

### 2-1. Available Territory Slots

*Slot's start and end time and available resources in the specified territory.*

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `endTime` | String | End time of the appointment. **Note:** The API returns time slots up to 31 days from the startTime. | Small, 49.0 | 49.0 |
| `engagementChannelTypeIds` | String[] | List of IDs of the engagement channel types for the service resource. | Small, 56.0 | 56.0 |
| `resources` | String[] | List of resources available in the specified territory. | Small, 49.0 | 49.0 |
| `startTime` | String | Start time of the appointment. | Small, 49.0 | 49.0 |

### 2-2. Available Territory Slots List

*Available territory slots.*

**Properties:** (pdftoppm 셀검증 — 단일 행. `territorySlots / Available Territory Slots[]` collapse는 Type이 2줄로 렌더된 한 행임이 확정됨)

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `territorySlots` | Available Territory Slots[] | List of appointment territory slots. | Small, 49.0 | 49.0 |

### 2-3. Available Territory Slots Output

*Available territory slots result.*

**Response example:**
```json
{
"result": {
    "territorySlots": [
      {
        "territoryId": "0HhB0000000TO9WKAW",
        "slots": [
          {
            "endTime": "2019-01-23T19:15:00.000+0000",
            "resources": [
              "0HnB0000000D2DsKAK",
              "0HnB0000000D2DsJKL"
            ],
            "startTime": "2019-01-23T16:15:00.000+0000"
          },
          {
            "endTime": "2019-01-23T19:30:00.000+0000",
            "resources": [
              "0HnB0000000D2DsKAK",
              "0HnB0000000D2DsJKL"
            ],
            "startTime": "2019-01-23T16:30:00.000+0000"
          }
        ]
      },
      {
        "territoryId": "0HhB0000000TO9WERT",
        "slots": [
          {
            "endTime": "2019-01-23T19:15:00.000+0000",
            "resources": [
              "0HnB0000000D2DsKAK"
            ],
            "startTime": "2019-01-23T16:15:00.000+0000"
          },
          {
            "endTime": "2019-01-23T19:30:00.000+0000",
            "resources": [
              "0HnB0000000D2DsKAK",
              "0HnB0000000D2DsJKL"
            ],
            "startTime": "2019-01-23T16:30:00.000+0000"
          }
        ]
      }
  ]
}
}
```

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `result` | Available Territory Slots List | All available time slots and resources available for that time slot across each territory. | Small, 49.0 | 49.0 |

### 2-4. Estimated Wait Time

*Output representation of the estimated wait time for a waitlist or waitlist participant.*

**JSON example:**
```json
{
"waitlistId": "11wfi700000262vAAA",
"waitlistParticipantEstimatedWaitTime": "",
"waitlistParticipantId": "",
"workTypeGroups": [
    {
        "workTypeGroupEstimatedWaitTime": "Unavailable",
        "workTypeGroupId": "0VSfi70000008yTGAQ"
    }
]
}
```

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `waitlistId` | String | ID of the waitlist. | Small, 65.0 | 65.0 |
| `waitlistParticipantEstimatedWaitTime` | String | Estimated wait time for the waitlist participant. Empty when the request specifies only waitlistId. | Small, 65.0 | 65.0 |
| `waitlistParticipantId` | String | ID of the waitlist participant. Empty when the request specifies only waitlistId. | Small, 65.0 | 65.0 |
| `workTypeGroups` | Work Type Group Estimated Wait Time Info[] | Estimated wait times for the work type groups associated with the waitlist. | Small, 65.0 | 65.0 |

### 2-5. Engagement Channel Type List Result

*Output representation of the engagement channel type result.*

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `engagementChannelTypes` | Get Engagement Channel Type Result[] | Engagement channel type details. | Small, 56.0 | 56.0 |

### 2-6. Engagement Channel Type Result

*Output representation of the details of the engagement channel type.*

**Properties:** (pdftoppm 셀검증)

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `contactPoint` | String | The contact point for the engagement channel type. | Small, 56.0 | 56.0 |
| `contactPointType` | String | The contact point type for the engagement channel type. Possible values are: • InPerson • None • Phone—Available in API version 57.0 and later. • Video—Available in API version 57.0 and later. | Small, 56.0 | 56.0 |
| `id` | String | The ID of the engagement channel type record. | Small, 56.0 | 56.0 |
| `name` | String | The name of the engagement channel type. | Small, 56.0 | 56.0 |
| `workTypeGroupIds` | String[] | The work type group IDs for the engagement channel type. **Note:** When workTypeID is specified in the API request, this property is unspecified. | Small, 56.0 | 56.0 |
| `workTypeIds` | String[] | The work type Ids for the engagement channel type. **Note:** When workTypeGroupID is specified in the API request, this property is unspecified. | Small, 56.0 | 56.0 |

### 2-7. Engagement Channel Type Output

*Output representation of the list of the engagement channel types.*

**JSON Example:**
```json
{
"result": {
  "engagementChannelTypes": [
    {
      "id": "0eFRM0000004CBs2AM",
      "name": "Inperson-2",
      "workTypeGroupIds": [
        "0VSRM0000000BgX4AU"
      ],
      "workTypeIds": []
    },
    {
      "contactPointType": "InPerson",
      "id": "0eFRM00000000BL2AY",
      "name": "A Channel",
      "workTypeGroupIds": [
        "0VSRM0000000BgX4AU"
      ],
      "workTypeIds": []
    },
    {
      "contactPointType": "InPerson",
      "id": "0eFRM00000000Bk2AI",
      "name": "Test",
      "workTypeGroupIds": [
        "0VSRM0000000BgX4AU"
      ],
      "workTypeIds": []
    }
  ]
}
}
```

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `result` | Get Engagement Channel Type List Result | List that contains the engagement channel types. | Small, 56.0 | 56.0 |

### 2-8. Extended Fields

*Output representation of the extended fields for Salesforce Scheduler.*

**JSON example:**
```json
"extendedFields":[
 {
  "name":"Source__c",
  "value":"Email"
 }
]
```
> [sic] 원문 JSON 단편 — 여는 중괄호 없이 `"extendedFields":[` 부터 시작.

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `name` | String | Name of the extended field. | Small, 59.0 | 59.0 |
| `value` | String | Value of the extended field. | Small, 59.0 | 59.0 |

### 2-9. Group Appointments

*Output representation of the response that contains the retrieved group appointments.*

**Sample Response:**
```json
{
"groupAppointments": [
  {
    "appointmentId": "08pxx0000004HlQAAU",
    "attendeeCount": 10,
    "attendeeLimit": 25,
    "parentRecordId": "001B000000qAUAWIA4",
    "endTime": "2024-01-21T19:15:00.000+0000",
    "resourceIds": [
      "0HnB0000000TO8gKAK"
    ],
    "startTime": "2024-01-21T16:15:00.000+0000",
    "territoryId": "0HhB0000000TO9WKAW",
    "engagementChannelTypeId": "0eFRM00000000Bv2AI",
    "workTypeId": "08qRM00000003fkYAA",
    "extendedFields": [
      {
        "name": "subject",
        "value": "MSc Internship - Resume workshop"
      },
      {
        "name": "description",
        "value": "Resume workshop for MSc Internship for Section 4"
      }
    ]
  },
  {
    "appointmentId": "08pxx0000003HpQAAU",
    "attendeeCount": 0,
    "attendeeLimit": 15,
    "parentRecordId": "001B000000qAUAWIA4",
    "endTime": "2019-01-21T19:30:00.000+0000",
    "resourceIds": [
      "0HnB0000000TO8gKAK"
    ],
    "startTime": "2019-01-21T16:30:00.000+0000",
    "territoryId": "0HhB0000000TO9WKAW",
    "engagementChannelTypeId": "0eFRM00000000Bv2AI",
    "workTypeId": "08qRM00000003fkYAA",
    "extendedFields": [
      {
        "name": "subject",
        "value": "MSc Internship - Resume workshop"
      },
      {
        "name": "description",
        "value": "Resume workshop for MSc Internship for Section 5"
      }
    ]
  },
  {
    "appointmentId": "08pxx0000009AsQAAU",
    "attendeeCount": 20,
    "attendeeLimit": 20,
    "parentRecordId": "001B000000qAUAWIA4",
    "endTime": "2019-01-21T19:45:00.000+0000",
    "resourceIds": [
      "0HnB0000000TO8gKAK"
    ],
    "startTime": "2019-01-21T16:45:00.000+0000",
    "territoryId": "0HhB0000000TO9WKAW",
    "engagementChannelTypeId": "0eFRM00000000Bv2AI",
    "workTypeId": "08qRM00000003fkYAA",
    "extendedFields": [
      {
        "name": "subject",
        "value": "MSc Internship - Resume workshop"
      },
      {
        "name": "description",
        "value": "Resume workshop for MSc Internship for Section 3"
      }
    ]
  }
]
}
```

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `result` | Group Appointments List Result | List of result objects for the retrieved group appointments. | Small, 61.0 | 61.0 |

### 2-10. Group Appointments List Result

*Output representation of the list of group appointments.*

**Sample Response:** (위 Group Appointments와 동일한 `groupAppointments` 배열 — appointmentId `08pxx0000004HlQAAU`/`08pxx0000003HpQAAU`/`08pxx0000009AsQAAU`, 동일 필드 구성. 원문 verbatim)
```json
{
"groupAppointments": [
  {
    "appointmentId": "08pxx0000004HlQAAU",
    "attendeeCount": 10,
    "attendeeLimit": 25,
    "parentRecordId": "001B000000qAUAWIA4",
    "endTime": "2024-01-21T19:15:00.000+0000",
    "resourceIds": [ "0HnB0000000TO8gKAK" ],
    "startTime": "2024-01-21T16:15:00.000+0000",
    "territoryId": "0HhB0000000TO9WKAW",
    "engagementChannelTypeId": "0eFRM00000000Bv2AI",
    "workTypeId": "08qRM00000003fkYAA",
    "extendedFields": [
      { "name": "subject", "value": "MSc Internship - Resume workshop" },
      { "name": "description", "value": "Resume workshop for MSc Internship for Section 4" }
    ]
  },
  {
    "appointmentId": "08pxx0000003HpQAAU",
    "attendeeCount": 0,
    "attendeeLimit": 15,
    "parentRecordId": "001B000000qAUAWIA4",
    "endTime": "2019-01-21T19:30:00.000+0000",
    "resourceIds": [ "0HnB0000000TO8gKAK" ],
    "startTime": "2019-01-21T16:30:00.000+0000",
    "territoryId": "0HhB0000000TO9WKAW",
    "engagementChannelTypeId": "0eFRM00000000Bv2AI",
    "workTypeId": "08qRM00000003fkYAA",
    "extendedFields": [
      { "name": "subject", "value": "MSc Internship - Resume workshop" },
      { "name": "description", "value": "Resume workshop for MSc Internship for Section 5" }
    ]
  },
  {
    "appointmentId": "08pxx0000009AsQAAU",
    "attendeeCount": 20,
    "attendeeLimit": 20,
    "parentRecordId": "001B000000qAUAWIA4",
    "endTime": "2019-01-21T19:45:00.000+0000",
    "resourceIds": [ "0HnB0000000TO8gKAK" ],
    "startTime": "2019-01-21T16:45:00.000+0000",
    "territoryId": "0HhB0000000TO9WKAW",
    "engagementChannelTypeId": "0eFRM00000000Bv2AI",
    "workTypeId": "08qRM00000003fkYAA",
    "extendedFields": [
      { "name": "subject", "value": "MSc Internship - Resume workshop" },
      { "name": "description", "value": "Resume workshop for MSc Internship for Section 3" }
    ]
  }
]
}
```

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `groupAppointments` | Group Appointment Result[] | List of group appointments in each territory. | Small, 61.0 | 61.0 |

### 2-11. Group Appointment Result

*Output representation that contains the details of a specific group appointment.*

**Sample Response:**
```json
{
    "groupAppointments": [
        {
            "appointmentId": "08pxx0000004HlQAAU",
            "attendeeCount": 10,
            "attendeeLimit": 25,
            "parentRecordId": "001B000000qAUAWIA4",
            "endTime": "2024-01-21T19:15:00.000+0000",
            "startTime": "2024-01-21T16:15:00.000+0000",
            "resource": {
                "id" : "0HnB0000000TO8gKAK",
                "name" : "Best Resource"
            },
            "territoryId": "0HhB0000000TO9WKAW",
            "engagementChannelTypeId": "0eFRM00000000Bv2AI",
            "workTypeId": "08qRM00000003fkYAA",
            "appointmentChannel": {
                "engagementChannelTypeId" : "0eFRM00000000Bv2AI" ,
                "engagementChannelTypeName" : "Video"
            },
            "workTypeGroup" : {
                "name" : "Wealth Management",
                "id" : "0eFRM00000000Bv2AI"
            },
            "extendedFields": [
                { "name": "subject",
                "value": "MSc Interniship - Resume workshop" },
                { "name": "description",
                "value": "Resume workshop for MSc Interniship for Section 4" }
            ]
        },
        {
            "appointmentId": "08pxx0000003HpQAAU",
            "attendeeCount": 0,
            "attendeeLimit": 15,
            "parentRecordId": "001B000000qAUAWIA4",
            "endTime": "2019-01-21T19:30:00.000+0000",
            "startTime": "2024-01-21T16:15:00.000+0000",
            "resource": {
                "id" : "0HnB0000000TO8gKAK",
                "name" : "Best Resource"
            },
            "startTime": "2019-01-21T16:30:00.000+0000",
            "territoryId": "0HhB0000000TO9WKAW",
            "engagementChannelTypeId": "0eFRM00000000Bv2AI",
            "workTypeId": "08qRM00000003fkYAA",
            "appointmentChannel": {
                "engagementChannelTypeId" : "0eFRM00000000Bv2AI",
                "engagementChannelTypeName" : "Video"
            },
            "workTypeGroup" : {
                "name" : "Wealth Management",
                "id" : "0eFRM00000000Bv2AI"
            },
            "extendedFields": [
                { "name": "subject",
                "value": "MSc Interniship - Resume workshop" },
                { "name": "description",
                "value": "Resume workshop for MSc Interniship for Section 5" }
            ]
        },
        {
            "appointmentId": "08pxx0000009AsQAAU",
            "attendeeCount": 20,
            "attendeeLimit": 20,
            "parentRecordId": "001B000000qAUAWIA4",
            "endTime": "2019-01-21T19:45:00.000+0000",
            "startTime": "2024-01-21T16:15:00.000+0000",
            "resource": {
                "id" : "0HnB0000000TO8gKAK",
                "name" : "Best Resource"
            },
            "startTime": "2019-01-21T16:45:00.000+0000",
            "territoryId": "0HhB0000000TO9WKAW",
            "engagementChannelTypeId": "0eFRM00000000Bv2AI",
            "workTypeId": "08qRM00000003fkYAA",
            "appointmentChannel": {
                "engagementChannelTypeId" : "0eFRM00000000Bv2AI",
                "engagementChannelTypeName" : "Video"
            },
            "workTypeGroup" : {
                "name" : "Wealth Management",
                "id" : "0eFRM00000000Bv2AI"
            },
            "extendedFields": [
                { "name": "subject",
                "value": "MSc Interniship - Resume workshop" },
                { "name": "description",
                "value": "Resume workshop for MSc Interniship for Section 3" }
            ]
        }
    ]
}
```
> [sic] 원문에 `startTime`이 각 객체 내 2회 중복 표기됨, `Interniship` 오타 원문 그대로.

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `appointmentId` | String | ID of the group appointment. | Small, 61.0 | 61.0 |
| `attendeeCount` | Integer | Number of attendees who are already associated with the appointment. | Small, 61.0 | 61.0 |
| `attendeeLimit` | Integer | Maximum attendee limit that's allowed for the appointment. | Small, 61.0 | 61.0 |
| `appointmentChannel` | Object | The appointment type, engagement channel type ID, and engagement Channel type name associated with the appointment, based on preferences. | Small, 61.0 | 61.0 |
| `endTime` | String | End time of the appointment. | Small, 61.0 | 61.0 |
| `engagementChannelTypeId` | String | ID of the engagement channel type record. | Small, 61.0 | 61.0 |
| `extendedFields` | Scheduler Extended Fields[] | Details of the extended custom fields. | Small, 61.0 | 61.0 |
| `parentRecordId` | String | ID of the associated parent record. | Small, 61.0 | 61.0 |
| `resourceIds` | String[] | Service resource IDs that are associated with the appointment. | Small, 61.0 | 61.0 |
| `startTime` | String | Start time of the appointment. | Small, 61.0 | 61.0 |
| `territoryId` | String | ID of the service territory that's associated with the appointment. | Small, 61.0 | 61.0 |
| `workTypeGroup` | Object | ID and name of the work type group associated with the work type of the appointment. | Small, 61.0 | 61.0 |
| `workTypeId` | String | ID of the work type for the appointment. | Small, 61.0 | 61.0 |

### 2-12. Service Appointment Output

*Output of the service appointment POST method.*

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `result` | Service Appointment Result | Result of the POST method. | Small, 48.0 | 48.0 |

### 2-13. Service Appointment Result

*Result of the POST method.*

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `assignedResourceIds` | String[] | IDs of the assigned resources | Small, 48.0 | 48.0 |
| `parentRecordId` | String | ID of the parent record. | Small, 48.0 | 48.0 |
| `serviceAppointmentId` | String | ID of the service appointment created. | Small, 48.0 | 48.0 |

### 2-14. Service Territories Output

*Output for the service territories GET method.*

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `result` | Service Territories List Result | Result for the GET method. | Small, 48.0 | 48.0 |

### 2-15. Service Territories List Result

*List of service territories returned as per the query in the GET service territories call.*

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `serviceTerritories` | Service Territories Result[] | List of service territories. | Small, 48.0 | 48.0 |

### 2-16. Service Territories Result

*Represents a service territory result.*

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `city` | String | Service territory city. | Small, 48.0 | 48.0 |
| `country` | String | Service territory country. | Small, 48.0 | 48.0 |
| `id` | String | ID of the service territory. | Small, 48.0 | 48.0 |
| `latitude` | Double | Latitude of the service territory. | Small, 48.0 | 48.0 |
| `longitude` | Double | Longitude of the service territory. | Small, 48.0 | 48.0 |
| `name` | String | Name of the service territory. | Small, 48.0 | 48.0 |
| `operatingHoursId` | String | ID of the service territory operatingHours record. | Small, 48.0 | 48.0 |
| `postalCode` | String | Service territory postal code. | Small, 48.0 | 48.0 |
| `state` | String | Service territory state. | Small, 48.0 | 48.0 |
| `street` | String | Service territory street. | Small, 48.0 | 48.0 |

### 2-17. Waitlist Analytics

*Output representation of the waitlist analytics.*

**JSON example:**
```json
"waitlistAnalytics":{
  "currentParticipant": 1,
  "totalWaitingTime": 40,
  "avgWaitingTime": 20,
  "avgParticipants": 24
}
```
> [sic] 원문 단편 — 여는 중괄호 없이 `"waitlistAnalytics":{` 부터 시작.

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `avgParticipants` | Integer | Count of average participants per day. | Small, 59.0 | 59.0 |
| `avgWaitingTime` | Integer | Average waiting time in minutes. | Small, 59.0 | 59.0 |
| `currentParticipant` | Integer | Number of current participants in the waitlist. | Small, 59.0 | 59.0 |
| `totalWaitingTime` | Integer | Total waiting time in minutes. | Small, 59.0 | 59.0 |

### 2-18. Waitlist Check In

*Output representation of the waitlist check in request.*

**JSON example:**
```json
{
"result" : {
    "participantId" : "00Q5h00000JdQWzEAN",
    "serviceAppointmentId" : "08pxx0000004CYqAAM",
    "waitlistParticipantId" : "12oxx0000004FGiAAM"
}
}
```

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `result` | Waitlist Check In Result | Result of the waitlist check in request. | Small, 59.0 | 59.0 |

### 2-19. Waitlist Check In Result

*Output representation of the waitlist check in result.*

**JSON example:**
```json
{
"result" : {
    "participantId" : "00Q5h00000JdQWzEAN",
    "serviceAppointmentId" : "08pxx0000004CYqAAM",
    "waitlistParticipantId" : "12oxx0000004FGiAAM"
}
}
```

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `participantId` | String | ID of the participant who has an appointment. | Small, 59.0 | 59.0 |
| `serviceAppointmentId` | String | ID of the service appointment. | Small, 59.0 | 59.0 |
| `waitlistParticipantId` | String | ID of the waitlist participant. | Small, 59.0 | 59.0 |

### 2-20. Waitlist Details

*Output representation of the waitlist details.*

**JSON example:**
```json
{
            "description":"None",
            "isActive":true,
            "name":"Queue_1",
            "serviceResources":[
                {
                    "id": "0Hnxx0000004C92CAE",
                    "name":"Admin"
                },
                {
                    "id": "0Hnxx0000004CFVCA2",
                    "name":"Standard User 2 Technician"
                }
            ],
            "waitlistAnalytics":{
                "currentParticipant":1,
                "totalWaitingTime":40,
                "avgWaitingTime":20,
                "avgParticipants":24
        },
        "waitlistId":"11wxx0000005GTHAA2",
        "waitlistParticipants":[
            {
                "participant":{
                    "id":"001xx000003GZUZAA4",
                    "name":"Global Media"
                },
                "participantIdentifier":"WP-0020",
                "serviceAppointmentId":"08pxx0000004CYqAAM",
                "serviceResource":{
                    "id":"0Hnxx0000004C92CAE",
                    "name":"Admin"
                },
                "waitlistParticipantId":"12oxx0000004FGiAAM",
                "workTypeGroup":{
                    "id":"0VSxx0000004CoyGAE",
                    "name":"General Banking WTG"
                },
                "createdDate" :"2023-05-02T12:23:34",
                "extendedFields":[
                    {
                        "name":"Source__c",
                        "value":"Email"
                    }
                ]
            }
        ],
        "workTypeGroups":[
            {
                "id":"0VSxx0000004CoyGAE",
                "name":"General Banking WTG"
            }
        ]
}
```

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `description` | String | Description of the waitlist. | Small, 59.0 | 59.0 |
| `isActive` | Boolean | Indicates whether the waitlist is available to add drop-in customers (true) or not (false). | Small, 59.0 | 59.0 |
| `name` | String | Name of the waitlist. | Small, 59.0 | 59.0 |
| `serviceResources` | Waitlist Service Resource[] | Details of the service resources that are related to the service appointment. | Small, 59.0 | 59.0 |
| `waitlistAnalytics` | Waitlist Analytics | Details of the waitlist analytics. | Small, 59.0 | 59.0 |
| `waitlistId` | String | ID of the waitlist. | Small, 59.0 | 59.0 |
| `waitlistParticipants` | Waitlist Participant Result[] | Participants who are added to the waitlist. | Small, 59.0 | 59.0 |
| `workTypeGroups` | Waitlist Work Type Group[] | Details of the work type groups that are related to the service appointment. | Small, 59.0 | 59.0 |

### 2-21. Waitlist List Result

*Output representation of the result of the list of waitlists.*

**JSON example:**
```json
"waitlists":[
    {
        "description":"None",
        "isActive":true,
        "name":"Queue_1",
        "serviceResources":[
            {
                "id": "0Hnxx0000004C92CAE",
                "name":"Admin"
            },
            {
                "id": "0Hnxx0000004CFVCA2",
                "name":"Standard User 2 Technician"
            }
        ],
        "waitlistAnalytics":{
            "currentParticipant":1,
            "totalWaitingTime":40,
            "avgWaitingTime":20,
            "avgParticipants":24
        },
        "waitlistId":"11wxx0000005GTHAA2",
        "waitlistParticipants":[
            {
                "participant":{
                    "id":"001xx000003GZUZAA4",
                    "name":"Global Media"
                },
                "participantIdentifier":"WP-0020",
                "serviceAppointmentId":"08pxx0000004CYqAAM",
                "serviceResource":{
                    "id":"0Hnxx0000004C92CAE",
                    "name":"Admin"
                },
                "waitlistParticipantId":"12oxx0000004FGiAAM",
                "workTypeGroup":{
                    "id":"0VSxx0000004CoyGAE",
                    "name":"General Banking WTG"
                },
                "createdDate" :"2023-05-02T12:23:34",
                "extendedFields":[
                    {
                        "name":"Source__c",
                        "value":"Email"
                    }
                ]
            }
        ],
        "workTypeGroups":[
            {
                "id":"0VSxx0000004CoyGAE",
                "name":"General Banking WTG"
            }
        ]
    }
]
```
> [sic] 원문 단편 — 여는 중괄호 없이 `"waitlists":[` 부터 시작.

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `waitlists` | Waitlist Details[] | List of waitlists that are associated with a service appointment. | Small, 59.0 | 59.0 |

### 2-22. Waitlist Participant Details

*Output representation of the waitlist participant details.*

**JSON example:**
```json
"participant":{
   "id":"001xx000003GZUZAA4",
   "name":"Global Media"
}
```
> [sic] 원문 단편 — 여는 중괄호 없이 `"participant":{` 부터 시작.

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `id` | String | ID of the waitlist participant. | Small, 59.0 | 59.0 |
| `name` | String | Name of the waitlist participant. | Small, 59.0 | 59.0 |

### 2-23. Waitlist Participant Result

*Output representation of a waitlist participant result. A waitlist participant is a customer who is added to a waitlist.*

**JSON example:**
```json
"waitlistParticipants":[
{
  "participant":{
   "id":"001xx000003GZUZAA4",
   "name":"Global Media"
 },
  "participantIdentifier":"WP-0020",
  "serviceAppointmentId":"08pxx0000004CYqAAM",
      "serviceResource":{
         "id":"0Hnxx0000004C92CAE",
         "name":"Admin"
       },
  "waitlistParticipantId":"12oxx0000004FGiAAM",
  "workTypeGroup":{
       "id":"0VSxx0000004CoyGAE",
       "name":"General Banking WTG"
   },
  "createdDate" :"2023-05-02T12:23:34",
  "extendedFields":[
       {
         "name":"Source__c",
         "value":"Email"
        }
  ]
}
]
```
> [sic] 원문 단편 — 여는 중괄호 없이 `"waitlistParticipants":[` 부터 시작.

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `createdDate` | String | Date when the waitlist participant record was created. | Small, 59.0 | 59.0 |
| `extendedFields` | Extended Fields[] | List of extended fields associated with the waitlist participant record. | **Big, 59.0** | 59.0 |
| `participant` | Waitlist Participant Details | Details of the participant from the waitlist participant record. | Small, 59.0 | **58.0** |
| `participantIdentifier` | String | Alphanumeric unique identifier of the participant in a waitlist. For example, D101, E63, or A5015. | Small, 59.0 | 59.0 |
| `serviceAppointmentId` | String | ID of the service appointment that's related to the waitlist participant. | Small, 59.0 | 59.0 |
| `serviceResource` | Waitlist Service Resource | Details of the service resource that's related to the service appointment for the waitlist participant. | Small, 59.0 | 59.0 |
| `waitlistParticipantId` | String | ID of the waitlist participant record. | Small, 59.0 | 59.0 |
| `workTypeGroup` | Waitlist Work Type Group | Details of the work type group that's associated with the service appointment. | Small, 59.0 | 59.0 |

> 이상치(원문 그대로): `extendedFields`의 Filter Group은 다른 행과 달리 **`Big, 59.0`**(다른 행은 `Small`). `participant`의 Available Version은 **58.0**(행 대부분은 59.0). 압축/일괄변경 금지.

### 2-24. Waitlist Participants Update

*Output representation of a waitlist participant move response.*

**JSON example:**
```json
{
"message": "Participant successfully moved to first in the Main Lobby waitlist.",
"status": "success",
"waitlistParticipantId": "12oRM0000004FGiYAM"
}
```

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `message` | String | Human-readable description of the result. Display this value to end users rather than branching on it. On success, the value matches one of these templates, depending on the value of targetPosition: `Participant successfully moved to first in the {WaitlistName} waitlist.` for 1, or `Participant successfully moved to last in the {WaitlistName} waitlist.` for -1. In API version 65.0 and later, a positive integer other than 1 returns `Participant successfully repositioned in the {WaitlistName} waitlist.` | Small, 62.0 | 62.0 |
| `status` | String | Result of the request. The value is success on an HTTP 200 response. Use this property to branch programmatically. | Small, 62.0 | 62.0 |
| `waitlistParticipantId` | String | ID of the waitlist participant record that was moved. | Small, 62.0 | 62.0 |

> **표 하단 Note (원문):** "The response doesn't include the participant's new position or the updated waitlist ordering. To read the new order, call `GET /connect/scheduling/waitlists` and use the array order of waitlistParticipants as the position."

### 2-25. Waitlist Result

*Output representation of the waitlist result.*

**JSON example:**
```json
{
      "result":{
          "waitlists":[
              {
                  "description":"None",
                  "isActive":true,
                  "name":"Queue_1",
                  "serviceResources":[
                      {
                          "id": "0Hnxx0000004C92CAE",
                          "name":"Admin"
                      },
                      {
                          "id": "0Hnxx0000004CFVCA2",
                          "name":"Standard User 2 Technician"
                      }
                  ],
                  "waitlistAnalytics":{
                      "currentParticipant":1,
                      "totalWaitingTime":40,
                      "avgWaitingTime":20,
                      "avgParticipants":24
                  },
                  "waitlistId":"11wxx0000005GTHAA2",
                  "waitlistParticipants":[
                      {
                          "participant":{
                              "id":"001xx000003GZUZAA4",
                              "name":"Global Media"
                          },
                          "participantIdentifier":"WP-0020",
                          "serviceAppointmentId":"08pxx0000004CYqAAM",
                          "serviceResource":{
                              "id":"0Hnxx0000004C92CAE",
                              "name":"Admin"
                          },
                          "waitlistParticipantId":"12oxx0000004FGiAAM",
                          "workTypeGroup":{
                              "id":"0VSxx0000004CoyGAE",
                              "name":"General Banking WTG"
                          },
                          "createdDate" :"2023-05-02T12:23:34",
                          "extendedFields":[
                              {
                                  "name":"Source__c",
                                  "value":"Email"
                              }
                          ]
                      }
                  ],
                  "workTypeGroups":[
                      {
                          "id":"0VSxx0000004CoyGAE",
                          "name":"General Banking WTG"
                      }
                  ]
            }
      ]
}
}
```

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `result` | Waitlist List Result | Details of the waitlist, including the list of participants and work type groups. | Small, 59.0 | 59.0 |

### 2-26. Waitlist Service Resource

*Output representation of the waitlist service resource. Service resources are individual users who can attend customer appointments.*

**JSON example:**
```json
"serviceResources":[
 {
  "id": "0Hnxx0000004C92CAE",
  "name":"Admin"
 },
 {
  "id": "0Hnxx0000004CFVCA2",
  "name":"Standard User 2 Technician"
 }
]
```
> [sic] 원문 단편 — 여는 중괄호 없이 `"serviceResources":[` 부터 시작.

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `id` | String | ID of the service resource. | Small, 59.0 | 59.0 |
| `name` | String | Name of the service resource. | Small, 59.0 | 59.0 |

### 2-27. Waitlist Work Type Group

*Output representation of the waitlist work type group. A work type group is a general appointment category or topic, such as a home loan or an investment.*

**JSON example:**
```json
"workTypeGroups":[
  {
    "id":"0VSxx0000004CoyGAE",
    "name":"General Banking WTG"
  }
]
```
> [sic] 원문 단편 — 여는 중괄호 없이 `"workTypeGroups":[` 부터 시작.

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `id` | String | ID of the work type group. | Small, 59.0 | 59.0 |
| `name` | String | Name of the work type group. | Small, 59.0 | 59.0 |

### 2-28. Work Type Group Estimated Wait Time Info

*Output representation of the estimated wait time for a specific work type group.*

**Properties:**

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| `workTypeGroupEstimatedWaitTime` | String | Estimated wait time for the work type group. | Small, 65.0 | 65.0 |
| `workTypeGroupId` | String | ID of the work type group. | Small, 65.0 | 65.0 |

---

## PART 3 — Error Codes and Responses

> 섹션 도입부 원문 — "When using the APIs in Salesforce Scheduler, you may encounter error codes and messages under certain conditions. For each Scheduler API, it lists the potential error codes, the associated error messages, and a description of what causes the error to occur. The following is a list of error code details within the Salesforce Scheduler platform."
>
> 각 표 머리 공통 문장 — "This table lists HTTP response code descriptions that are unique to this resource." Error 표 컬럼: `HTTP Response Code | Error Code | Description`.

### 3-1. Appointment Candidates (GET)

*Contains the error codes and error code messages related with the Salesforce Scheduler API for getAppointmentSlots (GET) resource.*

| HTTP Response Code | Error Code | Description |
|---|---|---|
| 400 | `MISSING_ARGUMENT` | Specify either a workTypeGroupId or WorkTypeId. |
| 400 | `MISSING_ARGUMENT` | Specify a serviceTerritoryId with either a workTypeGroupId or WorkTypeId. |
| 400 | `INVALID_INPUT` | This isn't a valid workTypeGroupId value. Specify a valid ID for the workTypeGroupId parameter. |
| 400 | `INVALID_INPUT` | This isn't a valid serviceTerritoryId value. Specify a valid ID for the territoryId parameter. |

### 3-2. Appointment Slots (GET)

*Contains the error codes and error code messages related with Salesforce Scheduler API for the getAppointmentSlots (GET) resource.*

| HTTP Response Code | Error Code | Description |
|---|---|---|
| 400 | `BAD_REQUEST` | Specify either a workTypeGroupId or a workTypeId and try again. |
| 400 | `BAD_REQUEST` | This isn't a valid durationInMinutes value. Specify a valid duration in minutes for the durationInMinutes parameter. |
| 400 | `BAD_REQUEST` | AppointmentTopicTimeSlot is not accessible for the current user. |
| 400 | `BAD_REQUEST` | Looks like you don't have access to {WorkTypeGroup} or {WorkType} object. Your Salesforce admin can help with that. |
| 400 | `BAD_REQUEST` | Looks like you don't have access to {ServiceTerritory} object. Your Salesforce admin can help with that. |
| 400 | `BAD_REQUEST` | Looks like you don't have access to {ServiceResource} object. Your Salesforce admin can help with that. |
| 400 | `BAD_REQUEST` | Remove the primaryResourceId from the requiredResourceIds list and try again. |
| 400 | `BAD_REQUEST` | Provide a valid primaryResourceId and try again. |
| 400 | `BAD_REQUEST` | The maximum number of required service resources is 5. Reduce the number of service resources in your request and try again. |
| 400 | `BAD_REQUEST` | Provide a resource ID in the requiredResourceIds field, and try again. |
| 400 | `BAD_REQUEST` | Specify a valid workType and try again. |
| 400 | `BAD_REQUEST` | Provide an end time that's after the start time, and try again. |
| 400 | `BAD_REQUEST` | This isn't a valid startTime or endTime value. Specify a valid date and time for the startTime or endTime parameter. |
| 400 | `BAD_REQUEST` | There is no active workTypeGroup. |

### 3-3. Available Territory Slots (POST)

*Contains the error codes and error code messages related with Salesforce Scheduler API for the available-territory-slots (POST) resource.*

| HTTP Response Code | Error Code | Description |
|---|---|---|
| 400 | `MISSING_ARGUMENT` | Specify a serviceTerritoryId with either a workTypeGroupId or WorkTypeId. |
| 400 | `INTERNAL_ERROR` | You can't specify both requiredResourceIds and filterByResources in the request body. Specify one or the other and try again. |
| 400 | `INVALID_INPUT` | Specify either a workTypeGroupId or a WorkTypeId. |
| 400 | `INVALID_INPUT` | This isn't a valid workTypeGroupId value. Specify a valid ID for the workTypeGroupId parameter. |
| 400 | `INVALID_INPUT` | This isn't a valid workTypeId value. Specify a valid ID for the workTypeId parameter. |
| 400 | `INVALID_INPUT` | Specify either a workTypeId or a value for the durationInMinutes parameter. |
| 400 | `INVALID_INPUT` | This isn't a valid serviceTerritoryId value. Specify a valid ID for the serviceTerritoryId parameter. |
| 400 | `INVALID_INPUT` | This isn't a valid account ID. Specify a valid ID for the accountId parameter. |
| 400 | `INTERNAL_ERROR` | AppointmentSchedulingPolicy provided: {id} does not belong to AppointmentSchedulingPolicy. |
| 400 | `INTERNAL_ERROR` | Provide an end date that's after the start date, and try again. |
| 400 | `INVALID_INPUT` | This isn't a valid service resource Id in the filterByResources parameter. Specify a valid service resource ID in the filterByResources parameter. |
| 400 | `INTERNAL_ERROR` | Something went wrong. Ask your admin for help. |
| 400 | `INSUFFICIENT_ACCESS` | Looks like you don't have access to the maxAppointments or workTypeGroup field in the TimeSlot object. Your Salesforce admin can help with that. |
| 400 | `INSUFFICIENT_ACCESS` | Looks like you don't have access to the {Service Resource} object. Your Salesforce admin can help with that. |
| 400 | `INTERNAL_ERROR` | Specify a workTypeGroup with a custom_workType associated with an appointment category with a Scheduled type, and try again. |
| 400 | `INTERNAL_ERROR` | {id} (AppointmentTopicTimeSlot), is not accessible for the current user. |
| 403 | `API_DISABLED_FOR_ORG` | The Chatter Connect API is not enabled for this organization or user type. |

### 3-4. Estimated Wait Time (POST)

*Contains the error codes and error code messages related with Salesforce Scheduler API for the estimated-wait-time (POST) resource.*

| HTTP Response Code | Error Code | Description |
|---|---|---|
| 400 | `JSON_PARSER_ERROR` | The HTTP entity body is required, but this request has no entity body. |
| 405 | `METHOD_NOT_ALLOWED` | The request used an HTTP method other than POST. |
| 500 | `INTERNAL_ERROR` | Specify a valid Waitlist ID or Waitlist Participant ID and try again. Returned when both waitlistId and waitlistParticipantId are missing, empty, or null. |
| 500 | `INTERNAL_ERROR` | The waitlist <id> doesn't have an active work type group. Returned when waitlistId is invalid. |
| 500 | `INTERNAL_ERROR` | Invalid waitlist participant id. Only one waitlist should be associated with waitlist participant. Returned when waitlistParticipantId is invalid. |

### 3-5. Service Appointments (PATCH)

*Contains the error codes and error code messages related with Salesforce Scheduler API for the service-appointments (PATCH) resource.*

| HTTP Response Code | Error Code | Description |
|---|---|---|
| 400 | `INSUFFICIENT_ACCESS_OR_READONLY` | Insufficient access rights on the ServiceAppointment object record. |

### 3-6. Service Appointments (POST)

*Contains the error codes and error code messages related with Salesforce Scheduler API for the service-appointments (POST) resource.*

| HTTP Response Code | Error Code | Description |
|---|---|---|
| 400 | `INTERNAL_ERROR` | We couldn't find any resources for your request. Specify a different schedStartTime and schedEndTime and try again. |
| 400 | `INVALID_API_INPUT` | Only one assignedResource can have isPrimaryResource set to true. Check the request and try again. |
| 400 | `INVALID_API_INPUT` | You haven't enabled the Schedule Appointments using Engagement Channels setting in your org. Contact your Salesforce admin for assistance. |
| 400 | `INSUFFICIENT_ACCESS` | Looks like you don't have access to the MaxAppointments field in the TimeSlot object. Your Salesforce admin can help with that. |
| 400 | `INSUFFICIENT_ACCESS` | Looks like you don't have access to ServiceAppointment object. Your Salesforce admin can help with that. |

### 3-7. Service Territories (GET)

*Contains the error codes and error code messages related with Salesforce Scheduler API for the service-territories (GET) resource.*

| HTTP Response Code | Error Code | Description |
|---|---|---|
| 400 | `MISSING_ARGUMENT` | Specify either a workTypeGroupId or WorkTypeId. |

### 3-8. Waitlist Participants (PATCH)

*Contains the error codes and error code messages related with Salesforce Scheduler API for the waitlist/participants (PATCH) resource.*

| HTTP Response Code | Error Code | Description |
|---|---|---|
| 400 | `API_DISABLED_FOR_ORG` | The Drop In Appointments setting isn't enabled in your org. Ask your Salesforce admin to enable the setting. |
| 400 | `INSUFFICIENT_ACCESS` | The calling user doesn't have access to Lobby Management. Assign a lobby management permission set, such as Facility Manager or Queue Manager, to the user. |
| 400 | `INVALID_API_INPUT` | One of: waitlistParticipantId is missing or empty; waitlistParticipantId doesn't match a waitlist participant whose Status is Unassigned; targetPosition is missing; targetPosition is 0, a negative value other than -1, or otherwise invalid. |
| 400 | `JSON_PARSER_ERROR` | The targetPosition value isn't a number, or the value is outside the signed 32-bit integer range. |
| 405 | `METHOD_NOT_ALLOWED` | The request used an HTTP method other than PATCH. |

---

## 관련 노트

- [[Salesforce Scheduler — Business REST·Connect 엔드포인트]] — 위 표현형을 주고받는 엔드포인트의 URI·HTTP 메서드·버전·요청/응답 파라미터·JSON 예제
- [[Salesforce Scheduler — ConnectApi LightningScheduler Apex]] — 이 표현형에 대응하는 ConnectApi LightningScheduler Apex 입력/출력 클래스
- [[Salesforce Scheduler — 커스텀 예약 시나리오 (익명·단일리소스)]] — 이 표현형을 주고받는 시나리오 워크플로우
- [[Salesforce Scheduler — 커스텀 예약 시나리오 (멀티리소스·동시·공유)]] — 멀티리소스·동시·공유 시나리오 워크플로우
- [[Salesforce Scheduler — Platform Events·Metadata API Types]]
- [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]]
- [[Salesforce Scheduler 표준객체 — 핵심 예약]]
- [[Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형]]
- [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]]
- [[Salesforce Scheduler 표준객체 — 초대·집계·로그]]
- [[Salesforce Scheduler 커스텀객체]]
