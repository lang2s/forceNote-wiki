---
tags: [lwc, accessibility, a11y, aria, focus, keyboard, screen-reader, ui-pattern]
source: developer.salesforce.com (LWC Developer Guide — Accessibility Attributes(create-components-accessibility-attributes) + Base Components Accessibility(base-components-accessibility) + Handle Focus, 라이브 공식 문서 Tier 2, 접속 2026-07-08) + lightningdesignsystem.com (Accessibility · Global Focus · Keyboard Interaction, SLDS 2, Tier 2)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/create-components-accessibility-attributes.html
created: 2026-07-08
aliases: [LWC accessibility pattern, 접근성 패턴, a11y pattern, alternative-text, aria-live, role status, slds-assistive-text, visually hidden, focus trap, 포커스 트랩, roving tabindex, keyboard handling, 키보드 처리, aria reflection, ariaLabel, ariaPressed, label for, lightning-helptext, screen reader live region, 스크린리더]
---

# LWC 접근성 패턴 (Accessibility Patterns)

> 실무에서 자주 쓰는 LWC 접근성 패턴 모음 — 아이콘/이미지 대체텍스트, `aria-*` 속성 바인딩·reflection, 포커스 관리(모달 포커스 트랩·roving tabindex), 키보드 핸들링(Enter/Space), 시맨틱 HTML·레이블 연결, 스크린리더 라이브 리전(`aria-live`·`role="status"`·`slds-assistive-text`). ARIA reflection의 개념 원리는 [[컴포넌트 접근성 (ARIA·label)]]에서 다루며, 이 노트는 그 원리를 화면 패턴으로 적용한다.

---

## 0. 우선순위 — base component가 접근성을 이미 갖고 있다

직접 ARIA를 다루기 전에, **`lightning-*` base component**는 최신 ARIA 표준·SLDS Blueprint에 맞춰 작성돼 접근성이 내장돼 있다. 커스텀 마크업보다 base component를 우선한다.

| 요구 | 우선 선택 |
|---|---|
| 입력 필드 | `lightning-input`(연관 label 자동 렌더) |
| 버튼 | `lightning-button` / `lightning-button-icon`(`alternative-text` 필수) |
| 아이콘 | `lightning-icon`(`alternative-text` 또는 장식이면 생략) |
| 도움말 툴팁 | `lightning-helptext`(`role="tooltip"` + `aria-describedby` 자동) |
| 폼 세트 | `lightning-record-edit-form` / `lightning-input`들 |

커스텀 마크업이 불가피할 때만 아래 패턴으로 직접 접근성을 부여한다.

---

## 1. 아이콘·이미지 대체텍스트 (alternative-text)

정보를 전달하는 아이콘/이미지에는 대체텍스트가 필요하다(WCAG 1.1.1 non-text content). **아이콘의 생김새가 아니라 기능**을 쓴다 — "Paperclip"이 아니라 "Upload File".

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<template>
    <!-- 정보성 아이콘: alternative-text로 기능을 설명 (스크린리더가 읽음) -->
    <lightning-icon icon-name="utility:upload"
                    alternative-text="Upload File"></lightning-icon>

    <!-- 아이콘 버튼: alternative-text가 접근 가능한 이름을 제공 -->
    <lightning-button-icon icon-name="utility:delete"
                           alternative-text="Delete row"
                           onclick={handleDelete}></lightning-button-icon>

    <!-- 장식용 아이콘: 의미가 없으면 alternative-text를 생략하고 aria-hidden으로 보조기술에서 숨김 -->
    <lightning-icon icon-name="utility:divider" aria-hidden="true"></lightning-icon>
</template>
```

> ⚠️ 아이콘은 화면 크기에 따라 **장식↔정보** 성격이 바뀔 수 있다. `alternative-text`를 생략하려면 작은 화면·창에서도 그 아이콘이 정말 장식용인지 확인한다.

일반 `<img>`에는 `alt` 속성을 쓴다 — 정보성이면 설명, 순수 장식이면 `alt=""`(빈 문자열)로 스크린리더가 건너뛰게 한다.

---

## 2. aria-* 속성 바인딩과 reflection

### 템플릿에서 aria-* 바인딩

HTML 표준 `aria-*` 속성은 템플릿에서 값 바인딩으로 직접 걸 수 있다.

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<template>
    <!-- 토글 버튼: 눌림 상태를 aria-pressed로 스크린리더에 전달 -->
    <button aria-pressed={isActive}
            aria-label="Toggle favorite"
            onclick={toggle}>★</button>

    <!-- 확장/축소: aria-expanded로 상태 알림 -->
    <button aria-expanded={isOpen} onclick={toggleSection}>Details</button>
</template>
```

### JS accessor는 camel-case (ARIA reflection)

커스텀 컴포넌트가 `aria-*`를 public 속성으로 노출할 때, JavaScript accessor는 **camel-case**를 쓴다. 공식 매핑:

| HTML 속성 | JS 프로퍼티 |
|---|---|
| `aria-label` | `ariaLabel` |
| `aria-pressed` | `ariaPressed` |
| `aria-describedby` | `ariaDescribedby` |
| `aria-details` | `ariaDetails` |
| `aria-owns` | `ariaOwns` |

전체 목록은 LWC GitHub `packages/@lwc/aria-reflection`. public 속성으로 노출하면 값이 HTML에 자동 반영되지 않으므로, getter/setter + `setAttribute()`로 렌더된 HTML에 reflect한다.

```js
// 구조 예시 — 실제 동작 코드 아님
import { LightningElement, api } from 'lwc';

export default class MyToggle extends LightningElement {
    @api
    get ariaPressed() { return this._pressed; }
    set ariaPressed(v) {
        this._pressed = v;
        this.setAttribute('aria-pressed', v); // 렌더된 HTML 속성에 reflect
    }
    _pressed = 'false';
}
```

> ⚠️ `id`↔ARIA 링크 주의: 템플릿 렌더 시 `id`가 globally unique 값으로 변환된다. `aria-describedby` 등에서 **static `id`를 하드코딩하지 말고** `class`/`data-*`로 요소를 잡는다. 개념·shadow DOM 제약은 [[컴포넌트 접근성 (ARIA·label)]] 참조.

---

## 3. 시맨틱 HTML·레이블 연결

가능하면 `<div>`/`<span>` 대신 native 요소(`<button>`·`<a>`·`<input>`·`<nav>`·`<ul>`)를 쓴다 — 접근성 역할·키보드 동작이 공짜로 따라온다. ARIA는 native 요소로 표현 못 하는 것을 보충할 때만.

### label 연결 3가지

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<template>
    <!-- (A) base component: label 속성이 자동으로 연관 label 렌더 -->
    <lightning-input label="Email" type="email"></lightning-input>

    <!-- (B) 커스텀 input: label for ↔ input id 로 명시적 연결
         (LWC가 id를 변환해도 같은 템플릿 내 for↔id는 유지된다) -->
    <label for="qty-input">Quantity</label>
    <input id="qty-input" type="number" />

    <!-- (C) 보이는 label을 못 둘 때만 aria-label (스크린리더 전용, 화면 표시 안 됨) -->
    <button aria-label="Close dialog" onclick={close}>×</button>
</template>
```

> ⚠️ base component에 이미 `label`이 있으면 `aria-label`은 불필요·중복이다. `placeholder`는 label 대용이 될 수 없다(포커스/입력 시 사라짐).

### 도움말 텍스트 — lightning-helptext

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<!-- role="tooltip" + aria-describedby 를 자동 렌더, alternative-text로 트리거 설명 -->
<lightning-helptext content="Enter your billing email"
                    alternative-text="Show help text"></lightning-helptext>
```

---

## 4. 키보드 핸들링 (keydown · Enter/Space · roving tabindex)

마우스로 되는 모든 동작은 키보드만으로도 돼야 한다. native `<button>`은 Enter/Space 활성화가 자동이지만, `role="button"`을 붙인 `<div>`는 직접 처리해야 한다.

```js
// 구조 예시 — 실제 동작 코드 아님
export default class ClickableCard extends LightningElement {
    handleKeyDown(event) {
        // Enter 또는 Space가 활성화 (native button 재현)
        if (event.key === 'Enter' || event.key === ' ') {
            event.preventDefault(); // Space의 페이지 스크롤 방지
            this.activate();
        }
    }
    activate() { /* 클릭과 동일 로직 */ }
}
```

`role="button"` + `tabindex="0"` + `onclick` + `onkeydown` 3(4)종 세트는 [[컴포넌트 접근성 (ARIA·label)]]에서 상세히 다룬다.

### roving tabindex — 리스트/툴바/탭 그룹의 화살표 이동

메뉴·탭·툴바처럼 항목이 여럿인 위젯은 **모든 항목을 tab 순서에 넣지 않는다.** 활성 항목 하나만 `tabindex="0"`, 나머지는 `tabindex="-1"`로 두고, **화살표 키로 활성 항목을 옮긴다**(roving tabindex). Tab 한 번에 그룹 진입 → 화살표로 내부 이동 → Tab으로 그룹 탈출.

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<template>
    <ul role="tablist" onkeydown={handleArrows}>
        <template for:each={tabs} for:item="t">
            <li key={t.id}
                role="tab"
                data-id={t.id}
                tabindex={t.tabindex}     
                aria-selected={t.selected}>{t.label}</li>
        </template>
    </ul>
</template>
```

```js
// 구조 예시 — 실제 동작 코드 아님
handleArrows(event) {
    if (event.key !== 'ArrowRight' && event.key !== 'ArrowLeft') return;
    const dir = event.key === 'ArrowRight' ? 1 : -1;
    this.activeIndex = (this.activeIndex + dir + this.tabs.length) % this.tabs.length;
    // 활성 항목만 tabindex 0, 나머지 -1로 갱신한 뒤 실제 DOM 요소에 포커스 이동
    const items = this.template.querySelectorAll('[role="tab"]');
    items[this.activeIndex].focus();
}
```

SLDS 컴포넌트별 키 패턴(Combobox·Menu·Tabs·Data Grid의 화살표/Enter/Esc)은 [[SLDS 접근성]] "키보드 인터랙션" 참조.

---

## 5. 포커스 관리 (focus · renderedCallback · 모달 포커스 트랩)

프로그래밍적 포커스 이동이 필요한 시점: **모달 열기/닫기, 폼 오류, 동적 콘텐츠 갱신**.

### 요소에 포커스 주기

```js
// 구조 예시 — 실제 동작 코드 아님
// 렌더 이후에 포커스해야 요소가 DOM에 존재한다
renderedCallback() {
    if (this._shouldFocus) {
        this._shouldFocus = false;
        this.template.querySelector('[data-id="first-field"]')?.focus();
    }
}
```

> ⚠️ `renderedCallback`은 여러 번 호출된다 — 한 번만 포커스하도록 플래그로 가드한다. base component 포커스는 그 컴포넌트의 `focus()` public 메서드(예: `lightning-input`)를 호출한다.

### 모달 포커스 트랩

모달이 열리면 포커스는 모달 안에 갇혀야 하고, Tab이 마지막 요소를 지나면 첫 요소로 순환, Esc로 닫고, **닫을 때 트리거 요소로 포커스 복귀**한다.

```js
// 구조 예시 — 실제 동작 코드 아님
open() {
    this._trigger = this.template.activeElement; // 복귀용 트리거 저장
    this.isOpen = true;
    this._shouldFocus = true;                    // renderedCallback에서 첫 요소 포커스
}

handleModalKeyDown(event) {
    if (event.key === 'Escape') { this.close(); return; }
    if (event.key !== 'Tab') return;
    // 모달 내 focusable 요소 목록으로 Tab 순환(트랩)
    const focusables = [...this.template.querySelectorAll(
        'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    )];
    const first = focusables[0];
    const last = focusables[focusables.length - 1];
    const active = this.template.activeElement;
    if (event.shiftKey && active === first) { event.preventDefault(); last.focus(); }
    else if (!event.shiftKey && active === last) { event.preventDefault(); first.focus(); }
}

close() {
    this.isOpen = false;
    this._trigger?.focus(); // 트리거로 포커스 복귀 (포커스 유실 방지)
}
```

**모달 초기 포커스 결정(SLDS 4단계):** ① 멀티스텝 → 스텝 부제(`tabindex="-1"`) ② 제목 있는 표준 모달 → 제목 ③ 제목 없음 → 본문 첫 인터랙티브 요소 ④ 그 외 → 닫기 버튼. 상세는 [[SLDS 접근성]]. 모달 UI 구현은 [[Toast & 모달 패턴]].

---

## 6. 스크린리더 알림 — 라이브 리전 & visually-hidden

화면에 새 상태(저장 완료, 검색 결과 n건, 오류)가 나타나도 **스크린리더는 자동으로 읽지 않는다.** 라이브 리전으로 변화를 알린다.

| 방법 | 용도 | 끼어듦 |
|---|---|---|
| `aria-live="polite"` / `role="status"` | 상태 알림(저장됨, 결과 수) | 진행 중 발화가 끝나면 읽음 |
| `aria-live="assertive"` / `role="alert"` | 긴급 오류·경고 | 즉시 끼어들어 읽음 |

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<template>
    <!-- 라이브 리전은 처음부터 DOM에 존재하고, 내용만 갱신해야 안정적으로 읽힌다.
         slds-assistive-text: 시각적으로 숨기되 스크린리더에는 노출(visually-hidden) -->
    <div aria-live="polite" role="status" class="slds-assistive-text">
        {statusMessage}   <!-- 예: "3 results found" -->
    </div>

    <!-- 긴급 오류는 assertive -->
    <div aria-live="assertive" role="alert" class="slds-assistive-text">
        {errorMessage}
    </div>
</template>
```

- **`slds-assistive-text`** — SLDS 유틸리티 클래스. 요소를 화면에서 시각적으로 감추되 접근성 트리에는 남겨 스크린리더가 읽게 하는 표준 visually-hidden 패턴. 보이는 라벨을 둘 수 없는 아이콘 버튼 등의 텍스트 대안으로도 쓴다.
- ⚠️ 라이브 리전 요소를 나중에 조건부로 새로 삽입하면 일부 스크린리더가 놓친다 — **리전은 미리 렌더**하고 **내부 텍스트만 갱신**한다.
- 폼 오류는 오류 메시지로 포커스를 옮기거나(§5) `aria-describedby`로 필드에 연결 + `aria-invalid="true"`를 함께 준다.

---

## 7. 체크리스트 (출시 전)

- [ ] 정보성 아이콘/이미지에 `alternative-text`/`alt`, 장식은 `aria-hidden`/`alt=""`
- [ ] 모든 인터랙티브 요소에 접근 가능한 이름(label·aria-label)
- [ ] 마우스 동작이 전부 키보드로 가능 (Tab 도달 + Enter/Space 활성화)
- [ ] 색만으로 정보 전달하지 않음, 대비 본문 4.5:1 / 큰 글자 3:1 이상 ([[SLDS 접근성]])
- [ ] 모달: 포커스 트랩 + Esc + 닫을 때 트리거 복귀
- [ ] 상태 변화는 `aria-live`/`role="status|alert"`로 알림
- [ ] 스크린리더(VoiceOver/NVDA)로 실제 통과 테스트

---

## 관련 노트
- [[컴포넌트 접근성 (ARIA·label)]] — ARIA reflection·기본 ARIA·role 고정·delegatesFocus 개념 원리
- [[SLDS 접근성]] — WCAG AA 기준·색 대비·키보드 인터랙션·모달 초기 포커스 4단계
- [[Toast & 모달 패턴]] — 모달/토스트 UI 구현(포커스 트랩 적용 대상)
- [[에러 패널 패턴]] — 오류 표시 UI(라이브 리전·aria-invalid 연계)
- [[Lightning Base Components 레퍼런스]] — 접근성 내장 base component 목록
- [[LWC MOC]]
