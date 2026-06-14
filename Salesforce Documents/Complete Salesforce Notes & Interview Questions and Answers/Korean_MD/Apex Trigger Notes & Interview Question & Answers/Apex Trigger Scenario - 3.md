# Apex 트리거 시나리오 3

**시나리오: Account의 커스텀 필드에 가장 높은 Opportunity 금액과 그 Opportunity 이름을 자동 업데이트.**

흐름: 1) Opportunity Insert·Update 시 트리거 발동, 2) 금액이 신규/변경된 Account ID 수집, 3) 집계 SOQL로 각 Account의 최대 금액 조회, 4) 최대 금액의 Opportunity 이름 매핑, 5) 단일 DML로 Account 업데이트.

트리거:
```apex
trigger OpportunityTrigger on Opportunity (after insert, after update) {
    OpportunityHandler opphand = new OpportunityHandler();
    opphand.doAction();
}
```

핸들러:
```apex
public class OpportunityHandler {
    public void doAction() {
        switch on Trigger.OperationType {
            when AFTER_INSERT { OppMaxAmtnName.updateMaxAmount(Trigger.New, null); }
            when AFTER_UPDATE { OppMaxAmtnName.updateMaxAmount(Trigger.New, Trigger.OldMap); }
        }
    }
}
```

헬퍼:
```apex
public class OppMaxAmtnName {
    public static void updateMaxAmount(List<Opportunity> opplist, Map<Id,Opportunity> oldMap) {
        Set<Id> accIds = new Set<Id>();
        Map<Id,Decimal> accMap = new Map<Id,Decimal>();
        Map<Id,String> nameMap = new Map<Id,String>();
        List<Account> acclist = new List<Account>();
        for(Opportunity opp : opplist) {
            if(Trigger.isInsert) {
                if(opp.AccountId != null && opp.Amount != null) accIds.add(opp.AccountId);
            } else if(Trigger.isUpdate) {
                if(opp.AccountId != null && opp.Amount != null && oldMap.get(opp.id).Amount != opp.Amount) accIds.add(opp.AccountId);
            }
        }
        if(!accIds.isEmpty()) {
            for(AggregateResult ag : [SELECT MAX(Amount) max, AccountId FROM Opportunity WHERE AccountId IN :accIds GROUP BY AccountId]) {
                accMap.put((Id)ag.get('AccountId'), (Decimal)ag.get('max'));
            }
            for(Opportunity opp : [SELECT Id, AccountId, Name, Amount FROM Opportunity WHERE AccountId IN :accIds]) {
                if(opp.Amount == accMap.get(opp.AccountId)) nameMap.put(opp.AccountId, opp.Name);
            }
            for(Account acc : [SELECT Id, MaxOppAmount__c, MaxOppName__c FROM Account WHERE Id IN :accIds]) {
                if(accMap.containsKey(acc.Id) && nameMap.containsKey(acc.id)) {
                    Account a = new Account(id=acc.id);
                    a.MaxOppAmount__c = accMap.get(acc.id);
                    a.MaxOppName__c = nameMap.get(acc.id);
                    acclist.add(a);
                }
            }
            if(!acclist.isEmpty()) update acclist;
        }
    }
}
```
