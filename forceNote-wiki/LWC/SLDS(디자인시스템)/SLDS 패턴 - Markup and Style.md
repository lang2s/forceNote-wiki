---
tags: [slds, slds2, design-pattern, ux, reference]
source: SLDS2-Docs — lightningdesignsystem.com SLDS 2 디자인 패턴 (Tier 2)
created: 2026-06-13
aliases: [Markup and Style, SLDS Markup and Style 패턴, markup-and-style]
---

# Markup and Style

> 카테고리: SLDS 2 디자인 패턴 · [공식](https://www.lightningdesignsystem.com/2e1ef8501/p/88f917-markup-and-style)

일관성·가독성·접근성을 위한 **CSS 네이밍 규칙**(BEM 기반 + SLDS 변형). 낮은 specificity로 `!important` 전쟁을 피함.

## BEM 기본
- **Block** — 컴포넌트 이름. 예: `.house` (모든 house 공통 속성).
- **Element** — 구성 요소, `__`(언더스코어 2개)로 구분. 예: `.house__door`. (`.house__stair__step`처럼 2단계 중첩 금지 → `.house__stair-step` 또는 `.stair`를 별도 블록으로)
- **Modifier** — 변형, `_`(언더스코어 1개)로 구분. 예: `.house_gray`, 요소 변형 `.house__door_pink`. (기본 클래스에 추가로 부여)

## SLDS의 BEM 변형
- **유틸리티 클래스** — 베이스 블록 없이 사용: `.slds-m-top_medium`(margin-top-medium), `.slds-size_1-of-2`, `.slds-text-heading_large` 등 (`.slds-m`, `.slds-text-heading` 같은 베이스 없음).
- **컴포넌트 컨테이너** — 컴포넌트 전용 선택적 컨테이너는 `_`로: 예 `.slds-pill_container`.
- **네임스페이스** — 모든 클래스에 `.slds-` 접두사(예: `.button` → `.slds-button`). 다른 프레임워크와 충돌 방지.
- **스코핑** — SLDS CSS가 없는 환경(my.app, Lightning Out)에선 커스텀 스코프 클래스를 DOM 최상위에. (단, 비-SLDS 컴포넌트가 섞인 곳의 body에는 두지 말 것 — 의도치 않은 스타일 적용)
- **컴포넌트 상태** — 상태 클래스: `.slds-is-selected`, `.slds-is-active`, `.slds-is-expanded`, `.slds-is-nested`, `.slds-is-open`, `.slds-has-focus`, `.slds-has-error` 등.

> 참고: 이 네이밍 규칙은 `SLDS-Utilities.md`의 클래스 표기(`_`/`--`)와 직접 연결됩니다.

---

## 관련 노트

- [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]
- [[SLDS LWC 디자인 시스템]] — SLDS 2 개념·스타일링 훅·LWC 적용
- [[LWC MOC]]
