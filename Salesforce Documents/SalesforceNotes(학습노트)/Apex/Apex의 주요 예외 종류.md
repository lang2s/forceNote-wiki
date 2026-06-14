---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Some Exception in Apex]
---

# Apex의 주요 예외 종류

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## DmlException

insert, update, delete 같은 DML을 수행할 때 필수 필드를 채우지 않으면 발생합니다.
```apex
Contact cont = new Contact();
cont.FirstName = 'Test';
insert cont; // LastName(필수) 누락 → DmlException
```
회피: DML 작업 시 필수 필드를 지정합니다.

## ListException

리스트에 문제가 있거나 존재하지 않는 인덱스의 요소에 접근할 때 발생합니다.
```apex
List<Contact> contactList = [SELECT Id, Name FROM Contact WHERE Name ='SFDC Einstein'];
system.debug(contactList[0].Name); // 빈 리스트면 ListException
```
회피: 리스트 크기를 확인합니다.

## QueryException

SOQL에 문제가 있을 때 발생합니다. SOQL 쿼리가 레코드를 반환하지 않는데 그 결과를 sObject에 할당하면 발생합니다.
```apex
Teacher__c teacherList = [SELECT Id, Name FROM Teacher__c WHERE Name ='Marc'];
```
회피: List를 사용합니다. `List<Teacher__c> teacherList = [SELECT Id, Name FROM Teacher__c WHERE Name ='Marc'];`

## SObjectException

쿼리된 SObject 레코드에서 SELECT 절에 포함되지 않은 필드에 접근할 때 발생합니다.
```apex
List<Teacher__c> teacherList = [SELECT Id FROM Teacher__c];
for(Teacher__c tch: teacherList){ system.debug(tch.Name); } // Name 미선택 → SObjectException
```
회피: 접근할 필드를 SOQL에 명시합니다. `[SELECT Id, Name FROM Teacher__c]`

## LimitException (거버너 한도 초과)

**Too many DML statements: 151:** 단일 트랜잭션에서 최대 DML 문(150개)을 초과할 때. 회피: 루프 밖에서 삽입(벌크화).
```apex
List<Contact> contactList = new List<Contact>();
for(integer i= 0; i<151; i++){
    Contact con = new Contact(); con.LastName = 'SFDC'+ i;
    contactList.add(con);
}
if(!contactList.isEmpty()){ insert contactList; }
```

**Too many SOQL queries: 101:** 단일 트랜잭션에서 최대 SOQL 쿼리(100개)를 초과할 때. 회피: 루프 밖으로 SOQL 이동.
```apex
List<Contact> con = [SELECT Id, Name FROM Contact WHERE Name Like '%contact%'];
for (integer i = 0; i < 101; i++){ system.debug(con[0].Name); }
```

## NullPointerException

null 오브젝트 참조에 접근할 때 발생합니다. 인스턴스화되지 않은 오브젝트에 작업을 수행하려 할 때.
```apex
Account acc;
System.debug(acc.Name); // NullPointerException
```
회피: 접근 전에 값을 할당합니다.
