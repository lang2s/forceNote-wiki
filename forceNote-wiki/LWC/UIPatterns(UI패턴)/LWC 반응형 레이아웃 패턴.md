---
tags: [LWC, UIPatterns, responsive, slds-grid, lightning-layout, form-factor]
source: lightningdesignsystem.com Grid·Layout + component-library(lightning-layout, lightning-layout-item) + developer.salesforce.com @salesforce/client/formFactor (Tier 2)
created: 2026-07-08
aliases: [LWC 반응형 레이아웃, responsive layout, slds-grid, slds-col, lightning-layout, form factor, formFactor, 폼 팩터, 반응형 그리드, breakpoint, 데스크톱 태블릿 모바일]
---

# LWC 반응형 레이아웃 패턴

> LWC를 데스크톱·태블릿·모바일에 대응시키는 3계층 — **SLDS 그리드**(CSS 브레이크포인트), **`lightning-layout`**(디바이스별 size 속성), **`@salesforce/client/formFactor`**(런타임 폼 팩터 감지 후 조건부 렌더).

> [!note] 이 노트는 **표준 Lightning Experience의 반응형 레이아웃**을 다룬다. Salesforce 모바일 앱의 디바이스 하드웨어 기능·오프라인은 [[모바일 & 오프라인 (LWC)]], Experience Cloud LWR 사이트의 반응형은 별도 주제다. 출처: SLDS 공식([lightningdesignsystem.com](https://www.lightningdesignsystem.com/utilities/grid/)) · 컴포넌트 라이브러리(`lightning-layout`) · `@salesforce/client/formFactor` 문서.

---

## 반응형 3계층 — 언제 무엇을 쓰나

| 계층 | 도구 | 반응 방식 | 언제 |
|---|---|---|---|
| CSS 그리드 | `slds-grid` + `slds-size_*` / `slds-{small\|medium\|large}-size_*` | **뷰포트 폭** 브레이크포인트 | 컬럼 수를 화면 폭에 따라 바꿀 때 (가장 흔함) |
| 컴포넌트 그리드 | `lightning-layout` + `lightning-layout-item` (`size`·`*-device-size`) | **디바이스 클래스**(SLDS와 동일 브레이크포인트) | 마크업만으로 정렬·간격까지 선언적으로 |
| 런타임 감지 | `@salesforce/client/formFactor` | **JS에서 Large/Medium/Small** 문자열 | 폼 팩터별로 **다른 컴포넌트/로직**을 렌더할 때 |

앞의 둘은 순수 레이아웃(같은 마크업이 접혀 배치됨), 세 번째는 **분기**(모바일에서 아예 다른 UI)에 쓴다.

---

## 1. SLDS 그리드 반응형

`slds-grid`는 flexbox 래퍼, `slds-col`은 flex 아이템이다. 폭은 `slds-size_<n>-of-<total>`로 분수 지정한다.

```html
<!-- 데스크톱: 3열 / 태블릿: 2열 / 모바일: 1열 (스택) -->
<template>
  <div class="slds-grid slds-wrap slds-gutters">
    <div class="slds-col slds-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3">
      카드 A
    </div>
    <div class="slds-col slds-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3">
      카드 B
    </div>
    <div class="slds-col slds-size_1-of-1 slds-medium-size_1-of-2 slds-large-size_1-of-3">
      카드 C
    </div>
  </div>
</template>
```

### 핵심 클래스

| 클래스 | 역할 |
|---|---|
| `slds-grid` | flex 컨테이너 시작 |
| `slds-col` | flex 아이템 (기본 균등 분할) |
| `slds-size_<n>-of-<total>` | **모든 폭**에서 적용되는 기본 분수 (예: `slds-size_1-of-2`) |
| `slds-small-size_<n>-of-<total>` | **≥ 30em(480px)** 부터 적용 |
| `slds-medium-size_<n>-of-<total>` | **≥ 48em(768px)** 부터 적용 (태블릿) |
| `slds-large-size_<n>-of-<total>` | **≥ 64em(1024px)** 부터 적용 (데스크톱) |
| `slds-wrap` | 컨테이너 폭을 넘으면 다음 줄로 **줄바꿈**(반응형 스택의 핵심) |
| `slds-gutters` | 컬럼 사이 좌우 여백(gutter) 추가. 변형: `slds-gutters_small`, `slds-gutters_large` |

> **모바일 우선(mobile-first):** 분모/분자 크기 접두사는 "그 폭 **이상**"에서 적용된다. 따라서 접두사 없는 `slds-size_*`를 모바일 기본값으로 두고, `slds-medium-*`·`slds-large-*`로 큰 화면을 덮어쓴다. `slds-wrap`이 없으면 줄바꿈이 안 되어 좁은 화면에서 컬럼이 찌그러진다.

브레이크포인트 기준(SLDS): `small` 30em · `medium` 48em · `large` 64em · `x-large` 75em.

---

## 2. lightning-layout / lightning-layout-item

CSS 클래스를 직접 쓰지 않고 **컴포넌트 속성**으로 같은 반응형 그리드를 표현한다. 정렬(`horizontal-align`/`vertical-align`)까지 마크업으로 선언할 수 있어 편하다.

```html
<template>
  <lightning-layout horizontal-align="spread"
                    vertical-align="center"
                    multiple-rows>
    <lightning-layout-item padding="around-small"
                           size="12"
                           medium-device-size="6"
                           large-device-size="4"
                           flexibility="auto">
      카드 A
    </lightning-layout-item>
    <lightning-layout-item padding="around-small"
                           size="12"
                           medium-device-size="6"
                           large-device-size="4"
                           flexibility="auto">
      카드 B
    </lightning-layout-item>
  </lightning-layout>
</template>
```

### `lightning-layout` 속성

| 속성 | 값 | 의미 |
|---|---|---|
| `horizontal-align` | `start` · `center` · `end` · `space` · `spread` | 아이템의 가로 분포. `space`=아이템 주위 균등 여백, `spread`=아이템 사이 균등 여백 |
| `vertical-align` | `start` · `center` · `end` · `stretch` | 아이템의 세로 정렬 |
| `pull-to-boundary` | `small` · `medium` · `large` | `padding`과 반대로 컨테이너 가장자리로 당겨 gutter 상쇄 |
| `multiple-rows` | (boolean) | 아이템이 한 줄을 넘으면 **다음 줄로 래핑**(SLDS의 `slds-wrap`에 해당) |

### `lightning-layout-item` 속성

| 속성 | 값 | 의미 |
|---|---|---|
| `size` | `1`~`12` | **모든 디바이스**에서의 12분할 폭 (기본 폭) |
| `small-device-size` | `1`~`12` | 스마트폰 가로/소형 이상에서의 폭 |
| `medium-device-size` | `1`~`12` | 태블릿 이상에서의 폭 |
| `large-device-size` | `1`~`12` | 데스크톱 이상에서의 폭 |
| `flexibility` | `auto` · `shrink` · `no-shrink` · `grow` · `no-grow` · `no-flex` (배열 가능) | 남는 공간에 대한 신축 동작 |
| `padding` | `horizontal-small` · `horizontal-medium` · `horizontal-large` · `around-small` · `around-medium` · `around-large` | 아이템 안쪽 패딩(gutter 역할) |
| `alignment-bump` | `left` · `top` · `right` · `bottom` | 해당 방향으로 자동 마진을 밀어 개별 아이템만 밀어내기 |

> `size`는 12-컬럼 정수(1~12)이고, SLDS의 `slds-size_*`는 `n-of-total` 분수라는 점만 다르다. `size="12"`(모바일 전체폭) → `medium-device-size="6"`(태블릿 반) → `large-device-size="4"`(데스크톱 1/3)가 위 SLDS 예제와 동일한 접힘을 만든다.

---

## 3. 폼 팩터 감지 (`@salesforce/client/formFactor`)

CSS로 접는 것으로 부족하고 **디바이스별로 다른 컴포넌트/데이터/로직**이 필요하면, JS에서 폼 팩터를 읽어 조건부 렌더한다.

```javascript
import { LightningElement } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class ResponsiveContainer extends LightningElement {
    formFactor = FORM_FACTOR;  // 'Large' | 'Medium' | 'Small' (import 시점 고정)

    get isDesktop() {
        return FORM_FACTOR === 'Large';
    }
    get isTablet() {
        return FORM_FACTOR === 'Medium';
    }
    get isPhone() {
        return FORM_FACTOR === 'Small';
    }
}
```

```html
<template>
    <template lwc:if={isPhone}>
        <c-compact-list></c-compact-list>   <!-- 모바일: 간소 리스트 -->
    </template>
    <template lwc:else>
        <c-full-datatable></c-full-datatable> <!-- 태블릿·데스크톱: 풀 테이블 -->
    </template>
</template>
```

### 반환 값

| 값 | 대응 폼 팩터 |
|---|---|
| `'Large'` | 데스크톱 (Lightning Experience full desktop) |
| `'Medium'` | 태블릿 |
| `'Small'` | 스마트폰 (Salesforce 모바일 앱 폰 폼 팩터) |

> **정적 값이다.** `FORM_FACTOR`는 **컴포넌트 로드 시점의 폼 팩터**를 반환하는 상수이며, 브라우저 창을 리사이즈해도 **바뀌지 않는다**(런타임 리스너 아님). 브라우저 폭 변화에 실시간 반응해야 하면 폼 팩터가 아니라 SLDS 브레이크포인트(CSS)나 `window` resize를 써야 한다. 폼 팩터는 "이 세션이 폰/태블릿/데스크톱인가"라는 **디바이스 분기**에 적합하다.

> 스코프드 모듈(`@salesforce/client/formFactor`)은 LWC가 컴파일 타임에 해석하므로 Jest 테스트에서는 `@salesforce/client/formFactor` 모의(mock)를 등록해야 한다.

---

## 4. 데스크톱 / 태블릿 / 모바일 대응 절차

```
1. 레이아웃을 12-컬럼(또는 n-of-total)으로 스케치 — 모바일 기본값부터.
2. 기본(접두사 없는) size = 모바일 전체폭(1-of-1 / size 12)으로 스택되게.
3. slds-medium-* / medium-device-size 로 태블릿 2열.
4. slds-large-* / large-device-size 로 데스크톱 3~4열.
5. 래핑 필수: slds-wrap(그리드) 또는 multiple-rows(lightning-layout).
6. 컬럼 접힘만으로 부족한 곳(내비/테이블 등)만 formFactor로 분기 렌더.
7. 실기기(또는 브라우저 반응형 모드)에서 3개 폭 모두 확인.
```

| 폼 팩터 | 목표 열 수 | SLDS | lightning-layout |
|---|---|---|---|
| 모바일(Small) | 1열 스택 | `slds-size_1-of-1` | `size="12"` |
| 태블릿(Medium) | 2열 | `slds-medium-size_1-of-2` | `medium-device-size="6"` |
| 데스크톱(Large) | 3~4열 | `slds-large-size_1-of-3` | `large-device-size="4"` |

---

## 관련 노트
- [[SLDS 유틸리티 클래스 레퍼런스]] — `slds-grid`·`slds-size_*`·`slds-p`/`slds-m` 등 유틸리티 클래스 전수
- [[모바일 & 오프라인 (LWC)]] — Salesforce 모바일 앱 디바이스 기능·오프라인(레이아웃이 아닌 하드웨어/네트워크 계층)
- [[LWC MOC]]
