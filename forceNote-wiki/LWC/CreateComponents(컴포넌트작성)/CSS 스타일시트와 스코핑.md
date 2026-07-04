---
tags: [lwc, css, styling, shadow-dom, scoped-css, host-selector, stylesheets]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Create Components > Style Components with CSS Stylesheets; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/create-components-css.html
created: 2026-07-04
aliases: [LWC CSS, CSS 스타일시트, scoped CSS, :host, host selector, shadow DOM 스코핑, static stylesheets, cascade, specificity, inheritance, CSS scoping 예외, host-context, ::part]
---

# CSS 스타일시트와 스코핑

> LWC 컴포넌트는 자기 이름의 CSS 파일로 스타일을 정의하며, 스타일은 shadow DOM에 의해 컴포넌트 단위로 격리(scoped)된다. `:host` selector, cascade/specificity/inheritance 규칙, static `stylesheets` 프로퍼티, 그리고 표준 CSS 대비 스코핑 예외를 다룬다.

---

## 스타일시트 번들

- 컴포넌트에 스타일을 주려면 컴포넌트와 **같은 이름의 스타일시트**(`componentName.css`)를 컴포넌트 폴더에 만든다.
- ⚠️ **폴더당 스타일시트는 1개만** 둘 수 있다(암묵적으로 연관되는 `componentName.css`). 여러 스타일시트가 필요하면 아래 static `stylesheets` 프로퍼티를 쓴다.
- 표준 CSS 문법을 사용하며, 다른 파일에 정의한 style rule을 **import** 해서 공유할 수 있다.

---

## Shadow DOM 스코핑

shadow DOM에서 컴포넌트 스타일시트의 스타일은 **그 컴포넌트에 scoped**(격리)된다. 스타일이 컴포넌트 경계를 넘어 새지 않고, 바깥 스타일도 안으로 새지 않는다.

- synthetic shadow에서 스코핑은 요소에 붙는 속성으로 표현된다. 형식 예: `<div c-child_child>` · `<div lwc-12abcdefg-host>`.
- **부모 컴포넌트의 CSS는 자식 컴포넌트 내부로 들어가지 못한다.** 부모는 자식을 **단일 요소로만** 스타일링할 수 있다(부모 CSS의 `c-child` selector로). 즉 자식 내부의 개별 요소는 부모 CSS로 건드릴 수 없다.
- 컴포넌트가 **자기 host 요소**를 스타일링하려면 `c-child` selector가 아니라 **`:host` selector**를 쓴다(아래 참조).

---

## `:host` selector

컴포넌트가 자기 자신의 host 요소(컴포넌트를 감싸는 최상위 요소)를 스타일링할 때 사용한다.

- `:host`는 **optional selector 리스트**를 허용한다. host 요소가 리스트의 매칭 class를 보유해야 스타일이 적용된다.
- 예: `:host(.active)`는 host에 `active` class가 있을 때만 적용 → active 항목만 다른 배경색을 주는 식.

```css
/* 구조 예시 — 실제 동작 코드 아님 */
/* c-child.css : 자식이 자기 host 요소를 스타일링 */
:host {
    display: block;
    background-color: white;
}

/* host 요소에 active class가 있을 때만 적용 (optional selector 리스트) */
:host(.active) {
    background-color: yellow;
}
```

---

## Cascade · Specificity · Inheritance

표준 CSS의 세 가지 값 결정 메커니즘은 shadow DOM 안에서도 적용되지만, shadow 경계에 대한 동작이 다르다.

### Cascading
- 여러 스타일시트에서 온 CSS 규칙들이 결합된다.

### Specificity
- CSS class나 요소를 포함하면 specificity가 증가한다.
- class selector(`.somecolor`)가 태그 selector보다 더 구체적이다 → 태그 selector가 `background: red`를, class selector가 `background: blue`를 지정하면 **class의 `background: blue`가 적용**된다.

### Inheritance
- cascaded 값이 없을 때 상속 값이 적용된다.
- `color` · `font` 등 일부 프로퍼티는 상속되고, `border`는 상속되지 않는다(각 프로퍼티의 상속 여부는 W3C 명세로 확인).
- ⚠️ **shadow DOM은 cascaded 스타일은 막지만 inherited 스타일은 막지 못한다.** 상속되는 프로퍼티(예: `color`)는 shadow 경계를 넘어 자식 컴포넌트에 적용된다.
- ⚠️ **CSS custom properties도 shadow 경계를 통과**한다.

---

## CSS Scoping 표준 예외

LWC의 스코핑은 CSS Scoping Module Level 1 표준과 다음 4가지가 다르다.

- ❌ **`:host-context()`** pseudo-class 함수를 지원하지 않는다.
- ❌ **`::part`** pseudo-element를 지원하지 않는다.
- ❌ **ID selector**를 지원하지 않는다. HTML 템플릿 내의 `id` 값은 고유하게 관리해야 하며, LWC가 렌더 시 id 값을 변형한다.
- LWC는 컴포넌트의 커스텀 **public 프로퍼티를 대응 HTML 속성으로 reflect 하지 않는다**. 단 `class`와 `data-*`는 HTML 속성으로 reflect된다(예외).

---

## 성능

- ⚠️ scoped CSS는 성능에 영향을 준다 — 신중하게 사용한다.
- 각 selector chain이 scoped되고, 각 compound selector에 `:host()` 등이 붙는다.
- CSS 캡슐화를 위해 각 요소에 추가 속성(예: `c-parent_parent-host`)이 붙으며, 이로 인해 렌더 시간이 증가한다.

---

## static `stylesheets` 프로퍼티 (다중 스타일시트)

한 컴포넌트를 여러 스타일시트로 커스터마이즈하려면 컴포넌트 클래스(`LightningElement`)에 **static `stylesheets` 프로퍼티**를 추가한다.

- 예: `header-styles.css`와 `button-styles.css`를 `myComponent`에 주입하려면 `myComponent.js`에 static `stylesheets`를 설정한다.
- 주입 순서: LWC 엔진이 **먼저 `myComponent.css`**(컴포넌트에 암묵적으로 연관된 스타일시트)를 주입하고, **그 다음 `stylesheets` 배열**을 주입한다.
- LWC 엔진은 클래스가 정의될 때 `stylesheets` 배열을 **앱 수명 동안 캐시**한다.
- ⚠️ **subclass는 superclass의 `stylesheets`를 자동으로 상속하지 않는다.** 확장하려면 `super.stylesheets`를 사용한다.

```js
// 구조 예시 — 실제 동작 코드 아님
import { LightningElement } from 'lwc';
import headerStyles from './headerStyles.css';
import buttonStyles from './buttonStyles.css';

export default class MyComponent extends LightningElement {
    // 먼저 myComponent.css가 주입된 뒤, 이 배열이 순서대로 주입된다.
    static stylesheets = [headerStyles, buttonStyles];
}

// subclass에서 확장할 때는 super.stylesheets를 이어붙인다 (자동 상속 안 됨)
export class ChildComponent extends MyComponent {
    static stylesheets = [...super.stylesheets, /* 추가 스타일시트 */];
}
```

---

## 관련 노트
- [[LWC Shadow DOM 모드]] — shadow DOM(native/synthetic) 모드 심화. 스코핑 격리의 기반 메커니즘.
- [[SLDS 스타일링 훅]] — CSS custom properties(스타일링 훅)로 shadow 경계를 넘어 스타일링하는 디자인 토큰.
- [[SLDS LWC 디자인 시스템]] — SLDS 디자인 시스템 전반과 LWC 적용.
- [[Lifecycle Hooks]] — 형제 Create Components 기초 주제.
- [[컴포넌트 접근성 (ARIA·label)]] — 형제 Create Components: ID↔ARIA 링크는 별도 템플릿 간 shadow DOM 제약으로 light DOM이 필요(스코핑 관련).
- [[LWC MOC]] — LWC 섹션 전체 목차.
