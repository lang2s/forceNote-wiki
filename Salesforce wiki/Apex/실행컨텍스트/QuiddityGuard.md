---
tags: [apex, security, quiddity, context, pattern]
source: apex-recipes/QuiddityGuard.cls, RestClient.cls
created: 2026-05-17
aliases: [QuiddityGuard, Quiddity, 실행 컨텍스트 검증]
---

# QuiddityGuard — 실행 컨텍스트 검증

> `System.Quiddity`는 현재 코드가 어떤 컨텍스트에서 실행 중인지 나타내는 열거형. `QuiddityGuard`는 신뢰할 수 있는 컨텍스트인지 검사하는 유틸리티.

---

## Quiddity 주요 값

| Quiddity | 실행 컨텍스트 |
|---|---|
| `ANONYMOUS` | Developer Console / Execute Anonymous |
| `AURA` | Lightning Web Component / Aura |
| `BATCH_APEX` | Batch Apex (execute 메서드) |
| `FUTURE` | @future 메서드 |
| `INBOUND_EMAIL_SERVICE` | Email Service |
| `INVOCABLE_ACTION` | Flow, Process Builder |
| `QUEUEABLE` | Queueable |
| `REST` | REST API 호출 |
| `RUNTEST_ASYNC` | @isTest 비동기 테스트 |
| `RUNTEST_SYNC` | @isTest 동기 테스트 |
| `SCHEDULED` | Scheduled Apex |
| `SYNCHRONOUS` | 일반 동기 실행 (Trigger 등) |

---

## QuiddityGuard 구조

```apex
public class QuiddityGuard {

    // 신뢰할 수 있는 컨텍스트 목록
    public static final List<System.Quiddity> trustedQuiddities =
        new List<System.Quiddity>{
            System.Quiddity.AURA,
            System.Quiddity.REST,
            System.Quiddity.SYNCHRONOUS,
            System.Quiddity.QUEUEABLE,
            System.Quiddity.SCHEDULED,
            System.Quiddity.BATCH_APEX,
            System.Quiddity.INVOCABLE_ACTION,
            System.Quiddity.FUTURE,
            System.Quiddity.RUNTEST_SYNC,     // 테스트에서도 통과
            System.Quiddity.RUNTEST_ASYNC
        };

    // ANONYMOUS 제외 버전 — 더 엄격
    public static final List<System.Quiddity> trustedQuiditiesWithoutAnon = ...;

    @testVisible
    private static Quiddity testQuiddityOverride; // 테스트에서 덮어쓰기

    public static Boolean isAcceptableQuiddity(List<System.Quiddity> acceptableList) {
        Quiddity current = testQuiddityOverride != null
            ? testQuiddityOverride
            : Request.getCurrent().getQuiddity();
        return acceptableList.contains(current);
    }
}
```

---

## 사용 패턴

```apex
// 신뢰되지 않은 컨텍스트에서 조기 반환
public List<Account> getAccounts() {
    if (!QuiddityGuard.isAcceptableQuiddity(QuiddityGuard.trustedQuiddities)) {
        return new List<Account>(); // ANONYMOUS, 알 수 없는 컨텍스트 차단
    }
    return [SELECT Id, Name FROM Account WITH USER_MODE];
}

// 현재 Quiddity 직접 조회
System.Quiddity current = Request.getCurrent().getQuiddity();
System.debug('Running as: ' + current);
```

---

## 테스트에서 Quiddity 오버라이드

```apex
@isTest
static void testWithSpecificQuiddity() {
    // 특정 컨텍스트 시뮬레이션
    QuiddityGuard.testQuiddityOverride = System.Quiddity.ANONYMOUS;

    List<Account> result = MyService.getAccounts();
    Assert.isTrue(result.isEmpty(), 'ANONYMOUS 컨텍스트에서는 빈 결과');
}
```

---

## OrgShape와 함께 사용

```apex
// 환경 타입 + 컨텍스트 모두 확인
public Boolean canExecute() {
    Boolean trustedContext = QuiddityGuard.isAcceptableQuiddity(
        QuiddityGuard.trustedQuiddities
    );
    Boolean isSandbox = OrgShape.isSandbox();

    return trustedContext && (isSandbox || isProductionSafe);
}
```

---

## 관련 노트

- [[OrgShape]]
- [[Dynamic SOQL]] — `QuiddityGuard.isAcceptableQuiddity` 조합 예시
- [[testVisible 회로차단기]]

