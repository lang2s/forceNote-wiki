---
tags: [soql, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SOQL in Salesforce]
---

# Salesforce의 SOQL

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

SOQL은 Salesforce 관계형 DB에서 데이터를 조회하는 쿼리 언어. SQL 유사하나 Salesforce 오브젝트 전용.

## 구문
```sql
SELECT FieldList FROM ObjectName
[WHERE conditions]      -- 레코드 필터
[GROUP BY fieldname]    -- 필드 그룹화
[ORDER BY fieldname {ASC|DESC}]  -- 정렬
[LIMIT n]               -- 레코드 수 제한
[OFFSET n]              -- 건너뛸 레코드
```

## 관계 쿼리 2종
1. Parent → Child (부모-자식)
2. Child → Parent (자식-부모)

### Parent → Child
부모 레코드에 관련된 자식 레코드 조회. 서브쿼리(괄호)로.
- Child Relationship Name 사용.
```sql
-- 표준→표준
SELECT Name, (SELECT LastName, Email FROM Contacts) FROM Account
```
**1단계만 지원**

— 자식 서브쿼리 내 또 다른 서브쿼리 중첩 불가.
```sql
-- 불가
SELECT Name, (SELECT LastName, (SELECT Name FROM Tasks) FROM Contacts) FROM Account
```
```sql
-- 표준→커스텀 (__r 사용)
SELECT Id, Name, (SELECT Name FROM Department__r) FROM Account
-- 커스텀→커스텀
SELECT Name, (SELECT Name, Email__c, Position__c FROM Employees__r) FROM Department__c
```

### Child → Parent
점 표기로 부모 필드 접근. 커스텀은 `__r` 추가.
