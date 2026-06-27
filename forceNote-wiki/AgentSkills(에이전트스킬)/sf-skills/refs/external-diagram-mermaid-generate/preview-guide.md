---
tags: [agent-skill, sf-skills, reference, diagram, mermaid, preview]
source: forcedotcom/sf-skills (skills/external-diagram-mermaid-generate/references/preview-guide.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Mermaid Preview Server Guide, Mermaid 미리보기 서버 가이드, 다이어그램 라이브 프리뷰]
---

# Mermaid Preview Server Guide — Mermaid 미리보기 서버 가이드
> 생성한 Mermaid 다이어그램을 localhost에서 실시간 반복 편집할 수 있도록 미리보기 서버를 시작·반복·종료하는 가이드.

---

<!-- Parent: external-diagram-mermaid-generate/SKILL.md -->
# Mermaid Preview Server Guide

After generating the diagram, offer the user a localhost preview for real-time iteration.

## Start Preview

1. Save Mermaid code to temporary file:
   ```
   Write: /tmp/mermaid-preview.mmd
   [Mermaid code content]
   ```

2. Start preview server (runs in background):
   ```bash
   # From installed skill folder:
   python ../scripts/mermaid_preview.py start --file /tmp/mermaid-preview.mmd
   ```

3. Provide URL to user:
   > **Preview available**: http://localhost:8765
   >
   > The browser will auto-reload when you update the diagram.

## Iteration Workflow

- User views diagram in browser
- User requests changes ("make boxes pink", "add another node")
- You update `/tmp/mermaid-preview.mmd` using the Write tool
- Browser auto-reloads with new diagram (via SSE)
- Repeat until user is satisfied

## Stop Preview

When user is done:
```bash
python ../scripts/mermaid_preview.py stop
```

## Preview Server Features

- Live reload via Server-Sent Events (SSE)
- Dark/light theme auto-detection
- Copy Mermaid code button
- Download as SVG button
- Connection status indicator

## 관련 노트
- [[external-diagram-mermaid-generate]]
- [[mermaid-reference]]
- [[usage-examples]]
