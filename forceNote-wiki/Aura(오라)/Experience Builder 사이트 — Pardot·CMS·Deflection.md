---
tags: [Aura, ExperienceCloud, ExperienceBuilder, Community, Pardot, CMS, Deflection, deflectionSignal, CaseDeflection]
source: communities_dev.pdf (Experience Cloud Developer Guide, v66.0 Spring '26)
created: 2026-06-21
aliases: [Pardot 추적 Experience Cloud, Pardot tracking Experience Builder, Edit Head Markup, Relaxed CSP Permit Inline Scripts, Salesforce CMS, CMS Connect, deflectionSignal, lightningcommunity deflectionSignal, Case Deflection 컴포넌트, Case Create Deflection Signal, 케이스 deflection 리포트, Community Case Deflection Metrics, caseCreateDeflectionModal, deflection payload, shouldSubmitSourceTypeSignals]
---

# Experience Builder 사이트 — Pardot·CMS·Deflection

> Experience Builder 사이트에 Pardot 추적 코드를 SPA-호환 방식으로 심고(head markup + Relaxed CSP), Salesforce CMS / CMS Connect로 콘텐츠를 재사용하며, `lightningcommunity:deflectionSignal` 이벤트로 케이스 deflection(케이스 생성 회피)을 리포팅하는 방법.

---

## Pardot 추적 코드 추가 (Add Pardot Tracking)

Experience Builder 사이트에 Pardot 추적 코드를 심으면 방문자의 사이트 내비게이션을 기반으로 page view를 추적하고 lead를 스코어링할 수 있다.

### 절차 4단계

1. Pardot에서 추적하려는 campaign으로 이동한다.
2. **View Tracking Code**를 클릭하고 코드를 복사한다.
3. 추적할 사이트의 Experience Builder에 접근한다.
4. **Settings > Advanced**에서 **Edit Head Markup**을 클릭하고 Pardot 코드를 붙여넣는다.

### SPA 처리 — 왜 OOTB Pardot 코드를 수정해야 하는가

Experience Builder 사이트는 **SPA(Single Page Application)** 다. 페이지 내비게이션 시 전체 페이지가 reload되지 않고 **콘텐츠 영역만 reload**된다. 기본(OOTB) Pardot 스크립트는 **첫 로드에서만** page view를 기록하므로 in-app 내비게이션을 캡처하지 못한다.

따라서 page state 변경을 **session history에 추가**하도록 스크립트를 수정해, 콘텐츠 영역만 바뀌는 in-app 내비게이션에서도 추적 데이터를 전송하게 한다. 아래 코드는 `history.pushState`를 패칭하고 `popstate` 이벤트를 청취해 이를 구현한다.

### SPA 호환 Pardot 추적 스크립트 (PDF 원문)

`{{%...%}}` placeholder는 본인 org의 Pardot ID·hostname으로 치환한다.

```javascript
<script type='text/javascript'>
piAId = '{{%pardot-id-for-your-org%}}'; //no change from OOTB code (format: 123456)
piCId = '';
piHostname = '{{%pardot-hostname-for-your-org%}}'; //no change from OOTB code (format: www.yourpardottrackerdomain.com)
(function() {
//patching the history push state function to include calling
// the async_load function that sends data to Pardot
var pushState = history.pushState;
history.pushState = function() {
pushState.apply(history, arguments);
async_load();
};
function async_load(){
var s = document.createElement('script'); s.type = 'text/javascript';
s.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + piHostname + '/pd.js';
var c = document.getElementsByTagName('script')[0];
c.parentNode.insertBefore(s, c);
}
if(window.attachEvent)
{
window.attachEvent('onload', async_load);
//attach event listener for browser history changes for browsers that support attachEvent
window.attachEvent('onpopstate', async_load);
}
else
{
window.addEventListener('load', async_load, false);
//add eventlistener for browser history changes for all other browsers
window.addEventListener('popstate', async_load, false);
}
})();
</script>
```

> 추출 주석: PDF 원문에서 `function async_load()` 줄은 `function async_load(){0`로 끝에 떠도는 `0`이 붙어 추출됐으나, OCR/PDF 추출 아티팩트로 판단해 위 코드 블록에서는 `function async_load(){`로 정규화했다. (참고: 같은 노트의 `source: cmp.get` [sic]는 원문 오류로 보존)

### CSP 설정 — Relaxed CSP

head markup이 의도대로 동작하려면 사이트의 Content Security Policy(CSP) 설정을 업데이트해야 한다.

1. **Experience Builder > Settings > Security**에 접근한다.
2. **Relaxed CSP: Permit Access to Inline Scripts and Allowed Hosts**를 선택하고, 확인창에서 **Allow**를 클릭한다.
3. **CSP Errors** 아래에 차단된(blocked) 사이트 목록이 표시된다. Pardot tracker 도메인으로 허용하려는 **각 사이트마다 Allow URL**을 클릭한다.

Pardot ↔ Experience Cloud 통합이 성공적으로 활성화되면, 방문자의 사이트 내비게이션을 기반으로 page view를 정확히 추적하고 lead를 스코어링할 수 있다.

> SEE ALSO (Salesforce Help): Implement Tracking Code / Add Markup to the Page `<head>` to Customize Your Experience Builder Site / Where to Allowlist Third-Party Hosts for Experience Builder Sites.

---

## CMS 사용 (Use a CMS with Your Experience Builder Site)

CMS(Content Management System)는 콘텐츠를 중복 생성하는 대신 **재사용**할 수 있게 해준다. CMS를 쓰면 여러 사이트에 콘텐츠를 공급하고, 한곳에서 **중앙 일괄 업데이트**하여 모든 곳을 최신 상태로 유지할 수 있다.

Experience Cloud는 두 가지 CMS 옵션을 제공한다.

| 옵션 | 설명 |
|---|---|
| **Salesforce CMS** | org에 내장(built-in)되어, org 내 여러 채널을 대상으로 콘텐츠를 생성·관리·정리한다. |
| **CMS Connect** | 서드파티 CMS의 콘텐츠를 사이트에 임베드(embed)하는 도구다. |

두 옵션의 상세는 **CMS Developer Guide**를 참조한다. (이 장에는 코드 예제가 없다.)

---

## Deflection 리포팅 — Deflection Signals Framework

`lightningcommunity:deflectionSignal` 이벤트는 사용자가 케이스를 생성하기 시작한 뒤, 자신의 문제를 해결해 주는 **deflection item**(deflection 항목)을 보고 케이스 생성을 **abandon(중단)** 할 때 fire된다.

예: 사용자가 고객 케이스 생성 폼을 작성하던 중 페이지에서 유용한 article을 본다. article을 클릭해 도움이 된다고 판단하면 케이스 생성이 불필요하다고 결정한다. 이때 `lightningcommunity:deflectionSignal` 이벤트가 fire되며, article과의 상호작용 정보가 이벤트에 포함된다. 사용자가 케이스를 생성하지 않았으므로 이 행위는 **successful deflection**으로 리포트된다.

이 이벤트는 타깃 오브젝트가 **Community Case Deflection Metrics**인 custom report type을 통해 리포팅할 수 있다. 시그널은 리포트에 **Successful Deflection / Failed Deflection / Potential Deflection** 중 하나로 나타난다.

> **Note:** 오직 **인증된(authenticated) 사용자**가 트리거한 `lightningcommunity:deflectionSignal` 이벤트만 리포트된다. (인증되지 않은 사용자의 이벤트는 데이터 수집·리포트 대상이 아니다.)

### Case Create Deflection Signal

`lightningcommunity:deflectionSignal` 이벤트는 **Aura 사이트**에서, 사용자가 고객 케이스 생성으로부터 deflect될 때 fire된다. 사용자가 article 또는 discussion을 본 뒤, 상호작용이 도움이 되었는지 그리고 케이스를 abandon할 것인지 질문을 받는다.

Experience Builder에서 **Case Deflection** 컴포넌트의 **Deflection Metrics** 속성으로 이 이벤트를 **자동 fire**하도록 구성할 수 있다. Case Deflection 컴포넌트는 deflection 상호작용을 등록하기 위해 **Contact Support Form**과 함께 동작한다.

> (PDF 스크린샷 — p.89에 Case Deflection 컴포넌트 속성 패널 스크린샷이 있으나, 본 위키에는 텍스트 설명만 둔다.)

### Attributes

Case Deflection 컴포넌트가 보내는 deflection signal의 속성은 다음과 같다.

| Attribute | 값 / 의미 |
|---|---|
| `sourceType` | `caseCreateDeflectionModal` (Case Deflection 컴포넌트에서 발생하는 시그널의 sourceType) |
| `source` | 사용자가 Case Create Form의 **subject** 필드 또는 **description**에 입력한 내용 |
| `destination` | deflection item인 **Article** 또는 **Discussion**의 ID |
| `payload` | JavaScript object key-value 매핑 (아래 표 참조) |

### Payload Property

`payload`는 JavaScript object key-value 매핑이며, 이 유형의 시그널에 사용되는 프로퍼티는 다음과 같다.

| Payload Property | Type | Description | Supported Values | Required |
|---|---|---|---|---|
| `deflectionAnswer` | string | deflection item이 도움이 되었는지 묻는 첫 번째 질문에 대한 사용자의 답변. | YES / NO / null—the user didn't vote | No |
| `confirmationAnswer` | string | 케이스 생성을 중단할지 묻는 두 번째 질문에 대한 사용자의 답변. | YES / NO / null—the user didn't vote | No |
| `state` | string | 팝업 창이 닫히기 직전 마지막으로 남아 있던 상태. | `MeasureDeflectionState`—첫 번째 질문에 답하지 않음 / `ConfirmationQuestionState`—두 번째 질문에 답하지 않음 / `ConfirmationMessageState`—두 질문 모두 답함 | No |
| `caseCreated` | boolean | 사용자가 케이스를 생성했는지 여부. | `true`—케이스 생성함 / `false`—케이스 생성 안 함 | No |

### Examples

커스텀 Aura 컴포넌트는 이 시스템 이벤트를 청취해 필요에 따라 처리할 수 있다. 예를 들어 사용자가 콘텐츠를 도움이 안 된다고 했다면 컴포넌트가 또 다른 프로세스를 시작할 수 있다.

**1) 시스템 이벤트를 청취하는 샘플 컴포넌트 (PDF 원문)**

```xml
<aura:component implements="forceCommunity:availableForAllPageTypes">
<aura:attribute name="message" type="String" required="false"/>
<aura:handler event="lightningcommunity:deflectionSignal" action="{!c.handleSignal}"/>
<lightning:formattedText value="{!v.message}"/>
</aura:component>
```

**2) client-side controller — failed deflection 체크 (PDF 원문)**

```javascript
({
handleSignal: function(component, event, helper) {
var signal = event.getParams() || {},
sourceType = signal.sourceType,
payload = signal.payload;
// Process case create deflection signals
if (sourceType && sourceType === "caseCreateDeflectionModal") {
if (payload && payload.deflectionAnswer === "NO") {
component.set("v.message", "Sorry you didn't find that helpful.");
}
if (payload && payload.caseCreated === true) {
component.set("v.message", "We Apologize For The Inconvenience. We'll get in touch with you shortly about your case.");
}
}
}
})
```

**3) `fireCaseDeflectionSignal` — deflection 시그널 fire (PDF 원문)**

> ⚠️ [sic] 아래 라인의 `source: cmp.get(...)`는 같은 블록의 `component.get`과 변수명이 혼용되어 있으나 PDF 원문 그대로 보존한다.

```javascript
fireCaseDeflectionSignal : function(component, shouldSubmitSourceTypeSignals) {
var evt = $A.get("e.lightningcommunity:deflectionSignal");
evt.setParams({
sourceType: "caseCreateDeflectionModal",
source: cmp.get("v.deflectionTerm"),
destinationType: component.get("v.deflectionEntityType"),
destination: component.get("v.deflectionEntityId"),
payload: {
deflectionAnswer: component.get("v.deflectionAnswer"),
confirmationAnswer: component.get("v.confirmationAnswer"),
state: component.get("v.deflectionState"),
caseCreated: component.get("v.caseCreated")
},
shouldSubmitSourceTypeSignals: shouldSubmitSourceTypeSignals
});
evt.fire();
}
```

**4) `fireCaseCreatedSignal` — 누적 시그널 batch 전송 (PDF 원문)**

사용자는 여러 deflection item을 연속해서 조회할 수 있으며, 각 조회마다 이벤트가 fire된다. 누적된 시그널을 단일 batch로 서버에서 처리하려면, **마지막 이벤트에서 `shouldSubmitSourceTypeSignals`를 `true`로** 설정한다.

```javascript
fireCaseCreatedSignal : function(component, caseCreated) {
// Send all accumulated signals to the server to be processed
var evt = $A.get("e.lightningcommunity:deflectionSignal");
evt.setParams({
sourceType: "caseCreateDeflectionModal",
payload: {
caseCreated: caseCreated
},
shouldSubmitSourceTypeSignals: true
});
evt.fire();
}
```

---

## 관련 노트

- [[Experience Builder Aura 사이트 개발]] — Aura 모델 Experience Builder 사이트에서 커스텀 Aura 컴포넌트(`forceCommunity:*`)·테마 레이아웃 개발 (자매 노트)
- [[ExperienceBundle — Experience Builder 사이트 메타데이터]] — Experience Builder 사이트의 메타데이터 번들·배포 (자매 노트)
