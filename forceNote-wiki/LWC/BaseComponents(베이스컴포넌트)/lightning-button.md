---
tags: [lwc, base-component, button, reference]
source: TrailheadApp/lwc-recipes-main (Tier 1) + cx-router 메타데이터 (Tier 2) + external-knowledge (Tier 3)
created: 2026-05-17
aliases: [lightning-button, 버튼, 표준 버튼, 버튼 패밀리, button family]
---

# lightning-button (표준 버튼 + 버튼 패밀리 허브)

> 표준 `lightning-button` 레퍼런스이자, 버튼 변형 패밀리(아이콘·토글·그룹·메뉴)로의 진입 허브.

> [!warning] 표준 버튼 속성 일부는 외부 지식(Tier 3). 코드 예시는 `lwc-recipes-main` (Tier 1). 공식 전체 명세는 cx-router 메타데이터(Tier 2).

---

## 버튼 패밀리 — 어느 컴포넌트를 쓰나 (선택 가이드)

| 상황 | 컴포넌트 | 전용 노트 |
|---|---|---|
| 텍스트 레이블 버튼 (선택적 아이콘 포함) | `lightning-button` | **이 노트 (아래 본문)** |
| 아이콘만 있는 버튼 (레이블 없음) | `lightning-button-icon` | [[lightning-button-icon]] |
| 아이콘 버튼의 on/off 토글 상태 | `lightning-button-icon-stateful` | [[lightning-button-icon-stateful]] |
| 텍스트 버튼의 on/off 토글 상태 (Follow/Following 등) | `lightning-button-stateful` | [[lightning-button-stateful]] |
| 버튼 여러 개를 시각적으로 붙여 그룹화 | `lightning-button-group` | [[lightning-button-group]] |
| 드롭다운 메뉴 버튼 (menu-item/divider/subheader 포함) | `lightning-button-menu` | [[lightning-button-menu]] |

> 변형 버튼의 속성·메서드·이벤트·슬롯 전체 명세와 코드 예시는 위 전용 노트에 있습니다. 이 노트는 표준 `lightning-button`만 상세히 다룹니다.

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

## 변형 버튼 — 전용 노트로 이동

아래 변형 버튼의 코드 예시·속성표·메서드는 각 전용 노트에 전부 들어 있습니다.

- **아이콘만 있는 버튼** → [[lightning-button-icon]]
- **아이콘 토글 버튼** → [[lightning-button-icon-stateful]]
- **텍스트 토글 버튼** (Follow/Following 등) → [[lightning-button-stateful]]
- **버튼 그룹** (`lightning-button-group`으로 버튼을 붙여 표시) → [[lightning-button-group]]
- **드롭다운 메뉴 버튼** (`menu-item` / `menu-divider` / `menu-subheader` 자식 포함) → [[lightning-button-menu]]

---

## 이벤트 (lightning-button)

| 이벤트 | 설명 |
|---|---|
| `click` | 클릭 시 |
| `focus` | 포커스 획득 |
| `blur` | 포커스 이탈 |

> 변형 버튼 고유 이벤트(예: `lightning-button-menu`의 `select` / `open` / `close`)는 해당 전용 노트 참조.

---

## 접근성 (Accessibility) — 버튼 공통

- 시각적 레이블이 없는 버튼에는 `aria-label`을 추가 (아이콘 버튼은 `alternative-text` — [[lightning-button-icon]] 참조).
- `aria-haspopup="true"`: 팝업을 트리거하는 버튼에 지정 (예: 모달 여는 버튼).
- `disabled` 속성은 `aria-disabled="true"`로도 자동 적용됨.

---

## 전체 공식 속성 명세 — lightning-button (cx-router · Tier 2)

> Salesforce 공식 cx-router 메타데이터에서 추출한 `lightning-button` 전체 명세입니다(Tier 2). 위 예제·패턴은 기존 lwc-recipes Tier 1 큐레이션입니다. 변형 버튼의 공식 명세는 각 전용 노트에 동일 형식으로 보존되어 있습니다.

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

---

## 관련 노트

- [[lightning-button-icon]] — 아이콘 전용 버튼
- [[lightning-button-icon-stateful]] — 아이콘 토글 버튼
- [[lightning-button-stateful]] — 텍스트 토글 버튼
- [[lightning-button-group]] — 버튼 그룹
- [[lightning-button-menu]] — 드롭다운 메뉴 버튼 (menu-item/divider/subheader 포함)
- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 목록
- [[lightning-modal]] — 모달 여는 버튼 패턴
- [[Toast & 모달 패턴]] — 버튼 클릭으로 토스트 발생 패턴
