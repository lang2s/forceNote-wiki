---
tags: [agent-skill, sf-skills, platform, apex, testing, test-data-factory]
source: forcedotcom/sf-skills (skills/platform-apex-test-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [platform-apex-test-generate, Apex 테스트 생성, Apex test class, TestDataFactory, bulk testing, mocking, test-fix loop]
---

# platform-apex-test-generate — Apex 테스트 클래스 생성·검증

> TestDataFactory 패턴, bulk 테스트(251+ 레코드), mocking 전략, assertion 베스트 프랙티스, 규율 있는 test-fix 루프로 프로덕션급 Apex 테스트 클래스를 생성·검증.

---

## 목적과 활성화 조건

`metadata.version: 1.0`

**Use when:** 새 Apex 테스트 클래스 생성, 커버리지 개선, 실패 Apex 테스트 디버깅/수정, 테스트 실행·커버리지 분석, 트리거·서비스·컨트롤러·배치·queueable·integration의 테스팅 패턴 구현.

**Triggers on:** `*Test.cls`, `*_Test.cls` 파일, `sf apex run test` 워크플로, 커버리지 리포트, test-fix 루프.

**Do NOT trigger:** 프로덕션 Apex 코드(→ `platform-apex-generate`) 또는 Jest/LWC 테스트.

---

## 핵심 원칙 (Core Principles)

1. **메서드당 하나의 동작** — 각 테스트 메서드는 단일 시나리오 검증. positive/negative/bulk 분리. 관련-but-구별 입력(예 null과 empty)을 한 메서드에 절대 결합 금지 — `_NullInput_`, `_EmptyInput_`을 별도 메서드로
2. **테스트 bulkify** — 200-record 트리거 batch 경계를 넘도록 251+ 레코드로 테스트. **Batch Apex 예외:** 테스트 컨텍스트에서는 `execute()`가 1회만 실행되므로 `batchSize >= testRecordCount` 설정 (`references/async-testing.md`)
3. **테스트 데이터 격리** — 모든 `@TestSetup`은 레코드 생성을 `TestDataFactory`에 위임. 없으면 먼저 생성. `@TestSetup`에서 inline 리스트 구축 금지. org 데이터(`SeeAllData=false`)·하드코딩 ID 의존 금지. duplicate rule 처리는 `references/test-data-factory.md`
4. **의미 있는 assert** — 테스트 데이터 setup에서 계산한 정확한 기대값 사용. 값이 결정적일 때 range/근사 count assertion 절대 금지. 항상 실패 메시지 포함 (`references/assertion-patterns.md`)
5. **`Assert` 클래스만 사용** — `Assert.areEqual`, `Assert.isTrue`, `Assert.fail` 등. 레거시 `System.assert`/`System.assertEquals`/`System.assertNotEquals` 사용 금지
6. **외부 경계 mock** — callout에 `HttpCalloutMock`, SOSL에 `Test.setFixedSearchResults`, DB 격리에 DML mock 클래스. 생성자 주입으로 testability 설계 (`references/mocking-patterns.md`)
7. **negative path 테스트** — happy path뿐 아니라 오류 처리·예외 시나리오 검증
8. **start/stop으로 wrap** — `Test.startTest()`와 `Test.stopTest()` 페어로 거버너 한도 리셋·async 강제 실행

### Test.startTest() / Test.stopTest()

항상 테스트 대상 코드를 wrap:
- 거버너 한도 리셋 → 대상 코드만 측정
- async 작업(queueable/batch/future) 동기 실행
- 스케줄 작업 즉시 fire

---

## 워크플로 / 단계

### Step 1 — 컨텍스트 수집
대상 프로덕션 클래스, 기존 테스트 클래스/data factory/setup 헬퍼, 원하는 테스트 scope(단일/특정 메서드/suite/local), 커버리지 임계값(배포 최소 75%, 권장 90%+), org alias.

### Step 2 — 테스트 클래스 생성

**MANDATORY — File Deliverables:** 모든 테스트 클래스에 두 파일 모두 생성:
1. `{ClassName}Test.cls` (`assets/test-class-template.cls` 시작점)
2. `{ClassName}Test.cls-meta.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <status>Active</status>
</ApexClass>
```

프로젝트에 `TestDataFactory`가 없으면 `assets/test-data-factory-template.cls`로 `TestDataFactory.cls` + `.cls-meta.xml` 생성.

#### @TestSetup 예제

```apex
@TestSetup
static void setupTestData() {
    List<Account> accounts = TestDataFactory.createAccounts(251, true);
}
```

#### Test Method 구조 (Given/When/Then)

```apex
@isTest
static void shouldUpdateStatus_WhenValidInput() {
    // Given
    List<Account> accounts = [SELECT Id FROM Account];

    // When
    Test.startTest();
    MyService.processAccounts(accounts);
    Test.stopTest();

    // Then
    List<Account> updated = [SELECT Id, Status__c FROM Account];
    Assert.areEqual(251, updated.size(), 'All accounts should be processed');
}
```

#### Negative Test — Exception 패턴

```apex
@isTest
static void shouldThrowException_WhenInvalidInput() {
    // Given
    List<Account> emptyList = new List<Account>();

    // When/Then
    Test.startTest();
    try {
        MyService.processAccounts(emptyList);
        Assert.fail('Expected MyCustomException to be thrown');
    } catch (MyCustomException e) {
        Assert.isTrue(e.getMessage().contains('cannot be empty'),
            'Exception message should indicate empty input');
    }
    Test.stopTest();
}
```

#### Naming Convention
- `should[ExpectedResult]_When[Scenario]`: `shouldSendNotification_WhenOpportunityClosedWon`
- `[SubjectOrAction]_[Scenario]_[ExpectedResult]`: `AccountUpdate_ChangeName_Success`

### Step 3 — 테스트 실행
디버깅 시 좁게 시작, 수정 안정화 후 확대.

```bash
# Single test class
sf apex run test --class-names MyServiceTest --result-format human --code-coverage --target-org <alias>

# Specific test methods
sf apex run test --tests MyServiceTest.shouldUpdateStatus_WhenValidInput --result-format human --target-org <alias>

# All local tests
sf apex run test --test-level RunLocalTests --result-format human --code-coverage --target-org <alias>
```

### Step 4 — 결과 분석
실패 메서드(예외 타입·stack trace), 미커버 줄·약한 커버리지, 실패 원인이 나쁜 테스트 데이터/brittle assertion/깨진 프로덕션 로직인지.

### Step 5 — Fix Loop (최대 3 iteration)
1. 실패 테스트 클래스와 대상 클래스 읽기
2. 오류 메시지·stack trace로 root cause 식별
3. 수정 적용 — 테스트측 이슈는 데이터/assertion 조정; 프로덕션 코드 이슈는 `platform-apex-generate`에 위임
4. broader regression 전 focused 테스트 rerun
5. 전부 통과/iteration 한도 도달/설계 변경 필요까지 반복

### Step 6 — 커버리지 검증

| Level | Coverage | 목적 |
|---|---|---|
| Production deploy | 75% minimum | Salesforce 요구 |
| Recommended | 90%+ | 베스트 프랙티스 목표 |
| Critical paths | 100% | 비즈니스 핵심 코드 |

모든 path 커버: positive · negative/exception · bulk(251+) · callout/async.

---

## 핵심 규칙·가드레일

### Test Code Anti-Patterns

| Anti-Pattern | Fix |
|---|---|
| 루프 내 SOQL/DML | 루프 전 한 번 쿼리; lookup에 `Map<Id, SObject>` |
| assertion의 magic number | setup 상수에서 기대값 도출 |
| God test class (>500줄) | 동작 영역별 다수 클래스로 분할 |
| 긴 테스트 메서드 (>30줄) | Given/When/Then을 헬퍼로 추출 |
| generic `Exception` catch | 구체 기대 타입(예 `DmlException`) catch |

### What to Test by Component

| Component | 핵심 테스트 시나리오 |
|---|---|
| Trigger | Bulk insert/update/delete, recursion guard, field change 감지 |
| Service | valid/invalid 입력, bulk, 예외 처리 |
| Controller | page load, action 메서드, view state |
| Batch | start/execute/finish, scope 매칭(batch size >= record count), `Database.Stateful` 추적, 오류 처리, chaining(별도 메서드 — `finish()`의 `Database.executeBatch()` 호출은 `UnexpectedException` throw) |
| Queueable | chaining(테스트에서 첫 job만 실행), bulkification, 오류 처리, `Test.startTest()` 전 callout mock |
| Callout | success 응답, error 응답, timeout |
| Selector | valid/null/empty 입력, bulk(251+), 필드 population, sort 순서, `System.runAs` 통한 `WITH USER_MODE` |
| Scheduled | `execute(null)` 직접 실행, `CronTrigger` 쿼리로 CRON 등록 |
| Platform Event | `Test.enableChangeDataCapture()`, `Test.getEventBus().deliver()`, subscriber side effect 검증 |

### Output Expectations
테스트 클래스당: `{ClassName}Test.cls` + `.cls-meta.xml`(대상 클래스 API 버전 매칭, 기본 `66.0`) · `TestDataFactory.cls` + `.cls-meta.xml`(없을 경우).

---

## 번들 파일

`assets/`:
- `test-class-template.cls` — 테스트 클래스 시작점 템플릿
- `test-data-factory-template.cls` — TestDataFactory 템플릿

`references/` (필요 시 on-demand 로드):
- `test-data-factory.md` — TestDataFactory 패턴, field override, duplicate rule 처리
- `assertion-patterns.md` — assertion 베스트 프랙티스·anti-pattern·pitfall
- `mocking-patterns.md` — HttpCalloutMock, DML mocking, StubProvider, SOSL, Email, Platform Events
- `async-testing.md` — Batch, Queueable, Future, Scheduled 작업 테스트

`CREDITS.md` · `SKILL.md`

---

## 관련 노트
- [[platform-apex-generate]]
- [[platform-apex-test-run]]
- [[platform-apex-logs-debug]]
- [[테스트 전략]] — 테스트 방법론(Positive/Negative/Bulk) 위키 노트
- [[StubProvider]] — Stub API 모킹 패턴
- [[HttpCalloutMock]] — HTTP 콜아웃 목 테스트
