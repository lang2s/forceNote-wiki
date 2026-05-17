---
tags: [apex, async, scheduled, cron, pattern]
source: apex-recipes/ScheduledRecipes.cls
created: 2026-05-17
aliases: [Scheduled Apex, Schedulable, 스케줄 잡]
---

# Scheduled Apex

> `Schedulable` 인터페이스를 구현해 정해진 시간에 반복 실행. Cron 표현식으로 스케줄 지정. 보통 Batch Apex 실행 트리거로 사용.

---

## 기본 구조

```apex
public class DailyBatchScheduler implements Schedulable {

    public void execute(SchedulableContext ctx) {
        // 주로 Batch 실행 위임
        Database.executeBatch(new DailyCleanupBatch(), 200);
    }
}

// 스케줄 등록 (코드)
String cronExp = '0 0 2 * * ?'; // 매일 오전 2시
System.schedule('Daily Cleanup', cronExp, new DailyBatchScheduler());
```

---

## Cron 표현식

```
초 분 시 일 월 요일 [년]
0  0  2  *  *  ?      → 매일 오전 2:00:00
0  0  0  1  *  ?      → 매달 1일 자정
0  0  8  ?  *  MON    → 매주 월요일 오전 8시
0  30 9  *  *  ?      → 매일 오전 9:30
```

| 위치 | 값 범위 | 특수값 |
|---|---|---|
| 초 | 0–59 | |
| 분 | 0–59 | |
| 시 | 0–23 | |
| 일 | 1–31 | `?` (요일과 함께 사용) |
| 월 | 1–12 또는 JAN–DEC | |
| 요일 | 1–7 또는 SUN–SAT | `?` (일과 함께 사용) |
| 년 | 선택 | |

---

## CronTrigger로 스케줄 관리

```apex
// 등록된 잡 조회
List<CronTrigger> scheduled = [
    SELECT Id, CronJobDetail.Name, NextFireTime, State
    FROM CronTrigger
    WHERE CronJobDetail.Name LIKE 'Daily%'
];

// 잡 취소
for (CronTrigger ct : scheduled) {
    System.abortJob(ct.Id);
}
```

---

## Batch와 함께 사용하는 패턴

```apex
// 스케줄러 → Batch 실행 → Batch에서 다음 실행 예약 (재귀 패턴)
public class SelfReschedulingBatch
    implements Database.Batchable<SObject>, Schedulable {

    // Schedulable: 최초 실행
    public void execute(SchedulableContext ctx) {
        Database.executeBatch(this, 200);
    }

    // Batchable
    public Database.QueryLocator start(Database.BatchableContext ctx) {
        return Database.getQueryLocator([SELECT Id FROM Account]);
    }

    public void execute(Database.BatchableContext ctx, List<Account> scope) {
        // 처리 로직
    }

    public void finish(Database.BatchableContext ctx) {
        // 다음 실행 예약 (24시간 후)
        String cronExp = '0 0 2 * * ?';
        System.schedule('Daily Account Batch', cronExp, new SelfReschedulingBatch());
    }
}
```

---

## Governor Limits

| 항목 | 제한 |
|---|---|
| 동시 Scheduled Jobs | 100개 |
| 하루 실행 횟수 | 250,000 (단, 분당 1회까지만 Cron 가능) |
| execute() 내 callout | 불가 (Batch를 통해 실행해야 함) |

---

## 테스트

```apex
@isTest
static void testScheduler() {
    Test.startTest();
    String jobId = System.schedule(
        'Test Scheduler',
        '0 0 0 * * ?',
        new DailyBatchScheduler()
    );
    Test.stopTest();

    CronTrigger ct = [
        SELECT State, NextFireTime
        FROM CronTrigger
        WHERE Id = :jobId
    ];
    Assert.areEqual('WAITING', ct.State);
}
```

---

## 관련 노트

- [[비동기 컨텍스트 선택]]
- [[Batch Apex]]
- [[Queueable]]

