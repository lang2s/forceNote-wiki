---
tags: [release, spring_24, einstein, copilot, prompt-builder, ai]
source: salesforce_spring24_release_notes.pdf
created: 2026-06-16
aliases: [Spring '24 Einstein, 스프링 24 아인슈타인, Einstein Copilot Prompt Builder GA]
---

# Spring '24 — Einstein

> Einstein Copilot 데뷔 + Prompt Builder GA(2024-02-29). Einstein Trust Layer · Einstein Studio · Einstein Bots를 아우르는 Spring '24 생성형/예측형 AI 플랫폼 변경 사항 전수.
> 허브: [[Spring '24]]

---

## 개요 — Einstein Platform 월별 타임라인

Einstein Platform은 분기 릴리즈와 별개로 거의 매월 변경이 배포된다. Spring '24 사이클 동안 다음 순서로 기능이 추가됐다.

| 시기 | 변경 내용 |
|---|---|
| **Feb '24** | Einstein Copilot 데뷔 + **Prompt Builder GA (2024-02-29)**. Einstein Trust Layer 업데이트, feedback/audit data 강화, 에디션 지원 확대. |
| **Mar '24** | Einstein Copilot용 analytics dashboard 추가. |
| **May '24** | Copilot welcome screen + toxic response flagging. Prompt Builder 개선된 에러 메시지 + Record Snapshot grounding. |

> PDF 원문(2월): *"Einstein Copilot makes its debut and Prompt Builder becomes generally available. Plus, updates to the Einstein trust layer, feedback and audit data enhancements, and expanded edition support."*

---

## Einstein Copilot (GA)

### Meet Your Team's Trusted AI Assistant (GA)

Salesforce CRM을 위한 conversational AI assistant. 직원들이 레코드 요약·이메일 작성 같은 핵심 업무를 "그냥 물어봐서" 처리한다. chat 인터페이스는 사용자의 업무 흐름(flow of work)에 임베드된다. 내부적으로 LLM이 사용자 메시지를 이해하고(understand) → 관련 action을 식별·실행하고(identify and execute relevant actions) → 자연어 응답을 생성한다(generate natural language responses). 모든 상호작용은 사용자 데이터에 grounding되고 **Einstein Trust Layer**로 보안 처리된다.

- **Where:** Lightning Experience, Salesforce mobile app(iOS/Android), Field Service mobile app(iOS/Android), Sales Cloud Everywhere. Enterprise · Performance · Unlimited 에디션 + **Einstein for Sales / Einstein for Service / Einstein Platform** add-on. Setup은 데스크톱 사이트에서만 가능.
- **When:** 데스크톱 사이트 + Sales Cloud Everywhere는 **2024-04-10 GA**. Salesforce mobile app + Field Service mobile app은 **2024-04-22 주(week of)** GA.
- **Who:** `Einstein Copilot for Salesforce User` permission set group 할당.
- **Why — 3가지 설계 특성:**
  - **Flexible:** 전통적 chatbot처럼 엄격한 대화 경로에 묶이지 않는다. copilot은 action 위에 구축되며, LLM의 도움으로 action을 동적으로 mix and match해 요청에 대응한다. context를 유지하므로 대화를 더 깊게(follow-up question) 또는 더 넓게(주제 변경) 이어갈 수 있다.
  - **Trusted:** Einstein Trust Layer와 통합 — 민감 데이터 masking 같은 guardrail로 데이터를 안전하게 사용. 라이선스·사용자 권한 같은 control을 존중해 접근 데이터·실행 action을 제한.
  - **Customizable:** copilot에 할당하는 action이 copilot의 능력을 정의한다. 바로 쓸 수 있는 **standard copilot action 라이브러리**에서 고르거나, 기존 Salesforce 자산(invocable Apex class, autolaunched flow, prompt template)을 기반으로 **custom action**을 만들어 확장한다. 코드가 아니라 "말(words)"로 copilot에게 action 사용법을 알려준다.

### Launch Your Copilot Quickly with Standard Actions (GA)

기본 제공 standard action만으로도 custom 기능 구축 없이 데스크톱 사이트와 Salesforce mobile app에서 강력한 copilot을 빠르게 런칭할 수 있다. 다수의 standard action은 Einstein Copilot 접근 권한이 있는 사용자에게 제공되지만, 일부는 특정 cloud/product용이라 추가 라이선스·권한이 필요하다. **prompt template을 실행하는 standard action은 `Execute Prompt Templates` permission이 필요하다.**

| Action | What It Does |
|---|---|
| **Answer Questions with Knowledge** | 관련 knowledge article 정보를 바탕으로 사용자 질문에 답한다. **Knowledge license 필요.** 예: "What is the policy for returns over 30 days?" |
| **Create Close Plan** | 목표일까지 opportunity를 close하도록 돕는 sales plan을 생성한다. **Einstein for Sales add-on + Close Plan user permission** 사용자에게 제공. 예: "Create a close plan for this opportunity." |
| **Draft or Revise Sales Email** | sales email draft를 만들거나 가장 최근 생성된 이메일을 사용자 입력 기반으로 수정한다. 예: "Help me write an intro email to Steve from Acme." |
| **Explore Conversation** | call transcript 내용을 바탕으로 voice/video call에 대한 질문에 답한다. **Einstein Conversation Insights + Einstein for Sales 필요.** 예: "What was the customer sentiment on this call?" |
| **Find Similar Opportunities** | 지정한 opportunity와 유사하지만 중복은 아닌 won opportunity 목록을 검색·반환한다. 각 레코드에 유사성 설명이 함께 반환된다. 예: "Show me other won deals like this one." |
| **Get Forecast Guidance** | seller의 gap to Commit / gap to Most Likely를 계산하고 forecast 내 위험 deal에 flag를 단다. **Einstein for Sales add-on 필요.** 예: "Show me Vince West's forecast." |
| **Identify Object by Name** | 사용자 입력을 해석해 어떤 object를 가리키는지 결정하고 object 이름을 반환해 후속 action이 가능하게 한다. 예: "List the opportunities for the Acme account" → Account/Opportunity object 식별. |
| **Identify Record by Name** | 이름으로 Salesforce 레코드를 검색해 매칭되는 레코드 ID 목록을 반환한다. 예: "Show me the Acme deal." |
| **Query Records (Beta)** | 사용자 요청과 필드 값 같은 특정 조건에 따라 Salesforce 레코드를 찾아 반환한다. 예: "Find all open opportunities set to close this quarter." |
| **Query Records with Aggregate (Beta)** | count, sum, average 같은 집계 질문에 답한다. 예: "How many opportunities were created in the last 5 days?" |
| **Summarize Record** | Salesforce 레코드를 요약한다. 어떤 레코드든 요약 가능하지만, 일부 레코드/사용자는 요약을 커스터마이즈하는 predefined prompt template을 가진다. 예: "Create a summary for the Acme deal." |

> ⚠️ **명확화:** "Meeting Follow-Up Email"은 standard action이 **아니다**. PDF 원문(line 14813–14814): *"the Draft or Revise Sales Email copilot action uses a Meeting Follow-Up Email internal-only prompt template"* — 즉 **Draft or Revise Sales Email** action이 내부적으로 쓰는 internal-only prompt template이다. "Identify Record Gaps"는 PDF에 존재하지 않는다.

> **관리 방법:** Copilots 페이지에서 copilot 선택 → 상세 페이지의 **Actions 탭**에서 할당된 standard action 목록 검토. Copilot Actions setup 페이지 또는 Copilot Builder에서 관리.

### Extend Your Copilot with Custom Actions (GA)

기존 platform 기능 위에 custom action을 구축해 copilot을 비즈니스 특화 작업에 맞게 확장한다. 기반이 되는 세 가지 자산:

- invocable Apex class
- autolaunched flow
- prompt template

활용 use case 예시: order details 조회, return 처리, product recommendation, inventory 확인, invoice 조회, meeting booking, marketing material 생성, IT ticket 처리.

### Customize, Test, and Troubleshoot — Copilot Builder (GA)

전통적 chatbot과 달리 copilot은 대화 중 reason하고 동적으로 응답한다. **Copilot Builder**로 copilot의 action·setting을 관리하고, 대화와 그 추론(reasoning)을 미리보며, 대화 활동을 감사(audit)한다.

> PDF에 Copilot Builder UI 스크린샷 콜아웃이 있음 — 본 wiki는 텍스트 설명만 제공한다(다이어그램 재현하지 않음).

### Gauge Adoption with Copilot Analytics (GA, Mar '24)

**Copilot Analytics dashboard**로 copilot 사용성을 추적하고 standard/custom action 인사이트를 얻는다. 참여 사용자 수, 실행된 action, action 성공률을 읽기 쉬운 차트·메트릭으로 보여준다.

### Welcome Users with Recommended Contextual Actions (GA, May '24)

사용자가 처음 Einstein Copilot에 접근하거나 새 세션을 시작하면, 페이지 context 기반 recommended action을 보여주는 welcome screen이 자동 표시된다. 예: account/opportunity에 접근한 sales rep에게 "Show top opportunities" 또는 "Show recent opportunities" 같은 action 제시. System Messages에 설정한 welcome message는 이제 첫 메시지가 아니라 welcome 페이지 상단에 표시된다.

> welcome message는 800자 제한.

### See a Warning if Copilot Generates Toxic Language (GA, May '24)

copilot이 harmful/offensive 언어를 사용하는 응답을 생성하면 사용자에게 경고가 표시된다. flag된 콘텐츠는 **Einstein audit trail**에도 기록된다. 콘텐츠가 harmful language로 태그되면 사용자는 판단을 행사하고 필요 시 새 응답을 생성하도록 안내받는다.

### Salesforce mobile app Copilot

Salesforce mobile app에서 iOS Siri/Dictation 음성으로 copilot과 상호작용 가능.

### Sales Cloud Copilot 액션 상세

| 액션 | 사용 prompt template / action | 권한·조건 | 시기 |
|---|---|---|---|
| **Sales Summaries** | Sales Summaries prompt template | Sales Summaries User permission | — |
| **Forecast Guidance** | GetForecastGuidance action | Einstein for Sales add-on | mid April |
| **Create Close Plan** | Create Close Plan action | Einstein for Sales add-on + Close Plan permission | April 2024 |
| **Meeting Follow-Up Email** | Draft or Revise Sales Email action + Meeting Follow-Up Email internal-only prompt template | Einstein Conversation Insights 필요 | April |
| **Find Similar Opportunities** | Find Similar Opportunities action | — | late April |

### Service — Work Summaries in Einstein Copilot (Beta)

Voice/Messaging/Chat transcript를 요약한다. **Summarize Record** action + **Work Summaries** prompt template으로 동작.

---

## Prompt Builder (GA)

**Simplify Daily Tasks with Prompt Builder (Generally Available)** — 2024-02-29 GA.

prompt template으로 구동되는 생성형 AI 순간(generative-AI moments)을 사용자 워크플로에 통합한다. trusted 생성형 AI 기술로 customizable prompt template을 만들면서 데이터는 안전하게 유지한다. prompt template을 CRM 데이터로 동적 grounding해 LLM에 personalized 응답을 만들 context를 제공한다.

### prompt template 유형 3종

| 유형 | 설명 |
|---|---|
| **Sales Email** | 커스터마이즈된 Sales Email template으로 contact/lead를 위한 personalized 이메일을 빠르게 생성. |
| **Field Generation** | account의 open case 요약처럼 유용한 정보로 필드를 빠르게 채워, 고객과 더 생산적인 대화를 가능하게 함. |
| **Flex** | product·campaign object 기반 newsletter 생성 등 폭넓은 가능성을 제공하는 범용 유형. |

### Where / Who

- **Where:** Lightning Experience, Enterprise · Performance · Unlimited 에디션. **Unlimited+ 에는 포함**. Enterprise/Performance/Unlimited에서 쓰려면 **Einstein for Sales / Einstein for Platform / Einstein for Service** add-on 필요(이 add-on들은 **Data Cloud 포함**).
- **권한:**
  - Admin = `Prompt Template Manager` permission set + `Einstein Prompt Templates` permission set license (PSL) — prompt template 생성·관리.
  - Admin/data scientist = `Data Cloud Admin` permission set — Einstein Studio에서 모델 조회·BYOM.
  - End user = `Prompt Template User` permission set + `Einstein Prompt Templates` PSL — prompt template 사용.
  - Sales Emails 사용 = `Einstein Sales Emails` permission set.

### Grounding (데이터 자원)

prompt template을 CRM 데이터로 grounding하는 4가지 자원:

- **merge field** — record field 참조
- **Prompt Flow type flow** — Prompt Flow 유형의 flow
- **related list**
- **Apex**

### 개발자 통합

#### Apex — ConnectApi.EinsteinLLM (신규 클래스)

```apex
// Prompt Builder와 함께 제공되는 신규 ConnectApi.EinsteinLLM 클래스 (PDF verbatim)
// prompt template과 input parameter로 응답 생성
ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
    promptTemplateDevName,
    promptTemplateGenerationsInput
);
// New input class:  ConnectApi.EinsteinPromptTemplateGenerationsInput
// New output class: ConnectApi.EinsteinPromptTemplateGenerationsRepresentation
```

#### Apex — Provide Data to Einstein with Invocable Actions

`@InvocableMethod` annotation + `capabilityType` modifier를 사용하는 Apex method를 만들면, Prompt Builder의 prompt template과 통합되는 invocable action을 생성할 수 있다. 이 invocable action은 동적 로직·action을 수행해 출력 텍스트를 만들고, 그 텍스트가 연관 prompt template의 resolution에 merge된다.

- **Where:** Lightning Experience, Enterprise · Unlimited · Unlimited+ 에디션.

#### REST API

```http
# 신규 Einstein REST 리소스 (PDF verbatim)
POST /einstein/prompt-templates/promptTemplateDevName/generations
# Request body:  Einstein Prompt Template Generations Input
# Response body: Einstein Prompt Template Generations
```

#### Metadata API

- 신규 metadata type: **`GenAiPromptTemplate`**, **`GenAiPromptTemplateActv`** — prompt template 생성·관리. org 간 prompt template configuration 전송은 **change set** 사용.
- Flow metadata type의 `FlowActionCall` subtype `actionType` 필드에 신규 값 **`initiateNaturalLangProcessing`** — 관련 Salesforce 레코드에서 AI 서비스로 텍스트 처리.

#### Flow (Salesforce Flow / Flow metadata)

- Flow metadata type `processType` 필드에 신규 값 **`PromptFlow`** — Prompt Builder와 통합되는 flow 지정.
- `FlowStart` subtype에 신규 필드 **`capabilityTypes`** — flow와 capability 간 데이터 전달.
- `FlowActionCall` subtype `actionType` 필드에 신규 값 **`generatePromptResponse`** — prompt template 응답 생성.

#### Template-Triggered Prompt Flow

Flow Builder에서 Prompt Builder의 prompt template과 통합되는 **template-triggered prompt flow**를 만든다. flow가 동적 로직·action을 수행해 출력 텍스트를 생성하고, 그 텍스트가 연관 prompt template의 resolution에 merge된다.

- **How:** Flow Builder에서 template-triggered prompt flow 생성 → Prompt Builder의 prompt template 유형과 연관된 **prompt template type** 선택 → 신규 **Add Prompt Instructions** element로 flow 구성 후 저장 → Prompt Builder에서 prompt template을 미리보면 flow가 trigger된다.
- **Where:** Lightning Experience, Enterprise · Unlimited · Unlimited+ 에디션. Einstein for Sales/Platform/Service add-on 필요.
- ⚠️ **호환성:** template-triggered prompt flow는 **Winter '24에서 만든 prompt template과 호환되지 않는다**(*"aren't compatible with prompt templates created in Winter '24"*).

---

## Einstein Studio in Data Cloud

> 상세는 Data Cloud 릴리즈 노트에도 기재. 여기서는 Einstein Platform 관점 요약.

- **Unlock the Power of AI with Einstein Studio (Feb '24):** Data Cloud에 AI home base 역할의 **Einstein Studio** 탭 추가. 기존 탭은 **Einstein Studio (Legacy)** 로 리네임.
- **Build Your Own Predictive AI Models:** 코드 없이 numeric measure 또는 binary outcome을 예측하는 predictive AI 모델 생성.
- **Power Generative AI Using Third-Party LLMs:** 외부 LLM(OpenAI, Azure OpenAI)을 foundation model로 연결. **Foundation Models** 탭 + **Model Playground** 제공.
- **Drive Hyper-Personalization Using Databricks Models (BYOM):** Databricks 모델의 예측을 가져와 활용(Bring Your Own Model).
- **Enrich Batch Data Transforms / Get Predictions:** Prediction Jobs로 batch data transform을 enrich하고, Flow Builder action으로 예측을 가져온다.

---

## Einstein Trust Layer

Einstein Trust Layer는 end-user 경험에 통합된 data·privacy control로 Salesforce 생성형 AI의 보안을 끌어올린다.

- **Data Masking:** region별 PII·PCI를 탐지·마스킹하고 **zero-data retention**을 적용.
- **Select What Data to Mask:** 마스킹할 데이터를 선택.
- **Audit Trail:** audit data와 feedback data를 **Data Cloud**에 저장.

---

## Einstein Bots

### Teach Your Bot New Languages — Cross-Lingual Intent Model (GA)

cross-lingual intent model로 업그레이드하면 봇 성능이 개선되고 NLP 봇에 언어 추가가 쉬워진다.

- 이전 모델: intent당·언어당 테스트/빌드에 **20 utterance** 필요.
- cross-lingual model: **intent·언어당 utterance 단 1개(as little as one)** 로 학습 가능. 모델 rebuild 없이 새 언어 utterance 테스트 가능. (intent에 20 utterance를 추가하면 모든 utterance를 테스트·학습에 써 더 정확한 F1 score 생성.)
- **19개 언어** intent·system entity 인식 지원, **Arabic(beta)** 포함.
- **Where:** Lightning Experience + Salesforce Classic, Enterprise · Performance · Unlimited · Developer 에디션. 신규/클론 봇·봇 버전은 single-/multi-language 모두 cross-lingual model을 기본값으로 사용.

### Messaging Components for Enhanced Bots (Beta)

enhanced bot용 4종 messaging component로 더 복잡한 use case 처리(enhanced Apple Messages for Business 채널). form component는 Messaging for In-App and Web에서도 제공.

- **Authentication**
- **Custom**
- **Form**
- **Payment**

### Send a Dynamic File with an Enhanced Bot

account 관련 invoice처럼 personalized 파일을 enhanced bot으로 동적으로 채워 전송. 이전에는 Asset Library에 저장된 static 파일만 전송 가능했다.

### Translate Dialogs (Beta)

multi-language 봇의 dialog를 다른 언어로 자동 번역.

### Commerce Concierge bot template (2024-02-04)

Commerce 스토어용 Commerce Concierge bot template 제공.

### Run Flows in Bot User Context (Release Update)

봇이 시작한 flow가 봇에 연관된 user profile·permission set으로 object permission·field-level access를 결정한다. 이 업데이트는 Summer '23에 처음 제공됐고 **Summer '24에 강제(enforced)** 예정. → [[Spring '24/Release Updates]]

### View Standard Bot Reports in the Spring '24 Folder

매 릴리즈마다 Einstein Bots는 최신 standard bot report 폴더를 추가한다. Spring '24에서는 standard bot metric type·개별 report에 변경이 없으나, **Einstein Bot Reports Spring '24** 폴더에서 모든 report의 새 버전에 접근할 수 있다.

---

## Other Changes (언어 · 에디션 · audit)

- **Use Multilingual Support in Einstein Generative AI:** English 외에 **French · German · Italian · Japanese · Spanish** 지원(Service Replies for Chat, Work Summaries 등 기능 포함).
- **Editions Support for Einstein Generative AI:** Lightning Experience의 **Enterprise · Performance · Unlimited** 에디션 지원.
- **Generative AI Audit and Feedback Data (Mar '24):** audit·feedback data를 **Data Cloud**에 저장.
- **Einstein for Developers (Beta):** Apex 코드 생성을 돕는 개발자 도구.

---

## 관련 노트

- [[Spring '24]] — Spring '24 릴리즈 허브
- [[Spring '24/Development]] — Apex · API · Flow · Metadata (ConnectApi.EinsteinLLM, capabilityType invocable, PromptFlow 등 개발자 통합 상세)
- [[Spring '24/Automation]] — Flow Builder & Orchestration (Template-Triggered Prompt Flows의 Add Prompt Instructions element, Send to Data Cloud 등 Flow 쪽 상세)
- [[Spring '24/Clouds]] — Sales/Service/Data Cloud (Einstein Studio, Sales Cloud Copilot 액션의 cloud별 맥락)
- [[Spring '24/Release Updates]] — Run Flows in Bot User Context 등 release update
