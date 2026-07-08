# Formatted URL

`lightning-formatted-url`  ·  카테고리: **Output**

URL을 하이퍼링크로 표시.

## 기본 예제 (Example)

```html
<lightning-formatted-url value="https://example.com" label="사이트 방문"></lightning-formatted-url>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-formatted-url` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 5개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `label` | string |  |  | The text to display in the link. |
| `tab-index` | number |  |  | Reserved for internal use. Use tabindex instead to indicate if an element should be focusable. A value of 0 means that the element is focu… |
| `target` | string |  |  | Specifies where to open the link. Options include _blank, _parent, _self, and _top. This value defaults to _self. |
| `tooltip` | string |  |  | The text to display when the mouse hovers over the link. A link doesn't display a tooltip unless a text value is provided. |
| `value` | string |  |  | The URL to format. |

### 메서드 (Methods) — 3개

| 메서드 | 설명 |
|---|---|
| `blur` | Removes keyboard focus from the element. |
| `click` | Simulates a mouse click on the url and navigates to it using the specified target. |
| `focus` | Sets focus on the element. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-formatted-url/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-formatted-url/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-formatted-url/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-formatted-url.html

---
[← 전체 목록으로 돌아가기](../components.html)
