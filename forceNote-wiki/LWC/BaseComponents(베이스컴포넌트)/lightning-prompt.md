---
tags: [lwc, base-component, modal, prompt, overlay, reference]
source: SLDS2-Docs/components/lightning-prompt.md (Tier 2)
created: 2026-06-14
aliases: [lightning-prompt, LightningPrompt, 프롬프트, 입력 모달, 입력 프롬프트]
---

# lightning-prompt

> 입력값을 받는 모달 프롬프트. 컴포넌트 태그가 아니라 `LightningPrompt.open()` 정적 메서드로 프로그래밍 호출하며, 사용자가 입력한 문자열(또는 취소 시 null)을 반환한다. 카테고리: **Status & Notification**.

지원 상태: **GA** · 최소 API 버전: **54.0**

---

## 개념

`lightning-prompt`는 마크업 태그로 배치하지 않는다. JavaScript 모듈 `lightning/prompt`를 import한 뒤 정적 메서드 `open()`을 호출한다. 반환된 Promise는 사용자가 입력한 문자열로 resolve되며, 취소하면 `null`로 resolve된다. `default-value`로 입력 필드의 초기값을 지정할 수 있다.

```javascript
// 소스 예제 (SLDS2-Docs) — Tier 2
import LightningPrompt from 'lightning/prompt';

const v = await LightningPrompt.open({ message: '이름?', defaultValue: '' });
```

---

## 정적 메서드

```javascript
// 구조 예시 — open()의 옵션 객체는 아래 속성표의 attribute에 대응. 시그니처는 소스 예제 기반.
LightningPrompt.open(config) → Promise<string | null>
```

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `open` | `LightningPrompt.open({ message, defaultValue, theme, label, variant })` | 입력 프롬프트 모달을 띄우고, 사용자가 입력한 문자열 또는 취소 시 `null`로 resolve되는 `Promise`를 반환한다. |

`open()`에 넘기는 config 객체의 키는 아래 **속성**과 동일하다. (`default-value` 속성은 JS config에서 `defaultValue`로 전달 — 소스 예제 참조)

---

## 속성 (Attributes) — 5개

> 소스 명세의 속성 설명은 약 140자에서 잘려 있습니다. 전체 문장은 하단 **Specification** 링크를 참고하세요.

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `default-value` | string |  |  | Default value for input. |
| `label` | string |  | Prompt (Localized Value) | Value to use for header text in "header" variant or aria-label in "headerless" variant. |
| `message` | string |  |  | Text to display in the prompt. |
| `theme` | string |  | default | Theme to use when variant is "header". Valid values are "default", "shade", "inverse", "alt-inverse", "success", "info", "warning", "error…(소스에서 약 140자에서 잘림) |
| `variant` | string |  | header | Variant to use for the prompt. Valid values are "header" and "headerless". |

> `theme` 유효값은 소스 명세에서 잘려 있음(`"...error…"`). 전체 유효값 목록은 Specification 링크 참고.

---

## 사용 예시

```javascript
// 구조 예시 — 실제 동작 코드 아님 (소스 속성표 기반 조합)
import LightningPrompt from 'lightning/prompt';

async handleRename() {
    const newName = await LightningPrompt.open({
        message: '새 이름을 입력하세요:',
        defaultValue: this.currentName, // 입력 필드 초기값 (default-value)
        label: '이름 변경',              // header variant: 제목 / headerless variant: aria-label
        theme: 'default',
        variant: 'header'               // 'header'(기본) | 'headerless'
    });

    if (newName !== null) {
        // 사용자가 입력하고 OK
        this.currentName = newName;
    }
    // 취소하면 newName === null
}
```

---

## 공식 문서 링크

- Example (실행 예제): https://developer.salesforce.com/docs/component-library/bundle/lightning-prompt/example
- Develop (개발 가이드): https://developer.salesforce.com/docs/component-library/bundle/lightning-prompt/documentation
- Specification (명세): https://developer.salesforce.com/docs/component-library/bundle/lightning-prompt/specification
- 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-prompt.html

---

## 관련 노트

- [[lightning-modal]] — 커스텀 모달(`LightningModal` 상속) 및 내장 모달 클래스 개요
- [[lightning-alert]] — OK 버튼만 있는 단순 알림 모달
- [[lightning-confirm]] — OK/Cancel을 묻는 확인 모달
