# Input Field

`lightning-input-field`  ·  카테고리: **Form**

edit form 안에서 객체 필드 하나를 편집.

## 기본 예제 (Example)

```html
<lightning-input-field field-name="Name"></lightning-input-field>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-input-field` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 42.0

### 속성 (Attributes) — 9개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `aria-invalid` | boolean |  |  | A boolean value that controls whether assistive technologies read empty required textboxes as invalid. Default value is false. |
| `autocomplete` |  |  |  | Controls auto-filling of the input field based on the value. Supported field types: 'text', 'email', 'textarea', and 'single select pickli… |
| `dirty` | boolean |  | false | Reserved for internal use. If present, the field has been modified by the user but not saved or submitted. |
| `disabled` | boolean |  |  | If present, the field is grayed out and users can't interact with it. Disabled fields don't receive focus and are skipped in tabbing navig… |
| `field-name` | string |  |  | The API name of the field to be displayed. |
| `read-only` | boolean |  | false | Specifies whether an input field is read-only. This value defaults to false. Not supported for the following field types: rich text, pickl… |
| `required` | boolean |  | false | If present, the input field must be filled out before the form is submitted. |
| `value` | string |  |  | The field value, which overrides the existing value. |
| `variant` | string |  | standard | The variant changes the label position of an input field. Accepted variants include standard, label-hidden, label-inline, and label-stacke… |

### 메서드 (Methods) — 8개

| 메서드 | 설명 |
|---|---|
| `clean` | Reserved for internal use. Clean up the field dirty state. |
| `focus` | Focus underlying input |
| `report-validity` | Reserved for internal use. |
| `reset` | Resets the form fields to their initial values. |
| `set-errors` | Reserved for internal use. |
| `update-dependent-field` | Reserved for internal use. |
| `wire-picklist-values` | Reserved for internal use. |
| `wire-record-ui` | Reserved for internal use. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-input-field/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-input-field/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-input-field/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-input-field.html

---
[← 전체 목록으로 돌아가기](../components.html)
