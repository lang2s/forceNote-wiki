# Formatted Name

`lightning-formatted-name`  ·  카테고리: **Output**

이름을 로케일 순서로 표시.

## 기본 예제 (Example)

```html
<lightning-formatted-name first-name="길동" last-name="홍"></lightning-formatted-name>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-formatted-name` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 42.0

### 속성 (Attributes) — 8개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `first-name` | string |  |  | The value for the first name. |
| `format` | string |  |  | The format to use to display the name. Valid values include short, medium, and long. This value defaults to long. |
| `informal-name` | string |  |  | The value for the informal name. |
| `last-name` | string |  |  | The value for the last name. |
| `locale` | string |  | en-US | Specifies the locale used to determine the order of name components of the formatted name. This value defaults to en-US. |
| `middle-name` | string |  |  | The value for the middle name. |
| `salutation` | string |  |  | The value for the salutation, such as Dr. or Mrs. |
| `suffix` | string |  |  | The value for the suffix, such as Jr. or Esq. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-formatted-name/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-formatted-name/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-formatted-name/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-formatted-name.html

---
[← 전체 목록으로 돌아가기](../components.html)
