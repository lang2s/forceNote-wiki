---
tags: [apex, async, batch, pattern, release-notes]
source: apex-recipes/BatchApexRecipes.cls; salesforce_app_limits_cheatsheet.pdf (Apex Flex Queue 동시성 한도, Tier 2); help.salesforce.com/s/articleView?id=000386672
created: 2026-05-17
aliases: [batch apex, 배치, 대용량 처리, apex cursor, batch vs cursor, test discovery api]
---

# Batch Apex

> 수만 건 이상의 대용량 데이터 처리. QueryLocator로 힙 한도 우회.

---

## 표준 패턴

```apex
// Database.Stateful: execute() 간 인스턴스 변수 상태 유지 (없으면 각 execute마다 초기화)
public with sharing class MyBatch
        implements Database.Batchable<SObject>, Database.Stateful {

    // Stateful 변수 — 모든 execute()에서 누적됨
    private List<Id> successes = new List<Id>();
    private List<Id> failures  = new List<Id>();

    // 테스트에서 의도적 실패 유발용 회로 차단기
    @testVisible private Boolean throwError = false;

    public Database.QueryLocator start(Database.BatchableContext ctx) {
        return Database.getQueryLocator([
            SELECT Id, Name FROM Account WITH USER_MODE
        ]);
    }

    public void execute(Database.BatchableContext ctx, List<Account> scope) {
        for (Account acct : scope) {
            acct.Description = 'Processed';
            if (throwError) { acct.Name = null; } // 테스트: 실패 강제
        }

        // allOrNothing=false → 부분 성공 허용
        List<Database.SaveResult> results = Database.update(scope, false);

        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) { successes.add(sr.getId()); }
            else                { failures.add(sr.getId());  }
        }
    }

    public void finish(Database.BatchableContext ctx) {
        // 완료 후 처리: 결과 이메일, 후속 배치 실행 등
        System.debug('Successes: ' + successes.size() + ', Failures: ' + failures.size());
    }
}
```

---

## 실행 방법

```apex
// 기본 실행 (배치 크기 default: 200)
Database.executeBatch(new MyBatch());

// 배치 크기 지정
Database.executeBatch(new MyBatch(), 50);

// 정기 실행 (Schedulable 대신)
System.scheduleBatch(new MyBatch(), 'Daily Batch', 1440); // 24시간마다
```

---

## 핵심 규칙

> [!warning] Database.Stateful 필수 조건
> execute() 간에 `successes`, `failures` 같은 집계 변수를 유지하려면 반드시 `Database.Stateful`을 함께 implements해야 한다. 없으면 각 execute() 호출마다 인스턴스가 새로 생성되어 변수가 초기화된다.

> [!warning] 함정 — Stateful이어도 static 변수는 유지되지 않는다
> `Database.Stateful`이 상태를 이어주는 것은 **인스턴스 멤버 변수(instance member variable)뿐**이다. **static 멤버 변수는 `Database.Stateful`을 구현해도 트랜잭션 간 값을 유지하지 못하고 매 트랜잭션(=각 execute 배치)마다 원래 값으로 리셋된다.** (공식: "When using `Database.Stateful`, only instance member variables retain their values between transactions. Static member variables don't retain their values and are reset between transactions.")
>
> 반대로 `Database.Stateful`을 **지정하지 않으면** static·instance 변수 **모두** 매 트랜잭션마다 초기값으로 되돌아간다.
>
> ```apex
> // 각 배치의 처리 건수를 누적하려는 의도
> public class CountBatch implements Database.Batchable<SObject>, Database.Stateful {
>     private Integer instanceCount = 0;   // ✅ execute() 간 누적됨 (Stateful)
>     private static Integer staticCount = 0; // ❌ 매 트랜잭션 0으로 리셋 — Stateful 무효
>     // ... start / execute 에서 두 변수를 모두 ++ 해도
>     //     finish 시점엔 instanceCount 만 총합, staticCount 는 마지막 배치분만 남음
> }
> ```
>
> 집계·카운팅에 static 변수를 쓰면 "왜 합계가 안 맞지"라는 버그가 된다. 배치 상태 누적은 **반드시 instance 변수**로 둔다.

> [!tip] 부분 성공 처리
> `Database.update(scope, false)`(allOrNothing=false)로 실패한 레코드만 건너뛰고 성공한 레코드를 처리할 수 있다. `Database.SaveResult.isSuccess()`로 각 레코드 결과를 확인한다.

> [!tip] QueryLocator vs Iterable
> - `Database.QueryLocator`: SOQL 결과 최대 5천만 건, 힙 한도 우회
> - `Iterable<SObject>`: 복잡한 필터링이 필요할 때, 최대 5만 건

---

## 동시성 한도 — Apex Flex Queue

> [!warning] org당 동시 배치 잡 5개 한도
> 한 org에서 동시에 **queued 또는 active** 상태일 수 있는 배치 잡은 **최대 5개**까지만 허용된다. 이 한도를 초과해 제출한 잡은 실패하지 않고 **Apex Flex Queue에 `Holding` 상태로 최대 100개까지** 대기했다가, 앞선 잡이 완료되면 자동으로 queued로 승격된다.
>
> - 대량 배치를 한꺼번에 `Database.executeBatch()`로 스케줄링하면 6번째부터는 즉시 실행되지 않고 Flex Queue에서 `Holding` 상태로 정체된다 — 이 한도를 모르면 "왜 배치가 안 돌지" 하는 정체를 겪는다.
> - Flex Queue(Setup → Apex Flex Queue)에서 Holding 잡의 실행 순서를 재정렬할 수 있다.
> - 한도 요약: **동시 queued/active 5개 + Holding 최대 100개**.

---

---

## 릴리즈별 변경사항

### Apex Cursor — Batch 대안 (Summer '24 v61.0 도입/Beta → Spring '26 v66.0 GA)

`Database.getCursor()`로 대용량 SOQL 결과를 커서 방식으로 처리한다. Batch Apex처럼 별도 클래스를 만들 필요 없이 단일 트랜잭션 내에서 페이지 단위로 레코드를 가져온다. **Summer '24(v61.0)에서 Beta로 도입됐고, Spring '26(v66.0)에서 GA가 됐다.**

> [!warning] fetch 거버너 한도 (근거 명시)
> `cursor.fetch(position, count)`의 `count`는 "호출당 최대 2,000건" 같은 고정 상한이 아니라 힙·행 거버너 안에서 정한다. 실제 커서 거버너는 다음과 같다(sync·async 공통):
> - **트랜잭션당 fetch 호출 최대 100회**
> - **커서 1개당 최대 5천만(50,000,000) 행**
> - **하루(24h) 최대 10,000개 커서** 생성 · 일 집계 1억 행
>
> 즉 한 커서로 5천만 행까지 커버하되, 한 트랜잭션에서 `fetch`는 100번까지만 호출할 수 있다. 페이지 크기는 힙 한도(6MB/12MB)에 맞춰 정한다.

```apex
// Cursor 생성 — SOQL을 즉시 실행하지 않고 커서 핸들만 반환
Database.Cursor cursor = Database.getCursor(
    [SELECT Id, Name, Description FROM Account WITH USER_MODE]
);

// 페이지 단위로 fetch — pageSize는 힙 한도 안에서 소규모로 (트랜잭션당 fetch 100회 상한)
Integer offset = 0;
Integer pageSize = 200;   // 힙 한도에 맞춰 조정 (고정 상한 아님)
List<Account> page;

do {
    page = (List<Account>) cursor.fetch(offset, pageSize);
    for (Account acct : page) {
        acct.Description = 'Cursor Processed';
    }
    update page;
    offset += pageSize;
} while (!page.isEmpty());

// 커서는 사용 후 반드시 닫는다
cursor.close();
```

> 근거: [Apex Cursors — Apex Developer Guide (developer.salesforce.com)](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_cursors.htm) · Spring '26 릴리즈 노트 "Apex Cursors" GA.

#### Batch Apex vs Apex Cursor 비교

| 항목 | Batch Apex | Apex Cursor |
|---|---|---|
| 트랜잭션 분리 | ✅ execute()마다 별도 트랜잭션 | ❌ 단일 트랜잭션 |
| 상태 유지 | `Database.Stateful`로 가능 | 변수 그대로 유지 (단일 트랜잭션) |
| 최대 처리 건수 | 5천만 건 (QueryLocator) | 5천만 건 (커서당) |
| 코드 복잡도 | 높음 (start/execute/finish) | 낮음 (단일 메서드) |
| 힙 한도 우회 | ✅ execute()마다 초기화 | ❌ 단일 트랜잭션 힙 공유 |
| 사용 시점 | 트랜잭션 격리가 필요한 DML | 단순 대용량 읽기·경량 처리 |
| GA 여부 | GA | **GA (Spring '26 / API v66.0)** — Summer '24(v61.0) Beta 도입 |

> [!tip] 선택 기준
> - 처리 중 실패 시 부분 롤백이 필요하다 → **Batch Apex** (`allOrNothing=false`)
> - 집계 변수(`successes`, `failures`)를 execute() 간에 누적해야 한다 → **Batch Apex** (`Database.Stateful`)
> - 단순 대용량 읽기 + 가벼운 처리, 코드를 간결하게 유지하고 싶다 → **Apex Cursor**

---

### Winter '26 (v65.0) — Test Discovery/Runner API

REST API로 Apex 테스트를 탐색하고 비동기 실행할 수 있다. CI/CD 파이프라인에서 특정 클래스/메서드만 선택해 실행하는 자동화에 활용한다.

```
# 테스트 탐색 — 실행 가능한 테스트 클래스 목록 조회
GET /services/data/v65.0/tooling/tests/

# 비동기 테스트 실행 — 특정 클래스 또는 메서드 지정 가능
POST /services/data/v65.0/tooling/runTestsAsynchronous/
```

```json
// POST body 예시 — 특정 클래스와 메서드만 실행
{
  "classNames": "MyBatchTest",
  "testLevel": "RunSpecifiedTests",
  "tests": [
    {
      "className": "MyBatchTest",
      "testMethods": ["testExecuteSuccess", "testStatefulAccumulation"]
    }
  ]
}
```

> [!note] CI/CD 활용 패턴
> - 배포 후 관련 테스트 클래스만 선택 실행 → 전체 테스트 실행 시간 단축
> - `runTestsAsynchronous` 응답의 `testRunId`로 `AsyncApexJob`을 폴링해 결과 확인
> - `Release/Winter '26` 기준 GA. Apex REST 인증은 기존 OAuth 흐름 동일.

---

## 관련 노트

- [[비동기 컨텍스트 선택]]
- [[Scheduled Apex]]
- [[testVisible 회로차단기]]
- [[Queueable]]
- [[Database Namespace 상세]] — Database.Batchable·QueryLocator·BatchableContext 상세
- [[대용량 데이터 (LDV) — 대량 로드·삭제]] — 로드 후 비동기 레코드 처리·집계에 batch Apex 활용
- [[대용량 데이터 (LDV) — 쿼리 옵티마이저·인덱싱]] — 큰 SOQL timeout 회피·aggregation 케이스에서 batch Apex chaining
- [[Release/Summer '24]]
- [[Release/Winter '26]]
