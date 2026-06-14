# Salesforce 비동기 Apex 마스터: Future, Batch, Queueable, Scheduled

## 왜 비동기 Apex인가?
- **성능 향상** — 거버너 한도 회피.
- **Future 메서드** — API 호출 최적화, 동기 콜아웃 문제 방지, 빠른 비동기 처리(경량 작업).
- **Batch Apex** — 대량 데이터 효율 처리, 수백만 건 벌크 처리.
- **Queueable Apex** — 복잡한 매개변수로 체이닝.
- **Scheduled Apex** — 자동화된 백그라운드 작업.

## 1. Future 메서드: 빠른 비동기 처리
- 동기 트랜잭션의 거버너 한도 회피를 위한 비동기 실행.
- 트리거 콜아웃·경량 작업에 사용.
- 체이닝·작업 추적 미지원.

**실전 시나리오:** Case 종료 시 외부 시스템에 API 요청 필요(트리거 내 콜아웃 불가). → @future 메서드로 콜아웃 비동기 처리.
```apex
public class CaseUpdateHelper {
    @future(callout=true)
    public static void sendCaseUpdateToExternalSystem(Id caseId) {
        Case c = [SELECT Id, Status FROM Case WHERE Id = :caseId];
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://externalapi.com/update');
        req.setMethod('POST');
        req.setBody('{"caseId":"' + c.Id + '","status":"' + c.Status + '"}');
        req.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
}
```

## 2. Batch Apex: 대량 데이터 처리
- 수백만 건을 작은 배치로 비동기 처리.
- 각 실행이 별도 트랜잭션이라 거버너 한도 문제 방지.
- 데이터 정리·대량 업데이트·복잡 리포트에 이상적.

**실전 시나리오:** 부동산 관리 프로젝트에서 시장 동향 기반으로 수천 건 가격 업데이트(표준 DML은 한도 초과). → Batch Apex.
```apex
global class UpdatePropertyPricesBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Price FROM Property__c');
    }
    global void execute(Database.BatchableContext BC, List<Property__c> propertyList) {
        for (Property__c prop : propertyList) prop.Price *= 1.05; // 5% 인상
        update propertyList;
    }
    global void finish(Database.BatchableContext BC) {
        System.debug('Batch process completed!');
    }
}
```

## 3. Queueable Apex: 고급 비동기 처리
- Future 유사하나 작업 체이닝·모니터링 지원.
- 복잡한 SObject·커스텀 객체를 매개변수로 전달.
- stateful 실행이 필요한 장기 작업에 이상적.

**실전 시나리오:** WiFi/데이터 네트워크 프로젝트에서 신규 고객에게 고유 데이터 플랜 생성·할당(다단계). → Queueable.
```apex
public class AssignDataPlanQueueable implements Queueable {
    private Id customerId;
    public AssignDataPlanQueueable(Id customerId) { this.customerId = customerId; }
    public void execute(QueueableContext context) {
        Customer__c customer = [SELECT Id, Name FROM Customer__c WHERE Id = :customerId];
        DataPlan__c plan = new DataPlan__c(Customer__c = customer.Id, PlanType__c = 'Premium');
        insert plan;
    }
}
```

## 4. Scheduled Apex: 반복 작업 자동화
- 매일·매주·매월 작업 자동화.
- Batch·Queueable과 연계.
- 데이터 정리·리포트·알림에 유용.

**실전 시나리오:** Edutech LMS에서 학생에게 주간 과정 완료 알림 발송.
```apex
global class WeeklyReminderScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        List<Student__c> students = [SELECT Id, Email FROM Student__c WHERE Status__c = 'In Progress'];
        for (Student__c student : students) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{student.Email});
            email.setSubject('Course Completion Reminder');
            email.setPlainTextBody('Hi, please complete your course soon!');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        }
    }
}
```

## 5. 모든 비동기 Apex를 함께 사용

**Case 관리 워크플로우:** ① Case 종료 시 외부 시스템 API 업데이트(Future), ② 대량 Case 상태 업데이트(Batch), ③ 업데이트 후 후속 Task 할당(Queueable), ④ 일일 Case 에스컬레이션(Scheduled).

```apex
// Batch 완료 후 Queueable 체이닝
global class UpdateCaseStatusBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Status FROM Case WHERE Status = \'Pending\'');
    }
    global void execute(Database.BatchableContext BC, List<Case> cases) {
        for (Case c : cases) c.Status = 'Resolved';
        update cases;
        System.enqueueJob(new AssignFollowUpQueueable(new List<Id>(new Map<Id,Case>(cases).keySet())));
    }
    global void finish(Database.BatchableContext BC) { System.debug('Batch completed!'); }
}

public class AssignFollowUpQueueable implements Queueable {
    private List<Id> caseIds;
    public AssignFollowUpQueueable(List<Id> caseIds) { this.caseIds = caseIds; }
    public void execute(QueueableContext context) {
        List<Task> tasks = new List<Task>();
        for (Case c : [SELECT Id FROM Case WHERE Id IN :caseIds]) {
            tasks.add(new Task(WhatId=c.Id, Subject='Follow-Up', Status='Open'));
        }
        insert tasks;
    }
}
```

> Future, Batch, Queueable, Scheduled를 함께 활용하면 완전 자동화되고 확장성 높은 워크플로우를 구축할 수 있다.
