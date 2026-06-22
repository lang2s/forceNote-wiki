---
tags: [analytics, reports, rest-api, reports-dashboards-rest, execute-report, report-instances]
source: salesforce_analytics_rest_api.pdf (Reports and Dashboards REST API Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Execute Sync, Execute Async, Report List REST, Instance Results, 리포트 비동기 실행, factMap]
---

# Reports and Dashboards REST API — Execute·Instances·Report List 표현형

> 리포트를 동기(Execute Sync)·비동기(Execute Async)로 실행하고, 비동기 인스턴스를 조회·삭제(Instances List·Instance Results)하며, 최근 본 리포트 목록을 조회·복제(Report List)하는 5개 리소스의 URI·메서드·응답 표현형 정본.

---

이 노트는 Reports and Dashboards REST API의 리포트 실행 계열 5개 리소스를 다룬다. 각 리소스의 고유 URI·HTTP 메서드·Response Body·sub-table은 본 노트가 정본이다.

> 각 리소스의 **POST Request Body**는 `reportMetadata` 표현형 전체와 동일하므로 여기서 복제하지 않는다. 동적 필터·그룹핑·집계를 지정하는 요청 본문 속성 전수는 [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] 참조.

```json
// 구조 예시 — 실제 동작 응답 아님
{
  "attributes": { "type": "Reports", "reportId": "00OD0000001cQYmMAM", "reportName": "Closed Sales This Quarter" },
  "allData": true,
  "hasDetailRows": false,
  "factMap": {
    "T!T": { "aggregates": [ { "label": "$22,815,000", "value": 22815000 } ], "rows": [] }
  }
}
```

---

## Resource 1 — Execute Sync

Runs a report immediately with or without changing filters, groupings, or aggregates and returns the latest summary data with or without details for your level of access.

| 항목 | 값 |
|---|---|
| URL | `/services/data/<latest API version>/analytics/reports/<report ID>` |
| Formats | JSON |
| HTTP Methods | `GET` — Get report results. / `POST` — Get specific results by passing dynamic filters, groupings, and aggregates in the report metadata. |

POST는 요청 본문으로 `reportMetadata`를 받아 동적 필터·그룹핑·집계를 지정한다. 요청 본문 속성 전수는 [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] 참조.

### Response Body

| Property | Type | Description |
|---|---|---|
| `allData` | `Boolean` | When True, all report results are returned. When False, results are returned for the same number of rows as a report run in Salesforce. Note: For reports that have too many records, use filters to refine results. |
| `attributes` | `Attributes` | Key report attributes and child resource URLs. |
| `factMap` | `Fact map` | Summary level data or both summary and detailed data for each row or column grouping. Detailed data is available if `hasDetailRows` is true. Each row or column grouping is represented by combination of row and column grouping keys defined in Groupings down and Groupings across. See these examples of fact map keys. |
| `groupingsAcross` | `Groupings across` | Collection of column groupings, keys, and their values. |
| `groupingsDown` | `Groupings down` | Collection of row groupings, keys, and their values. |
| `hasDetailRows` | `Boolean` | When true, the fact map returns values for both summary level and record level data. When false, the fact map returns summary values. |
| `hasExceededTabularRowLimit` | `Boolean` | When True, returns results for the same number of rows as a report run in Salesforce. For a report on Salesforce Objects, total and subtotal rows don't count toward this limit. For a report on Data 360 Objects, total and subtotal rows do count toward this limit. When False, all report results are returned. |
| `reportExtendedMetadata` | `Report extended metadata` | Additional information about columns, summaries, and groupings. |
| `reportMetadata` | `Report metadata` | Unique identifiers for groupings and summaries. |

### Attributes (sub)

| Property | Type | Description |
|---|---|---|
| `describeUrl` | `String` | Resource URL to get report metadata. |
| `instancesUrl` | `String` | Resource URL to run a report asynchronously. The report can be run with or without filters to get summary or both summary and detailed data. Results of each instance of the report run are stored under this URL. |
| `type` | `String` | API resource format. |
| `reportName` | `String` | Display name of the report. |
| `reportId` | `String` | Unique report ID. |

### Fact map (sub)

| Property | Type | Description |
|---|---|---|
| `rows` | `Data cells[]` | Array of detailed report data listed in the order of the detail columns provided by the report metadata. |
| `aggregates` | `Aggregates[]` | Summary level data including record count for a report. |

### Data cells (sub)

| Property | Type | Description |
|---|---|---|
| `value` | `Detail column info data type` | The value of a specified cell. If the response is an empty string, then API version 36.0 and earlier returns null. API version 37.0 and later returns an empty string. |
| `label` | `String` | Display name of the value as it appears for a specified cell in the report. |

### Aggregates (sub)

| Property | Type | Description |
|---|---|---|
| `value` | `Number` | Numeric value of the summary data for a specified cell. |
| `label` | `String` | Formatted summary data for a specified cell. |

### Groupings across (sub)

| Property | Type | Description |
|---|---|---|
| `groupings` | `Groupings[]` | Information for each column grouping as a list. |

### Groupings down (sub)

| Property | Type | Description |
|---|---|---|
| `groupings` | `Groupings[]` | Information for each row grouping as a list. |

### Groupings (sub)

| Property | Type | Description |
|---|---|---|
| `value` | `String` | Value of the field used as a row or column grouping. The value depends on the field's data type. • Currency fields: – `amount`: Of type currency. Value of a data cell. – `currency`: Of type picklist. The ISO 4217 currency code, if available; for example, USD for US dollars or CNY for Chinese yuan. (If the grouping is on the converted currency, this is the currency code for the report and not for the record.) • Picklist fields: API name. For example, a custom picklist field, Type of Business with values 1, 2, 3 for Consulting, Services, and Add-On Business, has 1, 2, or 3 as the grouping value. • ID fields: API name. • Record type fields: API name. • Date and time fields: Date or time in ISO-8601 format. • Lookup fields: Unique API name. For example, for the Opportunity Owner lookup field, the ID of each opportunity owner's Chatter profile page can be a grouping value. |
| `key` | `String` | Unique identity for a row or column grouping. The identity is used by the fact map to specify data values within each grouping. |
| `label` | `String` | Display name of a row or column grouping. For date and time fields, the label is the localized date or time. |
| `groupings` | `Array` | Second or third level row or column groupings. If there are none, the value is an empty array. |
| `dategroupings` | `Array` | Start date and end date of the interval defined by date granularity. |

SEE ALSO: Describe · Execute Async

---

## Resource 2 — Execute Async

Runs an instance of a report asynchronously with or without filters and returns a handle that stores the results of the run. The results can contain summary data with or without details.

| 항목 | 값 |
|---|---|
| URL | `/services/data/<latest API version>/analytics/reports/<report ID>/instances` |
| Formats | JSON |
| HTTP Methods | `POST` — Runs an instance of a report asynchronously. |

POST Request Body는 `reportMetadata` 표현형 전체와 동일 → [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] 참조.

### Response Body

| Property | Type | Description |
|---|---|---|
| `id` | `String` | Unique ID for an instance of a report that was run asynchronously. |
| `status` | `String` | • `New` if the report run has just been triggered through a request. • `Success` if the report ran. • `Running` if the report is being run. • `Error` if the report run failed. The instance of a report run can return an error if, for example, your permission to access the report has been removed since you requested the run. |
| `url` | `String` | URL where results of the report run for that instance are stored. The value is null if the report couldn't be run because of an error. |
| `ownerId` | `String` | API name of the user that created the instance. |
| `completionDate` | `Date, time string` | Date, time when the instance of the report run finished. Only available if the report instance ran successfully or couldn't be run because of an error. Date-time information is in ISO-8601 format. |
| `hasDetailRows` | `Boolean` | • When false, indicates that summary level data was requested for the report instance. • When true, indicates that detailed data, which includes summary level data, was requested for the report instance. |
| `requestDate` | `Date, time string` | Date and time when an instance of the report run was requested. Date-time information is in ISO-8601 format. |

SEE ALSO: Describe · Execute Sync

---

## Resource 3 — Instances List

Returns a list of instances for a report that you requested to be run asynchronously. Each item in the list is treated as a separate instance of the report run with metadata in that snapshot of time.

| 항목 | 값 |
|---|---|
| URL | `/services/data/<latest API version>/analytics/reports/<report ID>/instances` |
| Formats | JSON |
| HTTP Methods | `GET` — Return a list of asynchronous runs of a report. |

### Response Body

| Property | Type | Description |
|---|---|---|
| `id` | `String` | Unique ID for a report instance that was requested for a run. The ID is used to obtain results of the report run for that instance. |
| `status` | `String` | • `New` if the report run has just been triggered through a POST request. • `Success` if the report ran. • `Running` if the report is being run. • `Error` if the report run failed. The instance of a report run can return an error if, for example, your permission to access the report has been removed since you requested the run. |
| `url` | `String` | URL where results of the report run for that instance are stored. The value is null if the report couldn't be run because of an error. |
| `ownerId` | `String` | API name of the user that created the instance. |
| `hasDetailRows` | `Boolean` | • When false, indicates that summary level data was requested for the report run. • When true, indicates that detailed data, which includes summary level data, was requested for the report run. |
| `completionDate` | `Date, time string` | Date, time when the instance of the report run finished. Only available if the report instance ran successfully or couldn't be run because of an error. Date-time information is in ISO-8601 format. |
| `requestDate` | `Date, time string` | Date and time when an instance of the report run was requested. Date-time information is in ISO-8601 format. |

SEE ALSO: Execute Async · Instance Results

---

## Resource 4 — Instance Results

Retrieves results for an instance of a report run asynchronously with or without filters. Depending on your asynchronous report run request, data can be at the summary level or include details.

| 항목 | 값 |
|---|---|
| URL | `/services/data/<latest API version>/analytics/reports/<report ID>/instances/<instance ID>` |
| Formats | JSON |
| HTTP Methods | `GET` — Retrieves results of an asynchronous report run. / `DELETE` — If the given report instance has a status of Success or Error, delete the report instance and return an empty response body. |

### GET Response Body

| Property | Type | Description |
|---|---|---|
| `allData` | `Boolean` | When True, all report results are returned. When False, returns results for the same number of rows as a report run in Salesforce. |
| `attributes` | `Attributes` | Attributes for the instance of the report run. |
| `factMap` | `Fact map` | Collection of summary level data or both detailed and summary level data. |
| `groupingsAcross` | `Groupings across` | Collection of column groupings. |
| `groupingsDown` | `Groupings down` | Collection of row groupings. |
| `hasDetailRows` | `Boolean` | • When false, report results are at summary level. • When true, report results are at the record detail level. |
| `hasExceededTabularRowLimit` | `Boolean` | When True, returns the same number of rows as a report run in Salesforce. For a report on Salesforce Objects, total and subtotal rows don't count toward this limit. For a report on Data 360 Objects, total and subtotal rows do count toward this limit. When False, all report results are returned. |
| `reportExtendedMetadata` | `Report extended metadata` | Information on report groupings, summary fields, and detailed data columns, which is available if detailed data is requested. |
| `reportMetadata` | `Report metadata` | Information about the fields used to build the report. |

### Attributes (sub)

| Property | Type | Description |
|---|---|---|
| `id` | `String` | Unique ID for an instance of a report that was run. |
| `status` | `String` | • `New` if the report run has just been triggered through a request. • `Success` if the report ran. • `Running` if the report is being run. • `Error` if the report run failed. The instance of a report run can return an error if, for example, your permission to access the report has been removed since you requested the run. |
| `ownerId` | `String` | API name of the user that created the instance. |
| `completionDate` | `Date, time string` | Date, time when the instance of the report run finished. Only available if the report instance ran successfully or couldn't be run because of an error. Date-time information is in ISO-8601 format. |
| `requestDate` | `Date, time string` | Date and time when an instance of the report run was requested. Date-time information is in ISO-8601 format. |
| `type` | `String` | Format of the resource. |
| `reportId` | `String` | Unique report ID. |
| `reportName` | `String` | Display name of the report. |

`factMap`·`groupingsAcross`·`groupingsDown`의 하위 표현형(Fact map · Data cells · Aggregates · Groupings)은 Resource 1 — Execute Sync 섹션과 동일하다. 위의 해당 sub-table 참조.

SEE ALSO: Execute Async · Instances List

---

## Resource 5 — Report List

Displays a list of up to 200 tabular, matrix, or summary reports that you recently viewed. To get a full list of reports by format, name, and other fields, use a SOQL query on the Report object. The resource can also be used to make a copy of a report.

### Resource URL

| Task | URL |
|---|---|
| List reports | `/services/data/<latest API version>/analytics/reports` |
| Copy report | `/services/data/<latest API version>/analytics/reports?cloneId=<report ID>` |

| 항목 | 값 |
|---|---|
| Formats | JSON |
| HTTP Methods | `GET` — List of reports that were recently viewed by the API user. / `POST` — Create or clone a report. To create a new report, see this example. To clone an existing report, see this example. |

### GET Response Body

| Property | Type | Description |
|---|---|---|
| `name` | `String` | Report display name. |
| `id` | `String` | Unique report ID. |
| `url` | `String` | URL that returns report data. |
| `describeUrl` | `String` | URL that retrieves report metadata. |
| `instancesUrl` | `String` | Information for each instance of the report that was run asynchronously. |

POST(create/clone) Response Body는 `reportMetadata` 표현형 전체를 반환 → [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] 참조.

---

## 관련 노트

- [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] — POST Request Body 및 Report List POST 응답의 `reportMetadata` 전체 속성 정본
- [[Reports and Dashboards REST API — Report 표현형]]
- [[Reports and Dashboards REST API — 개요·Reports 예제]]
- [[Reports and Dashboards REST API — Dashboards·Downloads·Notifications 예제]]
