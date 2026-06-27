---
tags: [agent-skill, sf-skills, reference, experience, ui-bundle, agentforce, agent-id]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-agentforce-client-generate/references/agent-id-resolution.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Agent ID Resolution, 에이전트 ID 확인, agentId, BotVersion 쿼리]
---

# Agent ID Resolution — 에이전트 ID 확인

> AgentforceConversationClient에 넘길 `agentId`를 SOQL(BotVersion 쿼리) 또는 Setup UI로 알아내고 검증하는 방법.

---

## SOQL Query

```bash
sf data query \
  --query "SELECT BotDefinition.Id, BotDefinition.DeveloperName, BotDefinition.MasterLabel, Status FROM BotVersion WHERE BotDefinition.AgentType = 'AgentforceEmployeeAgent' ORDER BY BotDefinition.CreatedDate ASC" \
  --json
```

- Queries `BotVersion` (not `BotDefinition`) because only `BotVersion` has the `Status` field (`Active` / `Inactive`)
- Filters on `AgentType = 'AgentforceEmployeeAgent'` to return only Employee Agents (excludes Service Agents)

## Response Structure

```json
{
  "status": 0,
  "result": {
    "records": [
      {
        "BotDefinition": {
          "Id": "0Xxxx0000000001CAA",
          "DeveloperName": "Property_Manager_Agent",
          "MasterLabel": "Property Manager Agent"
        },
        "Status": "Active"
      }
    ]
  }
}
```

## Activation Path

Agents cannot be activated programmatically:

> Setup → Agentforce Agents → click agent name → Agent Builder → Activate

## Manual Lookup (without sf CLI)

> Setup → Agentforce Agents → click agent name → copy ID from URL

## Validation

`agentId` must match: `^0Xx[a-zA-Z0-9]{15}$`

## 관련 노트
- [[experience-ui-bundle-agentforce-client-generate]]
- [[experience-ui-bundle-agentforce-client-generate/troubleshooting|troubleshooting]]
- [[constraints]]
