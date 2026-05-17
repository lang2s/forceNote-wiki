---
tags: [apex, async, batch, pattern]
source: apex-recipes/BatchApexRecipes.cls
created: 2026-05-17
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

> [!tip] 부분 성공 처리
> `Database.update(scope, false)`(allOrNothing=false)로 실패한 레코드만 건너뛰고 성공한 레코드를 처리할 수 있다. `Database.SaveResult.isSuccess()`로 각 레코드 결과를 확인한다.

> [!tip] QueryLocator vs Iterable
> - `Database.QueryLocator`: SOQL 결과 최대 5천만 건, 힙 한도 우회
> - `Iterable<SObject>`: 복잡한 필터링이 필요할 때, 최대 5만 건

---

## 관련 노트

- [[비동기 컨텍스트 선택]]
- [[Scheduled Apex]]
- [[testVisible 회로차단기]]
