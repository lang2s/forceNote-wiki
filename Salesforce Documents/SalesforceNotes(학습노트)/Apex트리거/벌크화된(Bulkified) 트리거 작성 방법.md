---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [How do you write a bulkified trigger]
---

# 벌크화된(Bulkified) 트리거 작성 방법

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

- DML로 루프를 도는 대신 컬렉션(List, Map, Set) 사용.
- SOQL 쿼리는 루프 밖에서 사용.
- 유지보수성을 위해 Trigger Handler Framework 사용.
