---
tags: [lwc, crm-analytics, dashboard, widget, analytics, target]
source: bi_dev_guide_lwc_in_db.pdf (Lightning Web Components in CRM Analytics and Lightning Dashboards, Summer '26, Tier 2)
created: 2026-06-14
aliases: [CRM Analytics LWC, 대시보드 LWC 위젯, analytics__Dashboard, LWC in CRM Analytics, Dashboard Widget, hasStep]
---

# CRM Analytics 대시보드용 LWC

> LWC를 **CRM Analytics·Lightning 대시보드의 커스텀 위젯**으로 캔버스 위에 네이티브하게 렌더링. `analytics__Dashboard` 타깃 + no-code 쿼리(step) 연결 + 타입 지정 Attributes UI.

> [!note] 공식 *Lightning Web Components in CRM Analytics and Lightning Dashboards* (Summer '26) 발췌.

---

## 개요 — 왜 쓰나

LWC를 대시보드 위젯으로 만들면 커스텀 데이터 시각화·선택 컨트롤·서식 문서 등을 만들 수 있다. 핵심 이점:

- **대시보드 캔버스의 일부** — 옆에 붙는 게 아니라 대시보드 **위에** 렌더링되어 네이티브 위젯처럼 보이고, 하나의 단위로 탐색·임베드·소비된다. (Lightning 대시보드에는 커스텀 LWC를 **1개만** 추가 가능)
- **no-code 데이터 쿼리 내장** — 각 LWC를 쿼리(=**step**)에 연결하면 데이터 테이블이 주입돼 쿼리 코드를 덜 쓴다. 구성자는 CRM Analytics Explorer UI로 datasets·Salesforce Objects·Snowflake 쿼리를 클릭으로 구성. (Lightning 대시보드의 커스텀 LWC에는 미적용)
- **Attributes UI** — 개발자가 속성·타입을 선언하면 구성 UI·검증이 자동 생성(상수·계산 데이터·컬럼 메타데이터·라벨·색상/크기 등 추상화)
- **Set/Get State 함수** — CRM Analytics Dashboard Component와 동일한 상태 연동

---

## 아키텍처

CRM Analytics 대시보드는 **관심사 분리**로 동작한다 — 위젯은 쿼리에서 데이터를 받고 선택(selection)을 되돌려 준다. 쿼리끼리는 **faceting**으로 선택을 주고받고 코어 런타임에서 global filter를 받는다. step은 **bindings**로 다른 컴포넌트에 선택·데이터를 전달한다.

→ 부모 대시보드와 통신: 연결된 쿼리에 **selection 설정** 또는 **`setState` 메서드** 사용.

> [!note] 이 아키텍처(쿼리/step/faceting/bindings)는 **CRM Analytics 대시보드 전용**이며, Lightning 대시보드에 추가한 커스텀 LWC에는 적용되지 않는다.

---

## Setup 요약

1. **CRM Analytics 활성 DE org** 생성/사용 (developer.salesforce.com/promotions/orgs/analytics-de)
2. AppExchange 게시 예정이면 org를 **Dev Hub**로 활성화
3. **Connected App** + client key/secret 생성 (**JWT flow 사용 금지**)

---

## Hello World — 컴포넌트 노출 (Tier 2 원문)

`analytics__Dashboard` 타깃으로 노출하면 컴포넌트가 디자이너의 컴포넌트 선택기에 나타난다. 가시성은 `<isExposed>true</isExposed>`.

```xml
<!-- helloWorld.js-meta.xml (Tier 2 원문) -->
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>53.0</apiVersion>
    <isExposed>true</isExposed>
    <masterLabel>Hello LWC</masterLabel>
    <description>Test project for LWC.</description>
    <targets>
        <target>analytics__Dashboard</target>
    </targets>
    <targetConfigs>
        <targetConfig targets="analytics__Dashboard">
            <hasStep>false</hasStep>
            <property name="title" type="String" label="Title"
                      description="Title of the component" required="true" />
        </targetConfig>
    </targetConfigs>
</LightningComponentBundle>
```

- **`<hasStep>`** — 쿼리 데이터를 안 쓰면 `false`. (Lightning 대시보드의 커스텀 LWC는 **항상 false** — 쿼리 불가)
- **`<property>`** — 대시보드 작성자가 구성하는 속성. `type="String"` + `required="true"`로 빈 컴포넌트 방지.

```javascript
// helloWorld.js — @api로 meta의 property를 받음
import { LightningElement, api } from 'lwc';
export default class HelloWorld extends LightningElement {
    @api title;
}
```

```html
<!-- helloWorld.html -->
<template>
    Hello World: {title}
</template>
```

> API 버전은 개발 대상 org 버전에 맞춰 달라질 수 있다.

---

## 쿼리 데이터 주입 + 동적 속성

- **쿼리(step) 연결**: `<hasStep>true</hasStep>`로 두면 쿼리 결과 테이블이 컴포넌트에 주입된다. CRM Analytics Explorer UI로 클릭 구성.
- **bindings**: 기존 쿼리·선택에서 동적 값을 만들어 LWC 속성을 구동. 예) 토글 위젯의 static query 결과를 selection binding으로 LWC의 `title` 속성에 주입(end-user가 값을 선택해 속성 변경).
- 디버그: 데이터가 맞는지 query panel에서 확인, Advanced Editor 또는 `Cmd/Ctrl+E`로 대시보드 JSON 확인.

---

## 관련 노트

- [[LWC API 버전 관리]] — `.js-meta.xml` apiVersion·targets·targetConfigs 구조
- [[@api 패턴]] — `@api` 속성으로 외부 구성 값 수신
- [[Wave Namespace]] — Apex에서 CRM Analytics(Wave) 데이터 접근
- [[LWC MOC]]
