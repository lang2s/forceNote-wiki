---
tags: [apex, dml, security, pattern]
source: apex-recipes/DMLRecipes.cls, AccountServiceLayer.cls
created: 2026-05-17
aliases: [DML 보안, insert as user]
---

# DML 패턴

> Apex API 57.0+의 `insert as user/system` 키워드와 `Database.*(AccessLevel)` 패턴. FLS/CRUD를 인라인으로 강제.

---

## DML 접근 모드 선택 기준

| 패턴 | 코드 | 사용 시점 |
|---|---|---|
| `insert as user` | 현재 사용자 CRUD/FLS 적용 | 일반 DML (가장 권장) |
| `insert as system` | 시스템 모드 (CRUD/FLS 무시) | 트리거 핸들러, 플랫폼 자동화 |
| `Database.insert(recs, allOrNothing, AccessLevel.USER_MODE)` | 부분 성공 + FLS | 배치, 부분 실패 허용 시 |
| `Safely.cls` Fluent API | `new Safely().allOrNothing().doInsert(recs)` | throwIfRemovedFields 필요 시 |
| `Security.stripInaccessible` → DML | 필드 단위 제거 후 DML | 사용자 입력 데이터 처리 |

---

## `as user` / `as system` 키워드 (API 57.0+)

```apex
// ✅ 가장 간결한 FLS/CRUD 적용 — 표준 권장
insert as user acct;
update as user accounts;
delete as user contacts;
undelete as user contacts;
upsert as user acct;

// 시스템 모드 (트리거 핸들러 등)
insert as system acct;
update as system accounts;
```

---

## Database.* + AccessLevel (부분 성공 필요 시)

```apex
// allOrNothing=false + USER_MODE — 배치에서 자주 사용
List<Database.SaveResult> results =
    Database.insert(accounts, false, System.AccessLevel.USER_MODE);

// 결과 처리
for (Database.SaveResult sr : results) {
    if (sr.isSuccess()) { /* 성공 Id */ }
    else { /* sr.getErrors() */ }
}

// upsert
Database.upsert(acct, false, AccessLevel.USER_MODE);
Database.update(accts, AccessLevel.USER_MODE);
Database.delete(accts, AccessLevel.USER_MODE);
```

---

## Safely.cls Fluent API (throwIfRemovedFields 필요 시)

```apex
// throwIfRemovedFields: FLS로 제거된 필드가 있으면 예외 throw
new Safely()
    .allOrNothing()
    .throwIfRemovedFields()
    .doInsert(records);

new Safely().doUpdate(accounts);
new Safely().doDelete(contacts);
```

> [!note] Safely vs `as user` 선택 기준
> - 단순 DML → `insert as user` (더 읽기 쉬움)
> - 제거된 필드 감지 필요 → `Safely().throwIfRemovedFields()`
> - 부분 성공 처리 → `Database.insert(recs, false, AccessLevel.USER_MODE)`

---

## stripInaccessible + DML (외부 입력 처리)

```apex
// LWC/REST에서 받은 JSON 역직렬화 후 업데이트
List<Account> accounts = (List<Account>) JSON.deserialize(jsonText, List<Account>.class);

// UPDATABLE 모드로 편집 불가 필드 제거
SObjectAccessDecision decision =
    Security.stripInaccessible(AccessType.UPDATABLE, accounts);

update as user decision.getRecords();
```

> [!warning] JSON 역직렬화 후 반드시 stripInaccessible
> 사용자가 보내온 JSON을 그대로 DML하면 권한 없는 필드까지 수정될 수 있다. 반드시 `stripInaccessible(AccessType.UPDATABLE, ...)` 처리 후 DML.

---

## 관련 노트

- [[Safely]]
- [[StripInaccessible]]
- [[CanTheUser]]
- [[Batch Apex]] — Database.SaveResult 처리
