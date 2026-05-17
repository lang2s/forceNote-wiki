---
tags: [apex, integration, queueable, callout, async, pattern]
source: apex-recipes/QueueableWithCalloutRecipes.cls
created: 2026-05-17
aliases: [Queueable Callout, 비동기 외부 호출, AllowsCallouts]
---

# Queueable + Callout 패턴

> 외부 API 호출(Callout)과 DML을 한 트랜잭션에서 조합해야 할 때 사용하는 패턴.
> `@future(callout=true)`와 달리 SObject 파라미터, 체이닝, AsyncApexJob 모니터링이 가능.

---

## 언제 사용하나

| 상황 | 선택 |
|---|---|
| 단순 fire-and-forget, primitives만 전달 | `@future(callout=true)` |
| SObject 전달 또는 결과로 DML 필요 | **Queueable + AllowsCallouts** |
| Callout → DML → 다음 Callout 연속 | **Queueable 체이닝** |
| 대용량 레코드 일괄 처리 | Batch + `Database.AllowsCallouts` |

---

## 기본 구조

```apex
// Database.AllowsCallouts 를 함께 implements — 없으면 CalloutException 발생
public with sharing class SyncAccountsQueueable
        implements Queueable, Database.AllowsCallouts {

    private List<Account> accounts;

    public SyncAccountsQueueable(List<Account> accounts) {
        this.accounts = accounts; // SObject 직접 전달 가능
    }

    public void execute(QueueableContext qc) {
        for (Account acct : accounts) {

            // 1) 외부 API 호출
            HttpResponse response = RestClient.makeApiCall(
                'ExternalCRM',                 // Named Credential 이름
                RestClient.HttpVerb.POST,
                'api/accounts/' + acct.Id
            );

            // 2) 응답 처리 후 DML
            if (response.getStatusCode() == 200) {
                acct.Sync_Status__c = 'Synced';
                acct.Last_Sync__c   = DateTime.now();
            } else {
                acct.Sync_Status__c = 'Error';
            }
        }

        update accounts; // DML은 Callout 이후
    }
}

// 실행
System.enqueueJob(new SyncAccountsQueueable(accounts));
```

> [!warning] Callout → DML 순서 엄수
> 같은 execute() 내에서 DML 이후 Callout 시도 시 `System.CalloutException: You have uncommitted work pending` 발생.
> 반드시 **Callout 먼저, DML 나중**.

---

## 체이닝 패턴 (Callout → Callout)

```apex
public with sharing class FetchThenSaveQueueable
        implements Queueable, Database.AllowsCallouts {

    private List<Id> recordIds;
    private Boolean isFetchStep;

    public FetchThenSaveQueueable(List<Id> ids, Boolean isFetchStep) {
        this.recordIds   = ids;
        this.isFetchStep = isFetchStep;
    }

    public void execute(QueueableContext qc) {
        if (isFetchStep) {
            // Step 1: 외부에서 데이터 조회
            HttpResponse res = RestClient.makeApiCall(
                'ExternalAPI', RestClient.HttpVerb.GET, 'data'
            );
            List<Id> nextIds = parseIds(res.getBody());

            // Step 2 큐에 등록 (execute당 체이닝 1회 제한)
            if (!Test.isRunningTest()) {
                System.enqueueJob(new FetchThenSaveQueueable(nextIds, false));
            }
        } else {
            // Step 2: 조회 결과로 DML
            List<Account> toUpdate = [SELECT Id FROM Account WHERE Id IN :recordIds];
            for (Account a : toUpdate) {
                a.Synced__c = true;
            }
            update toUpdate;
        }
    }
}
```

> [!note] 체이닝 제한
> `execute()` 내에서 `System.enqueueJob()` 호출은 **1회만** 허용.
> 테스트 컨텍스트에서는 체이닝이 실행되지 않으므로 `Test.isRunningTest()` 가드 필수.

---

## 트리거에서 Queueable 실행

```apex
trigger AccountTrigger on Account (after insert) {
    // Trigger → Queueable → Callout 패턴
    // Trigger 안에서 직접 Callout 불가 → Queueable 위임 필수
    if (Trigger.isAfter && Trigger.isInsert) {
        System.enqueueJob(
            new SyncAccountsQueueable(Trigger.new)
        );
    }
}
```

> [!warning] Trigger에서 직접 Callout 불가
> Trigger는 이미 DML 트랜잭션 중이므로 직접 HTTP Callout 불가.
> 반드시 `@future(callout=true)` 또는 Queueable + AllowsCallouts로 위임.

---

## 테스트

```apex
@isTest
static void testSyncQueueable() {
    // 테스트 데이터
    List<Account> accounts = new List<Account>{
        new Account(Name = 'Test Account')
    };
    insert accounts;

    // Mock 등록 — Queueable 내 Callout을 가로챔
    Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

    Test.startTest();
    System.enqueueJob(new SyncAccountsQueueable(accounts));
    Test.stopTest(); // ← stopTest()에서 Queueable 동기 실행

    Account updated = [SELECT Sync_Status__c FROM Account WHERE Id = :accounts[0].Id];
    Assert.areEqual('Synced', updated.Sync_Status__c);
}
```

---

## Governor Limits

| 항목 | 제한 |
|---|---|
| 트랜잭션당 `System.enqueueJob()` 호출 | 50회 |
| execute당 체이닝 enqueueJob | 1회 |
| Queueable 내 Callout 횟수 | 100회 |
| 동시 Queueable 잡 (Org) | 250개 |

---

## 관련 노트

- [[RestClient 패턴]] — Callout 추상화
- [[Named Credential]] — 엔드포인트 설정
- [[HttpCalloutMock]] — Callout 테스트
- [[Future 메서드]] — 단순한 비동기 Callout 대안
- [[Queueable 체이닝]] — 복잡한 체이닝 패턴
