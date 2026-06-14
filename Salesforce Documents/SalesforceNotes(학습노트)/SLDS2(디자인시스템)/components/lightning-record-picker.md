# Record Picker

`lightning-record-picker`  ·  카테고리: **Input**

레코드를 검색해 선택하는 룩업 입력.

## 기본 예제 (Example)

```html
<lightning-record-picker label="계정" object-api-name="Account" onchange={handleChange}></lightning-record-picker>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-record-picker` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 59.0

### 속성 (Attributes) — 12개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `disabled` | boolean |  | false | If present, the component is disabled and you can't interact with it. |
| `display-info` |  |  |  | The display configuration used to customize the way retrieved records are presented. |
| `field-level-help` | string |  |  | Help text detailing the purpose and function of the record picker, displayed on hover for desktop and on click for mobile |
| `filter` | Filter |  |  | The filter applied to the retrieved records. |
| `label` | string | ✔ |  | The text label for the component. |
| `matching-info` | MatchingInfo |  |  | The matching configuration to customize the fields used to match the search results to the search term entered by the user. |
| `message-when-bad-input` | String |  |  | The error message displayed when the user enters a search term in the input but doesn't select an option. |
| `object-api-name` | string | ✔ |  | The API name of the object for the retrieved records. |
| `placeholder` | string |  |  | The text displayed when the input is empty to prompt the user to enter a search term. |
| `required` | boolean |  | false | If present, specifies that a user must select a record. If no record is selected, the record picker is in an invalid state. |
| `value` | string |  |  | The ID of the record that is selected in the record picker. |
| `variant` | string |  |  | The variant changes the appearance of the component. The component displays the label above the combobox by default. Specify variant="labe… |

### 메서드 (Methods) — 6개

| 메서드 | 설명 |
|---|---|
| `blur` | Remove the focus of the component. |
| `check-validity` | Check if the component is in a valid state. |
| `clear-selection` | Clears the selected record. This method does not clear the search term or refresh the validity message. |
| `focus` | Set the focus of the component. |
| `report-validity` | Check if the component is in a valid state and refresh the validity message. If the component is valid, it clears the validity error messa… |
| `set-custom-validity` | Set a custom validity error message. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-picker/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-picker/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-picker/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-record-picker.html

---
[← 전체 목록으로 돌아가기](../components.html)
