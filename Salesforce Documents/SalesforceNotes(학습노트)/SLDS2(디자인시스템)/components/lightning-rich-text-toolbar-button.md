# Rich Text Toolbar Button

`lightning-rich-text-toolbar-button`  ·  카테고리: **Input**

리치 텍스트 편집기에 추가하는 커스텀 툴바 버튼.

## 기본 예제 (Example)

```html
<lightning-rich-text-toolbar-button icon-name="utility:emoji" title="이모지" onclick={insert}></lightning-rich-text-toolbar-button>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-rich-text-toolbar-button` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 49.0

### 속성 (Attributes) — 6개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `aria-has-popup` | string |  |  | Specifies the value of the aria-haspopup attribute for the rendered toolbar button. Use this attribute to indicate the type of popup that … |
| `disabled` | Boolean |  | false | Specifies whether to display this button in a disabled state. Disabled buttons can't be clicked. This value defaults to false. |
| `group-order` |  |  |  | Reserved for internal use only. |
| `icon-alternative-text` | String |  |  | The alternative text used to describe the icon. This text should describe what happens when you click the button, for example 'Upload File… |
| `icon-name` | String |  |  | The Lightning Design System name of the icon for the custom button. Names are written in the format 'utility:down' where 'utility' is the … |
| `selected` | Boolean |  | false | Indicates whether the button is selected. This alters the button's selected or pressed state. A selected button is displayed with a dark c… |

### 메서드 (Methods) — 4개

| 메서드 | 설명 |
|---|---|
| `click` | Simulates a click on the button. |
| `close-popup` | Closes the popup that was displayed below the button. |
| `focus` | Sets focus on the button. |
| `show-popup` | Displays a popup below the button. Items passed in to the default slot of this component are rendered as the content of the popup. |

### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for items passed into a popup. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-rich-text-toolbar-button/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-rich-text-toolbar-button/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-rich-text-toolbar-button/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-rich-text-toolbar-button.html

---
[← 전체 목록으로 돌아가기](../components.html)
