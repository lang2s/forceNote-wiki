---
tags: [lwc, base-component, navigation, slds, reference]
source: Salesforce Lightning Component Reference (cx-router 메타데이터, Tier 2) + lightningdesignsystem.com (SLDS 2)
created: 2026-06-13
aliases: [lightning-vertical-navigation-item-badge, Vertical Navigation Item Badge]
---

# lightning-vertical-navigation-item-badge

> 배지(숫자)가 붙는 세로 내비 항목. · 카테고리: Navigation

> [!note] 속성·메서드·이벤트·슬롯 명세는 Salesforce 공식 cx-router 메타데이터(Tier 2)에서 추출했습니다. 속성 설명은 가독성을 위해 약 140자에서 줄였습니다 — 전체 문장은 공식 Specification 링크 참조.

---

## 기본 예제 (Example)

```html
<lightning-vertical-navigation-item-badge label="알림" name="alerts" badge-count="3"></lightning-vertical-navigation-item-badge>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-vertical-navigation-item-badge` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 5개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `assistive-text` | string |  |  | Assistive text describing the number in the badge, which enhances accessibility and is not displayed to the user. The default is "New Item… |
| `badge-count` | number |  | 0 | The number to show inside the badge. If this value is zero, the badge is hidden. The default value is zero. |
| `href` | string |  |  | The URL of the page that the navigation item goes to. |
| `label` | string | ✔ |  | The text displayed for this navigation item. |
| `name` | string | ✔ |  | A unique identifier for this navigation item. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-vertical-navigation-item-badge/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-vertical-navigation-item-badge/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-vertical-navigation-item-badge/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-vertical-navigation-item-badge.html

## 관련 노트

- [[BaseComponents(베이스컴포넌트)/index|BaseComponents 색인]]
- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 카테고리 목록
- [[LWC MOC]]
