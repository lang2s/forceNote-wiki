---
tags: [release, summer_24, clouds, sales, service, experience, data-cloud, slack]
source: salesforce_summer24_release_notes.pdf
created: 2026-06-16
aliases: [Summer '24 Clouds, 서머 24 클라우드, Sales Service Experience Data Cloud Slack]
---

# Summer '24 — Clouds

> Summer '24(API v61.0) 릴리즈 노트의 클라우드별(제품군별) 변경 사항 전수 — Sales·Service·Experience Cloud·Data Cloud·Analytics·Commerce·Field Service·Industries·Marketing·MuleSoft·Revenue(RLM)·Work.com·Slack의 GA·Beta·Pilot·Developer Preview + 신규 객체·API + 은퇴/지원 종료 항목.

> 허브: [[Summer '24]]

> [!note] AI/Einstein 항목(Einstein Copilot, Prompt Builder, Einstein Studio, Work Summaries, 생성형 AI)은 1줄로만 언급하고 상세는 → [[Summer '24/Einstein]]. RU(필수 적용) 상세는 → [[Summer '24/Release Updates]].

> 범례: **GA**=Generally Available · **Beta** · **Pilot** · **DevPrev**=Developer Preview · **RU**=Release Update · **변경**=Enhancement · **은퇴**=Retirement/Deprecation

---

## 개요

Summer '24 릴리즈 노트(Last updated September 30, 2024, API v61.0)의 클라우드 제품 도메인을 PDF 물리 페이지 기준으로 전수 정리한다(물리 = 인쇄 + 4). 본 노트는 제품군별 GA/Beta/Pilot/DevPrev 기능, 신규 객체·API, 은퇴 항목을 다룬다. AI/Einstein 상세는 [[Summer '24/Einstein]], RU 강제 시점은 [[Summer '24/Release Updates]]로 위임한다.

| 도메인 | PDF 물리 페이지(인쇄) |
|---|---|
| Sales | p.638–694 (인쇄 634–690) |
| Service | p.774–837 (인쇄 770–833) |
| Experience Cloud | p.339–350 (인쇄 335–346) |
| Data Cloud | p.206–233 (인쇄 202–229) |
| Analytics | p.127–143 (인쇄 123–139) |
| Commerce | p.144–188 (인쇄 140–184) |
| Field Service | p.351–375 (인쇄 347–371) |
| Industries | p.376–551 (인쇄 372–547) |
| Marketing | p.552–582 (인쇄 548–578) |
| MuleSoft | p.583 (인쇄 579) |
| Mobile (Salesforce Mobile App · Mobile Publisher) | p.584–592 (인쇄 580–588) |
| Revenue (RLM) | p.597–637 (인쇄 593–633) |
| Work.com | p.838–840 (인쇄 834) |

> 성숙도 표기: Summer '24는 GA를 항상 "(Generally Available)" 또는 narrative("now generally available")로 표기하며 "(GA)" 약어는 쓰지 않는다. 본 노트도 PDF 원문 표기를 그대로 따른다.

---

## Sales Cloud

> Einstein for Sales(Sales Emails, Copilot 표준 액션, Conversation Insights)는 Einstein spoke 위임 — 1줄: Sales Copilot에 4개 신규 topic(Close Deals, Manage Deals, Communicate with Customer, Conversation Explorer, Forecast Sales Revenue)과 Buyer Relationship Map 인사이트 추가. 상세 → [[Summer '24/Einstein]].

### Einstein for Sales

| 기능(verbatim) | 등급 | 설명 |
|---|---|---|
| **Draft Personalized Sales Emails with Einstein** | GA(narrative — composer 내장) | Performance/Unlimited. "grounding" 적용. *(Einstein — 위임)* |
| **Control Whether Users Can Enter Their Own Sales Email Prompt Instructions** | 변경 | 기본 on. **When: 2024-04-11.** |
| **Einstein Automated Contacts Is Being Retired in February 2025** | 은퇴 | **2025년 2월 은퇴.** Automatic Contact Creation으로 대체. |
| **Get Better Performance for Activity 360 Reporting** | 변경 | combined record threshold 3M→1.5M로 하향. |
| **Accomplish More with Sales Copilot Topics** | 변경 | 4개 신규 topic. Einstein for Sales add-on. *(Einstein — 위임)* |
| **Improve the Convenience of Setting Up Meeting Requests** | 변경 | Send Meeting Request copilot action(3개 time slot + calendar link 포함 email 초안). *(Einstein — 위임)* |
| **Visualize Key Contacts on the Buyer Relationship Map** | 변경 | Enterprise/Performance/Unlimited/**Einstein 1 Sales Edition** + Buyer Relationship Map 활성. |
| **Add Company and Buyer Information to Contacts Automatically** | 변경 | 생성형 AI 기반 **Automatic Contact Enhancements**(phone, address, title, seniority level, department group, buyer attribute). *(Einstein — 위임)* |

### Sales Foundations

| 기능 | 등급 | 설명 |
|---|---|---|
| **Create Contacts Automatically from Email and Calendar Interactions** | 변경 | Automatic Contact Creation. 최대 3 mention threshold. |
| **Enhance Your Contact Information Automatically** | 변경 | 생성형 AI. *(Einstein — 위임)* |
| **Accessibility Enhanced in Contact Suggestions** | 변경 | — |
| **Return to Your To Do List Exactly as You Left It** | 변경 | filter/sort/side panel 상태 저장. |
| **Organize and Find Records Easily with Personal Labels** | 신규 | 대상 객체: Account, Cadence, Cadence Step Tracker, Call Script, Campaign, Contact, Case, Email Template, Lead, Opportunity, Orchestration Work Item, Task, Custom objects. **한도: object당 label 20개, 총 200개, label당 record 500개.** |
| **Grant Access to the Label Object In Custom Profiles To Continue Using To Do List Labels** | RU | Label object가 API에 노출. custom profile 접근 권한 부여 필요. → [[Summer '24/Release Updates]] |
| **See More Valuable Information in Seller Home** | 변경 | Top Prospects, Goals(forecast commit), Salesblazer card. |
| **Save Time with More Actions in the Intelligence Views**(IdeaExchange Delivered) | 변경 | Account/Contact/Lead Intelligence view에서 **최대 200개 record 일괄 액션.** |

### Einstein Conversation Insights

| 기능 | 등급 | 설명 |
|---|---|---|
| **Configure Custom Insights with Generative Conversation Insights** | 신규(생성형) | ECI + Einstein for Sales 필요. **active generative insight 최대 5개.** *(Einstein — 위임)* |
| **Use Einstein Conversation Insights with Single User Meetings** | 변경 | single-user meeting도 처리. |
| **Share Edit Access for Record Collections with Other Users** | 변경 | Read/Write 공유. |
| **Access More Dashboard Improvements** | 변경 | Coaching + Related Record Calls 페이지. |

### Sales Engagement — Cadence Builder 2.0

| 기능 | 등급 | 설명 |
|---|---|---|
| **Use Screen Flows as Cadence Steps in Cadence Builder 2.0** | 신규 | **Cadence Step Flow** process type. 템플릿: Create a Case/Event/Task. |
| **Create More Customized Sales Playbooks in Cadence Builder 2.0** | 신규 | Cadence Link로 여러 cadence 연결. |
| **Save Time by Creating Email Templates with Cadences** | 변경 | — |
| **Easily Organize Cadence Builder 2.0 Cadences** | 변경 | 임의 folder에 저장. |
| **Cadence Builder Classic Is Being Retired** | 은퇴 | **Summer '25에 Sales Engagement의 Cadence Builder Classic(1.0) 은퇴.** Cadence Builder 2.0은 Spring '24부터 제공(Main/Positive/Negative track). **Spring '25부터 Classic은 기존 Classic cadence 편집만 가능(생성·복제 불가), Summer '25 은퇴.** *(이 항목은 Sales/Sales Engagement 소속 — Flow 아님.)* |

> PDF 원문: "In Summer '25, Salesforce is retiring Cadence Builder Classic (1.0) within Sales Engagement. ... Beginning Spring '25, Classic can only edit existing Classic cadences."

### Revenue Intelligence

- **Navigate Revenue Insights Dashboards More Easily** — tab + pinning.
- **Use Custom Fiscal Forecasts in Revenue Insights** — custom fiscal year forecast.
- **Increase Your Deal Potential with Lead Data in Einstein Account Management** — Account Inspector에 lead metric 추가.
- **Access Your Revenue Insights Resources in One Place** — Resources 탭.
- **Get Your Revenue Data Even Faster** — hourly app refresh.
- **Monitor Your Revenue Insights Installations and Upgrades**.

### Collaborative Forecasts

- **View Forecasts Grouped How It Makes Sense to You** — team→group/product family 또는 그 역순으로 grouping.
- **Further Customize the Forecast Guidance You Receive in Copilot** — Get Forecast Guidance copilot action가 flow-powered. **When: 7월 초.** *(Einstein — 위임)*

### Pipeline Inspection

- **Save Time with More Actions in Pipeline Inspection** — **최대 200개 record 일괄 액션.**
- **Identify Potentially Risky Contacts on Deals** — detractor insight + Buyer Relationship Map.

### Sales Programs and Partner Tracks with Enablement

| 기능 | 등급 | 설명 |
|---|---|---|
| **Provide Users with Coaching-Inspired Feedback Driven by Einstein Generative AI** | 신규(생성형) | Einstein Coach; Feedback Request exercise. *(Einstein — 위임)* |
| **Make Your Enablement Goals More Effective with Advanced Milestone Options** | 변경 | composite goal(measure 2개). |
| **Get Transparency on Your Goal Progress with Itemized Progress Details** | 변경 | — |
| **Help Users Discover and Complete Enablement Program Goals on Time** | 변경 | notification option. |
| **Develop, Test, and Deploy Enablement Programs and Measures More Easily** | 변경 | **EnablementMeasureDefinition** + **EnablementProgramDefinition** metadata type(change set/CLI). |
| **Tailor Your Enablement Programs to Your Company's Preferred Content System** | **DevPrev** | Apex/LWC로 custom exercise type. Developer Edition. |
| **Other Changes in Enablement** | 변경 | Enablement가 Developer Edition에서도 사용 가능. |

### Partner Relationship Management

- **Help Partners Send Personalized Sales Emails Fast** — Aura Experience Cloud site의 Einstein Sales Emails. PRM + Einstein for Sales add-on. *(Einstein — 위임)*

### Sales Performance Management — Salesforce Maps · Sales Planning · Sales Territories

| 기능 | 등급 | 설명 |
|---|---|---|
| **Get More from Salesforce Maps with an Enhanced User Experience** | 신규 framework | ArcGIS Living Atlas, traffic event. Summer '24 GA 시점 또는 직후. |
| **Changes Afoot for Custom Data Sources** | 은퇴 | Salesforce Maps Advanced의 custom source import 지원 **2025-05-16 은퇴.** |
| **Data Sources Management**(Sales Planning) | 신규 | — |
| **Segmentation**(Sales Planning) | 신규 | — |
| **Territory Planning: Estimate Travel Times / Edit Territory and Assignment Details on the Legend / Other Improvements** | 변경 | — |
| **Quota Planning** | 신규 | — |
| **Limited Availability of Original Sales Planning** | 지원 종료 | 원본 Sales Planning experience는 **Winter '25까지만** 사용 가능. |
| **Enterprise Territory Management Is Now Sales Territories** | 명칭 변경 | **Enterprise Territory Management(ETM) → Sales Territories.** |
| **Compensate Reps Based on Effective Territory Coverage Dates** | 변경 | User Territory Association Logs object. |

### Email, Calendar, and Integrations — 변경/은퇴

| 항목 | 등급 | 설명 |
|---|---|---|
| **Understand Downloaded User Connection Reports Quickly**(Einstein Activity Capture) | 변경 | field 명칭 변경. |
| **Enter Generative AI Instructions to Create Sales Emails in Email Integrations** | 변경 | Performance/Unlimited. **When: 2024-04-11.** *(Einstein — 위임)* |
| **Log Emails and Events More Intuitively** | 변경 | Pick Records 버튼. |
| **Inbox Mobile Was Retired** | 은퇴 | "Inbox mobile is retired **as of February 1, 2024**." 제품 전체 은퇴. |
| **Salesforce for Outlook Is Now Being Retired in December 2027** | 은퇴(연기) | 제품 전체 은퇴 **2027년 12월로 재조정**(이전 June 2024). |

### Sales Cloud Everywhere

- **See the Fields You Want in Sales Cloud Everywhere** — **When: 2024-04-18.**
- **Focus on the Right Records and Personalize Your Workspace** — **When: 2024-04-18.**

### Other Changes in the Sales Cloud

| 항목 | 등급 | 설명 |
|---|---|---|
| **Enable New Order Save Behavior** | RU | Winter '20 최초 제공; **Spring '25 enforce.** → [[Summer '24/Release Updates]] |
| **Focus More Easily with the Latest Visual Refresh in Sales Cloud** | 변경 | 신규 org; Pro Edition org은 2024-06-27 이후, Enterprise는 2024-07-25 이후. |

---

## Service Cloud

> Einstein for Service(Work Summaries, Conversation Mining, Feedback Summaries)는 Einstein spoke 위임 — 1줄: **Einstein Work Summaries for Email = GA**, Mid-Conversation Summaries(Conversation Catch-Up) = 6개 언어, Conversation Mining이 Messaging for In-App and Web·Web-to-Case로 확장. 상세 → [[Summer '24/Einstein]].

### Top-level / Einstein for Service

| 기능 | 등급 | 설명 |
|---|---|---|
| **Discover Service Capabilities with My Service Journey (Beta)** | **Beta** | Enterprise/Unlimited. |
| **Track Key Trends and Top Contact Reasons Across More Channels**(Einstein Conversation Mining) | 변경 | Messaging for In-App and Web + Web-to-Case 지원(이전 Email Message + Chat Transcript). **When: 2024년 8월.** *(Einstein — 위임)* |
| **Get Insightful Perspectives from Summaries of Survey Responses**(Feedback Management) | 신규(생성형) | Einstein for Service add-on. *(Einstein — 위임)* |
| **Get Deeper Insights from Survey Responses** | 신규 | NLP Insights dashboard. |
| **Catch Up with Midconversation Summaries in Five More Languages** | 변경 | Conversation Catch-Up이 **6개 언어: English, French, German, Italian, Japanese, Spanish**(이전 English only). Messaging + Voice. *(Einstein — 위임)* |
| **Catch Up Quickly On Emails with Einstein Work Summaries for Email (Generally Available)** | **GA** | 개별 email 또는 전체 thread 요약. Enterprise/Unlimited + Einstein for Service add-on. *(Einstein — 위임)* |
| **Customize Your Work Summaries in Copilot (Generally Available)** | **GA** | Summarize Record action; Summarize Messaging Session / Summarize Voice Call prompt template. *(Einstein — 위임)* |
| **Use Einstein Work Summaries in Additional Languages** | GA(narrative) | Messaging Session Work Summaries에 **3개 언어 추가: Dutch, Portuguese (Brazilian), Spanish (Mexico).** *(Einstein — 위임)* |

### Service Intelligence

- **Get Your Service Intelligence Data Even Faster** — hourly app refresh.
- **Monitor Your Service Intelligence Installations and Upgrades**.
- **Access Your Service Intelligence Resources in One Place**.
- **Help Agents Predict Time to Resolve Cases** — Einstein Studio No Code Builder ML model. *(Einstein — 위임)*
- **View Contact Center Metrics on Enhanced Dashboards** — Channel/Agent/Knowledge Performance 신규 탭.
- **Simplify Service Intelligence Permission Sets** — Service Intelligence App Admin이 Service Intelligence Admin 대체.
- **Apply Additional Service Assets in Data Cloud** — Service Data Kit v4.0; Digital Engagement bundle.

### Service Catalog

| 기능 | 등급 | 설명 |
|---|---|---|
| **Run Catalog Items for Contacts in Service Console** | 신규 | Actions & Recommendations 컴포넌트. |
| **Make Catalog Items Available On External Sites with Lightning Out** | 신규 | 외부 site에 catalog item 노출(코드 아래). |
| **Provide Guest User Access to Service Catalog** | 신규 | 이전엔 authenticated user만. |
| **Integrate Service Catalog with Knowledge** | 신규 | Customer Service Catalog add-on. |
| **Einstein for Service Catalog (Beta)** | **Beta** | parent. *(Einstein — 위임)* |
| → **Drive Case Resolution in Service Catalog with AI (Beta)** | **Beta** | 3개 custom action + 샘플 item(Update Phone Number, Update Email, Get Help). *(Einstein — 위임)* |
| → **Share Catalog Item Links to Customers with Einstein Copilot (Beta)** | **Beta** | Service Catalog Item action type. *(Einstein — 위임)* |

Service Catalog Lightning Out 코드(verbatim — PDF p.783):

```html
<html>
<script src="SiteURL/lightning/lightning.out.js"></script>
<body>
<h1>Header</h1>
<div id="item"></div>
</body>
<script>
// What needs to be done: in your org, add this URL (probably localhost) to CORS
var token = "<token, not prefixed by Bearer>"
$Lightning.use("runtime_service_servicecatalog:serviceCatalogLightningOut", function()
{
$Lightning.createComponent("runtime_service_servicecatalog:catalogItem",
{ itemApiName: "<itemName>", targetCustomerId: "<CustomerId>" },
"item",
function(newCmp, status, errorMessage) {
if (status === "SUCCESS") {
console.log("Component Created Successfully");
} else {
console.log("Component not created | " + errorMessage);
}
}
);
},"SiteURL"
,token);
</script>
</html>
```

### Channels — Email-to-Case / Email Threading

| 항목 | 등급 | 설명 |
|---|---|---|
| **Transition to the Lightning Editor for Email Composers in Email-to-Case (Generally Available) (Release Update)** | **GA / RU** | "generally available in Lightning Experience in Spring '24." **Spring '25 enforce.** 새 editor: full-screen, printing, undo/redo, format painting, emoji picker, resizability. → [[Summer '24/Release Updates]] |
| **Disable Ref ID and Transition to New Email Threading Behavior** | RU | Ref ID off → Lightning threading. Winter '21 최초 제공; **Spring '25 enforce.** merge field `Case.Thread_Id` → `Case.Thread_Token`; custom code `Cases.getCaseIdFromEmailThreadId` 교체. → [[Summer '24/Release Updates]] |
| **Enjoy Improved Threading for Emails Sent by Flows** | 변경 | — |
| **Use Threading Tokens with More Objects** | 변경 | platform feature로 확장(이전 Cases only). |
| **Threading Tokens Are Exempt From Salesforce Org Storage Policy** | 변경 | — |
| **Manage Visibility for Your Email Routing Address** | 변경 | — |

### Channels — Messaging

| 기능 | 등급 | 설명 |
|---|---|---|
| **Merge Marketing and Service by Migrating from Enhanced WhatsApp to Unified Messaging** | 변경 | 단방향 마이그레이션. |
| **Message Your Customers from the Salesforce Mobile App** | Beta | Omni-Channel for Mobile 연계(아래 Routing). |
| **Say Goodbye to Standard WhatsApp Channels** | 은퇴 | standard→enhanced WhatsApp 업그레이드 **마감 2025-07-30**; **2024-07-01부터 추가 standard WhatsApp channel 생성 불가.** |
| **Upgrade SMS and Facebook Messenger Channels from Standard to Enhanced** | 지원 종료 | standard SMS/FB Messenger 생성 단계적 종료. |
| **Analyze Conversation Transcripts in Data Cloud** | 신규 | production only. |
| **Block Sensitive Data in Enhanced Messaging, Messaging for In-App and Web, and Voice Transcripts** | 변경 | 이전엔 standard Messaging only. |
| **Use Status-Based Capacity with Messaging (Beta)** | **Beta** | tab 100개 대신 work item 100개. |
| **Register SMS Long Codes in Setup** | 신규 | Regulatory Compliance 페이지. |
| **Create a Custom UI Solution for Messaging for In-App and Web (Beta)** | **Beta** | custom client deployment; REST API. **When: 2024-05-20.** |
| **Bring Your Own Channel for Messaging (Generally Available)** | **GA** | "previously called Partner Messaging." Enterprise/Unlimited/Developer + Digital Engagement add-on. |

- **Messaging Components**(p.798–802): Send Messaging Components in Your Customer's Language · Customize Secure Forms with New Settings · Customize Lists in Messaging Components with New Settings · Control When Secure Forms Expire in Messaging Sessions · **Form Format in Secure Forms Is Generally Available in Messaging for In-App and Web**(GA — 이전 beta) · Extend Messaging Components with Custom Constants · Authentication Messaging Components Improved for Compatibility · **Auto-Response Components Are Available in Partner Messaging (Beta)** · Prevent Unwanted Parameters in Your Auto-Response URL.
- **Agent Messaging Experience**(p.803–805): Assign a New User Permission to Partner Messaging Agents (Beta) · The Attach File Action Got a Makeover · Enjoy a Better Messaging Experience Outside the Service Window · Refresh Conversations After a Lost Connection · Get Midconversation Summaries in Five New Languages(6개 언어) · Customize Which Queues, Flows, and Profiles Your Agents Can Transfer To · Adjust the Enhanced Conversation Component's Height(500–1,000 px).
- **Other Messaging**(p.805–807): Track Who Ends Enhanced Messaging Sessions(EndedByType: End User, Agent, Bot, System) · Activate or Deactivate Sensitive Data Rules from the Rules List View(**max 10 active**) · Einstein Conversation Mining is Now Available in Messaging for In-App and Web(2024년 8월) · Access to Sensitive Data Rules is Restricted to Admins · Route Data to Objects in Partner Messaging (Beta) · Set a More Informative Channel Type in Partner Messaging (Beta) · Customize the Partner Messaging Channel Setup Experience Using Icons (Beta) · The Minimize Chat Window Button Is Relocated in Messaging for Web.
- **Messaging for Web Development**(p.808–810): Reduce Noise During Messaging for Web Sessions(`shouldShowParticipantChgEvntInConvHist`) · Restrict Conversation History by Channel(`restrictSessionOnMessagingChannel`) · Minimize the Web Chat Client When Loading New Tabs(`shouldMinimizeWindowOnNewTab`) · Place the Chat Button Where You Want(`chatButtonPosition`) · Open the Web Chat Client with the Launch Chat API(`embeddedservice_bootstrap.utilAPI.launchChat()`) · Send Automated Notifications in Partner Messaging Channels (Beta).

### Channels — Voice

(p.812–822) Reassign Agents to Queues on the Fly · **Get Midconversation Summaries for Voice in Five More Languages**(6개 언어) · Protect Sensitive Data by Masking Customer Phone Numbers · Identify and Backfill Missing Call Transcripts in Bulk(contactDataSync Lambda, **최대 100**) · Take Calls from Preferred Audio Devices(Safari 미지원) · Security Increased for Authenticating Users in Amazon Connect with SSO(cert size 무제한, 이전 2048-bit) · Resolve Common Status Conflicts(sfdc_pending) · Toggle Between Callers and Put Other Agents on Hold in Multi-Party Calls(Swap/Hold) · Troubleshoot Failures During Amazon Contact Center Creation · Customize When to Apply the Sales Engagement Automatic Task Creation Feature · **Use an Apex-Defined Variable for All Intelligence Signal Types (Release Update)** — `intelligenceSignals` param, Summer '24 제공, **Spring '25 enforce** → [[Summer '24/Release Updates]] · **Pass the Conversation Intelligence Rule Name as Input to a Flow (Release Update)** — `ruleDevName` param, Spring '24 제공, **Winter '25 enforce** → [[Summer '24/Release Updates]] · Show an Accurate Call-Recording State in Omni-Channel(callRecordingDisabled) · Control the Enhanced Conversation Component's Height in the Voice Call Record Page(500–1,000 px) · Disable CTR Sync for Voice Call Records · Get the Latest Enhancements for Your Amazon Connect Contact(Contact Center version 15.0) · Account for Latency Between Omni-Channel and Amazon Connect when Rerouting Calls(version 248.11 backport).

### Channels — Social Media / Chat / Channel Tools

| 항목 | 등급 | 설명 |
|---|---|---|
| **Social Customer Service Starter Pack Is Being Retired** | 은퇴 | Social Customer Service **2024-11-16 은퇴 예정.** |
| **Legacy Chat Is Being Retired** | 은퇴 | Legacy Chat **2026-02-14 은퇴 예정**; 그때까지 maintenance mode; Messaging for In-App and Web으로 마이그레이션. |
| **The Search Individual Flow Action Is Now Generally Available** | **GA** | Individual-Object Linking의 일부(이전 beta). |

### Knowledge

| 항목 | 등급 | 설명 |
|---|---|---|
| **Unify Knowledge from Various Sources in Salesforce (Generally Available)** | **GA** | Unified Knowledge; SharePoint, Confluence, Google Drive, website. Zoomin 제휴(90일 무료 trial). 신규 connector: Jira Cloud, SharePoint Server. |
| **Turn On Lightning Article Editor and Article Personalization for Knowledge** | RU | **Winter '25 enforce.** → [[Summer '24/Release Updates]] |
| **Run the Lightning Knowledge Migration Tool** | 마이그레이션/은퇴 | **2025-06-01 enforce.** Summer '25부터 Classic Knowledge data model 미제공. (Classic UI for Knowledge 자체는 은퇴 아님.) |

### Routing

| 기능 | 등급 | 설명 |
|---|---|---|
| **Support Customers While on the Go with Omni-Channel for Mobile (Beta)**(IdeaExchange Delivered) | **Beta** | Voice 제외 모든 enhanced channel. **When: 2024-06-15 이후.** Digital Engagement 라이선스 필요. |
| **Stay Logged In to Omni-Channel When Using Multiple Tabs** | 변경 | "Remained logged in to Omni-Channel in previous console" 옵션. |
| **Route Orchestration Work Items with Omni-Channel** | 신규 | — |
| **Pause Messaging Sessions with Omni-Channel Status-Based Capacity (Beta)** | **Beta** | — |
| **Enhance Routing with Omni-Channel for Government Cloud Plus** | 신규 | Hyperforce; 마이그레이션 2024-05-10~08-23. |
| **Keep Routing Work During Service Degradation** | 신규 | Fallback Mode(Enhanced Omni-Channel only). |

### Feedback Management / Scheduled Reminders / Industries in Service Cloud

| 기능 | 등급 | 설명 |
|---|---|---|
| **Do More with an Enhanced Data Mapper Page** | 변경 | — |
| **Survey Invitations View in Contact Activity Tab Is No Longer Supported** | 지원 종료 | — |
| **Boost Participation for Upcoming Events with Scheduled Reminders** | 신규 | before-event reminder(이전 past event only). Industries Scheduled Reminders 라이선스. |
| **Extend Your Service Cloud Implementation with Service Innovations from Industries** | 신규 | Industry Service Excellence add-on. |
| **Create Rules with Business Rules Engine** | 신규 | BRE가 Service Cloud에 제공. |

---

## Experience Cloud

> Einstein 항목(AI-Generated Search Answer 설정, Einstein Sales Emails for partners)은 Einstein spoke 위임 — 1줄. 상세 → [[Summer '24/Einstein]].

### Aura and LWR Sites

| 기능 | 등급 | 설명 |
|---|---|---|
| **Prepare Your LWR and Aura Sites for Design System Architecture Updates** | 변경 | SLDS 내부 구현 변경. |
| **Upgrade Your App with the Latest Features from Mobile Publisher** | 변경 | biometric login(beta); 최소 Android 8/iOS 16; legacy Managed Public Android 앱 업데이트 종료. |
| **Integrate with Data Cloud to Harness Site Data (Generally Available)** | **GA** | enhanced LWR site를 Data Cloud와 연결. |
| **Customize the Forms and Buttons on Your LWR Site with New Styling Features** | 변경 | — |
| **Polish the Layout of Your LWR Site for Every Screen Size** | 변경 | — |
| **Configure Search Results Layouts with Search Manager (Generally Available)** | **GA** | search config가 site 간 재사용. |
| **See Updates to Dependent Picklists While Editing Records in LWR Sites** | 변경 | Record Detail 컴포넌트. |
| **Enable or Disable a Modernized Record Experience in Aura Sites in Your Sandbox Environment** | 신규(sandbox) | LWC 기반 Create Record Form, Record Banner, Record Detail. |
| **Customize URLs for Accounts and Contacts to Improve SEO (Beta)** | **Beta** | **ObjectRelatedUrl** object; "slug". |
| **Customize Your Einstein AI-Generated Search Answer Settings** | 변경 | *(Einstein — 위임)* |
| **Help Partners Draft Sales Emails Quickly** | 신규 | Einstein Sales Emails for partners; PRM + Einstein for Sales. *(Einstein — 위임)* |

### Site Performance

| 기능 | 등급 | 설명 |
|---|---|---|
| **Improve the Performance and Scalability of LWR Sites with Experience Delivery (Pilot)** | **Pilot** | SSR + CDN; page load 최대 60% 향상. **Developer Edition 미지원.** enhanced domain, path prefix custom URL 추가. |
| **Update References to Your Force.com Site URLs** | 변경/지원 종료 | legacy `*.force.com` redirection이 production org 대상 **2024년 9월부터 종료.** |
| **Load Cached Visualforce Site Pages Faster** | 변경 | — |

### Security and Sharing

| 기능 | 등급 | 설명 |
|---|---|---|
| **Switch to a Single Domain Certificate for Your Salesforce CDN** | 변경 | shared domain certificate 은퇴; **Spring '25 enforce.** |
| **Salesforce CDN Is Off by Default for Government Cloud Organizations** | 변경 | — |
| **Refine Your Experience Cloud Site with New Customer Identity Features** | 변경 | — |
| **Try a More Flexible Integration Framework for Headless Identity Flows** | 신규 | **External Client App** framework가 headless Authorization Code·Credentials Flow의 모든 variation 지원(headless login, passwordless login, guest user identity flow). |
| **Assign a New User Permission for Custom Domain Management** | 신규 | Custom Domain Management permission. |
| **Track More Visualforce Site Changes** | 변경 | Site History. |

---

## Mobile

> Salesforce Mobile App + Mobile Publisher 챕터(PDF 물리 p.584–592, 인쇄 p.580–588). Experience Cloud spoke와 Platform spoke 사이 seam에 있던 Mobile 챕터 본문을 여기서 전수 소유한다.

> Recent Activity Timeline with Copilot, Message Customers 등 Einstein/Copilot 인접 항목은 1줄로만 언급하고 상세는 → [[Summer '24/Einstein]]. Omni-Channel for Mobile 라우팅 상세는 위 Service Cloud의 Routing/Messaging 섹션 참조(중복 방지).

> 챕터 헤드라인(PDF 물리 p.584): "Configure offline landing pages without code using Mobile Builder for Salesforce Mobile App, which is now generally available. Improve your Mobile Publisher app with new security features and prepare your app for new notification and device operating system requirements. Submit the required Firebase information for push notifications on Android mobile connected apps."
>
> 가용 시점: "Most features become available for the Salesforce mobile app the week of June 17, 2024." 신규 Salesforce mobile app은 Database.com을 제외한 모든 edition에서 추가 라이선스 없이 사용 가능.

### Salesforce Mobile App

| 기능(verbatim) | 등급 | 설명 |
|---|---|---|
| **Hide Global Search for Specific Lightning Apps** | 변경 | 특정 Lightning app에서 global search를 숨겨 더 집중된 경험 제공. 다른 app으로 전환하면 search bar 다시 표시. mobile connected app에 적용(Group/Professional/Enterprise/Essentials/Performance/Unlimited/Developer에서 connected app 생성 가능). connected app 설정 `HIDE_SEARCH_ICON_FOR_LIGHTNING_APP`에 하나 이상의 app developer name을 값으로 지정. developer name은 Lightning Experience App Manager에서 확인. |
| **Configure Offline App Landing Pages Easily with Mobile Builder (Generally Available)** | **GA** | Mobile Builder for Salesforce Mobile App으로 코드 한 줄 없이 offline landing page를 커스터마이즈. mobile 사용자에게 가장 중요한 record를 보여줘 use case 기반으로 빠르게 관련 액션 수행. **Mobile Builder는 Spring '24에 beta였고 이번에 generally available.** Where: Salesforce Mobile App Plus(Android·iOS, phone·tablet), Database.com 제외 모든 edition. Who: Salesforce Mobile App Plus 라이선스 + **Mobile Offline for Salesforce Mobile App Plus** 사용자 권한. How: Setup → Quick Find에 `Mobile Builder` 입력 → Mobile Builder for Salesforce Mobile App 선택 → configuration 생성, user profile에 할당, publish. |
| **Keep Working While Your Records Download with Background Priming (Beta)** | **Beta** | offline 용 record를 download할 때 그 과정이 백그라운드에서 진행되어 mobile device를 중단 없이 계속 사용 가능(전화 받기·미팅 일정·기기 잠금 후 휴식). download 완료 시 앱이 알림. Where: Salesforce Mobile App Plus(iOS·Android, phone·tablet), Database.com 제외 모든 edition. **Note: Beta Service** — 고객 재량으로 시도 가능, 사용 시 Beta Services Terms 적용. Who: Salesforce Mobile App Plus 라이선스 + **Mobile Offline for Salesforce Mobile App Plus** 권한. How: 베타 참여는 customer success representative 또는 account executive에 문의. |
| **See Only Actions You Can Use in Mobile Builder** | 변경 | Salesforce Mobile app은 **LWC global action만** 지원. Mobile Builder에서 landing page를 구성하고 actions card에 액션을 추가할 때 non-LWC 액션은 자동으로 필터링 제거되어, 지원되는 액션만 추가 가능. Where: Salesforce Mobile App Plus(Android·iOS, phone·tablet), Developer/Enterprise/Unlimited edition. 기존에 non-LWC 액션이 있었다면 사용자 offline landing page에는 표시되지 않았고 Mobile Builder 안에서만 표시됐으며, 이제 Mobile Builder에서 빈칸으로 나타나 제거 가능. |
| **Access the Recent Activity Timeline on the Salesforce Mobile App with Copilot Enabled** | 변경 | Einstein Copilot이 활성화된 상태에서도 lead·opportunity·account·contact의 Recent Activity timeline을 mobile app에서 표시(이전엔 접근 불가). Enterprise/Performance/Unlimited + Einstein for Sales·Einstein for Service·Einstein Platform add-on. action bar에 4개 초과 시 record page overflow 메뉴에, 4개 미만이면 action bar에, Copilot 미활성 시 앱 하단에 표시. *(Einstein/Copilot 인접 — 상세는 [[Summer '24/Einstein]])* |
| **Message Customers in the Salesforce Mobile App (Beta)** | **Beta** | agent가 Salesforce mobile app에서 고객에게 메시지 전송 가능(이전엔 agent console의 Omni에 로그인해야 했음). 모든 enhanced messaging channel + Messaging for In-App and Web에 적용. **Note: Beta Service.** When: 2024-06-15 이후. Who: **Messaging User permission set license** 보유 사용자. agent는 Salesforce app에 로그인 후 Omni widget에서 available 상태로 전환해 메시지 송수신. *(위 Service Cloud의 Channels — Messaging / Routing의 Omni-Channel for Mobile 항목과 동일 기능 — 라우팅 상세 중복 방지)* |

### Mobile Publisher

> Mobile Publisher 앱에 user opt-in biometric login(beta)·custom mobile security policy 등 보안 기능 추가, Android push notification용 Firebase 정보 제출, Experience Cloud 앱 사용자 기기를 Android 8 / iOS 16 이상으로 업데이트하도록 준비.

| 기능(verbatim) | 등급 | 설명 |
|---|---|---|
| **Submit Your Mobile Publisher Android App's Required Firebase Information Before June** | 변경 | Google의 Android push notification 처리 방식 변경으로 Mobile Publisher가 앱의 Google Firebase project에서 새 정보를 요구. push notification 중단 방지를 위해 **2024년 6월 전에** Firebase Admin SDK private key + Firebase config file을 Setup for Mobile Publisher에 업로드. Where: Mobile Publisher for Experience Cloud + Mobile Publisher for Salesforce Mobile App Plus Android 앱. Setup은 Lightning Experience(Enterprise/Performance/Unlimited). |
| **Mobile Publisher Android Apps with Managed Public Distribution Are No Longer Updated** | 은퇴/지원 종료 | Mobile Publisher는 **Winter '23**에 Managed Public 옵션을 통한 Android 앱 배포를 retire함. 기존 Managed Public 배포 Android 앱은 계속 동작하나 **Summer '24 이후 릴리즈부터 앱 업데이트 미수신.** Delegated Public/Delegated Private 배포를 위해 자체 Google Play 계정으로 가능한 빨리 이전 권고. |
| **Experience Cloud Apps Now Require Android 8 or iOS 16 and Later** | 변경 | **app version 12.2부터** Mobile Publisher for Experience Cloud 앱은 Android 7 이하 / iOS 15 이하 기기 미지원. 12.2 이상 앱 설치 시 기기를 최소 Android 8 또는 iOS 16으로 업데이트해야 함. Where: Mobile Publisher for Experience Cloud Aura·LWR site 앱(Enterprise/Performance/Unlimited/Developer). |
| **Set Up Opt-In Biometric Login for Fast and Secure Experience Cloud App Logins (Beta)** | **Beta** | User Opt-In Biometric Login(beta)으로 사용자가 face/fingerprint 인증을 로그인에 opt-in 가능. 최초 username/password 로그인 후 이후 로그인에 biometric credential을 opt-in(이전엔 biometric app unlock 활성 시 biometric 없이는 로그인 불가). **Note: Beta Service.** Where: Mobile Publisher for Experience Cloud app version 12.2 이상. How: Setup → Quick Find에 `Connected App` → Manage Connected Apps → 해당 앱의 connected app에 opt-in biometric login custom attribute 추가. |
| **Configure How Your Experience Cloud App Responds to Security Threats** | 신규 | Enhanced Mobile App Security로 Mobile Publisher for Experience Cloud 앱이 보안 위협(jailbroken device, man-in-the-middle 공격 등)에 자동 대응하는 방식을 커스터마이즈. 위협 탐지 후 자동 대응의 severity level 설정. Where: iOS app version 12.3 또는 Android app version 12.4 이상; Setup은 Lightning Experience(Enterprise/Performance/Unlimited). **추가 비용 없음.** How: Setup for Mobile Publisher project에서 Enhanced Mobile App Security 활성 → Mobile Security에서 mobile security policy 구성. Android는 Google Play Console에서 app signing key certificate 다운로드 필요. |
| **Binary Upload Is the Default Distribution Method for New Mobile Publisher Apps** | 변경 | Setup for Mobile Publisher에서 project 생성 시 App Distribution Method 선택(직접 Apple/Google 심사 제출 = **Binary Upload**, Salesforce가 심사 제출 = **Fully Managed**). 신규 Mobile Publisher 앱의 기본 App Distribution Method가 **Binary Upload**로 변경. Fully Managed 옵션은 계속 사용 가능, 기존 앱 변경 없음. Where: Lightning Experience(Enterprise/Performance/Unlimited). **Note: App Distribution Types(앱의 공개/비공개 배포 결정)에는 변경 없음.** |
| **Add Links to an Experience Cloud iOS App's Login Page** | 신규 | Mobile Publisher for Experience Cloud iOS 앱이 login page에서 link 지원. login 화면으로 privacy policy·terms and conditions 등 중요 페이지로 안내. Android 앱은 app version 11.3 이상에서 login page link 지원. Where: Experience Cloud iOS app version 12.3 이상. How: Experience Builder로 site login page에 link 추가. |
| **Set the Default Method for How Your Experience Cloud App Opens External URLs (Generally Available)** | **GA** | 기본 동작은 Experience Cloud site의 URL은 in-app web view에서, site 외부 URL은 모두 in-app browser에서 열림. 이제 개별 URL을 일일이 구성하지 않고도 site 외부 모든 URL을 여는 방식을 선택 가능: **in-app web view, in-app browser, external browser, 또는 앱의 web view와 cookie를 공유하는 in-app browser.** external URL 기본 method 설정은 Service Cloud의 **Messaging for In-App and Web**에도 지원. Where: Mobile Publisher for Experience Cloud Aura·LWR site 앱(Enterprise/Performance/Unlimited/Developer); Setup은 Lightning Experience(Enterprise/Performance/Unlimited). How: Setup for Mobile Publisher project의 **URL Management** 섹션에서 설정. |
| **Simplify Site Navigation on Mobile Publisher for LWR Sites (Beta)** | **Beta** | LWR 플랫폼의 Mobile Publisher for Experience Cloud 앱에서 hamburger menu와 back button을 표시해 탐색 간소화. LWR site용으로 이 탐색 옵션을 커스터마이즈하려면 새 **`getNavigationConfig` wire adapter** 사용 — Android·iOS 앱의 hamburger menu·back button을 활성/비활성하는 property 노출. Where: Lightning Experience·Salesforce Classic으로 접근하는 LWR site(Enterprise/Performance/Unlimited/Developer). **Note: Beta Service.** Experience Builder의 Additional Navigation Options 설정은 Aura site(Customer Account Portal, Partner Central, Customer Service, Help Center 템플릿)에서만 제공되고 LWR 플랫폼 앱에는 미지원이라, wire adapter가 LWR site에서 이 옵션을 표시하는 방법 제공. |
| **Privacy Manifests Are Now Generated for Experience Cloud iOS Apps** | 변경 | Apple이 privacy manifest file(앱·third-party SDK가 사용자 데이터를 수집·사용하는 방식 기술)을 요구. Mobile Publisher for Experience Cloud가 이 파일을 대신 생성해 App Store 계정에 업로드. 앱 사용자 경험에는 변경 없음. Where: Experience Cloud iOS app version 12.2 이상. |

`getNavigationConfig` wire adapter 사용 예시:

```js
// 구조 예시 — 실제 동작 코드 아님 (PDF는 wire adapter 명칭만 명시, 코드 미수록)
import { wire } from 'lwc';
import getNavigationConfig from '@salesforce/...';

@wire(getNavigationConfig)
navConfig;   // hamburger menu / back button 활성·비활성 property 노출
```

### General Mobile Updates

| 기능(verbatim) | 등급 | 설명 |
|---|---|---|
| **Update Your Android Mobile Connected App with Firebase Information Required for Push Notifications** | 변경 | legacy Firebase Cloud Messaging API server key는 더 이상 mobile connected app의 Android push notification 구성에 허용되지 않음. Google의 push notification 처리 방식 변경으로 Android mobile connected app은 이제 Google Firebase project에서 **Admin SDK private key + project ID**를 수집. 알림 전달 중단 방지를 위해 새 Firebase Cloud Messaging API(**HTTP v1**)에 필요한 Firebase Admin SDK private key + project ID 제출. |

> 참고: 이 챕터의 push notification/Firebase 항목(Salesforce Mobile App·Mobile Publisher·mobile connected app)은 모두 Google의 FCM legacy API deprecation(June 2023 발표, 2024년 6월 적용)에 대응하는 변경이다.

---

## Data Cloud

> AI in Data Cloud(Anthropic Claude 3 Haiku, Google Gemini, Einstein Studio 모델)는 Einstein spoke 위임 — 1줄: Prompt Builder가 **Anthropic Claude 3 Haiku**(Amazon Bedrock)·**Google Gemini**(Vertex AI) 모델 지원. 상세 → [[Summer '24/Einstein]]. 아래는 비-AI 데이터 통합·세그먼테이션·연결 기능.

### Core / Connect Data / Segmentation

| 기능 | 등급 | 설명 |
|---|---|---|
| **Edit a Data Graph** | 신규 | draft 저장; flow invocable action. **When: 2024년 7월.** |
| **Access Data from Amazon Redshift and Databricks with BYOL Data Federation** | 신규 | Bring Your Own Lake; zero-copy. **When: 2024년 6월.** Enterprise/Performance/Unlimited. |
| **Ingest More Data into Data Cloud with New Third-Party Connectors (Beta)** | **Beta** | Adobe Analytics, Apache Hive, Asana, Azure Cosmos DB, eBay Analytics, Google Contacts, Google Drive, Google Spanner, GraphQL, IBM Cloud Object Storage, IBM Informix, Microsoft Dynamics 365, Oracle Eloqua, PayPal, SendGrid, Snapchat Ads, Spark SQL, SugarCRM. **When: 2024년 7월.** |
| **Query Data Graphs for Metadata and Data Using the Data Graphs APIs** | 신규 | Query API V1. 신규+기존 org 2024년 1월부터. |
| **Get Faster Segment Counts with Approximate Segment Population** | 신규 | **When: 2024년 7월.** |
| **Prioritize Campaigns with Waterfall Segments (Generally Available)** | **GA** | "now generally available, includes some changes since the last release." **When: 2024년 6월.** |
| **Create Segments with Fewer Clicks** | 변경 | **When: 2024년 7월.** |
| **Rapidly Publish Segments to Hyperscaler Targets** | 변경 | Amazon S3, SFTP, Google Cloud Storage, Microsoft Azure Storage. **When: 2024년 7월.** |
| **Define Segment Filters Based on Aggregate Values Across Multiple Levels (Pilot)** | **Pilot** | Hierarchical Aggregation. **When: 2024년 8월.** |
| **Optimize Campaigns by Ranking and Limiting the Segment Audience (Pilot)** | **Pilot** | **When: 2024년 8월.** |
| **Manage B2C Communications Using Capping Control (Pilot)** | **Pilot** | Communication Capping. **When: 2024년 8월.** |
| **Use Segments in a Data Kit** | 신규 | **When: 2024년 8월.** |
| **Apply Filters to Contact Points and the Activation Membership (Generally Available)** | **GA** | **When: 2024년 6월.** |
| **Use More Objects for Copy Field Enrichments** | 변경 | contacts, leads, accounts, assets. **When: 2024년 8월.** |
| **Data Cloud Related List Enrichments Now Support Accounts** | 변경 | **When: 2024년 6월.** |
| **Enrich Most Objects in Your Org With Data Cloud Data** | 변경 | **When: 2024년 5월.** |
| **Enrich Data Actions Using Data Graphs** | 신규 | **When: 2024년 5월 중순.** |

### Batch / Streaming Data Transforms

- **Run Batch Data Transforms at Custom Time Intervals** — 2024년 6월.
- **Enhance Row Security in Batch Data Transforms** — UUID function. 2024년 6월.
- **Run Batch Data Transforms with No Downtime** — flow로 sequence. 2024년 6월.
- **Refresh Data More Frequently with Incremental Refresh in BYOL Data Federation** — **15분~7일.** 2024년 8월.
- **Edit an Output Node in a Batch Data Transform** — 2024년 6월.
- **Modify Streaming Data Transforms** / **Refresh a Streaming Data Transform** — 2024년 6월.
- **Improve Data Quality by Monitoring Problem Record Metrics** — problem records DLO. 2024년 8월.

### Connectors & Sandbox

| 기능 | 등급 | 설명 |
|---|---|---|
| **Bring Inventory Data into Data Cloud with the Omnichannel Inventory Connector** | 신규 | **When: 2024년 6월.** (Omnichannel Inventory Connector 라벨은 Beta.) |
| **Import data from the Adobe Marketo Engage connector to Data Cloud** | GA(narrative: "generally available in June 2024") | campaign, lead, lead activity. |
| **Experience Faster Salesforce CRM Connector Refreshes** | 변경 | 2024년 6월. |
| **Identify Your Salesforce CRM Orgs Using an Alias** | 신규 | 2024년 6월. |
| **Use Identity Provider Authentication for S3 Connectors** | 신규 | 2024년 7월. |
| **Deploy Data Kit Components with Autolaunched Flows** | 신규 | REST API. 2024년 8월. |
| **Work with Data Cloud in a Sandbox Org (Beta)** | **Beta** | 2024년 7월. Enterprise/Performance/Unlimited. |
| **Deploy Data Cloud Changes from a Sandbox to Production (Beta)** | **Beta** | data kit + change set. 2024년 8월. |
| **Improve Search Accuracy with Hybrid Search (Beta)** | **Beta** | vector + keyword search. **beta에서 한 번 활성화하면 비활성화 불가.** |

Data Kit autolaunched flow deploy REST API(verbatim — PDF p.226):

```text
// 소스 발췌 (PDF p.226) — Deploy Data Kit Components autolaunched flow API
POST https://services/data/v61.0/actions/custom/flow/sfdatakit__DeployDataKitComponents
```

### Unstructured Data / RAG / Misc

- **Connect Unstructured Data in Data Cloud** — vector search용 search index config.
- **Enhance Your AI and Automation Strategies with Unstructured Data in Data Cloud** — 2024년 6월.
- **Use Vector Search in Generative AI, Automation, and Analytics Tools** — 2024년 6월.
- **Supercharge Your AI Usage with Retrieval Augmented Generation (RAG)** — prompt template에 vector DB 콘텐츠 augment. *(Einstein 인접 — 위임)*
- **Add Context to Chunks with Prepend Fields** — 2024년 8월.
- **Organize Segment Intelligence Data With Data Spaces** — 2024년 7월.
- **Optimize Monetary Data Management with the Currency Data Type** — 2024년 9월. (+ Include a Currency Type in a Data Action)
- **Transcribe and Index Audio and Video Files (Beta)** — FLAC/MP3/WAV; AVI/MOV/MP4; whisper-small model. 2024년 8월.
- **Refine Access with Data Spaces Feature Permissions** — permission set 통합.
- **Customize Web Pages in Real Time** — real-time identity resolution/CI/segmentation. limited basis Summer '24; 2024년 7월.

### AI in Data Cloud (Einstein 위임 — 1줄 목록)

> 상세 → [[Summer '24/Einstein]]. 항목만 나열:

- **Power Your Generative AI Using Anthropic Models with Prompt Builder** — **Anthropic Claude 3 Haiku**(Amazon Bedrock; Einstein Trust Layer). 2024년 7월.
- **Power Your Generative AI with Google Gemini and Prompt Builder** — **Google Gemini**(Vertex AI). 2024년 7월.
- **Manage AI Models in Einstein Studio** · **Leverage Alerts to Evaluate the Quality of Your Predictive Model** · **Let Einstein Autoselect the Best Factors for Your Use Case**(Autopilot) · **Evaluate Your Model Performance with Activity Metrics** · **Access Models Quicker with the Updated Einstein Studio Navigation** · **Focus on Relevant Attributes When Creating Einstein Segments** · **Get Optimized Segment Results with Einstein Data Prism** · **Create and Customize Retrievers in Einstein Studio**.
- **은퇴: Einstein Studio Legacy Tab Is No Longer Available in Data Cloud** — Einstein Studio (Legacy) 탭 제거. 2024년 7월.
- **은퇴: Data Cloud Einstein Lookalikes in Segmentation Is Being Retired** — Data Cloud Einstein Lookalike Segments **2024-09-27부로 미제공.**

### Cross Cloud Updates for Data Cloud

통합 지점: Data Cloud and Apex(SOQL in Apex with Data Cloud Objects; Field/Record-Level Access; Mock SOQL Tests) · Commerce Intelligence · Einstein Search(Improve Search with Insights from Search Analytics — Pilot) · Einstein Personalization · Industries(Automotive, Consumer Goods, Data Processing Engine, Financial Services Cloud, List Builder, Loyalty Management, Manufacturing Cloud) · Marketing Cloud · Salesforce Flow(Run Tests for Data Cloud-Triggered Flows) · Service Cloud(Service Intelligence, Field Service Intelligence) · Enrichments · Reports/Dashboards · Sandbox.

---

## Analytics (Reports · Dashboards · CRM Analytics · Tableau)

> p.127 상단에는 Release Updates 섹션 spillover(Apex Action Exception rollback, View Roles permission, SAML multiple-config 등)가 있으나 이는 Analytics가 아닌 RU 항목 → [[Summer '24/Release Updates]].

### Unified Analytics Experiences

- **Post from CRM Analytics to Slack** — snapshot/link + quick action으로 Slack 게시.
- **Access Any Analytics Collection in Lightning Pages** — 이전엔 첫 collection만.

### Data Cloud Reports and Dashboards

| 기능 | 설명 |
|---|---|
| **Summarize Complex Data with Matrix Reports** | row group 최대 2 + column group 최대 2. |
| **Analyze Data from Unified Objects and Related Source Objects** | unified link object. |
| **Export More Records from Data Cloud Reports** | **최대 50,000 row(이전 2,000).** |
| **Build More Granular Reports on Calculated Insights** | **최대 5 dimension(이전 3).** |
| **Unlock Insights from Unstructured Data** | — |
| **Add Calculated Fields to Your Data Cloud Reports with Einstein Generative AI** | Einstein Report Formula Generation; DC Report GPT add-on. *(Einstein — 위임)* |
| **Use Smart Totals with Formula Fields** | — |

### CRM Analytics

| 기능 | 등급 | 설명 |
|---|---|---|
| **Amplify Visual Impact In Waterfall Charts with Conditional Formatting** | 변경 | — |
| **Embed CRM Analytics Dashboards in LWR Sites (Generally Available)** | **GA** | CRM Analytics Dashboard 컴포넌트. |
| **Get More Functionality with the New Dashboard Lightning Web Component (Generally Available)** | **GA** | native CRM Analytics Dashboard LWC. |
| **Optimize Recipes That Use the Local Salesforce Connection (Pilot)** | **Pilot** | — |
| **Access Your Snowflake Data Using VPC on AWS (Pilot)** | **Pilot** | VPC for Snowflake on AWS connector. |
| **Test CRM Analytics Endpoints in Postman** | 신규 | CRM Analytics Connect API Postman collection. |

### Intelligent Analytics Apps / Einstein Discovery / Tableau / Marketing Cloud Intelligence

| 항목 | 등급 | 설명 |
|---|---|---|
| **Intelligent Analytics Apps**(포인터) | — | Commerce Intelligence, Field Service Intelligence, Revenue Intelligence, Service Intelligence Release Notes. |
| **Externally Built Models in Einstein Discovery Are Being Retired** | 은퇴 | **2024-07-31 이후** Einstein Discovery에서 외부 ML model 사용 불가; 외부 model 기반 prediction definition 실패. |
| **Tableau**(포인터) | — | Tableau Cloud, Tableau Pulse, Tableau Desktop, Tableau Prep, Tableau Server release notes. |
| **Marketing Cloud Intelligence**(포인터) | — | 별도 release notes. |

---

## Commerce (B2B · D2C · OMS · Payments)

### Salesforce B2B and D2C Commerce — App · Template · Einstein · Setup

| 기능 | 등급 | 설명 |
|---|---|---|
| **Switch to an Improved Merchant Experience with the Refreshed Commerce App** | 변경 | Summer '24 신규 customer는 자동 적용. |
| **Improve the Look and Feel of Your Store with the Refreshed D2C Template** | 신규 | — |
| **Improve Search Results with Einstein Semantic Search** | 신규 | *(Einstein 기반 — 위임)* |
| **Enable Einstein Semantic Search in APAC Regions** | 변경 | APAC 지원. *(Einstein — 위임)* |
| **Use Tailored Guided Steps for Quick Store Setup** | 변경 | <30분. |
| **Get Set Up Quicker with the Updated Commerce Assistant** | 변경 | Payments, OM, Reports/Dashboards, Omnichannel Inventory 1-click 설정. |
| **Configure Commerce with the Enhanced Setup Assistant** | 변경 | — |
| **Activate and Publish a Store Without a Custom Domain** | 신규 | — |
| **Streamline Store Creation with Smart Defaults** | 변경 | Managed Checkout. External Apps 라이선스. |
| **Set Up Person Accounts with One Click** | 신규 | — |
| **Share Your Store Setup Experience with In-App Feedback** | 신규 | — |
| **Guest Access to D2C Stores Is Automatically Enabled** | 변경 | — |
| **Include Attachments When Importing Products** | 신규 | — |

### B2B/D2C — Cart and Checkout

(p.151–156) Set Up Checkout Details Quickly with Managed Checkout for D2C Stores · Automate Your Shipping Setup with Managed Checkout · Provide Shoppers Estimated Delivery Dates at Checkout · Improve the Shopping Experience with an Add-to-Cart Success Message · Show the Precise Price Breakdown in the Cart Summary · Give Shoppers More Options with Coupons at Checkout · Improve Checkout with a Guided Flow(Checkout Layout: Salesforce / Accordion) · Dynamically Display Cart Information at Checkout(Checkout Summary 컴포넌트).

### B2B/D2C — Search

| 기능 | 등급 | 설명 |
|---|---|---|
| **Automatically Rebuild Your Search Index** | 신규 | 5분마다 점검. |
| **Get Improved Page Performance with Displayable Product Fields (Beta)** | **Beta** | — |
| **Sort Products by SKU** | 변경 | 신규 D2C에서 Product SKU가 기본 sortable에서 제거. |
| **Improve Your Browse Experience with the Redesigned Product List Page** | 변경 | Results Grid 컴포넌트. |

### B2B/D2C — Data Cloud for Commerce

(p.159–164) Drive Business Insights and Grow Revenue with Data Cloud for Commerce · Inventory Intelligence Analytics Dashboard · Product Intelligence Analytics Dashboard · Shopper Intelligence Analytics Dashboard · Bring Inventory Data into Data Cloud with the Omnichannel Inventory Connector(2024년 6월) · Deliver a Personalized Customer Experience Using Data Cloud Segments · Use AI to Offer Conversational Recommendations and Add Products to Cart(Shopper Copilot actions for B2C Einstein Bots; Commerce Concierge bot block) *(Einstein — 위임)*.

### B2B/D2C — Promotions / Components / Store Management / Dashboards

- **Promotions**(p.165–167): Create Promotions with Ease Using a Template · Entice Customers with Shipping Promotions · Configure Promotion Segments with More Flexibility · Highlight Promotional Pricing in Your Store.
- **Components**(p.168–169): Blend Social Media into Your Commerce Store with the Social Links Component · Improve the Shopper Experience with Enhanced Components(Order History w/ product images).
- **Store Management**(p.170–172): Goals and Recommendations Is Now Part of the Insights and Actions Workspace · Enhance Store Performance with More Recommended Actions · View the History and Status of Accepted Actions · Use Visibility Rules to Manage What Buyers See.
- **Dashboards**(p.173–175): Commerce Payments Dashboard · Commerce Promotions Dashboard · Commerce Finance Dashboard · Order Summary Entity Data in the Business Overview Dashboard.

### B2B/D2C — Additional Commerce Features

| 기능 | 등급 | 설명 |
|---|---|---|
| **Automate Tax Processes with the New Salesforce Tax Solution for Managed Checkout (Generally Available)** | **GA** | US sales tax 자동. |
| **Preview Added Products in Your Store Before Activating** | 신규 | 최대 5 category. |
| **Salesforce Tax Solution Is Renamed Manual Salesforce Tax Solution** | 명칭 변경 | 기존 Salesforce Tax Solution → Manual Salesforce Tax Solution; 신규 자동 솔루션이 Salesforce Tax Solution 명칭 사용. |
| **Use a Single Custom Domain for Multiple Commerce Sites** | 변경 | — |
| **Customize Your Salesforce CDN Settings for Commerce LWR Stores** | 신규 | 최대 10 custom WAF rule. |
| **Product and Category Record Pages Have a New Layout** | 변경 | — |

### Salesforce Order Management

(p.180–181) **Exchange Fulfilled Items Using UI Flows**(Order Management Growth 라이선스) · **Bulk-Edit Items on Cancel, Discount, Return, and Return RMA Flows.**

### Salesforce Payments

(p.182–184) **Simplify Payments Setup Using the Commerce Setup Assistant** · **Save Time Setting Up a Merchant Account Using Managed Checkout** · **Get Pay Now with a Payments License Purchased from Your Account**(standalone Salesforce Payments 라이선스, blended-rate pricing) · **Offer Shoppers One-Click Checkout with Passwordless Login.**

---

## Field Service

> Einstein for Field Service(Pre-Work Brief with Prompt Builder)는 Einstein spoke 위임 — 1줄: Einstein Field Service User permission set + Einstein 1 Field Service Edition; Pre-Work Brief template은 Summer '24 후반 제공. 상세 → [[Summer '24/Einstein]].

### Enhanced Scheduling and Optimization

| 기능 | 등급 | 설명 |
|---|---|---|
| **Prevent Overlapping Optimization Runs** | 변경 | — |
| **Adjust Service Appointments with Visiting Hours to Your Local Time Zone** | 변경 | — |
| **Enhance Service Coverage and Boost Resource Productivity by Scheduling Across Multiple Time Zones** | 변경 | — |
| **Benefit from Smoother Scheduling and Optimization Services for Overlapping Travel Time Scenarios** | 변경 | — |
| **Get More Clarity and Resolve Issues Faster with Improved Error Messages** | 변경 | — |
| **Trace Who Triggered an Optimization in the Optimization Request** | 변경 | Owner field. |
| **Let Dispatchers Easily Set Criteria for Schedule Optimization** | 변경 | Appointment Optimization Criteria(이전 "Filter service appointments by"). |
| **Review the History of Scheduling and Optimization Requests with Activity Reports (Beta)** | **Beta** | Optimization Center. |
| **Access Optimization Request Files on Your Own (Beta)** | **Beta** | JSON request/response file. |
| **Keep Important Appointments Scheduled During Optimization (Beta)** | **Beta** | Keep Scheduled Criteria; Optimize global Apex method의 `KeepApptScheduled` property. |
| **Create More Precise Travel Time Estimations by Including a Buffer (Beta)** | **Beta** | — |
| **Get More Accurate Scheduling Recommendations with Appointment Insights (Beta)** | **Beta** | Working Territories + Extended Match rule. |

### Work Capacity

- **Reserve Workforce Capacity in a Service Territory**.
- **Work Capacity Limit Relaxation Renamed for Better Clarity to Limit Override** — 명칭 변경: **Work Capacity Limit Relaxation → Limit Override.**
- **Share Work Capacity Data and Information with Partner Community Dispatchers via Experience Cloud**.

### Operations — Service Documents / Asset Management / Field Service Intelligence

| 기능 | 등급 | 설명 |
|---|---|---|
| **Personalize Service Documents with Embedded Expressions** | 신규 | 구문 `{!Record.fieldname}` / `{!Record.Objectname.fieldname}`(예: `{!Record.Account.phone}`). |
| **Minimize Downtime with Asset Health Score** | 신규 | Proactive Asset Service; Data Cloud + CRM Analytics; Connected Assets. |
| **Provision Entitlements with Precision** | 신규 | Warranties View / Contracts View 컴포넌트. |
| **Link Assets to Multiple Accounts and Contacts** | 변경 | — |
| **Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules** | RU | Frequency/Frequency Type field 은퇴. Summer '22 최초 제공; **Winter '25 enforce.** → [[Summer '24/Release Updates]] |
| **Unlock Insights and Dashboards with Field Service Intelligence** | 신규 | Data Cloud + CRM Analytics. |

Service Document embedded expression 구문(verbatim — PDF p.361):

```text
// 소스 발췌 (PDF p.361) — Field Service Document Builder embedded expression
{!Record.fieldname}
{!Record.Objectname.fieldname}
예: {!Record.Account.phone}
```

### Customer Engagement / Mobile

| 기능 | 등급 | 설명 |
|---|---|---|
| **Improve Your Data Security with Automated Deletion of Visual Remote Assistant Video Recordings** | 신규 | prebuilt Apex action. |
| **Simplify Interactions with Data with Near Field Communication on iOS** | 신규 | NFC plug-in(이전 Android only). |
| **Capture the Layout of a Space with Augmented Reality** | 신규 | Space Capture plug-in; Lidar. iOS. |
| **Give Workers Access to Files with Content Libraries** | 신규 | — |
| **Track Hours Offline With Time Sheets Priming** | 신규 | 최대 3 time sheet list view. |
| **Stay on Track with the Field Service Widget (Generally Available)** | **GA** | iOS home screen widget. |
| **Get Accurate Site Check-Ins and Check-Outs (Generally Available)** | **GA** | geolocation timestamp. |
| **Choose How Mobile Workers Navigate to Destinations** | 신규 | address 또는 lat/long. |
| **Measure an Object with Augmented Reality** | 신규 | iPhone 11+. |
| **Create Leads and Opportunities from the Field** | 신규 | flow template. |
| **Upsell Your Business from the Field (Beta)** | **Beta** | New Quote (Beta) quick action. |
| **Optimize Data Retrieval with Cache-First (Beta)** | **Beta** | **When: 2024-06-05.** |

---

## Industries

> Industries는 21개 sub-cloud + Common Features로 가장 큰 섹션(p.376–551). 성숙도 태그가 있는 것만 표로 명시하고, 나머지는 sub-cloud별 개요로 정리한다. 신규 객체·API·license명은 verbatim. AI 항목은 Einstein spoke 위임 → [[Summer '24/Einstein]].

### 성숙도 태그가 명시된 Industries 기능 (전수)

| 기능(verbatim) | 등급 | sub-cloud / 설명 |
|---|---|---|
| **Life Sciences Cloud (Generally Available)** | **GA** | Life Sciences Cloud — 신규 end-to-end 제품. **When: 2024년 6월.** Participant Enrollment Add-On 라이선스. |
| **Integration Orchestration (Generally Available)** | **GA** | Communications Cloud / Industries Common — prebuilt LWC. "now generally available." |
| **Get Meaningful Recommendations with Account Summarization (Beta)** | **Beta** | Consumer Goods Cloud — Einstein Bot 기반 생성형 account summary. *(Einstein — 위임)* |
| **Patient Program Outcome Management (Pilot)** | **Pilot** | Life Sciences Cloud — parent. 하위: Store Outcome Data in the Patient Program Outcome Management Data Model (Pilot); Calculate Outcome Metrics Using Salesforce Flows (Pilot). |
| **Search for and Draft ESG Reports (Beta)** | **Beta** | Net Zero Cloud — Einstein 생성형 ESG report. *(Einstein — 위임)* |
| **Einstein for Fundraising (Beta)** | **Beta** | Salesforce for Nonprofits — parent. *(Einstein — 위임)* |
| **Draft Fundraising Gift Proposals with Einstein Copilot (Beta)** | **Beta** | Salesforce for Nonprofits — Copilot Actions Fundraising Gift Proposals. *(Einstein — 위임)* |
| **Create Decision Tables that Support Large Number of Rows (Pilot)** | **Pilot** | Industries Common Features(Business Rules Engine). |
| **Engagement (Beta)** + **Efficiently Summarize a Customer Interaction (Beta)** + **Efficiently Summarize Up To Five Recent Customer Interactions (Beta)** | **Beta** | Industries Common Features(Timeline/Engagement summarization). *(Einstein 인접 — 위임)* |
| **Share Visit is Retiring** | 은퇴 | Consumer Goods Cloud — Share Visit setting **Spring '25 은퇴 예정.** |

### Sub-cloud별 개요

- **Automotive Cloud** — Connected Services for Vehicles · Data Cloud for Automotive Experiences · Supplier Recovery Claims · Product Service Campaigns for Vehicle and Parts Recalls · Automotive Foundational Enhancements. Common Features: Action Launcher(semantic search; "Out-of-the-Box Deployment"→"Standard Deployment"), Business Rules Engine(Does Not Match/Contains operator; medium-scale decision table), Context Service, Criteria-Based Search and Filter, Data Processing Engine(CSV upload; Data Cloud runtime), List Builder for Data Cloud Segment, Timeline(data graph; event summary).
- **Communications Cloud** — Enterprise Sales Management, Communications Cloud Agent Console, Multiplay Subscription Management, Field Service for Industries, Industries CPQ, Enterprise Product Catalog(EPC), Integration Orchestration (Generally Available).
- **Connected Assets** — asset management, Actionable Event Orchestration, usage-based entitlements.
- **Consumer Goods Cloud** — Data Cloud data stream; Direct Store Delivery and Van Sales; sync ID; Modeler CLI; Rounding within Period; Push Promotion; Account Summarization(Beta); Capture Store-Related Data Easily; **Share Visit 은퇴(Spring '25).**
- **Energy and Utilities Cloud** — 산업 특화 솔루션(개요).
- **Asset Service Lifecycle Management** — Product Service Campaign; Work Order Estimation.
- **Financial Services Cloud** — client management, task automation, customer insights, data organization(개요).
- **Health Cloud** — Einstein 생성형 AI assessment 생성 *(Einstein — 위임)*; Home Health(visit scheduling, Experience Cloud 컴포넌트); Integrated Care Management + Milliman Care Guidelines(MCG); Group Benefits 앱; Intelligent Appointment Management; Provider Network Management(신규 앱).
- **Insurance** — policy administration, benefit administration, claims, billing.
- **Life Sciences Cloud (Generally Available)** — Participant Management(Criteria-Based Search and Filter; Prescreening Assessments; Built-in Templates; Capture Informed Participant Consents with Flows). Participant Enrollment Add-On 라이선스. 2024년 6월. + Patient Program Outcome Management(Pilot).
- **Loyalty Management** — Build Your Own Promotion template(Global Promotions Management); negative point balance option; clone/launch promotion; 최대 50,000 partner; 신규 permission set.
- **Manufacturing Cloud** — Data Cloud 기능; Warranty Supplier Recovery; product service campaign; Work Order Estimation.
- **Media Cloud** — business application(개요).
- **Net Zero Cloud** — Disclosure and Compliance Hub; Microsoft 365 Word disclosure template; Einstein 생성형 응답+설명 *(Einstein — 위임)*; GHG emission 계산 export; field history tracking; **Search for and Draft ESG Reports(Beta).**
- **Public Sector Solutions** — social insurance benefit claims; circumstances addressing; referral management; unified interaction notes 컴포넌트; benefit recertification; partner/funder 협업.
- **Referral Marketing** — referral promotion design; reusable promotion template; custom promotion stage name; refreshed guided flow; loyalty program referral; advocate count tracking.
- **Salesforce Contracts** — end-to-end contract lifecycle; opportunity/order/quote/standard/custom object.
- **Salesforce for Education** — Intelligent Degree Planning; learning course/program LWC; mentor/mentee matching guided flow; auto resource assignment + QR check-in; Einstein assessment suggestion *(Einstein — 위임)*; Admissions Connect/Student Success Hub/EDA → Education Cloud 마이그레이션; Common App first-year data.
- **Salesforce for Nonprofits** — Nonprofit Cloud(source code; donor acknowledgment; program participation; cohort); **Einstein for Fundraising(Beta)**; **Draft Fundraising Gift Proposals with Einstein Copilot(Beta).** *(Einstein — 위임)*
- **Vlocity Contract Lifecycle Management** — Lightning action Create Contract, Update Contract, Pick Frame Contract(opportunity/order/quote).
- **Industries Common Features** — Business Rules Engine(subexpression; medium-scale decision table; **Create Decision Tables that Support Large Number of Rows(Pilot)**); Data Processing Engine; Action Launcher; Context Service; Criteria-Based Search and Filter; List Builder for Data Cloud Segment; Timeline(**Engagement(Beta)**; **Efficiently Summarize a Customer Interaction(Beta)**; **Efficiently Summarize Up To Five Recent Customer Interactions(Beta)**; Efficiently Summarize the Information Stored in Object Records).

---

## Marketing

> Salesforce는 3개 marketing 제품 제공: Account Engagement(구 Pardot), Engagement(구 Marketing Cloud), Marketing Cloud Growth. + Einstein Personalization, Unified Messaging. **Marketing Cloud Engagement 릴리즈: 2024-06-07~06-28.** AI 항목 상세 → [[Summer '24/Einstein]].

### Einstein Personalization

- **Provide Personalized Experiences With Einstein Personalization** — Data Cloud 기반 신규 Customer 360 앱. restricted basis Summer '24. *(Einstein — 위임)*

### Marketing Cloud Account Engagement

| 기능 | 등급 | 설명 |
|---|---|---|
| **Send Operational Emails to Opted-Out Prospects Directly from Engagement Studio** | 신규 | — |
| **Copy Images to a Salesforce CMS Workspace** | 신규 | Growth edition + Data Cloud. |
| **View Alerts in the Optimizer** | 신규 | — |
| **Account Engagement API: New and Changed Items** | API | v5: Export Relationships, Landing Pages via API, API V5 for Flow(forms). |
| **Engage for Gmail Chrome Extension Is Being Retired** | 은퇴 | Manifest V2; **2024년 6월 은퇴 예정.** |

### Marketing Cloud Engagement — App / Setup / Security

(p.552–555) Quickly Deploy a Retail Onboarding Journey with Industry Solutions(2024-07-01 이후) · Get More Subscriber Information with Package Manager Interactive Email Industry Solutions(case/empty/lead/progressive profile/review form 5개) · Visualize Automation History(English only) · Copy Large Datasets Efficiently in Automation Studio(Data Copy or Import) · Fine-Tune Permissions for SFTP Users · Plan Automations Based on Start-Time Scheduling Recommendations · Repeat Automations More Frequently(**15분마다**, 이전 1시간) · Get More Insights About Your Automation Health and History · Secure Event Notification Service Connections with OAuth 2.0 with Assertion Authentication · Monitor Event Notification Service Callbacks Using Alert Manager · **Social Studio Is Being Retired**(은퇴: **2024-11-18**; 90일 후 데이터 삭제; family: Social Studio, Command Center, Social Studio Mobile App, Social Studio Automate, **Social Customer Service**(무료 Starter Pack 포함)).

### Marketing Cloud Engagement — Cross-Cloud / Data Management / Developers

- **Cross-Cloud**: Prevent Email Sends with Empty Fields in Distributed Marketing · **Process Builder Is Retiring for Marketing Cloud Connect**(record-triggered flow로 자동 마이그레이션; Spring '24 이후~4월 말 View All, 그 외 Summer '24; V60 API 필요).
- **Data Management**: Maximum Length of a Data Extension Field Has Changed(**255**, 이전 254) · **Engagement Data Retention and Access Policy Is Changing**(**2025-01-15부터** retention 180일 제한).
- **Developers**(p.557–558): AMPscript `RetrieveSalesforceObjects()` Rowset Limit(**1,000 row**) · Compress Journey History Data Downloads · Manage Data Extensions with REST API · Release Multiple Contacts from Journey Waits Simultaneously(최대 100) · Use AMPscript to Encode JWTs with RSA Signatures(SHA-256/384/512).

### Marketing Cloud Engagement — Journeys / Messaging / Intelligence / Personalization

- **Journeys**(p.559): High System Priority · Useful Journey Information on the Canvas · High-Throughput Sending(2024년 3월) · Specify Inbox Message Send Dates · Improve Journey Performance with Recommendations.
- **Messaging**(p.560–563): Shorten SMS Links · Secure a Custom Domain for SMS Link Shortening · DLT Templates · Add MobilePush to Flutter(2024-04-01) · MobilePush Diagnostic Tool · MobilePush Developer Documentation Updated · **8개 신규 ENS event**(Push Sent, Push Not Sent, Push Bounced, Push Open, In-App Delivered, In-App Displayed, In-App Dismissed, Inbox Open) · New Privacy Manifest(iOS SDK 8.1.2, SFMC SDK 1.1.2; 2024-05-01 발효) · New Authentication Pattern for Android(Service Account JSON 업로드, 2024-06-01 이전) · Reuse Template Message Names Across WhatsApp Business Accounts(2024-07-12 이후 template).
- **Marketing Cloud Intelligence**(p.564–565): LinkedIn Company Page Connector · Google Display & Video 360 · Google Search Ads 360 · Performance Max Data in Bing Ads.
- **Marketing Cloud Personalization**(p.565): Track More Product Metrics · Update Your Firebase Cloud Messaging API Certificate(legacy FCM → FCM HTTP V1).

### Marketing Cloud Growth

(p.567–576) New Access Points on Campaigns · Updated Flow Functionality(Collect Consent with Signup Forms; Remove Users from Flows with Exit Rules — 최대 10; Check for Duplicates Before Creating Records; Access Data Graph Attributes in Campaign Flows) · Build a Static List Quickly with Campaign Members · Track and Use Data(Track Engagement on External Sites; Customize Engagement and Fit Scoring Rules) · Content Creation Enhancements(**Brand Your Content (Generally Available)**; Share Content Across Marketing Workspaces; Content Cloning) · More Accessible and Secure Landing Pages(SEO; Google reCAPTCHA v2; Preview as Guest/Authenticated) · SMS Request and Flow Experience(Save SMS Drafts; Enable SMS Usage in Flow for Unified Messaging) · Grounded Einstein AI Tools(**Create On-Brand Campaigns with Einstein Copilot** — Copilot가 Marketing에서 **2024년 9월 GA**; New Branding Fields; Data Prism — 2024년 9월) *(Einstein — 위임)* · Other Changes(Setup Reorganized; Data Kits/Analytics Packages Updated; Manually Update Consent; Personalize with Related Data; Reply Mail Management; Custom Domain Links; API Name Field Added; Jump-start with a Brief; Add Segments to a Campaign).

> **Note:** Marketing Cloud Growth에서 명시적 GA는 **Brand Your Content (Generally Available)** 단 하나다.

### Unified Messaging

(p.577–578) Merge Marketing and Service by Migrating from WhatsApp-First Business Messaging to Unified Messaging(단방향) · Transfer a WhatsApp Conversation from Marketing Cloud Engagement to Service Cloud with Journey Builder(WhatsApp Session Transfer activity) · View Analytics for the WhatsApp Session Transfer Activity · Suppress Promotional WhatsApp Messages During Support Interactions · Expand the Data Available for WhatsApp Engagement Queries(Correlation ID, Sender Display Name, Interactive Content Type) · Configure Customer Consent for Unified WhatsApp Messages in Flow.

---

## MuleSoft

- **포인터 섹션** (p.583, 인쇄 579). 메인 릴리즈 노트에 GA/Beta/Pilot 개별 항목 없음 — 별도 **MuleSoft Release Notes**(제품별 구성)로 안내. "Use the MuleSoft Anypoint Platform suite of products to connect and integrate apps, systems, and data."

---

## Revenue (Revenue Lifecycle Management · Billing · Subscription Management)

> RLM은 Salesforce platform 기반 end-to-end revenue 솔루션. 본 릴리즈 핵심은 **Dynamic Revenue Orchestrator GA.** Apex namespace 상세는 별도 reference 위임 가능.

### Revenue Lifecycle Management

RLM 영역: Product Catalog Management · Salesforce Pricing · Product Configurator · Quote and Order Capture · Asset Lifecycle · **Dynamic Revenue Orchestrator (Generally Available).**

- **Product Catalog Management**(p.594–604): Use Dynamic Options to Add All Products Based On a Product Classification to a Product Bundle · Maximize Product Reach with Translated Product and Product Category Data · Accurately Represent Monetary Values and Percentages in Product Attributes(currency/percent data type) · Alter Product Attribute Values Through Slider Controls · **Personalize Product Catalog Management Objects with Custom Fields**(custom field 허용: AttributeCategory, AttributeCategoryAttribute, AttributePicklist, AttributePicklistValue, AttrPicklistExcludedValue, ProductClassification, ProductClassificationAttr, ProductAttributeDefinition, ProductRelatedComponent, ProductRelComponentOverride, ProductComponentGroup, ProductComponentGrpOverride, ProductRelationshipType) · Other Changes(Include or Exclude Picklist Values; Validate Product Definition — 이전 Validate Product Bundle; Show More 10 products) · Product Discovery · New/Changed Objects(AttrPicklistExcludedValue, ProductSpecificationTypeLocalization; 신규 field FulfillmentQtyCalcMethods, DecompositionScope, StepValue, Slider display type, Currency/Percent DataType) · Connect REST API(신규 `/connect/pcm/products/bulk`).
- **Salesforce Pricing**(p.605–612): Accurately Derive Prices from Products and Assets(Derived Product; Pricing Contributors; Derived Price Element) · Automatically Populate Output Variables for Pricing Elements · Easily Update Context Tags(Assignment element) · Enhance Pricing Data Security · Contract-Based Pricing · Track Pricing Data Using Event Log Files · Operations Console · Cost Books · Redesigned Price Book Component · New Objects(CostBook, CostBookEntry, PriceBookEntryDerivedPrice, ProductSellingModelDataTranslation, ContractItemPrice) · Connect REST API(`/connect/core-pricing/pbeDerivedPricingSourceProduct`, waterfall) · New Metadata Type(**IndustriesPricingSettings**, API v60.0).
- **Product Configurator**(p.613–616): Actionable Configuration Rules(최대 3 condition, 3 action, 8 sub-condition) · Flexible and Dynamic Sales Packages · Additional Data Types(currency/percentage) · Custom Field and Field Mapping Support · New/Changed Objects(Sequence field in ProductConfigurationRule) · Connect REST API(8개 신규 configurator action: add-nodes, load-instance, set-instance, delete-nodes, get-instance, save-instance, set-product-quantity, update-nodes).
- **Quote and Order Capture**(p.617–623): **Transaction Line Editor**(Derive Prices; Customize for Partner Users; Edit in Bulk; Enhance for Sales Reps; Search and Add Products Across All Catalogs; Refresh Inaccurate Prices; Visualize Changes) · Custom Field Support · Customize Prices for Different Types of Transactions(Sales Transaction Type object) · Craft Quote Documents with Document Builder · Tax Information on Orders · Easily Submit Orders for Fulfillment(submitOrder invocable action) · New/Changed Objects(SalesTransactionType, SalesTransactionTypeOwnerSharingRule, SalesTransactionTypeShare; 신규 field ValidationResult, OrchestrationSbmsStatus, CalculationStatus, CustomProductName, SubscriptionTerm; ContractItemPrice/ContractItemPriceHistory; PricingSource, RenewalTerm2, RenewalTermUnit on Contract) · New Invocable Action(createContract, API v60.0) · New Metadata Type.
- **Asset Lifecycle**(p.623–627): Assetize Orders Flow · Contract Pricing · Create Contract From Quote · Visualize Quote and Order Changes · **Asset Conversion Tool**(open-source SMToRLMAssetConversionTool, GitHub) · Customer Community / Customer Community Plus 지원 · Managed Asset Viewer · New Object(AssetStatePeriodAttribute, API v60.0).
- **Dynamic Revenue Orchestrator (Generally Available)**(p.627–632): **GA** parent. 하위: Enable DRO · Set Up Permissions and Licenses · Fulfillment at a Glance · Define How Order Line Items Decompose · Design Orchestration Graphically · Configure Mapping · Monitor Decomposition · View Fulfillment · Track Items in Jeopardy · Manage Fallout. New Objects(AssetFulfillmentDecomp, FulfillmentAsset, FulfillmentAssetAttrribute, FulfillmentFalloutRule, FulfillmentStepJeopardyRule, ProductFulfillmentDecompRule, FulfillmentStepDefinition, FulfillmentStepDefinitionGroup, FulfillmentStepDependencyDefinition, ProductFulfillmentScenario, FulfillmentStepType, FulfillmentPlan, FulfillmentStep, FulfillmentStepDependency, FulfillmentStepSource, ValTfrm, ValTfrmGrp, ProductDecompEnrichmentRule, FulfillmentWorkspaceItem, FulfillmentWorkspace, FulfillmentLineSourceRel, FulfillmentLineRel, FulfillmentLineAttribute, FulfillmentAssetRelationship) · New Metadata Type · New Invocable Action(submitOrder).

### Salesforce Billing

(p.632–633) Improved Clean Up Process for Invoice Runs · New Metadata Type(InvLatePymntRiskCalc API v55.0; CollectionsDashboard API v56.0).

### Salesforce Subscription Management

(p.633) New Metadata Type(SubscriptionManagementSettings, API v55.0).

---

## Work.com

- **포인터 섹션** (p.838–840, 인쇄 834). 메인 릴리즈 노트에 GA/Beta/Pilot 개별 항목 없음 — 별도 **Work.com Release Notes**로 안내. "Prepare your business, employees, and facilities. Respond to major events."

---

## Slack

- **Salesforce for Slack Integrations** — 메인 Summer '24 릴리즈 노트에 GA/Beta 개별 항목 없음. 별도 **Salesforce for Slack Integrations Release Notes**로 안내.
- 단, Analytics 섹션의 **Post from CRM Analytics to Slack**(위 Analytics 참조)는 Slack 연동 항목으로 본 릴리즈에 존재 — CRM Analytics snapshot/link를 quick action으로 Slack에 게시·협업.

---

## 신규 객체·API·핵심 날짜 (빠른 참조)

- **신규 객체:** ObjectRelatedUrl(Experience Cloud) · CostBook·CostBookEntry·PriceBookEntryDerivedPrice·ContractItemPrice·SalesTransactionType·AssetStatePeriodAttribute(RLM) · 다수 Fulfillment* object(Dynamic Revenue Orchestrator) · User Territory Association Logs(Sales Territories)
- **신규 메타데이터 타입:** EnablementMeasureDefinition·EnablementProgramDefinition(Enablement) · IndustriesPricingSettings · InvLatePymntRiskCalc · CollectionsDashboard · SubscriptionManagementSettings
- **신규/변경 Apex·API:** submitOrder·createContract invocable action · FSL Optimize global method `KeepApptScheduled` property · Cart Calculate·Configurator Connect REST(`/connect/pcm/products/bulk`, 8개 configurator action) · Deploy Data Kit autolaunched flow API
- **핵심 날짜(은퇴/강제):** Inbox Mobile 은퇴 2024-02-01 · Salesforce for Outlook 은퇴 2027-12 · Einstein Automated Contacts 은퇴 2025-02 · Cadence Builder Classic 은퇴 Summer '25(Spring '25부터 생성 불가) · Salesforce Maps custom source 은퇴 2025-05-16 · standard WhatsApp 업그레이드 마감 2025-07-30(2024-07-01부터 생성 불가) · Social Customer Service Starter Pack 은퇴 2024-11-16 · Social Studio 은퇴 2024-11-18 · Legacy Chat 은퇴 2026-02-14 · Lightning Knowledge migration enforce 2025-06-01 · Data Cloud Lookalikes 은퇴 2024-09-27 · Einstein Discovery 외부 model 은퇴 2024-07-31 · Engage for Gmail 은퇴 2024-06 · MCE data retention 변경 2025-01-15 · Share Visit 은퇴 Spring '25 · Force.com site URL redirection 종료 2024-09
- **RU enforce 시점:** Email-to-Case Lightning Editor / Disable Ref ID Threading / Intelligence Signal Apex Variable / Single Domain Certificate CDN / Enable New Order Save Behavior = **Spring '25** · Conversation Intelligence Rule Name to Flow / Maintenance Plan Frequency / Lightning Article Editor = **Winter '25** (상세 → [[Summer '24/Release Updates]])

---

## 관련 노트

- [[Summer '24]] — 릴리즈 허브(Apex·LWC·Flow·Admin·Security·Architecture·Einstein·Release Updates 전체)
- [[Summer '24/Einstein]] — AI/Einstein 도메인 상세(Copilot, Prompt Builder, Einstein Studio, Work Summaries, Claude 3 Haiku/Gemini, 클라우드별 Einstein 기능 맥락)
- [[Summer '24/Automation]] — Flow·Orchestration·자동화 도메인 상세
- [[Summer '24/Platform]] — Mobile 챕터(Salesforce Mobile App·Mobile Publisher)는 본 노트가 단일 소유, Platform은 Android Firebase 등 보안 연계만 cross-ref
- [[Summer '24/Release Updates]] — 필수 적용(RU) 항목 상세(강제 시점 맵)
- [[Release MOC]] — 릴리즈 노트 섹션 목차
