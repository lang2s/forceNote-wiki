---
tags: [apex, collection, utility, map, set, pattern]
source: apex-recipes/CollectionUtils.cls
created: 2026-05-17
aliases: [CollectionUtils, 컬렉션 유틸리티, Map 조작]
---

# CollectionUtils — 컬렉션 유틸리티 패턴

> Apex 컬렉션 조작 공통 패턴. `Map<Id, SObject>` 구축, 중복 제거, 그룹화 등.

---

## SObject List → Map 변환

```apex
// 가장 흔한 패턴: Id → SObject
List<Account> accounts = [SELECT Id, Name, OwnerId FROM Account];

// 방법 1: new Map<>()
Map<Id, Account> accountMap = new Map<Id, Account>(accounts);

// 방법 2: 수동 구축 (필드 제어 필요 시)
Map<Id, Account> byOwnerId = new Map<Id, Account>();
for (Account a : accounts) {
    byOwnerId.put(a.OwnerId, a);
}

// 방법 3: 그룹화 (1:N 관계)
Map<Id, List<Account>> ownerAccounts = new Map<Id, List<Account>>();
for (Account a : accounts) {
    if (!ownerAccounts.containsKey(a.OwnerId)) {
        ownerAccounts.put(a.OwnerId, new List<Account>());
    }
    ownerAccounts.get(a.OwnerId).add(a);
}
```

---

## Set 연산

```apex
Set<Id> allIds     = new Set<Id>{ id1, id2, id3 };
Set<Id> activeIds  = new Set<Id>{ id2, id3, id4 };

// 교집합 (retainAll)
Set<Id> intersection = allIds.clone();
intersection.retainAll(activeIds); // {id2, id3}

// 차집합 (removeAll)
Set<Id> onlyInAll = allIds.clone();
onlyInAll.removeAll(activeIds); // {id1}

// 합집합 (addAll)
Set<Id> union = allIds.clone();
union.addAll(activeIds); // {id1, id2, id3, id4}
```

---

## 중복 제거

```apex
// SObject 중복 제거 (Id 기준)
List<Account> withDups = ...; // 중복 포함
Map<Id, Account> deduped = new Map<Id, Account>(withDups);
List<Account> unique = deduped.values();

// String 중복 제거
List<String> strs = new List<String>{ 'a', 'b', 'a', 'c' };
Set<String> unique = new Set<String>(strs); // {a, b, c}
List<String> result = new List<String>(unique);
```

---

## 필드 값 추출

```apex
// List<SObject> → Set<Id> (특정 필드 추출)
List<Contact> contacts = [SELECT Id, AccountId FROM Contact];

Set<Id> accountIds = new Set<Id>();
for (Contact c : contacts) {
    if (c.AccountId != null) {
        accountIds.add(c.AccountId);
    }
}

// 추출한 Set으로 관련 레코드 조회
List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
```

---

## 청크 분할 (Governor Limit 대응)

```apex
// 대량 리스트를 청크로 분할
public static List<List<SObject>> chunk(List<SObject> source, Integer chunkSize) {
    List<List<SObject>> chunks = new List<List<SObject>>();
    List<SObject> current = new List<SObject>();

    for (SObject item : source) {
        current.add(item);
        if (current.size() == chunkSize) {
            chunks.add(current);
            current = new List<SObject>();
        }
    }
    if (!current.isEmpty()) {
        chunks.add(current);
    }
    return chunks;
}

// 사용 — SOQL in 절 1000개 제한 대응
for (List<SObject> batch : CollectionUtils.chunk(allRecords, 1000)) {
    // batch로 처리
}
```

---

## Map 안전 접근 패턴

```apex
// null 안전 조회
Map<Id, Account> accountMap = ...;

// 패턴 1: containsKey 먼저
if (accountMap.containsKey(someId)) {
    Account a = accountMap.get(someId);
}

// 패턴 2: null 체크
Account a = accountMap.get(someId);
if (a != null) { ... }

// Apex에서 ?.get() 미지원 — 항상 null 체크 필요
```

---

## 관련 노트

- [[Comparator 인터페이스]]
- [[Iterable Iterator]]
- [[SOQL 패턴]] — Map 활용 쿼리 최적화

