# Button Icon Stateful

`lightning-button-icon-stateful`  ·  카테고리: **Action & Menu**

눌림(선택) 상태를 토글하는 아이콘 버튼. 예: 좋아요.

## 기본 예제 (Example)

```html
<lightning-button-icon-stateful icon-name="utility:like" selected={liked} onclick={toggleLike} alternative-text="좋아요"></lightning-button-icon-stateful>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-button-icon-stateful` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 8개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `alternative-text` | string |  |  | The alternative text used to describe the icon. This text should describe what happens when you click the button, for example 'Upload File… |
| `icon-name` | string |  |  | The Lightning Design System name of the icon. Names are written in the format 'utility:down' where 'utility' is the category, and 'down' i… |
| `name` | string |  |  | The name for the button element. This value is optional and can be used to identify the button in a callback. |
| `selected` | boolean |  |  | Specifies whether the button is in a selected state. This value defaults to false. |
| `size` | string |  | medium | The size of the button-icon component. Options include xx-small, x-small, small, and medium. This value defaults to medium. |
| `tooltip` | string |  |  | Text to display when the user mouses over or focuses on the button. The tooltip is auto-positioned relative to the button and screen space. |
| `value` | string |  |  | The value for the button element. This value is optional and can be used when submitting a form. |
| `variant` | string |  | border | The variant changes the appearance of button-icon. Accepted variants include border, border-filled, and border-inverse. This value default… |

### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `focus` | Sets focus on the button. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button-icon-stateful/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button-icon-stateful/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button-icon-stateful/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-button-icon-stateful.html

---
[← 전체 목록으로 돌아가기](../components.html)
