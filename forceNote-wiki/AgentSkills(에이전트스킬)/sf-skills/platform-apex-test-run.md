---
tags: [agent-skill, sf-skills, platform, apex, testing, code-coverage]
source: forcedotcom/sf-skills (skills/platform-apex-test-run/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-apex-test-run, Apex 테스트 실행, test execution, code coverage 분석, test-fix loop, 실패 테스트 수정]
---

# platform-apex-test-run — Apex 테스트 실행·커버리지 분석

> Apex 테스트 실행, 커버리지 분석, 실패 해석, 규율 있는 test-fix 루프 관리. 120점 채점 루브릭 포함.

---

## 목적과 활성화 조건

`metadata.version: 1.1`

**TRIGGER when:** 사용자가 Apex 테스트를 실행, 코드 커버리지를 확인, 실패 테스트를 수정하거나, `*Test.cls`/`*_Test.cls` 파일을 다룰 때.

**DO NOT TRIGGER:** Apex 프로덕션 코드 작성(→ `platform-apex-generate`), Agentforce agent 테스트(→ `agentforce-test`), Jest/LWC 테스트(→ `experience-lwc-generate`).

### 이 스킬이 작업을 소유할 때
- `sf apex run test` 워크플로
- Apex unit-test 실패
- code coverage 분석
- 미커버 줄·누락 테스트 시나리오 식별
- 구조화된 Apex test-fix 루프

### 다른 곳에 위임
- 프로덕션 Apex 작성/리팩터링 → `platform-apex-generate`
- Agentforce agent 테스트 → `agentforce-test`
- Jest LWC 테스트 → `experience-lwc-generate`

### 먼저 수집할 컨텍스트
target org alias · 테스트 scope(단일 클래스/특정 메서드/suite/local) · 커버리지 임계 기대 · 진단만 vs test-fix 루프 · 관련 test data factory 존재 여부.

---

## 워크플로 / 단계

### 1. 테스트 scope 발견
기존 테스트 클래스, 대상 프로덕션 클래스, test data factory/setup 헬퍼 식별.

### 2. 가장 작은 유용한 테스트 셋 먼저 실행
실패 디버깅 시 좁게 시작, 수정 안정화 후에만 확대.

### 3. 결과 분석
실패 메서드 · 예외 타입·stack trace · 미커버 줄/약한 커버리지 · 실패 원인이 나쁜 데이터/brittle assertion/깨진 프로덕션 로직인지.

### 4. 규율 있는 fix 루프 실행
코드 수정은 필요 시 `platform-apex-generate`에 위임 · 테스트 추가/개선 · broader regression 전 focused 테스트 rerun.

### 5. 의도적 커버리지 개선
positive path · negative/exception path · bulk path(적절 시 251+) · 관련 시 callout/async path.

---

## 핵심 규칙·가드레일

### High-Signal Rules

| 규칙 | 근거 |
|---|---|
| `SeeAllData=false` 기본 | 테스트 격리; org-specific 데이터 의존 방지 |
| 모든 테스트는 의미 있는 결과 assert | assertion 없는 테스트는 아무것도 증명 못 함, 거짓 확신 |
| bulk 동작을 251+ 레코드로 테스트 | 트리거는 200 batch 처리; 251이 경계 넘음 |
| 명료성 향상 시 factory/`@TestSetup` 사용 | 일관 데이터 생성을 한 곳에; 메서드 간 rollback |
| async는 `Test.startTest()`/`Test.stopTest()` 페어 | assertion 전 async(queueable/future) 완료 보장 |
| flaky org 의존을 테스트 안에 숨기지 않음 | org 상태 연동 간헐 실패 방지 |

### Gotchas

| 이슈 | 해결 |
|---|---|
| 로컬 통과·CI org 실패 | `SeeAllData=true` 또는 org-specific 레코드 미선언 의존 확인 |
| 리팩터 후 커버리지 급락 | focused class-level 테스트 먼저, 이후 `RunLocalTests`로 확대 확인 |
| callout 테스트 "Uncommitted work pending" 오류 | DML과 HTTP callout은 `Test.startTest()` wrapping 없이 같은 테스트 컨텍스트에서 혼합 불가 |
| 테스트에서 mock 미적용 | callout하는 코드 전에 `Test.setMock()` 호출 확인 |
| `@TestSetup` 데이터가 테스트 메서드에서 누락 | `@TestSetup` 데이터는 메서드별 commit — re-query; static 변수에 저장 금지 |

---

## 출력 형식 (Output Format)

마무리 시 순서: 1) 실행된 테스트 · 2) Pass/fail 요약 · 3) Coverage 결과 · 4) Root-cause 발견 · 5) Fix/next-run 권고.

```text
Test run: <scope>
Org: <alias>
Result: <passed / partial / failed>
Coverage: <percent / key classes>
Issues: <highest-signal failures>
Next step: <fix class, add test, rerun scope, or widen regression>
```

### Score Guide (120점)

| Score | 의미 |
|---|---|
| 108+ | 강한 프로덕션급 테스트 신뢰도 |
| 96–107 | minor gap 있는 good suite |
| 84–95 | 허용 가능하나 coverage/assertion 강화 필요 |
| < 84 | 표준 미달; 의존 전 수정 |

---

## 번들 파일

`references/`:
- `cli-commands.md` — 모든 `sf apex run test` 플래그, 출력 형식, async 실행, 커버리지 명령
- `test-patterns.md` — basic/bulk(251+)/mock callout/data factory 템플릿
- `testing-best-practices.md` — AAA 패턴, 네이밍, bulk/negative/mock 전략
- `test-fix-loop.md` — agentic test-fix 루프 구현, 실패 분석 decision tree
- `mocking-patterns.md` — HttpCalloutMock, DML mocking, StubProvider, selector mocking
- `performance-optimization.md` — 테스트 실행 시간 단축(DML/SOQL mocking, loop 최적화)

`assets/` (템플릿):
- `basic-test.cls` — `@TestSetup` + positive/negative/bulk/edge 메서드 표준 테스트
- `bulk-test.cls` — 200-record 트리거 경계 넘는 251+ bulk 테스트
- `mock-callout-test.cls` — `HttpCalloutMock` 사용 HTTP callout mock
- `test-data-factory.cls` — create/insert 헬퍼 재사용 TestDataFactory
- `dml-mock.cls` — DB-free unit 테스트용 `IDML` interface + `DMLMock`
- `stub-provider-example.cls` — `StubProvider` 기반 DI stub

`hooks/scripts/parse-test-results.py` — post-tool hook: `sf apex run test` JSON 출력 파싱, auto-fix 루프용 실패 포매팅

`README.md` · `CREDITS.md` · `SKILL.md`

### Cross-Skill Integration

| 필요 | 위임 대상 | 이유 |
|---|---|---|
| 프로덕션 코드 수정/테스트 클래스 작성 | `platform-apex-generate` | 코드 생성·수리 |
| bulk/edge-case 테스트 데이터 생성 | `platform-data-manage` | 현실적 테스트 데이터셋 |
| 갱신 테스트 org 배포 | `platform-metadata-deploy` | 배포 워크플로 |
| 상세 런타임 로그 검사 | `platform-apex-logs-debug` | 심층 실패 분석 |

---

## 관련 노트
- [[platform-apex-generate]]
- [[platform-apex-test-generate]]
- [[platform-apex-logs-debug]]
