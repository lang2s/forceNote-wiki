---
tags: [lwc, base-component, visual, slds, reference]
source: Salesforce Lightning Component Reference (cx-router 메타데이터, Tier 2) + lightningdesignsystem.com (SLDS 2)
created: 2026-06-13
aliases: [lightning-pill-container, Pill Container]
---

# lightning-pill-container

> 여러 pill을 묶어서 표시. · 카테고리: Visual

> [!note] 속성·메서드·이벤트·슬롯 명세는 Salesforce 공식 cx-router 메타데이터(Tier 2)에서 추출했습니다. 속성 설명은 가독성을 위해 약 140자에서 줄였습니다 — 전체 문장은 공식 Specification 링크 참조.

---

## 기본 예제 (Example)

```html
<lightning-pill-container items={items} onitemremove={handleRemove}></lightning-pill-container>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-pill-container` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 42.0

### 속성 (Attributes) — 6개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `is-collapsible` | boolean |  | false | Specifies whether the pill list can be collapsed. Use is-collapsible with the is-expanded attribute to expand and collapse the list of pil… |
| `is-expanded` | boolean |  | false | Specifies whether the list of pills is expanded or collapsed, when is-collapsible is true. This attribute is ignored when is-collapsible i… |
| `items` | list |  |  | An array of pill attribute values that define pills to display in the container. |
| `label` | string |  |  | Aria label for the pill container to describe the list of options. |
| `single-line` | boolean |  |  | Specifies whether to limit pill display to one line. This attribute overrides the is-collapsible and is-expanded attributes. |
| `variant` | string |  | standard | The variant changes the tab navigation behavior of the pill container. Accepted variants include standard and bare. This value defaults to… |

### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `focus` | Sets focus on the pill list. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-pill-container/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-pill-container/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-pill-container/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-pill-container.html

## 관련 노트

- [[BaseComponents(베이스컴포넌트)/index|BaseComponents 색인]]
- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 카테고리 목록
- [[LWC MOC]]
