# 트리거 시나리오 문제

## 시나리오 1: Contact의 Phone·Fax를 관련 Account의 Phone·Fax와 동기화

```apex
trigger ContactTrigger on Contact (before insert) {
    switch on trigger.operationType {
        when Before_Insert { ContactTriggerHandler.handleisBefore(trigger.new, Trigger.newMap); }
    }
}
public class ContactTriggerHandler {
    public static void handleisBefore(List<Contact> NewRecords, Map<Id,Contact> newMap){
        Set<Id> acIds = new Set<Id>();
        for(Contact c : NewRecords) acIds.add(c.AccountId);
        Map<Id,Account> acMap = new Map<Id,Account>([SELECT Fax, Phone FROM Account WHERE Id IN :acIds]);
        for (Contact c : NewRecords){
            if(acMap.containsKey(c.AccountId)){
                c.Fax = acMap.get(c.AccountId).Fax;
                c.Phone = acMap.get(c.AccountId).Phone;
            }
        }
    }
}
```

## 시나리오 2: Account의 Industry 변경 시, 관련 Contact의 Description에 이전·새 Industry 값 추가

```apex
public static void HandleActivityAfterUpdate(List<Account> newRecords, Map<Id,Account> newMap, Map<Id,Account> oldMap){
    Set<Id> accIds = new Set<Id>();
    for(Account acc : newRecords){
        if(newMap.get(acc.id).Industry != oldMap.get(acc.id).Industry) accIds.add(acc.Id);
    }
    List<Contact> conList = [SELECT id, name, accountId, description FROM Contact WHERE AccountId IN :accIds];
    List<Contact> conNewUpdate = new List<Contact>();
    for(Contact con : conList){
        con.Description = 'New industry' + newMap.get(con.AccountId).Industry + 'Old industry' + oldMap.get(con.AccountId).Industry;
        conNewUpdate.add(con);
    }
    update conNewUpdate;
}
```

## 시나리오 3: 관련 Account 삭제 시 Contact 삭제 방지(AccountId를 null로)

```apex
public static void HandleActivityBeforeDelete(List<Account> DeletedRecords, Map<Id,Account> oldMap){
    Set<Id> acId = new Set<Id>();
    // (oldMap.keySet()으로 acId 채움)
    List<Contact> conList = [SELECT id, name, accountId FROM Contact WHERE AccountId IN :acId];
    List<Contact> conUpdateList = new List<Contact>();
    for(Contact co : conList){
        co.AccountId = null;
        conUpdateList.add(co);
    }
    update conUpdateList;
}
```
