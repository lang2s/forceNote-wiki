---
tags: [sf-mcp, mcp, salesforce-dx, devops, tools, devops-center, work-items]
source: salesforcecli/mcp (packages/mcp-provider-devops/, 공식 Salesforce)
created: 2026-06-27
aliases: [mcp-provider-devops, DevOps Center MCP, work item 도구, createPullRequest, promoteWorkItem, 충돌 해결, 파이프라인 MCP]
---

# mcp-provider-devops — DevOps Center 도구

> Salesforce DX MCP Server의 DevOps 프로바이더. DevOps Center의 work item 생성·체크아웃·커밋·승격(promote)·PR 생성·머지 충돌 탐지/해결·배포 실패 진단까지 12개 MCP 도구를 `DevOpsMcpProvider`로 노출한다. 모든 도구는 `Toolset.DEVOPS` 소속, `ReleaseState.GA`.

---

## 역할 (DevOps Center work item / pipeline / PR 워크플로)

이 패키지는 [[mcp-provider-api]]의 `McpProvider` / `McpTool` 계약을 구현해 **DevOps Center(DoCe / DOCe)** 작업을 MCP 도구로 제공한다. 엔트리포인트는 `src/index.ts`가 export하는 `DevOpsMcpProvider` (`src/provider.ts`).

`provideTools(services)`는 12개 도구 인스턴스를 반환한다. 모든 도구가 생성자에서 `Services`를 받아 `services.getOrgService().getConnection(usernameOrAlias)`로 org 커넥션을 얻고, `services.getTelemetryService().sendEvent(...)`로 텔레메트리를 보낸다.

전형적 워크플로(도구 description이 강제하는 순서):

```
list_devops_center_projects   → 프로젝트 선택 (DevOps Center org에서만)
  └ list_devops_center_work_items   → work item 선택
       ├ checkout_devops_center_work_item  → 브랜치 clone/checkout (status New면 In Progress로 전환)
       │    └ commit_devops_center_work_item  → 커밋 + DevOps Center에 SHA 등록 → push 안내
       │         └ check_devops_center_commit_status  → requestId로 커밋 상태 확인
       │              └ create_devops_center_pull_request  → PR 생성 (위 단계 모두 완료 후 최종 단계)
       └ promote_devops_center_work_item  → 승인된 work item을 다음 파이프라인 stage로 승격
충돌/실패 분기:
  detect_devops_center_merge_conflict → resolve_devops_center_merge_conflict
  resolve_devops_center_deployment_failure → (확인 후) promote ... isFullDeploy:true
  update_devops_center_work_item_status → "In Progress" / "Ready to Promote"
```

> 위 트리는 본 위키가 12개 도구 description의 명시적 순서 지시를 재구성한 **흐름 요약**이며 PDF/원본 다이어그램이 아님.

공통 입력 파라미터 `usernameOrAlias`는 `src/shared/params.ts`의 재사용 가능한 zod 스키마(`usernameOrAliasParam`):

```ts
// src/shared/params.ts (발췌)
export const usernameOrAliasParam = z.string()
  .describe(`The username or alias for the Salesforce org to run this tool against.
... NEVER guess or make-up a username or alias.`);
```

여러 도구의 description이 강조하는 공통 규칙:
- **DevOps Center org 한정:** non-DevOps Center / non-Sandbox org에는 사용 금지. org가 안 주어지면 `list_all_orgs`(또는 `sf-list-all-orgs`)로 목록을 보여주고 사용자가 DevOps Center org를 고르게 한 뒤에만 진행.
- **자동 승격 금지:** promote / full promotion / 충돌 해결은 사용자의 명시적 확인 전에 절대 실행하지 않는다.
- **용어:** "DevOps Center", "DOCe", "DoCe"는 동일 제품/org 컨텍스트로 취급.

---

## 제공 도구 (전수 12개)

`src/tools/`의 12개 도구. 각 항목 = MCP 이름(`getName()`) / 클래스 / `getConfig().title` / inputSchema / 동작. 전부 `getReleaseState() = GA`, `getToolsets() = [Toolset.DEVOPS]`.

### 1. `list_devops_center_projects` — SfDevopsListProjects ("List DevOps Projects")
지정한 org의 DevOps Center 프로젝트 전체를 나열.
- **inputSchema:** `usernameOrAlias`
- **동작:** `SELECT Id, Name, Description FROM DevopsProject` SOQL 실행 → 레코드 배열을 JSON으로 반환. 텔레메트리 `devops_list_projects`(projectCount 포함).
- **MANDATORY:** 사용 전 선택 org가 DevOps Center org인지 확인. 아니면 사용자에게 선택 요청.

### 2. `list_devops_center_work_items` — SfDevopsListWorkItems ("List DevOps Work Items")
특정 DevOps Center 프로젝트의 work item 전체 나열.
- **inputSchema:** `usernameOrAlias`, `project: { Id: string, Name?: string }` (`list_devops_center_projects`에서 같은 org로 선택한 프로젝트)
- **동작:** `fetchWorkItems(connection, project.Id)` 호출. 각 work item의 `description`은 본문 대신 `descriptionPreview`(최대 `DESCRIPTION_PREVIEW_MAX_LEN = 160`자, 초과 시 `...`)와 `hasDescription` boolean으로 요약, 원본 `description`은 `undefined`로 제거. branch·environment·repository 정보 포함.
- **MANDATORY PROJECT SELECTION:** work item 나열 전 같은 org에서 프로젝트(projectId)를 먼저 선택해야 함.
- **다음 행동 제안(이 둘만 엄격히):** ① work item 작업 시작(`checkout_devops_center_work_item`) ② 승격(`promote_devops_center_work_item`).

### 3. `create_devops_center_work_item` — SfDevopsCreateWorkItem ("Create Work Item")
지정 프로젝트에 새 work item 생성.
- **inputSchema:** `usernameOrAlias`, `projectId: string (min 1)`, `subject: string (min 1)`, `description?: string`
- **API:** `POST /services/data/v65.0/connect/devops/projects/<ProjectID>/workitem`, body `{ "subject": string, "description": string }`
- **동작:** `createWorkItem({ connection, projectId, subject, description ?? "" })`. 성공 시 `success`, `workItemId`, `workItemName`, `subject` 반환. 실패 시 `error` + `isError: true`.
- **annotations:** `readOnlyHint: false`, `destructiveHint: false`, `openWorldHint: true`.
- **(Mandatory)** subject를 사용자가 줄 때까지 진행 금지.

### 4. `promote_devops_center_work_item` — SfDevopsPromoteWorkItem ("Promote Work Item")
승인된 work item을 DevOps Center 파이프라인의 다음 stage로 승격.
- **inputSchema:** `usernameOrAlias`, `workItemNames: string[] (nonempty, 각 min 1)`, `isFullDeploy?: boolean` (true면 full deploy — 누락 의존성으로 인한 배포 실패 해결 등. 기본 false)
- **동작:** `fetchWorkItemsByNames`로 Name 기준 조회 → 각 item에서 `PipelineId`·`TargetStageId`(및 `PipelineStageId`)를 자동 도출. `id`/`TargetStageId`/`PipelineId` 누락 시 해당 Name을 `missing`에 모아 actionable 에러 반환(승격 안 함). 검증 통과 시 `promoteWorkItems(connection, { workitems, deployOptions? })` 호출. `isFullDeploy`가 true면 `deployOptions = { testLevel: "NoTestRun", isFullDeploy: true }`. 결과 JSON(promotion requestId 등) 반환.
- **Safety:** 사용자 명시 확인 없이 절대 승격 금지. non-DevOps Center org 자동 선택 금지.

### 5. `detect_devops_center_merge_conflict` — SfDevopsDetectConflict ("Detect Conflict")
선택한 work item 또는 주어진 source branch의 머지 충돌 탐지.
- **inputSchema:** `usernameOrAlias?: string`, `workItemName?: string`, `sourcebranch?: string`, `localPath: string` (repo 로컬 경로, 기본 cwd)
- **동작:** `usernameOrAlias`와 (workItemName 또는 sourcebranch 중 하나)가 필수 — 없으면 actionable 에러. org가 Managed Package DevOps(`isManagedPackageDevopsOrg`, `sf_devops__Project__c` 존재 휴리스틱)이면 standard `WorkItem` 우선·MP를 fallback으로 조회(`fetchWorkItemByName` / `fetchWorkItemByNameMP`). 필수 필드(`WorkItemBranch`, `TargetBranch`, `SourceCodeRepository.repoUrl`) 검증 후 `detectConflict({ workItem, localPath })`로 work item branch ↔ target branch 충돌 탐지. `localPath`는 `normalizeAndValidateRepoPath`로 정규화·검증.
- **Output:** 충돌 있으면 충돌 파일 목록 + 다음 단계, 없으면 머지 안전 확인.
- **다음 단계:** `resolve_devops_center_merge_conflict`.

### 6. `resolve_devops_center_merge_conflict` — SfDevopsResolveConflict ("Resolve Conflict")
선택한 work item(Name 기준)의 머지 충돌 해결을 단계별로 안내.
- **inputSchema:** `usernameOrAlias`, `workItemName: string (min 1, mandatory)`, `localPath: string`
- **동작:** detect와 동일한 MP/standard work item 조회 로직. 충돌 파일별로 사용자에게 "현재 유지(ours) vs 들어오는 것 유지(theirs)" 중 하나를 묻고 명시 확인 후에만 해당 checkout 명령 적용·stage. 충돌 해소 검증 후 로컬 커밋 단계 안내.
- **Hard constraints:** 사용자가 해당 파일에 대해 선택하기 전 `git checkout --ours` / `--theirs` 실행 금지. "keep both" 머지 경로 제공/시도 금지. 사용자가 명시적으로 push를 요청하기 전엔 로컬 작업만.
- **NEVER auto-resolve:** 절대 자동 해결 금지.

### 7. `resolve_devops_center_deployment_failure` — SfDevopsResolveDeploymentFailure ("Resolve Deployment Failure")
배포 실패를 **full promotion**으로 해결 가능한지 판단하고 사용자를 안내.
- **inputSchema:** `usernameOrAlias`, `workItemName: string (min 1, mandatory)`, `sourceBranchName: string (min 1, mandatory)`, `targetBranchName?: string` (제공 시 source↔target 비교로 full promotion 해결 여부 확인), `errorDetails: string (min 1, mandatory)`, `localPath?: string` (기본 cwd)
- **동작:**
  1. `validateGitBranchName`로 branch 이름 검증. `normalizeAndValidateRepoPath` + `isSalesforceOrDevOpsProject`로 경로가 Salesforce/DevOps 프로젝트(`sfdx-project.json`, `force-app/`, `main/` 등)인지 확인.
  2. `git checkout <sourceBranchName>` 실행(unknown branch면 `git fetch origin <branch> --prune` 후 `git checkout -B`). `execFileSync` array 형태 = shell 미사용(인젝션 방지).
  3. `canFullPromotionFixFailure(errorDetails, options)`로 판정:
     - **merge_conflict** → full promotion 불가, `resolve_devops_center_merge_conflict` 사용 안내.
     - **dependency_in_source_branch** → source branch가 누락 의존성을 포함 → full promotion 권장, **확인 요청 후 STOP**.
     - **dependency_not_in_source_branch / local_path_required / 파싱 불가** → 일반 해결 지침.
- **MANDATORY:** full promotion 가능 판정이 나와도 사용자 명시 확인("Yes"/"Proceed"/"Go ahead") 전엔 `promote_devops_center_work_item` 호출 금지. 확인 후 `workItemNames: [workItemName], isFullDeploy: true`로 호출.

### 8. `checkout_devops_center_work_item` — SfDevopsCheckoutWorkItem ("Checkout Work Item")
선택한 work item(Name)의 브랜치를 로컬에 clone/checkout.
- **inputSchema:** `usernameOrAlias`, `workItemName: string (min 1)`, `localPath: string` (repo를 clone/checkout할 디렉터리 경로 — 미제공 시 사용자에게 요청)
- **동작:** `fetchWorkItemByName`로 조회 → `SourceCodeRepository.repoUrl`·`WorkItemBranch` 도출. work item status가 `"new"`이면 `update_devops_center_work_item_status`를 내부 호출해 `"In Progress"`로 전환 후 최신 work item 재조회. `checkoutWorkitemBranch({ repoUrl, branchName, localPath })`로 (없으면 clone 후) 브랜치 checkout. checkout 실패 시 In Progress 보장 + 최신 branch 재조회 후 1회 재시도. 출력에 work item 컨텍스트(name/subject/description) 부가. git CLI 인증은 사용자가 이미 했다고 가정.
- **MANDATORY:** localPath를 사용자가 명시 선택하기 전 진행 금지(cwd를 옵션으로 보여줄 수는 있음).

### 9. `commit_devops_center_work_item` — SfDevopsCommitWorkItem ("Commit Work Item")
SFDX 프로젝트 변경을 커밋하고 commit SHA를 DevOps Center에 등록.
- **inputSchema:** `usernameOrAlias`, `workItemName: string (min 1)`, `commitMessage: string` (사용자에게 받음), `repoPath: string` (git repo 루트 절대 경로, 기본 cwd)
- **동작:** `fetchWorkItemByName` 조회 → `normalizeAndValidateRepoPath(repoPath)` + `getCurrentBranch(localPath)`로 **현재 브랜치가 work item의 `WorkItemBranch`와 일치하는지 검증**(불일치 시 에러로 안내). 빈 commitMessage 거부. `commitWorkItem({ connection, workItem, commitMessage, repoPath })` 실행. 성공 시 push 안내 텍스트(`git push origin HEAD` → 이후 `create_devops_center_pull_request`)와 결과 JSON(`commitSha`) 반환.
- **CRITICAL:** `git add/commit/push`를 수동 실행하지 말고 이 도구를 사용해야 DevOps Center가 메타데이터를 추적하고 커밋을 work item에 연결.

### 10. `update_devops_center_work_item_status` — SfDevopsUpdateWorkItemStatus ("Update Work Item Status")
work item 상태를 `"In Progress"` 또는 `"Ready to Promote"`로 변경.
- **inputSchema:** `usernameOrAlias`, `workItemName: string (min 1, 예 WI-00000001)`, `status: z.enum(["In Progress", "Ready to Promote"])`
- **동작:** `updateWorkItemStatus(connection, workItemName, status)`. 성공 시 `success`, `workItemId`, `workItemName`, `status` 반환. 실패 시 `error` + `isError: true`.
- **annotations:** `readOnlyHint: false`, `destructiveHint: false`, `openWorldHint: true`.
- **다음 단계:** "Ready to Promote" 후엔 `promote_devops_center_work_item` 제안.

### 11. `check_devops_center_commit_status` — CheckCommitStatus ("Check Commit Status")
DevOps Center에 커밋된 work item의 현재 상태 확인.
- **inputSchema:** `usernameOrAlias`, `requestId: string` (커밋 작업의 Request Id, REQUIRED)
- **동작:** `fetchCommitStatus(connection, requestId)` → 해당 requestId의 Status 필드 값을 JSON으로 반환. PR 생성 전 커밋 처리 완료 검증 용도.

### 12. `create_devops_center_pull_request` — CreatePullRequest ("Create Pull Request")
work item 기반 Pull Request 생성(개발 → 리뷰 stage 이동).
- **inputSchema:** `workItemName: string (min 1)`, `usernameOrAlias`
- **동작:** `fetchWorkItemByName` 조회(없거나 `id` 없으면 에러) → `createPullRequest(connection, workItem.id)`. 결과의 `pullRequestResult`에서 `status === 'Error' || success === false || errorMessage` 면 에러로 판정. 반환 JSON: `workItemId`, `usernameOrAlias`, `message`, `pullRequestData`(reviewUrl·status 등).
- **IMPORTANT — 시작 도구 아님:** "create PR" 요청을 받아도 이 도구를 바로 쓰지 않는다. MANDATORY 워크플로 ① org 선택 → ② `list_devops_center_work_items`로 work item 선택 → ③ `checkout_devops_center_work_item` → ④ 사용자가 수동 커밋·push 했는지 확인(커밋 도구 사용 금지) → ⑤ `check_devops_center_commit_status`로 커밋 상태 검증(필수) → ⑥ 검증 성공 후에만 이 도구 호출.
- **다음 단계:** 반환된 reviewUrl로 PR 리뷰 요청, 승인 후 `promote_devops_center_work_item` 제안.

---

## 공통/타입 (shared/, types/WorkItem)

### `src/types/WorkItem.ts`
work item 도메인 모델. 핵심 필드:

```ts
export interface WorkItem {
  id: string;
  name: string;          // Salesforce record Name
  subject?: string;      // Work item subject/title
  description?: string;
  status: string;
  owner: string;
  DevopsProjectId: string;
  PipelineId?: string;
  PipelineStageId?: string;
  Environment?: { Org_Id: string; Username: string; IsTestEnvironment: boolean; };
  SourceCodeRepository?: { repoUrl: string; repoType: string; };
  WorkItemBranch?: string;
  TargetStageId?: string;
  TargetBranch?: string;
}
```

`checkout`/`commit`/`promote`/`detect`/`resolve` 도구가 이 필드들(`SourceCodeRepository.repoUrl`, `WorkItemBranch`, `TargetBranch`, `PipelineId`, `TargetStageId`, `PipelineStageId`)을 work item에서 자동 도출한다.

### `src/shared/` 헬퍼
- **`params.ts`** — 재사용 zod 파라미터 `usernameOrAliasParam`, `directoryParam`. 12개 도구 전부 `usernameOrAliasParam` 사용.
- **`orgType.ts`** — `isManagedPackageDevopsOrg(connection)`: `SELECT Id FROM sf_devops__Project__c LIMIT 1`로 Managed Package(MP) DevOps org 여부 판정. `INVALID_TYPE`이면 비-MP. detect/resolve conflict 도구가 standard WorkItem 우선·MP fallback 분기에 사용.
- **`pathUtils.ts`** — `normalizeAndValidateRepoPath(path)`, `isSalesforceOrDevOpsProject(path)`(`sfdx-project.json`/`force-app/`/`main/` 레이아웃 검사).
- **`gitUtils.ts`** — `validateGitBranchName(name)`, `getCurrentBranch(path)`.
- **`types.ts`** — `SanitizedOrgAuthorization`(org 인증 정보 형태).
- 기타: `auth.ts`, `dependencyInBranch.ts`, `pipelineUtils.ts`, `sfdxService.ts`, `soqlUtils.ts`, `validation.ts` (인증·의존성 검사·파이프라인·SOQL·검증 보조).

### `src/constants.ts` — 텔레메트리
`TelemetryEventNames`: `devops_list_projects` / `devops_list_work_items` / `devops_promote_work_item` / `devops_checkout_work_item` / `devops_commit_work_item` / `devops_check_commit_status` / `devops_create_pull_request` / `devops_detect_conflict` / `devops_resolve_conflict` / `devops_update_work_item_status` / `devops_create_work_item`. `TelemetrySource = 'MCP-DevOps'`.

> README는 "For Internal Use Only" — 현재 내부용 npm 패키지로 버전 간 호환성 보장 없음.

---

## 관련 노트
- [[mcp-provider-api]] — 이 패키지가 구현하는 `McpProvider`/`McpTool`/`Services`/`Toolset`/`ReleaseState` 계약
- [[mcp-provider-metadata-enrichment]] — 같은 sf-mcp 모노레포의 형제 프로바이더
- [[mcp-provider-mobile-web]] — 같은 sf-mcp 모노레포의 형제 프로바이더
- [[sf-mcp - 개요]] — sf-mcp 서버 전체 개요
