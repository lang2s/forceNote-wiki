# SOQL 쿼리 시나리오 — 언제 무엇을

## 연산자

**LIKE:** 지정 필드 값이 텍스트 패턴과 일치하면 true. 부분 문자열·와일드카드(% 0개 이상, _ 정확히 1개). 작은따옴표 필수, 문자열 필드만, 대소문자 무시.
```sql
SELECT AccountId, FirstName, LastName FROM Contact WHERE LastName LIKE 'test_%'
```
**IN:** WHERE에서 지정 값 중 하나와 같으면.
```sql
SELECT Name FROM Account WHERE BillingState IN ('California', 'New York')
```
**NOT IN:** 지정 값 중 어느 것과도 같지 않으면.
```sql
SELECT Name FROM Account WHERE BillingState NOT IN ('California', 'New York')
```
**INCLUDES:** (다중 선택 목록)
```sql
SELECT Customer_Name__c, Balance__c FROM Customer__c WHERE Proof__c INCLUDES ('Aadhar Card'), ('PAN Card')
```

## Subquery
오브젝트 간 관계에 주로 사용.
```sql
SELECT Id FROM Account WHERE Id NOT IN (SELECT AccountId FROM Opportunity WHERE IsClosed = false)
SELECT Id FROM Opportunity WHERE AccountId NOT IN (SELECT AccountId FROM Contact WHERE LeadSource = 'web')
```

## LIMIT / OFFSET
```sql
SELECT Name FROM Account WHERE Industry = 'Media' LIMIT 125
SELECT Name FROM Merchandise__c WHERE Price__c > 5.0 ORDER BY Name LIMIT 100 OFFSET 10
```
OFFSET은 대량 결과 페이징에 유용.

## GROUP BY
aggregate 함수(SUM·MAX 등)와 함께 데이터 요약·롤업.
```sql
SELECT LeadSource, Count(Name) FROM Lead GROUP BY LeadSource
SELECT Name, Max(CreatedDate) FROM Account GROUP BY Name LIMIT 5
```

## GROUP BY ROLLUP
서브토탈 계산.
```sql
SELECT LeadSource, COUNT(Name) cnt FROM Lead GROUP BY ROLLUP(LeadSource)
SELECT Status, LeadSource, COUNT(Name) cnt FROM Lead GROUP BY ROLLUP(Status, LeadSource)
```

## HAVING
GROUP BY 결과를 aggregate 함수로 필터.
```sql
SELECT LeadSource, COUNT(Name) FROM Lead GROUP BY LeadSource HAVING COUNT(Name) > 100
SELECT Name, COUNT(Id) FROM Account GROUP BY Name HAVING COUNT(Id) > 1
```

## 관계 쿼리

### Child → Parent
```sql
SELECT Contact.FirstName, Contact.Account.Name FROM Contact
SELECT Id, Name, Account.Name FROM Contact WHERE Account.Industry = 'Media'
-- 커스텀 (__r 추가)
SELECT Id, Name, parent__r.FirstName, parent__r.LastName__c FROM child__c WHERE age__c < 25
```

### Parent → Child
자식 오브젝트는 복수형으로 참조.
```sql
SELECT Name, (SELECT LastName FROM Contacts) FROM Account
SELECT Account, Id, Name, (SELECT Quantity, ListPrice, PricebookEntry.UnitPrice, PricebookEntry.Name FROM OpportunityLineItems) FROM Opportunity
```
