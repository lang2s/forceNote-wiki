# Apex 트리거 시나리오 6

**시나리오: Account에 "Destinations" 다중 선택 목록(국가명 추가)을 만들고, Account 삽입/업데이트 시 선택 목록에 값이 있으면 그 값 기반으로 관련 Contact 생성.**

트리거:
```apex
trigger AccountTrigger on Account (after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) TriggerHandlerOnAccount.handleAfterInsertUpdate(Trigger.new);
        else if (Trigger.isDelete) TriggerHandlerOnAccount.handleAfterDelete(Trigger.old);
    }
}
```

핸들러:
```apex
public class TriggerHandlerOnAccount {
    public static void handleAfterInsertUpdate(List<Account> newAccounts) {
        List<Contact> contactsToDelete = new List<Contact>();
        List<Contact> newContacts = new List<Contact>();
        for (Account acc : newAccounts) {
            if (acc.designation__c != null) {
                contactsToDelete.addAll([SELECT Id FROM Contact WHERE AccountId = :acc.Id]);
                for (String country : acc.designation__c.split(';')) {
                    newContacts.add(new Contact(FirstName='New', LastName='Contact'+country, AccountId=acc.Id));
                }
            }
        }
        if (!contactsToDelete.isEmpty()) delete contactsToDelete;
        if (!newContacts.isEmpty()) insert newContacts;
    }
    public static void handleAfterDelete(List<Account> deletedAccounts) {
        List<Contact> contactsToDelete = [SELECT Id FROM Contact WHERE AccountId IN :deletedAccounts];
        if (!contactsToDelete.isEmpty()) delete contactsToDelete;
    }
}
```

**동작:** Account를 designation과 함께 생성하면 관련 Contact 생성. 다른 designation(Ukraine) 추가 시 해당 Contact 생성(중복 방지). designation(Singapore) 제거 시 해당 관련 Contact 자동 삭제.
