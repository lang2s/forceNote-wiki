---
tags: [apex, dml, security, pattern]
source: apex-recipes/DMLRecipes.cls, AccountServiceLayer.cls
created: 2026-05-17
aliases: [DML 보안, insert as user, upsert 의미론, isCreated, External Id 매칭, merge 재부모, getUpdatedRelatedIds, DML 거버너 한도]
---

# DML 패턴

> Apex API 57.0+의 `insert as user/system` 키워드와 `Database.*(AccessLevel)` 패턴. FLS/CRUD를 인라인으로 강제.

---

## 개념

### 왜 DML 접근 모드가 중요한가

Apex DML(`insert`, `update`, `delete` 등)은 기본적으로 시스템 컨텍스트에서 실행된다. 이는 클래스에 `with sharing`이 선언되어 있어도 동일하다 — `with sharing`은 **레코드 가시성(공유 규칙)**에만 영향을 주며, DML 실행 시 FLS나 CRUD 권한 확인은 하지 않는다.

따라서 별도의 처리 없이 Apex DML을 수행하면, 사용자가 특정 오브젝트에 Create 권한이 없거나 특정 필드에 접근 권한이 없어도 DML이 성공적으로 실행된다. 이는 **권한 초과(privilege escalation)** 문제이며, Salesforce Security Review의 주요 지적 사항이다.

API 57.0(Summer '23)에서 `insert as user` 키워드와 `Database.*(AccessLevel)` 파라미터가 도입되어, DML 선언 지점에서 직접 접근 모드를 명시할 수 있게 되었다. v67.0(Summer '26)부터는 **DML 기본 모드 자체가 USER_MODE**로 변경된다.

### 언제 어떤 모드를 선택하는가

- **일반 서비스 레이어, @AuraEnabled, REST**: `insert as user` — 가장 간결하고 명확
- **트리거 핸들러, 플랫폼 자동화, 배치**: `insert as system` 또는 `Database.insert(recs, AccessLevel.SYSTEM_MODE)` — 자동화 컨텍스트에서 사용자 권한과 무관하게 작동해야 할 때
- **부분 성공(Partial Success) 처리**: `Database.insert(recs, false, AccessLevel.USER_MODE)` — 배치처럼 일부 레코드 실패를 허용하고 성공 레코드만 처리해야 할 때
- **FLS 위반 필드 감지 필요**: `Safely().throwIfRemovedFields().doInsert()` — 어떤 필드가 제거되었는지 알아야 할 때
- **외부 입력(JSON) 처리**: `Security.stripInaccessible()` → DML — 사용자가 보낸 데이터를 그대로 DML하기 전 접근 불가 필드를 반드시 제거

---

## DML 기본 연산 의미론

접근 모드(as user/system)와 별개로, 각 DML 연산이 **레코드를 어떻게 매칭·연결·병합하는지**의 규칙이다. 접근 모드를 정확히 걸어도 아래 의미론을 모르면 잘못된 레코드가 생성·병합된다.

### insert — 관계/외래키 채우기와 순서

insert는 새 레코드를 커밋하고 각 sObject 변수에 ID를 채운다. 자식이 부모를 참조하려면 부모 ID 또는 **External Id 외래키**를 지정한다. 부모 ID를 미리 모를 때는 관계 필드에 부모 sObject 참조를 직접 꽂거나, 부모의 External Id만 담은 참조용 sObject를 외래키로 쓴다.

```apex
// 기존 부모를 External Id 외래키로 참조 — 조회 없이 관계 연결
// (Account에 MyExtID__c External Id 필드가 있고, MyExtID__c='SAP111111' 레코드가 존재)
Opportunity newOpp = new Opportunity(
    Name='OpportunityWithAccountInsert',
    StageName='Prospecting',
    CloseDate=Date.today().addDays(7));
// 외래키 참조 전용 sObject — External Id 외엔 아무 필드도 세팅하지 않는다
Account accountReference = new Account(MyExtID__c='SAP111111');
newOpp.Account = accountReference;      // 관계 필드에 참조 sObject를 꽂는다
insert as user newOpp;
```

- **부모·자식을 한 문장에 생성** (외래키 single-statement): 배열의 **부모 인덱스가 자식보다 앞서야** 한다(부모 index < 자식 index). 최대 **10 레벨** 깊이까지, 단일 호출 내 관련 레코드는 서로 **다른 sObject 타입**이어야 한다.
- 부분 롤백 후 sObject 변수에 ID가 남아 있으면(insert 성공 후 후속 오류로 롤백) 같은 변수로 재-insert 시 오류가 난다 — ID가 이미 채워졌기 때문. 이땐 update/upsert로 전환한다.

### upsert — External Id 매칭과 `isCreated()`

upsert는 하나의 호출로 insert 또는 update를 결정한다. 매칭 키는 **레코드 ID**, 또는 **커스텀 External Id 필드**, 또는 `idLookup` 속성이 true인 표준 필드다. `upsert assets Line_Item_ID__c;` 처럼 매칭 필드를 명시할 수 있다.

| 키 매칭 결과 | 동작 |
|---|---|
| 매칭 **0건** (키 불일치) | 새 레코드 **insert** |
| 매칭 **1건** | 기존 레코드 **update** |
| 매칭 **다수** | 오류 발생 — 해당 레코드는 insert도 update도 되지 않음 |

```apex
// Database.upsert(부분성공) 결과에서 isCreated()로 신규 레코드만 골라 후속 처리
List<Database.UpsertResult> uResults = Database.upsert(leads, false, AccessLevel.USER_MODE);
List<Task> tasks = new List<Task>();
for (Database.UpsertResult r : uResults) {
    if (r.isSuccess() && r.isCreated())   // isCreated()=true → insert됨 (update가 아님)
        tasks.add(new Task(Subject='Follow-up', WhoId=r.getId()));
}
insert as user tasks;
```

- `UpsertResult.isCreated()` — 이 레코드가 **새로 생성**됐으면 true, 기존 레코드 **update**면 false. insert된 레코드에만 후속 작업(예: Task 생성)을 걸 때 쓴다.
- **External Id 매칭 주의**: upsert에 쓰는 External Id 필드는 **Unique**여야 하거나, 사용자가 **View All Data** 권한을 가져야 한다. 커스텀 필드 매칭은 필드 정의에서 "Unique + 대소문자 무시(Treat ABC and abc as duplicates)"를 켠 경우에만 대소문자 무시("ABC123"과 "abc123" 매칭)다.
- 각 upsert는 내부적으로 insert + update **두 연산**으로 나뉘어 거버너 한도에 각각 계산된다(아래 거버너 한도 참조).

### merge — 마스터 유지·자식 재부모·`getUpdatedRelatedIds()`

중복 정리용. **lead·contact·case·account** 4종만 병합 가능하며, 한 호출에 **메인(마스터) 레코드 1건 + 추가 최대 2건 = 총 3건**까지. 병합은 중복 레코드를 메인에 합치고, 중복 레코드를 삭제하며, 관련 자식 레코드를 메인으로 **재부모(reparent)** 한다.

```apex
// merge 문 — 중복 계정을 메인 계정으로 병합 (자식 Contact이 메인으로 이동)
merge as user mainAcct dupAcct;

// Database.merge(부분성공) — 재부모된 자식 ID를 getUpdatedRelatedIds()로 확인
Database.MergeResult[] results = Database.merge(main, duplicates, false);
for (Database.MergeResult res : results) {
    if (res.isSuccess())
        System.debug('재부모된 자식 ID: ' + res.getUpdatedRelatedIds());
}
```

- **마스터 필드가 항상 우선**: 메인 레코드의 필드값(null·빈 값 포함)이 항상 중복 레코드 값을 덮어쓴다. 메인의 필드가 비어 있으면 병합 후에도 비어 있다 — 중복 쪽 값을 살리려면 **병합 전에 메인 레코드에 그 값을 직접 세팅**한다.
- `MergeResult.getUpdatedRelatedIds()` — 이번 병합으로 **재부모된 자식 레코드 ID 목록**을 반환.
- **External Id 필드는 merge에 쓸 수 없다.**
- 트리거 관점: merge는 자체 트리거 이벤트가 없다 — 패자(중복) 레코드에 대해 **단일 delete 이벤트**, 승자(메인)에 대해 **단일 update 이벤트**를 발생시킨다. 재부모된 자식은 트리거를 발생시키지 않는다. 패자의 `MasterRecordId`(Trigger.old)로 승자 ID를 식별한다.
- undelete로 병합 시 삭제된 레코드를 복원할 수 있으나, **재부모(자식 이동)는 되돌릴 수 없다.**

### 거버너 한도 요약

DML은 트랜잭션당 두 축의 한도를 가진다. 컬렉션(List)을 한 번에 DML해서 문(statement) 수를 아낀다.

| 한도 | 값 | 계산 방식 |
|---|---|---|
| DML **문(statement) 수** | 트랜잭션당 **150** | `insert list;` 1회 = 문 1개 (리스트 크기 무관) |
| DML **처리 행(row) 수** | 트랜잭션당 **10,000** | 모든 DML 호출의 처리 행 누적. 예) 100건 insert + 50건 update = 150행, 남은 9,850행 |

upsert는 insert·update 두 연산으로 각각 행 한도에 계산되므로, 10,000행 초과 시 상황에 따라 insert 또는 update 쪽에서 한도 예외가 난다. External Id upsert로 조회+DML을 한 문장에 합치면 문 수를 아낀다. 상세·전체 한도표는 [[Governor Limits]].

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

> [!important] **Summer '26 (API v67.0) 파괴적 변경**
> - API v67.0부터 DML 기본 실행 모드가 **USER_MODE**로 변경.
> - `insert as user`, `update as user` 등 DML 접근 레벨 명시 구문 권장.
> - `Database.insert()`, `Database.update()` 등 Database 메서드도 기본 USER_MODE 적용.

```apex
// ✅ v67.0+ 권장 — 명시적 user mode DML
insert as user new Account(Name = 'Test');
update as user accounts;
delete as user [SELECT Id FROM Contact WHERE AccountId = :accId];
undelete as user contacts;
upsert as user acct;

// 시스템 모드 (트리거 핸들러, 플랫폼 자동화 등 명시적 필요 시)
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

// ✅ v67.0+ — SYSTEM_MODE 명시도 가능 (의도 명확화)
Database.insert(new Account(Name = 'Test'), AccessLevel.USER_MODE);
Database.insert(new Account(Name = 'Test'), AccessLevel.SYSTEM_MODE);
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
- [[WITH USER_MODE]] — AccessLevel 열거형 상세
- [[Database Namespace 상세]] — UpsertResult·MergeResult·SaveResult 등 Database 메서드 결과 클래스 전수
- [[Governor Limits]] — DML 문 수(150)·행 수(10,000) 등 전체 거버너 한도표
- [[4 Custom Objects]] — __c 표준 필드 목록 (DML 대상 필드 참조)
- [[Batch Apex]] — Database.SaveResult 처리
- [[Summer '26]] — API v67.0 DML 기본 모드 USER_MODE 변경
- [[Summer '26/Development]] — DML 기본 user mode / `insert as user` 상세 (파괴적 변경 ①)
- [[platform-data-manage]] (sf-skill — 실행형) — 레코드 CRUD·bulk DML 실행형 스킬
- [[Mixed DML 제약과 우회]] — setup 오브젝트와 일반 오브젝트를 같은 트랜잭션에서 DML 못 하는 제약 상세
