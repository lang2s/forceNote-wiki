---
tags: [agent-skill, sf-skills, reference, omnistudio, datamapper]
source: forcedotcom/sf-skills (skills/omnistudio-datamapper-generate/assets/completion-summary-template.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Data Mapper completion template, 데이터매퍼 완료 템플릿, 채점 출력, 요약]
---

# Data Mapper Completion Templates — Data Mapper 완료 템플릿

> Phase 3 채점 출력과 Phase 5 완료 요약에 사용하는 Data Mapper 템플릿(점수 임계값 포함).

---

Use these templates in Phase 3 (scoring output) and Phase 5 (completion summary).

## Scoring Output (Phase 3)

```
Score: XX/100 Rating
|- Design & Naming: XX/20
|- Field Mapping: XX/25
|- Data Integrity: XX/25
|- Performance: XX/15
|- Documentation: XX/15
```

**Thresholds**: ✅ 90+ (Deploy) | ⚠️ 67-89 (Review) | ❌ <67 (Block — fix required)

## Completion Summary (Phase 5)

```
Data Mapper Complete: [Name]
  Type: [Extract|Transform|Load|Turbo Extract]
  Target Object(s): [Object1, Object2]
  Field Count: [N mapped fields]
  Validation: PASSED (Score: XX/100)

Next Steps: Test in Integration Procedure, verify data output, monitor performance
```

## 관련 노트
- [[omnistudio-datamapper-generate]]
- [[omnistudio-datamapper-generate/best-practices|best-practices]]
