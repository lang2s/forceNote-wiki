# Apex 트리거 학습 가이드 (Account 시나리오)

> 하나의 핸들러 클래스로 여러 시나리오 처리. 메인 트리거는 가볍게, 로직은 핸들러에 위임.

## 시나리오 1: 청구 주소 업데이트
Account 업데이트 전, 청구 주소 필드 변경 여부 확인 후 벌크화하여 업데이트.
```apex
public void updateBillingAddress(List<Account> newAccounts, Map<Id, Account> oldMap) {
    List<Account> accountsToUpdate = new List<Account>();
    for (Account newAcc : newAccounts) {
        if (newAcc.BillingStreet != oldMap.get(newAcc.Id).BillingStreet ||
            newAcc.BillingCity != oldMap.get(newAcc.Id).BillingCity /* ... */) {
            accountsToUpdate.add(newAcc);
        }
    }
    if (!accountsToUpdate.isEmpty()) Database.update(accountsToUpdate);
}
```

## 시나리오 2: Account 생성 시 이메일 전송
Account 삽입 후, 새로 생성된 각 Account에 이메일 알림 구성·전송.
```apex
public void sendEmailOnCreation(List<Account> newAccounts) {
    List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
    for (Account newAcc : newAccounts) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{'example@email.com'});
        email.setSubject('New Account Created: ' + newAcc.Name);
        email.setPlainTextBody('A new Account was created.');
        emailMessages.add(email);
    }
    Messaging.sendEmail(emailMessages);
}
```

## 시나리오 3: 고유 Account 이름 검증
Account 삽입 전, 같은 이름의 Account가 없는지 검증.
```apex
public void validateUniqueNames(List<Account> newAccounts) {
    Set<String> existingAccountNames = new Set<String>();
    for (Account acc : [SELECT Name FROM Account WHERE Name IN :newAccounts]) existingAccountNames.add(acc.Name);
    for (Account newAcc : newAccounts) {
        if (existingAccountNames.contains(newAcc.Name)) newAcc.addError('Account with the same name already exists.');
    }
}
```

## 시나리오 4: 관련 Opportunity 업데이트
Account 업데이트 후, Account 변경에 따라 관련 Opportunity 업데이트.

## 시나리오 5: Account 삭제 시 자식 Contact 삭제
Account 삭제 전, 관련 Contact를 식별해 삭제.
```apex
public void deleteChildContactsOnAccountDelete(List<Account> oldAccounts) {
    Set<Id> accountIds = new Set<Id>();
    for (Account oldAcc : oldAccounts) accountIds.add(oldAcc.Id);
    List<Contact> contactsToDelete = [SELECT Id FROM Contact WHERE AccountId IN :accountIds];
    if (!contactsToDelete.isEmpty()) Database.delete(contactsToDelete);
}
```

## 메인 트리거
```apex
trigger AccountMasterTrigger on Account (before insert, after insert, before update, after update, before delete, after delete) {
    AccountTriggerHandler handler = new AccountTriggerHandler();
    if (Trigger.isBefore) {
        if (Trigger.isInsert) { handler.sendEmailOnCreation(Trigger.new); handler.validateUniqueNames(Trigger.new); }
        if (Trigger.isUpdate) { handler.updateBillingAddress(Trigger.new, Trigger.oldMap); handler.updateRelatedOpportunities(Trigger.new, Trigger.oldMap); }
        if (Trigger.isDelete) { handler.deleteChildContactsOnAccountDelete(Trigger.old); }
    }
}
```

**모범 사례:** 벌크화, 관심사 분리(트리거 경량·로직은 핸들러), 설명적 메서드 이름, 컨텍스트 변수 활용, 오류 처리, 루프 안 SOQL 회피, 이메일 로직은 별도 유틸리티 클래스.
