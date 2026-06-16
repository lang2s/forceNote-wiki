---
tags: [release, spring_24, clouds, sales, service, data-cloud, analytics, industries]
source: salesforce_spring24_release_notes.pdf
created: 2026-06-16
aliases: [Spring '24 Clouds, 스프링 24 클라우드, Sales Service Data Cloud Analytics RLM]
---

# Spring '24 — Clouds

> Spring '24(API v60.0) 릴리즈 노트의 클라우드별(제품군별) 변경 사항 전수 — Sales·Service·Data Cloud·Analytics·Commerce·Experience Cloud·Field Service·Industries·Marketing Cloud·Revenue Lifecycle Management·OmniStudio·Salesforce CMS·Slack·Work.com의 GA·Beta 전수 + Pilot/DevPreview + 신규 객체·API.

> 허브: [[Spring '24]]

> [!note] AI/Einstein 항목(Einstein Copilot, Prompt Builder, Einstein Studio, Einstein for Sales/Service, Generative AI)은 본 노트에 1줄로만 언급하고 상세는 Einstein spoke로 위임한다([[Spring '24/Einstein]]). Release Update(필수 적용) 상세는 [[Spring '24/Release Updates]] 참조.

> 범례: **GA**=Generally Available · **Beta** · **Pilot** · **DevPrev**=Developer Preview · **RU**=Release Update · **변경**=Enhancement

---

## Sales Cloud

> Einstein for Sales(Sales Emails, Copilot 표준 액션, Call Explorer, Conversation Insights)는 Einstein spoke 위임 — 1줄: Einstein Copilot가 Sales Cloud Everywhere·데스크톱에서 GA.

### Sales Fundamentals — Seller Home

- **Drive Success with Seller Home** — opportunity·account·lead·contact overview, 하루 agenda, goal/progress, to-do, recent record, Einstein contact suggestion을 한 화면에. Sales·Sales Console·Sales Engagement 앱의 default Home. Lightning Experience — Professional/Enterprise/Performance/Unlimited + Sales Cloud. 구성 항목: Opportunity/Account/Lead/Contact overview, Weekly/Monthly goals, Today's Events, To-do, Recent Records, Contact suggestions(Einstein).
- **Salesforce Maps Lite** — 지도 기반 in-person·virtual visit 계획.
- **Account Intelligence View** — account activity·opportunity metric·case·activity log 통합 뷰.
- **Lead and Contact Intelligence Views** — engagement·insight 뷰.

### Sales Engagement — Cadence Builder 2.0

- **Create Responsive Cadences Faster with Cadence Builder 2.0** — 3개 track(neutral·positive·negative) + entry rule로 target response 기반 자동 이동. 이전엔 branch마다 중복 step 필요. Performance/Unlimited/Professional/Enterprise + Sales Cloud. Sales Engagement Cadence Creator permission. **Cadence Builder 2.0 vs Classic 중 선택. 2.0은 cadence autolaunched flow·screen flow step 미지원.**
- **Save Time by Creating Call Scripts and Email Templates with Quick Cadences** — quick cadence 생성 창에서 call script·email template 직접 생성.

### Pipeline Inspection

- **Get More in Pipeline Inspection with Increased Record Limits in Charts and Views**(IdeaExchange Delivered) — **모든 metric·list view·chart의 record 한도가 2,000으로 증가.**
  > PDF 원문: "All metrics, list views, and charts now have a 2,000 record limit. Previously, the flow chart and some metrics in the pipeline changes metrics group had a 1,000 record limit, while the waterfall chart and forecast category metrics had a 2,000 record limit."
- **Narrow In on Deals with Filter Logic in Pipeline Inspection** — filter panel에 filter logic 추가.
- **Get a More Flexible Pipeline Inspection UI**(IdeaExchange Delivered) — 화면 resize 시 metric·quick filter가 조정되는 반응형 UI.

### Collaborative Forecasts — Forecast Groups (신규 객체)

| 기능 | 설명 |
|---|---|
| **View and Set Forecasts with Forecast Groups** | business segment(industry·sale type)별 forecast grouping. **Spring '24 이후 생성 + Opportunity·Opportunity Product 기반 forecast type만.** product family group은 계속 가능. Professional/Performance/Developer + Enterprise/Unlimited(Sales Cloud). custom single-selection picklist field(Opportunity/Opportunity Product/Product) 기준. **custom picklist에서 최대 50개 값 선택.** Edit Group Values. |
| **Gain Forecast Clarity with Side-by-Side Adjustment Details** | adjustment 값을 별도 컬럼(original / direct report adjustment / own adjustment). Forecast Settings에서 컬럼 표시·이름 변경. |
| **Access Different Forecast Views in Tabs** | multiple active forecast type를 tab으로. Edit Tab Selections. Salesforce mobile은 선택된 tab만 표시. |
| **Gain Deeper Insights About Forecast Health with Forecast Chart Enhancements** | Forecast Changes chart·Historical Trends(product family·forecast group 시각화, data summary table). |
| **Unlock More Details and Spot Trends with More Forecasting Custom Report Types** | external custom column·opportunity product split forecast report type. |
| **Round Forecast Amounts for More Streamlined Forecasts** | 2023년 10월 초부터 소수점 없이 반올림 표시. |

신규 객체·필드(verbatim):

```text
// 소스 발췌 (PDF 라인 12633~)
새 객체: ForecastingGroup, ForecastingGroupItem
  — custom single-selection picklist 기반 forecast group·값 식별

새 필드:
  ForecastingType.ForecastingGroupId        — forecast type에 할당된 그룹 식별
  ForecastingGroupItemId  ON  ForecastingAdjustment, ForecastingCustomData,
                              ForecastingItem, ForecastingOwnerAdjustment,
                              ForecastingQuota
  ForecastingType.HasAdjustments, ForecastingType.HasOwnerAdjustments
```

> PDF 원문: "You can select up to 50 values from a custom picklist that's used to group a forecast."

### Sales Cloud Everywhere (Chrome Extension)

- **Set Up Salesforce Everywhere More Easily** — 별도 enablement section. **When: 2024-02-29.** Starter/Enterprise/Performance/Unlimited/Developer.
- **Stay Logged In to Sales Cloud Everywhere** — browser close·manual logout 시에만 로그아웃되는 ongoing session.
- **Keep Productivity at Hand with the Embedded Side Panel for Everywhere** — Chrome embedded side panel(width 조정 가능).
- **Work Efficiently with Sales Cloud Everywhere** — navigation menu, alert, prospect, deal, activity timeline·related list, 1-click cadence.
- **Sell More Efficiently in Sales Cloud Everywhere** — 1-click lead convert·cadence.
- **Follow Up on Companies/People of Interest with Contextual Insights** — website 기반 Salesforce 데이터 매칭(account / lead·contact·person account).
- **Update Data for Many Records in Workspace** — 여러 record 동일 field 동시 업데이트.
- **Focus on the Right Records and Personalize Your Workspace** — filter workspace.
- **See the Fields You Want in Sales Cloud Everywhere** — field 선택·배열.
- **Get the Power of Copilot in Sales Cloud Everywhere** — Einstein Copilot(Einstein spoke 위임 — 1줄).

### Revenue Intelligence

- Revenue Insights 신규 setup(simplified workflow, error message 개선), 앱·task 한 곳 관리, **Stage Conversion analysis**(pipeline 상세).

### Partner Relationship Management

- **Channel Management Console** — indirect sales command center 전용 앱.
- **Partner Enablement and In-App Guidance** — onboarding·training.
- partner가 Contact Intelligence View, Lead Intelligence View, Pipeline Inspection 기능 접근(Experience Builder). Einstein Lead/Opportunity Scoring Pipeline Inspection, Enhanced Object View 컴포넌트.

### Email, Calendar, and Integrations — 변경/은퇴

| 항목 | 등급/날짜 | 설명 |
|---|---|---|
| **Service Account OAuth 2.0 Authentication to Microsoft Office 365 Is Being Retired** | 은퇴 | EAC + Microsoft Office 365 service account OAuth 2.0 setup 경고. **2024년 5월부터 Microsoft가 ApplicationImpersonation role 할당 차단.** org-level OAuth 2.0 권장. |
| **Connect Google to Salesforce with a Google Workspace Marketplace App** | 변경 | EAC 새 Google Workspace Marketplace 앱 auth. |
| **Set Up Meeting Options More Easily in Sales Engagement Setup** | 변경 | 새 meeting option(suggested meeting time). Inbox 필요. |

### Retirements

- **Salesforce for Outlook** — 은퇴일이 **December 2027로 연기**(이전 June 2024). Outlook integration + EAC 권장.
- **Inbox Mobile** — **은퇴 2024-02-01.** Outlook·Gmail integration(desktop) + Salesforce mobile app + EAC 대체.
- **Meeting Studio** — **은퇴 Spring '24.** Google Meet·Microsoft Teams·Zoom·WebEx 대체. Meeting Digest는 계속 지원.
- **Social Accounts, Contacts, and Leads** — **은퇴.** AppExchange 앱으로 social profile 표시.
- **Marketing 앱 리네임** — classic "Marketing" 앱 → **Marketing CRM Classic.**
- **Enable New Order Save Behavior**(RU) — order product update가 parent order 변경 시 custom application logic 실행(이전엔 parent record 미평가). Winter '25 enforce.

---

## Service Cloud

> Einstein for Service(Work Summaries, Service Replies, Conversation Mining, Knowledge Creation, Service Intelligence)는 Einstein spoke 위임 — 1줄: Conversation Mining GA, Knowledge Creation(Grow Your Knowledge Base with Generative AI) GA, Service Replies for Email GA(6개 언어), Einstein for Service add-on 라이선스 명칭 통합(Enterprise 지원).

### Channels

| 기능 | 등급 | 설명 |
|---|---|---|
| **Save a Transcript of Your Messaging for Web Conversation** | 변경 | unverified·verified end user가 session 종료 후 PDF transcript 다운로드. |
| **Get Started with Enhanced Messaging for SMS** | **GA** | enhanced long code·short code SMS channel. agent: session transfer(agent/queue/routing flow), Enhanced Conversation 컴포넌트 quick text·emoji·file, messaging component plain text, supervisor flag·whisper, inactive mark. Messaging Settings → New Channel → SMS → Enhanced(Salesforce Support case 필요). |
| **Try Partner Messaging** | **Beta** | partner messaging channel. |
| **Say Goodbye to Standard WhatsApp Channels** | 은퇴 예정 | standard WhatsApp → enhanced upgrade **by 2025-07-30. 2024-07-01부터 추가 standard WhatsApp channel 생성 불가.** |
| **Pass the Conversation Intelligence Rule Name as Input to a Flow** | **RU** | Conversation Intelligence rule name을 flow input으로. |

### Routing — Omni Supervisor 커스텀 페이지

| 기능 | 설명 |
|---|---|
| **Work More Efficiently with the New Omni-Channel Sidebar** | 새 Omni-Channel sidebar(persistent, collapsible, standard·console navigation). 기존 utility-bar widget 유지. Professional/Enterprise/Performance/Unlimited/Developer. Omni-Channel Settings → Enhanced Omni-Channel Routing + App Manager → Use Omni-Channel Sidebar. |
| **Swiftly Tailor Omni Supervisor to Your Supervisors' Needs with Configurable Tabs** | supervisor별 visible tab 설정(custom tab 포함, order). Enhanced Omni-Channel 필요. Supervisor Configurations → Define Visible Tabs. |
| **Create Custom Tabs for Omni Supervisor** | 새 **Omni Supervisor Page** Lightning page type(custom app·metric embed, AppExchange 공유). Lightning App Builder → supervisor configuration 할당. |
| **Select Multiple Queues You Want to Monitor on the Omni Supervisor Wallboard** | wallboard multi-select queue. 미선택 시 모든 queue. |

- 신규 객체: **OmniSupervisorConfigTab**(Omni Supervisor tab·tab order 구성). **isOmniPinnedViewEnabled** field(Omni-Channel sidebar 활성 여부).
- 기타: Supervisor Wallboard applied filter 표시, Voice·Messaging transcript에서 agent identity 숨김, standard navigation 앱에서 Enhanced Omni-Channel, status-based capacity로 messaging session pause·추적.

### Email-to-Case / Knowledge — GA & Release Update

| 항목 | 등급 | 설명 |
|---|---|---|
| **Transition to the Lightning Editor for Email Composers in Email-to-Case** | **GA / RU** | docked·case feed email composer의 email editor를 Lightning Editor로 교체. Lightning Experience Spring '24 GA. |
| **Disable Ref ID and Transition to New Email Threading Behavior** | **RU** | Ref ID threading off → Lightning threading. incoming email은 subject·body의 secure token으로 매칭, 없으면 email header metadata. **When: Spring '25 enforce.** Essentials/Professional/Enterprise/Unlimited/Developer. **merge field `Case.Thread_Id` → `Case.Thread_Token`. custom code `Cases.getCaseIdFromEmailThreadId` → `Cases.getCaseIdFromEmailHeaders` 또는 `EmailMessages.getRecordIdFromEmail`.** |
| **Turn On Lightning Article Editor and Article Personalization for Knowledge** | **RU** | Lightning Article Editor + Article Personalization 활성화. |

### Self-Service — Data Categories

| 기능 | 등급 | 설명 |
|---|---|---|
| **Structure Your Help Site with Data Categories** | **GA** | LWR site에 Data Categories GA(article·question·idea 분류). LWR — Enterprise/Professional/Unlimited/Developer. |
| **Change the Look and Feel of Your Data Categories** | 변경 | Data Categories Editor(label·description). |
| **Improve the Experience of Your Site Users** | 변경 | SEO-friendly URL(예: `/categories/insurance/home_insurance`). |
| **View Data Subcategories with the Subcategories List Component** | 변경 | Subcategories List 컴포넌트(child data category). Network Data Category page. |

### Knowledge & Service Catalog

- **Unify Your Organizational Knowledge Across Sources in Salesforce**(Beta) — Unified Knowledge(통합 knowledge base·search).
- **Action Launcher** — 버튼·링크 기반 액션을 agent가 검색·클릭으로 실행. custom title, out-of-the-box deployment 추가.
- **Service Catalog** — fulfillment automation 빠른 생성(이전엔 screen flow만), catalog item 접근 제한, 검색, site navigation.
- **Customer Service Incident Management** — Customer Service Incident Management + Related Broadcast Communications Alerts 활성화.
- **Resolve and Deflect Issues with Einstein Search Answers**(GA) — global search bar·knowledge sidebar·Experience site에 질문/구문 입력 시 knowledge article에서 가장 관련된 snippet 추출. **AI-Generated Search Answers**는 article·기타 source 기반으로 질문에 맞춘 요약 응답 생성(standard Search Answers 필요). **English-only article만 지원.** Where: Lightning Experience, Lightning Knowledge, Salesforce Experience Sites(LWR/Aura) + Lightning Knowledge 활성. 라이선스: agent용 Search Answers·AI-Generated Search Answers는 **Einstein for Service Add-on SKU**(agent access는 Enterprise/Performance/Unlimited; **Einstein 1 Service Edition**(formerly UE+)도 지원). self-service Experience Cloud site의 AI-Generated Search Answers는 **Einstein 1 Service Edition(formerly UE+) 전용.** When: 2024년 2월 말부터 rolling. agent·self-service 사용자가 thumbs up/down으로 응답 피드백. *(Einstein 기반 — 상세는 Einstein spoke 위임: [[Spring '24/Einstein]])*
- **Service Intelligence**(Einstein 인접 — 1줄): case별 time·effort·escalation 예측, Knowledge article ROI·cost-saving metric, Service Data Kit 3.0.

---

## Data Cloud

> Einstein Studio / AI in Data Cloud는 Einstein spoke 위임 — 1줄: Einstein Studio(BYOM·외부 LLM·예측 AI 모델)는 별도 spoke. 아래는 비-AI 데이터 통합·세그먼테이션·연결 기능.

### Data Graphs & Setup

| 기능 | 설명 |
|---|---|
| **Retrieve Your Customer 360 Data in Near Real Time with Data Graphs** | primary DMO + 관련 object·calculated insight에서 선택한 field로 data graph 구성, JSON blob 직렬화. data graph는 **24시간마다 1회 refresh.** Developer/Enterprise/Performance/Unlimited. **When: 신규 org 2023-12-13, 기존 org 2024-01-04.** |
| **Query Data Graphs for Metadata and Data Using the Data Graphs APIs** | REST API로 data graph의 primary model object·관련 object·field 쿼리. ID·secondary lookup key로 데이터 쿼리. **Query API V1.** **When: 신규 2023-12-13, 기존 2024-01-04.** |
| **Experience a Streamlined Enablement for Data Cloud** | Spring '24부터 라이선스되면 즉시 enablement 진입. 이전 org은 Get Started 클릭 필요. |
| **Create Google Cloud Storage Data Streams More Easily with the New Connector** | 표준 GCS source connector(bucket명 매번 입력 불필요). **When: 2024년 3월.** |
| **Create SQL Queries with Query Editor** | Query Editor로 Data Cloud object에 SQL 쿼리(data space-aware, 저장 가능). **Note: localized Query Editor UI label은 Beta.** **When: 2024년 3월 중순.** |
| **Extend Data Cloud Objects to Snowflake Accounts Across AWS Regions and Public Clouds** | 모든 AWS region·public cloud(Azure/GCP) Snowflake 계정에 데이터 공유(secure views). 이전엔 동일 AWS region만. **When: 2024년 3월 중순.** |
| **Share Data in Near Real Time Between Data Cloud and Google BigQuery** | BYOL data share로 zero-copy 통합(data share + data share target → BigQuery views). **When: 2024년 3월 중순.** |

### Marketing / WhatsApp / Transforms

- **Build Engaging Messaging Experiences Using WhatsApp Data in Data Cloud** — Marketing Cloud의 WhatsApp contact·tracking 데이터 ingest. WhatsApp이 Email Studio/MobileConnect/MobilePush와 함께 표준 Marketing Cloud data bundle로.
- **Include More Complex Data in Batch Data Transforms** — formula transformation에서 multivalue field(list/array) 접근. **When: 2024년 2월.**
- **Expand Date Ranges in Batch Data Transforms** — sequence·explode 함수로 date range row 삽입. **When: 2024년 4월.**
- **Add Streaming and Batch Data Transforms to a Data Kit** / **Add Ingestion API Data Streams to a Data Kit** — default data space의 transform·Ingestion API data stream을 data kit에. **When: 2024년 2월.**
- **Create a Data Kit with More Connection Options** — SFTP·web/mobile app connector 기반 data stream. **When: 2024년 3월 중순.**
- **Build Data Cloud Apps Using Second-Generation Managed Packaging (2GP)** — Data Cloud 기능에 2GP 적용. scratch org, CLI로 data kit metadata 검색, GitHub 공유, 패키지화. **When: 2024년 4월. Who: Salesforce Partner만.**

### Connectors & Data Types

| 기능 | 등급 | 설명 |
|---|---|---|
| **Add New Connectors to Ingest Data Into Data Cloud** | **Beta** | AWS Athena, AWS RDS, Azure SQL Server, Azure Synapse, Databricks, Google Cloud SQL, HubSpot, Jira, Oracle NetSuite, SAP SuccessFactors, ServiceNow 등 신규 connector. **When: 2024년 4월.** |
| **Ingest Data from Kinesis Data Streams into Data Cloud with the Amazon Kinesis Connector** | **GA** | Kinesis Data Streams를 표준 DMO에 매핑. beta 이후 일부 변경. **When: 2024년 4월 GA.** More Connectors → Amazon Kinesis. |
| **Bring PostgreSQL Database Data into Data Cloud with the Heroku PostgreSQL Connector** | 변경 | Heroku PostgreSQL connector로 ingest. **When: 2024년 5월.** |
| **Create S3 Data Streams More Easily with the New Amazon S3 Connector** | 변경 | one-time auth(매번 inline credential 불필요). **When: 2024년 3월 중순.** |
| **Package Web and Mobile Data Streams in a Data Kit** | 변경 | web·mobile app connector 기반 data stream 패키지. **When: 2024년 4월 중순.** |
| **Do More with New Data Types in Data Cloud** | 변경 | **email, URL, phone, percent, boolean** data type 추가. **When: 2024년 3월.** |
| **Consume Native Salesforce Data Cloud Objects in Tableau Catalog** | 변경 | DLO/DMO/calculated insight을 Tableau Cloud·Desktop에서 distinct object로 표시. **Where: Tableau Cloud February 2024, Tableau Desktop 2024.1.** |
| **Send Segments Created in Tableau Cloud to Data Cloud** | 변경 | Tableau에서 segment 생성 → Data Cloud 전송. Salesforce Data Cloud connector. **When: 2024년 2월 중순.** |

### Segmentation & Activation

- **Fine-Tune Your Segment with New Boolean Expressions** — Has Value, Has No Value, Is True, Is False boolean expression. **When: 2024년 3월.**
- **Get insights on Segment Performance with Segment Intelligence** — in-platform 도구(Marketing Cloud Engagement, Google Ads, Meta Ads, Commerce Cloud connector). **Data Cloud Starter 라이선스 필요.**
- **Analyze Customer Segment Data with Amazon Insights** — Amazon Marketing Cloud segment 분석. **Ad Audiences 필요. When: 2024년 4월.**
- **Activate Audiences to Google DV360 / LinkedIn / SnapChat** — native activation. **Ad Audiences. When: DV360 2024년 5월, LinkedIn·SnapChat 2024년 4월.**
- **Refresh Segments Incrementally for Ecosystem Partners** — new·changed·deleted member만 refresh. **When: 2024년 3월.**
- **Activate Segments Within Data Cloud Through the Audience DMO** — activation payload를 Audience DMO에 저장(외부 전송 없이). **When: 2024년 3월.**
- **Manage B2C Communications Using Capping Control**(Pilot) — B2C 통신 cap(department-level threshold). **When: 2024년 3월.**
- **Apply Filters to Contact Points and the Activation Membership**(Pilot) — activation membership filter, contact point consent filter.
- **Expand Your Reach Using the WhatsApp Channel** — WhatsApp을 Marketing Cloud activation contact point로.
- **Create Segments with Unified Data Model Objects and Activate on Non-Unified DMOs** — Unified Individual segment → Individual activate.
- **Connect a Data Space to an Activation Target** / **Create an Activation Target for B2C Commerce and MC Personalization** — data space별 activation target(File Storage, External Platform, Marketing Cloud, Data Cloud Loyalty, B2C Commerce, MC Personalization).
- **Speed Identity Resolution with More Frequent Ruleset Processing** — 데이터 변경 시마다 ruleset 실행(비용 증가 없음).
- **Improve Identity Resolution Match Rules with Fuzzy Matching** — 모든 text field에 fuzzy matching. **match rule당 first name 외 최대 2개, ruleset당 first name 외 총 6개.** "Fuzzy Precision - High" 권장.
- **Match on OTT Contact Points in Identity Resolution** — WhatsApp·Signal 등 OTT contact point match rule.
- **Add New Object Permissions to Custom Permission Sets in Data Cloud** — 표준 permission set에 5개 object permission 자동 추가. custom permission set은 수동 추가 필요.
- **Quickly Find Data Cloud Connect API Reference Information** — 독립 Data Cloud Connect REST API guide로 분리.
- **Control Your Data Model By Changing DMO Category** — DMO category 변경(Profile↔Other).
- **Know the Statistics of a Data Lake Object with the New Refresh History Tab** — DLO record-level 통계(total/added/updated/removed).
- **Expanded Data Cloud Availability** — Singapore, Indonesia, Korea, UAE 포함 모든 geographic area에서 사용 가능(Government Cloud org 등 일부 제외).
- **Build Strong Data Foundations with BYOL Data Federation**(일부 GA) — BYOL data federation(zero-copy). **Snowflake·Google BigQuery에 대해 GA.**
- **Refine Access with Data Spaces Feature Permissions** — data space access control을 permission set에 통합.

---

## Analytics (Reports · Dashboards · CRM Analytics · Tableau)

### Lightning Reports and Dashboards

| 기능 | 등급 | 설명 |
|---|---|---|
| **Transfer Lightning Dashboard Ownership** | **GA** | 대시보드 소유권 이전(여러 대시보드 동시 + 신규 소유자 이메일 알림). 이전엔 clone/재생성 필요. Group/Essentials/Professional/Enterprise/Performance/Unlimited/Developer. Dashboards/Analytics 탭 → Change Owner. |
| **Supercharge Your Visualizations with Images, Rich Text, and Dashboard Widgets in All Salesforce Editions** | 변경 | 모든 에디션에서 rich text·image 위젯. **대시보드는 최대 25 widget 지원(charts·tables 최대 20 + images 3 + rich text widgets 25). 이전 한도는 합계 20.** Lightning 컴포넌트가 모든 에디션에서 "widgets"로 명칭 변경. 이전엔 Unlimited/Performance만. |
| **Focus Your View with More Dashboard Filters in All Salesforce Editions** | 변경 | 모든 에디션에서 Lightning 대시보드 필터 **최대 5개.** |
| **Easily Update Fields in Lightning Report Filters** | 변경 | 필터 삭제·재생성 없이 필드 변경. 이전엔 Salesforce Classic만. |
| **Rearrange Multiple Lightning Report Columns at Once** | 변경 | 여러 컬럼 동시 이동. 이전엔 Classic만. |
| **Filter Report Types by Objects or Fields in Enterprise and Performance Editions** | 변경 | 특정 object/field 포함 report type 검색. **최대 20개 object/field로 필터.** lookup·composite(geolocation/address) field 불가. 이전엔 Unlimited만. |
| **Access Report and Dashboard Subscriptions with Slack Slash Commands** | 변경 | Slack slash command로 구독 관리(수신자 추가·제거). 이전엔 CRM Analytics for Slack 앱 내에서만. |

> PDF 원문(위젯 한도): "Dashboards now support up to 25 widgets, including a maximum of 20 charts and tables, 3 images, and 25 rich text widgets. The former limit was 20 in total."

### Unified Analytics Experiences

- **Control Your Report and Dashboard Sharing from the Analytics Tab** — Reports/Dashboard 탭의 폴더 공유 기능이 Analytics 탭에서도 사용(동일 granular 권한).
- **Streamline Management of Your Dashboards With Bulk Selection** — 대시보드 batch 일괄 처리(소유권 일괄 변경 등). 체크박스 선택 후 Manage Items.
- **Save Dashboard Views on Your iOS/Android Devices** — 새 Save View로 모바일 기기에서 대시보드 뷰 저장(iOS 12.2+ / Android 5+). 이전엔 데스크톱만. **When: 2024-02-12 주.**

### Data Cloud Reports and Dashboards

- **Tailor Reports on Data Model Objects with Custom Report Types** — DMO에 custom report type. **단일 custom report type에서 최대 4개 DMO 조인.** Data Cloud — Developer/Enterprise/Performance/Unlimited.
- **Discover Trends over Time Using Standard Fiscal Calendar Options** — DMO 리포트를 fiscal week/month/year/quarter로 group·sort·filter.
- **Easily Categorize Data Cloud Records with Bucket Columns** — DMO 리포트에서 bucket column(numeric/picklist/text).
- **Perform Calculations Using Functions and Formulas** — date·numeric 컬럼에 함수 적용(summary·row-level formula).

지원 함수 목록(verbatim):

```text
// 소스 발췌 (PDF 라인 6548~6595) — Data Cloud reports 지원 함수
Date and Time: ADDMONTHS, DATE, DATEVALUE, DATETIMEVALUE, DAY, DAYOFYEAR,
  FORMATDURATION, FROMUNIXTIME, HOUR, ISOWEEK, ISOYEAR, MILLISECOND, MINUTE,
  MONTH, NOW, SECOND, TIMENOW, TIMEVALUE, TODAY, UNIXTIMESTAMP, WEEKDAY, YEAR
Logical: AND, BLANKVALUE, CASE, IF, ISBLANK, ISNULL, ISNUMBER, NOT, NULLVALUE, OR
Math: ABS, ACOS, ASIN, ATAN, ATAN2, CEILING, COS, EXP, FLOOR, LN, LOG, MAX,
  MCEILING, MFLOOR, MIN, MOD, PI, ROUND, SIN, SQRT, TAN, TRUNC
```

### CRM Analytics — Experience, Visualizations, Data Integration

| 기능 | 등급 | 설명 |
|---|---|---|
| **Create More Efficient Queries with Semi-Joins and Anti-Joins** | **GA** | 단일 SAQL 쿼리에서 join statement + join_type specifier로 semi-join/anti-join 생성. |
| **Append Data Faster with Incremental Uploads** | **GA** | external data API로 CSV 증분 로드. mode를 incremental로 설정. |
| **Connect to Amazon Athena** | **GA** | Amazon Athena remote connection으로 Data Manager 동기화. AWS security credentials를 advanced properties에. |
| **Connect to Databricks** | **GA** | Databricks connector remote connection(personal access token, server, HTTPPath, database). |
| **Embed CRM Analytics Dashboards in LWR Sites** | **Beta** | LWR site에 CRM Analytics Dashboard 컴포넌트. Developer/Enterprise/Performance, Experience Cloud 라이선스 필요. |
| **Get More Functionality with the New Dashboard Lightning Web Component** | **Beta** | 네이티브 CRM Analytics Dashboard LWC로 Lightning Experience 페이지 임베드. |
| **Get Improved Dashboard Performance with Better Caching** | 변경 | 대시보드 쿼리 결과 캐싱(기본). Setup → Analytics → Settings → Disable dashboard query caching으로 해제. |
| **Download Metadata from Lenses and Widgets** | 변경 | lens/widget 데이터를 metadata 포함 Excel로 다운로드. Share → Download 탭. |
| **Visualize Hierarchies and Flatten Transformations with Preview in the Recipe Editor** | 변경 | aggregate node·flatten transform 결과 미리보기. |
| **Control Your Data Prep Concurrency Allocation** | 변경 | dataflow concurrency를 recipe에 할당(3/0, 2/1, 1/2 조합). CRM Analytics Plus 라이선스 + Admin permission set. |
| **Audit Details of Running and Canceled Data Prep Jobs** | 변경 | job 시작/취소 시각·실행자 표시. |
| **Get More Usage Information in Data Manager** | 변경 | Data Manager Usage 페이지에 external upload 수, 24h rolling dataflow·recipe 실행 수, 월간 recipe row 출력 수. |
| **Trigger Recipes to Run When an External Connection Syncs or a CSV Uploads** | 변경 | event-based recipe schedule에서 multiple event 선택. |
| **Experience Better Recipe Error Messaging and Reliability** | 변경 | recipe 실패 시 자동 리소스 증가·재시작. |

Semi-Join/Anti-Join SAQL 예제(verbatim):

```saql
account = load "accounts";
opp = load "opportunities";
opp = group opp by accountId;
opp = foreach opp generate accountId, count() as count;
opp = filter opp by count > 10;
q = join account by (id) semi, opp by (accountId)
```

```saql
account = load "accounts";
opp = load "opportunities";
q = join account by (id) anti, opp by (accountId)
```

### Tableau

- **Embed Tableau Pulse Data in Lightning Pages** — Tableau Pulse LWC를 Lightning App/Home/Record 페이지에. Tableau Cloud. Setup → Tableau Embedding 활성화 + token-based SSO. **Note: Tableau host mapping 기본 share 설정이 Public Read Only라 Health Check 점수에 영향 가능.**
- **Tableau Release Notes / Marketing Cloud Intelligence** — 별도 release notes 포인터(Tableau Cloud·Desktop·Prep·Server, MC Intelligence Help Map).

---

## Commerce (B2B · D2C · OMS · Payments)

### Salesforce B2B and D2C Commerce

| 기능 | 등급 | 설명 |
|---|---|---|
| **Bring Products to Customers with AI-Powered Search** | **GA** | Einstein semantic search(NLP로 synonym·오타·alternative spelling 처리, "couch"↔"sofa"). B2B/D2C — Enterprise/Unlimited/Developer. Commerce Einstein + storefront activity tracking 활성화 필요. *(Einstein 기반이나 핵심 GA라 포함)* |
| **Use Store Setup Tasks to Start Selling Fast** | 변경 | 화면의 setup task로 selling channel 설정. |
| **Easily Set Up Guest Access** | 변경 | guest access 1-click 설정(guest user profile 자동 생성). B2C는 필수, B2B는 선택. Person Accounts 선행 필요. |
| **Specify Locale Settings During Store Creation** | 변경 | store 생성 시 default language/currency/ship-to country 선택. |
| **Assign a CMS Public Channel to a Store** | 변경 | enhanced LWR site의 store에 할당된 public channel 변경. |
| **Collect Tax Globally with Salesforce Tax** | **Pilot** | 글로벌 payment 세금 계산·징수·보고(static tax table 불필요). |
| **Offer and Manage Subscriptions in Your B2B and D2C Store** | **Beta** | Subscription Management 통합으로 virtual·digital 구독 판매. 새 Product Set 컴포넌트. **Subscription Management는 Commerce 라이선스 미포함(별도 구매).** |
| **Improve Page Performance with Displayable Product Fields** | **Beta** | search/product/cart/checkout 페이지에 displayable product field 설정. |
| **Set Up Self-Registration for B2B Stores** | 변경 | 통합 self-registration. profile, account record type, permission set group, **최대 20 buyer group** 정의. Spring '24 이후 생성 store에 포함. |
| **Easily Select an Inventory Service for Your Commerce Store** | 변경 | inventory service provider(Omnichannel Inventory 또는 custom) 선택. |
| **Reduce Shipping Costs and Integration Times with Native Shipping** | 변경 | Salesforce native shipping(free/flat/price-based rate, custom shipping zone). Apex 설정 + Shipping Calculation 탭. |
| **Update Product Categories in Bulk with a Category Import** | 변경 | CSV import로 category path·description·SEO URL slug 일괄 추가·업데이트. |
| **Analyze Commerce Metrics with the Business Overview Dashboard** | 변경 | Commerce Analytics 신규 Business Overview Dashboard(평균 주문가, 전환율 등). |
| **Welcome Business Accounts to D2C Commerce** | 변경 | D2C에서 business account 등록(Self-Registration + Business Account record type). |
| **Cart Calculate API Enabled for New Webstores** | 변경 | Cart Calculate API(Commerce Extensions framework)가 모든 신규 store에서 기본 활성. LWR template 권장, Aura template 비호환. |
| **Customize Promotions with Conditional Rules / Set Maximum Coupon Redemptions** | 변경 | promotional rule로 복합 할인, coupon redemption 한도(All Buyers / per Buyer). |
| **Automatically Style a Store to Match Your Brand** | 변경 | 기존 site URL 제공 시 store를 브랜드에 맞게 디자인. |
| **Let Customers Know When There Are No Search Results** | 변경 | LWR template에 No Results Layout / Loading State 컴포넌트. |

### Commerce Search and SEO

- **Search Stores with Automatic SKU Detection**(Pilot) — Commerce Search가 Einstein으로 검색어가 SKU인지 판별, Product SKU·Product Code field만 검색. 단일/복수 SKU(공백 구분). 기존 `sku:`/`SKU:` prefix도 지원.
- **Improve Search Results with Product Image Structured Data** — product image expression으로 meta tag 동적 업데이트(SEO). 예: `"image": "{!Record.ProductMedia.DefaultImage}"`.

### Commerce Reorder Portal

- **Customize Emails in a Reorder Portal Invitation Cadence** — Invite Contact to Reorder Portal cadence 이메일 커스터마이즈(Einstein 초안). Enterprise/Unlimited/Developer.
- **Display Purchased Products on the Reorder Portal Home Page** — 새 Purchased Products 컴포넌트.
- **Invite Contacts to a Reorder Portal with a Quick Cadence** — quick cadence(1단계)로 이메일 초대.

### Salesforce Order Management

| 기능 | 등급 | 설명 |
|---|---|---|
| **Simplify Order Creation with the High Scale Order Integration** | 변경 | **High Scale for B2CE Integration** 활성화로 simplified Order Creation API를 High Scale Order API와 독립적으로 사용. Order Management/B2B/D2C — Unlimited/Developer/Enterprise. Setup → Order Management → High Scale Orders → Use High Scale. |
| **Provide Exchanges for Fulfilled Items** | 변경 | 새 **exchange API**로 return·exchange 단일 flow. 추가 자금/환불 필요 여부 계산. Order Management — Unlimited/Developer/Enterprise. |
| **Provide More Product Information with the Order Management Product Selector Component** | 변경 | order product summary에 quantity·price 등 field 추가. Flow Builder flow 컴포넌트. |
| **Order Management Flow Type Field Has a New Name** | 변경(명칭) | Order Management의 **Flow Type field → Transaction Type**(Flow Builder 용어 정렬). |
| **Place an Order on Behalf Of with Guest Checkout** | 변경 | guest customer용 person account 생성 후 Order on Behalf Of flow. |

- **Omnichannel Inventory** — Inventory Lookup 탭에서 shipping disabled 여부 확인(Disable Shipping 컬럼).

### Salesforce Payments

| 기능 | 등급 | 설명 |
|---|---|---|
| **Make Pay Now Transactions Easier with Express Payments** | **GA** | Pay Now express payment(digital wallet: **Apple Pay, Google Pay, Paypal, Venmo**). Pay Now — Enterprise/Unlimited. Experience Builder Pay 페이지 → Pay Now 컴포넌트 → Enable express payments. |
| **Expand Pay Now Checkout with Subscriptions and Tax and Shipping Options** | 변경 | 새 **Checkout with Order** payment link → 새 Pay Now Checkout 페이지(physical/digital product, tax·shipping). 구독 product line item 추가 가능. |
| **Simplify Pay Now Purchases with One-Click Checkout** | 변경 | passwordless login one-click checkout, 등록·로그인. |
| **Extend How Customers Manage Payment Methods from My Account** | 변경 | 등록 customer가 payment method 추가 가능(이전엔 default 선택·삭제만). Saved Payment Methods 컴포넌트에 Add 버튼. |

> PDF 원문(Express Payments): "Accepted express payment methods include digital wallets, such as Apple Pay, Google Pay, Paypal, and Venmo."

---

## Experience Cloud

### Components in Experience Builder

| 기능 | 등급 | 설명 |
|---|---|---|
| **Create Component Variations in Enhanced LWR Sites** | **GA** | Expression-Based Component Variations GA. 동일 컴포넌트의 여러 version + visibility rule. variation은 visibility rule 추가 전까지 draft. priority order. enhanced LWR — Enterprise/Performance/Unlimited/Developer. Component Variations dropdown → New Component Variation. |
| **Use the New Tab Layout Component for Smoother Performance on Your Aura Site** | 변경 | 새 Tab Layout 컴포넌트(기존 Tabs 대체 권장, 성능 향상). custom CSS 재설정 필요. |
| **Refine Your LWR Site Layout with Improved Spacing Controls** | 변경 | section별 spacing(component·column 간격, max content width). |
| **Supercharge Productivity for Sales Partners from Experience Cloud Sites** | 변경 | Enhanced List View 컴포넌트(contacts/leads/opportunity pipeline). PRM license 필요. |

### Aura and LWR Sites

| 기능 | 등급 | 설명 |
|---|---|---|
| **Track Site Updates in the New Change History Panel in Experience Builder**(IdeaExchange Delivered) | 변경 | Aura/LWR site publication·domain 변경 chronological 기록. |
| **Translate Your LWR Site into Even More Languages** | 변경 | **LWR site 최대 40개 언어(이전 25개).** |
| **Improve SEO with Custom URLs for Custom Objects** | **Beta** | enhanced LWR site custom object 페이지에 SEO-friendly URL slug(record ID 대체). 이전엔 Product·Catalog만. |
| **Integrate with Data Cloud to Harness Site Data** | **Beta** | enhanced LWR site를 Data Cloud와 통합(user profile·engagement·diagnostics 수집). |
| **Configure Search Results Layouts with Search Manager** | **Beta** | Search Manager로 search config. |

### Site Performance & Developer Productivity

- **Boost LWR Site Performance and Scalability with Experience Delivery**(Pilot) — LWR site 호스팅 신규 인프라(subsecond page load, 보안·SEO). Enterprise/Performance/Unlimited. **Developer Edition 미지원.**
- **Update References to Your Force.com Site URLs** — legacy `*.force.com` 도메인 redirection이 2024년 종료 → URL 참조 업데이트.
- **Dynamically Redirect Users to Sites Hosted on External Domains** — LWR dynamic URL redirect(source·target query parameter).
- **Try a Modernized Record Experience in Aura Sites**(sandbox 전용) — Create Record Form, Record Banner, Record Detail 업그레이드 컴포넌트.
- **Record Access Is Secure by Default after Enabling Digital Experiences**(변경·보안 기본값) — **2024년 2월 8일 이후 생성된 org**에서 digital experiences 활성화 시, Roles and Internal Subordinates group(sharing rule·기타 기능으로 공유된)으로 공유된 레코드가 **내부 사용자에게만 접근 유지**(외부 site 사용자에게 자동 공유 안 됨). **2024년 2월 8일 이전 생성 org**은 기존 동작 유지 — 내부 공유 레코드가 외부 site 사용자에게 자동 공유(Roles, Internal and Portal Subordinates)되므로, **Convert External User Access wizard**로 외부 사용자 접근을 제거해 보안화해야 함. Where: Aura/LWR/Visualforce sites — Enterprise/Performance/Unlimited/Developer.

---

## Field Service

> Einstein 항목(Pre-Work Brief, Einstein Copilot on FS Mobile)은 Einstein spoke 위임 — 1줄: FS Mobile에 Einstein Copilot GA(2024-05-06), Einstein for Field Service Mobile add-on 라이선스.

### Field Service Operations — Asset Management

| 기능 | 등급 | 설명 |
|---|---|---|
| **Create Richly Formatted Service Documents with Document Builder** | **GA** | Document Builder GA. Template Builder drag-drop, dynamic template, translate, signature, image embed, PDF preview(desktop·FS mobile), custom LWC, spanning field(polymorphic lookup). Enterprise/Unlimited/Developer + FS managed package. Setup → Field Service Settings → Enable Document Builder. **Salesforce admin만 builder 접근.** |
| **Save Database Storage with Optimized Storage Space for Asset Attributes** | 변경 | asset attribute record가 **0.25 KB(이전 2 KB).** |
| **Build In Accurate Maintenance Lead Time with Asset Attributes** | 변경 | asset attribute로 maintenance lead time. Recordset Filter Criteria → Add lead time to usage-based work rules. |
| **Accelerate Your Field Service Implementation with Data Cloud** | 변경 | Field Service Data Kit(asset, work order, warrant, service contract, resource, product service campaign). |
| **Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules** | **RU** | Maintenance Plan의 Frequency·Frequency Type field 은퇴. **When: Winter '25 enforce.** |

### Field Service Resource Management — Enhanced Scheduling and Optimization

| 기능 | 등급 | 설명 |
|---|---|---|
| **Get Additional Guidance When Transitioning to Enhanced Scheduling and Optimization** | 변경 | readiness check + Salesforce Help 링크. Fix Schedule Overlaps flow(Beta), Service Resource Availability work rule 차이 추가. |
| **Configure Scheduled Jobs Easily with Enhanced Optimization APIs** | 변경 | 새 **FSL.ScheduleJobsApi** Apex class로 territory group·scheduling policy 수정. |
| **Limit Your Mobile Worker's Cumulative Workload Throughout the Day** | 변경 | custom field의 **Count work rule**이 scheduled appointment 순서 고려(하루 중 어느 시점도 한도 초과 방지). 이전엔 full day horizon. |
| **Fix Schedule Overlaps Easily with an Automated Scheduling Flow** | **Beta** | appointment 종료 지연 overlap 해소 자동 flow. |
| **Evaluate Service Appointment Candidates Efficiently by Prioritizing Skill Preferences** | 변경 | 새 **Skill Preference service objective**(skill type 기반, 예: English/Spanish 중 Spanish 선호). |

### Field Service Resource Management (기타) & Mobile

- **Work Capacity** — work capacity limit 완화(service일 근처/당일), daily limit 변경, work capacity record 공유.
- **Get Notified When Automated Bundling Fails** — 실패한 Automated Bundling optimization 이메일.
- **Identify Configuration Issues More Efficiently with the Redesigned Health Check User Interface** — 재설계된 Health Check UI(status filter).
- **Experience Better Performance with Service Appointment List Filtering**(Beta) — dispatcher console service appointment list 필터링.
- **Control User Access with Operating Hours Sharing** — Operating Hours sharing(OWD, Sharing Rules, Guest Sharing).
- **View More Shifts on the Schedule with a Minimalist Design** — white space 클릭으로 shift 추가.
- **Plan for the Discontinuation of Mobile Extension Toolkit**(Beta) / **Switch the App Language to Support Hebrew**(Beta).

---

## Industries

> Industries는 대부분 정식 GA/Beta 태그 없이 plain 제목으로 제공된다(공식 등급 태그가 있는 것만 표기). 신규 객체·API명은 verbatim.

### Automotive Cloud

- **Service Excellence for Automotive Finance** — captive finance(loan/lease, balance, transaction, asset, title). Account·Financial Account console, ARC graph·timeline·record alert·interest tag.
- **Fleet Management Enhancements** — external user가 fleet·fleet asset·fleet participant tracking. Setup에서 Fleet Management 활성(이전엔 Metadata API만).
- **Automatically Populate Key Fields for Opportunity Products and Preferred Sellers** — lead line/opportunity line item, preferred seller field 자동 매핑.
- **Replace Deprecated Fields on Vehicle and Vehicle Definition with New Fields** — 사용자 정의 가능한 새 picklist field.
- **New and Updated Objects and Fields / Connect REST APIs for Automotive Cloud**.

### Consumer Goods Cloud

- **Automate the Transfer of TPM Promotions to Retail Promotions** — TPM에서 계획 → RE 실행. promotion·tactic type 선택, customizable hook.
- **Get Sales Baseline Prediction Data with MuleSoft Direct** — CRM Analytics 예측 baseline을 Hyperforce에 통합.
- **Integrate Additional Business Components from ERP Systems with MuleSoft Accelerator** — list price·COGS, POS order. Customer Role, Customer Relationship, Customer Org Unit, Org Unit, Customer Manager.
- **Extend UI and Business Logic for Advanced Orders** — Advanced Order LWC extensibility.
- **Get Started Quickly with Consumer Goods Cloud Offline Mobile App** / **Use the Enhanced Visual Studio Code Based Modeler CLI Commands**.
- **Trade Promotion Management** — business year 정의 유연화, sandbox clone/refresh 시 CG Processing Services 데이터 유지, P&L/customer business plan export.

### Financial Services Cloud

- **Financial Plans and Goals** — FlexCard: **FSCFinancialPlanDetails**(target date·value·priority·feasibility), **FSCFinancialAccountDetails**, **FinancialGoalsFundingHeader**, **FinancialAccountGoal**. FSC Extension + OmniStudio User permission set.
- **Data Cloud for Financial Services Cloud** — Calculate Customer Insights using Data Cloud(data kit, DMO stream·mapping·transform·calculated insight).
- **Residential Loan Application** — mortgage object 공유 방식 변경 setting.
- **Einstein Activity Capture for Financial Services Cloud** — non-Salesforce event sync, interaction participant record 자동 생성.
- **Transaction Dispute Management** — merchant 정보 enrich, business rule deflect, merchant alert, self-service portal 분쟁 제기.
- **Service Process Automation** — wealth management용 prebuilt service process.
- **Streamline Integration Callouts with Integration Orchestration**(Pilot) — identity verification·AML screening callout 상태 검토, integration plan 생성·실행. Professional/Enterprise/Unlimited.
- **New and Changed FSC Object Fields / Apex / Connect API / Invocable Action**.

Mulesoft Wealth Management REST API(verbatim):

```text
// 소스 발췌 (PDF 라인 17532~17560) — Mulesoft Wealth Management REST APIs
Add beneficiary:        POST   /InvestmentAccounts/Initiate
Update beneficiary:     PATCH  /InvestmentAccounts/Update
Delete beneficiary:     DELETE /InvestmentAccounts/Delete
Update customer:        PATCH  /customers/{customerId}
Process ACATS:          POST   /InvestmentAccounts/{accountId}/acats
Retrieve linked accts:  GET    /InvestmentAccounts/{accountId}/Retrieve
Process RMD:            POST   /InvestmentAccounts/{accountId}/RMD
Retrieve payment:       GET    /InvestmentAccounts/{accountId}/Payments/Retrieve
Process payments:       POST   /InvestmentAccounts/{accountId}/Payments/Initiate
Cancel payments:        PATCH  /InvestmentAccounts/{accountId}/Payments/Update
```

### Health Cloud

- **Advanced Therapy Management Enhancements** — Electronic Signatures framework로 Chain of Custody event, work type step lead time override(country·site), site-to-site lead time override.
- **Assessments Enhancements** — 새 **Assessment History**·**Assessment Questions** 컴포넌트, prefilled response, View mode, Experience Cloud authenticated user.
- **Electronic Signatures** — signature trail로 record update/workflow step 전자 서명.
- **Home Health Enhancements** — group visit·dependent visit·subsequent recurring visit reschedule, medication administration.
- **Integrated Care Management Enhancements** — 새 OmniScript flow로 care plan의 problem·goal·intervention 업데이트.
- **Interoperability for Health** — 새 **FHIR API for documentReference**, MuleSoft Direct for Health Cloud 3개 integration(Patient Summary - Blue Button 2.0, Bulk Clinical Data Sync, QHIN (Kno2) Integration APIs).
- **Medication Review and Medication Management** — custom flow medication therapy review. **RxNorm Interaction API deprecation → drug-to-drug interaction 식별 미지원.**
- **Provider Network Management / Provider Search Enhancements** — **최대 40개 custom field.**
- **Referral Management Enhancements** — guest user digital referral channel, 새 Referral Management 앱.
- **CRM Analytics Enhancements for Health Cloud** — Referral Analytics dashboard.
- **Update Sharing Settings for the Operating Hours Object** — `enableDepriveSoqlAccessGuestUserOrgPref`(IndustriesSettings Metadata API).

### Loyalty Management

- **Global Promotions Management** — guided flow로 pricing·loyalty promotion. **9개 promotion template.** Marketing Cloud journey 통합.
  - **Offer Members Real-Time Discounts on Their Purchases** — cart/cart item 할인. **Get Eligible Promotion** business API.
  - **Get a Jump-Start on Adding Promotion Rules with Promotion Templates** — **8개 pricing template + 1개 loyalty member accrual event template.**
- **Make Your Loyalty Program Engaging and Fun with Games** — Spin the Wheel, Scratchcard(points·voucher·raffle·custom reward). validity period, win probability, budget limit.
- **Do More with the Refreshed Quick Promotion Guided Flow** — granular eligibility, Accrual Events template, launch email.
- **Increase Your Efficiency with a Simplified Loyalty Program Page** — Promotions 컴포넌트, Promotion Console 앱.
- **Optimize Your Liability Forecast with Multivariate Forecasting** — Liability Forecast dashboard multi-select(voucher liability, NQP: accrued/redeemed/expired).
- **Reward Members for Scanning Receipts** — OCR receipt scanning 앱 통합(iOS/Android).
- **Improve Dining Experience With Loyalty Management Restaurant POS** — MuleSoft로 Restaurant POS 통합.
- **Gamification Mobile SDK** — game·game reward를 mobile app에 통합(**iOS 15.0+, Android 8.0+**). MyNTORewards sample app.
- **Connect REST API**(verbatim): Update promotion `PUT /global-promotions-management/promotions/${promotionId}`(request: Unified Promotions Input / response: Unified Promotions Output). Transaction Journal Process Result 응답에 새 field `badgesAssigned`, `gamesAssigned`.

### Manufacturing Cloud

- **Manage Sales Agreement Data Easily and Swiftly** — enhanced view 성능·접근성·usability, keyboard 편집.
- **Build a Product Portfolio That Best Reflects Your Company's Offerings** — Product Catalog Management(attribute·classification 기반 taxonomy).
- **Inventory Visibility Foundations for Manufacturing Cloud** — 새 inventory management object(inventory stock, transfer, return, shipment).
- **Quickly Import Production Forecasts from CSV Files** — program·variant forecast CSV → component production forecast(insert/update/upsert).
- **Fleet Management Enhancements** — Experience Cloud fleet·fleet asset·fleet participant tracking.

### Public Sector Solutions

- **Accelerate Complaint Intake for Judicial and Investigative Cases** — public portal guided flow(civil complaint, participant, regulatory code, digital evidence).
- **Efficiently Manage Service Requests** — public portal guided flow + Defer a Case Proceeding flow.
- **Easily Add Participants to a Case Proceeding** — custom action(OmniScript로 case participant 재사용).
- **Ensure Accurate Eligibility Determinations When Circumstances Change** — Experience Cloud guided flow, disbursement 조정.
- **Get Insights into Caseworker Productivity and Community Impact** — Caseworker Productivity analytics.
- **Use Filters to Aggregate a Subset of Records** — record aggregation filter.
- **Administer Social Insurance Benefits to Constituents** — Benefit Management data model(enroll, claim, documentation, contribution).
- **Create Business Authorization Applications with Out-of-the-Box Components** — OmniStudio business license application.
- **Control Provider Access to Benefit Assignment Records on Experience Cloud Sites** — manual share만 접근.

### Education Cloud (Salesforce for Education)

- **Use Education Cloud to Support Mentoring** / **Support Learners with Mentoring Programs** / **Create Mentoring Program Enrollment Portals** — Mentoring 앱(program, benefit 할당, assessment matching), mentor·mentee portal.
- **Create Mentoring Records Using Education Public API** — **Industries Education Public API**(Benefit Assignment에 Provider lookup, Contact Contact Relationship·Party Role Relationship record).
- **Customize the Application Experience / Create an Applicant Portal for Parents, Guardians, and Agents** — OmniStudio application template, 제3자 application 제출.
- **Leverage AI to Discover Skills for Courses and Programs**(Pilot) — Einstein Skills Generator.
- **Use the Education Portal Template** — Education Applicant Portal template → **Education Portal template**(applicant·student·alumni).
- **Create Action Plans by Using Action Plan Templates in Action Center** — 새 **Action Center** LWC.
- **Update OmniStudio Designer Settings** — Spring '24부터 모든 Education Cloud OmniStudio 기능이 **standard runtime.**
- **Migrate Managed Packages to Education Cloud** — Education Cloud Data Migration Kit.

### Nonprofit Cloud (Salesforce for Nonprofits)

- **Quickly Build an Integration with Fundraising** — **Business Process API**(donor match/create, recurring donation·installment, payment data, campaign·source code·designation, single payload).
- **Split Gift Transaction Amount Attribution Across Multiple Campaigns** / **Create Outreach Source Code URLs**(UTM parameter) / **Track Payment Data**.
- **Import Data with CSV Data Management for Industries** — gift batch CSV import.
- **Find and Fix Potential Duplicates in Nonprofit Success Pack**(Managed Package) — 새 **NPSP Potential Duplicates** LWC → NPSP Contact Merge.
- **은퇴: Elevate Retirement** — Elevate family 은퇴(**renew 종료 2023-10-01, 비활성화 2024-10-01 이후**). **foundationConnect Retirement**(renew 종료 2025-01-31, 비활성화 2026-01-31).

### 기타 Industries

- **Net Zero Cloud** — Author Disclosure Reports in Microsoft 365 Word(add-in), Categorize Emissions into CO2·CH4·N2O(CDP 정렬), Net Zero Cloud Admin permission set, Net Zero Cloud Starter SKU.
- **Rebate Management** — special pricing term·accrual rate **소수점 4자리(이전 2자리)**, incentive claim·transaction CSV import.
- **Referral Marketing** — 단일 referral program에 brand별 promotion, **Process Referral Events** action(Flow Builder), likelihood scoring model.
- **포인터(별도 release notes):** Communications Cloud, Energy and Utilities Cloud, Insurance, Media Cloud, Salesforce Contracts.
- **Industries Common Features**(여러 산업 공통): AI Accelerator, Action Launcher, Actionable Segmentation, Batch Management, Business Rules Engine(executable expression set template, Decision Explainer), Context Service, Criteria-Based Search and Filter, CSV Data Management for Industries, Data Processing Engine(Data Cloud writeback, Data Spaces), Discovery Framework, Grantmaking, Intelligent Document/Form Reader, KPI Bar, **List Builder for Data Cloud Segment(최대 50,000 member record 알림)**, Outcome Management, Reminders, Timeline.

---

## Marketing Cloud

### Marketing Cloud Growth — **GA in Spring '24**

> Salesforce platform + reimagined core object 기반 marketer 전용 experience. **When: 모든 MC Growth 기능 2024-02-20 시작.** Salesforce Enterprise·Unlimited + Marketing Cloud Growth edition.

| 기능 | 설명 |
|---|---|
| **Kick-Start Campaign Creation with Preset Options** | reimagined campaign object(draft content preconfigured 또는 Einstein co-create). single email / email series / sign-up form. checklist-style layout. 각 campaign에 flow coupled. **Marketing Manager permission set 포함.** Campaigns 탭. |
| **Build Audiences and Track Success with Unified Data** | Data Cloud 기반. Data Cloud segment 수동 또는 Einstein co-create. Segments 탭. |
| **Market Responsibly with Consent Management Tools** | prebuilt privacy 도구. marketing channel·communication subscription consent. built-in preference page(email·SMS opt-in). Consent 탭 bulk import. Preference Manager. |
| **Generate Campaigns and Segments with Einstein AI** | Einstein generative AI campaign brief·segment·email subject·preheader·body. *(Einstein 기반이나 MC Growth GA 핵심)* |
| **Create Content in a Consistent Editing Experience** | Salesforce CMS 기반 email·landing page·form. **SMS는 add-on(Salesforce Message Credits - SMS).** drag-drop, preview, publishing 일관. **brand center(beta).** |
| **Other Features in Marketing Cloud Growth** | **Einstein Send Time Optimization**(Setup → Einstein for Marketing). **Einstein Metrics Guard**(bot click·open 필터). **Engagement metrics backed by Data Cloud reporting**(email·SMS dashboard 기본 제공). |

### Marketing Cloud Account Engagement

- **Generate Content with Einstein in Account Engagement** — Einstein Assistant(form, landing page, email subject·body). *(Einstein — 1줄)*
- **Import Account Engagement Email Data into Data Cloud** — Account Engagement connector(Data Cloud) + email engagement data stream.
- **Use the Latest Email Editing Experience for Account Engagement** — 새 email builder(Edit in Builder).
- **Update Your Account Engagement Sending Domains to Prepare for 2024 Email Platform Changes** — Gmail·Yahoo 2024 spam 변경 대비, **verified DKIM record.**
- **은퇴: The Twitter Connector Has Been Retired** — X(Twitter) API 변경으로 **2023-10-31부터 미제공.**
- **Account Engagement API: New and Changed Items** — **Account Engagement API version 5** 신규·업데이트 object.

- **Marketing Cloud Engagement** — 별도 Marketing Cloud Engagement Release Notes 포인터.

---

## Revenue Lifecycle Management (RLM)

> Revenue Lifecycle Management은 Salesforce platform 기반 신규 end-to-end revenue 솔루션. revenue·CRM process 통합, one-time sale·subscription service, business process 자동화. **When: 2024-02-13 시작.** Spring '24의 핵심 신규 제품군이다.

> PDF 원문: "Revenue Lifecycle Management is available starting on February 13, 2024."

### Product Catalog Management — **GA**

unified interface로 product portfolio 생성·관리. attribute, product classification, simple·bundled product, rule. **Where: Lightning Experience — Developer/Enterprise/Unlimited(RLM enabled).**

- **Increase Product Findability Through a Visual Product Catalog** — hierarchical catalog category·subcategory.
- **Reuse Attributes to Define Similar Products At Scale** — attribute 1회 생성 → attribute category로 그룹화 → 다수 product 재사용.
- **Accelerate Product Creation Through Product Classifications** — product classification template(attribute 상속).
- **Effortlessly Design Products Of Varying Levels Of Complexity** — simple·hierarchical product, group cardinality·product cardinality·component relationship, level 2부터 component exclude·override.
- **Model Products to Represent Industry-Specific Product Types** — product specification type, product2 record type, API로 query.
- **Define Business Rules For Product and Product Category Eligibility and Availability** — **Qualification Rules**(user location·account attribute 기반).
- **Define Business Rules For Product Validation and Compatibility** — **Configuration Rules**(validation·exclusion·require rule).
- **Customize the Product Catalog Management Home Page with Lightning Web Components**.
- **Use APIs to Programmatically Access Your Product Data** — Product Catalog Management API.
- 신규: New and Changed Objects, **New Tooling API Objects**, New Metadata Types, New Connect REST API Resources.

Scratch org features(verbatim):

```text
// 소스 발췌 (PDF 라인 23349) — scratch org definition file에 추가
ProductCatalogManagementAddOn          (read-write)
ProductCatalogManagementViewerAddOn    (read)
ProductCatalogManagementPCAddOn        (Partner Community)
```

### Salesforce Pricing — **GA**

price adjustment schedule, discount, pricing element, pricing procedure.

- **Manage Pricing Policies and Processes Easily by Using Salesforce Pricing** — predefined object, pricing recipe, pricing procedure.
- **Perform Complex Price Calculations Using a Recipe** — pricing recipe(lookup table). **org당 active recipe 1개.**
  > PDF 원문: "Each org can only have one active recipe at a time."
- **Track Your Products by Using Price Books and Price Book Entries** — standard·custom price book.
- **Control Pricing with Adjustment Schedules** — quantity·attribute·bundle 기반 할인.
- **View Your Pricing Data Your Way** / **View Product Discounts on a Single Calendar**(Pricing Discount Calendar) / **Build Context Definitions to Use Data Efficiently**.
- **Calculate Discounts Using Defined Pricing Elements** — Pricing Procedure Builder.
- **Set a Product's Price on the Object Record Page** — pricing action button(Quote, Order, Contract, Sales Agreement, Case, Opportunity, Work Order).
- **Make Better Pricing Decisions Using Price Waterfall**.
- **View Pricing Process Logs with Price Waterfall Persistence (Pilot)** — 저장된 pricing process log를 조회. Price Waterfall Persistence로 stored pricing log 확인. Setup → Quick Find "Salesforce Pricing" → Salesforce Pricing에서 process log 조회. **Where: Lightning Experience — Developer/Enterprise/Unlimited(RLM enabled).** (위 비-Pilot Price Waterfall과는 별개 기능)

### Product Configurator — **GA**

- **Configure Your Products More Easily** — 실시간 pricing, option group·attribute·product bundle customizable layout, multi-level bundle, headless API, configuration rule(cardinality check, validation, message). preview runtime.
- **Where: Lightning Experience — Developer/Enterprise/Unlimited(Industries clouds, RLM + Product Configurator enabled).**
- 신규 Connect REST API(verbatim): Retrieve/update product configuration `POST /connect/cpq/configurator/actions/configure`(request: Configurator Input / response: Configuration Details).

### Quote and Order Capture — **GA**

initial·amendment·renewal sale. subscription lifecycle, quote·order→contract·asset·amendment·renewal. omnichannel(PRM, Commerce Cloud).

- **Product Discovery** — catalog·category·product browse, custom pricing·qualification procedure.
- **Capture Quotes and Orders** — quote에서 order 생성 또는 account에서 직접.
- **Configure Products To Accurately Price Quotes and Orders** — Salesforce Product Configurator 통합.
- **Increase Revenues With Partner Communities** — partner community Omni-Channel selling, approval process.
- 신규: New and Changed Objects, New Connect REST API Resources, New Metadata Types, New Invocable Actions. **QuoteLineDetail** object 사용.
- **CommerceOrders Namespace** — integrated pricing·configuration·validation으로 order 생성. 새 class·method·enum.
- **PlaceQuote Namespace** — pricing preference·configuration option으로 quote 생성·업데이트. 새 class·method·enum.

### Asset Lifecycle — **GA**

- **See the Customer Assets That Need Your Attention** — **Asset Viewer**(account record page, asset 검색·filter·sort). **Where: Sales Cloud·Service Cloud — Enterprise/Unlimited/Developer + RLM 라이선스. Aura/LWR/Visualforce sites.** Customize Application permission으로 추가.
- **Visualize Customer Assets in Partner Communities** — **Asset State Period Chart**·**Asset Summary** 컴포넌트(quantity·monthly recurring revenue), Experience Builder.
- **Amend, Renew, or Cancel Assets** — flow + invocable action.
- **Create a Contract from a Quote or Order** — custom flow configuration.
- **Automatically Create an Asset Contract Relation Using Asset Creation Flows** — **Order to Asset API**·**Order Product to Asset API**로 Asset Contract Relationship 생성.

### Salesforce CPQ & Subscription Management (RLM 인접)

- **Generate Permissions for the Integration User**(Salesforce CPQ) — Winter '23 integration user(short-lived access token). Installed Packages → Salesforce CPQ → Configure → Pricing and Calculation → Generate Integration Permissions.
- **Enhanced Error Handling for Billing Schedules**(Subscription Management) — `commerce/invoicing/invoices/collection/actions/generate` API, error status 시 Next Billing Date·Next Charge From Date 미업데이트.
- **Ensure Valid States When Using Single Invoice Generation API** — invoice post 전 billing period item 생성 보장. 실패 시 billing schedule = Error.
- **Ensure Users Can Access OrderToAsset and OrderItemToAsset Platform Events** — **CreateAssetOrderEvent**·**CreateAssetOrderDtlEvent** platform event 구독자는 user permission(Read access) 필요. OrderToAsset·OrderItemToAsset API는 permission 없이 호출 가능하나 event notification 미수신.

---

## OmniStudio

> Spring '24부터 OmniStudio Standard(Managed Package Runtime 비활성)가 OmniStudio for Vlocity 기능 지원(FlexCard XML publish option, component 사용 추적, Google Maps 주소, SOBO, 모든 version migration).

| 기능 | 설명 |
|---|---|
| **Automatic Upgrades for Managed Packages** | Spring '24부터 OmniStudio managed package가 자동 업그레이드 process(Summer·Winter·Spring 3회/년). sandbox preview early access. **Where: Spring '24부터 자동 업그레이드 필수.** |
| **Display FlexCards with More Options** | publish 시 Lightning App Builder·Experience Builder·Salesforce mobile app 선택. standard runtime. Editor 탭(Publish Options). |
| **Improve Workflows with Usage Data** | **OmniAnalytics**(OmniScript·FlexCard 상호작용 데이터, Google Analytics 등). standard runtime. **Spring '24 미지원: guest user access.** |
| **Migrate All Versions of OmniStudio Components** | Vlocity→Standard 마이그레이션 시 모든 version(active 외 older·in-progress 포함). OmniStudio Migration Tool. |
| **Save Time Activating Components After You Change Runtimes** | managed package→standard runtime 전환 시 active component 유지. |
| **Send Documents on Behalf of Others (SOBO)** | DocuSign 등 통합, 1명 authenticated user가 타인 대신 document 전송. |
| **Use OmniOut on Mobile Devices** | OmniScript·FlexCard를 iOS·Android에서 실행. **미지원(현재): toast message, record page·Experience site login 열기, link email.** |
| **OmniStudio Minor Releases** | Spring '24~Summer '24 bug fix·minor update·known issue. |

Vlocity vs OmniStudio OmniAnalytics 비교(verbatim — row=feature, col=runtime):

| Feature | Vlocity OmniAnalytics | OmniStudio OmniAnalytics |
|---|---|---|
| Managed Package Runtime | Enabled | Disabled |
| Granting Access | OmniStudio Admin permission set, OmniAnalytics Apex classes in user profile | OmniStudio Admin permission set for internal analytics |
| Enabling OmniAnalytics | Custom Settings | OmniAnalytics Settings |
| Data Storage | Custom Platform Event or Object | Standard Platform Event or Decision Explainer |

---

## Salesforce CMS

| 기능 | 설명 |
|---|---|
| **Schedule Content to Publish and Unpublish in Enhanced CMS Workspaces** | content publication schedule(지정 날짜·시간 publish·unpublish). 즉시/예약 workflow 통합. Enterprise/Performance/Unlimited/Developer. content detail page → Publish/Unpublish. Publication Calendar 탭·Publication Activity 탭. |
| **Preview Content in Enhanced CMS Workspaces** | enhanced LWR site에서 news·image·document content preview(publish 전후, desktop·mobile view mode). |
| **Work Smarter with Upgrades to CMS Workflows** | enhanced CMS workspace running workflow cancel(Workflows 컴포넌트 → Cancel) 후 새 workflow 시작. |

---

## Slack Integrations

- **Salesforce for Slack Integrations** — 메인 Spring '24 release notes에 GA/Beta 개별 항목 없음. 별도 **Salesforce for Slack Integrations Release Notes** 포인터.
- 단, Analytics 섹션의 **Access Report and Dashboard Subscriptions with Slack Slash Commands**(위 Analytics 표 참조)는 Slack 관련 항목으로 본 릴리즈에 존재.

---

## Work.com

| 기능 | 설명 |
|---|---|
| **Get Easy Access to Natural Language Processing Insights** | **Natural Language Processing Insights** card(AWS NLP service key phrase·entity). Enterprise/Unlimited/Developer(Feedback Management, NLP Insights enabled). Setup → Industries AI Setup → Entity extraction·Keyphrase extraction use case configuration. |
| **Invocable Action to Initiate Natural Language Processing Services** | invocable action **initiateNaturalLangProcessing**(Keyphrase·Entity extraction custom flow). |
| **Work.com** (포인터) | 별도 **Work.com Release Notes** 참조. |

---

## 신규 객체·API·핵심 날짜 (빠른 참조)

- **신규 객체:** ForecastingGroup, ForecastingGroupItem, OmniSupervisorConfigTab, QuoteLineDetail, CreateAssetOrderEvent, CreateAssetOrderDtlEvent
- **신규 필드:** ForecastingGroupId, ForecastingGroupItemId, HasAdjustments·HasOwnerAdjustments(ForecastingType), isOmniPinnedViewEnabled, badgesAssigned·gamesAssigned
- **신규 Apex:** FSL.ScheduleJobsApi, initiateNaturalLangProcessing(invocable), CommerceOrders namespace, PlaceQuote namespace
- **신규 REST API:** `/connect/cpq/configurator/actions/configure`, `/global-promotions-management/promotions/${promotionId}`, FHIR documentReference API, Mulesoft Wealth Management(10개 resource)
- **핵심 날짜:** RLM GA 2024-02-13 · MC Growth 2024-02-20 · CRM Analytics mobile Save View 2024-02-12 주 · Data Graphs 신규 2023-12-13·기존 2024-01-04 · Inbox Mobile 은퇴 2024-02-01 · Meeting Studio 은퇴 Spring '24 · Salesforce for Outlook 은퇴 December 2027 · standard WhatsApp upgrade 마감 2025-07-30 · email threading RU enforce Spring '25 · Maintenance Plan Frequency RU enforce Winter '25

---

## 관련 노트

- [[Spring '24]] — 릴리즈 허브(Apex·LWC·Flow·Admin·Security·Architecture·Einstein·Release Updates 전체)
- [[Release MOC]] — 릴리즈 노트 섹션 목차
- [[Spring '24/Einstein]] — AI/Einstein 도메인 상세(Copilot, Prompt Builder, Einstein Studio, Einstein for Sales/Service). Sales/Service Einstein 액션의 기능 맥락
- [[Spring '24/Release Updates]] — 필수 적용(RU) 항목 상세(강제 시점 맵)
