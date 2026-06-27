---
tags: [agent-skill, sf-skills, platform, data, bulk-api, test-data]
source: forcedotcom/sf-skills (skills/platform-data-manage/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-data-manage, 데이터 작업, Salesforce data operations, sf data CLI, 테스트 데이터 생성, bulk import export, 데이터 정리]
---

# platform-data-manage — Salesforce 데이터 작업 전문가

> 레코드 CRUD·대량 import/export·테스트 데이터 생성·정리 스크립트·Apex data factory 패턴을 sf CLI와 anonymous Apex로 수행. 130점 채점.

---

## 목적과 활성화 조건

`metadata.version: 1.1`

**TRIGGER when:** 테스트 데이터 생성, 대량 import/export, `sf data` CLI 명령 사용, Apex 테스트용 data factory 패턴 필요, 또는 org에 레코드 seed/clean이 필요할 때.

**DO NOT TRIGGER:** SOQL 작성만 할 때(→ `platform-soql-query`), Apex 테스트 실행(→ `platform-apex-test-run`), 메타데이터 배포(→ `platform-metadata-deploy`).

### 이 스킬이 작업을 소유할 때
- `sf data` CLI 명령
- 레코드 create·update·delete·upsert·export·tree import/export
- 현실적 테스트 데이터 생성
- 대량 데이터 작업과 정리
- 데이터 seeding/rollback용 Apex anonymous 스크립트

### 다른 곳에 위임
- SOQL만 작성 → `platform-soql-query`
- Apex 테스트 실행/수리 → `platform-apex-test-run`
- 먼저 메타데이터 배포 → `platform-metadata-deploy`
- 커스텀 오브젝트/필드 생성·수정 → `platform-custom-object-generate` 또는 `platform-custom-field-generate`

### 모드 결정 (먼저 확인)
| Mode | 사용 시점 |
|---|---|
| Script generation | org 건드리지 않고 재사용 `.apex`·CSV·JSON 자산만 원할 때 |
| Remote execution | 실제 org에 레코드를 지금 생성/변경할 때 |

사용자가 스크립트만 원할 수 있으면 remote execution을 가정하지 않는다.

### 먼저 수집할 컨텍스트
대상 오브젝트 · org alias(remote 시) · 작업 유형(query/create/update/delete/upsert/import/export/cleanup) · 예상 볼륨 · 테스트/마이그레이션/일회성 troubleshooting 데이터 여부 · 먼저 존재해야 할 parent-child 관계.

---

## 워크플로 / 단계

### 1. 전제조건 검증
오브젝트/필드 가용성, org 인증, 필요한 parent 레코드 확인.

### 2. 스키마 불확실 시 describe-first 사전검증
레코드 생성/수정 전 object describe 데이터로 검증: required 필드 · createable vs non-createable 필드 · picklist 값 · relationship 필드와 parent 요구사항. `sf sobject describe` + jq 필터 패턴은 `references/sf-cli-data-commands.md` 참조.

### 3. 가장 작은 올바른 메커니즘 선택
| 필요 | 기본 접근 |
|---|---|
| 소량 일회성 CRUD | `sf data` 단일 레코드 명령 |
| 대량 import/export | Bulk API 2.0 (`sf data ... bulk`) |
| parent-child seed 세트 | tree import/export |
| 재사용 테스트 데이터셋 | factory / anonymous Apex 스크립트 |
| 되돌릴 수 있는 실험 | cleanup 스크립트 또는 savepoint 기반 접근 |

### 4. 실행 또는 자산 생성
`assets/` 하위 내장 템플릿 활용(factories/bulk/cleanup/soql/csv/json).

### 5. 결과 검증
생성/수정 후 count, 관계, 레코드 ID 확인.

### 6. 제한된 retry 전략 적용
생성 실패 시: ① primary CLI shape 1회 시도 → ② 파라미터 수정 후 1회 재시도 → ③ describe 재실행/가정 검증 → ④ 다른 메커니즘으로 pivot 또는 수동 workaround 제공. **같은 실패 명령을 무한 반복 금지.**

### 7. 정리 가이드 남기기
데이터를 생성했으면 항상 정확한 cleanup 명령 또는 rollback 자산 제공.

### CLI 명령 (verbatim — `references/sf-cli-data-commands.md`)
```bash
# SOQL Query
sf data query \
  --query "SELECT Id, Name FROM Account LIMIT 10" \
  --target-org myorg \
  --json

# Bulk Export
sf data export bulk \
  --query "SELECT Id, Name FROM Account" \
  --output-file accounts.csv \
  --target-org myorg \
  --wait 30

# Create Record
sf data create record \
  --sobject Account \
  --values "Name='Acme' Industry='Technology'" \
  --target-org myorg

# Update Record
sf data update record \
  --sobject Account \
  --record-id 001XXXXXXXXXXXX \
  --values "Industry='Healthcare'" \
  --target-org myorg
```

---

## 핵심 규칙·가드레일

### Core Operating Rules
- 사용자가 명시적으로 로컬 스크립트 생성을 원하지 않는 한 **remote org 데이터에 작용**한다.
- 데이터 생성 전 오브젝트·필드가 이미 존재해야 한다.
- 자동화 테스트 시 bulk 동작이 중요하면 **251+ 레코드** 선호.
- 대량/noisy 데이터셋 생성 전 cleanup 계획. untracked 레코드는 run마다 누적되어 org 상태를 오염시킨다.
- 테스트 레코드에 synthetic·non-identifying 데이터 사용 — 실제 PII는 compliance 위험이며 bulk import 후 안전히 제거 불가.
- 단순 CRUD는 **CLI-first**; 서버측 orchestration이 진짜 필요할 때만 anonymous Apex.
- 메타데이터 누락 시 중단하고 `platform-custom-object-generate`/`platform-custom-field-generate`로 스키마 생성 후 `platform-metadata-deploy`로 배포 → 재시도.

### High-Signal Rules
- **Bulk safety:** 대량 볼륨엔 bulk; 자동화 민감 동작은 251+ 레코드; bulk 시나리오에 one-record-at-a-time 회피.
- **Data integrity:** required 필드 포함 · picklist 값 사전검증 · parent ID/관계 무결성 검증 · validation rule·duplicate 제약 고려 · non-createable 필드 payload에서 제외.
- **Cleanup discipline:** delete-by-ID / delete-by-pattern / delete-by-created-date window / rollback·savepoint 중 하나 선호.

### Common Failure Patterns
| Error | 원인 | 수정 방향 |
|---|---|---|
| `INVALID_FIELD` | 잘못된 필드 API명 또는 FLS 이슈 | 스키마·접근 검증 |
| `REQUIRED_FIELD_MISSING` | 필수 필드 누락 | describe 데이터의 required 값 포함 |
| `INVALID_CROSS_REFERENCE_KEY` | 잘못된 parent ID | parent 먼저 생성/검증 |
| `FIELD_CUSTOM_VALIDATION_EXCEPTION` | validation rule이 차단 | 유효 테스트 데이터 사용/setup 조정 |
| invalid picklist value | describe 대신 추측 값 | picklist 값 먼저 확인 |
| non-writeable field error | createable/updateable 아님 | payload에서 제거 |
| bulk limits / timeouts | 볼륨에 맞지 않는 도구 | bulk / staged import로 전환 |

### Output Format
순서: ① 수행 작업 ② 오브젝트·count ③ 대상 org/로컬 artifact 경로 ④ 레코드 ID/출력 파일 ⑤ 검증 결과 ⑥ cleanup 지침.

```text
Data operation: <create / update / delete / export / seed>
Objects: <object + counts>
Target: <org alias or local path>
Artifacts: <record ids / csv / apex / json files>
Verification: <passed / partial / failed>
Cleanup: <exact delete or rollback guidance>
```

### Score Guide (130점)
| Score | 의미 |
|---|---|
| 117+ | 강한 production-safe 데이터 워크플로 |
| 104–116 | minor 개선 여지 있는 good 작업 |
| 91–103 | 허용 가능하나 검토 권고 |
| 78–90 | partial / risky 패턴 존재 |
| < 78 | 수정 전까지 차단 |

---

## 번들 파일

`assets/`:
- `factories/` — Apex test data factory(account·contact·opportunity·lead·user·case·task·event·custom-object·hierarchy)
- `bulk/` — Bulk API 2.0 Apex 템플릿(insert 200/500/10000, upsert by external ID)
- `cleanup/` — delete-by-name·delete-by-created-date·delete-test-data·rollback-transaction
- `soql/` — aggregate·subquery·parent-to-child·child-to-parent·polymorphic
- `csv/` — Account·Contact·Opportunity·custom-object import 템플릿
- `json/` — tree import(account-contact·account-opportunity·full-hierarchy)

`references/`: sf-cli-data-commands · test-data-best-practices · orchestration · test-data-patterns · test-data-factory-usage · soql-relationship-guide · relationship-query-examples · bulk-operations-guide · cleanup-rollback-guide · cleanup-rollback-example · crud-workflow-example · bulk-testing-example · anonymous-apex-guide · governor-limits-reference

`scripts/`:
- `soql_validator.py` — 실행 전 SOQL 검증
- `validate_data_operation.py` — 데이터 작업 사전검증(required 필드·picklist 값·createable 필드)

`README.md` · `CREDITS.md` · `SKILL.md`

### Cross-Skill Integration
| 필요 | 위임 | 이유 |
|---|---|---|
| 누락 커스텀 오브젝트 생성 | `platform-custom-object-generate` | 데이터 작업 전 스키마 존재 |
| 누락 커스텀 필드 생성 | `platform-custom-field-generate` | 필드 스키마 존재 |
| bulk-sensitive Apex 검증 실행 | `platform-apex-test-run` | 테스트 실행·커버리지 |
| 누락 스키마 먼저 배포 | `platform-metadata-deploy` | 메타데이터 준비 |
| 데이터 소비 프로덕션 Apex 구현 | `platform-apex-generate` | Apex 클래스/트리거 작성 |
| 데이터 소비 Flow 로직 구현 | `automation-flow-generate` | Flow 작성·자동화 |

---

## 관련 노트
- [[platform-soql-query]]
- [[platform-apex-test-run]]
- [[platform-apex-generate]]
