# Slider

`lightning-slider`  ·  카테고리: **Input**

범위 값을 드래그로 조절하는 슬라이더.

## 기본 예제 (Example)

```html
<lightning-slider label="볼륨" value={value} min="0" max="100" onchange={handleChange}></lightning-slider>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-slider` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 18개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `disabled` | boolean |  | false | If present, the slider is disabled and users cannot interact with it. |
| `label` | string | ✔ |  | Text label to describe the slider. Provide your own label to describe the slider. |
| `max` | number |  | 100 | The maximum value of the input range. The default is 100. |
| `message-when-bad-input` | string |  |  | Error message to be displayed when a bad input is detected. |
| `message-when-pattern-mismatch` | string |  |  | Error message to be displayed when a pattern mismatch is detected. |
| `message-when-range-overflow` | string |  |  | Error message to be displayed when a range overflow is detected. |
| `message-when-range-underflow` | string |  |  | Error message to be displayed when a range underflow is detected. |
| `message-when-step-mismatch` | string |  |  | Error message to be displayed when a step mismatch is detected. |
| `message-when-too-long` | string |  |  | Error message to be displayed when the value is too long. |
| `message-when-type-mismatch` | string |  |  | Error message to be displayed when a type mismatch is detected. |
| `message-when-value-missing` | string |  |  | Error message to be displayed when the value is missing. |
| `min` | number |  | 0 | The minimum value of the input range. The default is 0. |
| `size` | string |  |  | The size of the slider. The default is an empty string, which sets the slider to the width of the viewport. Accepted values are x-small, s… |
| `step` | number |  | 1 | The step increment value of the input range. Example steps include 0.1, 1, or 10. The default is 1. |
| `type` | string |  | horizontal | The type determines the orientation of the slider. Accepted values are vertical and horizontal. The default is horizontal. |
| `validity` | object |  |  | Represents the validity states of the slider input, with respect to constraint validation. |
| `value` | number |  | 0 | The numerical value of the slider. The default is 0. |
| `variant` | string |  | standard | The variant changes the appearance of the slider. Accepted variants include standard and label-hidden. The default is standard. |

### 메서드 (Methods) — 6개

| 메서드 | 설명 |
|---|---|
| `blur` | Removes keyboard focus from the input element. |
| `check-validity` | Returns the valid attribute value (Boolean) on the ValidityState object. |
| `focus` | Sets focus on the input element. |
| `report-validity` | Displays the error messages and returns false if the input is invalid. If the input is valid, reportValidity() clears displayed error mess… |
| `set-custom-validity` | Sets a custom error message to be displayed when the slider value is submitted. |
| `show-help-message-if-invalid` | Displays error messages on invalid fields. An invalid field fails at least one constraint validation and returns false when checkValidity(… |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-slider/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-slider/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-slider/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-slider.html

---
[← 전체 목록으로 돌아가기](../components.html)
