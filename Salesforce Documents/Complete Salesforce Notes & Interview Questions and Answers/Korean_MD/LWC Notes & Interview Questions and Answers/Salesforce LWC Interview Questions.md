---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce LWC Interview Questions]
---

# Salesforce LWC 면접 질문

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**LWC란?** 웹 표준 기반 Lightning 컴포넌트 프레임워크. CSS·HTML·최신 JavaScript(ES7)·Shadow DOM·Custom Elements·Web Components.

**Aura가 있는데 LWC?** 추상화 계층 없어 더 빠른 렌더링·성능.

**LWC 장점?** 표준 기반 아키텍처·빠른 구축, 코드 재사용, 단위 테스트 지원, 개발 인재 접근성.

**Lightning vs LWC?** Aura는 HTML+JavaScript, LWC는 웹 스택 직접(React·Angular 등 다른 프레임워크 스킬 활용).

**LWC 제한?** Quick Action API, Custom/Global Actions, Related List View Actions, Chatter Extensions, Omni Toolkit API, Console API(Navigation Item·Workspace·Utility Bar), URL Addressable Tabs, 이메일 템플릿 사용 불가.

**Aura가 LWC 포함?** Aura 안에 LWC 가능, 역은 불가. 부모가 자식 속성 설정. facet·slot 이해 필요.

**Aura-LWC 통신?** 가능(통신 채널 이해 필요).

**Aura→LWC 데이터?** DOM 이벤트로 계층 상향, 계층 외는 Pub-Sub.

**양방향 바인딩?** LWC는 단방향, Aura는 양방향.

**두 컴포넌트 통신?** LMS(Publisher·Subscriber 컴포넌트).

**LWC 라이프사이클?** Constructor(부모→자식) → DOM 삽입 → connectedCallback(렌더링) → render(기능 오버라이드) → renderedCallback(자식→부모) → errorCallback → disconnectedCallback(Pub-Sub).

**한 속성에 다중 데코레이터?** 불가(한 번에 하나).

**콜백 함수?** 다른 함수에 인수로 전달되어 내부에서 호출되는 함수.

**데코레이터?** @api(public·반응형), @track(private 반응형), @wire(데이터 조회·재렌더링).

**Apex 변수 import?** 불가.

**파일 수?** 3개: .html·.js·.js-meta.xml.

**wire vs imperative?** wire는 A·B 변경 연동, imperative는 버튼 클릭 시 호출.

**Aura에서 LWC 호출?** LWC 함수를 @api로 public 선언, aura:id로 호출.

**Lightning Locker?** 네임스페이스별 컴포넌트 격리 보안 아키텍처.

**다중 wire 메서드?** 가능.

**Promise.all?** 비동기 메서드가 동기처럼 값 반환. 미래에 값 공급 약속.

**Lazy Loading?** 필요 시에만 데이터 로드. 무한 로딩으로 스크롤 시 부분 로드.

**Apex 새로고침?** refreshApex().

**async/await?** AsyncFunction 인스턴스. promise 체인 없이 깔끔한 비동기 코드.

**LightningElement?** 표준 HTML element의 커스텀 래퍼. extend해 LWC JS 클래스 생성(다른 클래스 extend 불가).

**Static Resource 호출?** `import myResource from '@salesforce/resourceUrl/...'`.

**디버거?** Lightning 디버그 모드 활성화 후 Chrome Sources 탭에서 브레이크포인트.

**표준 버튼 오버라이드?** Aura 가능, LWC 불가.

**@AuraEnabled?** Apex 컨트롤러 메서드 클라이언트·서버 접근 활성화(Lightning 컴포넌트 노출).

**@wire에 cacheable=true 필수?** 예.

**wire 강제 새로고침?** refreshApex.

**Custom Events?** Child→Parent 통신.

**Event Propagation?** 버블링·캡처링 2단계.

**앱에 LWC 포함?** meta.xml에 target 지정: lightning__AppPage, lightning__RecordPage, lightning__HomePage.

**Spinner?** lightning-spinner(SLDS).

**Toast 메시지?**
```javascript
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const toastEvent = new ShowToastEvent({
    title: 'Success!', message: 'Contact List Updated',
    variant: 'success', mode: 'dismissable'
});
```

**VF에 LWC 포함?** Aura에 LWC 추가 후 Lightning Out으로 VF에.

**리스트 반복?** for:each·iterator.
