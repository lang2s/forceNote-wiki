---
tags: [apex, async, future, pattern]
source: apex-recipes/FutureMethodRecipes.cls
created: 2026-05-17
aliases: [@future, Future 메서드, 비동기 future]
---

# @future 메서드

> 현재 트랜잭션 완료 후 별도 트랜잭션에서 실행되는 가장 단순한 비동기 패턴. 파라미터는 primitive 타입 또는 primitive 컬렉션만 가능.

---

## 개념

`@future`는 현재 트랜잭션이 완료된 후 **별도의 비동기 트랜잭션**에서 실행되는 가장 단순한 비동기 패턴이다.

### 왜 존재하는가

Salesforce의 DML 트리거나 동기 트랜잭션에서는 HTTP Callout이 금지된다. 또한 Trigger 안에서 무거운 처리를 하면 트랜잭션 타임아웃 위험이 있다. `@future`는 이 두 가지 문제를 해결한다. 현재 트랜잭션을 빠르게 완료한 뒤, 무거운 처리나 외부 API 호출을 별도 컨텍스트에서 실행하도록 연기한다.

### 언제 쓰나

- Trigger 안에서 HTTP Callout을 실행해야 할 때 (`@future(callout=true)`)
- 단순한 비동기 처리가 필요한데 SObject 전달이나 체이닝이 불필요한 경우
- 구현 복잡도를 최소화하면서 빠르게 비동기 로직을 분리해야 할 때

SObject 파라미터 전달, 체이닝, 실행 상태 추적이 필요하면 `Queueable`을 사용한다.

### 주요 제한사항

- 파라미터는 primitive 타입 또는 primitive 컬렉션만 가능. SObject 직접 전달 불가.
- `@future` 안에서 다른 `@future`를 호출할 수 없다 (체이닝 불가).
- 반환값이 없다 (fire-and-forget). 실행 결과를 호출자에게 전달할 수 없다.
- `@future(callout=true)` 안에서 DML → Callout 순서는 `DmlException` 발생. Callout을 먼저 해야 한다.
- 트랜잭션당 최대 50개의 `@future` 메서드를 호출할 수 있다.

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

