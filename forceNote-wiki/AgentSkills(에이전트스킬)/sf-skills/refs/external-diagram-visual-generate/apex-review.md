---
tags: [agent-skill, sf-skills, reference, diagram, visual, code-review]
source: forcedotcom/sf-skills (skills/external-diagram-visual-generate/assets/review/apex-review.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Apex Code Review Template, Apex 코드 리뷰 템플릿, Gemini Apex 리뷰]
---
# Apex Code Review Template — Apex 코드 리뷰 템플릿
> Gemini 서브에이전트로 Apex 코드를 벌크화·보안·성능·유지보수 관점에서 리뷰하기 위한 프롬프트와 심각도 가이드.

## Gemini Review Prompt

```
Review this Apex code for best practices and issues:

CODE:
[paste code here]

REVIEW CATEGORIES:

1. BULKIFICATION
   - SOQL queries in loops
   - DML operations in loops
   - Governor limit risks
   - Collection usage

2. SECURITY
   - CRUD permissions check
   - FLS enforcement
   - Sharing model compliance
   - Injection vulnerabilities

3. BEST PRACTICES
   - Trigger handler pattern
   - One trigger per object
   - Separation of concerns
   - Proper exception handling

4. PERFORMANCE
   - Selective SOQL queries
   - Index usage
   - Unnecessary computation

5. MAINTAINABILITY
   - Code comments
   - Method length
   - Test coverage considerations

OUTPUT FORMAT:
JSON with summary, issues array, bestPractices array, and score
```

## Usage

```bash
gemini "Review this Apex trigger for issues: [paste code]" -o json
```

## Severity Guidelines

| Severity | Criteria |
|----------|----------|
| High | Security, governor limits, data integrity |
| Medium | Performance, best practices |
| Low | Style, minor improvements |

## 관련 노트
- [[external-diagram-visual-generate]]
- [[lwc-review]]
- [[interview-questions]]
