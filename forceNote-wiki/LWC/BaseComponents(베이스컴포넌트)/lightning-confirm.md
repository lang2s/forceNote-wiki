---
tags: [lwc, base-component, modal, confirm, overlay, reference]
source: SLDS2-Docs/components/lightning-confirm.md (Tier 2)
created: 2026-06-14
aliases: [lightning-confirm, LightningConfirm, 확인, 확인 모달, 확인 다이얼로그]
---

# lightning-confirm

> 확인/취소를 묻는 모달. 컴포넌트 태그가 아니라 `LightningConfirm.open()` 정적 메서드로 프로그래밍 호출하며, 사용자의 선택(OK/Cancel)을 boolean으로 반환한다. 카테고리: **Status & Notification**.

지원 상태: **GA** · 최소 API 버전: **54.0**

---

## 개념

`lightning-confirm`은 마크업 태그로 배치하지 않는다. JavaScript 모듈 `lightning/confirm`을 import한 뒤 정적 메서드 `open()`을 호출한다. 반환된 Promise는 사용자가 OK를 누르면 `true`, Cancel을 누르면 `false`로 resolve된다.

```javascript
// 소스 예제 (SLDS2-Docs) — Tier 2
import LightningConfirm from 'lightning/confirm';

const ok = await LightningConfirm.open({ message: '삭제할까요?' });
```

---

## 정적 메서드

```javascript
// 구조 예시 — open()의 옵션 객체는 아래 속성표의 attribute에 대응. 시그니처는 소스 예제 기반.
LightningConfirm.open(config) → Promise<boolean>
```

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `open` | `LightningConfirm.open({ message, theme, label, variant })` | 확인 모달을 띄우고, 사용자의 선택에 따라 `true`(OK) 또는 `false`(Cancel)로 resolve되는 `Promise`를 반환한다. |

`open()`에 넘기는 config 객체의 키는 아래 **속성**과 동일하다.

---

## 속성 (Attributes) — 4개

> 소스 명세의 속성 설명은 약 140자에서 잘려 있습니다. 전체 문장은 하단 **Specification** 링크를 참고하세요.

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `label` | string |  | Confirm (Localized Value) | Value to use for header text in "header" variant or aria-label in "headerless" variant. |
| `message` | string |  |  | Text to display in the confirm modal. |
| `theme` | string |  | default | Theme to use when variant is "header". Valid values are "default", "shade", "inverse", "alt-inverse", "success", "info", "warning", "error…(소스에서 약 140자에서 잘림) |
| `variant` | string |  | header | Variant to use for the confirm modal. Valid values are "header" and "headerless". |

> `theme` 유효값은 소스 명세에서 잘려 있음(`"...error…"`). 전체 유효값 목록은 Specification 링크 참고.

---

## 사용 예시

```javascript
// 구조 예시 — 실제 동작 코드 아님 (소스 속성표 기반 조합)
import LightningConfirm from 'lightning/confirm';

async handleDelete() {
    const ok = await LightningConfirm.open({
        message: '이 레코드를 삭제하시겠습니까?',
        theme: 'warning',  // header variant일 때 적용
        label: '삭제 확인', // header variant: 제목 / headerless variant: aria-label
        variant: 'header'  // 'header'(기본) | 'headerless'
    });

    if (ok) {
        // 사용자가 OK 선택
        await this.deleteRecord();
    }
    // Cancel이면 ok === false
}
```

---

## 공식 문서 링크

- Example (실행 예제): https://developer.salesforce.com/docs/component-library/bundle/lightning-confirm/example
- Develop (개발 가이드): https://developer.salesforce.com/docs/component-library/bundle/lightning-confirm/documentation
- Specification (명세): https://developer.salesforce.com/docs/component-library/bundle/lightning-confirm/specification
- 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-confirm.html

---

## 관련 노트

- [[lightning-modal]] — 커스텀 모달(`LightningModal` 상속) 및 내장 모달 클래스 개요
- [[lightning-alert]] — OK 버튼만 있는 단순 알림 모달
- [[lightning-prompt]] — 입력값을 받는 프롬프트 모달
