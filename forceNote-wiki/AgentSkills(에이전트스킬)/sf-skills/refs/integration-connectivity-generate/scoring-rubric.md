---
tags: [agent-skill, sf-skills, reference, integration, scoring]
source: forcedotcom/sf-skills (skills/integration-connectivity-generate/references/scoring-rubric.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Scoring Rubric, 채점 기준, Integration Score, 120 Points]
---

# Scoring System (120 Points) — 채점 시스템(120점)

> 통합 코드 품질을 보안·오류처리·벌크화·아키텍처·모범사례·문서화 6개 카테고리 120점으로 평가하는 채점 기준과 출력 포맷.

---

## Category Breakdown

| Category | Points | Evaluation Criteria |
|----------|--------|---------------------|
| **Security** | 30 | Named Credentials used (no hardcoded secrets), OAuth scopes minimized, certificate auth where applicable |
| **Error Handling** | 25 | Retry logic present, timeout handling (120s max), specific exception types, logging implemented |
| **Bulkification** | 20 | Batch callouts considered, CDC bulk handling, event batching for Platform Events |
| **Architecture** | 20 | Async patterns for DML-triggered callouts, proper service layer separation, single responsibility |
| **Best Practices** | 15 | Governor limit awareness, proper HTTP methods, idempotency for retries |
| **Documentation** | 10 | Clear intent documented, endpoint versioning noted, API contract documented |

## Scoring Thresholds

| Rating | Score Range | Description |
|--------|------------|-------------|
| Excellent | 108-120 | Production-ready, follows all best practices |
| Very Good | 90-107 | Minor improvements suggested |
| Good | 72-89 | Acceptable with noted improvements |
| Needs Work | 54-71 | Address issues before deployment |
| Block | <54 | CRITICAL issues, do not deploy |

## Scoring Output Format

```
📊 INTEGRATION SCORE: XX/120 ⭐⭐⭐⭐ Rating
════════════════════════════════════════════════════

🔐 Security           XX/30  ████████░░ XX%
├─ Named Credentials used: ✅
├─ No hardcoded secrets: ✅
└─ OAuth scopes minimal: ✅

⚠️ Error Handling     XX/25  ████████░░ XX%
├─ Retry logic: ✅
├─ Timeout handling: ✅
└─ Logging: ✅

📦 Bulkification      XX/20  ████████░░ XX%
├─ Batch callouts: ✅
└─ Event batching: ✅

🏗️ Architecture       XX/20  ████████░░ XX%
├─ Async patterns: ✅
└─ Service separation: ✅

✅ Best Practices     XX/15  ████████░░ XX%
├─ Governor limits: ✅
└─ Idempotency: ✅

📝 Documentation      XX/10  ████████░░ XX%
├─ Clear intent: ✅
└─ API versioning: ✅

════════════════════════════════════════════════════
```

---

## 관련 노트
- [[integration-connectivity-generate]]
- [[security-best-practices]]
- [[callout-patterns]]
