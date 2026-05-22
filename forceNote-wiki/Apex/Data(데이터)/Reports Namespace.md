---
tags: [apex, reports, analytics, report-api, async-report, report-metadata, fact-map]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-18
aliases: [Reports namespace, ReportManager, ReportMetadata, ReportResults, ReportFact, ReportFilter, runReport, runAsyncReport, FactMap]
---

# Reports Namespace

> Salesforce Reports & Dashboards REST API와 동일한 데이터에 Apex에서 접근하는 API. 보고서를 동기/비동기로 실행하고 FactMap으로 결과를 탐색.

---

## ReportManager 클래스 (정적 메서드)

보고서를 실행하거나 인스턴스를 조회하는 진입점. 모든 메서드는 `static`.

### 동기 실행 (`runReport`)

```apex
Id reportId = '00O...';

// 기본 실행 (요약 데이터만)
Reports.ReportResults results = Reports.ReportManager.runReport(reportId);

// 상세 행 포함
Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);

// 메타데이터(필터 등) 재정의
Reports.ReportMetadata metadata = Reports.ReportManager.describeReport(reportId).getReportMetadata();
metadata.setReportFilters(new List<Reports.ReportFilter>{
    new Reports.ReportFilter('CLOSE_DATE', 'greaterThan', '2025-01-01')
});
Reports.ReportResults results = Reports.ReportManager.runReport(reportId, metadata, true);
```

| 메서드 | 반환 타입 |
|---|---|
| `runReport(reportId)` | `ReportResults` |
| `runReport(reportId, includeDetails)` | `ReportResults` |
| `runReport(reportId, reportMetadata)` | `ReportResults` |
| `runReport(reportId, reportMetadata, includeDetails)` | `ReportResults` |

### 비동기 실행 (`runAsyncReport`)

```apex
// 비동기 실행 → 인스턴스 ID 저장
Reports.ReportInstance instance = Reports.ReportManager.runAsyncReport(reportId, true);
Id instanceId = instance.getId();

// 나중에 폴링하거나 완료 후 결과 조회
Reports.ReportInstance completed = Reports.ReportManager.getReportInstance(instanceId);
if (completed.getStatus() == 'Success') {
    Reports.ReportResults results = completed.getReportResults();
}
```

| 메서드 | 반환 타입 |
|---|---|
| `runAsyncReport(reportId)` | `ReportInstance` |
| `runAsyncReport(reportId, includeDetails)` | `ReportInstance` |
| `runAsyncReport(reportId, reportMetadata)` | `ReportInstance` |
| `runAsyncReport(reportId, reportMetadata, includeDetails)` | `ReportInstance` |

### 기타 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `describeReport(reportId)` | `ReportDescribeResult` | 보고서·보고서 타입·확장 메타데이터 조회 |
| `getReportInstance(instanceId)` | `ReportInstance` | 비동기 인스턴스 한 건 조회 |
| `getReportInstances(reportId)` | `List<ReportInstance>` | 보고서의 비동기 인스턴스 목록 |
| `getDatatypeFilterOperatorMap()` | `Map<String, List<FilterOperator>>` | 데이터 타입별 사용 가능한 필터 연산자 목록 |

---

## ReportInstance 클래스

`runAsyncReport`가 반환하는 비동기 실행 인스턴스.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getId()` | `Id` | 인스턴스 고유 ID |
| `getReportId()` | `Id` | 원본 보고서 ID |
| `getOwnerId()` | `Id` | 실행을 요청한 사용자 ID |
| `getStatus()` | `String` | 상태: `New` / `Running` / `Success` / `Error` |
| `getRequestDate()` | `Datetime` | 실행 요청 시각 (ISO-8601) |
| `getCompletionDate()` | `Datetime` | 실행 완료 시각 (성공 또는 오류 시) |
| `getReportResults()` | `ReportResults` | 비동기 결과 조회 (완료 후) |

```apex
// 상태별 처리 예
if (instance.getStatus() == 'Success') {
    Reports.ReportResults r = instance.getReportResults();
}
// 상태 값: New | Running | Success | Error
```

---

## ReportResults 클래스

`runReport` / `ReportInstance.getReportResults()`가 반환하는 결과 컨테이너.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getAllData()` | `Boolean` | `true`=전체 결과, `false`=UI와 동일한 행 수 |
| `getFactMap()` | `Map<String, ReportFact>` | 보고서 데이터 값 맵 (키 → ReportFact) |
| `getGroupingsDown()` | `Dimension` | 행 그룹핑 컬렉션 |
| `getGroupingsAcross()` | `Dimension` | 열 그룹핑 컬렉션 |
| `getHasDetailRows()` | `Boolean` | 상세 행 포함 여부 |
| `getReportMetadata()` | `ReportMetadata` | 보고서 메타데이터 |
| `getReportExtendedMetadata()` | `ReportExtendedMetadata` | 확장 메타데이터 (필드 타입·레이블) |

### FactMap 키 형식

FactMap의 키는 행 그룹핑 인덱스와 열 그룹핑 인덱스를 `!`로 구분한 문자열.

```apex
Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
Map<String, Reports.ReportFact> factMap = results.getFactMap();

// Tabular 보고서: 유일한 키는 "T!T" (전체 합계)
Reports.ReportFact grandTotal = factMap.get('T!T');
List<Reports.SummaryValue> totals = grandTotal.getAggregates();

// Summary 보고서 (행 그룹핑만): "0!T", "1!T", ..., "T!T"
// 0번째 그룹의 요약: "0!T"
Reports.ReportFactWithDetails row0 = (Reports.ReportFactWithDetails) factMap.get('0!T');
List<Reports.ReportDetailRow> detailRows = row0.getRows();

// Matrix 보고서 (행/열 그룹핑): "행인덱스!열인덱스"
// 예: "0!0", "0!T", "T!0", "T!T"
```

---

## ReportFact 계층

```
ReportFact (부모)
  ├─ ReportFactWithDetails  — includeDetails=true 일 때
  └─ ReportFactWithSummaries — includeDetails=false 일 때
```

### ReportFact (공통 메서드)

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getKey()` | `String` | FactMap 키 (이 ReportFact의 위치) |
| `getAggregates()` | `List<SummaryValue>` | 요약 데이터 (레코드 수 포함) |

### ReportFactWithDetails (상세 행 포함)

```apex
// includeDetails=true일 때 캐스팅 필요
Reports.ReportFactWithDetails detail =
    (Reports.ReportFactWithDetails) factMap.get('0!T');
List<Reports.ReportDetailRow> rows = detail.getRows();
```

| 메서드 | 반환 타입 | 추가 설명 |
|---|---|---|
| `getKey()` | `String` | 상속 |
| `getAggregates()` | `List<SummaryValue>` | 상속 |
| `getRows()` | `List<ReportDetailRow>` | 상세 행 목록 (열 순서는 메타데이터의 detailColumns 기준) |

### ReportFactWithSummaries (요약만)

| 메서드 | 반환 타입 |
|---|---|
| `getKey()` | `String` |
| `getAggregates()` | `List<SummaryValue>` |
| `toString()` | `String` |

---

## SummaryValue 클래스

FactMap의 각 집계 셀 데이터.

```apex
List<Reports.SummaryValue> aggs = fact.getAggregates();
for (Reports.SummaryValue sv : aggs) {
    System.debug('Label: ' + sv.getLabel());   // 포맷된 표시 값 (예: "$1,234.00")
    System.debug('Value: ' + sv.getValue());   // 숫자 원값 (Object, cast 필요)
}
```

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getLabel()` | `String` | 포맷된 표시 레이블 |
| `getValue()` | `Object` | 숫자 원값 (Decimal 등으로 캐스팅) |

---

## ReportMetadata 클래스

보고서 전체 메타데이터 — 타입, 포맷, 그룹핑, 필터 등. `describeReport()` 또는 `ReportResults.getReportMetadata()`로 획득.

### 조회 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getId()` | `Id` | 보고서 ID |
| `getName()` | `String` | 보고서 이름 |
| `getDeveloperName()` | `String` | API 이름 (예: `'Closed_Sales_This_Quarter'`) |
| `getDescription()` | `String` | 보고서 설명 |
| `getReportFormat()` | `ReportFormat` | `TABULAR` / `SUMMARY` / `MATRIX` |
| `getReportType()` | `ReportType` | 보고서 타입 (API명 + 표시명) |
| `getDetailColumns()` | `List<String>` | 상세 컬럼 API명 목록 |
| `getAggregates()` | `List<String>` | 요약 필드 식별자 목록 (`a!Amount`, `s!Amount`, `m!Amount`, `x!Amount`) |
| `getGroupingsDown()` | `List<GroupingInfo>` | 행 그룹핑 목록 |
| `getGroupingsAcross()` | `List<GroupingInfo>` | 열 그룹핑 목록 |
| `getReportFilters()` | `List<ReportFilter>` | 커스텀 필터 목록 |
| `getReportBooleanFilter()` | `String` | 필터 논리식 (예: `'1 AND (2 OR 3)'`) |
| `getStandardDateFilter()` | `StandardDateFilter` | 표준 날짜 필터 |
| `getStandardFilters()` | `List<StandardFilter>` | 표준 필터 목록 |
| `getScope()` | `String` | 범위 API명 |
| `getCrossFilters()` | `List<CrossFilter>` | 크로스 필터 목록 |
| `getBuckets()` | `List<BucketField>` | 버킷 필드 목록 |
| `getCustomSummaryFormula()` | `Map<String, ReportCsf>` | 커스텀 요약 수식 |
| `getHasDetailRows()` | `Boolean` | 상세 행 포함 여부 |
| `getHasRecordCount()` | `Boolean` | 전체 레코드 수 표시 여부 |
| `getShowGrandTotal()` | `Boolean` | 전체 합계 표시 여부 |
| `getShowSubtotals()` | `Boolean` | 소계 표시 여부 |
| `getSortBy()` | `List<SortColumn>` | 정렬 컬럼 (현재 1개만 지원) |
| `getTopRows()` | `TopRows` | 행 수 제한 필터 |
| `getDivision()` | `String` | 나눔 설정 |
| `getCurrencyCode()` | `String` | 멀티커런시 통화 코드 |
| `getHistoricalSnapshotDates()` | `List<String>` | 히스토리 스냅샷 날짜 목록 |

### Aggregate 식별자 형식

| 식별자 | 의미 |
|---|---|
| `a!Amount` | Amount 필드 평균 |
| `s!Amount` | Amount 필드 합계 |
| `m!Amount` | Amount 필드 최솟값 |
| `x!Amount` | Amount 필드 최댓값 |
| `s!<customFieldId>` | 커스텀 필드 합계 |

### 설정 메서드 (필터 재정의 후 runReport에 전달)

```apex
Reports.ReportMetadata md = Reports.ReportManager.describeReport(reportId).getReportMetadata();

// 커스텀 필터 추가
md.setReportFilters(new List<Reports.ReportFilter>{
    new Reports.ReportFilter('AMOUNT', 'greaterThan', '1000'),
    new Reports.ReportFilter('TYPE', 'equals', 'New Business')
});
md.setReportBooleanFilter('1 AND 2');

// 상세 컬럼 재정의
md.setDetailColumns(new List<String>{'OPPORTUNITY_NAME', 'AMOUNT', 'CLOSE_DATE'});

// 그룹핑 및 집계 재정의
md.setGroupingsDown(new List<Reports.GroupingInfo>{...});
md.setAggregates(new List<String>{'s!Amount', 'a!Amount'});

Reports.ReportResults results = Reports.ReportManager.runReport(reportId, md, true);
```

전체 setter 목록: `setDetailColumns` / `setAggregates` / `setGroupingsDown` / `setGroupingsAcross` / `setReportFilters` / `setReportBooleanFilter` / `setStandardDateFilter` / `setStandardFilters` / `setScope` / `setCrossFilters` / `setBuckets` / `setCustomSummaryFormula` / `setHasDetailRows` / `setHasRecordCount` / `setShowGrandTotal` / `setShowSubtotals` / `setSortBy` / `setTopRows` / `setCurrencyCode` / `setDivision` / `setHistoricalSnapshotDates` / `setDeveloperName` / `setName` / `setDescription` / `setId` / `setReportFormat` / `setReportType`

---

## ReportFilter 클래스

커스텀 필터 한 건.

```apex
// 생성자 1: column + operator + value
new Reports.ReportFilter('CLOSE_DATE', 'greaterThan', '2025-01-01')

// 생성자 2: + filterType
new Reports.ReportFilter('AMOUNT', 'greaterThan', '1000', Reports.ReportFilterType.fieldValue)

// 생성자 3: + entityName (크로스 필터에서 모호한 필드 구분)
new Reports.ReportFilter('AMOUNT', 'greaterThan', '1000',
    Reports.ReportFilterType.fieldValue, 'Opportunity')
```

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getColumn()` / `setColumn(col)` | `String` | 필터 대상 필드 API명 |
| `getOperator()` / `setOperator(op)` | `String` | 필터 연산자 API명 |
| `getValue()` / `setValue(val)` | `String` | 필터 값 |
| `getFilterType()` / `setFilterType(type)` | `String` | 필터 타입 (`ReportFilterType`) |
| `getEntityName()` / `setEntityName(name)` | `String` | 엔티티명 (크로스 필터용) |

### ReportFilterType Enum

| 값 | 설명 |
|---|---|
| `fieldValue` | 필드 대 값 필터 |
| `fieldToField` | 필드 대 필드 필터 |

---

## BucketField 클래스

보고서의 버킷 필드 정보.

```apex
// 생성자 (전체 파라미터)
new Reports.BucketField(
    Reports.BucketType.NUMBER,   // bucketType
    'revenue_bucket',            // developerName (주의: 오타 'devloperName'이 공식 API)
    'Revenue Bucket',            // label
    true,                        // nullTreatedAsZero
    'Other',                     // otherBucketLabel (PICKLIST 타입)
    'AnnualRevenue',             // sourceColumnName
    new List<Reports.BucketFieldValue>{...} // values
)
```

### BucketType Enum

| 값 | 설명 |
|---|---|
| `NUMBER` | 숫자 범위 버킷 |
| `PICKLIST` | 선택 목록 값 버킷 |
| `TEXT` | 문자열 버킷 |

### BucketField 메서드

| 메서드 | 반환 타입 |
|---|---|
| `getBucketType()` / `setBucketType(type)` | `BucketType` |
| `getDevloperName()` / `setDevloperName(name)` | `String` |
| `getLabel()` / `setLabel(label)` | `String` |
| `getNullTreatedAsZero()` / `setNullTreatedAsZero(bool)` | `Boolean` |
| `getOtherBucketLabel()` / `setOtherBucketLabel(label)` | `String` |
| `getSourceColumnName()` / `setSourceColumnName(name)` | `String` |
| `getValues()` / `setValues(values)` | `List<BucketFieldValue>` |

> **주의**: Salesforce 공식 API에서 `developerName`이 `devloperName`(오타)으로 되어 있음.

---

## BucketFieldValue 클래스

버킷 카테고리 하나의 값 범위 또는 항목.

```apex
// NUMBER 타입: 상한값 지정
new Reports.BucketFieldValue('Low', null, 1000.0)

// PICKLIST/TEXT 타입: 포함할 원본 값 목록
new Reports.BucketFieldValue('Enterprise', new List<String>{'Enterprise', 'Strategic'}, null)
```

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getLabel()` / `setLabel(label)` | `String` | 버킷 카테고리 표시명 |
| `getRangeUpperBound()` / `setRangeUpperBound(bound)` | `Double` | NUMBER 타입 상한 (초과 미포함) |
| `getSourceDimensionValues()` / `setSourceDimensionValues(vals)` | `List<String>` | PICKLIST/TEXT 타입 원본 값 목록 |

---

## CrossFilter 클래스

관련 오브젝트 기반 필터.

```apex
// 생성자
new Reports.CrossFilter(
    new List<Reports.ReportFilter>{...}, // criteria (relatedEntity에 대한 필터)
    true,                                // includesObject (관계 있음=true)
    'AccountId',                         // primaryEntityField
    'Opportunity',                       // relatedEntity
    'AccountId'                          // relatedEntityJoinField
)
```

| 메서드 | 반환 타입 |
|---|---|
| `getCriteria()` / `setCriteria(criteria)` | `List<ReportFilter>` |
| `getIncludesObject()` / `setIncludesObject(bool)` | `Boolean` |
| `getPrimaryEntityField()` / `setPrimaryEntityField(field)` | `String` |
| `getRelatedEntity()` / `setRelatedEntity(entity)` | `String` |
| `getRelatedEntityJoinField()` / `setRelatedEntityJoinField(field)` | `String` |

---

## 주요 Enum 목록

### ReportFormat

| 값 | 설명 |
|---|---|
| `TABULAR` | 목록형 |
| `SUMMARY` | 요약형 (행 그룹핑) |
| `MATRIX` | 행렬형 (행+열 그룹핑) |

### ColumnDataType

`BOOLEAN_DATA` / `COMBOBOX_DATA` / `CURRENCY_DATA` / `DATE_DATA` / `DATETIME_DATA` / `DOUBLE_DATA` / `EMAIL_DATA` / `ID_DATA` / `INT_DATA` / `MULTIPICKLIST_DATA` / `PERCENT_DATA` / `PHONE_DATA` / `PICKLIST_DATA` / `REFERENCE_DATA` / `STRING_DATA` / `TEXTAREA_DATA` / `TIME_DATA` / `URL_DATA`

### ColumnSortOrder

| 값 |
|---|
| `ASCENDING` |
| `DESCENDING` |

### DateGranularity

`DAY` / `DAY_IN_MONTH` / `FISCAL_PERIOD` 등 날짜 그룹핑 단위

---

## AggregateColumn 클래스

요약 필드 (Record Count, Sum, Average, Max, Min, 커스텀 수식) 메타데이터.

| 메서드 | 반환 타입 |
|---|---|
| `getName()` | `String` — 필드 API명 |
| `getLabel()` | `String` — 로컬라이즈 표시명 |
| `getDataType()` | `ColumnDataType` |
| `getAcrossGroupingContext()` | `String` — 열 그룹핑 컨텍스트 |
| `getDownGroupingContext()` | `String` — 행 그룹핑 컨텍스트 |

---

## 전체 클래스 목록 (참조)

| 클래스 | 역할 |
|---|---|
| `ReportManager` | 실행·조회 진입점 (static) |
| `ReportDescribeResult` | describeReport 결과 |
| `ReportInstance` | 비동기 실행 인스턴스 |
| `ReportResults` | 실행 결과 컨테이너 |
| `ReportMetadata` | 보고서 메타데이터 |
| `ReportExtendedMetadata` | 확장 메타데이터 (컬럼·그룹·집계 타입·레이블) |
| `ReportFact` | FactMap 값 (부모) |
| `ReportFactWithDetails` | 상세 행 포함 FactMap |
| `ReportFactWithSummaries` | 요약만 있는 FactMap |
| `SummaryValue` | 집계 셀 값 |
| `ReportDetailRow` | 상세 행 한 건 |
| `ReportDataCell` | 상세 행 내 셀 하나 |
| `ReportFilter` | 커스텀 필터 |
| `BucketField` | 버킷 필드 |
| `BucketFieldValue` | 버킷 카테고리 값 |
| `CrossFilter` | 크로스 필터 |
| `GroupingInfo` | 그룹핑 설정 |
| `Dimension` | 그룹핑 결과 컨테이너 |
| `GroupingValue` | 그룹핑 값 |
| `AggregateColumn` | 집계 컬럼 메타데이터 |
| `DetailColumn` | 상세 컬럼 메타데이터 |
| `GroupingColumn` | 그룹핑 컬럼 메타데이터 |
| `ReportType` | 보고서 타입 |
| `ReportTypeMetadata` | 보고서 타입 메타데이터 |
| `ReportTypeColumn` | 보고서 타입 컬럼 |
| `ReportTypeColumnCategory` | 컬럼 카테고리 |
| `StandardDateFilter` | 표준 날짜 필터 |
| `StandardDateFilterDuration` | 날짜 필터 기간 |
| `StandardDateFilterDurationGroup` | 날짜 필터 기간 그룹 |
| `StandardFilter` | 표준 필터 |
| `StandardFilterInfo` | 표준 필터 정보 (추상) |
| `StandardFilterInfoPicklist` | 표준 필터 선택 목록 |
| `ReportCsf` | 커스텀 요약 수식 |
| `ReportCurrency` | 통화 정보 |
| `ReportDivisionInfo` | 나눔 정보 |
| `ReportScopeInfo` | 범위 옵션 정보 |
| `ReportScopeValue` | 범위 값 |
| `SortColumn` | 정렬 컬럼 |
| `TopRows` | 행 수 제한 필터 |
| `FilterOperator` | 필터 연산자 |
| `FilterValue` | 필터 값 |
| `EvaluatedCondition` | 알림 조건 평가 결과 |
| `ThresholdInformation` | 알림 임계값 정보 |
| `NotificationAction` | 알림 액션 인터페이스 |
| `NotificationActionContext` | 알림 컨텍스트 |

---

## AggregateColumn

> 집계 컬럼(Record Count, Sum, Average, Max, Min, CSF)의 이름·레이블·타입·그룹핑 컨텍스트를 반환한다.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getName()` | `String` | 집계 필드 API명 |
| `getLabel()` | `String` | 표시명 |
| `getDataType()` | `Reports.ColumnDataType` | 데이터 타입 |
| `getAcrossGroupingContext()` | `String` | 컬럼 그룹핑 컨텍스트 |
| `getDownGroupingContext()` | `String` | 행 그룹핑 컨텍스트 |

```apex
// 구조 예시 — ReportExtendedMetadata에서 취득
Map<String, Reports.AggregateColumn> aggCols = extMeta.getAggregateColumnInfo();
Reports.AggregateColumn col = aggCols.get('s!Amount');
System.debug(col.getName() + ' ' + col.getDataType());
```

---

## DetailColumn

> 상세 데이터 필드의 API명·레이블·타입을 반환하는 읽기 전용 클래스.

| 메서드 | 반환 타입 |
|---|---|
| `getName()` | `String` |
| `getLabel()` | `String` |
| `getDataType()` | `Reports.ColumnDataType` |

---

## GroupingColumn

> 컬럼 그룹핑에 사용되는 필드의 메타데이터. `GroupingInfo`보다 기본 정보만 제공.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getName()` | `String` | API명 |
| `getLabel()` | `String` | 표시명 |
| `getDataType()` | `Reports.ColumnDataType` | 데이터 타입 |
| `getGroupingLevel()` | `Integer` | 그룹핑 레벨 (Summary: 0/1/2, Matrix: 0/1) |

---

## GroupingInfo

> 행/열 그룹핑에 사용되는 필드의 정렬·날짜 단위 설명. `GroupingColumn`의 상위 정보 클래스.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getName()` | `String` | API명 |
| `getSortOrder()` | `Reports.ColumnSortOrder` | ASCENDING / DESCENDING |
| `getDateGranularity()` | `Reports.DateGranularity` | 날짜 그룹핑 단위 |
| `getSortAggregate()` | `String` | 그룹핑 내 정렬에 사용되는 집계 필드명 (없으면 null) |

---

## GroupingValue

> FactMap 탐색 시 행/열 그룹핑의 키·레이블·값 정보.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getGroupings()` | `List<Reports.GroupingValue>` | 2·3단계 하위 그룹핑 목록 |
| `getKey()` | `String` | FactMap에서 데이터를 인덱싱하는 고유 식별자 |
| `getLabel()` | `String` | 표시명 (날짜 필드 → 로컬라이즈된 날짜) |
| `getValue()` | `Object` | 그룹핑 값 (통화: amount+currency, 픽리스트: API명, ID: API명) |

```apex
Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
for (Reports.GroupingValue gv : results.getGroupingsDown().getGroupings()) {
    System.debug('Key: ' + gv.getKey() + '  Label: ' + gv.getLabel());
}
```

---

## Dimension

> 행/열 그룹핑 결과 컨테이너. `getGroupingsDown()`·`getGroupingsAcross()`가 반환한다.

| 메서드 | 반환 타입 |
|---|---|
| `getGroupings()` | `List<Reports.GroupingValue>` |

---

## ReportExtendedMetadata

> 집계·상세·그룹핑 컬럼의 상세 메타데이터 맵을 반환한다.

| 메서드 | 반환 타입 |
|---|---|
| `getAggregateColumnInfo()` | `Map<String, Reports.AggregateColumn>` |
| `getDetailColumnInfo()` | `Map<String, Reports.DetailColumn>` |
| `getGroupingColumnInfo()` | `Map<String, Reports.GroupingColumn>` |

```apex
Reports.ReportDescribeResult desc = Reports.ReportManager.describeReport(reportId);
Reports.ReportExtendedMetadata extMeta = desc.getReportExtendedMetadata();
Map<String, Reports.DetailColumn> detailCols = extMeta.getDetailColumnInfo();
```

---

## ReportDescribeResult

> 보고서·보고서 타입·확장 메타데이터를 담는 describe 결과 클래스.

| 메서드 | 반환 타입 |
|---|---|
| `getReportExtendedMetadata()` | `Reports.ReportExtendedMetadata` |
| `getReportMetadata()` | `Reports.ReportMetadata` |
| `getReportTypeMetadata()` | `Reports.ReportTypeMetadata` |

```apex
Reports.ReportDescribeResult descResult = Reports.ReportManager.describeReport(reportId);
Reports.ReportMetadata meta = descResult.getReportMetadata();
```

---

## ReportDetailRow / ReportDataCell

> 상세 행과 셀 하나의 데이터를 담는다. `includeDetails=true` 일 때 사용 가능.

**ReportDetailRow**

| 메서드 | 반환 타입 |
|---|---|
| `getDataCells()` | `List<Reports.ReportDataCell>` |

**ReportDataCell**

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getLabel()` | `String` | 로컬라이즈된 표시 값 |
| `getValue()` | `Object` | 실제 값 |

```apex
Reports.ReportFactWithDetails fact =
    (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');
for (Reports.ReportDetailRow row : fact.getRows()) {
    for (Reports.ReportDataCell cell : row.getDataCells()) {
        System.debug(cell.getLabel() + ' → ' + cell.getValue());
    }
}
```

---

## ReportFact / ReportFactWithDetails / ReportFactWithSummaries

> FactMap 진입점. `includeDetails` 값에 따라 하위 클래스로 분기.

**ReportFact** (부모)

| 메서드 | 반환 타입 |
|---|---|
| `getAggregates()` | `List<Reports.SummaryValue>` |
| `getKey()` | `String` |

**ReportFactWithDetails** (includeDetails=true)

| 추가 메서드 | 반환 타입 |
|---|---|
| `getRows()` | `List<Reports.ReportDetailRow>` |

**ReportFactWithSummaries** (includeDetails=false)

| 추가 메서드 | 반환 타입 |
|---|---|
| `toString()` | `String` |

---

## ReportType

> 보고서 타입의 API명과 표시명.

| 메서드 | 반환 타입 |
|---|---|
| `getLabel()` | `String` |
| `getType()` | `String` |

---

## ReportTypeColumn

> 보고서 타입 내 개별 필드의 상세 메타데이터.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getDataType()` | `Reports.ColumnDataType` | 필드 데이터 타입 |
| `getFilterValues()` | `List<Reports.FilterValue>` | picklist·boolean 타입의 필터 가능 값 목록 |
| `getFilterable()` | `Boolean` | 필터 가능 여부 (Encrypted Text → false) |
| `getLabel()` | `String` | 표시명 |
| `getName()` | `String` | API명 |

---

## ReportTypeColumnCategory

> 보고서 타입의 섹션(카테고리)별 필드 묶음.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getColumns()` | `Map<String, Reports.ReportTypeColumn>` | 카테고리 내 필드 맵 |
| `getLabel()` | `String` | 카테고리 표시명 |

```apex
Reports.ReportTypeMetadata rtMeta = descResult.getReportTypeMetadata();
for (Reports.ReportTypeColumnCategory cat : rtMeta.getCategories()) {
    System.debug('Category: ' + cat.getLabel());
    for (String colName : cat.getColumns().keySet()) {
        System.debug('  Field: ' + colName);
    }
}
```

---

## ReportTypeMetadata

> 보고서 타입 전체 메타데이터 — 섹션별 필드, 범위, 날짜 필터, 표준 필터 정보.

| 메서드 | 반환 타입 |
|---|---|
| `getCategories()` | `List<Reports.ReportTypeColumnCategory>` |
| `getDivisionInfo()` | `Reports.ReportDivisionInfo` |
| `getScopeInfo()` | `Reports.ReportScopeInfo` |
| `getStandardDateFilterDurationGroups()` | `List<Reports.StandardDateFilterDurationGroup>` |
| `getStandardFilterInfos()` | `Map<String, Reports.StandardFilterInfo>` |

---

## SortColumn

> 보고서 정렬 컬럼 및 방향.

| 메서드 | 반환 타입 |
|---|---|
| `getSortColumn()` | `String` |
| `getSortOrder()` | `Reports.ColumnSortOrder` |
| `setSortColumn(sortColumn)` | `void` |
| `setSortOrder(SortOrder)` | `void` |

---

## StandardDateFilter

> 표준 날짜 필터 — 컬럼명, 기간 값, 시작/종료일 get·set.

| 메서드 | 반환 타입 |
|---|---|
| `getColumn()` | `String` |
| `getDurationValue()` | `String` |
| `getEndDate()` | `String` |
| `getStartDate()` | `String` |
| `setColumn(name)` | `void` |
| `setDurationValue(name)` | `void` |
| `setEndDate(date)` | `void` |
| `setStartDate(date)` | `void` |

---

## StandardDateFilterDuration

> 날짜 필터 기간 항목 하나 (예: `THIS_FISCAL_YEAR`).

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getEndDate()` | `String` | 종료일 |
| `getLabel()` | `String` | 표시명 (예: Current FY) |
| `getStartDate()` | `String` | 시작일 |
| `getValue()` | `String` | API 값 (예: THIS_FISCAL_YEAR) |

---

## StandardDateFilterDurationGroup

> 날짜 필터 기간을 그룹핑 (Calendar Year, Fiscal Quarter 등).

| 메서드 | 반환 타입 |
|---|---|
| `getLabel()` | `String` |
| `getStandardDateFilterDurations()` | `List<Reports.StandardDateFilterDuration>` |

---

## StandardFilter

> 보고서 표준 필터 (Show, Opportunity Status, Probability 등) get·set.

| 메서드 | 반환 타입 |
|---|---|
| `getName()` | `String` |
| `getValue()` | `String` |
| `setName(name)` | `void` |
| `setValue(value)` | `void` |

---

## StandardFilterInfo / StandardFilterInfoPicklist

**StandardFilterInfo** (추상 기반 클래스)

| 메서드 | 반환 타입 |
|---|---|
| `getLabel()` | `String` |
| `getType()` | `Reports.StandardFilterType` |

**StandardFilterInfoPicklist** (픽리스트 표준 필터 구체 클래스)

| 메서드 | 반환 타입 |
|---|---|
| `getDefaultValue()` | `String` |
| `getFilterValues()` | `List<Reports.FilterValue>` |
| `getLabel()` | `String` |
| `getType()` | `Reports.StandardFilterType` |

---

## FilterOperator / FilterValue

**FilterOperator** — 필터 연산자의 API명·표시명

| 메서드 | 반환 타입 |
|---|---|
| `getLabel()` | `String` |
| `getName()` | `String` |

**FilterValue** — 필터 값의 API명·표시명

| 메서드 | 반환 타입 |
|---|---|
| `getLabel()` | `String` |
| `getName()` | `String` |

---

## ReportScopeInfo / ReportScopeValue

**ReportScopeInfo** — 범위 옵션 기본값과 목록

| 메서드 | 반환 타입 |
|---|---|
| `getDefaultValue()` | `String` |
| `getValues()` | `List<Reports.ReportScopeValue>` |

**ReportScopeValue** — 개별 범위 값

| 메서드 | 반환 타입 |
|---|---|
| `getAllowsDivision()` | `Boolean` |
| `getLabel()` | `String` |
| `getValue()` | `String` |

---

## ReportDivisionInfo

> 보고서를 나눔(Division) 기준으로 필터링할 수 있는 경우에만 사용 가능.

| 메서드 | 반환 타입 |
|---|---|
| `getDefaultValue()` | `String` |
| `getValues()` | `List<Reports.FilterValue>` |

---

## ReportCurrency

> 멀티통화 조직에서 통화 금액과 코드를 반환.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getAmount()` | `Decimal` | 통화 금액 |
| `getCurrencyCode()` | `String` | ISO 4217 코드 (예: USD, EUR). 단일 통화 → null |

---

## ReportCsf (Custom Summary Formula)

> 커스텀 요약 수식의 모든 속성을 get·set.

**생성자:**
```apex
Reports.ReportCsf csf = new Reports.ReportCsf(
    label, description,
    Reports.FormulaType.CURRENCY,
    2,          // decimalPlaces
    null,       // downGroup
    Reports.CsfGroupType.GRAND_TOTAL,
    null,       // acrossGroup
    Reports.CsfGroupType.ALL,
    'Amount + 100'  // formula
);
```

| get / set 메서드 쌍 | 타입 |
|---|---|
| `getLabel()` / `setLabel(label)` | `String` |
| `getDescription()` / `setDescription(desc)` | `String` |
| `getFormula()` / `setFormula(formula)` | `String` |
| `getFormulaType()` / `setFormulaType(type)` | `Reports.FormulaType` |
| `getDecimalPlaces()` / `setDecimalPlaces(n)` | `Integer` |
| `getDownGroup()` / `setDownGroup(name)` | `String` |
| `getDownGroupType()` / `setDownGroupType(type)` | `Reports.CsfGroupType` |
| `getAcrossGroup()` / `setAcrossGroup(name)` | `String` |
| `getAcrossGroupType()` / `setAcrossGroupType(type)` | `Reports.CsfGroupType` |

---

## EvaluatedCondition / EvaluatedConditionOperator

> 보고서 알림 조건 평가 결과.

**생성자:**
```apex
new Reports.EvaluatedCondition(
    aggregateName, aggregateLabel,
    compareToValue,   // Double
    aggregateValue,   // Double
    displayCompareTo, displayValue,
    Reports.EvaluatedConditionOperator.GREATER_THAN
)
```

| 메서드 | 반환 타입 |
|---|---|
| `getAggregateName()` | `String` |
| `getAggregateLabel()` | `String` |
| `getCompareTo()` | `Double` |
| `getDisplayCompareTo()` | `String` |
| `getValue()` | `Double` |
| `getDisplayValue()` | `String` |
| `getOperator()` | `Reports.EvaluatedConditionOperator` |

**EvaluatedConditionOperator 열거값:** `EQUAL`, `GREATER_THAN`, `GREATER_THAN_EQUAL`, `LESS_THAN`, `LESS_THAN_EQUAL`, `NOT_EQUAL`

---

## NotificationAction / NotificationActionContext / ThresholdInformation

> 보고서 알림 조건 충족 시 실행되는 커스텀 Apex 인터페이스.

**NotificationAction 인터페이스:**

```apex
public class AlertOwners implements Reports.NotificationAction {
    public void execute(Reports.NotificationActionContext context) {
        Reports.ReportResults results =
            context.getReportInstance().getReportResults();
        for (Reports.GroupingValue g : results.getGroupingsDown().getGroupings()) {
            FeedItem t = new FeedItem();
            t.ParentId = (Id)g.getValue();
            t.Body = '보고서 확인 필요';
            insert t;
        }
    }
}
```

**NotificationActionContext 생성자:**
```apex
new Reports.NotificationActionContext(reportInstance, thresholdInformation)
```

| 메서드 | 반환 타입 |
|---|---|
| `getReportInstance()` | `Reports.ReportInstance` |
| `getThresholdInformation()` | `Reports.ThresholdInformation` |

**ThresholdInformation 생성자:**
```apex
new Reports.ThresholdInformation(List<Reports.EvaluatedCondition> conditions)
```

| 메서드 | 반환 타입 |
|---|---|
| `getEvaluatedConditions()` | `List<Reports.EvaluatedCondition>` |

---

## TopRows

> 행 수 제한 필터 — 상위 N개 행 반환.

**생성자:**
```apex
new Reports.TopRows(Integer rowLimit, Reports.ColumnSortOrder direction)
new Reports.TopRows()  // no-arg, then use setters
```

| get / set 메서드 쌍 | 타입 |
|---|---|
| `getRowLimit()` / `setRowLimit(n)` | `Integer` |
| `getDirection()` / `setDirection(order)` | `Reports.ColumnSortOrder` |

---

## 열거형 (Enums)

| Enum | 값 | 설명 |
|---|---|---|
| `CsfGroupType` | `ALL`, `CUSTOM`, `GRAND_TOTAL` | CSF 집계 표시 위치 |
| `DateGranularity` | `DAY`, `DAY_IN_MONTH`, `FISCAL_PERIOD`, `FISCAL_QUARTER`, `FISCAL_WEEK`, `FISCAL_YEAR`, `MONTH`, `MONTH_IN_YEAR`, `NONE`, `QUARTER`, `WEEK`, `YEAR` | 날짜 그룹핑 단위 |
| `FormulaType` | `CURRENCY`, `NUMBER`, `PERCENT` | CSF 숫자 형식 |
| `StandardFilterType` | `PICKLIST`, `STRING` | 표준 필터 값 타입 |
| `EvaluatedConditionOperator` | `EQUAL`, `GREATER_THAN`, `GREATER_THAN_EQUAL`, `LESS_THAN`, `LESS_THAN_EQUAL`, `NOT_EQUAL` | 알림 조건 연산자 |
| `ColumnSortOrder` | `ASCENDING`, `DESCENDING` | 정렬 방향 |

---

## Reports 예외 클래스

| 예외 | 설명 | 추가 메서드 |
|---|---|---|
| `Reports.FeatureNotSupportedException` | 지원하지 않는 보고서 형식 | — |
| `Reports.InstanceAccessException` | 보고서 인스턴스 접근 불가 | — |
| `Reports.InvalidFilterException` | 필터 유효성 오류 | `getFilterErrors()` → `List<String>` |
| `Reports.InvalidReportMetadataException` | 필터 메타데이터 누락 | `getReportMetadataErrors()` → `List<String>` |
| `Reports.InvalidSnapshotDateException` | 과거 보고서 날짜 형식 오류 | `getSnapshotDateErrors()` → `List<String>` |
| `Reports.MetadataException` | 선택된 보고서 컬럼 없음 | — |
| `Reports.ReportRunException` | 보고서 실행 오류 | — |
| `Reports.UnsupportedOperationException` | 보고서 실행 권한 없음 | — |

---

## 관련 노트

- [[Database Namespace 상세]] — DML 결과 처리, SaveResult, Cursor
- [[SOQL 패턴]] — 보고서 대신 SOQL 사용 기준
- [[Dynamic SOQL]] — 동적 쿼리로 집계 구현
- [[FormulaEval Namespace]] — 수식 기반 동적 계산
- [[Wave Namespace]] — CRM Analytics SAQL 분석 (표준 보고서 vs CRM Analytics)
