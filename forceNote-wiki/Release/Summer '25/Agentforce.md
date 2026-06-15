---
tags: [release, summer_25, agentforce, einstein, ai]
api_version: v64.0
release_date: 2025-06
created: 2026-06-15
source: salesforce_release_notes_5-17-2026 (3).pdf (Salesforce Summer '25 Release Notes, Tier 2)
aliases: [Summer '25 Agentforce, 서머25 에이전트포스, Agentforce 3, Employee Agent, Agent API, Agent Surfaces GA, Service Agent Email GA, Prompt Builder, Einstein Trust Layer, Claude Sonnet 4, GPT 5, Gemini 2.5]
---

# Summer '25 — Agentforce / Einstein

> Agentforce 3 출시(하이브리드 인력 관리·확장 플랫폼), Agent API의 Apex/Flow 호출, Employee Agent 일반화, Agent Surfaces·Service Agent Email GA, 그리고 Claude Sonnet 4·GPT 5·Gemini 2.5·Amazon Nova 등 신규 모델 대거 추가.

---

## 개요

Summer '25의 Agentforce & Einstein 변경은 월 단위로 릴리즈되며(May~September '25 릴리즈 노트에 분산), May 월간 릴리즈에 포함된 기능이 Summer '25 롤아웃 시점에 일반 제공된다. PDF 원문은 기능을 두 묶음으로 구분한다.

- **Agentforce & Einstein Features** — 각 Salesforce 클라우드(Sales/Service/Field Service/Industries 등)에 임베드되는 기능. 본 노트는 플랫폼·개발자 관점만 다루며, 클라우드별 산업 에이전트 템플릿은 [[Summer '25/Clouds]] 으로 분리한다.
- **Agentforce & Einstein Platform** — 생성형/예측형 AI의 기능·보안·성능 개선. 본 노트의 주 대상.

> 상위 허브: [[Summer '25]] / 개발자 spoke: [[Summer '25/Development]]

이 노트는 다음을 다룬다: **GA 항목 전수**, **Agentforce 3 플랫폼**, **Agentforce 기능(관측성·테스트·라우팅·모델 공급자·검증 액션)**, **Prompt Builder**, **Einstein Trust Layer**, **지원 모델(Summer '25 신규)**.

---

## GA (일반 제공)

이번 릴리즈에서 일반 제공(Generally Available)으로 전환된 항목.

### Enhance Customer Experiences with Agent Surfaces (GA)

Surface는 AI 에이전트에 **채널별 컨텍스트와 리치 콘텐츠 포맷팅**을 제공해, 여러 채널·인터페이스·앱에서 개인화되고 일관된 경험을 전달한다. 에이전트가 추가된 경험(experience)에 자동으로 적응한다.

- **Messaging surface** (이전 명칭 **Digital Engagement surface**) 는 **두 개의 adaptive response format**을 포함하며, enhanced Messaging 채널에 연결된 **Agentforce Service agent**에 사용할 수 있다.
- 응답 포맷: **Rich Link Response**, **Rich Choice Response**. 사용하려면 필요한 정보를 반환하는 커스텀 에이전트 액션을 만들어야 한다. 포맷된 응답을 만드는 데 에이전트가 1초 정도 더 걸릴 수 있다.
- **Where:** Lightning Experience — Enterprise/Performance/Unlimited/Developer editions (추가 비용). 필요한 add-on 라이선스는 에이전트 유형별로 다름.
- **When:** 2025년 6월 16일 주(week of June 16, 2025).

### Respond to Customer Emails Autonomously with Agentforce Service Agent (GA)

Agentforce Service Agent가 이제 **고객 이메일에 자율적으로 응답**한다. 예: 패키지 도착 문의 시 예상 배송일·추적 번호 제공. 이메일 응답은 **Agentforce Data Libraries와 topic instructions에 grounding**되어 정확성과 일관성을 보장한다.

- **Where:** Lightning Experience — **Unlimited, Developer editions** (산문 그대로; Enterprise/Performance 미포함).

### Control Session Timeout for Bot Conversations (GA)

enhanced Messaging 채널에서 봇이 메시징 세션을 종료하기 전 고객 응답을 기다리는 **분(minute) 단위 시간**을 지정할 수 있다.

- **Where:** Lightning Experience·Salesforce Classic — Enterprise/Performance/Unlimited/Developer editions. Einstein Bots 설정은 Lightning Experience에서만.
- **When:** 2025년 6월.
- **How:** 켜려면 Salesforce Customer Support에 문의.

### Chat with Einstein Bots in More Languages (부분 GA)

> Pattern B 검증 — PDF는 언어를 GA 그룹과 beta 그룹으로 명확히 분리한다(line 2608). 두 그룹을 섞지 않도록 셀 단위로 분리해 옮김.

- **GA로 추가된 언어 (5개):** Croatian, Greek, Hindi, Polish, Vietnamese.
- **Beta로 추가된 언어 (7개):** Finnish, Latvian, Lithuanian, Norwegian, Tagalog, Thai, Turkish.
- **Where:** Lightning Experience·Salesforce Classic — Enterprise/Performance/Unlimited/Developer editions.
- **When:** 2025년 6월 16일 주.

> 관련 변경 — **Article Answers**: Summer '25 이후 생성된 Einstein bot에서는 end of service(사용 불가), Article Answers 지원·업데이트는 Spring '25부로 종료. 기존 봇은 Winter '26까지 사용 가능하나 그 전에 **Generative Knowledge Answers**로 전환 권장.

---

## Agentforce 3 플랫폼

### Introducing Agentforce 3: The First AI Agent Platform Built to Manage and Scale a Hybrid Workforce

Agentforce 3은 엔터프라이즈 규모에서 하이브리드 인력을 빌드·관리·최적화하는 데 필요한 power·visibility·flexibility를 제공한다. 더 완전한 에이전트 observability, governance, continuous refinement를 지향하며 reasoning engine·trust 개선이 포함된다.

- **When:** Agentforce 3 기능은 2025년 6월 23일자로 제공.
- **Where:** Lightning Experience — Enterprise/Performance/Unlimited/Developer editions. 필요한 add-on 라이선스는 에이전트 유형별로 다름.

PDF가 명시한 Agentforce 3의 주요 변화(원문 bullet 전수):

1. 산업 use case에 특화된 일반 제공 agent template·topic·action 다수(보험 견적, 로열티 프로모션, 인벤토리 관리 등).
2. 단순화된 가격·신규 SKU로 빠르게 시작하고 대담하게 확장.
3. **response streaming**과 latency 개선으로 더 빠른 응답 — 에이전트가 아직 "생각 중"이어도 사용자가 즉시 읽기 시작 가능.
4. **inline citations**로 신뢰 가능한 응답 + web-grounded "Answer Questions with Knowledge" 답변.
5. 확장된 언어 지원으로 더 글로벌한 인력·고객 대응.
6. **Anypoint Connector for MCP**로 MCP를 지원하는 AI 클라이언트가 에이전트를 API·커넥터·앱에 연결.
7. **Agentforce in Government Cloud**로 정부 운영·case 관리·시민 참여 가속.

### Call the Agent API from an Apex Class or Flow

새로운 표준 invocable action 4종으로 Agentforce Service agent / Employee agent / Agentforce (Default) 를 **Apex 클래스 또는 Flow에서 호출**한다. 이 액션들은 custom agent invocable action(이 단계를 자동 처리)보다 세션 중 에이전트 동작에 대해 더 granular한 제어를 제공한다.

- **Start Session**
- **Send Message**
- **End Session** — 특정 조건 충족 시 세션이 확실히 종료되도록 사용.
- **Submit Feedback** — 대화에 대한 사용자 피드백을 수집해 Data Cloud에 저장.

> [!important] 코드 fabrication 금지
> PDF는 **위 4개 action 이름만** 산문에 명시하며, **메서드 시그니처·파라미터·반환 타입·예제 코드를 일절 제공하지 않는다.** 아래 블록은 호출 흐름을 보여주기 위해 작성자가 만든 **의사(pseudo) 예시**일 뿐, 실제 API 형태가 아니다. 정확한 시그니처는 아래 "See Also"의 Agent API Developer Guide를 참조하라.

```text
// 구조 예시 — 실제 동작 코드 아님 (PDF는 액션 이름만 제공, 시그니처/예제 없음)
// Apex/Flow에서 Agent API invocable action을 호출하는 개념 흐름:
//   1. Start Session   → 에이전트 세션 시작
//   2. Send Message    → 사용자 메시지 전달, 에이전트 응답 수신
//   3. (반복) Send Message
//   4. Submit Feedback → 대화 피드백을 Data Cloud에 저장
//   5. End Session     → 조건 충족 시 세션 종료
```

- **Where:** Lightning Experience — Enterprise/Performance/Unlimited/Developer editions. add-on은 에이전트 유형별.
- **When:** 2025년 6월 중순.
- **See Also (PDF 명시):** Salesforce Help — Call an Agent from a Flow or Apex Class / Agent API Flow Core Actions, Agent API Developer Guide — Chat with Agents Using Agent API.

### Automate Employee Workflows with Agentforce Employee Agent

Agentforce Employee agent(AEA) 로 사원 상호작용·워크플로우를 자동화해 생산성·UX·데이터 보안을 개선한다. Agent Creator가 자연어 인터페이스로 설정을 안내하고 특정 사원 워크플로우 템플릿을 제공한다. 표준 topic·action에 대해 role-based 응답을 제공하며 **Flow·Apex class 구성**으로 자동화를 확장한다.

- **Where:** Lightning Experience·Slack·Mobile — Enterprise/Performance/Unlimited/Developer editions, Agentforce Employee agent add-on. AEA는 Salesforce Foundations Entitlements 모델 하에서 **Flex Credits** 사용.
- **When:** 2025년 5월 13일.

### Agentforce Employee Agents Now Available in Salesforce Developer Edition

이제 **Salesforce Developer Edition**에서 AEA를 빌드·테스트·런칭할 수 있다. 무료 Developer Edition 환경에서 guided creation 도구·통합 테스트·access control·sample data로 task-specific 에이전트를 빠르게 다듬는다. production에서 가능한 모든 구성 옵션(topic·action·permission·channel)이 Developer Edition에서도 지원된다.

- **When:** 2025년 6월.

### Migrate from Agentforce (Default) to Agentforce Employee Agent

**Agentforce (Default) 는 이제 end of sale**(판매 종료)이다. 고객은 AEA로 마이그레이션해야 한다.

- Agentforce (Default) 는 **신규 기능·개선이 추가되지 않으며**, 기존 에이전트는 계속 작동하지만 **새 Salesforce 환경에서는 더 이상 제공되지 않는다.**
- AEA는 guided Agent Creator로 더 쉽게 생성, enhanced control로 사용자 액세스 관리 단순화.
- AEA는 Helpdesk·Deal Support 같은 task-specific use case를 지원. 각 에이전트가 명확한 목적에 집중 → topic overlap 감소, 응답 명료도 향상.
- AEA는 Agentforce (Default) 가 지원하는 동일 사원 채널에 연결되며 **Slack까지 확장 지원**.
- Agentforce (Default) 가 **단 하나의 에이전트만** 지원하는 것과 달리, AEA는 **템플릿으로 여러 에이전트** 생성을 지원.
- **When:** Agentforce (Default) 는 2025년 6월 17일자로 end of sale.

> 마이그레이션 보조 도구(August '25): Agent Access tab, Simple Setup Flow(동일 topic·action·variable·setting으로 새 AEA 생성), Agent Readiness Checklist. 다중 사원 에이전트 환경에서 "Use the Right Agent for the Job" — 사용자가 설치된 에이전트 간 전환 가능, 답할 수 없으면 다른 에이전트로 전환을 안내.

### New Agentforce Editions with Unmetered User-Based AI

새 에디션 + add-on 라이선스로, **인간 사용자가 AI 기능과 상호작용할 때** 생성형 AI 크레딧을 소비하지 않는 **unmetered usage**를 사용할 수 있다(예: 에이전트에 질문, 특정 account 정보 조회).

- **Where:** **Agentforce 1 Editions** 또는 Enterprise/Performance/Unlimited Edition + 다음 add-on 라이선스. PDF 명시 add-on 16종 전수:
  - Agentforce for Automotive
  - Agentforce for Communications
  - Agentforce for Consumer Goods
  - Agentforce for Education
  - Agentforce for Energy and Utilities
  - Agentforce for Field Service
  - Agentforce for Financial Services
  - Agentforce for Health
  - Agentforce for Life Sciences
  - Agentforce for Manufacturing
  - Agentforce for Media
  - Agentforce for Net Zero
  - Agentforce for Nonprofits
  - Agentforce for Public Sector
  - Agentforce for Sales
  - Agentforce for Service
- **When:** 2025년 7월 중순.
- **How:** 각 사용자에게 permission set으로 **Unmetered User-Based AI** 권한 할당.

### Simplify Agentforce Credit Consumption with Flex Credits

**Flex Credits**는 Agentforce의 새롭고 유연한 결제 단위다. 에이전트가 **액션을 실행할 때 과금**되어 비용을 가치에 직접 정렬한다.

- **Where:** Lightning Experience — Enterprise/Performance/Unlimited/Developer editions (추가 비용).
- **When:** 2025년 5월부터 구매 가능.

---

## Agentforce 기능

### Gain Visibility Into Agent Behavior With Agentforce Session Tracing

Agentforce Session Tracing은 상세 에이전트 상호작용 데이터를 **Data Cloud의 unified data model**에 캡처·저장한다. reasoning engine 실행, action, prompt 입력·LLM 출력, error message, final response를 포함한 에이전트 동작 전체(start to finish)를 본다. report·ad hoc 쿼리로 인사이트를 표면화하고 sandbox·production에서 테스트·디버그·모니터링에 데이터 기반 조치를 취한다.

- **When:** 2025년 8월.
- **How:** Setup → Einstein Audit, Analytics, and Monitoring → Agentforce Session Tracing 켜기. data model은 수 분 내 프로비저닝, 데이터 수집은 5분 간격.

### Gain Visibility Into Knowledge Retrieval Quality

**Knowledge/Retrieval Augmented Generation (RAG) Quality Data and Metrics**가 지식 검색의 품질 점수·런타임 상세를 캡처·저장한다. built-in 대시보드·report로 런타임 성능·추세를 추적한다.

- **RAG quality metrics (3종):** **Context Precision**, **Faithfulness**, **Answer Relevance** — 문제 패턴 식별, 근본 원인 분석, AI 솔루션 fine-tune.
- production·sandbox 환경 지원.
- **When:** 2025년 9월. data model 수 분 내 프로비저닝, 데이터 수집 5분 간격, 점수는 시간 단위(hourly) 계산.

### Gain Dynamic Insights with Agentforce Analytics Powered by Tableau Next (Beta)

AI 에이전트 성능 분석을 위한 최신 버전 Agentforce Analytics. **unified Session Tracing Data Model (STDM)** 위에 구축되어 세션 내 모든 event·interaction을 개별 event로 로깅하고, event를 clustering·tagging해 semantic data model로 쿼리·다중 세션 인사이트 도출. Data Cloud 필요.

- **When:** 2025년 9월(beta).

### Explore Insights and Optimize Agent Effectiveness with Agentforce Optimization (Beta)

Agentforce Session Tracing을 사용해 user·agent 세션의 모든 step·action을 unified data model에 기록. 공유 intent로 그룹화된 상호작용을 분석. utterance analysis의 진화형으로 **conversational moments** 개념 도입(daily 생성 + weekly clustering). 인사이트 발견, 개선 영역 식별, **agent hallucination 탐지** 등. Data Cloud 필요(DC1·Sandbox는 beta 미지원).

- **When:** 2025년 9월(beta).

### Agentforce Testing Center (강화)

- **Test Agents with Real-World Context Variables** — ID·current app 같은 context variable을 test case에 추가(Testing API의 test metadata에도 추가 가능). **When:** 2025년 5월.
- **Choose Test Case Evaluation Details** — test run에서 평가할 항목(latency·topic accuracy 등)을 선택. **When:** 2025년 5월.
- **Get Detailed Agent Response Scores in Testing Center Results** — pass/fail을 넘어 response accuracy·quality에 대해 **0~5점** 점수 제공(5 = 최고). **When:** 2025년 7월.
- **Include Conversation History in Test Cases** — test case 생성 시 또는 Testing API 입력으로 Conversation History 선택. (Testing API 사용 시 Agentforce 활성화 + 활성 에이전트 1개 이상 필요.) **When:** 2025년 7월.
- **Verify AI Sources with Citations in Agentforce Testing Center** — batch test에서 Actual Response가 연결된 Agentforce Data Library의 정보를 인용하면 citation source 자료 링크 제공(CSV 다운로드 시 citation URL 컬럼 추가). **When:** 2025년 8월 말. (Data Library에 citations 활성화 필요.)

### Resolve More Inquiries with an Enhanced Escalation Experience

에스컬레이션이 불가능할 때도 고객이 Agentforce Service agent와의 세션을 이어갈 수 있고, 에이전트는 에스컬레이션 시도 전 대화 컨텍스트를 유지한다. Escalation topic을 커스터마이징해 에스컬레이션 경험을 제어(예: 에스컬레이션이 완료되지 않을 때 할 말 지정).

- **When:** 2025년 7월 중순.

### Agentforce Supports Geo-Aware Routing

Agentforce가 이제 LLM 요청을 **Einstein 생성형 AI 플랫폼 인스턴스 위치에 가장 가까운 OpenAI 또는 Azure OpenAI 인스턴스**로 라우팅한다. 이전에는 모든 AI 에이전트 요청이 미국 OpenAI로 라우팅됐다.

- **How:** 모든 Agentforce reasoning engine 호출은 **geo-aware GPT 4 Omni (GPT-4o)** 모델 사용. 미국 내 요청은 미국 내 OpenAI GPT-4o(일부는 Azure OpenAI GPT-4o)가 처리. 미국 외 요청은 인스턴스에 가장 가까운 지원 Azure OpenAI GPT-4o 엔드포인트로 라우팅.
- **When:** 2025년 7월.

### Select Anthropic for Agentforce

Agentforce는 기본 모델 공급자로 OpenAI를 사용하지만, 이제 **Anthropic on Amazon Bedrock**을 모델 공급자로 선택할 수 있다. Salesforce-managed Anthropic 인스턴스는 **Salesforce trust boundary 내에 완전히 포함된 최초의 LLM 공급자**로, 모든 LLM 트래픽이 Salesforce VPC 내에 머문다.

- Atlas reasoning engine이 선택된 모델 공급자를 사용. 일관성을 위해 custom agent action을 **Anthropic Claude Sonnet 4 on Amazon**으로 업데이트할 것.
- **제한 사항 (PDF 전수):**
  - 성능·latency는 Anthropic보다 OpenAI가 더 우수(벤치마크는 artificialanalysis.ai).
  - **영어만 지원**.
  - **Multimodal 기능 사용 불가**.
- **Where:** Lightning Experience — Enterprise/Performance/Unlimited editions.
- **When:** 2025년 7월 21일 주. 7월 초기 릴리즈는 활성화를 위해 Salesforce에 문의 필요, **8월부터는 Setup에서 직접** Anthropic 선택 가능.

### Monitor and Improve AI Agent Adherence to Topic Instructions

**Instruction Adherence**는 에이전트 응답을 topic instruction 기준으로 평가하는 새로운 Agentforce guardrail이다. enhanced event log·Data Cloud report로 에이전트 성능·adherence를 가시화하고 topic 지시에서 벗어나는 사례를 식별한다.

- **Where:** Enterprise/Performance/Unlimited editions + Agentforce for Service add-on. **When:** 2025년 7월.

### Verification Actions 매핑 (보안 강화)

**Improve Agentforce Service Agent Security with Updated Verification Actions** — 민감 작업 수행 전 검증을 요구한다. 새 verification action은 **검증된 고객을 나타내는 Contact ID**에 응답한다. **2025년 7월 13일에 deprecated되는** 이전 버전은 미검증 **Contact Record**에 응답했다. 새 **Service Customer Verification** topic이 secure action에 필요한 정보를 수집한다. 구버전은 기존 에이전트에서 계속 작동하나, 에이전트 생성·업데이트 시에는 더 이상 제공되지 않는다.

> Pattern B — old action → new action 매핑은 PDF 표(line 1528–1553)를 셀 단위로 옮김.

| Old action (deprecated 2025-07-13) | New action |
|---|---|
| Get All Cases for Contact | Get Cases for Verified Contact |
| Update Customer Contact | Update Verified Contact |
| Reset Password | Reset Secure Password |
| Get Case By Case Number | Get Case By Verified Case Number |
| Identify Customer By Email | **Service Customer Verification** topic 사용 — 포함 액션: **Send Email with Verification Code**, **Verify Customer** |

- **Where:** Performance/Unlimited/Developer editions + Einstein for Service / Einstein Platform / Agentforce Service Agent add-on.
- **When:** 2025년 7월 13일 발효.

### 기타 빌더·개발 기능

- **Easily Use Responses From Custom Agent Invocable Actions in Flow Builder** — custom agent invocable action(버전 1.1.0)에서 에이전트가 반환할 필드를 정의해 flow·Apex에서 사용. 이전엔 text-string을 파싱해야 했음. **When:** 2025년 8월 4일 주.
- **Build Agents Faster With a More Intuitive Variable Management Experience** — 업데이트된 Context 패널에서 변수 사용처 추적, 생성 시 action 입력·출력에 변수 연결. **When:** 2025년 8월 4일 주.
- **Test and Customize your Agents with Improved Agent Versions** — topic·action이 에이전트별로 고유. 다른 버전·에이전트에 영향 없이 새 버전 생성·변경. **Agentforce Asset Library**로 모든 에이전트·버전에 topic·action 공유. **When:** 2025년 8월 말.
- **Easily Add Agents to Multiple Channels with Enhanced Connections Setup** — Agentforce Builder의 enhanced Connections 패널에서 연결 채널을 한 곳에서 관리(routing flow·adaptive response format·escalation message 가시성). **When:** 2025년 9월 8일 주.
- **Improve Support Efficiency with Enriched Case Creation** — **Create Case with Enhanced Data** 액션으로 요약 포함 구조화 case 자동 생성. 조건 충족 시 messaging 세션의 최근 case에 연결된 transcript 포함. (지원 채널: MIAW, WhatsApp, Facebook Messenger.) **When:** 2025년 5월.

### Beta / Pilot (전수)

- **Improve User Search Experience by Sharing Data Category Selection with Agentforce Service Agent (Beta)** — 사용자가 선택한 data category 정보를 Service Agent에 전달해 더 빠른 답변 제공. MIAW 및 Lightning/Classic 사이트 — Performance/Unlimited/Developer editions.
- **Chat with Agentforce in 16 More Languages (Beta)** — Agentforce (Default) 가 기존 언어(영어·일본어·프랑스어·독일어·이탈리아어·포르투갈어·스페인어, 특정 locale)에 더해 16개 추가 언어 지원. 추가 언어·locale code 전수: Greek(el), Romanian(ro), Polish(pl), Croatian(hr), Arabic(ar), Bulgarian(bg), Czech(cs), Estonian(et), Hungarian(hu), Hebrew(he), Hindi(hi), Indonesian(id), Tagalog(tl), Thai(th), Turkish(tr), Vietnamese(vi). 영어 외 언어 작업 시 system message는 수동 번역 필요. **When:** 2025년 8월.
- **Show a Typing Indicator for Sequential Messages on Apple Messages for Business Channels (Beta)** — enhanced Apple Messages for Business 채널의 enhanced bot이 순차 메시지 사이 typing indicator 표시. **When:** 2025년 6월. (활성화: Salesforce Customer Support 문의.)
- **Develop More Precise Agent Test Cases with Custom Evaluation Criteria** — Testing API에 custom evaluation criteria 추가(actual value·expected value·operator로 비교, latency 등). sandbox 한정. **When:** 2025년 6월 2일 주.
- **Pilot:** Agentforce (Default) 의 enhanced language support 및 위 Data Category Selection·Typing Indicator 등은 PDF에서 pilot/beta service로 명시(Beta Services Terms·Non-GA 약관 적용, 고객 재량 사용).

### Einstein Data Library

- **Get Real-Time Updates on Your Agentforce Data Library Build** — build 진행 표시기 제공. **When:** 2025년 5월.
- **Migrate to Data Cloud for Continued Agentforce Data Library Support** — **VSaaS 기반 search index 더 이상 미지원**. 에이전트를 Data Cloud 기반 data library로 이동(2025년 5월부 필수).
- **Connect Your Data Libraries to More Data Sources and Orgs with Custom Retrievers** — custom retriever로 Data Cloud의 더 많은 데이터 유형 연결, home org의 data library를 companion org 에이전트와 연결. retriever prefix: `File_…`(업로드 파일 인덱스), `KA_…`(Knowledge 인덱스), `Web_…`(웹 소스). Ensemble retriever 미지원. **When:** 2025년 6월.

---

## Prompt Builder

CRM 데이터(record field·flow·related list·Apex 머지 필드)를 통합한 prompt template를 생성·테스트·관리한다.

- **Optimize Prompt Development with Step-by-Step Visuals in Prompt Builder** — 생성→테스트→활성화 전 여정을 안내하는 step-by-step 레이아웃. Prompt(머지 필드 삽입) → Resolved Prompt(민감 org 데이터 마스킹 확인) → Response(최종 LLM 출력·tone·toxicity 평가). **When:** Summer '25 rolling 제공.
- **Ground Prompts with Relevant Knowledge from Web Sites** — prompt template에서 **web retriever** 사용. 공개 웹사이트 검색으로 LLM prompt grounding. top-level·trusted domain만 포함 권장. **When:** 2025년 7월.
- **Use Structured Outputs for Rendered Model Responses** — template이 **JSON 또는 HTML** 포맷으로 응답하도록 정의. **JSON** 선택 시 syntax check로 structure validation(clean·parseable 응답), **HTML** 선택 시 rich text preview 렌더링. Markdown 응답은 기본으로 styled preview 렌더링(bold·italic·bullet 가독성 향상). **When:** 2025년 7월 14일부 rolling.
- **Verify Sources with Citations in Prompt Templates** — citation이 AI 생성 응답을 원본 정보(예: retrieved knowledge)에 연결해 비교·검증 가능. 호출 시 응답에 numbered·clickable Sources 목록과 inline 번호 표시. **When:** 2025년 8월. (resource 삽입 후 retriever 선택 → Template Settings의 Response 섹션에서 citations 켜기.)
- **Analyze PDF File Inputs with Prompt Templates** — 일부 모델 한정, prompt template 내에서 PDF 사용. PDF 업로드로 template 검증 또는 Resource Picker에서 file metadata 추출해 grounding. 개선된 UI가 모델별 업로드 호환성·한도를 안내. **When:** 2025년 8월 말.
- **Instruction-Only Flex Prompt Templates and Optional Inputs** — 입력 없는 instruction-only template 생성(flow·Apex 등이 컨텍스트 제공 시). **Flex template는 0~5개 입력 지원.** 입력 정의 시 각 입력이 런타임 필수인지 **Require when template runs** 체크박스로 제어. **When:** 2025년 9월 2일부 rolling.
- **Manage Access to Model Providers** — org에서 모델 공급자를 선택적으로 enable/disable. 켜면 해당 LLM을 agent·prompt template·API 등에서 사용, 끄면 org에서 차단.

---

## Einstein Trust Layer

데이터·프라이버시 컨트롤을 end-user 경험에 통합해 생성형 AI 보안을 강화한다.

- **Increase Trust in AI Responses with Citations** — Agentforce (Default) 또는 Agentforce Service agent에 질문 시, source URL이 응답 내 **inline link**와 응답 바로 아래에 표시된다. 이전에는 응답 아래에만 포함됐다.
  - **효과(PDF 전수):** 출처 정보 제공으로 응답 신뢰 증가 / 정보 출처 검토 용이 / 에이전트의 전반적 신뢰성·credibility 향상.
  - **Where:** Lightning Experience, Salesforce mobile app(Android/iOS), MIAW — Enterprise/Performance/Unlimited/Developer editions(추가 비용).
  - **When:** 2025년 5월.

---

## 지원 모델 (Summer '25 신규)

신규 LLM 지원과 모델 deprecation·reroute 날짜.

> [!important] Pattern B-3 — 모델명·날짜는 PDF 원문(line 3056–3228)을 그대로 옮겼다. 특히 **GPT 4 Turbo(reroute Jun 30, 연장)** 와 **GPT 4 32k(reroute Jun 6)** 의 날짜가 다르므로 혼동 금지. 원문 오타는 (sic) 표기.

### 신규 추가 모델

| 모델 | 공급자 | 비고 | When (PDF) |
|---|---|---|---|
| **Claude Sonnet 4** | Anthropic (Salesforce-managed) | Prompt Builder·Einstein Studio·Models API에서 사용 | **Jun 6, 2025** (원문 "Jun 6", sic — 월 약식) |
| **GPT 4.1 / GPT 4.1 Mini** | OpenAI (geo-aware) | LLM 요청이 가까운 OpenAI/Azure OpenAI 데이터센터로 자동 라우팅 | **Jun 6, 2025** |
| **Gemini 2.5 Pro / Gemini 2.5 Flash** | Vertex AI (Google) | Salesforce-managed | **June 30, 2025** |
| **Gemini 2.5 Flash Lite** | Google | Salesforce-managed | **August 2025** |
| **GPT 5 / GPT 5 Mini** | OpenAI (geo-aware) | OpenAI·Azure OpenAI가 동일 underlying 모델로 요청 처리 | (PDF "Supported Models — August '25" 묶음) |
| **Amazon Nova Lite / Amazon Nova Pro** | AWS Bedrock (Salesforce-managed) | Prompt template 등에서 사용 | (PDF "Supported Models — September '25" 묶음) |

### 리라우팅 (Reroute)

| 모델 | 리라우팅 대상 | reroute 날짜 (PDF) |
|---|---|---|
| OpenAI **GPT 4 Turbo** | OpenAI GPT 4 Omni | **June 30, 2025** (기존 발표 Jun 6에서 **연장**) |
| OpenAI **GPT 4 32k** | OpenAI GPT 4 Omni | **June 6, 2025** |
| OpenAI **GPT 4** | OpenAI GPT 4 Omni | **June 30, 2025** |
| Azure OpenAI·OpenAI **GPT 3.5 Turbo** | **geo-aware GPT 4 Omni Mini** | **July 16, 2025** |

### 버전 업그레이드

- **GPT 4 Omni Gets a Version Upgrade** — GPT-4o 버전을 **`gpt-4o-2024-05-13` → `gpt-4o-2024-11-20`** 로 업그레이드(Azure OpenAI가 `gpt-4o-2024-05-13` 곧 retire 예정). Einstein Studio·Prompt Builder·Models API·AI 에이전트의 custom action 등 생성형 AI 기능에 영향. 예: GPT 4 Omni를 쓰는 prompt template은 이제 `gpt-4o-2024-11-20` 사용.

### 기타 모델 설정

- **Disable Region Fallback for Azure OpenAI** — Azure OpenAI 요청이 모델 엔드포인트 region 밖으로 fallback되는 것을 비활성화하는 새 설정. 생성형 AI 모델 요청을 region 내에 유지해야 하는 엄격한 요구사항에 유용.

---

## 관련 노트

- [[Summer '25]] — 상위 릴리즈 허브
- [[Summer '25/Development]] — 개발자 관점(AgentforceInput/Output·embeddedai·Agent API DX 연계)
- [[Summer '25/Clouds]] — 클라우드별 산업 에이전트 템플릿·topic·action
