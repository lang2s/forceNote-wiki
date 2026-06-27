---
tags: [agent-skill, sf-skills, devops, testing, devops-center, test-suite]
source: forcedotcom/sf-skills (skills/managing-suite-assignments/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [managing-suite-assignments, 테스트 스위트 할당 관리, suite assignment, testSuiteStages, 파이프라인 스테이지 스위트]
---

# managing-suite-assignments — 테스트 스위트 할당 관리

> DevOps Center 파이프라인 스테이지에 테스트 스위트를 할당·매핑하고, 스위트 내 테스트 클래스를 추가/제거하는 Connect API `testSuiteStages` 스킬. 모든 모드는 API 호출 전 사용자 확인 게이트가 필수다.

---

## 목적과 활성화 조건

DevOps Center 파이프라인 스테이지에 대한 모든 형태의 테스트 스위트 할당을 Connect API `testSuiteStages` 엔드포인트로 관리한다. 세 가지 모드를 다룬다.

- **Mode A** — 단일 스위트를 스테이지에 일회성으로 부착(attach)
- **Mode B** — 여러 스위트를 스테이지에 대량 매핑(testing strategy). 변경 전 **impact-preview 표 필수**
- **Mode C** — 스위트 할당 내 개별 테스트 클래스 추가/제거. 거부된(rejected) 테스트 제외 + 최종 목록 재제시 거버넌스 규칙 적용

**TRIGGER:** 스위트가 파이프라인 스테이지에 연결되지 않은 채 발견되어 할당하려 할 때 / 파이프라인 전반의 suite-to-stage 매핑을 설정하거나 testing strategy로 다수 스위트를 할당할 때 / 스위트에 테스트를 추가·제거, 리뷰된 테스트를 스위트에 동기화, 또는 테스트를 스위트로 승격(promote)하려 할 때.

**DO NOT TRIGGER:** 새 테스트 클래스를 작성할 때(`platform-apex-test-generate` 사용) / 테스트를 직접 실행할 때(`platform-apex-test-run` 사용).

`version: 1.0`, `minApiVersion: 67.0`.

## 워크플로 / 단계

### Prerequisites

`checking-devops-prerequisites`를 먼저 로드 — Prerequisites 1–4 **AND** Prerequisite 5 (stage). 어느 모드든 진행 전 `doce-org-alias`, `pipelineId`, `stageId`가 필요하다.

| Variable | Description |
|---|---|
| `doce-org-alias` | Prerequisite 1에서 확립 |
| `pipelineId` | Prerequisite 4 (pipeline selection)에서 식별 |
| `stageId` | Prerequisite 5 (stage selection)에서 식별 |
| `event` | `Pre-Promote`, `Post-Promote`, 또는 `Review` |

### Mode A — 단일 스위트를 스테이지에 할당

관련 테스트 스위트가 이미 존재하나 아직 파이프라인 스테이지에 연결되지 않았고, 사용자가 단일 일회성 할당으로 추가하려 할 때 사용.

추가 입력: `testSuiteId`(할당할 스위트 ID), `testSuiteName`(확인 표시용 이름).

**Confirmation gate — API 호출 전 확인 필수.** 다음 프롬프트를 제시하고 긍정 응답을 기다린다:

> "The suite `<testSuiteName>` is not currently assigned to the `<stageName>` stage (`<event>`). Would you like me to assign it now?"

확인 전까지 진행 금지. **On success:**

> "Suite `<testSuiteName>` has been assigned to the `<stageName>` stage (`<event>`)."

### Mode B — 여러 스위트를 스테이지에 매핑

파이프라인 전반의 suite-to-stage 매핑 설정 또는 testing strategy로 다수 스위트 할당 시 사용.

추가 입력: `testSuiteOperations` — `{testSuiteId, action: "add"|"remove"}` 리스트.

**MANDATORY IMPACT PREVIEW — 어떤 변경 전에도 필수.** 사용자가 아래 프리뷰를 확인하기 전에는 API를 호출하지 않는다. 전체 매핑 요약을 제시하고 명시적 확인을 기다린다:

> "Here's the suite mapping I'll apply:
> | Suite | Stage | Event | Action |
> |---|---|---|---|
> | `<suiteName>` | `<stageName>` | `<event>` | Add |
> | `<suiteName2>` | `<stageName>` | `<event>` | Remove |
> Confirm to apply all changes?"

사용자가 명시적으로 확인한 후에만 진행. **On success:**

> "Suite mapping applied. `<N>` suite(s) updated for the `<stageName>` stage."

### Mode C — 스위트 내 테스트 클래스 추가/제거

기존 스위트 할당 내 개별 테스트 클래스를 추가·제거하거나, 리뷰된 테스트를 스위트에 동기화하거나, 테스트를 스위트로 승격할 때 사용.

추가 입력: `testSuiteOperations` — `{testSuiteId, action: "add"|"remove"}` 리스트.

**Confirmation gate — REQUIRED, 건너뛰지 말 것.** 호출 전 전체 변경 목록을 보여준다:

> "I'm about to sync the following changes to the test suite:
> - **Add:** `<testSuiteName1>`, `<testSuiteName2>`
> - **Remove:** `<testSuiteName3>`
> - Stage: `<stageName>` | Event: `<event>`
> Confirm?"

명시적 확인 후에만 진행. **On success:**

> "Test suite updated successfully for the `<stageName>` stage."

### The system call (세 모드 공통)

모든 `<placeholder>` 값을 실행 전 치환한다.

```bash
sf api request rest "/services/data/v67.0/connect/devopstesting/pipeline/<pipelineId>/testSuiteStages" --method POST --body '{"pipelineStageId":"<stageId>","event":"<event>","assignments":[{"testSuiteId":"<id>","action":"add|remove"}]}' --target-org <doce-org-alias>
```

전체 payload 스키마:

```json
{
  "pipelineStageId": "<stageId>",
  "event": "<event>",
  "assignments": [
    {"testSuiteId": "<suiteId1>", "action": "add"},
    {"testSuiteId": "<suiteId2>", "action": "remove"}
  ]
}
```

## 핵심 규칙·가드레일

- **모든 모드는 API 호출 전 명시적 확인 게이트가 필수.** Mode B는 impact-preview 표, Mode C는 전체 변경 목록 제시 필수.
- **Mode C 거버넌스:**
  - 명시적 승인 없이 절대 호출하지 않는다. AI가 리뷰/수정한 테스트는 이 호출 전에 사용자에게 재제시해야 한다.
  - 거부된(rejected) 테스트는 payload에서 **반드시 제외** — 이전에 스위트에 있었더라도 포함하지 않는다.
  - 리뷰 중 테스트가 수정되었다면 확인 요청 전에 최종 테스트 목록을 재제시한다.
- **에러 핸들링:** raw API 에러 메시지를 사용자에게 절대 노출하지 않는다. 상태 코드를 사용자 대면 메시지로 매핑한다.

| Status | User-facing message |
|---|---|
| 400 | "The request was invalid. Check that all suite and stage IDs are correct and the event type is valid." |
| 403 | "You don't have permission to modify suite assignments on this pipeline." |
| 404 | "The pipeline or stage was not found." |
| 500 | "A server error occurred. Try again in a few minutes." |

## 번들 파일

- `SKILL.md` — 단일 파일 스킬 (추가 번들 리소스 없음)

## 관련 노트
- [[syncing-test-providers]] — 할당하려는 스위트가 아직 나타나지 않을 때 provider 재싱크로 신규 스위트를 끌어온다
- [[recommending-devops-tests]] — 어떤 스위트를 할당할지 추천이 필요할 때
- [[running-devops-test-suite]] — 매핑된 스위트를 실제 실행할 때
- [[configuring-quality-gate]] — 스위트 매핑 후 스테이지에 quality gate 구성
- [[analyzing-test-failures]] — 실패 분석 및 스위트 내 테스트 개선 제안
