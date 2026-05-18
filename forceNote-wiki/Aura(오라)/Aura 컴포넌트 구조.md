---
tags: [aura, lightning-components, component-bundle, markup, attribute]
source: lightningAura.pdf
created: 2026-05-19
aliases: [Aura 번들, Aura Bundle, Aura 컴포넌트, aura:component, aura:attribute]
---

# Aura 컴포넌트 구조

> Aura 컴포넌트는 번들(Bundle) 단위로 관리되며, .cmp 마크업 + JS 컨트롤러/헬퍼 + CSS 등 여러 파일로 구성된다.

---

## 컴포넌트 번들 구성 파일

| 파일 | 역할 | 필수 여부 |
|---|---|---|
| `myComponent.cmp` | 컴포넌트 마크업 (HTML + Aura 태그) | ✅ 필수 |
| `myComponentController.js` | 클라이언트 이벤트 핸들러 (action) | 선택 |
| `myComponentHelper.js` | 재사용 JS 함수 (Controller에서 호출) | 선택 |
| `myComponentRenderer.js` | 기본 렌더링 동작 오버라이드 | 선택 |
| `myComponent.css` | 컴포넌트 전용 CSS 스타일 | 선택 |
| `myComponent.design` | Lightning App Builder / Flow Builder 노출 설정 | 선택 |
| `myComponent.auradoc` | 컴포넌트 문서 | 선택 |
| `myComponent.svg` | App Builder용 커스텀 아이콘 | 선택 |

모든 파일은 **컴포넌트 이름 기반 자동 연결(auto-wired)**된다.

---

## 기본 마크업 구조

```xml
<!-- myComponent.cmp -->
<aura:component controller="MyApexController" implements="flexipage:availableForAllPageTypes">

    <!-- 속성 선언 -->
    <aura:attribute name="title" type="String" default="Hello"/>
    <aura:attribute name="items" type="List"/>

    <!-- 이벤트 등록 -->
    <aura:registerEvent name="itemSelected" type="c:myEvent"/>

    <!-- 초기화 핸들러 -->
    <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>

    <!-- 마크업 -->
    <div class="slds-card">
        <h2>{!v.title}</h2>
        <aura:iteration items="{!v.items}" var="item">
            <p>{!item.Name}</p>
        </aura:iteration>
        <lightning:button label="Click" onclick="{!c.handleClick}"/>
    </div>

</aura:component>
```

---

## aura:attribute — 속성 선언

```xml
<!-- 기본 타입 -->
<aura:attribute name="message" type="String" default="Hello"/>
<aura:attribute name="count" type="Integer" default="0"/>
<aura:attribute name="isVisible" type="Boolean" default="true"/>
<aura:attribute name="price" type="Decimal"/>

<!-- SObject 타입 -->
<aura:attribute name="account" type="Account"/>
<aura:attribute name="expense" type="Expense__c"
    default="{ 'sobjectType': 'Expense__c', 'Name': '', 'Amount__c': 0 }"/>

<!-- 컬렉션 타입 -->
<aura:attribute name="contacts" type="Contact[]"/>
<aura:attribute name="data" type="List"/>
<aura:attribute name="config" type="Map"/>
```

속성 값 읽기: `{!v.attributeName}` (마크업), `component.get("v.attributeName")` (JS)
속성 값 쓰기: `component.set("v.attributeName", newValue)` (JS)

---

## 클라이언트 컨트롤러 (Controller.js)

```javascript
// myComponentController.js
({
    // 초기화 핸들러
    doInit: function(component, event, helper) {
        helper.loadData(component);
    },

    // 버튼 클릭 핸들러
    handleClick: function(component, event, helper) {
        var buttonLabel = event.getSource().get("v.label");
        component.set("v.message", "Clicked: " + buttonLabel);
    },

    // Apex 서버 호출
    saveRecord: function(component, event, helper) {
        var action = component.get("c.saveContact");  // Apex 메서드
        action.setParams({ contact: component.get("v.newContact") });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.message", "저장 완료");
            } else {
                console.error("Error:", response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})
```

---

## 헬퍼 (Helper.js)

```javascript
// myComponentHelper.js — Controller에서 공유 로직 분리
({
    loadData: function(component) {
        var action = component.get("c.getContacts");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.contacts", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    formatCurrency: function(amount) {
        return '$' + parseFloat(amount).toFixed(2);
    }
})
```

---

## 네임스페이스 규칙

| 상황 | 내 컴포넌트 참조 | 패키지 컴포넌트 참조 |
|---|---|---|
| 네임스페이스 없는 org | `<c:myComponent />` | `<pkgNs:theirComponent />` |
| 네임스페이스 있는 org | `<myNs:myComponent />` | `<pkgNs:theirComponent />` |

Salesforce 제공 base components: `lightning:button`, `lightning:card`, `lightning:input` 등 (`lightning` 네임스페이스)

---

## implements — 컴포넌트 노출 위치 지정

```xml
<!-- Lightning Experience 모든 페이지 -->
<aura:component implements="flexipage:availableForAllPageTypes">

<!-- 레코드 페이지 -->
<aura:component implements="flexipage:availableForRecordHome">

<!-- Salesforce 모바일 앱 -->
<aura:component implements="forceCommunity:availableForAllPageTypes">

<!-- 빠른 실행 버튼 (Quick Action) -->
<aura:component implements="force:lightningQuickAction">
```

---

## 관련 노트

- [[Aura 이벤트]] — Component/Application Event 패턴
- [[Aura vs LWC]] — 신규 개발 방향 결정
- [[LWC/LWC MOC]] — Lightning Web Components
