---
tags: [lwc, lifecycle, hooks, connectedcallback, renderedcallback, errorcallback, constructor]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Create Components > Lifecycle Hooks; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/create-lifecycle-hooks.html
created: 2026-07-04
aliases: [lifecycle hooks, LWC 라이프사이클, constructor, connectedCallback, disconnectedCallback, renderedCallback, errorCallback, error boundary, hasRendered, isConnected, 컴포넌트 생명주기]
---

# LWC Lifecycle Hooks

> Lightning Web Component 인스턴스가 생성·DOM 삽입·렌더·제거되는 lifecycle의 각 단계에서 프레임워크가 호출하는 콜백 메서드들 — constructor · connectedCallback · disconnectedCallback · renderedCallback · errorCallback.

---

## 개념

**lifecycle hook**은 컴포넌트 인스턴스 lifecycle의 특정 단계에 트리거되는 콜백 메서드다. 프레임워크가 컴포넌트의 생성, DOM 삽입, 렌더링, 제거, 프로퍼티 변경 감시를 관리하며, 각 단계에서 대응하는 hook을 호출한다.

hook은 5개다.

| Hook | 시점 | LWC 고유? |
|---|---|---|
| `constructor()` | 인스턴스 생성 시 | ❌ (Custom Elements 표준) |
| `connectedCallback()` | DOM에 삽입될 때 | ❌ (Web Components 표준) |
| `disconnectedCallback()` | DOM에서 제거될 때 | ❌ (Web Components 표준) |
| `renderedCallback()` | 컴포넌트 렌더 완료 후 | ✅ LWC 고유 |
| `errorCallback(error, stack)` | 하위 컴포넌트에서 에러 발생 시 | ✅ LWC 고유 |

---

## Lifecycle 흐름

> 공식 문서에는 흐름 다이어그램 2개(생성→렌더 / 제거)가 있다. 여기서는 다이어그램을 재현하지 않고 순서를 서술한다.

**생성 → 렌더 순서:**

```
constructor → connectedCallback → (render) → renderedCallback
```

**제거 순서:**

```
disconnectedCallback
```

`constructor`는 **parent → child** 순으로 fire된다(부모가 먼저 생성된다). 따라서 constructor 시점에는 자식 요소가 아직 존재하지 않아 접근할 수 없고, 자식 접근이 필요하면 `connectedCallback`을 쓴다.

---

## 1. constructor()

컴포넌트 인스턴스가 생성될 때 fire된다.

- **parent → child** 순으로 호출된다(부모가 먼저). 이 시점에는 자식 요소가 아직 없으므로 접근 불가 → 자식 접근은 `connectedCallback`에서 한다.
- 생성 중 host 요소에 **attribute를 추가하면 안 된다.** host 요소에 attribute를 추가하는 작업은 constructor가 아닌 다른 lifecycle 단계(권장: `connectedCallback`)에서 한다.

**HTML Custom Elements 명세가 요구하는 제약:**

- **첫 문장은 파라미터 없는 `super()`** 여야 한다 — 올바른 prototype chain과 `this` 값을 확립하기 위함이다.
- constructor 본문에서 `return` 문을 쓰면 안 된다. 단, 단순 early-return(`return;` / `return this;`)은 예외로 허용된다.
- `document.write()` / `document.open()`을 호출하면 안 된다.
- 요소의 **attribute와 children을 검사하면 안 된다**(아직 존재하지 않음).
- 요소의 **public 프로퍼티를 검사하면 안 된다**(public 프로퍼티는 컴포넌트가 생성된 후에 설정되기 때문).

```javascript
// 실제 문법 — LWC constructor 규칙
import { LightningElement } from 'lwc';

export default class MyComponent extends LightningElement {
    constructor() {
        super(); // 반드시 첫 문장, 파라미터 없음
        // ✅ 여기서 host attribute 추가 금지 → connectedCallback에서
        // ✅ this.children / attribute / public property 검사 금지
    }
}
```

---

## 2. connectedCallback() / disconnectedCallback()

`connectedCallback()`은 요소가 DOM에 **삽입될 때**, `disconnectedCallback()`은 DOM에서 **제거될 때** fire된다. 둘 다 Web Components 표준 콜백이다. 이 hook 안에서는 `this`와 `this.template`에 접근할 수 있다.

- DOM 연결 여부는 `this.isConnected`로 확인한다.
- `connectedCallback`은 컴포넌트에 전달된 **초기 프로퍼티**와 함께 invoke된다.

**connectedCallback의 대표 용도(5가지):**

1. 현재 document/컨테이너와 통신을 확립하고 환경·동작을 조율한다.
2. 초기화 — 데이터 fetch, 캐시 설정, 이벤트 리스닝 시작.
3. Message Channel 구독/구독 해제.
4. `lightning/navigation`을 사용해 레코드·리스트뷰 등으로 이동.
5. 서드파티 web component 사용.

**주의사항:**

- ⚠️ `connectedCallback`은 **1회 이상 fire될 수 있다** — 요소가 제거된 뒤 다른 위치에 다시 삽입되는 경우 등.
- 자식 요소는 아직 존재하지 않으므로 접근할 수 없다.
- `disconnectedCallback()`에서는 `connectedCallback`에서 했던 작업을 **정리**한다 — 캐시 purge, 이벤트 리스너 제거, Message Channel 구독 해제 등.
- ⚠️ **두 hook 모두 동기(synchronous)** 다. 프레임워크는 lifecycle hook이 반환한 promise를 await하지 않으므로 `async`/`await`으로 만들면 안 된다. 비동기 작업이 필요하면 **동기 hook 안에서 별도의 async 메서드를 호출**한다.

```javascript
// 실제 문법 — 동기 hook에서 별도 async 메서드 호출
import { LightningElement } from 'lwc';

export default class MyComponent extends LightningElement {
    connectedCallback() {          // 동기 — async 붙이지 않음
        this.loadData();           // 별도 async 메서드 호출
    }

    async loadData() {             // 비동기 작업은 여기서
        const result = await fetch('/some/endpoint');
        // ...
    }

    disconnectedCallback() {
        // connectedCallback에서 한 작업 정리
        // (이벤트 리스너 제거, Message Channel unsubscribe 등)
    }
}
```

---

## 3. renderedCallback()

**LWC 고유** hook으로, 컴포넌트 렌더가 완료된 후 로직을 수행한다.

**재렌더 메커니즘 (Reactivity):**

컴포넌트가 렌더될 때 템플릿의 expression이 재평가된다. 컴포넌트가 connect되고 렌더된 후 state가 변경/mutation되면 재렌더가 트리거된다.

- 컴포넌트를 "dirty"로 표시한다.
- 재렌더 microtask를 enqueue한다.

프로퍼티 값이 변경되고 **그 프로퍼티가 템플릿(또는 템플릿에서 쓰이는 getter)에 사용될 때** 재렌더된다(Reactivity).

**요소 재사용 예외:**

재렌더 시 LWC 엔진은 기존 요소를 재사용하려 시도한다. 단, 다음 두 경우는 재사용 판단이 다르다.

1. `for:each`로 만든 요소 — 재사용 여부는 `key`에 따라 결정된다.
2. `<slot>` content로 받은 요소 — diffing 알고리즘에 따라 결정된다.

**주의사항:**

- ⚠️ `renderedCallback`은 앱 수명 동안 **여러 번** 실행된다. 1회성 작업은 boolean 필드(예: `hasRendered`)로 추적한다 — renderedCallback 안에서 `hasRendered = true`로 표시.
- 이벤트 리스너는 HTML 템플릿에 선언적으로 추가하는 것이 최선이다. 프로그래밍적 추가가 꼭 필요하면 `renderedCallback`에서 한다.
- ⚠️ **renderedCallback에서의 state 업데이트는 무한 루프를 유발할 수 있다:**
  - renderedCallback에서 **wire adapter config 객체의 프로퍼티를 업데이트하면 안 된다.**
  - renderedCallback에서 **public 프로퍼티·필드를 업데이트하면 안 된다.**

> 예: `lwc-recipes`의 `libsChartjs` 모듈이 `renderedCallback`을 사용한다.

```javascript
// 실제 문법 — hasRendered 1회성 패턴
import { LightningElement } from 'lwc';

export default class MyComponent extends LightningElement {
    hasRendered = false;

    renderedCallback() {
        if (this.hasRendered) {
            return;            // 이미 실행됨 → 재실행 방지
        }
        this.hasRendered = true;
        // 여기서 1회성 초기화 (예: 서드파티 라이브러리 로드)
        // ⚠️ wire config 프로퍼티 / public 프로퍼티 업데이트 금지 (무한 루프)
    }
}
```

---

## 4. errorCallback(error, stack)

**LWC 고유** hook으로, **error boundary 컴포넌트**를 만드는 데 쓰인다. 트리 내 모든 하위(descendent) 컴포넌트에서 발생한 에러를 포착한다(JavaScript의 `catch {}`와 유사).

- error boundary 컴포넌트는 앱 전체에서 재사용할 수 있다. 에러가 발생하면 error-view를 표시하고, 아니면 healthy-view를 표시한다(컴포넌트를 wrapping).
- host 요소 접근은 `this`, 템플릿 요소 접근은 `this.template`.
- **파라미터:** `error` = JavaScript native error 객체, `stack` = 문자열.
- 템플릿에서 `lwc:if | lwc:elseif | lwc:else`를 반드시 써야 하는 것은 아니다.

**주의사항:**

- ⚠️ **프로그래밍적으로 할당한 이벤트 핸들러에서 발생한 에러는 errorCallback이 포착하지 못한다.**
  - `onclick`처럼 **선언적**으로 준 핸들러의 에러 → 포착됨.
  - `addEventListener`처럼 **프로그래밍적**으로 준 핸들러의 에러 → 포착 안 됨.

```javascript
// 실제 문법 — error boundary 컴포넌트
import { LightningElement } from 'lwc';

export default class Boundary extends LightningElement {
    error;
    stack;

    errorCallback(error, stack) {
        this.error = error;   // native error 객체
        this.stack = stack;   // 문자열
        // 트리 내 하위 컴포넌트의 에러를 여기서 포착 → error-view 표시
    }
}
```

---

## 관련 노트
- [[@wire 어댑터 내부 구조]] — @wire 데이터의 lifecycle과 config reactivity (renderedCallback에서 wire config 업데이트 금지 규칙과 연결)
- [[CustomEvent 패턴]] — DOM을 통한 이벤트 통신 (connectedCallback에서 리스너 초기화)
- [[Lightning Message Service]] — MessageChannel 구독은 connectedCallback, 해제는 disconnectedCallback
- [[HTML 템플릿 Directives 레퍼런스]] — `for:each`의 `key`와 `<slot>` 요소 재사용/재렌더 규칙
- [[CSS 스타일시트와 스코핑]] — 형제 Create Components 기초 주제 (컴포넌트 스타일링)
- [[컴포넌트 접근성 (ARIA·label)]] — 형제 Create Components: 기본 ARIA는 `constructor()`가 아니라 `connectedCallback()`에서 정의
- [[LWC MOC]] — LWC 섹션 전체 목차
