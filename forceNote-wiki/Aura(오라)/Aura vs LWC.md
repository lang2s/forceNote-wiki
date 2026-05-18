---
tags: [aura, lwc, migration, comparison, decision]
source: lightningAura.pdf
created: 2026-05-19
aliases: [Aura LWC 비교, Aura vs LWC, LWC 마이그레이션, Aura 마이그레이션]
---

# Aura vs LWC

> **신규 개발은 항상 LWC를 선택**한다. Aura가 지원하지 않는 기능이 필요한 경우에만 Aura를 사용한다.

---

## 핵심 원칙 (공식 가이드라인)

> [!important] **"Always choose Lightning Web Components unless you need a feature that isn't supported."**
> — Lightning Aura Components Developer Guide, v67.0

---

## 기능 비교표

| 기능 | Aura | LWC |
|---|---|---|
| **개발 모델** | 프레임워크 기반 (`.cmp`, `.js`, `.css`) | 웹 표준 (HTML, JS class, CSS) |
| **성능** | 상대적으로 무거움 | 더 빠름 (native web components) |
| **학습 곡선** | Aura 전용 문법 필요 | 일반 JS/HTML 지식으로 접근 가능 |
| **이벤트** | `aura:event` (.evt 파일) | `CustomEvent`, `dispatchEvent()` |
| **속성 바인딩** | `{!v.attributeName}` | `{attributeName}` |
| **Apex 호출** | `component.get("c.method")` + callback | `@wire` 또는 `import` + `async/await` |
| **라이프사이클** | `init`, `render`, `afterRender` 등 | `connectedCallback`, `renderedCallback` 등 |
| **테스트** | 복잡 | Jest 기반 표준 테스트 |
| **TypeScript** | 미지원 | 지원 |
| **GitHub 오픈소스** | 비공개 | 공개 (github.com/salesforce/lwc) |

---

## 언제 Aura를 써야 하는가

| 상황 | 이유 |
|---|---|
| 기존 Aura 컴포넌트 유지보수 | 전체 마이그레이션 비용 대비 득실 판단 필요 |
| Aura 전용 기능 사용 | LWC가 아직 지원하지 않는 일부 기능 |
| 레거시 코드베이스 통합 | 기존 Aura 앱과 깊이 통합된 경우 |

> [!note] LWC와 Aura는 **상호 운용 가능**하다. Aura 컴포넌트 안에 LWC 컴포넌트를 포함할 수 있다. (단, LWC 안에 Aura는 불가)

---

## 같은 기능 코드 비교

### 속성 선언 및 바인딩

```xml
<!-- Aura .cmp -->
<aura:attribute name="title" type="String" default="Hello"/>
<h1>{!v.title}</h1>
```

```html
<!-- LWC .html -->
<template>
    <h1>{title}</h1>
</template>
```

```javascript
// LWC .js
import { LightningElement, track } from 'lwc';
export default class MyComponent extends LightningElement {
    title = 'Hello';
}
```

---

### Apex 호출

```javascript
// Aura — callback 방식
({
    loadData: function(component, event, helper) {
        var action = component.get("c.getContacts");
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.contacts", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})
```

```javascript
// LWC — @wire 방식
import { LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';

export default class MyComponent extends LightningElement {
    @wire(getContacts)
    contacts;
}
```

---

### 이벤트 처리

```javascript
// Aura — Component Event
// 발생: selectEvent.fire()
// 처리: event.getParam("item")
```

```javascript
// LWC — CustomEvent
// 발생: this.dispatchEvent(new CustomEvent('itemselected', { detail: item }))
// 처리: event.detail
```

---

## 마이그레이션 전략

```
// 구조 예시 — 실제 동작 코드 아님
// 권장 마이그레이션 접근법:

1. 신규 기능 → 무조건 LWC로 작성
2. 기존 Aura → LWC를 점진적으로 교체 (리팩터링 필요 시)
3. Aura 앱 컨테이너 유지 + 내부 컴포넌트를 LWC로 교체 (가장 현실적)
4. Aura ↔ LWC 통신: LightningMessageChannel (LMS) 사용
```

---

## 관련 노트

- [[Aura 컴포넌트 구조]] — Aura 번들 구조 상세
- [[Aura 이벤트]] — Aura 이벤트 패턴
- [[LWC/LWC MOC]] — LWC 전체 가이드
