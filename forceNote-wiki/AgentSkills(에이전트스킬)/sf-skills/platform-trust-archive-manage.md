---
tags: [agent-skill, sf-skills, platform, archive, connect-api, rtbf]
source: forcedotcom/sf-skills (skills/platform-trust-archive-manage/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-trust-archive-manage, Salesforce Archive, Trusted Services Archive, ArchiveActivity, Archive Connect API, RTBF 잊힐 권리, archive 마스킹, unarchive]
---

# platform-trust-archive-manage — Salesforce Archive 운영

> Salesforce Archive(Trusted Services Archive)를 Connect API와 `ArchiveActivity` job 객체로 운영 — search·unarchive·analyze·mask·RTBF erase·storage 확인·job 상태/로그 조회.

---

## 목적과 활성화 조건

`metadata.version: 1.0`

**ALWAYS USE** Salesforce Archive 관련 모든 작업 — Archive Connect API로 archived 레코드 search·view·unarchive·analyze·mask·erase(RTBF), `ArchiveActivity` 객체에서 job 상태 읽기.

**TRIGGER when:** Salesforce Archive / Trusted Services Archive, archive·unarchive, ArchiveActivity, archive job·policy·analyzer, archived 레코드 search, archive storage·failure log, archived 데이터의 RTBF(잊힐 권리), archived PII 마스킹 — "archive된 레코드 찾기", "archived 데이터 복원", "archive job 실패 이유", "failure log 다운로드", "archive job 모니터링" 같은 표현 포함. **설명·가이드·runbook/doc 작성 요청에도** 발동.

**SKIP when:** Archive add-on과 무관한 일반 data-export/backup, 또는 archive policy UI 메타데이터 빌드.

### Scope
- **In scope:** `/platform/data-resilience/archive/` 하위 Connect API 호출 · `ArchiveActivity` SOQL/Connect 쿼리 · job의 `ArchiveActivity` 레코드와 log-download 엔드포인트 correlate · 각 async 작업의 verify-after-write.
- **Out of scope:** archive policy/`ArchivePolicyDefinition` 메타데이터 정의 · UI 빌드 · archive 데이터 위 Flow 생성(`ArchiveActivity`는 Flow-queryable 아님) · add-on 무관 backup/export.

### Required Inputs
operation intent(search/view/unarchive/analyze/mask/RTBF/storage/job-status) · 대상 sObject(`sobjectName`, search·unarchive 필수) · 필터(search·unarchive는 `sobjectName`+≥1 필터) · log download는 완료된 job의 `requestId`(`8qv…` prefix `ArchiveActivity` Id) + `reportType`(그 activity의 `Type`).

**Preconditions:** org에 Salesforce Archive 활성(`TrustedServicesArchive`/`TrustedServicesArchiveBt` org 권한) — 모든 작업이 이를 먼저 gate. 그 위에 각 작업은 별도 user 권한 필요(단일 "archive admin" 역할 없음 — capability별 접근).

---

## 워크플로 / 단계

모든 단계는 task 내 sequential. 각 영역을 처음 다룰 때 참조 파일을 읽는다.

1. **operation 식별 + contract 읽기** — Archive API의 non-obvious contract를 general knowledge에 의존하지 말 것. 호출 구성 전 `references/connect-api-operations.md`로 각 operation의 정확한 request/response shape·required input·gotcha 로드 (예: `dateRanges` plural vs singular, `isSuccess` flag vs HTTP status, `url: null`=no log).
2. **job 상태/모니터링은 data model 읽기** — job·failure·progress·count·log 관련 시 `references/archive-activity-entity.md`로 `ArchiveActivity` 필드 reference 로드. `ArchiveActivity`는 SOQL/Connect로 쿼리 — **Flow 아님**. end-to-end 예시는 `examples/monitor-failed-jobs.md`.
3. **호출 구성·전송** — contract 정확히 준수. search는 `sobjectName`+≥1 필터; date 필터는 plural `dateRanges` 배열 `{field, from, to}` + full ISO-8601 datetime.
4. **올바른 signal에 branch** — 일부 operation은 HTTP 201 + body-level success flag(`body.statusCode`, `body.isSuccess`) 반환. operation별 신뢰할 signal은 `connect-api-operations.md` 참조; HTTP status만으로 success 가정 금지.
5. **모든 write 후 verify** — 상태 재읽기로 효과 확인. async(analyzer·RTBF·masking)는 poll할 request id 반환.

### Permissions (org gate `hasTrustedServicesArchive` 위에 capability별)
| Operation | User 권한 |
|---|---|
| `search-archived-records`, `get-search-archived-records-next-page` | `ViewSearchPage` (Archive Search — global-search path, **`ViewArchivedRecords` 아님**) |
| `search-archived-records-with-sharing-rules` (Agentforce) | `ViewArchivedRecords` |
| `unarchive-records` | `UnarchiveSdk` |
| `forget-archived-records` (RTBF) + `get-rtbf-status` | `Rtbf` |
| `mask-archived-records` + `get-masking-status` | `Rtbf` (마스킹은 RTBF와 **같은** `Rtbf` 권한 공유 — 별도 entitlement 아님) |
| `run-analyzer`, `get-analyzer-report`, `get-archive-storage-used` | `ArchiveAnalyzer` |
| `get-execution-details-stream-url`, `get-failed-records-stream-url` | `ViewActivitiesPage` (Archive Activities) |

### Verify-After-Write
| write 후 | 확인 방법 |
|---|---|
| `run-analyzer` | report populate될 때까지 `get-analyzer-report` poll |
| `unarchive-records` | `search-archived-records` 재실행 — 레코드가 archive를 떠났는지 확인 |
| `forget-archived-records` (RTBF) | 반환된 `request_id`로 `get-rtbf-status` poll |
| `mask-archived-records` | 반환된 `request_id`로 `get-masking-status` poll |

### SOQL 예시 (ArchiveActivity — Flow 아닌 SOQL/Connect)
```sql
-- 실패/진행중 archive job 조회 (예시; 정확한 필드는 archive-activity-entity.md 참조)
SELECT Id, Type, Status FROM ArchiveActivity WHERE Status = 'Failed'
```

---

## 핵심 규칙·가드레일

### Rules / Constraints
| Constraint | Rationale |
|---|---|
| search·unarchive는 `sobjectName`+≥1 필터 | controller가 unfiltered 요청을 "Search must be based on at least 1 field"로 거부 — full-object 작업 불허 |
| date 필터는 full ISO-8601 datetime(`2020-01-01T00:00:00Z`) | date-only(`2020-01-01`)는 필드가 `xsd:dateTime`이라 `400 JSON_PARSER_ERROR` |
| search는 `dateRanges`(plural 배열), unarchive는 `dateRange`(singular) | 두 엔드포인트의 genuinely 다른 필드 — 잘못된 shape는 필터 silently drop 또는 400 |
| `scroll_id == "-1"`이면 pagination 중단 | `"-1"`로 next-page 호출 시 500 |
| log download는 실제 `ArchiveActivity` Id를 `requestId`로 + activity의 `Type`을 `reportType`으로 | 백엔드가 activity 레코드로 log resolve; mismatch `reportType`은 no log |
| deprecated lookup 사용 금지 | `global-search-by-id`, `get-global-search-results`, `view-archived-records`는 successor 없이 deprecated·현재 500. `search-archived-records`(+next-page) 사용 |
| excluded 오브젝트는 retrieve 불가 | `Feed`·`History`·`Relation`·`Share` search 불가; Files/Attachments는 이 API로 retrieve 불가 — 약속 금지 |
| `ArchiveActivity`는 SOQL/Connect로만, Flow 금지 | `isProcessEnabled=false` — Flow "Get Records"가 "You can't get ArchiveActivity records in a flow."로 실패 |

### Gotchas
| Issue | Resolution |
|---|---|
| HTTP 201을 success로 취급 | 여러 operation이 201+body outcome 반환. `body.statusCode`(search)/`body.isSuccess`(with-sharing-rules)에 branch |
| `run-analyzer.isRunning`을 signal로 | **항상** `null`; 엔드포인트는 `message`만 populate. `get-analyzer-report` poll로 완료 확인 |
| `search-...-with-sharing-rules`(Agentforce) 필터를 배열로 | `filtersJson`은 JSON-encoded **object map** `{"Field":"Value"}` — 배열 형태는 `isSuccess:false "No valid filters provided"` |
| log `url`을 201이라 present로 | `get-*-stream-url`은 `{url}` 반환; `url: null`=no log resolved. 항상 `url != null` 확인 |
| `get-archive-storage-used` 오독 | `usedStorage[]`/`availableStorage[]`는 parallel positional 배열: idx 0=org DATA, 1=org FILE, 2=archive RECORDS, 3=archive FILE. `availableStorage[2]`/`[3]`은 **항상 0**(archive tier unmetered) — "full"이 아니라 "not tracked" |
| Flow에서 `ArchiveActivity` 기대 | Flow-enabled 아님(`isProcessEnabled=false`). SOQL/Connect/Reports 사용 |
| unarchive cap | 요청당 ≤1000 matched 레코드, ≤50 요청/시간/org, match별 전체 archived 계층 복원 |
| RTBF/masking cap | `criteria` ≤10 entry(오브젝트당 1) · ≤10,000 root 레코드/일(RTBF·masking 공유) · masking은 irreversible. 둘 다 같은 `Rtbf` 권한 |

### Output Expectations
knowledge/API 스킬 — API 호출과 해석 결과, `ArchiveActivity` SOQL 산출. deployable 메타데이터 생성 안 함. task별 산출물: 올바른 operation 호출 + 올바른 success-signal branching + verify-after-write 확인.

---

## 번들 파일

`references/`:
- `connect-api-operations.md` — 모든 Archive Connect API 호출 구성 전 — 전체 operation별 contract·success signal·limit
- `archive-activity-entity.md` — job-status/failure/progress/log task — `ArchiveActivity` 필드 reference + log-download 엔드포인트 link

`examples/`:
- `monitor-failed-jobs.md` — end-to-end 모니터링 플로우: 실패/진행중 job 찾고 log 다운로드

`SKILL.md`

---

## 관련 노트
- [[platform-soql-query]]
- [[platform-data-manage]]
