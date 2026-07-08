---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [How to Avoid Rescursion In Triggers]
---

# 트리거에서 재귀(Recursion) 방지 방법

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

재귀는 트리거 내 DML 작업으로 트리거가 자신을 반복 호출해 무한 루프나 거버너 한도 도달을 일으킬 때 발생합니다.

**방지 방법:**

1. **헬퍼 클래스의 Static Boolean 플래그:** static Boolean 변수로 트리거가 이미 실행되었는지 추적.

2. **Trigger Framework:** Trigger Handler 패턴으로 트랜잭션당 한 번만 실행되도록 보장.
