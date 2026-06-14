---
tags: [lwc, base-component, modal, alert, overlay, reference]
source: SLDS2-Docs/components/lightning-alert.md (Tier 2)
created: 2026-06-14
aliases: [lightning-alert, LightningAlert, 알림, 경고창, 알림 모달]
---

# lightning-alert

> 확인 버튼이 있는 모달형 경고창. 컴포넌트 태그가 아니라 `LightningAlert.open()` 정적 메서드로 프로그래밍 호출한다. 카테고리: **Status & Notification**.

지원 상태: **GA** · 최소 API 버전: **54.0**

---

## 개념

`lightning-alert`는 마크업 태그로 배치하지 않는다. JavaScript 모듈 `lightning/alert`를 import한 뒤 정적 메서드 `open()`을 호출해 모달을 띄운다. 사용자가 확인 버튼을 누르면 반환된 Promise가 resolve된다. (OK 버튼만 있는 단순 알림용)

```javascript
// 소스 예제 (SLDS2-Docs) — Tier 2
import LightningAlert from 'lightning/alert';

await LightningAlert.open({ message: '저장됨', theme: 'success', label: '알림' });
```

---

## 정적 메서드

```javascript
// 구조 예시 — open()의 옵션 객체는 아래 속성표의 attribute에 대응. 시그니처는 소스 예제 기반.
LightningAlert.open(config) → Promise<void>
```

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `open` | `LightningAlert.open({ message, theme, label, variant })` | 알림 모달을 띄우고, 사용자가 OK 버튼을 누르면 resolve되는 `Promise`를 반환한다. |

`open()`에 넘기는 config 객체의 키는 아래 **속성**과 동일하다.

---

## 속성 (Attributes) — 4개

> 소스 명세의 속성 설명은 약 140자에서 잘려 있습니다(`theme` 등). 전체 문장은 하단 **Specification** 링크를 참고하세요.

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `label` | string |  | Alert (Localized Value) | Value to use for header text in "header" variant or aria-label in "headerless" variant. |
| `message` | string |  |  | Text to display in the alert. |
| `theme` | string |  | default | Theme to use when variant is "header". Valid values are "default", "shade", "inverse", "alt-inverse", "success", "success", "info", "warni…(소스에서 약 140자에서 잘림) |
| `variant` | string |  | header | Variant to use for alert. Valid values are "header" and "headerless". |

> `theme` 유효값은 소스 명세에서 잘려 있음(`"...warni…"`). 전체 유효값 목록은 Specification 링크 참고.

---

## 사용 예시

```javascript
// 구조 예시 — 실제 동작 코드 아님 (소스 속성표 기반 조합)
import LightningAlert from 'lightning/alert';

async handleSave() {
    await LightningAlert.open({
        message: '레코드가 저장되었습니다.',
        theme: 'success',   // header variant일 때 적용
        label: '알림',      // header variant: 제목 / headerless variant: aria-label
        variant: 'header'   // 'header'(기본) | 'headerless'
    });
    // OK 버튼을 누르면 여기로 진행 (Promise resolve)
}
```

---

## 공식 문서 링크

- Example (실행 예제): https://developer.salesforce.com/docs/component-library/bundle/lightning-alert/example
- Develop (개발 가이드): https://developer.salesforce.com/docs/component-library/bundle/lightning-alert/documentation
- Specification (명세): https://developer.salesforce.com/docs/component-library/bundle/lightning-alert/specification
- 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-alert.html

---

## 관련 노트

- [[lightning-modal]] — 커스텀 모달(`LightningModal` 상속) 및 내장 모달 클래스 개요
- [[lightning-confirm]] — OK/Cancel을 묻는 확인 모달
- [[lightning-prompt]] — 입력값을 받는 프롬프트 모달
