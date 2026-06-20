---
tags: [lwc, lwr, experience-cloud, branding, dxp-styling-hooks, css-custom-properties, theme-panel, reference]
source: exp_cloud_lwr.pdf (LWR Sites for Experience Cloud, v66.0 Spring '26, Tier 2) — Chapter 4 "Brand Your LWR Site"
official_doc: https://developer.salesforce.com/docs/atlas.en-us.exp_cloud_lwr.meta/exp_cloud_lwr/
created: 2026-06-20
aliases: [--dxp styling hooks, dxp 스타일링 훅, --dxp-g, --dxp-s, --dxp-c, LWR 브랜딩, Theme Panel 매핑, Theme 패널 속성 매핑, Site Logo 훅, Custom Fonts LWR, 커스텀 폰트, Remove SLDS, Color Palette, Button Colors 훅, Override Component Branding, part dxp]
---

# LWR `--dxp` 스타일링 훅 레퍼런스

> LWR 사이트의 `--dxp` 스타일링 훅 전수 레퍼런스 — Color/Text/Site Spacing 훅, Theme 패널 속성 매핑 lookup 표, 커스텀 컴포넌트 적용·CSS 오버라이드·Site Logo·Custom Fonts·Remove SLDS. (`exp_cloud_lwr.pdf` Ch4 "Brand Your LWR Site")

> 📍 허브: [[LWR Sites (Experience Cloud)]] · 이 노트는 그 "브랜딩 — `--dxp` 스타일링 훅" 섹션의 전수 확장 spoke(Ch4). 반응형 `--dxp-c-screensize`/`--dxp-c-l/m/s-*` 훅은 [[LWR 컴포넌트 개발 심화]](Ch3)가 담당.

---

## 개요 — `--dxp` 스타일링 훅이란

Lightning Web Runtime (LWR) design system을 사용하면 base 및 custom Lightning web component를 수정해 LWR 사이트 전체에 일관된 look & feel을 적용할 수 있다. 이 시스템은 Theme 패널의 속성에 매핑되는 `--dxp` 스타일링 훅을 사용해 사이트 전체에 브랜딩을 더 쉽게 적용하게 한다.

**What Are `--dxp` Styling Hooks?**
스타일링 훅은 CSS custom property를 사용한다 — selector의 스코프 내 모든 descendant로 cascade되는 CSS 내부 변수다. `--dxp` 스타일링 훅은 더 낮은 레벨의 컴포넌트 스타일링 훅에 매핑되는 *축약된 custom property 집합*으로, 단일 훅을 설정해 여러 개별 컴포넌트를 한 번에 변경할 수 있다. 이 훅들은 LWR 템플릿에 포함된 base component에서 사용되며, custom Lightning web component에서도 쓸 수 있어 사이트 전체를 훨씬 빠르게 브랜딩할 수 있다.

**What Are the Theme Panel Properties?**
Experience Builder의 Theme 패널은 사이트의 color·image·text·site spacing을 선언적으로 제어하는 여러 브랜딩 속성을 제공한다.
- **Colors 탭** — 메인 사이트 색상과 다른 color palette를 만들어 페이지의 특정 섹션에 적용.
- **Images 탭** — Salesforce CMS workspace에서 이미지를 선택해 로고나 browser icon(favicon) 생성.
- **Text 탭** — 모바일/데스크톱 사이트의 base font size 설정, dynamic font style·heading·decoration 선택(링크·버튼 포함 모든 텍스트 유형).
- **Site Spacing 탭** — 데스크톱/모바일 뷰의 maximum content width·section padding·section column·component spacing 조정.

### Theme 패널 속성과의 연동 — How Do They Work Together?

Theme 패널의 각 속성은 하나 이상의 `--dxp` 스타일링 훅에 매핑된다. Theme 패널에서 속성을 업데이트하면, 시스템이 그 속성에 연결된 훅을 사용하는 모든 Lightning web component를 자동으로 갱신한다.

예를 들어 Theme 패널의 브랜딩 속성을 사용하는 custom button 컴포넌트를 개발한다고 하자. 사이트의 Brand Color를 버튼 배경색으로 사용하려면 컴포넌트는 `--dxp-g-brand` 글로벌 스타일링 훅을 참조한다.

```css
// exp_cloud_lwr.pdf 발췌
.my-custom-button-component {
background-color: var(--dxp-g-brand);
color: var(--dxp-g-brand-contrast);
}
```

이제 사용자가 Theme 패널에서 Brand Color 속성을 업데이트할 때마다 시스템이 버튼 컴포넌트의 배경색을 즉시 갱신한다.

### `--dxp` 훅 vs `--slds` 훅 (네이밍: `-g` / `-s` / `-c`)

SLDS(Salesforce Lightning Design System)는 각 base component의 모습을 세밀하게 제어하는 많은 스타일링 훅을 제공한다. 예를 들어 `lightning-button` 컴포넌트는 `--slds-c-button-color-background` 훅으로 배경색을 바꾼다. 훅은 임의의 selector에 정의할 수 있다.

```html
<!-- exp_cloud_lwr.pdf 발췌 -->
<style>
/**
* Scoped to the root of the document and all its descendant elements.
*/
:root {
--slds-c-button-color-background: peachpuff;
}
/**
* Scoped to any element with the class applied and all its descendant elements
*/
.container {
--slds-c-button-color-background: peachpuff;
}
</style>
```

하지만 이 SLDS 방식으로 사이트 모든 컴포넌트(연관 variation·state 포함)에 브랜드를 정확히 반영하려면 종종 수백 개의 스타일링 훅 정의를 업데이트해야 한다.

대조적으로 `--dxp` 스타일링 훅은 더 낮은 레벨 컴포넌트 스타일링 훅에 매핑되는 *축약된 custom property 집합*이라, 단일 훅으로 여러 개별 컴포넌트를 한 번에 바꾼다. 예를 들어 `--dxp-g-brand` 훅 하나를 설정하면 버튼 배경색, 링크 색, focus 시 input border 색에 모두 영향을 준다.

훅 prefix 네이밍 규약(원문 철자 기준):

| Prefix | 의미 | 비고 |
|---|---|---|
| `--dxp-g-` | global | 사이트 광범위 변경에 사용 (예: `--dxp-g-brand`, `--dxp-g-root`) |
| `--dxp-s-` | settings | Theme 패널 속성에 매핑되는 세부 settings 훅 (예: `--dxp-s-text-heading-...`) |
| `--dxp-c-` | component | 컴포넌트/반응형 레벨 훅 — 본 노트 범위 밖, [[LWR 컴포넌트 개발 심화]] 참조 |

> Root는 컨테이너의 배경색이고 root-contrast가 전경색이다. 각 color pairing은 접근성을 위해 허용 가능한 contrast ratio를 유지해야 한다. 어떤 컨테이너든 스타일을 상속(default)하거나 새로 정의할 수 있다. 스코프된 컨테이너가 자체 root(배경색)를 설정하면, 새 root에 대해 접근성이 유지되도록 다른 모든 `--dxp` 훅을 재평가해야 한다.

> **Tip:** 사이트 컴포넌트 전반에 일반적인 변경을 줄 때는 `--dxp` 스타일링 훅 사용을 권장한다. 단 `--dxp` 브랜딩 default가 필요한 것을 정확히 제공하지 못하면, `--slds-c` 및 `--slds-g-color` 스타일링 훅으로 개별 컴포넌트의 모습을 미세조정할 수 있다.

---

## `--dxp` 스타일링 훅 활성화 (Enable)

Summer '21 *이전*에 만든 LWR 사이트라면, DXP 브랜딩 스타일시트를 사이트에 추가해 `--dxp` 스타일링 훅을 활성화한다.

> **Tip:** Summer '21 이후에 만든 새 LWR 사이트는 이 스타일시트를 자동으로 포함한다.

**Settings > Advanced > Edit Head Markup** 을 클릭하고 Head Markup 편집기에 다음 코드를 포함한다.

```html
<!-- exp_cloud_lwr.pdf 발췌 -->
<link rel="stylesheet" href="{ basePath }/assets/styles/salesforce-lightning-design-system.min.css?{ versionKey }" />
<link rel="stylesheet" href="{ basePath }/assets/styles/dxp-site-spacing-styling-hooks.min.css?{ versionKey }" />
<link rel="stylesheet" href="{ basePath }/assets/styles/dxp-styling-hooks.min.css?{ versionKey }" />
<link rel="stylesheet" href="{ basePath }/assets/styles/dxp-slds-extensions.min.css?{ versionKey }" />
```
<!-- PDF 원문 curly quote, 표준 따옴표로 정규화. `{ basePath }`·`{ versionKey }`는 원문 플레이스홀더 그대로. -->

> **Note:** `dxp-styling-hooks.min.css` 와 `dxp-slds-extension.min.css` 파일이 `salesforce-lightning-design-system.min.css` *이후*에 로드되도록 한다.

---

## `--dxp` 훅 기본 사용법

`--dxp` 스타일링 훅으로 단일 훅을 설정하면 Experience Cloud의 LWR 사이트 전반에서 base와 custom Lightning web component 둘 다에 영향을 준다.

### `:root` / `.container` 스코프

스타일링 훅은 CSS custom property이므로 어떤 selector에든 정의할 수 있다. 위 [활성화](#dxp-스타일링-훅-활성화-enable) 섹션의 4개 스타일시트 `<link>` 가 먼저 로드된 상태여야 한다(중복 인용 회피 — 스타일시트 블록은 활성화 섹션 정본).

- `:root` — 문서 root와 모든 descendant 요소에 스코프.
- `.container`(임의 클래스) — 해당 클래스가 적용된 요소와 모든 descendant에 스코프.

### `--dxp-g` 광범위 변경 + `--slds-c` 미세조정

`--dxp-g-` 훅으로 광범위한 변경을 하고, 필요한 곳에서만 `--slds-c-` 훅으로 미세조정하는 패턴이다.

```html
<!-- exp_cloud_lwr.pdf 발췌 — 4개 <link>는 위 '활성화' 섹션 참조(역참조), 아래는 <style> 블록 -->
<style>
.mycontainer {
/** Use --dxp-g to make broad changes **/
--dxp-g-root: #1a1b1e;
--dxp-g-root-contrast: #fff;
--dxp-g-brand: #5eb4ff;
--dxp-g-brand-contrast: #fff;
--dxp-g-neutral: #76716b;
--dxp-g-neutral-contrast: #fff;
/** Use --slds-c to fine-tune where necessary **/
--slds-c-button-color-background: peachpuff;
}
</style>
```

세 하위 영역(Color / Text / Site Spacing) 요약:
- **Color** — Experience Builder의 Colors 탭은 각각 특정 use case와 가능한 값의 scale을 가진 color family로 나뉜다. 페이지 전체 또는 섹션의 color 값을 조정할 수 있고, 한 color 값이 정의되면 다른 색들이 derive되어 개별 base component에 매핑된다.
- **Text** — heading·body·button·link·forms 텍스트의 스타일링을 쉽게 제어하는 광범위한 text 브랜딩 속성.
- **Site Spacing** — 사이트의 global spacing 설정을 커스터마이즈. 이 훅들이 결합해 각 페이지에 일관된 spacing 경험을 제공.

---

## Color `--dxp` 훅

Experience Builder의 Colors 탭은 각각 특정 use case와 가능한 값의 scale을 가진 color family로 나뉜다. 이 속성으로 페이지 전체 또는 페이지 내 임의 섹션의 color 값을 조정한다. 한 color 값이 정의되면 다른 색들이 derive되어 개별 base component에 매핑된다. 예를 들어 brand color를 default 파랑에서 바꾸면 시스템이 모든 base component의 연관 brand 색을 갱신한다.

### derivation·contrast pairing 동작

Experience Builder는 root에 대해 점점 더 대비되는 default derivation을 갖는다.
- root 배경색이 **어두우면** derivation이 점점 밝아져 배경과 대비.
- root 배경색이 **밝으면** derivation이 점점 어두워져 배경과 대비.

이 derivation 색은 종종 interaction state에 쓰인다. 예를 들어 버튼 색이 hover 시 `--dxp-g-brand` 에서 `--dxp-g-brand-1` 로 바뀔 수 있다. 또한 많은 색이 배경색 + 연관 전경색의 *pair*로 온다. 각 color pairing이 접근성을 위해 허용 가능한 contrast ratio를 유지하도록 한다.

### Usage Considerations

- use case에 맞는 올바른 훅 family를 사용한다. 예를 들어 브랜드의 메인 색이 빨강이라도 `--dxp-g-destructive` 가 마침 빨강이라는 이유로 그것을 쓰지 말 것 — `--dxp-g-destructive` 는 오직 error·invalid state에만 사용한다. 브랜드 색을 정의하려면 `--dxp-g-brand` 를 사용한다.
- `--dxp-g-neutral`, `--dxp-g-warning`, `--dxp-g-info`, `--dxp-g-success`, `--dxp-g-destructive` 는 Theme 패널에서 *선언적으로 구성할 수 없다.* 이 훅들을 수정하려면 head markup에서 수동으로 업데이트해야 한다.
- alpha 값은 투명도에 영향을 주므로, 값을 수정하면 페이지 요소에 의도치 않은 영향을 줄 수 있다. 색을 오버라이드한다면 alpha transparency를 그 색과 같은 레벨로 유지하기를 권장한다.
- ExperienceBundle 또는 DigitalExperienceBundle의 변경은 자동 color derivation을 트리거하지 *않는다.*

### Color 훅 families 전수

> PDF는 일부 훅 뒤에 `(1)(2)(3)(4)` 번호를 붙이고 일부엔 안 붙였다. 아래는 원문 그대로(번호 표기/누락 포함). 번호는 derivation scale 순서 라벨로 보이며, 일부 항목엔 PDF가 번호를 생략했다(원문 그대로 반영, 임의 보정 안 함).

**Root** — 페이지 또는 페이지 내 섹션의 배경색. Root-1은 root 배경색을 유지하면서 interaction state를 가진 컴포넌트(예: neutral 버튼의 background hover state)에 자주 쓰인다.
- `--dxp-g-root` (1)
- `--dxp-g-root-contrast` (2)
- `--dxp-g-root-1` (3)
- `--dxp-g-root-contrast-1`

> **Tip:** 페이지 내 섹션에서 `--dxp-g-root` 를 재정의하면, 새 root에 대해 접근성이 유지되도록 다른 모든 `--dxp` 스타일링 훅을 재평가한다. 접근 가능하지 않으면 훅을 재정의한다.

**Brand** — 사이트의 primary brand 색. Salesforce는 파랑. 버튼·링크·focus state 등에 흔히 사용.
- `--dxp-g-brand` (1)
- `--dxp-g-brand-contrast` (2)
- `--dxp-g-brand-1` (3)
- `--dxp-g-brand-contrast-1` (4)

**Success** — 성공을 전달. badge·alert·toast·success variant 버튼에 흔히 사용.
- `--dxp-g-success` (1)
- `--dxp-g-success-contrast` (2)
- `--dxp-g-success-1` (3)
- `--dxp-g-success-contrast-1` (4)

**Destructive** — error 또는 invalid state를 전달. alert·badge·toast·error state form field·destructive variant 버튼에 사용.
- `--dxp-g-destructive` (1)
- `--dxp-g-destructive-contrast` (2)
- `--dxp-g-destructive-1` (3)
- `--dxp-g-destructive-contrast-1` (4)

**Warning** — 사용자에게 경고를 전달. badge·alert·toast에 사용.
- `--dxp-g-warning` (1)
- `--dxp-g-warning-contrast` (2)

**Info** — 비긴급 정보를 전달. tooltip·popover에 사용.
- `--dxp-g-info` (1)
- `--dxp-g-info-contrast` (2)
- `--dxp-g-info-1`
- `--dxp-g-info-contrast-1`

**Neutral** — border·shadow로 요소 간 흐름을 끊는 데 사용. neutral 색은 toast·badge 같은 비긴급 informational 요소와 icon·disabled input처럼 interaction이 없는 요소에도 사용.
- `--dxp-g-neutral` (1)
- `--dxp-g-neutral-contrast`
- `--dxp-g-neutral-1` (3)
- `--dxp-g-neutral-contrast-1`
- `--dxp-g-neutral-2`
- `--dxp-g-neutral-contrast-2`
- `--dxp-g-neutral-3`
- `--dxp-g-neutral-contrast-3`

---

## Text `--dxp` 훅

heading·body·button·link·forms 텍스트의 스타일링을 쉽게 제어하는 광범위한 text 브랜딩 속성을 제공한다.

**Base Font Family / Base Font Size** 속성은 사이트의 `<html>` 요소에 font family와 font size를 설정한다.
- Base Font Family 속성은 **Visitor's Native System Font** 가 default. 따라서 각 text 요소의 Font Family는 **Use Base Font Family** 가 default. (Spring '25 이전에 만든 LWR 사이트는 기존 font 설정이 그대로 유지되며 업데이트 가능.) 이 설정은 방문자의 OS native/default 폰트를 사이트 폰트로 사용해 가독성과 사이트 성능을 높인다. native system font는 Windows·macOS·모바일 OS마다 다르지만 보통 sans serif다. 임의 text 요소의 폰트를 커스터마이즈할 수 있으나, 최적 성능을 위해 사이트에서 사용하는 font family 수를 최소화한다.
- Base Font Size 속성은 사이트의 default 데스크톱/모바일 font size를 결정한다. base font size를 바꾸면 relative unit(`rem`/`em`)으로 지정된 모든 사이트 요소(font size·spacing 값 등)가 비례 조정된다.

버튼·링크·forms 텍스트 외에도 여러 레벨의 heading·body 텍스트 스타일을 수정할 수 있다:
- Heading 1 / Heading 2 / Heading 3 / Heading 4 / Heading 5 / Heading 6
- Paragraph 1 / Paragraph 2

각 text 스타일은 Theme 패널에서 선언적으로, 또는 `--dxp` 스타일링 훅으로 프로그래밍 방식으로 구성한다. 이 속성 값을 바꾸면 그 값을 소비하는 SLDS·DXP CSS 클래스에도 영향을 준다.

> **Note:** 각 스타일에 연관된 heading 태그를 컴포넌트 레벨에서 오버라이드한다. 예를 들어 text 컴포넌트가 Heading 1 스타일(h1 태그 연관)을 가지면, 필요 시 태그를 h2로 바꾼다.

컴포넌트에서 이 text 속성을 사용하려면 SLDS 또는 DXP CSS 클래스를 쓰거나, `--dxp` 스타일링 훅을 컴포넌트 CSS에 직접 쓴다. 다음 샘플은 DXP CSS 클래스로 컴포넌트의 h1을 Extra Large Heading에 정의된 브랜딩 속성 값으로 스타일한다.

```html
<!-- exp_cloud_lwr.pdf 발췌 -->
<template>
<h1 class="dxp-text-heading-xlarge">Heading 1</h1>
</template>
```

또는 `--dxp` 스타일링 훅을 컴포넌트 CSS에 직접 쓸 수 있다:

```css
// exp_cloud_lwr.pdf 발췌
h1 {
font-size: var(--dxp-s-text-heading-extra-large-font-size);
font-family: var(--dxp-s-text-heading-extra-large-font-family);
}
```

Tablet Portrait·Mobile 같은 작은 form factor의 Base Font Size를 바꾸려면 `--dxp-s-html-font-size-mobile` 값을 프로그래밍 방식으로 설정한다.

---

## Site Spacing `--dxp` 훅

Site spacing으로 사이트의 global spacing 설정을 커스터마이즈한다. 이 훅들이 결합해 각 페이지에 일관된 spacing 경험을 제공한다.

Theme 패널의 Site Spacing 탭에서 데스크톱·모바일 디바이스에 대해 다음 속성을 설정한다.
- **Max Content Width** — theme region과 page region의 inner content 최대 너비.
- **Section Padding: Top & Bottom** — 섹션 inner content의 위/아래와 섹션 컨테이너의 위/아래 사이 공간.
- **Section Padding: Left & Right** — 섹션 inner content의 좌/우 edge와 섹션 컨테이너의 좌/우 edge 사이 공간.
- **Column Gutters** — 다중 컬럼 섹션 컴포넌트의 컬럼 간 공간. 모바일 form factor에서는 stack된 컬럼 사이의 vertical 공간을 제어.
- **Vertical Space Between Components** — 같은 region 내 컴포넌트 간 vertical spacing 양.

Site spacing 속성은 Theme 패널에 노출된 것에 국한되지 않는다. 거기 표시되는 선언적 속성 외에도, 페이지의 다른 부분에서 spacing을 미세조정하는 데 쓸 수 있는 수십 개의 component-level site spacing 훅이 더 있다.

---

## Theme 패널 속성 → `--dxp` 훅 매핑 표 (핵심 lookup)

Theme 패널의 각 선언적 속성은 하나 이상의 프로그래밍 방식 `--dxp` 스타일링 훅에 매핑된다. 사용자가 Theme 패널에서 속성을 업데이트하면, 시스템이 그 브랜딩 속성에 연관된 훅을 사용하는 모든 Lightning web component를 자동 갱신한다.

> 표 방향성(원문 보존): **좌열 = Theme 패널 속성**(서브그룹 헤더 + 필드명), **우열 = 매핑되는 `--dxp` 훅**(1:N 가능). transpose하지 않았다.

### Colors

> (For button colors, see the Button Colors section.)

| 서브그룹 | Theme 패널 속성 | `--dxp` 훅 |
|---|---|---|
| **Basic** | Background Color | `--dxp-g-root`, `--dxp-g-root-1`, `--dxp-g-root-2`, `--dxp-g-root-3` |
| Basic | Text Color | `--dxp-g-root-contrast`, `--dxp-g-root-contrast-1`, `--dxp-g-root-contrast-2`, `--dxp-g-root-contrast-3` |
| Basic | Brand Color | `--dxp-g-brand`, `--dxp-g-brand-1`, `--dxp-g-brand-2`, `--dxp-g-brand-3` |
| Basic | Brand Foreground Color | `--dxp-g-brand-contrast`, `--dxp-g-brand-contrast-1`, `--dxp-g-brand-contrast-2`, `--dxp-g-brand-contrast-3` |
| **Text** | Heading 1 | `--dxp-s-text-heading-extra-large-color` |
| Text | Heading 2 | `--dxp-s-text-heading-large-color` |
| Text | Heading 3 | `--dxp-s-text-heading-medium-color` |
| Text | Heading 4 | `--dxp-s-text-heading-small-color` |
| Text | Heading 5 | `--dxp-s-text-heading-extra-small-color` |
| Text | Heading 6 | `--dxp-s-text-heading-extra-extra-small-color` |
| Text | Paragraph 1 | `--dxp-s-body-text-color` |
| Text | Paragraph 2 | `--dxp-s-body-small-text-color` |
| **Links** | Link Color | `--dxp-s-link-text-color` |
| Links | Link Hover Color | `--dxp-s-link-text-color-hover` |
| **Forms** | Field Label | `--dxp-s-form-element-label-color` |
| Forms | Placeholder Text | `--dxp-s-form-element-placeholder-text-color` |
| Forms | Input Text | `--dxp-s-form-element-text-color` |
| Forms | Input Text Focus | `--dxp-s-form-element-text-color-focus` |
| Forms | Field Background Fill | `--dxp-s-form-element-color-background` |
| Forms | Field Background Focus | `--dxp-s-form-element-color-background-active` |
| Forms | Field Border | `--dxp-s-form-element-color-border` |
| Forms | Field Border Focus | `--dxp-s-form-element-color-border-focus` |
| Forms | Checkbox Background | `--dxp-s-form-checkbox-color-background` |
| Forms | Selected Checkbox Background | `--dxp-s-form-checkbox-color-background-checked` |
| Forms | Checkbox Border | `--dxp-s-form-checkbox-color-border` |
| Forms | Selected Checkbox Border | `--dxp-s-form-checkbox-color-border-checked` |
| **Dropdowns** | Dropdown Text Color | `--dxp-s-dropdown-text-color` |
| Dropdowns | Dropdown Background Color | `--dxp-s-dropdown-color-background` |
| Dropdowns | Dropdown Text Hover Color | `--dxp-s-dropdown-text-color-hover` |
| Dropdowns | Dropdown Background Hover Color | `--dxp-s-dropdown-color-background-hover` |
| Dropdowns | Dropdown Border Color | `--dxp-s-dropdown-color-border` |

> **Tip:** Theme 패널에 나타나지 않는 다른 사용 가능한 스타일링 훅은 위 [Color `--dxp` 훅](#color---dxp-훅) 섹션 참조.

### Images

| Theme 패널 속성 | `--dxp` 훅 |
|---|---|
| Site Logo | `--dxp-s-site-logo-path`, `--dxp-s-site-logo-url` |
| Browser Icon (Favicon) | No styling hook. To add a favicon in Experience Builder, click Theme > Images and upload the file. After upload, the favicon is added automatically to your site's browser tab. |

> 자세히는 아래 [구성 가능한 Site Logo 컴포넌트](#구성-가능한-site-logo-컴포넌트) 참조.

### Text

Base Font Family / Base Font Size 속성은 사이트의 `<html>` 요소에 font family와 font size를 설정한다. Base Font Family는 **Visitor's Native System Font** 가 default, 각 text 요소의 Font Family는 **Use Base Font Family** 가 default. 임의 text 요소에서 변경 가능하나, 최적 성능을 위해 사용 font family 수를 최소화한다. Base Font Size 속성은 default 데스크톱/모바일 font size를 결정하며, 변경 시 relative unit(`rem`/`em`) 기반 사이트 요소가 비례 조정된다.

design system은 여러 레벨의 text 스타일링을 제공한다. 각 레벨은 다음 형식으로 `--dxp` 스타일링 훅에 매핑되는 여러 스타일 속성을 포함한다:

```
--dxp-s-level-style
```

이 표의 **Headings and Body** 부분에서 `level` 을 아래 값으로 적절히 치환한다. 버튼 텍스트는 Buttons 섹션, forms 텍스트는 Forms 섹션 참조.

| 플레이스홀더 *level* 값 | 대응 Theme 속성 |
|---|---|
| `text-heading-extra-large` | Heading 1 |
| `text-heading-large` | Heading 2 |
| `text-heading-medium` | Heading 3 |
| `text-heading-small` | Heading 4 |
| `text-heading-extra-small` | Heading 5 |
| `text-heading-extra-extra-small` | Heading 6 |
| `body` | Paragraph 1 |
| `body-small` | Paragraph 2 |

예를 들어 Heading 1의 font family에 대한 `--dxp` 스타일링 훅은 `--dxp-s-text-heading-extra-large-font-family` 다.

| 서브그룹 | Theme 패널 속성 | `--dxp` 훅 |
|---|---|---|
| **Base Font Family and Size** | Base Font Family | `--dxp-s-html-font-family` |
| Base Font Family and Size | Desktop Base Font Size | `--dxp-s-html-font-size` |
| Base Font Family and Size | Mobile Base Font Size | `--dxp-s-html-font-size-mobile` |
| **Headings and Body** | Font Family | `--dxp-s-`*`level`*`-font-family` |
| Headings and Body | Font Size | `--dxp-s-`*`level`*`-font-size` |
| Headings and Body | Font Style | `--dxp-s-`*`level`*`-font-style` |
| Headings and Body | Font Weight | `--dxp-s-`*`level`*`-font-weight` |
| Headings and Body | Text Decoration | `--dxp-s-`*`level`*`-text-decoration` |
| Headings and Body | Text Case | `--dxp-s-`*`level`*`-text-transform` |
| Headings and Body | Line Height | `--dxp-s-`*`level`*`-line-height` |
| Headings and Body | Character Spacing | `--dxp-s-`*`level`*`-letter-spacing` |
| **Link Text** | Text Decoration | `--dxp-s-link-text-decoration` |
| Link Text | Focus Text Decoration | `--dxp-s-link-text-decoration-focus` |
| Link Text | Hover Text Decoration | `--dxp-s-link-text-decoration-hover` |

> *level* 은 위 8개 값으로 치환되는 플레이스홀더(PDF 이미지에서 이탤릭 표기).

### Site Spacing

| 서브그룹 | Theme 패널 속성 | `--dxp` 훅 |
|---|---|---|
| **Desktop Site Spacing** | Max Content Width | `--dxp-s-section-columns-max-width`, `--dxp-s-header-content-max-width`, `--dxp-s-footer-content-max-width` |
| Desktop Site Spacing | Section Padding: Top & Bottom | `--dxp-s-section-content-spacing-block-start`, `--dxp-s-section-content-spacing-block-end` |
| Desktop Site Spacing | Section Padding: Left & Right | `--dxp-s-section-content-spacing-inline-start`, `--dxp-s-section-content-spacing-inline-end` |
| Desktop Site Spacing | Column Gutters | `--dxp-s-column-spacer-size` |
| Desktop Site Spacing | Vertical Space Between Components | `--dxp-s-component-wrapper-spacer-size` |
| **Mobile Site Spacing** | Max Content Width | `--dxp-s-section-columns-max-width-mobile`, `--dxp-s-header-content-max-width-mobile`, `--dxp-s-footer-content-max-width-mobile` |
| Mobile Site Spacing | Section Padding: Top & Bottom | `--dxp-s-section-content-spacing-block-start-mobile`, `--dxp-s-section-content-spacing-block-end-mobile` |
| Mobile Site Spacing | Section Padding: Left & Right | `--dxp-s-section-content-spacing-inline-start-mobile`, `--dxp-s-section-content-spacing-inline-end-mobile` |
| Mobile Site Spacing | Column Gutters | `--dxp-s-column-spacer-size-mobile` |
| Mobile Site Spacing | Vertical Space Between Components | `--dxp-s-component-wrapper-spacer-size-mobile` |

### Buttons

base font size를 사이트 텍스트에 설정하면(Text 섹션 참조), 그 설정이 사이트 버튼 텍스트의 default font size에 영향을 준다. 버튼 색은 아래 Button Colors 섹션 참조.

| 서브그룹 | Theme 패널 속성 | `--dxp` 훅 |
|---|---|---|
| **Text Values for All Buttons** | Font Family | `--dxp-s-button-font-family` |
| Text Values for All Buttons | Font Style | `--dxp-s-button-font-style` |
| Text Values for All Buttons | Font Weight | `--dxp-s-button-font-weight` |
| Text Values for All Buttons | Text Case | `--dxp-s-button-text-transform` |
| Text Values for All Buttons | Text Decoration | `--dxp-s-button-text-decoration` |
| Text Values for All Buttons | Line Height | `--dxp-s-button-line-height` |
| Text Values for All Buttons | Character Spacing | `--dxp-s-button-letter-spacing` |
| **Standard Button Values** | Vertical Padding | `--dxp-s-button-padding-block-start`, `--dxp-s-button-padding-block-end` |
| Standard Button Values | Horizontal Padding | `--dxp-s-button-padding-inline-start`, `--dxp-s-button-padding-inline-end` |
| Standard Button Values | Font Size | `--dxp-s-button-font-size` |
| Standard Button Values | Border Radius | `--dxp-s-button-radius-border` |
| **Small Button Values** | Vertical Padding | `--dxp-s-button-small-padding-block-start`, `--dxp-s-button-small-padding-block-end` |
| Small Button Values | Horizontal Padding | `--dxp-s-button-small-padding-inline-start`, `--dxp-s-button-small-padding-inline-end` |
| Small Button Values | Font Size | `--dxp-s-button-small-font-size` |
| Small Button Values | Border Radius | `--dxp-s-button-small-radius-border` |
| **Large Button Values** | Vertical Padding | `--dxp-s-button-large-padding-block-start`, `--dxp-s-button-large-padding-block-end` |
| Large Button Values | Horizontal Padding | `--dxp-s-button-large-padding-inline-start`, `--dxp-s-button-large-padding-inline-end` |
| Large Button Values | Font Size | `--dxp-s-button-large-font-size` |
| Large Button Values | Border Radius | `--dxp-s-button-large-radius-border` |

### Button Colors

> Winter '25부터 버튼의 color 속성은 **Theme > Buttons** 패널에 있다. 이 표는 3컬럼 구조(**Button State | Theme 패널 속성 | `--dxp` 훅**)이며, Primary/Secondary/Tertiary Buttons가 그룹 헤더다.

**Primary Buttons**

| Button State | Theme 패널 속성 | `--dxp` 훅 |
|---|---|---|
| Default State | Background | `--dxp-s-button-color` |
| Default State | Border | `--dxp-s-button-border-color` |
| Default State | Text | `--dxp-s-button-color-contrast` |
| Hover State | Hover Background | `--dxp-s-button-color-hover` |
| Hover State | Hover Border | `--dxp-s-button-border-color-hover` |
| Hover State | Hover Text | `--dxp-s-button-color-hover-contrast` |
| Focus State | Focus Background | `--dxp-s-button-color-focus` |
| Focus State | Focus Border | `--dxp-s-button-border-color-focus` |
| Focus State | Focus Text | `--dxp-s-button-color-focus-contrast` |

**Secondary Buttons**

| Button State | Theme 패널 속성 | `--dxp` 훅 |
|---|---|---|
| Default State | Background | `--dxp-s-secondary-button-color` |
| Default State | Border | `--dxp-s-secondary-button-border-color` |
| Default State | Text | `--dxp-s-secondary-button-text-color` |
| Hover State | Hover Background | `--dxp-s-secondary-button-color-hover` |
| Hover State | Hover Border | `--dxp-s-secondary-button-border-color-hover` |
| Hover State | Hover Text | `--dxp-s-secondary-button-text-color-hover` |
| Focus State | Focus Background | `--dxp-s-secondary-button-color-focus` |
| Focus State | Focus Border | `--dxp-s-secondary-button-border-color-focus` |
| Focus State | Focus Text | `--dxp-s-secondary-button-text-color-focus` |

**Tertiary Buttons**

| Button State | Theme 패널 속성 | `--dxp` 훅 |
|---|---|---|
| Default State | Background | `--dxp-s-tertiary-button-color` |
| Default State | Border | `--dxp-s-tertiary-button-border-color` |
| Default State | Text | `--dxp-s-tertiary-button-text-color` |
| Hover State | Hover Background | `--dxp-s-tertiary-button-color-hover` |
| Hover State | Hover Border | `--dxp-s-tertiary-button-border-color-hover` |
| Hover State | Hover Text | `--dxp-s-tertiary-button-text-color-hover` |
| Focus State | Focus Background | `--dxp-s-tertiary-button-color-focus` |
| Focus State | Focus Border | `--dxp-s-tertiary-button-border-color-focus` |
| Focus State | Focus Text | `--dxp-s-tertiary-button-text-color-focus` |

### Forms

heading·body 텍스트의 여러 레벨 스타일링과 유사하게, design system은 form의 여러 부분에 대한 text 스타일을 제공한다. 이 표의 **Field Labels, Input Text, and Caption Text** 섹션에서 `level` 을 아래 값으로 적절히 치환한다.

| 플레이스홀더 *level* 값 | 대응 |
|---|---|
| `label` | Field Label |
| `text` | Input Text |
| `caption-text` | Caption |

예를 들어 Field Label의 font family에 대한 `--dxp` 스타일링 훅은 `--dxp-s-form-element-label-font-family` 다.

| 서브그룹 | Theme 패널 속성 | `--dxp` 훅 |
|---|---|---|
| **Spacing** | Field Padding: Top | `--dxp-s-form-element-spacing-block-start` |
| Spacing | Field Padding: Right | `--dxp-s-form-element-spacing-horizontal-end` |
| Spacing | Field Padding: Bottom | `--dxp-s-form-element-spacing-block-end` |
| Spacing | Field Padding: Left | `--dxp-s-form-element-spacing-horizontal-start` |
| **Borders** | Field Border Radius | `--dxp-s-form-element-radius-border` |
| Borders | Field Border Weight | `--dxp-s-form-element-width-border` |
| Borders | Checkbox Border Radius | `--dxp-s-form-checkbox-radius-border` |
| Borders | Checkbox Border Weight | `--dxp-s-form-checkbox-width-border` |
| **Field Labels, Input Text, and Caption Text** | Font Family | `--dxp-s-form-element-`*`level`*`-font-family` |
| Field Labels, Input Text, and Caption Text | Font Size | `--dxp-s-form-element-`*`level`*`-font-size` |
| Field Labels, Input Text, and Caption Text | Font Style | `--dxp-s-form-element-`*`level`*`-font-style` |
| Field Labels, Input Text, and Caption Text | Font Weight | `--dxp-s-form-element-`*`level`*`-font-weight` |
| Field Labels, Input Text, and Caption Text | Text Case | `--dxp-s-form-element-`*`level`*`-text-transform` |
| Field Labels, Input Text, and Caption Text | Line Height | `--dxp-s-form-element-`*`level`*`-line-height` |
| Field Labels, Input Text, and Caption Text | Character Spacing | `--dxp-s-form-element-`*`level`*`-letter-spacing` |

> Forms의 *level* 은 `label` / `text` / `caption-text` 로 치환되는 플레이스홀더(PDF 이미지에서 이탤릭 표기).

---

## 커스텀 컴포넌트에서 `--dxp` 훅 사용

design system을 사용하는 사이트용 custom Lightning web component를 만들려면 적절한 `--dxp` 스타일링 훅을 쓴다.

> **Tip:** 사이트 컴포넌트 전반에 일반적인 변경을 줄 때는 `--dxp` 스타일링 훅 사용을 권장한다. 단 `--dxp` 브랜딩 default가 필요한 것을 정확히 제공하지 못하면, `--slds-c` 및 `--slds-g-color` 스타일링 훅으로 개별 컴포넌트를 미세조정할 수 있다.

다음은 custom combobox 컴포넌트 코드 샘플이다.

```html
<!-- exp_cloud_lwr.pdf 발췌 -->
<template>
  <input type="text">
  <ul>
    <li>Option 1</li>
    <li>Option 2</li>
  </ul>
</template>
```

input이 브랜딩 변경에 반응하는 다른 Lightning base component와 유사하게 보이려면, CSS가 다음과 같이 `--dxp` 스타일링 훅을 참조해야 한다.

```css
// exp_cloud_lwr.pdf 발췌
input {
  border-color: var(--dxp-g-neutral);
}

input:focus {
  border-color: var(--dxp-g-brand);
}
```

> **Important:** CSS custom property 값은 평가 시점에 resolve된다. 예를 들어 한 CSS custom property가 다른 CSS custom property를 참조한다고 하자. 후자의 CSS custom property 값을 더 낮은 스코프에서 업데이트하면, 전자의 CSS custom property 값은 새 값을 반영하지 *않는다.*

---

## 커스텀 CSS로 브랜딩 오버라이드

가끔 스타일링 훅만으로는 원하는 방식 그대로 컴포넌트를 스타일하기에 충분하지 않다. 이 경우 CSS selector로 컴포넌트 내의 사전 승인된 "part"를 타깃해 스타일할 수 있다.

> **Warning:** custom CSS는 아껴서 사용하고, `part` 속성이 없는 DOM 요소를 타깃하지 않는다. 컴포넌트 내부 DOM 구조 변경이 하드코딩된 CSS selector를 깨기 쉬워 brittle하기 때문이다. 또한 Salesforce Customer Support는 custom CSS 관련 문제 해결을 도울 수 없다.

### Target Component Instances

모든 컴포넌트는 컴포넌트 인스턴스마다 고유한 값을 갖는 `data-component-id` 속성을 가진다. 이 값으로 컴포넌트 인스턴스를 쉽게 타깃해 스타일링 훅을 오버라이드하거나 새 CSS를 추가할 수 있다. 컴포넌트의 정확한 속성 값을 알려면 앱의 DOM을 inspect한다(예: Chrome DevTools).

페이지의 한 섹션이 `<community_layout-section data-component-id="section-adfb">` markup을 가진다고 하자. 다음 샘플은 그 값으로 컴포넌트의 default 스타일링을 오버라이드한다.

```html
<!-- exp_cloud_lwr.pdf 발췌 -->
<style>
  [data-component-id="section-adfb"] {
    --dxp-g-warning: #ff9966;
    --dxp-g-warning-contrast: #fff;
    border: 2px dashed #000;
  }
</style>
```

컴포넌트의 property 패널에서 custom CSS 클래스를 지정해 그 컴포넌트를 타깃할 수도 있다.

### Target Parts Within a Component

대부분의 컴포넌트는 많은 DOM 요소로 구성되므로, 컴포넌트 내 특정 요소나 part를 스타일할 수 있다. 컴포넌트 part는 DXP가 다음 형식으로 노출한다:

```html
<!-- exp_cloud_lwr.pdf 발췌 -->
<div part="dxp-[component]-[part]">Some element</div>
```

같은 형식으로 custom 컴포넌트에서 part를 노출할 수 있다. 예를 들어 custom hero 컴포넌트는 다음과 같을 수 있다:

```html
<!-- exp_cloud_lwr.pdf 발췌 -->
<template>
  <div class="hero-background">
    <h1>My hero text</h1>
    <button part="some-partner-hero-primary-button">Main button</button>
    <button part="some-partner-secondary-button">Secondary button</button>
  </div>
</template>
```

그리고 CSS attribute selector로 어느 버튼이든 타깃할 수 있다:

```html
<!-- exp_cloud_lwr.pdf 발췌 -->
<style>
  [part="some-partner-hero-primary-button"] {
    --dxp-g-brand: red;
    --dxp-g-brand-contrast: white;
    transition: background-color 2s ease-in;
  }
</style>
```

> **Note:** 위 샘플에서 `h1` 이나 `hero-background` 클래스는 정의된 part가 없으므로 타깃하지 않는다.

특정 컴포넌트 인스턴스 내의 part를 타깃하려면 part selector를 `data-component-id` selector와 결합한다:

```html
<!-- exp_cloud_lwr.pdf 발췌 -->
<style>
  [data-component-id="custom-hero-cd0b"] [part="some-partner-hero-primary-button"] {
    --dxp-g-brand: red;
    --dxp-g-brand-contrast: white;
    transition: background-color 2s ease-in;
  }
</style>
```

---

## 색 팔레트 — 페이지 섹션·컬럼

많은 웹사이트에서 헤더·푸터·컬럼·배너처럼 사이트 전체와 다른 색을 쓰는 페이지 섹션이 흔하다. 예를 들어 사이트 전체는 밝은 배경/어두운 전경인데 헤더만 어두운 배경/밝은 전경으로 반전하고 싶을 때, 별도의 color palette를 만들어 이 페이지 영역에 적용한다.

**절차 (Manage Color Palettes 경로):**
1. color palette를 만들려면 Experience Builder에서 Theme 패널의 **Colors** 탭을 열고 **> Manage Color Palettes** 를 클릭.
2. **New Palette** 클릭 후 팔레트 이름 지정. → 새 팔레트가 생성되고 Color Palette theme 패널에서 선택됨.
3. Color Palette theme 패널의 **Colors** 섹션에서 팔레트의 색상 속성을 필요에 맞게 업데이트.
4. 팔레트를 사용하려면 페이지에서 **Section** 또는 **Columns** 컴포넌트를 선택한 뒤, 컴포넌트 property 패널의 **Color Palette** 메뉴에서 해당 팔레트 선택.

**대안 (컴포넌트에서 직접 생성):** Section 또는 Columns 컴포넌트 property 패널의 **Color Palette** 메뉴에서 **New** 를 클릭해 팔레트를 직접 만들 수도 있다. 이름을 지정·저장하면 그 팔레트가 해당 컴포넌트에 할당되고 Color Palette theme 패널이 열린다. step 3처럼 theme 패널에서 팔레트의 색 속성을 편집하면 변경이 즉시 컴포넌트에 적용된다.

> 이 절은 Experience Builder UI 절차만 다루며, PDF는 section/column 전용 CSS 훅 철자(`--dxp-c-section-*` 등)를 정의하지 않는다 — 팔레트는 컴포넌트 property 패널 메뉴로 적용한다.

---

## 구성 가능한 Site Logo 컴포넌트

두 개의 글로벌 스타일링 훅 `--dxp-s-site-logo-path` 와 `--dxp-s-site-logo-url` 을 사용해 사이트 페이지에 추가할 수 있는 구성 가능한 site logo 컴포넌트를 만든다. Theme 패널 Images 탭의 **Site Logo** 속성을 업데이트하면 이 훅을 참조하는 모든 컴포넌트가 자동 갱신된다.

| 훅 | 저장 내용 | 소비 위치 |
|---|---|---|
| `--dxp-s-site-logo-path` | 이미지 path | JavaScript·HTML에서 소비 가능 |
| `--dxp-s-site-logo-url` | site logo path를 `url(.)` 로 감싼 값 | CSS 속성에서 소비 가능 |

`:root` 정의 예시:

```css
// 원문 그대로 — 세미콜론 미표기 (exp_cloud_lwr.pdf 발췌)
:root {
--dxp-s-site-logo-path: "/cms/delivery/media/MCKW5KMZTF2BBFDLWWZG2MOVLLXA"
--dxp-s-site-logo-url: url("/cms/delivery/media/MCKW5KMZTF2BBFDLWWZG2MOVLLXA")
}
```

`--dxp-s-site-logo-path` 로 이미지 `src` 를 설정하는 JavaScript:

```javascript
// exp_cloud_lwr.pdf 발췌
const root = document.querySelector('html');
const logoPath = getComputedStyle(root).getPropertyValue('--dxp-s-site-logo-path');
const imgEl = document.createElement('img');
imgEl.src = logoPath;
```

`--dxp-s-site-logo-url` 로 site logo를 background image로 설정하는 CSS:

```css
// exp_cloud_lwr.pdf 발췌
.logo-container {
background-image: var(--dxp-s-site-logo-url);
background-position: center;
background-repeat: no-repeat;
background-size: contain;
max-width: 100%;
}
```

**The Site Logo Property in Experience Builder**
- Experience Builder의 Site Logo 속성은 Salesforce CMS 이미지를 사용한다 → 먼저 Digital Experiences 앱에서 LWR 사이트를 CMS workspace의 **channel** 로 추가해야 한다.
- Theme 패널 Images 탭에서 이미지를 추가하려면 해당 CMS workspace의 **contributor** 여야 한다. (자세히: Salesforce CMS 참조)
- site logo가 public 페이지에 쓰이면, Administration workspace의 **Preferences** 에서 **Let guest users view asset files and CMS content available to the site** 를 활성화해야 한다.

---

## 커스텀 폰트 추가

커스텀 폰트는 (A) 폰트 파일을 static resource로 업로드하거나, (B) 외부 호스팅된 파일을 참조해 추가한다.

### Static Resource 업로드

1. Setup의 Quick Find 박스에 **Static Resources** 입력 후 **Static Resources** 선택.
2. **New** 클릭 → 파일 업로드 → static resource 이름 지정(리소스 이름 메모). 사이트에 public 페이지가 있으면 **Cache Control** 설정을 **Public** 으로 선택. 폰트 리소스를 public으로 하지 않으면 페이지가 브라우저 default 폰트를 사용한다.
3. 사이트 head markup에 폰트 참조를 추가하려면 Experience Builder로 돌아가 **Settings > Advanced > Edit Head Markup** 클릭.
4. `@font-face` 선언을 삽입. 예시:

```html
<!-- exp_cloud_lwr.pdf 발췌 -->
<link rel="stylesheet" href="{ basePath }/assets/styles/dxp-styling-hooks.min.css?{
versionKey}" />
<link rel="stylesheet" href="{ basePath }/assets/styles/dxp-slds-extensions.min.css?{
versionKey}" />
<style>
@font-face {
font-family: 'myFirstFont';
/* Replace myFonts with your resource name */
src: url('{ basePath }/sfsites/c/resource/myFonts') format('woff');
}
</style>
```
<!-- PDF 원문 curly quote, 표준 따옴표로 정규화. `{ basePath }`·`{ versionKey }`는 원문 플레이스홀더 그대로. -->

   - **단일 폰트 파일 참조 구문:** `{ basePath }/sfsites/c/resource/static_resource_name`
     예) `myFirstFont.woff` 업로드 + 리소스명 `MyFonts` → URL = `{ basePath }/sfsites/c/resource/MyFonts`
   - **.zip 파일 내 폰트 참조 구문:** `{ basePath }/sfsites/c/resource/static_resource_name/font_folder/font_file` (폴더 구조 포함, `.zip` 파일명은 생략)
     예) `fonts.zip`(내부 `bold/myFirstFont.woff`) 업로드 + 리소스명 `MyFonts` → URL = `{ basePath }/sfsites/c/resource/MyFonts/bold/myFirstFont.woff`
5. Theme 패널의 **Text** 섹션에서 **Base Font Family** 드롭다운(또는 특정 텍스트 속성의 **Font Family** 드롭다운)을 클릭하고 **Use Custom Font** 선택.
6. Head Markup 편집기에 입력한 font family 이름(예: `myFirstFont`)을 추가하고 변경 사항 저장.

> **Tip:** 폰트 파일 형식(예: `woff`)이 markup과 일치하는지 확인. 또한 fallback 값(예: `Helvetica`, `sans-serif` 등)이 브랜드에 맞게 제대로 정의됐는지 확인. 자세히: `@font-face` 참조.

### 외부 호스팅 폰트

Salesforce 외부에 호스팅된 폰트(예: Google Fonts)를 사용할 수 있다. 단 외부 호스팅 파일에 접근하려면 org의 **Content Security Policy (CSP)** 를 업데이트해 해당 host를 **Trusted URLs** 목록에 추가해야 한다. 그렇지 않으면 리소스에 접근할 수 없다는 에러가 표시된다.

예) Google Fonts의 경우 추가:
- `https://fonts.googleapis.com` — Google Fonts style sheet 접근용
- `https://fonts.gstatic.com` — Google Font의 폰트 접근용

필요한 CSP directive로 Trusted URL을 추가하는 방법은 **Manage Trusted URLs** 참조.

---

## Remove SLDS

필요한 경우 사이트에서 Salesforce Lightning Design System (SLDS)를 제거할 수 있다.

> **Important:** flexible layouts 또는 Lightning base component 중 하나라도 사용할 계획이면 SLDS를 제거하지 *말 것* — 이들은 design system에 크게 의존한다.

Experience Builder에서 **Settings > Advanced > Edit Head Markup** 클릭 후, 다음 라인을 삭제한다:

```html
<!-- exp_cloud_lwr.pdf 발췌 -->
<link
rel="stylesheet"
href="{ basePath }/assets/styles/salesforce-lightning-design-system.min.css?{ versionKey
}"
/>
```

나중에 SLDS를 다시 사용하려면 이 코드를 head markup에 다시 추가한다.

---

## 관련 노트
- [[LWR Sites (Experience Cloud)]]
- [[LWR 컴포넌트 개발 심화]]
- [[LWR 동작·캐싱·제약]]
- [[LWR 다국어 사이트]]
- [[LWR Expressions 레퍼런스]]
- [[Lightning Web Security (LWS)]]
- [[SLDS 스타일링 훅]]
- [[LWC Shadow DOM 모드]]
