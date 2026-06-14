# Batch Apex 시나리오 1

**문제: Account의 모든 레코드에서 SLA__c 필드를 Gold로 업데이트**

```apex
global class AccountupdateBatchapex implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT id, Name, SLA__c FROM account WHERE Rating = \'hot\'');
    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        for(Account acc : scope){
            acc.SLA__c = 'Gold';
        }
        update scope;
    }
    global void finish(Database.BatchableContext bc){
        System.debug('all batch are executed');
    }
}
```

## Schedulable 인터페이스로 실행
```apex
global class Accountupdate_schedulable implements Schedulable {
    global void execute(SchedulableContext cc){
        AccountupdateBatchapex a = new AccountupdateBatchapex();
        Database.executeBatch(a, 2000);
    }
}
```

## Finish 메서드에서 이메일 알림 (배치 정보 포함)
```apex
global void finish(Database.BatchableContext bc){
    endtime = System.now();
    AsyncApexJob job = [SELECT Id, Status, JobItemsProcessed, TotalJobItems,
        CreatedDate, CompletedDate, NumberOfErrors FROM AsyncApexJob WHERE id = :bc.getJobId()];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(new List<String> { 'laklakranjith123@gmail.com' });
    String body = 'The batch processing has been completed successfully.\n'
        + 'Batch id--' + job.id + ' Batch job id...' + bc.getJobId() + '\n'
        + 'Status-- ' + job.Status + '\n'
        + 'JobItemsProcessed---- ' + job.JobItemsProcessed + '\n'
        + 'TotalJobItems---- ' + job.TotalJobItems + '\n'
        + 'NumberOfErrors---- ' + job.NumberOfErrors + '\n'
        + 'CreatedDate---- ' + job.CreatedDate + ' startat-- ' + starttime + '\n'
        + 'CompletedDate---- ' + job.CompletedDate + ' endedat--- ' + endtime;
    mail.setSubject('Batch job notification');
    mail.setPlainTextBody(body);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { mail });
}
```
