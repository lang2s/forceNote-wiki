---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Top Salesforce Trigger Questions & Answers]
---

# Salesforce 트리거 Q&A Q&A 모음

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 초급

**1. Salesforce 트리거란?**

DML 이벤트(삽입·삭제 등) 전후에 실행되는 Apex 코드. 레코드 변경 전후 커스텀 액션 실행.

**2. 트리거 코드란?**

DML 이벤트 전후 실행되는 Apex 코드. 데이터 검증·자동화·수정 등 커스텀 로직 구현.

**3. 트리거 유형?**

Before(DML 완료 전, 검증·변경), After(DML 후 임시 저장, 시스템 설정 필드 접근·다른 레코드 수정).

**4. 실행 순서?**

before 트리거 → 검증 규칙 → after 트리거 → 할당·자동 응답·워크플로우 규칙 → 에스컬레이션·엔타이틀먼트 규칙.

**5. Trigger.new와 Trigger.old?**

new는 삽입·업데이트할 새 레코드 목록, old는 업데이트·삭제 전 이전 값.

**6. 벌크화 가능?**

네, 항상 대량 처리를 염두에 두고 작성. 루프 안 SOQL은 거버너 한도 문제.

**7. 재귀 트리거와 방지?**

트리거가 자신을 호출해 무한 루프. static boolean 변수로 실행 추적해 방지.

**8. Trigger.isExecuting?**

현재 컨텍스트가 트리거이면 true 반환하는 boolean.

**9. Trigger.new vs Trigger.newMap?**

new는 새 값 레코드 목록, newMap은 ID→레코드 맵(ID로 접근 시 유용).

**10. 트리거에서 DML?**

가능하나 거버너 한도 회피 위해 제한 권장. 컬렉션으로 벌크 처리.

## 중급

**11. 트리거 다중 실행 방지?**

static 변수를 플래그로 사용해 한 트랜잭션 내 반복 실행 방지.

**12. 트리거 프레임워크와 이유?**

모듈식·조직화된 트리거 로직 관리 디자인 패턴. handler 클래스가 로직 포함, 트리거가 호출. 코드 중복 감소·재사용·유지보수.

**13. 벌크 안전 보장?**

루프 안 DML·SOQL 회피. 레코드를 컬렉션에 모아 루프 밖에서 DML·쿼리.

**14. 컨텍스트 변수?**

Trigger.new, old, isInsert/isUpdate/isDelete, isBefore/isAfter 등.

**15. 같은 오브젝트에 여러 트리거 제어?**

가능하나 순서 보장 안 됨. 오브젝트당 트리거 하나 권장, Trigger Handler 클래스로 순서·실행 제어.

## 시나리오

**16.**

Contact 업데이트 시 부모 Account 필드 업데이트 → after-update 트리거.
**17.**

"Active" 상태 Account 삭제 방지 → before-delete 트리거 + addError.
**18.**

Opportunity "Closed Won" 시 후속 Task 자동 생성 → after-update 트리거.
**19.**

같은 레코드에 트리거 다중 실행 방지 → static boolean 변수.
**20.**

Contact의 이메일 형식 검증 → before insert·update 트리거 + 정규식, 잘못되면 addError.
