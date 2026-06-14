# Button Menu

`lightning-button-menu`  ·  카테고리: **Action & Menu**

클릭하면 드롭다운 메뉴가 열리는 버튼.

## 기본 예제 (Example)

```html
<lightning-button-menu alternative-text="더보기" onselect={handleSelect}>
  <lightning-menu-item value="edit" label="편집"></lightning-menu-item>
  <lightning-menu-item value="delete" label="삭제"></lightning-menu-item>
</lightning-button-menu>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-button-menu` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 19개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `access-key` | string |  |  | The keyboard shortcut for the button menu. |
| `alternative-text` | string |  |  | The assistive text for the button. |
| `disabled` | boolean |  | false | If present, the menu can be opened by users. |
| `draft-alternative-text` | string |  |  | Describes the reason for showing the draft indicator. This is required when is-draft is true. |
| `group-order` | string |  |  | Reserved for internal use only. Describes the order of this element (first, middle or last) inside lightning-button-group. |
| `icon-name` | string |  | utility:down | The name of the icon to be used in the format 'utility:down'. If an icon other than 'utility:down' or 'utility:chevrondown' is used, a uti… |
| `icon-size` | string |  | medium | The size of the icon. Options include xx-small, x-small, small, medium, or large. This value defaults to medium. |
| `internal-datatable-actions-menu` | boolean |  | false | For internal use only If this is present, then the button-menu is being used on the datatable it will remove the dropdown arrow for when '… |
| `is-draft` | boolean |  | false | If present, the menu trigger shows a draft indicator. |
| `is-loading` | boolean |  | false | If present, the menu is in a loading state and shows a spinner. |
| `label` | string |  |  | Optional text to be shown on the button. |
| `loading-state-alternative-text` | string |  |  | Message displayed while the menu is in the loading state. |
| `menu-alignment` | string |  | left | Determines the alignment of the menu relative to the button. Available options are: auto, left, center, right, bottom-left, bottom-center,… |
| `nubbin` | boolean |  | false | If present, a nubbin is present on the menu. A nubbin is a stub that protrudes from the menu item towards the button menu. The nubbin posi… |
| `tab-index` | number |  |  | Reserved for internal use only. Should be set to -1 if button should not be focused when navigating with tab |
| `title` | string |  |  | Displays tooltip text when the mouse moves over the button menu. |
| `tooltip` | string |  |  | Text to display when the user mouses over or focuses on the button. The tooltip is auto-positioned relative to the button and screen space. |
| `value` | string |  |  | The value for the button element. This value is optional and can be used when submitting a form. |
| `variant` | string |  | border | The variant changes the look of the button. Accepted variants include bare, container, border, border-filled, bare-inverse, and border-inv… |

### 메서드 (Methods) — 2개

| 메서드 | 설명 |
|---|---|
| `click` | Simulates a mouse click on the button. |
| `focus` | Sets focus on the button. |

### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for menu-item |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button-menu/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button-menu/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-button-menu/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-button-menu.html

---
[← 전체 목록으로 돌아가기](../components.html)
