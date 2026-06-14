---
tags: [apex, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Exceptions in Apex]
---

# Apex의 예외(Exceptions)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

예외(Exception) = Apex가 코드를 실행하지 못했다는 신호입니다.

예외는 코드의 어느 단계에서나 발생할 수 있습니다:
1. null 변수에서 메서드 호출
2. 존재하지 않는 리스트 인덱스 접근
3. 삽입 시 필수 필드 누락
4. 그 외 다수

무엇이든, 어느 단계에서든 잘못되면 전체 프로세스가 실패합니다. 예를 들어, 필수 필드 없이 레코드가 삽입된 경우.

**중요:** 예외는 좋은 것입니다. 코드가 무언가 잘못하고 있다는 신호이며, 언제든지 잡을(catch) 수 있습니다.
