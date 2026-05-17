---
tags: [apex, security, soql, user-mode, pattern]
source: apex-recipes/SOQLRecipes.cls, AccountServiceLayer.cls
created: 2026-05-17
aliases: [WITH USER_MODE, USER_MODE, 사용자 모드 쿼리]
---

# WITH USER_MODE

> API 57.0 (Summer '23)부터 지원. SOQL에 `WITH USER_MODE`를 추가하면 현재 사용자의 Object/Field 권한을 자동 적용. `with sharing`의 레코드 가시성과 별개로 동작.

---

## 기본 사용법

```apex
// 기본 — 현재 사용자의 FLS/CRUD 적용
List<Account> accounts =
    [SELECT Id, Name, BillingCity FROM Account WITH USER_MODE];

// 시스템 권한으로 실행 (FLS 무시) — 필요한 경우에만
List<Account> accounts =
    [SELECT Id, Name FROM Account WITH SYSTEM_MODE];
```

---

## sharing 키워드 vs USER_MODE 차이

| | sharing 키워드 | WITH USER_MODE |
|---|---|---|
| 적용 대상 | 레코드 가시성 (행) | FLS/CRUD (열+객체) |
| `with sharing` | 공유 규칙 적용 | 무관 |
| `without sharing` | 공유 규칙 무시 | 무관 |
| `WITH USER_MODE` | 무관 | FLS/CRUD 적용 |

> [!tip] 올바른 조합
> `with sharing` 클래스 + `WITH USER_MODE` 쿼리 = 행 제한 + 열 제한 모두 적용.

---

## 일반적인 사용 패턴

```apex
// 1. Service Layer 기본 패턴
public with sharing class AccountService {
    public List<Account> getAccounts() {
        return [SELECT Id, Name, Phone FROM Account WITH USER_MODE LIMIT 200];
    }
}

// 2. @AuraEnabled 메서드
@AuraEnabled(cacheable=true)
public static List<Account> getAccountsForUI() {
    try {
        return [SELECT Id, Name FROM Account WITH USER_MODE ORDER BY Name LIMIT 100];
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}

// 3. Database.query (동적 SOQL)
String soql = 'SELECT Id, Name FROM Account WHERE Name LIKE :pattern';
List<Account> results = Database.query(soql, AccessLevel.USER_MODE);
```

---

## Database.queryWithBinds — Bind 변수 포함 동적 SOQL

```apex
// SOQL injection 방어 + USER_MODE
String searchTerm = '%' + keyword + '%';
Map<String, Object> binds = new Map<String, Object>{
    'searchTerm' => searchTerm
};

List<Account> results = Database.queryWithBinds(
    'SELECT Id, Name FROM Account WHERE Name LIKE :searchTerm',
    binds,
    AccessLevel.USER_MODE
);
```

> [!warning] String.format()으로 SOQL 조립 금지
> `'SELECT Id FROM Account WHERE Name = \'' + userInput + '\''` → SOQL Injection 위험. 반드시 bind 변수 또는 `queryWithBinds` 사용.

---

## AccessLevel 열거형

| AccessLevel | 설명 |
|---|---|
| `USER_MODE` | 현재 사용자 권한 적용 |
| `SYSTEM_MODE` | 시스템 권한 (FLS 무시) |

`Database.insert(records, AccessLevel.USER_MODE)` — DML에도 동일하게 적용 가능 (API 57.0+).

---

## 관련 노트

- [[SOQL 패턴]]
- [[Dynamic SOQL]]
- [[DML 패턴]]
- [[CanTheUser]]
- [[Safely]]

