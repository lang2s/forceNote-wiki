---
tags: [lwc, base-components, form, input-field, record-form, reference]
source: SLDS2-Docs/components/lightning-input-field.md (Tier 2)
created: 2026-06-14
aliases: [lightning-input-field, input-field, 입력 필드, 레코드 입력 필드, edit form 필드]
---

# lightning-input-field

> edit form 안에서 객체 필드 하나를 편집하는 입력 필드. 카테고리: **Form**.

---

## 기본 예제

```html
<!-- 구조 예시 — SLDS2-Docs 소스 기본 예제 -->
<lightning-input-field field-name="Name"></lightning-input-field>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 공식 **Example** 탭에서 직접 확인/편집할 수 있습니다.

`lightning-input-field`는 반드시 [[lightning-record-edit-form]] 안에 배치되어 객체 필드 하나의 값을 편집한다. `field-name`에 객체의 API 이름을 지정하면 필드 타입에 맞는 입력 UI(텍스트, 피클리스트, 체크박스 등)가 자동으로 렌더링된다. SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링된다.

### record-edit-form과 함께 쓰는 사용 예

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<lightning-record-edit-form object-api-name="Account" onsubmit={handleSubmit}>
  <lightning-input-field field-name="Name" required></lightning-input-field>
  <lightning-input-field field-name="Industry"></lightning-input-field>
  <lightning-input-field field-name="Phone"></lightning-input-field>
  <lightning-button type="submit" label="저장" variant="brand"></lightning-button>
</lightning-record-edit-form>
```

---

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다.

> [!note] 속성 설명은 소스(SLDS2-Docs)에서 **약 140자에서 잘려** 있습니다(`…`로 표기). 전체 문장은 아래 Specification 링크를 참고하세요.

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

---

## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-input-field/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-input-field/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-input-field/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-input-field.html

---

## 관련 노트

- [[lightning-record-edit-form]] — input-field를 감싸는 편집 폼 (필수 부모)
- [[lightning-output-field]] — 읽기 전용 대응 컴포넌트 (view form용)
- [[lightning-record-form]] — 필드를 직접 배치하지 않고 한 번에 처리하는 상위 폼
