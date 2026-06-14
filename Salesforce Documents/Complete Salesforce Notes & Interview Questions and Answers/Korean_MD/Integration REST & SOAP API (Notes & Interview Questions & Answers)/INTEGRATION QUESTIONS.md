# 통합 질문

**SSO?** 단일 자격 증명으로 여러 앱 접근. SAML Federated Authentication, Delegated Authentication, OpenID Connect.

**Identity Provider (IdP)?** 사용자명·비밀번호 검증·인증 시스템. 다른 앱이 IdP를 신뢰.

**Service Provider (SP)?** 앱(서비스) 제공 주체. 예: Google 자격 증명으로 Salesforce 로그인 시 Salesforce=SP, Google=IdP.

**Salesforce 통합?** 둘 이상 애플리케이션 연결.

**통합 방향?** Inbound(외부가 Salesforce에 접촉), Outbound(Salesforce가 외부에 접촉).

**Inbound vs Outbound 웹 서비스?**
- **Inbound:** Salesforce가 SOAP/REST 노출, 외부가 소비. Salesforce=발행자.
- **Outbound:** Salesforce가 외부 웹 서비스 소비. 외부=발행자.

## Salesforce API와 사용 시점
- **REST API:** RESTful 원칙 경량. CRUD·검색·메타데이터. XML·JSON. 모바일·웹 앱.
- **SOAP API:** WSDL 계약. XML만. 서버 간 통합.
- **Bulk API:** 5만 건 이상 비동기 로딩·쿼리. 1.0/2.0. 초기 데이터 로딩.
- **Pub/Sub API:** 실시간 이벤트 통합. publish-subscribe. 폴링 불필요. gRPC·HTTP/2·Avro·11개 언어.
- **Apex REST API:** Apex 클래스를 REST로 노출. OAuth 2.0·Session ID.
- **Apex SOAP API:** Apex 메서드를 SOAP으로 노출.
- **Tooling API:** 커스텀 개발 도구. 메타데이터 SOQL. SOAP·REST.
- **GraphQL API:** 필요 데이터만 단일 요청. 필드 선택·집계·스키마 인트로스펙션.

## Connected App
SAML·OAuth·OpenID Connect로 외부 앱 통합·인증·SSO 프레임워크.

**시나리오 1(마케팅 자동화 통합):** App Manager → New Connected App → OAuth 활성화·Callback URL·스코프(api·refresh_token) → 저장 → Consumer Key·Secret → Profiles에서 허용 사용자 → 외부 도구에 OAuth 2.0 구현·토큰 획득·API 요청.
**시나리오 2(외부 IdP):** Connected App을 SAML·OpenID Connect로 구성.
**시나리오 3(SSO):** Connected App을 OAuth 2.0로 Google Workspace SSO.

## OAuth 용어
- **OAuth:** 자격 증명 노출 없이 안전한 인증·권한 부여 표준.
- **Client Application:** 사용자 대신 리소스 접근 앱.
- **Resource Owner:** 보호 리소스 소유자(Salesforce 사용자).
- **Authorization Server:** Salesforce Identity & Access Management.
- **Access Token:** 단기 자격 증명.
- **Refresh Token:** 장기, 만료 시 새 토큰 획득.
- **Authorization Code:** Web Server 플로우에서 토큰 교환용.
- **Consumer Key:** client_id.
- **Scopes:** 요청 권한.
- **Redirect URI (Callback URL):** 인증 후 리디렉션 URL.
- **JWT:** 당사자 간 claim 전달(JWT Bearer 플로우).
- **User-Agent Flow:** SPA·모바일(토큰 직접 반환).
- **Username-Password Flow:** 자격 증명 직접 교환(비권장).

## OAuth 1.0 vs 2.0
2.0은 비브라우저 앱 지원 향상, 서명 불필요(TLS/SSL), 역할 분리, 단기 액세스 토큰 + 리프레시 토큰(보안 향상).

## REST API Callout 코드
**GET(데이터 조회):**
```apex
Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
request.setMethod('GET');
HttpResponse response = http.send(request);
if(response.getStatusCode() == 200) {
    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    List<Object> animals = (List<Object>) results.get('animals');
    for(Object animal : animals) System.debug(animal);
}
```
**POST(데이터 전송):**
```apex
HttpRequest request = new HttpRequest();
request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
request.setMethod('POST');
request.setHeader('Content-Type', 'application/json;charset=UTF-8');
request.setBody('{"name":"mighty moose"}');
HttpResponse response = new Http().send(request);
if(response.getStatusCode() != 201) System.debug('Unexpected: ' + response.getStatusCode());
else System.debug(response.getBody());
```

## HttpCalloutMock 테스트
콜아웃은 테스트 컨텍스트에서 실행 안 됨 → Mock 응답 사용.
```apex
@isTest
global class AnimalsHttpCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animals": ["majestic badger", "fluffy bunny", "scary bear"]}');
        response.setStatusCode(200);
        return response;
    }
}
// 테스트: Test.setMock(HttpCalloutMock.class, new AnimalsHttpCalloutMock());
```
StaticResourceCalloutMock으로 정적 리소스 기반 응답도 가능.

## 커스텀 REST API
RestContext로 RestRequest·RestResponse 접근.
```apex
@RestResource(urlMapping='/api/Account/*')
global with sharing class MyFirstRestAPIClass {
    @HttpGet
    global static Account doGet() {
        RestRequest req = RestContext.request;
        String AccNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        return [SELECT Id, Name, Phone, Website FROM Account WHERE AccountNumber = :AccNumber];
    }
    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        String AccNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        delete [SELECT Id FROM Account WHERE AccountNumber = :AccNumber];
    }
    @HttpPost
    global static String doPost(String name, String phone, String AccountNumber) {
        Account acc = new Account(name=name, phone=phone, AccountNumber=AccountNumber);
        insert acc;
        return acc.id;
    }
}
```

**테스트:**
```apex
@IsTest
private class MyFirstRestAPIClassTest {
    static testMethod void testGetMethod(){
        Account acc = new Account(Name='Test', AccountNumber='12345');
        insert acc;
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/api/Account/12345';
        request.httpMethod = 'GET';
        RestContext.request = request;
        Account acct = MyFirstRestAPIClass.doGet();
        System.assertEquals('Test', acct.Name);
    }
}
```

**Workbench에서 실행:** Utilities > REST Explorer → Method=Get, URL=`/services/apexrest/api/Account/12345`.
