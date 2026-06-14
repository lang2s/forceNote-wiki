---
tags: [soql, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SOQL Queries]
---

# SOQL 쿼리 Q&A와 시나리오

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 질문

**SOQL Query란?** Salesforce 오브젝트에서 레코드를 검색·조회하는 쿼리 언어. SQL 유사, Salesforce 전용.

**모든 필드 조회?** SOQL은 `SELECT *`를 지원하지 않음(원문엔 *로 언급되나 실제로는 필드 명시 필요).

**SOQL vs SOSL?** SOQL은 한 번에 단일 오브젝트 검색·조회(SELECT). SOSL은 여러 오브젝트에 텍스트 검색.

**조건 필터?** WHERE 절. `SELECT Name FROM Account WHERE Industry = 'Technology'`

**관계 레코드 조회?** 관계 필드·점 표기. `SELECT Name, Account__r.Name FROM Invoice__c`

**레코드 수 제한?** LIMIT. `SELECT Name FROM Account LIMIT 10`

**정렬?** ORDER BY(ASC/DESC). `SELECT Name FROM Account ORDER BY Name DESC`

**쿼리 vs 서브쿼리?** 쿼리는 단일 오브젝트, 서브쿼리는 다른 쿼리에 중첩(관련 오브젝트 조회·필터).

**Aggregate 함수?** COUNT, SUM, AVG, MAX, MIN.

## 시나리오

1. 모든 Account: `SELECT Name, Industry, BillingCity, BillingState FROM Account`
2. Account 관련 Contact: `SELECT Name, Email, Phone FROM Contact WHERE AccountId = '001...'`
3. $10,000 초과 Opportunity: `SELECT Name, StageName, Amount FROM Opportunity WHERE Amount > 10000`
4. 최근 30일 Case: `SELECT CaseNumber, Subject, Status FROM Case WHERE CreatedDate = LAST_N_DAYS:30`
5. 전환된 Lead: `SELECT Name, ConvertedAccountId, ConvertedOpportunityId FROM Lead WHERE IsConverted = TRUE`
6. 특정 Product Family: `SELECT Name, ProductCode, IsActive FROM Product2 WHERE ProductFamily = 'Electronics'`
7. 특정 User Task: `SELECT Subject, Status, Priority FROM Task WHERE OwnerId = '005...'`
8. 커스텀 필드 정렬: `SELECT Name, CustomField__c FROM Custom_Object__c ORDER BY CustomField__c ASC`
9. Account + Opportunity: `SELECT Name, (SELECT Name, StageName, Amount FROM Opportunities) FROM Account`
10. Campaign + Lead 수: `SELECT Name, (SELECT Id FROM Leads) FROM Campaign`
11. Account + Contact 이메일: `SELECT Name, (SELECT Email FROM Contacts) FROM Account`
12. 이번 분기 마감: `SELECT Name, CloseDate FROM Opportunity WHERE CloseDate = THIS_QUARTER`
13. 특정 사용자 Case + Account: `SELECT CaseNumber, Account.Name FROM Case WHERE OwnerId = '005...'`
14. 최근 30일 Lead: `SELECT FirstName, LastName, CreatedDate FROM Lead WHERE CreatedDate = LAST_N_DAYS:30`
15. "In Progress" Project: `SELECT Name, Status__c FROM Project__c WHERE Status__c = 'In Progress'`
17. Account별 Closed Won 합계: `SELECT Account.Name, SUM(Amount) FROM Opportunity WHERE StageName = 'Closed Won' GROUP BY Account.Name`
18. 재고 10 미만: `SELECT Name, Quantity__c FROM Product__c WHERE Quantity__c < 10`
19. 금액 상위 5: `SELECT Name, Amount FROM Opportunity ORDER BY Amount DESC LIMIT 5`
20. 연체 Task(현재 사용자): `SELECT Subject, ActivityDate FROM Task WHERE IsClosed = FALSE AND ActivityDate < TODAY AND OwnerId = '005...'`
22. 30일 내 마감: `SELECT Name, CloseDate FROM Opportunity WHERE CloseDate >= NEXT_N_DAYS:0 AND CloseDate <= NEXT_N_DAYS:30`
24. Source별 Lead 수: `SELECT LeadSource, COUNT(Id) FROM Lead GROUP BY LeadSource`
25. Case + Account + Contact: `SELECT CaseNumber, Account.Name, Contact.Name FROM Case`
26. Closed Won + $100,000 초과: `SELECT Name, Amount FROM Opportunity WHERE StageName = 'Closed Won' AND Amount > 100000`
27. "Manager" 직함: `SELECT Name, Job_Title__c FROM Employee__c WHERE Job_Title__c LIKE '%Manager%'`
29. Escalated Case + Contact + Account: `SELECT CaseNumber, Contact.Name, Account.Name FROM Case WHERE Status = 'Escalated'`
32. 이번 달 마감 Opportunity 있는 Account: `SELECT Name, (SELECT Name, CloseDate FROM Opportunities WHERE CloseDate = THIS_MONTH) FROM Account`
33. Open + High/Critical Case: `SELECT CaseNumber, Subject, Priority FROM Case WHERE Status = 'Open' AND Priority IN ('High', 'Critical')`
34. Closed Won Opportunity 있는 Account: `SELECT Name, Phone, (SELECT Name, StageName FROM Opportunities WHERE StageName = 'Closed Won') FROM Account`
36. Technology 산업 Contact: `SELECT Name, Email FROM Contact WHERE Account.Industry = 'Technology'`
42. Open + Email/Phone Origin Case: `SELECT CaseNumber, Status, Origin FROM Case WHERE Status = 'Open' AND (Origin = 'Email' OR Origin = 'Phone')`
44. Technology + San Francisco Contact: `SELECT Name, Email FROM Contact WHERE Account.Industry = 'Technology' AND MailingCity = 'San Francisco'`
45. 최근 Case 3개: `SELECT Subject, CreatedDate FROM Case ORDER BY CreatedDate DESC LIMIT 3`
46. Stage별 합계: `SELECT StageName, SUM(Amount) FROM Opportunity GROUP BY StageName`
