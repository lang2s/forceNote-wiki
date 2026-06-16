---
tags: [release, winter_25, clouds, sales, service, commerce, analytics, data-cloud, experience-cloud]
api_version: v62.0
release_date: 2024-10
created: 2026-06-16
source: salesforce_winter25_release_notes.pdf (Salesforce Winter '25 Release Notes, Tier 2)
aliases: [Winter '25 Clouds, 윈터25 클라우드, Sales Cloud, Service Cloud, Commerce Cloud, Data Cloud, Analytics, Experience Cloud, Field Service, Slack, MuleSoft, Omnistudio, Revenue Cloud]
---

# Winter '25 — Clouds

> Salesforce Winter '25 (API v62.0) 릴리즈에서 코어 클라우드 제품군(Sales · Service · Commerce · Analytics · Data Cloud · Marketing · Experience · Field Service · Revenue Cloud 등)에 추가·변경된 기능 전수.

---

## 개요

이 노트는 Winter '25 릴리즈의 **코어 클라우드 제품 기능**을 다룬다. 산업별 클라우드(Health, FSC, Public Sector 등)는 [[Winter '25/Industries]]를, Einstein/Agentforce AI 기능은 [[Winter '25/Agentforce]]를 참조한다.

> **상태 라벨링 원칙:** Winter '25 릴리즈 노트는 대부분의 feature에 `(Generally Available)`/`(Beta)`/`(Pilot)` 라벨을 **명시하지 않고** "now available" / 단순 변경으로 기술한다. 아래에서는 PDF에 명시 라벨이 붙은 항목만 GA/Beta/Pilot로 표기하고, 라벨 없는 신규 feature는 "신규"로 기술한다. (false GA 라벨 금지)

> **이 노트에서 의도적으로 제외된 항목 (→ [[Winter '25/Agentforce]]):** Field Service Einstein, Agentforce for Sales(SDR·Sales Coach·Data Library), Einstein for Sales, Agentforce Service Agent, Einstein for Service. 단 Einstein 기반이라도 해당 제품의 자체 핵심 feature(예: Einstein Case Management, Einstein Conversation Insights)는 본 노트에 "(Einstein)" 표기로 포함한다.

---

## Sales Cloud

> Agentforce for Sales / Einstein for Sales AI 항목은 [[Winter '25/Agentforce]]로 제외됨.

### Sales Fundamentals
- **Get New Foundational Features for Sales Cloud Users** (신규) — Salesforce Foundations로 Marketing/Service/Commerce/Data Cloud 기능 내장. 2024-09-17.
- **Show Sales Reps Seller Home in More Places** (신규) — 모든 standard/custom 앱에 Seller Home 카드 노출. 카드: Account, Best prospects, Contact overview, Contact suggestions, Forecast commit, Lead overview, Opportunity overview, Recent records, Salesblazer articles, To-do, Today's events, Weekly·monthly goals.
- **Opportunities — Increase Sales Team Collaboration by Assigning Opportunity Splits to Territories** (신규) — Split Territory 필드.
- **Accounts — Delivered Idea: Optimize Your Strategic Planning with Account Plans** (신규) — SWOT, relationship map. 2024-11 중후순.
- **Accounts — Enhance Reporting Structure Visibility by Associating Person Accounts and Contacts** (신규) — Reports To 필드.
- **Leads — Review and Update Settings to Capture Leads from LinkedIn (Release Update)** — LinkedIn Ads Lead Sync API가 2024-12-16 retire되기 전 재구성 필요.

### Sales Cloud Go
- **Simplify Discovery and Setup of Your Sales Cloud Features with Sales Cloud Go** (신규) — Pro Suite/Pro/Ent/Perf/Unlimited/Einstein 1 Sales.

### Einstein Conversation Insights (Sales feature)
- **Access All Your Conversation Data with Conversation Hub** (신규) — Hub 탭, metrics.
- **See the Topics That Matter Most to Your Customers with Sales Signals** (신규, Einstein) — LLM + Data Cloud, Sales Signals permission set. ECI + Data Cloud + Einstein for Sales 필요.

### Sales Engagement
- **Find Your Next Customer with Prospecting Center, a new Data Cloud App** (신규) — Fit/Engagement/Intent score. Perf/Unlimited.
- **The Campaign Member Status Chart is Being Retired** (retirement).
- **Quickly Identify Which Builder Created Each Cadence** (신규) — Version 필드.
- **Change Einstein Activity Capture Permissions for Sales Engagement Basic Users (Release Update)** — Spring '25, Standard EAC permission set 필요.

### Revenue Intelligence
- **Identify New Opportunities with Improved Einstein Account Management White Space Analysis** (신규) — clusters/cohorts.
- **Email Customers Regarding Risk Factors from Within Einstein Account Management** (신규).
- **Control Access to Data Based on Territory** (신규) — territory-based security predicate.

### Collaborative Forecasts
- **Capture Forecasts at a Point in Time with Forecast Submissions** (신규) — `ForecastingSubmission` object.
- **Improve Sales Forecast Accuracy with Manager Judgment Enhancements** (신규) — 전체 hierarchy rollup, reports/dashboards.
- **Get a Complete Forecast Picture with Opportunity Splits by Territory Forecasts** (신규).
- **Identify What You See in Each Forecast Chart More Easily** (신규) — Weekly Changes/Monthly·Quarterly Trends 개명.

### Pipeline Inspection
- **Close Date Predictions Is Being Retired** (retirement) — Spring '25. → Einstein Opportunity Scoring.

### Sales Programs and Partner Tracks with Enablement
- **Get Timely and Contextual Feedback on Your Terms** (신규) — Einstein Coach in Guidance Center.
- **Publish and Share Enablement Programs Quickly with Managed Packages** (신규) — 2GP.
- **Personalize Your Sales Programs with Your Company's Preferred Content Experience** (신규) — custom exercise types.
- **Track Job-Related Activity for Enablement Measures More Effectively with Additional Filter Operators** (신규).
- **Other Changes in Sales Programs, Partner Tracks, and In-App Guidance** (신규) — targeted prompt, prebuilt reports/dashboards, Program Builder panel, measure 이름 표시.

### Sales Performance Management
- **Salesforce Maps — Embed Maps Within Your Branded Digital Experiences** (신규) — Experience Cloud, Visualforce.
- **Salesforce Maps — The Enhanced User Experience is now Enabled for All Users** (신규) — Spring '25 standard화.
- **Sales Planning — Plan Quotas from Territory Alignments** (신규) — stamped territory data.
- **Sales Planning — Plan Territories with Live Data** (신규).
- **Sales Planning — Structure Territories that Aren't Geographic** (신규) — table view.

### Email, Calendar, and Integrations
- **Salesforce for Outlook Is Being Retired in December 2027** (retirement) — → Outlook integration + EAC.
- **Outlook Integration — Maintain Access to the Outlook Integration** (신규) — Microsoft 레거시 기능 deprecation. 필요 scope: `Calendars.ReadWrite.Shared`, `email`, `Mail.ReadWrite.Shared`, `offline_access`, `openid`, `profile`, `User.Read`.
- **Gmail Integration — Increase Efficiency by Using the Gmail Integration in the Chrome Side Panel** (신규).
- **Gmail Integration — Use Einstein Copilot with Your Gmail Integration** (신규).

### Partner Relationship Management
- **Streamline Collaboration on Shared Deals with Trusted Partners** — **Partner Connect (Generally Available)**. vendor/partner org 연결, read-only mirror record. 회사당 최대 50 vendor + 50 partner 연결. PRM add-on 라이선스. Ent/Unlimited Sales/Service Cloud.

### Sales Cloud Everywhere
- **Give Copilot Instructions That Default to the Current Record in Sales Cloud Everywhere** (신규).
- **Match Precision Improved in Contextual Insights** (신규) — URL+first+last name.
- **Speed Up Your Day with the Gmail Integration in the Chrome Side Panel** (신규).
- **Access Einstein Copilot From Your Gmail Integration** (신규) — summarize record, draft email.

### Sales Cloud on Mobile
- **Close Deals Faster with a Seller-Focused Mobile App (Generally Available)** — Seller-Focused Mobile Experience (Android/iOS, Database.com 제외 모든 edition). 2024-10. `Salesforce Mobile App: Native Seller Experience` permission.

### Other Changes in the Sales Cloud
- **Enable New Order Save Behavior (Release Update)** — order product 업데이트 시 custom app logic으로 parent order 업데이트. Winter '25부터 신규 org 기본 활성.
- **Streamline Your Workflow with a New Design for Lightning Experience** (신규) — Sales Cloud Unlimited/Einstein 1 Sales, 2024-10-11 이후 org.

---

## Service Cloud

> Agentforce Service Agent / Einstein for Service AI 항목은 [[Winter '25/Agentforce]]로 제외됨. Einstein Case Management (Beta)는 Service Intelligence 핵심이므로 "(Einstein)" 표기로 포함.

### Get New Foundational Features / My Service Journey
- **Get New Foundational Features for Service Cloud Users** (신규) — Salesforce Foundations: Marketing/Sales/Commerce/Data Cloud. 2024-09-17.
- **Discover Even More Service Capabilities with My Service Journey (Beta)** — Service area 탐색, business goal/edition/Einstein 필터.

### Service Intelligence
- **Get Faster Insights with Einstein Case Management (Beta)** (Einstein) — near real-time insights, urgency/status/customer effort/SLA, Flag to Supervisor flow. Ent/Unlimited 추가비용.
- **Monitor Agent Performance Against Target Service Level Agreement (SLA) Times** (신규) — 모든 Omni-Channel queue 기본 SLA + 최대 10개 커스텀.
- **Automate Knowledge Reviews with Salesforce Flows** (신규) — Flag for Review flow.
- **Gain Deeper Insights into Knowledge Performance with Data Categories** (신규).
- **Apply Additional Service Assets in Data Cloud** (신규) — Service Data Kit v5.0: Voice Call, Messaging Session, Operating Hours, Time Slot; `User.ContactId`, `TranscriptSourceId`/`TranscriptSourceObject`.

### Channels — Email
- **Transition to the Lightning Editor for Email Composers in Email-to-Case (Generally Available) (Release Update)** — Spring '24 GA, enforcement 미정.
- **Move Emails Easily to the Relevant Case** (신규) — Email-to-Case 재할당.
- **Use Einstein Work Summaries for Email in Five More Languages** (신규, Einstein) — FR/DE/IT/JA/ES.
- **Disable Ref ID and Transition to New Email Threading Behavior (Release Update)** — Lightning threading, secure token 매칭.

### Channels — Messaging
- **Help Customers in a LINE Messaging Channel** (신규) — enhanced LINE, Japan.
- **Manage Marketing and Service Interactions Together with Unified Messaging for SMS** (신규) — 단일 번호.
- **The Messaging for In-App and Web API Is Generally Available** — conversation 프로그래밍 관리, access token, server-sent events.
- **Messaging in the Salesforce Mobile App is Generally Available** — Message on Mobile permission. Summer '24 beta→GA.
- **Monitor Workflow Health and Customize Messaging for In-App and Web with Standard Client Events** (신규).
- **Identify Top Conversation Drivers with Einstein Conversation Mining in Messaging for In-App and Web** (신규, Einstein).
- **Transfer Messaging Sessions and Send Messaging Components in Messaging for Mobile** (신규).
- **Use Messaging for In-App and Web in Developer Edition** (신규).
- **Send End User Information to an Auto-Response Messaging Component URL More Easily** (신규).
- **Show Customers a Longer Typing Indicator** (신규) — 최대 2분.
- **Read Conversations More Easily with the Resized Chat Bubble and Avatar** (신규) — 85% (기존 65%).
- **Configure Routing More Easily in Enhanced Messaging** (신규).
- **Activate, Deactivate, and Refresh Enhanced Messaging Channels** (신규) — Apple Messages/Facebook Messenger/LINE/WhatsApp.
- **Improvements to the Send Message Action** (신규) — View History and More in the Send Message Composer; Troubleshoot Agent-Initiated Messaging with New Error Messages; Start the Conversation in Enhanced SMS Channels (messaging user record 자동 생성, Send Initial Message to Individual permission).
- **Troubleshoot Faster with Translated Error Messages** (신규) — 12개 신규 에러.
- **Delete Messaging Users Without Opening a Support Case** (신규).
- **Track Your KPIs with More Messaging Session Metrics** (신규) — `MessagingSessionMetrics` object.
- **Send Post-Chat Surveys More Easily in Messaging for In-App and Web** (신규).
- **Set App-Specific Consent Levels in Unified Messaging** (신규).
- **Send Subscription Content with the Send Conversation Messages Invocable Action** (신규).
- **Use Status-Based Capacity with Messaging (Generally Available)** — Summer '24 beta→GA.
- **Scale Communication with Expanded Session Limits** (신규) — 3,000→4,000 outbound, 총 11,000.
- **Add Messaging Components to a Package** (신규).

#### Bring Your Own Channel
- **Bring Your Own Channel for Messaging (Generally Available)** — 2024-06 GA, 기존 Partner Messaging. Ent/Unlimited/Dev + Digital Engagement add-on.
- **Bring Your Own Channel for Contact Center as a Service (CCaaS)** (신규).
- **Track Developer Updates with the Interaction Service API Developer Guide** (신규).
- **Enrich Customer Conversations with More Messaging Component Formats** (신규) — quick replies, buttons, list selectors, forms, time selectors, carousels.
- **Find Out When Your Outbound Messages Are Delivered and Read** (신규).
- **Enhance Operational Efficiency by Syncing Messaging Queues with a CCaaS Partner System** (신규).
- **Control Your Setup with Your Own Custom OAuth Connected App** (신규).

### Channels — Voice
- **Expand Your Contact Center Capabilities with Integrated Voice and Messaging** (신규) — BYO CCaaS.
- **Troubleshoot Errors and Retry Provisioning Contact Centers with Detailed Error Messages** (신규).
- **Generate the Telephony Usage Report for Billing Details (Beta)** — Amazon Connect 번호별 사용량.
- **Sync Phone Numbers Automatically for Disaster Recovery** (신규) — Default TDG, Amazon Connect Global Resiliency.
- **Get the Latest Enhancements for Your Amazon Connect Contact Center** (신규) — Contact Center v16.0.
- **Customize the Partner Telephony Contact Center Setup Experience with Partner Icons** (신규) — `customIconId` on `ConversationVendorInfo`.
- **Enhance Operational Efficiency by Syncing Combined Messaging and Messaging Queues with a CCaaS Partner System** (신규).
- **Customize How Call Information Is Organized with Sales Engagement** (신규).
- **Pass the Conversation Intelligence Rule Name as Input to a Flow (Release Update)** — `ruleDevName`, Winter '25 enforce.
- **Use an Apex-Defined Variable for All Intelligence Signal Types (Release Update)** — `intelligenceSignals`, Spring '25 enforce.
- **Display Call Controls Only in Active Omni-Channel Sessions** (신규).
- **Perform Enhanced Call Type Analyses Using Call Subtypes** (신규) — `callSubtype`.
- **Keep Records Organized by Automatically Linking Voice Calls to Opportunities** (신규) — `VoiceCall.RelatedRecordId`.

### Channels — Social / Chat / Channel Tools
- **Social Customer Service Starter Pack Is Being Retired** (retirement) — 2024-11-18.
- **Embedded Appointment Management Is Being Retired** (retirement) — 2025-06-17, → Field Service.
- **Embedded Flows Is Being Retired** (retirement) — 2025-06-17, → Experience Cloud.
- **Legacy Chat Is Being Retired** (retirement) — 2026-02-14, → Messaging for In-App and Web.
- **Authenticate Messaging for Web in Channel Menu with User Verification** (신규).

### Knowledge
- **Integrate Knowledge and Unified Knowledge with Data Cloud** (신규) — RAG. 131,000자→100MB, 25MB+ 미인덱싱.
- **Connect Unified Knowledge to More Systems** (신규) — Github, ServiceNow, Madcap Flare, Helpjuice.
- **Organize your Knowledge Articles by Mapping Labels to Fields and Data Categories** (신규).
- **Get More Done in the Lightning Article Editor** (신규) — accordion summary, Latin symbols, spell-check, directionality, table border, screen reader 개선.
- **Turn On Lightning Article Editor and Article Personalization for Knowledge (Release Update)** — 2025-06-01 enforce. W3C accessibility checker, visibility rules.
- **Run the Lightning Knowledge Migration Tool** (신규) — Classic Knowledge data model retire (Summer '25). 2025-06-01.

### Entitlements and Milestones
- **Boost Service Efficiency by Automating Milestone Actions with Flows** (신규) — milestone completed/nearing violation/violated 시 flow auto-trigger (email alerts, record update, Slack 알림). Prof/Ent/Perf/Unlimited/Dev.

### Employee Service (신규 솔루션)
- **Simplify Information Access, Service Requests, and Case Creation with Employee Hub** (신규) — Experience Cloud. Service Cloud Employee Hub Community User Add-On 라이선스.
- **Manage Employees and Inquiries Effectively, and Resolve Cases Efficiently with HR Service Workspace** (신규) — Workday integration, Ent. Service Cloud Employee Hub HR Service Workspace Add-On 라이선스.
- **New and Changed Objects** — `EmpUserProvisionProcessErr` (신규 `AccountId` 필드), `Employee2`.

### Routing
- **Delivered Idea: Support Customers While on the Go with Omni-Channel for Mobile (Generally Available)** — Omni Mobile(status-based capacity 채널, Voice 제외). Digital Engagement 라이선스.
- **Pause Messaging Sessions with Omni-Channel Status-Based Capacity (Generally Available)** — Summer '24 beta→GA.
- **Get the Latest Omni-Channel Features for Government Cloud Plus** (신규) — Hyperforce, Enhanced Omni-Channel.
- **Sync Queues for More Channel Types to Partner Systems** (신규) — Voice+Messaging 큐 → CCaaS.
- **Delivered Idea: Add a Description for Queues** (신규) — Queue Description 필드.
- **Prevent and Debug Ringer Issues by Testing the Omni-Channel Notification Sound** (신규).

### Feedback Management
- **Gain Contextual Insights with Unique Post-Chat Survey Invitations** (신규) — in-app/web messaging 종료 시 고유 survey. Ent/Unlimited/Dev where Feedback Management Starter/Growth enabled.

### Customer Experience Intelligence
- **Enhance Engagement with a Unified View of Your Customer** (신규) — CRM Analytics dashboards, agent actions. Customer Exprc Intel add-on. 2024-11말.
- **Monitor Customer Experience Intelligence Signals Usage with Digital Wallet** (신규) — CXI Signals.
- **Analyze and Enhance Customer Engagement Experience by Using CRM Analytics Dashboards** (신규) — NPS, CSAT, sentiment.

### Einstein for Service
> Service product Einstein 기능. (Agentforce Service Agent 항목과 별개) Einstein for Service add-on 라이선스.
- **Optimize Your Classification Model with Additional Input Fields (Generally Available)** (Einstein) — Einstein classification 모델 학습에 최대 30개 input field 사용. 기존엔 closed case의 Subject·Description만 고려했으나 이제 둘을 제거하고 가장 관련성 높은 case 정보로 학습 가능. String(TextArea·TextArea Long)·Picklist·Lookup 필드 타입 지원. Ent/Perf/Unlimited.
- **Use Einstein Work Summaries for Voice in More Languages (Generally Available)** (Einstein) — Work Summaries for Voice가 English·Dutch·French·German·Italian·Japanese·Portuguese(Brazilian)·Portuguese(Portugal)·Spanish(Mexico)·Spanish(Spain)·Swedish 지원(기존 English only). 2024-10-23. Ent/Unlimited + Einstein for Service add-on.
- **Customize Your Work Summaries in Copilot (Generally Available)** (Einstein) — Copilot에서 Einstein이 Work Summaries를 작성하는 방식을 커스터마이징. prompt template에 자체 formatting rule·restriction 추가로 팀 요구에 맞는 요약.
- **Get a Quick Overview of a Case and Ongoing Developments with Case Summaries (Pilot)** (Einstein) — Einstein Case Summaries로 AI 생성 case 요약. 대화·업데이트·escalation 포함 case 진행 상황을 Case Feed 또는 Case Comments에서 확인.

---

## Commerce · Revenue Cloud

### B2B and D2C Commerce — Commerce App
- **Get Contextual Guidance When Setting Up a B2B or D2C Store** (신규).
- **Work More Efficiently with the Updated Commerce UI** (신규) — accordion 네비게이션.
- **Organize Products with the Enhanced Category Workspace** (신규) — tree-view.
- **Access Product Variation Settings in One Click** (신규).
- **Access Lowest Unit Price from Your Store Settings** (신규) — EU 규정.
- **Troubleshoot Product Visibility Issues Right from the Commerce App** (신규) — Troubleshooting Assistant.
- **Automate Order Confirmation Emails** (신규) — Messaging Workspace. Commerce Growth/Advanced 라이선스, 2024-12.
- **Experience Refreshed Workspaces with Quick Filters and Bulk Actions** (신규) — Shell/Pro Suite/Ent/Unlimited/Dev.
- **Add Design Elements to Your Store Without Leaving the Commerce App** (신규) — Website Design Workspace.
- **Smoothly Transition Between Your Store and a Record Page** (신규).
- **Start Selling Online with Salesforce Starter and Pro Suite** (신규) — D2C Commerce Starter/Pro Suite (US만).

대부분 Ent/Unlimited/Dev 적용.

### Data Cloud for Commerce
- **See Analytics Dashboards and Set Goal Targets in the Insights Workspace** (신규) — Commerce Growth/Advanced 라이선스.
- **Set Up Intelligence Analytics with a Few Clicks** (신규) — Commerce Intelligence basic/advanced.

### Einstein for Commerce
- **Power Up Productivity with Agentforce Merchant Agent** (신규) — Commerce Promotions/Insights Business Objective agent topics. Einstein Platform add-on. 2024-10말. (Agentforce 항목이나 Commerce 핵심으로 포함.)

### Commerce Cart and Checkout
- **Let Customers Complete Purchases on Any Page** (신규) — mini cart, 신규 스토어 기본 활성.
- **Streamline the Shopping Experience with Continuous Scrolling** (신규).
- **Address Fields Now Autocomplete for D2C Stores** (신규).
- **Offer Weight-Based Shipping Prices** (신규).
- **Turn Off Shipping for Non-Physical Products** (신규).
- **Switch Between Managed and Custom Checkout Without Losing Settings** (신규) — Cart Calculate API 필요.
- **Automate Updates to the D2C Checkout Experience with Managed Checkout (Beta)** — managed checkout 자동 업데이트(republish 불필요). Salesforce Payments 필요, 구독 미지원.
- **Use Business Accounts for B2B Store Guest Checkout** (신규) — person/business account 선택.
- **Offer One-Click Checkout for Returning Customers** (신규) — summary mode.

### Commerce Promotions
- **Offer Customers Shipping Rate Promotions** (신규) — 할인당 최대 25 shipping rate.
- **Manage Promotions with a Refreshed Promotion Workspace** (신규) — row-level actions, clone/delete.

### Commerce Components
- **Display Hi-Res Images and Alternative Views with the Enhanced Product Image Gallery** (신규) — LWR.
- **Faster Image Loads for Enhanced Shopping Experiences** (신규) — aspect ratio/image size 속성.
- **Keep Customers Informed About Orders with Real-Time Updates** (신규) — order status tracker.
- **Control Last Name Visibility in the Order Lookup Page** (신규) — Hide Last Name 기본 활성.
- **Reapply Your Customizations to the Updated Reorder Modal** (신규) — Reorder 모달의 CSS 셀렉터가 변경되어 기존 커스터마이징을 신규 모달 레이아웃에 맞게 재적용해야 한다. 아래는 PDF에서 발췌한 마이그레이션 예시.

```css
/* 기존 CSS */
<style>
commerce_my_account-reorder-modal-contents h1 b { color: red; }
commerce_my_account-reorder-modal-contents button.continue-shopping { border-radius: 10px; }
</style>
/* 신규 모달 레이아웃 유지 */
<style>
lightning-modal-header h1 { color: red; }
lightning-modal-footer button.primary-action-button { border-radius: 10px; }
lightning-modal-footer button.close-button { border-radius: 10px; }
</style>
```

### Commerce Search
- **Resolve Errors on the Redesigned Search Index Page** (신규) — CSV 다운로드.
- **Displayable Product Fields Toggle Has a New Name and Location (Beta)** — "Displayable Fields"로 개명, Store Settings 위치.

### Additional Commerce Features
- **Bundle Products to Increase Average Order Value** (신규) — 구독·order servicing 불가.
- **Set Targets to Track the Progress of Your Goals** (신규).
- **Use Salesforce Tax to Automate Tax Processes for Custom Checkout** (신규) — third-party tax provider.
- **Simplify Tax Transactions with Flows** (신규) — Create Tax Transaction flow, Record Tax Reversals flow.
- **Use Enhanced Domains to Serve Your Salesforce CDN for LWR Commerce Stores** (신규) — Cloudflare, Ent/Perf/Unlimited.
- **Improve Performance and Security of the CDN for LWR Commerce Stores** (신규) — compress content, HTTP 가속.
- **Access Product Media from Any CMS Workspace (Beta)** — Enhanced LWR Site 업그레이드 후 CMS workspace.

### Omnichannel Inventory
- **Add and Edit Inventory SKUs** (신규) — Omnichannel Inventory console에서 SKU 추가(최대 20)·편집(최대 100). Professional/Unlimited/Dev.

### Salesforce Order Management
- **Provide Customers Estimated Delivery Dates** (신규) — PDP/checkout에 예상 배송일. Delivery Estimation Service를 B2C Commerce 연결. Professional/Unlimited/Dev.
- **Tailor Service Flow Bulk Actions to Your Store's Needs** (신규) — `setBulkActionDisplay`로 bulk action threshold 제어(기본 2). Order Management Unlimited/Dev/Ent.

### Salesforce Payments (모두 Ent/Unlimited/Dev, 명시 GA/Beta 라벨 없음)
- **Set Up Your Pay Now Store Quickly and Easily** (신규) — automated guided setup.
- **Deliver an Improved Pay Now Experience to Your Customers** (신규) — 재설계 payment page.
- **Create Pay Now Links with an Improved Flow** (신규) — Generate Payment Link flow, HTML in Description.
- **Gain More Control of Payment Processing Using Manual Capture** (신규).
- **Salesforce Payments Is Now Available in Developer Edition** (신규).
- **Expand Customer Payment Options with Merchant-Initiated Payments** (신규) — Merchant-Submitted Payment + Saved Payment Methods components.
- **Monitor Payment Processing to Track Your Business's Financial Health** (신규) — Payments timeline.
- **Boost Sales by Offering More Payment Options** (신규) — Amazon Pay, Link, Affirm.
- **Let Shoppers Receive Their One-Time Passcode via Email** (신규).
- **View Payment Shipping and Billing Information to Improve Operations** (신규).

### Revenue Cloud (Revenue Lifecycle Management → Revenue Cloud로 개명)

**GA (명시):**
- **Rate Management (Generally Available)** — pay-per-use 모델 rate 정의, rate adjustment, 할인, net unit rate 계산(rating procedure).
- **Invoice Management (Generally Available)** — advance/arrears billing, 자동·확장 invoice 생성, multiple legal/tax entity, negative invoice line→credit memo 자동 변환.

**신규/변경 (라벨 없음) — 서브섹션별:**
- **Product Catalog Management** — Easily Create Qualification Decision Tables by Using Templates; Show Only Eligible and Available Categories; Improve Search Results by Indexing Your Product Catalog (typo tolerance); Define Ramp Segment Types for Products Whose Price and Volume Can Change Over Time; Organize Bundled Products Better With Nested Groups (cardinality); Improve Scalability and Efficiency of Product and Catalog Data Management; Guided Product Selection; **Product Discovery** — Show Qualification and Pricing Information Only When Necessary, Create a Custom Product Browsing Experience, Show Only the Available and Qualified Categories in Product Discovery, View Nested Groups for Product Bundles, 신규 invocable actions (`findProducts`, `getProducts`, `getProductDetails`), `ProductDiscoverySettings` metadata type.
- **Salesforce Pricing** — procedure requirement 통합, Price Tracking History, Pricing Batch Jobs, Commerce Cloud 통합 + waterfall view, proration 설정, Roll Up Price, 개선된 Derived Pricing(새 input 필드, asset pricing).
- **Product Configurator** — 규칙 생성 간소화, 규칙 오류 검사, 전체 transaction 규칙 적용, ramped quote pricing, derived product price 계산 view.
- **Transaction Management** — Usage-Based Selling, ramp deals(transaction line 분할), Advanced Approvals, customer community 사용자 quoting, Groups(자동/수동 quote/order line grouping), derived product asset 자동 추가, Add Assets action, transient lines, order 생성 알림.
- **Dynamic Revenue Orchestrator** — failed callout retry 횟수 지정, error logging, partial decomposition plan load, fulfillment step skip(step/branch), product classification, decomposition rule 검색.
- **Salesforce Contracts** — 내부 review workflow 최적화, document comparison, section lock, real-time 문서 생성(Single Point Requests/SPR), file-based prompt APIs.
- **Salesforce Billing Managed Package** — batch invoice posting 개선.

---

## Analytics · Data Cloud

### Analytics

**GA (명시):**
- **Launch a Flow with a Dashboard Interaction (Generally Available)** — Analytics 대시보드에서 screen/autolaunched flow 실행. text widget만 지원. CRM Analytics(LEX+Classic), Developer Edition + Enterprise/Performance/Unlimited 추가비용.
- **Explore Multiple Data Model Objects in Direct Data Using Joins (Generally Available)** — Direct Data for Data Cloud가 DMO 4종 join 지원, 조인 데이터 필터·조건부 서식. 기존엔 custom SQL 필요.
- **Transfer Your Snowflake Data to CRM Analytics Using VPC on AWS (Generally Available)** — Snowflake on AWS용 VPC 커넥터로 Data Manager 동기화. Salesforce Private Connect add-on 필요.

**Beta (명시):**
- **Export from Data Cloud-connected CRM Analytics Assets (Beta)** — DMO 쿼리 결과를 CSV로 export(최대 32MB). Data Cloud Dev/Ent/Perf/Unlimited. Support 문의 필요.
- **Do More with Custom Report Types (Beta)** — Setup의 개선된 Custom Report 페이지, list view 개인화, layout editor에 lookup으로 최대 1,000 필드.
- **Highlight Min and Max Aggregates for Date Fields (Beta)** — DMO 리포트에서 date/datetime/row-level formula 필드의 min/max aggregate.
- **Analyze Semantic Data Models in Data Cloud Reports (Beta)** — semantic model 기반 표준 Data Cloud 리포트(최대 20 Data Cloud objects, 기존 4개). 2024-11 시작. Data Cloud Credits 소비.
- **Give Users Read-Only Access to Recipes (Beta)** — Recipes View Only 권한. Data Manager에서 recipe 조회만.
- **Improve Snapshot Data Recipe Performance with Advanced Append Output (Beta)** — Output 노드의 Existing Dataset (Append) 옵션으로 append된 행만 등록.
- **Control Access to Data Based on a User's Assigned Territories (Beta)** — Territory Management 2.0 territory hierarchy를 security predicate에 참조. 예:

```
'Territory2.TerritoryIDs' in ["$UserTerritory2Ids"]
```

**Pilot (명시):**
- **Event Monitoring Platform Events Connector (Pilot)** — Real-Time Event Monitoring 데이터를 Platform Events connector로 Data Cloud에 import.

**신규/변경 (라벨 없음):**
- **Add Calculated Fields to Your Lightning Reports with Einstein Generative AI** — Einstein Report Formula Generation. 자연어→formula. LEX Ent/Perf/Unlimited/Dev + Einstein 1 Sales/Service + DC Report GPT add-on.
- **Create Data Cloud Reports with a Single Click** — Calculated Insights/DMO list view 또는 record page에서 리포트 생성.
- **Include Smart Totals Only in the Reports You Want** — DMO 리포트/차트의 smart totals on/off 토글.
- **Download Directly from Dashboard Widget Action Menus** — widget 메뉴에서 직접 이미지/데이터 다운로드.
- **Mark Downloaded Images and Exported Data as Confidential** — confidentiality notice ("Confidential Information - Do Not Distribute").
- **Add Greater Precision to Your Queries with More Filter Operators** — Does Not Contain, Does Not Start With, Ends With, Does not End With.
- **Control Tooltip Visibility on Link Widgets** — Link widget tooltip 비활성화.
- **Make Dashboard Metrics Stand Out with Number Widget Enhancements** — italic 서식 + tooltip 토글.
- **Manage Action Menus on the Repeater Widget** — Repeater widget action menu 비활성화.
- **Get More Table Widget Options with Header Formatting and Column Sorting** — header text 정렬·서식, query interaction table 정렬.
- **Improved Experience for Adoption Analytics Templates** — lookback period 4일로 확장, "Users with no interactions"에 Revenue Intelligence 포함, WaveChangeEA dataset 버그 수정.
- **Add Billing Information for Google BigQuery Connections** — project billing ID. compute/storage 분리.
- **Download Data Sync Job Logs in Data Manager** — job 로그 다운로드.
- **Analyze Data Across Multiple Data Spaces** — 여러 data space + DMO 쿼리.
- **Test CRM Analytics Endpoints in Postman** — CRM Analytics Connect API Postman collection. LEX Ent/Unlimited/Dev.
- **Connectors for Google Universal Analytics Have Been Removed** — Google Analytics/Core Reporting v4 커넥터 제거(2024-07-01 UA 종료). GA4 커넥터로 전환.
- **Externally Built Models in Einstein Discovery Are Retired** — 2024-07-31부로 외부 ML 모델 사용 불가.
- **Accessibility Enhancements** — Lightning Reports/Dashboards 및 CRM Analytics 접근성 개선.

**Tableau / Marketing Cloud Intelligence:** 외부 release notes 포인터(Tableau Cloud/Desktop/Prep/Server; Marketing Cloud Intelligence Data Pipelines). Winter '25 본문에 개별 GA feature 없음.

### Data Cloud (GA-heavy)

**GA (명시):**
- **Improve Search Accuracy with Hybrid Search (Generally Available)** — vector search + keyword search 결합, ranking factor(recency, popularity) 구성.
- **Prioritize and Limit Audience for Activation (Generally Available)** — activation 상한 10,000 recipient, 랜덤 선택 + activation attribute 랭킹으로 우선순위.
- **Ingest Company Data into Data Cloud with ZoomInfo Connector (Generally Available)** — ZoomInfo 회사 인텔리전스 export.
- **Ingest Data Stored in a PostgreSQL Database into Data Cloud (Generally Available)** — AWS Aurora/RDS/Azure PostgreSQL.
- **Transcribe and Index Audio and Video Files (Generally Available)** — 오디오/비디오 전사·인덱싱. FLAC/MP3/WAV, AVI/MOV/MP4. Whisper-Large-V3 모델.
- **Work with Data Cloud in a Sandbox (Generally Available)** — 대부분 Data Cloud feature sandbox 지원. Summer '24 beta→GA. 기존 beta 버전 2025-01-01 deprovision.

**Beta (명시):**
- **Manage B2C Communications Using Capping Control (Beta)** — B2C 커뮤니케이션 cap, department-level threshold.
- **Quickly Ingest Data into Data Cloud with Upload File (Beta)** — 로컬 CSV → data lake object, preview.
- **Data Cloud Includes More Third-Party Connectors (Beta)** — 100+ 커넥터. 신규: Act-On, ADP, Amazon Marketplace, Apache Cassandra, Apache HBase, Apache Impala, Apache Phoenix, Azure Analysis Services, BigCommerce, CockroachDB, Facebook, Google Sheets, Instagram, LinkedIn Ads, Microsoft 365 Excel Online, Microsoft Power BI XMLA, Microsoft SQL Server Analysis Services, OData, Paylocity, SAP ASE, SAP IQ, Shopify, Splunk, Square, Stripe, Twilio, Veeva Vault, WordPress, X Ads, YouTube Analytics, Zuora.
- **Bring Unstructured Data into Data Cloud with MuleSoft Direct (Beta)** — Confluence, Google Drive, SharePoint, Sitemap.

**Pilot (명시):**
- **Create Effective Marketing Campaigns with Static Attributes (Pilot)** — campaign ID/description/target audience/products 등 정적 attribute로 Activation segment.

**신규/변경 (라벨 없음) — 전수:**
- **Record Caching for Real-Time Data Graphs Is Changing** — real-time data graph record caching 비활성화 불가, 최소 caching 3일(기존 1일), Max # Records 기본 10,000(기존 100,000). 2024-12 롤아웃.
- **Create Real Time and Waterfall Segments in a Sandbox** — DataKit Connect APIs.
- **Target Specific Customers with Nested Segments in Rapid Segments**.
- **Quickly Find Attributes for Your Segments with Improved Search**.
- **Exclude Modified and Deleted Records From Incremental Activation**.
- **Connect Your Java Apps to Data Cloud** — Data Cloud JDBC driver, 통합 Data Cloud SQL dialect.
- **Revolutionize Multi-Org Architecture with Data Cloud One** — 양방향 metadata 공유, connected org.
- **Secure and Expand Access to Enriched Related Lists** — Data Access Level.
- **Share Data Between Data Cloud and Databricks Using Lakehouse Federation** — Unity Catalog.
- **Lock and Protect Your Custom Metadata in a Data Kit** — managed package.
- **Create Dedicated Data Cloud Packages**.
- **Add Identity Resolution Rulesets to Data Kits**.
- **Activate Waterfall Segments to a Data Extension**.
- **Deploy Activations Using Data Kits** — Amazon S3, Marketing Cloud Engagement targets.
- **Configure a Lookback Period for a Segment** — 1일~2년, batch segment만.
- **Activate a Data Model Object to an Activation Target**.
- **Fine-Tune Activation Membership Filtering by Adding Related Attributes** — 1:N, 1:1, N:1.
- **Segment Schedule Time is Used to Ensure Accurate Filtering** — Is Anniversary Of/Is Not Anniversary Of, BYOL.
- **Share Data in Near Real-Time Between Data Cloud and Amazon Redshift** — zero copy data shares.
- **Expand Identity Resolution With Cross-Object Matching**.
- **Focus on Relevant Attributes When Creating Einstein Segments** — suggested/additional.
- **Get Optimized Segment Results with Einstein Data Prism**.
- **Deploy an Amazon Kinesis Data Stream Using a Data Kit**.
- **Get User Agent Data in the Data Cloud Web and Mobile SDK**.
- **Include More Attributes in Your Activation to LinkedIn** — First/Last Name, Country Code, Google Ad ID, Company Title, Job Title.
- **Interaction Studio is Renamed Marketing Cloud Personalization**.
- **Batch Data Transforms Are Updated Incrementally**.
- **Flatten JSON into Tables with Data Transforms** — Flatten JSON transform, `JSON_TABLE` function.
- **Authenticate the Heroku PostgreSQL Connector Using Mutual Transport Layer Security** — mTLS.
- **Data Cloud Setup is Streamlined** — Data Cloud Admin permission set 사전 할당 불필요.
- **Filter Records for Copy Field Enrichments**.
- **Roll Up Data Model Objects in Data Graphs**.
- **Set a Refresh Frequency for a Data Graph** — 매시간~월 1회.
- **Save a Draft of an Unbuilt Data Graph**.
- **Use Search to Add a DMO to a Data Graph**.
- **Save the Salesforce CRM Permission Set Without License Restrictions** — `sfdc_c360a_sfdctrust_permSet` → `sfdc_a360_sfcrm_data_extract`, View All Data 허용.
- **Data Cloud Einstein Lookalikes in Segmentation Is Being Retired** — 2024-09-27.
- **Users Can View Only DLOs in Data Spaces They Have Access To** — View All/Modify All 제거.
- **Connect More Foundation Models for Generative AI Solutions** — Einstein Studio, Open Connector spec.
- **Create Secure AWS Integrations Using Private Connect for Data Cloud** — AWS PrivateLink.
- **Access Management Made Easy With the View All Data Permission** — Data Cloud Salesforce Connector permission set.
- **Monitor Data Cloud Sandbox Consumption in Near Real-Time with Digital Wallet**.
- **Use Identity Provider Authentication for an Amazon Redshift Data Federation Connection** — IDP-based auth.
- **Share Insights and Segments With Other Data Cloud One Companion Orgs**.
- **Improve Predicted Outcomes with Actionable Variables** — prescriptions/recommendations.
- **Simplify Training Multiple Model Versions with Autopilot**.
- **Train Predictive Models with Boolean Inputs**.
- **Enrich Flow with Predictive and Prescriptive Insights**.
- **Use Transformations for Predictive and Prescriptive Intelligence** — batch data transforms, Model Builder.

---

## Marketing · Experience Cloud

### Marketing — Einstein Personalization
- **Provide Personalized Experiences with Einstein Personalization (Generally Available)** — Data Cloud 기반 AI 추천·개인화 콘텐츠 실시간.
- **Extend Personalized Experiences in Marketing Cloud Using Einstein Personalization** (신규) — Marketing Cloud Growth/Advanced 통합.
- **Enhance Your Websites with Personalized Experiences Using Web Personalization Manager** (신규) — Data Cloud Web SDK.
- **Monitor Einstein Personalization Consumption in Near Real-Time with Digital Wallet** (신규).

### Marketing — Marketing Cloud Account Engagement (모두 신규, 명시 라벨 없음)
- **General Enhancements** — Discover a New Campaign Experience with Marketing Cloud (Growth/Plus/Advanced/Premium), Troubleshoot Email Send Issues, Find and Merge Duplicate Prospect Records, Copy Forms and Emails to a Salesforce CMS Workspace (.pdf/.mp4/.zip), Gain Insights with Form and Landing Page Engagement Data in Data Cloud, Create More Data Cloud Segments per Business Unit (최대 25, 기존 5), Open System Email Links in the Lightning App, Pause or Cancel Permanent Prospect Deletions.
- **APIs and Integrations** — Account Engagement API v5: Manage Tags, Send List and One-to-One Emails, Read and Query Prospect Permanent Deletion Requests.

### Marketing — Marketing Cloud Engagement
- **Apps, Setup, and Security** — General Enhancements to Package Manager, **Social Studio Is Being Retired** (2024-11-18), Enable Branded Email Sending Domains and URLs in the MC Engagement Interface (Sender Authentication Package), Rotate Client Secrets in Installed Packages (OAuth 2.0 staged secrets).
- **Cross-Cloud Products** — Process Builder Is Retired for Marketing Cloud Connect (→record-triggered flows), Let Customers Link a Distributed Marketing Send to an Active Campaign.
- **Einstein and Analytics** — 6개 언어 generative content, AI content audit export, business unit별 brand identity.
- **Journeys and Automations** — Journey History success rate 정확도, Journey Audit Log, high-throughput sending 권장.
- **Messaging** — SMS link shortening, WhatsApp 경험 개선.
- **Marketing Cloud Intelligence** — DoubleVerify, Criteo, SharePoint connector 추가.
- **Archived Release Notes** — Spring '24 이전 PDF.

### Marketing — Marketing Cloud (Growth/Advanced) ("Marketing Cloud Growth → Marketing Cloud"로 개명)
- **Get More with Marketing Cloud Advanced Edition** (신규) — conversational SMS, A/B testing, AI tools.
- **Update the Required Marketing Data Kits** (신규).
- **Create More Relevant Messages** (신규) — dynamic email content, event-triggered content, merge fields.
- **Improve User Experiences with These Content Enhancements** (신규) — clone content, decorative image.
- **Save Time with Grounded Agentforce and Einstein AI Tools** (신규).
- **Streamline Marketing Setup with These Admin Enhancements** (신규) — marketing setup assistant.
- **Level Up Your Reporting with Marketing Performance** (신규) — Tableau Einstein, embedded dashboards.
- **Interface Updates / Other Changes** (신규).
- **Advanced Edition 상세** — Boost Engagement with Einstein Features (Send Time Optimization + Data Cloud, global models), Better Understand Your Customers with Engagement Frequency and Scoring Tools, Explore Email Send Time Predictions, Choose to Boost Predictive Accuracy with Global Models, Test and Analyze Campaign Flows (2024-11 중순), Optimize Engagement with Path Experiments (Flow Experiment element, 최대 10 path, segment-triggered flows), Understand Flow Status with On-Canvas Insights, Grow Relationships with Conversational SMS (Service Cloud transfer).

### Marketing — Unified Messaging
- email/SMS/WhatsApp 통합. consent 동기화(MC Engagement↔Digital Engagement), Unified WhatsApp consent.

### Experience Cloud

**GA (명시):**
- **Configure LWR Sites Search Experience with Search Manager (Generally Available)** — Search Manager로 검색 구성, 필터, 저장·재사용. LWR Ent/Perf/Unlimited/Dev.
- **Customize URLs for Accounts and Contacts to Improve SEO (Generally Available)** — account/contact 페이지 SEO slug. enhanced LWR.
- **Customize SMS One-Time Password Delivery for Experience Cloud Sites (Generally Available)** — Customer Identity 하위.

**Beta (명시):**
- **Upgrade to Enhanced LWR Sites to Access the Latest Features (Beta)** — 기존 LWR→enhanced LWR 업그레이드(Winter '23 이후 site만). metadata: ExperienceBundle→DigitalExperienceBundle+DigitalExperienceConfig.
- **Enhance Your LWR Site Experience by Curating Data Providers on a Page (Beta)** — Apex/Record data provider.
- **Site Header component (Beta)** — 페이지별 header. logo/navigation menu/button 필드.
- **Link Files from Your LWR Site to Salesforce (Beta)** — File Upload LWC for LWR sites.

**Pilot (명시):**
- **Boost LWR Site Performance with Experience Delivery (Pilot)** — 확장성·성능 향상, SSR Playground Salesforce projects 지원, lightning-formatted-rich-text 등 SSR.

**신규/변경 (라벨 없음):**
- **Fine-Tune the Look and Feel of Your LWR Site with More Design and Layout Controls** — Theme panel, anchor header, Columns color palette, Headings 5/6. `--dxp-s-button-color-active` styling hook (Button Active color 제거됨).
- **Add Enhanced CMS Content to Your Aura Site** — News, Image, Document, custom.
- **Export and Integrate Shared Business Across Salesforce Orgs with Partner Connect**.
- **Take Advantage of the Latest Features from Mobile Publisher for Experience Cloud** — Mobile Publisher LWR site GA. snapshot prevention. Android 9+ (v12.6+). Firebase 필드 통합.
- **Secure Record Access When Enabling Digital Experiences in Preview Sandboxes** — Roles and Internal Subordinates.
- **Specify Trusted Domains for Clickjack Protection on Your Site** — enhanced LWR.
- **Enhance Your Experience Cloud Site with New Customer Identity Features** — OTP via messaging provider, social sign-on URL forwarding allowlist, headless identity (OAuth endpoint), Forgot Password error 메시지 개선. 하위: Customize SMS OTP (GA), Authentication Providers, Give Users More Ways to Log In, Headless Registration Flow, Headless Identity Draft Standard, Forgot Password Invalid Username Error.

---

## Field Service · Omnistudio

> Field Service Einstein 서브섹션(Generate Post-Work Summaries On the Go GA, Get a Daily Summary of Service Appointments, Find Service Appointments Easily by Creating Search Filters, Uncover Top Cancellation Reasons Easily Beta)은 [[Winter '25/Agentforce]]로 제외됨.

### Field Service — Resource Management
- **Manage the Field Service Integration Permission Set with More Flexibility** (신규) — 라이선스 비종속, Platform Integration User 전용.
- **Find Filters Quickly in the Appointments List** (신규) — Standard/Custom Filters.
- **Update All Dispatcher Permissions in One Permission Set** (신규) — Field Service Bundle for Dispatcher → Field Service Dispatcher.
- **Enhanced Scheduling and Optimization** 하위:
  - **Increase Flexibility and Efficiency When Scheduling Complex Work Chains** (신규) — start-after-finish dependency sliding.
  - **Gain Insights into Service Appointment Unscheduling Information** (신규) — Optimization Hub, JSON.
  - **Increase Coverage with 24-Hour Availability for Capacity-Based Resources** (신규).
  - **Increase Availability by Reshuffling and Prioritizing Service Appointments** (신규) — "keep scheduled" criteria.
  - **Enhance Scheduling Accuracy by Adding Travel Time Buffers per Territory** (신규).
  - **Get More Information About Scheduling and Optimization Requests with Activity Reports (Beta)**.
  - **Experience Better Performance with Enhanced Live Updates (Beta)** — dispatcher console Gantt 실시간, Experience Cloud 사용자도.
  - **Improve Schedule Recommendations with the Appointment Insights API (Beta)** — `getAppointmentInsights` Apex method, `ScheduleService` Apex class. SA 미스케줄 사유 반환.
- **Access Health Check in the Optimization Center Tab** (신규).

### Field Service — Asset Management
- **View Asset Health Score on the Go with the Connected Assets Add-On** (신규).
- **Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules (Release Update)** — Frequency/Frequency Type 필드 retire, Winter '26 enforce.
- **Field Service Asset Service Lifecycle Management Add-On** — Improve First-Time Fix Rates (asset hierarchical view), Improve Asset Visibility on Your Mobile App (Asset Hierarchy view, iOS/Android).

### Field Service — Operations
- **Gain Instant Access to Key Operations and Insights with Field Service Home** (신규) — Einstein 1 Field Service Edition.
- **Field Service Intelligence** — Boost and Track Team Performance (Resource Management dashboard), Gain Comprehensive Insights into Your Inventory and Products (Parts and Inventory dashboard).
- **Service Documents** — Grant Community Users Access to Document Builder (Contractor/Contractor Plus licenses), Personalize Service Documents with Company and Worker Details (User/Organization 필드), Organize Service Documents with Page Breaks.

### Field Service — Customer Engagement
- **Schedule and Reschedule Appointments with Scheduling Dependencies in Appointment Assistant** (신규).
- **Provide Real-Time Customer Guidance with the Visual Remote Assistant Mobile SDK Embedded in Your Branded Mobile App** (신규).

### Field Service — Mobile
- **Accept On-Site Payments with Tap-to-Pay** (신규) — Payments plug-in, Pay Now.
- **Reduce Distractions and Stay Focused with Standby Mode** (신규).
- **Upsell Your Business from the Field (Generally Available)** — 모바일 앱에서 quote 생성.
- **Launch Flows Silently Based on Geolocation** (신규) — platform alerts.
- **See the Status of Appointments on the Map at a Glance** (신규) — color-coded pins.
- **Customize Tabs More Easily in the Field Service Mobile App Builder** (신규).
- **Add Lightning Web Components with Attributes in the Field Service Mobile App Builder** (신규).
- **Search for Records Easily in the Field Service Mobile App** (신규).
- **Data Capture (Beta)** — Create Dynamic Forms with Data Capture Flow (Beta) (Data Capture flow type, Flow Builder); Empower Mobile Workers with Data Capture Forms (Beta) (Android/iOS).
- **Discovery Framework Based Data Capture** — Build Dynamic Forms with Discovery Framework Data Capture Flow (Beta), Improve Mobile Worker Productivity with Discovery Framework Data Capture Forms (Beta).

### Field Service — Spotlight on Field Service Content
- **Improve Your Scheduling and Optimization Proficiency with Revamped Salesforce Help Content** (신규).
- **Switch to Lightning Data Service for the Best Mobile Experience** (신규).
- **Discover What's New with Offline Usage in the Field Service Mobile App** (신규).
- **Start Your Journey with Einstein for Field Service** (신규) — Einstein Field Service User permission set.

### Omnistudio
- **Effortlessly Access Information with Distinct Omnistudio Guides** (신규) — Help 문서 3개 분리(Omnistudio / Omnistudio for Managed Packages / Omnistudio Installation and Upgrade). Omnistudio Standard→Omnistudio, Omnistudio for Vlocity→Omnistudio for Managed Packages.
- **Customize Omniscript Elements for Your Business Requirements** (신규) — Omniscript element의 HTML/CSS/JS 커스터마이징, LWC Component Override.
- **Other Improvements in Omnistudio** (신규) — Navigate action element 동작 변경 (Current Page + 특정 step target 시 해당 step으로). 예: Step1에서 Next→Step7(기존 Step8).
- **Optimize Data Mapper Performance with SOQL Query Limits** (신규) — Apex transaction당 SOQL 100개 제한 (100+ object 추출 시 중단·에러).
- **Omnistudio Minor Releases** — Spring '25 전 bug fix.
- 모두 LEX/Experience Cloud/Ent/Perf/Unlimited where Omnistudio enabled. (명시 GA/Beta 라벨 없음)

---

## MuleSoft · CMS · Slack · Work.com

### MuleSoft (포인터)
- MuleSoft Anypoint Platform 제품군. release notes는 제품별/월별 정리되며 외부 문서로 관리된다. 외부 링크: "MuleSoft Release Notes", "MuleSoft Release Note Summary by Month", "MuleSoft Documentation". **Winter '25 본문에 개별 GA feature 없음.**

### Salesforce CMS
- **Expand the Reach of Your Enhanced CMS Content** (신규) — Aura site channel publish, "Use non-enhanced APIs" 설정 기본 활성. Winter '25부터 신규 workspace 기본 enhanced.
- **Remove Channels from Enhanced CMS Workspaces and Delete Channels from Your Org** (신규).
- **Scale Content Delivery for High Performance (Beta)** — Hyperforce orgs용 Dedicated Content Delivery (beta). 신규 public channel 기본 활성.
- **Broaden Content Use and Reuse Possibilities in Enhanced CMS Workspaces** (신규) — Workspace Sharing, Shared with Workspaces 폴더.
- **Skip the Alt Text for Decorative Images** (신규) — "This image is purely decorative".
- 모두 enhanced CMS workspaces, LEX Ent/Perf/Unlimited/Dev.

### Salesforce for Slack Integrations (포인터)
- Slack + Salesforce 연결. **개별 GA feature 없음.** 외부 링크: "Salesforce for Slack Integrations Release Notes".

### Work.com (포인터)
- Business/employee/facility 대비. **개별 GA feature 없음.** 외부 링크: "Work.com Release Notes".

---

## 관련 노트
- [[Winter '25]]
- [[Winter '25/Industries]]
- [[Winter '25/Agentforce]]
