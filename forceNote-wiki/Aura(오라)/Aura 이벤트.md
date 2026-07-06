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

## 이벤트 전파 단계 (Propagation Phases)

DOM 이벤트 처리 패턴과 유사한 전파 단계가 있으며, **Component Event는 2단계, Application Event는 3단계**로 전파된다. 이벤트를 발생시킨 컴포넌트를 **source component**라 한다.

| 단계 | Component Event | Application Event |
|---|---|---|
| **1. Capture** | ✅ 애플리케이션 루트 → source 방향으로 내려가며(trickle down) 핸들러 실행 | ✅ 동일 |
| **2. Bubble** | ✅ source → 애플리케이션 루트 방향으로 올라가며 핸들러 실행 | ✅ 동일 |
| **3. Default** | ❌ 없음 | ✅ 루트 노드의 서브트리 전체에서 **비결정적 순서**로 핸들러 실행 (프레임워크 원래 동작 보존) |
| **핸들러 기본 phase** | `bubble` | `default` |

### phase별 핸들러 등록 — `phase` 속성

```xml
<!-- Component Event: 기본은 bubble. capture 단계에서 처리하려면 -->
<aura:handler name="compEvent" event="c:compEvent"
    action="{!c.handleCapture}" phase="capture"/>

<!-- Application Event: 기본은 default. capture/bubble 단계에서 처리하려면 -->
<aura:handler event="c:appEvent"
    action="{!c.handleApplicationEvent}" phase="bubble"/>
```

### stopPropagation / preventDefault / pause

- `event.stopPropagation()` — 이후 컴포넌트로의 전파를 중단한다. Capture 단계에서 호출하면 bubble 단계 핸들러도 호출되지 않는다. **Application Event에서는** 전파를 중단한 컴포넌트가 default 단계의 **루트 노드**가 된다 (중단이 없으면 루트 노드 = 애플리케이션 루트).
- `event.preventDefault()` — (Application Event) capture/bubble 단계에서 호출하면 **default 단계 핸들러 실행 자체를 취소**한다.
- `event.pause()` / `event.resume()` — 비동기 코드 실행 결과에 따라 전파 여부를 결정해야 할 때 전파를 일시정지/재개한다. capture·bubble 단계에서 호출 가능.

```javascript
// 전파 중단 예시 (소스: eventBubblingGrandchild 컨트롤러)
({
    handleBubbling: function(component, event, helper) {
        event.stopPropagation();
    }
})
```

### 기본 전파 규칙 — owner만 처리, container는 includeFacets

capture/bubble 단계에서 계층의 **모든 부모가 이벤트를 처리할 수 있는 게 아니다.** 기본적으로 이벤트는 containment 계층의 **owner**에게만 전파된다.

- **owner** = 그 컴포넌트를 생성한 컴포넌트. 선언적 생성이면 이벤트를 발생시키는 컴포넌트를 마크업에 참조하는 **가장 바깥 컴포넌트**, 프로그래밍 방식 생성이면 `$A.createComponent`를 호출한 컴포넌트.
- **container component** = 다른 컴포넌트를 포함하지만 owner가 아닌 컴포넌트 (`Aura.Component[]` 타입 facet — 예: `{!v.body}` — 로 렌더링). 기본적으로 이벤트를 처리할 수 **없다**.
- container가 처리하게 하려면 `<aura:handler>`에 `includeFacets="true"` 추가:

```xml
<aura:handler name="bubblingEvent" event="c:compEvent"
    action="{!c.handleBubbling}" includeFacets="true"/>
```

---

## getParam()이 undefined일 때 — 흔한 원인 체크리스트

```
□ setParams 키 ↔ .evt attribute name 불일치
  — setParams({...})의 파라미터명은 이벤트 .evt의 <aura:attribute name="...">과 정확히 일치해야 한다.
    불일치한 키로 set하면 getParam("attribute명")이 undefined.
□ (Component Event) registerEvent name ↔ handler name 불일치
  — <aura:handler>의 name은 이벤트를 발생시키는 컴포넌트의 <aura:registerEvent> name과 일치해야 한다.
□ (Application Event) 핸들러에 name 속성을 넣음
  — Application Event 핸들러는 <aura:handler>에 name을 설정하면 동작하지 않는다.
    name은 Component Event 전용. (registerEvent 쪽의 name은 필수 문법이지만 Application Event에서는 사용되지 않음)
□ 이벤트 인스턴스 획득 방식 혼동
  — Component Event: cmp.getEvent("evtName") / Application Event: $A.get("e.ns:appEvent"). 서로 다르다.
□ 상위 단계에서 stopPropagation() 호출
  — capture 단계의 어떤 핸들러가 전파를 중단하면 내 핸들러(bubble/default)까지 이벤트가 도달하지 않는다.
□ (Application Event) preventDefault() 호출
  — default 단계 핸들러(phase 미지정 핸들러의 기본)가 아예 실행되지 않는다.
□ owner가 아닌 container 컴포넌트에서 처리 시도
  — includeFacets="true" 없이는 container에 이벤트가 전파되지 않는다.
□ fire() 전에 setParams를 호출했는지 확인
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
