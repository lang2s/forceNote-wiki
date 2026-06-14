---
tags: [lwc, base-components, form, record-edit-form, record-form, reference]
source: SLDS2-Docs/components/lightning-record-edit-form.md (Tier 2)
created: 2026-06-14
aliases: [lightning-record-edit-form, record-edit-form, 레코드 편집 폼, 레코드 생성 폼, edit form]
---

# lightning-record-edit-form

> 레코드를 생성하거나 편집하는 폼. 필드를 직접 배치한다. 카테고리: **Form**.

---

## 기본 예제

```html
<!-- 구조 예시 — SLDS2-Docs 소스 기본 예제 -->
<lightning-record-edit-form object-api-name="Account" onsubmit={handleSubmit}>
  <lightning-input-field field-name="Name"></lightning-input-field>
</lightning-record-edit-form>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 공식 **Example** 탭에서 직접 확인/편집할 수 있습니다.

`lightning-record-edit-form`은 [[lightning-input-field]]를 자식으로 받아 레코드를 생성(`record-id` 미지정) 또는 편집(`record-id` 지정)한다. `lightning-messages`, `lightning-button`, `lightning-input-field`, `lightning-output-field`를 슬롯에 배치할 수 있다. SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링된다.

### input-field와 함께 쓰는 사용 예

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<lightning-record-edit-form
    object-api-name="Account"
    record-id={recordId}
    onsubmit={handleSubmit}
    onsuccess={handleSuccess}>
  <lightning-messages></lightning-messages>
  <lightning-input-field field-name="Name" required></lightning-input-field>
  <lightning-input-field field-name="Industry"></lightning-input-field>
  <lightning-button type="submit" label="저장" variant="brand"></lightning-button>
</lightning-record-edit-form>
```

---

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다.

> [!note] 속성 설명은 소스(SLDS2-Docs)에서 **약 140자에서 잘려** 있습니다(`…`로 표기). 전체 문장은 아래 Specification 링크를 참고하세요.

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

---

## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-edit-form/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-edit-form/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-edit-form/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-record-edit-form.html

---

## 관련 노트

- [[lightning-input-field]] — 편집 폼 안에 배치하는 입력 필드
- [[lightning-output-field]] — 편집 폼 안에 읽기 전용으로 함께 배치 가능
- [[lightning-record-view-form]] — 읽기 전용 대응 폼 (조회용)
- [[lightning-record-form]] — 필드를 직접 배치하지 않는 상위 추상화 폼
