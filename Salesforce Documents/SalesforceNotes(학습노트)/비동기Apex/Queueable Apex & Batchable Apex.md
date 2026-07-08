---
tags: [apex, async, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Queueable Apex and Batchable Apex]
---

# Queueable Apex & Batchable Apex

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

둘 다 비동기(백그라운드) 처리에 사용되나 시나리오와 장점이 다르다.

## 1. Queueable Apex
즉시 실행이 필요 없고 시간이 걸릴 수 있는 비동기 코드 실행. @future의 향상판으로 더 많은 제어·유연성 제공.

**핵심 기능:**

작업 체이닝(한 작업이 다른 작업 큐잉), 복잡한 입력 타입(객체 전달), Batch보다 단순, UI에서 진행 모니터링, 큐 작업 수 무제한이나 동시 실행/큐는 50개.

```apex
public class MyQueueableJob implements Queueable {
    public void execute(QueueableContext context) {
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE AnnualRevenue > 1000000];
        for(Account acc : accounts) acc.Description = 'High revenue account';
        update accounts;
    }
}
ID jobId = System.enqueueJob(new MyQueueableJob());
```

**사용 시점:**

배치 복잡도가 불필요한 비동기 처리, 체이닝 필요, 복합 타입(sObject·커스텀) 전달 시.
**장점:**

체이닝(최대 50개), 유연성(List<sObject>·커스텀 타입 전달), 단순성.

## 2. Batchable Apex
대량 데이터(5천만 건 이상)를 비동기 처리. 작업을 작은 청크(배치)로 나눠 거버너 한도 준수.

**핵심 기능:**

대량 데이터를 배치로 분할, 거버너 한도 회피, 특정 시간 스케줄 가능.

```apex
public class MyBatchClass implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Name FROM Account WHERE AnnualRevenue > 1000000');
    }
    public void execute(Database.BatchableContext BC, List<Account> scope) {
        for(Account acc : scope) acc.Description = 'High revenue account';
        update scope;
    }
    public void finish(Database.BatchableContext BC) {
        System.debug('Batch processing completed.');
    }
}
Database.executeBatch(new MyBatchClass(), 100);
```

**사용 시점:**

대량 데이터셋(수백만 건), 거버너 한도 없이 대량 처리, 주기적 스케줄, 시스템 한도 복원력(실패 배치 자동 재시도).
**장점:**

효율(200건 청크), 확장성(수백만 건), 후처리(finish).

## 어느 것을 쓸까?
- **Queueable**: 작은 데이터셋, 체이닝 필요, 복합 타입 전달.
- **Batchable**: 대량 데이터셋, 거버너 한도 없이 효율 실행, 수백만 건 확장.

## 비교

| 기능 | Queueable | Batchable |
|---|---|---|
| 주 용도 | 작은 데이터셋 비동기·체이닝 | 대량(수백만 건) 처리 |
| 레코드 처리 | 배치로 나누지 않음(비동기로 한도 회피) | 배치로 분할해 한도 회피 |
| 체이닝 | 지원(최대 50) | 미지원(natively) |
| 복합 데이터 전달 | 지원 | 단순 타입·SOQL만 |
| 작업 모니터링 | UI로 진행 모니터링 | UI로 각 배치 모니터링·로그 |
| 스케줄링 | 직접 불가(Scheduled Apex로 호출) | Scheduled Apex로 주기 실행 |
| 트랜잭션 크기 | 단일 트랜잭션 | 배치마다 별도 트랜잭션 |
