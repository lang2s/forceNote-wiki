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

## 레퍼런스

### System.RestContext

모든 Apex REST 메서드에서 기본으로 사용 가능한 정적 컨텍스트. 현재 요청/응답 객체를 정적 프로퍼티로 노출한다.

| 정적 프로퍼티 | 타입 | 의미 |
|---|---|---|
| `RestContext.request` | `System.RestRequest` | 현재 인바운드 요청 객체 |
| `RestContext.response` | `System.RestResponse` | 현재 아웃바운드 응답 객체 |

```apex
RestRequest  req = RestContext.request;
RestResponse res = RestContext.response;
```

### System.RestRequest 멤버

| 멤버 | 타입 | get/set | 의미 |
|---|---|---|---|
| `headers` | `Map<String, String>` | get | 요청에 담겨 온 HTTP 헤더 맵 |
| `httpMethod` | `String` | get | 요청의 HTTP 메서드 — `DELETE`·`GET`·`HEAD`·`PATCH`·`POST`·`PUT` 중 하나 |
| `params` | `Map<String, String>` | get | 쿼리스트링 파라미터 맵 (`?q=...&limit=...`) |
| `remoteAddress` | `String` | get | 요청 클라이언트의 IP 주소 |
| `requestBody` | `Blob` | get/set | 요청 본문. **Apex 메서드에 파라미터가 없을 때만** 채워진다 (파라미터가 있으면 본문은 파라미터로 역직렬화됨) |
| `requestURI` | `String` | get/set | HTTP 요청 문자열에서 호스트 이후 전체 (예: `/services/apexrest/integration-service/001...`) |
| `resourcePath` | `String` | get | base services 엔드포인트를 포함한 REST 리소스 경로 |

메서드 (주로 테스트에서 요청을 조립할 때 사용 — 실제 런타임에는 플랫폼이 자동 채움):

| 메서드 | 시그니처 | 반환 | 의미 |
|---|---|---|---|
| `addHeader` | `addHeader(String name, String value)` | `void` | 테스트에서 요청 헤더 맵에 헤더 추가. 제한 헤더(`cookie`·`set-cookie`·`set-cookie2`·`content-length`·`authorization`)는 추가 불가 |
| `addParameter` | `addParameter(String name, String value)` | `void` | 테스트에서 요청 `params` 맵에 파라미터 추가 |

> [!note] requestBody vs 파라미터
> `requestBody`(Blob)는 메서드가 파라미터를 선언하지 않았을 때 원문 본문을 받는다. 파라미터를 선언하면 본문 JSON/XML이 파라미터명 기준으로 역직렬화되어 바인딩되고 `requestBody`는 비게 된다.

### System.RestResponse 멤버

| 멤버 | 타입 | get/set | 의미 |
|---|---|---|---|
| `responseBody` | `Blob` | get/set | 응답 본문. 메서드가 `void`면 이 프로퍼티가 응답을 채운다. 반환값이 있으면 그 값이 직렬화되어 응답이 된다 |
| `headers` | `Map<String, String>` | get | 응답 헤더 맵. 프로퍼티 자체는 read-only지만 맵 내용은 읽기·쓰기 가능 |
| `statusCode` | `Integer` | get/set | 응답 HTTP 상태 코드. 유효 코드(200·201·202·204·400·401·403·404·500 등). 유효하지 않은 코드를 넣으면 HTTP 500 + 에러 메시지 반환 |

| 메서드 | 시그니처 | 반환 | 의미 |
|---|---|---|---|
| `addHeader` | `addHeader(String name, String value)` | `void` | 응답 헤더 추가. 제한 헤더(`cookie`·`set-cookie`·`content-length`·`authorization`)나 RFC 7230 비준수 헤더명은 예외 발생 |

```apex
RestResponse res = RestContext.response;
res.addHeader('Content-Type', 'application/json');
res.statusCode = 200;
res.responseBody = Blob.valueOf(JSON.serialize(records));   // 메서드가 void일 때
```

### URL 매핑·와일드카드 규칙

- `@RestResource(urlMapping='/pattern/*')` — `/services/apexrest/` 뒤에 붙는 경로. 대소문자를 구분한다.
- **`urlPattern`과 `urlPattern/*`은 동일하게 동작**한다. 두 클래스가 겹치는 매핑을 가지면 **먼저 저장된 클래스가 우선**한다.
- 와일드카드(`*`) 뒤 경로 조각은 `RestRequest.requestURI`에서 직접 파싱한다 (경로 파라미터 자동 바인딩은 없음 — 쿼리스트링만 `params`로 자동 채움).

### 파라미터 자동 바인딩·지원 타입

- **쿼리스트링 파라미터**는 `RestContext.request.params`(Map<String,String>)로 자동 노출된다.
- **요청 본문**은 메서드 파라미터가 있으면 파라미터명 기준으로 역직렬화되어 바인딩된다 (**순서 무관, 이름 일치가 중요**).
- 지원 타입(파라미터·반환): Apex 프리미티브(단, sObject·Blob 제외)·sObject·List/Map(**String 키 맵만**)·이들로 구성된 사용자 정의 타입.
- **`@HttpGet`·`@HttpDelete` 메서드는 파라미터를 가질 수 없다** (본문이 없어 역직렬화 대상이 없음).
- XML은 `List<List<String>>` 같은 중첩 컬렉션을 지원하지 않음(JSON은 가능). 미지원 타입은 요청 시 HTTP 415, 응답 시 HTTP 406.

### HTTP verb 애노테이션·`@ReadOnly`

| 애노테이션 | HTTP verb | 파라미터 |
|---|---|---|
| `@HttpGet` | GET | 불가 |
| `@HttpDelete` | DELETE | 불가 |
| `@HttpPost` | POST | 가능 |
| `@HttpPut` | PUT | 가능 |
| `@HttpPatch` | PATCH | 가능 |

- **한 `@RestResource` 클래스에 같은 HTTP verb 애노테이션 메서드는 하나만** 둘 수 있다.
- `@ReadOnly` — 위 5개 애노테이션 전부와 함께 사용 가능. 쿼리 로우 한도를 완화(정렬되지 않은 최대 100만 행)하지만 DML을 금지한다.

> [!note] 출처
> Salesforce Apex Reference Guide — [RestContext / RestRequest](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_restrequest.htm) · [RestResponse](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_restresponse.htm) · Apex Developer Guide — [Apex REST Methods](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_rest_methods.htm) (Tier 2, 웹 검증 2026-07-07)

---

## 관련 노트

- [[RestClient 패턴]] — 외부로 HTTP 호출
- [[Named Credential]]
- [[StripInaccessible]] — POST 바디 처리 시 필수
- [[CanTheUser]] — 삭제 권한 체크
- [[SOAP Web Services 노출 (webservice 키워드)]] — 짝꿍 인바운드 표면 (REST vs SOAP)
