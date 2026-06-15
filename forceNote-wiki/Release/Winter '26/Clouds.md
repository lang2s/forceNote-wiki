---
tags: [release, winter_26, clouds, sales, service, commerce, data360, analytics, industries]
api_version: v65.0
release_date: 2025-10
created: 2026-06-15
source: salesforce_release_notes_5-17-2026 (2).pdf (Salesforce Winter '26 Release Notes, Tier 2)
aliases: [Winter '26 Clouds, 윈터26 클라우드, Data Cloud Data 360 rebrand, Tableau Next Embedding SDK GA, Sales Cloud, Service Cloud, Commerce Cloud, Industries]
---

# Winter '26 — Clouds (Sales · Service · Commerce · Data 360 · Analytics · Industries 등)

> Winter '26(v65.0) 클라우드 제품 영역의 GA·핵심 신기능 — Data Cloud→Data 360 리브랜드, Tableau Next Embedding SDK(GA), Sales/Service/Commerce/Field Service/Industries/Marketing/Revenue Cloud의 정식 출시 기능을 클라우드별로 정리.

---

## 개요 — 상위/형제 라우팅 + GA 일람

| 라우팅 | 노트 |
|---|---|
| 상위 허브 | [[Winter '26]] |
| 형제 — 개발자 | [[Winter '26/Development]] (Apex·LWC·API) |
| 형제 — 플랫폼 | [[Winter '26/Platform]] |
| 형제 — AI 에이전트 | [[Winter '26/Agentforce]] (Einstein·Agentforce) |
| 형제 — 릴리즈 업데이트 | [[Winter '26/Release Updates]] (강제 적용 일정) |

> [!note] Data Cloud → Data 360 리브랜드
> **2025-10-14부로 Data Cloud는 Data 360으로 리브랜드되었다.** PDF 원문: *"As of October 14, 2025, Data Cloud has been rebranded to Data 360. During this transition, you may see references to Data Cloud... functionality and content remains unchanged."* 전환 기간 동안 "Data Cloud" 표기가 일부 남아있을 수 있으며 기능·콘텐츠는 동일하다. Winter '26 릴리즈는 **2025년 9월~12월**의 업데이트를 포함한다.

### 전 클라우드 "(Generally Available)" 마커 일람 (PDF 제목 텍스트 전수)

| 클라우드 | GA 항목 |
|---|---|
| **Analytics** | Embed Tableau Next Assets with Embedding SDK · Suggest Pane · Reference Lines · Size Encoding |
| **Data 360** | Image Processing in Search Index · Share Data Between Data Cloud Orgs · Activation-Triggered Flow |
| **Industries** | Telemetry Definition and Action Management (Automotive) · CG Cloud mobile LWC integration |
| **Sales** | Autonomously Capture Leads and Schedule Meetings (Inbound Lead Generation) |
| **Service** | Real-Time Translations · Telephony Usage Report · Simplified SLA Management Setup · **Agentforce IT Service** |
| Commerce · Experience Cloud · Field Service · Marketing · Revenue Cloud | 추출 범위 내 명시적 "(Generally Available)" 마커 없음 — 주요 변경은 enhancement / rename / Release Update / 리브랜드 |

> **추출 범위 메모(researcher):** Industries(278p)·Service(150p)는 도입부 + GA 마커 페이지를 표적 추출했다. 산업별·채널별 세부 enhancement 전부는 본 노트 범위 밖이며, 필요 시 해당 절을 별도 추출한다(아래 각 절에 "PDF 미확인(범위 외)" 표기).

---

## Analytics

CRM Analytics · Tableau Next · Lightning Reports/Dashboards · Data Cloud Reports · Tableau · Marketing Cloud Intelligence를 포함한다.

### GA 항목 (전수)
| GA 항목 (Generally Available) | 핵심 1줄 |
|---|---|
| **Embed Tableau Next Assets in Your App with the Embedding SDK** | Tableau Next Embedding SDK로 대시보드·시각화·메트릭 컴포넌트를 외부 웹앱에 임베드. **Dec 2025 GA**; 베타 대비 변경 — 한 웹페이지에 **여러 Salesforce org**의 컴포넌트 임베드 가능. External Client App(ECA) 필요. |
| **Accelerate Your Analysis in Tableau Next with the Suggest Pane** | Suggest Pane으로 분석 가속(Sep–Oct '25 월별표). |
| **Add Reference Lines to Compare Data Visually** | 시각적 데이터 비교용 참조선 추가. |
| **Use Size Encoding for Data Clarity and Visual Appeal** | 크기 인코딩으로 데이터 명확성·시각적 표현. |

### Beta 핵심
| Beta 항목 | 한 줄 |
|---|---|
| Analyze and Act on External Data Sources with Connectors in Tableau Next | 신규 커넥터를 출시 즉시 테스트·구현. Data 360 Setup→Feature Manager에서 Connectors(Beta) 활성화. |
| Evaluate and Refine Semantic Models with Semantic Model Optimization | Concierge: Analytics Q&A 같은 분석 에이전트용 시맨틱 모델 품질 평가·진단·해결 가이드. **Einstein Requests 소비**. Oct 2025. |
| AI Semantic Description Generator (AI-Generated Descriptions) | 시맨틱 모델 엔터티(계산필드·테이블·필드)용 AI 설명 생성. Nov 2025. Einstein Requests 소비. |
| Develop and Explore in Your Own Tableau Next Personal Org | 셀프서비스 분석·탐색용 전용 Personal Org(프로덕션 영향 없이 신규 모델·시각화 테스트). |
| Get Inspector Proactive Data Alerts About Tableau Next Metrics | Agentforce에게 메트릭 알림 요청(임계값/변화/예상범위 이탈). 하루 1회 메트릭 확인. |
| Share Configurable Insights with Template Builder | 코드 없이 대시보드 템플릿 생성→Marketplace 공유. |
| Use Existing Report Settings When Adding Tables to Dashboards | Lightning 테이블을 대시보드에 추가 시 리포트 설정(그룹화·수식·버킷팅) 재사용. |
| Boost Query Performance with Semi-Joins and Anti-Joins (CRM Analytics) | 쿼리에 semi/anti-join 추가하여 중복·비일치 행 식별. 렌즈 Add 메뉴 → Join Data Source (BETA). **최대 5 pairing**. |

### 그 밖의 신기능 (서술형)
- **Tableau Next ↔ Slack 통합 대폭 확장:** Slack에 대시보드·메트릭 공유, Slack 대화에 미리보기 첨부, Agentforce for Analytics in Slack으로 메트릭 대화. **Tableau Next Smart Digests in Slack은 은퇴**(Sep 30, 2025 이후 사용 불가).
- **AI Credit Consumption 변경:** Metric Insight Summaries·Data Pro Semantic Model Curation은 Einstein Requests **미소비**(Oct 2025).
- **Tableau Next Visualization 추가(Dec '25):** Funnel Charts·Dual/Synchronized Axes·Heat Maps·Marks Labels·Column Totals/Row Index·Widget Reflow.
- **Lightning Reports/Dashboards:** Reference Lines in Lightning Dashboard Charts · 메타데이터 라벨 번역(Translation Workbench) · Disable Formulas in Exported Reports(CSV의 `=`,`+`,`-` 시작 셀 앞에 `'` 추가).
- **Data Cloud Reports:** 요약 리포트 행 그룹화 **최대 10개**(이전 5개).
- **CRM Analytics:** org-wide 이메일 주소로 구독/알림 발송 · API명으로 데이터셋 컬럼 검색 · **Snowflake Live Data 컬럼 속성 관리 + CSV 내보내기**(Download CRM Analytics Data 권한 필요).
- **Community:** Tableau Next 대화가 신규 Trailblazer Community로 이전(Nov 15, 2025).

### ⭐ 대표 신기능
1. **Tableau Next Embedding SDK GA** — 여러 org 컴포넌트를 한 웹페이지에 임베드.
2. **Tableau Next ↔ Slack 통합 대폭 확장**(대시보드·메트릭·미리보기·Agentforce 대화).
3. **Snowflake Live Data 관리·CSV 내보내기**(CRM Analytics).

---

## Commerce

B2B/D2C Commerce · Salesforce Order Management · Omnichannel Inventory · Salesforce Payments를 포함한다.

> **GA 마커:** Commerce 섹션 내 명시적 "(Generally Available)" 마커 항목은 추출 범위 내 **없음**. 주요 변경은 default 전환·리브랜드·신규 템플릿·은퇴.

### 주요 변경 (default·은퇴)
- **Refreshed Commerce App Is Now the Default Experience** — Winter '26 업그레이드 시 새 Commerce 앱이 기본. Commerce Storefront Console App은 기본 비활성화.
- **New Unified Template** — B2B/D2C 통합 템플릿(단일 코드베이스). D2C Store 템플릿 복원은 Salesforce 지원 문의.
- **Shopper Copilot Is Being Retired** — Guided Shopping Agent 출시로 Shopper Copilot 에이전트 폐기(효력 Jan 2026).

### B2B/D2C Commerce 신기능
| 항목 | 한 줄 |
|---|---|
| Agentforce for Guided Shopping | 생성형 AI 가이드 쇼핑(Shopper Copilot 대체). |
| Changes to AI Credit Consumption | Smart Promotions·SEO Metadata·Return Insights·Generative Product Descriptions/Fields·Commerce Concierge가 Einstein Requests 미소비(Oct 2025). |
| Display Personalized Storefronts to Buyer Groups Using a URL Parameter | 단일 URL 구조로 buyer group별 다른 스토어 표시(Head Markup에 커스텀 URL 파라미터). |
| Personalize B2B Stores for International Authenticated Users | 인증된 buyer에게 시장별 가격·프로모션·entitlement(이전엔 게스트만). Settings\|Store\|Markets→B2B authenticated user access. |
| Process Orders in Currencies Different from the Account Default | Commerce Webstore Carts API의 `currencyIsoCode` 파라미터로 카트별 통화 오버라이드. |
| Empower Buyers to Manage Subscriptions | B2B 스토어 구독 페이지에서 수량 추가/감소(Oct 2025); 구독 갱신은 Spring '26 전까지 request-only(Nov 2025). |
| Localize Shopper Communications with Multilanguage Email Templates | Welcome·Abandoned Cart·Order Confirmation 이메일 다국어. |
| Secure Data with Remote Data Cloud Support and Data Space Awareness | 별도 org 간 Commerce↔Data Cloud 통합 + data space 지원. |
| Customize a B2B Store with Open-Source Components | Salesforce 공개 Git의 오픈소스 컴포넌트 사용. |
| Help Buyers Find Products with Partial SKU Search | 부분 SKU 검색(예: ABC-12345를 "ABC"/"12345"/"ABC1234"로). |
| Sell Configurable Product Bundles on Your B2B Store | 구성 가능한 제품 번들(필수/선택 구성요소·구성 규칙·동적 가격). **Revenue Cloud Advanced + Salesforce Pricing 필요**. |

### Order Management 신기능
| 항목 | 한 줄 |
|---|---|
| Process Returns as Unreferenced Refunds | 원 결제수단과 분리된 환불(모든 credit type으로). |
| Cancel All Eligible Items in an Order | Cancel Item flow에서 Cancel All로 적격 아이템 전체 취소(이전 최대 100개). |
| Boost Delivery Estimation Accuracy | 라우팅 로직·proximity rule·inventory sourcing으로 배송 추정 정확도 향상(Oct 2025). |
| Simplify Data Stream Management with File-Based Data Kits | OMS↔Data Cloud data stream을 file-based data kit으로 간소화. |
| Calculate Tax-Only and Product-Only Price Adjustments (Release Update) | tax-only/product-only 조정을 세율 계산에 반영. **Spring '26 enforced**. AmountTaxOnly/ProductOnly adjustment type. |

### Omnichannel Inventory · Payments
| 항목 | 영역 | 한 줄 |
|---|---|---|
| Customize Inventory Management Permissions | OCI | 신규 persona(Inventory Manager·Retail Manager·Merchandiser). |
| Connect OCI with Data Cloud via Specific Data Space | OCI | OCI↔Data Cloud 통합 시 data space 선택. |
| Expand Payment Processing with Third-Party Bank Payment Gateways | Payments | Commerce Payments API가 ACH·SEPA·BACS·BECS 등 third-party 은행 결제 지원(이전엔 신용/직불카드만). `POST commerce/payments/payment-methods`. |

```http
// 구조 예시 — 실제 동작 코드 아님 (Commerce Payments — Third-Party Bank Payment Gateway)
POST /services/data/v65.0/commerce/payments/payment-methods
Content-Type: application/json

{
  "paymentMethodType": "BankAccount",
  "bankPaymentScheme": "SEPA"
}
```

### ⭐ 대표 신기능
1. **New Unified Template**(B2B/D2C 단일 코드베이스) + Refreshed Commerce App이 기본.
2. **Agentforce for Guided Shopping**(Shopper Copilot 대체).
3. **Third-Party Bank Payment Gateways**(ACH/SEPA/BACS/BECS).

---

## Data 360

구 Data Cloud. *"Connect, harmonize, unify, and analyze structured and unstructured data with Data 360."* Winter '26 릴리즈의 월별(September~December 2025) 카탈로그에서 GA 마커 항목과 Beta 핵심을 정리한다.

### GA 항목 (전수)
| GA 항목 (Generally Available) | 영역 | 한 줄 |
|---|---|---|
| **Image Processing in Data Cloud Search Index Now Generally Available** | Process Content / Search Index | 검색 인덱스의 이미지 처리 GA. |
| **Share Data Between Data Cloud Orgs** | Act on Data / Data Shares (Oct 2025) | Data Cloud org 간 데이터 공유 GA. |
| **Activate Data Cloud Segments to Any API-Based Destination with Activation-Triggered Flow** | Activation (Oct 2025) | 모든 API 기반 destination에 세그먼트 활성화(Activation-Triggered Flow) GA. |

### Beta 핵심
| Beta 항목 | 영역 | 한 줄 |
|---|---|---|
| Mask Unstructured Data | Plan Data Strategy | 거버넌스로 비정형 데이터(PDF·텍스트) PII 동적 마스킹. Nov 2025. |
| Incorporate AI Functions for Text Analysis in Data 360 SQL | Query | Data 360 SQL에 텍스트 분석 AI 함수. Nov 2025. |
| Access External Data in Real Time with Zero Copy Connectors | Connect Data | zero copy 커넥터로 외부 데이터 실시간 접근. Nov 2025. |
| Eliminate Data Pipeline Delays for Near-Instant Profile Updates | Data Ingestion | 파이프라인 지연 제거(준실시간 프로필 업데이트). Nov 2025. |
| Power Smarter Decisions with Multiclass Models (Einstein Studio) | Use/Build AI | 다중 클래스 예측 모델. Nov 2025. |
| Research and Analyze Enterprise Content with Data 360 Notebook AI | Analyze Data | Notebook AI로 기업 콘텐츠 연구·분석. Nov 2025. |
| Clean Rooms (4건) | Act on Data | AWS Clean Rooms zero-copy 협업·커스텀 템플릿·다중 attribute match key·auto-generated overlap report. Nov 2025. |
| Migrate to Dedicated Unstructured Connectors (Google Drive·SharePoint) | Connect Data | 비정형 데이터 전용 커넥터로 마이그레이션. Dec 2025. |
| Deploy Direct DMO Customizations with Sandbox Mergeback | Build/Share | DMO 커스터마이즈를 sandbox mergeback으로 production 배포. Sep 2025. |

### 거버넌스·보안·암호화 (Plan Data Strategy 상세)
| 항목 | 한 줄 |
|---|---|
| Visualize Connected Objects with Unified Lineage | 거버넌스 데이터의 출처·변환·사용 추적(object/field 수준 의존성). **GA Dec 2025**. |
| Apply Record-Level Security Using Hierarchies | 조직 계층(role·manager) 기반 레코드 수준 보안. 신규 hierarchy operator. Setup→Hierarchy Ingestion. **GA Nov 2025**. |
| Control Data Encryption with Bring Your Own Key (BYOK) | 직접 키 자료를 Salesforce UI에 투입하여 암호화(CMK·EKM에 추가). Dec 2025. |

### Connect Data 신규 커넥터 (월별 카탈로그)
- **October 2025:** Ingest Guru Cards · Ingest YouTube Videos · Ingest GitHub Repository Contents · Integrate Journey Builder Data · Ingest Google Analytics 4 Event Data.
- **November 2025:** Federate Data from AWS Glue Data Catalog (Beta) · Sync Marketing Cloud Engagement Data on Demand · CRM Connector Periodic Full Refresh · Store Deleted CRM Connector Records.
- **December 2025:** Ingest Jira Projects · BigQuery Unload · Federate Data from Starburst Galaxy·Trino.

### Develop (Connect in Apex / REST API)
- **New Connect in Apex Classes** (Data 360 Connect in Apex, Nov 2025) · **Data 360 Connect REST API** 변경(Oct·Nov 2025). 상세는 [[Winter '26/Development]] 참조.

### ⭐ 대표 신기능
1. **Data Cloud → Data 360 리브랜드**(Oct 14, 2025).
2. **Share Data Between Data Cloud Orgs [GA]** + **Activation-Triggered Flow [GA]**.
3. **BYOK** + **Unified Lineage(Dec GA)** + **Record-Level Security via Hierarchies(Nov GA)**.

---

## Sales

Agentforce for Sales · Einstein for Sales · Sales Fundamentals · AI-Driven Sales Workspace · Einstein Conversation Insights · Forecasting을 포함한다.

### GA 항목 (전수)
| GA 항목 (Generally Available) | 핵심 1줄 |
|---|---|
| **Autonomously Capture Leads and Schedule Meetings** | Inbound Lead Generation으로 inbound web lead 캡처·문의 응답·미팅 예약. **Agentforce for Sales add-on**. Oct 2025. |

### Beta/Pilot
| 항목 | 마커 | 한 줄 |
|---|---|---|
| SDR Agent Analytics Dashboard | Beta | Agentforce SDR outreach 추적(lead 할당·이메일·답장·미팅 예약 수). Sep 2, 2025. |
| Agentforce Sales App in ChatGPT | Beta | ChatGPT에서 lead/account research·deal 관리(실시간 CRM). Dec 17, 2025, **English only**. |

### Agentforce for Sales 신기능
| 항목 | 한 줄 |
|---|---|
| **Agentforce SDR is Changing to Lead Nurturing** | Agentforce SDR→Agentforce Lead Nurturing 명칭 변경(Sep 30, 2025). |
| Continue Lead Engagement with Agent Handoff | Inbound Lead Generation↔Lead Nurturing agent 자동 핸드오프(mid Dec). |
| Send More Email with SDR and Microsoft Exchange | Exchange 연결 시 일일 이메일 한도 **1,800→9,800**. |
| Nurture Prospects with Multiple Agents | 최대 **5개** SDR agent. |
| Reference Field Values in Sales Email Prompts Securely | Insert Resource action(injection 공격 방지). |
| Scale Up Lead Nurturing with Automatic Limit Management | outreach 큐 자동 관리(Dec 1, 2025). |
| Assign Prospects to Lead Nurturing in Bulk | list view에서 **최대 200 prospect** 일괄 할당. |

### Agentforce Sales Management · Sales Coach
| 항목 | 한 줄 |
|---|---|
| Agentforce Pipeline Management | opportunity field 업데이트 제안(June 30, 2025). |
| Post-Meeting Suggestions from Agentforce | conversation transcript 분석→follow-up 제안(late Nov 2025). |
| Agentforce Account Management | account deep research·positioning statement(PDF 표기 "Jan 5, 2025 rolling"). |
| Pipeline/Account Management in Slack | Slack에서 동작(PDF 표기 "Jan 5, 2025 rolling"). |
| Sales Coach — Preview Coaching Scenarios | 활성화 전 role-play 미리보기. |
| Sales Coach — Coach in Preferred Language | 다국어 conversation(French·German·Italian·Japanese·Spanish·Portuguese·Korean 등). |

### Einstein for Sales · Sales Fundamentals · ECI
| 항목 | 영역 | 한 줄 |
|---|---|---|
| Accelerate Account Research with AI-Powered Insights | Einstein | 생성형 AI account research; account/plan field 자동 업데이트(Dec 8–17, 2025). **Government Cloud 미지원**. |
| Summarize Sales Records with Generative AI | Fundamentals | Einstein Summary(account·contact·lead·opportunity). Aug 4, 2025. |
| Support Higher Activity Volumes | Fundamentals | activity 한도 **400M→700M**(custom field 한도 300). |
| AI-Driven Sales Workspace | Workspace | Sales Workspace가 traditional Seller Home 대체(metric·AI recommendation·insight 통합). |
| Find Relevant Calls with Conversation Search | ECI | Data Cloud 기반 keyword/semantic search across transcript(Jan 2026, English only). |
| ECI Data Is Moving to the Salesforce Platform | ECI | ECI 데이터가 Salesforce object로(flow·Apex·Prompt Builder 접근). |

> 그 밖: Salesforce Forecasting(ramp/consumption-based·scheduled revenue·custom fiscal calendar), Sales Performance Management(Salesforce Maps timesheet·Sales Planning·territory design), Email/Calendar(org-level OAuth 2.0; **Outlook 통합 Dec 2027 retire**), **New Sales Dialer Licenses Are No Longer Available**. Agentforce 상세 → [[Winter '26/Agentforce]].

### ⭐ 대표 신기능
1. **Inbound Lead Generation [GA]**(autonomous lead capture·meeting scheduling).
2. **Agentforce SDR→Lead Nurturing 리브랜드** + Pipeline/Account Management agent(Slack 포함).
3. **ECI Conversation Search**(Data Cloud 기반 semantic search).

---

## Service

*"Learn about the latest features from Service Cloud to supercharge productivity..."* Winter '26 월별(September~December 2025) "Features Released by Month" 표에서 GA 마커와 Beta/Pilot 핵심, 그리고 신규 메이저 섹션 **Agentforce IT Service**를 정리한다.

### GA 항목 (전수)
| GA 항목 (Generally Available) | 영역 | 한 줄 |
|---|---|---|
| **Real-Time Translations (Formerly Einstein Conversation Translate)** | Messaging (Nov '25) | 실시간 번역 GA(구 Einstein Conversation Translate). |
| **Generate the Telephony Usage Report for Billing Details** | Voice (Aug '25) | 청구 상세용 telephony usage report 생성. |
| **Set Up SLA Management Faster with the New Simplified Setup Experience** | Entitlements & Milestones (Aug '25) | 간소화된 SLA 관리 설정 경험. |
| **Agentforce IT Service** | 신규 메이저 섹션 | IT service 운영 통합 플랫폼(CMDB·asset discovery·Slack/Teams). 아래 상세 참조. |

### Beta/Pilot 핵심
| 항목 | 마커 | 한 줄 |
|---|---|---|
| Related List Changes for Enterprise Knowledge | Beta | Enterprise Knowledge related list 변경(Dec '25). |
| Elevate Your Knowledge Experience with Salesforce Enterprise Knowledge | Beta | Enterprise Knowledge 경험 향상(Nov '25). |
| Unify Customer Insights Across Multiple Clouds | Beta | Customer Signals Intelligence 다중 클라우드 통합(Nov '25). |
| Enhance Case Descriptions with Rich Text Formatting | Beta | case description rich text(Aug '25). |
| Collaborate on Complex Calls by Adding More Participants | Pilot | 복잡 콜에 참가자 추가(Aug '25). |
| Control Phone Types Available for Reps | Beta | rep별 전화 유형 제어(Aug '25). |
| Transfer Calls with Voice-Enabled Agents to Reps | Beta | voice-enabled agent→rep 콜 전환(Aug '25). |

### Agentforce IT Service [GA] — 신규 메이저 섹션
> PDF 원문: *"Elevate your IT service operations with Agentforce IT Service, a unified platform that delivers deep integrations and unparalleled visibility... Get access to a customizable configuration management database (CMDB) and deep integrations for asset discovery."* (Unlimited/Enterprise/Performance)

| 영역 | 한 줄 |
|---|---|
| Salesforce Go for IT Service | Setup에서 IT Service 기능 발견·설정·추적. |
| Incident Management | 통합 incident record page; email/voice/chat에서 자동 생성; built-in approval; prebuilt dashboard. |
| Problem Management | problem lifecycle end-to-end; root cause analysis 가속; trend dashboard. |
| Change Management | predefined template·questionnaire 기반 risk score·stage definition template·실시간 dashboard. |
| Release Management | release lifecycle 단일 플랫폼. |
| CMDB & Service Graph | config item 중앙화·시스템 의존성 시각화. |
| Discovery for CMDB | agentless/agent-based scanning으로 IT asset 탐지 자동화. |
| Self-Service for IT Service | self-service portal·IT catalog·knowledge base. |
| Agentforce for IT Service | Employee Request Management agent·IT Fulfiller agent template. |
| Einstein for IT Service | incident→problem 자동 생성·routing·prompt template. |
| Data & Analytics | IT Services data kit→Data Cloud; Tableau Analytics dashboard. |
| Collaboration Channels | Slack·Microsoft Teams 통합(swarming). |
| Automation & Productivity | SLA management·targeted notification·assignment rule·advanced approval·unified calendar. |

> 그 밖의 Service 신기능(서술형, 전수 아님): Messaging Enhanced Chat v2·WhatsApp·BYOC progress indicator, Voice Unified Routing·AWS GovCloud(FedRAMP) contact center, Self-Service 포털 Agentforce 통합 대거(Agentforce Attach·AI-Generated Knowledge Summaries), **Legacy Chat 은퇴**, **Unified Knowledge 은퇴**, Employee Service→**HR Service 리네임**. Agentforce 상세 → [[Winter '26/Agentforce]].

### ⭐ 대표 신기능
1. **Agentforce IT Service [GA]** — ITSM(Incident·Problem·Change·Release·CMDB·Discovery) 통합 플랫폼 신규.
2. **Real-Time Translations [GA]**(구 Einstein Conversation Translate).
3. **Simplified SLA Management Setup [GA]** + Self-Service 포털 Agentforce 통합 대거.

---

## Field Service

Monthly Updates · Agentforce for Field Service · Scheduling/Optimization · Operations · Customer Engagement · Mobile를 포함한다.

> **GA 마커:** 명시적 "(Generally Available)" 마커 항목 추출 범위 내 **없음**(Proactive Asset Service는 Tableau Next 기반 enhancement).

### Beta 핵심
| Beta 항목 | 한 줄 |
|---|---|
| Optimize Large Datasets with Dynamic Scaling | 대규모 글로벌 최적화를 데이터 분할 없이 수행. Field Service Settings→Optimization→Enable Dynamic Scaling (Beta). |
| Complete Data Capture Forms with Voice to Form | Data Capture Voice to Form으로 음성→폼 필드 자동 전사(STT+LLM). |

### 영역별 신기능
| 항목 | 영역 | 한 줄 |
|---|---|---|
| Extend Autonomous Scheduling Agent to More Channels | Agentforce | Enhanced Facebook Messenger·Enhanced WhatsApp 연결. |
| Eliminate Schedule Gaps Before Lunch Breaks | Scheduling | 점심 전 유휴 갭 제거(이동시간 고려해 점심 자동 이동). |
| Improved Engine Resilience for Complex Work | Scheduling | pinned/canceled/overlapping 체인 주변을 지능적으로 처리. |
| Updated Map Data for Predictive Routing | Scheduling | Field Service Maps 데이터에 최신 도로망 반영(연 3회 갱신). |
| Tableau-Powered Proactive Asset Service | Operations | Proactive Asset Service가 Tableau Next 분석 엔진으로 강화(Connected Assets + Field Service 필요). |
| Multiparticipant VRA Sessions | Customer Engagement | Visual Remote Assistant 세션 **최대 6명**(rep + customer + 최대 4 guest). |
| Live Bookmarking in VRA Sessions | Customer Engagement | 라이브 VRA 세션 북마크(데스크톱). |
| Performance Priming (Data Sync) | Mobile | offline briefcase 기반 동기화(client-side priming 대체). |
| Voice to Record Edit | Mobile | Record Edit 화면 음성으로 레코드 업데이트. |
| Android 10 Support Deprecated | Mobile | **Android 11+ 필요**. |
| Data Capture: Global Variables·Flow Templates·Debugging·Regex·Repeater | Mobile | Data Capture flow 다중 enhancement(신규 3 템플릿·Flow Debugger·regex 검증·repeater). |

### ⭐ 대표 신기능
1. **Multiparticipant VRA Sessions**(최대 6명).
2. **Dynamic Scaling (Beta)** — 대규모 최적화.
3. **Data Capture Voice to Form (Beta)** + Voice to Record Edit.

---

## Experience Cloud

*"Take advantage of the latest Lightning Web Runtime features by upgrading your LWR sites to enhanced LWR..."*

> **GA 마커:** 명시적 "(Generally Available)" 마커 항목 추출 범위 내 **없음**(Release Update 다수).

### 신기능 (전수)
| 항목 | 마커 | 한 줄 |
|---|---|---|
| Upgrade to Enhanced LWR Sites | Release Update | enhanced LWR로 업그레이드(partial deployment·enhanced CMS·expression-based visibility). Spring '25 최초; Summer '25부터 **미강제**. URL의 `/s` 제거 후 업그레이드 가능. |
| Latest Features from Salesforce Flow for Experience Cloud | — | screen flow Display Text 컴포넌트에 static resource 이미지; Preview Style로 Aura/LWR 미리보기. |
| Prebuilt Components from Avonni | — | Avonni AppExchange 패키지(App Builder 14개 + Experience Builder 40개 LWC + Dynamic Component Builder). 내부 10명·외부 100명 무료. |
| Update References to Legacy Force.com Site URLs | — | force.com 종료 URL 리다이렉션 Winter '26 기본 비활성, **Spring '26 영구 종료**. |
| Let Users Know When Their Session Is About to End | — | LWR/enhanced LWR 세션 만료 **30초 전** 알림. |
| Real-Time Preview of Your LWR Site (Local Dev) | Beta | Local Dev가 소스 변경 감지→LWR 미리보기 자동 갱신. `sf plugins install @salesforce/plugin-lightning-dev`. |
| Switch to a Single Domain Certificate for Salesforce CDN | Release Update | 공유 도메인 인증서→단일 도메인 인증서. Summer '24 최초; **무기한 연기**. |
| Discover the Latest Features for Mobile Publisher Apps | — | External Client Apps 전환·Binary Handoff·NFC. |

### ⭐ 대표 신기능
1. **Enhanced LWR Sites 업그레이드**(RU, 미강제).
2. **Avonni 사전 빌드 컴포넌트 패키지**(54개).
3. **Local Dev 실시간 LWR 미리보기 (Beta)**.

---

## Industries

산업 특화 클라우드 전반(Automotive·Health·Financial Services·Manufacturing·Public Sector 등). PDF 278페이지로, researcher가 도입부 + GA 마커 페이지를 표적 추출했다.

> [!note] 추출 범위
> 각 산업의 세부 GA는 해당 산업 절을 별도 추출해야 하며 현재 범위 밖이다. **본 노트에서 확인된 명시적 "(Generally Available)" 마커는 아래 2건이다. 추가 산업별 GA는 PDF 미확인(범위 외).**

### GA 항목 (확인된 전수)
| GA 항목 (Generally Available) | 산업 | 핵심 1줄 |
|---|---|---|
| **Telemetry Definition and Action Management** | Automotive Cloud | connected data 기반 real-time remote action; telematics state 활용; telemetry definition/action 생성; 다중 차량 remote command 자동 실행. |
| **LWC integration is generally available on the CG Cloud mobile app** | Consumer Goods Cloud | CG Cloud 모바일 앱에 LWC 통합 GA. |

### 산업별 도입부 요약 (PDF 도입부 전수)
| 산업 클라우드 | 핵심 요약 |
|---|---|
| Asset Management | batch-level inventory; timesheet·labor cost 최적화; product service campaign; Connected Assets 기반 real-time action. |
| Automotive Cloud | AI agent로 dealership·차량 검색·banking; product service campaign; telematics proactive safety·remote action; Omniscript intake·Unified Catalog lending; trade-in appraisal on Experience Cloud. |
| Channel Revenue Management | in-transit stock tracking·transit time config; partner inventory·warning; rebate management(relationship graph·transaction journal·automated validation). |
| Communications Cloud | Agentforce 통합; quote recipient group; SLO; Enterprise Sales Management 역할별 접근; redesigned search; multiple order from single quote. |
| Consumer Goods Cloud | managed package push upgrade; **LWC integration GA on mobile**; driver compliance; Route Sales sync; component-wise KPI; promotion liability accrual; BOM→standard product. |
| Education Cloud | Recruitment & Admissions; Agentforce student life goal; Education Data Kit→Data Cloud; course registration policy rule; Philanthropic Research·Gift Planning. |
| Energy and Utilities Cloud | preconfigured sample product; commodity offer; supervisor·crew lead bulk timesheet; 자동 time entry·shift differential·wage classification override(mobile). |
| Financial Services Cloud | AI로 banking·wealth·insurance 통합; personalized engagement·faster onboarding·financial planning insight. |
| Health Cloud | Agentforce로 patient-provider matching·profile summary·home healthcare quote·benefit verification; athenahealth 통합; Integrated Care Management; IDP disease definition import; CDS hook. |
| Insurance | claims management API·invocable action; group insurance plan 통합; backdated change·reinstatement·out-of-sequence endorsement; reusable exclusion·clause; Agentforce proof of insurance. |
| Life Sciences Cloud | PSP rep reverification automation; research study·care program stage orchestration via Stage Management. |
| Manufacturing Cloud | inventory·forecasting·sales agreement; Agentforce smarter replenishment; batch level validation·discoverability. |
| Media Cloud | Advertising Inventory Management app; inventory calendar; slot pitch/reserve/release; revenue schedule; pricing procedure; media plan on Experience Cloud. |
| Net Zero Cloud | carbon accounting·data discovery·reporting; negative fuel consumption; Net Zero Marketplace keyword search; two-level org hierarchy emissions; CSRD compliance. |
| Nonprofit Cloud | Program·Case·Outcome·Fundraising·Volunteer·Grantmaking 개선; Volunteer Management via Salesforce Go; Data Cloud data bundle; Gift Entry Grid; Gift Planning. |
| Public Sector Solutions | AI agent로 job recommendation·benefit discovery·complaint intake; Amazon S3 연결(petabyte-scale 디지털 증거); compliance tracking; scratch org; readymade data stream→Data Cloud. |
| Industries Common Features | Revenue Cloud 등 Industries 제품 공통 enhancement. |

### Asset Management · Connected Assets · Automotive 상세
- **Asset Management:** Agentforce for Asset Service Lifecycle Management(inventory search·replenishment·proactive maintenance) · Product Service Campaigns · Any Word Search / Batch Search(CBSF) · Timesheet/Labor Cost(supervisor 관리·mobile 자동 time entry·differential shift·wage override·자동 계산 검증). 신규 객체/필드: `Product Inventory Batch Searchable Field`, `DifferentialShift`, `PayGrade`/`DifferentialShift`(TimesheetEntry), Status 값 `VerificationPending`/`Verified`/`VerificationFailed`.
- **Connected Assets:** Define the Structure of a Connected Asset · Generate a Service Process for Remote Actions · Enable Remote Commands Using AWS SiteWise · Take Action on a Connected Asset.
- **Automotive Cloud:** Agentforce for Automotive · Automotive Finance · Product Service Campaign Management · **Telemetry Definition and Action Management [GA]** · Manage Vehicle Appraisals on Experience Cloud · Salesforce Go.

### ⭐ 대표 신기능
1. **Telemetry Definition and Action Management [GA]**(Automotive/Connected Assets).
2. **CG Cloud mobile LWC integration [GA]**.
3. **Agentforce 산업별 확산**(Asset·Automotive·Health·Insurance·Public Sector 전반).

---

## Marketing

Marketing Cloud Next · Account Engagement · Marketing Cloud Engagement · Marketing Intelligence를 포함한다.

> **GA 마커:** 명시적 "(Generally Available)" 마커 항목 추출 범위 내 **없음**(대부분 서술형 신기능).

### Marketing Cloud Next 핵심
| 항목 | 한 줄 |
|---|---|
| Reach Your Users with Mobile App Messaging | 인증된 모바일 기기에 push. Basic push(미디어·탭액션·버튼)·**Carousel push(최대 6 swipeable card)**. |
| Send Push with the Unified Marketing Cloud SDK | 통합 SDK로 push(이전엔 Engagement만). |
| Enhance Campaign Creation with Agentforce | campaign brief·multichannel campaign 작성; Generate Campaign Insights. |
| Create Content with the Content Builder Agent | 자율 Content Builder Agent(subject line·SMS·body copy). |
| Streamline Email with Reusable Content Blocks | 재사용 content block(배너·푸터·약관). |
| Expand SMS Marketing to More Countries | 홍콩·온두라스·페루·싱가포르. |
| Make WhatsApp Messages More Engaging | WhatsApp flow·location sharing·CTA button·carousel·real-time catalog. |
| Connect External Forms with the Form Handler | 외부 웹폼→Salesforce object 매핑(코드 없이); honeypot·custom redirect. |
| Bring Marketing Orgs Together with Data Cloud One | companion org에서 MC Next 설정. |
| Score with Multiple Scoring Models | 다중 scoring model(이전 단일 고정주기). |

### Account Engagement · Engagement 핵심
| 항목 | 영역 | 한 줄 |
|---|---|---|
| Get New Engagement Data with Data Cloud | Account Engagement | CRM bundle 업그레이드(form handler engagement data). |
| Manage Prospects with Agentforce | Account Engagement | Agentforce action 6개 신규(June 2025). |
| Match Email Consent with Marketing Cloud Next | Account Engagement | prospect↔MC Next consent 매칭(Oct 2025). |
| Marketing Cloud Next for Engagement | Engagement | Engagement 계정에 MC Next 기능(Flow·Campaigns·Digital Wallet·Agent Builder·고급 분석). Nov 2025 rolling. |
| Dynamic Experiences Powered by Agentforce | Engagement | Journey Decisioning agent(MCAgentActionsUser 권한). |
| Cohesive Experiences with Flow | Engagement | Engagement 고객이 Flow Builder 사용. |
| Boost SQL Query Performance (Query Activity Optimizer) | Engagement | Automation Studio SQL 성능 개선. |

### ⭐ 대표 신기능
1. **Mobile App Messaging**(push notification, Carousel).
2. **Marketing Cloud Next for Engagement**(Engagement 고객에 Next 기능 — Flow·Campaigns·Agentforce·analytics).
3. **Content Builder Agent** + WhatsApp 인터랙티브 확장.

---

## Revenue Cloud

Product Catalog Management · Salesforce Pricing · Rate Management · Product Configurator · Transaction Management · Billing · Salesforce Contracts·Document Generation을 포함한다.

> **GA 마커:** 명시적 "(Generally Available)" 마커 항목 추출 범위 내 **없음**(전부 enhancement·rename·신규 객체).

### Product Catalog Management 핵심
| 항목 | 한 줄 |
|---|---|
| Accelerate Product Detail Retrieval with PCM Caching | Product Details API 캐싱 레이어(Product Discovery Settings→PCM Cache). |
| Product Classification Hierarchies with Attribute Inheritance | **최대 3단계** subclassification, 부모 속성 자동 상속. |
| Find Products Faster with Dynamic Product Facets | 검색 결과 기반 facet 자동 선택·정렬. |
| Conversational Selection | Revenue Quote Management agent의 Product Selection topic(자연어). |
| Changed Connect REST APIs | Product Classification에 `parentProductClassificationId` 신규 property. |

### Salesforce Pricing · Rate Management 핵심
| 항목 | 영역 | 한 줄 |
|---|---|---|
| Apply Price Adjustments Using CPI-Based Policies | Pricing | CPI 기반 가격 자동 조정(월/분기/연 uplift). |
| Improve Pricing Performance on Large Transactions | Pricing | 수정된 line item만 selective repricing(**Delta Pricing**). |
| New PriceRevisionPolicy object | Pricing | 신규 object; IndexRate에 Region·UsageType field. |
| Tiered Commitment Discounts | Rate | quantity·token·monetary commitment product tiered discount. |
| Bind Rates to New Object Targets | Rate | account·contract·custom object에 rate 바인딩. |

### Product Configurator 핵심
| 항목 | 한 줄 |
|---|---|
| New Names | Standard Configurator→**Configurator With Business Rules Engine**; Advanced→**Configurator with Constraint Rules Engine**. |
| Flexible Expression-Building in Visual Builder | 'and'/'or'/'xor' 논리로 expression 그룹화. |
| New Rule Types in Visual Builder | 3개 신규: **Exclude rule·Hide/Disable rule·Preference rule**. |
| Import Product Component Groups to Constraint Builder | PCM 번들 구조를 Constraint Builder로 import. |
| Leverage Salesforce Object Data in a Constraint Model | object 데이터를 table constraint로 import(**최대 50,000 records**). |
| Convert BRE Rules into CML Code | Business Rules Engine 룰→CML 변환. |
| Add Product Recommendations During Quote and Order | CML `recommend` attribute로 추천 룰. |

CML 코드 예제 (PDF 원문 — Product Configurator, Add Product Recommendations):
```cml
type Laptop {
@(defaultValue = "13 Inch")
string Display_Size = ["24 Inch", "13 Inch", "15 Inch", "27 Inch"];

rule(Display_Size == "24 Inch", "recommend", "type", "Printer");
}

type Printer;
```

> 도입부 언급(상세 미추출): Transaction Management(ramp deals for groups·quote split·asset transfer·cotermination), Dynamic Revenue Orchestrator(FulfillmentAsset/FulfillmentStep object), Usage Management, Billing(invoice sequence·debit memo·third-party payment gateway), Salesforce Contracts(Microsoft 365 user extension·Data True-up), Document Generation(Context Services로 runtime data).

### ⭐ 대표 신기능
1. **Product Configurator 신규 룰 타입**(Exclude·Hide/Disable·Preference) + CML import.
2. **CPI-Based Pricing Policies** + Delta Pricing.
3. **Attribute Inheritance**(PCM 3단계 hierarchy).

---

## 관련 노트
- [[Winter '26]] — Winter '26 릴리즈 허브 (상위)
- [[Winter '26/Development]] — Apex·LWC·API 개발자 변경 (Data 360 Connect in Apex/REST API 상세)
- [[Winter '26/Agentforce]] — Agentforce/Einstein (Sales·Service·Marketing AI 에이전트 상세)
- [[Winter '26/Release Updates]] — 릴리즈 업데이트 강제 적용 일정
- [[Release MOC]] — 전체 릴리즈 노트 목차
- [[Winter '26/Platform]] — 플랫폼 스포크
