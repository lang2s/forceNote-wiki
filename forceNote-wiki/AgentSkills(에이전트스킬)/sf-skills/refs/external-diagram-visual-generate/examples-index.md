---
tags: [agent-skill, sf-skills, reference, diagram, visual, examples]
source: forcedotcom/sf-skills (skills/external-diagram-visual-generate/references/examples-index.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Examples Index, 예시 모음, 다이어그램 예시 프롬프트]
---
# Examples — 예시 프롬프트 모음
> external-diagram-visual-generate 스킬의 ERD·LWC 목업·아키텍처 예시 프롬프트와 출력 위치.

<!-- Parent: external-diagram-visual-generate/SKILL.md -->

Example prompts and outputs for external-diagram-visual-generate.

## ERD Examples

```bash
# Basic CRM ERD
gemini --yolo "/generate 'Salesforce ERD diagram: Account (blue), Contact (green), Opportunity (yellow). Show relationships with arrows. Clean white background.'"

# Custom Object ERD
gemini --yolo "/generate 'ERD diagram for custom objects: Project__c, Task__c, Resource__c. Master-detail and lookup relationships shown.'"
```

## LWC Mockup Examples

```bash
# Data Table Mockup
gemini --yolo "/generate 'Lightning datatable mockup showing Account records with columns: Name, Industry, Annual Revenue. Include search bar and pagination.'"

# Record Form Mockup
gemini --yolo "/generate 'Salesforce Lightning record form for Contact object. Show Name, Email, Phone, Account lookup fields.'"
```

## Architecture Examples

```bash
# Integration Flow
gemini --yolo "/generate 'Integration architecture diagram: Salesforce to ERP sync via MuleSoft. Show Platform Events, Named Credentials, External Services.'"
```

## Output Location

Generated images are saved to `~/nanobanana-output/`

## 관련 노트
- [[external-diagram-visual-generate]]
- [[iteration-workflow]]
- [[interview-questions]]
