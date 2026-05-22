---
tags: [apex, integration, commerce, tax, isv, namespace, reference]
source: salesforce_apex_reference_guide.pdf (doc p.527–645, Apex Reference Guide v67.0)
created: 2026-05-20
aliases: [CommerceTax, TaxEngineAdapter, commercetax, 세금 엔진 어댑터, B2B 세금 계산]
---

# CommerceTax Namespace

> Salesforce B2B/D2C Commerce 세금 엔진 ISV 어댑터 SDK — `TaxEngineAdapter` 인터페이스 구현으로 외부 세금 계산 엔진(Avalara 등)을 Commerce 플랫폼에 연결한다.

---

## 개요

`CommerceTax` 네임스페이스는 Salesforce B2B/D2C Commerce의 세금 계산을 외부 엔진에 위임하는 ISV 어댑터 패턴을 제공한다. 구현자는 `TaxEngineAdapter` 인터페이스 하나를 구현하면 된다.

**핵심 흐름:**

```
Commerce Platform
    └─ TaxEngineAdapter.processRequest(TaxEngineContext)
            ├─ context.getRequestType()  → RequestType.CalculateTax
            └─ context.getRequest()      → CalculateTaxRequest (cast)
                    └─ 세금 계산 후 CalculateTaxResponse 또는 ErrorResponse 반환
```

### 클래스 인벤토리

| 클래스 / 열거형 | 역할 |
|---|---|
| `TaxEngineAdapter` | 구현 대상 인터페이스 — `processRequest()` 1개 메서드 |
| `TaxEngineContext` | 요청 타입·요청 객체·Named URI를 담는 래퍼 |
| `TaxEngineRequest` | 요청 기반 인터페이스 (`CalculateTaxRequest` 구현) |
| `TaxEngineResponse` | 응답 기반 인터페이스 (`CalculateTaxResponse`/`ErrorResponse` 구현) |
| `TaxTransactionRequest` | 모든 요청의 abstract 기반 클래스 |
| `CalculateTaxRequest` | `TaxTransactionRequest` 상속 — 실제 세금 계산 요청 |
| `TaxLineItemRequest` | 라인 아이템별 세금 계산 정보 |
| `TaxAddressRequest` | 주소 정보 (city/state/country/lat/lon/postalCode) |
| `TaxAddressesRequest` | 헤더 주소 묶음 (shipFrom/shipTo/soldTo/billTo/taxEngineAddress) |
| `HeaderTaxAddressesRequest` | 헤더 레벨 주소 묶음 |
| `LineTaxAddressesRequest` | 라인 레벨 주소 묶음 |
| `TaxCustomerDetailsRequest` | 고객 정보 (accountId/exemptionNo 등) |
| `TaxSellerDetailsRequest` | 판매자 코드 정보 |
| `AbstractTransactionResponse` | 모든 응답의 abstract 기반 클래스 |
| `CalculateTaxResponse` | `AbstractTransactionResponse` 상속 — 정상 응답 |
| `ErrorResponse` | 에러 응답 (ResultCode + errorCode + errorMessage) |
| `LineItemResponse` | 라인별 세금 집계 응답 |
| `TaxDetailsResponse` | 세금 상세 — rate/tax/taxableAmount/exemption/jurisdiction/imposition |
| `ImpositionResponse` | 세금 부과 정보 (id/name/type/subType) |
| `JurisdictionResponse` | 관할권 정보 (country/region/level/stateAssignedNumber) |
| `RuleDetailsResponse` | 세금 규칙 상세 |
| `AddressesResponse` | 응답용 주소 묶음 |
| `AddressResponse` | 응답용 개별 주소 |
| `AmountDetailsResponse` | 금액 집계 (taxAmount/totalAmount/exemptAmount) |
| `CustomTaxAttributesResponse` | 커스텀 세금 속성 응답 |
| `TaxApiException` | 세금 API 예외 |
| `CalculateTaxType` Enum | `Actual` / `Estimated` |
| `RequestType` Enum | `CalculateTax` (현재 유일 값) |
| `ResultCode` Enum | `TaxEngineError` / `ReferenceDocumentCodeMissing` |
| `TaxTransactionStatus` Enum | `Committed` / `Uncommitted` |
| `TaxTransactionType` Enum | `Credit` / `Debit` / `Void` |

---

## TaxEngineAdapter Interface

구현 대상 인터페이스 — 메서드 1개.

```apex
global interface TaxEngineAdapter {
    global commercetax.TaxEngineResponse processRequest(
        commercetax.TaxEngineContext var1
    )
}
```

---

## TaxEngineContext Class

요청 타입과 요청 객체를 담는 래퍼. 플랫폼이 생성해 `processRequest()`에 전달한다.

### 테스트용 생성자

```apex
// 테스트 컨텍스트 외에서 사용 시 예외 발생
global TaxEngineContext(
    commercetax.TaxEngineRequest request,
    commercetax.RequestType requestType,
    String namedUri
)
```

### 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getNamedUri()` | `global String` | Named URI (callout 엔드포인트) |
| `getRequest()` | `global commercetax.TaxEngineRequest` | 요청 객체 — `CalculateTaxRequest`로 캐스팅해 사용 |
| `getRequestType()` | `global commercetax.RequestType` | 요청 유형 (`RequestType.CalculateTax`) |

```apex
global virtual class MockAdapter implements commercetax.TaxEngineAdapter {
    global commercetax.TaxEngineResponse processRequest(
        commercetax.TaxEngineContext taxEngineContext
    ) {
        commercetax.RequestType requestType = taxEngineContext.getRequestType();
        commercetax.CalculateTaxRequest request =
            (commercetax.CalculateTaxRequest) taxEngineContext.getRequest();

        if (requestType == commercetax.RequestType.CalculateTax) {
            // 세금 계산 로직
            commercetax.calculatetaxtype taxType = request.taxtype;
            // ...
        }
        return null;
    }
}
```

---

## 요청 계층 구조

### TaxTransactionRequest (Abstract)

모든 세금 요청의 기반 abstract 클래스.

**테스트용 생성자:**
```apex
global TaxTransactionRequest(
    commercetax.HeaderTaxAddressesRequest addresses,
    String currencyIsoCode,
    commercetax.TaxCustomerDetailsRequest customerDetails,
    String description,
    String documentCode,
    String referenceDocumentCode,
    Datetime transactionDate,
    Datetime effectiveDate,
    List<commercetax.TaxLineItemRequest> lineItems,
    String referenceEntityId,
    commercetax.TaxSellerDetailsRequest sellerDetails,
    Map<String, Object> customTaxAttributes
)
```

**Properties (모두 `global`):**

| Property | 타입 | 설명 |
|---|---|---|
| `addresses` | `HeaderTaxAddressesRequest` | Ship To / Bill From 등 헤더 주소 |
| `currencyIsoCode` | `String` | ISO 4217 통화 코드 |
| `customerDetails` | `TaxCustomerDetailsRequest` | 고객 정보 (accountId/exemptionNo) |
| `customTaxAttributes` | `Map<String, Object>` | 커스텀 세금 속성 (헤더 레벨) |
| `description` | `String` | 요청 설명 |
| `documentCode` | `String` | 문서 코드 |
| `effectiveDate` | `Datetime` | 트랜잭션 효력 발생일 (보고 전용) |
| `lineItems` | `List<TaxLineItemRequest>` | 세금 계산 대상 라인 아이템 목록 |
| `referenceDocumentCode` | `String` | 음수 라인 처리용: `{originalInvoiceId}_Debit-{taxEngineId}` 형식 |
| `referenceEntityId` | `String` | 라인 아이템 관련 Object ID |
| `sellerDetails` | `TaxSellerDetailsRequest` | 판매자 코드 정보 |
| `transactionDate` | `Datetime` | 트랜잭션 발생일 |

---

### CalculateTaxRequest

`TaxTransactionRequest` 상속. 실제 세금 계산 요청 클래스.

**추가 Properties:**

| Property | 타입 | 설명 |
|---|---|---|
| `isCommit` | `Boolean` | 트랜잭션 커밋 여부 |
| `isHeaderTaxRequested` | `Boolean` | 헤더 레벨 세금 요청 여부 |
| `shouldVoidTax` | `Boolean` | 세금 무효화 여부 |
| `taxTransactionType` | `TaxTransactionType` | Credit / Debit / Void |
| `taxtype` | `CalculateTaxType` | Actual / Estimated |
| `documentcode` | `String` | (TaxTransactionRequest.documentCode와 동일) |

```apex
commercetax.CalculateTaxRequest request =
    (commercetax.CalculateTaxRequest) taxEngineContext.getRequest();

commercetax.calculatetaxtype taxType = request.taxtype;
String docCode = '';
if (request.DocumentCode == 'simulateEmptyDocumentCode') {
    docCode = '';
} else if (request.DocumentCode != null) {
    docCode = request.DocumentCode;
} else if (request.ReferenceEntityId != null) {
    docCode = request.ReferenceEntityId;
} else {
    docCode = String.valueOf(getRandomInteger(0, 2147483647));
}
```

---

### TaxLineItemRequest

라인 아이템별 세금 계산 정보.

**테스트용 생성자:**
```apex
global TaxLineItemRequest(
    commercetax.LineTaxAddressesRequest addresses,
    Double amount,
    String description,
    String productCode,
    Double quantity,
    String lineNumber,
    String taxCode,
    Datetime effectiveDate
)
```

**Properties:**

| Property | 타입 | 설명 |
|---|---|---|
| `addresses` | `public LineTaxAddressesRequest` | 라인별 주소 (배송지 등) |
| `amount` | `global Double` | 라인 아이템 금액 |
| `customTaxAttributes` | `global Map<String, Object>` | 커스텀 속성 (라인 레벨) |
| `description` | `global String` | 아이템 설명 |
| `effectiveDate` | `global Datetime` | 세금 효력 발생일 |
| `lineNumber` | `global String` | 라인 번호 (고유 식별자) |
| `productCode` | `global String` | 카탈로그 코드 |
| `productSKU` | `global String` | 면세 대상 식별용 SKU |
| `quantity` | `global Double` | 수량 |
| `referenceDocumentCode` | `global String` | 음수 라인용 참조 문서 코드 |
| `taxCode` | `global String` | 세금 계산 코드 |

**Methods:** `equals(Object obj)`, `hashCode()`, `toString()`

---

### TaxAddressRequest

개별 주소 정보.

**테스트용 생성자:**
```apex
global TaxAddressRequest(
    String city,
    String country,
    Double latitude,
    Double longitude,
    String postalCode,
    String state,
    String street,
    String locationCode
)
```

**Properties:** city, country, countryCode, latitude, locationCode, longitude, postalCode, state, stateCode, street

---

### HeaderTaxAddressesRequest / LineTaxAddressesRequest / TaxAddressesRequest

주소 묶음 클래스.

```apex
// HeaderTaxAddressesRequest — 헤더 레벨 (TaxTransactionRequest.addresses)
global HeaderTaxAddressesRequest(
    TaxAddressRequest shipFrom,
    TaxAddressRequest shipTo,
    TaxAddressRequest soldTo,
    TaxAddressRequest billTo,
    TaxAddressRequest taxEngineAddress
)
// Properties: billTo, shipFrom, shipTo, soldTo, taxEngineAddress (모두 TaxAddressRequest)

// LineTaxAddressesRequest — 라인 레벨 (TaxLineItemRequest.addresses)
global LineTaxAddressesRequest(
    TaxAddressRequest shipFrom,
    TaxAddressRequest shipTo,
    TaxAddressRequest soldTo,
    TaxAddressRequest billTo,
    TaxAddressRequest taxEngineAddress
)
// Properties: billTo, shipFrom, shipTo, soldTo (모두 TaxAddressRequest)
```

---

### TaxCustomerDetailsRequest

고객 정보.

```apex
global TaxCustomerDetailsRequest(
    String accountId,
    String code,
    String exemptionNo,
    String exemptionReason
)
// Properties: accountId, code, exemptionNo, exemptionReason, taxCertificateId
```

---

### TaxSellerDetailsRequest

판매자 코드 정보.

```apex
global TaxSellerDetailsRequest(String code)
// Properties: code (global String)
```

---

## 응답 계층 구조

### AbstractTransactionResponse (Abstract)

모든 성공 응답의 기반 클래스.

| 메서드 | 파라미터 타입 |
|---|---|
| `setAddresses` | `AddressesResponse` |
| `setAmountDetails` | `AmountDetailsResponse` |
| `setCurrencyIsoCode` | `String` |
| `setCustomTaxAttributes` | `Map<String, Object>` |
| `setDescription` | `String` |
| `setDocumentCode` | `String` |
| `setEffectiveDate` | `Datetime` |
| `setLineItems` | `List<LineItemResponse>` |
| `setReferenceDocumentCode` | `String` |
| `setReferenceEntityId` | `String` |
| `setTaxTransactionId` | `String` (public) |
| `setTransactionDate` | `Datetime` |

---

### CalculateTaxResponse

`AbstractTransactionResponse` 상속. 정상 세금 계산 응답.

**추가 메서드 (모두 `global void`):**

| 메서드 | 파라미터 타입 |
|---|---|
| `setStatus` | `TaxTransactionStatus` |
| `setStatusDescription` | `String` |
| `setTaxTransactionType` | `TaxTransactionType` |
| `setTaxType` | `CalculateTaxType` |

```apex
commercetax.CalculateTaxResponse response = new commercetax.CalculateTaxResponse();
if (request.isCommit == true) {
    response.setStatus(commercetax.TaxTransactionStatus.Committed);
} else {
    response.setStatus(commercetax.TaxTransactionStatus.Uncommitted);
}
response.setDocumentCode(docCode);
response.setTransactionDate(Datetime.now());
response.setTaxTransactionType(commercetax.TaxTransactionType.Debit);
response.setCurrencyIsoCode('USD');
```

---

### ErrorResponse

에러 응답. `TaxEngineResponse` 구현.

```apex
// 생성자 — 단일 생성자만 존재
global ErrorResponse(
    commercetax.ResultCode resultCode,
    String errorCode,
    String errorMessage
)

// 사용 예시
return new commercetax.ErrorResponse(
    commercetax.ResultCode.TaxEngineError,
    '404',
    'documentCode is mandatory'
);
return new commercetax.ErrorResponse(
    commercetax.ResultCode.ReferenceDocumentCodeMissing,
    '504',
    'referenceDocumentCode - not supported'
);
```

---

### LineItemResponse

라인별 세금 집계. 내부에 `List<TaxDetailsResponse>`를 가진다.

**메서드 (모두 `global void`):**

| 메서드 | 파라미터 타입 |
|---|---|
| `setAddresses` | `AddressesResponse` |
| `setAmountDetails` | `AmountDetailsResponse` |
| `setCustomTaxAttributes` | `Map<String, Object>` |
| `setEffectiveDate` | `Datetime` |
| `setIsTaxable` | `Boolean` |
| `setLineNumber` | `String` |
| `setProductCode` | `String` |
| `setQuantity` | `Double` |
| `setTaxCode` | `String` |
| `setTaxes` | `List<TaxDetailsResponse>` |

---

### TaxDetailsResponse

세금 상세 정보 — jurisdiction·imposition·rate·tax·exemption 포함.

**메서드:**

| 메서드 | 파라미터 타입 |
|---|---|
| `setCustomTaxAttributes` | `Map<String, Object>` |
| `setExemptAmount` | `Double` |
| `setExemptReason` | `String` |
| `setImposition` | `ImpositionResponse` |
| `setJurisdiction` | `JurisdictionResponse` |
| `setRate` | `Double` |
| `setSerCode` | `String` |
| `setTax` | `Double` |
| `setTaxAuthorityTypeId` | `String` |
| `setTaxId` | `String` |
| `setTaxRegionId` | `String` |
| `setTaxRuleDetails` | `RuleDetailsResponse` |
| `setTaxableAmount` | `Double` |

```apex
commercetax.TaxDetailsResponse taxDetailsResponse = new commercetax.TaxDetailsResponse();
taxDetailsResponse.setExemptAmount(linesDetails.exemptAmount);
taxDetailsResponse.setExemptReason('Some reason we dont know');

commercetax.ImpositionResponse imposition = new commercetax.ImpositionResponse();
imposition.setSubType(linesDetails.taxName);
imposition.setType(linesDetails.ratetype);
taxDetailsResponse.setImposition(imposition);

commercetax.JurisdictionResponse jurisdiction = new commercetax.JurisdictionResponse();
jurisdiction.setCountry(linesDetails.country);
jurisdiction.setRegion(linesDetails.region);
jurisdiction.setName(linesDetails.jurisName);
jurisdiction.setStateAssignedNumber(linesDetails.stateAssignedNo);
jurisdiction.setId(linesDetails.jurisCode);
jurisdiction.setLevel(linesDetails.jurisType);
taxDetailsResponse.setJurisdiction(jurisdiction);

taxDetailsResponse.setRate(linesDetails.rate);
taxDetailsResponse.setTax(linesDetails.taxCalculated);
taxDetailsResponse.setTaxableAmount(linesDetails.taxableAmount);
taxDetailsResponse.setTaxAuthorityTypeId(String.valueOf(linesDetails.taxAuthorityTypeId));
taxDetailsResponse.setTaxId(linesDetails.id);
taxDetailsResponse.setTaxRegionId(linesDetails.region);
```

---

### ImpositionResponse

세금 부과 정보.

```apex
// 메서드 (모두 public void String)
imposition.setId(String id)
imposition.setName(String name)
imposition.setSubType(String subType)
imposition.setType(String type)
```

### JurisdictionResponse

관할권 정보.

```apex
// 메서드 (모두 global void String)
jurisdiction.setCountry(String country)
jurisdiction.setId(String id)
jurisdiction.setLevel(String level)
jurisdiction.setName(String name)
jurisdiction.setRegion(String region)
jurisdiction.setStateAssignedNumber(String stateAssignedNumber)
```

### RuleDetailsResponse

세금 규칙 상세.

```apex
// 생성자
RuleDetailsResponse()
// 메서드
setNonTaxableRuleId(String)
setNonTaxableType(String)
setRateRuleId(String)
setRateSourceId(String)
```

---

### AddressesResponse / AddressResponse

응답용 주소 클래스.

```apex
// AddressesResponse — global void
setShipFrom(AddressResponse)
setShipTo(AddressResponse)
setSoldTo(AddressResponse)

// AddressResponse
setLocationCode(String locationCode)
```

---

### AmountDetailsResponse

금액 집계 응답.

```apex
// 모두 global void Double
setExemptAmount(Double)
setTaxAmount(Double)
setTotalAmount(Double)
setTotalAmountWithTax(Double)

// 사용 예시
commercetax.AmountDetailsResponse amountResponse = new commercetax.AmountDetailsResponse();
amountResponse.setTaxAmount(linesToProcess.taxCalculated);
amountResponse.setTotalAmount(linesToProcess.lineAmount);
amountResponse.setTotalAmountWithTax(linesToProcess.lineAmount + linesToProcess.taxCalculated);
amountResponse.setExemptAmount(linesToProcess.exemptAmount);
lineItemResponse.setAmountDetails(amountResponse);
```

---

### CustomTaxAttributesResponse

커스텀 세금 속성 응답.

```apex
global CustomTaxAttributesResponse()
global void setData(Map<String, Object> data)
```

---

## 열거형 (Enums)

### CalculateTaxType

```apex
// 세금 계산 유형
commercetax.CalculateTaxType.Actual     // 실제 인보이스 (SalesInvoice)
commercetax.CalculateTaxType.Estimated  // 예상 견적 (SalesOrder)
```

### RequestType

```apex
// 현재 유일 값
commercetax.RequestType.CalculateTax
```

### ResultCode

```apex
commercetax.ResultCode.TaxEngineError              // 세금 엔진 일반 오류
commercetax.ResultCode.ReferenceDocumentCodeMissing // referenceDocumentCode 누락
```

### TaxTransactionStatus

```apex
commercetax.TaxTransactionStatus.Committed    // 세금 계산 완료 + 커밋됨
commercetax.TaxTransactionStatus.Uncommitted  // 세금 계산 완료, 미커밋
```

### TaxTransactionType

```apex
commercetax.TaxTransactionType.Credit  // 크레딧(환불) 트랜잭션
commercetax.TaxTransactionType.Debit   // 일반 청구 트랜잭션
commercetax.TaxTransactionType.Void    // referenceDocumentCode 문서 무효화
```

---

## TaxApiException

```apex
global TaxApiException()
global TaxApiException(Exception var1)
global TaxApiException(String var1, Exception var2)
```

---

## 전체 어댑터 구현 예시 (Avalara 패턴)

```apex
global virtual class AvalaraAdapter implements commercetax.TaxEngineAdapter {

    global commercetax.TaxEngineResponse processRequest(
        commercetax.TaxEngineContext taxEngineContext
    ) {
        commercetax.RequestType requestType = taxEngineContext.getRequestType();

        if (requestType == commercetax.RequestType.CalculateTax) {
            return CalculateTaxService.getTax(taxEngineContext);
        }
        return null;
    }
}

public with sharing class CalculateTaxService {

    public static commercetax.TaxEngineResponse getTax(
        commercetax.TaxEngineContext taxEngineContext
    ) {
        commercetax.CalculateTaxRequest request =
            (commercetax.CalculateTaxRequest) taxEngineContext.getRequest();

        // taxtype → CalculateTaxType.Actual('SalesInvoice') or Estimated('SalesOrder')
        String type = (request.taxtype == commercetax.CalculateTaxType.Actual)
            ? 'SalesInvoice' : 'SalesOrder';

        // Avalara API 호출
        HttpService httpService = HttpService.getInstance();
        httpService.addHeader('Authorization', 'Basic ...');
        String jsonBody = AvalaraJSONBuilder.getInstance()
            .frameJsonForGetTaxOrderItem(request);
        httpService.post('/api/v2/transactions/create', jsonBody);

        String responseString = httpService.getResponseToString();
        if (httpService.getResponse().getStatusCode() == 201) {
            // 성공 응답 파싱
            JsonSuccessParser parser = JsonSuccessParser.parse(responseString);
            commercetax.CalculateTaxResponse response =
                new commercetax.CalculateTaxResponse();

            // 라인 아이템별 응답 조립
            List<commercetax.LineItemResponse> lineItemResponses =
                new List<commercetax.LineItemResponse>();

            for (JsonSuccessParser.lines linesToProcess : parser.lines) {
                commercetax.LineItemResponse lineItemResponse =
                    new commercetax.LineItemResponse();
                List<commercetax.TaxDetailsResponse> taxDetailsResponses =
                    new List<commercetax.TaxDetailsResponse>();

                for (JsonSuccessParser.details linesDetails : linesToProcess.details) {
                    commercetax.TaxDetailsResponse taxDetailsResponse =
                        new commercetax.TaxDetailsResponse();

                    // 면세 금액
                    if (linesDetails.exemptAmount != 0) {
                        taxDetailsResponse.setExemptAmount(linesDetails.exemptAmount);
                        taxDetailsResponse.setExemptReason('Some reason we dont know');
                    }

                    // Imposition (세금 부과 유형)
                    commercetax.ImpositionResponse imposition =
                        new commercetax.ImpositionResponse();
                    imposition.setSubType(linesDetails.taxName);
                    imposition.setType(linesDetails.ratetype);
                    taxDetailsResponse.setImposition(imposition);

                    // Jurisdiction (관할권)
                    commercetax.JurisdictionResponse jurisdiction =
                        new commercetax.JurisdictionResponse();
                    jurisdiction.setCountry(linesDetails.country);
                    jurisdiction.setRegion(linesDetails.region);
                    jurisdiction.setName(linesDetails.jurisName);
                    jurisdiction.setStateAssignedNumber(linesDetails.stateAssignedNo);
                    jurisdiction.setId(linesDetails.jurisCode);
                    jurisdiction.setLevel(linesDetails.jurisType);
                    taxDetailsResponse.setJurisdiction(jurisdiction);

                    taxDetailsResponse.setRate(linesDetails.rate);
                    taxDetailsResponse.setTax(linesDetails.taxCalculated);
                    taxDetailsResponse.setTaxableAmount(linesDetails.taxableAmount);
                    taxDetailsResponse.setTaxAuthorityTypeId(
                        String.valueOf(linesDetails.taxAuthorityTypeId));
                    taxDetailsResponse.setTaxId(linesDetails.id);
                    taxDetailsResponse.setTaxRegionId(linesDetails.region);
                    taxDetailsResponses.add(taxDetailsResponse);
                }

                lineItemResponse.setTaxes(taxDetailsResponses);
                lineItemResponse.setEffectiveDate(
                    date.valueof(linesToProcess.taxDate));
                lineItemResponse.setIsTaxable(true);

                // AmountDetails
                commercetax.AmountDetailsResponse amountResponse =
                    new commercetax.AmountDetailsResponse();
                amountResponse.setTaxAmount(linesToProcess.taxCalculated);
                amountResponse.setTotalAmount(linesToProcess.lineAmount);
                amountResponse.setTotalAmountWithTax(
                    linesToProcess.lineAmount + linesToProcess.taxCalculated);
                amountResponse.setExemptAmount(linesToProcess.exemptAmount);
                lineItemResponse.setAmountDetails(amountResponse);

                lineItemResponse.setIsTaxable(linesToProcess.isItemTaxable);
                lineItemResponse.setProductCode(linesToProcess.itemCode);
                lineItemResponse.setTaxCode(linesToProcess.taxCode);
                lineItemResponse.setLineNumber(linesToProcess.lineNumber);
                lineItemResponse.setQuantity(linesToProcess.quantity);
                lineItemResponses.add(lineItemResponse);
            }

            response.setLineItems(lineItemResponses);
            return response;

        } else {
            // 에러 응답 파싱
            JsonErrorParser jsonErrorParserClass =
                JsonErrorParser.parse(responseString);
            String message = jsonErrorParserClass.error.message;
            return new commercetax.ErrorResponse(
                commercetax.ResultCode.TaxEngineError,
                '501',
                message
            );
        }
    }
}
```

---

## Tax Mapping 테이블 (Quote/Order 연동)

### Request — Header 속성 매핑

| Header Attribute | Quote Mapping | Order Mapping |
|---|---|---|
| `currencyIsoCode` | `Quote.CurrencyISOCode` | `Order.CurrencyISOCode` |
| `isCommit` | `False` | `False` |
| `referenceEntityId` | `Quote.ID` | `Order.ID` |
| `taxEngineId` | `TaxTreatment.TaxEngine.ID` | `TaxTreatment.TaxEngine.ID` |
| `transactionDate` | Current System Date | System Date |
| `sellerDetails.code` | NULL | `TaxEngine.SellerCode` |
| `customerDetails.accountId` | `Quote.AccountId` | `Order.AccountId` |
| `taxType` | `Estimated` | `Estimated` |
| `documentCode` | `Quote.ID-TaxEngineId` | `Order.ID-TaxEngineId` |
| `shouldVoid` | `FALSE` | `FALSE` |
| `addresses.taxEngineAddress` | `TaxEngine.Address` | `TaxEngine.Address` |

### Request — Line 속성 매핑

| Line Attribute | Quote Line Item | Order Product |
|---|---|---|
| `taxCode` | `TaxTreatment.TaxCode` | `TaxTreatment.TaxCode` |
| `productCode` | `TaxTreatment.ProductCode` | `TaxTreatment.ProductCode` |
| `amount` | `QuoteLineItem.TotalPrice` | `OrderItem.TotalPrice` |
| `lineNumber` | `QuoteLineItem.Id` | `OrderItem.Id` |
| `quantity` | `QuoteLineItem.Quantity` | `OrderItem.Quantity` |
| `addresses.billTo` | `Quote.BillingAddress` | `Order.BillingAddress` |
| `addresses.shipTo` | `Quote.ShippingAddress` | `Order.ShippingAddress` |

### Response — Header 속성 매핑

| Header Attribute | Quote Mapping | Order Mapping |
|---|---|---|
| `documentCode` | `Quote.ID-TaxEngineId` | `Order.ID-TaxEngineId` |
| `status` | `Uncommitted` | `Uncommitted` |
| `amountDetails.taxAmount` | Actual taxAmount from response | Actual taxAmount from response |
| `amountDetails.totalAmount` | `Quote.Subtotal` | `Order.Subtotal` |
| `amountDetails.totalAmountWithTax` | `TaxAmount + TotalAmount` | `TaxAmount + TotalAmount` |

---

## Named Credential 연동

Avalara 등 외부 세금 엔진 호출 시 `TaxTypedNamedCredential` 사용:

```apex
// Named Credential 엔드포인트 패턴
String endPoint = 'callout:commerce.tax.TaxTypedNamedCredential:test' + path;
```

---

## 관련 노트

- [[CommercePayments Namespace]] — 동일한 ISV 어댑터 패턴 (PaymentGatewayAdapter)
- [[CommerceBuyGrp Namespace]] — Commerce Buyer Group 어댑터
- [[CommerceExtension Namespace]] — Commerce 확장 포인트 전략
- [[CommerceOrders Namespace]] — Commerce 주문 생성 Apex
- [[RestClient 패턴]] — callout: Named Credential 기반 HTTP 호출
- [[Sfdc_Checkout Namespace]] — B2B 체크아웃 AsyncCartProcessor의 CartTaxCalculations 비동기 통합
