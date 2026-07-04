---
tags: [lwc, events, propagation, bubbles, composed, shadow-dom, event-target]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Communicate with Events > Configure Event Propagation; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/events-propagation.html
created: 2026-07-04
aliases: [event propagation, 이벤트 전파, bubbles, composed, Event.target, currentTarget, composedPath, event retargeting, shadow 경계 이벤트, props down events up, 네임스페이스 이벤트]
---

# LWC 이벤트 전파 (bubbles·composed)

> LWC 이벤트는 DOM 이벤트와 동일한 규칙으로 위로 전파되며, `bubbles`·`composed` 두 프로퍼티가 DOM bubble 여부와 shadow 경계 통과 여부를 결정한다.

---

## 개요

부모-자식 컴포넌트 통신의 두 방향은 **props down, events up** 이다. 부모는 프로퍼티(props)를 자식으로 내려보내고, 자식은 이벤트를 fire 해 부모로 올려보낸다. 이벤트가 fire 되면 **DOM 트리 위로 전파(propagate up)** 되며, LWC 이벤트는 **표준 DOM 이벤트와 동일한 규칙**으로 전파된다.

핵심 제약: 이벤트 target은 기본적으로 **컴포넌트 인스턴스의 shadow root 밖으로 전파되지 않는다.** 이 때문에 컴포넌트 밖에서 이벤트를 관찰하면, 실제로 어느 내부 요소에서 발생했든 **모든 이벤트가 그 컴포넌트에서 온 것처럼 보인다.** 이 동작을 **retargeting**(재타겟팅)이라 부른다.

> shadow 경계·retargeting의 내부 메커니즘은 [[LWC Shadow DOM 모드]] 참조.

---

## 전파를 결정하는 2가지 프로퍼티

이벤트를 생성할 때 정의하는 두 Boolean 프로퍼티가 전파 방식을 결정한다.

| 프로퍼티 | 타입 | 기본값 | 의미 |
|---|---|---|---|
| `bubbles` | Boolean | `false` | 이벤트가 DOM 위로 bubble(상향 전파) 하는지 |
| `composed` | Boolean | `false` | 이벤트가 **shadow 경계를 통과**하는지 |

두 값 모두 기본이 `false` 이므로, 별도 지정 없이 생성한 이벤트는 bubble 하지도, shadow 경계를 넘지도 않는다.

---

## 이벤트 정보 (Web API `Event`)

핸들러 안에서 이벤트가 어디서 왔고 지금 어느 요소에 있는지 확인할 때 쓰는 프로퍼티다.

| 프로퍼티 | 반환 | 설명 |
|---|---|---|
| `Event.target` | 요소 | 이벤트를 dispatch한 요소. 각 컴포넌트의 내부 DOM은 shadow DOM에 캡슐화되므로 **shadow 경계에서 retarget** 된다. 예: `<my-button>` 컴포넌트에 부착된 click 리스너는 내부 `button` 요소에서 클릭이 일어나도 항상 `my-button`을 target으로 받는다. |
| `Event.currentTarget` | 요소 | 이벤트가 DOM을 순회하는 동안 **핸들러가 부착된 요소**를 항상 가리킨다. |
| `Event.composedPath()` | 요소 배열 | 이벤트가 DOM을 순회할 때 리스너가 호출되는 event target들의 배열. |

---

## 4가지 구성 (bubbles × composed)

정적 구성 예시로 `c-app` → `c-parent` → `c-child` 계층을 가정한다. `c-child`가 버튼을 보유하며, 버튼을 클릭하면 `buttonclick` 이벤트를 fire 한다. 아래는 `bubbles`·`composed` 조합별 동작이다.

### 1. `bubbles: false, composed: false` (기본)

- DOM 위로 bubble 하지 않고, shadow 경계도 넘지 않는다.
- **권장 구성** — 가장 덜 파괴적이며 캡슐화 수준이 가장 높다.
- 이벤트는 `c-child`까지만 도달한다. 핸들러에서 검사하면:
  - `event.currentTarget` = `c-child`
  - `event.target` = `c-child`
- 예: lwc-recipes 의 `c-event-with-data` / `c-contact-list-item` (bubbles false · composed false).

### 2. `bubbles: true, composed: false`

- DOM 위로 bubble 하지만 shadow 경계는 넘지 않는다. `c-child`와 `div.wrapper` 둘 다 이벤트를 처리한다.
  - `c-child` 핸들러: `currentTarget` = `c-child`, `target` = `c-child`
  - `div.childWrapper` 핸들러: `currentTarget` = `div.childWrapper`, `target` = `c-child` (target은 여전히 `c-child`로 retarget 유지)
- **용도 2가지:**
  - **내부 이벤트 생성:** 컴포넌트 템플릿 안에서 bubble 시킨다. 템플릿 요소에 dispatch 하고 `myComponent.js`에서 처리한다. 이때 포함(containing) 컴포넌트의 핸들러는 실행되지 않는다 — shadow 경계를 넘지 못하기 때문이다.
  - **grandparent로 전송:** 컴포넌트가 **slot에 전달(passed into a slot)** 됐고, 이벤트를 그 template로 bubble 시키고 싶을 때 사용한다. 예: lwc-recipes 의 `eventBubbling` — `c-contact-list-item-bubbling`이 `contactselect`를 bubbles:true 로 dispatch 하면, 리스너 `oncontactselect`는 부모 `lightning-layout-item`에 있고, 실제 처리는 grandparent `c-event-bubbling`에서 이뤄진다.

### 3. `bubbles: true, composed: true`

- DOM 위로 bubble 하고, shadow 경계를 통과하며, **document root까지 계속 bubble** 한다.
- ⚠️ 이 구성을 쓰면 **이벤트 타입이 컴포넌트 public API의 일부**가 된다.
- ⚠️ document root까지 bubble 하므로 **이름 충돌을 유발할 수 있다.** 사용 시 이벤트 타입에 **네임스페이스 접두**를 붙인다 — 예: `mydomain__myevent`, HTML 리스너는 `onmydomain__myevent`.

### 4. `bubbles: false, composed: true`

- ⚠️ **Lightning web components는 이 구성을 사용하지 않는다.**

---

## 코드 예시

```javascript
// 구조 예시 — 실제 동작 코드 아님

// c-child 컴포넌트: 버튼 클릭 시 buttonclick 이벤트 fire
handleClick() {
    this.dispatchEvent(
        new CustomEvent('buttonclick', {
            bubbles: true,      // DOM 위로 bubble
            composed: false     // shadow 경계는 넘지 않음
        })
    );
}
```

동일한 `buttonclick`(bubbles: true, composed: false) 이벤트를 서로 다른 요소의 핸들러가 받았을 때 `target`·`currentTarget` 값:

| 핸들러가 부착된 요소 | `event.currentTarget` | `event.target` |
|---|---|---|
| `c-child` | `c-child` | `c-child` |
| `div.childWrapper` | `div.childWrapper` | `c-child` |

`target`은 shadow 경계에서 retarget 되어 어느 핸들러에서 보든 `c-child`로 고정되지만, `currentTarget`은 핸들러가 부착된 요소를 그대로 가리킨다.

---

## 관련 노트
- [[CustomEvent 패턴]] — 이벤트 생성·디스패치 방법 (이 노트는 생성된 이벤트의 전파 규칙을 다룬다)
- [[Lightning Message Service]] — DOM 관계가 없는 컴포넌트 간 통신
- [[LWC Shadow DOM 모드]] — shadow 경계·retargeting 내부 메커니즘
- [[LWC MOC]]
