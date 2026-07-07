---
tags: [apex, soql, security, pattern]
source: apex-recipes/SOQLRecipes.cls
created: 2026-05-17
aliases: [SOQL 보안, USER_MODE SOQL, SOQL for loop, 벌크화, bulkify, 루프 내 SOQL 금지]
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

## 벌크화 원칙 — 루프 안에서 SOQL/DML 금지

거버너 한도는 **트랜잭션당** 적용된다 (SOQL 100회, DML 150 statement). 루프 안에 SOQL·DML을 두면 반복 횟수만큼 호출이 누적돼 대량 레코드에서 한도가 폭발한다. 핵심은 **컬렉션으로 수집 → 루프 밖에서 1회 SOQL/DML**.

### DML 벌크화 — 리스트로 모아 1회 update

```apex
// ❌ 루프마다 update — 151번째에서 DML statement 한도(150) 초과 런타임 예외
for (Line_Item__c li : liList) {
    if (li.Units_Sold__c > 10) {
        li.Description__c = 'New description';
    }
    update li;   // Not a good practice — governor limit
}

// ✅ 리스트에 수집 후 루프 밖에서 1회 벌크 update
List<Line_Item__c> updatedList = new List<Line_Item__c>();
for (Line_Item__c li : liList) {
    if (li.Units_Sold__c > 10) {
        li.Description__c = 'New description';
        updatedList.add(li);
    }
}
update updatedList;   // 전체 리스트를 한 번에 처리
```

### SOQL 벌크화 — Trigger.new 전체를 1회 쿼리

`Trigger.new`의 각 레코드마다 자식 SOQL을 날리면 레코드 200건 = SOQL 200회 → 100회 한도 초과. **관계 서브쿼리** 또는 `IN :Trigger.newMap.keySet()`로 한 번에 조회한다.

```apex
// ❌ Trigger.new 항목마다 SOQL — 100건 넘으면 SOQL 한도 초과
trigger LimitExample on Invoice_Statement__c (before insert, before update) {
    for (Invoice_Statement__c inv : Trigger.new) {
        List<Line_Item__c> liList = [SELECT Id, Units_Sold__c, Merchandise__c
                                     FROM Line_Item__c
                                     WHERE Invoice_Statement__c = :inv.Id];   // 루프마다 실행
        for (Line_Item__c li : liList) { /* Do something */ }
    }
}

// ✅ 서브쿼리로 루프 밖 1회 SOQL — Trigger.new 전체를 한 번에
trigger EnhancedLimitExample on Invoice_Statement__c (before insert, before update) {
    List<Invoice_Statement__c> invoicesWithLineItems =
        [SELECT Id, Description__c, (SELECT Id, Units_Sold__c, Merchandise__c FROM Line_Items__r)
         FROM Invoice_Statement__c
         WHERE Id IN :Trigger.newMap.keySet()];
    for (Invoice_Statement__c inv : invoicesWithLineItems) {
        for (Line_Item__c li : inv.Line_Items__r) { /* Do something */ }
    }
}
```

### Map/Set 관용구 — 벌크 조회 결과를 O(1)로 매칭

루프 밖에서 부모/참조 레코드를 한 번에 쿼리한 뒤 `Map<Id, SObject>`로 담아, 처리 루프에서 키로 즉시 찾는다. 중첩 루프 없이 벌크 매칭이 가능하다.

```apex
// ✅ Set으로 부모 Id 수집 → 1회 SOQL → Map으로 O(1) 조회
Set<Id> acctIds = new Set<Id>();
for (Contact c : Trigger.new) {
    acctIds.add(c.AccountId);
}
Map<Id, Account> acctById = new Map<Id, Account>(
    [SELECT Id, Name FROM Account WHERE Id IN :acctIds WITH USER_MODE]);

for (Contact c : Trigger.new) {
    Account parent = acctById.get(c.AccountId);   // 루프 내 SOQL 없이 매칭
    // parent 사용
}
```

### SOQL for-loop로 힙 절감 (벌크화와 함께)

SOQL for loop는 결과를 **200개 배치**로 청킹해 힙(6MB)을 절약한다. 단, DML을 루프 안에서 써야 한다면 **단일 sObject** 형식이 아니라 **sObject 리스트** 형식(`for (Account[] batch : ...)`)을 써서 배치당 1회 DML로 벌크 처리한다.

```apex
// ✅ 리스트 형식 — 배치(최대 200)마다 1회 DML로 벌크 처리
for (Account[] batch : [SELECT Id, Name FROM Account WITH USER_MODE]) {
    for (Account a : batch) {
        a.Name = a.Name + ' (updated)';
    }
    update batch;   // 배치당 1회 — 단일 sObject 형식이면 레코드마다 1회가 되어 비효율
}
```

> [!note] sObject 리스트 for loop의 DML 한도
> DML은 한 번에 최대 10,000건 처리하고 리스트 for loop는 200건 배치로 순회한다. 반환 레코드당 2건 이상을 insert/update/delete하면 런타임 한도에 걸릴 수 있다. `break`/`continue` 사용 시 리스트 형식의 `continue`는 다음 **배치**로 건너뛴다.

> [!tip] selectivity·인덱싱은 별도 주제
> 벌크화가 "호출 횟수"를 줄이는 원칙이라면, 각 SOQL이 **얼마나 빨리 도는가**(selectivity·인덱스)는 LDV 튜닝 영역이다. → [[대용량 데이터 (LDV) — 쿼리 옵티마이저·인덱싱]] · [[대용량 데이터 (LDV) — 대량 로드·삭제]]

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

## TYPEOF — 다형성 관계 쿼리 (API v46.0+)

다형성 관계 필드(예: Task.What, Event.Who)의 실제 타입에 따라 다른 필드를 가져온다.

```apex
// Task.What은 Account, Opportunity, Case 등 여러 타입이 될 수 있음
List<Task> tasks = [
    SELECT Id, Subject,
        TYPEOF What
            WHEN Account THEN Id, Name, Phone
            WHEN Opportunity THEN Id, Name, CloseDate
            ELSE Id, Name           -- 그 외 타입은 Id, Name만 반환
        END
    FROM Task
    WITH USER_MODE
];
```

---

## FOR UPDATE — 레코드 잠금

트랜잭션 중 다른 사용자/프로세스의 동시 수정을 방지한다.

```apex
// 레코드를 잠그고 업데이트 — 트랜잭션 완료 시 잠금 해제
Account[] accts = [SELECT Id, Name FROM Account
                   WHERE Id IN :targetIds
                   FOR UPDATE];
// 이후 DML 처리
```

> [!warning] `FOR UPDATE`와 `ORDER BY`는 함께 사용 불가.

---

## FOR VIEW / FOR REFERENCE — 최근 열람 기록 업데이트

```apex
// FOR VIEW — LastViewedDate + RecentlyViewed 갱신
SELECT Name, Id FROM Contact LIMIT 1 FOR VIEW

// FOR REFERENCE — LastReferencedDate + RecentlyViewed 갱신
// (관련 레코드를 조회할 때 사용)
SELECT Name, Id FROM Contact LIMIT 1 FOR REFERENCE
```

---

## Aggregate Functions 전체 목록

| 함수 | 설명 | 예시 |
|---|---|---|
| `COUNT()` | 조건 일치 행 수 (null 포함) | `SELECT COUNT() FROM Account` |
| `COUNT(field)` | 특정 필드의 non-null 행 수 | `SELECT COUNT(Id) FROM Account` |
| `COUNT_DISTINCT(field)` | 중복 제거 non-null 값 수 | `SELECT COUNT_DISTINCT(Company) FROM Lead` |
| `SUM(field)` | 합계 | `SELECT SUM(Amount) FROM Opportunity` |
| `AVG(field)` | 평균 | `SELECT AVG(Amount) FROM Opportunity` |
| `MIN(field)` | 최솟값 | `SELECT MIN(CreatedDate) FROM Contact` |
| `MAX(field)` | 최댓값 | `SELECT MAX(Amount) FROM Opportunity` |

> [!note] 모든 집계 함수는 null 값을 무시한다. `COUNT()`와 `COUNT(Id)`만 null 포함.

---

## toLabel() / FORMAT() / GROUPING() / convertTimezone()

```apex
// toLabel() — 피클리스트 값을 사용자 언어로 번역
List<AggregateResult> res = [
    SELECT toLabel(Status), COUNT(Id)
    FROM Case
    GROUP BY Status
    WITH USER_MODE
];

// FORMAT() — 숫자/날짜/통화 필드를 로캘 형식으로 표시
List<Opportunity> opps = [
    SELECT Name, FORMAT(Amount) AmountFormatted,
           FORMAT(CloseDate) CloseDateFormatted
    FROM Opportunity
    WITH USER_MODE
];

// GROUPING() — ROLLUP/CUBE 그룹화에서 소계 행 여부 판별 (1=소계, 0=일반)
List<AggregateResult> rollup = [
    SELECT LeadSource, Rating,
           GROUPING(LeadSource) grpLS,
           GROUPING(Rating) grpRating,
           COUNT(Id) cnt
    FROM Lead
    GROUP BY ROLLUP(LeadSource, Rating)
    WITH USER_MODE
];

// convertTimezone() — 날짜/시간 필드를 사용자 타임존으로 변환
List<AggregateResult> byHour = [
    SELECT HOUR_IN_DAY(convertTimezone(CreatedDate)) hr, COUNT(Id) cnt
    FROM Opportunity
    GROUP BY HOUR_IN_DAY(convertTimezone(CreatedDate))
    WITH USER_MODE
];
```

---

## 관련 노트

- [[SOQL 문법 레퍼런스]] — SELECT 전체 문법, 날짜 리터럴, 관계 쿼리, Object별 제한
- [[Dynamic SOQL]] — 동적 쿼리
- [[WITH USER_MODE]] — 상세 보안 적용 기준
- [[DML 패턴]]
- [[SOSL 패턴]] — 여러 Object 전문 검색
- [[Summer '26]] — API v67.0 파괴적 변경 (WITH SECURITY_ENFORCED 제거)
- [[Summer '26/Development]] — SOQL 기본 USER_MODE / WITH SECURITY_ENFORCED 제거 상세
- [[Spring '26/Development]] — Apex Cursors GA, Automated Process User의 `WITH USER_MODE` 실행(v66.0+)
- [[Summer '24]] — Apex Cursor Beta, 5단계 관계 SOQL
- [[1 Overview]] — Field 타입·API 속성 (Filter·Nillable·Sort 등 SOQL 가용 여부)
- [[6 Standard Objects]] — 표준 Object API 이름·도메인별 카탈로그
- [[Apex Best Practices]] — SOQL for loop 힙 메모리 절약, 루프 내 SOQL 금지 원칙
- [[대용량 데이터 (LDV) — 쿼리 옵티마이저·인덱싱]] — LDV에서 selectivity·인덱스로 효율적 SOQL 작성
- [[대용량 데이터 (LDV) — 대량 로드·삭제]] — 벌크 로드/삭제 시 청킹·PK Chunking·거버너 고려
- [[platform-soql-query]] (sf-skill — 실행형) — 벌크·selectivity SOQL 패턴 작성 실행형 스킬
