---
tags: [soql, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SOQL]
---

# SOQL 쿼리

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

1. **최근 Account 10개:** `SELECT Id, Name FROM Account ORDER BY CreatedDate DESC LIMIT 10`
2. **Account의 Contact·Opportunity 단일 쿼리:** `SELECT Id, Name, (SELECT Id, LastName FROM Contacts), (SELECT Id, Name FROM Opportunities) FROM Account`
3. **Account에 연결된 활성 Contact만:** `SELECT Id, LastName, AccountId FROM Contact WHERE IsActive__c = 'YES' AND AccountId IN (SELECT Id FROM Account)`
4. **Contact가 3개 초과인 Account ID:** `SELECT AccountId FROM Contact GROUP BY AccountId HAVING COUNT(Id) > 3`
5. **Contact 없는 Account:** `SELECT Id FROM Account WHERE Id NOT IN (SELECT AccountId FROM Contact)`
6. **Contact가 1개 이상인 Account:** `SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId FROM Contact)`
7. **System Administrator 프로필 사용자:** `SELECT Id FROM User WHERE Profile.Name = 'System Administrator'`
8. **최근 30일 생성 Account:** `SELECT Id FROM Account WHERE CreatedDate = LAST_N_DAYS:30`
9. **Opportunity 최다 Account:** `SELECT AccountId, Count(Id) FROM Opportunity GROUP BY AccountId ORDER BY Count(Id) DESC LIMIT 1`
