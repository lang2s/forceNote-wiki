---
tags: [field-service, fsl, apex-namespace, 현장서비스, scheduling, optimization, appointment-booking, managed-package]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [FSL Namespace, FSL Apex, ScheduleService, OAAS, AppointmentBookingService, GradeSlotsService, ScheduleJobsApi, RecurringAppointmentsManager, FSL 네임스페이스, 현장서비스 Apex]
---

# FSL Apex Namespace

> Field Service managed package가 제공하는 `FSL` Apex 네임스페이스 — appointment booking, scheduling, optimization(OAAS), recurring appointment 등 managed package 기능을 Apex로 프로그래밍 확장하기 위한 19개 클래스 전수.

---

> [!important] FSL(Field Service) ≠ LxScheduler(Salesforce Scheduler) — 별개 제품
> 이 노트의 `FSL` 네임스페이스는 **Field Service managed package**(현장 서비스 — dispatcher / mobile worker / 작업 스케줄링) 소관이다. 이름이 비슷한 `lxscheduler` 네임스페이스([[LxScheduler Namespace]])는 **Salesforce Scheduler**(고객 약속 예약 — Inbound/Outbound appointment)라는 **완전히 다른 제품**이다. 클래스명 충돌은 0건이며, 두 네임스페이스를 혼용하면 안 된다.

`FSL` 네임스페이스는 Field Service managed package 내부의 모든 클래스·메서드·Visualforce 페이지·custom object를 포함한다. 네임스페이스 요소에 접근하려면 사용자 persona에 맞는 FSL custom permission set을 할당한다. 예를 들어 사용자가 appointment를 예약할 수 있게 하려면 FSL Agent custom permission set을 할당한다.

> The Field Service managed package provides the FSL Apex namespace, whose custom methods and functions you can use to extend managed package features programmatically.

### 스케줄링 공통 권한 주의 (여러 클래스 공유)

`AppointmentBookingService` · `GradeSlotsService` · `ScheduleService` 등 스케줄링 클래스 사용 시:

- 사용자는 4개 managed package permission set 중 하나가 필요하다: **Field Service Admin, Field Service Dispatcher, Field Service Agent, Self-Service**.
- platform events를 사용하는 경우 사용자 권한을 명시적으로 구성해야 한다. 미구성 시 **Automated Process system user**로 실행되어 권한이 없다.

---

## 클래스 목차 (19개)

| # | 클래스 | 종류 |
|---|---|---|
| 1 | `AdvancedGapMatrix` | result container |
| 2 | `AppointmentBookingService` | service (static) |
| 3 | `AppointmentBookingSlot` | result |
| 4 | `GradeSlotsService` | service (instance) |
| 5 | `AppointmentInsightsResult` | response |
| 6 | `BlockingRule` | response 보조 |
| 7 | `GroupData` | input |
| 8 | `OAAS` | optimization service (static) |
| 9 | `OAASRequest` | request |
| 10 | `PolygonUtils` | utility (static) |
| 11 | `RecurringAppointmentsManager` | service (static) |
| 12 | `RecurringPattern` | input (enum 보유) |
| 13 | `RecurringSequence` | result |
| 14 | `ResourceScheduleData` | result |
| 15 | `ScheduleJobsApi` | service (static) |
| 16 | `ScheduleResult` | result |
| 17 | `ScheduleService` | service (static) |
| 18 | `SchedulingOption` | result |
| 19 | `TimeInterval` | value object |

> 범위 밖(타입 참조로만 등장, 별도 문서화 안 됨): `ABSlotsResponse`, `PartialResultsInfo`, `EncapsulatedResource`, `GradeSlotResult`, `RecurringAppointmentSlots`(단 RecurringSequence Example에 구조 노출됨).

---

## 1. AdvancedGapMatrix Class

service resource ID와 graded time slot의 매트릭스. `GradeSlotsService`가 반환하는 결과 컨텍스트 내에서만 사용되는 인스턴스. 결과 파싱 예시는 `GradeSlotsService` 참조.

**Namespace:** FSL

**프로퍼티:**

| 프로퍼티 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `FSLOperationId` | `public Id FSLOperationId {get; set;}` | `Id` | ESO(Enhanced Scheduling and Optimization)를 사용하지 않는 scheduling service appointment에만 적용. scheduling dependency가 있는 두 service appointment chain(complex work)을 스케줄링할 때 채워짐. chain 내 두 appointment를 스케줄하기 위해 비동기 호출이 일어나며 이 프로퍼티는 `FSL__FSL_Operation__c` ID를 담는다. |
| `partialResults` | `public List<FSL.PartialResultsInfo> partialResults {get; set;}` | `List<FSL.PartialResultsInfo>` | Field Service Admin app에서 Limit Apex Operations가 enabled일 때만 의미. `ScheduleService` 처리 시간이 최대 CPU limit을 초과하기 직전이면 이미 계산된 결과를 반환하고 프로세스를 중단한다. 이 리스트는 부분 처리된 결과의 세부를 담는다. 나머지 파라미터는 동일. |
| `resourceIDToScheduleData` | `public Map<Id, FSL.ResourceScheduleData> resourceIDToScheduleData {get; set;}` | `Map<Id, FSL.ResourceScheduleData>` | service resource ID와 그에 대응하는 가용 슬롯(`ResourceScheduleData`에 저장)을 반환하는 map. |
| `Service` | `public Service {get; set;}` `[sic]` | `ServiceAppointment` | AdvancedGapMatrix가 실행된 대상 service appointment. **[sic] — 원문 Signature 줄에 타입 누락(`public Service {get; set;}`). Property Value 섹션에는 Type: `ServiceAppointment`로 표기됨.** |

---

## 2. AppointmentBookingService Class

field service의 appointment booking 스케줄링 프로세스. 스케줄링 정책·work rule·service objective를 고려해 service appointment의 가용 슬롯을 반환한다.

**Namespace:** FSL

**Usage:**

- 이 클래스 호출 전에 부모 work order와 service appointment가 이미 존재해야 한다.
- 스케줄링 권한 주의는 상단 "스케줄링 공통 권한 주의" 참조.
- time zone은 보통 서비스 요청 고객 위치 기준. best practice는 service territory의 operating hours에 지정된 time zone 사용.
- grade 또는 date 순 정렬 슬롯을 원하면 sort 파라미터(`sortResultsBy` 또는 `sortBy`)를 받는 `getSlots()` 오버로드를 사용.
- `getSlots()` 호출 시 연관 work type의 `ExactAppointment` 값은 **무시**된다. exact appointments가 필요하면 파라미터에서 `true`로 설정한다. work type의 `ExactAppointment`를 존중하려면 work type에서 직접 쿼리한다.
- 슬롯 수신 후 표시·관리 방식은 개발자 결정. 보통 고객에게 표시 → 선택 후 service appointment의 `ArrivalWindowStartTime`/`ArrivalWindowEndTime`을 슬롯 시작·종료 시간으로 업데이트한 뒤 `FSL.ScheduleService` 메서드를 호출해 선택 슬롯 내에 스케줄한다.

```apex
FSL.AppointmentBookingSlot slot = slots[0];
sa.ArrivalWindowStartTime = slot.Interval.Start.addSeconds(tz.getOffset(slot.Interval.Start) / -1000);
sa.ArrivalWindowEndTime = slot.Interval.Finish.addSeconds(tz.getOffset(slot.Interval.Finish) / -1000);
update sa;
```

**메서드 (모두 static):**

### getSlots(serviceID, policyId, operatingHoursId, tz, exactAppointment)

```apex
public static List<FSL.AppointmentBookingSlot> getSlots(Id serviceID, Id policyId, Id operatingHoursId, System.TimeZone tz, Boolean exactAppointment)
```

- `serviceID` (Id, Required): 스케줄링되는 service appointment의 ID.
- `policyId` (Id, Required): 사용되는 scheduling policy의 ID.
- `operatingHoursId` (Id, Required): time slot interval을 결정하는 operating hours 레코드 ID. **Note: operating hours 레코드의 TimeZone은 무시된다.**
- `tz` (System.TimeZone, Required): 슬롯이 반환되는 time zone. service territory의 time zone이어야 하며, 다른 timezone 사용 시 런타임에 service territory time zone으로 변환된다.
- `exactAppointment` (Boolean, Required): exact appointments 사용 여부. 호출 시 work type의 exactAppointment 값은 무시된다.
- **Return:** `List<FSL.AppointmentBookingSlot>` — 가용 슬롯 리스트만 반환하고 스케줄링은 하지 않는다.

```apex
// Example 1: Customer first policy + Gold Appointments Calendar
ServiceAppointment sa = [SELECT Id, EarliestStartTime, DueDate FROM ServiceAppointment WHERE Id='07r3F0000009dTSGEC'];
Id schedulingPolicyId = [SELECT Id FROM FSL__Scheduling_Policy__c WHERE Name='Customer first' LIMIT 1].Id;
Id operatingHoursId   = [SELECT id FROM OperatingHours WHERE name='Gold Appointments Calendar' LIMIT 1].Id;
Timezone tz = UserInfo.getTimeZone();
List<FSL.AppointmentBookingSlot> slots = FSL.AppointmentBookingService.GetSlots(sa.Id, schedulingPolicyId, operatingHoursId, tz, false);
System.debug('Returned ' + slots.size() + ' appointment slots');
for(integer i=0; i<slots.size(); i++){
    system.debug('Slot:'+i+' Start: '+slots[i].Interval.Start+' Finish:'+ slots[i].Interval.Finish+' Grade: '+slots[i].Grade);
}
```

```apex
// Example 2: 다른 time zone(Europe/Jersey)으로 반환 — DST 미고려
ServiceAppointment sa = [SELECT Id, EarliestStartTime, DueDate,serviceterritory.operatinghours.timezone FROM ServiceAppointment WHERE Id='08pTC0000000rCPYAY'];
Id schedulingPolicyId = [SELECT Id FROM FSLQA__Scheduling_Policy__c WHERE Id='a0cTC000000JDOB' LIMIT 1].Id;
Id operatingHoursId = [SELECT id FROM OperatingHours WHERE Id='0OHTC0000000c0U' LIMIT 1].Id;
Timezone tz = TimeZone.getTimeZone(sa.serviceterritory.operatinghours.timezone);//timezone of the territory of the Service Appointment
List<FSLQA.AppointmentBookingSlot> slots = FSLQA.AppointmentBookingService.GetSlots(sa.Id, schedulingPolicyId, operatingHoursId, tz, false);
Timezone JerseyTZ = TimeZone.getTimeZone('Europe/Jersey');//desired output timezone
for(integer i=0; i<slots.size(); i++){
//Remove the time offset of the current timezone.
    slots[i].Interval.Start = slots[i].Interval.Start.addSeconds(tz.getOffset(slots[i].Interval.Start) / -1000);
    slots[i].Interval.Finish = slots[i].Interval.Finish.addSeconds(tz.getOffset(slots[i].Interval.Finish) / -1000);
//Add the time offset of the new timezone.
    slots[i].Interval.Start = slots[i].Interval.Start.addSeconds(JerseyTZ.getOffset(slots[i].Interval.Start) / 1000);
    slots[i].Interval.Finish = slots[i].Interval.Finish.addSeconds(JerseyTZ.getOffset(slots[i].Interval.Finish) / 1000);
}
```

### getSlots(serviceID, policyId, calendar, tz, exactAppointment)

```apex
public static List<FSL.AppointmentBookingSlot> getSlots(Id serviceID, Id policyId, OperatingHours calendar, System.TimeZone tz, Boolean exactAppointment)
```

- `serviceID` (Id, Required), `policyId` (Id, Required).
- `calendar` (OperatingHours object, Required): time slot interval 결정용 calendar. **Note: operating hours 레코드의 TimeZone은 무시된다.**
- `tz` (System.TimeZone, Required): 슬롯 반환 time zone. service territory time zone이어야 하며 아니면 런타임 변환.
- `exactAppointment` (Boolean, Required): exact appointments 여부. work type의 exactAppointment 무시.
- **Return:** `List<FSL.AppointmentBookingSlot>`
- Usage: appointment window(9-11, 11-1, 1-3 등)는 OperatingHours object의 subquery로 반환된 슬롯에 의존. 슬롯만 반환, 스케줄 안 함.

```apex
// calendar OperatingHours object subquery
ServiceAppointment sa = [SELECT Id, EarliestStartTime, DueDate FROM ServiceAppointment WHERE Id='08p4F0000008sRMQAY'];
Id schedulingPolicyId = [SELECT Id FROM FSL__Scheduling_Policy__c WHERE Name='Customer First' LIMIT 1].Id;
operatinghours oh = new operatinghours();
oh = [SELECT id, (SELECT EndTime, StartTime, Type, DayOfWeek FROM TimeSlots) FROM OperatingHours WHERE name='AB Slot: 2 Hour Slots' LIMIT 1];
Timezone tz = UserInfo.getTimeZone();
List<FSL.AppointmentBookingSlot> slots = FSL.AppointmentBookingService.GetSlots(sa.Id, schedulingPolicyId, oh, tz, false);
System.debug('Returned ' + slots.size() + ' appointment slots');
for(integer i=0; i<slots.size(); i++){
    system.debug('Slot:'+i+' Start: '+slots[i].Interval.Start+' Finish:'+ slots[i].Interval.Finish+' Grade: '+slots[i].Grade);
}
```

### getSlots(serviceID, policyId, calendar, tz, sortResults, exactAppointment)

정렬된 슬롯 리스트를 반환.

```apex
public static List<FSL.AppointmentBookingSlot> getSlots(Id serviceID, Id policyId, OperatingHours calendar, System.TimeZone tz, FSL.AppointmentBookingService.SortResultsBy sortResults, Boolean exactAppointment)
```

- `serviceID` (Id, Required), `policyId` (Id, Required), `calendar` (OperatingHours object, Required; TimeZone 무시), `tz` (System.TimeZone, Required).
- `sortResults` (`FSL.AppointmentBookingService.SortResultsBy` enumeration, Required): AppointmentBookingSlot 결과 정렬. **가능한 정렬 값: `Grade`, `NoSort`, `SlotDateTime`.**
- `exactAppointment` (Boolean, Required).
- **Return:** `List<FSL.AppointmentBookingSlot>`

```apex
// grade 정렬
ServiceAppointment sa = [SELECT Id, EarliestStartTime, DueDate FROM ServiceAppointment WHERE Id='08p4F0000008sRMQAY'];
Id schedulingPolicyId = [SELECT Id FROM FSL__Scheduling_Policy__c WHERE Name='Customer First' LIMIT 1].Id;
operatinghours oh = new operatinghours();
oh = [SELECT id, (SELECT EndTime, StartTime, Type, DayOfWeek FROM TimeSlots) FROM OperatingHours WHERE name='AB Slot: 2 Hour Slots' LIMIT 1];
Timezone tz = UserInfo.getTimeZone();
FSL.AppointmentBookingService.SortResultsBy sortResults = FSL.AppointmentBookingService.SortResultsBy.Grade;
List<FSL.AppointmentBookingSlot> slots = FSL.AppointmentBookingService.GetSlots(sa.Id, schedulingPolicyId, oh, tz, sortResults, false);
```

### getSlots(serviceID, policyId, calendar, tz, sortBy, exactAppointment)

`String` sortBy를 받는 정렬 오버로드.

```apex
public static List<FSL.AppointmentBookingSlot> getSlots(Id serviceID, Id policyId, OperatingHours calendar, System.TimeZone tz, String sortBy, Boolean exactAppointment)
```

- `serviceID` (Id, Required), `policyId` (Id, Required), `calendar` (OperatingHours object, Required; TimeZone 무시), `tz` (System.TimeZone, Required).
- `sortBy` (String, Required): AppointmentBookingSlot 결과 정렬. **허용 값: `SORT_BY_GRADE`, `SORT_BY_DATE`, `SORT_BY_NO_SORT`.**
- `exactAppointment` (Boolean, Required).
- **Return:** `List<FSL.AppointmentBookingSlot>`

> **참고:** `SortResultsBy` enum(`Grade`/`NoSort`/`SlotDateTime`)과 `sortBy` String 상수(`SORT_BY_GRADE`/`SORT_BY_DATE`/`SORT_BY_NO_SORT`)는 별개의 정렬 지정 방식이다.

### getABSlots(serviceID, policyId, calendar, tz, sortBy, exactAppointment)

complex work 의존성을 존중하는 service appointment chain용 슬롯을 반환.

```apex
public static FSL.ABSlotsResponse getABSlots(Id serviceID, Id policyId, OperatingHours calendar, System.TimeZone tz, String sortBy, Boolean exactAppointment)
```

- `serviceID` (Id, Required), `policyId` (Id, Required).
- `calendar` (OperatingHours object and related TimeSlot object, Required; TimeZone 무시), `tz` (System.TimeZone, Required).
- `sortBy` (String, Required): `SORT_BY_GRADE`, `SORT_BY_DATE`, `SORT_BY_NO_SORT`.
- `exactAppointment` (Boolean, Required): 이 메서드 호출 시 work type의 exactAppointment 무시.
- **Return:** `FSL.ABSlotsResponse`
- Usage: complex work chain(2 appointments)의 슬롯 조회. complex work 설정 "Use all-or-none scheduling for related appointments"를 존중. 반환 슬롯은 API에 보낸 service appointment용.
  - **ESO enabled:** 동기 실행 / 항상 ESO 동작(all-or-none) / chain of up to five to[sic] appointments 유효. **[sic] — 원문 "a chain of up to five to appointments"에 중복 단어 "to" 있음.**
  - **ESO 미사용:** 비동기. 결과 확인은 streaming API + `MstCompletedChannel` 구독.
  - 슬롯만 반환, 스케줄 안 함. `ArrivalWindowStartTime`/`EndTime` 업데이트 후 `FSL.ScheduleService`의 `scheduleExtended` 메서드 호출. dateTime은 UTC로 변환.

```apex
ServiceAppointment sa = [
    SELECT Id, EarliestStartTime, DueDate
    FROM ServiceAppointment
    WHERE Id='08p4F0000008sRMQAY'
];
Id schedulingPolicyId = [
    SELECT Id
    FROM FSL__Scheduling_Policy__c
    WHERE Name='Customer First'
    LIMIT 1
].Id;
OperatingHours oh = [
    SELECT Id,(SELECT EndTime, StartTime, Type, DayOfWeek, FSL__Designated_Work_Boolean_Fields__c
    FROM TimeSlots)
    FROM OperatingHours
    WHERE Name='AB Slot: 2 Hour Slots'
    LIMIT 1
];
TimeZone tz = UserInfo.getTimeZone();
FSL.ABSlotsResponse ABSlotsResponse = FSL.AppointmentBookingService.getABSlots(sa.Id, schedulingPolicyId, oh, tz, 'SORT_BY_DATE', false);
List<FSL.AppointmentBookingSlot> slots = ABSlotsResponse.Slots;
System.debug('Returned ' + slots.size() + ' appointment slots');
for (integer i = 0; i < slots.size(); i++) {
    System.debug('Slot:' + i + ' Start: ' + slots[i].Interval.Start + ' Finish: ' + slots[i].Interval.Finish + ' Grade: ' + slots[i].Grade);
}
```

---

## 3. AppointmentBookingSlot Class

주어진 service appointment에 가용한 booking slot. `AppointmentBookingService`와 `GradeSlotsService` 결과의 일부.

**Namespace:** FSL

> `BestSlotGrades` 파라미터는 private이며 코드로 접근 불가. debug log는 결과의 관련 부분(`Grade`, `Interval`)만 보여준다.

```text
AppointmentBookingSlot:
[
Grade=85.1851851851851851851851851851852,
Interval=TimeInterval:
[
2018-01-26 09:00:00,2018-01-26 11:00:00
]
]
```

**프로퍼티:**

| 프로퍼티 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `grade` | `public Decimal grade {get; set;}` | `Decimal` | The grade of the available appointment booking slot. |
| `interval` | `public FSL.TimeInterval interval {get; set;}` | `FSL.TimeInterval` | The time frame of the returned appointment booking slot. |

---

## 4. GradeSlotsService Class

Candidates quick action에 표시되는 결과. 주어진 service appointment를 스케줄링 가능한 모든 슬롯을 평가한다.

**Namespace:** FSL

**Usage:** 스케줄링 권한 주의는 상단 "스케줄링 공통 권한 주의" 참조.

**생성자:**

### GradeSlotsService(schedulingPolicyId, serviceAppointmentId)

```apex
public GradeSlotsService(Id schedulingPolicyId, Id serviceAppointmentId)
```

- `schedulingPolicyId` (Id): service appointment를 스케줄링하는 데 사용되는 scheduling policy 레코드 ID.
- `serviceAppointmentId` (Id): 스케줄링되는 service appointment 레코드 ID.

**메서드:**

### getGradedMatrix(i_ResultsInUserTimeZone)

resource ID와 graded time slot의 매트릭스를 반환(Candidates quick action과 유사).

```apex
public FSL.AdvancedGapMatrix getGradedMatrix(Boolean i_ResultsInUserTimeZone)
```

- `i_ResultsInUserTimeZone` (Boolean): `true`면 모든 DateTime을 사용자 time zone으로, `false`면 UTC로 반환.
- **Return:** `FSL.AdvancedGapMatrix`
- Usage: ESO enabled면 동기 실행. ESO 미사용 시 한 번에 하나의 service appointment만, 비동기 실행. 결과 확인은 streaming API + `MstCompletedChannel` 구독.

```apex
// FSL.AdvancedGapMatrix 결과 파싱
Id serviceAppointmentId = '08p1N000000qN4sQAE';
Id schedulingPolicyId=[SELECT Id FROM FSL__Scheduling_Policy__c WHERE Name='Customer First' LIMIT 1].Id;
FSL.GradeSlotsService mySlotService = new FSL.GradeSlotsService(schedulingPolicyId,serviceAppointmentId);
FSL.AdvancedGapMatrix myResultMatrix = mySlotService.getGradedMatrix(true);
Map<Id,FSL.ResourceScheduleData> mySRGradedTimeSlotMap = myResultMatrix.ResourceIDToScheduleData;
for (Id thisresourceid : mySRGradedTimeSlotMap.keySet()){
    for (FSL.SchedulingOption thisso : mySRGradedTimeSlotMap.get(thisresourceid).SchedulingOptions ) {
        system.debug('***** Resource Id' + thisresourceid);
        system.debug('***** Start - ' + thisso.Interval.Start);
        system.debug('***** Finish - ' + thisso.Interval.Finish);
        system.debug('****** Grade - ' + thisso.Grade);
    }
}
```

---

## 5. AppointmentInsightsResult Class

`getAppointmentInsights` 메서드가 반환하는 응답. service appointment가 Gantt에 추가될 수 없는 이유(resource availability, blocked slots, applicable blocking rules) 세부를 포함.

**Namespace:** FSL

```text
// getAppointmentInsights 출력 예 (차단 슬롯 없음)
AppointmentInsightsResult:[
blockedSlots=0,
blockingRules=(BlockingRule:[
    ruleName=Due Date,
    slotsBlockedByMultipleRules=0,
    slotsBlockedByRule=0
]),
horizonEndDate=2024-06-06 14:00:00,
horizonStartDate=2024-05-27 14:00:00,
operationTimeStamp=2024-06-16 14:00:53,
policyId=a0c8B00000638CMQAY,
resourcesEvaluated=0,
serviceAppointmentId=08p8B000000jCjBQAU,
serviceTerritoryId=0Hh8B000000HrctSAC
]
```

**프로퍼티 (모두 global):**

| 프로퍼티 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `blockedSlots` | `global Integer blockedSlots {get; set;}` | `Integer` | The total number of potential blocked slots returned by the getAppointmentInsights method. |
| `blockingRules` | `global List<BlockingRule> blockingRules {get; set;}` | `List<BlockingRule>` | Array of blocking rules with the rule name and number of slots |
| `horizonStartDate` | `global Datetime horizonStartDate {get; set;}` | `Datetime` | The horizon start date as calculated and used by the operation. |
| `horizonEndDate` | `global Datetime horizonEndDate {get; set;}` | `Datetime` | The horizon end date as calculated and used by the operation. |
| `operationTimeStamp` | `global Datetime operationTimeStamp {get; set;}` | `Datetime` | The time the operation was executed in Coordinated Universal Time (UTC). |
| `policyId` | `global Id policyId {get; set;}` | `Id` | The default policy ID or the policy ID provided in the request. |
| `resourcesEvaluated` | `global Integer resourcesEvaluated {get; set;}` | `Integer` | The total number of service resources loaded by fetch data and evaluated by the getAppointmentInsights method. |
| `serviceAppointmentId` | `global Id serviceAppointmentId {get; set;}` | `Id` | The ID of the service appointment used for the request. |
| `serviceTerritoryId` | `global Id serviceTerritoryId {get; set;}` | `Id` | service appointment에 연관된 service territory. service appointment에 territory가 없으면 비워 둔다. 이 프로퍼티는 optional. |

---

## 6. BlockingRule Class

blocking rule 배열을 보유하는 global class. `AppointmentInsightsResult`의 `blockingRules`에 대한 Apex class type이며 필수 파라미터.

**Namespace:** FSL

**프로퍼티 (모두 global):**

| 프로퍼티 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `ruleName` | `global String ruleName {get; set;}` | `String` | The name of the rule that is blocking the slot. When there is no rule name, use the rule type. |
| `slotsBlockedByMultipleRules` | `global Integer slotsBlockedByMultipleRules {get; set;}` | `Integer` | The number of slots that are blocked by a combination of this rule and others. |
| `slotsBlockedByRule` | `global Integer slotsBlockedByRule {get; set;}` | `Integer` | The number of slots that are blocked only by this rule. |

---

## 7. GroupData Class

group policy ID와 service territory ID 리스트를 결합하는 global class. `FSL.ScheduleJobsApi.getJob.setTerritory`의 필수 입력 파라미터. 두 입력: `groupPolicyId`, `territoryIds` 리스트.

**Namespace:** FSL

```apex
// 원문 Example — GroupData 채우기 (생성자 노출)
global class GroupData {
        public String groupPolicyId { get; set; }
        public List<String> territoryIds { get; set; }

             global GroupData(String groupPolicyId, List<String> territoryIds) {
                 this.groupPolicyId = groupPolicyId;
                 this.territoryIds = territoryIds;
             }
       }
```

**생성자:** `global GroupData(String groupPolicyId, List<String> territoryIds)`

**프로퍼티:**

| 프로퍼티 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `groupPolicyId` | `public String groupPolicyId { get; set; }` | `String` | The group policy of a job required by FSL.ScheduleJobsApi.getJob.setTerritory. |
| `territoryIds` | `public List<String> territoryIds { get; set; }` | `String` `[sic]` | service territory ID 리스트(FSL.ScheduleJobsApi.getJob.setTerritory가 요구). **[sic] — Property Value 섹션에 Type이 `String`으로 표기되어 있으나 시그니처상 실제 타입은 `List<String>`.** |

> `ScheduleJobsApi` 본문 Example은 이 클래스를 `FSL.ScheduleJobsApi.GroupData`(inner-class 경로)로도 참조한다 — 원문이 `FSL.GroupData`와 두 경로 모두 사용.

---

## 8. OAAS Class

가용 optimization service(global / in-day optimization, reshuffle, resource schedule optimization)에 사용되는 모든 메서드를 포함.

**Namespace:** FSL

**Usage:** OAAS API를 비동기 실행하는 다음 메서드에서 호출하면 `Database.executeBatch` 예외 에러 메시지를 받는다 — start batch Apex method, execute batch Apex method, future methods. (ESO 사용 시 이 제한은 적용되지 않음.)

**메서드 (모두 static):**

### optimize(request)

트리거된 global optimization 프로세스의 optimization request ID 반환. scheduling policy에 in-day optimization Boolean이 `true`면 in-day optimization을 트리거.

```apex
public static Id optimize(FSL.OAASRequest request)
```

- `request` (FSL.OAASRequest): The optimization request.
- **Return:** `Id` — optimization request의 레코드 ID.

```apex
DateTime start=Datetime.now();
DateTime finish=Datetime.now().addDays(3);
LIST<Id> lstServiceTerritories = new List<Id>();
lstServiceTerritories.add('0Hh0b000000cIwsCAE');
FSL.OAASRequest oaasRequest = new FSL.OAASRequest();
oaasRequest.allTasksMode = true;
oaasRequest.filterFieldAPIName = null;
oaasRequest.start = start;
oaasRequest.finish = finish;
oaasRequest.includeServicesWithEmptyLocation = false;
oaasRequest.locations = lstServiceTerritories;
oaasRequest.schedulingPolicyID = 'a0N4E0000031HKkUAM';
FSL.OAAS oaas = new FSL.OAAS();
id optRequest = oaas.optimize(oaasRequest);
```

### reshuffle(serviceId, policyId)

주어진 service appointment에서 시작된 reshuffle 작업의 optimization request ID 반환.

```apex
public static Id reshuffle(Id serviceId, Id policyId)
```

- `serviceId` (Id): 스케줄해야 하는 service appointment 레코드 ID.
- `policyId` (Id): 스케줄링에 사용되는 scheduling policy 레코드 ID.
- **Return:** `Id` — optimization request의 레코드 ID.
- Usage: full schedule 내에 high-priority service appointment를 스케줄해야 할 때 사용. "mini-optimization"을 실행.

```apex
FSL.OAAS oaas = new FSL.OAAS();
id optRequest = oaas.reshuffle('08p4E000000M21CQAS', 'a0N4E0000031HKkUAM');
```

### resourceDayOptimization — 4개 오버로드

단일 service resource의 schedule을 최적화한다. candidate/unschedulable 파라미터가 `String`인지 `Set`인지, 그리고 `nowTimeOnSchedule`(Datetime) 인자가 있는지에 따라 4개 오버로드가 존재한다.

> **[sic] 원문 불일치:** `Set` 오버로드의 시그니처는 파라미터를 `Set<String>`로 적었으나, 파라미터 설명표는 `Set<Id>`로 표기한다. 아래에는 시그니처(원문 그대로)와 설명표의 타입을 모두 표기한다.

**공통 파라미터 (4개 오버로드 공유):**

- `resourceId` (Id): schedule이 최적화되는 service resource 레코드 ID.
- `policyId` (Id): scheduling policy 레코드 ID.
- `horizon` (FSL.TimeInterval): resource schedule optimization 실행 시간 프레임.
- `includeAllTasks` (Boolean): `true`면 시간 프레임 내 모든 관련 service appointment 고려. `false`면 unscheduled만 고려, scheduled는 pinned(unmovable).
- `includeOnlyResourceFutureSA` (Boolean): `true`면 이미 해당 service resource에 할당된 appointment만 고려. `false`면 다른 resource 할당 appointment도 고려.
- `radius` (Decimal): 필수 appointment(unschedulable 필드로 정의)와 인접 appointment 간 제안 거리. `null`이면 radius 기반 필터를 하지 않음.
- `maxOptRuntime` (Decimal): optimization 결과 반환 시간(초). optimization 시간만 강제(queue / Apex job queue 시간 미포함). `null`이면 기본 30초.
- `nowTimeOnSchedule` (Datetime, variant B·D만): scheduled start time이 이 시간보다 이른 appointment는 required로 간주되어 RSO 중 업데이트되지 않음. RSO가 비동기이므로 optimization 시작 시점을 지정. (예: `nowTimeOnSchedule = April 17, 2018, 10:30`이면 그 이전에 시작하는 appointment는 required로 RSO에서 제외.)

**Return (모든 오버로드):** `Id` — optimization request의 레코드 ID.

**Variant A — String fields, no nowTimeOnSchedule:**

```apex
public static Id resourceDayOptimization(Id resourceId, Id policyId, FSL.TimeInterval horizon, Boolean includeAllTasks, Boolean includeOnlyResourceFutureSA, Decimal radius, String candidateSasFields, String unschedulableServicesField, Decimal maxOptRuntime)
```

- `candidateSasFields` (String): 스케줄 후보 appointment를 나타내는 Boolean service appointment 필드.
- `unschedulableServicesField` (String): service appointment가 required(pinned)인지 나타내는 Boolean 필드.

**Variant B — String fields + nowTimeOnSchedule:**

```apex
public static Id resourceDayOptimization(Id resourceId, Id policyId, FSL.TimeInterval horizon, Boolean includeAllTasks, Boolean includeOnlyResourceFutureSA, Decimal radius, String candidateSasFields, String unschedulableServicesField, Decimal maxOptRuntime, Datetime nowTimeOnSchedule)
```

- `candidateSasFields` (String), `unschedulableServicesField` (String) — Variant A와 동일.

```apex
FSL.OAAS a = new FSL.OAAS();
//SET the horizon interval
DateTime start = DateTime.newInstanceGmt(DateTime.Now().dateGmt(), Time.newInstance(0,0,0,0));
DateTime finish = start.addDays(3);
FSL.TimeInterval horizon = new FSL.TimeInterval(start,finish);
//SELECT the candidatesServices
List<ServiceAppointment> services = [SELECT Id FROM ServiceAppointment WHERE Id IN ('08p4E00000017Gp','08p4E00000017Go') ];
SET<Id> candidatesIds = new SET<Id>();
FOR(ServiceAppointment service : services) {
    candidatesIds.add(service.Id);
}
//SET the RSO required appointment services
Set<Id> requiredSaIds = new Set<Id>();
List<ServiceAppointment> services2 = [SELECT Id FROM ServiceAppointment WHERE Id='08p4E00000017Gq'];
FOR(ServiceAppointment service : services2) {
    requiredSaIds.add(service.Id);
}
//START the RSO process
Id requestId = a.resourceDayOptimization('0Hn4E0000004JRS','a1w4E000000Ac6S',horizon,false,true,50, candidatesIds,requiredSaIds,60,DateTime.newInstance(2018,1,0,0,0,0));
```

> 위 Example은 `Set<Id>` candidatesIds/requiredSaIds를 넘기므로 실제로는 아래 Variant D(Set + nowTimeOnSchedule) 오버로드와 매칭된다.

**Variant C — Set fields, no nowTimeOnSchedule:**

```apex
public static Id resourceDayOptimization(Id resourceId, Id policyId, FSL.TimeInterval horizon, Boolean includeAllTasks, Boolean includeOnlyResourceFutureSA, Decimal radius, Set<String> candidateSas, Set<String> unschedulableServices, Decimal maxOptRuntime)
```

- `candidateSas` — 시그니처는 `Set<String>`, 설명표는 `Set<Id>` `[sic]`: 스케줄 후보 service appointment ID 집합.
- `unschedulableServices` — 시그니처 `Set<String>`, 설명표 `Set<Id>` `[sic]`: required(pinned) service appointment ID 집합.

**Variant D — Set fields + nowTimeOnSchedule:**

```apex
public static Id resourceDayOptimization(Id resourceId, Id policyId, FSL.TimeInterval horizon, Boolean includeAllTasks, Boolean includeOnlyResourceFutureSA, Decimal radius, Set<String> candidateSas, Set<String> unschedulableServices, Decimal maxOptRuntime, Datetime nowTimeOnSchedule)
```

- `candidateSas` — 시그니처 `Set<String>`, 설명표 `Set<Id>` `[sic]`: 후보 service appointment ID 집합.
- `unschedulableServices` — 시그니처 `Set<String>`, 설명표 `Set<Id>` `[sic]`: required service appointment ID 집합. 다른 time slot으로 이동 가능하나 Earliest Start Permitted / Due Date를 준수.
- `nowTimeOnSchedule` (Datetime, Optional).

---

## 9. OAASRequest Class

`OAAS.optimize()` 메서드에 보내는 request. global optimization 호출의 모든 세부를 포함.

**Namespace:** FSL

**프로퍼티 (모두 public):**

| 프로퍼티 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `allTasksMode` | `public Boolean allTasksMode {get; set;}` | `Boolean` | `true`면 시간 프레임 내 모든 service appointment를 optimization 중 고려. `false`면 unscheduled만 고려하고 scheduled는 pinned(unmovable). |
| `filterFieldAPIName` | `public String filterFieldAPIName {get; set;}` | `String` | ServiceAppointment object의 Boolean 필드 API name. 그 Boolean 필드가 `true`인 service appointment만 optimize. |
| `start` | `public Datetime start {get; set;}` | `Datetime` | optimization 프로세스가 스케줄링 데이터를 고려하는 시간 프레임의 시작. |
| `finish` | `public Datetime finish {get; set;}` | `Datetime` | optimization 프로세스가 스케줄링 데이터를 고려하는 시간 프레임의 끝. |
| `includeServicesWithEmptyLocation` | `public Boolean includeServicesWithEmptyLocation {get; set;}` | `Boolean` | `true`면 연관 service territory가 있는 appointment와 없는 appointment 모두 고려. `false`면 territory가 있는 appointment만 고려. |
| `keepApptScheduled (Beta)` | `public String keepApptScheduled {get; set;}` | `String` | ServiceAppointment object의 Boolean 필드 API name. 그 Boolean 필드가 `true`인 service appointment는 global 또는 in-day optimization 후 절대 schedule에서 drop되지 않음. keepApptScheduledis[sic] only available for Enhanced Scheduling and Optimization. **[sic] — 원문 "keepApptScheduledis"에 공백 누락.** |
| `locations` | `public List<Id> locations {get; set;}` | `List<Id>` | optimization이 실행될 service territory ID 리스트. |
| `numberOfServicesToSchedule` | `public Integer numberOfServicesToSchedule {get; set;}` | `Integer` | Not currently in use. Leave as null. |
| `schedulingPolicyId` | `public Id schedulingPolicyId {get; set;}` | `Id` | service appointment 스케줄링에 사용되는 scheduling policy 레코드 ID. |

**`keepApptScheduled` (Beta) — 4가지 property value option:**

- **Valid field name:** ServiceAppointment object의 유효한 Boolean 필드. "Keep Scheduled" 표시 appointment는 global / in-day optimization 후 drop되지 않음.
- **Invalid field name:** 필드가 없거나 Boolean이 아님 → 에러 메시지.
- **Null:** org-level default(global / in-day optimization settings)에 따라 "Keep Scheduled" 표시.
- **NO_KEEP_APPT_SCHEDULED:** "Keep Scheduled" 표시 안 됨.

---

## 10. PolygonUtils Class

위경도 geolocation 값을 통해 service territory record ID를 반환. `getTerritoryIdByPolygons`로 위경도로 territory ID를 조회.

**Namespace:** FSL

**Usage:** 호출 전에 service territory와 연관된 기존 map polygon 레코드가 필요. "Base service appointment territories on polygons"가 enabled면 global action이 이 클래스를 사용해 ServiceAppointment의 Service Territory 필드를 채운다. 표준 FSL Global Actions 미사용 시 `getTerritoryIdByPolygons`로 Service Territory lookup 필드를 채울 수 있다. territory를 못 찾으면 `null` 반환.

**메서드 (모두 static):**

### getTerritoryIdByPolygons(longitude, latitude)

```apex
static Id getTerritoryIdByPolygons(Double longitude, Double latitude)
```

- `longitude` (Double, Required): Polygon Classification으로 service territory 레코드 ID 조회에 사용할 geolocation의 longitude.
- `latitude` (Double, Required): 동일 latitude.
- **Return:** `Id`
- Usage: service appointment의 geolocation이 둘 이상 polygon에 매치되면 설정에 따라 계층 내 최상위 또는 최하위 territory에 할당.

```apex
List<ServiceAppointment> sas = [select id, latitude, longitude from serviceappointment where appointmentnumber = 'SA-3600' limit 1];
If(!sas.isEmpty()){
     Id ServiceTerritoryId = FSL.PolygonUtils.getTerritoryIdByPolygons(double.valueOf(sas[0].longitude),double.valueOf(sas[0].latitude));
      system.debug(ServiceTerritoryId);
}
```

### getAllPolygonsByLatLong(longitude, latitude)

위경도 점을 포함하는 모든 매칭 polygon의 ID 리스트를 반환.

```apex
static List getAllPolygonsByLatLong(Double longitude, Double latitude)
```

- `longitude` (Double, Required): polygon classification으로 service territory 레코드 ID 조회용 longitude.
- `latitude` (Double, Required): 동일 latitude.
- **Return:** `List<Id>`
- Usage: 위경도 값으로 polygon record ID 리스트 반환. The method doesn't include sharing.

```apex
Double longitude = 32.077213;
Double latitude = 34.792759;
    List<FSL__Polygon__c> relevantPolygons = FSL.PolygonUtils.getAllPolygonsByLatLong (longitude,latitude);
    system.debug(relevantPolygons);
```

---

## 11. RecurringAppointmentsManager Class

`RecurringPattern` 클래스를 필수 파라미터로 받아 weekly 반복 `RecurringSequence` appointment 리스트를 반환.

**Namespace:** FSL

**메서드 (static):**

### getRecurringAppointmentsSlots

```apex
static List getRecurringAppointmentsSlots
```

> **[sic]** — 원문 Signature는 위와 같이 파라미터가 미표기되어 있다. 파라미터는 아래 표와 Example 코드로 확인된다.

**파라미터:**

- `ServiceID` (Id, Required): recurring visit을 나타내는 service appointment ID. 이 레코드가 각 appointment의 스케줄링 요구/제약을 정의. 모든 visit이 이 service appointment의 location, required resources, skill requirements, 기타 제약을 사용.
- `PolicyID` (Id, Required): 작업의 관련 work rule / objective를 얻는 데 사용할 policy.
- `CalendarOperatingHoursId` (Id, Required): API가 반환하는 슬롯 구조 결정에 사용하는 operating hours ID.
- `RecurringPattern` (RecurringPattern Class, Required): recurring pattern의 모든 필수 세부를 담아 파라미터로 전달되는 클래스 인스턴스.
- `SchedulingOptionsCount` (Integer, Required): API가 반환하는 scheduling option set 수. 1~3 set 가능. 3 선택했으나 3 미만이면 발견된 수만큼 반환. **Important: As of API version 60.0, SchedulingOptionsCount is hard coded to 3.**
- **Return:** `List RecurringSequence`

> **[sic] 파라미터 순서·반환 타입 불일치:** Example의 실제 호출 인자 순서는 `(serviceId, policyID, operatingHoursId, schedulingOptionsCount, pattern)` — `SchedulingOptionsCount`가 `pattern` 앞에 위치한다. 그러나 파라미터 표 순서는 `(ServiceID, PolicyID, CalendarOperatingHoursId, RecurringPattern, SchedulingOptionsCount)`로 다르다. 또한 본문 반환 타입은 `List RecurringSequence`라고 적혀 있으나 Example에서는 `FSL.RecurringAppointmentSlots`(recurringSequences 프로퍼티 보유)를 받는다. `RecurringAppointmentSlots` 클래스는 19클래스 범위 밖이나 RecurringSequence Example에 구조가 노출됨(아래 13번).

**Usage:** weekly 반복 appointment 리스트 반환. potential scheduling option(`RecurringSequence`)만 반환하며 스케줄링은 하지 않음. `getSlots`(AppointmentBookingService)와 유사하게 응답으로 insert할 레코드 리스트를 만든 후 스케줄. ServiceAppointment의 time constraint 필드가 모든 recurrence appointment에 사용됨. `EarliestStartTime`과 `DueDate` 사이 충분한 차이 필요(예: 6 appointment, 월요일만 visiting hours면 6주 필요). `ArrivalWindowStartTime`/`EndTime` 같은 더 제한적 필드 설정 금지.

```apex
// Example 1: Execution Script — 주말 제외, 주 2회, 총 6회, 3 옵션
//Fill the pattern object
FSL.RecurringPattern pattern = new FSL.RecurringPattern();
pattern.DaysOfWeek = new Set<FSL.RecurringPattern.DaysOfWeek>{FSL.RecurringPattern.DaysOfWeek.Monday,
FSL.RecurringPattern.DaysOfWeek.Wednesday, FSL.RecurringPattern.DaysOfWeek.Thursday,
FSL.RecurringPattern.DaysOfWeek.Friday};
pattern.FrequencyType = FSL.RecurringPattern.FrequencyType.WEEKLY;
pattern.Frequency = 2;
pattern.NumberOfVisits = 6;
Integer schedulingOptionsCount = 3;
Id policyID = 'a1Lx00000004CUXEA2';
Id serviceId = '08px000000NzmOeAAJ';
Id operatingHoursId = '0OHx0000000D3ETGA0';
//Call the API
FSL.RecurringAppointmentSlots result = FSL.RecurringAppointmentsManager.getRecurringAppointmentsSlots(serviceId , policyID, operatingHoursId, schedulingOptionsCount, pattern);
//Handle the response of the API (example only)
for (Integer i=1 ; i<= result.recurringSequences.size() ; i++){
    System.debug('Sequence number: ' + i);
    System.debug('participatingResources details: /n' + result);
    System.debug('visitSchedulingOptions details: /n' + result);
    System.debug('averageObjectivesGrades details: /n' + result);
    System.debug('sequenceScore details: /n' + result);
    System.debug('firstPatternOccurrence details: /n' + result);
}
```

```apex
// Example 2: Method 형태
public callRecurringVisitsAPI(Id serviceID, Id policyID, Id calendarOperatingHoursId, Integer SchedulingOptionsCount) {
//Fill the pattern object
RecurringPattern pattern = new FSL.RecurringPattern();
pattern.DaysOfWeek = new Set<RecurringPattern.DaysOfWeek>{RecurringPattern.DaysOfWeek.Monday,
 RecurringPattern.DaysOfWeek.Wednesday, RecurringPattern.DaysOfWeek.Thursday,
RecurringPattern.DaysOfWeek.Friday};
pattern.FrequencyType = RecurringPattern.FrequencyType.WEEKLY;
pattern.Frequency = 2;
pattern.NumberOfVisits = 6;
//Call the API
FSL.RecurringAppointmentSlots result = RecurringAppointmentsManager.getRecurringAppointmentsSlots(serviceID, policyID, calendarOperatingHoursId, SchedulingOptionsCount, pattern);
}
```

---

## 12. RecurringPattern Class

`RecurringAppointmentsManager`가 weekly 반복 appointment 패턴을 반환하기 위한 필수 파라미터인 global sharing class. API 호출을 위해 모든 프로퍼티가 완성되어야 한다.

**Namespace:** FSL

```apex
// 원문 Example — RecurringPattern과 프로퍼티
global class RecurringPattern {
   global enum DaysOfWeek {Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday}
   global enum FrequencyType {DAILY, WEEKLY, MONTHLY}
   global Set<DaysOfWeek> DaysOfWeek { get; set; }
   global FrequencyType FrequencyType { get; set; }
   global Integer Frequency { get; set; }
   global Integer NumberOfVisits { get; set; }
}
```

**열거형 값:**

| Enum | 값 |
|---|---|
| `DaysOfWeek` | Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday |
| `FrequencyType` | DAILY, WEEKLY, MONTHLY |

**프로퍼티 (모두 global):**

| 프로퍼티 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `DaysOfWeek` | `global Set<DaysOfWeek> DaysOfWeek { get; set; }` | `Set<enum>` | appointment 예약에 사용할 수 있는 day 리스트. service appointment에 연관된 visiting hours record에서 도출하거나 수동 설정 가능. 하루 1 visit만 스케줄해야 함(예: 총 6 visit, DaysOfWeek=Monday+Wednesday면 월 1회·수 1회를 초과하는 응답은 반환되지 않음). |
| `Frequency` | `global Integer Frequency { get; set; }` | `Integer` | The number of appointments to book inside the FrequencyType time frame provided. |
| `FrequencyType` | `global FrequencyType FrequencyType { get; set; }` | `Enum` | recurring appointment의 빈도. 현재는 weekly frequency만 지원. |
| `NumberOfVisits` | `global Integer NumberOfVisits { get; set; }` | `Integer` | Total number of appointments to schedule. |

---

## 13. RecurringSequence Class

`getRecurringAppointmentsSlots` 메서드가 반환하는 daily/weekly/monthly 반복 appointment 패턴 결과. 별도 프로퍼티 섹션 없이 Example 내에 구조가 노출된다.

**Namespace:** FSL

```apex
// 원문 Example — 반환 RecurringSequence object 구조 (컨테이너 RecurringAppointmentSlots 포함)
global class RecurringAppointmentSlots {
    global ServiceAppointment rootServiceAppointment;
    global List<RecurringSequence> recurringSequences;
}

global class RecurringSequence {
    global List<EncapsulatedResource> participatingResources;
    global List<SchedulingOption> visitSchedulingOptions;
    global List<GradeSlotResult> averageObjectivesGrades;
    global Double sequenceScore;
    global List<TimeInterval> firstPatternOccurrence;
}
```

**프로퍼티 (Example 내 노출):**

| 프로퍼티 | 시그니처 | 타입 |
|---|---|---|
| `participatingResources` | `global List<EncapsulatedResource> participatingResources;` | `List<EncapsulatedResource>` |
| `visitSchedulingOptions` | `global List<SchedulingOption> visitSchedulingOptions;` | `List<SchedulingOption>` |
| `averageObjectivesGrades` | `global List<GradeSlotResult> averageObjectivesGrades;` | `List<GradeSlotResult>` |
| `sequenceScore` | `global Double sequenceScore;` | `Double` |
| `firstPatternOccurrence` | `global List<TimeInterval> firstPatternOccurrence;` | `List<TimeInterval>` |

> 컨테이너 `RecurringAppointmentSlots`는 `rootServiceAppointment`(ServiceAppointment), `recurringSequences`(`List<RecurringSequence>`)를 갖는다. `EncapsulatedResource`·`GradeSlotResult`는 19클래스 범위 밖.

---

## 14. ResourceScheduleData Class

주어진 service appointment에 대한 service resource의 가용 슬롯 세부 전체. `AdvancedGapMatrix` 결과 컨텍스트 내에서만 사용.

**Namespace:** FSL

**프로퍼티 (모두 public):**

| 프로퍼티 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `currentSlotsIndexInAB` | `public Integer currentSlotsIndexInAB {get; set;}` | `Integer` | Index of the slot. |
| `resource` | `public FSL.EncapsulatedResource resource {get; set;}` | `FSL.EncapsulatedResource` | Not currently in use. |
| `schedulingOptions` | `public List<FSL.SchedulingOption> schedulingOptions {get; set;}` | `List<FSL.SchedulingOption>` | A list of all possible scheduling options for the service resource. |

---

## 15. ScheduleJobsApi Class

Enhanced Optimization으로 분류된 모든 scheduled job에 사용 가능한 Territory tab을 구성. 두 메서드(`getJob`, `setTerritory`)를 사용하며, `getJob`이 job을 `setTerritory`에 전달하고 `setTerritory`가 `GroupData`를 통해 territory ID와 group policy ID를 job에 적용한다.

**Namespace:** FSL

**메서드 (static):**

### getJob(jobName)

```apex
global static ScheduleJobsApi getJob(String jobName)
```

- `jobName` (String, Required): service territory를 업데이트할 job 이름. **The job name is case-sensitive.**
- **Return:** `ScheduleJobsApi(validateJobId(jobId))` `[sic — 원문 그대로의 비정상 반환 타입 표기]`
- Usage: job을 `setTerritory`에 전달해 Territory tab을 업데이트.

### setTerritory(groupList)

```apex
public void setTerritory(List<GroupData> groupList)
```

- `groupList` (List<GroupData>, Required): job에 연관할 territory와 group policy를 나타내는 GroupData object 리스트.
- **Return:** `Void`
- Usage: optimized territory와 scheduling policy 기반으로 scheduled job의 Territory tab을 구성.

```apex
// Example 1
String jobName = 'Optimization';
List<FSL.ScheduleJobsApi.GroupData> groupList = new List<FSL.ScheduleJobsApi.GroupData>();
FSL.ScheduleJobsApi.GroupData firstGroup = new FSL.ScheduleJobsApi.GroupData
    ('a0cSM0000000fEU', new List<String>{'0HhSM0000000S5x', '0HhSM0000000TbV0AU'});
FSL.ScheduleJobsApi.GroupData secondGroup = new FSL.ScheduleJobsApi.GroupData
    ('0', new List<String>{'0HhSM0000000RbJ'});
groupList.add(firstGroup);
groupList.add(secondGroup);
FSL.ScheduleJobsApi.GetJob(jobName).setTerritory(groupList);
```

```apex
// Example 2
String jobName = "Optimization";
// Get all service territory groups.
List<YourGroupType> All_ST_GROUPS = getAllGroupsFromAnotherSource();
List<FSL.ScheduleJobsApi.GroupData> groupList = new List<FSL.ScheduleJobsApi.GroupData>();
for (Integer i = 0; i < All_ST_GROUPS.size(); i++) {
    FSL.ScheduleJobsApi.GroupData groupData = new FSL.ScheduleJobsApi.GroupData(
        All_ST_GROUPS[i].policyId,
        new List<String> {
            All_ST_GROUPS[i].territoryIds
        }
    );
    // Add the created groupData to the list.
    groupList.add(groupData);
}
FSL.ScheduleJobsApi.GetJob(jobName).setTerritory(groupList);
```

> Example은 `GroupData`를 `FSL.ScheduleJobsApi.GroupData`(inner-class 형태)로 참조한다. 7번 `GroupData` Class(`FSL.GroupData`)와 동일 개념의 inner-class 표기로 보이며 — 원문이 두 경로를 모두 사용한다.

---

## 16. ScheduleResult Class

`ScheduleService.schedule` 메서드가 반환하는 service appointment 스케줄링 결과.

**Namespace:** FSL

```text
// 원문 Example — 반환 ScheduledResult object 내용
[
 BreakObject=null,
 Grade=100.000000000000000000000000000000,
 LongOperationId=null,
 PartialResults=(),
 Resource=ServiceResource:
 {Id=0Hn4E0000004bucSAA, Name=Crew A, IsActive=true, IsCapacityBased=false, ResourceType=C,
 ServiceCrewId=1cr4E0000004CM7QAM, Contractor_Priority__c=2},
 Service=ServiceAppointment:
 {Id=08p4E000000LeMiQAK, Status=None, FSL__Same_Day__c=false, FSL__Same_Resource__c=false,
 AppointmentNumber=SA-6214, DueDate=2018-09-20 17:07:00, EarliestStartTime=2018-09-17 17:07:00, Duration=1.5, DurationType=Hours, Latitude=37.793872000000000,
Longitude=-122.394865000000000, FSL__InternalSLRGeolocation__Latitude__s=37.793834, FSL__InternalSLRGeolocation__Longitude__s=-122.395123, ServiceTerritoryId=0Hh4E0000000OtPSAU,
 FSL__Schedule_over_lower_priority_appointment__c=false, FSL__Use_Async_Logic__c=false, FSL__IsMultiDay__c=false, ParentRecordId=0WO4E000000Vl6rWAC, FSL__Emergency__c=false,
SchedStartTime=2018-09-17 17:13:00, SchedEndTime=2018-09-17 18:43:00, FSL__Schedule_Mode__c=Automatic, FSL__Scheduling_Policy_Used__c=a0N4E0000031HPVUA2}
 ]
```

**프로퍼티 (모두 public):**

| 프로퍼티 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `breakObject` | `public ResourceAbsence breakObject {get; set;}` | `ResourceAbsence` | Not currently in use. |
| `grade` | `public Decimal grade {get; set;}` | `Decimal` | The grade of the slot in which the service appointment was scheduled. |
| `longOperationId` | `public Id longOperationId {get; set;}` | `Id` | ESO를 사용하지 않는 scheduling service appointment에만 적용. dependent service appointment 두 개(complex work) 그룹을 스케줄링할 때 채워짐. 비동기 호출로 dependency group 내 두 appointment를 스케줄하며 `FSL__FSL_Operation__c` ID를 담는다. |
| `partialResults` | `public List<FSL.PartialResultsInfo> partialResults {get; set;}` | `List<FSL.PartialResultsInfo>` | Limit Apex Operations가 enabled일 때만 의미. ScheduleService 처리 시간이 max CPU limit 초과 직전이면 partialResultsreturns[sic] 이미 계산된 결과를 반환하고 프로세스를 중단. **[sic] — 원문 "partialResultsreturns"에 공백 누락.** |
| `serviceResource` | `public ServiceResource serviceResource {get; set;}` | `ServiceResource` | The service resource assigned to the service appointment. |
| `serviceAppointment` | `public ServiceAppointment serviceAppointment {get; set;}` | `ServiceAppointment` | The scheduled service appointment. |

---

## 17. ScheduleService Class

적용된 scheduling policy 기반으로 주어진 service appointment를 최적 가용 슬롯에 스케줄링.

**Namespace:** FSL

**Usage:** 스케줄링 엔진을 호출해 highest-scoring 가용 슬롯에 스케줄. ESO 사용 시 이 API 호출은 ESO 서비스로 callout을 트리거. ESO 미사용 시 다음 조건에서 travel time callout 가능: (1) SLR 또는 point-to-point predictive travel이 선택된 routing이고 (2) 결과가 local cache에 없을 때. 이 API 호출 전 동일 Apex transaction에서 DML 수행을 회피하는 것이 권장됨. 스케줄링 권한 주의는 상단 "스케줄링 공통 권한 주의" 참조.

**메서드 (static):**

### schedule(policy, serviceId)

```apex
public static FSL.ScheduleResult schedule(Id policy, Id serviceId)
```

- `policy` (Id): scheduling policy 레코드 ID.
- `serviceId` (Id): 스케줄링되는 service appointment 레코드 ID.
- **Return:** `FSL.ScheduleResult`
- Usage: 최적 가용 슬롯에 스케줄. 가용 슬롯 없으면 스케줄 안 함. 한 번에 하나의 service appointment만 호출 가능. 여러 개는 Apex batch class로 batch size 1로 호출. appointment booking 메서드와 함께 사용 시 time zone 변환 필요(결과는 메서드 시그니처 지정 time zone으로 반환되므로 UTC로 변환).

```apex
FSL.ScheduleResult myResult = new FSL.ScheduleResult();
myResult = FSL.ScheduleService.schedule(Scheduling Policy ID,Service Appointment ID);
System.debug(myResult);
```

### scheduleExtended(policy, serviceId)

complex work chain appointment 스케줄링 결과를 반환.

```apex
public static List<FSL.ScheduleResult> scheduleExtended(Id policy, Id serviceId)
```

- `policy` (Id): scheduling policy 레코드 ID.
- `serviceId` (Id): complex work chain 내 service appointment 레코드 ID.
- **Return:** `List<FSL.ScheduleResult>`
- Usage: complex work chain의 두 service appointment를 스케줄. complex work 설정 "Use all-or-none scheduling for related appointments"를 존중. 가용 슬롯 없으면 chain 스케줄 안 됨. 두 appointment chain에 유효. `serviceId`의 appointment가 둘 이상과 의존성이 있으면 결과가 예상과 다를 수 있음. 한 번에 하나만 호출, 비동기 실행(결과는 streaming API + `MstCompletedChannel` 구독).
  - **ESO enabled:** 동기 실행 / 항상 ESO 동작(all-or-none) / chain of up to five to[sic] appointments 유효. **[sic] — 원문 중복 단어 "to".**
  - appointment booking 메서드와 함께 사용 시 time zone 변환(UTC로).

### getAppointmentInsights

`AppointmentInsightsResult` 클래스를 반환(Gantt 스케줄 불가 이유: blocking rules, blocked slots, resource availability).

```apex
public static FSL.AppointmentInsightsResult<FSL.AppointmentInsightsResult> getAppointmentInsights(Id policyId, Id serviceAppointmentId))
```

> **[sic]** — 원문 그대로. 반환 타입에 비정상 generic 표기 `<FSL.AppointmentInsightsResult>`와 닫는 괄호 `))`가 붙어 있다.

- `serviceAppointmentId` (Id): insights를 요청하는 appointment ID.
- `policyId` (Id): appointment가 평가되는 policy ID.
- **Return:** `FSL.AppointmentInsightsResult`

> **[sic] 파라미터 순서 불일치:** 시그니처 파라미터 순서는 `(Id policyId, Id serviceAppointmentId)`이나, 파라미터 설명과 Example 호출(`getAppointmentInsights(Service Appointment ID, Scheduling Policy ID)`)은 `serviceAppointmentId`를 먼저 둔다. 원문이 양쪽으로 불일치한다.

```apex
FSL.AppointmentInsightsResult myresult = new FSL.AppointmentInsightsResult();
myresult = FSL.ScheduleService.getAppointmentInsights(Service Appointment ID,Scheduling Policy ID);
System.debug(myresult);
```

### scheduleHere(startDate, usedPolicyId, serviceAppointmentId, newResourceId)

지정 service resource에 지정 시간으로 service appointment를 스케줄. **ESO 필요(미사용 시 실패).**

```apex
global static List<FSL.ScheduleResult> scheduleHere(Datetime startDate, Id usedPolicyId, Id serviceAppointmentId, Id newResourceId)
```

- `startDate` (Datetime): 스케줄할 desired 시작 일시. `getAppointmentCandidates` 결과로 슬롯 선택. startDate는 getAppointmentCandidates 스케줄링 horizon 내여야 함(default 10일, 최대 30일 구성 가능).
- `usedPolicyId` (Id): 스케줄링 규칙·optimization용 scheduling policy ID.
- `serviceAppointmentId` (Id): 스케줄할 service appointment ID.
- `newResourceId` (Id): appointment에 할당할 service resource ID.
- **Return:** `List<FSL.ScheduleResult>` — scheduled service appointment 세부(업데이트된 start/end time, 할당 resource, grade/score, 추가 메타데이터)를 포함하는 리스트.
- Usage: getAppointmentCandidates 호출 후 특정 candidate slot/resource에 스케줄. start time 설정 후 end time은 service duration과 service resource efficiency 기반 계산. 충돌 방지 위해 resource locking과 collision detection 수행. complex work chain의 dependent appointment 처리(모두 동기 스케줄, 각각 ScheduleResult 반환). chain 명시 스케줄은 `scheduleExtended` 참조. sliding/reshuffling enabled면 reshuffle logic 적용(high-priority 신규 appointment가 기존 appointment drop을 유발 가능).

```apex
Id serviceApptId = '08pxx000000001';
Id resourceId = '0Hnxx000000001';
Id policyId = '0Uyxx000000001';
Datetime startTime = Datetime.newInstance(2024, 12, 15, 9, 0, 0);
List<FSL.ScheduleResult> results = FSL.ScheduleService.scheduleHere(
    startTime,
    policyId,
    serviceApptId,
    resourceId
);
if (results != null && !results.isEmpty()) {
    FSL.ScheduleResult result = results[0];
    System.debug('Scheduled Service: ' + result.Service.Id);
    System.debug('Start: ' + result.Service.SchedStartTime);
    System.debug('End: ' + result.Service.SchedEndTime);
    System.debug('Resource: ' + result.Resource.Name);
    System.debug('Grade: ' + result.Grade);
}
```

---

## 18. SchedulingOption Class

스케줄링 가능한 개별 슬롯 세부. `AdvancedGapMatrix` 결과 컨텍스트 내에서 사용되는 run-time object.

**Namespace:** FSL

**프로퍼티 (모두 public):**

| 프로퍼티 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `grade` | `public Decimal grade {get; set;}` | `Decimal` | The grade of the available slot. |
| `interval` | `public FSL.TimeInterval interval {get; set;}` | `FSL.TimeInterval` | The time frame of the returned slot. |

---

## 19. TimeInterval Class

interval의 start/end time을 보유. scheduling horizon 또는 appointment slot/window의 start/end time 표현에 사용되는 인스턴스.

**Namespace:** FSL

**프로퍼티 (모두 public):**

| 프로퍼티 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `start` | `public Datetime start {get; set;}` | `Datetime` | The start time of the TimeInterval class. |
| `finish` | `public Datetime finish {get; set;}` | `Datetime` | The end time of the TimeInterval class. |

**메서드:**

### toString()

```apex
public String toString()
```

- **Return:** `String` — start와 end datetime을 string으로 반환.

> **생성자 메모:** `TimeInterval`은 v67.0 문서 본문에 **생성자 섹션이 없다.** 그러나 OAAS 예제에서 `new FSL.TimeInterval(start, finish)`(Datetime, Datetime) 형태의 생성자 사용이 반복 노출된다(OAAS `resourceDayOptimization` Example). 공식 생성자 시그니처가 문서에 명시되지 않았으므로, 아래는 문서에 노출된 **사용 패턴**일 뿐이다.
>
> ```apex
> // 사용 패턴(문서 Example에서 인용) — 공식 생성자 시그니처는 v67.0 문서에 미명시
> FSL.TimeInterval horizon = new FSL.TimeInterval(start, finish);
> ```

---

## 관련 노트

- [[Field Service 개요와 데이터 모델]] — Field Service 제품 개요·핵심 object(ServiceAppointment, ServiceResource, ServiceTerritory, OperatingHours 등) 데이터 모델
- [[Field Service Custom Triggers·Code Examples]] — FSL 패키지 트리거 동작 + Apex 코드 예제(dispatcher console `FSL.CustomGantt*Action` 인터페이스 구현)
- [[LxScheduler Namespace]] — ⚠️ 별개 제품(Salesforce Scheduler `lxscheduler` 네임스페이스). 혼동 주의 — FSL과 무관

> `ServiceAppointment`, `ServiceResource`, `ServiceTerritory`, `OperatingHours`, `FSL__Scheduling_Policy__c`, `FSL__Polygon__c` 등 object는 Object Reference(미작성)이므로 backtick 평문으로 표기.
