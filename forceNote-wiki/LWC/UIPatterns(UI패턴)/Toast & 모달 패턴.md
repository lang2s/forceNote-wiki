---
tags: [lwc, toast, modal, ui, pattern]
source: lwc-recipes/miscToastNotification, miscModal, myModal + developer.salesforce.com Component Reference lightning-platform-show-toast-event (Tier 2, mode 표) + component-library lightning-toast·lightning-toast-container (Tier 2, 선언형 토스트)
created: 2026-05-17
aliases: [ShowToastEvent, Toast, Modal, LightningModal, lightning-toast, toast-container]
---

# Toast & 모달 패턴

> ShowToastEvent(variant 4종·mode 3종)로 비차단 피드백을, LightningModal/LightningAlert로 차단형 다이얼로그를 구현하는 LWC UI 패턴.

---

## ShowToastEvent — 토스트 알림

```javascript
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

showToast(title, message, variant) {
    this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
}

// 사용 예
showToast('Success', 'Record saved', 'success');
showToast('Error', 'Something went wrong', 'error');
```

### variant 종류

| variant | 색상 | 아이콘 | 사용 시점 |
|---|---|---|---|
| `success` | 초록 | ✓ | 저장, 삭제 완료 |
| `error` | 빨강 | ✗ | API 실패, 검증 오류 |
| `warning` | 주황 | ! | 비가역적 작업 경고 |
| `info` | 파랑 | ℹ | 안내 메시지 |

### mode 옵션 (선택)

```javascript
new ShowToastEvent({
    title: '알림',
    message: '내용',
    variant: 'info',
    mode: 'sticky'  // 'dismissible'(기본) | 'pester' | 'sticky'
})
```

mode는 토스트의 **지속성(persistence)** 을 결정한다 (공식 Component Reference 대조, Tier 2):

| mode | 자동 소멸 | 닫기(X) 버튼 | 동작 |
|---|---|---|---|
| `dismissible` (기본) | O — 5초 후 | 있음 | 닫기 버튼 클릭 또는 5초 경과 중 **먼저 오는 쪽**에 사라짐 |
| `pester` | O — 5초 후 | **없음** | 5초 동안 표시 후 자동으로 사라짐. 사용자가 닫을 수 없음 |
| `sticky` | **없음** | 있음 | 사용자가 닫기 버튼을 클릭할 때까지 계속 유지 |

> 선택 기준: 일반 성공/안내 피드백 → `dismissible`(기본), 스쳐 지나가도 되는 알림 → `pester`, 반드시 읽고 넘어가야 하는 오류/경고 → `sticky`.

---

## lightning-toast — 선언형 토스트 (Summer '26 GA)

위의 `ShowToastEvent`는 이벤트를 디스패치하면 **Lightning Experience의 플랫폼이 잡아** 토스트를 그린다. 즉 LEX(및 이를 호스팅하는 컨테이너) **안에서만** 동작한다. `lightning-toast`(component-library, Summer '26 GA)는 이 의존을 없앤 **선언형** 대안으로, `Toast.show(...)` 정적 메서드를 직접 호출한다 (공식 Component Reference `lightning-toast`·`lightning-toast-container` 대조, Tier 2).

```javascript
import Toast from 'lightning/toast';

showToast() {
    Toast.show({
        label: 'Success',                 // 필수 — 토스트 제목
        message: 'Record saved',
        variant: 'success',               // 'info'(기본) | 'success' | 'warning' | 'error'
        mode: 'dismissible'               // 'dismissible'(기본) | 'pester' | 'sticky'
    }, this);                             // 두 번째 인자 = 호출 컴포넌트 인스턴스(this)
}
```

- `Toast.show(config, component)` — 이벤트 디스패치가 아니라 **정적 메서드 호출**이다. 두 번째 인자로 호출한 컴포넌트(`this`)를 넘겨 토스트를 어느 컨테이너에 띄울지 결정한다.
- `variant`·`mode` 값 집합은 `ShowToastEvent`와 동일하다(위 표 참조). 제목 필드명만 `title`이 아니라 **`label`**로 다르다.

### lightning-toast-container 배치

`lightning-toast`가 실제로 그려지려면 앱 트리 어딘가에 **`lightning-toast-container`**가 있어야 한다. LEX에는 플랫폼이 컨테이너를 제공하므로 그냥 `Toast.show`만 호출하면 되지만, **LEX 밖(LWR Experience Cloud 사이트 등)**에서는 앱 루트 컴포넌트에 컨테이너를 직접 배치해야 토스트가 표시된다.

```html
<!-- 앱 루트 컴포넌트 template — LEX 밖에서 필수 -->
<template>
    <lightning-toast-container></lightning-toast-container>
    <!-- 나머지 앱 마크업 -->
</template>
```

### 선언형(lightning-toast) vs 이벤트형(ShowToastEvent)

| 구분 | `ShowToastEvent` (이벤트형) | `lightning-toast` (선언형) |
|---|---|---|
| 호출 방식 | `this.dispatchEvent(new ShowToastEvent({...}))` | `Toast.show({...}, this)` 정적 호출 |
| 제목 필드 | `title` | `label` |
| 동작 범위 | **Lightning Experience 한정** (플랫폼이 이벤트를 포착) | **어디서나** — LEX + LWR Experience Cloud 사이트 등 |
| 컨테이너 | 불필요 (플랫폼 내장) | LEX 밖에서는 `lightning-toast-container` 필요 |

> 선택 기준: 순수 LEX(레코드 페이지·App 등) 컴포넌트라면 기존 `ShowToastEvent`로 충분하다. **LWR Experience Cloud 사이트처럼 LEX 밖**에서 동작해야 하거나, 이벤트 버블링 없이 정적 호출로 토스트를 띄우고 싶으면 `lightning-toast`를 쓰고 앱 루트에 `lightning-toast-container`를 배치한다.

---

## LightningModal — 모달 다이얼로그

### 모달 컴포넌트 정의

```javascript
// myModal.js — LightningModal 상속 필수
import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class MyModal extends LightningModal {
    @api header;
    @api content;

    handleClose() {
        this.close('confirmed'); // 반환값 전달
    }
}
```

```html
<!-- myModal.html -->
<template>
    <lightning-modal-header label={header}></lightning-modal-header>
    <lightning-modal-body>
        <p>{content}</p>
    </lightning-modal-body>
    <lightning-modal-footer>
        <lightning-button label="Cancel" onclick={handleCancel}></lightning-button>
        <lightning-button label="Confirm" variant="brand" onclick={handleClose}></lightning-button>
    </lightning-modal-footer>
</template>
```

### 모달 호출 (부모)

```javascript
import MyModal from 'c/myModal';

async handleShowModal() {
    const result = await MyModal.open({
        size: 'small',        // 'small' | 'medium' | 'large' | 'full'
        description: 'Confirmation dialog',
        header: '확인',
        content: '계속 진행하시겠습니까?'
    });

    if (result === 'confirmed') {
        // 사용자가 Confirm 클릭
        await this.doAction();
    }
    // result === undefined → X 버튼 또는 ESC로 닫음
}
```

> [!note] close() 반환값
> - `this.close('value')` → `result = 'value'`
> - X 버튼 / ESC / backdrop 클릭 → `result = undefined`

---

## 확인 다이얼로그 패턴

```javascript
// 삭제 전 확인 패턴
async handleDelete() {
    const result = await ConfirmModal.open({
        header: '삭제 확인',
        content: '이 레코드를 삭제하시겠습니까?'
    });

    if (result !== 'confirmed') return; // 취소

    try {
        await deleteRecord(this.recordId);
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: '삭제되었습니다',
            variant: 'success'
        }));
    } catch (error) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error',
            message: reduceErrors(error).join(', '),
            variant: 'error'
        }));
    }
}
```

---

## LightningAlert — 단순 경고 다이얼로그

모달보다 가벼운 alert. 확인 버튼 하나만 있는 단방향 알림에 사용.

```javascript
import LightningAlert from 'lightning/alert';

async handleAlert() {
    await LightningAlert.open({
        message: '이 작업은 되돌릴 수 없습니다.',
        theme: 'error',   // 'default' | 'shade' | 'inverse' | 'alt-inverse' | 'success' | 'info' | 'warning' | 'error' | 'offline'
        label: '경고'     // 모달 헤더 접근성 레이블
    });
    // await 완료 = 사용자가 OK 클릭
}
```

| 구분 | ShowToastEvent | LightningAlert | LightningModal |
|---|---|---|---|
| 차단 여부 | 비차단 (알림만) | 차단 (OK 클릭 대기) | 차단 (반환값 있음) |
| 반환값 | 없음 | 없음 | `close(value)` 값 |
| 사용 시점 | 성공/실패 피드백 | 단순 경고·안내 | 확인/입력 다이얼로그 |

---

## 관련 노트

- [[NavigationMixin 패턴]]
- [[에러 패널 패턴]]
- [[ldsUtils reduceErrors]]
