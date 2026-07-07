---
tags: [agent-skill, sf-skills, reference, integration, soap]
source: forcedotcom/sf-skills (skills/integration-connectivity-generate/assets/soap/wsdl2apex-guide.md, 공식 Salesforce)
created: 2026-06-27
aliases: [WSDL2Apex, WSDL to Apex, SOAP 콜아웃 생성, WebServiceMock]
---

# WSDL to Apex Generation Guide — WSDL to Apex 생성 가이드

> WSDL 파일로부터 Apex 클래스를 자동 생성해 SOAP 웹서비스와 통합하는 단계별 절차·오류처리·테스트(WebServiceMock)·한도를 다룬다.

---

## Overview

Salesforce can automatically generate Apex classes from WSDL (Web Services Description Language) files, enabling integration with SOAP-based web services.

## Step-by-Step Process

### 1. Obtain the WSDL File

Get the WSDL from your external system. Common sources:
- API documentation portal
- Endpoint URL with `?wsdl` suffix (e.g., `https://api.example.com/service?wsdl`)
- Direct download from vendor

### 2. Review WSDL for Compatibility

Salesforce WSDL2Apex has limitations. Check for:

**Supported:**
- **Document literal wrapped style only**¹
- Simple types (string, integer, boolean, date, etc.)
- Complex types (objects with properties)
- Arrays and lists
- Basic SOAP headers

**Not Supported / Problematic:**
- **RPC/encoded services — NOT supported**¹ (Apex supports only document literal wrapped)
- WSDL files with multiple portTypes, services, or bindings
- WSDL files that import external schemas (`<xsd:include schemaLocation="...">`)
- WSDLs that aren't document literal wrapped → `"Unable to find complexType"` error on import
- Very large WSDLs — parse fails if generated class exceeds the 1,000,000-character limit (includes the Salesforce SOAP API WSDL)
- Some advanced XSD features / schema types not in the supported list
- WS-Security (requires manual implementation)

> ¹ **정정 (2026-07-07):** 이전 버전은 "Document/literal and RPC/encoded styles"를 지원으로 표기했으나, 이는 오류다. Apex는 **document literal wrapped 스타일만** 지원하며 **RPC/encoded는 지원하지 않는다**. 근거: *Apex Developer Guide — Supported WSDL Features* ("Apex supports only the document literal wrapped WSDL style"; "Apex does not support ... RPC/encoded services"). 상세는 [[WSDL2Apex — 외부 SOAP 소비 (스텁 생성·구조·한도)]] 참조.

### 3. Generate Apex Classes

1. Navigate to **Setup → Apex Classes**
2. Click **Generate from WSDL**
3. Click **Choose File** and upload the WSDL
4. Review the parse results
5. Modify class names if needed (keep them short to avoid limits)
6. Click **Generate Apex code**

### 4. Generated Class Structure

For a WSDL defining `CustomerService` with operation `getCustomer`:

```
// 실제 구조: WSDL 네임스페이스당 top-level 클래스 1개.
// 각 complexType(요청·응답 래퍼·데이터 타입)은 그 클래스의 inner class로 들어간다.
// Async 스텁만 별도 top-level 클래스로 생성된다.
CustomerService.cls              - 네임스페이스당 top-level 클래스 1개 (스텁 포트 + 모든 타입을 inner class로 포함)
  ├─ class CustomerServicePort   - inner: 오퍼레이션 메서드(getCustomer 등)를 가진 스텁 포트
  ├─ class GetCustomerRequest    - inner: 요청 래퍼
  ├─ class GetCustomerResponse   - inner: 응답 래퍼
  ├─ class Customer              - inner: 스키마 데이터 타입
  └─ class Address               - inner: 중첩 데이터 타입
AsyncCustomerService.cls         - Async 버전만 별도 top-level 클래스 (접두사 Async)
```

> **정정 (2026-07-07):** WSDL2Apex는 타입마다 별도 `.cls`를 만들지 않는다. **WSDL 네임스페이스당 top-level 클래스 1개**를 생성하고, 각 complexType(요청/응답 래퍼·데이터 타입)은 그 클래스의 **inner class**로 넣는다. 동기 스텁과 별개로 **`Async` 접두사 클래스만 별도 top-level**로 생성된다. 근거: developer.salesforce.com — *Understanding the Generated Code* (apex_callouts_wsdl2apex_gen_code): "a default class name for each namespace" + 동일 이름을 재사용해 여러 네임스페이스를 한 클래스로 합칠 수 있음.

### 5. Configure Endpoint Access

**Option A: Named Credential (Recommended)**

1. Create Named Credential in Setup
2. Set endpoint to SOAP service URL
3. Configure authentication (Basic, Certificate, OAuth)
4. In Apex: `stub.endpoint_x = 'callout:MyNamedCredential';`

**Option B: Remote Site Setting**

1. Create Remote Site Setting with domain
2. In Apex: `stub.endpoint_x = 'https://api.example.com/service';`

### 6. Basic Usage Example

```apex
public class CustomerServiceCaller {

    public static Customer getCustomer(String customerId) {
        // Instantiate the generated stub
        CustomerService.CustomerServicePort stub = new CustomerService.CustomerServicePort();

        // Configure endpoint (Named Credential)
        stub.endpoint_x = 'callout:CustomerServiceNC';

        // Set timeout (max 120 seconds)
        stub.timeout_x = 120000;

        // Create request
        GetCustomerRequest request = new GetCustomerRequest();
        request.customerId = customerId;

        // Make the call
        GetCustomerResponse response = stub.getCustomer(request);

        return response.customer;
    }
}
```

### 7. Error Handling

```apex
try {
    GetCustomerResponse response = stub.getCustomer(request);
    // Process response

} catch (CalloutException e) {
    // Network error, timeout, SSL issues
    System.debug('Callout failed: ' + e.getMessage());

} catch (Exception e) {
    // SOAP fault (error from service)
    // The exception message contains SOAP fault details
    System.debug('SOAP error: ' + e.getMessage());
}
```

### 8. Common Issues and Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| `Web service callout failed` | Network/SSL issue | Check Remote Site Setting, verify endpoint |
| `Read timed out` | Service slow to respond | Increase `timeout_x` (max 120000ms) |
| `Apex class size limit` | WSDL too large | Split WSDL, use fewer operations |
| `Unable to parse callout response` | Response doesn't match WSDL | Check service version, update WSDL |
| `Methods defined as Webservice` | Conflict with reserved keywords | Rename operations in WSDL or generated class |

### 9. Testing SOAP Callouts

Use `Test.setMock()` with `WebServiceMock`:

```apex
@isTest
public class CustomerServiceTest {

    @isTest
    static void testGetCustomer() {
        // Set mock
        Test.setMock(WebServiceMock.class, new CustomerServiceMock());

        // Call service
        Test.startTest();
        Customer result = CustomerServiceCaller.getCustomer('CUST001');
        Test.stopTest();

        // Assert
        System.assertEquals('Test Customer', result.name);
    }

    // Mock implementation
    public class CustomerServiceMock implements WebServiceMock {
        public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
        ) {
            // Create mock response
            GetCustomerResponse mockResponse = new GetCustomerResponse();
            mockResponse.customer = new Customer();
            mockResponse.customer.name = 'Test Customer';

            response.put('response_x', mockResponse);
        }
    }
}
```

### 10. Async SOAP Calls

For calls from triggers or after DML:

```apex
public class CustomerSyncQueueable implements Queueable, Database.AllowsCallouts {

    private String customerId;

    public CustomerSyncQueueable(String customerId) {
        this.customerId = customerId;
    }

    public void execute(QueueableContext context) {
        try {
            Customer customer = CustomerServiceCaller.getCustomer(customerId);
            // Process result
        } catch (Exception e) {
            // Log error
        }
    }
}

// Usage in trigger:
System.enqueueJob(new CustomerSyncQueueable(accountId));
```

## Best Practices

1. **Always use Named Credentials** for authentication instead of hardcoding credentials
2. **Set appropriate timeouts** - default may be too short
3. **Implement error handling** - SOAP services can fail in many ways
4. **Log requests and responses** for debugging
5. **Use async patterns** when calling from DML contexts
6. **Test with mocks** - don't call real services in tests
7. **Monitor governor limits** - especially for large responses

## Limitations

- Maximum 100 callouts per transaction
- Maximum 120 second timeout per callout
- Response body limit: 6MB
- Apex code size limits may prevent large WSDL imports
- Some WSDL features not supported (WS-Security, MTOM, etc.)

---

## 관련 노트
- [[integration-connectivity-generate]]
- [[callout-patterns]]
- [[named-credentials-guide]]
