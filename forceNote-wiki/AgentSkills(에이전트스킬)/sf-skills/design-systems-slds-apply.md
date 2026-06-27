---
tags: [agent-skill, sf-skills, slds, design-system, styling-hooks, blueprints]
source: forcedotcom/sf-skills (skills/design-systems-slds-apply/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [design-systems-slds-apply, SLDS 적용 스킬, SLDS blueprints, styling hooks, 스타일링 훅, utility classes, 유틸리티 클래스]
---

# design-systems-slds-apply — SLDS 준수 UI 적용 스킬

> 올바른 blueprint·styling hook·utility class·icon을 찾아 SLDS v2 준수 UI를 만드는 방법을 에이전트에게 가르치는 스킬.

---

## 목적과 활성화 조건

Salesforce Lightning Design System(SLDS)은 수천 개 아티팩트를 가진 CSS 프레임워크다. 이 스킬은 그것들을 **찾아서 올바르게 사용하는 법**을 다룬다. SLDS **v2**를 타깃으로 하며, 레거시 `--lwc-*` 토큰과 `slds-*--modifier` 문법은 deprecated다.

활성화 트리거(description 발췌):
- SLDS가 필요한 UI 빌드, Lightning Base Components vs SLDS Blueprints 선택
- theming용 styling hook 적용, layout/spacing용 utility class 사용, icon 선택
- "build a modal", "create a form", "data table", "SLDS styling", "style with hooks", "add an icon"

### SLDS 아티팩트 규모

| Artifact | Count | 설명 |
|---|---|---|
| Lightning Base Components | ~70 | 사전 제작 LWC 컴포넌트 (LWC 전용) |
| SLDS Blueprints | 85 | 모든 프레임워크용 CSS/HTML 패턴 |
| Styling Hooks | 523 | theming용 CSS custom property (`--slds-g-*`) |
| Utility Classes | 1,147 | spacing·layout·visibility 빠른 스타일링 클래스 |
| Icons | 1,732 | 5개 카테고리의 SVG 아이콘 |

### 스코프

- **포함:** 어떤 blueprint를 쓸지, hook으로 스타일링(color/spacing/typography/shadow/border), utility class 선택, icon 선택, SLDS 네이밍·클래스 구조·hook 문법. 검증 체크리스트에 기본 접근성 리마인더(아이콘 alt text, focus outline, color-not-sole-indicator) 포함.
- **미포함(동반 스킬 사용):** 디자인 결정(시각 위계·구성·인터랙션 패턴), LWC 메커니즘(@wire/@api/lifecycle/events — 미제공), 전체 접근성(WCAG·ARIA·키보드·focus·대비 — 미제공).
- **감사 범위 주의:** 동반 `design-systems-slds-validate` analyzer는 `.css`·`.html`·`.js` 파일만 스캔. LWC 및 HTML/CSS/JS 컴포넌트에 직접 사용. JSX/TSX 등 프레임워크별 템플릿은 부분 신호로만 취급하고 수동 검토 보완.

---

## 워크플로 / 단계

### Component Selection Hierarchy (항상 이 순서)

```
1. Lightning Base Components (LWC only)    ← Check first
2. SLDS Blueprints (any framework)         ← Use exact SLDS classes
3. Custom with Styling Hooks               ← Use var(--slds-g-*)
4. Custom CSS (last resort)                ← Still use hooks for values
```

LWC로 빌드하면 먼저 Lightning Component Library에서 LBC를 확인한다. LBC가 없거나 LWC가 아니면 SLDS Blueprint를 선택한다.

### Authoring Workflow (5 Phase)

**Phase 1: Understand the Need** — UI 패턴(form/table/modal/card 등), 프레임워크(LWC/React/Vue/Angular/vanilla), 표시 데이터, 필요한 상태(loading/empty/error/success)를 식별한다.

**Phase 2: Select the Artifact**
1. LWC면 Lightning Component Library에서 LBC 확인
2. blueprint 검색: `node scripts/search-blueprints.cjs --search "<pattern>"`
3. blueprint YAML 읽기: `metadata/blueprints/components/<name>.yaml` — 정확한 클래스·modifier·state·접근성 요구사항
4. 매치 없으면 hook으로 custom 빌드(Phase 3)

**Phase 3: Apply Styling**
1. `references/styling-decision-guide.md` 읽기
2. Colors: role 분류(surface/accent/feedback/border) 후 hook 선택
3. Spacing: utility class(`slds-p-*`, `slds-m-*`) 또는 hook(`--slds-g-spacing-*`)
4. Layout: grid utility(`slds-grid`, `slds-col`, `slds-size_*`)
5. Custom CSS: `var(--slds-g-*, fallback)`, custom 클래스 prefix만

**Phase 4: Add Icons**
1. `references/icons-decision-guide.md` 읽기
2. 검색: `node scripts/search-icons.cjs --query "<description>"`
3. LWC: `<lightning-icon>` + `alternative-text`
4. non-LWC: SVG + `slds-icon` 클래스 + `slds-assistive-text`

**Phase 5: Validate (Mandatory — Do Not Skip)**

```bash
# Step 1: SLDS linter 실행 (필수, 목표 zero violations)
npx @salesforce-ux/slds-linter@latest lint <component-path>
```

- Step 2: invented hook 없는지 확인 — 모든 `--slds-g-*`가 `metadata/hooks-index.json`에 존재하는지(T051)
- Step 3: linter가 자동화 못 하는 항목을 `checklists.md`로 점검 (T002 fallback, T010–T013 color pairing, T020–T021 spacing, T031 font-scale, A004 icon a11y, Q010 custom prefix)
- Step 4 (optional): `design-systems-slds-validate`로 점수화 리포트. B grade(≥80) 이상 목표.

---

## 핵심 규칙·가드레일

### Do
- 선택 위계 준수: LBC > Blueprint > Hooks > Custom CSS
- 모든 themeable 값에 `var(--slds-g-*, fallback)` 사용
- `.slds-*`를 오버라이드하지 말고 custom 클래스(`my-*`, `c-*`) 생성
- **사용 전 모든 hook·class·utility가 존재하는지 검증** — search 스크립트 실행. 네이밍 패턴으로 존재를 추정하지 말 것
- surface color와 on-surface color(텍스트용)를 페어링
- 모든 `<lightning-icon>`에 `alternative-text` 제공

### Don't
- color/spacing/typography 값 하드코딩
- `.slds-*` 직접 오버라이드
- deprecated `--lwc-*` 토큰을 1차 값으로 사용
- `--slds-s-*` (shared) hook 사용 — private/internal
- hook 값 재할당 — `var()`로 참조만
- color만으로 의미 전달
- 다른 family 패턴을 보간해 hook 이름 발명

### Hook Naming Traps (발명 방지)

SLDS hook family는 모두 같은 네이밍 패턴을 따르지 **않는다**. `{prefix}-{number}`가 보편적이라 가정해 존재하지 않는 hook을 발명하는 일이 잦다.

- **Trap 1 — Font size는 번호가 없다:** `--slds-g-font-size-3`(✗) → `--slds-g-font-scale-1`(✓). base size인 `--slds-g-font-size-base` 하나만 존재. scale은 neg-4 ~ 10. 절대 `--slds-g-font-size-N` 금지.
- **Trap 2 — Color hook은 항상 번호 필요:** `--slds-g-color-on-surface`(✗) → `--slds-g-color-on-surface-2`(✓). 모든 `--slds-g-color-*`는 번호로 끝남. emphasis로 선택: `-1`(low)/`-2`(medium)/`-3`(high).
- **Trap 3 — 모든 값에 hook 대응이 있는 건 아님:** hook이 없으면 의도적 custom 값임을 주석으로 설명하고 직접 사용. 가능하면 `slds-size_*` grid utility를 하드코딩 대안으로 선호.

```css
.c-field-label {
  /* No SLDS hook exists for this width; intentional custom value */
  min-width: 7rem;
}
```

### Verify Before You Use

> Rule: 메타데이터에 존재를 먼저 확인하지 않고 SLDS hook·utility·blueprint class·icon을 생성 코드에 넣지 말 것. 네이밍 패턴 추측이 발명 아티팩트의 주원인.

| Artifact | 검증 명령 | Source of truth |
|---|---|---|
| Styling hook (`--slds-g-*`) | `node scripts/search-hooks.cjs --prefix "<hook-name>"` | `metadata/hooks-index.json` |
| Utility class (`slds-*`) | `node scripts/search-utilities.cjs --search "<class-name>"` | `metadata/utilities-index.json` |
| Blueprint / CSS class | `node scripts/search-blueprints.cjs --search "<pattern>"` 후 YAML 읽기 | `metadata/blueprints/components/*.yaml` |
| Icon | `node scripts/search-icons.cjs --query "<description>"` | `metadata/icon-metadata.json` |

검색 결과 없으면 **사용 금지** — 검색 결과의 대안을 찾거나 검증된 hook으로 custom 빌드.

> metadata JSON은 직접 읽지 말 것 — 컨텍스트에 너무 큼(hooks-index.json 6,300줄, icon-metadata.json 38,500줄). search 스크립트로 쿼리.

### Naming Conventions

| Pattern | 용도 | 예시 |
|---|---|---|
| `my-*` | 일반 custom 스타일링 | `my-card-header` |
| `c-*` | LWC 컴포넌트 전용 | `c-accountList-row` |
| `[namespace]-*` | 패키지/앱 네임스페이스 | `acme-dashboard-widget` |

회피: generic 이름(`container`, `wrapper`), SLDS-유사 이름(`custom-slds-button`), SLDS 클래스 BEM(`slds-card__custom-header`).

### Common Hook Patterns

```css
/* Surface + text pairing (always use numbered variants) */
background: var(--slds-g-color-surface-1, #ffffff);
color: var(--slds-g-color-on-surface-2, #181818);
padding: var(--slds-g-spacing-4, 1rem);
border-radius: var(--slds-g-radius-border-2, 0.25rem);
box-shadow: var(--slds-g-shadow-1, 0 2px 4px rgba(0,0,0,0.1));
/* Accent for primary actions */
background: var(--slds-g-color-accent-1, #0176d3);
color: var(--slds-g-color-on-accent-1, #ffffff);
/* Typography -- use font-scale-*, NOT font-size-* */
font-size: var(--slds-g-font-scale-2, 0.875rem);
```

---

## 번들 파일

총 151개 파일. 직접 나열하지 않고 카테고리+개수로 요약(SKILL.md "Knowledge Map" 기준).

| 카테고리 | 경로 | 개수 | 내용 |
|---|---|---|---|
| Decision Guides | `references/` | 4 | component-selection, styling-decision-guide, icons-decision-guide, utilities-quick-ref |
| Search Scripts | `scripts/` | 4 | search-blueprints / search-hooks / search-icons / search-utilities (.cjs) |
| Overviews | `guidance/overviews/` | 9 | color, spacing, typography, borders, shadows, icons, illustrations, display-density, utilities |
| Styling Hooks 가이드 | `guidance/styling-hooks/` | (color/borders/shadows/spacing/typography) | hook 카테고리별 상세 사용법 (color는 semantic 하위 폴더 포함) |
| Utilities 가이드 | `guidance/utilities/` | 27 | utility class 카테고리(alignment, box, grid, margin, padding, sizing, truncate, dark-mode 등) |
| Blueprint specs | `metadata/blueprints/components/` | 85 | blueprint YAML (classes·variants·a11y·HTML), 각 ~50–200줄 |
| Raw Metadata | `metadata/` | hooks-index.json(~6,300줄), icon-metadata.json(~38,500줄), utilities-index.json(~6,900줄) | search 스크립트로만 조회 |
| 기타 | 루트 | — | SKILL.md, checklists.md, examples.md, guidance/README.md, guidance/blueprints-index.md, guidance/slds-development-guide.md |

---

## 관련 노트
- [[design-systems-slds-validate]]
- [[design-systems-slds2-migrate]]
- [[SLDS 유틸리티 클래스 레퍼런스]] — 유틸리티 클래스 전수 위키 노트
- [[SLDS 스타일링 훅]] — 색상/밀도 CSS 커스텀 속성
- [[SLDS 블루프린트 카탈로그]] — 컴포넌트 블루프린트 마크업
