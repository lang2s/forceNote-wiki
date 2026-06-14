# Salesforce에서 Batch Apex 모니터링 살펴보기

작업을 추적하기 위한 커스텀 로그 오브젝트를 사용하는 Batch 클래스 예제. `Database.Stateful`로 상태를 유지하고, finish 메서드에서 작업 요약을 커스텀 로그 오브젝트(AsyncJobLogs__c)에 기록하고 이메일을 전송.

```apex
global class BatchClass implements Database.Batchable<SObject>, Database.Stateful {
    // AccountId별 Contact 수를 저장하는 Map
    global Map<Id, AggregateResult> acMap = new Map<Id, AggregateResult>();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        acMap = new Map<Id, AggregateResult>(
            [SELECT COUNT(Id) countId, AccountId Id FROM Contact
             WHERE AccountId != null GROUP BY AccountId]
        );
        return Database.getQueryLocator('SELECT Id, Count_of_contact__c FROM Account');
    }

    global void execute(Database.BatchableContext bc, List<Account> scope) {
        for (Account acc : scope) {
            if (acMap.containsKey(acc.Id)) {
                acc.Count_of_contact__c = (Decimal) acMap.get(acc.Id).get('countId');
            } else {
                acc.Count_of_contact__c = null;
            }
        }
        update scope;
    }

    global void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems,
                   CreatedDate, CompletedDate
            FROM AsyncApexJob WHERE Id = :bc.getJobId()
        ];
        // 작업 추적용 로그 오브젝트
        List<AsyncJobLogs__c> jobobj = new List<AsyncJobLogs__c>();
        AsyncJobLogs__c ac = new AsyncJobLogs__c();
        ac.jobid__c = job.Id;
        ac.Status__c = job.Status;
        ac.NumberOfErrors__c = job.NumberOfErrors;
        ac.JobItemsProcessed__c = job.JobItemsProcessed;
        ac.TotalJobItems__c = job.TotalJobItems;
        ac.CreatedDate__c = job.CreatedDate;
        ac.CompletedDate__c = job.CompletedDate;
        jobobj.add(ac);
        insert jobobj;

        String emailBody = 'Batch Job Details:\n\n'
            + '1. Batch Job ID: ' + job.Id + '\n'
            + '2. Current Status: ' + job.Status + '\n'
            + '3. Number of Errors: ' + job.NumberOfErrors + '\n'
            + '4. Records Processed: ' + job.JobItemsProcessed + '\n'
            + '5. Total Records to Process: ' + job.TotalJobItems + '\n'
            + '6. Start Time: ' + String.valueOf(job.CreatedDate) + '\n'
            + '7. End Time: ' + (job.CompletedDate != null ? String.valueOf(job.CompletedDate) : 'Still Processing') + '\n';

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject('Batch Job Status');
        email.setToAddresses(new String[] { 'sivachandran2256@gmail.com' });
        email.setPlainTextBody(emailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        System.debug('Batch processing completed successfully!');
    }
}
```

> 핵심: `Database.Stateful`로 배치 실행 간 `acMap` 상태 유지. finish에서 AsyncApexJob를 쿼리해 작업 상태를 커스텀 로그 오브젝트에 기록하고 이메일로 요약 전송.
