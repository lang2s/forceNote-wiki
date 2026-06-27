---
tags: [agent-skill, sf-skills, devops, testing, test-execution, quality-gate]
source: forcedotcom/sf-skills (skills/running-devops-test-suite/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [running-devops-test-suite, 데브옵스 테스트 스위트 실행, stage execute, quality gate retrigger, 품질 게이트 재실행]
---

# running-devops-test-suite — 데브옵스 테스트 스위트 실행

> 파이프라인 스테이지(Pre-Promote / Post-Promote / Review 이벤트)에서 하나 이상의 DevOps Center 테스트 스위트를 Connect API로 비동기 실행하는 스킬. 명시적 확인 게이트 후 실행하고 `polling-test-results`로 핸드오프하며, 커버리지 임계값 충족이 검증된 경우에만 quality gate를 재실행(retrigger)한다.

---

## 목적과 활성화 조건

파이프라인 스테이지에서 하나 이상의 테스트 스위트를 Connect API로 비동기 실행한다(Pre-Promote, Post-Promote, Review 이벤트). 명시적 사용자 확인 게이트 후 실행하고 결과 폴링을 `polling-test-results` 스킬에 핸드오프한다. 수정 후 quality gate를 재실행(retrigger)하기도 하지만 — 커버리지 임계값이 이제 충족됐음을 검증한 경우에만.

**TRIGGER:** 파이프라인 스테이지에서 테스트 스위트를 run/kick off/launch하려 할 때 / 승격 전후 테스트 실행 / Pre-Promote·Post-Promote·Review 이벤트 실행 트리거 / 수정 후 quality gate 재실행 / 커버리지 충족 후 실패 gate 재시도 / 테스트 추가 후 막힌 승격 해제.

**DO NOT TRIGGER:** `sf apex run test`를 직접 실행할 때(`platform-apex-test-run`) / 신규 gate나 임계값 구성 시(`configuring-quality-gate`).

`version: 1.0`, `minApiVersion: 67.0`.

## 워크플로 / 단계

### Prerequisites

`checking-devops-prerequisites`를 먼저 로드·수행 — Prerequisites 1–4 **AND** Prerequisite 5 (pipeline stage). 특정 스테이지에서 동작하므로 확인된 `doce-org-alias`, `pipelineId`, `stageId`가 필요하다.

### Inputs required

| Input | How to obtain |
|---|---|
| `pipelineId` | Prerequisite 4 (pipeline selection)에서 |
| `stageId` | Prerequisite 5 (pipeline stage confirmation)에서 |
| `event` | 사용자와 확인: `Pre-Promote` 또는 `Post-Promote` (review 환경이면 `Review`) |
| `testSuiteIds` | suite selection 또는 recommendation 단계에서 확인된 suite ID |
| `doce-org-alias` | Prerequisite 1에서 확립 |

### Confirmation gate

**이 호출은 org state를 변경한다 — 명시적 사용자 확인 없이 진행 금지.** API 호출 전 다음을 보여준다:

> "I'm about to run tests with the following configuration:
> - Pipeline: `<pipelineName>`
> - Stage: `<stageName>`
> - Event: `<event>`
> - Suite(s): `<suiteName(s)>`
> - Org: `<doce-org-alias>`
> Shall I proceed?"

사용자가 확인할 때까지 API 호출 금지.

### API call

```bash
sf api request rest \
  "/services/data/v67.0/connect/devopstesting/pipeline/<pipelineId>/stage/execute" \
  --method POST \
  --body '{
    "stageId": "<stageId>",
    "event": "<event>",
    "testSuiteIds": ["<suiteId1>", "<suiteId2>"]
  }' \
  --target-org <doce-org-alias>
```

Body schema:

| Field | Type | Description |
|---|---|---|
| `stageId` | string | 테스트를 실행할 파이프라인 스테이지의 ID |
| `event` | string | `Pre-Promote`, `Post-Promote`, 또는 `Review` |
| `testSuiteIds` | string[] | 실행할 하나 이상의 test suite ID |

### On success

응답에서 `runId`(또는 execution ID)를 추출한다. 사용자에게:

> "Tests are running in `<doce-org-alias>`. I'll update you when results are ready."

즉시 `runId`를 `polling-test-results` 스킬에 핸드오프해 폴링 루프를 시작한다.

### On error

| Status | Message to user |
|---|---|
| 400 | "The test execution request was invalid. Check that the stage and suite IDs are correct." |
| 403 | "You don't have permission to run tests on this pipeline. Check your DevOps Testing API access." |
| 404 | "The pipeline or stage was not found. It may have been deleted." |
| 500 | "The DevOps Center org returned a server error. Try again in a few minutes." |

raw API 에러를 사용자에게 절대 노출하지 않는다.

### Retrigger mode (quality gate 재실행)

승격이 quality gate 실패로 막혔고 커버리지 gap이 이후 해소된 경우 사용.

**Extra preconditions — 진행 전 모두 true여야 함:**
1. 최신 `DevopsTestSuiteExecution`의 `Coverage` 필드가 `DevopsQualityGateRule`에 정의된 임계값 이상
2. 사용자가 명시적으로 gate 재실행을 요청
3. 막힌 승격의 동일한 `pipelineId`, `stageId`, `event`를 알고 있음

커버리지가 여전히 임계값 미만이면 **재실행하지 않는다.** 대신:

> "Coverage is still at `<X>%`, below the `<threshold>%` gate. The gate cannot be retriggered until the threshold is met. Here are the remaining uncovered methods: `<list>`."

재시도하지 말 것. 먼저 해결해야 할 것을 설명하고 중단한다.

**Inputs (retrigger):** `pipelineId`·`stageId`(막힌 승격 컨텍스트에서), `event`(원래 막은 것과 동일), `suiteIds`(원래 실행된 동일 스위트), `doce-org-alias`(Prerequisite 1).

**Confirmation gate (retrigger):** API 호출 전 다음 프롬프트를 제시하고 명시적 승인을 기다린다:

> "Coverage is confirmed at `<X>%`, which meets the `<threshold>%` gate. I'll retrigger the quality gate check for the `<stageName>` stage (`<event>`). Confirm?"

확인 후에만 진행. 거부하면 어떤 API 호출도 없이 중단.

**API call (retrigger)** — 동일한 Connect API stage/execute 엔드포인트 사용:

```bash
sf api request rest "/services/data/v67.0/connect/devopstesting/pipeline/<pipelineId>/stage/execute" --method POST --body '{"stageId":"<stageId>","event":"<event>","testSuiteIds":["<suiteId1>"]}' --target-org <doce-org-alias>
```

호출이 `runId`를 반환하면 새 `runId`로 `polling-test-results` 스킬에 핸드오프한다.

**Error handling (retrigger):** gate 재실행 불가 에러 반환 시:

> "The quality gate cannot be retriggered right now. Reason: `<plain-language summary>`. Here's what needs to be resolved first: `<list>`."

raw API 에러 세부정보를 절대 노출하지 않는다.

## 핵심 규칙·가드레일

- **org state 변경 호출 — 명시적 확인 게이트 필수** (일반 실행·retrigger 양쪽).
- **retrigger는 커버리지 임계값 충족이 검증된 경우에만.** 미달이면 재실행/재시도 없이 남은 미커버 메서드를 설명하고 중단.
- 성공 시 항상 `runId`를 추출해 `polling-test-results`로 즉시 핸드오프.
- **raw API 에러 노출 금지** — 상태 코드를 사용자 대면 메시지로 매핑.

## 번들 파일

- `SKILL.md` — 단일 파일 스킬 (추가 번들 리소스 없음)

## 관련 노트
- [[polling-test-results]] — `runId` 수신 후 비동기 실행 결과 폴링
- [[recommending-devops-tests]] — 실행 전 먼저 어떤 스위트를 돌릴지 추천
- [[managing-suite-assignments]] — 스위트가 스테이지에 연결돼 있지 않으면 할당/매핑
- [[configuring-quality-gate]] — 신규 gate나 임계값 구성
- [[DevOps Center 객체 — 비동기·결과]] — Connect API 비동기 실행 결과 객체 위키 노트
