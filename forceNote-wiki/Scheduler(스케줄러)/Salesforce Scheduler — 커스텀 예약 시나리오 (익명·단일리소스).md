---
tags: [scheduler, salesforce-scheduler, appointment-booking, anonymous-appointment, single-resource, api-scenario]
source: salesforce_scheduler_dev_guide.pdf (Salesforce Scheduler Developer Guide, v67.0 Summer '26); help.salesforce.com "New Connected Apps Can No Longer Be Created in Spring '26" (id=005228017, Tier 2)
created: 2026-06-22
aliases: [익명 예약, anonymous appointment, single-resource appointment, location first, appointment distribution, Scheduler 예약 시나리오]
---

# Salesforce Scheduler — 커스텀 예약 시나리오 (익명·단일리소스)

> Salesforce Scheduler API로 커스텀 예약 앱을 만드는 6개 시나리오 — 익명 예약, 약속 분배, 위치 우선 선택, 익명 약속 수정, 단일 리소스 예약, 약속 수정 — 의 단계별 워크플로우와 각 단계의 HTTP 메서드·URI·요청/응답 JSON.

---

이 노트는 *Salesforce Scheduler Developer Guide* (v67.0 Summer '26) Chapter 12 "Custom Appointment Booking" 중 **시나리오 1–6**을 다룬다. 시나리오 7–11(Multi-Resource·Concurrent·Sharing Availability·Dummy Resource)은 이 노트 범위 밖이다.

> 사용된 API 엔드포인트(`available-territory-slots`, `service-appointments`, `service-territories`, `engagement-channel-types`, `getAppointmentCandidates`, `getAppointmentSlots`)의 레퍼런스는 [[Salesforce Scheduler — Business REST·Connect 엔드포인트]] 참조. 호출되는 객체(`ServiceAppointment`, `AssignedResource` 등)는 [[Salesforce Scheduler 표준객체 — 핵심 예약]] 참조. OAuth 인증·셋업·SOQL은 [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]] 참조.

> [!warning] 인증 방식 — Connected App은 후속(External Client App)으로 대체됨
> 아래 모든 시나리오의 **"Authenticate with a Connected App"** 단계는 PDF 원문 절차를 그대로 보존한 것이다. 그러나 Salesforce는 **Winter '26(신규 org)·Spring '26(전 org)** 부터 **신규 Connected App 생성을 차단**했다 — 오늘 새 통합을 만든다면 Connected App을 새로 생성할 수 없다.
> - **후속 권장:** 신규 통합은 **External Client App(ECA)** 으로 만든다. ECA도 동일한 OAuth 2.0 플로우(access token 발급)를 제공하므로 아래 각 시나리오의 나머지 API 호출 시퀀스·JSON은 그대로 유효하다. **기존 Connected App은 계속 동작**하므로 이미 운영 중인 앱은 마이그레이션 강제 아님.
> - 근거: help.salesforce.com "New Connected Apps Can No Longer Be Created in Spring '26" (id=005228017). ECA vs Connected App 비교: salesforceben.com "External Client vs Connected Apps".

> [!note] PDF 시각 자료
> Chapter 12 전체에는 UI mockup 스크린샷이 매우 많고("Here's how a ... page can look."), 시나리오 4에는 절차 개요 플로우차트("This flowchart provides an overview of the procedure:")가 있다. 이들 스크린샷·플로우차트는 PDF에 이미지로만 존재하며 텍스트로 추출되지 않았다. 이 노트는 API 호출 시퀀스와 JSON만 다루며, 화면·다이어그램은 재현하지 않는다.

## URI 버전 표기에 대하여 [sic]

PDF 원문은 시나리오마다 URI 버전을 다르게 적었다 — 시나리오 1·2·3·4는 `vXX.X`(플레이스홀더) 또는 `v66.0` 혼재, 시나리오 5·6은 `v66.0`. 또한 JSON 응답 내 `attributes.url` 필드의 버전은 `v53.0`/`v55.0`/`v57.0`/`v59.0` 등으로 혼재한다. **이 노트는 원문을 그대로 보존**하며 임의로 통일하지 않는다(`[sic]`).

> Chapter 12 intro (verbatim): "This section demonstrates how to build a seamless appointment booking experience using our Salesforce Scheduler APIs. With these use cases, developers can learn how to build custom scheduling apps with the Salesforce Scheduler APIs. The sample application currently shows an example implementation for simple appointment booking, automatic resource assignment, and anonymous appointment booking. It also shows an example of an appointment booking modification..."

---

## 시나리오 1 — Schedule an Anonymous Appointment

> "Build a scheduling application using Salesforce Scheduler APIs to book an anonymous appointment by assigning service resources automatically. Account users and guest users don't always know the name of the service resource, and sometimes they don't care which resource they're assigned to. You can automatically assign a service resource based on the time slot that a user selects. To protect users' privacy, you can also hide their names on the review appointment page."

단계 시퀀스 (6단계):

1. Authenticate with a Connected App
2. Get Work Type Groups
3. Get Engagement Channels
4. Get Service Territories
5. Get Available Territory Slots
6. Create Service Appointments

### Step 1 — Authenticate with a Connected App

OAuth access token을 받는다.

> Note: "To build a custom appointment scheduling application using Salesforce Scheduler APIs for prospects or unauthenticated users, you must build it using a logged-in user. For example, an integration user or an administrator."

Developer/Enterprise Edition 이상에서 **API Enabled** permission을 확인한다(기본 활성). 참조: Connect REST API Quick Start.

> [!warning] 신규 통합은 Connected App 대신 **External Client App(ECA)** 로 생성한다 — Spring '26부터 신규 Connected App 생성 차단. 상단 인증 방식 경고 참조.

### Step 2 — Get Work Type Groups

`Query()` method on **WorkTypeGroup** object. `toLabel` method로 SOQL 결과를 사용자 언어로 번역할 수 있다(Translate SOQL Query Results).

요청:

```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=SELECT+Id,+Name+From+WorkTypeGroup+Where+isActive+=+true+ORDER+BY+NAME+DESC
```

응답:

```json
{
"totalSize" : 3,
"done" : true,
"records" : [ {
"attributes" : {
"type" : "WorkTypeGroup",
"url" : "/services/data/v59.0/sobjects/WorkTypeGroup/0VSS700000000sLOAQ"
},
"Id" : "0VSS700000000sLOAQ",
"Name" : "Wealth Management"
}, {
"attributes" : {
"type" : "WorkTypeGroup",
"url" : "/services/data/v59.0/sobjects/WorkTypeGroup/0VSS700000000sQOAQ"
},
"Id" : "0VSS700000000sQOAQ",
"Name" : "Loans"
}, {
"attributes" : {
"type" : "WorkTypeGroup",
"url" : "/services/data/v59.0/sobjects/WorkTypeGroup/0VSS700000000sVOAQ"
},
"Id" : "0VSS700000000sVOAQ",
"Name" : "Banking"
} ]
}
```

### Step 3 — Get Engagement Channels

> "An engagement channel is a medium, such as Phone, Video, and In Person that service resources use to meet customers."

Before using engagement channels:

- Enable engagement channels in the Salesforce Scheduler Settings of your instance. See Enable the Scheduling Appointments Using Engagement Channels Setting.
- Set up engagement channels, including setting the required access and creating engagement channels. See Engagement Channels.
- Create the Shift Engagement Channel and Engagement Channel Work Type records for the applicable shifts.
- Define Shift Rules in the scheduling policy. See Define Shift Rules in Scheduling Policy.

GET request on **engagement-channel-types** Connect API.

> Note: "You can filter the engagement channel type results by workTypeGroupIds or workTypeIds."

요청 (filter by workTypeGroupId):

```
https://yourInstance.salesforce.com/services/data/v66.0/connect/scheduling/engagement-channel-types?workTypeGroupIds=0VSS700000000sVOAQ
```

응답:

```json
{
"result" : {
"engagementChannelTypes" : [ {
"contactPointType" : "Video",
"id" : "0eFS70000004CGAMA2",
"name" : "EngagementChannel2",
"workTypeGroupIds" : [ ],
"workTypeIds" : [ ]
}, {
"contactPointType" : "InPerson",
"id" : "0eFS70000004CG5MAM",
"name" : "EngagementChannel1",
"workTypeGroupIds" : [ ],
"workTypeIds" : [ ]
}, {
"contactPointType" : "Video",
"id" : "0eFS70000004CGFMA2",
"name" : "EngagementChannel3",
"workTypeGroupIds" : [ ],
"workTypeIds" : [ ]
} ]
}
}
```

### Step 4 — Get Service Territories

**service-territories** Connect API (GET). search values + work type group ID를 query string으로 전달한다. `radius`, `latitude`, `longitude`, `sortBy`, `sortOrder` 파라미터를 조합할 수 있다.

Resource URI:

```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-territories
```

요청:

```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-territories?workTypeGroupId=0VSS700000000sVOAQ&latitude=44.357422&longitude=-73.193952&radius=5&radiusUnit=mi&sortBy=Distance&sortOrder=asc
```

응답:

```json
{
"result": {
"serviceTerritories": [
{
"city": "Charlotte",
"country": "United States",
"id": "0HhS700000001DYKAY",
"latitude": 44.357422,
"longitude": -73.193952,
"name": "Spear Street Branch",
"operatingHoursId": "0OHS700000001HlOAI",
"postalCode": "05445",
"state": "VT",
"street": "121 Spear Street"
}
]
}
}
```

### Step 5 — Get Available Territory Slots

**available-territory-slots** Connect API (POST). 필수 파라미터 `workTypeGroupId`, `territoryIds`.

Resource URI:

```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/available-territory-slots
```

**기존 사용자(Account)의 경우:** "To consider an existing user's preferred visiting hours, pass accountId in the input request body. The preference is enforced when the Enforce Account's Visiting Hours policy rule is enabled."

요청 (Account):

```json
{
"accountId" : "001S7000001pFlJIAU",
"workTypeGroupId" : "0VSS700000000sVOAQ",
"territoryIds" : [
"0HhS700000001DYKAY"
],
"engagementChannelTypeIds": [
"0eFS70000004CG5MAM"
]
}
```

응답 (Account) — `result.territorySlots[].slots[]`, 각 slot = `endTime`, `engagementChannelTypeIds`, `resources`, `startTime`; 그리고 `territoryId`. PDF는 2023-11-29T19:00 ~ 2023-11-30T21:15 범위의 15분 단위 슬롯 ~40개를 verbatim으로 나열한다. 아래는 대표 2개:

```json
{
"result" : {
"territorySlots" : [ {
"slots" : [{
"endTime" : "2023-11-29T20:00:00.000Z",
"engagementChannelTypeIds" : [ "0eFS70000004CG5MAM" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-11-29T19:00:00.000Z"
}, {
"endTime" : "2023-11-29T20:15:00.000Z",
"engagementChannelTypeIds" : [ "0eFS70000004CG5MAM" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-11-29T19:15:00.000Z"
}
// ... PDF에 15분 단위 슬롯 ~40개 verbatim 나열
],
"territoryId" : "0HhS700000001DYKAY"
} ]
}
}
```

**게스트 사용자(Lead)의 경우:** `accountId` 없음.

요청 (Lead):

```json
{
"workTypeGroupId" : "0VSS700000000sVOAQ",
"territoryIds" : [
"0HhS700000001DYKAY"
],
"engagementChannelTypeIds": [
"0eFS70000004CG5MAM"
]
}
```

응답 (Lead): Account 케이스와 동일한 슬롯 구조(동일 territory, 동일 resource, 동일 슬롯 배열).

이후 단계 본문 노트:

> 3. "Parse the JSON response, and show only the available time slots on the page. Don't show the service resources to maintain their privacy."
> 4. "Write custom code to randomly select a service resource for the appointment based on the time slot that the user selects. This sample code automatically selects a service resource and stores it in serviceResourceId property."
> 5. "Pass the list of service resources available for the selected time slot in resources."

### Step 6 — Create Service Appointments

**service-appointments** Connect API (POST).

> Note: "To keep the service resource private, hide the resource's name on the review appointment page."

Resource URI:

```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-appointments
```

**기존 사용자(Account)의 경우:** "Pass the account ID as parentRecordId in the input request body. Set IsAnonymousBooking to true to indicate that the appointment is anonymous."

요청 (Account):

```json
{
"serviceAppointment": {
"serviceTerritoryId": "0HhS700000001DYKAY",
"parentRecordId" : "001S7000001pFlJIAU",
"schedStartTime" : "2023-11-29T20:00:00.000Z",
"schedEndTime": "2023-11-29T21:00:00.000Z",
"street": "121 Spear Street",
"city": "Charlotte",
"state": "VT",
"postalCode": "05445",
"country": "United States",
"engagementChannelTypeId" : "0eFS70000004CG5MAM",
"extendedFields" : [ {
"name": "IsAnonymousBooking",
"value": "true"
} ]
},
"assignedResources": [
{
"serviceResourceId": "0HnS700000002jAKAQ",
"isRequiredResource": true,
"extendedFields" : []
}
]
}
```

응답 (Account):

```json
{
"result" : {
"assignedResourceIds" : [ "03rS700000000oMIAQ" ],
"serviceAppointmentId" : "08pS700000001G3IAI"
}
}
```

**게스트 사용자(Lead)의 경우:** "Pass the required lead details in the input request body. Set IsAnonymousBooking to true to indicate that the appointment is anonymous."

요청 (Lead):

```json
{
"serviceAppointment": {
"serviceTerritoryId": "0HhS700000001DYKAY",
"schedStartTime" : "2023-11-29T22:15:00.000Z",
"schedEndTime": "2023-11-29T23:15:00.000Z",
"street": "121 Spear Street",
"city": "Charlotte",
"state": "VT",
"postalCode": "05445",
"country": "United States",
"engagementChannelTypeId" : "0eFS70000004CG5MAM",
"extendedFields" : [ {
"name": "IsAnonymousBooking",
"value": "true"
} ]
},
"assignedResources": [
{
"serviceResourceId": "0HnS700000002jGKAQ",
"isRequiredResource": true,
"extendedFields" : []
}
],
"lead": {
"firstName": "Tom",
"lastName": "Smith",
"phone": "(555) 555-1234",
"email": "info@salesforce.com",
"company": "MedLife, Inc.",
"extendedFields" : []
}
}
```

응답 (Lead):

```json
{
"result" : {
"assignedResourceIds" : [ "03rS700000000oRIAQ" ],
"parentRecordId" : "00QS7000000sfcnMAA",
"serviceAppointmentId" : "08pS700000001G8IAI"
}
}
```

마무리: "Create a page to show confirmation when the service appointment is created successfully."

---

## 시나리오 2 — Schedule Anonymous Appointments with Appointment Distribution

> "Build a scheduling app by using Salesforce Scheduler APIs to book anonymous service appointments via phone calls and video conferences within a large, virtual service territory. For territories with too many associated resources, use Appointment Distribution to show only the least consumed resources."

> Before you begin: "Appointment distribution helps to maintain balance and avoid situations where one resource is overloaded with all the meetings while others' calendars remain free."

> Cross-ref: "For more information on modifying Appointment Distribution, see Modify an Anonymous Appointment." (이 노트 시나리오 4)

단계 시퀀스 (7단계):

1. Create a Service Territory
2. Assign Service Territory to Work Types
3. Assign Service Resources
4. Enable Appointment Distribution
5. Authenticate API Calls with Salesforce Scheduler APIs
6. Get Appointment Time Slots
7. Create Service Appointments

### Step 1 — Create a Service Territory (UI 설정)

"Create a large, virtual service territory using Salesforce Scheduler and add service resources. Set the new territory as the secondary territory for service resources. You can assign a relatively large number of service resources to the territory. Use the territory exclusively for virtual appointments via phone calls and video conferences." 참조: Set Up Service Territories in Salesforce Scheduler.

### Step 2 — Assign Service Territory to Work Types (UI 설정)

"To use the new virtual service territory, assign the territory to work types in Salesforce Scheduler." 참조: Assign Service Territories to Work Types in Salesforce Scheduler.

### Step 3 — Assign Service Resources (UI 설정)

"To choose appointment candidates from the new virtual service territory, assign service resources to the territory in Salesforce Scheduler. Set this new territory as the secondary territory for each service resource." 참조: Assign Service Resources to Service Territories in Salesforce Scheduler.

### Step 4 — Enable Appointment Distribution (UI 설정)

"Make resource selection for territories with relatively large numbers of resources easier by setting Appointment Distribution to show only a short list of least-consumed resources from your resource pool." 참조: Enable Appointment Distribution.

### Step 5 — Authenticate API Calls with Salesforce Scheduler APIs

OAuth.

> Note: "You can't modify an existing appointment via a guest user profile. You can use an integration user who has permissions to read and update only the required objects."

API Enabled permission을 확인한다.

### Step 6 — Get Appointment Time Slots

**available-territory-slots** Connect API (POST). 필수 파라미터 `workType`, `territoryIds`. 서비스 리소스 수 제한을 위해 `resourceLimitApptDistribution`에 finite integer를 전달한다.

> Note: "When appointment distribution is enabled, Salesforce Scheduler fetches and shows a list of appointment time slots based on the resource utilisation calculation frequency: monthly, parameter-based, or weekly. The Salesforce Scheduler uses the service resources' utilization score for a specific period to suggest time slots for the least occupied resources. For more information, see How Appointment Distribution Works."

> Tip: "In the custom app, you can hard code most of the parameters, including territoryIds and resourceLimitApptDistribution. Set the territoryIds parameter to the ID of the new virtual territory that you created in the beginning of this procedure. If the new territory is assigned to multiple work types, you can let your end user select a value for workType."

Resource URI:

```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/available-territory-slots
```

**기존 사용자(Account)의 경우:** "To consider an existing user's preferred visiting hours, pass accountId in the input request body. You can also specify the startTime and endTime parameters with the request. The preference is enforced when the Enforce Account's Visiting Hours policy rule is enabled."

요청 (Account):

```json
{
"accountId" : "001B000001McLhMIAV",
"workType" : {
"id": "0VS2x000000PVu5GAG"
},
"resourceLimitApptDistribution" : 10,
"territoryIds" : [
"0Hh2w000000XmoXCAS"
]
}
```

> Note: "Setting a maximum number of resources you want to show for scheduling makes it possible to optimise performance for large territories, such as virtual or tele scenarios."

응답 (Account) — `resourceLimitApptDistribution`=10에 따라 least-consumed 리소스만 반환되며, 각 slot의 `resources`는 **여러 ID 배열**(5개씩)이다:

```json
{
"result" : {
"territorySlots" : [ {
"slots" : [ {
"endTime" : "2021-05-24T17:00:00.000Z",
"resources" : [ "0HnB0000000LVbfKAG", "0HnB0000000TavDKAS",
"0HnB0000000Tav3KAC", "0HnB0000000TauyKAC", "0HnB0000000TavMQAS" ],
"startTime" : "2021-05-24T16:00:00.000Z"
}, {
"endTime" : "2021-05-24T17:30:00.000Z",
"resources" : [ "0HnB0000000Tav3KAC", "0HnB0000000TaozKAL",
"0HnB0000000TavMQAS", "0HnB0000000TaiOKCS", "0HnB0000000TacOLCM" ],
"startTime" : "2021-05-24T16:30:00.000Z"
}, {
"endTime" : "2021-05-24T18:00:00.000Z",
"resources" : [ "0HnB0000000Tav3KAC", "0HnB0000000TauyKAC",
"0HnB0000000LVgfKBG", "0HnB0000000TayMQQS", "0HnB0000000TacOLCM" ],
"startTime" : "2021-05-24T17:00:00.000Z"
}, {
"endTime" : "2021-05-24T18:30:00.000Z",
"resources" : [ "0HnB0000000Tav3KAC", "0HnB0000000TauyKAC",
"0HnB0000000LVgfKBG", "0HnB0000000TayMQQS", "0HnB0000000TacOLCM" ],
"startTime" : "2021-05-24T17:30:00.000Z"
}, {
"endTime" : "2021-05-24T19:00:00.000Z",
"resources" : [ "0HnB0000000LVbfKAG", "0HnB0000000TavDKAS",
"0HnB0000000Tav3KAC", "0HnB0000000TauyKAC", "0HnB0000000TavMQAS" ],
"startTime" : "2021-05-24T18:00:00.000Z"
}, {
"endTime" : "2021-05-24T19:30:00.000Z",
"resources" : [ "0HnB0000000LVbfKAG", "0HnB0000000TavDKAS",
"0HnB0000000Tav3KAC", "0HnB0000000TauyKAC", "0HnB0000000TavMQAS" ],
"startTime" : "2021-05-24T18:30:00.000Z"
}, {
"endTime" : "2021-05-24T20:00:00.000Z",
"resources" : [ "0HnB0000000LVbfKAG", "0HnB0000000TavDKAS",
"0HnB0000000Tav3KAC", "0HnB0000000TauyKAC", "0HnB0000000TavMQAS" ],
"startTime" : "2021-05-24T19:00:00.000Z"
}],
"territoryId" : "0Hh2w000000XmoXCAS"
} ]
}
}
```

**게스트 사용자(Lead)의 경우:**

요청 (Lead):

```json
{
"workType" : {
"id": "0VS2x000000PVu5GAG"
},
"resourceLimitApptDistribution" : 10,
"territoryIds" : [
"0Hh2w000000XmoXCAS"
]
}
```

응답 (Lead): Account 응답과 동일 슬롯 구조/값(동일 7개 슬롯, 동일 multi-resource 배열), 동일 Note 반복.

이후 본문 노트:

> "Write custom code to select the least utilized resource or to randomly select a service resource for the appointment based on the time slot that the user selects."

최소 사용 리소스 선택 sample code: `var serviceResourceId=resources[0]`

랜덤 선택 sample code:

```
var index = Math.floor(Math.random() * Math.floor(resources.length));
var serviceResourceId=resources[index]
```

### Step 7 — Create Service Appointments

**service-appointments** Connect API (POST).

> Note: "To keep the service resource private, hide the resource's name on the review appointment page."

Resource URI:

```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-appointments
```

**기존 사용자(Account)의 경우:** "Pass the account ID as parentRecordId... Set IsAnonymousBooking to true..."

요청 (Account) — `schedStartTime` 값의 `00:00.000+0000` 형식 오류는 PDF 원문 그대로 [sic]:

```json
{
"serviceAppointment": {
"serviceTerritoryId": "0Hh2w000000XmoXCAS",
"parentRecordId" : "001B000001McLhMIAV", //accountId
"schedStartTime" : "2021-05-24T15:30:00:00.000+0000",
"schedEndTime": "2021-05-24T16:30:00.000+0000",
"street": "1 Market Street",
"city": "San Francisco",
"state": "CA",
"postalCode": "94105",
"country": "USA",
"extendedFields" : [ {
"name": "IsAnonymousBooking",
"value": "true"
} ]
},
"assignedResources": [
{
"serviceResourceId": "0HnB0000000LVbfKAG",
"extendedFields" : []
}
]
}
```

응답 (Account):

```json
{
"result" : {
"assignedResourceIds" : [ "0HnB0000000LVbfKAG" ],
"serviceAppointmentId" : "08pB0000000hvR6IAI"
}
}
```

**게스트 사용자(Lead)의 경우:** "Pass the required lead details... Set IsAnonymousBooking to true..."

요청 (Lead) — 동일 `schedStartTime` 형식 오류 보존 [sic]; `assignedResources`에 `isPrimaryResource: true` 추가:

```json
{
"serviceAppointment": {
"serviceTerritoryId": "0Hh2w000000XmoXCAS",
"schedStartTime" : "2021-05-24T15:30:00:00.000+0000",
"schedEndTime": "2021-05-24T16:30:00.000+0000",
"street": "1 Market Street",
"city": "San Francisco",
"state": "CA",
"postalCode": "94105",
"country": "USA",
"extendedFields" : [ {
"name": "IsAnonymousBooking",
"value": "true"
} ]
},
"assignedResources": [
{
"serviceResourceId": "0HnB0000000LVbfKAG",
"isRequiredResource": true,
"isPrimaryResource": true,
"extendedFields" : []
}
],
"lead": {
"firstName": "Mark",
"lastName": "Taylor",
"phone": "012-345-6789",
"email": "mtaylor@company.com",
"company": "Company1",
"extendedFields" : []
}
}
```

응답 (Lead):

```json
{
"result" : {
"assignedResourceIds" : [ "0HnB0000000LVbfKAG" ],
"parentRecordId" : "00QB00000094lOZMAY",
"serviceAppointmentId" : "08pB0000000hvR1IAI"
}
}
```

마무리: "Create a page to show confirmation when the service appointment creation is completed."

---

## 시나리오 3 — Schedule Appointments by Selecting Location First

> "This use case explains how you can build a scheduling app to have the service location selection first in your appointment scheduling experience using Salesforce Scheduler APIs. If you prefer to have the service location selection first, unlike the regular appointment scheduling experience that comes with out-of-the-box scheduler templates, this approach is for you."

단계 시퀀스 (6단계):

1. Enable Maps and Location Services
2. Get Service Territories
3. Get Work Type Groups
4. Get Work Type
5. Get Service Resources
6. Create Service Appointments

### Step 1 — Enable Maps and Location Services (UI 설정)

"Salesforce Scheduler uses maps and location services to search for appointment locations (service territories).." [sic 마침표 중복] 참조: Enable Maps and Location Services in Salesforce Scheduler.

### Step 2 — Get Service Territories

`Query()` on **ServiceTerritory** object. name/city/postal code/state로 검색하며, WHERE 절에 distance condition을 쓸 수 있다(Location-Based SOQL Queries).

요청 (within 1 mile; default 5 miles):

```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=
SELECT City,Country,Id,Name,State FROM ServiceTerritory WHERE DISTANCE(Address,
GEOLOCATION(17.4358411,78.3467857), 'mi') < 1
```

응답:

```json
{
"totalSize": 4,
"done": true,
"records": [
{
"attributes": {
"type": "ServiceTerritory",
"url": "/services/data/v55.0/sobjects/ServiceTerritory/0Hhx000000012oOCAQ"
},
"City": "Hyderabad",
"Country": "India",
"Id": "0Hhx000000012oOCAQ",
"Name": "Apollo Hyderabad",
"State": "TG"
},
{
"attributes": {
"type": "ServiceTerritory",
"url": "/services/data/v55.0/sobjects/ServiceTerritory/0Hhx000000012oRCAQ"
},
"City": "Nanakaramguda",
"Country": "India",
"Id": "0Hhx000000012oRCAQ",
"Name": "Somewhere",
"State": "TG"
},
{
"attributes": {
"type": "ServiceTerritory",
"url": "/services/data/v55.0/sobjects/ServiceTerritory/0Hhx000000012oQCAQ"
},
"City": "Hyderabad",
"Country": "India",
"Id": "0Hhx000000012oQCAQ",
"Name": "Partner Service Territory",
"State": "TG"
},
{
"attributes": {
"type": "ServiceTerritory",
"url": "/services/data/v55.0/sobjects/ServiceTerritory/0Hhx000000012oSCAQ"
},
"City": "Hyderabad",
"Country": "India",
"Id": "0Hhx000000012oSCAQ",
"Name": "JPMC Bank, Hyderabad",
"State": "TG"
}
]
}
```

### Step 3 — Get Work Type Groups (2단계 쿼리)

**3a.** `Query()` on **ServiceTerritoryWorkType** — 선택된 territory의 work type 조회.

요청:

```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=
SELECT+Id,WorkTypeId,WorkType.Name+FROM+ServiceTerritoryWorkType+WHERE+ServiceTerritoryId+=+'0Hhx000000012oSCAQ'
```

응답:

```json
{
"totalSize": 2,
"done": true,
"records": [
{
"attributes": {
"type": "ServiceTerritoryWorkType",
"url":
"/services/data/v55.0/sobjects/ServiceTerritoryWorkType/0VEx00000001CTGGA2"
},
"Id": "0VEx00000001CTGGA2",
"WorkTypeId": "08qx000000014fvAAA",
"WorkType": {
"attributes": {
"type": "WorkType",
"url": "/services/data/v55.0/sobjects/WorkType/08qx000000014fvAAA"
},
"Name": "WT 2"
}
},
{
"attributes": {
"type": "ServiceTerritoryWorkType",
"url":
"/services/data/v55.0/sobjects/ServiceTerritoryWorkType/0VEx00000001Ag4GAE"
},
"Id": "0VEx00000001Ag4GAE",
"WorkTypeId": "08qx000000014fnAAA",
"WorkType": {
"attributes": {
"type": "WorkType",
"url": "/services/data/v55.0/sobjects/WorkType/08qx000000014fnAAA"
},
"Name": "WT 3"
}
}
]
}
```

**3b.** `Query()` on **WorkTypeGroupMember** — work type으로 work type group 조회.

요청:

```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=
SELECT Id,WorkTypeGroupId,WorkTypeId,WorkTypeGroup.Name FROM WorkTypeGroupMember WHERE
WorkTypeId in ('08qx000000014fnAAA','08qx000000014fvAAA')
```

> Note: "You can use the toLabel method to translate the SOQL query results in the language of the user. For more information, see Translate SOQL Query Results."

응답:

```json
{
"totalSize": 2,
"done": true,
"records": [
{
"attributes": {
"type": "WorkTypeGroupMember",
"url": "/services/data/v55.0/sobjects/WorkTypeGroupMember/0Wzx000000013tICAQ"
},
"Id": "0Wzx000000013tICAQ",
"WorkTypeGroupId": "0VSx000000014DmGAI",
"WorkTypeId": "08qx000000014fnAAA",
"WorkTypeGroup": {
"attributes": {
"type": "WorkTypeGroup",
"url": "/services/data/v55.0/sobjects/WorkTypeGroup/0VSx000000014DmGAI"
},
"Name": "WTG 2"
}
},
{
"attributes": {
"type": "WorkTypeGroupMember",
"url": "/services/data/v55.0/sobjects/WorkTypeGroupMember/0Wzx000000013tHCAQ"
},
"Id": "0Wzx000000013tHCAQ",
"WorkTypeGroupId": "0VSx000000014DkGAI",
"WorkTypeId": "08qx000000014fvAAA",
"WorkTypeGroup": {
"attributes": {
"type": "WorkTypeGroup",
"url": "/services/data/v55.0/sobjects/WorkTypeGroup/0VSx000000014DkGAI"
},
"Name": "WTG 1"
}
}
]
}
```

### Step 4 — Get Work Type (2단계 쿼리)

**4a.** `Query()` on **WorkTypeGroupMember** — 선택된 work type group의 work type 조회.

요청:

```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=
SELECT+WorkTypeId,WorkType.Name+FROM+WorkTypeGroupMember+WHERE+WorkTypeGroupId+=+'0VSx000000014DmGAI'
```

응답:

```json
{
"totalSize": 2,
"done": true,
"records": [
{
"attributes": {
"type": "WorkTypeGroupMember",
"url": "/services/data/v55.0/sobjects/WorkTypeGroupMember/0Wzx000000013tICAQ"
},
"WorkTypeId": "08qx000000014fnAAA",
"WorkType": {
"attributes": {
"type": "WorkType",
"url": "/services/data/v55.0/sobjects/WorkType/08qx000000014fnAAA"
},
"Name": "WT 3"
}
},
{
"attributes": {
"type": "WorkTypeGroupMember",
"url": "/services/data/v55.0/sobjects/WorkTypeGroupMember/0Wzx000000013tJCAQ"
},
"WorkTypeId": "08qx000000014fwAAA",
"WorkType": {
"attributes": {
"type": "WorkType",
"url": "/services/data/v55.0/sobjects/WorkType/08qx000000014fwAAA"
},
"Name": "WT 4"
}
}
]
}
```

**4b.** `Query()` on **ServiceTerritoryWorkType** — territory + work type group 기준 default work type.

요청:

```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=
SELECT+WorkTypeId,WorkType.Name+FROM+ServiceTerritoryWorkType+WHERE+ServiceTerritoryId+=+'0Hhx000000012oSCAQ'+AND+WorkTypeId+IN+('08qx000000014fnAAA','08qx000000014fwAAA')
```

응답:

```json
{
"totalSize": 1,
"done": true,
"records": [
{
"attributes": {
"type": "ServiceTerritoryWorkType",
"url":
"/services/data/v55.0/sobjects/ServiceTerritoryWorkType/0VEx00000001Ag4GAE"
},
"WorkTypeId": "08qx000000014fnAAA",
"WorkType": {
"attributes": {
"type": "WorkType",
"url": "/services/data/v55.0/sobjects/WorkType/08qx000000014fnAAA"
},
"Name": "WT 3"
}
}
]
}
```

### Step 5 — Get Service Resources

**getAppointmentCandidates** REST API (POST). 필수 `workTypeGroupId` 또는 `workTypeId`, `territoryIds`.

Resource URI:

```
https://yourInstance.salesforce.com/services/data/vXX.X/scheduling/getAppointmentCandidates
```

**기존 사용자(Account)의 경우:** "To consider an existing user's preferred visiting hours, pass accountId in the input request body. The preference is enforced when the Include Only Required Service Resources and Ignore Excluded Service Resources policy rules are enabled."

요청 (Account) — Using workTypeGroupId:

```json
{
"accountId": "001x0000005DLxpAAG",
"startTime": "2022-04-19T10:30:00.000+0000",
"endTime": "2022-04-19T10:40:00.000+0000",
"workTypeGroupId": "0VSx000000014DmGAI",
"territoryIds": [
"0Hhx000000012oSCAQ"
]
}
```

요청 (Account) — Using workTypeId:

```json
{
"accountId" : "001x0000005DLxpAAG",
"startTime" : "2022-04-19T10:30:00.000+0000",
"endTime" : "2022-04-19T10:40:00.000+0000",
"workType" : {
"id" : "08qx000000014fnAAA"
},
"territoryIds" : ["0Hhx000000012oSCAQ"]
}
```

응답 (Account) — `candidates[]` 배열, 각 candidate = `endTime`, `resources`(단일 ID 배열), `startTime`, `territoryId`. PDF에는 14개 candidate가 모두 동일 시간슬롯(10:30~10:40)·동일 territory(`0Hhx000000012oSCAQ`)이며 resource ID만 다르다(`0Hnx000000006GcCAI`, `...GfCAI`, `...GbCAI`, `...GwCAI`, `...GyCAI`, `...GuCAI`, `...GtCAI`, `...GsCAI`, `...GmCAI`, `...GnCAI`, `...GlCAI`, `...H4CAI`, `...H2CAI`, `...H3CAI`). 대표 1개:

```json
{
"candidates": [
{
"endTime": "2022-04-19T10:40:00.000+0000",
"resources": [
"0Hnx000000006GcCAI"
],
"startTime": "2022-04-19T10:30:00.000+0000",
"territoryId": "0Hhx000000012oSCAQ"
}
// ... PDF에 14개 candidate verbatim (위 resource ID 리스트)
]
}
```

**게스트 사용자(Lead)의 경우:** `accountId` 없음.

요청 (Lead) — Using workTypeGroupId:

```json
{
"startTime": "2022-04-19T10:30:00.000+0000",
"endTime": "2022-04-19T10:40:00.000+0000",
"workTypeGroupId": "0VSx000000014DmGAI",
"territoryIds": [
"0Hhx000000012oSCAQ"
]
}
```

요청 (Lead) — Using workTypeId:

```json
{
"startTime": "2022-04-19T10:30:00.000+0000",
"endTime": "2022-04-19T10:40:00.000+0000",
"workType": {
"id": "08qx000000014fnAAA"
},
"territoryIds": [
"0Hhx000000012oSCAQ"
]
}
```

응답 (Lead): Account와 동일한 14개 candidate(동일 resource ID 리스트, 동일 시간슬롯).

### Step 6 — Create Service Appointments

**service-appointments** Connect API (POST).

Resource URI:

```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-appointments
```

**기존 사용자(Account)의 경우:** "Pass the account ID as parentRecordId... Set status to Scheduled to indicate that the appointment is scheduled." (`status`를 `extendedFields`로 전달 — 익명 아님)

요청 (Account):

```json
{
"serviceAppointment": {
"serviceTerritoryId": "0Hhx000000012oSCAQ",
"parentRecordId": "001x0000005DLxpAAG",
"workTypeId": "08qx000000014fnAAA",
"schedStartTime": "2022-04-19T10:30:00.000+0000",
"schedEndTime": "2022-04-19T10:40:00.000+0000",
"additionalInformation": "Appointment Scheduling Custom App.",
"appointmentType": "Testing Purpose",
"extendedFields": [
{
"name": "status",
"value": "Scheduled"
}
]
},
"assignedResources": [
{
"serviceResourceId": "0Hnx000000006GcCAI",
"isRequiredResource": "true"
}
]
}
```

응답 (Account):

```json
{
"result": {
"assignedResourceIds": [
"03rx00000001uxJAAQ"
],
"serviceAppointmentId": "08px00000001toRAAQ"
}
}
```

**게스트 사용자(Lead)의 경우:** "Pass the required lead details... Set status to Scheduled..."

요청 (Lead):

```json
{
"serviceAppointment": {
"serviceTerritoryId": "0Hhx000000012oSCAQ",
"workTypeId": "08qx000000014fnAAA",
"schedStartTime": "2022-04-19T10:30:00.000+0000",
"schedEndTime": "2022-04-19T10:40:00.000+0000",
"additionalInformation": "Appointment Scheduling Custom App.",
"appointmentType": "Testing Purpose",
"extendedFields": [
{
"name": "status",
"value": "Scheduled"
}
]
},
"assignedResources": [
{
"serviceResourceId": "0Hnx000000006H4CAI",
"isRequiredResource": "true"
}
],
"lead": {
"email": "name@company.com",
"firstName": "FName",
"lastName": "LName",
"company": "CompanyName"
}
}
```

응답 (Lead):

```json
{
"result": {
"assignedResourceIds": [
"03rx00000001uxOAAQ"
],
"parentRecordId": "00Qx0000001cKPoEAM",
"serviceAppointmentId": "08px00000001toWAAQ"
}
}
```

마무리: "Create a page to show confirmation when the service appointment is created successfully."

---

## 시나리오 4 — Modify an Anonymous Appointment

> "This use case explains how to change the service resource of an existing anonymous service appointment by using Salesforce Scheduler APIs. Typically, anonymous appointments are scheduled when users who don't belong to your organization request for appointments. For example, a subscriber of your app requests for an appliance maintenance appointment from your service app. After a service appointment is scheduled by using the anonymous mechanism, the service resource for the appointment can mark themselves unavailable. In that scenario, as an administrator or an appointment orchestrator for your organization, ensure that you modify the anonymous service appointment and assign a different resource to the appointment."

> Note: "For the procedure to be successful, ensure that each unavailable resource marks themselves as absent in Salesforce Scheduler. Otherwise, the API request to retrieve the list of service resources continues to include the resources that are currently unavailable or absent."

> [!note] PDF에 절차 개요 플로우차트 있음 ("This flowchart provides an overview of the procedure:"). 텍스트로 추출되지 않아 이 노트에서는 재현하지 않는다.

단계 시퀀스 (5단계):

1. Authenticate with a Connected App
2. Get Service Appointments
3. Get Service Appointment Details
4. Get Available Resources
5. Update Service Appointments

### Step 1 — Authenticate with a Connected App

OAuth.

> Note: "It's not possible to modify an existing appointment via a guest user profile. You can use an integration user who has permissions to read and update only the required objects."

API Enabled permission을 확인한다.

> [!warning] 신규 통합은 Connected App 대신 **External Client App(ECA)** 로 생성한다 — Spring '26부터 신규 Connected App 생성 차단. 상단 인증 방식 경고 참조.

### Step 2 — Get Service Appointments

`query` on **AssignedResource** object — 특정 리소스 관련 scheduled appointment ID 조회.

요청:

```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=SELECT+ServiceAppointmentId,ServiceResourceId+FROM+AssignedResource+WHERE+ServiceResourceId+=+'ServiceResourceId'+AND+ServiceAppointment.IsAnonymousBooking+=+TRUE
```

응답:

```json
{
"totalSize" : 2,
"done" : true,
"records" : [
{
"attributes" : {
"type" : "AssignedResource",
"url" : "/services/data/v53.0/sobjects/AssignedResource/03rB0000000cBVOIA2"
},
"ServiceAppointmentId" : "08pB0000000aKeYIAU",
"ServiceResourceId" : "0HnB0000000Tav3KAC"
},
{
"attributes" : {
"type" : "AssignedResource",
"url" : "/services/data/v53.0/sobjects/AssignedResource/03rB0000000cBVsIAM"
},
"ServiceAppointmentId" : "08pB0000000aKf2IAE",
"ServiceResourceId" : "0HnB0000000Tav3KAC"
}
]
}
```

> 본문 노트 [sic 마침표 중복]: "Use a collection object to capture all appointment IDs that the GET request retrieved. If you call multiple GET requests, include in the collection object the appointment IDs that each request returned.. This task helps you create a list of service appointments that you must update with new resources."

### Step 3 — Get Service Appointment Details

GET method on **ServiceAppointment** — 각 appointment의 추가 상세 조회.

요청:

```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=SELECT+Id,SchedEndTime,SchedStartTime,ServiceTerritoryId,WorkTypeId+FROM+ServiceAppointment+WHERE+id+=+'08pB0000000aKf2IAE'
```

응답:

```json
{
"totalSize": 1,
"done": true,
"records": [
{
"attributes": {
"type": "ServiceAppointment",
"url": "/services/data/v53.0/sobjects/ServiceAppointment/08pB0000000aKf2IAE"
},
"Id": "08pB0000000aKf2IAE",
"SchedEndTime": "2021-10-25T18:30:00.000+0000",
"SchedStartTime": "2021-10-25T17:30:00.000+0000",
"ServiceTerritoryId": "0HhB0000000TaHOKA0",
"WorkTypeId": "08qB0000000UF63IAG"
}
]
}
```

노트: "Use a collection object to capture all the details of service appointments."

### Step 4 — Get Available Resources

**getAppointmentCandidates** REST API (POST). 필수 `workTypeGroupId`, `territoryIds`, `startTime`, `endTime`.

Resource URI:

```
https://yourInstance.salesforce.com/services/data/vXX.X/scheduling/getAppointmentCandidates
```

Request body 템플릿:

```json
{
"startTime" : startTime,
"endTime" : endTime,
"territoryIds" : [territoryIds]
"workType" :
{
"id": workTypeId
}
}
```

Example request body:

```json
{
"startTime" : "2021-10-25T17:30:00.000+0000",
"accountId" : "001B000001McLhMIAV",
"territoryIds" : ["0HhB0000000TaHOKA0"],
"workType" :
{
"id": "08qB0000000UF63IAG"
}
}
```

응답:

```json
{
"candidates": [
{
"endTime" : "2021-10-25T18:30:00.000+0000",
"resources" : [ "0HnB0000000TavDKAS" ],
"startTime" : "2021-10-25T17:30:00.000+0000",
"territoryId" : "0HhB0000000TaHOKA0"
}, {
"endTime" : "2021-10-25T19:00:00.000+0000",
"resources" : [ "0HnB0000000TavDKAS" ],
"startTime" : "2021-10-25T18:00:00.000+0000",
"territoryId" : "0HhB0000000TaHOKA0"
}, {
"endTime" : "2021-10-25T19:30:00.000+0000",
"resources" : [ "0HnB0000000TavDKAS" ],
"startTime" : "2021-10-25T18:30:00.000+0000",
"territoryId" : "0HhB0000000TaHOKA0"
}, {
"endTime" : "2021-10-25T20:00:00.000+0000",
"resources" : [ "0HnB0000000TavDKAS" ],
"startTime" : "2021-10-25T19:00:00.000+0000",
"territoryId" : "0HhB0000000TaHOKA0"
} ]
}
```

### Step 5 — Update Service Appointments

**service-appointments** Connect API (PATCH). `serviceResourceId`, `serviceAppointmentId` 파라미터.

Resource URI:

```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-appointments
```

요청 — "In the input request body, pass the service appointment ID as serviceAppointmentId and service resource ID as serviceResourceId."

```json
{
"serviceAppointmentId": "08pB0000000aKf2IAE",
"serviceAppointment": {
"schedStartTime": "2021-10-25T17:30:00.000+0000",
"schedEndTime": "2021-10-25T18:30:00.000+0000",
"serviceTerritoryId": "0HhB0000000TaHOKA0"
},
"assignedResources": [
{
"serviceResourceId": "0HnB0000000TavDKAS",
"isRequiredResource": true
}
]
}
```

응답:

```json
{
"result" : {
"assignedResourceIds" : [ "03rB0000000cBVxIAM" ],
"serviceAppointmentId" : "08pB0000000aKf2IAE"
}
}
```

마무리 [sic "needs you want"]: "The request modifies the service appointment with a new service resource. Run the PATCH request for each service appointment ID that needs you want to modify."

---

## 시나리오 5 — Create a Single-Resource Appointment

> "This use case explains how you can build a scheduling website to allow users to book service appointments with a single resource using Salesforce Scheduler APIs."

단계 시퀀스 (6단계):

1. Authenticate with a Connected App
2. Get Work Type Groups
3. Get Engagement Channels
4. Get Service Territories
5. Get Service Resources
6. Create Service Appointments

### Step 1 — Authenticate with a Connected App

OAuth.

> Note: "To build a custom appointment scheduling application using Salesforce Scheduler APIs for prospects or unauthenticated users, you must build it using a logged-in user. For example, an integration user or an administrator."

API Enabled permission을 확인한다.

> [!warning] 신규 통합은 Connected App 대신 **External Client App(ECA)** 로 생성한다 — Spring '26부터 신규 Connected App 생성 차단. 상단 인증 방식 경고 참조.

### Step 2 — Get Work Type Groups

`Query()` on **WorkTypeGroup**.

요청 (URI `v66.0` [sic]):

```
https://yourInstance.salesforce.com/services/data/v66.0/query/?q=SELECT+Id,+Name+From+WorkTypeGroup+Where+isActive+=+true+ORDER+BY+NAME
```

응답:

```json
{
"totalSize": 3,
"done": true,
"records": [
{
"attributes": {
"type": "WorkTypeGroup",
"url": "/services/data/v57.0/sobjects/WorkTypeGroup/0VSS700000000sLOAQ"
},
"Id": "0VSS700000000sLOAQ",
"Name": "Wealth Management"
},
{
"attributes": {
"type": "WorkTypeGroup",
"url": "/services/data/v57.0/sobjects/WorkTypeGroup/0VSS700000000sQOAQ"
},
"Id": "0VSS700000000sQOAQ",
"Name": "Loans"
},
{
"attributes": {
"type": "WorkTypeGroup",
"url": "/services/data/v57.0/sobjects/WorkTypeGroup/0VSS700000000sVOAQ"
},
"Id": "0VSS700000000sVOAQ",
"Name": "Banking"
}
]
}
```

### Step 3 — Get Engagement Channels

시나리오 1과 동일한 설명 및 전제조건 4개 bullet(Enable engagement channels / Set up / Create Shift Engagement Channel·Engagement Channel Work Type / Define Shift Rules).

GET on **engagement-channel-types** Connect API.

요청 (filter by workTypeGroupId):

```
https://yourInstance.salesforce.com/services/data/v66.0/connect/scheduling/engagement-channel-types?workTypeGroupIds=0VSS700000000sVOAQ
```

> Note: "You can filter the engagement channel type results by workTypeGroupIds or workTypeIds."

응답 (시나리오 1과 달리 `workTypeGroupIds`에 실제 ID 채워짐):

```json
{
"result": {
"engagementChannelTypes": [
{
"contactPointType": "InPerson",
"id": "0eFS70000004CG5MAM",
"name": "EngagementChannel1",
"workTypeGroupIds": [
"0VSS700000000sVOAQ"
],
"workTypeIds": []
},
{
"contactPointType": "Video",
"id": "0eFS70000004CGFMA2",
"name": "EngagementChannel3",
"workTypeGroupIds": [
"0VSS700000000sVOAQ"
],
"workTypeIds": []
}
]
}
}
```

### Step 4 — Get Service Territories

**service-territories** Connect API.

요청 (within 10 miles; default 5 miles):

```
https://yourInstance.salesforce.com/services/data/v66.0/connect/scheduling/service-territories?workTypeGroupId=0VSS700000000sVOAQ
```

응답:

```json
{
"result": {
"serviceTerritories": [
{
"city": "Charlotte",
"country": "United States",
"id": "0HhS700000001DYKAY",
"name": "Spear Street Branch",
"operatingHoursId": "0OHS700000001HlOAI",
"postalCode": "05445",
"state": "VT",
"street": "121 Spear Street"
}
]
}
}
```

### Step 5 — Get Service Resources

**getAppointmentCandidates** REST API (POST). 필수 `workTypeGroupId`, `territoryIds`.

Resource URI:

```
https://yourInstance.salesforce.com/services/data/v66.0/scheduling/getAppointmentCandidates
```

요청 — "To consider an existing user's preferred visiting hours, pass accountId... The preference is enforced when the Include Only Required Service Resources and Ignore Excluded Service Resources policy rules are enabled. For more information, see Add Service Resource Preferences to Accounts for Salesforce Scheduler."

```json
{
"startTime": "2023-02-15T09:00:00.000+0000",
"endTime": "2023-02-15T19:00:00.000+0000",
"accountId": "001S7000001pFlJIAU",
"workTypeGroupId": "0VSS700000000sVOAQ",
"territoryIds": [
"0HhS700000001DYKAY"
],
"engagementChannelTypeIds": [
"0eFS70000004CG5MAM"
]
}
```

응답:

```json
{
"candidates" : [ {
"endTime" : "2023-02-15T18:00:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CG5MAM" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-02-15T17:00:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-02-15T18:15:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CG5MAM" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-02-15T17:15:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-02-15T18:30:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CG5MAM" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-02-15T17:30:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-02-15T18:45:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CG5MAM" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-02-15T17:45:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-02-15T19:00:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CG5MAM" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-02-15T18:00:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
} ]
}
```

### Step 6 — Create Service Appointments

**service-appointments** Connect API (POST).

Resource URI:

```
https://yourInstance.salesforce.com/services/data/v66.0/connect/scheduling/service-appointments
```

**기존 사용자(Account)의 경우:** "Pass the account ID as parentRecordId... To indicate that the appointment is scheduled, set status to Scheduled."

요청 (Account):

```json
{
"serviceAppointment": {
"serviceTerritoryId": "0HhS700000001DYKAY",
"parentRecordId": "001S7000001pFlJIAU",
"engagementChannelTypeId": "0eFS70000004CG5MAM",
"schedStartTime": "2023-02-15T17:00:00.000+0000",
"schedEndTime": "2023-02-15T18:00:00.000+0000",
"street": "121 Spear Street",
"city": "Charlotte",
"state": "VT",
"postalCode": "05445",
"country": "United States",
"extendedFields": [
{
"name": "status",
"value": "Scheduled"
}
]
},
"assignedResources": [
{
"serviceResourceId": "0HnS700000002jAKAQ",
"isRequiredResource": true
}
]
}
```

응답 (Account):

```json
{
"result": {
"assignedResourceIds": [
"03rS700000000hPIAQ"
],
"serviceAppointmentId": "08pS7000000018wIAA"
}
}
```

**게스트 사용자(Lead)의 경우:** "Pass the required lead details... To indicate that the appointment is scheduled, set status to Scheduled."

요청 (Lead):

```json
{
"serviceAppointment": {
"serviceTerritoryId": "0HhS700000001DYKAY",
"engagementChannelTypeId": "0eFS70000004CG5MAM",
"schedStartTime": "2023-02-15T17:00:00.000+0000",
"schedEndTime": "2023-02-15T18:00:00.000+0000",
"street": "121 Spear Street",
"city": "Charlotte",
"state": "VT",
"postalCode": "05445",
"country": "United States",
"extendedFields": [
{
"name": "status",
"value": "Scheduled"
}
]
},
"assignedResources": [
{
"serviceResourceId": "0HnS700000002jAKAQ",
"isRequiredResource": true
}
],
"lead": {
"firstName": "Mark",
"lastName": "Taylor",
"phone": "012-345-6789",
"email": "mtaylor@company.com",
"company": "Company1"
}
}
```

응답 (Lead):

```json
{
"result": {
"assignedResourceIds": [
"03rS700000000hUIAQ"
],
"parentRecordId": "00QS7000000sfbOMAQ",
"serviceAppointmentId": "08pS70000000191IAA"
}
}
```

마무리: "Create a page to show confirmation when the service appointment is created successfully."

---

## 시나리오 6 — Modify a Service Appointment

> "Use Salesforce Scheduler APIs to modify a service appointment. This use case explains how you can change the engagement channel, service resource, time slot, or status of an existing appointment. However, you can also modify other details of the appointment in a similar fashion. For example, to change the service territory, use the service-territories Connect API. This topic explains how you can modify an appointment using the custom application that you built for creating appointments."

> Note: "For the procedure to be successful, ensure that each unavailable resource marks themselves as absent in Salesforce Scheduler. Otherwise, the API request to retrieve the list of service resources continues to include the resources that are currently unavailable or absent."

단계 시퀀스 (5단계):

1. Authenticate with a Connected App
2. Get Service Appointments
3. Get Service Appointment Details
4. Change Appointment Details (하위 3개: Change Engagement Channel Type / Change Service Resource / Change Appointment Time)
5. Update Service Appointments

### Step 1 — Authenticate with a Connected App

OAuth.

> Note: "To build a custom appointment scheduling application using Salesforce Scheduler APIs for prospects or unauthenticated users, you must build it using a logged-in user. For example, an integration user or an administrator."

API Enabled permission을 확인한다.

### Step 2 — Get Service Appointments

`Query()` on **ServiceAppointment** — account 관련 appointment 목록.

요청:

```
https://yourInstance.salesforce.com/services/data/v66.0/query/?q=
SELECT+AppointmentNumber,+Status,+SchedStartTime,+SchedEndTime,+ServiceTerritoryId,+WorkTypeId+From+ServiceAppointment+WHERE+AccountId+=+'001S7000001pFlJIAU'
```

응답:

```json
{
"totalSize": 3,
"done": true,
"records": [
{
"attributes": {
"type": "ServiceAppointment",
"url": "/services/data/v57.0/sobjects/ServiceAppointment/08pS70000000196IAA"
},
"AppointmentNumber": "SA-0003",
"Status": "Scheduled",
"SchedStartTime": "2023-03-15T16:00:00.000+0000",
"SchedEndTime": "2023-03-15T17:00:00.000+0000",
"ServiceTerritoryId": "0HhS700000001DYKAY",
"WorkTypeId": null
},
{
"attributes": {
"type": "ServiceAppointment",
"url": "/services/data/v57.0/sobjects/ServiceAppointment/08pS7000000018wIAA"
},
"AppointmentNumber": "SA-0001",
"Status": "Scheduled",
"SchedStartTime": "2023-02-15T17:00:00.000+0000",
"SchedEndTime": "2023-02-15T18:00:00.000+0000",
"ServiceTerritoryId": "0HhS700000001DYKAY",
"WorkTypeId": null
},
{
"attributes": {
"type": "ServiceAppointment",
"url": "/services/data/v57.0/sobjects/ServiceAppointment/08pS7000000019BIAQ"
},
"AppointmentNumber": "SA-0004",
"Status": "Scheduled",
"SchedStartTime": "2023-03-15T18:00:00.000+0000",
"SchedEndTime": "2023-03-15T19:00:00.000+0000",
"ServiceTerritoryId": "0HhS700000001DYKAY",
"WorkTypeId": null
}
]
}
```

### Step 3 — Get Service Appointment Details

GET on **ServiceAppointment** object — 선택된 appointment의 전체 필드.

요청:

```
https://yourInstance.salesforce.com/services/data/v66.0/sobjects/ServiceAppointment/08pS7000000019BIAQ
```

응답 (전체 필드 verbatim):

```json
{
"attributes": {
"type": "ServiceAppointment",
"url": "/services/data/v57.0/sobjects/ServiceAppointment/08pS7000000019BIAQ"
},
"Id": "08pS7000000019BIAQ",
"OwnerId": "005S7000000Ipe4IAC",
"IsDeleted": false,
"AppointmentNumber": "SA-0004",
"CreatedDate": "2023-03-13T17:31:23.000+0000",
"CreatedById": "005S7000000Ipe4IAC",
"LastModifiedDate": "2023-03-13T17:31:23.000+0000",
"LastModifiedById": "005S7000000Ipe4IAC",
"SystemModstamp": "2023-03-13T17:31:28.000+0000",
"LastViewedDate": "2023-03-13T17:31:23.000+0000",
"LastReferencedDate": "2023-03-13T17:31:23.000+0000",
"ParentRecordId": "001S7000001pFlJIAU",
"ParentRecordType": "Account",
"AccountId": "001S7000001pFlJIAU",
"WorkTypeId": "08qS70000004DQsIAM",
"ContactId": null,
"Street": "121 Spear Street",
"City": "Charlotte",
"State": "VT",
"PostalCode": "05445",
"Country": "United States",
"Latitude": 44.356843,
"Longitude": -73.194897,
"GeocodeAccuracy": "Block",
"Address": {
"city": "Charlotte",
"country": "United States",
"geocodeAccuracy": "Block",
"latitude": 44.356843,
"longitude": -73.194897,
"postalCode": "05445",
"state": "VT",
"street": "121 Spear Street"
},
"Description": null,
"EarliestStartTime": "2023-03-13T17:31:23.000+0000",
"DueDate": "2023-03-20T17:31:23.000+0000",
"Duration": null,
"ArrivalWindowStartTime": "2023-03-15T18:00:00.000+0000",
"ArrivalWindowEndTime": "2023-03-15T19:00:00.000+0000",
"Status": "Scheduled",
"SchedStartTime": "2023-03-15T18:00:00.000+0000",
"SchedEndTime": "2023-03-15T19:00:00.000+0000",
"ActualStartTime": null,
"ActualEndTime": null,
"ActualDuration": null,
"DurationType": "Hours",
"DurationInMinutes": null,
"ServiceTerritoryId": "0HhS700000001DYKAY",
"Subject": null,
"ParentRecordStatusCategory": null,
"StatusCategory": "Scheduled",
"ServiceNote": null,
"AppointmentType": null,
"Email": null,
"Phone": null,
"CancellationReason": null,
"AdditionalInformation": null,
"Comments": null,
"IsAnonymousBooking": false,
"IsOffsiteAppointment": false,
"ApptBookingInfoUrl": null,
"AppointmentInvitationId": null,
"EngagementChannelTypeId": "0eFS70000004CG5MAM"
}
```

### Step 4 — Change Appointment Details

> "This section explains how you can show either the engagement channel types, service resources, or time slots page based on what the user chooses to change for the appointment."

#### 4a. Change Engagement Channel Type

전제조건 4개 bullet(시나리오 1·5와 동일: Enable engagement channels / Set up / Create Shift Engagement Channel·Engagement Channel Work Type / Define Shift Rules).

1. GET on **engagement-channel-types** API — 필수 `workTypeId` 또는 `workTypeGroupId`.

요청 (work type record로 filter):

```
https://yourInstance.salesforce.com/services/data/v66.0/connect/scheduling/engagement-channel-types?workTypeIds=08qS70000004DQsIAM
```

응답:

```json
{
"result" : {
"engagementChannelTypes" : [ {
"contactPointType" : "InPerson",
"id" : "0eFS70000004CG5MAM",
"name" : "EngagementChannel1",
"workTypeGroupIds" : [ ],
"workTypeIds" : [ "08qS70000004DQsIAM" ]
}, {
"contactPointType" : "Video",
"id" : "0eFS70000004CGFMA2",
"name" : "EngagementChannel3",
"workTypeGroupIds" : [ ],
"workTypeIds" : [ "08qS70000004DQsIAM" ]
} ]
}
}
```

3. "Make a GET request to the getAppointmentSlots REST API to see if the appointment's original time slot is still available for the changed engagement channel type. Otherwise, show the available time slots for the selected engagement channel and allow your users to select a time slot. See Change Appointment Time."

#### 4b. Change Service Resource

**getAppointmentCandidates** REST API (POST). 필수 `workTypeId`, `territoryIds`.

Resource URI:

```
https://yourInstance.salesforce.com/services/data/v66.0/scheduling/getAppointmentCandidates
```

요청 — "To consider an existing user's preferred visiting hours, pass accountId... The preference is enforced when the Include Only Required Service Resources and Ignore Excluded Service Resources policy rules are enabled. For more information, see Add Service Resource Preferences to Accounts for Salesforce Scheduler." (이 요청에 `schedulingPolicyId` 포함; 값 `2F0VrRM0000004CUV`의 `2F` prefix는 PDF 원문 그대로 [sic]):

```json
{
"startTime": "2023-03-24T09:00:00.000+0000",
"endTime": "2023-03-24T19:00:00.000+0000",
"accountId": "001S7000001pFlJIAU",
"workType": {
"id": "08qS70000004DQsIAM"
},
"territoryIds": [
"0HhS700000001DYKAY"
],
"schedulingPolicyId": "2F0VrRM0000004CUV",
"engagementChannelTypeIds": [
"0eFS70000004CGFMA2"
]
}
```

응답:

```json
{
"candidates" : [ {
"endTime" : "2023-03-24T17:00:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CGFMA2" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-03-24T16:00:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-03-24T17:15:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CGFMA2" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-03-24T16:15:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-03-24T17:30:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CGFMA2" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-03-24T16:30:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-03-24T17:45:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CGFMA2" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-03-24T16:45:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-03-24T18:00:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CGFMA2" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-03-24T17:00:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-03-24T18:15:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CGFMA2" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-03-24T17:15:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-03-24T18:30:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CGFMA2" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-03-24T17:30:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-03-24T18:45:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CGFMA2" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-03-24T17:45:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-03-24T19:00:00.000+0000",
"engagementChannelTypeIds" : [ "0eFS70000004CGFMA2" ],
"resources" : [ "0HnS700000002jAKAQ" ],
"startTime" : "2023-03-24T18:00:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
} ]
}
```

#### 4c. Change Appointment Time

**getAppointmentSlots** REST API (POST). 필수 `workTypeGroupId` 또는 `workTypeId` + `.territoryId`(앞 점 [sic]).

Resource URI:

```
https://yourInstance.salesforce.com/services/data/v66.0/scheduling/getAppointmentSlots
```

요청 — Using the WorkTypeId parameter:

```json
{
"workType": {
"id": "08qS70000004DQsIAM"
},
"territoryIds": [
"0HhS700000001DYKAY"
],
"requiredResourceIds": [
"0HnS700000002jAKAQ"
],
"accountId": "001S7000001pFlJIAU",
"schedulingPolicyId": "2F0VrRM0000004CUV",
"engagementChannelTypeIds": [
"0eFS70000004CGFMA2"
]
}
```

요청 — Using the WorkTypeGroupId parameter:

```json
{
"workTypeGroupId": "0VS2x0000008ZotGAE",
"accountId": "001S7000001pFlJIAU",
"schedulingPolicyId": "2F0VrRM0000004CUV",
"territoryIds": [
"0HhS700000001DYKAY"
],
"requiredResourceIds": [
"0HnS700000002jAKAQ"
],
"engagementChannelTypeIds": [
"0eFS70000004CGFMA2"
]
}
```

응답 — 응답 구조는 `timeSlots[]`이며 각 항목은 `endTime`, `remainingAppointments`, `startTime`, `territoryId`로 구성된다(다른 step 응답과 달리 `remainingAppointments` 필드 존재):

```json
{
"timeSlots" : [ {
"endTime" : "2023-03-26T17:55:00.000+0000",
"remainingAppointments" : 1,
"startTime" : "2023-03-26T17:30:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-03-30T16:55:00.000+0000",
"remainingAppointments" : 1,
"startTime" : "2023-03-30T16:30:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-04-02T16:55:00.000+0000",
"remainingAppointments" : 1,
"startTime" : "2023-04-02T16:30:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
}, {
"endTime" : "2023-04-04T18:25:00.000+0000",
"remainingAppointments" : 1,
"startTime" : "2023-04-04T18:00:00.000+0000",
"territoryId" : "0HhS700000001DYKAY"
} ]
}
```

### Step 5 — Update Service Appointments

**service-appointments** Connect API (PATCH).

Resource URI:

```
https://yourInstance.salesforce.com/services/data/v66.0/connect/scheduling/service-appointments
```

> Note: "Specify the scheduling policy ID in which the shift is defined. Additionally, pass the parameters including the standard and custom fields that are not available in the input parameters list as extended fields. Edit access on these fields is required to update their values. For example, pass the status field as extended fields with its value set to Canceled to indicate that the appointment is canceled."

요청 — Update Service Resource and engagement channel type:

```json
{
"serviceAppointmentId": "08pS7000000019BIAQ",
"schedulingPolicyId": "2F0VrRM0000004CUV",
"serviceAppointment": {
"schedStartTime": "2023-03-24T18:00:00.000+0000",
"schedEndTime": "2023-03-24T19:00:00.000+0000",
"serviceTerritoryId": "0HhS700000001DYKAY",
"engagementChannelTypeId": "0eFS70000004CGFMA2",
"workTypeId": "08qS70000004DQsIAM"
},
"assignedResources": [
{
"serviceResourceId": "0HnS700000002jAKAQ",
"isRequiredResource": true,
"extendedFields": []
}
]
}
```

요청 — Update Time Slot ([sic] `schedEndTime` 뒤 trailing comma 보존):

```json
{
"serviceAppointmentId": "08pS7000000019BIAQ",
"serviceAppointment": {
"schedStartTime": "2023-03-24T18:00:00.000+0000",
"schedEndTime": "2023-03-24T19:00:00.000+0000",
}
}
```

요청 — Update Appointment Status:

```json
{
"serviceAppointmentId": "08pS7000000019BIAQ",
"serviceAppointment": {
"extendedFields": [{
"name": "status",
"value": "Canceled"
}]
}
}
```

응답:

```json
{
"result": {
"assignedResourceIds": [
"03rS700000000heIAA"
],
"serviceAppointmentId": "08pS7000000019BIAQ"
}
}
```

마무리: "Create a page to show confirmation when the service appointment is modified successfully."

---

## 시나리오 비교

| 시나리오 | 동작 | 핵심 API | 특징 |
|---|---|---|---|
| 1. Anonymous Appointment | 생성 | available-territory-slots, service-appointments | `IsAnonymousBooking=true`, 리소스 자동 할당·이름 숨김 |
| 2. Anonymous + Appointment Distribution | 생성 | available-territory-slots, service-appointments | `resourceLimitApptDistribution`로 least-consumed 리소스만, slot당 multi-resource |
| 3. Location First | 생성 | (SOQL) ServiceTerritory, getAppointmentCandidates, service-appointments | territory 선택을 먼저, `status=Scheduled` (익명 아님) |
| 4. Modify Anonymous Appointment | 수정 | getAppointmentCandidates, service-appointments (PATCH) | 불가용 리소스 교체, guest profile로는 수정 불가 |
| 5. Single-Resource Appointment | 생성 | getAppointmentCandidates, service-appointments | engagement channel 사용, 단일 리소스 |
| 6. Modify a Service Appointment | 수정 | getAppointmentCandidates, getAppointmentSlots, service-appointments (PATCH) | engagement channel·resource·time slot·status 변경, `schedulingPolicyId` 필수 |

> 표는 본문 시나리오 요약 — 정확한 파라미터·JSON은 각 시나리오 본문 참조.

---

## 관련 노트

- [[Salesforce Scheduler — Business REST·Connect 엔드포인트]] — 이 시나리오가 호출하는 endpoint(available-territory-slots, service-appointments, service-territories, engagement-channel-types, getAppointmentCandidates, getAppointmentSlots) 레퍼런스
- [[Salesforce Scheduler — Connect API 요청·응답 표현형·Error Codes]] — 이 시나리오의 요청/응답 Body 표현형·Error Codes
- [[Salesforce Scheduler — ConnectApi LightningScheduler Apex]] — 동일 흐름의 Apex(ConnectApi LightningScheduler) 표면
- [[Salesforce Scheduler — 커스텀 예약 시나리오 (멀티리소스·동시·공유)]] — 멀티리소스·동시·공유 등 나머지 예약 시나리오
- [[Salesforce Scheduler 표준객체 — 핵심 예약]] — ServiceAppointment, AssignedResource 등 호출 대상 객체
- [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]] — OAuth 인증, 셋업, SOQL 쿼리
- [[Salesforce Scheduler 표준객체 — 정책·운영시간·작업유형]] — WorkType, WorkTypeGroup, scheduling policy, operating hours
- [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]] — ServiceResource, ServiceTerritory, Shift, Engagement Channel
