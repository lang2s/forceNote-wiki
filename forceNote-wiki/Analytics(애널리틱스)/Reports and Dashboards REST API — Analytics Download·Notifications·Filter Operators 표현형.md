---
tags: [analytics, rest-api, reports-dashboards-rest, analytics-download, analytics-notifications, filter-operators]
source: salesforce_analytics_rest_api.pdf (Reports and Dashboards REST API Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Analytics Download API, Analytics Notifications API, Filter Operators API, 알림 구독 REST, filteroperators, notification schedule]
---

# Reports and Dashboards REST API — Analytics Download · Notifications · Filter Operators 표현형

> Reports and Dashboards REST API의 Analytics Download(이미지/PDF 다운로드) · Analytics Notifications(알림 구독 — 13종 중첩 표현형 전수) · Filter Operators(16개 데이터타입별 필터 연산자) 리소스와 응답 표현형을 공식 가이드 v67.0 Summer '26에서 추출한 노트.

---

## Analytics Download

Use the Analytics Download API to download images and PDFs of Analytics assets, including CRM Analytics dashboards and lenses and Lightning Experience dashboards and reports. **Available in API version 55.0 and later.**

> **Note:** To use the Analytics Download API, your org must have a CRM Analytics license. In addition, your org needs both Slack for Salesforce and CRM Analytics for Slack enabled. For more information, see Enable Salesforce for Slack Integrations.

리소스는 `domain/analytics/download` 아래에 위치하며, **다운로드는 브라우저 호출(browser calls)로 요청**한다.

### Resource

| Resource | Description |
|---|---|
| `domain/analytics/download/assetType/Id.downloadType` | When downloadType has a value of `png`, downloads a .png image of the specified CRM Analytics dashboard or lens, or of the specified Lightning report or dashboard. When downloadType has a value of `pdf`, downloads a .pdf file of the specified CRM Analytics dashboard or lens. |

### Syntax

```
domain/analytics/download/assetType/assetId.downloadType
```

> **Note:** To request a download, enter the URI in a browser address bar. We don't support the use of this API from Apex.

Formats: `.png` or `.pdf`

### Parameters

| Parameter | Description |
|---|---|
| `assetType` | Required. Specifies what type of Analytics asset to download. Valid values are: `dashboard`, `lens`, `lightning-dashboard`, `report` |
| `assetId` | Required. Specifies the Analytics asset id to download. |
| `downloadType` | Required. Specifies what file type to download the Analytics asset as. Valid values are: `png`, `pdf` |

> **Note:** For Lightning Experience reports, the request works only with `png` and only if the report has a chart. If you use `pdf` or if the report doesn't have a chart, the request returns an error.

### Query Parameters

| Parameter | Description |
|---|---|
| `includeData` | Optional. Indicates whether to include that tabular widget data (`true`) or not (`false`). |
| `pageId` | Optional. Specifies the Id for a dashboard page to download. |
| `pageSize` | Optional. Specifies page size to download. Valid values are: `A3`, `A4`, `LEGAL`, `LETTER` |
| `savedviewId` | Optional. Specifies the Id for a dashboard saved view to download. |

> **Note:** For Lightning Experience reports, the request works only with `png` and only if the report has a chart. If you use `pdf` or if the report doesn't have a chart, the request returns an error. (원문에서 위 Note가 한 번 더 반복됨)

**Response Body:** binary data of the .png or .pdf representation.

> **Note:** For limits on columns and pages in .pdf files, see Analytics Download Limits.

---

## Analytics Notifications

Use the Analytics Notifications API to work set up [sic] custom analytics notifications. **Available in API version 38.0 and later.** 리소스는 `/services/data/<latest API version>/analytics/notifications` 아래에 위치한다.

### 리소스 매트릭스

| Resource | Method | Description |
|---|---|---|
| Analytics Notification List `/services/data/<latest API version>/analytics/notifications` | `GET` | Returns a list of recent notifications. |
| (동일) | `POST` | Create an analytics notification. |
| Analytics Notification `/services/data/<latest API version>/analytics/notifications/<Id>` | `GET` | Returns information about a specific notification. |
| (동일) | `PUT` | Save changes to the notification as specified in the request body. |
| (동일) | `DELETE` | Delete the notification. Deleted notifications can't be recovered. |
| Analytics Notification Limits `/services/data/<latest API version>/analytics/notifications/limits` | `GET` | Check to see how many more analytics notifications you can create. |

### Analytics Notification List

URI `/services/data/vXX.X/analytics/notifications?source=source` · JSON.

- `GET` — Returns a list of analytics notifications.
- `POST` — Create an analytics notification.

#### Parameters

| Parameter | Description |
|---|---|
| `source` | Required for GET calls. Specifies what type of analytics notification to return. Valid values are: `lightningDashboardSubscribe` — dashboard subscriptions; `lightningReportSubscribe` — report subscriptions; `waveNotification` — Analytics notifications |
| `ownerId` | Optional for GET calls. Allows users with Manage Analytics Notifications permission to get notifications for another user with the specified ownerId. |
| `recordId` | Optional. Return notifications for a single record. Valid values are: `reportId` — Unique report ID; `lensId` — Unique Analytics lens ID |

#### GET and POST Response Body

배열은 notification object의 배열이다 (각 object의 속성 — pdftoppm p.132 검증).

| Property | Type | Description |
|---|---|---|
| `active` | `Boolean` | Indicates whether the notification is being sent (`true`) or not (`false`). |
| `configuration` | `WaveConfiguration[]` | Describes details of a Analytics notification. Only applicable when source is `waveNotification`. |
| `createdDate` | `DateTime` | Date and time when the notification was created (in ISO 8601 format). |
| `deactivateOnTrigger` | `Boolean` | Indicates whether the notification is deactivated after it's sent (`true`) or not (`false`). Deactivation doesn't delete the notification. The default value is `false`. |
| `id` | `String` | Unique notification ID. |
| `lastModifiedDate` | `DateTime` | Date and time when the notification was last modified (in ISO 8601 format). |
| `name` | `String` | Display name of the notification. |
| `recordId` | `String` | Unique ID of the record that the notification describes. Valid values are: `reportId`, `lensId` |
| `runAs` | `runAs` | The person who runs the report in a report subscription. Report recipients see data in the emailed report that this person has access to in Salesforce. Available in API version 40.0 and later. Only appears if you have the "Subscribe to Reports: Add Recipients" user perm. |
| `schedule` | `Schedule` | Details about the notification's schedule. |
| `source` | `String` | Indicates the type of notification. Possible values are: `lightningSubscribe` — report subscriptions; `lightningDashboardSubscribe` — dashboard subscriptions; `lightningReportSubscribe` — report subscriptions; `waveNotification` — Analytics notifications |
| `thresholds` | `Threshold[]` | Specifies what happens when the notification runs. For example, sending an email with report results. |

> **POST Request Body:** Uses the same format as the GET and POST response body.

#### 중첩 표현형 (13종)

**1. `runAs`**

| Property | Type | Description |
|---|---|---|
| `id` | `String` | The person's unique Salesforce user ID. |
| `name` | `String` | The person's first and last name. |

**2. `Schedule`**

| Property | Type | Description |
|---|---|---|
| `frequency` | `String` | `daily` — Every day / `weekly` — One or more days each week / `monthly` — One or more days each month |
| `frequencyType` | `String` | Only necessary when frequency is monthly. `relative` — Days which can change month-to-month / `specific` — Fixed monthly dates |
| `details` | `ScheduleDetail[]` | Describes the notification schedule. Varies depending on whether frequency is daily, weekly, or monthly. |

**3. `ScheduleDetail` (frequency = daily)**

| Property | Type | Description |
|---|---|---|
| `time` | `Integer` | The hour of the day at which the notification is invoked. Possible values are integers from 0 to 23. |

**4. `ScheduleDetail` (frequency = weekly)**

| Property | Type | Description |
|---|---|---|
| `time` | `Integer` | 0 to 23. |
| `daysOfWeek` | `String[]` | `mon` / `tue` / `wed` / `thu` / `fri` / `sat` / `sun` |

**5. `ScheduleDetail` (frequency = monthly, frequencyType = relative)**

| Property | Type | Description |
|---|---|---|
| `time` | `Integer` | 0 to 23. |
| `weekInMonth` | `String` | `first` / `second` / `third` / `fourth` |
| `dayInWeek` | `String` | `mon` / `tue` / `wed` / `thu` / `fri` / `sat` / `sun` / `weekday` / `weekend` |

**6. `ScheduleDetail` (frequency = monthly, frequencyType = specific)**

| Property | Type | Description |
|---|---|---|
| `time` | `Integer` | 0 to 23. |
| `daysOfMonth` | `Integer[]` | 1 to 31, and `-1` = last day of the month. |

**7. `Threshold`**

| Property | Type | Description |
|---|---|---|
| `actions` | `Action[]` | |
| `conditions` | `Condition[]` | |
| `type` | `String` | `always` — Always invoke / `onError` — Invoke when there is an error / `condition` — Invoke based on criteria described by conditions |

**8. `Condition`**

| Property | Type | Description |
|---|---|---|
| `colName` | `String` | |
| `value` | `String` | |
| `operation` | `String` | `equal` / `notEqual` / `greaterThan` / `lessThan` / `greaterThanEqual` / `lessThanEqual` |

**9. `Action`**

| Property | Type | Description |
|---|---|---|
| `type` | `String` | `postToSlack` — Post to a Slack channel / `sendEmail` — Send an email to recipients |
| `configuration` | `Configuration[]` | |

**10. `Configuration`**

| Property | Type | Description |
|---|---|---|
| `attachment` | `String` | only one valid value `excel` — Attach report results to the email as a spreadsheet formatted as a .XLSX file. Do not include record-level details... If the Lightning report subscription does not include an attachment, then the attachment property is not returned. When not returned, HTML-formatted report results are included directly in the subscription email body. |
| `recipients` | `Recipient[]` | |
| `summaryOnly` | `Boolean` | Applies when threshold type is `condition` and `source=LightningReportSubscribe..` [sic 마침표2]. If true, emails the notification summary without the report table. If false or null, emails the summary and report table. |
| `team` | `Team` | |

**11. `Recipient`**

| Property | Type | Description |
|---|---|---|
| `id` | `String` | unique id of a user, role, or group. |
| `displayName` | `String` | |
| `type` | `String` | `collaborationRoom` — A collaboration room. / `user` — A individual user. [sic] |

**12. `Team`**

| Property | Type | Description |
|---|---|---|
| `platformId` | `String` | Specifies the id of the Slack platform. |

**13. `WaveConfiguration`** (+ `WaveDataset`)

| Property | Type | Description |
|---|---|---|
| `anchor` | `String` | Optional |
| `filter` | `String` | Optional |
| `query` | `String` | Required. SAQL query |
| `datasets` | `WaveDataset[]` | Required |

`WaveDataset`:

| Property | Type | Description |
|---|---|---|
| `id` | `String` | Required |
| `name` | `String` | Optional |
| `namespace` | `String` | Optional |

### Analytics Notification (specific)

URI `/services/data/vXX.X/analytics/notifications/<analytics notification ID>` · JSON.

- `GET` — Returns information about a specific notification.
- `PUT` — Save changes as specified in the request body.
- `DELETE` — Delete the analytics notification. Deleted notifications can't be recovered.

Parameters: `source` (Required for GET, same 3 values) · `ownerId` (Optional) · `recordId` (Optional, `reportId` / `lensId`).

- **GET Response Body:** Analytics Notification List의 `GET and POST Response Body`(12속성)와 13개 중첩 표현형이 셀 단위로 동일하다 → **위 [Analytics Notification List](#analytics-notification-list) 섹션 참조.**
- **PUT Request Body:** A notification object with desired changes. Uses the same format as the GET response body.
- **PUT Response Body:** An analytics notification object reflecting saved changes. Same format.
- **DELETE Response Body:** empty response body.

### Analytics Notification Limits

URI `/services/data/vXX.X/analytics/notifications/limits?source=source` · JSON.

- `GET` — Check how many analytic notifications you have, and the maximum number you can have.

Parameters: `source` (Required for GET, 3 values) · `recordId` (Optional, `reportId` / `lensId`).

#### GET Response Body

| Property | Type | Description |
|---|---|---|
| `max` | `Integer` | How many analytics notifications of the type specified by source the user is allowed to create. |
| `remaining` | `Integer` | How many more analytics notifications of the type specified by source the user can create before hitting the limit. |

---

## Filter Operators

Use the Filter Operators API to get information about which filter operators are available for reports and dashboards. **Available in API version 40.0 and later.** 리소스는 `/services/data/<latest API version>/analytics/filteroperators` 아래에 위치한다.

### Resource

| Resource | Method | Description |
|---|---|---|
| `/services/data/<latest API version>/analytics/filteroperators` **and** `?forDashboards=true` | `GET` | Returns a list of filter operators available for report filters. When `forDashboards` is `true`, returns a list of filter operators available for dashboard filters. |

### Filter Operator List

URI `/services/data/vXX.X/analytics/filteroperators` · JSON.

- `GET` — Returns a list of filter operators.

Parameters: `forDashboards` — Optional. When `forDashboards` equals `true`, returns filter operators for dashboard filters. Otherwise, the GET response always returns filter operators for report filters.

#### GET Response Body

응답은 field data type의 배열이며, 각 object는 다음 속성을 가진다 (pdftoppm p.175 검증).

| Property | Type | Description |
|---|---|---|
| `label` | `String` | The end user-facing name of the operator. |
| `name` | `String` | The API name of the operator. |

#### 데이터 타입별 사용 가능 operator (16 타입)

응답 JSON은 아래 16개 타입을 전부 축약 없이 나열한다. `label` ≠ `name`인 경우(예: "less or equal" → `lessOrEqual`)에 주의한다.

| 데이터 타입 | operator (label → name) |
|---|---|
| `date` | equals→`equals` · not equal to→`notEqual` · less than→`lessThan` · greater than→`greaterThan` · less or equal→`lessOrEqual` · greater or equal→`greaterOrEqual` |
| `string` | (date 6개) + contains→`contains` · does not contain→`notContain` · starts with→`startsWith` |
| `double` | (date 6개) |
| `picklist` | (string 9개) |
| `textarea` | (string 9개) |
| `percent` | (date 6개) |
| `url` | (string 9개) |
| `int` | (date 6개) |
| `reference` | equals→`equals` · not equal to→`notEqual` (2개만) |
| `datetime` | (date 6개) |
| `boolean` | equals→`equals` · not equal to→`notEqual` (2개만) |
| `phone` | (string 9개) |
| `currency` | (date 6개) |
| `id` | equals→`equals` · not equal to→`notEqual` · starts with→`startsWith` (3개) |
| `email` | (string 9개) |
| `multipicklist` | equals→`equals` · not equal to→`notEqual` · includes→`includes` · excludes→`excludes` (4개; `includes`·`excludes`는 이 타입에만 존재) |

> operator `name` unique 12종: `equals` · `notEqual` · `lessThan` · `greaterThan` · `lessOrEqual` · `greaterOrEqual` · `contains` · `notContain` · `startsWith` · `includes` · `excludes`.

#### Example GET Reponse Body

> [sic] 원문 헤딩은 `Example GET Reponse Body` ("Response"의 오타 "Reponse")로, p.175 verbatim 그대로 유지한다.

축약(`[ ... ]`)으로 표시된 타입(`double`/`picklist`/`textarea`/`percent`/`url`/`int`/`datetime`/`phone`/`currency`/`email`)은 위 표대로 채운다. 원문 JSON은 16타입 전부를 나열한다.

```json
{
  "date" : [ { "label":"equals", "name":"equals" }, { "label":"not equal to", "name":"notEqual" }, { "label":"less than", "name":"lessThan" }, { "label":"greater than", "name":"greaterThan" }, { "label":"less or equal", "name":"lessOrEqual" }, { "label":"greater or equal", "name":"greaterOrEqual" } ],
  "string" : [ { "label":"equals", "name":"equals" }, { "label":"not equal to", "name":"notEqual" }, { "label":"less than", "name":"lessThan" }, { "label":"greater than", "name":"greaterThan" }, { "label":"less or equal", "name":"lessOrEqual" }, { "label":"greater or equal", "name":"greaterOrEqual" }, { "label":"contains", "name":"contains" }, { "label":"does not contain", "name":"notContain" }, { "label":"starts with", "name":"startsWith" } ],
  "double" : [ ... ], "picklist" : [ ... ], "textarea" : [ ... ], "percent" : [ ... ], "url" : [ ... ], "int" : [ ... ],
  "reference" : [ { "label":"equals", "name":"equals" }, { "label":"not equal to", "name":"notEqual" } ],
  "datetime" : [ ... ],
  "boolean" : [ { "label":"equals", "name":"equals" }, { "label":"not equal to", "name":"notEqual" } ],
  "phone" : [ ... ], "currency" : [ ... ],
  "id" : [ { "label":"equals", "name":"equals" }, { "label":"not equal to", "name":"notEqual" }, { "label":"starts with", "name":"startsWith" } ],
  "email" : [ ... ],
  "multipicklist" : [ { "label":"equals", "name":"equals" }, { "label":"not equal to", "name":"notEqual" }, { "label":"includes", "name":"includes" }, { "label":"excludes", "name":"excludes" } ]
}
```

---

## 관련 노트

- [[Reports and Dashboards REST API — Dashboards·Downloads·Notifications 예제]] — Downloads·Notifications 호출 예제(이 노트는 표현형, 저 노트는 예제)
- [[Reports and Dashboards REST API — 개요·Reports 예제]] — REST API 진입점·인증·Reports 예제
- [[Reports and Dashboards REST API — Report Fields·Error Codes 표현형]] — 공통 Report Fields·에러 코드
- [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] — reportMetadata 표현형(필터 연산자가 쓰이는 reportFilters)
