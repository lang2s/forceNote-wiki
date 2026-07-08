---
tags: [SLDS, Lightning-Design-System, LWC, CSS, Styling-Hooks, Dark-Mode, SLDS2, Design-Tokens]
source: lightningdesignsystem.com — SLDS 2 · Global Styling Hooks · Dark Mode(Beta) · developer.salesforce.com "Style Components Using SLDS" (Tier 2)
created: 2026-05-23
aliases: [SLDS, SLDS 2, Lightning Design System, LWC 디자인 시스템, 스타일링 훅, CSS Styling Hook, 다크 모드]
---

# SLDS / LWC 디자인 시스템

> Salesforce Lightning Design System — LWC의 시각적 일관성을 제공하는 CSS 프레임워크, SLDS 2에서 CSS Styling Hook 기반으로 전환

> [!info] 출처 · Tier 2 (공식 웹 대조 완료)
> [SLDS 2](https://www.lightningdesignsystem.com/2e1ef8501/p/50ca07-slds-2) · [Global Styling Hooks](https://www.lightningdesignsystem.com/2e1ef8501/p/591960-global-styling-hooks) · [Style Components Using SLDS](https://developer.salesforce.com/docs/platform/lwc/guide/create-components-css-slds.html) · [SLDS Styling Hooks](https://developer.salesforce.com/docs/platform/lwc/guide/create-components-css-custom-properties.html) · 다크모드 [Use Dark Mode (Beta)](https://help.salesforce.com/s/articleView?id=release-notes.rn_slds_dark_mode_beta.htm) 대조. 토큰 스케일 상세는 [[SLDS 글로벌 스타일링 훅 토큰 레퍼런스]] 참조.

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

> [!note] 컴포넌트 훅(`--slds-c-*`) vs 글로벌 훅(`--slds-g-*`)
> 위 `--slds-c-*`는 **컴포넌트 레벨 훅**으로, 공식적으로는 **SLDS 1 방식**이며 SLDS 2(Cosmos) 테마에서는 지원되지 않는다. **SLDS 2 권장 경로는 앱 전역 디자인 토큰인 글로벌 훅 `--slds-g-*`** 다(색·간격·타이포가 색 모드·밀도·브랜드에 런타임 반응). 컴포넌트 커스터마이징도 SLDS 2에서는 글로벌 훅 참조로 수렴한다 → [[SLDS 스타일링 훅]] · [[SLDS 글로벌 스타일링 훅 토큰 레퍼런스]].

### Global Design Token (SLDS 2)

```css
/* SLDS 2 전역 토큰 — --slds-g-* 접두사 (스케일은 이름이 아닌 숫자 인덱스) */
.my-element {
  /* 색상 토큰 — 시맨틱(surface/on-surface) · 시스템색(brand-base-{명도}) · 팔레트(neutral-{명도}) */
  color: var(--slds-g-color-on-surface-1);
  background-color: var(--slds-g-color-surface-container-1);
  
  /* 간격 토큰 — 4pt 그리드 숫자 스케일 (4 = 1rem/16px, 2 = 0.5rem/8px) */
  padding: var(--slds-g-spacing-4);
  margin-bottom: var(--slds-g-spacing-2);
  
  /* 폰트 토큰 — 크기는 font-scale, 굵기는 숫자(7 = 700 Bold) */
  font-size: var(--slds-g-font-scale-5);      /* 28px */
  font-weight: var(--slds-g-font-weight-7);   /* 700 Bold */
  
  /* 테두리 토큰 — 두께는 sizing-border, 색은 color-border, 둥글기는 radius-border 숫자 */
  border-radius: var(--slds-g-radius-border-2);
  border: var(--slds-g-sizing-border-1) solid var(--slds-g-color-border-1);
}
```

> 위 토큰은 이름(small/medium/large)이 아니라 **숫자 인덱스** 스케일을 쓴다(spacing 1–12, sizing 1–16, font-weight 1–7 …). 전체 스케일·정확한 값은 [[SLDS 글로벌 스타일링 훅 토큰 레퍼런스]].

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

SLDS 2에서 다크 모드 지원이 **Winter '26 Beta**로 출시되었다(처음엔 Starter 계열, 이후 Sales·Service Cloud로 점진 롤아웃). 관리자가 조직 레벨에서 허용하면 사용자가 아바타 메뉴에서 라이트/다크를 토글한다.

> [!tip] 정석은 조건 CSS가 아니라 글로벌 훅
> 다크모드 대응의 공식 권장 경로는 아래처럼 손으로 색 모드를 분기하는 것이 아니라, **하드코딩 색을 `--slds-g-color-surface-*` / `--slds-g-color-on-surface-*` 글로벌 훅으로 교체**하는 것이다. 이 훅들은 현재 색 모드에 맞춰 값을 **런타임에 스스로 해석**하므로 컴포넌트마다 `@media` 분기가 필요 없다. 설정·검증 절차 전체는 [[SLDS 2 테마·다크모드·밀도]] 참조.

```css
/* 권장: 하드코딩·조건분기 대신 색 모드에 스스로 반응하는 글로벌 훅 */
.container {
  background-color: var(--slds-g-color-surface-container-1, var(--lwc-colorBackgroundAlt));
  color: var(--slds-g-color-on-surface-1);
  border-color: var(--slds-g-color-border-1);
}
```

```css
/* 훅을 못 쓰는 커스텀 영역에서만: 팔레트 색(neutral-{명도})으로 수동 분기 */
:host {
  --my-bg: var(--slds-g-color-neutral-100);   /* 밝은 표면 */
  --my-text: var(--slds-g-color-neutral-10);  /* 어두운 텍스트 */
}
@media (prefers-color-scheme: dark) {
  :host {
    --my-bg: var(--slds-g-color-neutral-10);
    --my-text: var(--slds-g-color-neutral-100);
  }
}
```

---

## 밀도 인식 Styling Hook (Density-Aware)

SLDS 2는 사용자가 고르는 두 표시 밀도(**Comfy** 기본 · **Compact**)를 제공한다. 밀도에 따라 값이 자동 축소되는 **variable spacing 훅** `--slds-g-spacing-var-*` 계열을 쓰면 컴포넌트가 comfy/compact에 저절로 반응한다(일반 `--slds-g-spacing-*`는 밀도 비대응 고정 간격).

```css
/* 밀도 대응: 고정 간격 대신 variable spacing 훅 사용 */
.form-element {
  /* 밀도 설정(comfy/compact)에 따라 자동으로 간격 조정 */
  padding-inline: var(--slds-g-spacing-var-inline-4);  /* 가로 — 밀도에 따라 축소 */
  padding-block: var(--slds-g-spacing-var-block-4);    /* 세로 — 밀도에 따라 축소 */
  gap: var(--slds-g-spacing-var-2);                    /* 모든 방향 균등 */
}
```

> 밀도 대응 훅의 축별 패턴(`-var-*` / `-var-inline-*` / `-var-block-*`)과 Comfy/Compact 정의는 [[SLDS 2 테마·다크모드·밀도]]에 상세.

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

> **SLDS 2 심화 문서:** [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]] — 유틸리티·패턴·접근성·블루프린트 전체

- [[SLDS 유틸리티 클래스 레퍼런스]] — 유틸리티 클래스 24개 카테고리 전수 (위 "빠른 참조"의 심화)
- [[SLDS 스타일링 훅]] — `--slds-*` CSS 커스텀 속성 개념·글로벌 vs 컴포넌트 훅
- [[SLDS 글로벌 스타일링 훅 토큰 레퍼런스]] — `--slds-g-*` 전역 토큰 카탈로그(spacing/sizing/radius/font/color 정확한 스케일 값)
- [[SLDS 2 테마·다크모드·밀도]] — Cosmos 테마 활성화·다크모드(Beta) 설정·Comfy/Compact 밀도 대응 절차
- [[SLDS 아이콘 시스템 레퍼런스]] — 5개 스프라이트 셋·`slds-icon` 클래스·SVG `<use>` 마크업·접근성 텍스트
- [[SLDS 접근성]] · [[SLDS 모범 사례]] · [[SLDS 개발 도구]] · [[SLDS 블루프린트 카탈로그]]
- [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]] — LWC + Vite + SLDS 1/2 로컬 프로토타이핑 공식 스타터킷(4부작 허브)
- [[design-system-react — SLDS React 컴포넌트 라이브러리]] — React on Salesforce(UI Bundle)에서 SLDS를 입히는 방법(LWC 베이스컴포넌트의 React 대응)
- [[Lightning Base Components 레퍼런스]]
- [[Toast & 모달 패턴]]
- [[LWC 보안 패턴]]
- [[lightning-tabset]]
- [[Spring '26/Development]] — v66.0 SLDS 2 dark mode 적응 베이스 컴포넌트(`lightning-empty-state` 등)
