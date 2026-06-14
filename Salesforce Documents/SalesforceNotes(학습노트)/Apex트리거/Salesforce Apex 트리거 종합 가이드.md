---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce Apex Trigger a Comprehensive Guide]
---

# Salesforce Apex 트리거 종합 가이드

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 1. Apex 트리거란?

데이터베이스에서 특정 이벤트(레코드 삽입·업데이트·삭제) 발생 시 자동 실행되는 절차. 이벤트 전후 커스텀 액션으로 복잡한 비즈니스 로직 구현·프로세스 간소화.

## 2. 언제 사용하나?

선언적 도구로 부족할 때: 복잡한 로직, DML 작업 관련 로직, 비관련 오브젝트 작업, 외부 시스템 통합.

## 3. 유형

- **Before Trigger:** 레코드 저장 전 실행. 값 검증·수정.
- **After Trigger:** 시스템이 값을 설정한 후 실행. 읽기 전용, 다른 레코드 변경에 시스템 설정값 사용.

## 4. 트리거 이벤트

Before/After Insert·Update·Delete, After Undelete. `trigger <Name> on <Object> (trigger_events) { }`.

## 5. 컨텍스트 변수

isExecuting, isInsert, isUpdate, isDelete, isBefore, isAfter, new(insert·update·undelete), newMap(before update·after insert·update·undelete), old(update·delete), oldMap(before update·after insert·update·delete).

## 6. 예시
```apex
trigger AccountValidationTrigger on Account (before insert, before update) {
    for(Account acc : Trigger.new) {
        if(String.isBlank(acc.Custom_Field__c)) {
            acc.addError('Custom Field must not be blank.');
        }
    }
}
```

## 7. 모범 사례

오브젝트당 트리거 하나, 컨텍스트별 핸들러 메서드, FOR 루프 안 SOQL·DML 회피, 컬렉션·효율적 FOR 루프, 대용량 데이터 쿼리, @future 적절히 사용.

## 8. 재귀 방지
```apex
public class TriggerHelper { public static Boolean isExecuting = false; }
trigger AccountTrigger on Account (before insert) {
    if(!TriggerHelper.isExecuting) {
        TriggerHelper.isExecuting = true;
        // 로직
        TriggerHelper.isExecuting = false;
    }
}
```

## 9. 실행 순서

Before 트리거 → 시스템 검증 규칙 → Duplicate 규칙 → 커스텀 검증 규칙 → After 트리거 → 할당 규칙 → 자동 응답 규칙 → 워크플로우 규칙·프로세스 → 에스컬레이션 규칙 → 부모 롤업 요약 수식 → Criteria 기반 공유 규칙 → Apex 공유 → DB 커밋 → 커밋 후 로직(이메일).

## 10. 트리거 프레임워크

중앙 핸들러 클래스가 트리거 이벤트를 관리하고 특정 핸들러 클래스에 실행을 위임. 코드 조직·관심사 분리·유지보수성 향상.
