---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Apex Trigger Notes by Abhishek Singh]
---

# Apex 트리거: 개념과 노트 (Abhishek Singh)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

트리거는 force.com 데이터베이스에서 레코드가 삽입·업데이트·삭제되기 전후에 실행되는 코드. Salesforce가 개발한 Apex 언어로 작성.

## 핵심 개념

### 트리거 이벤트
- **Before 트리거**: 저장 전 레코드 값 업데이트·검증.
- **After 트리거**: 저장 후 작업(이메일 전송, 관련 레코드 변경).

유형: Before Insert, After Insert, Before Update, After Update, Before Delete, After Delete, After Undelete.

| 이벤트 | 용도 | 예 |
|---|---|---|
| Before Insert | 삽입 전 복잡한 비즈니스 로직·검증 | 검증 규칙 |
| After Insert | 삽입 후 비즈니스 로직 | 이메일 알림 |
| Before Update | 업데이트 전 작업 | 검증 |
| After Update | 업데이트 후 작업 | 값 복제, 이메일 알림 |
| Before Delete | 삭제 전 작업 | 접근 확인, 자식 레코드 제거 |
| After Delete | 삭제 후 작업 | 알림, 롤업 요약 갱신 |
| After Undelete | 복원 후 작업 | 알림, 롤업 요약 갱신 |

### Before Undelete가 없는 이유
**도서관 비유:**

책(레코드)을 창고(휴지통)에서 꺼내 그대로 책장에 다시 놓는다. 꺼내기 *전에* 검사·변경할 게 없으므로 "Before Undelete"는 불필요. 하지만 복원 *후* 책이 다시 이용 가능함을 알리거나 카탈로그를 갱신할 수 있어 "After Undelete"는 존재.

## 구문
```apex
trigger TriggerName on ObjectName (trigger_events) {
    // 트리거 로직
}
// 예
trigger AccountTrigger on Account (before insert, after update) {
    // 로직
}
```

## 컨텍스트 변수 (System.Trigger 클래스)

| 변수 | 설명 | 사용 가능 |
|---|---|---|
| Trigger.new | 삽입·업데이트되는 새 버전 레코드 | Insert, Update, Undelete |
| Trigger.old | 업데이트·삭제되는 이전 버전 | Update, Delete |
| Trigger.newMap | ID→새 레코드 맵 | Insert, Update, Undelete |
| Trigger.oldMap | ID→이전 레코드 맵 | Update, Delete |
| Trigger.isInsert | insert면 true | 전체 |
| Trigger.isUpdate | update면 true | 전체 |
| Trigger.isDelete | delete면 true | 전체 |
| Trigger.isBefore | 저장 전이면 true | 전체 |
| Trigger.isAfter | 저장 후면 true | 전체 |
| Trigger.isUndelete | undelete면 true | After Undelete |
| Trigger.size | 처리 중 레코드 총 수 | 전체 |

```apex
for(Account acc : Trigger.new) { /* 새 레코드 처리 */ }
Account acc = Trigger.newMap.get(someAccountId);
if (Trigger.isInsert) { /* 삽입 시만 */ }
Integer recordCount = Trigger.size;
```

## 트리거 실행 흐름 (DML 발생 시 순서)

1. **시스템 검증 규칙** — 필드 타입·필수 필드 확인.
2. **Before 트리거** — 저장 전 레코드 추가 변경(기본값 설정 등).
3. **커스텀 검증 규칙** — 실패 시 작업 중단.
4. **중복 규칙** — 차단 설정이면 여기서 중단.
5. **After 트리거** — 저장 후(커밋 전). 관련 레코드 업데이트·알림.
6. **할당 규칙** (Lead·Case).
7. **자동 응답 규칙** (Lead·Case).
8. **워크플로우 규칙** — 필드 업데이트·태스크·이메일·아웃바운드 메시지. 필드 업데이트 시 before/after update 트리거 재발동.
9. **프로세스 빌더** — 필드·관련 레코드 업데이트, Flow 호출.
10. **에스컬레이션 규칙** (Case).
11. **엔타이틀먼트 규칙** (Case·Contract).
12. **롤업 요약 필드** — 부모 레코드 재계산.
13. **교차 오브젝트 워크플로우 업데이트** — 부모 레코드 업데이트 시 추가 트리거 발동 가능.
14. **기준 기반 공유 규칙**.
15. **커밋** — 오류 없으면 DB에 최종 저장.
16. **커밋 후 로직** — 이메일, 콜아웃, 비동기(@future·Queueable·Batch).

## 트리거 모범 사례

1. **오브젝트당 트리거 하나** — 실행 순서 제어.
2. **로직 없는 트리거** — 로직은 핸들러로(테스트·재사용).
3. **컨텍스트별 핸들러 메서드**.
4. **코드 벌크화** — 한 번에 여러 레코드.
5. **FOR 루프 안 SOQL/DML 회피** — SOQL 100개 한도.
6. **컬렉션·효율적 쿼리**.
7. **대용량 데이터셋** — SOQL 50,000건 한도, SOQL for 루프 사용.
8. **@future 적절히 사용**.
9. **ID 하드코딩 금지**.

기억할 거버너 한도: SOQL 100/트랜잭션, DML 150/트랜잭션, CPU 시간 10,000ms.

### 예: Before Insert 기본값
```apex
trigger SetAccountIndustry on Account (before insert) {
    for(Account acc : Trigger.new) {
        if(acc.Industry == null) acc.Industry = 'Technology';
    }
}
```

### 헬퍼 클래스 사용
```apex
trigger AccountTrigger on Account (before insert) {
    AccountHelper.setDefaultIndustry(Trigger.new);
}
public class AccountHelper {
    public static void setDefaultIndustry(List<Account> accounts) {
        for(Account acc : accounts) {
            if(acc.Industry == null) acc.Industry = 'Technology';
        }
    }
}
```

### 루프 안 SOQL 회피
```apex
// 나쁨
for(Account acc : Trigger.new) {
    List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
}
// 좋음
List<Id> accountIds = new List<Id>();
for(Account acc : Trigger.new) accountIds.add(acc.Id);
List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId IN :accountIds];
```

## 트리거 시나리오

### 1. Before Insert — 기본값
Industry 미입력 시 'Technology'.
```apex
trigger BeforeAccountInsert on Account (before insert) {
    for (Account acc : Trigger.New) {
        if (acc.Industry == null) acc.Industry = 'Technology';
    }
}
```

### 2. After Insert — 새 Lead에 후속 Task 생성 (3일 후)
```apex
trigger AfterLeadInsert on Lead (after insert) {
    List<Task> tasks = new List<Task>();
    for (Lead lead : Trigger.New) {
        tasks.add(new Task(Subject='Follow up with Lead',
            ActivityDate=System.today().addDays(3), WhatId=lead.Id, Status='Not Started'));
    }
    insert tasks;
}
```

### 3. Before Update — Amount<$10,000 시 Stage 변경 차단
```apex
trigger BeforeOpportunityUpdate on Opportunity (before update) {
    for (Opportunity opp : Trigger.New) {
        if (opp.Amount < 10000 && opp.StageName != Trigger.oldMap.get(opp.Id).StageName) {
            opp.addError('Amount가 $10,000 미만인 Opportunity는 Stage를 변경할 수 없습니다');
        }
    }
}
```

### 4. After Update — Last_Update_By__c 기록
```apex
trigger AfterAccountUpdate on Account (after update) {
    List<Account> toUpdate = new List<Account>();
    for (Account acc : Trigger.New) {
        toUpdate.add(new Account(Id=acc.Id, Last_Update_By__c=UserInfo.getUserName()));
    }
    update toUpdate;
}
```

### 5. Before Delete — 관련 Case 있으면 삭제 방지
```apex
trigger BeforeAccountDelete on Account (before delete) {
    for (Account acc : Trigger.Old) {
        Integer openCaseCount = [SELECT COUNT() FROM Case WHERE AccountId = :acc.Id AND Status != 'Closed'];
        if (openCaseCount > 0) acc.addError('열린 Case가 있는 Account는 삭제할 수 없습니다.');
    }
}
```

### 6. After Delete — 삭제 로그 기록
```apex
trigger AfterAccountDelete on Account (after delete) {
    List<Account_Deletion_Log__c> logs = new List<Account_Deletion_Log__c>();
    for (Account acc : Trigger.Old) {
        logs.add(new Account_Deletion_Log__c(Account_Name__c=acc.Name, Deleted_On__c=System.today()));
    }
    insert logs;
}
```

### 7. After Undelete — 관련 Contact 복원
```apex
trigger AfterAccountUndelete on Account (after undelete) {
    List<Contact> contactsToRestore = [SELECT Id FROM Contact WHERE AccountId = :Trigger.OldMap.keySet()];
    undelete contactsToRestore;
}
```

## 트리거 vs Process Builder vs Flow
트리거는 복잡한 저수준 제어가 가능하나 Apex 코딩 필요. Process Builder/Flow는 단순 로직용 선언적 도구이나 복잡도에 제약.
