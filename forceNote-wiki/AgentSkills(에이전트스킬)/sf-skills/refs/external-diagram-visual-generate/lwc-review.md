---
tags: [agent-skill, sf-skills, reference, diagram, visual, code-review]
source: forcedotcom/sf-skills (skills/external-diagram-visual-generate/assets/review/lwc-review.md, 공식 Salesforce)
created: 2026-06-27
aliases: [LWC Code Review Template, LWC 코드 리뷰 템플릿, Gemini LWC 리뷰]
---
# LWC Code Review Template — LWC 코드 리뷰 템플릿
> Gemini 서브에이전트로 Lightning Web Component를 접근성·성능·보안·Salesforce 패턴 관점에서 리뷰하기 위한 프롬프트.

## Gemini Review Prompt

```
Review this Lightning Web Component for best practices:

JAVASCRIPT:
[paste JS code]

HTML TEMPLATE:
[paste HTML code]

REVIEW CATEGORIES:

1. ACCESSIBILITY (A11Y)
   - ARIA labels and roles
   - Keyboard navigation
   - Screen reader compatibility

2. PERFORMANCE
   - Wire service usage
   - Rendering optimization
   - Event handling

3. SECURITY
   - Locker Service compliance
   - XSS prevention

4. BEST PRACTICES
   - Component lifecycle
   - Error handling
   - Data binding

5. SALESFORCE PATTERNS
   - Lightning Data Service
   - Navigation service
   - Toast notifications

OUTPUT FORMAT:
JSON with summary, issues array, accessibility score, and overall score
```

## Usage

```bash
gemini "Review this LWC component: [paste code]" -o json
```

## 관련 노트
- [[external-diagram-visual-generate]]
- [[apex-review]]
- [[interview-questions]]
