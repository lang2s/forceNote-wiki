---
tags: [agent-skill, sf-skills, devops, testing, code-analyzer]
source: forcedotcom/sf-skills (skills/analyzing-test-failures/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [analyzing-test-failures, 테스트 실패 분석, test failure 해석, Code Analyzer violation 설명, 개선 제안, plain-language explanation]
---

# analyzing-test-failures — 테스트 실패·Code Analyzer 위반 분석

> DevOps Center 테스트 실패 또는 Code Analyzer 위반 페이로드를 평이한 언어로 해석하고, 테스트별 우선순위 개선 제안을 내는 순수 추론(pure reasoning) 스킬.

---

## 목적과 활성화 조건

`metadata.version: 1.0` · `minApiVersion: 67.0`

**Type:** Pure reasoning — 시스템 호출 없음, 코드 작성 없음.

**무엇을 하는가:** 테스트 실패 또는 Code Analyzer 위반 페이로드를 파싱하여 평이한 언어 설명을 생성하고, 이어서 테스트별로 구체적·우선순위화된 개선 제안을 낸다. 각 fix가 **테스트 코드**에 속하는지 **프로덕션 코드**에 속하는지 구분한다. raw JSON, stack trace, API 오류 본문을 사용자에게 노출하지 않는다.

**TRIGGER when:** 테스트 실행 실패 후 근본 원인을 원할 때 · quality gate 실패 설명 필요 · Code Analyzer 위반을 평이한 언어로 번역 · 실패 페이로드를 공유하며 대처법을 물을 때 · 테스트가 계속 실패해 제안을 원할 때 · 커버리지 갭을 메우거나 assertion 강화, flaky/weak 테스트 수정을 원할 때.

**DO NOT TRIGGER:** fix 코드 작성을 원할 때(→ `platform-apex-generate`), 새 테스트 클래스 작성(→ `platform-apex-test-generate`).

### 사전조건 (Prerequisites)
직접 실패 페이로드를 가져와야 하면 `checking-devops-prerequisites`를 먼저 로드한 뒤 `polling-test-results`로 실행 결과를 얻는다. 페이로드가 이미 컨텍스트에 있으면 사전조건 불필요 — 순수 추론이다.

### 입력 (Inputs)
`polling-test-results` 스킬이 제공하거나 컨텍스트에 직접 붙여넣은 JSON 실패 페이로드. 실패 테스트별 필수: 테스트 메서드명 · 실패 메시지(assertion 오류 또는 예외 텍스트) · 실패 카테고리(assertion 실패, unhandled exception, timeout, compile error).

### Empty-org / no-data 케이스
페이로드에 실패·위반이 없으면 명확히 보고하고(`"No failures found in the provided execution results."`) 멈춘다. 실패·위반·개선 제안을 **fabricate 금지**.

---

## 워크플로 / 단계

### 1. 실패 카테고리 결정

| Category | Description |
|---|---|
| **Assertion failure** | 테스트 assertion 실패 (expected vs actual 불일치) |
| **Exception** | unhandled exception 발생 |
| **Code Analyzer violation** | 정적 분석 규칙 위반 (예: `ApexCRUDViolation`, `ApexSharingViolations`) |
| **Timeout** | 실행 시간 한도 초과 |
| **Compile error** | 클래스 컴파일 실패 |

### 2. 실패별 추출·평이 언어 번역
offending file·class명 · method명 · line number · 위반된 rule 또는 assertion(평이 언어) · suggested fix direction(코드 미작성).

### 3. 그룹화
하나 초과면 카테고리별로 그룹화.

### 출력 형식 (Output format)

```text
Test failure summary:

<N> failure(s) found:

1. [<Category>] `<ClassName>.cls` — `<methodName>()` at line <N>
   What happened: <plain-language description>
   Rule violated: <ruleName or assertion description>
   Fix direction: <plain-language suggestion>

2. [<Category>] `<ClassName2>.cls` — `<methodName2>()` at line <N>
   ...
```

### Code Analyzer 위반
위반에는 항상 포함: rule명을 평이 영어로 번역(예: `ApexCRUDViolation` → "A SOQL query was made without checking object-level permissions first") · 정확한 line number · fix direction(예: "Add a `Schema.sObjectType.Account.isAccessible()` check before the query").

---

## 핵심 규칙·가드레일

### Plain-language rule
raw stack trace, JSON 페이로드, 내부 Salesforce 오류 코드를 출력에 붙여넣지 않는다. 항상 file명·method·line·평이 설명으로 번역.

### 개선 제안 (Suggesting improvements)
**테스트 실행이 실패로 완료된 이후에만** 호출 — 정적 소스 코드에 대해서가 아니다. 실패 메시지가 primary signal: 테스트가 기대한 것 vs 실제 일어난 것을 기술한다.

**1 — 각 실패 메시지 읽기:** 테스트 메서드명 · 실패 메시지 · 실패 카테고리 추출.

**2 — 테스트가 처리하지 못하는 것 추론:**

| Failure pattern | Improvement suggestion |
|---|---|
| `NullPointerException` | null 입력 미처리 — null 체크 또는 데이터 존재 보장 setup 추가 |
| `Assertion failed: expected X but was Y` | assertion의 expected 값이 틀렸거나 test data setup이 올바른 상태를 만들지 못함 |
| `List has no rows for assignment` | 존재하지 않는 데이터 query — test setup 불완전 |
| `System.LimitException: Too many SOQL queries` | governor limit 도달 — 대상 코드나 setup이 query 과다 |
| `Insufficient access rights on cross-reference id` | 테스트 유저 권한 부족 — 적절 profile/permission set 유저로 실행 필요 |
| `DML currently not allowed` | DML 불허 컨텍스트에서 호출된 메서드 안에서 DML 수행 |
| Code Analyzer violation message | 프로덕션 코드가 규칙 위반 — 테스트가 노출했으나 fix는 프로덕션 코드에 있음 |

**3 — 실행 가능한 제안:** 실패가 드러내는 것 · 무엇을 추가/변경해야 robust한지 · fix가 **test**(assertion, setup, permissions)인지 **production code**(테스트는 옳고 대상 코드가 깨짐)인지. 테스트를 다시 쓰지 않는다 — 무엇을·왜 변경해야 하는지만 기술.

```text
Test improvement suggestions based on execution results:

`<testMethodName>()` — [Assertion Failure / Exception / etc.]
Failure: "<failure message>"
What this reveals: <plain-language explanation>
Suggestion: <specific, actionable recommendation>
Fix location: Test | Production code

Overall: <N> improvement(s) across <M> failed test(s).
```

### Test fix vs. production-code fix
- **Fix location: Production code** → 테스트가 노출한 코드 결함; 테스트 로직 자체는 건전. 테스트 품질을 근거로 suite promotion을 막아선 안 되며, 프로덕션 결함으로 별도 추적.
- **Fix location: Test** → 테스트 hardening 필요: setup 누락, 잘못된 assertion, edge case(null 입력, bulk 레코드 볼륨, 혼합 permission 컨텍스트, governor-limit 경계) 커버 부족.

---

## 번들 파일

`SKILL.md` 단일 파일(추가 references/assets 없음).

---

## 관련 노트
- [[creating-fix-work-item]]
- [[checking-devops-prerequisites]]
- [[configuring-quality-gate]]
- [[platform-apex-test-generate]]
- [[polling-test-results]] — 완료/실패 결과를 폴링해 이 분석의 입력을 제공
- [[테스트 전략]] — Apex 테스트 방법론·실패 시나리오 위키 노트
