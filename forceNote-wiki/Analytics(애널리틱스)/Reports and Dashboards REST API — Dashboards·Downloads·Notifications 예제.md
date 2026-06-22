---
tags: [analytics, dashboards, rest-api, reports-dashboards-rest, dashboard-results, analytics-notifications]
source: salesforce_analytics_rest_api.pdf (Reports and Dashboards REST API Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Dashboards REST API, 대시보드 REST API, Refresh Dashboard, Dashboard Results, Analytics Notification, CRM Analytics download]
---

# Reports and Dashboards REST API — Dashboards · Downloads · Notifications 예제

> Reports and Dashboards REST API의 Dashboards(목록·결과·필터·상태·새로고침·저장·Custom LWC Beta·Sticky 필터·컴포넌트 상세·메타데이터·복제·삭제) + Downloads(CRM Analytics PDF/PNG·LEX PNG) + Notifications(조회·생성·저장·삭제·한도 확인) 예제를 공식 가이드 v67.0 Summer '26에서 verbatim 추출한 노트.

---

> ℹ️ **소스 주의 — 버전 verbatim.** 가이드 자체는 v67.0이지만 각 예제 URI의 API 버전은 소스에 박힌 옛 버전(v31.0 / v34.0 / v35.0 / v36.0 / v37.0 / v38.0 / v40.0)을 **그대로** 유지한다. 임의로 v67.0으로 통일하지 않는다.
>
> ℹ️ **깊은 Dashboard 표현형(factMap·groupings·reportMetadata·buckets 등 응답 JSON 속성의 정의·필드 의미)은 이 노트의 소관이 아니다.** 본 노트는 *예제(요청/응답 JSON·HTTP)* 만 다룬다. 각 속성의 reference 정의는 Reports and Dashboards REST API Reference 노트(Dashboards 표현형) 소관 — 미작성 상태라 plain-text로만 표기한다.
>
> ℹ️ **[sic] 보존 표기들** (소스 원문 오류·표기 불일치를 그대로 둠): `savedViewId`(URI, 대문자 V) vs `savedviewId`(파라미터 표, 소문자 v) · `devloperName`(developer 오타) · `Fred Wiliamson`(Williamson 오타) · Custom LWC Beta 응답이 `components" : [{`로 시작(여는 `{`·`"` 누락) · LEX Report 다운로드 URI 확장자가 `.pdf`인데 제목·설명은 PNG.

---

## 1. Dashboards 예제

> Learn how to refresh, create, edit, copy, and delete dashboards.

### 1.1 Get List of Recently Used Dashboards

You can get a list of recently used dashboards by using the Dashboard resource. Use a GET request on the Dashboard List resource. The list is sorted by the date when the dashboard was last refreshed.

**GET** (Dashboard List resource)

```
/services/data/v35.0/analytics/dashboards
```

응답 — 두 개의 dashboard 정보를 반환. 각 URL handle은 status / results를 저장한다.

```json
[ {
"id" : "01ZD00000007QeuMAE",
"name" : "Adoption Dashboard",
"statusUrl" : "/services/data/v35.0/analytics/dashboards/01ZD00000007QeuMAE/status",
"url" : "/services/data/v35.0/analytics/dashboards/01ZD00000007QeuMAE"
}, {
"id" : "01ZD00000007QevMAE",
"name" : "Global Sales Dashboard",
"statusUrl" : "/services/data/v35.0/analytics/dashboards/01ZD00000007QevMAE/status",
"url" : "/services/data/v35.0/analytics/dashboards/01ZD00000007QevMAE"
} ]
```

SEE ALSO: Dashboard List

### 1.2 Get Dashboard Results

You can get dashboard metadata, data, and status by sending a GET request to the Dashboard Results resource. 응답은 다음을 포함한다.

- **Metadata** — dashboard ID, name, component metadata, dashboard filters 등 dashboard 전체 정보.
- **Data** — 각 컴포넌트의 underlying report data. 선택적 filter 파라미터로 필터링됨 (→ 1.3 Filter Dashboard Results).
- **Status** — 각 컴포넌트의 data·refresh 상태. data status는 `NODATA` · `DATA` · `ERROR`. 에러 시 컴포넌트 status에 error code·message·severity 속성이 추가된다. refresh status는 컴포넌트 실행 완료 시 `IDLE`, 아직 새로고침 중이면 `RUNNING`.

**GET** (Dashboard Results resource)

```
/services/data/v31.0/analytics/dashboards/01ZD00000007S89MAE
```

응답 — 다음 구조를 반환한다 (factMap·groupings·reportMetadata 등 깊은 표현형은 Reference 노트 소관, 여기서는 예제 JSON verbatim).

```json
{
"componentData" : [ {
"componentId" : "01aD0000000a36LIAQ",
"reportResult" : {
"attributes" : null,
"allData" : true,
"factMap" : {
"T!T" : {
"aggregates" : [ {
"label" : "USD 67,043,365.50",
"value" : 67043365.50166918337345123291015625
} ]
},
"0!T" : {
"aggregates" : [ {
"label" : "USD 10,083.33",
"value" : 10083.333333333333939663134515285491943359375
} ]
},
"1!T" : {
"aggregates" : [ {
"label" : "USD 25,016,768.67",
"value" : 25016768.670066006481647491455078125
} ]
},
"2!T" : {
"aggregates" : [ {
"label" : "USD 42,016,513.50",
"value" : 42016513.49826984107494354248046875
} ]
}
},
"groupingsAcross" : null,
"groupingsDown" : {
"groupings" : [ {
"groupings" : [ ],
"key" : "0",
"label" : "-",
"value" : null
}, {
"groupings" : [ ],
"key" : "1",
"label" : "Existing Business",
"value" : "Existing Business"
}, {
"groupings" : [ ],
"key" : "2",
"label" : "New Business",
"value" : "New Business"
} ]
},
"hasDetailRows" : false,
"reportExtendedMetadata" : {
"aggregateColumnInfo" : {
"s!AMOUNT" : {
"acrossGroupingContext" : null,
"dataType" : "currency",
"downGroupingContext" : null,
"label" : "Sum of Amount"
}
},
"detailColumnInfo" : { },
"groupingColumnInfo" : {
"TYPE" : {
"dataType" : "picklist",
"groupingLevel" : 0,
"label" : "Type"
}
}
},
"reportMetadata" : {
"aggregates" : [ "s!AMOUNT" ],
"chart" : null,
"currency" : "USD",
"description" : null,
"detailColumns" : [ ],
"developerName" : "Simple_Test",
"division" : null,
"folderId" : "00lR0000000M8IiIAK",
"groupingsAcross" : [ ],
"groupingsDown" : [ {
"dateGranularity" : "None",
"name" : "TYPE",
"sortAggregate" : null,
"sortOrder" : "Asc"
} ],
"hasDetailRows" : false,
"hasRecordCount" : true,
"historicalSnapshotDates" : [ ],
"id" : "00OD0000001g2nWMAQ",
"name" : "Simple Test",
"reportBooleanFilter" : null,
"reportFilters" : [ ],
"reportFormat" : "SUMMARY",
"reportType" : {
"label" : "Opportunities",
"type" : "Opportunity"
},
"scope" : "organization",
"showGrandTotal" : true,
"showSubtotals" : true,
"sortBy" : [ ],
"standardDateFilter" : { "column" : "CLOSE_DATE", "durationValue" : "CUSTOM",
"endDate" : null, "startDate" : null },
"standardFilters" : [
{ "name" : "open", "value" : "all" },
{ "name" : "probability", "value" : ">0" } ]
}
},
"status" : {
"dataStatus" : "DATA",
"errorCode" : null,
"errorMessage" : null,
"errorSeverity" : null,
"refreshDate" : "2014-04-09T00:28:16.000+0000",
"refreshStatus" : "IDLE"
}
} ],
"dashboardMetadata" : {
"attributes" : {
"dashboardId" : "01ZD00000007S89MAE",
"dashboardName" : "Simple Dashboard",
"statusUrl" : "/services/data/v31.0/analytics/dashboards/01ZD00000007S89MAE/status",
"type" : "Dashboard"
},
"canChangeRunningUser" : false,
"components" : [ {
"componentData" : 0,
"footer" : null,
"header" : null,
"id" : "01aD0000000a36LIAQ",
"properties" : {
"aggregates" : [ { "name" : "s!AMOUNT" } ],
"autoSelectColumns" : false,
"groupings" : null,
"maxRows" : null,
"sort" : { "column" : "TYPE", "sortOrder" : "asc" },
"useReportChart" : false,
"visualizationProperties" : {
"breakPoints" : [ {
"aggregateName" : "s!AMOUNT",
"breaks" : [
{ "color" : "000000", "lowerBound" : null, "upperBound" : -1 },
{ "color" : "000000", "lowerBound" : -1, "upperBound" : 0 },
{ "color" : "000000", "lowerBound" : 0, "upperBound" : null } ]
} ],
"metricLabel" : null },
"visualizationType" : "Metric" },
"reportId" : "00OD0000001g2nWMAQ",
"title" : null,
"type" : "Report"
} ],
"description" : null,
"developerName" : "Simple_Dashboard",
"filters" : [ {
"name" : "Amount",
"options" : [ {
"alias" : null,
"endValue" : null,
"id" : "0ICD00000004CBiOAM",
"operation" : "greaterThan",
"startValue" : null,
"value" : "USD 2000000"
} ],
"selectedOption" : null
} ],
"folderId" : "00lR0000000DrojIAC",
"id" : "01ZD00000007S89MAE",
"layout" : {
"columns" : [ {
"components" : [ 0 ]
} ]
},
"name" : "Simple Dashboard",
"runningUser" : {
"displayName" : "Allison Wheeler",
"id" : "005D00000016V2qIAE"
}
}
}
```

SEE ALSO: Dashboard Results

### 1.3 Filter Dashboard Results

You can filter dashboard results, status, or refresh requests, by using filter parameters. Dashboard results are always unfiltered, unless you have specified filter parameters in your request. 요청에 최대 3개의 선택적 필터 파라미터 `filter1`, `filter2`, `filter3`를 지정할 수 있다. 이 파라미터에는 해당 dashboard에 현재 정의된 필터에서 선택한 filter option을 적용한다. 필터를 적용할 수 있는 요청:

- A GET request on the Dashboard Results resource: returns data filtered by the specified parameters.
- A PUT request on the Dashboard Results resource: refreshes the data that has been filtered by the specified parameters.
- A GET request on the Dashboard Status resource: returns status for the data that has been filtered by the specified parameters.

하나의 필터("Country")와 두 개의 옵션("United States", "Canada")을 가진 dashboard는 dashboard metadata에서 다음처럼 보인다.

```json
{
"dashboardMetadata" : {
...
"filters" : [ {
"name" : "Country",
"options" : [ {
"id" : "0ICxx0000000001GAA",
"alias" : "United States",
"operation" : "equals",
"value" : "US",
"startValue" : null,
"endValue" : null
} ], [ {
"id" : "0ICxx0000000002GAA",
"alias" : "Canada",
"operation" : "equals",
"value" : "CA",
"startValue" : null,
"endValue" : null
} ],
...
}
```

"Country equals Canada"로 필터링된 결과를 얻으려면 다음 GET 요청을 보낸다.

```
/services/data/v31.0/analytics/dashboards/01Zxx0000000000000?filter1=0ICxx0000000002GAA
```

SEE ALSO: Dashboard Results / Dashboard Status

### 1.4 Get Dashboard Status

You can get the dashboard status by sending a GET request to the Dashboard Status resource. 각 컴포넌트의 status를 새로고침된 순서대로 반환한다. 컴포넌트가 현재 새로고침 중이 아니면 `IDLE`, 새로고침 중이면 `RUNNING`을 반환한다.

**GET** (Dashboard Status resource)

ID가 `01ZD00000007QevMAE`인 dashboard의 status 조회:

```
/services/data/v31.0/analytics/dashboards/01ZD00000007QevMAE/status
```

응답 — 각 컴포넌트의 status와 새로고침 일시.

```json
{
"componentStatus" : [ {
"componentId" : "01aD0000000J7M7",
"refreshDate" : "2014-03-10T17:26:07.000+0000",
"refreshStatus" : "IDLE"
}, {
"componentId" : "01aD0000000J7M9",
"refreshDate" : "2014-03-10T17:26:08.000+0000",
"refreshStatus" : "IDLE"
}, {
"componentId" : "01aD0000000J7MB",
"refreshDate" : "2014-03-10T17:26:09.000+0000",
"refreshStatus" : "IDLE"
} ]
}
```

SEE ALSO: Dashboard Status

### 1.5 Refresh a Dashboard

You can refresh a dashboard by using a PUT Dashboard Results request. Dynamic dashboards can also be refreshed via the REST API. refresh 응답은 새로고침이 트리거된 후 status resource의 URL을 반환한다. PUT 요청에 filter 파라미터가 포함되면 필터링된 데이터만 새로고침된다 (→ 1.3 Filter Dashboard Results).

**PUT** (Dashboard Results resource)

ID가 `01ZD00000007S89MAE`인 dashboard를 새로고침:

```
/services/data/v31.0/analytics/dashboards/01ZD00000007S89MAE
```

요청 본문: None required.

응답 — 새로고침된 dashboard의 status URL.

```json
{
"statusUrl" : "/services/data/v31.0/analytics/dashboards/01ZD00000007S89MAE/status"
}
```

SEE ALSO: Dashboard Results

### 1.6 Save a Dashboard

You can save changes to a dashboard by sending a PATCH request to the Dashboard Results resource.

**PATCH** (Dashboard Results resource)

```
/services/data/v31.0/analytics/dashboards/01ZD00000007S89MAE
```

요청 본문:

```json
{
"dashboardMetadata" : {
"name" : "Sales Dashboard",
}
}
```

응답 (소스의 예제 불일치를 verbatim 보존 — 요청 본문은 `name`을 "Sales Dashboard"로 PATCH하나 응답 `dashboardMetadata.attributes.dashboardName`은 "Service Dept Dashboard", 하단 `dashboardMetadata.name`은 "Simple Dashboard"로 혼재):

```json
{
"componentData" : [ {
"componentId" : "01aD0000000a36LIAQ",
"reportResult" : {
"attributes" : null,
"allData" : true,
"factMap" : {
"T!T" : {
"aggregates" : [ {
"label" : "USD 67,043,365.50",
"value" : 67043365.50166918337345123291015625
} ]
},
"0!T" : {
"aggregates" : [ {
"label" : "USD 10,083.33",
"value" : 10083.333333333333939663134515285491943359375
} ]
},
"1!T" : {
"aggregates" : [ {
"label" : "USD 25,016,768.67",
"value" : 25016768.670066006481647491455078125
} ]
},
"2!T" : {
"aggregates" : [ {
"label" : "USD 42,016,513.50",
"value" : 42016513.49826984107494354248046875
} ]
}
},
"groupingsAcross" : null,
"groupingsDown" : {
"groupings" : [ {
"groupings" : [ ],
"key" : "0",
"label" : "-",
"value" : null
}, {
"groupings" : [ ],
"key" : "1",
"label" : "Existing Business",
"value" : "Existing Business"
}, {
"groupings" : [ ],
"key" : "2",
"label" : "New Business",
"value" : "New Business"
} ]
},
"hasDetailRows" : false,
"reportExtendedMetadata" : {
"aggregateColumnInfo" : {
"s!AMOUNT" : {
"acrossGroupingContext" : null,
"dataType" : "currency",
"downGroupingContext" : null,
"label" : "Sum of Amount"
}
},
"detailColumnInfo" : { },
"groupingColumnInfo" : {
"TYPE" : {
"dataType" : "picklist",
"groupingLevel" : 0,
"label" : "Type"
}
}
},
"reportMetadata" : {
"aggregates" : [ "s!AMOUNT" ],
"chart" : null,
"currency" : "USD",
"description" : null,
"detailColumns" : [ ],
"developerName" : "Simple_Test",
"division" : null,
"folderId" : "00lR0000000M8IiIAK",
"groupingsAcross" : [ ],
"groupingsDown" : [ {
"dateGranularity" : "None",
"name" : "TYPE",
"sortAggregate" : null,
"sortOrder" : "Asc"
} ],
"hasDetailRows" : false,
"hasRecordCount" : true,
"historicalSnapshotDates" : [ ],
"id" : "00OD0000001g2nWMAQ",
"name" : "Simple Test",
"reportBooleanFilter" : null,
"reportFilters" : [ ],
"reportFormat" : "SUMMARY",
"reportType" : {
"label" : "Opportunities",
"type" : "Opportunity"
},
"scope" : "organization",
"showGrandTotal" : true,
"showSubtotals" : true,
"sortBy" : [ ],
"standardDateFilter" : { "column" : "CLOSE_DATE", "durationValue" : "CUSTOM",
"endDate" : null, "startDate" : null },
"standardFilters" : [
{ "name" : "open", "value" : "all" },
{ "name" : "probability", "value" : ">0" } ]
}
},
"status" : {
"dataStatus" : "DATA",
"errorCode" : null,
"errorMessage" : null,
"errorSeverity" : null,
"refreshDate" : "2014-04-09T00:28:16.000+0000",
"refreshStatus" : "IDLE"
}
} ],
"dashboardMetadata" : {
"attributes" : {
"dashboardId" : "01ZD00000007S89MAE",
"dashboardName" : "Service Dept Dashboard",
"statusUrl" : "/services/data/v31.0/analytics/dashboards/01ZD00000007S89MAE/status",
"type" : "Dashboard"
},
"canChangeRunningUser" : false,
"components" : [ {
"componentData" : 0,
"footer" : null,
"header" : null,
"id" : "01aD0000000a36LIAQ",
"properties" : {
"aggregates" : [ { "name" : "s!AMOUNT" } ],
"autoSelectColumns" : false,
"groupings" : null,
"maxRows" : null,
"sort" : { "column" : "TYPE", "sortOrder" : "asc" },
"useReportChart" : false,
"visualizationProperties" : {
"breakPoints" : [ {
"aggregateName" : "s!AMOUNT",
"breaks" : [
{ "color" : "000000", "lowerBound" : null, "upperBound" : -1 },
{ "color" : "000000", "lowerBound" : -1, "upperBound" : 0 },
{ "color" : "000000", "lowerBound" : 0, "upperBound" : null } ]
} ],
"metricLabel" : null },
"visualizationType" : "Metric" },
"reportId" : "00OD0000001g2nWMAQ",
"title" : null,
"type" : "Report"
} ],
"description" : null,
"developerName" : "Simple_Dashboard",
"filters" : [ {
"name" : "Amount",
"options" : [ {
"alias" : null,
"endValue" : null,
"id" : "0ICD00000004CBiOAM",
"operation" : "greaterThan",
"startValue" : null,
"value" : "USD 2000000"
} ],
"selectedOption" : null
} ],
"folderId" : "00lR0000000DrojIAC",
"id" : "01ZD00000007S89MAE",
"layout" : {
"columns" : [ {
"components" : [ 0 ]
} ]
},
"name" : "Simple Dashboard",
"runningUser" : {
"displayName" : "Allison Wheeler",
"id" : "005D00000016V2qIAE"
}
}
}
```

### 1.7 Save a Dashboard with a Custom Lightning Web Component (Beta)

You can save a dashboard with a custom Lightning web component by sending a PATCH request to the Dashboard Results resource.

> **Note (Beta):** This feature is a pilot or beta service that is subject to the Beta Services Terms at Agreements - Salesforce.com or a written Unified Pilot Agreement if executed by Customer, and applicable terms in the Product Terms Directory. Use of this pilot or beta service is at the Customer's sole discretion.

**PATCH** (Dashboard Results resource)

```
/services/data/v31.0/analytics/dashboards/01ZD00000007S89MAE
```

요청 본문:

```json
{
"components": [{
"header": "",
"properties": {
"content": {
"componentParameters":
"{\"componentApiName\":\"c:kpiDashboard\",\"properties\":\"{\\\"maxCards\\\":1,\\\"showProgressBars\\\":true,\\\"showSummary\\\":false}\"}"
},
"visualizationType": "LightningWebComponent"
},
"type": "Dashboard",
"componentData": 0
}]
}
```

응답 ([sic] — 소스가 여는 `{`·`"` 누락된 채 `components" : [{`로 시작. verbatim 보존):

```json
components" : [{
"chartTheme" : null,
"componentData" : null,
"footer" : null,
"header" : null,
"id" : "01aSG0000088inFYAQ",
"lastModifiedDate" : "2025-12-18T05:03:56Z",
"properties" : {
"content" : {
"componentParameters" :
"{\"componentApiName\":\"c:kpiDashboard\",\"properties\":\"{\\\"maxCards\\\":1,\\\"showProgressBars\\\":true,\\\"showSummary\\\":false}\"}"
},
"visualizationType" : "LightningWebComponent"
},
"reportId" : null,
"title" : null,
"type" : "Dashboard"
}]
```

### 1.8 Set a Sticky Dashboard Filter

Set a default filter value which gets applied to a dashboard when you open it. The default filter value you specify only applies to you (other people won't see it when they open the dashboard). If you change the filter value while viewing the dashboard, then the filter value you set in the user interface overwrites the value you set via the API. To set sticky filters for a dashboard, `canUseStickyFilter` must equal true.

Dashboard Results resource에 PATCH 요청을 보내고 파라미터 `isStickyFilterSave=true`를 붙인다. 요청 본문에서 `selectedOption` 속성을 적용할 filter option의 index로 설정한다.

**PATCH** (Dashboard Results resource) + query `isStickyFilterSave=true`

```
/services/data/v40.0/analytics/dashboards/0IBR00000004D4iOAE?isStickyFilterSave=true
```

요청 본문:

```json
{
"filters" : [ {
"errorMessage" : null,
"id" : "0IBR00000004D4iOAE",
"name" : "Billing City",
"options" : [ {
"alias" : "New York City",
"endValue" : null,
"id" : "0ICR00000004FtQOAU",
"operation" : "equals",
"startValue" : null,
"value" : "New York City"
}, {
"alias" : "Chicago",
"endValue" : null,
"id" : "0ICR00000004FtROAU",
"operation" : "equals",
"startValue" : null,
"value" : "Chicago"
}, {
"alias" : "Los Angeles",
"endValue" : null,
"id" : "0ICR00000004FtSOAU",
"operation" : "equals",
"startValue" : null,
"value" : "Los Angeles"
}
],
"selectedOption" : 1
}
]
}
```

응답: If successful, an empty response body is returned.

### 1.9 Return Details About Dashboard Components

Get details about one or more dashboard components using a POST request. Specify which dashboard components you want details about using `componentIds` in the request body. **Available in API versions 36.0 and later.**

**POST** (Dashboard Results resource)

```
/services/data/v36.0/analytics/dashboards/01ZR00000008h2EMAQ
```

요청 본문:

```json
{
"componentIds": ["01aR00000005aT4IAI", "01aR00000005aT5IAI"]
}
```

응답 — 두 개 컴포넌트에 대한 `componentData`(factMap·groupingsDown·reportExtendedMetadata·reportMetadata)와 dashboard `attributes`(describeUrl·statusUrl 포함)를 반환한다. 응답 본문 시작 구조:

```json
{
"attributes" : {
"dashboardId" : "01ZR00000008h2EMAQ",
"dashboardName" : "Liz's Sales Manager Dashboard",
"describeUrl" :
"/services/data/v37.0/analytics/dashboards/01ZR00000008h2EMAQ/describe",
"statusUrl" : "/services/data/v37.0/analytics/dashboards/01ZR00000008h2EMAQ/status",
"type" : "Dashboard"
},
"componentData" : [ {
"componentId" : "01aR00000005aT4IAI",
"reportResult" : {
"attributes" : null,
"allData" : true,
"factMap" : { ... },
"groupingsDown" : { ... },
"reportExtendedMetadata" : { ... },
"reportMetadata" : {
"aggregates" : [ "s!AMOUNT" ],
"buckets" : [ {
"bucketType" : "picklist",
"devloperName" : "BucketField_47575792",
"label" : "Industry",
...
}, {
"bucketType" : "picklist",
"devloperName" : "BucketField_36625466",
"label" : "Stage",
...
} ],
...
}
}
}, {
"componentId" : "01aR00000005aT5IAI",
...
} ]
}
```

> ⚠️ **응답 본문 일부 생략.** 이 응답은 두 컴포넌트의 전체 factMap·groupings·buckets(`reportMetadata.buckets`의 picklist 버킷 값·`sourceDimensionValues` 전체)·reportFilters 등을 포함하는 매우 긴 JSON이다. 그 속성들의 정의·필드 의미는 **Reports and Dashboards REST API Reference(Dashboards·Report Metadata 표현형) 노트 소관**(미작성)이므로 여기서는 응답 골격과 [sic] 항목만 남긴다.
> - **[sic] 보존:** `reportMetadata.buckets[].devloperName`(developer 오타) — 원본에 `BucketField_47575792`·`BucketField_36625466` 두 버킷 모두 `devloperName`으로 표기됨. verbatim.

### 1.10 Get Dashboard Metadata

Get details about dashboard metadata using a GET request. Use a GET request on the Dashboard Describe resource to get metadata for the specified dashboard, including dashboard components, filters, layout, and the running user.

**GET** (Dashboard Describe resource)

```
/services/data/v37.0/analytics/dashboards/01ZR00000004SknMAE/describe
```

응답 — 7개 컴포넌트(Line·Funnel·Gauge·Scatter·Table·Column·Bar)와 3개 filters(Closed·Account Type·Annual Revenue), layout, running user를 반환한다.

```json
{
"canChangeRunningUser" : true,
"components" : [ {
"componentData" : 0,
"footer" : null,
"header" : null,
"id" : "01aR00000005kCmIAI",
"properties" : {
"aggregates" : [ {
"name" : "s!AMOUNT"
} ],
"autoSelectColumns" : true,
"filterColumns" : [ {
"label" : "Closed",
"name" : "CLOSED"
}, {
"label" : "Account Type",
"name" : "ACCOUNT_TYPE"
}, {
"label" : "Annual Revenue",
"name" : "SALES"
} ],
"groupings" : [ {
"name" : "STAGE_NAME"
} ],
"maxRows" : null,
"sort" : {
"column" : "STAGE_NAME",
"sortOrder" : "asc"
},
"useReportChart" : false,
"visualizationProperties" : {
"axisRange" : {
"max" : null,
"min" : null,
"rangeType" : "auto"
},
"groupByType" : "cumulative",
"legendPosition" : "Bottom",
"showValues" : false
},
"visualizationType" : "Line"
},
"reportId" : "00OR0000000JizXMAS",
"title" : null,
"type" : "Report"
}, {
"componentData" : 1,
"footer" : null,
"header" : null,
"id" : "01aR00000005awVIAQ",
"properties" : {
"aggregates" : [ {
"name" : "s!AMOUNT"
} ],
"autoSelectColumns" : true,
"filterColumns" : [ {
"label" : "Closed",
"name" : "CLOSED"
}, {
"label" : "Account Type",
"name" : "ACCOUNT_TYPE"
}, {
"label" : "Annual Revenue",
"name" : "SALES"
} ],
"groupings" : [ {
"name" : "STAGE_NAME"
} ],
"maxRows" : null,
"sort" : {
"column" : "STAGE_NAME",
"sortOrder" : "asc"
},
"useReportChart" : false,
"visualizationProperties" : {
"combineSmallGroups" : true,
"legendPosition" : "Bottom",
"showPercentages" : false,
"showValues" : true
},
"visualizationType" : "Funnel"
},
"reportId" : "00OR0000000OFXeMAO",
"title" : null,
"type" : "Report"
}, {
"componentData" : 2,
"footer" : null,
"header" : null,
"id" : "01aR00000005awTIAQ",
"properties" : {
"aggregates" : [ {
"name" : "s!AMOUNT"
} ],
"autoSelectColumns" : true,
"filterColumns" : [ {
"label" : "Closed",
"name" : "CLOSED"
}, {
"label" : "Account Type",
"name" : "ACCOUNT_TYPE"
}, {
"label" : "Annual Revenue",
"name" : "SALES"
} ],
"groupings" : null,
"maxRows" : null,
"sort" : null,
"useReportChart" : false,
"visualizationProperties" : {
"breakPoints" : [ {
"aggregateName" : "s!AMOUNT",
"breaks" : [ {
"color" : "c25454",
"lowerBound" : 100000,
"upperBound" : 300000
}, {
"color" : "c2c254",
"lowerBound" : 300000,
"upperBound" : 800000
}, {
"color" : "54c254",
"lowerBound" : 800000,
"upperBound" : 1000000
} ]
} ],
"showPercentages" : false,
"showTotal" : false
},
"visualizationType" : "Gauge"
},
"reportId" : "00OR0000000JizXMAS",
"title" : null,
"type" : "Report"
}, {
"componentData" : 3,
"footer" : null,
"header" : null,
"id" : "01aR00000005kCnIAI",
"properties" : {
"aggregates" : [ {
"name" : "s!AMOUNT"
}, {
"name" : "a!AMOUNT"
} ],
"autoSelectColumns" : false,
"filterColumns" : [ {
"label" : "Closed",
"name" : "CLOSED"
}, {
"label" : "Account Type",
"name" : "ACCOUNT_TYPE"
}, {
"label" : "Annual Revenue",
"name" : "SALES"
} ],
"groupings" : [ {
"name" : "STAGE_NAME"
}, {
"name" : "TYPE"
} ],
"maxRows" : null,
"sort" : {
"column" : "STAGE_NAME",
"sortOrder" : "asc"
},
"useReportChart" : false,
"visualizationProperties" : {
"axisRange" : {
"max" : null,
"min" : null,
"rangeType" : "auto"
},
"groupByType" : "grouped",
"legendPosition" : "Bottom"
},
"visualizationType" : "Scatter"
},
"reportId" : "00OR0000000JizXMAS",
"title" : null,
"type" : "Report"
}, {
"componentData" : 4,
"footer" : null,
"header" : "My Table",
"id" : "01aR00000005awUIAQ",
"properties" : {
"aggregates" : [ {
"name" : "s!AMOUNT"
} ],
"autoSelectColumns" : false,
"filterColumns" : [ {
"label" : "Closed",
"name" : "CLOSED"
}, {
"label" : "Account Type",
"name" : "ACCOUNT_TYPE"
}, {
"label" : "Annual Revenue",
"name" : "SALES"
} ],
"groupings" : [ {
"name" : "INDUSTRY"
}, {
"name" : "CLOSE_DATE"
} ],
"maxRows" : null,
"sort" : {
"column" : "INDUSTRY",
"sortOrder" : "asc"
},
"useReportChart" : false,
"visualizationProperties" : {
"breakPoints" : [ {
"aggregateName" : "s!AMOUNT",
"breaks" : [ {
"color" : "c25454",
"lowerBound" : null,
"upperBound" : null
}, {
"color" : "c2c254",
"lowerBound" : null,
"upperBound" : null
}, {
"color" : "54c254",
"lowerBound" : null,
"upperBound" : null
} ]
} ],
"tableColumns" : [ {
"column" : "INDUSTRY",
"isPercent" : false,
"scale" : null,
"showTotal" : false,
"type" : "grouping"
}, {
"column" : "CLOSE_DATE",
"isPercent" : false,
"scale" : null,
"showTotal" : false,
"type" : "grouping"
}, {
"column" : "s!AMOUNT",
"isPercent" : false,
"scale" : null,
"showTotal" : true,
"type" : "aggregate"
} ]
},
"visualizationType" : "Table"
},
"reportId" : "00OR0000000OgsOMAS",
"title" : "My Table",
"type" : "Report"
}, {
"componentData" : 5,
"footer" : null,
"header" : null,
"id" : "01aR00000005kCoIAI",
"properties" : {
"aggregates" : [ {
"name" : "s!AMOUNT"
} ],
"autoSelectColumns" : false,
"filterColumns" : [ {
"label" : "Closed",
"name" : "CLOSED"
}, {
"label" : "Account Type",
"name" : "ACCOUNT_TYPE"
}, {
"label" : "Annual Revenue",
"name" : "SALES"
} ],
"groupings" : [ {
"name" : "STAGE_NAME"
}, {
"name" : "TYPE"
} ],
"maxRows" : null,
"sort" : {
"column" : "STAGE_NAME",
"sortOrder" : "asc"
},
"useReportChart" : false,
"visualizationProperties" : {
"aggregateVisualizationInfos" : [ {
"axis" : "Y2",
"visualizationType" : "Column"
} ],
"axisRange" : {
"max" : null,
"min" : null,
"rangeType" : "auto"
},
"groupByType" : "grouped",
"legendPosition" : "Bottom",
"showValues" : false
},
"visualizationType" : "Column"
},
"reportId" : "00OR0000000JizXMAS",
"title" : null,
"type" : "Report"
}, {
"componentData" : 6,
"footer" : null,
"header" : null,
"id" : "01aR00000005kCpIAI",
"properties" : {
"aggregates" : [ {
"name" : "s!AMOUNT"
}, {
"name" : "a!AMOUNT"
} ],
"autoSelectColumns" : false,
"filterColumns" : [ {
"label" : "Closed",
"name" : "CLOSED"
}, {
"label" : "Account Type",
"name" : "ACCOUNT_TYPE"
}, {
"label" : "Annual Revenue",
"name" : "SALES"
} ],
"groupings" : [ {
"name" : "STAGE_NAME"
} ],
"maxRows" : null,
"sort" : {
"column" : "STAGE_NAME",
"sortOrder" : "asc"
},
"useReportChart" : false,
"visualizationProperties" : {
"axisRange" : {
"max" : null,
"min" : null,
"rangeType" : "auto"
},
"groupByType" : "none",
"legendPosition" : "Bottom",
"showValues" : false
},
"visualizationType" : "Bar"
},
"reportId" : "00OR0000000JizXMAS",
"title" : null,
"type" : "Report"
} ],
"description" : null,
"developerName" : "Filtered_Dashboard",
"filters" : [ {
"errorMessage" : null,
"id" : "0IBR00000004CElOAM",
"name" : "Closed",
"options" : [ {
"alias" : "Open",
"endValue" : null,
"id" : "0ICR00000004CG4OAM",
"operation" : "equals",
"startValue" : null,
"value" : "True"
}, {
"alias" : "Closed",
"endValue" : null,
"id" : "0ICR00000004CG5OAM",
"operation" : "equals",
"startValue" : null,
"value" : "False"
} ],
"selectedOption" : null
}, {
"errorMessage" : null,
"id" : "0IBR00000004CEmOAM",
"name" : "Account Type",
"options" : [ {
"alias" : null,
"endValue" : null,
"id" : "0ICR00000004CG6OAM",
"operation" : "equals",
"startValue" : null,
"value" : "Analyst"
}, {
"alias" : null,
"endValue" : null,
"id" : "0ICR00000004CG7OAM",
"operation" : "equals",
"startValue" : null,
"value" : "Competitor"
}, {
"alias" : null,
"endValue" : null,
"id" : "0ICR00000004CG8OAM",
"operation" : "equals",
"startValue" : null,
"value" : "Press,Prospect,Reseller"
}, {
"alias" : null,
"endValue" : null,
"id" : "0ICR00000004CG9OAM",
"operation" : "notEqual",
"startValue" : null,
"value" : "Other"
}, {
"alias" : "Outsiders",
"endValue" : null,
"id" : "0ICR00000004CGAOA2",
"operation" : "lessOrEqual",
"startValue" : null,
"value" : "Integrator,Partner,Prospect"
} ],
"selectedOption" : null
}, {
"errorMessage" : null,
"id" : "0IBR0000000007cOAA",
"name" : "Annual Revenue",
"options" : [ {
"alias" : null,
"endValue" : null,
"id" : "0ICR000000000A5OAI",
"operation" : "lessThan",
"startValue" : null,
"value" : "\"400,000\""
} ],
"selectedOption" : null
} ],
"folderId" : "00lR0000000DnRZIA0",
"id" : "01ZR00000004SknMAE",
"layout" : {
"columns" : [ {
"components" : [ 0, 1, 2 ]
}, {
"components" : [ 3, 4 ]
}, {
"components" : [ 5, 6 ]
} ],
"gridLayout" : false
},
"name" : "Filtered Dashboard",
"runningUser" : {
"displayName" : "Vandelay Art",
"id" : "005R0000000Hv5rIAC"
}
}
```

### 1.11 Clone a Dashboard

Creates a copy of a dashboard by sending a POST request to the Dashboard List resource.

dashboard `01ZR00000008gkvMAA`를 복제해 새 폴더 ID `00lR0000000DnRZIA0`에 저장하려면, Dashboard List resource에 다음 POST 요청을 보낸다.

```
/services/data/v35.0/analytics/dashboards/?cloneId=01ZR00000008gkvMAA
```

요청 본문:

```json
{"folderId":"00lR0000000DnRZIA0"}
```

응답 — 복제된 dashboard 정보 ([sic] `Fred Wiliamson` — Williamson 오타, verbatim):

```json
{ "attributes" :
{ "dashboardId" : "01ZR00000004SZZMA2",
"dashboardName" : "Sales Manager Dashboard",
"statusUrl" : "/services/data/v35.0/analytics/dashboards/01ZR00000004SZZMA2/status",
"type" : "Dashboard" },
...
"folderId" : "00lR0000000DnRZIA0",
"id" : "01ZR00000004SZZMA2",
"layout" : {
"columns" : [
{ "components" : [ 0, 1, 2, 3 ] },
{ "components" : [ 4, 5, 6 ] },
{ "components" : [ 7 ] } ],
"gridLayout" : false },
"name" : "Sales Manager Dashboard",
"runningUser" : { "displayName" : "Fred Wiliamson", "id" : "005R0000000Hv5rIAC" }
}
```

### 1.12 Delete a Dashboard

Delete a dashboard by sending a DELETE request to the Dashboard Results resource. Deleted dashboards are moved to the Recycle Bin.

```
/services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE
```

이 DELETE 요청은 dashboard를 삭제하고 **204 HTTP response code with no content in the response body**를 반환한다.

---

## 2. Downloads 예제

> Learn how to download dashboards, lenses, and reports as images or PDFs.

> ℹ️ **제품 맥락:** CRM Analytics(구 Wave)는 표준 Reports & Dashboards와 다른 제품이다. 이 섹션은 download 엔드포인트 사용법만 다루며 CRM Analytics 자체 심층 설명은 범위 밖이다.
>
> **Note (전 예제 공통):** Downloads are requested by entering the URI in a browser address bar.

### 2.1 Download a CRM Analytics Dashboard as a PDF

Use a request on the Analytics Download resource to download a CRM Analytics dashboard as a `.pdf` binary file.

표준 사용:

```
<domain>/analytics/download/dashboard/0FKB0000000xxxxxxx.pdf
```

| Parameter | Description |
|---|---|
| `assetType` | Required. Specifies what type of Analytics asset to download. Valid values are: • `dashboard` • `lens` • `lightning-dashboard` • `report` |
| `assetId` | Required. Specifies the Analytics asset id to download. |

쿼리 파라미터 사용 — 특정 page와 saved view 다운로드:

```
<domain>/analytics/download/dashboard/0FKB0000000xxxxxxx.pdf?savedViewId=0Svxx&pageId=page1
```

legal-sized paper로 인쇄용 다운로드:

```
<domain>/analytics/download/dashboard/0FKB0000000xxxxxxx.pdf?pageSize=LEGAL
```

tabular widget data 없이 다운로드:

```
<domain>/analytics/download/dashboard/0FKB0000000xxxxxxx.pdf?includeData=false
```

| Parameter | Description |
|---|---|
| `includeData` | Optional. Indicates whether to include that tabular widget data (`true`) or not(`false`). |
| `pageId` | Optional. Specifies the Id for a dashboard page to download. |
| `pageSize` | Optional. Specifies page size to download. Valid values are: • `A3` • `A4` • `LEGAL` • `LETTER` |
| `savedviewId` | Optional. Specifies the Id for a dashboard saved view to download. |

> [sic] 표 row 키는 `savedviewId`(소문자 v)이나 위 URI 예시는 `savedViewId`(대문자 V). 소스의 표기 불일치 — 양쪽 verbatim.

응답: The response body is binary data of the `.pdf` representation of the CRM Analytics dashboard.

### 2.2 Download a CRM Analytics Lens as a PNG

Use a request on the Analytics Download resource to download a CRM Analytics lens as a `.png` binary file.

```
<domain>/analytics/download/lens/0FKB0000000xxxxxxx.png
```

| Parameter | Description |
|---|---|
| `assetType` | Required. Specifies what type of Analytics asset to download. Valid values are: • `dashboard` • `lens` • `lightning-dashboard` • `report` |
| `assetId` | Required. Specifies the Analytics asset id to download. |
| `downloadType` | Required. Specifies what file type to download the Analytics asset as. Valid values are: • `png` • `pdf` |

응답: The response body is binary data of the `.png` representation of the CRM Analytics lens.

### 2.3 Download a Lightning Experience Dashboard as a PNG

Use a request on the Analytics Download resource to download a Lightning Experience dashboard as a `.png` binary file.

```
<domain>/analytics/download/lightning-dashboard/01ZB0000000xxxxxxx.png
```

| Parameter | Description |
|---|---|
| `assetType` | Required. Specifies what type of Analytics asset to download. Valid values are: • `dashboard` • `lens` • `lightning-dashboard` • `report` |
| `assetId` | Required. Specifies the Analytics asset id to download. |
| `downloadType` | Required. Specifies what file type to download the Analytics asset as. Valid values are: • `png` • `pdf` |

응답: The response body is binary data of the `.png` representation of the Lightning Experience dashboard.

### 2.4 Download a Lightning Experience Report as a PNG

Use a request on the Analytics Download resource to download a Lightning Experience report as a `.png` binary file.

```
<domain>/analytics/download/report/00OB0000000xxxxxxx.pdf
```

> [sic] URI 예시 확장자는 `.pdf`이나 제목·설명은 PNG — verbatim 보존.

| Parameter | Description |
|---|---|
| `assetType` | Required. Specifies what type of Analytics asset to download. Valid values are: • `dashboard` • `lens` • `lightning-dashboard` • `report` |
| `assetId` | Required. Specifies the Analytics asset id to download. |
| `downloadType` | Required. Specifies what file type to download the Analytics asset as. Valid values are: • `png` • `pdf` |

> **Note:** For a Lightning Experience report, the download request only works for `.png` when the report has a chart. If `.pdf` is used or the report doesn't have a chart, the request returns an error.

응답: The response body is binary data of the `.png` representation of the Lightning Experience report.

---

## 3. Notifications 예제

> Learn how to refresh, create, edit, copy, and delete analytic notifications. Analytic notifications are surfaced in the Salesforce user interface as report subscriptions, dashboard subscriptions, or Analytics notifications.

### 3.1 Get Analytics Notifications

Return a list of analytics notifications using a GET request on the Analytics Notification List resource.

**GET** (Analytics Notification List resource)

```
/services/data/v38.0/analytics/notifications?source=lightningReportSubscribe
```

| Parameter | Description |
|---|---|
| `source` | Required for GET calls. Specifies what type of analytics notification to return. Valid values are: • `lightningDashboardSubscribe` — dashboard subscriptions • `lightningReportSubscribe` — report subscriptions • `waveNotification` — Analytics notifications |
| `ownerId` | Optional for GET calls. Allows users with Manage Analytics Notifications permission to get notifications for another user with the specified ownerId. |
| `recordId` | Optional. Return notifications for a single record. Valid values are: • `reportId` — Unique report ID • `lensId` — Unique Analytics lens ID |

응답 — 세 notification이 `schedule.frequency`의 세 변형을 보여준다: `daily`(time) · `monthly`+`frequencyType:"specific"`(daysOfMonth+time) · `monthly`+`frequencyType:"relative"`(dayInWeek+weekInMonth+time).

```json
[ {
"active" : true,
"createdDate" : "2016-08-08T04:14:12Z",
"deactivateOnTrigger" : false,
"id" : "0AuR00000004CYpKAM",
"lastModifiedDate" : "2016-08-08T04:14:12Z",
"name" : "Notification1",
"recordId" : "00OR0000000P7EgMAK",
"schedule" : {
"details" : {
"time" : 3
},
"frequency" : "daily"
},
"source" : "lightningReportSubscribe",
"thresholds" : [ {
"actions" : [ {
"configuration" : {
"recipients" : [ ]
},
"type" : "sendEmail"
} ],
"conditions" : null,
"type" : "always"
} ]
}, {
"active" : true,
"createdDate" : "2016-08-10T22:22:17Z",
"deactivateOnTrigger" : false,
"id" : "0AuR000000000KSKAY",
"lastModifiedDate" : "2016-08-11T23:16:01Z",
"name" : "Notification2",
"recordId" : "00OR0000000PCHYMA4",
"schedule" : {
"details" : {
"daysOfMonth" : [ 1, 2, 4 ],
"time" : 22
},
"frequency" : "monthly",
"frequencyType" : "specific"
},
"source" : "lightningReportSubscribe",
"thresholds" : [ {
"actions" : [ {
"configuration" : {
"recipients" : [ ]
},
"type" : "sendEmail"
} ],
"conditions" : null,
"type" : "always"
} ]
}, {
"active" : true,
"createdDate" : "2016-08-12T04:01:50Z",
"deactivateOnTrigger" : false,
"id" : "0AuR000000000KcKAI",
"lastModifiedDate" : "2016-08-12T04:16:34Z",
"name" : "Notification3",
"recordId" : "00OR0000000PBXEMA4",
"schedule" : {
"details" : {
"dayInWeek" : "mon",
"time" : 22,
"weekInMonth" : "third"
},
"frequency" : "monthly",
"frequencyType" : "relative"
},
"source" : "lightningReportSubscribe",
"thresholds" : [ {
"actions" : [ {
"configuration" : {
"recipients" : [ ]
},
"type" : "sendEmail"
} ],
"conditions" : null,
"type" : "always"
} ]
} ]
```

### 3.2 Create an Analytics Notification

Create an Analytics Notification using a POST request on the Analytics Notification List resource.

**POST** (Analytics Notification List resource)

```
/services/data/v38.0/analytics/notifications
```

요청 본문:

```json
{
"active" : true,
"createdDate" : "",
"deactivateOnTrigger" : false,
"id" : "",
"lastModifiedDate" : "",
"name" : "New Notification",
"recordId" : "00OR0000000PD55MAG",
"schedule" : {
"details" : {
"time" : 3
},
"frequency" : "daily"
},
"source" : "lightningReportSubscribe",
"thresholds" : [ {
"actions" : [ {
"configuration" : {
"recipients" : [ ]
},
"type" : "sendEmail"
} ],
"conditions" : null,
"type" : "always"
} ]
}
```

응답:

```json
{
"active" : true,
"createdDate" : "2016-08-12T05:57:19Z",
"deactivateOnTrigger" : false,
"id" : "0AuR00000004CZTKA2",
"lastModifiedDate" : "2016-08-12T05:57:19Z",
"name" : "New Notification",
"recordId" : "00OR0000000PD55MAG",
"schedule" : {
"details" : {
"time" : 3
},
"frequency" : "daily"
},
"source" : "lightningReportSubscribe",
"thresholds" : [ {
"actions" : [ {
"configuration" : {
"recipients" : [ ]
},
"type" : "sendEmail"
} ],
"conditions" : null,
"type" : "always"
} ]
}
```

### 3.3 Save Changes to an Analytics Notification

Save Changes to an Analytics Notification using a PUT request on the Analytics Notification resource.

**PUT** (Analytics Notification resource)

```
/services/data/v38.0/analytics/notifications/analytics notification ID
```

(URI 끝의 `analytics notification ID`는 플레이스홀더 — verbatim)

요청 본문 — 이 예제는 notification이 매일 3:00 AM 대신 9:00 AM에 실행되도록 변경한다.

```json
{
"active" : true,
"createdDate" : "",
"deactivateOnTrigger" : false,
"id" : "0AuR00000004CZTKA2",
"lastModifiedDate" : "",
"name" : "New Notification",
"recordId" : "00OR0000000PD55MAG",
"schedule" : {
"details" : {
"time" : 9
},
"frequency" : "daily"
},
"source" : "lightningReportSubscribe",
"thresholds" : [ {
"actions" : [ {
"configuration" : {
"recipients" : [ ]
},
"type" : "sendEmail"
} ],
"conditions" : null,
"type" : "always"
} ]
}
```

응답 — 갱신·저장된 notification을 반영한다.

```json
{
"active" : true,
"createdDate" : "2016-08-12T05:57:19Z",
"deactivateOnTrigger" : false,
"id" : "0AuR00000004CZTKA2",
"lastModifiedDate" : "2016-08-12T06:12:24Z",
"name" : "New Notification",
"recordId" : "00OR0000000PD55MAG",
"schedule" : {
"details" : {
"time" : 9
},
"frequency" : "daily"
},
"source" : "lightningReportSubscribe",
"thresholds" : [ {
"actions" : [ {
"configuration" : {
"recipients" : [ ]
},
"type" : "sendEmail"
} ],
"conditions" : null,
"type" : "always"
} ]
}
```

### 3.4 Delete an Analytics Notification

Delete an Analytics Notification using a DELETE request on the Analytics Notification resource. Once deleted, the analytics notification can't be recovered.

**DELETE** (Analytics Notification resource)

```
/services/data/v38.0/analytics/notifications/analytics notification ID
```

The analytic notification deletes and returns a **204 HTTP response code with no content in the response body**.

### 3.5 Check Limits for Analytics Notifications

Check analytics notification limits using a GET request on the Analytics Notification Limits resource.

**GET** (Analytics Notification Limits resource)

```
/services/data/v38.0/analytics/notifications/limits?source=waveNotification
```

| Method | Description |
|---|---|
| GET | Check how many analytic notifications you have, and the maximum number you can have. |

응답:

```json
{
"userLimit" : {
"max" : 5,
"remaining" : 2
}
}
```

---

## 챕터 범위 (멀티토픽 PDF)

이 노트는 *Reports and Dashboards REST API Developer Guide* v67.0 CHAPTER 2 "Examples" 중 **Dashboards Examples(12) + Downloads Examples(4) + Notifications Examples(5)** 를 verbatim 커버한다.

미커버(범위 밖 — 별도 노트 소관):

- **Reports Examples** — Dashboards 앞 섹션 (별도 N1 노트 소관, plain-text)
- **CHAPTER 3 Reference** — Analytics Download / Analytics Notifications / Dashboards / Filter Operators 등 reference 표현형·속성 정의 (별도 N9 Reference 노트 소관, plain-text). 위 1.2·1.6·1.9·1.10의 응답 JSON에 등장하는 `factMap`·`reportMetadata`·`buckets`·`visualizationProperties` 등 각 속성의 정의는 이 Reference 소관.

---

## 관련 노트

- [[Reports and Dashboards REST API — 개요·Reports 예제]] — 동일 가이드 CHAPTER 2의 Reports 예제(이 노트 앞 섹션) + REST API 진입점·인증
- [[Reports and Dashboards REST API — Dashboards 표현형]] — 위 1.x Dashboard 응답 JSON 속성(componentData·dashboardMetadata 등)의 reference 정의 소관
- [[Reports and Dashboards REST API — Analytics Download·Notifications·Filter Operators 표현형]] — 위 2.x Downloads·3.x Notifications 응답 속성·필터 연산자 reference 정의 소관
- [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] — 위 응답의 `reportMetadata` 속성 정의 정본
- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]] — 동일 Analytics 폴더 · 별개 REST API 클러스터
