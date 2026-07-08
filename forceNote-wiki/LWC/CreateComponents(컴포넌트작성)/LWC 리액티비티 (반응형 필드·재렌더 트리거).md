---
tags: [lwc, reactivity, reactive, rerender, track, api, getter, spread, immutable]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Create Components > Reactivity / Track Changes / @track; 라이브 공식 문서, Tier 2, 접속 2026-07-08)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/reactivity.html
created: 2026-07-08
aliases: [LWC 리액티비티, LWC reactivity, 반응형 필드, reactive fields, 재렌더 트리거, rerender, @track, 반응형, immutable update, 스프레드 재할당, 배열 push 재렌더 안됨, 중첩 객체 mutation]
---

# LWC 리액티비티 (반응형 필드·재렌더 트리거)

> LWC의 모든 필드는 기본 반응형이다 — 필드를 **재할당**하면 프레임워크가 재렌더한다. 단 객체·배열은 **내부를 mutate**해도 참조가 그대로면 재렌더가 트리거되지 않으므로, 새 참조로 교체하거나 `@track`으로 내부 변경을 추적해야 한다. (엔진 내부 프록시 동작은 [[@track 데코레이터 내부 구조]]에 위임 — 이 노트는 개발자 멘털모델.)

---

## 핵심 규칙 — 모든 필드가 기본 반응형

LWC에서 클래스의 모든 필드(프로퍼티)는 별도 데코레이터 없이도 반응형이다. 필드 값을 **재할당**하면, 그 필드를 참조하는 템플릿이 다시 렌더된다.

```javascript
// 구조 예시 — 실제 동작 코드 아님
import { LightningElement } from 'lwc';

export default class Counter extends LightningElement {
    count = 0;              // 데코레이터 없이도 반응형

    increment() {
        this.count = this.count + 1;   // ← 재할당 → 재렌더 트리거
    }
}
```

```html
<!-- template -->
<template>
    <p>Count: {count}</p>
    <lightning-button label="Add" onclick={increment}></lightning-button>
</template>
```

**재렌더가 트리거되는 조건:** 템플릿에서 사용되는 필드에 **새 값이 할당(=)**될 때. 값이 이전과 동일하면(원시값 기준 `===`) 재렌더하지 않는다.

---

## primitive 재할당 vs object/array 내부 변경

이 구분이 LWC 리액티비티에서 가장 헷갈리는 지점이다.

| 값의 종류 | 반응형 트리거 방식 | 재렌더되나? |
|---|---|---|
| primitive (string·number·boolean) | 필드 재할당(`this.x = newVal`) | ✅ 값이 바뀌면 |
| object / array | **새 참조로 필드 재할당** | ✅ 참조가 바뀌면 |
| object / array | 기존 참조 내부만 mutate (`this.obj.a = 1`, `this.arr.push(x)`) | ❌ (참조 불변 → 감지 안 됨) |

원시값은 값 자체가 필드에 저장되므로 재할당이 곧 값 변경이다. 반면 객체·배열은 필드에 **참조(포인터)** 가 저장된다. 내부를 mutate해도 필드가 가리키는 참조는 그대로라, 프레임워크는 "필드가 안 바뀌었다"고 판단해 재렌더하지 않는다.

### ✅ 새 참조로 교체 (immutable 업데이트 · 권장)

스프레드(`...`)로 새 객체·배열을 만들어 **재할당**한다.

```javascript
// 구조 예시 — 실제 동작 코드 아님
// 객체: 새 객체를 만들어 재할당
this.contact = { ...this.contact, name: 'Amy' };

// 배열에 항목 추가: 새 배열을 만들어 재할당
this.items = [...this.items, newItem];

// 배열에서 항목 제거: filter가 새 배열을 반환
this.items = this.items.filter(item => item.id !== targetId);
```

### ❌ 내부 mutation (재렌더 안 됨)

```javascript
// 구조 예시 — 재렌더가 트리거되지 않는 안티패턴
this.contact.name = 'Amy';        // 참조 그대로 → 감지 안 됨
this.items.push(newItem);         // 배열 참조 그대로 → 감지 안 됨
this.items[0].selected = true;    // 중첩 mutation → 감지 안 됨
```

---

## @track이 필요한 경우 — 객체·배열 내부 mutation 추적

`@track`은 필드에 담긴 객체·배열의 **내부 프로퍼티 변경까지** 반응형으로 만든다. 스프레드로 매번 새 참조를 만드는 대신 내부를 직접 mutate하고 싶을 때 사용한다.

```javascript
// 구조 예시 — 실제 동작 코드 아님
import { LightningElement, track } from 'lwc';

export default class Editor extends LightningElement {
    @track contact = { name: 'Amy', title: 'VP' };

    changeName() {
        this.contact.name = 'Bob';   // @track 덕분에 내부 mutation도 재렌더 트리거
    }
}
```

- `@track` 없이 객체·배열 필드를 두면, **필드 재할당(새 참조)** 만 반응형이고 내부 mutation은 무시된다.
- `@track`을 붙이면 객체의 프로퍼티, 배열의 요소까지 프레임워크가 관찰(deep observation)한다.
- 실무 권장은 **immutable 업데이트(스프레드 재할당)** 이며, `@track`은 내부 mutation이 불가피한 경우에 쓴다. (내부 프록시 래핑 동작은 [[@track 데코레이터 내부 구조]] 참조.)

> 참고: API 버전 48.0(Spring '20) 이후 필드가 기본 반응형이 되면서, 원시값이나 새 참조 재할당만으로 충분한 경우에는 `@track`이 더 이상 필요 없다. `@track`은 이제 **객체·배열 내부 변경 추적** 전용 도구다.

---

## getter는 자동 재계산

getter는 별도 반응형 표시가 필요 없다. getter가 참조하는 반응형 필드가 바뀌면, 다음 렌더 시 getter가 **자동으로 다시 호출**되어 새 값을 계산한다.

```javascript
// 구조 예시 — 실제 동작 코드 아님
export default class FullName extends LightningElement {
    firstName = 'Amy';
    lastName = 'Taylor';

    get fullName() {
        return `${this.firstName} ${this.lastName}`;   // firstName/lastName 변경 시 자동 재계산
    }
}
```

```html
<template>
    <p>{fullName}</p>
</template>
```

- getter 안에서 참조한 필드가 재렌더를 유발하면 getter도 함께 재평가된다.
- getter는 렌더 파이프라인에서 호출되므로 **부수효과(side effect)를 넣지 말 것** — 순수 계산만 둔다.

---

## @api 프로퍼티도 반응형

`@api`로 노출한 public 프로퍼티도 반응형이다. 부모가 자식의 `@api` 프로퍼티에 새 값을 전달하면 자식이 재렌더된다.

```javascript
// 구조 예시 — 실제 동작 코드 아님
import { LightningElement, api } from 'lwc';

export default class Greeting extends LightningElement {
    @api name;   // 부모가 name을 바꾸면 자식 재렌더
}
```

- `@api` 프로퍼티도 객체·배열이면 위와 동일한 규칙이 적용된다 — 부모가 **새 참조**를 넘겨야 자식이 재렌더된다. 부모가 자식에 넘긴 객체를 내부 mutate하면 자식은 갱신되지 않는다.
- `@api` 데이터 전달·headless action 패턴은 [[@api 패턴]] 참조.

---

## 흔한 함정

| 함정 | 왜 재렌더 안 되나 | 해결 |
|---|---|---|
| `this.obj.prop = x` (중첩 mutation) | 필드가 가리키는 참조 불변 | `this.obj = { ...this.obj, prop: x }` 또는 `@track` |
| `this.arr.push(x)` | 배열 참조 불변 | `this.arr = [...this.arr, x]` |
| `this.arr[i] = x` / `this.arr[i].sel = true` | 배열 참조·요소 참조 불변 | 새 배열 map으로 교체 또는 `@track` |
| 부모가 자식 `@api` 객체를 내부 mutate | 자식이 받은 참조 불변 | 부모에서 새 객체를 만들어 재할당 후 전달 |
| getter에 부수효과/비동기 | 렌더마다 호출돼 예측 불가 | getter는 순수 계산만 |
| 값이 실제로 안 바뀌었는데 재할당 | 동일 원시값은 `===`로 스킵 | 정상 동작 (불필요 렌더 방지) |

배열을 immutable하게 갱신하는 관용구:

```javascript
// 구조 예시 — 실제 동작 코드 아님
// 특정 요소만 변경 (map으로 새 배열 반환)
this.items = this.items.map(item =>
    item.id === targetId ? { ...item, selected: true } : item
);
```

---

## 관련 노트
- [[@track 데코레이터 내부 구조]] — observable-membrane·reactive proxy 등 엔진 내부 동작 (이 노트가 위임하는 심화편)
- [[Lifecycle Hooks]] — 재렌더가 실제 언제 일어나는지(renderedCallback 등 lifecycle 단계)
- [[@api 패턴]] — public 프로퍼티·메서드로 부모↔자식 데이터 전달
- [[LWC MOC]] — LWC 섹션 전체 목차
