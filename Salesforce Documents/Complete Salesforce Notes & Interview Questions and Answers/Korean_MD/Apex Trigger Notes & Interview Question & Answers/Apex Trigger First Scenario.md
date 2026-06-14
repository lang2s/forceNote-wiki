# Apex 트리거 시나리오 1

**시나리오: Account의 Status가 업데이트될 때마다 관련된 모든 Contact의 status를 업데이트.**

트리거:
```apex
trigger PracticeAccountTrigger on Account (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        FieldUpdateOfRelatedObject.statusFieldUpdate(trigger.new, trigger.oldMap, trigger.newMap);
    }
}
```

핸들러 클래스:
```apex
public class FieldUpdateOfRelatedObject {
    public static void statusFieldUpdate(List<Account> accList, Map<id, Account> oldAccountMap, Map<id, Account> newAccountMap){
        Set<Id> AccountIdSet = new Set<Id>();
        for(Account acct: accList){
            if(acct.Status__c != oldAccountMap.get(acct.Id).Status__c){
                AccountIdSet.add(acct.Id);
            }
        }
        List<Contact> conList = [SELECT Status__c, AccountId FROM Contact WHERE AccountId IN :AccountIdSet];
        for(Contact con: conList){
            con.Status__c = newAccountMap.get(con.AccountId).Status__c;
        }
        if(!conList.isEmpty()){
            update conList;
        }
    }
}
```
