---
tags: [analytics, reports, rest-api, reports-dashboards-rest, report-fields, error-codes]
source: salesforce_analytics_rest_api.pdf (Reports and Dashboards REST API Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Report Fields REST, dashboard filter fields, Report Error Codes, REST 에러 코드, intersectWith, equivalentFields]
---

# Reports and Dashboards REST API — Report Fields·Error Codes 표현형

> Report Fields 리소스(대시보드 필터용 공통 필드 탐색)의 요청·응답 표현형과, 리포트 레벨 에러 47종(HTTP 코드 + 메시지)을 전수 정리한다.

---

## Report Fields

The Report Fields resource returns report fields available for specified reports. Use the resource to determine the best fields for use in dashboard filters by seeing which fields different source reports have in common.

**Available in API version 40.0 and later.**

| 항목 | 값 |
|---|---|
| URL | `/services/data/<latest API version>/analytics/reports/<report ID>/fields` |
| Formats | JSON |
| HTTP Methods | `POST` |

POST 동작: If the request body is empty, returns a list of all possible report fields. Otherwise, returns a list of fields that specified reports share.

### POST Request Body

| Property | Type | Description |
|---|---|---|
| `intersectWith` | Array of Report IDs | An array of unique report IDs. |

### POST Response Body

| Property | Type | Description |
|---|---|---|
| `displayGroups` | Array of Fields | Fields available when adding a filter. |
| `equivalentFields` | Array of Fields | Fields available for each specified report. Each object in this array is a list of common fields categorized by report type. |
| `equivalentFieldIndices` | Map of Fields | Map of each field's API name to the index of the field in the `equivalentFields` array. |
| `mergedGroups` | Array of Fields | Merged fields. |

### Field object 키

각 필드는 `displayGroups` 안의 그룹 객체 → `columns` 맵에서 **API명 → 필드 객체**로 표현된다. 필드 객체의 6개 키:

| 키 | Type | 비고 |
|---|---|---|
| `dataType` | string | 예: `date` / `string` / `datetime` |
| `filterValues` | array | 예제에서는 전부 `[ ]` |
| `filterable` | boolean | 예제에서는 전부 `true` |
| `isLookup` | boolean | `true` / `false` |
| `label` | string | 사용자 표시 라벨 |
| `maxLength` | number 또는 null | lookup alias류는 `8`, 그 외 다수 `null` |

각 `displayGroups` 그룹 객체는 위 `columns` 맵 외에 추가로 `label`(string)·`labelSuffix`(string, 예 `"(Opportunities)"` / `"(Leads)"`)를 가진다.

### Example Request Body

원본 그대로 발췌.

```json
{ "intersectWith": ["00OR0000000P3RVMA0"] }
```

### Example Response Body

```json
// 구조 예시 — 실제 동작 설정 아님
// displayGroups 일부 label / Opportunity Owner 그룹 4번째 필드 키매핑은 PDF의 pdftotext 줄병합으로 불확정 →
// 이 displayGroups 블록은 "구조 예시"로 인용. 필드 정확 매핑의 확정 검증본은 아래
// equivalentFieldIndices(23키) · equivalentFields(20항목, index 0–19) 블록이다.
{
  "displayGroups" : {
    "Opportunity" : [ {
      "columns" : {
        "ACCOUNT_CREATED_DATE" : { "dataType":"date",   "filterValues":[ ], "filterable":true, "isLookup":false, "label":"Account: Created Date",       "maxLength":null },
        "ACCOUNT_LAST_ACTIVITY": { "dataType":"date",   "filterValues":[ ], "filterable":true, "isLookup":false, "label":"Account: Last Activity",      "maxLength":null },
        "ACCOUNT_LAST_UPDATE"  : { "dataType":"date",   "filterValues":[ ], "filterable":true, "isLookup":false, "label":"Account: Last Modified Date", "maxLength":null },
        "ACCOUNT_OWNER"        : { "dataType":"string", "filterValues":[ ], "filterable":true, "isLookup":false, "label":"Account Owner",               "maxLength":null },
        "ACCOUNT_OWNER_ALIAS"  : { "dataType":"string", "filterValues":[ ], "filterable":true, "isLookup":true,  "label":"Account Owner Alias",         "maxLength":8 }
      },
      "label" : "Account: General", "labelSuffix" : "(Opportunities)"
    }, {
      "columns" : {
        "CLOSE_DATE"            : { "dataType":"date",   "label":"Close Date",             "maxLength":null },
        "CLOSE_DATE2"           : { "dataType":"date",   "label":"Close Date (2)",         "maxLength":null },
        "CLOSE_MONTH"           : { "dataType":"date",   "label":"Close Month",            "maxLength":null },
        "CREATED_ALIAS"         : { "dataType":"string", "isLookup":true, "label":"Created Alias", "maxLength":8 },
        "CREATED"               : { "dataType":"string", "label":"Created By",             "maxLength":null },
        "CREATED_DATE"          : { "dataType":"date",   "label":"Created Date",           "maxLength":null },
        "LAST_ACTIVITY"         : { "dataType":"date",   "label":"Last Activity",          "maxLength":null },
        "LAST_UPDATE_BY_ALIAS"  : { "dataType":"string", "isLookup":true, "label":"Last Modified Alias", "maxLength":8 },
        "LAST_UPDATE_BY"        : { "dataType":"string", "label":"Last Modified By",       "maxLength":null },
        "LAST_UPDATE"           : { "dataType":"date",   "label":"Last Modified Date",     "maxLength":null },
        "LAST_STAGE_CHANGE_DATE": { "dataType":"date",   "label":"Last Stage Change Date", "maxLength":null }
      },
      "label" : "Opportunity Information", "labelSuffix" : "(Opportunities)"
    }, {
      "columns" : {
        "FULL_NAME"          : { "label":"Opportunity Owner" },
        "OWNER_MANAGER"      : { "label":"Opportunity Owner: Manager" },
        "ALIAS"              : { "isLookup":true, "label":"Opportunity Owner Alias", "maxLength":8 },
        "OWNER_ROLE_DISPLAY" : { "isLookup":true, "label":"Owner Role Display",      "maxLength":80 }
      },
      "label" : "Opportunity Owner", "labelSuffix" : "(Opportunities)"
    }, {
      "columns" : {
        "EMAIL_BOUNCED_DATE" : { "dataType":"datetime" }
      },
      "labelSuffix" : "(Leads)"
    }, {
      "columns" : { /* Leads General 필드들 (CREATED_ALIAS / CREATED_MONTH / CREATED / LAST_UPDATE_BY / LAST_ACTIVITY / OWNER_ROLE_DISPLAY 등, 동일 6키 구조) */ },
      "label" : "Lead General", "labelSuffix" : "(Leads)"
    } ]
  },
  "equivalentFieldIndices" : {
    "ACCOUNT_CREATED_DATE":19, "ACCOUNT_LAST_UPDATE":19, "ACCOUNT_OWNER":15, "CREATED_ALIAS":16, "CREATED_DATE":19,
    "LAST_UPDATE_BY_ALIAS":16, "ALIAS":16, "EMAIL_BOUNCED_DATE":19, "CLOSE_MONTH":17, "LAST_UPDATE_BY":15,
    "CREATED_MONTH":17, "LAST_ACTIVITY":17, "ACCOUNT_LAST_ACTIVITY":17, "CLOSE_DATE":17, "CREATED":15,
    "LAST_UPDATE":19, "CLOSE_DATE2":17, "OWNER_MANAGER":15, "LAST_STAGE_CHANGE_DATE":19, "ROLLUP_DESCRIPTION":7,
    "FULL_NAME":15, "ACCOUNT_OWNER_ALIAS":16, "OWNER_ROLE_DISPLAY":7
  },
  "equivalentFields" : [
    { "LeadList":[{"name":"CREATED"},{"name":"LAST_UPDATE_BY"}], "Opportunity":[{"name":"CREATED"},{"name":"LAST_UPDATE_BY"},{"name":"FULL_NAME"},{"name":"OWNER_MANAGER"},{"name":"ACCOUNT_OWNER"}] },
    { "LeadList":[{"name":"CREATED_ALIAS"},{"name":"LAST_UPDATE_BY_ALIAS"}], "Opportunity":[{"name":"CREATED_ALIAS"},{"name":"LAST_UPDATE_BY_ALIAS"},{"name":"ALIAS"},{"name":"ACCOUNT_OWNER_ALIAS"}] }
    /* ...(인덱스 2–19, 총 20항목 — equivalentFieldIndices가 가리키는 매핑. 마지막 index 7 = LeadList:[OWNER_ROLE_DISPLAY] ↔ Opportunity:[ROLLUP_DESCRIPTION])... */
  ],
  "mergedGroups" : { }
}
```

> **확정 검증본 주석:** `displayGroups`의 Leads 그룹 일부 label과 Opportunity Owner 그룹 4번째 필드 키매핑은 pdftotext 줄병합으로 불확정이라 위 `displayGroups` 블록은 "구조 예시"로 인용한다. 필드 정확 매핑의 확정본은 `equivalentFieldIndices`(23키)와 `equivalentFields`(20항목, index 0–19)이며, index 7 = `OWNER_ROLE_DISPLAY` ↔ `ROLLUP_DESCRIPTION`이다.

---

## Report Error Codes

Errors can occur at the report level. Report-level error messages are returned in the response header. When a report-level error occurs, the response header contains an HTTP response code and one of the following error messages.

> [sic] 원문은 curly apostrophe(’)를 사용한다(Can’t, don’t, report’s, you’re 등). 아래 표는 원문 따옴표를 유지한다.

전체 47행 (400:25 · 403:9 · 404:2 · 410:1 · 415:1 · 500:7 · 501:2).

| HTTP Response Code | Error Message |
|---|---|
| 400 | The specified start date of `<column name>` specified for the standard date filter is invalid. |
| 400 | The specified end date of `<column name>` specified for the standard date filter is invalid. |
| 400 | The column `<column name>` specified for the standard date filter is invalid. |
| 400 | The column `<column name>` cannot be a standard date filter because it is not a date column. |
| 400 | The duration `<value>` specified for the standard date filter is invalid. |
| 400 | The report folder ID must be a valid folder ID. |
| 400 | The report folder ID can’t be null. |
| 400 | The report name can’t be null. |
| 400 | Column sorting isn’t supported for matrix reports. |
| 400 | The sort column name must be from a selected column. |
| 400 | The sort column name can’t be null. |
| 400 | A report can only be sorted by one column. |
| 400 | A snapshot date is not in the correct format. Accepted formats are one of the rolling dates defined or yyyy-MM-dd. |
| 400 | The request is invalid because reports that are not historical trending reports cannot have historical snapshot dates. |
| 400 | The request is invalid because there are no historical snapshot dates in the request body. Specify historical snapshot dates, or set historical snapshot dates as an empty array to omit them. |
| 400 | Only a report with fewer than 100 columns can be run. The columns are fields specified as detail columns, summaries, or custom summary formulas. Remove unneeded columns from the report and try again. |
| 400 | Can’t run the report because it doesn’t have any columns selected. Be sure to add fields as columns to the report through the user interface. |
| 400 | The request is invalid because there are no filters. Specify filters or set filters as an empty array to omit them. |
| 400 | The filter value for ID `<value>` is incorrect. Specify an ID that is 15 or 18 characters long, such as 006D000000CrRLw or 005U0000000Rg2CIAS. |
| 400 | Specify a valid filterable column because `<value>` is invalid. |
| 400 | Specify a valid condition because `<value>` is invalid. |
| 400 | Filter the date in the correct format. Accepted formats are yyyy-MM-dd'T'HH:mm:ss'Z' and yyyy-MM-dd. |
| 400 | The date formula is too large. Specify a reasonable value. |
| 400 | The request is invalid because there is no metadata. Specify metadata in the request body. |
| 400 | The clone request must contain a valid cloneId parameter. |
| 403 | The report can’t be deleted because there are one or more dashboards referencing it. |
| 403 | You don’t have permission to create reports in the given folder. |
| 403 | You don’t have permission to edit reports in the given folder. |
| 403 | The report definition is obsolete. Your administrator has disabled all reports for the custom object, or its relationships have changed. |
| 403 | You don’t have permission to run reports. Check that you have the Run Reports user permission. |
| 403 | You don’t have sufficient privileges to perform this operation. |
| 403 | Reports and Dashboards REST API can’t process the request because it can accept only as many as `<number>` requests at a time to get results of reports run asynchronously. |
| 403 | Reports and Dashboards REST API can’t process the request because it can accept only as many as `<number>` requests at a time to run reports synchronously. |
| 403 | You can’t run more than `<number>` reports synchronously every 60 minutes. Try again later. |
| 404 | Use a valid URL, for example, /services/data/(apiversion)/analytics/reports/(reportID)/describe, to retrieve report metadata. |
| 404 | The data you’re trying to access is unavailable. |
| 410 | The requested resource has been retired or removed. Delete or update any references to the resource. |
| 415 | The Reports and Dashboards REST API only supports JSON content type in both request and response bodies. Specify requests with content type as application/json. |
| 500 | We ran into an error when fetching this report’s metadata. Try to re-submit your query. |
| 500 | We ran into an error when running this report. Try to re-submit your query. |
| 500 | The request body is either invalid or incomplete. |
| 500 | Results for this instance are unavailable because the report’s metadata has changed from when the report was last run. To get results, run the report again or undo changes to the report’s metadata. |
| 500 | The report failed to be deleted. |
| 500 | The report failed to be created. |
| 500 | The report failed to be saved. |
| 501 | You’re requesting data for an unsupported report format. |
| 501 | Historical trend data is unavailable in the report format requested. Change the report format to matrix and try again. |

---

## 관련 노트

- [[Reports and Dashboards REST API — 개요·Reports 예제]]
- [[Reports and Dashboards REST API — Execute·Instances·Report List 표현형]]
- [[Reports and Dashboards REST API — Query 표현형]]
