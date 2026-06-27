---
tags: [slds, starter-kit, lwc, vite, config, runtime-flags, html, gitignore]
source: salesforce-ux/design-system-2-starter-kit (GitHub, 공식 Salesforce UX)
created: 2026-06-26
aliases: [lwc.config.json, lwcRuntimeFlags, ENABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE, gate shim, gateComboboxElementInternalsClosed, index.html 엔트리, loading.css, reveal on ready, gitignore, nvmrc, 스타터킷 거버넌스 파일]
---

# SLDS 2 Starter Kit - 빌드 설정과 진입 HTML

> SLDS 2 Starter Kit의 빌드/런타임 설정(`lwc.config.json`·게이트 심), 진입 HTML(`index.html`), 로딩 UX(`loading.css`의 reveal-on-ready), 무시 파일(`.gitignore`·`.nvmrc`)을 원문 그대로 정리하고, 클러스터가 다루지 않은 빌드/설정 관련 잔여 파일(순수 스타일·상태 파일)을 인벤토리로 기록한다.

이 노트는 SLDS 2 Starter Kit 클러스터의 **8번째(마지막)** 노트로, 노트 1~7이 다루지 않은 **빌드/설정 관련 잔여 파일**을 책임진다.

---

## lwc.config.json (LWC 런타임 플래그)

프로젝트 루트의 `lwc.config.json`은 OSS LWC 컴파일러/런타임 설정 파일이다. 전문은 다음 한 항목뿐이다.

```json
{
  "lwcRuntimeFlags": {
    "ENABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE": false
  }
}
```

- `lwcRuntimeFlags`는 LWC 엔진의 런타임 동작을 제어하는 플래그 묶음이다.
- `ENABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE: false` — 네이티브 커스텀 엘리먼트 라이프사이클을 **끈다**. 이 스타터킷은 **synthetic shadow** 모드로 동작하며, 이 플래그를 끄는 것이 synthetic shadow / SLDS 1·2 동시 로딩 환경과 짝을 이룬다. (synthetic shadow 및 로더 동작은 [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]] 참조)

> LWC 런타임 플래그 자체의 일반 개념·전체 플래그 목록은 [[LWC 런타임 Feature Flags]] 참조.

---

## 게이트 심 (gate shim)

`src/build/shim/gateComboboxElementInternalsClosed.js` 전문:

```js
export default { isOpen: () => false };
```

이 모듈은 LWC 모듈 `@salesforce/gate/bc.260.enableComboboxElementInternals`로 등록되는 **게이트 심**이다. `vite.config.js`의 `modules` 배열이 이 파일을 해당 LWC 모듈 이름에 매핑한다(원문):

```js
// vite.config.js — modules 항목 (발췌, 원문)
{
  name: '@salesforce/gate/bc.260.enableComboboxElementInternals',
  path: path.resolve('./src/build/shim/gateComboboxElementInternalsClosed.js'),
}
```

- `lightning-base-components`의 combobox 등이 `@salesforce/gate/bc.260.enableComboboxElementInternals` 게이트를 import해 `isOpen()`을 질의하는데, 스타터킷에서는 이 심이 항상 `isOpen: () => false`를 반환한다.
- 즉 combobox의 `elementInternals` 게이트를 **닫아둔다**(`isOpen === false`). base components가 그 신기능 경로를 타지 않도록 고정하는 빌드 타임 결정이다.

> `vite.config.js`의 `modules` 배열 전체 구성은 [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]] 참조.

---

## 진입 HTML (index.html)

프로젝트 루트 `index.html` 전문:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1" />
    <title>Salesforce</title>
    <link rel="icon" href="./images/salesforce.svg" type="image/svg+xml">
    <link rel="icon" href="./favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="./loading.css">
</head>
<body>
    <div id="app"></div>
    <div id="app-loading">Loading…</div>
    <script type="module" src="./src/index.js"></script>
</body>
</html>
```

- `<title>Salesforce</title>` + 파비콘 2종(`images/salesforce.svg` 우선, `favicon.ico` 폴백).
- `loading.css`를 head에서 일찍 로드해 첫 페인트부터 로딩 UX가 적용되게 한다(아래 섹션).
- `<div id="app">` — LWC 앱이 마운트되는 루트 노드.
- `<div id="app-loading">Loading…</div>` — 앱이 준비되기 전 표시되는 로딩 오버레이.
- `<script type="module" src="./src/index.js">` — ESM 진입점. Vite가 이 모듈을 번들/서빙한다.

> `src/index.js` → `bootstrap.js` → 앱 마운트로 이어지는 전체 엔트리 흐름은 [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]] 참조.

---

## 로딩 UX (loading.css) + reveal-on-ready

`public/loading.css` 전문:

```css
#app {
    opacity: 0;
}

#app.is-ready {
    opacity: 1;
}

#app-loading {
    display: none;
    position: fixed;
    inset: 0;
    place-items: center;
    font: 500 .875rem/1 system-ui, sans-serif;
    color: oklch(60% 0 0);
    animation: app-loading-fade-in .5s ease-in forwards;
}

#app:not(.is-ready) ~ #app-loading {
    display: grid;
}

@keyframes app-loading-fade-in {
    from { opacity: 0; }
    to { opacity: 1; }
}
```

동작 원리 (FOUC = Flash Of Unstyled Content 방지):

- `#app { opacity: 0 }` — 앱 루트는 **기본적으로 투명**하다. 스타일이 아직 로드되지 않은 상태가 화면에 노출되는 것을 막는다.
- `#app.is-ready { opacity: 1 }` — `is-ready` 클래스가 붙으면 비로소 보인다. 이 클래스는 부트스트랩 과정에서 **활성 SLDS 스타일시트가 로드 완료된 뒤** `bootstrap.js`가 `#app`에 추가한다.
- `#app:not(.is-ready) ~ #app-loading { display: grid }` — `#app`이 아직 `is-ready`가 아닌 동안에만 형제 선택자(`~`)로 로딩 오버레이를 `grid`로 띄운다. `is-ready`가 붙는 순간 이 규칙이 풀리며 오버레이는 다시 `display: none`(기본값)으로 사라진다.
- `#app-loading`은 `position: fixed; inset: 0`로 전체 화면을 덮고 `place-items: center`로 "Loading…" 텍스트를 중앙 정렬, `app-loading-fade-in` 키프레임으로 0.5s 페이드인한다.

> `is-ready`를 부여하는 `bootstrap.js`와 SLDS 스타일시트 로드 순서는 [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]] 참조.

---

## .gitignore / .nvmrc

`.gitignore` 전문:

```gitignore
# Dependencies
node_modules/

# Build
dist/
dist-ssr/
src/build/generated/

# Environment
.env
.env.*.local

# Cursor (local-only)
.cursor/commands/

# Claude (local-only)
.claude/settings.local.json

# Agent skills synced from afv-library
.agent/skills/afv-library/

# OS
.DS_Store

# Logs
*.log
```

주목할 무시 항목:

- `src/build/generated/` — **아이콘 코드젠 산출물**. `scripts/prebuild-icons.mjs` 등이 생성하는 결과물이라 추적하지 않는다. (아이콘 빌드 파이프라인은 [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]] 참조)
- `.agent/skills/afv-library/` — afv-library에서 **동기화되는 스킬**이므로 로컬 생성물로 무시한다. (스킬 동기화는 [[SLDS 2 Starter Kit - 저장소 설정과 배포 스킬]] 참조)
- `dist/`·`dist-ssr/` — 빌드 출력, `node_modules/` — 의존성, `.env*` — 환경 비밀, `.cursor/commands/`·`.claude/settings.local.json` — 에디터/에이전트 로컬 설정, `.DS_Store`·`*.log` — OS/로그 잡파일.

`.nvmrc` 전문:

```
20
```

- Node 20을 고정한다. `package.json`의 `engines` 의 `node >= 20` 요구와 짝을 이룬다(`nvm use` 시 자동으로 20 선택).

---

## 기타 파일 인벤토리 (빌드/설정 관련 잔여 파일)

아래는 노트 1~7과 위 섹션이 다루지 않은 **빌드/설정 관련 잔여 파일**(순수 스타일·상태 파일)을 기록한다.

> 표준 OSS 거버넌스 파일(LICENSE.txt·CODE_OF_CONDUCT.md·CONTRIBUTING.md·SECURITY.md·CODEOWNERS)과 바이너리 에셋(favicon.ico·salesforce.svg·avatar1.jpg)은 학습 가치가 낮아 위키화 대상에서 제외했다.

### 컴포넌트 CSS (순수 스타일 — 무엇을 스타일하는지 + 주요 기법)

| 파일 | 무엇을 스타일하는가 + 주요 기법 |
|---|---|
| `src/modules/shell/app/app.css` | 앱 루트 레이아웃 — flex column·100vh, 글로벌 셸 상단 고정(z-index)·`.app-body`만 스크롤, `--slds-g-color-surface-2` 배경 (SLDS 글로벌 스타일링 훅) |
| `src/modules/page/builder/builder.css` | 빌더 페이지 레이아웃 — flex column, `.builder-rail` 고정폭(`--slds-g-sizing-15`) |
| `src/modules/page/contactDetail/contactDetail.css` | 연락처 상세 — 2열 grid, lightning-card 본문 spacing 훅(`--slds-c-card-body-spacing-inline`) 오버라이드 |
| `src/modules/page/home/home.css` | 홈 페이지 — card spacing 훅, 스피너 데모 높이, `@media (min-width:48em)` 반응형 |
| `src/modules/page/iconTest/iconTest.css` | 아이콘 테스트 페이지 — `.page` max-width 컨테이너·헤더 flex 레이아웃, `--slds-g-spacing-*` 토큰 |
| `src/modules/shell/globalShell/globalShell.css` | 글로벌 셸 — `::before` 가상요소로 하단 그림자 오버레이(`--slds-g-shadow-2`, opacity 0.25) |
| `src/modules/ui/globalHeader/globalHeader.css` | 글로벌 헤더 — SLDS 컴포넌트 스타일링 훅 + `light-dark()`로 라이트/다크 아이콘·버튼 색 분기 |
| `src/modules/ui/globalNavigation/globalNavigation.css` | 글로벌 내비 탭 — 아이콘 accent 색(`--slds-g-color-accent-1`), `button[role="tab"]` 기본 스타일 리셋 |
| `src/modules/ui/pageHeader/pageHeader.css` | 페이지 헤더 — `:host { display: block }` (최소 레이아웃) |
| `src/modules/ui/homeIntro/homeIntro.css` | 홈 인트로 단계 — 단계 번호 타이포(font-scale/weight 토큰)·브랜드 링크/아이콘 색(`--slds-g-color-brand-base-50`) |
| `src/modules/ui/panel/panel.css` | 패널 — `:host` flex column 전체 높이 레이아웃 |

> `src/modules/shell/themeSwitcher/themeSwitcher.css`·`src/styles/global.css`는 이미 [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]]에서 본문 인용·설명했으므로 해당 노트로 위임한다.

### 상태(state) 파일

| 파일 | 역할 |
|---|---|
| `package-lock.json` | npm 의존성 잠금 파일 (자동 생성 상태, 미수록) |

---

## 관련 노트
- [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]]
- [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]]
- [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]]
- [[SLDS 2 Starter Kit - 저장소 설정과 배포 스킬]]
- [[LWC 런타임 Feature Flags]]
