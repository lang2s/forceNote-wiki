# 비동기 Apex

비동기 Apex 메서드는 UI를 차단하거나 실시간 트랜잭션 성능에 영향을 주지 않고 백그라운드에서 작업을 실행할 때 사용. 대량 데이터 처리, 콜아웃, 이메일 전송 같은 장기 작업에 유용. 4가지 주요 유형: Future, Batch, Queueable, Scheduled.

## 1. Future 메서드
백그라운드 비동기 처리. 이메일 전송·외부 콜아웃 같은 단순 논블로킹 작업에 주로 사용.
- @future 어노테이션으로 표시
- 값 반환 불가(void)
- 트랜잭션당 최대 50회

**예: Opportunity 종료 시 Contact에 감사 이메일**
```apex
public class OpportunityHandler {
    @future
    public static void sendThankYouEmail(String contactId) {
        Contact contact = [SELECT Email FROM Contact WHERE Id = :contactId];
        if (contact.Email != null) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[] { contact.Email });
            email.setSubject('Thank You!');
            email.setPlainTextBody('Thank you for your business!');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }
    }
}
```

## 2. Batch Apex
대량 레코드(수백만)를 작은 청크로 나눠 처리. start(), execute(), finish() 세 메서드 필요.
- 배치당 최대 200건
- start()는 처리 범위(QueryLocator/Iterable) 정의
- execute()는 각 배치 처리 로직
- finish()는 모든 배치 후 최종 작업

**예: 180일 이상 미접촉 Lead를 Inactive로**
```apex
global class InactiveLeadsBatch implements Database.Batchable<SObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id FROM Lead WHERE LastActivityDate < LAST_N_DAYS:180');
    }
    global void execute(Database.BatchableContext BC, List<Lead> leads) {
        for (Lead lead : leads) lead.Status = 'Inactive';
        update leads;
    }
    global void finish(Database.BatchableContext BC) {
        System.debug('Inactive leads processing completed.');
    }
}
// 실행
Database.executeBatch(new InactiveLeadsBatch());
```

## 3. Queueable Apex
Batch와 유사하나 더 유연. 작업 체이닝 가능, 제약 적음. 작업 간 데이터 전달이 필요한 복잡 처리에 사용.

**예: Account BillingState 업데이트 후 Contact 생성(체이닝)**
```apex
public class updateAccQueue implements Queueable {
    public void execute(QueueableContext context) {
        List<Account> acclist = [SELECT id, billingstate FROM account WHERE billingstate='CA'];
        for (Account ac : acclist) ac.billingstate = 'NY';
        update acclist;
        System.enqueueJob(new updateConQueue());  // 다음 작업 체이닝
    }
}
public class updateConQueue implements Queueable {
    public void execute(QueueableContext context) {
        List<Account> acclist = [SELECT id, billingstate FROM account WHERE billingstate='NY'];
        List<Contact> ctlist = new List<Contact>();
        Integer i = 1;
        for (Account ac : acclist) {
            ctlist.add(new Contact(lastname='NY Account'+i++, AccountId=ac.id));
        }
        insert ctlist;
    }
}
// 실행
System.enqueueJob(new updateAccQueue());
```

## 4. Scheduled Apex
특정 시간(매일·매주·매월)에 작업 실행. Schedulable 인터페이스와 execute() 구현. cron 표현식 사용.

**예: 매일 자정에 배치 실행**
```apex
global class InactiveLeadsBatch_Schedule implements Schedulable {
    global void execute(SchedulableContext cb) {
        Database.executeBatch(new InactiveLeadsBatch());
    }
}
// 실행
String cronExp = '0 0 0 * * ?'; // 매일 자정
System.schedule('Daily Job', cronExp, new InactiveLeadsBatch_Schedule());
```
