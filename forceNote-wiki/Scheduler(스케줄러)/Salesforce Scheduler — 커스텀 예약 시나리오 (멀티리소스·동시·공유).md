---
tags: [scheduler, salesforce-scheduler, appointment-booking, multi-resource, concurrent-appointment, api-scenario]
source: salesforce_scheduler_dev_guide.pdf (Salesforce Scheduler Developer Guide, v67.0 Summer '26); Tier 2 보강 — Salesforce Help "New Connected Apps Can No Longer Be Created in Spring '26" (help.salesforce.com id=005228017)
created: 2026-06-22
aliases: [멀티리소스 예약, multi-resource appointment, concurrent appointment, sharing availability, dummy resource, Scheduler 예약 시나리오]
---

# Salesforce Scheduler — 커스텀 예약 시나리오 (멀티리소스·동시·공유)

> Salesforce Scheduler API로 커스텀 예약 앱을 구축하는 5개 시나리오 — Multi-Resource 예약·수정, Concurrent 예약, Sharing Availability(초대 URL), Dummy Resource 예약 후 재배정 — 의 단계별 워크플로우·HTTP 메서드·Resource URI·요청/응답 JSON 정본. (소스 Developer Guide Ch12 시나리오 7–11)

---

> **시각 자료 안내:** 각 시나리오에는 PDF 원문에 *"Here's how that page can look"* / *"Here's a sample confirmation page"* 형태의 **UI mockup 스크린샷**이 다수 포함돼 있다. pdftotext는 이미지를 추출하지 않으므로 본 노트에는 화면을 재현하지 않고 `(PDF에 화면 예시 있음)`으로만 표시한다.

> **버전 표기 안내:** 본문 Resource URI는 대부분 `vXX.X` placeholder다. 응답 JSON 내 `attributes.url`에는 캡처 당시 버전(v53.0·v55.0·v56.0·v59.0)이 섞여 있어 verbatim 보존했다. 시나리오 11은 URI에 실제 `v66.0`을 사용한다. `[sic]` 표시는 PDF 원문 오기를 그대로 보존했음을 뜻한다.

---

## 시나리오 7 — Create a Multi-Resource Appointment

여러 required service resource를 포함하는 **multi-resource service appointment**를 예약하는 앱을 구축한다.

> **Note:** A multi-resource appointment can have a maximum of **five required service resources: one primary required service resource plus four required service resources, including asset resources.**

전제: 앱 구축 전 *Set Up Salesforce Scheduler*를 완료한다.

**고수준 단계 (10):**
1. Considerations for Multi-Resource Scheduling
2. Enable Multi-Resource Scheduling
3. Update Field Level Security for Multi-Resource Scheduling
4. Authenticate with a Connected App
5. Get Work Type Groups
6. Get Engagement Channels
7. Get Service Territories
8. Get Appointment Candidates
9. Get Appointment Time Slots
10. Create Service Appointments

### 1. Considerations for Multi-Resource Scheduling

multi-resource scheduling에서 **primary service resource**가 appointment를 anchor하며 required로 표시돼야 한다. **Primary service resource만**이 appointment의 skill requirement에 매칭되는 유일한 required resource다. 다른 required service resource는 자신의 availability와 primary resource의 service territory를 기준으로 매칭된다.

PDF 원문 매트릭스(셀별 매핑 — row = 매칭 기준, col = service resource 유형, unique 값 `Yes`/`No` 2종):

| Matches On | Primary Service Resource | Required Service Resource |
|---|---|---|
| Skill Requirements | Yes | No |
| Service Territory | Yes | Yes |
| Availability in Time Slots | Yes | Yes |

### 2. Enable Multi-Resource Scheduling

1. From Setup, in the Quick Find box, enter **Salesforce Scheduler**, then select **Salesforce Scheduler Settings**.
2. Enable **Multi-Resource Scheduling**.
3. Save your changes.

### 3. Update Field Level Security for Multi-Resource Scheduling

Assigned Resource 객체의 **Primary Resource** 필드 FLS를 업데이트한다.

1. From Setup, open **Object Manager**.
2. Click **Assigned Resource** to open it.
3. Click **Fields & Relationships**, then select **Primary Resource**.
4. Click **Set Field-Level Security**.
5. Select the **Visible** checkbox for all profiles that need access (including System Administrator).
6. Save your changes.

### 4. Authenticate with a Connected App

OAuth access token으로 연결한다 (SOAP/REST API 호출의 가장 안전한 인증 방식).

> [!warning] 후속 권장: External Client App (ECA)
> Spring '26부터 **신규 Connected App 생성이 차단**된다. 신규 org·신규 통합은 Connected App 대신 **External Client App(ECA)**로 OAuth 인증을 구성해야 한다. 이미 존재하는 Connected App은 계속 사용·수정 가능하므로 아래 절차는 기존 앱 기준으로만 유효하다.
> 근거: [New Connected Apps Can No Longer Be Created in Spring '26](https://help.salesforce.com/s/articleView?id=005228017&type=1) (Tier 2 · Salesforce Help)

> **Note:** prospects/unauthenticated user용 앱은 반드시 **logged-in user**(integration user 또는 administrator)로 구축한다.

Developer/Enterprise Edition 이상이면 **API Enabled** 권한을 확인한다(기본 활성).

### 5. Get Work Type Groups

work type group = 일반 appointment 카테고리/토픽(home loan, investment 등). WorkTypeGroup 객체의 **Query()** 메서드를 사용한다.

**Sample Request:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=SELECT+Id,+Name+From+WorkTypeGroup
+Where+isActive+=+true+ORDER+BY+NAME+DESC
```

> `toLabel` 메서드로 SOQL 결과를 사용자 언어로 번역할 수 있다.

**Sample Response:**
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
JSON 파싱 후 페이지에 표시한다. (PDF에 화면 예시 있음)

### 6. Get Engagement Channels

engagement channel = 매체(Phone, Video, In Person 등). 사용 전 전제:
- Salesforce Scheduler Settings에서 engagement channel 활성화
- engagement channel 설정 (required access, channel 생성)
- 적용 shift에 대해 **Shift Engagement Channel** 및 **Engagement Channel Work Type** 레코드 생성
- scheduling policy에 Shift Rules 정의

**engagement-channel-types** Connect API에 **GET** 요청한다.

**Sample Request:** (이전 단계 workTypeGroupId로 필터)
```
https://yourInstance.salesforce.com/services/data/v66.0/connect/scheduling
/engagement-channel-types?workTypeGroupIds=0VSS700000000sVOAQ
```
> **Note:** `workTypeGroupIds` 또는 `workTypeIds`로 필터할 수 있다.

**Sample Response:**
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

### 7. Get Service Territories

service territory = 지점/사무소 위치. **service-territories** Connect API에 **GET** 요청한다. 사용자 검색값 + 선택한 work type group ID를 query string으로 전달하며, `radius`·`latitude`·`longitude`·`sortBy`·`sortOrder`를 조합할 수 있다.

**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-territories
```
**Sample Request:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-territories?workTypeGroupId=0VSS700000000sVOAQ
&latitude=44.357422&longitude=-73.193952&radius=5&radiusUnit=mi&sortBy=Distance&sortOrder=asc
```
**Sample Response:**
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
(PDF에 Select Service Territory 화면 예시 있음)

### 8. Get Appointment Candidates

service resource = 직원(loan officer, investment advisor, doctor 등). **getAppointmentCandidates** REST API에 **POST** — required `workTypeGroupId`, `territoryIds`.

**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/scheduling/getAppointmentCandidates
```

**For an Existing User (Account):** 기존 사용자의 preferred visiting hours를 고려하려면 `accountId`를 request body에 전달한다. **Include Only Required Service Resources** 및 **Ignore Excluded Service Resources** policy rule이 활성일 때 적용된다.

**Sample Request (Account):**
```json
{
"startTime" : "2023-11-01T09:00:00.000+0000",
"endTime" : "2023-11-25T19:00:00.000+0000",
"accountId" : "001S7000001pFlJIAU",
"workTypeGroupId" : "0VSS700000000sVOAQ",
"territoryIds" : ["0HhS700000001DYKAY"],
"engagementChannelTypeIds": [
"0eFS70000004CG5MAM"
]
}
```
**Sample Response (Account)** — 7개 candidate (start 17:00~18:30, 15분 간격, end는 +1h):
```json
{
"candidates": [
{ "endTime": "2023-11-24T18:00:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "resources": ["0HnS700000002jAKAQ"], "startTime": "2023-11-24T17:00:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-11-24T18:15:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "resources": ["0HnS700000002jAKAQ"], "startTime": "2023-11-24T17:15:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-11-24T18:30:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "resources": ["0HnS700000002jAKAQ"], "startTime": "2023-11-24T17:30:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-11-24T18:45:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "resources": ["0HnS700000002jAKAQ"], "startTime": "2023-11-24T17:45:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-11-24T19:00:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "resources": ["0HnS700000002jAKAQ"], "startTime": "2023-11-24T18:00:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-11-24T19:15:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "resources": ["0HnS700000002jAKAQ"], "startTime": "2023-11-24T18:15:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-11-24T19:30:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "resources": ["0HnS700000002jAKAQ"], "startTime": "2023-11-24T18:30:00.000+0000", "territoryId": "0HhS700000001DYKAY" }
]
}
```

**For a Guest User (Lead):** `accountId` 없이 요청한다.

**Sample Request (Guest/Lead):**
```json
{
"startTime" : "2023-11-01T09:00:00.000+0000",
"endTime" : "2023-11-25T19:00:00.000+0000",
"workTypeGroupId" : "0VSS700000000sVOAQ",
"territoryIds" : ["0HhS700000001DYKAY"],
"engagementChannelTypeIds": [
"0eFS70000004CG5MAM"
]
}
```
**Sample Response (Guest/Lead):** Account 케이스와 동일한 7개 candidate 슬롯(17:00~18:30 start, 동일 구조·동일 ID).

(PDF에 Select Service Resource 화면 예시 있음)

### 9. Get Appointment Time Slots

time slot = appointment 가능한 하루 중 기간. **getAppointmentSlots** REST API에 **POST** — 선택한 required resource(asset 포함) + workTypeGroupId + territoryId를 전달한다.

**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/scheduling/getAppointmentSlots
```
**Sample Request:**
```json
{
"startTime" : "2023-11-30T09:00:00.000+0000",
"endTime" : "2023-12-01T23:30:00.000+0000",
"accountId" : "001S7000001pFlJIAU",
"workTypeGroupId" : "0VSS700000000sVOAQ",
"territoryIds" : ["0HhS700000001DYKAY"],
"engagementChannelTypeIds": [
"0eFS70000004CG5MAM"
],
"primaryResourceId" : "0HnS700000002jAKAQ",
"requiredResourceIds" : ["0HnS700000002jKKAQ"]
}
```
**Sample Response** — 9개 timeSlot (start 17:00~01:00, 1h 간격, `remainingAppointments` 1):
```json
{
"timeSlots": [
{ "endTime": "2023-11-30T18:00:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "remainingAppointments": 1, "startTime": "2023-11-30T17:00:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-11-30T19:00:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "remainingAppointments": 1, "startTime": "2023-11-30T18:00:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-11-30T20:00:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "remainingAppointments": 1, "startTime": "2023-11-30T19:00:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-11-30T21:00:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "remainingAppointments": 1, "startTime": "2023-11-30T20:00:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-11-30T22:00:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "remainingAppointments": 1, "startTime": "2023-11-30T21:00:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-11-30T23:00:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "remainingAppointments": 1, "startTime": "2023-11-30T22:00:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-12-01T00:00:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "remainingAppointments": 1, "startTime": "2023-11-30T23:00:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-12-01T01:00:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "remainingAppointments": 1, "startTime": "2023-12-01T00:00:00.000+0000", "territoryId": "0HhS700000001DYKAY" },
{ "endTime": "2023-12-01T02:00:00.000+0000", "engagementChannelTypeIds": ["0eFS70000004CG5MAM"], "remainingAppointments": 1, "startTime": "2023-12-01T01:00:00.000+0000", "territoryId": "0HhS700000001DYKAY" }
]
}
```
(PDF에 Select Service Appointment Time 화면 예시 있음)

> **Note:** multi-resource appointment는 최대 5 required resource(primary 1 + required 4, asset 포함)를 가질 수 있다.

### 10. Create Service Appointments

service appointment = Scheduler로 예약된 appointment. **service-appointments** Connect API에 **POST**한다.

**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-appointments
```

**For an Existing User (Account):** account ID를 `parentRecordId`로 전달하고 status를 Scheduled로 설정한다.

**Sample Request (Account):**
```json
{
"serviceAppointment": {
"serviceTerritoryId": "0HhS700000001DYKAY",
"parentRecordId" : "001S7000001pFlJIAU",
"schedStartTime" : "2023-11-30T17:00:00.000+0000",
"schedEndTime": "2023-11-30T18:00:00.000+0000",
"street": "121 Spear Street",
"city": "Charlotte",
"state": "VT",
"postalCode": "05445",
"country": "United States",
"engagementChannelTypeId" : "0eFS70000004CG5MAM",
"extendedFields" : [{
"name": "status",
"value": "Scheduled"
}]
},
"assignedResources": [
{
"serviceResourceId": "0HnS700000002jAKAQ",
"isRequiredResource": true,
"isPrimaryResource": true,
"extendedFields" : []
}, {
"serviceResourceId": "0HnS700000002jKKAQ",
"isRequiredResource": true,
"isPrimaryResource": false,
"extendedFields" : []
}
]
}
```
**Sample Response (Account):**
```json
{
"result": {
"assignedResourceIds": [
"03rS700000000ogIAA",
"03rS700000000ohIAA"
],
"serviceAppointmentId": "08pS700000001GIIAY"
}
}
```

**For a Guest User (Lead):** lead 상세를 전달하고 status를 Scheduled로 설정한다.

**Sample Request (Lead):**
```json
{
"serviceAppointment": {
"serviceTerritoryId": "0HhS700000001DYKAY",
"schedStartTime" : "2023-11-30T17:00:00.000+0000",
"schedEndTime": "2023-11-30T18:00:00.000+0000",
"street": "121 Spear Street",
"city": "Charlotte",
"state": "VT",
"postalCode": "05445",
"country": "United States",
"engagementChannelTypeId" : "0eFS70000004CG5MAM",
"extendedFields" : [{
"name": "status",
"value": "Scheduled"
}]
},
"assignedResources": [
{
"serviceResourceId": "0HnS700000002jAKAQ",
"isRequiredResource": true,
"isPrimaryResource": true,
"extendedFields" : []
}, {
"serviceResourceId": "0HnS700000002jKKAQ",
"isRequiredResource": true,
"isPrimaryResource": false,
"extendedFields" : []
}
] ,
"lead": {
"firstName": "Philip",
"lastName": "Taylor",
"phone": "012-345-6789",
"email": "pmtaylor@company.com",
"company": "Philip&Taylor Company",
"extendedFields" : []
}
}
```
**Sample Response (Lead):**
```json
{
"result": {
"assignedResourceIds": [
"03rS700000000oqIAA",
"03rS700000000orIAA"
],
"parentRecordId": "00QS7000000sfcxMAA",
"serviceAppointmentId": "08pS700000001GSIAY"
}
}
```
성공 시 confirmation 페이지를 표시한다. (PDF에 화면 예시 있음)

---

## 시나리오 8 — Modify a Multi-Resource Service Appointment

기존 multi-resource appointment의 **secondary service resource** 또는 **time slot**을 변경한다. 시나리오 7에서 만든 커스텀 앱을 활용한다.

핵심 제약:
- resource 변경 시 추가 challenge — time slot이 특정 work type group/service territory 내 resource availability와 일치해야 한다.
- 적용 케이스: secondary resource가 자신을 absent로 표시한 경우 → 가용 resource로 업데이트. **absent resource는 반드시 Salesforce Scheduler에서 absent로 표시**해야 한다. 안 하면 service resource 목록 API가 현재 unavailable/absent resource를 계속 포함한다.
- 이 use case는 **secondary resource만** 수정한다. **primary resource는 이 단계로 수정 불가** — primary를 변경하려면 원래 appointment를 먼저 삭제하고 가용 resource를 primary로 한 새 appointment를 생성한다.

> **Note:** Multi-resource appointment는 **concurrent scheduling 기능이 활성일 때 작동하지 않는다.** concurrent scheduling 기능이 비활성인지 확인한다.

**고수준 단계 (5):**
1. Authenticate with Salesforce Scheduler APIs
2. Get Service Appointments
3. Get Service Appointment Details
4. Change Appointment Details (Change Appointment Candidates / Change Appointment Time Slots 중 택1)
5. Update Service Appointments

### 1. Authenticate with Salesforce Scheduler APIs

OAuth access token으로 인증한다.

> **Note:** **guest user profile로 기존 appointment 수정 불가.** 필요한 객체에 read/update 권한을 가진 **integration user**를 사용한다.

### 2. Get Service Appointments

ServiceAppointment 객체에 **query** 요청한다. 로그인 사용자의 service appointment 표시 페이지를 생성한다.

**Sample Request:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=SELECT+AppointmentNumber,
+Id,+Status,+SchedStartTime,+SchedEndTime,+ServiceTerritoryId,+WorkTypeId+From+ServiceAppointment+WHERE+AccountId+=+'001B000001McLhMIAV'
```
**Sample Response** (totalSize 5):
```json
{
"totalSize" : 5,
"done" : true,
"records" : [ {
"attributes" : { "type" : "ServiceAppointment", "url" : "/services/data/v53.0/sobjects/ServiceAppointment/08pB0000000aKe4IAE" },
"AppointmentNumber" : "SA-41906", "Id" : "08pB0000000aKe4IAE", "Status" : "Scheduled",
"SchedStartTime" : "2021-10-25T15:00:00.000+0000", "SchedEndTime" : "2021-10-25T16:00:00.000+0000",
"ServiceTerritoryId" : "0HhB0000000TakhKAC", "WorkTypeId" : null
}, {
"attributes" : { "type" : "ServiceAppointment", "url" : "/services/data/v53.0/sobjects/ServiceAppointment/08pB0000000aKesIAE" },
"AppointmentNumber" : "SA-41911", "Id" : "08pB0000000aKesIAE", "Status" : "Scheduled",
"SchedStartTime" : "2021-10-25T15:00:00.000+0000", "SchedEndTime" : "2021-10-25T16:00:00.000+0000",
"ServiceTerritoryId" : "0HhB0000000TaHOKA0", "WorkTypeId" : null
}, {
"attributes" : { "type" : "ServiceAppointment", "url" : "/services/data/v53.0/sobjects/ServiceAppointment/08pB0000000aKexIAE" },
"AppointmentNumber" : "SA-41912", "Id" : "08pB0000000aKexIAE", "Status" : "Scheduled",
"SchedStartTime" : "2021-10-22T16:30:00.000+0000", "SchedEndTime" : "2021-10-22T18:00:00.000+0000",
"ServiceTerritoryId" : "0HhB0000000TakhKAC", "WorkTypeId" : null
}, {
"attributes" : { "type" : "ServiceAppointment", "url" : "/services/data/v53.0/sobjects/ServiceAppointment/08pB0000000aKf2IAE" },
"AppointmentNumber" : "SA-41913", "Id" : "08pB0000000aKf2IAE", "Status" : "Scheduled",
"SchedStartTime" : "2021-10-25T17:30:00.000+0000", "SchedEndTime" : "2021-10-25T18:30:00.000+0000",
"ServiceTerritoryId" : "0HhB0000000TaHOKA0", "WorkTypeId" : "08qB0000000UF63IAG"
}, {
"attributes" : { "type" : "ServiceAppointment", "url" : "/services/data/v53.0/sobjects/ServiceAppointment/08pB0000000aKf7IAE" },
"AppointmentNumber" : "SA-41914", "Id" : "08pB0000000aKf7IAE", "Status" : "Scheduled",
"SchedStartTime" : "2021-10-22T15:00:00.000+0000", "SchedEndTime" : "2021-10-22T15:45:00.000+0000",
"ServiceTerritoryId" : "0HhB0000000TakhKAC", "WorkTypeId" : null
} ]
}
```
JSON 파싱 후 표시 → 사용자가 수정할 레코드를 선택한다. (PDF에 화면 예시 있음)

### 3. Get Service Appointment Details

Service Appointment 객체에 **GET** 메서드로 단일 레코드 상세를 조회한다.

**Sample Request:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=SELECT+Id,SchedEndTime,SchedStartTime,ServiceTerritoryId,WorkTypeId+FROM+ServiceAppointment+WHERE+id+=+'08pB0000000aJKhIAM'
```
**Sample Response:**
```json
{
"totalSize" : 1,
"done" : true,
"records" : [ {
"attributes" : {
"type" : "ServiceAppointment",
"url" : "/services/data/v53.0/sobjects/ServiceAppointment/08pB0000000aKf7IAE"
},
"Id" : "08pB0000000aKf7IAE",
"SchedEndTime" : "2021-10-22T15:45:00.000+0000",
"SchedStartTime" : "2021-10-22T15:00:00.000+0000",
"ServiceTerritoryId" : "0HhB0000000TakhKAC",
"WorkTypeId" : "08qB0000000Tf1FIAS"
} ]
}
```

### 4. Change Appointment Details

사용자가 변경하려는 항목에 따라 service resource 페이지 **또는** time slot 페이지를 표시한다(둘 중 택1):
- **Change Appointment Candidates** — assigned resource가 absent로 표시되면 ServiceTerritoryMember 객체 **query**로 대체 resource 목록을 표시한다.
- **Change Appointment Time Slots** — assigned resource의 대체 time slot을 표시하려고 getAppointmentSlots REST API를 사용한다. (원문 [sic]: "alternative tome slots")

#### 4a. Change Appointment Candidates

ServiceTerritoryMember 객체에 **query** 요청으로 대체 resource를 조회한다.

**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=SELECT+EffectiveStartDate,EffectiveEndDate,ServiceResourceId,ServiceTerritoryId+FROM+ServiceTerritoryMember
```
**Sample Response** (totalSize 55, 표시 레코드 3개):
```json
{
"totalSize" : 55,
"done" : true,
"records" : [
{
"attributes" : { "type" : "ServiceTerritoryMember", "url" : "/services/data/v53.0/sobjects/ServiceTerritoryMember/0HuB0000000TalUKAS" },
"EffectiveStartDate" : "2021-10-22T15:00:00.000+0000",
"EffectiveEndDate" : null,
"ServiceResourceId" : "0HnB0000000TbgFKAS",
"ServiceTerritoryId" : "0HhB0000000TakhKACC"
}, {
"attributes" : { "type" : "ServiceTerritoryMember", "url" : "/services/data/v53.0/sobjects/ServiceTerritoryMember/0HuB0000000TaleKAC" },
"EffectiveStartDate" : "2021-10-22T15:00:00.000+0000",
"EffectiveEndDate" : null,
"ServiceResourceId" : "0HnB0000000TbgDKAS",
"ServiceTerritoryId" : "0HhB0000000TakhKAC"
}, {
"attributes" : { "type" : "ServiceTerritoryMember", "url" : "/services/data/v53.0/sobjects/ServiceTerritoryMember/0HuB0000000TaloKAC" },
"EffectiveStartDate" : "2021-10-22T15:00:00.000+0000",
"EffectiveEndDate" : null,
"ServiceResourceId" : "0HnB0000000TbgjKAC",
"ServiceTerritoryId" : "0HhB0000000TakhKAC"
}
]
}
```
(PDF에 Select Service Resource 화면 예시 있음)

#### 4b. Change Appointment Time Slots

선택 primary resource + 기타 required resource(asset 포함) + 통합 time slot 페이지를 생성한다. required resource 선택 시 **getAppointmentSlots** REST API에 **POST**한다.

**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/scheduling/getAppointmentSlots
```
**Sample Request:** (⚠️ [sic] — `workTypeId`가 올바른 JSON 객체가 아니라 `{ "값" }` 형태로 PDF에 기재됨. 잘못된 JSON이지만 verbatim 보존)
```json
{
"startTime" : "2021-10-04T17:00:00.000+0000",
"endTime" : "2021-10-04T18:00:00.000+0000",
"workTypeId" : {
"08qB0000000Tf1FIAS"
},
"accountId" : "001B000001McLhMIAV",
"territoryIds" : ["0HhB0000000TaHOKA0"],
"primaryResourceId" : "0HnB0000000TavDKAS",
"requiredResourceIds" : ["0HnB0000000DynTKAS", "0HnB0000000Tav3KAC"]
}
```
**Sample Response** (6개 timeSlot):
```json
{
"timeSlots" : [ {
"endTime" : "2021-10-04T18:00:00.000+0000",
"startTime" : "2021-10-04T17:00:00.000+0000",
"territoryId" : "0HhB0000000TaHOKA0"
}, {
"endTime" : "2021-10-04T19:00:00.000+0000",
"startTime" : "2021-10-04T17:00:00.000+0000",
"territoryId" : "0HhB0000000TaHOKA0"
}, {
"endTime" : "2021-10-04T20:00:00.000+0000",
"startTime" : "2021-10-04T17:30:00.000+0000",
"territoryId" : "0HhB0000000TaHOKA0"
}, {
"endTime" : "2021-10-04T18:00:00.000+0000",
"startTime" : "2021-10-04T17:00:00.000+0000",
"territoryId" : "0HhB0000000TaHOKA0"
}, {
"endTime" : "2021-10-04T18:30:00.000+0000",
"startTime" : "2021-10-04T17:30:00.000+0000",
"territoryId" : "0HhB0000000TaHOKA0"
}, {
"endTime" : "2021-10-04T18:00:00.000+0000",
"startTime" : "2021-10-04T17:00:00.000+0000",
"territoryId" : "0HhB0000000TaHOKA0"
} ]
}
```
(PDF에 Select Service Appointment Time 화면 예시 있음)

> **Note:** 최대 5 required resource(primary 1 + required 4, asset 포함).

### 5. Update Service Appointments

**service-appointments** Connect API에 **PATCH**한다.

**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-appointments
```
**Sample Request (Update Service Resource):**
```json
{
"serviceAppointmentId": "08pB0000000aJKhIAM",
"serviceAppointment": {
"schedStartTime": "2021-10-04T17:00:00.000+0000",
"schedEndTime": "2021-10-04T18:00:00.000+0000",
"serviceTerritoryId": "0HhB0000000TaHOKA0"
},
"assignedResources": [
{
"serviceResourceId": "0HnB0000000TavDKAS",
"isRequiredResource": true,
"isPrimaryResource": true
},
{
"serviceResourceId": "0HnB0000000DynTKAS",
"isRequiredResource": true,
"isPrimaryResource": false
}
]
}
```
> ⚠️ **이 시나리오의 Update Service Appointments에는 Sample Response가 PDF에 제시되지 않았다** (request만 있고 곧 confirmation 페이지 안내로 넘어감). 성공 시 confirmation 페이지를 표시한다. (PDF에 화면 예시 있음)

---

## 시나리오 9 — Create a Concurrent Appointment

**concurrent appointment**(동일 time slot에 복수 appointment)를 예약하는 앱을 구축한다. 예: 의사 진료실이 월 1:00–3:00 PM 슬롯에 여러 환자를 예약. **각 service appointment마다 event가 생성된다.**

> **Note:** A concurrent time slot can have a **minimum of 2 and a maximum of 1000 appointments.**

**고수준 단계 (8):**
1. Enable and Configure Concurrent Scheduling
2. Assign Concurrent Operating Hours to Service Territory Members
3. Authenticate with a Connected App
4. Get Work Type Groups
5. Get Service Territories
6. Get Work Types
7. Get Appointment Candidates
8. Create Service Appointments

### 1. Enable and Configure Concurrent Scheduling

동일 슬롯 복수 예약을 활성화한다.

### 2. Assign Concurrent Operating Hours to Service Territory Members

concurrent time slot은 **service territory member에만** 적용된다. member 레코드 페이지의 **Operating Hours** 필드로 operating hours를 지정한다.

> **Note:** service territory member에 operating hours를 지정하지 않으면 자동으로 service territory의 operating hours를 사용한다. work type에 operating hours를 지정하지 않으면 항상 available로 간주한다.

1. service territory member 레코드 페이지에서 **Operating Hours** 필드를 편집한다.
2. 목록에서 operating hours 세트를 선택한다.
3. Save your changes.

### 3. Authenticate with a Connected App

OAuth access token으로 인증한다. prospects/unauthenticated용은 logged-in user(integration user/admin)로 구축하고 API Enabled 권한을 확인한다.

> [!warning] 후속 권장: External Client App (ECA)
> Spring '26부터 **신규 Connected App 생성이 차단**된다. 신규 통합은 **External Client App(ECA)**로 OAuth 인증을 구성한다(시나리오 7 4단계와 동일). 기존 Connected App은 계속 유효하다.
> 근거: [New Connected Apps Can No Longer Be Created in Spring '26](https://help.salesforce.com/s/articleView?id=005228017&type=1) (Tier 2 · Salesforce Help)

### 4. Get Work Type Groups

WorkTypeGroup 객체에 **Query()** 요청한다.

**Sample Request:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=SELECT+Id,+Name+From+WorkTypeGroup
+Where+isActive+=+true+ORDER+BY+NAME
```
**Sample Response** (totalSize 6):
```json
{
"totalSize": 6,
"done": true,
"records": [
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/vXX.X/sobjects/WorkTypeGroup/0VSB0000000L6XeOAK" }, "Id": "0VSB0000000L6XeOAK", "Name": "General Banking Group" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/vXX.X/sobjects/WorkTypeGroup/0VSB0000000L6XyOAK" }, "Id": "0VSB0000000L6XyOAK", "Name": "Insurance Management" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/vXX.X/sobjects/WorkTypeGroup/0VSB0000000L71HOAS" }, "Id": "0VSB0000000L71HOAS", "Name": "Investments" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/vXX.X/sobjects/WorkTypeGroup/0VSB0000000L6Y3OAK" }, "Id": "0VSB0000000L6Y3OAK", "Name": "Loan Planning" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/vXX.X/sobjects/WorkTypeGroup/0VSB0000000TbhWOAS" }, "Id": "0VSB0000000TbhWOAS", "Name": "LSConcurrent Work Type Group" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/vXX.X/sobjects/WorkTypeGroup/0VSB0000000L6Y4OAK" }, "Id": "0VSB0000000L6Y4OAK", "Name": "Wealth Planning" }
]
}
```

### 5. Get Service Territories

**service-territories** Connect API에 **GET**한다. `radius`·`latitude`·`longitude`·`sortBy`·`sortOrder`를 조합할 수 있다.

**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-territories
```
**Sample Request:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-territories
?workTypeGroupId=0VSB0000000TbhWOAS
```
**Sample Response:**
```json
{
"result" : {
"serviceTerritories" : [ {
"city" : "San Francisco",
"country" : "United States",
"id" : "0HhB00000001P0PKAU",
"latitude" : 37.794928,
"longitude" : -122.394514,
"name" : "LSConcurrent Service Territory",
"operatingHoursId" : "0OHB0000000LWkUOAW",
"postalCode" : "90011",
"state" : "CA",
"street" : "2 Market Street"
} ]
}
}
```
(PDF에 Select Service Territory 화면 예시 있음) 이후 work type group + service territory에 연관된 work type을 얻는다.

### 6. Get Work Types

work type = Scheduler에서 수행될 작업 유형. appointment topic(work type group) + appointment location(service territory)을 나타내는 template으로, duration·prep/wrap-up buffer·availability timing 등을 정의한다.

**6-1. WorkTypeGroupMember 객체에 Query()** — 선택한 work type group의 work type 조회.
**Sample Request:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=SELECT+Id,Name,
WorkTypeGroupId,WorkTypeId+FROM+WorkTypeGroupMember+WHERE+WorkTypeGroupId+=+'0VSB0000000TbhWOAS'
```
**Sample Response** (totalSize 2):
```json
{
"totalSize" : 2,
"done" : true,
"records" : [ {
"attributes" : { "type" : "WorkTypeGroupMember", "url" : "/services/data/v53.0/sobjects/WorkTypeGroupMember/0WzB0000000TbZcKAK" },
"Id" : "0WzB0000000TbZcKAK", "Name" : "00000047",
"WorkTypeGroupId" : "0VSB0000000TbhWOAS", "WorkTypeId" : "08qB00000002ocgIAA"
}, {
"attributes" : { "type" : "WorkTypeGroupMember", "url" : "/services/data/v53.0/sobjects/WorkTypeGroupMember/0WzB0000000Tbm5KAC" },
"Id" : "0WzB0000000Tbm5KAC", "Name" : "00000048",
"WorkTypeGroupId" : "0VSB0000000TbhWOAS", "WorkTypeId" : "08qB0000000UF63IAG"
} ]
}
```

**6-2. ServiceTerritoryWorkType 객체에 Query()** — 선택한 service territory에 맞는 work type 필터.
**Sample Request:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=SELECT+Id,Name,
ServiceTerritoryId,WorkTypeId+FROM+ServiceTerritoryWorkType+WHERE+WorkTypeId+=+'08qB00000002ocgIAA'+AND+
ServiceTerritoryId+=+'0HhB00000001P0PKAU'
```
**Sample Response** (totalSize 1):
```json
{
"totalSize" : 1,
"done" : true,
"records" : [ {
"attributes" : {
"type" : "ServiceTerritoryWorkType",
"url" : "/services/data/v53.0/sobjects/ServiceTerritoryWorkType/0VEB0000000TbbrOAC"
},
"Id" : "0VEB0000000TbbrOAC",
"Name" : "00000063",
"ServiceTerritoryId" : "0HhB00000001P0PKAU",
"WorkTypeId" : "08qB00000002ocgIAA"
} ]
}
```

### 7. Get Appointment Candidates

**getAppointmentCandidates** REST API에 **POST** — required `workTypeGroupId` 또는 `workTypeId`, 그리고 `territoryIds`. **concurrent 시나리오에서는 `allowConcurrentScheduling: true`가 필수**다.

**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/scheduling/getAppointmentCandidates
```

**For an Existing User (Account):** `accountId`로 preferred visiting hours를 고려한다. **Include Only Required Service Resources** 및 **Ignore Excluded Service Resources** policy rule 활성 시 적용된다.

**Sample Request (Account, using workTypeGroupId):**
```json
{
"accountId" : "001B000001McLhMIAV",
"startTime" : "2021-10-29T08:00:00.000+0000",
"endTime" : "2021-10-29T18:00:00.000+0000",
"allowConcurrentScheduling" : true,
"workTypeGroupId" : "0VSB0000000TbhWOAS",
"territoryIds" : ["0HhB00000001P0PKAU"]
}
```
**Sample Request (Account, using workTypeId):**
```json
{
"accountId" : "001B000001McLhMIAV",
"startTime" : "2021-10-29T08:00:00.000+0000",
"endTime" : "2021-10-29T18:00:00.000+0000",
"allowConcurrentScheduling" : true,
"workType" : {
"id" : "08qB00000002ocgIAA"
},
"territoryIds" : ["0HhB00000001P0PKAU"]
}
```
**Sample Response (Account)** — 10개 candidate (resource 0HnB00000001SJxKAM 5개 + 0HnB00000001SOUKA2 5개):
```json
{
"candidates" : [
{ "endTime" : "2021-10-29T16:00:00.000+0000", "resources" : [ "0HnB00000001SJxKAM" ], "startTime" : "2021-10-29T15:00:00.000+0000", "territoryId" : "0HhB00000001P0PKAU" },
{ "endTime" : "2021-10-29T16:30:00.000+0000", "resources" : [ "0HnB00000001SJxKAM" ], "startTime" : "2021-10-29T15:30:00.000+0000", "territoryId" : "0HhB00000001P0PKAU" },
{ "endTime" : "2021-10-29T17:00:00.000+0000", "resources" : [ "0HnB00000001SJxKAM" ], "startTime" : "2021-10-29T16:00:00.000+0000", "territoryId" : "0HhB00000001P0PKAU" },
{ "endTime" : "2021-10-29T17:30:00.000+0000", "resources" : [ "0HnB00000001SJxKAM" ], "startTime" : "2021-10-29T16:30:00.000+0000", "territoryId" : "0HhB00000001P0PKAU" },
{ "endTime" : "2021-10-29T18:00:00.000+0000", "resources" : [ "0HnB00000001SJxKAM" ], "startTime" : "2021-10-29T17:00:00.000+0000", "territoryId" : "0HhB00000001P0PKAU" },
{ "endTime" : "2021-10-29T16:00:00.000+0000", "resources" : [ "0HnB00000001SOUKA2" ], "startTime" : "2021-10-29T15:00:00.000+0000", "territoryId" : "0HhB00000001P0PKAU" },
{ "endTime" : "2021-10-29T16:30:00.000+0000", "resources" : [ "0HnB00000001SOUKA2" ], "startTime" : "2021-10-29T15:30:00.000+0000", "territoryId" : "0HhB00000001P0PKAU" },
{ "endTime" : "2021-10-29T17:00:00.000+0000", "resources" : [ "0HnB00000001SOUKA2" ], "startTime" : "2021-10-29T16:00:00.000+0000", "territoryId" : "0HhB00000001P0PKAU" },
{ "endTime" : "2021-10-29T17:30:00.000+0000", "resources" : [ "0HnB00000001SOUKA2" ], "startTime" : "2021-10-29T16:30:00.000+0000", "territoryId" : "0HhB00000001P0PKAU" },
{ "endTime" : "2021-10-29T18:00:00.000+0000", "resources" : [ "0HnB00000001SOUKA2" ], "startTime" : "2021-10-29T17:00:00.000+0000", "territoryId" : "0HhB00000001P0PKAU" }
]
}
```

**For a Guest User (Lead):**

**Sample Request (Guest, using workTypeGroupId):** (⚠️ [sic] — `territoryIds` 줄 끝에 trailing comma가 PDF 원문에 있음)
```json
{
"startTime" : "2021-10-13T08:00:00.000+0000",
"endTime" : "2021-10-13T18:00:00.000+0000",
"allowConcurrentScheduling" : true,
"workTypeGroupId" : "0VSB0000000TbhWOAS",
"territoryIds" : ["0HhB00000001P0PKAU"],
}
```
**Sample Request (Guest, using workTypeId):** (⚠️ [sic] — guest 케이스인데 `accountId`가 포함됨. PDF verbatim)
```json
{
"accountId" : "001B000001McLhMIAV",
"startTime" : "2021-10-29T08:00:00.000+0000",
"endTime" : "2021-10-29T18:00:00.000+0000",
"allowConcurrentScheduling" : true,
"workType" : {
"id" : "08qB00000002ocgIAA"
},
"territoryIds" : ["0HhB00000001P0PKAU"]
}
```
**Sample Response (Guest):** Account 케이스와 동일한 10개 candidate (0HnB00000001SJxKAM 5 + 0HnB00000001SOUKA2 5, 동일 start/end·territoryId). verbatim 동일.

(PDF에 resource·time slot 화면 예시 있음)

### 8. Create Service Appointments

**service-appointments** Connect API에 **POST**한다.

**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-appointments
```
**For an Existing User (Account):** account ID를 `parentRecordId`로 전달하고 status를 Scheduled로 설정한다.
**Sample Request (Account):**
```json
{
"serviceAppointment": {
"serviceTerritoryId": "0HhB00000001P0PKAU",
"parentRecordId" : "001B0000018vs9fIAA",
"workTypeId" : "08qB00000002ocgIAA",
"schedStartTime" : "2021-10-29T16:00:00.000+0000",
"schedEndTime": "2021-10-29T17:00:00.000+0000",
"additionalInformation" : "Concurrent Booking",
"appointmentType" : "Training Purpose",
"extendedFields" : [ {
"name": "status",
"value": "Scheduled"
} ]
},
"assignedResources": [
{
"serviceResourceId": "0HnB00000001SJxKAM",
"isRequiredResource" : "true"
}
]
}
```
**Sample Response (Account):**
```json
{
"result" : {
"assignedResourceIds" : [ "03rB0000000cBZ6IAM" ],
"serviceAppointmentId" : "08pB0000000aKjMIAU"
}
}
```
**For a Guest User (Lead):** lead 상세를 전달하고 status를 Scheduled로 설정한다.
**Sample Request (Lead):**
```json
{
"serviceAppointment": {
"serviceTerritoryId": "0HhB00000001P0PKAU",
"schedStartTime" : "2021-10-29T16:00:00.000+0000",
"schedEndTime": "2021-10-29T17:00:00.000+0000",
"workTypeId" : "08qB00000002ocgIAA",
"additionalInformation" : "Concurrent Booking",
"appointmentType" : "Training Purpose",
"extendedFields" : [ {
"name": "status",
"value": "Scheduled"
} ]
},
"assignedResources": [
{
"serviceResourceId": "0HnB00000001SJxKAM",
"isRequiredResource" : "true"
}
],
"lead": {
"email" : "name@company.com",
"firstName" : "FName",
"lastName" : "LName",
"company" : "CompanyName"
}
}
```
**Sample Response (Lead):**
```json
{
"result" : {
"assignedResourceIds" : [ "03rB0000000cBAFIA2" ],
"parentRecordId" : "00QB000000ASSt5MAH",
"serviceAppointmentId" : "08pB0000000aKIgIAM"
}
}
```
성공 시 confirmation 페이지를 표시한다. (PDF에 화면 예시 있음)

---

## 시나리오 10 — Schedule Appointments by Using Sharing Availability

Salesforce Scheduler API로 **외부 웹사이트**를 구축해, 사용자가 **invitation URL**로 appointment를 예약하게 한다. service resource(또는 assistant)가 availability를 공유하기 위해 invitation URL을 생성하며, URL은 사용자를 service resource가 available한 첫 주로 안내한다.

활용 예:
- wealth manager(contractor)가 invitation URL을 생성해 서명에 추가 → 잠재 고객이 URL로 예약.
- equity portfolio manager(contractor)가 3개월 후 availability를 기존 고객(authenticated consumer)에게 공유 → 현재로부터 3개월 후 start date로 URL을 생성해 공유.

> **Note:** invitation URL로 예약하려면 사용자가 invitation record, service territory, work type/work type group, service resource에 접근 권한이 필요하다. Admin이 sharing settings 또는 Apex sharing으로 read-only 접근을 제공한다.

**고수준 단계 (7):**
1. Configure Invitation URLs to Open on External Websites
2. Generate an Appointment Invitation URL
3. Retrieve the Invitation Key
4. Get the Appointment Invitation Details
5. Get the Appointment Invitee Details
6. Show Calendar Availability
7. Book Service Appointments

### 1. Configure Invitation URLs to Open on External Websites

Admin이 invitation URL에 prefix를 추가해 외부 웹사이트에서 직접 열리게 한다.

1. **Invitation URL Prefix** flow attribute에 웹사이트를 설정한다.
2. invitation URL을 웹사이트 도메인으로 prefix한다 — `https://YourSiteDomain/SiteURL` 형식.

### 2. Generate an Appointment Invitation URL

**Admin만** invitation URL을 생성할 수 있고, 사용자에게 공유한다. 사용자가 URL을 클릭하면 invitation key를 캡처해 상세를 조회한다.

### 3. Retrieve the Invitation Key

invitation URL = invitation URL prefix + invitation key(auto-generated 고유 식별자) 2개 컴포넌트로 구성된다.

예: URL이 `https://YourSiteDomain/SiteURL/f482d103-4792-40ac-864a-57db0c13161b`이면 invitation key는 `f482d103-4792-40ac-864a-57db0c13161b`다.

### 4. Get the Appointment Invitation Details

**AppointmentInvitation** 객체에 **Query()** 요청한다. 조회 항목: invitation ID, appointment topic ID(work type group ID), appointment topic type, service territory ID, availability start/end date.

> **Note:** invitation URL이 active한지 확인하려면 **IsActive** 쿼리 파라미터를 true로 설정한다.

**Sample REST API Request:** (⚠️ [sic] — `salesforce.com//services` 더블 슬래시 verbatim)
```
https://yourInstance.salesforce.com//services/data/vXX.X/query/?q=
SELECT+AppointmentTopicId,AppointmentTopicType,BookingEndDate,BookingStartDate,
Id,ServiceTerritoryId+FROM+AppointmentInvitation+
WHERE+InvitationIdentifier+=+'f482d103-4792-40ac-864a-57db0c13161b'+AND+IsActive+=+true
```
**Sample Response:**
```json
{
"totalSize" : 1,
"done" : true,
"records" : [ {
"attributes" : {
"type" : "AppointmentInvitation",
"url" : "/services/data/v55.0/sobjects/AppointmentInvitation/1S8x000000000oHCAQ"
},
"AppointmentTopicId" : "0VSx00000002Uh4GAE",
"AppointmentTopicType" : "WorkTypeGroup",
"BookingEndDate" : "2022-06-30",
"BookingStartDate" : "2022-06-14",
"Id" : "1S8x000000000oHCAQ",
"ServiceTerritoryId" : "0Hhx00000002LzGCAU"
} ]
}
```
값을 저장한다(invitation availability time slot 조회에 필요).

### 5. Get the Appointment Invitee Details

**AppointmentInvitee** 객체에 **Query()** 요청한다. 조회 항목: service territory ID, appointment topic ID, service resource ID, booking start/end date, resource가 primary/required 여부 등.

**Sample REST API Request:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/query/?q=
SELECT+AppointmentInvitationId,Id,IsPrimaryResource,IsRequiredResource,
Name,ParticipantServiceResourceId+FROM+AppointmentInvitee+
WHERE+AppointmentInvitationId+=+'1S8x000000000oHCAQ'
```
**Sample Response:**
```json
{
"totalSize" : 1,
"done" : true,
"records" : [ {
"attributes" : {
"type" : "AppointmentInvitee",
"url" : "/services/data/v55.0/sobjects/AppointmentInvitee/0y6x000000000pFAAQ"
},
"AppointmentInvitationId" : "1S8x000000000oHCAQ",
"Id" : "0y6x000000000pFAAQ",
"IsPrimaryResource" : true,
"IsRequiredResource" : true,
"Name" : "AITE-0247",
"ParticipantServiceResourceId" : "0Hnx000000007d7CAA"
} ]
}
```
값을 저장한다.

### 6. Show Calendar Availability

**getAppointmentSlots** API로 invitation에 연관된 service resource의 calendar availability를 조회한다. service territory ID + work type group ID + service resource ID로 결정된다.

> **Note:** 캘린더는 공유 invitation start/end date 사이의 선택 resource available slot만 표시한다.

**getAppointmentSlots** REST API에 **POST**한다.

**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/scheduling/getAppointmentSlots
```
**Sample Request:**
> **Note:** **workTypeGroupId** 필드는 required다.
```json
{
"startTime": "2022-06-14T00:00:00.000Z",
"endTime": "2022-06-30T00:00:00.000Z",
"workTypeGroupId": "0VSx00000002Uh4GAE",
"territoryIds": [
"0Hhx00000002LzGCAU"
],
"requiredResourceIds": [
"0Hnx000000007d7CAA"
]
}
```
**Sample Response** — 26개 timeSlot (모두 territoryId 0Hhx00000002LzGCAU, `remainingAppointments` 1):
```json
{
"timeSlots": [
{ "endTime": "2022-06-14T02:15:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-14T01:15:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-14T02:30:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-14T01:30:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-14T12:30:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-14T11:30:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-14T12:45:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-14T11:45:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-15T02:15:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-15T01:15:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-15T02:30:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-15T01:30:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-15T12:30:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-15T11:30:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-15T12:45:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-15T11:45:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-16T01:45:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-16T00:45:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-16T02:00:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-16T01:00:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-17T12:30:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-17T11:30:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-17T12:45:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-17T11:45:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-18T01:45:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-18T00:45:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-18T02:00:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-18T01:00:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-20T02:15:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-20T01:15:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-21T03:15:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-21T02:15:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-21T03:30:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-21T02:30:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-25T07:45:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-25T06:45:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-27T12:30:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-27T11:30:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-27T12:45:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-27T11:45:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-28T02:15:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-28T01:15:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-28T02:30:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-28T01:30:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-28T02:45:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-28T01:45:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-29T12:15:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-29T11:15:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-29T12:30:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-29T11:30:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" },
{ "endTime": "2022-06-29T12:45:00.000+0000", "remainingAppointments": 1, "startTime": "2022-06-29T11:45:00.000+0000", "territoryId": "0Hhx00000002LzGCAU" }
]
}
```
응답 파싱 후 웹페이지에 슬롯을 표시한다.

### 7. Book Service Appointments

**service-appointments** API로 appointment를 생성한다. Create 버튼을 가진 페이지를 생성하고 Create 버튼을 service-appointments Connect API **POST**에 연결한다.

**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/vXX.X/connect/scheduling/service-appointments
```
**For an Account User:**
> **Note:** **parentRecordId** 필드는 required다. account ID를 parentRecordId로 전달한다.
**Sample Request (Account):**
```json
{
"serviceAppointment": {
"serviceTerritoryId": "0Hhx00000002LzGCAU",
"parentRecordId": "001x0000005SEqZAAW",
"schedStartTime": "2022-06-29T11:30:00.000+0000",
"schedEndTime": "2022-06-29T12:30:00.000+0000",
"additionalInformation": "Sharing availability use case using APIs.",
"appointmentType": "Book Test Appointment1",
"extendedFields": [
{
"name": "status",
"value": "Scheduled"
}
]
},
"assignedResources": [
{
"serviceResourceId": "0Hnx000000007d7CAA",
"isRequiredResource": "true"
}
]
}
```
**Sample Response (Account):**
```json
{
"result": {
"assignedResourceIds": [
"03rx0000000252jAAA"
],
"serviceAppointmentId": "08px000000023bdAAA"
}
}
```
**For a Guest User:**
> **Note:** **lead** 필드는 required다. guest 상세(first name, last name, email, phone)를 lead로 전달한다.
**Sample Request (Guest):**
```json
{
"serviceAppointment": {
"serviceTerritoryId": "0Hhx00000002LzGCAU",
"schedStartTime": "2022-06-29T11:30:00.000+0000",
"schedEndTime": "2022-06-29T12:30:00.000+0000",
"additionalInformation": "Sharing availability use case using APIs.",
"appointmentType": "Book Test Appointment1",
"extendedFields": [
{
"name": "status",
"value": "Scheduled"
}
]
},
"assignedResources": [
{
"serviceResourceId": "0Hnx000000007d7CAA",
"isRequiredResource": "true"
}
],
"lead": {
"email": "Test@company.com",
"firstName": "FirstName",
"lastName": "LastName",
"company": "CompanyName"
}
}
```
**Sample Response (Guest):**
```json
{
"result": {
"assignedResourceIds": [
"03rx0000000252oAAA"
],
"parentRecordId": "00Qx0000001cLwwEAE",
"serviceAppointmentId": "08px000000023biAAA"
}
}
```
성공 시 confirmation 메시지를 표시한다. (PDF에 화면 예시 있음)

---

## 시나리오 11 — Schedule Appointments with a Dummy Resource and Reassign to Actual Resources

**dummy resource**로 concurrent appointment를 생성한 뒤, 나중에 **actual resource**로 reassign한다. actual resource를 미리 배정할 수 없는 시나리오용이다.

활용 예: wealth management advisory desk가 10:00 AM–5:00 PM 사이 50+ appointment를 접수하고 날짜 2일 전에야 actual resource로 reassign. 또는 call center가 resource를 실시간 랜덤 배정하지만 하루에 50 appointment를 예약.

> **EDITIONS** (PDF callout box — verbatim):
> Salesforce Scheduler is available for an extra cost in Lightning Experience.
> Available in: Enterprise, Performance, and Unlimited Editions

**최상위 3단계:**
1. Set Up Salesforce Scheduler
2. Book Concurrent Appointments with Dummy Resource
3. Modify Appointments to Reassign to Actual Resources

### 11-1. Set Up Salesforce Scheduler

permission/object access 할당, related list/tab visibility 업데이트, multi-resource scheduling·concurrent scheduling·multiple time zone selection·map and location services 설정. 필요 시 Asset Scheduling을 설정한다.

**Set Up 하위 7단계:** Create Service Territories · Create Service Resources · Enable Concurrent Scheduling · Assign Concurrent Operating Hours to the Dummy Resource · Configure Scheduling Policy to Enforce Operating Hours · Assign Regular Shifts to Actual Resources · Configure Scheduling Policy to Enforce Shifts

**Create Service Territories**
1. Service Territories 탭에서 **New** 클릭.
2. 이름(예: ServiceTerritory1)과 설명 입력.
3. member 추가/territory 연결이 가능하도록 새 service territory를 **활성화**.

**Create Service Resources** — customer appointment 참석 가능한 개별 user. **dummy resource**(예: DummyResource1, Agent1, Agent2)를 생성해 사용자가 예약하게 한 뒤 actual resource로 배정한다.
1. App Launcher에서 **Salesforce Scheduler Setup** 앱 열기.
2. Service Resources 탭에서 **New** 클릭.
3. user 선택 후 resource 이름(보통 user 이름) 입력.
4. resource를 appointment에 배정 가능하도록 **활성화**.
5. resource type으로 **Technician** 선택.
6. Save your changes.

**Enable Concurrent Scheduling**
1. From Setup, Quick Find box에 **Salesforce Scheduler** 입력 → **Salesforce Scheduler Settings** 선택.
2. concurrent scheduling 활성화.

**Assign Concurrent Operating Hours to the Dummy Resource** — concurrent time slot은 service territory member에만 적용. dummy resource에 concurrent time slot을 배정하면 concurrent scheduling으로 appointment 생성 시 dummy resource만 표시된다.
1. service territory member 레코드 페이지에서 **Operating Hours** 필드 편집.
2. dropdown에서 operating hours 세트 선택.
3. Save your changes.

**Configure Scheduling Policy to Enforce Operating Hours** — operating hours를 설정한 dummy resource용 scheduling policy를 생성해 appointment 생성 시에만 resource present를 보장한다. (참고: Enfore [sic] Scheduling Policies in Salesforce Scheduler)
1. From Setup, Quick Find box에 **Scheduling Policies** 입력 → **Scheduling Policies** 선택.
2. **New** 클릭.
3. custom scheduling policy 이름 입력 후 **Use service territory member's shift rule** 체크 해제.
   (이 rule은 service resource availability 결정 시 service territory member의 operating hours를 고려한다.)
4. Save your changes.

**Assign Regular Shifts to Actual Resources** — service resource가 shift로 변동 근무시간을 설정한다.
1. actual resource와 service territory에 regular shift를 생성·배정.

**Configure Scheduling Policy to Enforce Shifts** — shift로 근무시간을 만든 actual resource용 scheduling policy를 생성해 appointment reassignment 시에만 resource present를 보장한다. (참고: Enfore [sic] Scheduling Policies in Salesforce Scheduler)
1. From Setup, Quick Find box에 **Scheduling Policies** 입력 → **Scheduling Policies** 선택.
2. **New** 클릭.
3. custom scheduling policy 이름 입력 후 **Use service territory member's shift rule** 선택(체크).
   (이 rule은 availability 결정 시 service territory member의 shift를 고려한다.)
4. Save your changes.

### 11-2. Book Concurrent Appointments with Dummy Resource

concurrent scheduling으로 동일 슬롯에 복수 appointment를 예약한다. 각 appointment마다 event가 생성된다. dummy resource로 그날 여러 슬롯에 concurrent appointment를 생성한다.

> **Note:** A concurrent time slot can have **2 to 1,000 appointments.**

**하위 4단계:** Get Work Type Groups · Get Service Territories · Get Dummy Service Resource · Create Service Appointments

**Get Work Type Groups** — WorkTypeGroup 객체에 **Query()** 요청. (이 시나리오는 실제 v66.0 URI 사용)
**Sample Request:**
```
https://yourInstance.salesforce.com/services/data/v66.0/query/?q=
SELECT+Id,+Name+From+WorkTypeGroup+Where+isActive+=+true+ORDER+BY+NAME
```
**Sample Response** (totalSize 13):
```json
{
"totalSize": 13,
"done": true,
"records": [
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS700000009NdOAI" }, "Id": "0VSS700000009NdOAI", "Name": "Create Account" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS700000009YmOAI" }, "Id": "0VSS700000009YmOAI", "Name": "Parent 1" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS70000004DuiOAE" }, "Id": "0VSS70000004DuiOAE", "Name": "Parent topic Create" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS700000009YwOAI" }, "Id": "0VSS700000009YwOAI", "Name": "test" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS700000009Z1OAI" }, "Id": "0VSS700000009Z1OAI", "Name": "test 32" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS70000004DunOAE" }, "Id": "0VSS70000004DunOAE", "Name": "test 32" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS700000009ZaOAI" }, "Id": "0VSS700000009ZaOAI", "Name": "Virtual WTG" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS70000004DvWOAU" }, "Id": "0VSS70000004DvWOAU", "Name": "WorkTypeGrp1" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS700000009TvOAI" }, "Id": "0VSS700000009TvOAI", "Name": "Work_Type_Group_48368" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS700000009TqOAI" }, "Id": "0VSS700000009TqOAI", "Name": "Work_Type_Group_67304" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS700000009ZVOAY" }, "Id": "0VSS700000009ZVOAY", "Name": "Work_Type_Group_96227" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS700000009O7OAI" }, "Id": "0VSS700000009O7OAI", "Name": "WTG Block Time" },
{ "attributes": { "type": "WorkTypeGroup", "url": "/services/data/v56.0/sobjects/WorkTypeGroup/0VSS700000009Z6OAI" }, "Id": "0VSS700000009Z6OAI", "Name": "ytre" }
]
}
```

**Get Service Territories** — **service-territories** Connect API 요청. (⚠️ [sic] 본문은 "within a range of 10 miles … The default value is 5 miles."라고 하나 sample URI에는 radius 파라미터 없이 workTypeGroupId만 있음)
**Sample Request:**
```
https://yourInstance.salesforce.com/services/data/v66.0/connect/scheduling
/service-territories?workTypeGroupId=0VSS70000004DvWOAU
```
**Sample Response:**
```json
{
"result": {
"serviceTerritories": [
{
"city": "Hyderabad",
"country": "India",
"id": "0HhS70000004F9zKAE",
"name": "ServiceTerritory1",
"operatingHoursId": "0OHS70000004FIxOAM",
"postalCode": "500032",
"state": "TG"
}
]
}
}
```
(PDF에 Select Service Territory 화면 예시 있음)

**Get Dummy Service Resource** — 선택 work type group + service territory 기준 dummy resource와 availability를 표시한다. **getAppointmentCandidates** REST API에 **POST** — required `workTypeGroupId`, `territoryIds`. `allowConcurrentScheduling`을 **true**로 설정해 dummy resource의 concurrent time slot을 획득한다.
> **Note:** operating hour scheduling policy ID(`schedulingPolicyId`)를 지정해 concurrent scheduling용 operating hours가 정의된 dummy resource만 표시한다.
**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/v66.0/scheduling/getAppointmentCandidates
```
**Sample Request:** (`filterByResources` 파라미터로 dummy resource ID 필터)
```json
{
"startTime": "2022-10-01T00:00:00.000Z",
"endTime": "2022-10-08T20:00:00.000Z",
"allowConcurrentScheduling": true,
"schedulingPolicyId": "0VrS7000000004XKAQ",
"filterByResources": [
"0HnS70000004EFyKAM"
],
"workTypeGroupId": "0VSS70000004DvWOAU",
"territoryIds": [
"0HhS70000004F9zKAE"
]
}
```
**Sample Response** — 약 50개 candidate (모두 resource `0HnS70000004EFyKAM`, territoryId `0HhS70000004F9zKAE`, 30분 단위). 슬롯은 2022-10-03 16:00부터 2022-10-05 04:00까지 각 날짜 16:00~다음날 04:00 운영시간대에 연속 나열된다. 대표 슬롯 + 생략 표기:
```json
{
"candidates": [
{ "endTime": "2022-10-03T16:30:00.000+0000", "resources": ["0HnS70000004EFyKAM"], "startTime": "2022-10-03T16:00:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-03T17:00:00.000+0000", "resources": ["0HnS70000004EFyKAM"], "startTime": "2022-10-03T16:30:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-03T17:30:00.000+0000", "resources": ["0HnS70000004EFyKAM"], "startTime": "2022-10-03T17:00:00.000+0000", "territoryId": "0HhS70000004F9zKAE" }
// ... (10-03 17:30~24:00, 10-04 00:00~04:00 30분 간격 연속) ...
,{ "endTime": "2022-10-04T04:00:00.000+0000", "resources": ["0HnS70000004EFyKAM"], "startTime": "2022-10-04T03:30:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-04T16:30:00.000+0000", "resources": ["0HnS70000004EFyKAM"], "startTime": "2022-10-04T16:00:00.000+0000", "territoryId": "0HhS70000004F9zKAE" }
// ... (10-04 16:00~24:00, 10-05 00:00~04:00 30분 간격 연속) ...
,{ "endTime": "2022-10-05T04:00:00.000+0000", "resources": ["0HnS70000004EFyKAM"], "startTime": "2022-10-05T03:30:00.000+0000", "territoryId": "0HhS70000004F9zKAE" }
]
}
```
> 위 `// ...` 두 줄은 본 위키의 생략 표기다(원본 배열의 약 50개 슬롯 중 중간 구간 축약). 슬롯 ID·territoryId·resource는 전 구간 동일하며 30분 간격으로 연속된다.

**Create Service Appointments** — **service-appointments** Connect API에 **POST**.
> **Note:** operating hour scheduling policy ID를 지정해 dummy resource만 표시한다.
**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/v66.0/connect/scheduling/service-appointments
```
**For an Existing User (Account):** account ID를 `parentRecordId`로 전달. (⚠️ 이 케이스에는 status extendedFields 없음 — verbatim)
**Sample Request (Account):**
```json
{
"schedulingPolicyId": "0VrS7000000004XKAQ",
"serviceAppointment": {
"serviceTerritoryId": "0HhS70000004F9zKAE",
"parentRecordId": "001S7000002br8YIAQ",
"schedStartTime": "2022-10-03T16:30:00.000+0000",
"schedEndTime": "2022-10-03T17:00:00.000+0000",
"additionalInformation": "Schedule concurrent appointment with a dummy resource",
"appointmentType": "Use case purpose."
},
"assignedResources": [
{
"serviceResourceId": "0HnS70000004EFyKAM",
"isRequiredResource": "true"
}
]
}
```
**Sample Response (Account):**
```json
{
"result": {
"assignedResourceIds": [
"03rS700000003zrIAA"
],
"serviceAppointmentId": "08pS70000000CxEIAU"
}
}
```
**For a Guest User (Lead):** lead 상세를 전달한다.
**Sample Request (Lead):**
```json
{
"schedulingPolicyId": "0VrS7000000004XKAQ",
"serviceAppointment": {
"serviceTerritoryId": "0HhS70000004F9zKAE",
"schedStartTime": "2022-10-03T16:30:00.000+0000",
"schedEndTime": "2022-10-03T17:00:00.000+0000",
"additionalInformation": "Schedule concurrent appointment with a dummy resource",
"appointmentType": "Use case purpose."
},
"assignedResources": [
{
"serviceResourceId": "0HnS70000004EFyKAM",
"isRequiredResource": "true"
}
],
"lead": {
"firstName": "Patient1",
"lastName": "Test",
"email": "test1@company.com",
"company": "Test Club"
}
}
```
**Sample Response (Lead):**
```json
{
"result": {
"assignedResourceIds": [
"03rS700000003zrIAA"
],
"parentRecordId": "00QRM000004seHz2AI",
"serviceAppointmentId": "08pRM0000004vdvYAA"
}
}
```
성공 시 confirmation 페이지를 표시한다. (PDF에 화면 예시 있음)

### 11-3. Modify Appointments to Reassign to Actual Resources

dummy resource에 예약된 appointment를 조회·표시한 뒤 branch manager/admin이 actual resource로 reassign한다.

**하위 3단계:** Get Service Appointments Assigned to the Dummy Resource · Get Actual Service Resources · Update Service Appointments

**Get Service Appointments Assigned to the Dummy Resource** — **AssignedResource** 객체에 **Query()** 요청(ServiceAppointment를 관계로 조회). (⚠️ [sic] 원문: "For the list of AppointmentInvitation object fields, see ServiceAppointment." — AppointmentInvitation으로 잘못 표기됐으나 링크는 ServiceAppointment)
- 추가 컬럼(lead, parent record ID 등)을 원하면 쿼리를 수정한다.
- upcoming을 먼저 보려면 start time 오름차순 정렬.
- 과거 appointment를 제외하려면 currentTime > start time 조건 추가.

**Sample REST API Request:** (⚠️ [sic] 더블 슬래시 `salesforce.com//services`)
```
https://yourInstance.salesforce.com//services/data/v66.0/query/?q=
SELECT+ServiceAppointmentId,ServiceResourceId,ServiceAppointment.SchedEndTime,ServiceAppointment.SchedStartTime,ServiceAppointment.ServiceTerritoryId,ServiceAppointment.Id+
FROM+AssignedResource+WHERE+ServiceResourceId+=+'0HnS70000004EFyKAM'+ORDER+BY+createdDate+DESC+limit+5
```
**Sample Response** (totalSize 5, 중첩 ServiceAppointment 포함):
```json
{
"totalSize": 5,
"done": true,
"records": [
{
"attributes": { "type": "AssignedResource", "url": "/services/data/v56.0/sobjects/AssignedResource/03rS70000000401IAA" },
"ServiceAppointmentId": "08pS70000000CxOIAU",
"ServiceResourceId": "0HnS70000004EFyKAM",
"ServiceAppointment": {
"attributes": { "type": "ServiceAppointment", "url": "/services/data/v56.0/sobjects/ServiceAppointment/08pS70000000CxOIAU" },
"SchedEndTime": "2022-10-03T17:00:00.000+0000",
"SchedStartTime": "2022-10-03T16:30:00.000+0000",
"ServiceTerritoryId": "0HhS70000004F9zKAE",
"Id": "08pS70000000CxOIAU"
}
},
{
"attributes": { "type": "AssignedResource", "url": "/services/data/v56.0/sobjects/AssignedResource/03rS700000003zwIAA" },
"ServiceAppointmentId": "08pS70000000CxJIAU",
"ServiceResourceId": "0HnS70000004EFyKAM",
"ServiceAppointment": {
"attributes": { "type": "ServiceAppointment", "url": "/services/data/v56.0/sobjects/ServiceAppointment/08pS70000000CxJIAU" },
"SchedEndTime": "2022-10-03T17:00:00.000+0000",
"SchedStartTime": "2022-10-03T16:30:00.000+0000",
"ServiceTerritoryId": "0HhS70000004F9zKAE",
"Id": "08pS70000000CxJIAU"
}
},
{
"attributes": { "type": "AssignedResource", "url": "/services/data/v56.0/sobjects/AssignedResource/03rS700000003zrIAA" },
"ServiceAppointmentId": "08pS70000000CxEIAU",
"ServiceResourceId": "0HnS70000004EFyKAM",
"ServiceAppointment": {
"attributes": { "type": "ServiceAppointment", "url": "/services/data/v56.0/sobjects/ServiceAppointment/08pS70000000CxEIAU" },
"SchedEndTime": "2022-10-03T17:00:00.000+0000",
"SchedStartTime": "2022-10-03T16:30:00.000+0000",
"ServiceTerritoryId": "0HhS70000004F9zKAE",
"Id": "08pS70000000CxEIAU"
}
},
{
"attributes": { "type": "AssignedResource", "url": "/services/data/v56.0/sobjects/AssignedResource/03rS70000004D3WIAU" },
"ServiceAppointmentId": "08pS70000004F3xIAE",
"ServiceResourceId": "0HnS70000004EFyKAM",
"ServiceAppointment": {
"attributes": { "type": "ServiceAppointment", "url": "/services/data/v56.0/sobjects/ServiceAppointment/08pS70000004F3xIAE" },
"SchedEndTime": "2022-10-03T17:00:00.000+0000",
"SchedStartTime": "2022-10-03T16:30:00.000+0000",
"ServiceTerritoryId": "0HhS70000004F9zKAE",
"Id": "08pS70000004F3xIAE"
}
},
{
"attributes": { "type": "AssignedResource", "url": "/services/data/v56.0/sobjects/AssignedResource/03rS700000003zmIAA" },
"ServiceAppointmentId": "08pS70000000Cx9IAE",
"ServiceResourceId": "0HnS70000004EFyKAM",
"ServiceAppointment": {
"attributes": { "type": "ServiceAppointment", "url": "/services/data/v56.0/sobjects/ServiceAppointment/08pS70000000Cx9IAE" },
"SchedEndTime": "2022-10-03T17:00:00.000+0000",
"SchedStartTime": "2022-10-03T16:30:00.000+0000",
"ServiceTerritoryId": "0HhS70000004F9zKAE",
"Id": "08pS70000000Cx9IAE"
}
}
]
}
```
JSON 파싱 후 표시 → branch manager/admin이 actual resource로 reassign한다.

**Get Actual Service Resources** — **getAppointmentCandidates** REST API에 **POST** — required `workTypeGroupId`, `territoryIds`.
> **Note:** shift의 scheduling policy ID(`schedulingPolicyId`)를 지정해 shift로 regular working hours를 설정한 actual resource만 표시한다.
**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/v66.0/scheduling/getAppointmentCandidates
```
**Sample Request:** (⚠️ `allowConcurrentScheduling` 없음 — actual resource는 concurrent 아님)
```json
{
"startTime": "2022-10-01T17:00:00.000+0000",
"endTime": "2022-10-08T18:00:00.000+0000",
"workTypeGroupId": "0VSS70000004DvWOAU",
"schedulingPolicyId": "0VrS70000004CEhKAM",
"territoryIds": [
"0HhS70000004F9zKAE"
]
}
```
**Sample Response** — 15개 candidate (모두 resource `0HnS700000007xwKAA`, territoryId `0HhS70000004F9zKAE`, 30분 단위):
```json
{
"candidates": [
{ "endTime": "2022-10-01T17:30:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T17:00:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-01T18:00:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T17:30:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-01T18:30:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T18:00:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-01T19:00:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T18:30:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-01T19:30:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T19:00:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-01T20:00:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T19:30:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-01T20:30:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T20:00:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-01T21:00:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T20:30:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-01T21:30:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T21:00:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-01T22:00:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T21:30:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-01T22:30:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T22:00:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-01T23:00:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T22:30:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-01T23:30:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T23:00:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-02T00:00:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-01T23:30:00.000+0000", "territoryId": "0HhS70000004F9zKAE" },
{ "endTime": "2022-10-02T00:30:00.000+0000", "resources": ["0HnS700000007xwKAA"], "startTime": "2022-10-02T00:00:00.000+0000", "territoryId": "0HhS70000004F9zKAE" }
]
}
```
JSON 파싱 후 표시 → manager/admin이 actual resource를 선택한다.

**Update Service Appointments** — reassign하는 branch manager/admin에 필요한 권한:
- Read, Create, Edit on **service appointments**
- Read on accounts, contacts, operating hours, service resources, service territories, work types, work type groups

**service-appointments** Connect API에 **PATCH**한다.
**Resource URI:**
```
https://yourInstance.salesforce.com/services/data/v66.0/connect/scheduling/service-appointments
```
**Sample Request:** appointment ID를 `serviceAppointmentId`로, actual resource ID를 `serviceResourceId`로, status를 Scheduled로 전달한다.
```json
{
"schedulingPolicyId": "0VrS70000004CEhKAM",
"serviceAppointmentId": "08pS70000000CxOIAU",
"serviceAppointment": {
"serviceTerritoryId": "0HhS70000004F9zKAE",
"extendedFields": [
{
"name": "status",
"value": "Scheduled"
}
]
},
"assignedResources": [
{
"serviceResourceId": "0HnS700000007xwKAA",
"isRequiredResource": "true"
}
]
}
```
**Sample Response:**
```json
{
"result": {
"assignedResourceIds": [
"03rS70000000406IAA"
],
"serviceAppointmentId": "08pS70000000CxOIAU"
}
}
```
수정할 각 service appointment ID마다 PATCH를 실행한다. 보통 Business Location Manager 또는 actual resource 배정 담당자가 수행한다.

> **Important:** dummy appointment 총 수가 한 슬롯의 available resource 총 수를 초과하지 않도록 보장한다. 초과 시 appointment 수정 때 availability 기반으로 슬롯을 업데이트해야 한다. 이를 피하려면 **Concurrent Scheduling Max appointment slots를 총 resource capacity의 약 60–80%로 설정**한다.

---

## 커버리지 안내

본 노트는 Developer Guide Ch12 *"Build Custom Appointment Booking Experiences Using Salesforce Scheduler APIs"*의 **시나리오 7–11**만 다룬다. 같은 챕터의 시나리오 1–6(Single/Group/Anonymous booking 등)과 Business API 엔드포인트 정의·요청/응답 표현형은 형제 노트 소관이다.

---

## 관련 노트

이 노트는 5개 예약 시나리오의 워크플로우·요청/응답 예제를 다룬다. Business API 엔드포인트 정의(URI·메서드·파라미터)와 객체 필드 상세는 형제 노트가 보유한다.

- [[Salesforce Scheduler — Business REST·Connect 엔드포인트]] — getAppointmentCandidates·getAppointmentSlots·service-appointments 등 본 시나리오에서 호출하는 엔드포인트의 URI·메서드·파라미터 정본.
- [[Salesforce Scheduler — Connect API 요청·응답 표현형·Error Codes]] — 이 시나리오의 요청/응답 Body 표현형·Error Codes.
- [[Salesforce Scheduler — ConnectApi LightningScheduler Apex]] — 동일 흐름의 Apex(ConnectApi LightningScheduler) 표면.
- [[Salesforce Scheduler — 커스텀 예약 시나리오 (익명·단일리소스)]] — 익명·단일리소스 등 나머지 예약 시나리오.
- [[Salesforce Scheduler — 개요·셋업·데이터모델·인증·SOQL]] — Scheduler 개요·셋업·인증·SOQL(toLabel).
- [[Salesforce Scheduler 표준객체 — 핵심 예약]] — ServiceAppointment·AssignedResource·ServiceAppointmentAttendee 필드.
- [[Salesforce Scheduler 표준객체 — 리소스·영역·스킬·시프트]] — ServiceResource·ServiceTerritory·ServiceTerritoryMember·Shift.
- [[Salesforce Scheduler 표준객체 — 초대·집계·로그]] — AppointmentInvitation·AppointmentInvitee 필드(시나리오 10).
- [[Salesforce Scheduler 커스텀객체]] — WorkTypeGroupMember·EngagementChannelType 등 junction 객체.
- [[LxScheduler Namespace]] — 동일 기능의 Apex 인터페이스/클래스.
