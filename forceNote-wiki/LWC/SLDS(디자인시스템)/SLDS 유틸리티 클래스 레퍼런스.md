---
tags: [slds, slds2, utility-classes, css, reference]
source: SLDS2-Docs/SLDS-Utilities.md — @salesforce-ux/design-system v2.30.4 컴파일 CSS 대조 (SLDS 2, Tier 2)
created: 2026-06-13
aliases: [SLDS Utilities, SLDS 유틸리티 클래스, slds-m, slds-p, slds-grid, slds-text, 마진 패딩 클래스, SLDS 유틸리티 전수]
---

> SLDS 2(v2.30.4) 유틸리티 클래스 전수 레퍼런스 — 마진·패딩·그리드·정렬·타이포 등 24개 카테고리를 HTML 예제와 함께. 컴파일 CSS로 재검증.

# SLDS Utilities (최신판)

> **기준 버전:** Salesforce Lightning Design System **v2.30.4 (SLDS 2, Spring '25)**
> 원본 PPT(2023년경 작성)의 내용을 최신 SLDS 공식 패키지(`@salesforce-ux/design-system`)의 컴파일된 CSS 기준으로 전부 재검증하여 갱신했습니다.
> 각 항목에는 **바로 복사해 응용할 수 있는 HTML 사용 예시**를 함께 실었습니다.

---

## 📌 원본 대비 주요 변경 사항 (꼭 읽어주세요)

SLDS 2로 넘어오면서 utility 클래스 **이름과 구조는 거의 그대로 유지**되지만, 내부 값이 크게 바뀌었습니다.

1. **하드코딩 색상 → 스타일링 훅(Styling Hooks)으로 전환**
   모든 색상이 `var(--slds-g-color-..., 폴백값)` 형태의 CSS 커스텀 속성으로 바뀌었습니다. 테마/다크모드 대응을 위해서입니다.

   | 용도 | 예전 값 | 최신 값 (스타일링 훅) |
   |---|---|---|
   | 기본 테두리 | `#dddbda` | `var(--slds-g-color-border-base-1, rgb(229,229,229))` |
   | 기본 텍스트 | `#080707` | `var(--slds-g-color-neutral-base-10, rgb(24,24,24))` |
   | 약한 텍스트 | `#3e3e3c` | `var(--slds-g-color-neutral-base-30, rgb(68,68,68))` |
   | 오류 텍스트 | `#c23934` | `var(--slds-g-color-error-base-40, rgb(234,0,30))` |
   | 반전 텍스트 | `#fff` | `var(--slds-g-color-neutral-base-100, rgb(255,255,255))` |
   | 약한 반전 텍스트 | `#b0adab` | `var(--slds-g-color-neutral-base-70, rgb(174,174,174))` |
   | shade 배경 | `#f3f2f2` | `var(--slds-g-color-neutral-base-95, rgb(243,243,243))` |
   | 브랜드(구분점) | `#16325c` | `var(--slds-g-color-brand-base-20, rgb(3,45,96))` |
   | 링크 | `#006dcc` | `rgb(11,92,171)` |

2. **이중 선택자 제공:** 모든 클래스가 신형 `_`(BEM) 표기와 구형 `--`(더블 대시) 표기를 **둘 다** 지원합니다. (예: `.slds-m-top_small` / `.slds-m-top--small`) 신규 코드는 `_` 표기를 권장합니다.

3. **`font-weight:300` 제거:** `.slds-text-heading_*` 와 `.slds-avatar_large` 에서 예전에 있던 `font-weight:300` 선언이 사라졌습니다.

4. **Description List 반응형화:** `.slds-dl_inline*`, `.slds-dl_horizontal*` 는 이제 `@media (min-width: 30em)` 안에서만 적용됩니다(작은 화면에서는 세로 배치).

5. **원본 오타/오류 정정:** 원본 PPT의 잘못된 표기를 바로잡았습니다.
   - `padding-horizontal`, `padding-vertical`, `padding-around` 같은 **존재하지 않는 CSS 속성** → 실제로는 `padding-left/right`, `padding-top/bottom`, `padding`(4방향)으로 정의됩니다.
   - `stzzzzzzzart` → `start`, `.slds-m-top_x -large`(공백) → `.slds-m-top_x-large`, 중복된 `medium`/`x-large` 항목, `.slds-line-clamp, {`(트레일링 콤마) 등 정정.

## 🗂️ SLDS 2 분류 체계 (참고)

SLDS 2 공식 [Utility Classes](https://www.lightningdesignsystem.com/2e1ef8501/p/05098e-utility-classes) 페이지는 유틸리티를 4개 그룹으로 묶습니다. 아래 번호 섹션을 이 그룹으로 매핑하면 다음과 같습니다.

| 그룹 | 포함 유틸리티 (이 문서 섹션) |
|---|---|
| **General** (범용) | 17 Print · 18 Scrollable · 24 Visibility · 9 Interaction |
| **Layout** (레이아웃) | 1 Alignment · 5 Floats · 6 Grid · 10 Layout · 12 Margin · 13 Media Objects · 15 Padding · 16 Position · 19 Sizing |
| **List** (목록) | 4 Description List · 7 Horizontal List · 14 Name Value List · 23 Vertical List |
| **Styling** (스타일) | 2 Borders · 3 Box · 8 Hyphenation · 11 Line Clamp · 22 Truncation · 20 Text |

> 참고: **SLDS 2는 "Themes(21)"를 유틸리티 목록에서 제외**했습니다. 테마/색상은 이제 **스타일링 훅**(`SLDS2-Styling-Hooks.md` 참고)으로 처리하는 방향이기 때문입니다. 이 문서에는 SLDS 1 호환을 위해 21 Themes 섹션을 그대로 남겨 두었습니다.

> **HTML 적용 전제:** 아래 모든 예시는 `<head>` 에 SLDS 스타일시트가 로드되어 있고, 루트 컨테이너에 스코프 클래스(예: `<div class="slds-scope">…</div>`)를 둔 상태를 가정합니다.
> ```html
> <link rel="stylesheet"
>       href="https://cdn.jsdelivr.net/npm/@salesforce-ux/design-system@2.30.4/assets/styles/salesforce-lightning-design-system.min.css" />
> ```

---

## 1. Alignment (정렬)

요소를 가로·세로 정중앙에 배치합니다.

```css
.slds-align_absolute-center {
  display: flex;
  justify-content: center;
  align-content: center;
  align-items: center;
  margin: auto;
}
```

- `slds-align_absolute-center` : flex로 수평/수직 모두 가운데 정렬 + `margin:auto`.

**사용 예시 (HTML)**

```html
<div class="slds-align_absolute-center" style="height: 8rem; border: 1px solid #ddd;">
  <span>정중앙에 배치되는 콘텐츠</span>
</div>
```

---

## 2. Borders (테두리)

각 방향으로 1px 실선 테두리를 추가합니다. 색상은 테두리 스타일링 훅을 사용합니다.

```css
.slds-border_top    { border-top:    1px solid var(--slds-g-color-border-base-1, rgb(229,229,229)); }
.slds-border_right  { border-right:  1px solid var(--slds-g-color-border-base-1, rgb(229,229,229)); }
.slds-border_bottom { border-bottom: 1px solid var(--slds-g-color-border-base-1, rgb(229,229,229)); }
.slds-border_left   { border-left:   1px solid var(--slds-g-color-border-base-1, rgb(229,229,229)); }
```

- 방향별로 한 변에만 테두리를 줍니다.

**사용 예시 (HTML)**

```html
<!-- 위/아래 테두리만 -->
<div class="slds-border_top slds-border_bottom slds-p-vertical_small">
  상하 구분선이 있는 행
</div>

<!-- 사방 테두리는 slds-box 권장 (3번 참고) -->
```

---

## 3. Box (박스)

패딩 + 둥근 모서리 + 테두리를 가진 컨테이너. 크기 변형으로 패딩을 조절합니다.

```css
.slds-box {
  padding: 1rem;
  border-radius: 0.25rem;
  border: 1px solid var(--slds-g-color-border-base-1, rgb(229,229,229));
}
.slds-box_small    { padding: 0.75rem; }
.slds-box_x-small  { padding: 0.5rem; }
.slds-box_xx-small { padding: 0.25rem; }
```

- 기본 박스는 패딩 `1rem`, `small`→`x-small`→`xx-small` 순으로 패딩이 작아집니다.

**사용 예시 (HTML)**

```html
<div class="slds-box">기본 박스 (패딩 1rem)</div>

<div class="slds-box slds-box_x-small slds-m-top_small">
  작은 박스 + 위 여백
</div>
```

---

## 4. Description List (설명 목록)

용어-설명 쌍을 배치합니다. **SLDS 2부터 `@media (min-width: 30em)` 안에서만 적용**됩니다(좁은 화면에서는 기본 세로 흐름).

### Inline (한 줄에 라벨+설명)

```css
.slds-dl_inline:after { content:""; display:table; clear:both; } /* clearfix */

@media (min-width: 30em) {
  .slds-dl_inline__label  { float:left; clear:left; }
  .slds-dl_inline__detail { float:left; padding-left:0.25rem; }
}
```

### Horizontal (라벨 30% / 설명 70%)

```css
@media (min-width: 30em) {
  .slds-dl_horizontal { display:flex; flex-wrap:wrap; }
  .slds-dl_horizontal__label  { width:30%; padding-right:0.75rem; }
  .slds-dl_horizontal__detail { width:70%; }
}
```

- Inline은 float 기반, Horizontal은 flex 기반으로 라벨/설명을 가로 배치합니다.

**사용 예시 (HTML)**

```html
<!-- Horizontal: 라벨 30% / 값 70% -->
<dl class="slds-dl_horizontal">
  <dt class="slds-dl_horizontal__label slds-text-color_weak slds-truncate">이름</dt>
  <dd class="slds-dl_horizontal__detail slds-truncate">홍길동</dd>
  <dt class="slds-dl_horizontal__label slds-text-color_weak slds-truncate">이메일</dt>
  <dd class="slds-dl_horizontal__detail slds-truncate">hong@example.com</dd>
</dl>
```

---

## 5. Floats (플로트)

```css
.slds-clearfix:after { content:""; display:table; clear:both; }

.slds-float_left  { float: left; }
.slds-float_right { float: right; }
.slds-float_none  { float: none; }
```

- `slds-clearfix` : float 자식으로 무너진 부모 높이를 복구.
- `slds-float_*` : 좌/우/해제 플로트.

**사용 예시 (HTML)**

```html
<div class="slds-clearfix slds-box">
  <button class="slds-float_right">오른쪽 버튼</button>
  <h2 class="slds-float_left">제목</h2>
</div>
```

---

## 6. Grid (그리드)

flexbox 기반 레이아웃 시스템. 가장 자주 쓰는 핵심 유틸리티입니다.

### 기본 컨테이너 / 컬럼 / 거터

```css
.slds-grid { display: flex; }

/* 컬럼: 기본적으로 남는 공간을 균등 분배 */
.slds-col { flex: 1 1 auto; }

/* 거터(컬럼 사이 간격) */
.slds-gutters          { margin-right:-0.75rem; margin-left:-0.75rem; }
.slds-gutters .slds-col{ padding-right:0.75rem; padding-left:0.75rem; }
.slds-gutters_direct   { margin-right:-0.75rem; margin-left:-0.75rem; }
```

### 줄바꿈 / 순서

```css
.slds-wrap    { flex-wrap: wrap; align-items: flex-start; }
.slds-order_1 { order: 1; }
.slds-order_3 { order: 3; }
```

### 방향

```css
.slds-grid_vertical         { flex-direction: column; }
.slds-grid_reverse          { flex-direction: row-reverse; }
.slds-grid_vertical-reverse { flex-direction: column-reverse; }
```

### 수평 정렬 (justify-content)

```css
.slds-grid_align-center { justify-content: center; }
.slds-grid_align-space  { justify-content: space-around; }
.slds-grid_align-spread { justify-content: space-between; }
.slds-grid_align-end    { justify-content: flex-end; }
.slds-col_bump-left     { margin-left: auto; }   /* 특정 컬럼만 오른쪽으로 밀기 */
```

### 수직 정렬 (align-items / align-content)

```css
.slds-grid_vertical-align-start  { align-items: flex-start; align-content: flex-start; }
.slds-grid_vertical-align-center { align-items: center;     align-content: center; }
.slds-grid_vertical-align-end    { align-items: flex-end;   align-content: flex-end; }

/* 개별 아이템 정렬 */
.slds-align-top    { vertical-align: top;    align-self: flex-start; }
.slds-align-middle { vertical-align: middle; align-self: center; }
```

### 크기 (width 분수 표기)

```css
.slds-size_1-of-1  { width: 100%; }
.slds-size_1-of-2  { width: 50%; }
.slds-size_1-of-3  { width: 33.3333333333%; }
.slds-size_2-of-3  { width: 66.6666666667%; }
.slds-size_1-of-4  { width: 25%; }
.slds-size_3-of-4  { width: 75%; }
.slds-size_1-of-6  { width: 16.6666666667%; }
.slds-size_1-of-8  { width: 12.5%; }
.slds-size_1-of-12 { width: 8.3333333333%; }
.slds-size_7-of-12 { width: 58.3333333333%; }

/* 반응형: 화면 폭 48em 이상에서만 적용 */
@media (min-width: 48em) {
  .slds-medium-size_6-of-12 { width: 50%; }
}
```

- `slds-size_X-of-Y` 로 컬럼 폭을 분수로 지정, `slds-medium-size_*` 등 브레이크포인트 접두사로 반응형 처리.

**사용 예시 (HTML)**

```html
<!-- 3등분 컬럼 + 거터 -->
<div class="slds-grid slds-gutters">
  <div class="slds-col slds-size_1-of-3">컬럼 1</div>
  <div class="slds-col slds-size_1-of-3">컬럼 2</div>
  <div class="slds-col slds-size_1-of-3">컬럼 3</div>
</div>

<!-- 반응형: 모바일 1열 → 태블릿 이상 2열 -->
<div class="slds-grid slds-wrap slds-gutters">
  <div class="slds-col slds-size_1-of-1 slds-medium-size_6-of-12">A</div>
  <div class="slds-col slds-size_1-of-1 slds-medium-size_6-of-12">B</div>
</div>

<!-- 좌측 제목 + 우측 버튼(bump-left로 우측 정렬) -->
<div class="slds-grid slds-grid_vertical-align-center">
  <div class="slds-col">제목</div>
  <div class="slds-col_bump-left">
    <button>액션</button>
  </div>
</div>
```

---

## 7. Horizontal List (가로 목록)

```css
.slds-list_horizontal { display: flex; }

/* 링크를 블록/인라인블록으로, _space는 패딩 추가 */
.slds-has-block-links a              { display:block; text-decoration:none; }
.slds-has-block-links_space a        { display:block; text-decoration:none; padding:0.75rem; }
.slds-has-inline-block-links a       { display:inline-block; text-decoration:none; }
.slds-has-inline-block-links_space a { display:inline-block; text-decoration:none; padding:0.75rem; }
```

### 구분점(divider) — 좌/우

```css
/* 왼쪽 구분점 (·항목) */
.slds-has-dividers_left > .slds-item {
  position: relative; display: flex; align-items: center;
}
.slds-has-dividers_left > .slds-item:before {
  width:2px; height:2px; content:""; display:inline-block; vertical-align:middle;
  margin-left:0.5rem; margin-right:0.5rem; border-radius:50%;
  background-color: var(--slds-g-color-brand-base-20, rgb(3,45,96));
}
.slds-has-dividers_left > .slds-item:first-child { margin-right:0; padding-right:0; }

/* 오른쪽 구분점 (항목·) */
.slds-has-dividers_right > .slds-item {
  position: relative; display: flex; align-items: center;
}
.slds-has-dividers_right > .slds-item:after {
  width:2px; height:2px; content:""; margin-left:0.5rem; margin-right:0.5rem;
  border-radius:50%; background-color: var(--slds-g-color-brand-base-20, rgb(3,45,96));
}
```

- 구분점 색이 예전 `#16325c` → 브랜드 스타일링 훅으로 변경.

**사용 예시 (HTML)**

```html
<!-- 가운데 점(·)으로 구분되는 메타 정보 -->
<ul class="slds-list_horizontal slds-has-dividers_right">
  <li class="slds-item">작성자: 홍길동</li>
  <li class="slds-item">2026-06-13</li>
  <li class="slds-item">조회 1,024</li>
</ul>
```

---

## 8. Hyphenation (하이픈/줄바꿈)

```css
.slds-hyphenate {
  overflow-wrap: break-word;
  word-wrap: break-word;
  hyphens: auto;
}
```

- 긴 단어를 자동으로 줄바꿈/하이픈 처리합니다. (구형 `-webkit-hyphens`는 빌드에서 제거됨)

**사용 예시 (HTML)**

```html
<p class="slds-hyphenate" style="width: 120px;">
  pneumonoultramicroscopicsilicovolcanoconiosis
</p>
```

---

## 9. Interaction (상호작용)

링크/버튼의 인터랙션 스타일.

```css
.slds-text-link_reset { cursor:pointer; line-height:inherit; font-size:inherit; }

.slds-text-link {
  color: rgb(11,92,171);          /* 예전 #006dcc 에서 변경 */
  text-decoration: none;
  transition: color 0.1s linear;
}

.slds-has-blur-focus { color: currentColor; }
```

### Button (스타일링 훅 기반으로 전면 개편)

```css
.slds-button {
  position: relative;
  display: inline-flex;
  align-items: center;
  min-height: 1lh;
  padding-top:    var(--slds-c-button-spacing-block-start, 0);
  padding-right:  var(--slds-c-button-spacing-inline-end, 0);
  padding-bottom: var(--slds-c-button-spacing-block-end, 0);
  padding-left:   var(--slds-c-button-spacing-inline-start, 0);
  background-color: var(--slds-c-button-color-background, transparent);
  border: var(--slds-c-button-sizing-border, 1px) solid var(--slds-c-button-color-border, transparent);
  border-radius: var(--slds-c-button-radius-border, 0.25rem);
  box-shadow: var(--slds-c-button-shadow);
  line-height: var(--slds-c-button-line-height, 1.875rem);
  color: var(--slds-c-button-text-color, rgb(1,118,211));
  white-space: normal;
  user-select: none;
  vertical-align: middle;
}
```

- 버튼은 이제 컴포넌트 스타일링 훅(`--slds-c-button-*`)으로 패딩/색/테두리를 제어합니다.

**사용 예시 (HTML)**

```html
<!-- 텍스트 링크 -->
<a href="#" class="slds-text-link">자세히 보기</a>

<!-- 기본 + 강조(brand) 버튼 -->
<button class="slds-button slds-button_neutral">취소</button>
<button class="slds-button slds-button_brand">저장</button>

<!-- 버튼 색을 스타일링 훅으로 커스텀 -->
<button class="slds-button slds-button_brand"
        style="--slds-c-button-brand-color-background:#6b21a8;">
  커스텀 컬러
</button>
```

---

## 10. Layout (레이아웃)

> 원본 PPT 표지 목차에는 있었으나 본문 슬라이드는 누락되어 있던 항목입니다. 레이아웃 관련 핵심은 **6. Grid** 섹션(grid/col/size/gutters)에 통합되어 있습니다.

**사용 예시 (HTML) — 전형적인 페이지 레이아웃**

```html
<div class="slds-grid slds-grid_frame slds-wrap">
  <!-- 사이드바 -->
  <aside class="slds-col slds-size_1-of-1 slds-medium-size_1-of-4 slds-box slds-theme_shade">
    사이드바
  </aside>
  <!-- 본문 -->
  <main class="slds-col slds-size_1-of-1 slds-medium-size_3-of-4 slds-p-around_medium">
    본문 영역
  </main>
</div>
```

---

## 11. Line Clamp (줄 수 제한)

지정한 줄 수를 넘으면 말줄임(…) 처리합니다.

```css
.slds-line-clamp {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: pre-line;
}
.slds-line-clamp_x-small { -webkit-line-clamp: 2; /* +위 공통 속성 */ }
.slds-line-clamp_small   { -webkit-line-clamp: 3; }
.slds-line-clamp_medium  { -webkit-line-clamp: 5; }
.slds-line-clamp_large   { -webkit-line-clamp: 7; }
```

> 참고: 최신 빌드에서는 각 변형이 공통 속성을 모두 포함합니다(원본의 `.slds-line-clamp, {` 트레일링 콤마 오류 정정).

**사용 예시 (HTML)**

```html
<!-- 2줄까지만 표시하고 나머지는 ... -->
<p class="slds-line-clamp_x-small">
  여기에 긴 설명 텍스트가 들어갑니다. 두 줄을 넘어가면 자동으로 말줄임 처리됩니다.
  카드 리스트의 미리보기 텍스트에 유용합니다.
</p>
```

---

## 12. Margin (바깥 여백)

간격 스케일: `none`, `xxx-small(.125rem)`, `xx-small(.25rem)`, `x-small(.5rem)`, `small(.75rem)`, `medium(1rem)`, `large(1.5rem)`, `x-large(2rem)`, `xx-large(3rem)`.

### 방향별 (top 예시 — left/right/bottom 동일 패턴)

```css
.slds-m-top_none      { margin-top: 0 !important; }
.slds-m-top_xxx-small { margin-top: 0.125rem; }
.slds-m-top_xx-small  { margin-top: 0.25rem; }
.slds-m-top_x-small   { margin-top: 0.5rem; }
.slds-m-top_small     { margin-top: 0.75rem; }
.slds-m-top_medium    { margin-top: 1rem; }
.slds-m-top_large     { margin-top: 1.5rem; }
.slds-m-top_x-large   { margin-top: 2rem; }
.slds-m-top_xx-large  { margin-top: 3rem; }
```

> `slds-m-left_*`, `slds-m-right_*`, `slds-m-bottom_*` 도 같은 스케일로 존재합니다.

### 축/전체 (실제 CSS 속성으로 정정)

```css
.slds-m-horizontal_small { margin-left: 0.75rem; margin-right: 0.75rem; }   /* 좌우 */
.slds-m-vertical_medium  { margin-top: 1rem;     margin-bottom: 1rem; }     /* 상하 */
.slds-m-around_medium    { margin: 1rem; }                                  /* 4방향 */
```

**사용 예시 (HTML)**

```html
<h2>섹션 제목</h2>
<p class="slds-m-top_small">제목 아래 0.75rem 여백</p>

<div class="slds-m-around_medium">사방 1rem 여백 컨테이너</div>

<!-- 버튼 사이 간격 -->
<button class="slds-button">이전</button>
<button class="slds-button slds-m-left_x-small">다음</button>
```

---

## 13. Media Objects (미디어 객체)

아바타/아이콘 + 본문 텍스트를 나란히 배치하는 패턴.

```css
.slds-media        { display: flex; align-items: flex-start; }
.slds-media__figure{ flex-shrink: 0; margin-right: 0.75rem; }   /* 좌측 그림 영역 */
.slds-media__body  { flex: 1; min-width: 0; }                    /* 우측 본문 */

.slds-media_center { align-items: center; }                      /* 세로 가운데 정렬 */
.slds-media__figure_reverse { order: 3; margin: 0 0 0 1rem; }    /* 그림을 오른쪽으로 */
.slds-media_large .slds-media__figure { margin-right: 1.5rem; }

@media (max-width: 48em) {
  .slds-media_responsive { display: block; }                    /* 좁은 화면에서 세로 적층 */
}
```

### Avatar (스타일링 훅 적용)

```css
.slds-avatar {
  width: 2rem; height: 2rem;
  overflow: hidden; display: inline-block; vertical-align: middle;
  border-radius: var(--slds-c-avatar-radius-border, 0.25rem);
  line-height: 1; font-size: 0.875rem;
  color: var(--slds-c-avatar-text-color, var(--slds-g-color-neutral-base-100, rgb(255,255,255)));
}
.slds-avatar_large { width: 3rem; height: 3rem; font-size: 1.125rem; line-height: 1.25; }
/* 변경: 예전에 있던 font-weight:300 제거됨 */
```

**사용 예시 (HTML)**

```html
<article class="slds-media slds-media_center">
  <div class="slds-media__figure">
    <span class="slds-avatar slds-avatar_large">
      <img alt="홍길동" src="/avatar.jpg" />
    </span>
  </div>
  <div class="slds-media__body">
    <h3>홍길동</h3>
    <p class="slds-text-color_weak">제품 디자이너</p>
  </div>
</article>
```

---

## 14. Name Value List (이름-값 목록)

```css
.slds-list_horizontal { display: flex; }
.slds-list_horizontal .slds-item_label  { width: 30%; padding-right: 0.75rem; }
.slds-list_horizontal .slds-item_detail { width: 70%; }

.slds-truncate { max-width:100%; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
.slds-text-color_weak { color: var(--slds-g-color-neutral-base-30, rgb(68,68,68)); }

.slds-list_inline .slds-item_label  { max-width:180px; padding-right:0.75rem; flex-shrink:0; }
.slds-list_inline .slds-item_detail { min-width:0; }
```

- 라벨/값 쌍을 가로로 배치하고, 값은 필요 시 말줄임 처리.

**사용 예시 (HTML)**

```html
<ul>
  <li class="slds-list_horizontal slds-wrap">
    <span class="slds-item_label slds-text-color_weak slds-truncate">전화번호</span>
    <span class="slds-item_detail slds-truncate">010-1234-5678</span>
  </li>
  <li class="slds-list_horizontal slds-wrap">
    <span class="slds-item_label slds-text-color_weak slds-truncate">주소</span>
    <span class="slds-item_detail slds-truncate">서울특별시 …</span>
  </li>
</ul>
```

---

## 15. Padding (안쪽 여백)

스케일은 Margin과 동일. **원본의 `padding-horizontal` 등 잘못된 속성을 실제 CSS로 정정했습니다.**

### 방향별 (top 예시 — left/right/bottom 동일)

```css
.slds-p-top_none      { padding-top: 0 !important; }
.slds-p-top_xxx-small { padding-top: 0.125rem; }
.slds-p-top_xx-small  { padding-top: 0.25rem; }
.slds-p-top_x-small   { padding-top: 0.5rem; }
.slds-p-top_small     { padding-top: 0.75rem; }
.slds-p-top_medium    { padding-top: 1rem; }
.slds-p-top_large     { padding-top: 1.5rem; }
.slds-p-top_x-large   { padding-top: 2rem; }
.slds-p-top_xx-large  { padding-top: 3rem; }
```

### 축/전체 (정정된 실제 정의)

```css
.slds-p-horizontal_small { padding-left: 0.75rem; padding-right: 0.75rem; }   /* ❌ padding-horizontal 아님 */
.slds-p-vertical_medium  { padding-top: 1rem;     padding-bottom: 1rem; }     /* ❌ padding-vertical 아님 */
.slds-p-around_medium    { padding: 1rem; }                                   /* ❌ padding-around 아님 */
```

**사용 예시 (HTML)**

```html
<div class="slds-box slds-p-around_large">
  사방 1.5rem 안쪽 여백
</div>

<div class="slds-p-vertical_medium slds-p-horizontal_small">
  상하 1rem, 좌우 0.75rem 패딩
</div>
```

---

## 16. Position (위치)

```css
.slds-is-fixed    { position: fixed; }
.slds-is-absolute { position: absolute; }
.slds-is-relative { position: relative; }
.slds-is-static   { position: static; }
```

**사용 예시 (HTML)**

```html
<!-- 부모 relative + 자식 absolute로 배지 배치 -->
<div class="slds-is-relative slds-box">
  알림
  <span class="slds-is-absolute" style="top:-6px; right:-6px;">🔴</span>
</div>
```

---

## 17. Print (인쇄)

```css
.slds-no-print { display: none; }
```

- 인쇄 시 숨길 컴포넌트에 `slds-no-print` 를 추가합니다.

**사용 예시 (HTML)**

```html
<nav class="slds-no-print">화면에는 보이지만 인쇄 시 숨겨지는 내비게이션</nav>
<article>인쇄 대상 콘텐츠</article>
```

---

## 18. Scrollable (스크롤)

```css
.slds-scrollable   { -webkit-overflow-scrolling: touch; overflow: auto; }
.slds-scrollable_none { overflow: hidden; }
.slds-scrollable_x { -webkit-overflow-scrolling: touch; max-width: 100%;  overflow: hidden; overflow-x: auto; }
.slds-scrollable_y { -webkit-overflow-scrolling: touch; max-height: 100%; overflow: hidden; overflow-y: auto; }
```

- `_x`/`_y` 로 가로/세로 한 방향 스크롤을 만듭니다.

**사용 예시 (HTML)**

```html
<!-- 높이 제한 + 세로 스크롤 영역 -->
<div class="slds-scrollable_y slds-box" style="max-height: 12rem;">
  <p>긴 목록 …</p>
  <!-- … 많은 내용 … -->
</div>
```

---

## 19. Sizing (크기)

너비 분수 표기는 **6. Grid의 `slds-size_*`** 와 동일 시스템입니다. 박스/간격 유틸리티와 조합해 카드 레이아웃을 구성합니다.

```css
.slds-size_1-of-2 { width: 50%; }
.slds-size_1-of-3 { width: 33.3333333333%; }
.slds-size_1-of-4 { width: 25%; }
.slds-size_1-of-6 { width: 16.6666666667%; }
.slds-size_1-of-8 { width: 12.5%; }
.slds-size_1-of-12{ width: 8.3333333333%; }

/* 함께 자주 쓰는 조합 */
.slds-m-around_x-small { margin: 0.5rem; }
.slds-box_x-small      { padding: 0.5rem; }
.slds-text-align_center{ text-align: center; }
.slds-box { padding:1rem; border-radius:0.25rem; border:1px solid var(--slds-g-color-border-base-1, rgb(229,229,229)); }
```

**사용 예시 (HTML) — 카드 4장 그리드**

```html
<div class="slds-grid slds-wrap slds-gutters">
  <div class="slds-col slds-size_1-of-2 slds-medium-size_1-of-4">
    <div class="slds-box slds-text-align_center">카드 1</div>
  </div>
  <div class="slds-col slds-size_1-of-2 slds-medium-size_1-of-4">
    <div class="slds-box slds-text-align_center">카드 2</div>
  </div>
  <div class="slds-col slds-size_1-of-2 slds-medium-size_1-of-4">
    <div class="slds-box slds-text-align_center">카드 3</div>
  </div>
  <div class="slds-col slds-size_1-of-2 slds-medium-size_1-of-4">
    <div class="slds-box slds-text-align_center">카드 4</div>
  </div>
</div>
```

---

## 20. Text (텍스트)

### 본문 크기

```css
.slds-text-body_regular { font-size: 0.8125rem; }
.slds-text-body_small   { font-size: 0.75rem; }
```

### 제목 (변경: font-weight:300 제거)

```css
.slds-text-heading_large  { font-size: 1.75rem; line-height: 1.25; }
.slds-text-heading_medium { font-size: 1.25rem; line-height: 1.25; }
.slds-text-heading_small  { font-size: 1rem;    line-height: 1.25; }
```

### 타이틀

```css
.slds-text-title {
  font-size: 0.75rem; line-height: 1.25;
  color: var(--slds-g-color-neutral-base-30, rgb(68,68,68));
}
.slds-text-title_caps {
  font-size: 0.75rem; line-height: 1.25;
  color: var(--slds-g-color-neutral-base-30, rgb(68,68,68));
  font-weight: 400; text-transform: uppercase; letter-spacing: 0.0625rem;
}
```

### 정렬

```css
.slds-text-align_left   { text-align: left; }
.slds-text-align_right  { text-align: right; }
.slds-text-align_center { text-align: center; }
```

### 색상 (스타일링 훅)

```css
.slds-text-color_default      { color: var(--slds-g-color-neutral-base-10, rgb(24,24,24)); }
.slds-text-color_weak         { color: var(--slds-g-color-neutral-base-30, rgb(68,68,68)); }
.slds-text-color_error        { color: var(--slds-g-color-error-base-40, rgb(234,0,30)); }
.slds-text-color_destructive  { color: var(--slds-g-color-error-base-30, rgb(234,0,30)); }
.slds-text-color_inverse      { color: var(--slds-g-color-neutral-base-100, rgb(255,255,255)); }
.slds-text-color_inverse-weak { color: var(--slds-g-color-neutral-base-70, rgb(174,174,174)); }
```

### 폰트

```css
.slds-text-font_monospace { font-family: Consolas, Menlo, Monaco, Courier, monospace; }
```

**사용 예시 (HTML)**

```html
<h1 class="slds-text-heading_large">대제목</h1>
<p class="slds-text-title_caps slds-m-top_x-small">SECTION LABEL</p>
<p class="slds-text-body_regular">본문 텍스트입니다.</p>
<p class="slds-text-color_error">필수 입력 항목입니다.</p>
<code class="slds-text-font_monospace">npm install</code>
```

---

## 21. Themes (테마)

```css
.slds-theme_default { background-color: var(--slds-g-color-neutral-base-100, rgb(255,255,255));
                      color: var(--slds-g-color-neutral-base-10, rgb(24,24,24)); }
.slds-theme_shade   { background-color: var(--slds-g-color-neutral-base-95, rgb(243,243,243)); }
.slds-theme_alert-texture {
  background-image: linear-gradient(45deg,
    rgba(0,0,0,.025) 25%, transparent 25%, transparent 50%,
    rgba(0,0,0,.025) 50%, rgba(0,0,0,.025) 75%, transparent 75%, transparent);
  background-size: 64px 64px;
}
```

**사용 예시 (HTML)**

```html
<div class="slds-box slds-theme_shade">옅은 회색 배경 박스</div>

<!-- 상태 테마는 부록 A-1 참고 -->
<div class="slds-box slds-theme_success slds-text-color_inverse">저장되었습니다.</div>
```

---

## 22. Truncation (말줄임)

```css
.slds-truncate {
  max-width: 100%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.slds-has-flexi-truncate { flex: 1 1 0%; min-width: 0; }
.slds-no-flex            { flex: none; }

.slds-truncate_container_25 { max-width: 25%; }
.slds-truncate_container_33 { max-width: 33%; }
.slds-truncate_container_75 { max-width: 75%; }
```

- 한 줄 말줄임. flex 컨테이너 안에서는 `slds-has-flexi-truncate` / `slds-no-flex` 와 조합.

**사용 예시 (HTML)**

```html
<!-- 제목은 남는 공간만큼만 말줄임, 우측 메타는 고정 -->
<div class="slds-grid">
  <h3 class="slds-has-flexi-truncate slds-truncate" title="아주 긴 제목 전체">
    아주 긴 제목이 들어가면 말줄임 처리됩니다
  </h3>
  <span class="slds-no-flex slds-m-left_x-small">방금</span>
</div>
```

---

## 23. Vertical List (세로 목록)

```css
.slds-list_dotted  { margin-left: 1.5rem; list-style: disc; }
.slds-list_ordered { margin-left: 1.5rem; list-style: decimal; }
.slds-is-nested    { margin-left: 1rem; }

/* 링크 표시 방식 */
.slds-has-block-links a              { display:block; text-decoration:none; }
.slds-has-block-links_space a        { display:block; text-decoration:none; padding:0.75rem; }
.slds-has-inline-block-links a       { display:inline-block; text-decoration:none; }
.slds-has-inline-block-links_space a { display:inline-block; text-decoration:none; padding:0.75rem; }
```

### 구분선(divider) — 위/아래/사방

```css
.slds-has-dividers_top > .slds-item    { border-top:    1px solid var(--slds-g-color-border-base-1, rgb(229,229,229)); }
.slds-has-dividers_top-space > .slds-item { border-top: 1px solid var(--slds-g-color-border-base-1, rgb(229,229,229)); padding:0.75rem; }

.slds-has-dividers_bottom > .slds-item { border-bottom: 1px solid var(--slds-g-color-border-base-1, rgb(229,229,229)); }
.slds-has-dividers_bottom-space > .slds-item { border-bottom: 1px solid var(--slds-g-color-border-base-1, rgb(229,229,229)); padding:0.75rem; }

.slds-has-dividers_around > .slds-item {
  border: 1px solid var(--slds-g-color-border-base-1, rgb(229,229,229));
  border-radius: 0.25rem; background-clip: padding-box;
}
.slds-has-dividers_around > .slds-item + .slds-item { margin-top: 0.5rem; }
```

> 변경: 구분선 셀렉터가 `.slds-item` 뿐 아니라 `.slds-list__item` 도 함께 대상으로 하며, 색상은 테두리 스타일링 훅을 사용합니다.

**사용 예시 (HTML)**

```html
<!-- 항목마다 위 구분선 + 패딩 -->
<ul class="slds-has-dividers_top-space">
  <li class="slds-item">항목 1</li>
  <li class="slds-item">항목 2</li>
  <li class="slds-item">항목 3</li>
</ul>

<!-- 카드형(사방 테두리) 목록 -->
<ul class="slds-has-dividers_around">
  <li class="slds-item slds-p-around_small">카드 항목 1</li>
  <li class="slds-item slds-p-around_small">카드 항목 2</li>
</ul>
```

---

## 24. Visibility (표시/숨김)

```css
.slds-assistive-text {     /* 스크린리더 전용(시각적으로 숨김) */
  position: absolute !important; margin: -1px !important;
  border: 0 !important; padding: 0 !important;
  width: 1px !important; height: 1px !important;
  overflow: hidden !important; clip: rect(0 0 0 0) !important;
  text-transform: none !important; white-space: nowrap !important;
}

.slds-is-expanded  { height: auto; overflow: visible; }
.slds-is-collapsed { height: 0;    overflow: hidden; }

.slds-hidden  { visibility: hidden !important; }
.slds-visible { visibility: visible; }

.slds-show              { display: block; }
.slds-show_inline-block { display: inline-block; }

.slds-transition-hide { opacity: 0; }
.slds-transition-show { opacity: 1; }
```

**사용 예시 (HTML)**

```html
<!-- 아이콘 버튼의 접근성 라벨(시각적으로 숨김, 스크린리더만 읽음) -->
<button class="slds-button">
  <svg aria-hidden="true" width="16" height="16"><!-- 아이콘 --></svg>
  <span class="slds-assistive-text">닫기</span>
</button>

<!-- 토글로 펼침/접힘 -->
<section class="slds-is-collapsed">접힌 콘텐츠</section>
```

---

## 부록 A. 원본에 없던 최신 유틸리티 (추가 권장)

원본 PPT에는 없지만 현재 SLDS에서 자주 쓰이는 유틸리티입니다.

### A-1. 추가 테마 변형 (상태 색상)

`slds-theme_default`/`shade` 외에 상태별 배경 테마가 있습니다.

```css
.slds-theme_inverse { color: var(--slds-g-color-neutral-base-100, rgb(255,255,255));
                      background-color: var(--slds-g-color-brand-base-10, rgb(0,22,57)); }
.slds-theme_success { color: var(--slds-g-color-neutral-base-100, rgb(255,255,255));
                      background-color: var(--slds-g-color-success-base-50, rgb(46,132,74)); }
.slds-theme_warning { color: var(--slds-g-color-neutral-base-10, rgb(24,24,24));
                      background-color: var(--slds-g-color-warning-base-60, rgb(254,147,57)); }
.slds-theme_error   { color: var(--slds-g-color-neutral-base-100, rgb(255,255,255));
                      background-color: var(--slds-g-color-error-base-40, rgb(234,0,30)); }
.slds-theme_info    { color: var(--slds-g-color-neutral-base-100, rgb(255,255,255));
                      background-color: var(--slds-g-color-neutral-base-50, rgb(116,116,116)); }
```

**사용 예시 (HTML)**

```html
<div class="slds-box slds-theme_error   slds-text-color_inverse">오류가 발생했습니다.</div>
<div class="slds-box slds-theme_warning slds-m-top_x-small">주의가 필요합니다.</div>
<div class="slds-box slds-theme_success slds-text-color_inverse slds-m-top_x-small">완료되었습니다.</div>
```

### A-2. 추가 그리드 유틸리티

```css
/* 뷰포트 전체를 채우는 프레임 (앱 셸 레이아웃에 사용) */
.slds-grid_frame { min-width: 100vw; min-height: 100vh; overflow: hidden; }

/* 컬럼 자체에 패딩을 직접 부여 (gutters 대안) */
.slds-col_padded        { padding-right: 0.75rem; padding-left: 0.75rem; }
.slds-col_padded-medium { padding-right: 1rem;    padding-left: 1rem; }

/* flex grow/shrink 제어 */
.slds-grow-none   { flex-grow: 0; }
.slds-shrink-none { flex-shrink: 0; }
```

**사용 예시 (HTML)**

```html
<div class="slds-grid">
  <div class="slds-col_padded">패딩이 들어간 컬럼</div>
  <div class="slds-col_padded slds-shrink-none" style="width:120px;">고정폭 컬럼</div>
</div>
```

### A-3. 가짜 링크(faux link)

링크처럼 보이지만 hover 시에만 밑줄이 생기는 스타일.

```css
.slds-text-link_faux {
  border-bottom: 1px solid transparent;
  border-radius: 0;
  color: currentColor;
  cursor: pointer;
}
```

**사용 예시 (HTML)**

```html
<span class="slds-text-link_faux">호버하면 밑줄이 생기는 텍스트</span>
```

---

## 부록 B. SLDS 2 마이그레이션 참고

- **스타일링 훅 네이밍 규칙**
  - `--slds-g-*` : 전역(Global) 훅 — 색상/간격 등 디자인 토큰. 예) `--slds-g-color-border-base-1`, `--slds-g-spacing-4`
  - `--slds-c-*` : 컴포넌트(Component) 훅 — 특정 컴포넌트 테마용. 예) `--slds-c-button-color-background`
  - 구형 `--lwc-*`, `--sds-c-*` 토큰은 폴백으로만 남아 있으며 **신규 코드에서는 `--slds-*` 훅 사용을 권장**합니다.
- **권장 표기:** 신형 `_`(언더스코어, BEM) 표기 사용. 구형 `--`(더블 대시) 표기는 하위호환용으로만 유지됩니다.
- **자동 점검 도구:** `@salesforce-ux/slds-linter` 로 폐기된 클래스/토큰 사용을 자동 검출할 수 있습니다.
  ```bash
  npx @salesforce-ux/slds-linter lint
  ```

**스타일링 훅으로 색상 커스텀 예시 (HTML)**

```html
<!-- 컨테이너 단위로 훅 값을 덮어써서 일괄 테마 적용 -->
<div class="slds-scope" style="--slds-g-color-border-base-1:#c084fc;">
  <div class="slds-box">테두리 색이 보라색으로 바뀐 박스</div>
  <div class="slds-box slds-m-top_x-small">같은 컨테이너 안은 모두 적용</div>
</div>
```

---

### 참고 자료

- SLDS 2 공식 문서: <https://www.lightningdesignsystem.com/2e1ef8501/p/85bd85-lightning-design-system-2>
- Utility Classes (SLDS 2): <https://www.lightningdesignsystem.com/2e1ef8501/p/05098e-utility-classes>
- npm 패키지(검증 기준): `@salesforce-ux/design-system@2.30.4`

---

## 관련 노트

- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[SLDS LWC 디자인 시스템]] — SLDS 2 개념·스타일링 훅·LWC 적용 규칙
- [[SLDS 스타일링 훅]] — 색상/밀도 CSS 커스텀 속성
- [[LWC MOC]]
