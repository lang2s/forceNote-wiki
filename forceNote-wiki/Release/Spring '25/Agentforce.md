---
tags: [release, spring_25, agentforce, einstein, ai]
api_version: v63.0
release_date: 2025-02
created: 2026-06-16
source: salesforce_spring25_release_notes.pdf (Salesforce Spring '25 Release Notes, Tier 2)
aliases: [Spring '25 Agentforce, 스프링25 에이전트포스, Einstein for Flow GA, Einstein Flow Formula Builder, Flow Description 생성, Agentforce 패키징, Agentforce DX, Einstein Trust Layer]
---

# Spring '25 — Agentforce / Einstein

> Einstein for Flow·Flow Formula Builder GA, Einstein Flow Description 자동 생성, Agentforce 액션/토픽/프롬프트 템플릿의 1GP·2GP 패키징 지원, Agentforce DX(Beta) 프로코드 도구, 그리고 Einstein Copilot → Agentforce 리브랜딩과 다국어·Trust Layer·신규 LLM(Gemini 2.0·Claude 3.7) 대거 추가.

---

## 개요

Spring '25(API v63.0)의 Agentforce & Einstein 변경은 **월 단위로 릴리즈**되며(January~May '25 월간 릴리즈에 분산), **January 월간 릴리즈에 포함된 기능은 Spring '25가 조직에 롤아웃될 때 일반 제공**된다.

> PDF 원문(@12764–12765): *"Features included in the January monthly release generally become available when Spring '25 rolls out to your org."*

PDF는 Agentforce & Einstein를 두 묶음으로 구분한다.

- **Agentforce & Einstein Features** — 각 Salesforce 클라우드(Sales/Service/Field Service/Commerce/Industries 등)에 임베드되는 기능. 클라우드별 산업 에이전트 템플릿은 → [[Spring '25/Clouds]]·[[Spring '25/Industries]] 으로 분리한다.
- **Agentforce & Einstein Platform** — 생성형/예측형 AI의 기능·보안·성능 개선. **본 노트의 주 대상**(플랫폼·개발자 관점).

> 상위 허브: [[Spring '25]] / 개발자 spoke: [[Spring '25/Development]] / Flow 본체: [[Spring '25/Platform]]

```text
// PDF 원문 인용 — 구조 충족용 (코드 자체는 Development spoke에 위치)
"Agentforce & Einstein features are released as often as monthly...
 Features included in the January monthly release generally become
 available when Spring '25 rolls out to your org."
  — Salesforce Spring '25 Release Notes, Agentforce & Einstein opener (@12763–12765)
```

이 노트는 다음을 다룬다: **Einstein for Flow / Flow Formula Builder / Flow Description 생성(GA)**, **Agentforce 패키징(1GP/2GP)**, **Agentforce DX(Beta) 연계**, **Agentforce 플랫폼 기능(에이전트 버전·언어·보안·테스트·개발)**, **Einstein Bots·Trust Layer·Prompt Builder·Generative Canvas**, **신규/리라우트 LLM 모델**.

> [!note] PDF 표기 그대로 보존한 항목
> 일부 항목은 PDF에 연도 오타로 보이는 표기가 있다. 본 노트는 **원문 그대로 옮기고 추정만 병기**한다(임의 정정 금지).
> - Agentforce Data Library 리네이밍: PDF "available starting January **2024**" (@14387) — 맥락상 2025로 추정.
> - Use More Languages with Prompt Builder: PDF "available on February 11, **2024**" (@14987) — 맥락상 2025로 추정.

---

## Einstein for Flow (GA)

자연어로 Flow를 더 빠르고 정확하게 생성한다. Flow 본체 변경은 → [[Spring '25/Platform]].

- **Get Help Building Flows Faster and More Accurately with Einstein (Generally Available)** — Flow Creation with Einstein. January '25 월간 릴리즈로 Spring '25에 GA.
- **Generate a Detailed Description of a Flow with Einstein** (아래 별도 섹션 참조).
- **Track Generated Content Quality and Feedback in Flow Builder** (@15075–15079) — toxicity/부정 피드백 임계치 실시간 알림, RAG faithfulness 점수 제공.
- **Use Einstein to Generate Data Mask Custom Libraries** (Platform > Data Mask, @13321 matrix) — Einstein이 Data Mask 커스텀 라이브러리 생성.

> 분류: PDF Agentforce & Einstein Features 매트릭스의 **Automation & Integration / Platform** 행. Flow 본체(컬렉션 Join·Send Email 첨부 등)는 Platform 노트로 분리.

## Einstein Flow Formula Builder (GA)

자연어로 Flow 수식을 작성한다.

- **Get Help Creating Flow Formulas with Einstein (Generally Available)** — Einstein for Flow: Formula Creation. January '25 월간 릴리즈로 Spring '25에 GA.

## Einstein Flow Description 생성

- **Generate a Detailed Description of a Flow with Einstein** — 기존 Flow의 상세 설명을 자동 생성한다. 입력/출력 변수, 변경되는 오브젝트, 포함된 Subflow 등을 요약에 포함한다. PDF "Flow Creation with Einstein" 묶음의 두 번째 항목(@13321 matrix).

---

## Agentforce 패키징 지원 (1GP/2GP)

> **Package Agent Actions, Agent Topics, and Prompt Templates in Second- and First-Generation Managed Packages** (March '25 묶음; 상세 @20099–20113 — Development 섹션 내).

> PDF 원문(@20099): *"Develop packages that include Agentforce features like agent actions, agent topics, and prompt templates. Create and test your agents using scratch orgs and the Agentforce Testing Center."*

- **무엇:** Agentforce 기능(agent action·agent topic·prompt template)을 포함하는 패키지를 개발한다.
- **Where:** **second- and first-generation managed packages**(2GP·1GP 모두).
- **테스트:** scratch org + Agentforce Testing Center로 에이전트 생성·테스트.
- **See Also (PDF 명시):** 2GP Developer Guide — Package Agentforce Metadata Components / Get Access to Scratch Orgs That Have Agentforce; 1GP Developer Guide — Get Access to Agentforce in Your 1GP Packaging Org; Agentforce Developer Guide.

> CLI·코드 상세는 → [[Spring '25/Development]].

## Agentforce DX (Beta) 연계

> **Create and Test Agents by Using Agentforce DX (Beta)** (March '25 묶음; 상세 @20281–20349 — Development 섹션 내). CLI 명령·예제 코드는 → [[Spring '25/Development]]; 여기서는 개념만.

> PDF 원문(@20281): *"We're thrilled to announce the beta release of Agentforce DX. This set of pro-code tools includes new Salesforce CLI commands and a Visual Studio Code (VS Code) extension."*

- **무엇:** 에이전트를 프로코드로 생성·테스트하는 도구 세트(Salesforce CLI 명령 + VS Code 확장).
- **Where:** **Salesforce CLI version 2.80.6 and later** (@20296: *"These changes apply to Salesforce CLI version 2.80.6 and later."*).
- **CLI 플러그인:** `@salesforce/plugin-agent`.
- **기능:** YAML Spec 파일 생성(CLI) / Agent·Agent Test 생성 / Agent Test 실행(VS Code 테스트 패널 또는 CLI) / **Interact with Active Agents (Developer Preview)**.
- 관련 항목: **Agentforce for Developers**, **Explore Agentforce and Data Cloud in the New Developer Edition**, **Expose External Services as Custom Agent Actions** (모두 March '25 Platform 매트릭스).

---

## Agentforce (Default) 플랫폼 — 리브랜딩·생성

- **Einstein Copilot for Salesforce is Now Agentforce** (@13601/13985) — Einstein Copilot for Salesforce 에이전트 유형을 **Agentforce**로 리네임(기능 변화 없음). Setup에 "Agentforce" 또는 "Agentforce (Default)"로 표시. **When:** January 2025.
- **Build, Test, and Troubleshoot Agents More Easily with Agent Versions** (@13553/13780) — 단일 에이전트당 **최대 20개 버전**. 동시 활성 에이전트 수는 유형별로 다르며, Agentforce (Default) 유형은 **활성 버전 1개만**. **When:** late March 2025. How: Agents Setup → 드롭다운 → Save As New Version.
- **Build Specialized Agents with Templates** (@13549/13766) — 에이전트 유형(예: Agentforce Service Agent)을 템플릿으로 제공. **When:** mid-March 2025. (추가 비용; add-on은 템플릿별 상이.)
- **Find Agentforce More Easily in Setup** (@13625/14072) — 리네임: Agent Studio→**Agentforce Studio**, Agent Actions→**Agentforce Assets**, Agents→**Agentforce Agents**, Agent Builder→**Agentforce Builder**. **When:** week of March 31, 2025.
- **Say Hello to Agent for Setup, Your Sidekick for Admin Tasks** (@13649/14221) — LEX + Salesforce mobile(iOS/Android), Enterprise/Performance/Unlimited. **When:** March 2025.
- **Simplify Agent Building by Seeing Type-Specific Topics and Actions** (@13655/14243) — **When:** January 2025.
- **Watch Your Agent Take Action with Progress Indicators** (@13673/14339) — LEX·Salesforce mobile·Messaging for In-App and Web. **When:** rolling, week of February 10, 2025; mobile은 week of February 17, 2025.
- **Get Faster Agent Responses with Text Streaming** (@13639/14084) — Agentforce (Default) 가 plain-text LLM 응답을 점진 스트리밍. **When:** rolling, week of February 10, 2025; mobile은 week of March 3, 2025.

### 언어 지원

- **Chat with Agentforce in Your Preferred Language (Beta)** (@13570/13825) — Agentforce (Default) 에 French, German, Italian, Japanese, Portuguese, Spanish 추가(특정 locale). **When:** January 2025. locale code: en_US/en_GB/en_AU, fr_FR/fr_CA, de_DE, it_IT, ja_JA, pt_PT/pt_BR, es_ES/es_MX.
- **Chat with Agentforce in Your Preferred Language (Generally Available)** (@13595/13915) — 위 6개 언어가 특정 locale에서 GA. **When:** week of March 31, 2025. *"When you're working in a language other than English, system messages require a manual translation."*
- **Chat with Agentforce in 9 More Languages (Beta)** (@13598/13947) — 기존 언어에 더해 9개 추가. 9개 언어/locale: Catalan(ca), Chinese Simplified(zh_CN), Chinese Traditional(zh_TW), Dutch(nl), Danish(da), Finnish(fi), Korean(ko), Norwegian(no), Swedish(sv). **When:** March 2025. (PDF가 산문에서 "Japanese"를 중복 표기 — 원문 그대로.)

### 보안·접근 제어

- **Enhance Security by Controlling Access to Agentforce** (@13614/14031) — **Access Agentforce Default Agent** permission set group 또는 **Customize Application** 보유 admin 필요. **Modify Metadata**만 가진 사용자는 더 이상 접근 불가. **When:** February 2025.
- **Enhance Security with the Customer Verification Topic** (@13619/14045) — 새 **Customer Verification** topic; 에이전트가 이메일로 일회용 패스코드(OTP)를 보내 사용자 검증. **When:** early March 2025.
- **Get Separate Access to the Agentforce Platform and the Default Agentforce Agent** (@13642/14099) — **When:** mid-March 2025.
- **Control Access to Topics and Actions with Filters** (@13573/13860) — **When:** early March 2025.
- **Control Agent Decision-Making with Variables** (@13578/13891) — 에이전트 유형별 표준 변수 + 커스텀 대화 변수. **When:** March 2025.

### 호출·확장·테스트

- **Call an Agent from a Flow or Apex Class** (@13561/13808) — 커스텀 에이전트 invocable action으로 Agentforce Service agent(ASA) 또는 Agentforce (Default) 호출. ASA invocable action은 context 변수 지정 가능. **When:** rolling — sandbox **February 4, 2025**, production **February 5, 2025**.
- **Tackle More Use Cases with Expanded Custom Action Support** (@13659/14261) — **Apex REST classes, External Services, MuleSoft APIs**에서 커스텀 액션 생성. MuleSoft for Agentforce Extension Pack(beta) — API Design Extension, Dependencies Extension, Platform Extension. governance ruleset: Salesforce API Topic and Action Enablement, Salesforce Apex REST Best Practices. **When:** early March 2025; Extension Pack(beta)은 late March 2025.
- **Enhance Customer Experiences with Agent Connections (Beta)** (@13608/14000) — Digital Engagement connection에 **두 가지 adaptive response format**(**Rich Link Response**, **Rich Choice Response**) 포함(enhanced Messaging 채널 연결 ASA). **When:** week of March 10, 2025; 개별 에이전트별 관리는 week of April 14, 2025.
- **Use Gen AI to Quickly Create Test Cases** (@13664/14304) — **When:** February 2025.
- **Batch Test with Agentforce Testing Center** (@13544/13748) — LEX·Salesforce mobile·Field Service mobile·Sales Cloud Everywhere(Enterprise/Performance/Unlimited/Developer + Einstein for Sales/Service/Platform add-on). CSV 템플릿 제공. **When:** January 2025.
- **Add More Data Sources to your Agentforce Data Library with Web Search** (@13541/13716) — Setup → Agentforce Data Library → New Library → Web Source → Search the Web. 기능별로 라이브러리 1개씩 할당. **When:** May 2025.
- **View Available Topics and Actions in One Place with the Agent Asset Library** (@13669/14324) — 새 **Agentforce Asset Library**가 Agent Actions Setup 페이지를 대체. **When:** early April 2025.

---

## Agentforce Service Agent — 검증 액션·문서 답변

- **Enhance Agentforce Service Agent Verification with Four New Agent Actions and One New Topic** (@13523/13685) — 새 4개 액션(**Get Cases for Verified Contact, Update Verified Contact, Reset Secure Password, Get Case by Verified Case Number**)은 **Contact ID**(검증된 고객)에 응답. 구버전 4개 액션은 미검증 **Contact Record**에 응답했다. 새 topic: **Service Customer Verification**.
  - **Where:** LEX in Performance/Unlimited/Developer + Einstein for Service / Einstein Platform / Agentforce Service Agent add-on.
- **Answer Employee Questions from Agentforce in Agentforce** (@13529/13706) — Employee 에이전트에 **Answer Questions With Salesforce Documentation** 액션 추가. Salesforce 문서 기반 답변 + 원본 article 링크.
  - **Where:** LEX·Salesforce mobile(iOS/Android) in Enterprise/Performance/Unlimited.

---

## New and Changed Standard Agent Topics and Actions

> PDF 원문: *"Availability of standard agent topics, actions, and related prompt templates or flows can vary by edition and license."*

**May '25 — New Topic: Appointment Management for Field Service** (Scheduling 템플릿·ASA 템플릿 포함). 7개 액션:
- Get Work Types for Field Service
- Create Appointment for Field Service
- Get Appointment Time Slots for Field Service
- Schedule Appointment for Field Service
- Update Appointment Times for Field Service
- Cancel Appointment for Field Service
- Get Appointment Information for Field Service

**March '25**
- **Updated Action: Query Records** — *"now generally available with performance improvements."*
- **Updated Action: Query Records with Aggregates** — *"now generally available with performance improvements."*

**February '25**
- **New Topic: General Slack** — 5개 액션: Create a Slack Canvas; Look Up a Slack User; Search Slack; Send a Slack Direct Message; Update a Slack Canvas.
- **New Topic: Agent for Setup: Connected App Migration** — Summarize OAuth in Connected App; Migrate Connected App.
- **New Topic: Agent for Setup: Fallback** — Answer Questions with Salesforce Documentation.
- **New Topic: Agent for Setup: Object Management** — Identify Object By Name; Identify Field By Name.
- **New Topic: Agent for Setup: User Access Management** — **Get and Explain Object Permissions of User (Beta)**; **Get and Explain User Permissions of User (Beta)**; **Identify User Permissions by Name (Beta)**.

**January '25** (*"...typically become available when Spring '25 rolls out to your org."*)
- **Updated Topic: Field Service Dispatcher Actions** — Get Appointments to Fill Gaps for Field Service; Assign Appointment to Service Resource for Field Service.
- **New Topic: Customer Experience Intelligence** — Enhance Product Description; Find Similar Interactions; Summarize Product Reviews.
- **New Action: Update Omni-Channel User Configuration** — Omni-Channel 사용자에게 queue/skill 할당 추가·제거.

---

## Agentforce Data Library

- **Einstein Data Library Has a New Name: Introducing Agentforce Data Library** (@14366/14378) — **When:** PDF "available starting January **2024**" (맥락상 2025로 추정 — 원문 그대로 보존).
- **Test Your Data with Gen AI Features When You Export Data Libraries to Sandbox** (@14372/14392) — sandbox에서 CRM org로 data library 배포 불가. **When:** March 2025.

## Agentforce Development

- **Batch Test Agents with Testing API** (@14420/14447) — Metadata API로 테스트 생성·배포, Connect API로 실행. 3가지 테스트 유형: 기대 topic 사용 여부 / 기대 action 목록 사용 여부 / 응답에 기대 문자열 포함 여부. **When:** week of March 3, 2025.
- **Improve Agent Quality with New Test Metrics in the Testing API** (@14424/14469) — 새 메트릭: **coherence, completeness, conciseness, response latency**. **When:** week of April 20th, 2025.
- **Connect Agentforce Agents to Any Application with the Agent API** (@14428/14492) — LEX Enterprise/Performance/Unlimited + Einstein Platform add-on. Connected App(client credential flow) → 토큰 → API 호출. **When:** in effect week of March 3, 2025.
- **Try Out New Recipes for the LLM Open Connector** (@14439/14508) — Einstein Platform Cookbook. Hugging Face recipe(Serverless Inference API, Heroku 배포), MuleSoft recipes(Anypoint Studio, Anypoint Code Builder). LLM Open Connector = Einstein Studio Model Builder BYOLLM 개발자 옵션. **When:** in effect week of December 16, 2024.

---

## Einstein Bots

- **Control Intent Recognition Enhancements for Enhanced Bots (Generally Available)** (@14541/14604) — First Message Intent Recognition 설정; cross-lingual intent 모델. *"If you enabled First Message Intent Recognition before Spring '25, the feature remains enabled."*
- **Improve Bot Conversations with Disambiguation (Generally Available)** (@14559/14675) — cross-lingual intent 모델로 가능성 높은 dialog 제안.
- **Use Salesforce Records in Bot Conversations (Generally Available)** (@14598/14786) — **Object Search** 액션. 지원 표준 오브젝트: **Account, Case, Contact, Contract, Knowledge, Lead, Opportunity, Order, Task**. 메시지당 최대 3개 레코드.
- **Control Session Timeout for Bot Conversations (Beta)** (@14545/14624) — How: 켜려면 Salesforce Customer Support 문의.
- **Create Agentforce Service Agents Easily from Your Einstein Bots (Beta)** (@14548/14631) — Agentforce Service Agent 라이선스 필요. 봇 드롭다운에서 "Create Agent from Bot (Beta)". **When:** January 2025(권한 보유 고객); **after February 17, 2025** 모든 Einstein Bots 고객.
- **New Connect REST API Resources for Einstein Bots (Beta)** (@14585/14725) — Utterance Prediction API:
  - `POST /connect/bots/utterance-prediction/intent` — 신규 request body: Bot Utterance Collection Prediction Input, Utterance Prediction Input. 신규 response body: Bot Utterance Collection Prediction, Utterance Prediction, Utterance Prediction Summary.
  - `POST /connect/bots/utterance-prediction/intentFromSet` — 신규 request body: Bot Utterance Collection Prediction From Set Input.
- **Set Bot Variables to Custom Values in Bot Builder** (@14588/14751).
- **Einstein Bots Are Available in More Regions** (@14552/14659) — 신규 region: **London, Montreal, São Paulo, Sydney, Tokyo**.
- **End Messaging for In-App and Web Conversations Thoughtfully** (@14554/14664) — End Chat system dialog.
- **Transition to Generative Knowledge Answers and Data Cloud** (@14592/14762) — Generative Knowledge Answers는 Data Cloud에 인덱싱(Data Cloud 설정 필요). Article Answers는 maintenance mode.
- **Input Recommender (Beta) Is Being Retired** (@14572/14689) — *"Input Recommender is retiring with Spring '25, and you can no longer use it."* cross-lingual 모델로 전환 권장.
- **Legacy Chat is Being Retired** (@14577/14705) — *"Starting in February 2026, legacy chat is removed and you can't use standard bots on legacy chat channels."*
- **Some Usage-Based Entitlement Resources Are No Longer Updated** (@14581/14714) — *"Starting in January '25, the Maximum Chatbot API Sessions Allowed and Maximum Chatbot Sessions Allowed resources are no longer updated."* Maximum Chatbot Engaged Sessions Allowed 사용.

---

## Einstein Trust Layer

- **Improve Content Safety Through Toxicity Detection in Prompts (Beta)** (@14802/14812) — Einstein Trust Layer Setup → Content Safety & Security tab → 켜기. View Setup + Customize Application 권한. **When:** beta로 week of April 21, 2025.
- **Improve Content Security Through Prompt Injection Detection (Beta)** (@14806/14837) — **When:** beta로 week of April 21, 2025.

## Generative Canvas (Preview)

- **Get the Information You Need with One Question to Generative Canvas (Preview)** (@14866/14879) — LEX in Starter·Pro Suite editions. **When:** January 2025.
- **Set Up and Access Generative Canvas from the Navigation Bar (Preview)** (@14871/14905) — **When:** February 2025.

## Prompt Builder

- **Analyze File Inputs with Prompt Templates** (@14938/14970) — prompt template 내 이미지(일부 모델). LEX Enterprise/Performance/Developer/Unlimited.
- **Use More Languages with Prompt Builder** (@14944/14981) — Einstein Setup의 Global Language Support. **When:** PDF "Global output languages are available on February 11, **2024**" (맥락상 2025로 추정 — 원문 그대로 보존).
- **Refine Retriever Results with Pre-Filters** (@14955/14995) — Enterprise/Performance/Unlimited + Einstein for Sales/Platform/Service add-on. **When:** week of April 17, 2025.
- **Improve Response Relevance in Prompt Templates With Ensemble Retrievers** (@14958/15017) — ensemble retriever = 개별 retriever의 모음. Einstein Studio에서 생성·활성화. **When:** week of April 13, 2025.
- **Update Language Learning Models (LLMs) in Prompt Templates** (@14964/15033) — **When:** Einstein Studio의 LLM 가시성은 May 2025.

---

## Other Changes — Models (신규/리라우트 LLM)

- **Use Google Gemini Models on the Einstein Platform** (@15058/15081) — **Vertex AI (Google) Gemini 2.0 Flash**, **Gemini 2.0 Flash Lite**를 Salesforce-managed 모델로 추가(이전엔 Gemini 1.5 Pro BYOLLM만). Data Cloud + Einstein permission set 필요. **When:** week of May 5, 2025.
- **Use Claude 3.7 Sonnet on the Einstein Platform** (@15062/15104) — **Claude 3.7 Sonnet**를 Salesforce-managed 모델로 추가. **When:** week of May 5, 2025(미국 우선, 1주 내 타 지역).
- **Azure OpenAI GPT 4 Turbo Shutdown Date Approaching** (@15066/15117) — *"Azure OpenAI GPT 4 Turbo will be shut down on May 1, 2025."* 요청은 **Azure OpenAI GPT 4 Omni**로 리라우트.
- **OpenAI GPT 4 Turbo and GPT 4 32k Reroute Date Approaching** (@15071/15128) — *"OpenAI GPT 4 Turbo and OpenAI GPT 4 32k model requests will be rerouted to OpenAI GPT 4 Omni on June 6, 2025."*

---

## 성숙도별 항목 수 (Agentforce 범위)

PDF Agentforce & Einstein 범위(@12757–15136) 내 상세 feature heading 기준.

| 성숙도 | 개수 | 예시 |
|---|---|---|
| Generally Available | 7 | Preferred Language(GA), Query Records / Query Records with Aggregates(GA), Intent Recognition Enhancements(GA), Disambiguation(GA), Salesforce Records in Bot Conversations(GA) |
| Beta | 11 | Preferred Language(Beta), 9 More Languages(Beta), Agent Connections(Beta), User Access Mgmt 3액션(Beta), Session Timeout(Beta), Create ASA from Bots(Beta), Bot REST API(Beta), Toxicity Detection(Beta), Prompt Injection Detection(Beta) |
| Preview | 2 | Generative Canvas: One Question / Nav Bar |
| Developer Preview | 1 | Interact with Active Agents (Agentforce DX) |
| Being Retired | 2 | Input Recommender(Beta), Legacy Chat |
| Renamed | 3 | Einstein Copilot → Agentforce; Einstein Data Library → Agentforce Data Library; Service Planner → Service Assistant |

> Pilot 항목(Search Analytics, Conversation Intelligence, Einstein Article Recommendations)은 매트릭스에만 등장하고 상세는 Einstein Search / Service 섹션(범위 밖)에 있다. Beta 중 Agentforce DX(Beta)·Campaign Designer(Beta)·Work Summaries for Case(Beta)는 범위 밖 상세.

---

## 관련 노트

- [[Spring '25]] — Spring '25 릴리즈 노트 허브
- [[Spring '25/Development]] — Agentforce DX CLI·패키징 코드·개발 도구 상세
- [[Spring '25/Platform]] — Flow 본체(Einstein for Flow 적용 대상)·플랫폼 변경
- [[Spring '25/Clouds]] — 클라우드별 산업 에이전트(Sales/Service/Commerce 등)
- [[Spring '25/Industries]] — 산업 클라우드 에이전트(Education/Health/Public Sector 등)
