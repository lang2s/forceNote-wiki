---
tags: [sf-mcp, mcp, salesforce-dx, metadata-enrichment, tools]
source: salesforcecli/mcp (packages/mcp-provider-metadata-enrichment/, 공식 Salesforce)
created: 2026-06-27
aliases: [enrich_metadata, EnrichMetadataMcpProvider, EnrichMetadataMcpTool, 메타데이터 보강, 메타데이터 enrichment, AI 설명 생성]
---

# mcp-provider-metadata-enrichment — 메타데이터 보강 MCP 프로바이더

> DX 프로젝트의 메타데이터 컴포넌트(Custom Object·LWC)에 AI가 생성한 설명을 추가하는 단일 도구 `enrich_metadata`를 제공하는 MCP 프로바이더.

---

## 역할

`EnrichMetadataMcpProvider`는 `@salesforce/mcp-provider-api`의 `McpProvider`를 확장하며, 도구를 하나만 등록한다 — `EnrichMetadataMcpTool`. 이 도구는 로컬 DX 프로젝트의 지원 컴포넌트에 AI 생성 설명을 채워 넣어 메타데이터를 "보강(enrich)"한다.

```typescript
// 발췌 — src/provider.ts
export class EnrichMetadataMcpProvider extends McpProvider {
  public getName(): string {
    return "EnrichMetadataMcpProvider";
  }

  public provideTools(services: Services): Promise<McpTool[]> {
    return Promise.resolve([
      new EnrichMetadataMcpTool(services),
    ]);
  }
}
```

`provideTools()`는 `Services`를 도구 생성자에 그대로 주입한다(`new EnrichMetadataMcpTool(services)`). 도구는 이 서비스로부터 org connection을 얻는다.

> 다른 프로바이더 도구와 달리 release state가 GA가 아니다 — `getReleaseState()` = `ReleaseState.NON_GA`. Toolset 소속은 `[Toolset.ENRICHMENT]`.

---

## 제공 도구 — `enrich_metadata` (`EnrichMetadataMcpTool`)

- **getName():** `enrich_metadata`
- **title:** `Enrich Metadata`
- **getReleaseState():** `ReleaseState.NON_GA`
- **getToolsets():** `[Toolset.ENRICHMENT]`
- **annotations:** `openWorldHint: true` (org/외부 상태에 영향)
- **outputSchema:** `undefined` (출력 스키마 미정의 — 소스 주석: "choosing to not describe an output schema and just let the LLM figure things out")

### 입력 스키마 (`enrichMetadataSchema`)

| 필드 | 타입 | 비고 |
|---|---|---|
| `usernameOrAlias` | `usernameOrAliasParam` (`@salesforce/mcp-provider-dx-core`) | 대상 org의 username/alias |
| `directory` | `directoryParam` (`@salesforce/mcp-provider-dx-core`) | 도구를 실행할 디렉터리 |
| `metadataEntries` | `z.array(z.string()).optional()` | 보강할 메타데이터 항목. 형식 `<componentType>:<componentName>`. 사용자가 무엇을 보강할지 모호하면 unset으로 둔다 |

소스의 `metadataEntries` describe 원문:

> `The metadata entries to enrich. Leave this unset if the user is vague about what to enrich. Format: <componentType>:<componentName>`

### description (AGENT INSTRUCTIONS 요지)

도구 description에 LLM용 지침이 길게 들어 있다. 핵심:

- 기능: `Enrich metadata components in your DX project by adding AI-generated descriptions.`
- org이 metadata enrichment 자격을 갖춰야 한다(Salesforce 관리자가 활성화).
- 사용자가 무엇을 보강할지 명확히 말하지 않으면(예: "enrich metadata") 로컬 프로젝트의 구체적 컴포넌트 이름을 물어본다. 컴포넌트 이름에 **wildcard 지원**(로컬 프로젝트 컴포넌트와 매칭).
- **지원 컴포넌트 타입** (Component Type → Metadata Type, enrichment 요청에 쓰이는 건 Metadata Type):

| Component Type | Metadata Type |
|---|---|
| Custom Object | `CustomObject` |
| Lightning Web Component (LWC) | `LightningComponentBundle` |

- 미지원 타입을 지정하면 해당 항목은 skip하고 지원 컴포넌트는 계속 보강한다.
- 여러 컴포넌트를 지정하면 한 번에 batch 처리(도구가 다중 동시 처리 가능).
- 응답은 성공/실패/skip된 컴포넌트를 포함한다. enrichment 상태는 **오직 도구의 enrichment 응답**이 유일한 진실 — 이전 대화 컨텍스트나 과거 성공 응답으로 상태를 판단하지 말 것.
- `#retrieve_metadata` / `#deploy_metadata` 와는 다른 도구다. retrieve/deploy 의도면 그쪽을 써야 한다. 의도가 불분명하면 사용자에게 명확화 요청.
- 이 도구는 **로컬 프로젝트의 메타데이터만 갱신**하고 org에 배포하지 않는다. 변경을 저장하려면 사용자가 별도로 배포해야 한다.
- EXAMPLE USAGE: `"Enrich X"`, `"Enrich X and Y"`, `"Enrich X, Y, and Z"`, `"Enrich X metadata"`, `"Enrich this metadata"`, `"Enrich this component"` 등.

### 동작 (`exec`)

`exec(input)`의 흐름:

1. **유효성 검사** — `usernameOrAlias`가 없으면 `isError: true`로 `#get_username` 사용 안내. `metadataEntries`가 없으면 `isError: true`로 보강 대상 컴포넌트 지정 요청.
2. **컨텍스트 준비** — `process.chdir(input.directory)` → `this.services.getOrgService().getConnection(usernameOrAlias)`로 connection 획득 → `SfProject.resolve(directory)`로 프로젝트 resolve.
3. **컴포넌트 셋 빌드** — `ComponentSetBuilder.build()`(`@salesforce/source-deploy-retrieve`)에 `metadataEntries`와 프로젝트 경로를 넘겨 `getSourceComponents().toArray()`로 소스 컴포넌트 목록을 얻는다.
4. **skip 판정** — `SourceComponentProcessor.getComponentsToSkip(...)`로 보강 불가 컴포넌트를 가려 `EnrichmentRecords`에 기록하고, 나머지를 `componentsEligibleToProcess`로 필터링한다. 처리 대상이 0개면 `isError: true`로 `No eligible component was found for metadata enrichment.` 반환.
5. **보강 실행** — `EnrichmentHandler.enrich(connection, componentsEligibleToProcess)`로 보강, 결과를 `enrichmentRecords.updateWithResults()`로 반영.
6. **파일 갱신** — `FileProcessor.updateMetadata(...)`로 로컬 메타데이터 파일을 갱신하고 결과를 다시 records에 반영.
7. **요약 작성** — `EnrichmentStatus` 기준으로 `SUCCESS`/`SKIPPED`/`FAIL` 레코드를 분류해 요약 텍스트를 만든다(enriched 목록에 Request ID 포함). **모두 실패일 때만**(`successful=0 && skipped=0 && failed>0`) `isError: true`.

위 보강·파일 처리 로직은 `@salesforce/metadata-enrichment` 패키지(`SourceComponentProcessor`, `EnrichmentHandler`, `EnrichmentRecords`, `EnrichmentStatus`, `FileProcessor`)에 위임된다.

```typescript
// 발췌 — src/tools/enrich_metadata.ts (요약 분류 부분)
const successfulRecords = Array.from(enrichmentRecords.recordSet).filter(
  (record) => record.status === EnrichmentStatus.SUCCESS
);
const skippedRecords = Array.from(enrichmentRecords.recordSet).filter(
  (record) => record.status === EnrichmentStatus.SKIPPED
);
const failedRecords = Array.from(enrichmentRecords.recordSet).filter(
  (record) => record.status === EnrichmentStatus.FAIL
);
```

예외 발생 시 `isError: true`와 `Unexpected error occurred while enriching metadata: ${error}` 반환.

---

## 관련 노트
- [[sf-mcp - 개요]] — sf-mcp 서버 전체 개요
- [[mcp-provider-api]]
