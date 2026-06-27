---
tags: [slds, starter-kit, lwc, routing, spa, multi-app, history-api]
source: salesforce-ux/design-system-2-starter-kit (GitHub, 공식 Salesforce UX)
created: 2026-06-26
aliases: [SLDS 2 Starter Kit 라우팅, LWC 클라이언트 라우터, routes.config.js, apps.config.js, Standard Console 앱, ROUTE_COMPONENTS, navHighlight, LWC SPA 라우팅]
---

# SLDS 2 Starter Kit - 라우팅과 멀티앱 셸

> SLDS 2 Starter Kit의 클라이언트 사이드 라우터 + 멀티앱 셸: **logical 라우트 → 앱 prefix → 셸 outlet** 3계층으로, 서버·LWR 없이 History API만으로 SPA 라우팅을 구현한다.

---

## 1. 3계층 아키텍처 (routes → apps → shell)

이 스타터킷은 **순수 클라이언트 사이드 라우터 + 멀티앱 셸**을 LWC로 구현한다. 서버 라우팅이나 LWR 없이 History API(`pushState`/`replaceState`/`popstate`)만으로 동작한다.

| 계층 | 파일 | 역할 |
|---|---|---|
| **routes** | `src/routes.config.js` | URL 패턴 → LWC 컴포넌트 매핑. **logical(앱 prefix 없는) 경로** 사용 |
| **apps** | `src/apps.config.js` | routes 위 계층. URL prefix(`/app`, `/console`, `/builder`)로 라우트 집합을 scope. 라우터가 진입/진출 시 active app의 prefix를 strip/prepend |
| **shell** | `src/modules/shell/app/` | 라우트 outlet + 전역 chrome(헤더·내비) 렌더링, 라우트 구독, 컴포넌트 등록 |

핵심 분리 원칙: **라우트는 항상 logical(un-prefixed) 경로로 정의**되고, 라우터가 active app의 prefix를 들어올 때 떼고(strip) 나갈 때 붙인다(prepend). 그래서 같은 라우트 정의가 여러 앱에서 재사용된다.

`src/router.js` 파일 헤더 주석 (verbatim):

```js
// src/router.js (lines 1-9)
/**
 * Mini router for LWC – declarative routes, dynamic params, History API.
 * No page refresh; back/forward supported.
 * Routes are defined in routes.config.js; apps (URL prefixes that scope a set
 * of routes) are defined in apps.config.js.
 *
 * Production `vite build` uses pathname + pushState. `vite build --mode gh-pages`
 * (npm run build:gh-pages) uses hash URLs (#/path) for static hosts like GitHub Pages.
 */
```

---

## 2. `src/router.js` — Mini Router

### 2-1. Exported API (전수)

| Export | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `setCurrentAppForLinks` | `(appId)` | void | 모듈 레벨 `_currentAppId` 갱신(유효한 appId일 때만). `linkHref`/`navigate`가 logical 경로에 어떤 app prefix를 붙일지 결정하는 캐시. shell-app이 매 네비게이션마다 동기화 |
| `linkHref` | `(logicalPath, appId?)` | `string` | anchor `href` 생성. logicalPath에 이미 알려진 app prefix가 있으면 유지, 없으면 active app(또는 인자 appId)의 prefix를 prepend. HASH_MODE면 `#/...` 형태로 변환 |
| `navigate` | `(path)` | void | 프로그램적 이동. 경로 정규화 → app prefix 보정 → 현재 경로와 같으면 no-op → `writeUrl`(pushState) → `notify()` |
| `getCurrentRoute` | `()` | route 객체 \| null | 현재 logical 경로를 `matchRoute`로 매칭한 결과 반환 |
| `subscribe` | `(callback)` | unsubscribe 함수 | 리스너 등록. 등록 즉시 초기 라우트로 콜백 1회 호출(+ no-prefix면 defaultPath로 replace 리다이렉트). 반환된 함수 호출 시 리스너 제거 |

### 2-2. 내부 함수·상수 (non-exported)

| 이름 | 종류 | 설명 |
|---|---|---|
| `DEFAULT_TITLE` | const | `'Salesforce'` |
| `HASH_MODE` | const | `import.meta.env.VITE_ROUTER_MODE === 'hash'` — gh-pages 빌드에서 true |
| `listeners` | const | `new Set()` — 구독 콜백 집합 |
| `_currentAppId` | let | 모듈 레벨 active app 캐시. 초기값 `getPersistedAppId()` |
| `getActiveAppForBuild()` | fn | `getAppById(_currentAppId)` 또는 fallback `getAppById(DEFAULT_APP_ID)` |
| `normalizeLogicalPath(path)` | fn | `/`로 시작 보장 + 루트 외 trailing slash 제거 |
| `getLogicalPath()` | fn | HASH_MODE면 `window.location.hash`(`#/...`)에서, 아니면 `window.location.pathname`에서 logical 경로 추출. hash의 `?query`는 제거 |
| `hashUrlFromLogicalPath(logicalPath)` | fn | logical → `#/body` 변환 |
| `writeUrl(logicalPath, replace=false)` | fn | `history.pushState` 또는 `history.replaceState` 호출 |
| `matchRoute(path)` | fn | 핵심 매칭 (아래 상세) |
| `getTitleForRoute(route)` | fn | route.title이 함수면 `title(params)`, 문자열이면 그대로, 없으면 DEFAULT_TITLE |
| `notify()` | fn | 현재 경로 매칭 → document.title 설정 → 모든 리스너 호출. no-prefix면 defaultPath로 replace 후 재귀 |

### 2-3. 경로 파라미터 파싱 / 라우트 매칭 — `matchRoute`

동적 세그먼트(`/contacts/:id`)는 정규식 `/:([^/]+)/g`로 찾아 캡처 그룹 `([^/]+)`로 치환하고, 파라미터명을 `keys` 배열에 모아 매칭 후 `params` 객체로 만든다.

```js
// src/router.js (lines 108-137)
function matchRoute(path) {
  const app = getAppForPath(path);
  if (!app) return null;
  const subPath = stripAppPrefix(path, app);

  const candidates = [
    ...routes.filter((r) => r.app === app.id),
    ...routes.filter((r) => !r.app),
  ];

  for (const route of candidates) {
    const keys = [];
    const pattern = route.path.replace(/:([^/]+)/g, (_match, paramName) => {
      keys.push(paramName);
      return '([^/]+)';
    });

    const regex = new RegExp(`^${pattern}$`);
    const match = subPath.match(regex);

    if (match) {
      const params = {};
      keys.forEach((paramKey, i) => (params[paramKey] = match[i + 1]));

      return { ...route, params, app: app.id };
    }
  }

  return null;
}
```

- **app prefix를 먼저 떼고(`stripAppPrefix`) subPath로 매칭**한다. URL에 app prefix가 없으면(`getAppForPath` null) `null` 반환.
- **candidates 우선순위:** 현재 app에 묶인 라우트(`r.app === app.id`)가 먼저, 그다음 app-agnostic 라우트(`!r.app`). 즉 app별 라우트가 공용 라우트보다 우선 매칭.
- 반환 형태: `{ ...route, params, app: app.id }` — 원본 라우트 + 추출된 `params` + 매칭된 `app` id.

### 2-4. navigate / getCurrentRoute / subscribe

```js
// src/router.js (lines 174-205)
export function navigate(path) {
  const normalized = normalizeLogicalPath(path);
  const existingApp = getAppForPath(normalized);
  const logical = existingApp
    ? normalized
    : withAppPrefix(normalized, getActiveAppForBuild());
  if (logical === getLogicalPath()) {
    return;
  }
  writeUrl(logical);
  notify();
}

export function getCurrentRoute() {
  return matchRoute(getLogicalPath());
}

export function subscribe(callback) {
  listeners.add(callback);
  // Mirror notify()'s redirect-on-no-prefix behavior on first subscribe so a
  // direct hit on "/" lands on a real app URL before any listener runs.
  const initialPath = getLogicalPath();
  if (!getAppForPath(initialPath)) {
    writeUrl(getActiveAppForBuild().defaultPath, /* replace */ true);
  }
  const route = matchRoute(getLogicalPath());
  document.title = getTitleForRoute(route);
  if (route?.app) _currentAppId = route.app;
  callback(route);

  return () => listeners.delete(callback);
}
```

- `navigate`: logical 경로에 app prefix가 없으면 active app prefix를 붙이고, **현재 경로와 같으면 no-op**(중복 push 방지). 그 외엔 `pushState` 후 `notify()`.
- `subscribe`: 등록 직후 **현재 URL에 app prefix가 없으면**(bare `/` 직접 진입) active app의 `defaultPath`로 `replaceState` 리다이렉트한 뒤, 초기 라우트로 콜백을 1회 호출하고 unsubscribe 함수를 반환.

### 2-5. `notify` — no-prefix 리다이렉트 로직

```js
// src/router.js (lines 146-172)
function notify() {
  const path = getLogicalPath();
  const app = getAppForPath(path);

  // No app prefix on the URL (bare "/" or anything else): redirect into the
  // last-used app and re-evaluate.
  if (!app) {
    const target = getActiveAppForBuild().defaultPath;
    if (!getAppForPath(target)) {
      console.error(
        `[router] defaultPath "${target}" does not match any app prefix. Check apps.config.js.`
      );
      return;
    }
    writeUrl(target, /* replace */ true);
    return notify();
  }

  // Keep the module-level cache in sync with the URL so subsequent linkHref
  // calls produced before shell-app's subscribe handler runs use the right
  // prefix.
  _currentAppId = app.id;

  const route = matchRoute(path);
  document.title = getTitleForRoute(route);
  listeners.forEach((listener) => listener(route));
}
```

URL에 app prefix가 없으면 last-used app의 `defaultPath`로 `replaceState` 후 자기 자신을 재귀 호출해 다시 평가한다. prefix가 있으면 `_currentAppId`를 URL과 동기화하고 모든 리스너를 호출.

### 2-6. `writeUrl` (History API) + popstate/hashchange 바인딩

```js
// src/router.js (lines 76-83)
function writeUrl(logicalPath, replace = false) {
  const url = HASH_MODE ? hashUrlFromLogicalPath(logicalPath) : logicalPath;
  if (replace) {
    history.replaceState({}, '', url);
  } else {
    history.pushState({}, '', url);
  }
}
```

```js
// src/router.js (lines 207-210)
window.addEventListener('popstate', notify);
if (HASH_MODE) {
  window.addEventListener('hashchange', notify);
}
```

- 뒤로/앞으로 가기 → `popstate` → `notify()` → 리스너 재호출.
- HASH_MODE(gh-pages)에서는 추가로 `hashchange`도 구독.

### 2-7. `linkHref`

```js
// src/router.js (lines 93-106)
export function linkHref(logicalPath, appId) {
  const path = normalizeLogicalPath(logicalPath);
  const existingApp = getAppForPath(path);
  const finalPath = existingApp
    ? path
    : withAppPrefix(
        path,
        (appId && getAppById(appId)) || getActiveAppForBuild()
      );
  if (!HASH_MODE) {
    return finalPath;
  }
  return hashUrlFromLogicalPath(finalPath);
}
```

anchor의 `href` 생성용. 이미 app prefix가 있으면 유지, 없으면 인자 `appId`(있으면) 또는 active app의 prefix를 붙인다. 이 href는 접근성/우클릭 복사/새 탭 열기용 실제 URL이며, 실제 클릭은 `preventDefault`로 막고 SPA `navigate`로 처리된다.

---

## 3. `src/routes.config.js` — 라우트 정의

전체 파일 (verbatim):

```js
// src/routes.config.js
/**
 * Single source of truth for app routes.
 * Consumed by router.js (matching, titles) and app (nav maps, nav items).
 *
 * Fields:
 *   path       - URL pattern (use :param for dynamic segments). Logical, no app prefix.
 *   component  - LWC component name (must be registered in app.js ROUTE_COMPONENTS)
 *   title      - Document title (string or (params) => string)
 *   navPage    - Id for nav active state and navigate({ page }) (omit to hide from nav)
 *   navLabel   - Label shown in nav bar and in the Console object switcher
 *   navPath    - Optional; for dynamic routes, path used in nav links (e.g. /users/42)
 *   navHighlight - Optional; nav page id to highlight when this route is active (for child routes that don't create a tab)
 */

export const routes = [
  {
    path: '/',
    component: 'page-home',
    title: 'Home',
    navPage: 'home',
    navLabel: 'Home',
  },
  {
    path: '/icons',
    component: 'page-icon-test',
    title: 'Icons',
    navPage: 'icons',
    navLabel: 'Icons',
  },
  {
    path: '/contacts',
    component: 'page-contacts',
    title: 'Contacts',
    navPage: 'contacts',
    navLabel: 'Contacts',
  },
  {
    path: '/contacts/:id',
    component: 'page-contact-detail',
    title: (params) => `Contact ${params.id}`,
    navHighlight: 'contacts',
  },
  {
    path: '/',
    component: 'page-builder',
    title: 'Builder',
    app: 'builder',
  },
];
```

### 라우트 필드 스키마 (주석 verbatim)

| 필드 | 필수/선택 | 의미 |
|---|---|---|
| `path` | 필수 | URL 패턴(`:param`로 동적 세그먼트). **Logical, app prefix 없음** |
| `component` | 필수 | LWC 컴포넌트 이름 (반드시 app.js `ROUTE_COMPONENTS`에 등록) |
| `title` | 필수 | 문서 타이틀. 문자열 또는 `(params) => string` 함수 |
| `navPage` | 선택 | nav active 상태/`navigate({page})`용 id. **생략하면 nav에서 숨김** |
| `navLabel` | 선택 | nav 바 및 Console object switcher에 표시되는 라벨 |
| `navPath` | 선택 | 동적 라우트의 nav 링크용 경로(예: `/users/42`) |
| `navHighlight` | 선택 | 이 라우트 활성 시 하이라이트할 nav page id (탭을 만들지 않는 자식 라우트용) |
| `app` | 선택 | (스키마 주석엔 없으나 데이터에 존재) 이 라우트를 특정 app에 묶음. `matchRoute`의 candidates 우선순위·`subscribe`/`notify`의 app 전환에 사용 (예: builder 라우트의 `app: 'builder'`) |

### 정의된 실제 라우트 (전수 5개)

| # | path | component | title | navPage | navLabel | navHighlight | app |
|---|---|---|---|---|---|---|---|
| 1 | `/` | `page-home` | `'Home'` | `home` | `Home` | — | — |
| 2 | `/icons` | `page-icon-test` | `'Icons'` | `icons` | `Icons` | — | — |
| 3 | `/contacts` | `page-contacts` | `'Contacts'` | `contacts` | `Contacts` | — | — |
| 4 | `/contacts/:id` | `page-contact-detail` | <code>(params) => &#96;Contact ${params.id}&#96;</code> | — | — | `contacts` | — |
| 5 | `/` | `page-builder` | `'Builder'` | — | — | — | `builder` |

> 같은 `path: '/'`가 두 번 등장하지만(home, builder), 두 번째는 `app: 'builder'`로 묶여 있어 builder app prefix(`/builder`)에서만 매칭된다. `matchRoute`가 app별 candidates를 먼저 필터링하므로 충돌하지 않는다.

---

## 4. navPage vs navHighlight

두 필드 모두 "어떤 nav 탭을 active로 보일지"에 관여하지만 역할이 다르다.

| 필드 | 탭 생성 | active 하이라이트 대상 | 용도 |
|---|---|---|---|
| `navPage` | **생성함** (nav 탭/메뉴 항목을 만듦) | 자기 자신 탭 | 정상 페이지(`/contacts` → Contacts 탭). `navigate({page})`의 타겟 id이며 `NAV_PAGE_TO_PATH`/`NAV_PAGE_TO_ROUTE`/`navItems`에 들어감 |
| `navHighlight` | **생성 안 함** | 다른(부모) 탭 | 자식/디테일 라우트(`/contacts/:id`)가 탭을 만들지 않으면서도 부모 탭(`contacts`)을 active 표시 |

연결 메커니즘: app.js의 `ROUTE_TO_NAV_PAGE`가 **`r.navPage ?? r.navHighlight`**로 두 필드를 통합해 "현재 어떤 탭을 active로 보일지"를 계산한다(아래 §5-2). 그래서 `/contacts/:id`(디테일 페이지)에 있을 때 nav의 "Contacts" 탭이 active로 표시된다 — 디테일 페이지 자체는 탭을 만들지 않는다.

---

## 5. `src/apps.config.js` — 멀티앱 셸 정의

### 5-1. 전체 파일 (verbatim) — apps 배열 + 헬퍼

```js
// src/apps.config.js
/**
 * Single source of truth for "apps" — a layer above routes.
 *
 * Each app declares:
 *   id          - Stable identifier used in storage and events
 *   label       - Display name shown in the App Launcher (waffle)
 *   variant     - Navigation layout: "standard" (tabs) or "console" (object switcher)
 *   pathPrefix  - URL prefix that scopes the app's routes (e.g. /app, /console)
 *   defaultPath - Where to land when the app is opened from the App Launcher
 *   pages       - Ordered list of navPage ids (from routes.config.js) the app
 *                 surfaces in its primary navigation. Pages can be shared
 *                 across multiple apps.
 *
 * Routes themselves stay in routes.config.js with logical (un-prefixed) paths;
 * the router strips/prepends the active app's prefix on the way in/out.
 */

export const APP_STORAGE_KEY = 'shell-current-app';

export const apps = [
  {
    id: 'standard',
    label: 'Standard App',
    variant: 'standard',
    pathPrefix: '/app',
    defaultPath: '/app',
    pages: ['home', 'icons', 'contacts'],
  },
  {
    id: 'console',
    label: 'Console App',
    variant: 'console',
    pathPrefix: '/console',
    defaultPath: '/console',
    pages: ['home', 'icons', 'contacts'],
  },
  {
    id: 'builder',
    label: 'Builder',
    variant: 'builder',
    pathPrefix: '/builder',
    defaultPath: '/builder',
    pages: [],
  },
];

export const DEFAULT_APP_ID = 'standard';

export function getAppById(id) {
  return apps.find((a) => a.id === id) ?? null;
}

/**
 * Find which app owns a logical path by longest matching prefix.
 * Returns null if no app prefix matches (e.g. bare "/").
 */
export function getAppForPath(logicalPath) {
  if (!logicalPath) return null;
  const sorted = [...apps].sort(
    (a, b) => b.pathPrefix.length - a.pathPrefix.length
  );
  for (const app of sorted) {
    if (
      logicalPath === app.pathPrefix ||
      logicalPath.startsWith(`${app.pathPrefix}/`)
    ) {
      return app;
    }
  }
  return null;
}

/** Strip an app's prefix off a logical path. Returns "/" for the bare prefix. */
export function stripAppPrefix(logicalPath, app) {
  if (!app) return logicalPath;
  if (logicalPath === app.pathPrefix) return '/';
  if (logicalPath.startsWith(`${app.pathPrefix}/`)) {
    return logicalPath.slice(app.pathPrefix.length);
  }
  return logicalPath;
}

/** Prepend an app's prefix to a logical path. "/" becomes the bare prefix. */
export function withAppPrefix(logicalPath, app) {
  if (!app) return logicalPath;
  if (logicalPath === '/' || !logicalPath) return app.pathPrefix;
  return `${app.pathPrefix}${logicalPath}`;
}

/** Last-used app id from localStorage, or DEFAULT_APP_ID. */
export function getPersistedAppId() {
  try {
    const stored = localStorage.getItem(APP_STORAGE_KEY);
    return stored && getAppById(stored) ? stored : DEFAULT_APP_ID;
  } catch {
    return DEFAULT_APP_ID;
  }
}

export function persistAppId(id) {
  try {
    localStorage.setItem(APP_STORAGE_KEY, id);
  } catch {
    /* storage unavailable; non-fatal */
  }
}
```

### 5-2. Exported symbols + 헬퍼 함수 (전수)

| Export | 종류 | 값/시그니처 | 설명 |
|---|---|---|---|
| `APP_STORAGE_KEY` | const | `'shell-current-app'` | localStorage 키 (active app 저장) |
| `apps` | const array | (아래 표) | 앱 정의 배열 |
| `DEFAULT_APP_ID` | const | `'standard'` | 기본 앱 |
| `getAppById(id)` | fn | → app \| null | id로 앱 조회 |
| `getAppForPath(logicalPath)` | fn | → app \| null | **가장 긴 매칭 prefix**로 경로 소유 앱 결정. 매칭 없으면 null (예: bare `/`) |
| `stripAppPrefix(logicalPath, app)` | fn | → string | 앱 prefix 제거. bare prefix면 `/` 반환 |
| `withAppPrefix(logicalPath, app)` | fn | → string | 앱 prefix 추가. `/`는 bare prefix가 됨 |
| `getPersistedAppId()` | fn | → string | localStorage의 마지막 앱 또는 DEFAULT_APP_ID (try/catch로 storage 불가 시 fallback) |
| `persistAppId(id)` | fn | void | localStorage에 앱 id 저장 (storage 불가 시 non-fatal) |

> **`getAppForPath`의 longest-prefix 매칭:** `pathPrefix.length` 내림차순 정렬 후 첫 매칭을 반환한다. 조건은 `logicalPath === pathPrefix || startsWith(`${pathPrefix}/`)`. 단순 `startsWith`로는 `/app`이 `/application`을 잘못 매칭할 수 있어, `/app/` 경계로 정확히 구분한다.

### 5-3. 정의된 앱 (전수 3개)

| id | label | variant | pathPrefix | defaultPath | pages |
|---|---|---|---|---|---|
| `standard` | `Standard App` | `standard` (탭) | `/app` | `/app` | `['home', 'icons', 'contacts']` |
| `console` | `Console App` | `console` (object switcher) | `/console` | `/console` | `['home', 'icons', 'contacts']` |
| `builder` | `Builder` | `builder` | `/builder` | `/builder` | `[]` (빈 배열 = 전역 nav 없음) |

app 필드 의미 (주석 verbatim 요약): `id`(storage·event용 안정 식별자), `label`(App Launcher/waffle 표시명), `variant`(nav 레이아웃 — `standard` 탭 / `console` object switcher / `builder`), `pathPrefix`(라우트 scope용 URL prefix), `defaultPath`(앱 열 때 착지 경로), `pages`(primary nav에 노출하는 navPage id의 순서 목록 — **여러 앱이 공유 가능**, standard·console이 동일한 3개 page 공유).

---

## 6. `src/modules/shell/app/app.js` — 셸 루트 / 라우트 outlet

### 6-1. ROUTE_COMPONENTS — "Option A: explicit registration"

```js
// src/modules/shell/app/app.js (lines 1-26)
import { LightningElement } from 'lwc';
import { subscribe, navigate, linkHref, setCurrentAppForLinks } from '../../../router';
import { routes } from '../../../routes.config';
import {
    apps,
    getAppById,
    getPersistedAppId,
    persistAppId,
    DEFAULT_APP_ID,
} from '../../../apps.config';
import { toggleSLDS, activeSLDSVersion, STORAGE_KEY_SLDS_VERSION } from '../../../build/slds-loader';
import Home from 'page/home';
import IconTest from 'page/iconTest';
import Contacts from 'page/contacts';
import ContactDetail from 'page/contactDetail';
import Builder from 'page/builder';
import NotFound from 'page/notFound';

/** Option A: explicit registration – add one import + one entry here when adding a route */
const ROUTE_COMPONENTS = {
    'page-home': Home,
    'page-icon-test': IconTest,
    'page-contacts': Contacts,
    'page-contact-detail': ContactDetail,
    'page-builder': Builder,
};
```

route를 추가할 때 (1) import 한 줄 + (2) 이 맵에 항목 한 줄을 추가한다(주석 verbatim "add one import + one entry here when adding a route"). `routes.config.js`의 `component` 문자열(`'page-home'` 등)이 이 맵의 키와 **정확히 일치**해야 하고, 값은 실제 LWC 클래스 생성자(`page/home` 모듈의 default export)다. `notFound`(`page/notFound`)는 ROUTE_COMPONENTS에 없고 fallback 전용으로 import만 된다.

### 6-2. routes.config에서 파생되는 nav 맵 3종

```js
// src/modules/shell/app/app.js (lines 28-41)
/** Derived from routes.config: component name → nav page id (includes navHighlight for child routes) */
const ROUTE_TO_NAV_PAGE = Object.fromEntries(
    routes.filter((r) => r.navPage || r.navHighlight).map((r) => [r.component, r.navPage ?? r.navHighlight])
);

/** Derived from routes.config: nav page id → path for navigate() */
const NAV_PAGE_TO_PATH = Object.fromEntries(
    routes.filter((r) => r.navPage).map((r) => [r.navPage, r.navPath ?? r.path])
);

/** Derived from routes.config: nav page id → full route entry (label, icon, etc.) */
const NAV_PAGE_TO_ROUTE = Object.fromEntries(
    routes.filter((r) => r.navPage).map((r) => [r.navPage, r])
);
```

| 맵 | 키 → 값 | 필터 | 비고 |
|---|---|---|---|
| `ROUTE_TO_NAV_PAGE` | component명 → navPage id | `navPage \|\| navHighlight` | **`navPage ?? navHighlight`** 로 navHighlight도 포함 → 자식 라우트가 부모 탭을 active로 표시 |
| `NAV_PAGE_TO_PATH` | navPage → `navPath ?? path` | `navPage`만 | `navigate()` 타겟 경로 |
| `NAV_PAGE_TO_ROUTE` | navPage → 전체 route 엔트리 | `navPage`만 | label 등 nav 항목 구성용 |

### 6-3. 주요 getter

```js
// src/modules/shell/app/app.js (lines 53-111 발췌)
    get componentCtor() {
        if (!this.route) return NotFound;
        const name = this.route.component;
        return ROUTE_COMPONENTS[name] ?? NotFound;
    }

    get currentNavPage() {
        const name = this.route?.component;
        return name ? (ROUTE_TO_NAV_PAGE[name] ?? 'home') : 'home';
    }

    /** Pages exposed in the current app's primary nav (Standard tabs). */
    get navItems() {
        const app = getAppById(this._currentApp) || getAppById(DEFAULT_APP_ID);
        return app.pages
            .map((pageId) => NAV_PAGE_TO_ROUTE[pageId])
            .filter(Boolean)
            .map((r) => {
                const path = r.navPath ?? r.path;
                return { page: r.navPage, label: r.navLabel, path, href: linkHref(path) };
            });
    }

    /** All apps for the App Launcher (waffle), with isCurrent flag and href to defaultPath. */
    get appItems() {
        return apps.map((a) => ({
            id: a.id,
            label: a.label,
            href: linkHref(a.defaultPath, a.id),
            isCurrent: a.id === this._currentApp,
        }));
    }
```

| getter | 반환 | 설명 |
|---|---|---|
| `componentCtor` | LWC 생성자 | `route` 없으면 `NotFound`. `ROUTE_COMPONENTS[name] ?? NotFound` — **라우트 outlet의 핵심** (`<lwc:component lwc:is={componentCtor}>`) |
| `currentNavPage` | string | 현재 component → navPage(`ROUTE_TO_NAV_PAGE`), 없으면 `'home'`. navHighlight 포함이라 디테일 페이지에서도 부모 탭 active |
| `currentApp` | string | `_currentApp` |
| `currentAppVariant` | string | 현재 앱의 variant, fallback `'standard'` |
| `isBuilderApp` | boolean | `variant === 'builder'` (셸 chrome 없이 builder 전체화면) |
| `navItems` | array | 현재 앱 `pages` 순서대로 → `{page, label, path, href}`. href는 `linkHref(path)` (Standard 탭 데이터) |
| `pagesInCurrentApp` | array | navItems + `isCurrent` 플래그 (Console object switcher 메뉴 데이터) |
| `appItems` | array | 모든 앱 → `{id, label, href: linkHref(defaultPath, id), isCurrent}` (App Launcher waffle 데이터) |

### 6-4. connectedCallback — 라우트 구독 패턴

```js
// src/modules/shell/app/app.js (lines 113-149)
    connectedCallback() {
        this._restorePreferences();
        this._sldsVersion = activeSLDSVersion();
        setCurrentAppForLinks(this._currentApp);
        this.unsubscribe = subscribe((route) => {
            this.route = route;
            const newApp = route?.app;
            if (newApp && newApp !== this._currentApp) {
                this._currentApp = newApp;
                persistAppId(newApp);
                setCurrentAppForLinks(newApp);
            }
            this._syncBuilderRootClass();
        });
    }

    _syncBuilderRootClass() {
        document.documentElement.classList.toggle('builder-active', this.isBuilderApp);
    }

    disconnectedCallback() {
        this.unsubscribe?.();
        document.documentElement.classList.remove('builder-active');
    }
```

콜백은 매 네비게이션마다 (1) `this.route = route` 설정 → reactive하게 `componentCtor` 재계산 → outlet이 새 page-* 컴포넌트 렌더, (2) `route.app`이 바뀌었으면 `_currentApp` 갱신 + `persistAppId` + `setCurrentAppForLinks`(앱 전환 동기화), (3) builder root class 토글. `disconnectedCallback`에서 `unsubscribe()` + builder class 제거.

### 6-5. 이벤트 핸들러 (라우팅/셸)

```js
// src/modules/shell/app/app.js (lines 168-208 발췌)
    handleNavNavigate(event) {
        const page = event.detail?.page;
        const path = page ? NAV_PAGE_TO_PATH[page] : '/';
        navigate(path);
    }

    handleAppSwitch(event) {
        const appId = event.detail?.app;
        const target = getAppById(appId);
        if (!target) return;
        this._currentApp = appId;
        persistAppId(appId);
        setCurrentAppForLinks(appId);
        navigate(target.defaultPath);
    }

    handleBuilderExit() {
        const target = getAppById(DEFAULT_APP_ID);
        if (!target) return;
        this._currentApp = target.id;
        persistAppId(target.id);
        setCurrentAppForLinks(target.id);
        navigate(target.defaultPath);
    }

    handleNavigateBack() {
        history.back();
    }
```

| 핸들러 | 트리거 | 동작 |
|---|---|---|
| `handleNavNavigate(event)` | `onnavigate` (nav 탭/메뉴 클릭) | `event.detail.page` → `NAV_PAGE_TO_PATH[page]` → `navigate(path)`. page 없으면 `/` |
| `handleAppSwitch(event)` | `onappswitch` (App Launcher 선택) | `event.detail.app` → 앱 조회 → `_currentApp` 갱신 + persist + setCurrentAppForLinks + `navigate(target.defaultPath)` |
| `handleBuilderExit()` | `onbuilderexit` (builder의 back) | DEFAULT_APP으로 복귀 + persist + `navigate(defaultPath)` |
| `handleNavigateBack()` | `onnavigateback` | `history.back()` |

> 테마/패널 핸들러(`handleToggleSLDS`/`handleToggleDarkMode`/`handlePanelSelect`/`handlePanelClose`)는 셸 chrome 영역이라 라우팅 외다. SLDS 1·2 로더 토글 메커니즘은 [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]] 참조.

---

## 7. 라우트 outlet — `app.html`

```html
<!-- src/modules/shell/app/app.html -->
<template>
    <template lwc:if={isBuilderApp}>
        <lwc:component lwc:is={componentCtor} onbuilderexit={handleBuilderExit}></lwc:component>
    </template>

    <template lwc:else>
    <!-- Global shell: top, edge to edge, height by content -->
    <shell-global-shell
        current-page={currentNavPage}
        nav-items={navItems}
        current-app-variant={currentAppVariant}
        app-items={appItems}
        pages-in-current-app={pagesInCurrentApp}
        onnavigate={handleNavNavigate}
        onappswitch={handleAppSwitch}
        onpanelselect={handlePanelSelect}>
    </shell-global-shell>

    <!-- Main content and docked panel -->
    <main class="app-body">
        <lightning-layout vertical-align="stretch" class="utility-full-height">
            <lightning-layout-item flexibility="auto" class="app-body__content-cell">
                <div class="app-body__scroll-wrapper">
                    <div class="app-main">
                        <div class="app-main__inner">
                            <!-- Router outlet -->
                            <lwc:component lwc:is={componentCtor} onnavigateback={handleNavigateBack}></lwc:component>
                        </div>
                        <shell-theme-switcher
                            slds-version={_sldsVersion}
                            dark-mode={_darkMode}
                            ontoggleslds={handleToggleSLDS}
                            ontoggledarkmode={handleToggleDarkMode}>
                        </shell-theme-switcher>
                    </div>
                </div>
            </lightning-layout-item>
            <lightning-layout-item class={panelClasses}>
                <shell-panel selected-panel={selectedPanel} onpanelclose={handlePanelClose}></shell-panel>
            </lightning-layout-item>
        </lightning-layout>
    </main>
    </template>
</template>
```

- **Router outlet = `<lwc:component lwc:is={componentCtor}>`** — LWC의 동적 컴포넌트 렌더. `componentCtor` getter가 매칭된 page-* 클래스를 반환하면 그 컴포넌트가 렌더된다.
- **두 가지 셸 모드 (branch):**
  - `isBuilderApp` (variant `builder`) → chrome 없이 **builder만 전체화면**, `onbuilderexit`로 종료.
  - 그 외 (`lwc:else`) → `shell-global-shell`(헤더+내비) + main outlet + docked panel의 **global-shell** 레이아웃.
- `shell-global-shell`로 전달되는 props: `current-page`, `nav-items`, `current-app-variant`, `app-items`, `pages-in-current-app`. 이벤트: `onnavigate`, `onappswitch`, `onpanelselect`.

---

## 8. 사용 예제 — 라우터 소비 패턴

**동적 라우트로 이동** (`src/modules/page/contacts/contacts.js`):

```js
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

**path param 읽기** (`src/modules/page/contactDetail/contactDetail.js`):

```js
    connectedCallback() {
        const route = getCurrentRoute();
        const id = route?.params?.id;
        if (id) {
            this.contact = getContactById(id);
        }
    }
    ...
    handleBackToList() {
        navigate('/contacts');
    }
```

`getCurrentRoute()`가 반환하는 객체의 `params.id`가 `matchRoute`에서 `/contacts/:id`의 `:id` 캡처값이다. `navigate('/contacts')`처럼 logical 경로만 넘기면 라우터가 active app prefix를 붙여준다(예: standard 앱이면 `/app/contacts`).

**NotFound 컴포넌트** (`src/modules/page/notFound/notFound.js`, verbatim 전체):

```js
import { LightningElement } from 'lwc';
import { navigate } from '../../../router';

export default class NotFound extends LightningElement {
    handleGoHome() {
        navigate('/');
    }
}
```

---

## 9. pathname 모드 vs hash 모드

라우터는 빌드 모드에 따라 두 가지 URL 형식을 쓴다. 분기 기준은 `HASH_MODE = import.meta.env.VITE_ROUTER_MODE === 'hash'`.

| 모드 | URL 형식 | 빌드 명령 | 이벤트 구독 |
|---|---|---|---|
| **pathname** (기본/프로덕션) | `/app/contacts` | `vite build` | `popstate` |
| **hash** (gh-pages) | `#/app/contacts` | `vite build --mode gh-pages` (`npm run build:gh-pages`) | `popstate` + `hashchange` |

설정 출처 (verbatim):

```
# .env.gh-pages
# Used only when building with: vite build --mode gh-pages (npm run build:gh-pages / deploy)
VITE_ROUTER_MODE=hash
```

- `package.json`의 `"build:gh-pages": "node scripts/prebuild-icons.mjs && vite build --mode gh-pages"`, `"deploy": "npm run build:gh-pages && gh-pages -d dist --nojekyll"`.
- hash 모드는 GitHub Pages 같은 **정적 호스트**에서 서버 사이드 URL 리라이트 없이 SPA를 호스팅하기 위한 것이다. `getLogicalPath`/`writeUrl`/`linkHref`가 모두 `HASH_MODE`를 분기해 `#/...` 형식으로 변환한다.

---

## 관련 노트
- [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]]
- [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]]
- [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]]
- [[SLDS 2 Starter Kit - 셸 UI 컴포넌트]]
- [[SLDS 2 Starter Kit - UI 코딩 가이드라인]]
- [[SLDS LWC 디자인 시스템]]
