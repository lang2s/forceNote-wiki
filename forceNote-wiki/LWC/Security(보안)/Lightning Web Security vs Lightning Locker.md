---
tags: [lwc, security, lws, lightning-locker, client-side-security, csp, strict-mode]
source: developer.salesforce.com (Security for Lightning Components — How LWS Compares to Lightning Locker; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lightning-components-security/guide/get-started-compare-lws-locker.html
created: 2026-07-04
aliases: [Lightning Web Security, LWS, Lightning Locker, 클라이언트 보안, client-side security, distortion, secure wrapper, JavaScript strict mode, CSP, Content Security Policy, 가상 JS 샌드박스, custom elements 보안]
---

# Lightning Web Security vs Lightning Locker

> Lightning 컴포넌트(LWC·Aura)를 보호하는 두 클라이언트측 보안 아키텍처 — org는 둘 중 하나만 활성화하며, LWS가 신규 org 기본이고 Locker보다 제약이 적다.

---

## 개요 — 클라이언트측 보안 아키텍처

Lightning 컴포넌트(LWC·Aura)는 **클라이언트측 보안 아키텍처 계층**으로 보호된다. 이 계층은 컴포넌트가 다른 네임스페이스나 플랫폼 코드의 데이터에 명시적 권한 없이 접근하는 것을 방지하고, 안전하지 않은 API 동작을 자동으로 차단하거나 수정한다.

org는 **Lightning Web Security(LWS) 또는 Lightning Locker 중 하나**를 활성화한다 (둘을 동시에 쓰지 않는다).

| 아키텍처 | 요약 |
|---|---|
| **Lightning Web Security (LWS)** | Spring '22에 도입된 신 아키텍처. 최신 **TC39** 웹 표준 기반. 컴포넌트를 **가상 JavaScript 샌드박스**에서 실행해 안전하지 않은 코드 동작을 방지한다. Locker보다 **제약이 적고 기능이 많다**. **신규 org 기본 활성화.** |
| **Lightning Locker** | LWS의 전신(predecessor). 샌드박스 대신 **JavaScript 객체를 더 안전한 버전으로 wrapping**한다. |

어떤 보안 아키텍처를 쓰든 무관하게, Lightning 컴포넌트는 아래 두 브라우저 네이티브 메커니즘을 공통으로 사용한다.

- **JavaScript strict mode** — 브라우저 네이티브 보안 기능.
- **Content Security Policy(CSP)** 규칙 — 로드 가능한 콘텐츠의 소스를 제어한다.

---

## LWS가 Locker 대비 추가로 지원하는 것

LWS는 제약을 줄이면서 Locker에서 불가능하거나 제한되던 다음 기능을 지원한다.

- **타 네임스페이스의 컴포넌트/모듈 import 및 컴포지션 사용** — 네임스페이스마다 **분리된(detached) JavaScript 샌드박스**를 두어 `window`·`document`·`element` 같은 global을 노출할 수 있다.
- **iframe 요소의 콘텐츠 접근** — 브라우저는 기본적으로 cross-origin 접근을 차단하므로 postMessage 등을 통해 상호작용한다.
- **custom element 생성 및 서드파티 web component 사용.**
- **JavaScript 샌드박스 실행이 Locker보다 빠르다.**
- **라이브러리가 global 객체(`window`·`document`·`element`)를 조작 가능** — JS 샌드박스 내에서 실행되기 때문.
- **최신 TC39 표준을 모델링**한다.

---

## 비교표 — Locker vs LWS (9개 항목 전수)

| Feature | Lightning Locker | Lightning Web Security |
|---|---|---|
| **JavaScript strict mode** | Enforced | Enforced |
| **DOM access containment** | 컴포넌트가 자신이 생성한 요소만 접근. LWC는 `shadowRoot` 밖으로 나갈 수 없음 | 브라우저가 **Shadow DOM**(web 표준·`shadowRoot` mode)으로 DOM 접근을 제어 |
| **Secure wrappers** | JavaScript 객체를 더 안전한 버전으로 **wrapping** | wrapper를 사용하지 않음. **distortion**으로 비보안을 유발하는 API만 선택적으로 수정 |
| **Custom elements 허용?** | `customElements`를 차단 | API를 virtualize해 컴포넌트 네임스페이스 내에서 custom element 사용을 허용(`customElementRegistry`) |
| **`eval()` 제한** | `eval()`을 global scope로 제한 | `eval()`을 차단하지 않고, 샌드박스 distortion으로 비안전 활동을 방지 |
| **Blob 객체 MIME 타입** | 허용 MIME 타입 리스트 사용 | 같은 MIME 타입을 허용하되, **Blob 생성 시 MIME 타입 명시 필수** |
| **자식 컴포넌트에 전달되는 배열** | 컴포넌트 간 배열 필터링이 성능 문제를 유발할 수 있음 | DOM 요청을 필터링하지 않아 성능 문제를 해결 |
| **이전 Locker 버전으로 복귀** | org를 이전 Locker 규칙 버전으로 설정하는 것을 지원 | Locker API Version 설정은 LWS에 **무효** |
| **Lightning Out (Beta)·Lightning Components for Visualforce (Beta)** | Lightning Out을 사용하려면 Locker가 필요 | ⚠️ **LWS 활성화 시 Lightning Out 미지원** |

> ⚠️ **핵심 제약 — Lightning Out:** LWS가 활성화된 org에서는 Lightning Out(외부 앱에 Lightning 컴포넌트 임베드)이 **지원되지 않는다.** Lightning Out이 필수인 경우 Lightning Locker를 사용해야 한다. 자세한 임베드 패턴은 [[Lightning Out 2.0 (외부 앱 임베드)]] 참조.

---

## 핵심 개념 — wrapper(Locker) vs distortion(LWS)

두 아키텍처의 가장 근본적인 차이는 **비보안 API를 다루는 방식**이다.

- **Lightning Locker — Secure Wrapper 방식:** JavaScript 객체 전체를 "더 안전한 버전"으로 감싼다(wrapping). 컴포넌트가 원본 객체 대신 wrapper를 다루게 되어 안전하지만, 그만큼 표준 API와의 호환성 제약이 생긴다.
- **Lightning Web Security — Distortion 방식:** 객체를 통째로 감싸지 않고, **비보안을 유발하는 특정 API 동작만 선택적으로 수정(distort)**한다. 나머지는 표준 그대로 동작하므로 제약이 적고 실행이 빠르다.

```javascript
// 구조 예시 — 실제 동작 코드 아님. 두 방식의 개념적 차이를 도식화한 것.

// [Lightning Locker] 객체 전체를 안전한 버전으로 wrapping
const secureDocument = SecureWrapper(document);  // document 전체가 wrapper로 교체됨
secureDocument.querySelector('...');             // wrapper를 통해서만 접근

// [LWS] 샌드박스 내에서 표준 객체를 그대로 쓰되, 비보안 API만 distort
document.querySelector('...');                   // 표준 그대로 동작
// eval(...) 등 위험 동작은 샌드박스 distortion이 개입해 안전 처리
```

CSP·strict mode는 두 아키텍처가 공통으로 사용하는 브라우저 네이티브 계층이며, 위 wrapper/distortion 위에 겹쳐 적용된다.

> 참고: LWS·Locker의 세부 설정 절차, strict mode 규칙, CSP 지시자, distortion 목록, Experience Builder Sites와 LWS 등 세부 주제는 각 공식 문서(intro·strict mode·CSP·distortions 페이지)로 위임된다. 이 노트는 두 아키텍처의 비교에 초점을 둔다.

---

## 관련 노트
- [[LWS 활성화·Locker 마이그레이션 절차]] — 이 비교를 실무로: Session Settings 토글로 LWS 켜기·Locker 마이그레이션·distortion 진단·롤백
- [[LWC 보안 패턴]] — LWC 보안 일반 패턴
- [[Lightning Out 2.0 (외부 앱 임베드)]] — ⚠️ LWS 미지원 제약이 걸리는 외부 임베드 패턴
- [[LWC Shadow DOM 모드]] — DOM access containment의 기반이 되는 Shadow DOM 모드
- [[Aura vs LWC]] — 두 컴포넌트 모델 비교(둘 다 이 보안 계층으로 보호됨)
- [[LWC MOC]]
