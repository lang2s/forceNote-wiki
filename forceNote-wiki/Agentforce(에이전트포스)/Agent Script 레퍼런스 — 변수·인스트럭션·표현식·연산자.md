---
tags: [agentforce, agent-script, reference, variables, instructions, expressions, operators]
source: AgentScriptDocs (Salesforce Agent Script Developer Guide, 2026-06-17판) — agent-script/reference/ascript-ref-variables.md, ascript-ref-instructions.md, ascript-ref-expressions.md, ascript-ref-operators.md, ascript-ref-before-after-reasoning.md, ascript-reference.md
created: 2026-06-30
aliases: [변수, 인스트럭션, 표현식, 연산자, Variables, "@variables", "linked variables", 연결 변수, "system variables", "@system_variables", "Reasoning Instructions", "Logic Instructions", "Prompt Instructions", before_reasoning, after_reasoning, "Conditional Expressions", "Supported Operators", "syntax cheatsheet", "Agent Script 변수 타입 뭐 있어", "-> 와 | 차이가 뭐야", "else if 되나", "after_reasoning 언제 실행돼", "Agent Script 연산자 목록"]
---

# Agent Script 레퍼런스 — 변수·인스트럭션·표현식·연산자

> Agent Script 레퍼런스 — 변수 3종·인스트럭션(reasoning/logic/prompt + before·after_reasoning)·조건 표현식·연산자 14종을 문법 치트시트까지 전수 정리한다.

---

## 개요

이 노트는 Agent Script 레퍼런스 4파일(변수·인스트럭션·표현식·연산자) + before/after_reasoning + 문법 치트시트를 하나로 통합한 것이다.

소스 파일 6종을 소스 파일 순서가 아니라 **독자 흐름(변수 → 인스트럭션 → 표현식 → 연산자 → 문법)**으로 재배치했다. 본문 끝의 [부록 A](#부록-a-agent-script-문법-치트시트)는 모든 키워드·기호를 lookup하는 syntax 치트시트다.

---

## 1. 변수 (Variables)

변수는 agent가 conversation turn을 가로질러 정보를 **deterministic하게 기억**하고, 진행 상황을 추적하고, 세션 전체에서 context를 유지하게 해준다. 모든 변수는 `variables` 블록에서 정의하며, agent 안의 모든 subagent가 변수에 접근할 수 있다.

### 변수 3종 개요

| 종류 | 정의 | 기본값 | agent가 값 변경 | 비고 |
|---|---|---|---|---|
| **regular variable** (정규 변수) | `variables` 블록에서 직접 정의 | 가질 수 있음 | 가능(`mutable`일 때) | 기본 변수 |
| **linked variable** (연결 변수) | 값이 액션의 output 등 source에 묶임 | **가질 수 없음** | **불가** | `source` 필드로 값 위치 지정, object·list 불가 |
| **system variable** (시스템 변수) | 미리 정의·미리 채워짐 | (시스템 제공) | **불가**(read-only) | `variables` 블록에서 정의하지 않음 |

### 변수 명명 규칙 5

Salesforce developer name 표준을 따른다.

- Begin with a letter, not an underscore. (문자로 시작, 언더스코어로 시작 불가)
- Contain only alphanumeric characters and underscores. (영숫자·언더스코어만)
- Can't end with underscore. (언더스코어로 끝날 수 없음)
- Can't contain consecutive underscores (`__`). (연속 언더스코어 불가)
- Maximum length of 80 characters. (최대 80자)

### 변수 참조 2형식

변수를 참조하는 방식은 컨텍스트에 따라 둘로 나뉜다.

- **script(logic instructions)에서:** `@variables.<variable_name>`
- **reasoning instructions(prompt)에서:** `{!@variables.<variable_name>}` — prompt가 변수 값으로 resolve된다.

script(로직)에서 변수 참조:

```agentscript

            if @variables.Customer_Contact is None:
                set @variables.No_Matching_Contact = True
```

reasoning instructions(프롬프트) 내에서 변수 참조:

```agentscript
reasoning:
    instructions: ->
        | Always use {!@variables.Customer_Email} for the customer's email address.
```

> `{!@variables.x}` 형식의 정식 정의는 이 절 한 곳에만 둔다. 이후 ②·③에서는 사용만 한다.

### Regular Variables (정규 변수)

정규 변수 프로퍼티:

- `mutable` — Optional. 에이전트가 값을 변경하도록 허용. 절대 변경되지 않게 하려면 `mutable` 없이 정의.
- `description` — 변수를 설명. Optional. LLM이 reasoning으로 변수 값을 설정하길 원하면 description을 포함한다(slot filling).
- `label` — Optional. UI에 표시되는 변수 이름. 기본값은 name에서 생성된다. 예: name이 `my_var`면 UI는 label `My Var`를 표시.

```agentscript
variables:
    isPremiumUser: mutable boolean = False
        description: "Indicates whether the user is a premium user."
        label: "Has Gold Status"

    customer_loyalty_tier: mutable string = "standard"
        description:|
            Stores the customer's membership tier level.
```

#### 정규 변수 타입표 (7종)

| Type | Notes | Example |
|---|---|---|
| `string` | Any alphanumeric string without special characters. | `name: mutable string = ""` |
| `number` | Use for both integers and decimals. For example, 42 or 3.14. Compiles to IEEE 754 double-precision floating point. | `age: mutable number`, `price: mutable number = 99.99` |
| `boolean` | Allowed values are `True` or `False`. The value is case-sensitive, so capitalize the first letter. | `is_active: mutable boolean = True` |
| `object` | Value is a complex JSON object in the form `{"key": "value"}.` | `order_line: mutable object = {"SKU": "abc12344409","count": 42}` |
| `date` | Any valid date format. | `start_date: mutable date` |
| `id` | A Salesforce record ID. | `LeadID_Temp: mutable id = "00Q9V00000ZV2xUUAT"` |
| `list[type]` | A list of values of the specified type. All primitive types and `object` type are supported. | `flags: mutable list[boolean] = [True, False, True]`, `scores: list[number] = [95, 87.5, 92]`, `obj_list: mutable list[object] = None` |

### None(없음)과 빈 문자열("") 검사

`None`을 사용해 변수가 값을 가지는지 확인한다. `None`은 어떤 변수 타입에도 사용할 수 있다. string 변수의 경우, 변수가 빈 문자열로 설정되었는지 확인하기 위해 `""`도 사용할 수 있다. 조건문에서 string 변수를 확인할 때는 `None`과 `""` 둘 다를 쓰고 싶을 수 있다.

> None 개념의 anchor는 이 절 한 곳이다. ③ 표현식·④ 연산자에서는 `is None` / `is not None`을 사용만 한다(재정의 없음).

### Linked Variables (연결 변수)

연결 변수의 값은 source(예: 액션의 output)에 묶인다. 제약 3가지:

- can't have a default value (기본값을 가질 수 없음)
- can't be set by the agent (에이전트가 설정할 수 없음)
- can't be an object or a list (object·list가 될 수 없음)

`source` 필드는 변수가 값을 얻는 위치를 참조한다. 지원되는 source 네임스페이스:

| Namespace | Available Properties | Description |
|---|---|---|
| `@MessagingSession` | `Id`, `MessagingEndUserId`, `EndUserLanguage` | Properties of the messaging session |
| `@MessagingEndUser` | `ContactId` | Properties of the messaging end user |
| `@VoiceCall` | `Id` | Properties of the voice call |

```agentscript
variables:
    session_id: linked string
        source: @MessagingSession.Id
        description: "The messaging session ID"
    contact_id: linked string
        source: @MessagingEndUser.ContactId
        description: "The contact ID of the end user"
    voice_call_id: linked string
        source: @VoiceCall.Id
        description: "The voice call ID"
```

연결 변수가 가질 수 있는 타입(5종): `string`, `number`, `boolean`, `date`, `id`. (object·list는 위 제약과 일치하게 불가)

### System Variables (시스템 변수)

Agent Script는 미리 정의·미리 채워진 시스템 변수를 제공한다. 접근: `@system_variables.<variable_name>`. 시스템 변수는:

- read-only — 값을 변경할 수 없다
- predefined — `variables` 블록에서 정의하지 않는다
- regular/linked 변수와 동일한 곳에서 사용한다

현재 `@system_variables.user_input`이 유일한 시스템 변수다.

#### `@system_variables.user_input`

`user_input` 시스템 변수는 고객의 **가장 최근 발화 1건**(전체 대화 이력이 **아님**)을 담는다.

> [!note]
> The LLM remembers the entire conversation history, so you don't typically need to use `@system_variables.user_input` unless you're passing the last thing a customer said into an action.
> (LLM은 전체 대화 이력을 기억하므로, 고객이 마지막으로 한 말을 액션에 전달하는 경우가 아니면 보통 `@system_variables.user_input`을 쓸 필요가 없다.)

예제 — 가장 최근 고객 발화를 sentiment analysis 액션에 전달(에이전트 LLM도 sentiment를 분석할 수 있지만, 산업 특화 용어나 빠르게 변하는 언어 패턴을 이해하는 prompt template action을 쓰려는 경우):

```agentscript
reasoning:
    actions:
        AnalyzeSentiment: @actions.AnalyzeSentiment
            with utterance = @system_variables.user_input
            set @variables.customer_sentiment = @outputs.sentiment_classification
```

---

## 2. 인스트럭션 (Reasoning Instructions)

subagent의 `reasoning` 블록은 Agentforce가 LLM용 prompt로 resolve하는 instructions를 담는다. resolve된 prompt가 LLM에게 subagent의 목적을 수행하도록 지시한다. (서브에이전트 처리 흐름은 [[Agent Script 실행 흐름과 모델 설정]] 참조)

> [!note]
> In general, shorter reasoning instructions result in more accurate and reliable results.
> (일반적으로 reasoning instructions가 짧을수록 더 정확하고 신뢰성 있는 결과가 나온다.)

다음 예제에서 logic은 이메일 주소가 있을 때 verification code를 deterministic하게 보내고 반환값을 변수에 저장한다. prompt는 사용자가 코드를 제공·검증하도록 안내하며, 이메일을 확인하고 필요 시 재전송하는 instructions를 포함한다.

```agentscript
  reasoning:
    instructions: ->
      if @variables.member_email != "":
        run @actions.send_verification_code
          with email=@variables.member_email
          with member_number = @variables.member_number
          set @variables.verification_code=@outputs.verification_code
          set @variables.member_name=@outputs.member_name

      | Greet the user and inform them that to help them get started you've sent them a verification code via email.
        Ask the user for the verification code they received and verify it using {!@actions.validate_verification_code}.
        If the user says they did not receive the code, ask them to confirm their email and resend the verification code using {!@actions.send_verification_code}
```

reasoning instructions에서 변수를 사용하려면 `{!@variables.<variable_name>}`를 쓴다. prompt는 변수 값으로 resolve된다.

### Logic Instructions(`->`) vs Prompt Instructions(`|`)

reasoning instructions에는 서로 다른 두 부분이 있다 — **logic instructions**와 **prompt instructions**.

| 구분 | 시작 토큰 | 성격 | 역할 |
|---|---|---|---|
| **Logic instructions** | `->` | deterministic / [조건 표현식](#3-표현식-conditional-expressions) | 특정 요건을 판정하고, 액션을 실행(`run`)하고, 변수를 설정(`set`)한다. 결정론적으로 실행된다. |
| **Prompt instructions** | `\|` (pipe) | 자연어 | 조건이 충족되면 자연어로 LLM에 전달된다. `@variables`·`@utils`·`@actions`로 리터럴 값을 참조할 수 있다. |

`|` (pipe) 멀티라인 문자열 명령은 deterministic logic instructions가 실행되기 **전이나 후** 어디서든 들여쓰기된 멀티라인 prompt instructions에도 쓸 수 있다.

```agentscript
reasoning:
    instructions: ->
        # LOGIC INSTRUCTIONS
        if @variables.ready_to_book:
            run @actions.get_account_info
                with account_id=@variables.account_id
                set @variables.hotel_code=@outputs.hotel_code
        run @actions.get_hotel_info
            with hotel_code=@variables.hotel_code
            set @variables.hotel_info = @outputs.hotel_info

        # PROMPT INSTRUCTIONS
        | You are a helpful assistant that can answer questions about a hotel.
          Here's the latest hotel information {!@variables.hotel_info}. If the user
          asks about availability, please use the action: {!@actions.get_availability} action
          that they give you the date range they are traveling on.
          If they indicate they wish to book, please transition over
          to a booking agent by calling the action {!@actions.transition_to_booking} action.
          If they indicate that they wish to ask about another hotel, use the {!@actions.lookup_hotel}
          action and tell them they'll be able to ask about that hotel.
```

> logic/prompt instructions의 정의는 이 절 한 곳에만 둔다. ③ 표현식에서는 `if`/`else` **사용 문법**만 다루고 logic/prompt를 재정의하지 않는다. (개요 수준 cross-ref는 [[Agent Script 개요와 언어 특성]] 참조)

### before_reasoning / after_reasoning 블록

`before_reasoning`·`after_reasoning`는 reasoning과 별개인 블록이다. logic·actions·transitions·기타 directive를 담을 수 있지만 **`|` (pipe) prompt instructions는 담을 수 없다** — 즉 reasoning instructions와 달리 자연어 prompt를 넣지 못하는 것이 핵심 차이다.

**after_reasoning** — Agentforce는 reasoning 루프가 종료된 **후, 매 request마다** subagent의 `after_reasoning` 블록을 실행한다. 대표 용도: 고객이 입력한 정보를 변수에 저장, 다른 subagent로 전환, 액션 실행.

```agentscript
after_reasoning:->
    if @variables.urgency_level == "urgent":
        set @variables.estimated_duration = 15
    if @variables.urgency_level == "routine":
        set @variables.estimated_duration = 30
```

> [!note]
> Agentscript also supports a `before_reasoning` block with the same capability and syntax as the `after_reasoning` block. The `before_reasoning` block is functionally equivalent to adding logic to the beginning of a subagent's instructions.
> (`before_reasoning` 블록은 `after_reasoning`과 동일한 기능·문법을 지원한다. `before_reasoning` 블록은 subagent instructions 맨 앞에 로직을 추가한 것과 기능적으로 동등하다.)

**after_reasoning에서의 전환(Transitions)** — subagent가 실행 도중 새 subagent로 전환하면, 원래 subagent의 `after_reasoning` 블록은 실행되지 않는다. after reasoning에서 전환을 호출할 때는 `@utils.transition to`가 아니라 **`transition to`**를 사용한다. (`@utils.transition to`와의 차이는 [[Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법)]] 참조)

```agentscript
after_reasoning:
    if @variables.case_type != "":
        transition to @subagent.case_creation
```

---

## 3. 표현식 (Conditional Expressions)

`if`와 `else` 조건은 어떤 액션을 취할지 또는 어떤 prompt를 포함할지를 deterministic하게 지정한다. 복잡한 조건을 지정하려면 괄호 `()`로 조건 내의 `and`·`or` 연산자를 그룹화한다.

변수 값을 확인하고 결과에 따라 액션을 실행:

```agentscript
# If the tracking number (represented as a string) isn't empty and is not None, get the tracking updates
if @variables.tracking_number is not None and @variables.tracking_number != "":
    run @actions.Get_Tracking_Updates
else:
    run @actions.Ask_Tracking_Number
```

`and`/`or` 중첩이 필요하면 괄호 `()`를 쓴다. 아래 예에서 그룹 조건 `(@variables.HasSalesInterest == True or @variables.WantsMeeting == True)`이 먼저 평가되고, 둘 중 하나만 true여도 true로 평가된다.

```agentscript
    reasoning:
        instructions: ->
            | Select the best tool to call based on conversation history and user's intent.
        actions:
            go_to_Qualify: @utils.transition to @subagent.Qualify
                available when @variables.customerType == "Valued" and @variables.QualificationEnabled == True and (@variables.HasSalesInterest == True or @variables.WantsMeeting == True) and @variables.QualificationFlowStep != "COMPLETE"
```

변수를 확인하여 다른 변수를 설정:

```agentscript
if @variables.order_number == "" and @variables.customer_email == "":
    set @variables.order_found = False
    set @variables.customer_verified = False
```

조건 표현식으로 어떤 자연어 prompt를 포함할지 결정:

```agentscript
if @variables.is_late == True:
    | Apologize to the customer for the delay in receiving their order.
else:
    | Tell the customer their order is arriving as scheduled.
```

reasoning instructions 내부에서 `if`/`else`로 LLM용 prompt 라인을 조건부 포함:

```agentscript
reasoning:
    instructions: ->
        | Your job is solely to help with issues and answer questions by searching knowledge articles.
        if @variables.support_tier == "premium":
            | This is a premium customer. Prioritize their request and offer proactive suggestions.
        else:
            | This is a standard customer. Answer their questions helpfully and suggest upgrading for faster support.
        | If the customer's question is too vague, ask for more details.
```

변수가 값을 가지는지 확인:

```agentscript
# Note this example demonstrates correct syntax, NOT how to design a production agent
reasoning:
    instructions: ->
      if @variables.account_id is None:
        | What's the account ID for this order?
      if @variables.is_premium_user is not None:
        | This customer's premium status is set to {!@variables.is_premium_user}.
      if @variables.order_lines != None:
        | Order lines on this order: {!@variables.order_lines}.
      if @variables.scheduled_date is None:
        | When would you like to schedule this appointment?
```

> [!note]
> Currently, Agent Script supports `if` and `else` logic, but it doesn't support `else if` logic after an `if` statement.
> (현재 Agent Script는 `if`·`else` 로직을 지원하지만, `if` 문 뒤의 `else if` 로직은 **지원하지 않는다**.)

---

## 4. 연산자 (Supported Operators)

Agent Script에서 사용할 수 있는 연산자는 4 카테고리·14종이다.

| Category | Operator | Description | Example |
|---|---|---|---|
| Comparison | `==` | Equal to | `@variables.count == 10` |
| Comparison | `!=` | Not equal to | `@variables.status != "done"` |
| Comparison | `<` | Less than | `@variables.age < 18` |
| Comparison | `<=` | Less than or equal | `@variables.score <= 100` |
| Comparison | `>` | Greater than | `@variables.count > 0` |
| Comparison | `>=` | Greater than or equal | `@variables.total >= 50` |
| Comparison | `is` | Identity check | `@variables.value is None` |
| Comparison | `is not` | Negated identity check | `@variables.data is not None` |
| Logical | `and` | Logical AND | `@variables.a and @variables.b` |
| Logical | `or` | Logical OR | `@variables.x or @variables.y` |
| Logical | `not` | Logical NOT | `not @variables.flag` |
| Arithmetic | `+` | Addition | `@variables.count + 1` |
| Arithmetic | `-` | Subtraction | `@variables.total - 5` |
| Grouping | `( )` | Parentheses | `(@variables.x or @variables.y) and @variables.z` (See Conditional Expressions for examples) |

> 산술 연산자는 `+`(덧셈)·`-`(뺄셈) **둘뿐**이다 — 곱셈 `*`·나눗셈 `/`는 **없다**. None 검사는 `is None` / `is not None`을 사용한다(Comparison의 `is`·`is not`).

---

## 부록 A. Agent Script 문법 치트시트

Agent Script의 syntax·keyword·concept를 lookup하는 종합 레퍼런스다. (공통 패턴과 예제는 Agent Script Patterns 참조)

> [!note]
> Beginning in April 2026, agent **topics** are now called **subagents**. There are no changes to functionality. During this transition, you may see a mix of the new and previous terms in our documentation.
> (2026년 4월부터 agent **topics**는 **subagents**로 명칭이 바뀌었다. 기능 변화는 없다. 전환 기간 동안 문서에서 신·구 용어가 섞여 보일 수 있다. → `topic`은 deprecated, `subagent` 사용.)

### Syntax 종합표 (38행)

| Symbol | Description | More Info |
|---|---|---|
| `#` | Single-line comment. For example: `# This is a comment` | Comments |
| `...` | Slot-fill token that instructs the LLM to set the value. For example: `with order_id = ...` | Variables, Utils |
| `->` | Begins logic instructions. For example: `instructions: -> if @variables.verified:` | Reasoning Instructions |
| `\|` | Begins prompt instructions. For example: `\| Help the customer with their order.` | Reasoning Instructions |
| `{!expression}` | Resolve a variable or resource in prompt instructions. For example: `{!@variables.promotion_product}` | Reasoning Instructions |
| `==`, `!=`, `<`, `>`, `is None`, etc. | Comparison operators. For example: `@variables.count > 0` | Supported Operators |
| `@actions.name` | Reference an action. For example: `run @actions.get_order` | Actions |
| `@outputs.name` | Reference an action's output value. For example: `set @variables.status = @outputs.status` | Actions |
| `@subagent.name` | Delegate to another subagent. For example: `consult: @subagent.specialist` | Tools (Referencing a Subagent as a Tool) |
| `@utils.escalate` | Define a tool that escalates to a human service rep. For example: `escalate: @utils.escalate` | Utils (@utils.escalate) |
| `@utils.setVariables` | Define a tool that instructs the LLM to set variable values. For example: `set_name: @utils.setVariables` | Utils (@utils.setVariables) |
| `@utils.transition to` | Define a tool that transitions to a different subagent. For example: `@utils.transition to @subagent.Order_Management` | Utils (@utils.transition to) |
| `@variables.name` | Reference a variable from logic instructions. For example: `@variables.order_id` | Variables |
| `actions` | Define agent actions or tools available from a subagent. | Actions, Tools |
| `after_reasoning` | Run logic after the reasoning loop exits. | After Reasoning |
| `available when` | Conditionally show or hide a tool. For example: `available when @variables.verified == True` | Tools |
| `config` | Top-level block for agent configuration. | Config Block |
| `connection` | Top-level block for external connections like Enhanced Chat. For example: `connection messaging:` | Connection Block |
| `if` / `else` | Conditional branching. For example: `if @variables.is_member == True:` | Conditional Expressions |
| `instructions` | Guidance for the LLM within system or reasoning blocks. | Reasoning Instructions |
| `language` | Top-level block for supported languages. | Language Block |
| `linked` | Declare a variable whose value comes from an external source. For example: `session_id: linked string` | Variables (Linked Variables) |
| `messages` | System messages like welcome and error prompts. | System Block |
| `mutable` | Allow a variable's value to be changed. For example: `order_id: mutable string = ""` | Variables (Regular Variables) |
| `reasoning` | Block containing instructions and tools for the LLM. | Reasoning Instructions |
| `reasoning.actions` | Tools the LLM can choose to call within a subagent. | Tools (Reasoning Actions) |
| `reasoning.instructions` | Prompt and logic instructions sent to the reasoning engine. | Reasoning Instructions |
| `run` | Execute an action deterministically. For example: `run @actions.get_order` | Actions (Call an Action in the Reasoning Logic) |
| `set` | Store a value in a variable. For example: `set @variables.status = @outputs.status` | Variables, Actions |
| `start_agent` | Entry point block for subagent classification and routing. For example: `start_agent agent_router:` | Start Agent Block |
| `system` | Top-level block for agent instructions and messages. | System Block |
| `system.instructions` | Override system instructions for a specific subagent. | System Overrides |
| `target` | The flow or action target for an agent action. For example: `target: "flow://Get_Order"` | Actions |
| `subagent` | Top-level block defining a subagent's instructions and actions. For example: `subagent Order_Management:` | Subagent Blocks |
| `topic` | Deprecated. Use `subagent` instead. | Subagent Blocks |
| `transition to` | Move to a different subagent from logic instructions. For example: `transition to @subagent.wrap_up` | Utils (@utils.transition to) |
| `variables` | Top-level block for global agent variables. | Variables |
| `with` | Bind an input parameter. For example: `with order_id = @variables.order_id` | Actions |

### Concepts (11)

- **Actions** — Define executable tasks that an agent can perform, such as running a flow or transitioning to a new subagent.
- **After Reasoning** — Optional block inside a subagent that runs after the reasoning loop exits.
- **Blocks** — The structural components of an Agent Script, where each block contains a set of properties that describe data or procedures.
- **Conditional Expressions** — Deterministically specify what actions to take or which prompts to include based on the current context.
- **Reasoning Instructions** — Instructions that Agentforce resolves into a prompt for the LLM.
- **Start Agent Block** — A special subagent used for subagent classification, filtering, and routing.
- **Supported Operators** — The comparison, logical, and arithmetic operators you can use in Agent Script.
- **Tools (Reasoning Actions)** — Executable functions that the LLM can choose to call, based on the tool's description and current context.
- **Subagents** — A set of instructions, actions, and reasoning that defines a job that an agent can do.
- **Utils** — Utility functions used as tools, such as transitioning to subagents or setting variable values.
- **Variables** — Let agents track information across conversation turns.

---

## 관련 노트
- [[Agent Script 개요와 언어 특성]]
- [[Agent Script 블록 8종 (System·Config·Subagent 등)]]
- [[Agent Script 실행 흐름과 모델 설정]] — before/after_reasoning 실행 타이밍
- [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]]
- [[Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법)]] — after_reasoning의 transition to 차이
- [[스킬 ↔ 위키 토픽 맵]]
