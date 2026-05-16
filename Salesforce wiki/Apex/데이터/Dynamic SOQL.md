---
tags: [apex, soql, dynamic, security, injection, pattern]
source: apex-recipes/DynamicSOQLRecipes.cls
created: 2026-05-17
aliases: [동적 SOQL, SOQL 인젝션]
---

# Dynamic SOQL

> 사용자 입력이 포함된 동적 SOQL의 안전한 작성법. `Database.queryWithBinds`가 핵심.

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
- [[QuiddityGuard]]
- [[WITH USER_MODE]]
