---
tags: [soql, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SOQL and SOSL]
---

# SOQL과 SOSL

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Salesforce에서 데이터 조회에 쓰는 쿼리 언어.

## SOQL (Salesforce Object Query Language)
- **목적:** Salesforce DB 데이터 쿼리.
- **용도:** 단일/관련 오브젝트 레코드 조회.
- **기능:** 구조화 쿼리(타깃 필드), 조건 필터, 관계 탐색, 보안 모델 준수.
- **구문:** SQL 유사, SELECT 문.
```sql
SELECT Name, AccountNumber FROM Account WHERE Industry = 'Technology'
```
> 어느 오브젝트·필드를 쿼리할지 알 때 사용.

## SOSL (Salesforce Object Search Language)
- **목적:** 여러 오브젝트 검색.
- **용도:** 비구조화 데이터 검색(어느 오브젝트에 있는지 모를 때).
- **기능:** 글로벌 검색, 전체 텍스트 검색, 동적 검색, 여러 오브젝트 동시 효율 검색.
- **구문:** FIND 절.
```sql
FIND {SearchTerm} IN ALL FIELDS RETURNING Account(Id, Name), Contact, Opportunity
```
> 특정 용어를 동적으로 여러 오브젝트에서 검색할 때 사용.
