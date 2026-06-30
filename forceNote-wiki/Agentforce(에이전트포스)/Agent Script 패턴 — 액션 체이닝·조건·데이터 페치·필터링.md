---
tags: [Agentforce, AgentScript, 패턴, 액션체이닝, 조건, conditionals, fetch-data, 필터링, available-when, run-action]
source: AgentScriptDocs (Salesforce Agent Script Developer Guide, 2026-06-17판) — agent-script/patterns/ascript-patterns-action-chaining.md · ascript-patterns-conditionals.md · ascript-patterns-fetch-data.md · ascript-patterns-filtering.md
created: 2026-06-30
aliases: [action chaining, action sequencing, conditionals, if else, fetch data before reasoning, filtering with available when, 액션 체이닝, 액션 순차 실행, 조건문, 데이터 사전 페치, 필터링, "여러 액션 순서대로 실행", "조건에 따라 액션 실행", "추론 전 데이터 가져오기", "is None vs 빈 문자열", "available when 으로 액션 숨기기"]
---

# Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링

> 여러 액션을 보장된 순서로 연결하고, 조건문으로 인스트럭션·액션·전환을 결정적으로 제어하며, 추론 전에 데이터를 페치하고, `available when`으로 서브에이전트·액션 노출을 필터링하는 Agent Script 패턴 모음.

---

## 개요

이 노트는 Agent Script 공통 패턴 중 **프롬프트가 LLM에 전달되기 전에 결정적으로 실행되는** 네 가지 패턴을 다룬다.

- **Action Chaining & Sequencing** — 여러 액션을 보장된 순서로 실행
- **Conditionals** — `if`/`else`로 인스트럭션·액션·전환을 결정적으로 분기
- **Fetch Data Before Reasoning** — 추론 시작 전 액션으로 데이터를 가져옴
- **Filtering with Available When** — `available when`으로 서브에이전트·액션 노출 제어

이 네 패턴은 모두 reasoning instructions 안의 `run`/`if`/`available when`이 **프롬프트 구성 시점(LLM 전달 전)에 결정적으로 평가·실행**된다는 공통 메커니즘을 공유한다. 진입점 라우팅·전환·필수 워크플로우 패턴은 짝 노트 [[Agent Script 패턴 — 라우팅·전환·필수 워크플로우]]에 있다.

---

## 패턴: Action Chaining and Sequencing (액션 체이닝·순차)

### 목적 / 왜 쓰나

> Run multiple actions in a guaranteed sequence.
>
> Action chaining can be implemented in multiple ways depending on when and how you need actions to execute. You can run actions sequentially in instructions, chain reasoning actions, or combine actions with transitions and conditionals.

**Why Use This Pattern**

> Action sequencing ensures that one action can trigger another, creating reliable multi-step workflows without relying on the LLM to remember multiple steps.

> **Pattern Example**: Get the user's order with one action, then immediately check return eligibility for that order in another action.

### Sequential Actions in Instructions

> Call actions one after another in reasoning instructions. Both run deterministically before the prompt is sent to the LLM.

> [!note]
> When you run an action in instructions, you must manually set variables for the inputs and outputs because the action is run before any reasoning takes place. See Actions Reference.

```agentscript
reasoning:
  instructions: ->
    # First action
    run @actions.lookup_current_order
      with member_email=@variables.member_email
      set @variables.order_summary=@outputs.order_summary

    # Next action
    run @actions.lookup_current_user
      with member_email=@variables.member_email
      set @variables.user_profile=@outputs.profile

    | Show the user their order summary and welcome them by name.
```

> You can also store the output of one action in a variable, then use it as the input to another action, or as part of a subsequent prompt.

### Chained Actions in Reasoning Actions

> Define a follow-up action that automatically runs when the LLM calls an action.

```agentscript
reasoning:
  instructions: ->
    | If the user wants information, use {!@actions.my_action}.

  actions:
    my_action: @actions.my_action
      with foo=@variables.Foo
      set @variables.status = @outputs.status
      run @actions.other_action
        set @variables.some_other_result=@outputs.data
```

> Whenever the LLM calls `my_action`, the agent automatically runs `other_action` afterwards.

### Run Action Then Transition

> Run an action and then automatically transition to another subagent.

```agentscript
reasoning:
  instructions: ->
    | Call {!@actions.validate_user_ready} to check if the user is ready.

  actions:
    validate_user_ready: @actions.validate_user_ready
      with user_id=@variables.user_id
      set @variables.is_ready=@outputs.ready
      transition to @subagent.analyze_issue
```

### Conditional Chain

> Chain actions conditionally based on the results of previous actions.

```agentscript
reasoning:
  instructions: ->
    # First action
    run @actions.check_eligibility
      with user_id=@variables.user_id
      set @variables.is_eligible=@outputs.eligible

    # Condition
    if @variables.is_eligible == True:

      # Conditional action
      run @actions.fetch_offer_details
        with user_id=@variables.user_id
        set @variables.offer=@outputs.offer

      | Present the offer: {!@variables.offer}
    else:
      | Explain that the user is not eligible for this offer.
```

### Tips (2개 전수)

- **Use sequential instructions for deterministic flows**: When you always want actions to run in a specific order.
- **Use variables for action outputs**: If your second action needs an output from the first action, store the first action's outputs in a variable and assign it as an input to the second action.

---

## 패턴: Using Conditionals (조건문)

### 목적 / 왜 쓰나

> Use conditionals to deterministically control agent behavior based on variable values. Conditionals evaluate before the prompt reaches the LLM.

**Why Use This Pattern**

> Conditionals let you make deterministic decisions about which instructions are included in the prompt, which actions run, or which subagents to transition to. Conditionals don't rely on LLM interpretation.

> **Pattern Example**: Show Gold members a thank-you message and their points balance, while Platinum VIP members see an exclusive welcome with additional perks.

### Conditional Instructions

> Customize the prompt based on variable values.

```agentscript
reasoning:
  instructions: ->
    | Refer to the user by name {!@variables.member_name}.

    if @variables.loyalty_tier == "Gold":
      | Thank the customer for being a Gold member.

    if @variables.loyalty_tier == "Platinum VIP":
      | Thank the customer for being a Platinum VIP member.
```

> Only the relevant instruction is included in the prompt sent to the LLM.
>
> - Prompt sent to LLM if the customer's name is Jo Richards and they're a VIP member: `Refer to the user by Jo Richards. Thank the customer for being a Platinum VIP member.`
> - Prompt sent to the LLM if the customer's name is Jane Smith and they're a Gold member: `Refer to the user by Jane Smith. Thank the customer for being a Gold member.`

### Conditional Actions

> Run actions only when specific conditions are met. In this example, the agent only looks up the current order if we don't have an order summary, improving response time and reducing system usage.

```agentscript
reasoning:
  instructions: ->
    if @variables.order_summary == "":
      run @actions.lookup_current_order
        with member_email=@variables.member_email
        set @variables.order_summary = @outputs.order_summary

    | Show the user their order summary: {!@variables.order_summary}.
```

### Conditional Transitions

> Route users to different subagents based on conditions.

```agentscript
reasoning:
  instructions: ->
    if @variables.loyalty_tier == "Platinum VIP":
      transition to @subagent.vip_support
```

> The transition happens immediately, before the LLM processes any other instructions. See Required Subagent Flow ([[Agent Script 패턴 — 라우팅·전환·필수 워크플로우]]) for related patterns.

### If/Else Logic

> Handle mutually exclusive conditions with `if` and `else` logic.

```agentscript
reasoning:
  instructions: ->
    if @variables.order_summary.days_since_order <= 60:
      set @variables.return_eligibility = True
      | Offer to process return using {!@actions.create_return}.
    else:
      | Politely explain the return period has expired.
```

### Multiple Conditions (and/or)

> Keep in mind that you can combine conditions using `and` or `or`.

```agentscript
reasoning:
  instructions: ->
    if @variables.verified == True and @variables.is_business_hours == True:
      | You can escalate to a live representative if needed.
```

### Tips (3개 전수)

- **Initialize variables for reliable checks**: It's typically a good practice to give variables default values (for example, `= ""` or `= False`) so conditional checks work correctly.
- **Use `is None` for null checks**: Use `@variables.value is None` to check whether a variable has no value assigned. This check is different from checking for an empty string (`@variables.value == ""`), for example. The `== ""` expression checks for an empty string (which is a valid assignment), whereas `is None` checks for an unassigned value.
- **Use parentheses to control evaluation order**: Use parentheses `()` to explicitly group the conditionals you want evaluated together. For example, an action could have this `available when` condition:

```agentscript
          available when @variables.customerType == "Valued" and @variables.QualificationEnabled == True and (@variables.HasSalesInterest == True or @variables.WantsMeeting == True) and @variables.QualificationFlowStep != "COMPLETE"
```

> ⚠️ `is None`(미할당 값)과 `== ""`(빈 문자열, 유효한 할당값)은 서로 다른 검사다. 빈 문자열은 명시적으로 할당된 값이지만 `is None`은 값이 아예 할당되지 않은 상태를 검사한다. 같은 구분이 [[Agent Script 패턴 — 라우팅·전환·필수 워크플로우]]의 Required Flow(`if @variables.order_id is None:`)에서도 쓰인다.

---

## 패턴: Fetch Data Before Reasoning (추론 전 데이터 페치)

### 목적 / 왜 쓰나

> Run actions to retrieve data before the LLM begins reasoning.
>
> Place action calls at the top of your reasoning instructions to fetch data before the prompt is constructed. This ensures the LLM has access to current, accurate information when generating responses.

**Why Use This Pattern**

> Fetching before reasoning ensures the LLM has accurate, current data. For example, you can store the output of an action in a variable and use it to personalize instructions. Or you can create a filter based on the variable to refine the prompt that's sent to the LLM. Actions inside reasoning instructions execute **before** the prompt is sent to the LLM.

> **Pattern Example**: Look up the user's current order before the conversation starts so the agent can greet them with their order status and personalized recommendations.

### Basic Pattern

```agentscript
reasoning:
  instructions: ->

    # Check if data has been fetched
    if @variables.order_summary == "":

      # If not, fetch data with an action
      # (and store results in a variable)
      run @actions.lookup_current_order
        with member_email=@variables.member_email
        set @variables.order_summary=@outputs.order_summary

    # Reference the variable in the prompt
    | Refer to the user by name {!@variables.member_name}.
      Show them their current order summary: {!@variables.order_summary}.
```

> The pattern:
> 1. Check if data has already been fetched
> 2. If not, run the lookup action
> 3. Store results in a variable
> 4. Reference the variable in the prompt

### Fetch and Validate

> Fetch data and immediately check it to determine what options to present.

```agentscript
reasoning:
  instructions: ->
    if @variables.order_summary == "":
      run @actions.lookup_current_order
        with member_email=@variables.member_email
        set @variables.order_summary=@outputs.order_summary

    | If user wants to make a return:
    if @variables.order_summary.days_since_order <= 60:
      set @variables.return_eligibility = true
      | Offer to process return using {!@actions.create_return}.
    else:
      | Politely explain the return period has expired.
```

### Tips (1개 전수)

- **Avoid unnecessary calls**: Always check if data exists (`if @variables.data == ""`) before making a call to fetch data to avoid running actions unnecessarily.

---

## 패턴: Enforce Business Rules with Filters (필터링)

### 목적 / 왜 쓰나

> Use `available when` to control which subagents or actions are available to the LLM. If the conditions aren't met, the LLM can't access the subagent or reasoning action (also described as a tool in the developer guide).

**Why Use This Pattern**

> When your business conditions aren't met, this pattern allows you to hide the subagent or action entirely, simplifying the LLM's decision-making and enforcing business rules about feature availability. Without filtering, customers might convince the LLM to use features that aren't allowed. Or, the LLM might make reasoning errors during complex workflows and prolonged conversations, due to prompt noise and context drift. See Required Subagent Workflow ([[Agent Script 패턴 — 라우팅·전환·필수 워크플로우]]) for a related pattern.

> **Pattern Examples**:
> - Only enable the `create_return` action when the order is within the return window and verified—otherwise, hide it completely from the agent.
> - Only enable the `escalate` subagent for verified customers during business hours.

### Filter Subagents

> Control which subagents are available based on whether the user is verified.

```agentscript
start_agent agent_router:
  description: "Welcome the user and determine the appropriate subagent"

  reasoning:
    instructions: ->
      | Select the best tool to call based on conversation history and user's intent.

    actions:
      go_to_order: @utils.transition to @subagent.General_Info
          description: "Gives general information about products."
      go_to_order: @utils.transition to @subagent.Order_Management
          description: "Handles order lookup, refunds, order updates."
          available when @variables.verified == True
      go_to_escalation: @utils.transition to @subagent.Escalation
          description: "Handles escalation to a human rep."
          available when @variables.verified == True and @variables.is_business_hours == True
```

> 원문에서 첫 두 액션 키가 모두 `go_to_order`로 동일하게 표기됨 [sic] — 원문 충실 재현이며 임의 수정하지 않는다.

> In this example:
> - All users can access General Info.
> - Verified users can be routed to the Order Management.
> - Escalation requires verification **and** valid business hours.

### Filter Actions

> Make actions available only when business rules are satisfied.

```agentscript
reasoning:
  instructions: ->
    | Refer to the user by their name {!@variables.member_name}.
      Show the user their order summary: {!@variables.order_summary}.
      If the user wants to make a return, confirm their order ID and
      call {!@actions.create_return}. If returns are not eligible,
      explain why.

  actions:
    create_return: @actions.create_return
      available when @variables.order_return_eligible == True and @variables.order_id != None
```

> [!note]
> Keep in mind that the LLM can call any **available** reasoning action, even if you don't explicitly tell it to.

### Tips (2개 전수)

- **Protect against customer manipulation**: Filter business-sensitive features. Don't only rely on prompt engineering.
- **Use parentheses when nesting `and` / `or` conditions**: Using parentheses makes it clear which operations are evaluated first, and keeps your script maintainable.

---

## 관련 노트

- [[Agent Script 패턴 — 라우팅·전환·필수 워크플로우]] — 짝 노트(라우팅·전환·필수 워크플로우 패턴)
- [[Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드]] — 짝 노트(변수·리스트·리소스 참조·시스템 오버라이드·멀티턴), 조건 표현식·`available when` 공유
- [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]] — `run @actions` / 입출력 변수 수동 설정
- [[Agent Script 레퍼런스 — 변수·인스트럭션·표현식·연산자]] — 조건 표현식·연산자(`and`/`or`/`is None`/`==`)·괄호 우선순위
- [[Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법)]] — reasoning action(tool) 정의
- [[Agent Script 실행 흐름과 모델 설정]] — instructions 결정적 실행 시점
- [[스킬 ↔ 위키 토픽 맵]] — sf-skill ↔ 위키 디스패처
