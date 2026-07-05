---
tags: [agentforce, agent-script, pattern, variables, list-variables, resource-references, system-overrides, multi-turn]
source: AgentScriptDocs (Salesforce Agent Script Developer Guide, 2026-06-17판) — agent-script/patterns/{ascript-patterns-variables, var-list, resource-references, system-overrides, multi-turn}.md · Tier 2 deprecation 근거 developer.salesforce.com/docs/einstein/genai/guide (Agentforce Developer Guide, Agent Script reference: 'topic — Deprecated. Use subagent instead', 'Beginning in April 2026, agent topics are now called subagents')
created: 2026-07-01
aliases: [Using Variables Effectively, Using List Variables, list variables, collection variables, Reference Resources Directly, System Overrides, Instruction Overrides, Multi-Turn Workflows, slot filling, 변수 패턴, 리스트 변수, 컬렉션 변수, 리소스 직접 참조, 시스템 오버라이드, 멀티턴 워크플로우, 슬롯 필링, Agent Script에서 변수 어떻게 써, 멀티턴 순서 어떻게 강제해]
---

# Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드

> Agent Script 패턴 5종 — 변수 효과적 사용·리스트(컬렉션) 변수·리소스 직접 참조·시스템 오버라이드·멀티턴 워크플로우 강제. ([[Agent Script 패턴 — 라우팅·전환·필수 워크플로우]] 카탈로그의 C6 예정 5행을 채운다.)

> [!warning] `topic` / `@topic`은 deprecated — `subagent` / `@subagent` 사용
> Beginning in April 2026, agent **topics** are now called **subagents**. There are no changes to functionality. During this transition, you may see a mix of the new and previous terms in our documentation.
> (2026년 4월부터 agent **topics**는 **subagents**로 명칭이 바뀌었다. 기능 변화가 없는 순수 리네임이다. 구문 레퍼런스는 `topic — Deprecated. Use subagent instead`로 명시한다.) 이 노트의 일부 예제(아래 리스트 변수·순회 섹션)는 원본 소스 표기를 보존하기 위해 옛 `topic ask_questions:` / `transition to @topic.end_interview` 문법을 그대로 인용한다 — **현행 문법은 `subagent ask_questions:` / `transition to @subagent.end_interview`이다.** 근거: [[Agent Script 레퍼런스 — 변수·인스트럭션·표현식·연산자]]의 구문 표(`topic` 행: "Deprecated. Use `subagent` instead").

---

## 개요 — 5패턴 한눈에

이 노트는 Agent Script 패턴 카탈로그의 나머지 5개 패턴을 모은다. 각 패턴이 해결하는 문제는 다음과 같다.

| 패턴 | 무엇을 해결하는가 |
|---|---|
| **변수 효과적으로 사용** (Using Variables Effectively) | 서브에이전트·턴을 가로질러 에이전트의 현재 상태(state)를 추적하고, 데이터를 전달하며, 조건문에 활용한다. |
| **리스트(컬렉션) 변수** (Using List Variables) | 값의 컬렉션을 저장하고 순회한다(인터뷰 질문 목록, 액션 출력 모음 등). Agent Script에는 `for` 루프가 없어 인덱스 증가로 순회한다. |
| **리소스 직접 참조** (Reference Resources Directly) | reasoning instructions 프롬프트 텍스트 안에서 서브에이전트·액션·변수를 `@` 멘션과 `{중괄호}` 문법으로 직접 가리킨다. |
| **시스템 오버라이드** (System / Instruction Overrides) | 특정 서브에이전트 안에서 에이전트 레벨 `system.instructions`를 덮어써서, 충돌하는 지시를 해소하거나 컨텍스트별 페르소나를 만든다. |
| **멀티턴 워크플로우 강제** (Enforce Required Workflows in Multi-Turn) | step 변수로 agent router가 선택할 서브에이전트를 제어하여, 복잡한 순서 규칙을 멀티턴 대화 전반에 강제한다. |

---

## 변수 효과적으로 사용 (Using Variables Effectively)

변수(Variables)는 서브에이전트와 턴을 가로질러 에이전트의 현재 상태에 대한 정보를 저장한다.

**Why Use This Pattern**

변수는 에이전트 동작에 영향을 주는 상태를 추적하고, 서브에이전트 간에 데이터를 전달하며, 조건문에 데이터를 사용하고, 사용자에게 특정 정보를 보여주는 데 도움이 된다. 중요한 정보를 추적하는 데 전략적으로 사용하되, 모든 데이터 조각을 저장하여 에이전트를 과도하게 제약하지 않도록 한다.

변수는 다음 용도로 사용한다.

- **재사용을 위한 값 저장(Storing values for reuse)**: 조건문용 데이터, 다른 서브에이전트의 액션 입력, 또는 사용자에게 보여줄 데이터.
- **액션 출력 저장(Storing action outputs)**: 조건문이나 기타 결정론적(deterministic) 워크플로우에서 필요한 액션의 결과.
- **`available when` 절(clauses)**: 어떤 액션·서브에이전트·프롬프트가 사용 가능한지 결정하는 조건.

**Pattern Example**: 사용자의 인증(verification) 상태를 변수에 저장하여, 모든 서브에이전트가 민감한 정보를 보여주기 전에 사용자가 인증되었는지 확인할 수 있게 한다.

```agentscript
variables:
  member_name: mutable string
    description: "The name of the member for personalized greetings"
  verified: mutable boolean = False
    description: "Whether the user's identity has been verified"
  order_summary: mutable string = ""
    description: "Summary of the user's current order"
```

### Initialize Variables — 변수 초기화

조건 검사가 올바르게 동작하도록 변수를 합리적인 기본값으로 초기화한다.

```agentscript
variables:
  # Use empty string for text that is fetched later
  order_summary: mutable string = ""

  # Use False for flags that start negative
  verified: mutable boolean = False

  # Leave uninitialized for values that must be provided
  member_email: mutable string
```

### Good Variable Descriptions — 명확한 설명

명확한 설명은 에이전트가 변수를 올바르게 사용하도록 돕는다.

```agentscript
variables:
  is_business_hours: mutable boolean = False
    description: "Whether it is business hours. Used to determine if the agent can escalate to a live representative."

  loyalty_tier: mutable string
    description: "The customer's loyalty tier (Standard, Gold, or Platinum VIP). Used for personalized greetings and feature access."
```

### Store Action Outputs — 액션 출력 저장

조건 표현식에서 사용하거나, 다른 액션의 필수 입력으로 쓰거나, 기타 결정론적 워크플로우에 필요하면 액션 출력을 변수에 저장한다.

```agentscript
reasoning:
  instructions: ->
    run @actions.lookup_current_order
      with member_email=@variables.member_email
      set @variables.order_summary=@outputs.order_summary
      set @variables.order_id=@outputs.order_id

    | Show the user their order: {!@variables.order_summary}
```

### Share Information Between Subagents — 서브에이전트 간 정보 공유

변수를 사용해 서브에이전트 간에 정보(상태)를 공유할 수 있다. 예를 들어 에이전트 내 모든 서브에이전트가 현재 온도를 공유하려면, `Get_Current_Weather_Data` 액션을 실행하고 temperature 출력 값을 전역 temperature 변수에 저장한다.

```agentscript
reasoning:
    instructions: ->
        # always get the current weather data
        run @actions.Get_Current_Weather_Data
            with city=@variables.user_city
            # set the variable "temperature" with the
            # current temperature so that other subagent has that info
            set @variables.temperature = @outputs.temperature_celsius
```

### Let the LLM Set Variables (Slot Filling) — LLM이 사용자 입력으로 변수 설정

`...`를 사용해 LLM이 reasoning으로 변수 값을 설정해야 함을 나타낸다. 예를 들어 LLM은 사용자에게 이름과 성을 물은 뒤 `capture_user_info` 툴을 사용해 그 값을 `first_name`·`last_name` 변수에 설정할 수 있다. reasoning으로 변수 값을 설정하는 것을 **슬롯 필링(slot filling)**이라고 한다.

간단한 워크플로우에서는 LLM이 액션의 설명과 이름을 바탕으로 어떤 액션을 호출할지 스스로 판단할 수 있다. 이 예제에서는 LLM이 사용자 정보를 확실히 저장하도록 instructions에서 `{!@capture_user_info}`를 명시적으로 참조한다.

```agentscript
reasoning:
    instructions: -> Ask the user for their full name. Then, use {!@actions.capture_user_info} to set the value of the user's first and last name.
    actions:
        capture_user_info: @utils.setVariables
            with first_name = ...
            with last_name = ...
            description: "Set the user's name as variables"
```

> [!note] 원문 :::note
> You can use slot-filling for top-level action inputs (which are called by the LLM), but not for chained action inputs (because they're run deterministically).
>
> (슬롯 필링은 LLM이 호출하는 top-level 액션 입력에는 쓸 수 있지만, 결정론적으로 실행되는 chained 액션 입력에는 쓸 수 없다.)

### Tips (전문)

- **Name variables clearly**. `flag1`이 아니라 `order_return_eligible` 같은 서술적 이름을 사용한다.
- **In reasoning instructions, assign variables to action inputs and outputs**. reasoning instructions에서 액션을 실행할 때는 입력과 출력에 대해 변수를 수동으로 설정해야 한다. 액션이 어떤 reasoning이 일어나기 전에 실행되기 때문이다.
- **In reasoning actions, use variables as action inputs sparingly**. 액션은 에이전트가 관련 액션 입력을 모두 가졌을 때 사용 가능해지므로, 너무 많은 입력에 변수를 지정하면 에이전트가 액션을 일관성 없이 선택할 수 있다. 변수를 입력으로 지정하지 않으면 보통 에이전트가 최적의 입력을 결정할 수 있다. 테스트를 바탕으로 필요할 때만 변수를 입력으로 지정한다.
- **Store action outputs in variables when applicable**. 조건 표현식에서 쓰거나, 다른 액션의 필수 입력으로 쓰거나, 기타 결정론적 워크플로우에 필요하면 저장한다.

---

## 리스트(컬렉션) 변수 (Using List Variables)

리스트 변수(list variables, 컬렉션 변수라고도 함)를 사용하면 에이전트가 값의 컬렉션을 저장하고 순회할 수 있다. 예를 들어 인터뷰 에이전트가 물어야 할 질문 목록을 만들거나, 액션 출력을 저장할 객체 목록을 만들 수 있다. 리스트는 string, boolean, number, object 등 지원되는 모든 타입을 저장할 수 있다.

리스트 항목은 일반 변수를 쓸 수 있는 모든 곳에서 쓸 수 있다. 리스트의 항목을 참조하려면 `[<item_numer>]`를 사용한다. <!-- [sic] 원문 'numer' 오타 그대로 (item_number가 아님) — Salesforce 소스 원본 표기 보존 --> 리스트 인덱스는 0부터 시작하므로 리스트의 첫 항목은 `@variables.YourVariable[0]`이다.

```agentscript
@variables.YourVariable[2]
```

위 예시는 `YourVariable` 리스트의 **세 번째(THIRD)** 항목을 참조한다(0-base이므로 인덱스 2).

### Why Use This Pattern

리스트 변수는 다음 용도로 사용한다.

- **항목 시퀀스를 하나씩 처리(Working through a sequence of items)**: 인터뷰 질문, 체크리스트 항목, 검색 결과 등.
- **액션의 여러 출력 저장(Storing multiple outputs from an action)**: 계정 레코드 목록 등.
- **컬렉션 진행 추적(Tracking progress)**: 리스트를 인덱스 변수와 짝지어 진행 상황을 추적.

### Declare a List Variable — 리스트 변수 선언

`variables` 블록에서 리스트 변수를 선언한다. 대괄호 `[]`로 리스트 타입을 지정한다. `=[]`로 빈 리스트를 초기화하거나 기본값을 설정할 수 있다.

```agentscript
variables:
    # Declare a list of objects
    CandidateList: mutable list[object] = []
        description: "List of contacts returned from an action"
    CompetencyQuestions: mutable list[string] = ["Tell me about a time you disagreed with a coworker.", "Tell me about one of your favorite shifts.", "What are the most important qualities in a candidate?"]
        description: "List of questions to determine competency."
```

### Use a List Item in Reasoning Instructions — reasoning instructions에서 리스트 항목 사용

다음 예제에서 질문 3이 "Tell me about your work history"라면, LLM에 전송되는 프롬프트는 "Ask the candidate this question: Tell me about your work history"가 된다.

```agentscript
    reasoning:
        instructions: ->
            |Ask the candidate this question: {!@variables.CompetencyQuestions[0]}
```

### Reference a List Item with a Variable — 변수로 리스트 항목 참조

변수를 사용해 리스트 항목을 참조할 수 있다.

```agentscript
reasoning:
    instructions: ->
        | Ask this question: {!@variables.questions[@variables.current_question]}
```

### Use a List Item in Reasoning Logic — reasoning 로직에서 리스트 항목 사용

조건 표현식에서 리스트 항목을 사용할 수 있다.

```agentscript
# In the variables section, define a list of booleans
variables:
    areAnswersCorrect: mutable list[boolean]
        description: "True if the answer is correct, otherwise False"
....
# Later, as the user answers questions, record whether the answer was correct (not shown)
...

#  In a topic, if the THIRD answer is incorrect, end the interview
    reasoning:
        instructions: ->
            # remember that lists are zero-indexed ;-)
            if @variables.areAnswersCorrect[2] == "False":
                transition to @topic.end_interview
```

> [!warning] `@topic`은 deprecated — 현행 문법은 `transition to @subagent.end_interview`
> 위 예제는 원본 소스 표기 그대로다. `@topic`은 2026년 4월 리네임으로 deprecated되었으므로 새로 작성할 때는 `transition to @subagent.end_interview`를 쓴다(기능 동일).

### Get the Length of a List — 리스트 길이

`len(@variables.MyList)`를 사용해 리스트의 항목 수를 구한다. `len(@variables.MyList)`는 프롬프트, `available when` 필터, 조건 표현식에서 사용할 수 있다.

```agentscript
# For example, the agent might say "this is question 5 of 7"
reasoning:
    instructions: ->
        | This is question {!@variables.question_index + 1} of {!len(@variables.questions)}.
```

### Iterate Through a List — 리스트 순회

Agent Script에는 `for` 루프가 없다. 대신 매 턴 후에 인덱스 변수를 증가시켜 순회한다.

이 예제는 리스트의 각 질문을 한 번에 하나씩 묻는다. 에이전트가 답변을 기록하면 인덱스가 전진한다. 인덱스가 리스트 길이에 도달하면 에이전트는 다음 토픽으로 전환한다.

> [!warning] `topic`은 deprecated — 현행 문법은 `subagent ask_questions:`
> 아래 예제는 원본 소스 표기 그대로다. `topic` 키워드는 2026년 4월 리네임으로 deprecated되었으므로 새로 작성할 때는 `subagent ask_questions:`를 쓴다(기능 동일).

```agentscript
variables:
    questions: mutable list[object] = []
        description: "Questions to ask the candidate"
    question_index: mutable number = 0
        description: "Current index in the questions list"
    is_GetQuestions_run: mutable boolean = False
        description: "Whether the action Get_Questions has been run"

topic ask_questions:
    description: "Ask the candidate questions one at a time."

    reasoning:
        instructions: ->
            if @variables.is_GetQuestions_run == False:
                run @actions.Get_Questions
                    with JobScreeningRecordId=@variables.JobRecordID
                    set @variables.questions = @outputs.AllScreeningQuestions
                    set @variables.question_index = 0
                    set @variables.is_GetQuestions_run = True
            | Ask this question: {!@variables.questions[@variables.question_index]}
```

### Tips

- **Pair a list with an index variable** — 항목을 한 번에 하나씩 처리해야 할 때 리스트를 인덱스 변수와 짝짓는다.

---

## 리소스 직접 참조 (Reference Resources Directly in Reasoning Instructions)

reasoning instructions의 프롬프트 텍스트 안에서 서브에이전트·액션·변수를 직접 참조한다. `@` 멘션과 `{중괄호}` 문법으로 변수와 reasoning 액션을 직접 가리킨다.

**Why Use This Pattern**

특수 문법을 사용해 reasoning instructions에서 서브에이전트·액션·변수를 직접 참조한다. `@` 멘션과 중괄호 문법으로 프롬프트 텍스트 안에서 변수와 액션을 직접 가리킨다.

**Pattern Example**: order name·date·status 같은 변수를 참조하여 개인화된 주문 요약을 표시하고, 사용자가 추가 도움이 필요할 때 `lookup_order` 액션이나 `Returns` 서브에이전트로 안내한다.

### Reference Syntax — 참조 문법 (전문)

- **Subagents**: `{!@subagents.<subagent_name>}`
- **Actions**: `{!@actions.<action_name>}`
- **Variables**: `{!@variables.<variable_name>}`

### Reference Variables in Output — 출력에서 변수 참조

응답에 특정 데이터를 포함하려면 변수를 직접 참조한다.

```agentscript
reasoning:
  instructions: ->
    | Refer to the user by preferred name {!@variables.preferred_name}.
      Output a summary to the user in the following format:
      Order Name: {!@variables.order_name}
      Order Date: {!@variables.order_date}
      Order Status: {!@variables.order_status}
```

### Reference Actions in Instructions — instructions에서 액션 참조

LLM에게 어떤 reasoning 액션을 쓸지 알려주려면 액션을 직접 참조한다.

```agentscript
reasoning:
  instructions: ->
    | If the user wants information about a past order, ask for the Order ID
      or Restaurant Name and use {!@actions.lookup_order}.
      If the user asks for a service agent or seems upset,
      go to {!@actions.go_to_escalation}.
      If the user wants to make a return, confirm their order ID and
      call {!@actions.create_return}.
```

### Combine Variable and Action References — 변수·액션 참조 결합

완전하고 구체적인 instructions를 위해 두 종류의 참조를 함께 사용한다.

```agentscript
reasoning:
  instructions: ->
    | Refer to the user by their name {!@variables.member_name}.
      Show the user their current order summary: {!@variables.order_summary}
      at the start of the conversation or if they specifically request it again.
      If the user wants to make a return, confirm their order ID and
      call {!@actions.create_return}. If returns are not eligible
      ({!@variables.order_return_eligible} is False), explain that
      the order is not eligible for return.
```

### Conditional Output with References — 조건부 출력에서 참조

조건부 프롬프트 안에서도 참조를 사용한다.

```agentscript
reasoning:
  instructions: ->
    if @variables.loyalty_tier == "Gold":
      | Thank the customer for being a Gold member.
        Their current points balance is {!@variables.points_balance}.

    if @variables.loyalty_tier == "Platinum VIP":
      | Welcome back, valued Platinum VIP member {!@variables.member_name}!
        You have {!@variables.points_balance} points available.
```

### Tips

- **Reference resources when clarity is required**: 일반적으로 에이전트는 어떤 리소스를 쓸지 스스로 판단할 수 있다. 예를 들어 액션이 많은 경우 참조를 추가하여 에이전트가 올바른 것을 고르도록 돕는다. 직접 참조는 LLM에 더 강한 신호이므로 올바른 변수·액션·서브에이전트를 선택할 가능성이 더 높아진다.

---

## 시스템 오버라이드 (Avoid Conflicting Instructions with Instruction Overrides)

특정 서브에이전트 안에서 시스템 레벨 instructions(UI에서는 "agent-level" instructions)를 오버라이드하여 에이전트의 동작과 페르소나를 동적으로 바꾼다.

기본적으로 모든 서브에이전트는 agent-level `system.instructions`를 상속한다. 특정 서브에이전트에 `system` 블록을 추가하면, 그 instructions가 해당 서브에이전트에 한해서만 시스템 instructions를 오버라이드한다.

**Why Use This Pattern**

agent-level 시스템 instructions가 subagent-level reasoning instructions와 모순되면, 에이전트가 멈추거나(hang) 예기치 않게 동작할 수 있다. 시스템 오버라이드는 필요할 때 시스템 instructions를 명시적으로 교체하여 이를 해결한다.

또한 시스템 오버라이드는 단일 에이전트가 컨텍스트별로 다른 성격·톤·동작을 채택하게 한다 — 다른 곳에서는 일관된 동작을 유지하면서 특정 서브에이전트에서만 에이전트가 다르게 행동해야 할 때 유용하다.

**Pattern Example**: 이벤트 플래너 에이전트는 평소 알코올을 권하지 않지만, 성인 전용 파티 서브에이전트에서는 시스템 instructions를 오버라이드하여 칵테일 추천을 허용한다.

### Instruction Hierarchy (전문)

Agent Script는 어떤 시스템 instructions를 사용할지 결정할 때 다음 계층(hierarchy)을 따른다.

1. `Topic-level system instructions (highest priority)` — 서브에이전트에 `system` 블록이 있으면, 에이전트는 그 instructions를 사용한다.
2. `Agent-level system instructions (fallback)` — 서브에이전트에 `system` 블록이 없으면, 에이전트는 전역 instructions를 사용한다.

### Avoiding Instruction Conflicts — instruction 충돌 회피

agent-level 시스템 instructions가 subagent-level reasoning instructions와 모순되면, 에이전트가 충돌을 해소해야 하며 이는 예기치 않은 동작을 일으킬 수 있다.

**Problem**: 이벤트 기획 에이전트에 "Never suggest alcoholic beverages at a children's party"라는 전역 instructions가 있지만, 성인이 참석하는 어린이 파티용 서브에이전트가 reasoning instructions에서 샴페인을 제안하려 한다.

**Solution**: 시스템 오버라이드를 사용해 해당 서브에이전트에 한해 시스템 instructions를 명시적으로 교체한다.

```agentscript
system:
  instructions: "You are an event planning assistant. NEVER suggest alcoholic beverages for children's parties or events attended primarily by children."

subagent baby_first_birthday:
  description: "Plan a baby's first birthday celebration with adult guests"

  system:
    instructions: "You are an event planning assistant for a baby's first birthday celebration. While the event is for a baby, adult guests are present. You may suggest beverages including champagne for adult guests, while ensuring child-appropriate food and activities."

  reasoning:
    instructions: ->
      | Help plan a memorable first birthday celebration.
        Consider both the baby's needs and adult guest comfort.
        Suggest food, drinks, decorations, and activities.
```

### Creating Multiple Personas — 다중 페르소나

컨텍스트별로 다른 페르소나를 만든다.

```agentscript
subagent technical:
  description: "Technical support specialist"

  system:
    instructions: "You are a technical support specialist. Use precise technical terminology, provide step-by-step troubleshooting, ask diagnostic questions, and explain technical concepts clearly. Be patient and thorough."

  reasoning:
    instructions: ->
      | [Technical Support Mode]
        I am now operating in technical support mode with:
        - Precise technical language
        - Diagnostic approach
        - Step-by-step troubleshooting
        How can I assist you with technical issues?
```

```agentscript
subagent creative:
  description: "Creative brainstorming assistant"

  system:
    instructions: "You are a creative brainstorming partner. Think outside the box, suggest unconventional ideas, use enthusiastic language, encourage wild ideas, and help explore possibilities without judgment. Be imaginative and supportive."

  reasoning:
    instructions: ->
      | [Creative Mode Activated]
        I'm now in creative brainstorming mode with:
        - Think big and bold
        - No idea too wild
        - Explore all possibilities
        What shall we dream up together?
```

### When to Use Overrides — 언제 오버라이드를 쓰는가

오버라이드는 다음 경우에 사용한다.

- **Resolving instruction conflicts** — agent-level 시스템 instructions가 특정 서브에이전트가 해야 할 일과 모순될 때. 충돌하는 instructions는 에이전트에 예기치 않은 동작을 일으킬 수 있다.
- **Different subagents need different tones** — 캐주얼한 FAQ 서브에이전트 vs. 격식 있는 컴플라이언스 서브에이전트. 기술 전문가 vs. 비기술 사용자. 캐주얼한 톤 vs. 전문적이고 사과하는 톤. 청구(billing) 전문가 vs. 기술 지원 전문가.

---

## 멀티턴 워크플로우 강제 (Enforce Required Workflows Through Subagents In Multi Turn Conversations)

시퀀스 규칙이 복잡하더라도, 멀티턴 대화 전반에서 에이전트가 서브에이전트 시퀀싱 규칙을 준수하도록 보장한다. step 변수를 사용해 agent router가 어떤 서브에이전트를 선택할지 제어한다. 서브에이전트 안에서는 에이전트가 고객의 답변을 평가하고 다음 단계를 위한 step 변수를 설정하도록 한다.

**Why Use This Pattern**

이 패턴은 다음 경우에 사용한다.

- 에이전트가 긴 필수 질문 시퀀스를 물어야 하고, 다음 질문으로 넘어가기 전에 각 답변을 검증해야 할 때
- 다음에 물을 질문이 이전 질문의 답변에 의존할 때
- 에이전트가 단일 서브에이전트에서 여러 턴을 보낼 수 있을 때 — 예를 들어 특정 급여 요구사항을 명확히 하거나 자격증 동등성을 설명하는 경우

**When Not to Use This Pattern**

단일 전제 조건 게이트만 필요할 때 — 예를 들어 라우팅 전 인증, 또는 order help 전에 `order_id`를 수집하는 것 같은 단일 서브에이전트 전제 조건 — 에는 [[Agent Script 패턴 — 라우팅·전환·필수 워크플로우]]의 더 간단한 패턴(Enforce Required Workflows for a Subagent)을 사용한다.

### Example: Step-Driven Interview Questions

이 패턴에서 `start_agent`는 `currentInterviewStep` 변수를 사용해 현재 서브에이전트를 선택한다. 각 서브에이전트에서 에이전트는 고객에게 특정 질문 세트를 묻는다. 고객의 응답에 따라 에이전트는 `currentInterviewStep` 변수 값을 설정하여, 시퀀스의 다음 서브에이전트가 무엇이 될지 제어한다.

예를 들어 `permission` 서브에이전트에서 에이전트는 고객에게 해당 지역에서 일할 법적 허가가 있는지 묻는다.

- 고객이 허가를 **가지고 있으면**, 에이전트는 `currentInterviewStep`을 `Eligibility`로 설정하여 agent router가 `eligibility` 서브에이전트로 라우팅하게 한다.
- 고객이 허가를 **가지고 있지 않으면**, 에이전트는 `currentInterviewStep`을 `End`로 설정하여 agent router가 `end_interview` 서브에이전트로 라우팅하게 한다.

```agentscript
start_agent agent_router:
    label: "Agent Router"

    description: "Welcome the user and determine the appropriate subagent based on user input"

    reasoning:
        instructions: ->
            if @variables.currentInterviewStep == "Permission":
                transition to @subagent.permission
            if @variables.currentInterviewStep == "Eligibility":
                transition to @subagent.eligibility
            if @variables.currentInterviewStep == "Availability":
                transition to @subagent.availability
            if @variables.currentInterviewStep == "End":
                transition to @subagent.end_interview


subagent permission:
    label: "Permission"

    description: "Confirm the candidate has the legal right to work in Wonderland."

    reasoning:
        instructions: ->
            | Confirm whether the candidate has the legal right to work in Wonderland.
              Ask a clear yes or no question and allow the candidate to provide context if needed.
              If the candidate confirms eligibility, acknowledge and advise the next step.
              If the candidate is not eligible or refuses to answer, advise that the role requires work authorization.
              If the candidate is eligible, call {!@actions.setCurrentInterviewStep} with currentInterviewStep set to "Eligibility".
              If the candidate is NOT eligible, call {!@actions.setCurrentInterviewStep} with currentInterviewStep set to "End".

        actions:
            setCurrentInterviewStep: @utils.setVariables
                description: "Set the CurrentInterviewStep variable"
                with currentInterviewStep = ...
```

### Tips

- **Keep one responsibility per subagent** — 각 서브에이전트가 하나의 필수 답변을 검증한 뒤 다음 단계로 넘어가도록 설계한다.
- **Use explicit step names** — `permission`, `eligibility`, `availability` 같은 명확한 값을 사용해 라우팅을 읽기 쉽고 유지보수하기 쉽게 한다.
- **Let subagents own completion logic** — 서브에이전트가 답변이 만족스러운 시점을 결정하고, 그럴 때까지 후속 질문을 계속하도록 한다.

---

## 관련 노트

- [[Agent Script 레퍼런스 — 변수·인스트럭션·표현식·연산자]] — 변수 선언·표현식·연산자 레퍼런스 (이 노트 변수·리스트 패턴의 기반)
- [[Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법)]] — `@utils.setVariables`(슬롯 필링)·`setCurrentInterviewStep` 문법
- [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]] — `run @actions`·`@outputs` 문법
- [[Agent Script 패턴 — 라우팅·전환·필수 워크플로우]] — 멀티턴은 라우터+전환의 확장, 단일 게이트 패턴 대비
- [[Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링]] — 조건 표현식·`available when` 공유
- [[Agent Script 블록 8종 (System·Config·Subagent 등)]] — `system` 블록(오버라이드 대상)·`variables` 블록 구조
- [[Agent Script 실행 흐름과 모델 설정]] — 서브에이전트 전환·프롬프트 구성
- [[Agent Script 개요와 언어 특성]] — Agent Script 언어 허브
- [[스킬 ↔ 위키 토픽 맵]] — sf-skill ↔ 위키 토픽 라우팅
