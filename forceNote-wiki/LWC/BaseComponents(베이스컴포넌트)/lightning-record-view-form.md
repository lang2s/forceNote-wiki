---
tags: [lwc, base-components, form, record-view-form, record-form, reference]
source: SLDS2-Docs/components/lightning-record-view-form.md (Tier 2)
created: 2026-06-14
aliases: [lightning-record-view-form, record-view-form, 레코드 보기 폼, 읽기 전용 폼, view form]
---

# lightning-record-view-form

> 레코드를 읽기 전용으로 표시하는 폼. 필드를 직접 배치한다. 카테고리: **Form**.

---

## 기본 예제

```html
<!-- 구조 예시 — SLDS2-Docs 소스 기본 예제 -->
<lightning-record-view-form record-id={recordId} object-api-name="Account">
  <lightning-output-field field-name="Name"></lightning-output-field>
</lightning-record-view-form>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 공식 **Example** 탭에서 직접 확인/편집할 수 있습니다.

`lightning-record-view-form`은 [[lightning-output-field]]를 자식으로 받아 레코드 필드를 읽기 전용으로 표시한다. `record-id`와 `object-api-name`이 필수다. SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링된다.

### output-field와 함께 쓰는 사용 예

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<lightning-record-view-form record-id={recordId} object-api-name="Account" density="compact">
  <lightning-output-field field-name="Name"></lightning-output-field>
  <lightning-output-field field-name="Industry"></lightning-output-field>
  <lightning-output-field field-name="Phone"></lightning-output-field>
</lightning-record-view-form>
```

---

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다.

> [!note] 속성 설명은 소스(SLDS2-Docs)에서 **약 140자에서 잘려** 있습니다(`…`로 표기). 전체 문장은 아래 Specification 링크를 참고하세요.

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 4개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `density` | string |  |  | Sets the arrangement style of fields and labels in the form. Accepted values are compact, comfy, and auto (default). Use compact to displa… |
| `object-api-name` | string | ✔ |  | The API name of the object. |
| `optional-fields` | string[] |  |  | The optional fields of the record. |
| `record-id` | string \| null | ✔ |  | The ID of the record to be displayed. |

### 메서드 (Methods)

이 컴포넌트는 공식 명세에 노출된 public 메서드가 없습니다.

### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for lightning-output-field. |

---

## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-view-form/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-view-form/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-view-form/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-record-view-form.html

---

## 관련 노트

- [[lightning-output-field]] — 보기 폼 안에 배치하는 읽기 전용 필드
- [[lightning-record-edit-form]] — 편집 가능한 대응 폼
- [[lightning-record-form]] — 필드를 직접 배치하지 않는 상위 추상화 폼
