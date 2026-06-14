# Salesforce 통합 완전 가이드

외부 시스템과의 연결로 데이터 동기화·워크플로우 자동화. 다룰 내용: 통합 유형, API(REST·SOAP·Bulk·Streaming·GraphQL), 인증(OAuth·Named Credentials·Connected Apps), 미들웨어·이벤트 기반, 고급 패턴, 모범 사례·보안.

## Part 1: 통합 이해
**통합이란?** Salesforce를 외부 앱(DB·ERP·결제·CRM)과 연결해 데이터 교환.
**필요성:** 외부 DB(MySQL·PostgreSQL) 동기화, 마케팅 도구(HubSpot·Marketo) 연결, ERP(SAP) 주문 자동화, webhook·이벤트 기반 실시간 통신.
**유형:** Data Integration(데이터 동기화), Process Integration(워크플로우 자동화), Security Integration(SSO).

## Part 2: API
**SOAP API:** XML, 레거시(SAP·Oracle·은행), WSDL.
```xml
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
  <soapenv:Body>
    <create xmlns="urn:partner.soap.sforce.com">
      <sObjects><type>Account</type><Name>Test Account</Name></sObjects>
    </create>
  </soapenv:Body>
</soapenv:Envelope>
```
**Bulk API:** 대량 데이터·비동기.
```json
{"operation": "insert", "object": "Account", "records": [{"Name": "Account 1"}, {"Name": "Account 2"}]}
```
**Streaming API:** 실시간 알림, PushTopic·CDC.
```apex
PushTopic pt = new PushTopic();
pt.Name = 'AccountUpdates';
pt.Query = 'SELECT Id, Name FROM Account';
pt.ApiVersion = 57.0;
pt.NotifyForOperations = 'All';
insert pt;
```
**GraphQL API:** 단일 쿼리로 여러 오브젝트 조회.

## Part 3: 인증·권한
**Connected Apps:** 외부 앱 안전 연결. App Manager → New Connected App → OAuth 활성화·콜백 URL → 스코프 → Client ID·Secret.
**OAuth 2.0 방법:** Username-Password(비프로덕션), JWT(서버 간), Web Server(사용자 인증).
```
POST https://login.salesforce.com/services/oauth2/token
grant_type=authorization_code&client_id=...&client_secret=...&redirect_uri=...&code=...
```
**Named Credentials:** 자격 증명 하드코딩 없이 안전 콜아웃.
```apex
HttpRequest req = new HttpRequest();
req.setEndpoint('callout:MyExternalService');
req.setMethod('GET');
HttpResponse res = new Http().send(req);
```

## Part 4: 미들웨어
MuleSoft·Dell Boomi·Jitterbit로 복잡 시스템 연결. 예: Salesforce-ERP(SAP·Oracle) 동기화.

## Part 5: 고급 패턴
**Platform Events·이벤트 기반:** 실시간 통신·시스템 디커플링.
```apex
MyCustomEvent__e event = new MyCustomEvent__e(Field__c = 'Value');
EventBus.publish(event);
```
**External Objects·Salesforce Connect:** 저장 없이 외부 DB 실시간 접근(OData).

## Part 6: 모범 사례·보안
OAuth 2.0·Named Credentials, API 호출 최적화, 재시도·오류 처리, Event Monitoring·디버그 로그.
