---
tags: [lwc, create-components, slots, composition, reference]
source: developer.salesforce.com/docs/platform/lwc/guide/create-components-slots.html · reference-directives.html · create-light-dom.html (Tier 2)
created: 2026-07-08
aliases: [slot, slots, named slot, scoped slot, lwc:slot-data, lwc:slot-bind, slotchange, 슬롯, 네임드 슬롯, 스코프드 슬롯, 마크업 전달]
---

# LWC Slots (기본·named·scoped)

> `<slot>`은 **부모가 자식의 body로 넘긴 마크업이 들어갈 자리표시자**다. 이름 없는 default slot, `name`으로 구분하는 named slot, 자식 데이터를 부모 프래그먼트로 넘기는 scoped slot 세 가지가 있다.

---

## 1. slot이란 — 부모 → 자식 마크업 전달

컴포넌트는 slot을 0개 이상 가질 수 있다. 부모가 `<c-child>` 태그 **사이(body)**에 넣은 마크업이 자식 템플릿의 `<slot>` 위치로 삽입된다.

```html
<!-- 자식: c-slot-demo.html -->
<template>
    <h1>제목</h1>
    <slot></slot>   <!-- 부모가 넘긴 마크업이 여기로 -->
</template>
```

```html
<!-- 부모 -->
<template>
    <c-slot-demo>
        <p>이 문단이 자식의 &lt;slot&gt; 자리에 들어간다</p>
    </c-slot-demo>
</template>
```

핵심: slot은 **컴파일 타임이 아니라 런타임**에 채워진다. 부모가 아무것도 넘기지 않으면 slot 자리는 비거나 fallback(아래 4절)이 렌더된다.

---

## 2. Named slots — 여러 slot을 이름으로 구분

`name` 속성으로 슬롯을 구분한다. 부모는 자식으로 넘기는 요소에 `slot="이름"`을 붙여 대상 슬롯을 지정한다.

```html
<!-- 자식: c-named-slots.html -->
<template>
    <slot name="firstName"></slot>
    <slot name="lastName"></slot>
    <slot></slot>            <!-- 이름 없는 default slot -->
</template>
```

```html
<!-- 부모 -->
<c-named-slots>
    <span slot="firstName">Willy</span>
    <span slot="lastName">Wonka</span>
    <span>Chocolatier</span>   <!-- slot 속성 없음 → default slot으로 -->
</c-named-slots>
```

| slot 종류 | 자식 선언 | 부모 지정 | 개수 권장 |
|---|---|---|---|
| default(unnamed) | `<slot></slot>` | `slot` 속성 없이 | 보통 0~1개 |
| named | `<slot name="x">` | `slot="x"` | 여러 개 |

- default slot을 여러 개 두면 부모가 넘긴 마크업이 **모든** unnamed slot에 복제 삽입된다 — 그래서 보통 default slot은 0개나 1개만 둔다.
- `slot` 속성 값은 **동적 값(변수)** 을 넣어 문자열로 강제할 수 있다. 반면 자식 `<slot>`의 `name` 속성에는 **반드시 정적 문자열**을 넣어야 한다.

---

## 3. Slotted 콘텐츠는 부모 스코프에 속한다 (스타일·이벤트)

slot으로 넘긴 DOM은 자식의 shadow tree **바깥**, 즉 부모 소유로 남는다. 이 규칙은 세 가지 결과를 낳는다.

| 영역 | 규칙 |
|---|---|
| 스타일 | slotted 요소의 스타일은 **부모 컴포넌트의 CSS**가 적용된다. 자식 CSS는 slot 내용에 닿지 않는다. |
| 이벤트/로직 | slotted 요소의 이벤트 핸들러·바인딩은 **부모** 컨텍스트에서 동작한다. |
| DOM 접근 | slotted 요소는 자식 shadow tree 밖이므로 자식에서 `this.template.querySelector()`로 못 잡는다. `this.querySelector()` / `this.querySelectorAll()`를 쓴다. `id` 셀렉터는 피한다 — id 값은 전역 고유 값으로 변환될 수 있다. |

```javascript
// 자식 JS — slotted 콘텐츠 접근
// this.template.querySelector(...)  ❌ shadow tree만 검색
this.querySelector('span');          // ✅ light DOM(slotted 포함) 검색
```

---

## 4. Fallback(기본) 콘텐츠

`<slot>` 안에 넣은 마크업은 **부모가 아무것도 넘기지 않았을 때만** 렌더되는 기본값이다.

```html
<!-- 자식 -->
<template>
    <slot name="title">
        <!-- 구조 예시 — 부모가 slot="title"을 안 넘기면 이 h2가 렌더 -->
        <h2>제목 없음</h2>
    </slot>
</template>
```

부모가 `slot="title"` 요소를 넘기면 fallback은 대체된다.

---

## 5. slotchange 이벤트

모든 `<slot>`은 `slotchange` 이벤트를 지원한다. **slot의 직계 자식(node)이 바뀔 때** 발생한다.

```html
<!-- 자식 템플릿 -->
<slot onslotchange={handleSlotChange}></slot>
```

```javascript
handleSlotChange(e) {
    // slot에 들어온 직계 자식이 추가·제거·교체되면 호출
    console.log('slot assigned nodes changed', e.target.name);
}
```

주의: **slot 자식의 "내부" 변경(자손 트리 변경)은 `slotchange`를 트리거하지 않는다.** 직계 자식 노드 자체가 바뀔 때만 발생.

---

## 6. Scoped slots — 자식 데이터를 부모 프래그먼트로 넘기기

일반 slot은 부모 → 자식 단방향(마크업 전달)이다. **scoped slot**은 자식이 반복(loop) 등에서 만든 **데이터를 부모가 정의한 마크업 프래그먼트로 되돌려** 넘긴다. 자식은 루프 로직을, 부모는 각 항목의 렌더 모양을 담당한다.

두 directive를 함께 쓴다:

| directive | 붙이는 곳 | 값 | 역할 |
|---|---|---|---|
| `lwc:slot-bind` | **자식**의 `<slot>` | 자식 데이터 변수 (`={item}`) | slot에 데이터를 바인딩 |
| `lwc:slot-data` | **부모**의 `<template>` | 문자열 리터럴 (`="row"`) | 바인딩된 데이터를 받을 지역 변수 이름 |

```html
<!-- 자식: light DOM 필수. c-list.html -->
<template>
    <template for:each={items} for:item="item">
        <!-- 구조 예시 — 각 item을 scoped slot으로 부모에 바인딩 -->
        <slot lwc:slot-bind={item} key={item.id}></slot>
    </template>
</template>
```

```html
<!-- 부모: 자식이 넘긴 데이터를 "row"로 받아 렌더 -->
<c-list>
    <template lwc:slot-data="row">
        <span>{row.id} - {row.name}</span>
    </template>
</c-list>
```

named scoped slot이면 `name`/`slot`을 함께 붙인다: 자식 `<slot name="cell" lwc:slot-bind={item}>`, 부모 `<template lwc:slot-data="row" slot="cell">`.

### scoped slot 제약

- **자식은 반드시 light DOM.** shadow DOM에서는 scoped slot 미지원.
- `<template lwc:slot-data>`는 커스텀 엘리먼트의 **직계 자식**이어야 한다.
- `<template>` 하나에 `lwc:slot-data`는 **한 번만**. `<slot>` 하나에 `lwc:slot-bind`도 **한 번만** — scoped slot은 **단일 데이터 소스**에만 바인딩.
- `lwc:slot-data`의 문자열과 `lwc:slot-bind`가 바인딩한 변수명은 **같을 필요 없다** (부모가 원하는 지역 변수명으로 받는다).

---

## 7. 조건부 slot·shadow 경계 제약

| 제약 | 내용 |
|---|---|
| 조건부 렌더 | slot을 조건부로 넣을 땐 `<template lwc:if / lwc:elseif / lwc:else>`로 감싼다. **레거시 `if:true`/`if:false`는 중복 slot 컴파일 경고**를 낸다. |
| Aura → LWC slot | **Aura 컴포넌트를 LWC slot에 넘길 수 없다.** Aura 안에 중첩된 LWC도 slot으로 넘길 수 없다. |
| shadow 경계 | slotted 콘텐츠는 자식 shadow tree 밖(부모 소유)이라 자식 CSS·`this.template` 검색이 닿지 않는다(3절 참조). |
| default slot 중복 | unnamed slot을 여러 개 두면 부모 마크업이 모든 곳에 복제된다 — 의도치 않은 중복 주의. |

---

## 관련 노트

- Container/Presentational 분리와 slot을 합친 재사용 컴포넌트 설계 → [[컴포지션 패턴]]
- LWC 섹션 전체 목차 → [[LWC MOC]]
