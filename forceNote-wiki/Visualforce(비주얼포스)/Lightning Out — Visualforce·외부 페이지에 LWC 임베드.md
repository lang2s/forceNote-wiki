---
tags: [visualforce, lightning-out, lwc, aura, interoperability, includeLightning, outApp, createComponent, embed]
source: visualforce-to-lwc-main/force-app/main/default/{pages/interoperability.page, aura/LWCContainerApp, lwc/interoperability} (실전 예시, Tier 1) + developer.salesforce.com/docs/component-library/documentation/en/lwc/use_visualforce (Add Lightning Web Components to Visualforce Pages, Tier 2, 접속 2026-07-04) + developer.salesforce.com Aura Components Developer Guide — Lightning Out
created: 2026-07-04
aliases: [Lightning Out, apex:includeLightning, $Lightning.use, $Lightning.createComponent, ltng:outApp, ltng:outAppUnstyled, aura:dependency, LWC in Visualforce, Lightning components for Visualforce, VF에 LWC 임베드, Visualforce에서 LWC 사용, 라이트닝 아웃, 외부 페이지 LWC]
---

# Lightning Out — Visualforce·외부 페이지에 LWC 임베드

> `apex:includeLightning` + `ltng:outApp` 의존성 앱 + `$Lightning.use`/`$Lightning.createComponent`로 LWC(또는 Aura 컴포넌트)를 Visualforce 페이지나 완전 외부(비-Salesforce) 웹 페이지 안에 동적으로 렌더하고, 표준 DOM API로 속성·메서드·이벤트를 상호운용한다.

---

## 개요 — 무엇이고 언제 쓰나

**Lightning Out**은 Lightning 컴포넌트(LWC·Aura)를 Lightning Experience/모바일 **바깥의 컨테이너**에 삽입하는 프레임워크다. 두 가지 호스트가 있다:

1. **Visualforce 페이지** 안에 임베드 — 같은 org, Salesforce가 세션을 제공하므로 인증이 자동. `apex:includeLightning` 태그를 쓴다.
2. **완전 외부 사이트**(자체 웹 서버, 다른 도메인)에 임베드 — Lightning Out JS 라이브러리를 `<script>`로 직접 로드하고, Connected App OAuth로 얻은 access token을 넘겨 인증한다.

어느 경우든 실행되는 코드는 **의존성 Aura 앱**(`ltng:outApp` 확장)을 통해 부트되고, 그 앱에 `aura:dependency`로 선언된 컴포넌트만 클라이언트에서 생성할 수 있다.

> ⚠️ 버전 구분: 이 노트는 **클래식 Lightning Out**(`$Lightning.use` API, VF·외부 페이지 공통, GA·장기 안정)을 다룬다. 외부 앱 임베드용 **신형 `lightning-out-application` 웹 컴포넌트 기반**은 별도 노트 [[Lightning Out 2.0 (외부 앱 임베드)]]를 참조. 2.0은 외부 앱 시나리오에서 클래식 Lightning Out(beta 표기)을 대체하지만, **Visualforce 임베드는 이 클래식 API가 정본 경로**다.

---

## 3단계 구현

Salesforce 공식 문서가 명시하는 세 단계:

| # | 단계 | 무엇 |
|---|---|---|
| 1 | **JS 라이브러리 로드** | Visualforce: `<apex:includeLightning/>` / 외부: `<script src="https://<MyDomain>.lightning.force.com/lightning/lightning.out.js">` |
| 2 | **의존성 Aura 앱 생성·참조** | `ltng:outApp`(또는 `ltng:outAppUnstyled`)를 확장하는 standalone `aura:application` + `aura:dependency`. `$Lightning.use('c:앱')`로 참조 |
| 3 | **컴포넌트 생성** | `$Lightning.createComponent('c:컴포넌트', attrs, 'domLocator', callback)`로 지정 DOM 요소에 삽입 |

---

## 1) `apex:includeLightning`

Visualforce 페이지가 Lightning 컴포넌트 컨테이너로 동작하도록 **Lightning Components for Visualforce JavaScript 라이브러리**를 로드하는 태그. 페이지 **맨 앞(다른 Lightning Out 스크립트보다 먼저)**에 한 번 넣는다. 이 태그가 전역 `$Lightning` 객체를 제공한다.

```html
<apex:page lightningStyleSheets="true">
    <apex:includeLightning />
    ...
</apex:page>
```

- `lightningStyleSheets="true"`는 VF 페이지에 Lightning Experience 스타일시트를 적용한다(선택).
- 외부 페이지에는 이 태그 대신 org의 `lightning.out.js`를 직접 `<script>`로 로드한다.

---

## 2) 의존성 Aura 앱 — `ltng:outApp` + `aura:dependency`

클라이언트에서 생성할 컴포넌트를 **미리 선언**하는 standalone Aura 애플리케이션. 실행할 LWC/Aura 컴포넌트마다 `aura:dependency` 한 줄이 필요하다.

```xml
<!-- 실전 예시: aura/LWCContainerApp/LWCContainerApp.app -->
<aura:application access="GLOBAL" extends="ltng:outApp">
  <aura:dependency resource="c:interoperability" />
</aura:application>
```

| 요소 | 의미 |
|---|---|
| `access="GLOBAL"` | 앱을 org(및 관리 패키지 소비자)에서 접근 가능하게 노출 |
| `extends="ltng:outApp"` | **SLDS 스타일 포함** Lightning Out 부트 앱 |
| `extends="ltng:outAppUnstyled"` | **SLDS 없이** — 외부 사이트의 자체 CSS와 충돌을 피하고 싶을 때 |
| `aura:dependency resource="c:interoperability"` | 이 앱을 통해 생성 허용할 컴포넌트. `<namespace:camelCaseName>` 표기. 여러 개면 여러 줄 |

- **네임스페이스 접두사**: org 정의 컴포넌트는 `c`, 관리 패키지는 그 패키지 네임스페이스.
- 앱과 컴포넌트는 **VF 페이지와 같은 org**에 있어야 한다.

### `ltng:outApp` vs `ltng:outAppUnstyled` (선택 기준)

| 상황 | 선택 |
|---|---|
| Lightning 컴포넌트를 SLDS 룩앤필 그대로 보이고 싶다 | `ltng:outApp` |
| 외부 사이트의 기존 CSS 프레임워크와 스타일 충돌을 피하고 싶다 / 완전 커스텀 스타일 | `ltng:outAppUnstyled` |

---

## 3) `$Lightning.use` — 앱 부트

의존성 앱을 로드·초기화한다. 성공 콜백 안에서만 `$Lightning.createComponent`를 호출할 수 있다.

```javascript
// 시그니처
$Lightning.use(String appName,
               function callback,
               String lightningEndPointURI,   // 외부 페이지에서만 필요
               String authToken)              // 외부 페이지에서만 필요(게스트는 생략)
```

| 파라미터 | 필수 | 설명 |
|---|---|---|
| `appName` | ✅ | 의존성 앱 이름(네임스페이스 포함). 예: `'c:LWCContainerApp'` |
| `callback` | ✅ | 프레임워크·앱이 완전히 로드된 뒤 호출되는 함수. 여기서 `createComponent` 호출 |
| `lightningEndPointURI` | 외부만 | org의 Lightning 도메인 URL. 형식은 `https://<MyDomain>.lightning.force.com` (SOAP이 주는 `...my.salesforce.com`이 아님). `lightning.out.js`를 로드한 인스턴스와 **일치해야** 함 |
| `authToken` | 외부만 | 유효·활성 세션의 Session ID(SOAP) 또는 OAuth access token. **게스트 사용자에게 공개된 페이지에서는 생략** |

- **VF 페이지에서는 `appName`·`callback` 두 개만** 넘긴다 — Salesforce가 세션을 제공하므로 endpoint·token 불필요.
- `$Lightning.use`는 한 페이지에서 **여러 번 호출 가능**하나, **모든 호출이 동일한 의존성 앱을 참조**해야 한다.

```javascript
// 실전 예시: pages/interoperability.page 의 <script>
$Lightning.use('c:LWCContainerApp', function () {
    $Lightning.createComponent(
        'c:interoperability',
        { label: 'Initial label value' },
        'lwc-container',
        function (cmp) {
            console.log('LWC added to Visualforce page:' + cmp);
            var lwc = document.querySelector('c-interoperability');
            lwc.addEventListener('buttonclicked', handleLWCEvent);
        }
    );
});
```

---

## 4) `$Lightning.createComponent` — 컴포넌트 삽입

의존성 앱에 선언된 컴포넌트를 인스턴스화해 DOM 요소 안에 삽입한다.

```javascript
// 시그니처
$Lightning.createComponent(String type,
                           Object attributes,
                           String domLocator,
                           function callback)
```

| 파라미터 | 설명 |
|---|---|
| `type` | 생성할 컴포넌트. `'c:interoperability'`. **의존성 앱의 `aura:dependency`에 선언돼 있어야 함** |
| `attributes` | 컴포넌트의 `@api` 속성 초기값 맵. 예: `{ label: 'Initial label value' }`. 키는 LWC의 `@api` 프로퍼티명(camelCase) |
| `domLocator` | 컴포넌트를 삽입할 컨테이너 요소의 **id**(문자열). 예: `'lwc-container'` → `<div id="lwc-container">` |
| `callback` | 생성 완료 시 호출. 인자 `cmp`는 생성된 컴포넌트. 여기서 이벤트 리스너 부착·후속 로직 |

- LWC는 DOM에 **`c-interoperability`**(하이픈 표기)로 렌더된다. `document.querySelector('c-interoperability')`로 요소를 잡는다.

---

## 상호운용 — VF ↔ LWC (속성·메서드·이벤트)

Lightning Out으로 삽입된 LWC는 **일반 DOM 요소**처럼 호스트 페이지 JS와 주고받는다. 실전 예시(`interoperability` LWC)가 세 방향을 모두 보여준다.

### LWC 쪽 (`@api` 노출)

```javascript
// 실전 예시: lwc/interoperability/interoperability.js
import { LightningElement, api } from 'lwc';

export default class Interoperability extends LightningElement {
    @api label = 'This label property has its initial value';
    timesInvoked = 0;

    handleClick() {
        this.dispatchEvent(
            new CustomEvent('buttonclicked', { bubbles: true, composed: true })
        );
    }

    @api
    doWhatever() {
        this.timesInvoked++;
    }

    get message() {
        return `LWC Method invoked ${this.timesInvoked} times`;
    }
}
```

### 호스트(VF/외부) 쪽 상호운용 3방향

| 방향 | 방법 | 실전 코드 |
|---|---|---|
| **속성 설정** (호스트 → LWC) | `@api` 프로퍼티에 직접 대입 | `document.querySelector('c-interoperability').label = '...';` |
| **메서드 호출** (호스트 → LWC) | `@api` 메서드를 요소에서 직접 호출 | `document.querySelector('c-interoperability').doWhatever();` |
| **이벤트 수신** (LWC → 호스트) | `addEventListener`로 CustomEvent 청취 | `lwc.addEventListener('buttonclicked', handleLWCEvent);` |

```javascript
// 실전 예시: pages/interoperability.page — 호스트 함수들
function callLWCMethod(event) {
    var lwc = document.querySelector('c-interoperability');
    lwc.doWhatever();                     // @api 메서드 호출
}

function setLWCProperty(event) {
    var lwc = document.querySelector('c-interoperability');
    lwc.label = 'The label property was updated from Visualforce';  // @api 속성 설정
}

function handleLWCEvent() {              // LWC가 올린 CustomEvent 수신
    document.querySelector('p.messages').textContent =
        timesListened + ' messages listened from LWC';
    timesListened++;
}
```

> ⚠️ 이벤트가 호스트 페이지까지 올라오려면 LWC의 `CustomEvent`가 **`{ bubbles: true, composed: true }`** 여야 한다(위 `handleClick` 참조). shadow DOM·이벤트 전파 규칙은 [[CustomEvent 패턴]].

VF 마크업 쪽 컨테이너·버튼 연결:

```html
<!-- 실전 예시: pages/interoperability.page 발췌 -->
<apex:form>
    <apex:commandButton onclick="setLWCProperty();" onComplete="return null;"
        value="Press me and set a LWC property!" />
    <apex:commandButton onclick="callLWCMethod();" onComplete="return null;"
        value="Press me and call a LWC method!" />
</apex:form>
<p class="messages">0 messages listened from LWC</p>
<div id="lwc-container"></div>   <!-- $Lightning.createComponent 의 domLocator -->
```

---

## 외부(비-Salesforce) 페이지 호스팅

외부 웹 서버에 임베드할 때 추가로 필요한 것:

```html
<!-- 구조 예시 — 실제 동작 코드 아님 (외부 사이트) -->
<script src="https://MyDomain.lightning.force.com/lightning/lightning.out.js"></script>
<div id="lightning" />
<script>
  $Lightning.use(
    "c:LWCContainerApp",                                  // 의존성 앱
    function() {
      $Lightning.createComponent("c:interoperability", {}, "lightning",
        function(cmp) { /* ... */ });
    },
    "https://MyDomain.lightning.force.com",               // lightningEndPointURI
    "<OAuth access token 또는 Session ID>"                 // authToken (게스트면 생략)
  );
</script>
```

- **인증**: OAuth 2.0 Connected App(또는 SOAP login)으로 유효한 세션의 access token을 서버 측에서 취득해 `authToken`으로 전달.
- **인스턴스 일치**: `lightning.out.js`를 로드한 인스턴스와 `lightningEndPointURI`가 동일해야 한다.
- **CORS/도메인**: Lightning 컴포넌트와 외부 페이지는 서로 다른 도메인에서 서빙되므로 관련 쿠키는 **third-party cookie**로 취급된다.

---

## 제약·주의사항

| 제약 | 내용 |
|---|---|
| **같은 org** | 의존성 앱·컴포넌트는 VF 페이지와 **동일 org**에 존재해야 함 |
| **선언된 것만 생성** | `aura:dependency`에 없는 컴포넌트는 `createComponent`로 만들 수 없음 |
| **단일 앱 참조** | 한 페이지의 모든 `$Lightning.use` 호출은 **같은 의존성 앱**을 참조해야 함 |
| **third-party cookies** | 외부 도메인 임베드 시 브라우저가 third-party 쿠키로 처리 → 사용자가 브라우저에서 third-party 쿠키를 **허용**해야 동작 |
| **Lightning Web Security** | ⚠️ **LWS 활성화 org에서는 Lightning Out 미지원** — Lightning Out이 필수면 Lightning Locker를 사용해야 함 ([[Lightning Web Security vs Lightning Locker]]) |
| **콜백 순서** | `createComponent`는 반드시 `$Lightning.use`의 **콜백 안**에서 호출 |

---

## Lightning Out 클래식 vs Lightning Out 2.0 (선택 기준)

| 기준 | 클래식 Lightning Out (이 노트) | Lightning Out 2.0 |
|---|---|---|
| 임베드 대상 | **Visualforce 페이지** + 외부 사이트 | 외부(비-Salesforce) 앱 |
| API 방식 | `$Lightning.use`/`createComponent` JS + `ltng:outApp` Aura 앱 | `<lightning-out-application>` 웹 컴포넌트 + Setup App Manager |
| 런타임/격리 | 호스트 DOM에 직접 렌더 | LWR 기반, closed shadow DOM 내 **iframe** 캡슐화 |
| 인증 | `authToken`(OAuth/Session) 직접 전달 | `frontdoor-url`(UI Bridge API) |
| Visualforce 지원 | ✅ 정본 경로 | ❌ (외부 앱 전용) |
| 상태 | GA·안정 | GA (외부 시나리오에서 beta Lightning Out 대체) |

> **VF에 임베드**하려면 이 노트의 클래식 경로를 쓴다. 순수 **외부 웹 앱**이면 [[Lightning Out 2.0 (외부 앱 임베드)]]가 권장 경로다.

---

## 관련 노트
- [[Lightning Out 2.0 (외부 앱 임베드)]] — 외부 앱용 신형 `lightning-out-application` 기반 임베드(iframe·LWR). 이 노트의 클래식 API를 외부 시나리오에서 대체
- [[CustomEvent 패턴]] — LWC → 호스트로 이벤트를 올릴 때 필요한 `bubbles`/`composed` 규칙
- [[Aura vs LWC]] — Lightning Out 의존성 앱은 Aura, 임베드 컴포넌트는 LWC/Aura 둘 다 가능
- [[Lightning Web Security vs Lightning Locker]] — ⚠️ LWS 활성화 org는 Lightning Out 미지원
- [[JavaScript·Remoting·LMS across DOM]] — VF 페이지에서 JS로 컴포넌트·DOM 간 통신하는 다른 경로들과 비교
- [[Salesforce 앱 개발 — LEX·모바일·AppExchange]] — VF/Lightning 컨테이너 전반의 앱 개발 맥락
- [[Visualforce 개요 — 도구·퀵스타트]] — Visualforce 기본
