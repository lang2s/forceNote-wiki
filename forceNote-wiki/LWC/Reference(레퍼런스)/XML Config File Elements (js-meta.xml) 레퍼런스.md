---
tags: [lwc, reference, js-meta-xml, configuration, targets, capabilities, isExposed, apiVersion]
source: developer.salesforce.com (Lightning Web Components Developer Guide — Reference > XML Configuration File Elements; 라이브 공식 문서, Tier 2, 접속 2026-07-04)
official_doc: https://developer.salesforce.com/docs/platform/lwc/guide/reference-configuration-tags.html
created: 2026-07-04
aliases: [js-meta.xml, XML configuration file, LWC config file, targets, target, capability, isExposed, apiVersion, masterLabel, targetConfig, lightning__RecordPage, lightning__AppPage, lightning__FlowScreen, lightning__UrlAddressable, lightning__Tab, lightning__UtilityBar, lightning__HomePage, AgentforceInput, AgentforceOutput]
---

# LWC XML Configuration File Elements (.js-meta.xml) 레퍼런스

> 모든 LWC 폴더에 필수인 `componentName.js-meta.xml` 설정 파일의 최상위 태그·`<capability>` 5값·`<target>` 전수(29값)·`<targetConfig>` 레퍼런스.

---

## 개요

각 Lightning Web Component 폴더는 메타데이터 설정 파일 `componentName.js-meta.xml`을 반드시 포함해야 한다. 이 파일이 컴포넌트의 API 버전, builder 노출 여부, 배치 가능한 위치(target), 컴포넌트가 할 수 있는 것(capability), builder에 표시할 설정(targetConfig)을 정의한다.

- 파일명은 컴포넌트 폴더/JS 파일명과 동일해야 한다 (`myComponent/myComponent.js-meta.xml`).
- 샘플: `lwc-recipes`의 `eventSimple.js-meta.xml`.

---

## 최상위 태그

### `<apiVersion>`
- Salesforce API 버전. **45.0 이상**이어야 한다.
- apiVersion 값과 무관하게, 컴포넌트는 **항상 최신 LWC 런타임**을 사용한다.
- Winter '24부터 LWC 버저닝을 지원한다.
- **Spring '25부터 모든 컴포넌트는 `<apiVersion>`을 반드시(must) 지정**해야 한다.

### `<isExposed>`
- `false`(기본)면 App Builder·Experience Builder 등 builder에 **노출되지 않는다**.
- builder에서 사용하려면 `true`로 설정하고 `<target>`을 **최소 1개** 정의해야 한다.
- ⚠️ 커스텀 LWC는 `lightning` 네임스페이스 외의 커스텀 네임스페이스에 속한 LWC/모듈에 접근할 수 없다.

### `<masterLabel>`
- 컴포넌트 제목. Setup의 Lightning Components 목록(list view)과 builder에 표시된다.

### `<description>`
- 컴포넌트의 짧은 user-facing 설명(보통 한 문장). builder에 표시된다.

### `<runtimeNamespace>`
- Vlocity LWC managed package의 네임스페이스를 지정한다.

### AI Description 태그 세트 (Agentforce 전용)
- 컴포넌트와 프로퍼티의 **AI 설명**을 정의한다. record 관련 컴포넌트만 지원한다.
- `js-meta.xml` 최상위에 **1회만** 추가한다. 컴포넌트 AI 설명(비 user-facing, Agentforce가 사용)과 `<property>` 태그들을 포함한다.
- 각 `<property>`는 단일 컴포넌트 프로퍼티의 AI 설명이다. `targetConfig`의 `property`를 **대체하지 않고** AI 설명으로 보강한다.

`<property>` 속성:

| 속성 | 타입 | 설명 | Required |
|---|---|---|---|
| `aiDescription` | String | 프로퍼티의 AI 설명(비 user-facing, Agentforce가 사용) | Yes |
| `name` | String | 속성 이름. 컴포넌트 JS 클래스 프로퍼티명 및 `targetConfig` 프로퍼티명과 일치해야 한다 | Yes |

---

## `<capability>` (컨테이너 `<capabilities>`의 서브태그)

capability는 컴포넌트가 **할 수 있는 것**을 정의한다 (target = 컴포넌트를 배치할 수 있는 위치와 대조).

| 값 | 설명 |
|---|---|
| `lightningCommunity__RelaxedCSP` | managed package 컴포넌트를 LWS 및 relaxed CSP인 Experience Builder 사이트에서 실행 |
| `lightning__dynamicComponent` | 다른 컴포넌트를 동적으로 인스턴스화 |
| `lightning__ServerRenderable` | 페이지 SSR(islands architecture). Experience Builder LWR 사이트 |
| `lightning__ServerRenderableWithHydration` | 커스텀 컴포넌트 SSR + hydration. Experience Builder LWR 사이트 |
| `lightning__ServiceCloudVoiceToolkitApi` | Service Cloud Voice Toolkit API 사용 |

---

## `<target>` (컨테이너 `<targets>`의 서브태그)

컴포넌트를 추가할 수 있는 위치를 지정한다. builder에 노출하려면 `<isExposed>true</isExposed>`와 함께 `<target>`을 최소 1개 정의한다.

### `<target>` 유효값 (전수 — 29값)

| 값 | 설명 |
|---|---|
| `analytics__Dashboard` | CRM Analytics 대시보드 위젯 |
| `lightningCommunity__Default` | Experience Builder에서 편집 가능한 프로퍼티 노출 |
| `lightningCommunity__Page` | Experience Builder 드래그앤드롭 컴포넌트 |
| `lightningCommunity__Page_Layout` | LWR 사이트 page layout |
| `lightningCommunity__Theme_Layout` | LWR 사이트 theme layout |
| `lightningSnapin__ChatHeader` | Embedded Service Chat 커스텀 chat header (`lightningsnapin/baseChatHeader`) |
| `lightningSnapin__ChatMessage` | Embedded Service Chat 커스텀 chat message (`lightningsnapin/baseChatMessage`) |
| `lightningSnapin__MessagingPreChat` | Embedded Service Deployments 커스텀 pre-chat |
| `lightningSnapin__MessagingHeader` | Embedded Service Deployments 커스텀 컴포넌트 |
| `lightningSnapin__Minimized` | Embedded Service Chat 커스텀 minimized (`lightningsnapin/minimized`) |
| `lightningSnapin__PreChat` | Embedded Service Chat 커스텀 prechat (`lightningsnapin/basePrechat`) |
| `lightningStatic__Email` | Email Content Builder |
| `lightning__AgentforceInput` | agent action에서 사용자 입력 수용 |
| `lightning__AgentforceOutput` | agent action에서 출력 데이터 표시 |
| `lightning__AppPage` | Lightning App Builder App page |
| `lightning__ECSFSApp` | Field Service Mobile App Builder |
| `lightning__EnablementProgram` | Program Builder custom exercise type |
| `lightning__FlowScreen` | Flow Builder flow screen |
| `lightning__GlobalAction` | global quick action (actionType는 `targetConfig`의 `lightning__GlobalAction`에서 지정) |
| `lightning__HomePage` | Lightning App Builder Home page |
| `lightning__Inbox` | Outlook/Gmail 이메일 앱 pane |
| `lightning__PropertyEditor` | Experience Builder 커스텀 property editor (LightningTypeBundle js-meta.xml에서 참조) |
| `lightning__RecordAction` | record page quick action (actionType는 `targetConfig`의 `lightning__RecordAction`에서 지정) |
| `lightning__RecordPage` | Lightning App Builder record page |
| `lightning__ServiceDocument` | Document Builder |
| `lightning__Tab` | Lightning Experience·Salesforce 모바일 앱 커스텀 탭 |
| `lightning__UrlAddressable` | 특정 URL(`/lightning/cmp/c__...`)로 컴포넌트에 직접 네비게이션 |
| `lightning__UtilityBar` | App Manager utility bar utility item |
| `lightning__VoiceExtension` | Lightning App Builder Voice Extension page |

---

## `<targetConfig>`

지정한 target의 설정 메타데이터를 정의한다. `property`, `objects` 등의 서브태그를 지원한다. `targets` 속성으로 어느 target에 적용할지 지정한다.

- target별 세부 설정(supportedFormFactors, objects, property 상세 등)은 각 target 문서 페이지로 위임된다.

---

## 최소 예시 구조

```xml
<!-- 구조 예시 — myComponent.js-meta.xml (실제 동작 설정 아님) -->
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>62.0</apiVersion>
    <isExposed>true</isExposed>
    <masterLabel>My Component</masterLabel>
    <description>Short user-facing description.</description>
    <targets>
        <target>lightning__RecordPage</target>
        <target>lightning__AppPage</target>
        <target>lightning__UrlAddressable</target>
    </targets>
    <targetConfig targets="lightning__RecordPage">
        <property name="title" type="String" label="Title"/>
    </targetConfig>
</LightningComponentBundle>
```

---

## 관련 노트
- [[HTML 템플릿 Directives 레퍼런스]] — 형제 Reference (LWC 템플릿 디렉티브)
- [[@salesforce Modules 레퍼런스]] — 형제 Reference (`@salesforce/*` 임포트)
- [[PageReference Types 레퍼런스]] — `lightning__UrlAddressable` target 컴포넌트를 가리키는 `standard__component` 타입(짝)
- [[NavigationMixin 패턴]] — `lightning__UrlAddressable` target으로 노출한 컴포넌트로의 네비게이션
- [[New Button or Link & Action 생성 가이드 (타입·설정·예시)]] — URL 버튼으로 `lightning__UrlAddressable` 컴포넌트 이동
- [[LWC MOC]] — LWC 섹션 목차
