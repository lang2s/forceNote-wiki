---
tags: [apex, async, scheduled, cron, pattern]
source: apex-recipes/ScheduledRecipes.cls
created: 2026-05-17
aliases: [Scheduled Apex, Schedulable, 스케줄 잡]
---

# Scheduled Apex

> `Schedulable` 인터페이스를 구현해 정해진 시간에 반복 실행. Cron 표현식으로 스케줄 지정. 보통 Batch Apex 실행 트리거로 사용.

---

## 개념

`Schedulable` 인터페이스를 구현한 Apex 클래스는 **Cron 표현식**으로 지정한 시간에 자동 실행되는 예약 잡이 된다.

### 왜 존재하는가

Salesforce에서는 운영 자동화를 위해 특정 시간(매일 자정, 매주 월요일 등)에 일괄 처리 작업을 실행해야 하는 경우가 많다. Scheduled Apex는 이를 코드로 제어할 수 있게 해준다. `System.schedule()`로 등록하거나 UI(Setup → Apex Classes → Schedule Apex)에서 설정할 수 있다. 가장 흔한 패턴은 Batch Apex를 트리거하는 래퍼로 사용하는 것이다.

### 언제 쓰나

- 매일 자정, 매주 특정 요일 등 정해진 일정에 반복 작업을 실행해야 할 때
- Batch Apex를 주기적으로 자동 실행해야 할 때
- 데이터 정리, 리포트 생성, 외부 시스템 동기화 등 배치성 작업을 스케줄링할 때

단발성 비동기 처리는 `Queueable` 또는 `@future`, 즉시 실행 배치는 `Database.executeBatch()`를 직접 사용한다.

### 주요 제한사항

- `execute()` 메서드 안에서는 **Callout을 직접 실행할 수 없다.** Callout이 필요하면 `execute()` 안에서 Batch나 Queueable을 enqueue해야 한다.
- org 전체에서 동시에 예약된 잡은 최대 **100개**까지만 허용된다.
- Cron으로 지정 가능한 최소 간격은 **1분**이다 (초 단위 반복 불가).
- `System.schedule()`로 이미 같은 이름의 잡이 등록되어 있으면 예외가 발생한다. 등록 전 기존 잡을 `System.abortJob()`으로 정리해야 한다.

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

