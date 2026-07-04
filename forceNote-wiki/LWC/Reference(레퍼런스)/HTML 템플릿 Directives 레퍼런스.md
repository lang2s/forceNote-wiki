---
tags: [lwc, reference, html-template, directives, lwc-if, for-each, iterator, slots, lwc-ref]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Reference > HTML Template Directives + Dynamic Event Listeners Considerations; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/reference-directives.html
created: 2026-07-04
aliases: [LWC directives, HTML template directives, lwc:if, lwc:elseif, lwc:else, if:true, for:each, for:item, for:index, iterator, key, lwc:ref, lwc:dom, lwc:spread, lwc:on, lwc:slot-data, lwc:slot-bind, lwc:is, lwc:component, 조건 렌더링, 리스트 렌더링, 슬롯, dynamic event listeners, 동적 이벤트 리스너, lwc:on 고려사항]
---

# HTML 템플릿 Directives 레퍼런스

> LWC HTML 템플릿에 동적 동작(조건·리스트 렌더링, 슬롯, DOM 참조 등)을 더하는 특수 속성(directive) 전수 레퍼런스 — root `<template>`·중첩 `<template>`·HTML 요소의 **사용 위치별로 지원 directive가 다르다.**

---

## 개요

**directive**는 HTML 템플릿에 동적 동작을 부여하는 특수 속성이다. 어디에 붙일 수 있는지가 위치별로 정해져 있으며, 크게 4구획으로 나뉜다:

1. **Root 태그** (`<template>` 최상위)
2. **중첩 `<template>`** (리스트·조건 렌더링)
3. **`<template>` 슬롯** (scoped slot 데이터 바인딩)
4. **HTML 요소** (`<p>`·base component·커스텀 컴포넌트)

아래 각 구획별로 지원 directive를 전수 정리한다. 위치별 지원 매트릭스는 맨 아래 [요약표](#위치별-지원-요약표)를 참조한다.

---

## 1. Root 태그 (`<template>` 최상위) 지원 directive

컴포넌트 템플릿의 최상위 `<template>` 태그에 붙일 수 있는 directive.

| directive | 동작 |
|---|---|
| **`lwc:preserve-comments`** | HTML 주석을 DOM에 렌더한다(예: IE conditional comments 디버깅). ⚠️ 활성 시 형제 조건 directive(`lwc:if` 등) 사이에 주석을 배치할 수 없다. |
| **`lwc:render-mode`** | 컴포넌트를 light DOM으로 렌더한다. 서드파티 도구가 표준 `querySelector`로 DOM을 순회할 수 있게 된다. → light DOM 활성화. |

```html
<!-- 구조 예시 — root <template>에 directive 적용 -->
<template lwc:render-mode="light" lwc:preserve-comments>
    <!-- 이 주석이 DOM에 렌더됨 -->
</template>
```

---

## 2. 중첩 `<template>` 지원 directive

리스트 렌더링과 조건 렌더링에 쓰이는 중첩(nested) `<template>` 태그의 directive.

### 2-1. 리스트 렌더링

- **`for:each={array}`** — 배열을 반복 렌더한다. 중첩 `<template>`·HTML 요소와 함께 사용한다.
- **`for:item="currentItem"`** — 현재 항목에 접근한다. placeholder(`currentItem`)는 현재 스코프에 주입되는 식별자다.
- **`for:index="index"`** — 현재 항목의 0-기반 인덱스. placeholder(`index`)는 스코프에 주입되는 새 식별자다.
- **`iterator:iteratorname={array}`** — 배열을 반복하되 첫/마지막 항목에 특수 동작을 준다. `iteratorname`은 아래 4개 프로퍼티를 가진다:

| iterator 프로퍼티 | 의미 |
|---|---|
| `value` | 리스트 항목 값. 배열 프로퍼티 접근은 `iteratorname.value.propertyName` |
| `index` | 항목 인덱스 |
| `first` | 첫 항목이면 `true` (boolean) |
| `last` | 마지막 항목이면 `true` (boolean) |

```html
<!-- 구조 예시 — for:each + key -->
<template for:each={contacts} for:item="contact" for:index="idx">
    <li key={contact.Id}>{idx}: {contact.Name}</li>
</template>

<!-- 구조 예시 — iterator (first/last 특수 동작) -->
<template iterator:it={contacts}>
    <li key={it.value.Id}>
        <div if:true={it.first} class="list-first"></div>
        {it.value.Name}
        <div if:true={it.last} class="list-last"></div>
    </li>
</template>
```

> `key`는 각 항목에 고유 식별자를 부여하는 HTML 요소 directive다 — 상세는 [HTML 요소 구획](#4-html-요소p·base-component·커스텀-컴포넌트-지원-directive)의 `key` 참조.

### 2-2. 조건 렌더링

#### ⚠️ `if:true|false={expression}` — 더 이상 권장 안 함

- `if:true|false={expression}`는 **더 이상 권장되지 않는다**(향후 deprecated·제거 가능). 대신 `lwc:if`/`lwc:elseif`/`lwc:else`를 사용한다.
- expression은 JS 식별자 또는 dot 표기(`person.firstName`)만 가능하다. computed expression(`person[2].name['John']`)은 **불가** → getter를 사용한다.

#### `lwc:if` / `lwc:elseif` / `lwc:else` — 권장 조건 directive

`if:true`/`if:false`를 **대체(supersede)** 하는 조건 렌더 directive. 중첩 `<template>`·`<div>` 등 HTML 요소·커스텀 컴포넌트(`<c-custom-cmp>`)에 사용할 수 있다. 규칙 전수:

1. **형제 선행 규칙** — `lwc:elseif`·`lwc:else`는 **바로 앞에 형제 `lwc:if` 또는 `lwc:elseif`**가 와야 한다.
2. **expression 요구** — `lwc:if`·`lwc:elseif`는 expression 평가가 필수다. `lwc:else`는 **속성 값이 없어야** 한다.
3. **단순 dot 표기만** — expression은 단순 dot 표기만 허용한다. 복잡 식(`!condition`, `object?.property?.condition`, `sum % 2 === 1`)은 **불가** → getter를 사용한다.
4. **인스턴스당 1회 접근** — expression·property getter는 `lwc:if`/`lwc:elseif` 인스턴스당 **1회만** 접근된다.
5. **앞 텍스트 불가** — `lwc:elseif`·`lwc:else` 앞에 텍스트나 다른 요소가 올 수 없다(태그 사이 whitespace는 무시됨).
6. **주석 제약** — 조건 directive 형제로 코드 주석은 `lwc:preserve-comments`가 **비활성일 때만** 가능하다.
7. **falsy 체크** — getter 반환값에 부정 연산자를 적용해 expression이 `true`가 되도록 getter를 만든다.
8. **결합 불가** — `lwc:if`/`elseif`/`else`는 같은 요소에 동시 적용 불가이며, `if:true`/`if:false`와도 **결합 불가**다.

```html
<!-- 구조 예시 — lwc:if / lwc:elseif / lwc:else -->
<template lwc:if={isTemplateOne}>
    <p>Template One</p>
</template>
<template lwc:elseif={isTemplateTwo}>
    <p>Template Two</p>
</template>
<template lwc:else>
    <p>Fallback Template</p>
</template>
```

---

## 3. `<template>` 슬롯 directive (scoped slot)

scoped slot에서 부모↔자식 간 데이터를 바인딩하는 directive.

- **`lwc:slot-data`** — 부모의 `<template>` 요소에 추가한다(scoped slot fragment). 값은 **문자열 리터럴**이다. 커스텀 요소(`<c-child>`)의 **직접 자식**이어야 하며, `<template>`당 **1개만** 가능하다.
- **`lwc:slot-bind`** — 자식의 `<slot>` 요소에 추가해 scoped slot에 데이터를 바인딩한다. 값은 **변수명**이다. **light DOM 요소의 HTML에서만** 쓸 수 있고, `<slot>`당 **1개만** 가능하다.
- `lwc:slot-data`의 문자열 리터럴과 `lwc:slot-bind` 변수는 이름이 같을 필요가 없다.

```html
<!-- 구조 예시 — scoped slot 데이터 바인딩 -->
<!-- 부모 템플릿 -->
<c-child>
    <template lwc:slot-data="scopedData">
        <p>{scopedData.name}</p>
    </template>
</c-child>

<!-- 자식(light DOM) 템플릿 -->
<slot lwc:slot-bind={itemData}></slot>
```

---

## 4. HTML 요소(`<p>`·base component·커스텀 컴포넌트) 지원 directive

일반 HTML 태그·base component·커스텀 컴포넌트에 붙일 수 있는 directive.

| directive | 동작 |
|---|---|
| **`lwc:if` / `lwc:elseif` / `lwc:else`** | HTML 태그에도 조건 렌더 지원(위 [2-2 규칙](#lwcif--lwcelseif--lwcelse--권장-조건-directive) 동일). |
| **`for:item={currentItem}` / `for:index={index}`** | 반복 항목·인덱스 접근. |
| **`iterator`** | 첫/마지막 항목 특수 동작. |
| **`key={id}`** | 리스트 각 항목에 고유 식별자 부여(렌더 성능↑). ⚠️ `key`는 **문자열 또는 숫자**여야 한다(객체 불가). 엔진이 key로 변경 항목을 판별한다. |
| **`lwc:dom="manual"`** | 네이티브 HTML 요소에 추가해 owner JS에서 `appendChild()`를 호출할 수 있게 한다. ⚠️ `appendChild()`로 DOM 조작 시 append된 요소에는 **스타일이 미적용**된다. |
| **`lwc:external`** | 서드파티 web component/커스텀 요소를 네이티브 web component로 렌더한다(Third-Party Web Components Beta). |
| **`lwc:on={eventHandlers}`** | 요소에 이벤트 리스너를 동적 추가한다. `eventHandlers` 객체의 각 프로퍼티로 리스너를 설정한다. |
| **`lwc:ref="myDiv"`** | selector 없이 DOM 요소 위치를 지정한다(지정 template 내에서만 query). `this.refs.myDiv`로 접근. ⚠️ shadow DOM의 `this.template.querySelector()`·light DOM의 `this.querySelector()`보다 **`this.refs` 사용이 권장**된다. |
| **`lwc:spread={childProps}`** | 자식 컴포넌트에 프로퍼티를 전개한다(객체를 프로퍼티로 바인딩). 자식 컴포넌트에 프로퍼티로 적용되며, 요소당 **1개만** 가능하다. |
| **`<lwc:component>` + `lwc:is`** | 컴포넌트를 동적 인스턴스화한다(managed element). |

```html
<!-- 구조 예시 — lwc:ref (selector 없이 DOM 참조) -->
<template>
    <div lwc:ref="myDiv">Hello</div>
</template>
```

```javascript
// 구조 예시 — lwc:ref 접근 (실제 동작 코드 아님)
export default class extends LightningElement {
    renderedCallback() {
        const el = this.refs.myDiv; // querySelector보다 권장
    }
}
```

### lwc:on 고려사항 (동적 이벤트 리스너)

`lwc:on={eventHandlers}`로 이벤트 리스너를 동적으로 다룰 때 지켜야 할 규칙.

- ⚠️ **`lwc:on`에 전달한 변수가 참조하는 객체를 mutate(변형)하는 것은 허용되지 않는다.** 리스너를 바꾸려면 프로퍼티를 직접 수정하지 말고 객체를 **새 객체로 재할당**한다.
- **재할당(reassignment)은 허용**되며, 이전 객체와 새 객체의 프로퍼티 차이로 리스너가 다음과 같이 반영된다:

| 프로퍼티 상태 (이전 → 새 객체) | 이벤트 리스너 동작 |
|---|---|
| 이전에는 있었으나 새 객체에서 **누락** | 해당 리스너 **제거(remove)** |
| 이전에는 없었으나 새 객체에 **존재** | 해당 리스너 **추가(add)** |
| **양쪽 객체 모두**에 존재 | 해당 리스너 **업데이트(update)** |

- 동적 이벤트 리스너 추가는 **`lwc:spread`보다 `lwc:on` 사용을 권장**한다.
- ⚠️ HTML 템플릿에서 **같은 이벤트 타입**에 `lwc:on`과 `onevent`(선언적 핸들러) 리스너를 함께 지정하면 **에러**가 발생한다.
- 반면 **같은 이벤트 타입**에 `lwc:on`과 `lwc:spread`로 둘 다 리스너를 지정하면 → **두 리스너 모두 attach**된다.

**동적 컴포넌트 조합** — 동적으로 로드한 컴포넌트에 프로퍼티를 설정하고 이벤트 리스너를 attach하려면 세 directive를 함께 쓴다:

- **`lwc:component` + `lwc:is`** — 컴포넌트를 동적으로 로드한다.
- **`lwc:spread`** — 전달할 프로퍼티를 지정한다.
- **`lwc:on`** — attach할 이벤트 리스너를 지정한다.

```javascript
// 구조 예시 — lwc:on 리스너 재할당 (실제 동작 코드 아님)
export default class extends LightningElement {
    // ❌ mutate 금지: this.eventHandlers.click = ... (직접 변형 불가)
    // ✅ 새 객체로 재할당
    updateListeners() {
        this.eventHandlers = { ...this.eventHandlers, focus: this.handleFocus };
    }
}
```

```html
<!-- 구조 예시 — lwc:on + lwc:spread로 동적 컴포넌트에 프로퍼티·리스너 -->
<lwc:component lwc:is={componentCtor} lwc:spread={childProps} lwc:on={eventHandlers}></lwc:component>
```

---

## 위치별 지원 요약표

| directive | root `<template>` | 중첩 `<template>` | HTML 요소 |
|---|---|---|---|
| `lwc:preserve-comments` | ✅ | | |
| `lwc:render-mode` | ✅ | | |
| `for:each` / `for:item` / `for:index` | | ✅ | ✅ (`for:item`·`for:index`) |
| `iterator:name` | | ✅ | ✅ |
| `if:true\|false` (비권장) | | ✅ | ✅ |
| `lwc:if` / `lwc:elseif` / `lwc:else` | | ✅ | ✅ |
| `lwc:slot-data` | | ✅ | |
| `lwc:slot-bind` (slot) | | | ✅ (`<slot>`) |
| `key` | | | ✅ |
| `lwc:dom="manual"` | | | ✅ |
| `lwc:external` | | | ✅ |
| `lwc:on` | | | ✅ |
| `lwc:ref` | | | ✅ |
| `lwc:spread` | | | ✅ |
| `lwc:is` (`<lwc:component>`) | | | ✅ |

---

## See Also (공식 문서 위임)

directive의 실사용 how-to는 LWC Dev Guide의 아래 create-* 페이지에 위임된다: Use HTML Templates · Render Lists · Render DOM Elements Conditionally · Dynamically Instantiate Components.

---

## 관련 노트
- [[LWC 개요 (Get Started)]] — LWC 상위 진입점
- [[LWC MOC]] — LWC 섹션 전체 목차
