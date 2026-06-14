---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [The Ultimate guide to mastering in LWC]
---

# LWC 마스터 완전 가이드 (Q&A)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 원본은 이미지 PDF로 OCR 추출했습니다. 질문 1~62는 "SALESFORCE LWC INTERVIEW QUESTIONS & ANSWERS"와 동일하며, 여기서는 핵심 코드 예제를 함께 정리합니다.

**1. LWC 구조?**

HTML·JS·CSS·XML.

**2. 각 부분?**

HTML(마크업), JS(로직·동작), CSS(스타일), XML(메타데이터·target).

**3. 명명 규칙?**

camelCase 시작·소문자, 영숫자·언더스코어(대시 불가), HTML 참조는 kebab-case. 예: `myVariableName` ↔ `my-variable-name`.

**4. SLDS?**

Salesforce Lightning Design System.

**5. LWC 장점?**

네이티브 웹 표준, 성능·빠른 렌더링, 단순 개발·디버깅.

**6. 두 LWC 통신?**

Parent→Child(@api), Child→Parent(custom event).

**7. 이벤트?**

컴포넌트 통신. 표준(click·change), 커스텀(정의·dispatch).

**8. 이벤트 버블링?**

자식에서 DOM 트리 위로 전파.

**9. 데코레이터?**

@api, @track, @wire.

**10. 각 데코레이터?**

@api(public·통신), @track(배열·객체 깊은 변경 추적), @wire(데이터 상호작용).

**11. Parent→Child (@api):**
```javascript
// childComp.js
import { LightningElement, api } from 'lwc';
export default class ChildComp extends LightningElement {
    @api messageFromParent;
}
```
```html
<!-- childComp.html -->
<template>
    <lightning-card title="Child Component"><div>{messageFromParent}</div></lightning-card>
</template>
<!-- 부모: <c-child-comp message-from-parent={message}></c-child-comp> -->
```

**12. Child→Parent (custom event):**
```javascript
// childComp.js
import { LightningElement } from 'lwc';
export default class ChildComp extends LightningElement {
    messageFromChild = '';
    handleChange(event) { this.messageFromChild = event.target.value; }
    handleClick() { this.dispatchEvent(new CustomEvent('send', { detail: this.messageFromChild })); }
}
```
```html
<!-- 부모 parentComp.html -->
<c-child-comp onsend={handleMessageFromChild}></c-child-comp>
```
```javascript
// parentComp.js
handleMessageFromChild(event) { this.messageRecieved = event.detail; }
```

**13. Promise?**

비동기 코드, 성공/실패. Pending·Fulfilled·Rejected.

**14. Apex 호출?**

wire(cacheable=true·캐시·DML 불가) 또는 imperative(DML 가능·promise).

**15. 라이프사이클 훅?**

constructor·connectedCallback·renderedCallback·disconnectedCallback·errorCallback.

**16. 조건부 렌더링?**

template if:true 또는 lwc:if·lwc:elseif·lwc:else.

**17. for:each vs map?**

for:each는 반복 중 업데이트(새 배열 미반환), map은 새 배열 반환.

**18. Aura↔LWC?**

Aura 안에 LWC 가능, 역은 불가.

**19. 버블링 vs 캡처링?**

bubbles·composed=true로 Shadow 경계 통과. 버블링 아래→위, 캡처링 위→아래.

**20. 독립 컴포넌트 통신?**

LMS(message channel·publisher·subscriber).

**21. 컴포넌트 안 보임 디버그?**

isExposed·target·Apex sharing·SOQL 모드·프로필 접근.

**22. Apex 없이 Contact 폼?**

lightning-record-form.

**23. 동적 property 값?**

meta xml의 targetConfig·property.

**25. LMS?**

관계 없는 컴포넌트·Aura·VF 통신.

**26. LDS?**

Apex 없이 데이터 상호작용.

**27. async vs await?**

async는 promise 반환 함수, await는 promise까지 일시정지.

**28. uiRecordApi?**

createRecord·deleteRecord·getFieldValue 등.

**29. @wire에서 DML?**

불가.

**30. super()?**

constructor에서 부모 클래스 호출.

**31. Component vs Application 이벤트?**

Component는 부모-자식, Application은 글로벌(pub-sub).

**32. promise.all vs race?**

all은 전체 충족, race는 먼저 settle.

**33. Deep vs Shallow copy?**

Shallow는 중첩 참조(스프레드), Deep은 JSON.stringify(JSON.parse()).

**34. reduce?**

단일 값 누적.

**35. Jest?**

LWC 단위 테스트(Aura 미지원).

**37. 데이터 바인딩?**

JS↔HTML 연결. 단방향·양방향.

**38. 기본 바인딩?**

단방향.

**39. 단방향?**

JS→HTML(읽기 전용·자식 전달).

**40. 양방향?**

UI↔JS(@track·이벤트).

**41. this?**

현재 컨텍스트(속성·메서드 접근).

**42. Lightning Data Table?**

표 형식(정렬·인라인 편집·페이지네이션).

**43. lightning-record-form?**

LDS 기반 레코드 폼(FLS·공유 처리).

**44. 조건부 렌더링?**

if:true·if:false.

**45. connectedCallback?**

DOM 삽입(부모→자식).

**46. renderedCallback?**

렌더링 후(자식→부모).

**47. disconnectedCallback?**

DOM 제거.

**48. 이벤트 전파?**

버블링·캡처링.

**49. 직렬화?**

객체→JSON 문자열.

**50. getRelatedListCount?**

관련 목록 수 조회.

**51. connectedCallback에 wire?**

불가.

**52. JSON.stringify?**

객체→JSON 문자열.

**53. 현재 사용자 ID(Apex 없이)?**

`import Id from '@salesforce/user/Id'`.

**54. Toast?**

ShowToastEvent.

**55. NavigationMixin?**

페이지·레코드·앱 내비게이션.

**56. VF에서 LWC?**

lightning:container.

**57. 선택 목록(Apex 없이)?**

getPicklistValues(lightning/uiObjectInfoApi).

**58. refreshApex()?**

수동 데이터 새로고침.

**59. reportValidity()?**

제출 전 검증.

**60. 특정 레코드 조회?**

getRecords wire 어댑터.

**61. wire 다중 호출?**

가능.

**62. Static Resource import?**

@salesforce/resourceUrl.
