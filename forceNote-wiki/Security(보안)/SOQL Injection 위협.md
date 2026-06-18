---
tags: [Security, SecureCoding, SOQLInjection, SOQL, 보안가이드, 위협모델, 인젝션]
source: secure_coding (Secure Coding Guide, v67.0 Summer '26)
created: 2026-06-18
aliases: [SOQL Injection, SOQL 인젝션, escapeSingleQuotes 보안, bind variable 보안, SQL Injection 방어, isSafeObject isSafeField, 동적 SOQL에 사용자 입력 넣어도 되나, 쿼리에 변수 안전하게 넣는 법, 인젝션 막으려면 바인드 변수, 동적 쿼리 보안]
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
- [[Secure Coding 개요]]
- [[Platform Security FAQ]]
