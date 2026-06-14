---
tags: [apex, trigger, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Mastering Trigger for Interviews]
---

# Q&A을 위한 트리거 마스터 (Mastering Triggers for Interviews)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## 트리거 실행 시나리오
- Insert: Before, After
- Update: Before, After
- Delete: Before, After
- Undelete: After

## 컨텍스트 변수
isBefore, isAfter, isInsert, isUpdate, isDelete, isUndelete (Boolean), new/old (List), newMap/oldMap (Map), operationType (Enum), size (Integer), isExecuting (Boolean).

| 이벤트 | Before | After |
|---|---|---|
| INSERT | new | new, newMap |
| UPDATE | new, newMap, old, oldMap | new, newMap, old, oldMap |
| DELETE | old, oldMap | old, oldMap |
| UNDELETE | — | new, newMap |

## 이벤트 선택 기준

| 작업 | Before | After | DML 필요 |
|---|---|---|---|
| 같은 레코드 필드 업데이트 | ✔ | | 아니오 |
| 검증 오류 추가 | ✔ | ✔ | |
| 관련 레코드 필드 업데이트 | | ✔ | 예 |
| 새 레코드 생성 | | ✔ | 예 |
| 이메일/알림 전송 | | ✔ | |

## Flow vs Apex 트리거

**Flow 사용 시점:** 단순 자동화(알림·필드 업데이트·레코드 생성), 화면 상호작용, 선언적 해결, 저volume 업데이트.

**트리거 사용 시점:** 복잡한 로직(다중 조건·루프·관련 오브젝트 계산), 벌크 처리, 교차 오브젝트 작업, 실시간 처리.

## 기억할 점

**트리거 청크 크기:** 200건 단위로 처리. 210건 삽입 시 두 번 실행(200 + 10).

**재귀 방지:** ① 정적 변수, ② 정적 ID Set(200건 초과 처리에 더 적합).

**정적 변수 vs 정적 Set:** 정적 변수만 쓰면 처음 200건만 처리되고 나머지는 오류 없이 누락될 수 있음. **정적 ID Set**을 쓰면 모든 청크가 처리됨.

**일반 오류:** "Maximum Trigger Depth Exceeded" — 재귀 미제어 시 발생. (예: After 트리거에서 Customer Priority=High일 때 Rating=Hot 설정 → 재귀)

**Before vs After:** Before는 검증·같은 레코드 업데이트·오류 추가. After는 관련 레코드 생성·이메일·로깅(컨텍스트 변수 읽기 전용).

**참고:** Flow에서는 undelete 후 자동화 미지원. 콜아웃은 트리거가 동기이므로 Future 메서드 사용.

## 모범 사례
1. 오브젝트당 트리거 하나(실행 순서 제어)
2. 비즈니스 로직은 Trigger Handler에
3. 항상 벌크화
4. 중첩 루프 회피 → Map 사용
5. 재귀 신중히 제어
6. 코드 문서화
7. 배포 전 미사용 코드·디버그 문 제거
8. 벌크 시나리오로 단위 테스트
9. 컨텍스트 변수 숙달

## Trigger Handler 패턴

```apex
public class AccountTriggerHandler {
    List<Account> triggerNew;
    List<Account> triggerOld;
    Map<Id, Account> triggerNewMap;
    Map<Id, Account> triggerOldMap;

    public AccountTriggerHandler() {
        triggerNew = (List<Account>) Trigger.New;
        triggerOld = (List<Account>) Trigger.Old;
        triggerNewMap = (Map<Id, Account>) Trigger.NewMap;
        triggerOldMap = (Map<Id, Account>) Trigger.OldMap;
    }

    public void doAction() {
        switch on Trigger.operationType {
            when BEFORE_INSERT { onBeforeInsert(); }
            when AFTER_INSERT  { onAfterInsert(); }
            when BEFORE_UPDATE { onBeforeUpdate(); }
            when AFTER_UPDATE  { onAfterUpdate(); }
            when BEFORE_DELETE { onBeforeDelete(); }
            when AFTER_DELETE  { onAfterDelete(); }
            when AFTER_UNDELETE { onAfterUndelete(); }
        }
    }
    public void onBeforeInsert() { }
    public void onAfterInsert() { }
    public void onBeforeUpdate() { }
    public void onAfterUpdate() { }
    public void onBeforeDelete() { }
    public void onAfterDelete() { }
    public void onAfterUndelete() { }
}

trigger AccountTrigger on Account (before insert, after insert, before update,
    after update, before delete, after delete, after undelete) {
    AccountTriggerHandler handler = new AccountTriggerHandler();
    handler.doAction();
}
```
**장점:** 모듈화, 유지보수·확장성, 오류 처리·가독성 향상. 각 메서드는 벌크 처리. Trigger.operationType으로 컨텍스트 판단.

## 메서드별 예제

### Before Insert — Industry='Banking'이면 Rating='Hot'
```apex
public void onBeforeInsert() { updateRating(); }
public void updateRating() {
    for (Account record : triggerNew) {
        if (record.Industry == 'Banking') record.Rating = 'Hot';
    }
}
```

### Before Update — Rating 없으면 'Cold'
```apex
public void onBeforeUpdate() { updateRating(); }
public void updateRating() {
    for (Account record : triggerNew) {
        if (record.Rating == null) record.Rating = 'Cold';
    }
}
```

### Before Delete — 'Working - Contacted' Lead 삭제 방지
```apex
public void onBeforeDelete() {
    for (Lead record : triggerOld) {
        if (record.Status == 'Working - Contacted') {
            record.addError('상태가 Working Contacted일 때는 Lead를 삭제할 수 없습니다.');
        }
    }
}
```

### After Insert — Opportunity 생성 시 후속 Task 생성
```apex
public void onAfterInsert() {
    List<Task> taskList = new List<Task>();
    List<Opportunity> opportunityList = [SELECT Id, StageName, OwnerId FROM Opportunity WHERE Id IN :triggerNew];
    for (Opportunity record : opportunityList) {
        Task t = new Task();
        t.WhatId = record.Id;
        t.OwnerId = record.OwnerId;
        t.Subject = 'Follow up';
        taskList.add(t);
    }
    try { insert taskList; }
    catch (DmlException e) { System.debug('Task 생성 오류: ' + e.getMessage()); }
}
```

### After Update — Account 비활성화 시 관련 Case 닫기
```apex
public void onAfterUpdate() {
    Set<Id> inactiveAccountIds = new Set<Id>();
    for (Account acc : triggerNew) {
        Account oldAcc = triggerOldMap.get(acc.Id);
        if (oldAcc.Active__c != 'No' && acc.Active__c == 'No') inactiveAccountIds.add(acc.Id);
    }
    List<Case> caseList = new List<Case>();
    if (!inactiveAccountIds.isEmpty()) {
        for (Case c : [SELECT Id, Status, AccountId FROM Case
                       WHERE AccountId IN :inactiveAccountIds AND Status != 'Closed']) {
            c.Status = 'Closed';
            caseList.add(c);
        }
    }
    if (!caseList.isEmpty()) {
        try { update caseList; }
        catch (DmlException e) { System.debug('Case 업데이트 오류: ' + e.getMessage()); }
    }
}
```

### After Delete — Department 삭제 시 관련 Employee 연쇄 삭제
```apex
public class DepartmentTriggerHandler {
    static List<Employee_Management__c> employeeList = new List<Employee_Management__c>();
    // ... 생성자 ...
    public void onBeforeDelete() {
        Set<Id> departmentIds = new Set<Id>();
        for (Department__c dept : triggerOld) departmentIds.add(dept.Id);
        employeeList = [SELECT Id, Name FROM Employee_Management__c WHERE Departments__c IN :departmentIds];
    }
    public void onAfterDelete() {
        if (!employeeList.isEmpty()) {
            try { delete employeeList; }
            catch (DmlException e) { System.debug('Employee 삭제 오류: ' + e.getMessage()); }
        }
    }
}
```
> static employeeList는 같은 트랜잭션 내에서 데이터 무결성 유지·중복 처리 방지에 유용.

### After Undelete — Department 복원 시 Employee 복원
```apex
public void onAfterUndelete() {
    List<Employee_Management__c> empList = [
        SELECT Id, Department__c FROM Employee_Management__c
        WHERE Department__c IN :Trigger.new AND IsDeleted = true ALL ROWS];
    try {
        if (!empList.isEmpty()) undelete empList;
    } catch (DmlException e) { System.debug('Employee 복원 오류: ' + e.getMessage()); }
}
```

### Roll-up Summary — Opportunity Stage 변경 시 Account에 카운트
```apex
public static void updateCountOfOpportunity() {
    Set<Id> accountIds = new Set<Id>();
    for (Opportunity opp : (List<Opportunity>)Trigger.new) {
        if (opp.AccountId != null) {
            if (Trigger.isUpdate) {
                if (Trigger.OldMap.get(opp.Id).StageName != opp.StageName) accountIds.add(opp.AccountId);
            } else {
                accountIds.add(opp.AccountId);
            }
        }
    }
    List<AggregateResult> results = [SELECT Count(Id) numberOfOpportunities, AccountId
        FROM Opportunity WHERE StageName = :Label.OpportunityStageNameChange
        AND AccountId IN :accountIds GROUP BY AccountId];
    List<Account> accountList = new List<Account>();
    for (AggregateResult opp : results) {
        Account a = new Account();
        a.Id = (Id)opp.get('AccountId');
        a.OpportunityCount__c = (Decimal)opp.get('numberOfOpportunities');
        accountList.add(a);
    }
    if (!accountList.isEmpty()) {
        try { update accountList; }
        catch (DmlException e) { System.debug('Account 업데이트 오류: ' + e.getMessage()); }
    }
}
```

### Recursive Handler — 재귀 제어

**시나리오:** Flow(Customer Priority=High → Rating=Hot), Before Update(Type=Customer-Direct → Customer Priority=High), After Update(후속 Task 생성)가 서로를 재발동시켜 무한 루프 발생.

**해결:** 정적 Set으로 처리한 ID 추적.
```apex
public class AccountRecursiveCheck {
    public static Set<Id> setIds = new Set<Id>();
}

trigger AccountTrigger on Account (before update, after update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Account acc : Trigger.new) {
            if (acc.Type == 'Customer - Direct') acc.CustomerPriority__c = 'High';
        }
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Task> taskList = new List<Task>();
        for (Account acc : Trigger.new) {
            if (!AccountRecursiveCheck.setIds.contains(acc.Id)) {
                AccountRecursiveCheck.setIds.add(acc.Id);
                Task t = new Task();
                t.WhatId = acc.Id;
                t.Subject = 'Followup';
                taskList.add(t);
            }
        }
        if (!taskList.isEmpty()) insert taskList;
        AccountRecursiveCheck.setIds.clear();
    }
}
```

## 면접 질문

**1. 트리거란?** 지정된 DML 이벤트 전후 실행되는 Apex 코드.

**2. 트리거 코드란?** insert·update·delete·undelete 같은 DML 이벤트 응답으로 검증·자동화·수정 로직 구현.

**3. 유형?** Before(저장 전 검증·변경), After(저장 후 시스템 설정 필드 접근·관련 레코드 수정).

**4. 실행 순서?** 레코드 로드 → 시스템 검증 → Before 트리거 → 커스텀 검증 → 중복 규칙 → 저장(미커밋) → After 트리거 → 할당 규칙 → 자동 응답 → 워크플로우 → 레코드 업데이트(재검증) → 프로세스·Flow → 에스컬레이션 → 엔타이틀먼트 → 부모/조부모 롤업 → 기준 기반 공유 → 커밋 → 커밋 후 로직.

**5. Trigger.new vs old?** new는 삽입·업데이트될 새 레코드, old는 업데이트·삭제 전 이전 값.

**6. 벌크화 가능?** 예, 항상 다중 레코드 처리 고려. 루프 안 SOQL/DML 회피.

**7. 재귀 트리거와 방지?** 자신을 호출해 무한 루프. 정적 boolean 변수로 실행 여부 추적.

**8. Trigger.isExecuting?** 현재 컨텍스트가 트리거면 true 반환.

**9. new vs newMap?** new는 레코드 목록, newMap은 ID→레코드 맵.

**10. 트리거에서 DML?** 가능하나 거버너 한도 회피 위해 컬렉션으로 벌크 처리.

**11. 다중 실행 방지?** 정적 변수를 플래그로 사용.

**13. 벌크 안전 보장?** 루프 안 DML/SOQL 회피, 컬렉션에 수집 후 루프 밖에서 처리.

**15. 동일 오브젝트 다중 트리거 제어?** 가능하나 실행 순서 미보장. 오브젝트당 트리거 하나 + Handler 클래스 권장.

**16. 트리거 테스트?** 테스트 클래스 작성, 테스트 데이터로 DML 수행, System.assert로 검증.

**17. 트리거에서 배치 호출?** Database.executeBatch 가능하나 비권장. Queueable·Future 권장.

**21. 런타임 예외 발생 시?** 전체 트랜잭션 롤백.

**23. 한도?** 거버너 한도, 재귀 위험, 선택적 처리 어려움, 디버깅 어려움.
