---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Understand Parent To Child - Child To Parent]
---

# LWC의 Parent-to-Child & Child-to-Parent 통신 이해

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 원본은 이미지 PDF로 OCR 추출했습니다.

## Parent → Child 통신
부모가 자식에 데이터를 공유하거나 메서드를 호출. 폼·대시보드·재사용 임베드 컴포넌트에 필수.

**예:**

부모가 고객 상세(이름·이메일)를 자식에 전달, 자식이 카드로 표시. 부모가 reset 액션으로 초기화.

**자식(customerChildComponentLwc):**

@api로 public 속성(name·email) 노출, 부모가 호출 가능한 reset() 메서드.
```javascript
import { LightningElement, api } from 'lwc';
export default class CustomerChildComponentLwc extends LightningElement {
    @api name = '';
    @api email = '';
    @api reset() { this.name = ''; this.email = ''; }
}
```
```html
<template>
    <lightning-card title="Customer Details" icon-name="standard:contact">
        <div class="slds-grid slds-wrap">
            <div class="slds-size_1-of-2"><strong>Name:</strong> {name}</div>
            <div class="slds-size_1-of-2"><strong>Email:</strong> {email}</div>
        </div>
    </lightning-card>
</template>
```

**부모(customerParentComponentLwc):**

customerName·customerEmail 전달, querySelector로 자식 접근·reset() 호출.
```html
<template>
    <c-customer-child-component-lwc name={customerName} email={customerEmail}></c-customer-child-component-lwc>
    <lightning-button label="Reset Customer Info" onclick={resetCustomer}></lightning-button>
</template>
```
```javascript
export default class CustomerParentComponentLwc extends LightningElement {
    customerName = 'Juhi Chintan';
    customerEmail = 'juhi1327@gmail.com';
    resetCustomer() {
        const childComponent = this.template.querySelector('c-customer-child-component-lwc');
        childComponent.reset();
    }
}
```

## Child → Parent 통신
자식의 액션(사용자 상호작용·상태 변경)을 부모가 처리해야 할 때. Custom Event 사용.

**예:**

자식이 입력으로 피드백 수집·제출 시 부모에 알림, 부모가 표시.

**자식(feedbackChildComponentLwc):**

custom event(feedbacksubmit)로 알림.
```javascript
import { LightningElement } from 'lwc';
export default class FeedbackChildComponentLwc extends LightningElement {
    feedback = '';
    handleInputChange(event) { this.feedback = event.target.value; }
    handleSubmit() {
        const feedbackEvent = new CustomEvent('feedbacksubmit', { detail: { feedback: this.feedback } });
        this.dispatchEvent(feedbackEvent);
    }
}
```
```html
<template>
    <lightning-input label="Your Feedback" value={feedback} onchange={handleInputChange}></lightning-input>
    <lightning-button label="Submit Feedback" variant="brand" onclick={handleSubmit}></lightning-button>
</template>
```

**부모(feedbackParentComponentLwc):**

onfeedbacksubmit으로 수신.
```html
<template>
    <lightning-card title="Submit Your Feedback" icon-name="standard:feedback">
        <c-feedback-child-component-lwc onfeedbacksubmit={handleFeedbackSubmit}></c-feedback-child-component-lwc>
        <div><strong>Feedback Received:</strong> {feedbackReceived}</div>
    </lightning-card>
</template>
```
```javascript
export default class FeedbackParentComponentLwc extends LightningElement {
    feedbackReceived = '';
    handleFeedbackSubmit(event) { this.feedbackReceived = event.detail.feedback; }
}
```
