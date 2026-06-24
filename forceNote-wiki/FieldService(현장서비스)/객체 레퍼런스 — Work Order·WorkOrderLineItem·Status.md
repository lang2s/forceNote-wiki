---
tags: [field-service, fsl, sobject, object-reference, work-order, work-order-line-item, work-order-status, 현장서비스, 작업지시, 작업지시라인아이템]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-24
aliases: [WorkOrder, WorkOrderLineItem, WorkOrderLineItemStatus, WorkOrderStatus, 작업지시, 작업지시 라인 아이템, 작업지시 상태, 작업지시 라인 아이템 상태, Work Order Status]
---

# 객체 레퍼런스 — Work Order·WorkOrderLineItem·Status

> Field Service의 핵심 작업 단위인 작업지시 클러스터 SOAP API 객체 4종 전수 레퍼런스 — WorkOrder(고객에게 수행할 현장 작업), WorkOrderLineItem(작업지시의 하위 작업), 그리고 두 상태 picklist 객체(WorkOrderStatus·WorkOrderLineItemStatus). 각 객체의 설명·Supported Calls·전 필드·Special Access Rules·Usage·Associated Objects를 담는다.

> 이 노트는 Field Service의 **작업지시(Work Order) 데이터 모델** 도메인 SOAP API 객체 정의를 다룬다. 전체 데이터 모델 개요와 객체 간 관계도(ER diagram)는 [[Field Service 개요와 데이터 모델]], 객체 카탈로그 요약은 [[Field Service Objects]]를 참조한다.
>
> 필드 표 형식: PDF는 2열(Field Name | Details)이고 Details 셀 안에 Type/Properties/Description/Relationship Name/Relationship Type/Refers To가 세로 나열돼 있다. 본 노트는 이를 4열(Field · Type · Properties · Description / Relationship)로 펼치고, 관계 필드는 Description 끝에 `Rel Name / Type / Refers To`를 표기했다. 코드 블록은 PDF 원문에 없으며(순수 표·picklist 레퍼런스), 본 노트의 enum 목록 예시 블록에만 마커를 단다.
>
> **[sic] 보존:** PDF 원문의 문맥·숫자 불일치를 의도적으로 그대로 둔 곳에 `[sic]`을 달았다(아래 "[sic] 보존 항목" 표 참조).

---

## [sic] 보존 항목 (PDF 원문 그대로 — 교정하지 않음)

| # | 위치 | 원문 그대로 | 비고 |
|---|---|---|---|
| 1 | WorkOrderLineItem.Duration | "If the **Duration** field on a **Work Order** is null, it adopts the duration value from the Work Type object…" | WorkOrderLineItem.Duration 설명인데 본문이 "on a Work Order"라고 적음(line item 설명 위치에서 Work Order를 언급). 원문 그대로 보존. |
| 2 | WorkOrderLineItemStatus.StatusCode / WorkOrderStatus.StatusCode | "The Status Category field has **seven** values which are identical to the default Status values." | 상위 WorkOrder/WOLI의 StatusCategory 설명은 "**eight** default values: seven values… and a None value"라고 한다. Status*Status 객체에서는 "seven"으로 표기 — 숫자 불일치, 원문 그대로 보존. |
| 3 | WorkOrderLineItemStatus.StatusCode / WorkOrderStatus.StatusCode | StatusCode(picklist) Description = "The status category that the value corresponds to." | picklist 타입인데 설명은 카테고리 매핑을 가리킨다. 원문 그대로 보존. |

---

## 객체 한눈에 (4)

| # | 객체 | 한 줄 | 필드 수(전수) | API 도입 |
|---|---|---|---|---|
| 1 | WorkOrder | 고객에게 수행할 현장 서비스 작업 | 66 | v36.0+ |
| 2 | WorkOrderLineItem | 작업지시의 하위 작업(subtask) | 54 | v36.0+ |
| 3 | WorkOrderLineItemStatus | 작업지시 라인 아이템의 가능한 상태 | 5 | (명시 없음) |
| 4 | WorkOrderStatus | 작업지시의 가능한 상태 | 5 | (명시 없음) |

> 필드 수는 본문 표에 옮긴 PDF 행 전수다. WorkOrderLineItemStatus·WorkOrderStatus는 PDF 원문에 "available in API version" 문장이 없어 도입 버전을 명시하지 않는다.

---

## 1. WorkOrder

field service에서 고객을 위해 수행할 **현장 서비스 작업(work)**을 나타낸다. 이 객체는 API version 36.0 이상에서 사용 가능하다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:**
- Work orders 또는 Field Service가 켜져 있어야 한다.
- 다음 필드는 field-level security 설정과 무관하게 편집할 수 없다:
  - `Discount`
  - `GrandTotal`
  - `IsGeneratedFromMaintenancePlan`
  - `RootWorkOrderId`

**Fields:** (header "Field Name")

| Field | Type | Properties | Description / Relationship |
|---|---|---|---|
| AccountId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 계정. relationship 필드. Rel Name: Account · Type: Lookup · Refers To: Account. |
| Address | address | Filter, Nillable | 작업지시가 완료되는 주소의 compound form. |
| AssetId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 자산. relationship 필드. Rel Name: Asset · Type: Lookup · Refers To: Asset. |
| AssetWarrantyId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 asset warranty term. v50.0+. |
| BusinessHoursId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 business hours. relationship 필드. Rel Name: BusinessHours · Type: Lookup · Refers To: BusinessHours. |
| CaseId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 케이스. relationship 필드. Rel Name: Case · Type: Lookup · Refers To: Case. |
| City | string | Create, Filter, Group, Nillable, Sort, Update | 작업지시가 완료되는 도시. 최대 길이 40자. |
| ContactId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 연락처. relationship 필드. Rel Name: Contact · Type: Lookup · Refers To: Contact. |
| Country | string | Create, Filter, Group, Nillable, Sort, Update | 작업지시가 완료되는 국가. 최대 길이 80자. |
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | multicurrency 활성 조직에서만. 조직이 허용하는 통화의 ISO 코드. UI label Currency ISO Code. |
| Description | textarea | Create, Nillable, Update | 작업지시의 설명. 상태를 Completed로 바꾸는 데 필요한 단계를 포함하는 것이 좋다. |
| Discount | percent | Filter, Nillable, Sort | 읽기 전용. 작업지시 내 모든 라인 아이템 할인의 가중 평균. 0~100 사이 양수. |
| Duration | double | Create, Filter, Nillable, Sort, Update | 작업지시 완료에 필요한 예상 시간. 단위는 Duration Type 필드로 지정. Work Order의 Duration 필드가 null이면, work type이 업데이트/삽입될 때 Work Type 객체의 duration 값을 채택한다. 작업지시 duration과 작업지시 라인 아이템 duration은 서로 독립적이다. 작업지시 duration이 라인 아이템 duration의 합을 자동으로 보이게 하려면, 작업지시의 Duration 필드를 커스텀 roll-up summary 필드로 대체한다. |
| DurationInMinutes | double | Filter, Nillable, Sort | 분 단위 예상 duration. 내부 사용 전용. |
| DurationType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | duration 단위: Minutes 또는 Hours. |
| EndDate | dateTime | Create, Filter, Nillable, Sort, Update | 작업지시가 완료된 날짜. Apex trigger나 quick action을 설정하지 않으면 공백. 예: StartDate 365일 후로 EndDate를 설정하는 quick action 생성. |
| EntitlementId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 entitlement. |
| GeocodeAccuracy | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 주소 geocode의 정확도 수준. geolocation compound 필드 세부는 Compound Field Considerations and Limitations 참조. |
| GrandTotal | currency | Filter, Nillable, Sort | 읽기 전용. 세금이 더해진 작업지시 총 가격. |
| IsClosed | boolean | Defaulted on create, Filter, Group, Sort | 작업지시가 닫힘(true)/열림(false)인지. |
| IsGeneratedFromMaintenancePlan | boolean | Defaulted on create, Filter, Group, Sort | (Read Only) 작업지시가 maintenance plan에서 생성(true)됐는지, 수동 생성(false)됐는지. |
| IsStopped | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | milestone이 일시정지(true)/카운트다운 중(false)인지. Entitlement Settings 페이지에서 "Enable stopped time and actual elapsed time"이 선택된 경우에만 사용 가능. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 작업지시가 마지막으로 수정된 날짜. UI label Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 작업지시가 마지막으로 view된 날짜. |
| Latitude | double | Create, Filter, Nillable, Sort, Update | Longitude와 함께 작업지시 완료 주소의 정밀 geolocation 지정. –90~90, 소수점 15자리까지. Compound Field Considerations and Limitations 참조. |
| LineItemCount | int | Filter, Group, Nillable, Sort | 작업지시 내 라인 아이템 수. UI label Line Items. |
| LocationId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 위치(예: 작업 현장). relationship 필드. Rel Name: Location · Type: Lookup · Refers To: Location. |
| Longitude | double | Create, Filter, Nillable, Sort, Update | Latitude와 함께 작업지시 완료 주소의 정밀 geolocation 지정. –180~180, 소수점 15자리까지. Compound Field Considerations and Limitations 참조. |
| MaintenancePlanId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 maintenance plan. maintenance plan에서 자동 생성되면 관련 plan이 자동으로 표시된다. |
| MaintenanceWorkRuleId | reference | Filter, Group, Nillable, Sort | 이 작업지시를 생성한 maintenance work rule의 ID. v50.0+. |
| MilestoneStatus | string | Group, Nillable, Sort | milestone의 상태. entitlement process가 작업지시에 적용된 경우 표시. |
| MinimumCrewSize | int | Create, Filter, Group, Nillable, Sort, Update | 작업지시에 배정된 crew의 최소 인원. Field Service managed package를 쓰지 않으면 규칙이 아니라 제안으로 동작. managed package를 쓰면 scheduling optimizer가 service crew 멤버 수를 세어 작업지시의 최소 crew 크기 요건에 맞는지 판단. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | 작업지시의 배정된 소유자. polymorphic relationship 필드. Rel Name: Owner · Type: Lookup · Refers To: Group, User. |
| ParentWorkOrderId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시의 부모 작업지시(있는 경우). 자식 작업지시 조회는 커스텀 리포트 생성. relationship 필드. Rel Name: ParentWorkOrder · Type: Lookup · Refers To: WorkOrder. |
| PostWorkSummary | textarea | Create, Nillable, Update | 완료된 작업지시의 요약. 수동 입력 또는 AI agent가 생성. |
| PostalCode | string | Create, Filter, Group, Nillable, Sort, Update | 작업지시가 완료되는 우편번호. 최대 길이 20자. |
| PreWorkBriefPromptTemplate | string | Create, Filter, Group, Nillable, Sort, Update | 활성화된 Pre-Work Brief prompt template의 ID. |
| Pricebook2Id | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 가격표. 가격표를 추가하면 라인 아이템에 서로 다른 price book entry를 배정할 수 있다. Product2가 활성일 때만 사용 가능. relationship 필드. Rel Name: Pricebook2 · Type: Lookup · Refers To: Pricebook2. |
| Priority | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 작업지시의 우선순위. picklist 값(커스터마이즈 가능): Low · Medium · High · Critical. |
| ProductServiceCampaignId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 product service campaign. |
| ProductServiceCampaignItemId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 product service campaign item. |
| RecommendedCrewSize | int | Create, Filter, Group, Nillable, Sort, Update | 작업지시에 배정된 service crew의 권장 인원. 예: Minimum Crew Size 2, Recommended Crew Size 3. |
| ReturnOrderId | reference | Filter, Group, Nillable, Sort | 작업지시와 연결된 return order. |
| ReturnOrderLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 return order line item. |
| RootWorkOrderId | reference | Filter, Group, Nillable, Sort | (Read only) 작업지시 계층의 최상위 작업지시. 계층 내 위치에 따라 root가 parent와 같을 수 있다. 자식 작업지시는 Child Work Orders 관련 목록에서 조회. relationship 필드. Rel Name: RootWorkOrder · Type: Lookup · Refers To: WorkOrder. |
| ServiceAppointmentCount | int | Filter, Group, Nillable, Sort | 작업지시의 service appointment 수. |
| ServiceContractId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 service contract. |
| ServiceDocumentTemplate | string | Create, Filter, Group, Nillable, Sort, Update | Document Builder 기능의 각 service document에 대한 template을 설정하는 template ID. |
| ServiceReportLanguage | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 작업지시·그 service appointment·라인 아이템과 그 service appointment에 대해 생성되는 모든 service report 및 미리보기에 쓰이는 언어. 공백이면 리포트 작성자의 Salesforce 기본 언어로 생성. 옵션으로 나타나려면 언어가 Translation Workbench에 설정됐거나 Salesforce의 18개 fully supported 언어 중 하나여야 한다. Rich text 필드와 service report 섹션 이름은 번역되지 않는다. |
| ServiceReportTemplateId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시가 사용하는 service report template. 지정하지 않으면 work type에 명시된 template 사용. work type에 template이 없거나 work type이 없으면 기본 service report template 사용. |
| ServiceTerritoryId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시가 진행되는 service territory. relationship 필드. Rel Name: ServiceTerritory · Type: Lookup · Refers To: ServiceTerritory. |
| SlaExitDate | dateTime | Filter, Nillable, Sort | 작업지시가 entitlement process를 빠져나가는 시각. |
| SlaStartDate | dateTime | Create, Filter, Nillable, Sort, Update | 작업지시가 entitlement process에 진입하는 시각. 작업지시 "Edit" 권한이 있으면 갱신/리셋 가능. |
| StartDate | dateTime | Create, Filter, Nillable, Sort, Update | 작업지시가 효력을 발생하는 날짜. Apex trigger나 quick action을 설정하지 않으면 공백. 예: Status가 In Progress로 바뀔 때 StartDate를 설정하는 quick action. |
| State | string | Create, Filter, Group, Nillable, Sort, Update | 작업지시가 완료되는 주(state). 최대 길이 80자. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 작업지시의 상태. picklist 값(커스터마이즈 가능): • New — 작업지시 생성됨, 아직 활동 없음. • In Progress — 작업 시작됨. • On Hold — 작업 일시정지. • Completed — 작업 완료. • Cannot Complete — 작업 완료 불가. • Closed — 모든 작업·관련 활동 완료. • Canceled — 작업 취소됨(보통 작업 시작 전). 작업지시 상태를 바꿔도 그 라인 아이템이나 연결된 service appointment의 상태는 영향받지 않는다. |
| StatusCategory | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | 각 Status 값이 속하는 카테고리. Status Category 필드는 **eight default values**를 가진다: 기본 Status 값과 동일한 **seven values**와, 카테고리 없는 상태용 None 값. 커스텀 Status 값을 만들면 어느 카테고리에 속하는지 지정해야 한다. 예: Waiting for Response 값을 만들면 On Hold 카테고리에 둘 수 있다. 어떤 프로세스가 StatusCategory를 참조하는지는 "How are Status Categories Used?" 참조. |
| StopStartDate | dateTime | Filter, Nillable, Sort | milestone이 일시정지된 시각. UI label Stopped Since. |
| Street | textarea | Create, Filter, Group, Nillable, Sort, Update | 작업지시가 완료되는 도로명 주소(번지·이름). |
| Subject | string | Create, Filter, Group, Nillable, Sort, Update | 작업지시의 제목. 완료할 작업의 성격·목적을 기술. 예: "Annual On-Site Well Maintenance." 최대 길이 255자. |
| Subtotal | currency | Filter, Nillable, Sort | 읽기 전용. 할인·세금 적용 전 라인 아이템 subtotal의 합. |
| SuggestedMaintenanceDate | date | Create, Filter, Group, Nillable, Sort, Update | 작업지시 완료 권장 날짜. maintenance plan에서 자동 생성되면 plan 설정 기반으로 자동 채워진다. |
| Tax | currency | Create, Filter, Nillable, Sort, Update | 작업지시의 총 세금. 통화 기호 유무 무관, 소수점 2자리까지. 예: 총 가격 $100인 작업지시에 $10을 입력하면 10% 세금 적용. |
| TotalPrice | currency | Filter, Nillable, Sort | 읽기 전용. 라인 아이템 가격의 합. 할인은 적용되나 세금은 미적용. |
| WorkOrderNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | 작업지시를 식별하는 8자리 자동 생성 번호. |
| WorkTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | 작업지시와 연결된 work type. work type을 선택하면 그 Duration·Duration Type·required skills를 자동 상속. work type의 Duration이 null이면 duration 값 입력. relationship 필드. Rel Name: WorkType · Type: Lookup · Refers To: WorkType. |

**WorkOrder 필드 수: 66**

WorkOrder/WorkOrderLineItem의 `Status` ↔ `StatusCategory` 기본 매핑(PDF 본문 picklist 값 정리):

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (PDF 산문 picklist 값을 표 형태로 정리)
Status (기본 7값)        StatusCategory (eight default values)
─────────────────       ──────────────────────────────────────
New                  →  New
In Progress          →  In Progress
On Hold              →  On Hold
Completed            →  Completed
Cannot Complete      →  Cannot Complete
Closed               →  Closed
Canceled             →  Canceled
(커스텀 Status 값)    →  None  (카테고리 미지정 상태용)
```

**Associated Objects:** (API version이 명시되지 않으면 이 객체와 같은 API version에서 사용 가능. 명시되면 해당 version 이상.)
- `WorkOrderChangeEvent` (v48.0) — change events.
- `WorkOrderFeed` — feed tracking.
- `WorkOrderHistory` — 추적 필드 히스토리.
- `WorkOrderOwnerSharingRule` — sharing rules.
- `WorkOrderShare` — sharing.

---

## 2. WorkOrderLineItem

field service에서 작업지시의 **하위 작업(subtask)**을 나타낸다. 이 객체는 API version 36.0 이상에서 사용 가능하다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**Special Access Rules:** Work orders 또는 Field Service가 켜져 있어야 한다.

**Fields:** (header "Field Name")

| Field | Type | Properties | Description / Relationship |
|---|---|---|---|
| Address | address | Filter, Nillable | 라인 아이템이 완료되는 주소의 compound form. |
| AssetId | reference | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템과 연결된 자산. 부모 작업지시에서 자동 상속되지 않는다. relationship 필드. Rel Name: Asset · Type: Lookup · Refers To: Asset. |
| AssetWarrantyId | reference | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템과 연결된 asset warranty term. v50.0+. |
| City | string | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템이 완료되는 도시. 최대 길이 40자. |
| Country | string | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템이 완료되는 국가. 최대 길이 80자. |
| CurrencyIsoCode | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | multicurrency 활성 조직에서만. 조직이 허용하는 통화의 ISO 코드. UI label Currency ISO Code. |
| Description | textarea | Create, Nillable, Update | 라인 아이템의 설명. 라인 아이템을 Completed로 표시하는 데 필요한 단계를 기술. |
| Discount | percent | Create, Filter, Nillable, Sort, Update | 라인 아이템에 적용할 할인 비율. 퍼센트 기호 유무 무관, 소수점 2자리까지. |
| Duration | double | Create, Filter, Nillable, Sort, Update | 라인 아이템 완료에 필요한 예상 시간. 단위는 Duration Type 필드로 지정. If the Duration field on a Work Order [sic] is null, it adopts the duration value from the Work Type object when the work type is updated or inserted. **Note:** 작업지시 duration과 작업지시 라인 아이템 duration은 서로 독립적이다. 작업지시 duration이 라인 아이템 duration의 합을 자동으로 보이게 하려면, 작업지시의 Duration 필드를 커스텀 roll-up summary 필드로 대체한다. |
| DurationInMinutes | double | Filter, Nillable, Sort | 분 단위 예상 duration. 내부 사용 전용. |
| DurationType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | duration 단위: Minutes 또는 Hours. |
| EndDate | dateTime | Create, Filter, Nillable, Sort, Update | 라인 아이템이 완료되는 날짜. Apex trigger나 quick action을 설정하지 않으면 공백. 예: StartDate 365일 후로 EndDate를 설정하는 quick action. |
| GeocodeAccuracy | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 위치의 지리 좌표가 물리 주소와 얼마나 일치하는지의 정확도 수준. 보통 geocoding 서비스가 위·경도 기반으로 제공. **Note:** API에서만 사용 가능. 가능 값: • Address • Block • City • County • ExtendedZip • NearAddress • Neighborhood • State • Street • Unknown • Zip. |
| IsClosed | boolean | Defaulted on create, Filter, Group, Sort | 라인 아이템이 닫혔는지. 라인 아이템 상태를 Closed로 바꾸면 UI에서 이 체크박스가 선택됨(IsClosed=true). **Tip:** 닫힌 vs 열린 라인 아이템 리포팅에 사용. |
| IsGeneratedFromMaintenancePlan | boolean | Defaulted on create, Filter, Group, Sort | 라인 아이템이 maintenance plan에서 생성됐는지 식별. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 라인 아이템이 마지막으로 수정된 날짜. UI label Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 라인 아이템이 마지막으로 view된 날짜. |
| Latitude | double | Create, Filter, Nillable, Sort, Update | Longitude와 함께 라인 아이템 완료 주소의 정밀 geolocation 지정. –90~90, 소수점 15자리까지. **Note:** API에서만 사용 가능. |
| LineItemNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | 라인 아이템을 식별하는 자동 생성 번호. 각 작업지시의 라인 아이템은 1부터 시작. |
| ListPrice | currency | Filter, Nillable, Sort | 라인 아이템(제품)의 가격(해당 price book entry 기준). price book entry가 미지정이면 list price는 0으로 기본 설정. |
| LocationId | reference | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템과 연결된 위치(예: 작업 현장). relationship 필드. Rel Name: Location · Type: Lookup · Refers To: Location. |
| Longitude | double | Create, Filter, Nillable, Sort, Update | Latitude와 함께 라인 아이템 완료 주소의 정밀 geolocation 지정. –180~180, 소수점 15자리까지. **Note:** API에서만 사용 가능. |
| MaintenancePlanId | reference | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템과 연결된 maintenance plan. |
| MaintenanceWorkRuleId | reference | Filter, Group, Nillable, Sort | 이 라인 아이템을 생성한 maintenance work rule의 ID. v50.0+. |
| MinimumCrewSize | int | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템에 배정된 crew의 최소 인원. managed package를 쓰지 않으면 규칙이 아니라 제안. managed package를 쓰면 scheduling optimizer가 service crew 멤버 수를 세어 라인 아이템의 최소 crew 크기 요건에 맞는지 판단. |
| OrderId | reference | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템과 연결된 주문. 예: 라인 아이템 완료 전 교체 부품 주문이 필요할 수 있다. relationship 필드. Rel Name: Order · Type: Lookup · Refers To: Order. |
| ParentWorkOrderLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템의 부모 라인 아이템(있는 경우). **Tip:** 자식 라인 아이템 조회는 커스텀 리포트 생성. relationship 필드. Rel Name: ParentWorkOrderLineItem · Type: Lookup · Refers To: WorkOrderLineItem. |
| PostalCode | string | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템이 완료되는 우편번호. 최대 길이 20자. |
| PricebookEntryId | reference | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템과 연결된 price book entry(제품). UI label Product. 이 필드의 lookup 검색은 작업지시의 가격표에 포함된 제품만 반환. relationship 필드. Rel Name: PricebookEntry · Type: Lookup · Refers To: PricebookEntry. |
| Priority | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 라인 아이템의 우선순위. picklist 값(커스터마이즈 가능): • Low • Medium • High • Critical. |
| Product2Id | reference | Create, Filter, Group, Nillable, Sort, Update | (Read only) price book entry와 연결된 제품. UI에서 사용 불가. 커스텀 코드·레이아웃에는 PricebookEntryId 필드 사용 권장. relationship 필드. Rel Name: Product2 · Type: Lookup · Refers To: Product2. |
| ProductServiceCampaignId | reference | Filter, Group, Nillable, Sort | 라인 아이템과 연결된 product service campaign. |
| ProductServiceCampaignItemId | reference | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템과 연결된 product service campaign item. |
| Quantity | double | Create, Filter, Nillable, Sort, Update | 연결된 작업지시에 포함된 라인 아이템 단위 수. |
| RecommendedCrewSize | int | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템에 배정된 service crew의 권장 인원. 예: Minimum Crew Size 2, Recommended Crew Size 3. |
| ReturnOrderId | reference | Filter, Group, Nillable, Sort | 라인 아이템과 연결된 return order. |
| ReturnOrderLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템과 연결된 return order line item. |
| RootWorkOrderLineItemId | reference | Filter, Group, Nillable, Sort | (Read only) 라인 아이템 계층의 최상위 라인 아이템. 계층 내 위치에 따라 root가 parent와 같을 수 있다. **Note:** 자식 라인 아이템은 Child Work Order Line Items 관련 목록에서 조회. relationship 필드. Rel Name: RootWorkOrderLineItem · Type: Lookup · Refers To: WorkOrderLineItem. |
| ServiceAppointmentCount | int | Filter, Group, Nillable, Sort | 라인 아이템의 service appointment 수. |
| ServiceDocumentTemplate | string | Create, Filter, Group, Nillable, Sort, Update | Document Builder 기능의 각 service document에 대한 template을 설정하는 template ID. |
| ServiceReportTemplateId | reference | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템이 사용하는 service report template. 지정하지 않으면 work type에 명시된 template 사용. work type에 template이 없거나 work type이 없으면 기본 service report template 사용. |
| ServiceTerritoryId | reference | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템이 완료되는 service territory. relationship 필드. Rel Name: ServiceTerritory · Type: Lookup · Refers To: ServiceTerritory. |
| StartDate | dateTime | Create, Filter, Nillable, Sort, Update | 라인 아이템이 효력을 발생하는 날짜. Apex trigger나 quick action을 설정하지 않으면 공백. 예: Status가 In Progress로 바뀔 때 StartDate를 설정하는 quick action. |
| State | string | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템이 완료되는 주(state). 최대 길이 80자. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 라인 아이템의 상태. picklist 값(커스터마이즈 가능): • New — 라인 아이템 생성됨, 아직 활동 없음. • In Progress — 작업 시작됨. • On Hold — 작업 일시정지. • Completed — 작업 완료. • Cannot Complete — 작업 완료 불가. • Closed — 모든 작업·관련 활동 완료. • Canceled — 작업 취소됨(보통 작업 시작 전). |
| StatusCategory | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | 각 Status 값이 속하는 카테고리. Status Category 필드는 **eight default values**를 가진다: 기본 Status 값과 동일한 **seven values**와, 카테고리 없는 상태용 None 값. 커스텀 Status 값을 만들면 어느 카테고리에 속하는지 지정해야 한다. 예: Waiting for Response 값을 만들면 On Hold 카테고리에 둘 수 있다. 어떤 프로세스가 StatusCategory를 참조하는지는 "How are Status Categories Used?" 참조. |
| Street | textarea | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템이 완료되는 도로명 주소(번지·이름). |
| Subject | string | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템을 기술하는 단어·구. |
| Subtotal | currency | Filter, Nillable, Sort | (Read only) 라인 아이템 단가 × 수량. |
| SuggestedMaintenanceDate | date | Create, Filter, Group, Nillable, Sort, Update | maintenance 작업 예정 날짜. |
| TotalPrice | currency | Filter, Nillable, Sort | 읽기 전용. 할인이 적용된 라인 아이템 subtotal. |
| UnitPrice | currency | Create, Filter, Nillable, Sort, Update | 초기에는 가격표의 list price이나 변경 가능. |
| WorkOrderId | reference | Create, Filter, Group, Sort | 라인 아이템의 부모 작업지시. 라인 아이템은 반드시 작업지시에 연결돼야 하므로 필수 필드. relationship 필드. Rel Name: WorkOrder · Type: Lookup · Refers To: WorkOrder. |
| WorkTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | 라인 아이템과 연결된 work type. work type을 선택하면 그 Duration·Duration Type·required skills를 자동 상속. work type의 Duration이 null이면 duration 값 입력. relationship 필드. Rel Name: WorkType · Type: Lookup · Refers To: WorkType. |

**WorkOrderLineItem 필드 수: 54**

**Usage:** 작업지시 라인 아이템은 작업지시의 자식 레코드이며, 작업지시상의 특정 하위 작업을 나타낸다.

예: 고객이 트럭을 구매했고, 그 트럭이 Salesforce 조직에서 asset으로 표현된다. 시간이 지나 양쪽 헤드라이트 전구 교체가 필요해졌다. 작업지시·라인 아이템으로 수리를 추적하는 한 방법:
1. asset 레코드 상세 페이지에서 "Replace Headlight Bulbs" 작업지시 생성.
2. 작업지시에 라인 아이템 3개 추가: "Replace Left Headlight Bulb", "Replace Right Headlight Bulb", "Test Headlights".
3. 큐(queue)를 통해 작업지시를 기술자에게 배정.
4. 기술자가 각 라인 아이템을 완료할 때마다 해당 아이템을 Completed로 표시.
5. 모든 라인 아이템 완료 시 기술자가 작업지시를 Completed로 표시.

**Associated Objects:** (API version 미명시면 이 객체와 같은 API version에서 사용 가능)
- `WorkOrderLineItemChangeEvent` (v48.0) — change events.
- `WorkOrderLineItemFeed` — feed tracking.
- `WorkOrderLineItemHistory` — 추적 필드 히스토리.

---

## 3. WorkOrderLineItemStatus

field service에서 작업지시 라인 아이템의 **가능한 상태(possible status)**를 나타낸다.
(PDF 원문에 "available in API version" 문장 없음 — 도입 버전 미명시.)

**Supported Calls:** `describeSObjects()`, `query()`, `retrieve()`

**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:** (header "Field Name")

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiName | string | Filter, Group, idLookup, Sort | 상태 값의 API 이름. |
| IsDefault | boolean | Defaulted on create, Filter, Group, Sort | 이 상태 값이 작업지시의 기본 상태인지. 하나의 상태 값만 기본이 될 수 있다. |
| MasterLabel | string | Filter, Group, Nillable, Sort | UI에 나타나는 picklist 값의 label. |
| SortOrder | int | Filter, Group, Nillable, Sort | UI 드롭다운 목록에서 값의 위치. |
| StatusCode | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The status category that the value corresponds to. The Status Category field has **seven** values which are identical to the default Status values. [sic — 상위 WOLI는 "eight"인데 여기서는 "seven"; picklist인데 설명은 카테고리 매핑] |

**WorkOrderLineItemStatus 필드 수: 5**

**Usage:** 작업지시 라인 아이템의 Status 필드는 다음 값을 기본 제공한다:
- New — 라인 아이템 생성됨, 아직 활동 없음.
- In Progress — 작업 시작됨.
- On Hold — 작업 일시정지.
- Completed — 작업 완료.
- Cannot Complete — 작업 완료 불가.
- Closed — 모든 작업·관련 활동 완료.
- Canceled — 작업 취소됨(보통 작업 시작 전).

WorkOrderLineItemStatus 객체는 Status 필드에 대응한다. Status 필드에 값을 추가하면(예: Canceled By Customer) work order line item status 레코드가 생성되며, 역도 성립한다.

> **Note (원문):** Work order line items also come with a StatusCategory field whose values are identical to the default Status values. If you create custom Status values, you must indicate which category it belongs to. For example, if you create a Customer Absent value, you may decide that it belongs in the Cannot Complete category. To learn which processes reference StatusCategory, see How are Status Categories Used?

(PDF 원문에 이 객체에 대한 Associated Objects 헤더 없음.)

---

## 4. WorkOrderStatus

field service에서 작업지시의 **가능한 상태(possible status)**를 나타낸다.
(PDF 원문에 "available in API version" 문장 없음 — 도입 버전 미명시.)

**Supported Calls:** `describeSObjects()`, `query()`, `retrieve()`

**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:** (header "Field Name")

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiName | string | Filter, Group, idLookup, Sort | 상태 값의 API 이름. |
| IsDefault | boolean | Defaulted on create, Filter, Group, Sort | 이 상태 값이 작업지시의 기본 상태인지. 하나의 상태 값만 기본이 될 수 있다. |
| MasterLabel | string | Filter, Group, Nillable, Sort | UI에 나타나는 picklist 값의 label. |
| SortOrder | int | Filter, Group, Nillable, Sort | UI 드롭다운 목록에서 값의 위치. |
| StatusCode | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The status category that the value corresponds to. The Status Category field has **seven** values which are identical to the default Status values. [sic — 상위 WorkOrder는 "eight"인데 여기서는 "seven"; picklist인데 설명은 카테고리 매핑] |

**WorkOrderStatus 필드 수: 5**

**Usage:** 작업지시의 Status 필드는 다음 값을 기본 제공한다:
- New — 작업지시 생성됨, 아직 활동 없음.
- In Progress — 작업 시작됨.
- On Hold — 작업 일시정지.
- Completed — 작업 완료.
- Cannot Complete — 작업 완료 불가.
- Closed — 모든 작업·관련 활동 완료.
- Canceled — 작업 취소됨(보통 작업 시작 전).

WorkOrderStatus 객체는 Status 필드에 대응한다. Status 필드에 값을 추가하면(예: Canceled By Customer) work order status 레코드가 생성되며, 역도 성립한다.

> **Note (원문):** Work orders also come with a StatusCategory field whose values are identical to the default Status values. If you create custom Status values, you must indicate which category it belongs to. For example, if you create a Customer Absent value, you may decide that it belongs in the Cannot Complete category. To learn which processes reference StatusCategory, see How are Status Categories Used?

(PDF 원문에 이 객체에 대한 Associated Objects 헤더 없음.)

---

## 관련 노트

- [[Field Service 개요와 데이터 모델]] — Core Data Model ER 다이어그램과 작업지시 클러스터의 데이터 모델상 위치
- [[Field Service Objects]] — FSL 표준 객체(ServiceAppointment·WorkOrder·ServiceResource 등) 색인
- [[객체 레퍼런스 — WorkPlan·WorkStep·WorkType]] — 작업 계획·단계·유형 도메인. WorkOrder/WOLI의 WorkTypeId가 참조하는 WorkType, 작업지시의 절차 분해를 다룸
- [[객체 레퍼런스 — Service Appointment·Resource]] — 약속·리소스 도메인. WorkOrder/WOLI에 연결된 ServiceAppointment와 ServiceTerritory가 이 도메인과 교차
- [[객체 레퍼런스 — Service Report·Layout·DigitalSignature]] — ServiceReport.ParentId가 WorkOrder/WorkOrderLineItem을 참조하는 서비스 리포트 도메인
- [[객체 레퍼런스 — Expense·TimeSheet]] — Expense.WorkOrderId·TimeSheetEntry.WorkOrderId가 참조하는 경비·작업시간 도메인
