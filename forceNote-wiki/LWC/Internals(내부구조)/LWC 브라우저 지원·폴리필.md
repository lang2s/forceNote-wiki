---
tags: [lwc, internals, browser-support, polyfill, synthetic-shadow, aria-reflection, custom-elements, locale, i18n]
source: https://developer.salesforce.com/docs/atlas.en-us.salesforce_app_dev.meta/salesforce_app_dev/requirements.htm ; https://lwc.dev/guide/browser_support ; https://github.com/salesforce/lwc (packages/@lwc/synthetic-shadow, @lwc/aria-reflection, @lwc/features)
created: 2026-07-08
aliases: [LWC browser support, LWC supported browsers, LWC polyfill, synthetic-shadow polyfill, aria-reflection, DISABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE, ENABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE, native custom element lifecycle, LWC IE11, LWC locale, LWC 브라우저 지원, LWC 폴리필]
---

# LWC 브라우저 지원·폴리필

> LWC가 실행되는 브라우저 매트릭스와, 표준 API가 없는 브라우저를 메우기 위해 플랫폼이 자동 주입하는 폴리필(synthetic Shadow DOM·ARIA reflection·custom element lifecycle)을 정리한다.

**상위:** [[index|Internals(내부구조) index]] → [[LWC MOC]] → [[00 Home]]

---

## 지원 브라우저 매트릭스

LWC는 **표준 웹 컴포넌트(Custom Elements v1 + Shadow DOM v1)** 를 실행 기반으로 하므로, 이를 지원하는 최신(evergreen) 브라우저에서 동작한다. Lightning Experience / Salesforce 모바일 앱의 지원 브라우저와 일치한다.

| 브라우저 | 데스크톱 지원 | 비고 |
|---|---|---|
| **Google Chrome** | ✅ 최신 안정 버전 | 권장. 가장 광범위한 테스트 대상 |
| **Microsoft Edge** | ✅ 최신 안정 버전 (Chromium 기반) | Chromium Edge만 지원. 레거시 EdgeHTML 미지원 |
| **Mozilla Firefox** | ✅ 최신 안정 버전 | |
| **Apple Safari** | ✅ 최신 안정 버전 (macOS) | 특정 최소 마이너 버전 이상 요구(릴리스별 상이) |
| **Internet Explorer 11** | ❌ **미지원** | 웹 컴포넌트 표준 부재. Salesforce가 LEX에서 IE11 지원을 종료함 |
| **레거시 Edge (EdgeHTML)** | ❌ 미지원 | Chromium Edge로 대체됨 |

- **Evergreen 원칙:** Salesforce는 "최신 안정 버전"만 지원한다. 특정 버전 번호를 고정하지 않고, 각 브라우저 벤더의 현재 릴리스를 기준으로 한다.
- **모바일:** Salesforce 모바일 앱은 iOS Safari(WKWebView) / Android Chrome(WebView) 최신 계열을 기반으로 한다.
- **IE11 종료의 의미:** IE11은 Custom Elements / Shadow DOM / ES2015+ 를 네이티브로 지원하지 못한다. 과거 LEX는 대량의 트랜스파일·폴리필로 IE11을 우회했으나, 유지 비용과 성능 저하로 지원이 종료됐다. 따라서 오늘날 LWC 폴리필은 **IE11 복구용이 아니라, evergreen 브라우저 간 표준 구현 격차를 메우는 용도**다.

### Lightning Experience 실행 요구사항

```text
// 요구사항 요약 — 실제 동작 설정 아님, 지원 매트릭스 개념 정리
- 최신 안정 버전의 Chrome / Edge(Chromium) / Firefox / Safari
- 데스크톱 해상도 권장: 1280×1024 이상
- JavaScript 활성화 필수 (LWC는 클라이언트 렌더링)
- 서드파티 쿠키/스토리지 차단 시 일부 기능(세션·iframe) 제약
```

> Salesforce는 릴리스마다 "Supported Browsers" 문서를 갱신한다. 정확한 최소 Safari 마이너 버전 등은 대상 릴리스의 공식 문서를 확인한다.

---

## 폴리필 패키지 개요

LWC 엔진은 여러 개의 독립 폴리필 패키지로 나뉘어 있다. **Salesforce 플랫폼(Lightning Experience)에서는 이들이 프레임워크 로더에 의해 자동 주입**되므로 개발자가 직접 설치하지 않는다. 오픈소스(off-platform) LWC를 직접 번들링할 때만 명시적으로 import 한다.

| 패키지 | 역할 | 로드 조건 | 플랫폼 자동 주입 |
|---|---|---|---|
| **`@lwc/synthetic-shadow`** | Shadow DOM v1을 JS로 에뮬레이트(synthetic shadow). DOM 트래버설 API를 패치해 컴포넌트 경계 격리를 흉내 | Synthetic Shadow 모드가 필요한 컴포넌트가 있을 때. 엔진보다 **먼저** 로드돼야 함 | ✅ (org의 Native Shadow 롤아웃 여부에 따라) |
| **`@lwc/aria-reflection`** | `Element.prototype.ariaLabel`, `ariaDescribedBy` 등 **ARIA IDL 반영 프로퍼티**를 지원 안 하는 브라우저에 폴리필 | ARIA reflection 표준 미구현 브라우저 | ✅ |
| **Custom Elements 폴리필** | `customElements.define`/업그레이드가 없는 환경 보정 | 표준 미지원 브라우저(현대 evergreen에선 대개 불필요) | 상황부 |
| **`@lwc/features`** | 런타임 feature flag 게이트. 폴리필/동작 전환의 스위치 | 항상 | ✅ (내부) |

### `@lwc/synthetic-shadow`

- **하는 일:** 네이티브 Shadow DOM이 제공하는 스타일·DOM 격리를 JavaScript로 재현한다. `querySelector`, `childNodes`, `assignedNodes`, 이벤트 리타게팅 등 다수의 DOM 프로토타입 메서드를 몽키패치한다.
- **로드 순서:** 전역 프로토타입을 패치하므로 반드시 **`@lwc/engine-dom`을 import 하기 전에** import 해야 한다.

```javascript
// 오픈소스(off-platform) 번들 진입점 — 구조 예시, 실제 동작 설정 아님
import '@lwc/synthetic-shadow';   // 반드시 최상단 — 전역 프로토타입 패치
import { createElement } from 'lwc';
import MyApp from 'my/app';

const app = createElement('my-app', { is: MyApp });
document.body.appendChild(app);
```

- **비용:** 프로토타입 패치는 페이지 전역 DOM 성능에 오버헤드를 준다. 이 때문에 Salesforce는 org를 **Native Shadow DOM** 으로 점진 이행 중이며, Native로 전환된 org에서는 synthetic-shadow 폴리필을 걷어낼 수 있다. (모드 상세는 [[LWC Shadow DOM 모드]])

### `@lwc/aria-reflection`

- ARIA reflection이란 `el.ariaLabel = '...'` 처럼 **속성(attribute) 대신 IDL 프로퍼티**로 접근성 상태를 읽고 쓰는 표준이다.
- 일부 브라우저/버전은 이 IDL 프로퍼티 집합을 구현하지 않아, LWC의 접근성 헬퍼가 동작하려면 폴리필이 필요하다.
- Native Shadow 이행과 함께, 브라우저가 표준을 완비하면 이 폴리필도 불필요해진다.

---

## Native custom element lifecycle

Custom Element 표준은 `connectedCallback` / `disconnectedCallback` 같은 **리액션 콜백**을 브라우저가 직접 호출하도록 정의한다. 초기 LWC 엔진은 이 콜백을 브라우저가 아니라 **엔진이 스스로 동기적으로 호출**하는 방식(비-네이티브)으로 동작해, 삽입/제거 타이밍이 표준과 미묘하게 달랐다.

이 동작을 전환하는 런타임 feature flag가 있다.

| Feature flag | 의미 |
|---|---|
| **`ENABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE`** | 브라우저의 네이티브 upgrade/reaction 콜백에 lifecycle을 위임(표준 동작). |
| **`DISABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE`** | 네이티브 lifecycle을 끄고 엔진 관리형(레거시) 동작으로 되돌림(하위 호환 세이프티 스위치). |

- 이 플래그들은 `@lwc/features` 기반의 런타임 스위치로, 플랫폼이 org 롤아웃 상태에 맞춰 설정한다. 개발자가 직접 켜고 끄는 값이 아니다.
- 네이티브 lifecycle로 전환되면 삽입/제거 콜백 순서·타이밍이 브라우저 표준을 따르므로, 이전 타이밍에 의존하던 코드가 드물게 영향을 받을 수 있다.
- 관련 런타임 플래그 전반은 [[LWC 런타임 Feature Flags]] 참조.

---

## 로케일·언어 지원

- LWC 자체는 렌더링 프레임워크이며, **로케일·언어·통화·시간대는 실행 중인 Salesforce org와 사용자 설정에서 온다.** 컴포넌트는 사용자의 로케일에 맞춰 자동으로 국제화된 값을 표시한다.
- **국제화 스코프드 모듈:** `@salesforce/i18n/*`(예: `lang`, `locale`, `currency`, `timeZone`, `dir`)로 현재 사용자의 로케일 메타데이터를 읽는다. `dir`은 RTL(오른쪽→왼쪽) 언어 방향을 제공한다.
- **번역 텍스트:** UI 문자열은 [[Custom Labels (커스텀 레이블)|Custom Labels]] 또는 `@salesforce/label/*` 모듈로 번역 대상으로 관리한다(하드코딩 지양).
- **포맷팅:** 숫자/날짜/통화 표시는 `lightning-formatted-*` 베이스 컴포넌트가 사용자 로케일 기준으로 처리한다.
- Salesforce가 지원하는 언어(플랫폼 언어/엔드유저 언어/플랫폼 전용 언어)의 집합은 org 설정 및 릴리스별 공식 문서를 따른다.

```javascript
// 구조 예시 — 실제 동작 코드 아님
import LANG from '@salesforce/i18n/lang';        // 예: 'ko'
import LOCALE from '@salesforce/i18n/locale';    // 예: 'ko-KR'
import DIR from '@salesforce/i18n/dir';          // 'ltr' | 'rtl'
import CURRENCY from '@salesforce/i18n/currency';// 예: 'KRW'
// → 이 값들은 사용자 로케일에서 오며, LWC 엔진이 만들어내는 게 아니다.
```

---

## 요약 — 언제 무엇이 개입하나

| 상황 | 개입 요소 |
|---|---|
| evergreen 브라우저 + Native Shadow org | 폴리필 최소(또는 없음), 브라우저 네이티브 격리 |
| 아직 Synthetic Shadow인 org | `@lwc/synthetic-shadow` 자동 주입, 프로토타입 패치 |
| ARIA IDL 프로퍼티 미구현 브라우저 | `@lwc/aria-reflection` 자동 주입 |
| lifecycle 타이밍 호환 이슈 | `*_NATIVE_CUSTOM_ELEMENT_LIFECYCLE` 플래그로 전환 |
| IE11 | ❌ 지원 대상 아님 (폴리필로도 미복구) |
| 국제화 | org/사용자 로케일 + `@salesforce/i18n/*` + Custom Labels |

---

## 관련 노트
- [[LWC Shadow DOM 모드]]
- [[LWC 오픈소스 아키텍처]]
- [[LWC 런타임 Feature Flags]]
- [[LWC MOC]]
