---
tags: [release, summer_24, einstein, copilot, prompt-builder, ai]
source: salesforce_summer24_release_notes.pdf
created: 2026-06-16
aliases: [Summer '24 Einstein, 서머 24 아인슈타인, Einstein Copilot Prompt Builder Einstein Studio]
---

# Summer '24 — Einstein

> Einstein Copilot · Prompt Builder · Einstein Studio · Models API(Beta) · Einstein Data Library(Generally Available)를 아우르는 Summer '24(API v61.0) 생성형/예측형 AI 변경 전수. **Agentforce 이전(pre-Agentforce) 릴리즈** — 모든 AI는 Einstein / Einstein Copilot / Prompt Builder / Einstein Studio 명칭을 쓴다.
> 허브: [[Summer '24]]

---

## maturity 범례

| 표기 | 의미 |
|---|---|
| **(Generally Available)** | 정식 출시 — 프로덕션 사용 가능 |
| **(Beta)** | 베타 — Beta Services Terms 적용, 사용은 고객 재량 |
| **(Release Update)** | 릴리즈 업데이트 — 특정 릴리즈에 강제(enforced) |
| *(표기 없음)* | Summer '24 Einstein 챕터는 일반 신규/변경 기능에 GA/Beta를 별도 약칭하지 않음. 아래에서 maturity 표기가 없는 항목은 명시적 GA/Beta/Pilot 태그가 PDF에 없는 일반 신규/변경 기능이다. |

> Summer '24는 "(GA)" 같은 약칭을 쓰지 않는다. 정식 출시는 **(Generally Available)** 로 풀어 쓴다.

---

## 개요

Einstein 챕터(printed p.313–334 / physical 317–338, API v61.0)의 모든 기능을 전수 정리한다.

> PDF 원문: *"Einstein — Supercharge your workforce efficiency with predictive and generative AI."* (p.313)

Einstein 기능은 분기 릴리즈와 별개로 **거의 매월(as often as monthly)** 배포된다.

> PDF 원문: *"Einstein features are released as often as monthly... Features included in the June monthly release generally become available when Summer '24 rolls out to your org."* (p.313)

### Einstein Platform 월별 타임라인

| 시기 | 주요 변경 |
|---|---|
| **June '24** | Copilot: Clear Feed History · Require user confirmation(custom action) · 신규 standard topics/actions(Send Meeting Request, Draft a Gift Proposal). Prompt Builder: Record Snapshots(Ground Automatically) · View Masking of Sensitive Data. Bots: Required Responses · Generative Knowledge Answers · Run Flows in Bot User Context(Release Update) · New Invocable Actions. Other: Supported Locales(6개) · Starter Usage Type(BYO-LLM). |
| **July '24** | Copilot: Give Feedback · See Records from Different Objects(All Records 탭) · **Mask PII setting 제거**. Prompt Builder: Flex Free Text Inputs · Harmful Content Notification. Models API **(Beta)**. Trust Layer 추가 dashboards/reports(mid-July). Other: Geo-Aware LLM Routing · Supported Models 페이지. |
| **August '24** | Copilot Topics(General CRM·Single Record Summary·Close Deals·Communicate·Conversation Explorer·Forecast·Manage Deals). Prompt Builder: RAG · 4개 언어 추가(총 10개) · Use One Apex/Flow in Multiple Templates · Work with Large Prompts. Einstein Data Library **(Generally Available)**. RAG in Data Cloud. Other: Anthropic/Google/OpenAI 모델 추가 · Einstein Data Prism(기능은 9월부터) · **GPT 3.5 Turbo 16k shutdown 예고**. |

> Einstein Studio·Hybrid/Vector Search 등 일부 항목의 상세 본문은 **Data Cloud 릴리즈 노트로 위임**되어 있다. 본 노트는 Einstein 챕터에 상세 본문이 있는 항목을 전수 기재하고, 위임된 항목은 cross-ref만 둔다.

---

## Einstein Copilot

> PDF 원문(섹션 intro): *"Bring the power of conversational AI to your business with Einstein Copilot. Einstein Copilot features are released as often as monthly, and there's much more to come in Summer '24."* (p.319)

대부분의 Copilot 기능 **Where**는 동일하다: Lightning Experience, Salesforce mobile app(iOS/Android), Field Service mobile app(iOS/Android), Sales Cloud Everywhere — **Enterprise · Performance · Unlimited** 에디션 + **Einstein for Sales / Einstein for Service / Einstein Platform** add-on. Einstein Copilot **Setup은 데스크톱 사이트에서만** 가능.

### Copilot Topics 확장 — Handle More Use Cases More Consistently with Copilot Topics

**Release:** August '24 (rolling, week of August 26, 2024)

**Topics**는 copilot에 새로운 조직·커스터마이즈 계층을 더한다. copilot이 더 정확한 결정을 내리고 더 관련성 높고 예측 가능한 응답을 생성하도록 돕는다.

> PDF 원문: *"Topics represent the jobs you want your copilot to handle using a set of related instructions and actions. Now when a user enters a question or request, instead of searching through a flat list of all actions assigned to it, your copilot selects a relevant topic and then launches one or more actions included within that topic... Get started quickly with a library of out-of-the-box standard topics for common use cases, or create custom topics to meet your unique business needs."* (p.320)

**동작 모델 변화:**
- action을 copilot에 직접 할당하지 않고, **action → topic → copilot** 순으로 할당한다. 하나의 action을 여러 topic에 할당할 수 있다.
- 전환을 매끄럽게 하기 위해, 이전에 copilot에 직접 할당돼 있던 모든 action은 **Migration Default Topic** 이라는 topic으로 제공된다. 단 이 topic은 일반적 성격이라 use case에 최적화돼 있지 않다.
- topic은 planner service(Einstein Copilot의 reasoning engine) 개선의 일부다. Copilot Builder의 plan canvas에 topic 관련 step이 추가됐고, 단일 plan을 한 번 생성하는 대신 **action 간·사용자 입력에 반응한 더 빈번하고 반복적인(iterative) 결정**을 내린다.

> ⚠️ **PII 관련 변경(verbatim):** *"With this change, Einstein Copilot no longer supports masking of personally identifiable information (PII) through the Einstein Trust Layer."* (p.321) — 아래 "PII 마스킹 설정 제거" 항목과 연결.

**신규 standard topics (week of August 26, 2024):**

| Topic | 역할 (verbatim 요지) |
|---|---|
| **General CRM** | Salesforce CRM 데이터 관련 요청 처리 — 레코드 식별·요약·업데이트, 이메일 초안/수정, 데이터 집계, Salesforce object 검색·쿼리. 신규 copilot action 3개 포함(아래). 신규 copilot에 기본 할당. |
| **Single Record Summary** | 단일 Salesforce 레코드의 요약 생성. 신규 copilot에 기본 할당. |
| **Close Deals** | AI 인사이트로 sales 성공률을 높임 — 과거 won deal·conversation signal·customer sentiment 기반 close 접근법 추천, product pricing 질문 응답, sentiment 브리핑, close plan 제안. |
| **Communicate with Customers** | 이메일·follow-up·meeting request로 prospect/contact/lead와 소통할 개인화된 커뮤니케이션 생성. |
| **Conversation Explorer** | call transcript 내용 기반으로 voice/video call에 대한 사용자 질문에 답변. |
| **Forecast Sales Revenue** | sales revenue 예측에 대한 종합 인사이트 — 팀 forecast 이해, market signal/predictive analysis 기반 미래 sales 예측, deal alert·risky deal·deal value 추정 질의 응답. |
| **Manage Deals** | 효과적 deal 관리를 위한 전략 정보 — 특정 contact/관계 정보 제공, 유사 opportunity 식별로 deal 전략 최적화·우선순위 지정, deal·pipeline의 실시간 뷰. |

**General CRM topic의 신규 copilot action 3종:**

| Action | 역할 (verbatim 요지) |
|---|---|
| **Get Record Details** | 특정 레코드 정보 조회 — object field·value, related list 레코드, 연관 task·event 검색. |
| **Get Activities Timeline** | 지정 기간 내 레코드 연관 activity 전체 목록 검색(과거·미래 activity 포함). |
| **Get Activity Details** | activity의 간단한 요약 — content 개요(이메일·call summary 등)와 기타 상세. 유효 activity type: calls, emails, events, tasks. |

**How:** Copilot Builder에서 copilot 열기 → **Topics** 패널에서 asset library의 standard topic 선택 또는 custom topic 생성(action·instruction 정의). custom topic은 Topics 패널에서 보거나 편집 — topic 이름 클릭 후 **Topic Configuration** 탭, action 보기/추가/제거는 **This Topic's Actions** 탭. **topic·action을 변경하려면 copilot을 비활성화(deactivate)해야 한다.**

```text
// 구조 예시 — 실제 동작 코드 아님 (PDF에 코드 블록 없음, action→topic→copilot 할당 모델의 텍스트 도식)
Einstein Copilot
└── Topic: General CRM            (신규 copilot에 기본 할당)
    ├── Action: Get Record Details
    ├── Action: Get Activities Timeline
    └── Action: Get Activity Details
└── Topic: Single Record Summary  (신규 copilot에 기본 할당)
└── Topic: Migration Default Topic (이전에 copilot에 직접 할당돼 있던 action들)
        ↑ 하나의 action을 여러 topic에 할당 가능
```

### PII 마스킹 설정 제거 — The Mask Personally Identifiable Information (PII) Setting Has Been Removed

**Release:** July '24 (week of June 17, 2024부터 적용)

> PDF 원문: *"Copilot actions apply Einstein Trust Layer data masking by default, so the Mask personally identifiable information (PII) setting has been removed from custom and standard copilot action inputs and outputs. The Trust Layer uses a combination of pattern matching and machine learning techniques to automatically identify and mask PII, no additional settings required."* (p.321)

copilot action은 기본적으로 Einstein Trust Layer 데이터 마스킹을 적용한다. 따라서 custom·standard copilot action의 input/output에서 **Mask PII 설정이 제거됐다**. Trust Layer가 pattern matching + machine learning으로 PII를 자동 식별·마스킹하며 추가 설정이 필요 없다.

### Copilot 응답 피드백 — Give Feedback on Copilot Responses

**Release:** July '24 (iOS/Android는 week of July 1, 2024)

사용자가 Copilot 응답에 **thumbs up / thumbs down** 으로 응답이 유용했는지 알릴 수 있다.

> PDF 원문: *"When users hover over a Copilot response and select a thumbs down, they can select a reason why the response was unhelpful, or they can use the Other field to enter a reason not represented in the list. In the Salesforce mobile app, users can give feedback when they long-press a system-generated response."* (p.321)

thumbs down 시 응답이 유용하지 않은 이유를 선택하거나 **Other** 필드에 직접 입력한다. mobile app에서는 system-generated 응답을 long-press 해 피드백을 준다.

### 다양한 오브젝트 레코드 표시 — See Records from Different Objects in Einstein Copilot's Responses

**Release:** July '24 (iOS/Android는 week of July 1, 2024)

한 목록에 서로 다른 object type을 결합한 응답을 볼 수 있다.

> PDF 원문: *"For example, a salesperson asks Einstein Copilot, "Show me all the records owned by John Smith." After clicking View More, the salesperson can now see accounts, contacts, opportunities, and campaigns owned by John Smith in one list in the new All Records tab."* (p.321)

**View More** 클릭 후 신규 **All Records** 탭에서 account·contact·opportunity·campaign을 한 목록에 표시한다.

### Copilot Feed 히스토리 초기화 — Clear Your Einstein Copilot Feed History

**Release:** June '24 (iOS/Android는 week of July 1, 2024)

긴 채팅 후 feed가 어수선하면 feed 히스토리를 지우고 새 세션을 시작할 수 있다.

> PDF 원문: *"Clearing your feed history deletes previous interactions with Einstein Copilot, so if you need a response in your feed, make sure that you saved it elsewhere."* (p.322)

**How:** clear history 아이콘으로 feed를 비우고 새 세션 시작. feed 히스토리 초기화는 이전 상호작용을 삭제하므로, 필요한 응답은 다른 곳에 저장해 둘 것.

### 커스텀 액션 사용자 확인 — Give Users Control in Custom Einstein Copilot Actions

**Release:** June '24 (iOS/Android는 week of July 1, 2024)

custom action 생성 시 **Require user confirmation** 설정을 켜면, copilot이 org를 변경하기 전 사용자에게 확인 요청을 보낸다.

> PDF 원문: *"For example, a salesperson uses a custom action to ask Einstein Copilot to update an opportunity's stage that's currently set at Prospecting. Einstein Copilot reviews the activities around the opportunity and settles on the Negotiation stage. Before making the update, the salesperson must click Confirm to ensure that the stage is the correct one."* (p.322)

**How:** custom action 생성 시 **Require user confirmation** 설정을 켜면 action에 확인 버튼이 표시된다.

### 신규·변경된 Standard Copilot Topics·Actions (주차별)

**Release:** June '24 (그리고 July/August rolling)

> PDF 원문: *"Quickly add powerful functionality to a copilot with new and changed copilot standard topics and actions. Availability of copilot standard topics, actions, and related prompt templates can vary by edition and license."* (p.322)

**Week of August 26, 2024:** 신규 topics — General CRM(+Get Record Details / Get Activities Timeline / Get Activity Details), Single Record Summary, Close Deals, Communicate with Customers, Conversation Explorer, Forecast Sales Revenue, Manage Deals (상세는 위 "Copilot Topics 확장" 참조).

**Week of August 5, 2024 — Draft or Revise Email:** 이제 여러 action을 chain 해 multiple intent를 처리한다.
> PDF 원문: *"For example, Einstein Copilot can help a user summarize a call and then email it to someone in a single request: "Summarize the latest call with this customer and email it to Sofia Rodriguez." Behind the scenes, the Summarize Record action passes the action's output (a summary) to the Draft or Revise Email action as an input."* (p.323)
> 예시: "Summarize the Acme campaign and email it to John Smith." · "Find the return policy for the Studio Pro headphones and email it to this customer." · "Summarize the most recent Acme case and email it to Isaac Goldstein."

**Week of July 15, 2024:**
- **Summarize Record:** account 요약 시 더 종합적이고 정보가 풍부한 요약 생성. account detail, open case, past purchase, current opportunity, relevant interaction 등 스냅샷 캡처.
- **Get Forecast Guidance:** 이제 **flow로 구동**된다.

**Week of July 8, 2024:**
- **Customize Work Summaries:** Copilot에서 Einstein이 Work Summaries를 작성하는 방식을 커스터마이즈 — Einstein 응답을 안내하는 prompt template에 자체 포매팅 규칙/제약 추가. (상세 p.776 / 아래 "Einstein 적용 — Clouds 맥락" 참조)

**Week of June 17, 2024 — Draft a Gift Proposal:** Nonprofit·Education Cloud 고객이 **Fundraising Gift Proposals** copilot action으로 개인화된 gift proposal 작성을 간소화. Einstein Copilot에서 사용 가능.

**Week of June 10, 2024 — Send Meeting Request:** sales 사용자가 신규 **Send Meeting Request** copilot action으로 recipient에게 meeting request 초안 작성. 이메일 초안에 3개 time slot과 발신자 캘린더 링크 포함.

**June '24 (monthly):**
- **Answer Questions with Knowledge:** Einstein Bots 고객이 기존 Answer Questions with Knowledge copilot action을 봇에서 사용 가능.
  > Beta note(verbatim): *"This feature is a Beta Service. Customer may opt to try such Beta Service in its sole discretion. Any use of the Beta Service is subject to the applicable Beta Services Terms provided at Agreements and Terms."*
- **Service Catalog Item (Reference Action Type):** Service Catalog 고객이 신규 **Service Catalog Item** reference action type으로 Service Catalog item에서 custom action을 생성. Service Catalog use case용 prebuilt custom action도 몇 번의 클릭으로 접근.

---

## Prompt Builder

> PDF 원문(섹션 intro): *"Simplify your users' daily tasks by integrating generative-AI powered by prompt templates into their workflow. Create, test, revise, customize, and manage prompt templates that incorporate your CRM data from merge fields that reference record fields, flows, related lists, and Apex."* (p.327)

Prompt Builder의 대부분 기능 **Where**: **Lightning Experience**, **Enterprise · Performance · Unlimited** 에디션. (일부는 Einstein for Sales / Einstein for Platform / Einstein for Service add-on 필요.)

### Flex Prompt Templates — Create Flex Prompt Templates with Free Text Inputs

**Release:** July '24 (June 26, 2024부터)

> PDF 원문: *"Prompt Builder now supports free text inputs for use in flex prompt templates, so you can now use flex prompt templates in scenarios when you want to provide any manner of text as an input to your prompt."* (p.328)

flex prompt template에 **free text input**을 지원해, 어떤 형태의 텍스트든 prompt에 input으로 제공할 수 있다.

### 다국어 응답 — Get Prompt Responses in More Languages

**Release:** August '24 (week of August 12, 2024)

> PDF 원문: *"Prompt Builder supports four additional languages for prompt template responses: Dutch (Netherlands), Portuguese (Brazil), Spanish (Mexico), and Swedish (Sweden). Prompt Builder now supports prompt template responses in ten languages."* (p.328)

prompt template 응답에 **4개 언어 추가** — Dutch(Netherlands) · Portuguese(Brazil) · Spanish(Mexico) · Swedish(Sweden). 이제 **총 10개 언어**를 지원한다.

**Where:** Enterprise · Performance · Unlimited + Einstein for Sales / Einstein for Platform / Einstein for Service add-on.

### 자동 Grounding — Ground Your Prompts Automatically (Record Snapshots)

**Release:** June '24 (sandbox 2024-06-05, production 2024-06-12 rolling)

> PDF 원문: *"Record Snapshots brings a new way to ground your prompts, by automatically including data available on the user's page layout for an object with one resource."* (p.328)

**Record Snapshots**는 object의 사용자 page layout에 있는 데이터를 단일 resource로 자동 포함해 prompt를 grounding한다.

**How:** Prompt Builder의 resource picker에서 prompt template의 input object 선택 → **Record Snapshot** 선택 → 평소처럼 prompt 작성하면 Record Snapshot이 해당 object의 page layout 데이터로 prompt를 grounding한다.

### RAG (Retrieval Augmented Generation) — Ground Your Prompt Templates with Retrieval Augmented Generation (RAG)

**Release:** August '24 (week of August 19, 2024)

> PDF 원문: *"A retriever returns relevant facts from textual data, which is indexed in a vector database, to augment a Large Language Model (LLM) prompt. By augmenting the prompt with accurate, current, and pertinent information, retrievers improve the value and relevance of the LLM response for the user."* (p.329)

**retriever**는 vector database에 인덱싱된 textual data에서 관련 fact를 반환해 LLM prompt를 augment 한다. 정확하고 최신의 관련 정보로 prompt를 augment 함으로써 사용자에게 LLM 응답의 가치·관련성을 높인다.

**How:** Prompt Builder에서 retriever를 쓰려면, Setup의 Quick Find에서 `Prompt` 입력 → **Prompt Builder** 선택.

> [!note] PDF에 retriever 설정 절차의 UI 스크린샷이 있음 — 본 wiki에는 텍스트 단계 설명만 둔다(다이어그램 재현하지 않음). PDF가 텍스트로 추출한 번호 단계(verbatim):
> 1. LLM에 content 생성 지시(instruction) 제공.
> 2. Prompt Builder resources selector에 retriever 추가 후 **Einstein Search** 선택.
> 3. configuration side panel로 retriever가 반환하는 dataset 정제.
> 4. prompt template을 검토·정제·저장 → 테스트·준비 완료 시 activate 해 사용 가능하게 만듦.

### Harmful Content 알림 — View Harmful Content Notification in a Prompt Response

**Release:** July '24 (sandbox 2024-07-09, production 2024-07-11 rolling)

> PDF 원문: *"Quickly identify harmful language in prompt responses for safer, inclusive interactions, and make sure nothing harmful slips through."* (p.331)

prompt 응답의 harmful language를 빠르게 식별한다.

**How:** prompt를 작성·저장·미리보기 → prompt 응답에 harmful content가 있으면 응답 위에 **Harmful Content** badge가 표시된다.

### 민감 데이터 마스킹 표시 — View Masking of Sensitive Data in Prompts

**Release:** June '24 (week of June 24, 2024)

> PDF 원문: *"Einstein Trust layer masks sensitive data from the LLM by sending placeholder text. Now, you can see the placeholder text in the prompt resolution. In the response, you can see the demasked data added back in by Salesforce. A summary of all masked data for the response appears in the Data Masking Details dialog."* (p.331)

Einstein Trust Layer는 placeholder text를 보내 LLM에서 민감 데이터를 마스킹한다. 이제 prompt resolution에서 placeholder text를 볼 수 있고, 응답에서는 Salesforce가 다시 넣은 demasked 데이터를 볼 수 있다. 응답의 모든 마스킹 데이터 요약은 **Data Masking Details** 다이얼로그에 표시된다.

### 대형 프롬프트 지원 — Work with Large Prompts

**Release:** August '24 (week of August 12, 2024)

> PDF 원문: *"When a prompt is too large for the model to use, an error no longer occurs. Now, a summary is generated automatically in the Resolution panel. You can choose to keep using the summarized prompt or create a smaller prompt."* (p.331)

prompt가 모델이 쓰기에 너무 크면 더 이상 에러가 발생하지 않는다. **Resolution** 패널에 요약이 자동 생성되며, 요약된 prompt를 계속 쓰거나 더 작은 prompt를 만들 수 있다.

### 하나의 Apex/Flow로 여러 템플릿 재사용 — Use One Apex Class or Flow in Multiple Prompt Templates

**Release:** August '24 (August 26, 2024부터)

단일 Apex class 또는 prompt-triggered flow를 prompt template type과 무관하게 여러 template에 적용할 수 있다.

> PDF 원문: *"The inputs to the prompt template must include all the inputs to the Apex or flow. For flows, all inputs are considered required and must be present in the prompt template. For Apex, inputs are optional unless annotated as required. Optional Apex inputs don't have to be present in the prompt template. Apex and flows with no parameters work with all prompt templates."* (p.330)

**input 규칙(verbatim 요지):**
- prompt template의 input은 Apex/flow의 모든 input을 포함해야 한다.
- **flow:** 모든 input이 required로 간주되어 prompt template에 존재해야 한다.
- **Apex:** input은 required로 annotate 되지 않는 한 optional이다. optional Apex input은 prompt template에 없어도 된다.
- **parameter 없는 Apex·flow는 모든 prompt template과 동작한다.**

**How:** 선택한 prompt template type 기반 automatic input을 쓰거나 input을 수동 구성. 예: account input이 필요한 Field Generation template과 account input이 필요한 Record Summary template이 같은 underlying flow를 쓸 수 있다.

---

## Einstein Platform / Einstein Studio

### Einstein Studio in Data Cloud (허브)

> PDF 원문: *"Explore new Einstein Studio capabilities such as autoselection, metrics, and alerts. Simplify how you manage your AI models with enhanced permissions, navigation, and user interface... Learn more about Einstein Studio in the Data Cloud release notes."* (p.325)

**Where:** Data Cloud — Enterprise · Performance · Unlimited · Developer 에디션.

> ⚠️ Einstein Studio 세부 항목은 Einstein 챕터에 상세 본문이 없고 **Data Cloud 챕터로 위임**된다(p.316 인덱스 표 cross-ref). Einstein 챕터에서는 인덱스 cross-ref만 존재:
> - Manage AI Models in Einstein Studio
> - Power Your Generative AI Using Anthropic Models with Prompt Builder
> - Power Your Generative AI with Google Gemini and Prompt Builder
> - Create and Customize Retrievers in Einstein Studio
> - Leverage Alerts to Evaluate the Quality of Your Predictive Model
> - Let Einstein Autoselect the Best Factors for Your Use Case
> - Evaluate Your Model Performance with Activity Metrics
> - Access Models Quicker with the Updated Einstein Studio Navigation
> - **Einstein Studio Legacy Tab Is No Longer Available in Data Cloud** (제거/no-longer-available)

### 모델 지원 — Explore More Anthropic, Google, and OpenAI Models on the Einstein Platform

**Release:** August '24

> PDF 원문: *"We added support for Anthropic Claude 3 Haiku, Opus, and Sonnet and for Google Gemini 1.5 Pro and OpenAI GPT-4o on the Einstein Platform. Use Prompt Builder and Model Builder to build and test prompts with all our supported models."* (p.333)

신규 지원 모델(전수):
- **Anthropic Claude 3 — Haiku · Opus · Sonnet** (3종 모두)
- **Google Gemini 1.5 Pro**
- **OpenAI GPT-4o**

Prompt Builder·Model Builder로 모든 지원 모델에서 prompt를 빌드·테스트할 수 있다.

#### GPT 3.5 Turbo 16k 종료 예고 — OpenAI GPT 3.5 Turbo 16k and Azure OpenAI GPT 3.5 Turbo 16k Shutdown Date Approaching (RETIREMENT)

**Release:** August '24 (matrix)

> PDF 원문: *"OpenAI announced a shutdown date for GPT 3.5 Turbo 16k of 9/13/2024. Azure announced a shutdown date for Azure OpenAI GPT 3.5 Turbo 16k of 11/01/2024. After the shutdown date, you can't send requests to these models using Prompt Builder, Einstein Studio in Data Cloud, or your application. Requests are rerouted to GPT 3.5 Turbo (for GPT 3.5 Turbo 16k) and Azure OpenAI GPT 3.5 Turbo (for Azure OpenAI GPT 3.5 Turbo 16k)."* (p.334)

| 모델 | shutdown 날짜 | 리라우팅 대상 |
|---|---|---|
| **OpenAI GPT 3.5 Turbo 16k** | **2024-09-13** | GPT 3.5 Turbo |
| **Azure OpenAI GPT 3.5 Turbo 16k** | **2024-11-01** | Azure OpenAI GPT 3.5 Turbo |

shutdown 이후에는 Prompt Builder·Einstein Studio(Data Cloud)·자체 application에서 해당 모델로 요청을 보낼 수 없다. 응답이 바뀔 수 있으므로 가능한 한 빨리 새 모델로 prompt·copilot·application을 테스트할 것을 권장한다.

### Einstein Data Library — Ground Generative AI Responses with Einstein Data Library **(Generally Available)**

**Release:** August '24

> PDF 원문: *"Einstein Data Library indexes your knowledge articles and fields so that Einstein knows which information to ground responses on. Using this index, Einstein can quickly check the accuracy of responses against your Knowledge base, ensuring you get the best results."* (p.324)

knowledge article·field를 인덱싱해 Einstein이 어떤 정보로 응답을 grounding할지 알게 한다. 이 인덱스로 Knowledge base 대비 응답 정확도를 빠르게 확인한다.

**Where:** Lightning Experience — Enterprise · Unlimited 에디션 + Einstein for Sales / Einstein for Platform / Einstein for Service add-on.

**How(verbatim 요지):** Setup → **Einstein Data Library** → **New Library** → 라이브러리 이름·API 이름 입력 후 저장 → identifying field·content field 선택, data category로 knowledge article 필터. **Data Library는 Knowledge object만 지원한다(Data Libraries support Knowledge objects only).** 설정 후 AI feature에 라이브러리 할당. 여러 data library를 만들어 여러 feature에 할당할 수 있으나, **각 feature는 한 번에 하나의 data library만 사용한다(each feature uses one data library at a time).**

### Models API — Connect Your Application to Large Language Models with Models API **(Beta)**

**Release:** July '24 (July 2024부터)

> PDF 원문: *"Models API enhances your application with large language models (LLMs) from Salesforce partners... You can also bring your own LLM (BYOLLM) credentials from Amazon Bedrock, Azure OpenAI, OpenAI, and Vertex AI to access models enabled by Salesforce."* (p.325)

Salesforce 파트너의 LLM으로 application을 강화한다. system prompt로 브랜드 voice·tone을 다듬는 등 생성형 AI 시나리오에 활용. **BYOLLM(bring your own LLM)** 자격 증명을 **Amazon Bedrock · Azure OpenAI · OpenAI · Vertex AI** 에서 가져올 수 있다.

**Where:** Lightning Experience — Enterprise · Performance · Unlimited + Einstein for Sales / Einstein for Platform / Einstein for Service add-on.
**Who:** Data Cloud와 Einstein permission set이 있는 Salesforce 고객.
**How(verbatim):** *"Developers can access Models API with REST or Apex."*

> [!note] Einstein 챕터에는 Models API의 **구체적 Apex/ConnectApi 클래스명이 명시되지 않았고 코드 블록도 없다**. 구체 클래스·메서드는 본 노트에서 fabricate 하지 않는다. 개발자 상세는 **Einstein Generative AI Developer Guide** 를 참조.

> Beta note(verbatim): *"This feature is a Beta Service. Customer may opt to try such Beta Service in its sole discretion. Any use of the Beta Service is subject to the applicable Beta Services Terms provided at Agreements and Terms."*

### Einstein Data Prism — Get Optimized Einstein Responses with Einstein Data Prism

**Release:** August '24 (matrix); 기능은 **September 2024**부터

> PDF 원문: *"With Einstein Data Prism, automatically ground your large language models (LLMs) and gain more accurate and relevant responses to utterances or prompts. Einstein Data Prism is automatically enabled in approved apps."* (p.334)

LLM을 자동 grounding해 utterance·prompt에 더 정확하고 관련성 높은 응답을 얻는다. **approved app에서 자동 활성화**된다.

### Geo-Aware LLM Routing — Geo-Aware LLM Request Routing Is Available in the Einstein Generative AI Platform

**Release:** July '24 (July 2024부터)

> PDF 원문: *"The Einstein generative AI platform now routes large language model (LLM) requests to the servers that are closest to where your Einstein generative AI platform instance is located... If a model isn't available in a nearby region, the requests are routed to the US."* (p.333)

LLM 요청을 Einstein generative AI platform instance에 가장 가까운 서버로 라우팅한다. 인접 지역에 모델이 없으면 US로 라우팅된다.

### Supported Models 페이지 — Manage your Models on the Supported Models Page

**Release:** July '24 (week of July 1, 2024)

> PDF 원문: *"View platform-supported models for Prompt Builder and Einstein Studio in one place. Identify model depreciation schedules, and learn the steps to migrate from one model to the next."* (p.334)

Prompt Builder·Einstein Studio의 platform 지원 모델을 한 곳에서 보고, 모델 deprecation 일정을 식별하며 모델 마이그레이션 단계를 학습한다. Salesforce Help의 **Large Language Model** 토픽을 북마크.

### Einstein Trust Layer — Get More Trust Layer Audit Dashboards and Reports

**Release:** July '24 (mid-July 2024)

Data Cloud에 사전 빌드된 dashboard·report를 추가해 Einstein Trust Layer 메트릭을 모니터·검증한다. prompt·응답의 데이터 마스킹 동작을 확인하고 toxicity 같은 content safety 이슈를 탐색한다.

> How(verbatim 요지): Einstein Generative AI Setup에서 **Einstein Generative AI Data Collection and Storage** 기능을 켜면 최신 report·dashboard 사용 가능. *"If you previously installed the Einstein Generative AI and Feedback Data report package, you can now uninstall it. The package is no longer necessary for accessing the audit and feedback reports and dashboards."* 이 업데이트는 **Einstein Trust Layer dashboard(dynamic)** 를 포함하며, dynamic dashboard이므로 **사용 가능한 dynamic dashboard 총 개수에 카운트된다.** (p.326)

### 기타 — Locales / Usage Type

- **Use Supported Locales in the Einstein Generative AI Platform** (June '24): Einstein Generative AI Platform이 모든 region에서 **English · French · German · Italian · Japanese · Spanish** 지원. (p.333)
- **Use the Starter Usage Type for Lower Cost Models** (June '24): **BYO-LLM(Bring Your Own Large Language Models)** 사용량이 이제 **Starter usage type**으로 계산된다. 자체 모델을 가져오는 고객의 비용을 줄이며, 모델 구성 시 자동 할당. (p.334)

### RAG in Data Cloud — Supercharge Einstein Generative AI with Retrieval Augmented Generation (RAG)

**Release:** August '24 (week of August 19, 2024)

> PDF 원문: *"You can now augment prompt templates with unstructured content organized in the vector database in Data Cloud. Surface relevant information in your prompts from proprietary data, such as emails, meeting notes, service replies, article answers, and other types of unstructured content."* (p.332)

Data Cloud의 vector database에 구성된 unstructured content로 prompt template을 augment 한다 — 이메일·meeting note·service reply·article answer 등 독점 데이터의 관련 정보를 prompt에 노출.

**Where:** Enterprise · Performance · Unlimited + Einstein for Sales / Einstein for Platform / Einstein for Service add-on.

#### Vector Search · Hybrid Search **(Hybrid Search는 Beta)**

> PDF 원문: *"Vector search produces semantically aware query results while hybrid search combines vector search with keyword search to handle domain vocabulary and provide users with the most relevant results."* (p.332)

- **Vector Search:** 의미론적으로 인식하는(semantically aware) 쿼리 결과 생성.
- **Hybrid Search (Beta):** vector search + keyword search를 결합해 domain vocabulary를 처리하고 가장 관련성 높은 결과 제공.

> ⚠️ 인덱스 표(p.316) cross-ref: "Enhance Your AI and Automation Strategies with Unstructured Data in Data Cloud", "Improve Search Accuracy with Hybrid Search **(Beta)**", "Use Vector Search in Generative AI, Automation, and Analytics Tools" — 상세 본문은 **Data Cloud 챕터로 위임**.

---

## Einstein for Developers (Beta)

> ⚠️ Summer '24 **Einstein 챕터(p.313–334)에는 "Einstein for Developers" 전용 항목이 없다.** "Einstein Development" 섹션의 유일한 항목은 위의 **Models API (Beta)** 다. VS Code 확장 등 Einstein for Developers 관련 별도 항목은 이 챕터에 나타나지 않으며(Development 챕터에 있을 수 있음), 본 노트는 추측해 작성하지 않는다.

개발자 통합 상세(Models API, 신규 invocable action 등)는 → [[Summer '24/Development]]

---

## Einstein 적용 — Clouds 맥락

Clouds 노트가 1줄로 위임하는 AI 상세를 여기에 둔다. (Sales/Service 등 cloud별 비-AI 변경 전반은 [[Summer '24/Clouds]] 참조.)

- **Einstein for Sales / Einstein for Service (add-on):** 위 Copilot/Prompt Builder/Models API 대부분이 **Einstein for Sales · Einstein for Service · Einstein for Platform** add-on(또는 Enterprise/Performance/Unlimited 에디션)에서 동작한다.
- **Work Summaries — Customize Your Work Summaries in Copilot (Generally Available):** Voice/Messaging/Chat transcript 요약. Einstein이 Copilot에서 Work Summaries를 작성하는 방식을 prompt template에 포매팅 규칙/제약을 추가해 커스터마이즈(week of July 8, 2024; 상세 p.776). *"Use Einstein Work Summaries in Additional Languages"* (August '24)도 추가.
- **Einstein Bots (Generative AI 연관):** Einstein Platform 하위에 상세 본문 존재 — 아래.
- **Data Cloud AI:** Einstein Studio·RAG·Vector/Hybrid Search 등 모델·검색 인프라 상세는 Data Cloud 챕터로 위임(위 cross-ref).

### Einstein Bots (Generative-AI 연관)

> PDF 원문(섹션 intro): *"if you have Einstein Copilot, generate conversational answers to customer questions by connecting the Answer Questions with Knowledge copilot action to your bot."* (p.316)

#### Required Responses — Get the Information Your Team Needs with Required Responses (June '24)
Question dialog step에 응답을 필수로 지정하면, 고객 응답이 entity 요구사항을 충족할 때까지 봇이 질문을 반복한다. **How:** Bot Builder의 Question dialog step → Step Properties 패널에서 **Require a Response** 활성화 후 저장. **Where:** Enterprise · Performance · Unlimited · Developer 에디션.

#### Generative Knowledge Answers — Answer Questions Easily with Knowledge and Generative AI (June '24)
**Generative Knowledge Answers**로 고객 질문에 대화형 답변을 생성한다.
> PDF 원문: *"Generative Knowledge Answers searches for relevant information in your knowledge articles using the Answer Questions with Knowledge copilot action. If the copilot action finds information, the copilot platform sends an AI-generated response to the bot... Currently, this feature is available in English only."* (p.317)
**When:** July 2024부터. **Who:** Knowledge license 필요. **Where:** Enterprise · Performance · Unlimited + Einstein for Sales/Platform/Service add-on, 또는 Einstein 1 Service Edition.
**How:** Lightning Knowledge 설정 → Bot Builder의 Bot Overview → Settings의 Knowledge 섹션에서 **Use features that intelligently search for knowledge articles with this bot** 선택 → knowledge feature로 **Copilot Action: Answer Questions with Knowledge** 선택.

#### Run Flows in Bot User Context **(Release Update)** (June '24)
봇이 시작한 flow가 봇 연관 user profile·permission set·sharing rule로 object permission·field-level access를 결정한다(이전엔 system context). Summer '23에 처음 제공.
> When(verbatim): *"Salesforce enforces this update in Winter '25."* → 강제 시점은 **Winter '25**.

#### New Invocable Actions for Einstein Bots (June '24)
Lightning Knowledge를 활성화해야 한다.
> PDF 원문: *"Use the new searchKnowledgeArticles, getDataCategoryGroups, and getDataCategoryDetails actions. Introduced in API version 56.0, these actions have been added to the Actions Developer Guide... Use the new searchKnowledgeArticles, getDataCategoryGroups, and getDataCategoryDetails values in the existing actionType field on the existing Flow metadata type."* (p.318)
- 신규 invocable action: **searchKnowledgeArticles · getDataCategoryGroups · getDataCategoryDetails** (API v56.0 도입, Actions Developer Guide).
- Flow metadata type의 기존 **actionType** 필드에 동일 값 추가(Metadata API Developer Guide).

#### View Standard Bot Reports in the Summer '24 Folder (June '24)
standard bot metric type·개별 report에 Spring '24 대비 변경은 없으나, **Einstein Bot Reports Summer '24** 폴더에서 모든 report의 최신 버전에 접근 가능. **Where:** Lightning Experience + Salesforce Classic, Enterprise · Performance · Unlimited · Developer 에디션.

---

## 관련 패턴 노트 (업데이트 필요)

- Models API(Beta)가 GA로 전환되면 → 관련 Apex namespace/ConnectApi reference 노트 작성·보완 검토 필요.
- Generative Knowledge Answers·Answer Questions with Knowledge copilot action이 봇에 통합됨 → Einstein Bots 패턴 노트(있을 경우) 보완 검토 필요.
- 위 두 항목은 명시적 reference 페이지가 wiki에 아직 없어 링크하지 않는다(silent broken link 방지).

---

## 관련 노트

- [[Summer '24]] — Summer '24 릴리즈 허브
- [[Summer '24/Clouds]] — Sales/Service/Data Cloud (Einstein for Sales/Service, Work Summaries GA, Data Cloud AI의 cloud별 맥락)
- [[Summer '24/Automation]] — Flow Builder & Orchestration (prompt-triggered flow, Run Flows in Bot User Context 등 Flow 쪽 상세)
- [[Summer '24/Development]] — Apex · API · Flow · Metadata (Models API의 REST/Apex 개발자 상세, Einstein for Developers)
- [[Release MOC]] — 전체 릴리즈 노트 목차
