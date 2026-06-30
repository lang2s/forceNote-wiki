---
tags: [Agentforce, AgentScript, 패턴, 라우팅, 전환, transition, start_agent, 필수워크플로우, available-when]
source: AgentScriptDocs (Salesforce Agent Script Developer Guide, 2026-06-17판) — agent-script/patterns/ascript-patterns.md · ascript-patterns-topic-selector.md · ascript-patterns-transitions.md · ascript-patterns-required-flow.md
created: 2026-06-30
aliases: [Agent Router, agent router pattern, start_agent, transitions, "@utils.transition", required subagent workflow, conditional transition, 에이전트 라우터, 서브에이전트 전환, 필수 워크플로우, 조건 전환, "서브에이전트 간 이동 어떻게", "신원확인 강제 라우팅", "start_agent 라우팅 패턴"]
---

# Agent Script 패턴 — 라우팅·전환·필수 워크플로우

> 에이전트의 진입점(`start_agent`)에서 서브에이전트로 라우팅하고, `@utils.transition to`/조건 전환으로 실행을 이동하며, 필수 단계(신원확인 등)를 강제하는 Agent Script 패턴 모음.

---

## 개요 — Agent Script 공통 패턴

> This section provides common patterns for building agents with Agent Script. Each pattern focuses on a specific technique you can use to make your agents more reliable and effective.

각 패턴은 에이전트를 더 신뢰성 있고 효과적으로 만드는 한 가지 기법에 집중한다. 이 노트는 그중 **진입점→이동→강제** 흐름에 해당하는 세 패턴(Agent Router · Transitions · Required Subagent Workflow)과 패턴 일반 지침을 다룬다. 나머지 패턴(액션 체이닝·조건·데이터 페치·필터링)은 짝 노트 [[Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링]]에 있다.

### About Script and Canvas View

> These patterns are written in Agent Script as it appears in Script view, so you can easily reuse them in your own agent by copying and pasting. However, the patterns apply in Canvas view, as well.

모든 패턴은 Script view 기준 Agent Script로 작성되어 그대로 복사·붙여넣기로 재사용할 수 있으며, Canvas view에서도 동일하게 적용된다.

> **시각 자료:** 원본 문서에는 Script view와 Canvas view를 나란히 보여주는 이미지(`agent-script-patterns-example.png`, 캡션 "Script and Canvas views")가 있다. 본 위키에는 텍스트 설명만 두며 이미지는 재현하지 않는다.

### 패턴 일반 지침 (General Guidance) — 4원칙 전수

> When building agents with Agent Script, keep these principles in mind:

- **Start with simple reasoning instructions.** Start with the fewest instructions necessary for an agent to perform as expected. Add instructions as needed as you preview user conversations for different use cases, and then test for regressions between each change.
- **Use good names and descriptions.** Clear names for subagents, actions, and variables help your agent make better decisions.
  - Good names and descriptions are specific, distinct, and clearly related to the agent's task.
  - Review names and descriptions for other subagents, actions, and variables in your agent to ensure that the names and descriptions are distinct and don't overlap.
  - Use plain language that end users are likely to use and understand, not technical terms. This makes it easier for the agent to match a user's question or request to a relevant subagent, action, or variable.
  - Use language consistently throughout. When language is ambiguous, an agent can apply instructions inconsistently or incorrectly. For example, instead of naming an action "Get Client Info" and naming another action "Verify Customer," use the term "customer" in both.
- **Add determinism strategically**. Balance natural language instruction with deterministic logic expressions to get the most out of your agent's capabilities. Add logic for business workflows to increase predictable behavior.
- **Reference resources directly in reasoning instructions**. "@ mention" references to subagents, actions, and variables to give the LLM explicit guidance. References to resources increase the likelihood that your agent will use the resource as intended.

### Available Patterns — 12 패턴 카탈로그 (★ 라우팅 허브)

원본 "Available Patterns" 표 전 행을 옮기고, 각 패턴이 어느 위키 노트에 정리되어 있는지 매핑 열을 추가했다.

| Pattern | Description | 위키 노트 |
|---|---|---|
| Action Chaining & Sequencing | Run multiple actions in a guaranteed sequence | [[Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링]] (N7) |
| Agent Router | Set up effective subagent routing in the `start_agent` block | 이 노트 |
| Conditionals | Use if/else logic to control instructions, actions, and transitions | [[Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링]] (N7) |
| Context Engineering | Apply context engineering strategies with your Agentforce agents | 외부 help.salesforce 문서 (`ai.agent_context_engineering.htm`) |
| Fetch Data | Run actions to retrieve data before the LLM begins reasoning | [[Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링]] (N7) |
| Filtering with Available When | Control when subagents and actions are visible to the reasoning engine | [[Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링]] (N7) |
| Required Subagent Workflow | Guarantee users pass through required steps before proceeding | 이 노트 |
| Resource References | Reference variables and actions directly in reasoning instructions | [[Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드]] (N8) |
| System Overrides | Override global system instructions to change behavior per subagent | [[Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드]] (N8) |
| Transitions | Move execution between subagents with `@utils.transition to` | 이 노트 |
| Variables | Store and use state effectively across subagents | [[Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드]] (N8) |
| Variables (List) | Store variables in a list, also called a collection. Use a variable from your list just like a regular variable. Use an index to iterate through your list. | [[Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드]] (N8) |

관련 리소스(원본 Resources 섹션): An Agentforce Guide to Context Engineering (`ai.agent_context_engineering.htm`) · Agent Script Examples · Agent Script Reference.

---

## 패턴: Agent Router (서브에이전트 라우팅)

### 목적 / 왜 쓰나

> The agent router is the `start_agent` block that serves as the entry point for your agent.
>
> The agent router (also described as the `start_agent` subagent in Agent Script) controls your agent's entry point and routing logic. Keep it focused on essential subagents and use clear descriptions, filtering, and conditional transitions to guide users to the right place.

**Why Use This Pattern**

> Every user utterance begins at the `start_agent` subagent. It welcomes users, classifies intent, routes to appropriate subagents, and controls which subagents are available based on user state. A well-structured agent router ensures that your users get to the right subagent as effectively as possible.

> **Pattern Example**: A customer service agent's agent router forces unverified users through identity verification, then routes verified users to Order Management, Returns, or Escalation based on their intent.

### 기본 구조 (Basic Structure)

> The `start_agent` subagent has the same structure as any other subagent. However, it's usually geared towards effective and efficient subagent routing.

```agentscript
start_agent agent_router:
  description: "Welcome the user and determine the appropriate subagent based on user input"

  reasoning:
    instructions: ->
      | Select the best tool to call based on conversation history and user's intent.

    actions:
      go_to_orders: @utils.transition to @subagent.Order_Management
        description: "Handles order lookup, refunds, and order updates."

      go_to_faq: @utils.transition to @subagent.General_FAQ
        description: "Handles FAQ lookup and provides answers to common questions."

      go_to_escalation: @utils.transition to @subagent.Escalation
        description: "Escalate to a human representative."
```

### 효과적인 서브에이전트 설명 (Effective Subagent Descriptions)

> Good descriptions help your agent select the best subagent. Be specific about what each subagent handles.

```agentscript
actions:
  go_to_order: @utils.transition to @subagent.Order_Management
    description: "Handles order lookup, refunds, order updates, and summarizes status, order date, current location, delivery address, items, and driver name."

  go_to_returns: @utils.transition to @subagent.Returns
    description: "Processes return requests for orders within the 60-day return window."

  go_to_billing: @utils.transition to @subagent.Billing
    description: "Handles billing inquiries, payment issues, and invoice questions."
```

### 그 외 라우터 전략 (산문 전수)

- **Selective Subagent References** — Remove references to a subagent if you want the subagent to be accessible only via transitions from other subagents.
- **Subagent Gating** — You can gate and control flow using `available when` filters. (필터링 예시는 [[Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링]]의 Filtering 패턴 참조.)
- **Deterministic Routing** — For critical routing decisions, use conditional transitions in instructions instead of relying on the LLM to choose the right flow. (아래 Required Subagent Workflow 패턴 참조.)
- **Effective Transitions** — For more on how to effectively transition to another subagent, see the Transitions Pattern (아래 섹션).
- **Changing the Start Subagent** — By default, the agent router is defined as the starting subagent in your agent's Agent Script. In other words, this is the subagent that uses the `start_agent` prefix instead of the `subagent` prefix. However, you can define another subagent as the starting subagent instead (in Agent Script, the new subagent becomes the `start_agent` subagent). You can choose to use the agent router to move to subagent classification later in the conversation, or you can remove the agent router from your agent altogether if you want to control subagent routing differently.

### Tips (5개 전수)

- **Limit subagents**: Start with essential subagents and add more gradually as needed. Fewer subagents means clearer routing decisions for your agent.
- **Use the `go_to_` prefix**: Name transition actions with a `go_to_` prefix (for example, `go_to_orders`) so the agent understands they navigate to other subagents.
- **Write detailed descriptions**: Use detailed and unique descriptions so the agent knows when to choose a subagent, especially if you have similar subagents.
- **Hide subagents based on context**: Use `available when` to control subagent visibility.
- **Conditional logic**: Use conditional logic to guarantee that routing occurs before other processing.

---

## 패턴: Subagent Transitions (서브에이전트 전환)

### 목적 / 왜 쓰나

> Move execution from one subagent to another using the `@utils.transition to` command.
>
> Transitions move execution from one subagent to another. You can expose them as reasoning actions (sometimes described as tools in the developer guide) for the LLM to select, execute them deterministically with conditionals, or chain them after actions complete.

**Why Use This Pattern**

> Transitions route users to specialized subagents based on their needs. They're one way—when a transition occurs, Agentforce discards any prompt from the current subagent and processes the new subagent instead.

> **Pattern Examples**: When a user asks about a refund, transition them from the General FAQ subagent to the specialized Returns subagent. Or, after validating a user's identity, automatically transition to the Order Management subagent to continue the conversation.

전환은 **단방향(one-way)** 이다. 전환이 발생하면 현재 서브에이전트의 프롬프트는 폐기되고 새 서브에이전트가 처리된다. (실행 흐름 동작은 [[Agent Script 실행 흐름과 모델 설정]] 참조.)

### Reasoning Transitions (LLM 추론 기반)

> The following transitions can occur based on the LLM's reasoning. Deterministic transitions are described in the next section.

**Transitions in Reasoning Actions** — Expose transitions as reasoning actions (tools) that the LLM can choose to use.

```agentscript
start_agent agent_router:
  description: "Welcome the user and determine the appropriate subagent"

  reasoning:
    instructions: ->
      | Welcome the user and analyze their input to determine
        the most appropriate subagent to handle their request.

    actions:
      go_to_order: @utils.transition to @subagent.Order_Management
        description: "Handles order lookup, refunds, order updates."

      go_to_faq: @utils.transition to @subagent.General_FAQ
        description: "Handles FAQ lookup and common questions."

      go_to_escalation: @utils.transition to @subagent.Escalation
        description: "Escalate to a human representative."
```

**Filtered Transitions** — Combine transitions with `available when` to control which subagents are accessible.

```agentscript
reasoning:
  actions:
    go_to_identity: @utils.transition to @subagent.Identity
      description: "Verifies user identity"
      available when @variables.verified == False

    go_to_order: @utils.transition to @subagent.Order_Management
      description: "Handles order management"
      available when @variables.verified == True
```

**Transitions in Instructions (Reference Transitions)** — When exposing transitions as reasoning actions (tools), reference them in your prompt so the LLM knows when to use them.

```agentscript
reasoning:
  instructions: ->
    | If the user asks for a service agent or seems upset,
      go to {!@actions.go_to_escalation}.

  actions:
    go_to_escalation: @utils.transition to @subagent.Escalation
      description: "Escalate if requested or needed."
```

### Deterministic Transitions (결정적 전환)

> The following transitions occur deterministically based on your instructions. Reasoning transitions are described in the previous section.

> [!note]
> Transitions in reasoning instructions don't use the `@utils.` prefix.

> ⚠️ **`@utils.` 접두사 유무가 핵심 구분이다.** Reasoning **action**(tool)으로 노출되는 전환은 `@utils.transition to ...`로 쓰지만, reasoning **instruction** 내부의 결정적 전환은 `transition to ...`처럼 `@utils.` 접두사 **없이** 쓴다.

**Conditional Transitions in Reasoning Instructions** — Deterministically route users based on state or business rules.

```agentscript
reasoning:
  instructions: ->
    if @variables.loyalty_tier == "Platinum VIP":
      transition to @subagent.vip_support
```

> The transition happens before the LLM processes any other instructions.

**Transition After Action** — Chain a transition after an action completes.

```agentscript
reasoning:
  instructions: ->
    | Call {!@actions.validate_user_ready} to check if the user is ready.

  actions:
    validate_user_ready: @actions.validate_user_ready
      with user_id=@variables.user_id
      transition to @subagent.analyze_issue
```

### Tips

**Reasoning Transition Tips**

- **Use descriptive subagent names**: Names should clearly indicate the subagent's purpose.
- **Provide clear descriptions**: Help the LLM understand when to use each transition.
- **Use the `go_to_` prefix**: Name transition actions with a `go_to_` prefix (for example, `go_to_orders`) so the agent understands they navigate to other subagents.
- **Reference transitions in prompt**: When exposing transitions as reasoning actions, you can reference them in your prompt (for example, `{!@actions.go_to_escalation}`) so the LLM knows when to use them.

**Deterministic Transition Tips**

- **Use deterministic transitions sparingly**: Only when you need guaranteed routing; otherwise let the LLM choose.
- **Place transitions first**: When using conditional transitions, put them at the top of instructions so they execute before any other instructions. If the agent transitions to another subagent before reasoning, no prompt is sent to the LLM. Prior instructions aren't used or preserved, so executing them just increases latency and (in the case of running an action) can incur costs.
- **Avoid transition loops**: Ensure your subagent flow doesn't create infinite loops. For example, you don't want to introduce some logic that causes a transition from subagent A to subagent B but also causes a transition from subagent B back to A, and then repeat.

---

## 패턴: Required Subagent Workflow (필수 워크플로우 강제)

### 목적 / 왜 쓰나

> Use conditional transitions to guarantee users pass through required steps before accessing other features.
>
> Use conditional transitions at the top of your instructions to force users through required steps. Unlike filtering with `available when`, these transitions execute immediately and guarantee the routing behavior.

**Why Use This Pattern**

- Use filtering (`available when`) when you want to remove options.
- Use the required flow pattern (also described as a "conditional transition") when users must complete a step before anything else occurs.
- Use Enforce Required Workflows Through Subagents In Multi Turn Conversations to enforce step-by-step sequencing across conversation turns. This pattern ensures a required workflow through subagents, where the next subagent depends on a customer's response to a previous subagent. (multi-turn 패턴은 [[Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드]]의 "멀티턴 워크플로우 강제" 참조.)

### 접근 방식 비교표 (3행 전수)

| Approach | When to Use |
|---|---|
| `available when` | Control which reasoning actions are available; LLM chooses among them |
| Conditional transition | Require users to complete a step; no LLM choice |
| Enforce Required Workflows Through Subagents In Multi Turn Conversations | Enforce step-by-step sequencing through subagents while handling multiple conversation turns in each subagent |

> For critical flows like identity verification, a conditional transition in instructions is more reliable than `available when` filtering alone. While filtering restricts options, it doesn't enforce workflows. For example, instead of prompting the user to verify their identity, the agent can exclusively choose options that don't require user verification. A conditional transition guarantees the workflow before any reasoning takes place.

> **Pattern Examples**:
> - Force unverified users through identity verification before they can access order management, returns, or any other sensitive subagents.
> - Ensure order return subagents ask the correct next question based on previous answers, and that all required questions are asked.

### Required Flow for All Subagents

> To require a subagent flow before a user can move to any other subagents, in the agent router, place a conditional transition at the top of your instructions. If the condition is met, the transition happens immediately before any other processing.

```agentscript
start_agent agent_router:
  description: "Welcome the user and route to the appropriate subagent"

  reasoning:
    instructions: ->
      # Check for condition
      if @variables.verified == False:

        # Required transition to a subagent
        transition to @subagent.Identity

      # Subsequent processing that only occurs
      # if condition ISN'T met…
      | Select the best tool to call based on conversation history and user's intent.

    actions:
      go_to_orders: @utils.transition to @subagent.Order_Management
        description: "Handles order lookup, refunds, and order updates."

      go_to_faq: @utils.transition to @subagent.General_FAQ
        description: "Handles FAQ lookup and common questions."

      go_to_escalation: @utils.transition to @subagent.Escalation
        description: "Escalate to a human representative."
```

> Unverified users are immediately routed to the Identity subagent. No subagent classification takes place and no prompt is sent to the LLM. After the user completes verification with the Identity subagent, the process starts over. Because the Verified variable is now set to True, the conditional is satisfied. The agent can proceed through the remaining instructions and the other subagents in the agent router are available to the user.

### Required Flow for a Single Subagent

> This pattern works in any subagent, not just the agent router. Use it when an individual subagent requires a prerequisite.

```agentscript
subagent Order_Management:
  description: "Handle order inquiries and updates"

  reasoning:
    instructions: ->
      # Check for condition
      if @variables.order_id is None:

        # Required transition to a subagent
        transition to @subagent.Order_Lookup

      # Subsequent processing that only occurs
      # if condition ISN'T met…
      | Help the user with their order {!@variables.order_id}.
```

> ⚠️ 여기서 `if @variables.order_id is None:`은 **미할당(unassigned) 값**을 검사한다. 빈 문자열(`== ""`, 유효한 할당값)과는 다르다. `is None` vs `== ""` 구분은 [[Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링]]의 Conditionals Tips 참조.

### Use Step Variables to Select a Subagent

> This pattern works in any subagent, particularly in the agent router. Use it to enforce a complex subagent workflow throughout multi-turn conversations.

원본은 별도 예제 문서 "Agent Script Example: Use Step Variables to Enforce Subagent Workflows"(multi-turn 예제)를 참조한다 — [[Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드]]의 "멀티턴 워크플로우 강제" 패턴 참조.

### Tips (3개 전수)

- **Use the `go_to_` prefix**: Name transition actions with a `go_to_` prefix (for example, `go_to_orders`, `go_to_faq`) so the LLM understands they navigate to other subagents.
- **Place required flows first**: Put conditional transitions at the top of instructions so they execute before any other instructions. If the agent transitions to another subagent before reasoning, no prompt is sent to the LLM. Prior instructions aren't used or preserved, so executing them just increases latency and (in the case of running an action) can incur costs.
- **Use descriptive names**: Avoid generic names like `tool1` or `action2`; use names that describe the destination or purpose.

---

## 관련 노트

- [[Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링]] — 짝 노트(액션 체이닝·조건·페치·필터링 패턴)
- [[Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드]] — 짝 노트(변수·리스트·리소스 참조·시스템 오버라이드·멀티턴), 이 카탈로그의 나머지 5패턴
- [[Agent Script 실행 흐름과 모델 설정]] — 전환 시 실행 흐름·프롬프트 폐기 동작
- [[Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법)]] — `@utils.transition` 문법, reasoning action(tool) 정의
- [[Agent Script 블록 8종 (System·Config·Subagent 등)]] — `start_agent`·`subagent` 블록
- [[Agent Script 개요와 언어 특성]] — Agent Script 언어 일반
- [[스킬 ↔ 위키 토픽 맵]] — sf-skill ↔ 위키 디스패처
