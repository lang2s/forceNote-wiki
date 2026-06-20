---
tags: [security, lwc, lwr, experience-cloud, lws, lightning-web-security, csp, 보안, 격리모델]
source: exp_cloud_lwr.pdf (LWR Sites for Experience Cloud, v66.0 Spring '26)
created: 2026-06-20
aliases: [Lightning Web Security, LWS, Lightning Locker, secure wrapper, namespace sandbox, cross-namespace, LWS 활성화, LWS vs Locker 차이, Locker에서 LWS 전환, x-oasis-script, Privileged Script Tag, LWR 보안, LWS 미지원 속성, third-party script LWR]
---

# Lightning Web Security (LWS)

> LWR 사이트는 Lightning Locker를 대체하는 LWS로 보안 격리 — namespace별 sandbox로 document/window/element를 secure wrapper 없이 직접 노출하고 cross-namespace 통신을 허용.

---

## 개요 — LWS란

**Lightning Web Security (LWS)** 는 Lightning web components를 위한 새 보안 아키텍처로, **Experience Cloud의 LWR 사이트는 Lightning Locker 대신 LWS를 사용**한다.

- LWS는 Lightning Locker가 제공하던 통상적인 보안 기능에 더해, **Lightning web components 간 cross-namespace 통신**을 지원한다.
- 각 namespace에 **자체 sandbox**가 부여되므로, `document`·`window`·`element` global을 **secure object wrapper 없이 직접 노출**할 수 있다. 그 결과 더 많은 표준 DOM API가 정상 동작하고, namespace 내에서 노출된 API는 secure wrapper 없는 일반 웹 컨텍스트와 동일하게 동작한다.
- 이 직접 노출 덕분에 **analytics·charting 같은 third-party 라이브러리**를 Lightning web components 안에서 더 쉽게 통합할 수 있다.

> PDF 원문: *"Instead of Lightning Locker, LWR sites in Experience Cloud use Lightning Web Security (LWS), the new security architecture for Lightning web components."*

---

## Locker 대비 핵심 차이

LWS의 가장 두드러진 차이는 **cross-namespace communication**이다. cross-namespace 통신은 다른 namespace의 컴포넌트를 **import해서 composition 또는 extension으로 사용**할 수 있게 한다.

> ⚠️ 아래 표에서 **"Locker 대비"** 칸은 PDF가 Locker의 동작을 직접 서술한 것이 아니라, `"Instead of Locker"`·`"in addition to ... Lightning Locker"` 어법에서 **함의(implication)** 로 읽은 것이다. PDF는 Locker의 격리 단위·위협모델을 서술하지 않는다. 정식 Locker 위협모델은 [[Lightning Security 모델]] 참조.

| 항목 | LWS (PDF 명시) | Locker 대비 (PDF 함의 — 직접 서술 아님) |
|---|---|---|
| cross-namespace 통신 | 지원 — composition/extension으로 타 namespace 컴포넌트 import | `"in addition to the usual security features that Lightning Locker provides"` → Locker는 미지원으로 함의 |
| global 객체(document/window/element) | namespace sandbox 안에서 secure object wrapper 없이 직접 노출, 표준 DOM API 동작 | `"without secure object wrappers"` → Locker는 secure wrapper 경유로 함의 |
| third-party 라이브러리(analytics/charting) | 통합 용이 | (PDF 미언급) |
| 격리 단위 | namespace별 sandbox | (PDF에 Locker 격리 단위 서술 없음 → [[Lightning Security 모델]] 참조) |

---

## LWR에서의 LWS 활성화 / 제어

**LWR 사이트는 자체 LWS 인스턴스를 사용한다.**

- ⚠️ Setup의 **Session Settings**에 있는 *"Use Lightning Web Security for Lightning web components (GA) and Aura components (Beta)"* 설정(= org-level, *Enable Lightning Web Security in an Org*)은 **LWR 사이트에 영향을 주지 않는다.**
- 대신 **Experience Builder의 site-level 설정**이 그 사이트의 LWS 사용 여부를 제어하며, 이는 org-level 설정과 무관하다.

> PDF 원문: *"LWR sites use their own instance of LWS. The Use Lightning Web Security for Lightning web components (GA) and Aura components (Beta) setting in Session Settings in Setup ... has no effect on LWR sites. Instead, the site-level setting in Experience Builder controls whether the site uses LWS, regardless of the org-level setting."*

---

## LWS 제약 (미지원 속성)

LWR 사이트의 LWS에서 현재 **지원되지 않는 속성**은 다음 4종이다. (PDF는 각각의 설명을 제공하지 않으므로 여기서도 임의 설명을 덧붙이지 않는다.)

- `document.domain`
- `document.location`
- `window.location`
- `window.top`

> PDF 원문: *"These properties are currently unsupported for LWS in LWR sites."*

---

## Privileged Script Tag `<x-oasis-script>`

> ⚠️ PDF는 이 기능을 LWS sandbox와 명시적으로 연결하지 않는다. **LWS와 별개의, LWR 전용 보안 우회(shadow DOM bypass) 기능**으로 읽어야 한다. 아래 인과 연결은 PDF 서술 범위로 제한한다.

LWR 사이트의 일부 컴포넌트는 element를 **shadow DOM에 캡슐화**하므로 그 컴포넌트와의 global 상호작용이 차단된다. 그 결과 Google Analytics·Google Tag Manager 같은 third-party JavaScript 라이브러리가 LWR 사이트에서 DOM을 global하게 query하기 어렵다. DOM 내 element에 프로그래밍적으로 접근해야 할 때 **`<x-oasis-script>` privileged script tag** 안에 스크립트를 작성한다. 이 태그로 로드한 라이브러리는 **shadow DOM 경계를 우회**한다.

### 동작

- 표준 `<script>` 대신 `<x-oasis-script>` 를 **head markup 또는 inline**에 사용한다.
- 이 커스텀 태그 안에서 로드된 스크립트는 **shadow DOM에서 면제된 special iframe 안에서 실행**되며, **항상 비동기로(asynchronously)** 실행된다.
- `<x-oasis-script>` 는 `<script>` 태그와 **동일한 syntax**를 사용한다.

```html
<x-oasis-script src="third_party_library.js"></x-oasis-script>
```

### 속성

| 속성 | 동작 |
|---|---|
| `imported-global-names` | outer window에 정의된 global 변수를 privileged scope(x-oasis-script window)로 **import**. global 변수는 privileged scope에서 정의되려면 반드시 import되어야 한다 |
| `exported-global-names` | x-oasis-script에서 정의한 global 변수를 **export** |
| `hidden="true"` | 태그 안에 custom code가 있을 때 추가. 페이지 로드 중 custom code를 사이트 방문자에게 **숨김** |
| `async` | (위 `src` 로드 예시처럼) 라이브러리를 비동기 로드 |

**import 예제** — outer window에 `testVar`를 정의하고 x-oasis-script로 import:

```html
<script>
window.testVar = "myTestVar";
</script>
<x-oasis-script hidden="true" imported-global-names="testVar">
// Custom code to access testVar
console.log(window.testVar)
</x-oasis-script>
```

**export 예제** — x-oasis-script에서 `testVar`를 export:

```html
<x-oasis-script hidden="true" exported-global-names="testVar">
window.testVar = "myTestVar";
</x-oasis-script>
<script>
// setTimeout is needed in case this script tag is run before oasis script
setTimeout(function(){
// Custom code to access testVar
console.log(window.testVar)
}, 5000);
</script>
```

### 사전 설정 (Relaxed CSP · Trusted Sites for Scripts)

third-party 라이브러리를 inline 또는 head markup에 포함하면 다음 두 가지를 설정해야 한다.

- Experience Builder의 **Settings > Security & Privacy**에서 **Relaxed CSP**로 전환.
- 같은 페이지의 **Trusted Sites for Scripts** 목록에 해당 스크립트 URL(remote host)을 추가(allowlist).

> PDF 원문: *"If you include a third-party library inline or in the head markup, remember to switch to Relaxed CSP and to allowlist the remote host."*

### 코드 예제 (PDF 인용)

**Google Analytics 라이브러리 로드** (`{id}` = Google Analytics ID):

```html
<x-oasis-script async src="https://www.googletagmanager.com/gtag/js?{id}"></x-oasis-script>
```

**Google Tag Manager 스니펫** — head markup에 embed, `XXXX`를 GTM ID로 교체:

```html
<x-oasis-script hidden="true">(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-XXXX');</x-oasis-script>
```

> ⚠️ GTM은 `<x-oasis-script>`로 로드한 트리거·이벤트가 **Google Tag Manager Preview mode에서는 보이지 않는다.** 확인하려면 live mode로 전환한다. (PDF 원문 명시)

---

## 소스 범위 / 더 보기

> ⚠️ 이 노트의 출처 PDF(`exp_cloud_lwr.pdf`, LWR Sites for Experience Cloud)는 **LWR 사이트 맥락의 LWS만** 다룬다. 다음 내용은 **이 PDF에 없으므로 여기서 재현하지 않는다:**
> - LWS의 **distortion** 메커니즘 (API별 동작 변경 규칙)
> - **secure wrapper 내부 동작** 상세
> - **LWS vs Lightning Locker 정식 대칭 비교표**
>
> 이 내용이 필요하면 **LWC Developer Guide의 "Lightning Web Security" 가이드**(외부)를 참조한다. PDF 본문도 `"See Lightning Web Security in the Lightning Web Components Developer Guide."`로 동일하게 deep-link한다.

---

## 관련 노트
- [[Lightning Security 모델]] — Lightning Locker 위협모델·CSP·JS 제약(secure_coding Ch11). LWS의 대비 대상인 Locker 상세
- [[LWC 보안 패턴]] — LWC 보안 코딩 패턴(customPermission·CSP·DOM)
- [[LWC Shadow DOM 모드]] — Shadow DOM 모드와 Locker/LWS 통합
- [[LWR Sites (Experience Cloud)]] — LWR 사이트 구축(같은 PDF 출처). Privileged Script Tag도 여기 맥락
- [[공유 JS 모듈]] — LWC 간 JS 공유 시 Locker/LWS 제약
- [[LWR 동작·캐싱·제약]] — LWR 사이트 LWS 미지원 속성(document.domain 등)·Differences in Behavior에서 LWS 위임하는 spoke
