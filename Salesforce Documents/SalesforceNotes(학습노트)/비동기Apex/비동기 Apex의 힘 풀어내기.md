---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Unlocking the Power of Asynchronous Apex]
---

# 비동기 Apex의 힘 풀어내기

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 동기 vs 비동기
- **동기**: 전체 Apex 코드가 단일 스레드로 순차 실행.
- **비동기**: 별도 스레드에서 나중에 백그라운드 실행.

## 내부 아키텍처
- 비동기 Apex는 서로 다른 스레드에서 프로세스 실행.
- **실행 컨텍스트**: 함수 실행 시 메모리 관련 컨텍스트. 각 컨텍스트마다 스레드/프로세스 실행(본질적으로 동기).
- 효율을 높이거나 의존성을 줄이려면 다중 프로세스 실행 = 비동기.
- **비동기 작업**: 여러 프로세스를 작업(job)이라 하며 큐에 배치. 리소스 가용에 따라 완료.

## 장점
- 더 높은 거버너 한도(비동기 SOQL 200)
- 프로세스 스케줄 가능
- 확장성

## 거버너 한도
| 리소스 | 동기 | 비동기 |
|---|---|---|
| SOQL 쿼리 | 100 | 200 |
| getQueryLocator 레코드 | 10,000 | 10,000 |
| SOQL 반환 레코드 | 50,000 | 50,000 |
| SOSL 쿼리 | 20 | 20 |
| Future 메서드 최대 | 50 | batch·future 0, queueable 50 |
| enqueueJob 큐 추가 최대 | 50 | 1 |
| 힙 크기 | 6MB | 12MB |
| CPU 시간 | 10,000ms | 60,000ms |

## 구현 4가지
- **Future**: @future, 기본 타입만. 외부 콜아웃·Mixed DML 회피.
- **Queueable**: 복합 타입(레코드 목록) 전달. 체이닝·복잡 처리.
- **Scheduled**: 특정 시간 독립 실행. 주기 작업·배치 스케줄.
- **Batch**: 대량 작업을 청크로 분할. 대량 데이터·다중 쿼리.

## Future 메서드
- @future로 비동기 표시, 별도 스레드, void만, 기본 타입 매개변수만, 레코드 ID 전달 가능, sObject 불가(직렬화 불안정), 리소스 가용 시 실행, Job ID 미반환(모니터링 불가), 실행 순서 미보장, 체이닝 불가, Batch에서 호출 불가.

**제한:**

Apex 호출당 50개, 24시간당 250,000회 또는 200 × 사용자 라이선스.

**한도 관리:**

`Limits.getFutureCalls()`, `Limits.getLimitFutureCalls()`, `System.isFuture()`.

```apex
global class FutureClass {
    @future
    public static void futureMethod(String param) {
        System.debug('Parameter passed: ' + param);
    }
}
FutureClass.futureMethod('Hello Future!');
```

### Future 콜아웃 (callout=true)
**시나리오: 우편번호로 우체국명 업데이트**
```apex
public class postalHelper {
    @future(callout=true)
    public static void docallout(String pinCode, Id recordId) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.postalpincode.in/pincode/' + pinCode);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200) {
            List<Object> result = (List<Object>) JSON.deserializeUntyped(response.getBody());
            Map<String,Object> resultMap = (Map<String,Object>) result[0];
            List<String> postOffices = new List<String>();
            for(Object post : (List<Object>) resultMap.get('PostOffice')) {
                Map<String,Object> p = (Map<String,Object>) post;
                postOffices.add((String) p.get('Name'));
            }
            update new Postal__c(Id=recordId, Post_Offices__c=String.join(postOffices, ','));
        }
    }
}
trigger PostalTrigger on Postal__c (after insert) {
    for(Postal__c record : Trigger.New) PostalHelper.docallout(record.Postal_code__c, record.Id);
}
```

### Mixed DML 회피
Setup 오브젝트(User·Profile·Group)와 non-setup(Account·Contact)을 같은 트랜잭션에서 DML하면 Mixed DML 오류. @future로 분리.
```apex
public class MixedDMLErrorExample {
    public static void createUserAndAccount() {
        User newUser = new User(LastName='Doe', /* ... */);
        insert newUser;  // Setup 동기
        createAccountAsync('New Customer');  // non-setup 비동기
    }
    @future
    public static void createAccountAsync(String accountName) {
        insert new Account(Name = accountName);
    }
}
```

## Queueable Apex
체이닝, Batch 통합, SObject 전달, Job ID 모니터링, Transaction Finalizer(완료 처리·실패 재시도 5회·잠금).

**사용 시점:**

순차 체이닝, 복잡 매개변수, 별도 스레드, 대량 데이터.

```apex
public class DemoQueueable implements Queueable {
    public void execute(QueueableContext ctx) { /* 로직 */ }
}
System.enqueueJob(new DemoQueueable());
```

### Queueable 콜아웃
```apex
public class TestCallout implements Queueable, Database.AllowsCallouts {
    public void execute(QueueableContext ctx) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('endpoint');
        http.send(request);
    }
}
```

**기억할 점:**

Queueable에서 1개만 enqueue(무한 체이닝 방지), 단일 트랜잭션 최대 50개, Dev Edition 스택 깊이 5(부모 포함), 테스트에서 체이닝 미지원(`Test.isRunningTest()` 처리).

### 체이닝 시나리오: 작년 Contact·Account 삭제
```apex
public class DeleteContactsJob implements Queueable {
    public void execute(QueueableContext context) {
        List<Contact> contactsToDelete = [SELECT Id FROM Contact WHERE CreatedDate = LAST_YEAR LIMIT 200];
        if (!contactsToDelete.isEmpty()) {
            try { delete contactsToDelete; }
            catch (DmlException e) { System.debug('Error: ' + e.getMessage()); }
        }
        System.enqueueJob(new DeleteAccountsJob());  // 체이닝
    }
}
public class DeleteAccountsJob implements Queueable {
    public void execute(QueueableContext context) {
        List<Account> accountsToDelete = [SELECT Id FROM Account WHERE CreatedDate = LAST_YEAR LIMIT 200];
        if (!accountsToDelete.isEmpty()) {
            try { delete accountsToDelete; }
            catch (DmlException e) { System.debug('Error: ' + e.getMessage()); }
        }
    }
}
```

### Transaction Finalizer
Queueable 작업 실패 시 재시도(최대 5회)·알림·잠금. `System.Finalizer` 인터페이스 구현.
```apex
public class QueueableFinalizer implements System.Finalizer {
    public void execute(FinalizerContext ctx) {
        switch on ctx.getResult() {
            when SUCCESS { System.debug('Job Completed::' + ctx.getAsyncApexJobId()); }
            when UNHANDLED_EXCEPTION {
                System.debug('ERROR::' + ctx.getException().getMessage());
                EmailHelper.sendEmailNotification(ctx.getAsyncApexJobId());
            }
        }
    }
}
// 첨부
public class QueueableDemo implements Queueable {
    public void execute(QueueableContext ctx) {
        System.attachFinalizer(new QueueableFinalizer());
        // 로직
    }
}
```

## Batch Apex
대량 레코드를 비동기·청크로 처리. QueryLocator 최대 5천만 건(최소 1, 기본 200, 최대 2000). Flex Queue Holding 100개, 24시간당 250,000회. execute에서 future 호출 금지·queueable 1개만. Database 클래스로 레코드 조회.

- **start**: QueryLocator 반환, 수집, 1회, 레코드 집합 반환.
- **execute**: 작업 분리, 여러 번.
- **finish**: 모든 배치 후, 1회(알림).

**구성 방식:**

Query Locator(단순 쿼리), Iterator(복잡 기준).

**인터페이스:**

Database.Stateful(상태 유지), Database.RaisesPlatformEvents(BatchApexErrorEvent 발행), Database.AllowsCallouts(콜아웃, DML 전 실행). AsyncApexJob으로 진행 조회. finish에서 executeBatch/scheduleBatch로 체이닝.

**시나리오: Phone 빈 Account에 기본값 설정**
```apex
public class UpdateAccountPhoneBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Phone FROM Account WHERE Phone = NULL');
    }
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        for (Account acc : (List<Account>)scope) acc.Phone = '+1-800-000-0000';
        update scope;
    }
    public void finish(Database.BatchableContext bc) {
        System.debug('All accounts with blank Phone fields have been updated.');
    }
}
Database.executeBatch(new UpdateAccountPhoneBatch(), 100);
```

**오류 처리:**

DML 오류(SaveResult/Error 객체로 로깅), Non-DML(Database.update). DML 예외는 try-catch 또는 Platform Event(BatchApexErrorEvent 트리거).

## 면접 질문 요약
1. **비동기 Apex?** 백그라운드 실행으로 사용자 대기 없이 복잡·시간 소요 작업. Future/Batch/Queueable/Scheduled.
2. **Future?** @future, static·void, 콜아웃(callout=true), 체이닝·트랜잭션 제어 불가.
3. **Batch?** 대량 레코드를 청크로, start/execute/finish.
4. **Queueable vs Future?** 체이닝·복합 객체·모니터링 가능.
5. **Queueable 체이닝?** execute에서 System.enqueueJob.
6. **모니터링?** Apex Jobs 페이지, System.abortJob, AsyncApexJob 쿼리.
7. **Scheduled Apex?** Schedulable 구현, System.schedule. 예: `'0 0 6 * * ?'`(매일 6시).
8. **동기 Apex vs 트리거?** 트리거는 DML 이벤트에 즉시 실행되는 동기 Apex.
9. **Future vs Queueable?** Queueable이 유연·체이닝·sObject 지원.
10. **Queueable 단일 트랜잭션 최대?** 50개.
11. **Batch 실패 시?** 실패한 scope만 롤백, 나머지 계속. Database.SaveResult로 부분 처리.
12. **execute에서 Batch 호출?** 불가, finish만.
13. **메서드 실행 횟수?** start 1회, execute 여러 번, finish 1회.
14. **일일 배치 한도?** 250,000회.
15. **Future가 sObject 미지원 이유?** 호출~실행 사이 변경 가능성으로 옛 값 덮어쓰기 위험.
