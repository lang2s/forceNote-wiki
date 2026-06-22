---
tags: [analytics, reports, rest-api, reports-dashboards-rest, query-resource, run-report-without-saving]
source: salesforce_analytics_rest_api.pdf (Reports and Dashboards REST API Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Query resource REST, 리포트 쿼리 REST, run report without saving, analytics reports query, factMap]
---

# Reports and Dashboards REST API — Query 표현형

> Query 리소스 — 리포트를 저장하거나 새로 만들지 않고(run a report without saving) `reportMetadata`를 POST 본문으로 받아 실행하고 그 결과(fact map 포함)를 반환한다.

---

## Query 리소스

Returns report data without saving changes or creating a report. (Run a report without creating a report or changing an existing one.)

| 항목 | 값 |
|---|---|
| URL | `/services/data/<latest API version>/analytics/reports/query` |
| Formats | JSON |
| HTTP Methods | `POST` |

- **`POST`** — Run a report without creating or saving the report. Customize your report using `reportMetadata` that you specify in the request body.

### Request Body — reportMetadata

Query의 POST 요청 본문은 **`reportMetadata` 전체 표현형(34개 속성 + 12개 중첩 표현형)** 이다. 이 스키마는 Describe 리소스가 반환하는 `reportMetadata`와 **동일**하므로, 본 노트에서 복제하지 않고 정본 노트를 참조한다.

> Request Body 전체 속성·중첩 스키마는 [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] 참조.

즉, Query는 POST 본문으로 `reportMetadata`를 받아 리포트를 **생성·저장 없이 실행**한다. 본 노트는 Query가 반환하는 **Response Body**·sub-table·fact map key 패턴·POST 예제를 정본으로 다룬다.

---

## Response Body

| Property | Type | Description |
|---|---|---|
| `allData` | `Boolean` | When True, all report results are returned. When False, results are returned for the same number of rows as a report run in Salesforce. **Note:** For reports that have too many records, use filters to refine results. |
| `attributes` | `Attributes` | Key report attributes and child resource URLs. |
| `factMap` | `Fact map` | Summary level data or both summary and detailed data for each row or column grouping. Detailed data is available if `hasDetailRows` is true. Each row or column grouping is represented by combination of row and column grouping keys defined in Groupings down and Groupings across. See these examples of fact map keys. |
| `groupingsAcross` | `Groupings across` | Collection of column groupings, keys, and their values. |
| `groupingsDown` | `Groupings down` | Collection of row groupings, keys, and their values. |
| `hasDetailRows` | `Boolean` | When true, the fact map returns values for both summary level and record level data. When false, the fact map returns summary values. |
| `hasExceededTabularRowLimit` | `Boolean` | When True, returns results for the same number of rows as a report run in Salesforce. For a report on Salesforce Objects, total and subtotal rows don't count toward this limit. For a report on Data 360 Objects, total and subtotal rows do count toward this limit. When False, all report results are returned. |
| `reportExtendedMetadata` | `Report extended metadata` | Additional information about columns, summaries, and groupings. |
| `reportMetadata` | `Report metadata` | Unique identifiers for groupings and summaries. |

---

## Response sub-table 표현형

### Attributes
| Property | Type | Description |
|---|---|---|
| `describeUrl` | `String` | Resource URL to get report metadata. |
| `instancesUrl` | `String` | Resource URL to run a report asynchronously. |
| `type` | `String` | API resource format. |
| `reportName` | `String` | Display name of the report. |
| `reportId` | `String` | Unique report ID. |

### Fact map
| Property | Type | Description |
|---|---|---|
| `rows` | `Data cells[]` | Array of detailed report data listed in the order of the detail columns provided by the report metadata. |
| `aggregates` | `Aggregates[]` | Summary level data including record count for a report. |

### Data cells
| Property | Type | Description |
|---|---|---|
| `value` | `Detail column info data type` | The value of a specified cell. |
| `label` | `String` | Display name of the value as it appears for a specified cell in the report. If the response is an empty string, then API version 36.0 and earlier returns null. API version 37.0 and later returns an empty string. |

### Aggregates
| Property | Type | Description |
|---|---|---|
| `value` | `Number` | Numeric value of the summary data for a specified cell. |
| `label` | `String` | Formatted summary data for a specified cell. |

### Groupings across
| Property | Type | Description |
|---|---|---|
| `groupings` | `Groupings[]` | Information for each column grouping as a list. |

### Groupings down
| Property | Type | Description |
|---|---|---|
| `groupings` | `Groupings[]` | Information for each row grouping as a list. |

### Groupings
| Property | Type | Description |
|---|---|---|
| `value` | `String` | Value of the field used as a row or column grouping. For Currency fields, the amount and the currency ISO 4217 code. For Picklist fields, the API name. For ID and Record type fields, the API name. For Date and time fields, the ISO-8601 value. For Lookup fields, the unique API name. |
| `key` | `String` | Unique identity for a row or column grouping. |
| `label` | `String` | Display name of a row or column grouping. For date and time fields, the label is the localized date or time. |
| `groupings` | `Array` | Second or third level row or column groupings. If there are none, the value is an empty array. |
| `dategroupings` | `Array` | Start date and end date of the interval defined by date granularity. |

---

## Fact map key 패턴

`factMap`의 각 키는 row·column grouping의 조합으로 데이터 섹션을 가리킨다. 형식별 키 패턴은 다음과 같다.

| Report format | Fact map key pattern |
|---|---|
| Tabular | `T!T`: The grand total of a report. Both record data values and the grand total are represented by this key. |
| Summary | `<First level row grouping_second level row grouping_third level row grouping>!T`: T refers to the row grand total. |
| Matrix | `<First level row grouping_second level row grouping>!<First level column grouping_second level column grouping>`. |

> Each item in a row or column grouping is numbered starting with `0`. 예: `0!T`(first item of first-level grouping), `1!T`(second item of first-level grouping), `0_0!T`(first item of first-level + first item of second-level), `0_1!T`(first item of first-level + second item of second-level).

상세 디코딩(Tabular/Summary/Matrix 예제별 키 해석)은 [[Reports and Dashboards REST API — 개요·Reports 예제]]의 "Decode the Fact Map" 정본 참조.

---

## POST 예제

리포트를 저장하지 않고 실행하는 POST 요청 예제. (HTTP Methods 섹션 cross-ref, Ch2)

> ⚠️ [sic] 원문 보존: request의 `reportFormat`은 `MATRIX`이지만 response echo의 `reportFormat`은 `TABULAR`이고, response echo의 `developerName`·`id`는 `null`이다. 예제 URI는 v37.0(구버전)으로 원문 그대로 유지한다.

### Request

`POST /services/data/v37.0/analytics/reports/query`

```json
{
"reportMetadata" : {
"aggregates" : [ "RowCount" ],
"chart" : null,
"crossFilters" : [ ],
"currency" : null,
"description" : null,
"detailColumns" : [ "OPPORTUNITY_NAME", "TYPE", "LEAD_SOURCE", "AMOUNT", "CLOSE_DATE",
"NEXT_STEP", "STAGE_NAME", "PROBABILITY", "FISCAL_QUARTER", "AGE", "CREATED_DATE",
"FULL_NAME", "ROLLUP_DESCRIPTION", "ACCOUNT_NAME" ],
"developerName" : "OpportunityReport",
"division" : null,
"folderId" : "00DD000000086ujMAA",
"groupingsAcross" : [ ],
"groupingsDown" : [ ],
"hasDetailRows" : true,
"hasRecordCount" : true,
"historicalSnapshotDates" : [ ],
"id" : "00OD0000001leVCMAY",
"name" : "Matrix",
"reportBooleanFilter" : null,
"reportFilters" : [ ],
"reportFormat" : "MATRIX",
"reportType" : { "label" : "Opportunities", "type" : "Opportunity" },
"scope" : "organization",
"showGrandTotal" : true,
"showSubtotals" : true,
"sortBy" : [ ],
"standardDateFilter" : { "column" : "CLOSE_DATE", "durationValue" : "CUSTOM", "endDate" : null, "startDate" : null },
"standardFilters" : [ { "name" : "open", "value" : "all" }, { "name" : "probability", "value" : ">0" } ]
}
}
```

### Response (골격 — dataCells 축약)

```json
{
"attributes" : {
"describeUrl" : "/services/data/v37.0/analytics/reports/null/describe",
"instancesUrl" : "/services/data/v37.0/analytics/reports/null/instances",
"reportId" : null,
"reportName" : "Matrix",
"type" : "Report"
},
"allData" : true,
"factMap" : {
"T!T" : {
"aggregates" : [ { "label" : "9", "value" : 9 } ],
"rows" : [ {
"dataCells" : [
{ "label" : "salesforce.com - 5000 Widgets", "value" : "006D000000CzmqYIAR" },
{ "label" : "New Business", "value" : "New Business" },
{ "label" : "Advertisement", "value" : "Advertisement" },
{ "label" : "$500,000.00", "value" : { "amount" : 500000, "currency" : null } },
{ "label" : "9/19/2013", "value" : "2013-09-19" }
/* ... (각 row 14개 dataCell — detailColumns 순서대로; opportunity 9건 반복) ... */
] }
}
},
"groupingsAcross" : { "groupings" : [ ] },
"groupingsDown" : { "groupings" : [ ] },
"hasDetailRows" : true,
"reportExtendedMetadata" : {
"aggregateColumnInfo" : { "RowCount" : { "dataType" : "int", "label" : "Record Count" } },
"detailColumnInfo" : {
"OPPORTUNITY_NAME" : { "dataType" : "string", "label" : "Opportunity Name" },
"TYPE" : { "dataType" : "picklist", "label" : "Type" },
"LEAD_SOURCE" : { "dataType" : "picklist", "label" : "Lead Source" },
"AMOUNT" : { "dataType" : "currency", "label" : "Amount" },
"CLOSE_DATE" : { "dataType" : "date", "label" : "Close Date" },
"NEXT_STEP" : { "dataType" : "string", "label" : "Next Step" },
"STAGE_NAME" : { "dataType" : "picklist", "label" : "Stage" },
"PROBABILITY" : { "dataType" : "percent", "label" : "Probability (%)" },
"FISCAL_QUARTER" : { "dataType" : "string", "label" : "Fiscal Period" },
"AGE" : { "dataType" : "int", "label" : "Age" },
"CREATED_DATE" : { "dataType" : "datetime", "label" : "Created Date" },
"FULL_NAME" : { "dataType" : "string", "label" : "Opportunity Owner" },
"ROLLUP_DESCRIPTION" : { "dataType" : "string", "label" : "Owner Role" },
"ACCOUNT_NAME" : { "dataType" : "string", "label" : "Account Name" }
},
"groupingColumnInfo" : { }
},
"reportMetadata" : { "...request와 동일하나 developerName:null, id:null, reportFormat:\"TABULAR\"..." }
}
```

---

## 관련 노트

- [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] — Query POST 요청 본문(`reportMetadata` 34속성 + 12 중첩 표현형) 정본
- [[Reports and Dashboards REST API — 개요·Reports 예제]] — "Decode the Fact Map" 정본(형식별 키 디코딩 예제), Query/Run 예제 맥락
- [[Reports and Dashboards REST API — Report 표현형]] — Report 리소스(PATCH/저장) 표현형
- [[Reports and Dashboards REST API — Execute·Instances·Report List 표현형]] — 동기/비동기 Run 리소스(같은 reportMetadata POST 본문 공유)
- [[Reports and Dashboards REST API — Dashboards·Downloads·Notifications 예제]] — 같은 폴더 형제 예제 노트
