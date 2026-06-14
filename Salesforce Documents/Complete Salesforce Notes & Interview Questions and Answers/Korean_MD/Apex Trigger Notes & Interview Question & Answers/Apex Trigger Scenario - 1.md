# Apex 트리거 시나리오 1

**시나리오: 어떤 Account에 Case가 생성될 때마다 가장 최근 Case 번호를 Account의 Latest Case Number 필드에 기록.**

핸들러 클래스:
```apex
public class UpdateLatestCaseNumberHandler {
    public static void updateAccountLatestCaseNumber(List<Case> cases) {
        Map<Id, String> accountIdToLatestCaseNumberMap = new Map<Id, String>();
        for (Case c : cases) {
            if (c.AccountId != null && c.CaseNumber != null) {
                accountIdToLatestCaseNumberMap.put(c.AccountId, c.CaseNumber);
            }
        }
        List<Account> accountsToUpdate = new List<Account>();
        for (Account acc : [SELECT Id, Name, Latest_Case_Number__c FROM Account WHERE Id IN :accountIdToLatestCaseNumberMap.keySet()]) {
            acc.Latest_Case_Number__c = accountIdToLatestCaseNumberMap.get(acc.Id);
            accountsToUpdate.add(acc);
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
```

트리거:
```apex
trigger UpdateLatestCaseNumber on Case (after insert) {
    UpdateLatestCaseNumberHandler.updateAccountLatestCaseNumber(Trigger.new);
}
```
