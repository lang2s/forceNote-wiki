---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Aynchronous and Sysnchronous process in SF]
---

# Salesforce의 비동기·동기 프로세스

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 소개
Salesforce에서 작업은 동기 또는 비동기로 처리. 성능·사용자 경험 최적화에 중요.

**동기 프로세스:**

즉시 실행, 완료까지 사용자가 대기. 단순하나 복잡·대량 작업 시 지연.
**비동기 프로세스:**

백그라운드 실행, 사용자가 대기 없이 작업 계속. 장기·리소스 집약 작업에 이상적.

## 장단점

| 구분 | 동기 | 비동기 |
|---|---|---|
| 장점 | 즉시 결과, 단순 구현, 단일 컨텍스트 트랜잭션 제어 | 성능 향상, 나은 UX, 확장성, 리소스 최적화 |
| 단점 | 장기 작업 시 시스템 느려짐, 사용자 대기, 리소스 집약 | 결과 지연, 구현 복잡, 오류 디버깅 어려움 |

## 동기 프로세스
**사용 시점:**

즉시 응답 필요, 빠르게 완료되는 단순 작업.
```apex
public class SynchronousExample {
    public void updateAccounts(List<Id> accountIds) {
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
        for(Account acc : accounts) acc.Name += ' - Synchronous Updated';
        update accounts;
    }
}
```

## 비동기 프로세스
**사용 이유:**

성능 향상, 나은 UX, 확장성.

### 1. Future 메서드
```apex
public class FutureExample {
    @future
    public static void updateAccounts(Set<Id> accountIds) {
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN :accountIds];
        for(Account acc : accounts) acc.Name += ' - Updated';
        update accounts;
    }
}
```

### 2. Batch Apex
```apex
global class BatchExample implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Name FROM Account');
    }
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        for(Account acc : scope) acc.Name += ' - Batch Updated';
        update scope;
    }
    global void finish(Database.BatchableContext BC) { }
}
```

### 3. Queueable Apex
```apex
public class QueueableExample implements Queueable {
    public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        for(Account acc : accounts) acc.Name += ' - Queue Updated';
        update accounts;
    }
}
```

### 4. Scheduled Apex
```apex
global class ScheduledExample implements Schedulable {
    global void execute(SchedulableContext sc) {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        for(Account acc : accounts) acc.Name += ' - Scheduled Updated';
        update accounts;
    }
}
// 스케줄
String sch = '0 0 12 * * ?'; // 매일 정오
System.schedule('Daily Account Update', sch, new ScheduledExample());
```

## 결론
단순·즉시 작업은 동기, 장기·리소스 집약 작업은 비동기(Future, Batch, Queueable, Scheduled)를 사용해 성능·UX를 최적화한다.
