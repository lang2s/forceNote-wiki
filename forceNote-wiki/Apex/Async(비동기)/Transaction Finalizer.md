---
tags: [apex, async, queueable, finalizer, transaction-finalizer, error-handling]
source: salesforce_apex_developer_guide.pdf
created: 2026-07-08
aliases: [Transaction Finalizer, 트랜잭션 파이널라이저, System.Finalizer, FinalizerContext, attachFinalizer, ParentJobResult]
---

# Transaction Finalizer

> `System.Finalizer`는 Queueable 잡이 unhandled exception으로 롤백돼도 **반드시 실행되는 유일한 사후 훅**이다. 잡 성공/실패 결과에 따라 재시도·알림·로깅 등 복구 액션을 붙일 수 있다.

---

## 왜 필요한가 — 롤백돼도 실행되는 유일한 훅

Queueable 잡이 `execute()` 도중 잡히지 않은 예외로 실패하면, 그 트랜잭션의 DML은 전부 롤백된다. Transaction Finalizer 이전에는 비동기 잡 실패에 대해 취할 수 있는 조치가 두 가지뿐이었다.

- `AsyncApexJob`을 SOQL로 폴링해 상태를 확인하고 실패 시 재큐잉
- Batch Apex 메서드가 unhandled exception을 만나면 `BatchApexErrorEvent` 발행

Transaction Finalizer는 Queueable 잡에 **사후 액션 시퀀스(post-action sequence)** 를 직접 부착해, 잡 실행 결과(성공/실패)에 따라 관련 액션을 취하게 해 준다. 핵심은 **Queueable 잡과 Finalizer가 서로 다른 Apex·Database 트랜잭션에서 실행된다**는 점이다. 따라서 Queueable이 롤백돼도 Finalizer는 별도 트랜잭션으로 실행되며, 이것이 실패한 잡을 사후 처리할 수 있는 이유다.

```apex
// 구조 예시 — 최소 골격
public class MyFinalizer implements Finalizer {
    public void execute(FinalizerContext ctx) {
        if (ctx.getResult() == ParentJobResult.UNHANDLED_EXCEPTION) {
            // Queueable이 롤백된 뒤에도 이 블록은 실행된다
            Exception e = ctx.getException();
            System.debug('Job failed: ' + e.getMessage());
        }
    }
}
```

특징:

- Finalizer는 **inner class로 구현 가능**하며, **한 클래스가 Queueable과 Finalizer 인터페이스를 동시에 구현**할 수도 있다.
- Queueable은 DML을, Finalizer는 REST callout을 포함하는 식으로 서로 다른 작업을 나눌 수 있다 (별개 트랜잭션이므로).
- Finalizer 사용은 **일일 Async Apex 한도의 추가 실행으로 집계되지 않는다.**

---

## `System.Finalizer` 인터페이스

`execute` 메서드 하나를 포함한다.

```apex
global void execute(System.FinalizerContext ctx) {}
```

이 메서드는 finalizer가 부착된 enqueue된 잡마다, 제공된 `FinalizerContext` 인스턴스에 대해 호출된다. `execute` 안에서 Queueable 잡 종료 시점에 취할 액션을 정의한다. `System.FinalizerContext` 인스턴스는 Apex 런타임 엔진이 `execute` 메서드의 인자로 주입한다.

---

## `System.FinalizerContext` 인터페이스 — 메서드 전수 (4개)

| 메서드 | 시그니처 | 반환/설명 |
|---|---|---|
| `getAsyncApexJobId` | `global Id getAsyncApexJobId {}` | 이 finalizer가 정의된 Queueable 잡의 ID 반환. `AsyncApexJob` 테이블과 상관(correlate)할 때 사용. |
| `getRequestId` | `global String getRequestId {}` | 요청을 유일하게 식별하는 request ID(String) 반환. **Event Monitoring 로그와 상관** 가능. Queueable 잡과 Finalizer 실행은 **동일한 request ID를 공유**한다. |
| `getResult` | `global System.ParentJobResult getResult {}` | 부모 Queueable 잡의 결과를 나타내는 `System.ParentJobResult` enum 반환 (`SUCCESS` / `UNHANDLED_EXCEPTION`). |
| `getException` | `global System.Exception getException {}` | `getResult`가 `UNHANDLED_EXCEPTION`일 때 Queueable 잡이 실패한 예외를 반환. 그 외에는 `null`. |

> `AsyncApexJob` 테이블과 상관하려면 `getRequestId`가 아니라 `getAsyncApexJobId`를 쓴다. request ID는 Event Monitoring 로그 상관용이다.

### `System.ParentJobResult` enum

부모 비동기 Queueable 잡의 결과를 나타낸다.

| 값 | 의미 |
|---|---|
| `SUCCESS` | 부모 Queueable 잡이 성공적으로 완료됨 |
| `UNHANDLED_EXCEPTION` | 부모 Queueable 잡이 잡히지 않은 예외로 실패함 |

---

## `System.attachFinalizer` — finalizer 부착

Queueable의 `execute()` 안에서 `System.attachFinalizer` 메서드로 finalizer를 부착한다.

```apex
global void attachFinalizer(Finalizer finalizer) {}
```

절차:

1. `System.Finalizer` 인터페이스를 구현하는 클래스를 정의한다.
2. Queueable 잡의 `execute` 메서드 **안에서** `System.attachFinalizer`를 호출하되, 인자로 `System.Finalizer`를 구현한 인스턴스화된 클래스를 넘긴다.

```apex
public class MyQueueable implements Queueable {
    public void execute(QueueableContext ctx) {
        // finalizer 부착 — Queueable execute 컨텍스트 안에서만 유효
        System.attachFinalizer(new MyFinalizer());
        // ... 실제 작업 ...
    }
}
```

### 구현 상세 (Implementation Details)

- **Queueable 잡 하나에는 finalizer 인스턴스를 오직 1개만 부착**할 수 있다.
- finalizer의 `execute` 구현 안에서 비동기 Apex 잡(Queueable, Future, Batch)을 **1개** enqueue할 수 있다.
- finalizer 구현 안에서 **callout이 허용**된다.
- Finalizer 프레임워크는 Queueable 실행 종료 시점의 Finalizer 객체 상태를 사용한다. 즉 **부착 이후 Finalizer 상태 변경(mutation)이 지원**된다.
- `transient`로 선언한 변수는 직렬화/역직렬화에서 무시되므로 Transaction Finalizer에 persist되지 않는다.

---

## 거버너 한도

Finalizer 트랜잭션에는 **동기(synchronous) 거버너 한도**가 적용된다. 단, 아래 항목은 예외적으로 **비동기 한도**가 적용된다.

- Total heap size (총 힙 크기)
- `System.enqueueJob`으로 큐에 추가되는 최대 Apex 잡 수
- Apex 호출당 허용되는 `future` 애노테이션 메서드 최대 수

---

## 패턴 1 — 재시도 (실패 시 재큐잉)

Unhandled exception으로 실패한 Queueable 잡은 transaction finalizer가 **연속으로 최대 5번 재큐잉**할 수 있다. 이 한도는 연속된 Queueable 잡 실패 시퀀스에 적용되며, Queueable 잡이 unhandled exception 없이 완료되면 카운터가 리셋된다.

```apex
// 출처: salesforce_apex_developer_guide.pdf — Retry Queueable Example (요약 발췌)
public class RetryLimitDemo implements Finalizer, Queueable {
    // Queueable implementation
    public void execute(QueueableContext ctx) {
        String jobId = '' + ctx.getJobId();
        try {
            Finalizer finalizer = new RetryLimitDemo();
            System.attachFinalizer(finalizer);
            Integer accountNumber = 1;
            while (true) { // results in limit error
                Account a = new Account();
                a.Name = 'Account-Number-' + accountNumber;
                insert a;
                accountNumber++;
            }
        } catch (Exception e) {
            System.debug('Error executing the job [' + jobId + ']: ' + e.getMessage());
        } finally {
            System.debug('Completed: execution of queueable job: ' + jobId);
        }
    }

    // Finalizer implementation
    public void execute(FinalizerContext ctx) {
        String parentJobId = '' + ctx.getAsyncApexJobId();
        if (ctx.getResult() == ParentJobResult.SUCCESS) {
            System.debug('Parent queueable job [' + parentJobId + '] completed successfully.');
        } else {
            System.debug('Parent queueable job [' + parentJobId + '] failed due to unhandled exception: '
                + ctx.getException().getMessage());
            // 재큐잉 — 체이닝 한도 5회 초과 시 이 호출은 실패한다
            String newJobId = '' + System.enqueueJob(new RetryLimitDemo());
            System.debug('Enqueued new job: ' + newJobId);
        }
    }
}
```

---

## 패턴 2 — 로깅 (성공/실패 무관하게 커밋)

Finalizer는 별도 트랜잭션이므로, Queueable이 롤백돼도 버퍼링해 둔 로그를 커밋할 수 있다. Finalizer 상태(state)는 부착 이후에도 변경 가능하므로, Queueable 실행 중 `addLog()`로 버퍼에 쌓은 뒤 Finalizer의 `execute`에서 DB에 커밋한다.

```apex
// 출처: salesforce_apex_developer_guide.pdf — Logging Finalizer Example (요약 발췌)
public class LoggingFinalizer implements Finalizer, Queueable {
    private List<LogMessage__c> logRecords = new List<LogMessage__c>();

    public void execute(QueueableContext ctx) {
        String jobId = '' + ctx.getJobId();
        try {
            LoggingFinalizer f = new LoggingFinalizer();
            System.attachFinalizer(f); // 또는 System.attachFinalizer(this)
            f.addLog('About to do some work...', jobId);
            while (true) { /* Results in limit error */ }
        } catch (Exception e) {
            System.debug('Error executing the job [' + jobId + ']: ' + e.getMessage());
        }
    }

    public void execute(FinalizerContext ctx) {
        String parentJobId = ctx.getAsyncApexJobId();
        for (LogMessage__c log : logRecords) {
            log.Request__c = parentJobId; // 또는 ctx.getRequestId()
        }
        Database.insert(logRecords, false); // Queueable이 실패해도 별도 트랜잭션이라 커밋됨
        if (ctx.getResult() == ParentJobResult.SUCCESS) {
            System.debug('Parent queueable job [' + parentJobId + '] completed successfully.');
        } else {
            System.debug('failed due to unhandled exception: ' + ctx.getException().getMessage());
        }
    }

    public void addLog(String message, String source) {
        logRecords.add(new LogMessage__c(
            DateTime__c = DateTime.now(), Message__c = message,
            Request__c = 'setbeforecommit', Source__c = source));
    }
}
```

---

## Considerations & Best Practices

- **미실행 가능성**: 잡 요청이 예기치 않게 종료되면(예: 시스템 업그레이드 중 데이터베이스 셧다운) transaction finalizer가 실행되지 못할 수 있다. Finalizer는 "거의 항상" 실행되지만 절대 보장은 아니다.
- **ISV 주의**: 패키지에서 상태 변경(state-mutating) 메서드를 가진 global Finalizer 사용에 주의한다. 구독자 org 구현이 그런 메서드를 호출하면 예기치 않은 동작이 발생할 수 있다.

---

## 에러 메시지 (Apex 디버그 로그)

| 에러 메시지 | 실패 컨텍스트 | 원인 |
|---|---|---|
| More than one Finalizer cannot be attached to same Async Apex Job | Queueable Execution | 같은 Queueable 인스턴스에서 `System.attachFinalizer()`가 두 번 이상 호출됨 |
| Class {0} must implement the Finalizer interface | Queueable Execution | `attachFinalizer()`에 넘긴 클래스가 `System.Finalizer`를 구현하지 않음 |
| System.attachFinalizer(Finalizer) is not allowed in this context | Non-Queueable Execution | Queueable 인스턴스를 실행 중이지 않은 Apex 컨텍스트에서 호출됨 |
| Invalid number of parameters | Queueable Execution | `attachFinalizer()`에 잘못된 수의 파라미터 전달 |
| Argument cannot be null | Queueable Execution | `attachFinalizer()`에 null 파라미터 전달 |

> Splunk Add-On 사용 시 Splunk 로그에는 `Error processing finalizer for queueable job id: {0}` 형태로 런타임 에러(unhandled/uncatchable 예외, LimitException, 내부 시스템 에러)가 기록된다.

---

## 관련 노트

- [[Queueable]] — Finalizer가 부착되는 대상 프레임워크
- [[Queueable 체이닝]] — 체이닝 에러 핸들링에 Finalizer 활용 (상세 레퍼런스는 이 노트로 위임)
- [[Apex MOC]]
