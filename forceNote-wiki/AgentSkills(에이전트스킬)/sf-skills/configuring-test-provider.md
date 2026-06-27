---
tags: [agent-skill, sf-skills, devops, devops-center, test-provider]
source: forcedotcom/sf-skills (skills/configuring-test-provider/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [configuring-test-provider, 테스트 프로바이더 설정, test provider 구성, Apex Code Analyzer Flow Provar, Connect API pipeline provider]
---

# configuring-test-provider — DevOps Center 테스트 프로바이더 설정

> 사용 가능한 test provider(예: Apex Unit Tests, Code Analyzer, Flow Tests, Provar)를 명시적 확인 후 Connect API로 DevOps Center pipeline에 구성하여, 해당 provider의 suite가 stage 할당에 사용 가능해지게 한다.

---

## 목적과 활성화 조건

`metadata.version: 1.0` · `minApiVersion: 67.0`

`pipelineId`와 `testProviderId`를 받아 pipeline 레벨에서 provider를 구성한다. provider가 pipeline에서 available이나 아직 미구성이고 유저가 활성화를 원할 때 사용.

**Confirmation required:** Yes — provider 구성 전 명시적 확인.

**TRIGGER when:** test provider를 pipeline에 configure/enable/set up/add, 또는 아직 미구성 provider의 suite를 사용 가능하게.

**DO NOT TRIGGER:** 이미 구성된 provider를 재-sync해 새 suite를 가져올 때(→ `syncing-test-providers`), 기존 suite를 stage에 할당(→ `managing-suite-assignments`).

### 사전조건 (Prerequisites)
`checking-devops-prerequisites`를 먼저 로드 — Prerequisites 1–4(org login, Agentforce DX plugin, DevOps Center org auth, pipeline identified). Prerequisite 5(stage)는 **불요** — provider는 stage가 아닌 pipeline 레벨에서 구성된다.

| Variable | Source |
|---|---|
| `doce-org-alias` | Prerequisite 1에서 확립 |
| `pipelineId` | Prerequisite 4(pipeline 선택)에서 식별 |
| `testProviderId` | pipeline의 test provider fetch로 해소(아래) |

---

## 워크플로 / 단계

### Step 1 — Fetch test providers to resolve the provider ID
pipeline의 모든 test provider를 가져와 `testProviderId`를 해소하고 아직 구성 가능한 provider를 확인:

```bash
sf api request rest \
  "/services/data/v67.0/connect/devopstesting/pipeline/<pipelineId>/testProviders?status=all" \
  --target-org <doce-org-alias>
```
각 provider 항목은 `testProviderId`, `testProviderName`, status(Configured vs. Available) 포함. status별 그룹 요약 제시:

```text
Test providers for <pipelineName>:

✓ Configured:
- Code Analyzer (63 suites)
- Apex Unit Tests (5 suites)

Available (not yet configured):
- Flow Tests
```

- **Available provider만 구성 가능.** available provider가 없으면 보고 후 멈춤 — provider나 ID를 **fabricate 금지**.

### 명명된 provider가 이미 Configured인 경우
confirmation gate를 제시하지 **않고** configure 엔드포인트(Step 2–3)에 POST하지 **않는다** — 중복 `DevopsPipelineTestProvider` 생성 방지. 대신:
1. 이미 구성됨을 명확히 진술(반환되면 synced suite 수·last-sync 시각 포함, 예: *"Flow Tests is already configured on `<pipelineName>` with 3 suites synced (last sync 2026-06-23)."*).
2. 유저의 실제 목표를 진단하고 **이름으로** 리다이렉트:
   - provider의 **suite가 stage에 테스트 할당 시 안 나타남** → 이는 provider-configuration 갭이 아닌 **stage-assignment 갭**(suite는 pipeline 레벨에 이미 존재, stage 연결만 필요) → **`managing-suite-assignments`**로.
   - 아직 sync 안 된 **새로 만든 suite** 기대 → **`syncing-test-providers`**(`POST /connect/devops/sync`로 재-sync)로.
3. configure로 되돌아가지 않음 — 설명·리다이렉트 후 깔끔히 종료.

### Step 2 — Confirmation gate
**필수 — 유저 확인 전 API 호출 금지.**
> "I'll configure `<testProviderName>` on the `<pipelineName>` pipeline. This will make its suites available for assignment to stages. Confirm?"

긍정 응답 전 진행하지 않는다.

### Step 3 — Configure the provider
확인 시 provider ID로 configure 엔드포인트 호출:

```bash
sf api request rest \
  "/services/data/v67.0/connect/devops/pipeline/<pipelineId>/testProvider" \
  --method POST \
  --body '{"testProviderId": "<testProviderId>"}' \
  --target-org <doce-org-alias>
```

### On success
> "Provider `<testProviderName>` is now configured on the `<pipelineName>` pipeline. Its suites are available for assignment to stages."

새로 구성된 suite는 `managing-suite-assignments`로 stage에 할당 가능.

---

## 핵심 규칙·가드레일

### Critical gotcha
이 `POST .../pipeline/<pipelineId>/testProvider` 엔드포인트는 **새 provider 구성 레코드**(`DevopsPipelineTestProvider`)를 **생성**한다. 최초 구성에만 사용. 이미 구성된 provider를 새 suite 위해 재-sync하려면 `syncing-test-providers`(`POST /connect/devops/sync`) 사용 — 이미 구성된 provider에 이 configure 엔드포인트를 호출하면 **중복** `DevopsPipelineTestProvider` 레코드 발생.

### Error Handling
raw API error message·stack trace·JSON payload를 절대 노출하지 않음. status code를 평이 언어로 매핑:

| Status | User-facing message |
|---|---|
| 400 | "The request was invalid. Check that the provider ID and pipeline ID are correct." |
| 403 | "You don't have permission to configure test providers on this pipeline." |
| 404 | "The pipeline or test provider was not found." |
| 409 | "That provider appears to already be configured on this pipeline. To pick up new suites, re-sync it instead." |
| 500 | "A server error occurred. Try again in a few minutes." |

---

## 번들 파일

`SKILL.md` 단일 파일(추가 references/assets 없음).

---

## 관련 노트
- [[checking-devops-prerequisites]]
- [[configuring-quality-gate]]
- [[analyzing-test-failures]]
- [[syncing-test-providers]] — 최초 구성 후 provider를 재싱크해 신규 스위트를 끌어옴
