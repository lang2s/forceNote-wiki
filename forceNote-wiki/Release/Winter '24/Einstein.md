---
tags: [release, winter_24, einstein, ai, generative-ai]
source: salesforce_winter24_release_notes.pdf
created: 2026-06-16
aliases: [Winter '24 Einstein, 윈터 24 아인슈타인, Einstein Work Summaries Service Replies GA]
---

# Winter '24 — Einstein

> 허브: [[Winter '24]]
> Winter '24(API v59.0)의 Einstein/AI 영역 — **Agentforce·Einstein Copilot 이전 세대.** Einstein Trust Layer, Prompt Builder(Pilot), Einstein Work Summaries(GA), Einstein Service Replies(GA), Einstein for Service Grounding(GA), Article Answers for Bots(GA), Cross-Lingual Intent Model(GA), Einstein Search, 그리고 Einstein Vision and Language 은퇴(2024년 5월).

---

## 개요

이 노트는 Winter '24 릴리즈 노트의 **Einstein 섹션**(physical p.286~292)과 cloud 챕터에 흩어진 생성형 AI 기능을 모은 spoke다.

> [!note] **이 릴리즈는 Agentforce / Einstein Copilot 이전이다.** Winter '24에는 "Agentforce"도, "Einstein Copilot"도 존재하지 않는다. Prompt Builder는 이 PDF 기준 **Pilot**이다. Einstein Copilot·Prompt Builder GA는 다음 릴리즈([[Spring '24/Einstein]])에서 다룬다.

---

## Einstein Trust Layer

Einstein 생성형 AI 기능을 사용할 때 데이터 보안·안전을 보장한다. 데이터를 안전하게 하고 유해 콘텐츠로부터 보호하면서 가장 grounded되고 관련성 높은 응답을 제공하는 capability layer다.

- **Where:** Professional/Enterprise/Performance/Unlimited/Developer editions.
- Einstein 생성형 AI 기능에 구현되어 있으며 Setup을 통해 활성화한다.

---

## Prompt Builder (Pilot)

> [!note] Prompt Builder는 이 PDF 기준 **Pilot**이다(GA 아님). PDF 원문: *"This feature is not generally available and is being piloted with certain Customers…"*

Prompt Builder는 Lightning Experience의 **Unlimited Edition**에서 제공된다. 사용하려면 **Einstein for Sales** add-on이 필요하다.

- **Generate Personalized Sales Emails with Prompt Builder (Pilot)** — Sales Email prompt template. merge field, flow, Apex 사용. 권한: Einstein GPT Prompt Template User, Einstein Sales Emails.
- **Use Generative AI to Populate Field Values with Prompt Builder (Pilot)** — field generation prompt template.

---

## Einstein Work Summaries with Generative AI (GA)

AI 생성 case 요약으로 agent의 시간을 아낀다(GA). agent-고객 간 Chat 대화를 바탕으로 Einstein이 summary, issue, resolution을 예측·작성한다.

- **Bring Agents and Supervisors Up to Speed with Mid-Conversation Summaries** (Conversation Catch-Up) — 전환된 voice call/messaging session에 합류하거나 supervisor가 모니터링할 때 실시간 요약. 영어 전용. Setup: Einstein Work Summaries 페이지 → Conversation Catch-Up 탭.

> ⚠️ **언어 표기 충돌(둘 다 기록):** 컴패니언 항목 **"Use Work Summaries in More Languages"** (verbatim): *"Now generally available, Einstein Work Summaries supports five more languages: French, German, Italian, Japanese, and Spanish."* → 영어 포함 **6개 언어: English, French, German, Italian, Japanese, Spanish.** 그러나 Work Summaries **GA 상세 페이지의 "Where"** 절은 *"Work Summaries is available only in English (US)."*라고 한다. 두 진술이 PDF 내에서 충돌한다. 본 노트는 더 나중에 정정된 **6개 언어** 표기를 채택하고("More Languages" 항목, Dec 11 Release Note Change에서 추가), GA 페이지의 "English (US) only"는 이전 Where 절로 각주 처리한다.

---

## Einstein Service Replies (GA)

- **Optimize Agent Productivity and Response Quality with Einstein Service Replies (Generally Available)** — chat용 실시간 reply 추천. Unlimited Edition + Service Cloud Einstein + Einstein GPT for Service add-on. Setup: Einstein Reply Recommendations 페이지. Service Replies User permission set.
- **Save Agents Time and Improve Accuracy with Grounded Einstein Service Replies (Generally Available)** — Knowledge base에 grounded된 reply.
- **Solve Customer Cases Quickly with Service Replies for Email (Generally Available)** — Knowledge article 기반 AI 이메일 응답. Lightning email composer. article dropdown의 "Draft Einstein Response".
- **Use Service Replies for Chat in More Languages** (verbatim): *"Now generally available, Einstein Service Replies for Chat supports five more languages: French, German, Italian, Japanese, and Spanish."* (영어 포함 6개.)
- **See the Knowledge Article Einstein Used to Draft Grounded Service Replies** — source article로의 "Knowledge" 링크.

---

## Einstein for Service Grounding (GA)

- **Ground Einstein for Service in Your Company's Data (Generally Available)** — 생성형 응답을 Knowledge와 Case 필드에 기반(ground)한다. Unlimited Edition + Service Cloud Einstein + Einstein GPT for Service add-on. Setup: Einstein for Service: Grounding 페이지.

---

## Article Answers AI for Bots (GA)

(verbatim) *"Article Answers is now generally available in English, French, German, Italian, Portuguese, and Spanish."* Article Answers는 machine learning과 봇 대화 내 article을 결합한다. FAQ 봇을 빠르게 만들거나 봇을 knowledge base에 연결한다. feedback collection dialog, event logging, standard report 제공.

- Setup: Einstein Bots Setup → Smart Features 탭 → Article Answers → Get Started.

---

## Cross-Lingual Intent Model (GA)

(verbatim) *"Upgrade to the cross-lingual intent model, now generally available… New in Winter '24, get intent and system entity recognition support for 19 additional languages (beta)."*

- **Where:** Enterprise/Performance/Unlimited/Developer.
- **2023년 10월 30일 주부터** 새로 생성·클론된 봇은 cross-lingual intent model을 기본값으로 사용한다.
- cross-lingual intent model은 **intent당·언어당 단 한 개의 utterance(as little as one)** 로 학습할 수 있다.
- 전환: Bot Overview → Intent Enhancements → "Use the Cross-Lingual Intent Model with this bot."
- **19개 추가 언어(beta)** 의 intent·system entity 인식 지원. Release Note Changes는 beta에서 **Arabic** 지원을 기록하며, **Hebrew** 지원은 "isn't quite ready"로 보류됐다.

```text
// 구조 예시 — 실제 PDF 다이어그램 아님
// cross-lingual intent model 학습 데이터 요건(개념 정리)
이전 모델 :  intent당·언어당 utterance 다수 필요
cross-lingual :  intent당·언어당 utterance 1개(as little as one)로 학습 가능
지원 언어     :  기존 + 19개 추가(beta) — Arabic(beta) 포함, Hebrew 보류
```

**관련 봇 기능:**
- **Create and Share Your Own Custom Bot Templates (Generally Available)** — GA.
- **Build Bots Faster with Bot Blocks (Generally Available)** — GA.
- Route Conversations to an Enhanced Bot with Fewer Clicks; Get Your Bot Ready for Launch with the Enhanced Bot Audit; **Save Agents' Time with New Messaging Components for Enhanced Bots (Beta)** — Beta.

---

## Einstein Search

검색 결과 수신 방식을 개선한다. Search Manager에서 검색 가능한 standard·custom object를 구성하고 search storage insight를 캡처한다. Einstein Search Answers로 knowledge article에서 구체적 답변을 받을 수 있다.

- 관련 Beta: **Configure Searchable Objects for Profiles More Easily (Beta).**

---

## Einstein Conversation Mining

email conversation 또는 transcript로 report를 빌드한다.

- **Include Email Conversations When You Build Your Conversation Mining Reports (Generally Available)** — GA (email-to-case 전용).

---

## Commerce Einstein

- Commerce store의 product field를 Einstein으로 강화(한 단계에서 여러 product field 생성), Einstein Frequently Bought Together 컴포넌트.

---

## Einstein Vision and Language — 은퇴

(verbatim) *"Einstein Vision and Language is being retired in May 2024."* Einstein OCR 문서는 Salesforce Developer Docs의 새 위치(developer.salesforce.com/docs)로 이전된다.

- **Where:** Group/Professional/Enterprise/Performance/Unlimited/Developer/Contact Manager.
- 관련 기능 항목: "Access Einstein Optical Character Recognition (OCR) on Developer Docs."
- 또한 Einstein Account Insights·Opportunity Insights가 은퇴하면서 Metadata API의 `AccountInsightsSettings`·`OpportunityInsightsSettings`가 deprecated된다.

---

## 관련 노트

- [[Winter '24]] — 상위 릴리즈 허브
- [[Winter '24/Clouds]] — Service(Einstein for Service)·Sales(Einstein Conversation Insights)·Commerce(Einstein)의 cloud별 맥락
- [[Winter '24/Clouds-Industries]] — Health Cloud 등 산업별 AI 맥락
- [[Winter '24/Development]] — Develop Platform Apps with Ease 등 개발자 대상 생성형 AI
- [[Spring '24/Einstein]] — 다음 릴리즈: Einstein Copilot 데뷔 + Prompt Builder GA
- [[Release MOC]]
