---
tags: [apex, async, future, pattern]
source: apex-recipes/FutureMethodRecipes.cls
created: 2026-05-17
aliases: [@future, Future 메서드, 비동기 future]
---

# @future 메서드

> 현재 트랜잭션 완료 후 별도 트랜잭션에서 실행되는 가장 단순한 비동기 패턴. 파라미터는 primitive 타입 또는 primitive 컬렉션만 가능.

---

## 기본 패턴

```apex
// 기본 future 메서드
@future
public static void doSomethingAsync(String param1, Integer param2) {
    // 별도 트랜잭션 — 호출자의 컨텍스트와 무관
    Account acct = [SELECT Id, Name FROM Account WHERE Id = :param1];
    acct.Description = 'Updated asynchronously';
    update acct;
}

// 호출
MyClass.doSomethingAsync(accountId, 42);
// 리턴값 없음 — fire-and-forget
```

---

## HTTP Callout 허용

```apex
// callout=true로 외부 HTTP 호출 가능
@future(callout=true)
public static void syncWithExternalSystem(String recordId) {
    Account acct = [SELECT Id, Name FROM Account WHERE Id = :recordId];
    Http h = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint('callout:MyAPI/sync');
    req.setMethod('POST');
    req.setBody(JSON.serialize(acct));
    HttpResponse res = h.send(req);
    // 응답 처리...
}
```

> [!warning] callout과 DML 순서
> @future(callout=true) 내에서 DML → Callout 순서는 DmlException 발생. 반드시 **Callout 먼저, DML 나중**에 해야 함.

---

## 파라미터 제약

```apex
// ✅ primitive 타입 가능
@future public static void method(String s, Integer i, Boolean b) {}

// ✅ primitive 컬렉션 가능
@future public static void method(List<Id> ids, Set<String> names) {}

// ❌ SObject 직접 전달 불가 → Id로 전달 후 내부 쿼리
@future public static void method(Account acct) {} // 컴파일 에러

// ✅ SObject → JSON 직렬화로 우회 (비권장, Queueable 사용 권장)
@future public static void method(String accountJson) {
    Account acct = (Account) JSON.deserialize(accountJson, Account.class);
}
```

---

## @future vs Queueable 선택

| 기준 | @future | Queueable |
|---|---|---|
| SObject 파라미터 | ❌ (Id만) | ✅ |
| 체이닝 | ❌ | ✅ |
| 진행 상태 모니터링 | ❌ | ✅ (AsyncApexJob) |
| 구현 복잡도 | 단순 | 중간 |
| 권장 사용 | 단순 비동기 + callout | 복잡한 비동기 |

---

## Governor Limits

| 항목 | 제한 |
|---|---|
| 동기 트랜잭션에서 @future 호출 | 50번 |
| 큐에 대기 가능한 @future | 50 (Org 기준) |
| @future 내 callout | 100회 |

---

## 테스트

```apex
@isTest
static void testFutureMethod() {
    Account acct = new Account(Name = 'Test');
    insert acct;

    Test.startTest();
    MyClass.doSomethingAsync(acct.Id, 42);
    Test.stopTest(); // ← 이 시점에 @future 동기 실행

    Account updated = [SELECT Description FROM Account WHERE Id = :acct.Id];
    Assert.areEqual('Updated asynchronously', updated.Description);
}
```

---

## 관련 노트

- [[비동기 컨텍스트 선택]]
- [[Queueable]]
- [[RestClient 패턴]] — callout=true 패턴

