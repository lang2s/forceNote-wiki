---
tags: [apex, security, dml, fluent, pattern]
source: apex-recipes/Safely.cls, AccountServiceLayer.cls
created: 2026-05-17
aliases: [Safely.cls, Fluent DML, 안전 DML]
---

# Safely — Fluent DML 보안 래퍼

> `Safely`는 DML 전 FLS/CRUD 검사를 Fluent API로 체이닝하는 유틸리티 클래스. `insert as user` 키워드가 지원하지 않는 **제거 필드 감지**, **부분 성공**, **예외 억제** 등을 제어한다.

---

> [!important] Summer '26 (API v67.0) 파괴적 변경 — sharing 기본값 변경
> v67.0부터 `sharing` 키워드를 선언하지 않은 Apex 클래스는 **`with sharing`으로 기본 동작**한다.
> 의도적으로 sharing을 제거하려면 반드시 `without sharing`을 **명시적으로** 선언해야 한다.
> 암묵적인 sharing 없음 동작에 의존한 기존 코드는 동작이 바뀔 수 있으므로 즉시 점검 필요.

---

## v67.0 이후 sharing 선언 원칙

```apex
// ✅ v67.0 이후 권장 — sharing 의도를 항상 명시
public with sharing class AccountService {
    // 공유 규칙 적용 — 일반적인 서비스 레이어
}

public without sharing class InternalBatchJob {
    // ❗ 의도적으로 without sharing — 명시 필수
    // v67.0 이전: 선언 없으면 without sharing이었음
    // v67.0 이후: 선언 없으면 with sharing으로 동작
}

public inherited sharing class UtilityClass {
    // 호출자의 sharing 컨텍스트 상속 (권장 패턴)
}
```

> [!warning] 기존 sharing 미선언 클래스 점검
> v67.0 마이그레이션 시 `sharing` 키워드가 없는 클래스를 검색해 의도를 확인한다.
> 시스템 모드로 동작해야 한다면 `without sharing`을 즉시 추가.

---

## 기본 구조

```apex
// 삽입 — 모두 성공하거나 전부 롤백
List<Database.SaveResult> results =
    new Safely()
        .allOrNothing()          // 부분 성공 없음 (기본: false)
        .throwIfRemovedFields()  // 제거된 필드 있으면 예외
        .doInsert(records);

// 업데이트
new Safely().doUpdate(records);

// 삭제
new Safely().doDelete(records);

// Upsert
new Safely().doUpsert(records);
```

---

## 체이닝 옵션

| 메서드 | 설명 | 기본값 |
|---|---|---|
| `allOrNothing()` | `Database.*(records, true)` — 부분 실패 시 전체 롤백 | false |
| `throwIfRemovedFields()` | `stripInaccessible` 후 제거된 필드가 있으면 예외 | 억제 |
| `quietMode()` | DML 예외를 throw하지 않고 SaveResult로 반환 | false |

---

## 내부 동작 (stripInaccessible 연동)

```apex
// Safely.doInsert 내부 (개념)
SObjectAccessDecision decision =
    Security.stripInaccessible(AccessType.CREATABLE, records);

if (this.throwIfRemovedFields && !decision.getRemovedFields().isEmpty()) {
    throw new SecurityException('접근 불가 필드: ' + decision.getRemovedFields());
}

return Database.insert(decision.getRecords(), this.allOrNothing);
```

> [!note] insert as user와의 차이
> `insert as user`는 FLS 위반 시 DmlException을 throw. `Safely`는 위반 필드를 **제거**하고 계속 진행 (throwIfRemovedFields 없을 때).

---

## 언제 어떤 방법을 쓸까?

| 상황 | 권장 방법 |
|---|---|
| 단순 insert/update | `insert as user` |
| 부분 성공 핸들링 필요 | `new Safely().doInsert()` |
| 제거 필드 감지 필요 | `new Safely().throwIfRemovedFields().doInsert()` |
| 쿼리 FLS 필터링 | `stripInaccessible(READABLE, ...)` |
| 사용자 JSON 입력 처리 | `stripInaccessible(UPDATABLE, ...)` → DML |

---

## 실제 사용 예 (AccountServiceLayer)

```apex
public with sharing class AccountServiceLayer {

    public static List<Account> safelyCreateAccounts(List<Account> accounts) {
        List<Database.SaveResult> results =
            new Safely()
                .allOrNothing()
                .throwIfRemovedFields()
                .doInsert(accounts);

        List<Account> created = new List<Account>();
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                created.add(accounts[i]);
            }
        }
        return created;
    }
}
```

---

## 관련 노트

- [[StripInaccessible]]
- [[CanTheUser]]
- [[DML 패턴]]
- [[Summer '26]]
