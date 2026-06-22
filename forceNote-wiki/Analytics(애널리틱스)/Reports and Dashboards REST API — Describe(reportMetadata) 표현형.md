---
tags: [analytics, reports, rest-api, reports-dashboards-rest, reportmetadata, report-type-metadata, report-extended-metadata]
source: salesforce_analytics_rest_api.pdf (Reports and Dashboards REST API Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Describe report REST, reportMetadata, reportTypeMetadata, reportExtendedMetadata, Column map, Detail column information]
---

# Reports and Dashboards REST API — Describe(reportMetadata) 표현형

> Describe 리소스가 반환하는 `reportMetadata`·`reportTypeMetadata`·`reportExtendedMetadata` 세 표현형의 전체 속성·중첩 객체·enum 정본 — 다른 Reports REST 노트가 이리로 링크한다.

---

## 1. Describe 리소스

Retrieves report, report type, and related metadata for a tabular, summary, or matrix report.

- **Report metadata** gives information about the report as a whole. Tells you such things as, the report type, format, the fields that are summaries, row or column groupings, filters saved to the report, and so on.
- **Report type metadata** tells you about all the fields available in the report type, those you can filter, and by what filter criteria.
- **Report extended metadata** tells you about the fields that are summaries, groupings, and contain record details in the report. A property that displays null indicates that its value is not available.

| 항목 | 값 |
|---|---|
| Resource URL | `/services/data/<latest API version>/analytics/reports/<report ID>/describe` |
| Formats | JSON |
| HTTP Methods | `GET` — Retrieves report, report type, and related metadata for a tabular, summary, or matrix report. |

**Response Body — 최상위 3속성**

| Property | Type | Description |
|---|---|---|
| `reportMetadata` | Report metadata | Unique identifiers for groupings and summaries. |
| `reportTypeMetadata` | Report type metadata | Fields in each section of a report type plus filter information for those fields. |
| `reportExtendedMetadata` | Report extended metadata | Additional information about summaries and groupings. |

---

## 2. Report metadata (`reportMetadata`) — 34속성 (정본)

> PATCH Request Body 표와 동일 속성 집합이며, 본 노트가 정본이다.

| Property | Type | Description |
|---|---|---|
| `aggregates` | Array of strings | Unique identities for summary or custom summary formula fields in the report. For example: `a!Amount` average, `s!Amount` sum, `m!Amount` minimum, `x!Amount` maximum, `s!<customfieldID>` sum of a custom field column (identity = summary type + field ID), `u!{column_name}` unique count of values for the specified `{column_name}` (e.g. `u!AccountName`). |
| `allowedInCustomDetailFormula` | Boolean | Specifies whether a field can be referenced in a row-level formula (true) or not (false). |
| `buckets` | Bucket field | Describes a bucket field. |
| `chart` | Chart[] | Details about the chart used in a report. |
| `crossFilters` | Cross filter[] | Cross filters applied to the report. |
| `customDetailFormula` | Custom Detail Formula[] | An array of objects that describes row-level formulas. |
| `customSummaryFormula` | Custom summary formula | Describes a custom summary formulas. _[sic]_ |
| `currency` | String | Report currency, such as USD, EUR, GBP, for an organization that has Multi-Currency enabled. Value is null if the organization does not have Multi-Currency enabled. |
| `dashboardSetting` | Name/value pair | Allows saving of dashboard settings to allow for reports with row limit filters on dashboards. Can be configured on a report for Top-N reports. The Name and Value fields in dashboardSetting are used as Grouping and Aggregate in dashboard components. |
| `detailColumns` | Array of strings | Unique API names for the fields that have detailed data. |
| `developerName` | String | Report API name. |
| `division` | String | Determines the division of records to include in the report. For example, West Coast and East Coast. Available only if your organization uses divisions to segment data and you have the "Affected by Divisions" permission. If you do not have the "Affected by Divisions" permission, your reports include records in all divisions. |
| `folderId` | String | ID of the folder that contains the report. **Note:** When the report is in the My Personal Custom Reports folder, folderId = userId. When the report is in the Unfiled Public Reports folder, folderId = orgId. |
| `groupingsAcross` | Groupings across[] | Unique identities for each column grouping. The identity is: an empty array for reports in summary format (can't have column groupings), `BucketField_(ID)` for bucket fields, or the ID of a custom field when used for a column grouping. |
| `groupingsDown` | Groupings down[] | Unique identities for each row grouping. The identity is: `BucketField_(ID)` for bucket fields, or the ID of a custom field when used for grouping. |
| `hasDetailRows` | Boolean | Indicates whether to include detailed data with the summary data. |
| `hasRecordCount` | Boolean | Indicates whether the report shows the record count. |
| `historicalSnapshotDates` | Array of strings | List of historical snapshot dates. |
| `id` | String | Unique report ID. |
| `name` | String | Display name of the report. |
| `presentationOptions` | Report presentation options | Display options in the Lightning Report Builder. |
| `reportBooleanFilter` | String | Logic to parse custom field filters. Value is null when filter logic is not specified. (e.g. `"(1 OR 2) AND 3"`; see JSON below) |
| `reportFilters` | Filter details[] | List of each custom filter in the report along with the field name, filter operator, and filter value. |
| `reportFormat` | String | Format of the report. Possible values are: TABULAR, SUMMARY, MATRIX, MULTI_BLOCK. The MULTI_BLOCK property is available in API version 43.0 and later. |
| `reportType` | Report type | Unique API name and display name for the report type. `type`: unique identifier (string). `label`: display name (string). |
| `scope` | String | Defines the scope of the data on which you run the report. Valid values depend on the report type. |
| `showGrandTotal` | Boolean | Indicates whether the report shows the grand total. |
| `showSubtotals` | Boolean | Indicates whether the report shows subtotals, such as column or row totals. |
| `sortBy` | Array of strings | API name of the field on which the report is sorted and the direction (asc or desc). Example: `"sortBy":[{"sortColumn":"Account_ID","sortOrder":"asc"}]` |
| `standardDateFilter` | Array of strings | Standard date filters. Each contains: `column` (API name of date field), `durationValue` (date literal or 'CUSTOM'), `startDate`, `endDate`. |
| `standardFilters` | Array of strings | List of filters that show up in the report by default. Vary by report type (e.g. Opportunity: Show, Opportunity Status, Probability). Name-value string pairs. |
| `supportsRoleHierarchy` | Boolean | Indicates whether the report type supports role hierarchy filtering (true) or not (false). |
| `topRows` | Top rows | Describes a row limit filter applied to the report. |
| `userOrHierarchyFilterId` | String | Unique user or role ID used by the report's role hierarchy filter. If specified, a role hierarchy filter is applied; if unspecified, none. |

**`reportBooleanFilter` + `reportFilters` 예제**

```json
{
  "reportBooleanFilter": "(1 OR 2) AND 3",
  "reportFilters": [
    { "value": "Analyst,Integrator,Press,Other", "column": "TYPE", "operator": "notEqual" },
    { "value": "100,000", "column": "SALES", "operator": "greaterThan" },
    { "value": "Small", "column": "Size", "operator": "notEqual" }
  ]
}
```

---

## 3. `reportMetadata` 중첩 표현형 12종

### 3.1 Chart

| Property | Type | Description |
|---|---|---|
| `chartType` | String | |
| `groupings` | String | |
| `hasLegend` | Boolean | |
| `showChartValues` | Boolean | |
| `summaries` | Array of strings | Unique identities for summaries (`a!`/`s!`/`m!`/`x!`/`s!<id>` — `reportMetadata.aggregates`와 동일 설명). |
| `summaryAxisLocations` | String | X or Y. |
| `title` | String | Name of the chart. |

### 3.2 Groupings down

| Property | Type | Description |
|---|---|---|
| `name` | String | |
| `sortOrder` | String | asc or desc. |
| `dateGranularity` | String | Day, Calendar Week, Calendar Month, Calendar Quarter, Calendar Year, Fiscal Quarter, Fiscal Year, Calendar Month in Year, Calendar Day in Month. |
| `sortAggregate` | String | (pilot) null when not sorted by a summary. |

```json
{
  "aggregates": ["s!SALES", "RowCount"],
  "groupingsDown": [
    { "name": "USERS.NAME", "sortOrder": "Desc", "dateGranularity": "None", "sortAggregate": "s!SALES" }
  ]
}
```

### 3.3 Report presentation options

| Property | Type | Description |
|---|---|---|
| `hasStackedSummaries` | Boolean | |
| `historicalColumns` | Historical column presentation options | |

```json
"presentationOptions": {
  "historicalColumns": {
    "Opportunity__hd.CloseDate__hst": { "decreaseIsPositive": false, "showChanges": false },
    "Opportunity__hd.Amount__hst":    { "decreaseIsPositive": false, "showChanges": true }
  }
}
```

### 3.4 Historical column presentation options

| Property | Type | Description |
|---|---|---|
| `decreaseIsPositive` | Boolean | A negative change is shown green instead of red in the Lightning Report Builder. |
| `showChanges` | Boolean | Display the change column. |

### 3.5 Groupings across

| Property | Type | Description |
|---|---|---|
| `name` | String | |
| `sortOrder` | String | asc or desc. |
| `dateGranularity` | String | Day, Calendar Week, Calendar Month, Calendar Quarter, Calendar Year, Fiscal Quarter, Fiscal Year, Calendar Month in Year, Calendar Day in Month. |

### 3.6 Filter details

| Property | Type | Description |
|---|---|---|
| `column` | String | |
| `filterType` | String | `fieldToField`, `fieldValue`, or null (defaults to `fieldValue`). |
| `isRunPageEditable` | Boolean | |
| `operator` | String | equals, notEqual, lessThan, greaterThan, lessOrEqual, greaterOrEqual, contains, notContain, startsWith, includes, excludes, within (DISTANCE criteria only). |
| `value` | String | (datetime values in GMT). |

```json
"reportFilters": [
  { "column": "AMOUNT", "filterType": "fieldToField", "isRunPageEditable": true, "operator": "notEqual", "value": "PROJECTED_AMOUNT" },
  { "column": "CDF1",   "filterType": "fieldValue",   "isRunPageEditable": true, "operator": "greaterThan", "value": "0" }
]
```

### 3.7 Bucket field

| Property | Type | Description |
|---|---|---|
| `bucketType` | BucketType | number, percent, picklist. |
| `developerName` | String | |
| `label` | String | |
| `nullTreatedAsZero` | Boolean | |
| `otherBucketLabel` | String | "Other" label in PICKLIST buckets. |
| `sourceColumnName` | String | |
| `values` | Array of BucketTypeValues | Describes the values included in the bucket field.. _[sic — 마침표 2개]_ |

### 3.8 Bucket field value

| Property | Type | Description |
|---|---|---|
| `label` | String | |
| `sourceDimensionValues` | String | PICKLIST, TEXT. |
| `rangeUpperBound` | Double | NUMBER. |

### 3.9 Cross filter

| Property | Type | Description |
|---|---|---|
| `criteria` | Array of Filter details[] | |
| `includesObject` | Boolean | |
| `primaryEntityField` | String | |
| `relatedEntity` | String | |
| `relatedEntityJoinField` | String | |

### 3.10 Custom Detail Formula

| Property | Type | Description |
|---|---|---|
| `decimalPlaces` | Integer | |
| `description` | String | |
| `formula` | String | |
| `formulaType` | String | date, datetime, number, text. |
| `label` | String | |

### 3.11 Custom summary formula

| Property | Type | Description |
|---|---|---|
| `label` | String | |
| `description` | String | |
| `formulaType` | String | number, currency, percent. |
| `decimalPlaces` | Integer | |
| `downGroup` | String | |
| `downGroupType` | String | all, custom, grand_total. |
| `acrossGroup` | String | when the `accrossGroupType` is CUSTOM. _[sic]_ |
| `acrossGroupType` | String | all, custom, grand_total. |
| `formula` | String | |

### 3.12 Top rows

| Property | Type | Description |
|---|---|---|
| `rowLimit` | Integer | Number of rows returned. |
| `direction` | String | Sort order of report rows. |

---

## 4. Report type metadata (`reportTypeMetadata`) — 9속성

| Property | Type | Description |
|---|---|---|
| `categories` | Categories[] | Returns all row-level formulas in a report as an object identical to the other categories objects. For row-level formulas, these are always false: `allowedInCustomDetailFormula`, `Bucketable`, `Filterable`, `isCustom`, `isLookup`. Always null: `filterValues`, `inactiveFilterValues`. |
| `dataTypeFilterOperatorMap` | Filter operator reference | Lists all possible field data types that can be used to filter the report. Each data type (phone, percent, currency, picklist...) has `name` (string; unique API name for filter criteria) and `label` (string; display name). Bucket fields are considered string data type. |
| `dateGranularityInfos` | dateGranularityInfos[] | Array of objects each specifying a measure of time used to group date fields (day, week, month, fiscal quarter, ...). |
| `divisionInfo` | Division info[] | Default division and list of all possible record-level divisions usable in a report. |
| `objects` | Objects info[] | List of objects included in report type. Available in API version 54.0 and later. |
| `scopeInfo` | Scope info[] | Scope of the data on which you run the report. Valid values depend on report type. |
| `standardDateFilterDurationGroups` | Standard date filter duration groups[] | List of standard date filters available in reports. |
| `standardFilterInfos` | Array of strings | List of filters shown by default. Vary by report type. Name-value string pairs. |
| `supportsJoinedFormat` | Boolean | Specifies whether a report type is compatible with joined reports (true) or not (false). |

### 4.1 Categories

| Property | Type | Description |
|---|---|---|
| `label` | String | Section display name. |
| `columns` | Column map | |

### 4.2 Column map — 12속성

| Property | Type | Description |
|---|---|---|
| `allowedInCustomDetailFormula` | Boolean | Specifies whether a field is whether a field is _[sic — 중복]_ can be referenced in a row-level formula (true) or not (false). |
| `bucketable` | Boolean | Specifies whether a field can be used as the basis for a bucket column (true) or not (false). |
| `dataType` | String | Data type of the field. |
| `entityColumnName` | String | Describes the relationship between an sObject and a report field by returning the sObject and sObject field name that a report field maps to. Value formatted as `sObject.sObject field`. E.g. on `LAST_UPDATE_BY` column, entityColumnName = "User.Name" (see JSON below). **Note:** Row-level formulas aren't directly mapped to sObject fields but still have an entityColumnName property; for them the value is CDF1. |
| `fieldToFieldFilterable` | Boolean | Specifies whether a field can be referenced in a field-to-field filter (true) or not (false). |
| `filterValues` | String array | All filter values for a field if data type is picklist, multi-select picklist, boolean, or checkbox. Other types return an empty array. Two properties: `name` (string), `label` (string). |
| `filterable` | Boolean | False means the field is of a type that can't be filtered (e.g. Encrypted Text). |
| `isCustom` | Boolean | Specifies whether a column is a custom (true) or standard (false) field. |
| `isLookup` | Boolean | Specifies whether a field is a lookup (true) or not (false). |
| `label` | String | Display name of a field. |
| `maxLength` | Integer | Indicates the maximum permited _[sic]_ number of characters for the value of a column field. If there is no limit, use null. |
| `uniqueCountable` | Boolean | Specifies whether a field supports unique count (true) or not (false). |

```json
"reportTypeMetadata": {
  "categories": [
    {
      "columns": {
        "LAST_UPDATE_BY": {
          "allowedInCustomDetailFormula": true,
          "bucketable": true,
          "dataType": "string",
          "entityColumnName": "User.Name",
          "fieldToFieldFilterable": false,
          "filterValues": [],
          "filterable": true,
          "inactiveFilterValues": [],
          "isCustom": false,
          "isLookup": true,
          "label": "Last Modified By",
          "maxLength": null,
          "uniqueCountable": true
        }
      }
    }
  ]
}
```

### 4.3 dateGranularityInfos

| Property | Type | Description |
|---|---|---|
| `label` | String | |
| `value` | String | API name. |

### 4.4 Division Info

| Property | Type | Description |
|---|---|---|
| `defaultValue` | String | |
| `values` | String | Has `label` and `name` properties. |

### 4.5 Objects Info

| Property | Type | Description |
|---|---|---|
| `apiName` | String | |
| `joinType` | String | ROOT — Primary object; INNER — Inner join; OUTER — Outer join. |
| `label` | String | |

### 4.6 Scope Info

| Property | Type | Description |
|---|---|---|
| `defaultValue` | String | |
| `values` | Array of strings | Has `allowsDivision`, `label`, `value` properties. |

### 4.7 Standard date filter duration groups

| Property | Type | Description |
|---|---|---|
| `label` | String | Calendar Year, Calendar Quarter, Calendar Month, Calendar Week, Fiscal Year, Fiscal Quarter, Day, custom. |
| `standardDateFilterDurations` | Standard date filter durations[] | |

### 4.8 Standard date filter durations

| Property | Type | Description |
|---|---|---|
| `endDate` | String | |
| `label` | String | Relative label like Current FY / Current FQ, plus custom. |
| `startDate` | String | |
| `value` | String | API name like THIS_FISCAL_YEAR, NEXT_FISCAL_QUARTER, plus custom. |

---

## 5. Report extended metadata (`reportExtendedMetadata`) — 4속성

| Property | Type | Description |
|---|---|---|
| `aggregateColumnInfo` | Aggregate column information | All report summaries (Record Count, Sum, Average, Max, Min, custom summary formulas). Values for each summary in `reportMetadata.aggregates`. |
| `detailColumnInfo` | Detail column information | Two properties for each field that has detailed data, identified by unique API name. |
| `groupingColumnInfo` | Grouping column information | Map of each row/column grouping to its metadata. Values for each grouping in `groupingsDown`/`groupingsAcross`. |
| `historicalColumnInfo` | Historical column information | Additional info on columns that exist only in historical trending reports. |

### 5.1 Aggregate column information

| Property | Type | Description |
|---|---|---|
| `label` | String | |
| `dataType` | String | |
| `acrossGroupingContext` | String | Column grouping where the CSF is displayed (see JSON below). |
| `downGroupingContext` | String | Row grouping where the CSF is displayed (see JSON below). |

```json
{
  "reportExtendedMetadata": {
    "aggregateColumnInfo": {
      "FORMULA1": {
        "label": "Stalled Oppty Avg",
        "dataType": "Percent",
        "acrossGroupingContext": "GRAND_SUMMARY",
        "downGroupingContext": "GRAND_SUMMARY"
      }
    }
  }
}
```

> PDF의 `downGroupingContext` 옆에는 UI 스크린샷 이미지가 있다(p.232). 본 노트는 스크린샷을 재현하지 않고 다음 JSON 예제로 갈음한다.

```json
{
  "reportExtendedMetadata": {
    "aggregateColumnInfo": {
      "FORMULA1": {
        "label": "Average Won",
        "dataType": "Number",
        "acrossGroupingContext": null,
        "downGroupingContext": "TYPE"
      }
    }
  }
}
```

### 5.2 Detail column information

> `label` 속성이 2회 등장 — 원문 그대로 보존.

| Property | Type | Description |
|---|---|---|
| `label` | String | The localized display name of a standard field, the ID of a custom field, or the API name of a bucket field that has detailed data. |
| `dataType` | String | Data type of the field that has detailed data. Possible values: string, boolean, combobox, currency, date, datetime, double, email, html, id, int, multipicklist, number, percent, phone, picklist, reference, text, textarea, time, url. |
| `entityColumnName` | String | (Column map와 동일 설명 + `LAST_UPDATE_BY` 예제 재게재.) **Note:** for row-level formulas the value is CDF1. |
| `filterValues` | String array | (Column map와 동일.) |
| `filterable` | Boolean | False = field type can't be filtered. |
| `isLookup` | Boolean | Specifies whether a field is a lookup (true) or not (false). |
| `label` | String | Display name of a field. |
| `uniqueCountable` | Boolean | Specifies whether a field supports unique count (true) or not (false). |

### 5.3 Grouping column information

| Property | Type | Description |
|---|---|---|
| `label` | String | |
| `dataType` | String | (Detail column `dataType`와 동일 21값 enum: string, boolean, combobox, currency, date, datetime, double, email, html, id, int, multipicklist, number, percent, phone, picklist, reference, text, textarea, time, url.) |
| `groupingLevel` | Integer | 0, 1, 2 — first/second/third row level in summary reports. 0 or 1 — first/second row or column level in a matrix report. |

### 5.4 Historical column information

| Property | Type | Description |
|---|---|---|
| `baseField` | String | |
| `historicalColumn` | String | |
| `historicalSnapshotDate` | String | |
| `isHistoricalChange` | Boolean | True if the column represents the change between two historical columns. |

---

## 관련 노트

- [[Reports and Dashboards REST API — Execute·Instances·Report List 표현형]] — 이 reportMetadata를 POST 본문으로 받는 Execute Sync·Execute Async(Run a report) 리소스
- [[Reports and Dashboards REST API — Query 표현형]] — 이 reportMetadata를 POST 본문으로 받아 저장 없이 실행하는 Query 리소스(Response·factMap 정본)
- [[Reports and Dashboards REST API — 개요·Reports 예제]] — REST API 진입점·인증·Reports 예제
