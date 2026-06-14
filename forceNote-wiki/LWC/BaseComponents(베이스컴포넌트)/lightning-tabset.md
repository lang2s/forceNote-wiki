---
tags: [lwc, base-components, lightning-tabset, tabs, navigation, ui]
source: cx-router 메타데이터 (Tier 2) + external-knowledge (Tier 3)
created: 2026-05-22
aliases: [lightning-tabset, 탭셋, 탭 컨테이너]
---

# lightning-tabset

> [!warning] 상단 예제·설명은 외부 지식 기반(Tier 3)이며 공식 소스와 대조되지 않았습니다. 하단 `## 전체 공식 속성 명세`는 공식 cx-router 메타데이터(Tier 2)입니다.

> 여러 탭(lightning-tab)을 그룹화하는 컨테이너 컴포넌트 — 한 번에 하나의 탭 콘텐츠를 표시한다.

---

## 기본 사용

```html
<lightning-tabset>
    <lightning-tab label="탭 1" value="tab1">
        <p>탭 1 내용</p>
    </lightning-tab>
    <lightning-tab label="탭 2" value="tab2">
        <p>탭 2 내용</p>
    </lightning-tab>
</lightning-tabset>
```

---

## 주요 속성

### lightning-tabset

| 속성 | 타입 | 설명 |
|---|---|---|
| `active-tab-value` | String | 초기 선택 탭의 value |
| `variant` | String | `default` \| `scoped` \| `vertical` — 탭 스타일 |
| `selected-tab-value` | String | 현재 선택된 탭 value |

### lightning-tab

| 속성 | 타입 | 설명 |
|---|---|---|
| `label` | String | 탭 헤더에 표시되는 텍스트 |
| `value` | String | 탭 식별자 (고유해야 함) |
| `icon-name` | String | 탭 헤더 아이콘 (예: `utility:user`) |
| `show-error-indicator` | Boolean | 탭 헤더에 에러 표시 여부 |
| `is-loaded` | Boolean | 탭 콘텐츠가 DOM에 로드되었는지 |

---

## 이벤트 — ontabchange

```html
<lightning-tabset ontabchange={handleTabChange}>
    <lightning-tab label="계정" value="account">...</lightning-tab>
    <lightning-tab label="연락처" value="contact">...</lightning-tab>
</lightning-tabset>
```

```javascript
handleTabChange(event) {
    const selectedTabValue = event.target.value;
    console.log('선택된 탭:', selectedTabValue);
}
```

---

## Variant 비교

| variant | 설명 |
|---|---|
| `default` | 기본 탭 스타일 (상단 탭 헤더) |
| `scoped` | 박스 테두리가 있는 탭 |
| `vertical` | 세로 탭 배열 |

---

## 초기 활성 탭 지정

```html
<lightning-tabset active-tab-value="contact">
    <lightning-tab label="계정" value="account">...</lightning-tab>
    <lightning-tab label="연락처" value="contact">...</lightning-tab>
</lightning-tabset>
```

---


---

## 전체 공식 속성 명세 (cx-router · Tier 2)

> Salesforce 공식 cx-router 메타데이터에서 추출한 전체 속성·메서드·이벤트·슬롯 명세입니다(Tier 2). 위 예제·패턴은 기존 lwc-recipes Tier 1 큐레이션입니다.


### lightning-tabset

지원 상태: **GA** · 최소 API 버전: 44.0

#### 속성 (Attributes) — 6개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `active-tab-value` | string |  |  | Sets a specific tab to open by default using a string that matches a tab's value string. If not used, the first tab opens by default. |
| `heading-label` | string\|null |  |  | Specifies text to use as custom assistive text for the tabset heading. The text is placed in a div element with role="heading" and aria-le… |
| `heading-level` | number |  |  | Specifies the value to pass through to aria-level when you specify heading-label. Accepts values from 1 to 6. The default value is 2. |
| `heading-visible` | boolean |  |  | Determines whether the text that's passed with the heading-label attribute is visible above the tabset. This attribute isn't present by de… |
| `title` | string |  |  | Displays tooltip text when the mouse moves over the tabset. |
| `variant` | string |  |  | The variant changes the appearance of the tabset. Accepted variants are standard, scoped, and vertical. |

#### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `focus` | Focus currently selected tab. |

#### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for lightning-tab. |

### lightning-tab

지원 상태: **GA** · 최소 API 버전: 44.0

#### 속성 (Attributes) — 8개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `end-icon-alternative-text` | string |  |  | The alternative text for the icon specified by end-icon-name. |
| `end-icon-name` | string |  |  | The Lightning Design System name of an icon to display at the end of the tab label. Specify the name in the format 'utility:check' where '… |
| `icon-assistive-text` | string |  |  | The alternative text for the icon specified by icon-name. |
| `icon-name` | string |  |  | The Lightning Design System name of an icon to display at the beginning of the tab label. Specify the name in the format 'utility:down' wh… |
| `label` | string |  |  | The text displayed in the tab header. |
| `show-error-indicator` | boolean |  |  | Specifies whether there's an error in the tab content. An error icon is displayed to the right of the tab label. |
| `title` | string |  |  | Specifies text that displays in a tooltip over the tab content. |
| `value` | string |  |  | The optional string to identify which tab was clicked during the tab's active event. This string is also used by active-tab-value in tabse… |

#### 메서드 (Methods) — 1개

| 메서드 | 설명 |
|---|---|
| `load-content` | Reserved for internal use. |

#### 슬롯 (Slots) — 1개

| 슬롯 | 설명 |
|---|---|
| `default` | Placeholder for your content in lightning-tab. |
## 관련 노트

- [[lightning-tab]] — 탭셋 안에 배치하는 개별 탭 컴포넌트
- [[lightning-accordion]] — 펼치기/접기 패턴의 대안 컴포넌트
- [[lightning-card]] — 탭 내부에 카드 배치 패턴
