---
tags: [sf-mcp, mcp, salesforce-dx, mobile-web, tools, lwc]
source: salesforcecli/mcp (packages/mcp-provider-mobile-web/, 공식 Salesforce)
created: 2026-06-27
aliases: [create_mobile_lwc_native_capabilities, get_mobile_lwc_offline_analysis, get_mobile_lwc_offline_guidance, MobileWebMcpProvider, mobile-web 프로바이더, 모바일 LWC, 오프라인 분석, 네이티브 캡abilities]
---

# mcp-provider-mobile-web — 모바일 웹 LWC MCP 프로바이더

> Salesforce 모바일 앱용 LWC 개발을 돕는 MCP 프로바이더 — 네이티브 디바이스 기능 grounding, 오프라인 정적 분석, 오프라인 리뷰 가이던스 도구를 제공한다.

---

## 역할

`MobileWebMcpProvider`는 `@salesforce/mcp-provider-api`의 `McpProvider`를 확장하며, LWC를 Salesforce 모바일 앱(Mobile App Plus, Field Service Mobile App 등)에 맞게 작성하도록 돕는 MCP 도구들을 등록한다. 크게 세 종류다.

- **Native Capabilities** — 모바일 디바이스 네이티브 기능(바코드 스캐너, 생체인증, 위치 등)의 TypeScript API 타입 정의를 grounding 컨텍스트로 제공해, LLM이 해당 기능을 쓰는 LWC를 정확히 생성하도록 한다.
- **Offline Analysis** — LWC 코드를 정적 분석(ESLint 기반 LWC graph analyzer)하여 오프라인 호환성 문제를 찾아낸다.
- **Offline Guidance** — 오프라인 위반을 탐지·교정하기 위한 구조화된 리뷰 지침(expert review instructions)을 LLM에 전달한다.

`provideTools()`는 native-capability 설정(`nativeCapabilityConfigs`) 각각에 대해 `NativeCapabilityTool` 인스턴스를 만들고, 거기에 `OfflineAnalysisTool`·`OfflineGuidanceTool` 하나씩을 더해 반환한다.

```typescript
// 발췌 — src/provider.ts
export class MobileWebMcpProvider extends McpProvider {
  public getName(): string {
    return 'MobileWebMcpProvider';
  }

  public provideTools(_services: Services): Promise<McpTool[]> {
    const nativeCapabilityTools: NativeCapabilityTool[] = [];
    for (const config of nativeCapabilityConfigs) {
      nativeCapabilityTools.push(new NativeCapabilityTool(config));
    }

    return Promise.resolve([new OfflineAnalysisTool(), new OfflineGuidanceTool(), ...nativeCapabilityTools]);
  }
}
```

> 세 도구 모두 `getReleaseState()` = `ReleaseState.GA`, `annotations.readOnlyHint = true`(읽기 전용)다. Toolset 소속은 도구마다 다르다(아래 참조).

---

## 제공 도구

### 1. Native Capability 도구군 (`NativeCapabilityTool`)

단일 클래스 `NativeCapabilityTool`이 `NativeCapabilityConfig` 하나당 한 개의 도구로 등록된다. 즉 도구 이름(`getName()`)은 고정된 `create_mobile_lwc_native_capabilities`가 아니라 **각 config의 `toolId`** 다. `nativeCapabilityConfigs` 배열에 11개 설정이 있어 11개 도구가 등록된다.

**동작:** `exec()`는 `resources/` 폴더에서 세 개의 `.d.ts` 파일을 읽어 grounding 텍스트를 조립한다 — 해당 서비스 타입 정의(`typeDefinitionPath`), 공통 `BaseCapability.d.ts`, `mobileCapabilities.d.ts`. `createServiceGroundingText()`가 만드는 markdown 텍스트 구조는 다음과 같다(소스의 템플릿 리터럴을 재현).

```text
# {serviceName} Service Grounding Context

{serviceDescription}        ← config.groundingDescription

## Base Capability
  (BaseCapability.d.ts 내용을 typescript 코드펜스로 삽입)

## Mobile Capabilities
  (mobileCapabilities.d.ts 내용을 typescript 코드펜스로 삽입)

## {serviceName} Service API
  (typeDefinitionPath 의 .d.ts 내용을 typescript 코드펜스로 삽입)
```

파일 읽기에 실패하면 `isError: true`와 `Error: Unable to load ${this.toolId} type definitions.` 텍스트를 반환한다.

**입력 스키마:** `EmptySchema` (= `z.object({})`, 입력 없음).
**출력 스키마:** config에서 `outputSchema: undefined` (스키마 미정의). 응답은 `content[].text` + `structuredContent.content`에 grounding 텍스트를 담는다.

**Toolset:** `config.isCore`가 `true`면 `[Toolset.MOBILE, Toolset.MOBILE_CORE]`, 아니면 `[Toolset.MOBILE]`.

11개 native-capability 도구 (toolId · serviceName · isCore · typeDefinitionPath):

| toolId | serviceName | isCore | typeDefinitionPath |
|---|---|---|---|
| `create_mobile_lwc_app_review` | App Review | false | `appReview/appReviewService.d.ts` |
| `create_mobile_lwc_ar_space_capture` | AR Space Capture | false | `arSpaceCapture/arSpaceCapture.d.ts` |
| `create_mobile_lwc_barcode_scanner` | Barcode Scanner | true | `barcodeScanner/barcodeScanner.d.ts` |
| `create_mobile_lwc_biometrics` | Biometrics | true | `biometrics/biometricsService.d.ts` |
| `create_mobile_lwc_calendar` | Calendar | false | `calendar/calendarService.d.ts` |
| `create_mobile_lwc_contacts` | Contacts | false | `contacts/contactsService.d.ts` |
| `create_mobile_lwc_document_scanner` | Document Scanner | false | `documentScanner/documentScanner.d.ts` |
| `create_mobile_lwc_geofencing` | Geofencing | false | `geofencing/geofencingService.d.ts` |
| `create_mobile_lwc_location` | Location | true | `location/locationService.d.ts` |
| `create_mobile_lwc_nfc` | NFC | false | `nfc/nfcService.d.ts` |
| `create_mobile_lwc_payments` | Payments | false | `payments/paymentsService.d.ts` |

각 config의 `description`은 동일 패턴이다 — 예시(App Review):

> `The MCP tool provides a comprehensive TypeScript-based API documentation for Salesforce LWC App Review Service, laying the foundation for understanding mobile app review and offering expert-level guidance for implementing the App Review feature in a Lightning Web Component (LWC).`

### 2. `get_mobile_lwc_offline_analysis` (`OfflineAnalysisTool`)

- **title:** `Salesforce Mobile Offline LWC Expert Static Analysis`
- **description:** `Analyzes LWC components for mobile-specific issues and provides detailed recommendations for improvements. It can be leveraged to check if components are mobile-ready.`
- **Toolset:** `[Toolset.MOBILE, Toolset.MOBILE_CORE]`

**동작:** `@salesforce/eslint-plugin-lwc-graph-analyzer`의 `recommended` 설정으로 flat-config ESLint `Linter`를 구성하고, `bundleAnalyzer.setLwcBundleFromContent(...)`로 LWC 번들을 세팅한 뒤 `linter.verifyAndFix()`로 JS를 검사한다. lint 메시지의 `ruleId`를 `ruleConfigs` 기반 매핑(`ruleReviewers`)으로 풀어 구조화된 이슈로 변환한다. `code.js`가 없으면 빈 이슈 배열을 반환한다.

검출 규칙 → 이슈 매핑 (`src/tools/offline-analysis/ruleConfig.ts`):

| ESLint rule id (`@salesforce/lwc-graph-analyzer/...`) | 이슈 type |
|---|---|
| `no-private-wire-config-property` | Private Wire Configuration Property |
| `no-wire-config-references-non-local-property-reactive-value` | Wire Configuration References Non-Local Property |
| `no-assignment-expression-assigns-value-to-member-variable` | Violations in Getter |
| `no-reference-to-class-functions` | Violations in Getter |
| `no-reference-to-module-functions` | Violations in Getter |
| `no-getter-contains-more-than-return-statement` | Violations in Getter |
| `no-unsupported-member-variable-in-member-expression` | Violations in Getter |

**입력 스키마(`LwcCodeSchema`):**

| 필드 | 타입 | 설명 |
|---|---|---|
| `name` | `string` (min 1) | Name of the LWC component |
| `namespace` | `string` (default `'c'`) | Namespace of the LWC component |
| `js` | `LwcFileSchema` | LWC component JavaScript file. |
| `html` | `LwcFileSchema[]` (min 1) | LWC component HTML templates. |
| `css` | `LwcFileSchema[]` (optional) | LWC component CSS files. |
| `jsMetaXml` | `LwcFileSchema` (optional) | LWC component configuration .js-meta.xml file. |

`LwcFileSchema` = `{ path: string, content: string }`.

**출력 스키마(`ExpertsCodeAnalysisIssuesSchema`):** `analysisResults`(`ExpertCodeAnalysisIssues[]`, min 1) + `orchestrationInstructions`(string, default 제공). 각 이슈는 `type / description / intentAnalysis / suggestedAction`(base) + `filePath / code? / location`를 가진다. expertReviewerName은 `Mobile Web Offline Analysis`.

`orchestrationInstructions` 기본값(요지): 이 스레드에서 아직 `get_mobile_lwc_offline_guidance`를 실행하지 않았다면 즉시 호출 → 가이던스 지침을 사용자 LWC에 실행 → 두 결과를 합쳐 리팩터링하라.

### 3. `get_mobile_lwc_offline_guidance` (`OfflineGuidanceTool`)

- **title:** `Salesforce Mobile Offline LWC Expert Instruction Delivery`
- **description:** `Provides structured review instructions to detect and remediate Mobile Offline code violations in Lightning web components (LWCs) for Salesforce Mobile Apps.`
- **Toolset:** `[Toolset.MOBILE, Toolset.MOBILE_CORE]`
- **입력 스키마:** `EMPTY_INPUT_SCHEMA` = `z.object({}).describe('No input required')`.

**동작:** 정적 코드를 분석하지 않고, LLM이 직접 수행할 두 개의 "expert review instruction"을 반환한다.

1. **Conditional Rendering Compatibility Expert** (supportedFileTypes: `['HTML']`) — Komaci 오프라인 정적 분석 엔진이 최신 조건부 렌더링 디렉티브(`lwc:if`, `lwc:elseif`, `lwc:else`)를 지원하지 않으므로 레거시 디렉티브(`if:true`, `if:false`)로 변환하도록 지시한다.
2. **GraphQL Wire Configuration Expert** (supportedFileTypes: `['JS']`) — `@wire` 어댑터 설정에 인라인으로 박힌 GraphQL 쿼리를 별도 getter 메서드로 추출하도록 지시한다(Komaci가 오프라인 데이터 priming을 위해 요구).

각 expert는 `grounding`(배경)·`request`(리뷰 요청 절차)·`expectedResponseFormat`(`zodToJsonSchema(ExpertCodeAnalysisIssuesSchema)` + `inputValues.expertReviewerName`)을 포함한다.

**출력 스키마(`ExpertsReviewInstructionsSchema`):** `reviewInstructions`(`ExpertReviewInstructions[]`, min 1) + `orchestrationInstructions`(default 제공). orchestration 기본값(요지): 이 응답의 리뷰 지침을 먼저 사용자 LWC에 실행 → 이어서 `get_mobile_lwc_offline_analysis`를 사용자 코드로 호출 → 두 결과를 합쳐 리팩터링하라.

> Analysis ↔ Guidance 두 도구는 서로의 `orchestrationInstructions`를 통해 **짝(companion)으로 함께 실행**되도록 설계되어 있다. 어느 쪽을 먼저 호출하든 나머지 하나를 호출해 결과를 합치게 유도한다.

---

## 관련 노트
- [[sf-mcp - 개요]] — sf-mcp 서버 전체 개요
- [[mcp-provider-api]]
