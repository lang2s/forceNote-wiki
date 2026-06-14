---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Trigger Scenario - 1]
---

# Apex 트리거 시나리오 1

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

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
