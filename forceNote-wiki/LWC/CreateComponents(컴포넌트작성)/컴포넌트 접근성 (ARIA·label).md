---
tags: [lwc, accessibility, aria, a11y, screen-reader, label, shadow-dom]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Create Components > Component Accessibility(create-components-accessibility) + Handle Focus(create-components-focus); 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/create-components-accessibility.html
created: 2026-07-04
aliases: [component accessibility, 접근성, a11y, ARIA, aria-label, ariaLabel, aria-pressed, screen reader, label, WCAG, 기본 ARIA, role 고정, ID ARIA 링크, camel-case ARIA, focus, tabindex, delegatesFocus, 키보드 접근성, keyboard accessibility]
---

# LWC Component Accessibility (ARIA·label)

> 접근성 소프트웨어·보조기술(screen reader) 사용자가 컴포넌트를 쓸 수 있게 하려면 accessibility attributes(label·ARIA)를 노출하고, 커스텀 컴포넌트에서는 속성을 렌더된 HTML로 reflect해야 한다. ARIA accessor는 camel-case이며, 기본 ARIA는 `connectedCallback()`에서 정의한다.

---

## 개요

접근성 소프트웨어와 보조기술(screen reader 등)은 장애가 있는 사용자도 제품을 사용할 수 있게 한다. Salesforce는 접근 가능한 컴포넌트 작성을 위해 **WCAG(Web Content Accessibility Guidelines)** 를 따를 것을 권장한다.

접근성을 직접 다루는 대신 다음 두 가지 대안을 우선 고려할 수 있다.

- **Lightning base component 사용** — 내장된 접근성 지원을 그대로 활용한다.
- **SLDS Blueprint로 컴포넌트 생성** — Blueprint에 접근성이 이미 반영돼 있다.

컴포넌트를 접근 가능하게 만드는 두 축은 다음과 같다.

1. **accessibility attributes 사용** — screen reader·보조기술에 컴포넌트를 노출한다.
2. **focus 처리(Handle focus)** — 키보드 포커스 이동 관리.

> 두 축 모두 이 노트에서 다룬다. accessibility attributes는 아래에서, focus 처리는 [[#Focus 처리 (키보드 접근성)]] 섹션에서 설명한다.

---

## 접근성 속성 (Accessibility Attributes)

screen reader·보조기술에 컴포넌트를 노출하려면 HTML 속성을 사용한다.

### label 속성

**`label` 속성**이 접근성의 핵심이다. label을 컨트롤과 연관시켜 보조기술이 컨트롤의 용도를 읽을 수 있게 한다(WCAG label techniques).

**base component 내장 접근성** — `lightning-input`·`lightning-record-form` 같은 base component는 연관된 label과 함께 렌더된다. 예를 들어 `lightning-input`은 input 요소를 그에 연관된 label과 함께 렌더한다.

### aria-label 속성

`<label>` 요소를 사용할 수 없을 때, form control(버튼·input)을 식별하기 위해 **`aria-label`** 을 쓴다.

> ⚠️ `aria-label`은 **시각적으로 표시되지 않고 screen reader에만 전달**된다. 예를 들어 `aria-label`로 "Log In"을 지정하면 screen reader가 그 값을 읽는다.

> ⚠️ base component에 이미 `label="Log In"`이 있다면 `aria-label`은 **불필요**하다 — label 속성만으로 충분하다.

base component의 내부 구조는 변경될 수 있으므로, 아래 예시는 데모용이다(정확한 사용법은 Component Reference 참조).

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<!-- <label>을 쓸 수 없을 때 aria-label로 screen reader에 식별 정보 전달 -->
<button aria-label="Log In">Go</button>

<!-- base component: label 속성이 있으면 aria-label 불필요 -->
<lightning-input label="Log In"></lightning-input>
```

---

## 커스텀 컴포넌트에서 속성 노출·Reflect

커스텀 LWC를 작성할 때 screen reader가 접근할 수 있게 하려면 **`@api`로 public 속성을 노출**한다(예: `aria-label`).

> ⚠️ 속성을 public 프로퍼티로 노출해 제어권을 가지면, **그 속성이 HTML에 자동으로 나타나지 않는다.**

값을 렌더된 HTML 속성으로 전달(프로퍼티를 HTML 속성으로 reflect)하려면 **getter/setter를 정의하고 `setAttribute()`** 를 사용한다. setter에서 연산을 수행할 수 있고, 계산된 값을 private 프로퍼티로 보관할 수 있다(Reflect JavaScript Properties to HTML Attributes).

```js
// 구조 예시 — 실제 동작 코드 아님
import { LightningElement, api } from 'lwc';

export default class MyButton extends LightningElement {
    // public 속성으로 노출하면 HTML에 자동 반영되지 않으므로
    // getter/setter + setAttribute()로 렌더된 HTML 속성에 reflect한다
    @api
    get ariaPressed() {
        return this._ariaPressed;
    }
    set ariaPressed(value) {
        this._ariaPressed = value;              // private 프로퍼티에 계산값 보관
        this.setAttribute('aria-pressed', value); // 렌더된 HTML 속성으로 reflect
    }

    _ariaPressed;
}
```

---

## ARIA 속성 (고급)

버튼의 현재 상태를 screen reader가 읽게 하는 등 고급 접근성에는 **ARIA**를 사용한다. HTML 템플릿의 요소를 ARIA 속성으로 연관시킬 때 다음을 쓴다.

- `aria-describedby`
- `aria-details`
- `aria-owns`

> ⚠️ 템플릿이 렌더될 때 **`id` 값이 globally unique 값으로 변환**될 수 있다. 따라서 static `id`를 참조하지 말고 `class`나 `data-*`(예: `data-id`)를 사용한다.

### aria-pressed 예

**`aria-pressed`** 는 버튼의 눌림 상태를 screen reader에 전달하는 예다. `lightning-button`은 ARIA 속성을 public 프로퍼티로 정의하고 필드로 get/set한다. `lightning-button.js`는 camel-case 매핑을 통해 값을 get/set한다.

### ⚠️ ARIA 속성은 accessor 함수에서 camel-case

JavaScript accessor 함수에서 ARIA 속성은 **camel-case**로 표기한다.

- `aria-label` → **`ariaLabel`**
- `aria-pressed` → **`ariaPressed`**

> 전체 매핑 목록은 LWC GitHub(aria-reflection)에서 확인한다.

---

## 기본 ARIA 속성 (default + override 허용)

컴포넌트 작성자는 default ARIA 값을 정의하면서 소비자가 override하도록 허용할 수 있다.

> ⚠️ 속성은 **`connectedCallback()`에서 정의한다. `constructor()`에서 정의하지 말 것**(Constructor Considerations).

소비자가 `aria-label` 값을 제공하면 그 값을, 제공하지 않으면 default 값을 렌더한다.

```js
// 구조 예시 — 실제 동작 코드 아님
import { LightningElement } from 'lwc';

export default class MyComponent extends LightningElement {
    // 기본 ARIA는 constructor가 아니라 connectedCallback에서 정의
    connectedCallback() {
        if (!this.getAttribute('aria-label')) {
            this.setAttribute('aria-label', 'Default label'); // 소비자 미제공 시 default
        }
    }
}
```

---

## 속성 변경 방지 (고정 값)

커스텀 컴포넌트에서 속성 값이 바뀌지 않게 하고 싶을 때가 있다(예: `role`을 항상 `button` 또는 `tab`으로 고정).

소비자가 값을 바꾸지 못하게 하려면 **getter가 단순히 문자열을 반환**하게 한다(예: 항상 `"button"` 반환).

```js
// 구조 예시 — 실제 동작 코드 아님
import { LightningElement, api } from 'lwc';

export default class MyTab extends LightningElement {
    // getter가 항상 고정 문자열을 반환하므로 소비자가 role을 바꿀 수 없다
    @api
    get role() {
        return 'button';
    }
}
```

---

## ID ↔ ARIA 링크 (shadow DOM 제약)

같은 템플릿 내에서 요소의 `id`와 ARIA 속성은 **자동으로 링크**된다.

> ⚠️ **native shadow DOM에서는 별도 템플릿 간 요소의 ID↔ARIA 링크가 불가능하다.**

두 요소를 `id`·ARIA로 링크하려면 **light DOM**을 사용해 두 요소를 같은 템플릿에 배치한다.

> light DOM vs native shadow DOM의 차이는 [[LWC Shadow DOM 모드]]·[[CSS 스타일시트와 스코핑]] 참조.

---

## Focus 처리 (키보드 접근성)

접근성을 위해 **어느 요소가 focus를 갖는지 프로그래밍**한다. 브라우저는 **tab 키**로 키보드 네비게이션을 지원한다.

### interactive vs 비-interactive 요소

tab으로 이동할 때 **interactive 요소**(`<a>`·`<button>`·`<input>`·`<textarea>`)는 자동으로 focus를 받는다. 반면 **비-interactive 요소**(`<div>`·`<span>`)는 기본적으로 focus를 받지 못하므로, focus를 받게 하려면 **`tabindex="0"`** 을 붙여야 한다.

> ⚠️ LWC에서 `tabindex`는 **`0`과 `-1`만 지원**한다.
> - `tabindex="0"` — 표준 tab 순서로 focus를 받는다.
> - `tabindex="-1"` — tab 순서에는 포함되지 않지만 프로그래밍적으로(예: `.focus()`) focus 가능하다.

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<!-- interactive 요소는 자동 focus -->
<button>Save</button>

<!-- 비-interactive 요소는 tabindex="0"으로 표준 tab 순서에 편입 -->
<div tabindex="0">Focusable div</div>

<!-- tabindex="-1": tab으로는 못 가지만 프로그래밍 focus는 가능 -->
<div tabindex="-1">Programmatically focusable</div>
```

### 커스텀 컴포넌트의 focus

커스텀 컴포넌트에서는 focus가 **컴포넌트 컨테이너를 건너뛰고 내부 요소로 이동**한다(예: parent의 button → child의 input, 이때 child 컨테이너는 스킵된다).

커스텀 컴포넌트 **전체(컨테이너)에 focus**를 주려면 parent 템플릿에서 child 컴포넌트에 **`tabindex` 속성**을 설정한다.

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<!-- parent 템플릿: child 컴포넌트 전체(컨테이너)를 tab 순서에 넣으려면 tabindex 사용 -->
<c-cool-button tabindex="0"></c-cool-button>
```

### delegatesFocus

커스텀 컴포넌트 내부에 focusable 요소가 있어 `tabindex` 관리가 복잡할 때는 shadow DOM 옵션 **`delegatesFocus`** 를 `true`로 설정한다. 활성화 시 동작은 다음과 같다.

- `coolButton.focus()` 호출 시 컴포넌트 내부의 native 요소(예: button)에 focus가 추가된다.
- shadow DOM 내부의 **focusable하지 않은** 노드를 클릭하면 **첫 번째 focusable 영역**이 focus를 받는다.
- shadow DOM 내부 노드가 focus를 얻으면 **`:focus` CSS selector가 host 요소에도 적용**된다.

> ⚠️ **`tabindex`와 `delegatesFocus`를 함께 쓰지 말 것** — focus 순서가 어긋난다.

```js
// 구조 예시 — 실제 동작 코드 아님
import { LightningElement } from 'lwc';

export default class CoolButton extends LightningElement {
    // delegatesFocus: 내부에 focusable 요소가 여럿이라 tabindex 관리가 복잡할 때 사용
    static delegatesFocus = true;

    // 주의: delegatesFocus를 쓸 때는 tabindex 속성과 병용하지 않는다
}
```

> focus와 함께 쓰는 이벤트 리스너 연결·키보드 접근성 세부는 별도 주제(Attach Event Listeners, WebAIM Keyboard Accessibility)로 위임된다.

---

## 관련 노트
- [[Lifecycle Hooks]] — 기본 ARIA를 정의하는 `connectedCallback()` vs `constructor()` 차이
- [[CSS 스타일시트와 스코핑]] — light DOM / shadow DOM 스코핑 (ID↔ARIA 링크 관련)
- [[LWC Shadow DOM 모드]] — native shadow DOM vs light DOM (별도 템플릿 간 ID 링크 제약)
- [[SLDS 접근성]] — SLDS Blueprint 기반 접근성
- [[LWC MOC]]
