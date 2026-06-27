---
tags: [agent-skill, sf-skills, experience, ui-bundle, frontend, react-shadcn-tailwind]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-frontend-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-ui-bundle-frontend-generate, UI Bundle UI 수정, react ui bundle frontend, appLayout shadcn tailwind, base-path routing, 페이지 컴포넌트 헤더 생성]
---

# experience-ui-bundle-frontend-generate — UI Bundle UI 수정 (페이지·컴포넌트·레이아웃·스타일링)

> 기존 UI bundle 앱의 페이지·컴포넌트·레이아웃·스타일링·네비게이션을 수정할 때 쓰는 스킬. appLayout.tsx 쉘, shadcn/ui, Tailwind CSS, Salesforce base-path routing, module 제약 등 프로젝트별 규약이 일반 지식을 override한다.

## 목적과 활성화 조건

**활성화(MUST):** 기존 앱의 시각/UI 변경을 위해 `uiBundles/*/src/` 아래 **어떤 파일이든** 편집하기 전에 — 페이지, 컴포넌트, 섹션, 레이아웃, 스타일링, 색상, 폰트, 네비게이션, 애니메이션, look-and-feel 변경. 프로젝트에 `appLayout.tsx`, `routes.tsx`, `src/pages/`, `src/components/`, `global.css`가 있을 때 활성화.

이 스킬 없이는 생성 코드가 잘못된 import를 쓰거나, routing을 깨뜨리거나, 프로젝트 구조를 무시한다.

**사용 안 함:** 처음부터 새 앱 생성 시 → [[experience-ui-bundle-app-coordinate]].

### Task 식별

| Category | Examples | 구현 가이드 |
|----------|----------|-------------|
| **Page** | 새 routed 페이지(contacts, dashboard, settings) | `implementation/page.md` |
| **Header / Footer** | site 전역 nav bar, footer, 브랜딩 | `implementation/header-footer.md` |
| **Component** | widget, card, table, form, dialog | `implementation/component.md` |

## 워크플로 / 단계

### Layout and Navigation

`appLayout.tsx`가 네비게이션·레이아웃의 source of truth다. 모든 페이지가 이 쉘을 공유한다.

네비게이션·헤더·푸터·사이드바·테마·레이아웃에 영향을 주는 변경 시:

1. `src/appLayout.tsx` 편집 — `routes.tsx`가 사용하는 레이아웃
2. 모든 기본/template nav item·label을 앱별 링크·이름으로 교체
3. placeholder app 이름을 모든 곳에서 교체: header, nav brand, footer, `index.html`의 `<title>`

마치기 전 확인: "appLayout.tsx에 실제 nav item과 브랜딩을 업데이트했는가?"

| What | Where |
|------|-------|
| Layout, nav, branding | `src/appLayout.tsx` |
| Document title | `index.html` |
| Root page content | `routes.tsx`의 root route 컴포넌트 |

### React and TypeScript Standards

#### Routing

단일 router 패키지를 사용한다. `createBrowserRouter` / `RouterProvider` 사용 시 모든 import는 `react-router`에서(`react-router-dom` 아님).

client-side router(React Router, Remix Router, Vue Router 등) 사용 시 basename/basepath/base를 런타임에 document의 `<base href>` 태그에서 도출한다. basename을 절대 hardcode하지 않는다.

```js
const basename = document.querySelector('base')
  ? new URL(document.querySelector('base').href).pathname.replace(/\/$/, '')
  : '/';
const router = createBrowserRouter(routes, { basename });
```

#### Component Library and Styling

- **shadcn/ui** 컴포넌트: `import { Button } from '@/components/ui/button';`
- **Tailwind CSS** utility class

#### URL and Path Handling

앱은 동적 base path 뒤에서 실행된다. Router 네비게이션(`<Link to>`, `navigate()`)은 절대 경로(`/x`). 비-router 속성(`<img src>`)은 dot-relative(`./x`). static asset은 Vite `import` 선호.

#### TypeScript

- `any` 절대 사용 금지 — 적절한 타입, 제네릭, 또는 type guard와 함께 `unknown`
- 이벤트 핸들러: `(event: React.FormEvent<HTMLFormElement>): void`
- state: `useState<User | null>(null)` — 항상 타입 파라미터 제공
- unsafe assertion(`obj as User`) 금지 — type guard 사용

#### Module Restrictions

React UI bundle은 `lightning/*`이나 `@wire`(LWC 전용) 같은 Salesforce 플랫폼 모듈을 import하면 안 된다. 데이터 접근은 `experience-ui-bundle-salesforce-data-access` 스킬 사용.

### Design Thinking

코딩 전 대담한 미적 방향을 정한다:

- **Purpose:** 이 인터페이스가 푸는 문제? 누가 쓰나?
- **Tone:** 명확한 방향 선택 — brutally minimal, maximalist, retro-futuristic, organic, luxury, playful, editorial, brutalist, art deco, soft/pastel, industrial. 영감으로 쓰되 컨텍스트에 맞게 설계.
- **Differentiation:** 무엇이 기억에 남게 하는가?

bold maximalism과 refined minimalism 둘 다 유효 — 핵심은 강도가 아니라 의도(intentionality).

### Frontend Aesthetics

- **Typography:** 특색 있는 폰트. display 폰트 + refined body 폰트 페어링. Inter, Roboto, Arial, Space Grotesk, system 폰트 default 금지.
- **Color:** CSS variable로 cohesive 팔레트. dominant color + sharp accent. 진부한 흰 배경 purple gradient 회피.
- **Motion:** high-impact 순간에 집중 — staggered reveal(`animation-delay`)이 있는 잘 짜인 page load 한 번이 흩어진 micro-interaction보다 낫다. CSS-only 선호, React는 Motion 라이브러리 사용 가능 시.
- **Spatial Composition:** asymmetry, overlap, diagonal flow, grid-breaking. 넉넉한 negative space OR 통제된 밀도.
- **Backgrounds & Depth:** solid color default 대신 분위기 — gradient mesh, noise texture, geometric pattern, layered transparency, dramatic shadow, decorative border, grain overlay.
- **Mobile Responsiveness:** 모든 생성 UI는 **반드시** mobile-responsive. Tailwind 반응형 prefix(`sm:`, `md:`, `lg:`) 사용. 작은 화면에서 컬럼 stack, flexible grid, touch target 최소 44px.

구현 복잡도를 미적 비전에 맞춘다. maximalist는 정교한 애니메이션·효과, minimalist는 절제·정밀·세심한 spacing/typography. 두 디자인이 같아 보이면 안 됨.

### Clarifying Questions

한 번에 하나씩 묻고, 충분한 컨텍스트가 모이면 멈춘다.

**For a Page:** 1) 이름·목적 2) URL 경로 3) 네비게이션 노출 4) 접근 제어(public, `PrivateRoute` 인증, `AuthenticationRoute` 비인증) 5) 콘텐츠 섹션(list/form/table/detail) 6) 데이터 fetching 필요.

**For a Header / Footer:** 1) header/footer/both 2) 내용(logo, nav link, user avatar, copyright, social icon) 3) sticky header 4) 색상/스타일 방향.

**For a Component:** 1) 무엇을 하나 2) 어느 페이지 소속 3) 공유/재사용 vs 단일 feature 4) 데이터/props 5) 내부 state(loading, toggle, form state) 6) 사용할 특정 shadcn 컴포넌트.

### Verification

완료 전 UI bundle 디렉터리에서 lint·build 실행. lint는 0 errors, build는 성공해야 한다.

## 핵심 규칙·가드레일

- `appLayout.tsx`가 nav·layout의 source of truth — nav/header/footer/sidebar/theme/layout 변경은 여기서.
- 모든 placeholder app 이름·기본 nav item·template 콘텐츠 교체(header, nav brand, footer, index.html title).
- router import는 `react-router`만(`react-router-dom` 아님), basename은 `<base href>`에서 런타임 도출(hardcode 금지).
- Router 네비게이션은 절대 경로, 비-router 속성은 dot-relative.
- TypeScript `any` 금지, unsafe assertion 금지.
- `lightning/*`·`@wire` 등 LWC 전용 플랫폼 모듈 import 금지 — 데이터는 data-access 스킬.
- default 폰트(Inter/Roboto/Arial/Space Grotesk/system) 금지, 모든 UI mobile-responsive(touch target ≥44px).
- 완료 전 lint 0 errors + build 성공.

## 번들 파일

| 파일 | 언제 읽나 |
|------|-----------|
| `implementation/page.md` | Page — 새 routed 페이지 구현 가이드 |
| `implementation/header-footer.md` | Header/Footer — site 전역 nav bar·footer·브랜딩 구현 가이드 |
| `implementation/component.md` | Component — widget·card·table·form·dialog 구현 가이드 |

## 관련 노트
- [[experience-ui-bundle-app-coordinate]]
- [[experience-ui-bundle-features-generate]]
- [[experience-ui-bundle-agentforce-client-generate]]
- [[experience-ui-bundle-file-upload-generate]]
