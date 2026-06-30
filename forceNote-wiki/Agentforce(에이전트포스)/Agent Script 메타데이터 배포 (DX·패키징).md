---
tags: [agentforce, agent-script, deployment, metadata-api, package-xml, salesforce-dx, sf-cli, string-replacement]
source: AgentScriptDocs (Salesforce Agent Script Developer Guide, 2026-06-17판) — deploy-metadata/{agent-dx-deploy-metadata, metadata, package-allagents, package-singleagent, package-single-mismatch, string-replace-example}.md + agent-script/ascript-manage.md
created: 2026-07-01
aliases: [metadata deploy, Bot, BotVersion, GenAiPlannerBundle, AiAuthoringBundle, GenAiPlugin, GenAiFunction, GenAiPromptTemplate, ApexClass, Flow, package.xml, manifest, sf project retrieve start, sf project deploy start, sf template generate project, sf org login web, string replacement, TARGET_AGENT_USER, draft committed legacy, 에이전트 메타데이터 배포, 매니페스트, 에이전트 다른 org로 옮기기, 샌드박스에서 프로덕션으로 에이전트 이동, draft committed legacy 차이]
---

# Agent Script 메타데이터 배포 (DX·패키징)

> Agentforce 에이전트를 다른 org로 옮기기 — 메타데이터 타입 9종·draft/committed/legacy 구분·sf CLI 7단계 retrieve/deploy·매니페스트 3종(all/single/mismatch)·username 문자열 치환.

---

## 개요 — 에이전트를 새 org로

Agentforce UI 또는 Agentforce DX로 org에 에이전트를 만든 뒤에는, 메타데이터를 retrieve·deploy하여 에이전트를 다른 org로 옮길 수 있다. 예를 들어 에이전트를 sandbox org에서 production org로 옮기려면, 먼저 sandbox org에서 에이전트의 메타데이터를 로컬 머신으로 retrieve한 뒤, production org로 deploy한다.

이 노트는 Salesforce CLI 명령으로 에이전트 메타데이터를 retrieve·deploy한다. VS Code를 사용하려면 Salesforce Extensions for VS Code를 참조한다.

> 일반 메타데이터 retrieve/deploy·`package.xml` 개념은 [[Metadata API 개요]] 참조. 일반 `sf` CLI / DX 워크플로(`sf project retrieve/deploy start`, `sf template generate project`)는 [[DX 도구 개요와 워크플로 전환]] 참조. 이 노트는 **Agentforce/Agent Script 전용 메타데이터 타입과 에이전트 이동 워크플로우**에 한정한다.

---

## 에이전트 메타데이터 타입과 단계 (개념)

> 아래 표 4개는 원문 곳곳의 refresher(재기술) 표를 한곳에 모은 것이다. 값이 일부 겹치지만 각 표의 관점(타입 의미 / Agent Type→표현 / Stage→Lifecycle→메타데이터 / Summary 매트릭스)이 다르므로 요약 없이 전수 보존한다.

### 등장 메타데이터 타입 9종 (의미 전수)

| 메타데이터 타입 | 의미 (원문) |
|---|---|
| `Bot` | Top-level representation of an agent (에이전트 최상위 표현) |
| `BotVersion` | Configuration for a specific agent version. Top-level representation of an agent version. Recommended if you want to retrieve all versions of the same agent. |
| `GenAiPlannerBundle` | Represents the agent's reasoning engine metadata. Maps subagents to actions. |
| `AiAuthoringBundle` | Contains an Agent Script file and the associated metadata content. Doesn't apply to legacy agents, but you can leave it in. (draft agent 표현) |
| `GenAiPlugin` | Represents a subagent |
| `GenAiFunction` | Represents an agent action |
| `GenAiPromptTemplate` | Represents prompt templates that are used by the agent |
| `ApexClass` | Represents Apex classes that are used by an agent |
| `Flow` | Represents Flows that are used by an agent |

### draft / committed / legacy 개념

`package.xml` 매니페스트에 메타데이터를 나열하기 전에, 에이전트의 단계(stage)를 식별한다. 에이전트의 단계마다 표현하는 메타데이터가 다르다.

- **Draft (uncommitted) agent**: 에이전트나 에이전트 버전의 draft를 저장(save)하면 Agentforce가 에이전트의 `AiAuthoringBundle`을 만든다. draft 에이전트는 commit되기 전까지 편집 가능하다.
- **Committed agent**: 에이전트나 에이전트 버전을 commit하면 Agentforce가 `Bot` 또는 `BotVersion`을 만든다. committed 에이전트는 변경할 수 없으며, 변경하려면 새 버전을 만든다.
- **Legacy agent**: legacy 에이전트는 commit 단계가 없다. published legacy 에이전트나 버전을 편집·덮어쓸 수 있다. legacy 에이전트는 `AiAuthoringBundle`을 사용하지 않는다.

다음은 동일한 구분을 메타데이터 deploy 관점에서 재기술한 것이다(refresher).

- **Draft (uncommitted) agent version**: draft를 저장하면 `AiAuthoringBundle`이 생성된다. draft 에이전트를 deploy하려면 `AiAuthoringBundle`만 deploy한다.
- **Committed agent version**: commit하면 `Bot` 또는 `BotVersion`이 생성된다. committed 에이전트/버전을 deploy하려면 `AiAuthoringBundle` **그리고** `Bot` 또는 `BotVersion`을 모두 deploy해야 한다.
- **Legacy Agent**: legacy 에이전트는 `Bot` 또는 `BotVersion`으로 표현된다. legacy 에이전트는 `AiAuthoringBundle`이 필요 없다.

**Lifecycle 보충** — 메타데이터를 retrieve·deploy하려면 lifecycle을 고려해야 한다.

- **Agents: Save, Commit, then Activate** — 에이전트의 여러 draft 버전을 만들고 저장할 수 있다. 각 버전은 commit되기 전까지 편집 가능하다. commit 후에는 변경할 수 없고, 변경하려면 새 버전을 만들어야 한다. committed 에이전트는 추가 메타데이터로 표현된다.
- **Legacy Agents: Save, then Activate** — legacy 에이전트는 commit 단계가 없다. published legacy 에이전트나 버전을 그냥 편집·저장하여 덮어쓸 수 있다.

### 표② Agent Type → Metadata Representation (전수)

| Agent Type | Metadata Representation |
|---|---|
| Draft Agent | `AiAuthoringBundle` |
| Committed Agent | `AiAuthoringBundle` + `Bot` and `BotVersion` |
| Legacy Agent | `Bot` and `BotVersion` |

### 표③ Agent Stage / Lifecycle / Required Metadata (전수)

| Agent Stage | Lifecycle | Required Metadata |
|---|---|---|
| Draft (uncommitted) | Save | `AiAuthoringBundle` |
| Committed | Save → Commit → Activate | `AiAuthoringBundle` + `Bot` or `BotVersion` |
| Legacy | Save → Activate | `Bot` or `BotVersion` |

### 표④ Summary of Agent Metadata (전수)

| Agent Type | AiAuthoringBundle | Bot or BotVersion |
|---|---|---|
| Committed Agents | yes | yes |
| Draft (uncommited) Agents | yes | no |
| Legacy Agents | no | yes |

> `Draft (uncommited) Agents`의 "uncommited"는 원문 그대로의 표기다(올바른 철자는 uncommitted). [sic]

---

## 배포 7단계 (Step 1–7)

### Step 1: Set Up Your Local Development Environment

1. Salesforce CLI를 설치한다. 설정을 테스트하려면 `sf search`를 실행하여 CLI 명령 목록을 확인한다.
2. Salesforce CLI로 source org와 target org를 인증한다.

```bash
sf org login web --alias <org alias>
```

로그인 창이 나타나면 org에 로그인하고 **Allow**를 클릭한다.

(원문에서 다시 1.·2.로 번호가 매겨지는 후속 항목)

1. source org와 target org에서 Einstein과 Agentforce가 활성화되어 있는지 확인한다.
2. source org와 target org에서 에이전트를 publish·preview할 수 있는 필수 권한이 있는지 확인한다.

### Step 2: Create a Salesforce DX project

`package.xml` 매니페스트를 정의하고 retrieve된 메타데이터를 담을 Salesforce DX 프로젝트를 만든다. 먼저 프로젝트를 저장할 디렉터리로 이동한다. 그런 다음 `sf template generate project`를 사용한다.

이 예제에서는 예제 에이전트가 필요 없으므로 standard 프로젝트 템플릿을 사용한다. 또한 예제 메타데이터를 담은 샘플 `package.xml` 파일을 만들기 위해 `--manifest`를 사용한다.

```bash
sf template generate project --name <name> --template standard --manifest
```

로컬 머신의 `<project name>` 디렉터리에 Salesforce DX 프로젝트가 생성되며, 프로젝트에는 예제 `package.xml` 매니페스트 파일이 포함된다.

### Step 3: Define Metadata in the Manifest File

retrieve할 메타데이터를 정의하는 매니페스트를 만든다. 프로젝트의 `manifest/package.xml`에 생성된 기본 매니페스트를 복사하여 편집할 수 있다.

> 전체 매니페스트 예제 XML 3종과 네이밍 규칙 비교는 아래 [매니페스트 예제 3종](#매니페스트-예제-3종-all--single--mismatch) 섹션 참조.

**Understand Agent and Legacy Agent Metadata** — (위 "draft / committed / legacy 개념" 섹션 참조. Step 3 시점의 핵심만 재확인)

- Draft (uncommitted) 에이전트/버전은 `AiAuthoringBundle`로 표현된다. draft 에이전트는 commit 전까지 편집 가능하다.
- Committed 에이전트/버전은 `AiAuthoringBundle`과 더불어 `Bot`·`BotVersion`으로 표현된다. committed 에이전트는 변경할 수 없으며, 대신 새 버전을 만든다.
- Legacy 에이전트는 commit 단계가 없고 `Bot`·`BotVersion`으로 표현된다(`AiAuthoringBundle` 아님). active legacy 에이전트는 편집·덮어쓸 수 있다.

**Example Package.xml Manifest Files** — 시작용 예제

- 버전 번호(예: `<version>65.0</version>`)를 필요한 메타데이터 버전으로 교체한다. 프로젝트의 샘플 `package.xml` 매니페스트에 가장 최근 버전 번호가 들어 있다.
- Data 360 dependencies처럼 에이전트가 필요로 하는 다른 메타데이터 타입을 추가한다.

**Update Your Manifest** — 단일 에이전트 버전 정의 시 변경 사항

단일 에이전트 버전을 정의하려면 매니페스트에 다음 변경을 한다.

1. 에이전트의 최상위 표현인 `Bot` 대신, 특정 에이전트 버전의 구성을 나타내는 `BotVersion`을 사용한다. 에이전트 버전의 이름과 버전 번호를 포함한다. 예:

```xml
<types>
   <members>NGA_Service_Agent.v2</members>
   <name>BotVersion</name>
</types>
```

2. `AiAuthoringBundle`과 `GenAiPlannerBundle`을 지정할 때 에이전트 이름 대신 에이전트의 versioned name을 사용한다. 예:

```xml
<types>
   <members>NGA_Service_Agent_2</members>
   <name>AiAuthoringBundle</name>
<types>
   <members>AgentforceServiceAgent_v2</members>
   <name>GenAiPlannerBundle</name>
</types>
</types>
```

> [!warning] 위 XML은 원문(Salesforce 소스) 그대로의 verbatim이며 [sic] **`<types>` 중첩 닫힘 오류**를 포함한다 — 첫 번째 `<types>`의 닫는 태그가 없고, 마지막에 `</types>`가 2개 있는 비정상 중첩 구조다. 소스 원본의 오타이며 fabricate가 아니다. 실제 매니페스트 작성 시에는 `<types>` 블록을 각각 올바르게 닫아야 한다.

### Step 4: (Optional) — Update Your Manifest for Different Bot/AiAuthoringBundle Versions

에이전트 메타데이터에 대해 올바른 버전을 지정하는 단계다.

**What are mismatched `Bot`/`AiAuthoringBundle` versions?**

에이전트 버전을 저장(save)하면 Agentforce가 `AiAuthoringBundle` 메타데이터를 만든다. 에이전트 버전을 commit하면 Agentforce가 `Bot`/`BotVersion` 메타데이터를 만든다. commit한 것보다 더 많은 버전을 저장하면, `AiAuthoringBundle`의 버전이 `Bot`/`BotVersion`의 버전과 일치하지 않게 된다.

예를 들어 어떤 에이전트가 11개 버전과 7개의 committed 버전을 가지고 있다면, 에이전트 메타데이터에는 `AiAuthoringBundle` 11개 버전과 `Bot`·`BotVersion` 7개 버전이 들어 있다. 올바른 `AiAuthoringBundle`을 올바른 `Bot`·`BotVersion`에 매칭하려면 정확한 버전 번호를 지정해야 한다.

> [PDF/소스에 다이어그램 있음 — 본 wiki에는 alt 텍스트만] 이미지 `agent-dx-draft-versions.png` — alt: "Diagram showing draft AiAuthoringBundle versions that don't match committed Bot/BotVersion numbers" (committed Bot/BotVersion 번호와 일치하지 않는 draft AiAuthoringBundle 버전을 보여주는 다이어그램)

매칭되는 `Bot` 버전을 찾으려면, 원하는 버전의 AiAuthoringBundle 폴더를 연다. 에이전트 버전의 `bundle-meta.xml` 파일에서 `target` 메타데이터가 `GenAiPlannerBundle`과 `BotVersion`에 사용할 버전을 보여준다.

예를 들어 "TestAgentFromSource" 에이전트의 버전 9는 `GenAiPlannerBundle`과 `BotVersion`의 버전 7을 사용한다.

> [소스에 시각자료 있음 — alt 텍스트만] 이미지 `agent-dx-target.png` — alt: "Selecting the target for the agent version" (에이전트 버전의 target 선택)

이 버전들을 사용해 매니페스트를 지정한다 — 예: [매니페스트 예제 3종](#매니페스트-예제-3종-all--single--mismatch)의 mismatch 예제.

### Step 5: Retrieve Agent Metadata

프로젝트 매니페스트(예: `package.xml`)에 메타데이터를 정의한 뒤, 에이전트의 메타데이터를 로컬 머신으로 retrieve한다. org를 인증할 때 구성한 org alias를 사용한다.

```bash
sf project retrieve start --manifest manifest/package.xml --target-org <org alias>
```

메타데이터 retrieve·deploy에 대한 자세한 내용은 Basic Retrieval and Deployment of Metadata: A Refresher 참조.

### Step 6: (Optional) Update Agent Username

retrieve된 메타데이터에는 source org의 에이전트 username(들)이 들어 있다. 에이전트가 target org에서 바로(out-of-the-box) 실행되게 하려면, 문자열 치환(string replacement)으로 username을 target org의 username으로 업데이트한다. 에이전트는 사용자(user)의 컨텍스트에서 실행되며, source org와 target org의 username은 서로 다르다.

> [!note] 원문 :::note
> If you deploy an agent to your target org without replacing the username, you'll need to manually update the agent's username before it can run on the target org.
>
> (username을 치환하지 않고 target org에 에이전트를 deploy하면, target org에서 실행되기 전에 에이전트의 username을 수동으로 업데이트해야 한다.)

자세한 예는 아래 [에이전트 username 문자열 치환](#에이전트-username-문자열-치환-string-replacement) 섹션 참조.

### Step 7: Deploy Agent Metadata to a New Org

에이전트의 메타데이터를 로컬 프로젝트로 retrieve한 뒤에는, 새 org로 메타데이터를 deploy할 수 있다.

> [!important] 원문 :::important
> Don't modify the metadata that you retrieved. Uploading edited metadata to an org can corrupt your org. )
>
> ([sic] 원문 끝에 잉여 닫는 괄호 `)`가 그대로 있다 — Salesforce 소스 오타. retrieve한 메타데이터를 수정하지 말 것. 편집된 메타데이터를 org에 업로드하면 org가 손상될 수 있다.)

프로젝트에 맞는 deploy 명령을 사용한다.

```bash
sf project deploy start  --source-dir force-app --target-org my-target
```

> [sic] 위 명령에서 `start`와 `--source-dir` 사이에 공백이 2개 있다 — 원문 verbatim 보존.

**Set the Agent User and Assign Permissions**

새 org에서 에이전트를 사용하기 전에 agent user를 할당해야 한다. deploy 중에 에이전트의 user를 구성하지 않았다면 수동으로 구성한다.

> [!tip] 원문 :::tip
> You can't edit a **committed** agent. To add an agent user to a committed agent, first create a new agent version. Then, add the user to the new version.
>
> (committed 에이전트는 편집할 수 없다. committed 에이전트에 agent user를 추가하려면 먼저 새 에이전트 버전을 만든 뒤, 새 버전에 user를 추가한다.)

agent user가 에이전트의 작업을 수행할 충분한 권한을 갖도록 한다. 예를 들어 에이전트가 custom contact 필드를 읽는다면, agent user는 그 custom 필드에 대한 view 권한이 있어야 한다.

agent user에 대한 자세한 내용은 create or assign the default agent user 참조.

---

## 매니페스트 예제 3종 (all / single / mismatch)

### 예제 1 — All Agents

이 예제 매니페스트는 legacy 에이전트를 포함한 모든 에이전트의 메타데이터를 지정한다. 또한 org의 **모든** flow·prompt template·Apex class 메타데이터를 지정한다.

> [!note] 원문 :::note
> To prevent very large retrievals from large orgs, list specific metadata types rather than using the "`*`" wildcard.
>
> (대규모 org에서 매우 큰 retrieve를 방지하려면 `*` 와일드카드 대신 특정 메타데이터 타입을 나열한다.)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>*</members>
    <!-- Top-level representation of an agent. -->
        <name>Bot</name>
    </types>
    <types>
        <members>*</members>
    <!-- Top-level representation of an agent version. Recommended if you want to retrieve all versions of the same agent.-->
        <name>BotVersion</name>
    </types>
    <types>
    <!-- Represents the agent's reasoning engine metadata. Maps subagents to actions.  -->
        <members>*</members>
        <name>GenAiPlannerBundle</name>
    </types>
    <!-- Contains an Agent Script file and the associated metadata content. Doesn't apply to legacy agents, but you can leave it in.-->
    <types>
        <members>*</members>
        <name>AiAuthoringBundle</name>
    </types>

    <!-- Represents a subagent-->
    <types>
        <members>*</members>
        <name>GenAiPlugin</name>
    </types>
    <!-- Represents an agent action-->
    <types>
        <members>*</members>
        <name>GenAiFunction</name>
    </types>
    <!-- Represents prompt templates  that are used by the agent -->
    <types>
        <members>*</members>
        <name>GenAiPromptTemplate</name>
    </types>
    <!-- Represents Apex classes that are used by an agent -->
    <types>
        <members>*</members>
        <name>ApexClass</name>
    </types>

    <!-- Represents Flows that are used by an agent -->
    <types>
        <members>*</members>
        <name>Flow</name>
    </types>
    <!-- The version of metadata to extract -->
    <version>66.0</version>
</Package>
```

### 예제 2 — Single Agent Version

이 예제 `package.xml` 매니페스트는 NGA_Service_Agent 에이전트의 버전 2 메타데이터를 정의한다. 또한 에이전트의 flow·prompt template·Apex class를 정의한다.

> [!note] 원문 :::note
> Before deploying a single agent version into an org, you must have deployed the full agent to the org. Deploying the agent before deploying an agent version ensures all required metadata and artifacts are created in the target org.
>
> (단일 에이전트 버전을 org에 deploy하기 전에, 전체 에이전트를 org에 먼저 deploy해야 한다. 에이전트 버전 deploy 전에 에이전트를 deploy하면 필요한 모든 메타데이터·아티팩트가 target org에 생성된다.)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
 <!-- Use BotVersion instead of Bot to get a specific version of an agent -->
    <types>
        <members>NGA_Service_Agent.v2</members>
        <name>BotVersion</name>
    </types>
    <types>
        <members>NGA_Service_Agent_v2</members>
        <name>GenAiPlannerBundle</name>
    </types>
    <types>
        <members>NGA_Service_Agent_2</members>
        <name>AiAuthoringBundle</name>
    </types>

    <types>
        <members>*</members>
        <name>GenAiPlugin</name>
    </types>
    <types>
        <members>*</members>
        <name>GenAiFunction</name>
    </types>

    <types>
        <members>CaseEmail</members>
        <name>ApexClass</name>
    </types>

    <types>
        <members>Field_Generation_Flow</members>
        <members>Sales_Email_Flow</members>
        <name>Flow</name>
    </types>
    <!-- The version of metadata to extract -->
    <version>66.0</version>
</Package>
```

### 예제 3 — Single Agent Version with Different Bot/AiAuthoringBundle Versions (mismatch)

이 예제 `package.xml` 매니페스트는 TestAgentFromSource 에이전트의 버전 9를 retrieve하는 메타데이터를 정의하며, 이는 `GenAiPlannerBundle`·`BotVersion`의 버전 7에 대응한다. 또한 에이전트의 flow·prompt template·Apex class를 정의한다.

> [!note] 원문 :::note
> Before deploying a single agent version into an org, you must first deploy the full agent (./package-allagents.md).
>
> (단일 에이전트 버전을 org에 deploy하기 전에, 먼저 전체 에이전트를 deploy해야 한다.)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
 <!-- Use BotVersion instead of Bot to get a specific version of an agent -->
    <types>
        <members>TestAgentFromSource.v7</members>
        <name>BotVersion</name>
    </types>
    <types>
        <members>TestAgentFromSource_v7</members>
        <name>GenAiPlannerBundle</name>
    </types>
    <types>
        <members>TestAgentFromSource_9</members>
        <name>AiAuthoringBundle</name>
    </types>

    <types>
        <members>*</members>
        <name>GenAiPlugin</name>
    </types>
    <types>
        <members>*</members>
        <name>GenAiFunction</name>
    </types>

    <types>
        <members>CaseEmail</members>
        <name>ApexClass</name>
    </types>

    <types>
        <members>Field_Generation_Flow</members>
        <members>Sales_Email_Flow</members>
        <name>Flow</name>
    </types>
    <!-- The version of metadata to extract -->
    <version>66.0</version>
</Package>
```

### 표 — Example Manifests (전수, 3열)

| Example Manifest | Description | Notes |
|---|---|---|
| All Agents | Defines metadata for all agents, including legacy agents. Includes metadata for all flows, prompt templates, and Apex classes in the org. | Replace the `*` wildcard with the API names of the ApexClass, Flows, and GenAiPromptTemplates that your agents use. Using wildcards for these types can pull excessive data, leading to very long deployments or timeouts. |
| Single Agent Version | Defines a single version of an agent, plus the flows, prompt templates, and Apex class types that the agent version uses. | Before deploying a single agent version into an org (using `BotVersion`), you must have deployed the full agent to the org. Deploying the agent before deploying a specific version ensures that all required metadata and artifacts are created in the target org. |
| Single Agent Version with Different Bot/AiAuthoringBundle Versions | Defines a single agent version when the `AiAuthoringBundle` version doesn't match the `Bot`/`BotVersion` version. | This difference can happen when you save more versions than you commit. See Step 4. |

### ★ 네이밍 규칙 차이 (메타데이터 타입별 버전 표기)

같은 에이전트 버전을 가리켜도 메타데이터 타입마다 버전 표기 문법이 다르다. 매니페스트 작성 시 셀 단위로 정확히 맞춰야 한다.

| 메타데이터 타입 | 버전 표기 형식 | 예(single, v2) | 예(mismatch) |
|---|---|---|---|
| `BotVersion` | `<agent>.v<N>` (점 + v) | `NGA_Service_Agent.v2` | `TestAgentFromSource.v7` (committed 7) |
| `GenAiPlannerBundle` | `<agent>_v<N>` (언더스코어 + v) | `NGA_Service_Agent_v2` | `TestAgentFromSource_v7` (committed 7) |
| `AiAuthoringBundle` | `<agent>_<N>` (언더스코어, v 없음) | `NGA_Service_Agent_2` | `TestAgentFromSource_9` (draft 9) |

**mismatch 핵심**: draft(`AiAuthoringBundle`) = **9** ↔ committed(`Bot`/`BotVersion`·`GenAiPlannerBundle`) = **7**. commit한 것보다 많은 버전을 저장하면 이 불일치가 발생한다. 어느 draft 버전이 어느 committed 버전에 대응하는지는 `bundle-meta.xml`의 `target` 메타데이터로 확인한다(Step 4).

---

## 에이전트 username 문자열 치환 (string replacement)

이 예제는 deploy 중에 문자열 치환으로 에이전트의 username을 업데이트하는 한 가지 방법을 보여준다. 이 방법은 committed 및 uncommitted 에이전트 모두에서 동작한다.

이 예제에서는 다음을 수행한다.

- 치환할 문자열을 `digitalagent.00dob000002dgxhf324f6b53d31@salesforce.com`으로 지정한다.
- 환경 변수 `TARGET_AGENT_USER`가 새 username을 담도록 지정한다.
- 환경 변수를 설정하는 대신, 명령줄에서 새 username을 전달한다.

### Step 1 — Find Your Source Org's Username

source org에서 에이전트 default user의 username을 찾는다. username은 에이전트의 `.agent` 파일의 `default_agent_user` 속성에 정의되어 있다. 예:

```bash
    default_agent_user: "digitalagent.00dob000002dgxhf324f6b53d31@salesforce.com"
```

### Step 2 — Update Your sfdx-project.json File

Salesforce DX 프로젝트의 `sfdx-project.json` 파일에서 `replacements` 속성을 구성한다. 에이전트 username의 모든 인스턴스를 반드시 치환한다. 이 예제에서는 모든 메타데이터(`*-meta.xml`)와 agent script(`*.agent`) 파일에서 치환을 지정한다. 문자열 치환에 환경 변수 `TARGET_AGENT_USER`를 사용한다. (프로젝트의 필요에 따라 다를 수 있다.)

```json
{
  "packageDirectories": [
    {
      "path": "force-app",
      "default": true
    }
  ],
  "name": "test_metadata_string",
  "namespace": "",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "66.0",
  "replacements": [
    {
      "glob": "force-app/main/default/bots/**/*-meta.xml",
      "stringToReplace": "digitalagent.00dob000002dgxhf324f6b53d31@salesforce.com",
      "replaceWithEnv": "TARGET_AGENT_USER"
    },
    {
      "glob": "force-app/main/default/aiAuthoringBundles/**/*.agent",
      "stringToReplace": "digitalagent.00dob000002dgxhf324f6b53d31@salesforce.com",
      "replaceWithEnv": "TARGET_AGENT_USER"
    }
  ]
}
```

glob 경로 관찰: `Bot` 메타데이터 = `force-app/main/default/bots/**/*-meta.xml`, `AiAuthoringBundle` = `force-app/main/default/aiAuthoringBundles/**/*.agent`.

### Step 3 — Specify Source Username During Deployment

deploy를 실행할 때, target org의 agent username을 `TARGET_AGENT_USER` 환경 변수에 할당한다.

```bash
TARGET_AGENT_USER="digitalagent.00dob000002dgw5b9802e014bf4@salesforce.com" sf project deploy start --source-dir force-app --target-org my-target
```

---

## 에이전트 관리 (Manage Agent Script Agents)

Salesforce org에서, 또는 Agentforce DX로 명령줄에서 에이전트를 구성(configure)·배포(deploy)·테스트(test)할 수 있다.

**Configure and Deploy Agents** — org에서 에이전트를 구성·배포하려면 Salesforce Help의 Configure Your Agent·Deploy Your Agents를 참조한다. 명령줄에서 구성·배포하려면 Agentforce DX 문서를 참조한다. 또한 Agentforce와 연관된 Metadata API 타입을 참조한다.

**Test Agents** — 에이전트를 테스트하는 방법은 여러 가지다. 사용 사례에 가장 적합한 테스트 방법을 찾으려면 Get Started With Testing Agents를 참조한다.

> [!note] 원문 :::note
> Always test agents again after they're published.
>
> (에이전트가 published된 후에는 항상 다시 테스트한다.)

---

## 관련 노트

- [[Agent Script 블록 8종 (System·Config·Subagent 등)]] — `Bot`/`BotVersion`/`AiAuthoringBundle` ↔ 블록 구조 대응
- [[Agent Script 실행 흐름과 모델 설정]] — 배포된 에이전트 실행 컨텍스트·agent user
- [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]] — `ApexClass`/`Flow`/`GenAiFunction` 메타 = 액션 대상
- [[Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드]] — 같은 Cycle 6 패턴 노트(N8)
- [[Agent Script 개요와 언어 특성]] — Agentforce DX 개요(작성 3방식 허브)
- [[Metadata API 개요]] — 일반 retrieve/deploy·`package.xml` 개념 (경계: 이 노트는 agent 전용 타입에 한정)
- [[DX 도구 개요와 워크플로 전환]] — 일반 `sf` CLI/DX 워크플로 (경계: `sf project retrieve/deploy`, `sf template generate project` 일반 레퍼런스)
- [[Tooling API 객체 — 세일즈·예측·AI (포캐스팅·머신러닝·Einstein·Agentforce)]] — `GenAiFunctionDefinition`/`GenAiPlannerDefinition` sObject (경계: 배포 메타데이터 타입 vs sObject 레퍼런스 구분)
- [[스킬 ↔ 위키 토픽 맵]] — sf-skill ↔ 위키 토픽 라우팅
