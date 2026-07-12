---
tags: [analytics, reports, rest-api, reports-dashboards-rest, report-examples]
source: salesforce_analytics_rest_api.pdf (Reports and Dashboards REST API Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Reports REST API, 리포트 REST API, Create Report REST, Run Report Async, Fact Map, 리포트 실행 REST]
---

# Reports and Dashboards REST API — 개요·Reports 예제

> 리포트·대시보드 데이터에 프로그래밍 방식으로 접근하는 REST API의 Overview(Resource URL·제약·EOL 정책)와 Reports Examples 전수 — Create / Run sync·async / Describe / Report Types / Excel / Filter / Fact Map decode / Query(미저장) / Save / Clone / Delete.

---

## Overview

Reports and Dashboards REST API는 report builder·dashboard builder에 정의된 리포트·대시보드 데이터에 프로그래밍 방식으로 접근하게 해준다. 이 데이터를 Salesforce 플랫폼 안팎의 웹·모바일 애플리케이션에 통합할 수 있다. 예를 들어 분기마다 상위 영업담당자 스냅샷을 담은 Chatter 게시물을 트리거하는 데 사용할 수 있다.

> The Reports and Dashboards REST API will revolutionize the way you access and visualize your data. You can:
> - Integrate report data into custom objects.
> - Define rich visualizations on top of the API to animate the data.
> - Build custom dashboards.
> - Automate reporting tasks.

상위 수준에서 API 리소스로 리포트 데이터를 쿼리·필터할 수 있다.
- Run tabular, summary, or matrix reports synchronously or asynchronously.
- Filter for specific data on the fly.
- Query report metadata.

대시보드 리소스로는 다음을 할 수 있다.
- Get a list of recently used dashboards.
- Get dashboard metadata and data.
- Query dashboard status.
- Refresh dashboards.

> 대시보드 예제는 [[Reports and Dashboards REST API — Dashboards·Downloads·Notifications 예제]] 소관(이 노트는 Reports 예제만 다룬다).

---

## Build the Resource URL

My Domain 로그인 URL로 시작한다. My Domain 이름은 `getMyDomainName()` Apex 메서드로 얻거나 Setup의 My Domain 페이지에서 확인한다.

```
https://MyDomainName.my.salesforce.com
```

버전 정보를 붙인다.

```
/services/data/v67.0
```

리소스를 붙인다.

```
/analytics/reports
```

전부 합친 전체 URL.

```
https://MyDomainName.my.salesforce.com/services/data/v67.0/analytics/reports
```

`notifications` 같은 일부 리소스는 하나 이상의 URL 파라미터를 요구하며, 없으면 API 요청이 에러를 반환한다.

```
https://MyDomainName.my.salesforce.com/services/data/v67.0/analytics/notifications?source=lightningReportSubscribe
```

---

## Requirements and Limitations

API가 활성화된 모든 조직에서 사용 가능하다. Reports and Dashboards REST API에 접근하려면 OAuth로 인증된 세션을 수립해야 한다. 일반 API 한도에 더해 아래 제약을 고려한다.

> To use the Analytics Download API, your org must have a CRM Analytics license. In addition, your org needs both Slack for Salesforce and CRM Analytics for Slack enabled. For more information, see Enable Salesforce for Slack Integrations.

> **Note:** Responses and requests are in JSON. While using the Reports and Dashboards REST API with a POST request body, you must use `content-type: application/json`. If you don't use this content type, then you could get unexpected results.

### Reports Limits (전수)

- Cross filters, standard report filters, and filtering by row limit are unavailable when filtering data.
- Historical tracking reports are only supported for matrix reports.
- Subscriptions aren't supported for historical tracking reports.
- The API can process only reports that contain up to **100 fields** selected as columns.
- A list of up to **200 recently viewed reports** can be returned.
- Your org can request up to **500 synchronous report runs per hour**.
- The API supports up to **20 synchronous report run requests at a time**.
- A list of up to **2,000 instances** of a report that was run asynchronously can be returned.
- The API supports up to **200 requests at a time** to get results of asynchronous report runs.
- Your organization can request up to **1,200 asynchronous requests per hour**.
- Asynchronous report run results are available within a **24-hour rolling period**.
- The API returns up to the first **2,000 report rows**. You can narrow results using filters.
- You can add up to **20 custom field filters** when you run a report.
- If a report is run on a standard or custom object as an automated process user from an Apex test class, only the required custom fields are returned. Non-required custom fields aren't shown in the results.
- *(PDF 원문에서 Reports Limits 목록 끝에 대시보드 항목이 중첩 불릿으로 중복 등장)*: Your org can request up to 200 dashboard refreshes per hour. / Your org can request results for up to 5,000 dashboards per hour.

### Dashboards Limits (범위 밖 — 같은 페이지에 함께 등장, 참고)

- Your org can request up to **200 dashboard refreshes per hour**.
- Your org can request results for up to **5,000 dashboards per hour**.

### Analytics Notification Limits

- Each user can subscribe to up to **5 reports**.
- Each user can create up to **5 Analytics notifications**.

> **Note:** All limits that apply to reports created in the report builder also apply to the API, as do limits for dashboards created in the dashboard builder. For more information, see "Salesforce Reports and Dashboards Limits" in Salesforce Help.

### Analytics Download Limits

- Each user can make **3 concurrent requests** to download Analytics assets.

---

## API End-of-Life Policy

Salesforce는 각 API 버전을 최초 릴리즈일로부터 최소 3년간 지원한다. API 품질·성능을 성숙·개선하기 위해, 3년 이상 된 버전은 지원이 중단될 수 있다.

API 버전이 폐기 예정이면 지원 종료 최소 1년 전에 사전 고지한다. Salesforce는 폐기 예정 API 버전을 사용하는 고객에게 직접 통지한다.

> If you request any resource or use an operation from a retired API version, REST API returns `410:GONE` error code.
>
> To identify requests made from old or unsupported API versions of REST API, access the free API Total Usage event type.

EOL 표 (PDF p.9 이미지 직접 확인본이 정본 — pdftotext가 셀 순서를 뒤섞어 출력함):

| Salesforce API Versions | Version Support Status | Version Retirement Info |
|---|---|---|
| Versions 31.0 through 66.0 | Supported. | *(빈칸 — retirement info 없음)* |
| Versions 21.0 through 30.0 | As of Summer '25, these versions are retired and unavailable. | Salesforce Platform API Versions 21.0 through 30.0 Retirement |
| Versions 7.0 through 20.0 | As of Summer '22, these versions are retired and unavailable. | Salesforce Platform API Versions 7.0 through 20.0 Retirement |

---

## Reports Examples 개요

> Learn how to run, create, edit, or delete reports with the Reports REST API. Running a report returns a fact map that describes report data.

아래 예제의 URI는 PDF 원문 그대로 옛 API 버전(v29~v39 등)을 유지한다(임의로 v67로 통일하지 않음).

| 예제 | HTTP | 한 줄 설명 (원문) |
|---|---|---|
| Create a New Report | POST | Create a new report using a POST request. |
| Run Reports Synchronously or Asynchronously | GET/POST | — |
| Get Report Metadata | GET | — |
| Get a List of Report Types | GET | Return a list of analytics notifications using a GET request. *[sic — 설명이 "report types"가 아니라 "analytics notifications"로 오기]* |
| Download Formatted Excel Reports | POST/GET | You can use the Reports REST API to request reports in printer-friendly Excel format. |
| List Asynchronous Runs of a Report | GET | — |
| Filter Reports on Demand | POST | — |
| List Recently Viewed Reports | GET | — |
| Decode the Fact Map | — | — |
| Get Report Data without Saving | POST | Run a report without creating a report or changing an existing one by making a POST request to the query resource. |
| Save Changes to Reports | PATCH | Save changes to a report by sending a PATCH request to the Report resource. |
| Clone Reports | POST | Creates a copy of a custom, standard, or public report by sending a POST request to the Report List resource. |
| Delete Reports | DELETE | Delete a report by sending a DELETE request to the Report resource. Deleted reports are moved to the Recycle Bin. |

> Fact Map·reportMetadata의 깊은 표현형(스키마·속성 전수)은 Describe 표현형/Report 표현형 노트 및 Reports Namespace 노트 소관 — 본 노트는 예제 맥락 위주. 폴백 링크는 ## 관련 노트 참조.

---

## Create a New Report

새 리포트를 POST 요청으로 생성한다. 리포트를 만들려면 `reportMetadata`에 `name`과 `reportType`만 지정하면 된다(나머지 속성은 선택).

**POST** `/services/data/v39.0/analytics/reports` *[sic — 본문 예제 URL은 v39.0]*

요청 본문:

```json
{
"reportMetadata": {
"name":"NewReport",
"reportType": {
"type" : "Opportunity"
}
}
}
```

응답에는 새 리포트의 `reportExtendedMetadata`, `reportMetadata`, `reportTypeMetadata`가 포함된다. 응답 상단 핵심부(`reportExtendedMetadata` + `reportMetadata`) verbatim:

```json
{
"reportExtendedMetadata" : {
"aggregateColumnInfo" : {
"RowCount" : { "dataType" : "int", "label" : "Record Count" }
},
"detailColumnInfo" : {
"ROLLUP_DESCRIPTION" : { "dataType" : "string", "label" : "Owner Role" },
"FULL_NAME" : { "dataType" : "string", "label" : "Opportunity Owner" },
"ACCOUNT_NAME" : { "dataType" : "string", "label" : "Account Name" },
"OPPORTUNITY_NAME" : { "dataType" : "string", "label" : "Opportunity Name" },
"STAGE_NAME" : { "dataType" : "picklist", "label" : "Stage" },
"FISCAL_QUARTER" : { "dataType" : "string", "label" : "Fiscal Period" },
"AMOUNT" : { "dataType" : "currency", "label" : "Amount" },
"PROBABILITY" : { "dataType" : "percent", "label" : "Probability (%)" },
"AGE" : { "dataType" : "int", "label" : "Age" },
"CLOSE_DATE" : { "dataType" : "date", "label" : "Close Date" },
"CREATED_DATE" : { "dataType" : "datetime", "label" : "Created Date" },
"NEXT_STEP" : { "dataType" : "string", "label" : "Next Step" },
"LEAD_SOURCE" : { "dataType" : "picklist", "label" : "Lead Source" },
"TYPE" : { "dataType" : "picklist", "label" : "Type" }
},
"groupingColumnInfo" : { }
},
"reportMetadata" : {
"aggregates" : [ "RowCount" ],
"chart" : null,
"crossFilters" : [ ],
"currency" : null,
"description" : null,
"detailColumns" : [ "ROLLUP_DESCRIPTION", "FULL_NAME", "ACCOUNT_NAME",
"OPPORTUNITY_NAME", "STAGE_NAME", "FISCAL_QUARTER", "AMOUNT", "PROBABILITY", "AGE",
"CLOSE_DATE", "CREATED_DATE", "NEXT_STEP", "LEAD_SOURCE", "TYPE" ],
"developerName" : "DocTest2_mG",
"division" : null,
"folderId" : "005R0000000Kg8cIAC",
"groupingsAcross" : [ ],
"groupingsDown" : [ ],
"hasDetailRows" : true,
"hasRecordCount" : true,
"historicalSnapshotDates" : [ ],
"id" : "00OR0000000PYkiMAG",
"name" : "DocTest2",
"reportBooleanFilter" : null,
"reportFilters" : [ ],
"reportFormat" : "TABULAR",
"reportType" : { "label" : "Opportunities", "type" : "Opportunity" },
"scope" : "organization",
"showGrandTotal" : true,
"showSubtotals" : true,
"sortBy" : [ ],
"standardDateFilter" : {
"column" : "CLOSE_DATE",
"durationValue" : "THIS_FISCAL_QUARTER",
"endDate" : "2016-12-31",
"startDate" : "2016-10-01"
},
"standardFilters" : [
{ "name" : "open", "value" : "all" },
{ "name" : "probability", "value" : ">0" }
],
"supportsRoleHierarchy" : true,
"userOrHierarchyFilterId" : null
},
"reportTypeMetadata" : {
"categories" : [ /* ... 전체 필드 카탈로그 (출처 라인 460–2030 참조) ... */ ],
"standardFilterDurationGroups" : [ /* ... */ ],
"standardFilterInfos" : { "probability" : { /* ... */ }, "open" : { /* ... */ } }
}
}
```

> 응답 본문의 `reportTypeMetadata.categories`는 약 1,700줄짜리 **Opportunity 리포트 타입 전체 필드 카탈로그**(필드별 `dataType`/`filterValues`/`filterable`/`label`)다. 분량상 본 노트에는 전수 인용하지 않는다 — **조용한 누락이 아니라 의도적 위임**: 깊은 스키마 카탈로그는 [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] · [[Reports and Dashboards REST API — Report 표현형]] · Reports Namespace 노트 소관이며, 원문 전체는 `salesforce_analytics_rest_api.pdf` 출처 라인 460–2030(추출 텍스트 `/tmp/analytics_rest.txt`)에서 확인한다.
>
> 참고: `standardFilterInfos.probability`는 PICKLIST(All=`">0"`, gt90~gt10, lt90~lt10), `open`은 PICKLIST(Any=`"all"`, Open=`"open"`, Closed=`"closed"`, Closed Won=`"closedwon"`). 카탈로그 `categories` 그룹 label 예: "Opportunity Information", "Opportunity Owner Information", "Account Information".

---

## Run Reports Synchronously or Asynchronously

리포트를 동기 또는 비동기로 실행해 요약 데이터를 (상세 포함/미포함으로) 얻는다. 리포트를 실행하면 API는 Salesforce UI에서 실행했을 때와 동일한 수의 레코드 데이터를 반환한다.

빠르게 끝날 것으로 예상되면 동기 실행하고, 그렇지 않으면 다음 이유로 비동기 실행을 권장한다.

> - Long running reports have a lower risk of reaching the timeout limit when run asynchronously.
> - The 2-minute overall Salesforce API timeout limit doesn't apply to asynchronous runs.
> - The Salesforce Reports and Dashboards REST API can handle a higher number of asynchronous run requests at a time.
> - Since the results of an asynchronously run report are stored for a 24-hr rolling period, they're available for recurring access.

동기 실행:
- Send a GET or POST request to the Execute Sync resource to get data.
- Use a POST request to get specific results on the fly by passing dynamic filters, groupings, and aggregates in the report metadata.

비동기 실행:
1. Send a POST request to the Execute Async resource. If you're passing filters, include them in the POST request metadata. The request returns the instance ID where results of the run are stored.
2. Send a GET request to the Instance Results resource to fetch data using the instance ID.

### Example of a synchronous report run

GET to Execute Sync, `/services/data/v35.0/analytics/reports/00OR0000000K2UeMAK?includeDetails=true` — 상세 포함 요약 데이터 반환(matrix report). `...`는 PDF 원문 자체의 생략 표기(factMap 중간 키 생략)이지 추출 임의 생략이 아니다.

```json
{
"attributes" : {
"describeUrl" : "/services/data/v35.0/analytics/reports/00OR0000000K2UeMAK/describe",
"instancesUrl" : "/services/data/v35.0/analytics/reports/00OR0000000K2UeMAK/instances",
"reportId" : "00OR0000000K2UeMAK",
"reportName" : "Deals Closing This Quarter",
"type" : "Report"
},
"allData" : true,
"factMap" : {
"2!0_0" : {
"aggregates" : [
{ "label" : "$16,000.01", "value" : 16000.010000000000218278728425502777099609375 },
{ "label" : "$16,000.01", "value" : 16000.010000000000218278728425502777099609375 },
{ "label" : "1", "value" : 1 } ],
"rows" : [ {
"dataCells" : [
{ "label" : "Acme - 200 Widgets", "value" : "006R00000023IDYIA2" },
{ "label" : "$16,000.01", "value" : { "amount" : 16000.01, "currency" : null } },
{ "label" : "Word of mouth", "value" : "Word of mouth" },
{ "label" : "Need estimate", "value" : "Need estimate" },
{ "label" : "60%", "value" : 60},
{ "label" : "Q3-2015", "value" : "Q3-2015" },
{ "label" : "12", "value" : 12 },
{ "label" : "7/31/2015", "value" : "2015-07-31" },
{ "label" : "Fred Wiliamson", "value" : "005R0000000Hv5rIAC" },
{ "label" : "-", "value" : null } ]
} ]
},
"T!0" : {
"aggregates" : [
{ "label" : "$32,021.01", "value" : 32021.00999999999839928932487964630126953125 },
{ "label" : "$16,010.51", "value" : 16010.504999999999199644662439823150634765625 },
{ "label" : "2", "value" : 2 } ],
"rows" : [ ]
},
"T!T" : {
"aggregates" : [
{ "label" : "$153,042.01", "value" : 153042.01000000000931322574615478515625 },
{ "label" : "$25,507.00", "value" : 25507.00166666666700621135532855987548828125 },
{ "label" : "6", "value" : 6 } ],
"rows" : [ ]
}
},
"groupingsAcross" : {
"groupings" : [
{ "groupings" : [ { "groupings" : [ ], "key" : "0_0", "label" : "Existing Business", "value" : "Existing Business" } ],
  "key" : "0", "label" : "July 2015", "value" : "2015-07-01" },
{ "groupings" : [ { "groupings" : [ ], "key" : "1_0", "label" : "Existing Business", "value" : "Existing Business" },
                  { "groupings" : [ ], "key" : "1_1", "label" : "New Business", "value" : "New Business" } ],
  "key" : "1", "label" : "August 2015", "value" : "2015-08-01" },
{ "groupings" : [ { "groupings" : [ ], "key" : "2_0", "label" : "Existing Business", "value" : "Existing Business" } ],
  "key" : "2", "label" : "September 2015", "value" : "2015-09-01" }
]
},
"groupingsDown" : {
"groupings" : [
{ "groupings" : [ ], "key" : "0", "label" : "Acme", "value" : "001R0000002GuzsIAC" },
{ "groupings" : [ ], "key" : "1", "label" : "Facebook", "value" : "001R0000001nUAmIAM" },
{ "groupings" : [ ], "key" : "2", "label" : "Home Depot", "value" : "001R0000002Gv5zIAC" },
{ "groupings" : [ ], "key" : "3", "label" : "Mircosoft", "value" : "001R0000002Gv5QIAS" }
]
},
"hasDetailRows" : true,
"reportExtendedMetadata" : {
"aggregateColumnInfo" : {
"s!AMOUNT" : { "acrossGroupingContext" : null, "dataType" : "currency", "downGroupingContext" : null, "label" : "Sum of Amount" },
"a!AMOUNT" : { "acrossGroupingContext" : null, "dataType" : "currency", "downGroupingContext" : null, "label" : "Average Amount" },
"RowCount" : { "acrossGroupingContext" : null, "dataType" : "int", "downGroupingContext" : null, "label" : "Record Count" }
},
"detailColumnInfo" : {
"OPPORTUNITY_NAME" : { "dataType" : "string", "label" : "Opportunity Name" },
"AMOUNT" : { "dataType" : "currency", "label" : "Amount" },
"LEAD_SOURCE" : { "dataType" : "picklist", "label" : "Lead Source" },
"NEXT_STEP" : { "dataType" : "string", "label" : "Next Step" },
"PROBABILITY" : { "dataType" : "percent", "label" : "Probability (%)" },
"FISCAL_QUARTER" : { "dataType" : "string", "label" : "Fiscal Period" },
"AGE" : { "dataType" : "int", "label" : "Age" },
"CREATED_DATE" : { "dataType" : "datetime", "label" : "Created Date" },
"FULL_NAME" : { "dataType" : "string", "label" : "Opportunity Owner" },
"ROLLUP_DESCRIPTION" : { "dataType" : "string", "label" : "Owner Role" }
},
"groupingColumnInfo" : {
"ACCOUNT_NAME" : { "dataType" : "string", "groupingLevel" : 0, "label" : "Account Name" },
"CLOSE_DATE" : { "dataType" : "date", "groupingLevel" : 0, "label" : "Close Date" },
"TYPE" : { "dataType" : "picklist", "groupingLevel" : 1, "label" : "Type" }
}
},
"reportMetadata" : {
"aggregates" : [ "s!AMOUNT", "a!AMOUNT", "RowCount" ],
"chart" : {
"chartType" : "Donut",
"groupings" : [ "CLOSE_DATE" ],
"hasLegend" : true,
"showChartValues" : false,
"summaries" : [ "s!AMOUNT" ],
"summaryAxisLocations" : [ "Y" ],
"title" : "Pipeline by Stage and Type"
},
"currency" : null,
"description" : null,
"detailColumns" : [ "OPPORTUNITY_NAME", "AMOUNT", "LEAD_SOURCE","NEXT_STEP", "PROBABILITY", "FISCAL_QUARTER", "AGE", "CREATED_DATE", "FULL_NAME", "ROLLUP_DESCRIPTION" ],
"developerName" : "Deals_Closing_This_Quarter",
"division" : null,
"folderId" : "00lR0000000M8IiIAK",
"groupingsAcross" : [
{ "dateGranularity" : "Month", "name" : "CLOSE_DATE", "sortAggregate" : null, "sortOrder" : "Asc"},
{ "dateGranularity" : "None", "name" : "TYPE", "sortAggregate" : null, "sortOrder" : "Asc" } ],
"groupingsDown" : [
{ "dateGranularity" : "None", "name" : "ACCOUNT_NAME", "sortAggregate" : null, "sortOrder" : "Asc" } ],
"hasDetailRows" : true,
"hasRecordCount" : true,
"historicalSnapshotDates" : [ ],
"id" : "00OR0000000K2UeMAK",
"name" : "Deals Closing This Quarter",
"reportBooleanFilter" : null,
"reportFilters" : [
{ "column" : "BucketField_36625466", "isRunPageEditable" : true, "operator" : "equals", "value" : "Early,Late" },
{ "column" : "TYPE", "isRunPageEditable" : true, "operator" : "equals", "value" : "Existing Business,New Business" } ],
"reportFormat" : "MATRIX",
"reportType" : { "label" : "Opportunities", "type" : "Opportunity" },
"scope" : "organization",
"showGrandTotal" : true,
"showSubtotals" : true,
"sortBy" : [ ],
"standardDateFilter" : { "column" : "CLOSE_DATE", "durationValue" : "THIS_FISCAL_QUARTER", "endDate" : "2015-09-30", "startDate" : "2015-07-01" },
"standardFilters" : [ { "name" : "open", "value" : "all" }, { "name" : "probability", "value" : ">0" } ]
}
}
```

> [sic] `"Fred Wiliamson"`, `"Mircosoft"`는 PDF 원문 오타 그대로 보존. factMap의 `...`(중간 키 생략)는 PDF 원문 표기.

### Example of an asynchronous report run

1. POST(빈 요청 본문)을 Execute Async 리소스 `/services/data/v35.0/analytics/reports/00OR0000000K2UeMAK/instances`로 보내 요약 결과를 요청한다.

```json
{}
```

응답은 결과를 저장하는 instance handle을 반환한다.

```json
{
"completionDate" : null,
"hasDetailRows" : true,
"id" : "0LGR00000000He3OAE",
"ownerId" : "005R0000000Hv5rIAC",
"queryable" : false,
"requestDate" : "2015-08-12T16:05:43Z",
"status" : "New",
"url" : "/services/data/v35.0/analytics/reports/00OR0000000K2UeMAK/instances/0LGR00000000He3OAE"
}
```

2. GET `/services/data/v35.0/analytics/reports/00OR0000000K2UeMAK/instances/0LGR00000000He3OAE`(Instance Results 리소스)로 결과를 가져온다.

```json
{
"attributes" : {
"completionDate" : "2015-08-12T16:05:44Z",
"id" : "0LGR00000000He3OAE",
"ownerId" : "005R0000000Hv5rIAC",
"queryable" : false,
"reportId" : "00OR0000000K2UeMAK",
"reportName" : "Deals Closing This Quarter",
"requestDate" : "2015-08-12T16:05:43Z",
"status" : "Success",
"type" : "ReportInstance" },
"allData" : true,
"factMap" : { /* "2!0_0" 등 동일 구조 dataCells (출처 라인 2380–2552 참조) */ },
"groupingsAcross" : { "groupings" : [ /* ... */ ] },
"groupingsDown" : { "groupings" : [ /* ... */ ] },
"hasDetailRows" : true,
"reportExtendedMetadata" : { /* sync 예제와 동일 */ },
"reportMetadata" : { /* sync 예제와 동일, 단 reportFilters[].isRunPageEditable 가 false */ }
}
```

> 차이점: async 응답의 `reportFilters[].isRunPageEditable`는 `false`(sync 예제는 `true`). 전체 본문은 출처 라인 2380–2552. SEE ALSO: Execute Sync / Instances List / Instance Results.

---

## Get Report Metadata

리포트 메타데이터는 리포트와 그 리포트 타입에 대한 정보를 제공한다 — 필터·그룹핑·상세 데이터·요약에 쓰인 필드 정보 포함. 메타데이터로 다음을 할 수 있다.

> - Find out what fields in the report type you can filter on and by what values.
> - Build custom chart visualizations using the metadata information on fields, groupings, detailed data, and summaries.
> - Change filters in the report metadata during a report run.

To get report metadata, send a GET request to the Describe resource.

**GET** `/services/data/v29.0/analytics/reports/00OD0000001ZbP7MAK/describe` — matrix 리포트(bucket field, groupings, summaries, custom summary formula)의 메타데이터 반환.

응답 구조: `reportTypeMetadata.categories[]`(label "Opportunity Information" + columns CREATED.../TYPE picklist `[Add-On Business, New Business, Services]` — 중간 PDF 원문 `...` 생략), `reportExtendedMetadata`(`detailColumnInfo`: OPPORTUNITY_NAME/PROBABILITY/EXP_AMOUNT/NEXT_STEP/BucketField_34840671; `aggregateColumnInfo`: RowCount/FORMULA1[label "formula1", dataType double, down·acrossGroupingContext "ALL_SUMMARY_LEVELS"]/s!EXP_AMOUNT; `groupingColumnInfo`: CLOSE_DATE[level1]/STAGE_NAME[level0]/ACCOUNT_NAME[level0]/ACCOUNT_LAST_ACTIVITY[level1]), 그리고 `reportMetadata`:

```json
"reportMetadata": {
"name": "Stuck Opportunities",
"id": "00OD0000001ZbP7MAK",
"currency": null,
"developerName": "StuckOpportunities",
"groupingsDown": [
{ "name": "ACCOUNT_NAME", "sortOrder": "Asc", "dateGranularity": "None" },
{ "name": "CLOSE_DATE", "sortOrder": "Desc", "dateGranularity": "FiscalQuarter" } ],
"groupingsAcross": [
{ "name": "STAGE_NAME", "sortOrder": "Desc", "dateGranularity": "None" },
{ "name": "ACCOUNT_LAST_ACTIVITY", "sortOrder": "Asc", "dateGranularity": "Week" } ],
"reportType": { "type": "Opportunity", "label": "Opportunities" },
"aggregates": [ "s!EXP_AMOUNT", "FORMULA1", "RowCount" ],
"reportFormat": "MATRIX",
"reportBooleanFilter": null,
"reportFilters": [
{ "value": "Closed Won,Closed Lost", "column": "STAGE_NAME", "operator": "notEqual" },
{ "value": "50", "column": "PROBABILITY", "operator": "greaterThan" } ],
"detailColumns": [ "OPPORTUNITY_NAME", "PROBABILITY", "EXP_AMOUNT", "NEXT_STEP", "BucketField_34840671" ]
}
```

> 전체 본문은 출처 라인 2580–2725. 깊은 `reportMetadata` 표현형은 [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] 소관. SEE ALSO: Describe.

---

## Get a List of Report Types

> Return a list of analytics notifications using a GET request. *[sic]* — Use a GET request on the Report Type List resource to return a list of report types.

**GET** `/services/data/v39.0/analytics/reportTypes`

응답은 9개 카테고리 그룹 배열이며 각 그룹은 `label` + `reportTypes[]`(각 항목 `describeUrl`/`label`/`type`). 전수 목록:

- **"Accounts & Contacts"** (9): AccountList(Accounts), ContactList(Contacts & Accounts), AccountPartner(Accounts with Partners), AccountTeam(Account with Account Teams), AccountContactRole(Accounts with Contact Roles), AccountAsset(Accounts with Assets), ContactAsset(Contacts with Assets), AccountAuditHistory(Account History), ContactAuditHistory(Contact History)
- **"Opportunities"** (9): Opportunity(Opportunities), OpportunityProduct(Opportunities with Products), OpportunityContact(Opportunities with Contact Roles), OpportunityPartner(Opportunities with Partners), OpportunityCompetitor(Opportunities with Competitors), OpportunityHistory(Opportunity History), OpportunityFieldAuditHistory(Opportunity Field History), OpportunityTrend(Opportunity Trends), OpportunityContactProduct(Opportunities with Contact Roles and Products)
- **"Customer Support Reports"** (9): CaseList(Cases), CaseHistory(Case Lifecycle), CaseContactRole(Cases with Contact Roles), CaseAsset(Cases with Assets), CaseSolution(Cases with Solutions), CaseAuditHistory(Case History), SolutionList(Solutions), SolutionCategory(Solution Categories), SolutionAuditHistory(Solution History)
- **"Leads"** (3): LeadList(Leads), OpportunityLead(Leads with converted lead information), LeadAuditHistory(Lead History)
- **"Activities"** (11): Activity(Tasks and Events), EventAttendee(Events with Invitees), EmailStatus(HTML Email Status), AccountActivity(Activities with Accounts), ContactActivity(Activities with Contacts), OpportunityActivity(Activities with Opportunities), LeadActivity(Activities with Leads), CaseActivity(Activities with Cases), SolutionActivity(Activities with Solutions), ContractActivity(Activities with Contracts), ProductActivity(Activities with Products)
- **"Contracts and Orders"** (8): ContractList(Contracts), ContractAuditHistory(Contract History), ContractOrder(Contracts with Orders), ContractOrderItem(Contracts with Orders and Products), ContractContactRole(Contracts with Contact Roles), OrderList(Orders), OrderItemList(Orders with Products), OrderAuditHistory(Order History)
- **"Price Books, Products and Assets"** (6): ProductList(Products), ProductOpportunity(Products with Opportunities), PricebookProduct(Price Books with Products), ProductAsset(Products with Assets), AssetWithProduct(Assets), AssetCase(Assets with Cases)
- **"Administrative Reports"** (7): User(Users), ReportList(Reports), DocumentList(Documents), LoginIpEmail(New Login Locations), TwoFactorMethodsInfo(Identity Verification Methods), CollabGroup(Collaboration Group Report), CollabGroupFeedPosts(Collaboration Group Feed Posts Report)
- **"File and Content Reports"** (1): File(File and Content Report)

각 `describeUrl` 패턴: `/services/data/v39.0/analytics/reportTypes/{type}`. 전체 verbatim은 출처 라인 2773–3092.

---

## Download Formatted Excel Reports Using the Reports REST API

> You can use the Reports REST API to request reports in printer-friendly Excel format.
>
> To execute a report and obtain the results, the Salesforce Lightning Report Builder issues a REST request to the Analytics API. The API is a POST to the endpoint `/services/data/vXX.x/analytics/reports/<reportId>`.
>
> After the report is created, use a GET request to obtain the results. By default, results are returned in JSON format, which the Report Run page renders. This format is specified in the Accept header information.

> **Note:** This endpoint isn't designed for concurrent export of large formatted reports. To avoid impact on overall system load, don't run more than one large report export at a time.

JSON 대신 Excel을 요청하려면 요청 헤더의 `Accept` 값을 `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`로 바꾼다. GET을 실행하면 Excel 파일이 생성되고, raw 응답에 Excel 파일명이 포함된다(아래 예제에서 PDF는 `Content-Disposition`의 filename을 **bold** 강조).

```http
HTTP/1.1 200 OK
Date: Wed, 06 Jun 2018 17:23:58 GMT
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Content-Security-Policy: upgrade-insecure-requests
Cache-Control: no-cache,must-revalidate,max-age=0,no-store,private
Set-Cookie: BrowserId=YJXhUq42SRyZ3hhgDPFxog;Path=/;Domain=.salesforce.com;Expires=Sun,
05-Aug-2018 17:23:58 GMT;Max-Age=5184000
Expires: Thu, 01 Jan 1970 00:00:00 GMT
Sforce-Limit-Info: api-usage=4/15000
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
Content-Disposition: attachment; filename="New Opportunities Report-2018-05-06-10-23-59.xlsx"
Transfer-Encoding: chunked
```

---

## List Asynchronous Runs of a Report

> You can get as many as 2000 instances of a report for which you requested asynchronous runs by sending a GET request to the Instances List resource. The instance list is sorted by the date when the run was requested. Report results are stored for a rolling 24-hour period.

**GET** `/services/data/v29.0/analytics/reports/00OD0000001ZbP7MAK/instances` — 두 instance 반환.

```json
[
{
"id": "0LGD000000000IyOAI",
"requestDate": "2013-08-12T19:06:47Z",
"status": "Success",
"url": "/services/data/v29.0/analytics/reports/00OD0000001ZbP7MAK/instances/0LGD000000000IyOAI",
"ownerId": "005D0000001KvxRIAS",
"queryable" : false,
"hasDetailRows": false,
"completionDate": "2013-08-12T19:06:48Z"
},
{
"id": "0LGD000000000IjOAI",
"requestDate": "2013-08-12T18:39:06Z",
"status": "Success",
"url": "/services/data/v29.0/analytics/reports/00OD0000001ZbP7MAK/instances/0LGD000000000IjOAI",
"ownerId": "005D0000001KvxRIAS",
"queryable" : false,
"hasDetailRows": false,
"completionDate": "2013-08-12T18:39:07Z"
}
]
```

> SEE ALSO: Instances List.

---

## Filter Reports on Demand

> To get specific results on the fly, filter reports through the API. Filter changes made through the API does not affect the source report definition. Using the API, you can filter with up to 20 custom field filters and add filter logic (such as AND, OR). But standard filters (such as range), filtering by row limit, and cross filters are unavailable.

필터 전에 메타데이터에서 확인하면 좋은 속성:
- `filterable`
- `filterValues`
- `dataTypeFilterOperatorMap`
- `reportFilters`

동기·비동기 실행 시 Execute Sync 또는 Execute Async 리소스에 POST하여 필터링한다.

**예시 (POST to Execute Sync, accounts 리포트 동기 필터):**

```
1. Account Name not equal to Data Mart
2. Account Owner not equal to Admin User
3. Annual Revenue greater than "100,000"
4. Industry not equal to Manufacturing,Recreation
Filter logic: (1 OR 4) AND 2 AND 3.
```

요청 본문:

```json
{
"reportMetadata": {
"name": "FilterAcctsReport",
"id": "00OD0000001cw27MAA",
"reportFormat": "SUMMARY",
"reportBooleanFilter": "(1OR4)AND2AND3",
"reportFilters": [
{ "value": "DataMart", "operator": "notEqual", "column": "ACCOUNT.NAME" },
{ "value": "AdminUser", "operator": "notEqual", "column": "USERS.NAME" },
{ "value": "\"100,000\"", "operator": "greaterThan", "column": "SALES" },
{ "value": "Manufacturing,Recreation", "operator": "notEqual", "column": "INDUSTRY" }
],
"detailColumns": [ "RATING", "LAST_UPDATE", "SALES" ],
"developerName": "Filter_Accts_Report",
"reportType": { "type": "AccountList", "label": "Accounts" },
"currency": null,
"aggregates": [ "s!SALES", "RowCount" ],
"groupingsDown": [
{ "name": "USERS.NAME", "sortAggregate": "s!SALES", "sortOrder": "Desc", "dateGranularity": "None" },
{ "name": "ACCOUNT.NAME", "sortAggregate": null, "sortOrder": "Asc", "dateGranularity": "None" },
{ "name": "DUE_DATE", "sortAggregate": null, "sortOrder": "Asc", "dateGranularity": "Month" }
],
"groupingsAcross": []
}
}
```

응답 본문(factMap 일부 — PDF 원문 `...` 생략 포함):

```json
{
"hasDetailRows": false,
"attributes": {
"describeUrl": "/services/data/v29.0/analytics/reports/00OD0000001cw27MAA/describe",
"instancesUrl": "/services/data/v29.0/analytics/reports/00OD0000001cw27MAA/instances",
"type": "Report",
"reportName": "Filter Accts Report",
"reportId": "00OD0000001cw27MAA"
},
"factMap": {
"1_0!T": { "aggregates": [ { "value": 56000000, "label": "$56,000,000" }, { "value": 1, "label": "1" } ] },
"7_1!T": { "aggregates": [ { "value": 24000000, "label": "$24,000,000" }, { "value": 1, "label": "1" } ] }
},
"allData": true,
"reportMetadata": {
"name": "Filter Accts Report",
"id": "00OD0000001cw27MAA",
"reportFormat": "SUMMARY",
"reportBooleanFilter": "(1 OR 4) AND 2 AND 3",
"reportFilters": [
{ "value": "Data Mart", "operator": "notEqual", "column": "ACCOUNT.NAME" },
{ "value": "Admin User", "operator": "notEqual", "column": "USERS.NAME" },
{ "value": "\"100,000\"", "operator": "greaterThan", "column": "SALES" },
{ "value": "Manufacturing,Recreation", "operator": "notEqual", "column": "INDUSTRY" }
],
"detailColumns": [ "RATING", "LAST_UPDATE", "SALES" ]
}
}
```

> [sic] 주의: 요청 본문 `reportBooleanFilter`는 공백 없는 `"(1OR4)AND2AND3"`, 응답은 공백 있는 `"(1 OR 4) AND 2 AND 3"`. 요청 value도 `"DataMart"`/`"AdminUser"`(공백 없음) vs 응답 `"Data Mart"`/`"Admin User"`. 전체 본문은 출처 라인 3189–3300. SEE ALSO: Execute Sync.

---

## List Recently Viewed Reports

> Get up to 200 of the reports you most recently viewed in Salesforce by sending a GET request to the Report List resource. Each report listing in the response has resource URLs to get metadata and run a report asynchronously or synchronously.

더 폭넓은 리포트 목록은 SOAP API·REST API 등에서 Report 오브젝트를 SOQL로 쿼리한다. 예 — matrix 형식 전체 반환:

```sql
SELECT Description,Format,LastRunDate FROM Report WHERE Format = 'MATRIX' ORDER BY Id ASC NULLS FIRST
```

**GET** `/services/data/v35.0/analytics/reports` — 최근 본 5개 리포트 목록.

```json
[
{ "describeUrl" : "/services/data/v35.0/analytics/reports/00OR0000000K2OmMAK/describe",
  "id" : "00OR0000000K2OmMAK",
  "instancesUrl" : "/services/data/v35.0/analytics/reports/00OR0000000K2OmMAK/instances",
  "name" : "Pipeline By Industry",
  "url" : "/services/data/v35.0/analytics/reports/00OR0000000K2OmMAK" },
{ "describeUrl" : "/services/data/v35.0/analytics/reports/00OR0000000OFXeMAO/describe",
  "id" : "00OR0000000OFXeMAO",
  "instancesUrl" : "/services/data/v35.0/analytics/reports/00OR0000000OFXeMAO/instances",
  "name" : "My Open Pipeline",
  "url" : "/services/data/v35.0/analytics/reports/00OR0000000OFXeMAO" },
{ "describeUrl" : "/services/data/v35.0/analytics/reports/00OR0000000K2UeMAK/describe",
  "id" : "00OR0000000K2UeMAK",
  "instancesUrl" : "/services/data/v35.0/analytics/reports/00OR0000000K2UeMAK/instances",
  "name" : "Deals Closing This Quarter",
  "url" : "/services/data/v35.0/analytics/reports/00OR0000000K2UeMAK" },
{ "describeUrl" : "/services/data/v35.0/analytics/reports/00OR0000000OFHoMAO/describe",
  "id" : "00OR0000000OFHoMAO",
  "instancesUrl" : "/services/data/v35.0/analytics/reports/00OR0000000OFHoMAO/instances",
  "name" : "Sample Report: # of Opportunities",
  "url" : "/services/data/v35.0/analytics/reports/00OR0000000OFHoMAO" },
{ "describeUrl" : "/services/data/v35.0/analytics/reports/00OR0000000JdVOMA0/describe",
  "id" : "00OR0000000JdVOMA0",
  "instancesUrl" : "/services/data/v35.0/analytics/reports/00OR0000000JdVOMA0/instances",
  "name" : "My Leads rpt",
  "url" : "/services/data/v35.0/analytics/reports/00OR0000000JdVOMA0" }
]
```

> SEE ALSO: Report List.

---

## Decode the Fact Map

> Depending on how you run a report, the fact map in the report results can contain values for only summary or both summary and detailed data. The fact map values are expressed as keys, which you can programmatically use to visualize the report data. Fact map keys provide an index into each section of a fact map, from which you can access summary and detailed data.

리포트 형식별 fact map key 패턴:

| Report format | Fact map key pattern |
|---|---|
| Tabular | `T!T`: The grand total of a report. Both record data values and the grand total are represented by this key. |
| Summary | `<First level row grouping_second level row grouping_third level row grouping>!T`: T refers to the row grand total. |
| Matrix | `<First level row grouping_second level row grouping>!<First level column grouping_second level column grouping>`. |

> Each item in a row or column grouping is numbered starting with `0`. Here are some examples of fact map keys:

| Fact Map Key | Description |
|---|---|
| `0!T` | The first item in the first-level grouping. |
| `1!T` | The second item in the first-level grouping. |
| `0_0!T` | The first item in the first-level grouping and the first item in the second-level grouping. |
| `0_1!T` | The first item in the first-level grouping and the second item in the second-level grouping. |

> Fact Map·reportMetadata의 깊은 표현형(스키마·속성 전수)은 [[Reports and Dashboards REST API — Report 표현형]] 및 Reports Namespace(Apex) 노트 소관 — 아래는 예제 맥락 표만 다룬다.

### Tabular Report Fact Map

Tabular 리포트는 그룹핑이 없으므로 모든 레코드 레벨 데이터와 요약이 grand total을 가리키는 `T!T` 키로 표현된다.

> PDF에 다이어그램 있음(p.65, content p.59) — 본 wiki는 텍스트 설명만. pdftoppm 직접 확인: "Preview / Tabular Format" 미리보기로 컬럼 Opportunity Name·Close Date·Probability(%)·Next Step·Expected Revenue, "Data Mart - 44K/10K/2K/..." 17개 레코드, "Grand Totals (17 records) avg 82% $159,150.00", 빨간 말풍선이 `T!T` 키가 그랜드 토탈을 가리킴을 표시.

### Summary Report Fact Map

> PDF에 다이어그램 있음(p.65) — 본 wiki는 텍스트 설명만. pdftoppm 직접 확인: 요약 리포트 미리보기 — Stage: Prospecting(1 record) $45,000.00 → `0!T`; Industry: Manufacturing(1 record) $45,000.00; Acme - Widgets / Acme / $45,000.00 / New Business / 10% / Q2-2013 / 177; Stage: Needs Analysis(1 record) $105,000.00; Industry: Manufacturing(1 record) $105,000.00 → `1_0!T`; Global Gadgets / Global Media / $105,000.00 / Existing Business / 20% / Q2-2013 / 184.

| Fact Map Key | Description |
|---|---|
| `0!T` | Summary for the value of opportunities in the Prospecting stage. |
| `1_0!T` | Summary of the probabilities for the Manufacturing opportunities in the Needs Analysis stage. |

### Matrix Report Fact Map

> PDF에 다이어그램 있음(content p.59) — 매트릭스 리포트 셀 위 fact map key 주석. 본 wiki는 아래 표만 다룬다(표는 텍스트 추출 완전).

| Fact Map Key | Description |
|---|---|
| `0!0` | Total opportunity amount in the Prospecting stage in Q4 2010. |
| `0_0!0_0` | Total opportunity amount in the Prospecting stage in the Manufacturing sector in October 2010. |
| `2_1!1_1` | Total value of opportunities in the Value Proposition stage in the Technology sector in February 2011. |
| `T!T` | Grand total summary for the report. |

> SEE ALSO: Execute Sync / Execute Async.

---

## Get Report Data without Saving Changes to or Creating a Report

> Run a report without creating a report or changing an existing one by making a POST request to the query resource. Get report data without filling up your org with unnecessary reports.

**POST** to query 리소스: `/services/data/v37.0/analytics/reports/query`. 리포트 기준을 `reportMetadata`로 POST 본문에 포함한다(아래는 Opportunities 데이터 요청).

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

응답은 리포트 데이터를 반환하되 리포트를 생성·저장하지 않는다(`attributes.reportId`/`describeUrl`이 `null`인 점이 핵심).

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
{ "label" : "9/19/2013", "value" : "2013-09-19" },
{ "label" : "Closed!", "value" : "Closed!" },
{ "label" : "Closed Won", "value" : "Closed Won" },
{ "label" : "100%", "value" : 100 },
{ "label" : "Q2-2007", "value" : "Q2-2007" },
{ "label" : "0", "value" : 0 },
{ "label" : "1/4/2016", "value" : "2016-01-04" },
{ "label" : "Fred Williamson", "value" : "005D0000001bV42IAE" },
{ "label" : "-", "value" : null },
{ "label" : "Global Media", "value" : "001D000000KtTTqIAN" } ]
}
/* ... 추가 dataCells 행 다수 — salesforce.com - 500 Widgets, Acme - 1,200 Widgets 등 총 9 레코드 (출처 라인 3573–4170) ... */
] }
},
"reportMetadata" : {
/* ...반환 reportMetadata. 주의: 응답에서 "developerName": null, "id": null, "reportFormat": "TABULAR" (요청은 MATRIX였으나 응답은 TABULAR)... */
"folderId" : "00DD000000086ujMAA",
"name" : "Matrix",
"reportFormat" : "TABULAR",
"reportType" : { "label" : "Opportunities", "type" : "Opportunity" },
"scope" : "organization",
"standardDateFilter" : { "column" : "CLOSE_DATE", "durationValue" : "CUSTOM", "endDate" : null, "startDate" : null },
"standardFilters" : [ { "name" : "open", "value" : "all" }, { "name" : "probability", "value" : ">0" } ]
}
}
```

> [sic] 주의: 요청 본문 `reportFormat`=MATRIX 이나 응답 `reportMetadata.reportFormat`=TABULAR, 응답 `id`/`developerName`=null. dataCells 전체(9 레코드)는 출처 라인 3573–4170 verbatim.

---

## Save Changes to Reports

> Save changes to a report by sending a PATCH request to the Report resource.
>
> **Note:** Saving a report deletes any running async report jobs because they will be obsolete.

**예시:** 리포트 00OD0000001cxIE의 이름을 "myUpdatedReport"로 바꾸고 폴더 변경. **PATCH** `/services/data/v34.0/analytics/reports/00OD0000001cxIE`.

요청 본문:

```json
{
"reportMetadata" : {
"name":"myUpdatedReport",
"folderId":"00DD00000007enH"}
}
```

응답 본문(PDF 원문에서 `reportExtendedMetadata`/`reportTypeMetadata`는 `...`로 생략):

```json
{
"reportExtendedMetadata" : { /* ... */ },
"reportMetadata" : {
"aggregates" : [ "RowCount" ],
"chart" : null,
"currency" : null,
"description" : null,
"detailColumns" : [ "USERS.NAME", "ACCOUNT.NAME", "TYPE", "DUE_DATE", "LAST_UPDATE", "ADDRESS1_STATE" ],
"developerName" : "myreport",
"division" : null,
"folderId" : "00DD00000007enHMAQ",
"groupingsAcross" : [ ],
"groupingsDown" : [ ],
"hasDetailRows" : true,
"hasRecordCount" : true,
"historicalSnapshotDates" : [ ],
"id" : "00OD0000001cxIEMAY",
"name" : "myUpdatedReport",
"reportBooleanFilter" : null,
"reportFilters" : [ ],
"reportFormat" : "TABULAR",
"reportType" : { "label" : "Accounts", "type" : "AccountList" },
"scope" : "user",
"showGrandTotal" : true,
"showSubtotals" : true,
"sortBy" : [ ],
"standardDateFilter" : { "column" : "CREATED_DATE", "durationValue" : "CUSTOM", "endDate" : null, "startDate" : null },
"standardFilters" : null },
"reportTypeMetadata" : { /* ... */ }
}
```

---

## Clone Reports

> Creates a copy of a custom, standard, or public report by sending a POST request to the Report List resource.

**예시:** 리포트 00OD0000001cxIE를 클론, 이름 "myNewReport". **POST** `/services/data/v34.0/analytics/reports?cloneId=00OD0000001cxIE`.

요청 본문:

```json
{ "reportMetadata" :
{"name":"myNewReport"}
}
```

응답 본문(PDF 원문에서 `reportExtendedMetadata`/`reportTypeMetadata`는 `...`로 생략):

```json
{
"reportExtendedMetadata" : { /* ... */ },
"reportMetadata" : {
"aggregates" : [ "RowCount" ],
"chart" : null,
"currency" : null,
"description" : null,
"detailColumns" : [ "USERS.NAME", "ACCOUNT.NAME", "TYPE", "DUE_DATE", "LAST_UPDATE", "ADDRESS1_STATE" ],
"developerName" : "myreport2",
"division" : null,
"folderId" : "005D0000001UlszIAC",
"groupingsAcross" : [ ],
"groupingsDown" : [ ],
"hasDetailRows" : true,
"hasRecordCount" : true,
"historicalSnapshotDates" : [ ],
"id" : "00OD0000001jabSMAQ",
"name" : "myNewReport",
"reportBooleanFilter" : null,
"reportFilters" : [ ],
"reportFormat" : "TABULAR",
"reportType" : { "label" : "Accounts", "type" : "AccountList" },
"scope" : "user",
"showGrandTotal" : true,
"showSubtotals" : true,
"sortBy" : [ ],
"standardDateFilter" : { "column" : "CREATED_DATE", "durationValue" : "CUSTOM", "endDate" : null, "startDate" : null },
"standardFilters" : null },
"reportTypeMetadata" : { /* ... */ }
}
```

---

## Delete Reports

> Delete a report by sending a DELETE request to the Report resource. Deleted reports are moved to the Recycle Bin.
>
> **Note:** Deleting a report also cancels any running async report jobs and deletes all scheduled notifications.

**예시:** **DELETE** `/services/data/v34.0/analytics/reports/00OD0000001cxIE` — 리포트를 삭제하고 본문 없는 `204` HTTP 응답 코드를 반환한다.

---

## 관련 노트

- [[Reports and Dashboards REST API — Report 표현형]]
- [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]]
- [[Reports and Dashboards REST API — Execute·Instances·Report List 표현형]] — 위 Run sync/async·Instances 예제가 반환하는 표현형(factMap 포함) 정본
- [[Reports and Dashboards REST API — Query 표현형]] — 위 "Get Report Data without Saving"(query 리소스) 표현형 정본
- [[Reports and Dashboards REST API — Dashboards·Downloads·Notifications 예제]]
- [[Reports Namespace]] — Apex `Reports` 네임스페이스(ReportResults·ReportFactWithDetails·factMap 등 Apex 표현형)
- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]] — 같은 Analytics REST 계열 인접 가이드
- [[Analytics 개요 — 표준 리포팅 vs CRM Analytics·API 선택 가이드]] — 표준 리포팅 vs CRM Analytics 세계 구분·API 선택. 이 REST API가 표준 세계에 속함·언제 Apex/CRM Analytics 대신 고르는지 오리엔테이션
