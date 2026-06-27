---
tags: [agent-skill, sf-skills, devops, devops-center, quality-gate]
source: forcedotcom/sf-skills (skills/configuring-quality-gate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [configuring-quality-gate, quality gate 설정, 품질 게이트, coverage threshold, PASS_PERCENTAGE SEVERITY ESSENTIAL, 테스트 벤치마크]
---

# configuring-quality-gate — DevOps Center 품질 게이트 설정

> DevOps Center quality gate를 규칙(PASS_PERCENTAGE, SEVERITY, ESSENTIAL)과 함께 생성하고 pipeline-stage suite 할당에 연결한다. 필수 impact preview와 명시적 확인을 거친다.

---

## 목적과 활성화 조건

`metadata.version: 1.0` · `minApiVersion: 67.0`

quality gate를 연관 규칙과 함께 생성하고, 필수 impact preview를 보여 명시적 확인을 받은 뒤 pipeline-stage suite 할당에 연결한다.

**TRIGGER when:** quality gate 설정/구성, coverage threshold 변경, stage에 testing benchmark 설정.

**DO NOT TRIGGER:** 기존 gate 재실행만 할 때(→ `running-devops-test-suite` retrigger 모드).

### 사전조건 (Prerequisites)
`checking-devops-prerequisites`를 먼저 로드 — Prerequisites 1–4 AND Prerequisite 5(stage). 필요: `doce-org-alias`, `pipelineId`, `stageId`, 대상 `DevopsTestSuiteStage` 레코드 Id.

### 필수 입력 (Inputs)

| Input | Source |
|---|---|
| `name` | 유저 제공 gate 이름 |
| `rules` | `{type, threshold?}` 목록 — 아래 rule types |
| `doce-org-alias` | Prereq 1에서 확립 |
| `testSuiteStageId` | 대상 `DevopsTestSuiteStage` 레코드 Id (Prereq 5) |

### Rule types

| Type | Description | Threshold |
|---|---|---|
| `PASS_PERCENTAGE` | 통과해야 하는 테스트 최소 % | Required (0–100) |
| `SEVERITY` | 허용되는 실패 최대 severity 레벨 | Required (numeric, 예: 1–5) |
| `ESSENTIAL` | 모든 essential 테스트가 통과해야 함 | Not required |

---

## 워크플로 / 단계

### MANDATORY IMPACT PREVIEW
**어떤 명령 실행 전에도** 아래 preview를 보여주고 명시적 확인을 기다린다:

> "Here's what this quality gate will enforce on `<stageName>`:
> - Rule: `<type>` — `<description>`
> - Threshold: `<value>`
> - Affected pipelines: `<list>`
>
> Confirm to apply?"

**impact preview를 먼저 보이고 명시적 확인을 받기 전엔 이 지점을 절대 넘지 않는다.**

### Confirmation gate
유저가 명시적으로 확인("yes", "confirm", "go ahead")한 뒤에만 진행. 거절·미확인 시 멈추고 어떤 명령도 실행하지 않는다.

### Step 1 — Create the gate record

```bash
sf api request rest \
  "/services/data/v67.0/connect/devopstesting/qualityGate" \
  --method POST \
  --body '{"name": "<gateName>"}' \
  --target-org <doce-org-alias>
```
응답에서 `qualityGateId` 추출.

### Step 2 — Create each rule as a sObject record
규칙은 Connect API payload로 받지 않음 — `DevopsQualityGateRule` 레코드로 직접 생성. 유저가 요청한 규칙만 생성. `ESSENTIAL`은 threshold 없음.

```bash
sf data create record \
  --sobject DevopsQualityGateRule \
  --values "DevopsQualityGateId='<qualityGateId>' Rule='PASS_PERCENTAGE' Threshold=<value>" \
  --target-org <doce-org-alias> --json

sf data create record \
  --sobject DevopsQualityGateRule \
  --values "DevopsQualityGateId='<qualityGateId>' Rule='ESSENTIAL'" \
  --target-org <doce-org-alias> --json

sf data create record \
  --sobject DevopsQualityGateRule \
  --values "DevopsQualityGateId='<qualityGateId>' Rule='SEVERITY' Threshold=<value>" \
  --target-org <doce-org-alias> --json
```

### Step 3 — Link the gate to the suite stage
`DevopsTestSuiteStage` 레코드를 갱신해 새 gate 연결:

```bash
sf data update record \
  --sobject DevopsTestSuiteStage \
  --record-id <testSuiteStageId> \
  --values "IsQualityGateEnabled=true DevopsQualityGateId='<qualityGateId>'" \
  --target-org <doce-org-alias> --json
```

### On success
> "Quality gate `<gateName>` created with `<N>` rule(s) and assigned to `<suiteName>` on `<stageName>`."

---

## 핵심 규칙·가드레일

### Error handling
raw API error 절대 노출 금지. 다음 응답 사용:

| Status | Response |
|---|---|
| 400 | "The quality gate configuration is invalid. Check that all rule types and thresholds are correct." |
| 403 | "You don't have permission to configure quality gates on this org." |
| 500 | "A server error occurred. Try again in a few minutes." |

---

## 번들 파일

`SKILL.md` 단일 파일(추가 references/assets 없음).

---

## 관련 노트
- [[checking-devops-prerequisites]]
- [[configuring-test-provider]]
- [[analyzing-test-failures]]
- [[creating-fix-work-item]]
- [[DevOps Center 객체 — 파이프라인·프로젝트·환경]] — 파이프라인 스테이지·quality gate 객체 위키 노트
