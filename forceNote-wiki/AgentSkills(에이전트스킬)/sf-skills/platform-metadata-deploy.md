---
tags: [agent-skill, sf-skills, platform, metadata, devops, deployment, sf-cli]
source: forcedotcom/sf-skills (skills/platform-metadata-deploy/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-metadata-deploy, 메타데이터 배포, sf project deploy, dry-run, CI/CD, deployment order]
---

# platform-metadata-deploy — Salesforce 메타데이터 배포 자동화

> `sf` CLI v2 기반 배포 오케스트레이션 — dry-run 검증, targeted/manifest 배포, CI/CD 워크플로, scratch org 관리, 실패 triage, 안전한 rollout 순서.

## 목적과 활성화 조건

`metadata.version: 1.1`

**TRIGGER:** metadata 배포, scratch org/sandbox 생성·관리, CI/CD 파이프라인 설정, `sf project deploy` 배포 오류 트러블슈팅.

**DO NOT TRIGGER:** Apex 작성(→`platform-apex-generate`), LWC 빌드(→`experience-lwc-generate`), metadata 정의 생성(→`platform-custom-object-generate`/`platform-custom-field-generate`), org 데이터 쿼리(→`platform-data-manage`).

이 스킬이 소유하는 작업: `sf project deploy start/quick/report`·retrieval workflow · 객체·permission set·Apex·Flow 간 release sequencing · CI/CD gate·test-level 선택·deployment report · 배포 실패·의존성 순서 트러블슈팅.

## 워크플로 / 단계

### Critical Operating Rules
- **`sf` CLI v2 only.**
- non-source-tracking org에서 deploy/retrieve는 명시적 scope(`--source-dir`/`--metadata`/`--manifest`) 필요.
- **`--dry-run` first** 선호.
- Flow는 안전 배포 후 검증 후에만 활성화.
- test-data 생성은 metadata 검증/배포 후 `platform-data-manage`에 위임.

### Default Deployment Order (의존성·FLS 실패 방지)
| Phase | Metadata |
|---|---|
| 1 | Custom objects / fields |
| 2 | Permission sets |
| 3 | Apex |
| 4 | Flows as Draft |
| 5 | Flow activation / post-verify |

### Required Context to Gather First
target org alias·환경 타입 · 배포 scope(source-dir/metadata/manifest) · validate-only/deploy/quick deploy/retrieve/CI-CD 여부 · test level·rollback 기대 · 특수 metadata(Flow/permission set/agent/package) 여부.

Preflight:
```bash
sf --version
sf org list
sf org display --target-org <alias> --json
test -f sfdx-project.json
```

### Recommended Workflow
1. **Preflight** — auth, repo shape, package dir, target scope 확인.
2. **Validate first**
   ```bash
   sf project deploy start --dry-run --source-dir force-app --target-org <alias> --wait 30 --json
   ```
3. **검증 성공 시 다음 안전 단계 안내** — deploy now / permission set assign / `platform-data-manage`로 test data / 테스트·smoke check / 다단계 post-deploy 오케스트레이션.
4. **가장 작은 올바른 scope로 배포**
   ```bash
   # source-dir deploy
   sf project deploy start --source-dir force-app --target-org <alias> --wait 30 --json

   # manifest deploy
   sf project deploy start --manifest manifest/package.xml --target-org <alias> --test-level RunLocalTests --wait 30 --json

   # Spring '26 relevant-test 선택
   sf project deploy start --manifest manifest/package.xml --target-org <alias> --test-level RunRelevantTests --wait 30 --json

   # 검증 성공 후 quick deploy
   sf project deploy quick --job-id <validation-job-id> --target-org <alias> --json
   ```
5. **Verify**
   ```bash
   sf project deploy report --job-id <job-id> --target-org <alias> --json
   ```
   이후 테스트·Flow 상태·permission assignment·smoke-test 동작 검증.
6. **Report clearly** — 배포/실패/skip/다음 안전 action 요약. 출력 템플릿: `references/deployment-report-template.md`.

## 핵심 규칙·가드레일

### High-Signal Failure Patterns
| Error/symptom | 원인 | Default fix |
|---|---|---|
| `FIELD_CUSTOM_VALIDATION_EXCEPTION` | validation rule 또는 잘못된 test data | data/rule timing 조정 |
| `INVALID_CROSS_REFERENCE_KEY` | 의존성 누락 | 참조 metadata 먼저 포함 |
| `CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY` | trigger/Flow/validation side effect | automation stack·실패 로직 점검 |
| 배포 중 테스트 실패 | 깨진 코드/취약 테스트 | targeted 테스트, root cause 수정, 재검증 |
| permset에서 field/object not found | 잘못된 순서 | object/field를 permission set 전에 배포 |
| Flow invalid/version 충돌 | 의존성/활성화 문제 | Draft 배포, 검증 후 활성화 |

전체 workflow: `references/orchestration.md`, `references/trigger-deployment-safety.md`.

### CI/CD Guidance
기본 파이프라인: authenticate → repo/org 검증 → static analysis → dry-run deploy → 테스트+coverage gate → deploy → verify+notify.
- 정책·release risk 허용 시 Apex-heavy 배포에 `--test-level RunRelevantTests` 고려.
- 모던 Apex test annotation(`@IsTest(testFor=...)`, `@IsTest(isCritical=true)`)과 함께 사용 — authoring은 `platform-apex-generate`.
- static analysis는 **Code Analyzer v5**(`sf code-analyzer`), 폐기된 `sf scanner` 아님.

### Agentforce Deployment Note
agent 주변 배포/publish sequencing은 이 스킬, agent authoring은 `agentforce-generate`. `Agent:` pseudo metadata·publish/activate·sync-between-orgs는 `references/agent-deployment-guide.md`.

### Score Guide
90+ 강한 배포 계획 · 75–89 minor review · 60–74 partial coverage · <60 불충분(rollout 전 plan tighten).

### Completion Format
```text
Deployment goal: <validate / deploy / retrieve / pipeline>
Target org: <alias>
Scope: <source-dir / metadata / manifest>
Result: <passed / failed / partial>
Key findings: <errors, ordering, tests, skipped items>
Next step: <safe follow-up action>
```

## 번들 파일

`references/`:
- `orchestration.md` · `deployment-workflows.md` — 배포 오케스트레이션·deep workflow
- `deployment-report-template.md` — report 출력 템플릿
- `trigger-deployment-safety.md` — trigger 배포 안전성
- `agent-deployment-guide.md` — agent DevOps(pseudo metadata, publish/activate, sync)
- `deploy.sh` — 배포 스크립트

`assets/`:
- `package.xml` — 공통 metadata type을 커버하는 manifest 템플릿
- `destructiveChanges.xml` — target org에서 metadata 제거 템플릿

`README.md` · `CREDITS.md` · `SKILL.md`

### Cross-Skill Integration
custom object/field 생성 → `platform-custom-object-generate`/`platform-custom-field-generate` · Apex authoring/fix → `platform-apex-generate` · Flow → `automation-flow-generate` · test data → `platform-data-manage` · agent authoring → `agentforce-generate`.

## 관련 노트
- [[platform-custom-object-generate]]
- [[platform-custom-field-generate]]
- [[platform-permission-set-generate]]
- [[platform-metadata-api-context-get]]
- [[Metadata API 빌드·릴리스 워크플로]] — Org Development Model 배포 파이프라인
- [[Apex 배포 방법]] — Apex 배포 5가지 방법 카탈로그
- [[Salesforce DX 개요]] — sf CLI·sfdx-project.json 기반
