---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Best Practices]
---

# Apex 모범 사례

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Apex 모범 사례

- 명명 규칙은 로직에 기반.
- 값을 하드코딩하지 말고 메서드에 매개변수·값 전달.
- 예외 처리(try-catch)로 코드 중단 방지.
- FOR 루프 안 SOQL 회피(거버너 한도 100개, 초과 시 101 오류).
- system.debug() 남용 회피(출력 확인용).
- FOR 루프 안 DML 작업 회피.
- 중첩 FOR 루프 사용 금지(런타임 초과 오류) — 대신 Map/List 사용.
- 동적 SOQL은 바인딩 메서드로 데이터 인젝션 방지.

## 트리거 모범 사례

- 오브젝트당 트리거 하나, 핸들러 하나.
- 로직 없는 트리거(모든 로직은 핸들러에).
- 명명 규칙은 로직에 기반.
- 트리거 벌크화 — 한 번에 수백만 레코드를 for 루프로 처리.
