---
tags: [soql, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Basic SOQL Query]
---

# 기본 SOQL 쿼리

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

1. **기본:** `[SELECT Id, Name FROM Account]`
2. **WHERE:** `[SELECT Id, Name FROM Contact WHERE LastName = 'Smith']`
3. **ORDER BY:** `[SELECT Id, Name FROM Opportunity ORDER BY CloseDate DESC]`
4. **LIMIT:** `[SELECT Id, Name FROM Account LIMIT 5]`
5. **OFFSET:** `[SELECT Id, Name FROM Account LIMIT 10 OFFSET 5]`
6. **부모→자식:** `[SELECT Id, Name, (SELECT Id, FirstName, LastName FROM Contacts) FROM Account]`
7. **자식→부모:** `[SELECT Id, FirstName, LastName, Account.Name FROM Contact]`
8. **Aggregate:** `[SELECT COUNT(Id) FROM Opportunity WHERE StageName = 'Closed Won']`
9. **GROUP BY:** `[SELECT StageName, COUNT(Id) FROM Opportunity GROUP BY StageName]`
10. **Dynamic SOQL:** `Database.query('SELECT Id, Name FROM Account WHERE Name LIKE \'%Allen%\'')`
11. **FOR UPDATE:** `[SELECT Id, Name FROM Account WHERE Name = 'Allen' FOR UPDATE]` (레코드 잠금)
12. **IN:** `[SELECT Id, FirstName, LastName FROM Contact WHERE Id IN :contactIds]`
13. **Date 함수:** `[SELECT Id, Name FROM Opportunity WHERE CloseDate = LAST_N_DAYS:30]`
14. **Semi-Join:** `[SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Contact)]`
15. **Anti-Join:** `[SELECT Id, Name FROM Account WHERE Id NOT IN (SELECT AccountId FROM Contact)]`
16. **LIKE:** `[SELECT Id, Name FROM Account WHERE Name LIKE 'Acme%']`
17. **Subquery:** `[SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity WHERE StageName = 'Closed Won')]`
18. **Big Object:** `[SELECT Field__c FROM YourBigObject__b WHERE Field__c = 'value']`
19. **Polymorphic:** `[SELECT Id, WhoId, Who.Name FROM Task]`
20. **ALL ROWS(삭제 포함):** `[SELECT Id, Name FROM Account WHERE IsDeleted = true ALL ROWS]`
21. **OFFSET + ORDER BY:** `[SELECT Id, FirstName, LastName FROM Contact ORDER BY LastName ASC LIMIT 50 OFFSET 100]`
22. **Custom Metadata:** `[SELECT DeveloperName, Field__c FROM MyCustomMetadata__mdt]`
23. **롤업 요약:** `[SELECT Id, Name, Total_Opportunities__c FROM Account]`

## 고급
24. **WhoId Polymorphic (Lead/Contact):** `[SELECT Id, Subject, WhoId, Who.Type, Who.Name FROM Task WHERE WhoId != null]`
25. **WhatId Polymorphic:** WhatId는 다양한 표준·커스텀 오브젝트 참조.
26. **TYPEOF:** `[SELECT Id, Subject, TYPEOF Who WHEN Contact THEN FirstName, LastName WHEN Lead THEN Company, Email END FROM Task WHERE WhoId != null]`
27. **TYPEOF + What:** `[SELECT Id, Subject, TYPEOF What WHEN Opportunity THEN Amount WHEN Case THEN Status END FROM Event WHERE WhatId != null]`
28. **Junction 오브젝트:** `[SELECT Campaign.Name, Contact.FirstName, Contact.LastName FROM CampaignMember WHERE Campaign.IsActive = true]`
29. **External 오브젝트:** `[SELECT ExternalId__c, Name__c FROM ExternalObject__x WHERE ExternalId__c = '12345']`
30. **WITH SECURITY_ENFORCED:** `[SELECT Id, FirstName, LastName FROM Contact WITH SECURITY_ENFORCED]`
31. **다중 조건:** `[SELECT Id, Name FROM Account WHERE (Industry = 'Technology' OR Industry = 'Finance') AND AnnualRevenue > 1000000]`
32. **Shield 암호화 필드:** `[SELECT Id, LastName, SSN__c FROM Contact WHERE SSN__c = 'XXX-XX-1234']`
33. **DISTINCT:** `[SELECT DISTINCT Industry FROM Account WHERE Industry != null]`
34. **QueryLocator(대량):** `Database.getQueryLocator([SELECT Id, Name FROM Account])`
35. **Recycle Bin 조회:** `[SELECT Id, Name FROM Account WHERE IsDeleted = true ALL ROWS]`
36. **승인 프로세스:** `[SELECT Id, Status, TargetObject.Name FROM ProcessInstance WHERE TargetObjectId = :recordId]`
