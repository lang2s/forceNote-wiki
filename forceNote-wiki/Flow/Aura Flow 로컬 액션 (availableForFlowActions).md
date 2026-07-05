---
tags: [Flow, Aura, LocalAction, availableForFlowActions, Navigation, UtilityBar, ScreenFlow, invoke]
source: automation-components-main/src-ui/main/default/aura/navigate + automation-components-main/src-ui/main/default/aura/minimizeUtilityItem (실전 예시) + developer.salesforce.com lightning:availableForFlowActions·lightning:navigation·PageReference Types·lightning:utilityBarAPI (레퍼런스) + developer.salesforce.com LWC Guide - Create Flow Local Actions Using Lightning Web Components, Winter '26 (Tier 2, LWC 후속 경로)
created: 2026-07-04
aliases: [Flow Local Action, Aura Local Action, availableForFlowActions, Flow 로컬 액션, 플로우 클라이언트 액션, Flow 네비게이션, Flow 유틸리티바 최소화, invoke method flow, lightning navigation aura, Flow에서 페이지 이동]
---

# Aura Flow 로컬 액션 (availableForFlowActions)

> `lightning:availableForFlowActions`를 구현한 Aura 컴포넌트의 `invoke` 컨트롤러 메서드로 Flow(주로 Screen Flow)에서 **클라이언트 측 동작**(페이지 네비게이션·유틸리티바 제어 등)을 실행한다 — 서버 왕복 없이 브라우저에서 즉시 실행되는 "로컬 액션".

> [!note] 후속 권장 — LWC 로컬 액션 (Winter '26)
> **Winter '26**부터 Screen Flow에서 **LWC를 로컬 액션으로 직접 사용**할 수 있다(공식 LWC 개발자 가이드 *Create Flow Local Actions Using Lightning Web Components*). 이 노트가 다루는 Aura(`lightning:availableForFlowActions`) 방식은 **deprecated는 아니며 계속 동작**하지만, **신규 개발의 권장 후속 경로는 LWC 로컬 액션**이다. 근거: <https://developer.salesforce.com/docs/platform/lwc/guide/use-flow-local-actions.html>

---

## 1. 개념 — 로컬 액션이란

Flow의 **Action** 요소는 보통 Apex `@InvocableMethod`(서버 실행)를 호출한다. 하지만 페이지 이동·유틸리티바 열기/닫기 같은 동작은 **브라우저에서만** 가능하다. 이를 위해 Salesforce는 **로컬 액션(Local Action)** 을 제공한다:

- Aura 컴포넌트가 `lightning:availableForFlowActions` 인터페이스를 `implements` 하면, 그 컴포넌트의 클라이언트 컨트롤러 `invoke` 메서드가 **Flow의 Action 요소로 노출**된다.
- Flow 런타임(Lightning Experience)에서 실행되며, 서버 트랜잭션과 별개로 브라우저에서 즉시 동작한다.
- **Lightning Experience / Lightning 런타임 전용** — Classic이나 서버 전용 런타임에서는 지원되지 않는다.

> [!tip] Aura vs LWC 로컬 액션
> 여기서 소개하는 Aura 컴포넌트 방식(`lightning:availableForFlowActions` + `invoke`)은 **Winter '26** 이전부터 로컬 액션을 만드는 유일한 경로였고 지금도 유효하다. Winter '26부터는 동일한 로컬 액션을 **LWC**로도 구현할 수 있게 되어(공식 가이드 *Create Flow Local Actions Using Lightning Web Components*), LWC 기반 프론트엔드를 쓰는 신규 프로젝트에서는 LWC 로컬 액션이 권장된다. 기존 Aura 로컬 액션을 계속 유지·확장하는 것은 문제없다.

```
Flow (Screen/Autolaunched, Lightning 런타임)
   └─ Action 요소  ─────▶  Aura 컴포넌트 (implements lightning:availableForFlowActions)
                                 └─ invoke(component, event, helper)   ← 클라이언트 컨트롤러
                                        ├─ navService.navigate(pageReference)     (네비게이션)
                                        └─ utilityAPI.minimizeUtility()           (유틸리티바)
```

---

## 2. 인터페이스 계약 — `lightning:availableForFlowActions`

### 컴포넌트 선언

```xml
<aura:component implements="lightning:availableForFlowActions" access="global">
```

- `access="global"`은 패키지/조직 경계를 넘어 재사용하려면 권장.

### `invoke` 메서드 시그니처

컨트롤러(`*Controller.js`)에 반드시 `invoke` 액션을 정의한다:

```js
invoke: function (component, event, helper) { ... }
```

| 파라미터 | 설명 |
|---|---|
| `component` | 컴포넌트 인스턴스 — `component.get('v.<attr>')`로 Flow가 전달한 입력값을 읽는다 |
| `event` | 트리거 이벤트 |
| `helper` | 헬퍼 객체 |
| `cancelToken` (옵션) | Promise를 우아하게 중단하기 위한 토큰. `cancelToken.requested`(boolean), `cancelToken.promise`(타임아웃 시 Error로 resolve) |

### 동기 vs 비동기 반환

| 방식 | 동작 |
|---|---|
| **동기** | 메서드가 끝나면 제어권을 Flow에 반환 → 다음 요소로 진행 |
| **비동기** | **Promise 반환**. resolve → 다음 요소 진행 / reject → Fault 커넥터 발동 + `$Flow.FaultMessage` 채움 |
| 타임아웃 | Promise 타임아웃 시 제어권은 반환되지만 원래 요청은 취소되지 않는다 |

### 입출력 속성 (Flow ↔ 컴포넌트)

- `<aura:attribute>`로 정의한 속성이 Flow의 **입력/출력 변수**로 매핑된다.
- `access="global"`인 속성만 관리형 패키지 경계에서 노출된다.
- `*.design` 리소스의 `<design:attribute>`는 **Flow Builder에서 라벨·기본값**을 제어한다(빌더 UX). 로컬 액션 입력 매핑 자체는 `aura:attribute`가 결정한다.

---

## 3. 실전 예시 A — 네비게이션 로컬 액션 (navigate)

`automation-components`의 `navigate` 컴포넌트는 **8가지 목적지 유형**을 하나의 로컬 액션으로 처리한다. `lightning:navigation`(`navService`)의 `navigate(pageReference)`로 이동한다.

### 마크업 (`navigate.cmp`) — 실제 코드

```xml
<aura:component implements="lightning:availableForFlowActions" access="global">
    <aura:attribute name="destinationType" type="String" required="true" access="global"
        description="Redirect destination type. Supported values: object, record, app, url, tab, knowledge, namedpage, relatedlist" />
    <aura:attribute name="destinationRecordId" type="String" access="global"
        description="Target record Id used when destination is 'record' or 'relatedlist'." />
    <aura:attribute name="destinationName" type="String" access="global"
        description="object API name / app name / page name / tab name / article type ..." />
    <aura:attribute name="destinationAction" type="String" access="global"
        description="object: [home, list, new] / record: [clone, edit, view]" />
    <aura:attribute name="destinationActionFilter" type="String" access="global"
        description="Filter name used when destination is 'object' and action is 'list'." />
    <aura:attribute name="destinationUrl" type="String" access="global"
        description="Target URL used when destination is 'url' or 'knowledge'." />
    <aura:attribute name="relationshipName" type="String" access="global"
        description="Target relationship name used when destination is 'relatedList'." />

    <lightning:navigation aura:id="navService" />
</aura:component>
```

### 컨트롤러 (`navigateController.js`) — 실제 코드

`destinationType`으로 분기해 PageReference를 만들고 `navService.navigate()`를 호출한다.

```js
({
    invoke: function (component, event, helper) {
        var navService = component.find('navService');
        var destinationType = component.get('v.destinationType').toLowerCase();
        var pageReference;

        switch (destinationType) {
            case 'object':       pageReference = helper.getObjectPageReference(component); break;
            case 'record':       pageReference = helper.getRecordPageReference(component); break;
            case 'app':          pageReference = helper.getAppReference(component); break;
            case 'url':          pageReference = helper.getUrlReference(component); break;
            case 'namedpage':    pageReference = helper.getNamedPageReference(component); break;
            case 'tab':          pageReference = helper.getTabReference(component); break;
            case 'knowledge':    pageReference = helper.getKnowledgeArticleReference(component); break;
            case 'relatedlist':  pageReference = helper.getRelatedListReference(component); break;
            default:
                throw new Error('Invalid destination type value: "' + destinationType +
                    '". Supported values: object, record, app, url, tab, knowledge, namedpage, relatedlist');
        }
        navService.navigate(pageReference);
    }
});
```

### 헬퍼 (`navigateHelper.js`) — 실제 코드에서 발췌한 PageReference 빌드

각 목적지 유형이 정확히 어떤 `type`/`attributes`/`state`를 만드는지 보여준다:

```js
// object → standard__objectPage
{ type: 'standard__objectPage',
  attributes: { objectApiName: destinationName, actionName: destinationAction /* home|list|new */ },
  state: { filterName: destinationActionFilter } }

// record → standard__recordPage
{ type: 'standard__recordPage',
  attributes: { recordId: destinationRecordId, objectApiName: destinationName,
                actionName: destinationAction /* clone|edit|view */ } }

// app → standard__app
{ type: 'standard__app', attributes: { appTarget: destinationName } }

// url → standard__webPage
{ type: 'standard__webPage', attributes: { url: destinationUrl } }

// namedpage → standard__namedPage
{ type: 'standard__namedPage', attributes: { pageName: destinationName } }

// tab → standard__navItemPage
{ type: 'standard__navItemPage', attributes: { apiName: destinationName } }

// knowledge → standard__knowledgeArticlePage
{ type: 'standard__knowledgeArticlePage', attributes: { articleType: destinationName, urlName: destinationUrl } }

// relatedlist → standard__recordRelationshipPage
{ type: 'standard__recordRelationshipPage',
  attributes: { recordId: destinationRecordId, objectApiName: destinationName,
                actionName: 'view', relationshipApiName: relationshipName } }
```

> 실제 헬퍼는 `require(component, attr)`로 필수 입력 누락 시 `Missing mandatory value for attribute ...` 에러를 던지고, `object`/`record` 액션값을 화이트리스트로 검증한다.

### 디자인 리소스 (`navigate.design`) — 실제 코드

Flow Builder에서 보이는 라벨/기본값을 정의:

```xml
<design:component>
    <design:attribute name="destinationName" label="Destination Name" default="" />
    <design:attribute name="destinationRecordId" label="Destination Record Id" default="" />
    <design:attribute name="destinationType" label="Destination Type" required="true" />
    <design:attribute name="destinationAction" label="Destination Action" />
    <design:attribute name="destinationActionFilter" label="Destination Action Filter" />
    <design:attribute name="relationshipName" label="Relationship Name" />
    <design:attribute name="destinationUrl" label="Destination URL" default="www.salesforce.com" />
</design:component>
```

---

## 4. `lightning:navigation` 레퍼런스 (navService)

Aura에서 페이지 이동을 담당하는 서비스 컴포넌트(API 43.0+). LWC는 `lightning/navigation`의 `NavigationMixin`을 쓴다.

| 메서드 | 시그니처 | 동작 |
|---|---|---|
| `navigate` | `navigate(pageReference, replace)` | PageReference로 이동. `replace`(옵션 boolean)=true면 히스토리 항목 교체 |
| `generateUrl` | `generateUrl(pageReference)` | 이동 없이 URL 문자열만 생성(Promise). 링크 표시용 |

**지원 환경:** Lightning Experience, Experience Builder 사이트, Salesforce 모바일 앱, 모바일 오프라인.

### PageReference 객체 구조

```js
// 구조 예시 — 실제 동작 코드 아님
{
  type: 'standard__recordPage',   // 필수: PageDefinition API명
  attributes: { /* 유형별 값 */ }, // 필수
  state: { /* 쿼리 파라미터 (예: filterName) */ } // 선택
}
```

### PageReference 유형 전수 (공식 레퍼런스)

| type | 필수 attributes | actionName 허용값 | 비고 |
|---|---|---|---|
| `standard__app` | `appTarget` | — | `appId` 또는 `appDeveloperName` 형태 |
| `standard__component` | `componentName` | — | 대소문자 구분. state는 문자열 값·네임스페이스 포함 키 |
| `standard__objectPage` | `objectApiName`, `actionName` | `home`, `list`, `new` | 옵션: `filterName`, `defaultFieldValues`, `nooverride` |
| `standard__recordPage` | `recordId`, `actionName` | `clone`, `edit`, `view` | 옵션: `objectApiName`(LWR 필수), state `nooverride` |
| `standard__recordRelationshipPage` | `recordId`, `relationshipApiName`, `actionName` | `view`(only) | 관련 리스트만 지원. 옵션 `objectApiName` |
| `standard__navItemPage` | `apiName` | — | 커스텀 탭의 고유 이름 |
| `standard__namedPage` | `pageName` | — | 허용값: `home`, `chatter`, `today`, `dataAssessment`, `filePreview` |
| `standard__knowledgeArticlePage` | `articleType`, `urlName` | — | Experience Builder에서 `articleType` 무시 |
| `standard__webPage` | `url` | — | 외부 URL. LEX/Experience/모바일 지원 |
| `standard__managedContentPage` | `contentTypeName`, `contentKey` | — | Experience Builder 사이트 전용 |
| `comm__namedPage` | `name` | — | Experience Builder 사이트 전용 (Home·Login·Error 등) |

---

## 5. 실전 예시 B — 유틸리티바 최소화 로컬 액션 (minimizeUtilityItem)

Screen Flow가 유틸리티바 팝업에서 실행될 때, 완료 후 **유틸리티바를 자동으로 최소화**하는 로컬 액션.

### 마크업 (`minimizeUtilityItem.cmp`) — 실제 코드

```xml
<aura:component implements="lightning:availableForFlowActions" access="global">
    <lightning:utilityBarAPI aura:id="utilityBar" />
</aura:component>
```

### 컨트롤러 (`minimizeUtilityItemController.js`) — 실제 코드

`getUtilityInfo()`로 현재 열림 상태를 확인한 뒤, 열려 있을 때만 `minimizeUtility()`를 호출한다(비동기 Promise 체인).

```js
({
    invoke: function (component) {
        var utilityAPI = component.find('utilityBar');
        utilityAPI
            .getUtilityInfo()
            .then(function (response) {
                if (response.utilityVisible) {
                    utilityAPI.minimizeUtility();
                }
            })
            .catch(function (error) {
                // eslint-disable-next-line no-console
                console.error(error);
            });
    }
});
```

> `response.utilityVisible`가 팝업이 펼쳐진 상태인지 알려준다. 이미 최소화돼 있으면 아무 것도 하지 않는다.

---

## 6. `lightning:utilityBarAPI` 레퍼런스

유틸리티바를 프로그래밍적으로 제어하는 Aura 전용 API. **모든 메서드는 Promise를 반환**한다.

| 메서드 | 파라미터 | 반환(Promise) |
|---|---|---|
| `getEnclosingUtilityId()` | — | utilityId 또는 false |
| `getAllUtilityInfo()` | — | utilityInfo 객체 배열 |
| `getUtilityInfo()` | `{utilityId}`(옵션) | utilityInfo 객체 (예: `utilityVisible`) |
| `setUtilityLabel()` | `{label, utilityId}` | true |
| `setUtilityIcon()` | `{icon, utilityId}` | true |
| `setUtilityHighlighted()` | `{highlighted, utilityId}` | true |
| `setPanelHeaderLabel()` | `{label, utilityId}` | true |
| `setPanelHeaderIcon()` | `{icon, utilityId}` | true |
| `minimizeUtility()` | `{utilityId}`(옵션) | true |
| `openUtility()` | `{utilityId}`(옵션) | true |
| `toggleModalMode()` | `{enableModalMode, utilityId}` | true |
| `onUtilityClick()` | `{utilityId, eventHandler}` | true |
| `disableUtilityPopOut()` | `{disabled, disabledText}` | true |
| `isUtilityPoppedOut()` | — | true/false |

**제약:** Aura 컴포넌트 전용. 유틸리티바는 앱에 유틸리티가 설정돼 있어야 하며, 일부 기능은 **콘솔(내비게이션) 앱** 문맥에서 의미가 있다.

---

## 7. 로컬 액션 vs Apex 인보커블 액션 (선택 기준)

| 기준 | 로컬 액션 (`availableForFlowActions`) | Apex 인보커블 (`@InvocableMethod`) |
|---|---|---|
| 실행 위치 | **브라우저(클라이언트)** | **서버(트랜잭션)** |
| 대표 용도 | 페이지 네비게이션, 유틸리티바 제어, 토스트, 클라이언트 UI 조작 | DML, 콜아웃, 복잡한 계산, 대량 데이터 처리 |
| 런타임 제약 | **Lightning Experience 전용** (Screen Flow 등 화면 런타임) | 런타임 무관(자동실행 Flow 포함) |
| 비동기 처리 | Promise 반환(resolve/reject → Fault) | Apex 로직 내에서 처리 |
| 벌크 처리 | 화면 문맥 단건 위주 | List 입력으로 벌크 처리 필요 |

> **규칙:** "브라우저에서만 가능한 동작"(이동·유틸리티바·클라이언트 UI)은 로컬 액션, "서버 데이터/로직"은 Apex 인보커블. 자동실행(Autolaunched) Flow는 화면이 없어 로컬 액션을 쓸 수 없다 → 이동은 화면 있는 Screen Flow에서만.

---

## 8. 제약·주의사항

- **Lightning 런타임 전용** — Classic·서버 전용 실행에서는 로컬 액션이 실행되지 않는다.
- **화면 문맥 필요** — 네비게이션/유틸리티바 제어는 사용자 브라우저 세션에서만 의미가 있으므로 사실상 **Screen Flow**(또는 화면 있는 실행)에서 사용.
- **에러 처리** — 비동기 로직은 Promise reject로 Fault 커넥터를 발동하고 `$Flow.FaultMessage`를 채운다. 필수 입력 검증 실패는 명시적 `throw`로 빠르게 실패시키는 것이 좋다(실전 예시의 `require` 패턴).
- **입력 매핑** — Flow에서 넘기는 값은 `aura:attribute`로 받는다. 관리형 패키지 경계 노출은 `access="global"` 필요.
- **디자인 리소스** — `*.design`의 라벨/기본값은 빌더 UX일 뿐 런타임 매핑을 바꾸지 않는다.

---

## 관련 노트
- [[PageReference Types 레퍼런스]]
- [[NavigationMixin 패턴]]
- [[Flow 유틸리티 액션 모음]]
- [[@InvocableMethod 패턴]]
- [[Aura 컴포넌트 구조]]
- [[Flow Screen LWC 패턴]]
