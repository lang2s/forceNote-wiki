---
tags: [Agentforce, AgentScript, tools, utils, 툴, 유틸, reference]
source: AgentScriptDocs (Salesforce Agent Script Developer Guide, 2026-06-17판) — agent-script/reference/ascript-ref-tools.md, agent-script/reference/ascript-ref-utils.md
created: 2026-06-30
aliases: [AgentScript tools, reasoning actions, 툴, 유틸, "@utils", "transition to", setVariables, escalate, end_session, "available when", with, set, 단방향 전이, subagent 직접 참조, "@utils.transition과 직접참조 차이", "AgentScript에서 사람에게 escalate", "변수를 LLM이 설정하게 하려면", "tool 가용 조건 available when"]
---

# Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법)

> AgentScript 툴(reasoning actions) 문법과 @utils 4종(transition to·setVariables·escalate·end_session) — wrap·with·set·available when, 단방향 전이 vs 직접 참조.

---

## 개요

툴(tool)은 LLM이 tool의 description과 현재 context를 바탕으로 호출을 선택할 수 있는 실행 함수다. 툴은 subagent의 `reasoning.actions` 블록에 정의한다. 툴은 [액션](#)일 수도, 다른 [유틸리티(`@utils`)](#utils-함수-4종)일 수도 있다.

툴은 반드시 액션 또는 `@utils` 함수를 **wrap** 해야 한다. 파라미터 바인딩에는 `with`, 출력값을 변수에 할당하는 데는 `set`을 사용한다. `available when` 파라미터로 툴이 언제 사용 가능한지 결정적으로 지정할 수 있다.

> [!tip] Tools vs. Actions
> Agent Script에는 두 개의 `actions` 블록이 있다.
> - **Subagent actions** (`subagent.actions`) — 로직 기반 reasoning instructions에서 당신(개발자)이 사용 가능
> - **Reasoning actions** (`subagent.reasoning.actions`) — LLM이 필요에 따라 호출, prompt 기반 instructions에서 참조 가능
>
> reasoning actions는 일반 subagent 액션 외에 subagent와 utility도 참조할 수 있으므로, 더 넓은 용도를 반영해 이를 "tools"라고 부르기도 한다. Canvas view에서는 이 구분이 자동 처리되지만, Agent Script를 직접 작성할 때는 이해하는 것이 중요하다.

> 액션 정의의 상세(Action Properties·target URI·파라미터 타입·inputs/outputs)는 [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]] 참조.

---

## 툴 문법 (Tools / Reasoning Actions)

### 구성 요소

- 모든 툴은 액션 또는 `@utils` 함수를 **wrap** 해야 한다.
- `with` — 파라미터 바인딩(bind parameters).
- `set` — 출력값을 변수에 할당(assign output values to variables).
- `available when` — 툴 가용 조건을 결정적으로 지정. 뒤에 오는 절은 유효한 conditional expression이어야 한다.
- 툴은 `reasoning.actions` 블록에 정의한다.

### LLM이 어느 툴을 호출할지 결정하는 방식

LLM은 툴을 호출할지 결정할 때 모든 툴의 **이름과 description**을 본다. 따라서 툴에는 의미 있는 이름과 description을 부여해야 한다. 더 많은 context를 제공하려면 reasoning instructions에서 툴을 명시적으로 참조한다.

다음 reasoning instructions는 어느 툴을 호출할지에 대한 추가 context를 제공하지 않는다.

```agentscript
reasoning:
    instructions: ->
        | Use the action that best matches the user's message and the conversation context.
    actions:
        # This tool calls the Get_Customer_Info action
        lookup_customer: @actions.Get_Customer_Info
            with email=@variables.customer_email
            set @variables.customer_desc = @outputs.customer_description

        # This tool writes the customer-provided information
        # into the specified variables. The LLM can choose when to use it.
        capture_order_info: @utils.setVariables
            description: "Capture order search information from customer"
            with order_number=@variables.order_number
            with customer_email=@variables.customer_email
            available when @variables.customer_verified == True

        # This tool transitions to a subagent that
        # displays detailed information about the order
        show_order_details: @utils.transition to @subagent.order_details
            description: "Show detailed order information"
```

다음 reasoning instructions는 `capture_order_info` 툴을 언제 쓸지에 대한 더 자세한 정보를 제공한다.

```agentscript
reasoning:
    instructions: ->
        | If the customer is verified and provides their order number
           or email, use {!@actions.capture_order_info} to store the information.

           Otherwise, use the action that best matches the user's message and the conversation context.

    actions:
        # This tool calls the Get_Customer_Info action
        lookup_customer: @actions.Get_Customer_Info
            with email=@variables.customer_email
            set @variables.customer_desc = @outputs.customer_description

        # This tool writes the customer-provided information
        # into the specified variables. The LLM can choose when to use it.
        capture_order_info: @utils.setVariables
            description: "Capture order search information from customer"
            with order_number=@variables.order_number
            with customer_email=@variables.customer_email
            available when @variables.customer_verified == True

        # This tool transitions to a subagent that
        # displays detailed information about the order
        show_order_details: @utils.transition to @subagent.order_details
            description: "Show detailed order information"
```

### available when — 툴 가용 조건 정의

`available when`은 LLM이 툴을 사용하기 위해 충족되어야 하는 조건을 정의한다. `available when` 뒤의 절은 지원되는 연산자로 구성된 유효한 conditional expression이어야 한다.

```agentscript
reasoning:
    actions:
        cancel_booking: @actions.cancel_booking
            with booking_id=@variables.current_booking_id
            available when @variables.booking_status == "active"

        admin_override: @actions.admin_override
            available when @variables.user_role == "admin"

        go_to_identity: @utils.transition to @subagent.Identity
             description: "verifies user identity"
             available when @variables.verified == False
```

---

## subagent를 툴로 참조

reasoning actions에서는 subagent를 두 가지 방식으로 참조할 수 있다. 직접 참조 `@subagent.<topic_name>` 또는 선언적 전이 `@utils.transition to`. 이 둘의 차이가 핵심 혼동 포인트다.

| 방식 | 의미 | 제어 흐름 |
|---|---|---|
| `@subagent.<topic_name>` (직접 참조) | subagent에 위임(delegate) — 액션/툴 호출과 유사 | 참조된 subagent 실행 후 **원래 호출자로 복귀** |
| `@utils.transition to @subagent.<...>` (선언적 전이) | 선언적 전이 | **단방향** — 복귀 없음 |

직접 참조 `@subagent.<topic_name>`를 쓰면 subagent에 위임하고, 실행이 끝나면 원래 subagent로 흐름이 복귀한다. 이는 선언적 전이(`@utils.transition to`)와 다른 점으로, 전이는 단방향인 반면 직접 참조는 호출자로 돌아온다. 참조된 subagent가 선언적 transition을 포함하면, 흐름은 그 경로가 끝날 때까지 따라간 뒤 원래 subagent로 복귀한다.

다음 코드는 다른 subagent를 호출하는 두 방식을 모두 보여준다.

```agentscript
reasoning:
    actions:

        # Transitions to the other subagent and does not return
        show_order_details: @utils.transition to @subagent.order_details
            description: "Show detailed order information"

        # Runs the other subagent as a tool, synthesizes the result, then can run more tools
        consult_specialist: @subagent.specialist_topic
            description: "Consult specialist for complex questions"
            available when @variables.needs_expert_help == True
```

---

## @utils 함수 4종

`@utils`는 툴로 사용할 수 있는 유틸리티 함수다. 예를 들어 subagent로의 전이, 액션 실행, 또는 고객 발화를 바탕으로 LLM이 변수 값을 설정하도록 지시하는 등의 기능을 한다. 전수 4종은 `@utils.transition to`·`@utils.setVariables`·`@utils.escalate`·`@utils.end_session`이다.

### @utils.transition to

agent에게 다른 subagent로 이동하라고 지시한다.

전이는 단방향이다. 호출한 subagent로 제어가 복귀하지 않는다. `transition to`는 만나는 즉시 실행된다. 현재 directive 블록의 실행이 중단되고, 제어가 새 subagent로 넘어간다.

`actions:` 블록에 transition 로직을 포함하면 액션 완료 직후 hand off를 신호할 수 있다. 단, 이는 모든 액션이 실행되기 전까지는 일어나지 않을 수 있다.

```agentscript
# during reasoning

reasoning:
    actions:
        go_to_identity: @utils.transition to @subagent.Identity
            description: "verifies user identity"
            available when @variables.verified == False
        go_to_order: @utils.transition to @subagent.Order_Management
            description: "Handles order lookup, refunds, order updates, and summarizes status, order date, current location, delivery address, items, and driver name."
            available when @variables.verified == True
        go_to_faq: @utils.transition to @subagent.General_FAQ
            description: "Handles FAQ lookup and provides answers to common questions."
            available when @variables.verified == True
```

위 샘플은 order management, user verification, 일반 질문 답변에 대한 다수의 전이를 제공한다. 이 전이들은 reasoning actions 안에서 지정되었기 때문에, 적용 가능할 때 reasoning engine에 의해 실행될 수 있다.

reasoning instructions에서도 `transition to`로 subagent에 전이할 수 있다. 다음 샘플은 변수 상태에 따라 전이한다.

```agentscript
if @variables.approval_required:
    transition to @subagent.approval_workflow
```

지정된 subagent가 완료되어도 제어 흐름은 원래 subagent로 복귀하지 않으므로, 돌아가길 원한다면 원래 subagent로의 전이를 **명시적으로** 만들어야 한다. subagent로 다시 전이할 때, 흐름은 마지막에 떠난 지점이 아니라 **subagent의 처음부터** 시작한다.

```agentscript
# in topic A, specify that the flow of control jumps to topic_b

search_another: @utils.transition to @subagent.topic_b
    description: "Search for another order"

# in topic B, specify that the flow of control goes (back) to topic_a

back_to_order: @utils.transition to @subagent.topic_a
    description: "Return to order details"
```

> 전이의 단방향성·flow of control 전반은 [[Agent Script 실행 흐름과 모델 설정]] 참조.

### @utils.setVariables

agent에게 자연어 description을 바탕으로 변수를 정의하라고 지시한다. `…` 토큰은 LLM에게 변수 값을 설정하라고 지시한다. `description`은 LLM에게 변수 값을 어떻게 설정할지 지시한다.

```agentscript
reasoning:
    actions:
        set_first_name_variable: @utils.setVariables
            with first_name = ...
            description: "Get the user's first name"
```

> 토큰 주의: `…`(ellipsis) = LLM이 변수 값을 설정하도록 지시하는 토큰. 원문 설명은 유니코드 `…`로 표기하지만, 예제 코드는 ASCII `...`를 사용한다.

### @utils.escalate

agent에게 사람 서비스 상담원(human service rep)으로 escalate 하라고 지시한다. `utils.escalate`를 사용하려면 활성화된 Omni-Channel connection이 필요하다. 이는 `connection messaging` 블록에 `outbound_route_type`·`outbound_route_name` 값과 함께 정의되어야 한다. escalate 유틸리티 함수는 escalation subagent 대신 사용할 수 있다.

```agentscript
subagent my_topic_name:
    reasoning:
        instructions:
            | call the action {!@actions.escalate_to_human} if the user wants to speak with a human rep
        actions:
            escalate_to_human: @utils.escalate
                description: "Call this when you need to escalate to a human rep"
                available when @variables.in_business_hours
```

> [!note]
> `escalate`는 예약 키워드(reserved keyword)이며 subagent나 action 이름으로 사용할 수 없다.

**제약:** 활성 Omni-Channel connection 필요. `connection messaging` 블록에 `outbound_route_type`·`outbound_route_name` 값 정의 필수. (`connection` 블록 자세한 내용은 [[Agent Script 블록 8종 (System·Config·Subagent 등)]] 참조.)

### @utils.end_session

agent에게 대화를 즉시 종료하라고 지시한다. 작업 완료 후나 특정 조건이 충족될 때처럼 agent가 세션을 종료해야 할 때 `utils.end_session`을 사용한다.

다음 예제에서 LLM은 대화 종료 시점을 선택할 수 있다 — 예를 들어 고객이 부적절한 발화를 하는 경우.

```agentscript
reasoning:
    instructions: ->
        | Use your general knowledge to answer the user's questions.
        | If the user asks about aliens, you MUST say "aliens don't exist!" and run {!@actions.end_conversation} and end the conversation immediately.
    actions:
        end_conversation: @utils.end_session
```

다음 예제에서 agent router는 고객이 더 이상 도움이 필요 없다고 말하면 `go_to_EndSession` 액션을 실행하기로 선택한다. `go_to_EndSession` 액션은 `EndSession` subagent로 전이하고, 그 subagent가 `end_session` util을 실행한다.

```agentscript
variables:
  start_agent agent_router:
      label: "Agent Router"
      description: "Welcome the user and determine the appropriate subagent based on user input"
      model_config:
          model: "model://sfdc_ai__DefaultEinsteinHyperClassifier"
      reasoning:
          instructions: ->
              | Select the best tool to call based on conversation history and user's intent.
          actions:
              go_to_EndSession: @utils.transition to @subagent.EndSession
                  description: "End the session when the user says the conversation is over, or they don't need any more help."

  subagent EndSession:
    label: "End Session"
    description: "End the session when the user says the conversation is over, or they don't need any more help."
    reasoning:
        instructions: ->
            | End the conversation immediately.
        actions:
            end_conversation: @utils.end_session
                description: "End the session when the user says the conversation is over, or they don't need any more help."
```

> 위 예제의 `model://sfdc_ai__DefaultEinsteinHyperClassifier`(model URI scheme, `start_agent`의 `model_config`)는 모델 설정 소관 → [[Agent Script 실행 흐름과 모델 설정]] 참조.

---

## @utils 요약표

| 함수 | 동작 | 핵심 문법/파라미터 | 제약·주의 |
|---|---|---|---|
| `@utils.transition to @subagent.<name>` | 다른 subagent로 단방향 이동(제어 복귀 없음). 만나는 즉시 실행, 현재 directive 블록 실행 중단 후 제어 이양. | `description`, `available when` 사용 가능. reasoning.actions 또는 reasoning instructions(`transition to`)에서 사용 | 복귀 없음 — 돌아오려면 명시적 역transition 필요. 복귀 시 subagent 처음부터 시작(마지막 위치 아님) |
| `@utils.setVariables` | 자연어 description 기반으로 LLM이 변수 값 설정 | `with <var> = ...` (`…`/`...` 토큰 = LLM이 값 설정), `description`으로 설정 방법 지시 | — |
| `@utils.escalate` | 인간 상담원으로 escalate | `description`, `available when` 사용 가능 | 활성 Omni-Channel connection 필요. `connection messaging` 블록에 `outbound_route_type`·`outbound_route_name` 정의 필수. `escalate`는 예약 키워드 — subagent/action 이름 사용 불가. escalation subagent 대체 가능 |
| `@utils.end_session` | 대화 즉시 종료 | `description` 사용 가능 | 작업 완료/특정 조건 충족 시 사용 |

---

## Subagent actions vs Reasoning actions (구분표)

| 블록 | 위치 | 누가 호출 | 호출 시점 |
|---|---|---|---|
| Subagent actions | `subagent.actions` | 로직 기반 reasoning instructions에서 개발자가 결정적으로(`run @actions.<name>`) / `after_reasoning` 블록 | subagent 파싱 시(매 실행) / `after_reasoning`은 subagent 종료 후 |
| Reasoning actions (= Tools) | `subagent.reasoning.actions` | LLM이 주관적으로 선택, prompt에서 `{!@actions.<name>}` 참조 가능 | LLM이 resolved prompt 받을 때(파싱 시 아님) |

> 액션 정의의 상세는 [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]] 참조.

---

## 관련 노트
- [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]]
- [[Agent Script 개요와 언어 특성]]
- [[Agent Script 블록 8종 (System·Config·Subagent 등)]]
- [[Agent Script 실행 흐름과 모델 설정]]
- [[Agent Script 레퍼런스 — 변수·인스트럭션·표현식·연산자]] — 변수·인스트럭션(Logic/Prompt)·표현식·연산자 레퍼런스
- [[스킬 ↔ 위키 토픽 맵]]
