---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Trigger in Salesforce]
---

# Salesforce의 트리거 (Triggers in Salesforce)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

Apex 트리거는 Salesforce 레코드의 삽입·업데이트·삭제 같은 변경 전후에 커스텀 액션을 수행할 수 있게 해준다.

## 트리거 유형

**Before 트리거**

— 레코드가 DB에 저장되기 전에 레코드를 업데이트·검증할 때 사용.

**After 트리거**

— 시스템이 설정한 필드 값에 접근하거나, 다른 레코드에 변경을 적용할 때 사용.

## Before vs After 사용 시점

| Before 트리거 | After 트리거 |
|---|---|
| 레코드가 DB에 커밋되기 전 실행. 추가 DML 없이 업데이트 중인 레코드를 수정 가능. | 레코드가 DB에 커밋된 후 실행. 업데이트된 레코드를 바꾸려면 추가 DML이 필요. |
| 업데이트 중인 레코드 자체를 변경할 때 | 관련(다른) 오브젝트를 변경할 때 |

**Before 제한:**

Before 트리거에서는 새 레코드의 Id 필드 접근 불가, 수식(Formula) 필드 미계산.

**After 제한:**

추가 DML 없이 레코드 필드 업데이트 불가, 롤업 요약 사용 불가.

## 트리거 이벤트

Before: Insert, Update, Delete
After: Insert, Update, Delete, Undelete

구문:
```apex
trigger TriggerName on ObjectName (trigger_events) {
    code_block;
}
```

## 트리거 실행 순서

1. 시스템 검증 규칙
2. Apex Before 트리거
3. 커스텀 검증 규칙
4. 중복(Duplicate) 규칙 — 이 단계 후 레코드가 DB에 임시 저장(미커밋)되고 **Record ID가 생성**됨. 이 시점까지 롤백 가능.
5. Apex After 트리거
6. 할당 규칙
7. 자동 응답 규칙
8. 워크플로우 규칙
9. 프로세스 빌더 / 플로우
10. 에스컬레이션 규칙
11. 롤업 요약 필드 — **이 11단계 후 커밋이 일어나며 이후 롤백 불가**

## 트리거 컨텍스트 변수

| 변수 | 타입 |
|---|---|
| Trigger.isBefore / isAfter | Boolean |
| Trigger.isInsert / isUpdate / isDelete / isUndelete | Boolean |
| Trigger.isExecuting | Boolean |
| Trigger.new / Trigger.old | List |
| Trigger.newMap / Trigger.oldMap | Map |
| Trigger.operationType | Enum |
| Trigger.size | Integer |

| 이벤트 | Before | After |
|---|---|---|
| INSERT | Trigger.new | Trigger.new, newMap |
| UPDATE | new, old | new, newMap, old, oldMap |
| DELETE | old, oldMap | old, oldMap |
| UNDELETE | — | new, newMap |

- **Trigger.new**: 트리거 활성화 후 모든 레코드 목록. after DML에서는 이미 저장되어 변경 불가(변경 시 `record is read-only` 오류). before DML에서만 변경 가능.
- **Trigger.old**: 업데이트 전 이전 레코드 목록. update·delete 트리거만 해당(insert에는 없음).
- **Trigger.oldMap**: 업데이트 전 record Id→레코드 Map. update·delete만.
- **Trigger.newMap**: record Id→레코드 Map. ID가 채워진 후에만 조회 가능 → Before Insert에서는 접근 불가. After insert, before update, after undelete에서 지원.
- **Trigger.operationType**: System.TriggerOperation enum 반환(BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE, AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE, AFTER_UNDELETE). switch 문과 함께 사용 권장.

**주의사항:**

trigger.new/old는 DML에 직접 사용 불가. before 트리거에서만 trigger.new로 자기 필드 변경 가능. trigger.old는 항상 읽기 전용. trigger.new는 삭제 불가.

## 트리거 관련 시나리오

### 1. Account 생성 시 관련 Contact 생성
```apex
trigger NewAcc on Account (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        List<Contact> acc = new List<Contact>();
        for(Account a: trigger.new){
            Contact c = new Contact();
            c.AccountId = a.Id;
            c.LastName = 'Test contact';
            acc.add(c);
        }
        insert acc;
    }
}
```
관련 오브젝트를 변경해야 하므로 After 트리거 사용. Trigger.new로 새 레코드 ID를 가져오고 DML로 관련 레코드 삽입.

### 2. 동일 이름 Account 중복 생성 방지
```apex
trigger AccountTrigger on Account (before insert, before update) {
    for(Account a: Trigger.new){
        List<Account> acclist = [SELECT Name FROM Account WHERE Name = :a.Name];
        if(acclist.size() > 0){
            a.addError('Duplicate Account Name exists');
        }
    }
}
```

### 3. Account에 'Count of Contacts' 필드 채우기 (추가·삭제 시 자동 갱신)
```apex
public class ContactHandlerr {
    public static void noOfContacts(){
        Set<Id> accIds = new Set<Id>();
        for(Contact c : (List<Contact>) Trigger.new){
            if(c.AccountId != null) accIds.add(c.AccountId);
        }
        List<Account> toUpdate = new List<Account>();
        List<Account> acc = [SELECT Id, NoOfContacts__c, (SELECT Id FROM Contacts)
                             FROM Account WHERE Id IN :accIds];
        for(Account a : acc){
            a.NoOfContacts__c = a.Contacts.size();
            toUpdate.add(a);
        }
        update toUpdate;
    }
}

trigger contactTrigger on Contact (after insert, after update) {
    switch on Trigger.OperationType {
        when AFTER_INSERT { ContactHandlerr.noOfContacts(); }
        when AFTER_UPDATE { ContactHandlerr.noOfContacts(); }
    }
}
```

### 4. Rating 없이 Account 생성 시 'cold'로 기본값 설정
```apex
trigger AccountTrigger on Account (before insert) {
    for(Account a : Trigger.new){
        if(a.Rating == null) a.Rating = 'cold';
    }
}
```

### 5. Industry='Agriculture' Account 생성/업데이트 시 Opportunity 생성
Stage='Prospecting', Amount=$0, CloseDate=오늘+90일.
```apex
trigger NewOpp on Account (after insert, after update) {
    List<Opportunity> oppList = new List<Opportunity>();
    if(Trigger.isAfter){
        for(Account a : Trigger.new){
            Boolean make = false;
            if(Trigger.isInsert && a.Industry == 'Agriculture') make = true;
            if(Trigger.isUpdate && a.Industry == 'Agriculture'
               && a.Industry != Trigger.oldMap.get(a.Id).Industry) make = true;
            if(make){
                oppList.add(new Opportunity(
                    Name = a.Name + ' OPPORTUNITY', AccountId = a.Id,
                    StageName = 'Prospecting', CloseDate = System.today()+90, Amount = 0));
            }
        }
        if(!oppList.isEmpty()) insert oppList;
    }
}
```

## 트리거 모범 사례

1. **오브젝트당 트리거 하나** — 여러 트리거는 실행 순서 제어 불가.
2. **로직 없는 트리거** — 로직은 핸들러로 분리(테스트·재사용 용이).
3. **컨텍스트별 핸들러 메서드** 작성.
4. **코드 벌크화** — 한 번에 여러 레코드 처리.
5. **FOR 루프 안 SOQL/DML 회피** — 요청당 SOQL 100개 한도.
6. **컬렉션·효율적 쿼리** 사용으로 거버너 한도 회피.
7. **대용량 데이터셋** — SOQL 반환 50,000건 한도. 초과 시 SOQL for 루프 사용.
8. **@future 적절히 사용**.
9. **ID 하드코딩 금지** — 환경 간 ID 변경에 대응.
