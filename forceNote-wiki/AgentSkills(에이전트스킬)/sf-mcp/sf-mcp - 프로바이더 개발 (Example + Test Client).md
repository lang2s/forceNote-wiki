---
tags: [sf-mcp, mcp, salesforce-dx, provider-development, example, test-client]
source: salesforcecli/mcp (packages/EXAMPLE-MCP-PROVIDER/ + packages/mcp-test-client/, 공식 Salesforce)
created: 2026-06-27
aliases: [EXAMPLE-MCP-PROVIDER, mcp-test-client, 커스텀 MCP 프로바이더 만들기, MCP 테스트 클라이언트]
---

# sf-mcp — 프로바이더 개발 (Example + Test Client)

> 커스텀 MCP provider를 만드는 스캐폴드(`EXAMPLE-MCP-PROVIDER`)와, 만든 툴을 실제 서버로 구동해 검증하는 테스트 클라이언트(`mcp-test-client`). provider는 [[mcp-provider-api]]의 `McpProvider`/`McpTool`을 구현하고, 서버 등록은 `MCP_PROVIDER_REGISTRY`에 인스턴스를 추가하면 된다.

---

## 역할 / 목적

| 패키지 | 역할 |
|---|---|
| `@salesforce/EXAMPLE-MCP-PROVIDER` | 새 provider 작성 출발점인 **참조 스캐폴드** (For Internal Use Only). `McpProvider`·`McpTool` 구현 예시. |
| `@salesforce/mcp-test-client` | 테스트 시나리오 전용 **타입 안전 MCP 클라이언트**. Zod 스키마로 툴 인자를 정의하고, 내장 assertion 없이 어떤 테스트 러너(Jest/Vitest/Mocha)와도 동작. DX MCP 서버용 `DxMcpTransport` 헬퍼 포함. |

> provider/툴의 추상 클래스·`Services`·`Toolset`·`ReleaseState` 계약 정의는 [[mcp-provider-api]] 참조. 서버가 provider를 로드·게이팅하는 흐름은 [[mcp]] 참조.

---

## 커스텀 provider 구현 단계 (EXAMPLE-MCP-PROVIDER)

### 1. 패키지 export (`src/index.ts`)

탑레벨에서 provider를 export 한다. 보통 provider 하나만 내보내면 된다.

```ts
// src/index.ts (verbatim)
export { ExampleMcpProvider } from "./provider.js";
```

### 2. `McpProvider` 구현 (`src/provider.ts`)

`getName()`과 `provideTools(services)`를 구현한다. `provideTools`는 등록할 `McpTool` 인스턴스 배열을 Promise로 반환한다. `services`에서 `getTelemetryService()` 등 의존성을 받아 툴에 주입한다.

```ts
// src/provider.ts (verbatim)
import { McpProvider, McpTool, Services } from "@salesforce/mcp-provider-api";
import { ExampleMcpTool } from "./tools/example_tool.js";

export class ExampleMcpProvider extends McpProvider {
  // Must return a name for your McpProvider. It is recommended to make this match the class name
  public getName(): string {
    return "ExampleMcpProvider";
  }

  // Must return a promise containing an array of the McpTool instances that you want to register
  public provideTools(services: Services): Promise<McpTool[]> {
    return Promise.resolve([
      new ExampleMcpTool(services.getTelemetryService()),
    ]);
  }

  // This ExampleMcpProvider does not implement provideResources or providePrompts since the
  // main MCP server doesn't consume them yet.
}
```

> `provideResources`/`providePrompts`는 메인 서버가 아직 consume 하지 않으므로 예시에서 미구현.

### 3. `McpTool` 구현 (`src/tools/example_tool.ts`)

툴은 Zod input 스키마, release state, toolset, 이름, config, 그리고 실행 콜백 `exec`를 정의한다. 의존성(텔레메트리 등)은 생성자로 주입하면 단위 테스트가 쉽다.

```ts
// src/tools/example_tool.ts (verbatim)
const exampleInputSchema = z.object({
  someInput: z.string().describe("an input argument to be used for example purposes"),
});
type InputArgs = z.infer<typeof exampleInputSchema>;
type InputArgsShape = typeof exampleInputSchema.shape;
type OutputArgsShape = z.ZodRawShape;

export class ExampleMcpTool extends McpTool<InputArgsShape, OutputArgsShape> {
  private readonly telemetryService: TelemetryService;

  public constructor(telemetryService: TelemetryService) {
    super();
    this.telemetryService = telemetryService;
  }

  public getReleaseState(): ReleaseState {
    return ReleaseState.NON_GA;
  }

  // Must return which toolsets your tool should belong to
  public getToolsets(): Toolset[] {
    return [Toolset.OTHER];
  }

  public getName(): string {
    return "example_tool";
  }

  public getConfig(): McpToolConfig<InputArgsShape, OutputArgsShape> {
    return {
      title: "Example Tool",
      description: "Example Description",
      inputSchema: exampleInputSchema.shape,
      outputSchema: undefined,
      annotations: {
        readOnlyHint: true,
      },
    };
  }

  public exec(input: InputArgs): CallToolResult {
    this.telemetryService.sendEvent("sampleEvent", {
      someAttribute: "someAttributeValue",
    });
    const result: CallToolResult = {
      content: [
        { type: "text", text: "The input that was received: " + JSON.stringify(input) },
      ],
    };
    return result;
  }
}
```

구현 메서드 요약:

| 메서드 | 반환 | 의미 |
|---|---|---|
| `getReleaseState()` | `ReleaseState` | `GA` / `NON_GA`. NON_GA는 서버의 `--allow-non-ga-tools` 없이는 등록되지 않음. |
| `getToolsets()` | `Toolset[]` | 이 툴이 속할 toolset(예: `Toolset.OTHER`). |
| `getName()` | `string` | 툴 이름(MCP에 노출되는 식별자, 예: `example_tool`). |
| `getConfig()` | `McpToolConfig` | `title`/`description`/`inputSchema`/`outputSchema`/`annotations`(예: `readOnlyHint`). |
| `exec(input)` | `CallToolResult` (또는 Promise) | 입력을 받아 결과를 반환하는 콜백. async 시그니처도 가능. |

### 4. 서버에 등록

만든 provider 인스턴스를 서버의 `src/registry.ts` 내 `MCP_PROVIDER_REGISTRY` 배열에 추가하면, 서버가 시작 시 `provideTools(services)`를 호출해 툴을 수집한다(`// Add new instances here` 위치). 등록·게이팅 흐름은 [[mcp]] 참조.

> `package.json` 의존성: `@modelcontextprotocol/sdk`, `@salesforce/mcp-provider-api`(`^0.6.0`), `zod`. 빌드/테스트는 `tsc` + `vitest`.

---

## 테스트 클라이언트 (mcp-test-client)

### `McpTestClient`

`connect(transport)` → `callTool(schema, request)` → `disconnect()` 흐름. `callTool`은 `ToolSchema`(Zod)로 요청을 검증하고 `CallToolResult`를 파싱해 돌려준다. assertion은 호출 측 테스트 프레임워크에 맡긴다.

| 멤버 | 시그니처 | 설명 |
|---|---|---|
| `constructor(options?)` | `{ timeout?: number }` | 기본 timeout 30000ms. |
| `connect(transport)` | `Promise<void>` | `initialize` 핸드셰이크 + `notifications/initialized` 전송. 프로토콜 버전 미지원 시 throw. |
| `callTool(toolSchema, request, timeout?)` | `Promise<CallToolResult>` | `tools/call` 요청. `name`/`params`를 Zod로 parse 후 전송. |
| `disconnect()` | `Promise<void>` | pending 요청 reject + transport close. |
| `connected` (getter) | `boolean` | 연결 상태. |

`ToolSchema`는 `name`(`z.ZodLiteral` 또는 `z.ZodString`)과 `params`(`z.ZodSchema`)로 구성된다.

### `DxMcpTransport` (헬퍼)

DX MCP 서버를 stdio로 띄우는 `StdioClientTransport` 래퍼. command 결정 순서: ① 인자로 넘긴 `command` → ② `SF_MCP_SERVER_BIN` 환경변수 → ③ `$PATH`의 `sf-mcp-server`.

```ts
// src/transport.ts (verbatim 발췌)
const command = options.command ?? process.env.SF_MCP_SERVER_BIN ?? 'sf-mcp-server'
const args = options.args ?? ['--toolsets', 'all','--orgs', options.orgUsername ?? 'DEFAULT_TARGET_ORG', '--no-telemetry'];

// Throw if '--no-telemetry' is not present in args
if (!args.includes('--no-telemetry')) {
  throw new Error("'--no-telemetry' must be included in args.");
}
```

- **`--no-telemetry` 필수** — 테스트 실행이 텔레메트리로 잡히지 않도록 args에 없으면 throw.
- 기본 args는 `--toolsets all --orgs <orgUsername|DEFAULT_TARGET_ORG> --no-telemetry`.
- transport는 `env: { SF_USE_GENERIC_UNIX_KEYCHAIN: 'true' }`를 설정 — testkit이 home dir를 바꿔 auth를 테스트 디렉터리에 두므로 OS keychain 조회 실패(keychain error/silent failure)를 피하기 위함.

### 보조 유틸 / 에러

- **`TestSetup`** (`src/utils.ts`) — `onCleanup(fn)`으로 정리 함수를 등록하고 `cleanup()`에서 역순 실행 후 클라이언트를 disconnect. 누적 에러를 모아 throw.
- **에러 클래스** (`src/errors.ts`) — `McpTestClientError`(베이스, `cause?`), 파생: `ConnectionError`, `TimeoutError`, `ToolCallError`(`toolName?`), `ValidationError`(`validationErrors?`).

### E2E 예시 (README — TestKit + chai)

```typescript
import { McpTestClient, DxMcpTransport } from '@salesforce/mcp-test-client';
import { execCmd, TestSession } from '@salesforce/cli-plugins-testkit';
import { z } from 'zod';
import { ensureString } from '@salesforce/ts-types';

describe('Salesforce Tool E2E Test', () => {
  const client = new McpTestClient({ timeout: 300_000 }); // 5 minutes
  let testSession: TestSession;
  let orgUsername: string;

  const toolSchema = {
    name: z.literal('sf-deploy-metadata'),
    params: z.object({ usernameOrAlias: z.string(), directory: z.string() })
  };

  before(async () => {
    testSession = await TestSession.create({
      project: { gitClone: 'https://github.com/trailheadapps/dreamhouse-lwc' },
      scratchOrgs: [{ setDefault: true, config: path.join('config', 'project-scratch-def.json') }],
      devhubAuthStrategy: 'AUTO',
    });
    orgUsername = [...testSession.orgs.keys()][0];
    const transport = DxMcpTransport({ orgUsername: ensureString(orgUsername) });
    await client.connect(transport);
  });

  it('should deploy metadata', async () => {
    const result = await client.callTool(toolSchema, {
      name: 'sf-deploy-metadata',
      params: { usernameOrAlias: orgUsername, directory: testSession.project.dir }
    });
    expect(result.isError).to.equal(false);
    expect(result.content[0].text).to.contain('Deploy result:');
  });
});
```

> 설치: `@salesforce/mcp-test-client`를 tool provider 패키지의 **dev dependency**로 추가. 모노레포 내부에서는 `sf-mcp-server` bin이 `$PATH`에 있고 `packages/mcp/bin/run.js`를 가리킨다.

---

## 관련 노트
- [[sf-mcp - 개요]] — sf-mcp 서버 전체 개요
- [[mcp-provider-api]]
- [[mcp]]
