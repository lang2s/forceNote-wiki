---
tags: [agent-skill, sf-skills, reference, agentforce, feature-validity]
source: forcedotcom/sf-skills (skills/agentforce-generate/references/feature-validity.md, 공식 Salesforce)
created: 2026-06-27
aliases: [Feature Validity by Context, 컨텍스트별 기능 유효성, action metadata properties]
---

# Feature Validity by Context — 컨텍스트별 액션 메타데이터 유효성

> 많은 액션 메타데이터 속성은 `target:`을 가진 액션 정의에서는 유효하지만 `@utils.transition` 같은 유틸리티 액션에서는 무효다. 어떤 속성이 어디서 동작하는지 정리한다.

---

<!-- Parent: adlc-author/SKILL.md -->

# Feature Validity by Context

> **Key distinction**: Many action metadata properties are valid on **action definitions with targets** (`flow://`, `apex://`) but NOT on **utility actions** (`@utils.transition`).

| Feature | On `@utils.transition` | On action definitions with `target:` | Notes |
|---------|------------------------|---------------------------------------|-------|
| `label:` on subagents | ❌ | ✅ | Valid on subagent blocks |
| `label:` on actions | ❌ | ✅ | Valid on Level 1 action definitions |
| `label:` on I/O fields | ❌ | ✅ | Valid on inputs/outputs |
| `require_user_confirmation:` | ❌ | ✅ | Compiles; runtime no-op |
| `include_in_progress_indicator:` | ❌ | ✅ | Shows spinner during action execution |
| `progress_indicator_message:` | ❌ | ✅ | Works on both `flow://` and `apex://` |
| `output_instructions:` | ❌ | ❓ Untested | Not tested on target-backed actions |
| `always_expect_input:` | ❌ | ❌ | NOT implemented anywhere |

**What works on `@utils.transition` actions:**
```yaml
actions:
   go_next: @utils.transition to @subagent.next
      description: "Navigate to next subagent"   # ✅ ONLY description works
```

**What works on action definitions with `target:`:**
```yaml
actions:
   process_order:
      label: "Process Order"                            # ✅ Display label
      description: "Process the customer's order"       # ✅ LLM description
      require_user_confirmation: True                   # ✅ Compiles (runtime issue)
      include_in_progress_indicator: True               # ✅ Shows spinner
      progress_indicator_message: "Processing..."       # ✅ Custom spinner message
      inputs:
         order_id: string
            label: "Order ID"                           # ✅ I/O display label
            description: "The order identifier"
      outputs:
         status: string
            label: "Order Status"                       # ✅ I/O display label
            description: "Current order status"
      target: "apex://OrderProcessor"
```

## 관련 노트
- [[agentforce-generate]]
- [[complex-data-types]]
