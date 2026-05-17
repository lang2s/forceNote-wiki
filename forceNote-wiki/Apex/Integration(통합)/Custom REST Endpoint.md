---
tags: [apex, integration, rest, endpoint, pattern]
source: apex-recipes/CustomRestEndpointRecipes.cls
created: 2026-05-17
aliases: [@RestResource, REST API 엔드포인트]
---

# Custom REST Endpoint

> `@RestResource`로 Salesforce를 REST 서버로 만드는 패턴.
> URL: `/services/apexrest/{urlmapping}`

---

## 표준 패턴

```apex
@RestResource(urlmapping='/integration-service/*')
global inherited sharing class CustomRestEndpointRecipes {

    @HttpGet
    global static String getRecords() {
        RestResponse response = RestContext.response;
        try {
            List<Account> accounts = [SELECT Id, Name FROM Account WITH USER_MODE];
            response.statusCode = 200;
            return JSON.serialize(accounts);
        } catch (QueryException qe) {
            response.statusCode = 400;
            return qe.getMessage();
        }
    }

    @HttpPost
    global static String createContacts() {
        String requestBody = RestContext.request.requestBody.toString();

        // 역직렬화 후 반드시 stripInaccessible
        List<Contact> contacts =
            (List<Contact>) JSON.deserialize(requestBody, List<Contact>.class);
        SObjectAccessDecision decision =
            Security.stripInaccessible(AccessType.CREATABLE, contacts);

        try {
            insert as user decision.getRecords();
            response.statusCode = 201;
            return 'Created';
        } catch (DmlException e) {
            response.statusCode = 500;
            return e.getMessage();
        }
    }

    @HttpDelete
    global static String deleteRecord() {
        RestRequest request   = RestContext.request;
        RestResponse response = RestContext.response;

        // URL에서 Id 파싱: /services/apexrest/integration-service/{id}
        String recordId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/') + 1
        );

        if (!CanTheUser.destroy(new Contact())) {
            response.statusCode = 403;
            return 'Permission denied';
        }

        // ... 삭제 로직 ...
    }
}
```

---

## 핵심 규칙

| 항목 | 규칙 |
|---|---|
| 클래스 접근자 | 반드시 `global` |
| Sharing 키워드 | `inherited sharing` 권장 (with sharing도 가능) |
| 메서드 접근자 | 반드시 `global static` |
| HTTP 메서드 | `@HttpGet`, `@HttpPost`, `@HttpPut`, `@HttpPatch`, `@HttpDelete` |
| 요청 접근 | `RestContext.request` |
| 응답 접근 | `RestContext.response` (statusCode 명시 필수) |

---

## URL 파라미터 파싱

```apex
// URL: /services/apexrest/integration-service/001xxxxxxxxxxxx
String recordId = RestContext.request.requestURI.substring(
    RestContext.request.requestURI.lastIndexOf('/') + 1
);

// URL 파라미터 (쿼리스트링)
String keyword = RestContext.request.params.get('q');
```

---

## 에러 응답 패턴

```apex
RestResponse response = RestContext.response;
try {
    // 로직
    response.statusCode = 200;
    return successResult;
} catch (QueryException qe) {
    response.statusCode = 400; // Bad Request
    return qe.getMessage();
} catch (DmlException de) {
    response.statusCode = 500; // Internal Server Error
    return de.getMessage();
} catch (Exception e) {
    response.statusCode = 500;
    return 'Unexpected error: ' + e.getMessage();
}
```

> [!warning] statusCode 기본값
> `RestContext.response.statusCode`를 설정하지 않으면 기본값 200이 반환된다. 에러 시 반드시 명시적으로 4xx/5xx를 설정할 것.

---

## 관련 노트

- [[RestClient 패턴]] — 외부로 HTTP 호출
- [[Named Credential]]
- [[StripInaccessible]] — POST 바디 처리 시 필수
- [[CanTheUser]] — 삭제 권한 체크
