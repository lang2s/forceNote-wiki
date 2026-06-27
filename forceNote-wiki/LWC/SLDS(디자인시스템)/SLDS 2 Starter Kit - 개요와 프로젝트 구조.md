---
tags: [slds, slds2, starter-kit, lwc, vite, lightning-base-components, prototyping]
source: salesforce-ux/design-system-2-starter-kit (GitHub, 공식 Salesforce UX)
created: 2026-06-26
aliases: [SLDS 2 Starter Kit, design-system-2-starter-kit, SLDS 스타터킷, LWC Vite 프로토타이핑, 로컬 LWC 개발환경, SLDS 로컬 프로토타입]
---

# SLDS 2 Starter Kit - 개요와 프로젝트 구조

> Salesforce UX 공식 로컬 프로토타이핑 템플릿 — LWC + Vite + SLDS 1/2 + Lightning Base Components를 합성 섀도우(synthetic shadow)와 클라이언트 사이드 라우팅으로 묶은 시작 키트.

이 노트는 **SLDS 2 Starter Kit 4부작 클러스터의 허브(1번)** 다. 라우팅·SLDS 로더·아이콘/모달/배포 세부는 형제 노트(맨 아래 **관련 노트** 섹션)로 분리했고, 여기서는 **전체 개요·기술 스택·프로젝트 구조·진입점 흐름·컨벤션**을 다룬다.

---

## 1. 개요 / 누구를 위한 것 / 무엇을 제공하나

`salesforce-ux/design-system-2-starter-kit`는 **Salesforce 경험(UI)을 로컬에서 프로토타이핑/개발하기 위한 시작 템플릿**이다. LWC(Lightning Web Components), Vite, SLDS(Salesforce Lightning Design System), lightning-base-components로 구성되어 빠른 빌드·핫 리로드를 제공하면서 Salesforce 플랫폼 동작(합성 섀도우, 베이스 컴포넌트, 디자인 토큰)에 정렬된다.

### 누구를 위한 것 (Who this is for)

README 원문 그대로:

- 플랫폼 배포 전/배포와 병행하여 **Salesforce UI를 로컬에서 프로토타이핑**하는 개발자
- LWC와 SLDS로 경험을 설계·평가하는 팀
- **Salesforce 동작과 일치하는 로컬 개발 환경**(합성 섀도우, 전역 SLDS 스타일, Lightning Base Components)을 원하는 누구나

### 무엇을 제공하나 (What you get)

| 제공 항목 | 설명 |
|---|---|
| **App shell** | Header, 전역 내비게이션, 테마 스위처(light/dark, SLDS 1/2), 패널 레이아웃 |
| **클라이언트 사이드 라우팅** | `src/routes.config.js`에 선언적 라우트, path 파라미터(예: `/contacts/:id`), History API, 전체 페이지 리로드 없음 |
| **SLDS + Lightning Base Components** | 디자인 시스템과 Salesforce 컴포넌트 라이브러리가 연결되어 바로 사용 가능 |
| **Synthetic Shadow DOM** | Salesforce 플랫폼 동작과 일치 → 스타일·DOM 의미가 프로덕션과 정렬 |
| **아이콘 셋업** | prebuild 스크립트, `lightning/iconSvgTemplates*`용 Vite 별칭, `src/build/lightning-icon/shims/` 하위 shim 모듈; 생성 번들은 `src/build/generated/` |
| **예제 페이지** | Home, Icons, Contacts(파라미터화 상세 라우트 `/contacts/:id`). 패턴은 `src/modules/page/`·`src/modules/ui/` 참조 |
| **멀티 앱 셸** | 두 앱 모드(탭의 Standard, 객체 스위처의 Console) — `src/apps.config.js`에 구성 |

### Quick start

```bash
npm install
npm run dev
```

개발 서버는 **http://localhost:3000** 에서 실행된다. 전역 SLDS 스타일은 Vite가 `@salesforce-ux/design-system`·`@salesforce-ux/design-system-2`에서 해석한다(빌드 시 `dist/assets/`에 해시된 CSS). 프로덕션 번들 빌드/미리보기:

```bash
npm run build
npm run preview
```

> 라우팅·멀티 앱(Standard/Console)·테마 스위처의 메커니즘 상세는 [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]] 참조.

---

## 2. 기술 스택 & 의존성

`package.json` 전문(verbatim):

```json
{
  "name": "design-system-2-starter-kit",
  "version": "1.0.0",
  "description": "Starter template for prototyping Salesforce experiences with LWC, Vite, SLDS, and Lightning Base Components",
  "author": "Salesforce UX",
  "scripts": {
    "postinstall": "npm run skills:sync",
    "skills:sync": "node scripts/sync-afv-skills.mjs",
    "prebuild-icons": "node scripts/prebuild-icons.mjs",
    "dev": "node scripts/prebuild-icons.mjs && vite",
    "dev:native-shadow": "echo 'To use native shadow, set disableSyntheticShadowSupport: true in vite.config.js'",
    "build": "node scripts/prebuild-icons.mjs && vite build",
    "build:gh-pages": "node scripts/prebuild-icons.mjs && vite build --mode gh-pages",
    "preview": "vite preview",
    "deploy": "npm run build:gh-pages && gh-pages -d dist --nojekyll",
    "clean": "rm -rf dist .vite node_modules"
  },
  "license": "SEE LICENSE IN LICENSE.txt",
  "type": "module",
  "dependencies": {
    "@lwc/synthetic-shadow": "^9.0.2",
    "@salesforce-ux/design-system": "^2.29.0",
    "@salesforce-ux/design-system-2": "^2.0.0",
    "lightning-base-components": "^1.28.15-alpha",
    "lwc": "^9.0.2"
  },
  "devDependencies": {
    "gh-pages": "^6.3.0",
    "vite": "^7.3.1",
    "vite-plugin-lwc": "^4.1.0"
  },
  "engines": {
    "node": ">=20"
  }
}
```

### 버전 표 (package.json 정확히 일치)

| 패키지 | 버전 | 종류 | 역할 |
|---|---|---|---|
| `lwc` | `^9.0.2` | dependency | Lightning Web Components 프레임워크 |
| `@lwc/synthetic-shadow` | `^9.0.2` | dependency | 합성 섀도우 DOM (Salesforce 유사 동작) |
| `@salesforce-ux/design-system` | `^2.29.0` | dependency | Classic SLDS (SLDS 1) |
| `@salesforce-ux/design-system-2` | `^2.0.0` | dependency | SLDS 2 / Cosmos |
| `lightning-base-components` | `^1.28.15-alpha` | dependency | Salesforce 컴포넌트 라이브러리 — **버전이 `alpha`임에 주의** |
| `vite` | `^7.3.1` | devDependency | 빌드 도구 & 개발 서버 |
| `vite-plugin-lwc` | `^4.1.0` | devDependency | Vite용 LWC 지원 |
| `gh-pages` | `^6.3.0` | devDependency | GitHub Pages 배포 |
| `node` | `>=20` | engines | 런타임 요구 사항 |

> ⚠️ **`lightning-base-components`는 `^1.28.15-alpha` (정식 GA가 아닌 alpha 빌드)** 다. README "Tech stack and dependencies"는 SLDS 패키지 역할도 명시한다: `@salesforce-ux/design-system`은 SLDS 1을 로드할 때 Vite가 `assets/styles/salesforce-lightning-design-system.min.css`(및 중첩 `url(...)` 에셋)를 번들; `@salesforce-ux/design-system-2`는 기본 테마용 `dist/css/bundled/slds2.cosmos.css`를 번들한다. `public/images/`(예: favicon `salesforce.svg`)는 앱 소유 에셋으로 레포에 남는다.

> npm 스크립트(`dev`/`build`/`build:gh-pages`/`deploy`/`skills:sync` 등)의 동작 상세 — 특히 GitHub Pages 배포 흐름 — 는 [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]] 참조.

---

## 3. 프로젝트 구조

README "Project structure" 트리(verbatim):

```
design-system-2-starter-kit/
├── src/
│   ├── modules/
│   │   ├── shell/                 # App shell (shell-*)
│   │   │   ├── app/               # Root app, route rendering
│   │   │   ├── globalShell/       # Layout wrapper
│   │   │   ├── panel/             # Side panel
│   │   │   └── themeSwitcher/     # SLDS version + dark mode
│   │   ├── page/                  # Route-level views (page-*)
│   │   │   ├── home/
│   │   │   ├── contacts/
│   │   │   ├── contactDetail/     # e.g. /contacts/:id
│   │   │   └── iconTest/
│   │   ├── ui/                    # Reusable building blocks (ui-*)
│   │   │   ├── globalHeader/      # Top bar (ui-global-header)
│   │   │   ├── globalNavigation/ # App navigation (ui-global-navigation)
│   │   │   └── example/
│   │   └── data/                  # Shared modules (e.g. fixtures) imported as data/*
│   ├── build/                     # Build wiring, generated assets, shims (not LWC app UI)
│   │   ├── generated/             # Generated icon modules (do not edit)
│   │   ├── shim/                  # LWC / package shims (e.g. gate modules)
│   │   ├── slds/
│   │   │   └── slds1-url.js       # Lazy chunk: resolved URL for SLDS 1 stylesheet
│   │   ├── lightning-icon/shims/  # Icon template overrides (lightning/iconSvgTemplates* → here)
│   │   └── slds-loader.js         # SLDS stylesheet link injection, theme bootstrap, lazy SLDS 1
│   ├── router.js                  # Route definitions and navigation
│   └── index.js                   # App entry point
├── scripts/
│   ├── prebuild-icons.mjs         # Icon codegen (run via npm scripts)
│   └── sync-afv-skills.mjs        # Copies afv-library skills → .agent/skills/afv-library/
├── index.html
├── vite.config.js
└── package.json
```

### 두 종류의 최상위 디렉터리

- **`src/modules/{shell,page,ui,data}/`** — 실제 앱 코드. 폴더가 곧 LWC 네임스페이스(아래 §4). 각 폴더의 역할은 in-repo `README.md`로 문서화돼 있다:
  - **`shell/`** — 앱 전체를 감싸는 chrome: 루트 부트스트랩, 레이아웃, 테마, docked 패널. `src/index.js`에서 마운트되는 루트 컴포넌트(`shell-app`)가 여기 있음. 라우트 화면(`page-*`)도, 재사용 위젯(`ui-*`)도 아닌 것만.
  - **`page/`** — 라우트에 묶인 풀 페이지 뷰. URL에 대응하는 화면, 라우터가 렌더하는 최상위 뷰. 신규 페이지는 `src/router.js`와 `shell/app`의 `ROUTE_COMPONENTS`에 등록.
  - **`ui/`** — 페이지·셸·다른 컴포넌트가 쓰는 **빌딩 블록**. 재사용 프리미티브(카드/버튼/모달/폼 컨트롤), 공유 레이아웃, SLDS 컴포넌트 블루프린트 구현(global header, global navigation 등). 풀 라우트/뷰가 **아닌** 것.
  - **`data/`** — `data/<name>` 경로로 import하는 **순수 JS 모듈**(예: `import { getAllContacts } from 'data/contacts'`). LWC가 **아니며** 템플릿에 `data-*` 태그가 없다. 공유 데이터 헬퍼·픽스처·정적 데이터셋 등.
- **`src/build/`** — 빌드 배선·생성 에셋·shim (LWC 앱 UI가 **아님**). `generated/`(생성 아이콘 모듈, 편집 금지), `shim/`(LWC/패키지 shim, 예: gate 모듈), `slds/slds1-url.js`(SLDS 1 스타일시트 URL 지연 청크), `lightning-icon/shims/`(아이콘 템플릿 오버라이드), `slds-loader.js`(SLDS 스타일시트 링크 주입·테마 부트스트랩·지연 SLDS 1).

> `src/build/slds-loader.js`·`slds/slds1-url.js`의 SLDS 1/2 로딩 메커니즘과 Shadow DOM 동작 상세는 [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]] 참조. 아이콘 prebuild/shim 메커니즘은 [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]] 참조.

---

## 4. 컴포넌트 네임스페이스 (폴더 = 태그 프리픽스)

`src/modules/` 하위의 폴더 기반 네임스페이스가 LWC 태그 프리픽스를 정의한다. README "Component namespaces" 표(verbatim):

| Folder | Tag prefix | Use for |
|---|---|---|
| **shell/** | `shell-*` | App shell only (e.g. `shell-app`, `shell-global-shell`). Not for feature pages. |
| **page/** | `page-*` | Route-level views (one per URL). e.g. `page-contact-detail` for `/contacts/:id`. |
| **ui/** | `ui-*` | Reusable building blocks and SLDS blueprint implementations (e.g. `ui-global-header`, `ui-global-navigation`). Used inside pages or other components. |
| **data/** | - | Plain modules (e.g. fixtures), imported as `data/<name>`. Not LWC tags. |

### 핵심 규칙 (README 원문)

- **page/** 또는 **ui/** 아래에만 컴포넌트를 추가한다.
- 앱 셸 배선은 **`shell/`에만**, 재사용 SLDS 블루프린트 구현은 **`ui/`에** 둔다.
- 아이콘 템플릿 shim은 **`src/build/lightning-icon/shims/`**에만 있고, 거기에 다른 파일을 추가하지 않는다.
- 커스텀 컴포넌트용 **`lightning/` 폴더를 `src/modules` 아래에 만들지 않는다.**

**예시:** `src/modules/page/dashboard/` 추가 → router/app에 등록 → 예: `/dashboard`에서 `page-dashboard`로 사용. `src/modules/ui/card/` 추가 → 템플릿에서 `<ui-card>`로 사용.

---

## 5. 진입점 흐름 (index.js → bootstrap.js)

진입은 **두 파일로 분리**돼 있다. `src/index.js`가 **합성 섀도우를 먼저** import하고, 그다음 `bootstrap.js`를 **동적 import**한다 — 합성 섀도우가 런타임 글로벌을 패치한 *후에야* 앱 코드가 로드되도록 보장하기 위함이다.

`src/index.js` (verbatim):

```js
// MUST import synthetic shadow BEFORE any LWC imports.
import '@lwc/synthetic-shadow';

// Load app bootstrap only after synthetic shadow patches runtime globals.
await import('./bootstrap.js');
```

`src/bootstrap.js` (verbatim):

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

### 실제 실행 순서

1. **`index.js`** — `@lwc/synthetic-shadow`를 **가장 먼저** import (LWC import보다 앞). 합성 섀도우가 런타임 글로벌을 패치한 뒤에야 `import('./bootstrap.js')`를 await.
2. **`bootstrap.js`** — `initSldsFromStorage()`를 **await**하여 마운트 전에 올바른 테마(SLDS 1/2)가 첫 페인트에서 활성화되도록 함.
3. `new URL('./styles/global.css', import.meta.url)`로 전역 스타일시트를 `<link>`로 주입(LWC 플러그인을 우회 → Vite가 처리하되 합성 섀도우 제약을 안 받음). SLDS 링크 뒤에 추가됨.
4. `createElement('shell-app', { is: App })`로 루트 컴포넌트 생성 후 `#app`에 append (실패 시 `console.error`).
5. 활성 SLDS 스타일시트(`activeSldsLink()`)가 아직 로드 전이면 `load` 이벤트를 await한 뒤 `#app`에 **`is-ready`** 클래스 추가 → reveal-on-ready (FOUC 방지).
6. 4개 아이콘 템플릿 모듈(`lightning/iconSvgTemplates{Utility,Standard,Doctype,Action}`)을 `Promise.all`로 **프리로드** — 첫 아이콘 렌더 시 준비돼 있도록(실패는 무시).

> ⚠️ **주의 — README와 실제 코드의 미묘한 차이:** README "SLDS 1 and SLDS 2" 섹션은 *"`src/index.js` awaits `initSldsFromStorage()` ... before mounting LWC"* 라고 표현하지만, **실제 `await initSldsFromStorage()` 호출은 `index.js`가 아니라 `bootstrap.js`에 있다.** `index.js`는 합성 섀도우 import 후 `bootstrap.js`를 동적 import할 뿐이고, SLDS 초기화 await는 그 bootstrap 안에서 일어난다. (README는 진입 모듈 분리를 단순화해 서술한 것.)

> `initSldsFromStorage()`·`activeSldsLink()`의 내부 동작과 SLDS 1 지연 로딩은 [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]] 참조.

---

## 6. vite.config.js 핵심

`vite.config.js`의 핵심 부분(verbatim):

```js
export default defineConfig({
  base: './',
  plugins: [
    suppressLbcLwcLoggerNoisePlugin(),
    resolveIconTemplatesPlugin(),
    lwc({
      modules: [
        {
          dir: path.resolve('./src/modules'),
        },
        {
          name: '@salesforce/gate/bc.260.enableComboboxElementInternals',
          path: path.resolve('./src/build/shim/gateComboboxElementInternalsClosed.js'),
        },
        {
          npm: 'lightning-base-components',
        },
      ],
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
    }),
  ],
  // ...
  appType: 'spa',
  server: {
    port: 3000,
    open: false,
  },
  optimizeDeps: {
    exclude: ['lightning/modal', 'lightning/toast', 'lightning/toastContainer', 'lightning/showToastEvent', 'lightning/primitiveOverlay', 'lightning/overlayUtils', 'lightning/modalBase', 'lightning/utilsPrivate'],
  },
  resolve: {
    alias: {
      '@salesforce-ux/design-system': path.resolve('./node_modules/@salesforce-ux/design-system'),
      '@salesforce-ux/design-system-2': path.resolve('./node_modules/@salesforce-ux/design-system-2'),
      ...iconTemplateAliases,
    },
  },
});
```

### 읽는 법

- **`lwc({ modules })`** — LWC 모듈 해석 경로 3개: ① `./src/modules`(앱 코드, 폴더=네임스페이스), ② gate shim(`@salesforce/gate/bc.260.enableComboboxElementInternals` → `src/build/shim/gateComboboxElementInternalsClosed.js`), ③ npm의 `lightning-base-components`.
- **`disableSyntheticShadowSupport: false`** — 합성 섀도우 **켜짐**(기본). 네이티브 섀도우로 전환하려면 `true`로. (검증: 콘솔에서 `document.querySelector('shell-app').shadowRoot`가 `null`이면 합성 섀도우 활성.)
- **`enableDynamicComponents: true`** — `lwc:dynamic`/동적 컴포넌트 지원(라우터가 `page-*`를 동적으로 렌더하기 위함).
- **`exclude`** — LWC 플러그인 파이프라인을 **우회**시킬 대상: `index.html`, `loading.css`, `src/build/generated`, 전역 SLDS CSS(`salesforce-lightning-design-system.min.css`·`slds2.cosmos.css`) 및 `styles/global.css`. 주석에 명시되듯 **합성 섀도우가 켜지면 LWC가 이 파이프라인에서 `:root`를 거부**하므로 전역 CSS(`new URL()`로 로드)는 반드시 통과시키면 안 된다. 아이콘 템플릿 디렉터리(`iconTemplateExcludeDirs`)도 제외.
- **`optimizeDeps.exclude`** — `lightning/modal`·`toast`·`overlay` 계열 등 8개 모듈을 Vite 의존성 사전 번들에서 제외.
- **`resolve.alias`** — `@salesforce-ux/design-system{,-2}`를 로컬 `node_modules`로 별칭(전역 SLDS CSS를 `new URL()`로 정확히 가리키기 위함) + `iconTemplateAliases`(`lightning/iconSvgTemplates*` → shim).
- **커스텀 플러그인 2개:**
  - `suppressLbcLwcLoggerNoisePlugin()` — `node_modules/lightning-base-components/` 경로에서 나오는 LWC logger 경고를 억제(LBC가 출하하는 템플릿이 다수의 LWC 진단을 트리거하지만 앱 코드로는 못 고침). 빌드 시 `rollupOptions.onwarn`도 동일 경로 경고를 무시.
  - `resolveIconTemplatesPlugin()` — `lightning/iconSvgTemplates*`를 shim 모듈로 해석.

> 합성 섀도우 vs 네이티브 섀도우의 전환·동작 차이 표는 [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]] 및 [[LWC Shadow DOM 모드]] 참조.

---

## 7. 컨벤션 위계: Lightning Base Components > SLDS 유틸리티 클래스 > 스타일링 훅

이 프로젝트는 SLDS·LWC 모범 사례를 따르며, 커스터마이징 시 **선호 순서**가 정해져 있다. README "Conventions and design system" 원문:

> *"prefer Lightning Base Components, then SLDS utility classes, then styling hooks for customisation."*

즉:

```
1순위  Lightning Base Components (lightning-*)
2순위  SLDS 유틸리티 클래스 (slds-*)
3순위  스타일링 훅 (styling hooks)  ← 커스터마이징용
```

### AGENTS.md "Engineering habits" (핵심 원문)

- UI 작업은 **`.agent/skills/afv-library/applying-slds/SKILL.md`를 먼저 읽는다.**
- **"Prefer Lightning Base Components over hand-rolled SLDS markup."** — 만들려는 것에 해당하는 `lightning-*` 컴포넌트가 있으면, 기억으로 `slds-*` 블루프린트를 재구성하지 말고 그걸 쓴다 (예: `slds-card`가 아니라 `lightning-card`, `slds-button`이 아니라 `lightning-button`, `slds-icon`이 아니라 `lightning-icon`). 어떤 베이스 컴포넌트도 커버하지 못할 때만 블루프린트를 직접 만들고, 그럴 땐 그 사실을 밝힌다.
- 작고 단일 책임인 LWC와 읽기 쉬운 구조를 선호.
- **`!important` 사용 금지.**
- **인라인 `style` 속성 금지** — 유틸리티 클래스나 컴포넌트의 CSS 파일을 쓴다.

### AGENTS.md "Where to put code" (요약)

- **Route-level views**: `src/modules/page/<name>/` → 태그 `page-<name>`. `routes.config.js`에 라우트 추가 후 `shell/app/app.js`의 `ROUTE_COMPONENTS`에 import·등록. 라우터가 신규 라우트를 자동 인식하므로 `router.js`는 편집 불필요.
- **Reusable UI / SLDS blueprints**: `src/modules/ui/<name>/` → 태그 `ui-<name>`.
- **App shell**: `src/modules/shell/<name>/` → 태그 `shell-*`.
- **금지**: `src/build/lightning-icon/shims/`에 체크인된 아이콘 오버라이드 외 컴포넌트 추가, `src/modules/lightning/` 추가.

> 폼(`lightning-input` 등)·모달(`lightning/modal` 확장) 컨벤션과 SLDS 린터(`npx @salesforce-ux/slds-linter@latest lint`) 사용은 [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]] 참조. SLDS 디자인 원칙 일반은 [[SLDS 모범 사례]]·[[SLDS LWC 디자인 시스템]] 참조.

---

## 8. 새 페이지/컴포넌트 추가법 (Using this as a template)

README "Using this as a template" 단계(원문 기준):

1. 레포를 clone/copy → `npm install` → `npm run dev`.
2. **페이지 추가:** `src/modules/page/<name>/` 폴더 생성 후:
   - `src/routes.config.js`에 라우트 추가 (예: `{ path: '/dashboard', component: 'page-dashboard', title: 'Dashboard', navPage: 'dashboard', navLabel: 'Dashboard' }`).
   - `src/modules/shell/app/app.js`에서 컴포넌트를 import하고 `ROUTE_COMPONENTS`에 추가. **그게 전부** — `src/router.js`는 편집 불필요.
   - 기존 탭 아래 자식 라우트(예: `/contacts/:id`)는 `navPage` 대신 `navHighlight: '<parentNavPage>'`를 써서 새 nav 항목을 만들지 않고 부모 탭만 강조.
3. **재사용 컴포넌트 추가:** `src/modules/ui/<name>/` 폴더 생성 → 어느 페이지/컴포넌트에서든 `<ui-<name>>`로 사용.
4. 위 네임스페이스 규칙과 SLDS/LWC 컨벤션(예: `.cursor/rules`가 있으면 그것)을 따른다.

```js
// 구조 예시 — 실제 동작 코드 아님 (README 인용 형태의 라우트 엔트리)
{ path: '/dashboard', component: 'page-dashboard', title: 'Dashboard', navPage: 'dashboard', navLabel: 'Dashboard' }
```

> `routes.config.js`의 필드(`navPage`/`navHighlight`/`navPath`/path params)와 `apps.config.js`(Standard/Console)의 라우팅 메커니즘 상세는 [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]] 참조. 모달은 `lightning/modal` 확장 + `src/modules/ui/demoModal/` 참조 → [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]].

---

## 9. AI 도구 (Salesforce DX MCP)

프로젝트에는 **AI 보조 개발용 `mcp.json`** 이 포함돼 [Salesforce DX MCP server](https://www.npmjs.com/package/@salesforce/mcp)를 자동 구성한다. MCP를 지원하는 에디터(Claude Code, Cursor, Copilot이 있는 VS Code 등)가 이를 자동 인식해 Salesforce 특화 코드 분석·LWC 가이드 도구에 접근한다. 별도 셋업 불필요 — 서버는 `npx`로 on-demand 실행.

`mcp.json` (verbatim):

```json
{
  "mcpServers": {
    "SalesforceDX": {
      "type": "stdio",
      "command": "npx",
      "args": [ "-y", "@salesforce/mcp@latest", 
                "--orgs", "ALLOW_ALL_ORGS",
                "--toolsets", "code-analysis,lwc-experts",
                "--tools", "guide_design_general,guide_figma_to_lwc_conversion",
                "--allow-non-ga-tools"]
    }
  }
}
```

### Agent skills (layout)

- **`.agent/skills/afv-library/`** — [`forcedotcom/afv-library`](https://github.com/forcedotcom/afv-library)(`develop`)의 선별 skill이 **`npm install` 시 복사**됨(gitignore). `npm run skills:sync`로 갱신.
- **`.agent/skills/<skill-id>/`** — 이 프로젝트가 출하하는 skill.

AGENTS.md의 skill 표(원문):

| Skill | When to use |
|---|---|
| `applying-slds` | SLDS 기반 UI 기본: 블루프린트·훅·유틸리티·아이콘·LBC 선택 |
| `uplifting-components-to-slds2` | SLDS 1→2 마이그레이션·린터 위반·hook/token 교체 |
| `validating-slds` | 컴플라이언스 감사 또는 점수화 품질 리포트 (UI 구현/수정용 아님) |
| `repo-setup` | GitHub 레포 셋업: origin remote에서 host 감지, 사전요건, 레포 생성, 최초 push |
| `first-time-deploy` | GitHub Pages 게시. 재배포는 `npm run deploy`만; 최초엔 repo-setup 후 배포·Pages 구성 |

> **LWC troubleshooting:** AGENTS.md는 Salesforce DX MCP를 `@api`/`@wire`/lifecycle/events/org-only 동작 등 **LWC 프레임워크·Salesforce 플랫폼 이슈에만 선택적으로** 쓰라고 명시한다.

---

## 관련 노트
- [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]]
- [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]]
- [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]]
- [[SLDS 2 Starter Kit - 셸 UI 컴포넌트]]
- [[SLDS 2 Starter Kit - UI 코딩 가이드라인]]
- [[SLDS 2 Starter Kit - 빌드 설정과 진입 HTML]]
- [[SLDS 2 Starter Kit - 저장소 설정과 배포 스킬]]
- [[SLDS LWC 디자인 시스템]]
- [[SLDS 모범 사례]]
- [[LWC Shadow DOM 모드]]
