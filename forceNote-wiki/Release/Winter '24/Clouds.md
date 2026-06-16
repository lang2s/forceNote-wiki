---
tags: [release, winter_24, clouds, sales, service, data-cloud, analytics, experience, commerce]
source: salesforce_winter24_release_notes.pdf
created: 2026-06-16
aliases: [Winter '24 Clouds, 윈터 24 클라우드, Sales Service Data Cloud Experience Commerce Analytics]
---

# Winter '24 — Clouds

> 허브: [[Winter '24]]
> Winter '24(API v59.0) 클라우드별 변경 — Sales(Pipeline Inspection·Revenue Intelligence·Buyer Assistant GA)·Service(Enhanced Omni Supervisor/Wallboard GA·Enhanced Apple Messages for Business GA·Enhanced WhatsApp)·Data Cloud(Data Graphs·Snowflake OAuth·Batch Data Transform)·Experience Cloud(Enhanced LWR 기본화·Actions Bar/Record Detail/Dynamic Redirect GA)·Commerce·Analytics(Staged Data GA·GA4 GA·Tableau GA)·Revenue·Marketing·CMS·Slack. Industries는 별도 노트로 분리.

---

## 개요

이 노트는 Winter '24 릴리즈 노트의 **클라우드 챕터들**을 정리한 spoke다. AI/Einstein 항목은 1줄로만 언급하고 상세는 [[Winter '24/Einstein]]에 위임한다. Industries 챕터는 분량이 커서 별도 노트 [[Winter '24/Clouds-Industries]]로 분리했다.

> 범례: **GA**=Generally Available · **Beta** · **Pilot** · **변경**=Enhancement · **RU**=Release Update

---

## Sales Cloud

**챕터 개요(verbatim):** *"Einstein Conversation Insights users can now create call summaries with one click thanks to Einstein. In Pipeline Inspection, see if the right people are involved in deals… Get a detailed history of changes to opportunity splits, opportunity product splits, and teams… In Enablement, jump-start your sales teams…"*

- **Einstein Conversation Insights** — "Create Call Summaries Powered by Einstein"(one-click, voice+video, next step + 고객 피드백). 그 외: Review Calls with Ease, Match More Related Records Automatically, Share Conversation Data with Users with Call Access, Use Improved Transcripts for Voice and Video Calls. (Einstein 상세 → [[Winter '24/Einstein]])
- **Opportunity Splits 감사 이력** — "IdeaExchange Delivered: Ensure Accurate Sales Compensation with Audit History for Splits and Opportunity Teams"(opportunity split·product split·team 변경의 상세 이력). + "Optimize Your Users' Opportunity Product Splits View with Custom Fields."
- **Revenue Intelligence** — CRM Analytics dashboard와 Pipeline Inspection의 pipeline progress flow chart를 통합한 data-driven sales 솔루션. 하위: Monitor the Health of your Sales Engine, Explore Sales Scenarios with the Commit Calculator, Understand How your Products Sell in Different Segments, Upload Quota Data, Updated Einstein Account Management App, Track Historical Changes in Formula Fields.
- **Pipeline Inspection** — Keep Deals Moving by Involving the Right People; Speed Through Your Opportunities with a Revamped Pipeline Inspection Page; Edit More Fields Inline; Get Pipeline Inspection Opportunity Detail and Insights in Collaborative Forecasts; Track Performance with Pipeline Inspection in Salesforce PRM.
- **Sales Engagement** — **Accelerate Sales Cycles with a Buyer Assistant (Generally Available)** — **GA**(Buyer Assistant Sales Template GA 포함). Cadence Wait Steps Are Being Retired.
- **Sales Cloud Everywhere** — UI 업데이트, multi-row workspace editing.
- **Forecasting** — Use Multiple Variables for Forecasting Data(SAQL `arimax`); Round Forecast Amounts; Improve Sales Forecast Accuracy with Manager Judgments.

---

## Service Cloud

- **Follow Your Agents' Work Easily with the Enhanced Omni Supervisor Experience (Generally Available)** — **GA.** Omni-Channel **Wallboard**(실시간 메트릭, 이전엔 pilot). 신규: summary graphical view, skill/queue 필터, Raised Flags widget, time window(15/30/45/60분). Professional/Enterprise/Performance/Unlimited/Developer.

> ⚠️ **GA 범위 주의:** "(Generally Available)"이 붙는 것은 **Supervisor/Wallboard** 경험뿐이다. 우산 격인 **Enhanced Omni-Channel / Enhanced Agent**(Enhanced Agent UI, pause work, summary wallboard, "Speed Through Work with the Omni-Channel Enhanced Agent Experience")는 이 PDF에서 GA로 라벨링되지 않았다. 전체 Enhanced Omni-Channel을 GA라고 부르면 안 된다.

- **Improve Multi-Channel Agent Efficiency with Interruptible Capacity.**
- **Introducing Enhanced Apple Messages for Business (Generally Available)** — **GA.** Apple Messages for Business 채널 생성. Enterprise/Unlimited/Developer. messaging component(verify identity·Apple Pay·embed apps), collaboration tool(supervisor whisper/flag·transfer), channel option, proactive messaging.
- **Enhanced WhatsApp** — "Activation Step Added for Enhanced WhatsApp Channels", "Upgrade to Enhanced WhatsApp from a Standard Channel or External Provider", "Send Automated Notifications with the Send Conversation Messages Action"(enhanced WhatsApp + Messaging for In-App, Messaging for Web 아님). WhatsApp Outbound Messages add-on. template category: Marketing, One-Time Passwords, Transactional.
- **Initiate Conversations in Enhanced Messaging Channels and Messaging for In-App** — Initiate Messaging Session permission 필요.
- **Knowledge** — "Turn On Lightning Article Editor and Article Personalization for Knowledge"(Release Update, Spring '24 list → [[Winter '24/Release Updates]]).
- **Service Intelligence** — "Reduce Costs and Improve Operations with Service Intelligence"(Data Cloud + CRM Analytics + Einstein Conversation Mining), "Apply More Service Assets in Data Cloud"(Service Data Kit v2.0). Enterprise + Unlimited, 추가 비용.
- **Einstein for Service** → [[Winter '24/Einstein]] (Work Summaries GA, Service Replies GA, Grounding GA, Article Answers GA, Cross-Lingual GA, Mid-Conversation/Conversation Catch-Up summary).
- **Routing** — Audit Queue Membership Changes with Event Monitoring(Group Membership event type); IdeaExchange Delivered: View Queue Members with Reports.

---

## Data Cloud

**챕터 개요(verbatim):** *"Enable Data Cloud objects and insights on your Contact or Lead standard or custom fields. Explore expanded record home page view customizations."*

- **Retrieve Your Customer 360 in Near Real Time with Data Graphs** — Data Graphs 신규 기능(2024년 1월 1일 추가).
- **Drive Personalization Using Google Cloud Vertex AI Models with Data Cloud** — Vertex AI.
- **Share Data in Near Real-Time Between Data Cloud and Snowflake** + **Get Full Snowflake OAuth Parity** — Snowflake Output connector·Sync Out for Snowflake가 Snowflake input connector와 일치하는 full OAuth 기능을 갖춘다.
- **Batch Data Transforms** — Use Data Model Objects in Batch Data Transforms; Automate Batch Data Transforms; Fix Errors and Edit Batch Data Transforms; Maintain Multiple Data Sources with Multiple Output Nodes.
- **Data Cloud Reports / Dashboards** — "Find Answers to Business Questions with Data Cloud Reports" + Data Cloud dashboard(둘 다 2023년 10월 23일 GA로 Release Note Changes에 발표).
- Migrate to New Data Cloud Permission Sets; Refine Access with Data Spaces Feature Permissions; Access Profile Explorer Using a New Permission; Enable/Disable Data Cloud AI and Beta Features with Feature Manager.
- **Prioritize Campaigns with Waterfall Segments (Pilot)** — **Pilot.**
- Query Segment Data via Connect REST API; Create and List Segments in a Data Space via Connect REST API; Simplify Hierarchical Data with the Flatten Transformation; Add More Metrics to a Calculated Insight; Connect to Your Data Cloud Instance Automatically During Setup; View Daily Summary Results for Identity Resolution Ruleset Processing.
- Customize Data Model Object Record Home Pages; Get a 360-Degree View of Your Accounts; Use Data Cloud Related Lists to Enrich Your Contacts and Leads; Copy Fields from Data Cloud to Enrich Your Contacts and Leads; Choose When to Trigger Data Actions for Updated Records; Connect to Data Cloud from Tableau Server with the Salesforce Data Cloud Connector.

---

## Experience Cloud

**챕터 개요(verbatim):** *"Share CMS content from any workspace with your enhanced LWR site. Now all LWR sites that you create are enhanced…"*

- **New LWR Sites Are Now Enhanced Only** — LWR 템플릿(예: Build Your Own (LWR))을 선택할 때 더 이상 enhanced LWR 사이트 생성을 opt out할 수 없다. 이전에는 Enhanced Sites and Content Platform을 비활성화할 수 있었다.
- **Share CMS Content from Any Workspace with an Enhanced LWR Site** — enhanced AND non-enhanced workspace에서 공유.
- **Do More in LWR Sites with the Actions Bar Component (Generally Available)** — **GA.** LWR 사이트에서 레코드 생성/업데이트. Edit standard action, Create a Record/Update a Record quick action, headless LWC quick action 지원. active community license ≥1 필요.
- **View and Edit More Records Using the Record Detail Component in LWR Sites (Generally Available)** — **GA.** 다수 standard + 모든 custom object 페이지(Note/Report/ServiceReport는 Record Detail에서 미지원).
- **Use Dynamic Redirect Rules in LWR Sites (Generally Available)** — **GA.** no-code 동적 URL redirect rule(pattern mapping).
- **Use Quick Actions on Related Lists in Aura Sites (Generally Available)** — **GA.** Related List - Single 컴포넌트 + View All. 최대 100 related record mass update.
- **Improve Authorization Flow Performance with JSON Web Token-Based Access Tokens (Generally Available)** — **GA**(Experience·Security 양쪽에 등장). Salesforce REST API용 JWT 기반 access token. LWR/Aura/Visualforce 사이트.
- **Translate Your LWR Site into More Languages** — 이제 최대 25개 언어(이전 10개).
- **Find Components on Your LWR Site More Easily in Experience Builder** — canvas/Page Structure panel 동기화.
- **Create Custom Property Types and Editors for Lightning Web Components in Aura Sites (Beta)** — **Beta**(이전엔 LWR 전용).
- **Add Global Styles More Easily in Enhanced LWR Sites** — DigitalExperienceBundle의 새 `sfdc_cms__styles` 폴더(`styles.css`, `print.css`).
- **Get Information About the Default Site Language in Lightning Web Components** — `@salesforce/site`의 `activeLanguages` property에 `'default: true'` attribute 추가.
- **LWS Protects Static Resources in LWR Sites** — `loadScript`/`loadStyle`(`lightning/platformResourceLoader`)가 LWS namespace sandbox에서 실행.
- **Require an Email Address to Send Chatter Email Notifications (Release Update)** → [[Winter '24/Release Updates]].
- **Query for All File Shares with ContentDocumentLink** — Query All Files permission이 ContentDocumentLink도 조회(이전엔 ContentDocument + ContentVersion만).
- Site Performance: sandbox에서 default CDN 비활성화로 CDN 안전 테스트; enhanced domains 이후 redirect notice.

---

## Commerce

- Commerce Einstein(한 단계에서 여러 product field 생성; Einstein Frequently Bought Together 컴포넌트 → [[Winter '24/Einstein]]).
- Use Pay Now for Salesforce Starter(Payments).
- Salesforce Payments용 saved payment method를 위한 Connect REST API 리소스.
- **Provide Customers Quick Access to Your Featured Catalog Items (Beta)** — **Beta.**

---

## Analytics / CRM Analytics

- **Run Sequential Recipes Faster with Staged Data (Generally Available)** — **GA.**
- **Connect to Google Analytics 4 (Generally Available)** — **GA**(GA4 event-based property framework로 migrate).
- **Embed Tableau Views to Lightning Pages (Generally Available)** — **GA.**
- **Explore Tableau Views in CRM Analytics Dashboards With Custom Filters (Generally Available)** — **GA.**
- **Explore Multiple Data Model Objects in Direct Data Using Joins (Generally Available)** — **GA.**
- **Get Full Snowflake OAuth Parity** — Snowflake Output Connection + Sync Out for Snowflake.
- **Create More Efficient Queries with Semi-Joins and Anti-Joins (Beta)** — **Beta**(SAQL join statement).
- **Transfer Ownership of Lightning Dashboards (Beta)** — **Beta.**
- **Launch a Screen Flow with a Dashboard Interaction (Beta)** — **Beta.**
- **Use Multiple Variables for Forecasting Data** — SAQL `arimax` 다변량 timeseries.
- Discover Hidden Insights on Reports with CRM Analytics(Sales Cloud Einstein perm-set 사용자용 Einstein Discovery for Reports).

---

## Revenue

- **Subscription Management** — Use Your Existing Quotes Alongside Subscription Management Quotes(`SubscriptionManagementUser` permission); Visualize Data for Both Standalone and Bundled Assets(Transaction Line Editor); Control When Order Products Are Converted to Assets(Order Product to Asset API); Price Adjustment Tier Type 값 변경(Adjustment Percentage→Percentage, Adjustment Amount→Amount, +Override); Annual label→Years; Increase Partner Engagement With Partner Discounting(Partner Account·Partner Discount Percent·Partner Unit Price field).
- **Salesforce CPQ** — 이제 standard quote만 지원. LWC rich text editor가 CKEditor를 대체.

---

## Marketing + MCAE

- **Marketing Cloud Account Engagement** — Design Engagement Programs with More Precise Wait Times(<1일 wait time, email send step 전용); API V5 for Flow(asset를 sandbox→production 복사); 오래된 visitor activity record 제거. The Twitter Connector Is Being Retired(Account Engagement).

---

## CMS

- Create CMS Workspaces Faster(streamlined setup); Share CMS Content from Any Workspace(Experience 참조).

---

## Slack

- `NotificationChannels` metadata subtype에 `slackEnabled` 필드.

> Salesforce for Slack 통합의 상세는 Salesforce for Slack Integrations Release Notes 참조.

---

## Work.com / 기타

- Heroku(Heroku Changelog 참조); IdeaExchange; Success Plans / Customer Success Score.

---

## 동작 예시 (구조 참고)

```text
// 구조 예시 — 실제 PDF 다이어그램 아님
// Service Cloud의 GA 범위 구분(우산 vs GA 라벨)
Enhanced Omni-Channel (우산)        → 이 PDF에서 GA 라벨 없음
 └ Enhanced Agent Experience        → GA 라벨 없음
 └ Enhanced Omni Supervisor (Wallboard) → "(Generally Available)" ✅ 유일한 GA
```

> 위 트리는 "GA 라벨이 Supervisor/Wallboard에만 붙는다"는 점을 시각화하기 위한 구조 예시다. PDF의 실제 다이어그램이 아니다.

---

## 관련 노트

- [[Winter '24]] — 상위 릴리즈 허브
- [[Winter '24/Clouds-Industries]] — Industries 챕터(Outcome Management·Context Service GA 등) 별도 노트
- [[Winter '24/Einstein]] — Einstein for Service·Sales·Commerce의 AI 상세
- [[Winter '24/Automation]] — Data Cloud-Triggered Flow 등 클라우드 연동 자동화
- [[Winter '24/Platform]] — Experience Cloud의 보안·Identity(JWT access token 등) 맥락
- [[Winter '24/Release Updates]] — Chatter email·Knowledge editor 등 클라우드 관련 Release Update
- [[Release MOC]]
