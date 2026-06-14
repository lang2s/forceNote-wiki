# Apex 트리거 시나리오 5

## 1. 중복 레코드 방지

고유 필드(예: Contact의 Email)로 중복 방지.
```apex
trigger ContactTrigger on Contact (before insert) {
    switch on trigger.operationType {
        when Before_Insert { ContactTriggerHandler.handleisBefore(trigger.new); }
    }
}
public class ContactTriggerHandler {
    public static void handleisBefore(List<Contact> NewRecords){
        List<String> mailList = new List<String>();
        for(Contact con : [SELECT Email FROM Contact]) mailList.add(con.Email);
        for(Contact c : NewRecords){
            if(mailList.contains(c.Email)) c.addError('Do not use duplicate email');
        }
    }
}
```

## 2. 관련 레코드 기반 필드 자동 채우기

Opportunity 생성 시 관련 Account의 Close Date로 자동 채우기.
```apex
public class OpportunityTriggerHandler {
    public static void handleisBefore(List<Opportunity> newRecords){
        Set<Id> acIds = new Set<Id>();
        for(Opportunity opp : newRecords) acIds.add(opp.AccountId);
        Map<Id,Account> acMap = new Map<Id,Account>([SELECT Close_Date__c FROM Account WHERE Id IN :acIds]);
        for(Opportunity op : newRecords){
            if(acMap.containsKey(op.AccountId)) op.CloseDate = acMap.get(op.AccountId).Close_Date__c;
        }
    }
}
```

## 3. 조건 기반 삭제 방지

자식 레코드(Opportunity·Contact)가 있으면 Account 삭제 방지.
```apex
public class AccountTriggerHandler {
    public static void handleisBeforeDelete(List<Account> deletedRecords, Map<Id,Account> oldMap){
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([SELECT AccountId FROM Opportunity WHERE AccountId IN :oldMap.keySet()]);
        Map<Id,Contact> conMap = new Map<Id,Contact>([SELECT AccountId FROM Contact WHERE AccountId IN :oldMap.keySet()]);
        for(Account acc : deletedRecords){
            if (oppMap.containsKey(acc.Id) || conMap.containsKey(acc.Id))
                acc.addError('You cannot delete this account because it has related Opportunities or Contacts.');
        }
    }
}
```
