---
tags: [lwc, base-components, form, output-field, record-form, reference]
source: SLDS2-Docs/components/lightning-output-field.md (Tier 2)
created: 2026-06-14
aliases: [lightning-output-field, output-field, 출력 필드, 읽기 전용 필드, view form 필드]
---

# lightning-output-field

> view form 안에서 객체 필드 하나를 읽기 전용으로 표시하는 출력 필드. 카테고리: **Form**.

---

## 기본 예제

```html
<!-- 구조 예시 — SLDS2-Docs 소스 기본 예제 -->
<lightning-output-field field-name="Name"></lightning-output-field>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 공식 **Example** 탭에서 직접 확인/편집할 수 있습니다.

`lightning-output-field`는 반드시 [[lightning-record-view-form]] (또는 [[lightning-record-edit-form]]) 안에 배치되어 객체 필드 하나의 값을 읽기 전용으로 표시한다. 필드 타입에 맞는 포맷(주소, 통화, 날짜 등)이 자동 적용된다. SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링된다.

### record-view-form과 함께 쓰는 사용 예

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<lightning-record-view-form record-id={recordId} object-api-name="Account">
  <lightning-output-field field-name="Name"></lightning-output-field>
  <lightning-output-field field-name="Industry"></lightning-output-field>
  <lightning-output-field field-name="Phone" variant="label-hidden"></lightning-output-field>
</lightning-record-view-form>
```

---

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다.

> [!note] 속성 설명은 소스(SLDS2-Docs)에서 **약 140자에서 잘려** 있습니다(`…`로 표기). 전체 문장은 아래 Specification 링크를 참고하세요.

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 3개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `field-class` | string |  |  | A CSS class for the outer element, in addition to the component's base classes. |
| `field-name` | string |  |  | The API name of the field to be displayed. |
| `variant` | string |  | standard | Changes the appearance of the output. Accepted variants include standard and label-hidden. This value defaults to standard. |

### 메서드 (Methods) — 2개

| 메서드 | 설명 |
|---|---|
| `wire-picklist-values` | Reserved for internal use. |
| `wire-record-ui` | Reserved for internal use. |

---

## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-output-field/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-output-field/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-output-field/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-output-field.html

---

## 관련 노트

- [[lightning-record-view-form]] — output-field를 감싸는 읽기 전용 폼 (필수 부모)
- [[lightning-input-field]] — 편집 가능한 대응 컴포넌트 (edit form용)
- [[lightning-record-form]] — 필드를 직접 배치하지 않고 한 번에 처리하는 상위 폼
