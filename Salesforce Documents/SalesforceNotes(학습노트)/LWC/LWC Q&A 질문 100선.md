---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [100+ Interview Q &A  LWC]
---

# LWC Q&A 질문 100선

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**Dev Hub 용도?** org에서 Dev Hub 활성화 시 다수의 scratch org 생성 가능.

**SLDS?** Salesforce Lightning Design System.

**LWC 데이터 바인딩?** 기본 단방향. JS 파일의 값을 property라 함. 템플릿에서 `{property}`로 접근(HTML에서는 attribute라 부름). 사용자 입력에 따라 UI 자동 업데이트는 Event Listener로(이벤트 발생·처리).

**this 키워드?** 클래스 내 property면 this 사용(현재 컨텍스트). `this.firstName = event.target.value`(targeted value).

**조건부 렌더링?** 조건에 따라 컴포넌트 표시/숨김.

**다중 항목 반복?** for:each, Iterator. key 디렉티브 필수(고유 ID, 변경된 항목만 재렌더링).

**다중 템플릿 렌더링?** if:true로 컴포넌트 상태 기반 조건부 표시(showTemplate1·showTemplate2).

**컴포넌트 통신(4가지)?** Parent→Child, Child→Parent, 두 별도 컴포넌트 간, LWC↔Aura.

**데코레이터?** ECMAScript의 일부, 기능 추가(@ 접두, lwc에서 import). @api(public 속성), @wire(Apex·wire 어댑터 연결), @track(반응형, 재렌더링).

**Parent→Child 데이터?** 자식이 public API 선언(public 속성·메서드). @api 데코레이터로 속성 선언·import(값 변경 시 자동 재렌더링).

**라이프사이클 훅?** constructor·connectedCallback·render·renderedCallback·disconnectedCallback·errorCallback. (renderedCallback·errorCallback은 LWC 전용, 나머지는 HTML custom element 사양)

**라이프사이클 순서:** ① 부모 constructor → ② 부모 public 속성 설정 → ③ 부모 DOM 삽입 → ④ 부모 connectedCallback → ⑤ 부모 render → ⑥ 자식 constructor → ⑦ 자식 public 속성 설정 → ⑧ 자식 DOM 삽입 → ⑨ 자식 connectedCallback → ⑩ 자식 render → ⑪ 자식 renderedCallback → ⑫ 부모 renderedCallback.

**라이프사이클 비유(피자 추적):** 주문(constructor) → 추적기 활성화(connectedCallback) → 진행 업데이트(renderedCallback) → 문제 발생(errorCallback) → 피자 도착(disconnectedCallback).

**constructor?** 컴포넌트 생성 시 첫 호출. super() 필수.

**connectedCallback?** DOM 삽입 시. DOM 요소 참조·API 호출·구독 설정.

**render?** 렌더링할 템플릿 결정(오버라이드). 조건부 다중 템플릿에 사용.

**renderedCallback?** 렌더링 후. DOM 조작.

**disconnectedCallback?** DOM 제거 시. 정리. (부모 제거 → 부모 disconnected → 자식 제거 → 자식 disconnected)

**errorCallback?** 자손 오류 시.

**라이프사이클 훅 용도?** 데이터 조회·초기화·오류 처리(errorCallback).

**render vs renderedCallback?** render는 렌더링 라이프사이클의 일부로 템플릿 반환, renderedCallback은 렌더링 완료 후 호출.

**wire vs imperative?** Wire는 자동·반응형(데이터 변경 시 재호출), Imperative는 수동·제어(클릭 시·DML 가능).

**Child→Parent 데이터?** custom event dispatch, 부모가 on 접두로 수신.

**관계 없는 컴포넌트 통신?** LMS(Lightning Message Service).

**Aura vs LWC 이벤트?** Aura는 component·application 이벤트, LWC는 표준 DOM 이벤트·CustomEvent.

**선언적 이벤트 리스너?** `<c-child onnotification={handleNotification}>`.

**이벤트 전파?** 버블링·캡처링.

**bubbles:false, composed:false(기본)?** 이벤트가 발생 컴포넌트 내에만 머물고 Shadow 경계 통과 불가.

**프로그래밍 이벤트 리스너?** `this.template.addEventListener('notification', this.handleNotification.bind(this))`.

**Apex 없이 데이터?** LDS, Base Lightning Component, Wire Service.

**Apex로 데이터?** import 메서드 → wire 속성/함수 또는 imperative 호출.

**Apex 메서드 노출?** static, global/public, @AuraEnabled.

**클라이언트 측 캐싱?** @AuraEnabled(cacheable=true). 데이터 조회만(변경 불가). 캐시 데이터로 성능 향상. @wire에 필수.

**wire로 Apex 메서드 연결?**
```javascript
import getContactList from '@salesforce/apex/ContactController.getContactList';
@wire(getContactList) contacts;  // contacts.data 또는 contacts.error
```
**wire 함수:**
```javascript
@wire(getContactList)
wiredContacts({ error, data }) {
    if (data) this.contacts = data;
    else if (error) this.error = error;
}
```
**동적 매개변수($):** `@wire(findContacts, { searchKey: '$searchKey' })` — $는 반응형(값 변경 시 재렌더링).

**Lightning App에 LWC 임베드?** `<c:myLwcComponent>` 구문.

**LWC 캐시 활성화?** @wire + getRecord·getListUi 어댑터(브라우저 캐시 자동).

**REST API in LWC?** fetch 메서드 또는 axios·jQuery.

**LMS 사용?** message channel 정의 → publish() → subscribe() (connectedCallback에서 구독, disconnectedCallback에서 해제).

**LDS 목적·장점?** Apex 없이 CRUD. 선언적 데이터 바인딩, 캐싱·자동 업데이트, 자동 CRUD, 자동 공유·FLS.

**Shadow DOM?** 컴포넌트 DOM 캡슐화(CSS·JS 누출 방지). this.template으로 접근(페이지 DOM 직접 접근 불가).

**stopPropagation vs preventDefault?** stopPropagation은 이벤트 전파 중단, preventDefault는 브라우저 기본 동작 방지.

**Quick Action 유형?** Screen actions(모달), Headless actions(JS 로직만). xml에 정의.

**LightningElement extend 이유?** HTMLElement의 커스텀 래퍼(라이프사이클 훅 포함).

**B↔C 통신(공통 부모 A)?** B→A 이벤트 발생 → A가 @api로 C에 데이터 전달.

**composed=true?** DOM 버블링·Shadow 경계 통과.

**@track 언제?** Spring 20 이후 기본 반응형이라 기본 타입 불필요, 배열·객체는 필요.

**다중 데코레이터?** 한 속성에 불가.

**LMS?** pub-sub 라이브러리(VF·Aura·LWC 간 DOM 통신).

**LWC에 Application Event?** 없음, LMS 사용.

**레코드 상세 페이지 내비게이션?** NavigationMixin.

**현재 사용자 ID(Apex 없이)?** `import Id from '@salesforce/user/Id'`.

**cacheable=true 메서드 imperative 호출?** 가능.

**cacheable=true에서 DML?** 불가(DMLLimitException).

**imperative 호출 시 캐시 새로고침?** getRecordNotifyChange(RecordIds)(cacheable=true 필요).

**"Cant assign to Read only property" 오류?** @api 속성 변경 시. 값을 clone 후 변경.

**다중 input/combobox/radio를 한 querySelector로?**
```javascript
const allValid = [...this.template.querySelectorAll('lightning-input,lightning-combobox,lightning-radio-group')];
```
(...) 스프레드로 NodeList를 배열로.

**오류·예외 처리?** try-catch 또는 onError(errorCallback).

**HTTP 콜아웃?** fetch API.

**App Builder 노출?** meta.xml에 isExposed=true.

**lightning-record-edit-form?** LDS로 레코드 필드 생성·보기·편집.

**형제 컴포넌트 통신?** 공통 부모의 custom event·속성.

**lightning/navigation?** 레코드·리스트·커스텀 페이지 내비게이션.

**LWC 단위 테스트?** Jest 프레임워크.

**DB 변경 추적·UI 새로고침?** LDS 변경은 getRecordNotifyChange(), 외부(트리거·Flow·API)는 CDC·Platform Event.

**data 속성 기반 쿼리?** 속성·값으로 컴포넌트 쿼리.

**lightning-datatable?** 표 형식 데이터 표시(커스터마이즈).

**@wire 데이터 못 받는 이유?** @AuraEnabled에 cacheable=true 누락.

**Quick Action에서 레코드 ID 참조?** lightning/pageReferenceUtils의 getRecordId.

**FLS 준수?** ① 표준 컴포넌트(lightning-record-form 등 자동 준수), ② Apex에 WITH SECURITY_ENFORCED, ③ Schema 메서드(isAccessible 등).
```apex
@AuraEnabled(cacheable=true)
public static Account getAccount(Id accountId) {
    return [SELECT Id, Name FROM Account WHERE Id = :accountId WITH SECURITY_ENFORCED];
}
```
