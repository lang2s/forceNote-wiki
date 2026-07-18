---
tags: [agentforce, ai, agent, atlas-reasoning-engine, prompt-builder, orientation, overview]
source: help.salesforce.com — Agentforce (ai.agent_setup_explore_types·ai.agent_builder_studio·ai.agent_builder_tour·ai.agent_plan_action_identify·ai.agent_setup_enable·ai.agent_reasoning_engine·ai.copilot_building_blocks·ai.agent_builder_reasoning_engine·ai.prompt_builder_about, 접속일 2026-07-14) [Tier 2]
created: 2026-07-14
aliases: [Agentforce, 에이전트포스, Agentforce 개요, Agentforce란, Atlas Reasoning Engine, 아틀라스 추론 엔진, agent types, 에이전트 유형, Agentforce Builder, Agentforce Studio, building blocks, Subagents, Actions, Prompt Builder vs Agent, 에이전트 구성요소, Einstein Copilot]
---

# Agentforce 개요 — 제품·에이전트 유형·구성요소

> Agentforce는 CRM 데이터에 그라운딩된 **자율(autonomous) 대화형 AI 에이전트** 플랫폼이다 — 이 노트는 제품 방향(무엇인가·유형·구성요소·Atlas 추론 엔진·언제 쓰나)을 설명하고, 에이전트 저작 언어인 Agent Script 문법은 하위 레퍼런스 노트로 위임한다.

---

## Agentforce란

Agentforce의 **에이전트(Agent)** 는 Salesforce가 정의하는 "신뢰할 수 있는 대화형 AI 어시스턴트(trusted conversational AI assistants)"다. dump의 Building Blocks 페이지 정의를 그대로 옮기면:

> "Agents are trusted conversational AI assistants. They increase productivity and reduce workloads by automating routine tasks and assisting with complex ones. They're **more autonomous than other conversational AI solutions**, so they can adapt to different situations, environments, and information."

핵심 차별점은 **자율성**이다. 에이전트는 사용자가 지정한 use case와 guardrail 안에서 스스로 행동 기회를 식별하고(independently identify opportunities for action), 다음 단계를 예측하며, human-in-the-loop 유무와 무관하게 태스크를 개시할 수 있다. 에이전트는 처음부터(from scratch) 만들거나 템플릿(template)에서 생성한다.

> [!note] "What is Agentforce" 마케팅 개요 페이지는 이 dump 범위에 없다. 위 정의는 help의 Building Blocks("The Building Blocks of Agents") 페이지에 실린 **Agent** 구성요소 정의를 근거로 서술한다.

---

## 명칭 전환 (April 2026) — topics → subagents

> [!warning] Beginning in April 2026, agent **topics** are now called **subagents**. There are no changes to functionality.
>
> 전환기 동안 공식 문서에도 신·구 용어가 혼재할 수 있다(원문: "you may see a mix of the new and previous terms"). 이 위키는 신용어 **subagent**로 통일한다. (기존 Agent Script 언어 노트의 콜아웃과 동일.)

**Einstein Copilot 계보(추정):** Building Blocks·Atlas 추론 엔진 등 개념 help 페이지의 문서 ID가 `ai.copilot_building_blocks` / `ai.copilot_atlas_reasoning`처럼 `copilot` 접두를 유지하고 있다. 이는 이 개념들이 **Einstein Copilot 시절에 도입되어 Agentforce 브랜드로 흡수/리브랜드**된 흐름을 시사한다. 다만 dump에는 "Einstein Copilot → Agentforce" 리브랜드를 서술하는 본문이 없으므로, 위 계보는 문서 ID에서 유추한 추정으로만 기재한다(단정 아님).

---

## 구성요소 (Building Blocks) — 6종

dump의 "The Building Blocks of Agents" 페이지가 정의하는 6개 구성요소 전수:

| # | 구성요소 | 정의 |
|---|---|---|
| 1 | **Agent** | 신뢰할 수 있는 자율 대화형 AI 어시스턴트. 템플릿 또는 scratch에서 생성. (위 "Agentforce란" 참조) |
| 2 | **Subagents & Actions** | 에이전트의 가장 중요한 자산. **Action** = 에이전트가 Salesforce에서 일을 처리하는 방법(정보 조회·태스크 수행). 표준 액션 + 커스텀 액션. **Subagent** = "해야 할 특정 일(job to be done)"별로 관련 액션을 묶은 카테고리. Subagent는 **actions**(작업 도구)와 **instructions**(의사결정 지침)를 담는다. 예: "Deal Management" subagent가 opportunity 조회·to-do 생성·통화 로깅 액션을 그룹핑. |
| 3 | **Data (grounding / RAG)** | 에이전트는 그라운딩된 데이터만큼만 유용하다. Salesforce Platform 위에 구축되어 CRM 데이터와 통합되며 접근 범위는 관리자가 통제. knowledge article·field·파일 업로드·웹 소스로 그라운딩(Agentforce Data Libraries·Search the Web 표준 액션). 비정형 소스는 **RAG(Retrieval Augmented Generation)** 로 고급 검색 구성. |
| 4 | **Connections & Channels** | **Channel** = 에이전트를 배포하는 메시징 플랫폼·앱·인터페이스(텍스트/음성, 직원용/고객용), 복잡·민감 대화의 에스컬레이션 방식도 결정. **Connection** = 채널 배포 시 생성·관리하는 것 — adaptive response format(이미지·버튼·링크·비디오 등 멀티미디어), Omni-Channel flow 라우팅 설정 포함. 에이전트를 한 번 만들어 여러 채널에 재사용. |
| 5 | **Reasoning Engine** | 에이전트가 추론·행동·응답 생성하는 방식을 오케스트레이션. subagent classification 또는 결정적 전환으로 대화 라우팅 → subagent instruction 해석해 프롬프트 구성 → LLM으로 추론. (아래 "Atlas Reasoning Engine" 참조) |
| 6 | **Large Language Model (LLM)** | 에이전트가 추론·소통·행동에 활용하는 LLM. 추론 엔진이 태스크 중 여러 시점에 LLM을 호출하며, 호출 횟수·크기는 태스크 복잡도와 사용된 subagent·action에 따라 달라진다. |

> Subagent/Action 설계법(top-down vs bottom-up 접근, semantic overlap 방지, 최소 subagent 원칙)은 help의 "Identify the Subagents and Actions"에 상세하다. 액션을 먼저 granular하게 나열(bottom-up)한 뒤 관련 액션끼리 subagent로 묶는 것이 권장 흐름이다.

---

## Atlas Reasoning Engine

**Atlas reasoning engine**은 **graph-based(그래프 기반) 추론 엔진**이다. 노드·변수·전환(transition)을 가진 flowchart처럼 동작하여 에이전트가 예측 가능한 경로를 따르게 한다. 순수 프롬프트 기반 엔진과 달리 Atlas는 에이전트의 **big-picture workflow(큰 그림 워크플로우)** 를 **conversational skills(대화 기술)** 로부터 분리한다.

- **Agent Script 사용:** Agentforce Builder의 에이전트 저작 언어인 Agent Script로 프로그래밍적 표현식과 자연어 지침을 결합한다.
- **Hybrid reasoning(하이브리드 추론):** 확률적(probabilistic) LLM 기반 추론 + 결정적(deterministic) 규칙 기반 실행을 **하나의 엔진**에서 결합. 엔터프라이즈가 요구하는 예측성·통제와 LLM의 유연성·창의성을 동시에 확보.

### 사용자 메시지의 여정 (plan → reason → act)

dump의 legacy builder 흐름(5단계) 기준. 신 Builder 흐름에서는 시작 subagent(§ Agent Router)와 프롬프트 빌드 단계가 명시적으로 추가되어 7단계로 확장되지만, 핵심 reason/act 루프는 동일하다.

1. **사용자 메시지 전송** — 대화형 인터페이스에서 질문/요청 입력. 백그라운드 에이전트는 다르게 동작: SDR 에이전트는 lead 배정·스케줄·engagement rule로 개시, Apex 클래스/flow에서 호출된 에이전트는 설정한 조건으로 트리거(구성 시 지정한 sample user message로 subagent·action 탐색).
2. **메시지를 subagent로 분류(classification)** — 최근 대화 이력(평균 마지막 6턴)과 사용자 최신 메시지를, 사용 가능한 모든 subagent의 이름·분류 설명과 비교해 최적 subagent 선택. filter가 걸린 subagent는 조건 충족 시에만 후보. 적절한 subagent를 못 찾으면 **Off-Topic** 시스템 subagent로 이동해 대화를 원래 범위로 되돌림.
3. **추론 시작 및 행동(reason / act loop)** — 선택된 subagent에서 다음 중 하나 결정: ① agent action 실행(Apex·flow·prompt template 호출, knowledge/웹 그라운딩 포함) ② 사용자에게 추가 정보 요청 ③ 명확화 질문 ④ 즉시 응답. 액션 실행 후 **reasoning loop**에서 결과를 검토해 또 다른 액션·질문·최종 응답을 결정. **이 과정은 최대 7 reasoning loop까지 반복**된다. subagent instruction이 의사결정에 크게 영향(예: "제품 질문 전 모델 번호를 항상 물어라").
4. **최종 응답 검증 (Agentforce Service 에이전트 전용)** — 응답 전송 전, 데이터 소스 그라운딩 여부·subagent scope/instruction 준수·hallucination/미검증 정보/prompt injection 위험 부재를 검사. 실패 시 새 응답 생성(스트리밍 중 실패하면 삭제 후 재생성). 검증 통과 응답을 못 만들면 도울 수 없다고 사용자에게 알림.
5. **사용자에게 응답 전송** — 응답 후 사용자의 후속 질문/주제 전환이 여정을 재시작하지만, 사용자에게는 자연스러운 turn-by-turn 대화로 느껴짐.

### Agent Router 와 시작 subagent

신 Builder 흐름에서 에이전트는 먼저 **시작 subagent(starting subagent)** 로 이동한다. Agent Script에서 이는 `subagent` 접두 대신 **`start_agent` 접두**를 쓰는 subagent다. 기본값은 **Agent Router** — 최근 대화 이력과 사용 가능한 subagent를 근거로 어느 subagent를 선택할지 안내한다. 시작 subagent는 instruction을 위→아래 순서로 결정적으로 해석하며, 이 단계에서는 아직 LLM 추론이 일어나지 않는다.

```
// 구조 예시 — 실제 동작 코드 아님 (Agent Script 접두 개념만 표기)
start_agent AgentRouter        // 시작 subagent: start_agent 접두
subagent OrderManagement       // 일반 subagent: subagent 접두
subagent Troubleshooting
```

> Agent Script 문법 상세(블록 종류·변수·표현식·연산자·전환·액션 체이닝)는 이 노트 범위 밖이다 → [[Agent Script 개요와 언어 특성]], [[Agent Script 블록 8종 (System·Config·Subagent 등)]], [[Agent Script 실행 흐름과 모델 설정]] 참조.

---

## 에이전트 유형 (카탈로그)

dump의 "Agent Types and Considerations" 표 전수. 활성 6종 + 은퇴 2종.

### 활성 유형

| 유형 | 하는 일 | 필요 Edition | 필요 권한 |
|---|---|---|---|
| **Employee Agent** | 부서 전반의 회사 지식 접근·태스크 수행·워크플로우 간소화로 직원 지원 | Enterprise·Performance·Unlimited·Developer + **Foundations 또는 Agentforce 1 Editions**. 일부 표준 액션은 추가 add-on 라이선스 필요. **Flex Credits 필요.** | 생성/관리: **Manage AI Agents**. 사용: "Manage Employee Agent Access" 참조 |
| **Lead Nurturing** (구 SDR) | lead에 개인화 콘텐츠로 지능적 engagement·FAQ 응답·미팅 예약 | Enterprise·Performance·Unlimited·Developer + Foundations 또는 Agentforce 1 Editions | **SDR Agent Permission Sets** 참조 |
| **Sales Coach** | 영업 피치/롤플레이에 개인화·실행가능·스테이지별 피드백 제공 | Enterprise·Performance·Unlimited·Developer + Foundations 또는 Agentforce 1 Editions | **Agentforce Sales Coach Permissions** 참조 |
| **Service Agent** | 일반 문의 지원·복잡 이슈 에스컬레이션 | Enterprise·Performance·Unlimited·Developer + Foundations 또는 Agentforce 1 Editions. 일부 표준 액션은 add-on 필요 | **Manage Agentforce Service Agents** permission set(내부에 **Manage AI Agents** 포함 → Builder 접근 가능). ⚠️ Manage AI Agents는 org 전체 에이전트 관리 권한이므로 org-wide 관리가 필요한 사용자에게만 할당 |
| **Service Assistant** | 케이스 요약·단계별 해결 가이드로 서비스 rep의 케이스 해결 가속 | Enterprise·Performance·Unlimited + Foundations **AND** Agentforce for Service add-on **OR** Agentforce 1 Service Edition | "Permissions and Licensing for Service Assistant" 참조 |
| **Setup with Agentforce** | 사용자 관리·문제 해결·org 커스터마이즈 등 Setup 태스크를 admin 대신 수행. **활성화 시 자동 생성**되며 Agentforce Builder에서 보이지 않고 커스터마이즈 불가 | Enterprise·Performance·Unlimited·Developer + Foundations 또는 Agentforce 1 Editions | "Grant Permissions to Use Setup with Agentforce" 참조 |

### 은퇴 유형 (Retired) — 신규 사용 금지

| 유형 | 은퇴 사유 (원문 기준) | 필요 권한 (참고) |
|---|---|---|
| **Agentforce (Default)** | **2025-06-17부터 신규 기능·개선 없음**, 신규 Salesforce 환경에서 미제공. **Agentforce Employee agent로 마이그레이션 권장** (사전 마이그레이션 미완 시 다운타임 가능) | Manage AI Agents **AND** Manage Agentforce Default Agent **OR** Customize Application |
| **Agent for Setup** | 더 이상 업데이트 안 됨. **2026-04부터 신규 org에서 활성화 불가.** 더 많은 관리 태스크를 돕고 자동 업데이트되는 **Setup with Agentforce 사용 권장** | Customize Application **OR** Agentforce Default Admin permission set **AND** View Setup and Configuration |

> [!note] **Manage AI Agents** 권한은 모든 에이전트의 관리·활성/비활성·subagent·action 커스터마이즈·활동 모니터링을 부여한다. org 전체 관리가 필요한 사용자에게만 할당한다.

---

## Agentforce Studio & Builder

### Agentforce Studio (앱)

**Agentforce Studio** 앱은 새 **Agentforce Builder**의 홈이자 에이전트 구축·테스트·모니터링의 중앙 허브다. 기본적으로 Agentforce 접근 권한이 있는 org의 **모든 사용자에게 App Launcher에 노출**된다. Studio 내 각 기능은 자체 권한을 요구한다.

- **접근 경로:** App Launcher → **Agentforce Studio** 선택 → **Agents** 탭 클릭. Agents 목록 뷰를 보고 Builder에 접근하려면 세 조건 모두 충족:
  - org에 **Einstein** 활성화
  - org에 **Agentforce** 활성화
  - 사용자에게 **Manage AI Agents** 권한
- **Setup 밖에 위치:** 새 Builder는 Setup 바깥에 있어 **admin-level 권한 없이도** Manage AI Agents만 할당하면 비즈니스 전반의 사용자가 에이전트를 만들 수 있다.

### 새 Agentforce Builder

Builder는 비즈니스 규칙 안에서 동작하는 **예측 가능하고 컨텍스트를 인지하는(predictable, context-aware)** 에이전트를 만들고 커스터마이즈·테스트하는 곳이다. 제공 기능:

- **Guided setup** — 에이전트 생성 가이드
- **Building blocks 커스터마이즈** — subagent·action·지원 언어·채널
- **Preview / Test / Troubleshoot** 도구
- 여러 채널로 확장 배포

새 Builder의 추가 요소: **Built-in assistance**(UI에 임베드된 Agentforce가 요청을 subagent·action으로 변환), **Agent Script**(자연어 지침 + 프로그래밍 로직 결합 — if-else·변수 조작·subagent/action 체이닝), **강력한 프리뷰/테스트**(리뉴얼된 debugging panel로 상호작용의 매 순간 추적), **Flat navigation**(file explorer + text editor).

**Builder Tour 요소:** Explorer(1) · Canvas(2) · Preview(3) · Canvas and Script(4) · Agentforce Assistance(5) · Save(6) · Commit Version(7, 활성화 가능한 불변 버전 컴파일) · Settings(8) · Console(9, 구문 오류·경고 처리).

**Explorer 섹션:** Search · Settings · **Subagents**(각 subagent는 구성·action을 담은 폴더) · **Actions**(해당 subagent 하위 나열) · **Variables**(에이전트 동작 제어 값) · **Connections**(연결·채널) · **Data**(에이전트가 참조하는 구조화 데이터 소스).

> Agent Script 저작·프리뷰의 코드 뷰(Canvas ↔ Script 전환) 상세는 언어 노트에 위임한다. Canvas(자연어)와 Script(코드) 뷰는 구성이 상호 일관된다.

---

## 활성화 전제조건

dump의 "Enable Agentforce" 절차:

1. 아직 안 했다면 **Einstein Generative AI** 부터 켠다.
2. **Setup → Quick Find에 `Agent` 입력 → Agentforce Agents** 선택. (Setup에 Agents가 안 보이면 Einstein Generative AI 활성화 여부 확인.)
3. **Agentforce 토글을 켠다.**
4. 페이지를 새로고침하면 **New Agent** 버튼이 나타난다 → 에이전트 생성 **guided setup** 실행. (버튼이 안 보이면 프로필에 필요 권한 할당 여부 확인.)

**필요 권한:** Manage AI Agents **AND** 에이전트 유형별 필요 권한.

---

## Prompt Builder vs Agent

Agentforce 도입 시 자주 혼동되는 두 생성형 AI 도구를 대비한다.

| | **Prompt Builder** (prompt template) | **Agent** (Agentforce) |
|---|---|---|
| 정체 | 프롬프트 **템플릿 저작 도구** — CRM 데이터(merge field·flow·related list·Apex)를 프롬프트에 통합 | **자율 다단계 추론** 대화형 AI |
| 산출 | 단일 생성 결과(이메일 초안·필드 값·뉴스레터 등) | subagent·action 오케스트레이션으로 태스크 수행 |
| 템플릿 유형 | **Sales Email**(contact/lead 개인화 이메일), **Field Generation**(Lightning 레코드 페이지 필드에 LLM 요약/설명 채움), **Flex**(다양한 오브젝트 타입의 가변 입력) | 유형 카탈로그는 위 "에이전트 유형" 참조 |
| 호출 방식 | invocable action(플랫폼 어디서나), **Connect REST API**, **Connect in Apex** | 채널 배포·Apex/flow 트리거·대화형 인터페이스 |
| 권한 | **Prompt Template Manager** permission set | Manage AI Agents (+ 유형별) |

> 프롬프트 템플릿을 **에이전트 액션으로 실행**하는 구체적 방법(genAiPromptTemplate·Apex 그라운딩)은 [[Agentforce Prompt Template 액션 — genAiPromptTemplate·Apex 그라운딩]] 참조.

---

## 언제 무엇을 쓰나 (결정 가이드)

> [!warning] 아래 표는 dump의 Prompt Builder / Agent 정의에서 도출한 **synthesis(종합 판단)** 다. 특히 **Flow 비교 열은 dump 밖의 위키 일반 지식**이므로 판단 가이드로만 제시하며 단정하지 않는다.

```
// 구조 예시 — 판단 가이드 (dump 정의 기반 종합 + Flow는 일반 지식). 공식 결정표 아님
```

| 필요한 것 | 권장 | 근거 |
|---|---|---|
| **자율·다단계·대화형 추론** — 사용자와 turn을 주고받으며 상황에 따라 여러 action을 스스로 선택 | **에이전트(Agent)** | dump: 에이전트는 "more autonomous", plan/reason/act 루프로 다단계 처리 |
| **단일 생성 태스크** — 정해진 입력으로 텍스트/필드 값 한 번 생성 | **프롬프트 템플릿(Prompt Builder)** | dump: Sales Email·Field Generation·Flex 템플릿, invocable action 호출 |
| **결정적(deterministic) 자동화** — 조건이 명확하고 대화·추론이 불필요한 규칙 기반 처리 | **Flow** (참고 — dump 밖, 일반 지식) | ⚠️ dump 미포함. Flow는 결정적 자동화 도구라는 위키 일반 지식에 근거한 **비단정** 제안 |

Atlas가 hybrid reasoning으로 "결정적 규칙 실행 + 확률적 LLM 추론"을 한 엔진에 결합한다는 점(위 § Atlas)을 감안하면, 세 도구는 배타적이라기보다 **에이전트가 프롬프트 템플릿을 액션으로, 결정적 로직을 Agent Script로 품는** 계층 관계로도 이해할 수 있다(이 문장 역시 종합 판단).

---

## 관련 노트
- [[Agent Script 개요와 언어 특성]]
- [[Agent Script 블록 8종 (System·Config·Subagent 등)]]
- [[Agent Script 실행 흐름과 모델 설정]]
- [[Agentforce Prompt Template 액션 — genAiPromptTemplate·Apex 그라운딩]]
- [[스킬 ↔ 위키 토픽 맵]]
- [[Einstein 예측형 AI 개요 — 예측 vs 생성형·도구 지도]] — 예측형(비생성형) AI 계열(생성형과 경계 대비)
