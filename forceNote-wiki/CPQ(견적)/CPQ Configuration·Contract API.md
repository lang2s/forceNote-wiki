---
tags: [CPQ, Salesforce CPQ, SBQQ, Configuration API, Contract API, 번들구성, 견적, Apex, REST]
source: cpq_developer_guide.pdf (Salesforce CPQ Developer Guide, v65.0 Winter '26)
created: 2026-06-21
aliases: [CPQ Configuration API, CPQ Contract API, Configuration Loader API, Load Rule Executor API, Configuration Validator API, Contract Amender API, Contract Renewer API, ConfigLoader, LoadRuleRunner, ConfigValidator, ContractAmender, ContractRenewer, SBQQ.ConfigAPI, SBQQ.ContractManipulationAPI, 번들 구성 API, 계약 수정, 계약 갱신, amendment quote, renewal quote, "CPQ 번들 구성하는 API", "CPQ 계약 수정 갱신 API"]
---

# CPQ Configuration·Contract API

> Salesforce CPQ(managed package, `SBQQ.*`)의 두 API 그룹 — 제품 번들을 구성·가격 책정하는 **Configuration API**(Loader / Load Rule Executor / Validator)와 CPQ 견적을 수정·갱신하는 **Contract API**(Amender / Renewer).

이 문서의 모든 API는 `SBQQ.ServiceRouter`를 통해 호출된다(REST는 `/services/apexrest/SBQQ/ServiceRouter`). 각 API가 주고받는 `QuoteModel` · `ProductModel` · `ConfigurationModel` 등 데이터 모델은 [[CPQ API Models]] 참조 — 예제 Apex 클래스 실행 전에 CPQ Models 클래스들을 org에 개별 Apex 클래스로 추가해 두어야 한다. ServiceRouter의 메서드 시그니처(`read`/`load`/`save`)는 CPQ Quote API 문서 참조.

---

## CPQ Configuration API

> **EDITIONS** — 그룹 상위: Available in Salesforce CPQ, Summer '16 and later. 개별 API(Loader/Executor/Validator)는 Spring '17 and later.

제품 번들을 구성·가격 책정하는 데 사용한다. PDF 원문:

> Use the Salesforce CPQ Configuration API to configure and price product bundles.
> - **Configuration Loader API** — returns all the data for the product, including its product options and configuration model. When configuring a nested bundle, set the `parentProduct` property to the parent product to inherit configuration attributes on the nested bundle.
> - **Configuration Load Rule Executor API** — invokes all the load event product rules for the specified product. When configuring a nested bundle, set the `parentProduct` property to the parent product to inherit configuration attributes on the nested bundle.
> - **Configuration Validator API** — runs selection, validation, and alert product rules and configurator-scoped price rules against the input configuration model and returns an updated configuration model.

세 API 모두 **HTTP Method: PATCH**, 인증 `Authorization: Bearer token`, Formats: JSON·Apex, EDITIONS: Salesforce CPQ, Spring '17 and later.

---

### Configuration Loader API

제품의 모든 데이터(제품 옵션·구성 모델 포함)를 반환한다. nested bundle을 구성할 때는 `parentProduct` 프로퍼티에 부모 제품을 설정해 부모의 구성 속성을 상속한다.

| 속성 | 값 |
|---|---|
| Service Provider | `SBQQ.ConfigAPI.ConfigLoader` |
| HTTP Method | PATCH |
| Formats | JSON, Apex |
| EDITIONS | Salesforce CPQ, Spring '17 and later |

**Request 파라미터**

| Name | Type | Required/Optional | Description |
|---|---|---|---|
| `uid` | String | Required | ID of the Product2 record. |
| `quote` | QuoteModel | Required | Corresponds directly to SBQQ__Quote__c. |
| `parentProduct` | ProductModel | Optional | The parent product for a nested bundle. Used to inherit configuration attributes from the parent product. |

**Response**

| Type | Description |
|---|---|
| ProductModel | Representation of product data. See [[CPQ API Models]]. |

**REST 호출 (curl)**

```bash
curl \
"https://yourInstance.salesforce.com/services/apexrest/SBQQ/ServiceRouter?loader=SBQQ.ConfigAPI.ConfigLoader&uid=a0x5C000000G1CV" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer yourAuthorizationToken" \
-X PATCH \
-d "@configLoaderContext.json"
```

요청 본문 `configLoaderContext.json` (quote model의 JSON 문자열) — PDF verbatim:

```json
{"context":"{\"quote\":{\"record\":{\"attributes\":{\"type\":\"SBQQ__Quote__c\",
\"url\":\"/services/data/v48.0/sobjects/SBQQ__Quote__c/a0p61000004IpR8AAK\"},
\"Name\":\"Q-00905\",
\"Id\":\"a0p61000004IpR8AAK\"},
\"nextKey\":2,
\"netTotal\":0.00,
\"lineItems\":[],
\"lineItemGroups\":[],
\"customerTotal\":0.00},
\"products\":[],
\"groupKey\":0,
\"ignoreCalculate\": true}"}
```

응답 본문 — PDF verbatim (원문 그대로: `"Name": "Apple"` 다음 `}` 뒤에 쉼표 없이 `"options"`가 옴 [sic]):

```json
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

**Apex 예제 클래스 `ConfigLoader`** (PDF verbatim) — *Before saving the ConfigLoader example class, make sure that the CPQ Models classes are added as individual Apex classes in your org.*

```apex
public with sharing class ConfigLoader {
    public ProductModel load(Id productId, QuoteModel quote, ProductModel parentProduct) {
        ConfigLoadContext ctx = new ConfigLoadContext(quote, parentProduct);
        String productJSON = SBQQ.ServiceRouter.load('SBQQ.ConfigAPI.ConfigLoader',
            productId, JSON.serialize(ctx));
        return (ProductModel) JSON.deserialize(productJSON, ProductModel.class);
    }
    private class ConfigLoadContext {
        private QuoteModel quote;
        private ProductModel parentProduct;
        private ConfigLoadContext(QuoteModel quote, ProductModel parentProduct) {
            this.quote = quote;
            this.parentProduct = parentProduct;
        }
    }
}
```

Anonymous Apex 사용 예 (PDF verbatim):

```apex
QuoteModel quote; //Use Read, Add Products, or Calculate APIs to obtain a QuoteModel
ConfigLoader loader = new ConfigLoader();
ProductModel product = loader.load('a0x5C000000G1CV', quote, null);
System.debug(product);
```

---

### Configuration Load Rule Executor API

지정 제품의 모든 load 이벤트 제품 규칙(load event product rules)을 실행한다. nested bundle 구성 시 `parentProduct`로 부모 구성 속성을 상속한다.

| 속성 | 값 |
|---|---|
| Service Provider | `SBQQ.ConfigAPI.LoadRuleExecutor` |
| HTTP Method | PATCH |
| Formats | JSON, Apex |
| EDITIONS | Salesforce CPQ, Spring '17 and later |

**Request 파라미터**

| Name | Type | Required/Optional | Description |
|---|---|---|---|
| `uid` | String | Required | ID of the Product2 record. |
| `quote` | QuoteModel | Required | Corresponds directly to SBQQ__Quote__c. |
| `configuration` | ConfigurationModel | Optional | The product's configuration data. Only required if you have an existing configuration from product actions or a previous run-through. |
| `lineItemKey` | Integer | Optional | Used to identify upgrade options in amendment flows. |
| `dynamicOptionSkus` | List<String> | Optional | A list of dynamic option SKUs. Sourced from product options selected in dynamic features. |
| `parentProduct` | ProductModel | Optional | The parent product for a nested bundle. Used to inherit configuration attributes from the parent product. |

**Response**

| Type | Description |
|---|---|
| ProductModel | Representation of product data. See [[CPQ API Models]]. |

**REST 호출 (curl)**

```bash
curl \
"https://yourInstance.salesforce.com/services/apexrest/SBQQ/ServiceRouter?loader=SBQQ.ConfigAPI.LoadRuleExecutor&uid=a0x5C000000G1CV" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer yourAuthorizationToken" \
-X PATCH \
-d "@loadRuleContext.json"
```

요청 본문 `loadRuleContext.json` (quote model + configuration model의 JSON 문자열) — PDF verbatim:

```json
{"context":"{\"quote\":{\"record\":{\"attributes\":{\"type\":\"SBQQ__Quote__c\"},
\"Account__c\":\"0014M00001mfEYT\",
\"Id\":\"a0c4M00000eE9SgQAK\",
\"PricebookId__c\":\"01s61000002xO1h\",
\"CurrencyIsoCode\":\"USD\"}},
\"configuration\":{\"validationMessages\":[],
\"priceEditable\":false,
\"optionData\":{\"attributes\":{\"type\":\"SBQQ__ProductOption__c\"}},
\"optionConfigurations\":[{\"validationMessages\":[],
\"priceEditable\":false,
\"optionId\":\"a0U4M00000GJagGUAT\",
\"optionData\":{\"attributes\":{\"type\":\"SBQQ__ProductOption__c\",
\"url\":\"\/services\/data\/v48.0\/sobjects\/ProductOption__c\/a0U4M00000GJagGUAT\"},
\"ConfiguredSKU__c\":\"01t4M000003ru2OQAQ\",
\"Id\":\"a0U4M00000GJagGUAT\",
\"OwnerId\":\"0056100000148O6AAI\",
\"IsDeleted\":false,
\"CurrencyIsoCode\":\"USD\",
\"SystemModstamp\":\"2020-03-10T20:47:39.000+0000\",
\"AppliedImmediately__c\":false,
\"Bundled__c\":false,
\"DiscountedByPackage__c\":false,
\"Number__c\":1,
\"OptionalSKU__c\":\"01t4M000003ru2PQAQ\",
\"PriceEditable__c\":\"No\",
\"ProductConfigurationType__c\":\"Allowed\",
\"ProductName__c\":\"W-7145106 Bundle - Nested Option - Level 1 Product #1\",
\"QuantityEditable__c\":true,
\"Quantity__c\":1,
\"Required__c\":false,
\"Selected__c\":true,
\"System__c\":false,
\"Type__c\":\"Component\",
\"UpliftedByPackage__c\":false,
\"CanOrderSeparately__c\":false},
\"optionConfigurations\":[],
\"isUpgrade\":false,
\"isDynamicOption\":false,
\"configuredProductId\":\"01t4M000003ru2PQAQ\",
\"configured\":false,
\"configurationEntered\":false,
\"configurationData\":{\"attributes\":{\"type\":\"SBQQ__ProductOption__c\"}},
\"changedByProductActions\":false}],
\"isUpgrade\":false,
\"isDynamicOption\":false,
\"configuredProductId\":\"01t4M000003ru2OQAQ\",
\"configured\":false,
\"configurationEntered\":false,
\"configurationData\":{\"attributes\":{\"type\":\"SBQQ__ProductOption__c\"}},
\"changedByProductActions\":false}}"}
```

응답 본문 — PDF verbatim (`"Name": "Apple"` 뒤 `}`에 쉼표 누락 [sic]):

```json
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

**Apex 예제 클래스 `LoadRuleRunner`** (PDF verbatim) — *Before saving the LoadRuleRunner example class, make sure that the CPQ Models classes are added as individual Apex classes in your Salesforce org.*

```apex
public with sharing class LoadRuleRunner {
    public ProductModel load(
        Id productId,
        QuoteModel quote,
        Integer lineItemKey,
        List<String> dynamicOptionSkus,
        ConfigurationModel configuration,
        ProductModel parentProduct) {
        LoadRuleRunnerContext ctx = new LoadRuleRunnerContext(
            quote,
            lineItemKey,
            dynamicOptionSkus,
            configuration,
            parentProduct);
        String productJSON = SBQQ.ServiceRouter.load('SBQQ.ConfigAPI.LoadRuleExecutor',
            productId, JSON.serialize(ctx));
        return (ProductModel) JSON.deserialize(productJSON, ProductModel.class);
    }
    private class LoadRuleRunnerContext {
        private QuoteModel quote;
        private ProductModel parentProduct;
        private Integer lineItemKey;
        private List<String> dynamicOptionSkus;
        public ConfigurationModel configuration;
        public LoadRuleRunnerContext(
            QuoteModel quote,
            Integer lineItemKey,
            List<String> dynamicOptionSkus,
            ConfigurationModel configuration,
            ProductModel parentProduct) {
            this.quote = quote;
            this.parentProduct = parentProduct;
            this.lineItemKey = lineItemKey;
            this.dynamicOptionSkus = dynamicOptionSkus;
            this.configuration = configuration;
        }
    }
}
```

Anonymous Apex 사용 예 (PDF verbatim):

```apex
QuoteModel quote; //Use Read, Add Products, or Calculate APIs to obtain a QuoteModel
ProductModel product; //Use Read Product or Configuration Loader API to obtain a ProductModel
LoadRuleRunner runner = new LoadRuleRunner();
ProductModel product = runner.load('a0x5C000000G1CV', quote, null, null,
    product.configuration, null);
System.debug(product);
```

---

### Configuration Validator API

입력 구성 모델에 대해 선택(selection)·검증(validation)·알림(alert) 제품 규칙과 configurator 범위 가격 규칙(configurator-scoped price rules)을 실행하고, 갱신된 구성 모델을 반환한다.

| 속성 | 값 |
|---|---|
| Service Provider | `SBQQ.ConfigAPI.ConfigurationValidator` |
| HTTP Method | PATCH |
| Formats | JSON, Apex |
| EDITIONS | Salesforce CPQ, Spring '17 and later |

**Request 파라미터**

| Name | Type | Required/Optional | Description |
|---|---|---|---|
| `uid` | String | Required | ID of the Product2 record |
| `quote` | QuoteModel | Required | Corresponds directly to SBQQ__Quote__c. |
| `configuration` | ConfigurationModel | Required | The product's configuration data. |
| `event` | String | Required | Event type of product and price rules to run. Options are "Load", "Save", "Edit", and "Always". |
| `upgradedAssetId` | String | Optional | Asset ID when upgrading a bundle. |

**Response**

| Type | Description |
|---|---|
| ConfigurationModel | The product's configuration data. This is the same Configuration Model that was passed in the request, but the data will be changed based on Product Actions from Product and Price Rules that ran. See [[CPQ API Models]]. |

**REST 호출 (curl)**

```bash
curl \
"https://yourInstance.salesforce.com/services/apexrest/SBQQ/ServiceRouter?loader=SBQQ.ConfigAPI.ConfigurationValidator&uid=a0x5C000000G1CV" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer yourAuthorizationToken" \
-X PATCH \
-d "@configValidatorContext.json"
```

> 주: PDF 원문 curl 첫 줄 URL의 닫는 따옴표가 누락돼 있고 마지막 `-d` 값이 curly quote였다 [sic]. 위 블록은 동작 가능하도록 straight quote로 정규화했다. 식별자·의미는 원문과 동일.

요청 본문 `configValidatorContext.json` (quote model + configuration model + event type) — PDF verbatim:

```json
{"context":"{\"quote\":{\"record\":{\"attributes\":{\"type\":\"SBQQ__Quote__c\"},
\"Account__c\":\"0012F00000ayBPwQAM\",
\"Id\":\"a0z2F000000xGLpQAM\",
\"PricebookId__c\":\"01s2F0000011yApQAI\",
\"CurrencyIsoCode\":\"USD\"}},
\"configuration\":{\"validationMessages\":[],
\"priceEditable\":false,
\"optionData\":{\"attributes\":{\"type\":\"SBQQ__ProductOption__c\"}},
\"optionConfigurations\":[{\"validationMessages\":[],
\"priceEditable\":false,
\"optionId\":\"a0o2F000001Yi4JQAS\",
\"optionData\":{\"attributes\":{\"type\":\"SBQQ__ProductOption__c\",
\"url\":\"\/services\/data\/v48.0\/sobjects\/ProductOption__c\/a0o2F000001Yi4JQAS\"},
\"ConfiguredSKU__c\":\"01t2F000004XoPLQA0\",
\"Id\":\"a0o2F000001Yi4JQAS\",
\"OwnerId\":\"0056100000148O6AAI\",
\"IsDeleted\":false,
\"CurrencyIsoCode\":\"USD\",
\"SystemModstamp\":\"2020-03-10T20:47:39.000+0000\",
\"AppliedImmediately__c\":false,
\"Bundled__c\":false,
\"DiscountedByPackage__c\":false,
\"Number__c\":1,
\"OptionalSKU__c\":\"01t4M000003ru2PQAQ\",
\"PriceEditable__c\":\"No\",
\"ProductConfigurationType__c\":\"Allowed\",
\"ProductName__c\":\"Nested Option Product #1\",
\"QuantityEditable__c\":true,
\"Quantity__c\":1,
\"Required__c\":false,
\"Selected__c\":true,
\"System__c\":false,
\"Type__c\":\"Component\",
\"UpliftedByPackage__c\":false,
\"CanOrderSeparately__c\":false},
\"optionConfigurations\":[],
\"isUpgrade\":false,
\"isDynamicOption\":false,
\"configuredProductId\":\"01t2F000004XoPLQA0\",
\"configured\":false,
\"configurationEntered\":false,
\"configurationData\":{\"attributes\":{\"type\":\"SBQQ__ProductOption__c\"}},
\"changedByProductActions\":false}],
\"isUpgrade\":false,
\"isDynamicOption\":false,
\"configuredProductId\":\"01t2F000004XoPLQA0\",
\"configured\":false,
\"configurationEntered\":false,
\"configurationData\":{\"attributes\":{\"type\":\"SBQQ__ProductOption__c\"}},
\"changedByProductActions\":false},
\"event\":\"Edit\"}"}
```

응답 본문 (제품 구성 데이터) — PDF verbatim:

```json
{
"validationMessages": ["Incorrect quantity for Product A"],
"priceEditable": false,
"optionId": null,
"optionData": {
"attributes": {
"type": "SBQQ__ProductOption__c"
}
},
"optionConfigurations": [],
"listPrice": null,
"isUpgrade": false,
"isDynamicOption": false,
"inheritedConfigurationData": null,
"hiddenOptionIds": null,
"dynamicOptionKey": null,
"disabledOptionIds": null,
"configuredProductId": "01t3D000005Th8oQAC",
"configured": false,
"configurationData": {
"attributes": {
"type": "SBQQ__ProductOption__c"
},
"SBQQ__UnitPrice__c": null
},
"changedByProductActions": false
}
```

> 주: PDF 원문 응답 JSON에서 type 값이 `SBQQ_ProductOption_c`, 필드가 `SBQQ_UnitPrice_c`로 추출됐다(pdftotext가 이중밑줄 `__`를 단일밑줄로 떨어뜨린 것 [sic]). 정확한 API 표기는 `SBQQ__ProductOption__c` · `SBQQ__UnitPrice__c`이며 위 블록은 정확 표기로 복원했다.

**Apex 예제 클래스 `ConfigValidator`** (PDF verbatim) — *Before saving the ConfigValidator example class, make sure that the CPQ Models classes are added as individual Apex classes in your org.*

```apex
public with sharing class ConfigValidator {
    public ConfigurationModel load(
        Id productId,
        QuoteModel quote,
        ConfigurationModel configuration,
        String event,
        String upgradedAssetId) {
        ValidatorContext ctx = new ValidatorContext(
            quote,
            configuration,
            event,
            upgradedAssetId);
        String configJSON = SBQQ.ServiceRouter.load('SBQQ.ConfigAPI.ConfigurationValidator',
            productId, JSON.serialize(ctx));
        return (ConfigurationModel) JSON.deserialize(configJSON, ConfigurationModel.class);
    }
    private class ValidatorContext {
        private QuoteModel quote;
        private ConfigurationModel configuration;
        private String event;
        private String upgradedAssetId;
        public ValidatorContext(
            QuoteModel quote,
            ConfigurationModel configuration,
            String event,
            String upgradedAssetId) {
            this.quote = quote;
            this.configuration = configuration;
            this.event = event;
            this.upgradedAssetId = upgradedAssetId;
        }
    }
}
```

Anonymous Apex 사용 예 (PDF verbatim):

```apex
QuoteModel quote; //Use Read, Add Products, or Calculate APIs to obtain a QuoteModel
ProductModel product; //Use Read Product or Configuration Loader API to obtain a ProductModel
ConfigValidator validator = new ConfigValidator();
ConfigurationModel config = validator.load('01t2F000004XoPLQA0', quote,
    product.configuration, 'Edit', null);
System.debug(config);
```

---

## CPQ Contract API

> **EDITIONS** — Available in Salesforce CPQ, Summer '16 and later.

CPQ 견적을 수정(amend)·갱신(renew)하는 데 사용한다. PDF 원문:

> Use CPQ Contract API to amend and renew CPQ quotes.
> - **Contract Amender API** — Receive a CPQ contract ID in a request, and return quote data for an amendment quote.
> - **Contract Renewer API** — Receive a CPQ contract in a request, and return quote information for one or more renewal quotes.

---

### Contract Amender API

요청으로 CPQ contract ID를 받아 amendment quote(수정 견적) 데이터를 반환한다.

| 속성 | 값 |
|---|---|
| Service Provider | `SBQQ.ContractManipulationAPI.ContractAmender` |
| HTTP Method | PATCH |
| Formats | JSON, Apex |
| EDITIONS | Salesforce CPQ, Summer '16 and later |

**Special Access Rules** — 아래 사용자 권한이 **모두** 필요하다:
- Create on Opportunity
- Read on Quote, Opportunity, and Product2
- Insert and update on Quote and Opportunity
- Delete on Quote and Opportunity

> **Important:** Without full access on Opportunity, an error results, and contract amendment fails.

**Request 파라미터**

| # | Name | Type | Required | Available in | Description |
|---|---|---|---|---|---|
| Parameter 1 | `uid` | String | Yes | — | 15-character case sensitive or 18-character case insensitive Salesforce Contract ID to amend. |
| Parameter 2 | `AmendmentContext` | AmendmentContext | No | Salesforce CPQ Winter '21 and later | Context for the contract to amend. |

**Response**

| Type | Description |
|---|---|
| QuoteModel | Representation of SBQQ__Quote__c data for an amendment quote |

**REST 호출 (curl)** (PDF verbatim):

```bash
curl \
"https://yourInstance.salesforce.com/services/apexrest/SBQQ/ServiceRouter?loader=SBQQ.ContractManipulationAPI.ContractAmender&uid=800R00000000X4g" \
-H "Content-Type: application/json" -H "Authorization: Bearer token" -X PATCH
```

응답 본문 예 1 (amend 후) — PDF verbatim (`lineItems` 배열이 닫히지 않고 `"lineItemGroups"`가 옴 [sic]):

```json
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
"url":
"/services/data/v41.0/sobjects/SBQQ__QuoteLine__c/a0l61000003u09UAAQ"
},
"Id": "a0l61000003u09UAAQ"
}
}
"lineItemGroups": [ ]
}
```

응답 본문 예 2 (amend 후) — PDF verbatim:

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

**Apex 예제 클래스 `ContractAmender` (amendment context 미사용)** (PDF verbatim) — *Before saving the ContractAmender example class, make sure that the CPQ model classes are added as individual Apex classes in your org. In this example, the amendment context isn't used.*

```apex
public with sharing class ContractAmender {
    public QuoteModel load(String contractId) {
        String quoteJSON =
            SBQQ.ServiceRouter.load('SBQQ.ContractManipulationAPI.ContractAmender', contractId, null);
        return (QuoteModel) JSON.deserialize(quoteJSON, QuoteModel.class);
    }
}
ContractAmender amender = new ContractAmender();
QuoteModel quote = amender.load('8001D000000AUlg'); // example id
System.debug(quote);
```

**Apex 예제 클래스 `ContractAmenderTest` (amendment context 사용)** (PDF verbatim) — *In this example, the amendment context is used.*

```apex
public with sharing class ContractAmenderTest {
    public QuoteModel load(String contractId, String context) {
        String quoteJSON =
            SBQQ.ServiceRouter.load('SBQQ.ContractManipulationAPI.ContractAmender', contractId, context);
        return (QuoteModel) JSON.deserialize(quoteJSON, QuoteModel.class);
    }
}
// Create an amendment context
private with sharing class AmendmentContextTest {
    public Boolean returnOnlyQuoteId;
}
AmendmentContextTest context = new AmendmentContextTest();
context.returnOnlyQuoteId = true;
// Invoke the ContractAmender API
String contextJson = JSON.serialize(context);
ContractAmenderTest amender = new ContractAmenderTest();
QuoteModel quote = amender.load('CONTRACT_ID', contextJson);
```

`returnOnlyQuoteId = true`일 때 응답 본문 예 (PDF verbatim):

```json
{"attributes":{"type":"SBQQ__Quote__c","url":"/services/data/v50.0/sobjects/SBQQ__Quote__c/12345"},"Id":"12345"}
```

---

### Contract Renewer API

요청으로 CPQ contract를 받아 하나 이상의 renewal quote(갱신 견적) 정보를 반환한다.

| 속성 | 값 |
|---|---|
| Service Provider | `SBQQ.ContractManipulationAPI.ContractRenewer` |
| HTTP Method | PATCH (단, REST 예제 curl은 `-X POST` 사용 — [sic] 아래 참조) |
| Formats | JSON, Apex |
| EDITIONS | Salesforce CPQ, Summer '16 and later |

> **Important:** Where possible, we changed noninclusive terms to align with our company value of Equality. Because changing terms in our code can break current implementations, we maintained this metadata type's name.

**Special Access Rules** — 아래 사용자 권한이 **모두** 필요하다:
- Insert and update on quote and opportunity objects
- Read on quote, opportunity, and product2 objects
- Delete on quote object

**Request 파라미터·속성**

| 구분 | Name | Type | Required | Available in | Description |
|---|---|---|---|---|---|
| Parameter 1 | `context` | RenewalContext | Yes | — | JSON object containing the contracts to renew. Include the IDs of each contract to renew. If there's more than one contract, include the ID of the contract to use as the main contract. |
| Attribute 1 | `masterContractId` | Id | No | — | If you're renewing multiple contracts, specify the ID of the main contract. |
| Attribute 2 | `renewedContracts` | ContractModel[] | Yes | — | One or more ContractModels to renew. |
| Attribute 3 | `returnOnlyQuoteId` | boolean | No | Salesforce CPQ Winter '21 and later | If true, return the ID of the renewed quotes. If false or null, return the information for the renewed quotes. Default value is false. |

**Response** (두 가지)

| 조건 | Type | Description |
|---|---|---|
| `returnOnlyQuoteId` is false or null | QuoteModel[] | Representation of one or more SBQQ__Quote__c data for renewal quotes. |
| `returnOnlyQuoteId` is true | integer | The ID of the SBQQ__Quote__c record. |

**REST 호출 (curl)** (PDF verbatim):

```bash
curl \
"https://yourInstance.salesforce.com/services/apexrest/SBQQ/ServiceRouter?loader=SBQQ.ContractManipulationAPI.ContractRenewer" \
-H "Content-Type: application/json" -H "Authorization: Bearer token" -X POST -d \
@context.json
```

> 주: EDITIONS 박스에는 HTTP Method가 PATCH로 적혀 있으나 curl 예제는 `-X POST`를 쓴다 — PDF 원문 그대로 [sic].

요청 본문 `context.json` (PDF verbatim):

```json
{"context": "{\"masterContractId\": null, \"renewedContracts\":
[{\"attributes\":{\"type\":\"Contract\"},\"Id\":\"800540000006LLVAA2\"}]}"}
```

응답 본문 (renew 후) — PDF verbatim (`lineItems` 미닫힘 [sic]):

```json
[{
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
"url":
"/services/data/v41.0/sobjects/SBQQ__QuoteLine__c/a0l61000003u09UAAQ"
},
"Id": "a0l61000003u09UAAQ"
}
}
"lineItemGroups": [ ]
}]
```

**Apex 예제 클래스 `ContractRenewer`** (PDF verbatim) — *Before saving the ContractRenewer example class, ensure that you've created individual Apex classes for your CPQ models.*

```apex
// Define a class to hold information about the contracts to renew
private with sharing class CreateRenewalContext {
    public Id masterContractId;
    public Contract[] renewedContracts;
    public Boolean returnOnlyQuoteId;
}
//define a class to hold the serialized context and the returned quote information
public with sharing class ContractRenewer {
    public QuoteModel[] load(String masterContractId, String serializedContext) {
        String quotesJSON =
            SBQQ.ServiceRouter.load('SBQQ.ContractManipulationAPI.ContractRenewer', masterContractId,
                serializedContext);
        return (QuoteModel[]) JSON.deserialize(quotesJSON, List<QuoteModel>.class);
    }
}
// populate the renewal context
CreateRenewalContext context = new CreateRenewalContext();
context.masterContractId = '4567';
context.renewedContracts = [SELECT Id FROM Contract WHERE Id IN ('4567', '8910')];
// Set returnOnlyQuoteId to true if you only want the Quote ID and not the entire Quote model.
context.returnOnlyQuoteId = true;

// Serialized the renewal context
// For example, context = '{"masterContractId": "8001D000000AUlg", "renewedContracts":
//[{"attributes":{"type":"Contract"},"Id":"8001D000000AUlg"},
// {"attributes":{"type":"Contract"},"Id":"8001D000000AVGt"}]}';
String jsonContext = JSON.serialize(context);
// renew the two contracts
ContractRenewer renewer = new ContractRenewer();
QuoteModel[] quotes = renewer.load(null, jsonContext);
```

`returnOnlyQuoteId = true`일 때 응답 본문 예 (PDF verbatim):

```json
{"attributes":{"type":"SBQQ__Quote__c","url":"/services/data/v50.0/sobjects/SBQQ__Quote__c/123456"},"Id":"56789"}
```

---

## 관련 노트
- [[CPQ API Models]] — 이 API들이 입출력으로 사용하는 11개 데이터 모델(QuoteModel · ProductModel · ConfigurationModel 등)을 Apex 클래스로 정의하는 방법
- [[CPQ Quote API]] — 견적 Read/Add/Calculate/Save API. `SBQQ.ServiceRouter` 메서드 시그니처 상세
- [[CPQ 기타 API — Document·Router·Quickstart·Triggers·Approvals]] — Generate Quote Document · Service Router · API Quickstart · Disable CPQ Triggers · Advanced Approvals API
