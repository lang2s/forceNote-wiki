---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Triggers Interview Q & A]
---

# Apex 트리거 면접 Q&A

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 일반 개념

- **Apex 트리거란?** 특정 데이터 조작 이벤트 전후에 실행되는 Salesforce 코드.
- **목적?** 레코드 삽입·업데이트·삭제·복원 전후 커스텀 액션·로직 수행.
- **Before vs After?** Before는 DB 커밋 전, After는 커밋 후 실행.
- **한 오브젝트에 여러 트리거?** 가능하나 실행 순서를 고려해야 함.
- **Trigger Context의 의미?** 현재 컨텍스트 정보(Trigger.new 등)에 접근하는 변수 제공.

## 트리거 이벤트

- Before Insert: 새 레코드 생성 시.
- After Update: 기존 레코드 수정 시.
- Before Delete: 레코드 삭제 직전.

## 벌크화

대량 레코드를 효율적으로 처리하는 트리거 작성 관행. 성능·확장성 향상.

## 컨텍스트 변수

- **Trigger.new:** insert·update·undelete 후 새 버전 레코드.
- **Trigger.old:** update·delete 전 이전 버전 레코드.
- **Trigger.oldMap/newMap:** 특정 필드의 이전·새 값 접근.

## 재귀 방지

재귀는 트리거가 작동 중인 레코드를 업데이트해 무한 루프를 일으킬 때 발생. static 변수 등으로 트리거 실행 여부 추적하여 방지.

## 오류 처리

try-catch로 예외 처리·로깅. addError 메서드로 커스텀 오류 메시지 추가해 저장 방지.

## 실행 순서

Before 트리거 → 검증 규칙 → After 트리거 → 워크플로우·프로세스·부모 오브젝트 트리거 순.

## DML 작업

DML(insert·update·delete·undelete). 트리거에서 insert·update·delete·undelete 문으로 수행.

## 거버너 한도

플랫폼이 적용하는 런타임 리소스 한도. 효율적 코드·벌크화·예외 처리로 한도 내 유지.

## 테스트

테스트 클래스로 트리거 이벤트 시뮬레이션, 예상 동작 검증. 벌크 데이터·긍정·부정 케이스 테스트.

## SOQL과 SOSL

트리거에서 SOQL로 데이터 조회 가능. SOQL은 레코드 쿼리, SOSL은 전문 검색.

## 기타

- **모범 사례:** 코드 벌크화, 예외 처리, 선택적 쿼리, DML 최소화. → 확장성·유지보수성·성능.
- **커스텀 오브젝트 트리거:** 표준·커스텀 오브젝트 모두 가능.
- **Database 트리거 vs Apex 트리거:** Database 트리거는 DB 수준, Apex 트리거는 플랫폼 수준 실행.
- **After 트리거에서 future 메서드 호출:** 가능(비동기 작업). 실행 순서·지연 유의.
- **레코드 잠금:** 여러 사용자의 동시 업데이트 방지. 트리거가 잠금 시나리오 처리 필요.
- **배치 처리:** 컬렉션으로 여러 레코드 효율 처리.
- **트리거 디자인 패턴:** 재사용·확장 가능한 트리거 코드 조직 접근.
