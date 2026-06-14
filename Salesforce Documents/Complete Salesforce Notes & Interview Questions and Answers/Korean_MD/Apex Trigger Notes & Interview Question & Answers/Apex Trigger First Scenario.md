---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Trigger First Scenario]
---

# Apex 트리거 시나리오 1

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

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
