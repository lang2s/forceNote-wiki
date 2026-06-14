# Apex 트리거(Apex Triggers)

## 트리거

DML 작업 시 실행되는 Apex 코드/함수 블록. DML 작업: Insert, Update, Delete, Undelete.

## 트리거 유형

- **Before Trigger:** 데이터 검증·조작용. addError 메서드로 레코드의 DML 작업을 막을 수도 있음.
- **After Trigger:** 레코드 ID 접근이나 저장 후 관련 레코드 변경 시 사용.

## 이벤트

Before/After 이벤트. 실행 이벤트: before/after insert, before/after update, before/after delete, after undelete. (Undelete에는 before 이벤트 없음.)

## 컨텍스트 변수

런타임 컨텍스트(트리거 유형, 작동 레코드 목록)에 접근하는 암묵적 변수.

| 변수 | 설명 |
|---|---|
| isInsert | insert 작업으로 발동 시 true |
| isUpdate | update 작업 시 true |
| isDelete | delete 작업 시 true |
| isUndelete | undelete 작업 시 true |
| isBefore | 저장 전 발동 시 true |
| isAfter | 저장 후 발동 시 true |
| new | 새 버전 sObject 레코드 목록(insert·update·undelete) |
| old | 이전 버전 레코드 목록(update·delete) |
| newMap | ID→새 버전 맵(after insert·before/after update·after undelete) |
| oldMap | ID→이전 버전 맵(update·delete) |
| size | 트리거 호출의 총 레코드 수(old+new) |
| isExecuting | 현재 컨텍스트가 트리거이면 true |
| operationType | System.TriggerOperation enum 반환 |

## 모범 사례

코드 벌크화, 루프 안 SOQL·DML 회피, 로직 없는 트리거(Handler·Helper 클래스 사용), 컬렉션으로 데이터 저장, 하드코딩 회피.

## 구문

```apex
trigger Trigger_Name on sObject (TriggerEvents) { }
// 예
trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update, before delete, after delete, after undelete) { }
```
