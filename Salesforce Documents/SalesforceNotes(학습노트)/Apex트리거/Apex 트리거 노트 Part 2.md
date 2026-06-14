---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Triggers Notes Part -2]
---

# Apex 트리거 노트 Part 2

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 트리거란?

Salesforce 레코드 변경(Insert, Update, Delete, Merge, Upsert, Undelete) 전후에 실행되는 Apex 코드.

### 사용 시점
1. 레코드 삽입·업데이트·삭제·복원 시 호출되는 저장된 Apex 프로시저. 단일/다중 레코드 변경 시 해당 오브젝트의 트리거가 발동.
2. 예: 레코드 삽입 전, 삭제 후, 휴지통 복원 후 실행.
3. 포인트앤클릭 도구로 불가능한 작업에 사용. 가능하면 선언적 도구 우선.
4. 생성 시 기본 활성화되며 지정 이벤트 발생 시 자동 발동.

### 유형
- **Before 트리거**: 저장 전 레코드 업데이트·검증.
- **After 트리거**: 시스템 설정 필드(recordId, lastModifiedDate) 접근. 다른 레코드 변경 가능하나, 발동시킨 레코드 자체는 읽기 전용.

구문:
```apex
trigger TriggerName on ObjectName (trigger_events) {
    // code-block
}
```
이벤트: before insert/update/delete, after insert/update/delete/undelete.

> **주의:** before 트리거에서 레코드를 업데이트·삭제하거나, after 트리거에서 레코드를 삭제하면 오류 발생(직접·간접 작업 모두 포함).

## Salesforce 실행 순서 단계 (상세)

1. **데이터 로드** — DB에서 레코드 초기화, 새 값으로 덮어쓰기.
2. **요청 식별** — 출처(표준/커스텀 UI, SOAP/REST API) 식별, 그에 따른 검증.
3. **Record-Triggered Flow (Before) 실행**.
4. **Before 트리거 실행**.
5. **데이터 검증** — 시스템·커스텀 검증.
6. **중복 규칙** — Block 액션이면 여기서 실행 중단.
7. **레코드 저장** (커밋 아님) — 전체 순서가 성공해야 커밋.
8. **After 트리거 실행**.
9. **할당 규칙**.
10. **자동 응답 규칙**.
11. **워크플로우 규칙** — 필드 업데이트 시 레코드 재업데이트, 시스템 검증 재실행, before/after update 트리거 한 번 더 실행(insert/update 무관, 단 한 번).
12. **에스컬레이션 규칙**.
13. **Flow / 프로세스 실행**.
14. **After Record-Triggered Flow 실행**.
15. **엔타이틀먼트 규칙**.
16. **롤업 요약 필드** — 계산 후 부모/조부모 레코드가 저장 절차 재진입.
17. **기준 기반 공유 규칙(Criteria-Based Sharing)**.
18. **레코드 커밋** — DB에 최종 커밋.
19. **커밋 후 로직** — 리포트 생성, 외부 시스템 업데이트, 알림·이메일, async 작업 호출 등.

## 컨텍스트 변수
- **Trigger.New**: insert·update 트리거에서 삽입된 모든 레코드.
- **Trigger.Old**: update 트리거의 이전 버전, delete 트리거의 삭제된 레코드 목록.
- Trigger.new/old는 DML에 직접 사용 불가. before 트리거에서만 trigger.new로 자기 필드 변경. trigger.old는 읽기 전용. trigger.new 삭제 불가.
- Upsert·merge 이벤트는 자체 트리거가 없고, 결과로 다른 트리거를 발동.

## 벌크 Apex 트리거

벌크 설계 패턴은 성능 향상, 리소스 절약, 플랫폼 한도 준수에 유리.

```apex
// 비벌크 (나쁨)
trigger MyTriggerNotBulk on Account(before insert) {
    Account a = Trigger.New[0];
    a.Description = 'New description';
}
// 벌크 (좋음)
trigger MyTriggerBulk on Account(before insert) {
    for(Account a : Trigger.New) {
        a.Description = 'New description';
    }
}
```

### 벌크 SOQL — 루프 안 쿼리 회피 (동기 100, 비동기 200 한도)
```apex
// 좋음: 자식과 함께 한 번에 쿼리
trigger SoqlTriggerBulk on Account(after update) {
    for(Opportunity opp : [SELECT Id,Name,CloseDate FROM Opportunity
                           WHERE AccountId IN :Trigger.New]) {
        // 처리
    }
}
```
> 트리거는 200건 배치로 실행. 400건이면 두 번 발동(200건씩).

### 벌크 DML (트랜잭션당 150 DML 한도)
```apex
trigger DmlTriggerBulk on Account(after update) {
    List<Opportunity> relatedOpps = [SELECT Id,Name,Probability FROM Opportunity
                                     WHERE AccountId IN :Trigger.New];
    List<Opportunity> oppsToUpdate = new List<Opportunity>();
    for(Opportunity opp : relatedOpps) {
        if (opp.Probability >= 50 && opp.Probability < 100) {
            opp.Description = 'New description for opportunity.';
            oppsToUpdate.add(opp);
        }
    }
    update oppsToUpdate;  // 컬렉션에 대해 한 번만 DML
}
```

### 관련 레코드 추가 (개선) — 메인 쿼리에 조건 포함
```apex
trigger AddRelatedRecord on Account(after insert, after update) {
    List<Opportunity> oppList = new List<Opportunity>();
    for (Account a : [SELECT Id,Name FROM Account
                      WHERE Id IN :Trigger.New AND
                      Id NOT IN (SELECT AccountId FROM Opportunity)]) {
        oppList.add(new Opportunity(Name=a.Name + ' Opportunity',
            StageName='Prospecting', CloseDate=System.today().addMonths(1), AccountId=a.Id));
    }
    if (oppList.size() > 0) insert oppList;
}
```

## 주요 시나리오

### 1. 부모 After Update → 자식 업데이트
Account의 Industry 변경 시 관련 Contact의 Industry__c 업데이트.
```apex
trigger AccountAfterUpdate on Account (after update) {
    Set<Id> accountIds = new Set<Id>();
    for (Account acc : Trigger.new) {
        if (acc.Industry != Trigger.oldMap.get(acc.Id).Industry) accountIds.add(acc.Id);
    }
    if (!accountIds.isEmpty()) {
        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds]) {
            con.Industry__c = Trigger.newMap.get(con.AccountId).Industry;
            contactsToUpdate.add(con);
        }
        if (!contactsToUpdate.isEmpty()) update contactsToUpdate;
    }
}
```

### 2. 부모 After Insert → 자식 생성
새 Account마다 Contact 2개 기본 생성.
```apex
trigger AccountAfterInsert on Account (after insert) {
    List<Contact> contactsToInsert = new List<Contact>();
    for (Account acc : Trigger.new) {
        contactsToInsert.add(new Contact(LastName = 'Primary', AccountId = acc.Id));
        contactsToInsert.add(new Contact(LastName = 'Secondary', AccountId = acc.Id));
    }
    if (!contactsToInsert.isEmpty()) insert contactsToInsert;
}
```

### 3. 자식 After Update → 부모 업데이트 (Map 사용)
```apex
trigger ContactAfterUpdate on Contact (after update) {
    Map<Id, Account> accountsToUpdate = new Map<Id, Account>();
    for (Contact con : Trigger.new) {
        if (con.IsActive__c != Trigger.oldMap.get(con.Id).IsActive__c) {
            accountsToUpdate.put(con.AccountId, new Account(Id = con.AccountId, Has_Active_Contacts__c = true));
        }
    }
    if (!accountsToUpdate.isEmpty()) update accountsToUpdate.values();
}
```

### 4. 롤업 요약 시뮬레이션 (비 Master-Detail)
```apex
trigger ContactAfterInsertUpdateDelete on Contact (after insert, after update, after delete, after undelete) {
    Map<Id, Integer> cnt = new Map<Id, Integer>();
    for (Contact con : [SELECT AccountId FROM Contact WHERE AccountId != NULL]) {
        cnt.put(con.AccountId, cnt.getOrDefault(con.AccountId, 0) + 1);
    }
    List<Account> toUpdate = new List<Account>();
    for (Id accId : cnt.keySet()) {
        toUpdate.add(new Account(Id = accId, Active_Contacts__c = cnt.get(accId)));
    }
    if (!toUpdate.isEmpty()) update toUpdate;
}
```

### 7. 트리거 재귀 방지
정적 변수, 컨텍스트 변수(isBefore/isAfter), Custom Settings 활용.
```apex
public class TriggerHandler {
    public static Boolean isTriggerExecuted = false;
}
trigger AccountTrigger on Account (after update) {
    if (TriggerHandler.isTriggerExecuted) return;
    TriggerHandler.isTriggerExecuted = true;
    // 트리거 로직
    TriggerHandler.isTriggerExecuted = false;
}
```
