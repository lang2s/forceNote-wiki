# Salesforce SOQL 쿼리

## 단순 쿼리
```sql
SELECT Contact.FirstName, Contact.Account.Name FROM Contact  -- read 권한 필요
SELECT Account.Name, (SELECT Contact.LastName FROM Account.Contacts) FROM Account
```

## WHERE 절
```sql
SELECT Id FROM Contact WHERE Name LIKE 'A%' AND MailingState = 'California'
SELECT Name FROM Account WHERE CreatedDate > 2011-04-26T10:00:00-08:00
SELECT Amount FROM Opportunity WHERE CALENDAR_YEAR(CreatedDate) = 2011
```

## Null
```sql
SELECT AccountId FROM Event WHERE ActivityDate != null
```

## 다중 선택 목록
```sql
SELECT Id, MSP1__c FROM CustObj__c WHERE MSP1__c INCLUDES ('AAA;BBB','CCC')
```

## Semi-Join (IN) / Anti-Join (NOT IN)
같은 오브젝트 다른 필드가 특정 값일 때 쿼리.
```sql
SELECT Name FROM Account WHERE BillingState IN ('California', 'New York')
```
**ID 필드 Semi-Join (부모→자식):**
```sql
SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Opportunity WHERE StageName = 'Closed Lost')
```
**참조 필드 Semi-Join (자식→부모):**
```sql
SELECT Id FROM Task WHERE WhoId IN (SELECT Id FROM Contact WHERE MailingCity = 'Twin Falls')
```
**ID 필드 Anti-Join (부모→자식):**
```sql
SELECT Id FROM Account WHERE Id NOT IN (SELECT AccountId FROM Opportunity WHERE IsClosed = false)
```
**참조 필드 Anti-Join (자식→자식):**
```sql
SELECT Id FROM Opportunity WHERE AccountId NOT IN (SELECT AccountId FROM Contact WHERE LeadSource = 'Web')
```
**다중 Semi/Anti-Join:**
```sql
SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Contact WHERE LastName LIKE 'apple%')
AND Id IN (SELECT AccountId FROM Opportunity WHERE IsClosed = false)
```
> OR는 허용 안 됨.

## ORDER BY
```sql
SELECT Name FROM Account ORDER BY Name DESC NULLS LAST
```

## LIMIT / OFFSET
```sql
SELECT AccountNumber FROM Account ORDER BY Name LIMIT 10 OFFSET 4
```

## GROUP BY / ROLLUP
```sql
SELECT LeadSource, COUNT(Name) FROM Lead GROUP BY LeadSource
SELECT LeadSource, COUNT(Name) cnt FROM Lead GROUP BY ROLLUP(LeadSource)
```

## HAVING
```sql
SELECT Name, Count(Id) FROM Account GROUP BY Name HAVING Count(Id) > 1
```

## Aggregate 함수
COUNT(), COUNT(fieldName). GROUP BY 시 COUNT(fieldName) 사용. COUNT는 LIMIT 가능하나 ORDER BY·GROUP BY와는 불가(대신 COUNT(fieldName)).
