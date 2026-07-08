---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [LWC interview Q &A]
---

# LWC Q&A 질문과 답변

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**Q1. Aura vs LWC?**

Aura는 Aura 프레임워크, LWC는 현대 웹 표준(JavaScript·Shadow DOM). LWC가 성능·번들 크기·생산성 우수. 경량·표준 기반.

**Q2. LWC 정의·구성?**

HTML DOM의 커스텀 element. 3구성: HTML 템플릿(구조), JavaScript 클래스(동작·데이터), CSS(선택, 외관).
```html
<template><p>Hello, LWC!</p></template>
```
```javascript
import { LightningElement } from 'lwc';
export default class MyComponent extends LightningElement {}
```

**Q3. XML(메타데이터) 역할?**

컴포넌트 구성·메타데이터 정의(이름·설명·target config·접근 설정). 배포·관리에 중요.

**Q4. 이벤트로 통신?**

컴포넌트 간 이벤트. component event(표준), custom event(전용).
```javascript
// 자식: this.dispatchEvent(new CustomEvent('customclick'));
// 부모: <c-child-component oncustomclick={handleCustomClick}>
```

**Q5. @api?**

속성·메서드를 다른 컴포넌트에 노출(composition·재사용). 점 표기·중괄호로 접근.

**Q6. 데이터 바인딩?**

템플릿과 JS 클래스 속성 연결·자동 동기화. 단방향·양방향. Aura는 표현식, LWC는 반응형 속성.

**Q7. DOM 조작?**

대부분 불필요(반응형 렌더링). 필요 시 `this.template.querySelector('[data-id="info"]')`.

**Q8. Wire 어댑터 데이터 조회?**
```javascript
import getContacts from '@salesforce/apex/ContactController.getContacts';
@wire(getContacts) contacts;
```

**Q9. Wire vs Imperative?**

Wire는 선언적·캐싱·자동 새로고침·실시간(Platform Event·empAPI). Imperative는 JS에서 직접 호출(수동 캐싱·오류·데이터 처리).

**Q10. 오류 처리?**

try-catch·lightning-messages·ShowToastEvent·Platform/custom event.

**Q11. CSS?**

인라인·CSS 파일·`:host` 선택자.

**Q12. LMS?**

LWC·Aura 간, LWC끼리 pub-sub 통신.
```javascript
import { publish, MessageContext } from 'lightning/messageService';
import MY_MESSAGE_CHANNEL from '@salesforce/messageChannel/MyMessageChannel__c';
@wire(MessageContext) messageContext;
// 발행: publish(this.messageContext, MY_MESSAGE_CHANNEL, message);
// 구독: subscribe(this.messageContext, MY_MESSAGE_CHANNEL, (message) => {...});
```

**Q13. 라이프사이클 훅?**

connectedCallback·renderedCallback·disconnectedCallback·errorCallback. 초기화·데이터 조회·DOM 조작·정리.

**Q14. 페이지네이션·무한 스크롤?**

클라이언트·서버 측 조합으로 부분 조회.

**Q15. 클라이언트 캐싱?**

@wire의 cacheable.

**Q16. 내비게이션?**

NavigationMixin·lightning/navigation.

**Q17. 입력 검증?**

lightning-input 검증 속성·reportValidity().

**Q18. Imperative Apex 호출?**

import 후 then/catch.

**Q19. 표준 vs 커스텀 컴포넌트?**

표준은 Salesforce 제공(lightning-button 등), 커스텀은 직접 개발.

**Q20. Component Composition?**

작은 컴포넌트 조합으로 복잡한 컴포넌트(재사용·모듈성·중첩).

**Q21. 재사용성·모듈성?**

컴포넌트 기반 개발, @api·@wire·@track으로 통신·공유.

**Q22. 단위 테스트?**

Jest + @salesforce/lwc-jest.

**Q23. 접근성?**

시맨틱 HTML·ARIA, 이미지 대체 텍스트, 키보드 내비게이션, 색 대비, 스크린 리더 테스트.

**Q24. LDS?**

Apex 없이 데이터 접근·수정·캐싱. CRUD·자동 UI 업데이트.

**Q25. 서드파티 라이브러리?**

lightning/platformResourceLoader의 loadScript·loadStyle.

**Q26. Imperative vs Reactive 프로그래밍?**

Imperative는 순차 명시, Reactive는 의존성 선언·데이터 변경 시 자동 UI 업데이트.

**Q27. Lightning 이벤트?**

표준·커스텀. lightning/messageService, on 디렉티브·addEventListener.

**Q28. LWC + Aura 같은 페이지?**

Lightning Out.

**Q29. 성능 최적화?**

wire 호출 최소화, cacheable 캐싱, 페이지네이션·지연 로딩, 불필요한 DOM 업데이트 감소, 효율적 JS, 오류 처리.

**Q30. 오류 표시?**

errorCallback·커스텀 오류 속성·lightning-messages·toast.

**Q31. Lightning App Builder?**

시각적 페이지 디자인 도구(드래그앤드롭).

**Q32. 폼 제출·바인딩?**

value 속성·onchange 이벤트, 제출 시 검증·저장.

**Q33. 조건부 렌더링?**

if:true·if:false·template for:each.

**Q34. meta.xml?**

메타데이터·구성(label·설명·접근·target config). 배포·관리.

**Q35. 인증·권한?**

플랫폼 인증(username-password·SSO·소셜), 권한 집합·프로필·공유 규칙.

**Q36. Parent-Child 통신?**

부모→자식(속성), 자식→부모(이벤트).

**Q37. 데이터 조작·변환?**

JS 메서드(map·filter·reduce)·헬퍼 함수. 반응형으로 UI 자동 업데이트.

**Q38. 동기 vs 비동기?**

동기는 순차·블로킹, 비동기는 응답 대기 중 계속 실행(서버 호출·이벤트·장기 작업).

**Q39. 관계 없는 컴포넌트 데이터 공유?**

LMS(공통 message channel 발행·구독).

**Q40. @track?**

반응형 속성(값 변경 시 재렌더링). 기본 반응형이나 배열·객체에 명시.

**Q41. API 통합?**

fetch 또는 Apex 콜아웃.

**Q42. LWC > Aura 장점?**

성능·표준·생산성·작은 번들.

**Q43. Salesforce 데이터 조회?**

@wire 또는 imperative.

**Q44. 페이지네이션?**

클라이언트·서버 측 조합.

**Q45. 클라이언트 캐싱?**

@wire의 cacheable.

**Q46. Slots?**

부모가 자식에 마크업·콘텐츠 전달.

**Q47. 비동기·콜백?**

promise·async/await.

**Q48. 서드파티 JS?**

loadScript로 import.

**Q49. 이벤트 전파·버블링?**

stopPropagation()·preventDefault().

**Q50. 종속 선택 목록?**

lightning/uiObjectInfoApi(getPicklistValues·controllerValues).
