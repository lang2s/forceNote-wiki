---
tags: [release, winter_25, agentforce, einstein, ai]
api_version: v62.0
release_date: 2024-10
created: 2026-06-16
source: salesforce_winter25_release_notes.pdf (Salesforce Winter '25 Release Notes, Tier 2)
aliases: [Winter '25 Agentforce, 윈터25 에이전트포스, Einstein, Einstein Copilot, Agent Studio, Prompt Builder, AI v62, 윈터25 AI]
---

# Winter '25 — Agentforce / Einstein

> Winter '25 (API v62.0)의 Agentforce·Einstein 영역 전수 기록 — Agentforce 플랫폼(에이전트·topic·action·analytics), Einstein(Bots·Data Library·Trust Layer·Prompt Builder·Models API), 지원 LLM 모델, 그리고 다른 cloud 섹션에 분산된 Agentforce 항목(Developers·Sales·Service·Commerce·Field Service·Marketing). **리브랜드 정확도: "Einstein Copilot for Salesforce" agent type이 "Agentforce"로 리네임(기능 변화 없음)되었고 "Einstein Copilot" 명칭은 본 릴리즈에서 공존한다. "Einstein Copilot Studio"는 "Agent Studio"로 리네임("Agentforce Studio" 아님). Prompt Builder 자체가 GA로 전환된 것은 아니다.**

---

## 개요

이 노트는 Winter '25 릴리즈 노트의 **Agentforce·Einstein** 항목을 전수 전사한 spoke다. 허브 [[Winter '25]]에서 진입하며, 형제 spoke [[Winter '25/Development]]와 함께 Winter '25을 구성한다. Sales/Service/Commerce/Field Service 등 cloud 제품별 Einstein/AI 기능은 형제 spoke [[Winter '25/Clouds]]에서 다룬다.

> **리브랜드 정확도 (PDF 인용 근거):**
>
> - PDF 섹션 제목: **"Einstein Copilot for Salesforce is Now Agentforce"** — *"As we grow our team of Agentforce agents, we've renamed the **Einstein Copilot for Salesforce** agent type to **Agentforce** with no changes in functionality… In Setup, you'll see **Agentforce** or **Agentforce (Default)** for the agent name and type."* (When: **2025년 1월**부터). 즉 기능 변화 없는 명칭 변경이다.
> - **"Einstein Copilot Studio is now Agent Studio"** / *"Einstein Copilot Studio Setup pages have been renamed to Agent Studio. Start your Quick Find searches with Agent instead of Copilot."* / *"The Copilot Builder is now the Agent Builder."* — 매핑은 **Einstein Copilot Studio → Agent Studio**다. "Agentforce Studio"라는 문자열은 PDF에 등장하지 않는다.
> - 문서 전반에 "Einstein Copilot" 브랜드명이 여전히 다수의 feature 이름에 등장한다(예: "Einstein Copilot: Summarize Scheduling Issues for Field Service", "Einstein Copilot for Salesforce or Agentforce Service Agent (ASA)"). Agentforce (Default) = 리네임된 Einstein Copilot for Salesforce agent type이며, 두 명칭은 본 릴리즈에서 공존한다.
> - **Prompt Builder 자체는 Winter '25에 GA로 전환되지 않았다.** GA는 feature 단위로만 존재한다: "Einstein Service Replies in Prompt Builder"(generally available, 언어 목록 포함) 및 "Data Graphs in Prompt Builder"(롤아웃 — 'generally available' 라벨 없음).

### 명칭 매핑 (PDF 근거)

| 이전 명칭 (Einstein Copilot 계열) | Winter '25 명칭 | 근거 |
|---|---|---|
| Einstein Copilot for Salesforce (agent type) | **Agentforce** / Agentforce (Default) | 기능 변화 없는 리네임, Setup 표시명 |
| Einstein Copilot Studio | **Agent Studio** | "Einstein Copilot Studio is now Agent Studio" |
| Copilot Builder | **Agent Builder** | "The Copilot Builder is now the Agent Builder" |
| Copilot topics / actions | **agent topics / actions** | "Introducing the Agentforce Platform" |

> 주의: "Einstein Copilot" 브랜드명은 본 릴리즈의 많은 feature 이름에 그대로 남아 있다. Agentforce와 Einstein Copilot은 **공존**한다.

---

## Agentforce (Agents)

> Einstein Platform / Agentforce 전체 항목 (PDF lines 15118–16356).

### Agentforce 플랫폼

| Feature | Status | Where / When | Description |
|---|---|---|---|
| **Einstein Copilot for Salesforce is Now Agentforce** | GA (rebrand) | LEX, Salesforce mobile, Field Service mobile, Sales Cloud Everywhere; Ent, Perf, Unl, Dev + Einstein for Sales/Service/Platform add-on. **2025년 1월부터** | Einstein Copilot for Salesforce agent type을 Agentforce로 리네임. Setup: "Agentforce" 또는 "Agentforce (Default)". |
| **Build, Test, and Troubleshoot Agents More Easily with Agent Versions** | GA | LEX Ent, Perf, Unl, Dev (추가 비용). **2025년 1월 초** | agent당 최대 **20개 버전**. Agentforce (Default) 타입은 active version 하나만. Save As New Version. |
| **Get More Accurate Agent Session Previews with Preview Conditions** | GA | Einstein Copilot for Salesforce: LEX Ent/Perf/Unl. ASA: LEX Perf/Unl/Dev. **2024년 12월 초** | Einstein Copilot for Salesforce 또는 Agentforce Service Agent (ASA)를 테스트할 대화 컨텍스트 지정. |
| **Streamline Business Operations with Agentforce Agents** | **GA** | LEX Ent, Perf, Unl + Einstein for Sales/Service/Platform add-on. **2024년 10월 말** | 사전 구축 agent type: **Service Agent**, **SDR Agent**, **Sales Coach**. New Agent 버튼. |
| **Customize Your Agent's Behavior with Standard Topic Editing** | GA | LEX Ent, Perf, Unl + add-on. 2024년 10월 말 | standard topic의 버전 생성. |
| **Evaluate Agent Interaction with Utterance Analysis** | GA | LEX, mobile 앱, Sales Cloud Everywhere; Ent, Perf, Unl + add-on. **2024-10-23** | 사용자 입력을 리포트로 수집; 클러스터/카테고리화. |
| **Check Performance with Agent Analytics Built on Data Cloud** | GA | 위와 동일; **2024-10-23** | Agent Analytics가 Data Cloud 리포트/대시보드 사용; Dashboard 탭, Copilot for Salesforce Apps 폴더로 이동. |
| **Find Agent Analytics In the Dashboards Tab** | GA | 위와 동일; 2024년 10월 | 대시보드가 Copilot for Salesforce Apps 폴더로 이동. |
| **Handle More Use Cases More Consistently with Agent Topics** | GA | LEX, mobile, Sales Cloud Everywhere; Ent, Perf, Unl + add-on. **2024-08-26** 주부터 롤링 | **Topic** = 관련 instruction+action을 가진 job. 기존 action용 Migration Default Topic. 신규 standard topic: **General CRM**, **Single Record Summary**. agent가 모든 planner call에 **OpenAI GPT-4o** 사용(이전 GPT-4). **Einstein Trust Layer의 data masking이 비활성화**되어 agent 성능/정확도 개선(전송 중 PII는 여전히 보호, zero-data retention). |
| **Introducing the Agentforce Platform** | GA | LEX, mobile, Sales Cloud Everywhere; Ent, Perf, Unl + add-on. **2024-09-02** 주 | **Einstein Copilot Studio is now Agent Studio.** Copilot Builder → Agent Builder. Copilot topics/actions → agent topics/actions. |
| **Enhance AI Responses by Customizing the Data Used by the Answer Questions with Knowledge Action** | GA | LEX Ent, Perf, Unl + add-on. 2024년 10월 말. Einstein Copilot for Salesforce PSL 사용 | Einstein Data Library로 knowledge 레코드 필터 또는 파일 업로드; Prompt Builder에서 Answer Questions with Knowledge 템플릿 커스터마이즈. |
| **Configure Conversation Recommendations** | GA | LEX, mobile, Sales Cloud Everywhere; Ent, Perf, Unl + add-on. 2024년 11월 | topic에 추가하여 제안 생성. |

### New and Changed Standard Agent Topics and Actions

> PDF lines 15585–15693. 월별 전수.

- **2025년 1월:** Updated Topic — Post-Work Summary for Field Service (GA), Update Record action 사용.
- **2024년 12월:** New Action — Update Record (General CRM topic, 기본 Agentforce agent); New Action — Extract Fields and Values from User Input (General CRM topic, Update Record로 feed).
- **2024년 11월:**
  - New Topic — Account Management (ASA): Update Customer Contact, Reset Password.
  - New Topic — Case Management (ASA): Create Case, Get All Cases for Contact, Identify Customer By Email, Get Case By Case Number, Add Case Comment.
  - New Topic — Delivery Issues (ASA): Get Delivery Time Slots, Get Orders By Contact, Finalize New Delivery Time.
  - New Topic — Order Inquiries (ASA): Get Order by Order Number, Get Orders By Contact, Cancel Order.
  - New Topic — Reservation Management (ASA): Finalize Reservation, Get Reservation Time Slots.
- **2024년 10월:**
  - Service Agent: Escalation; Service Agent: General FAQ (Answer Questions with Knowledge).
  - Sales Coach Agent: Opportunity Coaching (4개 action: Give Feedback on Qualification / Needs Analysis / Proposal / Negotiation and Review Stage); Sales Coach Agent: Proposal/Pricing Quote Role-Play; Sales Coach Agent: Negotiation/Review Role-Play.
  - SDR Send Outreach (Draft Initial Outreach Email, Draft Nudge Email, Schedule Email); SDR Respond to Prospect (Draft Meeting Request Email, Draft Generic Reply Email, Schedule Email); SDR Manage Opt-Out (Opt-Out Lead).
  - Post-Work Summary for Field Service (Beta) (Identify Record by Name, Summarize Record, Refine Post-Work Summary for Field Service); Updated Action — Answer Questions with Knowledge.
  - Commerce Promotions (Create Promotions, Get Commerce Promotion Templates); Insights Business Objectives (Get Commerce Business Objectives, Format Commerce Insights).
- **2024년 9월:**
  - General CRM (Get Record Details, Get Activities Timeline, Get Activity Details); Single Record Summary; Close Deals; Communicate with Customers; Conversation Explorer.
  - Field Service Dispatcher Actions (Create Appointment List Filters, Summarize Scheduling Issues); Forecast Sales Revenue; Manage Deals; Prospect.
  - Sales actions: Add Record to Cadence, Create a Label, Create a To-Do, Find Contact Interactions, Find Past Collaborators, Get Product Pricing, Identify Contact Role, Identify Key Contacts, Label a Record, Log a Call, Prioritize Opportunities, Review My Day.
  - FSC Beta actions: Get Financial Accounts Information for an Account, Get Fee Transactions from a Financial Account, Create a Fee Reversal Case.

### Agentforce for Developers (Platform Dev Tools)

> PDF p.288.

- **Use Generative AI For Salesforce Development with Agentforce for Developers** (**GA**) — LEX Ent, Perf, Unl, Partner Developer, Dev edition. AI 기반 VS Code 확장(VS Code desktop + Code Builder), CodeGen + xGen-Code 커스텀 AI 모델 기반. 기본 활성화. **EU Operating Zone에서는 사용 불가.**
- **Agentforce for Developers Documentation Has a New Look** — developer.salesforce.com의 신규 UI.
- Metadata: **`AgentforceForDevelopersSettings`** metadata type, 필드 `agentforceForDevelopersOptOut`.

### Agentforce for Sales (Sales 섹션)

> PDF p.707–714.

- **Scale Your Sales Funnel with Agentforce SDR** (GA) — LEX Ent, Perf, Unl + **Agentforce SDR add-on**. 2024년 10월 말. 필요 Sales Cloud 기능: Sales Engagement, Einstein Activity Capture, Einstein Copilot, Einstein Generative AI, Salesforce Inbox, Automated Actions, Data Cloud. Agent Builder에서 text/HTML/PDF 업로드.
- **Coach Sales Reps at Scale with Agentforce Sales Coach** (GA) — LEX Ent, Perf, Unl + **Agentforce Sales Coach add-on**. 2024년 10월 말. Opportunity 페이지의 신규 Agentforce Sales Coach Lightning page 컴포넌트. Topic: Opportunity Coaching, Negotiation/Review Role-Play, Proposal/Pricing Quote Role-Play. 신규 prompt template type: **Sales Pitch Feedback**.
- **Enhance Agentforce Sales Coach Responses with a Data Library** (GA) — LEX Ent, Perf, Unl + Agentforce Sales Coach add-on. 2024-12-17. Agent Builder → Select Data step.

### Agentforce Service Agent (Service 섹션)

> PDF p.840–843.

- **Automate Common Contact Center Interactions with Agentforce Service Agents** (**GA** — "Agentforce Service Agent is generally available") — 모든 enhanced Messaging 채널. 2024년 10월 말. **Manage Agentforce Service Agents** 권한 집합. Agents Setup → New Agent → Agentforce Service Agent Type → enhanced messaging 채널 연결.
- **Ensure Sequential Conversations in Messaging for Web** (GA) — Messaging for Web 코드에 `enableUserInputForConversationWithBot` snippet 설정 추가.
- **Monitor Agentforce Service Agent Conversation Consumption with Digital Wallet** (GA) — Service Cloud Usage Billing, LEX Ent + Unl. 2024년 10월 말. Conversation add-on. 빌링은 **messaging-user가 시작한 ASA 대화에만** 적용(outbound/business-initiated 제외).
- **Test and Improve your Service Agents with an Improved Preview Experience** (GA) — preview에 Agent User context; 테스트용 context 변수 설정. 2024년 12월.

### Agentforce Merchant Agent (Commerce 섹션)

> PDF p.183–184.

- **Power Up Productivity with Agentforce Merchant Agent** (GA) — B2B + D2C Commerce; Ent, Unl, Dev + **Einstein Platform add-on**. 2024년 10월 말. Einstein Copilot for Salesforce user 권한 사용; **EinsteinGPTCommerceAddOn** 라이선스. Topic: Commerce Promotions, Insights Business Objectives. 예시 (PDF verbatim): "Create a promotion for the Testa Rossa coffee machine, where the discount is 25% on all orders valid until October 31, 2024."; "Show me the insights for the average order value for this web store."

### Field Service Einstein / Agentforce (Field Service 섹션)

> PDF p.393–394.

- **Generate Post-Work Summaries On the Go** (**GA**) — LEX Ent, Perf, Unl + **Einstein for Field Service** add-on + Einstein 1 Field Service edition. Field Service mobile (Android/iOS). **Post-Work Summary for Field Service** agent topic + **Refine Post-Work Summary for Field Service** agent action. 권한: Use Agentforce Default Agent, Access Field Service Copilot Agent Topics and Actions, Execute Prompt Templates.
- **Get a Daily Summary of Service Appointments that Require Immediate Attention** (Einstein Copilot Field Service action) — Summarize Scheduling Issues, 카테고리를 appointment-list 필터로 변환.
- **Find Service Appointments Easily by Creating Search Filters in the Appointment List** — Create Appointment List Filter action (자연어).
- **Uncover Top Cancellation Reasons Easily** (**Beta**) — Summarize Service Appointment Notes.

### Marketing distributed Agentforce (Marketing 섹션)

- **Create On-Brand Campaigns with Agentforce and Einstein** — draft campaign brief, messaging, 브랜드 콘텐츠 생성.
- **Analyze Campaign Performance with Agentforce and Einstein.**

---

## Einstein (Copilot · Prompt Builder · Generative)

### Einstein Bots

> PDF lines 15694–15850.

- **Connect Enhanced Bots to LINE Messaging Channels** (**GA**)
- **Get to Know Customers Faster with Improved Intent Recognition** (GA)
- **Input Recommender (Beta) Is Being Retired** — 폐기 Spring '25
- **Reach More Customers with Multi-Language Support for Messaging Components** (**GA**)
- **Run Flows in Bot User Context (Release Update)** — 최초 Summer '23, **Winter '25 강제**
- **Save Time with New Messaging Components for Enhanced Bots** (**GA**) — Authentication, Custom, Form, Payment 컴포넌트
- **Support More Customers with New Languages** (**GA**) — Hebrew, Romanian, Danish, Korean, Swedish
- **Translate Dialogs Easily** (**GA**)
- **Understand Customers More Accurately with Strict Recognition** (GA)

### Einstein Data Library

> PDF lines 15851–15890.

- **Ground Generative AI Responses on Your File Uploads** (GA) — text/HTML/PDF; Data Cloud 필요; Knowledge 또는 file upload 중 하나(둘 다 아님).
- **Changed Access to Existing Einstein Data Libraries** — 2024년 10월 말, 모두 active Data Cloud 설정 필요.

### Einstein Data Prism

> PDF lines 15896–15920.

- **Get Optimized Einstein Responses with Einstein Data Prism** (GA) — LLM 자동 grounding.

### Einstein Trust Layer

> PDF lines 15921–15998.

| Feature | Status | Description |
|---|---|---|
| **Choose Where to Store Generative AI Audit and Feedback Data** | GA | LEX Ent/Perf/Unl + add-on. 2024-10-07 주. 특정 data space로 분리. Setup→Einstein Feedback. |
| **Use Salesforce Data Classification for Field-Based LLM Data Masking** | GA | LEX Ent/Perf/Unl + add-on. 2024-11-11 주. 필드 기반 마스킹(Platform Shield Encryption / data classification metadata) + 기존 패턴 기반 마스킹. |
| **Verify AI-Generated Responses with Citations** | GA | LEX Ent/Perf/Unl + add-on. 2024-12-02. citation이 원본 소스 링크. |

### Prompt Builder

> PDF lines 15999–16128.
>
> **정확도 강조:** Prompt Builder 자체가 Winter '25에 GA로 전환되었다는 진술은 PDF에 없다. 아래는 모두 feature 단위 항목이며, 전체 "Prompt Builder GA" 라벨은 존재하지 않는다. 또한 "Data Graphs in Prompt Builder" 항목은 'generally available' 라벨이 붙어 있지 않다.

- **Get Prompt Performance Metrics with User Feedback** (**Beta**) — 샌드박스 2024-10-15, 프로덕션 2024-10-17.
- **Improve Prompt Grounding with Dynamic Retrievers** — 2024-10-24.
- **Repurpose a Standard Prompt Template** (prompt template override) — 2024-10-24.
- **Elevate Your Prompt Responses Using Data Graphs in Prompt Builder** — 샌드박스 2024-11-12, 프로덕션 2024-11-14. (롤아웃; 'generally available' 라벨 없음.)
- **Configure Prompt Templates in Multiple Languages** — 2024-11-13. response language용 Connect API.
- **Shape How Agents Respond to User's Questions Using the Answer Questions with Knowledge Prompt Template** — 2024년 11월.

> 참고: "Einstein Service Replies in Prompt Builder"는 Service 섹션에서 *generally available*로 명시되며, 지원 언어는 Dutch, English, French, German, Italian, Japanese, Portuguese 등이다. 이는 Service Replies 기능의 GA이며 Prompt Builder 자체의 GA가 아니다.

### Retrieval Augmented Generation (RAG) in Data Cloud

> PDF line 16129. 교차 참조.

- **Improve Search Accuracy with Hybrid Search** (GA)
- **Bring Unstructured Data into Data Cloud with MuleSoft Direct** (Beta)
- **Transcribe and Index Audio and Video Files** (GA)

### Generative Canvas

> PDF line 16140.

- **Get the Information You Need with One Question to Generative Canvas** (**Preview**) — LEX Starter + Pro Suite. **2025년 1월.** Einstein + LLM 기반.

---

## 지원 모델 (LLMs)

> Other Changes — Models API / LLMs (PDF lines 16164–16356). depth-critical.

| Feature | Status | Models / Description |
|---|---|---|
| **Explore More Anthropic, Azure, and OpenAI Models on the Einstein Platform** | GA | LEX Ent/Perf/Unl + add-on. 추가: **Azure OpenAI GPT-4o** (Prompt Builder + Model Builder; geo-aware routing + BYOLLM; 2024-08-14 제공), **OpenAI GPT-4o mini** (Prompt Builder + Model Builder; 2024-08-28 제공), **Anthropic Claude 3.5 Sonnet** (Model Builder, BYOLLM 전용; 2024-08-08 제공). |
| **Monitor Einstein Request Consumption in Near-Real Time with Digital Wallet** | GA | LEX Ent + Unl. 2024-10-10. Einstein Requests 카드; View Consumption 권한. |
| **Seamlessly Connect Customer and Partner LLMs with the Models API and LLM Open Connector** | **GA** | **Models API** = Salesforce 파트너(**Anthropic, Google, OpenAI**)의 LLM에 연결하는 Apex 클래스 + REST 엔드포인트. Einstein Studio에서 Salesforce-enabled 모델. **LLM Open Connector** = Einstein Studio에서 BYOLLM을 위한 신규 옵션. |
| **Try Out New Recipes for the LLM Open Connector** | GA | Einstein Platform Cookbook 사이트. Hugging Face(Serverless Inference API + Heroku 배포) + Mulesoft(Anypoint Studio / Anypoint Code Builder)를 통한 recipe. |

> Agents가 모든 planner call에 사용하는 기본 모델은 **OpenAI GPT-4o**다(이전 GPT-4). ("Handle More Use Cases More Consistently with Agent Topics" 항목 참조.)

```apex
// 구조 예시 — 실제 동작 코드 아님 (Models API는 Apex 클래스 + REST 엔드포인트로 파트너 LLM 연결)
// 실제 클래스/시그니처는 Winter '25 릴리즈 노트 및 Apex Models API 레퍼런스를 확인할 것.
// 지원 모델: Azure OpenAI GPT-4o, OpenAI GPT-4o mini, Anthropic Claude 3.5 Sonnet (BYOLLM)
```

### Einstein Features cross-cloud 인덱스 (요약)

> PDF의 "Cloud / Features / Release Note" 매트릭스(lines 14835–15116)를 월별로 전사. 각 항목의 상세는 해당 cloud 섹션에 있다.

- **2025년 1월:** Field Service — Post-Work Summary (GA, "Generate Post-Work Summaries On the Go"); Service — Service Replies ("Streamline Agent Handling Time").
- **2024년 12월:** Service — Agentforce Service Agent ("Test and Improve your Service Agents with an Improved Preview Experience"); Service — Service Replies ("Einstein Reply Recommendations").
- **2024년 11월:** Loyalty Management — Loyalty Program/Promotion Summary ("Einstein for Loyalty Management"); Public Sector Solutions — Application History Overview, Application Version Comparison, License Compliance Summary, Prior Violations Report ("Einstein Generative AI for Public Sector Solutions").
- **2024년 10월:** Commerce — Agentforce Merchant Agent ("Power Up Productivity with Agentforce Merchant Agent"); Field Service — Post-Work Summary (Beta); Sales — Agentforce SDR ("Scale Your Sales Funnel with Agentforce SDR"); Sales — Agentforce Sales Coach ("Coach Sales Reps at Scale"); Service — Agentforce Service Agent ("Automate Common Contact Center Interactions"); Service — Agentforce Service Agent ("Monitor… Conversation Consumption with Digital Wallet"); Service — Reply Recommendations, Work Summaries ("Einstein for Service").
- **2024년 9월:** Analytics — Lightning Report Formula Generation; Communications — Einstein Quick Quote; Education — Data Cloud for Education/Alumni Metrics, Einstein Advising Summary for Advisors, Einstein Mentoring Summaries; Field Service — Einstein Copilot: Summarize Scheduling Issues / Create Appointment List Filter / Summarize Service Appointment Notes; Financial Services — Einstein Summaries for Business Relationship Plan; Health — Einstein Embedded AI: Summarization and Email Generation for Healthcare; Industries Net Zero — ESG disclosure / Scope 3 Emissions; Marketing — Einstein Copilot: Create Briefs and Campaigns; Nonprofit — Einstein Program Benefits/Notes/Board Summary, Einstein Fundraising Award Summary (all beta); Platform — Agentforce for Developers (GA); Sales — Einstein Coach, Einstein Activity Capture/Automated Contacts/Sales Summaries (beta), 13 Einstein Copilot sales actions; Service — Einstein Article Recommendations, Case Classification, Conversation Mining, Knowledge Creation, Work Summaries.

---

## 관련 노트

- [[Winter '25]] — Winter '25 허브
- [[Winter '25/Development]] — Apex·LWC·API 개발자 항목 형제 spoke (Agentforce for Developers metadata 포함)
- [[Winter '25/Platform]] — Platform 형제 spoke (Flow Einstein·Security Einstein 항목 포함)
- [[Winter '25/Clouds]] — 클라우드 제품별 Einstein/AI 기능(Sales/Service/Commerce/Field Service)
