---
tags: [SLDS, Lightning-Design-System, LWC, CSS, Styling-Hooks, Dark-Mode, SLDS2, Design-Tokens]
source: external-knowledge
created: 2026-05-23
aliases: [SLDS, SLDS 2, Lightning Design System, LWC 디자인 시스템, 스타일링 훅, CSS Styling Hook, 다크 모드]
---

# SLDS / LWC 디자인 시스템

> Salesforce Lightning Design System — LWC의 시각적 일관성을 제공하는 CSS 프레임워크, SLDS 2에서 CSS Styling Hook 기반으로 전환

> [!warning] 이 노트는 외부 지식 기반으로 작성되었으며 공식 소스와 대조되지 않았습니다.
> 공식 문서: https://www.lightningdesignsystem.com / https://developer.salesforce.com/docs/platform/lwc/guide/create-components-css.html

---

## 개념 설명

**Salesforce Lightning Design System(SLDS)**은 LWC와 Aura 컴포넌트에서 사용하는 CSS 프레임워크다. Salesforce의 시각적 언어(Visual Language)를 구현하며, 접근성·일관성·반응형 디자인을 제공한다.

### SLDS 1 vs SLDS 2

| 항목 | SLDS 1 | SLDS 2 (Winter '26 GA) |
|---|---|---|
| 커스터마이징 방식 | CSS 변수 (제한적) | CSS Styling Hook (완전 개방) |
| 다크 모드 | ❌ | ✅ (Beta, Winter '26) |
| 밀도 인식 | ❌ | ✅ (Density Styling Hooks) |
| 토큰 체계 | Design Tokens | CSS Custom Properties |
| 하위 호환 | — | ✅ (SLDS 1 클래스 유지) |

---

## CSS Styling Hooks (SLDS 2 핵심 기능)

CSS Styling Hook은 **CSS Custom Properties**를 통해 컴포넌트 스타일을 외부에서 변경할 수 있는 방법이다.

### 기본 사용법

```css
/* 컴포넌트 내부 CSS — Styling Hook 선언 */
:host {
  /* Hook 변수 정의 — 외부에서 덮어쓸 수 있음 */
  --slds-c-button-color-background: var(--slds-g-color-brand-base-50);
  --slds-c-button-color-border: transparent;
}

.my-button {
  background-color: var(--slds-c-button-color-background);
  border-color: var(--slds-c-button-color-border);
}
```

```css
/* 부모 컴포넌트에서 자식 컴포넌트 Styling Hook 덮어쓰기 */
c-my-button {
  --slds-c-button-color-background: #ff0000;
}
```

### Global Design Token (SLDS 2)

```css
/* SLDS 2 전역 토큰 — --slds-g-* 접두사 */
.my-element {
  /* 색상 토큰 */
  color: var(--slds-g-color-neutral-base-10);
  background-color: var(--slds-g-color-brand-base-95);
  
  /* 간격 토큰 */
  padding: var(--slds-g-spacing-medium);
  margin-bottom: var(--slds-g-spacing-small);
  
  /* 폰트 토큰 */
  font-size: var(--slds-g-font-size-5);
  font-weight: var(--slds-g-font-weight-bold);
  
  /* 테두리 토큰 */
  border-radius: var(--slds-g-radius-border-medium);
  border: var(--slds-g-border-2) solid var(--slds-g-color-border-base-1);
}
```

---

## SLDS 클래스 활용 (기존 SLDS 1 방식)

### 레이아웃 클래스

```html
<!-- Grid / Layout -->
<template>
  <div class="slds-grid slds-wrap">
    <div class="slds-col slds-size_1-of-2">Column 1</div>
    <div class="slds-col slds-size_1-of-2">Column 2</div>
  </div>

  <!-- 간격 -->
  <div class="slds-m-around_medium slds-p-around_small">
    Content with margin and padding
  </div>

  <!-- 텍스트 유틸리티 -->
  <p class="slds-text-heading_large slds-text-color_weak">Heading</p>
</template>
```

### 아이콘 사용

```html
<!-- SLDS 아이콘 (SVG sprite) -->
<template>
  <!-- lightning-icon 컴포넌트 권장 -->
  <lightning-icon icon-name="utility:add" size="small"></lightning-icon>
  
  <!-- 직접 SLDS 아이콘 SVG -->
  <span class="slds-icon_container slds-icon-utility-add">
    <svg class="slds-icon slds-icon-text-default" aria-hidden="true">
      <use href="/apexpages/slds/latest/assets/icons/utility-sprite/svg/symbols.svg#add"></use>
    </svg>
  </span>
</template>
```

### 버튼 스타일

```html
<template>
  <!-- 기본 버튼 -->
  <button class="slds-button slds-button_brand">Brand Button</button>
  <button class="slds-button slds-button_neutral">Neutral Button</button>
  <button class="slds-button slds-button_destructive">Destructive Button</button>
  
  <!-- 텍스트 버튼 -->
  <button class="slds-button">Default / Text Button</button>
  
  <!-- 아웃라인 버튼 -->
  <button class="slds-button slds-button_outline-brand">Outline Button</button>
</template>
```

---

## 다크 모드 (Dark Mode, Beta — Winter '26)

SLDS 2에서 다크 모드 지원이 Beta로 출시되었다.

```css
/* 다크 모드 대응 — CSS Styling Hook 활용 */
:host {
  /* 라이트 모드 기본값 */
  --my-bg: var(--slds-g-color-neutral-base-100);
  --my-text: var(--slds-g-color-neutral-base-10);
}

/* 다크 모드 자동 적용 (시스템 설정 따름) */
@media (prefers-color-scheme: dark) {
  :host {
    --my-bg: var(--slds-g-color-neutral-base-10);
    --my-text: var(--slds-g-color-neutral-base-100);
  }
}

.container {
  background-color: var(--my-bg);
  color: var(--my-text);
}
```

---

## 밀도 인식 Styling Hook (Density-Aware)

Winter '26에서 밀도 인식(compact/comfortable/spacious) 스타일링 지원:

```css
/* 밀도 토큰 활용 */
.form-element {
  /* 밀도 설정에 따라 자동으로 간격 조정 */
  padding: var(--slds-g-spacing-density-compact, var(--slds-g-spacing-small));
  margin-bottom: var(--slds-g-spacing-density-comfortable, var(--slds-g-spacing-medium));
}
```

---

## LWC에서 SLDS 적용 규칙

### CSS 격리 (Shadow DOM)

```javascript
// LWC 컴포넌트는 Shadow DOM으로 CSS가 격리됨
// ❌ 외부에서 내부 클래스 직접 선택 불가
.parent-component .child-element { color: red; } /* 동작 안 함 */

// ✅ CSS Custom Properties (Styling Hook)로만 외부 제어 가능
.parent-component { --my-hook-color: red; }
```

### 글로벌 스타일 적용 (light DOM)

```javascript
// lwc:ref를 사용하는 방식이나 light DOM 컴포넌트는 전역 CSS 적용 가능
// js-meta.xml
```

```xml
<!-- js-meta.xml -->
<LightningComponentBundle xmlns="...">
    <renderMode>light</renderMode>  <!-- light DOM: 전역 CSS 접근 가능 -->
    ...
</LightningComponentBundle>
```

---

## SLDS Utility 클래스 빠른 참조

| 분류 | 클래스 예시 | 설명 |
|---|---|---|
| **Margin** | `slds-m-top_medium` | 위쪽 margin medium |
| **Padding** | `slds-p-around_small` | 전체 padding small |
| **Text** | `slds-text-heading_large` | 대형 헤딩 텍스트 |
| **Color** | `slds-text-color_weak` | 약한 색상 텍스트 |
| **Grid** | `slds-grid slds-wrap` | 그리드 컨테이너 |
| **Column** | `slds-col slds-size_1-of-2` | 1/2 폭 컬럼 |
| **Hide** | `slds-hide` | 숨기기 |
| **Show** | `slds-show` | 표시 |
| **Truncate** | `slds-truncate` | 긴 텍스트 말줄임 |
| **Align** | `slds-align_absolute-center` | 절대 중앙 정렬 |

---

## 비교표 (스타일링 방법 선택)

| 방법 | 사용 시기 | 권장도 |
|---|---|---|
| SLDS 유틸리티 클래스 | 레이아웃·간격·타이포그래피 | ✅ 권장 |
| CSS Styling Hook | 컴포넌트 테마 커스터마이징 | ✅ SLDS 2 권장 |
| Design Token 변수 | 전역 색상·폰트 재정의 | ✅ 권장 |
| 직접 CSS 작성 | 컴포넌트 내부 커스텀 UI | ✅ (컴포넌트 내부만) |
| `!important` 남용 | — | ❌ 금지 |
| 전역 CSS로 Shadow DOM 관통 | — | ❌ 금지 |

---

## 관련 노트
- [[Lightning Base Components 레퍼런스]]
- [[Toast & 모달 패턴]]
- [[LWC 보안 패턴]]
- [[lightning-tabset]]
