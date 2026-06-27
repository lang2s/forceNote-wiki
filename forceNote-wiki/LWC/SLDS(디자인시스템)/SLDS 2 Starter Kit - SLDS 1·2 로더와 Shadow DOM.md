---
tags: [slds, slds2, starter-kit, lwc, theme, dark-mode, synthetic-shadow, css-loading]
source: salesforce-ux/design-system-2-starter-kit (GitHub, 공식 Salesforce UX)
created: 2026-06-26
aliases: [SLDS 로더, slds-loader.js, initSldsFromStorage, SLDS 1 2 전환, 테마 스위처, 다크 모드, synthetic shadow, lazy CSS 로딩, slds2.cosmos.css]
---

# SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM

> SLDS 2 Starter Kit가 SLDS 1·2 전역 스타일시트를 `<link media>` 토글로 전환하고(SLDS2 상시 로드 / SLDS1 lazy import), 다크 모드를 `body` 클래스로 켜며, synthetic shadow DOM으로 Salesforce 플랫폼 동작을 재현하는 메커니즘을 소스 코드 그대로 정리한 노트.

이 노트는 4부 클러스터의 3번째다. 전체 구조·셋업은 [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]], 라우팅·셸은 [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]], 아이콘·모달·배포는 [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]] 참조.

---

## 1. 로딩 메커니즘 개요

이 스타터킷은 SLDS 전역 CSS를 LWC 컴포넌트 CSS가 아니라 **`<head>`에 주입한 `<link rel="stylesheet">` 태그**로 로드한다. 활성 시트는 링크의 **`media` 속성**으로 토글한다.

| `media` 값 | 동작 |
|---|---|
| `""` / `all` | 적용됨 (applied) |
| `not all` | 가져오기는 하지만 적용 안 됨 (fetched but not applied) — 두 링크가 모두 존재할 때 |

핵심 정책 (소스 주석 verbatim):

> *"SLDS 2 is always loaded on startup. SLDS 1 is lazy-loaded when the user selects it or when localStorage says the last session used SLDS 1 (see initSldsFromStorage)."*

- **SLDS 2** → 시작 시 항상 로드 (`slds2.cosmos.css`).
- **SLDS 1** → `import('./slds/slds1-url.js')` 동적 import로 **lazy** 로드. 사용자가 SLDS 1로 전환하거나, 저장된 선호가 버전 1일 때만 가져온다. 기본 번들은 classic SLDS를 fetch하지 않는다.

각 링크는 `data-slds` 속성으로 식별한다:

| 상수 | 값 | 대상 |
|---|---|---|
| `SLDS2_KEY` | `'slds-plus'` | SLDS 2 (`<link data-slds="slds-plus">`) |
| `SLDS1_KEY` | `'salesforce-lightning-design-system'` | SLDS 1 (`<link data-slds="salesforce-lightning-design-system">`) |

URL은 `new URL(..., import.meta.url)` 패턴으로 만들어 Vite가 해시된 CSS 에셋을 emit하고 중첩 `url(...)` 참조를 재작성하게 한다 (자세한 이유는 아래 [10. vite CSS 번들링 우회](#10-vite-css-번들링-우회) 참조).

---

## 2. `slds-loader.js` 전체

위치: `src/build/slds-loader.js`. 모든 로딩/전환 로직의 단일 진입점이다.

```js
/**
 * SLDS global stylesheets are loaded as <link rel="stylesheet"> tags.
 * Asset URLs use `new URL(..., import.meta.url)` so Vite emits hashed files and
 * rewrites nested `url(...)` without the css?url → transform-only Rollup parse path
 * that breaks when vite-plugin-lwc sits between vite:css and vite:css-post.
 *
 * The active sheet is toggled via the link's media attribute:
 *   - media="" / "all"  → applied
 *   - media="not all"   → fetched but not applied (when both links exist)
 *
 * SLDS 2 is always loaded on startup. SLDS 1 is lazy-loaded when the user selects it
 * or when localStorage says the last session used SLDS 1 (see initSldsFromStorage).
 */

const slds2CssUrl = new URL(
    '../../node_modules/@salesforce-ux/design-system-2/dist/css/bundled/slds2.cosmos.css',
    import.meta.url
).href;

export const STORAGE_KEY_SLDS_VERSION = 'slds-ui-slds-version';

const SLDS2_KEY = 'slds-plus';
const SLDS1_KEY = 'salesforce-lightning-design-system';

/** @type {Promise<string> | null} */
let slds1UrlPromise = null;

function getLink(key) {
    return document.querySelector(`link[data-slds="${key}"]`);
}

function ensureLink(key, href, media = 'not all') {
    let link = getLink(key);
    if (!link) {
        link = document.createElement('link');
        link.rel = 'stylesheet';
        link.media = media;
        link.setAttribute('data-slds', key);
        link.href = href;
        document.head.appendChild(link);
    } else if (href && link.getAttribute('href') !== href) {
        link.href = href;
    }
    return link;
}

/**
 * Resolves the SLDS1 CSS asset URL and ensures a <link> exists.
 * @returns {Promise<HTMLLinkElement>}
 */
export function ensureSlds1Loaded() {
    if (!slds1UrlPromise) {
        slds1UrlPromise = import('./slds/slds1-url.js').then((m) => m.default);
    }
    return slds1UrlPromise.then((href) => ensureLink(SLDS1_KEY, href));
}

/**
 * Bootstrap: insert SLDS2, then load SLDS1 only if storage requests version 1.
 * Call from src/index.js before mounting LWC (top-level await).
 */
export async function initSldsFromStorage() {
    const saved = localStorage.getItem(STORAGE_KEY_SLDS_VERSION);
    if (saved === '1') {
        const slds2Link = ensureLink(SLDS2_KEY, slds2CssUrl);
        const slds1Link = await ensureSlds1Loaded();
        slds1Link.media = 'all';
        slds2Link.media = 'not all';
    } else {
        ensureLink(SLDS2_KEY, slds2CssUrl, 'all');
    }
}

export function activateSLDS2() {
    const slds2 = getLink(SLDS2_KEY);
    const slds1 = getLink(SLDS1_KEY);
    if (slds2) slds2.media = 'all';
    if (slds1) slds1.media = 'not all';
}

/**
 * @returns {Promise<void>}
 */
export async function activateSLDS1() {
    const slds1 = await ensureSlds1Loaded();
    const slds2 = getLink(SLDS2_KEY);
    if (slds2) slds2.media = 'not all';
    slds1.media = 'all';
}

/**
 * @returns {Promise<void>}
 */
export async function toggleSLDS() {
    const slds2 = getLink(SLDS2_KEY);
    if (!slds2) return;

    const usingSlds2 = slds2.media !== 'not all';
    if (usingSlds2) {
        await activateSLDS1();
    } else {
        activateSLDS2();
    }
}

export function activeSLDSVersion() {
    const slds2 = getLink(SLDS2_KEY);
    return slds2 && slds2.media !== 'not all' ? 2 : 1;
}

export function preloadSlds1() {
    ensureSlds1Loaded();
}

export function activeSldsLink() {
    const slds2 = getLink(SLDS2_KEY);
    return slds2 && slds2.media !== 'not all' ? slds2 : getLink(SLDS1_KEY);
}
```

### Export 표

| Export | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `STORAGE_KEY_SLDS_VERSION` | `const = 'slds-ui-slds-version'` | `string` | SLDS 버전 선호를 저장하는 localStorage 키 |
| `ensureSlds1Loaded()` | `() => Promise<HTMLLinkElement>` | SLDS1 `<link>` 요소 | `slds1-url.js`를 동적 import해 URL을 해석하고, SLDS1 `<link>`가 존재하도록 보장 (Promise 캐시) |
| `initSldsFromStorage()` | `async () => Promise<void>` | — | 부트스트랩용. SLDS2 링크를 삽입하고, 저장값이 `'1'`이면 SLDS1을 로드해 `media`를 맞바꾼다. `src/index.js`에서 LWC 마운트 전 top-level await로 호출 |
| `activateSLDS2()` | `() => void` | — | SLDS2 `media='all'`, SLDS1 `media='not all'` (동기) |
| `activateSLDS1()` | `async () => Promise<void>` | — | SLDS1을 로드(필요 시) 후 SLDS1 `media='all'`, SLDS2 `media='not all'` |
| `toggleSLDS()` | `async () => Promise<void>` | — | 현재 SLDS2 사용 중이면 `activateSLDS1()`, 아니면 `activateSLDS2()`. SLDS2 링크가 없으면 no-op |
| `activeSLDSVersion()` | `() => number` | `2` 또는 `1` | SLDS2 링크가 있고 `media !== 'not all'`이면 `2`, 아니면 `1` |
| `preloadSlds1()` | `() => void` | — | `ensureSlds1Loaded()`를 호출만 하고 반환값 무시 — 백그라운드 프리로드용 |
| `activeSldsLink()` | `() => HTMLLinkElement` | 활성 `<link>` | 현재 적용 중인 시트의 `<link>` 요소 반환 (SLDS2가 활성이면 SLDS2, 아니면 SLDS1) |

### 내부 헬퍼 (export 안 됨)

| 헬퍼 | 시그니처 | 동작 |
|---|---|---|
| `getLink(key)` | `(key) => HTMLLinkElement \| null` | `document.querySelector('link[data-slds="${key}"]')` |
| `ensureLink(key, href, media='not all')` | `(key, href, media) => HTMLLinkElement` | 해당 `data-slds` 링크가 없으면 생성(`rel='stylesheet'` + 지정 `media` + `href`)해 `<head>`에 append. 이미 있고 href가 다르면 href만 갱신. **새 링크의 기본 media는 `'not all'`** (fetch만, 미적용) |
| `slds2CssUrl` | `const` (모듈 상수) | `new URL(...slds2.cosmos.css, import.meta.url).href` — SLDS2 번들 CSS의 해석된 URL |
| `slds1UrlPromise` | `let = null` | SLDS1 URL의 동적 import Promise 캐시 (중복 fetch 방지) |

> `ensureLink`의 기본 `media='not all'`이 핵심이다. `initSldsFromStorage()`가 SLDS1을 먼저 만들 때는 미적용 상태(`not all`)로 생성되고, 곧바로 `slds1Link.media = 'all'`로 전환된다.

---

## 3. SLDS1 lazy chunk (`slds1-url.js`)

위치: `src/build/slds/slds1-url.js`.

```js
/** Lazy chunk: resolved URL for SLDS1 global CSS (see slds-loader.js). */
export default new URL(
    '../../../node_modules/@salesforce-ux/design-system/assets/styles/salesforce-lightning-design-system.min.css',
    import.meta.url
).href;
```

이 파일이 **별도 모듈**로 분리된 이유: `slds-loader.js`가 `import('./slds/slds1-url.js')`로 동적 import하면 Vite/Rollup이 이를 **별도 code-split chunk**로 떼어낸다. 따라서 SLDS1을 실제로 선택하기 전까지 기본 번들은 classic SLDS CSS URL 모듈조차 fetch하지 않는다. URL 상수 하나만 export하는 최소 모듈이므로 분리 비용도 거의 없다.

---

## 4. 부트스트랩 순서

엔트리는 `src/index.js`이고, synthetic shadow 패치가 먼저 적용되도록 실제 앱 부트스트랩은 `src/bootstrap.js`로 분리되어 있다.

`src/index.js`:

```js
// MUST import synthetic shadow BEFORE any LWC imports.
import '@lwc/synthetic-shadow';

// Load app bootstrap only after synthetic shadow patches runtime globals.
await import('./bootstrap.js');
```

`src/bootstrap.js`:

```js
import { createElement } from 'lwc';
import App from 'shell/app';
import { initSldsFromStorage, activeSldsLink } from './build/slds-loader.js';

await initSldsFromStorage();

// Inject global stylesheet after SLDS using new URL() to bypass LWC plugin.
// This allows the CSS to be processed by Vite without LWC's synthetic shadow restrictions.
const globalCssUrl = new URL('./styles/global.css', import.meta.url).href;
const globalLink = document.createElement('link');
globalLink.rel = 'stylesheet';
globalLink.href = globalCssUrl;
document.head.appendChild(globalLink);

// Create and mount the app component
try {
    const app = createElement('shell-app', {
        is: App
    });
    document.querySelector('#app').appendChild(app);
} catch (err) {
    console.error('[LWC bootstrap] Failed to mount app:', err);
}

// Reveal the app once the active SLDS stylesheet has loaded.
const link = activeSldsLink();
if (link && !link.sheet) {
    await new Promise((r) => { link.addEventListener('load', r, { once: true }); });
}
document.getElementById('app')?.classList.add('is-ready');

// Preload icon template modules so they're likely ready when the first icons render.
Promise.all([
    import('lightning/iconSvgTemplatesUtility'),
    import('lightning/iconSvgTemplatesStandard'),
    import('lightning/iconSvgTemplatesDoctype'),
    import('lightning/iconSvgTemplatesAction'),
]).catch(() => {});
```

순서 정리:

1. `index.js`가 **synthetic-shadow를 가장 먼저** import (`// MUST import synthetic shadow BEFORE any LWC imports.`) — 런타임 전역을 패치한 뒤에야 `bootstrap.js`를 동적 import.
2. `bootstrap.js`가 **`await initSldsFromStorage()`** — 올바른 테마가 first paint 전에 활성화되도록 보장.
3. global.css를 `new URL()` 패턴으로 SLDS 뒤에 주입.
4. `shell-app` 컴포넌트 생성·마운트 (`#app`에 append).
5. 활성 SLDS 시트가 로드 완료(`link.sheet`)될 때까지 대기 → `#app`에 `is-ready` 클래스 추가 (reveal).
6. 아이콘 템플릿 모듈 프리로드.

> **README/실제 코드 위치 뉘앙스:** README는 *"`src/index.js` awaits `initSldsFromStorage()` ... before mounting LWC"*라고 서술하지만, 실제 코드에서 `await initSldsFromStorage()`와 마운트 로직은 `index.js`가 동적 import하는 **`bootstrap.js`**에 들어 있다. `index.js`는 synthetic-shadow를 먼저 적용한 뒤 `bootstrap.js`를 불러오는 얇은 wrapper다. README는 두 파일을 합쳐 "index.js"로 단순화해 설명한 것.

---

## 5. 테마 스위처 UI

위치: `src/modules/shell/themeSwitcher/`. 화면 우하단에 고정된 팔레트 버튼을 눌러 카드를 열고, SLDS 1/2 토글과 다크 모드 토글을 노출한다.

`themeSwitcher.js`:

```js
import { LightningElement, api } from 'lwc';
import { preloadSlds1 } from '../../../build/slds-loader';

export default class ThemeSwitcher extends LightningElement {
    @api sldsVersion = 2;
    @api darkMode = false;
    isCardOpen = false;
    isCardClosing = false;

    get sldsToggleLabel() {
        return this.sldsVersion === 2 ? 'Switch to SLDS 1' : 'Switch to SLDS 2';
    }

    get showDarkModeButton() {
        return this.sldsVersion === 2;
    }

    get darkModeLabel() {
        return this.darkMode ? 'Light Mode' : 'Dark Mode';
    }

    disconnectedCallback() {
        window.removeEventListener('click', this._handleWindowClick);
    }

    get showCard() {
        return this.isCardOpen || this.isCardClosing;
    }

    get cardWrapperClass() {
        const base = 'theme-switcher-card-wrapper';
        return this.isCardClosing ? `${base} ${base}--closing` : base;
    }

    handleIconClick() {
        if (this.isCardOpen) {
            this._beginCloseCard();
        } else if (this.isCardClosing) {
            this.isCardClosing = false;
            this.isCardOpen = true;
            setTimeout(() => {
                window.addEventListener('click', this._handleWindowClick);
            }, 0);
        } else {
            this.isCardOpen = true;
            preloadSlds1();
            setTimeout(() => {
                window.addEventListener('click', this._handleWindowClick);
            }, 0);
        }
    }

    _beginCloseCard() {
        this.isCardOpen = false;
        window.removeEventListener('click', this._handleWindowClick);
        if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
            this.isCardClosing = false;
            return;
        }
        this.isCardClosing = true;
    }

    handleCardWrapperAnimationEnd(event) {
        if (event.animationName !== 'theme-switcher-card-close') {
            return;
        }
        this.isCardClosing = false;
    }

    _handleWindowClick = (event) => {
        if (!this.isCardOpen) {
            return;
        }
        const path = event.composedPath();
        if (!path.includes(this.template.host)) {
            this._beginCloseCard();
        }
    };

    handleToggleSLDSClick() {
        this.dispatchEvent(new CustomEvent('toggleslds', { bubbles: true, composed: true }));
    }

    handleToggleDarkModeClick() {
        this.dispatchEvent(new CustomEvent('toggledarkmode', { bubbles: true, composed: true }));
    }
}
```

`themeSwitcher.html`:

```html
<template>
    <div class="theme-switcher slds-is-fixed slds-m-bottom_small slds-m-right_small">
        <lightning-button-icon
            icon-name="utility:palette"
            variant="border-filled"
            size="large"
            alternative-text="Theme options"
            title="Theme options"
            aria-haspopup="true"
            aria-expanded={isCardOpen}
            onclick={handleIconClick}>
        </lightning-button-icon>
        <template lwc:if={showCard}>
            <div class={cardWrapperClass} onanimationend={handleCardWrapperAnimationEnd}>
                <lightning-card title="Theme" class="theme-switcher-card">
                    <div class="slds-p-around_small">
                        <div class="slds-button-group slds-m-bottom_small">
                            <lightning-button
                                variant="neutral"
                                label={sldsToggleLabel}
                                icon-name="utility:palette"
                                onclick={handleToggleSLDSClick}>
                            </lightning-button>
                            <template lwc:if={showDarkModeButton}>
                                <lightning-button
                                    class="slds-m-left_small"
                                    variant="neutral"
                                    label={darkModeLabel}
                                    icon-name="utility:light_bulb"
                                    onclick={handleToggleDarkModeClick}>
                                </lightning-button>
                            </template>
                        </div>
                    </div>
                </lightning-card>
            </div>
        </template>
    </div>
</template>
```

동작 요점:

- **팔레트 버튼 → 카드:** `utility:palette` 아이콘 버튼(`handleIconClick`)으로 `lightning-card`를 토글. 열림/닫힘은 `isCardOpen`·`isCardClosing` 상태로 관리하고 `prefers-reduced-motion: reduce`면 닫힘 애니메이션을 생략한다.
- **카드 열릴 때 `preloadSlds1()` 호출:** 사용자가 카드를 처음 열면(`else` 분기) SLDS1을 백그라운드로 미리 fetch해, 실제 토글 시 지연이 없도록 한다.
- **외부 클릭 닫기:** `window` click 리스너가 `event.composedPath()`에 `this.template.host`가 없으면 카드를 닫는다(synthetic shadow를 통과하는 composedPath 사용).
- **SLDS 1/2 토글 버튼:** 항상 표시. 라벨은 `sldsToggleLabel`(`sldsVersion===2`면 "Switch to SLDS 1", 아니면 "Switch to SLDS 2"). 클릭 시 `toggleslds` custom event 발생.
- **다크 모드 버튼:** `showDarkModeButton`이 `sldsVersion === 2`일 때만 `true` → **SLDS 2에서만 노출**. 라벨은 `darkModeLabel`(`darkMode`면 "Light Mode", 아니면 "Dark Mode"). 클릭 시 `toggledarkmode` custom event 발생.
- **이벤트 전파:** 두 custom event 모두 `{ bubbles: true, composed: true }` — synthetic shadow 경계를 넘어 셸 앱(`shell-app`)까지 버블링되어 핸들러가 받는다.

`sldsVersion`·`darkMode`는 `@api` 프로퍼티이므로 부모(`shell-app`)가 현재 상태를 내려준다(이 컴포넌트는 상태를 직접 바꾸지 않고 event만 올린다 — 상태 전환은 셸 앱이 담당).

---

## 6. 핸들러 측 (shell/app)

위치: `src/modules/shell/app/app.js`. 테마 스위처가 올린 이벤트를 받아 실제 전환을 수행하고 선호를 저장한다. (이 파일의 라우팅/멀티앱 부분은 [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]] 참조 — 여기서는 SLDS·다크모드 관련 멤버만 다룬다.)

테마 관련 멤버 verbatim:

```js
const STORAGE_KEY_DARK_MODE = 'slds-ui-dark-mode';
```

```js
    _restorePreferences() {
        const savedVersion = localStorage.getItem(STORAGE_KEY_SLDS_VERSION);
        const savedDarkMode = localStorage.getItem(STORAGE_KEY_DARK_MODE);
        const version = savedVersion === '1' ? 1 : 2;
        if (savedDarkMode === 'true' && version === 2) {
            this._darkMode = true;
            document.body.classList.add('slds-color-scheme_dark');
        } else if (savedDarkMode === 'false') {
            this._darkMode = false;
            document.body.classList.remove('slds-color-scheme_dark');
        }
    }
```

```js
    async handleToggleSLDS() {
        await toggleSLDS();
        this._sldsVersion = activeSLDSVersion();
        localStorage.setItem(STORAGE_KEY_SLDS_VERSION, String(this._sldsVersion));
        if (this._sldsVersion !== 2 && this._darkMode) {
            this._darkMode = false;
            document.body.classList.remove('slds-color-scheme_dark');
            localStorage.setItem(STORAGE_KEY_DARK_MODE, 'false');
        }
    }

    handleToggleDarkMode() {
        this._darkMode = !this._darkMode;
        document.body.classList.toggle('slds-color-scheme_dark', this._darkMode);
        localStorage.setItem(STORAGE_KEY_DARK_MODE, String(this._darkMode));
    }
```

- `connectedCallback()`은 `_restorePreferences()`를 호출한 뒤 `this._sldsVersion = activeSLDSVersion()`으로 현재 버전을 동기화한다.
- `handleToggleSLDS()`는 `toggleSLDS()`(로더)를 await → 새 버전을 localStorage에 저장 → **SLDS1으로 바뀌었고 다크 모드가 켜져 있으면 강제 해제**(아래 7절 참조).
- `handleToggleDarkMode()`는 `_darkMode`를 뒤집고 `body` 클래스와 localStorage를 갱신.

---

## 7. 다크 모드

다크 모드는 **`<body>`의 `slds-color-scheme_dark` 클래스**로 켜진다 (`document.body.classList`).

- **저장 키:** localStorage `slds-ui-dark-mode` (상수 `STORAGE_KEY_DARK_MODE = 'slds-ui-dark-mode'`).
- **SLDS 2에서만 유효:** UI 측에서 다크 모드 버튼은 `showDarkModeButton`(= `sldsVersion === 2`)일 때만 노출된다. 복원 측에서도 `_restorePreferences()`가 `savedDarkMode === 'true' && version === 2`일 때만 다크를 켠다.
- **SLDS1 전환 시 강제 해제:** `handleToggleSLDS()`에서 전환 결과가 SLDS2가 아니고(`this._sldsVersion !== 2`) 다크 모드가 켜져 있으면, `_darkMode = false` + `body` 클래스 제거 + localStorage에 `'false'` 저장으로 다크 모드를 끈다.

복원 분기 정리:

| `slds-ui-dark-mode` | 버전 | 결과 |
|---|---|---|
| `'true'` | 2 | 다크 ON (`body`에 `slds-color-scheme_dark` 추가) |
| `'true'` | 1 | 적용 안 함 (다크는 SLDS2 전용) |
| `'false'` | 무관 | 다크 OFF (`body`에서 클래스 제거) |
| (없음) | 무관 | 변화 없음 (기본 라이트) |

`global.css`는 SLDS 컬러 팔레트 훅과 CSS `light-dark()` 함수를 함께 사용해 라이트/다크 값을 한 선언에 담는다:

```css
html.builder-active {
    overscroll-behavior-x: none;
    overscroll-behavior-y: none;
}

/* Global Header: Action Icons */
.lightning-button-menu_custom .slds-button__icon {
    fill: light-dark(var(--slds-g-color-palette-neutral-60), var(--slds-g-color-palette-neutral-40));
}

.lightning-button-menu_custom:hover .slds-button__icon {
    fill: light-dark(var(--slds-g-color-palette-neutral-50), var(--slds-g-color-palette-neutral-30));
}

.lightning-button-menu_custom lightning-primitive-icon:nth-of-type(2) {
    display: none;
}

.lightning-button-menu_custom .slds-button:first-child {
    border-inline-end-width: var(--slds-g-border-width-1, 1px);
}

.lightning-button-menu_custom .slds-button_icon-container-more {
    line-height: inherit;
}
```

`light-dark(라이트값, 다크값)`는 현재 컬러 스킴(여기서는 `slds-color-scheme_dark` 클래스가 결정)에 따라 첫/둘째 값을 고른다. 스타일링 훅(`--slds-g-color-palette-*`)에 대한 일반 설명은 [[SLDS 스타일링 훅]] 참조.

---

## 8. localStorage 키 표

| 키 | 상수 / 위치 | 값 | 의미 |
|---|---|---|---|
| `slds-ui-slds-version` | `STORAGE_KEY_SLDS_VERSION` (slds-loader.js, export) | `'1'` / `'2'` | 마지막 세션에서 사용한 SLDS 버전. `'1'`일 때만 부트스트랩이 SLDS1을 lazy 로드 |
| `slds-ui-dark-mode` | `STORAGE_KEY_DARK_MODE` (app.js, 모듈 상수) | `'true'` / `'false'` | 다크 모드 선호. 단 SLDS2일 때만 적용됨 |

---

## 9. Shadow DOM (synthetic vs native)

이 템플릿은 **Synthetic Shadow DOM**을 사용해 동작·스타일링이 Salesforce 플랫폼과 일치하도록 한다. README 비교표 verbatim:

| Feature | Synthetic Shadow (default) | Native Shadow |
|---|---|---|
| Platform match | Matches Salesforce | Different |
| Global styles | Penetrate components | Blocked |
| DOM queries | Can query inside components | Cannot query in |
| `shadowRoot` | `null` | ShadowRoot |

- **Verify (확인 방법):** 브라우저 콘솔(http://localhost:3000)에서 `document.querySelector('shell-app').shadowRoot` 실행 → 결과가 **`null`이면 synthetic shadow가 활성** 상태라는 뜻.
- **Switch to native shadow:** `vite.config.js`의 LWC 플러그인 옵션에서 `disableSyntheticShadowSupport: true`로 설정 (기본값은 `false`).
- **Why synthetic?** (README verbatim 요지) Salesforce 플랫폼 동작과 일치, 전역 SLDS 스타일이 컴포넌트 내부까지 적용 가능, 컴포넌트를 플랫폼으로 마이그레이션하기 쉬움, 테스트·툴링을 위해 DOM이 inspect 가능한 상태로 유지됨.

전역 SLDS CSS를 `<link>`로 주입하는 1절의 설계가 성립하는 이유가 바로 이 "Global styles penetrate components"다 — synthetic shadow에서는 전역 시트가 컴포넌트 경계를 통과한다. LWC의 synthetic vs native shadow 메커니즘 자체에 대한 일반 설명은 [[LWC Shadow DOM 모드]] 참조.

---

## 10. vite CSS 번들링 우회

위치: `vite.config.js`. SLDS 전역 CSS와 global.css는 **LWC 플러그인 파이프라인을 통과하면 안 된다.** synthetic shadow가 켜진 상태에서 LWC가 이 파이프라인의 `:root` 선택자를 거부하기 때문이다.

LWC 플러그인 `exclude` 배열 verbatim:

```js
      disableSyntheticShadowSupport: false,
      enableDynamicComponents: true,
      exclude: [
        path.resolve('./index.html'),
        /loading\.css/,
        path.resolve('./src/build/generated'),
        // Global SLDS from node_modules (new URL in slds-loader.js) must not pass through LWC:
        // LWC rejects :root in this pipeline when synthetic shadow is enabled.
        /(salesforce-lightning-design-system\.min\.css|slds2\.cosmos\.css)(\?.*)?$/,
        // Global styles loaded via new URL() pattern must also bypass LWC plugin
        /\/styles\/global\.css(\?.*)?$/,
        ...iconTemplateExcludeDirs,
      ],
```

- SLDS 1·2 CSS(`salesforce-lightning-design-system.min.css`, `slds2.cosmos.css`)와 `styles/global.css`를 정규식으로 제외(`?...` 쿼리 suffix 포함).
- 이들 CSS는 LWC 컴포넌트 CSS가 아니라 `new URL(..., import.meta.url)` 패턴으로 로드된다. 그러면 Vite는 일반 에셋으로 처리해 해시된 파일을 emit하고 중첩 `url(...)`을 재작성하되, `css?url → transform-only Rollup parse` 경로(= `vite-plugin-lwc`가 `vite:css`와 `vite:css-post` 사이에 끼어들 때 깨지는 경로)를 피한다 (slds-loader.js 상단 주석 참조).

또한 두 design-system 패키지는 `resolve.alias`로 node_modules 경로에 명시적으로 고정한다:

```js
  resolve: {
    alias: {
      '@salesforce-ux/design-system': path.resolve('./node_modules/@salesforce-ux/design-system'),
      '@salesforce-ux/design-system-2': path.resolve('./node_modules/@salesforce-ux/design-system-2'),
      ...iconTemplateAliases,
    },
  },
```

이로써 `new URL('../../node_modules/@salesforce-ux/...', import.meta.url)`이 가리키는 경로가 일관되게 해석된다.

---

## 관련 노트
- [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]]
- [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]]
- [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]]
- [[SLDS 2 Starter Kit - 셸 UI 컴포넌트]]
- [[SLDS 2 Starter Kit - 빌드 설정과 진입 HTML]]
- [[SLDS 스타일링 훅]]
- [[SLDS 모범 사례]]
- [[LWC Shadow DOM 모드]]
