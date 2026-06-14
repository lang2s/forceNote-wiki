---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Communication between Lightning Web Components]
---

# LWC 간 통신

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 통신이란?
한 LWC에서 다른 LWC로 데이터를 보내는 과정. 부모→자식, 관계 없는 컴포넌트 간 전송 가능.

## Parent → Child
부모가 자식에 데이터를 보내려면, 자식 컴포넌트에 @api 데코레이터로 표시한 속성을 만든다.
- **자식:** JS에 속성 생성·@api 표시.
```javascript
// child.js
import { LightningElement, api } from 'lwc';
export default class Child extends LightningElement {
    @api message;
}
```
- **부모:** 자식 사용 시 message 속성으로 데이터 전달.
```html
<c-child message={parentValue}></c-child>
```

## Child → Parent
@api 대신 이벤트 사용.
- **자식:** 데이터를 담은 이벤트 생성·dispatch.
```javascript
// child.js
sendData() {
    this.dispatchEvent(new CustomEvent('messagefromchild', { detail: 'some data' }));
}
```
- **부모(HTML):** 이벤트 수신.
```html
<c-child onmessagefromchild={handleMessage}></c-child>
```
- **부모(JS):** 이벤트 처리·데이터 접근.
```javascript
handleMessage(event) {
    const data = event.detail;
}
```
