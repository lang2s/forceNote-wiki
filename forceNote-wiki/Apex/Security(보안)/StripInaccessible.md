---
tags: [apex, security, fls, strip, pattern]
source: apex-recipes/StripInaccessibleRecipes.cls, AccountServiceLayer.cls
created: 2026-05-17
aliases: [Security.stripInaccessible, FLS 필드 제거]
---

# StripInaccessible

> FLS 권한이 없는 필드를 DML/조회 전에 제거. `Security.stripInaccessible(AccessType, records)`.

---

> [!important] Summer '26 (API v67.0) 파괴적 변경 — USER_MODE 기본값
> v67.0부터 DATABASE 오퍼레이션(SOQL, DML, Database 메서드)의 기본 실행 모드가 **USER_MODE**로 변경됨.
> `with sharing` 클래스에서 단순 SOQL/DML을 쓰는 경우 FLS 검사가 자동 적용되어 `stripInaccessible` 수동 호출이 불필요해진 상황이 많다.
> 단, 아래 "여전히 필요한 경우"를 확인해 누락하지 않도록 주의.

---

## v67.0 이후: USER_MODE vs StripInaccessible 비교

| 항목 | `WITH USER_MODE` / `insert as user` | `Security.stripInaccessible` |
|---|---|---|
| FLS 위반 처리 | 예외 throw (DmlException) | 필드 **제거** 후 계속 진행 |
| 제거된 필드 목록 조회 | ❌ 불가 | ✅ `getRemovedFields()` |
| 서브쿼리 필드 필터링 | ✅ 지원 | ✅ 지원 |
| `System.runAs()` 내부 적용 | 컨텍스트에 따라 다름 | ✅ 항상 명시적 적용 |
| JSON 역직렬화 후 처리 | ❌ 불가 | ✅ 필수 |
| v67.0 기본 동작 | 기본값으로 자동 적용 | 수동 호출 필요 |

---

## 언제 StripInaccessible이 여전히 필요한가?

v67.0에서 USER_MODE가 기본값이 되어도 다음 상황에서는 `stripInaccessible`을 직접 호출해야 한다.

**1. System.runAs() 블록 내부**
```apex
// runAs 블록은 USER_MODE 기본값 적용과 무관하게 명시 필요
System.runAs(testUser) {
    SObjectAccessDecision decision =
        Security.stripInaccessible(AccessType.READABLE, records);
    // decision.getRecords() 사용
}
```

**2. without sharing 클래스에서 의도적으로 FLS 검사할 때**
```apex
// without sharing이지만 특정 메서드에서만 FLS 적용
public without sharing class InternalProcessor {
    public List<Account> getFilteredAccounts() {
        List<Account> raw = [SELECT Id, Name, AnnualRevenue FROM Account];
        // USER_MODE 기본값이 without sharing 클래스에선 적용 안 됨
        return (List<Account>) Security.stripInaccessible(
            AccessType.READABLE, raw
        ).getRecords();
    }
}
```

**3. JSON 역직렬화(Dynamic DML) 결과 처리 시**
```apex
// JSON.deserialize 결과는 USER_MODE 기본값과 무관
List<Account> accounts =
    (List<Account>) JSON.deserialize(jsonText, List<Account>.class);

// stripInaccessible 필수 — 사용자가 권한 없는 필드를 JSON에 포함시킬 수 있음
SObjectAccessDecision decision =
    Security.stripInaccessible(AccessType.UPDATABLE, accounts);
update as user decision.getRecords();
```

**4. 제거된 필드 목록이 비즈니스 로직에 필요할 때**
```apex
SObjectAccessDecision decision =
    Security.stripInaccessible(AccessType.UPDATABLE, accounts);
Map<String, Set<String>> removed = decision.getRemovedFields();
if (!removed.isEmpty()) {
    // 감사 로그, 사용자 알림 등
    AuditLogger.log('FLS 필드 제거됨: ' + removed);
}
```

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
| 단순 DML 보안 (v67.0+) | `insert as user` 또는 USER_MODE 기본값 활용 |
| 제거 필드 감지 필요 | `Safely().throwIfRemovedFields().doInsert()` |
| 쿼리 결과 FLS 필터링 | `stripInaccessible(READABLE, ...)` |
| 사용자 입력 JSON 처리 | `stripInaccessible(UPDATABLE, ...)` → DML |
| without sharing 내 FLS 검사 | `stripInaccessible(...)` 명시적 호출 |

---

## 관련 노트

- [[Safely]]
- [[CanTheUser]]
- [[DML 패턴]]
- [[Custom REST Endpoint]] — POST 바디 처리
- [[Summer '26]]
