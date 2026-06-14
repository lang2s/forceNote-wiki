# Salesforce Lightning Components 튜토리얼

## Salesforce 소개
Salesforce는 클라우드 기반 CRM. 영업·서비스·마케팅에 사용. 장점: 빠름(몇 달 내 배포), 쉬움, 효과적(커스터마이즈).

**앱 구축 2가지:** ① Classic Application Architecture(모바일 클라이언트), ② Lightning Application Architecture(모든 디바이스, 단일 페이지 앱·동적).

## Lightning 소개
컴포넌트 기반 프레임워크. UI 개발·동적 웹 앱(모바일·데스크톱). Single Page Application 아키텍처. 3구성: 클라이언트(JavaScript), Salesforce Cloud, 서버(Apex Controller). Aura Component 기반.

**사용 이유:** 기본 제공 컴포넌트, 빠른 성능, 이벤트 기반, 반응형·재사용, 크로스 브라우저, 아름다운 UI.

**배포 가능:** Lightning Experience, Salesforce1 앱, Lightning 페이지·앱, Visualforce, Lightning Out, 독립 앱, Community Builder, Lightning 탭, 모바일 하이브리드 SDK. (외부 사이트 불가)

## 아키텍처 구성
1. **Lightning Application:** 여러 컴포넌트를 담는 독립 페이지(HTML 유사 마크업, Developer Console).
2. **Lightning Component:** 앱 내 마크업 컴포넌트(Helper·Controller·Style·Documentation·SVG·Renderer·Design).
3. **Controller (JS):** 액션 기능 정의.
```javascript
({
    handleClick : function(cmp, event) {
        var attributeValue = cmp.get("v.text");
        var target = event.getSource();
        cmp.set("v.text", target.get("v.label"));
    }
})
```
4. **Helper (JS):** Apex·앱 측 연결.
5. **Apex Controller:** 페이지 로직(argument 없는 생성자, static 메서드).
6. **CSS:** 스타일링.

## 컴포넌트·앱 생성
**컴포넌트:**
```xml
<aura:component>
    <h1>Lightning Application Tutorial</h1>
    <p>TrailheadTitans.com</p>
</aura:component>
```
**애플리케이션(컴포넌트 임베드, c는 기본 네임스페이스):**
```xml
<aura:application>
    <h1>My first lightning application</h1>
    <c:My_first_lightcomponent/>
</aura:application>
```
컴포넌트 번들에서 Preview로 출력 확인.

## 속성과 표현식
**Attribute:** 값을 저장하는 변수(`<aura:attribute>`). 명명 규칙: 알파벳/언더스코어로 시작, 영숫자·언더스코어만.
**Expression:** 속성 값·정보로 계산·동적 출력. `{!v.whom}`. 대소문자 구분.

**속성 유형:** 기본, 함수, 객체, 표준·커스텀, 컬렉션, 커스텀 Apex 클래스, 프레임워크 특정.

## 컨트롤러로 액션 처리
**Action:** 특정 작업 수행 함수.
```xml
<lightning:button label="Click Me" onclick="{!c.handleClick}" />
```
**Event:** 액션 수행 시 알림. 클라이언트 측 컨트롤러(JS)가 제어.
```javascript
({
    myAction : function(cmp, event, helper) { /* 액션 */ },
    anotherAction : function(cmp, event, helper) { /* 액션 */ }
})
```
각 함수 3개 매개변수: cmp(컨트롤러를 가진 컴포넌트), event(액션 처리), helper(선택, 재사용).

`getSource()`는 어느 컴포넌트에서 이벤트가 발생했는지 판단하는 내장 이벤트.

## 폼으로 데이터 입력
SLDS(Salesforce Lightning Design System)를 Lightning 컴포넌트에서 활성화(독립 앱에는 없음). 예: 비용 계산 폼.

## 서버 측 컨트롤러 연결
Apex Controller로 Salesforce 데이터 로드·저장. @AuraEnabled 메서드만 노출.

## 이벤트로 컴포넌트 연결
컴포넌트 이벤트·애플리케이션 이벤트로 컴포넌트 간 통신.

## 환경 설정
developer.salesforce.com에서 가입 → 필드 입력 → public 이메일·기억하기 쉬운 username → 구독 동의 → 이메일로 비밀번호 변경.
