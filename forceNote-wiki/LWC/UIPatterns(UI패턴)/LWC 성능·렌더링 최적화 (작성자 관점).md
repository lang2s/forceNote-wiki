---
tags: [lwc, performance, rendering, optimization, rerender, foreach, key, lazy-loading, wire, imperative, debounce, renderedcallback]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Performance Best Practices / Improve Runtime Performance; 라이브 공식 문서, Tier 2, 접속 2026-07-08)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/perf-best-practices.html
created: 2026-07-08
aliases: [LWC 성능, LWC performance, 렌더링 최적화, rendering optimization, 불필요 재렌더, unnecessary rerender, for:each key, lazy loading, 지연 로딩, 조건부 렌더, 동적 import, dynamic import, wire vs imperative, 병렬 로딩, parallel loading, debounce, 디바운스, renderedCallback 성능, getter 캐싱, 초기 페인트]
---

# LWC 성능·렌더링 최적화 (작성자 관점)

> 컴포넌트 **작성자가 직접 통제할 수 있는** 성능 레버 — 불필요 재렌더 회피, `for:each` key, lazy 로딩, `@wire` vs imperative 로딩 타이밍, 무거운 계산 회피 — 를 모은 실무 가이드. 엔진이 자동으로 해주는 최적화(정적 콘텐츠 hoisting 등)와는 구분한다. (엔진 자동 최적화는 [[LWC 오픈소스 아키텍처]]에 위임.)

---

## 작성자 레버 vs 엔진 자동 최적화 — 경계

성능을 나누는 두 축을 먼저 구분한다. 이 노트는 **왼쪽(작성자가 코드로 통제)** 만 다룬다.

| 축 | 누가 통제하나 | 예 | 이 노트에서 |
|---|---|---|---|
| 작성자 레버 | 개발자 코드 | 재렌더 최소화, key, lazy import, 로딩 타이밍, debounce | ✅ 다룸 |
| 엔진 자동 최적화 | LWC 컴파일러·런타임 | 정적 콘텐츠 hoisting, static content optimization, VDOM diff | ❌ [[LWC 오픈소스 아키텍처]]에 위임 |

즉 정적 마크업(변하지 않는 DOM)은 컴파일러가 이미 최적화하므로 손댈 필요 없다. 작성자가 신경 쓸 것은 **동적으로 바뀌는 부분을 얼마나 자주·얼마나 무겁게 재계산·재렌더하느냐**다.

---

## 1. 불필요한 재렌더 회피

재렌더는 "반응형 필드가 바뀌었다"는 신호에서 시작된다(트리거 규칙은 [[LWC 리액티비티 (반응형 필드·재렌더 트리거)]]). 성능 관점의 목표는 **바뀌지 않아도 되는 필드를 건드리지 않는 것**이다.

### 반응형 필드 mutation 최소화

```javascript
// 구조 예시 — 실제 동작 코드 아님
// ❌ 매 호출마다 새 배열/객체를 만들어 재렌더를 유발
handleTick() {
    this.rows = [...this.rows];        // 내용이 같아도 새 참조 → 재렌더
    this.meta = { ...this.meta };      // 불필요한 재할당
}

// ✅ 실제로 값이 바뀔 때만 재할당
handleTick(newRows) {
    if (this.hasChanged(newRows)) {
        this.rows = newRows;           // 변경이 있을 때만 새 참조
    }
}
```

- 원시값은 동일 값(`===`)을 재할당하면 엔진이 재렌더를 스킵한다. 하지만 객체·배열은 **새 참조면 무조건 dirty**로 표시되므로, "그냥 새로 만들어 넣는" 습관이 잦은 재렌더를 만든다.
- 큰 리스트를 통째로 교체하는 대신, 바뀐 항목만 갈아끼우는 immutable map 패턴을 쓴다(리액티비티 노트의 관용구 참조).
- 템플릿에서 **쓰이지 않는 필드**는 반응형이어도 재렌더에 영향을 주지 않는다 — 단, getter가 그 필드를 참조하면 연쇄된다(아래 getter 항목).

### getter 비용과 "캐싱"

getter는 렌더 파이프라인에서 호출되며, 참조하는 반응형 필드가 바뀌면 **다음 렌더마다 다시 실행**된다(자동 재계산 규칙은 리액티비티 노트). 무거운 getter는 렌더할 때마다 비용을 낸다.

```javascript
// 구조 예시 — 실제 동작 코드 아님
export default class Report extends LightningElement {
    rawRows = [];
    _sortedCache = null;
    _cacheKey = null;

    // ❌ 렌더마다 정렬 — rawRows가 안 바뀌어도 매번 O(n log n)
    get sortedRowsNaive() {
        return [...this.rawRows].sort(compareFn);
    }

    // ✅ 입력이 바뀔 때만 재계산 (memoize)
    get sortedRows() {
        if (this._cacheKey !== this.rawRows) {   // 참조가 그대로면 캐시 재사용
            this._sortedCache = [...this.rawRows].sort(compareFn);
            this._cacheKey = this.rawRows;
        }
        return this._sortedCache;
    }
}
```

- getter는 **순수 계산만** 둔다 — 부수효과·비동기 금지(예측 불가·중복 실행).
- 정렬·필터·집계처럼 비용이 큰 변환은 getter 안에서 매번 하지 말고, 입력 참조를 key로 memoize하거나, 데이터가 갱신되는 시점(핸들러·wire 콜백)에 미리 계산해 필드에 저장한다.
- getter가 여러 반응형 필드를 참조하면, 그중 **하나만 바뀌어도** 전체가 재실행된다. 자주 바뀌는 값과 무거운 계산을 같은 getter에 묶지 않는다.

---

## 2. `for:each`의 key — 리스트 재조정 효율

리스트를 렌더할 때 각 항목에 **고유하고 안정적인 `key`** 를 주면, 재렌더 시 엔진이 어떤 DOM 요소를 재사용·이동·제거할지 정확히 판단한다. key가 부실하면 엔진이 요소를 잘못 재사용하거나 불필요하게 재생성한다.

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<template>
    <ul>
        <template for:each={items} for:item="item">
            <li key={item.id}>{item.label}</li>   <!-- ✅ 안정적 고유 ID -->
        </template>
    </ul>
</template>
```

**key 규칙 (성능·정확성 양쪽):**

| 규칙 | 이유 |
|---|---|
| key는 **데이터에서 나온 고유값**(레코드 Id 등) | 항목이 재정렬·삽입·삭제돼도 엔진이 동일 항목을 추적 |
| **배열 index를 key로 쓰지 말 것** | 순서가 바뀌면 index가 다른 항목을 가리켜 잘못된 재사용·상태 꼬임 |
| key는 iterator의 **직속 자식 요소**에 부여 | 엔진이 각 반복 단위를 식별하는 지점 |
| key는 렌더 간 **안정적**이어야 함 | 매번 새로 생성되는 값(랜덤·타임스탬프) 금지 |

- `for:each`로 만든 요소의 재사용 여부는 `key`가 결정한다(`<slot>` content는 diffing 알고리즘이 결정 — [[Lifecycle Hooks]]의 요소 재사용 예외 참조).
- 큰 리스트에서 매 갱신마다 배열을 통째로 새로 만들면, key가 정확해도 DOM diff 비용은 항목 수에 비례한다. **바뀐 항목만 교체**하는 immutable 갱신이 diff 범위를 좁힌다.

---

## 3. Lazy 로딩 — 초기 페인트 최적화

초기 렌더에 꼭 필요 없는 것은 **미루면** 첫 페인트가 빨라진다. 두 가지 수단이 있다.

### 조건부 렌더 (`lwc:if`)

무거운 하위 트리를 처음부터 그리지 말고, 필요할 때만 조건을 켠다.

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<template>
    <lightning-button label="Show details" onclick={reveal}></lightning-button>

    <!-- details 트리는 showDetails가 true가 될 때까지 아예 렌더 안 함 -->
    <template lwc:if={showDetails}>
        <c-heavy-chart data={chartData}></c-heavy-chart>
    </template>
</template>
```

- `lwc:if`가 false인 동안 그 안의 컴포넌트는 **생성·렌더되지 않는다** — constructor/connectedCallback도 실행되지 않으므로 초기 비용에서 완전히 빠진다.
- 탭·아코디언처럼 한 번에 하나만 보이는 UI에서 특히 효과적이다.

### 동적 import (코드 스플리팅)

무거운 모듈을 초기 번들에서 빼고, 실제로 필요할 때 `import()`로 불러온다.

```javascript
// 구조 예시 — 실제 동작 코드 아님
// 정적 import: 컴포넌트 로드 시 항상 함께 로드됨
// import HeavyLib from 'c/heavyLib';

async openEditor() {
    // 동적 import: 이 코드가 실행될 때 비로소 모듈을 로드
    const { default: HeavyLib } = await import('c/heavyLib');
    this.editor = new HeavyLib();
}
```

- 동적 import는 초기 로드 payload를 줄여 **첫 상호작용까지의 시간(TTI)** 을 개선한다.
- 조건부 렌더와 결합하면(사용자가 버튼을 누를 때 컴포넌트를 lwc:if로 켜고 그 안에서 무거운 라이브러리를 동적 import) 초기 페인트에서 완전히 제외된다.
- Static Resource로 실은 서드파티 라이브러리도 `renderedCallback`의 1회성 패턴으로 필요 시점에 로드한다([[Static Resource 로딩]]).

---

## 4. `@wire` vs imperative — 데이터 로딩 타이밍

데이터를 언제·어떻게 부르느냐가 초기 렌더 체감 속도를 좌우한다.

| 방식 | 로딩 시점 | 재실행 | 성능 관점 |
|---|---|---|---|
| `@wire` (property/function) | 컴포넌트 초기화 시 자동, config 반응형으로 재실행 | reactive config 변경 시 자동 | 선언적·캐시(LDS) 활용 — **읽기 전용 초기 데이터**에 최적 |
| imperative (Apex/`refreshApex`) | 개발자가 호출한 시점 | 명시적 호출 | 사용자 액션 후·조건부 로딩·순서 제어에 적합 |

### 초기 데이터는 `@wire`로 조기 시작

`@wire`는 컴포넌트가 만들어질 때 데이터 fetch를 **바로 시작**하므로, connectedCallback에서 imperative 호출을 기다리는 것보다 데이터가 일찍 도착하는 경우가 많다. LDS 기반 wire는 **클라이언트 캐시**를 활용해 같은 데이터의 중복 서버 왕복도 줄인다.

### 병렬 로딩 — 워터폴 회피

여러 독립 데이터를 **순차로 await하면 지연이 누적**된다. 서로 의존하지 않는 호출은 병렬로 띄운다.

```javascript
// 구조 예시 — 실제 동작 코드 아님
// ❌ 워터폴: A가 끝나야 B 시작 → 총 시간 = A + B
async loadSlow() {
    this.accounts = await getAccounts();
    this.contacts = await getContacts();
}

// ✅ 병렬: 동시에 시작 → 총 시간 = max(A, B)
async loadFast() {
    const [accounts, contacts] = await Promise.all([
        getAccounts(),
        getContacts(),
    ]);
    this.accounts = accounts;
    this.contacts = contacts;
}
```

- `@wire`로 부른 독립 데이터들은 본래 각자 병렬로 진행되므로 워터폴이 잘 생기지 않는다 — imperative를 순차로 엮을 때 특히 `Promise.all`을 의식한다.
- 단, 뒤 호출이 앞 결과에 **의존**하면 병렬화할 수 없다. 의존이 없을 때만 묶는다.

---

## 5. 무거운 계산 회피

### renderedCallback 주의

`renderedCallback`은 앱 수명 동안 **여러 번** 실행된다([[Lifecycle Hooks]]). 여기에 무거운 계산이나 state 업데이트를 넣으면 렌더마다 비용을 물고, 최악의 경우 무한 루프가 된다.

```javascript
// 구조 예시 — 실제 동작 코드 아님
renderedCallback() {
    // ❌ 매 렌더마다 무거운 DOM 측정/계산
    // this.recalcLayoutForEveryRow();

    // ❌ 여기서 반응형/public 프로퍼티 업데이트 → 재렌더 재유발(무한 루프 위험)
    // this.total = compute();

    // ✅ 1회성 작업만, hasRendered로 가드
    if (this.hasRendered) return;
    this.hasRendered = true;
    // 서드파티 라이브러리 초기화 등 딱 한 번
}
```

- renderedCallback에서 **wire config 프로퍼티·public 프로퍼티를 업데이트하지 않는다**(재렌더를 다시 트리거).
- 렌더 후 DOM 측정이 꼭 필요하면 1회성 가드로 최소화하고, 매 렌더 반복 작업은 피한다.

### debounce — 고빈도 이벤트 억제

입력·스크롤·리사이즈처럼 **초당 수십 번** 발생하는 이벤트에서, 매 이벤트마다 검색·재계산·서버 호출을 하면 낭비가 크다. debounce로 "멈춘 뒤 한 번"만 실행한다.

```javascript
// 구조 예시 — 실제 동작 코드 아님
export default class Search extends LightningElement {
    _timer;

    handleInput(event) {
        const term = event.target.value;
        clearTimeout(this._timer);
        this._timer = setTimeout(() => {
            this.runSearch(term);     // 타이핑이 멈추고 300ms 뒤 1회만
        }, 300);
    }

    disconnectedCallback() {
        clearTimeout(this._timer);    // 정리 — 리스너/타이머 누수 방지
    }
}
```

- keystroke마다 Apex를 치지 말고 debounce로 호출 수를 줄이면 서버 부하와 재렌더가 함께 줄어든다.
- 타이머·리스너는 `disconnectedCallback`에서 정리한다(누수·좀비 콜백 방지 — [[Lifecycle Hooks]]).

---

## 체크리스트 — 작성자가 훑는 순서

```
□ 안 바뀌는 값을 새 참조로 재할당하고 있지 않은가 (불필요 재렌더)
□ 무거운 getter를 렌더마다 재계산하는가 → memoize 또는 사전 계산
□ for:each의 key가 데이터 고유 ID인가 (index 금지)
□ 초기 렌더에 불필요한 트리를 lwc:if로 미뤘는가
□ 무거운 모듈을 동적 import로 코드 스플리팅했는가
□ 초기 읽기 데이터는 @wire로 조기 로딩하는가
□ 독립 imperative 호출을 Promise.all로 병렬화했는가
□ renderedCallback에 무거운 계산/state 업데이트가 없는가 (hasRendered 가드)
□ 고빈도 이벤트를 debounce했는가 + 타이머/리스너를 disconnectedCallback에서 정리했는가
```

---

## 관련 노트
- [[LWC 리액티비티 (반응형 필드·재렌더 트리거)]] — 무엇이 재렌더를 트리거하는가 (이 노트가 전제하는 반응형 규칙)
- [[Lifecycle Hooks]] — renderedCallback 다중 실행·요소 재사용·정리 타이밍
- [[LWC 오픈소스 아키텍처]] — 정적 콘텐츠 최적화 등 엔진 자동 최적화 (이 노트가 위임하는 엔진 측)
- [[Static Resource 로딩]] — 서드파티 라이브러리 lazy 로딩 (renderedCallback 1회성 패턴)
- [[LWC MOC]] — LWC 섹션 전체 목차
