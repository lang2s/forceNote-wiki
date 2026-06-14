# SOQL와 SOSL 소개

커스텀 UI를 만들면 SOQL·SOSL API로 조직 데이터를 검색할 수 있다.

## 사용 시점
SOQL 쿼리는 SELECT SQL 문과 같아 org DB를 검색. SOSL은 검색 인덱스에 대한 텍스트 기반 검색.

**SOQL 사용(데이터가 어느 오브젝트에 있는지 알 때):**
- 단일/관련 오브젝트 데이터 조회.
- 기준 충족 레코드 카운트.
- 결과 정렬.
- 숫자·날짜·체크박스 필드 조회.

**SOSL 사용(어느 오브젝트·필드인지 모를 때):**
- 필드 내 특정 용어 조회(다중 용어 토큰화·검색 인덱스로 빠르고 관련성 높은 결과).
- 관련 없을 수 있는 여러 오브젝트·필드 효율 조회.
- division 데이터 조회.

## SOQL vs SOSL
| SOQL | SOSL |
|---|---|
| SELECT 키워드 | FIND 키워드 |
| 어느 오브젝트·필드인지 앎 | 모름 |
| 단일/관련 오브젝트 | 여러 오브젝트 |
| 한 테이블 쿼리 | 여러 테이블 쿼리 |

## SOQL 문
sObject 목록·단일 sObject·Integer(count)로 평가.
```apex
List<Account> aa = [SELECT Id, Name FROM Account WHERE Name = 'Acme'];
// 기존 쿼리로 새 객체 생성
Contact c = new Contact(Account = [SELECT Name FROM Account WHERE NumberOfEmployees > 10 LIMIT 1]);
c.FirstName = 'Raj'; c.LastName = 'Sharma';
// count
Integer i = [SELECT COUNT() FROM Contact WHERE LastName = 'Sharma'];
```

## SOSL 문
sObject 목록의 목록으로 평가(각 목록은 특정 sObject 유형 결과). 쿼리 순서대로 반환.
```apex
List<List<SObject>> searchList = [FIND 'map*' IN ALL FIELDS RETURNING Account(Id, Name), Contact, Opportunity, Lead];
Account[] accounts = ((List<Account>)searchList[0]);
Contact[] contacts = ((List<Contact>)searchList[1]);
Opportunity[] opportunities = ((List<Opportunity>)searchList[2]);
Lead[] leads = ((List<Lead>)searchList[3]);
```
