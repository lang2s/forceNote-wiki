---
tags: [agentforce, agent-script, language, overview, ai-agent]
source: AgentScriptDocs (Salesforce Agent Script Developer Guide, 2026-06-17판) — agent-script/agent-script.md, agent-script/ascript-lang.md, agent-script/ascript-examples.md
created: 2026-06-30
aliases: [Agent Script, 에이전트 스크립트, Agentforce, agent script language, 언어 특성, Compiled, Declarative, reasoning instructions, logic instructions, "Agent Script가 뭐야", "에이전트 스크립트 언어 특성", "-> 와 | 차이"]
---

# Agent Script 개요와 언어 특성

> Agentforce Builder에서 agent를 정의하는 언어 — 자연어 instruction의 유연성과 programmatic expression의 결정성을 결합한다.

---

> [!note] April 2026 명칭 전환 — topic → subagent
> Beginning in April 2026, agent **topics** are now called **subagents**. There are no changes to functionality. During this transition, you may see a mix of the new and previous terms in our documentation.
>
> (2026년 4월부터 agent의 **topic**은 **subagent**로 불린다. 기능 변화는 없으며, 전환 기간 동안 문서에 신·구 용어가 혼재할 수 있다.)

---

## 개요 — Agent Script란 무엇인가

### What's Agent Script?

Agent Script는 **Agentforce Builder에서 agent를 build하는 언어**다. Script는 두 가지를 결합한다.

1. 자연어 instructions의 **유연성** — 대화형(conversational) task 처리에 강하다.
2. programmatic expressions의 **신뢰성** — business rules 처리에 강하다.

Script에서 expressions로 다음을 정의할 수 있다.

- if/else 조건·transitions·기타 logic 정의
- 변수 set / modify / compare
- subagents·actions 선택

이로써 LLM 해석에만 의존하지 않는 **predictable·context-aware agent workflow**를 build할 수 있다. 예를 들어 agent가 한 subagent에서 다른 subagent로 transition하는 시점을 제어하거나, action을 특정 순서로 실행(이른바 **action chaining**)하도록 제어할 수 있다.

### What Can You Do with Agent Script?

Agent Script는 자연어 prompt의 conversational skill·complex reasoning 능력을 보존하면서 programmatic instruction의 determinism을 추가한다. 정의할 수 있는 것은 다음과 같다.

- **LLM이 reasoning 결정을 자유롭게 하는 영역** — Reasoning Instructions 참조.
- **agent가 deterministic하게 실행해야 하는 영역** — Reasoning Instructions 참조.
- **Variables** — agent의 current state 정보를 LLM context memory에 의존하지 않고 신뢰성 있게 저장한다. Variables 참조.
- **Conditional expressions** — agent의 실행 경로 또는 LLM의 발화를 결정한다. 예: `is_member` 변수 값에 따라 고객에게 다르게 말하기; `appointment_type` 변수 값에 따라 실행할 action을 deterministic하게 지정. Conditional Expressions 참조.
- **subagent transition 조건** — deterministic transition이 가능하다. 또는 subagent transition을 LLM에 tool로 노출해, LLM이 언제/여부를 결정하게 할 수도 있다. Tools, Utils 참조.

### Example Agent Script (Hello-world)

다음은 Agent Script 예제다. (출처: `agent-script.md` 원문 verbatim)

```agentscript
system:
    instructions: "You are a friendly and empathetic agent that helps customers with their questions."
    messages:
        error: "Sorry, something went wrong."
        welcome: "Hello! How are you feeling today?"

config:
    agent_name: "HelloWorldBot"
    default_agent_user: "hello@world.com"

language:
    default_locale: "en_US"
    additional_locales: ""

variables:
    isPremiumUser: mutable boolean = False
        description: "Indicates whether the user is a premium user."

start_agent hello_world:
    description: "Respond to the user."
    reasoning:
        instructions: ->
            if @variables.isPremiumUser:
                | ask the user if they want to redeem their Premium points
            else:
                | ask the user if they want to upgrade to Premium service
```

위 reasoning instructions에서는 conditional logic(`->` 뒤)을 LLM prompt(`|` 뒤)와 함께 지정한다. 이 조합이 predictable·deterministic logic과 LLM reasoning의 장점을 동시에 제공한다.

---

## 작성 방법 — Agentforce Builder 3가지 뷰 + Agentforce DX

Agent Script로 hands-on을 시작하려면 **Create an Agent → view picker에서 Script 선택**한다. 또는 Agentforce DX로 agent를 작성한다. (Agentforce Builder의 Agent Script UI 화면이 원문에 이미지 `agent-script-view3.png`로 제공되나, 본 위키에는 텍스트 설명만 둔다.)

Agentforce Builder에서 Agent Script를 작성하는 방법은 3가지다.

- **Chat with Agentforce** — 원하는 동작을 자연어로 설명한다(예: "If the order total is over $100, then offer free shipping."). Agentforce가 이를 subagents·actions·instructions·기타 expressions로 변환한다.
- **Canvas view** — Agent Script를 이해하기 쉬운 blocks로 요약 표시하고, 펼쳐서 underlying script를 확인한다. quick action shortcut으로 편집하며, `/` 입력은 공통 패턴(예: if/else conditionals) expression 추가, `@` 입력은 resources(subagents·actions·variables) 추가다.
- **Script view** — 고급 사용자가 script를 직접 작성·편집한다. syntax highlighting, autocompletion, validation 같은 개발자 친화 보조 기능을 제공한다.

추가로, 개발자는 **Agentforce DX**로 script 파일을 로컬 Salesforce DX 프로젝트로 generate/retrieve한 뒤 VS Code에서 작업할 수 있다. Agentforce DX VS Code Extension이 Agent Script 언어를 표준 코드 편집 기능으로 완전 지원한다.

---

## 언어 특성 9종

> Agent Script는 Salesforce가 Agentforce agent build 전용으로 설계한 언어다. (출처: `ascript-lang.md`) 아래 코드는 모두 원문 verbatim 인용이다.

### 1. Compiled

Agent Script는 compiled 언어다. agent의 한 버전을 save하면 script가 reasoning engine이 사용하는 lower-level metadata로 compile된다.

### 2. Determinism Plus Reasoning

deterministic logic과 LLM reasoning을 단일 workflow에 결합한다. 이 hybrid 접근으로 필요한 곳엔 predictable execution을, 동시에 LLM의 nuanced한 대화 처리 능력은 보존한다.

- **Logic instructions** (`->`): 매번 deterministic하게 실행된다. business rules·action 실행·변수 set·conditional branching에 사용한다.
- **Prompt instructions** (`|`): LLM에 보내는 자연어다. LLM이 해석하고 고객 응답 방식을 결정한다.

### 3. Declarative With Procedural Components

선언형(declarative)과 절차형(procedural) 요소를 모두 보유해, predictable하면서 maintain하기 쉬운 agent를 build한다.

- **Declarative language** — step-by-step 흐름을 걱정하지 않고 원하는 것을 직접 _declare_한다. 기본 Agent Script Blocks가 declarative 언어를 닮았다.
- **Procedural language** — 특정 순서로 command를 실행하는 방법을 지정한다. reasoning instructions의 logic이 procedural 언어를 닮았다.

### 4. Human-Readable

non-developer도 agent의 동작을 기본적으로 이해할 수 있도록 human-readable하게 설계되었다.

### 5. Property-Based

properties의 모음으로 구성된다. 각 property는 `key: value` 형태다. 일부는 여러 줄이고, 일부는 sub-properties를 포함한다. `key`는 항상 콜론(`:`) 앞에, `value`는 항상 콜론 뒤에 온다.

```agentscript
description: "Get account info"
```

top-level properties는 **blocks**라고 부른다. 예를 들어 아래 섹션은 config block이라고 부른다.

```agentscript
config:
    developer_name: "Demo_Agent_1"
    default_agent_user: "digitalagent.demo@salesforce.com"
    agent_label: "Demo Agent"
    description: "This is my demo agent"
```

### 6. Indentation and Formatting

whitespace-sensitive하다(Python·YAML과 유사). indentation으로 구조와 property 관계를 표현한다. value가 이전 줄 property에 속함을 표시하려면 **최소 2 spaces 또는 1 tab**을 indent한다. **단, 한 가지 indentation 방식을 선택해 전체 script에서 일관되게 사용**해야 한다. 같은 nesting level의 모든 줄은 같은 indentation을 사용하며, spaces와 tabs를 혼용하면 parsing error가 발생한다.

```agentscript
inputs:
    input_1: string
    input_2: string
```

logic instructions는 arrow `->`와 indented instructions로 지정한다.

```agentscript
instructions: ->
    if @variables.ready_to_book:
        run @actions.get_account_info
            with account_id=@variables.account_id
            set @variables.hotel_code=@outputs.hotel_code
```

multiline string(reasoning instructions·descriptions·system messages)은 pipe `|`로 지정한다.

```agentscript
instructions:|
    Welcome to our service!
    Please provide details about your request.
    I'll help you with whatever you need.
```

pipe는 logic-based instructions에서 prompt로 전환할 때도 사용한다.

```agentscript
    reasoning:
        instructions: ->
            | You are assessing the customer's timing for making a decision.
              Follow these rules to determine what to ask:

            if @variables.Lead_Record.S4STiming != "":
                | Existing timing data found.
                  Current Timing Value: {! @variables.Lead_Record.S4STiming }

                  Ask: "From what we have, you're looking to make a decision by {! @variables.Lead_Record.S4STiming }. Is that still correct?"

                  Wait for their response before proceeding.
```

### 7. Accessing Resources

`@` 기호로 resource에 접근한다(actions·subagents·variables).

- `@actions.<action_name>` — action 참조
- `@subagent.<subagent_name>` — subagent 참조
- `@variables.<variable_name>` — variable 참조
- `@outputs.<output_name>` — action output 참조

action 실행은 `run` 명령으로, 입력 제공은 `with`로, 출력 저장은 `set`으로 한다.

```agentscript
run @actions.show_great_example
   with QuestionRecordId=@variables.my_great_question
   set @variables.my_great_answer = @outputs.AnswerDescription
```

reasoning instructions의 prompt text 내에서 변수를 참조할 때는 **반드시 brackets**를 사용한다: `{!@variables.<variable_name>}`.

```agentscript
| Ask the user this question: {!@variables.my_question}
```

subagent를 LLM이 쓸 수 있는 tool로 지정할 수도 있다. Tools (Reasoning Actions) 참조.

### 8. Using Expressions

익숙한 flow control syntax를 제공한다: `if`, `else`. 기본 산술 expression(`+`, `-`), 비교 expression(`==`, `!=`, `>`, `<`)을 지원한다. empty 값 확인은 `is None`, `is not None`으로 한다.

```agentscript
if @variables.count >= 10:
    run @actions.count_achieved_announcement
else:
    run @actions.count_missed_announcement
```

### 9. Comments to Help the Humans

pound `#` 기호 뒤에 comment를 단다. `#` 뒤의 줄 내용은 script가 무시한다. script 내 문서화에 사용한다.

```agentscript
# This is an agent sample script that demonstrates deterministic behavior
```

---

## 토큰·연산자 치트시트

> 위 언어 특성 7·8·9에 분산된 토큰을 조회용으로 한곳에 모았다. (정의 원문은 각 특성 섹션 참조)

| 토큰 / 연산자 | 의미 | 비고 |
|---|---|---|
| `->` | logic instructions (deterministic 실행) | business rules·action·변수 set·conditional branching |
| `\|` | prompt instructions / multiline string | LLM에 보내는 자연어, logic→prompt 전환 |
| `@actions.<name>` | action 참조 | `run`으로 실행 |
| `@subagent.<name>` | subagent 참조 | tool로 노출 가능 |
| `@variables.<name>` | variable 참조 | global/linked 변수 |
| `@outputs.<name>` | action output 참조 | `set`으로 저장 |
| `run` | action 실행 명령 | |
| `with` | action 입력 제공 | |
| `set` | action 출력 저장 | |
| `{!@variables.x}` | prompt text 내 변수 참조 | brackets 필수 |
| `if` / `else` | flow control | |
| `+` `-` | 산술 expression | |
| `==` `!=` `>` `<` | 비교 expression | |
| `is None` / `is not None` | empty 값 확인 | |
| `#` | comment (script가 무시) | |

---

## 예제 (Agent Script Examples)

> `ascript-examples.md`는 agent build를 시작하기 위한 예제 Agent Script를 제공한다. 각 예제는 full script와 주요 개념 설명을 포함한다. 단, 실제 full script는 별도 `agent-examples/` 파일에 위치하며(이번 위키화 범위 밖), 여기서는 외부 링크로 안내한다.

| Example | Description |
|---|---|
| Customer Support (`agent-examples/ascript-examples-customer-support.md`) | An agent that verifies identity and provides order information |
| Enforce Subagent Sequencing With Variables (`agent-examples/ascript-examples-multi-turn.md`) | A step-based interview agent that enforces question order while handling natural conversation |
| Ground Your Agent With Updated Terminology (`agent-examples/ascript-example-rag-jargon.md`) | Ensure that your grounded agent understands your organization's evolving jargon without having to update your information sources |

- 더 많은 예제: **Agent Script Recipes** — developer.salesforce.com/sample-apps/agent-script-recipes (원문에 `agent-script-recipes.png` 배너 이미지 제공, 본 위키에는 링크만).

### Agent Skills (외부 리소스)

- **Skills in Agentforce Vibes** — Agentforce Vibes에서 skill 사용법.
- **Agentforce Vibes Library** — github.com/forcedotcom/afv-library, skill을 지원하는 AI tool용 Salesforce agent skill 큐레이션 모음.
- **Agentforce Development Skill** — Agent Script로 Agentforce agent를 build/modify/debug/deploy하기 위한 특정 skill (Vibes Library 내).

---

## 관련 노트

- [[Agent Script 블록 8종 (System·Config·Subagent 등)]] — Agent Script를 구성하는 8종 블록(System·Config·Variables·Language·Connection·Subagent·Connected_Subagent·Start Agent)의 목적·문법·속성·예제 전수
- [[Agent Script 실행 흐름과 모델 설정]] — 런타임 실행 순서(3경로·11단계 프롬프트 구성)·model_config 모델 설정
- [[스킬 ↔ 위키 토픽 맵]] — Agentforce 실행 스킬(agentforce-generate 등) 디스패처. 지식(이 노트) vs 실행(스킬) 레이어 구분
