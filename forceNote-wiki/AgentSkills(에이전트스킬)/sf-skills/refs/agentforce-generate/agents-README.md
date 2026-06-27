---
tags: [agent-skill, sf-skills, reference, agentforce, templates]
source: forcedotcom/sf-skills (skills/agentforce-generate/assets/agents/README.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Complete Agent Templates, 완성형 에이전트 템플릿, 배포 가능한 에이전트 예제]
---

# Complete Agent Templates — 완성형(배포 가능한) 에이전트 템플릿

> `assets/agents/` 폴더의 완전하고 배포 가능한 에이전트 템플릿 학습 경로(hello-world → production-faq), 빠른 시작 명령, 그리고 모든 에이전트가 가져야 하는 필수 블록 순서.

---

Templates for building complete, deployable agents.

## Learning Path

| Template | Complexity | Description |
|----------|------------|-------------|
| `hello-world.agent` | Beginner | Minimal viable agent - start here |
| `simple-qa.agent` | Beginner | Single-subagent Q&A agent |
| `multi-subagent.agent` | Intermediate | Multi-subagent routing agent |
| `production-faq.agent` | Advanced | Production-ready FAQ with escalation |

## Quick Start

1. Copy a template to your SFDX project:

```bash
mkdir -p force-app/main/default/aiAuthoringBundles/My_Agent
cp hello-world.agent force-app/main/default/aiAuthoringBundles/My_Agent/My_Agent.agent
cp ../metadata/bundle-meta.xml force-app/main/default/aiAuthoringBundles/My_Agent/My_Agent.bundle-meta.xml
```

2. Validate and deploy:

```bash
sf agent validate authoring-bundle --json --api-name My_Agent --target-org your-org
sf agent publish authoring-bundle --json --api-name My_Agent --target-org your-org
```

## Required Blocks

Every agent must have these blocks **in this order**:

| Block | Purpose |
|-------|---------|
| `system:` | Agent personality and default messages |
| `config:` | Deployment metadata (agent_name, label, etc.) |
| `variables:` | Data connections and state storage |
| `language:` | Locale configuration |
| `start_agent` | Entry point subagent (exactly one required) |

## Next Steps

- [components/](../components/) - Reusable action and subagent templates
- [patterns/](../patterns/) - Advanced patterns for complex behaviors
- [metadata/](../metadata/) - XML metadata templates

## 관련 노트
- [[agentforce-generate]]
- [[README-legacy]]
- [[patterns-README]]
