---
tags: [agent-skill, sf-skills, devops, testing, test-provider, sync]
source: forcedotcom/sf-skills (skills/syncing-test-providers/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [syncing-test-providers, 테스트 프로바이더 재싱크, provider sync, DevopsPipelineTestProvider, 신규 스위트 끌어오기]
---

# syncing-test-providers — 테스트 프로바이더 재싱크

> 파이프라인에 구성된 DevOps Center 테스트 프로바이더를 Connect API sync 엔드포인트로 재싱크해 신규 테스트 스위트를 끌어오는 스킬. 명시적 사용자 확인 후 `pipelineId`와 하나 이상의 `testProviderId`로 비동기 재싱크를 트리거한다.

---

## 목적과 활성화 조건

파이프라인에 구성된 테스트 프로바이더를 재싱크해, 마지막 구성 이후 프로바이더에 추가된 스위트가 스테이지 할당에 사용 가능해지도록 한다. `pipelineId`와 하나 이상의 `testProviderId`를 받아 Connect API sync 엔드포인트로 비동기 재싱크를 트리거한다.

**Confirmation required: Yes** — 싱크 트리거 전 명시적 확인.

**TRIGGER:** 테스트 프로바이더(예: Apex Unit Tests, Code Analyzer, Flow Tests, Provar)에 마지막 구성 이후 스위트가 추가됐고 사용자가 그 스위트를 DevOps Center에 표시되게 하려 할 때 / 프로바이더 재싱크, 신규 스위트 pull-in, 프로바이더 suite 목록 새로고침 요청 / 구성된 프로바이더의 할당 스위트가 누락/오래됐다고 할 때.

**DO NOT TRIGGER:** 프로바이더를 처음 구성할 때(새 `DevopsPipelineTestProvider` 구성 생성) / 기존 스위트를 스테이지에 할당·매핑할 때(`managing-suite-assignments`).

`version: 1.0`, `minApiVersion: 67.0`.

## 워크플로 / 단계

### Prerequisites

`checking-devops-prerequisites`를 먼저 로드 — Prerequisites 1–4 (org login, Agentforce DX plugin, DevOps Center org auth, pipeline 식별). Prerequisite 5 (stage)는 **불필요** — 프로바이더는 stage가 아니라 pipeline 레벨에서 싱크된다.

| Variable | Source |
|---|---|
| `doce-org-alias` | Prerequisite 1에서 확립 |
| `pipelineId` | Prerequisite 4 (pipeline selection)에서 식별 |
| `testProviderId` | 아래에서 파이프라인의 test provider를 가져와 resolve |

### Step 1 — Fetch test providers to resolve the provider ID

파이프라인에 구성된 모든 test provider를 가져와 `testProviderId`를 resolve하고 provider 이름을 사용자와 확인한다:

```bash
sf api request rest \
  "/services/data/v67.0/connect/devopstesting/pipeline/<pipelineId>/testProviders?status=all" \
  --target-org <doce-org-alias>
```

각 provider 엔트리는 `testProviderId`, `testProviderName`, status(Configured vs. Available)를 포함한다. status별로 그룹화한 짧은 요약을 제시한다:

```text
Test providers for <pipelineName>:

✓ Configured:
- Code Analyzer (63 suites)
- Apex Unit Tests (5 suites)

Available (not yet configured):
- Flow Tests
```

- **Configured provider만 싱크 가능.** 사용자가 *Available*(아직 미구성) 프로바이더를 지목하면, 먼저 구성해야 한다고 설명한다 — 이 스킬은 프로바이더를 구성하지 않는다.
- 파이프라인에 구성된 프로바이더가 없으면 보고하고 중단한다 — 프로바이더나 ID를 fabricate하지 말 것.

### Step 2 — Confirmation gate

**Required — 사용자 확인 전 API 호출 금지.**

> "I'll re-sync `<testProviderName>` on the `<pipelineName>` pipeline to pick up any new suites. Confirm?"

긍정 응답 전까지 진행 금지.

### Step 3 — Trigger the sync

확인 시, provider ID(들)와 pipeline ID로 sync 엔드포인트를 호출한다:

```bash
sf api request rest \
  "/services/data/v67.0/connect/devops/sync" \
  --method POST \
  --body '{
    "testProviderIds": ["<testProviderId>"],
    "pipelineId": "<pipelineId>"
  }' \
  --target-org <doce-org-alias>
```

`testProviderIds`는 리스트다 — 여러 구성된 프로바이더를 한 호출로 싱크할 수 있다.

### On success

> "Provider `<testProviderName>` sync started. The operation is running asynchronously — new suites will be available shortly."

싱크는 비동기로 실행된다. 새로 싱크된 스위트는 `managing-suite-assignments`로 스테이지에 할당할 수 있다.

## 핵심 규칙·가드레일

- **Critical gotcha:** `POST /connect/devops/pipeline/<pipelineId>/testProvider`를 싱크에 **사용하지 말 것** — 그 엔드포인트는 새 프로바이더 구성을 **생성**해 중복 `DevopsPipelineTestProvider` 레코드를 만든다. 싱크는 **오직** `POST /connect/devops/sync`로만 한다.
- **Configured provider만 싱크 가능** — Available 프로바이더는 먼저 구성 필요, 이 스킬은 구성 안 함.
- 구성된 프로바이더가 없으면 fabricate하지 말고 보고 후 중단.
- **확인 게이트 필수** — 싱크 전 명시적 확인.
- **raw API 에러/스택트레이스/JSON 노출 금지** — 상태 코드 매핑:

| Status | User-facing message |
|---|---|
| 400 | "The sync request was invalid. Check that the provider ID and pipeline ID are correct." |
| 403 | "You don't have permission to sync test providers on this pipeline." |
| 404 | "The pipeline or test provider was not found." |
| 500 | "A server error occurred. Try again in a few minutes." |

## 번들 파일

- `SKILL.md` — 단일 파일 스킬 (추가 번들 리소스 없음)

## 관련 노트
- [[managing-suite-assignments]] — 싱크가 신규 스위트를 표시한 후 스테이지에 할당/매핑
- [[recommending-devops-tests]] — 새로 싱크된 스위트 중 어떤 것을 실행할지 추천
- [[checking-devops-prerequisites]] — org·pipeline 컨텍스트 확립을 위해 먼저 로드
- [[configuring-test-provider]] — Available 프로바이더를 처음 구성 (이 스킬은 재싱크만)
