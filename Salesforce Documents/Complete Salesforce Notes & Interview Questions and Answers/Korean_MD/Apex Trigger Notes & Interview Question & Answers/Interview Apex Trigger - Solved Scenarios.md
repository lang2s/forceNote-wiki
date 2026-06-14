# 면접 Apex 트리거 — 해결 시나리오 (41선)

> 원본은 이미지 PDF(24p)로 OCR 추출했습니다. 시나리오 1~14는 "Salesforce scenario based questions" 문서와 동일하며, 코드는 거기서 확인하세요. 아래는 전체 시나리오 목록과 핵심 코드입니다.

## 1~14 (동일 시나리오)
1. Account 삽입 시 Contact 자동 생성
2. Contact 삽입 시 Account 자동 생성 (+ 재귀 방지)
3. Opportunity 생성 시 Account에 총 Opportunity 수·총 금액
4. Contact Department='CSE'면 before insert로 Email 채우기
5. Inputout__c 수정 시 무관계 Dropoff1__c 텍스트 업데이트
6. 하루 레코드 한도 도달 검증
7. 특정 사용자의 Account 삽입/수정/삭제 방지
8. 중복 레코드 오류 메시지
9. 관련 Contact 수 롤업
10. Opportunity Closed Won 시 Account Rating='Hot'
11. (이어지는 시나리오)
12. Opportunity 생성 시 Account 총액 계산
13. Lead 생성 시 Account·Contact·Opportunity 전환
14. Contact 생성 시 Opportunity 필드 업데이트

## 15. 새 Account 생성 시 Rating 설정 (before insert)
```apex
trigger AccTrig on Account (before insert) {
    for (Account a : trigger.new) {
        if(a.Rating == null) a.Rating = 'Hot';
    }
}
```

## 16. Account의 Fax 필드 필수화
```apex
trigger AccTrig on Account (before insert) {
    for (Account a : trigger.new) {
        if (a.Fax == null) a.Fax.addError('Fax field is mandatory');
    }
}
```

## 17. 새 Contact 생성 시 Salutation='Mr' 접두
```apex
trigger ConTrig on Contact (before insert) {
    for (Contact c : Trigger.new) c.Salutation = 'Mr';
}
```

## 18. 동일 이름 Account 중복 삽입 방지 (Map 사용)
```apex
trigger AccountDuplicate on Account (before insert) {
    Set<String> setName = new Set<String>();
    for(Account acc : trigger.new) setName.add(acc.Name);
    Map<String,Account> mapNameWiseAccount = new Map<String,Account>();
    for(Account acc : [SELECT Name, Id FROM Account WHERE Name IN :setName])
        mapNameWiseAccount.put(acc.Name, acc);
    for(Account acc : trigger.new){
        if(mapNameWiseAccount.containsKey(acc.Name))
            acc.Name.addError('Duplicate Account Name');
    }
}
```

## 19. 새 Contact 삽입/수정 시 Account phone을 Contact phone으로 업데이트 (Handler)
```apex
trigger contactTrigger on Contact (after insert, after update) {
    if(trigger.isAfter && trigger.isUpdate)
        contactTriggerHandler.afterUpdateHelper(trigger.new);
}
public class contactTriggerHandler {
    public static void afterUpdateHelper(List<Contact> conList){
        Set<Id> setId = new Set<Id>();
        for(Contact con : conList) setId.add(con.AccountId);
        List<Account> accList = [SELECT Id, Name, (SELECT Name, LastName, Phone, AccountId FROM Contacts)
                                 FROM Account WHERE Id IN :setId];
        // 관련 Account의 phone 업데이트 로직
    }
}
```

## 20. 새 Account 생성 시 Contact 생성
```apex
trigger AccTrig2 on Account (after insert) {
    List<Contact> contList = new List<Contact>();
    for (Account a : Trigger.new){
        contList.add(new Contact(AccountId=a.Id, LastName=a.Name, Phone=a.Phone));
    }
    insert contList;
}
```

## 21. 관련 Opportunity가 있으면 Account 삭제 방지
```apex
trigger DeleteAccountOpportunity on Account (before delete) {
    List<Opportunity> opp = [SELECT AccountId FROM Opportunity WHERE AccountId IN :Trigger.oldMap.keySet()];
    Set<Id> accWithOpp = new Set<Id>();
    for(Opportunity o : opp) accWithOpp.add(o.AccountId);
    for(Account a : Trigger.old){
        if(accWithOpp.contains(a.Id)) a.addError('관련 Opportunity가 있어 삭제할 수 없습니다');
    }
}
```

## 23. 모든 Account 삭제 방지
```apex
trigger test6 on Account (before delete) {
    for (Account a : Trigger.old)
        a.addError('레코드를 삭제할 수 없습니다. 관리자에게 문의하세요');
}
```

## 24. 동일 이름 Account 중복 생성 방지
시나리오 18과 동일(Map 패턴).

## 25. Lead 생성/수정 시 이름에 'Dr.' 접두
```apex
trigger Leadtrig on Lead (before insert, before update) {
    for (Lead l : Trigger.new) l.FirstName = 'Dr.' + l.FirstName;
}
```

## 26. Account 연관 Contact 삭제 방지
```apex
trigger TrigContact on Contact (before delete) {
    for (Contact c : Trigger.old) {
        if(c.AccountId != null) c.addError('Can not delete contact');
    }
}
```

## 27. 전화번호가 10자리가 아니면 오류
```apex
trigger AccTrig23 on Account (before insert, before update) {
    for (Account a : Trigger.new){
        if(a.Phone != null && a.Phone.length() != 10)
            a.Phone.addError('전화번호는 10자리여야 합니다');
    }
}
```

## 28. Contact 생성 시 연관 Account에서 status 필드 업데이트
연관 Account의 필드를 Contact로 복사하는 before/after insert 패턴.

## 29. 새 Account 생성 전, 동일 이름 Contact 레코드 모두 삭제
before insert에서 동일 이름 Contact 쿼리 후 delete.

## 30. Account 삽입 시 Contact 자동 생성
시나리오 1과 동일.
```apex
trigger SCENARIO on Account (after insert) {
    list<contact> c = new list<contact>();
    for(Account a : trigger.new){
        c.add(new Contact(LastName=a.Name, AccountId=a.Id));
    }
    insert c;
}
```

## 31. Opportunity 생성 시 Account 총 Opportunity 수·총액
시나리오 3과 동일.

## 32. 특정 사용자의 Account 삽입/수정/삭제 방지
```apex
trigger AccountDuplicate on Account (before insert, before update, before delete) {
    for (Account a : Trigger.new) a.addError('접근 권한은 Admin에 문의하세요');
}
```

## 33. Opportunity Closed Won 시 Account Rating='Hot'
```apex
trigger updateAccountRating on Opportunity (after insert, after update) {
    Set<Id> accIds = new Set<Id>();
    for(Opportunity o : Trigger.new){
        if(o.StageName == 'Closed Won') accIds.add(o.AccountId);
    }
    List<Account> accounts = new List<Account>();
    for(Id aid : accIds) accounts.add(new Account(Id=aid, Rating='Hot'));
    if(!accounts.isEmpty()) update accounts;
}
```

## 34. Account name 업데이트 시 관련 레코드에 name 반영

## 35. Annual Revenue > 50000인 Account 생성 시 'Pranay Mehare' Contact 추가
```apex
trigger AccTrig on Account (after insert) {
    List<Contact> conList = new List<Contact>();
    for(Account a : Trigger.new){
        if(a.AnnualRevenue != null && a.AnnualRevenue > 50000)
            conList.add(new Contact(LastName='Pranay Mehare', AccountId=a.Id));
    }
    if(!conList.isEmpty()) insert conList;
}
```

## 36. Lead Source='WEB'면 rating 설정
```apex
trigger LeadTrig on Lead (before insert) {
    for(Lead l : Trigger.new){
        if(l.LeadSource == 'Web') l.Rating = 'Hot';
    }
}
```

## 37. Contact가 2개 이상이면 Account 삭제 방지
```apex
trigger PreventAccDelete on Account (before delete) {
    for(Account a : [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :Trigger.oldMap.keySet()]){
        if(a.Contacts.size() >= 2) Trigger.oldMap.get(a.Id).addError('Contact가 2개 이상이면 삭제할 수 없습니다');
    }
}
```

## 38. Lead 생성/수정 시 Email 중복 확인
```apex
trigger LeadDup on Lead (before insert, before update) {
    Set<String> emails = new Set<String>();
    for(Lead l : Trigger.new) if(l.Email != null) emails.add(l.Email);
    Map<String,Lead> existing = new Map<String,Lead>();
    for(Lead l : [SELECT Email FROM Lead WHERE Email IN :emails]) existing.put(l.Email, l);
    for(Lead l : Trigger.new){
        if(l.Email != null && existing.containsKey(l.Email)) l.Email.addError('이미 존재하는 Email');
    }
}
```

## 39. Account phone 수정 시 관련 Contact의 OtherPhone에 이전 값 저장
```apex
trigger AccPhone on Account (after update) {
    Map<Id,Account> changed = new Map<Id,Account>();
    for(Account a : Trigger.new){
        if(a.Phone != Trigger.oldMap.get(a.Id).Phone) changed.put(a.Id, Trigger.oldMap.get(a.Id));
    }
    List<Contact> conList = new List<Contact>();
    for(Contact c : [SELECT Id, AccountId, OtherPhone FROM Contact WHERE AccountId IN :changed.keySet()]){
        c.OtherPhone = changed.get(c.AccountId).Phone;
        conList.add(c);
    }
    if(!conList.isEmpty()) update conList;
}
```

## 40. 트리거로 Account의 Contact 수 카운트 (롤업 트리거)
```apex
trigger CountContacts on Contact (after insert, after update, after delete, after undelete) {
    Set<Id> accIds = new Set<Id>();
    List<Contact> ctx = (Trigger.isDelete) ? Trigger.old : Trigger.new;
    for(Contact c : ctx) if(c.AccountId != null) accIds.add(c.AccountId);
    List<Account> accList = new List<Account>();
    for(Account a : [SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accIds]){
        a.Number_of_Contacts__c = a.Contacts.size();
        accList.add(a);
    }
    if(!accList.isEmpty()) update accList;
}
```

## 41. 트리거의 재귀 (Recursion)
```apex
public class CreateCont {
    public static Boolean isFirst = true;
}
trigger TrigCont on Contact (before insert){
    if(trigger.isInsert && Trigger.isBefore && CreateCont.isFirst){
        CreateCont.isFirst = false;  // 재귀 방지
        // CreateConts(Trigger.New); 핸들러 호출
    }
}
```
