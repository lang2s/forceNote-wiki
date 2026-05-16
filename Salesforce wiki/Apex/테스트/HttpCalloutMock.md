---
tags: [apex, testing, mock, http, callout, pattern]
source: apex-recipes/ApiServiceRecipesTest.cls, RestClientTest.cls
created: 2026-05-17
aliases: [HttpCalloutMock, HTTP 모킹, Callout 테스트]
---

# HttpCalloutMock — HTTP 호출 모킹

> `@isTest` 컨텍스트에서 실제 HTTP 호출 없이 `HttpResponse`를 반환하는 Mock 구현. `Test.setMock(HttpCalloutMock.class, mockInstance)`으로 등록.

---

## 기본 구현

```apex
@isTest
public class SuccessCalloutMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"items": [{"id": "1", "name": "Test"}]}');
        return res;
    }
}
```

---

## 다중 엔드포인트 Mock (요청 URL 분기)

```apex
@isTest
public class MultiEndpointMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        String endpoint = req.getEndpoint();

        if (endpoint.contains('/accounts')) {
            res.setStatusCode(200);
            res.setBody('[{"id": "001", "name": "Test Account"}]');
        } else if (endpoint.contains('/contacts')) {
            res.setStatusCode(200);
            res.setBody('[{"id": "003", "name": "Test Contact"}]');
        } else {
            res.setStatusCode(404);
            res.setBody('Not Found');
        }
        return res;
    }
}
```

---

## 에러 응답 Mock

```apex
@isTest
public class ErrorCalloutMock implements HttpCalloutMock {
    private Integer statusCode;
    private String body;

    public ErrorCalloutMock(Integer statusCode, String body) {
        this.statusCode = statusCode;
        this.body       = body;
    }

    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(this.statusCode);
        res.setBody(this.body);
        return res;
    }
}

// 사용
Test.setMock(HttpCalloutMock.class, new ErrorCalloutMock(500, '{"error":"Server Error"}'));
```

---

## 테스트에서 등록

```apex
@isTest
static void searchBooks_returns200() {
    // Mock 등록 — Test.startTest() 전에 해야 함
    Test.setMock(HttpCalloutMock.class, new SuccessCalloutMock());

    Test.startTest();
    List<BookModel> books = new BookApiService().searchBooks('salesforce');
    Test.stopTest();

    Assert.isFalse(books.isEmpty());
}

@isTest
static void searchBooks_handles404() {
    Test.setMock(HttpCalloutMock.class, new ErrorCalloutMock(404, '{}'));

    Test.startTest();
    try {
        new BookApiService().searchBooks('notexist');
        Assert.fail('404는 예외를 던져야 함');
    } catch (BookApiService.BookNotFoundException e) {
        Assert.isNotNull(e);
    }
    Test.stopTest();
}
```

---

## Mock 요청 검증 (요청 내용 확인)

```apex
@isTest
public class ValidatingMock implements HttpCalloutMock {
    public HttpRequest capturedRequest; // 요청 캡처

    public HttpResponse respond(HttpRequest req) {
        this.capturedRequest = req;

        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{}');
        return res;
    }
}

// 테스트
@isTest
static void verifyRequestFormat() {
    ValidatingMock mock = new ValidatingMock();
    Test.setMock(HttpCalloutMock.class, mock);

    Test.startTest();
    new BookApiService().searchBooks('salesforce');
    Test.stopTest();

    Assert.isTrue(mock.capturedRequest.getEndpoint().contains('salesforce'));
    Assert.areEqual('GET', mock.capturedRequest.getMethod());
}
```

---

## StubProvider vs HttpCalloutMock

| 기준 | StubProvider | HttpCalloutMock |
|---|---|---|
| 대상 | Apex 클래스 메서드 | HTTP 외부 호출 |
| 등록 방법 | `Test.createStub()` | `Test.setMock()` |
| 검증 | `hasBeenCalledXTimes` | Mock 내부 캡처 |
| 제약 | static/final 불가 | — |

---

## 관련 노트

- [[RestClient 패턴]]
- [[StubProvider]]
- [[테스트 전략]]

