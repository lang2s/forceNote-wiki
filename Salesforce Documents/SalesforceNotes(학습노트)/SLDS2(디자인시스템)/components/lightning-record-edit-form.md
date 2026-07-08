# Record Edit Form

`lightning-record-edit-form`  ·  카테고리: **Form**

레코드 생성/편집 폼(필드 직접 배치).

## 기본 예제 (Example)

```html
<lightning-record-edit-form object-api-name="Account" onsubmit={handleSubmit}>
  <lightning-input-field field-name="Name"></lightning-input-field>
</lightning-record-edit-form>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-record-edit-form` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 8개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `density` | string |  |  | Sets the arrangement style of fields and labels in the form. Accepted values are compact, comfy, and auto (default). Use compact to displa… |
| `field-names` | string[] |  |  | Reserved for internal use. Names of the fields to include in the form. |
| `form-class` | string |  |  | A CSS class for the form element. |
| `layout-type` | string |  | Full | Reserved for internal use. The type of layout to use to display the form fields. Possible values: Compact, Full. |
| `object-api-name` | string | ✔ |  | The API name of the object. |
| `optional-fields` | string[] |  |  | The optional fields of the record. |
| `record-id` | string |  |  | The ID of the record to be displayed. |
| `record-type-id` | string |  |  | The ID of the record type, which is required if you created multiple record types but don't have a default. |

### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `submit` | Submits the form using an array of record fields or field IDs. The field ID is provisioned from @salesforce/schema/. Invoke this method on… |

### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for form components like lightning-messages, lightning-button, lightning-input-field and lightning-output-field. Use lightning… |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-edit-form/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-edit-form/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-edit-form/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-record-edit-form.html

---
[← 전체 목록으로 돌아가기](../components.html)
