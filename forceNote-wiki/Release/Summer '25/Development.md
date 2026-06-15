---
tags: [release, summer_25, development, apex, lwc, api]
api_version: v64.0
release_date: 2025-06
created: 2026-06-15
source: salesforce_release_notes_5-17-2026 (3).pdf (Salesforce Summer '25 Release Notes, Tier 2)
aliases: [Summer '25 Development, 서머25 개발, parseAsTemplate, FormulaEval Template Mode, 2GP Convert GA, lightning mediaUtils GA, Heroku Setup GA, embeddedai, flowtesting]
---

# Summer '25 — Development (Apex · LWC · API)

> Summer '25(API v64.0)의 개발자 영역 변경 전수 — 동적 수식 Template Mode 평가(`parseAsTemplate`), 1GP→2GP 패키지 변환 GA, `embeddedai`·`flowtesting`·`ComplianceMgmt`·`CommerceBuyGrp`·`Auth`·`FormulaEval` 등 신규 네임스페이스/클래스, `lightning/mediaUtils` GA와 AgentforceInput/Output LWC 타겟, API v21.0–30.0 폐기 강제, ConnectApi·Connect REST API 레이트 리밋 마이그레이션.

---

## 개요

이 노트는 Summer '25 릴리즈 노트의 **Development 섹션(PDF p440–536)**을 Apex·LWC·API 축으로 정리한 spoke다.

- 상위 허브: [[Summer '25]]
- 강제 적용 항목(Release Updates): [[Summer '25/Release Updates]]
- 플랫폼/자동화/통합: [[Summer '25/Platform]]
- AI/에이전트: [[Summer '25/Agentforce]]

**핵심 메타데이터**

| 항목 | 값 |
|---|---|
| API 버전 | v64.0 |
| LWC API 버전 | 64.0 (custom component용 versioned 변경 **없음**) |
| 출시 | 2025년 06월 |

> 깊이 원칙에 따라 네임스페이스별 신규 클래스/메서드/enum을 전수 기록했다. 전통적 거버너 한도(heap·CPU·SOQL row 등) 증가는 이 섹션에 **없으며**, 레이트 리밋 마이그레이션과 Outbound Message 타임아웃 단축만 존재한다(맨 아래 거버너 섹션 참조).

---

## Apex — GA (Generally Available)

### Convert and Migrate Packages to 2GP (GA) — Package Migrations

1세대 관리 패키지(1GP)를 2세대 패키지(2GP)로 **변환**한 뒤, subscriber org에 설치된 1GP 패키지를 2GP로 **마이그레이션**할 수 있다. 패키지 변환은 패키지의 metadata를 바꾸지 않고, subscriber의 metadata나 데이터를 손상시키지 않는다.

- **Where:** 1세대 관리 패키지(first-generation managed packages).
- **When:** 2025년 6월 17일 이후 available. 스태거드 롤아웃이며 **Asia Pacific 인스턴스는 추후 릴리즈에서 제공**(초기 롤아웃 제외).
- **Who:** `Create and Update Second-Generation Packages` 사용자 권한 필요.

> 관련 CLI: `View Package Metadata Usage`(`sf package version report`)로 패키지가 metadata 파일 크기 한도/최대 파일 수에 근접하는지 확인. `Use CLI to Push Package Upgrades`(push upgrade schedule/abort/조회/목록 4개 신규 명령)는 2025년 6월 20일 이후 제공, 동일 권한 필요(2GP는 AppExchange 보안 리뷰 통과 + Partner Support 케이스 필요, unlocked 패키지는 기본 활성).

### Evaluate Dynamic Formulas in Template Mode — `parseAsTemplate()`

`FormulaBuilder` 클래스에 신규 `parseAsTemplate(Boolean templateMode)` 메서드가 추가되어, formula를 **template mode**로 평가할 수 있다. merge field 구문 `{!Object_Name.Field_Name}`로 레코드 필드 값이 보간(interpolation)된다.

- **Where:** Enterprise / Performance / Unlimited / Developer.

아래 예시에서 `parseAsTemplate()`에 `true`가 전달되면 formula expression이 template mode로 평가되고, Account 레코드의 `name`·`website` 필드 값이 문자열에 보간된다. 출력은 expression `'name & " (" & website & ")"'`와 동일하다.

```apex
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026 (3).pdf
FormulaEval.FormulaInstance ff = Formula.builder()
.withType(Schema.Account.class)
.withReturnType(FormulaEval.FormulaReturnType.STRING)
.withFormula('{!name} ({!website})')
.parseAsTemplate(true)
.build();
```

상세 백링크: [[FormulaEval Namespace]]

---

## Apex — 신규 네임스페이스 / 클래스 (전수)

### `Auth` 네임스페이스

**New Classes**

- `JsonValueOutput` — "Get User Data from JSON String" invocable action의 출력 저장. SSO 중 IdP의 user info response 또는 ID token에서 특정 attribute를 검색한다. 각 인스턴스가 단일 attribute를 저장하며, user registration flow에서 Apex-defined 변수로 사용된다.
- `GeneratedUserData` — "Generate User Data" invocable action의 출력 저장. 사용자 생성에 필요한 필드의 placeholder 값을 생성한다. IdP가 필수 필드를 채울 정보가 부족한 SSO use case용.

**New or Changed Constructors in Existing Classes**

- `AuthProviderTokenResponse(provider, oauthToken, oauthSecretOrRefreshToken, state, idToken)` — 신규 생성자. 신규 `idToken` 프로퍼티 추가. `AuthProviderPluginClass.handleCallback` / `AuthProviderPlugin.handleCallback` 응답에서 ID token을 저장·접근한다.
- `UserData(identifier, firstName, lastName, fullName, email, link, username, locale, provider, siteLoginUrl, attributeMap, idToken, userInfoJSONString)` — 신규 생성자. 신규 `idToken`, `idTokenJSONString`, `userInfoJSONString` 프로퍼티 추가.

### `CommerceBuyGrp` 네임스페이스 (신규)

buyer group에 사용자를 동적으로 할당하는 커스텀 로직을 정의한다.

**New Classes**

- `BuyerGroupEvaluationService` — buyer group에 user를 동적 할당하는 커스텀 로직 정의(메서드).
- `BuyerGroupRequest` — buyer group 식별에 쓰는 account·store 상세 검색(메서드).
- `BuyerGroupResponse` — user에 연관된 buyer group 검색(생성자·메서드).

### `ComplianceMgmt` 네임스페이스 (신규)

control compliance 평가를 위한 클래스/인터페이스.

**New Classes / Interface**

- `ComplianceEvaluation` (interface) — 평가할 parameter name·value 지정.
- `ControlEvaluationInput` — compliance 평가에 필요한 business context value를 저장하는 `ControlInput` map 지정.
- `ControlInput` — compliance 평가에 쓰는 control input 지정.
- `ComplianceEvaluationResponse` — 평가 요청 response 상세.
- `EvaluationResult` — compliance 평가 결과 상세.
- `ComplianceControlLog` — control compliance 평가에 logged된 business context·evidence map.

### `embeddedai` 네임스페이스 (신규)

**New Classes**

- `ApexMap` — 단순 key-value pair 저장(key·value 모두 string type). 생성·복제·문자열 변환 지원.
- `RecordApexRepresentation` — generic SObject record, 필드, 관련 child record를 **중첩 계층 구조**로 모델링. Generative AI summarization prompt 등 hierarchical record data를 소비하는 process용.

### `flowtesting` 네임스페이스 (신규)

Flow Builder에서 생성된 flow test를 위해 **동적으로 생성되는 Apex 클래스**를 제공한다. 고정된 클래스 세트를 정의하지 않으며, Flow Builder에서 생성된 flow·flow test를 반영한다. `sf flow run test` CLI 명령으로 실행한다.

### `FormulaEval` 네임스페이스 (변경)

**New or Changed Methods in Existing Classes**

- `FormulaBuilder.parseAsTemplate(Boolean templateMode)` — 신규 메서드. template mode에서 formula expression을 평가하고 merge field로 값을 보간한다. (위 "Apex — GA"의 코드 예시 참조.)

상세: [[FormulaEval Namespace]]

### `fschousehold` 네임스페이스

- **New Classes:** `RetrievalSummaryDataRefresh` — retrieval summary definition에 연관된 rollup 새로고침.
- **New or Changed Methods:** `FSCPlanService.call(action, args)`에 신규 `IsOnDemandRollupRefreshEnabled` action — on demand data refresh 활성 여부를 boolean으로 반환.

### `HealthCloudExt` 네임스페이스

- **New Classes:** `HomeVisitPatientBenefitDetails`, `HomeVisitPatientQuoteDetails` — patient benefit·patient quote 관련 데이터 저장.

### `InvoiceWriteOff` 네임스페이스 (신규)

**New Classes**

- `WriteOffInvoiceInput` — invoice 상세·write-off 사유 지정.
- `WriteOffInvoiceInputList` — posted invoice 목록 write-off용 invoice 상세.
- `WriteOffInvoiceResponseList` — written off된 invoice 목록 response.
- `WriteOffInvoiceResponse` — posted invoice write-off 요청 response.
- `WriteOffInvoiceResponseError` — write-off 요청에 연관된 error response.

### `Process` 네임스페이스 (변경)

**Changed Enums**

- `Process.PluginDescribeResult.ParameterType` enum에 신규 값 **`TIME`** — `Process.PluginDescribeResult.InputParameter`·`OutputParameter`에 time value를 지정.

### `RevSignaling` 네임스페이스

- **New Classes:** `ProcedurePlan`(현재 pricing procedure plan 인스턴스), `SignalingApexProcessor`(interface — context-driven orchestration logic), `TransactionRequest`(signaling Apex processor에 전달하는 transaction 요청 상세), `TransactionResponse`(transaction response).
- **New Enum:** `TransactionStatus` — transaction response의 요청 status.

### Platform Event Trigger 구성 UI 노출

Setup의 platform event trigger 구성(Platform Events → event → Subscriptions related list)에 신규 **Batch Size · User** 컬럼이 노출된다. 이전에는 Tooling/Metadata API의 `PlatformEventSubscriberConfig`로만 확인 가능했다.

관련: [[EventBus Namespace]]

### ConnectApi (Connect in Apex) 신규/변경 클래스·enum

> ConnectApi 레이트 리밋 마이그레이션은 맨 아래 거버너 섹션 참조.

**New Connect in Apex Classes — 메서드 시그니처 전수**

- Commerce `ConnectApi.CommerceCart`:
  - `addItemToCart(webstoreId, effectiveAccountId, activeCartOrId, cartItemInput, currencyIsoCode, includeCartData)`
  - `updateCartItem(webstoreId, effectiveAccountId, activeCartOrId, cartItemId, cartItem, currencyIsoCode, includeCartData)`
- Commerce `ConnectApi.IBusinessObjectivesAndRecsFamily`:
  - `createRecommendations(busObjRecommendationInput)`
  - `getBusinessObjectives(webstoreId, channelId, kpiName, includeRecSummary, includeInsightSummary)`
  - `getRecommendations(businessObjectiveId, domain, channelId, externalName, state, secondaryState, tertiaryState, grouping)`
  - `patchBusinessObjective(busObjRecommendationInput)`
  - `patchRecommendations(busObjRecommendationInput)`
  - `updateRecommendations(busObjRecommendationInput)`
- Data Cloud `ConnectApi.CdpActivation`: `getActivations()`, `getActivationsPaginated(batchSize, offset, orderBy, filters)`, `createActivation(input)`, `deleteActivation(activationId)`, `getActivation(activationId)`, `updateActivation(activationId, input)`.
- Data Cloud `ConnectApi.CdpDataStreams`: `runDataStream(recordIdOrDeveloperName, interactive)`.
- Data Cloud `ConnectApi.CdpQuery`: `querySql(...)`(input / input,dataspace / input,workloadName,dataspace 오버로드), `querySqlRows(queryId, offset, rowLimit ...)` 다중 오버로드, `cancelQuerySql(queryId ...)`, `querySqlStatus(queryId ...)`(waitTimeMs·dataspace·workloadName 조합 오버로드).
- Data Cloud `ConnectApi.CdpAudienceDMO`: `getActivationData(activationId)`.
- Data Cloud `ConnectApi.CdpConnection`: `getDatabaseSchemas(connectionId, getDatabaseSchemasInput)`.
- Data Cloud `ConnectApi.CdpSegment`: `getSegmentById(segmentId)`, `getSegmentsFilteredPaginated(batchSize, offset, orderBy, filters)`(+ dataspace 오버로드).
- Data Cloud `ConnectApi.CdpMachineLearning`: `predict(predict)`.
- Data Cloud `ConnectApi.CdpActivationTarget`: `createActivationTarget(input)`, `updateActivationTarget(activationTargetId, input)`, `getActivationTarget(activationTargetId)`, `getActivationTargets()`, `getActivationTargetsPaginated(batchSize, offset, orderBy, filters)`.
- Data Cloud `ConnectApi.CdpDataSpace`: `getDataSpace(idOrName)`, `getAllDataSpaces(batchSize, offset, orderBy)`.
- Salesforce CMS `ConnectApi.ManagedContentSpaces`: `getManagedContentSpace(contentSpaceId)`(⚠️ `ConnectApi.ManagedContent`의 동명 메서드는 더 이상 사용 불가 — 이 신규 메서드로 대체), `getManagedContentSpaces(pageParam, pageSize, nameFragment)`, `patchManagedContentSpace(contentSpaceId, ManagedContentSpaceUpdateInput)`, `postManagedContentSpace(ManagedContentSpaceInput)`.

**Changed Connect in Apex Enums (모든 신규 값 전수)**

- `ConnectApi.DataConnectorTypeEnum` — 신규: `AzureBlob`, `DataCloud`, `GoogleCloudStorage`, `Sftp`.
- `ConnectApi.DataSpaceStatusEnum` — 신규: `Active`, `Error`, `Processing`.
- `ConnectApi.ExternalAuthIdentityProviderParamType` — 신규: `ManagedByComponent`, `ManagedByFeature`.
- `ConnectApi.ExternalCredentialParameterType` — 신규: `ManagedByComponent`, `ManagedByFeature`.
- `ConnectApi.NamedCredentialParameterType` — 신규: `ConnectionStatus`.

**Changed Connect in Apex Input/Output 클래스 (주요 신규 프로퍼티)**

- Input: `AbstractCartItem`(`subType`), `PromotionCartItemInput`(`subType`), `OCIGetInventoryAvailabilityInputRepresentation`(`includeRelatedProducts`), `NamedCredentialInput`(`descripton` — PDF 원문 오타).
- Output: `AbstractCartItem`(`isShippingChargeNotApplicable`/`promotionDisplayName`/`subType`), `CartItem`(`cartData`), `CartItemCollection`(`approachingDiscounts`), `CartItemProduct`(`productClass`/`productUrlName`), `CartSummary`(`hasGift`), `DistinctFacetValue`(`displayMetadata`), `ProductAttributeInfo`(`isGroupedBy`), `NamedCredential`(`description`), `ManagedContentDocument`/`ManagedContentVariant`(`contentFqn`), `ManagedContentSpace`(`spaceType`), `SearchResult`(`apiName`), `SearchResultGroups`(신규 `queryInfo`/`resultGroups`, `searchObject`는 더 이상 사용 불가→`resultGroups`), `ScopedSearchResults`(신규 `objectQueryInfo`/`results`, `searchObject`→`results`).

---

## Apex — 산문 변경

| 항목 | 내용 |
|---|---|
| **메타데이터 배포 중 조직 전체 Debug Log 활성화** | metadata deployment 중 debug log 생성(기본 비활성). admin이 active debug log trace flag와 함께 활성 가능. `DebuggingHeader`의 debug log가 이 설정을 override. Setup → Apex Settings → "Metadata Deployments can generate Debug Logs". Metadata API: `ApexSettings.enableDebugLogsDuringDeployment` 필드. |
| **Outbound Message 타임아웃 60초 → 20초** | Outbound Message의 타임아웃이 60초에서 20초로 단축. (거버너 한도성 변경 — 맨 아래 거버너 섹션 참조.) |
| **Outbound Message 큐 헤더명 변경** | "Oldest failures in queue" → "Oldest messages in queue"로 개명. |
| **Streaming API v64.0 disconnect 메시지** | Streaming API v64.0+ client는 disconnect 후 reconnect가 필요. Hyperforce에서 infra auto-scaling으로 더 자주 발생. `/meta/disconnect` 채널 listener 추가 후 reconnect. Enterprise/Performance/Unlimited/Developer. |
| **Shift_JIS → Windows-31J 매핑 제거** | 시스템 프로퍼티 `sun.nio.cs.map`(Shift_JIS→Windows-31J) 제거. 영향: Apex `EncodingUtil`, Visualforce CSV, External Services. IANA Shift_JIS 정의 변경 준수. 기본적으로 모든 customer 환경에서 제거. |
| **Salesforce Functions 퇴직** | 구매·갱신 불가. 기존 order term까지 사용 가능하며, order term 종료 전 대체 솔루션 배포 필요. Professional/Unlimited/Developer. |

---

## Apex — Deprecated / 폐기

- **Salesforce Platform API v21.0 ~ 30.0 은퇴 (Release Update)** — 원래 Summer '23 예정에서 **Summer '25로 연기**되어 강제 적용. 미지원이며 Summer '25부터 요청이 실패(endpoint deactivated 에러)한다.
  - **영향 버전:** Bulk API 21.0~30.0, SOAP API 21.0~30.0, REST API v21.0~v30.0.
  - **영향 REST API:** Bulk API, Connect REST API, IoT REST API, Lightning Platform REST API, Metadata API, Place Order REST API, Reports and Dashboards REST API, Tableau CRM REST API, Tooling API.
  - **When:** Professional(API access)/Enterprise/Performance/Unlimited/Developer. `API Total Usage` 이벤트로 구버전 요청을 식별. Release Updates에서 "Enable Test Run"/"Disable Test Run".
  - 강제 적용 상세: [[Summer '25/Release Updates]]
- **Chimera DAST 스캐너** (2025-06-16 이후 사용 불가) — AppExchange 보안 리뷰용 DAST 스캐너를 자유롭게 선택하여 제출 필요. (※ Development 섹션 외 보안 섹션 항목 — 허브에서 이관.)
- **`DeliveryMethodId` 필드 on `CartDeliveryGroup`** — API v64.0에서 deprecated, API v66.0에서 제거 예정. 대신 `CartDeliveryGroupMethod`의 `DeliveryMethodId` 사용.
- **Activity 360 Reporting 관련 Objects (Summer '26 은퇴 예정)** — `UnifiedEmail`, `UnifiedEmailParticipant`, `UnifiedMeeting`, `UnifiedMeetingParticipant`, `UnifiedTask`, `UnifiedTaskParticipant`.

---

## LWC — 개요 및 산문 변경

> LWC API version 64.0은 custom component용 versioned 변경이 **없다**. import에 대한 stricter access check가 도입되어 에러가 발생할 수 있다. 문서에서 "base Lightning components"가 "Lightning base components"로 명칭 변경되었고, 더 많은 base component가 native shadow DOM을 지원하도록 적응되었으며, TypeScript를 지원한다.

| 항목 | 내용 |
|---|---|
| **LWC API Version 64.0** | version-specific 변경 없음. `.js-meta.xml`의 `<apiVersion>64.0</apiVersion>`로 변경. v59.0+는 그 값을 LWC framework version으로 사용; v58.0 이하는 Summer '23(API 58.0) 동작 유지. |
| **참조된 Lightning 컴포넌트 접근 에러 해결** | Aura/LWC가 다른 컴포넌트/모듈을 import·reference 시 strict access check 적용. `No {COMPONENT or MODULE} named {name} found` 에러. Salesforce 소유 컴포넌트는 직접 접근 불가 → 참조 제거. 비-SF 관리패키지면 패키지 소유자에 문의. ISV는 관리패키지 컴포넌트가 subscriber에 노출되는지 확인. |
| **Lightning Base Components 문서 명칭 통일** | "base Lightning components" → "Lightning base components"(약어 LBC). header는 title case, 본문은 sentence case. |
| **내부 DOM 구조 변경** | native shadow DOM 준비. 테스트가 이전 내부 구조에 의존하면 안 됨. **Summer '25 신규 적응:** `lightning-tree-grid`, `lightning-user-consent-cookie`, `lightning-quick-action-panel`. Aura 영향은 `lightning:treeGrid` 하나뿐. UTAM/UTAM Page Objects 권장. |
| **Local Development Server 은퇴** | **2025-09-05 은퇴 예정.** 새 Local Dev 경험으로 마이그레이션. Local Dev는 Code Builder 미지원. |
| **ESLint v9 마이그레이션 (Spring '26 전)** | Winter '26에 ESLint v8 지원 종료 → Spring '26 전 v9 업그레이드 권장. Spring '26부터 신규 rule·bugfix는 v9만. 설치: `npm install eslint@^9.0.0 @lwc/eslint-plugin-lwc@^3.0.0 @salesforce/eslint-config-lwc@^4.0.0 @salesforce/eslint-plugin-lightning@^2.0.0 --save-dev`. flat format(`eslint.config.js`) 필수. |
| **TypeScript with Lightning Base Components (Developer Preview)** | base component type 정의를 import. `@salesforce/lightning-types` npm 패키지. (developer preview — 여러 제한 있음.) |
| **Lightning Web Security API Distortion 변경** | LWS 신규 distortion + 매칭 ESLint rule. 신규 distortion: `Document.parseHTMLUnsafe` static method. |
| **SLDS Linter (Beta)** | SLDS 2(베타) 규칙으로 코드를 검증하고 CLI 한 번에 일괄 자동 수정. SLDS Validator(VS Code 확장)보다 설정이 쉽고 CLI 기반으로 레포 전체 대량 수정 지원. 기존 코드를 SLDS 2로 업리프트하도록 설계됨. (How: SLDS Linter github repository) |

TypeScript 예시(PDF 원문 발췌):

```javascript
// PDF 원문 발췌 — salesforce_release_notes_5-17-2026 (3).pdf
import { LightningElement } from 'lwc';
import '@salesforce/lightning-types';
import type LightningButton from 'lightning/button';
export default class ComponentExample extends LightningElement {
submitLabel: string = 'Submit';
}
```

---

## LWC — 신규 (컴포넌트·모듈·타겟)

### New Targets — Agentforce

- `lightning__AgentforceInput` — LWC를 agent action에 사용 가능하게 한다. **사용자 입력 데이터를 받는** 컴포넌트 구성용.
- `lightning__AgentforceOutput` — LWC를 agent action에 사용 가능하게 한다. **agent action 출력 데이터를 표시하는** 컴포넌트 구성용.

```xml
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<targets>
    <target>lightning__AgentforceInput</target>
    <target>lightning__AgentforceOutput</target>
</targets>
```

관련: [[Summer '25/Agentforce]]

### Changed Modules

- `lightning/mediaUtils` — **이 모듈이 이제 GA(Generally Available)**가 되었다.
- `lightning/platformResourceLoader` — static import(`import` declaration) 필수. **동적 `import()`가 차단**된다. 동적 import 시도 시 에러: `Module import blocked: lightning/platformResourceLoader could not be imported.`

### Changed Lightning Web Components (전수)

| 컴포넌트 | 변경 |
|---|---|
| `lightning-avatar` | `src` — `data` prefix를 포함하는 Data URL은 sanitize되어 `javascript:void(0)`로 대체. |
| `lightning-carousel-image` | `src` — 동일(data URL → `javascript:void(0)`). |
| `lightning-accordion` | `allow-multiple-sections-open` — section이 1개뿐이고 이 attribute 미지정/false면 이제 닫힘 가능(이전엔 단일 section이 항상 열림 유지). |
| `lightning-datatable` | 신규 메서드 `focus()`(active cell에 focus), `scrollToTop()`(첫 행으로 스크롤). 신규 column property `imgSrc`(커스텀 아이콘 URI, header label 앞 표시; `hideLabel` 시 아이콘만; URI 로딩 에러 시 `iconName` 아이콘으로 fallback). |
| `lightning-input` | invalid 상태 input type에 error icon 표시: text, number, tel, email, url, password, range. date·time·datetime·datetime-local은 desktop 제외 표시. `type="date"`/datetime의 date 필드는 메시지가 date format 대신 sample date 표시 (en_US `date-style="medium"`→"Format: Dec 31, 2024", `short`→"12/31/2024", `long`→"December 31, 2024"). focus 제거 시 메시지 숨김. valueMissing 메시지에 sample date 포함, custom error는 괄호로 sample date append. |
| `lightning-input-address` | 신규 attribute `hide-province`(province 필드 숨김), `country-lookup-filter`(`show-address-lookup` 사용 시 필터링할 ISO 3166-1 Alpha-2 country code 목록; 대소문자 무시; 최대 5개). |
| `lightning-menu-item` | 신규 attribute `icon-type` — menu item 아이콘 배경색 결정. `standard`(기본, grayscale) / `color`(action·object 아이콘은 SLDS 정의 색 배경에 white glyph). utility·doctype 아이콘엔 미적용. |
| `lightning-tree-grid` | 커스텀 데이터타입 지원(컴포넌트 클래스 확장, static/dynamic custom data type 정의). 신규 attribute `column-widths-mode`(`fixed` 균등=기본 / `auto` content+table width 기반). 신규 column property `sortable`(기본 false). 신규 custom event `sort`(컬럼 정렬 시 발생). |

### Changed Aura Components (전수)

| 컴포넌트 | 변경 |
|---|---|
| `lightning:avatar` | `src` — data URL → `javascript:void(0)` sanitize. |
| `lightning:carouselImage` | `src` — 동일. |
| `lightning:datatable` | 신규 메서드 `focus()`, `scrollToTop()`. 신규 column property `imgSrc`(LWC와 동일). |
| `lightning:input` | error icon(LWC와 동일 type 목록). `dateStyle` 속성(`medium`/`short`/`long`). valueMissing/custom error 메시지 sample date 처리(LWC와 동일). |
| `lightning:inputAddress` | 신규 attribute `hideProvince`, `countryLookupFilter`(LWC camelCase 대응). |
| `lightning:treeGrid` | 신규 attribute `columnWidthsMode`(fixed/auto, 기본 fixed). 신규 column property `sortable`(기본 false). 신규 custom event `sort`. |

---

## LWC — 변경 / Deprecated

- **Local Development Server 은퇴** — 2025-09-05 은퇴 예정(위 표 참조). 새 Local Dev로 마이그레이션.
- **`lightning/platformResourceLoader` 동적 import 차단** — v64.0부터 static import만 허용, 동적 `import()` 차단(위 Changed Modules 참조).
- **내부 DOM 구조 변경 주의** — native shadow DOM 적응 컴포넌트(`lightning-tree-grid`·`lightning-user-consent-cookie`·`lightning-quick-action-panel`, Aura `lightning:treeGrid`)에 의존한 테스트는 깨질 수 있음.

---

## API (v64.0)

| 항목 | 내용 |
|---|---|
| **API 버전** | v64.0 |
| **API v21.0–30.0 폐기 (Release Update)** | Summer '25부터 강제 차단(SOAP/REST/Bulk). 상세는 위 Apex Deprecated 및 [[Summer '25/Release Updates]]. |
| **Instanced URL 업데이트 (Release Update)** | API traffic이 org의 My Domain login URL을 사용하도록. Summer '25부터 available, sandbox는 Winter '26·그 외 org는 Spring '26 enforce. ("Use Your Org's My Domain Login URL in API Calls"를 대체.) 상세: [[Summer '25/Release Updates]]. |
| **Composite API EventLogFile** | `EventLogFile`에서 `CompositeApi`, `CompositeApiSubrequest` event type 쿼리 — composite API·composite graph API 요청·subrequest 상세. **API v64.0+.** |
| **sObjects REST API OpenAPI (Beta)** | `/async/specifications/oas3` 리소스로 모든 유효 리소스 목록 반환. URI에 와일드카드 `*` 사용(단일 path segment 또는 끝의 나머지 path 매칭). API v64.0+. |
| **Metadata API — 의존성 포함 retrieve** | 신규 `rootTypesWithDependencies` 파라미터(`RetrieveRequest` 객체) — metadata type + dependencies 요청. AI 생성 metadata의 의존성 탐색 문제 해결. Professional/Performance/Unlimited. |
| **Sandbox 동기 컴파일 배너** | sandbox Deployment Status 페이지에 "Perform Synchronous Compile on Deploy"(Apex) 활성 시 배너 표시. |
| **Streaming API v64.0** | `/meta/disconnect` 채널 구독으로 disconnect 메시지 수신 후 재연결(위 Apex 변경 참조). |
| **Pub/Sub API 전 Hyperforce 리전** | Pub/Sub API global endpoint가 Hyperforce 지원 모든 region에서 처리. 2025년 4월부터. |
| **Change Data Capture** | `PaymentPage`(Commerce) 등 추가 객체에서 변경 이벤트 알림 수신. |
| **신규 Standard Platform Events** | Data Cloud `DataObjectDataChgEvent`(신규 필드 `ProfileIdValue`/`TraceIdValue`/`TriggerEntity`); Industries `InsPolicyRnwlStatusEvent`·`InsPolicyRnwlQuoteStatusEvent`; Security `LoginAnomalyEvent`(데이터는 `LoginAnomalyEventStore`에 저장). |

> **Metadata API 신규 type(Development 도메인):** `LightningTypeBundle`(Agent Action Input/Output UI 커스터마이즈), `ExternalServiceRegistration.registrationProviderType`의 신규 값 `Heroku`(GA — External Services with Heroku apps), `DataConnector`(v64.0, Iceberg·Snowflake 등 connector 커스터마이즈·관리패키지 배포), `GenAiPlannerBundle`(GenAiPlanner 대체).

> ⚠️ **Tooling API · User Interface API:** 이 Development 섹션(p440–536)에는 개요 스텁만 존재하고 상세 객체 표가 없다. Tooling API는 "Access more metadata through these new and changed Tooling API objects", UI API는 "Batch requests support default assignment rules, and User Interface API supports more objects"로만 서술됨. 상세 객체 목록은 이 추출 범위 밖이므로 본 노트에 추측 작성하지 않는다.

---

## 거버너 한도 변경

> 전통적 거버너 한도(heap size·CPU time·SOQL query·DML rows·callout)의 증가는 Summer '25 Development 섹션에 **없다.** 아래는 레이트 리밋 마이그레이션과 타임아웃 단축이다.

| 항목 | 내용 |
|---|---|
| **ConnectApi (Connect in Apex) 레이트 리밋** | per user, per namespace, per hour → **per org, per 24-hour Salesforce Platform API rate limit**으로 마이그레이션. Summer '24 이후 생성 org는 이미 적용. migrated/new org에서는 **Chatter가 필요한 method 호출만** per user, per namespace, per hour 제한이 유지된다. (all editions, all API versions, rolling migration.) |
| **Connect REST API 레이트 리밋** | per user, per application, per hour → **per org, per 24-hour Salesforce Platform API rate limit**으로 마이그레이션. Summer '24 이후 생성 org는 이미 적용. migrated/new org에서는 **Chatter가 필요한 요청만** per user, per application, per hour 제한이 유지된다. |
| **Outbound Message 타임아웃** | **60초 → 20초**로 단축. |

> PDF 원문(ConnectApi): *"For migrated and new orgs, only method calls that require Chatter are subject to the per user, per namespace, per hour rate limit."*

---

## 관련 노트
- [[Summer '25]]
- [[Summer '25/Release Updates]]
- [[Summer '25/Platform]]
- [[Summer '25/Agentforce]]
- [[FormulaEval Namespace]]
- [[EventBus Namespace]]
