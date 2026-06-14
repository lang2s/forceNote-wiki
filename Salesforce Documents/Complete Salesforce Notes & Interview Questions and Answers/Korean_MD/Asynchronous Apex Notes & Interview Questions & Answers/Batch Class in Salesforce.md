# Salesforce의 Batch 클래스

Batch 클래스는 일반 처리 한도 내에서 수백만 건을 처리. 처리할 레코드가 많으면 Batch 클래스 사용. 세 메서드: start, execute, finish.

## 1. Start 메서드
처리할 레코드/객체 수집.
```apex
global Database.QueryLocator start(Database.BatchableContext BC){}
```
Database.Batchable 인터페이스는 Database.BatchableContext 객체 참조 필요(배치 진행 추적).

## 2. Execute 메서드
start에서 가져온 레코드 하위 집합 처리.
```apex
global void execute(Database.BatchableContext BC, List<sObject> scope) { }
```

## 3. Finish 메서드
모든 배치 후 실행. 확인 이메일 등 후처리.
```apex
global void finish(Database.BatchableContext BC) { }
```

## 예제
```apex
global class AccountBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Name FROM Account');
    }
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        for(Account a : scope) a.Name = a.Name + 'Updated';
        update scope;
    }
    global void finish(Database.BatchableContext BC) { }
}
```

## Database.Stateful 인터페이스
트랜잭션 간 상태 유지. 예: 배치 종료 시 성공·실패 레코드를 이메일로 전송할 때.
```apex
public class MyBatchJob implements Database.Batchable<sObject>, Database.Stateful {
    public Integer summary;
    public MyBatchJob(String q){ summary = 0; }
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        for(sObject s : scope) summary++;
    }
    public void finish(Database.BatchableContext BC){ }
}
```

## Batch Apex용 스케줄러 클래스
```apex
global class AccountBatchJobscheduled implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new AccountBatch());
    }
}
```

## 스케줄 방법
1. **선언적**: Setup → Apex Classes → Schedule Apex 버튼.
2. **Developer Console**:
```apex
AccountBatchJobscheduled m = new AccountBatchJobscheduled();
String sch = '0 0 0 ? * *';
String jobID = System.schedule('Merge Job', sch, m);
```

## CRON과 CRON 표현식
CRON은 Unix 기반 시간 기반 작업 스케줄러. CRON 표현식은 공백으로 구분된 5~6개 필드로 실행 시간을 표현.

```
System.schedule(JobName, CronExpression, SchedulableClass);
```
CRON 구문: `Seconds Minutes Hours Day_of_month Month Day_of_week`
- {1} 초, {2} 분, {3} 시(24시간, 21=9pm), {4} 일(? = 특정값 없음), {5} 월(* = 매월, 1 = 1월), {6} 요일(1~7 또는 MON-FRI 또는 *).
- `L`과 `W`를 함께 쓰면 월의 마지막 평일 지정.

**예: 5분마다 실행** — 각 jobName으로 `'0 00 * * * ?'`, `'0 05 * * * ?'` ... `'0 55 * * * ?'`처럼 12개 작업 등록.

## 테스트 클래스
```apex
@isTest
public class AccountBatchTest {
    static testMethod void testMethod1() {
        List<Account> lstAccount = new List<Account>();
        for(Integer i=0; i<200; i++) lstAccount.add(new Account(Name='Name'+i));
        insert lstAccount;
        Test.startTest();
        Database.executeBatch(new AccountBatch());
        Test.stopTest();
    }
}
```

## Batch 클래스 면접 질문
Batch Apex란? Schedule Apex란? 사용처·기능? 접근 제어자? 구현 메서드? start/execute/finish 용도? Database.Batchable/QueryLocator/Iterable/BatchableContext? 동기 vs 비동기? Batch는 비동기. Stateless vs Stateful? Stateful 구현 방법? Batch 스케줄 방법? 분·시간 단위 스케줄? Batch에서 Batch 호출? Batch 안에서 Batch 스케줄? Batch에서 Future 호출? Batch와 Schedulable을 한 클래스에? Batch에서 콜아웃? 기본/최대 배치 크기? 실행 방법? 현재 작업 추적? AsyncApexJob 객체? 동시 활성 작업 수? 거버너 한도? 모범 사례? 중지/중단 방법? BatchApexWorker 레코드 타입?
