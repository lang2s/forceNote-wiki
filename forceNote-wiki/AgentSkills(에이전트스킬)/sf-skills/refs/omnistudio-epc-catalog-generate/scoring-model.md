---
tags: [agent-skill, sf-skills, reference, omnistudio, epc]
source: forcedotcom/sf-skills (skills/omnistudio-epc-catalog-generate/references/scoring-model.md, 공식 Salesforce)
created: 2026-06-27
aliases: [EPC scoring model, EPC 채점 모델, 120점, 번들 검토]
---

# EPC Bundle Scoring Model (120 Points) — EPC 번들 채점 모델

> EPC 오퍼 번들 채점·검토용 120점 루브릭 — 카탈로그 식별/제품 구조/속성 모델링/번들 구성/DataPack 무결성/문서화.

---

Use this rubric when scoring or reviewing an existing EPC offer bundle. Score each category and sum for a total out of 120.

**Thresholds**: `>= 95` Deploy-ready | `70–94` Needs review | `< 70` Block and fix.

---

## 1) Catalog Identity and Naming (20 points)

- Product name is clear, unique, and follows naming conventions
- `ProductCode` follows the deterministic convention (no environment suffixes)
- `SpecificationType`, `SpecificationSubType`, and `Family` values are coherent
- Stable keying: `GlobalKey` is a UUID-style value; source key is consistent across files

---

## 2) EPC Product Structure (20 points)

- All required `Product2` and EPC fields are present and populated
- Lifecycle dates (`EffectiveDate`, `SellingStartDate`) are set and logically ordered
- `IsActive` and `%vlocity_namespace%__IsOrderable__c` flags are coherent with lifecycle status
- Record type and catalog classification are consistent

---

## 3) Attribute Modeling (25 points)

- Attributes are logically grouped by category
- Every attribute default exists within its `values[]` array
- Required, read-only, and filterable semantics are correctly set
- Display sequences are unique within each category and use spaced values (10, 20, 30…)

---

## 4) Offer Bundle Composition (25 points)

- Root `%vlocity_namespace%__ProductChildItem__c` row is present with `IsRootProductChildItem=true`
- All child product references are valid and their sequence/line numbers are unique
- `MinQuantity`, `MaxQuantity`, and default `Quantity` constraints are set correctly per child
- Optional vs required semantics are reflected accurately in min/max/default values

---

## 5) DataPack Integrity (15 points)

- All namespace placeholders (`%vlocity_namespace%`) are consistent across every file in the bundle
- Lookup object references use GlobalKey / source key (no hardcoded org-specific IDs)
- No environment-specific brittle fields (no `_DEV`, `_UAT`, `_PROD` suffixes in ProductCode or keys)

---

## 6) Documentation and Handoff (15 points)

- Clear explanation of the modeled intent is included in the handoff block
- Testing checklist is present (see `scripts/cli-validation-commands.sh`)
- Risks and assumptions are explicitly called out in the completion block

---

## 채점 합산 형식 (구조 예시)

```
// 구조 예시 — 실제 동작 코드 아님
EPC Bundle Score: XXX/120  (>=95 Deploy-ready | 70-94 Review | <70 Block)
|- Catalog Identity & Naming: XX/20
|- EPC Product Structure:     XX/20
|- Attribute Modeling:        XX/25
|- Offer Bundle Composition:  XX/25
|- DataPack Integrity:        XX/15
|- Documentation & Handoff:   XX/15
```

## 관련 노트
- [[omnistudio-epc-catalog-generate]]
- [[epc-field-guide]]
