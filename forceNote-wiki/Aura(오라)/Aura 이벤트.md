---
tags: [aura, events, component-event, application-event, aura:event]
source: lightningAura.pdf
created: 2026-05-19
aliases: [Aura 이벤트, Aura Component Event, Aura Application Event, aura:event, aura:registerEvent, aura:handler]
---

# Aura 이벤트

> Aura 이벤트는 컴포넌트 간 데이터를 전달하는 핵심 메커니즘이다. Component Event(부모-자식 계층)와 Application Event(전역 pub/sub) 두 종류가 있다.

---

## 이벤트 유형 비교

| | Component Event | Application Event |
|---|---|---|
| **범위** | 컴포넌트 계층 (containment hierarchy) | 이벤트를 구독한 모든 컴포넌트 |
| **모델** | 부모-자식 직접 통신 | Publish-Subscribe |
| **권장** | ✅ 기본 권장 | 전역 수준 필요 시만 사용 |
| **type** | `type="component"` | `type="application"` |

> [!important] **항상 Component Event를 먼저 고려**한다. Application Event는 컴포넌트 간 직접 관계가 없는 경우(예: 특정 레코드 페이지 이동)에만 사용한다.

---

## Component Event

### 1. 이벤트 정의 (.evt 파일)

```xml
<!-- myEvent.evt -->
<aura:event type="COMPONENT" description="항목 선택 이벤트">
    <aura:attribute name="item" type="Object"/>
    <aura:attribute name="index" type="Integer"/>
</aura:event>
```

### 2. 이벤트 발생 (자식 컴포넌트)

```xml
<!-- childComponent.cmp -->
<aura:component>
    <aura:registerEvent name="itemSelected" type="c:myEvent"/>
    <lightning:button label="선택" onclick="{!c.handleSelect}"/>
</aura:component>
```

```javascript
// childComponentController.js
({
    handleSelect: function(component, event, helper) {
        var selectEvent = component.getEvent("itemSelected");
        selectEvent.setParams({
            item: component.get("v.currentItem"),
            index: 0
        });
        selectEvent.fire();
    }
})
```

### 3. 이벤트 처리 (부모 컴포넌트)

```xml
<!-- parentComponent.cmp -->
<aura:component>
    <aura:handler name="itemSelected" event="c:myEvent" action="{!c.handleItemSelected}"/>
    <c:childComponent />
</aura:component>
```

```javascript
// parentComponentController.js
({
    handleItemSelected: function(component, event, helper) {
        var selectedItem = event.getParam("item");
        var index = event.getParam("index");
        component.set("v.selectedItem", selectedItem);
    }
})
```

---

## Application Event

### 1. 이벤트 정의

```xml
<!-- appNavigateEvent.evt -->
<aura:event type="APPLICATION" description="레코드 페이지 이동 이벤트">
    <aura:attribute name="recordId" type="String"/>
</aura:event>
```

### 2. 이벤트 발생

```javascript
// 어떤 컴포넌트의 Controller.js
({
    navigateToRecord: function(component, event, helper) {
        var navEvent = $A.get("e.c:appNavigateEvent");
        navEvent.setParams({ recordId: component.get("v.recordId") });
        navEvent.fire();
    }
})
```

### 3. 이벤트 처리 (어느 컴포넌트에서든)

```xml
<!-- anyComponent.cmp -->
<aura:component>
    <aura:handler event="c:appNavigateEvent" action="{!c.handleNavigation}"/>
</aura:component>
```

---

## Salesforce 표준 이벤트 활용

```javascript
// 레코드 페이지 이동 (force:navigateToSObject)
({
    navigateToRecord: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({ recordId: component.get("v.recordId") });
        navEvt.fire();
    },

    // 토스트 메시지 표시 (force:showToast)
    showSuccess: function(component, event, helper) {
        var toastEvt = $A.get("e.force:showToast");
        toastEvt.setParams({
            title: "성공",
            message: "저장되었습니다.",
            type: "success"
        });
        toastEvt.fire();
    },

    // 레코드 편집 모달 열기 (force:editRecord)
    editRecord: function(component, event, helper) {
        var editEvt = $A.get("e.force:editRecord");
        editEvt.setParams({ recordId: component.get("v.recordId") });
        editEvt.fire();
    }
})
```

---

## 초기화 / 시스템 이벤트

```xml
<aura:component>
    <!-- 컴포넌트 초기화 완료 시 -->
    <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>

    <!-- 속성 변경 시 -->
    <aura:handler name="change" value="{!v.items}" action="{!c.handleItemsChange}"/>

    <!-- 렌더링 완료 시 -->
    <aura:handler name="render" value="{!this}" action="{!c.onRender}"/>
</aura:component>
```

---

## 관련 노트

- [[Aura 컴포넌트 구조]] — 컴포넌트 번들 구조
- [[Aura vs LWC]] — LWC의 CustomEvent와 비교
- [[LWC/Events(이벤트)/index]] — LWC 이벤트 패턴
