---
tags: [lwc, overview, get-started, web-components, aura-interop]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Get Started with Lightning Web Components; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/get-started-introduction.html
created: 2026-07-04
aliases: [LWC, Lightning Web Components, LWC 개요, LWC 시작, Get Started, Web Components, base components, Aura interop, LWC vs Aura]
---

# LWC 개요 (Get Started)

> Lightning Web Components(LWC)는 HTML·JavaScript로 만드는 커스텀 HTML 요소로 Salesforce Platform에 커스텀 UI·앱·digital experience를 구축하는 프레임워크다. 이 노트는 LWC 섹션의 개념 진입점으로, 무엇이고 왜 쓰는지와 시작 경로를 짚고 심층 주제는 기존 노트로 위임한다.

---

## 정의 · Editions

**Lightning Web Components(LWC)** 프레임워크로 Salesforce Platform에서 커스텀 UI, 웹·모바일 앱, digital experience를 구축한다. 하나의 **Lightning web component**는 **HTML과 JavaScript로 만든 커스텀 HTML 요소**다.

**제공 환경(Editions):**

- Available in **Lightning Experience**.
- **Enterprise**, **Performance**, **Unlimited**, **Developer** Edition에서 사용 가능.

---

## Base components

Salesforce는 **Lightning Design System(SLDS)** 기반의 **Lightning base components**를 제공한다. 이는 커스텀 경험을 만드는 building block으로, 일관된 look & feel을 보장하고 개발을 단순화한다. Lightning Experience 자체가 SLDS와 base component 위에 만들어져 있다.

base component는 **LWC와 Aura Components 양쪽 모두**로 제공된다.

> base component 카탈로그·개별 사용법은 [[LWC MOC]]의 BaseComponents 섹션 참조 — 이 개요에서는 재서술하지 않는다.

---

## 표준 웹 기술 (Write Standard JavaScript and HTML)

LWC는 핵심 **Web Components 표준**을 사용하고, Salesforce가 지원하는 브라우저에서 잘 동작하는 데 필요한 것만 제공한다. 브라우저 네이티브 코드 위에서 동작하므로 **경량이면서 뛰어난 성능**을 낸다. 작성하는 코드 대부분은 표준 JavaScript와 HTML이다.

Salesforce는 표준의 진화에도 관여한다.

- **W3C** 멤버.
- **TC39**(ECMAScript/JavaScript 언어를 발전시키는 위원회)에 기여.
- LWC는 **오픈소스**다.

최소 형태의 Lightning web component는 다음과 같이 HTML 커스텀 요소와 JavaScript 클래스로 구성된다.

```html
<!-- 구조 예시 — 최소 LWC(실제 배포 코드 아님) -->
<!-- helloWorld.html -->
<template>
    <p>Hello, {name}!</p>
</template>
```

```javascript
// 구조 예시 — 최소 LWC(실제 배포 코드 아님)
// helloWorld.js
import { LightningElement } from 'lwc';

export default class HelloWorld extends LightningElement {
    name = 'World'; // 예시값
}
```

> 데코레이터(`@api`·`@track`·`@wire`)·라이프사이클·reactivity 등 심층 메커니즘은 이 개요에서 다루지 않는다 — [[LWC MOC]]에서 해당 노트로 진입한다.

---

## Backwards Compatibility (Aura 공존 · LWC 우선)

Lightning 컴포넌트에는 두 가지 프로그래밍 모델이 있다.

- **Lightning Web Components(LWC)** — 최신 모델.
- **Aura Components** — 원조(original) 모델.

두 모델은 **한 페이지에서 공존하고 상호운용(coexist·interoperate)** 한다. 어드민과 엔드유저에게는 둘 다 똑같이 Lightning component로 보인다. 앞서 언급했듯 base component도 LWC·Aura 양쪽에서 제공된다.

**선택이 가능하다면 LWC를 택한다(choose LWC).**

> 두 모델의 상세 비교·상호운용 방식·선택 기준은 [[Aura vs LWC]] 참조 — 여기서는 재서술하지 않는다.

---

## 시작 경로 (Get Started paths)

공식 Get Started가 제시하는 진입 경로:

- **Create Your First Component** — 첫 컴포넌트 만들기.
- **Set Up Development Environment** — 개발 환경 설정.
- **Explore Trailhead and Sample Code** — Trailhead·샘플 코드 탐색.
- **Work with Salesforce Data** — Salesforce 데이터 다루기.
- **Customize Salesforce Features** — Salesforce 기능 커스터마이즈.

---

## 관련 노트
- [[Aura vs LWC]] — 두 프로그래밍 모델 상세 비교·상호운용·선택 기준
- [[LWC 오픈소스 아키텍처]] — LWC 오픈소스 내부 구조
- [[LWC MOC]] — LWC 섹션 전체 목차 (심층 주제 진입점)
