---
tags: [release, winter_25, industries, health-cloud, financial-services, public-sector, manufacturing, automotive, communications]
api_version: v62.0
release_date: 2024-10
created: 2026-06-16
source: salesforce_winter25_release_notes.pdf (Salesforce Winter '25 Release Notes, Tier 2)
aliases: [Winter '25 Industries, 윈터25 산업 클라우드, Health Cloud, Financial Services Cloud, Public Sector, Automotive, Communications, Energy and Utilities, Manufacturing, Net Zero, Nonprofits, Education, Life Sciences, Loyalty Management]
---

# Winter '25 — Industries (산업 클라우드)

> Salesforce Winter '25 (API v62.0) 릴리즈의 산업별 클라우드(Automotive · Communications · Consumer Goods · Energy & Utilities · FSC · Health · Life Sciences · Loyalty · Manufacturing · Media · Net Zero · Public Sector · Education · Nonprofit · Insurance 등) 신규·변경 기능 전수.

---

## 개요

이 노트는 Winter '25 릴리즈의 **산업별(Industries) 클라우드 기능**을 다룬다. 코어 클라우드(Sales/Service/Commerce/Analytics/Data Cloud 등)는 [[Winter '25/Clouds]], 다음 릴리즈의 산업 기능은 [[Spring '25/Industries]]를 참조한다.

> **상태 라벨링 원칙:** Industries release notes는 대부분 명시적 GA/Beta/Pilot 라벨 없이 "now available"/단순 변경으로 기술한다. 아래에서는 PDF에 라벨이 명시된 항목만 GA/Beta/Pilot로 표기하고, 라벨 없는 신규 feature는 "신규"로 기술한다. Einstein 기반이라도 산업 핵심 feature는 "(Einstein)" 표기 후 포함한다. (false GA 라벨 금지)

### Industries 전역 (산업 공통)
- **Get New Foundational Features for Industries Users** (신규) — Salesforce Foundations for Industries (Marketing/Service/Commerce/Data Cloud). 2024-11-11. Ent/Unlimited/Einstein 1 Sales/Einstein 1 Service.
- **Accounting Subledger — Reduce Processing Time for Accounting Subledger** (신규) — Skip Reversal Logic, Account Field Mapping. Ent/Unlimited/Dev.
- **Asset Service Lifecycle Management** (신규) — Inventory Search and Transfer (Criteria-Based Search and Filter, Product Inventory Searchable Field), Service Parts Return, Product Service Campaign (multi-item work order), Work Order Estimation, Improve Technician Experience with Timesheet Automation and Labor Cost Association (Business Rules Engine, labor union rules).

---

## Automotive Cloud
- **Digital Lending for Automotive (Generally Available)** — vehicle loan/lease origination 단일 플랫폼. self-intake guided flow(Experience Cloud), Agent Assisted Application Management app, underwriter console, dealer Experience Cloud site.
  - **Offer Comprehensive Vehicle Lending Solutions to Financial Institutions** (하위 entry).
- **Connected Vehicle Enhancements** (신규) — 추가 usage-based entitlements, flow-based actionable event orchestrations (telematics provider events).
- **Einstein for Automotive Cloud** (신규, Einstein) — Einstein Summary component(Sales Agreement/Asset/Vehicle/Account).
- **Vehicle Inventory Search and Transfer Enhancements** (신규) — Experience Cloud(partner/customer) 지원, in-app 알림.
- **Easily Search for and Transfer Spare Parts Across Locations** (신규) — Product Inventory Searchable Field. Ent/Unlimited/Dev where Automotive Cloud + Criteria-Based Search and Filter. Automotive Foundation for Experience Cloud + Criteria-Based Search and Filter for Experience Cloud permission sets.
- **Manage Service Parts Returns for Faults and Replacements** (신규) — Field Service mobile app, offline sync. Service Part Return Management permission set.
- **Optimize Labour Cost Tracking with Automated Timesheets** (신규) — Timesheets app, labor union rules. Labor Cost Optimization permission set.
- **Efficiently Manage Work Orders and Quotes** (신규) — Work Order Estimation. Work Order Estimation permission set.

---

## Communications Cloud
- **Enterprise Sales Management** (신규) — Optimize Resource Usage by Easily Moving Assets (disconnect/connect dates, serviceability/address validation), Modify In-Progress Orders by Creating Quotes (supplemental/follow-on quote, Point of No Return), 대형 cart 할인 적용.
- **Einstein Generative AI Solutions for Enterprise Sales Management** (신규, Einstein) — Einstein Quick Quote (budgetary quote, needs analysis, product recommendations).
- **Communications Cloud Agent Console** (신규) — billing dispute rule-driven process.
- **Asset Service Lifecycle Management** (신규) — Inventory Search/Transfer, Product Service Campaign, Service Parts Return, Work Order Estimation, Timesheet Automation/Labor Cost.
- **Data Cloud Features for Communications Cloud** (신규) — 신규 DMO, real-time data streaming.
- **Connected Assets** (신규) — flow 기반 actionable event orchestration (critical events). 추가 entitlements.

---

## Consumer Goods Cloud
- **Retail Execution** (신규) — Streamline Delivery with Van Sales Delivery Execution (truck inventory, cash invoice), Experience Enhanced Performance with Penny Perfect Pricing Batch V2 (V1 유지 가능), Boost Mobile App Productivity with Bluetooth Keyboards.
- **Trade Promotion Management** (신규) — custom month/quarter real-time reports, customized derive/copy promotions workflow(KAM), 수동 조정 custom month/quarter KPI 복사, Consumer Goods Managed package 신규 permission sets.
- **APIs** (신규) — Add or Update Measures with Null Values, Copy Promotion (월/분기), Derive and Copy Promotion (Metadata Wizard, Business Object API).
- **Use Orchestration Entitlements Based on Execution Procedure Type** (신규) — 월 300 actionable event orchestration(usage type Manufacturing) per connected asset (기존 150); 150 expression set-based + 150 flow-based. Asset Connected Services Monthly Per Unit Entitlement add-on.

---

## Energy and Utilities Cloud
- **Drive Customer Support with Agent Console** (신규) — 360 view, identity 검증, usage stats, billing 통합.
- **Minimize Customer Service Calls with Self-Service Portal** (신규) — bill pay, autopay, usage, service address, Clean Energy Programs.
- **Summarize Customer Calls with Einstein Work Summaries** (신규, Einstein).
- **Improve Technician Experience with Timesheet Automation and Labor Cost Association** (신규).
- **Calculate Energy Savings and Rebates with Context Service** (신규) — Business Rules Engine, Clean Energy Program Management.
- **Monitor Connected Assets with Data Cloud Visualization** (신규) — Flexcards, EV charger metrics.
- **Product Catalog Management for Energy and Utilities** (신규) — Salesforce platform.
- **Store your labor cost optimization data** (신규 objects) — 17 신규 필드 (Work Order Line Item, Service Resource, Work Type, Time Sheet Entry, Service Resource Cost Rule, Pay Grade, Time Sheet, Time Sheet Entry Item).

---

## Financial Services Cloud (FSC)

**Pilot/Beta (명시):**
- **Boost Operational Efficiency with AI-powered Einstein Autofill (Pilot)** — 실시간 call/chat → form 추천.
- **Resolve Banking Inquiries Faster with Einstein Copilot (Beta)** — Einstein for FSC.
- **Einstein Copilot for Fee Reversal Service Process (Beta)**.

**신규/변경:**
- **Business Relationship Plan** (신규) — AI-powered summary, siloed data, client plan. Invocable: `createFieldGnrnPromptTmplResp`.
- **Complaints Management** (신규) — Auto Complaint Summarization (Einstein).
- **Digital Lending** (신규) — guest user access, loan calculator, Product Configurator, Data Mappers.
- **Digital Lending—India** (신규) — integration templates, 자동 loan origination.
- **Service Process Automation** (신규) — prebuilt service process templates.
- **Transaction Dispute Management** (신규) — dynamic grouping by reason code/subcode, Mastercom® 통합.
- **Wealth Management** (신규) — AI-powered personalized insights.
- **Data Cloud for FSC** (신규) — holistic financial picture.
- **Financial Summary Rollup** (신규) — Data Processing Engine templates, managed package 불필요.
- **Strengthen Your Business and Customer Relationships by Using CRM Analytics** (신규) — Wealth Management/Retail Banking 신규 app templates.
- **Watch FSC Videos** (신규).
- **Common Features — Stage Management** (신규) — Metadata API migration.
- **Metadata** — `IndustriesSettings`: `enableFinancialDealCallReportCmpPref`, `enableFinancialDealCallReportPref` (신규); `enableEinsteinDocReaderEnabled` 제거 (→ `enableEinsteinDocReaderMappings`).

---

## Health Cloud
- **Einstein for Health Cloud** (신규, Einstein) — prompt templates, summary/outreach email.
- **Home Health Enhancements** (신규) — patient self-service scheduling, guided setup.
- **Intelligent Appointment Management Enhancements** (신규) — clinics/rooms/equipment, providers/assets, same time slot multi-appointment, non-US postal code, Health Cloud Troubleshooter.
- **Integrated Care Management Enhancements** (신규) — MCG assessment 저장·재개, care plan recommendation, Experience site care plan component, MCG default.
- **Participant Management Enhancements** (신규) — Einstein Candidate Matching (AI), site coordinator metrics/tasks/events, guided setup.
- **Patient Program Outcome Management** (신규) — outcome/indicator data model, Einstein generative AI summary.
- **Patient Support Programs Console** (신규).
- **Roster File Mapping, NPPES integration** (신규) — provider auto-fill, simplified guided setup.
- **Invocable** — `scheduleRecurringHomeVisit` (`visitSourceId` 신규).
- **Metadata** — `IndustriesSettings`: `enableMedicationManagementEnabled`, `enableMedRecSetting`.

---

## Life Sciences Cloud
- **Advanced Therapy Management Enhancements** (신규) — Add Ad Hoc Tasks to a Therapy Step (Care Program Enrollee, action plan template, mandatory/optional), Review and Update Task Assignees.
- **Commercial Excellence Enhancements** (신규) — guided flow: sales agreement↔quote 변환.
- **Financial Assistance Program for Life Sciences** (신규) — out-of-pocket 약값 지원.
- **Participant Management Enhancements** (신규) — Einstein Candidate Matching (AI), guided setup.
- **Patient Program Outcome Management** (신규) — Einstein generative AI summary.
- **Patient Support Programs Console** (신규) — 신규 console app.
- **Pharmacy Benefits Verification Enhancements** (신규) — generative AI summary/call script, member plan from enrollee, benefit 필드, reverify guided flow.
- **New/Changed Objects, New Invocable Actions, Changed Metadata Types** (신규).

---

## Manufacturing Cloud
- **Einstein for Manufacturing Cloud** (신규, Einstein) — Einstein Summary component: Sales Agreement/Asset/Account.
- **Sales Agreement** (신규) — decimal quantity, planned quantity 수동/자동, product display name, setup 안내.
- **Easily Create Part Return Requests from a Warranty Claim or Work Order** (신규).
- **Close Deals Quickly by Automating Quote and Sales Agreement Conversion** (신규).
- **Search For and Transfer Products and Parts Across Inventory Locations** (신규) — serialized/non-serialized, Product Inventory Searchable Field.
- **Swiftly Generate Work Orders for Product Service Campaigns** (신규).
- **Consider Decimal Values When Calculating Forecasts** (신규) — DPE 신규 node, Advanced Account Forecasting.
- **Get Improved Mobile and Reports Support for Manufacturing Cloud Objects** (신규).
- **New Connect API: Warranty To Supplier Claims** (신규) — warranty claim 계층 clone.
- **Common Features — Business Rules Engine** (신규) — context-aware subexpressions, expression set version save, CSV decision table.

---

## Media Cloud
- **Advertising Sales Management** (신규):
  - **Boost Ad Impact With Related Media Product Bundles** — auto-add rules, digital/TV/print/radio.
  - **Customize the Spot Calendar's Style and Display** — 아래 구성요소를 사용해 Spot Calendar의 스타일과 표시를 커스터마이징한다(PDF에서 발췌한 구성요소명).

```
// 구조 예시 — Spot Calendar 커스터마이징 구성요소 (PDF 발췌, 동작 코드 아님)
Apex Class:            MediaAdSalesCustomRadioHandler
Integration Procedure: BulkCheckAvailability
LWC:                   sfiAdsCustomRadioPaginationHandler
Flexcard (업데이트):    sfiAdsRadioParentGrid
```
  - **Intelligent Document Reader for RFP ingestion** (teaser).

---

## Net Zero Cloud

**Beta (명시):**
- **Enhance Scope 3 Emissions Calculations with Einstein Generative AI (Beta)**.
- **Generate First Draft of ESG Disclosure Automatically (Beta)** — disclosure document → draft, Microsoft 365 Word 저장.

**신규/변경:**
- **Allowlist the Domains that You Trust for Disclosures** (신규) — Disclosure and Compliance Hub Connector, Session Settings.
- **Collect and Manage ESG Content in Centralized Information Library** (신규) — snippets, Data Links, topics, approval.
- **Boost efficiency: Einstein revise disclosure** (신규) — summarize/elaborate/rephrase.
- **Maintain questions/responses year over year** (신규) — Word → Assessment Framework.
- **New Objects** — `ContentLink`, `ContentSource`, `MaterialityTopicDocClauseSet`, `MaterialityTopicReference`, `InfoLibraryExternalDocument`.

---

## Public Sector Solutions
- **Talent Recruitment Management** (신규) — position management→offer, job seeker site, hiring decision tools.
- **Investigative Case Management** (신규) — case creation→resolution console, complaints/participants/evidence/violations, data-driven insights.
- **Einstein Generative AI for Public Sector Solutions** (신규, Einstein).
- **Speed Up Referral Authorization with Out-of-the-Box Flow** (신규) — Salesforce flow template.
- **Use Omniscripts in Multiple Languages** (신규) — 기존 English만.
- **New/Changed Objects** (recruitment 관련) — `PositionPayGrade`, `RecruitmentContentSection`, `RecruitmentPosting`, `RecruitmentPostingCntntSect`, `RecruitmentRequisition`, `RecruitmentRequisitionLoc`, `RecruitmentRequisitionPtcp`, `VettingEvaluation`; `PreliminaryApplicationRef` 신규 `ApplicantInformation` 필드.

---

## Education Cloud (Salesforce for Education)
- **Unify Your Learner Data with Data Cloud for Education** (신규) — education-specific DMO, LMS/SIS/engagement/ERP.
- **Build Stronger Alumni Relationships with Einstein and Data Cloud for Education** (신규, Einstein) — Alumni Metrics: experience/communication/volunteerism/philanthropy.
- **Enroll Admitted Students into Learning Programs** (신규) — Enroll Applicant action, Enroll Applicant Bulk flow.
- **Monitor Learners with Watchlist Tracking** (신규).
- **Get Learner Feedback with Pulse Checks** (신규) — recurring/one-time, learner portal, score graphs.
- **Summarize Advising Cases by Using Einstein** (신규, Einstein).
- **추가 (teaser)** — degree program plan templates, side-by-side program 비교, learner portal academic progress, recommendation flow, Inquiry Management, learning catalog REST/Apex APIs.

---

## Nonprofit Cloud (Salesforce for Nonprofits)

**Beta (명시) — Einstein Generative AI for Nonprofit Cloud:**
- **Quickly Create a Summary of a Program and Its Benefits with Einstein (Beta)**.
- **Catch Up On Notes by Using Einstein (Beta)**.
- **Generate a Specialized Version of a Grant Application for Board Review (Beta)**.
- **Create a Funding Award Summary with Einstein (Beta)**.

**신규/변경:**
- **Provider Management Is Now Available for Nonprofit Cloud** (신규) — service provider details, facilities/specialties, benefit↔specialty mapping. Provider Management Access permission set.
- **Fundraising** (신규) — outreach source codes bulk, person account address sync, donor briefs, pledge revenue, external ID gift entry, tax receipt batch, soft credits, account page gift entry, Nonprofit Intelligence for Fundraising.
- **Nonprofit Cloud for Grantmaking** (신규) — form framework, progress reports, single-page application review.
- **Salesforce for Nonprofits Managed Packages** (retirement) — Elevate, foundationConnect retiring.
- **Common Features** (신규) — CSV Data Management, Data Processing Engine.

---

## Loyalty Management

**Beta (명시):**
- **Turn on Einstein AI for Loyalty Management (Beta)**.
- **Get a Snapshot of Your Company's Loyalty Program in an Instant (Beta)** — Einstein summary.
- **Get a Rundown of a Promotion's Offers (Beta)** — Einstein.

**신규/변경:**
- **Create Programs Easily With Simplified Loyalty Program Setup** (신규) — currencies/tier groups/tiers/benefits/activities.
- **Promotions** (신규) — product bundle 기반, context definition, actionable lists, Data Cloud data graphs, promotion rule deploy, corporate member eligible promotions.
- **Control Liability with Currency Subtypes** (신규) — redemption↔accrual link, fixed-type non-qualifying currency subtype, cost 연결, liability reports.
- **Vouchers** (신규) — reserve voucher, time-based voucher, contact 제공, Experience Cloud.
- **Make the Most of the Revamped Loyalty Program Home Page** (신규).
- **New/Changed Objects, New Metadata Types, Changed Invocable Actions, New/Changed Connect REST APIs** (신규) — Eligible Promotions `ruleLibraryApiName`; Member Vouchers `effectiveDateTime`/`expirationDateTime`/`hasTimeBasedVoucher`; Redeem Vouchers `action`/`reservedValue`/`reservationKey`, response `status`/`reservationKey`/`reservedValue`.

---

## Referral Marketing
- **Easily View Configurations of a Referral Promotion** (신규) — read-only 접근, 비활성화 불필요.
- **Accelerate Customer Segment Verification for Promotions** (신규) — prebuilt Data Cloud data graphs.
- **Person account no longer required** (신규).
- **`referredPartyJournalSubtype` 필드** (신규).
- **New Connect REST API: Referral Advocate Profile** (신규).

---

## Insurance (포인터)
- frontline agents/back-office/customers 연결, policy admin/benefit admin/claims/billing. **개별 GA feature 본문 없음.** 외부 링크: "Insurance Winter '25 Release Notes".

---

## Industries 공통 기능 (Common Features)

> Industries 제품들이 공유하는 기능. modular business rule 생성, CSV 파일로 대용량 데이터 업로드 등. (PDF 본문: 18169 intro / 24744–25880 detail)

### Action Plans
- **Customize the Display of Task Field Columns in Action Plan and Action Plan Templates** (신규) — action plan·action plan template task list view에 컬럼 추가/제거. 이전엔 default 컬럼만 표시. 최대 8개 필드 선택 가능. Prof/Ent/Unlimited where FSC enabled.

### AI Accelerator and Scoring Framework
- **Get Customized Prediction Insights By Using AI Accelerator** (신규, Einstein) — AI Accelerator가 binary classification·descriptive text use case의 prediction score 지원. Lightning App Builder로 sector별 AI deployment 커스터마이징.
- **Scoring Framework (Generally Available)** (Einstein) — 코드 없이 propensity model 구축·배포. template configuration으로 CRM Analytics app·Data Cloud app·Einstein Discovery model·recipe 생성.
  - **Get Predictions for Your Data Cloud Apps** — Scoring Framework가 Data Cloud 기반 app 지원. data space·DMO 선택해 학습·scoring.
  - **Improve Workflow Efficiency by Removing Record Counting** — record counting 완료 대기 없이 Data Checker 작업 저장·계속.
  - **Simplify Customization in the Scoring Framework** — 신규 text input component로 parameter 정의·간소화.

### Business Rules Engine
- **Simplify Business Rules with Context-Aware Subexpressions** (신규) — context-aware expression set·list group에 context-aware subexpression 추가. context definition의 tag를 list variable로 사용 → input/output variable 불필요.
- **Simulate Expression Sets Comprehensively with All Available Context Mappings** (신규) — context definition의 임의 context mapping으로 expression set version 시뮬레이션(기존 default mapping만). Expression Set Builder의 Advanced Input Mode.
- **Save and Manage Expression Set Versions Effortlessly** (신규) — expression set version을 새 expression set 또는 기존 set의 새 version으로 저장(Save As). 전체 set clone 불필요.
- **Migrate Expression Set Versions Efficiently by Using Ranks** (신규) — source org에서 expression set version에 rank 부여 → migration 후 자동으로 올바른 version 선택. target org 수동 활성화 불필요.
- **Configure Complex Business Rules Easily by Using String Functions** (신규) — expression set calculation step에서 FIND·TRIM·UPPER·VALUE·REVERSE string function 사용.
- **Create Decision Tables More Intuitively by Using the Unified User Interface** (신규) — guided flow(source data·input/output condition·filter criteria)·industry별 ready-to-use template.
- **Manage the Volume and Complexity of Your Decision Tables with the Decision Table Type Options** (신규) — medium volume(대용량·저복잡, optional 컬럼 AND/OR 조합, 복수 Salesforce 객체) / low volume(복잡 조건, OR로 임의 컬럼).
- **Expedite Efficiency by Using CSV Files to Create Decision Tables** (신규) — Salesforce 객체 대신 CSV 파일로 decision table 생성. CSV는 medium volume decision table만 가능. 비활성화 없이 수정.
- **Narrow Your Source Conditions by Applying Source Filters in Decision Tables** (신규) — source object row가 많을 때 prelogic으로 필터. CSV 기반 decision table에는 source filter 미지원.
- **Improve Decision-Making with the Newly Supported Objects in Medium Volume Decision Tables** (신규) — medium volume decision table에 Account·Lead·Contact·Opportunity·Case 사용 가능.
- **Increase Efficiency with Faster Refresh for Decision Table Data in Flows** (신규) — Decision Table Refresh Action invocable action의 `InvocableRefreshDecisionTable` parameter로 변경 데이터(추가·삭제 row) 갱신.
- **Support for Rule Engine Designer Role to Refresh Decision Tables** (신규) — Rule Engine Designer role 사용자가 Decision Table refresh 가능.
- **Changed Business Rules Engine Objects** (신규) — `DecisionTblFileImportData` 객체의 `InputData`·`OutputData` 필드로 decision table input/output CSV 데이터 저장.

### Context Service
- **Conveniently Activate and Deactivate Definitions, and Other Context Service Enhancements** (신규) — detail page의 Activate·Deactivate 버튼, custom attribute description, extended context definition auto-upgrade(실패 시 Sync 버튼).
- **Easily Generate Input Mapping for Blank Attributes** (신규) — Regenerate All(모든/선택 node), Retain and Generate(blank attribute만).
- **New Objects in Context Service** (신규) — `ContextNodeAttrDictionary`(ContextNodeMapping↔ContextDictionary junction), `ContextDefinitionSync`(custom↔standard definition sync 정보).
- **Use Data Model Objects for Mapping** (신규) — definition mapping 시 DMO 선택해 데이터 조회. Salesforce Objects 탭에 표시.
- **New Connect REST API Resources** (신규) — `/connect/context-definition-interfaces`(GET, Context Definition Interface Metadata List), `/connect/context-definition-interfaces/{name}`(GET, Context Definition Interface).

### CSV Data Management
- **Import CSV Data by Using Various Supported Delimiters** (신규) — comma-delimited 변환 없이 CSV 업로드. 지원 delimiter: Comma·Pipe·Caret·Backquote·Semicolon·Tab. Basic CSV Data Import permission set, 단일 객체.
- **Perform Complex Calculations on CSV Data and Import into Salesforce Objects** (신규) — advanced: 단일 import로 하나 이상의 Salesforce 객체에 대용량 CSV import + 복잡한 transformation(컬럼 join·계산). Advanced CSV Data Import permission set, DPE definition 사용.

### Data Processing Engine
- **Simplify Transformation of Large Data by Using CSV Files (Pilot)** — Data Cloud runtime에서 CSV 파일을 data source로 업로드 → Data Lake Object/Salesforce Object에 writeback. 실패 record는 Monitor Workflow Services에서 확인. 2024-10-04. Prof/Ent/Unlimited where DPE enabled.
- **Write to Related Objects in Writeback Nodes in Data Cloud** (신규) — Data Cloud runtime이 related object writeback node 지원. related field 매핑으로 lookup/master-detail 필드 채움(insert·update·upsert). CRM Analytics runtime과 정렬.
- **Automatically Save your Recipes and Output Records** (신규) — debug mode 실행 시 recipe·output record를 7일간 autosave.
- **Get Notified When You Exceed Data Pipelines Usage Limits** (신규) — Data Pipelines limit 80% 초과 시 notification tray 알림.
- **Metadata API / Changed Objects** (신규) — `BatchCalcJobWritebackObject`의 `isExistingTarget`, `BatchCalcJobDefinition`의 `definitionRunMode`(v62.0), `BatchJob`의 `isDebugOn`·`isDebugRecipeDeleted`, `BatchCalcJobDefinition` `ProcessType`의 `ProductCatalogManagement` 값.

### Decision Table
- **Metadata API** (신규) — `DecisionTable` metadata type의 `doesConsiderNullValue`·`refreshStatus`·`refreshFailureReason` 필드(v62.0).
- **Changed Invocable Actions** (신규) — `refreshDecisionTable` action의 `isIncremental` input 필드(incremental refresh).
- **New Connect REST API Resources** (신규) — `/connect/business-rules/decision-table/{decisionTableId}/data` GET(paginated, Decision Table Rows List)·POST(CSV row update).

### Development Environments
- **Upgrade Data Storage in Developer and Developer Pro Sandboxes** (신규) — Developer sandbox 200MB→400MB, Developer Pro 1GB→2GB. Prof/Ent/Perf/Unlimited/Database.com. Manage Dev Sandboxes/Manage Sandboxes 권한.

### Einstein Bot Templates
- **Resolve Cases Efficiently with Case Management Bot Templates** (신규, Einstein) — Case Management enhanced bot template(case 생성·종료·status 확인, human agent 전환, preloaded intent data). Starter/Prof/Ent/Unlimited. Industry Service Excellence add-on.

### Engagement
- **Changed Object** (신규) — `EngagementInteraction` 객체의 신규 `RecordType` 필드(record type으로 business process·page layout·picklist 결정).

### Grantmaking
- **View Progress Reports for Updates on Applications** (신규) — grantee progress report 생성·관리·게시·검토. Grantmaking portal. Grantmaking for Experience Cloud permission set.
- **Use Flow-Based Forms in Grantmaking** (신규) — grant application·progress report·reviewer feedback용 flow 기반 form(enhanced form framework).
- **Review Submitted Applications from a Single Page** (신규) — Application Review Workspace에서 단일 페이지로 검토·피드백·평점.
- **New and Changed Objects in Grantmaking** (신규) — Application Review 신규 필드(`IsRequired`·`ApplicationStageDefinition`·`DisplayOrder`·`IsAssignedToMe`), `FundingAwardRqmtSection` 객체(`OwnerId` 필드), Individual Application Task `Description` 필드.

### Industries Configure, Price, Quote (CPQ)
- **Boost Efficiency with Industries CPQ in LWC Interface** (신규) — Industries CPQ를 LWC interface로 전환. 향상된 product configurator·cart, 모바일 태블릿 CPQ 작업. CME managed package.
- **Automate Asset Management with Query Driven Asset Disconnect Scheduler** (신규) — Query Driven Asset Disconnect Scheduler cron job으로 asset 비동기 disconnect.
- **Easily Apply Discounts to an Entire Cart with Large Sets of Quote Line Items** (신규) — GUIDs 활성 시 최대 50,000 quote line item, 비활성 시 100,000. enhanced API로 20,000+ 가격 조정.
- **Get a More Flexible Pricing Solution in CME Managed Package** (신규) — 실시간 가격 업데이트, matrix 기반 UI pricing builder, simulator.
- **Move to Salesforce Contracts in CME Managed Package** (신규) — Industries CLM 대비 업그레이드(AI insight·collaborative redlining). OmniStudio Standard Objects + Standard Runtime 필요.
- **Reverse Cardinality of Relies On Product Instances** (신규) — Relies On product relationship에 reverse cardinality 정의·runtime 검증, source product instance 최소/최대 수 지정.
- **Relies On with Attribute Propagation** (신규) — Linear Relationship에서 product instance 간 attribute propagation 정의. action: SUM·COPY·REFER.
- **Achieve Real-Time Catalog and Pricelist Updates with Incremental Caching** (신규) — incremental caching으로 standard Cart·Digital Commerce API에 카탈로그·pricelist 변경 라이브 반영.
- **Table Component Deprecated in the AccountBillingDashboard Component** (deprecation) — AccountBillingDashboard에서 Table component 제거.
- **Secure Your Data with Enhanced User Permissions** (신규) — Standard User profile 권한 업데이트(custom object·custom metadata type·custom setting). CME sample permission set에 추가.

### Integration Solutions with MuleSoft Direct
- **Industry Integration Solutions Has a New Name** (rename) — Industry Integration Solutions → MuleSoft, Integrations Setup → MuleSoft Direct. Setup navigation: Integrations > MuleSoft > MuleSoft Direct. 구현에 영향 없음. MuleSoft 라이선스 전 edition.

### List Builder for Data Cloud Segment
- **Changed Objects** (신규) — `ActionableList`의 `SynchronizationOperationType` 필드, `ActionableListMember`의 `InsertOperationOnSync` 필드(Data Cloud segment sync 시 insert 허용 여부).

### Omnistudio Document Generation
- **Improve Document Generation Performance with Timeout Setting** (신규) — time-out setting으로 장기 실행 document generation request 종료(failed 표시). `TerminateDocGenRequestCronJob` scheduled job. CLM Admin permission set. default timeout 6시간.

### Scheduled Reminders
- **Changed Objects in Scheduled Reminders** (신규) — `ReminderDefinition`의 `OccurrenceType`·`RelatedObjectName` 필드, `ReminderDefinitionChannel`의 `MessagingChannelId` 필드.

### Service Process Studio
- **Experience Greater Flexibility in Request Form Creation** (신규) — service process definition에 screen flow request form 추가. Omnistudio Runtime 없으면 Flow Builder로 생성. Industry Service Excellence add-on. 변경 객체: `SvcCatalogItemDependency`의 `ProcessStepName` 필드.

### Stage Management
- **Migrate Stage Management Configurations with Ease** (신규) — Metadata API로 Stage Management configuration을 org 간 패키징·공유·배포. Ent/Unlimited.

---

## 관련 노트
- [[Winter '25]]
- [[Winter '25/Clouds]]
- [[Spring '25/Industries]]
