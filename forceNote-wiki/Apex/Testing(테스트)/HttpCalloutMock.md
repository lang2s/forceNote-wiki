---
tags: [apex, testing, mock, http, callout, pattern]
source: apex-recipes/ApiServiceRecipesTest.cls, RestClientTest.cls
created: 2026-05-17
aliases: [HttpCalloutMock, HTTP 모킹, Callout 테스트]
---

# HttpCalloutMock — HTTP 호출 모킹

> `@isTest` 컨텍스트에서 실제 HTTP 호출 없이 `HttpResponse`를 반환하는 Mock 구현. `Test.setMock(HttpCalloutMock.class, mockInstance)`으로 등록. SOAP(wsdl2apex) 콜아웃은 [[WebServiceMock]]으로 모킹한다.

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

## 정적 리소스 기반 목 (구현 없이)

`HttpCalloutMock`을 직접 구현하는 대신, 응답 본문을 **정적 리소스(Static Resource)** 에 저장해두고 Apex 내장 목 클래스로 재생하는 방법. 코드로 응답 본문을 하드코딩하지 않으므로, 응답 페이로드가 크거나 자주 바뀔 때 Setup에서 리소스만 교체하면 된다.

준비: 응답 본문을 담은 텍스트 파일 → Setup ▸ Static Resources ▸ New 로 정적 리소스 등록. `Content-Type`을 지정하면 파일 내용이 그 타입과 일치해야 한다(예: `application/json`이면 파일이 JSON 문자열이어야 함).

### StaticResourceCalloutMock — 단일 응답

내장 클래스. 하나의 정적 리소스를 응답 본문으로 사용한다. 인터페이스 구현 불필요.

| 메서드 | 설명 |
|---|---|
| `setStaticResource(String resourceName)` | 응답 본문으로 사용할 정적 리소스 이름 지정 |
| `setStatusCode(Integer code)` | 응답 상태 코드 설정 |
| `setHeader(String key, String value)` | 응답 헤더 설정 |

```apex
public class CalloutStaticClass {
    public static HttpResponse getInfoFromExternalService(String endpoint) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        Http h = new Http();
        return h.send(req);
    }
}

@isTest
private class CalloutStaticClassTest {
    @isTest static void testCalloutWithStaticResources() {
        // 정적 리소스 'mockResponse' 내용: {"hah":"fooled you"}
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');

        // 목 콜아웃 모드 설정
        Test.setMock(HttpCalloutMock.class, mock);

        HttpResponse res = CalloutStaticClass.getInfoFromExternalService(
            'https://example.com/example/test');

        // 정적 리소스의 내용이 응답 본문으로 반환됨
        System.assertEquals('{"hah":"fooled you"}', res.getBody());
        System.assertEquals(200, res.getStatusCode());
        System.assertEquals('application/json', res.getHeader('Content-Type'));
    }
}
```

### MultiStaticResourceCalloutMock — 엔드포인트별 응답

`StaticResourceCalloutMock`과 유사하나 **엔드포인트마다 다른 응답 본문**을 지정할 수 있다. `setStaticResource`가 `(endpoint, resourceName)` 두 인자를 받는다.

| 메서드 | 설명 |
|---|---|
| `setStaticResource(String endpoint, String resourceName)` | 특정 엔드포인트에 매핑할 정적 리소스 지정 (반복 호출로 여러 엔드포인트 등록) |
| `setStatusCode(Integer code)` | 응답 상태 코드 설정 |
| `setHeader(String key, String value)` | 응답 헤더 설정 |

```apex
@isTest
private class CalloutMultiStaticClassTest {
    @isTest static void testCalloutWithMultipleStaticResources() {
        // mockResponse : {"hah":"fooled you"}
        // mockResponse2: {"hah":"fooled you twice"}
        MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
        multimock.setStaticResource(
            'https://example.com/example/test', 'mockResponse');
        multimock.setStaticResource(
            'https://example.com/example/sfdc', 'mockResponse2');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');

        Test.setMock(HttpCalloutMock.class, multimock);

        // 첫 번째 엔드포인트
        HttpResponse res = CalloutMultiStaticClass.getInfoFromExternalService(
            'https://example.com/example/test');
        System.assertEquals('{"hah":"fooled you"}', res.getBody());

        // 두 번째 엔드포인트 — 다른 응답
        HttpResponse res2 = CalloutMultiStaticClass.getInfoFromExternalService(
            'https://example.com/example/sfdc');
        System.assertEquals('{"hah":"fooled you twice"}', res2.getBody());
    }
}
```

> `Test.setMock(HttpCalloutMock.class, mock)` 등록 방식은 직접 구현한 목과 동일하다 — 두 내장 클래스 모두 첫 인자로 `HttpCalloutMock.class`를 넘긴다. 관리형 패키지 코드의 콜아웃을 목킹하려면 같은 네임스페이스의 테스트 메서드에서 `Test.setMock`을 호출한다.

### 직접 구현 vs 정적 리소스 목

| 기준 | HttpCalloutMock 직접 구현 | Static Resource 목 |
|---|---|---|
| 응답 본문 위치 | Apex 코드 내 문자열 | Setup의 정적 리소스 파일 |
| 인터페이스 구현 | `respond()` 필요 | 불필요 (내장 클래스) |
| 요청 분기 로직 | `respond()`에서 자유롭게 (헤더·바디 조건 등) | 엔드포인트 단위만 (Multi) |
| 요청 캡처·검증 | 가능 (목 내부에서 `req` 캡처) | 불가 |
| 응답 교체 | 코드 수정·재배포 | 리소스 파일만 교체 |
| 적합 상황 | 동적 응답, 요청 검증, 에러 시나리오 | 크거나 자주 바뀌는 고정 페이로드 |

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

- [[WebServiceMock]] — SOAP(wsdl2apex) 콜아웃 모킹 (HTTP가 아닌 경우)
- [[RestClient 패턴]]
- [[Http·HttpRequest·HttpResponse 레퍼런스]] — 목이 다루는 HttpRequest·HttpResponse 메서드 전수 레퍼런스
- [[StubProvider]]
- [[테스트 전략]]
- [[platform-apex-test-generate]] (sf-skill — 실행형) — 콜아웃 목 포함 Apex 테스트 생성 실행형 스킬

