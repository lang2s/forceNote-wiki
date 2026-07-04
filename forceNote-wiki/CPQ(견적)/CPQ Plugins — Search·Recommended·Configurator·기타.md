---
tags: [CPQ, 견적, Salesforce CPQ, Plugin, Apex, Product Search Plugin, Recommended Products Plugin, External Configurator, Document Store Plugin, Electronic Signature Plugin, Custom Action Plugin, Guided Selling]
source: cpq_developer_guide.pdf (Salesforce CPQ Developer Guide v65.0 Winter '26); help.salesforce.com — Manage Trusted URLs (sf.csp_trusted_sites.htm, Tier 2); developer.salesforce.com — Content Security Policy Overview (lightning-components-security, Tier 2)
created: 2026-06-21
aliases: [Product Search Plugin, Recommended Products Plugin, Product Recommendation Plugin, External Configurator, Document Store Plugin, Electronic Signature Plugin, Custom Action Plugin, Legacy Quote Calculator Plugin, Guided Selling Plugin, CPQ 플러그인, 제품 검색 플러그인, 제품 추천 플러그인, 외부 컨피규레이터, 전자서명 플러그인]
---

# CPQ Plugins — Search·Recommended·Configurator·기타

> Salesforce CPQ가 제공하는 9개 확장 지점(plugin) — Product Search·Recommended Products·External Configurator·Legacy Quote Calculator·Guided Selling Initializer/Executor·Document Store·Custom Action·Electronic Signature — 의 인터페이스·메서드 시그니처·예제를 전수 정리한다.

> JavaScript Quote Calculator Plugin(QCP)은 가장 핵심적인 계산 plugin으로 분량이 커서 별도 노트([[JavaScript Quote Calculator Plugin]])로 분리한다. 이 노트는 그 외 9개 plugin을 다룬다.

---

## 1. Product Search Plugin

**목적:** Product Search 페이지와 Guided Selling 페이지의 product search 결과를 커스터마이즈하기 위해 구현하는 인터페이스. 메서드는 Product Search 구현과 Guided Selling 구현 간에 약간 다르다.

- **인터페이스:** `SBQQ.ProductSearchPlugin`
- **Namespace:** SBQQ
- **EDITIONS:** Available in All Salesforce CPQ Editions

> Date 필드는 `yyyy-mm-dd` 형식의 문자열로 반환된다. (양쪽 인터페이스 공통 Note)
> Product search plugin은 기본적으로 CPQ quote 필드의 일부만 사용할 수 있다. 필드를 전달받지 못하거나 null로 전달되면, quote model로 전달된 ID로 SOQL 쿼리를 통해 직접 가져와야 한다.

### 1-A. Product Search Interface (Product Search 페이지용)

**Usage 예:** Product Search에서 Last Ordered Date 최신순 내림차순으로 모든 결과를 반환하도록 구성할 수 있다. "Tablets" 검색 시 최신 Last Ordered Date 순으로 표시되며, 사용자는 Product Search 필터 패널로 추가 필터링이 가능하다.

**Method Order of Execution** (원문 그대로):

```text
//**The constructor is optional**//
* 1.0 Constructor()
* 2.0 FOREACH(Search Field){
*     2.1 isFilterHidden()
*     2.1 getFilterDefaultValue()
* }
* 3.0 isSearchCustom (CUSTOM vs ENHANCED)
* IF(isCustom){
*   4.0 search()
* }
* ELSE{
*     4.0 getAdditionalSearchFilters()
* }
```

1. Constructor는 먼저 호출될 수 있으나 필수는 아니다.
2. 각 search input마다 두 메서드를 호출한다 — `isFilterHidden`(quote line editor에서 input 숨김 여부 결정), `getFilterDefaultValue`(초기 검색 필드값 설정).
3. `isSearchCustom`으로 Custom/Enhanced 검색 여부를 결정한다.
4. True면 `search()`를 호출(Select/Where Clause를 직접 구성·쿼리 수행 — 전체 제어).
5. False면 `getAdditionalSearchFilters`를 호출(기존 SOQL 쿼리에 WHERE clause append).

**메서드 (Product Search):**

| 메서드 | Signature | 파라미터 | 반환 | 설명 |
|---|---|---|---|---|
| `getAdditionalSearchFilters` | `global String getAdditionalSearchFilters(SObject quote, Map<String,Object> fieldValuesMap)` | quote — SObject (현재 quote) / fieldValuesMap — Map<String,Object> (검색 조건 맵; Key=Product2 API name, value=원하는 검색값) | String — 추가 검색 필터, SOQL 형식 문자열. 예 `'AND Product2.Inventory_Level__c > 3'` | SOQL 쿼리에 WHERE clause를 append하여 사용자 검색 입력을 정제. `isSearchCustom`이 FALSE일 때만 호출 |
| `getFilterDefaultValue` | `global String getFilterDefaultValue(SObject quote, String fieldName)` | quote — SObject (현재 quote) / fieldName — String (메서드 출력 결정에 쓰이는 quote 필드) | String — 필터의 초기 검색 입력값으로 쓰이는 문자열 | 초기 검색 값 결정. 각 input 필드마다 호출 |
| `isFilterHidden` | `global Boolean isFilterHidden(SObject quote, String fieldName)` | quote — SObject (true/false 결정에 쓰이는 필드를 보유한 quote) / fieldName — String (true/false 결정 위해 테스트되는 필드) | Boolean — True면 필터 숨김, False면 사용자에게 보임 | UI에서 필터 가시성 결정. 각 search input 필드마다 호출 |
| `isSearchCustom` | `global Boolean isSearchCustom(SObject quote, Map<String,Object> fieldValuesMap)` | quote — SObject (현재 quote) / fieldValuesMap — Map<String,Object> (map key=Product2 API name, value=원하는 검색값) | Boolean — True=custom searching, False=enhanced searching | `isFilterHidden`·`getFilterDefaultValue` 이후 호출. True면 `search()` 호출, False면 `getAdditionalSearchFilters` 호출 |
| `search` | `global List<PricebookEntry> search(SObject quote, Map<String,Object> fieldValuesMap)` | quote — SObject (현재 quote) / fieldValuesMap — Map<String,Object> (map key=Product2 API name, value=원하는 검색값; non-null 값의 키만 포함) | List<PricebookEntry> | 사용자 검색 입력을 전체 override. `isSearchCustom`이 TRUE일 때만 호출 |

> 원문 [sic]: 메서드 설명에서 `getFilterDefaulValue`로 'l'이 빠진 표기가 등장한다. 실제 메서드명은 `getFilterDefaultValue`이다.

**예제 — getAdditionalSearchFilters** (Hardware family 제품에 inventory>3 추가 필터):

```apex
global String getAdditionalSearchFilters(SObject quote, Map<String, Object> fieldValuesMap)
{
    String additionalFilter = NULL;
    if(fieldValuesMap.get('Family') == 'Hardware') {
        additionalFilter = 'AND Product2.Inventory_Level__c > 3';
    }
    return additionalFilter;
}
```

**예제 — getFilterDefaultValue** (Quote Type이 Quote면 product family 필터를 Service로):

```apex
global String getFilterDefaultValue(SObject quote, String fieldName) {
    // This would set Product Family filter to Service if Quote Type is Quote
    return (fieldName == 'Family' && quote.SBQQ__Type__c. == 'Quote') ? 'Service' : null;
}
```

> 원문 [sic]: `quote.SBQQ__Type__c.` 끝에 마침표 오타가 있다(원문 그대로 인용).

**예제 — isFilterHidden** (Quote Status가 Approved면 Product Code 필터 숨김):

```apex
global Boolean isFilterHidden(SObject quote, String fieldName) {
    // This would hide Product Code filter if Quote Status is Approved
    return fieldName == 'ProductCode' && quote.SBQQ__Status__c. == 'Approved';
}
```

> 원문 [sic]: `quote.SBQQ__Status__c.` 끝에 마침표 오타가 있다.

**예제 — isSearchCustom** (정렬용 Search field가 정의·사용됐으면 True):

```apex
global Boolean isSearchCustom(SObject quote, Map<String,Object> fieldValuesMap) {
    // This would use CUSTOM mode if a Search field for sorting was defined and used
    return fieldValuesMap.get('Sort_By__c') != '';
}
```

**예제 — search** (price book entry 리스트 구성·반환):

```apex
global List<PricebookEntry> search(SObject quote, Map<String,Object> fieldValuesMap){
    // Get all possible filter fields from the search filter field set
    List<Schema.FieldSetMember> searchFilterFieldSetFields =
        SObjectType.Product2.FieldSets.SBQQ__SearchFilters.getFields();
    // Get all possible fields from the search result field set
    List<Schema.FieldSetMember> searchResultFieldSetFields =
        SObjectType.Product2.FieldSets.SBQQ__SearchResults.getFields();
    // Build the Select string
    String selectClause = 'SELECT ';
    for(Schema.FieldSetMember field : searchResultFieldSetFields) {
        selectClause += 'Product2.' + field.getFieldPath() + ', ';
    }
    selectClause += 'Id, UnitPrice, Pricebook2Id, Product2Id, Product2.Id';
    // Build the Where clause
    String whereClause = '';
    for(Schema.FieldSetMember field : searchFilterFieldSetFields) {
        if(!fieldValuesMap.containsKey(field.getFieldPath())) {
            continue;
        }
        if(field.getType() == Schema.DisplayType.String || field.getType() ==
            Schema.DisplayType.Picklist) {
            whereClause += 'Product2.' + field.getFieldPath() + ' LIKE \'%' +
                fieldValuesMap.get(field.getFieldPath()) + '%\' AND ';
        }
    }
    whereClause += 'Pricebook2Id = \'' + quote.get('SBQQ__Pricebook__c') + '\'';
    // Build the query
    String query = selectClause + ' FROM PricebookEntry WHERE ' + whereClause;
    // Perform the query
    List<PricebookEntry> pbes = new List<PricebookEntry>();
    pbes = Database.query(query);
    return pbes;
}
```

**예제 구현 클래스 — Product Search:**

```apex
global class ExampleProductSearchPlugin implements SBQQ.ProductSearchPlugin{
    /**Constructor. Not required for implementation**/
    global ExampleProductSearchPlugin(){
    }
    /**Product Search Methods**/
    // if isSearchCustom returns True, the plugin uses search(), otherwise it uses getAdditionalSearchFilters()
    global Boolean isSearchCustom(SObject quote, Map<String,Object> fieldValuesMap){ return true; }
    global Boolean isFilterHidden(SObject quote, String fieldName){ return false; }
    global String getFilterDefaultValue(SObject quote, String fieldName){ return NULL; }
    global String getAdditionalSearchFilters(SObject quote, Map<String,Object> fieldValuesMap){ return NULL; }
    global List<PricebookEntry> search(SObject quote, Map<String,Object> fieldValuesMap){ return NULL; }
```

> 위 클래스와 아래 Guided Selling 예제 클래스는 문서에서 동일한 이름 `ExampleProductSearchPlugin`으로 등장한다 — 동일 클래스에 양쪽 인터페이스 메서드를 모두 넣은 통합 예시를 문서가 분리 제시한 것이다(닫는 `}`는 Guided Selling 예제 끝에 위치).

### 1-B. Guided Selling Interface (Guided Selling UI용)

**Namespace:** SBQQ

**Usage:** Guided selling prompt를 사용자 입력 시 특정 파라미터 기준으로 필터링하도록 구성한다. 예) Last Ordered Date 최신순. Date 필드는 `yyyy-mm-dd` 문자열을 반환한다.

**Order of Execution** (원문 그대로):

```text
//**The constructor is optional**//
* 1.0 Constructor()
* 2.0 FOREACH(Search Field){
*     2.1 isInputHidden()
*     2.1 getInputDefaultValue()
* }
* 3.0 isSuggestCustom (CUSTOM vs ENHANCED)
* IF(isCustom){
*   4.0 suggest()
* }
* ELSE{
*     4.0 getAdditionalSuggestFilters()
* }
```

1. Constructor는 먼저 호출될 수 있으나 필수는 아니다.
2. 각 guided selling input마다 — `isInputHidden`(prompt에서 input 숨김 여부), `getInputDefaultValue`(초기 input 필드값 설정).
3. `isSuggestCustom`으로 custom/enhanced를 결정한다.
4. TRUE면 `suggest`를 호출(SELECT/WHERE 수동 구성).
5. FALSE면 `getAdditionalSuggestFilters`를 호출(WHERE append).

> 원문 [sic]: 본문 4·5번이 메서드명을 `isInputCustom`으로 적었으나 실제 메서드는 `isSuggestCustom`이다(원문 불일치). 위 정리는 실제 메서드명으로 교정했다.

**메서드 (Guided Selling):**

| 메서드 | Signature | 파라미터 | 반환 | 설명 |
|---|---|---|---|---|
| `getAdditionalSuggestFilters` | `global String getAdditionalSuggestFilters(SObject quote, Map<String,Object> fieldValuesMap)` | quote — SObject (현재 quote) / fieldValuesMap — Map<String,Object> (guided selling suggestion 조건; Key=Product2 API name, value=원하는 suggest 값) | String — 추가 suggestion 필터, WHERE clause. 예 `'AND Product2.Inventory_Level__c > 3'` | guided selling prompt용 SOQL에 WHERE append. `isSuggestCustom`이 FALSE일 때만 호출 |
| `getInputDefaultValue` | `global String getInputDefaultValue(SObject quote, String fieldName)` | quote — SObject (현재 quote) / fieldName — String (출력 결정에 쓰이는 quote 필드) | String — guided selling prompt의 초기 input으로 쓰이는 문자열 | 초기 guided selling prompt의 input 결정 |
| `isInputHidden` | `global Boolean isInputHidden(SObject quote, String fieldName)` | quote — SObject (현재 quote) / fieldName — String (true/false 결정 위해 테스트되는 필드) | Boolean — True면 input 숨김, False면 보임 | Guided Selling UI에서 input 가시성 결정. 각 input마다 호출 |
| `isSuggestCustom` | `global boolean isSuggestCustom(SObject quote, Map<String,Object> fieldValuesMap)` | quote — SObject (현재 quote) / fieldValuesMap — Map<String,Object> (suggestion 조건; map key=Product2 API name, value=원하는 검색값) | Boolean — True=Custom, False=Enhanced | `isInputHidden`·`getInputDefaultValue` 이후 호출 |
| `suggest` | `global List<PricebookEntry> suggest(SObject quote, Map<String,Object> fieldValuesMap)` | quote — SObject (현재 quote) / fieldValuesMap — Map<String,Object> (검색 조건; map key=Product2 API name, value=원하는 검색값; non-null 값의 키만 포함) | List<PricebookEntry> | 사용자 suggestion 입력을 override. `isSuggestCustom`이 TRUE일 때만 호출 |

> 원문 [sic]: 메서드 설명에 `getInputDefaulValue`(l 누락) 표기가 등장한다. 또한 `isSuggestCustom`의 Return 설명에 Product Search 인터페이스의 `search`/`getAdditionalSearchFilters`를 그대로 복붙한 오기가 있다 — 실제 Guided Selling 흐름은 `suggest`/`getAdditionalSuggestFilters`이다.

**예제 — getAdditionalSuggestFilters** ('Urgent Shipment' input='Yes'면 inventory check 추가):

```apex
global String getAdditionalSuggestFilters(SObject quote, Map<String, Object> inputValuesMap) {
    System.debug('METHOD CALLED: getAdditionalSuggestFilters');
    /**Adds an inventory check in an input = 'Yes' for an urgent shipment**/
    String additionalFilter = NULL;
    String isUrgent = 'No'
    if(inputValuesMap.containsKey('Urgent Shipment')){
        isUrgent = (String) inputValuesMap.get('Urgent Shipment');
    }
    if(isUrgent == 'Yes'){
        additionalFilter = 'AND Product2.Inventory_Level__c > 3';
    }
    return additionalFilter;
}
```

> 원문 [sic]: `String isUrgent = 'No'` 끝에 세미콜론이 누락되어 있다(원문 그대로).

**예제 — isInputHidden** (금요일에 'Urgent Shipment' input 숨김):

```apex
global Boolean isInputHidden(SObject quote, String input){
    /**Hides an input called 'Urgent Shipment' on Fridays**/
    return input == 'Urgent Shipment' && Datetime.now().format('F') == 5;
}
```

**예제 — suggest** (CUSTOM 모드, 전체 검색 override):

```apex
/**
 * When Using Guided Selling in CUSTOM mode, Over-Ride entire search
 * Product2 Fields in the Search Results Field Set should be Set.
 */
global List<PricebookEntry> suggest(SObject quote, Map<String, Object> inputValuesMap)
{
    System.debug('METHOD CALLED: suggest');
    //GET ALL POSSIBLE FIELDS FROM THE SEARCH RESULTS FIELD SET
    List<Schema.FieldSetMember> searchResultFieldSetFields =
        SObjectType.Product2.fieldSets.SBQQ__SearchResults.getFields();
    //BUILD THE SELECT STRING
    String selectClause = 'SELECT ';
    for (Schema.FieldSetMember field : searchResultFieldSetFields) {
        selectClause += 'Product2.' + field.getFieldPath() + ', ';
    }
    selectClause += 'Id, UnitPrice, Pricebook2Id, Product2Id, Product2.Id';
    //BUILD THE WHERE CLAUSE
    String whereClause = '';
    whereClause += 'Pricebook2Id = \'' + quote.get('SBQQ__Pricebook__c') + '\'';
    //BUILD THE QUERY
    String query = selectClause + ' FROM PricebookEntry WHERE ' + whereClause;
    //DO THE QUERY
    List<PricebookEntry> pbes = new List<PricebookEntry>();
    pbes = Database.query(query);
    return pbes;
}
```

**예제 구현 클래스 — Guided Selling:**

```apex
global class ExampleProductSearchPlugin implements SBQQ.ProductSearchPlugin{
    /**Constructor. Not required for implementation**/
    global ExampleProductSearchPlugin(){
    }
    /**Guided Selling Methods**/
    // if isSuggestCustom returns True, the plugin uses suggest(), otherwise it uses getAdditionalSuggestFilters()
    global Boolean isSuggestCustom(SObject quote, Map<String,Object> inputValuesMap){ return true; }
    global Boolean isInputHidden(SObject quote, String input){ return false; }
    global String getInputDefaultValue(SObject quote, String input){ return NULL; }
    global List<PriceBookEntry> suggest(SObject quote, Map<String,Object> fieldValuesMap){ return null; }
    global String getAdditionalSuggestFilters(SObject quote, Map<String,Object> inputValuesMap){ return null; }
```

> 원문 [sic]: 이 예제 산문에는 "implementation of the System.ProductSearchPlugin_GuidedSelling interface"라는 인터페이스명 오기가 있다 — 실제 구현 인터페이스는 `SBQQ.ProductSearchPlugin`이다.

---

## 2. Recommended Products Plugin

**목적:** quote에 이미 있는 제품을 기반으로 관련 제품을 추천한다. 고객 자체 product recommendation service를 product search·search filter·favorites·guided selling과 함께 CPQ에서 사용할 수 있다. sales rep이 quote 작성 중 추천 제품 목록을 본다.

- **인터페이스:** `SBQQ.ProductRecommendationPlugin` (global interface `ProductRecommendationPlugin`)
- **EDITIONS:** Available in Salesforce CPQ Winter '21 and later

**Sample use cases:**
- 고객 needs를 예측한 이상적 제품 조합으로 quote를 작성해 더 많은 거래를 성사시킨다.
- quote 제품과 자주 함께 팔리는 추천 제품을 추가해 upsell한다.

**구현 단계:**
1. Settings Editor의 Plugins 탭에서 Recommended Products Plugin을 활성화한다.
2. quote line editor에 Add Recommendations 버튼을 추가하려면 Add Recommendations custom action record를 활성화한다(See Custom Actions).
3. 플러그인 인터페이스를 직접 구현한다. 자체 recommendation engine 또는 third-party service를 사용한다. `recommend()` 메서드를 `ProductRecommendationPlugin` global interface에 구현해야 한다.

```apex
global interface ProductRecommendationPlugin {
    PricebookEntry[] recommend(SObject quote, List<SObject> quoteLines);
}
```

4. runtime에 입력에 필요한 필드가 없으면 해당 객체의 ReferencedFields field set에 추가한다.
5. Settings의 Plugins 탭에 플러그인 클래스명을 추가한다.

**Note (전수):**
- Recommended Products 페이지에는 최대 2,000개 price book entry가 표시된다(Product Lookup 페이지 한도와 유사). 구현 클래스는 상위 2,000개까지 반환할 수 있다. 초과 시 recommendation score로 정렬·선별한다.
- Recommended Products plugin은 Large Quote Threshold 설정을 지원하지 않는다.
- Salesforce CPQ는 field-level security를 Recommended Product plugin보다 우선 적용한다. 사용자가 볼 권한이 없는 필드는 Recommended Products 페이지에 표시되지 않는다.
- Product Recommendation 페이지는 Product Lookup 페이지와 동일한 field set을 사용한다.

**Walkthrough:**
1. quote에 제품을 추가한 후 Add Recommendations custom action을 클릭한다.
2. Salesforce가 플러그인 구현 클래스를 호출 → 정렬된 PricebookEntry sObject 리스트를 획득 → Recommended Products 페이지에 표시한다.

> 이 워크스루는 PDF p.90·91에 3개의 UI 스크린샷으로 예시되어 있다(다이어그램 아님 — pdfimages+Read로 직접 확인). 텍스트로만 요약하면 다음과 같다. PDF 스크린샷이므로 아래는 캡처 내용 인용이다.
> - p.90 — Settings Editor → Salesforce CPQ → Plugins 탭에서 Recommended Products Plugin 필드에 클래스명(`ProductRecommendationPlugin`)을 입력하는 화면.
> - p.91 (1) — Edit Quote(Q-00130) 견적라인 에디터에서 Add Products 드롭다운 → Add Favorites / Add Recommendations 선택.
> - p.91 (2) — Recommended Products(Q-00130) 페이지에서 추천된 PricebookEntry 행을 체크박스로 선택 후 Select / Select & Add More / Cancel 버튼으로 추가하는 화면. 컬럼은 PRODUCT CODE / PRODUCT NAME / PRODUCT FAMILY / PRODUCT DESCRIPTION / LIST PRICE.

**메서드:**

| 메서드 | Description | Parameters | Return |
|---|---|---|---|
| `recommend()` | 제품 추천 반환 | `quote` — Type `SBQQ__Quote__c`, Current quote object / `quoteLines` — Type `List<SBQQ__QuoteLine__c>`, Current quote lines of the quote | `PricebookEntry[]` — Ordered list of PricebookEntry SObjects |

**Error Scenarios:** 플러그인이 exception을 throw하면 Recommendations Lookup 페이지에 에러가 표시된다. 메시지는 "Plugin Error:" prefix 뒤에 exception 메시지가 붙는다.

**Sample Implementation:**

```apex
// Create your own Custom Object to store your product recommendations
ProductRecommendation__c {
    Id Product2Id__c,
    Id RecommendedProduct2Id__c,
}
global class ProductRecommendationPluginJH implements SBQQ.ProductRecommendationPlugin{
    global PricebookEntry[] recommend(SObject quote, List<SObject> quoteLines) {
        System.debug('ProductRecommendationPluginJH');
        // Get the price book Id of the quote
        Id pricebookId = (Id)quote.get('SBQQ__PriceBookId__c');
        String quoteCurrency=(String)quote.get('CurrencyIsoCode');
        // Get Ids of all products in the quote
        Id[] productIdsInQuote = new Id[0];
        for (SObject quoteLine : quoteLines) {
            Id productId = (Id)quoteLine.get('SBQQ__Product__c');
            productIdsInQuote.add(productId);
        }
        // Query the recommendation custom object records of all products in quote.
        ProductRecommendation__c[] recommendations = [
            SELECT RecommendedProduct2Id__c
            FROM ProductRecommendation__c
            WHERE Product2Id__c IN :productIdsInQuote];
        // Get Ids of all recommended products
        Id[] recommendedProductIds = new Id[0];
        for(ProductRecommendation__c recommendation : recommendations) {
            recommendedProductIds.add(recommendation.RecommendedProduct2Id__c);
        }
        System.debug('>>>>>>>>>>>'+recommendedProductIds);
        // Query the price book entries of the above recommended products
        PricebookEntry[] priceBookEntries = [
            SELECT Id, UnitPrice, Pricebook2Id, Product2Id, Product2.Name, Product2.ProductCode
            FROM PricebookEntry
            WHERE Product2Id IN :recommendedProductIds AND Pricebook2Id = :pricebookId AND
                CurrencyIsoCode=:quoteCurrency];
        return priceBookEntries;
    }
}
```

---

## 3. External Configurator Plugins

**목적:** sales rep이 제품 고유 attribute·bundle configuration 등을 반영한 quote를 작성할 수 있다. CPQ external configurator가 지정 제품에 대해 CPQ product configurator를 대체하면서, price calculation·product rules 등 다른 CPQ 기능은 계속 사용한다. Visualforce 페이지 또는 외부 웹 앱(예: Heroku)으로 개발한다. Salesforce가 제품 정보 payload를 external configurator로 전송 → attribute 생성·수정, bundle 구성 → 수정된 payload를 CPQ로 반환 → quote line을 생성한다. 재구성 시 payload를 재전송한다.

- **EDITIONS:** Available in Salesforce CPQ Winter '16 and later (Create an External Configurator 및 일부 하위 항목은 Winter '18)

> ⚠️ **전제조건 — 외부(Heroku/비-Salesforce) configurator를 iframe으로 띄우려면 CSP Trusted URLs 등록이 필수.**
> Lightning Experience에서 external configurator(Heroku 등 외부 웹 앱, 3-B의 외부 host 방식)를 quote line editor의 iframe으로 launch하려면, 그 도메인을 **Setup → CSP Trusted URLs(Trusted Sites)** 에 **`frame-src` 컨텍스트**로 등록해야 한다. 등록하지 않으면 CSP가 프레임을 차단해 configurator가 **빈 화면**으로 뜬다(브라우저 콘솔에 `frame-src` CSP 위반 로그가 남는다). 이는 외부 앱 host 시 가장 흔한 블로커다.
> - Visualforce 페이지로 self-host(3-B의 Salesforce host 방식)하는 경우에는 same-origin이라 해당하지 않는다. **외부 앱을 host할 때 특히 발생**한다.
> - URL은 반드시 **HTTPS**여야 한다(3-A 6번에서 secure https 요구와 동일 조건). CSP frame-src 등록과 HTTPS는 별개 요건이며 둘 다 충족해야 한다.
> - 근거: help.salesforce.com — Manage Trusted URLs(`frame-src` 컨텍스트로 iframe 콘텐츠 허용) + developer.salesforce.com Content Security Policy(신뢰되지 않은 외부 프레임을 CSP가 차단). External Configurator URL 설정 문서(3-E)는 이 CSP 전제를 별도로 언급하지 않으므로 여기 명시한다.

### 3-A. Set Up an External Configurator to Launch from a Custom Action

non-CPQ configurator를 launch하는 custom action을 생성한다. 추가해야 할 layout/value:
- Page·URL Target 필드를 custom action page layout에 추가.
- Popup 값을 custom action의 URL Target 필드에 추가.
- external configurator 이름 label을 custom action Label 필드에 추가.

1. Custom Actions 탭 → New.
2. Label 필드 → GIS 선택.
3. Page 필드 → Product Configurator 선택.
4. URL Target 필드 → Popup 선택.
5. URL 필드 → secure https를 사용하는 custom website URL 추가.
6. 저장.

> **Important:** URL Target 값으로 Dialog Window를 강력 권장한다. Replace Window는 external configurator 로드 시 사용자 작업이 전부 손실된다.

### 3-B. Create an External Configurator

Visualforce 페이지로 Salesforce에 host하거나 외부 웹 앱(Heroku)에 host한다. easyXDM 라이브러리로 데이터를 전송한다. (Available in Salesforce CPQ Winter '18 and later)

1. easyXDM 라이브러리 CDN을 포함한다(CloudFlare host).

```html
<!-- easyXDM.min.js compiled and minified JavaScript to communicate with Salesforce CPQ-->
<script type="text/javascript"
    src="https://cdnjs.cloudflare.com/ajax/libs/easyXDM/2.4.20/easyXDM.min.js"
    crossorigin="anonymous">
</script>
```

다운로드 후 org static resource로 업로드할 수 있다.

2. easyXDM을 초기화한다. `configObj` 변수에 CPQ에서 보낸 정보를 저장한다.

```javascript
// Initialize the EasyXDM connection to Salesforce CPQ
var rpc = new easyXDM.Rpc({}, {
    //method defined in Salesforce CPQ
    remote: {
        postMessage: {}
    },
    // method for receiving configuration JSON from Salesforce CPQ
    local: {
        postMessage: function (message) { // parse the incoming information, for example:
            var configObj = JSON.parse(message);
        }
    }
});
```

3. 구성을 수행한다(규칙 강제, 제품 attribute 추가 등). 예) "Special Code" 옵션값을 12345로 설정.

```javascript
configObj.product.optionConfigurations["Special Code"] = '12345';
```

4. 구성 정보를 JSON string으로 CPQ에 반환한다.

```javascript
rpc.postMessage(JSON.stringify(configObj));
```

#### Configure Product Bundles (Nested Bundles)

`optionConfigurations` 파라미터로 product bundle을 생성한다. top-level 제품을 포함해 최대 4단계 nesting이 가능하다. (Available in Salesforce CPQ Winter '16 and later)

**Enable Nested Bundles:**
1. Setup → Installed Packages.
2. Salesforce CPQ package → Configure.
3. Additional Settings 탭 → Nested Bundles for External Configurator 선택.
4. Save.

> Note: 이 설정은 비활성화할 수 없다.

**Create Nested Bundles:** `optionConfigurations` 파라미터로 bundle 내 nested 제품을 정의한다.

**Example — Work Anywhere Software Bundle:** Work Anywhere 제품이 VPN access를 nested option으로 포함하고, VPN access는 Ultra High-Speed 옵션을, Ultra High-Speed는 Ad Blocker를 포함한다.

```text
// 구조 예시 — 원문 bundle 계층 표기(다이어그램 아님)
Work Anywhere
  VPN Access
    Ultra High Speed
      Ad Blocker
```

Work Anywhere bundle 구성 payload (원문 발췌 — JSON에 주석은 실제 무효이므로 구조 예시로만 사용):

```json
// 구조 예시 — 실제 동작 설정 아님 (원문 발췌, 주석은 PDF 표기 그대로)
{
  "quote": {},
  "product": {
    "configuredProductId": "<Product2 Id>",
    "lineItemId": null,
    "lineKey": null,
    "configurationAttributes": {
      "SBQQ__UnitPrice__c": null,
      "attributes": {
        "type": "SBQQ__ProductOption__c"
      }
    },
    "optionConfigurations": {
      "Other Options": [
        {
          "optionId": "<SBQQ__ProductOption__c Id>",
          "selected": true,
          "ProductName": "VPN Access",
          "Quantity": 1,
          "configurationData": {},
          "readOnly": {},
          "optionConfigurations": {
            "Other Options": [
              {
                "optionId": "<SBQQ__ProductOption__c Id>",
                "selected": true,
                "ProductName": "Ultra High Speed",
                "Quantity": 1,
                "configurationData": {},
                "readOnly": {},
                "optionConfigurations": {
                  "Other Options": [
                    {
                      "optionId": "<SBQQ__ProductOption__c Id>",
                      "selected": true,
                      "ProductName": "Ad Blocker",
                      "Quantity": 1,
                      "configurationData": {},
                      "readOnly": {}
                    }
                  ]
                }
              }
            ]
          }
        }
      ]
    },
    "configurationData": {}
  },
  "products": [],
  "readOnly": {},
  "redirect": {
    "save": true
  }
}
```

> 원문 [sic]: PDF에서 `"configuredProductId": "<Product2 Id>"` 줄에 trailing 콤마가 없고, 주석 `// ID of the WorkAnywhere Product,`가 페이지 레이아웃상 분리 표시되어 있다. 위는 논리적 위치로 정렬한 구조 예시이다.

**Considerations for Nested Bundles (전수):**
- top-level 제품을 포함해 최대 4단계 nested bundle을 구성할 수 있다. 5단계 bundle 재구성 시 4단계만 external configurator로 전송된다. 5번째 단계는 top-level 제품을 deselect하여 해제한다.
- bundle에서 `auto` property는 미지원이다 → 사용자가 CPQ configurator로 돌아가 제품을 계속 구성할 수 없다. 대신 quote line editor로 redirect된다.
- Default configuration은 미지원이다. payload 반환 시 각 nested option을 명시적으로 select해야 한다(재구성 payload도 동일).
- Nested bundle은 configured로 간주된다. Configuration Type이 Required인 nested bundle은 payload에 포함되면 configured로 간주된다.
- Min/Max options는 external configurator에서 미지원이다. CPQ configurator로 directed된다. external에서 min/max 설정을 시도하면 error가 발생할 수 있다.
- Duplicate dynamic options를 지원한다(같은 옵션을 여러 번 추가할 수 있다).

### 3-C. External Configurator Parameters

CPQ가 JSON 형식으로 configuration 정보를 custom configurator에 전달한다. 수정 후 CPQ로 반환한다. **아래 파라미터는 별도 표기가 없으면 required이다.** (Available in Salesforce CPQ Winter '16 and later)

> 원문은 산문형 정의 목록이며 `optionConfigurations`·`configurationData`·`readOnly`가 각각 2회 등장한다(중첩 컨텍스트마다 다른 정의). 아래 표는 원문 등장 순서·중복을 그대로 보존하며 두 entry를 합치지 않았다.

| 파라미터 | Type / 속성 | 설명 |
|---|---|---|
| `quote` | Object | The SBQQ__Quote__c record. |
| `product` | Object | The product being configured. |
| `configuredProductId` | String. Read-only. | The ID of the Product2 record. |
| `lineItemId` | String. Read-only. | 해당 quote line의 ID. quote line이 저장된 reconfigure 시 채워진다. |
| `lineKey` | Number. Read-only. | CPQ가 이 제품의 해당 quote line 식별에 사용한다. |
| `configurationAttributes` | Object. Required, but can be empty. | configuration attribute 사용 시 attribute 필드값을 포함한다. |
| `optionConfigurations` (1) | Object | nested bundle의 옵션을 표시한다. |
| `optionId` | String. Required for static options. | The ID of the SBQQ__ProductOption__c record. |
| `productId` | String. Required for dynamic options. | The ID of the SBQQ__Product2__c record. Available in API version 57.0 and later. |
| `selected` | Boolean. Required for static options but optional for dynamic options. | product option 선택 시 true, 아니면 false. |
| `ProductName` | String. Read-only. | Name of the product. |
| `Quantity` | Number | line item의 quantity. |
| `configurationData` (1) | Object. Required, but can be empty. | editable SBQQ__ProductOption__c 필드 설정에 사용하며, rules/twin field mapping과 함께 사용할 수 있다. |
| `readOnly` (1) | Object | 선택 옵션에 해당하는 quote line. CPQ가 reconfigure 요청 시 채운다. |
| `index` | Number. Required when SBQQ__ProductFeature__c record의 Option Selection Method 필드가 Add일 때. | 같은 제품을 feature에 여러 번 추가 시, 각 instance를 고유 식별한다. |
| `optionConfigurations` (2) | Object. Available when Nested Bundles for External Configurator is enabled. Available in API version 56.0 and later. | nested bundle 옵션 포함에 사용한다. |
| `configurationData` (2) | Object. Required, but can be empty. | 구성 중인 제품의 quote line에 twin field 값을 설정하는 Field-value pair. |
| `products` | Array. Optional. | 구성 중인 제품 clone에 사용한다. |
| `readOnly` (2) | Object | 구성 중인 제품에 해당하는 quote line. CPQ가 reconfigure 요청 시 채운다. |
| `redirect` | Object | save·redirect 동작을 지정하는 속성을 포함한다. |
| `save` | Boolean | 구성 저장 시 true, 취소 시 false. |
| `auto` | Boolean | true=quote line editor로 redirect, false=CPQ Configurator로 redirect. Nested Bundles for External Configurator 활성화 시 이 파라미터는 미사용. |

### 3-D. External Configurator Example

easyXDM 라이브러리를 초기화하고, Send·Cancel 버튼을 생성하며, CPQ가 보낸 configuration data를 표시한다. (Available in Salesforce CPQ Winter '16 and later)

> 원문 [sic]: 이 예제 소개 산문에 `easyXML`로 라이브러리명을 잘못 적은 표기가 있다 — 실제는 easyXDM이다.

```html
<apex:page doctype="html-5.0" standardstylesheets="false" showHeader="false">
<html>
<head>
    <!-- easyXDM.min.js compiled and minified JavaScript to communicate with Salesforce CPQ-->
    <script type="text/javascript"
        src="https://cdnjs.cloudflare.com/ajax/libs/easyXDM/2.4.20/easyXDM.min.js"
        crossorigin="anonymous">
    </script>
</head>
<body>
<div>
    <button onclick="broadcastSend()">Send</button>
    <button onclick="broadcastCancel()">Cancel (Customer's Cancel Button)</button>
    <br></br>
    <textarea id="output" type="text" style="width:1400px; height:700px"></textarea>
</div>
<script type="text/javascript">
// Set up the EasyXDM connection to Salesforce CPQ
var rpc = new easyXDM.Rpc({},{
    remote: {
        postMessage: {}
    },
    local: {
        //Method that receives the configuration information.
        postMessage: function(message) {
            // Display the JSON received from Salesforce CPQ.
            document.getElementById('output').value =
                JSON.stringify(JSON.parse(message), null, 4);
        }
    }
});
function broadcastSend() {
    //Return the configuration information to Salesforce CPQ
    rpc.postMessage(document.getElementById('output').value);
}
function broadcastCancel() {
    rpc.postMessage(null);
}
</script>
</body>
</html>
</apex:page>
```

### 3-E. Configure Salesforce CPQ to Use the External Configurator

quote line editor에서 custom configurator를 launch하도록 CPQ package를 구성한다. 제품의 Externally Configurable 필드를 true로 설정해 외부 구성 제품을 지정한다. (Available in Salesforce CPQ Winter '18 and later)

1. Setup → Quick Find box → Installed Packages → Installed Packages 선택.
2. Salesforce CPQ package → Configure.
3. Additional Settings 탭 선택.
4. External Configurator URL 필드 → external configurator URL 입력. (Visualforce 페이지 URL은 preview 클릭으로 획득. 절대/상대 URL 가능. Experience Cloud와 함께 쓰려면 relative URL 사용 — Lightning과 외부 웹 앱의 URL 형식이 다르다.)
   > ⚠️ 외부(Heroku/비-Salesforce) URL을 입력할 경우, 이 URL을 입력하기 전에 그 도메인을 **Setup → CSP Trusted URLs**에 `frame-src`로 등록해야 iframe이 차단되지 않는다(§3 상단 전제조건 참조). 미등록 시 configurator가 빈 화면으로 뜬다.
5. Optional: Additional Settings 페이지에서 Third Party Configurator 필드를 선택할 수 있다. 활성 시 external configurator가 전체 화면을 차지한다. configurator를 닫는 모든 액션(cancel/save)은 launch한 페이지로 redirect한다.
6. external configurator로 구성할 제품을 찾는다.
   - a. 각 제품 record에서 Externally Configurable 필드를 선택한다.
   - b. 각 제품의 Configuration Type 필드를 Required로 설정한다.
   - external configurator는 사용자가 configurable bundle 옆 wrench를 클릭하거나, configuration event가 required인 제품 추가 시 launch된다. Configuration type을 Allowed로 설정하면 sales rep이 configurable bundle 옆 wrench 아이콘을 선택할 때만 launch된다.

---

## 4. Legacy Quote Calculator Plugin

**목적:** Apex 코드로 CPQ quote line editor 내에서 계산을 수행한다.

- **인터페이스:** `SBQQ.QuoteCalculatorPlugin`, `SBQQ.QuoteCalculatorPlugin2`
- **EDITIONS:** Available in All Salesforce CPQ Editions (개별 예제는 Winter '16 and later)

> **Important:** Winter '17 기준 CPQ는 Legacy Quote Calculator Plugin에 새 기능을 개발하지 않는다. admin-related configuration case는 계속 지원한다. Salesforce Customer Support는 기존 legacy calculator 기능의 regression 버그에만 대응한다. 현행 문서는 [[JavaScript Quote Calculator Plugin]]을 참조한다.
> (각 예제마다 반복되는 Note) Salesforce CPQ no longer provides support for Legacy Quote Calculator plugins. Javascript Quote Calculator Plugin이 권장된다.

사용법: 먼저 Apex 클래스를 생성한 후 package settings에 클래스명을 입력한다. 한 번에 하나의 Apex 클래스만 호출할 수 있다.

> `getReferencedFields` 메서드는 Quote Line 객체의 ReferencedFields field set을 쓰면 더 이상 불필요하다(이 field set은 managed가 아니므로 직접 생성해야 한다). Quote 필드 접근이 필요하면 Quote 객체에도 ReferencedFields field set을 생성할 수 있다. `getReferencedFields`를 안 쓰면 클래스 선언에서 `SBQQ.QuoteCalculatorPlugin2`를 제거할 수 있다.

**콜백 메서드 (예제로 등장):**
- `getReferencedFields()` — `Set<String>` 반환 (QuoteCalculatorPlugin2)
- `onBeforePriceRules(SObject quote, SObject[] lines)`
- `onAfterPriceRules(SObject quote, SObject[] lines)`
- `onBeforeCalculate(SObject quote, SObject[] lines)`
- `onAfterCalculate(SObject quote, SObject[] lines)`
- `onInit(SObject[] lines)`

### 4-A. Calculating True End Date and Subscription Term

(Note: admin이 Quote Line에 custom 필드 True Effective End Date·True Effective Term을 생성한 전제)

```apex
global class QCPWinter16Legacy2 implements SBQQ.QuoteCalculatorPlugin,
SBQQ.QuoteCalculatorPlugin2 {
    /* This QCP examples calculates and stores the effective end date on each quote line,
    as well as the effective term.
    It also stores the max(effective end date) and max(effective term) on the Quote object
    */

    /* NOTE: the getReferencedFields method is no longer required if you use the ReferencedFields field set on
    the Quote Line object.
    This field set must be created as it's not a managed one.
    NOTE: if you need to access Quote fields, you can create the ReferencedFields field set on the Quote object as well.
    NOTE: if you do not use the getReferencedFields method, you can remove
    SBQQ.QuoteCalculatorPlugin2 from the class declaration.
    */
    global Set<String> getReferencedFields() {
        return new Set<String>{
            /* Note: add fields using the following format - Only add fields referenced
            by the plugin and not in the Line Editor field set on the Quote Line object
            String.valueOf(SBQQ__QuoteLine__c.My_Field_API_Name__c)
            */
            String.valueOf(SBQQ__QuoteLine__c.True_Effective_End_Date__c),
            String.valueOf(SBQQ__QuoteLine__c.True_Effective_Term__c),
            String.valueOf(SBQQ__Quote__c.True_Effective_End_Date__c),
            String.valueOf(SBQQ__Quote__c.True_Effective_Term__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__EffectiveStartDate__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__EffectiveEndDate__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__SubscriptionTerm__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__DefaultSubscriptionTerm__c),
            String.valueOf(SBQQ__Quote__c.SBQQ__SubscriptionTerm__c)
        };
    }
    global void onBeforePriceRules(SObject quote, SObject[] lines) {
    }
    global void onAfterPriceRules(SObject quote, SObject[] lines) {
    }
    global void onBeforeCalculate(SObject quote, SObject[] lines) {
    }
    global void onAfterCalculate(SObject quote, SObject[] lines) {
        Date maxEffectiveEndDate = null;
        Decimal maxEffectiveTerm = 0;
        for(SObject line : lines) {
            Date trueEndDate = calculateEndDate(quote, line);
            Decimal trueTerm = getEffectiveSubscriptionTerm(quote, line);
            if(maxEffectiveEndDate == null || maxEffectiveEndDate < trueEndDate) {
                maxEffectiveEndDate = trueEndDate;
            }
            if(maxEffectiveTerm < trueTerm) {
                maxEffectiveTerm = trueTerm;
            }
            line.put(SBQQ__QuoteLine__c.True_Effective_End_Date__c, trueEndDate);
            line.put(SBQQ__QuoteLine__c.True_Effective_Term__c, trueTerm);
        }
        quote.put(SBQQ__Quote__c.True_Effective_End_Date__c, maxEffectiveEndDate);
        quote.put(SBQQ__Quote__c.True_Effective_Term__c, maxEffectiveTerm);
    }
    global void onInit(SObject[] lines) {
    }
    private Date calculateEndDate(SObject quote, SObject line) {
        Date startDate =
            (Date)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__EffectiveStartDate__c));
        Date endDate =
            (Date)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__EffectiveEndDate__c));
        if ((startDate != null) && (endDate == null)) {
            /* Note: we are assuming that Subscription Term Unit is Month in the package settings */
            endDate = startDate.addMonths(getEffectiveSubscriptionTerm(quote,
                line).intValue()).addDays(-1);
            /* Note: we are assuming that Subscription Term Unit is Day in the package settings */
            //  endDate = startDate.addDays(getEffectiveSubscriptionTerm(line).intValue() - 1);
        }
        return endDate;
    }
    private Decimal getEffectiveSubscriptionTerm(SObject quote, SObject line) {
        Decimal lineTerm = null;
        Date startDate =
            (Date)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__EffectiveStartDate__c));
        Date endDate =
            (Date)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__EffectiveEndDate__c));
        if ((startDate != null) && (endDate != null)) {
            /* Note: we are assuming that Subscription Term Unit is Month in the package settings */
            lineTerm = startDate.monthsBetween(endDate.addDays(1));
            /* Note: we are assuming that Subscription Term Unit is Day in the package settings */
            //  lineTerm = startDate.daysBetween(endDate.addDays(1));
        } else {
            lineTerm =
                (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__SubscriptionTerm__c));
            if (lineTerm == null) {
                lineterm =
                    (Decimal)quote.get(String.valueOf(SBQQ__Quote__c.SBQQ__SubscriptionTerm__c));
                if (lineTerm == null) {
                    return
                        (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__DefaultSubscriptionTerm__c));
                }
            }
        }
        return lineTerm;
    }
}
```

> 원문 [sic]: `lineterm =` 의 소문자 t(Apex는 case-insensitive라 동작), 주석 줄의 `getEffectiveSubscriptionTerm(line)`은 1-arg 호출(주석 처리됨)이다 — 원문 그대로 인용.

### 4-B. Custom Package Total Calculation

(Note: admin이 Quote Line에 custom 필드 Component Custom Total을 생성한 전제)

```apex
global class QCPWinter16Legacy implements SBQQ.QuoteCalculatorPlugin,
SBQQ.QuoteCalculatorPlugin2 {
    /* NOTE: the getReferencedFields method is no longer required if you use the ReferencedFields field set on
    the Quote Line object.
    This field set must be created as it's not a managed one.
    NOTE: if you need to access Quote fields, you can create the ReferencedFields field set on the Quote object as well.
    NOTE: if you do not use the getReferencedFields method, you can remove
    SBQQ.QuoteCalculatorPlugin2 from the class declaration.
    */
    global Set<String> getReferencedFields() {
        return new Set<String>{
            /* Note: add fields using the following format - Only add fields referenced
            by the plugin and not in the Line Editor field set on the Quote Line object
            String.valueOf(SBQQ__QuoteLine__c.My_Field_API_Name__c)
            */
            String.valueOf(SBQQ__QuoteLine__c.Component_Custom_Total__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProratedListPrice__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__PriorQuantity__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__PricingMethod__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__DiscountScheduleType__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__Renewal__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__Existing__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__SubscriptionPricing__c)
        };
    }
    global void onBeforePriceRules(SObject quote, SObject[] lines) {
    }
    global void onAfterPriceRules(SObject quote, SObject[] lines) {
    }
    global void onBeforeCalculate(SObject quote, SObject[] lines) {
    }
    global void onAfterCalculate(SObject quote, SObject[] lines) {
        for(SObject line : lines) {
            SObject parent =
                line.getSObject(SBQQ__QuoteLine__c.SBQQ__RequiredBy__c.getDescribe().getRelationshipName());
            if(parent != null) {
                Decimal pComponentCustomTotal =
                    (Decimal)parent.get(String.valueOf(SBQQ__QuoteLine__c.Component_Custom_Total__c));
                Decimal cListPrice =
                    (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProratedListPrice__c));
                Decimal cQuantity =
                    (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Quantity__c));
                Decimal cPriorQuantity =
                    (Decimal)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__PriorQuantity__c));
                String cPricingMethod =
                    (String)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__PricingMethod__c));
                String cDiscountScheduleType =
                    (String)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__DiscountScheduleType__c));
                Boolean cRenewal =
                    (Boolean)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Renewal__c));
                Boolean cExisting =
                    (Boolean)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Existing__c));
                String cSubscriptionPricing =
                    (String)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__SubscriptionPricing__c));
                pComponentCustomTotal = (pComponentCustomTotal == null) ? 0 : pComponentCustomTotal;
                cListPrice = (cListPrice == null) ? 0 : cListPrice;
                cQuantity = (cQuantity == null) ? 1 : cQuantity;
                cPriorQuantity = (cPriorQuantity == null) ? 0 : cPriorQuantity;
                cPricingMethod = (cPricingMethod == null) ? 'List' : cPricingMethod;
                cDiscountSCheduleType = (cDiscountSCheduleType == null) ? '' : cDiscountSCheduleType;
                cRenewal = (cRenewal == null) ? false : cRenewal;
                cExisting = (cExisting == null) ? false : cExisting;
                cSubscriptionPricing = (cSubscriptionPricing == null) ? '' : cSubscriptionPricing;
                Decimal cTotalPrice = getTotal(cListPrice, cQuantity, cPriorQuantity,
                    cPricingMethod, cDiscountScheduleType, cRenewal, cExisting, cSubscriptionPricing,
                    cListPrice);
                pComponentCustomTotal += cTotalPrice;
                parent.put(SBQQ__QuoteLine__c.Component_Custom_Total__c, pComponentCustomTotal);
            }
        }
    }
    global void onInit(SObject[] lines) {
        for(SObject line : lines) {
            line.put(SBQQ__QuoteLine__c.Component_Custom_Total__c, 0);
        }
    }
    private Decimal getTotal(Decimal price, Decimal quantity, Decimal priorQuantity,
        String pricingMethod, String discountScheduleType, Boolean renewal, Boolean existing,
        String subscriptionPricing, Decimal ListPrice) {
        price = (price == null) ? 0 : price;
        renewal = (renewal == null) ? false : renewal;
        existing = (existing == null) ? false : existing;
        if(renewal == true && existing == false && priorQuantity == null) {
            return 0;
        } else {
            return price * getEffectiveQuantity(quantity, priorQuantity, pricingMethod,
                discountScheduleType, renewal, existing, subscriptionPricing, listPrice);
        }
    }
    private Decimal getEffectiveQuantity(Decimal quantity, Decimal priorQuantity,
        String pricingMethod, String discountScheduleType, Boolean renewal, Boolean existing,
        String subscriptionPricing, Decimal ListPrice) {
        Decimal result = 0;
        Decimal deltaQuantity = 0;
        quantity = (quantity == null) ? 0 : quantity;
        priorQuantity = (priorQuantity == null) ? 0 : priorQuantity;
        pricingMethod = (pricingMethod == null) ? '' : pricingMethod;
        discountScheduleType = (discountScheduleType == null) ? '' : discountScheduleType;
        subscriptionPricing = (subscriptionPricing == null) ? '' : subscriptionPricing;
        renewal = (renewal == null) ? false : renewal;
        existing = (existing == null) ? false : existing;
        listPrice = (listPrice == null) ? 0 : listPrice;
        deltaQuantity = quantity - priorQuantity;
        if(pricingMethod == 'Block' && deltaQuantity == 0) {
            result = 0;
        } else {
            if(pricingMethod == 'Block') {
                result = 1;
            } else {
                if(discountScheduleType == 'Slab' && (deltaQuantity == 0 || (quantity == 0 && renewal == true))) {
                    result = 0;
                } else {
                    if(discountScheduleType == 'Slab') {
                        result = 1;
                    } else {
                        if(existing == true && subscriptionPricing == '' && deltaQuantity < 0) {
                            result = 0;
                        } else {
                            if(existing == true && subscriptionPricing == 'Percent Of Total' && listPrice != 0 && deltaQuantity >= 0) {
                                result = quantity;
                            } else {
                                if(existing == true) {
                                    result = deltaQuantity;
                                } else {
                                    result = quantity;
                                }
                            }
                        }
                    }
                }
            }
        }
        return result;
    }
}
```

> 원문 [sic]: `cDiscountSCheduleType` 변수명에 대소문자 혼용이 있다(원문 그대로).

### 4-C. Find Lookup Records

Legacy Quote Line Calculator에서 record를 query한 후 그 필드로 각 quote line의 Description 필드를 설정한다.

> 추출 노트: 이 클래스의 `onAfterCalculate` 본문은 `/tmp/cpq_dev.txt` 텍스트 추출에서 잘려 있어 물리 PDF p.106·107에서 `pdftotext`로 완전체를 재추출해 결합했다.

```apex
global class QCPForFindingLookupRecords implements
SBQQ.QuoteCalculatorPlugin, SBQQ.QuoteCalculatorPlugin2 {
    global set<String> getReferencedFields() {
        return new Set<String> {
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProductCode__c),
            String.valueOf(SBQQ__QuoteLine__c.SBQQ__Description__c)
        };
    }
    global void onInit(SObject[] lines) {}
    global void onBeforeCalculate(SObject quote, SObject[] lines) {}
    global void onBeforePriceRules(SObject quote, SObject[] lines) {}
    global void onAfterPriceRules(SObject quote, SObject[] lines) {}
    global void onAfterCalculate(SObject quote, SObject[] lines) {
        if (!lines.isEmpty()) {
            String[] productCodes = new String[0];
            for (SObject line : lines) {
                String productCode =
                    (String)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProductCode__c));
                if (productCode != null && !productCode.isWhitespace()) {
                    productCodes.add(productCode);
                }
            }
            SBQQ__LookupData__c[] ds = [SELECT Id, SBQQ__Category__c, SBQQ__Value__c FROM
                SBQQ__LookupData__c WHERE SBQQ__Category__c IN :productCodes];
            if (!ds.isEmpty()) {
                Map<String,String> valuesByCategory = new Map<String,String>();
                for (SBQQ__LookupData__c d : ds) {
                    valuesByCategory.put(d.SBQQ__Category__c, d.SBQQ__Value__c);
                }
                for (SObject line : lines) {
                    String productCode =
                        (String)line.get(String.valueOf(SBQQ__QuoteLine__c.SBQQ__ProductCode__c));
                    if (productCode != null && !productCode.isWhitespace()) {
                        line.put(String.valueOf(SBQQ__QuoteLine__c.SBQQ__Description__c),
                            valuesByCategory.get(productCode));
                    }
                }
            }
        }
    }
}
```

---

## 5. Product Configuration Initializer for Guided Selling

**목적:** custom user-provided Apex page를 사용해 guided selling prompt 결과를 기반으로 옵션 선택·필드값을 설정한다. **standard product option 필드에만 동작**한다(configuration attribute나 custom product option 필드에는 미동작). Visualforce controller + Visualforce page로 구성한다.

**설정:** 모든 quote process에 적용하려면 CPQ line editor package settings의 Product Configuration Initializer 필드에 `c__` + Visualforce page 이름을 입력한다. 특정 quote process에만 적용하려면 해당 quote process의 Product Configuration Initializer 필드에 `c__` + page 이름을 입력한다. quote process record의 initializer가 package-level initializer를 override한다.

**Sample Visualforce controller:**

```apex
public with sharing class LF_ProductInitializerController {
    public Product2[] products {get; set;}
    public Boolean skip {get; set;}
    Map<String,SBQQ__ProductOption__c> optionsByCode = new
        Map<String,SBQQ__ProductOption__c>();
    public LF_ProductInitializerController() {
        // Set "skip" to true to bypass the configuration page, or to false to on the config page after the initializer has completed
        skip = true;
        // Retrieve product (bundle)
        String pidsStr = ApexPages.currentPage().getParameters().get('pids');
        String[] pids = pidsStr.split(',');
        products = [SELECT Id, Family, (SELECT SBQQ__OptionalSKU__r.ProductCode,
            SBQQ__Quantity__c, SBQQ__Selected__c FROM SBQQ__Options__r) FROM Product2 WHERE Id IN
            :pids];
        for (SBQQ__ProductOption__c opt : products[0].SBQQ__Options__r) {
            optionsByCode.put(opt.SBQQ__OptionalSKU__r.ProductCode, opt);
        }
        String myInput1 = ApexPages.currentPage().getParameters().get('Process Input 1');
        Decimal myInput2 = toInteger(ApexPages.currentPage().getParameters().get('Process Input 2'));
        // Perform any logic you want here
        // Then select options in the bundle, for example:
        if (myInput1 == 'ABC') {
            selectOption('MyProductOption1', myInput2);
        } else {
            selectOption('MyProductOption2', 1)
        }
    }
    private Decimal toInteger(String value) {
        return String.isBlank(value) ? 0 : Decimal.valueOf(value);
    }
    private void selectOption(String code, Decimal qty) {
        optionsByCode.get(code).SBQQ__Selected__c = (qty > 0);
        optionsByCode.get(code).SBQQ__Quantity__c = qty;
    }
}
```

> 원문 [sic]: `selectOption('MyProductOption2', 1)` 끝에 세미콜론이 누락되어 있고, 주석 "to false to on the config page"도 원문 문법 오류 그대로이다.

**Sample Visualforce page:**

```xml
<apex:page controller="LF_ProductInitializerController" contentType="text/xml"
    showHeader="false" sidebar="false">
    <products skipConfiguration="{!skip}">
        <apex:repeat var="product" value="{!products}">
            <product id="{!product.Id}">
                <apex:repeat var="opt" value="{!product.SBQQ__Options__r}">
                    <option id="{!opt.Id}"
                        selected="{!opt.SBQQ__Selected__c}"
                        quantity="{!ROUND(opt.SBQQ__Quantity__c, 0)}"/>
                </apex:repeat>
            </product>
        </apex:repeat>
    </products>
</apex:page>
```

---

## 6. Product Search Executor for Guided Selling

**목적:** guided selling prompt 결과를 sales rep 입력 후 필터링한다. Visualforce controller + Visualforce page로 구성하며, guided selling 구성 내 특정 quote process에 연결할 수 있다. sales rep이 제어할 수 있는 것 이상의 추가 guided selling 제품 필터링 단계를 추가하는 데 유용하다.

**설정:** quote process의 Product Search Executor 필드에 `c__` + Visualforce page 이름을 입력한다.

**Example (산문):** laptop workstation을 판매하는 조직에서, guided selling prompt가 memory·screen size·processor type으로 카탈로그를 필터한다. active 제품이면서 bundle component가 아닌 제품으로 추가 필터하는 간단한 executor를 작성할 수 있다.

**Sample Apex controller:**

```apex
public with sharing class TWProductSearchController {
    public Product2[] products {get; set;}
    public String error {get; set;}
    public TWProductSearchController() {
        products = [SELECT Id FROM Product2 WHERE IsActive = true AND SBQQ__Component__c
            = false];
    }
}
```

**Sample Visualforce page:**

```xml
<apex:page controller="TWProductSearchController" contentType="text/xml"
    showHeader="false" sidebar="false">
    <products error="{!error}">
        <apex:repeat var="product" value="{!products}">
            <product id="{!product.Id}"/>
        </apex:repeat>
    </products>
</apex:page>
```

---

## 7. Document Store Plugin

**목적:** CPQ document store plugin으로 quote document를 custom object 또는 third-party integration에 저장한다.

- **인터페이스:** `SBQQ.DocumentStorePlugin`
- **EDITIONS:** Available in All Salesforce CPQ Editions

**Table 8: storeDocument Method** (원문 표 전수):

| Param | Type | Description |
|---|---|---|
| `quote` | SObject (SBQQ__Quote__c) | Quote record information from the Salesforce CPQ quote. |
| `document` | SObject (SBQQ__QuoteDocument__c) | The quote document record from Salesforce CPQ. |
| `content` | Blob | Represents the actual PDF or Word file contents. |

**메서드 시그니처:**
- `public void storeDocument(SObject quote, SObject document, Blob content)`
- `public Boolean isQuoteDocumentSaved()` — Reserved for future use
- `public SObject[] listDocuments(SObject quote)` — Reserved for future use

**Sample document store plugin:**

```apex
public class TestDocumentStorePlugin implements SBQQ.DocumentStorePlugin {
    public void storeDocument(SObject quote, SObject document, Blob content) {
        // Custom document saving logic goes here.
    }
    // Reserved for future use
    public Boolean isQuoteDocumentSaved() {
        return true;
    }
    // Reserved for future use
    public SObject[] listDocuments(SObject quote) {
        return null;
    }
}
```

---

## 8. Custom Action Plugin

**목적:** CPQ의 custom action 전후로 코드를 실행한다. 현재는 cloning action만 지원한다. `onBeforeCloneLine` 또는 `onAfterCloneLine` 메서드를 호출해 cloning 전/직후에 quote line을 평가·수정한다. (JavaScript 기반 — custom script record에 작성)

**설정:** custom script record를 생성한 후 Code 필드에 코드를 입력 → CPQ package settings의 plugins 탭에서 Custom Action Plugin 필드에 custom script 이름을 입력·저장한다.

**Table 9: Parameters for onBeforeCloneLine and onAfterCloneLine** (원문 표 전수 — `clonedLines` 행의 Definition은 sub-property 목록을 담으며 PDF p.110→p.111로 분할된 셀을 layout-mode로 재결합함):

| Parameter | Type | Definition |
|---|---|---|
| `quote` | QuoteModel | A representation of the quote object. |
| `clonedLines` | Object | **Properties:** <br>· `clonedLines` — Available with `onAfterCloneLine`. An array of new QuoteLineModels created from the clone action. When using `onBeforeCloneLine`, this property is undefined. <br>· `originalLines` — Available with `onBeforeCloneLine` and `onAfterCloneLine`. An array of QuoteLineModels for the original quote lines that the user is cloning. <br>You can use the `cloneLines` parameter to change fields on the old and new quote lines. |
| `conn` | Object | A jsforce connection. |

> 원문 [sic]: `clonedLines` 셀 마지막 문장은 메서드명을 `cloneLines`('s' 빠짐)로 표기하나 실제 메서드는 `onBeforeCloneLine`/`onAfterCloneLine`이다 — 원문 그대로 인용.

**기본 템플릿** (추가 코드 없이; onBeforeCloneLine 또는 onAfterCloneLine 사용):

```javascript
export function onBeforeCloneLine(quote, clonedLines) {
    return Promise.resolve();
}
```

---

## 9. Salesforce CPQ Electronic Signature Plugin

**목적:** 개발자가 org에 electronic signature 기능을 추가한다. 구매·계약 finalize 등 서명 관련 프로세스 간소화에 유용하다.

- **인터페이스:** `ElectronicSignaturePlugin` (global virtual interface), `ElectronicSignaturePlugin2 extends ElectronicSignaturePlugin`
- **EDITIONS:** Available in All Salesforce CPQ Editions

```apex
global virtual interface ElectronicSignaturePlugin {
    void send(QuoteDocument__c[] documents);
    void updateStatus(QuoteDocument__c[] documents);
    void revoke(QuoteDocument__c[] documents);
    String getSendButtonLabel();
}

global interface ElectronicSignaturePlugin2 extends
ElectronicSignaturePlugin {
    Boolean isSendButtonEnabled();
}
```

**메서드 시그니처:**
- `ElectronicSignaturePlugin` (global virtual interface):
  - `void send(QuoteDocument__c[] documents)`
  - `void updateStatus(QuoteDocument__c[] documents)`
  - `void revoke(QuoteDocument__c[] documents)`
  - `String getSendButtonLabel()`
- `ElectronicSignaturePlugin2` (extends `ElectronicSignaturePlugin`):
  - `Boolean isSendButtonEnabled()`

---

## 플러그인 한눈에 — 인터페이스 요약

| Plugin | 인터페이스 | 핵심 메서드 | EDITIONS |
|---|---|---|---|
| Product Search | `SBQQ.ProductSearchPlugin` | search/suggest, isFilterHidden/isInputHidden, isSearchCustom/isSuggestCustom | All Editions |
| Recommended Products | `SBQQ.ProductRecommendationPlugin` | recommend | Winter '21+ |
| External Configurator | (Visualforce/외부 앱 + easyXDM) | postMessage payload | Winter '16+ (Create는 Winter '18+) |
| Legacy Quote Calculator | `SBQQ.QuoteCalculatorPlugin`, `SBQQ.QuoteCalculatorPlugin2` | onBefore/AfterCalculate, onBefore/AfterPriceRules, onInit, getReferencedFields | All Editions (deprecated) |
| Product Configuration Initializer | (Visualforce controller + page) | Apex controller | — |
| Product Search Executor | (Visualforce controller + page) | Apex controller | — |
| Document Store | `SBQQ.DocumentStorePlugin` | storeDocument, isQuoteDocumentSaved, listDocuments | All Editions |
| Custom Action | (JavaScript custom script) | onBeforeCloneLine, onAfterCloneLine | — |
| Electronic Signature | `ElectronicSignaturePlugin`, `ElectronicSignaturePlugin2` | send, updateStatus, revoke, getSendButtonLabel, isSendButtonEnabled | All Editions |

---

## 관련 노트
- [[JavaScript Quote Calculator Plugin]] — CPQ 계산의 핵심 plugin. Legacy Quote Calculator Plugin을 대체하는 현행 권장 방식.
- [[CPQ API Models]] — QuoteModel·QuoteLineModel 등 Custom Action Plugin·QCP가 다루는 데이터 모델.
