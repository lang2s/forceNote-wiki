---
tags: [apex, security, soql, user-mode, pattern]
source: apex-recipes/SOQLRecipes.cls, AccountServiceLayer.cls
created: 2026-05-17
aliases: [WITH USER_MODE, USER_MODE, 사용자 모드 쿼리]
---

# WITH USER_MODE

> API 57.0 (Summer '23)부터 지원. SOQL에 `WITH USER_MODE`를 추가하면 현재 사용자의 Object/Field 권한을 자동 적용. `with sharing`의 레코드 가시성과 별개로 동작.

---

> [!important] Summer '26 (API v67.0) 파괴적 변경
> - `WITH SECURITY_ENFORCED`는 v67.0부터 **컴파일 오류** 발생 → 즉시 `WITH USER_MODE`로 교체 필수.
> - SOQL, DML, Database 메서드의 **기본 실행 모드가 USER_MODE로 변경**됨. 명시적으로 작성하지 않아도 USER_MODE로 동작하지만, 코드 가독성을 위해 명시 권장.

---

## WITH SECURITY_ENFORCED vs WITH USER_MODE (v67.0 기준)

| 항목 | `WITH SECURITY_ENFORCED` | `WITH USER_MODE` |
|---|---|---|
| v67.0 상태 | ❌ 폐기 (컴파일 오류) | ✅ 현행 표준 |
| 다형성 필드 처리 | ❌ 미지원 | ✅ 지원 |
| 적용 절 범위 | WHERE, ORDER BY 일부 | 모든 절 검사 |
| FLS 오류 탐지 | 부분적 | 전체 탐지 |
| 동적 SOQL 지원 | ❌ 불가 | ✅ `AccessLevel.USER_MODE` |

> [!warning] WITH SECURITY_ENFORCED 사용 금지
> v67.0(Summer '26)부터 `WITH SECURITY_ENFORCED`는 컴파일 오류. 기존 코드베이스 전체를 `WITH USER_MODE`로 교체해야 한다.

---

## 기본 사용법

```apex
// 권장 — 현재 사용자의 FLS/CRUD 적용 (v67.0부터 기본값이지만 명시 권장)
List<Account> accounts =
    [SELECT Id, Name, BillingCity FROM Account WITH USER_MODE];

// 시스템 권한으로 실행 (FLS 무시) — 필요한 경우에만 명시
List<Account> accounts =
    [SELECT Id, Name FROM Account WITH SYSTEM_MODE];

// ❌ 사용 금지 — v67.0 컴파일 오류
// [SELECT Id, Name FROM Account WITH SECURITY_ENFORCED]
```

---

## v67.0 이후 "언제 명시해야 하나?"

v67.0부터 `WITH USER_MODE`를 명시하지 않아도 USER_MODE가 기본으로 동작한다. 그러나 다음 이유로 **명시를 권장**한다.

- 코드 의도가 명확해짐 (리뷰어가 보안 검토를 건너뛰지 않도록)
- `WITH SYSTEM_MODE`와 쌍으로 대비할 때 일관성 유지
- v67.0 미만 API 버전 대상 코드와 혼용될 때 명확한 구분

`WITHOUT SHARING` 클래스나 `System.runAs()` 블록처럼 **시스템 컨텍스트가 명확한 곳**에서는 모드를 명시해 의도를 드러내는 것이 더 중요하다.

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
- [[Summer '26]]
