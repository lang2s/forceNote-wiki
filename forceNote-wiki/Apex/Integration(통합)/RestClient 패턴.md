---
tags: [apex, integration, http, pattern, named-credential]
source: apex-recipes/RestClient.cls, ApiServiceRecipes.cls
created: 2026-05-17
aliases: [RestClient, HTTP 호출 추상화]
---

# RestClient 패턴

> Named Credential 기반 HTTP 호출을 추상화하는 `virtual class RestClient`. 상속으로 API별 서비스 클래스를 만든다.

---

## RestClient 구조

```apex
public virtual class RestClient {

    // Named Credential 이름 (callout:{name}/path 형식으로 사용)
    @testVisible
    protected String namedCredentialName { get; set; }

    // HTTP 메서드 열거형 — DEL은 Apex 예약어 DELETE 충돌 우회
    public enum HttpVerb { GET, POST, PATCH, PUT, HEAD, DEL }

    // 핵심 메서드 — 모든 HTTP 호출이 여기를 통과
    protected HttpResponse makeApiCall(HttpVerb method, String path,
                                       String query, String body,
                                       Map<String, String> headers) {
        path = ensureStringEndsInSlash(path);

        // PATCH → POST + ?_HttpMethod=PATCH (Salesforce PATCH 제한 우회)
        if (method == HttpVerb.PATCH) {
            method = HttpVerb.POST;
            query  = '?_HttpMethod=PATCH';
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + namedCredentialName + '/' + path + query);
        req.setMethod(method == HttpVerb.DEL ? 'DELETE' : method.name());
        // 헤더, 바디 설정...
        return new Http().send(req);
    }

    // 편의 메서드 (syntactic sugar)
    protected HttpResponse get(String path)                { return makeApiCall(HttpVerb.GET, path, '', '', null); }
    protected HttpResponse post(String path, String body)  { return makeApiCall(HttpVerb.POST, path, '', body, null); }
    protected HttpResponse patch(String path, String body) { return makeApiCall(HttpVerb.PATCH, path, '', body, null); }
    protected HttpResponse del(String path)                { return makeApiCall(HttpVerb.DEL, path, '', '', null); }

    // 정적 래퍼 — 상속 없이 일회성 사용
    public static HttpResponse makeApiCall(String namedCredential,
                                           HttpVerb method, String path) { ... }
}
```

---

## 서비스 클래스 구현 (상속)

```apex
public with sharing class BookApiService extends RestClient {

    public BookApiService() {
        namedCredentialName = 'GoogleBooksAPI'; // ← Named Credential 이름만 설정
    }

    public List<BookModel> searchBooks(String keyword) {
        HttpResponse response = get('volumes?q=' + EncodingUtil.urlEncode(keyword, 'UTF-8'));

        switch on response.getStatusCode() {
            when 200 { return BookModel.parse(response.getBody()); }
            when 404 { throw new BookNotFoundException('검색 결과 없음'); }
            when else { throw new ApiException('예상치 못한 응답: ' + response.getStatusCode()); }
        }
    }
}
```

---

## Named Credential 엔드포인트 형식

```
callout:{NC_DeveloperName}/{path}?{query}

예시:
callout:GoogleBooksAPI/volumes?q=salesforce
callout:MyRestApi/api/v1/accounts/
```

> [!note] PATCH 우회 이유
> Salesforce HTTP 클라이언트는 PATCH를 직접 지원하지 않는 경우가 있어, `POST + ?_HttpMethod=PATCH`로 우회한다. RestClient에 이 로직이 내장되어 있으므로 서비스 클래스에서는 신경 쓸 필요 없음.

---

## 테스트 (HttpCalloutMock)

```apex
// Mock 구현
@isTest
public class BookApiMock implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"items": [{"volumeInfo": {"title": "Salesforce Book"}}]}');
        return res;
    }
}

// 테스트에서 Mock 등록
@isTest
static void searchBooks_returnsResults() {
    Test.setMock(HttpCalloutMock.class, new BookApiMock());
    Test.startTest();
    List<BookModel> books = new BookApiService().searchBooks('salesforce');
    Test.stopTest();
    Assert.isFalse(books.isEmpty());
}
```

---

## 관련 노트

- [[Named Credential]]
- [[HttpCalloutMock]]
- [[Custom REST Endpoint]]
- [[Queueable]] — Callout + DML 조합 시
