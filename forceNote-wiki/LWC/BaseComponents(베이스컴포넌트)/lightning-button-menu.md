---
tags: [lwc, base-component, button-menu, menu, dropdown, action, reference]
source: SLDS2-Docs/components/lightning-button-menu.md (+ lightning-menu-item.md, lightning-menu-divider.md, lightning-menu-subheader.md) — 공식 SLDS 문서 (Tier 2)
created: 2026-06-14
aliases: [lightning-button-menu, button-menu, 버튼 메뉴, 드롭다운 메뉴, lightning-menu-item, lightning-menu-divider, lightning-menu-subheader, 메뉴 항목, 메뉴 구분선, 메뉴 소제목]
---

# lightning-button-menu

> 클릭하면 드롭다운 메뉴가 열리는 버튼. 메뉴 안에는 항목(`lightning-menu-item`)·구분선(`lightning-menu-divider`)·소제목(`lightning-menu-subheader`)을 배치한다. 카테고리: **Action & Menu**.

> [!note] 속성 설명은 공식 cx-router 메타데이터에서 약 140자로 잘려 추출되었습니다(원문에 `…` 표시). 전체 문장은 각 컴포넌트의 **Specification** 링크를 참고하세요.

---

## 기본 사용

```html
<!-- SLDS2-Docs 공식 예제 (Tier 2) -->
<lightning-button-menu alternative-text="더보기" onselect={handleSelect}>
  <lightning-menu-item value="edit" label="편집"></lightning-menu-item>
  <lightning-menu-item value="delete" label="삭제"></lightning-menu-item>
</lightning-button-menu>
```

```javascript
// 구조 예시 — 실제 동작 코드 아님
handleSelect(event) {
    const selectedValue = event.detail.value; // 'edit' | 'delete'
    // 선택된 값에 따라 처리
}
```

하위 요소를 조합한 메뉴 예:

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<lightning-button-menu label="Actions" alternative-text="액션 메뉴" onselect={handleSelect}>
  <lightning-menu-subheader label="보기 옵션"></lightning-menu-subheader>
  <lightning-menu-item value="list" label="리스트 보기"></lightning-menu-item>
  <lightning-menu-item value="kanban" label="칸반 보기"></lightning-menu-item>
  <lightning-menu-divider variant="compact"></lightning-menu-divider>
  <lightning-menu-item value="delete" label="삭제" prefix-icon-name="utility:delete"></lightning-menu-item>
</lightning-button-menu>
```

---

## 속성 (Attributes) — 19개

지원 상태: **GA** · 최소 API 버전: 0.0

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

## 메서드 (Methods) — 2개

| 메서드 | 설명 |
|---|---|
| `click` | Simulates a mouse click on the button. |
| `focus` | Sets focus on the button. |

## 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for menu-item |

---

## 하위 요소

`lightning-button-menu`의 드롭다운 안에 배치하는 자식 컴포넌트들이다. 단독으로 사용하지 않고 항상 button-menu 슬롯 안에 둔다.

### lightning-menu-item — 메뉴 항목

> 버튼 메뉴 안의 개별 항목. 카테고리: **Action & Menu**.

```html
<!-- SLDS2-Docs 공식 예제 (Tier 2) -->
<lightning-menu-item value="edit" label="편집" icon-name="utility:edit"></lightning-menu-item>
```

#### 속성 (Attributes) — 14개

지원 상태: **GA** · 최소 API 버전: 0.0

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

#### 메서드 (Methods) — 2개

| 메서드 | 설명 |
|---|---|
| `click` | Clicks the anchor. |
| `focus` | Sets focus on the anchor element in the menu item. |

### lightning-menu-divider — 메뉴 구분선

> 버튼 메뉴 항목 사이의 구분선. 카테고리: **Action & Menu**.

```html
<!-- SLDS2-Docs 공식 예제 (Tier 2) -->
<lightning-menu-divider variant="compact"></lightning-menu-divider>
```

#### 속성 (Attributes) — 1개

지원 상태: **GA** · 최소 API 버전: 0.0

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `variant` | string |  | standard | The variant changes the spacing above and below the divider. Accepted variants include standard and compact. The compact variant decreases… |

### lightning-menu-subheader — 메뉴 소제목

> 버튼 메뉴 안 항목 그룹의 소제목. 카테고리: **Action & Menu**.

```html
<!-- SLDS2-Docs 공식 예제 (Tier 2) -->
<lightning-menu-subheader label="보기 옵션"></lightning-menu-subheader>
```

#### 속성 (Attributes) — 1개

지원 상태: **GA** · 최소 API 버전: 0.0

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `label` | string |  |  | The text displayed in the subheader. |

---

## 공식 문서 링크

- Example (실행 예제): https://developer.salesforce.com/docs/component-library/bundle/lightning-button-menu/example
- Develop (개발 가이드): https://developer.salesforce.com/docs/component-library/bundle/lightning-button-menu/documentation
- Specification (명세): https://developer.salesforce.com/docs/component-library/bundle/lightning-button-menu/specification
- menu-item Specification: https://developer.salesforce.com/docs/component-library/bundle/lightning-menu-item/specification
- menu-divider Specification: https://developer.salesforce.com/docs/component-library/bundle/lightning-menu-divider/specification
- menu-subheader Specification: https://developer.salesforce.com/docs/component-library/bundle/lightning-menu-subheader/specification

---

## 관련 노트

- [[lightning-button]] — 버튼 패밀리(button / button-icon / button-stateful) 레퍼런스
