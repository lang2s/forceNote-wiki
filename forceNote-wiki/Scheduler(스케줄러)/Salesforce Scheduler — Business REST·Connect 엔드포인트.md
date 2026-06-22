---
tags: [scheduler, salesforce-scheduler, business-api, rest-api, connect-api, appointment-candidates]
source: salesforce_scheduler_dev_guide.pdf (Salesforce Scheduler Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [getAppointmentCandidates, getAppointmentSlots, Scheduler Connect API, service-appointments REST, available-territory-slots, 예약 후보 REST]
---

# Salesforce Scheduler — Business REST·Connect 엔드포인트

> Salesforce Scheduler Business API의 REST 엔드포인트(getAppointmentCandidates·getAppointmentSlots·Scheduling)와 Connect REST 리소스 9개의 URI·HTTP 메서드·버전·요청/응답 파라미터·JSON 예제 정본. 요청/응답 **표현형(representation) 상세**는 N9 소관이므로 여기서는 plain-text 폴백 링크로만 가리킨다.

> [!note] 문서 구조 변경 예정 (PDF 부록 Important, 2026-07)
> Salesforce는 2026년 7월에 Connect REST API 레퍼런스 콘텐츠를 개편한다. 리소스·요청 바디·응답 바디로 나뉜 개별 페이지를 **단일 페이지 확장형 레이아웃**으로 통합하며, 기존 리소스 페이지는 새 인터페이스의 해당 리소스로 자동 리디렉트된다. 요청/응답 바디 페이지는 메인 API 레퍼런스 페이지로 리디렉트된다(해당 정보가 리소스와 함께 맥락상 표시되기 때문). 미리보기는 Data 360 Connect REST API 참조.

---

## 두 API 패밀리 개요

| | REST APIs | Connect APIs |
|---|---|---|
| 베이스 경로 | `/services/data/vXX.X/scheduling/` | `/connect/scheduling/` |
| Rate limit | Salesforce platform 공통 API rate limit 적용 | per user, per application, per hour — **10000/user/app/hour** 지원 |
| 용도 | appointment time slot·available service resource 조회 (work type group + service territory 기반) | service territory 조회, territory별 service resource 통합 가용성 조회, service appointment 생성/수정 |

> **[sic] 보존 (PDF 원문 오타):** REST·Connect 양쪽 Note 모두 "Salesforce Scheduler is built on the Salesforce platform (also known as **Lighting Experience**)."로 표기되어 있다. 정상 표기는 "Lightning Experience"이나 PDF 원문 오타를 그대로 보존한다.

---

# PART 1 — REST APIs

베이스: `/services/data/vXX.X/scheduling/`. 모든 응답은 UTC 시각으로 반환된다.

**REST 리소스 3개:**

| Resource | 설명 | 버전 |
|---|---|---|
| Get Appointment Candidates | work type group/work type + service territory 기반 service resource(appointment candidate) 목록 반환 | 45.0 |
| Get Appointment Slots | 주어진 work type group/work type + service territory 기반 리소스의 available appointment time slot 목록 반환 | 45.0 |
| Scheduling | 사용 가능한 Scheduler REST 리소스와 대응 URI 목록 반환 | 45.0+ |

> 표현형(Skill Requirement, Work Type, Candidates, TimeSlots 등 Request/Response Body 표현형 상세)은 [[Salesforce Scheduler — Connect API 요청·응답 표현형·Error Codes]] 참조.

---

## 1.1 Get Appointment Candidates

> Returns a list of service resources (appointment candidates) based on work type group or work type and service territories.

요청 전 Scheduler 셋업 필요(Service Resources, Service Territory Members, Work Type Groups, Work Types, Work Type Group Members, Service Territory Work Types 생성/구성). 시간 슬롯은 field values·scheduled appointments·absences·Scheduler Settings·Scheduling Policies로 결정된다.

**Start/End time 결정 요인:**
- **Resource Availability** — service territory member, service territory, work type, account operating hours 필드로 결정.
- **Resource Unavailability** — resource absences와 리소스에 할당된 기존 appointment로 결정. 리소스는 closed·canceled·completed가 아닌 status로 required resource 표시되어야 함.
- **Appointment Start Time Interval (Scheduling Policy)** — 5, 10, 15, 20, 30, 60 중 하나. 기본값 15.
- **Work Type Duration** — end time = start time + work type duration.

> **Note:** asset scheduling이 활성화되면 응답에 asset-based candidate도 포함된다.

### Syntax

| 항목 | 값 |
|---|---|
| URI | `/services/data/vXX.X/scheduling/getAppointmentCandidates` |
| Available version | 45.0 |
| Formats | JSON, XML |
| HTTP methods | `POST` |

### Request body

| Parameter | Required | Type | Description |
|---|---|---|---|
| `accountId` | No | String | The ID of the associated account. |
| `allowConcurrentScheduling` | No | Boolean | If true, allows scheduling of concurrent appointments in a time slot. If false, concurrent appointments aren't allowed. The default is false. Available in API version 47.0 and later. |
| `correlationId` | No | String | The ID to pass custom information to the `ServiceResourceScheduleHandler` Apex interface. For example, you can use the correlation ID to identify the app, website, or any other external system that calls this Apex interface implementation. If you don't pass a custom value, a randomly generated identifier is passed. Available in API version 53.0 and later. |
| `endTime` | No | String | The latest time that a time slot can end (inclusive). **Note:** The API only returns time slots up to 31 days from the startTime. |
| `engagementChannelTypeIds` | No | String[] | The ID of the engagement channel type record. The availability of service resources is filtered based on the engagement channel type selected. Available in API version 56.0 and later. Supports only one engagement channel type ID. 사용 조건: (1) Schedule Appointments Using Engagement Channels 설정이 Salesforce Scheduler Settings에서 활성화. (2) scheduling policy에 shift 정의됨. **Note:** engagement channel type은 scheduling policy의 operating hours rule과 함께 지원되지 않는다. |
| `filterByResources` | No | String[] | A comma-separated list of service resource IDs. API returns only eligible service resources that are both in the list and in the selected service territory. The resources are sorted by the order in which the resource IDs are passed. Available in API version 51.0 and later. **Note:** Scheduler doesn't support appointment Distribution when you've specified a list of resource IDs in the filterByResources parameter. |
| `resourceLimitApptDistribution` | No | Integer | Specify the maximum number of service resources to show during appointment scheduling when appointment distribution is enabled. Available in API version 53.0 and later. **Note:** The filterByResources field takes precedence over the resourceLimitApptDistribution field. |
| `startTime` | No | String | The earliest time that a time slot can begin (inclusive). Defaults to the current time of the request, if empty. You can also use a time from the past. |
| `schedulingPolicyId` | No | String | The ID of the AppointmentSchedulingPolicy object. If no scheduling policy is passed, the default configurations are used. All Scheduling Policy Configurations are considered when using this API. |
| `territoryIds` | **Yes** | String[] | List of service territory IDs, where the work being requested is performed. |
| `workType` | Required if `workTypeGroupId` isn't given. | Work Type | The type of work to be performed. |
| `workTypeGroupId` | Required if `workType` isn't given. | String | The ID of the work type group containing the work types being performed. |

> **Note (필수 필드 판단):**
> - Provide either `workTypeGroupId` or `workType`, but not both.
> - If `workType` is specified, you must provide either `id` or `durationInMinutes`.
> - If `id` of `workType` is specified, the rest of the `workType` fields are optional.

> **Important:**
> - **shifts 사용 시:** `workTypeGroupId` 또는 work type의 ID를 지정해야 한다. work type의 ID를 지정하면 다른 모든 `workType` 필드는 optional이 되고 Scheduler가 DB에서 값을 가져온다.
> - **operating hours 사용 시:** `workTypeGroupId`나 work type ID를 지정할 필요가 없다. Scheduler가 `durationInMinutes`와 다른 모든 `workType` 필드를 구성한 대로 적용한다.

### Response body

| Parameter | Required | Type | Description |
|---|---|---|---|
| `candidates` | Yes | Candidates[] (→ N9 표현형) | List of available appointment candidates. |

### Examples

**Request — workTypeGroupId 사용:**

```json
{
"startTime": "2019-01-23T00:00:00.000Z",
"endTime": "2019-02-30T00:00:00.000Z",
"workTypeGroupId": "0VSB0000000KyjBOAS",
"accountId": "001B000000qAUAWIA4",
"territoryIds": [
"0HhB0000000TO9WKAW"
],
"schedulingPolicyId": "0VrB0000000KyjB",
"engagementChannelTypeIds": [
"0eFRM00000000Bv2AI"
]
}
```

**Request — workTypeId 사용:**

```json
{
"startTime": "2019-01-23T00:00:00.000Z",
"endTime": "2019-02-30T00:00:00.000Z",
"workType": {
"id": "08qRM00000003fkYAA"
},
"territoryIds": [
"0HhRM00000003OZ0AY"
],
"accountId": "001B000000qAUAWIA4",
"schedulingPolicyId": "0VrB0000000KyjB",
"engagementChannelTypeIds": [
"0eFRM00000000Bv2AI"
]
}
```

**Response:**

```json
{
"candidates": [
{
"endTime": "2019-01-23T19:15:00.000+0000",
"resources": [
"0HnB0000000D2DsKAK"
],
"startTime": "2019-01-23T16:15:00.000+0000",
"territoryId": "0HhB0000000TO9WKAW",
"engagementChannelTypeIds": [
"0eFRM00000000Bv2AI"
]
},
{
"endTime": "2019-01-23T19:30:00.000+0000",
"resources": [
"0HnB0000000D2DsKAK"
],
"startTime": "2019-01-23T16:30:00.000+0000",
"territoryId": "0HhB0000000TO9WKAW",
"engagementChannelTypeIds": [
"0eFRM00000000Bv2AI"
]
},
{
"endTime": "2019-01-23T19:45:00.000+0000",
"resources": [
"0HnB0000000D2DsKAK"
],
"startTime": "2019-01-23T16:45:00.000+0000",
"territoryId": "0HhB0000000TO9WKAW",
"engagementChannelTypeIds": [
"0eFRM00000000Bv2AI"
]
}
]
}
```

---

## 1.2 Get Appointment Slots

> Returns a list of available appointment time slots for a resource based on given work type group or work type and service territories.

**전제조건:** Scheduler 셋업(Service Resources, Service Territory Members, Work Type Groups, Work Types, Work Type Group Members, Service Territory Work Types). 요청 바디의 각 territory마다 Service Territory Work Type으로 work type을 매핑하고, work type group member로 동일 work type을 work type group에 매핑한다.

**시간 슬롯 계산 요인:**
- operating hours가 다른 timezone을 처리하며, 결과는 항상 UTC로 반환.
- 리소스는 assigned resource object에서 required resource로 표시되어야 함.
- service appointment에 할당된 리소스의 status category가 Canceled·Cannot Complete·Completed 외이면 unavailable로 간주.
- 모든 유형의 Resource Absence는 start~end 동안 unavailable로 간주.

**Work Type 레코드 필드(시간 슬롯 fine-tune):**

| 필드 | 설명 |
|---|---|
| Timeframe Start | current time + Timeframe Start보다 이른 슬롯은 미반환. |
| Timeframe End | current time + Timeframe End보다 늦은 슬롯은 미반환. |
| Block Time Before Appointment | appointment 이전 기간을 unavailable로 간주. |
| Block Time After Appointment | appointment 이후 기간을 unavailable로 간주. |
| Operating Hours | account·work type·service territory·service territory member의 operating hours 교집합이 시간 슬롯 결정에 반영. |

- start date로부터 31일 이내의 슬롯만 반환된다.
- earliest·latest appointment slot 등 여러 요인으로 available time slot을 결정한다.

> **Note:** asset scheduling이 활성화되면 `requiredResourceIds`에 asset-based service resource를 제공해 해당 asset 리소스의 available timeslot을 조회할 수 있다.

### Syntax

| 항목 | 값 |
|---|---|
| URI | `/services/data/vXX.X/scheduling/getAppointmentSlots` |
| Available version | 45.0 |
| Formats | JSON, XML |
| HTTP methods | `POST` |
| Authentication | `Authorization: Bearer token` |

### Request body

| Parameter | Required | Type | Description |
|---|---|---|---|
| `accountId` | No | String | The ID of the associated account. |
| `allowConcurrentScheduling` | No | Boolean | If true, allows scheduling of concurrent appointments in a time slot. If false, concurrent appointments aren't allowed. The default is false. Available in API version 47.0 and later. |
| `correlationId` | No | String | The ID to pass custom information to the `ServiceResourceScheduleHandler` Apex interface. For example, you can use the correlation ID to identify the app, website, or any other external system that calls this Apex interface implementation. If you don't pass a custom value, a randomly generated identifier is passed. Available in API version 53.0 and later. |
| `endTime` | No | String | The latest time that a time slot can end (inclusive). |
| `engagementChannelTypeIds` | No | String[] | The ID of the engagement channel type record. The availability of time slots is filtered based on the engagement channel type selected. Available in API version 56.0 and later. **Note:** Supports only one engagement channel type ID. 사용 조건: (1) Schedule Appointments Using Engagement Channels 설정 활성화. (2) scheduling policy에 shift 정의됨. **Note:** engagement channel type은 operating hours rule과 함께 지원되지 않는다. |
| `primaryResourceId` | No | String | The ID of the primary resource in multi-resource scheduling. Available in API version 48.0 and later. **Note:** multi-resource scheduling이 활성화된 경우에만 required. |
| `requiredResourceIds` | **Yes** | String[] | List of resource IDs that must be available during the time slot. |
| `schedulingPolicyId` | No | String | The ID of the AppointmentSchedulingPolicy object. If none passed, default configurations are used. The only scheduling policy configuration used in determining time slots is the enforcement of account visiting hours. |
| `startTime` | No | String | The earliest time that a time slot can begin (inclusive). Defaults to the current time of the request, if empty. |
| `territoryIds` | **Yes** | String[] | List of IDs of service territories, where the work being requested is performed. |
| `workType` | Required if `workTypeGroupId` isn't specified. | Work Type | The type of work to be performed. |
| `workTypeGroupId` | Required if `workType` isn't given. | String | The ID of the work type group containing the work types being performed. |

> **Note (필수 필드):**
> - Provide either `workTypeGroupId` or `workType`, but not both.
> - If `workType` is specified, you must provide either `id` or `durationInMinutes`.
> - If `id` of `workType` is specified, the rest of the `workType` fields are optional.

### Response body

| Parameter | Required | Type | Description |
|---|---|---|---|
| `timeSlots` | Yes | TimeSlots[] (→ N9 표현형) | List of time slots included in each territory. |

### Examples

**Request — workTypeGroupId 사용:**

```json
{
"startTime": "2019-01-23T00:00:00.000Z",
"endTime": "2019-02-28T00:00:00.000Z",
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
"0eFRM00000000Bv2AI"
]
}
```

**Request — workType 사용:**

```json
{
"startTime": "2019-01-23T00:00:00.000Z",
"endTime": "2019-02-28T00:00:00.000Z",
"workType": {
"id": "08qRM00000003fkYAA"
},
"requiredResourceIds": [
"0HnB0000000TO8gKAK"
],
"territoryIds": [
"0HhRM00000003OZ0AY"
],
"accountId": "001B000000qAUAWIA4",
"schedulingPolicyId": "0VrB0000000KyjB",
"engagementChannelTypeIds": [
"0eFRM00000000Bv2AI"
]
}
```

**Response:**

```json
{
"timeSlots": [
{
"endTime": "2019-01-21T19:15:00.000+0000",
"startTime": "2019-01-21T16:15:00.000+0000",
"territoryId": "0HhB0000000TO9WKAW"
},
{
"endTime": "2019-01-21T19:30:00.000+0000",
"startTime": "2019-01-21T16:30:00.000+0000",
"territoryId": "0HhB0000000TO9WKAW"
},
{
"endTime": "2019-01-21T19:45:00.000+0000",
"startTime": "2019-01-21T16:45:00.000+0000",
"territoryId": "0HhB0000000TO9WKAW"
}
]
}
```

---

## 1.3 Scheduling

> Returns a list of available Salesforce Scheduler REST resources and corresponding URIs. This resource is available in REST API version 45.0 and later.

### Syntax

| 항목 | 값 |
|---|---|
| URI | `/services/data/vXX.X/scheduling/` |
| Formats | JSON, XML |
| HTTP methods | `GET` |
| Authentication | `Authorization: Bearer token` |

**Response:**

```json
{
"getAppointmentCandidates" : "/services/data/v67.0/scheduling/getAppointmentCandidates",
"getAppointmentSlots" : "/services/data/v67.0/scheduling/getAppointmentSlots"
}
```

---

# PART 2 — Connect APIs Resources

베이스: `/connect/scheduling/`. Rate limit은 **per user, per application, per hour 10000** 지원.

**Connect 리소스 9개:**

| # | Resource | URI | 메서드 | 버전 |
|---|---|---|---|---|
| 1 | Available Territory Slots | `/connect/scheduling/available-territory-slots` | `POST` | 49.0 |
| 2 | Engagement Channel Types | `/connect/scheduling/engagement-channel-types` | `GET` | 56.0 |
| 3 | Estimated Wait Time | `/connect/scheduling/estimated-wait-time` | `POST` | 65.0 |
| 4 | Group Appointments | `/connect/scheduling/group-appointments` | `POST` | 61.0 |
| 5 | Service Appointments | `/connect/scheduling/service-appointments` | `POST`, `PATCH` | 48.0 (PATCH 51.0+) |
| 6 | Service Territories | `/connect/scheduling/service-territories` | `GET` | 48.0 |
| 7 | Waitlists | `/connect/scheduling/waitlists` | `GET` | 59.0 |
| 8 | Waitlist Check Ins | `/connect/scheduling/waitlist-checkin` | `POST` | 59.0 |
| 9 | Waitlist Participants | `/connect/scheduling/waitlist/participants` | `PATCH` | 62.0 |

> 응답 바디 표현형(Available Territory Slots Output, Service Appointment Output, Waitlist Output 등)은 [[Salesforce Scheduler — Connect API 요청·응답 표현형·Error Codes]] 참조.

---

## 2.1 Available Territory Slots

> Get consolidated availability of each service resource within specified territories.

| 항목 | 값 |
|---|---|
| Resource | `/connect/scheduling/available-territory-slots` |
| Available version | 49.0 |
| HTTP methods | `POST` |

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

**Request example (required fields만):**

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

### Properties

| Name | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `accountId` | String | ID of the associated account. | Optional | 49.0 |
| `allowConcurrentScheduling` | Boolean | Indicates whether concurrent appointments are allowed (true) or not allowed (false). The default value is false. | Optional | 49.0 |
| `correlationId` | String | ID to pass custom information to the `ServiceResourceScheduleHandler` Apex interface. For example, you can use the correlation ID to identify the app, website, or any other external system that calls this Apex interface implementation. If you don't pass a custom value, a randomly generated identifier is passed. | Optional | 53.0 |
| `endTime` | String | Latest time that an appointment can end. **Note:** The API only returns time slots up to 31 days from the startTime. | Optional | 49.0 |
| `engagementChannelTypeIds` | String[] | The ID of the engagement channel type record. The resources and their associated time slots are filtered by the specified engagement channel type. **Note:** Supports only one engagement channel type ID. 사용 조건: (1) Schedule Appointments Using Engagement Channels 활성화. (2) scheduling policy에 shift 정의됨. **Note:** operating hours rule과 함께 지원 안 됨. | Optional | 56.0 |
| `filterByResources` | String[] | Comma-separated list of service resource IDs. API returns only eligible service resources that are both in the list and in the selected service territory. The resources are sorted by the order in which the resource IDs are passed. **Note:** You can either pass `filterByResources` or `requiredResourceIds` in a request. | Optional | 51.0 |
| `recordLimit` | Integer | The maximum number of earliest available slots across the specified territories. The API outputs the specified number of sorted slots across service territories. | Optional | 63.0 |
| `requiredResourceIds` | String[] | List of resource IDs to get available time slots for. 여러 ID를 전달하면 전달된 리소스 중 하나라도 available한 모든 슬롯을 반환한다(예: A/B/C 전달 시 only A, only B, A+B, A+C, B+C, A+B+C인 슬롯 반환 — only C인 슬롯은 미반환). 비어 있으면 모든 qualified resource의 슬롯 반환. **Note:** `resourceLimitAppointmentDistribution`로 설정된 least utilized resource 목록에 없으면 해당 리소스의 슬롯은 표시되지 않는다(예: A를 지정하고 distribution=15인데 A가 top 15 least utilized에 없으면 A의 슬롯 미표시). | Optional | 49.0 |
| `resourceLimitApptDistribution` | Integer | Specify the maximum number of service resources to show during appointment scheduling when appointment distribution is enabled. Default value is 10. **Note:** The `filterByResources` field takes precedence. | Optional | 53.0 |
| `schedulingPolicyId` | String | ID of the AppointmentSchedulingPolicy object. If not provided, the default configurations are considered. | Optional | 49.0 |
| `startTime` | String | Earliest time that an appointment can start. Defaults to the current time of the request, if empty. You can also use a time from the past. | Optional | 49.0 |
| `territoryIds` | String[] | List of IDs of service territories where the specified work is performed. | **Required** | 49.0 |
| `workType` | Work Type Input | Type of work performed. | Required if `workTypeGroupId` isn't provided | 49.0 |
| `workTypeGroupId` | String | ID of the work type group containing all work types performed. | Required if `workType` isn't provided | 49.0 |

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

**Response body for POST:** Available Territory Slots Output (→ N9)

---

## 2.2 Engagement Channel Types

> Retrieve a list of the engagement channel types from your Salesforce org. The API returns only the channel types that are active and whose usage type is set to Salesforce Scheduler.

| 항목 | 값 |
|---|---|
| Resource | `/connect/scheduling/engagement-channel-types` |
| Available version | 56.0 |
| HTTP methods | `GET` |

**Examples:**

```
https://yourInstance.salesforce.com/services/data/v56.0/connect/scheduling/engagement-channel-types
https://yourInstance.salesforce.com/services/data/v56.0/connect/scheduling/engagement-channel-types?workTypeGroupIds=0VSRM0000000BgX4AU
https://yourInstance.salesforce.com/services/data/v56.0/connect/scheduling/engagement-channel-types?workTypeIds=08q2w000000XmniAAC,08q2w000000XmniAAS
```

> **Note:** request에서 `workTypeGroupIds` 또는 `workTypeIds` 중 하나만 지정해 engagement channel type 결과를 필터링할 수 있다.

### Request parameters for GET

| Parameter Name | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `workTypeGroupIds` | String | List of the work type group IDs. The API returns the engagement channel type records associated with the specified work type group IDs. (예: EC1/EC2/EC3 중 WTG1↔EC1·EC2, WTG2↔EC2 전달 시 → EC1 with WTG1 only, EC2 with both WTG1·WTG2 반환; EC3은 미연관이라 미반환.) | Optional | 56.0 |
| `workTypeIds` | String | List of the work type IDs. The API returns the engagement channel type records associated with the specified work type IDs. (예: WT1↔EC1·EC3, WT2↔EC3 전달 시 → EC1 with WT1 only, EC3 with both WT1·WT2 반환; EC2 미반환.) | Optional | 56.0 |

**Response body for GET:** Engagement Channel Type Output (→ N9)

---

## 2.3 Estimated Wait Time

> Get the estimated wait time for a customer waiting for service that belongs to a specified work type group.

| 항목 | 값 |
|---|---|
| Resource | `/connect/scheduling/estimated-wait-time` |
| Resource example | `https://yourInstance.salesforce.com/services/data/v67.0/connect/scheduling/estimated-wait-time` |
| Available version | 65.0 |
| HTTP methods | `POST` |
| Root XML tag | `<estimatedWaitTime>` |

**JSON example (waitlist ID):**

```json
{
"waitlistId": "11wfi700000262vAAA"
}
```

**JSON example (waitlist participant ID):**

```json
{
"waitlistParticipantId": "12oxx0000004FGiAAM"
}
```

### Properties

| Name | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `waitlistId` | String | ID of the waitlist. | Required if the `waitlistParticipantId` parameter isn't specified. | 65.0 |
| `waitlistParticipantId` | String | ID of the waitlist participant. | Required if the `waitlistId` parameter isn't specified. | 65.0 |

**Response body for POST:** Estimated Wait Time (→ N9)

---

## 2.4 Group Appointments

> Get a list of group appointments along with the remaining attendee limit.

| 항목 | 값 |
|---|---|
| Resource | `/connect/scheduling/group-appointments` |
| Resource example | `https://yourInstance.salesforce.com/services/data/v67.0/connect/scheduling/group-appointments` |
| Available version | 61.0 |
| HTTP methods | `POST` |

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

### Properties

| Name | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `endTime` | String | Latest end time for the group appointments to be retrieved. | Optional | 61.0 |
| `excludeAssociatedAppts` | Boolean | Indicates whether the response excludes appointments where the current user is associated as an attendee or assigned resource (true) or not (false). | Optional | 61.0 |
| `extendedFieldsToQuery` | String[] | List of the extended custom fields to fetch in the output. | Optional | 61.0 |
| `filterByEngagementChannelTypes` | String[] | ID of the engagement channel type record. Group appointments are filtered based on the selected engagement channel type. | Optional | 61.0 |
| `filterByParentRecords` | String[] | The ID of the associated parent record. | Optional | 61.0 |
| `filterByResources` | String[] | List of the group appointments where all the given resources are present. | Optional | 61.0 |
| `filterByTerritories` | String[] | List of IDs of the service territories where the requested work is performed. | Optional | 61.0 |
| `filterByWorkTypeGroups` | String[] | IDs of the work type groups containing the work types being performed. | Optional | 61.0 |
| `filterByWorkTypes` | String[] | List of IDs of the work types to be performed. | Optional | 61.0 |
| `limit` | Integer | Maximum number of records to be fetched. | Optional | 61.0 |
| `offset` | Integer | Number of records to be skipped. | Optional | 61.0 |
| `startTime` | String | The earliest start time for the group appointments to be retrieved. If not provided, defaults to the current time of the request. | Optional | 61.0 |

**Response body for POST:** Group Appointments (→ N9)

---

## 2.5 Service Appointments

> Create and update service appointment records, assign resources, and generate leads, including group appointments with multiple participants.

> **Note:** 다음 파라미터를 지정하지 않으면 API가 시간 슬롯 가용성을 확인하지 않는다. 중복 service appointment 생성을 막으려면 지정한다: `WorkTypeId` · `ServiceTerritoryId` · `SchedStartTime` · `SchedEndTime` · `AssignedResources`.

| 항목 | 값 |
|---|---|
| Resource | `/connect/scheduling/service-appointments` |
| Example | `https://yourInstance.salesforce.com/services/data/v67.0/connect/scheduling/service-appointments` |
| Available version | 48.0 |
| HTTP methods | `POST`, `PATCH` (PATCH is available in version 51.0 and later.) |

### Request body for POST — JSON example

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

### Request body for POST — unauthenticated user 예제

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

### Properties (POST)

| Name | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `assignedResources` | Assigned Resource Input[] | Service resource assigned to a service appointment. **Note:** 생성 시 edit access가 있는 한, custom field를 포함한 `assignedResources`의 어떤 필드에도 `extendedFields`로 값을 추가할 수 있다. | Optional | 48.0 |
| `lead` | Lead Input[] | Prospect or lead. **Note:** unauthenticated guest user로 service appointment를 생성하려면 required. | Required if `serviceAppointment` isn't provided | 48.0 |
| `schedulingPolicyId` | String | ID of the AppointmentSchedulingPolicy object. If none passed, default configurations are used. The only scheduling policy configuration used in determining time slots is the enforcement of account visiting hours. | Optional | 48.0 |
| `serviceAppointment` | Service Appointment Input[] | Appointment to complete a service work for a customer. **Note:** 생성 시 edit access가 있는 한, custom field를 포함한 `serviceAppointment`의 어떤 필드에도 `extendedFields`로 값을 추가할 수 있다. | Required if `lead` isn't provided | 48.0 |

### Request body for PATCH — JSON example

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

*(원문 그대로 — JSON 닫는 괄호 일부 누락은 PDF 원본 상태 [sic])*

**Request example — scheduled time 갱신:**

> **Note:** scheduled time이 갱신되면 API가 대응하는 Salesforce calendar event와 block time도 갱신한다.

```json
{
"serviceAppointmentId": "08pxx0000004C92AAE",
"serviceAppointment": {
"schedStartTime": "2020-09-15T16:00:00+0000",
"schedEndTime": "2020-09-15T17:00:00+0000",
}
```

**Request example — work type 갱신:**

```json
{
"serviceAppointmentId": "08pxx0000004C92AAE",
"serviceAppointment": {
"workTypeId": "08qxx0000004C92AAE",
}
```

**Request example — service territory 갱신:**

```json
{
"serviceAppointmentId": "08pxx0000004C92AAE",
"serviceAppointment": {
"serviceTerritoryId": "0Hhxx0000004CAeCAM"
}
```

### Properties (PATCH)

| Name | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `assignedResources` | Assigned Resource Input[] | Service resource assigned to a service appointment. 갱신 시 필요한 리소스의 완전한 목록을 전달한다. service appointment에 할당된 리소스를 전달하지 않으면 API가 그 assigned resource를 삭제한다. (예: 기존 A+B에 B+C 전달 → B·C 가용성 확인; 둘 다 available이면 A—Deleted, B—Updated, C—Created. assigned resource를 전혀 전달하지 않으면 변경 없음으로 간주.) **Note:** 갱신 시 edit access가 있는 한, custom field 포함 `assignedResources`의 필드에 `extendedFields`로 값 추가 가능. | Optional | 51.0 |
| `schedulingPolicyId` | String | ID of the AppointmentSchedulingPolicy object. If none passed, default configurations are used. The only scheduling policy configuration used in determining time slots is the enforcement of account visiting hours. | Optional | 51.0 |
| `serviceAppointment` | Service Appointment Input[] | 갱신 시 변경할 필드만 전달한다. **Note:** 갱신 시 edit access가 있는 한, custom field 포함 `serviceAppointment`의 필드에 `extendedFields`로 값 추가 가능. | Required | 51.0 |
| `serviceAppointmentId` | String | ID of the service appointment that you want to update. | Required | 51.0 |

**Response body for POST and PATCH:** Service Appointment Output (→ N9)

**engagement channel type을 service-appointments 리소스와 함께 쓸 때의 고려사항:**
- Salesforce Scheduler Settings에서 Schedule Appointments Using Engagement Channels가 활성화되어야 한다.
- appointment를 생성/수정할 때 scheduling policy에 shift가 정의되어야 한다. **Note:** engagement channel type은 operating hours rule과 함께 지원되지 않는다.
- engagement channel과 shift를 써서 service appointment를 생성/수정할 때, Scheduler는 (지정하지 않으면) Appointment Type의 기본값을 고려해야 한다. 다만 Scheduler는 engagement channel만 고려하고 Appointment Type은 무시한다.

---

## 2.6 Service Territories

> Get service territories for a workTypeId or workTypeGroupId. Filter and sort the service territories using the radius, latitude, longitude, sortBy, and sortOrder properties.

| 항목 | 값 |
|---|---|
| Resource | `/connect/scheduling/service-territories` |
| Available version | 48.0 |
| HTTP methods | `GET` |

**Resource example:**

```
https://yourInstance.salesforce.com/services/data/67.0/connect/scheduling/service-territories?workTypeGroupId=0VSRM000000009Z4AQ&latitude=37.79332&longitude=-122.392761&radius=50&radiusUnit=km&sortBy=Distance&sortOrder=asc
```

*(원문 그대로 — 이 URL의 버전 경로는 `data/67.0/`로 `v` 접두어 없음, 다른 예시들과 달리 [sic])*

### Query parameters

| Parameter Name | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `filterByTerritoryIds` | String[] | Comma-separated list of service territory IDs to filter the API response. | Optional | 57.0 |
| `latitude` | Double | Latitude of the service territory area. | Optional | 48.0 |
| `limit` | Integer | Limit of the service territories returned. (예: limit=1이면 service territory 1개만.) The default value is 40. | Optional | 48.0 |
| `longitude` | Double | Longitude of the service territory area. | Optional | 48.0 |
| `offset` | Integer | Offset for the service territories returned. The default value is 0. | Optional | 48.0 |
| `radius` | Integer | Radius around the latitude and longitude values to get service territories. Default value is 5 when latitude and longitude values are provided, otherwise no default. | Optional | 48.0 |
| `radiusUnit` | String | Unit for the radius value. Possible values are mi (miles) and km (kilometer). Default value is mi when latitude and longitude values are provided, otherwise no default. | Optional | 48.0 |
| `schedulingPolicyId` | String | ID of the AppointmentSchedulingPolicy object. If none passed, default configurations are used. All Scheduling Policy Configurations are considered when using this API. | Optional | 48.0 |
| `serviceResourceIds` | String[] | Comma-separated list of service territory technician or asset IDs to filter the API response. | Optional | 48.0 |
| `sortBy` | String[] | Criteria to sort the service territories list. Possible case-insensitive values are distance and name. The default value is distance when latitude and longitude values are provided, otherwise name. | Optional | 48.0 |
| `sortOrder` | String[] | Sorting order of the service territory list. Possible case-insensitive values are asc (ascending) and desc (descending). The default value is asc. | Optional | 48.0 |
| `workTypeGroupId` | String | ID of the work type group containing the work types being performed. | Required if `workTypeId` isn't given | 48.0 |
| `workTypeId` | String | ID of the type of work to be performed. | Required if `workTypeGroupId` isn't given | 48.0 |

**Sample response body:**

```json
{
"result" : {
"serviceTerritories" : [ {
"city" : "San Francisco",
"country" : "United States",
"id" : "0HhRM00000002U50AI",
"latitude" : 37.79332,
"longitude" : -122.392761,
"name" : "Chase 1 Mission",
"operatingHoursId" : "0OHRM00000002Ps4AI",
"postalCode" : "94105",
"state" : "CA",
"street" : "1 Mission Street"
}, {
"city" : "San Francisco",
"country" : "United States",
"id" : "0HhRM00000002Tq0AI",
"latitude" : 37.793872,
"longitude" : -122.394865,
"name" : "Chase 1 Market",
"operatingHoursId" : "0OHRM00000002Ps4AI",
"postalCode" : "94105",
"state" : "CA",
"street" : "1 Market Street"
} ]
}
}
```

**Response body:** Service Territories Output (→ N9)

---

## 2.7 Waitlists

> Get waitlist details with the list of participants. A waitlist is a queue that includes participants without a scheduled appointment.

| 항목 | 값 |
|---|---|
| Resource | `/connect/scheduling/waitlists` |
| Available version | 59.0 |
| HTTP methods | `GET` |

**Resource example:**

```
https://yourInstance.salesforce.com/services/data/v67.0/connect/scheduling/waitlists?waitlistIds=0010000XKJSMEDD
https://yourInstance.salesforce.com/services/data/v67.0/connect/scheduling/waitlists?waitlistIds=0010000XKJSMEDD,0010000XKJSMEDD
https://yourInstance.salesforce.com/services/data/v67.0/connect/scheduling/waitlists?serviceTerritoryId=0010000XKJSMEDD&isActive=true
https://yourInstance.salesforce.com/services/data/v67.0/connect/scheduling/waitlists?waitlistIds=0010000XKJSMEDD&participantFields=Source__c
```

### Request parameters for GET

| Parameter Name | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `isActive` | Boolean | Indicates whether to fetch the active waitlists (true) or inactive waitlists (false). Used when the `serviceTerritoryId` parameter is specified. | Optional | 59.0 |
| `maxLimit` | Integer | Batch size of the waitlist participant records to fetch for each waitlist ID or service territory ID. The default value is 50. | Optional | 59.0 |
| `offset` | Integer | Number of waitlist participant records to skip from the response, in ascending order as per the created date. The default value is 0. The maximum offset value is 2000. | Optional | 59.0 |
| `participantFields` | String[] | Comma-separated list of fields to fetch from the waitlist participant object. | Optional | 59.0 |
| `requestId` | String | For internal use only. | Optional | 59.0 |
| `serviceTerritoryId` | String | ID of the service territory to fetch the details of the waitlists. | Required if the `waitlistIds` parameter isn't specified. | 59.0 |
| `waitlistIds` | String | Comma-separated list of the waitlist IDs to filter the result. | Required if the `serviceTerritoryId` parameter isn't specified. | 59.0 |

**Response body for GET:** Waitlist Output (→ N9)

---

## 2.8 Waitlist Check Ins

> Check in or register a participant to a waitlist who arrives at the service territory for a drop-in appointment.

| 항목 | 값 |
|---|---|
| Resource | `/connect/scheduling/waitlist-checkin` |
| Resource example | `https://yourInstance.salesforce.com/services/data/v67.0/connect/scheduling/waitlist-checkin` |
| Available version | 59.0 |
| HTTP methods | `POST` |
| Root XML tag | `<waitlistCheckIn>` |

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

### Properties

| Name | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `description` | String | Description of the participant. | Optional | 59.0 |
| `extendedFields` | Extended Field Input[] | Details of the extended custom fields. | Optional | 59.0 |
| `lead` | Lead Input | Details of the prospect or lead. | Required if the `participantId` parameter isn't specified. | 59.0 |
| `participantId` | String | ID of the participant with an appointment. The participant can be an account, a contact, or a lead. | Required if the `lead` parameter isn't specified. | 59.0 |
| `serviceResourceId` | String | ID of the service resource. | Optional | 59.0 |
| `waitlistId` | String | ID of the waitlist that the participant is checked in. | Required | 59.0 |
| `workTypeGroupId` | String | ID of the work type group. | Required if the `workTypeId` parameter isn't specified. | 59.0 |
| `workTypeId` | String | ID of the work type that represents the topic for the appointment. | Required if the `workTypeGroupId` parameter isn't specified. | 59.0 |

**Response body for POST:** Waitlist Check In (→ N9)

---

## 2.9 Waitlist Participants

> Move a participant to a specific position in a waitlist, to the top of the waitlist, or to the bottom of the waitlist.

| 항목 | 값 |
|---|---|
| Resource | `/connect/scheduling/waitlist/participants` |
| Resource example | `https://yourInstance.salesforce.com/services/data/v67.0/connect/scheduling/waitlist/participants` |
| Available version | 62.0 |
| HTTP methods | `PATCH` |
| Root XML tag | `<updateWaitlistParticipant>` |

**JSON example:**

```json
{
"waitlistParticipantId": "12oRM0000004FGiYAM",
"targetPosition": 3
}
```

### Properties

| Name | Type | Description | Req/Opt | Ver |
|---|---|---|---|---|
| `targetPosition` | Integer | Position in the waitlist to move the participant to. A value of 1 moves the participant to the top, and -1 moves the participant to the bottom. In API version 65.0 and later, a positive integer n moves the participant to the nth position; if n exceeds the number of participants in the waitlist, the participant moves to the bottom. | Required | 62.0 |
| `waitlistParticipantId` | String | ID of the waitlist participant record to move. The participant's Status must be Unassigned. | Required | 62.0 |

**Response body for PATCH:** Waitlist Participants Update (→ N9)

---

## 관련 노트

- [[LxScheduler Namespace]] — 동일 기능의 Apex 인터페이스/클래스(ServiceResourceScheduleHandler 등). 위 `correlationId`가 전달되는 Apex interface.
- [[Salesforce Scheduler — Connect API 요청·응답 표현형·Error Codes]] — Candidates·TimeSlots·Work Type Input·Service Appointment Output 등 Request/Response Body 표현형·Error Codes 상세.
- [[Salesforce Scheduler — ConnectApi LightningScheduler Apex]] — 위 REST 엔드포인트에 대응하는 ConnectApi LightningScheduler Apex 메서드.
- [[Salesforce Scheduler — 커스텀 예약 시나리오 (익명·단일리소스)]] — 이 엔드포인트를 호출하는 예약 시나리오 워크플로우.
- [[Salesforce Scheduler — 커스텀 예약 시나리오 (멀티리소스·동시·공유)]] — 멀티리소스·동시·공유 예약 시나리오 워크플로우.
- [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]] — Scheduler 개요·셋업·인증·데이터 모델.
- [[Salesforce Scheduler 표준객체 — 핵심 예약]] — ServiceAppointment·AssignedResource 등 표준객체.
- [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]] — ServiceResource·ServiceTerritory·Skill·Shift.
- [[Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형]] — AppointmentSchedulingPolicy·OperatingHours·WorkType.
