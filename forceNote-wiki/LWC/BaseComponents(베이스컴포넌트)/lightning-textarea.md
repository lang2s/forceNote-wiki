---
tags: [lwc, base-component, input, slds, reference]
source: Salesforce Lightning Component Reference (cx-router 메타데이터, Tier 2) + lightningdesignsystem.com (SLDS 2)
created: 2026-06-13
aliases: [lightning-textarea, Text Area]
---

# lightning-textarea

> 여러 줄 텍스트 입력. · 카테고리: Input

> [!note] 속성·메서드·이벤트·슬롯 명세는 Salesforce 공식 cx-router 메타데이터(Tier 2)에서 추출했습니다. 속성 설명은 가독성을 위해 약 140자에서 줄였습니다 — 전체 문장은 공식 Specification 링크 참조.

---

## 기본 예제 (Example)

```html
<lightning-textarea label="메모" value={value} onchange={handleChange}></lightning-textarea>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-textarea` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 20개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `access-key` | string |  |  | The keyboard shortcut for input field. |
| `aria-described-by` | string |  |  | Aria Described by value on parent lighting-textarea |
| `aria-labelled-by` | string |  |  | A space-separated list of element IDs that provide labels for the aria-labelled-by value on parent lighting-textarea. |
| `autocomplete` | string |  |  | Controls auto-filling of the field. Set the attribute to pass through autocomplete values to be interpreted by the browser. |
| `disabled` | boolean |  | false | If present, the textarea field is disabled and users cannot interact with it. |
| `field-level-help` |  |  |  | The help text that appears in a popover. Set field-level help to provide an informational tooltip on the textarea input field. |
| `label` | string | ✔ |  | Text that describes the textarea input field. |
| `max-length` | number |  |  | The maximum number of characters allowed in the textarea. |
| `message-when-bad-input` | string |  |  | Error message to be displayed when a bad input is detected. |
| `message-when-too-long` | string |  |  | Error message to be displayed when the value is too long. |
| `message-when-too-short` | string |  |  | Error message to be displayed when the value is too short. |
| `message-when-value-missing` | string |  |  | Error message to be displayed when the value is missing. |
| `min-length` | number |  |  | The minimum number of characters allowed in the textarea. |
| `name` | string |  |  | Specifies the name of an input element. |
| `placeholder` | string |  |  | Text that is displayed when the field is empty, to prompt the user for a valid entry. |
| `read-only` | boolean |  | false | If present, the textarea field is read-only and cannot be edited. |
| `required` | boolean |  |  | If present, the textarea field must be filled out before the form can be submitted. |
| `validity` | object |  |  | Represents the validity states of the textarea input, with respect to constraint validation. |
| `value` | string |  |  | The value of the textarea input, also used as the default value during init. |
| `variant` | string |  | standard | The variant changes the appearance of the textarea. Accepted variants include standard, label-hidden, label-inline, and label-stacked. Thi… |

### 메서드 (Methods) — 7개

| 메서드 | 설명 |
|---|---|
| `blur` | Removes focus from the textarea field. |
| `check-validity` | Returns the valid attribute value (Boolean) on the ValidityState object. |
| `focus` | Sets focus on the textarea field. |
| `report-validity` | Displays the error messages and returns false if the input is invalid. If the input is valid, reportValidity() clears displayed error mess… |
| `set-custom-validity` | Sets a custom error message to be displayed when the textarea value is submitted. |
| `set-range-text` | Replace a range of text in textarea with a new string. |
| `show-help-message-if-invalid` | Displays error messages on invalid fields. An invalid field fails at least one constraint validation and returns false when checkValidity(… |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-textarea/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-textarea/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-textarea/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-textarea.html

## 관련 노트

- [[BaseComponents(베이스컴포넌트)/index|BaseComponents 색인]]
- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 카테고리 목록
- [[LWC MOC]]
