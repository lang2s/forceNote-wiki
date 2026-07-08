---
tags: [slds, slds2, styling-hooks, design-tokens, css-custom-properties, reference]
source: lightningdesignsystem.com — Global Styling Hooks (SLDS 2, Tier 2)
created: 2026-07-08
aliases: [SLDS Global Styling Hooks, 글로벌 스타일링 훅, 스타일링 훅 토큰, design tokens, --slds-g-color, --slds-g-spacing, --slds-g-sizing, --slds-g-radius, --slds-g-font, --slds-g-shadow, SLDS 토큰 스케일]
---

# SLDS 글로벌 스타일링 훅 토큰 레퍼런스

> SLDS 2 글로벌 스타일링 훅(`--slds-g-*`) 전역 디자인 토큰을 카테고리·네이밍 규칙·대표 토큰(정확한 스케일 값 포함)으로 정리한 레퍼런스. 전체 목록은 공식 Global Styling Hooks Index.

> 출처: [SLDS 2 · Global Styling Hooks](https://www.lightningdesignsystem.com/2e1ef8501/p/591960-global-styling-hooks) · [Styling Hooks 개요](https://www.lightningdesignsystem.com/2e1ef8501/p/319e5f-styling-hooks)
> 개념·왜 쓰는가·컴포넌트 훅과의 관계는 [[SLDS 스타일링 훅]] 참조 — 이 노트는 그 노트가 "전체 목록은 공식 Reference"로 외부 위임한 **토큰 카탈로그**를 채운다.

---

## 1. 네이밍 규칙

글로벌 훅은 **네임스페이스 + 카테고리 + 항목** 구조의 CSS 커스텀 프로퍼티다.

```
--slds-g-{category}-{item}[-{scaleIndex}]

  └ --slds-  : SLDS 네임스페이스
  └ g        : global (전역) — 컴포넌트 훅은 c
  └ category : color · spacing · sizing · radius · font · shadow · duration ...
  └ item     : 카테고리 안의 역할(surface, weight, border ...) 또는 스케일 이름
```

| 접두사 | 의미 | 지원 | 예시 |
|---|---|---|---|
| `--slds-g-*` | **글로벌 훅** — 앱 전역 디자인 토큰. SLDS 2 권장 방식 | 코드 참조는 SLDS 2 (시스템 색·팔레트는 SLDS 1·2 공용) | `--slds-g-color-surface-1`, `--slds-g-spacing-4` |
| `--slds-c-*` | **컴포넌트 레벨 훅** — 단일 컴포넌트만 조정 | **SLDS 1 전용** (SLDS 2 미지원) | `--slds-g-c` 아님 → `--slds-c-button-color-background` |

- 스케일형 토큰은 **공통 base 이름 + 숫자 인덱스**로 세트를 이룬다. 대개 `1`이 가장 작은/시작 값이고 위로 증가한다. 단 카테고리마다 범위가 다르다(spacing 1–12, sizing 1–16, font-weight 1–7 …).
- 글로벌 훅은 **참조만** 한다 — `var(...)`로 읽되 값을 **할당하지 않는다**(값 할당은 테마·브랜딩 도구 전용). 자세한 규율은 [[SLDS 스타일링 훅]].

```css
/* 구조 예시 — 실제 SLDS 토큰명 사용, 임의 조합 */
.myCard {
  background: var(--slds-g-color-surface-container-1, #fff);
  color:      var(--slds-g-color-on-surface-1, #181818);
  padding:    var(--slds-g-spacing-4, 1rem);
  border:     var(--slds-g-sizing-border-1, 1px) solid var(--slds-g-color-border-1, #c9c9c9);
  border-radius: var(--slds-g-radius-border-2, 0.25rem);
  font-size:  var(--slds-g-font-scale-2, 1rem);
  font-weight: var(--slds-g-font-weight-4, 400);
}
```

> 항상 **fallback 값**을 함께 넣는다(`var(--훅, 폴백)`) — SLDS 1 복귀나 미지원 환경에서도 깨지지 않게.

---

## 2. Color — `--slds-g-color-*`

색 시스템은 **① 시맨틱 색(surface·on-surface·accent·border·feedback)**, **② 시스템/접근성 색**, **③ 팔레트 색** 세 층이다. ①은 SLDS 2 전용, ②·③은 SLDS 1·2 공용.

### 2-1. Surface (표면 — 요소가 얹히는 캔버스)

| 토큰 | 용도 |
|---|---|
| `--slds-g-color-surface-1` | 페이지 배경 |
| `--slds-g-color-surface-2` | 더 어두운 페이지 배경 |
| `--slds-g-color-surface-3` | 세 번째 표면 레이어 |
| `--slds-g-color-surface-container-1` ~ `-3` | 표면 위에 얹혀 다른 UI를 담는 컨테이너(카드 등) 배경 |
| `--slds-g-color-surface-inverse-1` / `-2` | 반전(다크) 페이지 배경. `on-surface-inverse-*`와 페어 |
| `--slds-g-color-surface-container-inverse-1` / `-2` | 반전 컨테이너 배경 |

### 2-2. On-surface (표면 위의 텍스트·아이콘 fill)

| 토큰 | 용도 |
|---|---|
| `--slds-g-color-on-surface-1` ~ `-3` | surface/surface-container 위의 텍스트·아이콘 색 (WCAG 대비를 위해 짝 맞춤) |
| `--slds-g-color-on-surface-inverse-1` / `-2` | 어두운 배경 위 텍스트·아이콘 |
| `--slds-g-color-on-accent-1` | accent 배경 위 콘텐츠 fill |
| `--slds-g-color-on-error-1` | 에러 배경 위 콘텐츠 fill (feedback `on-*` 계열 대표) |

### 2-3. Accent (브랜드 강조색)

| 토큰 | 용도 |
|---|---|
| `--slds-g-color-accent-1` ~ `-3` | 브랜드 강조색 (텍스트·아이콘이 위에 없을 때) |
| `--slds-g-color-accent-container-1` ~ `-3` | 강조 컨테이너 배경 |

### 2-4. Border

| 토큰 | 용도 |
|---|---|
| `--slds-g-color-border-1` / `-2` | 일반 테두리·구분선 |
| `--slds-g-color-border-accent-1` ~ `-3` | 브랜드 accent 색 테두리·아웃라인 |

### 2-5. Feedback (상태 피드백 — error·success·warning·info)

액션/이벤트 상태를 시각적으로 알린다. 각 계열은 `base` 배경 + `on-*` 대비 fill 변형을 가진다.

| 계열 | 의미 | 대표 토큰 |
|---|---|---|
| error | 진행 전 해결해야 할 오류 | `--slds-g-color-error-base-*`, `--slds-g-color-on-error-1` |
| success | 긍정/성공한 액션·결과 | `--slds-g-color-success-base-*` |
| warning | 주의가 필요한 잠재적 이슈 | `--slds-g-color-warning-base-*` |
| info | 비긴급 정보 전달 | `--slds-g-color-info-base-*` |

> 규칙: accent/feedback 색은 **위에 텍스트·아이콘이 올라가지 않을 때만** 배경으로 쓴다. surface 색과 accent 색을 섞지 않는다.

### 2-6. 시스템/접근성 색 · 팔레트 (SLDS 1·2 공용)

명도 인덱스(`00`~`100`, 대개 10단위)를 붙여 대비를 정밀 제어한다.

| 종류 | 네이밍 | 예시 |
|---|---|---|
| 시스템 색 (semantic base) | `--slds-g-color-{brand\|error\|success\|warning}-base-{명도}` | `--slds-g-color-brand-base-50`, `--slds-g-color-error-base-60` |
| 팔레트 색 (raw hue) | `--slds-g-color-palette-{hue}-{명도}` | `--slds-g-color-palette-blue-50`, `--slds-g-color-palette-green-60` |

전체 목록: [Color 스타일링 훅](https://www.lightningdesignsystem.com/2e1ef8501/p/655b28-color)

---

## 3. Spacing — `--slds-g-spacing-*` (여백: margin·padding·gap)

루트 폰트 크기 기준 rem. **4-point grid**(4의 배수)에 맞춘 12단 스케일. SLDS 1과 동일 값.

| 토큰 | rem | px |
|---|---|---|
| `--slds-g-spacing-1` | 0.25rem | 4 |
| `--slds-g-spacing-2` | 0.5rem | 8 |
| `--slds-g-spacing-3` | 0.75rem | 12 |
| `--slds-g-spacing-4` | 1rem | 16 |
| `--slds-g-spacing-5` | 1.5rem | 24 |
| `--slds-g-spacing-6` | 2rem | 32 |
| `--slds-g-spacing-7` | 2.5rem | 40 |
| `--slds-g-spacing-8` | 3rem | 48 |
| `--slds-g-spacing-9` | 3.5rem | 56 |
| `--slds-g-spacing-10` | 4rem | 64 |
| `--slds-g-spacing-11` | 4.5rem | 72 |
| `--slds-g-spacing-12` | 5rem | 80 |

**Density-aware (밀도 대응)** — 컴팩트/컴포트 밀도에 따라 자동 축소:

| 토큰 | 축 |
|---|---|
| `--slds-g-spacing-var-{n}` | 모든 방향에 균등 적용 |
| `--slds-g-spacing-var-inline-{n}` | 수평(inline) 축 — 좌우 margin/padding |
| `--slds-g-spacing-var-block-{n}` | 수직(block) 축 — 상하 margin/padding |

> spacing은 **간격 전용**이다. 요소의 width/height는 sizing으로 잡는다.

---

## 4. Sizing — `--slds-g-sizing-*` (치수: width·height·min/max)

요소 자체의 크기. 16단 스케일(일부 대표값):

| 토큰 | px | | 토큰 | px |
|---|---|---|---|---|
| `--slds-g-sizing-1` | 2 | | `--slds-g-sizing-9` | (중간대) |
| `--slds-g-sizing-2` | 4 | | `--slds-g-sizing-10` | 48 |
| `--slds-g-sizing-3` | 8 | | `--slds-g-sizing-11` | 64 |
| `--slds-g-sizing-4` | 12 | | `--slds-g-sizing-12` | 80 |
| `--slds-g-sizing-5` | 16 | | `--slds-g-sizing-13` | 160 |
| `--slds-g-sizing-6` | 20 | | `--slds-g-sizing-14` | 240 |
| `--slds-g-sizing-7` | 28 | | `--slds-g-sizing-15` | 320 |
| `--slds-g-sizing-8` | 32 | | `--slds-g-sizing-16` | 480 |

- 테두리 두께는 별도 sizing 훅 계열(`--slds-g-sizing-border-*`, 예: `1` = 1px)을 쓴다.
- 전체 스케일·중간값: [Spacing and Sizing](https://www.lightningdesignsystem.com/2e1ef8501/p/03d6b0-spacing-and-sizing)

---

## 5. Radius — `--slds-g-radius-border-*` (모서리 둥글기)

`radius-border` 라벨 뒤에 스케일 인덱스. `1`(가장 작음)부터 증가하며, 완전한 원/알약형을 위한 `circle` 값이 있다.

| 토큰 | 용도 |
|---|---|
| `--slds-g-radius-border-1` | 가장 작은 둥글기 |
| `--slds-g-radius-border-2` ~ `-N` | 점진적으로 큰 둥글기 |
| `--slds-g-radius-border-circle` | 완전 원형/알약형(pill) |

전체: [Borders and Radius](https://www.lightningdesignsystem.com/2e1ef8501/p/7770b4-borders-and-radius)

---

## 6. Font — `--slds-g-font-*` (타이포그래피)

### 6-1. Font scale (크기) — `--slds-g-font-scale-*`

기준 `--slds-g-font-size-base` = 13px. 음수 인덱스(`neg-*`)로 더 작게.

| 토큰 | px |
|---|---|
| `--slds-g-font-scale-neg-2` | 10 |
| `--slds-g-font-scale-neg-1` | 12 |
| `--slds-g-font-size-base` | 13 |
| `--slds-g-font-scale-1` | 14 |
| `--slds-g-font-scale-2` | 16 |
| `--slds-g-font-scale-3` | 20 |
| `--slds-g-font-scale-4` | 24 |
| `--slds-g-font-scale-5` | 28 |
| `--slds-g-font-scale-6` | 32 |
| `--slds-g-font-scale-7` | 40 |
| `--slds-g-font-scale-8` | 48 |

### 6-2. Font weight (굵기) — `--slds-g-font-weight-*`

`4`(400, Regular)가 기본.

| 토큰 | CSS weight | 이름 |
|---|---|---|
| `--slds-g-font-weight-1` | 100 | Thin |
| `--slds-g-font-weight-2` | 200 | — |
| `--slds-g-font-weight-3` | 300 | Light |
| `--slds-g-font-weight-4` | 400 | Regular (기본) |
| `--slds-g-font-weight-5` | 500 | Medium |
| `--slds-g-font-weight-6` | 600 | SemiBold |
| `--slds-g-font-weight-7` | 700 | Bold |

### 6-3. Line height (행간) — `--slds-g-font-lineheight-*`

| 토큰 | px | | 토큰 | px |
|---|---|---|---|---|
| `--slds-g-font-lineheight-1` | 16 | | `--slds-g-font-lineheight-4` | 24 |
| `--slds-g-font-lineheight-2` | 20 | | `--slds-g-font-lineheight-5` | 28 |
| `--slds-g-font-lineheight-3` | 22 | | `--slds-g-font-lineheight-6` | 32 |

- Density-aware: `--slds-g-font-scale-var-*`, `--slds-g-font-lineheight-var-*`.
- font-family는 별도 family 훅으로 노출. 전체: [Typography](https://www.lightningdesignsystem.com/2e1ef8501/p/93288f-typography)

---

## 7. Shadow — `--slds-g-shadow-*` (그림자·엘리베이션)

SLDS 2는 소프트 섀도로 깊이를 표현한다. `shadow` 라벨 + 스케일 인덱스(작을수록 얕은 엘리베이션):

| 토큰 | 용도 |
|---|---|
| `--slds-g-shadow-1` | 가장 얕은 그림자 |
| `--slds-g-shadow-2` ~ `-N` | 점점 깊은 엘리베이션 |
| `--slds-g-shadow-inset-*` | 안쪽(inset) 그림자 계열 |

전체: [Shadows](https://www.lightningdesignsystem.com/2e1ef8501/p/64b580-shadows)

---

## 8. Duration — `--slds-g-duration-*` (모션 지속시간)

애니메이션·트랜지션 지속시간을 시맨틱 이름으로.

| 토큰 | 의미 |
|---|---|
| `--slds-g-duration-immediately` | 즉시(0) |
| `--slds-g-duration-paused` | 정지(모션 감소 설정 대응) |
| (기타 속도 단계) | 짧음~긺 단계별 지속시간 |

---

## 9. SLDS 1 (design tokens)과의 관계

| | SLDS 1 | SLDS 2 |
|---|---|---|
| 값 참조 방식 | **design tokens** — `--lwc-` 접두사 + camelCase (예: `--lwc-spacingSmall`) | **global styling hooks** — `--slds-g-*` |
| 상태 | design token은 SLDS 2에서 **deprecated** | 권장 방식 |
| 컴포넌트 훅 | `--slds-c-*` 지원 | `--slds-c-*` **미지원** (org를 SLDS 1 테마로 유지) |
| 공용 | 시스템 색(`--slds-g-color-*-base-*`)·팔레트는 양쪽 지원 | 동일 |

> ⚠️ 컴파일 타임에 변수가 실제 값으로 치환되므로 런타임 `getPropertyValue()`/`setProperty()`로 이 훅 값을 읽거나 바꿀 수 없다.

출처: [LWC Dev Guide · SLDS Styling Hooks](https://developer.salesforce.com/docs/platform/lwc/guide/create-components-css-custom-properties.html) · [SLDS Design Tokens](https://developer.salesforce.com/docs/platform/lwc/guide/create-components-css-design-tokens.html)

---

## 관련 노트

- [[SLDS 스타일링 훅]] — 스타일링 훅 개념·글로벌 vs 컴포넌트 훅·사용 규율(이 토큰 카탈로그의 상위 개념)
- [[SLDS 유틸리티 클래스 레퍼런스]] — 이 훅들이 적용된 실제 유틸리티 클래스(`slds-p-*`·`slds-m-*` 등)와 HTML 예제
- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[LWC MOC]]
