---
tags: [lwc, base-component, modal, overlay, reference]
source: TrailheadApp/lwc-recipes-main (Tier 1) + external-knowledge (Tier 3)
created: 2026-05-17
aliases: [lightning-modal, LightningModal, 모달, 모달 창, 다이얼로그]
---

# lightning-modal

> 현재 앱 화면 위에 오버레이되는 모달 다이얼로그. `LightningModal`을 상속(extends)한 컴포넌트 클래스를 만들어 사용한다.

> [!warning] 속성 세부사항 일부는 외부 지식(Tier 3). 코드 예시는 `lwc-recipes-main/miscModal` + `myModal` (Tier 1).

---

## 핵심 개념

`lightning-modal`은 컴포넌트 태그가 아닌 **클래스 상속 패턴**으로 사용한다.

1. 모달 컴포넌트: `LightningModal`을 extends
2. 호출 컴포넌트: `import MyModal from 'c/myModal'` → `await MyModal.open({ ... })`
3. 닫기: 모달 내부에서 `this.close(returnValue)` 호출

---

## 모달 컴포넌트 정의 *(lwc-recipes-main/myModal — Tier 1)*

```html
<!-- myModal.html -->
<template>
    <lightning-modal-header label={header}></lightning-modal-header>
    <lightning-modal-body>
        Content: {content}
    </lightning-modal-body>
    <lightning-modal-footer>
        <lightning-button label="Close" onclick={handleClose}></lightning-button>
    </lightning-modal-footer>
</template>
```

```javascript
// myModal.js
import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class MyModal extends LightningModal {
    @api header;  // 호출 시 전달받는 속성
    @api content;

    handleClose() {
        // close()에 반환값 전달 가능 — open()을 await한 쪽에서 받음
        this.close('return value');
    }
}
```

---

## 모달 열기 (호출 컴포넌트) *(lwc-recipes-main/miscModal — Tier 1)*

```html
<!-- miscModal.html -->
<template>
    <lightning-card title="MiscModal">
        <div class="slds-var-m-around_medium">
            <lightning-input label="Header" type="text" value={header} onchange={handleHeaderChange}></lightning-input>
            <lightning-input label="Content" type="text" value={content} onchange={handleContentChange}></lightning-input>
            <lightning-button onclick={handleShowModal} label="Show modal"></lightning-button>
        </div>
    </lightning-card>
</template>
```

```javascript
// miscModal.js
import { LightningElement } from 'lwc';
import MyModal from 'c/myModal';

export default class MiscModal extends LightningElement {
    content = 'The modal content';
    header  = 'The modal header';

    handleHeaderChange(event)  { this.header  = event.target.value; }
    handleContentChange(event) { this.content = event.target.value; }

    async handleShowModal() {
        // open()은 Promise 반환 — 모달이 닫힐 때까지 await
        const result = await MyModal.open({
            size: 'small',
            description: 'Accessible description for screen readers',
            header:  this.header,
            content: this.content
        });
        // result = close()에 전달한 값, 표준 X버튼으로 닫으면 undefined
        console.log(result);
    }
}
```

---

## open() 옵션

```javascript
const result = await MyModal.open({
    size: 'medium',        // small | medium | large | full
    description: '...',    // 스크린리더 설명 (접근성)
    // 모달 컴포넌트의 @api 속성들
    header: '제목',
    content: '내용'
});
```

| 옵션 | 타입 | 설명 |
|---|---|---|
| `size` | string | `small` / `medium`(기본) / `large` / `full` |
| `description` | string | 스크린리더용 설명 |
| 그 외 | any | 모달 컴포넌트의 `@api` 속성으로 전달됨 |

---

## close() 반환값 처리

```javascript
// 모달 내부
handleSave() {
    this.close({ saved: true, recordId: '001...' });
}

handleCancel() {
    this.close(); // undefined 반환
}
```

```javascript
// 호출 컴포넌트
const result = await MyModal.open({ ... });

if (result?.saved) {
    // 저장 후 처리
    console.log('저장된 레코드:', result.recordId);
} else {
    // 취소 또는 X 버튼으로 닫힘
}
```

---

## 모달 슬롯 구조

```html
<template>
    <!-- 헤더 슬롯 -->
    <lightning-modal-header label="모달 제목">
        <!-- label 속성 또는 슬롯 콘텐츠 -->
    </lightning-modal-header>

    <!-- 바디 슬롯 (스크롤 가능) -->
    <lightning-modal-body>
        <p>모달 내용이 여기 들어갑니다.</p>
        <!-- 긴 콘텐츠는 자동 스크롤 -->
    </lightning-modal-body>

    <!-- 푸터 슬롯 (버튼 영역) -->
    <lightning-modal-footer>
        <lightning-button label="취소" onclick={handleCancel}></lightning-button>
        <lightning-button label="저장" variant="brand" onclick={handleSave}></lightning-button>
    </lightning-modal-footer>
</template>
```

---

## 확인(Confirm) 모달 패턴

```javascript
// 삭제 전 확인 다이얼로그
import ConfirmModal from 'c/confirmModal';

async handleDelete(event) {
    const result = await ConfirmModal.open({
        size: 'small',
        header: '삭제 확인',
        message: `"${this.recordName}"을 삭제하시겠습니까?`
    });

    if (result === 'confirm') {
        await deleteRecord(this.recordId);
    }
}
```

```html
<!-- confirmModal.html -->
<template>
    <lightning-modal-header label={header}></lightning-modal-header>
    <lightning-modal-body>
        <p>{message}</p>
    </lightning-modal-body>
    <lightning-modal-footer>
        <lightning-button label="취소" onclick={handleCancel}></lightning-button>
        <lightning-button label="삭제" variant="destructive" onclick={handleConfirm}></lightning-button>
    </lightning-modal-footer>
</template>
```

```javascript
// confirmModal.js
import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class ConfirmModal extends LightningModal {
    @api header;
    @api message;

    handleCancel()  { this.close();           }
    handleConfirm() { this.close('confirm');  }
}
```

---

## LightningAlert / LightningConfirm / LightningPrompt (내장 모달)

복잡한 모달이 필요 없는 경우 내장 모달 클래스를 바로 사용할 수 있다.

```javascript
import LightningAlert from 'lightning/alert';
import LightningConfirm from 'lightning/confirm';
import LightningPrompt from 'lightning/prompt';

// 경고 알림 (OK 버튼만)
await LightningAlert.open({
    message: '저장되었습니다.',
    theme: 'success',  // default | shade | inverse | alt-inverse | success | info | warning | error | offline
    label: '알림'
});

// 확인 다이얼로그 (OK/Cancel)
const result = await LightningConfirm.open({
    message: '삭제하시겠습니까?',
    variant: 'destructive',  // default | destructive | header-destructive
    label: '삭제 확인'
});
// result: true (OK) | false (Cancel)

// 입력 프롬프트
const input = await LightningPrompt.open({
    message: '새 이름을 입력하세요:',
    label: '이름 변경',
    defaultValue: '기존 이름'
});
// input: string | null (취소)
```

---

## 접근성 (Accessibility)

- `description` 옵션: 스크린리더가 모달 용도를 읽을 수 있도록 제공 권장
- 모달이 열리면 포커스가 자동으로 모달 내부로 이동
- `Esc` 키로 모달 닫기 지원
- 모달 뒤의 콘텐츠는 `aria-hidden="true"` 처리 → 스크린리더 접근 차단
- `lightning-modal-header`의 `label` 속성 = 모달 제목 (ARIA)

---

## 사용 고려사항

- 표준 X 버튼으로 닫으면 `open()` promise가 `undefined`를 반환
- `this.close()` 호출 없이 모달을 닫을 수 없다 (프로그래밍 제어 필수)
- 모달 내부에서 `NavigationMixin` 사용 시 모달이 자동으로 닫히지 않음 — 명시적 `this.close()` 호출 필요
- `size: 'full'` — 화면 전체를 덮는 모달 (모바일에서는 기본적으로 full size)

---

## 관련 노트

- [[Toast & 모달 패턴]] — ShowToastEvent, LightningAlert, 전체 모달 패턴
- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 목록
- [[lightning-button]] — 모달 내 버튼 variant 선택
