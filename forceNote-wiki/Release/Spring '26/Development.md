---
tags: [release, spring_26, development, apex, lwc, api]
api_version: v66.0
release_date: 2026-02
created: 2026-06-15
source: salesforce_spring26_release_notes.pdf (Salesforce Spring '26 Release Notes, Tier 2)
aliases: [Spring '26 Development, 스프링26 개발, Apex Cursors GA, PaginationCursor, RunRelevantTests Beta, getPicklistValuesByRecordType, purgeOldAsyncJobs, GraphQL mutation field reference, Named Query API, v66 거버너 한도, Spring 26 개발자 변경]
---

# Spring '26 — Development (Apex · LWC · API · Visualforce · Packaging · Dev Environments)

> v66.0 개발자 항목 전수. Apex Cursors GA·RunRelevantTests(Beta)·purgeOldAsyncJobs 오버로드, LWC 복합 템플릿·전 TS 타입 완성, GraphQL mutation GA·Named Query API GA, New&Changed 네임스페이스, 거버너 한도(1억 cursor row / 12MB / 1MB)까지.

---

## 개요

이 노트는 [[Spring '26]] 릴리즈의 **개발자(Apex · LWC · API · Visualforce · Packaging · Dev Environments)** 영역을 전수로 다룬다. 추출 범위는 공식 Release Notes PDF의 Development 섹션 전체다.

- 강제 적용 시점(Blob.toPdf·no-arg 생성자·SOAP login 등)은 → [[Spring '26/Release Updates]] (단일 권위 출처)
- 보안·Admin 맥락(Named Credentials Apex·Sharing Recalculation)은 → [[Spring '26/Platform]]
- AI/Agent 통합(Apex/AuraEnabled → Agent Action)은 → [[Spring '26/Agentforce]]

> 모든 코드 블록은 PDF 원문 그대로(verbatim)이며 `// PDF 원문 발췌` 마커를 붙였다. 시연용(non-verbatim) 코드는 작성하지 않았다. `System.maxQueueableDepth` 같은 발명 API는 포함하지 않는다.

---

## Apex

### 신규

- **Apex Cursors / Pagination Cursors (GA)** — 대용량 SOQL 결과 집합을 분할 처리. API v66.0+, LEX·Classic, Enterprise/Performance/Unlimited/Developer.
  - 표준 커서는 Batch Apex의 효율적 대안. Batch는 동일 size를 전체 결과셋에 적용해 트랜잭션이 늘지만, cursor + Queueable 체인은 트랜잭션당 처리 레코드 수에 유연성을 준다.
  - `Cursor.fetch()` 호출은 SOQL query limit에 카운트되고, fetch된 row는 SOQL query row limit에 카운트된다.
  - GA 시 추가된 enhancement: `PaginationCursor` 클래스로 UI 페이지네이션 구현(`fetchPage()`, `fetchDeleted()` 호출은 SOQL query limit에, fetch된 row는 SOQL query row limit에 카운트). 커서 작업 추적용 디버그 로그 이벤트.
  - **거버너 한도:** 24시간당 새 cursor row의 최대 누적 수는 **1억(100 million)**.
  - 새 거버너 추적 메서드: `Limits.getApexCursors()` / `getLimitApexCursors()`, `Limits.getApexPaginationCursors()` / `getLimitApexPaginationCursors()`, `Limits.getApexPaginationCursorRows()` / `getLimitApexPaginationCursorRows()`.
  - AuraEnabled 직렬화/역직렬화에서 cursor·pagination cursor 지원. `@AuraEnabled` response에서 cursor 직렬화, `@AuraEnabled` 메서드 input parameter로 cursor 역직렬화 가능.
- **Record Type별 Picklist 값 추출** — `ConnectApi.RecordUi.getPicklistValuesByRecordType(objectApiName, recordTypeId)`. 종속 picklist 트리(예: `Continents__c` → `Countries__c` → `Cities__c`)의 모든 값을 한 요청에 `ConnectApi.PicklistValuesCollection`으로 획득. IdeaExchange 반영. LEX·Classic, Enterprise/Performance/Unlimited/Developer.
- **Expose Apex REST and AuraEnabled Controller Methods as Agent Actions (GA)** — 메서드에 어노테이션 → OpenAPI spec 생성 → org 배포 → API Catalog에서 API로 관리. LEX, Enterprise/Performance/Unlimited/Developer. (상세는 [[Spring '26/Clouds]] MuleSoft API Catalog, [[Spring '26/Agentforce]] 참조)
- **`Blob.toPdf()` — Visualforce PDF 렌더링 서비스 사용 (Release Update)** — `Blob.toPdf()`가 Visualforce와 동일한 PDF 렌더링 엔진을 사용. 시그니처(string 인자 → `Blob` 반환)는 불변. 확장된 폰트·멀티바이트 문자 지원. **기본 폰트가 `sans-serif` → `serif`로 변경**되어 명시적 font styling이 없으면 line length·line/page break이 달라질 수 있음. 강제 시점은 → [[Spring '26/Release Updates]].
- **Test Discovery API `category` 쿼리 파라미터** — Tooling API의 Test Discovery 엔드포인트에 GET, `category=flow` 또는 `category=apex`로 필터. 여러 category 동시 지정 불가, 다른 파라미터와 결합 가능. API v66.0+.

```text
// PDF 원문 발췌 — salesforce_spring26_release_notes.pdf
https://MyDomain.my.salesforce.com/services/data/v66.0/tooling/tests?category=apex
https://MyDomain.my.salesforce.com/services/data/v66.0/tooling/tests?category=flow&namespacePrefix=ourManagedPackage
```

- **`purgeOldAsyncJobs()` 오버로드** — 지정 날짜 이전 완료된 가장 오래된 async job부터 삭제할 개수를 지정. API v66.0+.

```apex
// PDF 원문 발췌 — salesforce_spring26_release_notes.pdf
Integer maximumNumberOfJobsToDelete = 1000;
Integer count = System.purgeOldAsyncJobs(
Date.today(),
maximumNumberOfJobsToDelete
);
System.debug('Deleted ' + count + ' old jobs.');
```

> See Also (시그니처 원문): `purgeOldAsyncJobs(dt, numOfJobs)`.

- **DataWeave에서 중첩 SOQL 쿼리 지원** — 변환(Transformation)에 parent-child relationship subquery/nested SOQL 사용 가능(이전엔 `DataWeaveScriptException` 발생). IdeaExchange 반영. API v66.0+.

### 변경

- **`RunRelevantTests` 테스트 레벨 (Beta)** — 배포 페이로드·의존성 분석으로 관련 테스트만 실행. `RunRelevantTests` 테스트 레벨 자체는 **모든 API 버전**에서 사용 가능하나, 아래 어노테이션은 **API v66.0+**에서만 동작.
  - `@IsTest(critical=true)` — 페이로드의 클래스/트리거와 무관하게 **항상 실행**.
  - `@IsTest(testFor='ApexClass:ClassName, ApexTrigger:TriggerName')` — 지정 클래스/트리거가 새로 추가/변경될 때 실행.
  - 지정 방법: file-based call은 `DeployOptions.testLevel = 'RunRelevantTests'`; REST는 `deployRequest` 본문의 `deployOptions.testLevel`; CLI는 `sf project deploy start --test-level RunRelevantTests`.
  - 기존 `RunLocalTests`(작은 변경에도 전 테스트 실행) / `RunSpecifiedTests`(수동 지정)의 한계를 해결, 배포 크기에 비례해 확장.
  - **Beta 약관:** `RunRelevantTests` 및 관련 `@IsTest()` 어노테이션은 pilot/beta 서비스(Beta Services Terms 적용). LEX·Classic, Enterprise/Performance/Unlimited/Developer.
  - 참고: `RunRelevantTests`·`@IsTest(critical=true)`·`@IsTest(testFor=...)`는 전용 위키 노트가 아직 없다(릴리즈 노트 내 항목).
- **`WITH USER_MODE` SOQL을 Automated Process User로 실행** — API v66.0+에서 Automated Process User가 `WITH USER_MODE` SOQL을 실행할 수 있다. v65.0 이하에서는 system mode로 명시 실행하지 않으면 실패한다. (→ [[WITH USER_MODE]])
- **Sharing 재계산 동작 변경 대비** — sharing recalculation 동작이 변경되어 share 레코드 즉시 업데이트에 의존하는 Apex가 깨질 수 있다. "Update Apex Code and Flows for Changed Sharing Recalculation Behavior" Release Update로 영향 코드를 식별·수정한다. 강제 시점(Spring '27)은 → [[Spring '26/Release Updates]].

### Deprecated / Release Update

- **Invocable Action 파라미터용 Apex 클래스의 no-argument 생성자 필수화 (API v66.0+)** — invocable action 파라미터로 쓰이는 Apex 클래스는 visible no-argument 생성자가 필수다(비패키지=`public`, 패키지 외부 호출=`global`). v65.0 이하 + Release Update 비활성 시 기존 동작 유지.
  - ⚠️ 관련 Release Update("Enforcing No-Argument Constructor on Apex Classes Used for Invocable Action Parameters")의 **강제는 취소됨**(Summer '26 예정 → Spring '26부터 더 이상 강제 안 함). 단, API v66.0+ **versioned change**로 동일 요건이 적용된다 — 두 메커니즘 구분에 주의. 상세는 → [[Spring '26/Release Updates]].

---

## LWC

### LWC API Version 66.0

`.js-meta.xml`에서 API 버전을 변경한다. 한 번에 한 버전씩 업그레이드를 권장한다. LWC API version 59.0+는 그 값을 LWC framework version으로 사용하고, 58.0 이하는 Summer '23(API 58.0) 동작을 유지한다.

```xml
<!-- PDF 원문 발췌 — salesforce_spring26_release_notes.pdf -->
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
<apiVersion>66.0</apiVersion>
</LightningComponentBundle>
```

### 신규

- **복합 템플릿 표현식 (Beta)** — LWC 템플릿의 가상 DOM 시스템을 JavaScript expression의 포괄적 subset으로 확장. basic property를 쓰던 어디서나 사용 가능. component의 `apiVersion`을 **66.0 이상**으로 설정해야 활성화. pilot/beta 서비스.
- **빈 상태/일러스트 베이스 컴포넌트 (Beta)** — 새 `lightning-empty-state`(SVG가 사용자 테마에 자동 조정, SLDS 2 dark mode 적응)와 `lightning-illustration`(text 없이 illustration만). title/illustration/CTA 없이도 가능 — **description만 필수**. illustration name·title은 attribute, description·cta는 slot으로 전달. pilot/beta 서비스.

```html
<!-- PDF 원문 발췌 — salesforce_spring26_release_notes.pdf -->
<!-- myEmptyState.html -->
<!-- With illustration and action -->
<lightning-empty-state
illustration-name="cart:noitems"
title="It's looking a little empty in here">
<p slot="description">Head to the product catalog to add something to your cart.</p>
<lightning-button
variant="brand"
label="Browse Products"
slot="cta"
onclick={handleCtaClick}>
</lightning-button>
</lightning-empty-state>
```

```javascript
// PDF 원문 발췌 — salesforce_spring26_release_notes.pdf
import { LightningElement } from "lwc";
export default class MyEmptyState extends LightningElement {
handleCtaClick(event) {
// go to the Products tab
}
}
```

```html
<!-- PDF 원문 발췌 — salesforce_spring26_release_notes.pdf -->
<!-- myIllustration.html -->
<lightning-illustration
illustration-name="cart:noitems"
alternative-text="Shopping cart is empty">
</lightning-illustration>
```

> ⚠️ 시각 자료: PDF에는 SLDS 2 테마(empty cart 그림)와 SLDS 1 테마("gone fishing" 그림) 스크린샷이 있으나 pdftotext가 잡지 못한다. 본 노트에는 텍스트 설명만 포함 — 다이어그램은 재현하지 않았다.

- **전 Lightning Base Component TypeScript 타입 완성** — 모든 base component의 TypeScript rollout 완료. `@salesforce/lightning-types` npm 패키지에서 타입 정의를 import. (→ [[Lightning Base Components 레퍼런스]])
- **Error Console** — 비치명적(non-fatal) 페이지 에러를 방해 없이 캡처·표시. 치명적 에러는 modal로 표시되며 Error Console에도 수집. Setup > User Interface > Advanced Settings > "Use Error Console for error reporting in Lightning Experience"로 활성화.
- **단일 LWC 브라우저 미리보기 (GA)** — Single Component Live Preview(이전 "Local Dev for single components")가 GA. Salesforce CLI가 Live Preview 플러그인을 자동 설치한다. all editions.
- **LWC 개발용 MCP 도구 확대 (Beta)** — `lwc-experts` toolset에 도구 다수 추가(`create_lds_graphql_mutation_query`, `explore_lbc_components`, `fetch_lds_graphql_schema`, `guide_lo_migration`, `test_lds_graphql_query` 등) + 새 `experts-validation` toolset(`validate_and_optimize`, `score_issues` — 0~100 readiness score). `explore_slds_styling`·`explore_slds_blueprints`·`guide_utam_generation` 등 일부는 NON-GA로 `--allow-non-ga-tools` 필요. `guide_lwc_security` → `guide_lws_security`, `guide_lwc_accessibility` → `guide_component_accessibility`로 rename, `explore_lds_graphql_schema`·`guide_lwc_slds2_uplift_linter_fixes` 제거. pilot/beta 서비스.
- **Setup with Agentforce용 커스텀 컴포넌트 업데이트 (Beta)** — custom Aura/LWC를 Setup의 Agentforce에 노출하려면 `js-meta.xml`·`.design`에 AI 관련 component/property description 추가. (early January 2026). 상세는 → [[Spring '26/Platform]].

### 변경

- **Lightning Out 2.0 개선** — App Manager에서 외부 앱 도메인명 추가(Setup Session Settings Trusted Domains에도 추가), 복합 namespace(mixed casing) LWC 추가 가능. namespace/component 구분자는 forward slash(`/`) 또는 hyphen(`-`); hyphen 사용 시 복합 namespace segment는 underscore(`_`)로 구분(예: `complexNs/lwcComponent` ≡ `complex_ns-lwc-component`). app component가 `app-id` attribute 지원. Professional/Enterprise/Performance/Unlimited/Developer.

```html
<!-- PDF 원문 발췌 — salesforce_spring26_release_notes.pdf -->
<!-- Generated Lightning Out 2.0 App Code Block -->
<script
type="text/javascript"
async=""
src="https://MyDomainName.my.salesforce.com/lightning/lightning.out.latest/index.iife.prod.js">
</script>
<lightning-out-application
app-id="18-DigitSalesforceID"
components="complex_ns-lwc-component">
</lightning-out-application>
<complex_ns-lwc-component></complex_ns-lwc-componenent>
```

> 🔎 **원문 오타 보존:** 마지막 줄 닫는 태그 `</complex_ns-lwc-componenent>`의 `componenent`는 PDF 원문 그대로의 오타(sic)다. 정정하지 않고 보존한다.

- **Screen Flow가 LWC local action 지원** — 화면 플로우에서 LWC 로컬 액션 사용. (→ [[Spring '26/Platform]] Automation)
- **API Distortion 변경 (Lightning Web Security)** — LWS에 web API distortion + 매칭 ESLint rule 추가. 새 distortion 대상: `Promise.try`, `WebAssembly.Instance.prototype.exports` getter, `WebAssembly.instantiate`, `WebAssembly.instantiateStreaming`.
- **Disconnected DOM Node Rehydration Fix** — LWC가 DOM에 active connect 됐을 때만 rehydrate(detached node skip). `renderedCallback` 등 lifecycle method 다중 호출 방지. 이전 동작에 의존하는 로직 검토 필요.
- **Local Dev → Live Preview 명칭 변경** — "Local Dev"가 "Live Preview"로 변경(CLI 명령어 불변).

| 이전 명칭 | 새 명칭 | 의미 |
|---|---|---|
| Local Dev for Lightning apps | Lightning App Live Preview | Lightning app을 브라우저에서 live preview |
| Local Dev for Experience sites | Experience Sites Live Preview | Experience site를 브라우저에서 live preview |
| Local Dev for single components | Single Component Live Preview | 단일 component를 브라우저에서 live preview |
| Lightning Preview (beta) | Live Preview VS Code Extension | 단일 LWC 또는 React component를 IDE 내 live preview. LWC preview는 GA, React preview는 beta |

### Deprecated

- **LWS Trusted Mode 활성화 중단(Discontinued)** — Spring '26부터 LWS Trusted Mode를 더 이상 enable하지 않음. LEX의 LWC 및 Aura 기반 Experience Cloud sites의 LWC에 적용(LWR sites·Aura components에는 미적용).
- **Lightning Component Library 은퇴** — 레거시 라이브러리가 새 Lightning Component Reference(`https://developer.salesforce.com/docs/component-library/overview/components`)로 redirect(January 2026). in-org site(`https://<myDomainName>.lightning.force.com/docs/component-library`)는 유지.
- **UTAM 문서가 Salesforce Developers 사이트로 이동** — utam.dev → `https://developer.salesforce.com/docs/platform/utam`(March 2026 redirect). Tutorials·Generator Playground는 utam.dev에 유지.

---

## API

### 신규

- **Named Query API로 REST에서 커스텀 SOQL 노출 (GA)** — custom SOQL을 REST API client용 scalable action으로 정의·노출. **Note:** Named Query API를 agent action으로 쓰는 것은 beta(추가 비용). (→ [[Spring '26/Clouds]] MuleSoft)
- **Speech/Text REST 액션 추가** — POST `/services/data/v66.0/actions/standard/voiceToText`(Convert Base64 Speech To Text), `/services/data/v66.0/actions/standard/textToSpeech`(**Beta**, optional `fileOutput` 파라미터), `/services/data/v66.0/actions/standard/speechToText`. Flow Extensions와 동일 기능 — Automation 맥락은 → [[Spring '26/Platform]].

### 변경 / 한도

- **Metadata 배포·검색 신규 한도** — 4개 metadata type(`AIAuthoringBundle`, `AnalyticsDashboard`, `AnalyticsWorkspace`, `AnalyticsVisualization`)에 single package zip당 component 수 + 24시간당 deploy/retrieve 횟수 한도 적용. all editions.
- **Data 360 SOQL 쿼리 결과 1회 12MB 제한** — size limit까지 결과를 반환하고 "query more" 링크로 페이지네이션. 단일 query 결과가 limit를 초과하면 SOQL이 query를 거부. Developer/Enterprise/Performance/Unlimited.
- **`ScheduledFlowRunLimit` / `ScheduledPathRunLimit`** — GET `/services/data/vXX.X/limits` resource에 새 값 추가. (Flow 한도이나 위치는 REST API Limits resource다.)

### Deprecated / Retired

- **`EventBusSubscriber`의 `Position`·`Tip` 필드 Deprecated** — 새 필드 `LastProcessed`/`LastPublished`로 교체. 타입이 int → string으로 변경(큰 replay ID 처리). Developer/Enterprise/Performance/Unlimited. (→ [[EventBus Namespace]])
- **Outbound Message의 Session ID 전송 제거** — 2026년 2월 23일부터 outbound message에서 session ID 전송 불가. `IncludeSessionId` flag는 무시되고 FALSE로 설정, `<sessionID></sessionID>` element는 session ID 미포함. OAuth 사용.
- **SOAP API `login()` (v31.0–64.0) 은퇴 (Release Update)** — Summer '27에 SOAP API v31.0~64.0의 `login()` 미지원. external client app으로 인증 전환. 강제 시점은 → [[Spring '26/Release Updates]].
- **Instanced URL 업데이트 (Release Update)** — API 트래픽이 잘못된 instanced URL 대신 My Domain login URL을 사용하도록 수정. **Spring '26 예정에서 Winter '27로 연기됨.** fix 배포 June 16–18, 2026, June 18 이후 테스트 권장. → [[Spring '26/Release Updates]].
- **Invocable Action 호출이 생성자 visibility 검증 (API v66.0+)** — API v66.0+에서 REST 호출이 invocable action parameter용 Apex 클래스의 visible no-argument 생성자를 검증. 미충족 시 호출 실패.

### New and Changed Objects (개발자 관련 발췌)

PDF는 클라우드별로 New/Changed Objects를 나열한다. 아래는 Development·Files·Event Monitoring·Salesforce Flow·Security 등 개발자 직접 관련 항목이다(클라우드 제품 객체 전수는 → [[Spring '26/Clouds]]).

- **Development:** 새 `PushUpgradeCustomization` 객체(managed package subscriber가 push upgrade 차단). `PackageSubscriber`에 새 필드 `CustomUpgradeType`, `HasRestrictionEnabled`, `IsCustomUpgradeAllowed`.
- **Files:** `ContentDocument`/`ContentVersion`에 새 `MalwareScanStatus`(beta), `MalwareScanDate`(beta) 필드. 2GB 초과 파일용 새 `ContentSizeLong` 필드(`AttachedContentDocument`, `AttachedContentNote`, `CombinedAttachment`, `ContentFolderItem`, `ContentNote`, `ContentVersion`, `FolderedContentDocument`, `OwnedContentDocument`).
- **Event Monitoring:** `EventLogFile` Aura Request Event type에 새 `easySuiteValue` 필드; Login Event Type에 새 `AUTHENTICATION_CONTEXT_CLASS_REFERENCE` 필드. **REMOVED:** `ApexLimitEvent` 객체 제거(API 46.0 deprecated → 66.0+ 제거).
- **Salesforce Flow:** `FlowRecord`에 새 `LogsEnabledFlowVersion` 필드, `Type` 필드 새 값 `IndivRelatedRecord`, `IndivRelatedRecTrigAutolnch`(🔎 원문 오타 보존 — `Autolnch`의 `l`/`I` 모호, PDF 텍스트 그대로). `FlowTestResult`의 `Result` 필드 새 값 `Skip`.
- **Security and Identity:** `BrowserPolicyViolation`에 새 `ViolationImpact` 필드. `RedirectWhitelistUrl` 접근에 Customize Application 권한 필요(read도). 새 `RetentionStoreUsage` 객체. `PartyConsent`에 `DoubleConsentCaptureDate`, `EffectiveFrom`, `EffectiveTo`. `LoginHistory` 새 값 `PasswordlessPasskeyLogin`(Beta), `VerificationHistory` 새 값 `PwlessPasskey`(Beta), `IdentityVerificationEvent` 새 값 `PasswordlessPasskeyLogin`(Beta).

### New and Changed Standard Platform Events

- **Commerce:** `WebCartAbandonedEvent`(cart abandon 알림).
- **Industries:** `CartToOrderCompletedEvent`(`/actions/standard/createOrderFromCart` REST 완료 알림).

### Connect REST API (개발자 발췌)

- **Rate Limit 변경:** per user/application/hour → per org/24-hour Salesforce Platform API rate limit으로 마이그레이션.
- **신규/변경 리소스(VERBATIM 경로 예):** Custom Domain GET `/connect/custom-domain/domains/domainId/pending-configuration`; Salesforce CMS GET `/connect/cms/contents/contentKeyOrId`(new param `contentVersion`), PATCH `/connect/cms/digital-asset-management-providers/providerInstanceId`; Salesforce Flow GET `/connect/interaction/flow-approval-process/status`. Commerce·Data 360·Personalization 등 클라우드 리소스 전수는 → [[Spring '26/Clouds]].

### Invocable Actions

- 새 `ConvertBase64SpeechToText`(Base64 audio → text), `TextToSpeech`(Beta, text → spoken audio, 기본 Base64 출력, optional file output), `SpeechToText`(audio file → text).
- `InvocableEnsureFundsOrderSummaryAsync`에 새 `isAllowPartial` 필드 + `SequenceOrderPaymentSummaryInputList` representation.
- 새 `exitIndividualsFromFlow`(segment/automation/on-demand flow에서 개인 제거).

### Metadata API (개발자 발췌)

- **Customization:** `ExternalServiceRegistration`에 새 `registrationProviderAsset` 필드(API 66.0+); `registrationProviderType` 새 subtype `AgentToAgent`, `ContextDef`, `CustomExternalConnector`. `LightningComponentBundle`에 새 `ai` 필드(API 66.0+). `NamedCredential`의 `ParameterType` 새 값 `ManagedByNamespace`, `NamedCredentialOptions`, `SfHttpRequestExtensionName`. `CatalogedApi`의 `CatalogedApiInstance` subtype에 새 `endpointType` 필드(API 66.0+).
- **Development:** 새 `UIBundle` metadata type(non-Salesforce framework 지원). `DevHubSettings`에 새 `enableALMDevopsCorePref` 필드(API 65.0+). **REMOVED:** `DevHubSettings`의 `enableDevOpsCenter` 필드 제거 → `enableDevOpsCenterGA` 사용.
- **Salesforce Flow:** `FlowActionCall`에 새 `actionCallPaths`, 새 `timoutPathUsage` 필드(API 66.0+ — 🔎 원문 오타 보존, `timout`은 PDF 그대로 sic). `FlowScreen`/`FlowScreenFieldStyleProperties`에 새 `styleSettings`. `FlowTest`에 `flowTestFlowVersions`, `testType`, `flowTestDatasources`, `isolatedObjectExternalKeys`; `FlowTestReferenceOrValue`에 `jsonValue`; `FlowTestParameter.type` 새 값 `InputVariable`. `FlowSchedule`에 `dayOfMonthToRun`, `daysOfWeekToRun`, `frequencyNumber`; `frequency` 새 값 `Monthly`, `Yearly`, `Hourly`, `Weekdays`. `FlowStart`에 `activationTemplate`, `prioritizedContactPointsList`, `sendMsgToOneContactPtPerIndv`, `fanOutAction`. `FlowScreenField`에 새 `attributes`.
- **Security and Identity:** `RedirectWhitelistUrl` 접근에 Customize Application 권한 필요. 새 `ExtlClntAppCanvasSettings` metadata type(API 66.0+). `ExtlClntAppConfigurablePolicies`에 새 `isCanvasPluginEnabled`. **DEPRECATED:** `ExternalClientAppSettings`의 `enableConsumerSecretApiAccess`.

### Tooling API

- GET `/services/data/v66.0/tooling/tests`에 새 `category` 쿼리 파라미터(값 `apex`, `flow`).
- 새 객체: `CustomNotifActionDef`(Beta, Mobile), `CustomNotificationActionGroup`(Beta, Mobile), `EngagementInsightType`(Sales, API 65.0+). `ExternalServiceRegistration`에 `registrationProviderAsset`(API 66.0+).

### User Interface API

- GET `/ui-api/object-info/{objectApiName}/picklist-values/{recordTypeId}`를 이제 Connect in Apex `ConnectApi.RecordUi` 클래스에서도 사용 가능.
- `Field` response body에 새 property `defaultValue`, `defaultedOnCreate`.
- UI API 신규 지원(기존 객체): `CustomPermission`, `Event`, `JournalReason`, `PermissionSetLicense`, `Task`. list view + MRU 신규 지원: `SharingRecordCollection`, `SharingRecordCollectionItem`.

---

## GraphQL — mutations & UI API (GA)

`lightning/graphql` 모듈에 새 `executeMutation` 메서드가 추가되어 JS에서 record를 생성·편집·삭제할 수 있다. `RecordUpdatePayload` type이 `Record` 필드를 포함하도록 변경(이전에는 `success` true/false 반환). 아래 코드는 PDF 원문 그대로다.

### 현재 사용자(User) 레코드 조회

```graphql
# PDF 원문 발췌 — salesforce_spring26_release_notes.pdf
{
uiapi {
currentUser{
Id
Name {
value
}
}
}
}
```

```json
// PDF 원문 발췌 — salesforce_spring26_release_notes.pdf
{
"data": {
"uiapi": {
"currentUser": {
"Id": "005xx000001X7sHAAS",
"Name": {
"value": "User‘s Name"
}
}
}
},
"errors": [],
"extensions": {}
}
```

### 오브젝트 페이지 레이아웃 메타데이터 조회

`recordLayouts` 필드가 `LayoutConnection` type을 반환한다.

```graphql
# PDF 원문 발췌 — salesforce_spring26_release_notes.pdf
type UIAPI {
recordLayouts(
objectApiName: String!
recordTypeIds: [Id!]
layoutConfigs: [LayoutConfig!]
layoutType: LayoutType
formFactor: FormFactor
mode: LayoutMode
first: Int
after: String
): LayoutConnection
}
input LayoutConfig {recordTypeId: ID!, formFactor: FormFactor, mode: LayoutMode
}
```

```graphql
# PDF 원문 발췌 — salesforce_spring26_release_notes.pdf
{
uiapi {
recordLayouts(objectApiName: "Account") {
edges {
node {
id
layoutType
mode
objectApiName
recordTypeId
sections {
heading
columns
rows
collapsible
layoutRows {
layoutItems {
label
required
editableForNew
editableForUpdate
uiBehavior
layoutComponents {
apiName
componentType
}
}
}
}
}
}
pageInfo {
hasNextPage
endCursor
}
totalCount
}
}
}
```

```json
// PDF 원문 발췌 — salesforce_spring26_release_notes.pdf
{
"data": {
"uiapi": {
"recordLayouts": {
"edges": [
{
"node": {
"id": "00hLT000001awTWYAY",
"layoutType": "FULL",
"mode": "VIEW",
"objectApiName": "Account",
"recordTypeId": "012LT000000aFiEYAU",
"sections": [
{
"heading": "Account Information",
"columns": 2,
"rows": 18,
"collapsible": false,
"layoutRows": [
{
"layoutItems": [
{
"label": "Account Owner",
"required": false,
"editableForNew": false,
"editableForUpdate": false,
"uiBehavior": "EDIT",
"layoutComponents": [
{
"apiName": "OwnerId",
"componentType": "FIELD"
}
]
}
]
}
]
}
]
}
}
],
"pageInfo": {
"hasNextPage": false,
"endCursor": "djE6NQ=="
},
"totalCount": 6
}
}
},
"errors": [],
"extensions": {}
}
```

### Mutation으로 레코드 생성·수정·삭제 (Generally Available)

```graphql
# PDF 원문 발췌 — salesforce_spring26_release_notes.pdf
mutation ContactUpdateExample{
uiapi {
ContactUpdate(input: {
Contact: {
FirstName: "Sam"
LastName: "Smith"
}
Id: "003RM000008AAAAAA4"
}) {
Record {
Id
FirstName {
value
}
LastName {
value
}
}
}
}
}
```

```json
// PDF 원문 발췌 — salesforce_spring26_release_notes.pdf
{
"data": {
"uiapi": {
"ContactUpdate": {
"Record": {
"Id": "003RM000008AAAAAA4",
"FirstName": {
"value": "Sam"
},
"LastName": {
"value": "Smith"
}
}
}
}
},
"errors": []
}
```

### 쿼리 시 LastViewedDate 갱신 (updateMRU)

`updateMRU` argument를 `true`로 설정하면 반환 record의 `LastViewedDate`가 업데이트된다.

```graphql
# PDF 원문 발췌 — salesforce_spring26_release_notes.pdf
query accounts {
uiapi {
query {
Account (updateMRU:true){
edges {
node {
Id
Name {
value
}
}
}
}
}
}
```

```json
// PDF 원문 발췌 — salesforce_spring26_release_notes.pdf
{
"data": {
"uiapi": {
"query": {
"Account": {
"edges": [
{
"node": {
"Id": "0015f000007wCAWAA2",
"Name": {
"value": "Enfield Tennis Academy"
}
}
},
{
"node": {
"Id": "0015f000007vRRVAA2",
"Name": {
"value": "Ennet House"
}
}
}
]
}
}
}
}
}
```

> 문서 개선: GraphQL API developer guide Reference 섹션이 최신 API 버전만 표시, OpenAPI Specification(OAS) 표준 준수·다운로드 지원, three-panel layout으로 개선됐다.

---

## New & Changed 개발자 항목 (네임스페이스별)

PDF는 namespace별로 "New Classes / Changed Enums / New or Changed Methods in Existing Classes" 구조다. 아래는 전수 전사다.

### System Namespace

- pagination cursor 생성: `Database.getPaginationCursor()`, `Database.getPaginationCursorWithBinds()`.
- `Limits.getApexCursors()` / `getLimitApexCursors()`, `Limits.getApexPaginationCursors()` / `getLimitApexPaginationCursors()`, `Limits.getApexPaginationCursorRows()` / `getLimitApexPaginationCursorRows()`.
- async job 삭제 개수 지정: `System.purgeOldAsyncJobs()` 새 오버로드.
- 개선된 PDF rendering: `Blob.toPdf()`가 Visualforce와 동일 서비스 사용.

### Database Namespace

- 새 `PaginationCursor` 클래스: `fetchPage()`, `fetchDeleted()`, `getNumRecords()`.
- 새 `CursorFetchResult` 클래스: `getNextIndex()`, `getNumDeletedRecords()`, `getRecords()`, `isDone()`.

### Invocable Namespace

- packaged custom action 특정 버전 반환: `createCustomAction(type, namespace, name, version)`.
- standard action 특정 버전 반환: `createStandardAction(type, version)`.

### CommercePayments Namespace

- 새 enum `RetryCategory`(payment failure category — retry 적격 결정), `RetryDecision`(retry 가능 여부), `PaymentMethodIdType`(payment method type ID).

### IssueCreditMemo Namespace (신규)

- `CreditRequestInputRepresentations` — invoice/amount + dispute, category, line-level credit 상세로 credit request 생성(constructors + properties).
- `CreditLineRequestInputRepresentations` — invoice line/amount로 credit line request 생성.
- `CreditResponseOutputRepresentations` — credit memo 작업 결과 + 추가 상세.

### Salesforce Maps Namespace

- **VERSIONED BEHAVIOR CHANGE:** `GetDistanceMatrix()`가 traffic window index를 8개 대신 **4개** 반환. `traffic_windows` property로 consolidated start/end time 포함 index set 접근.

### renew_assets_summary Namespace (신규)

- `RenewalOpptyDetail` — asset 상세 + renewal pricing으로 renewal opportunity 생성.
- `RenewalPriceDetail` — asset의 net unit price + quantity 지정.

### RulesAppln Namespace (신규)

- `RulesApplicationResponse` — rule application 상세.
- `RulesApplicationSummaryResponse` — `applyPaymentsAndCreditsByRules` invocable action 출력.
- `RulesApplicationErrorResponse` — error code + message.

### runtime_industries_insurance Namespace (신규)

- `AddEligibleInsuranceClausesOptions`, `CreateInsuranceQuoteOptions`, `CreateInsuranceRatingOptions`, `GenerateInsuranceClausesOptions`, `UpdateInsuranceQuoteOptions` (모두 constructors + properties).

### CommerceTax Namespace

- `CalculateTaxRequest` 클래스에 새 property `isHeaderTaxRequested`(invoice header level 세금 캡처). (→ [[Spring '26/Clouds]] Revenue Management)

### ConnectApi Namespace

**Rate Limit:** per user/namespace/hour → per org/24-hour Salesforce Platform API rate limit으로 마이그레이션. Summer '24 이후 생성 org는 이미 Platform API rate limit 사용.

**New Connect in Apex Classes / Methods:**

- **Commerce** — `ConnectApi.OrderSummary`: `getSequenceOrderPaymentSummaryInputList(List<SequenceOrderSummaryPaymentInputRepresentation> sequences)`, `getSequenceOrderPaymentSummaryInputRepresentation(orderPaymentSummaryId, amount)`.
  > ⚠️ source-verifier 플래그: PDF가 컬럼 경계에서 첫 메서드의 파라미터 타입을 `List<SequenceOrderSummaryPaymentInputRepresen`로 자르고 `sequences)`가 이어진다. 전체 타입은 `List<SequenceOrderSummaryPaymentInputRepresentation>`로 **추정**되나 PDF 텍스트가 잘려 있어 확정하지 않는다(임의 보완 안 함). 정확한 타입은 Apex Reference Guide로 확인.
- **Data 360** — `ConnectApi.CdpActivationExternalPlatform`: `getActivationExternalPlatforms()`, `getActivationExternalPlatforms(limit, offset, orderBy)`(output `ConnectApi.ActivationExternalPlatformCollection`). `ConnectApi.CdpQuery`: `getMetadataEntities()`, `getMetadataEntities(entityCategory, entityType)`, `getMetadataEntities(entityCategory, entityType, dataspace)`(output `ConnectApi.CdpQueryMetadataEntitiesOutput`).
- **Named Credentials** — `ConnectApi.NamedCredentials`: `deleteExternalAuthIdentityProvider(developerName)`, `deleteExternalCredential(developerName)`, `deleteNamedCredential(developerName)`, `updateExternalAuthIdentityProvider(developerName, requestBody)`, `updateExternalCredential(developerName, requestBody)`, `updateNamedCredential(developerName, requestBody)`. API v66.0+. (→ [[ConnectApi Namespace 개요]], 보안 맥락은 [[Spring '26/Platform]])
- **Orchestration** — `ConnectApi.Orchestration`: `getOrchestrationInstanceCollection(relatedRecordId, relatedOrchestrationId)`.
- **Records** — 새 `ConnectApi.RecordUi`: `getPicklistValuesByRecordType(objectApiName, recordTypeId)`(output `ConnectApi.PicklistValuesCollection`).
- **Salesforce CMS** — `ConnectApi.ManagedContent`: `getManagedContentProvidersForSpace(contentSpaceId)`, `updateManagedContentProviderInstance(providerInstanceId, providerInstanceInput)`.
- **Salesforce Flow** — 새 `ConnectApi.FlowApprovalProcesses`: `getFlowApprovalProcessWithStatus(relatedRecordId, processNames)`(output `ConnectApi.FlowApprovalProcessCollection`).
- **Billing** — `ConnectApi.BillingAdvanced`: `voidPostedCreditMemo(voidPostedCreditMemoInputRepresentation)`(input `ConnectApi.VoidPostedCreditMemoInputRepresentation`, output `ConnectApi.VoidPostedCreditMemoOutputRepresentation`). `ConnectApi.CalculateTaxRequest`에 `isHeaderTaxRequested`.

**Changed Connect in Apex Input/Output/Enums:**

- Commerce `ConnectApi.EnsureFundsAsyncInputRepresentation`: 새 `isAllowPartial`, `SequenceOrderPaymentSummaryInputList`.
- Salesforce CMS `ConnectApi.ManagedContentDocument`: 새/변경 `contentVersion`, `variantVersion`, `version`(더 이상 반환 안 됨). `ConnectApi.ManagedContentProviderCollection`: 새 `contentSpaceId`. `ConnectApi.ManagedContentProviderInstance`: 새 `isEnabledForSpace`.
- Service Email `ConnectApi.EmailMessageCapability`: 새 `emailSize`.
- Enums: `ConnectApi.ExternalCredentialParameterType` 새 값 `SfHttpRequestExtensionName`; `ConnectApi.IdentityProviderAuthFlow` 새 값 `ClientCredentials`; `ConnectApi.NamedCredentialParameterType` 새 값 `SfHttpRequestExtensionName`.

### Lightning Components: New and Changed Items

**New LWC Components:** `lightning-empty-state`(Beta), `lightning-illustration`(Beta).

**Changed LWC Components (전수):**

- `lightning-combobox` — validation·form submission에 올바르게 참여(invalid 값 + form validation 시 브라우저 focus).
- `lightning-datatable` — inline editing 중 status bar 표시 시 table container 높이 3rem 감소. `displayReadOnlyIcon:true` + `editable:false` 시 lock icon이 `aria-label="Locked Column Name"` + `role="image"`를 가진 `<span>`에 표시. lock icon assistive text `<span>` 제거.
- `lightning-flexcard` — 새 attribute `lwr`(LWR sites 임베드 시 `true`).
- `lightning-input`(date/datetime calendar accessibility) — month/year `<select>`에 `aria-describedby`; `tabindex`가 `<td>` → day button(`role="button"` `<span>`)으로 이동; `aria-selected`/`aria-current`/`aria-disabled`가 `role="button"` `<span>`으로 이동; `aria-label`이 `8 October 2025, button` 형식; 필수 checkbox/date/datetime/time/file의 `<abbr>`에 `aria-hidden="true"`.
- `lightning-input-address` — Geolocation이 10초 후 timeout 시 San Francisco, CA(위도 37.790091, 경도 -122.396848)로 기본 설정.
- `lightning-input-field` — date/datetime calendar는 `lightning-input`과 동일 변경.
- `lightning-input-rich-text` — 기본 font size 13으로 변경. **manual image upload(developer preview)** — 새 attribute `manual-image-upload`(존재 시 이미지가 삽입되나 업로드 안 됨), 새 메서드 `uploadPendingImages()`(이미지당 결과 1개 배열 promise; 성공 시 `imageId`/`file`/`success:true`/`downloadUrl`/`contentVersionId`, 실패 시 `imageId`/`file`/`success:false`/`error`). 새 이벤트 `imageupload`(detail: `imageId`=`pending-img-`+timestamp, `file`, `success`, `downloadUrl`, `contentVersionId`(`068` prefix)), `imageuploaderror`(detail: `error`, `file`, `imageId`, `maxSize`=**1 MB = 1,048,576 bytes**, `reason`=`SIZE_EXCEEDED` 또는 `UPLOAD_FAILED`).
- `lightning-omniscript` — 새 attribute `lwr`(LWR sites 임베드 시 `true`).
- `lightning-radio-group` — `role="status"` `<div>` 추가, field-level error 시 field label assistive text `<span>`.
- `lightning-select` — `role="status"` `<div>`, field-level error 시 field label `<span>`.
- `lightning-tree` — chevron icon이 bare variant(파란색).
- `lightning-tree-grid` — Right Arrow expand 후 다시 Right Arrow 시 checkbox 열로 focus(숨김 아닐 때).

**New/Changed Modules:**

- 새 `lightning/industriesConfigureApi` — Revenue Management Configuration API(cart/cart item 구성·가격·lifecycle, product/category/bulk product 상세, saved configuration/rule).
- `lightning/graphql` — 새 메서드 `executeMutation`(파라미터 `query`(`gql` template literal, non-reactive), `variables`).
- `lightning/navigation` — 새 `standard__flow` PageReference type.

**New Targets:** `lightning__PropertyEditor`(Experience Builder custom property editor).

**New Directives:** `lwc:on={eventHandlers}`(element에 event listener 동적 추가, 동적 계산 event type 지원).

**Changed Aura Components:** `lightning:combobox`, `lightning:datatable`, `lightning:input`, `lightning:inputAddress`, `lightning:inputField`, `lightning:navigation`(새 `standard__flow`), `lightning:radioGroup`, `lightning:tree`, `lightning:treeGrid` — 모두 LWC 대응 컴포넌트와 동일 변경. `lightning:omniChannelStatusChanged` 이벤트에 새 attribute `reason`(값 `OmniToolkitStatusChange`, `OmniPushTimeout`, `OmniDeclineWork`, `OmniManualStatusChange`, `OmniSupervisorStatusChange`, `OmniLoginStatusChange`).

---

## Visualforce

- **`<apex:inputField>` label 속성 이스케이프 (XSS 방지, Release Update)** — Visualforce 페이지의 `<apex:inputField>` `label` 속성을 자동 escape하여 XSS 방지. 대부분 org는 Spring '23에 enforce, 나머지 모든 org는 **Spring '26**에 enforce. ⚠️ enforce 후 이미 escape된 label은 double-escape되어 렌더 오류가 날 수 있다. 강제 시점·first available 불일치(메인 리스트 "Spring '23" vs 상세 "Winter '23")는 → [[Spring '26/Release Updates]].

---

## Packaging

- **Customized Push Upgrade로 패키지 업그레이드 관리** — partner가 select customer에게 push upgrade 차단 권한을 부여(규제 환경용). 2GP + 1GP managed packages. (→ [[2GP — Push Upgrade]])
- **구독자에게 패키지 버전 추천** — recommended version 설정 시 subscriber가 Installed Packages에서 "Upgrade to Recommended Version" 표시. released version만 가능. CLI: `sf package update --recommended-version-id`. 2GP.
- **디버그 로그 활성화로 구독자 이슈 빠른 진단** — License Management App(LMA)으로 subscriber의 managed Apex debug log를 self-serve 활성화(이전엔 Partner Support case). **namespace 단위**로 활성화 — 2GP에서 namespace 공유 시 그 namespace의 모든 managed package log 활성화. 1GP + 2GP.

---

## Dev Environments

- **Sandbox Copy 진행 상황 상세 UI** — sandbox copy/refresh에 visual progress bar + real-time status. (April 2026). Winter '27까지 Dev Hub Settings에서 old UI로 임시 revert 가능. Enterprise/Performance/Unlimited.
- **대형 production org용 Full Sandbox Quick Create** — Quick Create가 이제 **1 TB 초과** Hyperforce 호스팅 production org에서 사용 가능(이전엔 1 TB까지). 대부분 legacy 대비 2~3배 빠름. resource 제한 시 legacy method로 fallback될 수 있음.
- **새 Data Mask and Seed (Beta)** — Data Mask policy 정의로 sensitive sandbox data(proprietary, restricted, government-regulated, PII) 마스킹. (상세 Where/When/How는 PDF 후속 라인에 이어짐 — 본 노트는 nav 요약 기준 1줄 설명.)

---

## 거버너 한도 변경

| 항목 | 정확한 수치 |
|---|---|
| Apex Cursor — 24시간당 새 cursor row 최대 누적 | **1억 (100 million)** |
| Metadata 배포/검색 한도 적용 type | `AIAuthoringBundle`, `AnalyticsDashboard`, `AnalyticsWorkspace`, `AnalyticsVisualization` (zip당 component 수 + 24시간당 deploy/retrieve 횟수) |
| Data 360 SOQL 쿼리 결과 1회 한도 | **12 MB** (초과 시 query 거부) |
| `lightning-input-rich-text` 이미지 `maxSize` | **1 MB = 1,048,576 bytes** |
| `Cursor.fetch()` / `PaginationCursor.fetchPage()` | SOQL query limit + row limit에 계속 카운트 |
| 새 limits resource 값 | `ScheduledFlowRunLimit`, `ScheduledPathRunLimit` (GET `/limits`) |

> ⚠️ source-verifier 플래그(코드 불일치): Data SDK 코드 예제(PDF line 27744~)가 v66.0 릴리즈인데도 내부에서 `/services/data/v67.0/...`를 사용한다. **이는 PDF 원문 자체의 표기**(pdftotext 재추출로 확인 — 전사 오류 아님)이며, 본 노트에는 해당 Data SDK 코드 블록을 옮기지 않았다. 불일치 사실만 기록한다.

---

## 관련 노트

- [[Spring '26]] — 상위 허브
- [[Spring '26/Release Updates]] — no-arg 생성자·SOAP login()·Blob.toPdf 강제 시점
- [[Spring '26/Platform]] — Sharing Recalculation Release Update · Named Credentials Apex 메서드 보안 맥락
- [[Spring '26/Clouds]] — 클라우드 제품 객체·REST·Revenue Management 객체 전수
- [[Spring '26/Agentforce]] — Apex/AuraEnabled → Agent Action 노출
- [[WITH USER_MODE]] — Automated Process User user mode SOQL
- [[SOQL 패턴]] · [[DML 패턴]]
- [[EventBus Namespace]] — `EventBusSubscriber` Position·Tip Deprecated
- [[ConnectApi Namespace 개요]] — `RecordUi.getPicklistValuesByRecordType` 외 신규 메서드
- [[Lightning Base Components 레퍼런스]] — 전 TypeScript 타입 완성
- [[SLDS LWC 디자인 시스템]] · [[SLDS 블루프린트 카탈로그]]
- [[2GP — Push Upgrade]] — Customized Push Upgrade
