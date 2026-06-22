---
tags: [analytics, dashboards, rest-api, reports-dashboards-rest, dashboard-results, dashboard-metadata]
source: salesforce_analytics_rest_api.pdf (Reports and Dashboards REST API Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Dashboard Results REST, Dashboard Describe, Dashboard Status, 대시보드 표현형, dashboard component, refresh dashboard REST]
---

# Reports and Dashboards REST API — Dashboards 표현형

> Reports and Dashboards REST API의 Dashboards 리소스군 — 대시보드 목록·결과·메타데이터·상태·필터옵션 검증을 위한 URI·메서드·표현형(JSON property)·에러코드 전수.

---

Dashboards API는 대시보드를 조회·새로고침하기 위한 여러 리소스를 제공한다. 기본 리소스 URI는 `/services/data/<latest API version>/analytics/dashboards`이며, 모든 형식은 JSON, 인증은 `Authorization: Bearer token`이다. (예제 URI의 `vXX.X`는 v67.0 등 실제 버전으로 대체.)

## 리소스 일람

| Resource | HTTP Method | Description |
|---|---|---|
| Dashboard List | GET | Returns a list of recently used dashboards. |
| Dashboard List | POST | Makes a copy of a dashboard. |
| Dashboard Results | GET | Returns the metadata, data, and status for the specified dashboard. |
| Dashboard Results | POST | Returns details about specified dashboard components. |
| Dashboard Results | PUT | Triggers a dashboard refresh. |
| Dashboard Results | PATCH | Saves a dashboard. |
| Dashboard Results | DELETE | Deletes a dashboard. |
| Dashboard Status | GET | Returns the status for the specified dashboard. |
| Dashboard Describe | GET | Returns metadata for the specified dashboard, including dashboard components, filters, layout, and the running user. |
| Dashboard Filter Options Analysis | POST | Verifies that dashboard filter options are compatible with report fields. Specify the reportId of a dashboard's components' source report. |

> 대시보드를 호출·새로고침하는 실제 요청/응답 JSON 예제는 [[Reports and Dashboards REST API — Dashboards·Downloads·Notifications 예제]] 참조. 각 메서드 설명의 "See this example"는 그 예제 챕터로의 링크다.

---

## 1. Dashboard List

최근 사용한 대시보드 목록을 반환하거나 대시보드를 복제한다.

- **URI:** `/services/data/vXX.X/analytics/dashboards`
- **Formats:** JSON · **Authentication:** `Authorization: Bearer token`

| Method | Description |
|---|---|
| GET | Returns a list of dashboards that were recently viewed by the API user. See this example. |
| POST | Makes a copy of a dashboard. See this example. |

### GET Response body

An array of recent dashboard objects. 각 객체는 다음 필드를 포함한다.

| Property | Type | Description |
|---|---|---|
| `id` | String | Unique identifier of the dashboard. |
| `name` | String | Localized display name of the dashboard. |
| `statusUrl` | String | Dashboard status URL. |
| `url` | String | Dashboard result URL. |

**POST Response Body:** Uses the same format as the GET and PUT responses for the resource.

---

## 2. Dashboard Results

지정한 대시보드의 메타데이터·데이터·상태를 반환하며, 새로고침·저장·삭제도 수행한다.

- **URI:** `/services/data/vXX.X/analytics/dashboards/dashboardID`
- **선택 파라미터 포함:** `/services/data/vXX.X/analytics/dashboards/dashboardID?runningUser=runningUserID&filter1=filter1ID&filter2=filter2ID&filter3=filter3ID`
- **Formats:** JSON · **Authentication:** `Authorization: Bearer token`

| Method | Description |
|---|---|
| GET | Returns metadata, data, and status for the specified dashboard. See this example. |
| POST | Returns details about one or more dashboard components from a specified dashboard. See this example. |
| PUT | Triggers a dashboard refresh. See this example. |
| PATCH | Saves a dashboard. See this example. |
| DELETE | Deletes a dashboard. See this example. |

### Parameters (GET·PUT·PATCH 메서드에서 사용, 선택)

| Parameter Name | Description |
|---|---|
| `runningUser` | Identifier of the running user. Gives an error if the user is not allowed to change the running user, or if the selected running user is invalid. |
| `filter1` | Identifier of the selected filter option for the first filter. Gives an error if the filter option is invalid. |
| `filter2` | Identifier of the selected filter option for the second filter. Gives an error if the filter option is invalid. |
| `filter3` | Identifier of the selected filter option for the third filter. Gives an error if the filter option is invalid. |
| `isStickyFilterSave` | Append to a PATCH request. When true, saves any dashboard filters set in the request so that they're also set the next time you open the dashboard. You can only set dashboard filters for yourself, not for other users. |

### GET, POST, and PUT Response body

| Property | Type | Description |
|---|---|---|
| `componentData` | Component data[] | Ordered array containing data and status for each component of the dashboard. |
| `dashboardMetadata` | Dashboard metadata | Metadata for the entire dashboard. |

### Attributes

| Property | Type | Description |
|---|---|---|
| `dashboardId` | String | Unique identifier of dashboard. |
| `dashboardName` | String | Dashboard name. |
| `statusUrl` | Url | The URL of the status resource for the dashboard. |
| `type` | String | This property is always set to Dashboard. |

### Component data

| Property | Type | Description |
|---|---|---|
| `componentId` | String | Unique identifier of the component. |
| `reportResult` | Report results | Report metadata and summary data for the dashboard component. Uses the same data format as the Report API. |
| `status` | Component status | Queue and data status of the component. |

### Component status

| Property | Type | Description |
|---|---|---|
| `dataStatus` | String | Status of the data set of the component. Value can be:<br>• NODATA: The data set was never generated or is invalid due to a change in the report.<br>• DATA: The data set is available and was last refreshed at the refreshDate.<br>• ERROR: A component error has occurred. Details can be found in errorCode, errorMessage, and errorSeverity. |
| `errorCode` | String | Unique identifier of error message. This property is only populated in case of error. |
| `errorMessage` | String | Localized error message. This property is only populated in case of error. |
| `errorSeverity` | String | Severity of error code and message. Value can be:<br>• Error<br>• Warning<br>This property is only populated in case of error. |
| `refreshDate` | Date and time string | Date and time of last refresh in ISO-8601 format. |
| `refreshStatus` | String | Refresh status of the component. Value can be:<br>• IDLE: The component is not currently being refreshed.<br>• RUNNING: The component is currently being refreshed. |

### Dashboard metadata

| Property | Type | Description |
|---|---|---|
| `attributes` | Attributes | Attributes for the dashboard resource, such as name, identifier, and references to other related resources. |
| `canChangeRunningUser` | Boolean | Indicates whether the user is allowed to select a specific running user. Always true for team dashboards. |
| `canUseStickyFilter` | Boolean | Indicates whether dashboard filters persist after closing the dashboard (true) or not (false). Filters that persist keep the dashboard filtered the next time you open it. Filters persist for users on a per-user basis, so if you apply a filter then it doesn't persist for other people. |
| `chartTheme` | String | Specifies the dashboard theme. Possible values are:<br>• light—Default value. Dashboards have a light background that resembles a glass of milk.<br>• dark—Dashboards have a dark background that is reminiscent of the night sky. |
| `colorPalette` | String | Specifies a color palette for use in charts. Possible values are:<br>• wildflowers—Default value.<br>• aurora<br>• nightfall<br>• sunrise<br>• bluegrass<br>• ocean<br>• heat<br>• dusk<br>• pond<br>• watermelon<br>• fire<br>• water<br>• lake<br>• mineral—Accessible. |
| `components` | Components[] | Ordered array of components in this dashboard. |
| `description` | String | Dashboard description. |
| `dashboardType` | String | Indicates whether a dashboard is a dynamic dashboard, a dashboard with running users, or a standard dashboard. Possible values are:<br>• SpecifiedUser — Dashboard readers view data as though they are the person specified by runningUser<br>• LoggedInUser — Dashboard readers view data as themselves. The dashboard is a dynamic dashboard.<br>• MyTeamUser — Dashboard readers view data as the person specified by runningUser by default. If they have the "View All Data" user permission then they can change the runningUser to anyone. If they have the "View My Team's Dashboards" user permission then they can change the runningUser to people subordinate to them in the role hierarchy. |
| `developerName` | String | Unique API name of the dashboard. |
| `filters` | Filters[] | Ordered array of filters for this dashboard. The dashboard can have 0-3 filters. |
| `folderId` | String | ID of the folder that contains the dashboard. |
| `id` | String | Unique identifier of dashboard. |
| `layout` | Layout | Component layout for this dashboard. |
| `maxFilterOptions` | Integer | The maximum number of values allowed in a dashboard filter. |
| `name` | String | Dashboard name. |
| `runningUser` | Running user | The running user, which is either specified at dashboard design time, or is overridden by the runningUser parameter specified in the GET request. For dynamic dashboards, this is always the current user. |

### Components

| Property | Type | Description |
|---|---|---|
| `componentData` | Integer | Index into the component data array in the response body. |
| `footer` | String | Footer of the component. |
| `header` | String | Header of the component. |
| `id` | String | Unique identifier of the component. |
| `properties` | Properties (for Report component type)<br>Properties (for Visualforce page component type) | Component properties, including type-specific visualization properties. |
| `reportId` | String | Unique identifier of the underlying report. |
| `title` | String | Title of the component |
| `type` | String | Type of the component. Value can be:<br>• Report<br>• VisualforcePage<br>If the component is an SControl, the value is not set. |

### Filters

| Property | Type | Description |
|---|---|---|
| `errorMessage` | String | If there is no error with a dashboard filter, then null. Otherwise, the error message is returned. |
| `name` | String | Localized display name of filter. |
| `options` | Filter option | Ordered array of possible filter options. |
| `selectedOption` | Integer | Index of the selected option from the options array. This matches the selection that was made based on the filter1, filter2, or filter3 parameter. Value is null if no option is selected. |

### Filter option

| Property | Type | Description |
|---|---|---|
| `alias` | String | Optional alias of the filter option. |
| `id` | String | Unique identifier of the filter option. Used as a value for the filter1, filter2, and filter3 parameters. |
| `operation` | String | Unique API name for the filter operation. Valid filter operations depend on the data type of the filter field. Value can be:<br>• equals<br>• notEqual<br>• lessThan<br>• greaterThan<br>• lessOrEqual<br>• greaterOrEqual<br>• contains<br>• notContain<br>• startsWith<br>• includes<br>• excludes<br>• within<br>• between |
| `value` | String | Value to filter on. Used for all operations except between. |
| `startValue` | String | Start value when using a between operation. Not set for all other operations. |
| `endValue` | String | End value when using a between operation. Not set for all other operations. |

### Layout

| Property | Type | Description |
|---|---|---|
| `columns` | Columns[] | Dashboard layout columns. Can have 2 or 3 columns, including empty columns. This property is available only if the dashboard was created using Salesforce Classic. |
| `components` | Components | Layout for dashboards. This property is available only if the dashboard was created using Lightning Experience. |

### Columns

| Property | Type | Description |
|---|---|---|
| `components` | Integer[] | Ordered list of components in a column (top to bottom). Components are represented by indices into the array of components in the dashboard metadata object. |
| `colspan` | Integer | Width of component in columns. For example, if colspan=3, then the component spans 3 columns. |
| `rowspan` | Integer | Height of component in rows. For example, if rowspan=4, then the component spans 4 rows. |
| `column` | String | Column position on the grid. |
| `row` | String | Row position on the grid. |

### Running user

| Property | Type | Description |
|---|---|---|
| `displayName` | String | Display name of running user. |
| `id` | String | Returns the ID of the running user specified for the dashboard. If the dashboard is configured to run as the viewing user, returns the user ID of the dashboard creator. |

### picklistColors

| Property | Type | Description |
|---|---|---|
| `color` | String | The color in hexadecimal format used to represent a picklist value. |

### Properties (for Report component type)

| Property | Type | Description |
|---|---|---|
| `aggregates` | Array of strings | Unique identities for summary or custom summary formula fields in the report. For example:<br>• a!Amount represents the average for the Amount column.<br>• s!Amount represents the sum of the Amount column.<br>• m!Amount represents the minimum value of the Amount column.<br>• x!Amount represents the maximum value of the Amount column.<br>• s!&lt;customfieldID&gt; represents the sum of a custom field column. For custom fields and custom report types, the identity is a combination of the summary type and the field ID.<br>• u!{column_name} represents a unique count of values for the specified {column_name}. For example, u!AccountName returns the number of unique account name values in the AccountName field. |
| `autoSelectColumns` | Boolean | Indicates whether groupings and aggregates are automatically selected. Valid values are true and false. |
| `drillUrl` | String | Specifies a custom link destination from a dashboard component. If drillURL begins with https:// or http:// or www., then the link directs to a website outside of Salesforce. Otherwise, the destination is a site inside Salesforce. Null if no link is set. |
| `groupings` | Groupings | Report groupings included in the dashboard. |
| `maxRows` | Number | Maximum number of rows to be rendered, based on the sort value. |
| `reportFormat` | String | The format of a dashboard's source report. |
| `sort` | Sort | Used in previous releases. In this release (v46.0) and later assign the value null, except for the following instances:<br>• Tabular lightning table format<br>• Top N source report for any chart type<br>In these two cases, the value matches the following object:<br>`{ "sort" : { "column" : "TYPE", "sortOrder" : "asc", "type" : "label" }, }` |
| `useReportChart` | Boolean | Indicates whether the dashboard component uses the chart as defined in the report. Valid values are true and false. |
| `useReportTableSetting` | Boolean | Indicates whether the widget uses report settings when a Lightning table is added to a dashboard. Valid values are true and false. |
| `visualizationProperties` | Visualization properties (Chart)<br>Visualization properties (Table)<br>Visualization properties (FlexTable)<br>Visualization properties (Metric)<br>Visualization properties (Gauge) | Type-specific visualization properties. |
| `visualizationType` | String | Type of the component. Value can be:<br>• Bar<br>• Column<br>• Donut<br>• Funnel<br>• Gauge<br>• Line<br>• Metric<br>• Pie<br>• Scatter<br>• Table<br>• FlexTable (As of API Version 41.0) |

### Groupings

| Property | Type | Description |
|---|---|---|
| `inheritedReportSort` | String | For this release (v46.0) and later, keep the default value of null for this property and use sortOrder instead. |
| `name` | String | Developer name of the grouping. |
| `sortAggregate` | String | Name of the aggregate by which the dashboard component sorts. If null, the dashboard component sorts by label or matches/inverts the report's sort order. |
| `sortOrder` | String | Specifies whether the dashboard component sorts in ascending (Asc) or descending (Desc) order. |

### Sort

| Property | Type | Description |
|---|---|---|
| `inheritedReportSort` | String | For this release (v46.0) and later, keep the default value of null for this property and use sortOrder instead. |
| `sortAggregate` | String | Name of the aggregate by which the dashboard component sorts. If null, the dashboard component sorts by label or matches/inverts the report's sort order. |
| `sortOrder` | String | Specifies whether the dashboard component sorts in ascending (Asc) or descending (Desc) order. |

### Visualization properties (Chart)

| Property | Type | Description |
|---|---|---|
| `axisRange` | String | Range of values specified for the axis. |
| `decimalPrecision` | Integer | The number of decimal places included in a dashboard metric, chart, or table, 0–5. If -1 or null, Salesforce automatically sets the number of decimal places. |
| `displayUnits` | String | Specify how to display numbers. Possible values are:<br>• whole — Display the true value of the number without rounding it.<br>• auto — Display the number rounded to the nearest thousand, million, etc. and displayed as a shortened value. For example, 1,876 displays as 1.9k. In calculating summaries, the true value of the number (1,876) is used , even if 1.9k is displayed.<br>• hundreds — Display as multiples of 100.<br>• thousands — Display as multiples of 1,000.<br>• millions — Display as multiples of 1,000,000.<br>• billions — Display as multiples of 1,000,000,000.<br>• trillions — Display as multiples of 1,000,000,000,000.<br>• null — Customizing how numbers display isn't applicable.. _[sic — 마침표 2개]_ |
| `drillURL` | String | Specifies a custom link destination from a dashboard component. If drillURL begins with https:// or http:// or www., then the link directs to a website outside of Salesforce. Otherwise, the destination is a site inside Salesforce. Null if no link is set. |
| `groupByType` | String | Type of second-level grouping. |
| `legendPosition` | String | Position of legend on the grid. Valid values are bottom, right, and none. |
| `showValues` | Boolean | Indicates whether to include values in the chart. Valid values are true and false. |

### Visualization properties (Table)

| Property | Type | Description |
|---|---|---|
| `breakPoints` | Break point[] | Break points for the table component. |
| `displayUnits` | String | Specify how to display numbers. Possible values are:<br>• whole — Display the true value of the number without rounding it.<br>• auto — Display the number rounded to the nearest thousand, million, etc. and displayed as a shortened value. For example, 1,876 displays as 1.9k. In calculating summaries, the true value of the number (1,876) is used , even if 1.9k is displayed.<br>• hundreds — Display as multiples of 100.<br>• thousands — Display as multiples of 1,000.<br>• millions — Display as multiples of 1,000,000.<br>• billions — Display as multiples of 1,000,000,000.<br>• trillions — Display as multiples of 1,000,000,000,000.<br>• null — Customizing how numbers display isn't applicable.. _[sic]_ |
| `drillURL` | String | Specifies a custom link destination from a dashboard component. If drillURL begins with https:// or http:// or www., then the link directs to a website outside of Salesforce. Otherwise, the destination is a site inside Salesforce. Null if no link is set. |
| `tableColumns` | Table columns[] | Columns of the table component. |

### Visualization properties (FlexTable)

> "FlexTable is the API name of the Lightning dashboard table."

| Property | Type | Description |
|---|---|---|
| `displayUnits` | String | Specifies how to display numbers in dashboard components. Each value displays numbers as a multiple of a hundred (hundreds), thousand (thousands), million (millions), billion (billions), or trillion (trillions). |
| `drillURL` | String | Specifies a custom link destination from a dashboard component. If drillURL begins with https:// or http:// or www., then the link directs to a website outside of Salesforce. Otherwise, the destination is a site inside Salesforce. Null if no link is set. |
| `flexTableType` | String | Specifies whether the table shows detail columns or groups and measures. Possible values are:<br>• tabular — The table displays detail rows.<br>• summary — The table displays groups and measures. |
| `showChatterPhotos` | Boolean | Indicates whether Chatter photos are shown (true) or not (false). |
| `tableColumns` | Table columns[] | Columns of the table component. |

> FlexTable의 `displayUnits` 설명은 다른 표현형과 **다르다** — multiple-of 형식만 나열하고 whole/auto/null 값이 없다. 위 원문 그대로 유지.

### Visualization properties (Metric)

| Property | Type | Description |
|---|---|---|
| `breakPoints` | Break point[] | Break points for the metric component. |
| `displayUnits` | String | Specify how to display numbers. Possible values are:<br>• whole — Display the true value of the number without rounding it.<br>• auto — Display the number rounded to the nearest thousand, million, etc. and displayed as a shortened value. For example, 1,876 displays as 1.9k. In calculating summaries, the true value of the number (1,876) is used , even if 1.9k is displayed.<br>• hundreds — Display as multiples of 100.<br>• thousands — Display as multiples of 1,000.<br>• millions — Display as multiples of 1,000,000.<br>• billions — Display as multiples of 1,000,000,000.<br>• trillions — Display as multiples of 1,000,000,000,000.<br>• null — Customizing how numbers display isn't applicable.. _[sic]_ |
| `drillURL` | String | Specifies a custom link destination from a dashboard component. If drillURL begins with https:// or http:// or www., then the link directs to a website outside of Salesforce. Otherwise, the destination is a site inside Salesforce. Null if no link is set. |
| `metricLabel` | String | Label for the metric component. |

### Visualization properties (Gauge)

| Property | Type | Description |
|---|---|---|
| `breakPoints` | Break point[] | Break points for the gauge component. |
| `displayUnits` | String | Specify how to display numbers. Possible values are:<br>• whole — Display the true value of the number without rounding it.<br>• auto — Display the number rounded to the nearest thousand, million, etc. and displayed as a shortened value. For example, 1,876 displays as 1.9k. In calculating summaries, the true value of the number (1,876) is used , even if 1.9k is displayed.<br>• hundreds — Display as multiples of 100.<br>• thousands — Display as multiples of 1,000.<br>• millions — Display as multiples of 1,000,000.<br>• billions — Display as multiples of 1,000,000,000.<br>• trillions — Display as multiples of 1,000,000,000,000.<br>• null — Customizing how numbers display isn't applicable.. _[sic]_ |
| `drillURL` | String | Specifies a custom link destination from a dashboard component. If drillURL begins with https:// or http:// or www., then the link directs to a website outside of Salesforce. Otherwise, the destination is a site inside Salesforce. Null if no link is set. |
| `showPercentages` | Boolean | Specify whether percentages are displayed (true) or not (false) _[sic — 끝 마침표 없음]_ |
| `showTotal` | Boolean | Indicates whether the total is displayed (true) or not (false). |

### Break point

| Property | Type | Description |
|---|---|---|
| `aggregateName` | String | Aggregate column developer name that the break points have been applied to. |
| `breaks` | Break[] | Break values for a break point. |

### Break

| Property | Type | Description |
|---|---|---|
| `color` | String | A hex value representing the color for the break point.<br>**Note:** A color value of black displays only 1 character (0) instead of 6 characters (000000). |
| `lowerBound` | Number | Lower bound for the break point. |
| `upperBound` | Number | Upper bound for the break point. |

### Table columns

| Property | Type | Description |
|---|---|---|
| `column` | String | Developer name for the aggregate or grouping column. |
| `isPercent` | Boolean | Indicates whether the column value is shown as a percent (true) or not (false). Not supported for FlexTables. |
| `scale` | Number | The number of decimal places for the column value. Not supported for FlexTables. |
| `showTotal` | Boolean | Indicates whether the column shows the total (true) or not (false). |
| `type` | String | Type of the column. Valid values are:<br>• detail<br>• aggregate<br>• grouping |

### Properties (for Visualforce page component type)

| Property | Type | Description |
|---|---|---|
| `pageName` | String | Developer name of the Visualforce page. |
| `height` | String | Height of the Visualforce page, in pixels. |

### tableChatterPhotoUrls

| Property | Type | Description |
|---|---|---|
| `chatterPhotoUrl` | String | URL pointing to a user's Chatter photo. |

### PUT Response body

| Property | Type | Description |
|---|---|---|
| `statusUrl` | String | URL of the status resource for the dashboard. |

### POST Request body

| Property | Type | Description |
|---|---|---|
| `componentIds` | Array of Strings | Dashboard component ids. |

> Dashboard Results 섹션 내 inline JSON 예제는 PDF 본문에 없다. DELETE Response body, PATCH Request/Response body도 별도 표가 없으며 POST Request body까지가 섹션 끝이다.

---

## 3. Dashboard Describe

지정한 대시보드의 메타데이터(컴포넌트·필터·레이아웃·running user 포함)를 반환한다.

- **URI:** `/services/data/vXX.X/analytics/dashboards/dashboardID/describe`
- **Formats:** JSON · **HTTP methods:** GET · **Authentication:** `Authorization: Bearer token`
- **Example:** "See this example, Get Dashboard Metadata."

### Parameters

| Parameter | Description |
|---|---|
| `loadComponentProperties` | Optional. Specifies whether or not to return properties for each dashboard component. The default value is true. Has no effect on filtered dashboards. Valid values are:<br>• true — Return component properties.<br>• false — Don't return component properties. The properties value instead returns null. |

### Response body

| Property | Type | Description |
|---|---|---|
| `attributes` | Attributes | Attributes for the dashboard resource, such as name, identifier, and references to other related resources. |
| `canChangeRunningUser` | Boolean | Indicates whether the user is allowed to select a specific running user. Always true for team dashboards. |
| `canUseStickyFilter` | Boolean | Indicates whether dashboard filters persist after closing the dashboard (true) or not (false). Filters that persist keep the dashboard filtered the next time you open it. Filters persist for users on a per-user basis, so if you apply a filter then it doesn't persist for other people. |
| `chartTheme` | String | Specifies the dashboard theme. Possible values are:<br>• light—Default value. Dashboards have a light background that resembles a glass of milk.<br>• dark—Dashboards have a dark background that is reminiscent of the night sky. |
| `colorPalette` | String | Specifies a color palette for use in charts. Possible values are:<br>• wildflowers—Default value.<br>• aurora<br>• nightfall<br>• sunrise<br>• bluegrass<br>• ocean<br>• heat<br>• dusk<br>• pond<br>• watermelon<br>• fire<br>• water<br>• lake<br>• mineral—Accessible. |
| `components` | Components[] | Ordered array of components in this dashboard. |
| `description` | String | Dashboard description. |
| `dashboardType` | String | Indicates whether a dashboard is a dynamic dashboard, a dashboard with running users, or a standard dashboard. Possible values are:<br>• SpecifiedUser — Dashboard readers view data as though they are the person specified by runningUser<br>• LoggedInUser — Dashboard readers view data as themselves. The dashboard is a dynamic dashboard.<br>• MyTeamUser — Dashboard readers view data as the person specified by runningUser by default. If they have the "View All Data" user permission then they can change the runningUser to anyone. If they have the "View My Team's Dashboards" user permission then they can change the runningUser to people subordinate to them in the role hierarchy. |
| `developerName` | String | Unique API name of the dashboard. |
| `filters` | Filters[] | Ordered array of filters for this dashboard. The dashboard can have 0-3 filters. |
| `folderId` | String | ID of the folder that contains the dashboard. |
| `id` | String | Unique identifier of dashboard. |
| `layout` | Layout | Component layout for this dashboard. |
| `maxFilterOptions` | Integer | The maximum number of values allowed in a dashboard filter. |
| `name` | String | Dashboard name. |
| `runningUser` | Running user | The running user, which is either specified at dashboard design time, or is overridden by the runningUser parameter specified in the GET request. For dynamic dashboards, this is always the current user. |

### Components

*(Dashboard Results의 Components와 동일 — 아래 verbatim)*

| Property | Type | Description |
|---|---|---|
| `componentData` | Integer | Index into the component data array in the response body. |
| `footer` | String | Footer of the component. |
| `header` | String | Header of the component. |
| `id` | String | Unique identifier of the component. |
| `properties` | Properties (for Report component type)<br>Properties (for Visualforce page component type) | Component properties, including type-specific visualization properties. |
| `reportId` | String | Unique identifier of the underlying report. |
| `title` | String | Title of the component |
| `type` | String | Type of the component. Value can be:<br>• Report<br>• VisualforcePage<br>If the component is an SControl, the value is not set. |

### Properties (for Report component type)

*(Dashboard Results와 동일 구조 — verbatim)*

| Property | Type | Description |
|---|---|---|
| `aggregates` | Array of strings | Unique identities for summary or custom summary formula fields in the report. For example:<br>• a!Amount represents the average for the Amount column.<br>• s!Amount represents the sum of the Amount column.<br>• m!Amount represents the minimum value of the Amount column.<br>• x!Amount represents the maximum value of the Amount column.<br>• s!&lt;customfieldID&gt; represents the sum of a custom field column. For custom fields and custom report types, the identity is a combination of the summary type and the field ID.<br>• u!{column_name} represents a unique count of values for the specified {column_name}. For example, u!AccountName returns the number of unique account name values in the AccountName field. |
| `autoSelectColumns` | Boolean | Indicates whether groupings and aggregates are automatically selected. Valid values are true and false. |
| `drillUrl` | String | Specifies a custom link destination from a dashboard component. If drillURL begins with https:// or http:// or www., then the link directs to a website outside of Salesforce. Otherwise, the destination is a site inside Salesforce. Null if no link is set. |
| `groupings` | Groupings | Report groupings included in the dashboard. |
| `maxRows` | Number | Maximum number of rows to be rendered, based on the sort value. |
| `reportFormat` | String | The format of a dashboard's source report. |
| `sort` | Sort | Used in previous releases. In this release (v46.0) and later assign the value null, except for the following instances:<br>• Tabular lightning table format<br>• Top N source report for any chart type<br>In these two cases, the value matches the following object:<br>`{ "sort" : { "column" : "TYPE", "sortOrder" : "asc", "type" : "label" }, }` |
| `useReportChart` | Boolean | Indicates whether the dashboard component uses the chart as defined in the report. Valid values are true and false. |
| `useReportTableSetting` | Boolean | Indicates whether the widget uses report settings when a Lightning table is added to a dashboard. Valid values are true and false. |
| `visualizationProperties` | Visualization properties (Chart)<br>Visualization properties (Table)<br>Visualization properties (FlexTable)<br>Visualization properties (Metric)<br>Visualization properties (Gauge) | Type-specific visualization properties. |
| `visualizationType` | String | Type of the component. Value can be:<br>• Bar<br>• Column<br>• Donut<br>• Funnel<br>• Gauge<br>• Line<br>• Metric<br>• Pie<br>• Scatter<br>• Table<br>• FlexTable (As of API Version 41.0) |

### Sort

| Property | Type | Description |
|---|---|---|
| `inheritedReportSort` | String | For this release (v46.0) and later, keep the default value of null for this property and use sortOrder instead. |
| `sortAggregate` | String | Name of the aggregate by which the dashboard component sorts. If null, the dashboard component sorts by label or matches/inverts the report's sort order. |
| `sortOrder` | String | Specifies whether the dashboard component sorts in ascending (Asc) or descending (Desc) order. |

> Describe의 표현형 배열은 Results와 **다르다**: Describe에서는 Properties(Report) 뒤에 **Sort** 표가 바로 오고 (별도 Groupings 표는 없음), 이어서 Visualization properties 군이 온다.

### Visualization properties (Chart)

| Property | Type | Description |
|---|---|---|
| `axisRange` | String | Range of values specified for the axis. |
| `decimalPrecision` | Integer | The number of decimal places included in a dashboard metric, chart, or table, 0–5. If -1 or null, Salesforce automatically sets the number of decimal places. |
| `displayUnits` | String | Specify how to display numbers. Possible values are: whole / auto / hundreds / thousands / millions / billions / trillions / null. (Dashboard Results의 Chart displayUnits 8개 값과 동일 verbatim. "isn't applicable.." _[sic]_) |
| `drillURL` | String | Specifies a custom link destination from a dashboard component. If drillURL begins with https:// or http:// or www., then the link directs to a website outside of Salesforce. Otherwise, the destination is a site inside Salesforce. Null if no link is set. |
| `groupByType` | String | Type of second-level grouping. |
| `legendPosition` | String | Position of legend on the grid. Valid values are bottom, right, and none. |
| `showValues` | Boolean | Indicates whether to include values in the chart. Valid values are true and false. |

### Visualization properties (Table)

| Property | Type | Description |
|---|---|---|
| `breakPoints` | Break point[] | Break points for the table component. |
| `displayUnits` | String | Specify how to display numbers. Possible values are: whole / auto / hundreds / thousands / millions / billions / trillions / null (Dashboard Results와 동일 8개 값 verbatim). |
| `drillURL` | String | Specifies a custom link destination from a dashboard component. (Chart와 동일 verbatim) |
| `tableColumns` | Table columns[] | Columns of the table component. |

### Visualization properties (Metric)

| Property | Type | Description |
|---|---|---|
| `breakPoints` | Break point[] | Break points for the metric component. |
| `displayUnits` | String | Specify how to display numbers. Possible values are: whole / auto / hundreds / thousands / millions / billions / trillions / null (Dashboard Results와 동일 8개 값 verbatim). |
| `drillURL` | String | (Chart와 동일 verbatim) |
| `metricLabel` | String | Label for the metric component. |

### Visualization properties (Gauge)

| Property | Type | Description |
|---|---|---|
| `breakPoints` | Break point[] | Break points for the gauge component. |
| `displayUnits` | String | Specify how to display numbers. Possible values are: whole / auto / hundreds / thousands / millions / billions / trillions / null (Dashboard Results와 동일 8개 값 verbatim). |
| `drillURL` | String | (Chart와 동일 verbatim) |
| `showPercentages` | Boolean | Specify whether percentages are displayed (true) or not (false) _[sic]_ |
| `showTotal` | Boolean | Indicates whether the total is displayed (true) or not (false). |

> Describe 본문에는 **Visualization properties (FlexTable) 상세표가 없다** (Results에는 있었음). Describe는 Chart/Table/Metric/Gauge 4종만 표로 전개한다. `visualizationProperties` 행의 Type 셀에는 FlexTable 참조가 여전히 나열되나 별도 상세표는 Describe 섹션에 미출력된다. — PDF 본문 자체의 구조이며 조용한 누락이 아니다.

### Properties (for Visualforce page component type)

| Property | Type | Description |
|---|---|---|
| `pageName` | String | Developer name of the Visualforce page. |
| `height` | String | Height of the Visualforce page, in pixels. |

### Filters

| Property | Type | Description |
|---|---|---|
| `errorMessage` | String | If there is no error with a dashboard filter, then null. Otherwise, the error message is returned. |
| `name` | String | Localized display name of filter. |
| `options` | Filter option | Ordered array of possible filter options. |
| `selectedOption` | Integer | Index of the selected option from the options array. This matches the selection that was made based on the filter1, filter2, or filter3 parameter. Value is null if no option is selected. |

### Filter option

| Property | Type | Description |
|---|---|---|
| `alias` | String | Optional alias of the filter option. |
| `id` | String | Unique identifier of the filter option. Used as a value for the filter1, filter2, and filter3 parameters. |
| `operation` | String | Unique API name for the filter operation. Valid filter operations depend on the data type of the filter field. Value can be:<br>• equals<br>• notEqual<br>• lessThan<br>• greaterThan<br>• lessOrEqual<br>• greaterOrEqual<br>• contains<br>• notContain<br>• startsWith<br>• includes<br>• excludes<br>• within<br>• between |
| `value` | String | Value to filter on. Used for all operations except between. |
| `startValue` | String | Start value when using a between operation. Not set for all other operations. |
| `endValue` | String | End value when using a between operation. Not set for all other operations. |

### Layout

| Property | Type | Description |
|---|---|---|
| `columns` | Columns[] | Dashboard layout columns. Can have 2 or 3 columns, including empty columns. This property is available only if the dashboard was created using Salesforce Classic. |
| `components` | Components | Layout for dashboards. This property is available only if the dashboard was created using Lightning Experience. |

### Columns

| Property | Type | Description |
|---|---|---|
| `components` | Integer[] | Ordered list of components in a column (top to bottom). Components are represented by indices into the array of components in the dashboard metadata object. |
| `colspan` | Integer | Width of component in columns. For example, if colspan=3, then the component spans 3 columns. |
| `rowspan` | Integer | Height of component in rows. For example, if rowspan=4, then the component spans 4 rows. |
| `column` | String | Column position on the grid. |
| `row` | String | Row position on the grid. |

### Running user

| Property | Type | Description |
|---|---|---|
| `displayName` | String | Display name of running user. |
| `id` | String | Returns the ID of the running user specified for the dashboard. If the dashboard is configured to run as the viewing user, returns the user ID of the dashboard creator. |

> **Describe에 없는 표 (Results 대비):** picklistColors, 별도 Groupings, FlexTable 상세, Break point / Break / Table columns 상세, tableChatterPhotoUrls는 Describe 본문에 출력되지 않는다 (Type 셀 참조로만 언급). PDF 본문 자체가 Describe에서 이들 상세표를 생략한 것이며 조용한 누락이 아니다.

---

## 4. Dashboard Status

지정한 대시보드의 상태를 반환한다.

- **URI:** `/services/data/vXX.X/analytics/dashboards/dashboardID/status`
- **선택 파라미터 포함:** `/services/data/vXX.X/analytics/dashboards/dashboardID/status?runningUser=runningUserID&filter1=filter1ID&filter2=filter2ID&filter3=filter3ID`
- **Formats:** JSON · **HTTP methods:** GET · **Authentication:** `Authorization: Bearer token`

### Parameters (GET 메서드에서 사용, 선택)

| Parameter Name | Description |
|---|---|
| `runningUser` | ID of the running user. Gives an error if the user is not allowed to change the running user, or if the selected running user is invalid. |
| `filter1` | ID of the selected filter option for the first filter. Gives an error if the filter option is invalid. |
| `filter2` | ID of the selected filter option for the second filter. Gives an error if the filter option is invalid. |
| `filter3` | ID of the selected filter option for the third filter. Gives an error if the filter option is invalid. |

### Response body

| Property | Type | Description |
|---|---|---|
| `componentStatus` | Component status with id[] | Status for each component of the dashboard. The order of the array is the same as in previous calls, unless the dashboard has changed in the meantime. |

### Component status with id

| Property | Type | Description |
|---|---|---|
| `componentId` | String | Unique ID of the dashboard component. |
| `refreshDate` | Date and time string | Date and time of last refresh in ISO-8601 format. |
| `refreshStatus` | String | Refresh status of the component. Value can be:<br>• IDLE: The component is not currently being refreshed.<br>• RUNNING: The component is currently being refreshed. |

---

## 5. Dashboard Filter Options Analysis

대시보드 필터 옵션이 소스 리포트 필드와 호환되는지 검증한다. (Available in API version 40.0 and later.)

> 섹션 설명 원문(추출 줄바꿈 아티팩트 포함): "Verifies that dashboard filter options are compatible with source report fields. Use this resource to test **Available in API version 40.0 and later.**" — _[sic]_ PDF에서 "Use this resource to test..." 문장 뒤에 버전 노트가 붙어 출력됨. 본래 의도는 필터 옵션 호환성 검증 리소스(API v40.0+).

- **URI:** `/services/data/vXX.X/analytics/dashboards/dashboardID/filteroptionsanalysis`
- **Formats:** JSON · **HTTP methods:** POST · **Authentication:** `Authorization: Bearer token`

### POST Request Body

| Property | Type | Description |
|---|---|---|
| `filterColumns` | filterColumns[] | An array of fields from the source report which you check filter values against. Each object in the array has these properties:<br>**reportId** — The the source report's unique ID. _[sic — "The the"]_<br>**name** — The report field's API name. |
| `options` | options[] | An array of objects describing a dashboard filter. Each object has these properties:<br>**alias** — The display name of the filter value.<br>**operation** — The filter's operator.<br>**value** — The value applied by the filter.<br>**startValue** — If the filter includes a range (such as a date range), the start of the range. Otherwise, null.<br>**endValue** — If the filter includes a range (such as a date range), the end of the range. Otherwise, null. |

### POST Response Body

> "If successful, returns an empty response."

### Example POST Request

```json
{
"filterColumns" : [{
"reportId": "00OR0000000P76tMAC",
"name": "ACCOUNT_TYPE"
}],
"options": [{
"alias": "New",
"operation": "contains",
"value": "New",
"startValue": null,
"endValue": null
}]
}
```

---

## 6. Dashboard and Component Error Codes

> "Errors can occur at the dashboard level and at the component level."
> "Dashboard-level error messages are returned in the response header, and component-level error messages are returned as part of the component status object."
> "To view a complete list of error messages, see Status Codes and Error Responses."

### Dashboard-level errors

> "When a dashboard-level error occurs, the response header contains an HTTP response code and one of the following error messages:"

(아래 6개 에러의 HTTP Response Code는 모두 `400`이다.)

| HTTP Response Code | Error Message |
|---|---|
| 400 | The running user for this dashboard doesn't have permission to run reports. Your system administrator should select a different running user for this dashboard. |
| 400 | The running user for this dashboard is inactive. Your system administrator should select an active user for this dashboard. |
| 400 | You don't have permission to view data as this user. |
| 400 | Your organization has reached the limit for dynamic dashboards, or doesn't have access. Ask your administrator to enable dynamic dashboards or convert them to dashboards with a specific running user. |
| 400 | The selected filter item isn't valid. |
| 400 | You can't refresh this dashboard. A refresh is already in progress. |

### Component-level errors

> "If an error occurs at the component level, the errorCode, errorMessage, and errorSeverity properties of the component status field are populated. The errorSeverity property distinguishes between errors and warnings. Errors are blocking issues that prevent the query from returning any data. Warnings are non-blocking issues; queries will finish, but they might return incomplete data. The following table shows the possible values for the error fields."

(errorSeverity unique 값: **Error**, **Warning**. 코드는 309 다음 403으로 점프 — 310–402 행은 PDF 자체에 부재.)

| errorCode | errorMessage | errorSeverity |
|---|---|---|
| 201 | This component must have a type and a data source. | Error |
| 202 | The source report isn't available; it's been deleted or isn't in a folder accessible to the dashboard's running user. | Error |
| 203 | This report can no longer be edited or run. Your administrator has disabled all reports for the custom or external object, or its relationships have changed. | Error |
| 205 | The source report is based on a report type that is inaccessible to the dashboard's running user. | Error |
| 208 | Unable to run source report because its definition is invalid. | Error |
| 209 | This report cannot be used as the source for this component. If it is a summary or matrix report, add one or more groupings in the report. If it is a tabular report with a row limit, specify the Dashboard Settings in the report. | Error |
| 210 | This row-limited tabular report cannot be used as the source for this component. Use the dashboard component editor to specify the data you want to display, or specify the Dashboard Settings in the report. | Error |
| 211 | To use this row-limited tabular report as the source, edit the report and specify the Name and Value under Dashboard Settings. When updating the report, make sure you are the running user of the dashboard. | Error |
| 212 | Groupings and combination charts are not available for a row-limited tabular report. Set "Group By" to None and deselect "Plot Additional Values." | Error |
| 300 | The results below may be incomplete because the underlying report produced too many summary rows, and the sort order of the component is different from the sort order in the underlying report. Try adding filters to the report to reduce the number of rows returned. | Error |
| 301 | Results may be incomplete because the source report had too many summary rows. Try filtering the report to reduce the number of rows returned. | Warning |
| 302 | The component can't be displayed because the source report exceeded the time limit. | Warning |
| 303 | The component can't be displayed because the source report failed to run. | Error |
| 304 | The component can't be displayed because the dashboard filter raises the number of source report filters above the limit. Reduce the number of report filters and try again. | Error |
| 305 | The component can't be displayed because the field(s) you chose for the filter are unavailable. | Error |
| 308 | You can't filter this component because data is in the joined report format. To filter the component, change its report format. | Error |
| 309 | The underlying report uses a snapshot date that is out of range. | Error |
| 403 | The request has been refused. Verify that the logged-in user has appropriate permissions. If the error code is REQUEST_LIMIT_EXCEEDED, you've exceeded API request limits in your org. | Error |
| 409 | The request couldn't be completed due to a conflict with the current state of the resource. Check that the API version is compatible with the resource you're requesting. | Error |

---

## 관련 노트

- [[Reports and Dashboards REST API — Dashboards·Downloads·Notifications 예제]]
- [[Reports and Dashboards REST API — Report 표현형]]
- [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]]
- [[Reports and Dashboards REST API — Report Fields·Error Codes 표현형]]
- [[Reports and Dashboards REST API — 개요·Reports 예제]]
