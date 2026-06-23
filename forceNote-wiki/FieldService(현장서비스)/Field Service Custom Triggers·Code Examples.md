---
tags: [field-service, fsl, apex-trigger, code-examples, dispatcher-console, service-report, work-order, platform-event, 현장서비스, 커스텀트리거, 코드예제]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [Field Service Triggers, FSL Triggers, Field Service Custom Triggers, Dispatcher Console Custom Actions, FSL Code Examples, CreateFilterEvent__e, createServiceReport, generateWorkOrders, 현장서비스 트리거, 디스패처 콘솔 커스텀 액션]
---

# Field Service Custom Triggers · Code Examples

> Field Service 관리형 패키지가 스케줄링 전후에 표준·커스텀 객체를 처리하기 위해 제공하는 24개 트리거의 동작 가이드(전수)와, Apex로 Field Service 기능을 프로그래밍하는 4개 코드 예제.

---

## 개요

> Field Service custom triggers ensure that the objects and respective fields are processed before or after scheduling.
> The Field Service package provides triggers on Salesforce objects. Each trigger checks for various conditions and then performs tasks based on what it finds. Some of the triggers run on custom objects and some on standard objects.

Field Service 관리형 패키지(`FSL` 네임스페이스)는 표준·커스텀 객체 위에 트리거를 설치한다. 트리거 컨텍스트 변수(`Trigger.new`, `Trigger.isBefore` 등)와 이벤트의 일반론은 [[Trigger 컨텍스트 변수와 이벤트]] 참조 — 본 노트는 FSL 패키지가 **실제로 어떤 트리거를 어느 객체에 설치하고 각 시점에 무슨 동작을 하는지**만 다룬다.

> FSL 네임스페이스의 Apex 클래스·인터페이스 reference는 [[FSL Apex Namespace]] 참조. 데이터 모델·객체 관계는 [[Field Service 개요와 데이터 모델]] 참조.

---

# PART 1 — Field Service Custom Triggers

## Table 6: Field Service Quick Reference for Triggers (24행 전수)

각 트리거 파일은 한 호스트 객체에 설치된다. `Object Type`은 호스트 객체가 표준 객체인지 커스텀 객체인지를 나타낸다.

| # | Trigger Name | Host Object | Object Type |
|---|---|---|---|
| 1 | `FSL__TR021_AssignedResource.trigger` | Assigned Resource | Standard Object |
| 2 | `FSL__TR004_Event.trigger` | Event | Standard Object |
| 3 | `FSL__TR030_GanttPalette.trigger` | Gantt Palette | Custom Object |
| 4 | `FSL__TR029_GanttFilter.trigger` | Gantt Filter | Custom Object |
| 5 | `FSL__TR034_OperatingHours.trigger` | Operating Hours | Standard Object |
| 6 | `FSL__TR013_OptimizationRequest.trigger` | Optimization Request | Custom Object |
| 7 | `FSL__TR028_Polygon.trigger` | Map Polygon | Custom Object |
| 8 | `FSL__TR007_ResourceAbsence.trigger` | Resource Absence | Standard Object |
| 9 | `FSL__TR010_SchedulingPolicy.trigger` | Scheduling Policy | Custom Object |
| 10 | `FSL__SchedulingPolicyWorkRule.trigger` `[sic — TR 번호 없음]` | Scheduling Policy Work Rule | Custom Object |
| 11 | `FSL__TR001_Service.trigger` | Service Appointment | Standard Object |
| 12 | `FSL__TR008_ServiceResource.trigger` | Service Resource | Standard Object |
| 13 | `FSL__TR012_Capacity.trigger` | Service Resource Capacity | Standard Object |
| 14 | `FSL__TR066_ServiceObjective.trigger` | Service Objective | Custom Object |
| 15 | `FSL__TR025_ServiceResourceSkill.trigger` | Service Resource Skill | Standard Object |
| 16 | `FSL__TR0023_ServiceTerritory.trigger` `[sic — 0023, 4자리]` | Service Territory | Standard Object |
| 17 | `FSL__TR020_ResourceTerritories.trigger` | Service Territory Member | Standard Object |
| 18 | `FSL__TR0024_ServiceTerritory.trigger` `[sic — 0024, 4자리. 파일명은 ServiceTerritory지만 Host=Skill Requirement]` | Skill Requirement | Standard Object |
| 19 | `FSL__TR051_TimeDependency.trigger` | Time Dependency | Custom Object |
| 20 | `FSL__TR027_TimeSlot.trigger` | Time Slot | Standard Object |
| 21 | `FSL__TR005_UserTerritory.trigger` | User Territory | Custom Object |
| 22 | `FSL__TR022_WorkOrder.trigger` | Work Order | Standard Object |
| 23 | `FSL__TR026_WorkRule.trigger` | Work Rule | Custom Object |
| 24 | `FSL__TR022_WorkOrderLineItem.trigger` `[sic — TR022 번호가 WorkOrder와 중복]` | Work Order Line Item | Standard Object |

> **[sic] 보존 메모:** 트리거 파일명의 오타·번호 중복은 원문 그대로다. #10 `FSL__SchedulingPolicyWorkRule`는 TR 번호가 없고, #16/#18은 TR 뒤 숫자가 4자리(0023/0024), #22·#24는 모두 `TR022`로 번호가 중복된다. 또한 #18은 파일명이 `ServiceTerritory`인데 호스트 객체는 Skill Requirement다.

---

## 트리거별 동작 가이드 (전수)

각 호스트 객체별로 Before/After × Insert/Update/Delete 시점에 트리거가 수행하는 동작이다. 요약 없이 원문 그대로 옮긴다.

### Assigned Resource

**Before Insert:**
- 생성되는 리소스 중 하나가 crew 멤버이면 트리거 실행을 중지한다(다른 flow에서 처리됨).
- 삽입되는 assigned resource에 scheduled start / schedule end time 필드가 채워져 있지 않으면 트리거를 실패시킨다.
- 생성되는 리소스에 유효한 service territory member가 할당돼 있지 않으면 트리거를 실패시킨다.
- 리소스 타입이 Crew이면 생성되는 리소스의 ServiceCrewId 필드를 채운다.

**After Insert:**
- Enable User Territories sharing 설정이 켜져 있으면, 생성된 service appointment를 service territory public group과 공유한다. service appointment 영역(territory)에 속한 dispatcher에게 공유를 제공한다. service resource가 relocate되면 새 territory의 public group과 공유돼 dispatcher가 관련 service appointment에 접근할 수 있다.
- Enable User Territories sharing 설정이 켜져 있고 해당 service appointment parent sharing 설정도 켜져 있으면, 생성된 service appointment의 parent를 service territory public group과 공유한다. 자세한 내용은 Limit Access to Field Service Records 참조.
- 상태 카테고리가 Dispatched로 바뀌면, 생성된 리소스의 service appointment를 service resource의 user들과 공유한다. service territory가 바뀌면 service territory public group과 공유한다.
- 관련 설정이 켜져 있으면 assigned resource user를 mention한다.
- 가능하면 이 작업을 비동기 메서드로 수행한다.
- 생성되는 리소스 중 하나가 crew 멤버이면 트리거 실행을 중지한다(다른 flow에서 처리됨).
- 생성된 리소스를 기반으로 calendar event를 업데이트하거나 생성한다.
- assigned resource의 service status가 None 또는 Canceled이면, 그 상태를 Assigned로 바꾼다.
- 생성된 리소스의 service가 multi-day service appointment이면, service duration 재계산이 필요한지 확인하고 필요하면 길이를 재계산한다.
- org에서 travel trigger가 켜져 있으면, service의 start/end date와 같은 날에 스케줄된 모든 service의 travel을 재계산한다.
- crew 멤버를 위한 assigned resource를 생성한다. 트리거의 리소스가 crew 타입이면 crew 멤버당 단일 리소스를 생성한다.
- 리소스의 service appointment에 따라 ResourceCapacity 객체를 업데이트한다. service appointment가 contractor에게 스케줄되면, 실제 스케줄된 작업 시간과 할당된 작업 항목을 반영하도록 capacity를 업데이트한다.

**Before Update:**
- 생성된 Assigned Resources 레코드에 유효한 Service Territory Member가 할당돼 있지 않으면 트리거를 실패시킨다.
- service resource가 crew 타입이면 ServiceCrewId 필드를 채운다.

**After Update:**
- Enable User Territories sharing 설정이 켜져 있으면, 생성된 service appointment를 service territory public group과 공유한다(After Insert와 동일 — relocate 시 새 territory public group과 공유).
- service appointment가 multi-day appointment이면, service duration 재계산이 필요한지 확인하고 필요하면 재계산한다.
- 업데이트된 assigned resource를 기반으로 calendar event를 업데이트하거나 생성한다.
- 리소스 업데이트에 따라 assigned resource를 생성·삭제한다. 트리거의 assigned resource가 crew 타입 service resource이면 crew 멤버당 단일 assigned resource를 생성한다.
- assigned resource의 service appointment에 따라 Resource Capacity 객체를 업데이트한다(contractor에 스케줄 시 실제 작업 시간·할당 작업 항목 반영).
- assigned resource 업데이트에서 Service Resource 필드가 바뀌면, 기존 sharing을 제거하고 service resource·dispatcher의 territory에 따라 sharing을 생성한다.
- "Make assigned resources followers of service appointments that are Dispatched or In Progress" 설정이 켜져 있고 해당 service appointment Status Category 필드가 업데이트됐으면, 업데이트된 assigned resource를 service appointment 및 parent의 follower로 만든다.
- org에서 travel trigger가 켜져 있으면, service의 start/end date와 같은 날에 스케줄된 모든 service의 travel을 재계산한다.
- 실제 스케줄링 작업(Optimization, Automatic, Manual)에 따라 schedule mode를 업데이트한다.

**Before Delete:**
- 삭제되는 assigned resource의 service appointment에서 sharing을 제거한다.
- 삭제되는 assigned resource가 crew 타입 리소스이면, 해당 crew 멤버 appointment 리소스를 삭제한다.

**After Delete:**
- org에서 travel trigger가 켜져 있으면, 삭제된 assigned resource의 service의 start/end date와 같은 날에 스케줄된 모든 service의 travel을 재계산한다.
- 삭제된 assigned resource의 service appointment에 따라 Resource Capacity 객체를 업데이트한다(contractor에서 unschedule 시 실제 작업 시간·할당 작업 항목 반영).
- "Make assigned resources followers..." 설정이 켜져 있으면, 삭제된 assigned resource의 service appointment 및 parent를 unfollow한다.
- 삭제된 assigned resource의 Service Appointment의 scheduled start/end time을 null로 만들고 status를 None으로 바꾼다.
- 두 Follow Immediately 체인 중 하나가 unschedule(즉 assigned resource 삭제)되면, 체인에서 해당 service appointment를 unschedule한다. 자세한 내용은 Schedule an Appointment That Immediately Follows Another 참조.

### Event

> 이 객체의 모든 트리거는 Calendar Sync 기능의 일부다(Calendar Sync's Knowledge Article에 설명됨).

**Before Insert:**
- Calendar Sync's Knowledge Article에 설명된 설정에 따라 Resource Absences, Work Orders, Service Appointments, Assigned Resources를 생성한다.
- Calendar Sync 설정은 Field Service settings 페이지에 있다. settings 페이지에서 Sharing > Calendar Sync 선택.

**After Update:** (이 파일은 `FSL__TR004_Event_BeforeUpdate`로 불리지만 after update에만 발동한다.)
- 다음 필드 중 하나 이상이 바뀌면 Salesforce 레코드를 그에 맞게 업데이트한다: OwnerId, Subject, Location, StartDateTime, EndDateTime.
- FSL__Event_Type__c 필드가 바뀌고 새 값이 유효하면 Salesforce 레코드를 그에 맞게 생성한다.

**After Delete:** (이 파일은 `FSL__TR004_Event_BeforeDelete`로 불리지만 after delete에만 발동한다.)
- FSL__Event_Type__c 필드가 Service Appointment의 'Calendar Event type' 설정과 일치하고 service가 업데이트되지 않았으면, 그 service에 관련된 Assigned Resource를 삭제한다. 이 트리거는 Service Appointment를 unschedule한다.
- FSL__Event_Type__c 필드가 Resource Absence의 'Calendar Event type' 설정과 일치하면, 관련 absence를 삭제한다.

### Gantt Filter

**After Insert:**
- "Make this filter available for all users" 체크박스가 체크돼 있으면, FSL__Gantt_Filter__c와 AllInternalUsers 그룹에 대한 Share 레코드를 생성한다.

**After Update:**
- 업데이트에서 "Make this filter available for all users" 체크박스가 해제되면, share 레코드를 삭제한다.
- 업데이트에서 체크박스가 체크되면, After Insert에 설명된 대로 sharing 레코드를 추가한다.

### Gantt Palette

**After Insert:**
- AllInternalUsers 그룹에 sharing을 추가한다.

**After Update:**
- 그런 sharing이 아직 없으면 AllInternalUsers 그룹에 sharing을 추가한다.

### Map Polygon

**Before Insert:**
- polygon의 최소·최대 Latitude / Longitude를 지정된 필드에 설정한다.

**Before Update:**
- polygon의 최소·최대 Latitude / Longitude를 지정된 필드에 설정한다.

### Operating Hours

**Before Delete:**
- 삭제되는 레코드가 appointment booking 설정의 default operating hours가 아닌지 검증한다. Field Service settings 페이지에서 Global Actions > Appointment Booking 선택.

**After Update:**
- Appointment Bundling 기능이 켜져 있고 Use Bundle Apex Mode 커스텀 설정이 2이면, serviceTerritoryRefresh API http 요청이 트리거된다.

### Optimization Request

**Before Insert:**
- FSL__Status__c picklist 필드의 값으로 FSL__Text_Status__c 텍스트 필드를 설정한다. FSL__Text_Status__c는 External ID로 표시된 텍스트 필드로 쿼리 성능 향상에 쓰인다.

**Before Update:**
- FSL__Status__c picklist 필드가 In Progress에서 Queued로 바뀌는 것을 방지한다. 이 트리거는 status를 In Progress로 되돌린다.
- FSL__Status__c 값이 Aborted인 레코드가 Completed로 바뀌지 않도록 검증한다. 바뀌면 변경을 막고 에러를 던진다.
- status가 Aborted로 바뀌면 다음 조건을 확인한다:
  - 변경이 optimization user에 의한 것이 아니어야 한다.
  - Optimization Request가 auto-kill 기능에 의해 abort된 것이 아니어야 한다. 즉, 커스텀 설정에 정의된 시간보다 특정 상태에 오래 머문 요청을 죽이는 기능.
  - user가 프로필이나 permission set 중 하나에 Abort_Optimization_Request 커스텀 권한을 가져야 한다.
  - 앞의 모든 기준이 충족되면 요청이 abort된다.

### Resource Absence

**Before Insert:**
- geolocation 값(latitude·longitude)의 scale을 소수점 이하 6자리로 바꾼다.
- resource absence DateTime 필드에서 초·밀리초를 제거한다.
- geolocation 값을 기반으로 InternalSLRGeolocation 필드(latitude·longitude)를 채운다. 이 필드는 street-level routing과 predictive route 계산에 쓰인다.

**After Insert:**
- 삽입된 resource absence가 nonavailability 타입이면:
  - multi-day service appointment가 resource absence의 영향을 받고 service appointment가 하나뿐이면, 그 duration을 업데이트한다.
  - org에서 Fix Overlaps가 켜져 있고 Travel Trigger가 꺼져 있으면 Fix Overlaps를 호출한다.
  - org에서 Travel Trigger가 켜져 있고 1단계에서 multi-day appointment가 업데이트되지 않았으면, absence의 start/end date와 같은 날에 스케줄된 모든 service의 travel을 재계산한다.
  - calendar sync 기능이 켜져 있으면 resource absence에 대한 calendar event를 생성한다.
- 그 외에는 아무 것도 하지 않는다.

**Before Update:** (내용은 Before Insert와 동일)
- geolocation 값(latitude·longitude)의 scale을 소수점 이하 6자리로 바꾼다.
- resource absence의 DateTime 필드에서 초·밀리초를 제거한다.
- geolocation 값을 기반으로 InternalSLRGeolocation 필드를 채운다. geolocation 값의 변경 여부를 확인하지 않고 Before Insert처럼 업데이트한다.

**After Update:**
- 업데이트된 resource absence가 non availability 타입이면:
  - multi-day service appointment가 resource absence 변경의 영향을 받고 service appointment가 하나뿐이면, 그 duration을 업데이트한다.
  - org에서 Fix Overlaps가 켜져 있고 Travel Trigger가 꺼져 있으면 Fix Overlaps를 호출한다.
  - org에서 Travel Trigger가 켜져 있고 1단계에서 multi-day appointment가 업데이트되지 않았으면, absence의 start/end date와 같은 날에 스케줄된 모든 service의 travel을 재계산한다.
  - calendar sync 기능이 켜져 있으면 resource absence에 대한 calendar event를 생성한다.
- 그 외에는 아무 것도 하지 않는다.

**Before Delete:**
- 일치하는 calendar event가 있으면 삭제한다. 자세한 내용은 Calendar Sync's Knowledge Article 참조.

**After Delete:**
- 삭제된 resource absence가 nonavailability 타입이면:
  - multi-day service appointment가 resource absence 삭제의 영향을 받고 service appointment가 하나뿐이면, 그 duration을 업데이트한다.
  - org에서 Fix Overlaps가 켜져 있고 Travel Trigger가 꺼져 있으면 Fix Overlaps를 호출한다.
  - org에서 Travel Trigger가 켜져 있고 1단계에서 multi-day appointment가 업데이트되지 않았으면, absence의 start/end date와 같은 날에 스케줄된 모든 service의 travel을 재계산한다.

### Scheduling Policy

**Before Insert:**
- 이 기능이 org에서 켜져 있을 때만 Travel Mode 체크박스가 체크되도록 검증한다.
- org에서 Enhanced Optimization이 켜져 있을 때만 In-Day Optimization이 체크되도록 검증한다.

**After Insert:**
- Earliest Start Time과 Due Date basic time rule이 없으면 생성한다.
- 이 work rule들을 삽입된 policy에 할당하기 위해 Scheduling Policy Work Rule junction 객체를 생성한다.

**Before Update:**
- 이 기능이 org에서 켜져 있을 때만 Travel Mode 체크박스가 체크되도록 검증한다.
- org에서 Enhanced Optimization이 켜져 있을 때만 In-Day Optimization이 체크되도록 검증한다.

**Before Delete:**
- 삭제되는 레코드가 appointment booking action의 default scheduling policy가 아닌지 검증한다.
- 이 기능이 org에서 켜져 있을 때만 Travel Mode 체크박스가 체크되도록 검증한다.
- org에서 Enhanced Optimization이 켜져 있을 때만 In-Day Optimization이 체크되도록 검증한다.
- Earliest Start Time과 Due Date'Scheduling Policy Work Rules junction 객체를 삭제한다. `[sic — Date'Scheduling 사이 누락된 공백]`

### Scheduling Policy Work Rule

**Before Insert:**
- 중복이 없는지 검증한다. 즉, 같은 policy에서 특정 work rule을 참조하는 Scheduling Policy Work Rule 레코드가 하나뿐인지 검증한다.
- 같은 policy에 enhanced match rule이 둘을 초과하지 않는지 검증한다. 둘이면 서로 다른 Linking Object를 참조하도록 한다.
- Count Type이 CustomValue인 Count Rule이 넷을 초과하지 않는지 검증한다.
- 모든 Count Rule 필드가 유효한지 검증한다.

**Before Update:** Before Insert와 동일.

**Before Delete:**
- Due Date 및 Earliest Start Time basic rule에 관련된 Scheduling Policy Work Rule 레코드의 삭제를 방지한다.
- Scheduling Policy를 삭제하면 이 검증을 건너뛰고 관련된 모든 Scheduling Policy Work Rule을 삭제한다.

### Service Appointment

**Before Insert:**
- Service Appointment의 DateTime 필드에서 초를 제거한다.
- 생성된 ServiceAppointment 레코드에 geolocation(latitude·longitude)이 있으면, 소수점 이하 자릿수를 최대 6자리로 제한한다.
- 생성된 ServiceAppointment 레코드에 geolocation이 있으면, FSL__InternalSLRGeolocation__Latitude__s, FSL__InternalSLRGeolocation__Longitude__s 필드를 채운다(street-level routing 경로 계산에 사용).
- "Derive the Service Appointment due date from its Work Type" 설정이 켜져 있으면, work order parent 레코드에서 Duration 필드를 derive하고, parent의 work type 필드에서 오는 Earliest Start Permitted + Due Date offset 값으로 Due Date 필드를 채운다.
- "Set your default service appointment duration to one hour" 설정이 켜져 있으면, 다음 중 하나가 발생할 때 service appointment duration을 1시간으로 설정한다:
  - duration 필드가 null이다.
  - duration이 1분보다 짧다.

**After Insert:**
- Enable User Territories sharing 설정이 켜져 있으면, 생성된 service appointment를 service territory public group과 공유한다(해당 territory의 dispatcher에 공유 제공).
- Enable User Territories sharing 설정이 켜져 있고 해당 service appointment parent sharing 설정(Share parent Work Order when Service Appointment is shared)이 켜져 있으면, 생성된 service appointment의 parent를 service territory public group과 공유한다.
- "Derive the Service Appointment due date from its Work Type" 설정이 켜져 있으면, Before Insert와 동일하게 Duration을 derive하고 Due Date를 채운다. 이 동작은 의도적으로 Before Insert와 After Insert 양쪽 트리거에 들어 있다.
- Auto Schedule 필드 값이 true이면 생성된 service appointment를 배치로 스케줄한다. 생성 시 auto-scheduling에는 Field Service settings 페이지에 설정된 default policy가 쓰인다.
- 배치가 호출된 후 Auto Schedule 플래그는 자동으로 false로 설정된다.
- "Use polygons to assign service territories" 설정이 켜져 있으면, service appointment의 주소와 Map Polygon Service Territory 필드의 일치를 기반으로 생성된 service appointment의 service territory 필드를 auto populate한다.
- service appointment 주소와 org map polygon 간 일치가 없으면 service territory 필드는 그대로 유지된다.
- Appointment Bundling 기능이 켜져 있고; Use Bundle Apex Mode 커스텀 설정이 2이며; 삽입된 service appointment가 bundle 또는 bundle member이면; afterServiceAppointmentUpdate API http 요청이 트리거된다.
- Appointment Bundling 기능이 켜져 있고; automatic bundling이 켜져 있으며; 삽입된 service appointment가 bundle 또는 bundle member가 아니고; service appointment의 수정 필드가 automatic mode의 제한 내에 있으며; service appointment의 service territory가 정의된 ApptBundlePolicySvcTerr에 있고; Recordeset Filter Criteria가 일치하며 `[sic — Recordeset]`; service appointment의 status가 bundle status에 존재하고; service appointment가 pinned되지 않았으며; service appointment의 service territory 타임존을 고려할 때 due date가 과거가 아니면; automatic API 요청이 트리거된다.

**Before Update:**
- service appointment의 DateTime 필드에서 초를 제거한다.
- 생성된 ServiceAppointment 레코드에 geolocation이 있으면, 소수점 이하 자릿수를 최대 6자리로 제한한다.
- Field Service settings 페이지에서 Service Appointment Status Transitions가 켜져 있고 service appointment status 필드에 변경이 있었으면, status transition의 적법성을 검증한다.
- 업데이트된 service appointment의 Status Category가 Canceled 또는 New로 바뀌면, Scheduled Start Time과 Scheduled End Time 필드 값을 제거한다.
- Is Pinned 필드 값이 true이면 Scheduled Start Time, Scheduled End Time, Latitude, Longitude 필드 값 업데이트를 방지한다.
- service appointment가 multi-day service appointment이면, service duration 재계산이 필요한지 확인하고 필요하면 재계산한다.
- settings 페이지에서 Drip-Feed 기능이 켜져 있으면, 해당 일의 다음 service appointment를 dispatch한다. 현재 service appointment status category가 Completed, Canceled or,Couldn't Complete `[sic — "or,Couldn't" 쉼표·공백]`로 바뀐 경우에 수행된다. 자세한 내용은 Salesforce Help의 Drip Feed Service Appointments 참조.
- "Mention assigned user when the Service Appointment is dispatched" 설정이 켜져 있으면, service cancellation 시 user를 mention한다.
- 업데이트된 service appointment duration이 1분보다 긴지 검증한다. duration이 null 또는 1분이면 duration을 1시간으로 바꾼다.
- 업데이트된 service 레코드에 geolocation이 있고 업데이트 내에서 바뀌었으면, FSL__InternalSLRGeolocation__Latitude__s, FSL__InternalSLRGeolocation__Longitude__s 필드를 채운다(street-level routing 경로 계산에 사용).
- FSL__Prevent_Geocoding_For_Chatter_Actions__c 필드가 체크돼 있으면, 주소 변경 시 발생하는 Data.com의 geolocation cleanup을 비활성화하고 그 필드 값을 false로 되돌린다.
- service appointment 업데이트 과정에서 Auto Schedule 필드가 true로 설정되면, After Update 트리거 작업에서 호출되는 service appointment 집합을 준비하고 필드를 false로 설정한다.
- "Use polygons to assign service territories" 설정이 켜져 있고 geolocation이 관련 Map Polygon 레코드 내에 들어가면, 지리 영역을 기반으로 업데이트된 service appointment territory를 분류한다. 자세한 내용은 Salesforce Help의 Create and Manage Map Polygons / Enable Map Polygons 참조.

**After Update:**
- status category가 Dispatched로 바뀌면, 업데이트된 service appointment를 assigned resource와 공유한다. service territory가 바뀌면 service territory public group과 공유한다.
- 관련 설정이 켜져 있으면 assigned resource user를 mention한다.
- 이미 async 컨텍스트가 아니면 이 작업을 비동기 메서드로 수행한다.
- service appointment status 변경에 따라 Salesforce calendar event를 생성·삭제한다.
  - SA Status category가 New/Scheduled에서 Dispatched로 바뀌면 calendar event를 생성한다.
  - service appointment status category가 Dispatched에서 Scheduled/New로 바뀌면 calendar event를 삭제한다.
  - service appointment assigned resource가 바뀌고 service appointment가 dispatched로 유지되면, 관련 Salesforce calendar event를 그에 맞게 업데이트한다.
- service appointment 변경에 따라 Resource Capacity 객체를 업데이트한다(contractor에 스케줄 시 실제 작업 시간·할당 작업 항목 반영).
- Auto Schedule 필드 값이 true이면 업데이트된 service appointment를 배치로 스케줄한다(update 시 auto-scheduling에는 default policy 사용).
- 배치가 호출된 후 Auto Schedule 플래그는 자동으로 false로 설정된다.
- "Make assigned resources followers of service appointments that are Dispatched or In Progress" 설정이 켜져 있고 Status Category 필드가 업데이트됐으면, assigned resource를 업데이트된 service appointment의 follower로 만든다.
- 업데이트된 service appointment가 Service Crew에 할당돼 있으면, 실제 Service Crew 스케줄링을 반영하도록 새로 업데이트된 service appointment에 따라 service의 assigned resource를 생성/업데이트/삭제한다. 자세한 내용은 Salesforce Help의 Considerations for Scheduling Service Crews 참조.
- org에서 travel trigger가 켜져 있으면, service의 start/end date와 같은 날에 스케줄된 모든 service의 travel을 재계산한다.
- 업데이트된 service appointment의 Scheduled Start/End Time이 null이지만 관련된 assigned resource가 있으면, 그 assigned resource를 삭제한다.
- 실제 스케줄링 작업(Optimization, Automatic, Manual)에 따라 schedule mode를 업데이트한다.
- 실제 service appointment 업데이트(Canceled, Shortened, Late-end, Emergency)에 따라 scheduling recipe를 평가한다.
- 자세한 내용은 Salesforce Help의 Create Scheduling Recipes for Common Events 참조.
- Appointment Bundling 기능이 켜져 있고; Use Bundle Apex Mode 커스텀 설정이 2이며; 업데이트된 service appointment가 bundle 또는 bundle member이면; bundle service appointment 로직을 실행한다.
- Appointment Bundling 기능이 켜져 있고; Use Bundle Apex Mode 커스텀 설정이 2이며; 업데이트된 service appointment가 bundle 또는 bundle member이면; afterServiceAppointmentUpdate API http 요청이 트리거된다.
- Appointment Bundling 기능이 켜져 있고; Use Bundle Apex Mode 커스텀 설정이 2이며; 업데이트된 service appointment가 bundle member이면; RelatedBundleId 필드가 바뀌지 않았을 때 SchedStartTime·SchedEndTime 필드를 업데이트하지 않는다. RelatedBundleId가 업데이트된 경우에만 SchedStartTime·SchedEndTime 필드가 바뀐다.
- Appointment Bundling 기능이 켜져 있고; automatic bundling이 켜져 있으며; 업데이트된 service appointment가 bundle 또는 bundle member가 아니고; service appointment의 수정 필드가 automatic mode의 제한 내에 있으며; service appointment의 service territory가 정의된 ApptBundlePolicySvcTerr에 있고; Recordeset Filter Criteria가 일치하며 `[sic — Recordeset]`; service appointment의 status가 bundle status에 존재하고; service appointment가 pinned되지 않았으며; due date가 과거가 아니면; automatic API 요청이 트리거된다.

**Before Delete:**
- 일치하는 calendar event가 있으면 삭제한다. 자세한 내용은 Calendar Sync's Knowledge Article 참조.
- 삭제된 service appointment에서 assigned resource 레코드를 삭제한다.
- parent 레코드(Work Order)의 sharing을 territory public group에서 제거한다.

### Service Objective

**Before Insert:**
- service objective에 record type이 있는지 검증한다.
- service objective가 custom logic objective이면, Custom Logic Data를 검증·디코드한다(채워져 있어야 함).

**Before Update:** Before Insert와 동일.

### Service Resource

**Before Insert:**
- Efficiency 필드가 비어 있지 않으면, 값이 유효 범위(0.1–10 사이)에 있는지 확인한다. 아니면 삽입을 막고 Efficiency 필드 옆에 에러를 표시한다.
- ServiceCrewId 필드가 비어 있으면, 같은 service crew를 가리키는 다른 Service Resource 레코드가 있는지 확인한다. 있으면 에러를 던지고 삽입을 막는다.

**After Insert:**
- org에서 location-based sharing이 켜져 있으면, RelatedRecordId 필드에 지정된 user에 대한 ServiceResourceShare 객체를 생성한다. location-based sharing이 꺼져 있으면 아무 것도 하지 않는다. 특정 레코드(예: Crew 타입 Service Resource)에서 RelatedRecordId 필드가 비어 있으면, 그 레코드에 대한 share 객체를 생성하지 않는다.

**Before Update:**
- IsCapacityBased 체크박스가 false에서 true로 바뀌면, 그 리소스에 연결된(secondary service territory member 제외) service territory member가 하나뿐인지 검증한다. 아니면 에러를 던지고 업데이트를 막는다.
- Efficiency 필드가 비어 있지 않으면, 값이 유효 범위(0.1–10 사이)에 있는지 확인한다. 아니면 업데이트를 막고 Efficiency 필드 옆에 에러를 표시한다.
- IsCapacityBased 체크박스가 체크돼 있으면, 이 service resource에 Service Crew Member 레코드가 없는지 검증한다. 아니면 에러를 던지고 업데이트를 막는다.
- ServiceCrewId 필드가 바뀌고 새 값이 비어 있지 않으면, 그 Service Crew를 가리키는 기존 Service Resource 레코드가 없는지 검증한다. 아니면 에러를 던지고 업데이트를 막는다.

**After Update** `[sic — 콜론 없음]`
- 업데이트에서 RelatedRecordId가 바뀌고 org에서 location-based sharing이 켜져 있으면, user가 생성한 것을 포함해 Service Resource의 모든 수동 sharing 레코드를 삭제하고 새 관련 user에 대한 ServiceResourceShare 객체를 생성한다. 수동 sharing 객체 중 하나라도 삭제에 실패하면 어느 것도 삭제하지 않는다.

### Service Resource Capacity

> 이 트리거는 TR012_CapacityAfterUpdate로 명명됐지만 before insert와 before update에만 발동한다.

**Before Insert:**
- monthly capacity가 그 달의 첫 날에 정의됐는지 검증한다.
- 같은 duration type의 capacity가 서로 겹치지 않는지(리소스와 날짜를 공유하지 않는지) 검증한다.
- Time Period와 End Date 필드가 유효한지 검증한다.
- capacity 내에 스케줄된 service의 duration에 따라 MinutesUsed__c 필드를 업데이트한다.
- CapacityInWorkItems 필드가 비어 있지 않으면, capacity 내에 스케줄된 service 수로 Work_Items_Allocated__c 필드를 업데이트한다.
- HoursInUse__c 필드는 MinutesUsed__c 기반의 formula 필드다. 이 필드는 그에 맞게 업데이트된다.
- Last Updated Epoch 필드를 1970년 1월 1일 00:00:00 GMT 이후 경과한 밀리초 수로 업데이트한다.

**Before Update:**
- monthly capacity가 그 달의 첫 날에 정의됐는지 검증한다.
- 같은 duration type의 capacity가 겹치지 않는지(리소스와 날짜를 공유하지 않는지) 검증한다.
- the the Time Period와 End Date 필드가 유효한지 검증한다. `[sic — "the the" 중복]`
- 다음 필드 중 하나 이상이 바뀌었는지 검증한다: TimePeriod, StartDate, CapacityInHours, CapacityInWorkItems, ServiceResourceId.
- 이 필드 중 하나라도 바뀌면, capacity 내에 스케줄된 service의 duration에 따라 MinutesUsed__c 필드를 업데이트한다.
- CapacityInWorkItems 필드가 비어 있지 않으면, capacity 내에 스케줄된 service 수로 Work_Items_Allocated__c 필드를 업데이트한다.
- HoursInUse__c 필드는 MinutesUsed__c 기반의 formula 필드다. 이 필드는 그에 맞게 업데이트된다.
- Last Updated Epoch 필드를 1970년 1월 1일 00:00:00 GMT 이후 경과한 밀리초 수로 업데이트한다.

### Service Resource Skill

**Before Insert:**
- Effective Start Date와 Effective End Date 필드에서 초·밀리초를 제거한다.

**Before Update:** Before Insert와 동일.

### Service Territory

**Before Insert:**
- Enable Territory Name Duplicates 커스텀 설정이 꺼져 있으면(default 값은 꺼짐), 삽입되는 territory의 이름에 중복이 없도록 한다.
- territory에 geolocation이 있으면, 내부 street-level routing geolocation 값을 채운다.

**After Insert:**
- Enable User Territories sharing 설정이 켜져 있으면, territory 이름의 새 public group을 생성하고(그런 그룹이 없으면) 그 그룹에 대한 sharing 레코드를 생성한다.
- territory에 parent territory가 있으면, territory의 public group을 parent territory의 public group에 group member로 추가한다.
- Enable Service Auto Classification 커스텀 설정이 켜져 있으면(default는 켜짐), 모든 territory의 parent territory·top-level territory 값에 따라 FSL__TerritoryLevel__c 필드를 설정한다. 이 필드는 계층에서 territory의 레벨을 나타내며 polygon 알고리즘에 쓰인다.
- Appointment Bundling 기능이 켜져 있고; Use Bundle Apex Mode 커스텀 설정이 2이면; serviceTerritoryRefresh API http 요청이 트리거된다.

**Before Update:**
- Enable Territory Name Duplicates 커스텀 설정이 꺼져 있고(default 꺼짐) Name 필드가 바뀌었으면, 업데이트되는 territory의 이름에 중복이 없도록 한다.
- territory에 geolocation이 있으면, 내부 street-level routing geolocation 값을 채운다.

**After Update:**
- name 또는 owner 필드가 바뀌면, territory의 public group을 그에 맞게 업데이트한다.
- Parent Territory 필드가 바뀌면, Parent Territory의 public group을 업데이트하고 새 계층에 따라 모든 레코드의 FSL__TerritoryLevel__c 필드 값을 재계산한다.
- Appointment Bundling 기능이 켜져 있고; Use Bundle Apex Mode 커스텀 설정이 2이며; Operating Hours 속성이 업데이트됐으면; serviceTerritoryRefresh API http 요청이 트리거된다.

**Before Delete:**
- Service Territory의 public group을 삭제한다.
- 새 계층에 따라 자식 territory의 FSL__TerritoryLevel__c 필드를 업데이트한다.
- Appointment Bundling 기능이 켜져 있고; Use Bundle Apex Mode 커스텀 설정이 2이면; serviceTerritoryRefresh API http 요청이 트리거된다.

### Service Territory Member

**Before Insert:**
- service territory member DateTime 필드에서 초를 제거한다.
- 날짜 충돌을 확인한다. 같은 날짜에 primary 또는 relocation service territory member가 있으면 트리거가 실패한다.
- 같은 날짜에 secondary service territory member가 있고 생성되는 service territory member가 같은 service territory에 있으면 트리거가 실패한다.
- 생성된 service territory member 레코드에 geolocation이 있으면, FSL__InternalSLRGeolocation__Latitude__s, FSL__InternalSLRGeolocation__Longitude__s 필드를 채운다(street-level routing 경로 계산에 사용).
- contractor에 대한 Relocation 타입 service territory member 생성을 방지한다.
- contractor에 대해(Secondary service territory member 제외) 둘 이상의 service territory member 생성을 방지한다.

**Before Update:**
- 날짜 충돌을 확인한다. 같은 날짜에 primary 또는 relocation service territory member가 있으면 트리거가 실패한다.
- 같은 날짜에 secondary service territory member가 있고 생성되는 service territory member가 같은 service territory에 있으면 트리거가 실패한다.
- 업데이트된 service territory member 레코드에 geolocation이 있으면, FSL__InternalSLRGeolocation__Latitude__s, FSL__InternalSLRGeolocation__Longitude__s 필드를 채운다.
- contractor에 대한 Relocation 또는 Primary 타입 service territory member 다중 생성을 방지한다.
- contractor에 대해(Secondary service territory member 제외) 둘 이상의 service territory member 생성을 방지한다.

### Skill Requirement

> 모든 트리거가 비어 있다(empty).

### Time Dependency

**After Insert:**
- service appointment 간 중복된 dependency 생성을 방지한다.
- 이미 생성된 time dependency 체인에 Immediately Follow dependency 타입 추가를 방지한다.
- 생성된 Time Dependency에 따라 기존 체인에 service appointment를 추가한다. 필요하면 생성된 Time Dependency에 따라 두 체인을 merge한다.

**Before Update:**
- 기존 Time Dependency가 같은 두 service appointment를 가지면 Time Dependency 업데이트를 방지한다.
- 이미 생성된 time dependency 체인에 Immediately Follow dependency 타입 추가를 방지한다.

**After Delete:**
- 삭제된 Time Dependency에 따라 두 dependency를 split한다. 예를 들어 체인 A가 SerA SerB SerC SerD SerE를 포함하고 삭제된 Time Dependency가 SerC SerD이면, 체인을 SerA SerB SerC와 SerD SerE 둘로 split한다.

### Time Slot

**Before Insert:**
- DateTime 필드에서 초를 제거한다.

**Before Update:**
- DateTime 필드에서 초를 제거한다.

### User Territory

**Before Insert:**
- Enable User Territories sharing 설정이 켜져 있으면, 모든 user territory 내에서 uniqueness를 확인한다. 즉, 같은 user가 같은 territory에 관련되지 않도록 한다.

**After Insert:**
- Enable User Territories sharing 설정이 켜져 있으면, 생성된 User Territory에 따라 user를 해당 public group에 추가한다. User Territory.Service Territory 이름을 public group 이름과 같게 만든다.

**BeforeUpdate:** `[sic — "Before Update" 사이 공백 없음]`
- Enable User Territories sharing 설정이 켜져 있으면, 모든 user territory 내에서 uniqueness를 확인한다. 즉, 같은 user가 같은 territory에 관련되지 않도록 한다.

**After Update:**
- Enable User Territories sharing 설정이 켜져 있으면, 업데이트된 user territory에 따라 user를 해당 public group에 추가·제거한다. 예를 들어 user territory가 User: David, Service Territory: LA에서 User: David, Service Territory: Washington으로 업데이트되면, David를 LA public group에서 제거하고 Washington public group에 추가한다.

**After Delete:**
- Enable User Territories sharing 설정이 켜져 있으면, 삭제된 user territory에 따라 user를 해당 public group에서 제거한다.

### Work Order

**Before Insert:**
- AccountId 필드가 비어 있지 않고 VisitingHoursId 필드가 비어 있으면, 관련 account의 operating hours ID로 VisitingHoursId를 채운다.

**Before Update:**
- AccountId 또는 VisitingHoursId 필드가 바뀌고, AccountId 필드가 비어 있지 않으며, VisitingHoursId 필드가 비어 있으면, 관련 account의 operating hours ID로 VisitingHoursId를 채운다.
- FSL__Prevent_Geocoding_For_Chatter_Actions__c 필드가 체크돼 있으면, 주소 변경 시 발생하는 Data.com의 geolocation cleanup을 비활성화하고 그 필드 값을 false로 되돌린다.

### Work Order Line Item

> 모든 트리거가 비어 있다(empty).

### Work Rule

**Before Update:**
- work rule이 Availability Rule이면, fixed gap 체크박스가 비활성화돼 있으면 minimum gap 설정을 방지한다.
- work rule이 Availability Rule이면, Break And Travel 트리거가 비활성화돼 있으면 break time 설정을 방지한다.
- work rule이 Match Boolean Rule이면, resource property 필드가 채워져 있지 않으면 work rule 업데이트를 방지한다.
- work rule이 Time Rule이면, Scheduled Start Time Equal To/Before Arrival Window Start/End인 time rule 업데이트를 방지한다.
- work rule이 Enhanced Match Rule 또는 Count Rule이면, 유효하지 않은 필드 값으로 rule 업데이트를 방지한다.
- basic time work rule이 org에 없거나 변경되면, 유효한 basic time rule(Early Start Permitted & Due Date work rule)을 생성한다.

**Before Delete:**
- basic time work rule(Early Start Permitted & Due Date)의 삭제를 방지한다.

---

# PART 2 — Field Service Code Examples

> Use these code examples to get started working programmatically with Field Service features.

Field Service 기능을 프로그래밍으로 다루기 위한 4개 코드 예제다.

---

## 코드 예제 1 — Create a Service Report with Apex

work order, work order line item, service appointment에 대한 Create Service Report 액션은 Apex 코드로도 호출할 수 있다. 아래 예제는 `createServiceReport` 액션 REST API 리소스로 Apex callout을 만들어 시그니처 2개를 가진 service report를 생성한다.

각 service report는 parent 레코드의 데이터와, 작업을 sign off해야 하는 고객·기술자 등의 시그니처를 담는다. API 호출에서 하나 이상의 시그니처를 정의할 수 있다. 시그니처의 수와 타입은 service report 템플릿의 시그니처 설정과 일치해야 한다.

> **Note:**
> - 이 코드 예제는 API version 41.0 이상에 적용된다. API version 40.0으로 생성된 service report는 시그니처를 하나만 가질 수 있다.
> - REST callout을 위해 remote site setting이 활성화돼 있다고 가정한다. 자세한 내용은 Adding Remote Site Settings 참조.
> - 코드 예제의 mock 레코드 ID는 0WOxx000000001E, mock service report 템플릿 ID는 0SLR00000004DBFOA2.

**API Endpoint (v41.0):** `/services/data/v41.0/actions/standard/createServiceReport`

```apex
String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
String url = salesforceHost + '/services/data/v41.0/actions/standard/createServiceReport';
// Create HTTP request
HttpRequest request = new HttpRequest();
request.setEndpoint(url);
request.setMethod('POST');
request.setHeader('Content-Type', 'application/json');
request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
// Set the body as a JSON object
request.setBody('{"inputs" : [ {"entityId" : "0WOxx000000001E","signatures" :
[{"data":"Base64 code for the captured signature
image","contentType":"image/png","name":"Customer
Signature","signatureType":"Default","place":"San Francisco","signedBy":"John
Doe","signedDate":"2019-06-05 12:00:00"}],"templateId" : "0SLR00000004DBFOA2"} ]}');
Http http = new Http();
HttpResponse response = http.send(request);
// Parse the JSON response
if (response.getStatusCode() != 201) {
    System.debug('The status code returned was not expected: ' +
                 response.getStatusCode() + ' ' + response.getStatus());
} else {
    System.debug(response.getBody());
}
```

다음은 시그니처 2개로 payload를 생성하는 예제다.

```json
{
    "inputs":[
       {
          "entityId":"0WOxx000000001E",
          "signatures":[
             {
                "data":"Base64 code for the captured signature image",
                "contentType":"image/png",
                "name":"Customer Signature",
                "signatureType":"Customer",
                "place":"San Francisco",
                "signedBy":"John Doe",
                "signedDate":"Thu Jul 13 22:34:43 GMT 2017"
             },
             {
                "data":"Base64 code for the captured signature image",
                "contentType":"image/png",
                "name":"Technician Signature",
                "signatureType":"Technician"
             }
          ],
          "templateId":"0SLR00000004DBFOA2"
       }
    ]
}
```

**Field Descriptions:**
- **entityId:** service report를 생성할 work order, work order line item, service report의 ID.
- **signatures:** 디지털 시그니처에 대한 JSON 정의 목록.
  - **data:** (Required) 이미지의 base64 코드.
  - **contentType:** (Required) 시그니처의 파일 타입.
  - **signatureType:** (Required) 서명하는 사람의 역할(예: Customer). Signature Type picklist 값은 Salesforce admin이 사전에 정의한다. 각 시그니처 블록은 서로 다른 signature type을 써야 하며, 호출에서 정의한 signature type은 service report 템플릿의 signature type과 일치해야 한다.
  - **name:** 시그니처 블록 제목. 생성된 service report에 표시된다.
  - **place:** 서명 장소. 생성된 service report에 표시된다.
  - **signedBy:** 서명하는 사람의 이름. 생성된 service report에 표시된다.
  - **signedDate:** 서명 날짜. 생성된 service report에 표시된다.
- **templateId:** 리포트에 쓰이는 service report 템플릿의 ID. ID를 찾으려면 ServiceReportLayout 객체에 SOQL 쿼리를 실행한다.

**Limitations:**
- guest user이고 Future annotation을 쓰는 경우, ContentDocument 객체를 생성할 수 없어 Service Document를 생성할 수 없다.

**SEE ALSO:** Salesforce Actions Developer Guide: Create Service Report Actions

---

## 코드 예제 2 — Generate Work Orders on Maintenance Plans with Apex

maintenance plan에 대한 Generate Work Orders 액션은 Apex 코드로도 호출할 수 있다. 아래 샘플은 `generateWorkOrder` 액션 REST API 리소스로 Apex callout을 만들어 work order 레코드를 생성한다.

이 코드 샘플은 여러 방식으로 쓸 수 있다:
- Aura 컴포넌트의 Apex 컨트롤러 코드에 추가하여 커스텀 UI·앱 기능에 연결
- Apex trigger에서 work order 생성을 반자동화(예: maintenance plan이 생성·업데이트될 때마다)
- 외부 통합 서비스에서 호출될 때 work order를 생성하는 Apex REST 서비스에서 사용

> **Note:**
> - REST callout을 위해 remote site setting이 활성화돼 있다고 가정한다. 자세한 내용은 Adding Remote Site Settings 참조.
> - 코드 샘플의 mock maintenance plan ID는 1MPR000000000Bu.
> - 이 코드 샘플은 API version 45.0을 참조하지만, 40.0 이상의 어떤 버전과도 함께 쓸 수 있다.

**API Endpoint (v45.0):** `/services/data/v45.0/actions/standard/generateWorkOrders`

```apex
String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
String url = salesforceHost + '/services/data/v45.0/actions/standard/generateWorkOrders';
// Create HTTP request
HttpRequest request = new HttpRequest();
request.setEndpoint(url);
request.setMethod('POST');
request.setHeader('Content-Type', 'application/json;charset=UTF-8');
request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
// Set the body as a JSON object
request.setBody('{"inputs" : [{"recordId" : "1MPR000000000Bu"}]}');
Http http = new Http();
HttpResponse response = http.send(request);
// Parse the JSON response
if (response.getStatusCode() != 201) {
    System.debug('The status code returned was not expected: ' +
    response.getStatusCode() + ' ' + response.getStatus());
} else {
    System.debug(response.getBody());
}
```

**SEE ALSO:** Salesforce Actions Developer Guide: Generate Work Orders Actions

---

## 코드 예제 3 — Dispatcher Console Custom Actions

dispatcher console의 커스텀 액션에 연결할 Apex 클래스 또는 Visualforce 페이지를 구성하는 방법이다.

커스텀 액션은 Apex 클래스를 호출하거나 Visualforce 페이지를 열 수 있으며, dispatcher console의 여러 영역의 레코드에서 실행될 수 있다. 커스텀 액션 생성 방법은 Create Custom Actions for the Dispatcher Console 참조.

> **Note:** dispatcher console에서 접근하려면 quick action 인터페이스를 구현하는 모든 Apex 클래스를 Global로 선언해야 한다.

### Creating Apex Classes

dispatcher console 커스텀 액션에 연결할 Apex 클래스를 만들 때, 다음 세 인터페이스 중 하나를 구현한다.

**Interface 1 — `CustomGanttServiceResourceAction`:**
service resource에 대한 액션. 파라미터는 service resource 레코드 ID, Gantt에 반영된 service territory member 레코드 ID, 현재 Gantt 뷰의 start·end date다. 추가 파라미터는 없다.
다음 포맷을 사용한다:
```apex
String action(Id resourceId, Id stmId, Datetime strGanttStartDate, Datetime strGanttEndDate, Map<String, Object> additionalParameters)
```

**Interface 2 — `CustomGanttServiceAppointmentAction`:**
service appointment에 대한 액션. 파라미터는 service appointment 레코드 ID들(bulk action에 사용)과 현재 Gantt 뷰의 start·end date다. 추가 파라미터는 없다. `Map<String, Object> additionalParameters` 입력 파라미터는 향후 사용을 위해 예약돼 있으나 코드 실행을 위해 반드시 포함해야 한다.
다음 포맷을 사용한다:
```apex
String action(List<Id> serviceAppointmentsIds, Datetime strGanttStartDate, Datetime strGanttEndDate, Map<String, Object> additionalParameters)
```
이 액션이 구현되면 여러 service appointment가 반환될 수 있다. 메서드에서 몇 개의 ID가 반환됐는지 확인하는 if문을 만들 것을 권장한다. 먼저 최소 하나의 ID가 반환됐는지 검증한다: `serviceAppointmentsIds.size()>1`. 그 후 반환된 appointment ID가 0, 1, 또는 그 이상인지에 따라 다른 액션을 취할 수 있다.

**Interface 3 — `CustomGanttResourceAbsenceAction`:**
resource absence에 대한 액션. 파라미터는 resource absence 레코드 ID, absence 타입('na' 또는 'break'), 현재 Gantt 뷰의 start·end date다. 추가 파라미터는 없다. `Map<String, Object> additionalParameters` 입력 파라미터는 향후 사용을 위해 예약돼 있으나 코드 실행을 위해 반드시 포함해야 한다.
다음 포맷을 사용한다:
```apex
String action(Id absenceId, String absenceType, Datetime strGanttStartDate, Datetime strGanttEndDate, Map<String, Object> additionalParameters)
```

이 함수들은 global이어야 하며 string 반환이 요구된다. string이 비어 있지 않으면, user가 관련 액션을 클릭할 때 표시되는 Gantt notification에 쓰인다.

> **Note:** 모든 date·time 계산에 Datetime 클래스를 사용한다.

### Code Example: Service Resource Custom Action

이 액션은 선택된 service resource에 대해 Gantt에 보이는 날짜에 걸친 Non Availability 타입 resource absence를 생성한다.

```apex
global class BlockResourceVisibleTime implements FSL.CustomGanttServiceResourceAction {

    global String action(Id resourceId, Id stmId, Datetime ganttStartDate, Datetime
ganttEndDate, Map<String, Object> additionalParameters) {

            ResourceAbsence na = new ResourceAbsence();

           // get Resource Absence record type - NA
           RecordType recordTypeNA = [
               SELECT
                   Id, SobjectType, Name
               FROM
                   RecordType
               WHERE
                   DeveloperName =: 'Non_Availability'
                   AND
                   SObjectType =: ResourceAbsence.getSobjectType().getDescribe().getName()
               ];

           na.RecordTypeId = recordTypeNA.Id;
           na.ResourceId = resourceId;
           na.FSL__Approved__c = true;
           na.Start = ganttStartDate;
           na.End = ganttEndDate;

           insert na;

          ServiceResource resource = [SELECT Name FROM ServiceResource WHERE Id =: resourceId];


        return 'Blocked availability to ' + resource.Name + ' from ' +
ganttStartDate.format() + ' to ' + ganttEndDate.format();

     }

}
```

### Code Example: Service Appointment Custom Action

이 액션은 In Jeopardy 필드를 True/False 사이에서 토글한다.

```apex
global class toggleServiceAppointmentJeopardy implements
FSL.CustomGanttServiceAppointmentAction {

   global String action(List<Id> serviceAppointmentsIds, Datetime ganttStartDate, Datetime
 ganttEndDate, Map<String, Object> additionalParameters) {

        List<ServiceAppointment> saList = [SELECT FSL__InJeopardy__c, AppointmentNumber
FROM ServiceAppointment WHERE Id in : serviceAppointmentsIds];
        String reply = '';
        List<String> saNames = new List<String>();

           for (ServiceAppointment s : saList) {
               s.FSL__InJeopardy__c = !s.FSL__InJeopardy__c;
               saNames.add(s.AppointmentNumber);
           }

           upsert saList;

           reply = String.join(saNames, ', ');
           return 'Service Appointments successfully processed: ' + reply;
     }

}
```

### Code Example: Resource Absence Custom Action

NA 타입 resource absence에 대해 이 액션은 다음 날에 중복 absence를 생성한다.

```apex
global class copyAbsenceToNextDay implements FSL.CustomGanttResourceAbsenceAction {

   global String action(Id absenceId, String absenceType, Datetime ganttStartDate, Datetime
 ganttEndDate, Map<String, Object> additionalParameters) {

       ResourceAbsence resourceAbsence = [SELECT Id, AbsenceNumber, Start, End, ResourceId,
 RecordTypeId, FSL__Approved__c FROM ResourceAbsence WHERE Id =: absenceId LIMIT 1];

           ResourceAbsence raClone = resourceAbsence.clone(false, true, false, false);
           raClone.Start = resourceAbsence.Start.addDays(1);
           raClone.End = resourceAbsence.End.addDays(1);
           raClone.ResourceId = resourceAbsence.ResourceId;
           raClone.RecordTypeId = resourceAbsence.RecordTypeId;
           raClone.FSL__Approved__c = true;
           insert raClone;

           return 'Resource Absence successfully copied.';
     }

}
```

### Creating Visualforce Pages

Visualforce 페이지를 만들 때 다음 GET 파라미터를 사용한다.

| For actions on... | Description (파라미터 포맷·예시) |
|---|---|
| Service appointments | `services` [여러 개일 때], `id` (여러 개면 쉼표 구분), `start` (현재 Gantt start date, string), `end` (현재 Gantt end date, string)<br>· 단일 service appointment 업데이트 예: `?id=08p4E000000Kj5hQAC&start=5-7-2018&end=5-8-2018`<br>· 다중 service appointment 업데이트 예: `?services=08p4E000000Kj5hQAC,08p4E000430Kj5hAPP&start=5-7-2018&end=5-8-2018` |
| Service resources | `id`, `stm` (service resource의 현재 service territory member 레코드 ID), `start` (현재 Gantt start date, string), `end` (현재 Gantt end date, string)<br>· 예: `?id=0Hn4E0000001OMQSA2&stm=0Hu4E0000005cpPSAQ&start=5-7-2018&end=5-8-2018` |
| Resource absences | `id`, `type` ('break' 또는 'na'), `start` (현재 Gantt start date, string), `end` (현재 Gantt end date, string)<br>· 예: `?id=0Hw4E00000091HSSAY&type=break&start=5-7-2018&end=5-8-2018` |

코드에서 Visualforce lightbox를 닫으려면: `parent.postMessage('closeLightbox','*');`

> **Note:** 커스텀 dispatcher console 액션은 관리형 패키지의 일부인 Visualforce 페이지를 열 수 없다.

**SEE ALSO:** Create Custom Actions for the Dispatcher Console

---

## 코드 예제 4 — Create Service Appointment Lists in the Dispatcher Console

Field Service 관리형 패키지에서 **Create Temporary Service Appointment List** 커스텀 권한을 추가하면 user별 임시 appointment 목록을 만들 수 있다. 이 커스텀 권한이 활성화되면 Field Service 앱이 `CreateFilterEvent__e` platform event 채널에 연결을 만들고 관련 메시지를 구독한다.

event 채널 구독으로 소비되는 allocation 한도 정보는 Change Data Capture Allocations 참조.

커스텀 필터는 `CreateFilterEvent__e` platform event를 생성한 user만 생성·접근할 수 있고 다른 user에게는 보이지 않는다. 커스텀 필터를 기반으로 동일한 이름의 임시 목록을 만들 수 있다. 각 목록은 새 인스턴스로 생성되며 기존 것을 덮어쓰지 않는다. 각 목록은 **최대 300개**의 service appointment를 포함할 수 있다.

임시 appointment 목록이 dispatch console에 로드된 후 목록은 static 상태로 유지된다. 목록을 auto-refresh하려면 Field Service Admin 앱에서 Enhanced Live Updates를 활성화하고 service appointment의 field set의 모든 필드에 read 접근 권한이 있는지 확인한다. dispatch console이 refresh되면 임시 목록은 더 이상 사용할 수 없다. refresh 없이 임시 목록을 삭제하려면 Delete Filter를 클릭한다.

appointment용 커스텀 필터를 만들려면, 다음 커스텀 필드를 추가하여 새 `CreateFilterEvent__e` platform event를 정의·publish한다.

- **FSL__ServiceApptIds__c:** service appointment Id의 JSON 배열. 예: `["08pO10000049k7lIAA","08pO10000049k7mIAA"]`
- **FSL__FilterName__c:** 지정된 service appointment ID 기반의 임시 목록 이름. 예: `High Priority Appointments`
- **FSL__Description__c** (optional): 설명. 예: `This filter displays high priority appointments.`
- **FSL__FilterCategory__c:** 값은 반드시 `GENERAL`로 설정.
- **FSL__LoadFilterImmediately__c:** true로 설정하면 dispatcher console이 새 임시 목록으로 전환된다.

---

## 관련 노트
- [[Field Service 개요와 데이터 모델]]
- [[Field Service REST API]]
- [[Field Service Metadata·Tooling API]]
- [[FSL Apex Namespace]] — FSL 네임스페이스 Apex 클래스·인터페이스 reference(코드 예제의 `FSL.CustomGantt*Action` 인터페이스 소관)
- [[Trigger 컨텍스트 변수와 이벤트]]
