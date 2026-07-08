---
tags: [soql, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SOQL (Salesforce Object Query Language)]
---

# SOQL (Salesforce Object Query Language)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

SOQL은 Salesforce DB에서 기존 데이터를 조회하는 언어. 표준·커스텀 오브젝트(Account·Contact·Opportunity 등)에서 특정 데이터 조회.

```sql
SELECT Name, Email, Phone FROM Contact WHERE AccountId = '0012w00001hbgs2AAA'
```
- **키워드:** SELECT, FROM, WHERE
- **3절:** SELECT 절, FROM 절, WHERE 절

## 실습 (Developer Console)
Setup → Developer Console → File | Open | Objects | Contact → Query Editor 탭. (1: 쿼리 작성, 2: 오류, 3: 실행 히스토리)

```sql
SELECT FirstName, LastName, Email, Phone FROM Contact
SELECT Name, Email FROM Contact WHERE FirstName = 'Sanjeev'
SELECT Name, Email FROM Contact WHERE FirstName = 'Sanjeev' AND LastName = 'Jha'
SELECT Name, Email FROM Contact WHERE LastName = 'Jha' OR LastName = 'Mishra'
SELECT Name, Email FROM Contact WHERE LastName IN ('Jha', 'Mishra', 'Pandey', 'James')
SELECT Name, Email, Phone FROM Contact LIMIT 20
SELECT Name, Email FROM Contact ORDER BY Name ASC LIMIT 5
SELECT Name, Email FROM Contact ORDER BY Email DESC LIMIT 5
SELECT Name, Email FROM Contact ORDER BY Email NULLS FIRST
```

## Apex에서 SOQL 실행
SOQL은 항상 List 반환.
```apex
List<Contact> listOfContacts = [SELECT FirstName, LastName FROM Contact];
System.debug(listOfContacts);
```

**시나리오 1: Contact 이름 출력**
```apex
public class ContactUtility {
    public static void viewContacts(){
        List<Contact> listofContacts = [SELECT FirstName, LastName FROM Contact];
        for(Contact con : listofContacts){
            System.debug('First Name: ' + con.FirstName + ', Last Name: ' + con.LastName);
        }
    }
}
```
> 연결 시 필드는 object.field, 리터럴은 작은따옴표, + 로 결합.

**시나리오 2: Account 이름·연매출**
```apex
List<Account> accountsList = [SELECT Name, AnnualRevenue FROM Account];
for(Account acct : accountsList){
    System.debug('Account Name:' + acct.Name + ', Annual Revenue: ' + acct.AnnualRevenue);
}
```

## 관계 쿼리 (Cross-Object)
관계로 두 오브젝트 필드 반환. 자식→부모(child-to-parent), 부모→자식(parent-to-child).
**Master-Detail:**

마스터(부모)는 다수 디테일(자식), 디테일은 마스터 하나. 예: Contact의 AccountId(Lookup(Account)).

**Child→Parent:**
```sql
SELECT Name, Account.Name FROM Contact
```
**Parent→Child(서브쿼리):**
```sql
SELECT Name, (SELECT Name FROM Contacts) FROM Account
SELECT Name, (SELECT Name FROM Contacts) FROM Account WHERE Id IN (SELECT AccountId FROM Contact WHERE LastName = 'Forbes')
```

**시나리오 3: DreamHouse 최근 30일 매물**
```apex
List<Property__c> newPropList = [SELECT Name, Broker__r.Email__c, Days_On_Market__c FROM Property__c WHERE Days_On_Market__c < 31];
for(Property__c pe : newPropList){
    System.debug('Property Name:' + pe.Name + ', Broker Email:' + pe.Broker__r.Email__c);
}
```

## Bind 변수와 Aggregate
**Bind 변수:**
```apex
Integer maxHomeValue = 200000;
List<Property__c> property = [SELECT Name, Price__c FROM Property__c WHERE Price__c < :maxHomeValue];
```
**Aggregate:**
```sql
SELECT COUNT(City__c) FROM Property__c
SELECT COUNT_DISTINCT(City__c) FROM Property__c
SELECT MIN(Date_Listed__c) FROM Property__c
SELECT MAX(Status__c), Broker__r.Name FROM Property__c GROUP BY Broker__r.Name HAVING MAX(Status__c) = 'Closed'
```
