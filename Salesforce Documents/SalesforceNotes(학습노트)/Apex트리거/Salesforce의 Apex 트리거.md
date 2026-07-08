---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Trigger in Salesforce]
---

# Salesforce의 Apex 트리거

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Apex 트리거란?

- **정의:** Salesforce에서 특정 이벤트 발생 시 실행되는 코드.
- **목적:** 레코드 삽입·업데이트·삭제·복원 같은 프로세스 자동화.

## 트리거 이벤트

Before Insert, Before Update, Before Delete, After Insert, After Update, After Delete, After Undelete.

## 언제 사용하나?

- **데이터 검증:** insert·update 전 데이터 무결성 보장.
- **복잡한 자동화:** 워크플로우·Process Builder로 불가능한 복잡한 로직.
- **DML 작업:** 이벤트 발생 시 다른 레코드에 관련 DML 수행.

## 구문

`trigger TriggerName on ObjectName (trigger_events) { }`. Trigger.new & Trigger.old는 수정·삭제 중인 레코드를 담는 컬렉션.

## Before vs After

| Before | After |
|---|---|
| 변경 전 검증 | 변경 후 후처리 |
| 레코드 저장 방지 가능 | 저장 방지 불가 |
| Trigger.new 사용 가능 | Trigger.new와 Trigger.old 사용 가능 |

## 모범 사례

오브젝트당 트리거 하나, 복잡 로직은 헬퍼 클래스로, 컬렉션 사용, 코드 벌크화, 재귀 트리거 방지.

## 일반 오류

루프 안 쿼리(거버너 한도 초과), 루프 안 DML, 트리거 로직 충돌.

## 테스트 도구

Apex 테스트 클래스, Developer Console, Salesforce Lightning Inspector.

## 실행 순서

1. Before 트리거 → 2. 검증 규칙 → 3. After 트리거 → 4. 워크플로우 규칙 → 5. 에스컬레이션 규칙 → 6. 할당 규칙.

## 결론

Apex 트리거는 Salesforce 자동화·커스터마이징의 강력한 도구입니다. 모범 사례를 따르고 효율적·벌크화·재사용 가능하게 작성하며, 적절한 테스트·디버깅이 중요합니다.
