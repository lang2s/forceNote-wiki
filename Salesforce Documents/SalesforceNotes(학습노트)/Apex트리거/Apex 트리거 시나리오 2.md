---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Trigger Scenario - 2]
---

# Apex 트리거 시나리오 2

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**시나리오: Account 삽입 시 CopyBillingToShipping(커스텀 필드) 체크박스가 체크되면 청구 주소를 배송 주소로 자동 복사.**

핸들러:
```apex
public class CopyBillingToShippingClass {
    public static void copyBillingToShippingFunc(List<Account> incomingRecords){
        for(Account acc : incomingRecords){
            if(acc.BillingToShippingCheckbox__c == true){
                acc.ShippingStreet = acc.BillingStreet;
                acc.ShippingCity = acc.BillingCity;
                acc.ShippingState = acc.BillingState;
                acc.ShippingPostalCode = acc.BillingPostalCode;
                acc.ShippingCountry = acc.BillingCountry;
            }
        }
    }
}
```

트리거:
```apex
trigger CopyBillingToShippingTrigger on Account (before insert){
    if(Trigger.isInsert && Trigger.isBefore){
        CopyBillingToShippingClass.copyBillingToShippingFunc(Trigger.New);
    }
}
```
