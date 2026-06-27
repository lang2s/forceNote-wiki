---
tags: [sf-mcp, mcp, salesforce-dx, server, cli]
source: salesforcecli/mcp (packages/mcp/, 공식 Salesforce)
created: 2026-06-27
aliases: [@salesforce/mcp, MCP 서버 패키지, --toolsets, --orgs, --allow-non-ga-tools, 프로바이더 로딩]
---

# mcp — @salesforce/mcp 서버 패키지

> Salesforce DX MCP Server의 실행 진입점 패키지. `sf-mcp-server` bin으로 stdio MCP 서버를 띄워 LLM이 인가된 org에 안전하게 접근하게 한다. CLI 플래그(`--orgs`/`--toolsets`/`--tools`/`--allow-non-ga-tools` 등)를 파싱하고, `MCP_PROVIDER_REGISTRY`의 8개 provider에서 툴을 수집해 toolset·GA 게이팅을 적용한 뒤 등록한다.

---

## 역할 / 목적

`@salesforce/mcp`(v0.30.14)는 LLM과 Salesforce org 사이를 잇는 **Model Context Protocol 서버 구현체**다. provider 패키지들이 제공하는 60개+ MCP 툴을 모아 하나의 서버로 노출하며, 각 클라이언트(VS Code Copilot, Claude Code, Cline, Cursor 등)는 `npx -y @salesforce/mcp ...` 형태로 이 서버를 구동한다.

| 항목 | 값 (package.json) |
|---|---|
| 패키지명 | `@salesforce/mcp` |
| 버전 | `0.30.14` |
| bin | `sf-mcp-server` → `bin/run.js` |
| 진입 command | oclif single command, `target: ./lib/index.js` (소스 `src/index.ts`) |
| transport | `StdioServerTransport` (stdio) |
| Node 요구 | `>=20.0.0` |

서버 클래스 `SfMcpServer`(`src/sf-mcp-server.ts`)는 SDK의 `McpServer`를 상속해 **telemetry + rate limiting**을 덧입힌 래퍼다. `registerTool`을 오버라이드해 모든 툴 호출을 가로채고, 호출 전 rate-limit을 확인하며 호출 후 `TOOL_CALLED` 텔레메트리(런타임 ms·`isError`·응답 char count)를 보낸다.

```ts
// 발췌 — src/index.ts (run())
await Cache.safeSet('allowedOrgs', new Set(flags.orgs));
const server = new SfMcpServer(
  { name: 'sf-mcp-server', version: this.config.version,
    capabilities: { resources: {}, tools: {} } },
  { telemetry: this.telemetry }
);
await registerToolsets(
  flags.toolsets ?? [], flags.tools ?? [],
  flags['dynamic-tools'] ?? false, flags['allow-non-ga-tools'] ?? false,
  server, services
);
const transport = new StdioServerTransport();
await server.connect(transport);
```

---

## CLI 플래그 (args 옵션 — verbatim)

플래그 정의는 oclif `Command.flags`(`src/index.ts`)에 있다. README의 args 테이블과 동일하다.

| 플래그 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `--orgs` (`-o`) | string, multiple, `,` 구분 | **Yes** | 접근을 허용할, 로컬에서 인가한 org. 최소 1개 필수. |
| `--toolsets` | option(enum), multiple, `,` 구분 | No | 활성화할 toolset. `all`이면 모든 toolset. `--dynamic-tools`와 상호 배타. |
| `--tools` | string, multiple, `,` 구분 | No | 개별 툴 이름. `--toolsets`와 병용 가능. `--dynamic-tools`와 상호 배타. |
| `--allow-non-ga-tools` | boolean | No | GA뿐 아니라 NON-GA 툴도 등록 허용. 기본은 GA 툴만. |
| `--dynamic-tools` (`-d`) | boolean (experimental) | No | 동적 툴 발견·로딩. 최소 코어 툴로 시작해 필요 시 로드. `--toolsets`와 상호 배타. |
| `--debug` | boolean | No | 디버그 로그 출력 (기본 비활성). 모든 클라이언트가 MCP 로그를 노출하진 않음. |
| `--no-telemetry` | boolean | No | 텔레메트리 비활성 (기본 활성). |
| `--version` | — | — | 버전 출력. |

오류 가드(`registerToolsets`): `--toolsets`·`--tools`·`--dynamic-tools` 중 하나도 없으면 throw —
`Tool registration error. Start server with one of the following flags: --toolsets, --tools, --dynamic-tools`.

### `--orgs` 값 (verbatim)

| 값 | 설명 |
|---|---|
| `ALLOW_ALL_ORGS` | 인가된 모든 org 접근 허용 (주의해서 사용 — 입력 시 `ux.warn` 경고). |
| `DEFAULT_TARGET_DEV_HUB` | 기본 Dev Hub org(로컬 우선, 없으면 글로벌). |
| `DEFAULT_TARGET_ORG` | 기본 target org(로컬 우선, 없으면 글로벌). |
| `<username or alias>` | 특정 org를 username/alias로 지정. |

`--orgs` 파싱은 입력값을 검증한다. `DEFAULT_TARGET_ORG`/`DEFAULT_TARGET_DEV_HUB`이거나 `@` 포함(=username)이거나 `-`로 시작하지 않으면 통과시키고, 그 외(예: `-`로 시작하는 잘못된 입력)는 `ux.error`로 막는다.

```ts
// 발췌 — src/index.ts (orgs flag parse)
if (input === 'ALLOW_ALL_ORGS') {
  ux.warn('ALLOW_ALL_ORGS is set. This allows access to all authenticated orgs. Use with caution.');
}
if (input === 'DEFAULT_TARGET_ORG' || input === 'DEFAULT_TARGET_DEV_HUB'
    || input.includes('@') || !input.startsWith('-')) {
  return Promise.resolve(input);
}
ux.error(`Invalid org input: "${input}". ...`);
```

### 클라이언트 설정 예 (README)

```json
{
  "servers": {
    "Salesforce DX": {
      "command": "npx",
      "args": ["-y", "@salesforce/mcp",
              "--orgs", "DEFAULT_TARGET_ORG",
              "--toolsets", "orgs,metadata,data,users",
              "--tools", "run_apex_test",
              "--allow-non-ga-tools"]
    }
  }
}
```

---

## provider 등록 흐름

서버는 툴을 직접 들고 있지 않고, **provider 레지스트리**에서 수집한다. `src/registry.ts`의 `MCP_PROVIDER_REGISTRY` 배열에 provider 인스턴스가 나열돼 있다 (verbatim 8개):

```ts
// 발췌 — src/registry.ts
export const MCP_PROVIDER_REGISTRY: McpProvider[] = [
  new DxCoreMcpProvider(),
  new CodeAnalyzerMcpProvider(),
  new LwcExpertsMcpProvider(),
  new AuraExpertsMcpProvider(),
  new MobileWebMcpProvider(),
  new DevOpsMcpProvider(),
  new ScaleProductsMcpProvider(),
  new EnrichMetadataMcpProvider(),
  // Add new instances here
];
```

`registerToolsets`(`src/utils/registry-utils.ts`)의 단계:

1. **버전 검증** — 각 provider의 major 버전이 `MCP_PROVIDER_API_VERSION.major`와 일치해야 함. 불일치 시 throw (`The version '...' for '...' is incompatible with this MCP Server.`).
2. **툴 수집** — `createToolRegistryFromProviders`가 각 provider의 `provideTools(services)`를 `Promise.all`로 호출해 받은 `McpTool[]`을, 각 툴의 `getToolsets()`에 따라 `Record<Toolset, McpTool[]>` 레지스트리로 분류.
3. **toolset 선택** — `all`이면 모든 `TOOLSETS`, 아니면 `Toolset.CORE` + 지정 toolset. **CORE는 항상 활성**.
4. **등록** — 선택된 각 toolset의 툴을 `registerTools`로 등록. `--tools`로 개별 툴도 추가 등록(이름 검증 + 일부 rename alias 처리).

```ts
// 발췌 — registry-utils.ts (createToolRegistryFromProviders)
const toolsPromise: Promise<McpTool[]> = provider.provideTools(services);
...
for (const tool of tools) {
  for (const toolset of tool.getToolsets()) {
    registry[toolset].push(tool);
  }
}
```

> provider/툴이 구현하는 `McpProvider`·`McpTool`·`Toolset`·`ReleaseState` 계약 자체는 [[mcp-provider-api]] 참조.

---

## toolset 게이팅

`--toolsets`로 활성화 집합을 정한다. 활성화되지 않은 toolset의 툴은 등록을 건너뛴다(`!! Skipping toolset: '...'`). 사용 가능한 toolset(README):

| Toolset | 설명 |
|---|---|
| `all` | 모든 toolset의 모든 툴 (60개+ — 권장하지 않음, LLM 컨텍스트 과부하). |
| `core` | 핵심 DX MCP 툴. **항상 활성**. |
| `aura-experts` | Aura 컴포넌트 분석·블루프린트·LWC 마이그레이션. |
| `code-analysis` | Salesforce Code Analyzer 정적 분석. |
| `data` | org 데이터 관리(예: SOQL 조회). |
| `devops` | DevOps Center 리소스 읽기·관리·운영. |
| `enrichment` | DX 프로젝트 메타데이터 enrich. |
| `experts-validation` | LWC 프로덕션 준비도(접근성·보안·베스트프랙티스) 검증·스코어링. |
| `lwc-experts` | LWC 개발·테스트·최적화·베스트프랙티스. |
| `metadata` | org↔DX 프로젝트 메타데이터 deploy/retrieve. |
| `mobile` | 모바일 개발 기능. |
| `mobile-core` | `mobile`의 핵심 부분집합. |
| `orgs` | 인가된 org 관리. |
| `scale-products` | Apex 성능 안티패턴 탐지·수정. |
| `testing` | 코드·기능 테스트(Apex/agent 테스트 실행). |
| `users` | org 사용자 관리(예: permission set 할당). |

---

## GA vs NON-GA 툴 게이팅

`registerTools`는 각 툴의 `getReleaseState()`가 `ReleaseState.NON_GA`이고 `--allow-non-ga-tools`가 **꺼져 있으면** 등록을 건너뛴다. 기본값은 GA 툴만 등록.

```ts
// 발췌 — registry-utils.ts (registerTools)
if (!allowNonGaTools && tool.getReleaseState() === ReleaseState.NON_GA) {
  ux.stderr(`* Skipping registration of non-ga tool '${tool.getName()}' because the '--allow-non-ga-tools' flag was not set at server startup.`);
  continue;
}
if (await isToolRegistered(tool.getName())) {
  ux.stderr(`* Skipping registration of tool '${tool.getName()}' because it is already registered.`);
  continue;
}
const registeredTool = server.registerTool(tool.getName(), tool.getConfig(), (...args) => tool.exec(...args));
```

`--dynamic-tools` 사용 시: `EnableToolsMcpTool`·`ListToolsMcpTool`(동적 코어 툴)을 먼저 등록하고 `all` toolset을 강제 추가한 뒤, CORE가 아닌 툴은 등록은 하되 `registeredTool.disable()`로 비활성 상태로 둔다(필요할 때 활성화).

README의 `--tools`/toolset 목록에서 NON-GA로 표기된 툴 예: `create-custom-rule`, `generate_xpath_prompt`(code-analysis), `enrich_metadata`(enrichment), `create_org_snapshot`·`create_scratch_org`·`delete_org`·`open_org`(orgs), `explore_slds_blueprints`·`guide_slds_blueprints`·`guide_utam_generation`·`orchestrate_lwc_slds2_uplift` 등(lwc-experts).

---

## org allowlisting / 보안

서버 시작 시 `--orgs` 값이 `Cache.safeSet('allowedOrgs', new Set(flags.orgs))`로 캐시에 저장되고, 모든 툴은 이 allowlist를 거쳐서만 org 커넥션을 얻는다. 핵심 함수는 `src/utils/auth.ts`에 있다.

- **`getConnection(username)`** — 툴이 커넥션을 얻는 단일 진입점. `getAllAllowedOrgs()`로 허용 org를 매 호출마다 다시 계산(기본 config 변경 대응)하고, 매칭 org가 없으면 reject.
- **`getAllAllowedOrgs()`** — 머신의 모든 인가 org(`AuthInfo.listAllAuthorizations()`)를 `sanitizeOrgs`로 민감 필드 제거 후 `filterAllowedOrgs`로 allowlist 필터.
- **`filterAllowedOrgs(orgs, allowList)`** — `ALLOW_ALL_ORGS`면 전부 통과. 아니면 username/alias 직접 매칭 또는 `DEFAULT_TARGET_ORG`/`DEFAULT_TARGET_DEV_HUB` 기본값 매칭만 허용.
- **`sanitizeOrgs`** — `accessToken` 등 민감 정보를 빼고 `aliases`/`username`/`instanceUrl`/`isScratchOrg`/`isDevHub`/`isSandbox`/`orgId`/`oauthMethod`/`isExpired` 등 허용 필드만 반환.

```ts
// 발췌 — auth.ts (filterAllowedOrgs)
if (allowList.has('ALLOW_ALL_ORGS')) return orgs;
...
if (allowList.has(org.username)) return true;
if (org.aliases?.some((alias) => allowList.has(alias))) return true;
if (allowList.has('DEFAULT_TARGET_ORG') && defaultTargetOrg?.value) { ... }
```

기본 config(default org / dev hub)는 `getDefaultConfig`에서 `ConfigAggregator.clearInstance()` 후 다시 읽어, **서버 시작 후 config 파일 조작으로 allowlist를 우회하지 못하게** 한다.

텔레메트리로 나가는 org 값도 `sanitizeOrgInput`으로 특수값(`DEFAULT_TARGET_ORG`/`DEFAULT_TARGET_DEV_HUB`/`ALLOW_ALL_ORGS`)만 보존하고 나머지는 `SANITIZED_ORG`로 치환한다. 서버는 **사전에 org를 명시적으로 인가(`org login web` 등)** 해야만 접근 가능하다.

---

## 관련 노트
- [[sf-mcp - 개요]] — sf-mcp 서버 전체 개요
- [[mcp-provider-api]]
- [[sf-mcp - 프로바이더 개발 (Example + Test Client)]]
- [[mcp-provider-dx-core]]
- [[mcp-provider-mobile-web]]
- [[mcp-provider-metadata-enrichment]]
