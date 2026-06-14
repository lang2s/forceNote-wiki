---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Lightning Components Cheatsheet]
---

# Lightning Components(Aura) 치트시트

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 개요
Lightning Component 프레임워크로 Force.com 앱의 반응형 UI 구축. 클라이언트=JavaScript, 서버=Apex. Aura 오픈소스 프레임워크 기반.

## 시작
1. Setup → Develop → Lightning Components → Enable 체크.
2. Developer Console → File > New > Lightning Application.
```xml
<aura:application> <!--helloComponent.cmp-->
    <h1>Hello App</h1>
    <ns:helloComponent />
</aura:application>
<aura:component>
    <h1>Hello Lightning!</h1>
</aura:component>
```

## 컴포넌트 번들
Controller(클라이언트 액션), Helper(공유 JS), Renderer(커스텀 렌더러), Styles(CSS).

## 표현식
`{!...}` 구문. `{!c.change}`(클라이언트 컨트롤러 호출), `{!v.myText}`(속성 값), `{!v.body}`(컴포넌트 body).

## 클라이언트 측 컨트롤러
```xml
<aura:component>
    <aura:attribute name="myText" type="String" default="A string waiting to change"/>
    {!v.myText}
    <ui:button label="Go" press="{!c.change}"/>
</aura:component>
```
```javascript
change : function(cmp, event, helper) {
    cmp.set("v.myText", "new string");
    helper.doSomething(cmp);
}
```

## App Events
```xml
<aura:event type="APPLICATION">
    <aura:attribute name="myObj" type="namespace.MyObj__c"/>
</aura:event>
```
```javascript
// 발생
var myEvent = $A.get("e.namespace:theEvent");
myEvent.setParams({ "myObj": myObj}).fire();
// 핸들러
<aura:handler event="namespace:theEvent" action="{!c.updateEvent}"/>
```

## 초기화 액션
```xml
<aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
```

## CSS
`.THIS` 선택자로 스타일 충돌 방지(런타임에 컴포넌트명으로 대체).

## 컴포넌트 ID로 찾기
`aura:id`로 로컬 ID 설정, `cmp.find("button1")`로 찾기.

## 공통 JS 함수
- 값 조회: `cmp.get("v.myString")`
- 값 설정: `cmp.set("v.myString", "...")`
- 이벤트 매개변수 조회: `myEvt.getParam("myAttr")`
- 이벤트 매개변수 설정: `myEvt.setParams({...}).fire()`

## 핵심 요소
aura:application, aura:attribute, aura:component, aura:event, aura:iteration, aura:if, aura:renderIf, aura:set, aura:text.

## 핵심 폼
ui:button, ui:inputCheckbox, ui:inputDate, ui:inputDateTime, ui:inputEmail, ui:inputNumber, ui:inputPhone, ui:inputText.

## 핵심 출력
ui:outputCheckbox, ui:outputDate, ui:outputDateTime, ui:outputEmail, ui:outputNumber, ui:outputPhone, ui:outputText.

## $A 메서드
$A.get(앱 이벤트), $A.enqueueAction(배치 실행 큐), $A.log(오류 로그), $A.newCmpAsync(동적 컴포넌트 생성), $A.run.

## Apex 컨트롤러 연동
서버 측 메서드는 static·@AuraEnabled.
```apex
public class OpportunityController {
    @AuraEnabled
    public static List<Opportunity> getOpportunities() {
        return [SELECT Id, Name, CloseDate FROM Opportunity];
    }
}
```
컴포넌트 연결: `<aura:component controller="myNamespace.MyApexController">`
```javascript
"getOpps" : function(component) {
    var a = component.get("c.getOpportunities");
    a.setCallback(this, function(action) {
        if (action.getState() === "SUCCESS") alert(action.getReturnValue());
    });
    $A.enqueueAction(a);
}
```

## Salesforce1 통합
`<aura:component implements="force:appHostable">` — Salesforce1 모바일 앱에서 사용 가능(커스텀 탭 생성·내비게이션 추가).
