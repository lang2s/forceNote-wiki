---
tags: [Security, SecureCoding, Lightning, Aura, LWC, CSP, LightningLocker, 보안가이드, 위협모델]
source: secure_coding (Secure Coding Guide, v67.0 Summer '26)
created: 2026-06-18
aliases: [Lightning Security, Lightning Locker, CSP Directives, Lightning component 보안, AuraEnabled 보안, with sharing controller, Lightning CRUD FLS, Lightning XSS, Lightning CSRF, unsafe attribute, secret inputs, LWC 보안 모델, AuraEnabled 메서드 권한 검사, Lightning 컴포넌트 안전하게 만들기, CSP 때문에 외부 리소스 차단]
---

# Lightning Security 모델

> third-party Lightning component/app은 Salesforce-authored 코드와 같은 origin을 공유하므로 Lightning Locker·특수 CSP·추가 security review가 적용된다 — CSP·sharing·CRUD/FLS·XSS·CSRF·redirect를 component 레벨에서 강제하는 모델.

---

## 위협 / 일반 고려사항

CSP 요구를 충족하고, server-side Apex의 CRUD/FLS·sharing을 강제하며, XSS·CSRF를 방어해 안전한 Lightning component/app을 개발한다.

third-party Lightning component/app은 특수 domain(lightning.force.com, lightning.com)에서 동작하며, **Salesforce-authored Lightning code(특히 setup.app, 민감 보안 설정 제어)와 origin을 공유**한다. VF는 다른 domain(force.com, Salesforce code 비공유)에서 동작한다. Lightning이 같은 origin이므로 third-party Lightning code에 증가된 제약이 적용된다 → **Lightning Locker** + 특수 CSP + AppExchange security review 추가 검토. **stricter CSP** 활성을 권장한다(Summer '18부터 기본, 이전 org은 아님).

> Lightning Web Security(LWS)의 격리 모델 상세는 [[Lightning Web Security (LWS)]] 참조. Lightning Locker 위협모델은 이 노트가 소관이다.

---

## Content Security Policy Directives (표, 셀 전수 — 원문)

| Directive | Summary |
|---|---|
| `default-src 'self'` | 리소스를 같은 domain(lightning.force.com/lightning.com)에서만 로드. |
| `script-src 'self'` | script는 같은 domain만(외부 script 로드 불가). static resource 사용. |
| `'unsafe-inline'` | inline JS는 CSP에서 차단되지 않으나 security review에서 차단(향후 CSP가 unsafe-inline 불허). inline JS 코드 작성 금지. |
| `object-src 'self'` | `<object>` `<embed>` `<applet>`는 같은 domain만(static resource). |
| `style-src 'self'` | CSS는 같은 domain만(static resource). |
| `img-src 'self'` | 이미지는 같은 domain만. |
| `img-src 'http:' 'https:' 'data:'` | 이미지는 http/https/data URI로. security review는 https 요구. |
| `style-src 'https:'` | CSS는 https로만. |
| `media-src 'self'` | audio/video는 같은 domain만. |
| `frame-ancestors https:` | https parent frame으로만 embed 가능. |
| `frame-src https:` | 모든 frame은 https로. |
| `font-src https: data:` | font는 https·data URI로. |
| `connect-src 'self'` | XHR callback·websocket은 같은 domain만 연결. |
| `'unsafe-eval'` | eval() 및 reflection 작업은 CSP에서 차단되지 않으나 AppExchange security review에서 차단. |

> **Note:** Spring '19(API 45.0)부터 LWC model + Aura Components model 2가지가 있다. 공존·interoperate 가능하다.

> CSP·Trusted URLs(CSPTrustedSite, Manage Trusted URLs)의 설정 상세는 [[CSP와 RemoteSite]] 참조.

---

## Additional Restrictions For JavaScript in Lightning Components (다단 표, 이미지 검증 완료 — 셀 전수)

> 표 dimension: row=Restriction, col=Aura Components / Lightning Web Components. 이미지로 셀 단위 검증 완료(transpose 아님 — 덤프 셀 매핑 그대로).

| Restriction | Aura Components | Lightning Web Components |
|---|---|---|
| component는 같은 namespace의 DOM element만 read/modify. data 전달은 public API로. | Aura attribute set, Aura method 호출, Aura/DOM event 사용. | `@api` decorator의 method·attribute 사용 또는 event 사용. |
| renderer 함수에서 event fire 금지. | No restriction. | controller method 또는 controller가 호출한 helper method에서 event fire. |
| render cycle 중 component attribute 변경 금지(render loop 방지). | controller method 또는 helper method에서 attribute 수정. | `renderedCallback`에서 자기 attribute 수정 금지. |
| script/link 태그 대신 리소스(script·stylesheet)를 적절히 로드. | `ltng:require` component 사용. | `lightning/platformResourceLoader` module 사용. |
| native window/document 함수 override 금지. | Aura component는 window/document 함수 override 금지. | LWC는 window/document 함수 override 금지. |
| inline JS는 component markup의 method에만 사용. | Aura: `<div onmouseover="{!c.myControllerFunction}">foo</div>` | LWC: `<div onmouseover={myComponentFunction}>foo</div>` |
| security review 제출 component는 모든 CSS·JS library를 static resource에 포함. | `$Resource` URL에서 `ltng:require`로 모든 library 로드. | `$Resource` URL에서 `lightning/platformResourceLoader`로 모든 library 로드. |

> (이미지로 확인: 표는 footer 73-74 두 페이지 합산이며 실제 7개 restriction row. Security with Lightning Locker 제약도 숙지 권장. security review 제출 시 minified가 아닌 source JS 포함.)

---

## Component Security Boundaries and Encapsulation

모든 `@AuraEnabled` 메서드를 **webservice interface로 취급**한다. 공격자가 임의 파라미터로 호출 가능하다고 가정한다. 파라미터: unsanitized로 SOQL에 넣지 말 것, field/object 접근 결정에 신뢰하지 말 것. sObject 수정 시 full CRUD/FLS + sharing check(server-side/Apex). VF와 달리 Lightning은 presentation layer가 CRUD/FLS를 해주지 않으므로, VF→Lightning 포팅 시 각 sObject 접근마다 CRUD/FLS check를 추가한다.

global/public attribute는 untrusted로 취급하고, innerHTML/`$().html()`로 직접 DOM 렌더를 금지한다. raw HTML write/href 설정 시 JS code에서 sanitized로 표시한다.

**session 인증:** Experience Cloud site user의 session 만료 후 AuraEnabled 메서드는 **site guest user로 invoke**된다 → guest user 접근을 부여/취소하거나 session time-out을 모니터링한다.

---

## Sharing in Apex Classes

**모든 controller class는 with sharing keyword를 사용한다. 예외 없음.** 권한 상승이 필요하면(예: 사용자가 미접근인 field의 summary) controller는 with sharing을 유지하되, 특정 Aura-enabled 메서드가 `without sharing`을 명시한 helper class를 호출한다. privileged 작업은 helper class에 두고, 각 helper는 단일 privileged 함수만 담는다. (원문 예제: `ExpenseController` unsafe vs safe, `HelperClass` without sharing)

global/webservice/remote invocation class(Aura Enabled, remote action)는 항상 with sharing이다. **예외:** site(Experience Cloud) controller class(with sharing이 guest user에 과도한 권한을 강제하는 경우).

> with/without/inherited sharing 키워드 메커니즘 상세는 [[권한과 접근 제어 위협]] 참조.

---

## CRUD/FLS Enforcement

Lightning component/controller는 CRUD/FLS를 자동 강제하지 않는다. server-side에서 `isAccessible()`, `isUpdateable()`, `isCreateable()`, `isDeletable()`을 명시 확인한다. (원문 예제: `get_UNSAFE_Expenses()` vulnerable vs `getExpenses()` safe — field map 순회 + `getDescribe().isAccessible()` + `System.NoAccessException()`)

```apex
// 안전 패턴(원문 요지)
for (Schema.SObjectField field : fieldMap.values()) {
  if (!field.getDescribe().isAccessible()) {
    throw new System.NoAccessException();
  }
}
```

---

## Field Validation Concerns

client는 공격자가 통제하므로 client-side field validation은 신뢰할 수 없다(usability 역할만 한다). field-level validation이 필요하면 **trigger**로 한다. Aura-enabled server-side controller validation도 불충분하다(SOAP/REST API로 우회 가능).

---

## Object Validation Concerns

Aura enabled 메서드가 object를 input으로 받으면 object 내 field를 검증한다(client가 임의 field를 설정 가능). 취약 예제(원문): `insertAccount(Account a)` — Name만 기대하나 `insert a`가 다른 field도 설정한다. 안전 예제(원문):

```apex
// respectFLS(Account a) — 원문 요지
for (String fieldName : a.getPopulatedFieldsAsMap().keySet()) {
  if (!Schema.sObjectType.Account.fields.getMap()
        .get(fieldName).getDescribe().isUpdateable()) {
    throw new SecurityException('Invalid fields');
  }
}
```

---

## Cross Site Request Forgery

page load 결과로 DML을 수행하는 server-side controller 메서드의 자동 invoke를 금지한다. onInit/afterRender handler에서 DML을 금지한다. (원문 예제: `doInit`의 `c.updateField` vulnerable vs `handleClick` not vulnerable) 핵심: human interaction(click) event 없이 DML 금지. CSRF는 server-side DML에만 적용되며, client-side attribute update에는 미적용이다.

> CSRF 전반의 위협·VF 방어는 [[CSRF 방어]] 참조.

---

## Cross Site Scripting

component markup은 server-side VF나 innerHTML micro-templating과 다르게 렌더된다. valid xhtml이어야 하고 `setAttribute`/`textContent` 등 DOM accessor로 렌더되므로, markup 렌더 중 HTML parsing이 없고 attribute value/nodeValue 탈출이 불가능하다. attribute는 attribute value 또는 text content로만 interpolate되며, attribute name/portion으로는 불가능하다. (원문 예제: `<div>Here is a <b> {!v.myvalue} </b> bold value</div>` always safe, `<div {!v.myvalue}>` will not compile) → framework가 인코딩하지 않으며, 인코딩 함수를 제공하지 않는다.

**unsafe attribute:** `<a href="{!v.foo}">` (foo=javascript:..), `<iframe src="{!v.foo}"/>`.

### Attribute(s) — Unsafe Tag/Attribute 조합표 (표, 이미지 검증 완료 — 셀 전수)

> 표 dimension: 8행 × 3열(Tag / Attribute(s) / Issue). 이미지로 셀 단위 검증 완료(덤프 셀 매핑 그대로).

| Tag | Attribute(s) | Issue |
|---|---|---|
| (any) | `href` or `xlink:href` | javascript: or data: pseudo-schemes |
| any | `on*` (event handler) | js execution context |
| iframe, embed | `src` | javascript: pseudo scheme |
| iframe | `srcdoc` | html execution context |
| form | `formaction` | js execution context |
| object | `data` | js execution via data uri |
| animate | `to`, `from` | js execution context |
| any | `style` | css injection |

(partial list, html5sec.org 참조)

### Sanitizing 기법 (전수, 원문)

- relative URL: `<a href="{!'/' + v.foo}">click</a>` (scheme을 https/http로 강제).
- 절대+상대 모두 처리 시: attribute를 private로 표시(코드에서 설정, 외부 미설정 시).
- private 불가 시: onChange event로 sanitize. (원문: `<aura:handler name="change"...>` + `sanitizeUrl` controller — `document.createElement('a')`, `el.protocol !== 'https:'` 확인, init·change 둘 다 필터)
- style 태그: CSS sanitize가 어려우므로 token/private attribute/JS로 관리하고, attribute value를 style 태그에 전달하지 않는다.
- JS 내 XSS: 인코딩 함수를 제공하지 않으므로 secureFilters를 helper에 로드(static resource 로드 시 race condition 주의)하고 `secureFilters.html()`로 sanitize.
  ```javascript
  // unsafe vs safe (원문)
  el.innerHTML = "<b>" + myattr + "</b>";                       // unsafe
  el.innerHTML = "<b>" + cmp.helper.secureFilters.html(myattr) + "</b>"; // safe
  ```
  **자체 인코딩 함수 작성 금지.**
- **CSP에 의존해 XSS를 방지하지 말 것**(component surfacing·org policy에 따라 변동, runtime 변경 가능). CSP는 html/style injection을 보호하지 않는다.

> XSS 인코딩 함수(secureFilters)·브라우저 파싱 컨텍스트 상세는 [[XSS 방어]] 참조.

---

## Arbitrary Redirect (Lightning)

third-party redirect 시: ① HTTPS, ② domain을 source에 hardcode하거나 custom setting에 저장(custom object field는 불충분).

> redirect 위협 전반은 [[Arbitrary Redirect 방어]] 참조.

---

## Secret Inputs

VF의 `<apex:inputSecret>`는 Lightning에서 `<ui:inputSecret />`이다.

---

## Third-Party Frameworks

Lightning Locker 내에서 third-party framework 사용은 blogpost를 참조한다.

---

## 관련 노트
- [[Lightning Web Security (LWS)]] — Locker를 대체하는 LWR 사이트 보안 아키텍처(namespace sandbox·cross-namespace·Privileged Script Tag)
- [[LWC 보안 패턴]]
- [[CSP와 RemoteSite]]
- [[LWC API 버전 관리]]
- [[XSS 방어]]
- [[CSRF 방어]]
- [[Arbitrary Redirect 방어]]
- [[권한과 접근 제어 위협]]
- [[Secure Coding 개요]]
- [[Platform Security FAQ]]
