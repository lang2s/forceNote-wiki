---
tags: [slds, css, icons, sprite, svg, reference]
source: https://www.lightningdesignsystem.com/icons/ (SLDS 공식 "Icons", Tier 2)
created: 2026-07-08
aliases: [SLDS Icons, SLDS 아이콘, slds-icon, 아이콘 스프라이트, SVG icon sprite, utility standard action doctype custom, slds-icon_container, slds-assistive-text, xlink:href]
---

> SLDS 아이콘 시스템 CSS 레벨 레퍼런스 — 5개 스프라이트 셋(utility·standard·action·doctype·custom), `slds-icon`·컨테이너·사이즈·색 클래스, SVG `<use xlink:href>` 스프라이트 마크업, 접근성 텍스트. lightning-icon 등 베이스 컴포넌트로 감싸는 것이 실무 권장.

# SLDS 아이콘 시스템 레퍼런스 (CSS 레벨)

> **범위:** 이 노트는 SLDS의 **CSS/SVG 스프라이트 원시 마크업** 레벨을 다룬다. LWC에서는 이 마크업을 직접 쓰기보다 [[lightning-icon]]·[[lightning-button-icon]] 같은 **베이스 컴포넌트**로 감싸 쓰는 것이 공식 권장이다(스프라이트 경로·접근성·정적 리소스 처리를 컴포넌트가 대신 해준다). 순수 Aura/Visualforce/외부 SLDS 사이트나 컴포넌트가 커버 못 하는 커스텀 마크업에서 이 레벨 지식이 필요하다.

---

## 1. 아이콘 카테고리 (스프라이트 셋)

SLDS 아이콘은 5개의 SVG **스프라이트 시트**로 배포된다. 각 셋은 정적 리소스(또는 `/assets/icons/{set}-sprite/svg/symbols.svg`)에 들어 있고 용도·색상 규칙이 다르다.

| 스프라이트 셋 | 용도 | 색/배경 규칙 | 예시 심볼 |
|---|---|---|---|
| **utility** | UI 인터랙션·상태 표시용 단색(monochrome) 글리프. 버튼·인풋·인라인 힌트 | **배경 없음.** 색은 `fill`(SVG `fill` / `slds-icon-text-*` 또는 `slds-current-color`)로 지정. 기본 회색 계열 | `down`, `close`, `search`, `check`, `warning`, `settings` |
| **standard** | 표준/커스텀 **오브젝트**(레코드) 아이콘. 리스트뷰·레코드 헤더·룩업 | **색 배경(square, rounded)** + 흰색 글리프. 각 오브젝트 고유 브랜드 컬러가 스프라이트에 내장 → **색 클래스로 덮어쓰지 않는다** | `account`, `contact`, `opportunity`, `case`, `lead` |
| **action** | 액션(퀵 액션·버튼) 아이콘. Global Action, 레코드 액션 | **색 배경(원형 느낌의 rounded square)** + 흰색 글리프. 액션별 배경색 내장 | `new_task`, `log_a_call`, `email`, `edit`, `share_post` |
| **doctype** | 파일 형식(문서 타입) 아이콘. Files·첨부 | 형식별 브랜드 컬러가 내장된 **멀티컬러** 글리프(배경 없음, 글리프 자체가 컬러) | `pdf`, `excel`, `word`, `image`, `zip` |
| **custom** | 커스텀 오브젝트/앱용 범용 색 배경 아이콘(custom1~custom110 등 번호 심볼) | **색 배경** + 흰색 글리프. standard에 대응 아이콘이 없는 커스텀 오브젝트에 배정 | `custom1`, `custom5`, `custom53` |

**핵심 규칙**
- **utility**만 단색이라 색을 CSS로 자유롭게 바꾼다(`fill`/색 클래스/`slds-current-color`).
- **standard·action·custom**은 **색 배경이 스프라이트에 이미 칠해져 있다** → 색 클래스로 덮지 않는다. 컨테이너(`slds-icon_container_*`)로 감싸 배경을 그대로 노출한다.
- **doctype**은 글리프 자체가 멀티컬러 → 색 변경 금지.

---

## 2. SVG 스프라이트 참조 마크업 (`<use xlink:href>`)

아이콘 1개는 SVG `<use>`가 스프라이트 시트의 `symbols.svg#심볼id`를 참조하는 형태다.

```html
<!-- utility 아이콘: 컨테이너 없이 단색 -->
<svg class="slds-icon slds-icon-text-default slds-icon_x-small" aria-hidden="true">
  <use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#settings"></use>
</svg>
<span class="slds-assistive-text">설정</span>
```

- 스프라이트 경로 형식: `/assets/icons/{set}-sprite/svg/symbols.svg#{symbolName}`
  - `{set}` = `utility` / `standard` / `action` / `doctype` / `custom`
  - `xlink:href`는 구형이나 SLDS 예제는 여전히 이 속성을 쓴다(`href`도 모던 브라우저에서 동작).
- Salesforce org 내부에서는 정적 리소스 `SLDS` 또는 `$Asset`/`lightning:icon`이 경로를 대신 제공하므로 절대경로 하드코딩을 피한다.
- 장식용 아이콘엔 `aria-hidden="true"`를 달고, 의미가 있으면 인접에 `slds-assistive-text`(아래 6절).

---

## 3. 기본 클래스 — `slds-icon` 와 컨테이너

```html
<!-- standard 오브젝트 아이콘: 색 배경 컨테이너로 감쌈 -->
<span class="slds-icon_container slds-icon_container_circle slds-icon-standard-account" title="Account">
  <svg class="slds-icon" aria-hidden="true">
    <use xlink:href="/assets/icons/standard-sprite/svg/symbols.svg#account"></use>
  </svg>
  <span class="slds-assistive-text">Account</span>
</span>
```

| 클래스 | 역할 |
|---|---|
| `slds-icon` | SVG에 붙이는 기본 아이콘 클래스(기본 사이즈·수직 정렬) |
| `slds-icon_container` | 색 배경 아이콘을 감싸는 컨테이너(둥근 사각 배경). standard/action/custom에 사용 |
| `slds-icon_container_circle` | 컨테이너를 **원형** 배경으로. action 아이콘에서 흔함 |
| `slds-icon-standard-{obj}` / `slds-icon-action-{name}` / `slds-icon-custom-{n}` / `slds-icon-doctype-{type}` | 컨테이너에 **해당 셋의 브랜드 배경색**을 입히는 색 클래스(예: `slds-icon-standard-account`) |

> `slds-icon-standard-account` 같은 클래스는 스프라이트에 내장된 색과 별개로, 컨테이너 배경색을 SLDS 토큰으로 칠한다. 그래서 utility엔 쓰지 않고 색 배경 셋에만 쓴다.

---

## 4. 사이즈 클래스

`slds-icon_{size}`를 SVG(`slds-icon`)에 함께 붙여 크기를 조절한다.

| 클래스 | 크기(약) | 비고 |
|---|---|---|
| `slds-icon_xx-small` | 0.875rem (14px) | 인라인 텍스트 힌트 |
| `slds-icon_x-small` | 1rem (16px) | 버튼 내부 |
| `slds-icon_small` | 1.5rem (24px) | 기본 인터페이스 |
| `slds-icon_medium` | 2rem (32px) | 컨테이너 기본(미지정 시) |
| `slds-icon_large` | 3rem (48px) | 헤더·강조 |

```html
<svg class="slds-icon slds-icon_x-small slds-icon-text-default" aria-hidden="true">
  <use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#down"></use>
</svg>
```

> 컨테이너를 쓸 땐 컨테이너가 크기의 프레임을, `slds-icon_{size}`가 내부 글리프 크기를 정한다. 미지정 시 medium 계열이 기본.

---

## 5. 색 클래스 (utility 전용) 와 `slds-current-color`

utility 아이콘의 `fill` 색을 SLDS 토큰으로 지정한다. **standard/action/custom/doctype에는 쓰지 않는다**(색 배경/멀티컬러가 내장).

| 클래스 | 색 의미 |
|---|---|
| `slds-icon-text-default` | 기본 회색(중립 텍스트색) |
| `slds-icon-text-weak` | 더 옅은 회색(보조·비활성 힌트) |
| `slds-icon-text-error` | 에러(빨강) |
| `slds-icon-text-success` | 성공(초록) |
| `slds-icon-text-warning` | 경고(노랑/주황) |
| `slds-icon-text-light` | 밝은 색(어두운 배경 위) |

**`slds-current-color`** — 아이콘 `fill`을 부모의 `currentColor`(즉 텍스트 `color`)로 상속시킨다. 링크·버튼처럼 **텍스트 색과 아이콘 색을 함께 움직이고 싶을 때** 사용한다.

```html
<!-- 부모의 color를 그대로 따라가는 아이콘 (호버 시 텍스트와 같이 색 변함) -->
<a href="#" class="slds-text-link">
  <svg class="slds-icon slds-icon_x-small slds-current-color" aria-hidden="true">
    <use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#link"></use>
  </svg>
  <span>연결</span>
</a>

<!-- 상태색 예: 에러 -->
<svg class="slds-icon slds-icon_x-small slds-icon-text-error" aria-hidden="true">
  <use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#error"></use>
</svg>
```

---

## 6. 접근성 텍스트 — `slds-assistive-text`

SVG 아이콘은 스크린리더가 읽지 못하므로, 의미 있는 아이콘엔 **시각적으로 숨긴 텍스트**를 붙인다.

```html
<button class="slds-button slds-button_icon" title="Close">
  <svg class="slds-button__icon" aria-hidden="true">
    <use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#close"></use>
  </svg>
  <span class="slds-assistive-text">Close</span>
</button>
```

- `slds-assistive-text`: 화면엔 안 보이되 스크린리더는 읽는 클래스(off-screen).
- 장식용(중복 의미 없음) 아이콘엔 SVG에 `aria-hidden="true"`만 달고 assistive-text는 생략.
- 아이콘이 유일한 콘텐츠인 버튼은 `title` 속성 + `slds-assistive-text` 둘 다 권장(툴팁 + 스크린리더).

---

## 7. lightning-icon / lightning-button-icon 와의 관계

LWC에서는 위 원시 마크업 대신 베이스 컴포넌트를 쓰는 것이 **공식 권장**이다. 컴포넌트가 스프라이트 경로·사이즈·색·접근성 처리를 내부에서 표준대로 해준다.

```html
<!-- 위의 utility 마크업 전체를 이 한 줄이 대체 -->
<lightning-icon icon-name="utility:settings" size="small" alternative-text="설정"></lightning-icon>

<!-- 아이콘 전용 버튼 -->
<lightning-button-icon icon-name="utility:close" alternative-text="Close" variant="bare"></lightning-button-icon>
```

- `icon-name="{set}:{symbol}"` 형식이 스프라이트 셋+심볼id에 그대로 대응(`utility:settings` = utility-sprite `#settings`).
- `size`는 `slds-icon_{size}`에, `variant`는 색 클래스에 대응.
- **직접 SVG 마크업이 필요한 경우:** 컴포넌트가 커버 못 하는 커스텀 배치, 순수 SLDS 정적 사이트, Visualforce/Aura 마크업 세밀 제어. 그 외 LWC에서는 컴포넌트 사용.

---

## 관련 노트
- [[lightning-icon]]
- [[lightning-button-icon]]
- [[SLDS 유틸리티 클래스 레퍼런스]]
- [[SLDS 스타일링 훅]]
- [[SLDS 접근성]]
- [[LWC MOC]]
