---
tags: [integration, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [SOAP API Implementation Guide SF]
---

# Salesforce SOAP API 구현

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

구조화·신뢰성·레거시 통합(엄격한 계약 정의 필요)에 SOAP API, 경량·모바일은 REST.

## SOAP API란?
XML over HTTP/HTTPS 프로토콜. CRUD, 메타데이터 배포·조회, 레거시 통합.
**특징:** XML 전용, 계약 기반(WSDL), 엄격 표준, 트랜잭션 무결성.

## WSDL
웹 서비스를 기술하는 XML 문서(message·port type·binding). 메서드·입출력·데이터 타입·엔드포인트 정의.
- **Enterprise WSDL:** 특정 org 전용, 커스텀 오브젝트·필드 포함, 강타입.
- **Partner WSDL:** 범용, 다중 org, 커스터마이즈 미포함.

## SOAP API 유형
1. **Enterprise WSDL:** 단일 org, 메타데이터 동적 포함, org별 통합.
2. **Partner WSDL:** 범용·재사용, ISV 앱.
3. **Metadata API (SOAP):** 메타데이터 배포·조회, CI/CD.
4. **Apex SOAP API:** 커스텀 Apex 메서드를 SOAP 웹 서비스로 노출.

## Inbound SOAP API (외부 → Salesforce)
**단계:** ① WSDL 다운로드(Setup → API → Generate WSDL), ② 외부 시스템과 공유, ③ Session ID(login()) 또는 OAuth 2.0 인증, ④ SOAP UI·Postman 테스트.

**Account 생성 요청:**
```xml
<soapenv:Envelope xmlns:soapenv="..." xmlns:urn="urn:enterprise.soap.sforce.com">
  <soapenv:Header><urn:SessionHeader><urn:sessionId>[SessionID]</urn:sessionId></urn:SessionHeader></soapenv:Header>
  <soapenv:Body>
    <urn:create>
      <urn:sObjects xsi:type="urn:Account" xmlns:xsi="...">
        <urn:Name>Acme Corp</urn:Name>
        <urn:Industry>Finance</urn:Industry>
      </urn:sObjects>
    </urn:create>
  </soapenv:Body>
</soapenv:Envelope>
```

### Apex 클래스를 SOAP 웹 서비스로 노출 (@WebService)
class·메서드는 global, 메서드는 static.
```apex
global class AccountWebService {
    @WebService
    global static String createAccount(String accountName, String accountPhone) {
        Account acc = new Account(Name=accountName, Phone=accountPhone);
        try { insert acc; return 'Account Created Successfully: ' + acc.Id; }
        catch (Exception e) { return 'Error: ' + e.getMessage(); }
    }
    @WebService
    global static Account getAccount(String accountId) {
        try { return [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId LIMIT 1]; }
        catch (Exception e) { throw new CalloutException('Error: ' + e.getMessage()); }
    }
}
```
WSDL 생성: Setup → Apex Classes → AccountWebService → Generate WSDL. Java(JAX-WS·Axis2)로 클라이언트 스텁 생성.

**테스트:**
```apex
@IsTest
public class AccountWebServiceTest {
    @IsTest
    static void testCreateAccount() {
        String accountId = AccountWebService.createAccount('Test Account', '9876543210');
        Account acc = [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId];
        System.assertEquals('Test Account', acc.Name);
    }
}
```

## Outbound SOAP API (Salesforce → 외부)
**단계:** ① 외부 WSDL 다운로드, ② Setup → Apex Classes → Generate from WSDL → 파싱·이름 변경·생성, ③ Apex로 SOAP 요청, ④ Developer Console·테스트.

```apex
public class PaymentIntegration {
    public void sendPayment(String accountId, Decimal amount) {
        PaymentService.SoapClient client = new PaymentService.SoapClient();
        client.Endpoint_x = 'https://paymentgateway.com/api';
        PaymentService.PaymentRequest request = new PaymentService.PaymentRequest();
        request.accountId = accountId;
        request.amount = amount;
        PaymentService.PaymentResponse response = client.processPayment(request);
        System.debug('Response: ' + response.status);
    }
}
```
> @WebService는 Inbound 전용. Outbound는 WSDL로 Apex 생성 후 콜아웃.

**Outbound 테스트(HttpCalloutMock):**
```apex
@IsTest
global class MockPaymentServiceResponse implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'text/xml');
        response.setBody('<?xml version="1.0"?><soap:Envelope xmlns:soap="..."><soap:Body>'
            + '<processPaymentResponse xmlns="..."><status>Success</status></processPaymentResponse>'
            + '</soap:Body></soap:Envelope>');
        response.setStatusCode(200);
        return response;
    }
}
@IsTest
public class PaymentIntegrationTest {
    @IsTest
    static void testSendPayment() {
        Test.setMock(HttpCalloutMock.class, new MockPaymentServiceResponse());
        new PaymentIntegration().sendPayment('001XXX', 500.00);
    }
}
```

## Inbound vs Outbound 요약
| 측면 | Inbound(서버) | Outbound(클라이언트) |
|---|---|---|
| 목적 | 외부가 Salesforce 호출 | Salesforce가 외부 호출 |
| 키워드 | @WebService | WSDL 생성 Apex |
| 흐름 | 외부→SF | SF→외부 |
| 예 | ERP가 Account 생성 | 결제 게이트웨이에 주문 전송 |

## 모범 사례
WSDL 선택(Enterprise/Partner), HTTPS·프로필·IP 화이트리스트, SOAP fault 처리, 필요 필드만.

## 장점·제한
장점: 구조화·트랜잭션 무결성(롤백)·강타입·상세 메타데이터. 제한: .wsdl 형식만, 다중 port type·binding 불가, import·상속 미지원.

## 사용 사례
Inbound: 물류 배송 상태 업데이트, HR 직원 레코드 생성. Outbound: ERP 재고 업데이트, 외부 금융 API 신용등급 조회.
