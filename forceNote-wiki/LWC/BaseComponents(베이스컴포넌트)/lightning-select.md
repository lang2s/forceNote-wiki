---
tags: [lwc, base-component, input, slds, reference]
source: Salesforce Lightning Component Reference (cx-router 메타데이터, Tier 2) + lightningdesignsystem.com (SLDS 2)
created: 2026-06-13
aliases: [lightning-select, Select]
---

# lightning-select

> 네이티브 HTML select 기반 드롭다운. · 카테고리: Input

> [!note] 속성·메서드·이벤트·슬롯 명세는 Salesforce 공식 cx-router 메타데이터(Tier 2)에서 추출했습니다. 속성 설명은 가독성을 위해 약 140자에서 줄였습니다 — 전체 문장은 공식 Specification 링크 참조.

---

## 기본 예제 (Example)

```html
<lightning-select label="등급" value={value} onchange={handleChange}>
  <option value="a">A</option>
</lightning-select>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-select` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 59.0

### 속성 (Attributes) — 16개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `access-key` | string |  |  | A shortcut key that activates and focuses on the menu. |
| `aria-described-by` | string |  |  | Aria Described by value on parent lighting-select |
| `aria-labelled-by` | string |  |  | A space-separated list of element IDs that provide labels for the aria-labelled-by value on parent lighting-select. |
| `autocomplete` | string |  |  | Reserved for internal use. Controls auto-filling of the field. |
| `disabled` | boolean |  | false | Specifies whether the menu is disabled and users cannot interact with it. |
| `field-level-help` | string |  |  | Help text detailing the purpose and function of the menu of options. The text is displayed in a tooltip above the menu. |
| `label` | string |  |  | The text label for the component. To hide the label but make it available to assistive technologies, use the label-hidden variant. |
| `message-when-value-missing` | string |  |  | The error message that's displayed below the menu when a user interacts with the menu but does not select an option. |
| `multiple` | boolean |  | false | Specifies whether multiple options can be selected. |
| `name` | string |  |  | The identifier for the component. |
| `options` | Option[] |  |  | An array of menu options with key-value pairs for label and value. |
| `required` | boolean |  | false | Specifies whether an option must be selected. |
| `size` | number \| string \| null |  | 4 | The number of rows in the list that should be visible at one time. Use this attribute with the multiple attribute. |
| `validity` | ValidityState |  |  | Represents the validity states that an element can be in, with respect to constraint validation. |
| `value` | string \| string[] |  |  | The value of the selected option. If empty and a value is required, the component is in an invalid state. |
| `variant` | string |  |  | The variant changes the appearance of the dropdown menu. Accepted variants include standard, label-inline, label-hidden, and label-stacked… |

### 메서드 (Methods) — 6개

| 메서드 | 설명 |
|---|---|
| `blur` | Removes focus on from the select element. |
| `check-validity` | Checks if the input is valid. |
| `focus` | Sets focus on the select element. |
| `report-validity` | Displays the error messages and returns false if the input is invalid. If the input is valid, reportValidity() clears displayed error mess… |
| `set-custom-validity` | Sets a custom error message to be displayed when a form is submitted. |
| `show-help-message-if-invalid` | Displays an error message on an invalid select field. An invalid field fails at least one constraint validation and returns false when che… |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-select/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-select/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-select/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-select.html

## 관련 노트

- [[BaseComponents(베이스컴포넌트)/index|BaseComponents 색인]]
- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 카테고리 목록
- [[LWC MOC]]
