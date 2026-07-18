---
tags: [Analytics, CRMAnalytics, REST, Wave, SAQL, SQL, Query]
source: developer.salesforce.com/docs/atlas.en-us.bi_dev_guide_rest.meta/bi_dev_guide_rest/ — CRM Analytics REST API Developer Guide v67.0 Summer '26, 2026-07-18 접속, Tier 2
created: 2026-07-18
aliases: [wave query REST, SAQL query REST, /wave/query, SaqlQueryInput, SAQL 쿼리 실행]
---

# CRM Analytics REST API — Query 실행 (SAQL·SQL)

> `POST /wave/query`로 CRM Analytics(Wave) 데이터셋에 SAQL 또는 SQL 쿼리를 직접 실행한다. 요청은 `SaqlQueryInput` 표현형, 응답은 metadata + records를 담은 Literal JSON이다. Apex `Wave` 빌더 경로와 달리 쿼리 문자열을 REST로 직접 던진다.

---

## 1. Query Resource

Executes a query written in Salesforce Analytics Query Language (SAQL) or SQL for CRM Analytics.

| 항목 | 값 |
| --- | --- |
| Resource URL | `/wave/query` |
| Formats | JSON |
| Available Version | 36.0 |
| HTTP Methods | **POST** |
| Request body (POST) | `SaqlQueryInput` |
| Response body (POST) | Literal JSON |

**Available Components:** Apex — `Wave.executeQuery()` · Aura — `<wave:sdk> executeQuery()` · LWC — `lightning/analyticsWaveApi executeQuery()`.

> LWC `lightning/analyticsWaveApi` 모듈의 `executeQuery` 함수를 쓰면 REST를 직접 프록시하지 않고 이 기능을 Salesforce 안으로 가져올 수 있다.

---

## 2. SaqlQueryInput (요청 표현형 — property 전수)

An Analytics query written in SAQL or SQL.

| Property | Type | 설명 | 필수 | Ver |
| --- | --- | --- | --- | --- |
| licenseAttributes | LicensesAttributesInput | Analytics 라이선스 타입 및 기타 속성 | Optional | 53.0 |
| name | String | 쿼리 이름 | Optional | 41.0 |
| query | String | 쿼리 문자열 | **Required** | 40.0 |
| queryLanguage | AnalyticsQueryLanguageEnum | 쿼리가 작성된 언어. 기본값은 SAQL. 유효값: `SAQL` · `SQL` | **Required if the query is SQL.** | 48.0 |
| timezone | String | 쿼리의 timezone. org에서 쿼리용 timezone이 활성화돼 있어야 함 | Optional | 43.0 |

> **주의(Pattern B — 강조어 정확도):** `query`만 무조건 Required이고, `queryLanguage`는 **"쿼리가 SQL일 때만 Required"**(SAQL이면 기본값이라 생략 가능)다. `queryLanguage : SQL`을 빠뜨리면 요청은 syntax error를 반환한다.

---

## 3. Query (응답/compact 표현형 — property 전수)

A query written in SAQL or compact form.

| Property | Type | 설명 | Filter Group, Ver | Ver |
| --- | --- | --- | --- | --- |
| aggregateFilters | Object | 쿼리 aggregate filter | Small, 48.0 | 48.0 |
| columnGroups | Object | 쿼리 column group | Small, 56.0 | 56.0 |
| columnTotals | Object | 쿼리 column total | Small, 56.0 | 56.0 |
| limit | Object | 쿼리 limit | Small, 48.0 | 48.0 |
| orders | Object | 쿼리 order | Small, 48.0 | 48.0 |
| query | String | SAQL 쿼리 텍스트 | Small, 36.0 | 36.0 |
| rowTotals | Object | 쿼리 row total | Small, 56.0 | 56.0 |
| sourceFilters | CompactFormFilter | 쿼리 source filter | Small, 48.0 | 48.0 |
| sources | CompactFormSource | 쿼리 source | Small, 48.9 | 48.0 |
| version | Double | 이 쿼리의 버전 | Small, 36.0 | 36.0 |

---

## 4. SAQL 모드 — 요청·응답 예제

SAQL 쿼리를 REST API로 실행할 때는 **데이터셋 ID와 데이터셋 버전 ID를 둘 다** 지정해야 한다. 쿼리에서 데이터셋 이름을 쓰면 오류가 반환된다. 요청에서 필수 속성은 `query`뿐이다.

```json
// SAQL Query Request (소스 예제 그대로 — bi_rest_api_query_data)
{
    "query" : "q = load \"<datasetId>/<datasetVersionId>\"; q = group q by 'Status'; q = foreach q generate 'Status' as 'Status', count() as 'count'; q = limit q 20;",
    "queryLanguage" : "SAQL"
}
```

응답 results는 metadata와 records를 포함한다. 원본 쿼리와 응답 시간(`responseTime`)도 반환하며, warning이나 error가 있으면 `warnings`가 포함된다.

```json
// SAQL Query Response (소스 예제 그대로)
{
  "action" : "query",
  "responseId" : "4l-kl6BTnH4ay9-qbx2Re-",
  "results" : {
    "metadata" : [ {
      "lineage" : {
        "type" : "foreach",
        "projections" : [ {
          "field" : { "id" : "q.Status", "type" : "string" },
          "inputs" : [ { "id" : "q.Status" } ]
        }, {
          "field" : { "id" : "q.count", "type" : "numeric" }
        } ],
        "input" : {
          "type" : "group",
          "groups" : [ { "id" : "q.Status" } ]
        }
      },
      "queryLanguage" : "SAQL"
    } ],
    "records" : [ {
      "Status" : "Closed",
      "count" : 7
    }, {
      "Status" : "Open",
      "count" : 6
    } ]
  },
  "query" : "q = load \"<datasetId>/<datasetVersionId>\"; q = group q by 'Status'; q = foreach q generate 'Status' as 'Status', count() as 'count'; q = limit q 20;",
  "responseTime" : 3,
  "warnings" : [
    { "code" : "001", "message" : "Limit exceeded" },
    { "code" : "002", "message" : "Another warning..." }
  ]
}
```

---

## 5. SQL 모드 — 요청·응답 예제

쿼리 실행의 기본 언어는 SAQL이다. SQL을 쓰려면 요청에 `"queryLanguage" : "SQL"` 속성을 포함한다. **SQL 쿼리에서는 데이터셋 이름을 사용할 수 있다**(SAQL과 달리 ID/버전 ID 불필요).

```json
// SQL Request Body (소스 예제 그대로 — 같은 쿼리를 SQL로)
{
  "query" : "SELECT Status, COUNT(*) as StatusCount FROM \"<name>\" GROUP BY Status LIMIT 20;",
  "queryLanguage": "SQL"
}
```

> **Note:** `"queryLanguage" : "SQL"`을 지정하지 않으면 요청은 syntax error를 반환한다.

응답 records는 SAQL 응답과 동일해 보이지만 **metadata가 다르다.** `columns` 키가 쿼리 projection의 name과 type을 담는다.

```json
// SQL Query Response (소스 예제 그대로)
{
  "action" : "query",
  "responseId" : "4l-mtW26NZ4OYu-qbx3GN-",
  "results" : {
    "metadata" : [
      {
        "columns" : [
          { "columnLabel" : "Status", "columnType" : "varchar" },
          { "columnLabel" : "StatusCount", "columnType" : "numeric" }
        ],
        "queryLanguage" : "SQL"
      }
    ],
    "records" : [
      { "Status" : "Closed", "StatusCount" : 7 },
      { "Status" : "Open", "StatusCount" : 6 }
    ]
  },
  "query" : "SELECT Status, COUNT(*) as StatusCount FROM \"Cases1\" GROUP BY Status LIMIT 20;",
  "responseTime" : 9
}
```

### SQL metadata — Group By + 집계

`avg(Sales) as AvgSales`처럼 집계를 projection하면 수치 데이터를 반환하고, metadata의 대응 column type은 `numeric`으로 반환된다.

```json
// SQL Metadata (소스 예제 그대로)
"metadata": [
  "columns": [
    { "columnLabel": "City", "columnType": "varchar" },
    { "columnLabel": "AvgSales", "columnType": "numeric" }
  ],
  "queryLanguage": "SQL"
]
```

### SQL — 날짜 파트 추출 (EXTRACT) + timezone

CloseDate 필드에서 year·month·day를 수치로 반환. 요청에 `timezone` 속성을 사용했는데, 이 속성은 **선택이며 org에 timezone이 활성화된 경우에만** 쓸 수 있다.

```json
// SQL EXTRACT + timezone (소스 예제 — 추출 따옴표 정규화)
{
  "query" : "SELECT EXTRACT(YEAR FROM CloseDate) as year, EXTRACT(MONTH FROM CloseDate) as month, EXTRACT(DAY FROM CloseDate) as day From \"OpportunityFiscalEM\"",
  "queryLanguage" : "SQL",
  "timezone" : "America/Los_Angeles"
}
```

```json
// 응답 metadata (소스 예제 그대로)
"metadata": [
  "columns": [
    { "columnLabel": "year", "columnType": "numeric" },
    { "columnLabel": "month", "columnType": "numeric" },
    { "columnLabel": "day", "columnType": "numeric" }
  ],
  "timezone": "America/Los_Angeles",
  "queryLanguage": "SQL"
]
```

### SQL — DateTime 타입 필드 projection

date 정보를 timestamp로 반환한다.

```json
// SQL DateTime projection (소스 예제 — 추출 따옴표 정규화)
{
  "query" :  "SELECT CloseDate From \"OpportunityFiscalEM\"",
  "queryLanguage" : "SQL"
}
```

```json
// 응답 metadata (소스 예제 그대로)
"metadata": [
  "columns": [
    { "columnLabel": "CloseDate", "columnType": "timestamp" }
  ],
  "queryLanguage": "SQL"
]
```

---

## 6. Query Metadata 구조 (columns·groups)

클라이언트가 쿼리를 파싱해 dimension·group을 알아낼 수 있으나 비용이 크다. 그래서 대부분의 경우 쿼리 응답에 grouping·column 정보를 제공하는 metadata 섹션이 포함된다. metadata 섹션은 응답 payload의 `results` 키 안에 있으며 `columns`·`groups` 키로 구성된다.

```json
// metadata 구조 (소스 예제 그대로)
"metadata":{
  "columns" : [
    { "name" : "dim name", "type" : "String" }
  ],
  "groups" : [ "name", "destination" ]
}
```

- `columns` 키 — 쿼리 projection의 name과 type을 포함. **column name 값은 projection에 부여된 alias이며 dimension의 이름이 아니다.**
- `groups` 키 — 쿼리에 사용된 group 목록. 단, 쿼리가 complex하지 않을 때만(group 이름이 여러 stream에서 쓰여 nondeterministic한 경우 — `cogroup`·`union` 사용 시 — `groups` 키는 비어 있음).
- metadata는 쿼리가 성공했을 때만 추가된다. 쿼리 실패·syntax error·authorization callback 실패 시 metadata는 results에 추가되지 않는다.

---

## 7. REST 직접 호출 vs Apex Wave 빌더

동일한 SAQL/SQL 쿼리를 두 경로로 실행할 수 있다. 선택 기준:

| 경로 | 방식 | 언제 |
| --- | --- | --- |
| REST `POST /wave/query` | JSON body(`SaqlQueryInput`)에 쿼리 문자열을 직접 전달 | 외부 앱·서버-투-서버 통합, 언어 무관 HTTP 클라이언트 |
| Apex `Wave` 네임스페이스 | Apex에서 SAQL 빌더 API로 쿼리 구성·실행(`Wave.executeQuery()` 등) | Apex 트랜잭션 안에서 타입-세이프하게 쿼리 조립·실행 → [[Wave Namespace]] 참조 |
| LWC `lightning/analyticsWaveApi` | `executeQuery()` wire/imperative | LWC에서 REST 프록시 없이 직접 |

> Apex 빌더의 클래스·메서드 상세는 [[Wave Namespace]]가 소관이다 — 여기서는 REST 경로만 다룬다.

---

## 관련 노트

- [[CRM Analytics REST API — 개요·인증·asset 엔드포인트 지도]] — 이 스포크의 지도 노트(asset 리소스 맵·인증·경계)
- [[CRM Analytics REST API — Datasets·Versions·XMD 표현형]] — 쿼리 대상 데이터셋·버전·XMD 표현형
- [[Wave Namespace]] — Apex `Wave` 네임스페이스(SAQL 빌더). REST 직접 호출과 대비되는 Apex 경로
- [[Analytics 개요 — 표준 리포팅 vs CRM Analytics·API 선택 가이드]]
