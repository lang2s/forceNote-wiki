# Apex 트리거 시나리오 2

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
