---
tags: [apex, test, sosl, search]
source: apex-recipes
created: 2026-05-17
aliases: [SOSL 테스트, Test.setFixedSearchResults]
---

# SOSL 테스트 패턴

> SOSL은 테스트 환경에서 결과를 반환하지 않음. `Test.setFixedSearchResults()`로 픽스처 주입.

---

## 문제

```apex
// SOSL은 테스트에서 빈 결과 반환 → 커버리지 누락
List<List<SObject>> results = [FIND :searchTerm IN ALL FIELDS RETURNING Account, Contact];
// results[0].size() == 0 (항상)
```

---

## 해결 — Test.setFixedSearchResults()

```apex
@IsTest
static void testSearch() {
    Account acc = new Account(Name = 'Test Corp');
    insert acc;

    // SOSL 실행 전 픽스처 설정
    Test.setFixedSearchResults(new List<Id>{ acc.Id });

    // 이제 SOSL이 위 Id 목록을 반환
    List<List<SObject>> results = [
        FIND 'Test' IN ALL FIELDS RETURNING Account(Id, Name)
    ];

    Assert.areEqual(1, results[0].size());
    Assert.areEqual('Test Corp', ((Account) results[0][0]).Name);
}
```

---

## 주의사항

- `setFixedSearchResults`는 테스트 메서드당 한 번만 설정 가능
- `Id` 목록만 전달 — 실제 필드 값은 SOQL로 조회됨
- 여러 오브젝트 타입 반환 시 Id 목록에 혼합 가능

---

## 관련 노트

- [[테스트 전략]]
- [[HttpCalloutMock]]
- [[StubProvider]]
