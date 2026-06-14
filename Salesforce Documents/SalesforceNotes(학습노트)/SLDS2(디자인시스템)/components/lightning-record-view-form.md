# Record View Form

`lightning-record-view-form`  ·  카테고리: **Form**

레코드 읽기 전용 폼.

## 기본 예제 (Example)

```html
<lightning-record-view-form record-id={recordId} object-api-name="Account">
  <lightning-output-field field-name="Name"></lightning-output-field>
</lightning-record-view-form>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-record-view-form` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 4개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `density` | string |  |  | Sets the arrangement style of fields and labels in the form. Accepted values are compact, comfy, and auto (default). Use compact to displa… |
| `object-api-name` | string | ✔ |  | The API name of the object. |
| `optional-fields` | string[] |  |  | The optional fields of the record. |
| `record-id` | string \| null | ✔ |  | The ID of the record to be displayed. |

### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for lightning-output-field. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-view-form/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-view-form/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-record-view-form/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-record-view-form.html

---
[← 전체 목록으로 돌아가기](../components.html)
