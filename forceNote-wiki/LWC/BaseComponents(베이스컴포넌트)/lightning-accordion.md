---
tags: [lwc, base-component, accordion, layout, reference]
source: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/components.html
created: 2026-05-17
aliases: [accordion, 아코디언, lightning-accordion-section]
---

# lightning-accordion

> 여러 콘텐츠 영역을 수직으로 쌓아 접고 펼칠 수 있는 컨테이너. 섹션 헤더를 클릭하면 내용이 확장된다.

> [!info] 출처: Salesforce 공식 컴포넌트 레퍼런스 (Tier 2)

---

## 사용 가능 환경

Lightning Experience, Experience Builder Sites, Salesforce Mobile App, Lightning Out (Beta), Standalone Lightning App, Mobile Offline

---

## 개요

`lightning-accordion`은 섹션 헤더를 클릭해 내용을 펼치거나 접을 수 있는 수직 스택 레이아웃을 제공한다. 한 섹션을 열면 다른 섹션이 닫히도록 제어할 수 있고, `allow-multiple-sections-open` 속성으로 여러 섹션을 동시에 열 수 있다.

각 섹션은 `lightning-accordion-section` 컴포넌트로 구성하며, 내부에 HTML 마크업이나 Lightning 컴포넌트를 넣을 수 있다.

> [!note] **lazy loading 미지원** — 초기에 접혀 있는 섹션의 콘텐츠도 페이지 로드 시 DOM에 포함된다. 비활성 섹션이 페이지 로드 시간에 영향을 줄 수 있다.

---

## 기본 사용 — 단일 섹션 열기

첫 번째 섹션이 기본으로 펼쳐진다. `active-section-name` 속성에 섹션 이름을 지정하면 해당 섹션이 기본으로 열린다. **섹션 이름은 대소문자를 구분한다.**

```html
<!-- 섹션 B가 기본으로 열린 아코디언 -->
<template>
    <lightning-accordion active-section-name="B">
        <lightning-accordion-section name="A" label="Accordion Title A">
            This is the content area for section A
        </lightning-accordion-section>
        <lightning-accordion-section name="B" label="Accordion Title B">
            This is the content area for section B
        </lightning-accordion-section>
        <lightning-accordion-section name="C" label="Accordion Title C">
            This is the content area for section C
        </lightning-accordion-section>
    </lightning-accordion>
</template>
```

> 같은 이름을 가진 섹션이 여러 개이고, 그 이름이 `active-section-name`으로 지정된 경우 첫 번째 섹션이 열린다.

---

## 여러 섹션 동시에 열기

`allow-multiple-sections-open` 속성을 추가하고, `active-section-name`에 섹션 이름 배열을 전달한다. 배열을 전달하지 않으면 모든 섹션이 닫힌 상태로 시작한다.

```html
<template>
    <lightning-accordion
        allow-multiple-sections-open
        active-section-name={activeSections}
    >
        <lightning-accordion-section name="A" label="Accordion Title A">
            <p>This is the content area for section A.</p>
        </lightning-accordion-section>
        <lightning-accordion-section name="B" label="Accordion Title B">
            <p>This is the content area for section B.</p>
        </lightning-accordion-section>
        <lightning-accordion-section name="C" label="Accordion Title C">
            <p>This is the content area for section C.</p>
        </lightning-accordion-section>
    </lightning-accordion>
</template>
```

```javascript
import { LightningElement } from 'lwc';

export default class AccordionMultiple extends LightningElement {
    activeSections = ['A', 'C']; // A와 C가 기본으로 열림
}
```

> [!note] 여러 섹션을 초기화할 때는 마크업만으로 불가능하다. JavaScript에서 배열을 전달해야 한다.

---

## sectiontoggle 이벤트 처리

섹션이 열리거나 닫힐 때 `sectiontoggle` 이벤트가 발생한다. `event.detail.openSections`로 현재 열린 섹션 이름을 받는다.

```html
<template>
    <p>{activeSectionsMessage}</p>
    <lightning-accordion
        allow-multiple-sections-open
        onsectiontoggle={handleSectionToggle}
        active-section-name="A"
    >
        <lightning-accordion-section name="A" label="Accordion Title A">
            <p>This is the content area for section A.</p>
        </lightning-accordion-section>
        <lightning-accordion-section name="B" label="Accordion Title B">
            <p>This is the content area for section B.</p>
        </lightning-accordion-section>
        <lightning-accordion-section name="C" label="Accordion Title C">
            <p>This is the content area for section C.</p>
        </lightning-accordion-section>
    </lightning-accordion>
</template>
```

```javascript
import { LightningElement } from 'lwc';

export default class AccordionSectionToggle extends LightningElement {
    activeSectionsMessage = '';

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage = 'Open sections: ' + openSections.join(', ');
        }
    }
}
```

**`openSections` 반환 타입:**
- `allow-multiple-sections-open` 있음 → **배열(string[])** 반환. 예: `['A']`, `['A', 'B']`
- `allow-multiple-sections-open` 없음 → **문자열(string)** 반환. 예: `'A'`
- name 속성이 없거나 빈 문자열인 섹션이 열린 경우 → 빈 배열 또는 `undefined` 반환

---

## 프로그래밍 방식으로 섹션 열기

JavaScript에서 `active-section-name` 바인딩 변수를 변경해 섹션을 열 수 있다.

```html
<template>
    <lightning-button label="Expand Section B" onclick={handleClick}>
    </lightning-button>
    <lightning-accordion
        active-section-name={section}
        onsectiontoggle={handleSectionToggle}
    >
        <lightning-accordion-section name="A" label="A">Content A</lightning-accordion-section>
        <lightning-accordion-section name="B" label="B">Content B</lightning-accordion-section>
        <lightning-accordion-section name="C" label="C">Content C</lightning-accordion-section>
    </lightning-accordion>
</template>
```

```javascript
import { LightningElement } from 'lwc';

export default class AccordionProgrammatic extends LightningElement {
    section = '';

    handleClick() {
        this.section = 'B';
    }

    handleSectionToggle(event) {
        // 사용자가 클릭해서 바꿔도 section 값을 동기화
        this.section = event.detail.openSections;
    }
}
```

**여러 섹션을 프로그래밍 방식으로 열기:**

```javascript
import { LightningElement } from 'lwc';

export default class AccordionProgrammaticMultiple extends LightningElement {
    section = [];

    handleClick() {
        this.section = ['B', 'C']; // B와 C를 동시에 열기
    }

    handleSectionToggle(event) {
        this.section = event.detail.openSections;
    }
}
```

---

## 중첩 아코디언

`lightning-accordion-section` 내부에 `lightning-accordion`을 중첩하면 다단계 아코디언을 만들 수 있다. 모든 수준에서 쉐브론(chevron) 아이콘이 사용된다.

---

## 컴포넌트 스타일링

SLDS 유틸리티 클래스를 `class` 속성에 적용해 추가 스타일을 줄 수 있다.

```html
<!-- 섹션 내용에 테두리와 회색 배경 추가 -->
<lightning-accordion active-section-name="A">
    <lightning-accordion-section name="A" label="Accordion Title A">
        <div class="slds-box slds-theme_shade">
            <p>This is the content area for section A.</p>
        </div>
    </lightning-accordion-section>
</lightning-accordion>
```

컴포넌트 스타일링 훅(`--slds-c-*` CSS 변수)은 SLDS 1에서만 지원된다.

---

## 사용 고려사항

- **여러 섹션 초기화**: 마크업만으로 불가, 반드시 JavaScript 배열을 사용한다.
- **DOM 즉시 로드**: 접혀 있는 섹션의 내용도 초기 로드 시 DOM에 있다. lazy loading 없음.
- Aura 버전과 사용법 차이 있음.

---

## 접근성 (Accessibility)

`lightning-accordion`은 SLDS 아코디언 블루프린트와 WAI-ARIA Authoring Practices를 따른다.

- 키보드 인터랙션에 **Left Arrow / Right Arrow** 키로 아코디언 헤더 간 포커스 이동 가능
- `Home` / `End` 키는 `lightning-accordion`에서 사용되지 않는다
- `lightning-accordion`에 `role="list"` 설정됨
- 활성(펼쳐진) 섹션의 헤더 버튼에 `aria-expanded="true"` 설정됨
- 접힌 섹션에 `aria-hidden="true"` 설정 → 보조 기술에서 내용 숨김

---

## 커스텀 이벤트

### `sectiontoggle`

아코디언이 활성 섹션과 함께 로드되거나 섹션이 토글될 때 발생.

**이벤트 파라미터:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `openSections` | `object` | 활성 섹션 이름. `allow-multiple-sections-open` 있으면 배열, 없으면 문자열 |

**이벤트 속성:**

| 속성 | 값 | 설명 |
|---|---|---|
| `bubbles` | `false` | 버블링 없음 |
| `cancelable` | `false` | `preventDefault()` 호출 불가 |
| `composed` | `false` | 템플릿 외부로 전파 안 됨 |

---

## 주요 속성

| 속성 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `active-section-name` | string \| string[] | 첫 번째 섹션 | 펼쳐질 섹션 이름(들) |
| `allow-multiple-sections-open` | boolean | `false` | 여러 섹션 동시 열기 허용 |

### lightning-accordion-section 속성

| 속성 | 타입 | 설명 |
|---|---|---|
| `name` | string | 섹션 고유 식별자 (대소문자 구분) |
| `label` | string | 섹션 헤더에 표시될 텍스트 |
| `actions` (slot) | — | 헤더 오른쪽에 표시될 액션 |

---

## 관련 노트

- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 빠른 선택 가이드
- [[lightning-tabset]] — 탭 방식 대안 레이아웃
- [[lightning-card]] — 아코디언 섹션 내 카드 컨테이너 활용
