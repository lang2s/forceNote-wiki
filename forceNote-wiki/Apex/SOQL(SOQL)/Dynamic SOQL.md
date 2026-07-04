---
tags: [apex, soql, dynamic, security, injection, pattern]
source: apex-recipes/DynamicSOQLRecipes.cls, ebikes-lwc-main/force-app/main/default/classes/ProductController.cls
created: 2026-05-17
aliases: [동적 SOQL, SOQL 인젝션, 동적 필터 빌더, countQuery, String.join WHERE]
---

# Dynamic SOQL

> 사용자 입력이 포함된 동적 SOQL의 안전한 작성법. `Database.queryWithBinds`가 핵심.

---

## 개념

### Dynamic SOQL이란

정적 SOQL(`[SELECT Id FROM Account]`)은 컴파일 타임에 구문이 확정된다. 반면 Dynamic SOQL은 **런타임에 문자열로 SOQL을 조립**해 `Database.query()` 등으로 실행한다.

Dynamic SOQL이 필요한 상황:
- 쿼리 대상 오브젝트 타입을 런타임에 결정해야 할 때
- 사용자가 선택한 필드 목록에 따라 SELECT 절이 변해야 할 때
- 조건(WHERE 절)의 유무나 구조 자체가 동적으로 결정될 때
- Tooling API, Metadata API처럼 정적 SOQL이 지원하지 않는 오브젝트를 대상으로 할 때

### 왜 위험한가 — SOQL Injection

Dynamic SOQL의 가장 큰 위험은 **SOQL Injection**이다. 사용자 입력을 그대로 SOQL 문자열에 연결하면, 악의적인 사용자가 쿼리 구조 자체를 변경할 수 있다. 예를 들어 `Name = 'x' OR 1=1 --` 형태의 입력은 WHERE 절을 무력화해 모든 레코드를 반환하게 만든다.

SQL Injection과 동일한 원리지만, Salesforce 내부 데이터를 대상으로 한다는 점에서 레코드 유출, 공유 규칙 우회, 권한 없는 필드 조회 등의 피해로 이어질 수 있다.

### 안전한 작성의 핵심 원칙

1. **사용자 입력은 반드시 bind 변수로** — `queryWithBinds`의 bindMap 또는 정적 SOQL의 `:변수명` 구문을 사용
2. **WHERE 절 구조 자체를 사용자가 제어하게 하지 않는다** — 값은 bind로, 절 구조는 코드에서 화이트리스트로 관리
3. **숫자형 파라미터는 타입캐스팅으로 방어** — `Integer.valueOf(input)`으로 숫자로 강제 변환
4. **`String.escapeSingleQuotes()`만으로는 부족하다** — 따옴표 이스케이프는 문자열 값에만 유효하며, 숫자 비교나 절 구조 변조에는 효과 없음

---

## 결정 기준

| 상황 | 사용 패턴 |
|---|---|
| 정적 쿼리 문자열, 입력값 없음 | `Database.query(string, AccessLevel)` |
| 사용자 입력이 WHERE 절 값으로 사용 | `Database.queryWithBinds(string, bindMap, AccessLevel)` |
| WHERE 절 자체를 동적 구성 | `QuiddityGuard` 신뢰 컨텍스트 검증 필수 |

---

## 패턴 1: Database.queryWithBinds (표준 권장)

```apex
// ✅ 사용자 입력 → bindMap으로 안전하게 바인딩
public static List<Account> getByName(String name) {
    String queryString = 'SELECT Id, Name FROM Account WHERE Name = :name WITH USER_MODE';
    Map<String, Object> binds = new Map<String, Object>{ 'name' => name };
    return Database.queryWithBinds(queryString, binds, AccessLevel.USER_MODE);
}

// bindMap 키 = 쿼리 내 :변수명과 정확히 일치해야 함
Map<String, Object> binds = new Map<String, Object>{
    'name'   => name,
    'limit'  => 100
};
String q = 'SELECT Id FROM Account WHERE Name LIKE :name LIMIT :limit';
return Database.queryWithBinds(q, binds, AccessLevel.USER_MODE);
```

---

## 패턴 2: Database.query + AccessLevel (입력값 없는 동적 쿼리)

```apex
// ✅ WHERE 절에 사용자 입력 없음 — 구조만 동적
public static List<SObject> getRecentRecords(String objectType) {
    String queryString = 'SELECT Id, Name FROM ' + objectType
        + ' ORDER BY CreatedDate DESC LIMIT 10';
    return Database.query(queryString, AccessLevel.USER_MODE);
}
```

---

## 패턴 3: 숫자 파라미터 — 타입캐스트로 방어

```apex
// ✅ Integer.valueOf()로 숫자 타입 강제 → 문자열 인젝션 불가
public static List<Account> getLargeAccounts(String numberOfRecords) {
    String queryString = 'SELECT Id, Name FROM Account '
        + 'WHERE NumberOfEmployees > '
        + String.valueOf(Integer.valueOf(numberOfRecords)); // 타입캐스트 방어
    return Database.query(queryString, AccessLevel.USER_MODE);
}

// ❌ String.escapeSingleQuotes는 숫자 비교에 무효
// 'WHERE NumberOfEmployees > ' + String.escapeSingleQuotes(numberOfRecords)
// → '100 OR 1=1' 같은 인젝션에 취약
```

---

## 패턴 4: WHERE 절 동적 구성 시 QuiddityGuard 필수

```apex
// 사용자가 WHERE 절을 직접 제어하는 위험한 상황
public static List<Account> dynamicWhere(String whereClause) {
    // ✅ 신뢰할 수 없는 컨텍스트(AURA, REST, VF 등)에서 즉시 반환
    if (!QuiddityGuard.isAcceptableQuiddity(QuiddityGuard.trustedQuiddities)) {
        return new List<Account>();
    }

    // 신뢰된 컨텍스트(SYNCHRONOUS, QUEUEABLE, BATCH_APEX)에서만 실행
    return Database.query(
        'SELECT Id, Name FROM Account WHERE ' + whereClause,
        AccessLevel.USER_MODE
    );
}
```

---

## 패턴 5: 필터 패널 → 페이지네이션 컨트롤러 (실전 결합 패턴)

앞의 패턴들이 "단일 조건 + bind" 중심이라면, 실무의 목록 화면은 **여러 개의 선택적 필터**(검색어, 가격 상한, 다중선택 카테고리 등)를 조합하고 그 결과를 페이지 단위로 나눠 반환해야 한다. ebikes 앱의 `ProductController.getProducts`가 이 결합을 보여준다. 세 가지 핵심 기법이 한 메서드에 모인다.

1. **조건을 `List<String>`에 조립 → `String.join`으로 WHERE 절 동적 구성** — 어떤 필터가 채워졌는지에 따라 WHERE 절 구조 자체가 달라진다.
2. **정적 bind(`:key`, `:maxPrice`, `IN :categories`)와 동적 문자열을 혼용** — 절의 *구조*는 코드가 화이트리스트로 조립하고, 값은 전부 bind로 넘긴다. 사용자 입력이 문자열 연결에 닿지 않으므로 인젝션 표면이 없다.
3. **개수와 레코드를 별도 쿼리로 분리** — `Database.countQuery`로 전체 개수(`SELECT count()`)를, `Database.query`로 현재 페이지 레코드를 각각 조회해 [[PagedResult 패턴]]에 담는다.

```apex
// 실제 소스: ebikes-lwc-main/force-app/main/default/classes/ProductController.cls
public class Filters {
    @AuraEnabled public String searchKey { get; set; }
    @AuraEnabled public Decimal maxPrice { get; set; }
    @AuraEnabled public String[] categories { get; set; }
    @AuraEnabled public String[] materials { get; set; }
    @AuraEnabled public String[] levels { get; set; }
}

@AuraEnabled(Cacheable=true scope='global')
public static PagedResult getProducts(Filters filters, Integer pageNumber) {
    String key, whereClause = '';
    Decimal maxPrice;
    String[] categories, materials, levels, criteria = new List<String>{};
    if (filters != null) {
        maxPrice = filters.maxPrice;
        materials = filters.materials;
        levels = filters.levels;
        // ✅ 채워진 필터만 조건 리스트에 추가 — 값은 전부 bind로
        if (!String.isEmpty(filters.searchKey)) {
            key = '%' + filters.searchKey + '%';
            criteria.add('Name LIKE :key');
        }
        if (filters.maxPrice >= 0) {
            maxPrice = filters.maxPrice;
            criteria.add('MSRP__c <= :maxPrice');
        }
        if (filters.categories != null) {
            categories = filters.categories;
            criteria.add('Category__c IN :categories');   // ✅ 다중선택 IN + bind
        }
        if (filters.levels != null) {
            levels = filters.levels;
            criteria.add('Level__c IN :levels');
        }
        if (filters.materials != null) {
            materials = filters.materials;
            criteria.add('Material__c IN :materials');
        }
        // ✅ 조건이 하나라도 있으면 String.join으로 WHERE 절 조립
        if (criteria.size() > 0) {
            whereClause = 'WHERE ' + String.join(criteria, ' AND ');
        }
    }
    Integer pageSize = ProductController.PAGE_SIZE;
    Integer offset = (pageNumber - 1) * pageSize;
    PagedResult result = new PagedResult();
    result.pageSize = pageSize;
    result.pageNumber = pageNumber;
    // ✅ 전체 개수는 별도 countQuery — 같은 whereClause 재사용
    result.totalItemCount = Database.countQuery(
        'SELECT count() FROM Product__c ' + whereClause
    );
    // ✅ 현재 페이지 레코드 — WITH USER_MODE + LIMIT/OFFSET bind
    result.records = Database.query(
        'SELECT Id, Name, MSRP__c, Description__c, Category__c, Level__c, Picture_URL__c, Material__c FROM Product__c ' +
            whereClause +
            ' WITH USER_MODE' +
            ' ORDER BY Name LIMIT :pageSize OFFSET :offset'
    );
    return result;
}
```

### 이 패턴이 인젝션에 안전한 이유

`whereClause`는 사용자 입력을 문자열로 이어붙이지 않는다. `criteria`에 들어가는 것은 `'Name LIKE :key'`처럼 **코드에 하드코딩된 절 문자열**이고, 실제 사용자 값(`key`, `maxPrice`, `categories` 등)은 전부 `:변수명` bind로 전달된다. 즉 `String.join`이 조립하는 것은 *구조(어떤 조건을 AND로 묶을지)*뿐이고, *값*은 절대 문자열 연결에 노출되지 않는다 — 앞의 "안전한 작성의 핵심 원칙 2"(구조는 코드, 값은 bind)를 그대로 구현한 사례다.

> 이 예시는 `Database.query`에 로컬 변수 bind(`:key`, `:pageSize` 등)를 쓰지만, 최신 코드라면 `Database.queryWithBinds`(패턴 1)의 bindMap 방식으로도 동일하게 구성할 수 있다.

### count / records 분리와 페이지네이션

`Database.countQuery('SELECT count() FROM ... ' + whereClause)`는 **같은 whereClause를 재사용**해 필터 적용된 전체 개수를 구한다. 이 개수로 총 페이지 수를 계산하고, 레코드 쿼리는 `LIMIT :pageSize OFFSET :offset`으로 현재 페이지만 가져온다. 두 쿼리 결과를 [[PagedResult 패턴]] 래퍼에 담아 LWC 데이터테이블/페이저에 넘기는 구조다. (정적 SOQL만 쓰는 [[PagedResult 패턴]] 노트의 페이지네이션과 달리, 여기서는 WHERE 절이 런타임에 조립되므로 count도 동적 쿼리로 맞춰야 한다.)

---

## ❌ 절대 하지 말아야 할 것

```apex
// ❌ 문자열 직접 연결 — SOQL 인젝션 위험
String query = 'SELECT Id FROM Account WHERE Name = \'' + userInput + '\'';

// ❌ escapeSingleQuotes만으로 충분하지 않은 경우 있음
String escaped = String.escapeSingleQuotes(userInput);
// → 숫자 필드, LIMIT 절 등에는 효과 없음
```

---

## 관련 노트

- [[SOQL 패턴]]
- [[PagedResult 패턴]] — 정적 SOQL 페이지네이션 래퍼. 패턴 5의 동적 필터 카운트/레코드 분리가 이 래퍼를 채운다
- [[QuiddityGuard]]
- [[WITH USER_MODE]]
- [[SOQL Injection 위협]] — 동적 SOQL 문자열 결합 시 인젝션 위협 모델과 방어 (escapeSingleQuotes 한계, bind 변수)
- [[Platform Security FAQ]] — SOQL 인젝션 등 플랫폼 보안 공통 질문
- [[platform-soql-query]] (sf-skill — 실행형) — 동적 SOQL 작성·인젝션 방어 실행형 스킬
