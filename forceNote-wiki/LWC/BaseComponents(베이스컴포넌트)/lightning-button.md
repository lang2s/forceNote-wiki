---
tags: [lwc, base-component, button, reference]
source: TrailheadApp/lwc-recipes-main (Tier 1) + external-knowledge (Tier 3)
created: 2026-05-17
aliases: [lightning-button, lightning-button-icon, lightning-button-menu, 버튼, 아이콘 버튼, 드롭다운 버튼]
---

# lightning-button / button-icon / button-menu

> 표준 버튼, 아이콘 버튼, 드롭다운 메뉴 버튼 패밀리.

> [!warning] 속성 세부사항 일부는 외부 지식(Tier 3). 코드 예시는 `lwc-recipes-main` (Tier 1).

---

## lightning-button *(가장 기본 버튼)*

```html
<!-- 기본 브랜드 버튼 -->
<lightning-button
    label="저장"
    variant="brand"
    onclick={handleSave}
></lightning-button>

<!-- 아이콘 포함 버튼 -->
<lightning-button
    label="추가"
    variant="brand"
    icon-name="utility:add"
    icon-position="left"
    onclick={handleAdd}
></lightning-button>

<!-- 비활성 버튼 -->
<lightning-button
    label="처리 중..."
    variant="brand"
    disabled={isLoading}
></lightning-button>

<!-- 폼 제출 버튼 (record-edit-form 내부에서) -->
<lightning-button
    type="submit"
    label="저장"
    variant="brand"
></lightning-button>
```

### variant 목록

| variant | 설명 | 사용 예 |
|---|---|---|
| `base` | 링크 스타일 (테두리 없음) | 보조 액션 |
| `neutral` | 기본 회색 테두리 버튼 | 기본 액션 |
| `brand` | 파란색 채운 버튼 | 주요 액션 |
| `brand-outline` | 파란색 테두리만 | 보조 주요 액션 |
| `destructive` | 빨간색 채운 버튼 | 삭제·위험 액션 |
| `destructive-text` | 빨간 텍스트, 테두리 없음 | 보조 삭제 |
| `inverse` | 흰색 (어두운 배경용) | 어두운 배경 위 |
| `success` | 녹색 채운 버튼 | 완료·저장 |

### 속성

| 속성 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `label` | string | — | 버튼 텍스트 |
| `variant` | string | `neutral` | 스타일 variant |
| `type` | string | `button` | `button` / `submit` / `reset` |
| `icon-name` | string | — | 버튼 내 아이콘 (예: `utility:save`) |
| `icon-position` | string | `left` | `left` / `right` |
| `disabled` | boolean | `false` | 비활성화 |
| `name` | string | — | 폼 필드 이름 |
| `value` | string | — | 폼 필드 값 |
| `title` | string | — | 툴팁 텍스트 |
| `aria-label` | string | — | 접근성 레이블 |

---

## lightning-button-icon *(아이콘만 있는 버튼)*

```html
<!-- 기본 아이콘 버튼 -->
<lightning-button-icon
    icon-name="utility:edit"
    variant="border"
    alternative-text="편집"
    onclick={handleEdit}
></lightning-button-icon>

<!-- 삭제 아이콘 버튼 *(lwc-recipes-main/graphqlMutationDelete — Tier 1)* -->
<lightning-button-icon
    icon-name="utility:delete"
    alternative-text="Delete"
    onclick={handleDeleteContact}
    data-id={contact.Id}
    data-name={contact.Name}
></lightning-button-icon>
```

### button-icon variant

| variant | 설명 |
|---|---|
| `bare` | 테두리 없음, 배경 없음 |
| `container` | 정사각형 배경 |
| `brand` | 파란 채운 원 |
| `border` | 테두리 있는 정사각형 |
| `border-filled` | 테두리 + 채운 배경 |
| `border-inverse` | 흰색 아이콘, 어두운 배경 |
| `inverse` | 흰색 아이콘 |

### button-icon 속성

| 속성 | 타입 | 설명 |
|---|---|---|
| `icon-name` | string | SLDS 아이콘 이름 (필수) |
| `alternative-text` | string | 접근성 대체 텍스트 (필수) |
| `variant` | string | 스타일 variant |
| `size` | string | `xx-small` / `x-small` / `small` / `medium` / `large` |
| `disabled` | boolean | 비활성화 |
| `tooltip` | string | 마우스 오버 툴팁 |

---

## lightning-button-group *(버튼 그룹)*

버튼들을 붙여서 그룹으로 표시한다.

```html
<lightning-button-group>
    <lightning-button label="이전" icon-name="utility:chevronleft" icon-position="left"></lightning-button>
    <lightning-button label="다음" icon-name="utility:chevronright" icon-position="right"></lightning-button>
</lightning-button-group>
```

---

## lightning-button-menu *(드롭다운 메뉴 버튼)*

```html
<lightning-button-menu
    label="Actions"
    variant="border"
    icon-name="utility:down"
    onselect={handleMenuSelect}
>
    <lightning-menu-item value="edit"   label="수정"></lightning-menu-item>
    <lightning-menu-item value="clone"  label="복제"></lightning-menu-item>
    <lightning-menu-divider></lightning-menu-divider>
    <lightning-menu-item value="delete" label="삭제" prefix-icon-name="utility:delete"></lightning-menu-item>
</lightning-button-menu>
```

```javascript
handleMenuSelect(event) {
    const selectedValue = event.detail.value; // 'edit' | 'clone' | 'delete'
    switch (selectedValue) {
        case 'edit':   this.handleEdit();   break;
        case 'clone':  this.handleClone();  break;
        case 'delete': this.handleDelete(); break;
    }
}
```

### button-menu 주요 속성

| 속성 | 타입 | 설명 |
|---|---|---|
| `label` | string | 버튼 텍스트 |
| `variant` | string | `bare` / `container` / `border` / `border-filled` / `bare-inverse` / `border-inverse` |
| `icon-name` | string | 드롭다운 아이콘 |
| `menu-alignment` | string | `left`(기본) / `center` / `right` / `bottom-left` / `bottom-center` / `bottom-right` |
| `is-loading` | boolean | 로딩 스피너 표시 |
| `is-draft` | boolean | 초안 상태 표시 (점 표시기) |

### lightning-menu-item 속성

| 속성 | 타입 | 설명 |
|---|---|---|
| `value` | string | onselect에서 받는 값 |
| `label` | string | 표시 텍스트 |
| `prefix-icon-name` | string | 왼쪽 아이콘 |
| `suffix-icon-name` | string | 오른쪽 아이콘 |
| `checked` | boolean | 체크 표시 |
| `disabled` | boolean | 비활성화 |
| `href` | string | 링크 URL (버튼이 아닌 링크로 동작) |

---

## lightning-button-stateful *(토글 버튼)*

두 가지 상태(on/off)를 토글하는 버튼.

```html
<lightning-button-stateful
    selected={isFollowing}
    label-when-off="Follow"
    label-when-on="Following"
    label-when-hover="Unfollow"
    icon-name-when-off="utility:add"
    icon-name-when-on="utility:check"
    icon-name-when-hover="utility:close"
    onclick={handleToggleFollow}
></lightning-button-stateful>
```

```javascript
isFollowing = false;

handleToggleFollow() {
    this.isFollowing = !this.isFollowing;
}
```

---

## 이벤트

| 이벤트 | 컴포넌트 | 설명 |
|---|---|---|
| `click` | 모든 버튼 | 클릭 시 |
| `focus` | 모든 버튼 | 포커스 획득 |
| `blur` | 모든 버튼 | 포커스 이탈 |
| `select` | `button-menu` | 메뉴 항목 선택 (`event.detail.value`) |
| `open` | `button-menu` | 드롭다운 열림 |
| `close` | `button-menu` | 드롭다운 닫힘 |

---

## 접근성 (Accessibility)

- `lightning-button-icon`에는 반드시 `alternative-text`를 제공 — 스크린리더용 텍스트
- `aria-label`: 레이블이 시각적으로 없는 경우 추가
- `aria-haspopup="true"`: 팝업을 트리거하는 버튼에 지정 (예: 모달 여는 버튼)
- `disabled` 속성은 `aria-disabled="true"`로도 자동 적용됨

---


---

## 전체 공식 속성 명세 (cx-router · Tier 2)

> Salesforce 공식 cx-router 메타데이터에서 추출한 전체 속성·메서드·이벤트·슬롯 명세입니다(Tier 2). 위 예제·패턴은 기존 lwc-recipes Tier 1 큐레이션입니다.


### lightning-button

지원 상태: **GA** · 최소 API 버전: 0.0

#### 속성 (Attributes) — 10개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `disable-animation` |  |  |  | Reserved for internal use. If present, disables button animation. |
| `icon-name` | string |  |  | The Lightning Design System name of the icon. Names are written in the format 'utility:down' where 'utility' is the category, and 'down' i… |
| `icon-position` | string |  | left | Describes the position of the icon with respect to the button label. Options include left and right. This value defaults to left. |
| `label` | string |  |  | The text to be displayed inside the button. |
| `name` | string |  |  | The name for the button element. This value is optional and can be used to identify the button in a callback. |
| `stretch` | boolean |  | false | Setting it to true allows the button to take up the entire available width. This value defaults to false. |
| `tab-index` | number |  |  | Reserved for internal use only. Use the global tabindex attribute instead. Set tab index to -1 to prevent focus on the button during tab n… |
| `type` | string |  | button | Specifies the type of button. Valid values are button, reset, and submit. This value defaults to button. |
| `value` | string |  |  | The value for the button element. This value is optional and can be used when submitting a form. |
| `variant` | string |  | neutral | The variant changes the appearance of the button. Accepted variants include base, neutral, brand, brand-outline, destructive, destructive-… |

#### 메서드 (Methods) — 2개

| 메서드 | 설명 |
|---|---|
| `click` | Simulates a mouse click on the button. |
| `focus` | Sets focus on the button. |

### lightning-button-icon

지원 상태: **GA** · 최소 API 버전: 0.0

#### 속성 (Attributes) — 12개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `alternative-text` | string |  |  | The alternative text used to describe the icon. This text should describe what happens when you click the button, for example 'Upload File… |
| `disable-alternative-text-title` | boolean |  | false | Reserved for internal use only. Disables the alternative text being used for the button title when the title has not been provided. |
| `icon-class` | string |  |  | The class to be applied to the contained icon element. Only Lightning Design System utility classes are currently supported. |
| `icon-name` | string | ✔ |  | The Lightning Design System name of the icon. Names are written in the format 'utility:down' where 'utility' is the category, and 'down' i… |
| `name` | string |  |  | The name for the button element. This value is optional and can be used to identify the button in a callback. |
| `size` | string |  | medium | The size of the button-icon. For the bare variant, options include x-small, small, medium, and large. For non-bare variants, options inclu… |
| `tab-index` | number |  |  | Reserved for internal use only. Use the global tabindex attribute instead. Set tab index to -1 to prevent focus on the button during tab n… |
| `tooltip` | string |  |  | Text to display when the user mouses over or focuses on the button. The tooltip is auto-positioned relative to the button and screen space. |
| `tooltip-type` | string |  | info | Reserved for internal use only. Specifies the type of tooltip to be used. Use info in cases where target already has click handlers. Use t… |
| `type` | string |  | button | Specifies the type of button. Valid values are button, reset, and submit. This value defaults to button. |
| `value` | string |  |  | The value for the button element. This value is optional and can be used when submitting a form. |
| `variant` | string |  | border | The variant changes the appearance of button-icon. Accepted variants include bare, container, brand, border, border-filled, bare-inverse, … |

#### 메서드 (Methods) — 2개

| 메서드 | 설명 |
|---|---|
| `click` | Simulates a mouse click on the button. |
| `focus` | Sets focus on the button. |

### lightning-button-icon-stateful

지원 상태: **GA** · 최소 API 버전: 41.0

#### 속성 (Attributes) — 8개

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

#### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `focus` | Sets focus on the button. |

### lightning-button-menu

지원 상태: **GA** · 최소 API 버전: 0.0

#### 속성 (Attributes) — 19개

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

#### 메서드 (Methods) — 2개

| 메서드 | 설명 |
|---|---|
| `click` | Simulates a mouse click on the button. |
| `focus` | Sets focus on the button. |

#### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for menu-item |

### lightning-button-group

지원하는 **속성(attributes) · 메서드(methods) · 이벤트(events) · 슬롯(slots)** 전체 목록은 공식 **Specification** 탭에서 확인하세요. (해당 표는 인터랙티브 페이지에서 렌더링됩니다.)

### lightning-button-stateful

지원 상태: **GA** · 최소 API 버전: 0.0

#### 속성 (Attributes) — 10개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `disabled` |  |  |  | Passthrough to pass disabled attribute onto button |
| `group-order` | string |  |  | Reserved for internal use only. Describes the order of this element (first, middle or last) inside lightning-button-group. |
| `icon-name-when-hover` | string |  |  | The name of the icon to be used in the format 'utility:close' when the state is true and the button receives focus. |
| `icon-name-when-off` | string |  |  | The name of the icon to be used in the format 'utility:add' when the state is false. |
| `icon-name-when-on` | string |  |  | The name of the icon to be used in the format 'utility:check' when the state is true. |
| `label-when-hover` | string |  |  | The text to be displayed inside the button when state is true and the button receives focus. |
| `label-when-off` | string | ✔ |  | The text to be displayed inside the button when state is false. |
| `label-when-on` | string | ✔ |  | The text to be displayed inside the button when state is true. |
| `selected` | boolean |  | false | If present, the button is in the selected state. |
| `variant` | string |  | neutral | The variant changes the appearance of the button. Accepted variants include brand, destructive, inverse, neutral, success, and text. |

#### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `focus` | Sets focus on the button. |

### lightning-menu-item

지원 상태: **GA** · 최소 API 버전: 0.0

#### 속성 (Attributes) — 14개

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

### lightning-menu-divider

지원 상태: **GA** · 최소 API 버전: 0.0

#### 속성 (Attributes) — 1개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `variant` | string |  | standard | The variant changes the spacing above and below the divider. Accepted variants include standard and compact. The compact variant decreases… |

### lightning-menu-subheader

지원 상태: **GA** · 최소 API 버전: 0.0

#### 속성 (Attributes) — 1개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `label` | string |  |  | The text displayed in the subheader. |
## 관련 노트

- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 목록
- [[lightning-modal]] — 모달 여는 버튼 패턴
- [[Toast & 모달 패턴]] — 버튼 클릭으로 토스트 발생 패턴
