---
tags: [release, summer_25, clouds, sales, service, data-cloud, commerce, analytics]
api_version: v64.0
release_date: 2025-06
created: 2026-06-15
source: salesforce_release_notes_5-17-2026 (3).pdf (Salesforce Summer '25 Release Notes, Tier 2)
aliases: [Summer '25 Clouds, 서머25 클라우드, Data Cloud, Field Service, Sales Cloud, Service Cloud, Commerce Cloud, Revenue Cloud, Analytics]
---

# Summer '25 — Clouds (Sales · Service · Commerce · Experience · Data Cloud · Field Service · Marketing · Revenue · Analytics · CMS)

> 일반 클라우드(non-Industries)의 Summer '25 GA/Beta를 전수 정리. Data Cloud(GA 6)·Analytics(GA 7)·Service(GA 6)가 가장 변화가 크고, Knowledge Feedback은 한 번 켜면 끌 수 없음(irreversible)이며, Revenue Cloud Constraint Engine은 EU OZ·Government Cloud 미지원이다. 산업 특화 클라우드는 → [[Summer '25/Industries]].

---

## 개요 — 클라우드별 GA/Beta 건수

| 클라우드 | GA | Beta | 비고 |
|---|---|---|---|
| Sales | 2 | — | Seller-Focused Mobile Exp GA, PEM bundle GA (June 15, 2025) |
| Service | 6 | — | Voice GA 2건은 functional area 중복 게재 → dedup 후 각 1건 |
| Commerce | 0 | — | B2B/D2C·Order Management·Payments 다수 개선(미태깅) |
| Experience Cloud | 0 | 2 | Agentforce Draft Text Beta, File Upload Enhanced LWC Beta |
| Data Cloud | 6 | — | Document AI·Zero Copy File Federation·Website Content·Draft with Einstein·Suggested Relationships·Databricks Share |
| Field Service | 2 | — | Buffer Time on Service Appointments GA, Tableau Next Insights GA |
| Marketing | 0 | 1 | Campaign Designer Beta |
| Revenue | 2 | — | Constraint Rules Engine GA, Constraint Builder GA |
| Analytics | 7 | — | Suggested Relationships·Draft with Einstein은 Data Cloud와 **cross-cloud 공유**(카운트 1회) |
| CMS | 0 | — | 3개 기능(Dedicated Content Delivery·ContentTypeBundle·Delete Workspace) |

> **cross-cloud 주의:** Tableau Semantics의 **Suggested Relationships (GA)**, **Draft with Einstein (GA)** 두 GA는 Analytics·Data Cloud 양쪽 릴리즈 노트에 등장한다. 본 노트에서는 Data Cloud 쪽에 상세를, Analytics 쪽에 cross-cloud 표기만 두고 **카운트는 1회**로 처리한다.

---

## Sales (GA 2)

### Customize Seller-Focused Mobile Experience (Generally Available)
- **무엇:** Seller-Focused Mobile Experience는 미팅 계획·의사결정자 연결·딜 클로징에 필요한 레코드를 보여준다. 이제 **Mobile Builder for Seller-Focused Experience (beta)** 로 커스텀 오브젝트용 네이티브 페이지를 추가하고 레코드 홈 페이지 레이아웃을 커스터마이즈할 수 있다.
- **왜 GA:** Mobile Builder for Seller-Focused Experience는 Spring '25 beta였고, Summer '25에 **영어 전용(English only)** 으로 일반 제공된다.
- **Where:** Lightning Experience, all editions(Android·iOS, phone·tablet, Database.com 제외, mobile version 254.000 이상).
- **Who:** `Salesforce Mobile App: Native Seller Experience` 권한 필요.
- **연계 — Use Seller-Focused Mobile Experience Without Admin Setup:** 이제 Seller-Focused Mobile Experience가 모든 Sales Cloud 유저에게 Salesforce mobile app의 lightning app으로 제공된다. 원하면 비활성화 가능. **app version 256.000부터는 Native Seller Experience 권한이 필요 없다.**

### Scale Your Partner Ecosystem — Partner Ecosystem Management (PEM) bundle (Generally Available)
- **무엇:** 신규 **Partner Ecosystem Management (PEM)** 번들. 핵심 PRM(Partner Relationship Management) 기능에 인접 솔루션(Account Planning, Partner Tracks, B2B Referral Marketing, Loyalty Management, Incentive Management with Spiff)을 결합한 올인원 오퍼링. 파트너 도구를 단일 패키지로 통합해 조달 간소화·세일즈 사이클 단축·일관된 파트너 경험을 제공.
- **Where:** Lightning Experience, Enterprise·Unlimited·Einstein 1 Sales editions. PEM은 add-on 오퍼링.
- **When:** **Generally available beginning June 15, 2025.**

> [!note] PEM 라이선스
> PEM 번들은 두 라이선스 타입으로 제공된다: **PEM Member licenses**, **PEM Login licenses**. 두 타입을 한 org에 모두 프로비저닝할 수 있으나, **개별 유저는 한 번에 한 타입만** 할당 가능. Admin은 permission set을 할당해야 한다.

```
// PDF 원문 인용 (Sales — PEM GA, June 15)
When: Generally available beginning June 15, 2025.
Who: The PEM bundle is available through two license types: Both license types can be
provisioned in the same org, but an individual user may only be assigned one type at a time.
 • PEM Member licenses
 • PEM Login licenses
```

> 그 밖의 Sales 비-GA 변경: Sales Cloud Go → **Salesforce Go** 리브랜딩, Partner Central 신규 템플릿, Sync Email as Salesforce Activity(Einstein Activity Capture), Activities: Match Email to Records flow, 대리 직접 전화번호(DID) 할당, Salesforce for Outlook은 December 2027 은퇴 예정. Agentforce for Sales(SDR·Sales Management·Sales Coach)는 → [[Summer '25/Agentforce]].

---

## Service (GA 6) — Voice GA 중복 dedup

> **중복 주의 (researcher 명시):** Service Voice 영역은 동일 기능이 2개 functional area에 게재됐다. **"Route Work Items Through a Single System with Unified Routing for Voice" = "Route Voice Calls with Other Channels by Using Omni-Channel"**, **"Manage Capacity via Status-Based Capacity for Voice" = "Use Status-Based Capacity with Voice"**. 각 1건으로 dedup → 아래 6개가 고유 GA.

### 1. Automate Your Customer Emails with Agentforce (Generally Available)
- Agentforce Service Agent가 고객 이메일에 **자율 응답**(적절한 톤). 예: 배송 도착 문의 시 예상 배송일·추적번호 제공. 응답은 Agentforce Data Libraries와 topic instructions에 grounding.
- **Where:** Lightning Experience, **Unlimited·Developer** editions. **When:** **May 15, 2025** 부터.
- **How:** Agentforce Service Agent 생성·grounding 후 Lightning email template을 만들어 서비스 에이전트에 연결. Omni-Channel flow로 어떤 케이스를 에이전트 vs 서비스 담당자로 라우팅할지 제어 권장.

### 2. Transition to the Lightning Editor for Email Composers in Email-to-Case (Generally Available) (Release Update)
- docked·case feed 이메일 composer의 에디터를 HTML 5 기반 모던 에디터로 교체. **Spring '24에 GA**, 강제 적용일(enforcement date) 없음.
- 신규 기능: Full-screen mode, Printing, Undo/Redo, Format painting, Emoji picker, Resizability, 더 반응성 좋은 toolbar. 자동 표시되던 table controls·word/character count·붙여넣기 포맷 안내창 제거.
- **How:** Email-to-Case 활성 org 대상. Winter '24 이후 생성 org은 기본 적용, 이전 org은 Release Updates 페이지에서 활성화.

### 3. Gather Feedback to Improve Your Knowledge Base — Knowledge Feedback (Generally Available)
- Knowledge 아티클에 대한 피드백을 수집하고 응답을 적절한 담당자/팀에 할당. 아티클 유용성 파악·개선 영역 식별 → Agentforce 응답 정확도 향상.
- **Where:** Lightning Experience, Unlimited Edition 및 Knowledge add-on 라이선스 보유 타 edition. Aura 기반 Experience Cloud 사이트(Enterprise·Performance·Unlimited·Developer)에도 적용. **org에 최소 1개의 active community license 필요.**

> [!warning] Knowledge Feedback은 켜면 되돌릴 수 없음 (irreversible)
> **Knowledge Feedback을 켜는 것은 irreversible 하다. 한 번 켜면 끌 수 없다.** 변경 준비가 됐는지 확인하고, **먼저 sandbox에서 테스트**한 뒤 org에 켤 것을 권장.
> **Note(할당량):** 처음 **30,000개** feedback response는 추가 비용 없이 사용 가능. 한도를 늘리려면 Knowledge add-on 라이선스를 구매(account executive 문의).
> **선행조건:** 켜기 전에 Lightning Knowledge와 Salesforce Surveys를 먼저 켜야 한다. Setup의 Enhanced Knowledge Settings → Article Feedback Settings → Feedback for Knowledge Articles 활성화.

### 4. Route Work Items Through a Single System with Unified Routing for Voice (Generally Available)
- inbound·outbound·transfer 음성 통화를 다른 채널 타입과 함께 **Omni-Channel Unified Routing** 으로 라우팅. 라우팅이 텔레포니 시스템이 아니라 **Salesforce에서** 일어난다. skill-based·direct-to-rep 라우팅을 Amazon Connect contact center에서 활용. Unified Routing은 desk phone·voice mail을 제한 용량으로 지원. Amazon Connect 사용 시 call acceptance push time-out 커스터마이즈 가능(기존 20초 기본값 제거).
- 이 기능은 pilot 대비 변경사항 포함. **Where:** Enterprise·Unlimited·Developer / Service Cloud Voice with Amazon Connect·Partner Telephony from Amazon Connect. **When:** **June 23, 2025** 부터 GA.
- (= "Route Voice Calls with Other Channels by Using Omni-Channel (Generally Available)" 와 동일 — dedup)

### 5. Manage Capacity via Status-Based Capacity for Voice (Generally Available)
- rep의 accepted work **상태(status) 기반** 으로 용량 측정. status-based capacity는 기존 타 서비스 채널에서만 제공됐으나 이제 Voice에서도. standard navigation Lightning app에서 음성 통화 사용 가능. standard(console 아님) app에서는 rep이 session ownership 영향 없이 여러 음성 통화 레코드를 동시에 볼 수 있다.
- **Where:** Enterprise·Unlimited·Developer / Amazon Connect·Partner Telephony from Amazon Connect·Partner Telephony.
- **How:** Omni-Channel Settings에서 enhanced Omni-Channel routing 활성화 → Enable Status-Based Capacity Model 선택 → Service Channels에서 Voice Call object용 Service Channel 생성, Capacity Model을 Status-Based로 설정.
- (= "Use Status-Based Capacity with Voice" 와 동일 — dedup)

### 6. Focus on Primary Tasks by Using Voice in an App with Standard Navigation (Generally Available)
- Service Cloud Voice의 app type·capacity model 유연성 향상. **standard navigation** app에서 Voice 사용 가능. 기존에는 tab-based capacity(console app 전용)에 의존. standard app 지원으로 status-based capacity가 음성 통화 포함 모든 서비스 채널 타입에서 제공.
- **Where:** Enterprise·Unlimited·Developer / Amazon Connect·Partner Telephony from Amazon Connect·Partner Telephony.

> 그 밖의 Service 비-GA 변경: Tailor the Email Summaries Prompt in Prompt Builder, Notify Senders About Email-to-Case Processing Errors, Draft With Einstein Improvement(`EmailMessage.AutomationType = AI-Assisted`), Disable Ref ID and Transition to New Email Threading(Release Update), Case Lightning Email Composer 시간당 단일 이메일 발송 한도(시간당 최대 **250 external recipients**), Assign Dedicated Phone Numbers(DID), Unified Knowledge는 **Summer '26에 은퇴 예정**(Data Cloud connector 마이그레이션 권장).

---

## Commerce (GA 0)

Commerce Cloud는 B2B/D2C Commerce, Salesforce Order Management, Salesforce Payments 전반의 개선이지만 Summer '25 Commerce 섹션 자체에 GA/Beta 태그가 붙은 항목은 없다(개요 수준 enhancement).

- **Salesforce B2B and D2C Commerce:** 제품 갤러리에 비디오 추가, Marketing Cloud·Data Cloud로 마케팅 동의 관리, 기프팅 옵션·간소화 checkout, 소셜 미디어 제품 홍보, 제품 미리보기, size/color로 검색 결과 그룹화, search facet 최적화. 구독 결제 실패 표시(shopper)·이메일 알림(merchant). 2차 인증(2FA)으로 연락처 정보 업데이트.
- **Commerce Store Pages:** External Channel feature로 Facebook·Instagram 제품 노출, 홈/제품 페이지 featured recommendation 커스텀, 제품 레코드 편집 중 라이브 미리보기.
- **Marketing Cloud for Commerce:** Commerce + Marketing Cloud 결합. 신규 주문·장바구니 이탈 등 이벤트가 Marketing Cloud(Data Cloud 기반) 서비스로 메시지 발송하는 out-of-the-box flow를 트리거. order confirmation email template에 repeater component로 주문 라인 아이템·배송 그룹 추가.
- **Cart/Checkout/Shipping:** 기프팅, 미니 카트 개인화 추천, express checkout, 디지털 제품 플래그.
- **Commerce Components:** Marketing Consent Settings, Email Sign-Up Form(최대 5개 동의 옵션), Cookie Consent component.
- **Commerce Promotions:** 보너스/기프트 제품(무료), 할인 임계값 근접 알림 메시지.
- **Commerce Search:** D2C 제품 미리보기, attribute(size/color) 그룹화, search facet 순서 개선, price filter range·guest shopper price 정렬.
- **Commerce Subscriptions:** My Subscriptions 페이지에 결제 실패 표시, merchant 이메일 알림, 활성 구독 연결 결제수단 삭제 경고.
- **Commerce Additional Features:** 2FA(one-time passcode)로 연락처 정보 업데이트, self-registering 유저는 기본 buyer group 자동 미할당(self-registration settings에서 default buyer group 설정 시 자동 할당).
- **Salesforce Order Management:** 모든 서비스 flow에서 product bundle 지원, high-scale order ingestion.
- **Salesforce Payments:** buyer-controlled 저장 결제정보 접근, payment record sharing 관리, 결제 페이지 악성 변경 추적 platform events, business account ACH 결제, EEA(European Economic Area) 고객용 개선·준수 결제 경험.

---

## Experience Cloud (GA 0 · Beta 2)

### Use Agentforce to Draft Text for Enhanced LWR Sites (Beta)
- generative AI로 사이트의 모든 Text Block component 콘텐츠를 작성·수정(**Experience Builder Agent (beta)**). Experience Builder Settings의 신규 **Brand Identity** 필드로 회사 스타일에 맞춰 텍스트 작성. Experience Builder 사용법 일반 질문도 Salesforce Help 문서 기반으로 답변.
- **Where:** LWR 사이트, Enterprise·Performance·Unlimited editions + Einstein for Sales/Service/Platform add-on. **When:** June 2025.
- Beta Services Terms 적용. Non-GA Services를 paid credits/entitlements를 소모하는 GA Services와 함께 사용하더라도 그로 인한 entitlement 소비는 환불/크레딧 권리를 발생시키지 않음.

### Use the File Upload Enhanced Lightning Web Component with Aura and LWR Sites (Beta)
- Aura·LWR 사이트와 Lightning Experience에 파일 업로드 — 신규 **File Upload Enhanced (Beta)** flow screen component. `Required` 필드를 true로 설정하면 파일 업로드 필수화. 기존에는 LWR 사이트용 File Upload component가 없었다.
- **Where:** Aura·LWR 사이트(Lightning Experience·Salesforce Classic, 일부 org 미지원), Enterprise·Performance·Unlimited·Developer editions. Beta Services Terms 적용.

> 그 밖의 Experience Cloud 비-GA: Upgrade to Enhanced LWR Sites(Release Update — Summer '25부터 강제 적용 안 함, 활성화 권장), Mobile Publisher 최신 기능, External Client Apps로 push notification 관리(GA). 음성 통화 unified routing(Beta).

---

## Data Cloud (GA 6)

### 1. Document AI Now Generally Available
- Data Cloud의 Document AI로 invoice·resume·lab report 같은 비정형 문서에서 스키마 생성·데이터 추출. AI로 source object에서 스키마 자동 추출하거나, document schema builder로 수동 생성/scratch 빌드. **이 GA 릴리즈는 beta 업데이트(document schema builder, Gemini 2.0 Flash 지원)를 포함.**
- **Where:** Lightning Experience, **Professional·Performance·Unlimited** editions. **When:** **August 2025** GA.

### 2. Build Cost-Effective Data Foundation with Zero Copy File Federation (Generally Available)
- zero copy file federation으로 Apache Iceberg 호환 테이블 포맷의 외부 파일 시스템·data lake 데이터에 안전하게 접근. 데이터를 Data Cloud로 복사하지 않고 접근. **이 릴리즈는 Apache Iceberg 호환 테이블, Databricks, Snowflake에 대한 file federation을 GA로 포함.**
- **Where:** **Enterprise·Performance·Unlimited** editions. **When:** August 2025 롤아웃.

### 3. Ingest Website Content into Data Cloud (General Availability)
- **Web Content connector** 로 조직의 마케팅·ecommerce·문서·기타 웹사이트 콘텐츠를 Data Cloud로 ingest. AI 에이전트가 이 콘텐츠로 신뢰할 만한 답변 제공. 사이트 sitemap 또는 web crawler 두 방식 지원.
- **Where:** Developer·Enterprise·Performance·Unlimited editions. **When:** **July 2025.**
- **How:** Data Cloud setup → Other Connectors → Web Content (Crawler) 또는 Web Content (Sitemap) connector로 연결 생성 → Data Lake Objects 탭에서 source로 선택.

### 4. Turn Natural Language into Formulas with Draft with Einstein (Generally Available) — *cross-cloud*
- **Draft with Einstein** 으로 복잡한 calculated field를 syntax 암기 없이 빠르게 생성. 자연어로 필드를 설명("percentage of transactions associated with accounts that are considered high revenue and currently at risk")하면 필드명·설명·데이터 타입·aggregation type·formula를 제안.
- **Where/Who:** Data Cloud + Tableau Next 사용자. Data Cloud는 GenieDataPlatformStarter 라이선스, Tableau Next는 Standard Tableau Next 라이선스 필요.
- **cross-cloud:** Analytics(Tableau Semantics) 릴리즈 노트에도 동일하게 GA로 등장 → 카운트 1회.

### 5. Find and Create Data Connections Automatically with Suggested Relationships (Generally Available) — *cross-cloud*
- **Suggested Relationships** 가 데이터 오브젝트 간 관계 생성 추천을 알림 → 검토·적용·거절. 수동 작업 감소·관계 자동화. 데이터 모델 정확도·사용성 향상.
- **Where:** Data Cloud + Tableau Next(Developer·Enterprise·Performance·Unlimited). **When:** **August 2025.**
- **Who:** Data Cloud는 GenieDataPlatformStarter, Tableau Next는 Standard Tableau Next 라이선스 필요.
- **cross-cloud:** Analytics(Tableau Semantics)에도 동일 GA → 카운트 1회.

### 6. Share Data in Near Real-Time Between Data Cloud and Databricks (Generally Available)
- zero-copy data sharing으로 Data Cloud object를 데이터 이동 없이 Databricks와 안전하게 공유 → near real-time 접근.
- **Where:** Enterprise·Performance·Unlimited·Developer editions. **When:** **August 2025** GA.
- (동명 Beta는 June 2025 제공; Feature Manager의 "Data Sharing with Databricks - File Federation (Beta)" 활성화.)

> 주요 Data Cloud Beta: Indexed Images(이미지 검색, July 2025), Ingest Box Content, Ingest Google Analytics 4 Event Data, Authenticate Amazon Kafka Connector with IdP, Share Data Between Data Cloud Orgs(July 2025), Data Cloud Direct Query App-Level Caching. 비-GA enhancement: Streaming Ingestion API 부분 업데이트, File Upload로 CSV 교체, Amazon MSK Private Connect, IBM watsonx.data file federation, BigQuery/Databricks/Snowflake zero copy connector IdP 인증, Databricks Auto-Load Schema. (Data Cloud·AI 에이전트 연계 → [[Summer '25/Agentforce]])

---

## Field Service (GA 2)

### 1. Create More Precise Travel Time Estimations by Including a Buffer Time on Service Appointments (Generally Available)
- 이동 시간 추정에 buffer를 더해 회사 비즈니스 요구에 맞춤 — 이제 **Service Appointment object** 에서도 가능. buffer는 주차·자산 하역 등 추가 도착 시간을 반영해 이동 시간 정확도 향상. **pilot 대비 변경 포함.** 기존에는 Field Service Settings 또는 Service Territory에서만 buffer time 추가.
- **Where:** Lightning Experience, Enterprise·Unlimited·Developer editions + Field Service managed package.
- **How:** Field Service Settings에서 Enhanced Scheduling and Optimization 활성 확인 → Field Service Admin app → Scheduling → Routing → buffer 분 입력. 특정 service territory·service appointment에도 buffer 설정 가능.

### 2. Upgrade Your Field Service Insights with Tableau Next (Generally Available)
- Field Service Intelligence와 Operations Home이 **Tableau Next로 구동** → Demand Forecasting 등 최신 플랫폼 기능·운영 모니터링 제공. Demand Forecasting으로 수요 예측·리소스 균형. 향상된 Einstein dashboard로 커스터마이즈 데이터·시각화·KPI 제공. work order·service appointment 트렌드 상세 분석.
- **Where:** Lightning Experience, **Einstein 1**(대시보드 커스터마이즈 권한 포함) 및 **Unlimited** edition(Unlimited는 Tableau Next 구매 필요).
- **Who:** 대시보드 사용은 `Tableau Einstein Included App Business User` permission set 필요.

> 그 밖의 Field Service 비-GA: Priorities로 complex work chain 스케줄링, crew member 결근 color coding, Capacity Visualization, Migrate from Maintenance Plan Frequency Fields(Release Update — **취소됨**).

---

## Marketing (GA 0 · Beta 1)

### Create Meaningful Moments with Campaign Designer (Beta)
- 신규 **Campaign Designer (beta)** 기능으로 신뢰할 데이터를 활용한 multi-touch 마케팅 brief·캠페인을 빠르게 생성. draft brief 검토 시 기존 캠페인을 선택해 컨텍스트 추가. AI로 draft 캠페인의 메시지·채널을 정제.
- **Where:** Salesforce Enterprise·Unlimited editions + Marketing Cloud Advanced edition, 또는 Marketing Cloud Account Engagement Plus/Advanced/Premium editions + Data Cloud and Einstein Requests add-on. Beta Services Terms 적용.
- **How:** Marketing Cloud에서 AI 기능 활성화 후 홈 페이지의 **Draft with AI** 버튼 클릭 → campaign designer가 brief·캠페인·component 생성을 안내. 피드백: agentforce-for-marketing-product-beta@salesforce.com.

> 그 밖의 Marketing 비-GA: Campaign Creation Agent Template(May 2025), 캠페인·flow 통합 관리 개선. (Agentforce for Marketing → [[Summer '25/Agentforce]])

---

## Revenue (GA 2)

### 1. Support Complex Configurable Products with Ease with Constraint Rules Engine (Generally Available)
- 구성 가능 제품(configurable product)의 설계·설정 간소화. 추상 수준에서 constraint를 정의해 비즈니스 admin이 관리하는 룰 수 감소. 룰을 link·backtrack하는 advanced algorithm. **Configurator with Constraint Rules Engine** 은 대규모 거래·복잡 룰을 다루는 manufacturing·technology 등 산업 대상.
- **Where:** Lightning Experience, Enterprise·Unlimited·Developer editions of Revenue Cloud(Product Configurator 활성).
- **Who:** `Advanced Configurator Designer` permission set 사용자가 Configurator with Constraint Rules Engine을 켜고 룰 생성.
- **Note:** Configurator with Constraint Rules Engine을 켜면 **AdvancedConfigurator가 org의 transaction type 기본 엔진**이 된다.

### 2. Manage Product Configuration Logic with the Constraint Builder (Generally Available)
- Revenue Cloud의 Configurator with Constraint Rules Engine 내 **Constraint Builder** 로 constraint model을 생성해 제품 구성을 정확하게 관리. constraint model은 전통적 if-then 룰의 streamlined 대안으로 복잡한 제품 구성 검증을 쉽게 한다. 두 인터페이스 제공 — **CML Editor**(코드 기반, 기술 유저용), **Visual Builder**(비즈니스 유저용).
- **Where:** Lightning Experience, Enterprise·Unlimited·Developer editions of Revenue Cloud(Product Configurator 활성).
- **Who:** `Advanced Configurator Designer` permission set.

> [!warning] Constraint Rules Engine 미지원 환경
> **Constraint Rules Engine services는 Government Cloud 및 EU Operating Zone (OZ) 내 org에서 사용할 수 없다.** 자세한 내용은 Salesforce account executive에 문의.

> 그 밖의 Revenue 비-GA: Product Configurator 설정 라벨 정확도 개선, Constraint Modeling Language(CML) 코드 내 asset data 필터링(asset context definition).

---

## Analytics (GA 7)

> **cross-cloud 카운트 규칙:** 아래 GA 중 **Suggested Relationships**, **Draft with Einstein** 2건은 Data Cloud(Tableau Semantics)와 공유되는 cross-cloud GA로, 상세는 [Data Cloud](#data-cloud-ga-6) 섹션에 두고 여기서는 표기만 한다. **전체 카운트에서 중복 카운트하지 않는다.**

### 1. Choose Which Dashboard Widgets to Refresh (Generally Available)
- 전체 대시보드가 아니라 필요한 위젯만 새로고침. 예: support 팀원이 Open Tickets 위젯만 새로고침해 미해결 이슈 최신 목록 확인.
- **Where:** Lightning Experience·Salesforce mobile app(iOS·Android), Essentials·Professional·Enterprise·Performance·Unlimited·Developer editions. **When:** Summer '25부터 rolling.
- **How:** 대시보드에서 위젯의 refresh 아이콘 클릭.

### 2. Designate One Email Address to Send Report Subscription Notifications (Generally Available)
- organization-wide 이메일 주소로 report subscription을 발송 → 일관된 이메일 커뮤니케이션·spoofing 위험 감소. 기존에는 subscription을 만든 유저 주소로 발송.
- **Where:** Lightning Experience, Essentials·Professional·Enterprise·Performance·Unlimited·Developer editions.
- **How:** Setup → Reports and Dashboards Settings → Enable Org-Wide Email Address for Report Subscription → org-wide email address 선택.
- (참고: "Designate One Email Address to Send **Dashboard** Subscription Notifications"는 동일 컨셉이나 PDF에서 GA 미태깅.)

### 3. Connect to Your Snowflake Data Using Direct Data for Snowflake with OAuth (Generally Available)
- Snowflake warehouse에 라이브 연결을 만들어 데이터를 복사하지 않고 CRM Analytics에서 탐색. Snowflake·Salesforce·CRM Analytics를 외부 OAuth authorization server(예: Okta)로 구성해 안전한 실시간 통합.

### 4. Improve Salesforce External Connector Sync Performance with Incremental and Periodic Full Syncs (Generally Available)
- 외부 데이터 sync를 incremental 또는 periodic으로 로드해 성능 개선. **incremental sync** 는 외부 Salesforce 데이터의 최신 변경분만 추출. **periodic full sync** 는 정기 incremental sync + 주 1회 전체 추출.
- **Where:** CRM Analytics·Salesforce Data Pipelines(Lightning Experience·Salesforce Classic), Enterprise·Performance·Unlimited editions(추가 비용).
- **How:** Data Manager → Salesforce external connection → Edit Connection Mode에서 Incremental Sync 또는 Periodic Full Sync 선택.

> [!note] BULKV2 필수
> **incremental·periodic full sync를 위해 external connector의 API Type은 반드시 BULKV2 여야 한다.**

### 5. Find and Create Data Connections Automatically with Suggested Relationships (Generally Available) — *cross-cloud (Data Cloud 공유)*
- Tableau Semantics의 Suggested Relationships GA. 상세는 [Data Cloud](#data-cloud-ga-6) 섹션 참조. **카운트 1회.**

### 6. Turn Natural Language into Formulas with Draft with Einstein (Generally Available) — *cross-cloud (Data Cloud 공유)*
- Tableau Semantics의 Draft with Einstein GA. 상세는 [Data Cloud](#data-cloud-ga-6) 섹션 참조. **카운트 1회.**

### 7. (Tableau Semantics / Data Pro 계열 GA — Create Calculated Fields Effortlessly with Data Pro 등)
- Tableau Next/Semantics functional area에 Suggested Relationships·Draft with Einstein과 함께 게재된 GA 라인업. (Create Calculated Fields with Data Pro, Share Semantic Models in Tableau Next, Tableau Next Connect REST APIs 등은 GA/Beta 혼재 — 본 노트는 GA 태깅된 항목 위주로 정리하며, Tableau Next 상세 기능은 별도 분리 대상.)

> Analytics Beta: Add Data to Tableau Next From an Excel File (Beta, July 2025), Improve Snapshot Data Recipe Performance with Optimized Upsert and Delete Actions (Beta). 비-GA enhancement: Filter and Navigate with the List Widget, Repeater Widget custom header·sorting, 데이터 버킷 생성, read-only 유저 recipe notification 구독, 접근성 개선. **Einstein Discovery Decision Optimization beta는 June 5, 2025 이후 사용 종료(retired).**

---

## CMS / 기타 (Salesforce CMS — GA 0, 3개 기능)

Salesforce CMS는 enhanced CMS workspace 대상 3개 기능. 메타데이터 타입명(`ContentTypeBundle`)은 원문 그대로 유지.

### 1. Deliver All Media Content Types at High Scale (Dedicated Content Delivery)
- 이미지 콘텐츠 외에도, **Hyperforce 호스팅 org** 이 **Dedicated Content Delivery** 로 document·audio·video 콘텐츠를 고성능·저지연으로 전달. 활성화 후 publish하는 media content는 Hyperforce로 서빙. 기존 published 콘텐츠는 다음 publish 시 Hyperforce로. **Dedicated Content Delivery 설정은 enhanced CMS workspace의 모든 신규 public channel에서 기본 ON.**
- **Where:** enhanced CMS workspaces, Enterprise·Performance·Unlimited·Developer editions(Hyperforce 호스팅).
- **How:** Hyperforce의 기존 public channel에 활성화하려면 channel settings 편집.

### 2. Create More Powerful Content with Enhanced Custom Content Types (ContentTypeBundle)
- enhanced CMS workspace용 enhanced custom content type을 만들 때 신규 **`ContentTypeBundle`** 메타데이터 타입 사용. enhanced custom content type은 **JSON-based schema** 를 제공해 커스텀 콘텐츠 blueprint 정의에 유연성 제공.
- **Where:** enhanced CMS workspaces, Enterprise·Performance·Unlimited·Developer editions.

### 3. Delete Enhanced CMS Workspaces
- 오래되거나 미사용 enhanced CMS workspace를 영구 삭제 가능. workspace 삭제 시 모든 콘텐츠 삭제 + 예약된 publication·import·export 취소.
- **Where:** enhanced CMS workspaces, Enterprise·Performance·Unlimited·Developer editions.
- **How:** 삭제 전 모든 CMS channel 제거 + 다른 workspace와의 공유 해제 → workspace settings에서 삭제.

---

## 관련 노트
- [[Summer '25]] — Summer '25 릴리즈 허브
- [[Summer '25/Industries]] — 산업 특화 클라우드 peer(Health·Financial·Manufacturing 등)
- [[Summer '25/Agentforce]] — Agentforce/Einstein(Data Cloud·AI 에이전트 연계)
- [[Summer '25/Development]] — Apex·LWC·API 개발자 변경
- [[Summer '25/Release Updates]] — 릴리즈 업데이트 강제 적용 일정
