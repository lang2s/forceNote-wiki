---
tags: [agent-skill, sf-skills, devops, devops-center, work-item]
source: forcedotcom/sf-skills (skills/creating-fix-work-item/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [creating-fix-work-item, fix work item 생성, 수정 작업 항목, WorkItem 추적, remediation task, 실패 개발자 할당]
---

# creating-fix-work-item — DevOps Center Fix Work Item 생성

> 테스트 실패 또는 Code Analyzer 위반의 fix를 추적할 DevOps Center WorkItem을 생성한다. 생성 전 subject/assignee/project preview를 보이고 명시적 확인을 요구한다.

---

## 목적과 활성화 조건

`metadata.version: 1.0` · `minApiVersion: 67.0`

테스트 실패나 분석 실패의 fix를 추적할 WorkItem 생성.

**TRIGGER when:** fix work item 생성, remediation 로깅, 실패를 개발자에게 해결 할당.

**DO NOT TRIGGER:** fix 코드 자체 작성(→ `platform-apex-generate`).

### 사전조건 (Prerequisites)
`checking-devops-prerequisites`를 먼저 로드 — Prerequisites 1–4. 필요: `doce-org-alias`, 분류할 `DevopsProjectId`, `OwnerId`(assignee). DevopsProject가 없으면 project가 존재해야 work item 생성 가능함을 표면화.

### 생성 전 필수 입력 (Inputs)

| Input | How to obtain |
|---|---|
| `DevopsProjectId` | pipeline의 연관 project에서 — 미상 시 doce org에서 `DevopsProject WHERE Name = '<projectName>'` query |
| `Subject` | 실패 분석에서 도출 — 예: "Fix: Missing code-analyzer-v5.yml workflow in blitz-10-06 repository" |
| `OwnerId` | 할당 개발자 User ID — 미상 시 doce org에서 `SELECT Id, Name FROM User WHERE Username = '<username>'` query. username 모르면 유저에게 질문. |
| `doce-org-alias` | Prerequisites에서 확립 |

---

## 워크플로 / 단계

### Confirmation gate
work item 생성 전 요약을 보이고 명시적 확인을 기다린다:

> "I'll create a fix work item with the following details:
> - **Subject:** `<subject>`
> - **Assigned to:** `<assigneeName>`
> - **Project:** `<projectName>`
>
> Shall I create it?"

유저 확인 전 진행하지 않는다.

### Creating the work item

```bash
sf data create record \
  --sobject WorkItem \
  --values "Subject='<subject>' DevopsProjectId='<DevopsProjectId>' OwnerId='<OwnerId>'" \
  --target-org <doce-org-alias> \
  --json
```

> **Important:** `WorkItem`(no namespace) 사용 — `DevopsWorkItem`은 이 org 버전에서 지원되는 sObject가 아니다.

### On success
결과에서 반환된 `id`를 파싱하고 확인:
> "Fix work item created (`<id>`): `<subject>`. Assigned to `<assigneeName>` in the `<projectName>` project."

---

## 핵심 규칙·가드레일

### Error handling
raw API error message를 절대 노출하지 않음. 오류를 평이 언어로 매핑:

| Error | Response |
|---|---|
| `FIELD_INTEGRITY_EXCEPTION` | "The assignee ID is invalid. Let me look up the correct user ID — what's the developer's username?" |
| `REQUIRED_FIELD_MISSING` | "A required field is missing. Check that `Subject` and `DevopsProjectId` are both provided." |
| `INSUFFICIENT_ACCESS` | "Your user doesn't have permission to create work items in this project." |
| Any other error | "The work item could not be created. Error: `<plain summary>`. Try again or create it manually in DevOps Center." |

---

## 번들 파일

`SKILL.md` 단일 파일(추가 references/assets 없음).

---

## 관련 노트
- [[analyzing-test-failures]]
- [[checking-devops-prerequisites]]
