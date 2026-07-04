---
tags: [Agentforce, AgentScript, actions, 액션, reference]
source: AgentScriptDocs (Salesforce Agent Script Developer Guide, 2026-06-17판) — agent-script/reference/ascript-ref-actions.md
created: 2026-06-30
aliases: [AgentScript actions, 액션, action target, apex://, flow://, prompt://, parameter types, 파라미터 타입, Action Properties, inputs, outputs, filter_from_agent, "AgentScript에서 액션을 어떻게 정의하나", "action target URI는 뭐가 있나", "apex flow prompt 호출"]
---

# Agent Script 레퍼런스 — 액션 (apex·flow·prompt)

> AgentScript 액션 정의 — target URI(apex·flow·prompt), 파라미터 타입 12종, Action/Output 속성, 결정적 호출과 툴 노출.

---

## 개요

액션(action)은 subagent가 수행할 수 있는 task를 정의한다. Flow 호출, prompt template 호출, Apex 클래스 호출 등이 이에 해당한다. 액션의 출력은 변수에 저장할 수 있고, reasoning engine에 노출할 수 있으며, LLM이 그 출력을 고객에게 표시할지 여부도 선택할 수 있다.

하나의 subagent는 여러 액션을 가질 수 있다. 액션은 라이브러리에서 import 하거나 subagent에 직접 정의한다. **subagent끼리는 액션을 공유하지 않는다** — 각 액션은 그 subagent에만 고유하다. 액션을 subagent로 import 하면, 그 subagent는 import 된 액션의 **자기 사본(copy)** 을 갖는다.

액션은 subagent의 `actions` 블록에 정의한다.

> 블록 구조 전반은 [[Agent Script 블록 8종 (System·Config·Subagent 등)]] 참조. `@actions`/`@variables`/`@outputs` 등 토큰 표기는 [[Agent Script 개요와 언어 특성]] 참조.

---

## 액션 정의 — Action Properties

액션 정의는 다음 속성들을 포함한다.

| Property | 설명 |
|---|---|
| action name | Required string. 액션의 이름. |
| description | Optional string. 액션의 동작과 목적에 대한 설명. 여러 줄 설명에는 `\|` 사용. LLM은 이 설명을 보고 언제 액션을 호출할지 판단한다. |
| inputs | Optional object. 액션의 입력 파라미터를 정의(있는 경우). |
| include_in_progress_indicator | Optional boolean (`True`/`False`). 액션 실행 시 agent가 progress indicator를 표시할지 여부. |
| target | Required string. 실행체(apex, flow, prompt)에 대한 참조. |
| label | Optional string. 고객에게 표시할 액션 이름. 지정하지 않으면 자동 생성. 기본적으로 Agentforce는 액션 이름에서 라벨을 만든다 — `my_action`은 "My Action"이 된다. |
| outputs | Optional object. 액션의 출력 파라미터를 정의(있는 경우). |
| require_user_confirmation | Optional boolean. agent가 액션을 실행하기 전에 고객이 확인해야 하는지 여부. |

### action name 명명 규칙

액션의 식별자이며, 이 이름으로 액션을 실행한다. 액션 이름은 Salesforce developer name 표준을 따라야 한다.

- 문자로 시작하고, underscore로 시작하지 않는다.
- 영숫자(alphanumeric)와 underscore만 포함한다.
- underscore로 끝날 수 없다.
- 연속된 underscore(`__`)를 포함할 수 없다.
- 최대 길이 80자.
- `snake_case` 권장.

### inputs

액션의 입력 파라미터, 그 [타입](#파라미터-타입-입력출력-공통), 그리고 입력이 필수인지(`is_required`)를 정의한다.

```agentscript
inputs:
    email: string
        label: "Email Address"
        description: "Customer's email address"
        is_required: True
```

---

## 파라미터 타입 (입력·출력 공통)

입력·출력 파라미터에 다음 타입을 사용할 수 있다 (12종 전수).

- `string` - text values
- `number` - numeric values (floating point)
- `integer` - integer values
- `long` - long integer values
- `boolean` - True/False values
- `object` - complex objects
- `date` - date values (YYYY-MM-DD)
- `datetime` - dateTime values
- `time` - time values
- `currency` - currency values
- `id` - Salesforce ID values
- `list[<type>]` - 같은 타입 값들의 리스트. 리스트 안에는 지원되는 어떤 타입이든 사용 가능. 예: `list[string]` 또는 `list[number]`.

> 입력(`inputs`)과 출력(`outputs`) 파라미터 모두 위 동일 타입 집합을 사용한다.

---

## target — URI scheme (핵심)

target은 실행체(executable)에 대한 참조다. 형식은 `{TARGET_TYPE}://{DEVELOPER_NAME}` 를 사용한다. 액션은 다음 target을 가질 수 있다.

- `apex` (Apex)
- `flow` (Flow)
- `prompt` (Prompt Template)

예시:

```agentscript
flow://AssignSalesRep
```

```agentscript
prompt://check_bookings
```

> `apex://` target은 목록에 포함되어 있으나, 원문(reference)에 `apex://` 본문 코드 예제는 **없다**(target 목록에만 존재). Flow·Prompt target만 코드 예제로 제시됨.

- `apex://` 호출 대상 Apex는 [[Apex MOC]] 참조.
- `flow://` 호출 대상 Flow는 [[Flow MOC]] 참조.
- `model://` URI scheme(예: `model://sfdc_ai__DefaultEinsteinHyperClassifier`)도 코드 예제에 등장하나 model 설정 소관 → [[Agent Script 실행 흐름과 모델 설정]] 참조.

---

## inputs와 outputs

`inputs`는 위 [파라미터 타입](#파라미터-타입-입력출력-공통) 절을 따른다(파라미터·타입·`is_required`).

`outputs`는 액션의 출력 파라미터와 그 속성들을 정의한다. **기본적으로 agent는 액션의 출력 정보를 세션 전체 동안 기억한다.** agent는 그 정보를 바탕으로 선택을 내리고, 고객 질문에 답하는 데 그 정보를 사용할 수 있다. 예를 들어 `get_product_care` 액션이 제품 관리 방법 정보를 반환하면, agent는 그 정보를 세션 내내 기억하고 관련 질문에 답하는 데 사용한다.

출력 파라미터도 위 [타입](#파라미터-타입-입력출력-공통)을 가질 수 있다.

> [!important]
> agent로부터 출력 정보를 숨기려면, 출력 파라미터의 `filter_from_agent` 속성을 `True`로 설정한다.

출력 파라미터가 지원하는 속성:

| Property | 설명 |
|---|---|
| `description` | Optional. String. 출력 파라미터에 대한 설명. 기본적으로 Agentforce가 파라미터 이름에서 생성. 예: 파라미터 `error_code`는 `Error Code`가 된다. |
| `developer_name` | Required. String. 파라미터의 developer name을 override 할 수 있는 값. |
| `label` | Optional. String. 출력 파라미터 값에 대한 사람이 읽을 수 있는 라벨. 기본적으로 Agentforce가 출력 파라미터 이름에서 자동 생성. 예: `error_code`는 `Error Code`가 된다. |
| `complex_data_type_name` | 파라미터가 complex data type이면 Required. String. target이 반환하는 타입을 가리킨다. 예: 어떤 액션이 flow target과 `customer_info` 출력 파라미터를 갖고, flow가 `lightning__recordInfoType` 타입 정보를 반환하면, 액션의 `customer_info` 파라미터는 타입 `object`와 `complex_data_type_name: lightning__recordInfoType` 속성을 가져야 한다. **Note:** 이 complex 타입은 custom Lightning type일 수도 있다. |
| `filter_from_agent` | Optional. Boolean. `True`면 출력이 agent의 context에서 제외된다. `False`면 출력이 agent의 context에 포함된다. 기본값은 `False`. |

```agentscript
outputs:
    customer_found: boolean
        label: "Customer Found"
        filter_from_agent: True
```

---

## 액션 사용하기 (Using Actions)

subagent의 `reasoning.actions` 블록(또는 `subagent.actions`)에 액션을 정의한 뒤에는, subagent의 reasoning 로직에서 액션을 호출하거나 LLM에게 tool로 노출할 수 있다.

### 결정적 호출 — run @actions.\<name\>

subagent가 실행될 때마다 액션이 반드시 실행되게 하려면, subagent의 `reasoning` 블록에서 `run @actions.<action_name>`을 사용한다. subagent의 `after_reasoning` 블록에서 호출하면, subagent가 종료된 후 매 실행마다 액션이 실행된다.

다음 예제에서 한 액션이 영업시간을 확인한다. 이 액션은 입력이 필요 없고, 출력을 변수에 저장한다. 이 변수는 다른 subagent나, 다음 번 실행 시 이 subagent가 접근할 수 있다.

```agentscript
reasoning:
    instructions: ->
        run @actions.check_business_hours
           set @variables.is_business_hours=@outputs.is_business_hours
           set @variables.next_open_time=@outputs.next_open_time
```

> `run`·`after_reasoning`의 실행 시점 자세한 흐름은 [[Agent Script 실행 흐름과 모델 설정]] 참조.

### 툴로 노출 — reasoning.actions

액션을 `reasoning.actions` 블록에 tool로 노출하면, LLM이 그 tool을 실행할지 여부를 스스로 선택할 수 있다. tool로 노출할 때, reasoning 블록에 지정한 prompt에서 그 tool을 명시적으로 참조할지 선택할 수 있다.

```agentscript
reasoning:
    actions:
        load_order_details: @actions.Get_Order_Details
            with order_number=@variables.order_number
            with customer_id=@variables.customer_id
```

일반적으로 LLM은 언제 tool을 쓸지 인식하지만, prompt에서 `{!@actions.<action_name>}`를 사용해 더 많은 context를 제공할 수도 있다.

```agentscript
reasoning:
    instructions: ->
        | If not within business hours, create a support case by using {!@actions.create_case}.
           Share the Case Number and when to expect follow-up ({!@variables.next_open_time}).
```

LLM에게 더 명시적인 지시를 주려면, prompt에서 tool을 참조한다. 다음 예제는 `send_verification_code_tool` tool을 명시적으로 참조한다.

```agentscript
            | Ask the user for the verification code they received and
              verify it using {!@actions.send_verification_code_tool}.
```

> tool(reasoning actions)의 상세 문법(`wrap`·`with`·`set`·`available when`)은 [[Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법)]] 참조.

### 액션 체이닝

정의된 액션을 reasoning actions 블록에서 LLM에게 노출할 때, 그 직후에 즉시 실행할 또 다른 액션을 지정할 수 있다. 다음 예제에서 `ScheduleOrder` 액션은 `GetOrderByNumber` 액션 직후 즉시 실행된다.

```agentscript

   reasoning:
      instructions: ->
         | You are a helpful agent.

      actions:
            # get the order's details
            GetOrderByOrderNumber: @actions.GetOrderByOrderNumber
                with contactRecord = ...
                with orderNumber = ...
                set @variables.orderDetails = @outputs.orderDetails

                # automatically run the ScheduleOrder action after you get the order's details
                run @actions.ScheduleOrder
                    with orderDetails = @variables.orderDetails
                    set @variables.DeliveryDate = @outputs.deliveryDate

```

### 종합 예제 — 정의 + 결정적 호출 + 툴 노출

다음 예제는 단일 액션 `send_verification_code_action`을 정의한다. reasoning instructions의 logic section에서 이 액션을 명시적으로 호출한다. 동시에 이 액션을 tool(`send_verification_code_tool`)로 LLM에게 노출하여, 고객이 처음에 인증 코드를 받지 못한 경우 LLM이 액션 호출을 선택할 수 있게 한다.

```agentscript
subagent my_topic:

    # Agentforce actions go in the subagent actions block
    actions:
        send_verification_code_action:
            description: "Send a verification code to the member and verify confirmation."
            inputs:
                email: string
                member_number: string
            outputs:
                verification_code: string
                member_name: string
            target: "flow://Get_Verification_Code"

    reasoning:

        # LLM tools (aka reasoning actions) go in the reasoning actions block
        # which can include pointers to Agentforce actions. These tools are sent to the LLM to be used
        # at the LLM's discretion.
        actions:
            send_verification_code_tool: @actions.send_verification_code_action
                with email=@variables.member_email
                with member_number=@variables.member_number
                set @variables.verification_code=@outputs.verification_code

        instructions: ->
            # We explicitly call a subagent action from
            # the logic section of the reasoning instructions
            # In this case, the customer is sent a verification code
            # each time the subagent is run, as the agent is parsing the subagent.
            if @variables.member_email != "":
                run @actions.send_verification_code_action
                    with email=@variables.member_email
                    with member_number = @variables.member_number
                    set @variables.verification_code=@outputs.verification_code
                    set @variables.member_name=@outputs.member_name

            # In this case, we call our tool (a reasoning action) from
            # the prompt section of the reasoning instructions.
            # Calling the tool from the prompt isn't required, because
            # the LLM can usually figure out which tool to use.
            | Ask the user for the verification code they received and
              verify it using {!@actions.send_verification_code_tool}.

```

즉, 액션은 `subagent.actions`에 지정해 **결정적으로** 호출할 수 있고, `subagent.reasoning.actions`에 지정해 LLM이 context에 따라 선택해 쓸 수 있는 **tool로 노출**할 수도 있다.

> [!note]
> 위 Actions and Tools 예제에서 액션은 `send_verification_code_action`으로 정의되고 `send_verification_code_tool`이라는 tool로 노출된다. UI에서 액션을 만들고 tool로 노출하면, 액션과 tool은 **같은 이름**을 갖는다.

---

## Subagent actions vs Reasoning actions (구분표)

Agent Script에는 두 개의 `actions` 블록이 있다. 혼동을 피하기 위해 정리한다.

| 블록 | 위치 | 누가 호출 | 호출 시점 |
|---|---|---|---|
| Subagent actions | `subagent.actions` | 로직 기반 reasoning instructions에서 개발자가 결정적으로(`run @actions.<name>`) / `after_reasoning` 블록 | subagent 파싱 시(매 실행) / `after_reasoning`은 subagent 종료 후 |
| Reasoning actions (= Tools) | `subagent.reasoning.actions` | LLM이 주관적으로 선택, prompt에서 `{!@actions.<name>}` 참조 가능 | LLM이 resolved prompt 받을 때(파싱 시 아님) |

> tool(reasoning.actions)의 상세 문법과 `@utils` 함수는 [[Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법)]]에서 다룬다.

---

## 관련 노트
- [[Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법)]]
- [[Agent Script 개요와 언어 특성]]
- [[Agent Script 블록 8종 (System·Config·Subagent 등)]]
- [[Agent Script 실행 흐름과 모델 설정]]
- [[Agent Script 레퍼런스 — 변수·인스트럭션·표현식·연산자]] — 변수·인스트럭션(Logic/Prompt)·표현식·연산자 레퍼런스
- [[Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링]] — 액션 정의를 이어 붙이는 액션 체이닝·데이터 페치·필터링 실전 패턴
- [[Agentforce Prompt Template 액션 — genAiPromptTemplate·Apex 그라운딩]] — `generatePromptResponse://` 타깃 액션 실전(prompt 타깃 URI·`Input:` 바인딩·`promptResponse` 출력)
- [[Agentforce 커스텀 Lightning Type — 에이전트 액션 입출력 UI]] — 액션 입출력(`complex_data_type_name`·`is_user_input`·`is_displayable`)을 커스텀 LWC UI로 렌더
- [[Apex MOC]]
- [[Flow MOC]]
- [[스킬 ↔ 위키 토픽 맵]]
