---
tags: [apex, datasource, namespace, salesforce-connect, external-objects, custom-adapter, external-data-source]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [DataSource Namespace, DataSource.Connection, DataSource.Provider, Salesforce Connect, External Objects, 커스텀 어댑터, 외부 오브젝트]
---

# DataSource Namespace

> Apex Connector Framework — `DataSource.Provider`와 `DataSource.Connection`을 구현하여 Salesforce Connect용 커스텀 어댑터를 만들고, 외부 시스템의 데이터를 External Object로 연결한다.

---

## 아키텍처 개요

```
┌─────────────────────────────────────────┐
│           DataSource.Provider           │  ← 기능/인증 capability 선언
│  getCapabilities() / getAuthCapabilities()│
│  getConnection(params)                  │  ← Connection 인스턴스 반환
└─────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│          DataSource.Connection          │  ← 실제 데이터 처리
│  sync()          → Table 목록 반환      │  ← 스키마 동기화
│  query(ctx)      → TableResult          │  ← SOQL 처리
│  search(ctx)     → List<TableResult>    │  ← SOSL 처리
│  upsertRows(ctx) → List<UpsertResult>   │  ← 생성/수정
│  deleteRows(ctx) → List<DeleteResult>   │  ← 삭제
└─────────────────────────────────────────┘
```

---

## DataSource.Provider 구현

```apex
global class MyProvider extends DataSource.Provider {

    // 인증 방식 선언
    override global List<DataSource.AuthenticationCapability> getAuthenticationCapabilities() {
        return new List<DataSource.AuthenticationCapability>{
            DataSource.AuthenticationCapability.ANONYMOUS,
            DataSource.AuthenticationCapability.OAUTH
        };
    }

    // 기능 선언
    override global List<DataSource.Capability> getCapabilities() {
        return new List<DataSource.Capability>{
            DataSource.Capability.ROW_QUERY,    // SOQL 지원
            DataSource.Capability.SEARCH,        // SOSL 지원
            DataSource.Capability.ROW_CREATE,
            DataSource.Capability.ROW_UPDATE,
            DataSource.Capability.ROW_DELETE
        };
    }

    // Connection 인스턴스 반환
    override global DataSource.Connection getConnection(
            DataSource.ConnectionParams params) {
        return new MyConnection(params);
    }
}
```

### Capability Enum 주요 값

| 값 | 설명 |
|---|---|
| `ROW_QUERY` | SOQL 쿼리 지원 |
| `SEARCH` | SOSL / 전역 검색 지원 |
| `ROW_CREATE` | 외부 레코드 생성 |
| `ROW_UPDATE` | 외부 레코드 수정 |
| `ROW_DELETE` | 외부 레코드 삭제 |

### AuthenticationCapability Enum

| 값 | 설명 |
|---|---|
| `ANONYMOUS` | 인증 불필요 (Named Credential 사용 시 권장) |
| `OAUTH` | OAuth 인증 |
| `PASSWORD` | 사용자명/비밀번호 |
| `CERTIFICATE` | 인증서 기반 |

---

## DataSource.Connection 구현

```apex
global class MyConnection extends DataSource.Connection {

    global MyConnection(DataSource.ConnectionParams params) { }

    // 스키마 동기화 — Validate and Sync 버튼 클릭 시 호출
    override global List<DataSource.Table> sync() {
        List<DataSource.Column> columns = new List<DataSource.Column>{
            DataSource.Column.text('Name', 255),
            DataSource.Column.text('ExternalId', 255),  // 필수 — External ID 컬럼
            DataSource.Column.url('DisplayUrl')          // 필수 — 레코드 링크
        };
        return new List<DataSource.Table>{
            DataSource.Table.get('Products', 'Name', columns)
        };
    }

    // SOQL 처리
    override global DataSource.TableResult query(DataSource.QueryContext ctx) {
        List<Map<String, Object>> rows = fetchRowsFromExternalSystem();
        // QueryUtils.process: 필터/정렬/LIMIT-OFFSET 로컬 처리 (개발·테스트용)
        return DataSource.TableResult.get(ctx, DataSource.QueryUtils.process(ctx, rows));
    }

    // SOSL / 전역 검색 처리
    override global List<DataSource.TableResult> search(DataSource.SearchContext ctx) {
        List<DataSource.TableResult> results = new List<DataSource.TableResult>();
        for (DataSource.TableSelection ts : ctx.tableSelections) {
            results.add(DataSource.TableResult.get(ts, fetchRowsFromExternalSystem()));
        }
        return results;
    }

    // Upsert (생성/수정)
    override global List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext ctx) {
        List<DataSource.UpsertResult> results = new List<DataSource.UpsertResult>();
        for (Map<String, Object> row : ctx.rows) {
            String extId = (String) row.get('ExternalId');
            try {
                String id = saveToExternalSystem(row, extId == null);
                results.add(DataSource.UpsertResult.success(id));
            } catch (Exception e) {
                results.add(DataSource.UpsertResult.failure(extId, e.getMessage()));
            }
        }
        return results;
    }

    // 삭제
    override global List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext ctx) {
        List<DataSource.DeleteResult> results = new List<DataSource.DeleteResult>();
        for (String extId : ctx.externalIds) {
            try {
                deleteFromExternalSystem(extId);
                results.add(DataSource.DeleteResult.success(extId));
            } catch (Exception e) {
                results.add(DataSource.DeleteResult.failure(extId, e.getMessage()));
            }
        }
        return results;
    }

    private List<Map<String, Object>> fetchRowsFromExternalSystem() {
        // HTTP callout → JSON parse → rows
        return new List<Map<String, Object>>();
    }
    private String saveToExternalSystem(Map<String, Object> row, Boolean isInsert) { return null; }
    private void deleteFromExternalSystem(String id) { }
}
```

---

## Context 클래스 주요 속성

| 클래스 | 핵심 속성 |
|---|---|
| `QueryContext` | `tableSelection` (TableSelection), SOQL WHERE/ORDER/LIMIT/OFFSET 분해됨 |
| `SearchContext` | `tableSelections` (List\<TableSelection\>) |
| `UpsertContext` | `tableSelected` (String), `rows` (List\<Map\<String,Object\>\>) |
| `DeleteContext` | `tableSelected` (String), `externalIds` (List\<String\>) |

## Result 클래스 생성 패턴

```apex
// UpsertResult
DataSource.UpsertResult.success(externalId)
DataSource.UpsertResult.failure(externalId, errorMessage)

// DeleteResult
DataSource.DeleteResult.success(externalId)
DataSource.DeleteResult.failure(externalId, errorMessage)

// TableResult
DataSource.TableResult.get(queryContext, rows)
DataSource.TableResult.get(tableSelection, rows)
```

---

## 비동기 콜백 — AsyncDeleteCallback / AsyncSaveCallback

외부 시스템이 비동기 처리를 할 때 `Database.deleteAsync()` / `Database.insertAsync()` / `Database.updateAsync()`와 함께 사용한다.

```apex
global class MyDeleteCallback extends DataSource.AsyncDeleteCallback {
    global override void processDelete(Database.DeleteResult result) {
        if (result.isSuccess()) {
            // 보정 트랜잭션 — 예: 로컬 레코드 상태 업데이트
        }
    }
}

global class MySaveCallback extends DataSource.AsyncSaveCallback {
    global override void processSave(Database.SaveResult result) {
        if (!result.isSuccess()) {
            // 실패 처리
        }
    }
}
```

---

## 필수 컬럼 규칙

| 컬럼 | 이유 |
|---|---|
| `ExternalId` (text) | Salesforce가 레코드를 외부 시스템과 매핑하는 키 |
| `DisplayUrl` (url) | 레코드 상세 페이지의 외부 링크 |

---

## DataSource.Column — 컬럼 정의

`sync()` 메서드에서 External Object의 각 필드를 정의하는 클래스. 팩토리 메서드로 생성.

```apex
// 자주 쓰는 팩토리 메서드
DataSource.Column.text('Name', 255)           // 짧은 텍스트 (255자 이하)
DataSource.Column.text('Description', 4000)   // 긴 텍스트 (255 초과 시 LONG_TEXT)
DataSource.Column.text('ExternalId')          // 기본 255자 텍스트
DataSource.Column.url('DisplayUrl')           // URL (기본 1000자)
DataSource.Column.url('ProfileLink', 500)     // URL (길이 지정)
DataSource.Column.date('CreatedDate')
DataSource.Column.datetime('LastModifiedDate')
DataSource.Column.boolean('IsActive')
DataSource.Column.integer('Count', 10)
DataSource.Column.number('Score', 10, 2)      // 전체 자릿수, 소수점
DataSource.Column.currency('Amount', 18, 2)
DataSource.Column.percent('Rate', 10, 2)
DataSource.Column.phone('Phone')
DataSource.Column.email('Email')
DataSource.Column.textarea('Body')            // LONG_TEXT (32,000자)
DataSource.Column.lookup('AccountId', 'Account')  // 조회 관계
DataSource.Column.externalLookup('OrgId', 'ExternalOrg')
DataSource.Column.indirectLookup('ExtId', 'Account', 'External_Id__c')

// 피클리스트
List<Map<String,String>> vals = new List<Map<String,String>>{
    new Map<String,String>{'label'=>'Active', 'value'=>'1'},
    new Map<String,String>{'label'=>'Inactive', 'value'=>'0'}
};
DataSource.Column.picklist('Status', vals, false)     // restricted=false
DataSource.Column.multipicklist('Tags', vals, false)

// 전체 제어 — get() 팩토리
DataSource.Column col = DataSource.Column.get(
    'Name',                            // name
    'Product Name',                    // label
    'The product display name',        // description
    true,                              // filterable
    true,                              // sortable
    DataSource.DataType.STRING_SHORT_TYPE, // type
    255,                               // length
    0                                  // decimalPlaces
);
```

### Column 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `name` | `String` | API 이름 |
| `label` | `String` | 표시 레이블 |
| `description` | `String` | 설명 (선택) |
| `type` | `DataSource.DataType` | 데이터 타입 |
| `length` | `Integer` | 최대 길이 |
| `decimalPlaces` | `Integer` | 소수점 자리수 |
| `filterable` | `Boolean` | WHERE 절 필터 가능 여부 |
| `sortable` | `Boolean` | ORDER BY 가능 여부 |
| `referenceTo` | `String` | 조회 대상 오브젝트 이름 |
| `referenceTargetField` | `String` | 간접 조회 대상 필드 |
| `picklistValues` | `List<Map<String,String>>` | 피클리스트 값 목록 |
| `isPicklistRestricted` | `Boolean` | 피클리스트 값 제한 여부 |
| `isPicklistAlphabeticallySorted` | `Boolean` | 피클리스트 알파벳 정렬 여부 |

---

## DataSource.DataType Enum

| 값 | 설명 |
|---|---|
| `BOOLEAN_TYPE` | Boolean |
| `CURRENCY_TYPE` | 통화 |
| `DATE_TYPE` | 날짜 |
| `DATETIME_TYPE` | 날짜/시간 |
| `EMAIL_TYPE` | 이메일 |
| `EXTERNAL_LOOKUP_TYPE` | External Object 조회 |
| `INDIRECT_LOOKUP_TYPE` | 간접 조회 |
| `INTEGER_TYPE` | 정수 |
| `LOOKUP_TYPE` | 표준/커스텀 오브젝트 조회 |
| `MULTI_PICKLIST` | 다중 선택 피클리스트 |
| `NUMBER_TYPE` | 숫자 |
| `PERCENT_TYPE` | 백분율 |
| `PHONE_TYPE` | 전화번호 |
| `PICKLIST` | 피클리스트 |
| `STRING_SHORT_TYPE` | 짧은 텍스트 (255자 이하) |
| `STRING_LONG_TYPE` | 긴 텍스트 (255자 초과) |
| `TIME_TYPE` | 시간 |
| `URL_TYPE` | URL |

---

## DataSource.Filter — WHERE 조건 파싱

`QueryContext.tableSelection`에서 WHERE 절의 조건을 파싱한 결과.

```apex
// query() 내에서 Filter 직접 파싱
DataSource.Filter whereFilter = ctx.tableSelection.filter;
if (whereFilter != null) {
    applyFilter(whereFilter, rows);
}

private void applyFilter(DataSource.Filter f, List<Map<String,Object>> rows) {
    if (f.type == DataSource.FilterType.EQUALS) {
        // rows를 f.columnName == f.columnValue 로 필터
    } else if (f.type == DataSource.FilterType.AND_) {
        for (DataSource.Filter sub : f.subfilters) {
            applyFilter(sub, rows);
        }
    }
}
```

### Filter 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `columnName` | `String` | 필터 대상 컬럼 이름 |
| `columnValue` | `Object` | 필터 값 |
| `tableName` | `String` | 필터 대상 테이블 이름 |
| `type` | `DataSource.FilterType` | 필터 타입 |
| `subfilters` | `List<DataSource.Filter>` | 복합 타입(AND_, OR_, NOT_)의 하위 필터 |

### DataSource.FilterType Enum

| 값 | 설명 |
|---|---|
| `AND_` | 복합 AND (subfilters 필수) |
| `CONTAINS` | 포함 (LIKE '%val%') |
| `ENDS_WITH` | 끝 일치 (LIKE '%val') |
| `EQUALS` | 등호 |
| `GREATER_THAN` | 초과 |
| `GREATER_THAN_OR_EQUAL_TO` | 이상 |
| `LESS_THAN` | 미만 |
| `LESS_THAN_OR_EQUAL_TO` | 이하 |
| `LIKE_` | LIKE 패턴 |
| `NOT_` | 부정 (subfilters 필수) |
| `NOT_EQUALS` | 불등호 |
| `OR_` | 복합 OR (subfilters 필수) |
| `STARTS_WITH` | 시작 일치 (LIKE 'val%') |

---

## DataSource.Order — ORDER BY 파싱

```apex
// QueryContext에서 ORDER BY 추출
List<DataSource.Order> orderBys = ctx.tableSelection.order;
for (DataSource.Order o : orderBys) {
    String col  = o.columnName;
    String tbl  = o.tableName;
    DataSource.OrderDirection dir = o.direction;
    // ASCENDING 또는 DESCENDING
}

// Order 직접 생성
DataSource.Order asc = DataSource.Order.get('Products', 'Name', DataSource.OrderDirection.ASCENDING);
```

### Order 프로퍼티

| 프로퍼티 | 타입 |
|---|---|
| `columnName` | `String` |
| `tableName` | `String` |
| `direction` | `DataSource.OrderDirection` |

### DataSource.OrderDirection Enum

| 값 |
|---|
| `ASCENDING` |
| `DESCENDING` |

---

## DataSource.Table — 테이블 정의

`sync()`에서 External Object 스키마를 반환할 때 사용.

```apex
// sync() 예시
List<DataSource.Column> columns = new List<DataSource.Column>{
    DataSource.Column.text('ExternalId', 255),  // 필수
    DataSource.Column.url('DisplayUrl'),          // 필수
    DataSource.Column.text('Name', 255),
    DataSource.Column.date('OrderDate')
};

return new List<DataSource.Table>{
    DataSource.Table.get('Orders', 'Name', columns)
};
```

### Table 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `name` | `String` | 테이블(오브젝트) API 이름 |
| `nameColumn` | `String` | 이름 필드로 사용할 컬럼 이름 |
| `labelSingular` | `String` | 단수 레이블 |
| `labelPlural` | `String` | 복수 레이블 |
| `description` | `String` | 설명 |
| `columns` | `List<DataSource.Column>` | 컬럼 목록 |

---

## DataSource.ColumnSelection — SELECT 절 컬럼

```apex
// QueryContext 내에서 SELECT 절 파싱
List<DataSource.ColumnSelection> cols = ctx.tableSelection.columnsSelected;
for (DataSource.ColumnSelection cs : cols) {
    String colName = cs.columnName;
    String tblName = cs.tableName;
    DataSource.QueryAggregation agg = cs.aggregation;
    // COUNT, MAX, MIN, SUM, null
}
```

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `columnName` | `String` | SELECT 대상 컬럼 이름 |
| `tableName` | `String` | 컬럼이 속한 테이블 |
| `aggregation` | `DataSource.QueryAggregation` | 집계 함수 |

### DataSource.QueryAggregation Enum

| 값 | 설명 |
|---|---|
| `COUNT` | COUNT() |
| `MAX` | MAX() |
| `MIN` | MIN() |
| `SUM` | SUM() |
| `NONE` (null) | 집계 없음 |

---

## DataSource.TableSelection — SOQL 쿼리 분해 결과

`QueryContext.tableSelection`에 저장되어 있으며 SOQL의 각 절을 파싱한 결과를 담는다.

```apex
DataSource.QueryContext ctx = queryContext;
DataSource.TableSelection sel = ctx.tableSelection;

String tableName        = sel.tableSelected;          // FROM 절
List<DataSource.ColumnSelection> cols = sel.columnsSelected; // SELECT 절
DataSource.Filter filter = sel.filter;                 // WHERE 절
List<DataSource.Order> orders = sel.order;             // ORDER BY 절
Integer limitVal   = ctx.maxResults;                   // LIMIT
Integer offsetVal  = ctx.offset;                       // OFFSET
String token       = ctx.queryMoreToken;               // query-more 토큰
```

---

## DataSource.ConnectionParams — 연결 파라미터

Provider.getConnection()이 Connection에 전달하는 연결 설정 정보.

```apex
global class MyConnection extends DataSource.Connection {
    global MyConnection(DataSource.ConnectionParams params) {
        // Named Credential 기반 인증
        String protocol      = params.protocol.name();   // ANONYMOUS, OAUTH, PASSWORD 등
        String endpoint      = params.endpoint;
        String oauthToken    = params.oauthToken;
        String username      = params.username;
        String password      = params.password;
        String certName      = params.certificateName;
        DataSource.IdentityType principalType = params.principalType;
    }
}
```

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `endpoint` | `String` | 외부 시스템 URL |
| `protocol` | `DataSource.AuthenticationProtocol` | 인증 프로토콜 |
| `principalType` | `DataSource.IdentityType` | 인증 주체 유형 |
| `oauthToken` | `String` | OAuth 액세스 토큰 |
| `username` | `String` | 사용자명 |
| `password` | `String` | 비밀번호 |
| `certificateName` | `String` | 인증서 이름 |
| `repository` | `String` | 저장소 이름 (선택) |

### DataSource.IdentityType Enum

| 값 | 설명 |
|---|---|
| `ANONYMOUS` | 인증 없음 |
| `NAMED_USER` | Named Credential에 설정된 인증 정보 |

### DataSource.AuthenticationProtocol Enum

| 값 | 설명 |
|---|---|
| `ANONYMOUS` | 인증 없음 |
| `OAUTH` | OAuth |
| `PASSWORD` | 사용자명/비밀번호 |
| `CERTIFICATE` | 인증서 |

---

## DataSource.ReadContext — 읽기 전용 쿼리 컨텍스트

`query()` 메서드의 `QueryContext`와 유사하나 읽기 전용 어댑터용. 프로퍼티는 QueryContext와 동일.

---

## DataSource.SearchUtils — SOSL 검색 유틸리티

```apex
// searchByName: SearchContext를 받아 이름 컬럼 기반으로 로컬 검색
override global List<DataSource.TableResult> search(DataSource.SearchContext ctx) {
    return DataSource.SearchUtils.searchByName(ctx, fetchAllRows());
}
```

| 메서드 | 설명 |
|---|---|
| `searchByName(ctx, rows)` | 이름 컬럼 기반 단순 검색 구현 |

---

## DataSource.DataSourceUtil — 로그 유틸리티

```apex
DataSource.DataSourceUtil util = new DataSource.DataSourceUtil();
util.logWarning('외부 시스템 응답 지연');
util.throwException('연결 실패: ' + errorMsg);
```

| 메서드 | 설명 |
|---|---|
| `logWarning(message)` | 경고 로그 기록 |
| `throwException(message)` | DataSource 예외 발생 |

---

## DataSource.QueryUtils — 로컬 SOQL 처리

외부 시스템이 필터/정렬/페이지네이션을 지원하지 않을 때 in-memory로 처리.

```apex
// 완전한 로컬 처리 (필터 + 정렬 + LIMIT/OFFSET)
List<Map<String,Object>> processed = DataSource.QueryUtils.process(ctx, allRows);

// 단계별 처리
List<Map<String,Object>> filtered = DataSource.QueryUtils.filter(ctx, allRows);
List<Map<String,Object>> sorted   = DataSource.QueryUtils.sort(ctx, filtered);
List<Map<String,Object>> paged    = DataSource.QueryUtils.applyLimitAndOffset(ctx, sorted);
```

| 메서드 | 설명 |
|---|---|
| `process(ctx, rows)` | 필터 + 정렬 + LIMIT/OFFSET 일괄 처리 |
| `filter(ctx, rows)` | WHERE 절 필터만 적용 |
| `sort(ctx, rows)` | ORDER BY 정렬만 적용 |
| `applyLimitAndOffset(ctx, rows)` | LIMIT/OFFSET만 적용 |

---

## DataSource Exceptions

```apex
// DataSource 어댑터 내에서 예외 발생
throw new DataSource.DataSourceException('외부 API 응답 오류: ' + statusCode);
```

---

## 관련 노트

- [[RestClient 패턴]] — Connection 내 HTTP callout 구현에 사용
- [[LxScheduler Namespace]] — 외부 캘린더 연동 (외부 데이터·시스템 연동 패턴)
- [[Named Credential]] — callout 인증 관리
- [[Dom Namespace]] — XML 응답 파싱
- [[SOQL 패턴]] — 내부 데이터 쿼리와 구분
