# Menu Item

`lightning-menu-item`  ·  카테고리: **Action & Menu**

버튼 메뉴 안의 개별 항목.

## 기본 예제 (Example)

```html
<lightning-menu-item value="edit" label="편집" icon-name="utility:edit"></lightning-menu-item>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-menu-item` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 0.0

### 속성 (Attributes) — 14개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `access-key` | string |  |  | The keyboard shortcut for the menu item. |
| `checked` | boolean |  | false | If present, a check mark displays on the left of the menu item if it's selected. |
| `disabled` | boolean |  | false | If present, the menu item is disabled and users cannot interact with it. |
| `download` | string |  |  | The name of a file that's downloaded when clicking a link in the menu item. Used with the href attribute. |
| `draft-alternative-text` | string |  |  | Describes the reason for showing the draft indicator. This is required when is-draft is present on the lightning-menu-item tag. |
| `href` | string |  |  | URL for a link to use for the menu item. |
| `icon-name` | string |  |  | The name of an icon to display after the text of the menu item. |
| `icon-type` | string |  | standard | The iconType changes the appearance of the icons in the menu item. Accepted variants include standard and color. This value defaults to st… |
| `is-draft` | boolean |  | false | If present, a draft indicator is shown on the menu item. A draft indicator is denoted by blue asterisk on the left of the menu item. When … |
| `label` | string |  |  | Text of the menu item. |
| `prefix-icon-name` | string |  |  | The name of an icon to display before the text of the menu item. |
| `tab-index` | number |  |  | Reserved for internal use. Use tabindex instead to indicate if an element should be focusable. tabindex can be set to 0 or -1. The default… |
| `target` | string |  |  | Determines how a link in the href attribute is opened. Valid values include '_self' and '_blank'. The default is '_self', which opens the … |
| `value` | string |  |  | A value associated with the menu item. |

### 메서드 (Methods) — 2개

| 메서드 | 설명 |
|---|---|
| `click` | Clicks the anchor. |
| `focus` | Sets focus on the anchor element in the menu item. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-menu-item/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-menu-item/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-menu-item/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-menu-item.html

---
[← 전체 목록으로 돌아가기](../components.html)
