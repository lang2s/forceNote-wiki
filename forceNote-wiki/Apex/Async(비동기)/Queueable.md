---
tags: [apex, async, queueable, pattern, release-notes]
source: apex-recipes/QueueableRecipes.cls, QueueableWithCalloutRecipes.cls
created: 2026-05-17
aliases: [queueable, 큐어블, 비동기 체이닝, elastic limits, apex cursor queueable]
---

# Queueable

> @future 보다 강력한 비동기 처리. 객체 파라미터, 체이닝, Callout 모두 가능.

---

## 개념

`Queueable`은 `@future`보다 강력한 비동기 처리 인터페이스로, 클래스 구조(SObject 포함)를 파라미터로 전달하고, 체이닝(순차 실행)이 가능하며, `AsyncApexJob`으로 실행 상태를 추적할 수 있다.

### 왜 존재하는가

`@future`는 primitive 타입 파라미터만 허용하고, 체이닝이 불가하며, 실행 상태를 조회할 방법이 없다. 복잡한 비동기 파이프라인(예: Callout → DML → 다음 단계 실행)을 구현하려면 `@future`만으로는 부족하다. `Queueable`은 이 한계를 극복하기 위해 도입되었다. 클래스 인스턴스를 그대로 큐에 넣을 수 있어 상태를 자유롭게 전달하고, `System.enqueueJob()`이 반환하는 `AsyncApexJob` ID로 실행 현황을 모니터링할 수 있다.

### 언제 쓰나

- SObject 리스트나 복잡한 데이터 구조를 비동기로 전달해야 할 때
- 비동기 작업을 순서대로 체이닝해야 할 때 (예: A 완료 후 B 실행)
- HTTP Callout과 DML을 같은 비동기 트랜잭션에서 처리해야 할 때 (`Database.AllowsCallouts` 함께 implements)
- 실행 상태(`AsyncApexJob.Status`)를 UI나 코드에서 조회해야 할 때
- `Database.Cursor`와 함께 대용량 SOQL 결과를 페이지 단위로 처리할 때

단순 비동기 처리에 SObject 전달이나 체이닝이 불필요하면 `@future`가 더 단순하다. 수만 건 이상 대용량 처리는 Batch Apex를 고려한다.

### 주요 제한사항

- 하나의 `execute()` 안에서 `System.enqueueJob()` 호출은 **1번**만 허용된다. (Summer '24 이전 기준. Cursor 연계 시 동일)
- 트랜잭션당 최대 50개의 Queueable을 enqueue할 수 있다.
- Mixed DML: Setup 오브젝트(User, PermissionSet 등)와 일반 오브젝트를 같은 트랜잭션에서 DML하면 오류가 발생한다. 체이닝으로 분리해야 한다.
- 무한 체이닝은 `AsyncOptions.MaximumQueueableStackDepth`로 최대 깊이를 설정(`System.enqueueJob(queueable, asyncOptions)`에 전달)하고, 런타임에 `System.AsyncInfo.getCurrentQueueableStackDepth()`로 현재 깊이를 확인해 방지한다. 깊이 제한 없이 체이닝하면 잡이 무한 생성된다.

---

## 기본 패턴

```apex
public with sharing class MyQueueable implements Queueable {

    private List<Account> accounts;

    public MyQueueable(List<Account> accounts) {
        this.accounts = accounts; // 객체 전달 가능 — @future 불가능
    }

    public void execute(QueueableContext qc) {
        for (Account acct : accounts) {
            acct.Description += ' Processed';
        }
        try {
            update accounts;
        } catch (DmlException e) {
            // 에러 처리
        }
    }
}

// 실행
Id jobId = System.enqueueJob(new MyQueueable(accounts));
```

---

## HTTP Callout이 필요한 경우

```apex
// Database.AllowsCallouts 를 함께 implements
public with sharing class CalloutQueueable
        implements Queueable, Database.AllowsCallouts {

    public void execute(QueueableContext qc) {
        // Callout + DML 모두 가능
        HttpResponse response = RestClient.makeApiCall(
            'MyNamedCredential',
            RestClient.HttpVerb.GET,
            'api/data'
        );
        if (response.getStatusCode() == 200) {
            // 결과로 DML 수행
        }
    }
}
```

> [!warning] Mixed DML
> Queueable 안에서 Setup 오브젝트와 일반 오브젝트를 같은 트랜잭션에서 DML하면 Mixed DML 에러 발생.
> → 체이닝으로 분리하거나 별도 Queueable로 위임.

---

## @future vs Queueable 비교

| 항목 | @future | Queueable |
|---|---|---|
| SObject 파라미터 | ❌ (primitives만) | ✅ |
| Callout | `callout=true` 옵션 필요 | `AllowsCallouts` 함께 implements |
| 체이닝 | ❌ | ✅ (execute당 1개) |
| 모니터링 | 어려움 | AsyncApexJob으로 추적 가능 |
| 트랜잭션당 한도 | 50개 | 50개 (Governor Limit 동일) |

---

## 릴리즈별 변경사항

### Winter '24 (v59.0) — 최대 체이닝 깊이 설정 GA

Developer·Trial Edition org의 기본 최대 깊이 **5**를 override해 Queueable job의 최대 stack depth를 설정할 수 있다. 설정은 `AsyncOptions` 인스턴스의 `MaximumQueueableStackDepth` property에 depth를 지정한 뒤 새 overload `System.enqueueJob(queueable, asyncOptions)`로 enqueue한다. 런타임에는 `System.AsyncInfo.getCurrentQueueableStackDepth()`로 현재 깊이를, `getMaximumQueueableStackDepth()`로 설정된 최대 깊이를 조회하고, `hasMaxStackDepth()`로 최대 깊이 설정 여부를 확인한다. runaway recursive job이 일일 async Apex 한도를 소진하는 것을 막는다.

| API | 설명 |
|---|---|
| `AsyncOptions.MaximumQueueableStackDepth` | 최대 stack depth를 설정하는 property (Integer) |
| `System.enqueueJob(queueable, asyncOptions)` | `AsyncOptions`를 받는 overload |
| `System.AsyncInfo.getCurrentQueueableStackDepth()` | 현재 Queueable stack depth 반환 |
| `System.AsyncInfo.getMaximumQueueableStackDepth()` | 최대 Queueable stack depth 반환 |
| `System.AsyncInfo.getMinimumQueueableDelayInMinutes()` | 최소 Queueable delay(분) 반환 |
| `System.AsyncInfo.hasMaxStackDepth()` | 최대 stack depth 설정 여부 반환 |

아래는 Winter '24 릴리즈 노트의 Fibonacci 예제(PDF verbatim)다. 최초 enqueue 시 `AsyncOptions.MaximumQueueableStackDepth`로 깊이를 설정하고, `execute()` 안에서 `AsyncInfo`로 현재/최대 깊이를 비교해 체이닝 종료 여부를 결정한다.

```apex
// Fibonacci
public class FibonacciDepthQueueable implements Queueable {
    private long nMinus1, nMinus2;
    public static void calculateFibonacciTo(integer depth) {
        AsyncOptions asyncOptions = new AsyncOptions();
        asyncOptions.MaximumQueueableStackDepth = depth;
        System.enqueueJob(new FibonacciDepthQueueable(null, null), asyncOptions);
    }
    private FibonacciDepthQueueable(long nMinus1param, long nMinus2param) {
        nMinus1 = nMinus1param;
        nMinus2 = nMinus2param;
    }
    public void execute(QueueableContext context) {
        integer depth = AsyncInfo.getCurrentQueueableStackDepth();
        // Calculate step
        long fibonacciSequenceStep;
        switch on (depth) {
            when 1, 2 {
                fibonacciSequenceStep = 1;
            }
            when else {
                fibonacciSequenceStep = nMinus1 + nMinus2;
            }
        }
        System.debug('depth: ' + depth + ' fibonacciSequenceStep: ' + fibonacciSequenceStep);

        if(System.AsyncInfo.hasMaxStackDepth() &&
           AsyncInfo.getCurrentQueueableStackDepth() >=
           AsyncInfo.getMaximumQueueableStackDepth()) {
            // Reached maximum stack depth
            Fibonacci__c result = new Fibonacci__c(
                Depth__c = depth,
                Result = fibonacciSequenceStep
            );
            insert result;
        } else {
            System.enqueueJob(new FibonacciDepthQueueable(fibonacciSequenceStep, nMinus1));
        }
    }
}
```

> [!tip] 무한 체이닝 차단 패턴
> 최초 enqueue 시 `AsyncOptions.MaximumQueueableStackDepth`에 최대 깊이를 설정하고, `execute()` 안에서 `System.AsyncInfo.getCurrentQueueableStackDepth()`와 `getMaximumQueueableStackDepth()`를 비교해 다음 잡 enqueue 여부를 결정한다. 무한 체이닝 버그를 런타임에서 안전하게 차단한다. (`System.maxQueueableDepth`라는 API는 존재하지 않는다 — 정확한 정의는 [[Release/Winter '24/Development]] 참고.)

---

### Summer '24 (v61.0) — Apex Cursor와 Queueable 체이닝 연계

`Database.getCursor()`로 만든 Cursor를 Queueable에 넘겨 대용량 데이터를 페이지 단위로 처리할 수 있다. Batch Apex 없이 단일 Queueable 클래스에서 대용량 SOQL을 처리하는 패턴.

```apex
// Cursor를 생성해 Queueable에 전달
Database.Cursor cursor = Database.getCursor(
    [SELECT Id, Name FROM Account WITH USER_MODE]
);
System.enqueueJob(new CursorQueueable(cursor, 0));

// Queueable 안에서 페이지 단위 처리 후 재귀 체이닝
public class CursorQueueable implements Queueable {
    private Database.Cursor cursor;
    private Integer offset;
    private static final Integer PAGE_SIZE = 2000;

    public CursorQueueable(Database.Cursor cursor, Integer offset) {
        this.cursor = cursor;
        this.offset = offset;
    }

    public void execute(QueueableContext ctx) {
        List<Account> page = (List<Account>) cursor.fetch(offset, PAGE_SIZE);
        // 페이지 처리 로직
        if (!page.isEmpty()) {
            System.enqueueJob(new CursorQueueable(cursor, offset + PAGE_SIZE));
        }
    }
}
```

> [!note] Cursor vs Batch Apex 선택
> - Cursor + Queueable: 단일 Queueable 클래스에서 대용량 처리, 체이닝 깊이 제한 주의
> - Batch Apex: 트랜잭션 격리가 필요할 때, `Database.Stateful`로 상태 유지가 필요할 때
>
> 자세한 비교는 [[Batch Apex]] 참고.

---

### Summer '26 (v67.0) — Elastic Limits for Async Jobs (Beta)

Queueable / future 잡이 라이선스 일일 한도의 **최대 2배**까지 큐잉 가능. 한도 초과분은 즉시 실패하지 않고 **스로틀링**되어 처리된다.

| 항목 | 기존 동작 | Elastic Limits (Beta) |
|---|---|---|
| 일일 한도 초과 시 | `LimitException` 즉시 발생 | 스로틀링 — 지연 처리 |
| 최대 큐잉 가능 수 | 라이선스 한도 100% | 라이선스 한도의 **200%** |
| 적용 대상 | — | Queueable, @future |

> [!warning] Beta 주의사항
> Summer '26 기준 Beta. GA 전 동작 변경 가능. 스로틀링은 실패가 아닌 지연이므로 시간 제약이 있는 잡에서는 별도 모니터링이 필요하다.

---

## 관련 노트

- [[비동기 컨텍스트 선택]]
- [[Queueable 체이닝]]
- [[Future 메서드]]
- [[RestClient 패턴]]
- [[Batch Apex]]
- [[Queueable + Callout 패턴]] — Database.AllowsCallouts를 함께 구현하는 패턴
- [[Release/Winter '24]]
- [[Release/Winter '24/Development]] — 체이닝 최대 깊이 GA의 정확한 API(`AsyncOptions.MaximumQueueableStackDepth` · `AsyncInfo.getMaximumQueueableStackDepth()`)
- [[Release/Summer '24]]
- [[Release/Summer '26]]
- [[Release/Summer '26/Development]] — Elastic Limits for Async Jobs (Beta), 비동기 일일 한도 2배
