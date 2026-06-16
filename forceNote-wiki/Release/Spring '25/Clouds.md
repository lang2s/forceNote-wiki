---
tags: [release, spring_25, clouds, sales, service, data-cloud, commerce, analytics, slack, field-service]
api_version: v63.0
release_date: 2025-02
created: 2026-06-16
source: salesforce_spring25_release_notes.pdf (Salesforce Spring '25 Release Notes, Tier 2)
aliases: [Spring '25 Clouds, 스프링25 클라우드, Sales Cloud, Service Cloud, Data Cloud, Commerce, Experience Cloud, Field Service, Marketing, Revenue Cloud, Analytics, Slack, CMS, Omnistudio]
---

# Spring '25 — Clouds (Sales · Service · Experience · Commerce · CMS · Data Cloud · Analytics · Slack · Field Service · Marketing · Revenue · Omnistudio)

> 일반 클라우드(non-Industries)의 Spring '25(v63.0, 2025년 2월) GA/Beta/Pilot을 클라우드별로 전수 정리. **Service**가 가장 변화가 크고(GA 6·Beta 5·Pilot 5·Release Update 5, Voice 기능은 Voice·Routing 영역에 중복 게재되어 dedup), **Field Service**(GA 7)·**Analytics**(GA 8)가 그 다음이다. Data Cloud는 월별(February/March/April/May 2025) 롤아웃 모델을 쓴다. Slack은 stub(별도 릴리즈 노트 포인터)이며, Omnistudio는 GA/Beta 태깅 항목이 없다. 산업 특화 클라우드는 → [[Spring '25/Industries]].

---

## 개요 — 클라우드별 GA/Beta 건수

> body-tagged(상세 블록에 명시적 maturity가 붙은) 항목 기준. cross-cloud 중복(Data Cloud↔Analytics의 Data Cloud Reports)·cross-area 중복(Service Voice↔Routing)은 1회만 카운트한다.

| 클라우드 | GA | Beta | Pilot/Closed Beta | 비고 |
|---|---|---|---|---|
| Sales | 0 | 1 | — | Seller-Focused Mobile은 Winter '24 GA. Customize Seller-Focused Mobile Experience만 Beta |
| Service | 6 | 5 | Pilot 5 | Voice 기능 Voice·Routing 중복 → dedup. Release Update 5건 별도 |
| Experience Cloud | 2 | 3 | — | Enhanced LWR Sites GA(RU)·Link Files GA. Experience Delivery·Record List·Local Dev Beta |
| Commerce | 2 | 1 | — | Guided Shopping GA·Digital Subscriptions GA. D2C Store Performance Beta |
| CMS | 0 | 1 | — | Content Taxonomy Beta(English only) |
| Data Cloud | 4 | 4 | — | 월별 롤아웃. Data Cloud Reports GA는 Analytics와 cross-cloud(여기 1회) |
| Analytics | 8 | 4 | — | Data Cloud Reports/Dashboards GA 포함. Tableau/MCI는 포인터 |
| Slack | 0 | 0 | — | stub(Salesforce for Slack Integrations Release Notes 포인터) |
| Field Service | 6 | 3 | — | Data Capture GA 다수. Field Service Setup·Intelligence Dashboards Beta |
| Marketing | 0 | 4 | — | core-GA 없음. Campaign Designer·MI Goals·MI Patterns·file enrichment Beta |
| Revenue Cloud | 2 | — | Closed Beta 2 | Usage Management GA. Advanced Configurator·Constraint Models Closed Beta |
| Omnistudio | 0 | 0 | — | maturity 태깅 항목 없음(전부 enhancement) |

> **cross-cloud 주의:** Data Cloud Reports and Dashboards GA(Highlight Min/Max Aggregates, Create Semantic Model Report Single Click, Bucket Columns, Advanced Formulas 등)는 **Analytics 섹션 안의 "Data Cloud Reports and Dashboards" 하위 영역**에 게재되며 Data Cloud와 겹친다. 본 노트는 상세를 Analytics 쪽에 두고 Data Cloud에서는 표기만 한다. **Unify Your Data Across Dashboards**(CRM Analytics)는 Data Cloud One companion org를 쓰는 cross-cloud 항목.

---

## Sales

> Intro: "Boost your sales teams' results with new features across Sales Cloud." 주요 영역: Agentforce for Sales, Sales Cloud Go, Sales Fundamentals, Einstein Conversation Insights, Sales Engagement, Salesforce Forecasting, Pipeline Inspection, Email/Calendar/Integrations, PRM, Sales Cloud Everywhere/Mobile, Salesforce Meetings.

### Agentforce for Sales
- **Monitor Agentforce Sales Coach and SDR Usage with Digital Wallet** — Digital Wallet의 Conversations consumption card가 Sales Coach Agent + Agentforce SDR + ASA Messaging(구 Agentforce Service Agent - Inbound) 사용량을 합산. Where: Digital Wallet은 Enterprise·Unlimited; Agentforce SDR은 Enterprise·Performance·Unlimited; Sales Coach도 Enterprise·Performance·Unlimited. Who: `View Consumption` 권한 또는 Your Account access.
- **Coach Sales Reps at Scale with Agentforce Sales Coach** — Opportunity 페이지의 신규 Agentforce Sales Coach Lightning page component. Qualification/Needs Analysis 단계 → sales pitch 연습; Proposal/Pricing Quote 또는 Negotiation/Review → role-play. 신규 Agent topics 3종, 신규 prompt template type "Sales Pitch Feedback". Where: Lightning Experience, Enterprise·Performance·Unlimited + Agentforce Sales Coach add-on. **When: late October부터.**
- **Enhance Agentforce Sales Coach Responses with a Data Library** — Agent Builder의 Select Data Step. **When: December 17, 2024부터.**
- **Scale Your Sales Funnel with Agentforce SDR** — Where: Enterprise·Performance·Unlimited + Agentforce SDR add-on. **When: October, 2024부터.** 필수: Sales Engagement, Einstein Activity Capture, Einstein Copilot, Einstein Generative AI, Salesforce Inbox, Automated Actions, Data Cloud.
- **Reach Out to All Kinds of Customers with Agentforce SDR** — lead 외 contacts·person accounts 지원. 레코드에 Account Name·Owner·email address 필수. **When: March 31, 2025부터.**
- **Engage with Prospects in More Languages with Agentforce SDR** — French·Italian·German·Spanish·Japanese·Portuguese. **When: March 31, 2025.**
- **Test Agentforce SDR Email Generation in Agent Builder** — **When: March 31, 2025.**
- **Batch Test SDR Scenarios with Agent Builder Testing Center** — CSV 업로드, quality scoring. **When: May 5, 2025부터.**
- **See Your SDR Agent's Work at a Glance** — Agent Control Center. metrics: First Touch Scheduled, In Progress, No Response, Opted Out, Meeting Requested, Replied, Errors. 권한: Use Agentforce SDR. **When: May 5, 2025.**

> Agentforce for Sales 상세는 → [[Spring '25/Agentforce]] 참조.

### Sales Cloud Go · Sales Fundamentals
- **View and Assign Permission Sets and Monitor Usage in Sales Cloud Go** — Where: Pro Suite·Professional·Enterprise·Performance·Unlimited·Einstein 1 Sales Edition. Who: View Setup and Configuration; Customize Application.
- **Track Progress Toward Sales Account Plan Objectives More Easily** — calculation definition; prebuilt 2종 기본. Where: Enterprise·Performance·Unlimited + Einstein 1 Sales Edition.
- **Coordinate Your Sales Team's Activities with More Transparency** (Delivered Idea) — sales action plans가 Industries action plans 확장, 고유 Event item type. **When: rolling, Spring '25부터 — 전체 고객은 late March~mid-April 2025.**
- **Discover Untapped Selling Opportunities** — Account Plan Whitespace Map component.
- **Take Advantage of the Increased Custom Field Limit for Activities** — activity 4억 건 미만 org은 custom field 한도 **100 → 300**. Where: Enterprise·Performance·Unlimited.

### Einstein Conversation Insights
- **Use Generative AI in All Languages Supported by Einstein Conversation Insights** — Call Summaries·Call Explorer·Generative Conversation Insights를 **37개 언어** 지원(Arabic·Bulgarian·Catalan·Chinese(Simplified/Traditional)·Croatian·Czech·Danish·Dutch·English 여러 variant·Finnish·French(CA/FR)·German·Greek·Hebrew·Hindi·Hungarian·Icelandic·Indonesian·Italian·Japanese·Korean·Latvian·Lithuanian·Norwegian·Polish·Portuguese(BR/PT)·Punjabi·Romanian·Russian·Serbian·Slovak·Spanish(ES/US)·Swedish·Thai·Turkish·Ukrainian·Vietnamese). **주의: Einstein Trust Layer가 커버하지 않는 언어 포함.** Sales Signals는 English only.
- **Use Call Explorer in Flows** — Explore Conversation standard action(screen·scheduled·record-triggered 전 flow 지원).

### Sales Engagement
- **Find Your Next Customer with Prospecting Center, a new Data Cloud App** — Fit·Engagement·Intent score(Data Cloud 기반). connectors: Zoominfo, Demandbase. Where: Performance·Unlimited.
- **Change Einstein Activity Capture Permissions for Sales Engagement Basic Users (Release Update)** — Sales Engagement Basic User permission set에서 Einstein Activity Capture 접근 제거. **When: January 1, 2025까지 권한 갱신.**

### Salesforce Forecasting
- **Collaborative Forecasts Is Now Pipeline Forecasting** — Where: Professional·Developer + Enterprise·Unlimited.
- **Improve Pipeline Forecast Visibility with Manager Judgments on Opportunity Splits** — opportunity split 기반 forecast type(opportunity product splits 제외).
- **Forecast Your Consumption-Based Business** — Consumption Forecasting(월/분기). Where: Enterprise·Unlimited + Einstein 1 Sales Edition.

### Pipeline Inspection
- **Get an Improved User Experience in Pipeline Inspection List View** — Read-Only 필드 정상 동작.
- **Close Date Predictions Has Been Retired** — Einstein Deal Insights 기능 Spring '25 은퇴. 대체: Einstein Opportunity Scoring.

### Sales Programs, Partner Tracks, In-App Guidance
- **Empower Your Sales Leaders with Enablement Analytics** — Manage Enablement Analytics 권한. Enablement add-on 필요.
- **Take Full Control of Your Enablement Settings with One Switch** — settings 페이지 Enablement 스위치.
- **Deliver In-App Guidance Quickly with Managed Packages** — prompts·walkthroughs용 2GP 관리형 패키지.

### Sales Performance Management
> **Note(40150):** 이 영역 기능들은 initial Spring '25 release에 포함되지 않으며 이후 추가될 수 있다.
- **Plan Accurate Quotas That Account for Ramp and Seasonality** — Quota Planning.
- **Publish Quota Plans to Pipeline Forecasting** — territory-based forecasting types.
- **Design Sales Strategies with a More Intuitive Experience** — Sales Planning navigation.
- **Simplify Activity Tracking and Reimburse for Qualified Travel Distances** — Salesforce Maps.
- **The Enhanced User Experience Is Now Standard** — Salesforce Maps legacy UX 제거.
- **New Permission Set for Communications with Hyperforce** — SF Maps Platform Integration User permission set.
- **Other Improvements (TABLE):**

| Product | What's Different |
|---|---|
| Sales Planning | CSV import·field matching 시 field type 자동 설정 |
| Territory Planning | Starts with 필터 연산자; territory와 descendant 일괄 제거; Shift+로 multi-select; territory 내 고유값 개수 식별 |
| Sales Territories | Administer Territory Operations 권한으로 특정 territory·descendant 관리; TerritoryAdminAssignment 표준 오브젝트를 **Salesforce API v63 이상**에서 구성 |
| Salesforce Maps | CSV 커스텀 데이터 소스 업로드 은퇴 예정 **May 16, 2025** — 대안: Visualize Custom Data Sources |

### Email, Calendar, and Integrations
- **Upgrade Your Service Account Connections to Org-Level OAuth 2.0 Authentication** — Microsoft가 **February 2025** Exchange Online의 ApplicationImpersonation role 은퇴 → Salesforce는 Einstein Activity Capture의 Office 365 service account OAuth 2.0 access 은퇴.
- **Hourly Single Email Send Limit for Case Lightning Email Composer (Release Update)** — 시간당 최대 **250 external recipients**. **When: Spring '25 enforce; Spring '25 이후 생성 org은 기본 ON.** 자동 UI 케이스 이메일은 QuickActionRequest 사용.
- **Maintain Access to the Outlook Integration** — Exchange Online only. 필수 scope: Calendars.ReadWrite.Shared, email, Mail.ReadWrite.Shared, offline_access, openid, profile, User.Read.
- **Use Agentforce with Your Gmail Integration** — Chrome side panel.
- **Increase Efficiency by Using the Gmail Integration in the Chrome Side Panel**.
- **Allowlist the Required Domain for Salesforce Inbox** — `*.svc.sfdcfc.net` 추가.
- **Salesforce for Outlook Is Being Retired in December 2027**.

### Partner Relationship Management
- **Expand and Maintain Shared Business with Trusted Partners** — Partner Connect; field mapping resend/delete; 신규 Update JSON 옵션. PRM add-on 라이선스 필요. vendor는 Opportunity의 Account Name·Primary Campaign Source lookup 필드 export 가능.

### Sales Cloud Everywhere · Mobile · Meetings
- **Access Your Records and Selling Metrics Easily in Everywhere** — My Records 페이지, recent records·goals component.
- **Prepare for Meetings Without Opening Your Laptop** — Seller-Focused Mobile Experience; "Ask Einstein" 필드 → "Ask Agentforce". 권한: Salesforce Mobile App: Native Seller Experience. (Note: Winter '24에 Seller-Focused Mobile Experience GA.)
- **Customize Seller-Focused Mobile Experience (Beta)** — Mobile Builder for Seller-Focused Experience (beta). Where: all editions; Android·iOS(Database.com 제외), mobile version 254.000부터.
- **Streamline Meeting Prep with Automatic Contact Enhancements** — Meeting Digest에 AI 생성 데이터(department group·seniority level·buyer attributes). contacts 전용(leads/users 제외).

### Other Changes
- **Einstein Automated Contacts Is Being Retired in February 2025** — 대체: Automatic Contact Creation in Einstein Activity Capture.

---

## Service

> Intro(45112): "Get Case Resolution Assistance at the Click of a Button (Generally Available). Monitor Real-time Conversations Between Agentforce Service Agents and Customers. Integrate Knowledge with Data Cloud." 하위 영역: Agentforce for Service Cloud, Einstein for Service, Employee Service, Service Data Kit, Service Insights, Channels, Knowledge, Entitlements and Milestones, Self Service, Routing, Feedback Management, Customer Experience Intelligence, Service Adoption.

> **중복 주의 (researcher 명시):** Voice 기능 일부는 **Voice(Channels)** 와 **Routing** 두 영역에 동일하게 게재된다 — "Manage Capacity via Status-Based Capacity for Voice (Beta)" = "Use Status-Based Capacity with Voice (Beta)"; "Route Work Items Through a Single System with Unified Routing for Voice (Pilot)" = "Route Voice Calls with Other Channels by Using Omni-Channel (Pilot)". 각 1건으로 dedup해 카운트.

> **SERVICE TOTALS(detail-block 기준):** GA 6 distinct(More Languages, Japanese, Get Case Resolution, Transition to Lightning Editor[dual GA/RU], Einstein Knowledge Edits, My Service Journey) · Beta 5 · Pilot 5 · Release Update 5.

### Agentforce for Service Cloud — Agentforce Service Agent
- **Chat with Agentforce Service Agent in More Languages (Generally Available)** — English·Japanese에 더해 French·German·Italian·Portuguese·Spanish가 certain locale에서 GA. **When: week of February 17, 2025부터.** GA 코드: English(en_AU/en_GB/en_US), Japanese(ja_JA), French(fr_FR/fr_CA), German(de_DE), Italian(it_IT), Portuguese(pt_BR/pt_PT), Spanish(es_ES/es_MX). How: Agent Builder → Language Settings.
- **Chat with Agentforce Service Agent in 9 More Languages (Beta)** — GA 7개 외 9개 추가. Beta 코드: Catalan(ca), Dutch(nl), Danish(da), Norwegian(no), Swedish(sv), Finnish(fi), Chinese Simplified(zh_CN), Chinese Traditional(zh_TW), Korean(ko). **When: week of March 3, 2025부터.** Beta Services Terms 적용.
- **Chat with Agentforce Service Agent in Japanese (Generally Available)** — English/French/German/Italian/Portuguese/Spanish에 Japanese 추가 GA. **When: January 2025부터.**
- **Choose Where Links Open in the Messaging Window for Web** — Messaging for Web.
- **Reduce Perceived Latency with Text Streaming** — Messaging for In-App and Web.
- **Take Actions with User Context in Messaging for Web** — credential-based user verification로 사용자 컨텍스트에서 액션(주문 조회/취소). 기존 token-based는 불가했음.
- **Markdown Supported for Agentforce Service Agent in Messaging for In-App and Web** — hyperlink·bulleted/numbered list·heading size(기존 plain text only).
- **Send Formatted Responses with Markdown in Messaging for In-App and Web** — **When: after March 3, 2025.**
- **Customize Progress Indicators for Agentforce Service Agent** — custom agent action 생성 시 progress indicator 작성.
- **Monitor Real-time Conversations Between Agentforce Service Agents and Customers (Release Update)** — supervisor가 Omni Supervisor에서 live messaging session 모니터링. AI agent에 **Raise Flag** 액션 추가. Where: Lightning Experience, Enterprise·Performance·Unlimited·Developer + Einstein for Service/Einstein Platform/Agentforce Service Agent add-on.
- **Flag Supervisors to Help with Agentforce Service Agent Conversations** — Raise Flag 액션으로 supervisor 알림.
- **Agentforce Service Agent is Now ASA Messaging in Digital Wallet** — "Agentforce Service Agent - Inbound" → **ASA Messaging in Digital Wallet**. consumption card가 ASA Messaging + Sales Coach + SDR 사용량 합산.
- **Enhance User Search Experience by Using Context-Driven Conversations** — site visitor의 real-time search context를 에이전트에 전달. (Self Service 영역의 "Resolve User Search Queries Faster…"와 동일 기능.)

### Agentforce Service Assistant
- **Service Planner is now Service Assistant** — Setup·Lightning component·Help에서 명칭 변경(권한 세트 이름은 불변). **When: April 3, 2025부터.** Admin은 `Service Planner Builder`, rep은 `Service Planner User` 권한 세트 필요.
- **Get Case Resolution Assistance at the Click of a Button (Generally Available)** — Service Assistant = Case record page의 AI assistant LWC. generative AI로 케이스 요약·제안 해결 단계 생성, Case data·Agentforce topics/actions/instructions에 grounding. Where: Lightning Experience, Enterprise·Unlimited·Developer + Service Cloud(및 Einstein for Service·Einstein 1). **When: Spring '25에 GA.** Who: `Service Planner User`. How: Service Assistant Setup 가이드 → Case record page에 component 추가 → Service Assistant Agent 생성.
- **Ground Service Assistant in Your Knowledge Base** — **Agentforce Data Libraries**로 grounding. **When(DELAY): 원래 April 3, 2025 → May 8, 2025 이후로 연기.** Service Assistant는 한 번에 한 data library, **Knowledge** data type만 지원.
- **Redraft Service Plans to Include New Case Information** — 케이스에 새 정보가 있고 완료 표시된 step이 없으면 **Redraft Plan** 버튼. **When: April 3, 2025부터.** April 3, 2025 이후 생성 plan만.
- **Provide Service Plan Email Updates to Customers** — **Draft Service Plan Email** quick action. **When: April 3, 2025부터.** Who: Service Planner User + Prompt Template User + Einstein for Service Email Assistant User.
- **Monitor Service Plan Performance with Service Insights** — Service Assistant metrics dashboard(Tableau + Data Cloud). **When: April 3, 2025부터.**

### Einstein for Service
- **Gain Insights from Customer Conversations in More Languages** (Conversation Mining) — French·German·Italian·Spanish 추가(기존 English only).
- **Mine Insights from Voice Conversations** — 신규 채널 **Voice**. Enhanced Conversations 선택 후 contact center channel type 선택.
- **Customize Service Replies for Email in Prompt Builder** — **Einstein Service Replies for Email** prompt template + **Get Grounding Data for Service Replies for Email** action. **When: January 6, 2025.**
- **Set a Default State So That Your Agents Decide When to Get AI-Generated Service Replies for Chat** — 세션 시작 시 즉시 표시 또는 Resume까지 일시정지. **When: February 2025부터.**
- **Enjoy Rich Text and Additional Supported Languages in Conversation Catch-Up** — Dutch·Mexican Spanish·Portuguese·Portuguese Brazilian·Swedish 추가, rich content(choices·choiceResponse).
- **Get a Quick Overview of a Case with Work Summaries for Case (Beta)** — Case Feed/Case Comments에서 AI 케이스 요약. **When: January 2025부터.** Beta Services Terms 적용. How: Service AI Grounding with Cases 설정 → **Draft a Case Summary with Einstein**.
- **Customize Work Summaries for Enhanced Messaging** — **Summarize Messaging Session** prompt template. **When: January 2025부터.**
- **Customize Work Summaries for Voice** — **Summarize Voice Call** prompt template. **When: January 2025부터.**
- **Customize Work Summaries for Case** — **Summarize Case** prompt template(기능 자체는 Work Summaries for Case beta). **When: January 2025부터.**

### Employee Service
> HR/Employee 경험. 대부분 UI/라이선스 기능(maturity tag 없음).
- **Simplify Information Access, Service Requests, and Networking with Alumni Portal** — Who: Alumni Portal Community User permission set license.
- **Experience Improved Clarity with the Renamed Employee Hub and HR Service Workspace** — Employee Hub → **Employee Portal**, HR Service Workspace → **HR Service Console**.
- **Equip Service Representatives with Historical Context by Rapidly Deploying a Preconfigured Timeline** — HR Service Console Employees 페이지의 **Timeline** component.
- **Efficiently Create Employee Records by Using CSV File Import** — **Employee2** + **Person Account** 오브젝트로 CSV import. How: App Launcher → CSV File Import → Import using Data Processing Engine(DPE).
- **Showcase Actions and Simplify Navigation with Navigation Tiles** — Employee Portal·Alumni Portal의 **Navigation Tiles** component.
- **Ascertain that Important Information Reaches Employees with CMS Collection** — CMS Collection carousel.
- **Streamline Employee Life Events with Employee Enablement Program** — onboarding·promotion 등 life event 프로그램.
- **Conveniently Comment on Cases By Using the Case Management Bot**.
- **Improve Accountability with Enhanced Approval Capabilities** — Approvals 탭의 **Work Guide** component, **Trace Approvals** 탭, 요청 recall.
- **Improve Employee Service by Managing Feedback with Feedback Management** — Closed 도달 시 survey 자동 발송.
- **Manage Workday Employee Data by Using Prebuilt MuleSoft Integrations** — Workday Org/Location/Manager Sync, Workday Employee Offboarding, Absence Manager, Employee Profile Update. **MuleSoft Direct** 활성 org.
- **Changed Object in Employee Service** — **EnablementProgram** 오브젝트 **Type** 필드에 신규 enum 값 **Employee Service Enablement Program**.

### Service Data Kit · Service Insights
- **Add More Service Data to Data Cloud for Greater Insights** — **Service Data Kit version 6.0**. Digital Engagement·Field Service data bundle 강화 + 신규 **Service Plan** data bundle(calculated insights). Service Intelligence·Field Service Intelligence·Service Insights 지원. **When: sometime in February 2025.**
- **Reduce Costs and Improve Operations with Service Insights** — Case·CSAT·Agentforce dashboard. Who: `Tableau Einstein Included App Business User`(사용), `Tableau Included App Manager`(관리).

### Channels — Email
- **Enjoy Improved Flexibility When Refining Automated Emails** — case email composer의 **Draft with Einstein**(free-form 지시, length/tone 조정).
- **Omni-Channel Flow for Email-to-Case Is Now Invoked Synchronously** — Email-to-Case 레코드(**Case, EmailMessage, Task, ContentDocument**) 커밋 직후 flow 호출.
- **Disable Ref ID and Transition to New Email Threading Behavior (Release Update)** — Ref ID threading 종료 → Lightning threading. subject/body의 secure token으로 매칭. **Winter '21 최초 제공, 강제 적용일 없음.**
- **Transition to the Lightning Editor for Email Composers in Email-to-Case (Generally Available) (Release Update)** — docked·case feed composer를 HTML 5 에디터로 교체. **Spring '24에 GA, 강제 적용일 없음.** 신규: Full-screen mode·Printing·Undo/Redo·Format painting·Emoji picker·Resizability·반응성 toolbar. 제거: 자동 표시 table controls·word/character count·붙여넣기 포맷 안내창.

### Channels — Messaging
- **Get Responses Faster with Agentforce Text Streaming in Messaging for In-App and Web** — partial response 실시간 표시.
- **Define Where Links Open in Messaging for Web** — `shouldOpenLinksInSameTab` snippet 설정.
- **Let Agentforce Service Agent Take Actions with User Context in Messaging for Web** — credential-based user verification. channel의 **User Verification** 체크박스.
- **Customize the Style of Text Message Bubbles** — message bubble 전용 custom LWC.
- **Warn End Users Before Automatically Inactivating Their Messaging Session** — inactivation timeout warning auto-response component.
- **Messaging on the Mobile App to Include Attachments** — mobile enhanced conversation component에서 attachment 전송.
- **Blur Potentially Harmful Content Sent to Service Reps in Attachments** — **Blur File Preview** 체크박스.
- **Help Customers Contact You During a Service Downtime** — custom fallback message.
- **More Customers Can End a Messaging Session** — verified(Web)·unverified(In-App) 모두 **End Chat** 가능.
- **Notify End Users When a Salesforce Org Migration Happens** — custom org migration error message.
- **Expand the Scope of Messaging for In-App and Web Engagement with Supported File Types** — 추가 지원: `.xml, .xls, .xlsx, .csv, .docx, .doc, .txt` (기존 `.pdf, .png, .jpeg, .jpg, .bmp, .tiff, .gif`).
- **Start a Messaging Session from a Contact, Account, or Lead Record** — outbound messaging(mobile·desktop). Messaging for Web 제외 전 채널.
- **Conversation Catch-up for Messaging to Include Rich Text and Additional Supported Languages** — Dutch·Mexican Spanish·Portuguese·Portuguese Brazilian·Swedish.
- **Collect Date Information from End Users in Secure Forms** — secure form이 **Date**·**DateTime** 필드 지원(신규 필드만).
- **The Enhanced Messaging Component Gets a Style Update** — End Chat·agent tools·Send Message가 원형 디자인.
- **Empower Reps to Resolve Cases Faster with Einstein Article Recommendations for Messaging (Pilot)** — 통화/세션 중 실시간 article 추천. Where: Messaging for In-App and Web, enhanced Facebook Messenger, enhanced WhatsApp.
- **Customize the Size of Your Customer-Facing Chat Window** — default width **320 px**, height **480 px**. Messaging for Web.
- **Use a Custom Font on Your Messaging Window** — static resource로 **.ttf/.otf/.woff2** 업로드, cache control **public**.
- **Insert Messaging Components in Service Rep Text Boxes…Using Lightning Console Methods** — 신규 **Set Messaging Component**·**Send Messaging Component** console method.
- **Improvements to Existing Lightning Console APIs** — `setAgentInput`(typing indicator), `conversationAgentSend`(choice messages 지원), `endUserNewMessage`(choice message 응답).
- **Remove All Messaging Components from a Web Page by Using an API** — **Remove All Components** API(먼저 **Clear Session** 호출).
- **Ingest Third-Party Bot Conversation History into the Service Console by Using an API** — **Conversation History API**.
- **Mass Delete User Information to Comply with GDPR by Using an API** — **Conversation Service API**로 Messaging End User·Messaging Session·Conversation·Conversation Entry·Conversation Participant·Participant Device·Intelligence Signals·Intelligence Signal Targets·Related Records·Participant·Context Param Maps·VoiceCall 삭제.
- **Optimize Business Processes Based on the Sentiment and Intent of Real-Time Messages (Pilot)** — generative AI로 sentiment/intent 분류. Where: Messaging for In-App and Web, enhanced Facebook Messenger, enhanced WhatsApp.
- **Get Added Support for Reply Messages in LINE** · **Save Time with Automated Outbound Messages for LINE** · **Use Rich Link Format in Enhanced LINE Links** — enhanced LINE channels.
- **Streamline User Interactions with Auto-Populated Language Data** — Messaging User 레코드에 **Language** 필드 자동 채움.

#### Bring Your Own Channel
- **Build Trust with Messaging Typing Indicators and Read and Delivery Receipts** — admin opt-in(Spring '25부터). Bring Your Own Channel for Messaging·CCaaS.
- **Customize the Messaging Experience Dynamically** — **Interaction Service API**의 `/agentWork` endpoint payload로 transfer 활성/비활성. Bring Your Own Channel for CCaaS.
- **Get Context Faster with Link Previews in Inbound and Outbound Messages**.
- **Stay Updated on Bring Your Own Channel Terminology** — Spring '25부터 **Bring Your Own Channel for Messaging**(외부 Messaging provider 연결), **Bring Your Own Channel for CCaaS**(외부 CCaaS provider 연결).

### Channels — Voice
> **Voice 영역 시각 자료 주의 (researcher 명시):** Voice의 각 detail 블록에는 3-column telephony-model 표가 반복된다 — 컬럼은 항상 **Service Cloud Voice with Amazon Connect | Partner Telephony from Amazon Connect | Partner Telephony**. pdftotext가 per-model 가용성 매트릭스(체크마크)를 평탄화해 동일 헤더만 남았다. **per-model Yes/No 값은 fabricate하지 않으며, 차별화 정보는 trailing availability 문장(Service+Sales vs Service+Sales+Government Clouds)뿐이다.**

- **Route Work Items Through a Single System with Unified Routing for Voice (Pilot)** — Omni-Channel Unified Routing; 라우팅이 telephony가 아닌 Salesforce에서; skill-based·direct-to-rep(Amazon Connect). **rep이 통화 수락에 20초 이상.** 가용: Service+Sales+Government Clouds add-on. (= "Route Voice Calls with Other Channels by Using Omni-Channel (Pilot)" 와 동일 — dedup)
- **Use Omni-Channel Routing with Automatic Queue and User Sync During Disaster Recovery** — secondary contact center에 queue/agent capacity 자동 동기화.
- **Manage Call Actions from Your Headset** — headset에서 accept/mute/hold/unmute(telephony provider 의존).
- **Empower Reps to Resolve Cases Faster with Einstein Article Recommendations (Pilot)** — Voice Call/Messaging Session record page의 실시간 article 추천. Service+Sales Clouds.
- **Access and Configure the Latest AWS Services for Your Contact Center** — **Salesforce Contact Center with Amazon Connect (SCC)**; Amazon Connect Chat 등. **Additional AWS services add-on** 필요. Amazon Connect Chat은 현재 Partner Telephony from Amazon Connect 전용.
- **Customize Softphone Options to Support Call Handling Compliance** — end call·phone book·dial pad 비활성(TCPA).
- **Use Desk Phones Without Another Audio Device**.
- **Leverage Customized Usernames for Contact Centers** — Amazon Connect username 형식 커스텀.
- **Use External ID for Provisioning Role for Additional Security** — IAM provisioning role 고유 external ID.
- **Get the Latest Enhancements for Your Amazon Connect Contact Center** — **Contact Center version 17.0**.
- **Optimize Business Processes Based on the Sentiment and Intent of Real-Time Conversations (Pilot)** — Conversation Intelligence Rules로 Intent/Customer Sentiment/Agent Sentiment Signal Type. Service+Sales Clouds.
- **Updated Format of Usage Details Field in Amazon Connect Usage and Amazon Lex Reports** — `AWSRegionName_AWSAccountId`(기존 `AWSRegionName_SalesforceOrgId`).
- **Conversation Catch-Up Offers Additional Supported Languages** — Dutch·Mexican Spanish·Portuguese·Portuguese Brazilian·Swedish.
- **Manage Capacity via Status-Based Capacity for Voice (Beta)** — status-based capacity가 Voice에서도. standard navigation app에서 voice call. Service+Sales+Government Clouds. How: Omni-Channel Settings → enhanced Omni-Channel routing → **Enable Status-Based Capacity Model**; Voice Call object용 Service Channel을 **Status-Based**로. (= Routing의 "Use Status-Based Capacity with Voice (Beta)" — dedup)
- **Get More Granular Voice Call Report Data with Role Hierarchy Filters**.
- **Display Voice Call Audio Statistics in Real Time Using the Service Cloud Voice Toolkit API** — WebRTC audio stats(30초 간격). **AUDIO_STATS**(Aura)/`audiostats`(LWC) 이벤트.
- **Dissociate Voice Call Recordings from Voice Calls** — **VoiceCallRecording** 레코드 삭제.
- **Focus on Primary Tasks by Using Voice in an App with Standard Navigation (Beta)** — standard navigation app에서 Voice. Service+Sales+Government Clouds.
- **Use an Apex-Defined Variable for All Intelligence Signal Types (Release Update)** — 신규 **intelligenceSignals** flow input parameter(Apex-defined). **Summer '24 최초 제공, Spring '25 강제 적용.**

### Knowledge
- **Create Advanced Approval Processes for Knowledge Articles** — Flow Orchestration 기반 multi-stage 승인. **Work Guide**·**Approval Trace** component 또는 **Approvals** app.
- **Revise Knowledge Articles for Grammar and Readability with Einstein Knowledge Edits (Generally Available)** — Einstein generative AI 사전정의 edit prompt(grammar·conciseness·readability). pilot 대비 변경 포함. Where: Unlimited·Enterprise + Einstein for Service add-on. Who: `Prompt Template User`·`Einstein Knowledge Creation`. How: 툴바 **Revise with Einstein**. customized prompt는 Prompt Builder의 **Knowledge Field Update** type.
- **Leverage Data Cloud Connectors to Ingest Knowledge Articles** — 3rd-party knowledge를 Data Cloud로(**Knowledge Article DMO**). Data Cloud consumption credit 필요.
- **Sync Knowledge with Data Cloud** — Einstein 1 Platform knowledge → Data Cloud. **Enhanced Knowledge Settings → Sync With Data Cloud**.
- **Unify Knowledge with MindTouch Connector** — Unified Knowledge용 **MindTouch** connector(Zoomin 90일 무료 trial, 3 connector instance).
- **Get More Done in the Lightning Article Editor** — Find/Replace 필드 라벨, 수동 이미지 치수, alt-text 오류 수정 등.
- **Open Ingested Article Links from Third-Party Sources in Salesforce** — 지원 connector: Salesforce Knowledge Article, Zendesk, Confluence Cloud/Server, ServiceNow Knowledge, Sitemap, Guru, Atlassian Jira Cloud/Server, Helpjuice. **Open imported inter-article links in Salesforce** 켜기.
- **Sync Options Enhanced for Your Knowledge Base** — **Force Full Resync**·**Incremental Sync**.
- **Run the Lightning Knowledge Migration Tool (Release Update)** — Classic Knowledge data model 은퇴 전 마이그레이션. **Salesforce enforces in Summer '25.** "The Classic Knowledge data model is no longer available starting with Summer '25." Spring '25 이후 생성 org은 Classic Knowledge 미접근.
- **Alert Agents to Knowledge Articles with Einstein Knowledge Creation Async Notification** — 생성 중 다른 케이스 처리 가능(기존 최대 3분 차단). in-app + email 알림.

### Entitlements and Milestones
- **Boost Rep Productivity and Reporting Accuracy by Automating Milestone Completion with Flows** — flow로 milestone completion criteria 설정.
- **Optimize Data Analysis, Reporting, and Decision Making with the Case Milestones Report Type** — **Case Milestones** report type(SLA violations, entitlements).

### Self Service
- **Resolve User Search Queries Faster by Using Context-Driven Conversations with Agentforce Service Agent** — (Agentforce 1A "Enhance User Search Experience…"와 동일 기능 — Experience Workspaces → AI Experiences → **Share search queries with Agentforce Service Agent**.)

### Routing
- **Reassign Work Items from Service Channels** — 다른 queue·rep·skill·Omni-Channel flow로 재배정(재배정 시 queue 상위 배치). **Enable Enhanced Omni-Channel** + **Enable Skills-Based and Direct-to-Agent Routing**.
- **Manage Your Workforce More Efficiently with Agentforce** — **Agentforce (Default)** 로 queue/skill 관리; **Update Omni-Channel User Configuration** agent action. Who: `Use Agentforce Default Agent`.
- **Perform Actions from More Flow Types** — **Check Availability for Routing**·**Add Screen Pop** flow action을 전 flow type에서(기존 Omni-Channel flow 전용).
- **Increase Rep Productivity with Omni-Channel Sidebar** — collapsed sidebar; auto-accepted/resumed work item 표시.
- **Other Enhancements for Routing Work to Agentforce Service Agents** — **Route Work** 액션 간소화 + 상세 오류 메시지.
- **Route Voice Calls with Other Channels by Using Omni-Channel (Pilot)** — (= Voice의 Unified Routing for Voice — dedup.) skill-based·direct-to-rep(Amazon Connect), 20초 이상 수락.
- **Use Status-Based Capacity with Voice (Beta)** — (= Voice의 Manage Capacity via Status-Based Capacity — dedup.)

### Feedback Management
- **Improve Data Gathering with Partial Survey Responses** — 부분 완료 survey 응답 캡처·재개. **Feedback Management - Growth** 필요.
- **Customize NPS Question Labels for Better Relevance** — NPS 최저/최고 점수 라벨 커스텀·번역.
- **Access Customer Feedback Directly from the Messaging Sessions Page** — messaging session 페이지의 survey invitation/response. **Feedback Management - Starter/Growth**.

### Customer Experience Intelligence
> Where(공통): Lightning Experience, Enterprise·Unlimited·Developer + Data Cloud + **Customer Exprc Intel** add-on. Who: `Scoring Framework Admin`·`Data Cloud Admin`.
- **Unify Customer Data for a Holistic Profile** — Channels 페이지에서 **Unified Profiles** 켜기.
- **Extract Product Insights from Customer Interactions** — **Product Insights Extraction** AI service.
- **Enhance Data Quality by Restricting the Length of Key Phrases** — 최소 key phrase 길이 **2~5**.
- **Improve Customer Experience with Email Insights** — Email을 feedback channel로.
- **Engage with Customers over Custom Channels** — name + data lake object로 custom channel 추가. **When: February 2025부터.**
- **Optimize Engagement Efficiency by Analyzing Interactions Across Products** — analytics dashboard(NPS·CSAT·sentiment trend).
- **Boost Productivity by Creating Multiple Cases Simultaneously** — dashboard에서 다중 케이스 생성(user segment 또는 최대 20명).
- **Get a Comprehensive Summary of Customer Engagement, Experience, and Data** — **Customer Experience Intelligence agent topic**; actions: Find Similar Interactions, Summarize Product Reviews, Enhance Product Description.

### Service Adoption
- **Discover More Service Capabilities with My Service Journey (Generally Available)** — Service 영역 탐색(Help Site·Agent Console); business goal·edition·Agentforce 등으로 필터. **16개 fully supported 언어.** Where: Lightning Experience, Enterprise·Unlimited·Developer. Who: 모든 Service Cloud user. How: App Launcher → **Journey Map**.

---

## Experience Cloud

> Intro(23386): "Upgrade your existing LWR sites to enhanced LWR sites... customize your site URLs to remove the /s..."

### Aura and LWR Sites
- **Upgrade to Enhanced LWR Sites (Release Update)** — "now generally available"; Spring '25부터 업데이트 제공. enhanced 기능: Expression-based visibility/variations, Component-specific Style 탭, Site content search, Data Cloud integration, Enhanced CMS workspaces. metadata: non-enhanced는 ExperienceBundle, enhanced는 DigitalExperienceBundle + DigitalExperienceConfig. **When: Salesforce가 Spring '26에 강제 적용.**
- **Remove /s from the URL of Your LWR Site** — `https://mycustomdomain.com/s` → `https://mycustomdomain.com`. enhanced upgrade 선행조건.
- **Improve LWR Site Performance with Experience Delivery (Beta)** — server-side rendering + dedicated CDN, page load 최대 **60%** 빠름. Where: Enterprise·Performance·Unlimited(**Developer Edition 미지원**).
- **Work More Efficiently in Experience Builder with Usability Updates** — Base Font Family 필드, Change History 패널, dockable property 패널, Site Headers 섹션. Spring '25 이후 생성 LWR 사이트는 Salesforce Sans 미제공.

### Components in Experience Builder
- **Enable a Modernized Record Experience in Aura Sites (Release Update)** — Create Record Form·Record Banner·Record Detail component → LWC. **When: Summer '25 강제 적용.**
- **Help Your Site Visitors View Records More Easily with the New Record List Component (Beta)** — LWR 사이트의 object list view.
- **Give Experience Cloud App Users the Ability to Log In with One Tap** — **Biometric Login Button** component. Mobile Publisher for Aura·LWR 앱, User Opt-In Biometric Login 구성 필요.

### Developer Productivity
- **Link Files from Your LWR Site to Salesforce is Generally Available** — LWR/enhanced LWR용 File Upload LWC. 기본 ON.
- **Develop Lightning Web Components Faster in a Real-Time Preview of Your LWR Site (Beta)** — Local Dev. at least one active community license.

```
sf plugins install @salesforce/plugin-lightning-dev
```

### Mobile · Security and Sharing
- **Improve Your Experience Cloud App with the Latest Features from Mobile Publisher** — User Opt-In Biometric Login "now generally available"; Biometric Login Button; Enhanced Mobile App Security 알림 스타일; 신규 download method(unauthenticated·dynamic·third-party·Base64·custom/standard object).
- **Use Trusted Sites and Disable Lightning Locker When CSP Is in Strict Mode**.
- **Salesforce No Longer Supports Shared Domain Certificates for the Salesforce CDN** — 신규 CDN domain은 single domain certificate.
- **Increase the Security of Your Site When Managing External Users** — Manage External Users (Limited) 권한.
- **Strengthen Your Customer Identity Implementation with New Features and Security Updates** — headless app login; External Client Apps framework로 SAML SSO; `services/oauth2/singleaccess` endpoint 변경(URL query string의 access token GET 차단); Triple DES SAML encryption deprecated.

---

## Commerce

> 하위 영역: Commerce Einstein, B2B/D2C Commerce, Omnichannel Inventory, Order Management, Salesforce Payments. (별도 명시 없으면 Where: B2B/D2C Commerce, Enterprise·Unlimited·Developer.)

### Commerce Einstein
- **Enhance the Customer Shopping Experience with Agentforce for Guided Shopping (General Availability)** — Where: B2B·D2C Commerce, Enterprise·Unlimited·Developer + Agentforce add-on. **When: April 2025부터.** Template: Agentforce for Guided Shopping - B2B & D2C.

### Store Pages · Components
- **Edit Product Details with Fewer Clicks** — Edit Product 페이지.
- **Enhance the Shopping Experience with the Redesigned Address Page** — auto-complete, phone capture.
- **Provide Complete Order Details on the Order Confirmation Page**.
- **Translate Your Store in Minutes** — 자동 번역(Dutch·French·German·Italian·Japanese·Spanish·Portuguese). Export Content → XLF.
- **Experience Improved D2C Store Performance (Beta)** — Experience Delivery, server-side rendering. 신규 D2C store.
- **Create and Manage Product Attributes from Your Store Settings** — Product Attribute 탭.
- **Brand Your Store Faster with the Enhanced Website Design Workspace**.
- **Do More with the New Banner Component** — Category Banner component 대체.
- **Build Multilevel Navigation Menus with the Mega Menu Component for D2C Stores** — 최대 3 레벨. Spring '25 이후 사이트는 header 기본 포함.
- **Add Color Variations to the Product Detail Page** — dropdown/pills/swatches; hex code.

### Cart, Checkout, Shipping
- **Collect a Shipping Phone Number During Checkout** — Custom Checkout.
- **Address Fields Autocomplete on All Store Pages** — B2B store, Custom Checkout, Pay Now, My Profile.
- **Improve the User Experience for Shipping to Multiple Addresses** — **Split Shipment Layout** component. Salesforce Payments 필요(Managed Checkout 미지원).
- **Jump to the Top or Bottom of the Cart Items List with One Click** — "Skip to" 버튼.
- **Improve the Shopping Experience with Enhanced Cart and Checkout Performance** — Cart Calculate API.
- **See Matching Product Data in Cart and Mini Cart**.

### Promotions · Search
- **Create a Promotion Based on Specific Product Variations** — attribute(size/color/weight).
- **Create Coupons Using a Guided Workflow** — start/end time, redemption limit.
- **Offer Shoppers Relevant Search Suggestions** — predictive search(Product Name·SKU·Category Name·Product Code).
- **Boost Product Discovery with the Enhanced Variation Display** — color swatch/summarized text.

### Additional · Inventory · Order Management · Payments
- **Sell and Manage Digital Subscriptions in B2B and D2C Stores (Generally Available)** — Salesforce Revenue Cloud 통합; **Salesforce Pricing** 필요. Commerce Subscriptions는 Salesforce Payments 필요(Commerce 라이선스 미포함).
- **Analyze Order Trends on the Commerce Orders Dashboard** — Insights | Orders.
- **Get Notified When a Customer Abandons a Shopping Cart** — Abandoned Cart event; `WebCartAbandonedEvent` platform event. Commerce Growth/Advanced 라이선스.
- **Send a Customized Welcome Email to New Users** · **Add Variations During Product Creation** · **Connect Your Custom Domain to Your Store from the Commerce App** · **Customize and Extend Commerce Messages Using Flow** · **Share Knowledge Articles with Your Customers**.
- **Import Inventory in Bulk** (Omnichannel Inventory) — CSV 또는 JSON.
- **Cancel, Return, and Route Orders Containing Product Bundles** — Order Management Growth 라이선스; Distributed Order Management 패키지.
- **Cancel Orders in Bulk** — Cancel All APIs.
- **Use Adyen as a Payment Gateway for Salesforce Payments** — Enterprise·Unlimited.
- **Elevate Your Customers' Shopping Experience with the Enhanced Pay Now Store** — payment link 제품, Insights dashboard, custom→managed checkout 단방향 전환.
- **Capture or Refund Payments in the Payments Workspace** — Capture는 Authorized 상태일 때만, Refund는 Captured/Succeeded일 때만.
- **View Where a Payment Originates from in the Payments Workspace** — payment initiation source.

---

## CMS

> Intro(41838): "Classify CMS content with content taxonomy, then tag content to create dynamic collections." (Where 공통: enhanced CMS workspaces, Enterprise·Performance·Unlimited·Developer.)

- **Classify CMS Content with Content Taxonomy (Beta)** — content taxonomy로 분류. **English only.** Beta.
- **Streamline Content Management with Automated Tag-Based Conditions** — dynamic collection, relevance 순으로 최대 **250 content item**.
- **Save Time with Content Record Cloning in Your Shared Enhanced CMS Workspaces**.
- **Scale Content Delivery for High Performance** — image content type용 **Dedicated Content Delivery**, 신규 public channel 기본 ON(Hyperforce).
- **Deliver Content from Any CMS Workspace to Any Public or Restricted Channel** — newly enhanced channel은 "Use non-enhanced APIs" 기본 활성.
- **Remove More Types of Channels from Enhanced CMS Workspaces** — Aura site, "Use non-enhanced APIs" 활성 enhanced public/restricted channel 제거 가능.

---

## Data Cloud

> Note(17794): "Changes included in the Spring '25 release are generally listed under February." Data Cloud는 **월별(February/March/April/May 2025) 롤아웃** 모델. 아래는 KEY JOB AREA 기준 정리.

### Connect Data
- **Allow Access to All Salesforce CRM Fields with One Permission** — **View All Fields (Global)** user permission(Platform Integration User에만 할당). **When: February 2025.**
- **Boost Productivity with File Upload Enhancements (Generally Available)** — 더 큰 파일; engagement stream 버그 수정. **When: March 2025.**
- **Ingest Data Stored from Jira into Data Cloud (General Availability)** — issues·projects·sprints·users·workflows. **When: February 2025.**
- **Ingest B2C Commerce Intelligence Data into Data Cloud (Beta)** — orders·products·promotions·payments·site search. **When: March 2025.**
- **Ingest SAP Concur Data into Data Cloud (General Availability)** — expense report. **When: March 2025.**
- **Connect to Kinesis Data Streams Using Data Cloud Virtual Private Cloud Endpoints** — "Beginning on April 17, 2025, Data Cloud will use the VPC endpoints...". **When: April 2025.**
- **Ingest and Index File Attachments from Salesforce Objects in Data Cloud** — Content data streams; UDMOs. **When: February 2025.**
- **Send Profile and Engagement Data to Data Cloud Using a Server-to-Server Connection** — Mobile/Web SDK. **When: March 2025.**
- **Configure Multiple Marketing Cloud Engagement Connections in One Data Cloud Org** — multiple EID. **When: March 2025.**
- **Ingest Data in Real-Time Using Ingestion APIs** — DLO→real-time data graph DMO. Sub-Second Real-Time Profiles & Entities add-on. **When: March 2025.**
- **Optionally Disable Real-Time Data Ingestion in Ingestion APIs** — **When: April 2025.**
- **Build Cost-Effective Data Foundation with Zero Copy File Federation (Beta)** — Apache Iceberg·Databricks·Snowflake. **When: March 2025.**
- **Use Private Connect for Data Cloud to Join Data Across Regions for Redshift** — **When: March 2025.**
- **Capture UTM and Custom Parameters In Data Cloud** — Web and Mobile App connector. **When: April 2025.**
- **Retrieve the VPC Endpoint ID for a Private Network Route Using the User Interface** — **When: May 2025.**

### Prepare and Model Data · Unify Data
- **Change a Data Model Object Field Mapping** — DLO 필드 = DMO 필드 동일 data type. Developer 제외 전 edition(sandbox 미지원). **When: February 2025.**
- **Limit the Number of Child Records in a Data Graph** — **When: March 2025.**
- **Optimize Resources Using Merge Write Mode for Batch Transforms** — **When: April 2025.**
- **Use the Unified Data Cloud SQL in Query Editor** — 검토 단계: Audit Identifiers, Review Data Types/Literals, Adjust External Data Syntax(`external()`), Test Aggregates/Window Functions, Iterative Testing. **When: April 2025.**
- **Increase Real-Time Profile Match Rates with Exact Normalized Matching** — phone/email Exact Normalized. **When: March 2025.**

### Build a Semantic Model
- **Unify Your Salesforce Data for Consistent Insights with Tableau Semantics** — 신규 semantic layer(Data Cloud Reports·Tableau Next). **When: March 2025.**
- **Accelerate Semantic Model Setup with Data Kits** — **When: April 2025.**
- **Control Access to Semantic Models Based on Data Cloud Tagging and Policies** — Enterprise·Unlimited. **When: April 2025.**

### Use and Build AI Models · Build and Share
- **Use OAuth Authentication with Bring Your Own LLMs and Azure** — LLM Open Connector + Azure OAuth + Named Connection. **When: February 2025.**
- **Improve Response Relevance With Ensemble Retrievers** — Einstein Studio. **When: April 2025.**
- **Hide Large Learning Models (LLMs) from Prompt Templates** — Einstein Studio Model Library. **When: May 2025.**
- **Boost Predictive Model Performance with Scheduled Retraining** — **When: May 2025.**
- **Data Kit 일괄(February~April 2025):** Automate Data Cloud Package Creation, Deploy Data Kit Components with Fewer Clicks, Lock Data Kit Metadata, Maintain DMO Relationships During Deployment, Migrate Data Cloud Changes Across Orgs Using a Sandbox(DevOps data kit), Push Upgrades to All Subscriber Orgs, Reduce Deployment Errors with Automated Sequencing, Uninstall Packages with Fewer Clicks.

### Create and Activate Segments
- **Analyze the Latest Activation Publish Output Using a Simple Query** — Audience Latest DMO. **When: February 2025.**
- **Configure External Activation Platform Using JSON Schema** — ISV partner, Amazon S3 target만. **When: March 2025.**
- **Define Segment Filters Based on Aggregate Values Across Multiple Levels (Generally Available)** — hierarchical aggregation(Account·Unified Account). **When: April 2025부터 GA.**
- **Improve Segmentation Accuracy with Vector Filters (Beta)** — structured + unstructured. **When: April 2025.**

### Act on Data · Analyze Data
- **Create a Real-Time Data Action Using Automation Event-Triggered Flow (Beta)** — Sub-Second Real-Time Profiles & Entities add-on. **When: March 2025.**
- **Add Up to 250 Data Cloud Objects in a Data Share** — **20 → 250**. **When: March 2025.**
- **Catch Up with Large Data Changes for Copy Field Enrichments with Full Sync** — **250,000건** 초과 변경 시 full sync. **When: March 2025.**
- **Data Cloud Enrichments 일괄(February 2025):** Create Enrichments with Companion Org Data(Data Cloud One), Copy Field Enrichments Sync Faster, Display Insights from External Data(Snowflake·Redshift·BYOL), Enhance Vehicle Records(Automotive Cloud), Export Enrichments to a Data Cloud Sandbox.
- **Add Copy Field Enrichments to More Objects** — collection plan·opportunity. **When: April 2025.**
- **Data Cloud SQL Array Datatype Syntax Update** — array literal이 curly brace → **square bracket**. All Editions.

> **cross-cloud:** Data Cloud Reports and Dashboards GA(Highlight Min/Max Aggregates, Create/Default Semantic Model Report, Bucket Columns, Advanced Formulas 등)는 **Analytics** 섹션에 상세. **Import Event Data from Shield's Event Monitoring into Data Cloud (Beta)** 등 Cross Cloud Updates 다수(Loyalty·Education·Communications·Marketing Cloud 연계). Data Cloud·AI 에이전트 연계는 → [[Spring '25/Agentforce]].

---

## Analytics

> 하위 영역: Unified Analytics Experiences, Lightning Reports and Dashboards, Data Cloud Reports and Dashboards, CRM Analytics, Tableau, Marketing Cloud Intelligence, Accessibility. **Note:** Analytics 다수 기능이 "not part of the initial Spring '25 release and may be included at a later date."

### Unified · Lightning Reports and Dashboards
- **Add Assets to Collections in Bulk** — CRM Analytics. **When: not part of initial release.**
- **Run More CRM Analytics Dashboard Subscriptions Per Hour in Slack** — 상한 **100 → 500/hour/org**. 권한: Connect Salesforce with Slack.
- **Do More with Custom Report Types (Generally Available)** (Delivered Idea) — lookup field로 최대 **1,000 field**. Enhanced Custom Report Type Setup Page(기본 ON).
- **Keep Charts Consistent with Reordered Report Data** — sort 시 chart 갱신.
- **Choose Which Dashboard Widgets to Refresh (Beta)** — Customer Support로 활성화.
- **Designate One Email Address to Send Report Subscription Notifications (Beta)** — org-wide email address. "Enable Org Wide Email Address for Report Subscription (Beta)".
- **Sort Chart Legends Alphabetically or Numerically** — Sort Legend Values.

### Data Cloud Reports and Dashboards (cross-cloud — Data Cloud와 공유)
> Where 공통: Data Cloud, Developer·Enterprise·Performance·Unlimited.
- **Define Filters on Aggregate Values in Data Cloud Reports** — sum/average/highest/lowest, AND 로직.
- **Highlight Min and Max Aggregates for Date Fields (Generally Available)** — date/datetime/row-level formula.
- **Create a Semantic Data Model Report with a Single Click (Generally Available)**.
- **Default Behavior When Creating a Semantic Data Model Report Has Changed (Generally Available)** — count of rows + detail rows 기본 비활성.
- **Analyze Logical View and Semantic Union Metrics in Data Cloud Reports (Generally Available)**.
- **Categorize Semantic Model Records with Bucket Columns (Generally Available)** — numeric/picklist/text.
- **Assess Semantic Data Model Records with Advanced Formulas (Generally Available)** — summary formula + row-level formula.

### CRM Analytics
> Where: CRM Analytics(Developer Edition + Enterprise·Performance·Unlimited 추가 비용).
- **See More Color Contrast in Donut and Stacked Bar Charts** — 5 segment 초과 chart 제외.
- **Use Version Control When Saving Dashboard Component Changes** — Version History 필드.
- **Unify Your Data Across Dashboards** — Data Cloud One companion org + shared data space(cross-cloud).
- **Enhance Your Dashboards with Customizable Tooltip Colors** · **Get More Representative Sample Data in Recipes** · **Preview Random Samples from Datasets in Recipes** · **Improved Data Preview in Recipes** · **Secure Salesforce External Connections with OAuth 2.0** · **Monitor Dataflow and Recipe Deletions in the Audit Trail** · **Run Sequential Recipes Faster in Encrypted Orgs**(not part of initial release).
- **Give Users Read-Only Access to Recipes (Generally Available)** — Recipes View Only 권한.
- **Push Data from Government Cloud with Output Connectors** — Amazon S3·Salesforce·Snowflake, FIPS 140. not part of initial release.
- **Improve Salesforce External Connector Sync Performance with Incremental Syncs (Beta)** · **Load Data Incrementally (Beta)** — Analytics External Data API(upsert·delete).

### Tableau · Marketing Cloud Intelligence · Accessibility
- **Tableau** — Tableau Cloud/Desktop/Prep/Server 릴리즈 노트 포인터.
- **Marketing Cloud Intelligence** — Marketing Cloud / MCI Data Pipelines 릴리즈 노트 포인터.
- **Accessibility Enhancements in Analytics** — contrast, keyboard navigation, focus order, assistive text(Home/Browse/Watchlist/Notifications/Collections). not part of initial release.

---

## Slack

> Spring '25 Clouds 섹션의 Slack은 **stub(포인터)** 이며 GA/Beta/Pilot 기능이 없다. 별도 릴리즈 노트로 안내한다.

```
// PDF 원문 인용 — 구조 충족용
"Salesforce for Slack Integrations — Use Slack and Salesforce together to connect with
customers, track progress, collaborate seamlessly, and deliver team success from anywhere.
See the release notes for the latest updates: Salesforce for Slack Integrations Release Notes."
```

> 참고: 별도의 "Salesforce for Slack" 커넥터 GA 목록은 Flow의 MuleSoft 섹션(서드파티 커넥터)에 있으며, 이는 MuleSoft 커넥터로 위 Slack stub과 별개다(→ [[Spring '25/Development]]).

---

## Field Service

> 하위 영역: Agentforce for Field Service, Einstein for Field Service, Setup Home, Scheduling and Optimization, Asset Management, Operations, Customer Engagement, Mobile, Data Capture, Spotlight.

### Agentforce / Einstein for Field Service
- **Enhance Appointment Management with the Scheduling Agent** — enhanced Messaging channel. **When: week of May 5, 2025부터.**
- **Reduce Customer Wait Times with Autonomous Scheduling** — schedule/reschedule/cancel/inquire. Agent Creator → Scheduling 또는 Agentforce Service Agent template. **When: week of May 5, 2025.**
- **Boost Productivity and Resource Utilization by Easily Filling Schedule Gaps with Agentforce** — Field Service Dispatcher Actions topic. Einstein for Field Service add-on; Field Service 관리형 패키지.
- **Work Smarter by Using Siri to Communicate with Agentforce** — "Ask Field Service"(iOS only).
- **Listen Safely to Pre-Work Briefs with a Tap of a Button** — Pre-Work Brief의 Read Aloud(Android·iOS).

### Setup Home · Scheduling and Optimization
- **Accelerate Time to Value with Field Service Setup (Beta)** — one-click activation, 4 wizard. Enterprise·Unlimited·Developer.
- **Increase Coverage with 24-Hour Availability for All Service Resources**.
- **Enhance Scheduling Flexibility by Assigning Service Appointments to Individuals or Crews** — Assign Service Appointments to Individuals and Crews 체크박스.
- **Reduce Labor Costs and Increase Resource Productivity with Consecutive Appointment Scheduling** — Minimize Gaps objective.
- **Improve Scheduling in Japan with More Accurate Travel Time Predictions** — point-to-point predictive routing.
- **Improve Scheduling Efficiency with the Enhanced Minimize Travel Service Objective** — 초 단위 penalty(기존 분 단위).
- **Gain Visibility into the Scheduling History of Service Appointments** — Service Appointment Lifecycle; 신규 object change record page. **When: February 4, 2025부터.**
- **Renamed Field Service Agent Permission Set Name and Agent Persona** — persona → Field Service Call Center Rep.
- **Quickly Identify and Manage Empty Appointment Bundles** — empty bundle status. **When: later in Spring '25.**

### Asset Management
- **View and Manage Asset Components in Real Time with the Asset Service Lifecycle Management Add-On** — Asset Interactive Hierarchy(Current/As Installed/As Maintained). ASLM add-on 라이선스.
- **Foresee Future Fixes with the Connected Assets Add-On** — Asset Service Prediction(ASP). Connected Assets add-on.
- **Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules (Release Update)** — Frequency·Frequency Type 필드 은퇴. Summer '22 최초, Winter '22 예정 → **Winter '26로 연기. enforced in Winter '26.**

### Operations · Customer Engagement
- **Monitor Field Service Operations with New Dashboards (Beta)** — Field Service Intelligence dashboard(Work Order·Service Appointment). Einstein 1(Unlimited는 Tableau+ 필요). 권한: Tableau Einstein Included App Business User, Tableau Included App Manager.
- **Transfer to a Visual Remote Assistant Session Easily with Agentforce** — Visual Remote Assistant install 필요.
- **Promote Your Brand During Visual Remote Assistant Sessions**.
- **Find Available Slots More Efficiently When Booking Appointments with Appointment Assistant** — single-day view.

### Mobile · Data Capture
- **Field Service Mobile App Device Deprecations** — Spring '25부터 Android 9·iOS 16 deprecated(Summer '25까지 동작). LWC 호환 위해 앱은 플랫폼 대비 2 major release 이내.
- **Automatically Unlock a Suite of Advanced Features with Lightning Data Service** — 신규 org/sandbox auto-enable; Data Capture + Document Builder. **When: As of November 4, 2024.**
- **Address Asset Issues Proactively with Asset Service Predictions (Generally Available)** — Connected Assets add-on(Android·iOS).
- **Manage Service Records Automatically On the Go** — geolocation 기반 background action(Android·iOS).

```
{"quickAction": "Global.LogACall"}
```

- **Get Notified When Mobile Workers Arrive at the Office or Pass by a Work Facility** — geolocation action(service territory·member 지원).
- **Update Field Service Records Quickly and Easily** — 네이티브 iOS/Android record edit.
- **Minimize Work Disruptions with Seamless Updates** — 로그아웃 없는 LWC update.
- **Update Service Appointment's En Route Status On the Go** — iOS only.
- **Optimize Data Retrieval in Low-Connectivity Zones with Cache First (Generally Available)** — cache 로드 + network fetch(Android·iOS).
- **Simplify Mobile Forms with Data Capture Flow (Generally Available)** — Data Capture flow type. Enterprise·Unlimited·Developer.
- **Empower Mobile Workers with Data Capture Forms (Generally Available)** — Field Service mobile app(Android·iOS).
- **Build Dynamic Forms with Discovery Framework Data Capture Flow (Generally Available)**.
- **Improve Mobile Worker Productivity with Discovery Framework Data Capture Forms (Generally Available)** — Field Service·Discovery Framework·Import/Export·Data Capture Flow 활성.
- **Gather All the Answers with the Assessment Variable for Discovery Framework Data Capture** — 신규 assessment variable(Assessment object).
- **Improve Your Scheduling and Optimization Proficiency with Revamped Salesforce Help Content** (Spotlight).

---

## Marketing

> 하위 영역: Marketing Cloud(Growth/Advanced), Account Engagement, Engagement, Intelligence, Personalization, Marketing Intelligence. core-GA tagged 없음, Beta 4건(Campaign Designer·MI Goals·MI Patterns·file enrichment).

### Marketing Cloud (Growth/Advanced)
- **Reach More People with WhatsApp** — Blank WhatsApp campaign, Send WhatsApp Message element, 2-way 대화, audio/video/document.
- **Save Time with New AI Capabilities for Campaigns and Content** — email/landing page용 Agentforce (Default) agent; campaign brief prompt.
- **Create Campaigns with Agentforce Campaign Designer (Beta)** — Enterprise·Unlimited + Marketing Cloud Advanced 또는 Account Engagement Plus/Advanced/Premium.
- **Reuse Personalization Settings Throughout Email Components** · **Reduce Message Design Time with Reusable Expressions** · **Create a Segment with Quick Filters** · **Preview Segment Membership Before Sending**(최대 1,000 member) · **Expand Your Customer Base with Prospects and Leads**(신규 Prospect object) · **Prioritize Ready-to-Purchase Accounts with Account Scoring** · **Embed Forms on External Sites**(iframe·HTTPS) · **Relate External Web Engagement to a Campaign** · **Expand SMS Marketing to More Countries**(50+개국) · **Use Brand Vetting** · **Use Blockout Windows** · **Review Consent Source Details in Data Cloud** · **Manage More of Your Flow from the Campaign**(최대 5 wait element) · **Gain Insight on Campaign ROI with Opportunity Influence** · **Track your Campaigns and Flows with Marketing Calendar** 등.

### Account Engagement · Engagement
- **Get Helpful Resources for Enabling Marketing Cloud** — Enable Marketing Cloud Optimizer.
- **Automate Account Engagement Data Stream Creation in Data Cloud**.
- **Expedite Content Creation by Copying Assets to CMS via API** — Account Engagement API **Version 5**; `/copyToCms` endpoint, `/salesforceCmsId` read-only.
- **Streamline Content Creation by Copying Additional Asset Types to CMS** · **Get More Visibility into Email Send Issues** · **Generate Account Engagement Content in More Languages**(French·German·Japanese·Portuguese(BR)·Spanish).
- **Prepare for End of Support for Enhanced Email Experience** — Winter '25부터 종료.
- **(Engagement)** Get More Details with Deployment Summary; Package Manager Folder Navigation; Intelligence Reports No Longer on Hyperforce; Enable Default High-Throughput Sending in Journey Builder; **New Permission Requirements for Sales and Service Cloud Activities**(March 6, 2025 강제); Additional File Transfer Location Destinations for AWS S3; Send Interactive Messages on WhatsApp; MobilePush SDK 9.0+ 기능 다수; **Changes to Data Retention Policy**(May 15, 2025부터 180일); **Updated Limit for Data Extract Activity Queues**(February 10, 2025부터 최대 250).

### Personalization (구 Einstein Personalization)
- **Einstein Personalization Is Now Called Personalization** · **Explore the Enhanced Web Personalization Manager** · **Define Custom Objectives for Recommendations** · **Use Scheduling Rules for Decisions** · **Personalize Business Processes and Screens with Flow**(Get Personalization Decisions invocable action; Decisioning API) · **Display Personalized Recommendations with Agentforce**.

### Marketing Intelligence
- **Separate and Protect Data with Data Spaces** · **Track Channel-Specific Performance with New Connector Dashboards**(8 신규 connector) · **Connect Marketing Data Sources Using Data Pipelines**(March 2025) · **Ingest…with New API Connectors**(Amazon·Google·LinkedIn·Microsoft·Snapchat·Trade Desk·TikTok·Twitter·Youtube).
- **Improve Your Marketing Strategy with Measurable Goals (Beta)** — KPI(ROI·CPA·CLV). February 2025.
- **Improve Data Consistency by Using Marketing Intelligence Patterns (Beta)** — March 2025.
- **Enhance Data Quality by Using AI-Powered Enrichment** — file upload for data enrichment은 **Beta**.

> Marketing·Agentforce 연계는 → [[Spring '25/Agentforce]].

---

## Revenue Cloud

> 하위 영역: Product Catalog Management, Salesforce Pricing, Product Configurator, Transaction Management, **Usage Management (GA)**, Salesforce Contracts, Dynamic Revenue Orchestrator, Billing. (Where 공통: Enterprise·Unlimited·Developer of Revenue Cloud.)

### Product Catalog Management · Salesforce Pricing
- **Accelerate Product Creation with Deep Clone** · **Define Decimal Values for Product Quantity** · **Update Product Index Quickly with Partial Index Rebuilds** · **Enhance Product Discovery with Faceted Search** · **Streamline Product Discovery with Custom Procedure Plans** · **Optimise the Creation of Product Descriptions by Using Einstein AI**(Einstein GPT Platform add-on).
- **Changed Objects** — Product2·AttributePicklist에 신규 `UnitOfMeasure` 필드. **Changed Metadata** — ProductDiscoverySettings에 `enableGuidedSelling`·`discoverProductsFlowNameOrgValue`.
- **Connect REST API(신규/변경):** GET `/connect/pcm/index/snapshots`(numberOfIndexLogs), GET/PATCH `/connect/pcm/index/setting`, GET `/connect/pcm/index/error`, POST `/connect/pcm/deep-clone`, GET `/connect/pcm/unit-of-measure/info`, POST `/connect/pcm/unit-of-measure/rounded-data`.
- **Salesforce Pricing:** Add Context Tags Automatically(Einstein), Discount Distribution Service Element, Pricing Operations Console, Map Line Items, Delete Pricing Recipes 등. 신규 object: `ProcedureOutputResolution`·`PricingApiExecution`·`PricingProcessExecution`. 신규 metadata: `PricingRecipe`(v60.0)·`PricingActionParameters`(v60.0).

### Product Configurator
- **Create Quotes and Orders Faster by Saving and Reusing Configurations** · **Create Precise Configurations with Decimal Quantity Support**(`DecimalQuantityRuntime` 권한) · **Design Product Configurations Faster With Product Classes and Flexible Rules** · **Compact Mode** · **Breadcrumb Navigation component** · **Customized Product Cards**.
- **Set Up Complex Product Validation Rules Easily by Using Advanced Configurator (Closed Beta)** — Constraint Builder. Who: Advanced Configurator Designer(designtime), Advanced Configurator User(runtime). account executive opt-in.
- **Configure Complex Products Accurately with Constraint Models (Closed Beta)** — Advanced Configurator Designtime permission set license.
- **New Connect REST API:** POST/GET/PUT/DELETE `/connect/cpq/configurator/saved-configuration`.

### Transaction Management
- **Amend Evergreen Subscriptions on Any Date** · **Decimal Quantity Support** · **Negotiate Tiered Volume Adjustments**(Contract Item Price Adjustment Tier) · **Line Item Level Pricing Contracts** · **Transaction Line Editor / Enable Groups** · **Create Complex Quotes and Orders**(최대 1,000 lines synchronously).
- **New/Changed Objects:** 신규 `ContractItemPriceAdjTier`; `ApprovalSubmission`·`ApprovalSubmissionDetail`·`ApprovalWorkItem` Experience Cloud 지원(v62.0). 신규 Tooling object `TransactionProcessingType`.
- **RevSalesTrxn Namespace** — 신규 Classes: `ConfigurationOptionsInput`, `GraphRequest`, `PlaceSalesTransactionExecutor`, `PlaceSalesTransactionException`, `PlaceSalesTransactionResponse`, `RecordResource`, `RecordWithReferenceRequest`. 신규 Enums: `CatalogRatesPreferenceEnum`, `ConfigurationExecutionEnum`, `PricingPreferenceEnum`.

### Usage Management (Generally Available)
> Where: Enterprise·Unlimited·Developer where Usage Management enabled. 하위: Usage Modeling, Rate Management, Consumption Management, Wallet Management.
- **Usage Modeling:** Define Sellable Products and Usage Resources(pay-as-you-go·prepurchase·overage), Define Units of Measure(time/transaction/volume/count), Product Usage Grants(Drawdown Order), Define Refresh Policies(monthly/quarterly/annually), rollover policy(expire immediately/roll over for period/roll over indefinitely), Usage Aggregation Methods/Periods, grant-binding policy.
- **Rate Management:** Predefined Negotiable Rating Elements(Negotiable Rating Procedure·Rating Procedure Builder), Rate Card Entry lifecycle(draft/active/inactive). 신규 필드: RateCardEntry의 `Status`·`RateCardType`·`RateNegotiation` 등.
- **Consumption Management:** On-Demand Summary Generation, Calculate Rate, Enhanced Liable Summary Generation.
- **Wallet Management:** Wallet 탭.
- **New Objects(15종):** `TransactionUsageEntitlement`, `UsageEntitlementAccount`, `UsageEntitlementEntry`, `UsageEntitlementBucket`, `UsageSummary`, `UsageRatableSummary`, `UsageBillingPeriodItem`, `UnitOfMeasureClass`, `UsageResource`, `UsageGrantRolloverPolicy`, `UsageGrantRenewalPolicy`, `ProductUsageGrant`, `UsageResourceBillingPolicy`, `UsageProductGrantBinding`, `TransactionJournal`.
- **New Invocable Actions:** `invokeSummaryCreationService`, `processConsumptionOverages`, `refreshUsageEntitlementBucket`.
- **New Connect REST API:** GET `/asset-management/assets/{assetId}/usage-details`, GET `/commerce/sales-orders/line-items/{orderItemId}/usage-details`, GET `/commerce/quotes/line-items/{quoteLineItemId}/usage-details`.

### Salesforce Contracts · Dynamic Revenue Orchestrator · Billing
- **Salesforce Contracts(Professional·Enterprise·Unlimited·Developer):** Microsoft 365 guided setup, Discreet External Review Process, Specify Attachment Format(.docx 또는 .pdf+.docx), Manage Custom Fonts(Hyperforce).
- **Dynamic Revenue Orchestrator:** Prioritize Orders(High/Default/Bulk), Staged Assetization, Cross Plan dependencies, task-assignment rules, Future Dated Steps(Execute On). 신규 object `FulfillmentTaskAssignmentRule`; 신규 invocable `submitSalesTransaction`; 신규 metadata `DynamicFulfillmentOrchestratorSettings`(v61.0).
- **Billing(Enterprise·Unlimited·Developer):** **Milestone Billing**(later in Spring '25), **Generate Usage-Based Invoices with Usage Management**, Custom Invoice PDF Documents(Invoice Batch Document Generation API), Invoice Group Type, **Chart of Accounts / Transaction Journals**(General Ledger), Invoice Scheduler 기능(Ad Hoc·Auto Deactivation·Multicurrency·Editing), Suspend/Resume Billing, Invoice Preview API, Invoice Ingestion API. 신규 object: `AccountBillingAccount`·`BillingAccount`·`BillingMilestonePlan`·`BillingMilestonePlanItem`·`GeneralLedgerAccount`·`GeneralLedgerAcctAsgntRule`·`TransactionJournal`·`InvoiceDocument`. 신규 platform event `BillingScheduleCreatedEvent`. **API v63.0+에서 InvoiceLineTax의 `Product2Id`·`Quantity`·`UnitPrice`, CreditMemoLineTax의 `Product2Id` 제거(상위 라인 사용).**

---

## Omnistudio

> Intro(36957): "Omnistudio now offers a standard designer and list view for all components." (Where 공통: Lightning Experience·Experience Cloud sites, Enterprise·Performance·Unlimited where Omnistudio enabled.) maturity 태깅 항목 없음 — 전부 enhancement.

- **Build Omnistudio Components More Easily with the Standard Designer** — Flexcards·Omniscripts·Integration Procedures·Data Mappers의 standard runtime designer. Customer Support로 활성화.
- **Easily Browse Through Omnistudio Components with List Views** — list page에서 import/export 불가 → Salesforce CLI 사용.
- **Proactively Monitor and Manage the Health of Flexcards and Omniscripts Using Omnistudio Design Assistant** — real-time feedback.
- **Perform Advanced Apex Class Check on Permission Sets or Permission Set Groups** — `PerformAdvancedCheck` + `ApexClassCheck` flag. 주의: bulk 시 SOQL query limit 오류 가능.
- **Access Omnistudio Capabilities Anywhere on the Web with OmniOut** — Flexcards/Omniscripts를 표준 web component로 컴파일.
- **Format Text in Omniscripts and Flexcards** — Lightning Rich Text Editor가 TinyMCE 대체.
- **Explore Omnistudio's Refreshed Visual Style with SLDS 2** — Omnistudio SLDS 2 theme.
- **Integrate Guest User Data on Experience Cloud with OmniAnalytics** — guest user 기본 ON.
- **Use Omniscript Saved Sessions in Emails and Email Templates** — OmniScriptSavedSession object → RelatedTo 필드.
- **Save Costs and Time with Built-In Translations for Omniscripts and Flexcards**.
- **Seamlessly Enable Omnistudio Metadata in Scratch Orgs by Updating the Org Shape File**:

```
"OmniStudioSettings": {
"enableOmniStudioMetadata": true
}
```

- **Upgrade to a Secure Node.js Version for OmniOut** — Node.js **18.20.4 ~ 22.11.0**.
- **Securely Deploy Omnistudio Components…** — Build Tool > 1.17.11, Node.js > 18, Puppeteer 5.3.1 → 21.11.0. **Puppeteer 업그레이드: January 03, 2025.**
- **Accessibility Enhancements in Omnistudio** — Radio/Radio Group의 Read-Only → Disabled.
- **Deprecation and End of Support for AngularJS-Based Omniscripts** — Omniscript LWC framework로 마이그레이션. **Salesforce ended support on December 31, 2022.**

---

## 관련 노트
- [[Spring '25]] — Spring '25 릴리즈 허브(Apex·LWC·Flow·API·DevOps)
- [[Spring '25/Industries]] — 산업 특화 클라우드 peer(Health·Financial·Manufacturing 등)
- [[Spring '25/Agentforce]] — Agentforce/Einstein(Sales·Service·Marketing·Data Cloud AI 연계)
- [[Spring '25/Development]] — Apex·LWC·API·MuleSoft 개발자 변경
- [[Spring '25/Release Updates]] — 릴리즈 업데이트 강제 적용 일정
- [[Summer '25/Clouds]] — 다음 릴리즈(v64.0) Clouds
