---
tags: [LWC, UIPatterns, validation, form, lightning-input, record-edit-form]
source: developer.salesforce.com LWC Dev Guide "Validate the User's Input" + component-library(lightning-input, lightning-record-edit-form)
created: 2026-07-08
aliases: [LWC 폼 검증, checkValidity, reportValidity, setCustomValidity, form validation, 입력 검증, message-when]
---

# LWC 폼 검증 패턴

> `lightning-input` 계열의 제약 속성 + `checkValidity`/`reportValidity`/`setCustomValidity`로 클라이언트 검증하고, `lightning-record-edit-form`의 `onsubmit`/`onerror`로 서버 검증까지 연결하는 패턴.

---

## 1. 제약 속성 (선언적 검증)

`lightning-input`(및 `lightning-textarea`, `lightning-combobox` 등)은 HTML5 폼 검증에 대응하는 속성을 제공한다. 사용자가 규칙을 어기면 컴포넌트가 자동으로 유효성 상태를 계산한다.

| 속성 | 적용 `type` | 의미 |
|---|---|---|
| `required` | 전부 | 값이 비면 무효 |
| `pattern` | `text`, `email`, `url`, `tel`, `search`, `password` | 정규식과 일치해야 유효 |
| `min` / `max` | `number`, `date`, `datetime`, `time` | 최소/최대 값 |
| `step` | `number` | 값 간격 (미배수면 무효) |
| `minlength` / `maxlength` | 문자열 계열 | 최소/최대 문자 수 |

각 제약에는 대응하는 `message-when-*` 속성으로 커스텀 오류 메시지를 지정한다.

| `message-when-*` 속성 | 트리거되는 무효 상태 |
|---|---|
| `message-when-value-missing` | `required`인데 값 없음 |
| `message-when-pattern-mismatch` | `pattern` 불일치 |
| `message-when-type-mismatch` | `type=email`/`url` 형식 위반 |
| `message-when-too-long` | `maxlength` 초과 |
| `message-when-too-short` | `minlength` 미달 |
| `message-when-range-underflow` | `min` 미만 |
| `message-when-range-overflow` | `max` 초과 |
| `message-when-step-mismatch` | `step` 배수 아님 |
| `message-when-bad-input` | 파싱 불가한 입력 |

```html
<!-- validationForm.html -->
<template>
    <lightning-input
        name="email"
        label="Email"
        type="email"
        required
        message-when-value-missing="이메일을 입력하세요."
        message-when-type-mismatch="유효한 이메일 형식이 아닙니다.">
    </lightning-input>

    <lightning-input
        name="zip"
        label="Zip Code"
        pattern="[0-9]{5}"
        message-when-pattern-mismatch="5자리 숫자를 입력하세요.">
    </lightning-input>

    <lightning-input
        name="qty"
        label="Quantity"
        type="number"
        min="1"
        max="100"
        message-when-range-overflow="최대 100까지 가능합니다."
        message-when-range-underflow="최소 1 이상이어야 합니다.">
    </lightning-input>

    <lightning-button label="Submit" onclick={handleSubmit}></lightning-button>
</template>
```

---

## 2. 검증 메서드

`lightning-input` 계열은 세 가지 검증 API를 노출한다.

| 메서드 | 반환 | UI 표시 | 용도 |
|---|---|---|---|
| `checkValidity()` | `Boolean` | 없음 (조용히 판정만) | 유효 여부만 확인 |
| `reportValidity()` | `Boolean` | 무효면 오류 메시지 표시 | 판정 + 사용자에게 피드백 |
| `setCustomValidity(msg)` | `void` | (다음 `reportValidity()`에 반영) | 커스텀 오류 문자열 지정 |

### 단일 입력 검증

```js
handleSubmit() {
    const input = this.template.querySelector('lightning-input[data-id="email"]');
    if (input.checkValidity()) {
        // 유효 — 진행
    } else {
        input.reportValidity(); // 오류 메시지 화면 표시
    }
}
```

### 여러 입력 순회 검증 (querySelectorAll + reduce)

폼의 모든 `lightning-input`을 순회하며 각각 `reportValidity()`를 호출하고, 하나라도 무효면 전체를 무효로 판정하는 표준 패턴이다. `&&`가 아니라 `reduce`를 쓰는 이유는 **모든** 입력에 대해 `reportValidity()`를 호출해 오류를 전부 표시하기 위함이다(단락 평가로 뒤 입력이 스킵되면 안 됨).

```js
handleSubmit() {
    const allValid = [
        ...this.template.querySelectorAll('lightning-input'),
    ].reduce((validSoFar, inputCmp) => {
        inputCmp.reportValidity();
        return validSoFar && inputCmp.checkValidity();
    }, true);

    if (allValid) {
        // 모든 입력 유효 — 저장 로직 진행
    }
}
```

### setCustomValidity로 커스텀 검증

선언적 제약으로 표현할 수 없는 규칙(예: 두 필드 값 비교, 서버 조회 결과)은 `setCustomValidity()`로 오류를 주입한다. **커스텀 오류를 지운 뒤 다시 `reportValidity()`를 호출**해야 UI가 갱신된다. 빈 문자열(`''`)로 세팅하면 커스텀 오류가 해제된다.

```js
validatePasswordMatch() {
    const confirm = this.template.querySelector('[data-id="confirmPassword"]');
    if (confirm.value !== this.password) {
        confirm.setCustomValidity('비밀번호가 일치하지 않습니다.');
    } else {
        confirm.setCustomValidity(''); // 커스텀 오류 해제
    }
    confirm.reportValidity(); // 메시지 표시/제거 반영
}
```

> 흐름: `setCustomValidity(msg)` → `reportValidity()`. 커스텀 메시지가 남아 있으면 그 입력은 계속 무효로 취급되므로, 규칙을 통과하면 반드시 `setCustomValidity('')`로 해제한다.

---

## 3. lightning-record-edit-form 검증

`lightning-record-edit-form`은 레코드 생성/수정 폼으로, **필드 레벨 검증(필수/타입)**과 **서버 검증(validation rule)**을 함께 처리한다.

### 이벤트 흐름

| 이벤트 | 발생 시점 | 용도 |
|---|---|---|
| `onsubmit` | 클라이언트 검증 통과 후, 서버 전송 직전 | `event.preventDefault()`로 가로채 필드 값 재작성 |
| `onsuccess` | 서버 저장 성공 | 성공 처리(토스트, 네비게이션) |
| `onerror` | 서버 저장 실패(validation rule·필수 필드 등) | 오류 처리 |

`lightning-messages`를 폼 안에 두면 서버 오류가 자동으로 표시된다. `lightning-input-field`는 필드 레벨 오류를 인라인으로 렌더한다.

```html
<!-- recordForm.html -->
<template>
    <lightning-record-edit-form
        object-api-name="Account"
        onsubmit={handleSubmit}
        onsuccess={handleSuccess}
        onerror={handleError}>

        <lightning-messages></lightning-messages>

        <lightning-input-field field-name="Name" required></lightning-input-field>
        <lightning-input-field field-name="AnnualRevenue"></lightning-input-field>

        <lightning-button
            type="submit"
            label="Save"
            variant="brand">
        </lightning-button>
    </lightning-record-edit-form>
</template>
```

### onsubmit — preventDefault 후 필드 재작성

기본 저장을 막고 값을 가공한 뒤 `form.submit(fields)`로 수동 제출한다.

```js
handleSubmit(event) {
    event.preventDefault();           // 기본 제출 중단
    const fields = event.detail.fields;
    fields.Name = fields.Name.trim(); // 값 재작성
    this.template.querySelector('lightning-record-edit-form').submit(fields);
}
```

### onerror — 서버 검증(validation rule) 에러 표시

서버 측 validation rule이나 Apex 트리거 오류는 `onerror`에서 `event.detail`로 전달된다. `lightning-messages`가 폼 내부에 있으면 자동 표시되지만, 커스텀 UI로 노출하려면 이벤트에서 추출한다.

```js
handleError(event) {
    // event.detail.message / detail.detail / detail.output.errors
    const msg = event.detail.detail || event.detail.message;
    this.errorMessage = msg;
}
```

### reportValidity() — 폼 전체 검증

`lightning-record-edit-form`도 `reportValidity()`를 노출해, 제출 전 폼 내 모든 `lightning-input-field`의 유효성을 검사하고 오류를 표시한다.

```js
checkForm() {
    const form = this.template.querySelector('lightning-record-edit-form');
    if (form.reportValidity()) {
        // 클라이언트 검증 통과 — submit 진행
    }
}
```

> 클라이언트 검증(필수/타입)은 제출 전에, 서버 검증(validation rule)은 저장 시도 후 `onerror`로 표시된다. 두 계층을 모두 처리해야 사용자가 완전한 피드백을 받는다.

---

## 4. 검증 계층 정리

| 계층 | 위치 | 트리거 | 메시지 표시 |
|---|---|---|---|
| 선언적 제약 | `required`/`pattern`/`min` 등 속성 | 값 변경·제출 | `message-when-*` |
| 명령형 커스텀 | `setCustomValidity()` | JS 로직 | 다음 `reportValidity()` |
| 폼 클라이언트 | `reportValidity()` (form/input) | 제출 직전 | 인라인 |
| 서버 (validation rule) | org 설정 | 저장 시도 후 | `onerror` + `lightning-messages` |

---

## 관련 노트
- [[Record Form 선택]]
- [[에러 패널 패턴]]
- [[LWC MOC]]
