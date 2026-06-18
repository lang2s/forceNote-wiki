---
tags: [Security, SecureCoding, CSRF, Visualforce, Aura, LWC, 보안가이드, 위협모델]
source: secure_coding (Secure Coding Guide, v67.0 Summer '26)
created: 2026-06-18
aliases: [CSRF, Cross Site Request Forgery, 크로스사이트요청위조, 요청위조 방어, page load DML, action 속성 CSRF, Require CSRF protection on GET, 페이지 로드시 DML 위험, 링크 클릭만으로 데이터 바뀜, GET 요청에서 레코드 수정 막기]
---

# CSRF 방어

> CSRF는 인증된 사용자를 속여 의도치 않은 동작을 수행하게 하는 공격 — Salesforce는 form-based request를 대부분 자동 보호하나 page load 중 자동 실행되는 state-changing logic은 보호하지 않는다.

---

## 위협

CSRF(Cross Site Request Forgery)는 인증된 사용자를 속여 의도치 않은 동작을 수행하게 하는 공격이다. Salesforce에서는 인증 session을 악용해 record 수정, 설정 변경, business logic 트리거가 가능하다. 위협:
1. 보호되지 않은 VF page·Lightning component·custom Apex endpoint를 악용
2. 데이터 무결성·신뢰 손상

(Aura, LWC, VF, Flow 전반에 걸친 방어가 필요하다.)

**참고 링크:** Cross Site Request Forgery (CSRF) / The CSRF/XSRF FAQ / Cross-Site Request Forgeries.

---

## 플랫폼 제공 보호 — CSRF Considerations and Limitations

Salesforce는 대부분의 form-based request를 자동 보호한다. standard controller·method가 insert/update/delete/upsert를 **user interaction(버튼 클릭, form 제출) 시** 보호한다.

> **단 page load 중 자동 실행되는 state-changing logic에는 미적용된다:**
> - 페이지가 완전히 렌더되기 전에 실행되는 DML
> - VF page의 `action` 속성에서 호출된 메서드
> - Aura/LWC/VF의 component initialization code에서의 DML

---

## Secure Visualforce Pages

`<apex:page>`의 `action` 속성이나 controller 생성자 메서드는 page load 시 실행되어 **CSRF 보호를 우회**한다. user-triggered DML을 사용하고, `apex:actionFunction`을 onload 등 JS event로 호출하지 않는다.

> **Note:** VF page load에 DML이 필요하면 "Require CSRF protection on GET requests"를 선택한다.

취약 예제(원문):

```html
<apex:page controller="myClass" action="{!init}"/>
```
```apex
public void init() {
  delete acc; // page load 시 자동 실행 → CSRF 우회
}
```

안전 예제(원문) — 사용자 클릭 시에만 실행:

```html
<apex:commandButton action="{!deleteAccount}" value="Delete" />
```

---

## Secure Aura and LWC

component load 중에는 DML/state-changing을 금지하고 **read-only만** 허용한다. 대상 lifecycle: `init`, `connectedCallback`, `renderedCallback`, 생성자.

취약 Aura 예제(원문):

```javascript
// controller.js — doInit에서 state-changing 호출 (취약)
doInit : function(component, event, helper) {
  var action = component.get("c.updateField");
  $A.enqueueAction(action);
}
```

안전 Aura 예제(원문) — `doInit`은 read-only, state-changing은 user-triggered handler에서:

```javascript
doInit : function(component, event, helper) {
  var action = component.get("c.getSomething"); // read-only
  $A.enqueueAction(action);
},
handleClick : function(component, event, helper) {
  var action = component.get("c.updateField"); // user-triggered
  $A.enqueueAction(action);
}
```

---

## Secure Third-Party API Integrations

custom anti-CSRF token을 설계하고, `setRequestHeader()`로 XMLHttpRequest에 추가한다. 예제(원문):

```javascript
var o = XMLHttpRequest.prototype.open;
XMLHttpRequest.prototype.open = function(){
  var res = o.apply(this, arguments);
  var err = new Error();
  this.setRequestHeader('anti-csrf-token', csrf_token);
  return res;
};
```

---

## 관련 노트
- [[Lightning Security 모델]]
- [[XSS 방어]]
- [[Secure Coding 개요]]
- [[Platform Security FAQ]]
