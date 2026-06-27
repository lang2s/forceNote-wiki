---
tags: [agent-skill, sf-skills, reference, diagram, visual, lwc]
source: forcedotcom/sf-skills (skills/external-diagram-visual-generate/assets/lwc/data-table.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Data Table Mockup, 데이터 테이블 목업, lightning-datatable 목업]
---
# LWC Template: Data Table Mockup — 데이터 테이블 목업 템플릿
> lightning-datatable 스타일의 LWC 데이터 테이블 목업을 생성하기 위한 프롬프트 템플릿과 예시.

## Prompt Template

```
Salesforce Lightning Web Component data table mockup:

COMPONENT: lightning-datatable style

HEADER:
- Component title: "[Title]"
- Search box (right-aligned)
- Action buttons: New, Refresh, Export

COLUMNS:
[List columns with types]

SAMPLE DATA:
- Show 5-7 sample rows with realistic data
- Include row selection checkboxes
- Show sorting arrows on sortable columns

STYLING:
- SLDS (Salesforce Lightning Design System)
- Zebra striping on rows
- Hover highlight
- Blue header bar
- White background

ACTIONS:
- Row-level action menu (three dots)
- Bulk action buttons when rows selected

FORMAT:
- Desktop view (1200px width)
- Full component with card wrapper
- Include pagination footer
```

## Example

```bash
gemini "/generate 'Salesforce LWC data table mockup:
Title: Recent Opportunities
Columns:
1. Opportunity Name (link)
2. Account Name (text)
3. Amount (currency, right-aligned)
4. Stage (picklist badge)
5. Close Date (date)
6. Owner (user with avatar)

Sample data: Show 5 realistic opportunities
Include: Search, New button, row actions menu
Style: SLDS, professional, clean
Pagination: 1-5 of 127'"
```

## 관련 노트
- [[external-diagram-visual-generate]]
- [[record-form]]
- [[dashboard-card]]
