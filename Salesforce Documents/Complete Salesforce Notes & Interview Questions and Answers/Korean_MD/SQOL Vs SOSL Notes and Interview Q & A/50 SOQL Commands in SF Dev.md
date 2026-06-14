# SOQL 명령 50선 (치트시트)

1. Account 이름: `SELECT Name FROM Account`
2. Account 이름 + Contact LastName: `SELECT Name, (SELECT LastName FROM Contacts) FROM Account`
3. Banking 산업 Account 관련 Contact: `SELECT Id, Name, Account.Name FROM Contact WHERE Account.Industry = 'Banking'`
4. California의 Media Account: `SELECT Name FROM Account WHERE BillingState = 'California' AND Industry = 'Media'`
5. 최근 Account 5개: `SELECT Name FROM Account ORDER BY CreatedDate DESC LIMIT 5`
6. Contact 수: `SELECT COUNT() FROM Contact`
7. Lead Source별 Lead 수: `SELECT LeadSource, COUNT(Name) FROM Lead GROUP BY LeadSource`
8. Product + ProductCode: `SELECT Name, (SELECT ProductCode FROM PricebookEntries) FROM Product2`
9. Open Opportunity 평균 금액: `SELECT AVG(Amount) FROM Opportunity WHERE IsClosed = false`
10. 이번 달 Closed Won 합계: `SELECT SUM(Amount) FROM Opportunity WHERE CloseDate = THIS_MONTH AND StageName = 'Closed Won'`
11. 어제 이후 수정 Account: `SELECT Name FROM Account WHERE LastModifiedDate > YESTERDAY`
12. Prospecting 단계 $50,000 초과 Opportunity: `SELECT Id, Name FROM Opportunity WHERE Amount > 50000 AND StageName = 'Prospecting'`
13. Gmail Contact: `SELECT Id FROM Contact WHERE Email LIKE '%gmail.com'`
14. 'A'로 시작 Account: `SELECT Name FROM Account WHERE Name LIKE 'A%'`
15. 최근 30일 Lead: `SELECT Id, Name FROM Lead WHERE CreatedDate > LAST_N_DAYS:30`
16. 'MyAccount'의 Opportunity: `SELECT Name, (SELECT Name FROM Opportunities) FROM Account WHERE Name = 'MyAccount'`
17. 다음 분기 마감: `SELECT Name FROM Opportunity WHERE CloseDate = NEXT_QUARTER`
18. 'Smith' Contact가 있는 Account: `SELECT Name FROM Account WHERE Id IN (SELECT AccountId FROM Contact WHERE LastName = 'Smith')`
19. 30일 내 마감: `SELECT Name FROM Opportunity WHERE CloseDate > NEXT_N_DAYS:30`
20. 지난주 Technology Account: `SELECT Name FROM Account WHERE CreatedDate > LAST_WEEK AND Industry = 'Technology'`
21. 직원 500명 초과: `SELECT Name FROM Account WHERE NumberOfEmployees > 500`
22. 확률 40% 미만: `SELECT Id, Name FROM Opportunity WHERE Probability < 40`
23. 오늘 생일 Contact: `SELECT Id FROM Contact WHERE Birthdate = TODAY`
24. 연매출 $1,000,000 초과: `SELECT Name FROM Account WHERE AnnualRevenue > 1000000`
25. 미전환 Lead: `SELECT Id, Name FROM Lead WHERE IsConverted = false`
26. 직원 100명 미만 Account+Opportunity: `SELECT Name, (SELECT StageName FROM Opportunities) FROM Account WHERE NumberOfEmployees < 100`
27. Pipeline 예측: `SELECT Name FROM Opportunity WHERE ForecastCategory = 'Pipeline'`
28. Closed Won Opportunity 있는 Account: `SELECT Name FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity WHERE IsWon = true)`
29. 지난 회계분기 마감: `SELECT Name FROM Opportunity WHERE CloseDate = LAST_FISCAL_QUARTER`
30. 마지막 활동일 없는 Account: `SELECT Name FROM Account WHERE LastActivityDate = NULL`
31. Prospect 유형: `SELECT Name FROM Account WHERE Type = 'Prospect'`
32. Negotiation/Review 단계: `SELECT Id, Name FROM Opportunity WHERE StageName = 'Negotiation/Review'`
33. San Francisco Contact: `SELECT Id FROM Contact WHERE MailingCity = 'San Francisco'`
34. 직원 100~500: `SELECT Name FROM Account WHERE NumberOfEmployees BETWEEN 100 AND 500`
35. Web Lead: `SELECT Id, Name FROM Lead WHERE LeadSource = 'Web'`
36. Customer 유형 Account+Opportunity: `SELECT Name, (SELECT StageName FROM Opportunities) FROM Account WHERE Type = 'Customer'`
37. New Business Opportunity: `SELECT Name FROM Opportunity WHERE Type = 'New Business'`
38. Existing Business Opportunity 있는 Account: `SELECT Name FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity WHERE Type = 'Existing Business')`
39. 다음 회계연도 마감: `SELECT Name FROM Opportunity WHERE CloseDate = NEXT_FISCAL_YEAR`
40. 지난달 활동 Account: `SELECT Name FROM Account WHERE LastActivityDate > LAST_MONTH`
41. USA Account: `SELECT Name FROM Account WHERE BillingCountry = 'USA'`
42. 예상 매출 $100,000 초과: `SELECT Id, Name FROM Opportunity WHERE ExpectedRevenue > 100000`
43. MobilePhone 있는 Contact: `SELECT Id FROM Contact WHERE MobilePhone != NULL`
44. California·New York 배송 Account: `SELECT Name FROM Account WHERE ShippingState IN ('California', 'New York')`
45. 'Open- Not Contacted' Lead: `SELECT Id, Name FROM Lead WHERE Status = 'Open- Not Contacted'`
46. 연매출 $500,000 미만 Account+Opportunity: `SELECT Name, (SELECT StageName FROM Opportunities) FROM Account WHERE AnnualRevenue < 500000`
47. NextStep 정의된 Opportunity: `SELECT Name FROM Opportunity WHERE NextStep != NULL`
48. Email 있는 Contact의 Account: `SELECT Name FROM Account WHERE Id IN (SELECT AccountId FROM Contact WHERE Email != NULL)`
49. 이전 회계분기보다 적은 금액: `SELECT Name FROM Opportunity WHERE Amount < PREVIOUS_FISCAL_QUARTER`
50. 최근 60일 수정: `SELECT Name FROM Account WHERE LastModifiedDate <= LAST_N_DAYS:60`
