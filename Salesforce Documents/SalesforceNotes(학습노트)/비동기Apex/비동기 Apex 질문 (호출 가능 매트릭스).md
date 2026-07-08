---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Asynchronous Apex Questions]
---

# 비동기 Apex 질문 (호출 가능 매트릭스)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. Future에서 Future 호출 가능?
불가능. (체이닝은 Queueable에서 가능)
```apex
public class futureMethodExample {
    @future
    public static void MyFutureMethod(){
        Map<Id,Account> mapacct = new Map<Id,Account>([SELECT Id, Name FROM Account]);
        System.debug('test method' + mapacct);
        // MyFutureMethod1(); // Future에서 Future 호출 시도 → 불가
    }
    @future(callout=true)
    public static void MyFutureMethod1(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug(result.get('animal'));
        }
        // BatchClassPractice bcn = new BatchClassPractice(); // Future에서 Batch 호출 시도 → 불가
    }
}
```

## 2. Scheduled Apex에서 Batch 호출 가능?
가능.
```apex
public class ScheduledBatchClassPractice implements Schedulable {
    public void execute(SchedulableContext sc){
        try {
            Database.executeBatch(new BatchClassPractice(), 400);  // Batch 호출 가능
            futureMethodExample.MyFutureMethod1();                 // Future도 호출 가능
        } catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
        }
    }
}
```

## 3. Batch에서 Batch 호출 가능?
가능하나 **finish 메서드에서만**(start·execute 불가).
```apex
public void finish(Database.BatchableContext bc) {
    Database.executeBatch(new BatchClassPractice(), 200);
}
```

## 4. Batch에서 Future 호출 가능?
불가능. `System.AsyncException: Future method cannot be called from a future or batch method`.

## 5. Future에서 Batch 호출 가능?
불가능. `System.AsyncException: Database.executeBatch cannot be called from a batch start, batch execute, or future method`.

## 6. Queueable에서 Future·Batch 호출 가능?
가능(양방향).
```apex
public class QueuableApexExample implements Queueable {
    public void execute(QueueableContext QC){
        insert new Account(Name='Tested Acct', Phone='0523124578');
        futureMethodExample.MyFutureMethod1();  // Future 호출 가능
    }
}
```

## 호출 가능 매트릭스 요약
| 호출원 → 대상 | Future | Batch | Queueable |
|---|---|---|---|
| Future에서 | ✖ | ✖ | ✔(1개) |
| Batch에서 | ✖ | ✔(finish만) | ✔ |
| Queueable에서 | ✔ | ✔ | ✔(체이닝) |
| Scheduled에서 | ✔ | ✔ | ✔ |
| Trigger에서 | ✔ | ✔ | ✔ |

## 7. Batch의 중요 인터페이스?
- **Database.Batchable**: 필수.
- **Database.AllowsCallouts**: 콜아웃 시 필수.
- **Database.Stateful**: 변수 상태 유지(예: 삽입된 Account 카운트).

## 8. Batch 클래스 메서드?
- start → Database.QueryLocator 또는 Iterable
- execute → void
- finish → void

## 9. 비동기 Apex 인터페이스?
Queueable, Schedulable, Database.Batchable.

## 10. Trigger에서 Future 호출 가능?
가능. (Mixed DML 회피에 활용 — Setup 오브젝트 DML을 @future로 분리)

## 11. Scheduled 작업 모니터링 방법?
- Apex Jobs 페이지(Setup → Apex Jobs)
- Developer Console에서 CronTrigger 쿼리:
```sql
SELECT Id, CronExpression, NextFireTime, PreviousFireTime, StartTime, EndTime,
       Status, JobItemsProcessed, TotalJobItems, NumberOfErrors, ExtendedStatus
FROM CronTrigger WHERE CronJobDetail.JobType = '7'
```

## 12. Scheduled 작업 중지 방법?
```apex
CronTrigger jobTrigger = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = :jobName LIMIT 1];
System.abortJob(jobTrigger.Id);
```
