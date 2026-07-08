---
tags: [soql, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SOQL PRACTICE]
---

# SOQL 연습

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 키워드 순서
SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT

| # | 키워드 | 예 |
|---|---|---|
| 1 | 단순 쿼리 | `SELECT Id, Name, BillingCity FROM Account` |
| 2 | WHERE | `SELECT Id FROM Contact WHERE MailingCity = 'California'` |
| 3 | AND | `SELECT Name, Phone FROM Account WHERE Industry = 'Technology' AND BillingState = 'California'` |
| 4 | OR | `SELECT Name, Phone FROM Account WHERE Industry = 'Technology' OR BillingState = 'California'` |
| 5 | IN | `SELECT Name, Phone FROM Account WHERE BillingState IN ('California', 'Texas', 'New York')` |
| 6 | NOT | `SELECT Name, Phone FROM Account WHERE NOT Industry = 'Technology'` |
| 7 | LIKE | `SELECT Id FROM Contact WHERE Name LIKE 'A%'` |
| 8 | COUNT() | `SELECT COUNT() FROM Account WHERE Name LIKE 'b%'` |
| 9 | COUNT_DISTINCT() | `SELECT COUNT_DISTINCT(Company) FROM Lead` |
| 10 | AVG() | `SELECT CampaignId, AVG(Amount) FROM Opportunity GROUP BY CampaignId` |
| 11 | MIN() | `SELECT MIN(CreatedDate), FirstName, LastName FROM Contact GROUP BY FirstName, LastName` |
| 12 | MAX() | `SELECT Name, MAX(BudgetedCost) FROM Campaign GROUP BY Name` |
| 13 | SUM() | `SELECT SUM(Amount) FROM Opportunity WHERE IsClosed = false AND Probability > 60` |
| 14 | GROUP BY | `SELECT LeadSource, COUNT(Name) FROM Lead GROUP BY LeadSource` |
| 15 | HAVING | `SELECT Name, COUNT(Id) FROM Account GROUP BY Name HAVING COUNT(Id) > 1` |
| 16 | ORDER BY | `SELECT Name FROM Account ORDER BY Name DESC` |
| 17 | LIMIT | `SELECT Name FROM Account WHERE Industry = 'media' LIMIT 125` |
| 18 | OFFSET | `SELECT Name, Salary__c FROM Employee__c ORDER BY Salary__c DESC LIMIT 1 OFFSET 1` |
| 19 | 부모→자식 | `SELECT Name, (SELECT LastName FROM Contacts) FROM Account` |
| 20 | 자식→부모 | `SELECT Contact.FirstName, Contact.Account.Name FROM Contact` |

> 모든 aggregate 함수는 null을 무시(COUNT()·COUNT(Id) 제외). COUNT(fieldname)은 null을 무시(COUNT()와 다름).
