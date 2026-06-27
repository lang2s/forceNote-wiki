---
tags: [slds, starter-kit, lwc, shell, components, navigation, panel, datatable, lightning-base-components]
source: salesforce-ux/design-system-2-starter-kit (GitHub, 공식 Salesforce UX)
created: 2026-06-26
aliases: [SLDS Starter Kit 셸 컴포넌트, globalHeader, globalNavigation, App Launcher waffle, Console object switcher, docked panel, ui-panel, pageHeader, lightning-datatable, contacts 페이지, builder 페이지]
---

# SLDS 2 Starter Kit - 셸 UI 컴포넌트

> SLDS 2 Starter Kit의 앱 크롬(chrome) 구현: 글로벌 헤더, 내비게이션(waffle App Launcher + Console 오브젝트 스위처 + Standard 탭), 도킹 패널, 재사용 페이지 빌딩블록(pageHeader/builderHeader/homeIntro), 그리고 예제 페이지(Home/Contacts/Contact Detail/Builder)와 contacts 데이터 픽스처.

확인 커밋: `38395a2` ("Harden agent guidance on Lightning Base Components (#23)"). 스택: LWC OSS + Vite + Lightning Base Components + SLDS 2. 모든 코드 블록은 소스 파일 직접 발췌(verbatim)다.

---

## 컴포넌트 계층 개요

이 노트는 셸(shell)·UI(ui)·페이지(page)·데이터(data) 4개 모듈 네임스페이스의 컴포넌트를 다룬다. 라우터/`shell-app`/`routes.config`/`apps.config` 본문은 [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]]에 있으므로 여기서는 셸이 렌더하는 **크롬과 페이지 컴포넌트**에 집중한다.

```
// 구조 예시 — 실제 원본 다이어그램 아님 (소스 관계를 도식화)
shell-app (라우트 outlet + 셸 호스트)            ← [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]]
├─ shell-global-shell  (이벤트 릴레이 중간 계층)
│   ├─ ui-global-header       (상단 바: 로고/검색/액션/패널 트리거)
│   └─ ui-global-navigation   (waffle App Launcher · Console 스위처 · Standard 탭)
├─ <lwc:component componentCtor>  (라우트 outlet → page-* 렌더)
│   ├─ page-home          → ui-home-intro + 폼/버튼/토스트 데모
│   ├─ page-contacts      → ui-page-header(object-home) + lightning-datatable
│   ├─ page-contact-detail→ ui-page-header(record-home) + Details/Activity 카드
│   └─ page-builder       → ui-builder-header + 좌/우 ui-panel 레일
├─ shell-theme-switcher   ← [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]]
└─ shell-panel            → ui-panel (도킹 우측 패널)
```

### 이벤트 릴레이 체인

크롬의 자식 컴포넌트들은 `bubbles: true, composed: true` CustomEvent를 올리고, `shell-global-shell`이 이를 가로채(`stopPropagation`) 한 번만 다시 dispatch한 뒤, `shell-app`의 app.js 핸들러가 최종 처리한다.

| 시작 컴포넌트 | 이벤트 | 중간 릴레이 (globalShell) | 최종 핸들러 (app.js) |
|---|---|---|---|
| `ui-global-navigation` | `navigate` `{page}` | `handleNavigate` (stop+re-dispatch) | `handleNavNavigate` → `navigate(NAV_PAGE_TO_PATH[page])` |
| `ui-global-navigation` | `appswitch` `{app}` | `handleAppSwitch` (stop+re-dispatch) | `handleAppSwitch` → 앱 전환 + `navigate(defaultPath)` |
| `ui-global-header` | `panelselect` `{name}` | `handlePanelSelect` (re-dispatch, **stop 없음**) | `handlePanelSelect` → `selectedPanel`/`isPanelOpen` |
| `shell-panel` | `panelclose` | (직접 app.html에 바인딩) | `handlePanelClose` → `isPanelOpen=false` |
| `page-builder` | `builderexit` | (app.html `onbuilderexit`) | `handleBuilderExit` → standard 앱 복귀 |

> app.js의 `handleNavNavigate`/`handleAppSwitch`/`handlePanelSelect`/`handleBuilderExit`/outlet 동작 전문은 [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]] 참조. 이 노트는 이벤트를 **올리는 쪽**(크롬·페이지)을 문서화한다.

주의: `navigate`/`appswitch` 릴레이는 `stopPropagation()`을 호출하지만 `panelselect` 릴레이는 호출하지 않는다(globalShell.js verbatim). header는 navigation과 달리 중첩 트리거가 없어 중복 버블 우려가 없기 때문이다.

---

## shell-global-shell — 셸 중간 계층 (릴레이)

`shell-app`과 `ui-global-header`/`ui-global-navigation` 사이의 패스스루 + 이벤트 릴레이 계층. 헤더(행1) + 내비(행2)를 `lightning-layout multiple-rows`로 쌓는다.

**@api 프로퍼티 (전수 — 5종 모두 navigation으로 패스스루):**

| 프로퍼티 | 기본값 | 전달 대상 |
|---|---|---|
| `currentPage` | `'home'` | `ui-global-navigation current-page` |
| `navItems` | `[]` | `ui-global-navigation nav-items` |
| `currentAppVariant` | `'standard'` | `ui-global-navigation variant` |
| `appItems` | `[]` | `ui-global-navigation app-items` |
| `pagesInCurrentApp` | `[]` | `ui-global-navigation pages-in-current-app` |

(헤더에는 패스스루 prop이 없고 `onpanelselect`만 바인딩.)

**릴레이 핸들러 (전수):**

| 핸들러 | 수신 이벤트 | `stopPropagation` | 재-dispatch 이벤트 | detail | bubbles/composed |
|---|---|---|---|---|---|
| `handleNavigate(event)` | navigation의 `navigate` | ✅ | `navigate` | `event.detail` 그대로 | true/true |
| `handleAppSwitch(event)` | navigation의 `appswitch` | ✅ | `appswitch` | `event.detail` 그대로 | true/true |
| `handlePanelSelect(event)` | header의 `panelselect` | ❌ | `panelselect` | `event.detail` 그대로 | true/true |

```javascript
// src/modules/shell/globalShell/globalShell.js
import { LightningElement, api } from 'lwc';

export default class GlobalShell extends LightningElement {
    @api currentPage = 'home';
    @api navItems = [];
    @api currentAppVariant = 'standard';
    @api appItems = [];
    @api pagesInCurrentApp = [];

    handleNavigate(event) {
        // Prevent the original child event from continuing to bubble, then relay once.
        event.stopPropagation();
        this.dispatchEvent(
            new CustomEvent('navigate', {
                detail: event.detail,
                bubbles: true,
                composed: true
            })
        );
    }

    handleAppSwitch(event) {
        event.stopPropagation();
        this.dispatchEvent(
            new CustomEvent('appswitch', {
                detail: event.detail,
                bubbles: true,
                composed: true
            })
        );
    }

    handlePanelSelect(event) {
        this.dispatchEvent(
            new CustomEvent('panelselect', {
                detail: event.detail,
                bubbles: true,
                composed: true
            })
        );
    }
}
```

```html
<!-- src/modules/shell/globalShell/globalShell.html -->
<template>
    <lightning-layout class="global-shell" multiple-rows>
        <lightning-layout-item size="12" padding="none">
            <ui-global-header onpanelselect={handlePanelSelect}></ui-global-header>
        </lightning-layout-item>
        <lightning-layout-item size="12" padding="none">
            <ui-global-navigation
                variant={currentAppVariant}
                current-page={currentPage}
                nav-items={navItems}
                app-items={appItems}
                pages-in-current-app={pagesInCurrentApp}
                onnavigate={handleNavigate}
                onappswitch={handleAppSwitch}>
            </ui-global-navigation>
        </lightning-layout-item>
    </lightning-layout>
</template>
```

라이프사이클 훅: 없음.

---

## ui-global-header — 상단 글로벌 헤더

SLDS `slds-global-header` 구현. **라우팅 로직은 없고** 검색·전역 액션·패널 트리거만 담당. 모든 핸들러는 `panelselect` 이벤트를 dispatch해 도킹 패널을 연다.

**@api 프로퍼티:** 없음. **getters:** 없음. **라이프사이클 훅:** 없음.

**panelselect 핸들러 (전수 — 4종, 모두 `bubbles+composed`):**

| 핸들러 | 트리거 버튼 (아이콘) | `detail.name` |
|---|---|---|
| `handleAgentforceClick()` | Agentforce (`utility:agent_astro`) | `agentforce_panel` |
| `handleTrailheadClick()` | Guidance Center (`utility:trailhead_alt`) | `trailhead_panel` |
| `handleSettingsClick()` | Setup (`utility:settings`) | `settings_panel` |
| `handleNotificationClick()` | Notifications (`utility:notification`) | `notification_panel` |

```javascript
// src/modules/ui/globalHeader/globalHeader.js
import { LightningElement } from 'lwc';

export default class GlobalHeader extends LightningElement {
    handleAgentforceClick() {
        this.dispatchEvent(new CustomEvent('panelselect', {
            detail: { name: 'agentforce_panel' },
            bubbles: true,
            composed: true
        }));
    }

    handleTrailheadClick() {
        this.dispatchEvent(new CustomEvent('panelselect', {
            detail: { name: 'trailhead_panel' },
            bubbles: true,
            composed: true
        }));
    }

    handleSettingsClick() {
        this.dispatchEvent(new CustomEvent('panelselect', {
            detail: { name: 'settings_panel' },
            bubbles: true,
            composed: true
        }));
    }

    handleNotificationClick() {
        this.dispatchEvent(new CustomEvent('panelselect', {
            detail: { name: 'notification_panel' },
            bubbles: true,
            composed: true
        }));
    }
}
```

**헤더 레이아웃 (좌→우, `lightning-layout horizontal-align="spread"`):**

1. Salesforce 로고 — `lightning-icon icon-name="utility:salesforce1"` (+ assistive text "Salesforce")
2. 글로벌 검색 — `lightning-input type="search" variant="label-hidden"`, `flexibility="auto"`로 가운데 신축
3. Agentforce — `lightning-button-icon icon-name="utility:agent_astro"` → `handleAgentforceClick`
4. Favorites — `lightning-button-group`: stateful 별 아이콘(`utility:favorite`) + `lightning-button-menu`(View Favorites)
5. Global Actions — `lightning-button-menu icon-name="utility:new" nubbin="true"`
6. Guidance Center — `lightning-button-icon icon-name="utility:trailhead_alt"` → `handleTrailheadClick`
7. Help — `lightning-button-menu icon-name="utility:help" nubbin="true"`
8. Setup — `lightning-button-icon icon-name="utility:settings"` → `handleSettingsClick`
9. Notifications — `lightning-button-icon icon-name="utility:notification"` → `handleNotificationClick`
10. 아바타 — `lightning-avatar` (Austin Guevara, 이니셜 AG, fallback `standard:person_account`)

> 중요: **App Launcher(waffle)와 네비 탭은 헤더가 아니라 `ui-global-navigation`에 있다.** 헤더는 검색·전역 액션·패널 트리거만 담당한다.

```html
<!-- src/modules/ui/globalHeader/globalHeader.html (발췌 — 액션 클러스터) -->
<lightning-button-icon icon-name="utility:agent_astro" aria-haspopup="true" title="Agentforce"
    variant="bare" size="large" onclick={handleAgentforceClick} class="lightning-button-icon_custom slds-m-right_small">
</lightning-button-icon>
...
<lightning-button-icon icon-name="utility:notification" aria-haspopup="true" title="Notifications"
    variant="bare" size="large" onclick={handleNotificationClick} class="lightning-button-icon_custom">
</lightning-button-icon>
<lightning-avatar size="medium" src="/images/avatar1.jpg" initials="AG"
    fallback-icon-name="standard:person_account" alternative-text="Austin Guevara" variant="circle"
    class="slds-m-right_small"></lightning-avatar>
```

---

## ui-global-navigation — App Launcher · 오브젝트 스위처 · Standard 탭

크롬에서 가장 복잡한 컴포넌트. variant에 따라 두 레이아웃을 렌더한다: **Standard**(탭 스트립)와 **Console**(오브젝트 스위처). App Launcher(waffle)는 두 variant 공통.

**@api 프로퍼티 (전수):**

| 프로퍼티 | 기본값 | 설명 |
|---|---|---|
| `currentPage` | `'home'` | 현재 활성 navPage id (app.js `currentNavPage`). 탭 active 판정 |
| `navItems` | `[]` | Standard 탭 데이터 `{page, label, path, href}` (app.js `navItems`) |
| `appItems` | `[]` | App Launcher 항목 `{id, label, href, isCurrent}` (app.js `appItems`) |
| `pagesInCurrentApp` | `[]` | Console 스위처 메뉴 데이터 `{page, label, href, isCurrent}` |
| `variant` | `'standard'` | `'standard'` 또는 `'console'` |

**반응형 내부 필드:** `isWaffleMenuOpen = false`, `isObjectSwitcherOpen = false`. (포커스 예약용 `_focusOnNextRender`, 문서 클릭 바인딩 `_handleDocumentClickBound`는 동적으로 설정.)

모듈 상수: `const VARIANT_CONSOLE = 'console';`

**getters (전수):**

| getter | 반환/로직 |
|---|---|
| `isConsole` | `this.variant === VARIANT_CONSOLE` |
| `isStandard` | `!this.isConsole` |
| `contextBarClass` | console면 `slds-context-bar slds-context-bar_tabs`, 아니면 `slds-context-bar` |
| `waffleDropdownTriggerClass` | base 트리거 클래스 + open 시 `slds-is-open` |
| `isMainTabActive` | 항상 `true` (현재 구현 — object switcher 메인 탭 활성) |
| `mainTabAriaSelected` | `isMainTabActive ? 'true' : 'false'` |
| `objectSwitcherTabClass` | base + 활성 시 `slds-is-active` |
| `objectSwitcherChevronClass` | base chevron 트리거 + open 시 `slds-is-open` |
| `appItemsWithCurrent` | `appItems` 각 항목에 `ariaCurrent`(isCurrent면 `'true'`, 아니면 `null`) 추가 |
| `currentAppLabel` | `appItems`에서 `isCurrent`인 앱의 `label`, 없으면 `''` |
| `currentPageLabel` | `pagesInCurrentApp`에서 `isCurrent`인 페이지의 `label`, 없으면 `''` (Console 트리거 라벨) |
| `navItemsWithActive` | `navItems` 각 항목에 `isActive`/`tabClass`/`ariaCurrent` 추가 (아래 verbatim) |

**Standard 탭 생성 — `navItemsWithActive` (verbatim):**

```javascript
// src/modules/ui/globalNavigation/globalNavigation.js
    /** Nav items with isActive and tabClass derived from currentPage (Standard variant). */
    get navItemsWithActive() {
        return (this.navItems || []).map((item) => {
            const isActive = item.page === this.currentPage;
            const base = 'slds-context-bar__item';
            return {
                ...item,
                isActive,
                tabClass: isActive ? `${base} slds-is-active` : base,
                ariaCurrent: isActive ? 'page' : null,
            };
        });
    }
```

`item.page`가 곧 routes.config의 `navPage` id이고 `currentPage`는 app.js `currentNavPage`(`navPage ?? navHighlight`)에서 온다. 따라서 디테일 라우트(`/contacts/:id`, `navHighlight: 'contacts'`)에 있어도 Contacts 탭이 active 표시된다.

**App Launcher 항목 / 라벨 getters (verbatim):**

```javascript
// src/modules/ui/globalNavigation/globalNavigation.js
    get appItemsWithCurrent() {
        return (this.appItems || []).map((item) => ({
            ...item,
            ariaCurrent: item.isCurrent ? 'true' : null,
        }));
    }

    get currentAppLabel() {
        const current = (this.appItems || []).find((a) => a.isCurrent);
        return current?.label ?? '';
    }

    get currentPageLabel() {
        const current = (this.pagesInCurrentApp || []).find((p) => p.isCurrent);
        return current?.label ?? '';
    }
```

**이벤트 핸들러 (전수):**

| 핸들러 | 동작 | dispatch |
|---|---|---|
| `handleNavItemClick(event)` | `preventDefault` → `currentTarget.dataset.page` → `_dispatchNavigate(page)` | `navigate {page}` |
| `handleWaffleOpen(event)` | `stopPropagation` → waffle 토글(열면 object switcher 닫음), 열 때 `_focusOnNextRender='waffle'` | — |
| `handleWaffleMenuItemClick(event)` | `preventDefault`, waffle 닫고 `dataset.value`(appId) → `appswitch` dispatch | `appswitch {app}` |
| `handleObjectSwitcherToggle(event)` | `preventDefault`+`stopPropagation` → 토글(열면 waffle 닫음), 열 때 `_focusOnNextRender='object'` | — |
| `handleObjectSwitcherSelect(event)` | `lightning-menu-item`의 `privateselect` 수신 → `detail.value`(page) → 닫고 `_dispatchNavigate(page)` | `navigate {page}` |
| `handleWaffleMenuKeydown(event)` | Escape(닫고 트리거 포커스)/Tab(닫음)/ArrowUp·Down(메뉴아이템 순환 포커스) | — |
| `handleObjectSwitcherKeydown(event)` | 동일 키보드 내비 (menu-item은 자체 shadow root이라 host로 매칭) | — |
| `_dispatchNavigate(page)` | `navigate` CustomEvent(`{page}`, bubbles+composed). page 없으면 no-op | `navigate {page}` |
| `_handleDocumentClick(event)` | 외부 클릭 시 열린 메뉴 닫기 (connectedCallback에서 document 바인딩) | — |

**App Launcher → appswitch (verbatim):**

```javascript
// src/modules/ui/globalNavigation/globalNavigation.js
    handleWaffleMenuItemClick(event) {
        event.preventDefault();
        this.isWaffleMenuOpen = false;
        const appId = event.currentTarget.dataset.value;
        this.dispatchEvent(
            new CustomEvent('appswitch', {
                detail: { app: appId },
                bubbles: true,
                composed: true,
            })
        );
    }
```

**Console 스위처 → navigate (verbatim):**

```javascript
// src/modules/ui/globalNavigation/globalNavigation.js
    /**
     * Listens for `privateselect` bubbled up from `lightning-menu-item` children.
     * `lightning-menu-item` dispatches this with `bubbles: true` whenever the item
     * is activated by click or Space; we don't need a separate click handler.
     */
    handleObjectSwitcherSelect(event) {
        const page = event.detail?.value;
        if (!page) return;
        this.isObjectSwitcherOpen = false;
        this._dispatchNavigate(page);
    }

    _dispatchNavigate(page) {
        if (!page) return;
        this.dispatchEvent(
            new CustomEvent('navigate', {
                detail: { page },
                bubbles: true,
                composed: true,
            })
        );
    }
```

**라이프사이클 훅 (전수):**
- `connectedCallback()` — `_handleDocumentClick`을 바인딩해 `document` click 리스너 등록 (외부 클릭으로 메뉴 닫기)
- `disconnectedCallback()` — document click 리스너 제거
- `renderedCallback()` — `_focusOnNextRender`가 설정돼 있으면 waffle/object switcher의 첫 메뉴 항목에 `setTimeout(...,0)`으로 포커스 이동 후 플래그 초기화

**variant별 템플릿 차이:**
- **Standard** (`isStandard`): `slds-context-bar__secondary`에 `navItemsWithActive`를 `<li>` 탭 스트립으로 렌더. 각 anchor `href={item.href}`(linkHref로 app prefix 포함 실제 URL), `data-page={item.page}`, `onclick={handleNavItemClick}`. active면 `slds-is-active` + "Current Page:" assistive text.
- **Console** (`isConsole`): primary 영역에 오브젝트 스위처 — `currentPageLabel` 버튼 + chevron 드롭다운(`pagesInCurrentApp`을 `lightning-menu-item`으로, 선택은 `privateselect`). secondary는 divider만(주석: "Workspace tab strip will live here in a follow-up pass").
- **App Launcher(waffle):** 두 variant 공통. `lightning-dynamic-icon type="waffle"` → 드롭다운에 `appItemsWithCurrent` → 선택 시 `appswitch`. context bar에 `currentAppLabel` 표시.

```html
<!-- src/modules/ui/globalNavigation/globalNavigation.html (발췌 — Standard 탭) -->
<template lwc:if={isStandard}>
    <nav class="slds-context-bar__secondary" role="navigation" aria-label="App navigation">
        <ul class="slds-grid slds-container_fluid">
            <template for:each={navItemsWithActive} for:item="item">
                <li key={item.page} class={item.tabClass}>
                    <a href={item.href} class="slds-context-bar__label-action" title={item.label}
                        aria-current={item.ariaCurrent} data-page={item.page} onclick={handleNavItemClick}>
                        <span class="slds-assistive-text" lwc:if={item.isActive}>Current Page:</span>
                        <span class="slds-truncate" title={item.label}>{item.label}</span>
                    </a>
                </li>
            </template>
        </ul>
    </nav>
</template>
```

```html
<!-- src/modules/ui/globalNavigation/globalNavigation.html (발췌 — Console 오브젝트 스위처 드롭다운) -->
<div class={objectSwitcherChevronClass} role="presentation">
    <lightning-button-icon class="slds-m-horizontal_xx-small" icon-name="utility:chevrondown" variant="container"
        alternative-text="Open object switcher menu" aria-haspopup="true"
        onclick={handleObjectSwitcherToggle}>
    </lightning-button-icon>
    <div class="slds-dropdown slds-dropdown_left" lwc:if={isObjectSwitcherOpen} onkeydown={handleObjectSwitcherKeydown}>
        <div class="slds-dropdown__list" role="menu" onprivateselect={handleObjectSwitcherSelect}>
            <template for:each={pagesInCurrentApp} for:item="item">
                <lightning-menu-item key={item.page} label={item.label} value={item.page}></lightning-menu-item>
            </template>
        </div>
    </div>
</div>
```

> anchor `href`는 실제 URL(linkHref)이지만 `onclick`이 `preventDefault`로 풀페이지 이동을 막고 SPA navigate로 처리한다. href는 새 탭으로 열기/우클릭 복사/접근성용. linkHref·navigate 본문은 [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]] 참조.

---

## 도킹 패널 — shell-panel + ui-panel

우측에 도킹되는 패널은 **두 컴포넌트**로 나뉜다: `shell-panel`(4종 패널 타입을 매핑하는 셸 측 어댑터/호스트) + `ui-panel`(헤더/본문/close를 가진 재사용 프리젠테이션 빌딩블록).

### shell-panel (셸 측 어댑터)

`selectedPanel` 키 하나로 4종 패널의 제목·본문을 매핑해 `ui-panel`에 주입한다.

**@api 프로퍼티 (전수):**

| 프로퍼티 | 기본값 | 유효값 |
|---|---|---|
| `selectedPanel` | `'agentforce_panel'` | `agentforce_panel`, `trailhead_panel`, `notification_panel`, `settings_panel` |

**getters (전수):** 4개 `show*` boolean getter (`showAgentforcePanel`/`showTrailheadPanel`/`showNotificationPanel`/`showSettingsPanel` — 각각 `selectedPanel === '...'`) + `panelTitle` + `panelContent`.

> 주의: 4개 `show*` getter는 JS에 정의돼 있으나 `panel.html` 템플릿에서는 **사용되지 않는다**(템플릿은 `panelTitle`/`panelContent`만 사용). verbatim 확인.

`panelTitle` / `panelContent` 맵 (4종 패널 타입의 단일 출처, verbatim):

| `selectedPanel` 키 | panelTitle | panelContent |
|---|---|---|
| `agentforce_panel` | `Agentforce` | `Agentforce panel content` |
| `trailhead_panel` | `Guidance Center` | `Trailhead guidance content` |
| `notification_panel` | `Notifications` | `Notifications panel content` |
| `settings_panel` | `Setup` | `Settings panel content` |
| (그 외/폴백) | `Panel Header` | `A panel body accepts any layout or component` |

**핸들러 (전수):** `handleClosePanel()` → `panelclose` CustomEvent(bubbles+composed, detail 없음). 라이프사이클 훅: 없음.

```javascript
// src/modules/shell/panel/panel.js
import { LightningElement, api } from 'lwc';

export default class Panel extends LightningElement {
    @api selectedPanel = 'agentforce_panel';

    get showAgentforcePanel() {
        return this.selectedPanel === 'agentforce_panel';
    }
    get showTrailheadPanel() {
        return this.selectedPanel === 'trailhead_panel';
    }
    get showNotificationPanel() {
        return this.selectedPanel === 'notification_panel';
    }
    get showSettingsPanel() {
        return this.selectedPanel === 'settings_panel';
    }

    get panelTitle() {
        const titles = {
            'agentforce_panel': 'Agentforce',
            'trailhead_panel': 'Guidance Center',
            'notification_panel': 'Notifications',
            'settings_panel': 'Setup'
        };
        return titles[this.selectedPanel] || 'Panel Header';
    }

    get panelContent() {
        const content = {
            'agentforce_panel': 'Agentforce panel content',
            'trailhead_panel': 'Trailhead guidance content',
            'notification_panel': 'Notifications panel content',
            'settings_panel': 'Settings panel content'
        };
        return content[this.selectedPanel] || 'A panel body accepts any layout or component';
    }

    handleClosePanel() {
        this.dispatchEvent(new CustomEvent('panelclose', {
            bubbles: true,
            composed: true
        }));
    }
}
```

```html
<!-- src/modules/shell/panel/panel.html -->
<template>
    <ui-panel title={panelTitle} show-close onclose={handleClosePanel}>
        <lightning-button-icon
            slot="actions"
            icon-name="utility:pinned"
            size="small"
            variant="container"
            alternative-text="Unpin panel"
            title="Unpin panel">
        </lightning-button-icon>
        {panelContent}
    </ui-panel>
</template>
```

CSS 파일 없음. `panelclose` → app.js `handlePanelClose`로 `isPanelOpen=false`.

### ui-panel (재사용 빌딩블록)

헤더(제목 + actions 슬롯 + 선택적 close 버튼) + 본문(default 슬롯)을 가진 순수 프리젠테이션 컴포넌트. 4종 패널 타입 분기는 갖지 않는다 — 그것은 위 `shell-panel` 소관.

**@api 프로퍼티 (전수):**

| 프로퍼티 | 기본값 | 설명 |
|---|---|---|
| `title` | `''` | 헤더 제목 (`slds-panel__header-title`, `title` 속성에도 바인딩) |
| `showClose` | `false` | `true`면 헤더 우측에 close 버튼아이콘 렌더 (`lwc:if`) |

**핸들러 (전수):** `handleClose()` → `close` CustomEvent(bubbles+composed, detail 없음). getters/라이프사이클 훅: 없음.

**슬롯:** `actions`(named, close 버튼 앞), default(`slds-panel__body` 본문).

```javascript
// src/modules/ui/panel/panel.js
import { LightningElement, api } from 'lwc';

export default class Panel extends LightningElement {
    @api title = '';
    @api showClose = false;

    handleClose() {
        this.dispatchEvent(
            new CustomEvent('close', { bubbles: true, composed: true })
        );
    }
}
```

```css
/* src/modules/ui/panel/panel.css */
:host {
    display: flex;
    flex-direction: column;
    height: 100%;
    min-height: 0;
}
```

`ui-panel`은 도킹 패널뿐 아니라 Builder 페이지의 좌(Components)·우(Properties) 레일에도 재사용된다.

---

## 재사용 빌딩블록 — pageHeader · homeIntro · builderHeader

### ui-page-header

SLDS `slds-page-header` 블루프린트의 다목적 래퍼. variant에 따라 3행(타이틀 / 메타·컨트롤 / 디테일필드)을 조건 렌더한다.

모듈 상수: `VARIANT_BASE='base'`, `VARIANT_OBJECT_HOME='object-home'`, `VARIANT_RECORD_HOME='record-home'`, `VARIANT_RELATED_LIST='related-list'`, `VALID_VARIANTS=[base, object-home, record-home, related-list]`.

**@api 프로퍼티 (전수):**

| 프로퍼티 | 기본값 | 종류 | 설명 |
|---|---|---|---|
| `iconName` | `''` | 필드 | 헤더 아이콘 (예: `standard:contact`) |
| `objectLabel` | `''` | 필드 | 오브젝트 라벨 (타이틀 위/아이콘 alt) |
| `title` | `''` | 필드 | 페이지 타이틀 |
| `label` | `''` | 필드 | 루트 div `aria-label` |
| `metaText` | `''` | 필드 | 메타 텍스트 |
| `hideDetails` | `false` | 필드 | record-home에서 디테일행 숨김 |
| `variant` | `'base'` | getter/setter | setter가 소문자·trim 후 `VALID_VARIANTS` 검증, 미일치 시 `base` 폴백 |
| `fields` | `[]` | getter/setter | setter가 `Array.isArray` 검증, 아니면 `[]` |
| `breadcrumbs` | `[]` | getter/setter | setter가 `Array.isArray` 검증, 아니면 `[]` |

**계산 getters (전수):**

| getter | 로직 |
|---|---|
| `computedHeaderClass` | `slds-page-header` + record-home면 `slds-page-header_record-home`, related-list면 `slds-page-header_related-list` |
| `hasIcon` | `!!this.iconName` |
| `hasObjectLabel` | `!!this.objectLabel && !this.showBreadcrumbs` |
| `isBase`/`isObjectHome`/`isRecordHome`/`isRelatedList` | 각 `_variant === VARIANT_*` |
| `showIcon` | `hasIcon && !isRelatedList` |
| `showMetaRow` | `isObjectHome \|\| isRelatedList` |
| `showDetailsRow` | `isRecordHome && !hideDetails && _fields.length > 0` |
| `showBaseMeta` | `isBase && !!metaText` |
| `showBreadcrumbs` | `_breadcrumbs.length > 0` |
| `showActions` | `!isBase` |
| `showSwitcher` | `isObjectHome` |
| `searchLabel` | `` `Search ${objectLabel \|\| 'this list'}` `` |
| `normalizedFields` | `_fields` → `{key:'field-${i}', label, value(String화), type('text' 기본)}` |

**핸들러 (전수):** `handleSearchChange(event)` → `search` CustomEvent, detail `{ value: event.target.value }`, **bubbles=false, composed=false** (페이지 내부 소비용). 라이프사이클 훅: 없음.

**슬롯:** `switcher`(object-home 타이틀행), `actions`(non-base 액션열), `meta`(meta row, 기본콘텐츠로 metaText 단락).

```javascript
// src/modules/ui/pageHeader/pageHeader.js (발췌 — variant setter + 핵심 getter/handler)
    @api
    get variant() { return this._variant; }
    set variant(value) {
        const normalized = typeof value === 'string' ? value.toLowerCase().trim() : '';
        this._variant = VALID_VARIANTS.includes(normalized) ? normalized : VARIANT_BASE;
    }

    @api
    get fields() { return this._fields; }
    set fields(value) { this._fields = Array.isArray(value) ? value : []; }

    get computedHeaderClass() {
        const classes = ['slds-page-header'];
        if (this._variant === VARIANT_RECORD_HOME) {
            classes.push('slds-page-header_record-home');
        } else if (this._variant === VARIANT_RELATED_LIST) {
            classes.push('slds-page-header_related-list');
        }
        return classes.join(' ');
    }

    handleSearchChange(event) {
        this.dispatchEvent(
            new CustomEvent('search', {
                detail: { value: event.target.value },
                bubbles: false,
                composed: false,
            })
        );
    }

    get normalizedFields() {
        return this._fields.map((f, i) => ({
            key: `field-${i}`,
            label: f.label || '',
            value: f.value != null ? String(f.value) : '',
            type: f.type || 'text'
        }));
    }
```

템플릿 3행 구조:
- **Row 1** — breadcrumbs(`showBreadcrumbs`) → media(아이콘 `showIcon` + 타이틀/objectLabel `hasObjectLabel` + switcher 슬롯 `showSwitcher` + base meta `showBaseMeta`) + actions 열(`showActions`).
- **Row 2** (`showMetaRow`) — meta 슬롯 + 컨트롤. object-home이면 search input(`onchange=handleSearchChange`) + settings/table/edit/refresh 버튼아이콘 + chart/filterList 버튼그룹. related-list면 table 버튼아이콘 + chart/filterList 버튼그룹.
- **Row 3** (`showDetailsRow`) — `normalizedFields` 반복 → 각 `lightning-input` read-only, `variant="label-stacked"`.

CSS: `:host { display: block; }`.

### ui-home-intro

홈 페이지 인트로 블록. JS는 빈 클래스(`export default class HomeIntro extends LightningElement {}`) — @api/getter/핸들러/라이프사이클 전부 없음. 정적 마크업 3단계 가이드를 렌더한다:

1. **Start with Lightning Base Components** (링크: developer.salesforce.com/docs/platform/lightning-component-reference) — "**Always** start with Lightning Base Components first. When talking with an agent, name these components directly (for example, `lightning-button`)."
2. **Use Component Blueprints when needed** (링크: v1.lightningdesignsystem.com) — Lightning Base Components로 부족하면 Blueprint에서 새 LWC 생성, 가능한 한 많은 마크업을 LBC로 대체.
3. **Build custom with Global Styling Hooks** (링크: lightningdesignsystem.com global-styling-hooks) — LBC·Blueprint로도 부족하면 Global Styling Hooks로 커스텀 컴포넌트.

각 step: 좌측 번호(`intro-step-number`, `aria-hidden`) + 우측 `<h3>`(외부링크 + `utility:new_window` 아이콘) + 카피. 헤더는 `<h1>` "Welcome to the Salesforce UI Starter Kit". CSS는 brand 색상(`--slds-g-color-brand-base-50`)·폰트 스케일 훅 사용.

### ui-builder-header

SLDS `slds-builder-header` 기반 빌더 앱 크롬. 상단 배너(back / 앱명 / 문서명 / Settings·Help utilities) + 선택적 toolbar.

**@api 프로퍼티 (전수):**

| 프로퍼티 | 기본값 | 설명 |
|---|---|---|
| `appName` | `'Builder'` | 헤더 좌측 앱 라벨 (`utility:builder` 아이콘 옆) |
| `documentTitle` | `'Untitled'` | 헤더 중앙 문서 제목 (`<h1>`, truncate) |
| `showToolbar` | `false` | `true`면 헤더 아래 `slds-builder-toolbar` 렌더 (`lwc:if`) |

**핸들러 (전수 — 모두 bubbles+composed):**

| 핸들러 | 트리거 | dispatch | 비고 |
|---|---|---|---|
| `handleBack(event)` | Back 링크 | `back` | `event.preventDefault()` |
| `handleSettings(event)` | Settings 링크 | `settings` | `event.preventDefault()` |
| `handleSave()` | (기본 toolbar) Save | `save` | — |
| `handleSaveAs()` | (기본 toolbar) Save As | `saveas` | — |

**슬롯:** `toolbar-actions-left`(기본: undo/redo 버튼그룹 + toggle_panel_left), `toolbar-actions-right`(기본: Save As neutral + Save brand). getters/라이프사이클 훅: 없음. CSS 파일 없음.

```javascript
// src/modules/ui/builderHeader/builderHeader.js
import { LightningElement, api } from 'lwc';

export default class BuilderHeader extends LightningElement {
    @api appName = 'Builder';
    @api documentTitle = 'Untitled';
    @api showToolbar = false;

    handleBack(event) {
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('back', { bubbles: true, composed: true }));
    }

    handleSettings(event) {
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('settings', { bubbles: true, composed: true }));
    }

    handleSave() {
        this.dispatchEvent(new CustomEvent('save', { bubbles: true, composed: true }));
    }

    handleSaveAs() {
        this.dispatchEvent(new CustomEvent('saveas', { bubbles: true, composed: true }));
    }
}
```

> 슬롯에 기본 콘텐츠(undo/redo, Save/Save As)가 있어 소비자가 슬롯을 채우지 않으면 기본 버튼이 표시되며, 이때만 `save`/`saveas` 이벤트가 동작한다. page-builder는 이 슬롯을 자체 콘텐츠로 오버라이드한다(아래 참조).

---

## 예제 페이지

### page-contacts — 데이터테이블 리스트뷰

`lightning-datatable` 기반 Contacts 리스트뷰. `ui-page-header`(object-home) + 검색/정렬/행액션.

임포트: `import { navigate } from '../../../router';`, `import { getAllContacts } from 'data/contacts';`

**COLUMNS 상수 (전수):**

| # | label | fieldName | type | sortable | typeAttributes |
|---|---|---|---|---|---|
| 1 | Name | `name` | `button` | true | `{ label:{fieldName:'name'}, variant:'base', name:'view' }` |
| 2 | Account Name | `company` | (default) | true | — |
| 3 | Title | `title` | (default) | true | — |
| 4 | Phone | `phone` | `phone` | — | — |
| 5 | Email | `email` | `email` | — | — |
| 6 | — | — | `action` | — | `{ rowActions: [{View,view},{Edit,edit},{Delete,delete}] }` |

**반응형 필드:** `columns = COLUMNS`, `data = []`, `sortedBy = 'name'`, `sortedDirection = 'asc'`, `searchTerm = ''`. @api: 없음.

**라이프사이클:** `connectedCallback()` → `this.data = getAllContacts();`

**getters (전수):** `filteredData`(searchTerm 없으면 전체, 있으면 name/company/title/email 소문자 includes 필터), `metaText`(`` `${count} item${count!==1?'s':''}` `` + sortField 있으면 ` • Sorted by ${sortField}` + ` • Updated a few seconds ago`).

**핸들러 (전수):**

| 핸들러 | 트리거 | 동작 |
|---|---|---|
| `handleSearch(event)` | `ui-page-header` `onsearch` | `searchTerm = event.detail.value` |
| `handleSort(event)` | datatable `onsort` | `{fieldName, sortDirection}` 추출, data 복제 후 문자열 소문자 비교 정렬, 3필드 갱신 |
| `handleRowAction(event)` | datatable `onrowaction` | `view`→`navigate('/contacts/'+row.id)`, `delete`→해당 id 필터 제거 (`edit`는 미처리) |

```javascript
// src/modules/page/contacts/contacts.js (발췌 — 행 액션 → 라우팅)
    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;

        if (action.name === 'view') {
            navigate(`/contacts/${row.id}`);
        } else if (action.name === 'delete') {
            this.data = this.data.filter(item => item.id !== row.id);
        }
    }
```

```html
<!-- src/modules/page/contacts/contacts.html (발췌 — 헤더 + 데이터테이블) -->
<ui-page-header variant="object-home" icon-name="standard:contact" object-label="Contacts"
    title="All Contacts" meta-text={metaText} onsearch={handleSearch}>
    <lightning-button-icon slot="switcher" icon-name="utility:down" variant="bare" size="small"
        alternative-text="Switch list view" title="Switch list view"></lightning-button-icon>
    <div slot="actions"> ... New/Import/Add to Campaign/Send Email 버튼그룹 + Printable View 메뉴 ... </div>
</ui-page-header>

<lightning-datatable key-field="id" data={filteredData} columns={columns}
    sorted-by={sortedBy} sorted-direction={sortedDirection}
    onsort={handleSort} onrowaction={handleRowAction} show-row-number-column>
</lightning-datatable>
```

CSS 파일 없음.

### page-contact-detail — 레코드 디테일

`ui-page-header`(record-home) + 2/3 Contact Details 카드 + 1/3 Activity 타임라인. 라우터의 `id` 파라미터로 contact 조회.

임포트: `import { getCurrentRoute, navigate } from '../../../router';`, `import { getContactById } from 'data/contacts';`

모듈 상수 `DETAIL_FIELDS` (9개): Full Name(`name`), Account Name(`company`), Title(`title`), Department(`department`), Email(`email`,email), Phone(`phone`,tel), Mobile(`mobile`,tel), Mailing Address(`mailingAddress`,조합), Description(`description`, `component:'textarea', fullWidth:true`).

모듈 상수 `ACTIVITY_ITEMS` (4개): a1 Follow-up call(`standard:log_a_call`, 3 days ago), a2 Proposal sent(`standard:email`, 1 week ago), a3 Quarterly review meeting(`standard:event`, 2 weeks ago), a4 Introductory call(`standard:log_a_call`, 1 month ago).

**반응형 필드:** `contact = null`, `isFollowing = false`, `activityItems = ACTIVITY_ITEMS`. @api: 없음.

**라이프사이클:** `connectedCallback()` → `getCurrentRoute()`에서 `route?.params?.id` 추출, id 있으면 `this.contact = getContactById(id)`.

**getters (전수):** `hasContact`(`contact !== null`), `cardFields`(DETAIL_FIELDS 매핑 — `mailingAddress`면 조합주소, `isTextarea`/`cssClass` 파생), `contactName`(`contact?.name || 'Unknown Contact'`), `detailFields`(`[{Company},{Title},{Email,email},{Phone,tel}]`, page-header `fields`로 전달), `mailingAddress`(`` `${street}, ${city}, ${state} ${zip}` ``), `followVariant`/`followLabel`/`followIconName`(isFollowing 토글: success·Following·utility:check vs neutral·Follow·utility:add).

**핸들러 (전수):** `handleFollow()` → `isFollowing = !isFollowing` (CustomEvent 없음). `handleBackToList()` → `navigate('/contacts')` (not-found 상태의 "Back to Contacts").

```javascript
// src/modules/page/contactDetail/contactDetail.js (발췌 — 라우트 파라미터 소비 + getters)
    connectedCallback() {
        const route = getCurrentRoute();
        const id = route?.params?.id;
        if (id) {
            this.contact = getContactById(id);
        }
    }

    get cardFields() {
        if (!this.contact) return [];
        return DETAIL_FIELDS.map(field => ({
            ...field,
            value: field.fieldName === 'mailingAddress'
                ? this.mailingAddress
                : this.contact[field.fieldName],
            isTextarea: field.component === 'textarea',
            cssClass: field.fullWidth ? 'c-contact-details-grid__full-width' : ''
        }));
    }

    handleBackToList() {
        navigate('/contacts');
    }
```

템플릿: `hasContact`이면 `ui-page-header`(record-home, `fields={detailFields}`) + actions(Follow 버튼[동적] + Edit/Delete/Clone 버튼그룹 + More Actions 메뉴) + body grid(좌 8/12 "Contact Details" 카드에 `cardFields` 반복[textarea/input read-only] / 우 4/12 "Activity" 카드에 `activityItems` 타임라인). `lwc:else`면 "Contact not found" 일러스트 + "Back to Contacts".

> 참고: contactDetail은 `fields={detailFields}`(4개)를 page-header에 넘겨 record-home Row 3 디테일 행을 렌더하면서 동시에 좌측 카드에 `cardFields`(9개)도 렌더한다 — 두 곳에 필드가 표시될 수 있다(verbatim 사실).

### page-builder — 빌더 풀페이지

빌더 앱 풀 페이지. 좌측 Components 레일(토글/닫기) + 캔버스 + 우측 Properties 레일. settings는 `ui/builderSettingsModal`을 `.open()`으로 호출.

모듈 상수: `STORAGE_KEY_PAGE_NAME = 'builder-page-name'`, `DEFAULT_PAGE_NAME = 'Untitled Page'`. 임포트: `import BuilderSettingsModal from 'ui/builderSettingsModal';`

**반응형 필드:** `pageName = DEFAULT_PAGE_NAME`, `showLeftPanel = true`. @api: 없음.

**getter:** `leftRailClass` — base 클래스(`slds-panel slds-panel_docked slds-panel_docked-left slds-is-open builder-rail builder-rail_left slds-scrollable`), `showLeftPanel` 아니면 ` slds-hide` 추가.

**라이프사이클:** `connectedCallback()` → try/catch로 `localStorage.getItem('builder-page-name')` 읽어 있으면 `pageName` 할당.

**핸들러/메서드 (전수):**

| 핸들러 | 동작 | dispatch |
|---|---|---|
| `handleBack()` | builderexit 발행 | `builderexit` (bubbles+composed) |
| `toggleLeftPanel()` | `showLeftPanel = !showLeftPanel` | — |
| `closeLeftPanel()` | `showLeftPanel = false` | — |
| `handleSave()` | no-op (빈 함수) | — |
| `handleSaveAs()` | no-op (빈 함수) | — |
| `handleSettings()` (async) | `BuilderSettingsModal.open(...)` await → result `undefined`면 취소, 아니면 `pageName = result \|\| DEFAULT_PAGE_NAME` + localStorage 저장 | — |

```javascript
// src/modules/page/builder/builder.js (발췌 — builderexit + settings 모달)
    handleBack() {
        this.dispatchEvent(
            new CustomEvent('builderexit', { bubbles: true, composed: true })
        );
    }

    async handleSettings() {
        const result = await BuilderSettingsModal.open({
            size: 'small',
            label: 'Page Settings',
            pageName: this.pageName,
        });
        if (result === undefined) return;
        this.pageName = result || DEFAULT_PAGE_NAME;
        try {
            localStorage.setItem(STORAGE_KEY_PAGE_NAME, this.pageName);
        } catch {
            /* empty */
        }
    }
```

템플릿: `ui-builder-header`(app-name="Builder", document-title={pageName}, show-toolbar, onback=handleBack, onsettings=handleSettings)에 toolbar 슬롯을 자체 콘텐츠로 오버라이드 — left에 undo/redo + `lightning-button-icon-stateful`(selected={showLeftPanel}, onclick=toggleLeftPanel), right에 Save As/Save(onclick으로 builder의 no-op 핸들러). body grid: 좌 `{leftRailClass}` 안 `ui-panel`(Components, show-close, onclose=closeLeftPanel) / 중앙 `main.builder-canvas` / 우 `ui-panel`(Properties).

> builder가 toolbar 슬롯을 오버라이드하므로 builder 페이지에서 실제 동작하는 버튼은 builder.html 슬롯 콘텐츠(toggleLeftPanel, no-op save)이고 builderHeader의 기본 save/saveas 이벤트는 사용되지 않는다. back/settings만 builderHeader의 `onback`/`onsettings` 경로를 쓴다. `builderexit`는 app.js `handleBuilderExit`로 standard 앱 복귀 — [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]] 참조.

**ui-builder-settings-modal** (builder가 의존하는 `LightningModal` 확장): `@api pageName=''`, 내부 `_value=''`, getter `inputValue`. `connectedCallback`에서 `_value = pageName`. `handleNameChange`(`_value = event.detail.value`), `handleCancel`(`this.close()` → 인자 없음 → builder가 `undefined`로 취소 처리), `handleSave`(`this.close((this._value || '').trim())`). open() 반환 계약: 저장=trim 문자열, 취소=`undefined`.

### page-home — 컴포넌트 갤러리

`ui-home-intro` + Lightning Base Components 데모 카드(Input/Selection/Other/Buttons/Icon Buttons/Badges/Modal/Spinner). 폼 입력은 모두 `event.detail.value`(또는 toggle은 `event.detail.checked`)를 반응형 필드에 저장하고, 버튼은 `lightning/toast`의 `Toast.show(...)`, Modal Demo는 `ui/demoModal`의 `DemoModal.open(...)`을 호출한다.

**반응형 필드:** `inputValue=''`, `checkboxGroupValues=[]`, `selectedRadioValue='option1'`, `selectedComboboxValue='option1'`, `sliderValue=50`, `textAreaValue=''`, `dateValue=''`, `toggleValue=false`.

**getters:** `comboboxOptions`/`radioOptions`/`checkboxOptions` (옵션 배열 3종).

**핸들러:** 8개 change 핸들러(input/checkbox/radio/combobox/slider/textArea/date/toggle) + 5개 버튼 핸들러(`handleButtonClick`/`handleSuccessButton`/`handleNeutralButton`/`handleBrandButton`/`handleDestructiveButton` — 각 `Toast.show({label, message, variant, mode:'dismissible'})`) + `handleOpenModal`(`DemoModal.open({size:'medium', label:'Demo Modal'})`).

```javascript
// src/modules/page/home/home.js (발췌 — toast + modal 데모)
import Toast from 'lightning/toast';
import DemoModal from 'ui/demoModal';
...
    handleButtonClick() {
        Toast.show({ label: 'Button clicked', message: 'Base button was clicked.', variant: 'info', mode: 'dismissible' });
    }

    handleOpenModal() {
        DemoModal.open({
            size: 'medium',
            label: 'Demo Modal',
        });
    }
```

> `lightning/toast`·`lightning/modal`(DemoModal)·폼 입력 컴포넌트의 상세 사용법은 [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]] 참조.

---

## 데이터 픽스처 — data/contacts

순수 JS 데이터 모듈(LightningElement 아님). 7개 contact 픽스처 + 2개 export 함수. contacts/contactDetail이 `import ... from 'data/contacts'`로 소비한다.

**Export 함수 (전수):**

| 함수 | 시그니처 | 반환 | 동작 |
|---|---|---|---|
| `getAllContacts()` | `()` | `Array<Contact>` | `[...CONTACTS]` (얕은 복사) |
| `getContactById(id)` | `(id: string)` | `Contact \| null` | `CONTACTS.find(c => c.id === id) || null` |

**Contact 스키마 (키):** `id`, `name`, `title`, `company`, `email`, `phone`, `mobile`, `department`, `mailingStreet`, `mailingCity`, `mailingState`, `mailingZip`, `description`.

**CONTACTS 데이터 (7건):**

| id | name | title | company | department | mailing |
|---|---|---|---|---|---|
| 1 | Lando Voss | VP Sales | Global Media | Sales | 123 Market St, San Francisco, CA 94105 |
| 2 | Carlos Piquet | President and CEO | Acme | Executive | 456 Broadway, New York, NY 10013 |
| 3 | Lewis Mansell | President | Global Media | Executive | 123 Market St, San Francisco, CA 94105 |
| 4 | Max Alonso | Buyer | Acme | Procurement | 456 Broadway, New York, NY 10013 |
| 5 | Oscar Lauda | Sales Manager | Global Media | Sales | 789 King St W, Toronto, ON M5V 1N4 |
| 6 | Kimi Leclerc | VP Customer Support | Acme | Customer Support | 456 Broadway, New York, NY 10013 |
| 7 | Ayrton Prost | Executive Officer | Pinnacle Corp | Executive | 415 Mission St, San Francisco, CA 94105 |

```javascript
// src/modules/data/contacts/contacts.js (발췌 — export 함수)
export function getAllContacts() {
    return [...CONTACTS];
}

export function getContactById(id) {
    return CONTACTS.find(c => c.id === id) || null;
}
```

각 contact는 `email`(예: `lvoss@globalmedia.com`)·`phone`·`mobile`·`description`도 갖는다. `getContactById`는 문자열 id 매칭(`'1'`~`'7'`)이므로 라우트 `/contacts/:id`의 string param과 직접 호환된다.

---

## 관련 노트
- [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]]
- [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]]
- [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]]
- [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]]
- [[SLDS 2 Starter Kit - UI 코딩 가이드라인]]
- [[SLDS 블루프린트 카탈로그]]
- [[SLDS LWC 디자인 시스템]]
