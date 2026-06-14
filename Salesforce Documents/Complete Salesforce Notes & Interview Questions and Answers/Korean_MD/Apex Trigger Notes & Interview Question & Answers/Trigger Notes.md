# Apex 트리거 노트

## 트리거란?

DML 작업이 발생할 때 자동으로 실행되는 함수/코드 블록입니다.

## 트리거와 Flow의 차이 — 언제 트리거를 사용하나?

복잡한 로직, DML 작업 관여, 비관련 오브젝트 업데이트, 외부 시스템 호출, 벌크화가 필요할 때.

## 이벤트 vs 컨텍스트 변수

| 이벤트 | Before | After |
|---|---|---|
| Insert | trigger.new | trigger.new, trigger.newMap |
| Update | trigger.new, trigger.old (+oldMap) | trigger.new, trigger.newMap, trigger.old, trigger.oldMap |
| Delete | trigger.old, trigger.oldMap | trigger.old, trigger.oldMap |
| Undelete | - | trigger.new, trigger.newMap |

## Before Trigger

DML 사용: before 트리거에서 DML 작업 회피. 이유: trigger.new의 레코드는 before 실행 후 자동으로 DB에 저장되므로 명시적 DML이 불필요(중복).

## After Trigger

관련 레코드 업데이트, 관련 오브젝트로 새 레코드 생성 시 사용. 예: 롤업 요약처럼 before에서 허용되지 않는 필드 업데이트.
1. 관련 레코드 생성
2. 자식 레코드 생성(자식이 부모 ID 참조 필요 시 after 사용)
3. 연쇄 업데이트(관련 레코드 변경 기반)

이점: 관련 레코드 간 데이터 일관성 유지, 자식 업데이트 자동화, 동기화된 정보로 더 나은 UX.

## 트리거에서 DML 사용 시점

| 트리거 이벤트 | 현재 오브젝트 DML | 관련 오브젝트 DML | 비고 |
|---|---|---|---|
| Before Insert | NO | 드물게 | trigger.new 직접 수정 |
| Before Update | NO | 드물게 | trigger.new 직접 수정 |
| After Insert | YES | YES | 연쇄 로직에 DML |
| After Update | YES | YES | 종속 업데이트 |
| After Delete | YES | YES | 관련 레코드 수정 |
| After Undelete | YES | YES | 필요 시 관련 레코드 복원 |

## DML을 피해야 할 때

- **Before 트리거:** 같은 레코드를 DML로 업데이트하지 말고 trigger.new를 수정.
- **재귀 트리거:** 재귀를 유발할 수 있는 트리거 내 DML 회피. static 변수로 무한 루프 방지.

## 실행 한도

각 트리거 실행은 트랜잭션당 150 DML 문 한도. 대량 레코드를 효율적으로 처리하도록.

## 모범 사례

오브젝트당 트리거 하나, 코드 벌크화, for 루프 안 DML·SOQL 회피, 컬렉션·효율적 for 루프 사용, 대용량 쿼리, 명명 규칙.
