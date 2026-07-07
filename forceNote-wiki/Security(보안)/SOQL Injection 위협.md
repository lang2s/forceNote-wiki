---
tags: [Security, SecureCoding, SOQLInjection, SOQL, SOSL, 보안가이드, 위협모델, 인젝션]
source: secure_coding (Secure Coding Guide, v67.0 Summer '26), salesforce_apex_developer_guide (SOQL Injection / SOSL Injection / SOQL Injection Defenses), salesforce_apex_reference_guide (String.escapeSingleQuotes)
created: 2026-06-18
aliases: [SOQL Injection, SOSL Injection, SOQL 인젝션, SOSL 인젝션, escapeSingleQuotes 보안, bind variable 보안, SQL Injection 방어, isSafeObject isSafeField, 동적 SOQL에 사용자 입력 넣어도 되나, 쿼리에 변수 안전하게 넣는 법, 인젝션 막으려면 바인드 변수, 동적 쿼리 보안, queryWithBinds 방어, 화이트리스트 쿼리]
---

# SOQL Injection 위협

> user data를 type-safe bind parameter 대신 query에 직접 embedding하면 악성 input이 query 구조를 바꾼다 — Apex SOQL에서의 인젝션 위협과 방어.

---

## 위협

user data로 query를 구성할 때 type-safe bind parameter 대신 embedding하면, 악성 input이 query 구조를 변경할 수 있다. Apex는 SQL이 아닌 **SOQL**을 사용한다. SOQL은 SELECT만 가능하므로 delete/modify가 불가능해 SQL injection보다 덜 위험하지만, 공격 방식은 거의 동일하다. SOQL injection은 **CRUD/FLS bypass의 한 형태**다. (Trailhead: Mitigate SOQL Injection)

### Sample Vulnerability (Apex)

`Personnel__c` 검색 예제. 아래처럼 user input을 직접 연결하면 취약하다.

```apex
// 취약 예제 (원문)
whereClause += 'Title__c LIKE \'%' + userInputTitle + '%\'';
// ...
List<Personnel__c> records = Database.query(queryString);
```

공격 입력 `'% OR Performance_rating__c < 2 OR Name LIKE '%'` 를 넣으면 WHERE 절이 조작되어 의도하지 않은 레코드가 노출된다.

---

## How to Secure my SOQL Queries

SOQL의 3대 커스터마이즈 영역: **Select fields / From object / Where clause.**

### WHERE 절 — bind variable (가장 간단·권장)

parameterized query(bind variable)를 사용한다. 안전 예제(원문):

```apex
String qTitle = '%' + userInputTitle + '%'; // Fixed variable — wildcard wrapping 포함
List<Personnel__c> records =
  [SELECT Name, Role__c, Title__c, Age__c FROM Personnel__c WHERE Title__c LIKE :qTitle];
```

`:` prefix는 bind variable이며, DB 계층이 그 내용을 전부 **데이터로 취급**한다. 단 bind variable은 **WHERE 절의 변수 binding에만 한정**되므로, dynamic field name이나 dynamic object name에는 쓸 수 없다.

> bind variable·`Database.query` 메커니즘 자체의 시그니처와 동적 쿼리 작성법은 [[Dynamic SOQL]]·[[SOSL 패턴]] 참조. 여기서는 인젝션 위협 관점만 다룬다.

### 동적 object name — `isSafeObject`

동적 object name이 필요하면 sanitizing 함수로 검증한다. `Schema.getGlobalDescribe()`로 SObjectType를 조회한 뒤 `getDescribe().isAccessible()`로 확인한다(CRUD check 겸함).

```apex
// 원문 패턴
public Boolean isSafeObject(String objName) {
  SObjectType sObjType = Schema.getGlobalDescribe().get(objName);
  if (sObjType == null) { return false; }
  return sObjType.getDescribe().isAccessible();
}
```

### 동적 field name — `isSafeField`

동적 field name이 필요하면 object가 accessible한지 확인한 후, `myObj.getDescribe().fields.getMap().get(fieldName)`로 field를 얻어 field의 `isAccessible()`을 검사한다.

```apex
// 원문 패턴
public Boolean isSafeField(String fieldName, String objName) {
  if (!isSafeObject(objName)) { return false; }
  SObjectType sObjType = Schema.getGlobalDescribe().get(objName);
  Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
  Schema.SObjectField field = fieldMap.get(fieldName);
  if (field == null) { return false; }
  return field.getDescribe().isAccessible();
}
```

> **API vs Apex 차이 (원문):** REST/SOAP API는 임의 SOQL을 허용하지만 sharing·CRUD/FLS 검사가 내장되어 있어 SOQL injection이 되지 않는다. Apex SOQL은 CRUD/FLS 검사를 하지 않는다(sharing은 `with sharing`일 때만). 따라서 **end user가 Apex SOQL 내용을 제어하는 것은 심각한 취약점이지만, API 경유는 취약점이 아니다.**

---

## 방어 기법 카탈로그 (Apex Developer Guide)

Secure Coding Guide의 위 원칙을 Apex 개발자 관점의 6개 방어 기법으로 정리한다(출처: Apex Developer Guide — SOQL Injection / SOSL Injection / SOQL Injection Defenses). 값 injection은 바인딩으로, 식별자(필드/오브젝트명) injection은 화이트리스트로 막는다는 것이 핵심이다.

| # | 기법 | 무엇을 막나 | 한계 / 적용 범위 |
|---|---|---|---|
| 1 | 정적 SOQL + `:var` 바인딩 | 값 위치 injection 전부 | **1순위.** 쿼리 구조가 컴파일 타임 고정일 때만. 필드/오브젝트명은 바인딩 불가 |
| 2 | `Database.queryWithBinds` (bindMap) | 동적 문자열이 필요할 때의 값 injection | 값만 바인딩. 스코프 밖 변수도 Map으로 전달 가능 (API 57.0+) |
| 3 | `String.escapeSingleQuotes()` | 문자열 리터럴 내 따옴표 탈출 | 문자열 리터럴 값에만. 숫자·필드명·오브젝트명·연산자엔 무의미 |
| 4 | 타입 캐스팅 (`Integer.valueOf` 등) | 숫자 컨텍스트 injection | 입력이 숫자/불리언일 때. 값을 문자열 아닌 타입으로 강제 |
| 5 | 화이트리스트 (허용목록) | 필드명·오브젝트명·정렬 방향 injection | escape로 못 막는 식별자 위치. 허용된 값만 통과 |
| 6 | SOSL: `escapeSingleQuotes` + 위 원칙 | SOSL injection | `Search.query` 동적 SOSL에 동일 적용 |

### `Database.queryWithBinds` / `getQueryLocatorWithBinds` (bindMap)

쿼리 문자열을 런타임에 조립해야 하지만 **값은 안전하게 바인딩**하고 싶을 때. 바인드 변수를 Apex 변수 스코프가 아니라 **Map 파라미터**에서 key로 해석한다(API 57.0+). 값 위치 injection을 막는다.

```apex
// 방어 — 동적 문자열이되 값은 bindMap으로 바인딩 (API 57.0+)
Map<String, Object> acctBinds = new Map<String, Object>{ 'acctName' => 'Acme Corporation' };
List<Account> accts = Database.queryWithBinds(
    'SELECT Id FROM Account WHERE Name = :acctName',
    acctBinds,
    AccessLevel.USER_MODE);
```

bindMap 사용 시 고려사항:
- Map key는 **대소문자 구분 안 함** — 대소문자만 다른 중복 key가 있으면 런타임 `System.QueryException`(`The bindMap consists of duplicate case-insensitive keys`)이 발생한다.
- key는 변수 명명 규칙을 따라야 한다: ASCII 문자로 시작, 숫자로 시작 불가, 예약어 불가.
- Map key에 dot notation은 현재 지원되나 Salesforce가 **권장하지 않는다**.

같은 계열의 WithBinds 메서드가 동적 쿼리 전반을 커버한다:
- `Database.queryWithBinds` — sObject 리스트 반환
- `Database.getQueryLocatorWithBinds` — Batch Apex·Visualforce용 `QueryLocator` 생성
- `Database.countQueryWithBinds` — 반환 레코드 수 계산

> `accessLevel`(`AccessLevel.USER_MODE`/`SYSTEM_MODE`)로 오브젝트·필드 권한과 공유 규칙 강제 여부를 함께 지정한다 — injection 방지와 별개의 접근제어 축이다. [[WITH USER_MODE]] 참조.

### 타입 캐스팅 — 숫자/불리언 강제

입력이 숫자여야 하면 문자열로 결합하지 말고 타입으로 파싱해 강제한다. 파싱 실패 시 예외로 걸러지고, 성공하면 SOQL 명령 문자가 끼어들 수 없다. `escapeSingleQuotes`는 따옴표로 감싸지 않는 숫자 컨텍스트(`WHERE Age > {입력}`)엔 무의미하므로 이 기법으로 처리한다.

```apex
// 구조 예시 — 실제 동작 코드 아님 (숫자 입력 방어 패턴)
Integer age = Integer.valueOf(userInput);   // 숫자 아니면 여기서 예외
String qry = 'SELECT Id FROM Contact WHERE Age__c > ' + age;  // 따옴표 없이 안전
List<Contact> rows = Database.query(qry);
```

### 식별자 화이트리스트 — 필드명·오브젝트명엔 escape가 안 통한다

`escapeSingleQuotes`는 식별자(필드/오브젝트/정렬 컬럼)를 보호하지 못한다 — 따옴표로 감싸지 않는 위치이기 때문이다. 사용자가 필드명·오브젝트명·정렬 방향을 고를 수 있어야 하면 **허용된 값의 목록(allowlist)에 있는 것만** 통과시킨다.

```apex
// 구조 예시 — 실제 동작 코드 아님 (식별자 화이트리스트 패턴)
Set<String> allowedFields = new Set<String>{ 'Name', 'Email', 'Phone' };
if (!allowedFields.contains(userField)) {
    throw new AuraHandledException('허용되지 않은 필드');
}
// Schema describe로 실재 확인하면 더 견고
String qry = 'SELECT Id, ' + userField + ' FROM Contact';
List<Contact> rows = Database.query(qry);
```

정렬 방향도 마찬가지로 `{'ASC','DESC'}` 화이트리스트로 좁힌다. 식별자는 위 `isSafeObject`/`isSafeField`(Schema describe)로 실재 여부를 재검증하면 CRUD/FLS까지 함께 확인돼 더 견고하다.

### SOSL Injection — `Search.query`

SOSL injection도 동적 SOSL(`Search.query`)에서 검증 없는 입력을 결합할 때 발생하며, 방어는 SOQL과 동일하게 `escapeSingleQuotes`로 사용자 입력의 따옴표를 탈출시키는 것이다.

```apex
// 방어 — 동적 SOSL의 사용자 입력 sanitize
String term = String.escapeSingleQuotes(userTerm);
String sosl = 'FIND \'' + term + '\' IN ALL FIELDS RETURNING Account(Id, Name), Contact, Lead';
List<List<SObject>> results = Search.query(sosl);
```

문자열 리터럴 한정이라는 한계도 SOQL과 동일하다 — `RETURNING` 절의 오브젝트/필드명은 화이트리스트로 통제한다.

### 선택 기준 — 언제 무엇을

| 상황 | 권장 |
|---|---|
| 쿼리 구조가 고정, 값만 사용자 입력 | **정적 SOQL + `:var`** (1순위) |
| 쿼리 문자열을 런타임 조립, 값은 안전하게 | `Database.queryWithBinds` / `getQueryLocatorWithBinds` |
| 문자열 리터럴 값만 동적 결합이 불가피 | `String.escapeSingleQuotes()` (한계 인지) |
| 입력이 숫자/불리언 | 타입 캐스팅 (`Integer.valueOf` 등) |
| 사용자가 필드/오브젝트/정렬을 선택 | 화이트리스트 (escape 무효 구간) |
| 동적 SOSL 검색어 | `escapeSingleQuotes` + RETURNING 절 화이트리스트 |

> injection 방지(값을 문법에서 분리)와 접근제어([[WITH USER_MODE]]·[[CanTheUser]]·[[StripInaccessible]] = 누가 무엇을 볼 수 있나)는 **별개의 축**이다. 둘 다 적용해야 완전하다.

---

## Alternate Methods to Secure SOQL Queries

| Method | Description |
|---|---|
| **Escape Single Quotes** | 동적 query에서 `String.escapeSingleQuotes()`를 사용. 예: `'... LIKE \'%'+String.escapeSingleQuotes(name)+'%\''`. query tampering은 막지만 unauthorized data 접근은 못 막는다. single quote 안의 변수에만 적용되며 boolean/unquoted field에는 무효. **권장하지 않음.** |
| **Typecasting / Whitelisting** | **Typecasting**: user input을 boolean/integer 등 기대 타입으로 변환하고, 변환 실패 시 중단. **Whitelisting**: input 구조를 알 때 predefined list로 검증. Typecasting 예: `'... WHERE isActive = ' + (input ? 'TRUE' : 'FALSE')`. Whitelisting 예: `Set<String> fields` + `fields.contains(inputField)` 검사 후 `CustomException`. injection은 막지만 object 접근권은 보장하지 않으며, **edge case를 제외하면 권장하지 않음.** |

---

## How Do I Protect My Non-Salesforce Application?

플랫폼별 typed parameterized query가 최선이다. 필터링·sanitize는 필수다. "known good" allowlist가 최선이다(예: phone=숫자만, name=문자·공백만). blacklisting은 alternate encoding/double quote로 우회 가능하다. single-quote, double-quote, hyphen, NULL, newline을 제거한다. (OWASP SQL Injection / Blind SQL Injection / Microsoft 링크)

---

## Best Practices for Preventing SQL Injection Across Various Technologies

> PDF에서 row=Technology(5개), col=3개(Technology / Best Practices / References). 이미지로 셀 매핑 재검증 완료 — 원문 방향 그대로 인용(transpose 아님).

| Technology | Best Practices | References |
|---|---|---|
| **ASP.NET** | query 전 input data를 sanitize. stored procedure든 dynamic SQL이든 type-safe SQL parameter를 일관 사용. `SqlParameterCollection`으로 type check·length validation. | How To: Protect From SQL Injection in ASP.NET |
| **LINQ** | LINQ로 ASP.NET 앱의 SQL injection 방지. LINQ가 DB construct를 native object로 취급. LINQ to SQL이 DB 상호작용을 object model로 추상화 → 자동 parameterized query 생성으로 injection 회피. | LINQ to SQL: .NET Language-Integrated Query for Relational Data |
| **Java** | 대형 앱은 commercial source code analysis tool(Checkmarx, Coverity, Fortify, Klocwork, Ounce Labs). 소형 앱은 manual review + coding standard. 모든 JDBC code를 리뷰 — user data 처리에 `java.sql.Statement` 사용은 risk. user data엔 `java.sql.CallableStatement`, `java.sql.PreparedStatement`만 사용. Hibernate/ORM으로 prepared statement 활용 — HQL 직접 사용 주의, `session.find` 같은 deprecated 회피, bind variable 지원 overload 사용. ORM 사용 시에도 input 검증·sanitize. | OWASP SQL Injection Prevention Cheat Sheet / OWASP Hibernate Security Guidance |
| **PHP (PDO)** | PHP Data Objects(PDO)로 parameterized query·prepared statement. `PDO::prepare`는 좋은 방어이나 underlying PDO driver·DB가 native parameterized query를 지원할 때만 보장. `PDO::prepare` 전 data sanitize(defense-in-depth). regex로 input 값을 기대 포맷으로 제한. | PHP Security guidance for Prepared Statements and Stored Procedures |
| **Ruby on Rails** | Active Record object는 제한적 자동 보호. `Model.find(id)`/`Model.find_by_X(X)`는 `'`,`"`,NULL,line break를 자동 escape. SQL fragment(`:conditions => "..."`), `connection.execute`, `Model.find_by_sql`는 수동 sanitize 필요. conditions를 array/hash 형태로. `sanitize_sql_array`/`sanitize_sql_for_conditions` 수동(Rails 2.0), deprecated `sanitize_sql`(이전). | OWASP Ruby on Rails Cheat Sheet |

Java 예제(원문):

```java
PreparedStatement pstmt = con.prepareStatement("UPDATE USERS SET SALARY = ? WHERE ID = ?");
pstmt.setBigDecimal(1, new BigDecimal("30000.00"));
pstmt.setInt(2, 20487);
pstmt.executeUpdate();
```

Ruby on Rails 예제(원문):

```ruby
Model.find(:first, :conditions => ["login = ? AND password = ?", entered_user_name, entered_password])
```

---

## How Can I Test My Application?

black-box(single quote, dash 입력 후 DB error 관찰)는 일부만 발견한다. 최선은 manual code review/static analysis다. Lightning Platform: **Security Source Code Scanner**(첫 on-demand PaaS source code analysis tool). bind variable vs string concatenation을 검증한다. static SQL stored procedure는 OK이나, exec로 dynamic SQL을 구성하는 것은 주의한다.

안전 예제(원문):

```java
PreparedStatement query =
  con.prepareStatement("SELECT * FROM users WHERE userid = ? AND password = ?");
```

---

## 관련 노트
- [[Dynamic SOQL]]
- [[SOSL 패턴]]
- [[Search Namespace]]
- [[권한과 접근 제어 위협]]
- [[CanTheUser]]
- [[WITH USER_MODE]]
- [[StripInaccessible]]
- [[Secure Coding 개요]]
- [[Platform Security FAQ]]
