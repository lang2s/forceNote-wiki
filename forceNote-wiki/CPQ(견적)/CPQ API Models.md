---
tags: [CPQ, Salesforce CPQ, SBQQ, API Models, 데이터모델, 견적, Apex]
source: cpq_developer_guide.pdf (Salesforce CPQ Developer Guide, v65.0 Winter '26)
created: 2026-06-21
aliases: [CPQ API Models, CPQ 데이터 모델, SBQQ 모델 클래스, QuoteModel 필드, QuoteLineModel, OptionModel, ConfigurationModel, ProductModel, QuoteProposalModel, QuoteTermModel, 견적 라인 모델, CPQ 모델 클래스, SBQQ 모델, "QuoteModel 필드가 뭐야", "CPQ API 모델 만들기"]
---

# CPQ API Models

> Salesforce CPQ(managed package, `SBQQ.*`) API가 사용하는 11개 데이터 모델 — 각 모델을 Apex 클래스로 org에 직접 정의해 CPQ Quote/Configuration/Contract API에 전달한다.

CPQ API를 사용하려면 각 데이터 모델에 대응하는 Apex 클래스를 org에 직접 만들어야 한다. 아래 11개 모델은 견적(Quote) · 견적 라인(Quote Line) · 번들 구성(Configuration) · 제품(Product) · 견적서 문서(Quote Proposal) · 견적 조항(Quote Term)을 표현한다.

**EDITIONS** — 모든 모델 공통: Available in Salesforce CPQ, Summer '16 and later. (CPQ API Models 인덱스 페이지 자체만 Spring '17 and later로 표기되며, 개별 모델은 모두 Summer '16 and later다.)

> 이 문서가 다루는 CPQ는 managed package 제품(`SBQQ` 네임스페이스)이다. Salesforce의 후속 platform-native 제품인 RLM(Revenue Lifecycle Management / Revenue Cloud, `PlaceQuote` · `RevSalesTrxn` 네임스페이스)과는 **별개 제품**이다. 혼동 주의.

---

## 모델 중첩 관계

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (PDF에 다이어그램 없음, 필드 타입으로부터 도출)

QuoteModel
├─ lineItems        : QuoteLineModel[]
└─ lineItemGroups   : QuoteLineGroupModel[]

ProductModel
├─ options                          : OptionModel[]
├─ features                         : FeatureModel[]
├─ configuration                    : ConfigurationModel
├─ configurationAttributes          : ConfigAttributeModel[]
├─ inheritedConfigurationAttributes : ConfigAttributeModel[]
└─ constraints                      : ConstraintModel[]

ConfigurationModel
├─ optionData                  : SBQQ__ProductOption__c
├─ configurationData           : SBQQ__ProductOption__c
├─ inheritedConfigurationData  : SBQQ__ProductOption__c
└─ optionConfigurations        : ConfigurationModel[]   (재귀 — 중첩 번들)
```

---

## QuoteLineModel

견적 라인(quote line) 데이터 모델을 표현한다.

| Name | Type | Description |
|---|---|---|
| record | SBQQ__QuoteLine__c | The record that this model represents. |
| amountDiscountProrated | Boolean | Corresponds to SBQQ__QuoteLine__c.ProrateAmountDiscount__c. |
| parentGroupKey | Integer | The unique key of this line's group, if this line is part of a grouped quote. |
| parentItemKey | Integer | The unique key of this line's parent, if this line is part of a bundle. |
| key | Integer | Each quote line and group has a key that is unique amongst all other keys in the same quote. |
| upliftable | Boolean | True if this line is an MDQ segment that can be uplifted from a previous segment. |
| configurationType | String | Indicates the configuration type of the product that this line represents. |
| configurationEvent | String | Indicates the configuration event of the product that this line represents. |
| reconfigurationDisabled | Boolean | If true, this line cannot be reconfigured. |
| descriptionLocked | Boolean | If true, this line's description cannot be changed. |
| productQuantityEditable | Boolean | If true, this line's quantity is editable. |
| productQuantityScale | Decimal | The number of decimal places used for rounding this line's quantity. |
| dimensionType | String | The type of MDQ dimension that this line represents. |
| productHasDimensions | Boolean | If true, the underlying product can be represented as a multidimensional line. |
| targetCustomerAmount | Decimal | The unit price for which this quote line is discounted. |
| targetCustomerTotal | Decimal | The customer amount for which this quote line is discounted. |

```apex
public class QuoteLineModel {
public SBQQ__QuoteLine__c record;
public Boolean amountDiscountProrated;
public Integer parentGroupKey;
public Integer parentItemKey;
public Integer key;
public Boolean upliftable;
public String configurationType;
public String configurationEvent;
public Boolean reconfigurationDisabled;
public Boolean descriptionLocked;
public Boolean productQuantityEditable;
public Decimal productQuantityScale;
public String dimensionType;
public Boolean productHasDimensions;
public Decimal targetCustomerAmount;
public Decimal targetCustomerTotal;
}
```

---

## QuoteLineGroupModel

견적 라인 그룹(quote line group) 데이터 모델을 표현한다.

| Name | Type | Description |
|---|---|---|
| record | SBQQ__QuoteLineGroup__c | The record that this model represents. |
| netNonSegmentTotal | Decimal | The net total for all non-multidimensional quote lines. |
| key | Integer | Each quote line and group has a key that is unique amongst all other keys in the same quote. |

```apex
public class QuoteLineGroupModel {
public SBQQ__QuoteLineGroup__c record;
public Decimal netNonSegmentTotal;
public Integer key;
}
```

---

## OptionModel

제품 옵션(product option) 데이터 모델을 표현한다.

| Name | Type | Description |
|---|---|---|
| record | SBQQ__ProductOption__c | The record that this model represents. |
| externalConfigurationData | Map\<String,String\> | Internal property for the external configurator feature. |
| configurable | Boolean | Indicates whether the option is configurable. |
| configurationRequired | Boolean | Indicates whether the configuration of the option is required. |
| quantityEditable | Boolean | Indicates whether the quantity is editable. Editability is determined by the quantity and bundled fields on the option record. |
| priceEditable | Boolean | Indicates whether the price is editable. Editability is determined by the price editable field on the product record and the bundled field on the option record. |
| productQuantityScale | Decimal | Returns the value of the quantity scale field for the product being configured. |
| priorOptionExists | Boolean | Checks if this option is an asset on the account that the quote is associated with. |
| dependentIds | Set\<Id\> | The option IDs that depend on this option. |
| controllingGroups | Map\<String,Set\<Id\>\> | The option IDs that this option depends on. |
| exclusionGroups | Map\<String,Set\<Id\>\> | The option IDs that this option is exclusive with. |
| reconfigureDimensionWarning | String | Reconfigures the warning label for an option with segments. |
| hasDimension | Boolean | Indicates whether this option has dimensions or segments. |
| isUpgrade | Boolean | Indicates whether the product option is related to an upgrade product. |
| dynamicOptionKey | String | Internal property for dynamic options. |

```apex
public class OptionModel {
public SBQQ__ProductOption__c record;
public Map<String,String> externalConfigurationData;
public Boolean configurable;
public Boolean configurationRequired;
public Boolean quantityEditable;
public Boolean priceEditable;
public Decimal productQuantityScale;
public Boolean priorOptionExists;
public Set<Id> dependentIds;
public Map<String,Set<Id>> controllingGroups;
public Map<String,Set<Id>> exclusionGroups;
public String reconfigureDimensionWarning;
public Boolean hasDimension;
public Boolean isUpgrade;
public String dynamicOptionKey;
}
```

---

## FeatureModel

제품 피처(product feature) 데이터 모델을 표현한다.

| Name | Type | Description |
|---|---|---|
| record | SBQQ__ProductFeature__c | The record that this model represents. |
| instructionsText | String | Instruction label for the feature. |
| containsUpgrades | Boolean | This feature is related to an upgrade product. |

```apex
public class FeatureModel {
public SBQQ__ProductFeature__c record;
public String instructionsText;
public Boolean containsUpgrades;
}
```

---

## ConfigAttributeModel

구성 속성(configuration attribute) 객체 — `SBQQ__ConfigurationAttribute__c` — 를 표현한다.

> [!note] PDF 결함 교정 — 객체명·필드명 오타
> 이 모델의 필드표 "Corresponds directly to ..." 항목은 PDF 원문에서 대상 객체명이 행마다 다르게 깨져 있다(예: `SBQQ__ConfigurationAtribute__c`, `SBQQ__ConifgurationAtribute__c`, `SBQQ__ConifguraitonAtirbute__c`). 정식 객체명은 **`SBQQ__ConfigurationAttribute__c`** 하나이며 아래 표는 이를 교정해 표기했다. 일부 대상 필드명 오타도 함께 교정했다: `SBQQ__Positon__c` → `SBQQ__Position__c`, `SBQQ__AppiledImmediately__c` → `SBQQ__AppliedImmediately__c`, `SBQQ__ApplyToProductOpitons__c` → `SBQQ__ApplyToProductOptions__c`.
> 단, 아래 **Apex 코드 블록의 `colmnOrder`(columnOrder 오타)는 PDF 원문 그대로 [sic] 보존**한다(Apex 코드는 verbatim 인용 — org에서 모델 클래스를 만들 때 PDF가 명시한 멤버명을 그대로 따라야 호환되기 때문).

| Name | Type | Description (Corresponds directly to — 객체명 교정 적용) |
|---|---|---|
| name | String | SBQQ__ConfigurationAttribute__c.Name |
| targetFieldName | String | SBQQ__ConfigurationAttribute__c.SBQQ__TargetField__c |
| displayOrder | Decimal | SBQQ__ConfigurationAttribute__c.SBQQ__DisplayOrder__c |
| columnOrder | String | SBQQ__ConfigurationAttribute__c.SBQQ__ColumnOrder__c |
| required | Boolean | SBQQ__ConfigurationAttribute__c.SBQQ__Required__c |
| featureId | Id | SBQQ__ConfigurationAttribute__c.SBQQ__Feature__c |
| position | String | SBQQ__ConfigurationAttribute__c.SBQQ__Position__c |
| appliedImmediately | Boolean | SBQQ__ConfigurationAttribute__c.SBQQ__AppliedImmediately__c |
| applyToProductOptions | Boolean | SBQQ__ConfigurationAttribute__c.SBQQ__ApplyToProductOptions__c |
| autoSelect | Boolean | SBQQ__ConfigurationAttribute__c.SBQQ__AutoSelect__c |
| shownValues | String[] | SBQQ__ConfigurationAttribute__c.SBQQ__ShownValues__c |
| hiddenValues | String[] | SBQQ__ConfigurationAttribute__c.SBQQ__HiddenValues__c |
| hidden | Boolean | SBQQ__ConfigurationAttribute__c.SBQQ__Hidden__c |
| noSuchFieldName | String | If no field with the target name exists, the target name is stored here. |
| myId | String | SBQQ__ConfigurationAttribute__c.Id |

```apex
public class ConfigAttributeModel {
public String name;
public String targetFieldName;
public Decimal displayOrder;
public String colmnOrder;
public Boolean required;
public Id featureId;
public String position;
public Boolean appliedImmediately;
public Boolean applyToProductOptions;
public Boolean autoSelect;
public String[] shownValues;
public String[] hiddenValues;
public Boolean hidden;
public String noSuchFieldName;
public Id myId;
}
```

> 위 Apex 코드의 `public String colmnOrder;`는 PDF 원문 그대로의 오타다 [sic]. 필드표의 논리적 필드명은 `columnOrder`이지만 PDF가 제시한 Apex 멤버명은 `colmnOrder`이므로 verbatim 보존한다.

---

## ConfigurationModel

번들 제품(bundle product) — 옵션 구성 상태 — 을 표현한다. `optionConfigurations`를 통해 자기 자신을 재귀적으로 중첩한다(중첩 번들).

| Name | Type | Description |
|---|---|---|
| configuredProductId | Id | The Product2.Id. |
| optionId | Id | The SBQQ__ProductOption__c.Id. |
| optionData | SBQQ__ProductOption__c | Editable data about the option, such as quantity or discount. |
| configurationData | SBQQ__ProductOption__c | Stores the values of the configuration attributes. |
| inheritedConfigurationData | SBQQ__ProductOption__c | Stores the values of the inherited configuration attributes. |
| optionConfigurations | ConfigurationModel[] ¹ | Stores the options selected on this product. |
| configured | Boolean | Indicates whether the product has been configured. |
| changedByProductActions | Boolean | Indicates whether a product action changed the configuration of this bundle. |
| isDynamicOption | Boolean | Indicates whether the product was configured using a dynamic lookup. |
| isUpgrade | Boolean | Queries whether this product is an upgrade. |
| disabledOptionIds | Set\<Id\> | The option IDs that are disabled. |
| hiddenOptionIds | Set\<Id\> | The option IDs that are hidden. |
| listPrice | Decimal | The list price. |
| priceEditable | Boolean | Indicates whether the price is editable. |
| validationMessages | String[] | Validation messages. |
| dynamicOptionKey | String | Internal property for dynamic options. |

¹ PDF 필드표는 `optionConfigurations`의 타입을 `ConfigurationModel`로 표기하나 Apex 코드는 **`ConfigurationModel[]`** (배열)이다 — Apex 코드를 권위 소스로 채택한다.

```apex
public class ConfigurationModel {
public Id configuredProductId;
public Id optionId;
public SBQQ__ProductOption__c optionData; // Editable data about the option in question, such as quantity or discount
public SBQQ__ProductOption__c configurationData;
public SBQQ__ProductOption__c inheritedConfigurationData;
public ConfigurationModel[] optionConfigurations;
public Boolean configured;
public Boolean changedByProductActions;
public Boolean isDynamicOption;
public Boolean isUpgrade;
public Set<Id> disabledOptionIds;
public Set<Id> hiddenOptionIds;
public Decimal listPrice;
public Boolean priceEditable;
public String[] validationMessages;
public String dynamicOptionKey;
}
```

---

## ConstraintModel

옵션 제약(option constraint) 객체 — `SBQQ__OptionConstraint__c` — 를 표현한다.

| Name | Type | Description |
|---|---|---|
| record | SBQQ__OptionConstraint__c | The record that this model represents. |
| priorOptionExists | Boolean | Checks if this option is an asset on the account that the quote is associated with. |

```apex
public class ConstraintModel {
public SBQQ__OptionConstraint__c record;
public Boolean priorOptionExists;
}
```

---

## ProductModel

제품(product) 데이터 모델을 표현한다. 옵션 · 피처 · 구성 · 구성 속성 · 제약을 하위 모델로 보유한다.

| Name | Type | Description |
|---|---|---|
| record | Product2 | The record that this model represents. |
| upgradedAssetId | Id | Provides a source for SBQQ__QuoteLine__c.SBQQ__UpgradedAsset__c. |
| currencySymbol | String | The symbol for the currency in use. |
| currencyCode | String | The ISO code for the currency in use. |
| featureCategories | String[] | Allows users to sort product features by category. |
| options | OptionModel[] | A list of all available options for this product. |
| features | FeatureModel[] ¹ | All features available for this product. |
| configuration | ConfigurationModel | An object representing this product's current configuration. |
| configurationAttributes | ConfigAttributeModel[] | All configuration attributes available for this product. |
| inheritedConfigurationAttributes | ConfigAttributeModel[] | All configuration attributes that this product inherits from ancestor products. |
| constraints | ConstraintModel[] | Option constraints on this product. |

¹ PDF 필드표는 `features`의 타입을 `FeatureModel`로 표기하나 Apex 코드는 **`FeatureModel[]`** (배열)이다 — Apex 코드를 권위 소스로 채택한다.

```apex
public class ProductModel {
public Product2 record;
public Id upgradedAssetId;
public String currencySymbol;
public String currencyCode;
public String[] featureCategories;
public OptionModel[] options;
public FeatureModel[] features;
public ConfigurationModel configuration;
public ConfigAttributeModel[] configurationAttributes;
public ConfigAttributeModel[] inheritedConfigurationAttributes;
public ConstraintModel[] constraints;
}
```

---

## QuoteModel

CPQ 견적(quote) 데이터 모델을 표현한다. 견적 라인과 그룹을 하위 모델로 보유한다.

| Name | Type | Description |
|---|---|---|
| record | SBQQ__Quote__c | The record that this model represents. |
| lineItems | QuoteLineModel[] | The lines that this quote contains. |
| lineItemGroups | QuoteLineGroupModel[] | The groups that this quote contains. |
| nextKey | Integer | The next key to use for new groups or lines. To keep keys unique, do not lower this value. |
| applyAdditionalDiscountLast | Boolean | Corresponds to the field SBQQ__Quote__c.ApplyAdditionalDiscountLast__c. |
| applyPartnerDiscountFirst | Boolean | Corresponds to the field SBQQ__Quote__c.ApplyPartnerDiscountFirst__c. |
| channelDiscountsOffList | Boolean | Corresponds to the field SBQQ__Quote__c.ChannelDiscountsOfList__c. ¹ |
| customerTotal | Decimal | SBQQ__Quote__c.SBQQ__CustomerAmount__c is a roll-up summary field, so its accuracy is guaranteed only after a quote has been saved. In the meantime, its current value is stored in customerTotal. |
| netTotal | Decimal | SBQQ__Quote__c.SBQQ__NetAmount__c is a roll-up summary field, so its accuracy is guaranteed only after a quote has been saved. In the meantime, its current value is stored in netTotal. |
| netNonSegmentTotal | Decimal | The net total for all non-multidimensional quote lines. |

¹ 대응 필드 API명이 PDF 원문에 `ChannelDiscountsOfList__c`로 표기돼 있다 — `Off`가 아니라 `Of`로 한 글자 빠진 형태다 [sic]. 모델 멤버명은 `channelDiscountsOffList`(Off)이지만 대응 필드는 원문 그대로 보존한다.

```apex
public class QuoteModel {
public SBQQ__Quote__c record;
public QuoteLineModel[] lineItems;
public QuoteLineGroupModel[] lineItemGroups;
public Integer nextKey;
public Boolean applyAdditionalDiscountLast;
public Boolean applyPartnerDiscountFirst;
public Boolean channelDiscountsOffList;
public Decimal customerTotal;
public Decimal netTotal;
public Decimal netNonSegmentTotal;
}
```

---

## QuoteProposalModel

견적서 문서(quote document)를 표현한다.

| Name | Type | Description |
|---|---|---|
| name | String | The document name. |
| paperSize | String | The paper size. Possible values are: Default · Letter · Legal · A4. Defaults to **Default**. |
| outputFormat | String | The output format. Possible values are: pdf · word. Defaults to **pdf**. |
| quoteId | Id | The ID of your quote. |
| templateId | Id | The ID of your quote template. |
| language | String | The language code. Defaults to **en_US**. |

```apex
public class QuoteProposalModel {
public String name;
public Id quoteId;
public Id templateId;
public String language;
public String outputFormat;
public String paperSize;
}
```

---

## QuoteTermModel

견적 조항(quote term) 객체 — `SBQQ__QuoteTerm__c` — 를 표현한다.

| Name | Type | Description |
|---|---|---|
| id | Id | ID for the quote term. |
| label | String | For quote templates with multiple quote terms, this field defines the order in which the terms appear on the quote document. Terms are ordered from the lowest to highest value. |
| locked | Boolean | Defines whether sales reps can edit the quote term. Corresponds directly to SBQQ__QuoteTerm__c.SBQQ__Locked__c. |
| quoteId | Id | Allows users to relate the quote term to a specific quote. Left blank if the term applies to multiple quotes. Corresponds directly to SBQQ__QuoteTerm__c.SBQQ__Quote__c. |
| standardTermId | Id | If the quote term was created by clicking Modify Terms on the quote, standardTermId shows the original quote term's ID. Corresponds directly to SBQQ__QuoteTerm__c.SBQQ__StandardTerm__c. |
| type | String | Shows whether the term is **standard, modified, or custom**. Unmodified terms have a Type value of Standard. When a user clicks Modify Terms on a quote and changes the term, Salesforce CPQ creates a quote term with a Type value of Modified. Corresponds directly to SBQQ__QuoteTerm__c.SBQQ__Type__c. |
| value | String | Value of the quote term's Body field, or the translated value of the Body field when using CPQ translations. **Maximum 32,768 characters.** Corresponds directly to SBQQ__QuoteTerm__c.SBQQ__Body__c. |

```apex
public class QuoteTermModel {
public String value;
public String type;
public Id standardTermId;
public Id quoteId;
public Boolean locked;
public String label;
public Id id;
}
```

---

## 관련 노트
- [[CPQ Quote API]] — 위 모델을 입출력으로 사용하는 견적 API (Save / Calculate / Read / Validate / Add Products)
- [[CPQ Configuration·Contract API]] — 번들 구성(Loader/Executor/Validator) 및 계약 수정·갱신(Amender/Renewer) API. 위 모델을 입출력으로 사용
- [[CPQ 기타 API — Document·Router·Quickstart·Triggers·Approvals]] — 견적서 문서 생성·Service Router·API Quickstart·트리거 제어·Advanced Approvals API
- [[JavaScript Quote Calculator Plugin]] — 견적 계산 시점에 개입하는 JS 플러그인. 위 `QuoteModel`·`QuoteLineModel`을 `.record`로 다룬다
- [[CPQ Plugins — Search·Recommended·Configurator·기타]] — Product Search·Recommended·External Configurator·Custom Action·Electronic Signature 등 9개 plugin. Custom Action Plugin이 위 `QuoteModel`·`QuoteLineModel`을 다룬다
- [[PlaceQuote Namespace]] — RLM(Revenue Cloud) 견적 namespace. CPQ managed package와 별개 제품
- [[RevSalesTrxn Namespace]] — RLM(Revenue Cloud) 영업 트랜잭션 namespace. CPQ managed package와 별개 제품
