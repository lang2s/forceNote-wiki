# Combobox

`lightning-combobox`  ·  카테고리: **Input**

드롭다운에서 하나를 선택하는 입력.

## 기본 예제 (Example)

```html
<lightning-combobox label="국가" options={options} value={value} onchange={handleChange}></lightning-combobox>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-combobox` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 19개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `aria-described-by` | string |  |  | Reserved for internal use. Use the standard aria-describedby instead. A space-separated list of element IDs that provide descriptive label… |
| `aria-invalid` | boolean |  |  | A Boolean value for aria-invalid. |
| `aria-labelled-by` | string |  |  | Reserved for internal use. Use the standard aria-labelledby instead. A space-separated list of element IDs that provide labels for the com… |
| `autocomplete` | string |  |  | Reserved for internal use. Controls auto-filling of the field. |
| `disabled` | boolean |  | false | If present, the combobox is disabled and users cannot interact with it. |
| `dropdown-alignment` | string |  | left | Specifies where the drop-down list is aligned with or anchored to the selection field. By default the list is aligned with the selection f… |
| `field-level-help` | string |  |  | Help text detailing the purpose and function of the combobox. |
| `icon-name` | string |  |  | The name of the icon displayed in the combobox button. Applies only when variant is 'button'. |
| `label` |  |  |  | Text label for the combobox. |
| `message-when-value-missing` | string |  |  | Error message to be displayed when the value is missing and input is required. |
| `name` | string |  |  | Specifies the name of the combobox. |
| `options` | object[] | ✔ |  | A list of options that are available for selection. Each option has the following attributes: label and value. |
| `placeholder` | string |  | Select | Text that is displayed before an option is selected, to prompt the user to select an option. The default is "Select an Option". |
| `read-only` | boolean |  | false | If present, the combobox is read-only. A read-only combobox is also disabled. |
| `required` | boolean |  | false | If present, a value must be selected before the form can be submitted. |
| `spinner-active` | boolean |  | false | If present, a spinner is displayed below the menu items to indicate loading activity. |
| `validity` | object |  |  | Represents the validity states that an element can be in, with respect to constraint validation. |
| `value` | string |  |  | Specifies the value of an input element. |
| `variant` | string |  | standard | The variant changes the appearance of the combobox. Accepted variants include standard, label-hidden, label-inline, label-stacked, and but… |

### 메서드 (Methods) — 6개

| 메서드 | 설명 |
|---|---|
| `blur` | Removes focus from the combobox. |
| `check-validity` | Returns the valid attribute value (Boolean) on the ValidityState object. |
| `focus` | Sets focus on the combobox. |
| `report-validity` | Displays the error messages and returns false if the input is invalid. If the input is valid, reportValidity() clears displayed error mess… |
| `set-custom-validity` | Sets a custom error message to be displayed when the combobox value is submitted. |
| `show-help-message-if-invalid` | Shows the help message if the combobox is in an invalid state. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-combobox/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-combobox/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-combobox/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-combobox.html

---
[← 전체 목록으로 돌아가기](../components.html)
