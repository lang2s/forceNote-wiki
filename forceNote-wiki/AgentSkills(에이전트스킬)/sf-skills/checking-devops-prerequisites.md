---
tags: [agent-skill, sf-skills, devops, devops-center, prerequisites]
source: forcedotcom/sf-skills (skills/checking-devops-prerequisites/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [checking-devops-prerequisites, DevOps 사전조건 검증, DevOps Center prerequisites, org pipeline 검증, 환경 게이트, shared gate]
---

# checking-devops-prerequisites — DevOps Center 사전조건 검증

> 모든 DevOps Center 파이프라인 테스트 액션 전에 인증된 org·Agentforce DX 플러그인·DevOps Center org·파이프라인(필요 시 stage)을 확인하는 공유 게이트(shared gate).

---

## 목적과 활성화 조건

`metadata.version: 1.0` · `minApiVersion: 67.0`

모든 DevOps Center 테스트 스킬이 query·system call **전에** 실행하는 공유 게이트. 실패 시 평이 언어 메시지를 표면화하고 사용자가 해결할 때까지 멈춘다 — 검증되지 않은 환경으로 절대 write 진행 금지.

**TRIGGER when:** 다른 DevOps 테스트 스킬이 query/system call 전에 org/pipeline 컨텍스트 확인이 필요할 때 (suite 실행, 결과 polling, 테스트 sync, quality gate 설정/retrigger, suite 할당/매핑, fix work item 생성, 테스트 추천, 커버리지 설명, 실패 분석).

**DO NOT TRIGGER:** non-DevOps-Center 작업.

> **API version:** 모든 DevOps 테스트 system call은 Salesforce API **v67.0**(최소 요구)을 타깃.

**Important:** 모든 DevOps Center 데이터(pipeline, stage, test suite, execution)는 로컬 repo가 아니라 **Salesforce org**에 있다. 파이프라인 설정을 파일시스템에서 검색하지 말 것. 항상 `sf data query` 또는 `sf api request rest`로 org를 query.

### 다른 스킬이 사용하는 방식
모든 DevOps 테스트 스킬이 이 스킬을 먼저 로드해 Prerequisites 1–4를 순서대로 실행. Prerequisite 5(stage)는 호출 스킬이 특정 stage에 작동할 때**만**(suite 실행/retrigger, sync, gate 설정, suite 매핑). 호출 스킬은 해소된 `doce-org-alias`, `pipelineId`, (해당 시) `stageId`를 자기 명령에 받아간다.

**DevOps Center org alias 해소** (애매할 때만 질문):
1. 유저가 메시지에 alias를 명시했으면 사용.
2. 아니면 default org(`sf org display --json`, `--target-org` 없이).
3. default org에 `DevopsPipeline` 레코드가 없을 때(Prereq 4 실패)만 질문: "Which org alias is your DevOps Center org?"

---

## 워크플로 / 단계

### Prerequisite 1 — Salesforce org: active login

```bash
sf org list --json
```
`result.nonScratchOrgs` / `result.scratchOrgs` / `result.sandboxes`에서 `"connectedStatus": "Connected"` 1개 이상 확인.
- **Pass:** 최소 1개 Connected · **Fail:** org 없음 또는 전부 non-connected
- **On fail:** "No authenticated Salesforce org found. Run `sf org login web --alias <your-alias>` in your terminal, then come back."

### Prerequisite 2 — Agentforce DX plugin installed

```bash
sf plugins --json
```
`name`에 `plugin-agent`, `agentforce`, `einstein`(대소문자 무관) 포함 항목 확인.
- **Pass:** 발견 · **Fail:** 매칭 없음
- **On fail:** "The Agentforce DX Plugin is not installed. Run `sf plugins install @salesforce/plugin-agent`, then restart the IDE and try again."

### Prerequisite 3 — DevOps Center org authenticated

```bash
sf org display --target-org <doce-org-alias> --json
```
`"connectedStatus"`가 `"Connected"`인지 확인.
- **Pass:** Connected · **Fail:** 세션 만료/오류
- **On fail:** "Your DevOps Center org session has expired. Run `sf org login web --alias <doce-org-alias>` to re-authenticate."

### Prerequisite 4 — Pipeline identified

```bash
sf data query \
  --query "SELECT Id, Name, CreatedDate FROM DevopsPipeline ORDER BY Name ASC" \
  --target-org <doce-org-alias> \
  --json
```
- **Pass (정확히 1개):** 자동 사용 — 묻지 않음.
- **Pass (복수):** 유저가 이미 명명했으면 이름 매칭. 아니면 번호 목록 표시 후 질문:
  ```text
  Found <N> pipelines:
  1. <Name>
  2. <Name>
  Which pipeline would you like to work with?
  ```
- **Fail (레코드 없음):** "No DevOps Center pipeline found. Create a project and pipeline in DevOps Center before using the DevOps Testing Skills."
- **Fail (unsupported object):** "DevOps Center does not appear to be installed on `<doce-org-alias>`. Check that you're pointing at the correct org."

### Prerequisite 5 — Pipeline stage identified (conditional)
호출 스킬이 특정 stage에 작동할 때**만** 실행. 유저가 stage 이름을 이미 명시(예: "Integration", "Staging", "Production")했으면 그대로 사용 — 다시 묻지 않고 Id 조회:

```bash
sf data query \
  --query "SELECT Id, Name FROM DevopsPipelineStage WHERE DevopsPipelineId = '<pipelineId>' AND Name = '<stageName>'" \
  --target-org <doce-org-alias> --json
```
stage 미언급 시에만 전체 목록 fetch 후 질문:
```bash
sf data query \
  --query "SELECT Id, Name FROM DevopsPipelineStage WHERE DevopsPipelineId = '<pipelineId>' ORDER BY Name ASC" \
  --target-org <doce-org-alias> --json
```
이후 질문: "Which pipeline stage are we working with?" — org alias는 묻지 않음(stage는 pipeline에서 이름으로 해소).
- **Pass:** stage Id·Name 확인 · **Deferred:** 호출 스킬 필요 전까지 불요.

---

## 핵심 규칙·가드레일

### Error Handling

| Error condition | Response |
|---|---|
| `sf org list` 전체 실패 | "Could not reach the Salesforce CLI. Make sure `sf` is installed and on your PATH." |
| `sf org display` auth error | 평이 언어 re-auth 안내. raw error 노출 금지. |
| `DevopsPipeline` query 5xx | "The DevOps Center org is returning a server error. Try again in a few minutes." |
| 예기치 못한 throw | "Something went wrong checking prerequisites. Error: [plain summary]. Let's try again — or resolve it manually and let me know when ready." |

raw API error, stack trace, JSON error payload를 사용자에게 절대 노출하지 않는다.

### Gotchas

| Issue | Resolution |
|---|---|
| `DevopsPipeline` query empty | 대상 org에 DevOps Center 미설치 또는 잘못된 alias — 유저에게 확인 요청 |
| `DevopsWorkItem` sObject 미지원 | `WorkItem`(no namespace) 사용 — 이 org 버전의 정확한 API 이름 |
| Review trigger가 stage-level 아닌 pipeline-level | `DevopsPipelineStageTrigger`에서 `TriggerType = 'Review'` AND `RelatedRecordId = <pipelineId>` query |
| Connect API `testSuites`가 `?stageId=`로 empty 반환 | `?triggerId=<reviewTriggerId>` 사용 — `stageId`는 stage-level trigger에만 작동 |
| `sf plugins`가 `agentforce` 미매칭 | 설치된 플러그인은 `@salesforce/plugin-agent` — `plugin-agent`도 매칭 |

---

## 번들 파일

`SKILL.md` 단일 파일(추가 references/assets 없음).

---

## 관련 노트
- [[analyzing-test-failures]]
- [[configuring-quality-gate]]
- [[configuring-test-provider]]
- [[creating-fix-work-item]]
- [[DevOps Center 데이터 모델 개요]] — DevOps Center 객체 데이터 모델 위키 노트
- [[DevOps Center 객체 — 파이프라인·프로젝트·환경]] — 파이프라인·프로젝트·환경 객체
