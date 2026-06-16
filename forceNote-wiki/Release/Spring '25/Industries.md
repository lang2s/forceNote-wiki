---
tags: [release, spring_25, industries, health-cloud, financial-services, public-sector, manufacturing, automotive, communications]
api_version: v63.0
release_date: 2025-02
created: 2026-06-16
source: salesforce_spring25_release_notes.pdf (Salesforce Spring '25 Release Notes, Tier 2)
aliases: [Spring '25 Industries, 스프링25 산업 클라우드, Health Cloud, Financial Services Cloud, Public Sector, Automotive, Communications, Energy and Utilities, Manufacturing, Net Zero, Nonprofits, Education]
---

# Spring '25 — Industries (산업 클라우드)

> Spring '25 릴리즈의 **산업 클라우드(Industries)** 전용 노트. 원본 PDF Industries 섹션(p500–718, 약 9,640줄)이 단일 클라우드 섹션 중 가장 방대해 [[Spring '25]] 본문과 [[Spring '25/Clouds]](일반 클라우드)에서 분리했다. 18개 산업 클라우드 + Industries Common(공통 기능)의 GA / Beta / Pilot / Retirement 항목과 산업별 기능을 전수 정리한다.

---

## 개요 — 산업별 GA / Beta / Pilot 건수

PDF Industries 범위(라인 25217–34855)에서 dedup한 정식 등급 항목:

| 등급 | 건수 | 항목 |
|---|---|---|
| **GA (Generally Available)** | 2 | Trade-In Appraisal Management (Automotive), Channel Revenue Management (Automotive) |
| **Beta** | 2 | Cross-Object Field History (Industries Common), Einstein Autofill (Industries Common) |
| **Pilot** | 7 | Site Management 그룹 1 + 하위 6 (Life Sciences) — 모두 Life Sciences. (Education Student Recruitment Agent는 PDF heading에 (Pilot) 태그가 없어 등급 미표기로 분류) |
| **Release Update** | 0 | Industries 범위 내 해당 없음 |
| **Retirement(명시)** | 7+ | Share Visits, Penny Perfect Pricing V1, Windows Server Modeler, VF DocGen Omniscripts, Document Generation 1.0, foundationConnect, ICU Locale Apex class 제거 2건 |

> 그 외 약 180개 이상의 feature heading은 명시 태그 없는 일반 GA 향상(대부분 "automatically enabled" 또는 add-on / permission set 기반)이다. 아래 산업별 섹션에 전수 기재한다.

| 서브클라우드 | PDF 라인 범위 | 주요 변경 |
|---|---|---|
| Asset Management | 25540–25940 | ASLM + Connected Assets |
| Automotive Cloud | 25941–26640 | **GA**: Trade-In Appraisal, Channel Revenue Mgmt |
| Communications Cloud | 26641–27140 | ESM, Agent Console, Einstein, Comms Cloud Sales |
| Consumer Goods Cloud | 27141–27703 | Retail Execution, TPM, API; **Retirement** 3건 |
| Energy and Utilities Cloud | 27704–27831 | Einstein GenAI, Case mgmt, Timesheets |
| Financial Services Cloud | 27832–29219 | Business Relationship Plan, Digital Lending India, FAMS objects |
| Health Cloud | 28368–29219 | Disease Surveillance, Utilization Mgmt, Connect REST API/objects |
| Insurance and Brokerage | 29219–29796 | Insurance / Brokerage / Managed Package |
| Life Sciences Cloud | 29797–30441 | **Pilot**: Site Management, FAP, Participant Mgmt |
| Loyalty + Global Promotions Mgmt | 30441–30831 | objects / API / invocable action |
| Manufacturing Cloud | 30832–31247 | Revenue Mgmt for Sales Agreements |
| Media Cloud | 31248–31307 | Advertising Sales Mgmt (WideOrbit, Data Cloud) |
| Net Zero Cloud | 31308–31499 | CSRD, IRO objects |
| Public Sector Solutions | 31499–31928 | Data Cloud, Employee Service, Metadata API |
| Referral Marketing | 31928–32119 | WhatsApp, objects, API |
| Salesforce for Education | 32119–32254 | SIS, Agentforce, objects/DMOs |
| Nonprofit Cloud | 32255–32419 | Fundraising/Grantmaking/PCM; foundationConnect retire |
| Vlocity Contract Lifecycle Management | 32419–32524 | DocGen retire / 2.0 |
| Industries Common Features | 32524–34855 | AI Accelerator, BRE, Collections, Context Service, DPE, CPQ, DocGen 등 |

### 산업별 개요 (PDF Industries 인트로 — 전수)

> PDF 원문 인트로(라인 25229–25244)는 Einstein GenAI가 산업 클라우드 전반에 적용됨을 요약한다.

- **Asset Management** — 자산 가동률 최대화, 설치 자산 가치 발굴, 서비스 팀 생산성 향상.
- **Automotive Cloud** — 차량 감정(Trade-In Appraisal), 차량·자산 대출 협상, 채널 매출 관리.
- **Communications Cloud** — Enterprise Sales Management, Agent Console, Einstein, Communications Cloud Sales.
- **Consumer Goods Cloud** — geofencing, VS Code 기반 앱 커스터마이징, Retail Execution, TPM.
- **Energy and Utilities Cloud** — clean energy program 제안, case management, timesheets.
- **Financial Services Cloud** — business relationship plan, portfolio, wealth, India digital lending.
- **Health Cloud** — financial management, scheduling, provider search, disease surveillance.
- **Insurance / Brokerage** — 정책 API/invocable action, producer split, multi-root policy.
- **Life Sciences Cloud** — pharmacy benefits, financial assistance, participant management, site management(Pilot).
- **Loyalty / Global Promotions** — coupon code, milestone promotion.
- **Manufacturing Cloud** — run-rate revenue, sales agreement revenue management.
- **Media Cloud** — advertising sales management.
- **Net Zero Cloud** — CSRD compliance, materiality assessment.
- **Public Sector / Education / Nonprofit** — benefit applicant household overview, Agentforce, fundraising.

> **PDF 구조 주의:** Salesforce Release Notes는 각 feature가 2회(상단 요약 목록 + 본문 Where/Who/When/Why/How 상세) 등장한다. 아래는 각 feature를 1회로 통합하되 상세를 보존했다. "New and Enhanced Common Features for [Cloud]"는 타 섹션으로의 상호참조 불릿이며 신규 기능이 아니다.

---

## Industries Common (공통 기능)

> PDF 라인 32524–34855. 여러 산업 클라우드가 공유하는 기능. **Beta 2건(Cross-Object Field History, Einstein Autofill)**을 여기에서 단일 항목으로 정리한다.

### Cross-Object Field History (Beta)

**Track Changes Across Related Objects with Cross-Object Field History (Beta)** — 관련 객체 전반의 필드 변경을 단일 뷰에서 추적·시각화. **Cross-Object Field History LWC**와 **Object Relationship Graphs builder** 사용.

**Where:** Enterprise / Performance / Unlimited / Developer edition. (Beta Services Terms 적용.)
**How:** Setup → **Cross-Object Field History (Beta)** 검색·선택 → Cross-Object Field History 활성화 → Object Relationship Graphs builder로 추적 대상 설정.

> pdftotext 추출 시 "How:" 레이블이 문장 중간으로 밀려 표기됨("In Setup, How:search for and select...") — 내용은 온전하며 위에서 정상 순서로 재배치했다.

### Einstein Autofill (Beta)

**Boost Efficiency and Customer Satisfaction with Einstein Autofill (Beta)** — call/chat 내용을 분석해 Omniscript form field 값을 제안. Industry Service Excellence add-on 기반.

**Where:** 여러 Industries 클라우드의 Enterprise / Unlimited edition. (Beta Services Terms 적용.)
**Who:** Industry Service Excellence add-on license.
**How:** Omniscript Builder → Einstein Autofill component를 Omniscript step에 드래그 → Properties pane에서 상세 입력.

> PDF에는 위 절차에 대한 **UI 스크린샷이 존재**하나 pdftotext로 추출되지 않았다. 원문의 "(1)(2)(3)"은 스크린샷 콜아웃 번호이며, 본 노트는 단계 설명으로만 사용하고 이미지를 재현하지 않는다.

### AI Accelerator and Scoring Framework
**Improve Prediction Accuracy by Optimizing Training and Scoring Data** — training/scoring data에 별도 filter option 적용. **Who:** Automotive / Communications / Consumer Goods / Education / Energy and Utilities / Financial Services / Health / Manufacturing / Media Clouds + Revenue Intelligence license.

### Action Launcher
**Reduce the Cognitive Load of Contact Center Agents with Recommended Actions** — semantic search 기반 추천. **Where:** Starter / Professional / Enterprise / Unlimited. **Who:** Data Cloud license + Industry Service Excellence, Data Cloud Semantic Search, Einstein Generative Services, Digital Engagement, Service Cloud Voice add-on.

### Action Plans
**Automate Status Update for Action Plans** — Update Action Plan Status flow. **Where:** Professional / Enterprise / Unlimited w/ FSC.

### Business Rules Engine (BRE)
전 feature **Where:** Enterprise / Unlimited / Developer w/ BRE + Context Service (별도 명시 제외):
- **Monitor the Usage of Business Rules Engine Components** — Guardrail Connect API, scheduled flow w/ Apex. (See Also: Guardrails API.)
- **Simplify Calculations By Using Transient Attributes** — **Who:** Context Service Admin + Rule Engine Designer.
- **Easily Activate Expression Set Templates in a Single Step.**
- **Efficiently Configure Context-Based Expression Sets** — output step 표시 불필요.
- **Simplify Datetime Retrieval with the New Date/Time Data Type** — CSV decision table. **Where:** Industries clouds w/ BRE.
- **Monitor CSV Upload Progress for Decision Tables** — CSV Upload Details field.

### Collections
**When: Collections available starting April 2025.** **Where:** 여러 Industries 클라우드.
- **Manage Collection Activities Efficiently with Collections Console App.**
- **Save Time and Effort with a Preconfigured Action Launcher Deployment** (Collection Plan Processes).
- **Create Promise to Pay Agreements Quickly** (Create Promise to Pay flow).
- **Offer Additional Payment Options with Salesforce Pay Now** (Generate and Send Payment Link / Send Reminder with Payment Link flow).
- **Automatically Update Payments Received in Collection Plans and Payment Schedules** (Collections: Update Payment Details flow).
- **Notify Customers of Payment Status Automatically** (Collections: Send Payment Status Email flow). **Where:** + Data Cloud and Marketing Cloud.
- **Automate Case Creation and Closure for Collection Plans** (Create Case for Collection Plan, Close Collection Plan and Associated Cases flow).
- **Determine Collection Plan Segments with Business Rules Engine.**
- **Create a Prioritized List of Collection Plans with Actionable Segmentation.**
- **Maximize Collections with Request Direct Debit Action** (MuleSoft integration).
- **Import Collections Data with CSV File Import.**
- **Streamline Record Creation for Collection Plan and Related Objects with Composite Graph API.**
- **Get Collections Up and Running with Ease** (Collections Guided Setup).
- **New and Changed Objects:** `CollectionPlan`(신규), `CollectionPlanItem`(신규), `CollectionPlanReason`(신규), `PaymentSource`(field on PaymentSchedule), `UsageType`(PaymentSchedule, PaymentScheduleItem), `TotalPaymentsReceived`(PaymentSchedule), `PaymentsReceived`(PaymentScheduleItem), `PaymentLinkId`(PaymentScheduleItem).

### Compliant Data Sharing
**Deactivate Users and Retain Compliant Data Sharing Participant Records** — 신규 setting. **How:** Compliant Data Sharing General Settings → "Delete participant records before deactivating a user" 또는 "Deactivate a user while retaining users' inactive participant records".

### Context Service
전 feature **Where:** Professional / Enterprise / Unlimited / Developer where Context Service enabled:
- **Optimize Performance by Using Reference Definitions.**
- **Simplify Data Population for Nodes and Attributes** (System Information Node, "_s" suffix).
- **Conveniently Store Temporary Changes to Attributes** (Transient).
- **Efficiently Manage Context Instances by Using Context Actions in Flows** (Query Context, Delete Context, Update Context Attributes actions). **Who:** ContextService Admin + ContextService Runtime.
- **Increase Database Efficiency with Polymorphic Fields.**
- **Effortlessly Sync Extended Context Definitions** (Sync Now).
- **Easily Generate Tags for Attributes** (Regenerate All / Retain and Generate).
- **Easily Clone a Context Mapping.**
- **Conveniently Map Context Definitions to Data Model Objects.**
- **New Connect REST API Resources:** PATCH `/connect/contexts/write-through-tags` (new request: Context Write Through Tags Request Input, new response: Context Write Through Tags Response Output).
- **New Object:** `ContextDefinitionReference`.

### Data Processing Engine (DPE)
- **Automate Your Field Mapping with Einstein** (writeback node, Einstein score). **Where:** + Einstein AI.
- **Perform Bulk Transformations with Data Cloud** (append node, hierarchy node). **Where:** Data Cloud w/ DPE.
- **Ensure Data Integrity for the Writeback of Transformed Data** (composite writeback, prewrite hook).
- **Troubleshoot Composite Writeback or CSV File Ingestion** (Download Failed Records).
- **Changed Object:** `FailedRecFile` field on `BatchJobPart` (CSV/JSON/TXT).
- **Tooling API Changed Object:** `ProcessType` field on `BatchCalcJobDefinition` 신규 값 — `ChannelInventoryManagement`, `EmployeeService`, `FundraisingRollups`, `LegalEntityAccountingPeriodClosureAdvanced`, `LifeSciencesCommercialTerritoryAlignment`, `RevenueTransactionManagement`, `SalesAgreement`.
- **Changed Metadata Types:** `ProcessType`(BatchCalcJobDefinition metadata type, 위 7개 값); `isExistingDataset`(BatchCalcJobWritebackObject); `atomicWritebacks`(BatchCalcJobDefinition, API v62.0 도입); `childWritebackObjectField` / `parentWritebackObjectField`(BatchCalcJobAtomicWritebackRelationship subtype).

### Fundraising
전 feature **Where:** Enterprise / Unlimited / Developer where Fundraising enabled; **Who:** FundraisingAccess permission set:
- **Scale Your Fundraising Efforts by Autogenerating Outreach Source Codes.**
- **Understand Donor Impact by Using Soft Credit Rollups.**
- **Automatically Receive Fundraising Rollup Calculation Updates** (DPE definition).
- **Delivered Idea: Customize Summary Displays** (page layouts for summary objects).
- **Enhance Donor Segmentation** (interest tags on outreach source codes).
- **Delivered Idea: Improve Donor Relations and Track the Impact of Gifts** (custom fields in gift entry).
- **Create and Manage Pledges in Bulk** (`/commitments` POST of Business Process API).
- **Customize Sources and Destinations for RFM Scoring.**
- (Education 중복: Streamline Advancement-Specific Data Processing, Drive Comprehensive Prospect Research, Gain Insight Through Generational Cohorts.)
- **New and Changed Objects and Fields — Education Cloud 한정 picklist 전수:**
  - `CapitalPurpose` / `CurrentOperationsPurpose` fields on `GiftDesignation`(Education Cloud).
    - CapitalPurpose picklist: **Property, Buildings and Equipment, Endowment: Income Unrestricted, Endowment: Income Restricted, Loan Funds, Other Capital Purpose.**
    - CurrentOperationsPurpose picklist: **Unrestricted, Academic, Faculty / Staff Compensation, Research, Student Financial Aid, Student Affairs / Life, Athletics, Other Restricted.**
  - `AdvancementType` / `GraduationAchievement` / `GraduationCohort` on `GiftSoftCredit`(Education Cloud) **및** `GiftTransaction`(Education Cloud):
    - AdvancementType picklist: **Alumni, Student, Parent, Faculty or Staff, Private Institution Trustee or Board Member, Public Institution Board Member, Other Individual.**
    - GraduationAchievement picklist: **Secondary Diploma, Associate Degree, Postgraduate Degree, Multiple Degrees, Non-Graduate, Other.**
    - GraduationCohort picklist: **Silent Generation (1928–1945), Baby Boomers (1946–1964), Generation X (1965–1980), Millennials (1981–1996), Generation Z (1997–2012), Generation Alpha (2013–2025).**
    - (추가 라벨 "50+ Years Since Graduation" — GiftSoftCredit / GiftTransaction 컨텍스트.)

### Grantmaking
전 feature **Where:** Enterprise / Performance / Unlimited / Developer where Grantmaking enabled:
- **Delivered Idea: Save Time by Bulk-Assigning Grant Application Reviews.**
- **Streamline Grantmaking Processes with Stage Management.** **When: enable/configure Stage Management starting February 17, 2025.**
- **Enter Multiple Grant Funding Results in Experience Cloud** (Create Indicator Results component).
- **Delivered Idea: Share Funding Disbursements** (sharing: Private / Public Read Only / Public Read-Write).
- **Changed Objects:** `Draft` / updated `Canceled` picklist on ApplicationReview; `Form Framework` picklist for UsageType on ApplicationRenderMethod (Grantmaking 기본); `Form Framework` for Type on ApplicationStageDefinitionMethod; `OwnerId` on FundingDisbursement(Sharing/SharingRules); `EstimatedUtilizationAmount` / `UtilizedAmount` on Budget.

### Group Membership and Households
- **Receive Change Event Notifications for More Objects** (Change Data Capture): Party Relationship Group, Account Account Relation, Contact Contact Relation, Party Role Relation, Record Aggregation Result.
- **Easily Find Contacts for Party Relationship Groups** (email ID + phone).

### Industries Configure, Price, Quote (CPQ)
전 feature **Where:** CME managed package 설치 edition (일부 + Digital Commerce API enabled). 개발자 영향 큼:
- **Detect and Resolve Duplicate Offers During Hierarchical Catalog Compilation.**
- **Configuring and Pricing Bundles for Anonymous User** — 신규 **Preview Offers API** (anonymous B2C, cart 없이 configure/price; UBP/ABP/BRE pricing, waterfall view). Note: Load API Metadata job 실행 필요(Backup → Load API Metadata → Restore; `VlocityAPIMetadata__c` table).
- **Support for Offer Specification** (Standard DC API).
- **Ensure Seamless Promotion Management Across Digital Commerce and Standard CPQ** (interoperability, promotion cache conflict resolution).
- **Process Large Promotion Bundles Seamlessly in Standard Digital Commerce** (200+ line item).
- **Automate Cache Cleanup with Lifecycle Management** (Cache Lifecycle Management Job, Vlocity CMT Administration EPC Jobs).
- **Simplify MACD (Move, Add, Change, Delete) Journeys with Guided Transform Multiplay** (CPQ UI LWC).
- **Integrate Salesforce Pricing with Standard Digital Commerce APIs.**
- **Attribute Validation in PutCartsItems API** (userValues data type 검증, mismatch 시 exception).
- **Sync Product and Promotion Launch Dates Across Time Zones** (locale 기반; Standard DC user 미지원).
- See Also Known Issues: putCartsItems Internal Server Error; Asset To Basket null error; Hybrid Cart Collapsible Hierarchy; OS Runtime Success Message; applyAdjustment Apex CPU time limit.

### Integration Solutions with MuleSoft
- **Save and Reuse Connection Settings When You Enable MuleSoft Integrations.** **Where:** MuleSoft Direct enabled. **Who:** Salesforce Administrator.
- **Integration Solutions with MuleSoft Video** (Get Started with MuleSoft Direct Integrations).

### Omnistudio Document Generation
- **Process More Batch Server-Side Document Generation Requests with Increased Limits:** 시간당 **2,500**(기존 1,000), 일 **60,000**(기존 24,000). Hyperforce 전환.
- **Document Generation 1.0 is Being Retired** (July 31, 2025) — Vlocity CLM과 동일.
- **Enhance Document Generation with Document Generation 2.0** — 동일.
- **Migrate and Sync Custom Fonts** (DocGen Designer permission set).
- **Enrich Server-Side Document Generation with Dynamic Images** (image token in Word/PowerPoint, single/multiple/loop, Omnistudio Data Mapper Transform, Token Data / Token Data Content Document fields, custom class blob).

### Outcome Management
**Create Multiple Indicator Results** — spreadsheet 형식, Create Indicator Results component. **Where:** Enterprise / Unlimited / Developer where Outcome Management enabled.

### Program and Case Management
전 feature **Where:** Enterprise / Performance / Unlimited / Developer:
- **Delivered Idea: Create Custom Care Plan Goals** (where Care Plans enabled).
- **Delivered Idea: Clone Care Plan Templates** (Copy Care Plan Template flow template, where Care Plans enabled).
- **Improve Accuracy and Compliance with Stage Management** (where Program Management enabled). **When: enable/configure Stage Management starting February 17, 2025.**
- **Set a Default Status for Program Enrollments** (기존: 항상 Applied).
- **Updated Objects:** `CustomGoalName` field on GoalAssignment; `IsCustomGoalNameRequired` on GoalDefinition.

### Record Rollup Definitions
전 feature **Where:** 여러 Industries 클라우드:
- **Aggregate Tasks and Events with Record Rollup Definitions** (Task, Event objects).
- **Delete Record Rollup Definitions** (draft status만).
- **Provide More Meaningful Names and Descriptions** (draft / inactive status만).

### Stage Management
전 feature **Where:** Enterprise / Unlimited w/ Stage Management:
- **Manage Parent and Child Stage Transitions Declaratively** (Stage Transition Rules → Add Child Object Criteria and Conditions).
- **Clone and Customize Stage Definitions.**
- **Define Key Checkpoints with Milestones** (Milestone step type, Record Stage Overview LWC).
- **Automate Step Definition Execution** (conditional step execution via expression sets).

---

## Asset Management

> PDF 라인 25540–25940. 자산 가동률 최대화, 설치 자산 가치 발굴, 서비스 팀 생산성. Asset Service Lifecycle Management(ASLM) + Connected Assets.

### Asset Service Lifecycle Management (ASLM)
- **Estimate Work Orders for Installations** (Work Order Estimation) — 서비스 rep가 quote/order의 product 설치 작업을 추정(기존 asset의 field service 추정에 더해). 소스: Accounts, Assets, Quotes, Orders, Work Type Groups, no-context. Omnistudio Document Generation으로 문서 생성/이메일 제안. 모듈화, OOTB on Flows, Omniscript 통합 가능. **Where:** Automotive / Communications / Energy & Utilities / Manufacturing / Media Cloud where ASLM enabled. **Who:** Work Order Estimation permission set.
- **Book a Service Appointment Independently** (Service Appointment Booking) — Core에서 standalone 기능(Work Order Estimation 독립). 별도 권한으로 다른 기능 내 호출/임베드 가능. **Where:** 위 5개 cloud. **Who:** Book Service Appointment Experience User permission set.
- **Efficiently Schedule Inventory Counts for Products and Parts** (Inventory Count) — 물리/시스템 재고 비교, count plan 생성, cycle/ad hoc count, serialized/non-serialized, Salesforce Field Service mobile app.
- **Inventory Replenishment:**
  - **Design Inventory Replenishment Policies with Nuanced Structures** — 제품/제품 카테고리/위치 단위 정책, min/max stock level, replenishment source location 도출. **Where:** Automotive / Communications / Energy & Utilities / Manufacturing / Media + Field Service w/ ASLM. **Who:** Inventory Replenishment permission set.
  - **Minimize Stockouts with an Automated Replenishment Process** — schedule-triggered flow → Replenish Inventory batch job definition / Replenish Inventory flow.
  - **Easily Track Replenishment Policies for Product Items** — Applicable Inventory Replenishment Policy related list on product item record.
  - **New and Changed Objects:** `InventoryReplenishmentPolicy`(신규 object), `InventoryReplenishmentPolicy`(신규 field on `ProductRequest`), `ProcessingStatus`(신규 field on `ProductRequestLineItem`).
- **Timesheets and Labor Cost Optimization Enhancements:**
  - **Validate and Approve Timesheets Quickly** — 신규 desktop experience, BRE 커스텀 검증 규칙, supervisor/time clerk/crew lead bulk edit + approve. **Where:** Field Service Plus for Energy & Utilities + ASLM 전 에디션. **Who(config):** Labor Cost Optimization Admin. **Who(approve):** Labor Cost Optimization Supervisor. **How:** Setup → Timesheets and Labor Cost Optimization 활성화 → App Launcher → Timesheet Management.
  - **Boost Mobile Worker Efficiency with Salesforce Field Service Mobile App** — 자동 daily time summarization, time rounding, 최대 3 shift/workday, absence schedule. **Who:** Labor Cost Optimization Resource + FieldServiceMobileStandardPermSet.
  - **View Meals Earned When a Timesheet Is Approved** — meal voucher/allowance, Labor Union agreement rule 계산.
  - **Updated Objects:** 다음 기존 object 각각에 최대 15개 신규 field — Time Sheet Wage Type Summary, Time Sheet, Time Sheet Entry, Time Sheet Entry Item, Service Resource Cost Rule, Pay Type, Resource Absence. Time Sheet Wage Type Summary의 Regular / Double / Time-and-a-Half Hours → double type(소수 가능).

### Connected Assets
- **Represent Asset Events by Using a Predefined Context Definition** — 사전정의 **Asset Event Details** context definition(asset location, energy consumption, environmental condition, performance node/attribute). **Where:** Enterprise / Unlimited / Developer w/ Connected Assets + Context Service. **Who:** Actionable Event Orchestration Designer + Context Service Admin.
- **Accelerate Actionable Event Orchestration Implementation with Templates** — orchestration record를 template로 저장, expression set / flow template을 execution procedure로 사용. **Who:** Create Actionable Event Orchestration Templates user permission.
- **Streamline Asset Registration Based on Telematics Events** — prebuilt orchestration template로 asset / warranty / milestone / entitlement 생성·갱신. **How:** "Create Records for Asset Registration" / "Update Records for Asset Registration" template.
- **Schedule Asset Service Appointments Based on Telematics Events** — "Service Appointment for Faults" template, asset 위치 20 miles 내 service territory 검색. **Where:** + Salesforce Scheduler.

---

## Automotive Cloud

> PDF 라인 25941–26640. 이 릴리즈 Industries **GA 2건이 모두 Automotive에 집중**.

### Trade-In Appraisal Management (Generally Available)
- **Quickly Initiate Appraisals for Customers and Prospects** — Lead / Opportunity / Account(+Case / Financial Account) record page에서 Flexcard로 appraisal 1-click 생성. **Where:** Enterprise / Performance / Unlimited / Developer w/ Automotive, Appraisal Management, Automotive Components for Appraisal Management. **Who:** Manage Appraisals and Valuations user permission. **How:** Request An Appraisal Flexcard → Create Appraisal.
- **Easily Capture Granular Vehicle Details for Appraisal** — VIN / make-model / license plate 검색, trim / mileage / condition, ownership status, asking price, color / location / purchase date 커스텀.
- **Enhance Valuation Accuracy with Vehicle Customization Details** — 추가 part / accessory(sound system, leather upholstery 등).
- **Integrate External Sources for Better Vehicle Valuation** — JD Power, Kelly Blue Book(KBB), Edmunds; condition average / clean / rough.
- **Efficiently Adjust and Approve the Final Appraisal Value** — discount / markup, approval authorities.
- **View Appraisals Related to a Vehicle in a Single List** — vehicle page related list (VIN 기준).

### Connected Vehicle Enhancements
- **Create Actionable Event Orchestrations Faster** — template 직접/clone. **Where:** Enterprise / Unlimited / Developer w/ Automotive + Actionable Event Orchestration. **Who:** Create Actionable Event Orchestration Templates user permission.
- **Automatically Register Vehicles and Assets Based on Telematics Events** — "Create/Update Records for Asset Registration" template. **Where:** + Connected Vehicle Services. **Who:** Actionable Event Orchestration Designer + Context Service Admin + Manage Flows.
- **Automatically Schedule Vehicle Service Appointments Based On Telematics Events** — DTC 기반, 20 miles 내 service territory. **Where:** + Automotive Scheduler, Connected Vehicle Services.

### Vehicle and Asset Lending Enhancements
Experience Cloud site, rehash proposal:
- **Find a Different Vehicle for Your Vehicle Loan or Lease Application** — Criteria-Based Search and Filter, model / make / year / trim / retail price 검색. **Where:** Enterprise / Performance / Unlimited / Developer w/ Digital Lending, Vehicle and Asset Lending, Criteria-Based Search and Filter. **Who:** Vehicle and Asset Lending for Partners + Criteria Based Search and Filter for Experience Cloud. **How:** Vehicle Definition Searchable Field object 기반 검색 설계; Experience Cloud → Application Form Product → Rehash Proposal → Change Vehicle.
- **Update the Application Payment Structure to Generate Better Offers** — loan / lease amount, interest, term, down payment 조정; preconfigured pricing procedure. **Where:** + Salesforce Pricing.
- **Easily Track Proposals During Various Stages of Decisioning** — 단일 리스트. proposal 분류(원문 그대로):
  - Customer가 intake 중 선택 → **Applicant Selected** (active)
  - Underwriter가 active proposal 공유 → **Lender Selected** (final stage)
  - Dealer가 rehash → **Applicant Revised** (active)
  - Dealer가 final proposal 수락 → **Applicant and Lender Selected**

### Inventory & Financial Data
- **Easily Visualize Vehicle Inventory Search Results with a Card-Based View** — Flexcard(stock code, registration number, exterior color, market price, make/model), 차량 이미지 표시. **Where:** + Criteria-Based Search and Filter. **Who:** Automotive Foundation User + Criteria-Based Search and Filter.
- **Sync Financial Account Data by Using Prebuilt Data Streams** — Automotive data kit data stream → Data Cloud (financial account, address, balance, fee, statement, transaction). **Where:** + Data Cloud.
- **Keep Your Financial Data Updated with Prebuilt Service Processes** — Omniscript guided flow; Action Launcher; Experience Cloud self-service. 배포 가능 프로세스: **Address Update, Fee Reversal, Update Email or Phone**. **Where:** Professional / Enterprise / Unlimited w/ Automotive Cloud.

### Channel Revenue Management (Generally Available)
모든 하위 feature **When: starting March 2025**, **Where:** Sales Cloud 또는 Industries Cloud w/ Channel Revenue Management add-on:
- **Enable Multipartner Design Registration for Seamless Collaboration** (Design Registration)
- **Get Enhanced Visibility with Design Registration Approval Reports**
- **Utilize Enhanced Line Item Approvals for Design Registration** (**Where:** Sales Cloud only)
- **Track Partner Inventory** (Channel Partner Inventory Tracking)
- **Protect Partner Margins with end-to-end Price Protection Management** (Price Protection)
- **Incentivize Your Partners to Meet Sales Targets with Rebates** (Rebate Management, now included)
- **Compensate Partners for Reactive Pricing with Ship and Debit Incentives** (Ship and Debit Process Management, now included)
- **Streamline Channel Management with Unified Setup**

---

## Communications Cloud

> PDF 라인 26641–27140.

### Enterprise Sales Management (ESM)
전 feature **Where:** Enterprise / Performance / Unlimited / Developer w/ Enterprise Sales Management; 대부분 **How: automatically enabled**:
- **Tailor Quotes with Automatic Member Field Mapping** (BRE decision table)
- **Streamline Pricing with Bulk Price Adjustments**
- **Simplify Pricing with Predefined Adjustment Codes** (Enterprise Product Catalog)
- **Increase Asset-to-Quote Limit in ESM Asset Viewer** (기존 cap 6 초과; sync/async threshold; in-app notification)
- **Improve Performance with Level-Based Item Retrieval in ESM Configuration Cart**
- **Simplify Discount Management with Advanced Search and Flexible Bundle Selection**
- **Enhance Global Reach with Multilingual Support**
- **Optimize Bundle Management with Accurate Product and Attribute Sequencing**
- **Keep Your Catalog and Cart Fresh** (만료 제품 알림)

### Agent Console / Einstein / Data Cloud
- **Communications Cloud Agent Console → Streamline Customer Support for Service Issues** — Service Troubleshooting. **Where:** Enterprise / Performance / Unlimited / Developer w/ Customer Service Management. **Who:** Communications Cloud Agent Console, Business Process Engine, Omnistudio, Industry Service Excellence 라이선스.
- **Einstein for Communications → Easily Enable Einstein for Communications from Setup** — **Who:** Communications Cloud Advanced Admin Permission Set Group. **How:** Setup → Einstein Setup → Einstein 켜기; Communications Cloud → Services Setup → Enable Service Console → Einstein for Communications.
- **Use Data Cloud to Proactively Track Service Level Objectives** — Process Asset SLO Breach Tasks flow; Get Service Level Objective and Network Data flow; Calculated Insights object. **Who:** Communications Cloud Admin + Data Cloud Admin/User.
- **Analyze Service Level Objectives and Identify Opportunities for Upsell** — Einstein GenAI, summarized / detailed analysis.

### Communications Cloud Sales
(Note: 추가 라이선스 필요, Salesforce 문의):
- **Create Quotes for New and Existing Customers with the Onboard Customer Flow.** **Where:** Personal / Professional / Enterprise / Performance / Unlimited / Developer w/ Communications Cloud Sales. **Who:** RevenueLifecycleManagementAddOn 또는 RevenueCloudPlusAddOn + CommsCloudRLMAddOn 라이선스.
- **Easily Add Multiple Locations to Quotes and Orders** (CSV upload, Quote Line Item Recipient / Order Product Recipient). **Who:** + CSVImportLicenseAddOn.
- **Browse Product Catalogs and Assign Products to Locations** (qualified / disqualified product, Communications: Discover Products flow).
- **Manage Your MultiSite Customer Assets** (amend / cancel asset multi-location).
- **New Objects in Communications Cloud:** `Quote Line Item Recipient`(견적 대상 site / employee 정보), `Order Product Recipient`(주문 대상 정보).

> **Asset Service Lifecycle Management** (cross-ref): Inventory Count, Inventory Replenishment, Work Order Estimation, Service Appointment Booking → [Asset Management](#asset-management) 참조.

---

## Consumer Goods Cloud

> PDF 라인 27141–27703. **Retirement 3건**(Share Visits, Penny Perfect Pricing V1, Windows Server Modeler) — 개발자 영향 큼.

### Retail Execution
- **Streamline Delivery Execution and Efficiently Complete Tours** — Delivery document(서명, 송장, 반품), end-of-tour(check-in, mileage). **Where:** Enterprise / Unlimited w/ CG Cloud Retail Execution. **Who:** Direct Store Delivery for CG Cloud Offline Mobile App permission set; mobile: CGCloud Tour Driver OR (CGCloud Retail Tour Driver AND CGCloud Retail User).
- **Ensure Visit Integrity with Geofencing and Time Tracking** — explicit start visit, geofencing radius, 동시 in-progress 1개 제한.
- **Boost Brand Visibility by Adding Your Company Logo on CG Cloud Offline Mobile App** — sales org별 logo, Summary card on Your Day page (PNG/JPG, VS Code Modeler).
- **Share Visits Is Retired** (Spring '25부터) — Share visits setting 사용 불가, visit owner만 접근. 커스텀 sharing 구현 필요. 기존 고객은 platform-based sharing 구현 후 setting 끄고 업그레이드. *(PDF 원문: "Starting Spring '25, you can no longer enable the Share visits setting.")*
- **Penny Perfect Pricing V1 Is Being Retired** (Winter '26 예정) — V2로 전환(logging 개선, rebuild mode, scalability). **How:** V2 기본 실행; Spring '25 이하 패키지 고객은 `CGCloudServiceComplexPricing` custom setting 수동 생성. *(PDF 원문: "Penny Perfect Pricing V1 batch process is scheduled for retirement in Winter '26.")*
- **Usability Improvements for Desktop Orders** — configurable default tab(All Items 기본, defaultTab attribute로 Basket 설정), 수량 관리(Add products에서 직접 수량, Custom JSON for Add Items), LWC font/padding/SLDS 정렬, Assessment Task Definitions 검색바.
- **Other Improvements in Retail Execution** — Delete completed visit(`Delete_Completed_Visit`, `Age_of_Visit` custom setting), promotion limit 최대 49,000 account/promotion, batch process 변경(Distribution Relevant False 처리, AggregatePromotionBatch는 Sellable Promotion record type만 — PromotionAggregationForAllPromotions setting으로 전체), DSD Sync Rule 확장, Sharing for Substitution(OvrideSharingForSubstTeamMbr), versioning detail(Device Status Overview), enhanced signing experience, package compatibility validation(4개 컴포넌트 버전 검증).
- **New and Changed Objects for Retail Execution** (전 필드 cgcloud namespace):
  - DSD Execution: `cgcloud__Has_End_Tour_Veh_Details_Rvw__c`(on `cgcloud__Tour__c`), CashInvoice/CreditInvoice picklist on `cgcloud__Document_Transaction_Type__c`(`cgcloud__Order_Template__c`), CashInvoice/CreditInvoice on `cgcloud__Payer_Role_Document_Transaction_Type__c`(`cgcloud__Account_Extension__c`).
  - Geofencing/Time Tracking: `cgcloud__Loc_Capture_During_Complete__c`, `cgcloud__Loc_Capture_During_Cancel__c`, `cgcloud__Capture_Proceeding_Time__c`, `cgcloud__Start_Vst_Geolc_Validation__c`(+None/Error/Warning picklist), `cgcloud__Cmpl_Vst_Geolc_Validation__c`(+None/Error/Warning), `cgcloud__Is_Vst_Start_Osid_Range__c`(Visit), `cgcloud__Is_Vst_Cmpl_Osid_Range__c`(Visit), `cgcloud__Is_Start_Visit_Rqr_To_Check_In__c`, `cgcloud__Does_Show_Read_Only_Visit_Info__c`, `cgcloud__Limit_To_One_Visit_In_Progress__c` (모두 on `cgcloud__Visit_Template__c`), Visit object의 In Progress picklist.

### Modeler Retirement
- **Plan for Windows Server Based Modeler's Retirement** (late 2025, maintenance mode) — VS Code based Modeler 전환 권장(CLI plugin, Salesforce CLI 통합). MCP/MUP/FUP 패키지 unavailable 예정.

### Trade Promotion Management (TPM)
- **Reduce Time and Effort by Copying Manual Inputs for Tactics** (Copy Manual Input). **Where:** Enterprise / Unlimited w/ CG Cloud TPM.
- **Retrieve and Audit Account Plan Manual Inputs** (Get Manual Inputs integration API, Get Comparison integration API, session data in CG Processing Services).
- **Manage TPM Permission Sets Efficiently** (신규: TPM Standard Object Admin, TPM Master Data Admin — 업그레이드 시 자동 갱신).
- **Preview Your Processing Service** (Sandbox 사전 테스트).
- **New and Changed Objects for TPM:** `Duplicate_manual_inputs` field on `tactic_template`.
- **New and Changed Metadata Types in TPM:** `Allowed_Promotion_Phases` query parameter on Filtered Tactic Selection query definition (parameter order 13).
- **New and Changed APIs in TPM** (모두 Enterprise/Unlimited):
  - 기존: DELETE Actuals API, GET Actuals API, Rejection Log API, NULL update 지원.
  - Changed: `/api/v63.0/promotions` (신규 query param `datefrom`, `datethru`).
  - New: `/api/v63.0/volumes/promotions/daily/{measure}`, `/api/v63.0/volumes/promotions/weekly/{measure}`, `/api/v63.0/transaction`, `/api/v63.0/volumes/promotions/daily/bulk/{measure}`, `/api/v63.0/volumes/promotions/daily/{measure}` (delete), `/api/v63.0/volumes/promotions/week/bulk/{measure}`, `/api/v63.0/volumes/promotions/week/{measure}` (delete).

### Metadata
- **New and Changed Metadata Types in Consumer Goods Cloud:** Settings — `cgcloud_Sync_Ignored_Field__mdt` Custom Metadata Type (동기화 제외 sObject 필드 지정). **Where:** Developer / Enterprise / Performance / Professional.

---

## Energy and Utilities Cloud

> PDF 라인 27704–27831.

- **Einstein Generative AI for Energy and Utilities Cloud Enhancements** — Agent Console에 engagement summary, clean energy program suggestion, case summary 추가. **Where:** Professional / Enterprise / Performance / Unlimited / Developer. **Who:** Energy & Utilities Cloud, Energy & Utilities Cloud Billing Account, Energy & Utilities Other Features permission set license. 기능: 최근 5 engagement interaction 요약, location별 clean energy program 식별, 최근 5 case 요약. (GenAI 주의 note 포함.) **How:** Agent Console 설정 후 Setup → Einstein + Einstein Generative AI for Energy and Utilities.
- **Improve Case Management with Easy Access to Case Details** — Agent Console에서 related object field(billing account, service point, location record). **Where:** Lightning + Classic, Professional / Enterprise / Performance / Unlimited / Developer w/ Agent Console.
- **Timesheets and Labor Cost Optimization Enhancements** (cross-ref): Field Service Plus for Energy & Utilities + ASLM → [Asset Management](#asset-management) 참조.

---

## Financial Services Cloud

> PDF 라인 27832–29219. **ICU Locale Apex class 제거 13건**(개발자 영향 큼).

### Business Relationship Plan
- **Closely Monitor Business Relationship Planning with Objective Tracking Metrics** — **Where:** Enterprise / Unlimited w/ FSC Sales & Service 또는 FSC Sales license. **How:** Commercial Banking app → Objectives tab.
- **Effectively Implement Objectives with Action Plans** (Tasks Flexcard, task distribution pie chart).
- **Efficiently Create Measures for Account Plan Objectives By Using a Guided Flow** (opportunity / case / financial deal, progress ring).

### Data Cloud / Portfolio / Lending
- **Data Cloud for Financial Services Cloud → Keep Client Financial Goals on Track with Contextual Alerts and Actions.** **Where:** Professional / Enterprise / Unlimited w/ FSC. **Who:** FSC Extension + purchase FSC Contextual Alerts. **How:** (기존 셋업 시) FSC data kit 제거 → 새 버전 설치 → context definition / expression set / AEO record 삭제 → Contextual Alerts Guided Setup.
- **Portfolio Management → Quickly Compare Actual and Target Allocations** (asset allocation visualization component for accounts). **Who:** View Asset Allocation permission from FSC Sales permission set.
- **Digital Lending—India → Increase the Efficiency of Your Loan Approval Workflow.** **Where:** Enterprise / Unlimited w/ Digital Lending—India. **Who:** Digital Lending India Admin User permission. Integration template(loan origination service): **KYC OCR for Aadhaar, Aadhaar OTP Authentication, Send for ESign, Send for EStamp, Get Status for ESign, Get Status for EStamp, Pan Profile Detailed, Cheque OCR, Employer Search, Employee Search, Form 16 Authentication.**

### Service Process Automation
(Note: Known Limitation — non-FSC 사용자가 FSC service process flow를 볼 수 있음, FSC namespace 이동 작업 중):
- **Accelerate Retail Banking Service Process Setup with Prebuilt Templates.** **Who:** Industries Service Process + Omnistudio User + Industry Service Excellence + (FSC Extension / Basic / Service / Standard) permission set license. Retail 프로세스: **Change Billing Cycle, Initiate Vehicle First Notice of Loss, Lock Unlock Card, Manage Beneficiaries, Manage Card Usage, Manage Credit Limit, Notify Travel Plans, Request Loan Payoff Statement, Reset PIN.**
- **Accelerate Wealth Banking Service Process Setup with Prebuilt Templates.** Wealth 프로세스: **Estate Planning for Wealth, Initiate Automated Account Transfer for Wealth (ACAT), Manage Beneficiaries for Wealth, Manage Standing Instructions for Wealth, Set Up Required Minimum Distribution for Wealth (RMD), Update Profile for Wealth.**

### Wealth / 기타
- **Wealth Management → Boost Productivity with Financial Services Cloud Embedded AI for Agents** — GenAI 요약(asset allocation, portfolio performance, financial goal). **Who:** FSC for Service Einstein 또는 FSC for Sales Einstein; Prompt Template Manager/User; Einstein for Service Innovations.
- **Improve Readability and Clarity of Financial Account Party Record Names** — prefix **FAR → FAP** 변경. custom query / Apex / report filter 업데이트 필요. **Who:** Industry Service Excellence + (FSC Extension / Service / Foundation).
- **Get Started Faster with Guided Setups → Configure Business Relationship Plans with Ease by Using Guided Setup.**

### Objects & DMO
- **New and Changed FSC Object Fields — Financial Account Management Standard Objects** (FSC 관리 패키지 없이 사용 가능, 신규 standard object): `FinancialAccount`, `FinancialAccountParty`, `FinancialAccountBalance`, `FinancialAccountTransaction`, `FinancialAccountAddress`, `FinancialAccountStatement`, `PartyFinclAssetAddlOwner`, `PartyFinancialAsset`, `FinclAcctPtyFinclAsset`, `PartyFinancialLiability`, `PartyFinclLiabAddlBrwr`, `IssuedCard`, `FinancialAccountFee`, `FinancialSecurity`, `Securities Holding`.
- **Data Cloud for Digital Lending — DMOs:** `FinancialApplicationItemProposal`, `FinancialApplicationItem`, `Applicant`, `FinancialApplication`.

### ICU Locale Apex 제거
**Resolve ICU Locale Format Warnings After Spring '25 Sandbox Upgrade** — FinServ 관리 패키지에서 **deprecated Apex class 13건 제거**(원문 그대로):
`FinServ__DeployCustomPicklist`, `FinServ__ModalController`, `FinServ__ReportService`, `FinServ__SegmentationController`, `FinServ__SegmentationService`, `FinServ__TestDeployCustomPicklist`, `FinServ__TestModalController`, `FinServ__TestReportService`, `FinServ__TestSegmentationController`, `FinServ__TestSegmentationService`, `FinServ__TestTodayPageController`, `FinServ__TestWMBaseService`, `FinServ__TestTodayPageController.cls`.

> 위 목록은 PDF 원문상 13개 항목이며, 마지막 `.cls` 표기가 중복처럼 보이나 PDF 원문 그대로 보고한다.

---

## Health Cloud

> PDF 라인 28368–29219. Utilization Management은 Da Vinci FHIR-aligned(CRD/DTR/PAS). **HealthCloudGA Apex class 9 + VF 1 제거**(개발자 영향).

### Disease Surveillance
**Track Public Health Information with the Disease Surveillance Data Model** — **Where:** Enterprise / Unlimited of Health Cloud w/ Health Cloud Add-on license. **Who:** Disease Surveillance, Industries LPI User, Dynamic Assessment Access, Omnistudio User, Action Plans, Industries visit, Industries Assessment permission set. **How:** Public Health Settings → Disease Surveillance; Industries LPI Settings → Inspections.

### Home Health
- **Streamline Home Healthcare with Integrated Quoting and Budgeting Capabilities** — **Where:** Enterprise / Unlimited w/ Health Cloud + Home Health add-on. **Who:** Home Health Quote, DocGen User, DocGen Runtime User, DocGen Designer, Health Cloud Utilization Management, Health Cloud Foundation. **How:** Context Service Settings → Context Definitions; Revenue Settings → Revenue Lifecycle Management; DocGen General Settings; Flows → Send Home Visit Budget Document flow.
- **Expedite Your Home Health Setup** (guided setup).

### Intelligent Appointment Management
모두 **Who:** Health Cloud Appointment Management permission set, **Where:** Enterprise / Unlimited w/ Health Cloud:
- **Verify Prerequisites for Appointments** (Check Appointment Prerequisites flow, work type code set bundle).
- **Optimize Resource Use with Capacity-Based Scheduling** (Salesforce Scheduler; Note: Salesforce Scheduler만 지원, external EHR 미지원).
- **Schedule Ongoing Care with Recurring Appointments** (healthCloudIAM_HomePage_multiLanguage Omniscript; SchedulingOption=Recurring).
- **Give Patients the Ability to Book Assets** (selfScheduleProvidersAndAssets flow; Resource Type field). **Where:** + Health Cloud For Community + Customer Community/Plus.
- **Simplify Scheduling with Enhanced Appointment Guidance.**

### Provider Network Management
- **Streamline Roster File Submission for Providers** (Experience Cloud). **Where:** + Health Cloud Provider Network Management Add-on. **Who:** Customer Community/Plus + Health Cloud for Experience Cloud Sites license.
- **Automate Field Mapping with Einstein Generative AI** (Roster File Mapping, writeback node, confidence score). **Who:** EinsteinGPTFeedbackAddOn, EinsteinGPTPlatformAddOn, EinsteinGPTPromptBuilderAddOn, EinsteinGPTTrustAddOn, EinsteinServices.

### Utilization Management (Da Vinci FHIR-aligned CRD/DTR/PAS)
- **Make Coverage Requirements Easily Accessible for Providers** (CRD, CDS hooks order-select hook). **Who:** Health Cloud Utilization Management, Omnistudio Admin/User, Rule Engine Runtime/Designer. **How:** Clinical Decision Support 켜기; decision matrix; `HlsClinicalDecisionSupportProcessOrderEcho` integration procedure clone.
- **Ensure Submission of Required Documentation for Prior Authorization Requests** (FHIR-aligned DTR). **Where:** + Discovery Framework. **How:** Documentation Templates and Rules 켜기; custom object(Plan Type, Code Set lookup).
- **Author FHIR-Aligned Questionnaires Using the Enhanced Discovery Framework Designer** (FHIR-Aligned Questionnaire usage type).
- **Capture Metrics for CRD/DTR/PA Requests** (request date, response date, response status code). **Who:** Health Cloud Utilization Management + Hls Clinical Decision Support.

### Managed Package / Setup
- **Maintain Smooth Operations with ICU Locale Format Fixes** — HealthCloudGA 패키지에서 **Apex class 9 + Visualforce page 1 제거**(원문): `HcExceptionHelper`, `HcExceptionWrapper`, `HcFieldSetAppConfig`, `HcFieldSetMember`, `HcFieldSetsCtrl`, `HcFieldSetUtils`, `HcHelpTrayDataService`, `HcLabelConfigService`, `HcListViewController` (Apex class), `HcDummyLabelPage` (Visualforce page).
- **Expedite Your Health Cloud Setup** (guided setup, Additional Setup tab).
- **Financial Assistance Program Enhancements / Pharmacy Benefits Verification Enhancements / Site Management (Pilot)** — See Also만, 상세는 [Life Sciences Cloud](#life-sciences-cloud) 참조.

### Connect REST API & Objects
- **New and Changed Connect REST API Resources in Health Cloud:**
  - POST `/connect/discovery-framework/assessment-responses/omniScriptId` — new request body: Assessment Response Input, new response body: Assessment Response Output (DTR Questionnaire 응답 기록).
  - Care Services Review (POST) 신규 request param: careRequest, careRequestItems, careRequestDrugs, contentDocumentLinks, assessmentLinks.
  - get discovery framework structure (OmniProcess API): `additionalAttributes` 반환.
- **New and Changed Objects in Health Cloud:**
  - **Assessments:** `AssessmentDefinition`(신규 object), `AssessmentReason`(field on ServiceAppointmentGroup), `CompletedDateTime`(Assessment), `Assessor`(Assessment), `Identifier`(Assessment), `DisplayTextCategory`(AssessmentQuestion), `DisplayTextCategory`(AssessmentQuestionVersion), `OriginType`(AssessmentQuestionResponse), `ReviewerRole`(AssessmentQuestionResponse), `Reviewer`(AssessmentQuestionResponse).
  - **Home Health:** `AdditionalNotes`(PartyAppointmentRequest), `RecurringAppointmentCount`(PartyAppointmentRequest).
  - **Intelligent Appointment Management:** `ResourceType`(AppointmentReason), `AppointmentGroupType`(ServiceAppointmentGroup), `HasPrerequisitesCheckInFlow`(WorkTypeCodeSetBundle).
  - **Utilization Management** (신규 object): `ServiceInformationRequest`, `ServiceInfoRequestDetail`, `ServiceInformationResponse`, `ServiceInfoResponseCoverage`, `SvcInfoRespCoverageDetail`, `ServiceInfoRespSuggestion`, `ServiceInfoResponseAction`, `ServiceInfoRespResourceUrl`, `ServiceInfoRespOvrideOpt`, `SvcInfoRelatedQuestionnaire`, `ServiceInfoRequestOperation`, `ServiceInfoRqstOpOutcome`, `CareRequestSupportingCntnt`, `CareRequestExchangeInfo`. 신규 field: `CoveragePlanType` / `SupportingDocUrl` / `ClientSourceSysIdentifier`(CareRequestExtension); CareRequestDrug에 `StatusCode` / `TransactionNumber` / `AssertionIdentifier` / `SubmittedDateTime` / `ResponseDateTime` / `RequiredResponseCount` / `ServiceInformationResponse`; CareRequestItem에 동일 7개 field.

---

## Insurance and Brokerage

> PDF 라인 29219–29796. Connect REST API 19건 / Invocable Action 8건(개발자 영향 큼).

### Insurance
대부분 **Where:** Enterprise / Unlimited / Developer w/ Digital Insurance Platform:
- **Manage Policies with Policy APIs and Invocable Actions** (issuance / endorsement / renewal / cancellation). **Where:** + DigitalInsuranceProductAdministrationAddOn, DigitalInsurancePolicyAdministrationAddOn, DigitalInsuranceProductRuntimeCCAddOn, DigitalInsuranceProductRuntimePCAddOn. **Who:** DigitalInsuranceProductAdmin, DigitalInsuranceProductAdminRunTime, DigitalInsurancePolicyAdmin, FSCInsurance.
- **View Policy Information at a Glance** (Insurance Policy LWC).
- **Create and Manage Insurance Products with Ease** (Product Catalog Management for Insurance). **Who:** Manage Product Catalog.
- **Reduce Data Duplication by Using Extended Attributes.**
- **Accurately Calculate Insurance Prices with Precise Pricing Formulas** (pricing procedure). **Who:** Customize Application + Salesforce Pricing Design Time.
- **Offer Precise Product and Quote Pricing to Customers** (procedure plan). **Who:** Procedure Plan Access + Salesforce Pricing Design Time.
- **Facilitate Quote Management with New Quoting Invocable Actions and APIs; Simplify Quote Management with Quote Configurator.**
- **Automate Quote-Related Business Decisions with Product Underwriting Rules** (Stage Management). **Capture Quotes Accurately with Configuration and Qualification Rules** (Revenue Lifecycle Management Add-on).

**New Connect REST APIs in Insurance** (19): Issue Insurance Policy, Endorse Insurance Policy, Cancel Insurance Policy, Get Insurance Policy Details, Create Insurance Quote, Update Insurance Quote, Renew Insurance Policy, Insurance Product Rating, Insurance Underwriting Rules, Insurance Underwriting Rules (Invoke), Insurance Underwriting Rule, Insurance Product Surcharge, Insurance Product Surcharges, Insurance Get Quote Detail, Commission Processing, Cost Calculation, Expected Revenue, Plan Benefits Product Model, Renew Policy.

**New Invocable Actions in Insurance** (8): `issueInsurancePolicy`, `endorseInsurancePolicy`, `renewInsurancePolicy`, `cancelInsurancePolicy`, `getInsurancePolicy`, `createInsuranceQuote`, `repriceInsuranceProduct`, `getInsuranceQuoteDetails`.

**New Metadata Type — Salesforce Flow for Insurance** (FlowActionCall subtype, actionType field 신규 값): `cancelInsurancePolicy`, `endorseInsurancePolicy`, `getInsurancePolicy`, `issueInsurancePolicy`, `renewInsurancePolicy`.

### Insurance Brokerage
전 feature **Where:** Professional / Enterprise / Unlimited w/ Financial Service Cloud + Insurance Brokerage:
- **Manage Commissions Easily by Assigning Producer Splits to Insurance Policies** (Producer Split Arrangements).
- **Simplify Producer Split Management with Account and Role-based Assignments.**
- **Process Commission Statements at Scale** (CSV Import).
- **Easily Define Employee Eligibility for Benefits Coverage** (eligibility definition, group class).
- **Conveniently Calculate the Premium for a Policy or Coverage** (Insurance Rate Plans).
- **Improve Forecasting by Calculating Expected Commissions** (Insurance Rate Plan Commission).
- **Define Employee and Employer Contributions for Insurance Coverage** (Insurance Contribution Plan).
- **Easily Manage Coverage Benefits By Using a Product Template** (Product Catalog Manager).
- **Easily Manage System Configurations for Brokerage** (Setup → Brokerage).
- **Save Time and Effort in Performing Policy Lifecycle Tasks** (renew / endorse / repurpose / cancel).
- **New Metadata Type — Salesforce Flow** (FlowActionCall subtype): `computeProducerSplits`, `createProducerCommissions`, `findInsurancePolicy`.

### Insurance (Managed Package)
- **Transform Insurance Offerings with Multi-Root Policy Services** (auto+home 번들). **Where:** Professional / Enterprise / Unlimited w/ Insurance Industries managed package.
- **Ensure Precision in Pending Payment Calculations** (`ExcludeStatusesForPayment` custom setting). **Where:** + Insurance Industries Extension.
- **New Services in Insurance:** `InsPolicyService:createMultiRootPolicy`, `InsPolicyService:createMultiRootPolicyVersion`, `InsQuoteService:createEndorsementQuote`, `InsPolicyService:getPolicyAsyncJobStatus`.

---

## Life Sciences Cloud

> PDF 라인 29797–30441. **Pilot 7건**(Site Management 그룹 + 하위 6). 객체/필드 변경 대량.

### Advanced Therapy Management
- **Refresh Components to Track Task Progress** (Work Order Step Progression, Work Procedure Step Progression). **When: starting March 2025.** **Who:** Health Cloud Advanced Therapy Orchestration permission set + license.

### Financial Assistance Program
- **Manage Appeals for Financial Assistance Program.** **Who:** Health Cloud Starter(LS)/Foundation(HC), Industry Service Excellence, OmniStudio Admin/User, Rule Engine Runtime/Designer, Manage Financial Assistance Program. **How:** FinancialAssistanceProgramContainer Flexcard → File Appeal.
- **View the Appeals History of a Rejected Application.**

### Participant Management
- **Access Recruitment Features on Mobile or Tablet Devices.** **Where:** + Participant Enrollment add-on.
- **Configure Criteria-Based Search and Filter Automatically with a Toggle.**
- **Merge Prescreening and Registration Omniscripts for a Unified Flow** (TrialManagement_candidateEligibiltiyAndRegistration Omniscript, reCAPTCHA).
- **Refine Search Results by Using Range-Based Filtering Options** (In-Range, Range Overlap range type). 예시 원문: In-Range(25–35: 26/30/35 포함, 24/36 제외), Range Overlap(20–30, 30–40 오버랩 포함).

### Pharmacy Benefits Verification
- **Boost Representative's Productivity with Electronic Verification.** **Who:** OmniStudio Admin/User, Manage Pharmacy Benefits Verification, Health Cloud Starter/Foundation. **How:** PharmacyBenefitsVerification Flexcard → New Electronic Request.

### Site Management (Pilot)
그룹 + 하위 6 feature **전부 Pilot**(각각 Beta Services Terms note 명시):
- **Identify Investigators and Sites for Clinical Trials by Using Enhanced Search Capabilities (Pilot)** — CBSF. **How:** Site Management Settings → Set Up Site Investigator Search.
- **Create and Deploy Site Feasibility Assessments (Pilot)** — GenAI questionnaire. **Where:** + Einstein GPT Platform, Omnistudio Designer, Industries Generative AI platform license. **Who:** Study Manager + Health Cloud Starter/Foundation + Generative AI Assessment Questions, NLP Service, Scoring Framework license. (GenAI 경고 note.)
- **Assign Scores to the Investigators and Sites for Effective and Faster Site Selection (Pilot).**
- **Accelerate the Site Feasibility Assessment Process (Pilot)** — discovery framework formula question. **Who:** OmniStudio Admin + Health Cloud Starter/Foundation.
- **Tag the Sites and Investigators for Future Site Selection Efforts (Pilot)** — Interest Tagging, 최대 3 level.
- **Accelerate Your Site Management Configurations with a Guided Setup (Pilot).**

### Objects
**New and Changed Objects in Life Sciences Cloud:**
- **Site Management (Pilot)** 신규 object: `Care Site Investigator Searchable Field`, `Care Program Site Contract`, `Party Publication`, `Research Study Protocol Information`.
- **CareProgramSite** 신규 field(전수): `Investigator`, `RegulatoryDocTurnaroundDrtn`, `InvtglProductReleaseDrtn`, `QualVstToInitVstDrtn`, `SiteActvToFirstPtcpDrtn`, `SiteActvToLastPtcpDrtn`, `ProjectedPtcpEnrlDrtn`, `ActualPtcpEnrollmentDrtn`, `ProjectedPtcpEnrlCount`, `ActualPtcpEnrollmentCount`, `ScreenedParticipantCount`, `RandomizedParticipantCount`, `RsrchStudyCmplPtcpCount`, `ProtocolDeviationCount`, `SeriousAdverseEventCount`, `SponsorRepresentative`, `ClnclTrialAgreeTrnarndDrtn`.
- `HealthcareFacility` field on Accreditation.
- **CareProviderFacilitySpecialty:** `HealthCareFacility`, `CompletedResearchStudyCount`, `ActiveResearchStudyCount`.
- **HealthcareProvider:** `Classification`, `DoesParticipateInRsrchStudy`.
- **HealthcareProviderSpecialty:** `ResearchStudyPhase`, `ResearchStudyType`, `CompletedResearchStudyCount`, `ActiveResearchStudyCount`.
- `HealthcareProvider` field on HealthcareProviderTaxonomy.
- **HealthcareFacility** 신규 field(전수): `IsAfflWithSiteMgmtOrg`, `IsSatelliteSite`, `ResearchStudyStartYear`, `PatientAgeRange`, `AverageOpdPatientCount`, `ResearchStudyPhase`, `ResearchStudyType`, `InvestigationalProductType`, `ResearchStudyMethod`, `ClinicalTrialAgreementType`, `AvgClnclTrialAgreeDrtn`, `IsDedResearchStudyRoomAvl`, `IsDedRsrchStdyMntrRmAvl`, `IsRsrchStudyMtrlStoreAvl`, `IsPkpdSpcmnCollStrgAvl`, `IsPgxSpcmnCollAvl`, `InvtglProductStorageCpbl`, `InvtglProdtDestructionCpbl`, `InvtglProdtPreparationCpbl`, `IsTrainingProvided`, `IsGoodClnclPracTrnPrvd`, `IsRsrchEthicalRvwSbmsSupp`, `AvgRsrchEthicalReviewDrtn`, `RsrchEthicalRvwComteType`, `AvgRegltyDocTrnarndDrtn`, `AvgInvtglProductReleaseDrtn`, `AvgQualVstToInitVstDrtn`, `AvgSiteActvToFstPtcpDrtn`, `AvgSiteActvToLastPtcpDrtn`, `AvgProjectedPtcpEnrlDrtn`, `AverageActualPtcpEnrlDrtn`, `AvgProjectedPtcpEnrlCount`, `AvgActualPtcpEnrlCount`, `RegulatoryViolationCount`, `AvgProtocolDeviationCount`, `HealthcareProvider`, `Classification`, `AreResearchStudiesConducted`.
- **Financial Assistance Program:** `Application Form Appeal Status Change Event` object(신규), `Verification Mode` field on Care Benefit Verify Request.

---

## Loyalty Management + Global Promotions Management

> PDF 라인 30441–30831.

### Loyalty Management
전 feature **Where:** Enterprise / Performance / Unlimited / Developer:
- **Gamify Member Engagement with Milestone-Based Promotions** (Engagement Trail template). w/ Loyalty Management - Growth/Advanced.
- **Report Liability Accurately by Tracing Negative Points Usage** (action type: **Credit for Arrears**, **Debit with Arrears**). **How:** Loyalty Management Settings → Trace Usage of Points + Members Can Have a Negative Point Balance.
- **Effectively Track Promotional Points by Using Currency Subtype.**
- **Gather Richer Customer Insights with the Enhanced Data Kit.** w/ Data Cloud.

### Global Promotions Management
전 feature **Where:** Loyalty Management 가능 + Global Promotions Management enabled:
- **Empower Customers and Sales Reps to Select Promotions by Using Coupons.**
- **Accurately Search for Products Using Enhanced Search Options** (SKU / code).
- **Exclude Ineligible Products and Categories Efficiently.**
- **Simplify the Evaluation of In-Store Promotions** (Eligible Promotions API context definition).
- **Easily List Accounts Eligible for Promotions with Campaigns.**
- **Easily Select All Eligible Products for a Promotion Rule.**
- **Automate Promotion Data Sync with Prebuilt Data Streams.** w/ Data Cloud.
- **Decide How Customers' Data Cloud Segment is Verified** (Query API vs data graph). w/ Data Cloud.

### API & Objects
- **New and Changed APIs in Global Promotions Management:**
  - New: `/global-promotions-management/coupons/usage-increase`, `/global-promotions-management/coupons/usage-decrease`.
  - Changed: `/global-promotions-management/eligible-promotions` — 신규 input(stockKeepingUnit, productCode), 신규 output(promotionCoupon, couponAvailabilityMessage, couponDetails, couponCode, status, startDateTime, endDateTime).
  - Account Support for Campaigns: Eligible Promotions(accountId), Transaction Journals Execution(MemberId), Redeem Voucher(accountId).
- **New and Changed Objects in Loyalty Management:** `Coupon`(신규), `CouponCodeRedemption`(신규), `CreditForArrears` / `DebitWithArrears` values on ActionType field of `LoyaltyLedgerTraceability`.
- **Changed Invocable Actions in Loyalty Management:** Account Support for Campaigns(accountId → 발급 voucher 반환).
- **New and Changed APIs in Loyalty Management:**
  - New: `/loyalty/programs/${programName}/members/${membershipNumber}/engagement-trail?$promotionId={promotionId}`.
  - Changed: `/connect/realtime/loyalty/programs/${programName}` — 신규 field `shouldCheckCouponUsageLimit`.

---

## Manufacturing Cloud

> PDF 라인 30832–31247.

### Revenue Management Features for Sales Agreements
전 feature **Where:** Enterprise / Unlimited / Developer w/ Manufacturing Cloud + Revenue Cloud; **Who:** Manufacturing Sales Agreements, Pricing Features for Sales Agreements, Product Catalog Features for Sales Agreements, Salesforce Pricing Run Time User, Product Discovery User, Context Service Runtime, Product Catalog Management Viewer, Product Configuration permission set:
- **Identify Perfect Products for Sales Agreements from Expansive Catalogs** (Browse Catalog).
- **Drive Sales by Tailoring Product Configurations to Customer Preferences** (product configurator, attribute 조합).
- **Maximize Your Margins with Rules-Driven Pricing in Sales Agreements** (Salesforce Pricing, price waterfall).
- **Easily Compare Committed and Fulfilled Sales of Products with Attributes in Sales Agreements.**
- **Check Product Specifications for Sales Agreements Without Switching Pages** (side panel).
- **Renew Sales Agreements with Same Products and Attributes.**

### Sales Agreements Foundations Enhancements
전 feature **Who:** Manufacturing Sales Agreement Psl permission set:
- **Calculate Sales Agreement Actuals by Using Data Processing Engine** ("Calculate Actual Metrics for Products" DPE template).
- **Maximize Sales Agreement Profitability with Cost Visibility** (cost book, Cost Price, margin). 예시: planned 10 generators, wholesale $110/unit, cost $100/unit → planned margin % = 9.09%.
- **Recalculate Actuals for Future Schedules** (최대 24 future schedule, weekly / monthly / quarterly).
- **Add Multiple Instances of the Same Product to a Sales Agreement** (unique display name, Actuals Calculation Product).
- **Easily View the Unallocated Quantity for a Product** (예: 1200 → 300 할당 → 900 unallocated).

### Inventory
- **Streamline Your Inventory Counting Processes** (Inventory Count). **Who:** Inventory Count Manager + Inventory Count User.
- **Minimize Stockouts with Automated Inventory Replenishment** (Inventory Replenishment). **Who:** Inventory Replenishment permission set.

---

## Media Cloud

> PDF 라인 31248–31307.

### Advertising Sales Management
- **Boost Efficiency in Your Advertising Sales Workflow** (WideOrbit 통합; Note: WO Traffic TV만 지원). **Where:** Lightning, all editions. **How:** Media External Account WideOrbit Integrations API in MuleSoft Direct; Salesforce inbound / outbound Account APIs.
- **Target Granular Audience Segments By Using Salesforce Data Cloud** (remote Data Cloud instance, Google Ad Manager 업로드). **Where:** Lightning, all editions. **Who:** Media Cloud users + Salesforce Data Cloud instance. **How:** DataSpace custom setting, lightning page for segment import.

> Note: "Boost Efficiency" feature는 pdftotext 추출 시 "Where:"·"How:" 레이블이 문장 끝으로 밀려 표기됨(라인 31278 / 31280) — 내용은 온전하며 위에서 정상 순서로 재배치했다.

---

## Net Zero Cloud

> PDF 라인 31308–31499. CSRD compliance, IRO(Impact Risk Opportunity) 데이터 모델.

전 feature **Where:** Professional / Enterprise / Unlimited / Developer w/ Net Zero Growth license + 각 add-on:
- **Perform Materiality Assessments and Score Impacts and Risks and Opportunities for CSRD Compliance** (IRO heat map, Information Library). + Materiality Assessment add-on. **How:** Net Zero Settings → Manage Materiality Assessments.
- **Streamline CSRD Reporting with Simplified Setup and Enhanced Features** (CSRD report builder Version 3, EFRAG questionnaire April 2024). + Disclosure and Compliance Hub add-on. **How:** Disclosure and Compliance Hub Settings → Manage ESG Reports + Manage CSRD Reports.
- **Find XBRL Tagging Providers to Comply with CSRD Requirements** (Net Zero Marketplace). + Disclosure and Compliance Hub add-on.
- **Allocate Scorecard Emissions Based on Spent Amount** (Supplier Scorecard → Scope 3 Procurement Item). + Net Zero Cloud External Engagement Management add-on. **How:** Net Zero Settings → Allocate Scorecard Emissions Based on Spent Amount.

**New and Changed Objects in Net Zero Cloud:**
- Changed (Note: page layout 추가 필요): `PredefinedDisclosureDefVersion` field on Disclosure; `IsMaterial` on MaterialityTopic; Disclosure object의 field type 변경 ForeignKey→EnumOrId (`DisclosureDefinitionId` 제거, `DisclosureDefinition` 추가 — custom SOQL integration 수정 필요).
- New object: `Impact Risk Opportunity`, `Impact Risk Opportunity Assessment`, `Impact Risk Opportunity Score`, `Impact Risk Opportunity Assessment Topic`(junction), `Impact Risk Opportunity Topic`(junction).

---

## Public Sector Solutions

> PDF 라인 31499–31928. Metadata API / 객체 변경(개발자 영향 큼).

- **Create Unified Profiles and Gain Insights from Harmonized Data in Data Cloud.** **Where:** Enterprise / Performance / Unlimited / Developer w/ PSS + Data Cloud. **When: Data Cloud for Public Sector Solutions starting April 2025.**
- **Help Caseworkers Quickly Learn About a Household with Einstein.** + Einstein Platform add-on.
- **Enhance Job Applications for Talent Recruitment Management** (multi-section, skippable optional section).
- **Easily Create Personalized Care Plans for Employees** (Employee Experience cloud site). + Employee Experience for Public Sector add-on. **Who:** Employee Experience For Public Sector license.
- **Quickly Migrate Dynamic Assessments with Metadata API.**
- **Improve Employee Experience with Streamlined HR Service Management** (Employee Service = Work.com 재설계; Work.com 사용자는 migrate 권장). **Where:** + Public Sector Solutions — Service — Einstein 1 Edition.
- **Updated Metadata API Type:** `OmniAssessmentTasks` field on OmniScript metadata type.
- **New and Changed Objects:** `IntakeFormSection`(신규), `OmniProcessOmniAsmtTask`(신규), `RecruitmentPosting`(field on ApplicationForm), **REMOVED:** `ActionPlanBaseTemplateAsgn`(API v63.0+ 제거, `ActionPlanTemplateAssignment` 사용), `LastFilledDate` / `Status`(JobPosition), `ApprovalDateTime`(RecruitmentRequisition), `VettingStartDateTime` / `VettingEndDateTime`(VettingEvaluation).

---

## Referral Marketing

> PDF 라인 31928–32119.

전 feature **Where:** Enterprise / Performance / Unlimited / Developer where Referral Marketing available:
- **Enhance Your Promotion's Reach with WhatsApp Messages** (Referral Promotion guided setup → Communication Assets → WhatsApp).
- **Choose How to Verify Advocates' Data Cloud Segments** (Query API vs data graph; Refer A Friend widget, Referral Advocate Enrollments API).
- **Sync Referral Marketing Data with Prebuilt Data Streams.** + Data Cloud.
- **Get Predictions on Contacts' Likelihood to Refer.** **Where:** + CRM Analytics for Loyalty Management + Scoring Framework. **Who:** AI Accelerator, Referral Marketing, Loyalty Analytics Apps license. (Contacts' Likelihood to Refer template configuration.)
- **Integrate Referral Marketing to Enhance B2C Customer Engagement** (B2C Commerce cartridge).
- **New and Changed Objects:** `CommunicationChannelType`(신규), `CommunicationChannelTemplate`(신규), `InternalOrgUnitCommChannel`(신규), `PromStageCommChannelTmpl`(신규).
- **Changed APIs:** `/referral-program/referral-event` — 신규 field: `optInWhatsApp`, `contactLocale`, `contactFieldForLocale`.

---

## Salesforce for Education (Education Cloud)

> PDF 라인 32119–32254. Student Recruitment Agent 1건은 **등급 미표기(GenAI 일반)** — PDF heading에 `(Pilot)`/`(Beta)` 태그가 없다(본문 Note만 pilot/beta 가능성 언급). 객체/picklist 변경 대량.

- **Autonomously Answer and Support Prospective Students** (Student Recruitment Agent for Agentforce — **등급 미표기(GenAI 일반)**. PDF heading에 `(Pilot)`/`(Beta)` 태그 없음. 단 본문 Note는 *"Student Recruitment Agent is a pilot or beta service that is subject to the Beta Services Terms"*라고 명시). + Agentforce add-on license. **When: starting March 2024** ⚠️(아래 timing flag). **Who:** Education Cloud Full Access (config), 모든 사용자(guest 포함) 사용 가능.
- **Consolidate Information in Student Records with the Student Management App.**
- **Get More from the Intelligent Degree Planner and the Learner Progress View** (Compare Program Plans flow template).
- **Streamline Advancement-Specific Data Processing** (+ Fundraising).
- **Drive Comprehensive Prospect Research Activities** (+ Fundraising).
- **Unlock Deeper Insights with Generational Categories** (baby boomers / Gen X / millennials / Gen Z) (+ Fundraising).
- **Gain Holistic Student Insights and Visualize Learner Progress** (Data Cloud for Education: Holistic Student Insights, At Risk / On Track / Needs Attention). + Einstein for Sales/Service add-on + Data Cloud.
- **Get a Unified View of Student Data with Learner Profile** (Update Learner Profiles with CRM Data definition).
- **Schedule Appointments Efficiently with a New Lightning Web Component** (My Appointments Header).
- **Capture Student Sentiment with Icon Responses in Pulse Checks** (icon data type, emoji).
- **Score Applications with Rubrics** (Application Scoring). **Who:** Education Cloud Full Access 또는 Limited Access.
- **Streamline Admissions Reviews with Stage Management** (Application Review, Application Decision, Individual Application objects + Case / Opportunity). **Who:** Stage Management Design User.

**New and Changed Objects in Education Cloud:** `LearnerProfile`(신규), `Summary`(CourseOfferingParticipant), `AssessmentQuestionVerChoice`(AssessmentQuestionResponse), `AcademicTermGpaCalcEvent`(신규), `RgltyCodeRegClauseVer`(신규 junction), `RgltyCodeViolRegClVer`(신규 junction), `UsageType`(BusinessOperationsProcess), `UsageType`(ComplianceControl), `AcademicStanding`(AcademicTermEnrollment) — picklist: **Good Standing, HonorsDeans List, Academic Warning, Academic Probation, Academic Dismissal, Required Withdrawal, Reinstatement Status**; `ActionPlanTemplateAssignment` 신규 field `AssignmentQueueName` / `AssignmentSize` / `AssignmentType`(AssignmentType picklist: Staff Review); `Score`(ApplicationDecision, ApplicationReview, Assessment); `ParticipantResultStatus`(CourseOfferingPtcpResult) 신규 label: **Failed, Passed, Withdrew**; `IsActive`(CourseOffering); `CourseOfrgRubricCriterion`(신규); `CourseOfrPtcpActvtyGrd`(신규); `ParticipationStatus`(CourseOfferingParticipant) 신규 picklist: **Declined Waitlist, Dropped, Registering**; CourseOfferingSchedule 신규 field `EndDate` / `RecurrencePattern` / `StartDate` / `Type`(record 및 template); ContactProfile 신규 `HasFerpaParentalDisclosure` / `HasFerpaThrdPtyDisclosure`; IndividualApplicationTask 신규 `ApplicationDecision` / `ApplicationReview`; LearnerProgram 신규 `CatalogYear` / `ClassCohort` / `ExpectedGraduationDate`.

**New and Changed Data Model Objects (DMOs) in Education Cloud:** `LearnerLearningSystemActivity`, `LearnerCampusSpacesActivity`, `MealCardActivityId`.

> ⚠️ **Timing flag:** Student Recruitment Agent의 "starting in March 2024"는 Spring '25 릴리즈 노트 맥락상 **2025 오타로 의심**된다. 원문 그대로 기재하되 검증 권장.

---

## Nonprofit Cloud

> PDF 라인 32255–32419. 상세 기능은 Fundraising / Outcome Management / Program and Case Management / Grantmaking([Industries Common](#industries-common-공통-기능)) 참조.

- **foundationConnect is Being Retired** (Salesforce for Nonprofits Managed Packages) — **Jan 31, 2025** 이후 구독 갱신 불가, **Jan 31, 2026 은퇴**. Grantmaking이 대안. *(PDF 원문: "After January 31, 2025, you can't renew subscriptions ... foundationConnect is scheduled for retirement on January 31, 2026.")*

---

## Vlocity Contract Lifecycle Management

> PDF 라인 32419–32524. **DocGen Retirement 2건**(VF Omniscripts, Document Generation 1.0) — 개발자 영향 큼.

- **Visualforce-Based Document Generation Omniscripts Are Being Retired** — `singleDocxVF`, `multiDocxVF`, `singleWebVF`, generic DocGen Omniscript 은퇴. LWC 기반 `singleDocxLwc` / `multiDocxLwc` / `singleWebLwc` 전환. **Where:** Professional / Enterprise / Unlimited / Developer. **How:** Vlocity Templates → DocGenerationSampleLwc datapack. (datapack: docGenerationSample/singleDocxVF, multiDocxVF, singleWebVF → singleDocxLwc, multiDocxLwc, singleWebLwc.)
- **Document Generation 1.0 is Being Retired** — **July 31, 2025** 은퇴. CME / INS / Vlocity Government(PS) / Omnistudio 패키지(Winter '25까지). 2.0 전환(client-side processing, PDF previewer, custom font config).
- **Enhance Document Generation with Document Generation 2.0** (Hyperforce hybrid, in-app consent). **How:** App Launcher → Document Generation 2.0 Notification → Server-Side Notice.
- **Migrate and Sync Custom Fonts.** **Who:** DocGen Designer permission set.

---

## PDF 인용 — 등급·날짜 wording (구조 충족용)

> Industries 섹션에는 전통적 Apex/JSON 코드 블록이 **없다**. 대신 API endpoint·object/field API name·picklist 값·permission set 명이 코드성 자산이다(위 각 섹션에 verbatim 보존). 아래는 등급·날짜 claim 원문 인용.

```text
// PDF 원문 인용 — 구조 충족용 (Salesforce Spring '25 Release Notes, Industries)
"Trade-In Appraisal Management (Generally Available)"
"Channel Revenue Management (Generally Available)"
"Design Registration is available with Channel Revenue Management starting in March 2025."
"Track Changes Across Related Objects with Cross-Object Field History (Beta)"
"Boost Efficiency and Customer Satisfaction with Einstein Autofill (Beta)"
"Penny Perfect Pricing V1 batch process is scheduled for retirement in Winter '26."
"Windows Server based Modeler is scheduled for retirement in late 2025."
"Starting Spring '25, you can no longer enable the Share visits setting."
"Collections is available starting April 2025."
"You can enable and configure Stage Management starting on February 17, 2025."
"Document Generation 1.0 is scheduled for retirement on July 31, 2025."
"After January 31, 2025, you can't renew subscriptions ... foundationConnect is scheduled for retirement on January 31, 2026."
"Process More Batch Server-Side Document Generation Requests with Increased Limits"   // 시간당 2,500 / 일 60,000
```

---

## 관련 노트

- [[Spring '25]] — Spring '25 릴리즈 전체 진입점 (허브)
- [[Spring '25/Clouds]] — 일반 클라우드(Sales / Service / Experience / Commerce 등) peer 노트
- [[Spring '25/Agentforce]] — 산업별 Agentforce 연계(Einstein for Communications / Energy & Utilities, Student Recruitment Agent 등) peer 노트
