# Apex 트리거 시나리오 (코드 포함)

## 1. Media 산업 Account에 Rating='Hot'
```apex
trigger AccountTrigger on Account (before insert) {
    if (Trigger.isInsert && Trigger.isBefore) AccountTriggerHandler.updateRating(Trigger.New);
}
public class AccountTriggerHandler {
    public static void updateRating(List<Account> accList) {
        for (Account acc : accList) {
            if (acc.Industry == 'Media') acc.Rating = 'Hot';
        }
    }
}
```

## 2. 고액 Opportunity에 Description
```apex
public static void updateDesc(List<Opportunity> oppList) {
    for (Opportunity opp : oppList) {
        if (opp.Amount != null && opp.Amount > 100000) opp.Description = 'Hot Opportunity';
    }
}
```

## 3. 청구→배송 주소 복사
```apex
public static void copyBillingToShipping(List<Account> accList) {
    for (Account acc : accList) {
        if (acc.CopyBillingToShipping__c) {
            acc.ShippingCity = acc.BillingCity; acc.ShippingCountry = acc.BillingCountry;
            acc.ShippingPostalCode = acc.BillingPostalCode; acc.ShippingState = acc.BillingState;
            acc.ShippingStreet = acc.BillingStreet;
        }
    }
}
```

## 4. 새 Position 기본값
```apex
public static void populateDateAndPay(List<Position__c> posList) {
    for (Position__c pos : posList) {
        if (pos.Status__c == 'New Position' && pos.Min_Pay__c == null && pos.Max_Pay__c == null && pos.Open_Date__c == null) {
            pos.Open_Date__c = System.today(); pos.Min_Pay__c = 10000; pos.Max_Pay__c = 15000;
        }
    }
}
```

## 5. Account 생성 시 관련 Contact 생성 (after insert)
```apex
public static void createContact(List<Account> accList) {
    List<Contact> conList = new List<Contact>();
    for (Account acc : accList) {
        conList.add(new Contact(FirstName=acc.Name+'FN', LastName=acc.Name+'LN', AccountId=acc.Id));
    }
    if (!conList.isEmpty()) insert conList;
}
```

## 6. Account 생성 시 관련 Opportunity 생성
```apex
public static void createRelatedOpp(List<Account> accList) {
    List<Opportunity> oppList = new List<Opportunity>();
    for (Account acc : accList) {
        oppList.add(new Opportunity(Name=acc.Name+'opp', AccountId=acc.Id, StageName='Prospecting', CloseDate=System.today()));
    }
    if (!oppList.isEmpty()) insert oppList;
}
```

## 7. Latest Case Number 업데이트
```apex
public static void populateLatestCaseNum(List<Case> caseList) {
    List<Account> accList = new List<Account>();
    for (Case cs : caseList) {
        if (cs.AccountId != null) accList.add(new Account(Id=cs.AccountId, Latest_Case_Number__c=cs.CaseNumber));
    }
    if (!accList.isEmpty()) update accList;
}
```

## 8. Recent Opportunity Amount 업데이트
```apex
public static void populateAmount(List<Opportunity> oppList) {
    List<Account> accList = new List<Account>();
    for (Opportunity opp : oppList) {
        if (opp.Amount != null && opp.AccountId != null) accList.add(new Account(Id=opp.AccountId, Recent_Opp_Amount__c=opp.Amount));
    }
    if (!accList.isEmpty()) update accList;
}
```

## 9. 체크박스 기반 관련 레코드 생성
```apex
public static void createContactOrOpp(List<Account> accList) {
    List<Contact> conList = new List<Contact>();
    List<Opportunity> oppList = new List<Opportunity>();
    for (Account acc : accList) {
        if (acc.Contact__c) conList.add(new Contact(FirstName='con1', LastName='last', AccountId=acc.Id));
        if (acc.Opportunity__c && acc.Active__c == 'Yes') oppList.add(new Opportunity(AccountId=acc.Id, StageName='Prospecting', CloseDate=System.today(), Name='Opp1'));
    }
    if (!oppList.isEmpty()) insert oppList;
    if (!conList.isEmpty()) insert conList;
}
```

## 10. Phone 변경 시 Description 업데이트 (before update)
```apex
public static void updateDescription(List<Account> accList, Map<Id, Account> oldMap) {
    for (Account acc : accList) {
        if (acc.Phone != oldMap.get(acc.Id).Phone) {
            acc.Description = 'Phone is updated! Old Value: ' + oldMap.get(acc.Id).Phone + ' & New Value: ' + acc.Phone;
        }
    }
}
```
