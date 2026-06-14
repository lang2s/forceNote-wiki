---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [150 Asynchronous Apex Interview Questions]
---

# 비동기 Apex Q&A 질문 150선 (초급~고급, 시나리오 포함)

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

## Batch Apex 기초 (1~54)

**1. 비동기 Apex 거버너 한도?** SOQL 200, 힙 12MB, CPU 60초 등(동기보다 높음).

**2. Batch 메서드?** start(데이터 수집·배치 분할), execute(각 배치 처리), finish(후처리·이메일).

**3. Batch 호출?** `Database.executeBatch(new BatchApexExample(), 100);`

**4. Batch 모니터링?** Setup → Apex Jobs.

**5. Batch 체이닝?** 최대 5개 체이닝. finish 메서드에서 `Database.executeBatch(new AccountBatch())`.

**6. Batch 인터페이스?** Database.Batchable.

**7. Batch가 Normal Apex보다 나은 점?** SOQL 사이클당 200건(vs 100), SOQL 5천만 건 조회(vs 5만), 힙 12MB(vs 6MB).

**8. 동시 활성 배치?** 5개(나머지 큐).

**9. Data Loader 대신 Batch?** 정적·Excel 가능 작업은 Data Loader. 런타임 커스텀 계산·복잡 로직(관계 쿼리·콜아웃)은 Batch.

**10. 1234건 execute 실행 횟수?** 배치 크기에 따라. 미설정 시 1234/200 = 7회.

**11. 최대 배치 크기?** 2000. **12. 최소?** 1. **13. 기본?** 200.

**14. Apex Flex Queue?** 5개 실행/큐 한도 초과 시 대기 배치를 저장하는 큐.

**15. Flex Queue 최대?** 100개.

**16. 체이닝을 finish에서만?** execute는 여러 번 호출되어 체이닝 클래스가 여러 번 호출되므로.

**17. QueryLocator vs Iterable?** QueryLocator는 SOQL 한도 우회(5천만 건), Iterable은 한도 적용(5만 건).

**18. Batch 상태?** Stateless(각 실행이 별도 트랜잭션).

**19. Database.Stateful?** 트랜잭션 간 인스턴스 변수 값 유지(카운팅·요약).

**20. Batch vs Queueable 선택?** 배치 1개 초과면 Batch, 1개 미만이면 Queueable.

**21. Batch 콜아웃?** Database.AllowsCallouts 구현.

**22. 200건 중 1건 실패 시?** 해당 배치 200건 전체 실패, 다음 배치 실행.

**23. Batch에서 Batch?** finish에서 가능.

**24. execute에서 Batch?** 불가(AsyncException). finish만.

**25. 트리거에서 Batch?** 가능하나 매번 금지(5개 한도).

**26. start/execute/finish 실행 횟수?** start·finish 1회, execute는 배치 크기·데이터에 따라.

**27. Batch에서 Future?** 불가.

**28. Batch에서 Queueable?** 가능, execute당 enqueueJob 1회만.

**29. Batch 테스트?** Test.startTest()~stopTest() 사이, stopTest 후 비동기 동기 실행.

**30. 테스트 삽입 레코드?** 배치 크기(200) 이하(테스트는 1개 배치만 실행).

**31. Apex Flex Queue?** 100개까지 Holding 상태로 제출.

**32. Flex Queue 순서 변경?** FIFO. `System.FlexQueue.moveBeforeJob(jobToMoveId, jobInQueueId)`.

**33. Flex Queue 작업 상태?** Holding, Queued, Preparing, Processing, Aborted, Completed, Failed.

**34. 150개 배치 한 번에 큐?** Flex Queue 최대 100개(초과 시 LimitException). 미활성 시 5개.

**35. QueryLocator에서 FOR UPDATE?** 불가(배치는 잠금 내포).

**36. QueryLocator 관련 레코드 쿼리?** 서브쿼리 가능하나 느림. execute에서 별도 쿼리 권장.

**37. 1000건/200, 395번째 DML 오류?** 1번째 배치 커밋, 2번째 배치(201~400) 전체 롤백.

**38. Batch 중지?** executeBatch/scheduleBatch 반환 ID로 System.abortJob.

**40. Aggregate 쿼리?** queryMore 미지원으로 Batch에서 불가.

**41. Database.Batchable vs BatchableContext?** 전자는 인터페이스(블루프린트), 후자는 런타임 정보(jobId) 컨텍스트 변수.

**42. execute → execute1로 변경 시?** 컴파일 오류(execute 구현 필수).

**43. Batch에서 Future 호출 우회?** 웹서비스가 future를 호출하도록.

**45. start/execute/finish 외 메서드?** 불가.

**46. Batch가 global인 이유?** 관리 패키지 외부 코드에서 사용 가능하도록.

**47. insert vs Database.insert?** insert는 오류 시 전체 중단, Database.insert(list, false)는 부분 성공.

**49. finish는 비동기?** finish는 동기(큐 안 들어감), execute만 비동기.

**51. start에서 콜아웃?** 가능하나 한도 위험, execute 권장.

## Future 메서드 (55~72, 105, 121~127, 145)

**55. Future 실행?** @future, void.
```apex
@future
public static void clothesInLaundry(){ }
```

**56. 기본 값 전달 이유?** 기본 타입은 불변·단순해 호출~실행 사이 변경 없음. 객체는 변경 가능성으로 데이터 무결성 문제.

**57. 호출?** `ClassName.clothesInLaundry();`

**58. 사용 시나리오?** 백그라운드 실행, Mixed DML 회피(Setup: User/Group/Profile/Layout/Email Template, Non-Setup: Account 등), 트리거 콜아웃.

**59. 제한?** Future에서 Future 호출 불가, 기본 타입만, 순서 미보장.

**61. sObject 우회?** ID(또는 ID 컬렉션) 전달 후 쿼리.
```apex
@future
public static void processRecords(List<ID> recordIds) { /* 쿼리·처리 */ }
```

**62. Future 콜아웃?** `@future(callout=true)`.

**63. 트리거에서 Future?** 가능.

**64. try-catch 없이 예외 회피?** System.isFuture()·System.isBatch()로 컨텍스트 확인.

**65. 클래스당 Future 수?** 제한 없음(트랜잭션당 50개).

**66. Future에서 Future?** 웹서비스의 future 호출로 우회.

**66b. Mixed DML 회피?** 한 종류 DML을 Future로 분리.
```apex
public class MixedDMLFuture {
    public static void useFutureMethod() {
        insert new Account(Name='Acme');
        Util.insertUserWithRole('abc.com','Test','acb.com','Test2'); // future
    }
}
```

**67. Future 추적?** ID 미반환, MethodName·JobType로 AsyncApexJob 필터.

**70. Future가 static·void인 이유?** 동기 코드가 비동기 결과를 기다리지 않게 void, 인스턴스화 없이 접근하도록 static.

**71. 호출 가능 위치?** 트리거, Apex 클래스, Schedulable.

**72. Wrapper 전달?** String으로 직렬화 후 전달.

## Queueable Apex (73~85, 104, 107)

**73. Future 대비 장점?** 비기본 타입(sObject·커스텀), Job ID 모니터링, 체이닝.

**74. 인터페이스?** Queueable. **75. 메서드?** execute.

**76. 실행 작업에서 체이닝?** 1개(자식 1개).

**76b. 단일 트랜잭션 큐?** 50개.

**78. Queueable 콜아웃?** Database.AllowsCallouts.

**79. 제한?** 트랜잭션당 50개, 체인 깊이 5(Dev/Trial).

**80. 블루프린트?**
```apex
public class QueueableApexExample implements Queueable {
    public void execute(QueueableContext context) { /* 처리 */ }
}
```

**81. QueueableContext?** Job ID 포함 인터페이스, getJobId().

**82. 큐 등록?** `System.enqueueJob(new QueueableApexExample());`

**83. 200건 분할?** Queueable은 배치 미처리, 단일 컨텍스트에서 전체 처리.

**85. 체이닝 테스트?** 테스트에서 체이닝 불가, Test.isRunningTest() 체크.

**104. 매개변수 전달?** 생성자로.
```apex
public MyQueueableClass(String recordId, String customMessage) {
    this.recordId = recordId; this.customMessage = customMessage;
}
```

## Scheduled Apex (86~101, 120)

**86. Apex Scheduler?** 지정 시간 Apex 실행(일·주간 유지보수).

**87. 인터페이스?** Schedulable. **88. 메서드?** execute. **89. 매개변수?** SchedulableContext.

**90. 스케줄 후?** CronTrigger 객체 생성.

**91. System.Schedule 인수?** 작업명, CRON 표현식, 클래스명.

**93. 거버너 한도?** 동시 100개, 24시간 250,000회.

**93b. Scheduled에서 콜아웃?** 동기 콜아웃 미지원(@future(callout=true) 또는 배치 사용).

**94. 모니터링?** CronTrigger SOQL.

**96. 반환 타입?** Job ID(String).

**98. 활성 스케줄 작업 있으면 클래스 수정?** UI 불가, Metadata API로 가능.

**99. 시스템 모드?** Scheduler는 시스템 모드 실행.

## 시나리오 (108~150)

**108. Batch 실전:** 매일 밤 Marketo로 Opportunity 동기화(start: 24시간 변경 쿼리, execute: 콜아웃, finish: 요약 이메일).

**109. Batch vs Data Loader:** 자동화·통합·오류 처리·알림은 Batch.

**110. Batch vs Queueable:** 대량 데이터·높은 한도는 Batch.

**111. Queueable 실전:** ShipStation 실시간 주문 동기화(트리거→Queueable 콜아웃). Batch는 스케줄 간격이라 부적합, Future는 체이닝·상태 미지원.

**114. Batch 거버너 한도:** Flex Queue 100, 동시 5, 배치당 5만 건, 최대 배치 2000(기본 200), 콜아웃 100/트랜잭션, 실행 60초.

**121. Future 50개 초과?** 예외.

**122. Future에서 Batch?** 불가. **123. Future에서 Queueable?** 가능(1개).

**131/135/148. Mixed DML 회피:** Non-Setup 동기 + Setup을 Future로.
```apex
@future
public static void deactivateUserAsync(Id userId) {
    User user = [SELECT Id, IsActive FROM User WHERE Id = :userId];
    user.IsActive = false;
    update user;
}
```

**139/147. Queueable 순차 체이닝:**
```apex
public class ValidateDataJob implements Queueable {
    public void execute(QueueableContext context) {
        // 검증 로직
        System.enqueueJob(new CalculateScoreJob());
    }
}
public class CalculateScoreJob implements Queueable {
    public void execute(QueueableContext context) {
        System.enqueueJob(new SendNotificationJob());
    }
}
public class SendNotificationJob implements Queueable {
    public void execute(QueueableContext context) { /* 알림 */ }
}
```

**140. Batch finish → Queueable 집계:**
```apex
public void finish(Database.BatchableContext bc) {
    System.enqueueJob(new AggregationJob(processedRecordIds));
}
```

**141. Batch 체이닝(Orders → Payments):** finish에서 `Database.executeBatch(new PaymentBatchJob(), 200);`

**142. Future → Queueable:**
```apex
public class MyFutureClass {
    @future
    public static void myFutureMethod(Set<Id> recordIds) {
        System.enqueueJob(new MyQueueableJob(recordIds));
    }
}
```

**143/150. Scheduled → Queueable/Batch:**
```apex
public class NightlyJobScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        System.enqueueJob(new NightlyDataRefreshJob());
    }
}
String cronExp = '0 0 0 * * ?'; // 매일 자정
System.schedule('Nightly Data Refresh', cronExp, new NightlyJobScheduler());
```

**146. Scheduled + Batch 주간 정리:**
```apex
public class DataCleanupScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new DataCleanupBatchJob(), 200);
    }
}
```

**149. 실시간 동기화(트리거 → Queueable 콜아웃):**
```apex
trigger ContactTrigger on Contact (after insert, after update) {
    for (Contact con : Trigger.new) System.enqueueJob(new SyncContactWithExternalSystem(con.Id));
}
public class SyncContactWithExternalSystem implements Queueable, Database.AllowsCallouts {
    private Id contactId;
    public SyncContactWithExternalSystem(Id contactId) { this.contactId = contactId; }
    public void execute(QueueableContext context) {
        Contact con = [SELECT Id, Name, Email FROM Contact WHERE Id = :contactId];
        // 외부 시스템 콜아웃
    }
}
```

> 핵심 선택 가이드: 대량 데이터=Batch, 실시간·체이닝·복합 타입=Queueable, 트리거 콜아웃·Mixed DML 회피=Future, 주기 작업=Scheduled.
