---
tags: [apex, security, dml, fluent, pattern]
source: apex-recipes/Safely.cls, AccountServiceLayer.cls
created: 2026-05-17
aliases: [Safely.cls, Fluent DML, 안전 DML]
---

# Safely — Fluent DML 보안 래퍼

> `Safely`는 DML 전 FLS/CRUD 검사를 Fluent API로 체이닝하는 유틸리티 클래스. `insert as user` 키워드가 지원하지 않는 **제거 필드 감지**, **부분 성공**, **예외 억제** 등을 제어한다.

---

## 개념

`insert as user`(API 57.0+)는 FLS 위반 시 즉시 `DmlException`을 던진다. 이는 단순한 경우에는 충분하지만, 다음과 같은 요구사항에서는 한계가 있다.

- **어떤 필드가 제거되었는지 알고 싶다**: `insert as user`는 예외만 던질 뿐, 어떤 필드가 FLS 위반인지 상세 정보를 제공하지 않는다
- **FLS 위반 필드를 제거하고 나머지는 계속 처리하고 싶다**: `insert as user`는 위반 즉시 전체를 중단하지만, `Safely`는 `Security.stripInaccessible()`로 접근 불가 필드를 제거한 뒤 DML을 계속 진행한다
- **부분 성공(Partial Success)을 핸들링하고 싶다**: 배치 DML에서 일부 레코드만 성공하고 나머지는 실패하는 경우, `Database.insert(recs, false, AccessLevel.USER_MODE)` 또는 `Safely`의 결과(`List<Database.SaveResult>`)로 각 레코드 성공 여부를 확인해야 한다
- **예외를 억제하고 결과만 받고 싶다**: `quietMode()`를 체이닝하면 DML 예외 없이 SaveResult 목록으로 결과를 받는다

`Safely`는 `apex-recipes`에서 제공하는 유틸리티 클래스로, 프로젝트 내에 직접 포함해 사용하는 패턴이다. Salesforce 표준 라이브러리가 아니므로, 사용 전 프로젝트 코드베이스에 `Safely.cls`가 존재하는지 확인해야 한다.

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
