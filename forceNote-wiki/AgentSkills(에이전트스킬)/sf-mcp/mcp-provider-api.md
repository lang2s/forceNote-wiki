---
tags: [sf-mcp, mcp, salesforce-dx, provider-api, sdk]
source: salesforcecli/mcp (packages/mcp-provider-api/, 공식 Salesforce)
created: 2026-06-27
aliases: [mcp-provider-api, McpProvider, McpTool, MCP 프로바이더 SDK, MCP 툴 정의]
---

# mcp-provider-api — MCP 프로바이더 SDK

> Salesforce DX MCP Server의 SDK 패키지. `McpProvider`·`McpTool`·`McpResource`·`McpPrompt` 추상 클래스와 `Services` 인터페이스, `Toolset`/`ReleaseState` 열거형을 정의한다 — 다른 모든 `mcp-provider-*` 패키지가 이 계약을 구현(implement)한다.

---

## 역할

`@salesforce/mcp-provider-api`는 MCP Server에 prompts·resources·tools를 등록(register)하기 위한 **provider 계약(contract) 정의 패키지**다. 자체 동작 로직은 거의 없고 추상 클래스/인터페이스/타입만 export 한다.

- 패키지명: `@salesforce/mcp-provider-api`
- 버전: `0.6.0` (package.json), `MCP_PROVIDER_API_VERSION` 상수로도 노출
- 설명(공식): "(For Internal Use Only) API to implement a McpProvider that provides prompts, resources, and tools to be registered by an MCP server"
- README 명시: **내부 사용 전용**. 버전 간 호환성 보장 없이 내용이 변경될 수 있음.
- 주요 의존성: `@modelcontextprotocol/sdk` (^1.18.0), `@salesforce/core` (^8.29.0), `@salesforce/ts-types` (^2), `zod` (^3.25.76), `semver` (^7.7.2)
- 구현 패키지: `mcp-provider-dx-core`, `mcp-provider-code-analyzer`, `mcp-provider-devops`, `mcp-provider-metadata-enrichment`, `mcp-provider-mobile-web`, `mcp-provider-scale-products` 등이 이 SDK를 implements 한다.

### `index.ts` 공개 export 전수

```ts
export { McpPrompt, type McpPromptConfig } from './prompts.js';

export { MCP_PROVIDER_API_VERSION, McpProvider, type Versioned } from './provider.js';

export { McpResource, McpResourceTemplate } from './resources.js';

export { McpTool, type McpToolConfig } from './tools.js';

export { ReleaseState, Toolset, TOOLSETS } from './enums.js';

export { type OrgConfigInfo, type SanitizedOrgAuthorization } from './types.js';

export {
  type Services,
  type TelemetryService,
  type TelemetryEvent,
  type OrgService,
  type ConfigService,
  type StartupFlags
} from './services.js';
```

---

## 핵심 추상 클래스/인터페이스

### `McpProvider` (provider.ts)

서버에 등록될 prompts/resources/tools를 공급하는 최상위 진입점. provider 구현체는 이 추상 클래스를 상속한다. `getName()`만 추상이고 나머지 provide* 메서드는 기본적으로 빈 배열을 반환하므로 필요한 것만 override 한다.

```ts
export const MCP_PROVIDER_API_VERSION: SemVer = new SemVer(packageJson.version);

export abstract class McpProvider implements Versioned {
  /**
   * Returns the name given to this provider instance.
   */
  abstract getName(): string;

  /**
   * Provides prompts to be registered with the MCP Server.
   *
   * NOTE - CURRENTLY THE MAIN MCP SERVER DOES NOT CONSUME THIS YET.
   */
  providePrompts(services: Services): Promise<McpPrompt[]> {
    return Promise.resolve([]);
  }

  /**
   * Provides resources to be registered with the MCP Server.
   *
   * NOTE - CURRENTLY THE MAIN MCP SERVER DOES NOT CONSUME THIS YET.
   */
  provideResources(services: Services): Promise<(McpResource | McpResourceTemplate)[]> {
    return Promise.resolve([]);
  }

  /**
   * Provides tools to be registered with the MCP Server.
   * @param services Provides a list of services that are available to tool authors
   * @returns An array of McpTool instances
   */
  provideTools(services: Services): Promise<McpTool[]> {
    return Promise.resolve([]);
  }

  /**
   * This method allows the server to check that this provider is return compatible
   * prompts, resources, and tools to be registered.
   * IMPORTANT: Subclasses should not override this method.
   */
  public getVersion(): SemVer {
    return MCP_PROVIDER_API_VERSION;
  }
}

export interface Versioned {
  getName(): string;
  getVersion(): SemVer;
}
```

주의:
- `providePrompts` / `provideResources`는 코드 주석상 **메인 MCP 서버가 아직 소비하지 않음**(NOTE - CURRENTLY THE MAIN MCP SERVER DOES NOT CONSUME THIS YET). 실제로 등록되는 것은 `provideTools`의 결과다.
- `getVersion()`은 **override 금지** — 서버가 provider의 API 호환 버전을 확인하는 데 쓰인다.

### `McpTool` (tools.ts)

MCP Server에 등록되는 개별 툴의 추상 클래스. `InputArgsShape`·`OutputArgsShape` 두 zod 제네릭을 받는다.

```ts
export abstract class McpTool<
  InputArgsShape extends z.ZodRawShape = z.ZodRawShape,
  OutputArgsShape extends z.ZodRawShape = z.ZodRawShape
> {

  /**
   * Returns the release state of the tool.
   */
  public abstract getReleaseState(): ReleaseState

  /**
   * Returns one or more toolsets that the tool should be associated with
   */
  public abstract getToolsets(): Toolset[];

  /**
   * Returns the name for the MCP Tool
   */
  public abstract getName(): string;

  /**
   * Returns the configuration for the MCP Tool
   */
  public abstract getConfig(): McpToolConfig<InputArgsShape, OutputArgsShape>;

  /**
   * Implements the main callback for the MCP Tool
   */
  public abstract exec(
    ...args: InputArgsShape extends z.ZodRawShape
      ? [
          args: z.objectOutputType<InputArgsShape, z.ZodTypeAny>,
          extra: RequestHandlerExtra<ServerRequest, ServerNotification>
        ]
      : [extra: RequestHandlerExtra<ServerRequest, ServerNotification>]
  ): CallToolResult | Promise<CallToolResult>;
}
```

5개 추상 멤버 전부 구현 필수: `getReleaseState()`, `getToolsets()`, `getName()`, `getConfig()`, `exec()`. `exec`의 반환은 `@modelcontextprotocol/sdk`의 `CallToolResult`(동기 또는 Promise).

### `McpResource` / `McpResourceTemplate` (resources.ts)

두 클래스 모두 `kind` 리터럴 프로퍼티로 구분된다(discriminated union 용). 코드 주석상 **메인 서버가 아직 소비하지 않음**, 향후 `getReleaseState` 추가 검토 중이라고 명시됨.

```ts
export abstract class McpResource {
  kind: 'McpResource' = 'McpResource';

  abstract getName(): string;
  abstract getUri(): string;
  abstract getConfig(): ResourceMetadata;
  abstract read(
    uri: URL,
    extra: RequestHandlerExtra<ServerRequest, ServerNotification>
  ): ReadResourceResult | Promise<ReadResourceResult>;
}

export abstract class McpResourceTemplate {
  kind: 'McpResourceTemplate' = 'McpResourceTemplate';

  abstract getName(): string;
  abstract getTemplate(): ResourceTemplate;
  abstract getConfig(): ResourceMetadata;
  abstract read(
    uri: URL,
    variables: Variables,
    extra: RequestHandlerExtra<ServerRequest, ServerNotification>
  ): ReadResourceResult | Promise<ReadResourceResult>;
}
```

- `McpResource`는 고정 URI(`getUri()`)를, `McpResourceTemplate`은 `ResourceTemplate`(`getTemplate()`)과 `read`에 추가로 `variables: Variables` 인자를 갖는다.
- `ResourceMetadata`·`ResourceTemplate`·`Variables`는 `@modelcontextprotocol/sdk`에서 import.

### `McpPrompt` (prompts.ts)

프롬프트 추상 클래스. `ArgsShape`는 `PromptArgsRawShape`로 제약(문자열 zod 타입만 허용). 역시 **메인 서버가 아직 소비하지 않음**, `getReleaseState` 추가 검토 중 주석 명시.

```ts
export abstract class McpPrompt<ArgsShape extends PromptArgsRawShape = PromptArgsRawShape> {
  abstract getName(): string;

  abstract getConfig(): McpPromptConfig<ArgsShape>;

  abstract prompt(
    ...args: ArgsShape extends PromptArgsRawShape
      ? [
          args: z.objectOutputType<ArgsShape, z.ZodTypeAny>,
          extra: RequestHandlerExtra<ServerRequest, ServerNotification>
        ]
      : [extra: RequestHandlerExtra<ServerRequest, ServerNotification>]
  ): GetPromptResult | Promise<GetPromptResult>;
}
```

---

## 타입·열거형 (types.ts / enums.ts)

### 열거형 (enums.ts) — 전수

```ts
/**
 * The release state for a tool, resource, or prompt.
 */
export enum ReleaseState {
  // General Availability (GA)
  GA = "ga",

  // Non-GA. (Please use this for now, but note it is subject to change)
  // In the future, we may instead introduce BETA, DEV_PREVIEW, etc.
  NON_GA = "non-ga"
}

// Toolset that a tool should live under
export enum Toolset {
  CORE = 'core',
  DATA = 'data',
  ORGS = 'orgs',
  METADATA = 'metadata',
  TESTING = 'testing',
  USERS = 'users',
  MOBILE = 'mobile',
  MOBILE_CORE = 'mobile-core',
  AURA_EXPERTS = 'aura-experts',
  LWC_EXPERTS = 'lwc-experts',
  DEVOPS = 'devops',
  CODE_ANALYSIS = 'code-analysis',
  SCALE_PRODUCTS = 'scale-products',
  ENRICHMENT = 'enrichment',
  EXPERTS_VALIDATION = 'experts-validation',
  OTHER = 'other'
}

// Array of all Toolset names
export const TOOLSETS: Toolset[] = Object.values(Toolset);
```

- `ReleaseState`: 값 2개 — `GA = "ga"`, `NON_GA = "non-ga"`. 향후 BETA/DEV_PREVIEW 등 도입 가능성 주석.
- `Toolset`: 값 16개 — core, data, orgs, metadata, testing, users, mobile, mobile-core, aura-experts, lwc-experts, devops, code-analysis, scale-products, enrichment, experts-validation, other.
- `TOOLSETS`: `Object.values(Toolset)`로 생성한 전체 toolset 배열.

### Config 타입 (tools.ts / prompts.ts)

```ts
export type McpToolConfig<
  InputArgsShape extends z.ZodRawShape = z.ZodRawShape,
  OutputArgsShape extends z.ZodRawShape = z.ZodRawShape
> = {
  title?: string;
  description?: string;
  inputSchema?: InputArgsShape;
  outputSchema?: OutputArgsShape;
  annotations?: ToolAnnotations;
};

export type McpPromptConfig<ArgsShape extends PromptArgsRawShape = PromptArgsRawShape> = {
  title?: string;
  description?: string;
  argsSchema?: ArgsShape;
};

// PromptArgsRawShape가 @modelcontextprotocol/sdk에서 export되지 않아 여기서 직접 정의
export type PromptArgsRawShape = {
  [k: string]: z.ZodType<string, z.ZodTypeDef, string> | z.ZodOptional<z.ZodType<string, z.ZodTypeDef, string>>;
};
```

### 조직 인증 타입 (types.ts)

```ts
export type OrgConfigInfo = {
  key: string;
  location?: ConfigInfo['location'];
  value: string;
  path: string;
};

export type SanitizedOrgAuthorization = {
  aliases?: Nullable<string[]>;
  configs?: Nullable<string[]>;
  username?: string;
  instanceUrl?: string;
  isScratchOrg?: boolean;
  isDevHub?: boolean;
  isSandbox?: boolean;
  orgId?: string;
  oauthMethod?: string;
  isExpired?: boolean | 'unknown';
};
```

- `OrgConfigInfo.location`은 `@salesforce/core`의 `ConfigInfo['location']` 타입.
- `SanitizedOrgAuthorization`은 민감 정보(토큰 등)를 제거한 조직 인증 정보. `isExpired`는 `boolean | 'unknown'` 3-상태.

---

## 서비스·리소스·프롬프트 (services.ts / resources.ts / prompts.ts)

### `Services` 인터페이스 (services.ts)

tool 작성자가 `exec`/`provideTools`에서 사용할 수 있는 서비스 묶음. `Services`는 3개 서비스 접근자(getter)를 제공한다.

```ts
export interface Services {
  getTelemetryService(): TelemetryService;
  getOrgService(): OrgService;
  getConfigService(): ConfigService;
}

export interface TelemetryService {
  sendEvent(eventName: string, event: TelemetryEvent): void;
}

export type TelemetryEvent = {
  [key: string]: string | number | boolean | null | undefined;
};

export interface OrgService {
  getAllowedOrgUsernames(): Promise<Set<string>>;
  getAllowedOrgs(): Promise<SanitizedOrgAuthorization[]>;
  getConnection(username: string): Promise<Connection>;
  getDefaultTargetOrg(): Promise<OrgConfigInfo | undefined>;
  getDefaultTargetDevHub(): Promise<OrgConfigInfo | undefined>;
  findOrgByUsernameOrAlias(
    allOrgs: SanitizedOrgAuthorization[],
    usernameOrAlias: string
  ): SanitizedOrgAuthorization | undefined;
}

export type StartupFlags = {
  'allow-non-ga-tools': boolean | undefined,
  debug: boolean | undefined
}

export interface ConfigService {
  getDataDir(): string;
  getStartupFlags(): StartupFlags;
}
```

서비스별 요약:

| 서비스 | 멤버 | 역할 |
|---|---|---|
| `TelemetryService` | `sendEvent(eventName, event)` | 텔레메트리 이벤트 전송. `event`는 `TelemetryEvent`(문자열 키 → string\|number\|boolean\|null\|undefined) |
| `OrgService` | `getAllowedOrgUsernames`, `getAllowedOrgs`, `getConnection`, `getDefaultTargetOrg`, `getDefaultTargetDevHub`, `findOrgByUsernameOrAlias` | 허용된 org 목록/인증/`@salesforce/core` Connection 획득, 기본 타깃 org·DevHub 조회 |
| `ConfigService` | `getDataDir()`, `getStartupFlags()` | 데이터 디렉터리 경로 및 서버 기동 플래그 |

- `getConnection(username)`은 `@salesforce/core`의 `Connection`을 반환.
- `StartupFlags`: `'allow-non-ga-tools'`(non-GA 툴 허용 여부)와 `debug` 두 플래그. 둘 다 `boolean | undefined`. → `ReleaseState.NON_GA` 툴은 `allow-non-ga-tools`가 켜졌을 때만 노출되는 구조를 시사.

### Resources / Prompts

`McpResource`·`McpResourceTemplate`·`McpPrompt`의 추상 멤버 시그니처는 위 "핵심 추상 클래스/인터페이스" 절 참조. 세 클래스 모두 코드 주석상 **현재 메인 MCP 서버가 소비하지 않는다**(provide 메서드의 기본 빈 배열 반환과 일치). 따라서 현 시점 실질 확장 지점은 `McpTool` + `provideTools`다.

---

## 관련 노트
- [[sf-mcp - 개요]] — sf-mcp 서버 전체 개요
- [[mcp-provider-dx-core]] — 이 SDK를 구현하는 코어 provider 패키지
- [[mcp-provider-code-analyzer]] — 이 SDK를 구현하는 코드 분석 provider 패키지
