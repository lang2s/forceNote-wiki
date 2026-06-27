---
tags: [agent-skill, sf-skills, devops, testing, polling, test-execution]
source: forcedotcom/sf-skills (skills/polling-test-results/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [polling-test-results, 테스트 결과 폴링, runId 폴링, DevopsTestExecution, async test polling]
---

# polling-test-results — 테스트 결과 폴링

> DevOps Center 비동기 테스트 실행을 `runId`로 폴링해 완료·실패·타임아웃까지 추적하는 스킬. provider별 간격으로 실행 레코드에 read-only SOQL을 던지며, 사용자 확인 게이트가 없는 자동·읽기전용 동작이다.

---

## 목적과 활성화 조건

DevOps Center 비동기 테스트 실행을 `runId`로 폴링하여 완료(Completed)·실패(Failed)·타임아웃 중 하나가 될 때까지 추적한 뒤 결과를 surface한다. provider별 간격(Apex 15s/5m, Code Analyzer 10s/3m, Provar UI 60s/20m, Flow 20s/8m)으로 실행 레코드에 read-only SOQL을 사용한다.

**Confirmation required: No** — 폴링은 자동이며 read-only다. 사용자 확인 게이트가 필요 없다.

**TRIGGER:** 테스트 스위트 실행이 진행 중이고 사용자가 결과를 기다릴 때 / 스위트 실행 직후 `runId`가 확보됐을 때.

**DO NOT TRIGGER:** 활성 `runId`가 없을 때.

`version: 1.0`, `minApiVersion: 67.0`.

## 워크플로 / 단계

### Prerequisites

활성 `runId`(`running-devops-test-suite` 스킬이 반환)와 확인된 `doce-org-alias`가 필요하다. org 컨텍스트가 아직 확립되지 않았다면 `checking-devops-prerequisites`를 먼저 로드한다(Prerequisites 1–3).

### Inputs required

| Input | Source |
|---|---|
| `runId` | `running-devops-test-suite` 스킬이 반환 |
| `testType` | 스위트의 test provider에서 도출 (Apex, Code Analyzer, UI/Provar, Flow) |
| `doce-org-alias` | `checking-devops-prerequisites`에서 확립 |

### Polling configuration

| Test type | Poll interval | Max wait | Timeout action |
|---|---|---|---|
| Apex unit tests | 15 seconds | 5 minutes | Surface runId, offer retry |
| Code Analyzer | 10 seconds | 3 minutes | Surface runId, offer retry |
| UI tests (Provar) | 60 seconds | 20 minutes | Surface runId, mark as pending |
| Flow tests | 20 seconds | 8 minutes | Surface runId, offer retry |

### Poll query

각 간격마다 `runId`로 실행 레코드를 쿼리한다:

```bash
sf data query \
  --query "SELECT Id, Status, TestsRan, TestsPassed, TestsFailed, CoveragePercentage FROM DevopsTestExecution WHERE Id = '<runId>' LIMIT 1" \
  --target-org <doce-org-alias> \
  --json
```

각 폴링마다 `Status` 필드를 확인한다:
- `Queued` / `Running` → 대기 후 다시 폴링
- `Completed` → 결과 분석으로 진행
- `Failed` → 에러 surface 후 retry 또는 skip 제안

### On timeout

`runId`를 사용자에게 surface한다:

> "The test run is taking longer than expected. Your run ID is `<runId>`. You can check the status manually in DevOps Center, or I can keep waiting — what would you prefer?"

타임아웃 후 자동 재시도하지 않는다. 사용자 지시를 기다린다.

### On completion

전체 결과 payload를 `analyzing-test-failures` 스킬에 전달해 추론하게 한다. `Coverage`, `SuccessCount`, `FailureCount`, `QualityGateStatus`를 인라인으로 surface한다. raw JSON을 사용자에게 노출하지 않는다.

## 핵심 규칙·가드레일

- **확인 게이트 없음** — 자동·read-only 동작이므로 사용자 확인 불필요.
- **타임아웃 시 자동 재시도 금지** — 항상 `runId`를 surface하고 사용자 지시를 기다린다.
- **raw JSON 노출 금지** — 완료 시 핵심 지표만 인라인으로 보여준다.
- provider별 poll interval / max wait를 정확히 준수한다 (표 참조).

## 번들 파일

- `SKILL.md` — 단일 파일 스킬 (추가 번들 리소스 없음)

## 관련 노트
- [[running-devops-test-suite]] — 실행은 이 스킬이 시작하며(retrigger 모드 포함) `runId`를 넘겨준다
- [[managing-suite-assignments]] — 폴링 대상 실행을 만든 스위트의 스테이지 할당 관리
- [[analyzing-test-failures]] — 완료/실패 결과에 대한 분석 처리
