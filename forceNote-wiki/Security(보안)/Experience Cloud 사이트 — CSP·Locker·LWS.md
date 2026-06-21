---
tags: [security, experience-cloud, aura, csp, lightning-locker, lws, lightning-web-security, third-party-components, adobe-analytics, 보안]
source: communities_dev.pdf (Experience Cloud Developer Guide, v66.0 Spring '26)
created: 2026-06-21
aliases: [Aura 사이트 Locker, Relaxed CSP, Strict CSP, allowInRelaxedCSP, lightningCommunity__RelaxedCSP, third-party 컴포넌트 Locker off, Adobe Analytics Aura, Locker 충돌 해결, LWS org site level, Aura 사이트 보안, Lightning Locker 끄기, forceCommunity routeChange, Aura API 39.0 Locker]
---

# Experience Cloud 사이트 — CSP·Locker·LWS

> Aura 사이트 맥락에서 CSP 레벨(Relaxed/Strict)·Lightning Locker·LWS가 org/site 레벨에서 어떻게 적용되는지, Locker 충돌을 해결하고 third-party 컴포넌트를 Locker off 상태에서 실행하는 방법 — Adobe Analytics 통합 예제 포함.

---

## 개요 — Aura·LWR 사이트의 보안 레이어

Experience Cloud의 **Aura·LWR 사이트**는 **Content Security Policy (CSP)** 와 **Lightning Web Security (LWS)** 또는 **Lightning Locker** 중 하나를 사용해 악성 공격과 커스텀 코드 취약점으로부터 사이트를 보호한다. 커스텀 컴포넌트 개발·third-party 컴포넌트 사용·head markup에 커스텀 코드 추가 시 이 보안 기능들의 잠재적 영향을 고려한다.

> PDF 원문: *"Aura and LWR sites in Experience Cloud use Content Security Policy (CSP) and either Lightning Web Security (LWS) or Lightning Locker to secure the site from malicious attacks and custom code vulnerabilities."*

### CSP (개념만 — 상세는 위임)

CSP는 페이지에 로드될 수 있는 콘텐츠의 소스를 제어하는 **W3C 표준**이다. CSP 규칙은 **page level**에서 동작하며 모든 third-party 컴포넌트와 커스텀 코드에 적용된다. 기본적으로 framework의 헤더는 콘텐츠를 **secure (HTTPS) URL에서만** 로드하도록 허용하고 JavaScript의 XHR 요청을 금지한다.

- Experience Builder에서 **여러 단계의 CSP script security**를 선택할 수 있다. **CSP 레벨은 각 사이트별로 고유**하다.

> CSP **Directives 전수표**(default-src·script-src·unsafe-inline 등)는 [[Lightning Security 모델]] 소관이며 본 노트에서 재현하지 않는다. CSP·Trusted URLs 설정 상세는 [[CSP와 RemoteSite]] 참조.

### Lightning Locker 와 LWS (개념만 — 상세는 위임)

**Lightning Locker** 아키텍처 레이어는 개별 Lightning component namespace를 각자의 컨테이너로 격리하고 coding best practice를 강제해 보안을 강화한다. Lightning Locker는 Lightning components와 Experience Cloud의 Aura 사이트의 **기본 보안 아키텍처**였다.

**LWS**는 컴포넌트가 secure coding practice를 더 쉽게 쓰도록 설계되었으며 **Lightning Locker를 대체**하는 것을 목표로 한다. Locker와 마찬가지로 LWS의 목표는 Lightning component가 platform code나 다른 namespace 컴포넌트에 속한 데이터에 간섭·접근하지 못하게 막는 것이지만, **다른 접근 방식(architecture)** 으로 Lightning web component를 보호한다.

> LWS **격리 모델 상세**(namespace sandbox·cross-namespace·Privileged Script Tag)는 [[Lightning Web Security (LWS)]] 소관(LWR 전용)이며 본 노트에서 재현하지 않는다. Locker **위협 모델 상세**는 [[Lightning Security 모델]] 참조.

---

## How LWS Applies — Org & Site 레벨 (본 노트 핵심)

관리자는 Setup의 **Session Settings**에 있는 **Use Lightning Web Security for Lightning web components and Aura components** 설정으로 **org 레벨에서 LWS를 활성화**해 org 전체에서 Lightning Locker 대신 사용할 수 있다.

- **이 org-level 설정은 Aura 사이트에 영향을 준다.** org에서 LWS가 활성화되면 LWS가 **site level에서 Lightning Locker를 대체**하기 때문이다. 그러면 Aura 사이트에 대해 Experience Builder에서 **Lightning Locker 설정을 disable하면 실제로는 LWS를 disable**하는 것이 된다.
- **LWR 사이트는 자체 LWS 인스턴스를 가지므로 org의 LWS 설정이 LWR 사이트에 영향을 주지 않는다.** LWR 사이트에서 Lightning Locker를 disable하면, org에서 LWS가 활성화되어 있어도 **그 사이트의 LWS 인스턴스가 disable**된다.

> PDF 원문: *"This org-level setting affects Aura sites because when LWS is enabled in the org, LWS replaces Lightning Locker at the site level. ... LWR sites have their own instance of LWS, so the org setting for LWS has no effect on LWR sites."*

> **Note:** 기본적으로 모든 새 Experience Builder 사이트는 **Strict CSP**가 활성화되어 있으며, 이는 Lightning Locker 또는 LWS도 활성화됨을 의미한다. Experience Builder에서 Lightning Locker 설정에 접근하려면 **Relaxed CSP**를 선택한다.

> **Commerce Cloud의 B2B store·D2C store LWR 템플릿**에서는 LWS가 기본적으로 활성화되지 않으며 **활성화할 수도 없다.**

### org × site 설정 → 사용되는 보안 매트릭스

> ⚠️ pdftotext가 이 표의 ✓/✗ 셀 기호를 누락 → researcher가 인쇄 p.80(PDF 물리 84페이지)을 `pdftoppm`으로 이미지 렌더 후 Read로 셀값 전수 복원. 아래는 그 **이미지 복원본**이다(추측 아님).
>
> **표 방향성:** 각 행 = (framework × site-level 설정 × org-level 설정) 한 조합 → 결과. 8행 각각이 독립 조합이므로 transpose하지 않는다.
> - **Site-level setting** 열: Aura는 Experience Builder의 "Lightning Locker" 토글, LWR은 사이트 자체 LWS 토글.
> - **Org-level setting** 열: org의 LWS 설정 토글.
> - 결과 셀의 ✗ = 해당 조합에서 Locker/LWS 미사용(설정 OFF). PDF 원문은 빈칸이 아니라 명시적 빨간 ✗(X 마크)로 미사용을 표기한다.

| Framework | Site-level setting | Org-level setting | 사이트에서 사용되는 LWS or Locker |
|---|---|---|---|
| **Aura** | ✗ OFF | ✗ OFF | ✗ (미사용) |
| Aura | ✗ OFF | ✓ ON | ✗ (미사용) |
| Aura | ✓ ON | ✗ OFF | **Lightning Locker** |
| Aura | ✓ ON | ✓ ON | **LWS** |
| **LWR** | ✗ OFF | ✗ OFF | ✗ (미사용) |
| LWR | ✗ OFF | ✓ ON | ✗ (미사용) |
| LWR | ✓ ON | ✗ OFF | **LWS (site's instance)** |
| LWR | ✓ ON | ✓ ON | **LWS (site's instance)** |

핵심 읽기:
- **Aura 사이트**: site-level이 ON일 때만 보안 레이어가 동작하며, **org LWS가 OFF면 Locker, ON이면 LWS**로 대체된다.
- **LWR 사이트**: site-level이 ON이면 **org 설정과 무관하게 항상 자체 LWS 인스턴스**를 쓴다 (org LWS 토글의 영향 없음).

> SEE ALSO (PDF): Salesforce Help — CSP and Lightning Locker in Experience Builder Sites / Select a Security Level in Experience Builder Sites / CSP and Lightning Locker Design Considerations · Lightning Web Components Developer Guide — Security with Lightning Locker · Lightning Aura Components Developer Guide — Developing Secure Code

---

## Resolve Lightning Locker Conflicts in Aura Sites

Lightning Locker는 Experience Cloud의 모든 새 Aura 사이트에서 **기본 활성화**된다. 그러나 가끔 페이지의 third-party 컴포넌트나 head markup의 커스텀 코드가 Lightning Locker와의 충돌로 기대대로 동작하지 않는다. 이때 Salesforce는 아래 워크어라운드 중 하나를 권장한다.

### 1. Use JavaScript Custom Events

Lightning Locker는 third-party 컴포넌트·커스텀 코드가 다른 namespace의 리소스와 상호작용하지 못하게 보호하지만, **head markup으로부터는 보호하지 않는다.** 즉 head markup에 Lightning Locker를 우회하고 보안 취약점을 들이는 커스텀 코드가 들어갈 수 있다. head element의 third-party 스크립트는 Salesforce platform code와 충돌해 예측 불가 이슈를 일으킬 수도 있다.

이 한계를 다루려면 head markup에서 **`CustomEvent` constructor**를 써서 third-party Aura·Lightning web component와 커스텀 코드를 격리한다. 그러면 third-party 컴포넌트·커스텀 코드가 리소스를 직접 로드/참조하지 않고도 내 리소스와 상호작용할 수 있다.

- 이벤트로 listener에 전달할 데이터는 이벤트 초기화 시 생성되는 **`detail` property**로 전달된다. `detail` property는 head markup listener의 **`dataLayer`** 에 매핑된다.
- custom event는 **`EventTarget`을 extend하는 모든 리소스**로 dispatch된다. 사용 예는 아래 [Adobe Analytics 예제](#example-adobe-analytics-and-lightning-locker-in-aura-sites) 참조.

> **Warning:** JavaScript CustomEvent constructor로 전달하는 데이터에 주의하고 사용이 안전한지 확인한다. **페이지에서 실행되는 모든 JavaScript(사용 중인 third-party AppExchange 컴포넌트 포함)가 event 이름을 listen해 이 데이터를 읽을 수 있다.**

### 2. Set an Aura Component to API 39.0

third-party 컴포넌트나 커스텀 코드가 Aura 컴포넌트와 기대대로 상호작용하지 않으면, Aura 컴포넌트를 **Salesforce API version 39.0**으로 설정해 해당 컴포넌트의 Lightning Locker를 disable할 수 있다. (Lightning Aura Components Developer Guide의 *Disable Lightning Locker for a Component* 참조)

> **Warning:** Aura 컴포넌트의 Lightning Locker를 disable하면 사이트에 보안 결함이 들어갈 수 있고, 해당 컴포넌트가 design time에 사용 불가하거나 runtime에 렌더되지 않을 수 있다.

- 일관성·디버깅 편의를 위해 **부모 Aura 컴포넌트와 자식 컴포넌트가 서로 다른 API version을 갖지 않게** 한다. 따라서 컴포넌트 계층(컴포넌트 안의 컴포넌트, 다른 컴포넌트를 extend하는 컴포넌트)에서 API version 39.0으로 설정된 Aura 컴포넌트를 쓰지 않는다.
- **org에서 LWS가 활성화되어 있으면**, 컴포넌트에 API version 39.0을 설정해도 그 컴포넌트의 LWS는 disable되지 않는다. 다만 LWS는 Lightning Locker가 차단하는 컴포넌트 동작을 허용할 가능성이 높아 disable할 필요 자체가 줄어든다.

### 3. Turn Off Lightning Locker

> **Warning:** 이 워크어라운드는 **최후의 수단(last resort)** 으로만 사용한다.

사이트에서 Lightning Locker를 끄면 **사이트의 모든 third-party 컴포넌트·커스텀 코드에 대해 disable**된다. 영향이 광범위·예측 불가할 수 있다(예: 사이트에 보안 결함 유입). third-party 컴포넌트가 Lightning Locker 없이 동작하도록 enable되지 않았다면 design time 사용 불가·runtime 렌더 실패가 발생할 수 있다. Lightning Locker가 꺼지면 **다른 namespace의 컴포넌트가 서로의 DOM에 접근·상호작용**할 수 있고, 커스텀 리소스가 사이트와 상호작용하는 데 대한 제약이 완화된다.

> SEE ALSO (PDF): ExperienceBundle for Experience Builder Sites · Experience Cloud Help — Select a Security Level in Experience Builder Sites · Salesforce Help — Add Markup to the Page \<head\> to Customize Your Experience Builder Site · Lightning Web Components Dev Guide — Communicate with Events · Lightning Aura Components Developer Guide — Communicating with Events

---

## Enable Third-Party Components to Run When Lightning Locker Is Off

Experience Builder 사이트에서 Lightning Locker를 끄면, managed package에서 설치한 모든 third-party 컴포넌트는 **design time에 사용 가능하고 runtime에 렌더되도록 구성**되어야 한다.

- Lightning Locker는 **Relaxed CSP 또는 Strict CSP** 보안 레벨에서 끌 수 있다.

> **Note (인쇄 p.82 callout):** org에서 LWS가 활성화되어 있으면, Aura 사이트에서 Lightning Locker를 disable할 때 실제로는 사이트의 LWS를 disable하는 것이다. LWR 사이트에서 Lightning Locker를 disable하면 org에서 LWS가 활성화되어 있어도 그 사이트의 LWS 인스턴스가 disable된다. **LWR 사이트는 Lightning Locker나 LWS를 disable하지 않고도 third-party 라이브러리를 포함할 수 있다.** (Privileged Script Tag 메커니즘은 [[Lightning Web Security (LWS)]] 참조)

> **Warning:** Lightning Locker를 끄면 사이트에 보안 결함이 들어갈 수 있다. **최후의 수단으로만** disable한다.

### 컴포넌트 타입별 설정 (Aura vs LWC)

| 컴포넌트 타입 | 설정 위치 | 인터페이스 / 값 |
|---|---|---|
| Third-party **Aura** 컴포넌트 | 컴포넌트의 interface | `lightningcommunity:allowInRelaxedCSP` |
| Third-party **Lightning web component** | config 파일의 `capability` 태그 내 value | `lightningCommunity__RelaxedCSP` |

- **Third-party Aura 컴포넌트:** managed package 개발자가 컴포넌트에 **`lightningcommunity:allowInRelaxedCSP`** interface를 구성해야 한다.
- **Third-party LWC:** managed package 개발자가 컴포넌트 configuration file의 **`capability` 태그**에 **`lightningCommunity__RelaxedCSP`** value를 구성해야 한다.

> SEE ALSO (PDF): ExperienceBundle for Experience Builder Sites · Experience Cloud Help — Select a Security Level in Experience Builder Sites · Salesforce Help — Where to Allowlist Third-Party Hosts for Experience Builder Sites · Lightning Web Component Reference — Allow In Relaxed Csp · Lightning Web Components Developer Guide — XML Configuration File Elements

---

## Example — Adobe Analytics and Lightning Locker in Aura Sites

Adobe Analytics는 Aura 사이트의 컴포넌트와 상호작용하므로 Lightning Locker가 예기치 않은 결과를 낼 수 있다. 권장 워크어라운드는 head markup에서 **JavaScript Custom Events로 Adobe Analytics를 격리**하는 것이다. 그러면 Adobe Analytics가 리소스를 직접 로드/참조하지 않고도 컴포넌트와 상호작용할 수 있다.

> **Tip:** LWR 사이트는 다른 전략(Privileged Script Tag)으로 analytics를 포함할 수 있다 — [[Lightning Web Security (LWS)]] 참조.

### 1. Include Adobe Analytics in Your Aura Site

site의 head markup에 script 태그로 Adobe Analytics 스크립트와 해당 event listener를 추가한다.

```html
<script>
    document.addEventListener('analyticsEvent', function(e) {
        //add logic here to tell your dataLayer about the event
        //dataLayer.action = e.detail.action;
        //dataLayer.label = e.detail.label;
        //or map payload to an AA library event
    });
    document.addEventListener('analyticsViewChange', function() {
    });
</script>
<script src="full-url-to-your-adobe-script" async></script>
```

### 2. Use Custom Events

Adobe Analytics와 상호작용시킬 컴포넌트마다 **`detail` property**를 사용한 custom event를 구현한다. 이 property는 이벤트로 데이터를 listener에 전달하고 head markup listener의 `dataLayer`에 매핑된다. custom event는 `EventTarget`을 extend하는 모든 리소스로 dispatch될 수 있다.

```javascript
document.dispatchEvent(new CustomEvent('analyticsEvent', {'detail': {action: 'click',
    label: 'Submitted Case'}}));
```

> **Warning:** JavaScript CustomEvent constructor로 전달하는 데이터에 주의하고 사용이 안전한지 확인한다. Adobe Analytics를 포함해 페이지의 모든 JavaScript가 event 이름을 listen해 이 데이터를 읽을 수 있다.

### 3. Implement Additional Events for Aura Components

Adobe Analytics가 **Aura 컴포넌트**와 상호작용하면 **`forceCommunity:routeChange`** 와 **`aura:locationChange`** event도 구현해야 한다.

- **`forceCommunity:routeChange`** — Lightning Component Framework 내의 view 변경을 추적한다.

```xml
<aura:component implements="forceCommunity:availableForAllPageTypes">
    <aura:handler event="forceCommunity:routeChange" action="{!c.handleRouteChange}" />
</aura:component>
```

```javascript
handleRouteChange : function(component, event, helper) {
    document.dispatchEvent(new Event('analyticsViewChange'));
}
```

- **`aura:locationChange`** — 브라우저 location bar의 URL 중 hash 부분이 수정되었음을 나타낸다. 단, location URL의 hash 부분을 바꾸는 것은 드물게만 쓰인다 — 예: Tabs 컴포넌트의 탭 변경 구현.

> SEE ALSO (PDF): Salesforce Help — Add Markup to the Page \<head\> to Customize Your Experience Builder Site · Lightning Web Components Reference — Route Change / Location Change · Lightning Aura Components Developer Guide — What is the Lightning Component Framework?

---

## 관련 노트
- [[Lightning Web Security (LWS)]] — LWS 격리 아키텍처 상세(namespace sandbox·cross-namespace)·LWR 전용 Privileged Script Tag. 본 노트가 위임하는 LWS 상세 소관
- [[Lightning Security 모델]] — Lightning Locker 위협 모델·CSP Directives 전수표. 본 노트가 위임하는 Locker/CSP 상세 소관
- [[CSP와 RemoteSite]] — CSP·Trusted URLs(CSPTrustedSite) 설정 상세
- [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]] — 같은 PDF Ch4. 게스트 사용자·인증 보안 고려사항 (형제 노트)
- [[Experience Builder Aura 사이트 개발]] — Aura 사이트 커스텀 컴포넌트 개발·보안 확보 맥락 (형제 노트)
