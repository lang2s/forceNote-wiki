---
tags: [apex, testing, testVisible, circuit-breaker, pattern]
source: apex-recipes/TestVisible.cls
created: 2026-05-17
aliases: [@testVisible, 회로차단기, 테스트 격리 패턴]
---

# @testVisible 회로차단기

> `@testVisible`로 표시된 private 필드를 테스트에서 직접 조작해 예외 경로나 특정 컨텍스트를 시뮬레이션하는 패턴. `StubProvider`로 모킹할 수 없는 static 메서드/시스템 클래스 의존성을 우회할 때 사용.

---

## 패턴 1: Boolean 회로차단기

```apex
// 프로덕션 코드
public class DataService {

    @testVisible
    private static Boolean throwError = false; // 테스트에서 조작 가능

    public List<Account> getAccounts() {
        if (throwError) {
            throw new DataServiceException('Test-injected error');
        }
        return [SELECT Id, Name FROM Account WITH USER_MODE];
    }
}

// 테스트
@isTest
static void getAccounts_throwsOnError() {
    DataService.throwError = true; // @testVisible 이므로 접근 가능
    try {
        new DataService().getAccounts();
        Assert.fail('예외가 발생해야 함');
    } catch (DataService.DataServiceException e) {
        Assert.isTrue(e.getMessage().contains('Test-injected'));
    }
}
```

---

## 패턴 2: Exception 회로차단기

```apex
// 프로덕션 코드
public class EmailService {

    @testVisible
    private static Exception circuitBreaker; // null이면 정상 동작

    public void sendEmail(String to, String subject, String body) {
        if (circuitBreaker != null) {
            throw circuitBreaker;
        }
        // 실제 이메일 발송...
        Messaging.sendEmail(...);
    }
}

// 테스트 — 특정 예외 타입 주입
@isTest
static void sendEmail_handlesEmailException() {
    EmailService.circuitBreaker =
        new EmailException('Simulated email failure');

    try {
        new EmailService().sendEmail('test@test.com', 'Test', 'Body');
        Assert.fail();
    } catch (EmailException e) {
        Assert.areEqual('Simulated email failure', e.getMessage());
    }
}
```

---

## 패턴 3: @testVisible 의존성 주입

```apex
// 프로덕션 코드
public class BookController {

    @testVisible
    private BookApiService apiService;

    public BookController() {
        apiService = new BookApiService(); // 기본값
    }

    public BookController(BookApiService service) {
        apiService = service; // 생성자 주입 (테스트용)
    }

    public List<BookModel> getBooks(String keyword) {
        return apiService.searchBooks(keyword);
    }
}

// 테스트 — StubProvider로 주입
@isTest
static void getBooks_usesApiService() {
    TestDouble.Method m =
        new TestDouble.Method('searchBooks').returning(new List<BookModel>());
    TestDouble stub = new TestDouble(BookApiService.class);
    stub.track(m);

    BookController ctrl = new BookController((BookApiService) stub.generate());
    ctrl.getBooks('sf');

    Assert.areEqual(1, m.hasBeenCalledXTimes);
}
```

---

## 적용 가이드

| 상황 | 패턴 |
|---|---|
| 예외 경로 테스트 | Boolean 회로차단기 (`throwError`) |
| 특정 예외 타입 테스트 | Exception 회로차단기 (`circuitBreaker`) |
| 외부 서비스 의존성 | StubProvider + 생성자 주입 |
| Quiddity 오버라이드 | `QuiddityGuard.testQuiddityOverride` |
| static 메서드 | Boolean/Exception 회로차단기 (StubProvider 사용 불가) |

---

## StubProvider 불가 대상 → 회로차단기 사용

> [!warning] StubProvider 제약
> - `static` 메서드 → @testVisible Boolean/Exception
> - `final` 클래스 → @testVisible Boolean/Exception
> - Salesforce 시스템 클래스 → 래퍼 클래스 + StubProvider

---

## 관련 노트

- [[StubProvider]]
- [[테스트 전략]]
- [[QuiddityGuard]] — `testQuiddityOverride` 예시

