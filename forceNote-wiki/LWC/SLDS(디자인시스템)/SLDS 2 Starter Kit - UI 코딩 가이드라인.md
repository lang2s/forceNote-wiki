---
tags: [slds, starter-kit, lwc, guidelines, best-practices, lightning-base-components, styling-hooks, builderrules]
source: salesforce-ux/design-system-2-starter-kit (.builderrules, 공식 Salesforce UX)
created: 2026-06-26
aliases: [.builderrules, Salesforce UI Guidelines, UI 코딩 가이드라인, LBC 우선, UI 코드 체크리스트, 스타일링 훅 시맨틱 사용, explore_slds_blueprints, 컴포넌트 결정 트리]
---

# SLDS 2 Starter Kit - UI 코딩 가이드라인 (.builderrules)

> `.builderrules`는 스타터킷의 AI 에이전트·개발자용 **UI 작성 규칙**이다 — 템플릿 배치 구조 + "UI 코드를 한 줄 쓰기 전" 거쳐야 할 **5단계 결정 트리** + 스타일링 훅의 시맨틱(의미 기반) 사용 규칙으로 구성된다.

---

이 노트는 SLDS 2 Starter Kit 리포지토리 루트의 `.builderrules` 파일(160줄, 제목 "Salesforce UI Guidelines")을 전수 정리한 것이다. AI 빌더(Cursor/Copilot 등)와 사람 개발자 모두 이 규칙을 따라 컴포넌트를 만들어야 일관된 SLDS 2 UI가 나온다.

---

## 1. 템플릿 구조 — 컴포넌트를 어디에 둘 것인가

`.builderrules`의 **TEMPLATE STRUCTURE (where to add components)** 섹션 원문:

- **Route-level views** → `src/modules/page/<name>/` → tag `page-<name>`. `src/routes.config.js`와 `shell/app/app.js`(`ROUTE_COMPONENTS`)에 등록.
- **Child routes** (예: `/contacts` 탭 아래의 `/contacts/:id`) → `navPage` 대신 **`navHighlight: '<parentNavPage>'`** 설정. 이렇게 하면 별도 nav 항목을 만들지 않고 부모 탭만 활성 표시(active-state)된다.
  > 원문: *"Only routes with `navPage` create tabs; `navHighlight` is for active-state only."* — 즉 탭을 만드는 건 `navPage`뿐이고, `navHighlight`는 활성 상태 표시 전용이다.
- **Reusable UI** → `src/modules/ui/<name>/` → tag `ui-<name>`. 페이지나 다른 컴포넌트 내부에서 사용.
- **App shell** → `src/modules/shell/<name>/` → tag `shell-<name>`. **기능(feature) UI를 여기 두지 말 것** — `page/` 또는 `ui/`를 사용.
- **Do not**: `src/modules/lightning/` 또는 `src/build/lightning-icon/shims/` 아래에 커스텀 컴포넌트를 추가하지 말 것 (체크인된 아이콘 오버라이드는 예외).

> 라우팅·셸 배치의 상세 메커니즘(`navPage`/`navHighlight`/`ROUTE_COMPONENTS`)은 [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]] 참조. `page/`·`ui/`·`shell/` 모듈 폴더 구조 전체는 [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]] 참조.

---

## 2. UI 코드 체크리스트 (반드시 IN ORDER) — 5단계 결정 트리

이 5단계가 `.builderrules`의 핵심이다. 원문(**UI CODE CHECKLIST**)은 *"Before writing ANY UI code, complete this checklist **IN ORDER**"* 로 시작한다. 순서를 건너뛰지 말 것 — 위에서부터 하나씩 "있으면 사용, 없으면 다음 단계"로 내려간다.

```text
// .builderrules 원문 인용 — UI CODE CHECKLIST (IN ORDER)

1. [ ] Search Lightning Base Components index – Does a component exist for this?
       - Reference: Lightning Base Components
       If YES → Use it.
       If NO  → Proceed to step 2.

2. [ ] Search SLDS Component Blueprints – Does a blueprint exist for this?
       - Use the MCP tool `explore_slds_blueprints` to search by name, category, or keyword.
         Use `guide_slds_blueprints` for general blueprint guidance and a full index.
       If YES → Create a new LWC that implements this component blueprint.
       If NO  → Proceed to step 3.

3. [ ] Check SLDS Utility Classes – Does one exist for this styling need?
       - Reference: Lightning Design System Components
       - Common utilities: spacing (slds-m-*, slds-p-*), layout (slds-grid, slds-size_*),
         text (slds-text-*)
       If YES → Use it.
       If NO  → Proceed to step 4.

4. [ ] Use Custom CSS with Styling Hooks – Does one exist for this CSS property?
       - Reference: Lightning Design System Components
       If YES → Use it (with fallback value).
       If NO  → Proceed to step 5.

5. [ ] Use a hard-coded CSS value – Only when no component, utility class,
       or styling hook exists.
```

요약 (한국어):

| 단계 | 질문 | YES면 | NO면 |
|---|---|---|---|
| ① | Lightning Base Component(LBC) 인덱스에 있는가? | 그것을 사용 | ②로 |
| ② | SLDS 컴포넌트 블루프린트가 있는가? (`explore_slds_blueprints` MCP) | 블루프린트를 구현하는 **새 LWC** 생성 | ③으로 |
| ③ | SLDS 유틸리티 클래스가 있는가? | 사용 | ④로 |
| ④ | 해당 CSS 속성에 맞는 스타일링 훅이 있는가? | **fallback 값과 함께** 사용 | ⑤로 |
| ⑤ | 하드코딩 CSS 값 | — | 컴포넌트·유틸리티·훅 어디에도 없을 때만 |

---

## 3. 모듈형 컴포넌트 설계 + 포맷팅 규칙

### Modular Component Design (원문)

> *"Decouple your UI into independent, single-responsibility components. Focus on creating a highly reusable and maintainable codebase by breaking complex layouts into smaller 'atomic' or 'molecular' LWCs."*

복잡한 레이아웃을 더 작은 **atomic(원자)** 또는 **molecular(분자)** LWC로 쪼개 단일 책임·재사용성·유지보수성을 확보한다.

### Formatting Rules (원문 그대로)

* Always prioritize readability and standard Salesforce design patterns. (가독성과 표준 Salesforce 디자인 패턴 우선)
* **Never use `!important`.**
* **Never override SLDS classes** in your CSS. (SLDS 클래스를 CSS에서 오버라이드 금지)
* **Do not use inline `style` attributes** — 유틸리티 클래스나 컴포넌트 CSS 파일을 사용.

### LWC Framework

> *"If you run into errors with the LWC framework or LWR runtime, use the MCP server and selectively use tools to best address your issue."* — LWC/LWR 런타임 오류 시 MCP 서버의 도구를 선택적으로 사용한다.

---

## 4. 디자인 시스템 컨텍스트 — LBC vs Lightning Design System Components

`.builderrules`의 **DESIGN SYSTEM CONTEXT**는 두 개의 상호 보완 인덱스를 정의한다.

**Lightning Base Components (LBCs)** — SLDS 컴포넌트의 사전 제작된 LWC 구현체(예: `<lightning-button>`, `<lightning-card>`). JavaScript 기능·이벤트·props가 내장돼 있다.
> 원문: *"**Always use LBCs first** when available—they are the preferred method for building UI."*

**Lightning Design System Components** — 그 아래에 깔린 CSS 프레임워크:
- **Styling Hooks**: 테마용 CSS 변수 (예: `--slds-g-color-surface-1`)
- **Utility Classes**: 레이아웃·간격 클래스 (예: `slds-m-around_small`)
- **Component Classes**: CSS-only 컴포넌트 패턴 (예: `.slds-button`)
- **Component Blueprints**: LBC가 없을 때 쓰는 HTML/CSS 마크업 패턴

> 원문: *"Use SLDS (styling hooks, utility classes, component blueprints) to customize LBCs or build components when no LBC exists."* — SLDS는 LBC를 커스터마이즈하거나 LBC가 없을 때 컴포넌트를 만드는 데 쓴다.

### 두 종류의 컴포넌트 (Lightning Base Component and Component Blueprints)

HTML/CSS/JS를 쓰기 전, 기존 컴포넌트로 원하는 외형을 낼 수 있는지부터 판단한다.

**A. Lightning Base Components (`<lightning-*>`)** — JavaScript API·props·events를 갖춘 Salesforce 공식 LWC 컴포넌트. 주요 예시(`.builderrules` 원문 목록):

* `<lightning-button>` — variant를 가진 인터랙티브 버튼
* `<lightning-input>` — 폼 입력 (text, email, date, checkbox 등)
* `<lightning-textarea>` — 여러 줄 텍스트 입력
* `<lightning-card>` — header/body/footer 슬롯을 가진 컨테이너
* `<lightning-combobox>` — 드롭다운 선택
* `<lightning-datatable>` — 정렬 가능한 데이터 테이블
* **LightningModal** (`lightning/modal`에서 extend) — 모달 다이얼로그.
  > 원문: *"Use `src/modules/ui/demoModal/` as the reference: extend LightningModal; compose with `lightning-modal-header`, `lightning-modal-body`, `lightning-modal-footer`; open via `MyModal.open({ size, label })`. Do not build modals from raw `slds-modal` markup."* — raw `slds-modal` 마크업으로 모달을 만들지 말 것.

> 모달 구현 패턴(`demoModal`)의 상세는 [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]] 참조.

**B. Component Blueprints (HTML/CSS 패턴)** — LBC가 없거나 적합하지 않을 때 쓰는 SLDS CSS 클래스 + vanilla HTML.
> 원문: *"If a lightning base component is not available, create a _new LWC_ that implements the component blueprint."*

블루프린트 찾는 법 (원문):
- **MCP 도구 `explore_slds_blueprints`** — `name`, `category`, `search` 키워드, `lightning_component`, `slds_class`, `styling_hook` 으로 검색/조회.
- **MCP 도구 `guide_slds_blueprints`** — 카테고리별로 정리된 **전체 85개 블루프린트** 개요와 사용 가이드.

> 블루프린트 카탈로그 자체는 [[SLDS 블루프린트 카탈로그]] 참조.

### Utility Classes (원문)

> *"Always use SLDS utility classes for spacing, alignment, text, and sizing. Avoid custom classes for these purposes."*

주요 유틸리티 카테고리(원문):
- **Spacing**: `slds-m-around_*`, `slds-p-horizontal_*`, `slds-p-around_small`
- **Layout/Grid**: `slds-grid`, `slds-size_1-of-1`, `slds-medium-size_1-of-2`
- **Text**: `slds-text-align_center`, `slds-text-heading_medium`
- **Display**: `slds-show`, `slds-hide`

---

## 5. 스타일링 훅 — 시맨틱(의미 기반) 사용

유틸리티 클래스로 해결되지 않으면, 올바른 글로벌 스타일링 훅을 참조하는 커스텀 CSS를 작성한다. `.builderrules`의 **Custom CSS with Styling Hooks** Usage Guidelines (원문):

- 글로벌 스타일링 훅은 CSS 변수다: `background: var(--slds-g-color-surface-1, #fff);`
- **Always provide a fallback value** — backwards compatibility(하위 호환)를 위해 항상 fallback 값을 둘 것.
- fallback 값은 **Cosmos theme 값**을 사용 (token `.mdx` 파일 참조).
- **Semantic Usage Only** — 훅을 의도하지 않은 용도로 절대 쓰지 말 것:

```css
/* .builderrules 원문 인용 — Semantic Usage 예시 */

/* ❌ WRONG: 반지름 훅을 width에 사용 (의미 불일치) */
width: var(--slds-g-radius-border-circle);

/* ✅ CORRECT: surface 색 훅을 background-color에 + fallback */
background-color: var(--slds-g-color-surface-1, #fff);
```

### 예시 훅 카테고리 (원문)

| 카테고리 | 훅 예시 | 용도 |
|---|---|---|
| **Surface** | `--slds-g-color-surface-1`, `--slds-g-color-surface-2` | 표면 색 |
| **Container** | `--slds-g-color-surface-container-1`, `--slds-g-color-surface-container-2` | 컨테이너 표면 |
| **On-Surface** | `--slds-g-color-on-surface-1` | 표면 위 텍스트/아이콘 |
| **Accent** | `--slds-g-color-accent-1`, `--slds-g-color-accent-container-1` | 강조 |
| **Border** | `--slds-g-color-border-1`, `--slds-g-color-border-accent-1` | 테두리 |
| **Feedback** | `--slds-g-color-error-1`, `--slds-g-color-success-1`, `--slds-g-color-warning-1` | 피드백(오류/성공/경고) |

> 리소스(원문): *"Semantic Usage Guide and Token Value Reference in Lightning Design System Components."* 훅의 전체 네이밍 체계·토큰 값은 [[SLDS 스타일링 훅]] 참조.

---

## 6. 하드코딩 CSS 값이 허용되는 경우

5단계 결정 트리의 마지막 단계. 컴포넌트·유틸리티 클래스·스타일링 훅 어디에도 없을 때만 허용한다. `.builderrules`가 명시한 **허용 예시(원문)**:

- `height: 100%` — 대응하는 유틸리티 클래스나 스타일링 훅이 없음
- 커스텀 레이아웃을 위한 **퍼센트(%) 값**
- **Transform 또는 animation** 값
- **Z-index**

> 색·간격·타이포그래피처럼 디자인 토큰으로 표현 가능한 값은 하드코딩하지 않는다 — 위 4가지는 토큰 체계 바깥의 구조적/동적 값이라 예외다.

---

## 7. 노트 — `.builderrules`의 위치와 고유성

- `.builderrules`는 같은 리포의 `AGENTS.md`·`README.md`와 **상당 부분 중복**된다(디자인 시스템 컨텍스트, LBC 우선 원칙 등). 그러나 다음 세 가지는 `.builderrules` 고유의 깊이를 가진다:
  1. **순서 강제 5단계 UI 코드 체크리스트** (IN ORDER 결정 트리)
  2. **85개 블루프린트 MCP 도구** (`explore_slds_blueprints` / `guide_slds_blueprints`)의 검색 인자 명세
  3. **스타일링 훅 시맨틱 사용 가이드** (❌/✅ 예시 + 카테고리별 훅 목록)
- 리포 루트의 `CLAUDE.md`는 본문이 없고 **`@AGENTS.md` include 한 줄**뿐이다 — 즉 Claude Code도 `AGENTS.md` 규칙을 그대로 따르도록 위임돼 있다.

> 스타터킷의 에이전트 규칙 파일 체계(AGENTS.md / .builderrules / README) 개요는 [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]] 참조.

---

## 관련 노트
- [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]]
- [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]]
- [[SLDS 2 Starter Kit - 셸 UI 컴포넌트]]
- [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]]
- [[SLDS 블루프린트 카탈로그]]
- [[SLDS 스타일링 훅]]
- [[SLDS 모범 사례]]
- [[SLDS LWC 디자인 시스템]]
