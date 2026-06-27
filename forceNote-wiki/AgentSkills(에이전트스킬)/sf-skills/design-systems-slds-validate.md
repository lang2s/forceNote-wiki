---
tags: [agent-skill, sf-skills, slds, design-system, quality-audit, scorecard]
source: forcedotcom/sf-skills (skills/design-systems-slds-validate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [design-systems-slds-validate, SLDS 품질 감사, SLDS scorecard, quality audit, 컴포넌트 점수, production-readiness]
---

# design-systems-slds-validate — SLDS 품질 감사 스킬

> Lightning Web Component의 SLDS 준수를 감사해 자동 scorecard + 필수 수동 검토 게이트로 등급 리포트를 산출하는 스킬.

---

## 목적과 활성화 조건

LWC의 SLDS 준수를 감사하고 자동 scorecard와 필수 수동 검토 게이트를 만든다. SLDS linter 출력 + 보조 정적 분석을 결합해 linter가 놓치는 것을 잡는다.

활성화 트리거(description 발췌): "score my component", "SLDS scorecard", "quality report", "audit SLDS compliance", "how good is my SLDS", "check component quality", "rate my component", "is this component ready to ship?", "review my component before code review" 등 LWC/SLDS 컴포넌트 품질 평가·production-readiness 점검.

### 스코프

- **포함:** 프로젝트/컴포넌트 셋 SLDS 준수 감사, 변경 전후 품질 비교.
- **미포함(다른 스킬 사용):** violation **수정** → `design-systems-slds2-migrate`; 신규 컴포넌트 **빌드** → `design-systems-slds-apply`; linter만 돌리기 → `npx @salesforce-ux/slds-linter@latest lint .` 직접; 전체 WCAG 감사(이 스킬은 attribute 존재만 확인, 대비/키보드/스크린리더 미포함); `.css`·`.html`·`.js` 외 프레임워크 템플릿(JSX/TSX/Vue/Svelte는 추가 수동 검토 필요).

---

## 워크플로 / 단계

```
1. Run SLDS Linter     → Collect violation counts (linter's job)
2. Run Analyze Script  → Check what linter doesn't cover (supplementary)
3. Agent Review        → Required manual review gate
4. Score & Grade       → Compute automated score + final recommendation
5. Generate Report     → Produce formatted scorecard
```

### Step 1: Run SLDS Linter

```bash
npx @salesforce-ux/slds-linter@latest lint <component-path> 2>&1
```

rule별 violation 카운트 → **Linter Compliance** 점수에 직접 반영.

| Rule | Impact |
|---|---|
| `slds/class-override` | theming·dark mode 깨짐 |
| `slds/lwc-token-to-slds-hook` | SLDS 1 기술 부채 |
| `slds/no-hardcoded-values` | theming·접근성 깨짐 |

**Linter Compliance Score** = `100 - (total_violations × 10)`, 최소 0.

linter 사용 불가 시(Node.js 없음/네트워크 없음/CI 샌드박스): 이 단계 skip, 리포트 헤더에 "Linter not run" 명시, Linter Compliance를 N/A로 하고 나머지 4개 카테고리를 100%로 재정규화:

```
Overall (linter unavailable) = (Theming × 0.29) + (Accessibility × 0.29)
                              + (CodeQuality × 0.21) + (ComponentUsage × 0.21)
```

### Step 2: Run Supplementary Analysis

```bash
node scripts/analyze-quality.cjs <component-path>
```

`.css`·`.html`·`.js`만 스캔, severity별 JSON 출력.

**CSS Checks (linter-complementary)** — Missing fallbacks(`var(--slds-g-*)` fallback 없음, Critical), Invented hooks T051(`hooks-index.json`에 없는 토큰, `--hooks-index` 필요, Critical), Hook pairing(background에 matching foreground 없음, Warning), `!important`(Warning), Magic pixel(spacing hook 미사용 하드코딩 px, Warning), High z-index(>99, Warning), Outline removal(`outline: none` + 대체 focus 없음, Warning).

**JS Checks** — Inline style assignment(`.style.*=`, Warning), SLDS class manipulation(동적 `.classList.add('slds-*')`, Warning).

**HTML Checks** — LBC input labels(`<lightning-input>` label 없음, Critical), Icon alt text(`<lightning-icon>` alternative-text 없음, Critical), Image alt text(`<img>` alt 없음, Critical), Heading hierarchy(레벨 건너뜀 h2→h4, Warning), Positive tabindex(0/-1 외, Warning), Clickable divs(`<div onclick>`, Warning), Inline styles(`style="..."`, Warning), Native elements(LBC 대안 있는 `<input>`/`<button>`/`<select>`, Warning).

**Hook Pairing Validation:**

```
surface-* backgrounds     → on-surface-* text
surface-container-* bg    → on-surface-* text
accent-* backgrounds      → on-accent-* text
accent-container-* bg     → on-accent-* text
```

> 한계: pairing은 selector별이 아닌 **파일 레벨**로 확인. `.classA`에 surface-1, `.classB`에 on-accent-1이 있어도 두 family가 모두 존재하면 통과 → selector별 정확성은 Step 3 수동 검토.

**Invented Hook Detection (T051):** CSS의 모든 `--slds-g-*`를 `hooks-index.json`과 교차 참조. 메타데이터에 없으면 critical — 네이밍 패턴으로 hook을 발명하는 가장 흔한 실수를 잡음.

### Step 3: Agent Manual Review (Required Gate)

자동화 불가, 컴포넌트 목적 이해 필요. 각 발견을 **Blocking**(잘못된 blueprint 구조·필수 state 누락·production 불가한 의미/인터랙션 이슈) 또는 **Advisory**(단독으로 ship을 막진 않는 개선)로 분류.

검토 영역: Loading states(spinner/skeleton), Error states(actionable 메시지), Empty states, Disabled states, Semantic HTML(`<nav>`/`<article>`/`<section>`), SLDS blueprint compliance(card/modal/form 구조).

> 수동 검토 발견은 자동화되지 않지만 최종 권고에 영향. 자동 등급을 유일한 판정으로 보고하지 말 것.

### Step 4: Calculate Scores & Final Recommendation

**Component Complexity** (점수 맥락 제공): Small(1–2 파일, <100줄, high-confidence) / Medium(3–6 파일, 100–500줄) / Large(7+ 파일, 500+줄, 절대 이슈 수 반영 — 잘 만든 큰 컴포넌트도 낮을 수 있음). 리포트 헤더에 포함.

```
Category Score = 100 - (critical_issues × 10) - (warnings × 3) - (info × 1)
Minimum score: 0
```

| Category | Weight | Source |
|---|---|---|
| Linter Compliance | 30% | linter (Step 1) |
| Theming | 20% | script: fallbacks, hook pairing (Step 2) |
| Accessibility | 20% | script: labels, alt text, focus (Step 2) |
| Code Quality | 15% | script: !important, inline styles, z-index (Step 2) |
| Component Usage | 15% | script: native elements (Step 2) + 수동 semantic/blueprint 검토 (Step 3) |

```
Overall = (Linter × 0.30) + (Theming × 0.20) + (Accessibility × 0.20)
        + (CodeQuality × 0.15) + (ComponentUsage × 0.15)
```

**Grade:** 90–100 A / 80–89 B / 70–79 C / 60–69 D / 0–59 F.

**Manual Review Gate:** Pass(수동 발견 없음 → 자동 점수 따름) / Advisory(non-blocking만 → 최대 "Ready with follow-ups") / Blocking(1개 이상 blocking → 자동 등급 무관 production 불가).

**Final Recommendation:**
- Ready for production: 자동 A/B + critical 없음 + gate Pass
- Ready with follow-ups: 자동 A/B + critical 없음 + gate Advisory
- Needs work: critical 있음, 또는 C/D, 또는 gate Blocking
- Failing: 자동 F

### Step 5: Generate Report

`references/report-format.md` 템플릿 사용. 초기 출력은 **compact format** 기본, 요청 시 섹션 확장. executive summary(자동 등급+최종 권고), manual gate 결과(Pass/Advisory/Blocking), 카테고리별 점수, severity별 상세, 코드 위치+권고, 필수 액션 체크리스트 포함.

---

## 핵심 규칙·가드레일

- **자동 등급 ≠ 최종 판정** — Manual Review Gate가 자동 점수를 무시하고 production 불가로 만들 수 있음(Blocking).
- Component Complexity를 항상 헤더에 명시 — 1000줄 컴포넌트의 "B"와 20줄의 "B"를 혼동 방지.
- linter 부재 시 4-카테고리 재정규화 공식 사용, "Linter not run" 명시.
- T051 invented hook은 critical — 에이전트의 가장 흔한 실수.

### Quick Validation Mode

전체 분석 없는 빠른 점검:

```
Quick Quality Check: <component-name>
─────────────────────────────────────
Linter Violations:
  • Class Override:     0
  • Deprecated Tokens:  3
  • Hardcoded Values:   5

Quick Automated Grade: C (estimated)
Run full validation for detailed report.
```

### Edge Cases / False Positives

| 상황 | 가이드 |
|---|---|
| Headless 컴포넌트(JS-only, HTML 없음) | HTML 체크 skip, CSS+linter만 점수화 |
| Wrapper/container 컴포넌트 | CSS 최소가 정상 — 낮은 hook 사용을 벌점하지 않음 |
| 의도적 native element | SLDS blueprint 내부 `<button>`은 정상 — `slds-*` 구조 안이면 C002 suppress |
| LEX 밖 컴포넌트 | LWR/Experience Cloud는 LBC 미사용 가능 — 리포트에 맥락 명시 |
| Test/demo 컴포넌트 | 기준 완화 — 리포트에 명시하되 warning으로 block 안 함 |

false positive는 조용히 버리지 말고 "suppressed" + 정당화로 리포트.

---

## 번들 파일

| 카테고리 | 경로 | 내용 |
|---|---|---|
| Quality Checks | `references/quality-checks.md` | 모든 품질 체크 + 탐지 패턴 전체 목록 |
| Report Format | `references/report-format.md` | 품질 리포트 템플릿·포맷 가이드 |
| Analyze Script | `scripts/analyze-quality.cjs` | linter-보완 자동 분석 (`.css`/`.html`/`.js` 스캔) |
| (스킬 본문) | `SKILL.md` | 5단계 프로세스·스코어링 공식·게이트 |

---

## 관련 노트
- [[design-systems-slds-apply]]
- [[design-systems-slds2-migrate]]
