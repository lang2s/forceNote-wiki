---
tags: [field-service, fsl, sobject, object-reference, service-territory, operating-hours, shift, shift-pattern, shift-template, time-slot, 현장서비스, 객체레퍼런스]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [ServiceTerritory, ServiceTerritoryLocation, ServiceTerritoryMember, OperatingHours, OperatingHoursHoliday, Shift, ShiftPattern, ShiftPatternEntry, ShiftTemplate, TimeSlot, 서비스 영역, 운영시간, 운영시간 휴일, 시프트, 시프트 패턴, 시프트 템플릿, 타임슬롯]
---

# 객체 레퍼런스 — Service Territory·OperatingHours·Shift

> Field Service의 시간·영역 도메인 10개 표준 객체 — 서비스 영역(ServiceTerritory), 운영시간(OperatingHours), 시프트(Shift) 클러스터 — 의 설명·Supported Calls·전 필드·Special Access Rules·Usage·Associated Objects 전수.

---

> [!note] Scheduler 도메인 공유 주의
> `OperatingHours`·`OperatingHoursHoliday`·`ServiceTerritory`·`ServiceTerritoryMember`·`TimeSlot`은 Field Service 전용이 아니라 **Salesforce Scheduler·Workforce Engagement 등에서도 공유**되는 객체다. 이 노트는 Field Service Developer Guide v67.0 기준 정의를 다룬다 — Scheduler 맥락에서의 활용은 Scheduler 도메인 노트를 참조한다.

이 노트는 다음 10객체를 다룬다: `OperatingHours`, `OperatingHoursHoliday`, `ServiceTerritory`, `ServiceTerritoryLocation`, `ServiceTerritoryMember`, `Shift`, `ShiftPattern`, `ShiftPatternEntry`, `ShiftTemplate`, `TimeSlot`.

객체 간 관계(아래 필드 정의에서 도출한 SOQL 예시 — 동작 검증된 쿼리 아님):

```sql
// 구조 예시 — 실제 동작 코드 아님 (위 필드 정의의 관계 필드에서 도출)
// ServiceTerritory → OperatingHours → TimeSlot 경로
SELECT Id, Name, OperatingHoursId, ParentTerritoryId, TopLevelTerritoryId
FROM ServiceTerritory
WHERE IsActive = true

SELECT Id, DayOfWeek, StartTime, EndTime, OperatingHoursId
FROM TimeSlot
WHERE OperatingHoursId = :operatingHoursId

// Shift → ShiftTemplate, ShiftPatternEntry → ShiftPattern 연결
SELECT Id, Label, StartTime, EndTime, ShiftTemplateId, ServiceResourceId
FROM Shift
WHERE ServiceTerritoryId = :territoryId
```

---

## OperatingHours

서비스 영역·서비스 리소스·계정이 작업 가능한 시간대를 나타낸다. Field Service, Salesforce Scheduler, Salesforce Meetings, Sales Engagement, Workforce Engagement에서 사용된다. API version 38.0 이상.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** (명시 안 됨)

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | 운영시간 설명. 이름에 포함되지 않은 세부사항 추가. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 운영시간 레코드가 마지막으로 수정된 날짜. UI 레이블은 **Last Modified Date**. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 운영시간 레코드를 마지막으로 본 날짜. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | 운영시간 이름. 예: Summer Hours, Winter Hours, Peak Season Hours. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | 운영시간 레코드 소유자 ID. API version 59.0부터 제공. polymorphic 관계 필드. **RelName:** Owner · **RelType:** Lookup · **Refers To:** Group, User |
| TimeZone | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | 운영시간이 속한 시간대. |

**Usage:** 기본적으로 System Administrator만 운영시간을 보고·생성·할당할 수 있다. 서비스 영역 구성원(territory에서 일할 수 있는 service resource)은 자동으로 소속 service territory의 운영시간을 사용한다. 리소스가 territory와 다른 운영시간이 필요하면 Operating Hours 탭에서 별도 운영시간을 만들고, service territory member 상세 페이지의 Operating Hours 룩업 필드에서 선택한다. 특정 territory에 대한 service resource 운영시간을 보려면 Service Territories 관련 목록에서 해당 territory의 Member Number를 클릭한다 — service territory member 상세 페이지가 열리고 구성원의 운영시간과 territory 소속 기간이 표시된다.

**Associated Objects:** (별도 명시 없으면 객체와 동일 API 버전)
- OperatingHoursChangeEvent (API version 54.0) — Change events
- OperatingHoursHistory (API version 62.0) — History (tracked fields)

---

## OperatingHoursHoliday

서비스 영역 또는 서비스 리소스가 Field Service, Salesforce Scheduler, Salesforce Meetings, Sales Engagement, Workforce Engagement에서 작업 불가능한 날 또는 시간을 나타낸다. API version 54.0 이상.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules:** Field Service must be enabled.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| DateAndTime | string | Filter, Group, Nillable, Sort | (Read-Only) 휴일의 날짜 또는 시간. |
| HolidayId | reference | Create, Filter, Group, Sort, Update | OperatingHoursId 필드에 표시된 운영시간과 관련된 holiday의 ID. 관계 필드. **RelName:** Holiday · **RelType:** Lookup · **Refers To:** Holiday |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 객체와 관련된 레코드를 마지막으로 본 날짜·시간. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 객체를 마지막으로 본 타임스탬프. |
| OperatingHoursHolidayNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | (Read-Only) 운영시간 휴일을 식별하는 자동 생성 번호. |
| OperatingHoursId | reference | Create, Filter, Group, Sort | HolidayId 필드에 표시된 holiday와 관련된 운영시간의 ID. 관계 필드. **RelName:** OperatingHours · **RelType:** Lookup · **Refers To:** OperatingHours |

**Usage:** (명시 안 됨)

**Associated Objects:** (API 버전 미명시 시 객체와 동일하거나 명시 버전 이상)
- OperatingHoursHolidayChangeEvent (API version 62.0) — Change events
- OperatingHoursHolidayHistory (API version 62.0) — History (tracked fields)

---

## ServiceTerritory

Field Service, Salesforce Scheduler, Workforce Engagement에서 작업이 수행될 수 있는 지리적 또는 기능적 영역을 나타낸다. API version 38.0 이상.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Field Service must be enabled.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| Address | address | Filter | territory와 연결할 주소. 예: territory 본부 주소. |
| AvgTravelTime | int | Create, Filter, Group, Nillable, Sort, Update | 이 service territory의 평균 이동 시간. service territory 내 예약된 각 service appointment의 Work Capacity Usage에 더해진다. API version 59.0 이상. |
| City | string | Create, Filter, Group, Nillable, Sort, Update | 연결된 주소의 시. 최대 40자. |
| Country | string | Create, Filter, Group, Nillable, Sort, Update | territory와 연결할 국가. 최대 80자. |
| Description | textarea | Create, Nillable, Update | territory 설명. |
| GeocodeAccuracy | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 위치 지리 좌표의 물리 주소 대비 정확도 수준. 보통 주소의 위·경도 기반으로 geocoding 서비스가 제공. API 전용 필드. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | service territory 사용 여부. 비활성이면 구성원을 추가하거나 work order·work order line item·service appointment에 연결할 수 없다. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | territory가 마지막으로 수정된 날짜. UI 레이블은 **Last Modified Date**. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | territory를 마지막으로 본 날짜. |
| Latitude | double | Create, Filter, Nillable, Sort, Update | Longitude와 함께 territory 주소의 정확한 geolocation 지정. –90 ~ 90, 소수점 15자리까지. API 전용 필드. |
| Longitude | double | Create, Filter, Nillable, Sort, Update | Latitude와 함께 territory 주소의 정확한 geolocation 지정. –180 ~ 180, 소수점 15자리까지. API 전용 필드. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | territory 이름. |
| OperatingHoursId | reference | Create, Filter, Group, Sort, Update | territory의 운영시간 — territory 내 service appointment가 발생 가능한 시점을 나타낸다. territory 구성원인 service resource는 리소스 레코드에 별도 시간이 지정되지 않는 한 자동으로 territory 운영시간을 상속한다. 관계 필드. **RelName:** OperatingHours · **RelType:** Lookup · **Refers To:** OperatingHours |
| ParentTerritoryId | reference | Create, Filter, Group, Nillable, Sort, Update | territory의 상위 service territory(있는 경우). 예: Northern California territory는 State of California territory를 부모로 가질 수 있다. service territory 계층은 최대 10,000개 territory를 포함할 수 있다. 관계 필드. **RelName:** ParentTerritory · **RelType:** Lookup · **Refers To:** ServiceTerritory |
| PostalCode | string | Create, Filter, Group, Nillable, Sort, Update | territory와 연결된 주소의 우편번호. 최대 20자. |
| State | string | Create, Filter, Group, Nillable, Sort, Update | territory와 연결된 주소의 주(state). 최대 80자. |
| Street | textarea | Create, Filter, Group, Nillable, Sort, Update | territory와 연결된 주소의 번지·도로명. |
| TopLevelTerritoryId | reference | Filter, Group, Nillable, Sort | (Read only) service territory 계층의 최상위 territory. 계층 내 위치에 따라 top-level territory가 parent와 같을 수 있다. 관계 필드. **RelName:** TopLevelTerritory · **RelType:** Lookup · **Refers To:** ServiceTerritory |
| TravelModeId | reference | Create, Filter, Group, Nillable, Sort, Update | 이동 시간 계산에 사용되는 TravelMode의 ID. travel mode는 교통수단 유형(차량·도보 등), 톨게이트 통과 가능 여부, 위험물 운송 여부 정보를 포함한다. 관계 필드. **RelName:** TravelMode · **RelType:** Lookup · **Refers To:** TravelMode |
| TravelTimeBuffer | int | Create, Filter, Group, Nillable, Sort, Update | 주차 찾기·현장 도보 이동 등 운전 시간에 추가하는 시간. Field Service Settings \| Scheduling \| Routing에 정의된 Travel Time Buffer 값을 재정의한다. |
| TypicalInTerritoryTravelTime | double | Create, Filter, Nillable, Sort, Update | service territory 내 한 위치에서 다른 위치로 이동하는 데 필요한 추정 분(minute). Apex 커스터마이즈에 사용 가능. |

**Usage:** service territory를 사용하려면 어떤 territory를 생성할지 결정한다. 비즈니스 방식에 따라 도시·카운티 기반으로, 또는 영업 대 서비스 같은 기능 범주 기반으로 territory를 만들 수 있다. 계층을 구축할 계획이면 최상위 territory를 먼저 만든다. 예: California 팀 작업 영역 계층 — 최상위 California territory, 하위 Northern/Central/Southern California territory 3개, 그리고 California 카운티에 대응하는 3단계 territory들. 각 카운티 territory에 service resource를 할당해 누가 그 카운티에서 일할 수 있는지 나타낸다.

**Associated Objects:** (API 버전 미명시 시 객체와 동일, 그 외 명시 버전 이상)
- ServiceTerritoryChangeEvent (API version 48.0) — Change events
- ServiceTerritoryFeed — Feed tracking
- ServiceTerritoryHistory — History (tracked fields)
- ServiceTerritoryOwnerSharingRule — Sharing rules
- ServiceTerritoryShare — Sharing

---

## ServiceTerritoryLocation

Field Service에서 특정 service territory와 연결된 location을 나타낸다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()` (※ `search()` 없음)

**Special Access Rules:** Field Service must be enabled.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| LocationId | reference | Create, Filter, Group, Sort, Update | service territory와 연결된 location. |
| ServiceTerritoryId | reference | Create, Filter, Group, Sort | 연결된 service territory. |
| ServiceTerritoryLocationNumber | string | Autonumber, Defaulted on create, Filter, Sort | (Read only) service territory location을 식별하는 자동 생성 번호. |

**Usage:** (명시 안 됨)

**Associated Objects:** (별도 명시 없으면 객체와 동일 API 버전)
- ServiceTerritoryLocationChangeEvent (API version 55.0) — Change events
- ServiceTerritoryLocationFeed — Feed tracking
- ServiceTerritoryLocationHistory — History (tracked fields)

---

## ServiceTerritoryMember

Field Service, Salesforce Scheduler, Workforce Engagement에서 service territory에 할당될 수 있는 service resource를 나타낸다. API version 38.0 이상.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`

**Special Access Rules:** Field Service 또는 Workforce Engagement must be enabled.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| Address | address | Filter | 구성원 주소. 관련 service resource의 주소를 기재할 수 있다. |
| City | string | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 구성원 주소의 시. 최대 40자. |
| Country | string | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 구성원 주소의 국가. 최대 80자. |
| EffectiveEndDate | datetime | Create, Filter, Nillable, Sort, Update | service resource가 더 이상 territory 구성원이 아니게 되는 날짜. 무기한 근무 예정이면 비워둔다. 주로 임시 재배치 종료 시점 표시에 유용. |
| EffectiveStartDate | datetime | Create, Filter, Sort, Update | service resource가 service territory 구성원이 되는 날짜. |
| GeocodeAccuracy | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 위치 지리 좌표의 물리 주소 대비 정확도 수준. 보통 주소 위·경도 기반으로 geocoding 서비스가 제공. *Note: API 전용 필드.* |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | territory 구성원이 마지막으로 수정된 날짜. UI 레이블은 **Last Modified Date**. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | territory 구성원을 마지막으로 본 날짜. |
| Latitude | double | Create, Defaulted on create, Filter, Nillable, Sort, Update | Longitude와 함께 구성원 주소의 정확한 geolocation 지정. –90 ~ 90, 소수점 15자리까지. *Note: API 전용 필드.* |
| Longitude | double | Create, Defaulted on create, Filter, Nillable, Sort, Update | Latitude와 함께 구성원 주소의 정확한 geolocation 지정. –180 ~ 180, 소수점 15자리까지. *Note: API 전용 필드.* |
| MemberNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | (Read only) service territory 구성원을 식별하는 자동 생성 번호. |
| OperatingHoursId | reference | Create, Filter, Group, Sort, Nillable, Update | service territory 구성원에 할당된 운영시간. 운영시간 미지정 시 상위 service territory 운영시간을 사용한다고 가정. 특별 운영시간이 필요하면 Setup에서 만들고 구성원 상세 페이지의 Operating Hours 룩업 필드에서 선택. 관계 필드. **RelName:** OperatingHours · **RelType:** Lookup · **Refers To:** OperatingHours |
| PostalCode | string | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 구성원 주소의 우편번호. 최대 20자. |
| ServiceResourceId | reference | Create, Filter, Group, Sort, Update | service territory에 할당된 service resource. 관계 필드. **RelName:** ServiceResource · **RelType:** Lookup · **Refers To:** ServiceResource |
| ServiceTerritoryId | reference | Create, Filter, Group, Sort | service resource가 할당된 service territory. 관계 필드. **RelName:** ServiceTerritory · **RelType:** Lookup · **Refers To:** ServiceTerritory |
| State | string | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 구성원 주소의 주(state). 최대 80자. |
| Street | textarea | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 구성원 주소의 번지·도로명. |
| TerritoryType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Primary, Secondary, Relocation. • primary territory는 보통 리소스가 가장 자주 일하는 territory(예: 홈베이스 근처) — service resource는 primary territory를 하나만 가질 수 있다. • secondary territory는 필요 시 appointment에 할당될 수 있는 territory — 여러 개 가능. • relocation territory는 service resource의 임시 이동을 나타낸다. Field Service 관리형 패키지와 scheduling optimizer 사용 시, relocation territory가 있는 리소스는 지정된 relocation 기간 동안 항상 relocation territory 내 서비스에 할당된다 — relocation territory가 없으면 secondary보다 primary territory가 우선된다. 예: 한 service resource — • Primary territory: West Chicago • Secondary territories: – East Chicago – South Chicago • Relocation territory: Manhattan, 3개월 기간. |
| TravelModeId | reference | Create, Filter, Group, Nillable, Sort, Update | 이동 시간 계산에 사용되는 TravelMode의 ID. travel mode는 교통수단 유형, 톨게이트 통과 여부, 위험물 운송 여부 정보를 포함. 관계 필드. **RelName:** TravelMode · **RelType:** Lookup · **Refers To:** TravelMode |

**Usage:** 구성원이 있는 service territory를 삭제하면, 구성원이었던 service resource는 더 이상 해당 territory와 연결되지 않는다.

**Associated Objects:** (API 버전 미명시 시 객체와 동일, 그 외 명시 버전 이상)
- ServiceTerritoryMemberChangeEvent (API version 48.0) — Change events
- ServiceTerritoryMemberFeed — Feed tracking
- ServiceTerritoryMemberHistory — History (tracked fields)

---

## Shift

service resource 스케줄링을 위한 시프트를 나타낸다. API version 46.0 이상.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `upsert()` (※ `update()`·`undelete()` 없음)

**Special Access Rules:** Field Service, Service Engagement, 또는 Workforce Engagement must be enabled. Field Service의 경우 사용자는 Field Service 권한이 필요하다. Service Engagement의 경우 Service Engagement Planner permission set이 필요하다. Workforce Engagement의 경우 Workforce Engagement Admin 또는 Planner permission set이 필요하다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| BackgroundColor | string | Create, Filter, Group, Nillable, Sort, Update | UI에 시프트 표시 시 배경색 설정. 3자리 또는 6자리 16진수 형식(예: #FF00FF). API version 54.0 이상. |
| EndTime | dateTime | Create, Filter, Sort, Update | 시프트가 종료되는 날짜·시간. |
| IsHolidayShift | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 휴일 시간과 겹치는 시프트인지 표시. 기본값 false. API version 55.0 이상. |
| IsNonStandard | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 초과근무·대기(on-call) 등 비표준 시프트 여부. 기본값 false. API version 54.0 이상. |
| JobProfileId | reference | Create, Filter, Group, Nillable, Sort, Update | 시프트와 연결된 job profile. API version 47.0 이상. |
| Label | string | Create, Filter, Group, Nillable, Sort, Update | 시프트에 부여된 레이블. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 관련 레코드를 마지막으로 본 날짜·시간. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드를 마지막으로 본 날짜·시간. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | 시프트 소유자. polymorphic 관계 필드. **RelName:** Owner · **RelType:** Lookup · **Refers To:** Group, User |
| RecordsetFilterCriteriaId | reference | Create, Filter, Group, Nillable, Sort, Update | 시프트에 선택된 recordset filter criteria의 ID. API version 49.0 이상. 관계 필드. **RelName:** RecordsetFilterCriteria · **RelType:** Lookup · **Refers To:** RecordsetFilterCriteria |
| ServiceResourceId | reference | Create, Filter, Group, Nillable, Sort, Update | 시프트가 속한 service resource의 ID. API version 47.0 이상. 관계 필드. **RelName:** ServiceResource · **RelType:** Lookup · **Refers To:** ServiceResource |
| ServiceTerritoryId | reference | Create, Filter, Group, Nillable, Sort, Update | 시프트가 속한 service territory의 ID. API version 47.0 이상. 관계 필드. **RelName:** ServiceTerritory · **RelType:** Lookup · **Refers To:** ServiceTerritory |
| ShiftNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | 시프트 생성 시 자동 부여되는 번호. |
| ShiftTemplateId | reference | Create, Filter, Group, Nillable, Sort | 시프트가 shift template에서 생성된 경우 그 template ID. API version 53.0 이상. 관계 필드. **RelName:** ShiftTemplate · **RelType:** Lookup · **Refers To:** ShiftTemplate |
| StartTime | dateTime | Create, Filter, Sort, Update | 시프트가 시작되는 날짜·시간. |
| Status | picklist | Create, Filter, Group, Sort, Update | 시프트 상태. 사용자 정의 값 생성 가능. 기본값: • Tentative • Published • Confirmed |
| StatusCategory | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 정적 값으로 시프트 상태를 표현. setup에 정의된 매핑을 통해 Status에서 파생. 가능한 값: • Tentative • Published • Confirmed |
| TimeSlotType | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | 시프트의 time slot 유형. OperatingHours 객체의 TimeSlot 필드와 동일 setup 값. 가능한 값: • Normal (기본값) • Extended |

**Usage:** 시프트 데이터를 사용한 service resource 스케줄링·디스패칭은 API version 46.0에서는 지원되지 않으며, API version 47.0에서는 pilot 기능이다.

**Associated Objects:** (별도 명시 없으면 객체와 동일 API 버전)
- ShiftChangeEvent (API version 54.0) — Change events
- ShiftFeed — Feed tracking
- ShiftHistory — History (tracked fields)
- ShiftOwnerSharingRule — Sharing rules
- ShiftShare — Sharing

---

## ShiftPattern

시프트 생성을 위한 template들의 패턴을 나타낸다. API version 51.0 이상.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Field Service must be enabled. 사용자는 Field Service 권한이 필요하다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | 사용자가 패턴을 식별하는 데 도움이 되는 shift pattern 짧은 설명. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | shift pattern을 시프트 생성에 사용할 수 있는지 표시. 기본값 'false'. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | shift pattern이 마지막으로 사용된 날짜. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | shift pattern을 마지막으로 본 날짜. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | shift pattern의 짧고 서술적인 이름. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | shift pattern 소유자 ID. 기본값은 shift pattern을 만든 사용자. polymorphic 관계 필드. **RelName:** Owner · **RelType:** Lookup · **Refers To:** Group, User |
| PatternLength | int | Create, Filter, Group, Sort, Update | shift pattern의 일(day) 단위 기간. |

**Usage:** (명시 안 됨)

**Associated Objects:** (API 버전 미명시 시 객체와 동일, 그 외 명시 버전 이상)
- ShiftPatternChangeEvent (API version 54.0) — Change events
- ShiftPatternFeed — Feed tracking
- ShiftPatternHistory — History (tracked fields)
- ShiftPatternShare — Sharing

---

## ShiftPatternEntry

shift template을 shift pattern에 연결한다. API version 51.0 이상.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Field Service must be enabled. 사용자는 Field Service 권한이 필요하다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| DayOrder | int | Create, Filter, Group, Sort, Update | DayOrder는 shift template을 shift pattern 기간 내 특정 일(day)에 연결한다. 예: DayOrder가 2이면 연결된 template의 시프트가 패턴의 둘째 날에 생성된다. *[sic — 원문 "...the specific day within the shift pattern duration that the template." 문장이 미완결로 끝남]* |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | shift pattern entry가 마지막으로 사용된 날짜. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | shift pattern entry를 마지막으로 본 날짜. |
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | shift pattern entry의 자동 생성 참조 번호. |
| ShiftPatternId | reference | Create, Filter, Group, Sort | shift pattern entry가 연결된 shift pattern의 ID. 관계 필드. **RelName:** ShiftPattern · **RelType:** Lookup · **Refers To:** ShiftPattern |
| ShiftTemplateId | reference | Create, Filter, Group, Sort, Update | 이 shift pattern entry의 시프트를 생성하는 데 사용되는 shift template의 ID. 관계 필드. **RelName:** ShiftTemplate · **RelType:** Lookup · **Refers To:** ShiftTemplate |

**Usage:** (명시 안 됨)

**Associated Objects:** (별도 명시 없으면 객체와 동일 API 버전)
- ShiftPatternEntryChangeEvent (API version 54.0) — Change events

---

## ShiftTemplate

시프트 생성을 위한 template을 나타낸다. API version 51.0 이상.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()` (※ `undelete()` 없음)

**Special Access Rules:** Field Service 또는 Workforce Engagement must be enabled. Field Service의 경우 사용자는 Field Service 권한이 필요하다. Workforce Engagement의 경우 Workforce Engagement Admin 또는 Planner permission set이 필요하다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| BackgroundColor | string | Create, Filter, Group, Nillable, Sort, Update | UI에 시프트 표시 시 배경색 설정. 3자리 또는 6자리 16진수 형식(예: #FF00FF). API version 54.0 이상. |
| Description | textarea | Create, Filter, Group, Nillable, Sort, Update | 휴식 횟수·활동 등 시프트 추가 정보. |
| Duration | double | Create, Filter, Sort, Update | 시프트 지속 기간. 측정 단위는 ShiftTemplateDurationType으로 결정된다. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 시프트 활성/비활성 여부. |
| IsNonStandard | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 초과근무·대기(on-call) 등 비표준 시프트 여부. 기본값 false. API version 54.0 이상. |
| JobProfileId | reference | Create, Filter, Group, Nillable, Sort, Update | Job Profile 레코드. 선택 필드. 관계 필드. **RelName:** JobProfile · **RelType:** Lookup · **Refers To:** JobProfile |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | shift template이 마지막으로 수정된 날짜. UI 레이블은 **Last Modified Date**. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | shift template을 마지막으로 본 날짜. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | shift template 레코드 이름. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | shift template 소유자. polymorphic 관계 필드. **RelName:** Owner · **RelType:** Lookup · **Refers To:** Group, User |
| RecordsetFilterCriteriaId | reference | Create, Filter, Group, Nillable, Sort, Update | shift template에 선택된 recordset filter criteria의 ID. API version 53.0 이상. 관계 필드. **RelName:** RecordsetFilterCriteria · **RelType:** Lookup · **Refers To:** RecordsetFilterCriteria |
| ShiftTemplateDurationType | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | shift template 기간의 측정 단위. 가능한 값: • H—Hours • M—Minutes. 기본값 H. |
| StartTime | time | Create, Filter, Sort, Update | 시프트가 시작되는 시각. |
| TimeSlotType | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | time slot 유형. 가능한 값: • Normal • Extended. Extended는 초과근무 시프트 표현에 사용. API version 55.0 이상. |

**Usage:** (명시 안 됨)

**Associated Objects:** (API 버전 미명시 시 객체와 동일, 그 외 명시 버전 이상)
- ShiftTemplateOwnerSharingRule — Sharing rules
- ShiftTemplateShare — Sharing
- ShiftTemplateChangeEvent — Change Data Capture events. API version 54.0 이상.

---

## TimeSlot

Field Service, Salesforce Scheduler, Workforce Engagement에서 작업이 수행될 수 있는, 특정 요일의 시간 구간을 나타낸다. 운영시간은 하나 이상의 time slot으로 구성된다. API version 38.0 이상.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `update()`, `upsert()` (※ `search()`·`undelete()` 없음)

**Special Access Rules:** (명시 안 됨)

> **Fields 순서 주의:** 아래 표는 PDF 필드 순서를 그대로 따른다 — `StartTime`이 `OperatingHoursId` 뒤, `RecordSetFilterCriteriaId` 앞에 위치한다(알파벳순 아님).

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| DayOfWeek | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | time slot이 발생하는 요일. |
| EndTime | time | Create, Filter, Sort, Update | time slot이 종료되는 시각. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드와 관련된 레코드를 마지막으로 본 타임스탬프. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드를 마지막으로 본 타임스탬프. null이면 이 레코드는 조회(LastReferencedDate)만 되고 view되지 않았을 수 있다. |
| MaxAppointments | int | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 단일 time slot의 최대 appointment 수. API version 47.0 이상. |
| OperatingHoursId | reference | Create, Filter, Group, Sort | time slot이 속한 운영시간. 운영시간의 time slot들은 Operating Hours 관련 목록에 나타난다. 관계 필드. **RelName:** OperatingHours · **RelType:** Lookup · **Refers To:** OperatingHours |
| StartTime | time | Create, Filter, Sort, Update | time slot이 시작되는 시각. |
| RecordSetFilterCriteriaId | reference | Create, Filter, Group, Nillable, Sort, Update | time slot에 선택된 recordset filter criteria의 ID. 관계 필드. **RelName:** RecordsetFilterCriteria · **RelType:** Lookup · **Refers To:** RecordsetFilterCriteria *[sic — 필드명은 대문자 S의 RecordSetFilterCriteriaId이나 RelName은 RecordsetFilterCriteria로 대소문자 불일치]* |
| TimeSlotNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | time slot 이름. 요일·시간 형식으로 자동 채워짐(예: Monday 9:00 AM - 10:00 PM)이며 수동 수정 가능. |
| Type | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | time slot 유형. 가능한 값은 Normal과 Extended. Extended는 초과근무 시프트 표현에 사용할 수 있다. |
| WorkTypeGroupId | reference | Create, Filter, Group, Nillable, Sort, Update | time slot에 할당된 work type group. API version 47.0 이상. 관계 필드. **RelName:** WorkTypeGroup · **RelType:** Lookup · **Refers To:** WorkTypeGroup |

**Usage:** 운영시간은 time slot으로 구성되며, time slot은 특정 일의 운영 시간을 나타낸다. 운영시간 생성 후 각 날짜에 대한 time slot을 만든다. 예: 운영시간이 월~금 오전 8시–오후 5시라면 하루에 하나씩 5개의 time slot을 만든다. 점심시간 같은 휴식을 반영하려면 하루에 여러 time slot을 만든다 — 예: Monday 8:00 AM – 12:00 PM, Monday 1:00 PM – 5:00 PM.

> **Tip:** time slot에는 내장 규칙이 없지만, org 내에서 time slot 설정을 제한하는 Apex 트리거를 만들 수 있다. 예: 시작·종료 시각을 30분 단위로 제한하거나, 종료 시각을 오후 8시 이후로 금지.

**Associated Objects:** (별도 명시 없으면 객체와 동일 API 버전)
- TimeSlotChangeEvent (API version 54.0) — Change events
- TimeSlotHistory (API version 62.0) — History (tracked fields)

---

## 관련 노트
- [[Field Service 개요와 데이터 모델]] — Field Service 데이터 모델·도메인 전반
- [[Field Service Objects]] — Field Service 표준 객체 전체 카탈로그
- [[객체 레퍼런스 — Service Appointment·Resource]] — ServiceResource·ServiceAppointment 등 인접 객체
- [[객체 레퍼런스 — Service Resource·Crew·Skill]] — ServiceTerritoryMember·Shift가 참조하는 ServiceResource 본체와 인력 객체
