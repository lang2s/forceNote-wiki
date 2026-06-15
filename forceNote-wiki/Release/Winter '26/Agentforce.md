---
tags: [release, winter_26, agentforce, einstein, ai]
api_version: v65.0
release_date: 2025-10
created: 2026-06-15
source: salesforce_winter26_release_notes.pdf (Salesforce Winter '26 Release Notes, Tier 2)
aliases: [Winter '26 Agentforce, 윈터26 에이전트포스, Agent Analytics GA, Agentforce Optimization GA, New Agentforce Builder, Agent Script, Agentforce Testing Center, Claude Sonnet 4.5, GPT 5.x, Gemini 3, Flex Credits]
---

# Winter '26 — Agentforce & Einstein

> Agent Analytics/Optimization GA, 24개 언어 GA, O3/O4 Mini·Claude Sonnet 4.5·Haiku 4.5 모델 GA, New Agentforce Builder(Beta)+Agent Script(Beta)+Testing Center(Beta) 등 Beta 전수, Flex Credits 신규 과금 유형, Trusted URL Allowlisting까지.

---

## 개요

Winter '26의 Agentforce & Einstein 변경은 월 단위로 롤아웃되며(여러 월간 릴리즈 노트에 분산), 정식 출시(GA)·Beta·과금·보안 변경이 함께 진행된다. 본 노트는 플랫폼·개발자·어드민 관점에서 GA 전수, Beta 전수, 지원 모델, 과금/명칭/보안 변경, 표준 토픽·액션 변경을 다룬다.

> 상위 허브: [[Winter '26]]
> 형제 spoke: [[Winter '26/Development]] · [[Winter '26/Platform]] · [[Winter '26/Clouds]] · [[Winter '26/Release Updates]]

**분류 메모 — 개발자 도구는 여기서 중복 작성하지 않는다.** 다음 항목은 개발자 도구라 [[Winter '26/Development]] spoke 소관이며 여기서는 위임만 한다:

- **SLDS 2 (GA)** — [[Winter '26/Development]] 참조.
- **Agentforce DX (GA)** — [[Winter '26/Development]] 참조.
- **Agentforce Vibes Extension (GA)** — [[Winter '26/Development]] 참조.

> 미성숙(non-GA) 항목 분류 메모: 이 섹션 PDF에는 **Pilot / Developer Preview 전용 마커 항목이 발견되지 않았다.** 따라서 아래 "Beta" 표 외의 별도 Pilot/Developer Preview 섹션은 두지 않는다.

---

## GA (정식 출시)

이번 릴리즈에서 일반 제공(Generally Available)으로 전환된 항목 전수.

### Track Agent Performance and Quality Metrics with Agent Analytics (Generally Available)

Agent Analytics가 정식 출시되어 에이전트 성능·품질을 추적한다. 신규 메트릭과 전용 Employee Agent dashboard를 제공하고 sandbox·DC1을 지원한다.

- **신규 Quality tab** — 서비스 에이전트의 quality score 제공.
- **Employee Agent support** — Employee Agent 전용 dashboard.
- **Additional metrics** — error rate, unique user count, 세션 내 action 수.
- Agentforce Analytics(Legacy)를 대체하며, **Legacy는 2026년 5월 retire** 예정.
- **Note:** Government Cloud 미지원.
- **Where:** Enterprise/Performance/Unlimited editions + Foundations/Agentforce 1.
- **When:** 2025년 11월 GA.
- **How:** Setup → Einstein Audit, Analytics, and Monitoring → Agentforce Session Tracing.

### Explore Insights and Optimize Agent Effectiveness with Agentforce Optimization (Generally Available)

Agentforce Optimization이 정식 출시되어 세션 인사이트 탐색과 에이전트 효과 최적화를 지원한다.

- **Session Trace 뷰 개선** 및 **voice agents 지원**.
- sandbox·DC1 지원.
- **Daily intent association** 제공.
- **명칭 변경: Moments → Intents** (데이터 모델 변경 없음 — 명칭만 변경).
- **Note:** Government Cloud 미지원.
- **When:** 2025년 11월 GA.

### Chat with Agentforce in 24 More Languages (Generally Available)

Agentforce가 기존 지원 언어에 더해 **24개 언어**를 추가 지원한다.

- **How:** Agent Builder → Language Settings.
- **When:** 2025년 11월 GA.
- **추가된 24개 언어·로케일 전수:**

| 언어 | 로케일 | 언어 | 로케일 |
|---|---|---|---|
| Bulgarian | bg | Korean | ko |
| Catalan | ca | Malay | ms |
| Chinese (Simplified) | zh_CN | Norwegian | no |
| Chinese (Traditional) | zh_TW | Polish | pl |
| Croatian | hr | Romanian | ro |
| Czech | cs | Swedish | sv |
| Danish | da | Thai | th |
| Dutch | nl | Tagalog | tl |
| Estonian | et | Turkish | tr |
| Finnish | fi | Vietnamese | vi |
| Greek | el | Hindi | hi |
| Hungarian | hu | Indonesian | id |

### New Connect REST API Resources for Einstein Bots (Generally Available)

Einstein Bots용 **Utterance Prediction API** 리소스가 정식 출시되었다. 아래 엔드포인트와 request/response body는 PDF 원문에서 그대로 옮긴 것이다(verbatim).

```http
// verbatim — Salesforce Winter '26 Release Notes 원문 발췌 (Connect REST API)

POST /connect/bots/utterance-prediction/intent
  New request bodies:
    - Bot Utterance Collection Prediction Input
    - Utterance Prediction Input
  New response bodies:
    - Bot Utterance Collection Prediction
    - Utterance Prediction
    - Utterance Prediction Summary

POST /connect/bots/utterance-prediction/intentFromSet
  New request body:
    - Bot Utterance Collection Prediction From Set Input
```

- **When:** 2025년 9월 15일 주(week of Sep 15, 2025) GA.

### O3 and O4 Mini Models Are Generally Available

OpenAI **O3**·**O4 Mini** 모델이 정식 출시되었다.

- rate limit **500 requests/min**.
- **geo-aware** — OpenAI 또는 Azure OpenAI로 라우팅.
- **When:** 2025년 12월 15일 주(week of Dec 15, 2025) GA.

### Claude Sonnet 4.5 Is Generally Available

**Claude Sonnet 4.5**(Anthropic)가 정식 출시되었다.

- rate limit **500 requests/min**.
- **When:** 2025년 12월 22일 주(week of Dec 22, 2025) GA.

### Claude Haiku 4.5 Is Generally Available

**Claude Haiku 4.5**(Anthropic)가 정식 출시되었다.

- rate limit **250 requests/min**.
- **When:** 2025년 12월 22일 주(week of Dec 22, 2025) GA.

### Convert Overages into Revenue with Agentforce (Generally Available)

Revenue/Quote Management 영역에서, 오버리지(overage)를 매출로 전환하도록 지원한다.

- **Get Usage Details** 액션 — 계정 ID로 **최대 5개**의 usage resource consumption overage를 조회한다.

---

## Beta

아래 항목은 모두 Beta로 제공된다. (이 섹션 PDF에서 Pilot/Developer Preview 전용 마커는 발견되지 않았다.)

| 제목 | 한 줄 요약 |
|---|---|
| Connect Agents to Enhanced Chat v2 in Agentforce Builder (Beta) | Service agent에 Enhanced Chat v2 connection 추가 |
| Build Complex Agents Faster with the Latest Enhancements to Canvas View (Beta) | Script view 전용 기능을 Canvas view에서 사용 |
| Create Employee Agents in the New Agentforce Builder (Beta) | New Agentforce Builder에서 Employee agent 지원 |
| Build High-Quality Agents with Validation Enhancements in the New Agentforce Builder (Beta) | agent action validation check 강화 |
| Accelerate AI Experimentation with Agentforce Grid (Beta) | spreadsheet형, CRM/Data 360 실데이터 기반 실험 |
| Combine Determinism and LLM Reasoning with Agent Script (Beta) | Agent Script 언어 — if-else·변수·토픽 제어 |
| Confidently Build Agents with In-Depth Agent Previews (Beta) | reasoning trace·변수값·AI 설명 미리보기 |
| Measure Agent Outcomes With Task Resolution (Beta) | Task Resolution 메트릭으로 outcome scoring |
| Get Flexible, AI-Driven Testing for Your Agents With Testing Center in Agentforce Studio (Beta) | multi-turn·custom eval·regression 테스트 |
| Track Agent Health Over Time With Test Run History in Agentforce Testing Center (Beta) | test run history로 시간 경과별 health 추적 |
| Create Tests Quickly and Consistently with Test Suite Cloning in Agentforce Testing Center (Beta) | test suite cloning으로 일관된 테스트 생성 |
| View AI Agent Inputs and Outputs Directly from Testing Center (Beta) | Testing Center에서 입출력 직접 확인 |
| Fine-Tune Agent Tests in Real-Time with Inline Editing in Agentforce Testing Center (Beta) | inline editing으로 실시간 테스트 조정 |
| Align Testing with Your Business Goals Using Custom Evaluations in Agentforce Testing Center (Beta) | LLM Judge 기반 custom evaluation |
| Improve Web Search Results by Using OpenAI as a Search Provider in Search The Web Action (Beta) | OpenAI/BrightData search provider 선택 |
| Gain Dynamic Insights with Agentforce Analytics Powered by Tableau Next (Beta) | STDM 기반 동적 인사이트 |
| Build Enterprise-Ready Agents with the New Agentforce Builder (Beta) | deterministic+NL, graph-based Atlas 엔진 |
| Quickly Run Custom SOQL Using Named Query API (Beta) | Named Query API로 custom SOQL 실행 |
| Automatically Check Prerequisites Before Creating Agents from Bots (Beta) | Bot→Agent 생성 전 prerequisite 자동 점검 |
| Convert Selected Bot Dialogs to Agents (Beta) | 선택한 Bot dialog를 Agent로 변환 |
| Use GPT 5.2 on the Einstein Platform (Beta) | Einstein Platform에서 GPT 5.2 사용 |
| Use GPT 5.1 on the Einstein Platform (Beta) | Einstein Platform에서 GPT 5.1 사용 |
| Use Gemini 3 Flash on the Einstein Platform (Beta) | Einstein Platform에서 Gemini 3 Flash 사용 |
| Use Gemini 3 Pro on the Einstein Platform (Beta) | Einstein Platform에서 Gemini 3 Pro 사용 |
| Use Claude Opus 4.5 on the Einstein Platform (Beta) | Einstein Platform에서 Claude Opus 4.5 사용 |
| Turn On Beta Generative AI Models for Faster Access to New Models (Beta) | Einstein Setup에서 beta generative AI model을 활성화해 신규 모델에 더 빠르게 접근 (인쇄 p.479) |

> **Agent Script 코드 예제 안내** — PDF의 Agent Script 예제는 스크린샷(이미지)으로만 제공되어 텍스트 추출이 불완전하다. 부분 판독한 코드를 위키에 옮기면 부정확하므로 본 노트에는 코드를 싣지 않는다. Agent Script는 deterministic 제어(if-else·변수·토픽 제어)와 LLM reasoning을 결합하는 언어라는 설명만 둔다.

---

## 지원 모델

> Pattern B — GA/Beta 구분을 셀 단위로 분리해 옮긴다. GA 모델과 Beta 모델을 섞지 않는다.

### GA 모델

| 모델 | 공급자 | rate limit | When (PDF) |
|---|---|---|---|
| **O3** | OpenAI (geo-aware) | 500 req/min | week of Dec 15, 2025 |
| **O4 Mini** | OpenAI (geo-aware) | 500 req/min | week of Dec 15, 2025 |
| **Claude Sonnet 4.5** | Anthropic | 500 req/min | week of Dec 22, 2025 |
| **Claude Haiku 4.5** | Anthropic | 250 req/min | week of Dec 22, 2025 |

### Beta 모델

| 모델 | 공급자 |
|---|---|
| **GPT 5.1** | OpenAI |
| **GPT 5.2** | OpenAI |
| **Gemini 3 Flash** | Google |
| **Gemini 3 Pro** | Google |
| **Claude Opus 4.5** | Anthropic |

> **동일 모델 GA/Beta 이중 트랙** — Claude Sonnet 4.5·Claude Haiku 4.5는 이번 릴리즈에 GA로 승격됐으나(위 "GA 모델" 표), Einstein Platform에서 **(Beta) 엔트리로도 먼저** 제공됐다: *Use Claude Sonnet 4.5 on the Einstein Platform (Beta)* (Oct 6, 2025), *Use Claude Haiku 4.5 on the Einstein Platform (Beta)* (Oct 27, 2025) → 이후 12월 GA(week of Dec 22, 2025). 즉 두 모델은 Beta(10월) → GA(12월) 이중 트랙을 거쳤다. (PDF 인쇄 p.478·483)

### 추가 모델

| 모델 | 공급자 | When (PDF) |
|---|---|---|
| **Amazon Nova Lite** | AWS Bedrock (Salesforce-managed) | Sep 2025 |
| **Amazon Nova Pro** | AWS Bedrock (Salesforce-managed) | Sep 2025 |

### 모델 옵션·공급자 설정

- **Salesforce Default** (권장) — GPT-4o를 포함한 Salesforce-managed 모델 mix.
- **AWS-Hosted** — Anthropic Claude Sonnet 4 on Amazon Bedrock.
- **Manage Access to Model Providers** — Setup → Einstein Setup → Configure Model Providers 에서 모델 공급자를 enable/disable.
- **Disable Region Fallback for Azure OpenAI** — Azure OpenAI 요청이 region 밖으로 fallback되는 것을 비활성화(Data 360 ON 필요).

---

## 주요 변경

### 과금 — Flex Credits

> Pattern B-2 — usage type을 전수 나열한다. (영역별 적용 대상을 누락 없이 옮김.)

- **Changes to AI Credit Consumption (Oct 2025)** — 다음 영역의 AI 사용이 **더 이상 credit을 소비하지 않는다**: B2C Commerce, B2B and D2C Commerce, MuleSoft, Tableau, Tableau Next.
- **New Billable Usage Types for Flex Credits (Oct 2025)** — Flex Credits에 신규 과금 usage type 4종 추가:
  - **Starter Prompts**
  - **Standard Prompts**
  - **Basic Prompts**
  - **Advanced Prompts**
- **New Billable Usage Types for Agentforce Voice (Oct 24, 2025)** — Voice용 과금 usage type 2종 추가:
  - **Standard Voice Action**
  - **Custom Voice Action**
- **New Flex Credits Billable Usage Type for Translation (Digital Wallet, Feb 2026)** — machine translation에 대한 신규 과금 usage type. **character 수 기준 metering**.
- **Process Large Data Volumes Faster with Native Batch Processing (Prompt Builder, week of Dec 12, 2025)** — batch job당 **10,000 items** 처리. 지원 모델: GPT 4.1, GPT 4.1 Mini, GPT 4 Omni, GPT 4 Omni Mini, GPT 5, GPT 5 Mini.

### 명칭 변경

- **Agentforce SDR → Lead Nurturing** 명칭 변경.
- **Moments → Intents** 명칭 변경 (Agentforce Optimization GA 내, 데이터 모델 변경 없음).

### 보안

- **Secure Your Agents with Trusted URL Allowlisting (Sep 8, 2025)** — trusted URL allowlist를 enforce한다. 미등록 link는 차단되고, 미승인 URL은 응답에서 **"URL_Redacted"** 로 치환된다.

### 기타 변경

- **Easily Migrate from Agentforce (Default) to an Employee Agent (week of Aug 18, 2025)** — Agentforce (Default) → Employee Agent 마이그레이션을 간소화.
- **Modernize Agent Conversations with Enhanced Chat v2 (Oct 24, 2025)** — Enhanced Chat v2로 에이전트 대화 현대화.
- **Link Your Agent to Multiple Data Types with Ensemble Retrievers in Agentforce Data Library (Oct 2025)** — Ensemble retriever로 여러 데이터 유형을 에이전트에 연결. (PDF에 Beta 마커 없음 — GA성 기능으로 분류.)
- **Use Generative AI Immediately in New Orgs (Dec 4, 2025)** — 신규 org에서 Einstein이 자동으로 enable되어 생성형 AI를 즉시 사용.

---

## 기타 향상

Beta 마커 없는 enhancement 항목(GA성). PDF 월별 마스터 표에서 흡수.

- **Customize Welcome Recommendations in Agentforce Builder (Nov 2025)** — Agentforce Builder에서 welcome recommendation을 **최소 3개~최대 20개** 구성한다. (인쇄 p.483)
- **Get Summarized Answers with the General Web Search Topic and Action (Oct 2025)** — **General Web Search** 토픽/액션을 out-of-box로 제공해 요약 답변을 반환.
- **Enable Voice Conversations for Agentforce Service Agents (week of Oct 21, 2025)** — Agentforce Voice로 Service agent의 음성 대화를 지원.
- **Help Your Voice-Enabled Agent Recognize Key Terms and Phrases (week of Dec 15, 2025)** — **Key-term Prompting**으로 voice agent가 핵심 용어·문구를 인식.
- **Apply Advanced Content Processing Tools for Smarter Agentforce Data Libraries (Dec 2025)** — **Intelligent Context**로 이미지·flow chart·table 포함 파일을 처리. **10MB 이하 PDF는 자동** 처리.
- **Deliver Emails with the Service Email Connection (week of Nov 3, 2025)** — **Service Email** connection으로 이메일 전송.
- **Escalate Complex Employee Agent Conversations to Reps (end of Sep 2025)** — Agentforce Employee Agent(AEA)가 **Experience Cloud escalation**을 지원.
- **Gain Visibility Into Knowledge Retrieval Quality (Sep 2025)** — **RAG Quality Data and Metrics** 제공: Context Precision, Faithfulness, Answer Relevance.
- **Easily Add Agents to Multiple Channels with Enhanced Connections Setup (week of Sep 8, 2025)** — enhanced **Connections** panel로 에이전트를 여러 채널에 추가.

### Einstein Bots

- **Deliver Generative Knowledge Answers with More Control and Consistency (late Sep 2025)** — **Generative Knowledge Answers** action step으로 더 정밀하고 일관된 답변 제공.
- **Get More Customer Responses to Dynamic Option Messaging Components (week of Sep 15, 2025)** — **entity recognition**으로 Dynamic Option messaging 응답률 향상.
- **Article Answers for Einstein Bots Is Being Retired** — **2026년 2월 28일 retire** 예정(이전 공지 12/31/2025에서 변경).
- **Legacy Chat Is Being Retired** — **2026년 2월 14일 retire** 예정.
- **Instruction-Only Flex Prompt Templates and Optional Inputs (Prompt Builder, Sep 2, 2025)** — instruction-only flex prompt template과 optional input(**zero~five inputs**) 지원.

---

## New and Changed Standard Agent Topics and Actions

표준 에이전트 토픽·액션의 월별 신규/변경 요약.

| 월 | 신규/변경 내용 |
|---|---|
| **December '25** | **B2C Commerce Coupon Management** (신규 토픽) — **Apply Coupon to B2C Cart** 액션 포함. |
| **November '25** | **Agentforce Scheduling for Field Service** (Conversations org 지원 확대), Scheduling 템플릿 업데이트, **B2C Commerce Product Search Assistant** 업데이트, **Pre Visit Planning** (신규 — **Generate Healthcare Provider Summary**), **Query Records** (NL search custom). |
| **October '25** | **Appointment Management for Field Service** 업데이트, **Customer Verification With Email** (신규), **Inbound Sales Record Creation** (신규), **Product Inquiries and Qualification** (신규), **Prospect Meeting Scheduling** (신규), **Quote Management** (Revenue Cloud — **Get Usage Details** 등 5개 신규 액션 + 1개 업데이트). |
| **September '25** | 산업별(Field Service·Healthcare·Wealth·Education 등) 다수 토픽·액션 추가. 상세는 PDF 인쇄 p.532–536 참조. |

---

## 관련 노트

- [[Winter '26]] — 상위 릴리즈 허브
- [[Winter '26/Development]] — 개발자 도구(SLDS 2·Agentforce DX·Agentforce Vibes Extension GA 등)
- [[Winter '26/Platform]] — 플랫폼 변경
- [[Winter '26/Clouds]] — 클라우드별 GA·산업 에이전트(Sales·Service·Data 360·Industries 등)
- [[Winter '26/Release Updates]] — 릴리즈 업데이트·보안·deprecation
- [[Release MOC]] — 전체 릴리즈 노트 목차
