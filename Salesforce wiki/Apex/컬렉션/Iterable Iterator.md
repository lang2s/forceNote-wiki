---
tags: [apex, collection, iterable, iterator, pattern]
source: apex-recipes/IterableAndIteratorRecipes.cls
created: 2026-05-17
aliases: [Iterable, Iterator, 커스텀 반복자]
---

# Iterable / Iterator

> `Iterable<T>`와 `Iterator<T>`를 구현해 커스텀 순회 로직을 `for-each` 루프에서 사용. Batch Apex의 `start()` 반환 타입으로도 활용.

---

## Iterator 구현

```apex
public class NumberIterator implements Iterator<Integer> {
    private Integer current;
    private Integer max;

    public NumberIterator(Integer start, Integer max) {
        this.current = start;
        this.max     = max;
    }

    public Boolean hasNext() {
        return current <= max;
    }

    public Integer next() {
        return current++;
    }
}
```

---

## Iterable 구현

```apex
public class NumberRange implements Iterable<Integer> {
    private Integer start;
    private Integer finish;

    public NumberRange(Integer start, Integer finish) {
        this.start  = start;
        this.finish = finish;
    }

    // for-each 루프에서 호출
    public Iterator<Integer> iterator() {
        return new NumberIterator(start, finish);
    }
}

// 사용
for (Integer n : new NumberRange(1, 5)) {
    System.debug(n); // 1, 2, 3, 4, 5
}
```

---

## Batch Apex에서 Iterable 사용

```apex
// Database.QueryLocator 대신 Iterable<SObject>로 데이터 소스 제공
public class CustomBatch implements Database.Batchable<SObject> {

    public Iterable<SObject> start(Database.BatchableContext ctx) {
        // 외부 API 결과, CSV 파싱 결과 등 동적 소스
        return new CustomSObjectIterable(getExternalData());
    }

    public void execute(Database.BatchableContext ctx, List<SObject> scope) {
        // scope 처리
    }

    public void finish(Database.BatchableContext ctx) {}
}
```

> [!note] Iterable vs QueryLocator
> `QueryLocator`는 최대 50,000,000건까지. `Iterable`은 List<SObject> 기반으로 50,000건 제한이 적용되지만 동적 데이터 소스를 지원.

---

## 실전 예: 페이지네이션 Iterable

```apex
// 대량 외부 API 결과를 페이지 단위로 순회
public class PaginatedApiIterable implements Iterable<Account> {
    private String apiEndpoint;

    public PaginatedApiIterable(String endpoint) {
        this.apiEndpoint = endpoint;
    }

    public Iterator<Account> iterator() {
        return new PaginatedApiIterator(apiEndpoint);
    }
}

public class PaginatedApiIterator implements Iterator<Account> {
    private List<Account> currentPage = new List<Account>();
    private Integer pageIndex = 0;
    private String nextPageUrl;

    // hasNext(), next() 구현에서 페이지 경계 처리...
    public Boolean hasNext() {
        return pageIndex < currentPage.size() || nextPageUrl != null;
    }

    public Account next() {
        if (pageIndex >= currentPage.size()) {
            loadNextPage();
        }
        return currentPage[pageIndex++];
    }

    private void loadNextPage() {
        // HTTP callout으로 다음 페이지 로드
    }
}
```

---

## 관련 노트

- [[Comparator 인터페이스]]
- [[Batch Apex]]
- [[CollectionUtils]]

