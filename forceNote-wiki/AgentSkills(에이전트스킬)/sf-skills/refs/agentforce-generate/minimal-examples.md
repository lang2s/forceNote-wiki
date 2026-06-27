---
tags: [agent-skill, sf-skills, reference, agentforce, minimal-examples]
source: forcedotcom/sf-skills (skills/agentforce-generate/references/minimal-examples.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Minimal Working Examples, 최소 동작 예제, hello-world agent script]
---

# Minimal Working Examples — 최소 동작 Agent Script 예제

> 단일 서브에이전트·액션·조건부 로직을 가진 완전하고 배포 가능한 Hello-World Agent Script 예제와 핵심 포인트.

---

# Minimal Working Examples

Complete, deployable agent examples with single subagents, actions, and conditional logic.

---

## Hello-World Agent Script

A complete, deployable agent with one subagent, one action, and conditional logic:

```agentscript
system:
    messages:
        welcome: "Hello! How can I help you today?"
        error: "Sorry, something went wrong."
    instructions: "You are a helpful customer service agent."

config:
    developer_name: "simple_agent"
    description: "A minimal working agent example"
    agent_type: "AgentforceServiceAgent"
    default_agent_user: "agent_user@yourorg.com"

variables:
    customer_verified: mutable boolean = False

start_agent entry:
    description: "Entry point for all conversations"
    reasoning:
        instructions: |
            Greet the customer and route to the main subagent.
        actions:
            go_main: @utils.transition to @subagent.main
                description: "Navigate to main conversation"

subagent main:
    description: "Main conversation handler"
    reasoning:
        instructions: ->
            if @variables.customer_verified == True:
                | You are speaking with a verified customer.
                | Help them with their request.
            else:
                | Please verify the customer's identity first.
        actions:
            verify: @actions.verify_customer
                description: "Verify customer identity"
                set @variables.customer_verified = @outputs.verified
    actions:
        verify_customer: apex://VerifyCustomerAction
            description: "Verify customer identity"
            inputs:
                customer_id: string
                    label: "Customer ID"
            outputs:
                verified: boolean
                    label: "Verified"
```

### Key Points

- **`config` block**: `developer_name` must match the folder name (case-sensitive)
- **`default_agent_user`**: Must be a valid Einstein Agent User in the target org — query with `sf data query`
- **`instructions: ->`**: Procedural mode enables `if`/`else` and `run` directives
- **`instructions: |`**: Literal mode for static text passed to the LLM
- **`set @variables.X = @outputs.Y`**: Captures action output into mutable state
- **`@utils.transition`**: Permanent handoff (does not return to calling subagent)

## 관련 노트
- [[agentforce-generate]]
- [[agentforce-generate/examples|examples]]
