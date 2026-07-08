# Radio Group

`lightning-radio-group`  ·  카테고리: **Input**

하나만 선택하는 라디오 버튼 묶음.

## 기본 예제 (Example)

```html
<lightning-radio-group label="성별" options={options} value={value} type="radio" onchange={handleChange}></lightning-radio-group>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-radio-group` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 10개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `disabled` | boolean |  | false | If present, the radio group is disabled and users cannot interact with it. |
| `label` | string | ✔ |  | Text label for the radio group. |
| `message-when-value-missing` | string |  |  | Optional message displayed when no radio button is selected and the required attribute is set to true. |
| `name` | string |  |  | Specifies the name of the radio button group. Only only one button can be selected if a name is specified for the group. |
| `options` | Array<{ label: string; value: string; }> | ✔ |  | Array of label-value pairs for each radio button. |
| `required` | boolean |  | false | If present, a radio button must be selected before the form can be submitted. |
| `type` | string |  | radio | The style of the radio group. Options are radio or button. The default is radio. |
| `validity` | object |  |  | Represents the validity states that an element can be in, with respect to constraint validation. |
| `value` | string |  |  | Specifies the value of the selected radio button. |
| `variant` | string |  | standard | The variant changes the appearance of the radio group. Accepted variants include standard, label-hidden, label-inline, and label-stacked. … |

### 메서드 (Methods) — 5개

| 메서드 | 설명 |
|---|---|
| `check-validity` | Returns the valid attribute value (Boolean) on the ValidityState object. |
| `focus` | Sets focus on the first radio input element. |
| `report-validity` | Displays the error messages and returns false if the input is invalid. If the input is valid, reportValidity() clears displayed error mess… |
| `set-custom-validity` | Sets a custom error message to be displayed when the radio group value is submitted. |
| `show-help-message-if-invalid` | Shows the help message if the form control is in an invalid state. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-radio-group/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-radio-group/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-radio-group/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-radio-group.html

---
[← 전체 목록으로 돌아가기](../components.html)
