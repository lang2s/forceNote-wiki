---
tags: [lwc, base-component, input, form, reference]
source: TrailheadApp/lwc-recipes-main (Tier 1) + cx-router 메타데이터 (Tier 2) + external-knowledge (Tier 3)
created: 2026-05-17
aliases: [lightning-input, 입력 컴포넌트, text input]
---

# lightning-input

> 텍스트, 숫자, 날짜, 이메일, 파일 등 다목적 입력 필드. `type` 속성 하나로 14가지 입력 유형을 전환한다.

> [!warning] 속성 목록은 외부 지식(Tier 3) 기반 — 공식 소스와 전수 대조되지 않았습니다. 코드 예시는 `lwc-recipes-main` (Tier 1).

---

## 사용 가능 환경

Lightning Experience, Experience Builder Sites, Salesforce Mobile App, Lightning Out (Beta), Standalone Lightning App

---

## 기본 사용 *(lwc-recipes-main/helloBinding — Tier 1)*

```html
<template>
    <lightning-card title="HelloBinding">
        <div class="slds-var-m-around_medium">
            <p>Hello, {greeting}!</p>
            <lightning-input
                label="Name"
                value={greeting}
                onchange={handleChange}
            ></lightning-input>
        </div>
    </lightning-card>
</template>
```

```javascript
import { LightningElement } from 'lwc';

export default class HelloBinding extends LightningElement {
    greeting = 'World';

    handleChange(event) {
        this.greeting = event.target.value;
    }
}
```

---

## type 변형 14가지

```html
<!-- 텍스트 -->
<lightning-input type="text" label="이름" value={name} onchange={handleChange}></lightning-input>

<!-- 숫자 -->
<lightning-input type="number" label="수량" min="0" max="100" step="1" formatter="decimal"></lightning-input>

<!-- 통화 -->
<lightning-input type="number" label="금액" formatter="currency" step="0.01"></lightning-input>

<!-- 날짜 -->
<lightning-input type="date" label="날짜" value={dateVal}></lightning-input>

<!-- 날짜+시간 -->
<lightning-input type="datetime" label="날짜/시간"></lightning-input>

<!-- 시간 -->
<lightning-input type="time" label="시간"></lightning-input>

<!-- 이메일 -->
<lightning-input type="email" label="이메일" value={email}></lightning-input>

<!-- 전화번호 -->
<lightning-input type="tel" label="전화번호"></lightning-input>

<!-- URL -->
<lightning-input type="url" label="웹사이트"></lightning-input>

<!-- 비밀번호 -->
<lightning-input type="password" label="비밀번호"></lightning-input>

<!-- 체크박스 (true/false) -->
<lightning-input type="checkbox" label="동의" checked={isChecked} onchange={handleCheckbox}></lightning-input>

<!-- 토글 (checkbox의 슬라이드 버전) -->
<lightning-input type="toggle" label="활성" message-toggle-active="켜짐" message-toggle-inactive="꺼짐"></lightning-input>

<!-- 파일 -->
<lightning-input type="file" label="파일 선택" accept=".pdf,.docx" multiple></lightning-input>

<!-- 검색 *(lwc-recipes-main/compositionContactSearch — Tier 1)* -->
<lightning-input type="search" label="Search" onchange={handleKeyChange}></lightning-input>

<!-- 색상 -->
<lightning-input type="color" label="색상 선택"></lightning-input>
```

---

## 검색 입력 + 디바운싱 패턴 *(lwc-recipes-main/compositionContactSearch — Tier 1)*

```javascript
import { LightningElement } from 'lwc';
import findContacts from '@salesforce/apex/ContactController.findContacts';

const DELAY = 350;

export default class CompositionContactSearch extends LightningElement {
    contacts;
    error;

    handleKeyChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(async () => {
            try {
                this.contacts = await findContacts({ searchKey });
                this.error = undefined;
            } catch (error) {
                this.error = error;
                this.contacts = undefined;
            }
        }, DELAY);
    }
}
```

---

## 전체 속성 레퍼런스

| 속성 | 타입 | 설명 |
|---|---|---|
| `label` | string | 필드 레이블 (필수) |
| `type` | string | 입력 유형 (기본값: `text`) |
| `value` | string | 현재 값 |
| `name` | string | 폼 제출 시 사용되는 이름 |
| `placeholder` | string | 입력 전 안내 텍스트 |
| `required` | boolean | 필수 필드 표시 및 검사 |
| `disabled` | boolean | 비활성화 |
| `readonly` | boolean | 읽기 전용 |
| `variant` | string | `standard`(기본) / `label-hidden` / `label-inline` / `label-stacked` |
| `field-level-help` | string | 물음표 아이콘 옆 도움말 텍스트 |
| `min` | number / string | 최솟값 (number, date, time, datetime) |
| `max` | number / string | 최댓값 |
| `step` | number | 증가 단위 (number) |
| `minlength` | number | 최소 문자 수 (text) |
| `maxlength` | number | 최대 문자 수 |
| `pattern` | string | 정규식 유효성 검사 패턴 |
| `formatter` | string | 숫자 형식: `decimal` / `currency` / `percent` / `percent-fixed` |
| `multiple` | boolean | 파일 다중 선택 (type=file) |
| `accept` | string | 허용 파일 확장자 (type=file) |
| `checked` | boolean | 체크 여부 (type=checkbox, toggle) |
| `message-when-value-missing` | string | required 미충족 시 에러 메시지 |
| `message-when-pattern-mismatch` | string | pattern 불일치 시 에러 메시지 |
| `message-when-range-overflow` | string | max 초과 시 에러 메시지 |
| `message-when-range-underflow` | string | min 미만 시 에러 메시지 |
| `message-toggle-active` | string | 토글 ON 상태 레이블 (type=toggle) |
| `message-toggle-inactive` | string | 토글 OFF 상태 레이블 (type=toggle) |

---

## 이벤트

| 이벤트 | 설명 | 주요 프로퍼티 |
|---|---|---|
| `change` | 값이 변경될 때 | `event.detail.value` (텍스트) / `event.detail.checked` (checkbox, toggle) |
| `commit` | Enter 또는 포커스 이탈 시 | `event.detail.value` |
| `focus` | 포커스 획득 시 | — |
| `blur` | 포커스 이탈 시 | — |

```javascript
// change 이벤트 처리 패턴
handleChange(event) {
    // 텍스트, 숫자, 날짜 등
    const value = event.target.value;

    // checkbox, toggle
    const checked = event.target.checked;
}
```

---

## 유효성 검사

```javascript
// reportValidity() — 유효성 검사 실행 + 오류 메시지 표시
// checkValidity() — 유효성 검사 실행 (메시지 표시 없음)
// setCustomValidity(message) — 커스텀 에러 메시지 설정

handleSubmit() {
    const input = this.template.querySelector('lightning-input');
    if (!input.checkValidity()) {
        input.reportValidity();
        return;
    }
    // 폼 처리 로직
}
```

---

## 접근성 (Accessibility)

- `label` 속성은 항상 지정한다 (`label-hidden`으로 시각적으로 숨기더라도 접근성을 위해 제공)
- `required` 설정 시 보조 기술에 필수 입력 알림
- `field-level-help` 도움말은 포커스 시 읽힘

---

## 사용 고려사항

- `type="number"`에서 `value`는 항상 문자열로 반환됨 — 숫자로 사용하려면 `parseFloat()`/`parseInt()` 변환 필요
- `type="checkbox"` / `type="toggle"` 에서 `event.detail.value`가 아닌 `event.target.checked`로 값을 읽는다
- `type="file"` 에서 파일 콘텐츠 접근은 `event.detail.files` (FileList)
- `variant="label-hidden"` — 레이블이 시각적으로 숨겨지지만 DOM에 존재 (접근성 유지)

---


---

## 전체 공식 속성 명세 (cx-router · Tier 2)

> Salesforce 공식 cx-router 메타데이터에서 추출한 전체 속성·메서드·이벤트·슬롯 명세입니다(Tier 2). 위 예제·패턴은 기존 lwc-recipes Tier 1 큐레이션입니다.


### lightning-input

지원 상태: **GA** · 최소 API 버전: 0.0

#### 속성 (Attributes) — 74개

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

#### 메서드 (Methods) — 6개

| 메서드 | 설명 |
|---|---|
| `blur` | Removes keyboard focus from the input element. |
| `check-validity` | Checks if the input is valid. |
| `focus` | Sets focus on the input element. |
| `report-validity` | Displays the error messages and returns false if the input is invalid. If the input is valid, reportValidity() clears displayed error mess… |
| `set-custom-validity` | Sets a custom error message to be displayed when a form is submitted. |
| `show-help-message-if-invalid` | Displays error messages on invalid fields. An invalid field fails at least one constraint validation and returns false when checkValidity(… |
## 관련 노트

- [[Lightning Base Components 레퍼런스]] — 전체 입력 컴포넌트 목록
- [[lightning-combobox]] — 드롭다운 단일 선택 입력
- [[lightning-record-form]] — 레코드 필드 자동 입력 폼
- [[파일 업로드와 이미지 처리]] — type=file 고급 처리 패턴
- [[Winter '25/Development]] — v62.0 `type="number"` 신규 `badNumericInput` validity + `type="date"` 날짜 형식 인라인 안내·접근성 변경
