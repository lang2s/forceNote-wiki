---
tags: [lwc, lightning-out, external-app, lwr, iframe, embed, postmessage]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Use Components Outside Salesforce with Lightning Out 2.0; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/lightning-out-architecture.html
created: 2026-07-04
aliases: [Lightning Out 2.0, Lightning Out, 외부 앱 임베드, lightning-out-application, frontdoor-url, app-id, LWR, iframe, closed shadow DOM, lo.application.ready, lo.component.ready, window.postMessage, 외부 사이트 LWC]
---

# Lightning Out 2.0 (외부 앱 임베드)

> 비-Salesforce 외부 앱에 커스텀 LWC를 임베드하는 특수 Salesforce 앱. LWR 기반이며 임베드 컴포넌트를 shadow DOM 내 iframe에 캡슐화한다. Lightning Out(beta)를 완전히 대체하는 GA 기능.

---

## 개요

**Lightning Out 2.0**은 외부(비-Salesforce) 앱 페이지에 커스텀 Lightning Web Component를 임베드하기 위한 특수 Salesforce 앱이다. **Setup에서 생성·구성**하며, 생성된 마크업을 외부 앱 페이지에 붙여 넣어 사용한다.

- **LWR(Lightning Web Runtime) 기반**으로 동작한다. 임베드된 컴포넌트를 **shadow DOM 내 iframe에 캡슐화**하여, 컴포넌트를 더 안전하게 유지하면서도 외부 앱과 빠르고 반응적인 상호작용을 가능하게 한다.
- ⚠️ **Lightning Out(beta)를 완전히 대체(replace)한다 — 확장(extension)이 아니다.** Lightning Out 2.0은 **GA**이며, 기존 beta 버전은 Beta Service Terms가 적용된다.

하위 주제: 아키텍처 · 컴포넌트 스타일/프로퍼티 설정 · 이벤트 처리 · 제약 · beta 비교.

---

## 아키텍처

외부 host 페이지에 **Lightning Out 2.0 JavaScript 라이브러리를 `<script>`로 포함**한다. 필요한 코드 블록은 Lightning Out 2.0 App Manager가 제공한다.

host 페이지가 스크립트를 초기화하면, host 페이지 컨텍스트에 커스텀 web component **`lightning-out-application`**이 생성된다.

### `lightning-out-application` 필수 3속성

| 속성 | 설명 |
|---|---|
| `frontdoor-url` | Salesforce 세션 확립용 frontdoor URL. **동적으로 설정**한다 (Set Up Authentication 참조). |
| `app-id` | 18자리 Lightning Out 2.0 앱 ID (예: `1Usfi200000006TCAQ`). App Manager에서 확인. |
| `components` | 임베드할 LWC 컴포넌트의 comma-separated 목록. 형식은 `c-my-component`(하이픈 표기). 복잡한 네임스페이스는 `complex_ns-lwc-component` 형식. |

- 코드 블록에는 `lightning-out-application`(`app-id`·`components` 속성 포함)과 함께, `components`에 나열한 LWC를 미러링하는 **다른 Lightning Out 2.0 web component**들이 포함된다.
- 각 Lightning Out 2.0 web component는 **iframe을 포함**하며, 이 iframe이 **closed shadow DOM의 root**가 된다.
- 각 Lightning Out 2.0 web component에는 대응 LWC가 노출하는 **아무 속성이나 값을 설정할 수 있다.** 예를 들어 `c-my-lwc`에 `style="--custom-color: brown;"`을 설정할 수 있다 (`style`은 global 속성이며, `c-my-lwc`에 `--custom-color`를 설정하는 것).

### Lifecycle 커스텀 이벤트 (4)

| 이벤트 | 발생 시점 | `detail` |
|---|---|---|
| `lo.application.ready` | Salesforce 세션이 성공적으로 확립될 때. | — |
| `lo.application.error` | 세션 확립에 실패할 때. | `message`(에러 메시지), `originalError`(Salesforce 컨텍스트 내부의 원본 에러) |
| `lo.component.ready` | Lightning Out 2.0 컴포넌트가 임베드 LWC와 함께 성공적으로 렌더될 때. | — |
| `lo.component.error` | 컴포넌트 렌더 실패 또는 임베드 LWC에서 에러 발생 시. | `message`, `originalError` |

### 초기화 흐름 (9단계)

1. 엔드유저가 host 페이지를 오픈한다.
2. host 페이지가 **UI Bridge API**를 통해 유효한 Salesforce access token/Session ID를 frontdoor URL과 교환한다.
3. host 페이지가 `lightning-out-application`에 `frontdoor-url` 속성을 설정한다.
4. Lightning Out 2.0 스크립트가 frontdoor URL로 앱을 초기화하고 Lightning 세션을 확립한다.
5. 세션이 성공하면 `lo.application.ready`가 fire된다.
6. 다른 Lightning Out 2.0 web component들이 초기화된다. 각각은 iframe을 포함하며, 이 iframe이 closed shadow DOM의 root가 된다.
7. iframe 내부에서 대응하는 커스텀 LWC가 초기화된다 (Salesforce 컨텍스트에서 실행).
8. Lightning Out 2.0 web component(host 페이지 컨텍스트)가 iframe을 렌더한다.
9. 컴포넌트가 성공적으로 렌더되면 `lo.component.ready`가 fire된다.

---

## 이벤트 처리

컴포넌트는 host 페이지에 직접 로드되지 않고 iframe에 로드된다. 따라서 iframe 경계를 넘는 통신 제약을 극복하기 위해, Lightning Out 2.0은 커스텀 이벤트를 **`window.postMessage()`** 메시지로 래핑한다. iframe 한쪽의 리스너가 반대쪽에서 dispatch된 이벤트를 감지한다.

개발자 관점에서는 이 메커니즘이 투명하게 처리되므로, 표준 **`EventTarget`·`CustomEvent`** API로 이벤트를 생성·처리하면 된다.

> LWC 내부의 CustomEvent 생성·dispatch·리스닝 패턴은 [[CustomEvent 패턴]] 참조.

---

## 코드 예시

```html
<!-- 구조 예시 — 실제 동작 코드 아님 (예시값 사용) -->
<!-- 외부 host 페이지 -->
<head>
  <!-- Lightning Out 2.0 App Manager가 제공하는 JS 라이브러리 -->
  <script src="https://<myDomain>.lightning.force.com/lightning/lightning.out.js"></script>
</head>
<body>
  <lightning-out-application
    app-id="1Usfi200000006TCAQ"
    components="c-my-component"
    frontdoor-url="">
    <!-- components에 나열한 LWC를 미러링하는 web component -->
    <c-my-component style="--custom-color: brown;"></c-my-component>
  </lightning-out-application>
</body>
```

```javascript
// 구조 예시 — 실제 동작 코드 아님
// host 페이지: UI Bridge API로 얻은 frontdoor URL을 동적으로 설정
const loApp = document.querySelector('lightning-out-application');
loApp.setAttribute('frontdoor-url', frontdoorUrl); // (2)(3)

// 세션 확립 성공 리스너
loApp.addEventListener('lo.application.ready', () => {
  console.log('Salesforce session established'); // (5)
});

// 세션 확립 실패 리스너
loApp.addEventListener('lo.application.error', (event) => {
  console.error(event.detail.message, event.detail.originalError);
});

// 임베드 컴포넌트 렌더 완료 리스너
loApp.addEventListener('lo.component.ready', () => {
  console.log('Embedded LWC rendered'); // (9)
});
```

---

## 제약 및 Setup

- **제약(limitations):** 현재 Lightning Out 2.0에는 알려진 제약이 존재한다. 상세 목록은 공식 문서의 별도 Limitations 페이지에 위임된다 (본 위키에는 미수록).
- **Setup 방법(위임):** 생성·인증 설정 절차는 Salesforce Help에 위임된다.
  - "Extend Salesforce to External Apps with Lightning Out 2.0"
  - "Build a Lightning Out 2.0 App"
  - "Set Up Authentication"

---

## 관련 노트
- [[Aura vs LWC]] — Lightning 프로그래밍 모델 비교 (Lightning Out 2.0은 LWC 기반)
- [[LWR Sites (Experience Cloud)]] — Lightning Out 2.0이 기반으로 삼는 LWR 런타임
- [[CustomEvent 패턴]] — EventTarget/CustomEvent 이벤트 생성·처리
- [[LWC Shadow DOM 모드]] — 임베드 iframe이 root가 되는 closed shadow DOM
- [[LWC MOC]]
