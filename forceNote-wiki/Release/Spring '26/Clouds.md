---
tags: [release, spring_26, clouds]
source: salesforce_release_notes_6-13-2026.pdf (Salesforce Spring '26 Release Notes, Tier 2)
created: 2026-06-15
aliases: [Spring 26 Clouds, 스프링26 클라우드, Spring '26 Clouds, Spring26 Cloud Release Notes, 스프링26 클라우드 릴리즈, 클라우드별 GA]
---

# Spring '26 — Clouds

> Spring '26(v66.0) 릴리즈 노트의 클라우드별(제품군별) 변경 사항 — Analytics·Commerce·Data 360·Experience Cloud·Field Service·Industries·Marketing·MuleSoft·Omnistudio·Partner·Revenue Management·Sales·CMS·Slack·Service의 GA 전수 + Beta/Pilot + 개발자 Connect API.

> [!note] 이 릴리즈부터 다수 제품군이 **Agentforce** 브랜드로 이름이 바뀌었다(원문 기준).
> Sales Cloud → **Agentforce Sales** · Service Cloud → **Agentforce Service** · Field Service → **Agentforce Field Service** · Commerce → **Agentforce Commerce** · Revenue Cloud → **Agentforce Revenue Management** · Data Cloud → **Data 360** · Retail Cloud Modern POS → **Point of Sale** · Service Cloud Voice → **Salesforce Voice with Telephony Providers** · Sidebar Extensions → **Extensions in CMS**.

---

## 범위 안내

이 노트는 릴리즈 노트의 **제품/클라우드 영역**만 다룬다. 아래는 다른 하위 노트 소관이라 여기 포함하지 않는다.

- GraphQL **mutations** GA → [[Spring '26/Development]]
- Database Encryption GA(worldwide), Login Anomaly event → [[Spring '26/Platform]] (Security)
- "Simplify Testing with a Default Domain (GA)", "MuleSoft for Flow: IDP (GA)" → [[Spring '26/Platform]]

---

## Analytics (Tableau Next / CRM Analytics / Data 360 분석) — GA 5 · Beta 10

### GA (5)

1. **Upload Excel Files Directly to Your Tableau Next Workspace** (p.272/274) — Tableau Next 워크스페이스에 XLSX 파일을 직접 업로드. **최대 100MB·500열**. GA: April 2026.
   > PDF 원문(p.811/927): "You can upload files up to 100 MB and 500 columns"
2. **Generate Answers Directly from Tableau Next with MCP Server** (p.274/311) — MCP(Model Context Protocol) 서버로 Tableau Next에서 직접 답변 생성. GA: April 2026.
3. **Use Existing Report Settings When Adding Tables to Dashboards** (p.314) — 대시보드에 테이블 추가 시 기존 리포트 설정을 그대로 사용.
4. **Use CRM Analytics Datasets in Data 360** (p.322/323) — CRM Analytics 데이터셋을 Data 360에서 사용.
5. **Control Access to Data Based on a User's Assigned Territories** (p.322/325) — 사용자에게 할당된 영역(territory) 기준으로 데이터 접근 제어. predicate 사용.
   ```
   // 소스 발췌 (PDF p.2608) — security predicate
   'Territory2.TerritoryIDs' in ["$UserTerritory2Ids"]
   ```

### Beta (10)

- **CSI Score** — Customer Satisfaction Index 점수 (Beta).
- **Monitor Your Data Objects and Connections in Tableau Next** — Tableau Next에서 데이터 객체·연결 모니터링 (Beta). *(Data 360 영역과 중복 게재)*
- **Accelerate Your Insights with Metrics Templates in the Marketplace** — 마켓플레이스의 메트릭 템플릿 (Beta).
- **Unlock Account Growth or Service-Risk Insights with New Tableau Next Metric Templates** — 신규 Tableau Next 메트릭 템플릿 (Beta).
- **Create Semantic Models Faster with Auto-Generation** — 시맨틱 모델 자동 생성 (Beta).
- **Resolve Similar Meanings to Improve Agent Accuracy** — 유사 의미 해소로 에이전트 정확도 향상 (Beta).
- **Stay Informed with Inspector Proactive Data Alerts for Tableau Next in Slack** — Slack에서 Tableau Next Inspector 사전 데이터 알림 (Beta).
- **Embed Custom Lightning Web Components in Dashboards** (p.315) — 대시보드에 커스텀 LWC 임베드 (Beta).
- **Speed Up Queries with Data 360 SQL** (p.320) — Data 360 SQL로 쿼리 가속 (Beta).
- **Improve Write to Data 360 Output Performance** (p.326) — Data 360 출력 쓰기 성능 개선 (Beta).

---

## Commerce (Agentforce Commerce) — GA 0 · Pilot 1

이 영역은 GA 항목이 없다. 주요 enhancement는 GA/Beta 미표기로 출시된다.

### Pilot (1)

- **Resolve Fulfillment Issues Proactively with Agentforce** (p.454/455, Order Management) — Agentforce로 이행(fulfillment) 문제를 사전 해결 (Pilot).

### 개발자 항목

- **Control the Order of Payment Capture** (p.455)
  > PDF 원문: "You can now add an action element to the **Ensure Funds Async flow** or implement your own default payment sequence using **Apex** to rank payment summaries and specify capture amounts."

### 주요 enhancement (GA/Beta 미표기)

- **Let Buyers Request a Quote from Their Cart** (p.444) — 카트에서 견적 요청. 신규 **Request Quote** 컴포넌트.
- **Extend B2B Store Pricing Rules with Custom Context Definitions** (p.445) — `CommerceCartContextDefinition` 으로 B2B 가격 규칙 컨텍스트 확장.
- **New and Changed Commerce LWR Store Components** (p.446) — New: **Request Quote** / Changed: **Order Amount**, **Order Promotions Summary**, **Payment Summary**.
- **Product Catalogs** (p.447) — 카탈로그 100개 searchable + filterable.
- **Predictive Product Suggestions** (p.448) — 예측 상품 추천.
- **Synonym Rules** — 동의어 규칙.
- **Multi-Language B2B Guided Shopping Agent** — 다국어 B2B 가이드 쇼핑 에이전트.
- **Omnichannel Inventory: Safety Stock Caps** (p.453) — 안전 재고 상한.
- **Order Management** (p.454) — **Monitor AI-Generated Insights** 대시보드 (available March 10, 2026) · **Manage Locations in Shipping Methods**.

---

## Data 360 (구 Data Cloud) — GA 8 · Beta 7+

### GA (8)

1. **Connect to More Unstructured Data Sources** (p.501) — GitHub·Jira·Helpjuice·Adobe Experience Manager(AEM)를 프로덕션 Data 360에 통합. GA: April 2026.
2. **Ingest Site Pages and Site Assets into Data 360** (p.501) — 사이트 페이지·자산을 Data 360에 수집.
3. **Ingest Unstructured Documents with Microsoft SharePoint Unstructured Data (Documents) Connector** (p.501) — SharePoint 비정형 문서 커넥터로 수집.
4. **Connect to Databricks on Azure with Private Connect** (p.503) — Private Connect로 Azure의 Databricks 인스턴스와 직접·보안 네트워크 경로(PNR) 구성. **GA: April 2026** (헤더에 "Generally Available", 본문 "This feature is Generally Available (GA) starting in April 2026").
   > Snowflake와 Databricks 둘 다 Azure에서 Private Connect(PNR)를 지원하지만 **GA는 Databricks만 해당**(April 2026). Snowflake on Azure(p.503, "Connect to Snowflake on Azure with Private Connect")는 헤더에 GA 표기가 없고 본문이 "This change **starts in January 2026**"으로만 적혀 있어 **GA 아닌 일반 change(Jan 2026)** 로 분류 — 아래 "주요 change" 참조.
5. **Fine-Tune, Test, and Optimize Retrievers in Retriever Playground** (p.520/522) — Retriever Playground에서 retriever 파인튜닝·테스트·최적화. Feb/Mar 2026. Government Cloud 제외.
6. **Data 360 Clean Rooms Are Now Generally Available** (p.525) — Clean Rooms GA. Jan 2026. Government Cloud 제외.
7. **Build Cross-Channel Journeys Using API Activations in Data 360** (p.526/531) — API Activation으로 크로스채널 여정 구성. April 2026.
8. **Research and Analyze Enterprise Content with Data 360 Notebook AI** (p.533/534) — Notebook AI로 엔터프라이즈 콘텐츠 리서치·분석. Feb 2026. Government Cloud 제외.

### 주요 change (GA 미표기)

- **Connect to Snowflake on Azure with Private Connect** (p.503) — Private Connect로 Azure의 Snowflake/Databricks 인스턴스와 직접·보안 네트워크 경로 구성(PNR). 출시: January 2026. **GA 표기 없는 일반 change** (헤더에 "(Generally Available)" 없음, 본문 "This change starts in January 2026").

### Beta (7+)

- **Streamline Your Tasks with New Data 360 Navigation** (Beta).
- **Create Batch Data Transforms by Using Custom Code with Code Extension** — Python 커스텀 코드로 배치 데이터 변환 (Beta).
- **Extend Data 360 by Using Custom Code with Code Extension** (Beta).
- **Deploy Code Extension Components Using Data Kits** (p.525/528) — Data Kit으로 Code Extension 컴포넌트 배포 (Beta).
- **Trigger Data 360 Activations Directly from a Flow** (p.526/530) — Flow에서 Data 360 Activation 직접 트리거 (Beta).
- **multiclass model type** — 모델 타입에 multiclass 추가 (binary·regression·multiclass) (Beta).
- **Monitor Your Data Objects and Connections in Tableau Next** — *(Analytics 영역과 중복)* (Beta).

---

## Experience Cloud — GA 2 · Beta 2

### GA (2)

1. **Create Custom Property Types and Editors for LWC in Aura and LWR Sites** (p.679) — Aura·LWR 사이트의 LWC용 커스텀 속성 타입·에디터 생성. 신규 **`LightningTypeBundle`** 사용(업데이트 지원). `editor.json` 을 `experienceBuilder` 폴더에 배치.
   > PDF 원문(p.526–532): 이전 beta의 `ExperiencePropertyTypeBundle` 은 업데이트를 허용하지 않았다. 기존 `ExperiencePropertyTypeBundle` 을 쓰던 경우 새 `LightningTypeBundle` 로 **교체 후 재배포**를 권장.
2. **Quickly Develop LWC in a Real-Time Preview of Your LWR Site** (p.680) — LWR 사이트 실시간 프리뷰로 LWC 개발(Local Dev). Spring '26부터 `sf lightning dev site` 명령은 **`--ssr` 플래그 미지원**.

### Beta (2)

- **Protect Your Salesforce Org by Scanning Files for Malware** (p.685) — 파일 멀웨어 스캔. 권한: **Manage Malicious Files Beta**, **Download Malicious Files Beta** (Beta).
- **Launch a Flow When a User Changes a File** — 파일 변경 시 Flow 실행 (Beta).

> GraphQL **mutations** GA는 Development 소관 → [[Spring '26/Development]].

---

## Field Service (Agentforce Field Service) — GA 5 · Beta 2

### GA (5)

1. **Workforce Scheduling** (p.690) — 인력 스케줄링(개요).
2. **Automate Hands-Free Data Entry with Data Capture Voice to Form** (p.706/708) — 음성→폼 자동 데이터 입력(STT + LLM). 신규 **LLM Context** field.
3. **Experience Faster Dispatching with Enhanced Live Updates** (p.715) — 디스패칭 라이브 업데이트 가속. **15–20초 → 3초 미만**.
4. **Optimize Large Datasets with Dynamic Scaling** (p.716/717) — 동적 스케일링으로 대규모 데이터셋 최적화.
5. **Access Optimization Request Files on Your Own** (p.717/718) — 최적화 요청 파일 직접 접근.

### Beta (2)

- **Drive Intelligent Operations with Enhanced Scheduling and Optimization Insights** (p.715) (Beta).
- **Get More Transparency into Service Operation Inefficiencies with Rule Violation Analytics** (p.716/719) (Beta).

---

## Industries (산업 클라우드) — GA 1 · Beta ~6 · Pilot 3

### 다루는 산업 클라우드 (개요 전수)

Automotive · Channel Revenue Management · Communications(→ Revenue Cloud for Communications) · Consumer Goods · Education · Energy & Utilities · Financial Services Cloud(FSC) · Health · Insurance · Life Sciences · Manufacturing · Media · Net Zero · Public Sector · Nonprofits · Industries Common Features.

### GA (1)

1. **Get In-App Agent Assistance with Agentforce** (p.764, Consumer Goods Cloud) — 인앱 Agentforce 에이전트 지원.

### Beta / Pilot

- **Self-Service Donor Support Agent** (Beta, Nonprofit)
- **Student Recruitment Agent** (Beta, Education)
- **Transfer Credit Agent for Education Cloud** (Beta)
- **Anypoint Connector for Blackboard · D2L Brightspace · Moodle** (Beta)
- **Store Check** (Pilot, Consumer Goods)
- **Remote Engagement with Microsoft Teams** (Pilot)
- **Generate Quotes for Customers in Multiple Locations** (Pilot, Media)

### 개발자 — Insurance Connect API (p.846–850, v66.0)

**Changed Connect REST API**
- Insurance Quoting: `POST /connect/insurance/product-rating/get-rating-input` — New request body: *Product Rating Request Input* / New response body: *Product Rating Details Response*.
- `GET /connect/insurance/quotes/{quoteId}` — `connectDynamicParameters` 요청 파라미터에 신규 값 **`includeClause`** 추가(판매 거래 항목의 product clause를 응답에 포함).
- **v66.0 이상 deprecated 속성:** `sameCarrier` (Insurance Policy Renew Input), `pricingProcedure`.

**New Connect in Apex Methods** (기존 클래스에 추가)

```apex
// 소스 발췌 (PDF p.849–850) — verbatim method signatures

// ConnectApi.InsuranceBrokerageFamily
createBillingSchedulesFromTransaction(InsuranceTransactionBillingInput)
//   input : ConnectApi.InsuranceTransactionBillingInputRepresentation
//   output: ConnectApi.InsuranceTransactionBillingOutputRepresentation

// ConnectApi.InsuranceClaimFamily
EditClaimCoveragePaymentDetail(EditClaimCoveragePaymentDetailInput, claimId, coverageId, paymentDetailId)
//   input : ConnectApi.EditClaimCvrPaymentDetailInputRep
//   output: ConnectApi.EditClaimCoveragePaymentDetailRep
PayExGratiaClaimCvrPaymentDetail(claimId, coverageId, paymentDetailId, PayExGratiaClaimCvrPaymentDetailInput)
//   input : ConnectApi.PayExGratiaClaimCvrPaymentDetailInputRep
//   output: ConnectApi.PayExGratiaClaimCvrPaymentDetailRep
RecalculateAdjustments(claimId, coverageId, RecalculateAdjustmentsInput)
//   input : ConnectApi.RecalculateAdjustmentsInputRep

// ConnectApi.InsurancePolicyAdminFamily  (output 공통: ConnectApi.PolicyAsyncRepresentation)
MultiRootIssuePolicy(IssuePolicyInput)
MultiRootEndorsePolicy(EndorsePolicyInput, policyId)
MultiRootRenewPolicy(RenewPolicyInput, policyId)
```

---

## Marketing — GA 0 · Pilot 1

### Pilot (1)

- **Grab Customers' Attention with Flash Notifications** (p.968) — 플래시 알림 (Pilot).

### 개발자 — Loyalty Management (p.1005–1007)

- **New Objects:** Loyalty Program Member Linked Partner · Digital Pass Template · Digital Pass Template Parameter · Digital Pass.
- **Changed Objects:**
  - *Loyalty Ledger Traceability* — `ProcessingStatus`, `ProcessingSequenceInfo`
  - *Loyalty Program Partner* — `IsMemberLinkingAllowed`, `MemberLinkingEffStartDate`, `MemberLinkingEffEndDate`
- **Changed Metadata:** `IndustriesUnifiedPromotionsSettings`.`enableGlobalPromotionsForRevenueCloud`.
- **New Invocable Actions:** `issueDigitalPass` · `mapTraceablePtForRedemTrxn` · `refreshDigitalPass`.
- **Connect REST:** member link/unlink, `journalCreationMode` enum.

---

## MuleSoft — GA 2 · Beta 3

### GA (2)

1. **View Apex REST APIs in API Catalog and Activate Actions** (p.1010) — API Catalog에서 Apex REST API 조회·액션 활성화.
2. **View AuraEnabled APIs in API Catalog and Activate Actions** (p.1010) — API Catalog에서 AuraEnabled API 조회·액션 활성화.

### Beta (3)

- **Bring MuleSoft MCP Servers into API Catalog** (Beta).
- **View Manually Registered External MCP Servers in API Catalog** (Beta).
- **View Named Query APIs in API Catalog and Activate Actions** (p.1010) — API Catalog에서 Named Query API 조회·액션 활성화. Named Query API support가 **여전히 beta**("which remains in beta") — Agentforce에서 action으로 사용 (Beta).

---

## Omnistudio — GA 1 · Pilot 1

### GA (1)

1. **Enhance Your Experience Cloud LWR Sites with Flexcards and Omniscripts** (p.1025) — Experience Cloud LWR 사이트에 FlexCard·OmniScript 활용.

### Pilot (1)

- **Omnistudio Assistance AI Agent** (p.1029) (Pilot).

### 주요 enhancement

- **Omnistudio Migration Assistant** — CLI 플러그인 (v2.0.0-rc.59+).
- **Enforced Security Checks** · **UTAM UI Testing** · **Accessibility (WCAG 2.2)** · **Is Null Operator in Data Mappers**.

---

## Partner Cloud — GA 1

### GA (1)

1. **Create and Track Joint Business Plans with Your Partners** (p.1033/1034) — 파트너와 공동 비즈니스 플랜 생성·추적(now generally available). joint account plan record type 사용.

---

## Revenue Management (Agentforce Revenue Management) — GA 0 · Beta 1 · Pilot 1

### Beta (1)

- **Promotions in Agentforce Revenue Management** (p.1035/1041) (Beta).

### Pilot (1)

- **Automate Consistent Line Item Sequencing on Quotes and Orders** (p.1096) (Pilot).

### 개발자 — Billing Connect / Metadata / Invocable (verbatim)

**Changed Connect in Apex**
```apex
// 소스 발췌 (PDF p.1100대) — verbatim
ConnectApi.BillingAdvanced.voidPostedCreditMemo(voidPostedCreditMemoInputRepresentation)
//   output: ConnectApi.VoidPostedCreditMemoOutputRepresentation
ConnectApi.CalculateTaxRequest.isHeaderTaxRequested   // true 시 tax engine에서 header tax 활성화
```

**Changed Metadata — `BillingSettings`** 신규 필드:
`enableCreditMemoSequenceService` · `enableFailedPaymentsRetry` · `enableBillingDisputeManagement` · `ruleBasedCrAndPymtAppln`.

**`FlowActionCall.actionType` 신규 값:**
`blngDsptIssueCreditMemo` · `blngSvcExtendInvoiceDueDate` · `blngSvcSuspendBilling` · `blngSvcUpdateBillToContact`.

**New Invocable Actions (7개):**
`applyPaymentsAndCreditsByRules` · `voidPostedCreditMemo` · `generateStatementOfAccount` · `blngDsptIssueCreditMemo` · `blngSvcExtendInvoiceDueDate` · `blngSvcSuspendBilling` · `blngSvcUpdateBillToContact`.

**Promotions Connect REST:**
`POST /revenue/transaction-management/sales-transactions/actions/get-eligible-promotions`.

---

## Sales (Agentforce Sales) — GA 0 · Beta 4

### Beta (4)

- **Get Product Recommendations While Adding Products** — 상품 추가 시 추천 (Beta).
- **Manage Deals Directly from the Agentforce Sales App in ChatGPT** (p.1133) — ChatGPT 내 Agentforce Sales 앱에서 거래 관리. Dec 17, 2025. English only. (Beta).
- **Control User Access to the Agentforce Sales App in ChatGPT** (p.1134) — 권한: **Agentforce Sales ChatGPT App User** (Beta).
- **Manage Sales Strategy and Update Records Directly in Gemini** (p.1134) — Gemini에서 세일즈 전략 관리·레코드 업데이트. April 22, 2026 (Beta).

### 주요 enhancement (GA/Beta 미표기)

- **Set Unique Thresholds for Automatic Contact Creation** (p.1166) — 자동 연락처 생성 임계값(min 1 / max 10 / 기본 3).
- **Enhance Contact Records Automatically with Sync Email as Salesforce Activity** (p.1166).

---

## Salesforce CMS — GA 0 · Beta 1

### Beta (1)

- **Use the CMS Base (Beta) Data Kit to Ingest Content into Data 360** (p.1184) — CMS Base Data Kit으로 콘텐츠를 Data 360에 수집 (Beta).

### 주요 enhancement

- **Improved Extensions in Salesforce CMS** (구 Sidebar Extensions, p.1183).
- **Take Control of Assets from External Content Providers**.
- **Use Data Model Objects for CMS Content**.

---

## Salesforce for Slack Integrations (p.1187)

포인터 섹션 — Spring '26 릴리즈 노트 본문에 콘텐츠 항목이 없다. Slack 변경 사항은 **별도 Slack 릴리즈 노트 참조**.

---

## Service (Agentforce Service) — GA 2 · Beta 2

### GA (2)

1. **Elevate Your Knowledge Experience with Salesforce Enterprise Knowledge** (p.1324) — Enterprise Knowledge로 지식 경험 강화.
2. **Organize Articles and Improve Navigation with Knowledge Maps** (p.1325) — Knowledge Maps로 아티클 구성·내비게이션 개선.

### Beta (2)

- **Use Voicemail Drop for Outbound Calls** (p.1240) — 아웃바운드 콜 음성메일 드롭 (Beta).
- **Clean Up Messaging Session List Views without Disrupting Conversation History** (p.1247) — 대화 이력을 손상하지 않고 메시징 세션 리스트 뷰 정리 (Beta).

### 은퇴(Retired)

- **Work Summaries for Case (Beta) Is Being Retired** — 2026-06-30 은퇴.

### 개발자

- **Agentforce IT Service** — New/Changed Objects · **CMDB GraphQL APIs** (query / search / manage configuration items).
- **Messaging** — Dynamic WhatsApp Messaging Content via Apex-based form.

> 이름 변경: Service Cloud → **Agentforce Service** · Service Cloud Voice → **Salesforce Voice with Telephony Providers**.

---

## 도메인별 집계

| 도메인 | GA | Beta | Pilot |
|---|---|---|---|
| Analytics | 5 | 10 | 0 |
| Commerce | 0 | 0 | 1 |
| Data 360 | 8 | 7+ | 0 |
| Experience Cloud | 2 | 2 | 0 |
| Field Service | 5 | 2 | 0 |
| Industries | 1 | ~6 | 3 |
| Marketing | 0 | 0 | 1 |
| MuleSoft | 2 | 3 | 0 |
| Omnistudio | 1 | 0 | 1 |
| Partner Cloud | 1 | 0 | 0 |
| Revenue Management | 0 | 1 | 1 |
| Sales | 0 | 4 | 0 |
| Salesforce CMS | 0 | 1 | 0 |
| Slack | — | — | — |
| Service | 2 | 2 | 0 |
| **합계** | **27** | **38+** | **7** |

---

## 관련 노트

- [[Spring '26]] — 허브
- [[Spring '26/index]] — 폴더 인덱스
- [[Spring '26/Development]] — 개발자 영역(GraphQL mutations 등)
- [[Spring '26/Platform]] — 플랫폼·보안 영역
- [[Spring '26/Agentforce]] — Agentforce 영역
- [[Spring '26/Release Updates]] — Release Updates
- [[Release MOC]]
