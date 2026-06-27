---
tags: [agent-skill, sf-skills, reference, diagram, visual, erd]
source: forcedotcom/sf-skills (skills/external-diagram-visual-generate/assets/erd/custom-objects.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Custom Objects ERD, 커스텀 객체 ERD, 커스텀 오브젝트 다이어그램]
---
# ERD Template: Custom Objects — 커스텀 객체 ERD 템플릿
> 커스텀 객체(표준/커스텀/외부) 관계를 색상 코딩과 관계 표기로 보여주는 ERD 생성 프롬프트 템플릿.

## Prompt Template

```
Professional Salesforce ERD diagram showing custom objects:

OBJECTS:
[List custom objects with relationships]

COLOR CODING:
- Standard Objects: Blue (#bae6fd fill, #0369a1 border)
- Custom Objects: Orange (#fed7aa fill, #c2410c border)
- External Objects: Green (#a7f3d0 fill, #047857 border)

RELATIONSHIPS:
- Lookup (LK): Dashed arrow, optional parent
- Master-Detail (MD): Solid thick arrow, cascade delete

STYLING:
- Clean white background
- Pastel fill colors with dark borders
- Relationship labels on arrows
- Professional diagram layout
- Include color legend

FORMAT:
- Auto-layout based on relationships
- Primary objects centered
- Child objects positioned below/right of parents
```

## Example

```bash
# Draft at 1K (iterate here)
gemini --yolo "/generate 'Salesforce ERD for real estate app:
- Property__c (orange, center): Main custom object
- Listing__c (orange, right): Master-Detail to Property__c
- Showing__c (orange, below): Lookup to both Property__c and Contact

Orange boxes for custom objects, blue for standard (Contact).
Include legend. Professional style.'"
open ~/nanobanana-output/*.png  # Review and refine

# Final at 4K (when satisfied)
uv run scripts/generate_image.py \
  -p "Salesforce ERD for real estate app..." \
  -f "realestate-erd.png" \
  -r 4K
```

## Resolution Guide

| Phase | Resolution | Use Case |
|-------|------------|----------|
| Draft | 1K (CLI) | Quick iteration, prompt refinement |
| Final | 4K (Python) | Documentation, presentations |

**Tip**: Iterate at 1K until layout is correct, then generate 4K final.

## 관련 노트
- [[external-diagram-visual-generate]]
- [[core-objects]]
- [[architect-aesthetic-guide]]
