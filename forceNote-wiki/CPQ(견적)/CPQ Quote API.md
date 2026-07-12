---
tags: [CPQ, QuoteAPI, REST, Apex, SBQQ, ServiceRouter, 견적]
source: cpq_developer_guide.pdf (Salesforce CPQ Developer Guide v65.0 Winter '26)
created: 2026-06-21
aliases: [CPQ Quote API, Save Quote API, Calculate Quote API, Read Quote API, Validate Quote API, Add Products API, Read Product API, Create and Save Quote Proposal API, Quote Term Reader API, QuoteSaver, QuoteCalculator, QuoteReader, QuoteValidator, QuoteProductAdder, ProductLoader, SBQQ.ServiceRouter, CalculateCallback, CPQ 견적 저장 API, CPQ 견적 계산 API, CPQ REST, "CPQ 견적을 API로 저장하려면", "CPQ ServiceRouter 사용법", "CPQ 제안서 PDF API로 생성"]
---

# CPQ Quote API

> CPQ 견적의 저장·계산·읽기·검증·제품 추가·제안서 생성·약관 조회를 단일 REST 진입점 `SBQQ/ServiceRouter`로 수행하는 8개 하위 API. Salesforce CPQ Summer '16 이상.

---

## ServiceRouter — 단일 진입점 패턴

CPQ Quote API의 모든 하위 API는 REST 엔드포인트 하나를 공유한다.

```
/services/apexrest/SBQQ/ServiceRouter
```

동작 구분은 URL 경로가 아니라 **쿼리 파라미터로 어떤 saver/loader/reader 문자열을 지정하느냐**로 결정된다.

| 쿼리 파라미터 | 의미 | Apex 대응 메서드 |
|---|---|---|
| `?saver=...` | 데이터 저장 동작 | `SBQQ.ServiceRouter.save(...)` |
| `?loader=...` | 컨텍스트를 받아 모델을 로드/변환하는 동작 | `SBQQ.ServiceRouter.load(...)` |
| `?reader=...` | ID로 단순 읽기 | `SBQQ.ServiceRouter.read(...)` |
| `?uid=...` | 대상 레코드 ID (reader/loader와 함께) | (메서드 2번째 인자) |

REST 호출의 요청 본문은 `{"context": "..."}` 또는 `{"saver": "...", "model": "..."}` 형태이며 `context`/`model` 값은 **JSON 직렬화된 문자열(이스케이프된 JSON)**이다.

> 모델 클래스(QuoteModel·ProductModel·QuoteTermModel·QuoteProposalModel 등)의 필드 구조는 이 노트 범위 밖이다 → [[CPQ API Models]] 참조.
> ServiceRouter 메서드 시그니처·트리거 호출 제약 등 라우터 자체의 상세는 [[CPQ 기타 API — Document·Router·Quickstart·Triggers·Approvals]] 소관(이 노트는 Quote API 관점의 사용법만 다룬다).

---

## 모든 Apex 예제의 공통 전제

아래 8개 하위 API의 모든 Apex 예제 클래스는 실행 전 다음 전제를 만족해야 한다(원문이 각 API마다 반복 명시).

> **Before saving the example class, make sure that the CPQ Model classes are added as individual Apex classes in your org.**

즉 `QuoteModel`·`ProductModel`·`QuoteTermModel`·`QuoteProposalModel` 등 CPQ 모델 클래스가 org에 **개별 Apex 클래스로 미리 추가돼 있어야** 예제 클래스가 컴파일/실행된다. 모델 클래스 소스는 [[CPQ API Models]] 참조.

---

## 8개 하위 API 요약 매트릭스

| API | HTTP Method | ServiceRouter 메서드 | 쿼리 파라미터 문자열 | 반환 타입 | EDITIONS |
|---|---|---|---|---|---|
| Save Quote | POST | `save` | `saver=SBQQ.QuoteAPI.QuoteSaver` | QuoteModel | Summer '16+ |
| Calculate Quote | PATCH | `load` | `loader=SBQQ.QuoteAPI.QuoteCalculator` | (콜백 경유 저장) | Summer '16+ |
| Read Quote | GET | `read` | `reader=SBQQ.QuoteAPI.QuoteReader` | QuoteModel | Summer '16+ |
| Validate Quote | PATCH | `load` | `loader=QuoteAPI.QuoteValidator` (URL) / `SBQQ.QuoteAPI.QuoteValidator` (Apex) | String[] | Winter '19+ |
| Add Products | PATCH | `load` | `loader=SBQQ.QuoteAPI.QuoteProductAdder` | QuoteModel | Summer '16+ |
| Read Product | PATCH | `load` | `loader=SBQQ.ProductAPI.ProductLoader` | ProductModel | Summer '16+ |
| Create and Save Quote Proposal | POST `[sic]` / PATCH `[sic]` | `save` | `saver=QuoteDocumentAPI.SaveProposal` (URL) / `SBQQ.QuoteDocumentAPI.Save` (body·Apex) `[sic]` | jobId | Winter '19+ |
| Quote Term Reader | PATCH | `load` | `loader=SBQQ.QuoteTermAPI.Load` | QuoteTermModel | Summer '19+ |

> Validate Quote의 URL 문자열은 `QuoteAPI.QuoteValidator`(SBQQ 접두어 없음), Apex 코드는 `SBQQ.QuoteAPI.QuoteValidator`(접두어 있음)로 PDF 원문이 서로 다르다 — 원문 그대로 보존.
> Create and Save Quote Proposal의 HTTP Method와 saver 문자열은 PDF 내에서 불일치 — 아래 해당 섹션의 `[sic]` 설명 참조.

---

## 1. Save Quote API

CPQ 견적을 저장한다.

- **Formats** — JSON, Apex
- **HTTP Method** — POST
- **EDITIONS** — Available in: Salesforce CPQ, Summer '16 and later
- **Authentication** — Authorization: Bearer token

**REQUEST**

| Name | Type | Required | Description |
|---|---|---|---|
| quote | QuoteModel | Yes | Representation of `SBQQ__Quote__c` data |

**RESPONSE**

| Type | Description |
|---|---|
| QuoteModel | Representation of `SBQQ__Quote__c` data |

### REST Examples

```bash
curl
"https://yourInstance.salesforce.com/services/apexrest/SBQQ/ServiceRouter" -H
"Content-Type: application/json" -H "Authorization: Bearer token" -X POST -d
@quoteModel.json
```

This request body `quoteModel.json` file saves a quote. The context value is a JSON formatted string.

```json
{"saver": "SBQQ.QuoteAPI.QuoteSaver", "model": "{\"record\":
{\"attributes\":{\"type\":\"SBQQ__Quote__c\",\"url\":\"/services/data/v41.0/sobjects/
SBQQ__Quote__c/a0l61000003kUlVAAU\"},
\"Name\":\"Q-00681\",\"Id\":\"a0l61000003kUlVAAU\"},\"nextKey\":2,\"netTotal\":0.00,\
"lineItems\":[],\"lineItemGroups\":[],\"customerTotal\":0.00}"}
```

An example response body after saving a quote. The actual response is a JSON formatted string.

```json
{
  "record": {
    "attributes":{
      "type":"SBQQ__Quote__c",
      "url":"/services/data/v41.0/sobjects/SBQQ__Quote__c/a0l61000003kUlVAAU"
    },
    "Name":"Q-00681",
    "Id":"a0l61000003kUlVAAU"
  },
  "nextKey":2,
  "netTotal":0.00,
  "lineItems":[],
  "lineItemGroups":[],
  "customerTotal":0.00
}
```

### Apex Examples

```apex
public with sharing class QuoteSaver {
    public QuoteModel save(QuoteModel quote) {
        String quoteJSON = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver',
            JSON.serialize(quote));
        return (QuoteModel) JSON.deserialize(quoteJSON, QuoteModel.class);
    }
}
```

For an example of the `QuoteSaver` class, run the following code in anonymous Apex.

```apex
QuoteModel quoteModel; //Use Read, Add Products, or Calculate APIs to obtain a QuoteModel
QuoteSaver saver = new QuoteSaver();
QuoteModel savedQuote = saver.save(quoteModel);
System.debug(savedQuote);
```

---

## 2. Calculate Quote API

CPQ 견적의 가격을 계산한다.

- **Formats** — JSON, Apex
- **HTTP Method** — PATCH
- **EDITIONS** — Available in: Salesforce CPQ, Summer '16 and later
- **Authentication** — Authorization: Bearer token

성능 특성 (원문):

- Calculate Quote API는 Salesforce CPQ의 비동기 계산 속도와 유사하게 계산을 처리한다. **즉시 계산이 필요한 프로세스에는 권장하지 않는다(We do not recommend using it).**
- Calculate Quote API는 견적 생성·계산 시 배치를 사용하지 않는다. quote line이 대량인 견적에서는 성능이 달라질 수 있다.
- **Note:** Calculate Quote API는 quote-scoped product rule을 평가할 때 콜백(callback)을 요구한다.

**REQUEST**

| Name | Type | Required | Description |
|---|---|---|---|
| quote | QuoteModel | Yes | Representation of `SBQQ__Quote__c` data. See CPQ API QuoteModel |
| callbackClass | String | Required for Apex Trigger | This Apex class implements the CPQ `CalculateCallback` interface. |

> `callbackClass`는 Apex 트리거에서 호출할 때 필요하다. 트리거 컨텍스트에서 계산은 백그라운드로 수행되므로, 계산 후 견적을 저장하려면 `SBQQ.CalculateCallback` 인터페이스를 구현한 콜백 클래스를 지정해야 한다.

### REST Examples

```bash
curl
"https://yourInstance.salesforce.com/services/apexrest/SBQQ/ServiceRouter?loader=SBQQ.QuoteAPI.QuoteCalculator"
-H
"Content-Type: application/json" -H "Authorization: Bearer token" -X PATCH -d
"@quoteToCalculate.json"
```

This request body `quoteToCalculate.json` file calculates a quote. The context value is a JSON formatted string.

```json
{"context":"{\"quote\":{\"record\":{\"attributes\":{\"type\":\"SBQQ__Quote__c\",
\"url\":\"/services/data/v41.0/sobjects/SBQQ__Quote__c/a0p61000002NUmoAAG\"},
\"SBQQ__PartnerDiscount__c\":null,\"SBQQ__GenerateContractedPrice__c\":null,
\"SBQQ__QuoteProcessId__c\":\"a0m61000005NYxO\",
\"SBQQ__NetAmount__c\":100.0,\"SBQQ__CustomerDiscount__c\":null,
\"SBQQ__CustomerAmount__c\":100.0,\"SBQQ__PaymentTerms__c\":\"Net30\",
\"SBQQ__RenewalUpliftRate__c\":null,\"Name\":\"Q-00822\",\"SBQQ__Type__c\":\"Quote\",
\"SBQQ__SubscriptionTerm__c\":null,\"SBQQ__MarkupRate__c\":null,
\"SBQQ__OrderGroupID__c\":null,\"SBQQ__DistributorDiscount__c\":null,
\"SBQQ__OrderByQuoteLineGroup__c\":false,\"SBQQ__OrderBy__c\":null,
\"SBQQ__PricebookId__c\":\"01s61000000LI67AAG\",\"SBQQ__EndDate__c\":null,
\"SBQQ__Account__c\":null,\"SBQQ__StartDate__c\":null,
\"SBQQ__FirstSegmentTermEndDate__c\":null,\"SBQQ__BillingFrequency__c\":null,
\"SBQQ__LineItemsGrouped__c\":false,\"SBQQ__ExpirationDate__c\":null,
\"SBQQ__Primary__c\":false,\"SBQQ__LineItemCount__c\":1.0,\"SBQQ__MasterContract__c\":null,
\"SBQQ__EditLinesFieldSetName__c\":null,
\"Id\":\"a0p61000002NUmoAAG\",\"SBQQ__Unopened__c\":false,\"SBQQ__RenewalTerm__c\":null},
\"nextKey\":2,\"netTotal\":100.00,
\"netNonSegmentTotal\":100.0000,\"lineItems\":[{\"upliftable\":false,
\"targetCustomerTotal\":null,\"targetCustomerAmount\":null,
\"record\":{\"attributes\":{\"type\":\"SBQQ__QuoteLine__c\",
\"url\":\"/services/data/v41.0/sobjects/SBQQ__QuoteLine__c/a0l610000061yHpAAI\"},
\"SBQQ__CarryoverLine__c\":false,\"SBQQ__TermDiscountTier__c\":null,
\"SBQQ__VolumeDiscount__c\":null,\"SBQQ__BillingType__c\":null,
\"SBQQ__Discount__c\":null,\"SBQQ__ListPrice__c\":100.0,\"SBQQ__Existing__c\":false,
\"SBQQ__ProductName__c\":\"Product1\",\"SBQQ__SegmentIndex__c\":null,
\"SBQQ__DiscountTier__c\":null,\"SBQQ__SBCustomLevel__c\":null,\"SBQQ__ComponentTotal__c\":null,
\"SBQQ__RenewedSubscription__c\":null,
\"SBQQ__SubscriptionTargetPrice__c\":null,\"SBQQ__AllowAssetRefund__c\":false,
\"SBQQ__Optional__c\":false,\"SBQQ__PriorQuantity__c\":null,
\"SBQQ__Source__c\":null,\"SBQQ__Quote__c\":\"a0p61000002NUmoAAG\",\"SBQQ__SBCustomEndDate__c\":null,
\"SBQQ__ProratedListPrice__c\":100.0,\"SBQQ__ChargeType__c\":null,
\"SBQQ__UpliftAmount__c\":0.0,\"SBQQ__ComponentSubscriptionScope__c\":null,
\"SBQQ__OptionLevel__c\":null,\"SBQQ__NetPrice__c\":100.0,\"SBQQ__SBCustomCity__c\":null,
\"Id\":\"a0l610000061yHpAAI\",\"SBQQ__OriginalQuoteLineId__c\":null,
\"SBQQ__RegularPrice__c\":100.0,\"SBQQ__EffectiveQuantity__c\":1.0,\"SBQQ__Quantity__c\":1.0,
\"SBQQ__TaxCode__c\":null,\"SBQQ__sbCustom_Number1__c\":null,\"SBQQ__ContractedPrice__c\":null,
\"SBQQ__CostEditable__c\":false,\"SBQQ__Dimension__c\":null,
\"SBQQ__DynamicOptionId__c\":null,\"SBQQ__SBCustomSupport__c\":null,
\"SBQQ__PreviousSegmentUplift__c\":null,\"SBQQ__EndDate__c\":null,\"SBQQ__PreviousSegmentPrice__c\":null,
\"SBQQ__UpgradedSubscription__c\":null,\"SBQQ__SpecialPriceType__c\":null,
\"SBQQ__SegmentKey__c\":null,\"SBQQ__OptionDiscount__c\":null,\"SBQQ__RequiredBy__c\":null,
\"SBQQ__UpgradedAsset__c\":null,\"SBQQ__Bundled__c\":false,\"SBQQ__SBCustomColor__c\":null,
\"SBQQ__OptionType__c\":null,\"SBQQ__Number__c\":1.0,\"SBQQ__SubscriptionPercent__c\":null,
\"SBQQ__ComponentListTotal__c\":null,\"SBQQ__TermDiscountSchedule__c\":null,
\"SBQQ__Taxable__c\":false,\"SBQQ__Description__c\":null,\"SBQQ__ProductCode__c\":\"P1\",
\"SBQQ__OriginalPrice__c\":100.0,\"SBQQ__GenerateContractedPrice__c\":null,
\"SBQQ__NetTotal__c\":100.0,\"SBQQ__UnitCost__c\":null,\"SBQQ__SubscriptionCategory__c\":null,
\"SBQQ__Hidden__c\":false,\"SBQQ__NonDiscountable__c\":false,\"SBQQ__Markup__c\":0.0,\"SBQQ__RenewedAsset__c\":null,
\"SBQQ__GrossProfit__c\":null,\"SBQQ__MinimumPrice__c\":null,
\"SBQQ__BundledQuantity__c\":null,\"SBQQ__BatchQuantity__c\":null,
\"SBQQ__ProrateMultiplier__c\":1.0,\"SBQQ__CustomerPrice__c\":100.0,\"SBQQ__SubscriptionTerm__c\":null,
\"SBQQ__MarkupRate__c\":null,\"SBQQ__DistributorDiscount__c\":null,
\"SBQQ__DefaultSubscriptionTerm__c\":null,\"SBQQ__PriceEditable__c\":false,
\"SBQQ__ProratedPrice__c\":100.0,
\"SBQQ__ComponentUpliftedByPackage__c\":false,\"SBQQ__StartDate__c\":null,
\"SBQQ__NonPartnerDiscountable__c\":false,\"SBQQ__BlockPrice__c\":null,\"SBQQ__MaximumPrice__c\":null,
\"SBQQ__SubscriptionPricing__c\":null,\"SBQQ__AdditionalDiscount__c\":0.0,\"SBQQ__Favorite__c\":null,
\"SBQQ__ProductOption__c\":null,\"SBQQ__OptionDiscountAmount__c\":null,
\"SBQQ__TermDiscount__c\":null,\"SBQQ__MarkupAmount__c\":null,\"SBQQ__PartnerDiscount__c\":null,
\"SBQQ__ComponentDiscountedByPackage__c\":false,\"SBQQ__Renewal__c\":false,
\"SBQQ__CompoundDiscountRate__c\":null,\"SBQQ__UpgradedQuantity__c\":null,
\"SBQQ__AdditionalDiscountAmount__c\":null,\"SBQQ__Cost__c\":null,
\"SBQQ__PackageProductDescription__c\":null,\"SBQQ__PartnerPrice__c\":100.0,\"SBQQ__DiscountSchedule__c\":null,
\"SBQQ__ComponentCost__c\":null,\"SBQQ__SubscribedAssetIds__c\":null,
\"SBQQ__SubscriptionScope__c\":\"Quote\",\"SBQQ__Product__r\":{\"attributes\":
{\"type\":\"Product2\",\"url\":\"/services/data/v41.0/sobjects/Product2/01t610000033JNPAA2\"},
\"SBQQ__ExternallyConfigurable__c\":false,\"SBQQ__CostEditable__c\":false,\
"SBQQ__QuantityEditable__c\":true,\"SBQQ__Hidden__c\":false,\"SBQQ__ExcludeFromOpportunity__c\":false,
\"SBQQ__NonDiscountable__c\":false,\"Name\":\"Product1\",\"PricebookEntries\":
{\"totalSize\":1,\"done\":true,\"records\":[{\"attributes\":{\"type\":\"PricebookEntry\",
\"url\":\"/services/data/v41.0/sobjects/PricebookEntry/01u610000055KTeAAM\"},\
"UnitPrice\":100.0,\"Product2Id\":\"01t610000033JNPAA2\",\"IsActive\":true,
\"Pricebook2Id\":\"01s61000000LI67AAG\",\"Id\":\"01u610000055KTeAAM\"}]},
\"SBQQ__AssetConversion__c\":\"Oneperquoteline\",\"SBQQ__IncludeInMaintenance__c\":false,
\"SBQQ__PriceEditable__c\":false,\"SBQQ__ReconfigurationDisabled__c\":false,
\"SBQQ__DescriptionLocked__c\":false,\"SBQQ__NewQuoteGroup__c\":false,\"SBQQ__Optional__c\":false,
\"SBQQ__ExcludeFromMaintenance__c\":false,
\"SBQQ__AssetAmendmentBehavior__c\":\"Default\",\"ProductCode\":\"P1\",\"SBQQ__OptionSelectionMethod__c\":\"Click\",
\"SBQQ__SubscriptionType__c\":\"Renewable\",\"SBQQ__SubscriptionBase__c\":
\"List\",\"SBQQ__CustomConfigurationRequired__c\":false,\"SBQQ__NonPartnerDiscountable__c\":false,
\"SBQQ__DefaultQuantity__c\":1.0,\"SBQQ__PricingMethodEditable__c\":false,\"SBQQ__BlockPricingField__c\
":\"Quantity\",\"SBQQ__HasConfigurationAttributes__c\":false,\"SBQQ__Taxable__c\":false,
\"SBQQ__PricingMethod__c\":\"List\",\"Id\":\"01t610000033JNPAA2\"},\"SBQQ__SubscriptionBase__c\
":\"List\",\"SBQQ__BillingFrequency__c\":null,\"SBQQ__OriginalUnitCost__c\":null,
\"SBQQ__sbcustom_TwinField__c\":null,\"SBQQ__Bundle__c\":false,\"SBQQ__Product__c\":\
"01t610000033JNPAA2\",\"SBQQ__SpecialPrice__c\":100.0,\"SBQQ__PricingMethodEditable__c\":false,
\"SBQQ__Uplift__c\":0.0,\"SBQQ__PackageProductCode__c\":null,\"SBQQ__PricingMethod__c\":\"List\",
\"SBQQ__SegmentLabel__c\":null,\"SBQQ__AdditionalQuantity__c\":null,
\"SBQQ__DiscountScheduleType__c\":null},\"reconfigurationDisabled\":false,\"productQuantityScale\"
:null,\"productQuantityEditable\":true,\"productHasDimensions\":false,
\"parentItemKey\":null,\"parentGroupKey\":null,\"key\":2,\"dimensionType\":null,\"descriptionLocked\":false,
\"configurationType\":null,\"configurationEvent\":null,
\"amountDiscountProrated\":null}],\"lineItemGroups\":[],\"customerTotal\":100.00,\"channelDiscountsOffList\":false,
\"applyPartnerDiscountFirst\":false,\"applyAdditionalDiscountLast\":false}}"}
```

An example response body after successfully calculating a product. The actual response is a JSON formatted string.

```json
// PDF 원문 — JSON 일부 닫는 괄호 표기 불완전 (lineItems 항목 뒤 콤마·닫는 ] 누락은 PDF 그대로)
{
  "record": {
    "attributes": {
      "type": "SBQQ__Quote__c",
      "url": "/services/data/v41.0/sobjects/SBQQ__Quote__c/a0p610000040iumAAA"
    },
    "Id": "a0p61000002NUmoAAG",
    "Name": "Q-00822"
  },
  "nextKey": 2,
  "netTotal": 200,
  "netNonSegmentTotal": 200,
  "lineItems": [
    {
      "record": {
        "attributes": {
          "type": "SBQQ__QuoteLine__c",
          "url": "/services/data/v41.0/sobjects/SBQQ__QuoteLine__c/a0l61000003u09UAAQ"
        },
        "Id": "a0l610000061yHpAAI",
        "SBQQ__NetTotal__c": 200
      }
    }
  "lineItemGroups": []
}
```

### Apex Examples

When you execute the Calculate API with an Apex trigger, you also need to create a quote calculator callback class. This class must implement the CPQ `CalculateCallback` interface to save the quote after calculating it in the background.

```apex
global with sharing class MyCallback implements SBQQ.CalculateCallback {
    global void callback(String quoteJSON){
        SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', quoteJSON);
    }
}
```

Before saving the `QuoteCalculator` example class, make sure that the CPQ model classes are added as individual Apex classes in your org.

```apex
public with sharing class QuoteCalculator {
    public void calculate(QuoteModel quote, String callbackClass) {
        QuoteCalculatorContext ctx = new QuoteCalculatorContext(quote, callbackClass);
        SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteCalculator', null, JSON.serialize(ctx));
    }
    private class QuoteCalculatorContext {
        private QuoteModel quote;
        //The quote and callbackClass properties are called in the API code by the exact names seen here.
        private String callbackClass;
        //Altering these property names will cause calculator API calls to fail.
        private QuoteCalculatorContext(QuoteModel quote, String callbackClass) {
            this.quote = quote;
            this.callbackClass = callbackClass;
        }
    }
}
```

> `QuoteCalculatorContext`의 `quote`·`callbackClass` 프로퍼티 이름은 API 코드가 정확히 이 이름으로 호출하므로 변경하면 calculator API 호출이 실패한다(원문 주석).

For an example of the `QuoteCalculator` class, run the following code in anonymous Apex.

```apex
QuoteModel quoteModel; // Use Read or Add Products APIs to obtain a QuoteModel
quoteModel.lineItems[0].record.SBQQ__Quantity__c = 2;
QuoteCalculator calculator = new QuoteCalculator();
calculator.calculate(quoteModel, 'MyCallback');
```

---

## 3. Read Quote API

CPQ 견적 ID로 견적을 읽는다.

- **Formats** — JSON, Apex
- **HTTP Method** — GET
- **EDITIONS** — Available in: Salesforce CPQ, Summer '16 and later
- **Authentication** — Authorization: Bearer token

**REQUEST**

| Name | Type | Required | Description |
|---|---|---|---|
| uid | String | Yes | The ID of the quote to read |

**RESPONSE**

| Type | Description |
|---|---|
| QuoteModel | The representation of `SBQQ__Quote__c` data. |

### REST Examples

```bash
curl "https://yourInstance.salesforce.com/services/apexrest/SBQQ/
ServiceRouter?reader=SBQQ.QuoteAPI.QuoteReader&uid=a0p610000040iumAAA"
-H "Content-Type: application/json" -H "Authorization: Bearer token" -X GET
```

An example response body after reading a quote. The actual response is a JSON formatted string.

```json
// PDF 원문 — JSON 일부 닫는 괄호 표기 불완전 (lineItems 항목 뒤 콤마·닫는 ] 누락은 PDF 그대로)
{
  "record": {
    "attributes": {
      "type": "SBQQ__Quote__c",
      "url": "/services/data/v41.0/sobjects/SBQQ__Quote__c/a0p610000040iumAAA"
    },
    "Id": "a0p610000040iumAAA",
    "Name": "Q-00880"
  },
  "nextKey": 5,
  "netTotal": 300,
  "netNonSegmentTotal": 300,
  "lineItems": [
    {
      "record": {
        "attributes": {
          "type": "SBQQ__QuoteLine__c",
          "url": "/services/data/v41.0/sobjects/SBQQ__QuoteLine__c/a0l61000003u09UAAQ"
        },
        "Id": "a0l61000003u09UAAQ"
      }
    }
  "lineItemGroups": [ ]
}
```

### Apex Examples

Before saving the `QuoteReader` example class, make sure that the CPQ model classes **are** [sic — 원문 "are as", "added as"의 added 누락] as individual Apex classes in your org.

```apex
public with sharing class QuoteReader {
    public QuoteModel read(String quoteId) {
        String quoteJSON = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId);
        return (QuoteModel) JSON.deserialize(quoteJSON, QuoteModel.class);
    }
}
```

For an example of the `QuoteReader` class, run the following code in anonymous Apex.

```apex
QuoteReader reader = new QuoteReader();
QuoteModel quote = reader.read('a0Wf100000J1vk1');
System.debug(quote);
```

---

## 4. Validate Quote API

CPQ 견적을 검증하고 검증 오류를 반환한다.

- **Formats** — JSON, Apex
- **HTTP Method** — PATCH
- **EDITIONS** — Available in: Salesforce CPQ, **Winter '19 and later**
- **Authentication** — Authorization: Bearer token

**REQUEST**

| Name | Type | Required | Description |
|---|---|---|---|
| quote | QuoteModel | Yes | Representation of `SBQQ__Quote__c` data. |

**RESPONSE**

| Type | Description |
|---|---|
| String[] | If the quote is valid, the array is empty. Otherwise, the array contains an item for each validation error. |

### REST Examples

```bash
curl
"https://yourInstance.salesforce.com/services/apexrest/SBQQ/ServiceRouter?loader=QuoteAPI.QuoteValidator"
-H
"Content-Type: application/json" -H "Authorization: Bearer token" -X PATCH -d
@quoteModel.json
```

> URL의 loader 문자열은 `QuoteAPI.QuoteValidator`(SBQQ 접두어 없음). Apex 코드(아래)의 load 인자는 `SBQQ.QuoteAPI.QuoteValidator`(접두어 있음)로 PDF 원문이 서로 다르다 — 양쪽 모두 원문 보존.

The request body `quoteModel.json` file validates a quote. The context value is a JSON formatted string/serialization of a quote, the same as the CPQ Save Quote API.

```json
{"context": "{\"record\":
{\"attributes\":{\"type\":\"SBQQ__Quote__c\",\"url\":\"/services/data/v41.0/sobjects/SBQQ__Quote__c/a0l61000003kUlVAAU\"},
\"Name\":\"Q-00681\",\"Id\":\"a0l61000003kUlVAAU\"},\"nextKey\":2,\"netTotal\":0.00,\"lineItems\":[],\"lineItemGroups\":[],\"customerTotal\":0.00}"}
```

An example response body.

```json
// valid quote
[]
// invalid quote
[
  "message 1",
  "message 2",
  "message 3"
]
```

> PDF 원문은 이 응답 캡션에 "after creating the Apex job for generating the quote proposal"이라고 적혀 있으나, 이는 Create and Save Quote Proposal API에서 복사된 캡션 오류이며 Validate Quote API와 무관하다 — 본 노트에는 반영하지 않음.

### Apex Examples

Before saving the `Validator` example class, make sure that the CPQ model classes are added as individual Apex classes in your org.

```apex
public with sharing class Validator {
    public List<String> validate(QuoteModel quote) {
        String res = SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteValidator', null,
            JSON.serialize(quote));
        return (List<String>) JSON.deserialize(res, List<String>.class);
    }
}
```

> 교정 표기: PDF 원문은 `load(’SBQQ.QuoteAPI.QuoteValidator’, ...)`처럼 곡선 따옴표(U+2019)를 사용해 그대로는 Apex 컴파일이 불가하다. 위 코드는 정상 작은따옴표 `'`로 교정해 인용했다(동작 가능형). 그 외 내용은 원문 그대로.

Run the following code in anonymous Apex.

```apex
QuoteModel quoteModel; //Use Read Quote API to obtain a QuoteModel
Validator validator = new Validator();
List<String> msgs = validator.validate(quoteModel);
System.debug(msgs);
```

> 위 anonymous Apex 캡션도 PDF 원문은 "to get Apex job ID for generating and saving the quote proposal"로 적혀 있으나(복붙 오류) Validate Quote API와 무관하다 — 본 노트에는 정정해 옮김.

---

## 5. Add Products API

CPQ 견적·product collection·quote group key를 요청으로 받아, 제공된 모든 제품이 quote line으로 추가된 Quote 모델을 반환한다.

- **Formats** — JSON, Apex
- **HTTP Method** — PATCH
- **EDITIONS** — Available in: Salesforce CPQ, Summer '16 and later
- **Authentication** — Authorization: Bearer token

**REQUEST**

| Name | Type | Required | Description |
|---|---|---|---|
| quote | QuoteModel | Yes | A representation of `SBQQ__Quote__c` data |
| products | ProductModel[] | Yes | An array of representations of product data |
| groupKey | Integer | Required only for grouped quotes | An index of the existing quote line group where you're adding products (0 indexed by default) |
| ignoreCalculate | Boolean | Yes | Always use `true` for this value |

**RESPONSE**

| Type | Description |
|---|---|
| QuoteModel | The representation of `SBQQ__Quote__c` data |

### REST Examples

```bash
curl
"https://yourInstance.salesforce.com/services/apexrest/SBQQ/ServiceRouter?loader=SBQQ.QuoteAPI.QuoteProductAdder"
-H "Content-Type: application/json" -H "Authorization: Bearer token" -X PATCH -d
"@adderContext.json"
```

This request body `adderContext.json` file reads a product. The context value is a JSON formatted string.

```json
{"context":"{\"quote\":{\"record\":{\"attributes\":{\"type\":\"SBQQ__Quote__c\",\"url\":\"/services/data/v41.0/sobjects/SBQQ__Quote__c/a0p61000004IpR8AAK\"},
\"Name\":\"Q-00905\",\"Id\":\"a0p61000004IpR8AAK\"},\"nextKey\":2,\"netTotal\":0.00,\"lineItems\":[],\"lineItemGroups\":[],
\"customerTotal\":0.00},\"products\":[],\"groupKey\":0, \"ignoreCalculate\": true}"}
```

An example response body after adding a product. The actual response is a JSON formatted string.

```json
{
  "record": {
    "attributes": {
      "type": "SBQQ__Quote__c",
      "url": "/services/data/v41.0/sobjects/SBQQ__Quote__c/a0p61000004IpR8AAK"
    }
  },
  "nextKey": 4,
  "netTotal": 0.00,
  "lineItems": [
    {
      "record": {
        "attributes": {
          "type": "SBQQ__QuoteLine__c"
        },
        "SBQQ__Product__c": "01t610000033JNtAAM"
      },
      "productQuantityEditable": true,
      "productHasDimensions": false,
      "key": 3,
      "descriptionLocked": false
    },
    {
      "record": {
        "attributes": {
          "type": "SBQQ__QuoteLine__c"
        },
        "SBQQ__Product__c": "01t610000033JNUAA2",
        "SBQQ__Product__r": {
          "attributes": {
            "type": "Product2",
            "url": "/services/data/v41.0/sobjects/Product2/01t610000033JNUAA2"
          },
          "Id": "01t610000033JNUAA2",
          "Name": "Product 2",
          "ProductCode": "P2"
        }
      }
    }
  ],
  "lineItemGroups": [
    {
      "record": {
        "attributes": {
          "type": "SBQQ__QuoteLineGroup__c",
          "url": "/services/data/v41.0/sobjects/SBQQ__QuoteLineGroup__c/a0k61000008WIF1AAO"
        },
        "SBQQ__Quote__c": "a0p61000004IpR8AAK",
        "Id": "a0k61000008WIF1AAO",
        "SBQQ__Number__c": 1.0,
        "SBQQ__SeparateContract__c": false,
        "Name": "Group1"
      },
      "key": 2,
      "hasMultiSegmentLines": false
    }
  ],
  "customerTotal": 0.00
}
```

### Apex Examples

Before saving the `ProductAdder` example class, make sure that the CPQ model classes are added as individual Apex classes in your org.

```apex
public with sharing class ProductAdder {
    public QuoteModel add(QuoteModel quote, ProductModel[] products, Integer groupKey) {
        AddProductsContext ctx = new AddProductsContext(quote, products, groupKey);
        String quoteJSON = SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteProductAdder', null,
            JSON.serialize(ctx));
        return (QuoteModel) JSON.deserialize(quoteJSON, QuoteModel.class);
    }
    private class AddProductsContext {
        private QuoteModel quote;
        private ProductModel[] products;
        private Integer groupKey;
        private final Boolean ignoreCalculate = true; //Must be hardcoded to true
        private AddProductsContext(QuoteModel quote, ProductModel[] products, Integer groupKey) {
            this.quote = quote;
            this.products = products;
            this.groupKey = groupKey;
        }
    }
}
```

> `AddProductsContext`의 `ignoreCalculate`는 `true`로 하드코딩되어야 한다(원문 주석 "Must be hardcoded to true"). REST 요청의 `ignoreCalculate` 파라미터도 "Always use true"이다.

For an example of the `ProductAdder`, run the following code in anonymous Apex.

```apex
// [sic] PDF 원문에서 첫 두 줄이 "QuoteModelProductModel"로 붙어 출력됨 — 의미상 2개 변수 선언으로 분리
QuoteModel quoteModel; //Use Read Quote API to obtain a QuoteModel
ProductModel productModel; //Use Read Product API to obtain a ProductModel
List<ProductModel> productModels = new List<ProductModel>();
productModels.add(productModel);
ProductAdder adder = new ProductAdder();
QuoteModel quoteWithProducts = adder.add(quoteModel, productModels, 0);
System.debug(quoteWithProducts);
```

---

## 6. Read Product API

요청의 product ID·pricebook ID·currency code를 받아 Product 모델을 반환한다. Product 모델은 사용자가 요청할 때 카탈로그에서 제품을 로드한다.

- **Formats** — JSON, Apex
- **HTTP Method** — PATCH
- **EDITIONS** — Available in: Salesforce CPQ, Summer '16 and later
- **Special Access Rules** — Users must have read access to the `product2` object.
- **Authentication** — Authorization: Bearer token

**REQUEST**

| Name | Type | Required | Description |
|---|---|---|---|
| productId | ID | Yes | The ID of the product record to load |
| pricebookId | ID | Yes | The ID of the pricebook that contains the product record to load |
| currencyCode | String | Required only for multi-currency orgs | The ISO code of a Salesforce currency where the product's price is loaded |

**RESPONSE**

| Type | Description |
|---|---|
| ProductModel | The representation of product data |

### REST Examples

```bash
curl
"https://yourInstance.salesforce.com/services/apexrest/SBQQ/ServiceRouter?loader=SBQQ.ProductAPI.ProductLoader&uid=01t610000033JNt"
-H "Content-Type: application/json" -H "Authorization: Bearer token" -X PATCH -d
"@loaderContext.json"
```

This request body `loaderContext.json` file reads a product. The context value is a JSON formatted string.

```json
{"context" : "{\"pricebookId\": \"01sA0000000wuhg\", \"currencyCode\":\"USD\"}"}
```

An example response body after reading a product. The actual response is a JSON formatted string.

```json
// PDF 원문 — JSON 일부 닫는 괄호 표기 불완전 (record 객체 뒤 콤마 누락은 PDF 그대로)
{
  "record": {
    "attributes": {
      "type": "Product2",
      "url": "/services/data/v42.0/sobjects/Product2/01tA0000005uzfZ"
    },
    "Id": "01tA0000005uzfZ",
    "Name": "Apple"
  }
  "options": [],
  "features": [],
  "configuration": {}
}
```

### Apex Examples

Before saving the `ProductReader` example class, make sure that the CPQ model classes are added as individual Apex classes in your org.

```apex
public with sharing class ProductReader {
    public ProductModel read(Id productId, Id pricebookId, String currencyCode) {
        ProductReaderContext ctx = new ProductReaderContext(pricebookId, currencyCode);
        String productJSON = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ProductLoader',
            productId, JSON.serialize(ctx));
        return (ProductModel) JSON.deserialize(productJSON, ProductModel.class);
    }
    private class ProductReaderContext {
        private Id pricebookId;
        private String currencyCode;
        private ProductReaderContext(Id pricebookId, String currencyCode) {
            this.pricebookId = pricebookId;
            this.currencyCode = currencyCode;
        }
    }
}
```

> Read Product API는 `load`의 2번째 인자로 `productId`(레코드 ID)를 전달하고, context에는 `pricebookId`·`currencyCode`만 직렬화해 넣는다.

For an example of the `ProductReader` class, run the following code in anonymous Apex.

```apex
ProductReader reader = new ProductReader();
ProductModel product = reader.read('01tj0000003P1SN','01sj0000003THhKAAW','USD');
System.debug(product);
```

---

## 7. Create and Save Quote Proposal API

CPQ quote proposal(견적 제안서 문서)을 생성하고 저장한다.

- **Formats** — JSON, Apex
- **HTTP Method** — POST `[sic]` (REST curl 예제에서는 `-X PATCH` 사용 — PDF 내 불일치)
- **EDITIONS** — Available in: Salesforce CPQ, **Winter '19 and later**
- **Authentication** — Authorization: Bearer token
- **Note** — Salesforce CPQ는 API를 통한 Additional Document 레코드 첨부를 지원하지 않는다(doesn't support attaching Additional Document records through API).

> **`[sic]` HTTP Method 불일치:** EDITIONS/속성 섹션에는 `HTTP Method: POST`로 명시돼 있으나, 아래 curl 예제는 `-X PATCH`를 사용한다 — PDF 원문 그대로 양쪽 보존.
> **`[sic]` saver 문자열 불일치:** URL 쿼리 파라미터는 `saver=QuoteDocumentAPI.SaveProposal`이지만, 요청 본문과 Apex 코드는 `SBQQ.QuoteDocumentAPI.Save`를 쓴다 — 두 문자열이 서로 다르다. 원문 그대로 보존.

**REQUEST**

| Name | Type | Required | Description |
|---|---|---|---|
| name | String | No | The document name |
| paperSize | String | No | Options: Default, Letter, Legal, A4 |
| outputFormat | String | No | Options: pdf, word. Defaults to pdf. |
| quoteID | Id | Yes | The quote ID |
| templateId | Id | Yes | The quote template ID |
| language | String | No | Defaults to en_US |

**RESPONSE**

| Type | Description |
|---|---|
| jobId | Apex queueable job Id |

### REST Examples

```bash
curl
"https://yourInstance.salesforce.com/services/apexrest/SBQQ/ServiceRouter?saver=QuoteDocumentAPI.SaveProposal"
-H "Content-Type: application/json" -H
"Authorization: Bearer token" -X PATCH -d @data.json
```

The request body `data.json` file generates and saves a quote proposal.

```json
"{\"saver\":\"SBQQ.QuoteDocumentAPI.Save\",\"model\":\"{\\\"name\\\":\\\"test\\\",\\\
"quoteId\\\":\\\"a0n0R000000jhVC\\\",\\\"templateId\\\":\\\"a0l0R000000vahe\\\",
\\\"outputFormat\\\":\\\"PDF\\\",\\\"language\\\":\\\"en_US\\\",\\\"paperSize\\\":\\\"Default\\\"}\"}"
```

An example response body after creating the Apex job for generating the quote proposal.

```json
"7070R00000Nj8mjQAB"
```

### Apex Examples

Before saving the `GenerateQuoteProposal` example class, make sure that the CPQ model classes are added as individual Apex classes in your org.

```apex
public with sharing class GenerateQuoteProposal {
    public String save(QuoteProposalModel context) {
        return SBQQ.ServiceRouter.save('SBQQ.QuoteDocumentAPI.Save',
            JSON.serialize(context));
    }
}
```

Run the following code in anonymous Apex to get Apex job ID for generating and saving the quote proposal.

```apex
QuoteProposalModel model = new QuoteProposalModel();
model.quoteId = 'a0n0R000000jhVC';
model.templateId = 'a0l0R000000vahe';
GenerateQuoteProposal proposalGenerator = new GenerateQuoteProposal();
String jobId = proposalGenerator.save(model);
System.debug(jobId);
```

> `QuoteProposalModel` 필드 구조는 [[CPQ API Models]] 참조.

---

## 8. Quote Term Reader API

견적의 quote term(견적 약관)을 조회한다.

- **Formats** — JSON, Apex
- **HTTP Method** — PATCH
- **EDITIONS** — Available in: Salesforce CPQ, **Summer '19 and later**
- **Authentication** — Authorization: Bearer token

**REQUEST**

| Name | Type | Required | Description |
|---|---|---|---|
| quoteId | Id | Yes | The quote record's ID |
| templateId | Id | Optional | The quote template record's ID. If you don't include the templateId parameter, the quote terms associated with the template contents don't return. |
| language | String | Optional | Language code when using CPQ translations. |

**RESPONSE**

| Type | Description |
|---|---|
| QuoteTermModel | The representation of `SBQQ__QuoteTerm__c` data |

### REST Examples

```bash
curl "https://yourInstance.salesforce.com/services/apexrest/SBQQ/
ServiceRouter?loader=SBQQ.QuoteTermAPI.Load&uid=a0x5C000000G1CV"
-H "Content-Type: application/json" -H "Authorization: Bearer token" -X PATCH -d
"@termContext.json"
```

Example request body `termContext.json` file for reading quote terms. The context value is a JSON-formatted string.

```json
{"context":"{\"templateId\": \"a0v5C000000jTgr\", \"language\": \"es\"}"}
```

An example response body returning two quote terms. The actual response is a JSON-formatted string.

```json
[
  {
    "value": "Hasta 10 sesiones concurrentes incluidas.",
    "type": "Standard",
    "standardTermId": null,
    "quoteId": null,
    "locked": false,
    "label": "1",
    "id": "a0w5C000000cbaFQAQ"
  },
  {
    "value": "$ 50USD / por mes por licencia de sesión adicional.",
    "type": "Standard",
    "standardTermId": null,
    "quoteId": null,
    "locked": false,
    "label": "1.1",
    "id": "a0w5C000000cbaKQAQ"
  }
]
```

### Apex Examples

Before saving the `QuoteTermReader` example class, make sure that the CPQ model classes are added as individual Apex classes in your org.

```apex
public with sharing class QuoteTermReader {
    public List<QuoteTermModel> load(Id quoteId, Id templateId, String language) {
        TermContext ctx = new TermContext(templateId, language);
        String quoteTermsJSON = SBQQ.ServiceRouter.load('SBQQ.QuoteTermAPI.Load', quoteId,
            JSON.serialize(ctx));
        return (List<QuoteTermModel>) JSON.deserialize(quoteTermsJSON,
            List<QuoteTermModel>.class);
    }
    private class TermContext {
        private Id templateId;
        private String language;
        private TermContext(Id templateId, String language) {
            this.templateId = templateId;
            this.language = language;
        }
    }
}
```

> `load`의 2번째 인자로 `quoteId`를 전달하고, context에는 `templateId`·`language`만 직렬화해 넣는다.

For an example of the `QuoteTermReader` class, run this code in anonymous Apex.

```apex
QuoteTermReader quoteTermReader = new QuoteTermReader();
List<QuoteTermModel> quoteTerms = quoteTermReader.load('a0x5C000000G1CV', 'a0v5C000000jTgr',
    'es');
System.debug(quoteTerms);
```

---

## 관련 노트

- [[CPQ API Models]] — 이 API들이 주고받는 QuoteModel·QuoteLineModel·ProductModel·QuoteTermModel·QuoteProposalModel 등 모델 클래스 정의 (Apex 예제 실행 전 org에 추가 필요)
- [[CPQ Configuration·Contract API]] — Configuration Loader/Configurator·Contract 생성 등 같은 ServiceRouter를 쓰는 자매 API군
- [[CPQ 기타 API — Document·Router·Quickstart·Triggers·Approvals]] — SBQQ.ServiceRouter 메서드 시그니처 상세·트리거 호출 제약·Quickstart·Approvals
- [[Quotes (견적)]] — CPQ 없이 쓰는 표준 무료 견적 객체. 구성·가격 규칙이 필요 없는 단순 견적의 베이스라인
