---
tags: [apex, integration, callout, http, reference]
source: salesforce_apex_reference_guide.pdf (System — Http·HttpRequest·HttpResponse Class) + salesforce_apex_developer_guide.pdf (Callout Limits and Limitations)
created: 2026-07-05
aliases: [Http Class, HttpRequest, HttpResponse, setTimeout, 콜아웃 타임아웃, Http.send, HTTP 콜아웃, CalloutException]
---

# Http·HttpRequest·HttpResponse 레퍼런스

> Apex HTTP 콜아웃 3종 표준 클래스(System 네임스페이스) 전수 레퍼런스 — 타임아웃은 **밀리초 단위**로 `setTimeout(Integer)`에 지정하며, **기본 10초(10,000ms)·요청당 1~120,000ms 범위·트랜잭션 누적 최대 120초**다.

---

## 핵심 답변 — 콜아웃 타임아웃

| 항목 | 값 | 근거 |
|---|---|---|
| 단위 | **밀리초(ms)** — `setTimeout(Integer timeout)` | Apex Reference Guide, HttpRequest.setTimeout |
| 기본값 | **10초 (= 10,000ms)** | Apex Developer Guide, Callout Limits |
| 요청당 설정 범위 | **최소 1ms ~ 최대 120,000ms (120초)** | 양쪽 가이드 동일 |
| 트랜잭션 누적 상한 | **120초** — 트랜잭션 내 모든 콜아웃 시간의 합산(additive) | Apex Developer Guide, Callout Limits |
| 타임아웃의 의미 | HTTP **연결 수립 + 요청 시작 대기**까지의 최대 시간. 요청이 실행 중(데이터 송수신)이면 완료까지 연결 유지 | Apex Reference Guide, setTimeout |

```apex
HttpRequest req = new HttpRequest();
req.setTimeout(2000); // timeout in milliseconds
```

> PDF 원문: *"Sets a timeout for the request between 1 and 120,000 milliseconds. The timeout is the maximum time to wait for establishing the HTTP connection. The same timeout is used for waiting for the request to start. When the request is executing, such as retrieving or posting data, the connection is kept alive until the request finishes."*

WSDL2Apex(SOAP) 스텁은 `setTimeout`이 아니라 스텁의 `timeout_x` 변수(역시 ms)로 지정한다.

```apex
docSample.DocSamplePort stub = new docSample.DocSamplePort();
stub.timeout_x = 2000; // timeout in milliseconds
```

---

## Http Class

HTTP 요청/응답을 개시하는 클래스. 네임스페이스: `System`. 메서드 2개 — 모두 인스턴스 메서드.

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `send(request)` | `public HttpResponse send(HttpRequest request)` | HttpRequest를 전송하고 응답 반환 |
| `toString()` | `public String toString()` | 객체 프로퍼티를 표시·식별하는 문자열 반환 |

---

## HttpRequest Class

GET·POST·PATCH·PUT·DELETE 같은 HTTP 요청을 프로그램적으로 생성. 네임스페이스: `System`. 요청 본문의 XML/JSON 파싱에는 XML 클래스([[Dom Namespace]])·JSON 클래스를 사용한다.

### 생성자

| 생성자 | 시그니처 |
|---|---|
| `HttpRequest()` | `public HttpRequest()` — 새 인스턴스 생성 |

### 메서드 전수 (18개, 모두 인스턴스 메서드)

| 메서드 | 시그니처 | 설명·제한 |
|---|---|---|
| `getBody()` | `public String getBody()` | 요청 본문 조회 |
| `getBodyAsBlob()` | `public Blob getBodyAsBlob()` | 요청 본문을 Blob으로 조회 |
| `getBodyDocument()` | `public Dom.Document getBodyDocument()` | 요청 본문을 DOM document로 조회 (`new Dom.Document(getBody())` 단축) |
| `getCompressed()` | `public Boolean getCompressed()` | 본문 압축 여부 |
| `getEndpoint()` | `public String getEndpoint()` | 외부 서버 엔드포인트 URL 조회 |
| `getHeader(key)` | `public String getHeader(String key)` | 요청 헤더 내용 조회 |
| `getMethod()` | `public String getMethod()` | 메서드 타입 반환 — 반환 예: `DELETE`·`GET`·`HEAD`·`PATCH`·`POST`·`PUT`·`TRACE` |
| `setBody(body)` | `public Void setBody(String body)` | 본문 설정. **제한: 동기 Apex 6MB / 비동기 Apex 12MB** — 요청·응답 크기는 힙 크기에 합산 |
| `setBodyAsBlob(body)` | `public Void setBodyAsBlob(Blob body)` | 본문을 Blob으로 설정. 제한 동일(6MB/12MB, 힙 합산) |
| `setBodyDocument(document)` | `public Void setBodyDocument(Dom.Document document)` | 본문을 DOM document로 설정. 제한 6MB/12MB |
| `setClientCertificate(clientCert, password)` | `public Void setClientCertificate(String clientCert, String password)` | **Deprecated** — `setClientCertificateName` 사용. (구: PKCS12 키스토어+비밀번호 설정) |
| `setClientCertificateName(certDevName)` | `public Void setClientCertificateName(String certDevName)` | 외부 서비스가 클라이언트 인증서(양방향 인증)를 요구할 때 인증서의 Unique Name 지정 |
| `setCompressed(flag)` | `public Void setCompressed(Boolean flag)` | `true`면 본문을 **gzip** 압축 형식으로 전달 |
| `setEndpoint(endpoint)` | `public Void setEndpoint(String endpoint)` | 엔드포인트 지정 — 아래 "엔드포인트 값" 참조 |
| `setHeader(key, value)` | `public Void setHeader(String key, String value)` | 요청 헤더 설정. **제한 100KB** |
| `setMethod(method)` | `public Void setMethod(String method)` | HTTP 메서드 설정 — 가능 값: `DELETE`·`GET`·`HEAD`·`PATCH`·`POST`·`PUT`·`TRACE`. 필요한 옵션 설정에도 사용 가능 |
| `setTimeout(timeout)` | `public Void setTimeout(Integer timeout)` | **1~120,000ms** 타임아웃 설정 (상단 "핵심 답변" 참조) |
| `toString()` | `public String toString()` | 엔드포인트 URL·메서드 문자열 반환 — 예: `Endpoint=http://YourServer, Method=POST` |

### 엔드포인트 값 (setEndpoint)

| 형태 | 예 |
|---|---|
| 엔드포인트 URL | `https://my_endpoint.example.com/some_path` |
| Named Credential URL | `callout:My_Named_Credential/some_path` — `callout:` 스킴 + Named Credential 이름 + (선택) 경로 |

> Named Credential을 엔드포인트로 지정하면 인증을 Salesforce가 전부 관리하므로 코드에서 인증을 처리할 필요가 없다. 설정·유형 상세는 [[Named Credential]] 참조.

### 예제 — Basic Auth 헤더 콜아웃 (Reference Guide 원문 발췌)

```apex
public with sharing class AuthCallout {
  public void basicAuthCallout(){
    HttpRequest req = new HttpRequest();
    req.setEndpoint('http://www.yahoo.com');
    req.setMethod('GET');

    // Specify the required user name and password to access the endpoint
    // As well as the header and header information
    String username = 'myname';
    String password = 'mypwd';

    Blob headerValue = Blob.valueOf(username + ':' + password);
    String authorizationHeader = 'Basic ' +
      EncodingUtil.base64Encode(headerValue);
    req.setHeader('Authorization', authorizationHeader);

    // Create a new http object to send the request object
    // A response object is generated as a result of the request
    Http http = new Http();
    HTTPResponse res = http.send(req);
    System.debug(res.getBody());
  }
}
```

### 압축 (setCompressed)

```apex
HttpRequest req = new HttpRequest();
req.setEndPoint('my_endpoint');
req.setCompressed(true);
req.setBody('some post body');
```

응답이 압축 형식으로 오면 `HttpResponse.getBody()`가 형식을 인식해 **자동으로 압축 해제한** 값을 반환한다.

### 클라이언트 인증서 (setClientCertificateName)

Salesforce에서 인증서 생성 → 그 **Unique Name**을 인자로 지정 (양방향 인증 콜아웃 지원).

```apex
HttpRequest req = new HttpRequest();
req.setClientCertificateName('DocSampleCert');
```

---

## HttpResponse Class

`Http.send()`가 반환한 HTTP 응답을 처리. 네임스페이스: `System`. 응답 본문의 XML/JSON 파싱에는 XML 클래스·JSON 클래스 사용.

### 메서드 전수 (14개, 모두 인스턴스 메서드)

| 메서드 | 시그니처 | 설명·제한 |
|---|---|---|
| `getBody()` | `public String getBody()` | 응답 본문 조회. **제한: 동기 6MB / 비동기 12MB** — 요청·응답 크기는 힙 크기에 합산 |
| `getBodyAsBlob()` | `public Blob getBodyAsBlob()` | 응답 본문을 Blob으로 조회. 제한 동일 |
| `getBodyDocument()` | `public Dom.Document getBodyDocument()` | 응답 본문을 DOM document로 조회 (`new Dom.Document(getBody())` 단축) |
| `getHeader(key)` | `public String getHeader(String key)` | 응답 헤더 내용 조회 |
| `getHeaderKeys()` | `public String[] getHeaderKeys()` | 응답 헤더 키 배열 조회 |
| `getStatus()` | `public String getStatus()` | 상태 메시지 조회 |
| `getStatusCode()` | `public Integer getStatusCode()` | 상태 코드 값 조회 |
| `getXmlStreamReader()` | `public XmlStreamReader getXmlStreamReader()` | 응답 본문을 파싱하는 `System.XmlStreamReader` 반환 (`new XmlStreamReader(getBody())` 단축) |
| `setBody(body)` | `public Void setBody(String body)` | 응답 본문 지정 |
| `setBodyAsBlob(body)` | `public Void setBodyAsBlob(Blob body)` | 응답 본문을 Blob으로 지정 |
| `setHeader(key, value)` | `public Void setHeader(String key, String value)` | 응답 헤더 지정 |
| `setStatus(status)` | `public Void setStatus(String status)` | 상태 메시지 지정 |
| `setStatusCode(statusCode)` | `public Void setStatusCode(Integer statusCode)` | 상태 코드 지정 |
| `toString()` | `public String toString()` | 상태 메시지+코드 반환 — 예: `Status=OK, StatusCode=200` |

> `set*` 메서드들은 주로 테스트에서 가짜 응답을 구성할 때 쓴다 — 목 구현은 [[HttpCalloutMock]] 참조.

### 예제 — 콜아웃 응답 XML 스트림 파싱 (Reference Guide 원문 발췌)

```apex
public with sharing class ReaderFromCalloutSample {
  public void getAndParse() {
    // Get the XML document from the endpoint
    Http http = new Http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint(URL.getOrgDomainUrl().toExternalForm() + '/services/data');
    req.setMethod('GET');
    req.setHeader('Accept', 'application/xml');
    HttpResponse res = http.send(req);

    // Log the XML content
    System.debug(res.getBody());

    // Generate the HTTP response as an XML stream
    XmlStreamReader reader = res.getXmlStreamReader();

    // Read through the XML
    while(reader.hasNext()) {
      System.debug('Event Type:' + reader.getEventType());
      if (reader.getEventType() == XmlTag.START_ELEMENT) {
        System.debug(reader.getLocalName());
      }
      reader.next();
    }
  }
}
```

---

## 콜아웃 제한 전체 (Developer Guide — Callout Limits and Limitations)

HTTP 요청·웹서비스 호출(SOAP API 포함) 공통 제한. 수치 요약표는 [[Governor Limits]] 참조 — 아래는 콜아웃 관점 전수.

| 제한 | 값 |
|---|---|
| 트랜잭션당 콜아웃 최대 횟수 | **100회** (HTTP 요청 또는 API 호출) |
| Developer Edition 동시 콜아웃 | org 도메인 **외부** 엔드포인트로 최대 **20개 동시** — 비 Developer Edition org에는 미적용 |
| 기본 타임아웃 | **10초** (콜아웃별 커스텀 설정 가능: 최소 1ms ~ 최대 120,000ms) |
| 누적 타임아웃 | 트랜잭션당 **120초** — 트랜잭션이 호출한 모든 콜아웃에 대해 합산 |
| 요청/응답 최대 크기 | 동기 6MB / 비동기 12MB (힙 크기에 합산) |
| 장기 실행 요청(5초 초과) 카운트 | **콜아웃 처리 시간은 제외** — 콜아웃 동안 타이머를 멈췄다가 완료 시 재개 |
| 대기 중 작업(pending operations) | 같은 트랜잭션에 DML·비동기 Apex(future·batch)·scheduled Apex·이메일 발송이 대기 중이면 콜아웃 불가 — 이런 작업 **이전에는** 콜아웃 가능 |
| `Expect: 100-Continue` 헤더 | 외부 서버가 `HTTP/1.1 100 Continue`를 반환하지 않으면 타임아웃 발생 |

> 목(mock) 콜아웃 앞에서는 같은 트랜잭션의 pending operation이 허용된다 — [[HttpCalloutMock]] 참조.

---

## CalloutException 케이스

`Http.send()` 실패(연결 불가·타임아웃 등)와 콜아웃 규칙 위반 시 `System.CalloutException`이 발생한다.

### 1. Uncommitted work pending — DML 후 콜아웃

```apex
Savepoint sp = Database.setSavepoint();
insert new Account(name='Foo');
Database.releaseSavepoint(sp);
try {
    makeACallout();
} catch (System.CalloutException ex) {
    Assert.isTrue(ex.getMessage().contains('You have uncommitted work pending. Please commit
or rollback before calling out.'));
}
```

콜아웃 전에 트랜잭션을 커밋(종료)하거나 롤백해야 한다.

### 2. Active savepoint 미해제 — 세이브포인트 후 콜아웃

```apex
Savepoint sp = Database.setSavepoint();
try {
    makeACallout();
} catch (System.CalloutException ex) {
    Assert.isTrue(ex.getMessage().contains('All active Savepoints must be released before
making callouts.'));
}
```

해결 — 미커밋 DML을 롤백한 뒤 `Database.releaseSavepoint()`로 세이브포인트를 명시 해제하고 콜아웃:

```apex
Savepoint sp = Database.setSavepoint();
try {
    // Try a database operation
    insert new Account(name='Foo');
    integer bang = 1 / 0;
} catch (Exception ex) {
    Database.rollback(sp);
    Database.releaseSavepoint(sp);
    makeACallout();
}
```

**버전별 동작:** API 60.0 이전에는 미커밋 DML 여부·롤백 여부와 무관하게 세이브포인트 생성 후 콜아웃이 무조건 CalloutException을 던졌다. API 60.0+ 테스트에서는 `Test.startTest()`/`Test.stopTest()` 호출 시 모든 세이브포인트가 해제된다.

### 3. 런타임 실패 — try-catch 처리 패턴 (Developer Guide ApexDoc 예제 발췌)

```apex
HttpRequest req = new HttpRequest();
req.setEndpoint(namedCredentialUrl + requestParams);
req.setMethod('GET');
req.setTimeout(60000);

Http http = new Http();
HttpResponse res;
try {
    res = http.send(req);
} catch (System.CalloutException e) {
    throw new WeatherServiceException(
        'HTTP Callout Failed: ' + e.getMessage()
    );
}
if (res.getStatusCode() == 200) {
    return res.getBody();
}
```

### Read-Only 모드 주의

읽기 전용 모드(사이트 스위칭·인스턴스 리프레시 등) 중에도 콜아웃 자체는 차단되지 않고 실행된다. 그러나 응답 후 이어지는 쓰기(DML)가 차단되어 프로그램 흐름이 깨질 수 있으므로, `System.getApplicationReadWriteMode()`가 `ApplicationReadWriteMode.READ_ONLY`면 콜아웃을 건너뛰는 방어를 권장한다.

---

## 테스트

콜아웃은 테스트에서 직접 실행할 수 없고 `Test.setMock` + `HttpCalloutMock.respond(HttpRequest) : HttpResponse` 구현으로 가짜 응답을 반환한다 — 전체 패턴은 [[HttpCalloutMock]] 참조 (본 노트 범위 밖).

---

## 관련 노트

- [[Governor Limits]] — 콜아웃 타임아웃·크기 제한 수치 요약표
- [[HttpCalloutMock]] — 콜아웃 테스트 목 패턴
- [[Named Credential]] — `callout:` 엔드포인트 인증 관리
- [[RestClient 패턴]] — HTTP 콜아웃 래퍼 유틸리티 패턴
- [[Custom REST Endpoint]] — 반대 방향(Apex를 REST로 노출)
- [[Dom Namespace]] — getBodyDocument()가 반환하는 Dom.Document
