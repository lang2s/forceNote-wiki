---
tags: [agent-skill, sf-skills, reference, diagram, visual, lwc]
source: forcedotcom/sf-skills (skills/external-diagram-visual-generate/assets/lwc/dashboard-card.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Dashboard Card Mockup, 대시보드 카드 목업, LWC 대시보드 타일]
---
# LWC Template: Dashboard Card Mockup — 대시보드 카드 목업 템플릿
> SLDS 대시보드 카드/타일(메트릭·차트·리스트·진행률) 목업을 생성하기 위한 프롬프트 템플릿과 예시.

## Prompt Template

```
Salesforce Lightning dashboard card/tile mockup:

CARD TYPE: [metric/chart/list/progress]

METRIC CARD:
- Large metric value
- Label below
- Trend indicator: up/down arrow with percentage
- Sparkline mini chart (optional)
- Icon in corner

CHART CARD:
- Chart type: [bar/line/pie/donut]
- Legend position
- Data labels on hover

LIST CARD:
- Title with "View All" link
- 3-5 list items
- Each item: icon, primary text, secondary text

STYLING:
- SLDS card component
- White background with subtle shadow
- Rounded corners
- Header with title and action menu
```

## Example: Metric Card

```bash
gemini "/generate 'Salesforce dashboard metric card:
- Large number: $1.2M
- Label: Total Pipeline Value
- Trend: +12% (green up arrow)
- Icon: Opportunity icon (top-right)
- Sparkline: Show 7-day trend mini chart

Style: SLDS card, white background, subtle shadow'"
```

## 관련 노트
- [[external-diagram-visual-generate]]
- [[data-table]]
- [[record-form]]
