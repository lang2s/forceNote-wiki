---
tags: [apex, soql, security, pattern]
source: apex-recipes/SOQLRecipes.cls
created: 2026-05-17
aliases: [SOQL 보안, USER_MODE SOQL, SOQL for loop]
---

# SOQL 패턴

> WITH USER_MODE 일관 적용, SOQL for loop로 힙 한도 방어.

---

## WITH USER_MODE — 모든 SOQL의 기본

> [!important] **Summer '26 (API v67.0) 파괴적 변경**
> - API v67.0부터 SOQL 기본 실행 모드가 **USER_MODE**로 변경.
> - `WITH SECURITY_ENFORCED`는 v67.0에서 **컴파일 오류** 발생 → `WITH USER_MODE`로 교체 필수.
> - `Database.query()` 메서드도 기본 USER_MODE 적용.

```apex
// ❌ v67.0에서 컴파일 오류 — WITH SECURITY_ENFORCED 제거됨
List<Account> accs = [SELECT Id FROM Account WITH SECURITY_ENFORCED];

// ✅ v67.0+ 권장 — WITH USER_MODE 명시
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

// ✅ Database.query()도 USER_MODE 명시
List<Account> accs = Database.query('SELECT Id FROM Account', AccessLevel.USER_MODE);
```

> [!tip] WITH USER_MODE vs WITH SECURITY_ENFORCED
> - `WITH USER_MODE` (API 57+): CRUD + FLS 검사. 권장 표준.
> - `WITH SECURITY_ENFORCED` (구형, **v67.0에서 컴파일 오류**): FLS만 검사, 읽기 접근 없는 필드 포함 시 예외.
> - v67.0 이전 코드베이스는 `WITH SECURITY_ENFORCED` → `WITH USER_MODE` 일괄 교체 필요.

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

## 5단계 부모-자식 관계 SOQL (Summer '24)

Summer '24부터 부모-자식 관계 탐색 깊이가 최대 **5단계**까지 지원된다.

```apex
// ✅ Summer '24+ — 5단계 부모-자식 관계 탐색 예시
List<Account> deep = [
    SELECT Id, Name,
        (SELECT Id, LastName,
            (SELECT Id, Subject FROM Cases)
         FROM Contacts)
    FROM Account
    WITH USER_MODE
];
```

---

## Apex Cursor — 대용량 SOQL 처리 (Summer '24 Beta)

`Database.getCursor()`로 최대 **5천만 행**까지 처리 가능. Batch Apex 없이 대용량 데이터 순회 대안.

```apex
// ✅ Summer '24 Beta — Database.getCursor()
Database.Cursor cursor = Database.getCursor(
    'SELECT Id, Name FROM Account WITH USER_MODE',
    AccessLevel.USER_MODE
);

Integer fetched = 0;
while (cursor.hasNext()) {
    List<Account> chunk = (List<Account>) cursor.fetch(200);
    fetched += chunk.size();
    // 청크 처리 로직
}
cursor.close();
```

> [!note] Apex Cursor vs SOQL for loop vs Batch Apex
> - **SOQL for loop**: 50,000행 이하, 단순 순회. 힙 안전.
> - **Apex Cursor (Summer '24 Beta)**: 5천만 행까지, 커서 방식 순회. 단일 트랜잭션.
> - **Batch Apex**: 트랜잭션 분리 필요, 비동기 처리.

---

## 관련 노트

- [[Dynamic SOQL]] — 동적 쿼리
- [[WITH USER_MODE]] — 상세 보안 적용 기준
- [[DML 패턴]]
- [[Summer '26]] — API v67.0 파괴적 변경 (WITH SECURITY_ENFORCED 제거)
- [[Summer '24]] — Apex Cursor Beta, 5단계 관계 SOQL
