---
tags: [tooling-api, devops, forecasting, sales, account-plan, territory, opportunity-split, pipeline-inspection, ai, machine-learning, einstein, agentforce, recommendation, data-cleansing]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-30
aliases: [AccountPlanObjMeasCalcCond, AccountPlanObjMeasCalcDef, AdvAcctFrcstDisplayGroup, AdvAccountForecastSet, AdvAcctForecastMeasureDef, AIApplication, AIApplicationConfig, CleanDataService, ForecastingDisplayedFamily, ForecastingFilter, ForecastingFilterCondition, ForecastingSourceDefinition, ForecastingType, ForecastingTypeSource, GenAiFunctionDefinition, GenAiPlannerDefinition, InvocableActionExtension, MLDataDefinition, MLField, MLFilter, MLPredictionDefinition, OpportunitySplitType, PipelineInspMetricConfig, RecommendationStrategy, Territory2SupportedObject, 예측, 포캐스팅, 어카운트플랜, 고급예측, 고급계정예측, AI애플리케이션, 머신러닝, ML, Einstein, Agentforce, 에이전트포스, 추천전략, 기회분할, 옵션분할, 파이프라인검사, 테리토리, 데이터정제, "Tooling API로 예측 유형 조회", "Einstein 예측 정의 sObject", "Agentforce 액션 메타데이터 조회", "기회 분할 유형 Tooling API", "머신러닝 필터 sObject"]
---

# Tooling API 객체 — 세일즈·예측·AI (포캐스팅·머신러닝·Einstein·Agentforce)

> 세일즈·예측(Forecasting·고급계정예측·어카운트플랜·기회분할·파이프라인검사·테리토리)과 AI·ML(Einstein 예측/추천·머신러닝 모델 정의·Agentforce 액션/플래너·데이터정제) 도메인의 Tooling sObject 25종 240필드 전수 — 예측 유형·소스·필터의 메타데이터 구성, ML 예측/필터/필드 정의, GenAi 액션·플래너, RecommendationStrategy를 query()로 조회·구성한다.

---

## 개요

이 노트는 Tooling API Reference(v67.0 / Summer '26)의 세일즈·예측·AI/ML 도메인 sObject 25종을 다룬다. 모두 Tooling API의 `query()`(SOAP) / `query`(REST)로 조회하며, 대부분 `create()`/`update()`/`upsert()`로 메타데이터를 프로그래매틱하게 구성할 수 있다(읽기전용 객체 예외는 각 항목에 표기).

도메인은 두 갈래다:

1. **세일즈·예측 (14종)** — 협업·예측 메타데이터: 고급계정예측(AdvAccountForecastSet 등), 예측 유형·소스·필터(ForecastingType/Source/Filter), 어카운트플랜 목표측정(AccountPlanObjMeasCalc*), 기회분할 유형(OpportunitySplitType), 파이프라인검사 메트릭(PipelineInspMetricConfig), 테리토리(Territory2SupportedObject).
2. **AI·ML·Agentforce·추천·데이터정제 (11종)** — Einstein ML 모델 정의(ML*·AIApplication*), Agentforce 액션·플래너(GenAi*), 추천전략(RecommendationStrategy), 데이터정제(CleanDataService), invocable action 확장(InvocableActionExtension).

> **구조 안내 (D-4):** PDF는 전 객체를 알파벳순으로 나열하지만, 이 노트는 **도메인 2분류 → 그룹 내 필드수 내림차순**으로 재배열했다(독자가 "예측이냐 AI냐"로 먼저 좁히고 큰 객체부터 본다). `DeveloperName`/`MasterLabel`/`NamespacePrefix`/`ManageableState`/`Metadata`/`FullName`/`Language`의 표준 보일러플레이트 의미는 [공통 반복 필드](#공통-반복-필드-한-번만-정의) 섹션에 1회 정의하고, 각 객체 표에서는 **객체별 고유 차이와 enum·관계만** 전수한다.

각 `###` 객체 엔트리 = 설명 1줄 + API 버전 + Supported SOAP Calls / REST Methods + Special Access Rules(없으면 "없음") + 전체 필드 표(필드·Type·Properties·Description). enum 값·숫자코드·관계 타깃은 객체별로 빠짐없이 적었다.

---

## 공통 반복 필드 (한 번만 정의)

아래 필드는 25객체 다수에 반복 등장한다. 표준 의미를 여기 1회 정의하고, 각 객체 표의 Description에서는 객체별 차이(라벨·제약·버전 등)만 적는다. **단 enum 값·숫자코드·관계 타깃은 압축하지 않고 각 객체 표에 전수한다.**

| 공통 필드 | 표준 의미 |
|---|---|
| `DeveloperName` | API에서 객체를 식별하는 unique 이름. 밑줄·영숫자만 허용, org 내 유일, 글자로 시작, 공백·끝밑줄·연속밑줄 불가. managed package 네이밍 충돌 방지. 일부 객체는 자동 생성되며 API 생성 시 직접 지정 가능 — **대량 레코드 생성 시 반드시 unique DeveloperName을 지정**(미지정 시 Salesforce가 각 레코드용으로 생성하느라 성능 저하). 일부 객체는 "View DeveloperName" 또는 "View Setup and Configuration" 권한이 있어야 조회·그룹·정렬·필터 가능. |
| `MasterLabel` | 객체의 라벨(UI에서 보통 "Label"). display value는 번역되지 않는 내부 라벨인 경우가 많음. |
| `NamespacePrefix` | 이 객체에 연결된 네임스페이스 프리픽스. Limit 15자, `namespacePrefix__componentName` 표기. Dev Edition org에서 등록한 네임스페이스가 있을 때만 글로벌 unique 값이 설정되고, 그 외에는 null. |
| `ManageableState` | 패키지에 포함된 컴포넌트의 manageable 상태(`ManageableState enumerated list`). 가능 값: **beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged**. |
| `Metadata` | 객체의 Metadata API 표현(complexvalue / 해당 Metadata Type). **쿼리 결과가 1건 이하일 때만** 이 필드를 query — 1건 초과 시 error 발생(여러 레코드는 별도 쿼리). |
| `FullName` | Metadata API에서의 연관 타입 full name(네임스페이스 프리픽스 포함 가능). **쿼리 결과가 1건 이하일 때만** query. |
| `Language` | 객체의 언어. 대부분 Defaulted on create + Restricted picklist. |

> 위 표는 의미 압축용이다. 각 객체 표에는 해당 필드가 실제로 존재할 때 행을 그대로 유지하며, Properties(토큰)와 객체별 Description 차이는 객체 표에 적는다.

---

## 1. 세일즈·예측 (Forecasting · Account Plan · Territory · Split) — 14종

### AdvAccountForecastSet (22필드)

고급 계정 예측 세트(advanced account forecast set)를 나타낸다.

- **API 버전:** 56.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음
- **Note:** Important — noninclusive 용어를 Equality 가치에 맞춰 변경했으나, 코드 내 용어 변경이 현행 구현을 깨뜨릴 수 있어 이 객체 이름은 유지함.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| AccountFieldName | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 고급 계정 예측 fact 레코드의 account 필드명. |
| CalculationFrequency | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | 예측 세트가 자동 재계산되는 주기. 가능 값: Monthly, Quarterly, Weekly, Yearly. 기본값 Monthly. |
| Description | textarea | Filter, Group, Nillable, Sort | AdvAccountForecastSet 설명. |
| DeveloperName | string | Filter, Group, Sort | 고급 계정 예측 세트 레코드의 unique 이름(공통 반복 필드 참조). 자동 생성되나 API 생성 시 직접 지정 가능. **대량 데이터 생성 시 각 레코드에 반드시 unique DeveloperName 지정**(미지정 시 성능 저하). |
| ForecastFactObjectName | picklist | Filter, Group, Restricted picklist, Sort | facts 테이블로 사용되는 엔터티의 API 이름. |
| ForecastPeriodGroupId | reference | Filter, Group, Sort | 고급 계정 예측에 연결된 forecast period group의 Id. 관계 필드 — Relationship Name: ForecastPeriodGroup / Type: Lookup / Refers To: AdvAcctForecastPeriodGroup. |
| ForecastQuantityFieldName | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 고급 계정 예측 fact 레코드의 forecast quantity 필드명. |
| ForecastRevenueFieldName | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 고급 계정 예측 레코드의 forecast revenue 필드명. |
| ForecastSetFieldName | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 고급 계정 예측 레코드의 forecast set 필드명. |
| ForecastSetName | string | Filter, Group, idLookup, Sort | 고급 계정 예측 레코드의 forecast set 이름. |
| ForecastStatusFieldName | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 고급 계정 예측 fact 레코드의 status 필드명. |
| FullName | string | Create, Group, Nillable | Metadata API의 연관 고급 계정 예측 fact 레코드 full name. 쿼리 결과 1건 이하일 때만 query(공통 반복 필드 참조). |
| GenerationDpeDefNameId | reference | Filter, Group, Nillable, Sort | 고급 계정 예측 fact 레코드를 생성하는 Data Processing Engine 정의 이름. 관계 필드 — Relationship Name: GenerationDpeDefName / Type: Lookup / Refers To: BatchCalcJobDefinition. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | AdvAccountForecastSet의 언어. |
| MasterLabel | string | Filter, Group, Sort | AdvAccountForecastSet 레코드의 라벨. |
| Metadata | complexvalue | Create, Nillable, Update | AdvAccountForecastSet의 metadata. 쿼리 결과 1건 이하일 때만 query. |
| PeriodFieldName | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 고급 계정 예측 fact 레코드의 period 필드명. |
| RecalculateDpeDefNameId | reference | Filter, Group, Nillable, Sort | 고급 계정 예측 fact 레코드를 재계산하는 Data Processing Engine 정의. 관계 필드 — Relationship Name: RecalculateDpeDefName / Type: Lookup / Refers To: BatchCalcJobDefinition. |
| RegenerationDpeDefNameId | reference | Filter, Group, Nillable, Sort | 고급 계정 예측 fact 레코드를 재생성하는 Data Processing Engine 정의. 관계 필드 — Relationship Name: RegenerationDpeDefName / Type: Lookup / Refers To: BatchCalcJobDefinition. |
| RolloverDpeDefNameId | reference | Filter, Group, Nillable, Sort | 롤오버 고급 계정 예측 fact 레코드를 생성하는 Data Processing Engine 정의. 관계 필드 — Relationship Name: RolloverDpeDefName / Type: Lookup / Refers To: BatchCalcJobDefinition. |
| RolloverFrequency | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | 고급 계정 예측 레코드의 롤오버 주기. 가능 값: Monthly, Quarterly, Weekly, Yearly. 기본값 Monthly. |
| Status | picklist | Filter, Group, Restricted picklist, Sort | 고급 계정 예측 세트의 상태. 가능 값: Active, Inactive. |

### ForecastingSourceDefinition (12필드)

예측이 매출을 추정하는 데 사용하는 object·measure·date type·hierarchy를 나타낸다.

- **API 버전:** 52.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()` — **update()/upsert() 없음**
- **Supported REST Methods:** DELETE, GET, HEAD, POST, Query — **PATCH 없음**
- **Special Access Rules:** 없음
- **Note:** Important — noninclusive 용어 정렬, 일부 용어는 유지.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| CategoryField | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 예측 유형에 연관된 forecast category 이름. 가능 값: Opportunity.ForecastCategoryName. |
| DateField | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 예측 유형의 date type에 사용되는 필드(예: Opportunity의 CloseDate). 가능 값: Opportunity.CloseDate, OpportunityLineItem.ServiceDate. |
| DeveloperName | string | Filter, Group, Sort | Required. forecasting source definition의 이름. |
| FamilyField | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 예측을 product family로 그룹화할 때 사용. 가능 값: Product2.Family. |
| FullName | string | Create, Group, Nillable | forecasting source definition의 full name. |
| Language | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | forecasting source definition의 언어. |
| MasterLabel | string | Filter, Group, Sort | Required. 이 forecasting source definition의 controlling label. |
| MeasureField | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 예측 유형의 measure에 사용되는 필드(예: Opportunity의 Amount). 가능 값: Opportunity.Amount, Opportunity.Custom, Opportunity.TotalOpportunityQuantity, OpportunityLineItem.Custom, OpportunityLineItem.Quantity, OpportunityLineItem.TotalPrice. (여기서 `Custom`은 예측 유형의 measure가 기반하는 커스텀 필드명을 의미 — 예: `Megawatts__c` 커스텀 필드로 에너지 소비 예측.) |
| Metadata | ForecastingSourceDefinition | Create, Nillable, Update | forecasting source definition의 metadata. |
| SourceObject | picklist | Filter, Group, Restricted picklist, Sort | Required. 이 forecasting source definition에 연관된 object. 가능 값: Opportunity, OpportunityLineItem, Product2. |
| Territory2Field | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 테리토리 기반 예측 유형에서 테리토리 정보에 사용되는 필드. user role 기반 예측 유형에서는 이 값이 null. |
| UserField | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 예측 소유자를 지정. 가능 값: Opportunity.OwnerId. |

### ForecastingType (11필드)

예측 유형(forecast type)을 나타낸다.

- **API 버전:** 52.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음
- **Note:** Important — noninclusive 용어 정렬, 일부 용어는 유지.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| DateType | picklist | Filter, Group, Restricted picklist, Sort | Required. 예측 금액이 기준하는 date type. 가능 값: OLIMeasureCloseDateOnly—3, OpportunityCloseDate—0, ProductDate—1, ProductDateOnly—4, ScheduleDate—2, ScheduleDateOnly—5. |
| DeveloperName | string | Filter, Group, Sort | Required. 예측 유형의 이름. |
| FullName | string | Create, Group, Nillable | 예측 유형의 full name. |
| HasProductFamily | boolean | Defaulted on create, Group | Required. 예측 유형이 product family를 포함하는지(true) 여부(false). 기본값 false. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | 예측 유형의 언어. |
| MasterLabel | string | Filter, Group, Sort | Required. 이 예측 유형의 controlling label. 번역되지 않는 내부 라벨. |
| Metadata | ForecastingType | Create, Nillable, Update | 예측 유형의 metadata. |
| OpportunitySplitTypeId | reference | Filter, Group, Nillable, Sort | split 기반 예측 유형에서 opportunity split type의 ID. 관계 필드 — Relationship Name: OpportunitySplitType / Type: Lookup / Refers To: OpportunitySplitType. |
| OpptyLineItemSplitTypeId | reference | Filter, Group, Nillable, Sort | opportunity product split 기반 예측 유형에서 opportunity line item split type의 ID. API 버전 58.0 and later. 관계 필드 — Relationship Name: OpptyLineItemSplitType / Type: Lookup / Refers To: OpptyLineItemSplitType. |
| RoleType | picklist | Filter, Group, Restricted picklist, Sort | Required. role type이 ForecastingType을 가지는지와 어떤 ForecastingType인지를 나타냄. 가능 값: R—User role-based forecast type, T, Y—Territory2-based forecast type. (T는 PDF에 라벨 없음 — 원문 그대로.) |
| Territory2ModelId | string | Filter, Group, Sort | 테리토리 기반 예측 유형에서 Territory2 model의 ID. |

### ForecastingFilterCondition (11필드)

opportunity 예측에 데이터를 포함/제외하기 위한 커스텀 필터 조건 로직을 나타낸다.

- **API 버전:** 55.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** Spring '20 이후, View All Forecasts 권한 OR Allow Forecasting 권한 OR delegated forecast manager 상태를 가진 standard user만 이 객체에 접근 가능.
- **Note:** Important — noninclusive 용어 정렬, 일부 용어는 유지.
- **Usage:** 한 예측 유형은 최대 3개의 필터 조건을 가질 수 있다.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | 예측 필터 조건의 developer name. |
| FieldName | string | Filter, Group, Sort | 필터링 대상 opportunity 필드명. |
| ForecastingFilterId | reference | Filter, Group, Sort | 예측 필터의 ID. 관계 필드 — Relationship Name: ForecastingFilter / Type: Lookup / Refers To: ForecastingFilter. |
| ForecastingSourceDefinitionId | reference | Filter, Group, Sort | forecasting source definition의 ID. 관계 필드 — Relationship Name: ForecastingSourceDefinition / Type: Lookup / Refers To: ForecastingSourceDefinition. |
| FullName | string | Create, Group, Nillable | 예측 필터 조건의 full name. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | 예측 필터 조건의 언어. |
| MasterLabel | string | Filter, Group, Sort | Setup에 표시되는 라벨. org의 default language locale, 없으면 en_US. |
| Metadata | ForecastingFilterCondition | Create, Nillable, Update | 예측 필터 조건의 metadata. |
| Operation | picklist | Filter, Group, Restricted picklist, Sort | 필터 조건의 연산자. 가능 값: equals, greaterOrEqual—greater than or equal to, greaterThan, lessOrEqual—less than or equal to, lessThan, notEqual—not equal to. |
| SortOrder | int | Filter, Group, Sort | 조건의 index 값. ForecastingFilter의 FilterLogic 필드에서 이 조건을 나타냄(예: 1). |
| Value | string | Filter, Group, Nillable, Sort | 필터 조건의 값. 여러 값은 콤마 구분자로 분리. **Note:** 멀티 통화가 활성화되어 있고 예측 유형 정의의 일부로 통화 필드에 커스텀 필터를 추가하면 필터 생성 시점의 corporate currency가 사용됨. 단일 통화가 활성화되어 있으면 absolute value가 필터 조건에 사용됨. |

### OpportunitySplitType (11필드)

각 split type의 라벨·동작을 나타낸다.

- **API 버전:** 37.0 and later
- **Supported SOAP Calls:** `describeSObjects()`, `query()`, `retrieve()` — 읽기전용
- **Supported REST Methods:** GET
- **Special Access Rules:** 없음 (단, NamespacePrefix는 Customize Application 권한 필요 — 아래 필드 노트 참조)
- **Note(본문):** 이 객체는 read only이며 Teamselling과 Opportunity Splits가 활성화된 경우에만 사용 가능. 기본 split type 2가지 존재 — revenue split(합계 100%여야 함)과 overlay split(임의 percentage 합계 가능).

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Filter, Group, Sort, Update | split type의 목적 설명(향후 개발자에게 컨텍스트 제공). |
| DeveloperName | string | Create, Filter, Group, Sort, Update | Required. API에서 객체의 unique 이름. managed package에서 네이밍 충돌 방지(공통 반복 필드 참조). **대량 데이터 생성 시 각 레코드에 unique DeveloperName 지정**(미지정 시 성능 저하). |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | split type 활성/비활성. |
| IsTotalValidated | boolean | Create, Defaulted on create, Filter, Group, Sort | true면 split 합계가 100%여야 함. false면 임의 percentage 합계 가능. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | UI에서 split 라벨의 언어를 나타냄. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | 컴포넌트 manageable 상태(공통 반복 필드 참조): beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. 이 필드는 API 버전 38.0 and later에서 사용 가능. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | split type의 UI 라벨. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체에 연관된 네임스페이스 프리픽스(Limit 15자, Dev Edition vs non-Dev Edition 동작). **로그인 사용자가 Customize Application 권한을 가져야 접근 가능.** |
| SplitEntity | picklist | Create, Filter, Group, Restricted picklist, Sort | 포함하는 record type(예: opportunity). API 버전 30 and later. |
| SplitField | picklist | Create, Filter, Group, Restricted picklist, Sort | opportunity 객체의 어느 통화 필드가 split되는지 지정. API 버전 30 and later. |
| SplitDataStatus | picklist | Filter, Group, Nillable, Restricted picklist, Sort, Update | split type의 상태. API 버전 30 and later. |

### AccountPlanObjMeasCalcDef (10필드)

sales account plan objective measure 계산 정의에 연관된 metadata를 나타낸다. 계산 정의는 target object·rollup field·현재값 계산 로직을 포함한다.

- **API 버전:** 63.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** AccountPlanObjMeasCalcDef 컴포넌트에 접근하려면 account plans를 활성화.
- **Note:** Important — noninclusive 용어를 Equality 가치에 맞춰 변경했으나 일부 용어는 고객 구현 영향을 피하기 위해 유지.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Filter, Group, Nillable, Sort, Update | 사용자가 account plan objective measure에 정의를 선택할 때 보이는 계산 정의 요약. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | API에서 객체의 unique 이름(공통 반복 필드 참조). Label is Record Type Name. |
| ManageableState | picklist (ManageableState enumerated list) | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 컴포넌트 manageable 상태: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | AccountPlanObjMeasCalcDef 객체의 라벨. UI에서 이 필드는 Label. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체에 연관된 네임스페이스 프리픽스(공통 반복 필드 참조). |
| RollupType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | 계산 정의 및 선택 조건에 매칭되는 레코드로부터 account plan objective measure의 현재값을 계산하는 방법. 가능 값: Count, Max—Maximum, Min—Minimum, Sum. |
| Status | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | 계산 정의의 상태. active 정의만 사용자가 선택 가능. 가능 값: Active, Draft, Inactive. |
| TargetField | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 현재값 계산에 사용할 TargetObject의 필드. Campaign, Case, Contact, Opportunity 객체의 rollup 필드 지원. Setup에서 이 필드 라벨은 Rollup Field. |
| TargetObject | picklist | Create, Filter, Group, Restricted picklist, Sort | 현재값 계산에 사용할 객체. 가능 값: Campaign, Case, Contact, Opportunity. |
| ValueType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 현재값 계산의 데이터 타입. 가능 값: Currency, Number, Percent. |

> 📦 Metadata Type 형태(배포용)는 [[Metadata Types — Einstein & Analytics]] 참조.

### ForecastingTypeSource (10필드)

forecasting source definition을 예측 유형에 매핑하는 것을 나타낸다.

- **API 버전:** 52.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()` — **update()/upsert() 없음**
- **Supported REST Methods:** DELETE, GET, HEAD, POST, Query — **PATCH 없음**
- **Special Access Rules:** 없음
- **Note:** Important — noninclusive 용어 정렬, 일부 용어는 유지.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | forecasting source definition의 developer name. |
| ForecastingSourceDefinitionId | reference | Filter, Group, Sort | forecasting source definition의 ID. 관계 필드 — Relationship Name: ForecastingSourceDefinition / Type: Lookup / Refers To: ForecastingSourceDefinition. |
| ForecastingTypeId | reference | Filter, Group, Sort | 예측 유형의 ID. Summer '21 이후 생성된 예측 유형에만 연결 가능. 관계 필드 — Relationship Name: ForecastingType / Type: Lookup / Refers To: ForecastingType. |
| FullName | string | Create, Group, Nillable | forecasting type source의 full name. |
| Language | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | forecasting type source의 언어. |
| MasterLabel | string | Filter, Group, Sort | Required. 이 forecasting type source의 controlling label. |
| Metadata | ForecastingTypeSource | Create, Nillable, Update | forecasting source definition의 metadata. |
| ParentSourceDefinitionId | reference | Filter, Group, Nillable, Sort | Opportunity 객체 기반이 아니고 커스텀 measure 기반도 아닌 예측 유형에서, 연결된 ForecastingSourceDefinition의 부모 ForecastingSourceDefinition ID. 관계 필드 — Relationship Name: ParentSourceDefinition / Type: Lookup / Refers To: ForecastingSourceDefinition. |
| RelationField | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 부모 ForecastingSourceDefinition의 source object를 자식 ForecastingSourceDefinition에 연결하는 필드. 가능 값: OpportunityLineItem.OpportunityId, OpportunityLineItem.Product2Id. |
| SourceGroup | int | Filter, Group, Sort | Required. forecast type source 정의의 그룹화를 나타냄. |

### AdvAcctForecastMeasureDef (8필드)

예측 세트의 고급 계정 예측 그리드에 표시할 measure 정보를 나타낸다.

- **API 버전:** 57.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| AdvAccountForecastSetId | reference | Create, Filter, Group, Sort, Update | 고급 계정 예측 메트릭에 연관된 예측 세트. SalesAgreementSettings도 참조 가능. 관계 필드 — Relationship Name: AdvAccountForecastSet / Type: Lookup / Refers To: AdvAccountForecastSet. |
| AdvAcctForecastMeasureDefName | string | Create, Filter, Group, idLookup, Sort, Update | 고급 계정 예측 measure 정의의 이름. |
| AggregationType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 고급 계정 예측 값 계산에 사용되는 집계 유형. 가능 값: AVERAGE—Average, MAXIMUM—Maximum, MINIMUM—Minimum, SUM—Sum. 기본값 SUM. |
| ComputationMethod | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 고급 계정 예측 값 계산 방법. 가능 값: CUSTOM—Custom, DATA_PROCESSING_ENGINE_DEFINITION—Data Processing Engine definition, FORMULA—Formula. 기본값 DATA_PROCESSING_ENGINE_DEFINITION. |
| ForecastDataMeasureName | string | Create, Filter, Group, Sort, Update | 이 measure에 사용되는 facts 객체의 필드. |
| ForecastMeasureName | string | Create, Filter, Group, Sort, Update | UI에 표시할 measure 이름. |
| ForecastMeasureType | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | 생성된 고급 예측 값에 사용되는 measure 유형. 가능 값: QUANTITY—Quantity, REVENUE—Revenue. 기본값 QUANTITY. |
| IsAdjustmentTracked | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 이 메트릭의 고급 계정 예측 값에 대한 조정이 추적되는지 여부. 기본값 false. |

### ForecastingFilter (8필드)

opportunity 예측에 데이터를 포함/제외하기 위한 커스텀 필터를 나타낸다.

- **API 버전:** 55.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** Spring '20 이후, View All Forecasts 권한 OR Allow Forecasting 권한 OR delegated forecast manager 상태를 가진 standard user만 접근 가능.
- **Note:** Important — noninclusive 용어 정렬, 일부 용어는 유지.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | 예측 필터의 developer name. |
| FilterLogic | string | Filter, Group, Nillable, Sort | 조건 평가를 제어하는 로직. AND만 지원(예: 1 AND 2 AND 3). |
| ForecastingTypeId | reference | Filter, Group, Sort | 예측 유형의 ID. Summer '21 이후 생성된 예측 유형에만 연결 가능. 관계 필드 — Relationship Name: ForecastingType / Type: Lookup / Refers To: ForecastingType. |
| ForecastingTypeSourceId | reference | Filter, Group, Sort | forecast type source의 ID. Summer '21 이후 생성되고 source object가 'Opportunity'인 forecast source definition을 가진 forecast type source에만 연결 가능. 관계 필드 — Relationship Name: ForecastingTypeSource / Type: Lookup / Refers To: ForecastingTypeSource. |
| FullName | string | Create, Group, Nillable | 예측 필터의 full name. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | 예측 필터의 언어. |
| MasterLabel | string | Filter, Group, Sort | Setup에 표시되는 라벨. org의 default language locale, 없으면 en_US. |
| Metadata | ForecastingFilter | Create, Nillable, Update | 예측 필터의 metadata. |

### AdvAcctFrcstDisplayGroup (5필드)

고급 계정 예측 세트의 measure 또는 dimension에 대한 그룹 정보를 나타낸다.

- **API 버전:** 57.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| AdvAccountForecastSetId | reference | Create, Filter, Group, Nillable, Sort, Update | 고급 계정 예측 display group에 연관된 예측 세트. 이 필드는 polymorphic 관계 필드 — Relationship Name: AdvAccountForecastSet / Type: Lookup / Refers To: AdvAccountForecastSet, SalesAgreementSettings. |
| AdvAcctFrcstDisplayGroupName | string | Create, Filter, Group, idLookup, Sort, Update | 고급 계정 예측 그룹의 이름. |
| GroupType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | display group의 카테고리 지정. 가능 값: MEASURE. |
| IsDefault | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | display group이 기본 그룹인지 여부. 기본값 false. |
| UserProfileId | reference | Create, Filter, Group, Nillable, Sort, Update | display group이 적용되는 profile. 관계 필드 — Relationship Name: UserProfile / Type: Lookup / Refers To: Profile. |

### PipelineInspMetricConfig (5필드)

Pipeline Inspection 뷰에 표시되는 forecast category 메트릭의 구성을 나타낸다.

- **API 버전:** 55.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음
- **Note:** Important — noninclusive 용어 정렬, 일부 용어는 유지.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Create, Filter, Group, Sort, Update | Read only. API에서 Pipeline Inspection 메트릭 구성의 unique 이름. |
| IsCumulative | boolean | Defaulted on create, Filter, Group, Sort | Read only. 메트릭이 누적인지 여부. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Read only. Pipeline Inspection 메트릭의 언어. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | Pipeline Inspection 메트릭의 커스텀 라벨. Limit: 50자. |
| Metric | picklist | Create, Filter, Group, Restricted picklist, Sort | Pipeline Inspection 메트릭. 가능 값: BestCase, ClosedLost, ClosedWon, Commit, MostLikely, OpenPipeline, TotalPipeline. |

### AccountPlanObjMeasCalcCond (4필드)

sales account plan objective measure의 현재값 계산에 포함할 레코드를 필터링하기 위한 field·value 조합을 나타낸다.

- **API 버전:** 63.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음 (PDF에 섹션은 존재하나 본문 비어 있음)

| 필드 | Type | Properties | Description |
|---|---|---|---|
| AccountPlanObjMeasCalcDefId | reference | Create, Filter, Group, Sort | 이 조건이 사용되는 account plan objective measure 계산 정의. 관계 필드 — Relationship Name: AccountPlanObjMeasCalcDef / Type: Master-detail / Refers To: AccountPlanObjMeasCalcDef (master 객체). |
| FieldName | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | 필터링할 계산 정의 TargetObject의 필드. Campaign, Case, Contact, Opportunity 객체의 필드 지원. |
| Operation | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | 지정 필드 값과 레코드를 매칭하는 논리 연산자. 가능 값: Contains—contains, Equals—equals, GreaterOrEqual—greater or equal, GreaterThan—greater than, LessOrEqual—less or equal, LessThan—less than, NotContain—does not contain, NotEqual—not equal to, StartsWith. |
| Value | string | Create, Filter, Group, Nillable, Sort, Update | 지정 필드에 매칭할 값. |

### Territory2SupportedObject (4필드)

테리토리가 지원하는 객체 유형을 나타낸다.

- **API 버전:** 57.0 and later
- **Supported SOAP Calls:** `describeSObjects()`, `query()`, `retrieve()` — 읽기전용
- **Supported REST Methods:** GET, HEAD, Query
- **Special Access Rules:** Manage Territories 사용자 권한을 활성화.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| DefaultAccessLevel | string | Filter, Group, Nillable, Sort | 테리토리에 할당된 객체의 기본 access level. |
| DurableId | string | Filter, Group, Nillable, Sort | 필드의 unique 식별자. |
| ObjectType | string | Filter, Group, Nillable, Sort | 테리토리가 지원하는 객체 유형. |
| State | string | Filter, Group, Nillable, Sort | 객체 유형의 support 활성화 상태. |

### ForecastingDisplayedFamily (2필드)

Lightning Experience에서 관리자가 예측을 허용하기로 선택한 product family를 나타낸다.

- **API 버전:** 40.0 and later
- **Supported SOAP Calls:** `describeSObjects()`, `query()`, `retrieve()` — 읽기전용(create/update/delete 없음)
- **Supported REST Methods:** GET
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| DisplayPosition | int | Filter, Group, idLookup, Nillable, Sort | 예측 페이지에 product family가 표시되는 순서. 각 값은 product family마다 unique. |
| ProductFamily | picklist | Filter, Group, Sort | 예측 가능한 product family. 각 product family는 unique. |

---

## 2. AI · ML · Agentforce · 추천 · 데이터정제 — 11종

### MLPredictionDefinition (18필드)

머신러닝(ML) 애플리케이션에서 prediction definition 내 prediction의 세부를 나타낸다.

- **API 버전:** 50.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음
- **Note:** Important — noninclusive 용어 정렬, 일부 용어는 유지.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| ApplicationId | reference | Filter, Group, Nillable, Sort | prediction definition에 연관된 application의 ID. 관계 필드 — Relationship Name: Application / Type: Lookup / Refers To: AIApplication. |
| Description | string | Filter, Group, Nillable, Sort | prediction 설명. |
| DeveloperName | string | Filter, Group, Nillable, Sort | API에서 객체의 unique 이름(공통 반복 필드 참조). **대량 데이터 생성 시 각 레코드에 unique DeveloperName 지정.** |
| FullName | string | Create, Group, Nillable | Metadata API의 연관 MLPredictionDefinition 타입 full name(네임스페이스 프리픽스 포함 가능; 1건 초과 시 error). |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | MLPredictionDefinition의 언어. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | 컴포넌트 manageable 상태: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Filter, Group, Nillable, Sort | Salesforce UI 전반에서 MLPredictionDefinition을 식별하는 라벨. |
| Metadata | AIApplication | Create, Nillable, Update | MLPredictionDefinition의 metadata(1건 초과 시 error). **Type이 `AIApplication`임 — PDF 표기 그대로이며 자기 타입이 아님.** |
| MLDataDefinitions | QueryResult | Nillable | ML application 레코드에 연관된 prediction definition 레코드 목록. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체에 연관된 네임스페이스 프리픽스(공통 반복 필드 참조). |
| NegativeExpressionId | reference | Filter, Group, Nillable, Sort | Reserved for future use. 관계 필드 — Relationship Name: NegativeExpression / Type: Lookup / Refers To: MLFilter. |
| PositiveExpressionId | reference | Filter, Group, Nillable, Sort | Reserved for future use. 관계 필드 — Relationship Name: PositiveExpression / Type: Lookup / Refers To: MLFilter. |
| PredictionField | string | Filter, Group, Nillable, Sort | prediction이 기반하는 필드. |
| PredictionStrategy | string | Filter, Group, Nillable, Sort | prediction이 기반하는 strategy. |
| Priority | int | Filter, Group, Nillable, Sort | AIApplication이 여러 자식 MLPD를 가질 때 MLPredictionDefinition(MLPD) 객체의 우선순위 반영. |
| PushbackField | string | Filter, Group, Nillable, Sort | prediction이 점수를 기록하는 필드. |
| Status | picklist | Filter, Group, Restricted picklist, Nillable, Sort | prediction의 상태. 가능 값: Disabled, Draft, Enabled. |
| Type | picklist | Filter, Group, Restricted picklist, Nillable, Sort | prediction 값을 반환하는 모델 유형. 가능 값: BinaryClassification—1, DeepLearningIntentClassification—5, DeepLearningNameEntityRecognition—6, GlobalDeepLearningIntentClassification—7, GlobalDeepLearningNameEntityRecognition—8, LanguageDetection—4, MulticlassClassification—2, Regression—3, ScoringSpecificOutcome—0. |

### MLFilter (14필드)

머신러닝(ML) 애플리케이션에서 데이터 비교 기반의 data filter를 나타낸다. 각 비교는 left-hand element, operator, right-hand element로 구성된다.

- **API 버전:** 50.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| FilterName | string | Create, Filter, Group, Nillable, Sort, Update | 필터의 이름. |
| LhFilterId | reference | Create, Filter, Group, Nillable, Sort, Update | left-hand 필터 조건의 ID. 관계 필드 — Relationship Name: LhFilter / Type: Lookup / Refers To: MLFilter. |
| LhPredictionField | string | Create, Filter, Group, Nillable, Sort, Update | left-hand prediction 필드. |
| LhType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | left-hand 값이 지정된 경우의 값 타입. 가능 값: Boolean, Comparison, Currency, Date, DateTime—Datetime, Number, String, Supplier, Varchar. |
| LhUnit | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | left-hand 필터가 지정된 경우의 단위. 가능 값: Days, Hours, Milliseconds, Minutes, Months, Seconds, Weeks, Years. |
| LhValue | string | Create, Filter, Group, Nillable, Sort, Update | left-hand 값. |
| Operation | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 데이터를 필터링하는 방법. 가능 값: Add, And, Between, Concat, Contains, Divide, DoesNotContain, EndsWith, Equals, GreaterThan, GreaterThanOrEqual, In, IsNotNull, IsNull, LessThan, LessThanOrEqual, Multiply, Not, NotEquals, Or, StartsWith, Subtract. |
| ParentDefinitionId | reference | Filter, Group, Nillable, Sort | 이 MLFilter가 속한 MLRecommendationDefinition, MLPredictionDefinition, 또는 MLDataDefinition의 ID. polymorphic 관계 — Relationship Name: ParentDefinition / Type: Lookup / Refers To: MLDataDefinition, MLPredictionDefinition, MLRecommendationDefinition. |
| RhFilterId | reference | Create, Filter, Group, Nillable, Sort, Update | right-hand 필터 조건의 ID. 관계 필드 — Relationship Name: RhFilter / Type: Lookup / Refers To: MLFilter. |
| RhPredictionField | string | Create, Filter, Group, Nillable, Sort, Update | right-hand prediction 필드. |
| RhType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | right-hand 값이 지정된 경우의 값 타입. 가능 값: Boolean, Comparison, Currency, Date, DateTime—Datetime, Number, String, Supplier, Varchar. |
| RhUnit | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | right-hand 필터가 지정된 경우의 단위. 가능 값: Days, Hours, Milliseconds, Minutes, Months, Seconds, Weeks, Years. |
| RhValue | string | Create, Filter, Group, Nillable, Sort, Update | right-hand 값. |
| SortOrder | int | Create, Filter, Group, Nillable, Sort, Update | expression 평가의 연산 순서 지정(예: 조건이 두 개면 어느 조건이 먼저 평가되는지). |

### MLDataDefinition (13필드)

머신러닝(ML) 애플리케이션용 모델을 생성하는 데 사용되는 데이터를 지정하는 modeling data definition을 나타낸다. 필터·포함 필드·제외 필드 등을 포함할 수 있다.

- **API 버전:** 50.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음
- **Note:** Important — noninclusive 용어 정렬, 일부 용어는 유지.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Nillable, Sort | API에서 객체의 unique 이름(공통 반복 필드 참조). **대량 데이터 생성 시 각 레코드에 unique DeveloperName 지정.** |
| EntityDeveloperName | string | Filter, Group, Nillable, Sort | 모델 데이터를 가져오는 객체의 developer name. **Note:** MLDataDefinition 엔터티 생성 후에는 EntityDeveloperName을 업데이트할 수 없음. |
| FullName | string | Create, Group, Nillable | Metadata API의 연관 MLDataDefinition 타입 full name(네임스페이스 프리픽스 포함 가능; 1건 초과 시 error). |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | MLDataDefinition의 언어. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | 컴포넌트 manageable 상태: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Filter, Group, Nillable, Sort | Salesforce UI 전반에서 MLDataDefinition을 식별하는 라벨. |
| Metadata | MLDataDefinition | Create, Nillable, Update | MLDataDefinition의 metadata(1건 초과 시 error). |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체에 연관된 네임스페이스 프리픽스(Limit 15자; Dev Edition vs non-Dev Edition 동작). |
| ParentDefinitionId | reference | Filter, Group, Nillable, Sort | 이 MLDataDefinition이 속한 MLRecommendationDefinition 또는 MLPredictionDefinition의 ID. polymorphic 관계 — Relationship Name: ParentDefinition / Type: Lookup / Refers To: MLPredictionDefinition, MLRecommendationDefinition. |
| ScoringFilterId | reference | Filter, Group, Nillable, Sort | prediction 점수가 기록되는 레코드 ID 지정. 관계 필드 — Relationship Name: ScoringFilter / Type: Lookup / Refers To: MLFilter. |
| SegmentFilterId | reference | Filter, Group, Nillable, Sort | training·scoring에 사용되는 데이터의 레코드 ID 지정. 관계 필드 — Relationship Name: SegmentFilter / Type: Lookup / Refers To: MLFilter. |
| TrainingFilterId | reference | Filter, Group, Nillable, Sort | training set을 구성하는 레코드 ID 지정. 관계 필드 — Relationship Name: TrainingFilter / Type: Lookup / Refers To: MLFilter. |
| Type | picklist | Filter, Group, Restricted picklist, Nillable, Sort | 데이터 유형 지정. 가능 값: Candidate, Interaction, Prediction, Recipient. **Note:** 모델 생성 후에는 type을 업데이트할 수 없음. |

### GenAiFunctionDefinition (12필드)

agent action(Agentforce)을 나타낸다.

- **API 버전:** 60.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 이 객체에 접근하려면 org에서 Agents가 활성화되어 있어야 함.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Nillable | action의 일반 목적·도메인을 설명. |
| DeveloperName | string | Filter, Group, Sort | 이 객체의 unique 이름. |
| FullName | string | Create, Group, Nillable | Metadata API의 연관 객체 full name(네임스페이스 프리픽스 포함 가능). |
| InvocationTarget | picklist | Filter, Group, Restricted picklist, Sort | invocation 연산에 사용되는 target invocation. |
| InvocationTargetType | picklist | Filter, Group, Restricted picklist, Sort | invocation 연산에 사용되는 invocable action 유형. 가능 값: apex, flow, generatePromptResponse. |
| IsConfirmationRequired | boolean | Defaulted on create, Filter, Group, Sort | 이 action에 confirmation이 필요한지 여부. 기본값 false. |
| IsIncludeInProgressIndicator | boolean | Defaulted on create, Filter, Group, Sort | ProgressIndicatorMessage가 표시되는지 여부. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | GenAiFunctionDefinition의 언어. 이 필드 값은 org의 언어 값. |
| MasterLabel | string | Filter, Group, Sort | generative AI action의 master label. |
| Metadata | complexvalue | Create, Nillable, Update | 연관 타입에 대한 접근 제공. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | GenAiFunctionDefinition의 네임스페이스. |
| ProgressIndicatorMessage | string | Filter, Group, Sort | action 실행이 예상보다 오래 걸릴 때 표시되는 메시지. |

> InvocableActionExtension가 확장하는 invocable action(apex/flow) 도메인은 [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] 참조.

### RecommendationStrategy (12필드)

recommendation strategy를 나타낸다. recommendation strategy는 data flow와 유사한 application으로, data retrieval·branching·filtering·logic 연산을 통해 클라이언트에 전달할 recommendation 집합을 결정한다.

- **API 버전:** 45.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `query()`, `retrieve()`, `update()`, `upsert()` — **describeSObjects() 없음**
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| ContextRecordType | string | Filter, Group, Nillable, Sort | flow가 사용하는 $Record의 sObject 타입. |
| Description | string | Filter, Group, Nillable, Sort | recommendation strategy 설명. |
| DeveloperName | string | Filter, Group, Sort | API에서 recommendation strategy의 unique 이름(공통 반복 필드 참조). Label is Record Type Name. |
| Fullname | string | Create, Group, Nillable | Metadata API의 연관 metadata 타입 full name(1건 초과 시 error). **필드명은 `Fullname`(소문자 n) — 다른 객체의 `FullName`과 다르며 정규화 금지.** |
| IsTemplate | boolean | Defaulted on create, Filter, Group, Sort | recommendation strategy가 template인지(true) 아닌지(false). managed package에서 설치된 경우, IP(지적재산권) 보호 때문에 subscriber가 recommendation strategy를 보거나 clone할 수 없음. 단 template인 경우 subscriber가 builder에서 열고 clone하여 clone을 커스터마이징할 수 있음. 기본값 false. API 버전 47.0 and later. |
| Label | string | Filter, Group, Sort | Required. recommendation strategy의 라벨. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | recommendation strategy의 언어. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | 컴포넌트 manageable 상태: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Filter, Group, Sort | recommendation strategy의 master label. 번역되지 않는 내부 라벨. Limit: 40자. |
| Metadata | mns: RecommendationStrategy | Create, Nillable, Update | recommendation strategy의 metadata(1건 초과 시 error). managed package의 일부면 이 필드는 Null. managed package의 recommendation strategy에 대해서는 metadata가 반환되지 않음(단, template인 경우 예외). (Type 표기 `mns: RecommendationStrategy`는 PDF 그대로.) |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체에 연관된 네임스페이스 프리픽스(Limit 15자; Dev Edition vs non-Dev Edition). |
| OnBehalfOfExpression | string | Filter, Group, Nillable, Sort | recommendation의 의도된 target을 정의하는 formula expression(예: Case에 연관된 Contact). 주로 reaction tracking에 사용. |

> 📦 Metadata Type 형태(배포용)는 [[Metadata Types — Einstein & Analytics]] 참조.

### AIApplicationConfig (11필드)

머신러닝(ML) 애플리케이션에 관련된 추가 prediction 정보를 나타낸다.

- **API 버전:** 50.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음
- **Note:** Important — noninclusive 용어 정렬, 일부 용어는 유지.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| ApplicationId | reference | Filter, Group, Nillable, Sort | 부모 ML application의 ID. 관계 필드 — Relationship Name: Application / Type: Lookup / Refers To: AIApplication. |
| DeveloperName | string | Filter, Group, Nillable, Sort | API에서 객체의 unique 이름(공통 반복 필드 참조). Label is Record Type Name. 자동 생성되나 API 생성 시 직접 지정 가능. |
| FullName | string | Create, Group, Nillable | Metadata API의 연관 AIApplicationConfig 타입 full name(네임스페이스 프리픽스 포함 가능; 1건 초과 시 error). |
| IsInsightReasonEnabled | boolean | Defaulted on create, Filter, Group, Nillable, Sort | true이면 prediction 값 생성에 사용된 predictor 또는 field 값을 생성. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | AIApplicationConfig의 언어. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | 컴포넌트 manageable 상태: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Filter, Group, Nillable, Sort | Salesforce UI 전반에서 AIApplicationConfig를 식별하는 라벨. |
| Metadata | AIApplicationConfig | Create, Nillable, Update | AIApplicationConfig의 metadata(1건 초과 시 error). |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체에 연관된 네임스페이스 프리픽스(Limit 15자; Dev Edition vs non-Dev Edition 동작). |
| Rank | int | Defaulted on create, Filter, Group, Nillable, Sort | Reserved for future use. |
| ScoringMode | picklist | Defaulted on create, Filter, Group, Restricted picklist, Nillable, Sort | prediction 점수가 기록되는 빈도(frequency with which the prediction scores are written back). 가능 값: Batch, OnDemand, Streaming. |

> 📦 Metadata Type 형태(배포용)는 [[Metadata Types — Einstein & Analytics]] 참조.

### AIApplication (10필드)

머신러닝(ML) 애플리케이션의 인스턴스를 나타낸다.

- **API 버전:** 50.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음
- **Note:** Important — noninclusive 용어를 Equality 가치에 맞춰 변경했으나 일부 용어는 고객 구현 영향을 피하기 위해 유지.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Nillable, Sort | API에서 객체의 unique 이름(공통 반복 필드 참조). 자동 생성되나 직접 지정 가능. **대량 데이터 생성 시 각 레코드에 unique DeveloperName 지정**(미지정 시 성능 저하). |
| FullName | string | Create, Group, Nillable | Metadata API의 연관 AIApplication 타입 full name(네임스페이스 프리픽스 포함 가능; 1건 초과 시 error). |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | AIApplication의 언어. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | 컴포넌트 manageable 상태: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Filter, Group, Nillable, Sort | Salesforce UI 전반에서 AIApplication을 식별하는 라벨. |
| Metadata | AIApplication | Create, Nillable, Update | AIApplication의 metadata(1건 초과 시 error). |
| MLPredictionDefinitions | QueryResult | Nillable | ML application 레코드에 연관된 ML prediction definition 레코드 목록. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체에 연관된 네임스페이스 프리픽스(Limit 15자). |
| Status | picklist | Defaulted on create, Filter, Group, Restricted picklist, Nillable, Sort | application의 상태. 가능 값: Disabled—0, Draft—3, Enabled—1, Migrated—2. (코드 비순차 주의.) |
| Type | picklist | Filter, Group, Restricted picklist, Nillable, Sort | application의 유형. 가능 값: PredictionBuilder—5, RecommendationBuilder—14. |

> 📦 Metadata Type 형태(배포용)는 [[Metadata Types — Einstein & Analytics]] 참조.

### GenAiPlannerDefinition (8필드)

대형 언어 모델(LLM)과 reasoning strategy를 사용해 주어진 task를 더 작은 subtask로 분해하고, 각 subtask에 가장 적합한 action을 식별·호출하는 agent planner service(Agentforce)를 나타낸다.

- **API 버전:** 60.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 이 객체에 접근하려면 org에서 Agents가 활성화되어 있어야 함.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Capabilities | string | Filter, Group, Nillable, Sort | agent planner service 정의에 연관된 tag 집합. |
| Description | textarea | Filter, Group, Sort | agent planner service 정의의 일반 목적·도메인 설명. |
| DeveloperName | string | Filter, Group, Sort | 이 객체의 unique 이름. |
| FullName | string | Create, Group, Nillable | Metadata API의 연관 객체 full name(네임스페이스 프리픽스 포함 가능). |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | GenAiPlannerDefinition의 언어. 이 필드 값은 org의 언어 값. |
| MasterLabel | string | Filter, Group, Sort | agent planner service 정의의 master label. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | GenAiPlannerDefinition의 네임스페이스. |
| PlannerType | picklist | Filter, Group, Restricted picklist, Sort | LLM에 prompt instruction으로 주어지는 문제 해결 접근법. 가능 값: **AiCopilot__ReAct**—LLM으로 문제를 푸는 reactive planning 전략 사용. 이벤트와 현재 컨텍스트에 응답해 LLM이 다음 단계를 생성하도록 prompt. sequential planner와 달리 한 단계 이상 미리 계획하지 않음. / **AiCopilot__SequentialPlannerIntentClassifier**—intent classifier prompt와 sequential planner prompt 사용. 각 텍스트 입력마다 planner가 LLM에 목표 완수를 위한 단계별 계획 생성을 요청. 먼저 계획한 뒤 실행. |

### CleanDataService (7필드)

org의 기존 레코드에 데이터를 추가·업데이트하는 data service를 나타낸다.

- **API 버전:** 38.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()` — **search() 포함**
- **Supported REST Methods:** GET — **GET만**
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Filter, Group, Nillable, Sort, Update | data service를 설명하는 사용자 친화 텍스트. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | 이 data service의 unique 이름(공통 반복 필드 참조). 동일 MasterLabel을 가진 다른 data service와의 충돌을 방지하는 글로벌 unique 식별자 제공. **Note:** "View DeveloperName" 또는 "View Setup and Configuration" 권한이 있는 사용자만 이 필드를 조회·그룹·정렬·필터 가능. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | data service의 언어. 지원 값(18개 locale): Chinese (Simplified)—zh_CN, Chinese (Traditional)—zh_TW, Danish—da, Dutch—nl_NL, English—en_US, Finnish—fi, French—fr, German—de, Italian—it, Japanese—ja, Korean—ko, Norwegian—no, Portuguese (Brazil)—pt_BR, Russian—ru, Spanish—es, Spanish (Mexico)—es_MX (customer-defined 번역은 Spanish로 default), Swedish—sv, Thai—th (UI는 완전 번역, Help는 영어). |
| ManageableState | picklist (ManageableState enumerated list) | Filter, Group, Nillable, Restricted picklist, Sort | 컴포넌트 manageable 상태: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | 이 객체의 master label. 번역되지 않는 내부 라벨 display 값. |
| MatchEngine | string | Create, Filter, Group, Nillable, Sort, Update | 내부 data service 식별자로 매핑되는 key. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | data service에 연관된 네임스페이스 프리픽스(Lightning Platform AppExchange 패키지에 할당). 네임스페이스는 다른 data service가 사용하는 것과 커스텀 객체·필드를 구분하는 데 도움. |

### InvocableActionExtension (6필드)

Salesforce의 invocable action에 대한 확장을 나타낸다.

- **API 버전:** 65.0 and later
- **Supported SOAP Calls:** `describeSObjects()`, `query()`, `retrieve()` — 읽기전용
- **Supported REST Methods:** GET, HEAD, Query
- **Special Access Rules:** 없음
- **Note:** Important — noninclusive 용어 정렬, 일부 용어는 유지.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | InvocableActionExtension 객체의 unique 이름(공통 반복 필드 참조). 자동 생성되나 직접 지정 가능. **대량 데이터 생성 시 각 레코드에 unique DeveloperName 지정**(미지정 시 성능 저하). |
| Language | picklist | Filter, Group, Restricted picklist, Sort | 패키지의 언어. picklist 값은 Salesforce Help의 Fully Supported Languages와 일치. 언어 미지정 시 패키지를 생성한 Dev Hub 사용자의 언어로 default. 이 필드는 API 버전 65.0 and later에서 사용 가능. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | 컴포넌트 manageable 상태: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Filter, Group, Sort | InvocableActionExtension의 라벨. UI에서 이 필드는 InvocableActionExtension. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체에 연관된 네임스페이스 프리픽스(Limit 15자, `namespacePrefix__componentName` 표기). |
| ReferenceObjectId | reference | Filter, Group, Nillable, Sort | 이 InvocableActionExtension이 확장하는 Invocable Action을 포함하는 Apex Class에 대한 참조. 주어진 Apex Class마다 InvocableActionExtension은 하나만 존재 가능 — 이 객체 레코드 중 unique 값. 관계 필드 — Relationship Name: ReferenceObject / Refers To: ApexClass. |

### MLField (6필드)

modeling data definition 내의 필드를 나타낸다. modeling data definition은 머신러닝(ML) 애플리케이션용 모델을 생성하는 데 사용되는 데이터를 지정한다.

- **API 버전:** 50.0 and later
- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Entity | picklist | Create, Filter, Group, Restricted picklist, Nillable, Sort, Update | MLField를 포함하는 객체. valid 값은 Internal, Interface, Virtual, InDevelopment 커스텀 객체를 제외한 모든 Salesforce 객체. |
| Field | picklist | Create, Filter, Group, Restricted picklist, Nillable, Sort, Update | MLField의 이름. valid 값은 Internal, Interface, Virtual, InDevelopment 커스텀 객체를 제외한 모든 Salesforce 객체. |
| ParentDefinitionId | reference | Filter, Group, Nillable, Sort | 이 MLField가 속한 MLRecommendationDefinition 또는 MLPredictionDefinition의 ID. polymorphic 관계 — Relationship Name: ParentDefinition / Type: Lookup / Refers To: MLDataDefinition, MLRecommendationDefinition. |
| RelatedFieldId | reference | Create, Filter, Group, Nillable, Sort, Update | Reserved for future use. 관계 필드 — Relationship Name: RelatedField / Type: Lookup / Refers To: MLField. |
| RelationType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Reserved for future use. |
| Type | picklist | Create, Filter, Group, Restricted picklist, Nillable, Sort, Update | 필드가 prediction에서 사용되는 방식. valid 값: Excluded, Expression, Included, Join, NegativeExpression, PositiveExpression, Prediction, Pushback, Related, ScoringExpression, SegmentExpression, SourceDate, TrainingExpression. |

---

## 빠른 참조 — 25객체 요약표

| 객체 | 그룹 | 필드 | API | SOAP | REST | Special Access |
|---|---|---|---|---|---|---|
| AdvAccountForecastSet | 세일즈·예측 | 22 | 56.0 | full CRUD+upsert | DELETE/GET/HEAD/PATCH/POST/Query | 없음 |
| ForecastingSourceDefinition | 세일즈·예측 | 12 | 52.0 | create/delete/describe/query/retrieve (update·upsert 없음) | DELETE/GET/HEAD/POST/Query (PATCH 없음) | 없음 |
| ForecastingType | 세일즈·예측 | 11 | 52.0 | full CRUD+upsert | 전체 | 없음 |
| ForecastingFilterCondition | 세일즈·예측 | 11 | 55.0 | full CRUD+upsert | 전체 | View All Forecasts 등 |
| OpportunitySplitType | 세일즈·예측 | 11 | 37.0 | read-only(describe/query/retrieve) | GET | NamespacePrefix=Customize Application |
| AccountPlanObjMeasCalcDef | 세일즈·예측 | 10 | 63.0 | full CRUD+upsert | 전체 | enable account plans |
| ForecastingTypeSource | 세일즈·예측 | 10 | 52.0 | create/delete/describe/query/retrieve (update·upsert 없음) | DELETE/GET/HEAD/POST/Query (PATCH 없음) | 없음 |
| AdvAcctForecastMeasureDef | 세일즈·예측 | 8 | 57.0 | full CRUD+upsert | 전체 | 없음 |
| ForecastingFilter | 세일즈·예측 | 8 | 55.0 | full CRUD+upsert | 전체 | View All Forecasts 등 |
| AdvAcctFrcstDisplayGroup | 세일즈·예측 | 5 | 57.0 | full CRUD+upsert | 전체 | 없음 |
| PipelineInspMetricConfig | 세일즈·예측 | 5 | 55.0 | full CRUD+upsert | 전체 | 없음 |
| AccountPlanObjMeasCalcCond | 세일즈·예측 | 4 | 63.0 | full CRUD+upsert | 전체 | 없음(빈 섹션) |
| Territory2SupportedObject | 세일즈·예측 | 4 | 57.0 | read-only(describe/query/retrieve) | GET/HEAD/Query | Manage Territories |
| ForecastingDisplayedFamily | 세일즈·예측 | 2 | 40.0 | read-only(describe/query/retrieve) | GET | 없음 |
| MLPredictionDefinition | AI·ML | 18 | 50.0 | full CRUD+upsert | 전체 | 없음 |
| MLFilter | AI·ML | 14 | 50.0 | full CRUD+upsert | 전체 | 없음 |
| MLDataDefinition | AI·ML | 13 | 50.0 | full CRUD+upsert | 전체 | 없음 |
| GenAiFunctionDefinition | AI·ML | 12 | 60.0 | full CRUD+upsert | 전체 | Agents enabled |
| RecommendationStrategy | AI·ML | 12 | 45.0 | create/delete/query/retrieve/update/upsert (describeSObjects 없음) | DELETE/GET/HEAD/PATCH/POST | 없음 |
| AIApplicationConfig | AI·ML | 11 | 50.0 | full CRUD+upsert | 전체 | 없음 |
| AIApplication | AI·ML | 10 | 50.0 | full CRUD+upsert | 전체 | 없음 |
| GenAiPlannerDefinition | AI·ML | 8 | 60.0 | full CRUD+upsert | 전체 | Agents enabled |
| CleanDataService | AI·ML | 7 | 38.0 | +search() 포함 | GET만 | 없음 |
| InvocableActionExtension | AI·ML | 6 | 65.0 | read-only(describe/query/retrieve) | GET/HEAD/Query | 없음 |
| MLField | AI·ML | 6 | 50.0 | full CRUD+upsert | 전체 | 없음 |

> **총 25객체 / 240필드.** ("전체" REST = DELETE/GET/HEAD/PATCH/POST/Query, "full CRUD+upsert" SOAP = create/delete/describeSObjects/query/retrieve/update/upsert.)

### 조회 구조 예시 (SOQL)

```sql
// 구조 예시 — 실제 동작 코드 아님 (Tooling API query() 호출 형태 설명용)
-- 예측 유형 조회 (Tooling API)
SELECT Id, DeveloperName, MasterLabel, DateType, RoleType
FROM ForecastingType

-- ML 예측 정의와 모델 유형 조회
SELECT Id, DeveloperName, Status, Type, ApplicationId
FROM MLPredictionDefinition
WHERE Status = 'Enabled'

-- Metadata 필드는 결과가 1건 이하일 때만 query (1건 초과 시 error)
SELECT Id, DeveloperName, Metadata
FROM ForecastingFilter
WHERE DeveloperName = 'My_Filter'
```

---

## 관련 노트
- [[Tooling API — 개요·REST·SOAP 호출 기초]] — Tooling API 호출 기초·허브
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 전체 객체 분류 카탈로그
- [[Tooling API — SOAP·REST 헤더]] — 호출 헤더
- [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] — InvocableActionExtension가 확장하는 invocable action
- [[Tooling API 객체 — 통합·데이터·결제·마케팅 (외부서비스·Data Kit·페이먼트·Account Engagement)]] — 같은 C4-9 그룹 형제 노트(통합·데이터·결제·마케팅 sObject)
- [[Metadata Types — Einstein & Analytics]] — AIApplication·AIApplicationConfig·RecommendationStrategy·AccountPlanObjMeasCalcDef의 Metadata API 타입 facet (BOUNDARY 교차)
