---
tags: [release, summer_25, industries, health-cloud, financial-services, public-sector]
api_version: v64.0
release_date: 2025-06
created: 2026-06-15
source: salesforce_release_notes_5-17-2026 (3).pdf (Salesforce Summer '25 Release Notes, Tier 2)
aliases: [Summer '25 Industries, 서머25 산업 클라우드, Health Cloud, Financial Services Cloud, Public Sector, Automotive, Communications, Energy and Utilities, Life Sciences, Net Zero]
---

# Summer '25 — Industries (산업 클라우드)

> Summer '25 릴리즈의 **산업 클라우드(Industries)** 전용 노트. 원본 PDF에서 Industries 섹션(p572–793, 9699줄)이 단일 클라우드 섹션 중 가장 방대해 [[Summer '25/Clouds]](일반 클라우드 — Sales/Service/Experience/Commerce 등)에서 분리했다. 14개 이상의 산업 클라우드 + Industries Common(공통 기능)의 GA / Beta / Pilot 항목과 산업별 기능 요지를 전수 정리한다.

---

## 개요 — 산업별 GA / Beta / Pilot 건수

이 노트가 다루는 고유(dedup 후) 정식 등급 항목:

| 등급 | 건수 | 항목 |
|---|---|---|
| **GA (Generally Available)** | 5 | Cross-Object Field History (Industries Common), Advertising Sales Management on Salesforce Platform (Media), Enhance Scope 3 Emissions Calculations with Einstein (Net Zero), Search for and Draft ESG Reports (Net Zero), Generate First Draft of ESG Disclosure Automatically (Net Zero) |
| **Beta** | 다수 | LWC Quick Actions (Consumer Goods), Media Proposals 묶음(Media), Public Sector Einstein 4건, Philanthropic Research in Agentforce (Nonprofits) |
| **Pilot** | 1 | Ingest KPI Data from Processing Services to Data Cloud (Consumer Goods) |

> Cross-Object Field History GA는 여러 산업 클라우드(Automotive·Financial Services·Industries Common 등)에 중복 등장하지만 동일 기능이므로 **1건으로 dedup**해 [Industries Common](#industries-common-공통-기능) 아래에 둔다.

### 산업별 개요 (PDF Industries TOC 원문 요약 — 전수)

> PDF 원문 p572–575 "Industries" 산업별 한 줄 요약. 산문을 보존한다.

- **Asset Management** — 인벤토리 운영 간소화. 파트너용 서비스 작업 견적, 빠른 반품·교체, depot repair 워크플로, 대량 타임시트 생성·차량 사용 시간 추적.
- **Automotive Cloud** — 차량·자산 대출 rehashing 최적화, 중복 레코드 관리, interaction summary 기반 대출/리스 승인 간소화. 동적 questionnaire와 prebuilt Omniscript로 차량·자산 검사. 맞춤 path·softphone layout, Experience Cloud page variation, guest user의 lead line item/preferred seller 접근, 공공 민원 추적, 외부 시스템용 차량 식별자.
- **B2B Referral Management** — 파트너의 신규 비즈니스 추천을 통한 유기적 성장. referral promotion 설계, 재사용 promotion 템플릿, 다양한 reward, brand 비즈니스 프로세스에 referral 통합, referral program/promotion 업데이트 모니터링.
- **Channel Revenue Management** — 채널 영업·인벤토리 가시성. partner inventory reconciliation, manual adjustment, partner/end-customer return tracking, 미판매 인벤토리 기반 ship and debit claim 검증으로 과지급(overpayment) 최소화.
- **Communications Cloud** — Agentforce for Communications Billing Resolution으로 청구 문의/분쟁 처리. prebuilt Industries CPQ invocable action으로 자동 quoting/ordering. Communications Cloud Agent Console로 고객 정보(service/billing account, order, asset viewer, case) 통합 뷰. Communications Cloud Sales의 quote line item 확장성 개선, Enterprise Sales Management, partner community의 Work Order Estimation.
- **Consumer Goods Cloud** — 배송 시 사전주문 수량 조정 + 현금/부분 결제. visit activity와 delivery task hybrid 처리. Bluetooth thermal printer 출력. mobile linking, **온라인 모드 LWC**, sync 빈도 제어. 단종 제품 leftover inventory의 actuals capture. TPM Data Connector로 Data Cloud ingest. Trade Promotion Optimization(TPO)에 forward buy 반영.
- **Energy and Utilities Cloud** — service location 월별 소비 추적·비교. supervisor/time clerk/crew lead의 대량 타임시트 생성, 모바일 워커 차량 검색·선택·usage 할당·time-off balance 검토.
- **Financial Services Cloud** — Salesforce Go로 기능 발견·설정. API로 client/관련 레코드 실시간 새로고침. standard object 기반 financial plan/goal 데이터 모델 유연성. household 상세 near real-time 새로고침. loan origination 통합(applicant verification·payment setup). Cancel Insurance Policy service process.
- **Health Cloud** — Agentforce for Contact Center(컨택센터 효율), Agentforce for Public Health(질병 조사 case 분류), Agentforce for Home Health(재택 의료 워크플로 자동화). Home Health 예산 관리 워크플로. waitlist management·time zone 기반 예약 일정.
- **Insurance** — 다수 보험 정책 일괄 갱신/취소. producer split arrangement line item에 flat amount 할당. 반올림 수수료(rounded commission) 필드. Insurance의 신규/변경 객체.
- **Life Sciences Cloud** — Advanced Therapy Management orchestrator 개선(더 큰 트랜잭션 처리), 멈춘 stage/step 수동 재시작. research study 생성으로 participant 모집·등록. 검색 결과 페이지에서 임상시험 site/investigator 요약. Site Selection console app.
- **Loyalty Management** — Agentforce topic으로 맞춤 promotion 생성·launch 이메일 초안. interest·affinity 기반 club. 맞춤 promotion 추천. data space 교차 쿼리로 member segment 조회. 가족·친구에게 point 전송. 모든 rule action에 field alias.
- **Manufacturing Cloud** — sales agreement에서 configured product의 정확한 수량 지정으로 revenue leakage 최소화. depot repair·advanced exchange로 인벤토리 추적성 개선.
- **Media Cloud** — Advertising Sales Management on Salesforce Platform으로 미디어 속성·광고 상품 전체 관리. 광고 영업 lifecycle 전체. prebuilt 리소스로 외부 시스템 통합, media plan/광고 워크플로 fine-tune. Agentforce for Media. RFP 대응 proposal·pitch deck 생성. 광고 placement/서비스별 매출 추적.
- **Net Zero Cloud** — snippet 초안 작성 간소화(CSRD·custom disclosure framework 연결 context 제공). Salesforce Data Cloud의 near real-time file indexing으로 Einstein 강화. 배출 데이터 gap 식별·estimated method로 채움. multi-level hierarchy 조직 경계로 carbon accounting 확장. 에이전트로 Net Zero Cloud Manager 확장.
- **Public Sector Solutions** — Agentforce로 rule 기반·표준화된 대량 작업 자동화. skill·disability·certification·examination score 등 candidate 상세 capture. Einstein 기반 grant manager 요약. Employee Experience Cloud site 검색. permission set group/permission set 갱신, custom report.
- **Referral Marketing** — advocate와 referred friend에게 다양한 reward 제공.
- **Salesforce for Education** — 통합 course registration, registrar의 hold 정의·배치. Agentforce로 student recruitment. application stage별 specialized rubric, applicant의 선호 school/program 선택. advisor의 campus involvement 추적. gift planning 단일 플랫폼 통합.
- **Salesforce for Nonprofits** — Agentforce로 Fundraising의 philanthropic/wealth data 요약·인사이트. philanthropic research data(prospect profile·wealth assessment·milestone summary) 관리. Gift Entry Grid로 단건/배치 gift 입력. Gift Planning 객체. Program and Case Management referral 추적, 참가자 레코드에서 benefit 직접 로그, bulk ad hoc benefit disbursement. Grantmaking funding award requirement/disbursement 자동화, predefined 템플릿 progress report. 신규 Volunteer Management 데이터 모델 + Experience Cloud volunteer portal.
- **Vlocity Contract Lifecycle Management** — Summer '25 managed package 업그레이드 시 Document Generation 2.0 자동 활성화(in-app consent 불필요). Docgen Custom Fonts Library의 custom font 파일 크기 한도 증가(support request 필요).
- **Industries and Revenue Cloud Common Features** — 일부 Industries·Revenue Cloud 제품 공유 기능. Business Rules Engine 컴포넌트가 Partial/Developer/Developer Pro sandbox copy에서 사용 가능. Data Processing Engine이 Data Cloud 활용. Fundraising Gift Entry Grid. Grantmaking 자동화. Industry Integration Solutions(prebuilt MuleSoft). Process Compliance Navigator. Program and Case Management. Action Launcher·Actionable Relationship Center·Batch Management·Compliant Data Sharing·Interest Tags·Omnistudio Document Generation·Omnistudio for Industries·Rollup Definitions 개선.

---

## Media Cloud — Advertising Sales Management on Salesforce Platform (GA)

> PDF 원문 p690–692. 이 릴리즈 Industries 최대 GA 기능 중 하나.

Salesforce Platform 기반으로 광고 영업 비즈니스 전체를 Salesforce에서 운영한다. 외부 ad server 접근 관리, media property 관리, agency·advertiser 관계, product catalog 설계, pricing 전략, targeting 옵션 구성을 빠르게 처리한다. RFP에 맞춤 media plan으로 대응하고, media plan을 단일 워크스페이스에서 관리하며, 클릭 한 번으로 order로 변환한다.

세부 기능(전수):

- **Manage Ad Server Properties and Streamline Server Access** — 외부 ad server 인스턴스를 광고 유형별로 구분, custom ad server property(인증 프로토콜 등) 관리, role 기반 접근 제어.
- **Simplify the Management of Media Properties** — media channel·ad space·creative size 등 핵심 속성 관리. media channel ↔ ad space ↔ creative size 매핑.
- **Maximize Your Ad Portfolio's Impact with Product Catalog Management** — media property 기준 ad product 카탈로그, type별 분류, reusable product classification으로 대량 product 생성, tiered product bundle(광고 패키지).
- **Design Dynamic Pricing and Discounting Policies with Salesforce Pricing** — 업계 표준 pricing model, price book 통합, price impacting attribute로 discount, ad space·creative size·targeting option별 내장 discount.
- **Offer Robust Targeting Options to Advertisers and Agencies** — 다차원 targeting(demographic·hierarchical geographic), postal code 등 granular targeting, ad product별 preset targeting criteria.
- **Foster Trusted Relationships with Advertisers and Agencies** — advertiser·agency 정보 관리, party role relationship으로 agency-advertiser 연결, advertiser-brand 연계.
- **Create Campaigns for RFPs in No Time** — Intelligent Document Automation으로 RFP에서 캠페인 정보(budget·strategy·deal type·duration) 추출 → opportunity/ad opportunity 매핑.
- **Craft Comprehensive Media Plan on a Unified Workspace** — 단일 quote에서 media plan 전 측면 설계, Line Item Configuration 패널, 실시간 pricing 반영, media plan/targeting template, placement clone/copy.
- **Send Media Plans for Internal Audits and Contracting** — Advanced Approvals로 승인 워크플로(legal·creative·finance), Salesforce Contracts로 contract 생성·전송.
- **Convert Contracted Media Plans into Orders with a Single Click** — 승인·계약된 media plan에서 order 직접 생성.
- **Amend Orders Based on Campaign Performance and Feedback** — preflight·in-flight order amendment, 동일 승인/contracting 워크플로.
- **Optimize Business Processes with Prebuilt Integrations** — Dynamic Revenue Orchestrator, MuleSoft Direct app, Salesforce Flow action으로 외부 ad server 연동(코드 없이).
- **Tailor Media Plans and Processes Based on Company Requirements** — Ad Availability View Configuration 레코드/decision table, custom action, Salesforce Flow.

**Where:** Lightning Experience (PDF 원문 — 정확한 edition 목록은 PDF 해당 "Where" 행 참조).

### Media Cloud — Agentforce / Media Proposals (Beta)

> PDF 원문 p700–703.

- **Agentforce for Media** — 전 부서 일일 업무 자동화. 2025년 6월부터. Enterprise/Performance/Unlimited edition + Agentforce for Media add-on.
- **Craft Proposals with Curated Products to Expedite Deals (Beta)** — Ad Proposal Management Agentforce topic. 광고 캠페인 find/create, 요건 충족 media product 식별, proposal 생성. UI는 영어만.
- **Media Proposals (Beta)** — incoming RFP에 대한 전략을 명확히 전달하는 media proposal 생성, branded pitch deck 생성. 하위 Beta:
  - **Design Proposals Tailored to Your Advertiser's Campaign Objectives (Beta)** — advertiser 캠페인 목표 맞춤 proposal.
  - **Convey Your Value Proposition with Engaging Visual Presentations (Beta)** — pitch deck로 value proposition 전달.

> Media Proposals 관련 Agentforce action(Create Media Opportunity, Create Media Proposal, Find Media Opportunity, Get Media Products / Get Media Products Based on Targeting, Media Opportunity Summary)은 모두 Beta로 표기됨(PDF Salesforce Help 링크 기준).

---

## Net Zero Cloud — ESG / Carbon Accounting GA (3건)

> PDF 원문 p705–709. 이 릴리즈 Industries GA 5건 중 3건이 Net Zero Cloud에 집중.

### Enhance Scope 3 Emissions Calculations with Einstein Generative AI (GA)
procurement emissions factor set를 Scope 3 GHG 카테고리와 연결하고, procurement summary data를 emissions factor에 매칭한다. 기존 데이터를 grounding으로 사용해 Einstein이 GHG 카테고리를 제안한다. spent amount → Scope 3 emissions 변환·GHG 카테고리 분류 지원.

> PDF 원문: *"This feature, now generally available, includes some changes since the last release."*

**Where:** Lightning Experience — Enterprise, Performance, Unlimited, Developer edition. Net Zero Cloud Growth 라이선스 + Agentforce for Net Zero Cloud add-on 라이선스 필요.
**How:** Setup → Net Zero Settings → Einstein for Net Zero Cloud, Einstein for Carbon Accounting, Einstein for Scope 3 Procurement Hub 활성화.

### Search for and Draft ESG Reports (GA)
Microsoft 365 Word add-in(Salesforce Disclosure and Compliance Hub for Microsoft 365 Word) 또는 Google Docs add-on(Salesforce Disclosure and Compliance Hub Connector)에서 Einstein generative AI로 ESG 리포트 초안 작성. Einstein Search for Disclosures로 이전 연도 disclosure 리포트를 업로드해 generative AI가 답변 추천.

**Where:** Lightning Experience — Enterprise, Performance, Unlimited, Developer edition. Net Zero Cloud Growth 라이선스 + Agentforce for Net Zero Cloud add-on.
**How:** Word/Google Docs add-on 설치 → Setup → Disclosure and Compliance Hub Settings → Einstein for Disclosure Authoring 활성화.

### Generate First Draft of ESG Disclosure Automatically (GA)
Microsoft 365 Word add-in에서 Einstein generative AI로 ESG 리포트 초안 자동 생성. Einstein Search for Disclosures로 이전 연도 disclosure 업로드 → 분석 기반 답변 추천.

**Where:** Lightning Experience — Enterprise, Performance, Unlimited, Developer edition. Net Zero Cloud Growth 라이선스 + Agentforce for Net Zero Cloud add-on.

### Net Zero — 관련 비-GA 개선(요지)
- **Enhance Disclosure Reporting by Using Einstein Generative AI with Data Cloud** — Data Cloud의 vector database/hybrid search, near real-time file indexing, Google Drive·Microsoft SharePoint 소스 지원.
- **Insert Questions and Response Placeholders in Google Docs** — Disclosure and Compliance Hub Connector add-on으로 Google Docs에서 ESG disclosure 템플릿 설계(이미지·차트·sheet 포함).
- **Other Improvements for ESG Report Accuracy Assessment** — Google Docs에서 question guidance와 제안 응답 비교로 정확도 개선.

---

## Public Sector Solutions — Einstein Beta (4건)

> PDF 원문 p718–720. 4건 모두 Beta, Agentforce for Public Sector add-on 필요, **2025년 9월 1일 주(週)부터** 제공.

| Beta 기능 | 요지 | 기반 객체 |
|---|---|---|
| **Quickly Create a Summary of a Program and Its Benefits with Einstein (Beta)** | program과 benefit 요약(내부·외부 stakeholder 공유) | Program, Benefits |
| **Catch Up On Notes by Using Einstein (Beta)** | note 요약으로 미완료 action/task 식별 | Account, Interaction, Interaction Summaries |
| **Create a Funding Award Summary with Einstein (Beta)** | 현재 grant status 요약(engagement·disbursement·future award 결정용) | Funding Award, Funding Award Requirement, Indicator Performance Period, Indicator Results, Funding Disbursement |
| **Generate a Specialized Version of a Grant Application for Board Review (Beta)** | board member 검토용 간결한 grant application 버전 | Individual Application, Application Review |

**Where:** Lightning Experience — Enterprise, Performance, Unlimited edition (Public Sector Solutions 활성화 + Agentforce for Public Sector add-on).

### Public Sector — User Access Management 개선(요지)
persona 기반 permission set group 할당, 신규 standard permission set로 빠른 user access 설정, configuration error 감소·audit 개선.

---

## Consumer Goods Cloud — LWC Quick Actions (Beta) / KPI (Pilot)

> PDF 원문 p615·627–628.

### Customize Consumer Goods Cloud Mobile App Faster with LWC Quick Actions (Beta)
온라인 시나리오 커스터마이징을 Lightning Web Components(LWC)로 빠르게 하고 iOS 기기의 quick action과 통합. contract management·case handling 등 custom mobile process를 오프라인 모델링·data sync 없이 구현.

**Where:** Lightning Experience — Enterprise, Unlimited edition (Consumer Goods Cloud 활성화).
**How:** Sync Settings의 **Integrate LWC with CG offline mobile app** 설정으로 활성화. global/object-specific quick action 생성, visit의 account 상세 등 context 공유. 온라인 모드 로그인·sync 시 Quick Actions card가 모든 cockpit 페이지에 표시(별도 설정 없는 한).

### Ingest Key Performance Indicator (KPI) Data from Processing Services to Data Cloud (Pilot)
Trade Promotion Management(TPM) data connector로 Consumer Goods Processing Services에서 KPI 데이터를 Data Cloud로 직접 동기화. daily measure integer/real, promotion, payment tactic 객체의 KPI 데이터 취득. Data Explorer로 조회 또는 Query Editor로 SQL-like 쿼리 실행.

**Where:** Lightning Experience — Enterprise, Unlimited edition (Trade Promotion Management + Data Cloud).
**How:** Data Cloud setup에서 **Connectors (Beta)** 활성화 시 connector가 24시간 내 자동 설치.

### Consumer Goods — 기타 주요 개선(요지)
배송 중 수량 조정·현금/부분 결제(Enable Quantity Adjustments and Cash Collection), hybrid user persona(Drive Retail Execution During Delivery Visits), Bluetooth thermal printer 출력(3-inch endless paper, ESC/POS raster protocol), 단종 제품 leftover inventory actuals(lookback 1년=380일 / 2년=760일), forward buy 기반 uplift 예측.

---

## Salesforce for Nonprofits — Philanthropic Research in Agentforce (Beta)

> PDF 원문 p763. **2025년 7월 17일부터** 제공.

**Use Philanthropic Research Topics in Agentforce (Beta)** — prospect의 milestone·wealth capacity 요약, professional affiliation·philanthropic event 질의응답으로 맞춤 engagement 전략 수립.

**Where:** Lightning Experience — Enterprise, Unlimited, Developer edition (Education Cloud 라이선스 + 해당 Agentforce add-on 라이선스).
**How:** Setup → Fundraising Settings → Access Fundraising Research in Agentforce (Default) → **Philanthropic Research Topics in Agentforce (Beta)** 활성화.

---

## Industries Common (공통 기능)

> PDF 원문 p751–768. "Industries and Revenue Cloud Common Features". 여러 산업 클라우드가 공유하는 기능. Cross-Object Field History GA를 여기에서 단일 항목으로 정리한다.

### Cross-Object Field History (Generally Available)
관련 객체 전반의 필드 변경을 단일 뷰에서 추적·시각화. Cross-Object Field History Lightning web component로 각 레코드를 개별 확인하지 않고 여러 객체(예: Know Your Customer, Business Relationship Plan 같은 복잡한 데이터 모델)의 변경을 추적. 변경 auditability 개선.

> PDF 원문: *"Cross-Object Field History is now generally available with some improvements."*

**Where:** Lightning Experience — Enterprise, Unlimited, Developer edition.
**How:** Setup → **Cross-Object Field History Settings** 검색 → Cross-Object Field History 활성화 → **Cross-Object Field History Graphs builder**로 추적 대상 객체 설정.

> 이 기능은 Automotive Cloud·Financial Services Cloud 등 여러 산업 섹션에 동일하게 재등장하지만 동일 기능이므로 dedup해 한 번만 기재한다.

### 기타 Industries Common 기능(요지)
- **Data Consumption Framework** — integration definition template로 Equifax 통합(consumer credit history). 미국 Equifax Credit Scoring 서비스 대상.
- **Data Processing Engine** — Data Cloud 기반 복잡 데이터 처리. slice node, Explode/Sequence 함수, "Update only changed records" 옵션, composite writeback node(단일 트랜잭션 다중 관련 엔티티 기록), non-editable field에 대한 Upsert action.
- **Discovery Framework** — assessment 초안 저장, 통합 assessment 뷰.
- **Einstein Summary** — AI summary에서 바로 action, AI agent로 follow-up.
- **Fundraising** — Gift Entry Grid, Gift Planning 객체.
- **Grantmaking** — funding award requirement/disbursement 생성·스케줄 자동화, predefined 템플릿 progress report.
- **Industries CPQ** — Order Overview 페이지, Omnistudio for Managed Packages 배포, Classic/Standard Cart API 개선, Get Cart Products API, Replace Offers API.
- **Industry Integration Solutions** — prebuilt MuleSoft Direct asset 구성.
- **Interest Tags** — sharing rule로 Tag Category 공유 확장.
- **Omnistudio Document Generation / Omnistudio for Industries / Connect REST APIs** — Document Generation 2.0 자동 활성화, Data Mapper/Integration Procedure 실행·캐시 클리어.
- **Program and Case Management** — 조직 내부 referral 추적, 참가자 레코드 기반 benefit disbursement, bulk off-schedule/ad hoc disbursement.
- **Rollup Definitions / Stage Management / Unified Catalog / Action Launcher / Action Plans** — 다중 record rollup, template 기반 stage definition, 중앙 product/service 카탈로그(Unified Catalog), Action Launcher의 Unified Catalog 지원, predefined action plan template.

### Apex / Invocable Action 참고
PDF Industries 섹션에는 새 Apex 네임스페이스 reference보다 **invocable action**과 객체 변경이 주로 등장한다. 예: Communications Cloud의 Industries CPQ는 agentic flow에서 cart operation을 invocable action으로 자동화한다.

```apex
// 구조 예시 — 실제 동작 코드 아님 (PDF는 Apex 시그니처가 아니라 setup 절차를 기술)
// PDF 원문(p1610–1634): Industries CPQ의 cart/order 작업을 custom Apex 없이
// invocable action으로 수행. Setup의 Custom Settings에 CpqCartAgentInvocableAction
// 파라미터를 추가하고 값을 설정해 활성화한다.
//   "...directly with Agentforce, eliminating the need for custom Apex.
//    Create agent actions by using the invocable action..."
```

> PDF 원문 인용: *"Automate Cart Operations by Using Invocable Actions for Agentic Flows ... eliminating the need for custom Apex."* — 별도 동작 Apex 코드 블록은 PDF에 없으며, 이 노트는 설정 파라미터(`CpqCartAgentInvocableAction`)와 절차만 인용한다. fabricate된 메서드 시그니처는 포함하지 않는다.

---

## 기타 산업 (GA/Beta 없음 — 산업별 기능 요지)

> 정식 GA/Beta/Pilot 등급이 없는 산업 클라우드의 Summer '25 변경 요지(depth balance를 위해 한 섹션으로 묶음). 각 산업의 상세 "New and Changed Objects"·setup 절차는 PDF 해당 페이지 참조.

- **Asset Management** — Work Order Estimation(Partner Community), Advanced Exchange(빠른 반품·교체), Depot Repair, Timesheets & Labor Cost Optimization(대량 타임시트·차량 시간 할당). 신규 객체: `ServiceResourceLeaveBalance`, `ServiceResourceLeaveBalanceHistory`, `ServiceResourceCostRule`의 `RuleType`(`TimesheetEntryItemCalculation`)·`StandardApexClass` 필드.
- **Automotive Cloud** — Agentforce for Automotive(Asset Finance Management·Asset Service Management·Industries Customer Engagement 에이전트), 공공 민원 capture, rehashing 최적화. Agentforce 일부 기능 2025년 6월 17일부터, 영어만.
- **B2B Referral Management** — invocable action 기반 referral 자동화, Flow Builder/Connect API의 B2B Referral Event action.
- **Channel Revenue Management** — Channel Partner Inventory Tracking(Adjust Partner Unsold Inventory invocable action), Ship and Debit Process Management, decision table CSV 다운로드.
- **Communications Cloud** — Communications Cloud Agent Console, Communications Cloud Sales, Communications Cloud TM Forum API, Industries CPQ invocable cart action, Enterprise Sales Management.
- **Energy and Utilities Cloud** — 월별 소비 추적, 대량 타임시트, 모바일 워커 차량 검색·usage 할당.
- **Financial Services Cloud** — Salesforce Go, API 실시간 client 새로고침, standard object 기반 financial plan/goal, 근실시간 household 새로고침, loan origination 통합, Cancel Insurance Policy service process.
- **Health Cloud** — Agentforce for Contact Center / Public Health / Home Health, Disease Surveillance·Case Classification, waitlist management·time zone 예약.
- **Insurance** — 다수 정책 일괄 갱신/취소, producer split arrangement flat amount, rounded commission 필드.
- **Life Sciences Cloud** — Advanced Therapy Management orchestrator, stalled stage/step 수동 재시작, research study, Site Selection console app.
- **Loyalty Management** — Agentforce topic promotion, interest/affinity club, point 전송, rule action field alias.
- **Manufacturing Cloud** — sales agreement configured product 수량, depot repair·advanced exchange.
- **Referral Marketing** — advocate·referred friend reward.
- **Salesforce for Education** — 통합 course registration, registrar hold, Agentforce student recruitment, stage별 rubric, gift planning. 신규 객체: `AcademicTermRgstrTimeline` 필드 확장, `AcadTermEnrlPolicyRuleLog` 등.
- **Salesforce for Nonprofits (비-Beta 부분)** — Gift Entry Grid, Gift Planning 객체, Program and Case Management referral 추적, bulk benefit disbursement, Grantmaking 자동화, Volunteer Management 데이터 모델 + Experience Cloud volunteer portal.
- **Vlocity Contract Lifecycle Management** — Document Generation 2.0 자동 활성화, Docgen Custom Fonts 파일 크기 한도 증가.

---

## 관련 노트

- [[Summer '25]] — Summer '25 릴리즈 전체 진입점
- [[Summer '25/Clouds]] — 일반 클라우드(Sales/Service/Experience/Commerce 등) peer 노트 *(생성 예정)*
- [[Summer '25/Agentforce]] — 산업별 Agentforce 연계(Agentforce for Media·Automotive·Public Sector·Net Zero 등)
- [[Summer '25/Development]] — 개발자 변경(Apex·LWC·API)
- [[Summer '25/Release Updates]] — Release Updates
