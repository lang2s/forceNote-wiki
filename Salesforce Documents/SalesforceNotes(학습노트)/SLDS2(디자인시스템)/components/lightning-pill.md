# Pill

`lightning-pill`  ·  카테고리: **Visual**

제거 가능한 라벨(태그) 칩.

## 기본 예제 (Example)

```html
<lightning-pill label="서울" onremove={handleRemove}></lightning-pill>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-pill` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 9개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `aria-selected` |  |  |  | Reserved for internal use. Specifies the aria-selected of an element. |
| `has-error` | boolean |  | false | If present, the pill is shown with a red border and an error icon on the left of the label. |
| `href` | string |  |  | The URL of the page that the link goes to. |
| `is-plain-link` | boolean |  |  | Reserved for internal use. Specifies whether the element variant is a plain link. |
| `label` | string | ✔ |  | The text label that displays in the pill. |
| `name` | string |  |  | The name for the pill. This value is optional and can be used to identify the pill in a callback. |
| `role` |  |  |  | Reserved for internal use. Specifies the role of an element. |
| `tab-index` | number |  |  | Reserved for internal use. Use tabindex instead to indicate if an element should be focusable. A value of 0 means that the pill is focusab… |
| `variant` | string |  | link | The variant changes the appearance of the pill. Accepted variants include link, plain, and plainLink. The default variant is link, which c… |

### 메서드 (Methods) — 2개

| 메서드 | 설명 |
|---|---|
| `focus-link` | Reserved for internal use. Sets focus on the anchor element for a plainLink pill. |
| `focus-remove` | Reserved for internal use. Sets focus on the remove button element for a plain pill. |

### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for an image, such as an icon or avatar. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-pill/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-pill/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-pill/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-pill.html

---
[← 전체 목록으로 돌아가기](../components.html)
