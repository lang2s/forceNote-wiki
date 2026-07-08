---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [child_parent_communication_in_lwc]
---

# LWC의 이벤트를 통한 Child→Parent 통신 상세

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 원본은 이미지 PDF로 OCR 추출했습니다.

## Part 1: JavaScript 이벤트와 Custom Event
- LWC 통신은 Parent→Child, Child→Parent 두 방향.
- Child→Parent는 **Custom Event**로 부모에 액션·데이터 변경 알림.
- 이벤트는 JS가 인식하는 액션(클릭·입력 등). 특정 함수(핸들러) 트리거.
- **CustomEvent:** 컴포넌트 간 데이터 전달하는 사용자 정의 이벤트.
```javascript
const event = new CustomEvent('eventName', { detail: { key: 'value' } });
```
- **Dispatch:** `this.dispatchEvent(new CustomEvent('eventName', { detail: {...} }))`.

## Part 2: 자식 컴포넌트에서 구현
자식이 custom event 정의·dispatch.
```javascript
// ChildComponent.js
export default class ChildComponent extends LightningElement {
    handleAction() {
        const customEvent = new CustomEvent('someaction', {
            detail: { message: 'Hello from Child Component!' }
        });
        this.dispatchEvent(customEvent);
    }
}
```
- **detail 객체:** 이벤트와 함께 데이터 전달. 다중 키-값 가능.
- **이벤트 이름:** 모두 소문자(case-insensitive, 일관성 위해 소문자).
```html
<!-- ChildComponent.html -->
<template>
    <lightning-button label="Click me" onclick={handleAction}></lightning-button>
</template>
```

## Part 3: 부모 컴포넌트에서 처리
부모가 HTML 템플릿의 이벤트 핸들러로 수신.
```html
<!-- ParentComponent.html -->
<template>
    <c-child-component onsomeaction={handleChildAction}></c-child-component>
</template>
```
- **명명 규칙:** `on` 접두 + 소문자 이벤트명(onsomeaction).
```javascript
// ParentComponent.js
export default class ParentComponent extends LightningElement {
    handleChildAction(event) {
        // event.detail로 자식 데이터 접근
        console.log(event.detail.message);
    }
}
```
