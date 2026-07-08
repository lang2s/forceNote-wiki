---
tags: [slds, slds2, cosmos, dark-mode, density, theme, styling-hooks, lwc]
source: SLDS2-Docs — lightningdesignsystem.com · Trailhead(dark-mode-ready-components-in-slds-2) · salesforce.com/blog/what-is-slds-2 (Tier 2)
created: 2026-07-08
aliases: [SLDS 2 Theme, Cosmos Theme, 코스모스 테마, Dark Mode, 다크모드, Display Density, 밀도, comfy, compact, slds-color-scheme_dark, light-dark]
---

# SLDS 2 테마 · 다크모드 · 밀도 (Cosmos · Dark Mode · Density)

> SLDS 2의 조직 레벨 테마(Salesforce Cosmos)·다크모드·표시 밀도(Density)를 스타일링 훅 기반으로 정리하고, 커스텀 LWC를 이 세 가지에 대응시키는 절차를 설명합니다.

> [!info] 출처 · Tier
> 모두 Tier 2 공식 웹 문서 기반입니다:
> [SLDS 2](https://www.lightningdesignsystem.com/2e1ef8501/p/50ca07-slds-2) · [Display Density](https://www.lightningdesignsystem.com/2e1ef8501/p/805bbe) · [Activate SLDS 2 & Preview Dark Mode (Trailhead)](https://trailhead.salesforce.com/content/learn/modules/dark-mode-ready-components-in-slds-2/activate-slds-2-and-preview-dark-mode) · [Modify Custom Components for Dark Mode (Trailhead)](https://trailhead.salesforce.com/content/learn/modules/dark-mode-ready-components-in-slds-2/modify-custom-components-for-dark-mode-with-slds-linter)

---

## 1. SLDS 2 · Cosmos 테마 — 개념

SLDS 2는 **구조(structure)와 시각 디자인(visual design)을 분리**한 새 CSS 프레임워크이고, 그 분리를 가능하게 하는 축이 **스타일링 훅(CSS 변수)** 입니다. 하드코딩된 색·간격 대신 `--slds-g-*` 글로벌 훅을 참조하면, 같은 컴포넌트가 **색 모드(라이트/다크)·브랜드 색·밀도**에 따라 값이 **런타임에 자동으로 바뀝니다**.

- **Salesforce Cosmos** = 조직이 SLDS 2를 사용(opt-in)하도록 켜는 **테마**입니다. Setup에서 Cosmos 테마를 활성화하면 그 조직의 UI가 SLDS 2 스타일 파이프라인으로 렌더됩니다.
- 스타일링 훅이 "정적 UI → 동적 UI"로 바꿔주기 때문에, **다크모드**·**밀도**·**브랜드 테마** 같은 실시간 개인화 기능이 성립합니다.
- 이 노트는 그 세 가지 동적 축(테마 활성화 · 다크모드 · 밀도)과 커스텀 LWC 대응을 다룹니다. 훅 체계 자체의 상세는 [[SLDS 스타일링 훅]]을 참조하세요.

### 릴리스 상태 (버전 명시)

| 기능 | 상태 | 근거 |
|---|---|---|
| **SLDS 2 / Cosmos 테마** | Spring '25 도입 (opt-in) | [[SLDS 모범 사례]] · lightningdesignsystem.com |
| **다크모드** | **Winter '26 Beta** — 처음엔 Starter 계열, 이후 Sales·Service Cloud로 점진 롤아웃 | salesforce.com/blog/what-is-slds-2 |
| 다크모드 지원 에디션 | Winter '26 기준 Free/Starter/Pro Suite · Professional · Enterprise · Developer | Trailhead(dark-mode-in-slds-2) |

> [!warning] Beta 범위 주의
> 다크모드는 **Beta**(Winter '26)입니다. 위 에디션·범위는 롤아웃 진행에 따라 바뀔 수 있으니, 프로덕션 적용 전 최신 릴리스 노트를 확인하세요.

---

## 2. 조직 레벨 활성화 (Setup 절차)

SLDS 2와 다크모드는 **Setup > Themes and Branding**에서 켭니다.

### 2-1. SLDS 2(Cosmos) 켜기
1. **Setup > Themes and Branding** 로 이동
2. **Salesforce Cosmos** 테마의 드롭다운에서 **Activate** 선택 → 조직에 SLDS 2 적용
   - (프로덕션 활성화 전 미리 보려면 Cosmos에서 **Preview** 만 눌러 확인 가능)

### 2-2. 브랜드 색으로 커스텀 테마 만들기
1. **Setup > Themes and Branding** → **New Theme**
2. 테마 이름과 **brand color**(예: `#9900FF`) 입력
3. Salesforce가 그 브랜드 색을 기준으로 **접근성 있는 색 팔레트를 자동 생성**
4. **Save**

### 2-3. 다크모드 켜기 (사용자 선택형)
1. 커스텀 테마에서 **"Let users enable Dark Mode"** 체크
2. **Save** → **Preview**
3. 앱으로 이동해 아바타 클릭 → **Dark** 선택으로 다크모드 미리보기 토글
4. 활성화 전 라이트/다크 양쪽 외관을 검증

> 다크모드를 켜면 **최종 라이트/다크 선택은 사용자**가 아바타 메뉴에서 합니다. 관리자는 "허용" 여부만 정합니다.

---

## 3. 다크모드 — 동작 원리와 CSS

### 3-1. 핵심: 글로벌 훅이 색 모드에 따라 스스로 해석된다
다크모드 대응의 정석은 **하드코딩 색을 글로벌 스타일링 훅(`--slds-g-color-*`)으로 교체**하는 것입니다. 이 훅들은 현재 색 모드(라이트/다크)와 조직 브랜드에 맞춰 **자동으로 알맞은 값으로 해석(resolve)** 되므로, 컴포넌트마다 조건 분기 CSS를 쓸 필요가 없습니다. SLDS 2 호환 훅은 전부 `--slds-g` 로 시작합니다.

```css
/* 다크모드 대응: 하드코딩 색 대신 글로벌 훅 사용 */
.custom-card {
  /* surface 훅이 라이트/다크에 맞는 배경을 스스로 해석 (폴백은 SLDS 1 훅) */
  background: var(--slds-g-color-surface-container-1, var(--lwc-colorBackgroundAlt));
  color: var(--slds-g-color-on-surface-1);
  border-color: var(--slds-g-color-border-1);
}
```

자주 쓰는 대응 훅:

| 용도 | 하드코딩(지양) | 글로벌 훅(권장) |
|---|---|---|
| 표면/배경 | `#FFFFFF` | `--slds-g-color-surface-1`, `--slds-g-color-surface-container-1` |
| 표면 위 텍스트 | `#000000` | `--slds-g-color-on-surface-1` |
| 텍스트(중립) | `#ffffff` | `--slds-g-color-neutral-100` |
| 브랜드/인터랙티브 | `#0070d2` | `--slds-g-color-brand-base-40`, `--slds-g-color-accent-1` |

### 3-2. 표준 CSS 기반: `color-scheme` · `light-dark()`
SLDS 2의 색 모드 전환은 표준 CSS 색 모드 메커니즘 위에 얹혀 있습니다. 브라우저 표준인 `color-scheme` 속성과 `light-dark()` 함수가 그 토대입니다.

```css
/* 구조 예시 — 실제 동작 코드 아님 (표준 CSS 색 모드 메커니즘 설명용) */
:root {
  color-scheme: light dark;                 /* 이 서브트리가 두 모드를 모두 지원함을 선언 */
}
.example {
  /* light-dark(라이트값, 다크값): color-scheme가 dark로 해석되면 두 번째 값 사용 */
  background: light-dark(#ffffff, #1a1a1a);
}
```

> [!warning] 검증 범위 (Tier 표기)
> 위 `color-scheme` / `light-dark()` 는 **W3C 표준 CSS** 기능이며 SLDS 2 색 모드가 의존하는 저수준 토대입니다. 다만 **`slds-color-scheme_dark` 라는 특정 클래스명**은 공식 SLDS 문서에서 verbatim으로 확인하지 못했습니다 — Salesforce는 색 모드 토글을 프레임워크가 처리하고, **개발자에게는 "글로벌 훅을 쓰라"** 고 안내합니다. 따라서 커스텀 LWC에서는 `light-dark()`를 직접 손으로 쓰기보다 **`--slds-g-color-*` 훅을 참조**하는 것이 공식 권장 경로입니다(훅 내부가 이미 색 모드에 반응).

### 3-3. SLDS Linter로 준수 검증
하드코딩 색(`rgb(92,92,92)` 같은)을 찾아 SLDS 2·다크모드 표준 위반을 잡아줍니다. 행·열 위치로 위반을 표시하고 `--fix`로 자동 수정도 가능합니다.

```bash
# SLDS 2 / 다크모드 준수 검사
npx @salesforce-ux/slds-linter@latest lint
# 자동 수정
npx @salesforce-ux/slds-linter@latest lint --fix
```

목표는 텍스트 색이 배경과 올바르게 대비되어 **다크모드 요건 + WCAG 색 대비**를 동시에 만족시키는 것입니다.

---

## 4. 밀도(Display Density) — comfy vs compact

SLDS 2는 두 가지 표시 밀도를 제공하며, 사용자가 자기 선호/용도에 맞게 고릅니다.

| 밀도 | 설명 |
|---|---|
| **Comfy** (기본) | 라벨을 필드 **위**에 두고, 페이지 요소 사이 **간격을 넓게**. |
| **Compact** | 라벨을 필드와 **같은 줄**에 두고, 줄 간격을 **좁혀** 시각 밀도를 높임. |

### 4-1. 밀도 대응 스타일링 훅 (density-aware)
밀도가 바뀌면 값이 자동 조정되는 **variable spacing 훅**을 쓰면, 컴포넌트가 comfy/compact에 저절로 반응합니다.

| 방향 | 훅 패턴 |
|---|---|
| 상·하·좌·우 전체 간격 | `--slds-g-spacing-var-[size]` |
| 가로(inline) 간격 | `--slds-g-spacing-var-inline-[size]` |
| 세로(block) 간격 | `--slds-g-spacing-var-block-[size]` |

```css
/* 밀도 대응: 고정 간격 대신 variable spacing 훅 사용 */
.custom-row {
  padding-block: var(--slds-g-spacing-var-block-4);   /* 세로 — 밀도에 따라 축소 */
  padding-inline: var(--slds-g-spacing-var-inline-4); /* 가로 — 밀도에 따라 축소 */
  gap: var(--slds-g-spacing-var-2);
}
```

> 밀도 **비대응** 고정 간격이 필요하면 일반 `--slds-g-spacing-*`(예: `--slds-g-spacing-4`)을, **밀도 대응**이 필요하면 `--slds-g-spacing-var-*`를 씁니다. 두 계열의 구분은 [[SLDS 스타일링 훅]]의 훅 종류 표를 참조하세요.

---

## 5. 커스텀 LWC에 테마·다크·밀도 적용 — 절차 요약

1. **조직에서 Cosmos(SLDS 2) 활성화** — Setup > Themes and Branding > Salesforce Cosmos > Activate.
2. **하드코딩 색·간격 제거** — 색은 `--slds-g-color-*`, 밀도 대응 간격은 `--slds-g-spacing-var-*`로 교체(항상 `var(--훅, 폴백)`로 SLDS 1 폴백 병기 → [[SLDS 모범 사례]]).
3. **다크모드 준비** — 배경 `--slds-g-color-surface-*`, 텍스트 `--slds-g-color-on-surface-*`/`--slds-g-color-neutral-*`로 통일. 색 모드 전환은 프레임워크가 처리하므로 조건 CSS 불필요.
4. **밀도 준비** — 여백을 `--slds-g-spacing-var-inline-*` / `-block-*`로 두어 comfy/compact에 자동 반응.
5. **검증** — `slds-linter`로 위반 스캔 + 라이트/다크·comfy/compact를 아바타 메뉴로 토글해 육안 확인.

```css
/* 구조 예시 — 위 5단계를 한 컴포넌트에 종합 (실제 브랜드값은 조직 테마가 주입) */
.my-lwc-panel {
  background: var(--slds-g-color-surface-container-1, var(--lwc-colorBackgroundAlt)); /* 다크 대응 */
  color: var(--slds-g-color-on-surface-1);                                           /* 다크 대응 */
  padding-block: var(--slds-g-spacing-var-block-4);                                  /* 밀도 대응 */
  padding-inline: var(--slds-g-spacing-var-inline-4);                                /* 밀도 대응 */
  border: 1px solid var(--slds-g-color-border-1);
}
```

---

## 관련 노트

- [[SLDS 스타일링 훅]] — `--slds-g-*` 글로벌 훅·컴포넌트 훅 체계 (이 노트의 색·밀도 훅 상세)
- [[SLDS 글로벌 스타일링 훅 토큰 레퍼런스]] — 병렬 토큰 카탈로그
- [[SLDS 모범 사례]] — SLDS 1 vs 2, 폴백 병기, opt-in/되돌리기
- [[SLDS 유틸리티 클래스 레퍼런스]] — 유틸리티 클래스와 훅의 관계
- [[LWC MOC]] — LWC 섹션 목차
