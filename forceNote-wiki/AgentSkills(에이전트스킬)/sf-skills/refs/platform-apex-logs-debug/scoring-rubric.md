---
tags: [agent-skill, sf-skills, reference, platform, debug, scoring]
source: forcedotcom/sf-skills (skills/platform-apex-logs-debug/references/scoring-rubric.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Debug Analysis Scoring Rubric, 디버그 분석 채점 루브릭, 100점 평가, 분석 품질 임계값]
---
# Debug Analysis Scoring Rubric — 디버그 분석 채점 루브릭

> 디버그 로그 분석 품질을 100점 만점으로 평가하는 루브릭 — 근본원인 정확도·수정 품질·성능 영향·완전성·명료성 5개 카테고리와 등급 임계값.

## 100-point rubric

| Category | Points | What good looks like |
|---|---:|---|
| Root-cause accuracy | 25 | Finds the actual cause, not just symptoms |
| Fix quality | 25 | Recommends a fix that directly addresses the cause |
| Performance impact | 20 | Improves limits / efficiency without introducing regressions |
| Completeness | 15 | Captures related issues and secondary risks |
| Clarity | 15 | Gives an explanation the user can act on quickly |

## Thresholds

| Score | Rating | Meaning |
|---|---|---|
| 90–100 | Excellent | Expert analysis with strong fixes |
| 80–89 | Good | Reliable analysis with minor gaps |
| 70–79 | Acceptable | Usable, but may miss secondary issues |
| 60–69 | Weak | Partial diagnosis only |
| < 60 | Incomplete | Needs more investigation |

---

## Score Calculation Example

```text
// 구조 예시 — 실제 동작 코드 아님 (루브릭 합산 도해)
Root-cause accuracy : 25 / 25
Fix quality         : 22 / 25
Performance impact  : 18 / 20
Completeness        : 12 / 15
Clarity             : 14 / 15
-----------------------------------
Total               : 91 / 100  → Rating: Excellent
```

## 관련 노트
- [[platform-apex-logs-debug]]
- [[analysis-playbook]]
- [[common-issues]]
