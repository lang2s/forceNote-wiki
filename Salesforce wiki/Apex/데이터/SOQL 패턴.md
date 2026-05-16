---
tags: [apex, soql, security, pattern]
source: apex-recipes/SOQLRecipes.cls
created: 2026-05-17
---

# SOQL 패턴

> WITH USER_MODE 일관 적용, SOQL for loop로 힙 한도 방어.

---

## WITH USER_MODE — 모든 SOQL의 기본

```apex
// ✅ 표준 — WITH USER_MODE 항상 붙임
List<Account> accounts = [
    SELECT Id, Name, ShippingStreet
    FROM Account
    WITH USER_MODE
];

// ✅ 서브쿼리도 동일
List<Account> withContacts = [
    SELECT Id, Name, (SELECT Id, LastName FROM Contacts)
    FROM Account
    WITH USER_MODE
];
```

> [!tip] WITH USER_MODE vs WITH SECURITY_ENFORCED
> - `WITH USER_MODE` (API 57+): CRUD + FLS 검사. 권장 표준.
> - `WITH SECURITY_ENFORCED` (구형): FLS만 검사, 읽기 접근 없는 필드 포함 시 예외.
> - 새 코드는 항상 `WITH USER_MODE` 사용.

---

## SOQL for loop — 힙 한도 + 보안 동시 해결

```apex
// ✅ 대용량 처리 — 200개 청크씩 처리 (힙 한도 방어)
Integer count = 0;
for (Account acct : [SELECT Id, Name FROM Account WITH USER_MODE]) {
    count++;
}

// ✅ 청크 단위 처리 (리스트 버전)
Integer chunkCount = 0;
for (List<Account> chunk : [SELECT Id FROM Account WITH USER_MODE]) {
    chunkCount++;
    // chunk는 최대 200개
}
```

> [!warning] 단순 List 쿼리의 힙 위험
> `List<Account> all = [SELECT ... FROM Account]`는 수천 건이면 힙 한도(6MB) 초과.
> 대용량 처리는 반드시 SOQL for loop 또는 Batch Apex 사용.

---

## 트리거 컨텍스트에서 USER_MODE 생략

```apex
// 트리거에서는 시스템 컨텍스트가 적절한 경우 생략 가능
// PMD 경고는 @SuppressWarnings로 억제
@SuppressWarnings('PMD.ApexCRUDViolation')
public void afterInsert() {
    List<Account> accts = [SELECT Id FROM Account WHERE Id IN :triggerNew];
}
```

---

## 집계 쿼리 패턴

```apex
// COUNT() — AggregateResult 없이 Integer 반환
Integer total = [SELECT COUNT() FROM Account WITH USER_MODE];

// 집계 함수 — AggregateResult 사용
List<AggregateResult> results = [
    SELECT Industry, COUNT(Id) cnt
    FROM Account
    WITH USER_MODE
    GROUP BY Industry
];
for (AggregateResult ar : results) {
    String industry = (String) ar.get('Industry');
    Integer cnt = (Integer) ar.get('cnt');
}
```

---

## 관련 노트

- [[Dynamic SOQL]] — 동적 쿼리
- [[WITH USER_MODE]] — 상세 보안 적용 기준
- [[DML 패턴]]
