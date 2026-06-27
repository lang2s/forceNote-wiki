---
tags: [agent-skill, sf-skills, reference, diagram, visual, lwc]
source: forcedotcom/sf-skills (skills/external-diagram-visual-generate/assets/lwc/record-form.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Record Form Mockup, 레코드 폼 목업, lightning-record-form 목업]
---
# LWC Template: Record Form Mockup — 레코드 폼 목업 템플릿
> lightning-record-form 스타일의 LWC 레코드 폼 목업을 생성하기 위한 프롬프트 템플릿과 예시.

## Prompt Template

```
Salesforce Lightning Web Component record form mockup:

COMPONENT: lightning-record-form style

HEADER:
- Object icon and label
- Edit/Save/Cancel buttons (right)
- Record name as title

LAYOUT:
- Two-column layout for desktop
- Responsive single column for mobile

SECTIONS:
[Define sections with fields]

FIELD TYPES:
- Text inputs with labels above
- Picklists as dropdown
- Lookups with search icon
- Date pickers with calendar
- Currency with formatting
- Checkboxes for boolean

STYLING:
- SLDS record page styling
- Compact spacing
- Blue section headers
- Required field indicators (*)
- Help text icons where applicable
```

## Example

```bash
gemini "/generate 'Salesforce LWC record form mockup:
Object: Opportunity
Mode: Edit

Sections:
1. Opportunity Information:
   - Opportunity Name* (text)
   - Account Name* (lookup with search)
   - Type (picklist)
   - Lead Source (picklist)

2. Amount & Dates:
   - Amount (currency)
   - Close Date* (date picker)
   - Stage* (picklist)
   - Probability (percentage)

Footer: Save and Cancel buttons
Style: SLDS, professional, desktop view'"
```

## 관련 노트
- [[external-diagram-visual-generate]]
- [[data-table]]
- [[dashboard-card]]
