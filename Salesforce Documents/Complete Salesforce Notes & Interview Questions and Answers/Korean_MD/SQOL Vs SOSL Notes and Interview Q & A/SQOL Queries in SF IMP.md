---
tags: [soql, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SQOL Queries in SF IMP]
---

# Salesforce 중요 SOQL 쿼리 (150+)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

> 원본은 이미지 PDF로 OCR 추출했습니다. 질문 설명을 번역하고 깔끔한 대표 쿼리를 함께 정리합니다.

## 기본 쿼리
1. 모든 Account: `SELECT Id, Name FROM Account`
2. LastName='Smith' Contact: `SELECT Id, FirstName, LastName FROM Contact WHERE LastName = 'Smith'`
3. Amount > 1,000,000 Opportunity: `SELECT Id, Name, Amount FROM Opportunity WHERE Amount > 1000000`
4. Closed Case: `SELECT Id, CaseNumber, Status FROM Case WHERE Status = 'Closed'`
5. 전환된 Lead: `SELECT Id, FirstName, LastName FROM Lead WHERE IsConverted = TRUE`
6. 이름순 상위 10 Account: `SELECT Id, Name FROM Account ORDER BY Name LIMIT 10`
7. 최근 30일 마감 Opportunity: `SELECT Id, Name, CloseDate FROM Opportunity WHERE CloseDate = LAST_N_DAYS:30`
8. 'Acme Inc.' Contact: `SELECT Id, FirstName, LastName FROM Contact WHERE Account.Name = 'Acme Inc.'`
9. 연체 Task: `SELECT Id, Subject, ActivityDate FROM Task WHERE ActivityDate < TODAY`
10. Stage별 Opportunity: `SELECT StageName, COUNT(Id) FROM Opportunity GROUP BY StageName`
11. Opportunity 없는 Account: `SELECT Id, Name FROM Account WHERE Id NOT IN (SELECT AccountId FROM Opportunity)`
12. 확률 ≥ 80%: `SELECT Id, Name, Probability FROM Opportunity WHERE Probability >= 80`
13. BillingState='California': `SELECT Id, Name FROM Account WHERE BillingState = 'California'`
14. 특정 Contact 관련 Task: `SELECT Id, Subject FROM Task WHERE WhoId = '003...'`
15. 지난주 생성 Contact: `SELECT Id, FirstName, LastName FROM Contact WHERE CreatedDate = LAST_WEEK`
16. LeadSource='Web': `SELECT Id, FirstName, LastName FROM Lead WHERE LeadSource = 'Web'`
17. 'Global Media' Opportunity: `SELECT Id, Name FROM Opportunity WHERE Account.Name = 'Global Media'`
18. 최근 24시간 Case: `SELECT Id, CaseNumber, CreatedDate FROM Case WHERE CreatedDate = LAST_N_DAYS:1`
19. 7일 내 마감: `SELECT Id, Name, CloseDate FROM Opportunity WHERE CloseDate = NEXT_N_DAYS:7`
20. Type='Customer' Account: `SELECT Id, Name, Type FROM Account WHERE Type = 'Customer'`
21. Open + High Case: `SELECT Id FROM Case WHERE Status != 'Closed' AND Priority = 'High'`
22. Closed Won: `SELECT Id, Name FROM Opportunity WHERE StageName = 'Closed Won'`
23. 1년간 미수정 Account: `SELECT Id, Name FROM Account WHERE LastModifiedDate < LAST_N_DAYS:365`
24. Title='CEO': `SELECT Id, Name FROM Contact WHERE Title = 'CEO'`
25. Origin='Phone' Case: `SELECT Id FROM Case WHERE Origin = 'Phone'`
26. 특정 User 생성 Opportunity: `SELECT Id, Name FROM Opportunity WHERE CreatedById = '005...'`
27. example.com 이메일 Contact: `SELECT Id FROM Contact WHERE Email LIKE '%example.com'`
28. Rating='Hot' Lead: `SELECT Id FROM Lead WHERE Rating = 'Hot'`
29. 확률 < 20%: `SELECT Id, Name FROM Opportunity WHERE Probability < 20`
30. ShippingCountry='USA': `SELECT Id, Name FROM Account WHERE ShippingCountry = 'USA'`
31. 미완료 Task: `SELECT Id FROM Task WHERE IsClosed = FALSE`
32. 과거 CloseDate: `SELECT Id, Name FROM Opportunity WHERE CloseDate < TODAY`
33. Status='New' Case: `SELECT Id FROM Case WHERE Status = 'New'`
34. MailingState='New York': `SELECT Id FROM Contact WHERE MailingState = 'New York'`
35. Proposal/Price Quote 단계: `SELECT Id FROM Opportunity WHERE StageName = 'Proposal/Price Quote'`
36. Industry='Technology': `SELECT Id, Name FROM Account WHERE Industry = 'Technology'`
37. 30일 내 마감: `SELECT Id FROM Opportunity WHERE CloseDate = NEXT_N_DAYS:30`
38. LeadSource='Referral': `SELECT Id FROM Lead WHERE LeadSource = 'Referral'`
39. 오늘 생성 Case: `SELECT Id FROM Case WHERE CreatedDate = TODAY`
40. MailingCountry='Canada': `SELECT Id FROM Contact WHERE MailingCountry = 'Canada'`
41. Prospecting 단계: `SELECT Id FROM Opportunity WHERE StageName = 'Prospecting'`
42. Type='Prospect': `SELECT Id FROM Account WHERE Type = 'Prospect'`
43. 'Open - Not Contacted' Lead: `SELECT Id FROM Lead WHERE Status = 'Open - Not Contacted'`
44. California Account의 Opportunity: `SELECT Id FROM Opportunity WHERE Account.BillingState = 'California'`
45. Escalated Case: `SELECT Id FROM Case WHERE Status = 'Escalated'`
46. 확률 ≥ 50%: `SELECT Id FROM Opportunity WHERE Probability >= 50`
47. BillingCity='New York': `SELECT Id FROM Account WHERE BillingCity = 'New York'`
48. MailingPostalCode='10001': `SELECT Id FROM Contact WHERE MailingPostalCode = '10001'`
49. 최근 7일 Lead: `SELECT Id FROM Lead WHERE CreatedDate = LAST_N_DAYS:7`
50. Amount < 5,000: `SELECT Id FROM Opportunity WHERE Amount < 5000`

## 관계 쿼리 (51~100)
- Account 관련 Contact: `SELECT Name, (SELECT Name FROM Contacts) FROM Account WHERE Name = 'Acme Inc.'`
- Account 관련 Opportunity: `SELECT Name, (SELECT Name FROM Opportunities) FROM Account WHERE Name = 'Global Media'`
- Contact 관련 Case: `SELECT CaseNumber FROM Case WHERE Contact.Name = 'John Doe'`
- Opportunity 관련 OpportunityLineItem: `SELECT Id, (SELECT Quantity, ListPrice FROM OpportunityLineItems) FROM Opportunity WHERE Name = 'Opportunity1'`
- Contact + Account 정보: `SELECT Name, Account.Name FROM Contact`
- Account + Contact + Opportunity: `SELECT Name, (SELECT Name FROM Contacts), (SELECT Name FROM Opportunities) FROM Account`
- Technology Account의 Contact: `SELECT Name, (SELECT Name FROM Contacts) FROM Account WHERE Industry = 'Technology'`
- Open Case 있는 Contact: `SELECT Name, (SELECT CaseNumber FROM Cases WHERE Status = 'Open') FROM Contact`
- Product='Laptop' OpportunityLineItem: `SELECT Id, (SELECT Quantity FROM OpportunityLineItems WHERE PricebookEntry.Product2.Name = 'Laptop') FROM Opportunity`
- High Priority Case 있는 Contact: `SELECT Name, (SELECT CaseNumber FROM Cases WHERE Priority = 'High') FROM Contact`
> (51~100은 부모-자식 서브쿼리·자식-부모 점 표기 조합으로 다양한 조건 필터를 적용하는 패턴입니다.)

## Semi-Join / Anti-Join (101~160)
- Opportunity 있는 Account: `SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity)`
- Opportunity 없는 Account: `SELECT Id, Name FROM Account WHERE Id NOT IN (SELECT AccountId FROM Opportunity)`
- Case 없는 Contact: `SELECT Id FROM Contact WHERE Id NOT IN (SELECT ContactId FROM Case)`
- Contact 없는 Account: `SELECT Id FROM Account WHERE Id NOT IN (SELECT AccountId FROM Contact)`
- 특정 산업 Account의 Opportunity: `SELECT Id FROM Opportunity WHERE AccountId IN (SELECT Id FROM Account WHERE Industry = 'Technology')`
- Task 없는 Case: `SELECT Id FROM Case WHERE Id NOT IN (SELECT WhatId FROM Task)`
- Contact 있으나 Opportunity 없는 Account: `SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Contact) AND Id NOT IN (SELECT AccountId FROM Opportunity)`
> (101~160은 IN(Semi-Join)·NOT IN(Anti-Join)을 부모-자식·자식-부모·자식-자식 관계에 적용해 "관련 레코드가 있는/없는" 레코드를 조회하는 패턴입니다.)
