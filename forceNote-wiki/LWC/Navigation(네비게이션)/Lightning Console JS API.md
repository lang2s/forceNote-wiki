---
tags: [lwc, aura, console, service-cloud, workspace-api, utility-bar]
source: api_console.pdf (Salesforce Console Developer Guide v67.0, Summer '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.api_console.meta/api_console/
created: 2026-06-14
aliases: [Lightning Console API, Console JS API, workspaceAPI, lightning/platformWorkspaceApi, utilityBarAPI, openTab, openSubtab, Console Integration Toolkit, 콘솔 API]
---

# Lightning Console JS API

> Salesforce **콘솔 앱**(멀티탭 워크스페이스)을 프로그래밍으로 제어하는 JS API — 워크스페이스 탭/서브탭 열기·포커스·닫기, 유틸리티 바, 내비게이션 항목. Aura 컴포넌트 + LWC 모듈로 제공. 구형 Classic Console Integration Toolkit(`sforce.console.*`)을 대체.

> [!note] *Salesforce Console Developer Guide v67.0* 전수(Lightning Console API 중심). 📖 공식: [Salesforce Console Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.api_console.meta/api_console/)

---

## 구현 방식 — Aura vs LWC

| 컴포넌트 (Aura) | LWC 모듈 | 역할 |
|---|---|---|
| `lightning:workspaceAPI` | `lightning/platformWorkspaceApi` | 워크스페이스 탭·서브탭 관리 |
| `lightning:utilityBarAPI` | `lightning/platformUtilityBarApi` | 유틸리티 바 항목 제어 |
| `lightning:navigationItemAPI` | (모듈) | 콘솔 내비게이션 항목 |

- **Aura**: 필수 파라미터를 **객체로** 전달 — `workspace.openTab({ url, focus, label })`
- **LWC**: 필수 파라미터를 **명시적으로** 전달 — `openTab({ url, label, focus })`, 메서드/wire 어댑터를 모듈에서 import
- `lightning/platformWorkspaceApi`는 메서드 + **wire 어댑터**(`EnclosingTabId`, `IsConsoleNavigation`) + **Lightning Message Channel**(`@salesforce/messageChannel/lightning__tabClosed` 등) 제공

```javascript
// LWC — openSubtab + EnclosingTabId wire 어댑터
import { LightningElement, wire } from 'lwc';
import { EnclosingTabId, openSubtab } from 'lightning/platformWorkspaceApi';
export default class MyComponent extends LightningElement {
    @wire(EnclosingTabId) tabId;
    handleClick() {
        openSubtab(this.tabId, { url: '/lightning/r/Account/001.../view', focus: true });
    }
}
```

```javascript
// 탭 열기 — LWC
openTab({ url: '#/sObject/001R0000003HgssIAC/view', label: 'Global Media', focus: true });
```

---

## Workspace API 메서드 (전수)

| 메서드 | 설명 |
|---|---|
| `openTab(options)` | 새 워크스페이스 탭 열기(url·focus·label·pageReference) |
| `openSubtab(parentTabId, options)` | 부모 탭 아래 서브탭 열기 |
| `getFocusedTabInfo()` | 현재 포커스된 탭 정보 |
| `getTabInfo(tabId)` | 특정 탭 정보 |
| `getAllTabInfo()` | 모든 탭 정보 |
| `getEnclosingTabId()` | (메서드) 컴포넌트가 속한 탭 ID — LWC는 `EnclosingTabId` wire 권장 |
| `focusTab(tabId)` | 탭 포커스 |
| `closeTab(tabId)` | 탭 닫기 |
| `refreshTab(tabId, options)` | 탭 새로고침 |
| `setTabLabel(tabId, label)` | 탭 라벨 설정 |
| `setTabIcon(tabId, icon, ...)` | 탭 아이콘 설정 |
| `disableTabClose(tabId, disabled)` | 탭 닫기 비활성화 |
| `isConsoleNavigation()` | (메서드) 콘솔 내비게이션 앱 여부 — LWC는 `IsConsoleNavigation` wire |
| `openTab`/`openSubtab` (PageReference) | PageReference로 탭/서브탭 열기 |

---

## Utility Bar API 메서드

| 메서드 | 설명 |
|---|---|
| `openUtility()` | 유틸리티 패널 열기 |
| `minimizeUtility()` | 유틸리티 최소화 |
| `toggleModalMode(options)` | 모달 모드 토글 |
| `getEnclosingUtilityId()` | 컴포넌트가 속한 유틸리티 ID |
| `getAllUtilityInfo()` / `getUtilityInfo()` | 유틸리티 정보 |
| `setUtilityLabel` / `setUtilityIcon` / `setUtilityHighlighted` | 라벨·아이콘·강조 설정 |
| `setPanelHeaderLabel` / `setPanelHeaderIcon` | 패널 헤더 |

- **Background Utility Items** — UI 없이 백그라운드 로직 실행하는 유틸리티
- **Pop-Out Utilities** — 유틸리티를 별도 창으로 분리
- **Page Context** — 유틸리티 바 API에서 현재 페이지 컨텍스트 사용

---

## Navigation Item API

- `getNavigationItems()` — 콘솔 앱의 내비게이션 항목 목록 조회

---

## 이벤트 (Lightning Message Channel)

탭 생명주기를 LMS 채널로 구독: `lightning__tabClosed`, `lightning__tabFocused`, `lightning__tabRefreshed`, `lightning__tabCreated` 등 (`@salesforce/messageChannel/lightning__*`).

---

## Classic API (레거시)

Salesforce Classic의 **Console Integration Toolkit** — Visualforce/iframe 페이지의 `<script>`에서 `sforce.console.*` 메서드 호출(예: `sforce.console.openSubtab`). v42.0+부터 다수 Classic 메서드가 Lightning Console API에서도 지원(Method Parity 표). **신규 개발은 Lightning Console API 사용.**

---

## 관련 노트

- 📖 공식: [Salesforce Console Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.api_console.meta/api_console/)
- [[NavigationMixin 패턴]] — 일반 LWC 페이지 내비게이션(콘솔 외)
- [[Lightning Message Service]] — 탭 이벤트 채널 구독
- [[LWC MOC]]
