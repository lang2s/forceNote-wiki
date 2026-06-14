---
tags: [scenario, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Salesforce developer Interview Questions & Answers]
---

# Salesforce 개발 Q&A 질문과 답변

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

**1. 거버너 한도와 존재 이유?** 멀티테넌트 환경에서 효율적 리소스 사용을 위한 런타임 한도. SOQL 100/트랜잭션, DML 150/트랜잭션, 힙 동기 6MB·비동기 12MB, CPU 시간 10,000ms.

**2. SOQL vs SOSL?** SOQL은 단일/관련 오브젝트에서 필드 값 기반 조회(WHERE 조건). SOSL은 여러 오브젝트 텍스트 검색.
```sql
-- SOQL
SELECT Id, Name FROM Account WHERE Name = 'Acme'
-- SOSL
FIND 'Acme' IN ALL FIELDS RETURNING Account(Id, Name)
```

**3. 벌크화와 중요성?** 한 번에 여러 레코드 처리. 거버너 한도 위반 방지, 성능·확장성.
```apex
// 잘못된 예
for(Account acc : Trigger.new){
    Account a = [SELECT Id FROM Account WHERE Id = :acc.Id]; // 루프 안 SOQL
    a.Name = 'UpdatedName';
    update a; // 루프 안 DML
}
// 올바른 예
List<Account> accList = [SELECT Id FROM Account WHERE Id IN :Trigger.newMap.keySet()];
for(Account a : accList) a.Name = 'UpdatedName';
update accList;
```

**4. Before vs After 트리거?** Before는 저장 전(필드 수정·검증, 명시적 DML 불필요), After는 저장 후(관련 레코드 접근·이메일, 명시적 DML 필요).

**5. Batch Apex 동작·사용 시점?** 대량 레코드를 청크로 비동기 처리. start(수집)·execute(처리)·finish(후처리). 대량 업데이트·정리·통합.
```apex
global class AccountBatchUpdate implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Name FROM Account');
    }
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        for(Account acc : scope) acc.Name = acc.Name + '-Updated';
        update scope;
    }
    global void finish(Database.BatchableContext BC) { System.debug('Completed'); }
}
Database.executeBatch(new AccountBatchUpdate(), 200);
```

**6. Apex 모범 사례?** 벌크화, 루프 안 SOQL/DML 회피, 컬렉션(List·Map·Set), 비동기 처리, SOQL 최적화(필요 필드만), 예외 처리(try-catch), 테스트 클래스(75%+).

**7. 외부 서비스 콜아웃?** Http·HttpRequest 클래스.
```apex
public class ExternalAPICallout {
    public static void makeCallout() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/data');
        req.setMethod('GET');
        HttpResponse res = new Http().send(req);
        System.debug(res.getBody());
    }
}
```

**8. 예외 처리?** try-catch, 오류 로깅(커스텀 오브젝트·디버그 로그), 사용자 메시지(ApexPages.Message).

**9. Apex 테스트 커버리지?** @isTest, 긍정·부정 시나리오, System.assert(), Test.startTest/stopTest.

**10. Visualforce vs Lightning?** Visualforce는 페이지 중심(HTML+Apex), 서버 측 실행, 레거시. Lightning은 컴포넌트 기반, 클라이언트 측 JS, 이벤트, 모던 앱·SPA.

**11. 트리거 재귀 방지?** static boolean 변수 또는 처리 레코드 추적 Set.
```apex
public class TriggerHelper { public static Boolean isTriggerExecuted = false; }
trigger AccountTrigger on Account (before update) {
    if(TriggerHelper.isTriggerExecuted) return;
    TriggerHelper.isTriggerExecuted = true;
}
```

**12. 트리거가 자신을 발동한 레코드 업데이트 시?** Before는 메모리 변경이라 재귀 없음, After는 재귀 발생. Trigger.oldMap으로 변경 감지·불필요 업데이트 방지.

**13. 벌크 처리 SOQL 한도 회피?** 루프 밖 SOQL, Map으로 조회 데이터.

**14. SOQL for 루프 언제?** 대용량(50,000+) 처리 시 청크로.

**15. LWC 실시간 업데이트(폴링 없이)?** Platform Events 또는 Streaming API(empApi).
```javascript
import { subscribe, unsubscribe } from 'lightning/empApi';
connectedCallback() {
    this.subscription = subscribe('/event/Order_Updated__e', -1, (event) => {
        console.log('Received event:', event);
    });
}
disconnectedCallback() { unsubscribe(this.subscription); }
```

**16. LDS 제약?** Apex에서 사용 불가, 표준/커스텀만(외부 오브젝트 불가), 복잡 쿼리(집계·조인) 불가, DML 직접 호출 불가.

**17. API rate limit 처리?** Exponential Backoff, 비동기 처리, 호출 전 한도 확인.

**18. OAuth 토큰 자동 갱신?** Refresh Token Flow.

**19. Queueable vs Future vs Batch 언제?** Future는 단순 비동기(콜아웃), Queueable은 체이닝·관련 레코드·stateful, Batch는 대량(50K+).

**20. API 재시도 멱등성?** External ID로 중복 제거, 고유 request ID 추적, External ID upsert.

**21. 트리거에서 Future 호출?** 직접 불가는 아니나(가능), 비동기에서 비동기 호출 불가. 대안: Queueable.
```apex
trigger AccountTrigger on Account (after insert) {
    System.enqueueJob(new MyQueueableJob());
}
```

**22. System Mode vs User Mode?** System Mode는 사용자 권한·FLS 무시(트리거·Batch·Scheduled). User Mode는 권한·FLS 강제(VF 컨트롤러·Lightning·Flow).

**23. 레코드 공유 설계 모범 사례?** OWD 신중히(민감=Private, 공개=Read-Only), Role Hierarchy, Sharing Rules, 수동 공유, Apex Managed Sharing, 'View All'/'Modify All' 신중히.
```apex
public class AccountSharing {
    public static void shareAccount(Id accountId, Id userId) {
        AccountShare accShare = new AccountShare();
        accShare.AccountId = accountId;
        accShare.UserOrGroupId = userId;
        accShare.AccessLevel = 'Edit';
        insert accShare;
    }
}
```

**24. Batch Apex 스케줄?** Batch 클래스 + Scheduler 클래스 + System.schedule.
```apex
global class MyBatchScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new MyBatchJob(), 200);
    }
}
System.schedule('Daily Batch Job', '0 0 12 * * ?', new MyBatchScheduler());
```

**25. LWC 라이프사이클 훅?** 컴포넌트 생애 단계별 메서드.
- **constructor()**: 생성 시(DOM 접근 X).
- **connectedCallback()**: DOM 추가 시(Apex 데이터 조회 최적).
- **renderedCallback()**: UI 렌더링 후(DOM 조작).
- **disconnectedCallback()**: DOM 제거 시(정리).
- **errorCallback(error, stack)**: 오류 발생 시(오류 처리).
