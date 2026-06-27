---
tags: [sf-mcp, mcp, salesforce-dx, dx-core, tools, orgs, metadata]
source: salesforcecli/mcp (packages/mcp-provider-dx-core/, 공식 Salesforce)
created: 2026-06-27
aliases: [mcp-provider-dx-core, DX 코어 MCP 도구, deploy_metadata, run_soql_query, create_scratch_org, org 관리 도구]
---

# mcp-provider-dx-core — DX 코어 도구

> Salesforce DX MCP Server의 핵심 도구 패키지. org 관리(생성·삭제·열기·목록·스냅샷), 메타데이터 deploy/retrieve, SOQL 쿼리, 권한 집합 할당, Apex/Agent 테스트, 장기 작업 재개를 MCP 도구로 노출한다.

---

## 역할

`mcp-provider-dx-core`는 `DxCoreMcpProvider` 클래스 하나를 export한다. 이 provider는 `@salesforce/mcp-provider-api`의 `McpProvider`를 상속하며, `provideTools(services)`에서 13개의 `McpTool` 인스턴스를 반환한다. 각 도구는 `@salesforce/core`·`@salesforce/source-deploy-retrieve`·`@salesforce/source-tracking`·`@salesforce/apex-node`·`@salesforce/agents` 등 DX 라이브러리를 직접 호출해 실제 org 작업을 수행한다.

> provider/도구가 `McpTool` 베이스 클래스, `Services`, `Toolset`, `ReleaseState` 같은 공통 추상을 어떻게 상속·구현하는지는 [[mcp-provider-api]] 참조. 이 노트는 dx-core가 *무엇을 제공하는지*만 다룬다.

```ts
// 발췌 — src/index.ts
export class DxCoreMcpProvider extends McpProvider {
  public getName(): string {
    return 'DxCoreMcpProvider';
  }

  public provideTools(services: Services): Promise<McpTool[]> {
    return Promise.resolve([
      new AssignPermissionSetMcpTool(services),
      new CreateOrgSnapshotMcpTool(services),
      new CreateScratchOrgMcpTool(services),
      new DeleteOrgMcpTool(services),
      new DeployMetadataMcpTool(services),
      new GetUsernameMcpTool(services),
      new ListAllOrgsMcpTool(services),
      new OrgOpenMcpTool(services),
      new QueryOrgMcpTool(services),
      new ResumeMcpTool(services),
      new RetrieveMetadataMcpTool(services),
      new TestAgentsMcpTool(services),
      new TestApexMcpTool(services),
    ]);
  }
}
```

각 도구 클래스는 `getName()`(MCP 도구 이름), `getReleaseState()`(GA / NON_GA), `getToolsets()`(분류), `getConfig()`(title·description·inputSchema), `exec(input)`(실행)을 구현한다.

### 도구 한눈에 보기

| 도구 이름 | 클래스 | Toolset | ReleaseState |
|---|---|---|---|
| `get_username` | GetUsernameMcpTool | CORE | GA |
| `resume_tool_operation` | ResumeMcpTool | CORE | GA |
| `list_all_orgs` | ListAllOrgsMcpTool | ORGS | GA |
| `open_org` | OrgOpenMcpTool | ORGS | NON_GA |
| `create_scratch_org` | CreateScratchOrgMcpTool | ORGS | NON_GA |
| `delete_org` | DeleteOrgMcpTool | ORGS | NON_GA |
| `create_org_snapshot` | CreateOrgSnapshotMcpTool | ORGS | NON_GA |
| `deploy_metadata` | DeployMetadataMcpTool | METADATA | GA |
| `retrieve_metadata` | RetrieveMetadataMcpTool | METADATA | GA |
| `run_soql_query` | QueryOrgMcpTool | DATA | GA |
| `assign_permission_set` | AssignPermissionSetMcpTool | USERS | GA |
| `run_apex_test` | TestApexMcpTool | TESTING | GA |
| `run_agent_test` | TestAgentsMcpTool | TESTING | GA |

> 참고: 작업 의뢰서는 11개 도구를 지정했으나, `src/index.ts`가 실제로 등록하는 도구는 13개다(`run_apex_test`, `run_agent_test` 포함). 전수 커버리지 원칙에 따라 13개 모두 문서화한다.

---

## 제공 도구 (tools)

각 항목의 입력 스키마는 `src/tools/*.ts`의 zod 객체에서 그대로 옮겼다. 다수 도구가 공유하는 `usernameOrAlias`·`directory` 파라미터는 [공통 (shared/)](#공통-shared) 참조.

### get_username (`get_username`)

- **클래스:** `GetUsernameMcpTool` · **Toolset:** `CORE` · **ReleaseState:** `GA`
- **title:** `Get Username`
- **description:** "Intelligently determines the appropriate username or alias for Salesforce operations." — 어떤 org를 쓸지 불확실할 때 사용. `defaultTargetOrg=true & defaultDevHub=false`면 기본 target org를, 반대면 기본 devhub를 해석한다. 둘 다 false면 allow-list된 org 중 하나를 제안한다.
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `defaultTargetOrg` | `z.boolean().optional().default(false)` | Resolve the default target org username |
| `defaultDevHub` | `z.boolean().optional().default(false)` | Resolve the default target devhub org username |
| `directory` | `directoryParam` | 실행 디렉터리 |

- **동작:** `orgService`로 `getDefaultTargetOrg()` / `getDefaultTargetDevHub()` / `getAllowedOrgs()`를 조회. `suggestUsername()` 헬퍼가 ① allow-list org가 1개면 그것, ② 기본 target org, ③ 기본 dev hub 순으로 username을 추론하고 reasoning 문자열을 함께 반환. 다른 도구들은 username이 불명확할 때 `#get_username`을 먼저 호출하도록 안내받는다.

### resume_tool_operation (`resume_tool_operation`)

- **클래스:** `ResumeMcpTool` · **Toolset:** `CORE` · **ReleaseState:** `GA`
- **title:** `Resume`
- **description:** "Resume a long running operation that was not completed by another tool." (예: deploy 0Af..., scratch org 2SR..., agent test 4KB..., org snapshot 0Oo...)
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `jobId` | `z.string()` | The job id of the long running operation to resume (required) |
| `wait` | `z.number().optional().default(30)` | The amount of time to wait for the operation to complete in minutes (optional) |
| `usernameOrAlias` | `usernameOrAliasParam` | 대상 org |
| `directory` | `directoryParam` | 실행 디렉터리 |

- **동작:** `validateSalesforceId`로 jobId 검증 후, jobId 앞 3글자 prefix로 작업 종류를 분기한다. prefix 맵:

```ts
// 발췌 — src/tools/resume_tool_operation.ts
const resumableIdPrefixes = new Map<string, string>([
  ['deploy', '0Af'],
  ['scratchOrg', '2SR'],
  ['agentTest', '4KB'],
  ['orgSnapshot', '0Oo'],
]);
```

  - `0Af` → `resumeDeployment`: `MetadataApiDeploy.pollStatus`
  - `2SR` → `resumeScratchOrg`: `scratchOrgResume`
  - `4KB` → `resumeAgentTest`: `AgentTester.poll`
  - `0Oo` → `resumeOrgSnapshot`: `OrgSnapshot` 레코드를 `PollingClient`로 30초 간격 폴링(Status가 `In Progress`가 아니면 완료)
  - 그 외 prefix → "is not resumeable" 에러.

### list_all_orgs (`list_all_orgs`)

- **클래스:** `ListAllOrgsMcpTool` · **Toolset:** `ORGS` · **ReleaseState:** `GA`
- **title:** `List All Orgs`
- **description:** "Lists all configured Salesforce orgs." 에이전트 지침: 사용자가 명시적으로 org 목록을 요청할 때만 사용하고, 어떤 org를 쓸지 판단하려면 대신 `#get_username`을 쓸 것.
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `directory` | `directoryParam` | 실행 디렉터리 |

- **annotations:** `readOnlyHint: true`, `openWorldHint: false`
- **동작:** `orgService.getAllowedOrgs()` 결과를 JSON으로 반환.

### open_org (`open_org`)

- **클래스:** `OrgOpenMcpTool` · **Toolset:** `ORGS` · **ReleaseState:** `NON_GA`
- **title:** `Open Org in Browser`
- **description:** "Open a Salesforce org in the browser. You can specify a metadata file you want to open."
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `filePath` | `z.string().optional()` | File path of the metadata to open. This should be an existent file path in the project. |
| `usernameOrAlias` | `usernameOrAliasParam` | 대상 org |
| `directory` | `directoryParam` | 실행 디렉터리 |

- **annotations:** `readOnlyHint: true`, `openWorldHint: false`
- **동작:** `filePath`가 있으면 `MetadataResolver`로 컴포넌트 타입을 찾아 `org.getMetadataUIURL(typeName, filePath)`를 연다(빌더 UI가 없으면 Lightning App Builder로 대체 — URL에 `FlexiPageList` 포함 시 안내). `filePath`가 없으면 `org.getFrontDoorUrl()`을 연다. 브라우저 오픈은 `open` 패키지 사용.

### create_scratch_org (`create_scratch_org`)

- **클래스:** `CreateScratchOrgMcpTool` · **Toolset:** `ORGS` · **ReleaseState:** `NON_GA`
- **title:** `Create a scratch org`
- **description:** "Creates a scratch org with the specified parameters."
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `directory` | `directoryParam` | 실행 디렉터리 |
| `devHub` | `usernameOrAliasParam.describe(...)` | The default devhub username, use the #get_username tool to get the default devhub if unsure |
| `duration` | `z.number().default(7)` | number of days before the org expires |
| `edition` | `z.enum([...]).optional()` | 아래 enum 값 참조 |
| `definitionFile` | `z.string().default(join('config','project-scratch-def.json'))` | a normalized path to a scratch definition json file |
| `alias` | `z.string().optional()` | the alias to be used for the scratch org |
| `async` | `z.boolean().default(false)` | Whether to wait for the org creation process to finish (false) or just quickly return the ID (true) |
| `setDefault` | `z.boolean().optional()` | If true, will set the newly created scratch org to be the default-target-org |
| `snapshot` | `z.string().optional()` | The snapshot name to use when creating a scratch org |
| `sourceOrg` | `z.string().length(15).optional()` | 15-character ID of the org shape that the new scratch org is based on |
| `username` | `z.string().optional()` | Username of the scratch org admin user |
| `description` | `z.string().optional()` | a description given to the scratch org |
| `orgName` | `z.string().optional()` | Name of the scratch org |
| `adminEmail` | `z.string().optional()` | Email address that will be applied to the org's admin user. |

- **`edition` enum (전수):** `developer`, `enterprise`, `group`, `professional`, `partner-developer`, `partner-enterprise`, `partner-group`, `partner-professional`
- **동작:** allow-list에 devHub가 있는지 확인 후 `scratchOrgCreate()` 호출. `async=true`면 `wait`를 `Duration.minutes(0)`으로 두고 job Id를 반환(이후 `#resume_tool_operation`으로 재개), `false`면 `Duration.minutes(10)` 대기 후 username 반환. `tracksSource: true`. definitionFile JSON에 edition·snapshot·username·description·orgName·sourceOrg·adminEmail을 병합.

### delete_org (`delete_org`)

- **클래스:** `DeleteOrgMcpTool` · **Toolset:** `ORGS` · **ReleaseState:** `NON_GA`
- **title:** `Delete an Org`
- **description:** "Deletes specified salesforce org." 에이전트 지침: org 삭제 전 항상 사용자에게 확인.
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `directory` | `directoryParam` | 실행 디렉터리 |
| `usernameOrAlias` | `usernameOrAliasParam` | 삭제할 org |

- **동작:** `Org.create({connection}).delete()`. 만료된 org라 원격 호출이 실패(`DomainNotFoundError`)하면 `AuthRemover`로 로컬 인증 파일만 정리한다.

### create_org_snapshot (`create_org_snapshot`)

- **클래스:** `CreateOrgSnapshotMcpTool` · **Toolset:** `ORGS` · **ReleaseState:** `NON_GA`
- **title:** `Create a new snapshot`
- **description:** "Creates a new snapshot of an org" (예: "Create a snapshot called 07042025", "create a snapshot of my MyScratch in myDevHub")
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `directory` | `directoryParam` | 실행 디렉터리 |
| `devHub` | `usernameOrAliasParam.describe(...)` | The default devhub username, use the #get_username tool to get the default devhub if unsure |
| `sourceOrg` | `usernameOrAliasParam.describe(...)` | The org username or alias to create a snapshot of, use the #get_username tool to get the default target org if unsure |
| `description` | `z.string().optional()` | Description of snapshot. |
| `name` | `z.string().max(15).default(Date.now().toString().substring(0, 15))` | Unique name of snapshot (최대 15자, 기본값은 현재 timestamp 앞 15자리) |

- **동작:** sourceOrg의 OrgId를 구해 devHub connection에서 `OrgSnapshot` sobject를 `create`(`Content: 'metadatadata'`). 생성 후 `singleRecordQuery`로 Id·SnapshotName·Status·ExpirationDate 등을 조회해 반환. devHub에 스냅샷 기능이 꺼져 있으면(`NOT_FOUND`) "Scratch Org Snapshots isn't enabled for your Dev Hub." 반환.

### deploy_metadata (`deploy_metadata`)

- **클래스:** `DeployMetadataMcpTool` · **Toolset:** `METADATA` · **ReleaseState:** `GA`
- **title:** `Deploy Metadata`
- **description:** "Deploy metadata to an org from your local project." 모호하면(`deploy my changes`) sourceDir·manifest·ignoreConflicts를 비워 두 도구가 변경 파일을 계산하게 한다.
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `ignoreConflicts` | `z.boolean().optional()` | Ignore conflicts and deploy local files, even if they overwrite changes in the org. |
| `sourceDir` | `z.array(z.string()).optional()` | Path to the local source files to deploy. Leave this unset if the user is vague about what to deploy. |
| `manifest` | `z.string().optional()` | Full file path for manifest (XML file) of components to deploy. |
| `apexTestLevel` | `z.enum(['NoTestRun','RunLocalTests','RunAllTestsInOrg']).optional()` | 배포 시 Apex 테스트 레벨. `RunSpecifiedTests`는 의도적으로 제외(apexTests가 넘어오면 도구가 자동 설정). |
| `apexTests` | `z.array(z.string()).optional()` | Apex tests classes to run. |
| `usernameOrAlias` | `usernameOrAliasParam` | 대상 org |
| `directory` | `directoryParam` | 로컬 프로젝트 디렉터리 |

- **annotations:** `destructiveHint: true`, `openWorldHint: false`
- **검증:** `apexTests`와 `apexTestLevel` 동시 지정 불가, `sourceDir`와 `manifest` 동시 지정 불가.
- **동작:** `SourceTracking`으로 컴포넌트 셋을 만든다. sourceDir/manifest가 없고 source-tracking 미지원이면 파일/매니페스트 지정을 요구. 변경이 없으면 "No local changes to deploy were found." `componentSet.deploy()` 후 10분 폴링. 타임아웃 시 `jobId`와 함께 `#resume_tool_operation`으로 재개하라고 안내. `apexTests` 지정 시 `testLevel: 'RunSpecifiedTests'` + `runTests`로 설정.

### retrieve_metadata (`retrieve_metadata`)

- **클래스:** `RetrieveMetadataMcpTool` · **Toolset:** `METADATA` · **ReleaseState:** `GA`
- **title:** `Retrieve Metadata`
- **description:** "Retrieve metadata from an org to your local project." 모호하면 sourceDir·manifest·ignoreConflicts를 비워 둔다.
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `ignoreConflicts` | `z.boolean().optional().default(false)` | Ignore conflicts and retrieve and save files to your local filesystem, even if they overwrite your local changes. |
| `sourceDir` | `z.array(z.string()).optional()` | Path to the local source files to retrieve. Leave this unset if the user is vague about what to retrieve. |
| `manifest` | `z.string().optional()` | Full file path for manifest (XML file) of components to retrieve. |
| `usernameOrAlias` | `usernameOrAliasParam` | 대상 org |
| `directory` | `directoryParam` | 로컬 프로젝트 디렉터리 |

- **annotations:** `openWorldHint: false`, `destructiveHint: true`
- **검증:** `sourceDir`와 `manifest` 동시 지정 불가.
- **동작:** `SourceTracking` 기반 컴포넌트 셋을 만들어 `componentSet.retrieve({ merge: true, format: 'source', output: 기본 패키지 경로 })`. 10분 폴링. 변경 없으면 "No remote changes to retrieve were found." 결과에서 `zipFile`은 제외하고 반환.

### run_soql_query (`run_soql_query`)

- **클래스:** `QueryOrgMcpTool` · **Toolset:** `DATA` · **ReleaseState:** `GA`
- **title:** `Query Org`
- **description:** "Run a SOQL query against a Salesforce org."
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `query` | `z.string()` | SOQL query to run |
| `usernameOrAlias` | `usernameOrAliasParam` | 대상 org |
| `directory` | `directoryParam` | 실행 디렉터리 |
| `useToolingApi` | `useToolingApiParam` (`z.boolean().optional()`) | Use Tooling API for the operation |

- **annotations:** `openWorldHint: false`, `readOnlyHint: true`
- **동작:** `useToolingApi`면 `connection.tooling.query`, 아니면 `connection.query`. 에러 메시지가 "is not supported."로 끝나면 Tooling API 사용/미사용을 바꿔 보라고 힌트 추가.

### assign_permission_set (`assign_permission_set`)

- **클래스:** `AssignPermissionSetMcpTool` · **Toolset:** `USERS` · **ReleaseState:** `GA`
- **title:** `Assign Permission Set`
- **description:** "Assign a permission set to one or more org users."
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `permissionSetName` | `z.string()` | A single permission set to assign |
| `usernameOrAlias` | `usernameOrAliasParam` | 대상 org |
| `onBehalfOf` | `z.string().optional()` | A single username or alias (other than the usernameOrAlias) to assign the permission set to. 사용자가 명시적으로 "on behalf of"라고 할 때만 채워짐. |
| `directory` | `directoryParam` | 실행 디렉터리 |

- **annotations:** `openWorldHint: true`
- **동작:** `StateAggregator`로 alias를 최신 상태로 갱신(`clearInstanceAsync`)한 뒤 `onBehalfOf || usernameOrAlias`를 username으로 resolve. `validateAndEscapeUsername`로 SOQL 인젝션 방지 후 `SELECT Id FROM User WHERE Username='...'`로 User Id를 찾아 `user.assignPermissionSets(Id, [permissionSetName])` 실행.

### run_apex_test (`run_apex_test`)

- **클래스:** `TestApexMcpTool` · **Toolset:** `TESTING` · **ReleaseState:** `GA`
- **title:** `Apex Tests`
- **description:** "Run Apex tests in an org." Apex 테스트만 실행하며 agent/lightning/flow 테스트는 실행하지 않는다. `classes` 디렉터리 파일이 언급될 때 선택.
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `testLevel` | `z.enum([TestLevel.RunLocalTests, TestLevel.RunAllTestsInOrg, TestLevel.RunSpecifiedTests])` | Apex test level |
| `classNames` | `z.array(z.string()).optional()` | Apex tests classes to run. (RunSpecifiedTests일 때) |
| `methodNames` | `z.array(z.string()).optional()` | Specific test method names, functions inside of an apex test class, must be joined with the Apex tests name |
| `async` | `z.boolean().default(false)` | wait for the test to finish (false) or enqueue and return the test run id (true) |
| `suiteName` | `z.string().optional()` | a suite of apex test classes to run |
| `testRunId` | `z.string().default('an id of an in-progress, or completed apex test run').optional()` | 기존 테스트 실행의 결과 조회용 id |
| `verbose` | `z.boolean().default(false)` | If a user wants more test information in the context, or information about passing tests |
| `codeCoverage` | `z.boolean().default(false)` | set to true if a user wants codecoverage calculated by the server |
| `usernameOrAlias` | `usernameOrAliasParam` | 대상 org |
| `directory` | `directoryParam` | 로컬 프로젝트 디렉터리 |

- **검증:** suiteName/methodNames/classNames 중 하나라도 지정했는데 `testLevel`이 `RunSpecifiedTests`가 아니면 에러.
- **동작:** `testRunId`가 있으면 `testService.reportAsyncResults(testRunId, codeCoverage)`. 없으면 `buildAsyncPayload` → `runTestAsynchronous`(10분). `async=true`면 test run id 반환. `verbose=false`면 통과한 테스트를 필터링하고 실패(`Fail`)만 남긴다.

### run_agent_test (`run_agent_test`)

- **클래스:** `TestAgentsMcpTool` · **Toolset:** `TESTING` · **ReleaseState:** `GA`
- **title:** `Run Agent Tests`
- **description:** "Run Agent tests in an org." Agent 테스트만 실행. `aiEvaluationDefinitions` 디렉터리 파일이 언급될 때 선택. 한 번에 하나의 테스트만 실행 가능.
- **입력 스키마:**

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `agentApiName` | `z.string()` | Agent test to run (aiEvaluationDefinition의 name). 모르면 `**/aiEvaluationDefinitions/*.aiEvaluationDefinition-meta.xml` 패턴으로 목록화. |
| `usernameOrAlias` | `usernameOrAliasParam` | 대상 org |
| `directory` | `directoryParam` | 로컬 프로젝트 디렉터리 |
| `async` | `z.boolean().default(false)` | wait for the tests to finish (false) or quickly return only the test id (true) |

- **annotations:** `openWorldHint: false`
- **동작:** `AgentTester(connection)`. `async=true`면 `start()` 결과만 반환, `false`면 `start()` 후 `poll(runId, {timeout: 10분})`로 결과까지 대기.

---

## 공통 (shared/)

### params.ts — 재사용 파라미터

| export | 정의 | 설명 |
|---|---|---|
| `usernameOrAliasParam` | `z.string().describe(...)` | 도구를 실행할 org의 username(`name@domain.com`) 또는 alias. 불명확하면 `#get_username`으로 해석하고, 절대 추측하지 말라는 지침 포함. |
| `useToolingApiParam` | `z.boolean().optional()` | "Use Tooling API for the operation" |
| `baseAbsolutePathParam` | `z.string().refine(sanitizePath, ...)` | 절대경로이며 경로 탐색(`..`) 시퀀스가 없어야 함 |
| `directoryParam` | `baseAbsolutePathParam.describe(...)` | 도구를 실행할 디렉터리. 항상 전체 경로를 쓰고, 사용자가 다른 디렉터리를 요구하지 않는 한 후속 호출에서도 같은 디렉터리를 재사용. |

`index.ts`는 `usernameOrAliasParam`, `directoryParam`을 패키지 밖으로 재-export한다.

### utils.ts

- `textResponse(text, isError = false): ToolTextResponse` — 모든 도구가 결과를 감싸는 헬퍼. `text`가 빈 문자열이면 throw. `{ isError, content: [{ type: 'text', text }] }` 형태 반환.
- `sanitizePath(projectPath): boolean` — URL 디코딩 + Unicode 정규화 후, `..`·유니코드 생략부호(`‥`/`…`)를 차단하고 절대경로인지 검사(Windows 드라이브-상대 경로, 즉 역슬래시로 시작하는 경로 제외).

### soqlUtils.ts — SOQL 인젝션 방지

`assign_permission_set`가 사용한다.

- `escapeSoqlString(value)` — 작은따옴표를 이스케이프(`'` → `\'`).
- `containsSqlInjectionPatterns(value)` — `--`, `;`, `OR`/`AND`/`UNION`/`SELECT`/`DROP`/`INSERT`/`UPDATE`/`DELETE`/`EXEC` 키워드 패턴 탐지.
- `isValidUsername(username)` — `@` 포함 + 이메일 형식 + 인젝션 패턴 없음 검사.
- `validateAndEscapeUsername(username)` — 위 검증을 통과하면 이스케이프된 username 반환, 아니면 throw.

### types.ts

```ts
// 발췌 — src/shared/types.ts
export type ToolTextResponse = {
  isError: boolean;
  content: Array<{
    type: 'text';
    text: string;
  }>;
};
```

---

## 관련 노트

- [[sf-mcp - 개요]] — sf-mcp 서버 전체 개요
- [[mcp-provider-api]]
