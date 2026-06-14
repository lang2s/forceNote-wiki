---
tags: [lwc, base-components, button, button-stateful, action-menu, reference]
source: SLDS2-Docs/components/lightning-button-stateful.md (Tier 2)
created: 2026-06-14
aliases: [lightning-button-stateful, button-stateful, 상태 버튼, 토글 버튼, 팔로우 버튼]
---

# lightning-button-stateful

> 선택/비선택 상태에 따라 라벨·아이콘이 바뀌는 버튼 (예: 팔로우 / 팔로잉). 카테고리: **Action & Menu**.

---

## 기본 예제

```html
<!-- 구조 예시 — SLDS2-Docs 소스 기본 예제 -->
<lightning-button-stateful
    label-when-off="팔로우"
    label-when-on="팔로잉"
    selected={following}
    onclick={toggle}
></lightning-button-stateful>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 공식 **Example** 탭에서 직접 확인/편집할 수 있습니다.

`lightning-button-stateful`은 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다. `selected` 값에 따라 `label-when-off` / `label-when-on`이, 마우스 오버 시 `label-when-hover`가 표시됩니다.

---

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다.

> [!note] 속성 설명은 소스(SLDS2-Docs)에서 **약 140자에서 잘려** 있습니다(`…`로 표기). 전체 문장은 아래 Specification 링크를 참고하세요.

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 10개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `disabled` |  |  |  | Passthrough to pass disabled attribute onto button |
| `group-order` | string |  |  | Reserved for internal use only. Describes the order of this element (first, middle or last) inside lightning-button-group. |
| `icon-name-when-hover` | string |  |  | The name of the icon to be used in the format 'utility:close' when the state is true and the button receives focus. |
| `icon-name-when-off` | string |  |  | The name of the icon to be used in the format 'utility:add' when the state is false. |
| `icon-name-when-on` | string |  |  | The name of the icon to be used in the format 'utility:check' when the state is true. |
| `label-when-hover` | string |  |  | The text to be displayed inside the button when state is true and the button receives focus. |
| `label-when-off` | string | ✔ |  | The text to be displayed inside the button when state is false. |
| `label-when-on` | string | ✔ |  | The text to be displayed inside the button when state is true. |
| `selected` | boolean |  | false | If present, the button is in the selected state. |
| `variant` | string |  | neutral | The variant changes the appearance of the button. Accepted variants include brand, destructive, inverse, neutral, success, and text. |

### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `focus` | Sets focus on the button. |

---

## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button-stateful/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button-stateful/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button-stateful/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-button-stateful.html

---

## 관련 노트

- [[lightning-button]] — 상태 토글이 없는 표준 버튼
- [[lightning-button-icon-stateful]] — 텍스트 없이 아이콘만으로 상태를 토글하는 버튼
