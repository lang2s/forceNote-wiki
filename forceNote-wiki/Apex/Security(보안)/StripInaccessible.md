---
tags: [apex, security, fls, strip, pattern]
source: apex-recipes/StripInaccessibleRecipes.cls, AccountServiceLayer.cls
created: 2026-05-17
aliases: [Security.stripInaccessible, FLS 필드 제거]
---

# StripInaccessible

> FLS 권한이 없는 필드를 DML/조회 전에 제거. `Security.stripInaccessible(AccessType, records)`.

---

## AccessType 종류와 선택 기준

| AccessType | 사용 시점 | 설명 |
|---|---|---|
| `READABLE` | 쿼리 결과 반환 전 | 읽기 권한 없는 필드 제거 |
| `CREATABLE` | insert 전 | 생성 권한 없는 필드 제거 |
| `UPDATABLE` | update 전 | 수정 권한 없는 필드 제거 |
| `UPSERTABLE` | upsert 전 | 생성/수정 권한 없는 필드 제거 |

---

## 패턴 1: READABLE — 쿼리 결과 필터링

```apex
// 읽기 권한 없는 필드를 제거한 후 반환
SObjectAccessDecision decision = Security.stripInaccessible(
    AccessType.READABLE,
    [SELECT Id, Name, BudgetedCost, ActualCost FROM Campaign WITH USER_MODE]
);
return (List<Campaign>) decision.getRecords();
```

---

## 패턴 2: 서브쿼리 포함 (부모+자식 모두 필터링)

```apex
SObjectAccessDecision decision = Security.stripInaccessible(
    AccessType.READABLE,
    [
        SELECT Id, Name, Phone,
               (SELECT LastName, Email FROM Contacts)
        FROM Account
        WITH USER_MODE
    ]
);
// 부모 Account의 권한 없는 필드 + 자식 Contact의 권한 없는 필드 모두 제거
return (List<Account>) decision.getRecords();
```

---

## 패턴 3: UPDATABLE — JSON 역직렬화 후 update (중요!)

```apex
// LWC/REST에서 받은 JSON을 update할 때 필수
List<Account> accounts =
    (List<Account>) JSON.deserialize(jsonText, List<Account>.class);

SObjectAccessDecision decision =
    Security.stripInaccessible(AccessType.UPDATABLE, accounts);

update as user decision.getRecords();
```

> [!warning] 사용자 입력 JSON은 반드시 stripInaccessible
> 사용자가 클라이언트에서 수정 권한 없는 필드를 JSON에 포함해 보낼 수 있다. `stripInaccessible(UPDATABLE)`로 제거하지 않으면 권한 없는 필드까지 업데이트된다.

---

## 패턴 4: CREATABLE — insert 전 처리

```apex
SObjectAccessDecision decision =
    Security.stripInaccessible(AccessType.CREATABLE, contacts);
insert decision.getRecords();
```

---

## 패턴 5: 제거된 필드 감지

```apex
SObjectAccessDecision decision =
    Security.stripInaccessible(AccessType.UPDATABLE, accounts);

// 어떤 필드가 제거됐는지 확인
Map<String, Set<String>> removedFields = decision.getRemovedFields();
if (!removedFields.isEmpty()) {
    // Safely().throwIfRemovedFields()와 동일한 효과를 수동으로 구현
    throw new SecurityException('접근 불가 필드 포함: ' + removedFields);
}
```

---

## 패턴 6: CRUD + FLS 동시 검사 (세 번째 인수 true)

```apex
// 세 번째 인수 true = CRUD 검사도 함께
Security.stripInaccessible(AccessType.READABLE, records, true);
```

---

## Safely.cls와의 관계

| 상황 | 권장 |
|---|---|
| 단순 DML 보안 | `insert as user` 키워드 |
| 제거 필드 감지 필요 | `Safely().throwIfRemovedFields().doInsert()` |
| 쿼리 결과 FLS 필터링 | `stripInaccessible(READABLE, ...)` |
| 사용자 입력 JSON 처리 | `stripInaccessible(UPDATABLE, ...)` → DML |

---

## 관련 노트

- [[Safely]]
- [[CanTheUser]]
- [[DML 패턴]]
- [[Custom REST Endpoint]] — POST 바디 처리
