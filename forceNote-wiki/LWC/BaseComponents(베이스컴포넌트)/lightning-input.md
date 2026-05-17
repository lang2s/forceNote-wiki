---
tags: [lwc, base-component, input, form, reference]
source: TrailheadApp/lwc-recipes-main (Tier 1) + external-knowledge (Tier 3)
created: 2026-05-17
aliases: [lightning-input, 입력 컴포넌트, text input]
---

# lightning-input

> 텍스트, 숫자, 날짜, 이메일, 파일 등 다목적 입력 필드. `type` 속성 하나로 14가지 입력 유형을 전환한다.

> [!warning] 속성 목록은 외부 지식(Tier 3) 기반 — 공식 소스와 전수 대조되지 않았습니다. 코드 예시는 `lwc-recipes-main` (Tier 1).

---

## 사용 가능 환경

Lightning Experience, Experience Builder Sites, Salesforce Mobile App, Lightning Out (Beta), Standalone Lightning App

---

## 기본 사용 *(lwc-recipes-main/helloBinding — Tier 1)*

```html
<template>
    <lightning-card title="HelloBinding">
        <div class="slds-var-m-around_medium">
            <p>Hello, {greeting}!</p>
            <lightning-input
                label="Name"
                value={greeting}
                onchange={handleChange}
            ></lightning-input>
        </div>
    </lightning-card>
</template>
```

```javascript
import { LightningElement } from 'lwc';

export default class HelloBinding extends LightningElement {
    greeting = 'World';

    handleChange(event) {
        this.greeting = event.target.value;
    }
}
```

---

## type 변형 14가지

```html
<!-- 텍스트 -->
<lightning-input type="text" label="이름" value={name} onchange={handleChange}></lightning-input>

<!-- 숫자 -->
<lightning-input type="number" label="수량" min="0" max="100" step="1" formatter="decimal"></lightning-input>

<!-- 통화 -->
<lightning-input type="number" label="금액" formatter="currency" step="0.01"></lightning-input>

<!-- 날짜 -->
<lightning-input type="date" label="날짜" value={dateVal}></lightning-input>

<!-- 날짜+시간 -->
<lightning-input type="datetime" label="날짜/시간"></lightning-input>

<!-- 시간 -->
<lightning-input type="time" label="시간"></lightning-input>

<!-- 이메일 -->
<lightning-input type="email" label="이메일" value={email}></lightning-input>

<!-- 전화번호 -->
<lightning-input type="tel" label="전화번호"></lightning-input>

<!-- URL -->
<lightning-input type="url" label="웹사이트"></lightning-input>

<!-- 비밀번호 -->
<lightning-input type="password" label="비밀번호"></lightning-input>

<!-- 체크박스 (true/false) -->
<lightning-input type="checkbox" label="동의" checked={isChecked} onchange={handleCheckbox}></lightning-input>

<!-- 토글 (checkbox의 슬라이드 버전) -->
<lightning-input type="toggle" label="활성" message-toggle-active="켜짐" message-toggle-inactive="꺼짐"></lightning-input>

<!-- 파일 -->
<lightning-input type="file" label="파일 선택" accept=".pdf,.docx" multiple></lightning-input>

<!-- 검색 *(lwc-recipes-main/compositionContactSearch — Tier 1)* -->
<lightning-input type="search" label="Search" onchange={handleKeyChange}></lightning-input>

<!-- 색상 -->
<lightning-input type="color" label="색상 선택"></lightning-input>
```

---

## 검색 입력 + 디바운싱 패턴 *(lwc-recipes-main/compositionContactSearch — Tier 1)*

```javascript
import { LightningElement } from 'lwc';
import findContacts from '@salesforce/apex/ContactController.findContacts';

const DELAY = 350;

export default class CompositionContactSearch extends LightningElement {
    contacts;
    error;

    handleKeyChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(async () => {
            try {
                this.contacts = await findContacts({ searchKey });
                this.error = undefined;
            } catch (error) {
                this.error = error;
                this.contacts = undefined;
            }
        }, DELAY);
    }
}
```

---

## 전체 속성 레퍼런스

| 속성 | 타입 | 설명 |
|---|---|---|
| `label` | string | 필드 레이블 (필수) |
| `type` | string | 입력 유형 (기본값: `text`) |
| `value` | string | 현재 값 |
| `name` | string | 폼 제출 시 사용되는 이름 |
| `placeholder` | string | 입력 전 안내 텍스트 |
| `required` | boolean | 필수 필드 표시 및 검사 |
| `disabled` | boolean | 비활성화 |
| `readonly` | boolean | 읽기 전용 |
| `variant` | string | `standard`(기본) / `label-hidden` / `label-inline` / `label-stacked` |
| `field-level-help` | string | 물음표 아이콘 옆 도움말 텍스트 |
| `min` | number / string | 최솟값 (number, date, time, datetime) |
| `max` | number / string | 최댓값 |
| `step` | number | 증가 단위 (number) |
| `minlength` | number | 최소 문자 수 (text) |
| `maxlength` | number | 최대 문자 수 |
| `pattern` | string | 정규식 유효성 검사 패턴 |
| `formatter` | string | 숫자 형식: `decimal` / `currency` / `percent` / `percent-fixed` |
| `multiple` | boolean | 파일 다중 선택 (type=file) |
| `accept` | string | 허용 파일 확장자 (type=file) |
| `checked` | boolean | 체크 여부 (type=checkbox, toggle) |
| `message-when-value-missing` | string | required 미충족 시 에러 메시지 |
| `message-when-pattern-mismatch` | string | pattern 불일치 시 에러 메시지 |
| `message-when-range-overflow` | string | max 초과 시 에러 메시지 |
| `message-when-range-underflow` | string | min 미만 시 에러 메시지 |
| `message-toggle-active` | string | 토글 ON 상태 레이블 (type=toggle) |
| `message-toggle-inactive` | string | 토글 OFF 상태 레이블 (type=toggle) |

---

## 이벤트

| 이벤트 | 설명 | 주요 프로퍼티 |
|---|---|---|
| `change` | 값이 변경될 때 | `event.detail.value` (텍스트) / `event.detail.checked` (checkbox, toggle) |
| `commit` | Enter 또는 포커스 이탈 시 | `event.detail.value` |
| `focus` | 포커스 획득 시 | — |
| `blur` | 포커스 이탈 시 | — |

```javascript
// change 이벤트 처리 패턴
handleChange(event) {
    // 텍스트, 숫자, 날짜 등
    const value = event.target.value;

    // checkbox, toggle
    const checked = event.target.checked;
}
```

---

## 유효성 검사

```javascript
// reportValidity() — 유효성 검사 실행 + 오류 메시지 표시
// checkValidity() — 유효성 검사 실행 (메시지 표시 없음)
// setCustomValidity(message) — 커스텀 에러 메시지 설정

handleSubmit() {
    const input = this.template.querySelector('lightning-input');
    if (!input.checkValidity()) {
        input.reportValidity();
        return;
    }
    // 폼 처리 로직
}
```

---

## 접근성 (Accessibility)

- `label` 속성은 항상 지정한다 (`label-hidden`으로 시각적으로 숨기더라도 접근성을 위해 제공)
- `required` 설정 시 보조 기술에 필수 입력 알림
- `field-level-help` 도움말은 포커스 시 읽힘

---

## 사용 고려사항

- `type="number"`에서 `value`는 항상 문자열로 반환됨 — 숫자로 사용하려면 `parseFloat()`/`parseInt()` 변환 필요
- `type="checkbox"` / `type="toggle"` 에서 `event.detail.value`가 아닌 `event.target.checked`로 값을 읽는다
- `type="file"` 에서 파일 콘텐츠 접근은 `event.detail.files` (FileList)
- `variant="label-hidden"` — 레이블이 시각적으로 숨겨지지만 DOM에 존재 (접근성 유지)

---

## 관련 노트

- [[Lightning Base Components 레퍼런스]] — 전체 입력 컴포넌트 목록
- [[lightning-combobox]] — 드롭다운 단일 선택 입력
- [[lightning-record-form]] — 레코드 필드 자동 입력 폼
- [[파일 업로드와 이미지 처리]] — type=file 고급 처리 패턴
