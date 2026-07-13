---
tags: [Agentforce, AgentScript, flow-of-control, 실행흐름, model-config, 모델설정, EinsteinHyperClassifier, transition]
source: AgentScriptDocs (Salesforce Agent Script Developer Guide, 2026-06-17판) — agent-script/ascript-flow.md, agent-script/ascript-model.md
created: 2026-06-30
aliases: [flow of control, 실행 흐름, model_config, 모델 설정, EinsteinHyperClassifier, transition, "@utils.transition", subagent classification, 서브에이전트 전환, "에이전트 모델 어떻게 바꿔?", "Agent Script 실행 순서", "서브에이전트 전환 어떻게 동작해?"]
---

# Agent Script 실행 흐름과 모델 설정

> Agent Script의 3대 실행 경로(첫 요청·서브에이전트 처리·전환)와 프롬프트 구성 11단계, 그리고 model_config를 통한 모델 override·우선순위·EinsteinHyperClassifier 설정.

---

## 개요

실행 순서와 제어 흐름(flow of control)을 이해하면 더 나은 에이전트를 설계할 수 있다. Agentforce에는 3개의 주요 실행 경로(execution path)가 있다:

1. **에이전트로의 첫 요청** (First request to an agent)
2. **서브에이전트 처리** (Processing a subagent)
3. **서브에이전트 간 전환** (Transitioning between subagents)

이 노트는 두 개의 소스(`ascript-flow.md` 실행 흐름 + `ascript-model.md` 모델 설정)를 "실행 흐름(어떻게 동작하나) → 모델 설정(어떻게 구성하나)" 독자 path로 통합한다.

---

## 실행 흐름 (Flow of Control)

### 1. 첫 요청 — start_agent (agent router)

첫 요청을 포함한 **모든 요청**은 agent router인 `start_agent` 블록에서 시작한다. 보통 `start_agent` 서브에이전트는 다음 두 가지 용도로 쓴다:

1. 변수의 초기값(initial value) 설정
2. subagent classification 수행

**subagent classification**이란 현재 컨텍스트(current context)에 기반해 LLM에게 어떤 서브에이전트를 선택할지 알려주는 것이다.

> `start_agent` 블록 구조의 상세는 [[Agent Script 블록 8종 (System·Config·Subagent 등)]] 참조.

### 2. 서브에이전트 처리 (top-to-bottom 순차)

Agentforce는 서브에이전트의 text instructions, variables, `if`/`else` conditions, 그리고 기타 programmatic instructions를 사용해 LLM 프롬프트를 만든다. 처리 규칙은 다음과 같다:

- reasoning instructions는 **순차적으로(sequentially), 위에서 아래로(top-to-bottom)** 처리된다.
- reasoning instructions가 programmatic logic과 text instructions를 포함할 수 있지만, LLM은 **resolved prompt를 받은 후에만** reasoning을 시작한다 — Agentforce가 아직 파싱(parsing) 중일 때는 시작하지 않는다.
- reasoning instructions에 transition command가 있으면, Agentforce는 **즉시** 지정된 서브에이전트로 전환하고 기존의 resolved prompt를 폐기(discard)한다. (전환의 상세 규칙은 아래 "3. 서브에이전트 간 전환" 참조)

> reasoning instructions의 전체 명령어 집합은 별도 노트(예정)에서 다룬다.

#### 예시 — 서브에이전트로부터 프롬프트가 만들어지는 과정

Agentforce는 서브에이전트를 처리해 프롬프트를 만들고, 이를 LLM에 보낸다. 다음 서브에이전트를 보자.

**[코드 1] Order_Management 서브에이전트:**

```agentscript

subagent Order_Management:
    description: "Handles order inquiries."
    reasoning:
        instructions:->
            set @variables.num_turns = @variables.num_turns + 1
            run @actions.get_delivery_date
                with order_ID=@variables.order_ID
                set @variables.updated_delivery_date=@outputs.delivery_date

            | Tell the user that the expected delivery date for order number {!@variables.order_ID} is {!@variables.updated_delivery_date}

            run @actions.check_if_late
                with order_ID=@variables.order_ID
                with delivery_date=@variables.updated_delivery_date
                set @variables.is_late = @outputs.is_late

            if @variables.is_late == True:
                | Apologize to the customer for the delay in receiving their order.
    after_reasoning:
       if @variables.num_turns > 5:
           transition to @subagent.escalate_order

```

다음을 가정한다(Suppose that):

- order ID = `1234`
- current delivery date = `February 10, 2026`
- the package is late (패키지가 늦음)
- 에이전트가 현재 세션에서 이 서브에이전트에 두 번 진입했으므로 `num_turns`는 2

reasoning instructions를 처리한 후 Agentforce가 만드는 프롬프트는 다음과 같다.

**[코드 2] 처리 후 Agentforce가 만든 프롬프트:**

```agentscript
Tell the user that the expected delivery date for order number 1234 is February 10, 2026.
Apologize to the customer for the delay in receiving their order.
```

#### 프롬프트 구성 11단계 (How Agentforce Constructs the Prompt)

프롬프트를 구성하기 위해, Agentforce는 reasoning instructions를 한 줄씩(line by line) 파싱하며 다음 단계를 따른다. ([코드 1]의 서브에이전트가 위 가정 하에서 어떻게 [코드 2]의 프롬프트로 풀리는지의 런타임 trace다.)

1. Initialize the prompt to empty.
2. Increments the global variable `num_turns` from 2 to 3.
3. Run the action `get_delivery_date`.
4. Set the variable `updated_delivery_date` to the value of `outputs.delivery_date`, which was returned by the action.
5. Concatenate this string to the prompt: `Tell the user that the expected delivery date for order number 1234 is February 10, 2026.`
6. Run action `check_if_late`.
7. Set the variable `is_late` to the value of `outputs.is_late`, which was returned by the action.
8. Check whether the value of `@variables.is_late` == `True`.
9. Concatenate this string to the prompt: `Apologize to the customer for the delay in receiving their order.`
10. Process the `after_reasoning` instructions, which don't transition because `num_turns` is 3.
11. Send the prompt to the LLM and return the LLM's response to the customer.

### 3. 서브에이전트 간 전환 (transition)

전환(transition)은 reasoning action, reasoning instructions, 또는 before/after reasoning 블록에서 할 수 있다. 전환 규칙:

- `@utils.transition to`를 사용한 transition은 **one-way(단방향)** 이며, 제어권(control)은 이전 서브에이전트로 돌아오지 않는다.
- Agentforce는 이전 서브에이전트의 모든 prompt instructions를 폐기(discard)한다.
- 그 다음 두 번째 서브에이전트를 top to bottom으로 읽는다. 최종 프롬프트는 **두 번째 서브에이전트의 instructions만** 포함한다.
- 두 번째 서브에이전트가 완료되면(completes), Agentforce는 다음 customer utterance를 기다리며, 그 시점에 `start_agent` 서브에이전트로 복귀(return)한다.

다음 예시는 서브에이전트 `account_help`로 전환하는 `go_to_account_help`라는 reasoning action을 정의한다.

**[코드 3] go_to_account_help 전환 reasoning action:**

```agentscript
reasoning:
    actions:
        go_to_account_help: @utils.transition to @subagent.account_help
            description: "When a user needs help with account access"
```

> transition·서브에이전트의 토큰 정의는 [[Agent Script 개요와 언어 특성]], 블록 구조는 [[Agent Script 블록 8종 (System·Config·Subagent 등)]] 참조. transition을 사용하는 디자인 패턴은 별도 패턴 노트(예정)에서 다룬다.

---

## 모델 설정 (model_config)

기본값(default)으로 Agentforce는 org의 Setup에서 선택된 모델을 org의 모든 에이전트에 사용한다. 특정 에이전트와 그 에이전트 안의 서브에이전트에 대해 org 기본 모델을 override 할 수 있다.

모델을 지정하려면 `model_config`를 사용한다. 예를 들어:

**[코드 4] model_config 기본 형태:**

```agentscript
model_config:
    model: "model://sfdc_ai__DefaultBedrockAnthropicClaude45Sonnet"
```

supported model이면 무엇이든 지정할 수 있다(전체 목록은 아래 "model:// 식별자" 절 참조). 모델 선택을 테스트하려면 에이전트의 서로 다른 버전에서 서로 다른 모델을 사용한다.

> [!important]
> Thoroughly test your agent with your chosen model or models before deploying. Some supported models may not be suitable for your agent or agent's tools.

### 레벨별 model_config 적용

`model_config`는 에이전트 레벨, 서브에이전트 레벨, agent router 레벨에서 각각 지정할 수 있다.

**[코드 5] 에이전트 레벨** — `model_config`로 org-level 기본 모델을 에이전트에 대해 override:

```agentscript
system:
    instructions: "You are an AI Agent."
    messages:
        welcome: Hi, I'm an AI service assistant. How can I help you?
        error: "Sorry, it looks like something has gone wrong."
model_config:
    model: "model://sfdc_ai__DefaultBedrockAnthropicClaude45Sonnet"
```

**[코드 6] 서브에이전트 레벨** — 서브에이전트 안에서 `model_config`로 org-level 또는 agent-level 모델을 해당 서브에이전트에 대해 override:

```agentscript
subagent ReservationManagement:
    description: "Handles requests to create new reservations for customers at their desired time slots."
    model_config:
        model: "model://sfdc_ai__DefaultBedrockAnthropicClaude45Sonnet"
```

일부 에이전트 템플릿(예: Agentforce Service agent)은 agent router의 subagent classification에 Salesforce 소유 **EinsteinHyperClassifier** 모델을 사용한다. 그 모델을 유지하거나, agent router에 다른 모델을 지정할 수 있다.

**[코드 7] agent router 레벨** — `start_agent agent_router`에 모델 지정:

```agentscript
start_agent agent_router:
    description: "Welcome the user and determine the appropriate subagent based on user input"
    model_config:
        model: "model://sfdc_ai__DefaultGPT41"
```

### 우선순위 (precedence)

같은 에이전트 안에 여러 모델을 지정할 수 있다. **subagent-specific model이 agent-specific model보다 우선**한다(takes precedence). 계층은 다음과 같다:

```
org default  <  agent-specific  <  subagent-specific
(낮은 우선순위)              (높은 우선순위)
```

예시 — org, agent, subagent가 서로 다른 모델을 지정한 경우. 다음을 가정한다(Suppose that):

- org에 대해 Salesforce default model을 선택했다.
- `MyTestAgent` 에이전트는 **Claude Haiku 4.5**를 지정한다.
- `HandleReservation` 서브에이전트는 **Gemini 3.1 Pro**를 지정한다.

이 예시에서 Agentforce는 다음과 같이 모델을 적용한다:

| 적용 대상 | 사용 모델 |
|---|---|
| `HandleReservation` 서브에이전트 | Gemini 3.1 Pro |
| `MyTestAgent`의 다른 모든 서브에이전트 | Claude Haiku 4.5 |
| 같은 org의 다른 에이전트 | Salesforce default model |

### EinsteinHyperClassifier

Salesforce가 개발한 **EinsteinHyperClassifier** 모델은 `agent_router` 서브에이전트의 subagent classification에 자주 사용된다.

EinsteinHyperClassifier를 subagent classification에 사용할 때의 **장점(advantages):**

- 다른 LLM 대비 훨씬 빠른(significantly faster) subagent classification.
- 분류 정확도(classification accuracy) 증가 — 특히 specialized classification constraints와 negative instructions에서.

**한계(limitations):**

- `before_reasoning` 또는 `after_reasoning`을 **사용할 수 없다(Can't).**
- 도구는 `@utils.transition`만 **사용할 수 있고(Can only)**, 그 외 다른 tools는 사용할 수 없다.

### model:// 식별자

`model_config`의 `model` 값에는 `model://` URI 형식의 식별자를 쓴다. 소스에 등장하는 식별자는 다음과 같다:

| 용도 / 예시 | model:// 식별자 |
|---|---|
| Claude 4.5 Sonnet (Bedrock/Anthropic, 기본 예시) | `model://sfdc_ai__DefaultBedrockAnthropicClaude45Sonnet` |
| GPT-4.1 (agent router 예시) | `model://sfdc_ai__DefaultGPT41` |

> 식별자의 `sfdc_ai__` 부분은 더블언더스코어(`__`)다.

산문에서 모델명으로만 언급되며 `model://` 식별자가 제시되지 않은 모델: **Claude Haiku 4.5**, **Gemini 3.1 Pro**, **Salesforce default model**.

> ⚠️ 지원되는 전체 모델 목록과 각 모델의 `model://` 식별자는 이 소스에 없다. 전체 목록은 외부 supported-models 문서(`models/supported-models.md`)에 위임되어 있다. 위 두 식별자 외의 `model://` URI를 추측하지 말 것.

---

## 관련 노트
- [[Agent Script 개요와 언어 특성]] — transition·reasoning·@utils 토큰 정의·언어 특성
- [[Agent Script 블록 8종 (System·Config·Subagent 등)]] — start_agent·subagent·reasoning 블록 구조
- [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]] — 액션의 결정적 호출(run·after_reasoning) 실행 시점·target URI·파라미터 타입
- [[Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법)]] — transition 단방향 전이·flow of control·@utils 4종 문법
- [[Agent Script 레퍼런스 — 변수·인스트럭션·표현식·연산자]] — 변수·인스트럭션(Logic/Prompt)·표현식·연산자 레퍼런스
- [[Agent Script 패턴 — 라우팅·전환·필수 워크플로우]] — 이 실행 흐름 위에서 subagent 전환·라우팅·필수 워크플로우를 구성하는 패턴
- [[Agent Script 메타데이터 배포 (DX·패키징)]] — 배포된 에이전트의 실행 컨텍스트·agent user 설정
- [[Agentforce 개요 — 제품·에이전트 유형·구성요소]] — 이 실행 흐름의 개념적 상위: Atlas Reasoning Engine plan→reason→act 루프·agent router의 제품 관점 오리엔테이션
- [[스킬 ↔ 위키 토픽 맵]] — Agentforce 실행 스킬 디스패처
