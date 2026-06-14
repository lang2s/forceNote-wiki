# Salesforce의 Queueable Apex

> 원본은 이미지 PDF로 OCR 추출했습니다.

## 예제 클래스
```apex
public with sharing class AccountQueueableJob implements Queueable {
    private List<Id> recordIds;

    // 매개변수를 전달하는 생성자
    public AccountQueueableJob(List<Id> recordIds) {
        this.recordIds = recordIds;
    }

    // 작업을 실행하는 execute 메서드
    public void execute(QueueableContext context) {
        try {
            List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN :recordIds];
            for (Account acc : accounts) {
                acc.Name = acc.Name + ' - Processed';
            }
            Database.update(accounts);
            System.debug('Job executed successfully');
        } catch (Exception ex) {
            System.debug('An error occurred: ' + ex.getMessage());
            // 예외 처리
        }
    }
}
```

## 작업 등록
```apex
List<Id> accountIds = new List<Id> {'0012800000rs681AAA'};
System.enqueueJob(new AccountQueueableJob(accountIds));
```

## 작업 체이닝
```apex
public class AccountQueueableJob implements Queueable {
    public void execute(QueueableContext context) {
        // 처리 로직
        // 다음 작업을 등록해 체이닝
        System.enqueueJob(new SecondJob());
    }
}
```

> Queueable Apex는 매개변수 전달(생성자), 비기본 타입 지원, 작업 체이닝, AsyncApexJob Id로 모니터링이 가능해 Future 메서드보다 유연하다.
