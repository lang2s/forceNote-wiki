---
tags: [Aura, Deprecated, ui네임스페이스, lightning네임스페이스, 마이그레이션, LWC, LegacyComponents]
source: Salesforce Spring '20 Release Notes — "Aura Components in the ui Namespace Are Deprecated" (releasenotes.docs.salesforce.com/en-us/spring20/release-notes/rn_aura_ui_deprecate.htm, Wayback 아카이브로 원문 대조) · 동일 문서 Winter '21~Summer '21 개정판 (지원 종료일·Winter '20 최초 발표 확인) · Salesforce Component Reference (lightning 네임스페이스 Aura/LWC 이중 제공) [Tier 2]
created: 2026-07-05
aliases: [ui namespace deprecated, ui 네임스페이스 deprecated, ui:inputText 대체, ui:button 대체, ui 컴포넌트 대체, Aura ui deprecated, ui to lightning migration, ui 컴포넌트 lightning 매핑]
---

# ui 네임스페이스 Deprecated — lightning 대체 매핑

> Aura의 `ui:*` 네임스페이스 컴포넌트 39종 전체가 deprecated다(Winter '20 최초 발표, **2021-05-01 지원 종료**). 각 컴포넌트를 무엇으로 바꿔야 하는지 — `lightning:*`(Aura) 및 등가 `lightning-*`(LWC) — 공식 릴리즈 노트의 전수 매핑.

---

## 배경 — 무엇이, 언제, 왜 deprecated 됐나

| 항목 | 내용 (릴리즈 노트 원문 기준) |
|---|---|
| 대상 | **`ui` 네임스페이스의 Aura 컴포넌트 전체** (아래 39종) |
| 최초 발표 | **Winter '20** — *"We first announced this deprecation plan in Winter '20."* (Spring '20 릴리즈 노트에서 재공지) |
| 지원 종료 | **2021년 5월 1일** — *"You can continue to use these components beyond May 1, 2021, but we won't accept support cases for them after that date."* |
| 적용 범위 | Lightning Experience · Salesforce Classic · Salesforce 모바일 앱 전 버전의 Lightning 컴포넌트 |
| 이유 | 레거시 컴포넌트를 정리하고 성능·접근성·UX·국제화에서 최신 웹 표준에 맞는 컴포넌트에 집중하기 위해 |
| 현재 상태 | **삭제된 것은 아니다** — 기존 코드는 계속 동작하지만 지원 케이스가 접수되지 않으며, 공식 Component Reference는 *Legacy Components / (Deprecated)* 로 분류. 신규 작성 금지 |

**대체 원칙 (공식 How):**
1. deprecated 컴포넌트를 **`lightning` 네임스페이스의 대응 컴포넌트로 교체**한다 — 더 빠르고 효율적이며 SLDS 스타일이 기본 적용된다.
2. `lightning` 네임스페이스 컴포넌트는 **Aura 버전과 LWC 버전 두 가지로 제공**된다 — Salesforce는 **가능하면 LWC 사용을 권장**한다 (Summer '21 개정판: *"Migrate to Lightning Web Components (LWC) whenever possible."*). LWC와 Aura는 한 페이지에서 공존·상호운용 가능.

---

## 전수 매핑 표 (39종)

> 아래 "대체 (Aura)" 열은 Spring '20 릴리즈 노트의 공식 권장 그대로다. "등가 LWC" 열은 같은 lightning 컴포넌트의 LWC 버전(Component Reference의 camelCase→kebab-case 표준 명명)을 병기한 것.

### 입력 계열 — `ui:input*` (16종)

| Deprecated | 대체 (Aura) | 등가 LWC | 비고 |
|---|---|---|---|
| `ui:inputText` | `lightning:input` (`type="text"`) | `lightning-input` | 질문의 대표 케이스 |
| `ui:inputNumber` | `lightning:input` (`type="number"`) | `lightning-input` | |
| `ui:inputCurrency` | `lightning:input` (`type="number"` + `formatter="currency"`) | `lightning-input` | |
| `ui:inputDate` | `lightning:input` (`type="date"`) | `lightning-input` | |
| `ui:inputDateTime` | `lightning:input` (`type="datetime"`) | `lightning-input` | |
| `ui:inputEmail` | `lightning:input` (`type="email"`) | `lightning-input` | |
| `ui:inputPhone` | `lightning:input` (`type="phone"`) | `lightning-input` | |
| `ui:inputURL` | `lightning:input` (`type="url"`) | `lightning-input` | |
| `ui:inputSecret` | `lightning:input` (`type="password"`) | `lightning-input` | |
| `ui:inputCheckbox` | `lightning:input` (`type="checkbox"` / `"toggle"` / `"checkbox-button"`) | `lightning-input` | 체크박스 **그룹**은 `lightning:checkboxGroup` / `lightning-checkbox-group` |
| `ui:inputRadio` | `lightning:input` (`type="radio"`) | `lightning-input` | 라디오 **그룹**은 `lightning:radioGroup` / `lightning-radio-group` |
| `ui:inputRichText` | `lightning:inputRichText` | `lightning-input-rich-text` | |
| `ui:inputSelect` | `lightning:select` 또는 `lightning:combobox` | `lightning-select` / `lightning-combobox` | |
| `ui:inputSelectOption` | `lightning:select` 또는 `lightning:combobox` | `lightning-select` / `lightning-combobox` | 옵션은 대체 컴포넌트의 `options` 속성으로 |
| `ui:inputTextArea` | `lightning:textarea` | `lightning-textarea` | |
| `ui:inputDefaultError` | `lightning:input`의 **내장 필드 검증** 사용 | `lightning-input` | 별도 에러 컴포넌트 불필요 — validity·messageWhen* 속성 |

### 출력 계열 — `ui:output*` (11종)

| Deprecated | 대체 (Aura) | 등가 LWC | 비고 |
|---|---|---|---|
| `ui:outputText` | `lightning:formattedText` | `lightning-formatted-text` | |
| `ui:outputTextArea` | `lightning:formattedText` | `lightning-formatted-text` | |
| `ui:outputNumber` | `lightning:formattedNumber` | `lightning-formatted-number` | |
| `ui:outputCurrency` | `lightning:formattedNumber` (`style="currency"`) | `lightning-formatted-number` | |
| `ui:outputDate` | `lightning:formattedDateTime` | `lightning-formatted-date-time` | |
| `ui:outputDateTime` | `lightning:formattedDateTime` 또는 `lightning:formattedTime` | `lightning-formatted-date-time` / `lightning-formatted-time` | |
| `ui:outputEmail` | `lightning:formattedEmail` | `lightning-formatted-email` | |
| `ui:outputPhone` | `lightning:formattedPhone` | `lightning-formatted-phone` | |
| `ui:outputURL` | `lightning:formattedUrl` | `lightning-formatted-url` | |
| `ui:outputRichText` | `lightning:formattedRichText` | `lightning-formatted-rich-text` | |
| `ui:outputCheckbox` | `lightning:input` (`type="checkbox"` + `readonly="true"`) | `lightning-input` | 읽기 전용 체크박스로 표현 |

### 메뉴 계열 — `ui:menu*` (9종)

| Deprecated | 대체 (Aura) | 등가 LWC | 비고 |
|---|---|---|---|
| `ui:menu` | `lightning:buttonMenu` | `lightning-button-menu` | 메뉴 컨테이너+트리거가 하나로 통합 |
| `ui:menuList` | `lightning:buttonMenu` | `lightning-button-menu` | |
| `ui:menuTrigger` | `lightning:buttonMenu` | `lightning-button-menu` | |
| `ui:menuTriggerLink` | `lightning:buttonMenu` | `lightning-button-menu` | |
| `ui:menuItem` | `lightning:menuItem` (+ `lightning:buttonMenu`) | `lightning-menu-item` | |
| `ui:actionMenuItem` | `lightning:menuItem` (+ `lightning:buttonMenu`) | `lightning-menu-item` | |
| `ui:checkboxMenuItem` | `lightning:menuItem` (+ `lightning:buttonMenu`) | `lightning-menu-item` | `checked` 속성 활용 |
| `ui:radioMenuItem` | `lightning:menuItem` (+ `lightning:buttonMenu`) | `lightning-menu-item` | |
| `ui:menuItemSeparator` | `lightning:menuDivider` (+ `lightning:buttonMenu`) | `lightning-menu-divider` | |

### 기타 (3종)

| Deprecated | 대체 (Aura) | 등가 LWC | 비고 |
|---|---|---|---|
| `ui:button` | `lightning:button` · `lightning:buttonIcon` · `lightning:buttonIconStateful` | `lightning-button` / `lightning-button-icon` / `lightning-button-icon-stateful` | 버튼 **그룹**은 `lightning:buttonGroup` / `lightning-button-group` |
| `ui:message` | `lightning:notificationsLibrary` | (등가 단일 컴포넌트 없음) | LWC에선 toast = `ShowToastEvent`(`lightning/platformShowToastEvent`), 모달 알림 = `lightning/alert`·`lightning/confirm`·`lightning/prompt` 모듈 |
| `ui:spinner` | `lightning:spinner` | `lightning-spinner` | |

---

## 마이그레이션 예시 — ui:inputText / ui:button / ui:outputText

```xml
<!-- 구조 예시 — 실제 동작 코드 아님 (매핑 표를 마크업으로 표현한 예) -->

<!-- ❌ Before: deprecated ui 네임스페이스 -->
<aura:component>
    <ui:inputText  aura:id="name" label="Name" value="{!v.myName}"/>
    <ui:outputText value="{!v.myName}"/>
    <ui:button label="Save" press="{!c.handleSave}"/>
</aura:component>

<!-- ✅ After (Aura): lightning 네임스페이스 -->
<aura:component>
    <lightning:input  aura:id="name" type="text" label="Name" value="{!v.myName}"/>
    <lightning:formattedText value="{!v.myName}"/>
    <lightning:button label="Save" onclick="{!c.handleSave}"/>
</aura:component>
```

```html
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<!-- ✅ After (권장, LWC): 등가 lightning-* 컴포넌트 -->
<template>
    <lightning-input type="text" label="Name" value={myName} onchange={handleChange}></lightning-input>
    <lightning-formatted-text value={myName}></lightning-formatted-text>
    <lightning-button label="Save" onclick={handleSave}></lightning-button>
</template>
```

**전환 시 자주 걸리는 차이점:**
- `ui:button`의 클릭 이벤트는 `press`, `lightning:button`은 **`onclick`** — 이벤트 속성명이 다르다.
- `ui:inputText` 등은 컴포넌트별로 타입이 나뉘어 있었지만 `lightning:input`은 **`type` 속성 하나로 통합** — 유효성 검증(`ui:inputDefaultError`가 하던 일)도 내장돼 별도 컴포넌트가 필요 없다.
- `ui:menu`는 트리거/리스트/아이템을 4개 컴포넌트로 조립했지만 `lightning:buttonMenu`는 트리거+드롭다운을 하나로 제공하고 안에 `lightning:menuItem`만 넣는다.
- 대체 컴포넌트는 SLDS 스타일이 기본 적용되므로, ui 컴포넌트에 입히던 커스텀 CSS 상당수는 제거 대상.

---

## 관련 노트

- [[Aura → LWC 마이그레이션]] — ui→lightning 교체를 넘어 컴포넌트 전체를 LWC로 옮기는 절차
- [[Aura vs LWC]] — 어느 모델로 작성할지 선택 기준
- [[Aura 컴포넌트 구조]] — Aura 번들·마크업 기초
- [[Experience Builder Aura 사이트 개발]] — `ui:menu` 계열이 등장하는 실제 PDF 샘플과 경고 블록
- [[lightning-input]] — `ui:input*` 대부분의 LWC 종착지 (type별 상세)
- [[lightning-button-menu]] — 메뉴 계열 대체 (menu-item·menu-divider 포함)
- [[lightning-formatted-text]] — `ui:outputText/TextArea` 대체
