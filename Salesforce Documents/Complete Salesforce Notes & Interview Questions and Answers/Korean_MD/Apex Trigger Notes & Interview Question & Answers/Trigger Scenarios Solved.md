# Apex 트리거 해결 시나리오 (코드 포함)

> Salesforce 개발 스킬 향상을 위한 트리거 사용 사례와 솔루션. (커스텀 필드는 `__c`로 표기)

## 1. Account 생성 시 Industry='Media'면 Rating='Hot'
```apex
trigger AccountTrigger on Account (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        AccountTriggerHandler.updateRating(Trigger.New);
    }
}
public class AccountTriggerHandler {
    public static void updateRating(List<Account> accList){
        for(Account acc : accList){
            if(acc.Industry != null && acc.Industry == 'Media') acc.Rating = 'Hot';
        }
    }
}
```

## 2. Opportunity 생성 시 Amount>100000이면 Description='Hot Opportunity'
```apex
public static void updateDesc(List<Opportunity> oppList){
    for(Opportunity opp : oppList){
        if(opp.Amount != null && opp.Amount > 100000) opp.Description = 'Hot Opportunity';
    }
}
```

## 3. Account 삽입 시 CopyBillingToShipping__c 체크되면 청구→배송 주소 복사
```apex
public static void updateAddress(List<Account> accList){
    for(Account acc : accList){
        if(acc.CopyBillingToShipping__c && acc.BillingCity != null && acc.BillingCountry != null
           && acc.BillingPostalCode != null && acc.BillingState != null && acc.BillingStreet != null){
            acc.ShippingCity = acc.BillingCity;
            acc.ShippingCountry = acc.BillingCountry;
            acc.ShippingPostalCode = acc.BillingPostalCode;
            acc.ShippingState = acc.BillingState;
            acc.ShippingStreet = acc.BillingStreet;
        }
    }
}
```

## 4. 새 Position__c에 기본값(Open Date=오늘, Min Pay=10000, Max Pay=15000)
```apex
public static void populateDateAndPay(List<Position__c> posList){
    for(Position__c pos : posList){
        if(pos.Status__c == 'New Position' && pos.Min_Pay__c == null
           && pos.Max_Pay__c == null && pos.Open_Date__c == null){
            pos.Open_Date__c = System.today();
            pos.Min_Pay__c = 10000;
            pos.Max_Pay__c = 15000;
        }
    }
}
```

## 5. Account 생성 시 관련 Contact 생성 (after insert)
```apex
public static void createContact(List<Account> accList){
    List<Contact> conList = new List<Contact>();
    for(Account acc : accList){
        Contact con = new Contact();
        con.FirstName = acc.Name + 'FN';
        con.LastName = acc.Name + 'LN';
        con.AccountId = acc.Id;
        conList.add(con);
    }
    if(!conList.isEmpty()) insert conList;
}
```

## 6. Account 생성 시 관련 Opportunity 생성
```apex
public static void createRelatedOpp(List<Account> accList){
    List<Opportunity> oppList = new List<Opportunity>();
    for(Account acc : accList){
        Opportunity opp = new Opportunity();
        opp.Name = acc.Name + 'opp';
        opp.AccountId = acc.Id;
        opp.StageName = 'Prospecting';
        opp.CloseDate = System.today();
        oppList.add(opp);
    }
    if(!oppList.isEmpty()) insert oppList;
}
```

## 7. Case 생성 시 Account의 'Latest Case Number' 채우기
```apex
public static void populateLatestCaseNum(List<Case> caseList){
    List<Account> accList = new List<Account>();
    for(Case cs : caseList){
        if(cs.AccountId != null){
            accList.add(new Account(Id = cs.AccountId, Latest_Case_Number__c = cs.CaseNumber));
        }
    }
    if(!accList.isEmpty()) update accList;
}
```

## 8. Account의 'Recent Opportunity Amount'에 최근 Opportunity 금액
```apex
public static void populateAmount(List<Opportunity> oppList){
    List<Account> accList = new List<Account>();
    for(Opportunity opp : oppList){
        if(opp.Amount != null && opp.AccountId != null){
            accList.add(new Account(Id = opp.AccountId, Recent_Opp_Amount__c = opp.Amount));
        }
    }
    if(!accList.isEmpty()) update accList;
}
```

## 9. 체크박스(Contact__c / Opportunity__c) 기반 관련 레코드 생성
Opportunity는 Active__c='Yes'일 때만 생성.
```apex
public static void createContactOrOpp(List<Account> accList){
    List<Contact> conList = new List<Contact>();
    List<Opportunity> oppList = new List<Opportunity>();
    for(Account acc : accList){
        if(acc.Contact__c){
            conList.add(new Contact(FirstName='con1', LastName='last', AccountId=acc.Id));
        }
        if(acc.Opportunity__c && acc.Active__c == 'Yes'){
            oppList.add(new Opportunity(AccountId=acc.Id, StageName='Prospecting',
                CloseDate=System.today(), Name='Opp1'));
        }
    }
    if(!oppList.isEmpty()) insert oppList;
    if(!conList.isEmpty()) insert conList;
}
```

## 10. Account phone 업데이트 시 Description에 이전/새 값 (before update)
```apex
public static void updateDescription(List<Account> accList, Map<Id,Account> oldMap){
    for(Account acc : accList){
        if(acc.Phone != oldMap.get(acc.Id).Phone){
            acc.Description = 'Phone is updated! Old Value : ' + oldMap.get(acc.Id).Phone
                              + ' & New Value : ' + acc.Phone;
        }
    }
}
```

## 11. Account 삽입/업데이트 시 CopyBillingToShipping 체크되면 주소 복사
```apex
public static void copyBillToShip(List<Account> accList, Map<Id,Account> oldMap){
    for(Account acc : accList){
        if((oldMap == null && acc.CopyBillingToShipping__c) ||
           (!oldMap.get(acc.Id).CopyBillingToShipping__c && acc.CopyBillingToShipping__c)){
            acc.ShippingCity = acc.BillingCity;
            acc.ShippingCountry = acc.BillingCountry;
            acc.ShippingPostalCode = acc.BillingPostalCode;
            acc.ShippingState = acc.BillingState;
            acc.ShippingStreet = acc.BillingStreet;
        }
    }
}
```

## 12. Account 생성/업데이트 시 Industry='Media'면 Rating='Hot'
```apex
public static void updateIndustryRating(List<Account> accList, Map<Id,Account> oldMap){
    for(Account acc : accList){
        if((oldMap == null && acc.Industry == 'Media') ||
           (acc.Industry == 'Media' && acc.Industry != oldMap.get(acc.Id).Industry)){
            acc.Rating = 'Hot';
        }
    }
}
```

## 13. Opportunity Stage 변경 시 Description 업데이트
```apex
public static void updateDesc(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
    for(Opportunity opp : oppList){
        if(oldMap == null || opp.StageName != oldMap.get(opp.Id).StageName){
            if(opp.StageName == 'Closed Won') opp.Description = 'Opportunity is Closed Won';
            else if(opp.StageName == 'Closed Lost') opp.Description = 'Opportunity is Closed Lost';
            else opp.Description = 'Opportunity is open';
        }
    }
}
```

## 14. Account phone 업데이트 시 관련 Contact Home Phone 채우기 [Map]
```apex
public static void updateRelatedConts(List<Account> accList, Map<Id,Account> oldMap){
    List<Contact> conList = new List<Contact>();
    Map<Id,Account> accToAccountMap = new Map<Id,Account>();
    for(Account acc : accList){
        if(oldMap != null && acc.Phone != null && acc.Phone != oldMap.get(acc.Id).Phone){
            accToAccountMap.put(acc.Id, acc);
        }
    }
    for(Contact cont : [SELECT Id, HomePhone, AccountId FROM Contact
                        WHERE AccountId IN :accToAccountMap.keySet()]){
        cont.HomePhone = accToAccountMap.get(cont.AccountId).Phone;
        conList.add(cont);
    }
    if(!conList.isEmpty()) update conList;
}
```

## 15. 동일 (Parent-Child SOQL)
```apex
public static void updateRelatedContsWithoutMap(List<Account> accList, Map<Id,Account> oldMap){
    List<Contact> conList = new List<Contact>();
    Set<Id> accIds = new Set<Id>();
    for(Account acc : accList){
        if(oldMap != null && acc.Phone != null && acc.Phone != oldMap.get(acc.Id).Phone){
            accIds.add(acc.Id);
        }
    }
    for(Account acc : [SELECT Id, Phone, (SELECT HomePhone FROM Contacts)
                       FROM Account WHERE Id IN :accIds]){
        for(Contact con : acc.Contacts){
            con.HomePhone = acc.Phone;
            conList.add(con);
        }
    }
    if(!conList.isEmpty()) update conList;
}
```

## 16. Account 청구 주소 업데이트 시 관련 Contact 우편 주소 [Map]
```apex
public static void updateRelatedContactMail(List<Account> accList, Map<Id,Account> oldMap){
    List<Contact> conList = new List<Contact>();
    Map<Id,Account> accToAccountMap = new Map<Id,Account>();
    for(Account acc : accList){
        if(oldMap != null && (
           !acc.BillingCity.equals(oldMap.get(acc.Id).BillingCity) ||
           !acc.BillingCountry.equals(oldMap.get(acc.Id).BillingCountry) ||
           !acc.BillingPostalCode.equals(oldMap.get(acc.Id).BillingPostalCode) ||
           !acc.BillingState.equals(oldMap.get(acc.Id).BillingState) ||
           !acc.BillingStreet.equals(oldMap.get(acc.Id).BillingStreet))){
            accToAccountMap.put(acc.Id, acc);
        }
    }
    for(Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accToAccountMap.keySet()]){
        Account a = accToAccountMap.get(con.AccountId);
        con.MailingCountry = a.BillingCountry;
        con.MailingCity = a.BillingCity;
        con.MailingState = a.BillingState;
        con.MailingPostalCode = a.BillingPostalCode;
        con.MailingStreet = a.BillingStreet;
        conList.add(con);
    }
    if(!conList.isEmpty()) update conList;
}
```

## 17. 동일 (Parent-Child SOQL)
```apex
for(Account acc : [SELECT Id, BillingCountry, BillingCity, BillingState, BillingPostalCode,
                   BillingStreet, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :idSet]){
    for(Contact cont : acc.Contacts){
        cont.MailingCountry = acc.BillingCountry;
        cont.MailingCity = acc.BillingCity;
        cont.MailingState = acc.BillingState;
        cont.MailingPostalCode = acc.BillingPostalCode;
        cont.MailingStreet = acc.BillingStreet;
        conList.add(cont);
    }
}
```

## 18. Opportunity Stage 변경 시 Task 생성·할당
```apex
public static void createTask(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
    List<Task> tList = new List<Task>();
    for(Opportunity opp : oppList){
        if(opp.StageName != oldMap.get(opp.Id).StageName){
            Task t = new Task();
            t.WhatId = opp.Id;
            t.Subject = 'Email';
            t.Priority = 'Normal';
            t.Status = 'Not Started';
            t.OwnerId = UserInfo.getUserId();
            tList.add(t);
        }
    }
    if(!tList.isEmpty()) insert tList;
}
```

## 19. Account Active 'Yes'→'No' 시 관련 Opportunity를 Closed Lost로 (Closed Won 제외)
```apex
public static void updateOpportunityStage(List<Account> accList, Map<Id,Account> oldMap){
    List<Opportunity> oppList = new List<Opportunity>();
    Set<Id> idSet = new Set<Id>();
    for(Account acc : accList){
        if(acc.Active__c == 'No' && acc.Active__c != oldMap.get(acc.Id).Active__c) idSet.add(acc.Id);
    }
    for(Account a : [SELECT Id, Active__c, (SELECT Id, StageName FROM Opportunities)
                     FROM Account WHERE Id IN :idSet]){
        for(Opportunity opp : a.Opportunities){
            if(opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost'){
                opp.StageName = 'Closed Lost';
                oppList.add(opp);
            }
        }
    }
    if(!oppList.isEmpty()) update oppList;
}
```

## 20. Active='Yes'면 Account 삭제 방지 (before delete)
```apex
public static void preventDel(List<Account> accList){
    for(Account acc : accList){
        if(acc.Active__c == 'Yes') acc.addError(Label.Prevent_Account_Deletion);
    }
}
```

## 21. 생성 7일 지난 Account 편집 방지
```apex
public static void preventAccEdit(List<Account> accList){
    for(Account acc : accList){
        if(acc.CreatedDate < System.today()-6){
            acc.addError('7일 전에 생성된 Account는 업데이트할 수 없습니다');
        }
    }
}
```

## 22. addError()로 Opportunity 생성 시 Amount null이면 오류
```apex
public static void validateAmount(List<Opportunity> oppList){
    for(Opportunity opp : oppList){
        if(opp.Amount == null) opp.addError('Amount field can not be null');
    }
}
```

## 23. Closed Lost인데 Reason 미입력이면 검증 오류 (before update)
```apex
public static void populateClosedReason(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
    for(Opportunity opp : oppList){
        if(opp.StageName == 'Closed Lost' && opp.StageName != oldMap.get(opp.Id).StageName
           && opp.Closed_Lost_Reason__c == null){
            opp.addError('Please populate Closed Lost Reason');
        }
    }
}
```

## 24. System Administrator만 Account 삭제 가능
```apex
public static void checkProfileForDeletion(List<Account> accList){
    Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    for(Account acc : accList){
        if(UserInfo.getProfileId() != p.Id) acc.addError('Only System Administrator can delete Account');
    }
}
```

## 25. Closed Opportunity는 System Administrator만 삭제 가능
```apex
public static void checkProfileForDeletion(List<Opportunity> oppList){
    Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    for(Opportunity opp : oppList){
        if(opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost'){
            if(UserInfo.getProfileId() != p.Id) opp.addError('Only System administrator can delete opportunity');
        }
    }
}
```

## 26. 관련 Opportunity가 있으면 Account 삭제 방지
```apex
public static void preventDelIfHasRelatedOpp(List<Account> accList){
    Set<Id> idSet = new Set<Id>();
    for(Account acc : accList) idSet.add(acc.Id);
    for(Account acc : [SELECT Id, (SELECT Id FROM Opportunities) FROM Account WHERE Id IN :idSet]){
        if(acc.Opportunities.size() > 0) acc.addError('Opportunity가 있는 Account는 삭제할 수 없습니다');
    }
}
```

## 27. 관련 Case가 있으면 Account 삭제 방지
```apex
for(Account acc : [SELECT Id, (SELECT Id FROM Cases) FROM Account WHERE Id IN :idSet]){
    if(acc.Cases.size() > 0) acc.addError('Case가 있는 Account는 삭제할 수 없습니다');
}
```

## 28. Employee 삭제 시 Account의 'Left Employee Count' 업데이트 (after delete)
Account별 카운트를 Map으로 집계 후 누적 업데이트.
```apex
public static void leftEmpCount(List<Employee__c> oldEmpList){
    Set<Id> accIds = new Set<Id>();
    Map<Id,Decimal> accIdToTotalCount = new Map<Id,Decimal>();
    for(Employee__c emp : oldEmpList){
        if(emp.Account__c != null) accIds.add(emp.Account__c);
    }
    Map<Id,Account> accIdToAccMap = new Map<Id,Account>(
        [SELECT Id, Left_Employee_Count__c FROM Account WHERE Id IN :accIds]);
    for(Employee__c emp : oldEmpList){
        if(emp.Account__c != null && accIdToAccMap.containsKey(emp.Account__c)){
            Decimal base = accIdToTotalCount.containsKey(emp.Account__c)
                ? accIdToTotalCount.get(emp.Account__c)
                : accIdToAccMap.get(emp.Account__c).Left_Employee_Count__c;
            accIdToTotalCount.put(emp.Account__c, base + 1);
        }
    }
    List<Account> accToBeUpdated = new List<Account>();
    for(Id accId : accIdToTotalCount.keySet()){
        accToBeUpdated.add(new Account(Id=accId, Left_Employee_Count__c=accIdToTotalCount.get(accId)));
    }
    if(!accToBeUpdated.isEmpty()) update accToBeUpdated;
}
```

## 29. Employee 복원 시 Active=true (after undelete)
```apex
public static void unDeletionofEmp(List<Employee__c> empList){
    List<Employee__c> toUpdate = new List<Employee__c>();
    for(Employee__c emp : empList){
        toUpdate.add(new Employee__c(Id=emp.Id, Active__c=true));
    }
    if(!toUpdate.isEmpty()) update toUpdate;
}
```

## 30. Employee 복원 시 'Left Employee Count' 감소
시나리오 28과 동일하나 `+1` 대신 `-1`로 카운트 감소.

## 31. Employee 삽입·삭제·복원 시 'Present Employee Count' 업데이트 [Parent-Child SOQL]
```apex
trigger EmployeeTrigger on Employee__c (after insert, after delete, after undelete) {
    if(Trigger.isAfter){
        List<Employee__c> ctx = (Trigger.isDelete) ? Trigger.old : Trigger.new;
        EmployeeTriggerHandler.updatePresentEmpCount(ctx);
    }
}
public static void updatePresentEmpCount(List<Employee__c> empList){
    List<Account> accList = new List<Account>();
    Set<Id> idSet = new Set<Id>();
    for(Employee__c emp : empList){
        if(emp.Account__c != null) idSet.add(emp.Account__c);
    }
    for(Account acc : [SELECT Id, Name, (SELECT Id FROM Employees__r) FROM Account WHERE Id IN :idSet]){
        acc.Present_Employee_Count__c = acc.Employees__r.size();
        accList.add(acc);
    }
    if(!accList.isEmpty()) update accList;
}
```

## 32. Contact 생성 시 지정 템플릿으로 이메일 전송
```apex
public static void sendEmailToContact(List<Contact> conList){
    List<Messaging.Email> emailList = new List<Messaging.Email>();
    for(Contact con : conList){
        if(con.Email != null){
            Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
            emailMsg.setToAddresses(new String[]{con.Email});
            emailMsg.setSubject('Welcome ' + con.FirstName);
            emailMsg.setSenderDisplayName('Sanjay Gupta');
            emailMsg.setHtmlBody('Hi ' + con.FirstName + ',<br/><br/>'
                + 'Welcome to SalesForce EcoSystem! <br/><br/>Happy learning! <br/><br/>Thank you!');
            emailList.add(emailMsg);
        }
    }
    Messaging.sendEmail(emailList);
}
```

## 33. "Partner Case"·"Customer Case" 레코드 타입별 카운트를 Account에
```apex
public static void countCases(List<Case> cList){
    List<Account> accList = new List<Account>();
    Set<Id> idSet = new Set<Id>();
    Id partnerRtId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Partner_Case'].Id;
    Id customerRtId = [SELECT Id FROM RecordType WHERE Name = 'Customer Case'].Id;
    for(Case c : cList){ if(c.AccountId != null) idSet.add(c.AccountId); }
    for(Account acc : [SELECT Id, Total_Case__c, Customer_Case__c, Partner_Case__c,
                       (SELECT Id, RecordTypeId FROM Cases) FROM Account WHERE Id IN :idSet]){
        Decimal countPartner = 0, countCustomer = 0;
        for(Case c : acc.Cases){
            if(c.RecordTypeId == partnerRtId) countPartner++;
            else if(c.RecordTypeId == customerRtId) countCustomer++;
        }
        acc.Customer_Case__c = countCustomer;
        acc.Partner_Case__c = countPartner;
        acc.Total_Case__c = countCustomer + countPartner;
        accList.add(acc);
    }
    if(!accList.isEmpty()) update accList;
}
```

## 34. Opportunity 생성/금액 업데이트/삭제/복원 시 Account Annual Revenue 롤업
```apex
public static void populateAmountOnAccount(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
    Set<Id> accIds = new Set<Id>();
    for(Opportunity opp : oppList){
        if(oldMap != null){
            if(opp.AccountId != null && opp.Amount != null && opp.Amount != oldMap.get(opp.Id).Amount)
                accIds.add(opp.AccountId);
        } else {
            if(opp.AccountId != null && opp.Amount != null) accIds.add(opp.AccountId);
        }
    }
    List<Account> accList = [SELECT Id, AnnualRevenue, (SELECT Id, Amount FROM Opportunities)
                            FROM Account WHERE Id IN :accIds];
    for(Account acc : accList){
        Decimal total = 0;
        for(Opportunity opp : acc.Opportunities){ if(opp.Amount != null) total += opp.Amount; }
        acc.AnnualRevenue = total;
    }
    if(!accList.isEmpty()) update accList;
}
```

## 35. Database 클래스 + addError() (부분 처리)
```apex
public static void createOpp(List<Account> accList){
    List<Opportunity> oppList = new List<Opportunity>();
    for(Account acc : accList){
        oppList.add(new Opportunity(Name=acc.Name, AccountId=acc.Id, StageName='Prospecting'));
    }
    Database.SaveResult[] srList = Database.insert(oppList, false);
    for(Integer i=0; i<srList.size(); i++){
        if(!srList[i].isSuccess()){
            String errors = '';
            for(Database.Error err : srList[i].getErrors()) errors += err.getMessage();
            accList[i].addError(errors);
        }
    }
}
```

## 36. Apex 트리거 재귀 방지
정적 boolean/Set 변수로 트리거 1회 실행 보장.

## 37. Closed Won/Lost 시 Description 업데이트 (재귀 처리)
```apex
public class preventRecursion {
    public static Boolean firstCall = false;
}
trigger OpportunityTrigger on Opportunity (after update){
    if(Trigger.isAfter && Trigger.isUpdate && !preventRecursion.firstCall){
        preventRecursion.firstCall = true;
        OpportunityTriggerHandler.updateStageRecursion(Trigger.New, Trigger.oldMap);
    }
}
public static void updateStageRecursion(List<Opportunity> oppList, Map<Id,Opportunity> oldMap){
    List<Opportunity> toUpdate = new List<Opportunity>();
    for(Opportunity opp : oppList){
        if(opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost'){
            Opportunity o = new Opportunity(Id=opp.Id);
            o.Description = (opp.StageName == 'Closed Won') ? 'Opportunity is Closed Won' : 'Opportunity is Closed Lost';
            toUpdate.add(o);
        }
    }
    if(!toUpdate.isEmpty()) update toUpdate;
}
```

## 38. Account 소유자 변경 시 관련 Contact 소유자도 변경 [Map 없이]
```apex
public static void updateOwnerOfRelatedContact(List<Account> accList, Map<Id,Account> oldMap){
    List<Contact> conList = new List<Contact>();
    Set<Id> idSet = new Set<Id>();
    for(Account acc : accList){
        if(acc.OwnerId != oldMap.get(acc.Id).OwnerId) idSet.add(acc.Id);
    }
    for(Account acc : [SELECT Id, OwnerId, (SELECT OwnerId FROM Contacts) FROM Account WHERE Id IN :idSet]){
        for(Contact c : acc.Contacts){ c.OwnerId = acc.OwnerId; conList.add(c); }
    }
    if(!conList.isEmpty()) update conList;
}
```

## 39. 동일 [Map 사용]
```apex
Map<Id,Account> accToAccountMap = new Map<Id,Account>();
for(Account acc : accList){
    if(acc.OwnerId != oldMap.get(acc.Id).OwnerId) accToAccountMap.put(acc.Id, acc);
}
for(Contact con : [SELECT AccountId, OwnerId FROM Contact WHERE AccountId IN :accToAccountMap.keySet()]){
    con.OwnerId = accToAccountMap.get(con.AccountId).OwnerId;
    conList.add(con);
}
```

## 40. System Administrator 활성 User 삽입 시 "Admins" Public Group에 추가
```apex
public static void addUserToGroup(List<User> usList){
    Id systemAdminId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
    Id groupId = [SELECT Id FROM Group WHERE Name='Admins'].Id;
    List<GroupMember> groupList = new List<GroupMember>();
    for(User us : usList){
        if(us.ProfileId == systemAdminId && us.IsActive){
            groupList.add(new GroupMember(GroupId=groupId, UserOrGroupId=us.Id));
        }
    }
    if(!groupList.isEmpty()) insert groupList;
}
```

## 41. Contact Email 기반 중복 방지
```apex
public static void preventDuplicateEmail(List<Contact> conList, Map<Id,Contact> oldMap){
    Set<String> emailSet = new Set<String>();
    for(Contact con : conList){
        if(oldMap == null && con.Email != null) emailSet.add(con.Email);
        else if(con.Email != null && con.Email != oldMap.get(con.Id).Email) emailSet.add(con.Email);
    }
    Set<String> existing = new Set<String>();
    for(Contact con : [SELECT Id, Email FROM Contact WHERE Email IN :emailSet]) existing.add(con.Email);
    for(Contact con : conList){
        if(existing.contains(con.Email)) con.addError('Duplicate email');
    }
}
```

## 42. OWD=Private. Account 생성 시 Standard User에게 자동 공유
```apex
public static void shareAccWithStdUser(List<Account> accList){
    Id stdUserId = [SELECT Id FROM Profile WHERE Name='Standard User'].Id;
    List<User> users = [SELECT Id FROM User WHERE ProfileId = :stdUserId AND IsActive=true LIMIT 1];
    List<AccountShare> accShareList = new List<AccountShare>();
    for(Account acc : accList){
        AccountShare aShare = new AccountShare();
        aShare.UserOrGroupId = users[0].Id;
        aShare.AccountId = acc.Id;
        aShare.RowCause = 'Manual';
        aShare.AccountAccessLevel = 'Edit';
        aShare.OpportunityAccessLevel = 'Edit';
        accShareList.add(aShare);
    }
    if(!accShareList.isEmpty()) insert accShareList;
}
```

## 43. Trigger.isExecuting 컨텍스트 변수 데모
```apex
public class AccountHandler{
    public Boolean handleAccount(List<Account> accList){
        System.debug('Trigger is executing : ' + Trigger.isExecuting);
        if(Trigger.isExecuting){
            // 트리거 호출의 일부로 수행할 작업
        } else {
            // 컨트롤러 등 다른 컨텍스트에서 호출된 경우 수행할 작업
        }
        return Trigger.isExecuting;
    }
}
```
