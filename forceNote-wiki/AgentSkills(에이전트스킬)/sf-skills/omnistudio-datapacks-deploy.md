---
tags: [agent-skill, sf-skills, omnistudio, datapack, vlocity-build, ci-cd]
source: forcedotcom/sf-skills (skills/omnistudio-datapacks-deploy/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [omnistudio-datapacks-deploy, OmniStudio DataPack 배포 스킬, Vlocity Build, packDeploy packRetry packExport, DataPack 마이그레이션]
---

# omnistudio-datapacks-deploy — Vlocity Build DataPack 배포 스킬

> Vlocity Build(`vlocity`)로 OmniStudio/Industries DataPack을 export·deploy·retry·diff 하고 org-to-org 마이그레이션과 CI/CD 시퀀싱을 orchestrate하는 에이전트 스킬.

---

## 목적과 활성화 조건

Vlocity DataPack 배포 orchestration이 필요할 때 사용: export/deploy 워크플로, manifest 기반 배포, 실패 triage, OmniStudio/Industries DataPack의 CI/CD 시퀀싱.

**Scope (사용):**
- `vlocity packDeploy`, `packRetry`, `packContinue`, `packExport`, `packGetDiffs`, `validateLocalData`
- DataPack job-file 설계(`projectPath`, `expansionPath`, `manifest`, `queries`)
- org-to-org DataPack 마이그레이션·retry 루프
- DataPack 의존성·matching-key·GlobalKey 이슈 troubleshooting

**위임:** 표준 메타데이터 `sf project deploy` → `platform-metadata-deploy` / OmniScript·FlexCard·IP·Data Mapper 빌드 → `omnistudio-*` 빌드 스킬 / Product2 EPC 번들 → `omnistudio-epc-catalog-generate` / Apex·LWC 코드 → `platform-apex-generate`, `experience-lwc-generate`.

### Critical Operating Rules
- DataPack은 `sf project deploy`가 아닌 **Vlocity Build(`vlocity`)** 명령 사용.
- 가능하면 username/password 파일보다 SF CLI auth 통합(`-sfdx.username <alias>`) 선호.
- full deploy 전 항상 **pre-deploy quality gate** 실행: 1) `validateLocalData` 2) (선택) `packGetDiffs` 3) `packDeploy`.
- 오류 수가 줄어드는 동안 `packRetry` 반복; retry가 개선 안 되면 중단.
- source·target org 간 matching-key 전략·GlobalKey 무결성 일관 유지.

### Required Context to Gather First
source/target org alias, job file 경로·DataPack 프로젝트 경로, 배포 scope(full/manifest subset/`-key`), export·deploy·retry·continue·diff-only 여부, namespace 모델(`%vlocity_namespace%`/`vlocity_cmt`/core), 알려진 제약(새 sandbox bootstrap, trigger 동작, matching key 커스터마이징).

Preflight:
```bash
vlocity help
sf org list
sf org display --target-org <alias> --json
test -f <job-file>.yaml
```

---

## 워크플로 / 단계 (Recommended Workflow)

### 1. 도구 준비
```bash
npm install --global vlocity
vlocity help
```

### 2. 로컬 데이터 검증
```bash
vlocity -sfdx.username <source-alias> -job <job-file>.yaml validateLocalData
```
`--fixLocalGlobalKeys`는 명시적 요청·영향 설명 후에만 사용.

### 3. source에서 export (필요 시)
```bash
vlocity -sfdx.username <source-alias> -job <job-file>.yaml packExport
vlocity -sfdx.username <source-alias> -job <job-file>.yaml packRetry
```

### 4. target에 deploy
```bash
vlocity -sfdx.username <target-alias> -job <job-file>.yaml packDeploy
vlocity -sfdx.username <target-alias> -job <job-file>.yaml packRetry
```

### 5. 중단된 작업 continue
```bash
vlocity -sfdx.username <target-alias> -job <job-file>.yaml packContinue
```

### 6. 배포 후 parity 검증
```bash
vlocity -sfdx.username <target-alias> -job <job-file>.yaml packGetDiffs
```

Job-file starter: `references/job-file-template.md`.

### CI/CD Guidance — 기본 파이프라인
1. org 인증(`sf org login ...`) 2. 로컬 무결성 검증(`validateLocalData`) 3. 변경 scope export(`packExport`·manifest) 4. deploy(`packDeploy`) 5. retry 루프(`packRetry`) 안정될 때까지 6. 비교(`packGetDiffs`)·배포 리포트 발행. 증분 배포 최적화: `gitCheck: true`, `gitCheckKey: <folder>`, `manifest`(결정적 scope 제어).

---

## 핵심 규칙·가드레일

### Gotchas — Error / 증상 → 원인 → 기본 fix
| Error / symptom | Likely cause | Default fix direction |
|---|---|---|
| `No match found for ...` | target org에 의존성 누락 | 누락 DataPack key 포함 후 재배포 |
| `Duplicate Results found for ... GlobalKey` | target에 중복 레코드 | 중복 정리 후 재배포 |
| `Multiple Imported Records ... same Salesforce Record` | source 중복 matching-key 레코드 | source 중복 제거 후 재export |
| `No Configuration Found` | 오래된 DataPack 설정 | `packUpdateSettings` 실행 또는 `autoUpdateSettings` 활성 |
| `Some records were not processed` | 설정 mismatch / 부분 의존성 상태 | 양 org 설정 refresh 후 retry |
| SASS / template compile 실패 | 참조 UI 템플릿 asset 누락 | 참조 템플릿 의존성 먼저 export/deploy |

상세 매트릭스: `references/troubleshooting-matrix.md`.

### Output Expectations — 완료 블록
```text
// 구조 예시 — 실제 동작 설정 아님
DataPack goal: <export / deploy / retry / diff / ci-cd>
Source org: <alias or N/A>
Target org: <alias or N/A>
Scope: <job file + manifest/key/full>
Result: <passed / failed / partial>
Key findings: <errors, dependencies, retries, diffs>
Next step: <safe follow-up action>
```

---

## 번들 파일

| 경로 | 용도 |
|------|------|
| `references/job-file-template.md` | job file 구조 baseline 구성 참조 |
| `references/troubleshooting-matrix.md` | deploy 실패 진단·fix 방향 |
| `examples/business-internet-plus-bundle/TRANSCRIPT.md` | Product2 번들 validation 계획·실행 예제 |
| `examples/business-internet-plus-bundle/deploy-business-internet-plus-bundle.yaml` | scope 제한 `validateLocalData` job file 예제 |
| `examples/business-internet-plus-bundle-deploy/TRANSCRIPT.md` | `packDeploy`·`packRetry` 포함 full deploy 사이클 예제 |
| `examples/business-internet-plus-bundle-deploy/deploy-business-internet-plus-bundle.yaml` | manifest targeting 단계적 배포 job file 예제 |

---

## 관련 노트
- [[omnistudio-epc-catalog-generate]]
- [[omnistudio-dependencies-analyze]]
- [[omnistudio-datamapper-generate]]
- [[omnistudio-integration-procedure-generate]]
