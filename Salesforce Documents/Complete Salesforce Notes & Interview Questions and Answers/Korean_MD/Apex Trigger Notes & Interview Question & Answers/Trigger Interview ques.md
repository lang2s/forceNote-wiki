# Salesforce 트리거 면접 질문

**트리거란?** insert·update·delete·undelete 같은 이벤트 전후에 자동 실행되는 코드 블록.

구문: `trigger trigger_name on SObjectName (event_operation1, event_operation2) { }`

**트리거 이벤트:** Before(저장 전), After(저장 후). 작업: Insert, Update, Delete, Undelete.

**컨텍스트 변수:** isInsert, isUpdate, isDelete, isBefore, isAfter, new(새 버전 목록), old(이전 버전, update·delete), newMap(ID→새 버전, before update·after insert), oldMap(ID→이전 버전, update·delete).

**Trigger.new vs Trigger.old:** new는 삽입·업데이트 중인 새 버전, old는 업데이트·삭제 전 이전 버전.

**Trigger.new vs Trigger.newMap:** new는 레코드 목록, newMap은 ID→레코드 맵(키-값 조회에 유용).

**Trigger Handler·Helper:** 비즈니스 로직을 트리거에서 분리해 가독성·재사용성 향상.

**모범 사례:** 오브젝트당 트리거 하나, 로직 없는 트리거, 코드 벌크화, 루프 안 SOQL/DML 회피, 효율적 쿼리.

**재귀 트리거:** 트리거가 루프에서 자신을 계속 호출. static 플래그로 방지.
```apex
public class RecursiveTriggerHandler { public static Boolean isFirstTime = true; }
trigger SampleTrigger on Contact (after update) {
    if(RecursiveTriggerHandler.isFirstTime) {
        RecursiveTriggerHandler.isFirstTime = false;
        // 트리거 로직
    }
}
```

**실행 순서:** DB 로드 → 시스템 검증 → before 트리거 → 커스텀 검증 → 저장(미커밋) → after 트리거 → 워크플로우·할당·자동 응답 규칙 → DML 커밋 → 커밋 후 로직(이메일).

**운영에서 트리거 편집 가능?** 불가. Sandbox/Developer Org에서 변경 후 배포. (Visualforce는 Apex 의존이 없으면 운영에서 직접 편집 가능.)
