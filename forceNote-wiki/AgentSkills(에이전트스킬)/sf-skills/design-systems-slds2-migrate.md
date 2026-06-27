---
tags: [agent-skill, sf-skills, slds, design-system, slds2-migration, styling-hooks]
source: forcedotcom/sf-skills (skills/design-systems-slds2-migrate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [design-systems-slds2-migrate, SLDS 2 마이그레이션, SLDS uplift, lwc-token-to-slds-hook, no-hardcoded-values, 스타일링 훅 교체]
---

# design-systems-slds2-migrate — SLDS 1→2 마이그레이션 스킬

> SLDS linter를 돌리고 violation을 모든 styling hook 카테고리에 걸쳐 체계적으로 고쳐 LWC를 SLDS 1에서 SLDS 2로 이전하는 스킬.

---

## 목적과 활성화 조건

SLDS linter와 구조화된 가이드로 LWC를 SLDS 1 → SLDS 2로 체계적으로 마이그레이션한다.

활성화 트리거(description 발췌): SLDS 2, SLDS uplift, linter violation, LWC token 마이그레이션, class override, SLDS hook 교체가 필요한 하드코딩 CSS 값, styling hook 선택. 또한 `no-hardcoded-values`, `no-slds-class-overrides`, `lwc-to-slds-hooks`, `no-deprecated-tokens-slds1`을 언급하거나 컴포넌트 마이그레이션을 물을 때 — "uplift"/"migration"을 명시하지 않아도 발동.

### SLDS 2 Styling Hook 카테고리

| Category | Hook Prefix | 대체 대상 |
|---|---|---|
| Color | `--slds-g-color-*` | 하드코딩 color, `--lwc-color*` 토큰 |
| Spacing | `--slds-g-spacing-*` | 하드코딩 margin, padding, gap |
| Sizing | `--slds-g-sizing-*` | 하드코딩 width, height, dimension |
| Typography | `--slds-g-font-*` | 하드코딩 font size, weight, line height |
| Border/Radius | `--slds-g-radius-border-*`, `--slds-g-sizing-border-*` | 하드코딩 border-radius, border-width |
| Shadow | `--slds-g-shadow-*` | 하드코딩 box-shadow |

Color hook이 가장 판단이 필요(맥락 의존 선택). Non-color hook은 대부분 번호 스케일로 매핑이 단순.

### Prerequisites
- Node.js 14.x 이상
- 컴포넌트 CSS·markup 파일 접근(`.html` for LWC, `.cmp` for Aura)
- linter 실행용 터미널
- 백업용 Git 저장소(권장)

---

## 워크플로 / 단계

```
1. **REQUIRED — ALWAYS run first:** npx @salesforce-ux/slds-linter@latest lint --fix . — NEVER skip this step. This handles simple violations automatically.
2. Review linter output -> Identify remaining manual fixes needed
3. Fix by violation type -> Use per-rule reference guides
4. Choose the right hook -> Context-first, inspect HTML before deciding
5. Validate -> Re-run linter and confirm zero errors
```

### Step 1: Run SLDS Linter (MANDATORY — NOT optional)

```bash
npx @salesforce-ux/slds-linter@latest lint --fix .
```

모든 CSS·markup(`.html` LWC, `.cmp` Aura)을 분석, 단순 violation 자동 수정, 수동 개입 필요 이슈 리포트.

### Step 2: Analyze Linter Output

linter violation 포맷 예:

```
componentName.css
  15:3  warning  Overriding slds-button isn't supported. To differentiate SLDS and
                 custom classes, create a CSS class in your namespace.
                 Examples: myapp-input, myapp-button.                        slds/no-slds-class-overrides

  23:5  error    The '--lwc-colorBackground' design token is deprecated. Replace it with
                 the SLDS 2 styling hook and set the fallback to '--lwc-colorBackground'.
                 1. --slds-g-color-surface-2
                 2. --slds-g-color-surface-container-2                      slds/lwc-token-to-slds-hook

  30:8  warning  Consider replacing the #ffffff static value with an SLDS 2 styling hook
                 that has a similar value:
                 1. --slds-g-color-surface-1
                 2. --slds-g-color-surface-container-1
                 3. --slds-g-color-on-accent-1
                 4. --slds-g-color-on-accent-2
                 5. --slds-g-color-on-accent-3                              slds/no-hardcoded-values-slds2

  31:15  error   Consider removing t(fontSizeMedium) or replacing it with
                 var(--slds-g-font-size-base, var(--lwc-fontSizeMedium, 0.8125rem)).
                 Set the fallback to t(fontSizeMedium). For more info, see
                 Styling Hooks on lightningdesignsystem.com.               slds/no-deprecated-tokens-slds1
```

4가지 violation type, 각각 고유 fix 접근. **Important:** linter는 모든 하드코딩 값을 플래그하지만 **layout 값**(`100%`, `auto`, `0`, `inherit`, `none`)은 skip — `rule-no-hardcoded-values.md`의 fix-vs-skip triage 표 참조.

### Step 3: Fix Violations by Type

| Violation Rule | 요약 | Reference |
|---|---|---|
| `slds/no-hardcoded-values-slds2` | 하드코딩 값을 SLDS hook + 원본 fallback으로 교체 | rule-no-hardcoded-values.md |
| `slds/lwc-token-to-slds-hook` | `--lwc-*` 토큰을 SLDS 2 hook으로, LWC 토큰을 fallback 유지 | rule-lwc-token-to-slds-hook.md |
| `slds/no-slds-class-overrides` | component-prefixed 클래스 생성, markup에 SLDS 클래스와 나란히 추가 | rule-no-slds-class-overrides.md |
| `slds/no-deprecated-tokens-slds1` | 레거시 `t()`/`token()` 문법을 SLDS 2 hook + LWC fallback으로 교체 | rule-no-deprecated-tokens-slds1.md |

**항상 fallback 값 포함** — `var(--slds-g-hook, originalValue)`, originalValue는 소스 CSS의 정확한 원본.

**Class Override Quick Reference** (가장 자주 빠뜨리는 단계 — CSS와 markup **둘 다** 변경):
1. CSS: `.slds-*` selector → `{componentName}-{sldsElementPart}` (camelCase)로 rename
2. Markup: 새 클래스를 SLDS 클래스 **옆에** 추가 — SLDS 클래스를 절대 제거하지 않음

```css
/* Before */ .slds-button { border-radius: 8px; }
/* After */  .myComponent-button { border-radius: 8px; }
```
```html
<!-- Markup: both classes --> <button class="slds-button myComponent-button">Click</button>
```

### Step 4: Choose the Right Hook

**Color hook** = 맥락 기반 선택. **REQUIRED: color 속성(`color`, `background-color`, `background`, `fill`, `border-color`) violation이면 hook 선택 전 반드시 `color-hooks-decision-guide.md`를 읽어야 함.** linter는 hook을 순서 없이 나열 — 첫 제안을 고르지 말 것. 가이드의 property-based rule이 올바른 hook을 결정.

**Non-color hook** = 단순 — CSS 값을 번호 스케일에 매칭. `non-color-hooks-decision-guide.md`의 value-to-hook lookup 표(spacing/sizing/typography/border/radius/shadow).

### Step 5: Validate and Verify

```
1. npx @salesforce-ux/slds-linter@latest lint .
2. Review errors -> fix by type (Step 3)
3. Re-run linter
4. Repeat until output shows: 0 errors
```

### Validation 체크리스트
- [ ] CSS selector에 `.slds-*` 클래스 없음
- [ ] SLDS 2 대체 없는 `var(--lwc-*)` 토큰 없음
- [ ] 모든 hook에 fallback 값 포함
- [ ] background/foreground color hook이 같은 family
- [ ] HTML에 원본 SLDS 클래스 보존
- [ ] spacing은 번호 hook (named `spacing-medium` 아님)
- [ ] typography는 번호 hook (named `font-weight-bold` 아님)
- [ ] light/dark mode·density 설정에서 정상 렌더

### Output
완전히 마이그레이션된 CSS(+ class override 수정 시 업데이트된 HTML markup) 반환, SLDS linter violation 0. 모든 hook은 원본 CSS 값을 보존하는 fallback 포함.

---

## 핵심 규칙·가드레일

### Key Constraints
- **Hook 이름 절대 발명 금지** — SLDS design system에 문서화된 hook만 사용
- **항상 fallback 값 포함** — fallback은 소스 CSS의 정확한 원본 값
- **하드코딩 숫자 값 절대 변경 금지** — `100%`, `50%`, `200px`, `1.5`, `auto`, `0`, `inherit`, `none`, `flex: 1`은 구조/layout 값. hook으로 교체·제거하지 않음
- **정확한 매치 없으면 그대로 둠** — 하드코딩 값이 어떤 hook의 렌더 값과도 가깝게 대응 안 하면 강제 끼워맞추지 말고 유지
- **hook 번호를 원본 값 강도에 매칭** — `-1`로 기본값 두지 말 것. 원본에 가장 가까운 variant 선택
- **번호 스케일만** — `spacing-medium`, `font-weight-bold`, `radius-large` 같은 named hook은 존재하지 않음

### Advanced Patterns

**Color-Mix for Transparency** — 하드코딩이 `rgba()`/투명도를 쓰면 `color-mix()`로 opacity 보존:

```css
/* Before */
border-color: rgba(186, 5, 23, 0.7);
/* After — use oklab color space for perceptual consistency */
border-color: color-mix(in oklab, var(--slds-g-color-palette-red-40, rgb(181,54,45)), transparent 30%);
```

공식: X% opacity → `(100 - X)%` transparent (70%→`transparent 30%`, 50%→`transparent 50%`). fallback은 `rgba()`가 아닌 불투명 `rgb()` 사용 — color-mix가 투명도 처리.

**calc() Expressions with Tokens:**

```css
/* Before — Aura t() with calc */
height: t('calc(' + lineHeightButton + ' + 2px)');
/* After — if calc is still needed */
height: calc(var(--lwc-lineHeightButton) + 2px);
/* After — if calc was unnecessary, simplify */
height: var(--lwc-lineHeightButton);

/* calc() with --lwc-* being replaced */
/* Before */ padding: calc(var(--lwc-spacingMedium) + 4px);
/* After */  padding: calc(var(--slds-g-spacing-4, var(--lwc-spacingMedium)) + 4px);
```

Tip: 종종 `calc()`는 불필요 — 결과가 기존 hook 값과 맞는지 확인 후 단순화.

### Troubleshooting

| Issue | Solution |
|---|---|
| linter가 color hook 2+ 제안 | HTML 맥락으로 element의 semantic role 판단 — color-hooks-decision-guide.md |
| 마이그레이션 후 시각 변화 | fallback이 원본과 맞는지 확인, surface vs container family 확인 |
| 하드코딩 값에 hook 없음 | 그대로 둠, custom hook 이름 발명 금지 |
| linter가 `100%`/`auto` 등에 "Remove static value" | 그대로 둠 — layout 값, 제거 시 렌더 깨짐 |
| CSS 클래스 네이밍 에러 | 정확한 camelCase: `myComponent-button` (not `MyComponent-button`) |
| spacing/sizing 안 맞음 | non-color-hooks-decision-guide.md 매핑 확인, spacing vs sizing 용법 확인 |
| named hook 작동 안 함 (`spacing-medium`) | named hook 없음 — 번호 스케일: 16px=`spacing-4`, inline bold emphasis=`font-weight-7`(헤딩 아님) |
| compact density에서 달라 보임 | density-aware hook(`--slds-g-spacing-var-*`) 사용 |

---

## 번들 파일

`references/` 9개 파일:

| 파일 | 내용 |
|---|---|
| color-hooks-decision-guide.md | 5개 color hook family, 결정 트리, bg-fg pairing, palette 접근성 |
| non-color-hooks-decision-guide.md | spacing/sizing/typography/border/radius/shadow lookup 표 |
| rule-no-hardcoded-values.md | linter 동작, fix-vs-skip triage, 교체 패턴, utility class 워크플로 |
| rule-lwc-token-to-slds-hook.md | deprecated `--lwc-*` 토큰 교체 패턴 |
| rule-no-deprecated-tokens-slds1.md | 레거시 `t()`/`token()` Aura 문법 교체 패턴 |
| rule-no-slds-class-overrides.md | 클래스 rename + HTML 업데이트 |
| examples.md | 시나리오·복잡도별 before/after 예제 |
| common-patterns.md | override 금지 클래스, deprecated SLDS 2 클래스, palette fallback, SLDS 2 대응 없는 토큰 |
| migration-checklist.md | 전체 검증 체크리스트 |

---

## 관련 노트
- [[design-systems-slds-apply]]
- [[design-systems-slds-validate]]
