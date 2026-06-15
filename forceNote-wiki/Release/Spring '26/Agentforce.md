---
tags: [release, spring_26, agentforce, einstein, prompt-builder, supported-models]
source: salesforce_spring26_release_notes.pdf (Spring '26, API v66.0, Agentforce Platform 챕터 논리 p.189–254, Tier 2)
created: 2026-06-15
aliases: [Spring 26 Agentforce, 스프링26 에이전트포스, Spring 26 Einstein, Spring 26 Prompt Builder, Spring 26 Supported Models, 에이전트포스 릴리즈노트, 스프링26 지원모델]
---

# Spring '26 — Agentforce / Einstein

> 새 Agentforce Builder(Agent Script 기반) GA, Task Resolution 메트릭 GA, HyperClassifier subagent 분류, Agentforce Voice 프랑스어, 다수 Beta(Multi-Agent Orchestration·Canvas v2·Employee agents·Session Trace OTel API), Prompt Builder Web Action·action chaining, 그리고 GPT 5.1/5.2/5.4·Claude Opus 4.5·Claude Sonnet 4.6 모델 GA + 다수 Beta 모델·reroute를 다루는 Spring '26 Agentforce Platform 챕터 정리.

---

PDF 챕터 제목은 **"Agentforce Platform"**(TOC 약칭 "Agentforce & Einstein"). 부제: *"Supercharge your workforce efficiency with predictive and generative AI."* 하위 카테고리 순서는 **Agentforce → Standard Topics/Actions → Einstein Bots → Einstein Development → Prompt Builder → Supported Models**.

각 entry의 `Where`는 별도 표기 없으면 **Enterprise, Performance, Unlimited, Developer Edition (with Foundations or Agentforce 1)**을 기본으로 한다.

---

## 1. GA (Generally Available) — 전수

본문에 상세 entry가 있는 GA는 5건이다(+ 챕터 인트로 요약에만 등장하는 Agentforce Grid는 §7 cross-reference 참조).

### The New Agentforce Builder Is Now Generally Available

새 Agentforce Builder(Agentforce Studio)가 GA. 코어는 **Agent Script** — 논리식 + 자연어 prompt를 조합해 정교한 multi-step workflow를 구성한다. in-depth agent previews·trace·debugging, text editor-inspired 인터페이스에 AI assistance 내장.

- **When:** February 20, 2026. desktop only. (추가 UI language support는 April 2026 예정)
- Beta 이후 개선:
  - **Agent creation/management:** default Agentforce Service agent template 지원(out-of-the-box topics·actions; 이전엔 template에서 Employee agent만). All Agents list 또는 빌더에서 에이전트 버전 삭제 가능. 레거시 빌더 생성 에이전트도 All Agents list에 표시(레거시 빌더에서 열림).
  - **Canvas view:** utility actions(escalate·set variables·transition) 생성·편집. topic 편집 시 참조 resource detail 보기/편집. 복붙 개선 + 키보드 단축키(Ctrl/Cmd+c, Ctrl/Cmd+a+a로 instruction block 전체 선택).
  - **Welcome messages:** context variables 지원(인사 개인화).
  - **Agent previews:** Interaction Details panel에서 trace view의 system events 표시/숨김(기본 숨김), event click 시 JSON 전체 화면.
- **How:** App Launcher → Agentforce Studio → Agents → New Agent.

### Measure Agent Outcomes With Task Resolution

새 Agentforce Builder로 만든 에이전트의 outcomes를 scoring하는 **Task Resolution metric**이 GA. user task 이해·해결 정도를 측정한다.

- **When:** February 20, 2026. desktop only.
- **How:** Einstein Audit and Feedback 켜기 → 새 Agentforce Builder(Beta)로 에이전트 구축 → production/sandbox 운영 시 outcomes 자동 scoring(**Fully Resolved, Partially Resolved, Unresolved**), 모든 agent types. scores·explanations이 Data 360의 DMO로 stream → Data 360 dashboard·report·query 구축.

### GPT 5.1, GPT 5.2, and Claude Opus 4.5 Are Generally Available

**GPT 5.1, GPT 5.2, Claude Opus 4.5**가 GA(이전 beta). production 사용 준비됨.

- **When:** week of March 23, 2026. **Who:** Data Cloud·Einstein permission sets.

### Use Claude Sonnet 4.6 on the Einstein Platform

**Claude Sonnet 4.6** GA.

- **When:** week of April 13, 2026. **Who:** Data 360·Einstein permission sets.

### Use GPT 5.4 on the Einstein Platform (GA)

**GPT 5.4** GA(Spring '26 초에는 beta였음). geo-aware(OpenAI 또는 Azure OpenAI, 동일 underlying model).

- **When:** GA week of April 27, 2026. **Who:** Data 360·Einstein permission sets.

> Supported Models 카테고리에는 GPT 5.4가 같은 챕터 안에서 **Beta entry(week of April 6, 2026)** 와 **GA entry(week of April 27, 2026)** 두 번 등장한다. §6에서 둘 다 표기.

---

## 2. Agentforce — Enhancement / Change (GA 외 본문 entry 전수)

### Easily Upgrade Agents from the Legacy Builder to the New Builder

레거시 Agentforce Builder(Setup)의 에이전트를 Agentforce Studio의 새 Builder로 몇 번의 클릭으로 업그레이드. 에이전트·버전 지정 → 새 버전 자동 생성. 원본의 모든 subagents·actions·system messages·settings·data·connections를 **Agent Script로 변환**해 포함. 원본 에이전트는 영향 없이 레거시 빌더에서 계속 편집 가능.

- **When:** rolling basis, sandboxes부터 week of May 4, 2026. Setup for AI agents는 desktop only.

### Build an Agent Script-Powered Agent End to End with the Updated Implementation Guide

Agentforce Implementation Guide를 새 Builder용으로 업데이트. Agent Script로 deterministic 에이전트 + hybrid reasoning, enhanced preview·debugging, 새 Testing Center, 업데이트된 Observability guide.

- **When:** April 20, 2026.

### Improve Web Search Results by Using an Additional Search Provider Option

Search The Web agent action이 **You.com**을 search provider로 지원(이전 BrightData·OpenAI). 이제 selection list로 provider 선택.

- **When:** April 7, 2026.
- **How:** Agentforce Builder → Search The Web → Edit Action → Inputs → Search Provider → Configuration Value dropdown.

### Improve Web Search Results By Using Allowed Domains

Search The Web action이 **allowed domains** 지정으로 결과 필터링(최대 **10개**). per-action 구성(Setup의 Trusted URLs와 무관). 미지정 시 default provider 동작.

- **When:** February 17, 2026.
- **How:** Search The Web → Edit Action → Inputs → Allowed Domains → 최대 10개 comma-separated.

### Manage AI Usage with Product-Based Unmetering

**Product-Based Unmetering** = license-driven 모델. 특정 Agentforce·generative AI 기능 사용을 license 기반으로 assigned users에 unmetered. global unmetering의 scoped 버전.

- **When:** week of April 20, 2026. (제한된 Agentforce Add-ons에서만)

### Enable Voice Interactions in French with Agentforce Voice

Agentforce Voice가 **프랑스어** 지원 추가.

- **Where:** Enterprise, Unlimited, Developer with Foundations or Agentforce 1, and Service Cloud Voice add-ons.
- **When:** week of March 30, 2026.
- **How:** Legacy Agent Builder → language settings → French; connections → Telephony connection → compatible French voice 선택.

### Topics Are Now Subagents (용어 변경)

agent **topics → subagents**, **Topic Selector → Agent Router**로 명칭 변경. 기능 변화 없음(transition 중 신/구 용어 혼재).

- **When:** week of April 6, 2026. desktop only.

### Convert Audio to Text with Speech To Text Action (신규 액션)

**Speech To Text action** — 오디오 파일을 텍스트로 변환. audio file ID → transcript. 다국어, 지원 포맷 **MP3, WAV, FLAC, OGG, OGA, AMR, MPEG, MPGA**. **Agentforce Builder, Flow, REST, Apex**에서 사용 가능.

- **When:** February 17, 2026.
- **How:** Agentforce Builder → Conversation Preview → "convert speech to text" → Audio File ID 제공 → Submit.

### Migrate Your Agents' Connected Apps to the External Client App Framework (Retirement/Migration)

**Spring '26부터 connected apps 신규 생성 불가.** connected apps → external client apps로 migrate 권장. 레거시 Agentforce Builder의 기존 connected apps·Slack connected apps는 영향 없음.

- **When:** early January 2026.
- **How:** App Manager에서 connected app → Migrate to External Client App. 변환 후 connected app은 App Manager에서 read-only. 다음 OAuth scope를 가진 기존 apps는 Messaging connection의 External Apps list에 표시:
  - Access chatbot services (`chatbot_api`)
  - Access the Salesforce API Platform (`sfap_api`)
  - Manage user data via APIs (`api`)

### Observability Enhancements: Optimization Breadcrumb Navigation, UI Enhancements, and Additional Analytics Metrics

user interruption events로 granular visibility, session 간 navigation, 3-layer drill-down, breadcrumb navigation, bulk transcript downloads, standardized date filters.

- **Optimization/Voice:** Track User Interruptions(Agentforce Voice Sessions), agent processing time(reasoning·acting), breadcrumb navigation(Previous/Next), Bulk Transcript Downloads(CSV export limit 제거), channel type별 global filter.
- **Analytics:** standardized date filter(Analytics↔Optimization). 신규 SDM metrics: **Interruption Rate, Interruption Count**(voice), **Stickiness Rate**.
- **Where:** Enterprise, Unlimited with Einstein for Sales/Platform/Service add-on.
- **When:** March 16, 2026.
- **Who:** Access Agentforce Optimization + Data Cloud User. Analytics drill-down은 CRM Analytics User 또는 Einstein Analytics Plus 추가.

### Agentforce Observability: New Quality Metrics and Civilian GovCloud Support

Agent Optimization을 Civilian Government Cloud로 확장 + 신규 metrics.

- **Agent Optimization:** Civilian Government Cloud 지원, Session Outcome status(user abandonment·deflection), Split view(Interaction Details + Trace Events 단일 workspace).
- **Agent Analytics 신규 metrics:** **User Feedback (Positive, Negative, N/A)** + positive·negative feedback counts, **Task Resolution Rate**, **Instruction Adherence and Adherence Rate**, **Average Agent Toxicity Score**. Semantic data model 신규 DMOs.
- **Where:** Enterprise, Unlimited with Einstein for Sales/Platform/Service add-on(Agent Optimization은 Civilian GovCloud도).
- **When:** April 13, 2026.
- **How:** Setup → Einstein Audit, Analytics, and Monitoring Setup → Audit and Feedback 켜기.

### Evaluate AI Performance with New RAG Metrics and Enriched Analytics

3개 신규 RAG(Retrieval-Augmented Generation) evaluation metrics(Analytics Foundation Data Model에 추가) → trust score.

- 신규 metrics:
  - **Average Answer Faithfulness Score:** grounded source data(Knowledge Base 등) 준수 정도.
  - **Average Answer Relevance Score:** 응답이 고객 질문에 부합하는 정도.
  - **Average Context Relevance Score:** 올바른 data source 검색 여부.
- **Where:** Enterprise, Unlimited with Einstein for Sales/Platform/Service add-on.
- **When:** week of February 9, 2026.
- **How:** Setup → Audit and Feedback + Knowledge/RAG Quality Data and Metrics 토글 on.

### Connect Agents to Your Knowledge Sources in the New Agentforce Builder

새 Builder에서 **Answer Questions with Knowledge** action을 Agentforce Data Library 통해 사용. 할당된 data library의 knowledge 접근.

- **Where:** Enterprise, Performance, Unlimited with Agentforce for Service/Sales, Foundations or Agentforce 1. Agentforce Data Library는 Data Cloud 필요. Intelligent Context는 Data Cloud 1 orgs 불가.
- **Note:** new Agentforce Builder는 beta service.
- **When:** December 2025.
- **How:** Agentforce Studio → Agents. 1) data library 추가, 2) Answer Questions with Knowledge action 추가. Explorer → Data → Data Library → dropdown → Show sources(citations).

### Route Agentforce Voice Calls Using SIP

Agentforce Service agent에 **SIP(Session Initiation Protocol)**로 call routing(이전 PSTN phone number만).

- **When:** February 26, 2026.
- **How:** Agentforce Voice setup page → SIP tab.

### Agentforce Agents Settings Have Moved

"Enable the Agentforce (Default) Agent"·"Select the Model for Agentforce" 설정이 **Einstein Audit, Analytics, and Monitoring Setup** page로 이동. "Migrate to an Agentforce Employee Agent" 섹션 → Default agent의 action dropdown "Migrate to an Employee Agent" action으로 교체.

- **When:** January 8, 2026.
- **How:** Setup → Quick Find → "Audit, Analytics, and Monitoring".

### Agent Optimization: Voice Session Playback and Dashboard Enhancements

integrated voice playback + enhanced dashboard filtering.

- Integrated Voice Playback(Sessions page integrated player), Filtering by Modality(**Voice, Chat, All Modalities**), Processed/Unprocessed Sessions(2 distinct views), Session Timeframe Range(Last 24 hours), Transcript Export(single/multiple, 최대 **100** as CSV), Deeper Session Insights(duration metrics — Sessions & Intents tab). **Note:** Duration metrics는 현재 Chat만(Voice는 coming soon).
- **Where:** Enterprise, Unlimited with Einstein for Sales/Platform/Service add-on.
- **When:** January 2026.
- **Who:** Access Agentforce Optimization + Data Cloud User.

### Opt Out of Allowing Salesforce Access to Customer Data (Privacy)

Setup UI의 self-service toggle로 Salesforce의 Customer Data 접근 opt out(이전엔 support case 필요). 기본 on(Government Cloud 사용 또는 이미 미공유 결정 org 제외).

- 끄면: 신규 data 미공유, Salesforce가 수집 data를 최대 **30일** 보관 후 삭제(복구 불가).
- **Where:** Enterprise, Performance, Unlimited, Developer.
- **When:** consent management February 4, 2026.
- **How:** Setup → Einstein Setup → Einstein 켜기 → Opt Out of Customer Data Access.

### Streamline Enhanced Chat v2 Conversations with the Latest Improvements

Enhanced Web Chat 기능이 Enhanced Chat v2 deployments에 제공: business hours·estimated wait time·queue position, reCAPTCHA, custom chat window header, downloadable conversation transcripts.

- **Where:** Enterprise, Performance, Unlimited, Developer.
- **When:** week of February 2, 2026.
- **How:** queue position은 Enhanced Omni-Channel Routing + routing type Omni-Queue/Omni-Flow 설정 후만.

### Generate Test Cases in Your Agent's Default Language

Testing Center가 Agentforce agent의 **default language**로 test cases draft(이전 English만).

- **When:** January 2026.

### Introducing Agentforce Voice Minutes Usage Type for Agentforce Voice (Billing)

**Agentforce Voice Minutes** usage type — call duration 측정(voice actions 수 아님). Agentforce Voice Minutes 구독 구매한 제한된 고객만.

- **Where:** Enterprise, Unlimited, Developer with Foundations or Agentforce 1, and Service Cloud Voice add-ons.
- **When:** week of February 9, 2026.
- **How:** Digital Wallet의 Flex Credits consumption card.

### New Usage Types for Agentforce Speech (Billing)

2개 신규 usage types: **Speech-to-Text, Text-to-Speech**. dedicated standard actions·invocable actions·flows·기타 AI 기능 사용에 적용. 독립 metered(billing 중복 없음).

- **When:** week of February 17, 2026.
- **How:** Digital Wallet의 Flex Credits consumption card → Speech Foundation usage types.

### Optimize Your Agents with Agent Platform Tracing

**Agent Platform Tracing** — 에이전트 실행·의사결정 deep visibility. steps·tool usage·LLM calls chain capture·visualize.

- **When:** April 6, 2026.
- **How:** Setup → Einstein Audit, Analytics, and Monitoring Setup → Agentforce Session Tracing 켜진 것 확인 → Agent Platform Tracing 켜기 → Data 360 Report for Service Rep Sessions and Platform Traces 생성·실행.

### New Tag Limits for GenAIRequestTag Queries (Developer)

Einstein generative AI audit and feedback의 GenAIRequestTag queries에 LLM request당 최대 **20 individual rows** enforce. 초과 tags는 단일 **REMAINDER_TAGS** row(JSON array)에. Data 360 credits 소비 감소.

- **When:** April 10, 2026.
- **How:** 기존 `tag__c` filter SQL queries는 REMAINDER_TAGS JSON value를 parse하도록 업데이트. one-row-per-tag 가정 dashboard·report·Data Cloud recipe는 error 없이 incomplete result 반환 가능.

### Deploy Agents to Slack Quickly with the Slack Connection

새 Builder에서 Agentforce Employee agent에 **Slack connection** 추가(이전엔 Slack connected app 설치 후 Messaging connection에 추가 필요).

- **When:** week of March 9, 2026.
- **How:** Employee agent → 새 Builder → Explorer panel → Add Connection → Slack → Add to Agent.

### Elevate the Enhanced Chat v2 Experience with Pre-Chat, Post-Conversation Surveys, and User Verification

Enhanced Chat v2 deployments에 pre-chat form(또는 hidden pre-chat fields auto-fill), post-conversation survey, token-based user verification.

- **Where:** Enterprise, Performance, Unlimited, Developer.
- **When:** week of March 9, 2026.

### Deliver Emails in the New Agentforce Builder

새 Builder의 Service agent에 **Service Email connection**(Email-to-Case 기반 personalized email) + 신규 **Marketing Email connection**(Unified Messaging email channels의 conversational email) 추가 가능.

- **Where:** 기본 + Unified Messaging은 Enterprise·Unlimited with Marketing Cloud Next Advanced Edition만.
- **When:** week of March 9, 2026.

### Improve Subagent Classification with HyperClassifier

default Agentforce Service agent·Employee agent template으로 새로 만든 에이전트가 subagent classification에 Salesforce-owned **HyperClassifier** model 사용. standard LLMs보다 speed·precision 우수(특히 complex/negative instructions). (별도 GA 표기 없음 — Enhancement)

- **When:** week of April 6, 2026.
- **How:** default template 에이전트는 자동 사용. Agent Script의 `model_config` property로 subagent block에서 model 커스터마이즈 가능(Canvas view의 Agent Router는 불가). `model_config` 제거 시 Setup의 Agentforce model option 선택으로 default.

```
# PDF verbatim — p.227 (line 1953–1959). 원문에서 "subagent"가 "subagen / t"로 줄바꿈 wrapping 됨(실제로는 한 단어).
start_agent agent_router:
    description: "Welcome the user and determine the appropriate topic/subagent based on user input"
    model_config:
        model: "model://sfdc_ai__DefaultEinsteinHyperClassifier"
```

### Let Agentforce Service Agent Take Actions with User Context in Enhanced Web Chat v2

credential-based user verification으로 Enhanced Web Chat v2 session의 AI agent가 user context로 action 수행(주문 조회·취소 등; 이전 Enhanced Web Chat v1만).

- **Where:** Enterprise, Performance, Unlimited, Developer.
- **When:** week of April 13, 2026.

### Build and Troubleshoot Agents Quickly with the Latest Builder Enhancements

Agentforce Builder의 새 **console** — agent performance 저해 error·warning 목록(syntax errors, unexpected values). Canvas view utility referencing, Script view autocomplete.

- **When:** week of April 6, 2026.
- **How:** console error/warning click → 해당 element/line 열림. Canvas utility: `@` → Actions → utility. Script autocomplete: `@` → arrow keys → Tab/Enter.

### Deploy Agentforce to Any Channel with Custom Connections (Developer)

secure metadata-based **custom connections**으로 비즈니스 채널에 Agentforce 배포. channel-tailored connection metadata로 multimedia 응답 구조화.

- **When:** week of May 4, 2026.
- **How:** Agent API로 통신 가능 확인 + channel 통합 external client app 생성 → **AiSurface, AiResponseFormat, GenAiPlannerBundle** metadata types 선언 package 생성(AiSurface + 최소 1개 AiResponseFormat) → GenAiPlannerBundle에 추가 → Salesforce CLI로 metadata 배포 → Agent API로 session 시작 테스트.

---

## 3. Agentforce — Beta

### Build Complex Agents Faster with the Latest Enhancements to Canvas View (Beta)

새 Builder의 Canvas view가 이전엔 Script view만 있던 기능 포함: action을 topic에 추가 시 자동 reasoning actions 추가, Variables page에서 변수 생성·관리, Topic Selector·reasoning actions filter, follow-up actions(action chain·topic transition), System Messages page(agent-level instructions). **"Filter from agent action" → "Include in agent context"** 로 rename(활성화 시 output이 conversation history·reasoning에 포함).

- **When:** week of January 5, 2026.

### Connect Agents to Enhanced Chat v2 in Agentforce Builder (Beta)

Agentforce Service agent에 **Enhanced Chat v2 connection** 추가 가능(connection's routing page에서 Enhanced Chat channels·deployments 생성/조회; 이전엔 Messaging이 유일 connection이었고 제거 불가).

- **When:** week of January 5, 2026.

### Create Employee Agents in the New Agentforce Builder (Beta)

새 Builder가 **Agentforce Employee agents** 지원(이전엔 Service agents·scratch만). default Agentforce Employee Agent template으로 prebuilt topics·actions.

- **When:** week of January 5, 2026.

### Build High-Quality Agents with Validation Enhancements in the New Agentforce Builder (Beta)

agent actions에 validation checks 추가, error messages 개선. action 저장 시 underlying flow·prompt template·reference action 누락 또는 input/output 이름·data type 이슈 알림. error 정보를 Canvas·Script view 모두 표시(상세는 Script view).

- **When:** week of January 5, 2026.

### Export Agentforce Session Trace Data (Beta) — Developer

**Agentforce Session Trace OTel API** — full session trace를 단일 unified JSON view로 추출 → observability tool/OTLP collector로 import. JSON output에 Agentforce agent interaction의 모든 step 포함: **turns, messages, LLM calls, actions, RAG retrievals, quality scores, feedback**. output format은 **OpenTelemetry (OTLP)** 사양 준수.

- **When:** April 10, 2026.
- **How:** Setup → Einstein Audit, Analytics, and Monitoring Setup → Agentforce Session Tracing + Audit and Feedback 켜기. OAuth 2.0(external client app, ECA)로 인증 → session ID로 REST endpoint에 API 실행 → Splunk, Datadog, New Relic, 또는 OTLP collector로 import.

### Orchestrate Other Agents (Beta) — Multi-Agent Orchestration for Agentforce

에이전트를 org 내 다른 specialized agents와 연결. connected subagents가 단일 unified contact 제공.

- **When:** week of May 4, 2026(일부 기능 후속 roll out — 예: custom variables 지원, NGA의 connected subagent trace 상세 unified trace view).
- **How:** Agent Builder → draft 에이전트(= orchestrator) 열기 → Explorer panel → + → Connect Agent as Subagent (Beta) → 1개 이상 에이전트 선택 → Add to Agent. orchestrator가 Agent Router 사용 시 routing logic 지정. Canvas view에서 각 connected subagent를 Actions Available for Reasoning에 수동 추가 → Instructions에서 `@`로 참조.

---

## 4. New and Changed Standard Agent Topics and Actions

> standard agent topics·actions·관련 prompt templates/flows의 availability는 edition·license에 따라 다를 수 있다.

### March '26
- **Updated Availability — Scheduling Agent:** Agentforce Studio에서 inbound·outbound conversations 모두 사용 가능. 단, further notice까지 legacy Agentforce Builder에서 신규 에이전트 구축 권장.

### February '26
- **New Topic — Marketing Cloud: Campaign Preview Refinement** (마케터가 campaign preview 정제)
  - **Refine Campaign Preview:** 특정 brief의 campaign preview steps를 user input 기반 정제·교체.
- **Updated Topic — Marketing Cloud: Campaign Planning** (briefs·previews·campaigns 생성/저장/분석, multi-channel email·SMS)
  - **Draft a Campaign Brief:** follow-up action 추가, Salesforce Files의 파일에서도 brief 생성 가능.
  - **Save Campaign Brief:** campaign 생성 follow-up action 추가.
  - **Draft a Campaign Preview:** campaign messages/steps(email·SMS) 시리즈 생성. action 이름 **"Create a Campaign from a Brief" → "Draft a Campaign Preview"** 로 변경.
  - **Save Campaign:** brief record ID로 draft campaign components 생성.
  - **Identify Business Unit (신규):** 현재 user의 Marketing Cloud BUs 목록 반환, session용 BU 선택.
  - **Generate Campaign Insights (신규):** campaign engagement·performance data 기반 insights 생성.

### January '26
- **Updated Topic — Appointment Management for Field Service** (Scheduling·Service Agent templates)
  - 신규 subflow: **Field Service: Send Confirmation to Customer**, **Field Service: Format Service Appointment Time for Display** (Cancel/Schedule Appointment flows에 추가).
  - 업데이트 actions(eligibility 검증): Cancel Appointment / Get Appointment Time Slots / Schedule Appointment / Update Appointment Times for Field Service.
  - 신규 action: **Get Current Time for Field Service** (relative date 'today'·'tomorrow' 해결).
- **New Topic — ESG Data Collection** (environmental·social·governance 정보 수집)
  - **Get Vehicle Asset Emission Source Data**, **Get Sustainability Stakeholder Data**, **Manage Sustainability Task Group**, **Get Sustainability Task Group Data**, **Create Sustainability Task Group**.
- **New Topic — FinServ Package Wealth Advisor Client Meeting Preparation (Managed Package)**
  - **FinServ Package Summarize Financial Details**, **FinServ Package Summarize Financial Goals**, **FinServ Package Summarize Portfolio Performance**.
- **New Topic — FinServ Package Wealth Advisor Client Post Meeting Follow Up (Managed Package)**
  - **FinServ Package Create Financial Goal**, **FinServ Package Create Life Event**, **FinServ Package Extract Financial Goals**, **FinServ Package Extract Life Events**, **FinServ Package Structure Financial Advisor Meeting Notes**.
- **New Topic — Manage Gift Commitments (Beta)** (donor의 gift commitments/recurring donations 관리)
  - **Agent Action: Close Gift Commitment**, **Agent Action: Manage Recurring Gift Commitment**.
- **New Action — Match Volunteers to Shifts:** time·location·qualification 요건 기반 open shifts에 적합 volunteers 찾기.
- **New Topic — Account Performance**
  - **Get Retail Execution Account Performance Data** (total revenue·min/max order values, top N%·bottom N% selling products), **Get Retail Execution Orders By Account**.
- **New Topic — Account Compliance**
  - **Get Retail Execution Visits By Account**, **Get Retail Execution Customer Tasks By Account**.
- **New Topic — Last Visit Summary**
  - **Get Retail Execution Customer Tasks By Account**, **Get Retail Execution Visits By Account**, **Get Retail Execution Orders By Visit**.
- **New Topic — Product Upsell** (recommendations·sales pitches·OOS analysis)
  - **Get Retail Execution Visits By Account**, **Get Retail Execution Orders By Account**.
- **New Topic — B2C Commerce Coupon Management** (cart에 coupon 적용·complex discounts)
  - 기존 **Get B2C User Access Token** + 신규 **Configure Your Agent to Apply Coupon to B2C Cart**.
- **New Action — Get Rule-Based Product Recommendations:** Product Catalog Management(PCM) configuration rules 기반 quote 추천 products. 최대 **5개** product IDs·names 반환.
- **New Topic — Billing Inquiries** (internal teams가 Agentforce Revenue Management Billing 정보 접근)
  - **Get Account Balance** (posted invoices·credits·debits·payments·refunds 요약 → net amount due), **Get Next Due Payment** (가장 이른 due date + total due), **Get Payment Plan Details** (installment schedule), **Get Latest Invoice and Document PDF** (최근 posted invoice + PDF download link).

---

## 5. Einstein Bots — Retirement

### Extend Your Use of Article Answers for Einstein Bots

Article Answers for Einstein Bots retirement이 **September 30, 2026**으로 변경(이전 February 28, 2026). retirement date까지 knowledge content 계속 제공. 이후 **Generative Knowledge Answers** 전환 권장.

- **Where:** Lightning Experience·Salesforce Classic — Enterprise, Performance, Unlimited, Developer (Setup은 Lightning Experience만).
- **When:** September 30, 2026 은퇴.

> ⚠️ 같은 챕터에 구 entry **"Article Answers for Einstein Bots Is Being Retired"** (February 28, 2026 은퇴 예정)도 공존한다. 최신값 **September 30, 2026** 이 정본이다(연장됨).

---

## 6. Einstein Development — Developer Preview

### Accelerate Custom Lightning Type Creation for Agentforce with the Lightning Types MCP Tool (Developer Preview)

**Lightning Types MCP(Model Context Protocol) tool**(Salesforce DX MCP Server) — custom Lightning types 생성·강화. LLMs로 **LightningTypeBundle** metadata files 생성(`schema.json`, `editor.json`, `renderer.json`) + custom LWC 응답 생성. **Agentforce Employee agents**(Lightning Experience)·**Agentforce Service agents**(Enhanced Chat v2) 지원. Prompt Builder structured outputs 정의도 가능.

- **Where:** Salesforce DX MCP Server (beta) 최신 버전.
- **Note:** developer preview — GA 아님(commands·parameters 변경/deprecation 가능, 운영 구현 금지).
- **When:** week of February 9, 2026.
- **How:** Salesforce DX MCP Server는 **Agentforce Vibes Extension**에 preconfigured. Agentforce에서 server 켜기 → 자연어 prompt로 상호작용.

---

## 7. Prompt Builder

### Ground Prompts with Live Web Data with Web Actions
**Web Action** in Prompt Builder — real-time web data를 prompt에 도입(외부 소스 실시간 정보, 출처 제어, citations 포함).
- **Where:** Enterprise, Performance, Unlimited with Einstein for Platform, 또는 Einstein/Agentforce for Sales/Service add-on, 또는 Agentforce Foundations.
- **When:** week of April 6, 2026.

### Pass Outputs Between Actions in Prompt Builder
action 간 data 전달로 dynamic workflow(prompt templates·flows·Apex·retrievers의 data로 downstream actions 구동). Performance Insights panel에서 각 action latency·token usage 조회.
- **When:** week of April 6, 2026.

### Use Prompt Templates as Actions in Prompt Builder
prompt templates를 action으로 추가(하나의 template에서 다른 것 invoke). 실행 시 referenced template 먼저 실행 후 response merge.
- **Where:** Enterprise, Performance, Unlimited with Einstein for Sales/Service/Platform add-on.
- **When:** week of April 6, 2026.

### Monitor Token Usage and Response Time in Prompt Builder
centralized **Performance Insights panel** — response time, token usage(input+output), masked values 조회. response time drill-down(data retrieval·prompt hydration·summarization·masking·response generation).
- **When:** week of March 9, 2026.
- **How:** Prompt Builder → Preview 실행 → Performance Insights panel.

### Add New Inputs to Existing Prompt Templates
기존 prompt template에 new inputs 추가(object·free text·data model objects via Resources panel).
- **Where:** Enterprise, Performance, Unlimited with Einstein for Sales/Platform/Service add-on.
- **When:** week of February 23, 2026.

### Manage Actions and Inputs in the Resources Panel
enhanced **Resources panel** — actions·inputs 관리 간소화(flows·Apex·retrievers 추가·구성, action description·API name·associated inputs metadata 조회).
- **When:** week of February 20, 2026.

### Structure Prompt Template Output with Custom Lightning Types
custom Lightning types로 structured·predictable prompt responses(output fields·data types 제어; 이전엔 output schema 없는 JSON은 prompt instructions에만 의존).
- **Where:** Enterprise, Performance, Unlimited with Einstein for Platform, 또는 Einstein/Agentforce add-ons.
- **When:** week of January 5, 2026. **Who:** Prompt Template Manager permission set.

### Improved Prompt Template Batch Processing with Supported Models in Flow (Limits)
일부 model providers가 native batch processing 지원 → job당 max requests 증가. **Flow의 native batch processing 모델은 하루 50,000 items 한도.**
- native batch processing 지원 모델: **GPT 4.1, GPT 4.1 Mini, GPT 4 Omni, GPT 4 Omni Mini, GPT 5, GPT 5 Mini, OpenAI GPT 4 Omni Mini, Bedrock Claude Haiku 4.5, Bedrock Claude Sonnet 4.5**.
- **When:** week of February 2, 2026.

### Use Anthropic Models to Process More Data with Native Provider Batch Processing (Limits)
**Anthropic Claude Haiku 4.5·Anthropic Claude Sonnet 4.5**에 Apex·Flow로 더 많은 batch. **native provider batch processing 모델은 Apex에서 job당 10,000 items 한도.**
- **When:** week of February 2, 2026. **Who:** Data 360·Einstein permission sets.

### Prompt Performance Metrics Is Scheduled for Retirement (Retirement)
Prompt Performance Metrics가 **Summer '26** 은퇴 예정. (Gen AI Audit and Feedback 활성화 시 Calculated Insights 자동 활성화 → 미사용에도 credit 소비 영향이 있었음)
- **Where:** Enterprise, Performance, Unlimited with Einstein for Sales/Service/Platform add-on.

---

## 8. Supported Models

> 대부분 Beta 모델 entry는 동일 패턴: beta service, Where(Enterprise/Performance/Unlimited with Foundations or Agentforce 1), Who(Data 360·Einstein permission sets), How(Einstein Setup page에서 beta generative AI models 켜기).

### GA 모델
- **GPT 5.1, GPT 5.2, Claude Opus 4.5** — GA (week of March 23, 2026). 위 §1 참조.
- **Claude Sonnet 4.6** — GA (week of April 13, 2026). 위 §1 참조.
- **GPT 5.4** — GA (week of April 27, 2026). geo-aware(OpenAI/Azure OpenAI). 위 §1 참조.

### Beta 모델 (신규)
| 모델 | When |
|---|---|
| **NVIDIA Nemotron 3 Nano 30B** (Beta) | week of February 16, 2026 |
| **Gemini 3.1 Pro** (Beta) | week of March 23, 2026 |
| **Gemini 3.1 Flash Lite** (Beta) | week of March 30, 2026 |
| **GPT 5.4** (Beta) — geo-aware(OpenAI/Azure OpenAI) | week of April 6, 2026 |
| **Claude Opus 4.6** (Beta) | week of April 27, 2026 |
| **Claude Opus 4.7** (Beta) | week of April 27, 2026 |
| **GPT 5.4 Mini** (Beta) — geo-aware | week of May 4, 2026 |
| **GPT 5.5** (Beta) — geo-aware | week of May 4, 2026 |

> GPT 5.4는 같은 챕터에서 Beta(week of April 6, 2026)와 GA(week of April 27, 2026) 두 entry로 등장한다.

### Reroute / Deprecation
| 모델 | 대체 | reroute date |
|---|---|---|
| **Claude 3.7 Sonnet** (Amazon Bedrock, deprecated) | → **Claude Sonnet 4.5** | February 26, 2026 |
| **Claude 3 Haiku** (Amazon Bedrock, deprecated) | → **Claude Haiku 4.5** | February 26, 2026 |
| **Gemini 2.0 Flash** (Vertex AI, deprecated) | → **Gemini 2.5 Flash** | February 20, 2026 |
| **Gemini 2.0 Flash Lite** (Vertex AI, deprecated) | → **Gemini 2.5 Flash Lite** | February 20, 2026 |

### Beta Retirement
- **Gemini 3 Pro (Beta) Is Retiring:** Google preview model. Beta이고 GA 안 될 예정이라 자동 reroute 없이 은퇴. 권장 replacement **Gemini 3.1 Pro (Beta)**. 은퇴 시작 week of March 23, 2026 → **week of April 23, 2026부터 Gemini 3 Pro (Beta) 요청은 error 반환.**

### 기타
- **Einstein Studio Is Now AI Models (용어 변경):** **Einstein Studio → AI Models**(Data 360). transition 중 신/구 용어 혼재. (week of April 20, 2026). Data 360 → AI Models.
- **Understand the Tokens Per Minute Model Limit (Limits):** service protection을 위한 신규 **tokens per minute(TPM)** limit(org당, 모델별). 1분 input+output tokens 합산 측정, 초과 시 error. 모델별 limit은 Large Language Model Limits(Salesforce Help) 참조. (week of April 20, 2026)

---

## 9. 챕터 인트로 요약에만 등장 (본문 상세 entry 없음 — cross-reference)

아래 두 항목은 Agentforce Platform 챕터의 **인트로 요약 + 월별 매트릭스에만** 등장하며, 이 챕터 본문에는 Where/When/How 풀 entry가 **없다**. 상세 내용은 다른 챕터(Data Cloud / Tableau Next 등)에 위치한다.

### Build and Scale AI Workflows with Agentforce Grid (Generally Available)
> "Run cumulative workflows where every column advances your project from raw insight to completed work. New in this release are a Billing Calculator … and run conditions … Also included are an increased scale to 1,000 rows in a worksheet and the ability to improve LLM responses with data from the web." (PDF 인트로 요약, p.190)

- GA 표기됨. 월별 매트릭스 Platform Area = Agentforce Grid, week of April 6, 2026.
- ⚠️ Agentforce Platform 챕터 본문 상세 entry 없음 (cross-reference). 상세는 별도 챕터 참조.

### Build on Standard DMOs for Audit and Feedback Analytics
> "Build analytics and reporting capabilities on new standard data model objects (DMOs) … across Salesforce products like Tableau Next. Continue to use your existing reports, dashboards, and queries built on custom DMOs." (PDF 인트로 요약, p.190)

- 등급 표기 없음(기능 추가). 월별 매트릭스 Platform Area = GovCloud Support, week of April 13, 2026.
- ⚠️ 본문 상세 entry 없음 (cross-reference).

> 참고 — **SOAP API login() Retirement (Release Update):** Summer '27에 SOAP API login() call(SOAP API versions 31.0–64.0) 미지원/미제공 예정. 이 항목은 Agentforce Platform 챕터 표지 페이지(p.189) 상단에 1줄로 등장하나 Agentforce 전용이 아닌 Release Update 성격이다.

---

## 관련 노트

- [[Spring '26]] — 허브
- [[Spring '26/index]] — 폴더 인덱스
- [[Release MOC]]
- [[Spring '26/Development]] — Apex·LWC·Flow 개발자 변경
- [[Spring '26/Platform]] — Setup·Security·Data Cloud 등 플랫폼 변경
- [[Spring '26/Clouds]] — Sales·Service·기타 Cloud 변경
