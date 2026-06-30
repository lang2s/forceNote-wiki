---
tags: [agentforce, agent-script, blocks, system, config, subagent, ai-agent]
source: AgentScriptDocs (Salesforce Agent Script Developer Guide, 2026-06-17판) — agent-script/ascript-blocks.md
created: 2026-06-30
aliases: [Agent Script blocks, 에이전트 스크립트 블록, system block, config block, variables block, language block, connection block, subagent, connected_subagent, start_agent, 블록 8종, "Agent Script 블록 종류", "config 파라미터 뭐 있어", "start_agent 가 뭐야", "connected subagent 베타"]
---

# Agent Script 블록 8종 (System·Config·Subagent 등)

> Agent Script는 8종 블록(System·Config·Variables·Language·Connection·Subagent·Connected_Subagent·Start Agent)으로 구성된다 — 각 블록의 목적·문법·속성·예제 전수.

---

## 개요 — 블록이란 / 8종 목록

script는 blocks로 구성되며, 각 block은 property 집합을 보유한다. property는 data 또는 procedure를 기술한다. Agent Script는 여러 다른 block type을 보유한다. (원문에 `agent-script-blocks3.svg` 다이어그램이 제공되나, 본 위키에는 아래 목록 표로 대체한다.)

| # | 블록 | 토큰 prefix | 목적 |
|---|---|---|---|
| 1 | System Block | `system:` | agent의 general instructions + 시나리오별 message prompt (welcome·error 필수) |
| 2 | Config Block | `config:` | agent를 정의하는 configuration parameter |
| 3 | Variables Block | `variables:` | agent·script가 사용하는 global variables |
| 4 | Language Block | `language:` | agent가 지원하는 언어 정의 |
| 5 | Connection Block | `connection messaging:` | 외부 connection(예: Enhanced Chat)과의 상호작용 방식 |
| 6 | Subagent Blocks | `subagent <name>:` | subagent의 instructions·logic·actions 지정 |
| 7 | Connected_Subagent Blocks (Beta) | `connected_subagent <name>:` | org 내 다른 Agentforce agent로의 connection 정의 |
| 8 | Start Agent Block | `start_agent <name>:` | 매 utterance의 진입점, subagent classification·filtering·routing |

> 아래 코드 블록은 모두 원문 `ascript-blocks.md` verbatim 인용이다.

---

## 블록 8종

### 1. System Block

`system:` 블록은 agent의 general instructions를 포함한다. agent가 특정 시나리오에서 사용하는 message prompt 목록을 포함하며, `welcome`과 `error`는 **required messages**다.

- multiline messages는 pipe `|`를 사용한다.
- message 개인화나 context 정보 포함에는 linked variables를 사용한다.

예: welcome message에 사용자 preferred name을 동적으로 주입하려면 `{!@variables.userPreferredName}`를 쓴다. `userPreferredName`이 `Sam`이면 고객에게 "Hi Sam! I'm your personal shopping assistant"가 표시된다.

```agentscript
system:
    instructions:|
        You are an AI agent. Have a friendly conversation with the user.

    messages:
        welcome:|
            Welcome  {!@variables.userPreferredName}! I'm your personal shopping assistant.

            I can help you:
            - Find products and check availability
            - Track your orders
            - Process returns and refunds
            - Answer questions about our policies

            How can I assist you today?
        error: "Whoops!"
```

### 2. Config Block

`config:` 블록은 agent를 정의하는 configuration parameter를 포함한다.

| Parameter | Description |
|---|---|
| `developer_name` | The Salesforce API name of the agent (max 80 chars). Must start with a letter, contain only alphanumeric and underscores, and can't end with underscore or have consecutive underscores. Must be unique in your org - you can't have two agents with the same `developer_name`. |
| `default_agent_user` | API name or ID of the default Salesforce user that is used to run this agent. Required for AgentforceServiceAgent, ignored for AgentforceEmployeeAgent. |
| `agent_label` | Optional. The agent's label, displayed in the UI. Auto-generated from `developer_name` if not provided. |
| `description` | Description of the agent's goals and purpose. |
| `company` | Optional. Information about your company. |
| `role` | Optional. The agent's role. For example, "Help the customer select the perfect gift." |
| `agent_version` | The agent's version. Set automatically when you create a new version of your agent. |
| `agent_type` | Optional. The type of agent. Currently, allowed values are `AgentforceServiceAgent` (default) or `AgentforceEmployeeAgent`. Set automatically when you create an agent from a template. |
| `enable_enhanced_event_logs` | Optional. Indicates whether to enable conversation logging for debugging and monitoring. Allowed values are `True` or `False`. Default: `False`. |
| `user_locale` | Optional. User locale setting. |

```agentscript
config:
    developer_name: "Demo_Agent_1"
    default_agent_user: "digitalagent.demo@salesforce.com"
    agent_label: "Demo Agent"
    description: "This is my demo agent"
```

### 3. Variables Block

`variables:` 블록은 agent와 script가 사용할 수 있는 global variables 목록을 포함한다. Variables 참조.

```agentscript
variables:
    string_var: mutable string = "hello world"
    hotel_info: mutable string = "Dreamforce Hotel"
```

script 전반에서 변수는 `@variables.<variable_name>` syntax로 참조한다.

### 4. Language Block

`language:` 블록은 agent가 지원하는 언어를 정의한다.

```agentscript
language:
    default_locale: "en_US"
    additional_locales: ""
    all_additional_locales: False
```

지원 언어 목록은 Agentforce Language Support 참조.

### 5. Connection Block

`connection messaging:` 블록은 이 agent가 외부 connection과 상호작용하는 방식을 기술한다. 예를 들어 agent가 Enhanced Chat과 상호작용하는 방식을 정의한다.

```agentscript
connection messaging:
    escalation_message: "One moment while I connect you to the next available service representative."
    outbound_route_type: "OmniChannelFlow"
    outbound_route_name: "agent_support_flow"
    adaptive_response_allowed: True
```

connection block은 `@utils.escalate` 명령과 함께 사용할 수 있다.

### 6. Subagent Blocks

`subagent <name>:` 블록은 subagent의 instructions·logic·actions를 지정한다. subagent block은 description, actions 목록, reasoning instructions를 포함한다. (org 내 다른 Agentforce agent에 연결하려면 아래 **7. Connected_Subagent Blocks (Beta)** 참조.)

```agentscript
subagent Order_Management:
    description: "Handles order lookup, order updates, and summaries including status, date, location, items, and driver."

    reasoning:
        instructions: ->
            if @variables.order_summary == "":
                run @actions.lookup_current_order
                with member_email=@variables.member_email
                set @variables.order_summary=@outputs.order_summary

            | Refer to the user by name {!@variables.member_name}.
              Show their current order summary: {!@variables.order_summary} when conversation starts or if requested.
              If they want past order info, ask for Order ID and use {!@actions.lookup_order}.

        actions:
            lookup_order: @actions.lookup_order
                with query = ...
                set @variables.order_summary=@outputs.order_summary
                set @variables.order_id=@outputs.order_id

            lookup_current_order: @actions.lookup_current_order
                with member_email=@variables.member_email
                set @variables.order_summary=@outputs.order_summary
                set @variables.order_id=@outputs.order_id

    actions:
        lookup_order:
            description: "Retrieve order details."
            inputs:
                query: string
            outputs:
                order_summary: string
                order_id: string
            target: "flow://SvcCopilotTmpl__GetOrdersByContact"


        lookup_current_order:
            description: "Retrieve current order details."
            inputs:
                member_email: string
            outputs:
                order_summary: string
                order_id: string
            target: "flow://SvcCopilotTmpl__GetOrderByOrderNumber"
```

**Subagent block 구성 property (전수):**

- **subagent name** — subagent의 이름. scope·purpose를 몇 단어로 정확히 기술한다. 공백 불가이므로 `snake_case`를 사용한다.
- **description** — 이 subagent의 description. 사용자 intent를 기반으로 agent가 이 subagent를 사용할 시점을 판단하는 데 도움을 준다.
- **system.instructions** (optional) — 이 subagent에 한해 system-level instructions를 override한다. instruction override로 LLM에 충돌하는 instruction을 방지(예상치 못한 동작 유발 회피)하고, 특정 subagent용으로 voice & tone을 변경할 수 있다. Avoid Conflicting Instructions with Instruction Overrides 참조.
- **reasoning** — reasoning engine에 보내는 정보. 주요 property는 instructions, actions다.
  - **reasoning.instructions** — reasoning engine이 이 subagent가 사용자 요청에 relevant하다고 결정한 후의 guidance. logic instructions와 prompt-based instructions를 조합할 수 있다. Reasoning Instructions 참조.
  - **reasoning.actions** — reasoning engine이 사용할 수 있는 tools 목록. 상위 actions 섹션의 agent actions를 가리킬 수 있고, reasoning engine이 쓸 수 있는 기타 기능(다른 subagent로 transition, 변수 값 set 등)도 포함한다. Tools (Reasoning Actions) 참조.
- **actions** — 이 subagent에서 사용 가능한 agent actions를 정의한다. action description, inputs/outputs 목록, action이 위치한 target location을 포함한다. reasoning engine이 이 agent action 중 하나를 쓰게 하려면 `reasoning.actions`에서도 이 action을 가리켜야 한다. Actions 참조.

### 7. Connected_Subagent Blocks (Beta)

> [!warning] Multi-Agent Orchestration (connected subagents) — Beta/Pilot
> Multi-Agent Orchestration (connected subagents) is a pilot or beta service that is subject to the Beta Services Terms at Agreements - Salesforce.com or a written Unified Pilot Agreement if executed by Customer, and applicable terms in the Product Terms Directory. Use of this pilot or beta service is at the Customer's sole discretion.

`connected_subagent <name>:` 블록은 org 내 다른 Agentforce agent로의 connection을 정의한다. connected subagent는 현재 agent의 일부인 subagent와는 다르다. reasoning action에서 connected subagent를 사용해 다른 Agentforce agent에 task를 위임할 수 있다. Multi-Agent Orchestration (Beta) 참조.

```agentscript
connected_subagent CRM_Agent:
    label: "CRM_Agent"
    target: "agentforce://X00Dfi200000dpFZ_CRM_Agent"
    loading_text: |
        Fetching CRM information....
    description: "Use this tool for any request about CRM information"
    # define input variables that you'll use to pass information to the connected agent
    inputs:
        EndUserLanguage: string = @variables.EndUserLanguage
        currentRecordId: string = @variables.currentRecordId
```

connected subagent를 reasoning action으로 사용하는 예:

```agentscript
start_agent agent_router:
    label: "Agent Router"
    description: "Welcome the user and determine the appropriate subagent based on user input"
    reasoning:
        instructions: ->
            | Select the best tool to call based on conversation history and user's intent.
        actions:
            # transition to a subagent
            go_to_off_topic: @utils.transition to @subagent.off_topic

            # Route to the CRM_Agent connected subagent
            crm_agent: @connected_subagent.CRM_Agent
```

**connected_subagent block 구성 property (전수):**

- **connected_subagent name** — Agent Script 내 다른 곳에서 이 connected subagent를 참조할 때 사용하는 이름.
- **target** — 외부 agent를 식별하는 URI. Agentforce Builder에서 agent를 subagent로 connect할 때 채워진다.
- **label** (optional) — connected subagent용 human-readable label.
- **description** (optional) — connected subagent의 capabilities 또는 호출 시점을 기술한다. reasoning engine이 위임 시점을 결정하는 데 도움을 준다.
- **loading_text** (optional) — connected subagent 실행 중 고객에게 표시되는 message.
- **inputs** (optional) — connected subagent에 전달되는 값. 각 input binding은 두 side를 가진다.
  - **left side** (예: `customer_id`) — _connected_ subagent(다른 Agentforce agent)에 정의된 linked(context) 변수. connected subagent가 받기를 기대하는 값의 이름.
  - **right side** (예: `@variables.Customer_Id`) — connected subagent의 input을 calling agent의 변수에 binding한다. 임의 변수 type이 가능하다.
  - 예: input이 `customer_id: string = @variables.Customer_Id`이면, connected subagent의 `customer_id` 변수가 calling agent의 `Customer_Id` 변수 값을 받는다.

### 8. Start Agent Block

start agent block(Canvas view에서 "Agent Router")은 `subagent` prefix 대신 `start_agent` prefix를 쓰는 subagent다. 모든 고객 utterance마다 agent는 이 block에서 실행을 시작한다. `start_agent` subagent는 대화 시작에 사용되며, 보통 agent의 다른 subagent로 전환할 시점을 결정한다. 이 block은 subagent classification·filtering·routing을 처리한다.

```agentscript
start_agent agent_router:
    description: "Welcome the user and determine the appropriate subagent based on user input"
    reasoning:
        instructions: |
            You are an agent router for this assistant. Welcome the guest
            and analyze their input to determine the most appropriate subagent
            to handle their request.
        actions:
            go_to_identity: @utils.transition to @subagent.Identity_Verification
                description: "Verifies user identity"
                available when @variables.verified == False
            go_to_order: @utils.transition to @subagent.Order_Management
                description: "Handles order lookup, refunds, and order updates."
                available when @variables.verified == True
            go_to_faq: @utils.transition to @subagent.General_FAQ
                description: "Handles various frequently asked questions."
                available when @variables.verified == True
            go_to_escalation: @utils.transition to @subagent.Escalation
                description: "Handles escalation to a human rep."
                available when @variables.verified == True and @variables.is_business_hours == True
```

subagent routing·filtering에 start agent block을 사용하는 가이드는 Subagent Classification and Routing(Salesforce Help) 참조.

---

## 블록 구성·중첩 규칙

원문에 명시된 블록 간 관계는 다음과 같다.

- **top-level blocks** — `system` / `config` / `variables` / `language` / `connection messaging`(데이터·설정 블록)에 더해 `subagent` / `connected_subagent` / `start_agent`(agent 동작 블록)가 모두 top-level이다. (특성상 top-level property = block — [[Agent Script 개요와 언어 특성]] "Property-Based" 참조)
- **subagent의 `reasoning.actions` ↔ 상위 `actions`** — reasoning engine이 어떤 agent action을 쓰게 하려면, 해당 action을 subagent의 상위 `actions` 섹션에 정의하고 `reasoning.actions`에서도 가리켜야 한다(이중 참조).
- **start_agent = subagent의 특수형** — `start_agent`는 `subagent`와 같은 구조이나 prefix만 다른 라우터다. 매 utterance의 진입점으로 classification·filtering·routing을 담당하며, `@utils.transition to @subagent.<name>`으로 다른 subagent로 전환한다.
- **connected_subagent 위임** — `connected_subagent`는 reasoning action(`@connected_subagent.<name>`)으로 호출해 외부 Agentforce agent에 task를 위임한다(Beta).

---

## 관련 노트

- [[Agent Script 개요와 언어 특성]] — Agent Script 언어 자체(컴파일·결정성+추론·`->`/`|`/`@`/`{!}` 토큰)와 작성 3방식·언어 특성 9종
- [[스킬 ↔ 위키 토픽 맵]] — Agentforce 실행 스킬(agentforce-generate 등) 디스패처. 지식(이 노트) vs 실행(스킬) 레이어 구분
- [[Tooling API 객체 — 세일즈·예측·AI (포캐스팅·머신러닝·Einstein·Agentforce)]] — GenAiFunctionDefinition·GenAiPlannerDefinition 등 GenAi 메타데이터를 조회하는 Tooling API sObject(언어가 아닌 다른 API 레이어)
