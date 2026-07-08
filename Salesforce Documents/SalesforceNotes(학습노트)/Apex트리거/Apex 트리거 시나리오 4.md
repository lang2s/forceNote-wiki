---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Trigger Scenario - 4]
---

# Apex 트리거 시나리오 4

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**시나리오: Account가 특정 Status로 생성/업데이트될 때 관련 Contact를 같은 status로 자동 업데이트. 관련 Contact가 없으면 새 Contact를 생성해 데이터 무결성 유지.**

트리거:
```apex
trigger accTrigger on Account (after insert, after update) {
    accTriggerHandler obj = new accTriggerHandler();
    obj.doAction();
}
```

핸들러:
```apex
public class accTriggerHandler {
    public void doAction(){
        switch on trigger.OperationType {
            when AFTER_INSERT { accTriggerHelper.updatecontact((List<Account>)trigger.New, null); }
            when AFTER_UPDATE { accTriggerHelper.updatecontact((List<Account>)trigger.New, (Map<Id,Account>)trigger.OldMap); }
        }
    }
}
```

헬퍼(핵심):
```apex
public class accTriggerHelper {
    public static void updatecontact(List<Account> triggernew, Map<Id,Account> triggeroldmap){
        List<Contact> conToCreate = new List<Contact>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        if(trigger.isInsert){
            for(Account acc : triggernew){
                if(acc.Status__c != null){
                    accMap.put(acc.Id, acc);
                    conToCreate.add(contactCreation(acc.Id, acc.Status__c));
                }
            }
        }
        if(trigger.isUpdate){
            for(Account acc : triggernew){
                if(acc.Status__c != null && acc.Status__c != triggeroldmap.get(acc.Id).Status__c) accMap.put(acc.Id, acc);
            }
        }
        List<Contact> conToUpdate = new List<Contact>();
        if(!accMap.isEmpty()){
            List<Contact> conList = [SELECT LastName, AccountId FROM Contact WHERE AccountId IN :accMap.keySet()];
            if(!conList.isEmpty()){
                for(Contact con : conList){
                    if(accMap.containsKey(con.AccountId)){
                        con.AccountStatus__c = accMap.get(con.AccountId).Status__c;
                        conToUpdate.add(con);
                    }
                }
            } else {
                for(Account a : triggernew) conToCreate.add(contactCreation(a.Id, a.Status__c));
            }
        }
        if(!conToCreate.isEmpty()) insert conToCreate;
        if(!conToUpdate.isEmpty()) update conToUpdate;
    }
    public static Contact contactCreation(String id, String status){
        Contact c = new Contact();
        c.AccountId = id; c.FirstName = 'Placeholder'; c.LastName = 'Contact'; c.AccountStatus__c = status;
        return c;
    }
}
```
