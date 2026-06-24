---
tags: [field-service, fsl, sobject, object-reference, work-capacity, recordset-filter, 현장서비스, 작업가용량, 레코드셋필터]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-24
aliases: [WorkCapacityAvailability, WorkCapacityLimit, WorkCapacityUsage, RecordsetFilterCriteria, RecordsetFilterCriteriaRule, RecordsetFltrCritMonitor, SvcApptField, work capacity, recordset filter criteria, 작업 가용량, 작업 용량 한도, 작업 용량 사용량, 레코드셋 필터 기준, 레코드셋 필터 규칙, RFC 모니터]
---

# 객체 레퍼런스 — WorkCapacity·RecordsetFilterCriteria

> Field Service의 **작업 용량(Work Capacity) 관리**와 **레코드셋 필터 기준(Recordset Filter Criteria)** 클러스터의 SOAP API 객체 6종 전수 레퍼런스 — 서비스 영역별 가용 용량(WorkCapacityAvailability)·용량 한도(WorkCapacityLimit)·용량 사용량(WorkCapacityUsage)과, 서비스 약속·자산을 기준에 따라 매칭하는 필터 기준(RecordsetFilterCriteria)·필터 규칙(RecordsetFilterCriteriaRule)·자산 임계값 모니터(RecordsetFltrCritMonitor). 각 객체의 설명·Supported Calls·전 필드·Special Access Rules·Usage·Associated Objects를 담는다.

> 이 노트는 Field Service의 **작업 용량 관리 및 레코드셋 필터** 도메인 SOAP API 객체 정의를 다룬다. 전체 데이터 모델 개요와 객체 간 관계도(ER diagram)는 [[Field Service 개요와 데이터 모델]], 객체 카탈로그 요약은 [[Field Service Objects]]를 참조한다.
>
> **[sic] 보존:** PDF 원문의 오타·오기를 의도적으로 그대로 둔 곳에 `[sic]`을 달았다(예: 필드명 "NextOccurence"·"Usage Rate Field", 본문 "LastReferenceDate"·"ration"·"RecordSetFilterCriteria", enum suffix "__ce" 등). 교정하지 않고 PDF 원문 그대로 옮긴다.
>
> 필드 표 형식: PDF는 2열(Field Name | Details)이고 Details 셀 안에 Type/Properties/Description/Relationship Name/Relationship Type/Refers To가 세로 나열돼 있다. 본 노트는 이를 4열(Field · Type · Properties · Description)로 펼치고, 관계 필드는 Description 끝에 `RelName / RelType / Refers To`를 표기했다.

---

## 객체 한눈에 (6)

| # | 객체 | 한 줄 | 필드 수(전수) | API 도입 |
|---|---|---|---|---|
| 1 | RecordsetFilterCriteria | 서비스 약속/자산을 기준에 맞춰 매칭하는 필터 기준 집합 | 11 | v50.0+ |
| 2 | RecordsetFilterCriteriaRule | source 객체 필드로 필터를 만드는 규칙 | 11 | v50.0+ |
| 3 | RecordsetFltrCritMonitor | 자산 속성이 RFC 임계값 내인지 모니터 | 7 | v57.0+ |
| 4 | WorkCapacityAvailability | 특정 시간·서비스 영역의 가용 작업 용량 | 9 | v59.0+ |
| 5 | WorkCapacityLimit | 워크스트림/영역의 용량 한도 | 24 | v59.0+ |
| 6 | WorkCapacityUsage | 워크스트림/영역의 용량 사용량 | 23 | v59.0+ |

> WorkCapacityLimit·WorkCapacityUsage는 동일한 `SvcApptField` picklist enum(31값)을 공유한다. 두 객체 모두 본문에 enum 31값을 전수 기재했다.

```sql
-- 구조 예시 — 실제 동작 쿼리 아님 (필드명은 본문 표의 PDF 원문 필드 기준)
-- 특정 서비스 영역의 활성 용량 한도와 해당일 사용량/한도 비율 조회
SELECT Id, SvcApptFieldValDplyNm, LimitationUnits, LimitationValue, TimePeriod
FROM WorkCapacityLimit
WHERE ServiceTerritoryId = :territoryId AND IsActive = true

SELECT Id, StartDate, TimeConsumedInHours, LimitationValue, ConsumptionToLimitRatio
FROM WorkCapacityUsage
WHERE ServiceTerritoryId = :territoryId AND StartDate = TODAY
```

---

## 1. RecordsetFilterCriteria

기준(criteria) 필드를 바탕으로 서비스 약속(service appointment) 또는 자산(asset)을 매칭하는 **필터 집합**을 나타낸다. 예를 들어, 필터 기준을 만족하는 서비스 약속만 필터링된 shift에 매칭되도록, 마찬가지로 기준을 만족하는 maintenance work rule만 자산에 매칭되도록 할 수 있다. v50.0+. 자산과 maintenance work rule은 v52.0+에서 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields (11):**

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | recordset filter criteria의 설명. |
| FilteredObject | picklist | Create, Filter, Group, Restricted picklist, Sort | 필터 기준을 정의하는 데 사용되는 객체. v52.0+. 값: Asset, ServiceAppointment. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | recordset filter criteria가 shift 또는 maintenance work rule과 연결됐는지(true) 여부. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | recordset filter criteria가 마지막으로 referenced된 날짜. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | recordset filter criteria가 마지막으로 view된 날짜. |
| LogicalOperator | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 여러 recordset filter criteria rule을 평가하는 논리를 정의. v53.0+. 값: AND, OR. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | recordset filter criteria의 이름. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | recordset filter criteria의 소유자. |
| SourceObject | picklist | Create, Filter, Group, Restricted picklist, Sort | 필터링된 기준이 적용되는 source 객체. shift와 maintenance work rule은 v52.0+, appointment bundle 객체는 v53.0+에서 사용 가능. 값: ApptBundleAggrPolicy—Appointment Bundle Aggregation Policy, ApptBundleConfig—Appointment Bundle Config, Shift, ContractLineOutcome, MaintenanceWorkRule. |
| Usage Rate Field [sic] | picklist | Create, Filter, Group, Restricted picklist, Sort | 자산의 일일 사용률(daily usage rate)을 저장. 사용률의 단위는 per day여야 한다. (필드명에 공백 포함 — PDF 원문 그대로 "Usage Rate Field") |
| Usage Rate Unit [sic] | picklist | Create, Filter, Group, Restricted picklist, Sort | Usage Rate Field의 rate를 정의. 값: DAYS. (필드명에 공백 포함 — PDF 원문 그대로 "Usage Rate Unit") |

> 필드 총 11개. PDF 본문에서 "Description"이 페이지 경계(p.251/252)에 걸쳐 헤더에 Type만(textarea), 다음 페이지에 Properties/Description 전체가 나온다. 위 표는 합쳐서 기록했다.

**Usage:** 직원이 일요일 오전 9시~오후 5시 shift는 근무할 수 있으나 emergency 약속에 한해서만 가능하다고 하자. 이 경우 SourceObject는 Shift, FilteredObject는 ServiceAppointment다. 해당 shift에 가용한 서비스 약속은 RecordsetFilterCriteriaRule 객체를 사용해 emergency 약속으로 필터링된다. RecordSetFilterCriteria [sic: 본문에서 "RecordSetFilterCriteria" — 대문자 S, 정식 객체명은 RecordsetFilterCriteria]는 report type에 사용할 수 없다.

**Associated Objects:** (별도 명시 없으면 이 객체와 동일 API 버전에서 사용 가능.)
- `RecordsetFilterCriteriaFeed` — feed tracking 사용 가능.
- `RecordsetFilterCriteriaHistory` — 추적 필드의 history 사용 가능.
- `RecordsetFilterCriteriaOwnerSharingRule` — sharing rule 사용 가능.
- `RecordsetFilterCriteriaShare` — sharing 사용 가능.

---

## 2. RecordsetFilterCriteriaRule

지정된 source 객체의 필드를 사용해 filtered(target) 객체에 대한 필터를 만드는 **규칙(rule)**을 나타낸다. RecordsetFilterCriteriaRule은 RecordsetFilterCriteria 객체와 연결된다. v50.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields (11):**

| Field | Type | Properties | Description |
|---|---|---|---|
| CriteriaField | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | 필터 규칙이 적용되는 필드. 자산 필드는 v52.0+에서 사용 가능. 가능한 값은 source 객체의 표준·커스텀 필드에서 파생된다. 가능한 표준 source 객체는 Asset과 ServiceAppointment. 형식 예: Asset.PricingSource 또는 ServiceAppointment.GroupAppointmentAccessType. encryptedstring, multipicklist, textarea, url 필드 유형을 제외한 모든 표준·커스텀 필드 허용. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | recordset filter criteria rule이 마지막으로 referenced된 날짜. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | recordset filter criteria rule이 마지막으로 view된 날짜. |
| NextOccurence [sic] | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 이 필드의 값이 Usage Field와 비교되어 규칙이 true인지 판단된다. 가능한 값은 source 객체의 표준·커스텀 필드에서 파생된다. 가능한 표준 source 객체는 Asset과 ServiceAppointment. 형식 예: Asset.PricingSource 또는 ServiceAppointment.GroupAppointmentAccessType. encryptedstring, multipicklist, textarea, url 필드 유형을 제외한 모든 표준·커스텀 필드 허용. (철자 "NextOccurence" — r 1개, 표준 영어는 NextOccurrence. PDF 원문 그대로) |
| Operator | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | CriteriaField와 Value 사이의 관계 연산자. v52.0+. 값: Equals—Default, GreaterOrEqual, GreaterThan, LessOrEqual, LessThan. |
| RecordsetFilterCriteriaId | reference | Create, Filter, Group, Sort | 이 규칙을 연결할 RecordsetFilterCriteria 레코드의 ID. |
| RecordsetFilterCriteriaRuleNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | recordset filter criteria rule에 자동 할당된 번호. |
| Type | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | criteria rule의 유형. 값: Criteria—Default, Usage, UsageCounter—Usage(Counter), UsageDuration—Usage(Duration). |
| Value | textarea | Create, Nillable, Update | 필터 규칙에 적용되는 CriteriaField의 기대 값. |
| Usage Rate Field [sic] | picklist | Create, Filter, Group, Restricted picklist, Sort | 자산의 일일 사용률을 저장. 사용률 단위는 per day여야 한다. 가능한 값은 source 객체의 표준·커스텀 필드에서 파생. 가능한 표준 source 객체는 Asset과 ServiceAppointment. 형식 예: Asset.PricingSource 또는 ServiceAppointment.GroupAppointmentAccessType. (필드명에 공백 포함 — PDF 원문 그대로) |
| Usage Rate Unit [sic] | picklist | Create, Filter, Group, Restricted picklist, Sort | Usage Rate Field의 rate를 정의. 값: DAYS. (필드명에 공백 포함 — PDF 원문 그대로) |

> 필드 총 11개.

**Usage:** dispatched 상태의 서비스 약속에 대한 필터 규칙을 만들려면 CriteriaField를 ServiceAppointment.Status로, Value를 Dispatched로 설정한다. 그런 다음 RecordsetFilterCriteria 레코드의 ID를 RecordsetFilterCriteriaId에 추가해 이 규칙을 shift용 filter criteria와 연결한다.

**Associated Objects:** PDF에 이 객체의 Associated Objects 섹션이 없다 — 본문은 Usage 이후 바로 다음 객체 헤더로 이어진다.

---

## 3. RecordsetFltrCritMonitor

자산 속성(asset attribute)의 값이 recordset filter criteria(RFC)의 임계값(threshold) 이내인지를 **모니터**한다. 한 Asset에 대해 하나 이상의 RFC를 모니터할 수 있다. v57.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields (7):**

| Field | Type | Properties | Description |
|---|---|---|---|
| AssetId | reference | Create, Filter, Group, Sort, Update | RFC를 연결할 자산의 ID. 관계 필드. RelName: Asset; RelType: Lookup; Refers To: Asset. |
| Description | string | Create, Filter, Group, Nillable, Sort, Update | recordset filter criteria monitor와 연결된 RFC의 설명. |
| IsWithinThreshold | boolean | Defaulted on create, Filter, Group, Sort | 자산 속성의 값이 RFC의 임계값 이내인지 여부. 기본값 false. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | recordset filter criteria monitor의 이름. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 값이 마지막으로 referenced된 날짜. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 값이 마지막으로 view된 날짜. |
| RecordsetFilterCriteriaId | reference | Create, Filter, Group, Sort | recordset filter criteria의 ID. 관계 필드. RelName: RecordsetFilterCriteria; RelType: Lookup; Refers To: RecordsetFilterCriteria. |

> 필드 총 7개. 필드 순서는 PDF 원문 그대로(Name이 LastReferencedDate보다 앞 — 알파벳 순서가 아니라 PDF 원문 순서 유지). PDF에 Usage 섹션은 없다.

**Associated Objects:** (API 버전 미지정 시 이 객체와 동일 버전에서 사용 가능. 그 외에는 지정된 버전 이후 사용 가능.)
- `RecordsetFltrCritMonitorChangeEvent` — change event 사용 가능.
- `RecordsetFltrCritMonitorHistory` — 추적 필드의 history 사용 가능.

---

## 4. WorkCapacityAvailability

특정 시간과 서비스 영역(service territory)에 대한 **가용 작업 용량(available work capacity)**을 나타낸다. v59.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** PDF에 Special Access Rules 섹션 없음 — Supported Calls 다음 바로 Fields.

**Fields (9):**

| Field | Type | Properties | Description |
|---|---|---|---|
| AvailCapacityHours | double | Create, Filter, Nillable, Sort, Update | 사용자가 서비스 영역에 대해 정의한 시간 프레임의 가용 용량(시간 단위) 수. |
| AvailCapacityMinutes | double | Create, Filter, Nillable, Sort, Update | 사용자가 서비스 영역에 대해 정의한 시간 프레임의 가용 용량(분 단위) 수. |
| EndDate | date | Create, Filter, Group, Nillable, Sort, Update | 총 가용 용량의 종료 날짜. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드를 간접적으로(예: list view나 관련 레코드를 통해) 마지막으로 접근한 시각. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드/리스트뷰를 마지막으로 본 시각. 이 값이 null이고 LastReferenceDate [sic: "LastReferenceDate" — d 누락, 정식 필드는 LastReferencedDate]가 null이 아니면, 사용자가 이 레코드/리스트뷰에 간접적으로 접근한 것이다. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | 이 객체의 소유자 ID. Polymorphic. RelName: Owner; RelType: Lookup; Refers To: Group, User. |
| ServiceTerritoryId | reference | Create, Filter, Group, Nillable, Sort, Update | work capacity availability 계산의 서비스 영역 ID. 관계 필드. RelName: ServiceTerritory; RelType: Lookup; Refers To: ServiceTerritory. |
| StartDate | date | Create, Filter, Group, Nillable, Sort, Update | 총 가용 용량의 시작 날짜. |
| TimePeriod | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 사용자가 work capacity limit 생성 시 선택한 기간. 값은 WorkCapacityLimit 객체의 TimePeriod 필드에서 복사된다. 값: Day. 기본값 Day. |

> 필드 총 9개. PDF에 Usage 섹션은 없다.

**Associated Objects:** (API 버전 미지정 시 이 객체와 동일 버전에서 사용 가능. 그 외에는 지정된 버전 이후 사용 가능.)
- `WorkCapacityAvailabilityFeed` — feed tracking 사용 가능.
- `WorkCapacityAvailabilityShare` — sharing 사용 가능.

---

## 5. WorkCapacityLimit

특정 서비스 영역에서 워크스트림(workstream) 또는 전체 서비스 영역에 대해, 주어진 기간의 **용량 한도(capacity limit)**를 나타낸다. v59.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** PDF에 Special Access Rules 섹션 없음.

**Fields (24):**

| Field | Type | Properties | Description |
|---|---|---|---|
| CapacityLimitRelaxation | string | Create, Filter, Group, Nillable, Sort, Update | Field Service Settings에서 limit override policy가 limit별로 설정된 경우, 이 limit의 override policy를 결정하는 relaxation 동작을 정의. limit override policy가 limit별로 설정되지 않았으면 이 값은 무시된다. 유효 문자열: Empty value - no limit override; 0 - 서비스 당일 자정에 limit override 시작; Positive integer - 자정 이후 이 시간(hours) 수만큼 지나 limit override 시작. the maximum [sic: 소문자 "the"] value is 23.; Negative integer - 자정 이전 이 시간 수만큼 앞서 limit override 시작. The maximum value is 336. |
| Description | string | Create, Filter, Group, Nillable, Sort, Update | work capacity limit의 설명. |
| EndDate | date | Create, Filter, Group, Nillable, Sort, Update | work capacity limit의 종료 날짜. EndDate가 설정되지 않으면 이 work capacity limit은 만료일이 없다. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | work capacity limit이 활성/비활성인지. 레코드 생성 시 먼저 저장한 다음 활성화한다. 활성 레코드의 필드는 업데이트할 수 없다. 기본값 false. |
| IsFriday | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 금요일에 제한이 적용되는지 여부. 기본값 false. |
| IsMonday | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 월요일에 제한이 적용되는지 여부. 기본값 false. |
| IsSaturday | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 토요일에 제한이 적용되는지 여부. 기본값 false. |
| IsSunday | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 일요일에 제한이 적용되는지 여부. 기본값 false. |
| IsSvcTerrOnlyLimit | boolean | Create, Defaulted on create, Filter, Group, Sort | 이 work capacity limit을 전체 서비스 영역에 적용. 기본값 false. |
| IsThursday | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 목요일에 제한이 적용되는지 여부. 기본값 false. |
| IsTuesday | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 화요일에 제한이 적용되는지 여부. 기본값 false. |
| IsWednesday | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 수요일에 제한이 적용되는지 여부. 기본값 false. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드를 간접적으로(예: list view나 관련 레코드를 통해) 마지막으로 접근한 시각. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드/리스트뷰를 마지막으로 본 시각. 이 값이 null이고 LastReferenceDate [sic: "LastReferenceDate" — d 누락]가 null이 아니면, 사용자가 이 레코드/리스트뷰에 간접적으로 접근한 것이다. |
| LimitationUnits | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | LimitationValue의 단위. 값: Hours, Percentage. 기본값 Hours. |
| LimitationValue | double | Create, Filter, Sort, Update | LimitationUnits가 Hours이면, LimitationValue는 특정 워크스트림에 대해 서비스 영역에서 스케줄될 수 있는 총 작업 용량의 시간(hours) 수를 나타내는 임계값이다. 일일 제한 시간 수를 정수(whole number)로 입력. LimitationUnits가 Percentage이면, 이 임계값은 특정 워크스트림에 대해 서비스 영역에서 스케줄될 수 있는 총 작업 용량의 백분율을 나타낸다. 일일 제한 백분율을 정수로 입력. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | work capacity limit 생성자의 ID. Polymorphic. RelName: Owner; RelType: Lookup; Refers To: Group, User. |
| ServiceTerritoryId | reference | Create, Filter, Group, Nillable, Sort, Update | limit이 정의된 work capacity 워크스트림의 서비스 영역 ID. 관계 필드. RelName: ServiceTerritory; RelType: Lookup; Refers To: ServiceTerritory. |
| StartDate | date | Create, Filter, Group, Sort, Update | Work Capacity Limit의 시작 날짜. |
| SvcApptField | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 워크스트림의 용량 한도를 정의하는 데 사용되는 작업별(work-specific) 기준. 첫 번째 work capacity limit 인스턴스가 생성될 때 조직에 대해 서비스 약속 필드가 설정된다. 값: 아래 SvcApptField enum 31값 참조. |
| SvcApptFieldValDplyNm | string | Create, Filter, Group, Nillable, Sort, Update | SvcApptFieldValue의 워크스트림 표시 이름. SvcApptField가 서비스 약속에 대한 lookup이면 SvcApptFieldValue는 ID이고 표시 이름이 사용자에게 그 값을 설명한다. |
| SvcApptFieldValue | string | Create, Filter, Group, Nillable, Sort, Update | SvcApptField의 값, 즉 용량 한도의 작업별 기준. |
| TimePeriod | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | 서비스 영역의 워크스트림에 대한 용량 제한을 정의하기 위한 기간(duration). 값: Day. 기본값 Day. |
| WorkCapacityLimitNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | 읽기 전용. 자동 채워지는 고유 식별 번호. |

> 필드 총 24개. PDF에 Usage 섹션은 없다.

**SvcApptField enum 전수 (31값):**

| # | 값 | label(있을 경우) |
|---|---|---|
| 1 | ServiceAppointment.AccountId | — |
| 2 | ServiceAppointment.ActualDuration | Actual duration (in minutes) |
| 3 | ServiceAppointment.Duration | Duration |
| 4 | ServiceAppointment.DurationInMinutes | — |
| 5 | ServiceAppointment.FSL__Appointment_Grade__ce [sic] | — (suffix "__ce" — 표준 커스텀 필드 suffix는 "__c". PDF 원문 그대로) |
| 6 | ServiceAppointment.FSL__Auto_Schedule__c | — |
| 7 | ServiceAppointment.FSL__Duration_In_Minutes__c | Scheduled duration |
| 8 | ServiceAppointment.FSL__Emergency__c | — |
| 9 | ServiceAppointment.FSL__GanttColor__c | — |
| 10 | ServiceAppointment.FSL__GanttLabel__c | — |
| 11 | ServiceAppointment.FSL__InJeopardyReason__c | — |
| 12 | ServiceAppointment.FSL__InJeopardy__c | — |
| 13 | ServiceAppointment.FSL__IsFillInCandidate__c | — |
| 14 | ServiceAppointment.FSL__IsMultiDay__c | — |
| 15 | ServiceAppointment.FSL__Last_Updated_Epoch__c | — |
| 16 | ServiceAppointment.FSL__MDS_Calculated_length__c | Multiday work calculated length |
| 17 | ServiceAppointment.FSL__Pinned__c | — |
| 18 | ServiceAppointment.FSL__Prevent_Geocoding_For_Chatter_Actions__c | — |
| 19 | ServiceAppointment.FSL__Related_Service__c | — |
| 20 | ServiceAppointment.FSL__Same_Day__c | — |
| 21 | ServiceAppointment.FSL__Same_Resource__c | — |
| 22 | ServiceAppointment.FSL__Schedule_Mode__c | — |
| 23 | ServiceAppointment.FSL__Schedule_over_lower_priority_appointment__c | — |
| 24 | ServiceAppointment.FSL__Scheduling_Policy_Used__c | — |
| 25 | ServiceAppointment.FSL__Time_Dependency__c | — |
| 26 | ServiceAppointment.FSL__UpdatedByOptimization__c | — |
| 27 | ServiceAppointment.FSL__Use_Async_Logic__c | — |
| 28 | ServiceAppointment.FSL__Virtual_Service_For_Chatter_Action__c | — |
| 29 | ServiceAppointment.IsOffsiteAppointment | — |
| 30 | ServiceAppointment.Subject | — |
| 31 | ServiceAppointment.WorkTypeId | Work Type ID |

**Associated Objects:** (API 버전 미지정 시 이 객체와 동일 버전에서 사용 가능. 그 외에는 지정된 버전 이후 사용 가능.)
- `WorkCapacityLimitChangeEvent` (v62.0) — change event 사용 가능.
- `WorkCapacityLimitFeed` — feed tracking 사용 가능.
- `WorkCapacityLimitHistory` — 추적 필드의 history 사용 가능.
- `WorkCapacityLimitShare` — sharing 사용 가능.

---

## 6. WorkCapacityUsage

특정 서비스 영역에서 워크스트림 또는 전체 서비스 영역에 대해, 주어진 기간의 **용량 사용량(capacity usage)**을 나타낸다. v59.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** PDF에 Special Access Rules 섹션 없음.

**Fields (23):**

| Field | Type | Properties | Description |
|---|---|---|---|
| AvailCapacityHours | double | Create, Defaulted on create, Filter, Nillable, Sort, Update | 같은 날짜의 서비스 영역에 대한 WorkCapacityAvailability 객체의 AvailCapacityHours에서 복사된 값. |
| CapacityLimitRelaxation | string | Create, Filter, Group, Nillable, Sort, Update | Field Service Settings에서 limit override policy가 limit별로 설정된 경우, 이 limit의 override policy를 결정하는 relaxation 동작을 정의. limit override policy가 limit별로 설정되지 않았으면 이 값은 무시된다. 유효 문자열: Empty value - no limit override; 0 - 서비스 당일 자정에 limit override 시작; Positive integer - 자정 이후 이 시간 수만큼 지나 limit override 시작. the maximum [sic: 소문자 "the"] value is 23.; Negative integer - 자정 이전 이 시간 수만큼 앞서 limit override 시작. The maximum value is 336. |
| ConsumptionToLimitRatio | double | Create, Defaulted on create, Filter, Nillable, Sort | (소비 시간(hours) / 한도 시간(hours)) * 100. 다음 예외에 유의. • 한도가 정의되지 않았으면(-1) ratio는 -1(소비가 0 이상이라도). • 소비가 0이고 한도가 0보다 큰 수이면, ration [sic: "ration" — ratio 오타]은 0. • 소비가 0이고 한도가 0이면, ration [sic]은 100%로 hard-coded. • 소비가 0보다 크고 한도가 0이면, ration [sic]은 100%보다 높은 결과를 얻기 위해 limit = 0.99인 것처럼 계산된다. |
| EndDate | date | Create, Filter, Group, Sort | 용량 사용량이 누적되는 기간의 종료 날짜. |
| IsSvcTerrOnlyLimit | boolean | Create, Defaulted on create, Filter, Group, Sort | 이 work capacity limit을 전체 서비스 영역에 적용. 기본값 false. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드를 간접적으로(예: list view나 관련 레코드를 통해) 마지막으로 접근한 시각. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드/리스트뷰를 마지막으로 본 시각. 이 값이 null이고 LastReferenceDate [sic: "LastReferenceDate" — d 누락]가 null이 아니면, 사용자가 이 레코드/리스트뷰에 간접적으로 접근한 것이다. |
| LimitationPercentage | double | Create, Defaulted on create, Filter, Nillable, Sort | LimitationUnits가 Percentage이면, 이 값은 WorkCapacityLimit 객체의 LimitationValue 필드에서 복사된다. |
| LimitationUnits | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort | 서비스 영역의 워크스트림에 대한 제한이 시간(hours) 단위인지, 특정 날짜에 해당 서비스 영역에서 제한이 존재하는 모든 워크스트림의 전체 가용 시간 대비 백분율인지를 정의. 값: Hours, Percentage. 기본값 Hours. |
| LimitationValue | double | Create, Filter, Sort | LimitationValue는 LimitationUnit에 따라 다르다. LimitationUnit이 Hours이면 값은 WorkCapacityLimit 객체의 LimitationValue에서 복사된다. LimitationUnit이 Percentage이면, 백분율은 WorkCapacityAvailability 객체의 가용량 대비로 계산된다. |
| OriginalLimit | double | Create, Defaulted on create, Filter, Nillable, Sort, Update | work capacity usage가 생성된 후 limit 값이 변경되면, 이 파라미터는 원래 값이다. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | 이 객체의 소유자 ID. Polymorphic. RelName: Owner; RelType: Lookup; Refers To: Group, User. |
| ServiceTerritoryId | reference | Create, Filter, Group, Nillable, Sort | usage가 누적되는 work capacity 워크스트림의 서비스 영역 ID. 관계 필드. RelName: ServiceTerritory; RelType: Lookup; Refers To: ServiceTerritory. |
| StartDate | date | Create, Filter, Group, Sort | 용량 사용량이 누적되는 기간의 시작 날짜. |
| SvcApptField | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort | 워크스트림의 용량 한도를 정의하는 데 사용되는 작업별 기준. 값: 아래 SvcApptField enum 31값 참조. |
| SvcApptFieldValDplyNm | string | Create, Filter, Group, Nillable, Sort, Update | SvcApptFieldValue의 워크스트림 표시 이름. |
| SvcApptFieldValue | string | Create, Filter, Group, Nillable, Sort | SvcApptField의 값, 즉 용량 한도의 작업별 기준. |
| TimeConsumedInHours | double | Create, Filter, Nillable, Sort | 정의된 기간 동안 서비스 영역의 워크스트림이 소비한 시간(hours). 이 값은 TimeConsumedInMinutes를 60으로 나눠 계산된다. |
| TimeConsumedInMinutes | double | Create, Filter, Sort | 정의된 기간 동안 서비스 영역의 워크스트림이 소비한 시간(분). |
| TimePeriod | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort | 서비스 영역의 워크스트림에 대한 용량 제한을 정의하기 위한 기간. 값: Day. 기본값 Day. |
| WcuUniqueField1 | string | Create, Filter, Group, idLookup, Nillable, Sort, Update | 읽기 전용. 자동 채워지는 고유 식별 번호. |
| WcuUniqueField2 | string | Create, Filter, Group, Nillable, Sort, Update | 읽기 전용. 자동 채워지는 고유 식별 번호. |
| WorkCapacityUsageNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | 읽기 전용. 자동 채워지는 고유 식별 번호. |

> 필드 총 23개. PDF에 Usage 섹션은 없다.

**SvcApptField enum 전수 (31값) — WorkCapacityLimit과 동일 목록:**

| # | 값 | label(있을 경우) |
|---|---|---|
| 1 | ServiceAppointment.AccountId | — |
| 2 | ServiceAppointment.ActualDuration | Actual duration (in minutes) |
| 3 | ServiceAppointment.Duration | Duration |
| 4 | ServiceAppointment.DurationInMinutes | — |
| 5 | ServiceAppointment.FSL__Appointment_Grade__ce [sic] | — (suffix "__ce", PDF 원문 그대로) |
| 6 | ServiceAppointment.FSL__Auto_Schedule__c | — |
| 7 | ServiceAppointment.FSL__Duration_In_Minutes__c | Scheduled duration |
| 8 | ServiceAppointment.FSL__Emergency__c | — |
| 9 | ServiceAppointment.FSL__GanttColor__c | — |
| 10 | ServiceAppointment.FSL__GanttLabel__c | — |
| 11 | ServiceAppointment.FSL__InJeopardyReason__c | — |
| 12 | ServiceAppointment.FSL__InJeopardy__c | — |
| 13 | ServiceAppointment.FSL__IsFillInCandidate__c | — |
| 14 | ServiceAppointment.FSL__IsMultiDay__c | — |
| 15 | ServiceAppointment.FSL__Last_Updated_Epoch__c | — |
| 16 | ServiceAppointment.FSL__MDS_Calculated_length__c | Multiday work calculated length |
| 17 | ServiceAppointment.FSL__Pinned__c | — |
| 18 | ServiceAppointment.FSL__Prevent_Geocoding_For_Chatter_Actions__c | — |
| 19 | ServiceAppointment.FSL__Related_Service__c | — |
| 20 | ServiceAppointment.FSL__Same_Day__c | — |
| 21 | ServiceAppointment.FSL__Same_Resource__c | — |
| 22 | ServiceAppointment.FSL__Schedule_Mode__c | — |
| 23 | ServiceAppointment.FSL__Schedule_over_lower_priority_appointment__c | — |
| 24 | ServiceAppointment.FSL__Scheduling_Policy_Used__c | — |
| 25 | ServiceAppointment.FSL__Time_Dependency__c | — |
| 26 | ServiceAppointment.FSL__UpdatedByOptimization__c | — |
| 27 | ServiceAppointment.FSL__Use_Async_Logic__c | — |
| 28 | ServiceAppointment.FSL__Virtual_Service_For_Chatter_Action__c | — |
| 29 | ServiceAppointment.IsOffsiteAppointment | — |
| 30 | ServiceAppointment.Subject | — |
| 31 | ServiceAppointment.WorkTypeId | Work Type ID |

**Associated Objects:** (API 버전 미지정 시 이 객체와 동일 버전에서 사용 가능. 그 외에는 지정된 버전 이후 사용 가능.)
- `WorkCapacityUsageFeed` — feed tracking 사용 가능.
- `WorkCapacityUsageShare` — sharing 사용 가능.

---

## 관련 노트

- [[Field Service 개요와 데이터 모델]] — Work Capacity·Recordset Filter의 데이터 모델상 위치와 전체 ER 다이어그램
- [[Field Service Objects]] — FSL 표준 객체(ServiceAppointment·WorkOrder·ServiceResource 등) 색인
- [[객체 레퍼런스 — Service Appointment·Resource]] — 서비스 약속·리소스 도메인. SvcApptField enum이 ServiceAppointment 필드를 참조하고, WorkCapacity 객체의 ServiceTerritoryId가 이 도메인과 교차
- [[객체 레퍼런스 — Service Territory·OperatingHours·Shift]] — 서비스 영역·Shift 도메인. RecordsetFilterCriteria의 SourceObject(Shift)·WorkCapacity 객체의 ServiceTerritory가 이 도메인과 교차
