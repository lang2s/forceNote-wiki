# Apex 트리거 노트 Part 3

## Apex 트리거란?

DML 작업(삽입·업데이트·삭제·복원) 시 자동 실행되는 코드 블록. Flow·검증 규칙 같은 선언적 도구로 불가능한 복잡한 비즈니스 로직 자동화.

구문: `trigger Trigger_Name on SObject (Trigger_event) { }`

## 이벤트

Before(Insert·Update·Delete), After(Insert·Update·Delete·Undelete). 레코드 생성 후 코드 실행은 After Insert 사용.

## 모범 사례

- 오브젝트당 트리거 하나(Trigger Handler 클래스로 로직 분리)
- 코드 벌크화(루프·컬렉션)
- 루프 안 SOQL/DML 회피
- 컨텍스트 변수(Trigger.oldMap, newMap) 효율적 사용
- 오류 처리(addError())
- 75% 이상 테스트 커버리지

## 컨텍스트 변수

| 변수 | 설명 |
|---|---|
| Trigger.new | 생성·업데이트되는 새 버전 레코드 |
| Trigger.old | 이전 버전(update·delete 전) |
| Trigger.isInsert/isUpdate/isDelete | 해당 이벤트면 true |
| Trigger.isBefore/isAfter | before/after면 true |
| Trigger.newMap/oldMap | ID→레코드 맵 |
| Trigger.isUndelete | undelete 이벤트면 true |
| Trigger.size | 컨텍스트의 총 레코드 수 |

## 샘플 비즈니스 시나리오

- 중복 레코드 방지(특정 필드 값 기반)
- 필드 자동 업데이트(Opportunity "Closed Won" 시 Account의 "Last Closed Date" 업데이트)
- 커스텀 검증(관련 Opportunity가 있으면 Account 삭제 방지)
- 감사 로깅(Opportunity Amount·Stage 변경을 커스텀 오브젝트에 기록)
- 연쇄 삭제(부모 Account 삭제 시 자식 Contact 삭제)

## 예제: Account 업데이트 시 관련 Opportunity를 "Negotiation/Review"로 업데이트

```apex
public class AccountTriggerHandler {
    public static Boolean recordsProcessed = false;
    public static Set<Id> processedAccountId = new Set<Id>();
    public static void afterUpdate(List<Account> newList, List<Account> oldList, Map<Id,Account> newMap, Map<Id,Account> oldMap){
        Set<Id> acids = new Set<Id>();
        for (Account ac : newList){
            if(recordsProcessed == false){
                if(!processedAccountId.contains(ac.Id)) acids.add(ac.id);
                processedAccountId.add(ac.id);
            }
            recordsProcessed = true;
        }
        List<Opportunity> relatedOpportunity = new List<Opportunity>();
        if(!acids.isEmpty()){
            relatedOpportunity = [SELECT id, name, StageName, accountid FROM Opportunity WHERE accountid IN :acids];
        }
        List<Opportunity> OpportunityToUpdate = new List<Opportunity>();
        for (Opportunity op : relatedOpportunity){
            op.StageName = 'Negotiation/Review';
            OpportunityToUpdate.add(op);
        }
        update OpportunityToUpdate;
    }
}

trigger AccountTrigger on Account (before update, after insert, after update, before insert, before delete, after delete) {
    if(Trigger.isAfter && Trigger.isUpdate){
        AccountTriggerHandler.afterUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.OldMap);
    }
}
```

**적용된 모범 사례:** 핸들러 클래스로 로직 분리, static 변수로 중복 처리 방지, 벌크 처리. 추가로 try-catch 오류 처리, Custom Setting/Metadata로 StageName 구성 가능, 루프 안 SOQL 회피.
