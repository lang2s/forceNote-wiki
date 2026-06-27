---
tags: [agent-skill, sf-skills, reference, slds, design-system, checklist]
source: forcedotcom/sf-skills (skills/design-systems-slds2-migrate/references/migration-checklist.md, 공식 Salesforce)
created: 2026-06-27
aliases: [SLDS 2 Uplift Checklist, SLDS2 업리프트 체크리스트, 마이그레이션 검증, troubleshooting]
---

# SLDS 2 Uplift Checklist — SLDS 2 업리프트 검증 체크리스트

> SLDS 2 업리프트 수정을 적용한 각 CSS 파일에 대해 룰별·교차 점검 체크리스트와 시각/린터/기능 문제 트러블슈팅 절차.

---

Validation checklist for each CSS file after applying SLDS 2 uplift fixes.

---

## Per-Rule Checks

### `slds/no-slds-class-overrides`

**CSS:**
- [ ] All `.slds-*` overrides reported by the linter are renamed to `{componentName}-{sldsElementPart}`
- [ ] Component name is camelCase
- [ ] SLDS element names preserved after prefix (e.g., `.slds-button` → `myComponent-button`)
- [ ] Each SLDS class in a compound selector gets its own component class

**HTML:**
- [ ] Original SLDS classes preserved (never removed)
- [ ] Component classes added alongside SLDS classes
- [ ] Every element in CSS selector chain updated in HTML

### `slds/lwc-token-to-slds-hook`

- [ ] All `var(--lwc-*)` tokens replaced with SLDS 2 hooks
- [ ] Hooks chosen from linter's numbered suggestion list (not invented)
- [ ] Surface vs container choice matches DOM context
- [ ] Fallback includes original token: `var(--slds-g-[hook], var(--lwc-[token]))`

### `slds/no-hardcoded-values-slds2`

- [ ] Color values replaced with context-appropriate hooks (surface, accent, feedback, etc.)
- [ ] Non-color values (spacing, sizing, typography, border, radius, shadow) replaced where exact match exists
- [ ] Hardcoded numerical values left unchanged — do not replace or remove values like `100%`, `50%`, `200px`, `1.5`, `auto`, `0`, `inherit`, `none`, `flex: 1`
- [ ] All replacements include original value as fallback: `var(--slds-g-[hook], originalValue)`
- [ ] Only numbered hooks used (no `spacing-medium`, `font-weight-bold`, etc.)

---

## Cross-Cutting Checks

### Hook Selection
- [ ] Background-foreground hooks paired from same family (e.g., `surface-container-*` with `on-surface-*`)
- [ ] Spacing hooks for margin/padding/gap; sizing hooks for width/height
- [ ] Density-aware variants (`--slds-g-spacing-var-*`) used where component adapts to comfy/compact

### Linter Validation
- [ ] `npx @salesforce-ux/slds-linter@latest lint .` — zero errors
- [ ] Warnings reviewed — remaining warnings are for values with no available hook

```bash
# Run the SLDS linter and confirm zero errors
npx @salesforce-ux/slds-linter@latest lint .
```

---

## Troubleshooting

### Visual appearance changed
1. Check fallback values match original hardcoded values exactly
2. Verify correct hook family (surface vs container)
3. Ensure background-foreground hooks properly paired

### Linter still shows violations
1. Verify hook names exactly match linter suggestions
2. Check for missed CSS files in subdirectories
3. Ensure all elements in selector chains updated in HTML

### Functionality broken
1. Check original SLDS classes preserved in HTML
2. Verify JavaScript selectors updated if CSS classes changed (class overrides rule)
3. Update tests that use class-based query selectors

## 관련 노트

- [[design-systems-slds2-migrate]]
- [[design-systems-slds2-migrate/examples|examples]]
- [[rule-no-slds-class-overrides]]
