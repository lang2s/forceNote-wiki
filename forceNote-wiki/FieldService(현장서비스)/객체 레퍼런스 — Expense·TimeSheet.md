---
tags: [field-service, fsl, sobject, object-reference, expense, timesheet, 현장서비스, 경비, 타임시트]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-24
aliases: [Expense, ExpenseReport, ExpenseReportEntry, TimeSheet, TimeSheetEntry, ExpenseType, Field Service Expense Objects, Field Service TimeSheet Objects, 경비, 경비 보고서, 경비 보고서 항목, 타임시트, 타임시트 항목, 경비 유형]
---

# 객체 레퍼런스 — Expense·TimeSheet

> Field Service의 **경비(Expense) 및 시간 추적(TimeSheet) 클러스터** SOAP API 객체 5종 전수 레퍼런스 — 작업지시에 연결된 경비(Expense)·경비 보고서(ExpenseReport)·보고서 항목(ExpenseReportEntry), 그리고 서비스 리소스의 근무 시간을 추적하는 타임시트(TimeSheet)·타임시트 항목(TimeSheetEntry). 각 객체의 설명·Supported Calls·전 필드·Special Access Rules·enum 값·Associated Objects를 담는다.

> 이 노트는 Field Service의 **경비·시간 추적(Expense & Time Tracking) 데이터 모델** 도메인 SOAP API 객체 정의를 다룬다. 전체 데이터 모델 개요와 객체 간 관계도(ER diagram)는 [[Field Service 개요와 데이터 모델]], 객체 카탈로그 요약은 [[Field Service Objects]]를 참조한다. 서비스 리소스 도메인은 [[객체 레퍼런스 — Service Resource·Crew·Skill]] 참조.

---

## 객체 한눈에 (5)

| # | 객체 | 한 줄 | 필드 수(전수) | API 도입 |
|---|---|---|---|---|
| 1 | Expense | 작업지시에 연결된 경비(공구·출장비 등) | 19 | v49.0+ |
| 2 | ExpenseReport | 경비들을 요약한 보고서 | 8 | v50.0+ |
| 3 | ExpenseReportEntry | 경비 보고서 내의 한 항목 | 10 | v50.0+ |
| 4 | TimeSheet | 서비스 리소스의 시간 스케줄 | 12 | v47.0+ |
| 5 | TimeSheetEntry | 서비스 리소스가 작업에 소비한 시간 구간 | 15 | v47.0+ |

> 필드 표 형식: PDF의 Field / Type / Properties / Description 4열을 그대로 옮겼다. picklist 필드의 enum 값은 Description 안에 PDF 원문 그대로 나열한 뒤, 객체별 "enum 값(전수)" 항목으로 다시 요약했다.
>
> **[sic] 보존:** PDF 원문의 의도적·비의도적 차이를 교정하지 않고 그대로 두며, 주의가 필요한 2곳에 `[sic]` 메모를 달았다(ExpenseReportEntry.ExpenseType의 `Create` 누락, TimeSheetEntry.TimeSheetEntryNumber의 `idLookup` 누락).

> 클러스터 관계(요약): Expense·TimeSheetEntry는 모두 작업 주문(WorkOrderId)에 연결되고, ExpenseReportEntry는 ExpenseId로 Expense를, TimeSheetEntry는 TimeSheetId로 TimeSheet를 참조한다. 아래는 객체 간 참조 필드를 활용한 SOQL 조회 예시다.

```sql
// 구조 예시 — 실제 동작 코드 아님 (필드명은 본문 표 기준)
// 한 작업 주문에 기록된 경비와 타임시트 항목을 함께 조회
SELECT Id, ExpenseNumber, ExpenseType, Amount, WorkOrderId
FROM   Expense
WHERE  WorkOrderId = :workOrderId

SELECT Id, Subject, Type, Status, DurationInMinutes, TimeSheetId, WorkOrderId
FROM   TimeSheetEntry
WHERE  WorkOrderId = :workOrderId
```

---

## 1. Expense

작업 주문(work order)에 연결된 **경비**를 나타낸다. 서비스 리소스 기술자가 공구·출장비 같은 경비를 기록할 수 있다. v49.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** (PDF에 명시 없음)

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| AccountId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the account associated with the linked work order. |
| Amount | currency | Create, Filter, Sort, Update | The amount of the expense. |
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Available only if the multicurrency feature is enabled. Contains the ISO code for any currency allowed by the organization. |
| Description | textarea | Create, Nillable, Update | A description for the expense. |
| Discount | percent | Create, Filter, Nillable, Sort, Update | The percentage deducted from the Subtotal price. Available in version 51.0 and later. |
| ExpenseEndDate | date | Create, Filter, Group, Nillable, Sort, Update | If the expense was incurred over multiple days, the Expense End Date is the last day that the expense covers. |
| ExpenseNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | The number that uniquely identifies the expense. |
| ExpenseStartDate | date | Create, Filter, Group, Nillable, Sort, Update | If the expense was incurred over multiple days, the Expense Start Date is the first day that the expense covers. |
| ExpenseType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The type of expense. Possible values are: • Billable • Non-Billable. The default value is Billable. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed a record related to this record. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed this record. If this value is null, this record might only have been referenced (LastReferencedDate) and not viewed. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The ID of the user who owns the expense record. |
| Quantity | double | Create, Filter, Nillable, Sort, Update | The number of items purchased in this record. Available in version 51.0 and later. |
| Subtotal | currency | Filter, Nillable, Sort | The subtotal price calculated as the product of Quantity and UnitPrice. Available in version 51.0 and later. This is a calculated field. |
| Title | string | Create, Filter, Group, Nillable, Sort, Update | A title that identifies the expense. This field is available in API version 50.0 and later. |
| TotalPrice | currency | Filter, Nillable, Sort | The total price of the transaction which is equal to the discounted subtotal: Subtotal - (Discount * Subtotal). Available in version 51.0 and later. This is a calculated field. |
| TransactionDate | date | Create, Filter, Group, Sort, Update | The day that the expense was incurred, or the payment date for the expense. |
| UnitPrice | currency | Create, Filter, Nillable, Sort, Update | The price of one item on the record. Available in version 51.0 and later. |
| WorkOrderId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the work order associated with the expense. |

**ExpenseType enum 값(전수):** `Billable`, `Non-Billable` (default = `Billable`)

**Associated Objects:** (별도 명시 없으면 이 객체와 동일 API 버전)
- `ExpenseChangeEvent` (v55.0) — change events.
- `ExpenseFeed` — feed tracking.
- `ExpenseHistory` — 추적 필드 히스토리.
- `ExpenseOwnerSharingRule` — sharing rules.
- `ExpenseShare` — sharing.

---

## 2. ExpenseReport

경비들을 요약한 **보고서**를 나타낸다. v50.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** (PDF에 명시 없음)

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Available only if the multicurrency feature is enabled. Contains the ISO code for any currency allowed by the organization. |
| Description | textarea | Create, Nillable, Update | A description for the expense report. |
| ExpenseReportNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-generated number identifying the expense report. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed a record related to this record. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed this record. If this value is null, this record might only have been referenced (LastReferencedDate) and not viewed. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The ID of the user who owns the expense report record. |
| Title | string | Create, Filter, Group, Nillable, Sort, Update | A title that identifies the expense report. |
| TotalExpenseAmount | currency | Filter, Nillable, Sort | The sum of all expense entries in the report. This is a calculated field. |

**Associated Objects:**
- `ExpenseReportFeed` — feed tracking.
- `ExpenseReportHistory` — 추적 필드 히스토리.
- `ExpenseReportShare` — sharing.

---

## 3. ExpenseReportEntry

경비 보고서 내의 한 **항목(entry)**을 나타낸다. v50.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** (PDF에 명시 없음)

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| Amount | currency | Filter, Nillable, Sort | The amount of the expense. |
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Available only if the multicurrency feature is enabled. Contains the ISO code for any currency allowed by the organization. |
| ExpenseId | reference | Create, Filter, Group, Sort, Update | The expense that corresponds to the expense report entry. |
| ExpenseReportEntryNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-generated number identifying the expense report entry. |
| ExpenseReportId | reference | Create, Filter, Group, Sort | The expense report that's associated with the expense report entry. |
| ExpenseType | picklist | Defaulted on create, Filter, Group, Nillable, Sort | The type of expense. Possible values are: • Billable • Non-Billable. The default value is Billable. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed a record related to this record. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp for when the current user last viewed this record. If this value is null, this record might only have been referenced (LastReferencedDate) and not viewed. |
| Title | string | Filter, Group, Nillable, Sort | A title that identifies the expense. |
| TransactionDate | date | Filter, Group, Nillable, Sort | The day that the expense was incurred, or the payment date for the expense. |

**ExpenseType enum 값(전수):** `Billable`, `Non-Billable` (default = `Billable`)

> **[sic]:** ExpenseReportEntry의 `ExpenseType` Properties에는 **`Create`가 없다**(`Defaulted on create, Filter, Group, Nillable, Sort`). 부모 Expense의 `ExpenseType`은 `Create`를 포함한다 — 차이가 의도된 것일 수 있으나 PDF 원문 그대로 보존한다.

**Associated Objects:**
- `ExpenseReportEntryFeed` — feed tracking.
- `ExpenseReportEntryHistory` — 추적 필드 히스토리.

---

## 4. TimeSheet

Field Service 또는 Workforce Engagement에서 서비스 리소스의 **시간 스케줄(time schedule)**을 나타낸다. 타임시트는 타임시트 항목들(time sheet entries)로 구성되며, 항목은 보통 이동·자산 수리 같은 개별 작업을 추적한다. v47.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service 또는 Workforce Engagement가 켜져 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Available only if the multicurrency feature is enabled. Contains the ISO code for any currency allowed by the organization. The label in the user interface is Currency ISO Code. |
| EndDate | date | Create, Filter, Group, Sort, Update | The last day the time sheet covers. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last interacted with this record, directly or indirectly. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, it's possible that the user only accessed this record or list view (LastReferencedDate), but not viewed it. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The owner of the time sheet. |
| ServiceResourceId | reference | Create, Filter, Group, Nillable, Sort, Update | The service resource whose time is being tracked with the time sheet. |
| StartDate | date | Create, Filter, Group, Sort, Update | The first day the time sheet covers. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The status of the time sheet. The picklist includes the following values, which can be customized: • New • Submitted • Approved |
| TimeSheetEntryCount | int | Filter, Group, Nillable, Sort | (Read Only) The number of related time sheet entries. |
| TimeSheetNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-generated number identifying the time sheet. |
| TotalDurationInHours | double | Filter, Nillable, Sort | Represents the sum total of the duration field of all the time sheet entries related to the time sheet object in hours. |
| TotalDurationInMinutes | int | Filter, Group, Nillable, Sort | Represents the sum total of the duration field of all the time sheet entries related to the time sheet object in minutes. |

**Status enum 값(전수, customizable):** `New`, `Submitted`, `Approved`

**Associated Objects:**
- `TimeSheetChangeEvent` (v48.0) — change events.
- `TimeSheetFeed` — feed tracking.
- `TimeSheetHistory` — 추적 필드 히스토리.
- `TimeSheetOwnerSharingRule` — sharing rules.
- `TimeSheetShare` — sharing.

---

## 5. TimeSheetEntry

서비스 리소스가 현장 서비스 작업에 소비한 **시간 구간**을 나타낸다. 타임시트는 타임시트 항목들로 구성되며, 항목은 보통 이동·자산 수리 같은 개별 작업을 추적한다. v47.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Available only if the multicurrency feature is enabled. Contains the ISO code for any currency allowed by the organization. The label in the user interface is Currency ISO Code. Time sheet entries inherit their time sheet's currency code. Updates to a time sheet's currency code aren't reflected in existing time sheet entries' currency code. |
| Description | textarea | Create, Nillable, Update | Notes on how the time was spent. For example, "This service took longer than normal because the machine was jammed." |
| DurationInMinutes | int | Filter, Group, Nillable, Sort | Minutes recorded on the time sheet entry. |
| EndTime | dateTime | Create, Filter, Nillable, Sort, Update | The date and time the activity finished. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last interacted with this record, directly or indirectly. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The timestamp when the current user last viewed this record or list view. If this value is null, it's possible that the user only accessed this record or list view (LastReferencedDate), but not viewed it. |
| LocationTimeZone | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Time zone of the location where the activity occurred. This field is available in API version 50.0 and later. |
| StartTime | dateTime | Create, Filter, Nillable, Sort, Update | The date and time the activity began. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The status of the time sheet entry. The picklist includes the following values, which can be customized: • New • Submitted • Approved |
| Subject | string | Create, Filter, Group, Nillable, Sort, Update | Activity performed; for example, repair, lunch, or travel. |
| TimeSheetEntryNumber | string | Autonumber, Defaulted on create, Filter, Sort | An auto-generated number identifying the time sheet entry. |
| TimeSheetId | reference | Create, Filter, Group, Sort | The time sheet associated with the time sheet entry. |
| Type | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The type of work performed. The picklist includes the following values, which can be customized: • Direct • Indirect |
| WorkOrderId | reference | Create, Filter, Group, Nillable, Sort, Update | The work order related to the time sheet entry. Work orders are searchable by their content. |
| WorkOrderLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | The work order line item related to the time sheet entry. Work order line items are searchable by their content. |

**Status enum 값(전수, customizable):** `New`, `Submitted`, `Approved`
**Type enum 값(전수, customizable):** `Direct`, `Indirect`

> **[sic]:** TimeSheetEntry의 `TimeSheetEntryNumber` Properties에는 **`idLookup`이 없다**(`Autonumber, Defaulted on create, Filter, Sort`). 다른 `*Number` autonumber 필드(`ExpenseNumber`, `TimeSheetNumber`, `ExpenseReportNumber` 등)는 `idLookup`을 포함한다 — PDF 원문 그대로 보존한다.

**Associated Objects:**
- `TimeSheetEntryChangeEvent` (v48.0) — change events.
- `TimeSheetEntryFeed` — feed tracking.
- `TimeSheetEntryHistory` — 추적 필드 히스토리.

---

## 관련 노트

- [[Field Service 개요와 데이터 모델]] — Expense·TimeSheet 객체의 데이터 모델상 위치와 작업 주문(Work Order) 도메인과의 연계
- [[Field Service Objects]] — FSL 표준 객체(ServiceAppointment·WorkOrder·ServiceResource 등) 색인
- [[객체 레퍼런스 — Service Resource·Crew·Skill]] — 리소스 연계. TimeSheet.ServiceResourceId가 참조하는 서비스 리소스 도메인
- [[객체 레퍼런스 — Work Order·WorkOrderLineItem·Status]] — Expense.WorkOrderId·TimeSheetEntry.WorkOrderId/WorkOrderLineItemId가 참조하는 작업 주문 도메인
