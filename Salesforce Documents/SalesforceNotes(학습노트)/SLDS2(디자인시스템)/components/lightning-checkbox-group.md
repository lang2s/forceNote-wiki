# Checkbox Group

`lightning-checkbox-group`  ·  카테고리: **Input**

여러 개를 선택할 수 있는 체크박스 묶음.

## 기본 예제 (Example)

```html
<lightning-checkbox-group label="관심사" options={options} value={selected} onchange={handleChange}></lightning-checkbox-group>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-checkbox-group` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 9개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `disabled` | boolean |  | false | If present, the checkbox group is disabled. Checkbox selections can't be changed for a disabled checkbox group. |
| `label` | string | ✔ |  | Text label for the checkbox group. |
| `message-when-value-missing` | string |  |  | Optional message to be displayed when no checkbox is selected and the required attribute is set. |
| `name` | string | ✔ |  | The name of the checkbox group. |
| `options` | list | ✔ |  | Array of label-value pairs for each checkbox. |
| `required` | boolean |  | false | If present, at least one checkbox must be selected. |
| `validity` | object |  |  | Represents the validity states that an element can be in, with respect to constraint validation. Returns the ValidityState object for the … |
| `value` | string[] | ✔ |  | The list of selected checkboxes. Each array entry contains the value of a selected checkbox. The value of each checkbox is set in the opti… |
| `variant` | string |  | standard | The variant changes the appearance of the checkbox group. Accepted variants include standard, label-hidden, label-inline, and label-stacke… |

### 메서드 (Methods) — 5개

| 메서드 | 설명 |
|---|---|
| `check-validity` | Returns the valid attribute value (Boolean) on the ValidityState object. |
| `focus` | Sets focus on the first checkbox input element. |
| `report-validity` | Displays the error messages and returns false if the input is invalid. If the input is valid, reportValidity() clears displayed error mess… |
| `set-custom-validity` | Sets a custom error message to be displayed when the checkbox value is submitted. |
| `show-help-message-if-invalid` | Displays an error message if the checkbox value is required and no option is selected. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-checkbox-group/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-checkbox-group/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-checkbox-group/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-checkbox-group.html

---
[← 전체 목록으로 돌아가기](../components.html)
