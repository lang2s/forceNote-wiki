# Input

`lightning-input`  ·  카테고리: **Input**

텍스트/숫자/날짜/체크박스 등 다양한 타입의 입력 필드.

## 기본 예제 (Example)

```html
<lightning-input type="text" label="이름" value={name} onchange={handleChange}></lightning-input>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-input` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 74개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `accept` | string |  |  | Specifies the types of files that the server accepts. Use this attribute with file input type only. |
| `access-key` | string |  |  | Specifies a shortcut key to activate or focus an element. |
| `aria-active-descendant-element` | HTMLElement \| null |  |  | The active descendant element reference for aria-activedescendant. When set, the element is passed to AriaObserver as relatedNodes so the … |
| `aria-auto-complete` | string |  |  | Specifies the value of the aria-autocomplete, only valid on type simple |
| `aria-controls` | string |  |  | A space-separated list of element IDs whose presence or content is controlled by the input. |
| `aria-described-by` | string |  |  | A space-separated list of element IDs that provide descriptive labels for the input. |
| `aria-details` | string |  |  | A space-separated list of IDs of elements that provide details for the input. |
| `aria-disabled` | boolean |  |  | Specifies the value of the aria-disabled attribute |
| `aria-error-message` |  |  |  | A space-separated list of element IDs that provide descriptive error message for input. |
| `aria-expanded` | string |  |  | Specifies the value of the aria-expanded attribute, only valid on type simple |
| `aria-has-popup` |  |  |  | Specifies the value of the aria-haspopup attribute |
| `aria-invalid` | boolean |  |  | A Boolean value for aria-invalid. |
| `aria-key-shortcuts` | string |  |  | Specifies the value of the aria-keyshortcuts attribute |
| `aria-label` | string |  |  | Describes the input to assistive technologies. |
| `aria-labelled-by` | string |  |  | A space-separated list of element IDs that provide labels for the input. |
| `aria-role-description` | string |  |  | Specifies the value of the aria-roledescription attribute |
| `autocomplete` | string |  |  | Controls auto-filling of the field. Use this attribute with email, search, tel, text, and url input types only. Set the attribute to pass … |
| `checked` | boolean |  | false | If present, the checkbox is selected. |
| `date-access-key` | string |  |  | Sets a key that can be used to access the date picker when you use the datetime type. |
| `date-aria-controls` | string |  |  | A space-separated list of element IDs whose presence or content is controlled by the date input when type='datetime'. On mobile devices, t… |
| `date-aria-described-by` | string |  |  | A space-separated list of element IDs that provide descriptive labels for the date input when type='datetime'. On mobile devices, this is … |
| `date-aria-details` | string |  |  | A space-separated list of IDs of elements that provide details of the date input when type='datetime'. |
| `date-aria-error-message` | string |  |  | A space-separated list of element IDs that provide error messages for the date input when type='datetime'. |
| `date-aria-label` | string |  |  | Describes the date input to assistive technologies when type='datetime'. On mobile devices, this label is merged with aria-label and time-… |
| `date-aria-labelled-by` | string |  |  | A space-separated list of element IDs that provide labels for the date input when type='datetime'. On mobile devices, this is merged with … |
| `date-style` | string |  | medium | The display style of the date when type='date' or type='datetime'. Valid values are short, medium (default), and long. The format of each … |
| `disabled` | boolean |  | false | If present, the input field is disabled and users cannot interact with it. |
| `field-level-help` | string |  |  | Help text detailing the purpose and function of the input. This attribute isn't supported for file, toggle, and checkbox-button types. |
| `files` | object |  |  | A FileList that contains selected files. Use this attribute with the file input type only. When setting the files property, the value must… |
| `format-fraction-digits` | number |  |  | Reserved for internal use. |
| `formatter` | string |  |  | String value with the formatter to be used for number input. Valid values include decimal, percent, percent-fixed, and currency. |
| `indeterminate` | boolean |  | false | If present, the checkbox is displayed with an indeterminate state, showing a dash indicator instead of a checkmark or empty box. This is c… |
| `inputmode` |  |  |  | Controls the virtual keyboard type on mobile devices. This property should ideally be named `inputMode` (camelCase) to follow JavaScript n… |
| `is-loading` | boolean |  | false | For the search type only. If present, a spinner is displayed to indicate that data is loading. |
| `label` | string | ✔ |  | Text label for the input. |
| `max` | decimal\|string |  |  | The maximum acceptable value for the input. Use this attribute with number, range, date, time, and datetime input types only. For number a… |
| `max-length` | number |  |  | The maximum number of characters allowed in the field. Use this attribute with email, password, search, tel, text, and url input types only. |
| `message-toggle-active` | string |  |  | Text shown for the active state of a toggle. The default is "Active". |
| `message-toggle-inactive` | string |  |  | Text shown for the inactive state of a toggle. The default is "Inactive". |
| `message-when-bad-input` | string |  |  | Error message to be displayed when a bad input is detected. The badInput error can be returned for invalid input for any input type. |
| `message-when-pattern-mismatch` | string |  |  | Error message to be displayed when a pattern mismatch is detected. The patternMismatch error can be returned when you specify a pattern fo… |
| `message-when-range-overflow` | string |  |  | Error message to be displayed when a range overflow is detected. The rangeOverflow error can be returned when you specify a max value for … |
| `message-when-range-underflow` | string |  |  | Error message to be displayed when a range underflow is detected. The rangeUnderflow error can be returned when you specify a min value fo… |
| `message-when-step-mismatch` | string |  |  | Error message to be displayed when a step mismatch is detected. The stepMismatch error can be returned when you specify a step value for n… |
| `message-when-too-long` | string |  |  | Error message to be displayed when the value is too long. The tooLong error can be returned when you specify a max-length value for email,… |
| `message-when-too-short` | string |  |  | Error message to be displayed when the value is too short. The tooShort error can be returned when you specify a min-length value for emai… |
| `message-when-type-mismatch` | string |  |  | Error message to be displayed when a type mismatch is detected. The typeMismatch error can be returned for the email and url input types. |
| `message-when-value-missing` | string |  |  | Error message to be displayed when the value is missing. The valueMissing error can be returned when you specify the required attribute fo… |
| `min` | decimal\|string |  |  | The minimum acceptable value for the input. Use this attribute with number, range, date, time, and datetime input types only. For number a… |
| `min-length` | number |  |  | The minimum number of characters allowed in the field. Use this attribute with email, password, search, tel, text, and url input types only. |
| `multiple` | boolean |  | false | Specifies that a user can enter more than one value. Use this attribute with file and email input types only. |
| `name` | string |  |  | Specifies the name of an input element. |
| `pattern` | string |  |  | Specifies the regular expression that the input's value is checked against. This attribute is supported for email, password, search, tel, … |
| `placeholder` | string |  |  | Text that is displayed when the field is empty, to prompt the user for a valid entry. Use this attribute with date, email, number, passwor… |
| `read-only` | boolean |  | false | If present, the input field is read-only and cannot be edited by users. |
| `required` | boolean |  | false | If present, the input field must be filled out before the form is submitted. |
| `role` | string |  |  | The role set on lightning-primitive-input-simple to allow external developers to have a type="text" and role="combobox" if lightning-combo… |
| `selection-end` |  |  |  | Specifies the index of the last character to select in the input element. This attribute is supported only for text type. Use with selecti… |
| `selection-start` |  |  |  | Specifies the index of the first character to select in the input element. This attribute is supported only for text type. Use with select… |
| `step` | decimal\|string |  | 1 | Granularity of the value, specified as a positive floating point number. Use this attribute with number and range input types only. Use 'a… |
| `time-access-key` | string |  |  | Sets a key that can be used to access the time picker when you use the datetime type. |
| `time-aria-controls` | string |  |  | A space-separated list of element IDs whose presence or content is controlled by the time input when type='datetime'. On mobile devices, t… |
| `time-aria-described-by` | string |  |  | A space-separated list of element IDs that provide descriptive labels for the time input when type='datetime'. On mobile devices, this is … |
| `time-aria-details` | string |  |  | A space-separated list of IDs of elements that provide details of the date input when type='datetime'. |
| `time-aria-error-message` | string |  |  | A space-separated list of element IDs that provide error messages for the time input when type='datetime'. |
| `time-aria-label` | string |  |  | Describes the time input to assistive technologies when type='datetime'. On mobile devices, this label is merged with aria-label and date-… |
| `time-aria-labelled-by` | string |  |  | A space-separated list of element IDs that provide labels for the time input when type='datetime'. On mobile devices, this is merged with … |
| `time-step-minutes` | number |  | 15 | Specifies the time interval in minutes for the dropdown options. Any positive integer above or equal to 5 is valid. The default is 15 minu… |
| `time-style` | string |  | short | The display style of the time when type='time' or type='datetime'. Valid values are short (default), medium, and long. Currently, medium a… |
| `timezone` | string |  |  | Specifies the time zone used when type='datetime' only. This value defaults to the user's Salesforce time zone setting. |
| `type` | string |  | text | The type of the input. Valid values are checkbox, checkbox-button, color, date, datetime, time, email, file, password, range, search, tel,… |
| `validity` | object |  |  | Represents the validity states that an element can be in, with respect to constraint validation. |
| `value` | object |  |  | Specifies the value of an input element. |
| `variant` | string |  | standard | The variant changes the appearance of an input field. Accepted variants include standard, label-inline, label-hidden, and label-stacked. T… |

### 메서드 (Methods) — 6개

| 메서드 | 설명 |
|---|---|
| `blur` | Removes keyboard focus from the input element. |
| `check-validity` | Checks if the input is valid. |
| `focus` | Sets focus on the input element. |
| `report-validity` | Displays the error messages and returns false if the input is invalid. If the input is valid, reportValidity() clears displayed error mess… |
| `set-custom-validity` | Sets a custom error message to be displayed when a form is submitted. |
| `show-help-message-if-invalid` | Displays error messages on invalid fields. An invalid field fails at least one constraint validation and returns false when checkValidity(… |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-input/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-input/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-input/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-input.html

---
[← 전체 목록으로 돌아가기](../components.html)
