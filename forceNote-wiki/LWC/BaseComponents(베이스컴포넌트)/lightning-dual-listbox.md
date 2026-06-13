---
tags: [lwc, base-component, input, slds, reference]
source: Salesforce Lightning Component Reference (cx-router 메타데이터, Tier 2) + lightningdesignsystem.com (SLDS 2)
created: 2026-06-13
aliases: [lightning-dual-listbox, Dual Listbox]
---

# lightning-dual-listbox

> 좌→우로 항목을 옮겨 선택하는 이중 리스트. · 카테고리: Input

> [!note] 속성·메서드·이벤트·슬롯 명세는 Salesforce 공식 cx-router 메타데이터(Tier 2)에서 추출했습니다. 속성 설명은 가독성을 위해 약 140자에서 줄였습니다 — 전체 문장은 공식 Specification 링크 참조.

---

## 기본 예제 (Example)

```html
<lightning-dual-listbox label="권한" source-label="가능" selected-label="선택됨" options={options} value={value} onchange={handleChange}></lightning-dual-listbox>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-dual-listbox` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 24개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `add-button-label` | string |  | Move | Label for add button. |
| `disabled` | string |  |  | If present, the listbox is disabled and users cannot interact with it. |
| `disable-reordering` | boolean |  | false | If present, the Up and Down buttons used for reordering the selected list items are hidden. |
| `down-button-label` | string |  | Move selection down | Label for down button. |
| `field-level-help` | string |  |  | Help text detailing the purpose and function of the dual listbox. |
| `label` | string | ✔ |  | Label for the dual listbox. |
| `max` | number |  |  | Maximum number of options allowed in the selected options listbox. |
| `message-when-range-overflow` | string |  |  | Error message to be displayed when a range overflow is detected. |
| `message-when-range-underflow` | string |  |  | Error message to be displayed when a range underflow is detected. |
| `message-when-value-missing` | string |  |  | Error message to be displayed when the value is missing and input is required. |
| `min` | number |  |  | Minimum number of options required in the selected options listbox. |
| `name` | string |  |  | Specifies the name of an input element. |
| `options` | object[] | ✔ |  | A list of options that are available for selection. Each option has the following attributes: label and value. |
| `remove-button-label` | string |  | Move selection to {sourceLabel} | Label for remove button. |
| `required` | string |  | false | If present, the user must add an item to the selected listbox before submitting the form. |
| `required-options` | list |  |  | A list of required options that cannot be removed from selected options listbox. This list is populated with values from the options attri… |
| `selected-label` | string | ✔ |  | Label for the selected options listbox. |
| `show-activity-indicator` | boolean |  | false | If present, a spinner is displayed in the first listbox to indicate loading activity. |
| `size` | number |  |  | Number of items that display in the listboxes before vertical scrollbars are displayed. Determines the vertical size of the listbox. |
| `source-label` | string | ✔ |  | Label for the source options listbox. |
| `up-button-label` | string |  | Move selection up | Label for up button. |
| `validity` | object |  |  | Represents the validity states that an element can be in, with respect to constraint validation. |
| `value` | list |  |  | A list of default options that are included in the selected options listbox. This list is populated with values from the options attribute. |
| `variant` | string |  |  | The variant changes the appearance of the dual listbox. Accepted variants include standard, label-hidden, label-inline, and label-stacked.… |

### 메서드 (Methods) — 5개

| 메서드 | 설명 |
|---|---|
| `check-validity` | Returns the valid attribute value (Boolean) on the ValidityState object. |
| `focus` | Sets focus on the first option from either list. If the source list doesn't contain any options, the first option on the selected list is … |
| `report-validity` | Displays the error messages and returns false if the input is invalid. If the input is valid, reportValidity() clears displayed error mess… |
| `set-custom-validity` | Sets a custom error message to be displayed when the dual listbox value is submitted. |
| `show-help-message-if-invalid` | Displays an error message if the dual listbox value is required. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-dual-listbox/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-dual-listbox/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-dual-listbox/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-dual-listbox.html

## 관련 노트

- [[BaseComponents(베이스컴포넌트)/index|BaseComponents 색인]]
- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 카테고리 목록
- [[LWC MOC]]
