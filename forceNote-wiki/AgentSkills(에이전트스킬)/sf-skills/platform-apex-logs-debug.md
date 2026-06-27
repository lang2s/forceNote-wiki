---
tags: [agent-skill, sf-skills, platform, apex, debug-log, governor-limits]
source: forcedotcom/sf-skills (skills/platform-apex-logs-debug/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-apex-logs-debug, Apex 디버그 로그 분석, debug log analysis, governor limit 진단, stack trace 분석, 로그 troubleshooting]
---

# platform-apex-logs-debug — Salesforce 디버그 로그 분석·트러블슈팅

> 디버그 로그 근거 기반 root-cause 분석: 거버너 한도 진단, stack trace 해석, slow-query 조사, heap/CPU 압박 분석, 로그 증거 기반 reproduction-to-fix 루프. 100점 채점 루브릭 포함.

---

## 목적과 활성화 조건

`metadata.version: 1.1`

**TRIGGER when:** 사용자가 디버그 로그를 분석, 거버너 한도에 도달, stack trace를 읽거나, Salesforce org의 `.log` 파일을 다룰 때.

**DO NOT TRIGGER:** Apex 테스트 실행(→ `platform-apex-test-run`), Apex 코드 생성/수정(→ `platform-apex-generate`), Agentforce 세션 트레이싱(→ `agentforce-observe`).

### 이 스킬이 작업을 소유할 때

- Salesforce `.log` 파일
- stack trace와 예외 분석
- 거버너 한도
- SOQL / DML / CPU / heap 트러블슈팅
- 로그에서 추출한 query-plan 또는 성능 증거

### 다른 곳에 위임

- Apex 테스트 실행/수리 → `platform-apex-test-run`
- 코드 수정 생성/구현 → `platform-apex-generate`
- Agentforce 세션 트레이스/parquet 텔레메트리 디버깅 → `agentforce-observe`

### 먼저 수집할 컨텍스트

org alias · 실패 트랜잭션/사용자 흐름/테스트명 · 대략적 타임스탬프 또는 트랜잭션 윈도우 · 알려진 user/record/request ID · 목표가 진단만인지 진단+수정 루프인지.

---

## 워크플로 / 단계

### 1. 로그 검색 (Retrieve logs)
`references/cli-commands.md`의 명령으로 대상 org 로그 나열·다운로드·스트리밍.

### 2. 다음 순서로 분석
1. 진입점·트랜잭션 타입
2. 예외 / fatal 오류
3. 거버너 한도
4. 반복 SOQL / DML 패턴
5. CPU / heap hotspot
6. callout 타이밍·외부 실패

### 3. 심각도 분류
- **Critical** — 런타임 실패, hard limit, 손상 위험
- **Warning** — near-limit, non-selective 쿼리, slow path
- **Info** — 최적화 기회 또는 hygiene 이슈

### 4. 가장 작은 올바른 수정 권고
root-cause 지향 · bulk-safe · testable · rerun으로 검증 쉬움.

확장 워크플로: `references/analysis-playbook.md`.

---

## 핵심 규칙·가드레일

### Rules / Constraints

| 규칙 | 근거 |
|---|---|
| 항상 로그 증거 기반으로 수정 권고 | 추측 진단 회피 — root cause는 로그에서 추적 가능해야 함 |
| 발견된 모든 이슈에 6개 출력 필드 모두 보고 | actionable·완전한 발견 보장 |
| 모든 발견을 Critical/Warning/Info로 분류 | 우선순위 판단 지원 |
| 코드 생성은 `platform-apex-generate`에 위임 | 이 스킬은 진단; Apex 재작성 안 함 |
| 테스트 실행은 `platform-apex-test-run`에 위임 | 테스트 클래스 실행/수리 안 함 |
| `LIMIT_USAGE` 이벤트를 읽지 않고 한도 안전 가정 금지 | 실패 지점에 안 보이는 이전 작업이 한도 소비 가능 |

### High-Signal Issue Patterns

| 이슈 | 주 신호 | 기본 수정 방향 |
|---|---|---|
| SOQL in loop | 반복 호출 경로의 `SOQL_EXECUTE_BEGIN` 반복 | 한 번 쿼리, map/grouped 컬렉션 사용 |
| DML in loop | 반복 `DML_BEGIN` 패턴 | row 수집, bulk DML 한 번 |
| Non-selective query | 높은 rows scanned / 낮은 selectivity | 인덱스 필터 추가, scope 축소 |
| CPU pressure | sync 한도 근접 CPU 사용 | 알고리즘 복잡도 축소, 캐시, 유효 시 async |
| Heap pressure | sync 한도 근접 heap 사용 | SOQL for-loop로 스트림, in-memory 데이터 축소 |
| Null pointer / fatal error | `EXCEPTION_THROWN` / `FATAL_ERROR` | null 가정 guard, empty-query 처리 수정 |

확장 예제: `references/common-issues.md`.

### Gotchas

| 함정 | 해결 |
|---|---|
| 2 MB에서 로그 truncate | debug 레벨 축소(예 `ApexCode: INFO`, `ApexProfiling: FINE`) 후 재캡처 |
| 같은 이슈가 SOQL·CPU 문제로 동시 출현 | SOQL-in-loop 먼저 수정 — 보통 CPU 스파이크를 2차로 유발 |
| trace flag 설정 후 로그 안 나옴 | trace flag `ExpirationDate`가 미래인지, 올바른 user가 traced인지 확인 |
| Async 컨텍스트가 한도값 변경 | CPU 한도 async 60,000 ms vs sync 10,000 ms — 한도 플래그 전 트랜잭션 타입 확인 |
| stack trace가 user 코드가 아닌 framework 줄 가리킴 | trigger handler 위로 call stack 거슬러 originating user 코드 찾기 |

---

## 출력 형식 (Output Format)

분석 마무리 시 다음 순서로 보고: 1) What failed · 2) Where it failed(class/method/line/transaction stage) · 3) Why it failed(root cause, 증상 아님) · 4) How severe · 5) Recommended fix · 6) Verification step.

```text
Issue: <summary>
Location: <class / line / transaction>
Root cause: <explanation>
Severity: Critical | Warning | Info
Fix: <specific action>
Verify: <test or rerun step>
```

### Score Guide (100점)

| Score | 의미 |
|---|---|
| 90+ | 강한 fix 가이드의 expert 분석 |
| 80–89 | minor gap 있는 good 분석 |
| 70–79 | 허용 가능하나 2차 이슈 놓칠 수 있음 |
| 60–69 | partial 진단만 |
| < 60 | 불완전 분석 |

---

## 번들 파일

`references/`:
- `analysis-playbook.md` — 여기서 시작, 확장 step-by-step 워크플로
- `common-issues.md` — SOQL/DML in loop, CPU/heap, null pointer 빠른 lookup
- `cli-commands.md` — 디버그 로그 검색·스트리밍·관리 SF CLI 명령
- `debug-log-reference.md` — event type 카탈로그, 로그 레벨, 거버너 한도 reference 값
- `log-analysis-tools.md` — Apex Log Analyzer, Developer Console, CLI grep 패턴
- `benchmarking-guide.md` — 성능 벤치마킹 기법·데이터·anti-pattern
- `scoring-rubric.md` — 100점 채점 루브릭

`assets/` (Apex):
- `benchmarking-template.cls` — Anonymous Apex 벤치마크 템플릿
- `cpu-heap-optimization.cls` — CPU/heap 절감 패턴
- `dml-in-loop-fix.cls` — DML-in-loop before/after
- `soql-in-loop-fix.cls` — SOQL-in-loop before/after
- `null-pointer-fix.cls` — null pointer guard 패턴

`README.md` · `CREDITS.md` · `SKILL.md`

### Cross-Skill Integration

| 필요 | 위임 대상 | 이유 |
|---|---|---|
| Apex 수정 구현 | `platform-apex-generate` | 코드 변경 생성/리뷰 |
| 테스트로 재현 | `platform-apex-test-run` | 테스트 실행·커버리지 루프 |
| 수정 배포 | `platform-metadata-deploy` | 배포 오케스트레이션 |
| 디버깅 데이터 생성 | `platform-data-manage` | 타깃 seed/repro 데이터 |

---

## 관련 노트
- [[platform-apex-generate]]
- [[platform-apex-test-run]]
- [[platform-apex-test-generate]]
