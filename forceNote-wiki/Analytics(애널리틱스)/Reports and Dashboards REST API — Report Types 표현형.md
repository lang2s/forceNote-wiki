---
tags: [analytics, reports, rest-api, reports-dashboards-rest, report-types, hide-report-type]
source: salesforce_analytics_rest_api.pdf (Reports and Dashboards REST API Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Report Type List, Report Types REST, Recently Used Report Types, Hide Report Type, reportTypeMetadata, recent-reports]
---

# Reports and Dashboards REST API — Report Types 표현형

> Report Types 리소스 5종(Report Type List · Report Type · Recently Used · Recently Created · Hide/Unhide)의 URI·메서드·응답 표현형 — Report Type GET이 반환하는 3개 metadata 컨테이너의 상세는 Describe 노트로 위임한다.

---

## 개요

org에서 사용 가능한 report type 정보를 조회한다. **API version 39.0 이상**에서 사용 가능하다.

베이스 URI는 `/services/data/<latest API version>/analytics/report-types` 다.

> **Note:** report type 리소스를 참조할 때 `report-types` 또는 `reportTypes` 어느 쪽 표기든 사용할 수 있다 — 두 표현은 동등(equivalent)하다.

### 리소스 목록

| Resource | URI | Method | Description |
|---|---|---|---|
| Report Type List | `/services/data/<latest API version>/analytics/report-types` | GET | Returns a list of available report types. |
| Report Type | `/services/data/<latest API version>/analytics/report-types/<type>` | GET | Returns metadata about a specified report type. |
| Recently Created Reports | `/services/data/<latest API version>/analytics/report-types/<report-type-API-name>/recent-reports` | GET | Returns a list of recently created reports for a specific report type. |
| Recently Used Report Types | `/services/data/<latest API version>/analytics/report-types/recent/by-user` | GET | Returns a list of report types used by reports recently created by the current user. |
| Hide and Unhide Report Types | `/services/data/<latest API version>/analytics/reports/show-hide-report_type` | PATCH | Sets the `hidden` parameter to `true` or `false` for a specific report type. |

---

## Report Type List

org에서 사용 가능한 report type 목록을 반환한다.

- **URI** — `/services/data/vXX.X/analytics/report-types`
- **Formats** — JSON
- **HTTP method** — `GET`

### GET 응답 본문

report type 폴더 객체의 배열을 반환한다.

| Property | Type | Description |
|---|---|---|
| `label` | `String` | The end user-facing name of the report type folder. |
| `report-types` | `report-types[]` | An array of report types. |

#### `report-types[]`

| Property | Type | Description |
|---|---|---|
| `describeUrl` | `String` | A URL link to the report type's metadata. |
| `description` | `String` | Optional. A description of the report type. |
| `isHidden` | `Boolean` | Indicates whether an administrator has hidden the report type (`true`) or not (`false`). Hidden report types don't appear in the report builder when creating a report. |
| `isHistorical` | `Boolean` | Optional. `true` for historical tracking report types. If this property is missing, the value is assumed to be `false`. |
| `label` | `String` | The end user-facing name of the report type in the report builder. |
| `supportsJoinedFormat` | `Boolean` | Specifies whether a report type is compatible with joined reports (`true`) or not (`false`). |
| `type` | `String` | The API name of the report type. |

---

## Report Type

지정한 report type의 metadata를 반환한다.

- **URI** — `/services/data/vXX.X/analytics/reportTypes/type`
- **Formats** — JSON
- **HTTP method** — `GET`

### GET 요청 본문 — 3개 metadata 컨테이너

Report Type GET은 아래 3개의 metadata 컨테이너를 반환한다. 각 컨테이너의 표현형 본체(`reportMetadata`의 속성·중첩, `reportTypeMetadata`의 Categories·Column map 등, `reportExtendedMetadata`의 요약·그룹핑 정보)는 **Describe 노트가 이미 전수 정본화**했으므로 본 노트에서는 복제하지 않는다 — 상세는 [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] 참조.

| Property | Type | Description |
|---|---|---|
| `reportMetadata` | Report metadata | Unique identifiers for groupings and summaries. → [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] |
| `reportTypeMetadata` | Report type metadata | Fields in each section of a report type plus filter information for those fields. → [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] |
| `reportExtendedMetadata` | Report extended metadata | Additional information about summaries and groupings. → [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] |

> 원문 [sic]: GET 요청 본문 설명에 "A notification object with desired changes." 표현이 등장한다(notification 표현 그대로 보존). 또한 가이드의 시각 스크린샷 2건(p280·p281, "Where will this formula be displayed?")은 본 노트에서 재현하지 않는다.

---

## Recently Used Report Types

현재 사용자가 가장 최근에 생성한 50개 report에서 사용된 report type 목록을 반환한다.

- **URI** — `/services/data/<latest API version>/analytics/report-types/recent/by-user`
- **Formats** — JSON
- **HTTP method** — `GET`

### GET 응답 본문

| Property | Description |
|---|---|
| `describeUrl` | A URL link to the report type's metadata. |
| `isCustomReportType` | Indicates whether a report type is custom (`true`) or not (`false`). |
| `isHidden` | Indicates whether an administrator has hidden the report type (`true`) or not (`false`). Hidden report types don't appear in the report builder when creating a report. |
| `isHistorical` | Indicates whether it's a historical tracking report type (`true`) or not (`false`). |
| `label` | The display name of the report type. |
| `lastUsedDate` | Timestamp when the report type was last used. |
| `supportsJoinedFormat` | Indicates whether a report type is compatible with joined reports (`true`) or not (`false`). |
| `type` | The API name of the report type. |

---

## Recently Created Reports

특정 report type에 대해 현재 사용자 또는 다른 사용자가 최근에 생성한 report 목록을 반환한다.

- **URI** — `/services/data/<latest API version>/analytics/report-types/<report-type-API-name>/recent-reports`
- **Formats** — JSON
- **HTTP method** — `GET`

### 파라미터

| Parameter | Type | Description |
|---|---|---|
| `pageSize` | `Integer` | Required for GET calls. Specifies number of recently created reports to return. |
| `isCurrentUser` | `Boolean` | Optional for GET calls. Specifies if results are limited to current user (`true`) or all other users (`false`). Default value is `false`. |
| `offset` | `Integer` | Optional for GET calls. Specifies offset of returned report list. Default value is `0`. |

### GET 응답 본문

| Property | Description |
|---|---|
| `createdByUser` | Name of user who created report. |
| `createdDate` | Timestamp of report creation. |
| `id` | Id of report. |
| `name` | Name of report. |

### 예제 요청

```
analytics/report-types/AccountList/recent-reports?pageSize=3&isCurrentUser=true&offset=3
```

### 예제 응답

```json
[
  {
    "createdByUser": "Admin User",
    "createdDate": "2021-11-03T17:31:53.000+0000",
    "id": "00Oxx0000011ghvEAA",
    "name": "New Accounts Report1"
  },
  {
    "createdByUser": "Admin User",
    "createdDate": "2021-10-19T17:20:44.000+0000",
    "id": "00Oxx0000011gLVEAY",
    "name": "Sample Report: # of Accounts"
  }
]
```

---

## Hide and Unhide Report Types

report type의 hidden 상태를 갱신한다(PATCH). 특정 report type에 대해 `hidden` 파라미터를 `true` 또는 `false`로 설정한다.

- **URI** — `/services/data/<latest API version>/analytics/reports/show-hide-report_type`
- **Formats** — JSON
- **HTTP method** — `PATCH`

### 파라미터

| Parameter | Description |
|---|---|
| `templateId` | Required for PATCH calls. Specifies report type API name. |
| `hidden` | Required for PATCH calls. Specifies if report type is hidden (`true`) or not (`false`). |

### 예제 요청 본문 — Hide

```json
{ "templateId" : <Report Type API Name>, "hidden" : "true" }
```

### 예제 요청 본문 — Show

```json
{ "templateId" : <Report Type API Name>, "hidden" : "false" }
```

---

## 관련 노트

- [[Reports and Dashboards REST API — Describe(reportMetadata) 표현형]] — Report Type GET이 반환하는 reportMetadata·reportTypeMetadata·reportExtendedMetadata 3컨테이너 및 모든 중첩 표현형 정본
- [[Reports and Dashboards REST API — 개요·Reports 예제]]
- [[Reports and Dashboards REST API — Report 표현형]]
- [[Reports and Dashboards REST API — Dashboards·Downloads·Notifications 예제]]
