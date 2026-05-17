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

## 관련 노트

- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 목록
- [[lightning-modal]] — 모달 여는 버튼 패턴
- [[Toast & 모달 패턴]] — 버튼 클릭으로 토스트 발생 패턴
