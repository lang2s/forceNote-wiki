---
tags: [index, search, navigation, router]
created: 2026-05-17
---

# SEARCH INDEX (라우터)
> 전체 wiki 키워드 검색의 진입점. 평면 인덱스가 아니라 **도메인 → 샤드 라우터**다.
> 키워드의 도메인을 판단해 아래 샤드 파일 **1개만** 열면 된다.
> (한 번에 읽는 양을 일정하게 유지 — 위키가 아무리 커져도 truncation/컨텍스트 낭비 없음)

---

## 라우팅 — 도메인 → 샤드

| 도메인 | 샤드 파일 | 포함 |
|---|---|---|
| LWC · Aura · Flow · SLDS · Base Components(카탈로그) | `_index/frontend.md` | 프론트엔드 전반 (개별 lightning-* 레퍼런스 제외) |
| LWC 베이스 컴포넌트 — lightning-* 개별 컴포넌트 레퍼런스 | `_index/frontend-basecomponents.md` | `LWC/BaseComponents(베이스컴포넌트)/` 개별 페이지 |
| Visualforce — 개념·컨트롤러·동적 VF·JS Remoting·베스트 프랙티스·`apex:`/비-`apex:` 표준 컴포넌트(레거시 UI) | `_index/visualforce.md` | Visualforce(비주얼포스)/ 폴더 전반 (Visualforce Developer Guide v67.0, 16노트) |
| Apex 언어/코어 — 데이터·SOQL/SOSL·비동기·보안·테스트·System·Schema·트리거·컬렉션·한도·표준클래스 | `_index/apex-core.md` | Apex 개발 핵심 |
| Apex 네임스페이스 — 통합/HTTP·Commerce·Industries·Metadata | `_index/apex-namespaces.md` | 통합 및 산업 네임스페이스 (Order Management 섹션 포함 — 아래 Commerce 행 참조) |
| Commerce · Order Management(주문 관리) · B2C Commerce — Salesforce Order Management(SOM): OrderSummary·FulfillmentOrder·OrderItemSummary 데이터 모델 · B2C Commerce Storefront 주문 데이터 맵(XSD 매핑) · Import/Fulfillment/Taxation(주문 가져오기·이행·세금) · Exchanges(RMA 교환)/Payment Sequencing | `_index/apex-namespaces.md` | `Commerce(커머스)/` 폴더 4노트 — 샤드 내 "Order Management — B2C Commerce" 섹션. 자연어 질문은 `_index/questions.md` |
| Architecture · Admin · Integration(플랫폼) | `_index/platform.md` | VF·Sites·Canvas·AppLauncher·VisualEditor·Enhanced Domains·Admin·외부연동 등 (DevOps/DX 제외) |
| 플랫폼 DevOps / DX — Salesforce DX · Scratch Org · Sandbox · Source Tracking · DX 인증 · CI/CD · Metadata API · DevOps Center (패키징·Tooling API 제외) | `_index/platform-devops.md` | `DevOps(데브옵스)/` 폴더 — DX 코어·Metadata API·DevOps Center |
| 플랫폼 DevOps 패키징 — Unlocked Package · 2GP Managed Package · 컴포넌트 Manageability Rules · Push Upgrade · AppExchange · LMA · Feature Management App · App Analytics | `_index/platform-devops-2gp.md` | `DevOps(데브옵스)/` 폴더 — 패키징(2GP/Unlocked) 클러스터 (platform-devops.md에서 분할) |
| 플랫폼 DevOps Tooling API — 개발 도구용 메타데이터 API: 개요·REST/SOAP 호출·헤더·네임스페이스 분류 + 도메인별 Tooling sObject(Apex·스키마·보안·자동화·UI·Lightning·운영·패키징·이벤트·Service·세일즈/AI·Experience·통합) 전수 | `_index/platform-devops-tooling.md` | `DevOps(데브옵스)/ToolingAPI(툴링API)/` 폴더 — Tooling API 클러스터 (platform-devops.md에서 분할) |
| 릴리즈 노트 — Spring/Summer/Winter (v59~v67) | `_index/release.md` | 릴리즈별 변경 |
| sObject Reference — Field 타입·Object 그룹·Associated Objects·Custom Objects·Object Interfaces·표준 Object 카탈로그 | `_index/sobject-reference.md` | Object Reference v67.0 |
| Sales Cloud · Agentforce Sales — 영업 표준 기능: 기회(Opportunities)·제품/가격표·캠페인·거래처/연락처·견적(Quotes)·리드·활동(Task/Event)·예측(Collaborative Forecasts)·영역 관리(ETM)·계약/주문 | `_index/sales.md` | SalesCloud(세일즈클라우드)/ 폴더 전반 (Salesforce Help — Sales Basics, 11노트). CPQ 심화는 cpq 샤드, 주문관리(SOM)는 apex-namespaces 샤드 |
| Service Cloud · Knowledge — 데이터모델·SOAP/REST/Metadata/UI API·아티클·데이터카테고리 | `_index/service.md` | Service(서비스)/ 폴더 전반 |
| Salesforce Scheduler · Lightning Scheduler — 예약(appointment) 스케줄링: 표준/커스텀 객체·Platform Events·Metadata·Business(REST/Connect) API·ConnectApi.LightningScheduler Apex·커스텀 예약 시나리오 | `_index/scheduler.md` | Scheduler(스케줄러)/ 폴더 전반 (Salesforce Scheduler Developer Guide v67.0, 12노트) |
| Field Service · FSL — 현장 서비스 운영: 개요·데이터 모델(Core/Inventory/Preventive Maintenance/Product Service Campaign/Warranty/Pricing)·오브젝트 관계도·REST/Metadata/Tooling API·FSL Apex Namespace·Custom Triggers·Code Examples·Mobile App LWC·Object References 전 객체 필드 전수 완료 | `_index/field-service.md` | FieldService(현장서비스)/ 폴더 전반 (Field Service Developer Guide v67.0) |
| Security · 시큐어 코딩 — XSS·SQLi·CSRF·Redirect·TLS·민감데이터·CRUD/FLS·Lightning보안·세션/브라우저통신·MC API·FAQ | `_index/security.md` | Security(보안)/ 폴더 전반 (Secure Coding Guide) |
| CPQ · 견적 — Salesforce CPQ(`SBQQ`) API 모델·Quote/Config/Contract API·기타 API·플러그인(JSQCP·9종) | `_index/cpq.md` | CPQ(견적)/ 폴더 전반 (CPQ Developer Guide, managed package — RLM과 별개) |
| Analytics · CRM Analytics · 리포트/대시보드 REST — Data Prep Recipe REST API(노드 Input·Response·Enum) + Reports and Dashboards REST API(reports·dashboards·folders·notifications·표현형) | `_index/analytics.md` | Analytics(애널리틱스)/ 폴더 전반 (Data Prep Recipe REST API Summer '26 + Reports and Dashboards REST API v67.0) |
| Data Cloud · Data 360 — CDP 파이프라인(연결→수집→조화→통합→세그먼트→발행): Data Streams·수집·DLO/DMO 데이터 모델·Identity Resolution·Calculated Insights·Segments·Activations·Data Spaces | `_index/data-cloud.md` | DataCloud(데이터클라우드)/ 폴더 전반 (Salesforce Help — Data 360, 8노트). 어드민/개념 측. **개발자 측 Apex `Datacloud` 네임스페이스(코드)는 `_index/apex-namespaces.md` 샤드** |
| Salesforce Clouds(제품 클라우드 지도·개요) — 전체 제품 클라우드 지도 허브 + 심층 폴더 없는 클라우드 개요(Experience·Commerce·Marketing·CRM Analytics·Revenue·Net Zero) | `_index/clouds.md` | Clouds(클라우드)/ 폴더 전반 (7노트, 개요·지도). **심층은 전용 샤드로: Sales→`_index/sales.md`, Service→`_index/service.md`, Data→`_index/data-cloud.md`** |
| Agentforce · Agent Script — Agentforce Builder agent 정의 언어: 개요·언어 특성(컴파일·결정성+추론·`->`/`\|`/`@`/`{!}`)·블록 8종(system·config·variables·language·connection·subagent·connected_subagent[Beta]·start_agent)·실행 흐름·model_config·레퍼런스(액션·툴·유틸·변수)·패턴·메타데이터 배포(Agentforce DX) | `_index/agentforce.md` | `Agentforce(에이전트포스)/` 폴더 전반 (Agent Script Developer Guide 2026-06-17판) |
| Agent Skills · 에이전트 스킬 — SKILL.md 기반 단계별 안내 절차. SLDS 2 Starter Kit 스킬 + 공식 `forcedotcom/sf-skills` 라이브러리(Platform/Apex·Experience/LWC·Agentforce·Data 360·OmniStudio·Integration·DevOps·Design Systems·Diagram 등 도메인별 스킬) | `_index/agent-skills.md` | AgentSkills(에이전트스킬)/ 폴더 전반 (sf-skills 카탈로그: `AgentSkills(에이전트스킬)/sf-skills/index.md`) |
| sf-skills refs · 다이어그램 — `external-diagram-mermaid/visual-generate` 스킬 레퍼런스 문서(ERD·OAuth 플로우·Mermaid 문법·비주얼 목업) | `_index/agent-skills-refs-diagram.md` | sf-skills/refs/ 다이어그램(45) (카탈로그: `AgentSkills(에이전트스킬)/sf-skills/refs/index.md`) |
| sf-skills refs · Agentforce — `agentforce-generate/test/observe/d360-analyze/architecture-analyze` 스킬 레퍼런스 문서(Agent Script·테스트·관측성·STDM) | `_index/agent-skills-refs-agentforce.md` | sf-skills/refs/ Agentforce(43) |
| sf-skills refs · Platform — `platform-data-manage/soql-query/apex-logs-debug/apex-test-*/metadata-deploy/trust-archive/...` 스킬 레퍼런스 문서(Apex·SOQL·데이터·메타데이터) | `_index/agent-skills-refs-platform.md` | sf-skills/refs/ Platform(50) |
| sf-skills refs · Experience — `experience-lwc-generate`·`experience-ui-bundle-agentforce-client-generate` 스킬 레퍼런스 문서(LWC·UI Bundle) | `_index/agent-skills-refs-experience.md` | sf-skills/refs/ Experience(20) |
| sf-skills refs · Integration — `integration-connectivity-generate/connected-app-configure`·`eventing-subscription/cdc-configure` 스킬 레퍼런스 문서(콜아웃·Named Credential·CDC·구독) | `_index/agent-skills-refs-integration.md` | sf-skills/refs/ Integration(25) |
| sf-skills refs · OmniStudio — `omnistudio-datamapper/datapacks/dependencies/epc/flexcard/integration-procedure/omniscript` 스킬 레퍼런스 문서 | `_index/agent-skills-refs-omnistudio.md` | sf-skills/refs/ OmniStudio(17) |
| sf-skills refs · Design Systems·DX·Mobile·Data 360·Commerce — `design-systems-slds*`·`dx-code-analyzer-*`·`mobile-platform-*`·`data360-orchestrate`·`*datacloud*`·`commerce-b2b-store-create` 스킬 레퍼런스 문서 | `_index/agent-skills-refs-misc.md` | sf-skills/refs/ 기타(52) |
| 자연어 질문 — "~하는 방법" | `_index/questions.md` | 교차 도메인 질문 라우팅 |

---

## 사용법

1. 키워드/질문의 도메인을 판단 → 위 표에서 샤드 **1개** 선택
2. 그 샤드 파일만 읽어 `키워드 → 경로` 확인 → 해당 파일 바로 읽기
3. 도메인이 애매하면 `_index/questions.md`(자연어 질문)부터 본다
4. 섹션 전체를 훑을 땐 Section MOC(`Apex/Apex MOC.md` 등), 폴더 내 탐색은 `폴더/index.md`

---

## 구조 규칙 (요약 — 상세는 `CLAUDE.md`의 "탐색 인덱스 구조")

- 이 라우터는 **개별 페이지를 나열하지 않는다** — 도메인→샤드만. 그래서 크기가 페이지 수와 무관하게 일정하다.
- 각 샤드 상한 **~300줄 / ~12k 토큰**. 초과 시 하위 샤드로 분할하고 위 표에 1줄만 추가한다.
- 모든 샤드 쓰기는 **index-manager 전담** (1 페이지 = 1 홈 샤드, 중복 키워드 행 금지).
