# 비동기 Apex 완전 면접 가이드 ⚡

## 비동기 Apex란?
사용자가 완료를 기다리지 않고 백그라운드에서 작업을 실행하는 프로세스. 별도 스레드에서 실행.

> **세탁 비유:** 빨래를 세탁기에 넣고 돌리는 동안(백그라운드) 부엌에서 저녁을 요리한다. 세탁이 끝날 때까지 기다리면 비효율적이다.

주요 이점: 더 높은 거버너·실행 한도.

## 유형
- **Future**: 웹 콜아웃, Mixed DML 회피.
- **Batch**: 대량 처리, 큰 쿼리 결과(DB 유지보수).
- **Scheduled**: 특정 시간 Apex 호출(반복·1회).
- **Queueable**: 작업 의존성·체이닝·복잡 작업.

## Batch Apex

`Database.Batchable` 구현 global 클래스, start/execute/finish 구현. 기본 200건.
- **start**: 데이터 수집·배치 분할.
- **execute**: 각 배치 처리.
- **finish**: 후처리(이메일).

> 외부 오브젝트 접근 시 QueryLocator 대신 Iterable<sObject> 사용.

**호출:** `Database.executeBatch(new BatchApexExample(), 100);`
**모니터링:** Setup → Apex Jobs.
**체이닝:** API 29.0+, finish에서 체인. 최대 5개.

**Batch vs Normal Apex:** SOQL 사이클당 200건(vs 100), SOQL 5천만 건(vs 5만), 힙 12MB(vs 6MB), 오류 복원력. 각 트랜잭션이 새 거버너 한도, 한 배치 실패가 다른 성공 배치를 롤백하지 않음.

**미래 1회 스케줄:**
```apex
System.scheduleBatch(Database.Batchable batchable, String jobName, Integer minutesFromNow [, Integer batchSize]);
```

**콜아웃 시 배치 크기 계산:** 트랜잭션당 콜아웃 100. `배치 크기 = (100 / 레코드당 콜아웃 수) - 1`.

**N분마다 스케줄:** Salesforce는 분·초에 와일드카드 미지원. 코드로 self-reschedule:
```apex
global class CaseCreationonSchedular implements Schedulable {
    public void execute(SchedulableContext scon) {
        System.abortJob(scon.getTriggerId());  // 기존 작업 중단
        Decimal nextInterval = Decimal.valueOf(System.Label.nextIntervalTime);
        System.schedule('CaseCreationonBatch - ' + String.valueOf(DateTime.now()),
            '0 ' + DateTime.now().addMinutes(Integer.valueOf(nextInterval)).minute() + ' */1 ? * *', this);
        Database.executeBatch(new YourBatchClassName());
    }
}
```

**execute 실행 횟수:** 총 레코드/배치 크기(올림). 1234/200 = 7회.
**최대 배치 2000, 최소 1, 기본 200.**

**Apex Flex Queue:** 5개 한도 초과 시 대기 배치 저장(최대 100 Holding). 순서 변경: `System.FlexQueue.moveBeforeJob(jobToMoveId, jobInQueueId)`.

**QueryLocator vs Iterable:** QueryLocator는 SOQL 한도 우회(5천만), Iterable은 한도 적용(5만), 복잡 필터에 사용.

**상태:** Stateless(각 실행 별도 트랜잭션). Database.Stateful로 인스턴스 변수 상태 유지.

**Batch vs Queueable:** 배치 1개 초과면 Batch, 미만이면 Queueable.

**200건 중 1건 실패:** 해당 배치 전체 실패, 다음 배치 실행.
**Batch에서 Batch:** finish만. **execute에서:** AsyncException.
**트리거에서 Batch:** 가능하나 5개 한도 주의.
**콜아웃:** Database.AllowsCallouts.
**일일 배치 실행:** 250,000회.
**Batch에서 Future:** 불가. **Batch에서 Queueable:** execute당 1개.
**테스트:** startTest~stopTest, 삽입 ≤ 200건(1개 배치만).

**FOR UPDATE in QueryLocator:** 불가(배치가 자동 잠금).
> **색칠 비유:** "FOR UPDATE"는 "내가 칠하는 중이니 건들지 마"이지만, 배치는 이미 선생님(시스템)이 그림을 보호하므로 이중 주장 불가.

**관련 레코드 쿼리:** 서브쿼리 가능하나 느림. execute에서 별도 쿼리 권장.
> **과일 시장 비유:** 사과 하나 골라 바구니 찾기를 반복(느림) vs 사과 다 고른 후 바구니 한 번에 찾기(빠름).

**실행 순서 제어:** 불가하나 Database.Stateful로 우회.
> **케이크 비유:** 케이크를 굽기(A) 전에 프로스팅(B) 불가. Stateful 체크리스트로 "구웠는지" 기억. Stateful 없으면 각 배치가 독립적이라 진행 상태를 못 기억해 혼란.

### 예제: Contact phone을 Account phone으로 (Account-Contact 부모-자식)
```apex
global class ContactUpdate implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT id, phone, Account.phone FROM Contact');
    }
    global void execute(Database.BatchableContext bc, List<Contact> scope) {
        List<Contact> conlist = new List<Contact>();
        for(Contact con : scope) {
            con.phone = con.Account.phone;
            conlist.add(con);
        }
        update conlist;
    }
    global void finish(Database.BatchableContext bc) { }
}
// 호출
Id id = Database.executeBatch(new ContactUpdate(), 400);
System.debug('My Job id' + id);
```

**Aggregate 쿼리:** Batch에서 불가(queryMore 미지원). Iterator<AggregateResult> 또는 Iterable로 우회.
> **사탕 비유:** 표준 쿼리는 사탕을 조금씩, aggregate는 색깔별 카운트를 전부 한 번에 주려 해 배치 방식과 안 맞음.

**플랫폼 이벤트:** BatchApexErrorEvent. 오류 시 발동, Database.RaisesPlatformEvents 구현.

**execute → execute1 변경 시:** 컴파일 오류(execute 구현 필수).

**Batch에서 Future 우회:** 웹서비스가 future를 호출하도록.

**BatchableContext:** 런타임 정보(jobId) 컨텍스트 변수. AsyncApexJob 조회에 사용.

**insert vs Database.insert:** insert는 오류 시 중단(try-catch), Database.insert는 부분 성공.

**finish는 동기**(큐 안 들어감), execute만 비동기.

**콜아웃:** Database.AllowsCallouts + execute에서. start도 가능하나 한도 위험.

### Batch 시나리오
- **Iterable 반환 시 scope 상한:** 없음(높으면 다른 한도).
- 레코드 삭제·업데이트·웹서비스 콜아웃·테스트 클래스 등 다양한 예제 패턴.
- **테스트:** @isTest(코드 크기 제외), @testSetup(공통 데이터, 200건), startTest/stopTest, System.assertEquals로 검증. 최소 200건 테스트, startTest/stopTest 사이 실행.

## Future 메서드

@future, static·void. 기본 타입·기본 타입 배열·컬렉션만(객체 불가).

> **기본 값:** 불변·단순해 호출~실행 사이 변경 없음. **객체:** 변경 가능성으로 데이터 무결성 문제.

**호출:** `ClassName.clothesInLaundry();`

**시나리오:** ① 백그라운드 실행, ② Mixed DML 회피(Setup: User/Group/Profile/Layout/Email Template, Non-Setup: Account 등), ③ 트리거 콜아웃.

**제한:** Future에서 Future 호출 불가, 기본 타입만, 순서 미보장.

**sObject 우회:** ID 전달 후 쿼리.
**콜아웃:** `@future(callout=true)`.

**트리거 future + 배치 DML 충돌:** 배치가 Account 업데이트 → 트리거 발동 → future 호출 시도 → "Future method cannot be called from a future or batch method" 예외. **해결:** System.isFuture()·System.isBatch()로 컨텍스트 확인 후 future 미호출, 또는 로직 리팩토링.

**Mixed DML 오류:** 한 트랜잭션에서 Setup·Non-Setup DML 혼합 시. Future로 한 종류 분리.

**추적:** ID 미반환, MethodName·JobType로 AsyncApexJob 필터.
**테스트:** startTest~stopTest.
**한도:** 대량 부적합, 기본 타입만, 추적 어려움, Batch·future에서 호출 불가(Queueable에서 1개).
**Scheduler에서 호출:** 가능.
**Process Builder에서:** invocable 메서드로 호출.
**호출 위치:** 트리거, Apex 클래스, Schedulable.
**Wrapper 전달:** String 직렬화 후.

## Queueable Apex

**Future 대비 장점:** 비기본 타입(sObject·커스텀), Job ID 모니터링, 체이닝.

**Future를 Queueable 대신 쓸 때:** 동기·비동기 둘 다 실행되는 기능(리팩토링 용이).

- 실행 작업에서 체이닝 1개, 단일 트랜잭션 50개.
- 콜아웃: Database.AllowsCallouts.
- enqueueJob 초과 시 LimitException("Too many queueable jobs added").
- Batch에서 다수 Queueable 필요 시 스케줄링.
- 테스트: startTest~stopTest, 테스트 컨텍스트에서 enqueueJob은 null 반환, 체이닝 시 Test.isRunningTest() 체크.
- 200건 분할 불가(단일 컨텍스트).
- QueueableContext: getJobId().
- 체인 깊이 5(Dev/Trial).

```apex
public class QueueableApexExample implements Queueable {
    public void execute(QueueableContext context) { /* 처리 */ }
}
ID jobID = System.enqueueJob(new QueueableApexExample());
```

**Transaction Finalizer:** System.Finalizer로 Queueable 작업 성공·실패 후 액션. 실패 작업 최대 5회 재큐잉. ① Finalizer 구현, ② execute에서 System.attachFinalizer(작업당 1개).

## Schedulable Apex

`Schedulable` 인터페이스, execute(SchedulableContext). 스케줄 후 CronTrigger 생성.

**System.Schedule 인수:** 작업명, CRON 표현식, 클래스.
**한도:** 동시 100개, 24시간 250,000회.
**콜아웃:** 동기 미지원(@future(callout=true) 또는 배치).
**모니터링:** CronTrigger SOQL.
**반환:** Job ID(String).
**시스템 모드 실행.**
**활성 스케줄 시 클래스 수정:** UI 불가, Metadata API 가능.

### CRON 표현식
`초 분 시 일 월 요일 [연도]` (초 0-60, 분 0-60, 시 0-24, 일 1-31, 월 1-12, 요일 1-7)
- 1월 화요일 12:30: `'0 30 12 ? 1 3'`
- 9월 매일 12:30 PM: `'0 30 12 * 9 ?'`
- 9월 11일 매시 30분: `'0 30 * 11 9 ?'`

### 배치 1회 스케줄
```apex
System.scheduleBatch(batchInstance, 'Job name', minutesInterval [, batchSize]);
```
CronTrigger ID 반환, Schedulable 구현 불필요.

### Schedulable에서 Batch 호출
```apex
global class SampleBatchScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new SampleBatch('SELECT Id, Name FROM Account'), 200);
    }
}
```

**콜아웃 대안:** @future(callout=true)를 Scheduled에서 호출, 또는 Scheduled가 배치를 실행하면 배치에서 콜아웃 가능.
