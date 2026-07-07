---
tags: [apex, collection, iterable, iterator, pattern]
source: apex-recipes/IterableAndIteratorRecipes.cls, salesforce_apex_reference_guide.pdf
created: 2026-05-17
aliases: [Iterable, Iterator, 커스텀 반복자]
---

# Iterable / Iterator

> `Iterable<T>`와 `Iterator<T>`를 구현해 커스텀 순회 로직을 `for-each` 루프에서 사용. Batch Apex의 `start()` 반환 타입으로도 활용.

---

## 레퍼런스 — 인터페이스 메서드

두 인터페이스는 역할이 나뉜다. `Iterable<T>`는 **순회 대상(컬렉션)** 이 구현해 "나를 어떻게 돌지"를 반환하고, `Iterator<T>`는 **커서(순회 상태)** 를 들고 다니며 한 항목씩 꺼낸다.

**`Iterator<T>`** — 커서. `hasNext()`/`next()` 두 메서드만 구현하면 된다.

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `hasNext()` | `public Boolean hasNext()` | `Boolean` | 남은 항목이 하나 이상 있으면 `true`, 없으면 `false`. `for-each`/`while` 루프의 계속 조건. |
| `next()` | `public T next()` | `T` | 커서를 다음 항목으로 진행시키며 그 항목을 반환. `hasNext() == false`인데 호출하면 `System.NoSuchElementException`을 던지도록 구현한다(공식 예제 패턴). |

> [!note] Apex `Iterator`에는 `remove()`가 없다
> Java의 `java.util.Iterator`와 달리 **Apex의 `Iterator<T>` 인터페이스는 `hasNext()`·`next()` 두 메서드만 정의한다.** `remove()`는 존재하지 않으므로 구현할 필요도 없고, 순회 중 원소 제거 메서드도 제공되지 않는다. (제거가 필요하면 별도 컬렉션에 남길 항목만 모으는 식으로 처리)

**`Iterable<T>`** — 순회 대상. 커서를 만들어 주는 팩토리 메서드 하나만 구현한다.

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `iterator()` | `public Iterator<T> iterator()` | `Iterator<T>` | 이 컬렉션을 순회할 **새 커서 인스턴스**를 반환. `for-each`가 루프 시작 시 한 번 호출한다. |

> [!warning] `iterator()`는 매번 새 인스턴스를 반환하므로 커서를 변수에 저장해 재사용한다
> 공식 문서(`QueryLocatorIterator`)의 경고: 반복할 때마다 `iterator()`를 새로 호출하면 매번 처음 상태의 커서가 나와 **잘못된 동작**을 일으킨다. `Iterator it = coll.iterator();`로 한 번 받아 그 변수로 `while (it.hasNext()) it.next();` 순회한다.

> [!note] `List`는 이미 `Iterable`이라 `iterator()`를 공짜로 제공
> Apex `List`에는 `public Iterator<T> iterator()`가 내장돼 있다. 즉 `List<Account>`에 직접 `.iterator()`를 호출해 `hasNext`/`next`로 돌 수 있고(인터페이스를 직접 구현하지 않아도 됨), Batch `start()`가 `List`나 `Iterable`을 그대로 반환할 수 있는 것도 이 때문이다.

---

## 왜 Iterable인가 — for-each 프로토콜

Apex의 `for (T x : source)` 루프는 아무 타입이나 도는 게 아니라 **`source`가 순회 프로토콜을 만족할 때**만 동작한다. 내장 `List`/`Set`은 이 프로토콜을 이미 구현하고 있어 그냥 돌지만, **컬렉션이 아닌 대상**(숫자 범위, 외부 API 페이지, CSV 스트림, 트리 순회 등)을 `for-each`로 돌리려면 그 대상이 스스로 프로토콜을 제공해야 한다. 그 프로토콜이 곧 `Iterable<T>`(→ `iterator()`)와 `Iterator<T>`(→ `hasNext()`/`next()`) 두 인터페이스다.

- **커스텀 순회 로직 캡슐화** — 페이지 경계 처리·지연 로딩·필터링 같은 순회 규칙을 `Iterator` 안에 숨기고, 호출부는 `for-each` 한 줄로 소비한다. (아래 페이지네이션 예)
- **지연 평가(lazy)** — 전체를 미리 List로 만들지 않고 `next()`가 호출될 때마다 한 항목씩 생성/로드할 수 있어 힙을 아낀다.
- **소비부-생성부 분리** — 순회 대상이 List든 API든 계산식이든, 소비하는 `for-each` 코드는 동일하게 유지된다.

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

### `start()` 반환 3종 대비

`Batchable.start()`가 돌려줄 수 있는 데이터 소스는 세 형태이고, 상한과 용도가 다르다.

| 반환 타입 | 레코드 상한 | 소스 | 언제 |
|---|---|---|---|
| `Database.QueryLocator` | **50,000,000건** | 단일 SOQL 쿼리 (`Database.getQueryLocator(...)`) | 표준. org의 SObject를 한 쿼리로 긁어 대량 처리 — 상한이 압도적으로 크다. |
| `Iterable<SObject>` | **50,000건** (SOQL 조회 로우 거버너 한도) | 커스텀 `Iterator` — 외부 API 결과, CSV 파싱, 계산된 컬렉션 등 | 쿼리로 표현할 수 없는 동적/비-SObject 소스를 순회할 때. |
| `List<SObject>` | **50,000건** (`Iterable`과 동일) | 미리 만든 리스트 (`List`가 곧 `Iterable`) | 대상이 이미 메모리에 있는 소규모 컬렉션일 때 간편 반환. |

> [!note] Iterable/List vs QueryLocator — 왜 상한이 다른가
> `QueryLocator`는 결과를 DB 커서로 스트리밍하므로 5천만 건까지 가능하다. 반면 `Iterable`·`List`는 컬렉션을 **힙에 올린 채** start가 반환하는 구조라, 이를 채우는 SOQL 조회 로우 한도(50,000건)에 묶인다. 상한이 커야 하면 `QueryLocator`, 쿼리로 못 만드는 동적 소스면 `Iterable`, 소량이면 `List`.

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
- [[Apex 언어 기초 — 제어 흐름과 클래스]] — Iterator/Iterable 인터페이스 구현·클래스 기초

