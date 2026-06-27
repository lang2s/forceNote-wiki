---
tags: [slds, slds2, styling-hooks, css-custom-properties, reference]
source: SLDS2-Docs — lightningdesignsystem.com (SLDS 2 v2.30.4, Tier 2)
created: 2026-06-13
aliases: [SLDS Styling Hooks, 스타일링 훅, --slds-g, --slds-c, CSS Custom Properties]
---

# SLDS 스타일링 훅 (Styling Hooks)

> 출처: [SLDS 2 · Styling Hooks](https://www.lightningdesignsystem.com/2e1ef8501/p/319e5f-styling-hooks)
> SLDS 컴포넌트 스타일을 안전하게 커스터마이즈하는 CSS 변수 체계를 한국어로 정리했습니다.

## 스타일링 훅이란?

SLDS 스타일링 훅은 **SLDS 스타일시트를 직접 수정하지 않고** 컴포넌트의 특정 속성을 바꿀 수 있게 해주는 **CSS 변수**입니다. 색·폰트·간격·테두리 등을 커스터마이즈하고, 앱 전반에 일관된 테마를 적용할 수 있습니다.

## 왜 쓰는가

- **안전한 커스터마이즈** — SLDS 클래스를 깊은 셀렉터로 덮어쓰는 방식과 달리, 훅은 안정적이고 **업그레이드에 안전**합니다.
- **스코프 한정** — 훅의 범위(글로벌 또는 컴포넌트) 안에서만 영향을 줍니다.
- **테마링 지원** — 브랜드 준수 테마나 다크/라이트 테마를 쉽게 만듭니다.

```css
.myCustomClass {
  padding: var(--slds-g-sizing-1, 0.25rem);
}
```

> 🔑 글로벌 훅은 **참조만** 하세요(위 예시처럼 `var(...)`로 사용). 값을 **할당하지 마세요** — 값 할당은 테마·브랜딩 도구 전용입니다.
> 항상 **fallback 값**(`var(--훅, 폴백)`)을 함께 넣어 SLDS 1 복귀나 미지원 환경에서도 깨지지 않게 하세요.

---

## 스타일링 훅 종류

훅은 **글로벌(global)** 과 **컴포넌트 레벨(component-level)** 두 가지입니다. **현재 SLDS 2에서 코드로 참조 지원되는 것은 글로벌 훅뿐입니다.**

| 분류 | 하위 종류 | 지원 환경 | 예시 |
|---|---|---|---|
| **글로벌 훅** | 시맨틱 UI (색·간격·그림자 등) | **SLDS 2 전용** | `--slds-g-color-surface-container-3`, `--slds-g-spacing-4`, `--slds-g-radius-border-1` |
| | 접근성 시스템 색 | SLDS 1 · 2 공용 | `--slds-g-color-brand-base-50`, `--slds-g-color-error-base-60` |
| | 접근성 색 팔레트 | SLDS 1 · 2 공용 | `--slds-g-color-palette-blue-50`, `--slds-g-color-palette-green-60` |
| | Density-aware (밀도 대응) | SLDS 2 | `--slds-g-spacing-var-1`, `--slds-g-spacing-var-block-5` |
| | Duration (지속시간) | SLDS 2 | `--slds-g-duration-immediately`, `--slds-g-duration-paused` |
| **컴포넌트 레벨 훅** | — | **SLDS 1 전용** | `--slds-c-button-color-background`, `--slds-c-card-color-border`, `--slds-c-modal-color-shadow` |

**핵심 구분**
- `--slds-g-*` = 글로벌 훅 (전역 디자인 토큰). SLDS 2의 권장 방식.
- `--slds-c-*` = 컴포넌트 레벨 훅. **SLDS 1에서만** 지원되며, SLDS 2에서는 글로벌 훅으로 대체됩니다.
- **시맨틱 UI / density / duration** 계열은 **SLDS 2 전용**, **시스템 색·팔레트**는 SLDS 1·2 공용입니다.

> 참고: 앞서 만든 `SLDS-Utilities.md`와 컴포넌트 md의 CSS에서 보이는 `var(--slds-g-color-..., 폴백)` 패턴이 바로 이 글로벌 훅입니다. 또 버튼 등 일부 컴포넌트 CSS의 `var(--slds-c-button-..., ...)`는 컴포넌트 레벨 훅(SLDS 1 호환용 fallback)입니다.

---

## 도입 효과

- **유지보수 단순화** — 반복 값을 중앙에서 관리해 오류·중복 감소.
- **유연한 테마링** — Figma 변수로 만든 테마 값을 컴포넌트로 그대로 연결.
- **디자인→개발 핸드오프 효율화** — 디자인·개발이 공유하는 단일 진실 원천(single source of truth).
- 공통 언어, 거버넌스, 플랫폼 간 동기화, 기술·디자인 부채 감소, UI 일관성.

---

### 관련 문서
- 개발 모범 사례: `SLDS2-Best-Practices.md`
- 유틸리티 클래스(글로벌 훅이 적용된 실제 CSS·예제): `SLDS-Utilities.md`
- 전체 글로벌 훅 목록: SLDS 2 **Global Styling Hooks Reference** (공식 사이트)

---

## 관련 노트

- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[SLDS LWC 디자인 시스템]] — SLDS 2 개념·스타일링 훅·LWC 적용
- [[SLDS 유틸리티 클래스 레퍼런스]] — 유틸리티 클래스 전수
- [[LWR --dxp 스타일링 훅 레퍼런스]] — LWR 사이트는 `--slds-*` 대신 `--dxp-*` 훅으로 브랜딩(`--slds-c`/`--slds-g-color`로 미세조정·Remove SLDS)
- [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]] — 다크 모드/테마를 `body` 클래스로 토글하는 스타터킷 구현
- [[LWC MOC]]
