---
tags: [apex, async, queueable, pattern]
source: apex-recipes/QueueableRecipes.cls, QueueableWithCalloutRecipes.cls
created: 2026-05-17
---

# Queueable

> @future 보다 강력한 비동기 처리. 객체 파라미터, 체이닝, Callout 모두 가능.

---

## 기본 패턴

```apex
public with sharing class MyQueueable implements Queueable {

    private List<Account> accounts;

    public MyQueueable(List<Account> accounts) {
        this.accounts = accounts; // 객체 전달 가능 — @future 불가능
    }

    public void execute(QueueableContext qc) {
        for (Account acct : accounts) {
            acct.Description += ' Processed';
        }
        try {
            update accounts;
        } catch (DmlException e) {
            // 에러 처리
        }
    }
}

// 실행
Id jobId = System.enqueueJob(new MyQueueable(accounts));
```

---

## HTTP Callout이 필요한 경우

```apex
// Database.AllowsCallouts 를 함께 implements
public with sharing class CalloutQueueable
        implements Queueable, Database.AllowsCallouts {

    public void execute(QueueableContext qc) {
        // Callout + DML 모두 가능
        HttpResponse response = RestClient.makeApiCall(
            'MyNamedCredential',
            RestClient.HttpVerb.GET,
            'api/data'
        );
        if (response.getStatusCode() == 200) {
            // 결과로 DML 수행
        }
    }
}
```

> [!warning] Mixed DML
> Queueable 안에서 Setup 오브젝트와 일반 오브젝트를 같은 트랜잭션에서 DML하면 Mixed DML 에러 발생.
> → 체이닝으로 분리하거나 별도 Queueable로 위임.

---

## @future vs Queueable 비교

| 항목 | @future | Queueable |
|---|---|---|
| SObject 파라미터 | ❌ (primitives만) | ✅ |
| Callout | `callout=true` 옵션 필요 | `AllowsCallouts` 함께 implements |
| 체이닝 | ❌ | ✅ (execute당 1개) |
| 모니터링 | 어려움 | AsyncApexJob으로 추적 가능 |
| 트랜잭션당 한도 | 50개 | 50개 (Governor Limit 동일) |

---

## 관련 노트

- [[비동기 컨텍스트 선택]]
- [[Queueable 체이닝]]
- [[Future 메서드]]
- [[RestClient 패턴]]
