---
tags: [field-service, fsl, sobject, object-reference, inventory, product, return-order, shipment, pricebook, product-transfer, serialized-product, 현장서비스, 재고]
source: field_service_dev.pdf (Field Service Developer Guide v67.0 Summer '26)
created: 2026-06-23
aliases: [Pricebook2, Product2, ProductConsumed, ProductConsumedState, ProductItem, ProductItemTransaction, ProductRequest, ProductRequestLineItem, ProductRequired, ProductTransfer, ReturnOrder, ReturnOrderLineItem, SerializedProduct, SerializedProductTransaction, Shipment, Field Service Inventory Objects, 재고, 반품 주문, 배송, 제품 소비, 제품 이전, 직렬화 제품, 가격표]
---

# 객체 레퍼런스 — Inventory (Product·ReturnOrder·Shipment)

> Field Service Inventory Management 클러스터의 SOAP API 객체 15종 전수 레퍼런스 — 가격표(Pricebook2)·제품(Product2)부터 재고 추적(ProductItem·ProductTransfer), 부품 주문(ProductRequest), 반품/수리(ReturnOrder), 직렬화 제품(SerializedProduct), 배송(Shipment)까지. 각 객체의 설명·Supported Calls·전 필드·Special Access Rules·Usage·Associated Objects를 담는다.

> 이 노트는 Field Service의 **재고 관리(Inventory Management) 데이터 모델** 도메인 SOAP API 객체 정의를 다룬다. 전체 데이터 모델 개요와 객체 간 관계도(ER diagram)는 [[Field Service 개요와 데이터 모델]], 객체 카탈로그 요약은 [[Field Service Objects]]를 참조한다.
>
> **표준 CRM 객체 주의:** `Pricebook2`·`Product2`는 Field Service 전용이 아니라 Sales/Commerce 전반에서 쓰이는 표준 CRM 객체이기도 하다. 여기서는 Field Service Developer Guide가 게재한 정의를 그대로 옮기며, 가격표·제품의 일반 CRM 맥락(PricebookEntry·OpportunityLineItem 등)도 PDF 원문 범위 내에서 함께 기술한다.

---

## 객체 한눈에 (15)

| # | 객체 | 한 줄 | 필드 수(전수) | API 도입 |
|---|---|---|---|---|
| 1 | Pricebook2 | 조직이 판매하는 제품 목록을 담는 가격표 | 10 | — |
| 2 | Product2 | 회사가 판매하는 제품 | 30 | — |
| 3 | ProductConsumed | 작업지시(WO/WOLI) 완료에 사용된 재고 항목 | 18 | — |
| 4 | ProductConsumedState | 소비된 직렬화 제품의 상태 | 6 | v57.0+ |
| 5 | ProductItem | 특정 위치의 특정 제품 재고 | 10 | — |
| 6 | ProductItemTransaction | 제품 항목에 대한 자동 생성 거래 기록 | 8 | — |
| 7 | ProductRequest | 부품 주문 | 26 | — |
| 8 | ProductRequestLineItem | 부품 주문의 라인 아이템 | 27 | — |
| 9 | ProductRequired | WO/WOLI 완료에 필요한 제품 | 9 | — |
| 10 | ProductTransfer | 위치 간 재고 이전 | 26 | — |
| 11 | ReturnOrder | 재고/제품의 반품 또는 수리 | 54 | v42.0+ |
| 12 | ReturnOrderLineItem | 반품 주문의 라인 아이템 | 40 | v42.0+ |
| 13 | SerializedProduct | 개별 제품의 일련번호 기록 | 10 | v50.0+ |
| 14 | SerializedProductTransaction | 직렬화 제품 거래(읽기 전용 계열) | 6 | v57.0+ |
| 15 | Shipment | 재고/주문 항목의 운송 | 38 | — |

> 위 "필드 수(전수)"는 본문 표에 실제로 옮긴 PDF 행 수다. (소스 추출 노트의 추정치보다 많은 경우가 있으나, 본문은 PDF 행 전수를 누락 없이 옮겼다.)
>
> 필드 표 형식: PDF는 2열(Field Name | Details)이고 Details 셀 안에 Type/Properties/Description/Relationship Name/Relationship Type/Refers To가 세로 나열돼 있다. 본 노트는 이를 4열(Field · Type · Properties · Description)로 펼치고, 관계 필드는 Description 끝에 `RelName / RelType / Refers To`를 표기했다.
>
> **[sic] 보존:** PDF 원문의 오타·오기를 의도적으로 그대로 둔 곳에 `[sic]`을 달았다(예: "Pricebok", "Products2", "ProductClassfield", "shouldn't be check", ProductRequest 일부 설명의 "shipment"/"product transfer" 오기 등).

---

## 1. Pricebook2

조직이 판매하는 제품 목록을 담는 **가격표(price book)**를 나타낸다.

> **Note (원문):** Price books are represented by Pricebook2 objects. As of API version 8.0, the Pricebook object is no longer available. Requests containing Pricebook are refused, and responses don't contain the Pricebook object.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** (없음)

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | string | Create, Filter, Group, Nillable, Sort, Update | Text description of the price book. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 가격표가 활성(true)인지 여부. 비활성 가격표는 UI 여러 곳에서 숨겨진다. 필요한 만큼 자주 변경 가능. Label은 Active. |
| IsArchived | boolean | Defaulted on create, Filter, Group, Sort | 가격표가 보관(archived, true)되었는지 여부. 읽기 전용. |
| IsDeleted | boolean | Defaulted on create, Filter | 가격표가 휴지통으로 이동(true)되었는지 여부. Label은 Deleted. |
| IsStandard | boolean | Defaulted on create, Filter, Group, Sort | 조직의 표준 가격표(true)인지 여부. 모든 조직은 하나의 표준 가격표를 가지며 나머지는 커스텀 가격표다. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드와 관련된 레코드를 마지막으로 본 시각. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드를 마지막으로 본 시각. null이면 referenced(LastReferencedDate)됐지만 view되지 않았을 수 있다. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | Required. 객체 이름. 표준 가격표에서는 읽기 전용. Label은 Price Book Name. |
| ValidFrom | dateTime | Create, Filter, Nillable, Sort, Update | Commerce 가격표가 최초로 유효해지는 날짜·시각. null이면 활성 즉시 유효. v48.0+. |
| ValidTo | dateTime | Create, Filter, Nillable, Sort, Update | Commerce 가격표가 유효한 마지막 날짜·시각. null이면 비활성화될 때까지 유효. v48.0+. |

**Usage:** 가격표는 조직이 판매하는 제품 목록이다. 각 조직은 제품·서비스별 표준/일반 정가를 정의하는 **표준 가격표 하나**를 가진다. 할인·채널·시장·특정 계정/기회 용도로 **여러 커스텀 가격표**를 둘 수 있다. 클라이언트 앱은 커스텀 가격표를 생성/삭제/수정할 수 있으나 표준 가격표는 **수정만** 가능하다. 일부 조직은 표준 가격표만으로 충분하다. 다른 가격표를 설정한 경우, 커스텀 가격표에서 list price를 설정할 때 표준 가격표를 참조할 수 있다. 표준/커스텀 가격표 조회에 사용한다. 흔한 용도: API로 PricebookEntry 레코드를 구성하기 위해 유효한 Pricebook2 ID를 얻는 것. 클라이언트 앱은 PricebookEntry에 대해 Query / 표준·커스텀 가격표에 Create / Update / Delete / 생성·수정 시 IsActive 변경이 가능하다.

- **Pricebook2 · Product2 · PricebookEntry 관계:** 가격표 = Pricebook2 레코드(v8.0+, Pricebook 제거), 제품 = Product2 레코드(v8.0+, Product 제거). 각 가격표는 0개 이상의 PricebookEntry를 가지며, 한 entry는 특정 통화에서 한 제품을 판매하는 가격을 정의한다. products 기능이 켜진 조직에서만 정의되며, 아니면 `describeGlobal()`에 Pricebook2가 나타나지 않고 접근 불가. 라인 아이템이 어떤 Pricebook2의 PricebookEntry를 참조하는 중에 그 Pricebook2를 삭제하면: 라인 아이템은 영향 없고, Pricebook2는 archived 처리되어 API에서 사용 불가가 된다. PDF의 "Product and Schedule Objects" 다이어그램 참조(본 노트에는 텍스트 설명만).
- **가격표 설정 절차:** 1) 제품 데이터를 Product2 레코드로 로드(제품당 하나). 2) 각 Product2에 대해 표준 Pricebook2와 연결하는 PricebookEntry 생성 — 커스텀 가격표에서 같은 통화의 가격을 정의하기 전에 해당 통화의 표준 가격을 먼저 정의해야 한다. 3) 커스텀 가격표용 Pricebook2 생성. 4) 각 Pricebook2에 대해 추가할 모든 Product2마다 PricebookEntry 생성(UnitPrice·CurrencyIsoCode 등 고유 속성 지정).

**Code Sample — Java (원문 그대로, [sic] "Pricebok"):**

```java
public void pricebookSample() {
  try {
    //Create a custom pricebook
    Pricebook2 pb = new Pricebook2();
    pb.setName("Custom Pricebok");
    pb.setIsActive(true);
    SaveResult[] saveResults = connection.create(new SObject[]{pb});
    pb.setId(saveResults[0].getId());

      // Create a new product
      Product2 product = new Product2();
      product.setIsActive(true);
      product.setName("Product");
      saveResults = connection.create(new SObject[]{product});
      product.setId(saveResults[0].getId());

      // Add product to standard pricebook
      QueryResult result = connection.query(
          "select Id from Pricebook2 where isStandard=true"
      );
      SObject[] records = result.getRecords();
      String stdPbId = records[0].getId();

      // Create a pricebook entry for standard pricebook
      PricebookEntry pbe = new PricebookEntry();
      pbe.setPricebook2Id(stdPbId);
      pbe.setProduct2Id(product.getId());
      pbe.setIsActive(true);
      pbe.setUnitPrice(100.0);
      saveResults = connection.create(new SObject[]{pbe});

      // Create a pricebook entry for custom pricebook
      pbe = new PricebookEntry();
      pbe.setPricebook2Id(pb.getId());
      pbe.setProduct2Id(product.getId());
      pbe.setIsActive(true);
      pbe.setUnitPrice(100.0);
      saveResults = connection.create(new SObject[]{pbe});
    } catch (ConnectionException ce) {
      ce.printStackTrace();
    }
}
```

**Associated Objects:** `Pricebook2ChangeEvent` (v48.0) — change events; `Pricebook2History` — 추적 필드 히스토리.

---

## 2. Product2

회사가 판매하는 **제품**을 나타낸다. 수량/매출 스케줄(연금 등)에만 쓰이는 필드가 몇 개 있다. 스케줄은 products & schedules 기능이 켜진 조직에서만 쓸 수 있고, 꺼져 있으면 schedule 필드가 보이지 않으며 query/create/update가 불가능하다.

> **Note (원문, [sic] "Products2"):** As of API version 8.0, the Product object is no longer available. Requests that contain Product are refused, and responses don't contain the Product object. Use the Products2 object instead.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** `ConfigureDuringSale`·`IsSoldOnlyWithOtherProds` 필드는 Industry Automotive 또는 Subscription Management가 켜진 v58.0+에서 사용 가능.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| BillingPolicyId | reference | Create, Filter, Group, Nillable, Sort, Update | 관련 billing policy의 ID. Subscription Management 활성 시 사용. v55.0+. RelName: BillingPolicy; RelType: Lookup; Refers To: BillingPolicy. |
| CanUseQuantitySchedule | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 제품이 수량 스케줄을 가질 수 있는지(true). Label은 Quantity Scheduling Enabled. |
| CanUseRevenueSchedule | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 제품이 매출 스케줄을 가질 수 있는지(true). Label은 Revenue Scheduling Enabled. |
| ConnectionReceivedId | reference | Filter, Group, Nillable, Sort | 이 레코드를 조직에 공유한 PartnerNetworkConnection의 ID. Salesforce to Salesforce 활성 시. |
| ConnectionSentId | reference | Filter, Group, Nillable, Sort | 이 레코드가 공유된 PartnerNetworkConnection의 ID. Salesforce to Salesforce 활성 시. v16.0+에서는 이 값이 null. 레코드를 연결로 전달하려면 PartnerNetworkRecordConnection 객체 사용. |
| ConfigureDuringSale | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 번들 주문/견적 생성 시 사용자가 configuration을 편집할 수 있는지 결정. v58.0+. Industries Automotive/Subscription Management 활성 시. 값: Allowed — 번들에 라인 아이템 추가 시 변경 허용(제품 추가·수량 편집 등); NotAllowed — 변경 불가. |
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | multicurrency 활성 조직에서만. 조직이 허용하는 통화의 ISO 코드. |
| Description | textarea | Create, Filter, Nillable, Sort, Update | 이 레코드의 텍스트 설명. Label은 Product Description. |
| DisplayUrl | url | Create, Filter, Nillable, Sort, Update | 연결된 외부 데이터 소스의 특정 버전 레코드로 가는 URL. |
| ExternalDataSourceId | reference | Create, Filter, Group, Nillable, Sort, Update | 관련 외부 데이터 소스의 ID. |
| ExternalId | string | Create, Filter, Group, Nillable, Sort, Update | 연결된 외부 데이터 소스의 레코드 고유 식별자. 예: ID #123. |
| Family | picklist | Create, Filter, Group, Nillable, Sort, Update | 이 레코드의 product family 이름. UI에서 picklist로 구성. 유효 값은 `describeSObjects()` 호출로 확인. Label은 Product Family. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 활성 레코드(true)인지. 비활성 Product2는 UI 여러 곳에서 숨겨진다. 자주 변경 가능. Label은 Active. |
| IsArchived | boolean | Defaulted on create, Filter, Group, Sort | 제품이 archived인지. 기본값 false. |
| IsDeleted | boolean | Defaulted on create, Filter | 객체가 휴지통으로 이동(true)되었는지. Label은 Deleted. |
| IsSerialized | boolean | Create, Filter, Group, Sort, Update | 직렬화 제품(true)인지. Label은 Serialized. |
| IsSoldOnlyWithOtherProds | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 제품을 독립 판매할 수 있는지, 번들의 일부로만 판매하는지 결정. v58.0+. Industries Automotive/Subscription Management 활성 시. 기본 false(독립 판매 가능). |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드와 직·간접으로 마지막 상호작용한 시각. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드/리스트뷰를 마지막으로 본 시각. null이면 referenced만 됐고 view되지 않았을 수 있다. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | Required. 레코드 기본 이름. Label은 Product Name. |
| NumberOfQuantityInstallments | int | Create, Filter, Group, Nillable, Sort, Update | 수량 스케줄이 있으면 분할(installment) 횟수. |
| NumberOfRevenueInstallments | int | Create, Filter, Group, Nillable, Sort, Update | 매출 스케줄이 있으면 분할 횟수. |
| ProductClass | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | 읽기 전용. 값은 Type 필드 값 및 제품이 ProductAttribute 레코드에 연결됐는지로 결정. 제품이 bundle/set/simple/variation parent/variation 중 무엇인지. 값: Bundle — 제품 번들의 parent 또는 component; Set — product set에 포함; Simple — variation 없음; VariationParent — 하나 이상 variation의 기준 제품, 자체 SKU 보유하나 판매 불가(판매 가능한 variation들의 parent); Variation — parent의 variation, 각 variation은 자체 SKU 보유. ProductClass=VariationParent이면 절대 바뀌지 않음. ProductAttribute를 붙이면 Variation으로, 모두 떼면 Simple로 바뀜. 기본 Simple. v50.0+, B2B·B2C Commerce 지원 위해 도입. |
| ProductCode | string | Create, Filter, Group, Nillable, Sort, Update | 이 레코드의 기본 product code. 조직이 코드 명명 패턴 정의. |
| QuantityInstallmentPeriod | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 수량 스케줄이 있으면 스케줄이 다루는 기간. |
| QuantityScheduleType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 수량 스케줄이 있으면 그 유형. |
| QuantityUnitOfMeasure | picklist | Create, Filter, Group, Nillable, Sort, Update | 제품의 단위; 예: 킬로그램·리터·케이스. 기본값은 Each 하나뿐이라 직접 만드는 것을 고려. ProductItem의 QuantityUnitOfMeasure 필드가 이 필드 값을 상속. |
| RecalculateTotalPrice | boolean | Defaulted on create, Filter, Group, Sort | 라인 아이템에 Quantity용 자식 schedule row가 있을 때 OpportunityLineItem 계산 동작을 바꿈. 활성 시 rollup 수량이 변하면 수량 rollup 값이 sales price와 곱해져 total price를 변경. |
| RevenueInstallmentPeriod | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 매출 스케줄이 있으면 다루는 기간. |
| RevenueScheduleType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 매출 스케줄이 있으면 그 유형. |
| StockCheckMethod | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 제품 재고 확인 방법. 번들이 사전 포장되고 children을 따로 못 파는 경우 parent에서, 사전 포장이 아니고 fulfillment 중 조립되면 child에서 재고 확인이 흔함. 값: Null — product SKU에서 재고 확인; DoNotCheck — The stock shouldn't be check [sic]; ParentProduct — 번들 parent면 parent에서 확인; ChildProducts — 번들 parent면 child 컴포넌트에서 확인. |
| StockKeepingUnit | string | Create, Filter, Group, Nillable, Sort, Update | 제품의 SKU. ProductCode와 함께 또는 대신 사용. 예: Product Code에 제조사 코드를 추적하고 재판매 시 SKU 부여. |
| TaxPolicyId | reference | Create, Filter, Group, Nillable, Sort, Update | 관련 tax policy의 ID. Subscription Management 활성 시. v55.0+. RelName: TaxPolicy; RelType: Lookup; Refers To: TaxPolicy. |
| TransferRecordMode | picklist | Create, Filter, Group, Nillable, Sort, Update | 직렬화 시 일련번호 기록 시점. FLS에 따라 표시. ProductTransfer의 Product2TransferMode 읽기 전용 값에 영향. 값: SendAndReceive — 보내거나 받을 때 기록; ReceiveOnly — 받을 때만 기록. |
| Type | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort | 제품 유형. 이 값이 Product2의 ProductClassfield [sic] 읽기 전용 값에 영향. 매핑: Base→ProductClass=VariationParent; Null→ProductClass=Simple(독립 제품); Null→ProductClass=Variation(variation 제품); Bundle→ProductClass=Bundle; Set→ProductClass=Set. Note: Revenue Cloud는 Type=Base+ProductClass=VariationParent 또는 Type=Null+ProductClass=Variation을 지원하지 않음. 값 Null, Base, Bundle, Set은 Commerce와 Revenue Cloud가 공존하는 곳에서 사용 가능. Type은 Simple ProductClass 제품에 대해 Null→Bundle로만 업데이트 가능. Revenue Cloud, B2B Commerce, B2C Commerce, 또는 PCM add-on이 있는 클라우드 활성 시. v50.0+. |
| UnitOfMeasureId | reference | Create, Filter, Group, Nillable, Sort, Update | 제품과 연결된 unit of measure의 ID. Revenue Cloud 활성 시. v63.0+. RelName: UnitOfMeasure; Refers To: UnitOfMeasure. |

**Schedule Enabled Flags:** schedules 기능을 켤 때 quantity, revenue, 또는 둘 다 선택. API로 제품 수준에서 `CanUseQuantitySchedule`·`CanUseRevenueSchedule` 플래그로 제어. 둘 중 하나라도 true면 제품과 그 OpportunityLineItem이 해당 유형 스케줄을 가질 수 있다. Product2 생성/수정 시 설정 가능.

**Default Schedule Fields:** 나머지 schedule 필드는 기본 스케줄을 정의한다. 기본값은 Product에 대한 OpportunityLineItem 생성 시 OpportunityLineItemSchedule을 만드는 데 쓰인다. 유효 값(모두 nillable):

| Field | Valid Values |
|---|---|
| RevenueScheduleType | Divide, Repeat |
| RevenueInstallmentPeriod | Daily, Weekly, Monthly, Quarterly, Yearly |
| NumberOfRevenueInstallments | Integer from 1 to 150, inclusive. |
| QuantityScheduleType | Divide, Repeat |
| QuantityInstallmentPeriod | Daily, Weekly, Monthly, Quarterly, Yearly |
| NumberOfQuantityInstallments | Integer from 1 to 150, inclusive |

create/update 시 cross-field 무결성 검사: schedule type이 nil이면 installment period·number of installments도 nil이어야 한다. schedule type이 어떤 값이면 둘 다 non-nil이어야 한다. 위반하는 create/update는 오류로 거부된다. 이 default schedule 필드들 + `CanUseQuantitySchedule` + `CanUseRevenueSchedule`은 restricted picklist 필드이며 schedules 기능이 켜진 조직에서만 사용 가능하다.

**Usage:** 조직의 기본 제품 정보를 정의하는 데 사용. PricebookEntry를 통해 Pricebook2와 reference로 연결된다. 같은 제품을 서로 다른 가격표에, 심지어 같은 가격표에 다른 가격/통화로 여러 번 둘 수 있다. 단, 같은 가격표 내 같은 통화에서는 제품당 가격이 하나뿐이다. 커스텀 가격표에서 쓰려면 모든 표준 가격이 표준 가격표에 PricebookEntry로 추가돼야 한다.

> **Note (원문, [sic]):** You can't create lookup fields to Product2 object, which have Required check box set to true or the Don't Allow Deletion" radio button selected, as the platform would otherwise interpret this and throw an error that you cannot create a master-detail relationship to the object.

구성된 제품을 조회할 수 있다(예: PricebookEntry 구성을 위한 유효 product ID 획득). 클라이언트 앱은 PricebookEntry에 대해 Query / 표준·커스텀 가격표에 Create / Update / Delete / 생성·수정 시 IsActive 변경 가능. products 기능이 켜진 조직에서만 정의되며, 아니면 describeGlobal에 없다. 기회(opportunity)가 사용 중인 제품을 API로 삭제하면 삭제 실패한다. 우회책은 UI에서 삭제(이때 archive 옵션 제공).

> **Note (원문):** On opportunities and opportunity products, workflow rules, validation rules, and Apex triggers fire when an update to a child opportunity product or schedule causes an update to the parent record.

**Associated Objects:** `Product2ChangeEvent` (v44.0) — change events; `Product2Feed` (v18.0) — feed tracking; `Product2History` — 추적 필드 히스토리; `Product2OwnerSharingRule` (v50.0) — sharing rules.

---

## 3. ProductConsumed

field service에서 작업지시(work order) 또는 작업지시 라인 아이템(work order line item)을 완료하는 데 사용된 **재고 항목**을 나타낸다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다. Note: products consumed를 생성하려면 product items에 대한 Read 권한 필요. Note: 비직렬화 제품의 product consumed를 삭제/undelete하려면 product consumed에 대한 Edit·Create·Read 권한 필요. 직렬화 제품을 lookup하는 product consumed 레코드는 product consumed에 대한 Modify All Data 또는 Modify All Records 권한 필요.

**Fields:** (header "Field Name")

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | product consumed에 대한 메모·맥락. |
| IsConsumed | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 참조하는 Product2가 IsSerialized=true이면 product consumed가 처리되었음을 나타냄. 기본 false. |
| IsLocked | boolean | Defaulted on create, Filter, Group, Sort | product consumed 레코드가 잠겼는지. 기본 false. |
| IsProduct2Serialized | boolean | Create, Filter, Nillable, Sort, Update | 제품이 직렬화 제품인지. 기본 false. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | product consumed가 마지막으로 수정된 날짜. UI label Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | product consumed가 마지막으로 view된 날짜. |
| MayEdit | boolean | Defaulted on create, Filter, Group, Sort | product consumed 레코드를 편집할 수 있는지. 기본 false. |
| PricebookEntryId | reference | Create, Filter, Group, Nillable, Sort, Update | product consumed와 연결된 가격표. 작업지시와 product item의 연결 제품이 같은 가격표에 관련되면 Price Book Entry가 product item 기반으로 자동 채워진다. |
| Product2Id | reference | Filter, Group, Nillable, Sort | product consumed와 연결된 제품. |
| ProductConsumedNumber | string | Autonumber, Defaulted on create, Filter, Sort | (Read Only) product consumed를 식별하는 자동 생성 번호. |
| ProductItemId | reference | Create, Filter, Group, Nillable, Sort | product consumed와 연결된 product item. product consumed 레코드를 만들면 소비 수량만큼 연결된 product item 수량이 차감된다. |
| ProductName | string | Filter, Group, Nillable, Sort | product consumed의 이름. |
| QuantityConsumed | double | Create, Filter, Sort, Update | 소비된 제품 수량. |
| QuantityUnitOfMeasure | picklist | Filter, Group, Nillable, Sort | 소비 항목의 단위; 예: 킬로그램·리터. picklist 값은 products의 Quantity Unit of Measure 필드에서 상속. |
| TotalPrice | currency | Filter, Nillable, Sort | product items에 지불한 총 가격. |
| UnitPrice | currency | Create, Filter, Nillable, Sort, Update | product consumed의 단가. |
| WorkOrderId | reference | Create, Filter, Group, Sort | 제품이 소비된 작업지시. |
| WorkOrderLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | 제품이 소비된 작업지시 라인 아이템. |

**Usage:** 작업지시 완료 중 제품이 소비되면 소비를 추적할 product consumed 레코드를 만든다. 작업지시 또는 작업지시 라인 아이템에 추가 가능. 라인 아이템 단위로 추적하면 각 라인 아이템 작업에 어떤 제품이 쓰였는지 알 수 있다. 재고 상태를 얼마나 정밀하게 추적하느냐에 달려 있다: 전체 생애주기(보관·이전·소비)를 추적하려면 product consumed 레코드를 product items에 연결한다(재고 수량 자동 갱신). 소비만 추적하려면 각 product consumed 레코드에 Price Book Entry를 지정하고 Product Item 필드는 비워 둔다.

**Associated Objects:** `ProductConsumedChangeEvent` (v48.0) — change events; `ProductConsumedFeed` — feed tracking; `ProductConsumedHistory` — 추적 필드 히스토리.

---

## 4. ProductConsumedState

Field Service에서 작업지시/작업지시 라인 아이템 완료에 사용된 재고 항목의 **상태**를 나타낸다. v57.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다. Note: products consumed를 생성하려면 product items에 대한 Read 권한 필요. Note: products consumed를 삭제하려면 product items에 대한 Edit·Create·Read 권한 필요.

**Fields:**

| Field | Type | Properties | Description |
|---|---|---|---|
| ConsumedState | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | 직렬화 제품이 소비된 후의 새 상태. |
| IsLocked | boolean | Defaulted on create, Filter, Group, Sort | product consumed 레코드가 잠겼는지. 기본 false. |
| MayEdit | boolean | Defaulted on create, Filter, Group, Sort | product consumed 레코드를 편집할 수 있는지. 기본 false. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | 제품의 이름. |
| ProductConsumedId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | 직렬화 제품 소비에 사용된 Product Consumed. RelName: Owner; RelType: Lookup. |
| SerializedProductId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | 소비되는 직렬화 제품. RelName: Owner; RelType: Lookup. |

> [sic] 두 reference 필드(ProductConsumedId·SerializedProductId)의 Relationship Name이 PDF에 모두 "Owner"로 표기됨 — 오타로 보이나 원문 그대로 보존.

**Associated Objects:** "Product Consumed State History" — 추적 필드에 대한 히스토리 사용 가능. (이름이 공백 포함으로 표기됨 [sic])

---

## 5. ProductItem

field service에서 **특정 위치의 특정 제품 재고**(예: 메인 창고에 보관된 모든 볼트)를 나타낸다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:** (header "Field Name")

| Field | Type | Properties | Description |
|---|---|---|---|
| LastReferencedDate | dateTime | Filter, Nillable, Sort | product item이 마지막으로 수정된 날짜. UI label Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | product item이 마지막으로 view된 날짜. |
| LocationId | reference | Create, Filter, Group, Sort | product item과 연결된 위치. 보통 보관 장소를 나타냄. RelName: Location; RelType: Lookup; Refers To: Location. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | product item의 소유자. Polymorphic. RelName: Owner; RelType: Lookup; Refers To: Group, User. |
| Product2Id | reference | Create, Filter, Group, Sort | product item과 연결된 제품(재고 내 제품 유형 표현). RelName: Product2; RelType: Lookup; Refers To: Product2. |
| ProductItemNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | (Read Only) product item을 식별하는 자동 생성 번호. |
| ProductName | string | Filter, Group, Nillable, Sort | product item의 이름. 무엇이 어디 보관됐는지 나타내는 이름 권장; 예: Batteries in Warehouse A. |
| QuantityOnHand | double | Create, Filter, Sort, Update | 위치의 수량. 일련번호를 추가하려면 이 값이 1이어야 한다. |
| QuantityUnitOfMeasure | picklist | Create, Filter, Group, Nillable, Sort, Update | product item의 단위; 예: 킬로그램·리터. picklist 값은 products의 Quantity Unit of Measure 필드에서 상속. |
| SerialNumber | string | Create, Filter, Group, Nillable, Sort, Update | 식별용 고유 번호. 일련번호를 입력하려면 Quantity on Hand가 1이어야 한다. |

**Usage:** 각 product item은 제품 하나와 위치 하나에 연결된다. 한 제품이 여러 위치에 보관되면 위치마다 별도 product item으로 추적된다.

**Associated Objects:** `ProductItemChangeEvent` (v48.0) — change events; `ProductItemFeed` — feed tracking; `ProductItemHistory` — history; `ProductItemOwnerSharingRule` — sharing rules; `ProductItemShare` — sharing.

---

## 6. ProductItemTransaction

field service에서 product item에 대해 취한 **동작(action)**을 나타낸다. product item이 보충·소비·조정될 때를 추적하는 자동 생성 레코드다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `update()`, `undelete()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다. Modify All Data 또는 Modify All Records 권한이 있는 사용자만 이 객체를 삭제할 수 있다.

**Fields:** (header "Field Name")

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | 거래 설명. 거래 레코드 생성 시 공백이나 업데이트 가능. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드와 직·간접으로 마지막 상호작용한 시각. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드/리스트뷰를 마지막으로 본 시각. null이면 referenced만 됐을 수 있다. |
| ProductItemId | reference | Create, Filter, Group, Sort | 연결된 product item. RelName: ProductItem; RelType: Lookup; Refers To: ProductItem. |
| ProductItemTransactionNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | (Read Only) product item transaction을 식별하는 자동 생성 번호. |
| Quantity | double | Create, Filter, Sort | 거래에 관련된 product item 수량. 재고가 소비됐으면 음수. |
| RelatedRecordId | reference | Filter, Group, Nillable, Sort | (Read Only) 동작과 관련된 product consumed 또는 product transfer. 소비/이전과 무관하면 공백. Polymorphic. RelName: RelatedRecord; RelType: Lookup; Refers To: ProductTransfer, Visit. |
| TransactionType | picklist | Create, Filter, Group, Restricted picklist, Sort | 거래가 추적하는 동작. Replenished: 부품이 위치에 적재될 때(product item 생성 시 만들어짐). Consumed: 작업지시 완료에 부품 소비 시(WO/WOLI의 Products Consumed 관련 목록에 레코드 추가 시 만들어짐). Adjusted: 소비에 불일치/변경 시(QoH 편집, product consumed 업데이트/삭제 [sic "delete"], 또는 product transfer 삭제 시 만들어짐). Transferred: 위치 간 부품 이전 시. |

**Associated Objects:** `ProductItemTransactionChangeEvent` — change events; `ProductItemTransactionFeed` — feed tracking; `ProductItemTransactionHistory` — 추적 필드 히스토리.

---

## 7. ProductRequest

field service에서 부품(part) 하나 또는 여럿에 대한 **주문(order)**을 나타낸다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다. 인증된 외부 사용자(external users)는 ProductRequest 객체를 생성·업데이트할 수 있다.

**Fields:** (header "Field Name")

| Field | Type | Properties | Description |
|---|---|---|---|
| AccountId | reference | Create, Filter, Group, Nillable, Sort, Update | product request와 연결된 계정. RelName: Account; RelType: Lookup; Refers To: Account. |
| CaseId | reference | Create, Filter, Group, Nillable, Sort, Update | product request와 연결된 케이스. RelName: Case; RelType: Lookup; Refers To: Case. |
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | multicurrency 활성 시에만. 조직이 허용하는 통화의 ISO 코드. UI label Currency ISO Code. |
| Description | textarea | Create, Nillable, Update | 제공 필드에 없는 세부 정보용 텍스트 필드. |
| DestinationLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | 제품이 배송되는 곳. RelName: DestinationLocation; RelType: Lookup; Refers To: Location. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | product request가 마지막으로 수정된 날짜. UI label Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | product request가 마지막으로 view된 날짜. |
| NeedByDate | dateTime | Create, Filter, Nillable, Sort, Update | 제품이 배송돼야 하는 날짜. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | The owner of the shipment. [sic "shipment"] Polymorphic. RelName: Owner; RelType: Lookup; Refers To: Group, User. |
| ProductRequestNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | An auto-assigned number that identifies the shipment. [sic "shipment"] |
| ShipToAddress | address | Filter, Nillable | 제품이 배송될 주소. |
| ShipToCity | string | Create, Filter, Group, Nillable, Sort, Update | 제품이 배송될 도시. |
| ShipToCountry | string | Create, Filter, Group, Nillable, Sort, Update | 제품이 배송될 국가. |
| ShipToCountryCode | picklist | Create, Filter, Group, Nillable, Sort, Update | ISO 3166-1 alpha-2 표준을 따르는 두 글자 대문자 국가 코드. |
| ShipToGeocodeAccuracy | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 배송 주소 geocode의 정확도. |
| ShipToLatitude | double | Create, Filter, Nillable, Sort, Update | 제품이 배송될 위치의 위도. |
| ShipToLongitude | double | Create, Filter, Nillable, Sort, Update | 제품이 배송될 위치의 경도. |
| ShipToPostalCode | string | Create, Filter, Group, Nillable, Sort, Update | 제품이 배송될 주소의 우편번호. |
| ShipToState | string | Create, Filter, Group, Nillable, Sort, Update | 제품이 배송될 주(state) 이름. |
| ShipToStateCode | picklist | Create, Filter, Group, Nillable, Sort, Update | ISO 3166-1 alpha-2 표준을 따르는 두 글자 대문자 주 코드. |
| ShipToStreet | textarea | Create, Filter, Group, Nillable, Sort, Update | 제품이 배송될 도로명 주소. |
| ShipmentType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 배송 유형. 기본 picklist 값: None, Rush, Overnight, Next Business Day, Pick Up. |
| SourceLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | 제품이 출하되는 위치. RelName: SourceLocation; RelType: Lookup; Refers To: Location. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | Status of the product transfer. [sic "transfer"] |
| WorkOrderId | reference | Create, Filter, Group, Nillable, Sort, Update | product request와 관련된 작업지시. RelName: WorkOrder; RelType: Lookup; Refers To: WorkOrder. |
| WorkOrderLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | product request와 관련된 작업지시 라인 아이템. RelName: WorkOrderLineItem; RelType: Lookup; Refers To: WorkOrderLineItem. |

**Associated Objects:** `ProductRequestChangeEvent` (v48.0) — change events; `ProductRequestFeed` — feed tracking; `ProductRequestHistory` — history; `ProductRequestOwnerSharingRule` — sharing rules; `ProductRequestShare` — sharing.

---

## 8. ProductRequestLineItem

field service에서 부품에 대한 **요청(request)**을 나타낸다. product request line item은 product request의 구성 요소다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다. product request line item을 (커스텀 필드를 통해) 데이터가 있는 커스텀 객체와의 master-detail 관계에서 master로 쓸 수 없다. [sic]

**Fields:** (header "Field Name")

| Field | Type | Properties | Description |
|---|---|---|---|
| AccountId | reference | Create, Filter, Group, Nillable, Sort, Update | product request line item과 연결된 계정. RelName: Account; RelType: Lookup; Refers To: Account. |
| CareProgramEnrolleeId | reference | Create, Filter, Group, Nillable, Sort, Update | 연결된 care program enrollee의 ID. v49.0+. RelName: CareProgramEnrollee; RelType: Lookup; Refers To: CareProgramEnrollee. |
| CaseId | reference | Create, Filter, Group, Nillable, Sort, Update | 연결된 케이스. RelName: Case; RelType: Lookup; Refers To: Case. |
| Description | textarea | Create, Nillable, Update | 제공 필드에 없는 세부 정보. |
| DestinationLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | 제품이 배송되는 곳. RelName: DestinationLocation; RelType: Lookup; Refers To: Location. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 직·간접으로 마지막 상호작용한 시각. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 마지막으로 view한 시각. null이면 referenced만 됐을 수 있다. |
| NeedByDate | dateTime | Create, Filter, Nillable, Sort, Update | 제품이 배송돼야 하는 날짜. |
| ParentId | reference | Create, Filter, Group, Sort | 라인 아이템이 속한 product request. RelName: Parent; RelType: Lookup; Refers To: ProductRequest. |
| Product2Id | reference | Create, Filter, Group, Sort, Update | 연결된 제품. RelName: Product2; RelType: Lookup; Refers To: Product2. |
| ProductRequestLineItemNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | (Read Only) product request line item을 식별하는 자동 할당 번호. |
| QuantityRequested | double | Create, Filter, Sort, Update | 요청 수량. |
| QuantityUnitOfMeasure | picklist | Create, Filter, Group, Nillable, Sort, Update | 요청 제품의 단위; 예: 그램·리터·units. picklist 값 커스터마이즈 가능. |
| ShipToAddress | address | Filter, Nillable | 제품이 필요한 물리적 주소. |
| ShipToCity | string | Create, Filter, Group, Nillable, Sort, Update | 제품이 필요한 주소의 도시. |
| ShipToCountry | string | Create, Filter, Group, Nillable, Sort, Update | 제품이 필요한 주소의 국가. |
| ShipToGeocodeAccuracy | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 제품이 필요한 주소 geocode의 정확도. Compound Field Considerations and Limitations 참조. API only. |
| ShipToLatitude | double | Create, Filter, Nillable, Sort, Update | Longitude와 함께 제품이 필요한 주소의 정밀 geolocation 지정. –90~90, 소수점 15자리까지. API only. |
| ShipToLongitude | double | Create, Filter, Nillable, Sort, Update | Latitude와 함께 제품이 필요한 주소의 정밀 geolocation 지정. –180~180, 소수점 15자리까지. API only. |
| ShipToPostalCode | string | Create, Filter, Group, Nillable, Sort, Update | 제품이 필요한 주소의 우편번호. |
| ShipToState | string | Create, Filter, Group, Nillable, Sort, Update | 제품이 필요한 주소의 주(state). |
| ShipToStreet | textarea | Create, Filter, Group, Nillable, Sort, Update | 제품이 필요한 주소의 도로명. |
| ShipmentType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 배송 유형. 커스터마이즈 가능 picklist: Rush, Overnight, Next Business Day, Pick Up. |
| SourceLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | 요청 시점의 제품 위치. RelName: SourceLocation; RelType: Lookup; Refers To: Location. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | The status of the shipment. 커스터마이즈 가능 picklist: Draft, Submitted, Received. |
| WorkOrderId | reference | Create, Filter, Group, Nillable, Sort, Update | 제품이 필요한 작업지시. RelName: WorkOrder; RelType: Lookup; Refers To: WorkOrder. |
| WorkOrderLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | 제품이 필요한 작업지시 라인 아이템. RelName: WorkOrderLineItem; RelType: Lookup; Refers To: WorkOrderLineItem. |

**Associated Objects:** `ProductRequestLineItemChangeEvent` (v48.0) — change events; `ProductRequestLineItemFeed` — feed tracking; `ProductRequestLineItemHistory` — 추적 필드 히스토리.

---

## 9. ProductRequired

field service에서 작업지시 또는 작업지시 라인 아이템을 완료하는 데 **필요한 제품**을 나타낸다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:** (header "Field Name")

| Field | Type | Properties | Description |
|---|---|---|---|
| LastReferencedDate | dateTime | Filter, Nillable, Sort | product required가 마지막으로 수정된 날짜. UI label Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | product required가 마지막으로 view된 날짜. |
| ParentRecordId | reference | Create, Filter, Group, Sort | 제품이 필요한 작업지시 또는 작업지시 라인 아이템. Polymorphic. RelName: ParentRecord; RelType: Lookup; Refers To: Visit, WorkOrder, WorkOrderLineItem, WorkType. |
| ParentRecordType | string | Filter, Group, Nillable, Sort | parent 레코드가 작업지시인지 작업지시 라인 아이템인지 나타냄. |
| Product2Id | reference | Create, Filter, Group, Sort, Update | 필요한 제품. RelName: Product2; RelType: Lookup; Refers To: Product2. |
| ProductName | string | Filter, Group, Nillable, Sort | 필요한 제품의 이름. |
| ProductRequiredNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | (Read only) product required를 식별하는 자동 생성 번호. |
| QuantityRequired | double | Create, Filter, Nillable, Sort, Update | 제품의 필요 수량. |
| QuantityUnitOfMeasure | picklist | Create, Filter, Group, Nillable, Sort, Update | 필요 제품의 단위; 예: 킬로그램·리터. picklist 값은 products의 Quantity Unit of Measure 필드에서 상속. |

**Usage:** 필요 제품(required products)은 work type·작업지시·작업지시 라인 아이템에 추가해 배정된 service resource가 올바른 장비를 갖고 도착하도록 보장한다. work type에 추가하면 시간 절약·일관성 유지에 도움이 된다. WO·WOLI는 자신의 work type의 필요 제품을 상속한다. 예: 모든 전구 교체 작업에 사다리와 전구가 필요하면 이를 Light Bulb Replacement work type에 필요 제품으로 추가하고, 그 work type을 WO에 적용하면 필요 제품이 추가된다.

**Associated Objects:** `ProductRequiredChangeEvent` — change events; `ProductRequiredFeed` — feed tracking; `ProductRequiredHistory` — 추적 필드 히스토리.

---

## 10. ProductTransfer

field service에서 **위치 간 재고 이전**을 나타낸다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service가 켜져 있어야 한다.

**Fields:** (header "Field Name")

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | 제공 필드에 없는 세부 정보. |
| DestinationLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | 제품이 배송될 곳. RelName: DestinationLocation; RelType: Lookup; Refers To: Location. |
| ExpectedPickupDate | dateTime | Create, Filter, Nillable, Sort, Update | 제품이 픽업될 것으로 예상되는 날짜. |
| IsReceived | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | 제품이 수령됐음을 표시하는 체크박스. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | The date when the product request was last modified. [sic "product request"] UI label Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | The date when the product request was last viewed. [sic "product request"] |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | product transfer의 소유자. Polymorphic. RelName: Owner; RelType: Lookup; Refers To: Group, User. |
| Product2Id | reference | Create, Filter, Group, Nillable, Sort, Update | product transfer와 연결된 제품의 lookup 필드. RelName: Product2; RelType: Lookup; Refers To: Product2. |
| Product2TransferRecordMode | reference | Filter, Group, Nillable, Sort | 직렬화 시 일련번호 기록 시점. FLS에 따라 product transfer에 읽기 전용으로 표시. 값: SendAndReceive — 보내거나 받을 때 기록; ReceiveOnly — 받을 때만 기록. RelName: Product2.TransferRecordMode; RelType: Lookup; Refers To: Product2.TransferRecordMode. (Type=reference이나 picklist 같은 값 설명 — 원문 그대로) |
| ProductRequestId | reference | Filter, Group, Nillable, Sort | product transfer와 연결된 product request의 lookup 필드. RelName: ProductRequest; RelType: Lookup; Refers To: ProductRequest. |
| ProductRequestLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | product transfer와 연결된 product request line item의 lookup 필드. RelName: ProductRequestLineItem; RelType: Lookup; Refers To: ProductRequestLineItem. |
| ProductTransferNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | product transfer를 식별하는 자동 할당 번호. |
| QuantityReceived | double | Create, Filter, Nillable, Sort, Update | 목적지 위치에서 수령한 제품 수량. |
| QuantitySent | double | Create, Filter, Sort, Update | 출발지 위치에서 보낸 제품 수량. |
| QuantityUnitOfMeasure | picklist | Create, Filter, Group, Nillable, Sort, Update | 제품의 단위, 예: 그램·리터·units. |
| ReceivedById | reference | Create, Filter, Group, Nillable, Sort, Update | 목적지 위치에서 제품을 수령한 연락처의 lookup 필드. Polymorphic. RelName: ReceivedBy; RelType: Lookup; Refers To: Group, User. |
| ReturnOrderId | reference | Filter, Group, Nillable, Sort | product transfer와 연결된 반품 주문. RelName: ReturnOrder; RelType: Lookup; Refers To: ReturnOrder. |
| ReturnOrderLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | product transfer와 연결된 반품 주문 라인 아이템. RelName: ReturnOrderLineItem; RelType: Lookup; Refers To: ReturnOrderLineItem. |
| ShipmentExpectedDeliveryDate | dateTime | Filter, Nillable, Sort | product transfer와 관련된 shipment의 lookup 필드. |
| ShipmentId | reference | Create, Filter, Group, Nillable, Sort, Update | product transfer와 관련된 shipment의 lookup 필드. RelName: Shipment; RelType: Lookup; Refers To: Shipment. |
| ShipmentStatus | picklist | Defaulted on create, Filter, Group, Nillable, Sort | product transfer와 관련된 shipment의 lookup 필드. |
| ShipmentTrackingNumber | string | Filter, Group, Nillable, Sort | product transfer와 관련된 shipment의 lookup 필드. |
| ShipmentTrackingUrl | url | Filter, Group, Nillable, Sort | product transfer와 관련된 shipment의 lookup 필드. |
| SourceLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | product transfer와 관련된 source location의 lookup 필드. RelName: SourceLocation; RelType: Lookup; Refers To: Location. |
| SourceProductItemId | reference | Create, Filter, Group, Nillable, Sort, Update | product transfer와 관련된 product item의 lookup 필드. RelName: SourceProductItem; RelType: Lookup; Refers To: ProductItem. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | product transfer의 상태. |

**Associated Objects:** `ProductTransferChangeEvent` (v48.0) — change events; `ProductTransferFeed` — feed tracking; `ProductTransferHistory` — history; `ProductTransferOwnerSharingRule` — sharing rules; `ProductTransferShare` — sharing.

---

## 11. ReturnOrder

Field Service에서 재고/제품의 **반품 또는 수리**, 또는 Order Management에서 주문 제품의 반품을 나타낸다. v42.0+. 반품 주문은 Lightning Experience, Salesforce Classic, Salesforce 모바일 앱, Android·iOS용 Field Service 모바일 앱, Salesforce Tabs + Visualforce로 만든 커뮤니티에서 사용 가능하다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service 또는 Order Management가 켜져 있어야 한다. Salesforce Order Management 라이선스로 반품 주문이 켜졌으면, Status Category Activated에 대응하는 Status로 생성돼야 한다. Activated에 대응하는 기본 Status는 Submitted·Approved다.

**Fields:** (header "Field Name") — 53행 전수

| Field | Type | Properties | Description |
|---|---|---|---|
| AccountId | reference | Create, Filter, Group, Nillable, Sort, Update | 반품 주문과 연결된 계정. RelName: Account; RelType: Lookup; Refers To: Account. |
| CaseId | reference | Create, Filter, Group, Nillable, Sort, Update | 연결된 케이스. RelName: Case; RelType: Lookup; Refers To: Case. |
| ContactId | reference | Create, Filter, Group, Nillable, Sort, Update | 연결된 연락처. RelName: Contact; RelType: Lookup; Refers To: Contact. |
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | multicurrency 조직에서만. ReturnOrder와 연결된 OrderSummary 통화의 ISO 코드. 값: DKK — Danish Krone; EUR — Euro; GBP — British Pound; USD — U.S. Dollar. 기본 USD. v49.0+. |
| Description | textarea | Create, Nillable, Update | 반품 주문에 대한 메모·맥락. |
| DestinationLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | 항목이 반품되는 위치. 예: 기술자 밴에서 창고로의 반품을 추적하면 창고가 목적지. RelName: DestinationLocation; RelType: Lookup; Refers To: Location. |
| ExpectedArrivalDate | dateTime | Create, Filter, Nillable, Sort, Update | 항목이 목적지 위치에 도착할 것으로 예상되는 날짜. |
| ExpirationDate | dateTime | Create, Filter, Nillable, Sort, Update | authorization은 만료일 이후 capture 불가. v50.0+. |
| GrandTotalAmount | currency | Filter, Nillable, Sort | 조정·세금 포함, 반품 주문의 제품·수수료·배송료 총액. 모든 RO 라인 아이템 포함. TotalAmount + TotalTaxAmount와 동일. 계산 필드. v50.0+. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 반품 주문이 마지막으로 수정된 날짜. UI label Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 반품 주문이 마지막으로 view된 날짜. |
| LifeCycleType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | order summary가 Salesforce Order Management(MANAGED)에 의해 관리되는지 외부 시스템(UNMANAGED)에 의해 관리되는지. unmanaged는 참조용 저장. 일부 OM API는 unmanaged order summary와 연결된 입력 레코드를 거부하고, OM은 일부 레코드의 financial bucket 필드를 갱신하지 않으며, EditUnmanagedOrderSummaries 또는 B2BCommerceIntegrator 권한 사용자는 보통 API로만 접근 가능한 특정 필드를 편집할 수 있다. 값: MANAGED — Managed; UNMANAGED — Unmanaged. v50.0+. |
| OrderId | reference | Create, Filter, Group, Nillable, Sort, Update | 반품 주문과 연결된 주문. RO를 주문과 연결하면 RO의 라인 아이템을 주문 제품과 연결할 수 있다. RelName: Order; RelType: Lookup; Refers To: Order. |
| OrderSummaryId | reference | Create, Filter, Group, Nillable, Sort | 반품 주문과 연결된 order summary의 ID. v50.0+. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | 반품 주문의 소유자. Polymorphic. RelName: Owner; RelType: Lookup; Refers To: Group, User. |
| ProductRequestId | reference | Create, Filter, Group, Nillable, Sort, Update | 연결된 product request. 연결 시 RO 라인 아이템을 product request의 라인 아이템과 연결할 수 있다. 미사용/수리/교체 제품 반품 추적 시 RO가 product request에 관련될 수 있다. 예: 기술자가 모터 3개를 product request로 요청했는데 2개만 필요하면 세 번째를 반품하는 RO를 만들고 여기에 product request를 기재. RelName: ProductRequest; RelType: Lookup; Refers To: ProductRequest. Field Service 또는 Health Cloud 활성 시에만. |
| ProductServiceCampaignId | reference | Create, Filter, Group, Nillable, Sort, Update | 연결된 product service campaign. Field Service 활성 시에만. |
| RefundInstructionsHint | textarea | Nillable | ensure credit·ensure refund 및 관련 change order에 대한 payment credit·refund 시퀀스의 JSON 표현 저장. v65.0+. |
| ReturnOrderNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | (Read only) 반품 주문을 식별하는 자동 생성 번호. |
| ReturnedById | reference | Create, Filter, Group, Nillable, Sort, Update | 항목을 반품하는 사용자의 ID. RelName: ReturnedBy; RelType: Lookup; Refers To: User. |
| ShipFromAddress | address | Filter, Nillable | 반품 배송 주소. 반품/수리 시작 시점의 항목 위치 추적. 예: 고객이 항목을 반품하면 Ship From은 고객 주소. |
| ShipFromCity | string | Create, Filter, Group, Nillable, Sort, Update | 반품 배송 주소의 도시. (동일 추적 노트) |
| ShipFromCountry | string | Create, Filter, Group, Nillable, Sort, Update | 반품 배송 주소의 국가. (동일 추적 노트) |
| ShipFromGeocodeAccuracy | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 반품 배송 주소 geocode의 정확도. Compound Fields Considerations and Limitations 참조. API only. |
| ShipFromLatitude | double | Create, Filter, Nillable, Sort, Update | Longitude와 함께 반품 배송 주소의 정밀 geolocation 지정. –90~90, 소수점 15자리까지. API only. |
| ShipFromLongitude | double | Create, Filter, Nillable, Sort, Update | Latitude와 함께 반품 배송 주소의 정밀 geolocation 지정. –180~180, 소수점 15자리까지. API only. |
| ShipFromPostalCode | string | Create, Filter, Group, Nillable, Sort, Update | 반품 배송 주소의 우편번호. (동일 추적 노트) |
| ShipFromState | string | Create, Filter, Group, Nillable, Sort, Update | 반품 배송 주소의 주(state). (동일 추적 노트) |
| ShipFromStreet | textarea | Create, Filter, Group, Nillable, Sort, Update | 반품 배송 주소의 도로명. (동일 추적 노트) |
| ShipmentType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 반품 주문과 연결된 배송 유형. 값: Standard(기본), Rush, Overnight, Next Business Day, Pick Up. |
| SourceLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | 반품/수리 시작 시점의 항목 위치. 예: 기술자 서비스 차량에서 창고로의 반품을 추적하면 서비스 차량이 source. RelName: SourceLocation; RelType: Lookup; Refers To: Location. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 반품 주문 상태. 값: Draft, Submitted, Approved, Canceled, Closed. Salesforce Order Management 라이선스로 켜졌으면 Status Category Activated에 대응하는 Status로 생성돼야 한다. Activated 기본 Status는 Submitted·Approved. |
| StatusCategory | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | 반품 주문의 status category. 처리는 이 값에 따라 다름. 각 category는 하나 이상의 status에 대응. 값: Activated, Canceled, Closed, Draft, Pending. v50.0+. |
| TaxLocaleType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | RO와 연결된 원래 주문의 세금 처리 시스템. Gross는 보통 VAT 같은 세금에, Net은 보통 sales tax에 적용. 값: Automatic(combined values), Gross(combined values), Net(separate values). v50.0+. |
| TotalAmount | currency | Filter, Nillable, Sort | 세금 제외, 제품·수수료·배송료 포함 RO 라인 아이템의 조정 총액. 계산 필드. v50.0+. |
| TotalDeliveryAdjustAmount | currency | Filter, Nillable, Sort | RO의 배송료에 적용된 price adjustment 총액. type code Charge인 RO 라인 아이템 조정만 포함. 계산 필드. v50.0+. |
| TotalDeliveryAdjustAmtWithTax | currency | Filter, Nillable, Sort | 세금 포함, 배송료 price adjustment 총액. type code Charge만. TotalDeliveryAdjustAmount + TotalDeliveryAdjustTaxAmount와 동일. 계산. v50.0+. |
| TotalDeliveryAdjustTaxAmount | currency | Filter, Nillable, Sort | TotalDeliveryAdjustAmount에 대한 세금. 계산. v50.0+. |
| TotalDeliveryAmount | currency | Filter, Nillable, Sort | RO의 배송료 총액. type code Charge인 RO 라인 아이템만. 계산. v50.0+. |
| TotalDeliveryAmtWithTax | currency | Filter, Nillable, Sort | 세금 포함 배송료 총액. type code Charge만. TotalDeliveryAmount + TotalDeliveryTaxAmount와 동일. 계산. v50.0+. |
| TotalDeliveryTaxAmount | currency | Filter, Nillable, Sort | TotalDeliveryAmount에 대한 세금. 계산. v50.0+. |
| TotalFeeAdjustAmount | currency | Filter, Nillable, Sort | RO의 수수료에 적용된 price adjustment 총액. type Fee인 RO 라인 아이템 조정만. 계산. v56.0+. |
| TotalFeeAdjustAmtWithTax | currency | Filter, Nillable, Sort | 세금 포함 수수료 price adjustment 총액. type Fee만. TotalFeeAdjustAmount + TotalFeeAdjustTaxAmount와 동일. 계산. v56.0+. |
| TotalFeeAdjustTaxAmount | currency | Filter, Nillable, Sort | TotalFeeAdjustAmount에 대한 세금. 계산. v56.0+. |
| TotalFeeAmount | currency | Filter, Nillable, Sort | RO의 수수료 총액. type Fee인 RO 라인 아이템만. 계산. v56.0+. |
| TotalFeeAmtWithTax | currency | Filter, Nillable, Sort | 세금 포함 수수료 총액. type Fee만. TotalFeeAmount + TotalFeeTaxAmount와 동일. 계산. v56.0+. |
| TotalFeeTaxAmount | currency | Filter, Nillable, Sort | TotalFeeAmount에 대한 세금. 계산. v56.0+. |
| TotalProductAdjustAmount | currency | Filter, Nillable, Sort | RO의 제품에 적용된 price adjustment 총액. type code Product인 RO 라인 아이템 조정만. 계산. v50.0+. |
| TotalProductAdjustAmtWithTax | currency | Filter, Nillable, Sort | 세금 포함 제품 price adjustment 총액. type code Product만. TotalProductAdjustAmount + TotalProductAdjustTaxAmount와 동일. 계산. v50.0+. |
| TotalProductAdjustTaxAmount | currency | Filter, Nillable, Sort | Tax on the TotalProductAdjustmentAmount. [sic — 필드명은 TotalProductAdjustTaxAmount이나 설명엔 'Adjustment' 표기] 계산. v50.0+. |
| TotalProductAmount | currency | Filter, Nillable, Sort | RO의 제품 charge 총액. type code Product인 RO 라인 아이템만. 계산. v50.0+. |
| TotalProductAmtWithTax | currency | Filter, Nillable, Sort | 세금 포함 제품 charge 총액. type code Product만. TotalProductAmount + TotalProductTaxAmount와 동일. 계산. v50.0+. |
| TotalProductTaxAmount | currency | Filter, Nillable, Sort | TotalProductAmount에 대한 세금. 계산. v50.0+. |
| TotalTaxAmount | currency | Filter, Nillable, Sort | TotalAmount에 대한 세금. 계산. v50.0+. |

**Usage:** 반품 주문은 고객 반품, 고객 수리, 또는 기술자 밴 stock에서 창고/공급업체로의 재고 반품을 추적하는 데 쓴다. 고객은 커뮤니티에서 반품을 시작할 수 있고, 상담원은 고객 통화나 기술자 요청에 응해 반품 주문을 만들 수 있다. RO는 반품 항목 세부 정보를 추가하는 반품 주문 라인 아이템으로 구성된다. 반품 항목을 표현하려면 각 라인 아이템이 product, product item, asset, product request line item, order product 중 하나 이상을 기재해야 한다. RO는 product request, case, account, contact, order와 연결될 수 있다.

**Example — JSON (원문 그대로):**

```json
{
    "RefundInstructionsHint": {
      "PaymentCreditSequence": [
        {
          "OrderPaymentSummaryId": "0bMxx0000000000001",
          "Amount": 50,
          "CreditType": "GIFT_CARD",
          "Rank": 1
        },
        {
          "OrderPaymentSummaryId": "0bMxx0000000000002",
          "Amount": 50,
          "CreditType": "CHECK",
          "Rank": 2
        }
      ]
    },
    "RefundSequence": [
      {
        "OrderPaymentSummaryId": "0bMxx0000000000001",
        "Amount": 50,
        "Rank": 1
      },
      {
        "OrderPaymentSummaryId": "0bMxx0000000000002",
        "Amount": 50,
        "Rank": 2
      }
    ],
    "ChangeOrders": [
      {
        "ChangeOrderId": "801xx000003Gd01111",
        "FeeChangeOrderId": null,
        "NetAmount": -75
      }
    ]
}
```

**Associated Objects:** `ReturnOrderChangeEvent` (v48.0) — change events; `ReturnOrderFeed` — feed tracking; `ReturnOrderHistory` — history; `ReturnOrderOwnerSharingRule` — sharing rules; `ReturnOrderShare` — sharing.

---

## 12. ReturnOrderLineItem

Field Service에서 반품 주문의 일부로 **반품/수리되는 특정 제품**, 또는 Order Management에서 반품 주문의 일부로 반품되는 특정 order item을 나타낸다. v42.0+. (ReturnOrder와 동일한 사용 가능 플랫폼.)

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** Field Service 또는 Order Management가 켜져 있어야 한다.

> **반품 항목 식별 규칙:** 반품 항목을 표현하려면 다음 5개 중 **하나 이상**을 채워야 한다 — AssetId, OrderItemId, Product2Id, ProductItemId, ProductRequestLineItemId.

**Fields:** (header "Field Name") — 40행 전수

| Field | Type | Properties | Description |
|---|---|---|---|
| AssetId | reference | Create, Filter, Group, Nillable, Sort, Update | RO 라인 아이템과 연결된 asset. AssetId·OrderItemId·Product2Id·ProductItemId·ProductRequestLineItemId 중 하나 이상 필수. RelName: Asset; RelType: Lookup; Refers To: Asset. |
| ChangeOrderItemId | reference | Create, Filter, Group, Nillable, Sort | 연결된 change order item의 ID. v50.0+. RelName: ChangeOrderItem; RelType: Lookup; Refers To: OrderItem. |
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort | multicurrency 조직에서만. ReturnOrderLineItem과 연결된 원래 Order 통화의 ISO 코드. 값: DKK, EUR, GBP, USD. 기본 USD. v49.0+. |
| Description | textarea | Create, Nillable, Update | RO 라인 아이템에 대한 메모·맥락. |
| DestinationLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | 항목이 반품되는 위치. RelName: DestinationLocation; RelType: Lookup; Refers To: Location. |
| GrossUnitPrice | currency | Create, Filter, Nillable, Sort, Update | 연결된 order item summary가 나타내는 제품의 세금 포함 단가. v50.0+. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | RO 라인 아이템이 마지막으로 수정된 날짜. UI label Last Modified Date. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | RO 라인 아이템이 마지막으로 view된 날짜. |
| OrderItemId | reference | Create, Filter, Group, Nillable, Sort, Update | RO 라인 아이템과 연결된 order product. 위 5개 중 하나 이상 필수. RelName: OrderItem; RelType: Lookup; Refers To: OrderItem. |
| OrderItemSummaryId | reference | Create, Filter, Group, Nillable, Sort | 연결된 order item summary의 ID. v50.0+. |
| ProcessingPlan | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 반품 후 항목의 선호 처리. 값: Repair — 수리 후 소유자에게 반환; Discard — 폐기; Salvage — 작동 부품 회수; Restock — 재고로 반환. |
| Product2Id | reference | Create, Filter, Group, Nillable, Sort, Update | RO 라인 아이템과 연결된 제품. 위 5개 중 하나 이상 필수. RelName: Product2; RelType: Lookup; Refers To: Product2. |
| ProductItemId | reference | Create, Filter, Group, Nillable, Sort, Update | 반품 시작 시점의 제품 위치를 나타내는 product item. 위 5개 중 하나 이상 필수. RelName: ProductItem; RelType: Lookup; Refers To: ProductItem. |
| ProductRequestLineItemId | reference | Create, Filter, Group, Nillable, Sort, Update | RO 라인 아이템과 연결된 product request line item. 위 5개 중 하나 이상 필수. RelName: ProductRequestLineItem; RelType: Lookup; Refers To: ProductRequestLineItem. |
| ProductServiceCampaignId | reference | Filter, Group, Nillable, Sort | RO 라인 아이템과 연결된 product service campaign. |
| ProductServiceCampaignItemId | reference | Create, Filter, Group, Nillable, Sort, Update | RO 라인 아이템과 연결된 product service campaign item. |
| QuantityExpected | double | Create, Filter, Nillable, Sort, Update | 반품 예상 항목 수량. v50.0+. |
| QuantityReceived | double | Create, Filter, Nillable, Sort, Update | 반품으로 수령한 실제 항목 수량. v50.0+. |
| QuantityRejected | double | Create, Filter, Nillable, Sort, Update | 반품 거절된 항목 수량. v50.0+. |
| QuantityReturned | double | Create, Filter, Sort, Update | 반품되는 항목 수량. 여러 제품 유형을 반품하면 각각을 다른 RO 라인 아이템으로 추적. |
| QuantityUnitOfMeasure | picklist | Create, Filter, Group, Nillable, Sort, Update | 반품 항목의 단위; 예: 킬로그램·리터. picklist 값은 products의 Quantity Unit of Measure 필드에서 상속. |
| ReasonForRejection | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 이 RO 라인 아이템의 반품 항목 거절 사유. 값: Damaged Item, Expired Warranty, Missing Item or Part, Wrong Item. 기본 Missing Item or Part. v50.0+. |
| ReasonForReturn | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 항목 반품 사유. 값: Damaged, Defective, Duplicate Order, Wrong Item, Wrong Quantity, Not Satisfied, Outdated, Other. 기본 Damaged. |
| ReasonForChangeText | string | Filter, Group, Sort | 반품 변경 사유에 대한 세부 정보. |
| RepaymentMethod | picklist | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 반품 항목에 대해 고객/소유자에게 보상하는 방법. 값: Replace — 항목 교체; Refund — 항목 반품·소유자 환불; Credit — 항목 반품·소유자 credit 수령; Return — 항목을 소유자에게 반환(예: 수리 후). |
| ReturnOrderId | reference | Create, Filter, Group, Sort | RO 라인 아이템이 속한 반품 주문. RelName: ReturnOrder; RelType: Lookup; Refers To: ReturnOrder. |
| ReturnOrderLineItemNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | (Read only) RO 라인 아이템을 식별하는 자동 생성 번호. |
| SourceLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | 반품/수리 시작 시점의 항목 위치. RelName: SourceLocation; RelType: Lookup; Refers To: Location. |
| TotalAdjustmentAmount | currency | Filter, Nillable, Sort | RO 라인 아이템에 적용된 모든 price adjustment 총액. 계산. v50.0+. |
| TotalAdjustmentAmountWithTax | currency | Filter, Nillable, Sort | 세금 포함 RO 라인 아이템 price adjustment 총액. TotalAdjustmentAmount + TotalAdjustmentTaxAmount와 동일. 계산. v50.0+. |
| TotalAdjustmentTaxAmount | currency | Filter, Nillable, Sort | TotalAdjustmentAmount에 대한 세금. 계산. v50.0+. |
| TotalAmount | currency | Filter, Nillable, Sort | 조정·세금 포함 RO 라인 아이템 총액. 계산. v50.0+. |
| TotalLineAmount | currency | Create, Defaulted on create, Filter, Nillable, Sort, Update | 조정·세금 제외 RO 라인 아이템 총액. v50.0+. |
| TotalLineAmountWithTax | currency | Filter, Nillable, Sort | 세금 포함 총 가격. TotalLineAmount + TotalLineTaxAmount와 동일. 계산. v50.0+. |
| TotalLineTaxAmount | currency | Filter, Nillable, Sort | TotalLineAmount에 대한 세금. 계산. v50.0+. |
| TotalPrice | currency | Filter, Nillable, Sort | 조정 포함·세금 제외 RO 라인 아이템 총액. UnitPrice × Quantity와 동일. 계산. |
| TotalTaxAmount | currency | Filter, Nillable, Sort | TotalAmount에 대한 세금. 계산. v50.0+. |
| Type | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | RO 라인 아이템 유형. 연결된 order item summary 유형과 일치. Delivery Charge=배송료; Fee=다른 종류 수수료(예: 반품 수수료); Order Product=그 외 모든 제품/서비스/charge. 각 유형은 하나의 type code(괄호 안)에 대응. 값: Delivery Charge (Charge); Fee (Charge) [v56.0+]; Order Product (Product). v50.0+. |
| TypeCode | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | RO 라인 아이템의 type code. 연결된 order item summary type code와 일치. 처리는 이 값에 따라 다름. Charge=배송료; Product=an other type of product/service/charge [sic]. 각 type category는 하나 이상의 type에 대응. 값: Charge, Product. v50.0+. |
| UnitPrice | currency | Create, Defaulted on create, Filter, Nillable, Sort, Update | RO 라인 아이템의 단가. v50.0+. |

**Associated Objects:** `ReturnOrderLineItemChangeEvent` (v48.0) — change events; `ReturnOrderLineItemFeed` — feed tracking; `ReturnOrderLineItemHistory` — 추적 필드 히스토리.

---

## 13. SerializedProduct

재고 내 **개별 제품마다의 일련번호(serial number)를 기록**한다. v50.0+.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** 이 객체를 쓰려면 Manage Industries Visit 권한과 Industries Visit 권한 세트 라이선스가 필요하다. 이 규칙은 **Field Service에서 직렬화 제품을 사용하는 경우엔 적용되지 않는다.**

**Fields:** (header "Field")

| Field | Type | Properties | Description |
|---|---|---|---|
| AssetId | reference | Create, Filter, Group, Nillable, Sort, Update | asset 레코드 참조. |
| ExpirationDate | date | Create, Filter, Group, Nillable, Sort, Update | 제품이 만료되는 날짜. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 이 레코드가 마지막으로 referenced된 날짜·시각. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 이 레코드가 마지막으로 view된 날짜·시각. |
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | serialized product 레코드의 이름. 자동 생성됨. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | 레코드 소유자 참조. |
| Product2Id | reference | Create, Filter, Group, Sort, Update | 직렬화되는 제품. |
| ProductItemId | reference | Create, Filter, Group, Nillable, Sort, Update | 이 직렬화 제품이 속한 재고(product item 레코드) 참조. |
| SerialNumber | string | Create, Filter, Group, Sort, Update | 제품의 일련번호. |
| Status | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 제품 상태. 값: Available, Consumed, Damaged, Lost, Sent. 기본 Available. |

> **Associated Objects:** PDF에 SerializedProduct에 대한 Associated Objects 섹션이 **없다**(원문 그대로 — Status 필드 후 바로 다음 객체로 이어짐).

---

## 14. SerializedProductTransaction

직렬화 제품에 수행된 **거래(transaction)**를 나타낸다. v57.0+.

> **읽기 전용 계열:** 이 객체의 Supported Calls에는 `create()`·`delete()`·`update()`·`upsert()`·`undelete()`가 **없다**. 조회/describe 계열만 지원한다.

**Supported Calls:** `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`
**Special Access Rules:** (PDF에 별도 섹션 없음)

**Fields:** (header "Field")

| Field | Type | Properties | Description |
|---|---|---|---|
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 이 레코드가 마지막으로 referenced된 날짜·시각. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 이 레코드가 마지막으로 view된 날짜·시각. |
| Name | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | serialized product 레코드의 이름. 자동 생성됨. |
| RelatedRecordId | reference | Filter, Group, Sort | 이전되는 직렬화 제품. Polymorphic. RelName: SerializedProduct; RelType: Lookup; Refers To: ProductConsumed, ProductTransfer. |
| SerializedProductId | reference | Filter, Group, Sort | 이전되는 직렬화 제품. RelName: SerializedProduct; RelType: Lookup; Refers To: SerializedProduct. |
| TransactionType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 거래가 추적하는 동작. 값: Adjusted, Consumed, Damaged, Found, Lost, Received, Repaired, Replenished, Sent, Withdrawn. |

**Associated Objects:** `SerializedProductTransactionChangeEvent` (v64.0) — change events; `SerializedProductTransactionFeed` — feed tracking; `SerializedProductTransactionHistory` — 추적 필드 히스토리.

---

## 15. Shipment

field service에서 **재고의 운송**, 또는 Order Management에서 order item의 배송(shipment)을 나타낸다.

**Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`
**Special Access Rules:** 다음 기능 중 하나 이상이 켜져 있어야 한다 — Order Management; Field Service; B2B Commerce; Consumer Goods Cloud Retail Execution.

**Fields:** (header "Field Name") — 38행 전수

| Field | Type | Properties | Description |
|---|---|---|---|
| ActualDeliveryDate | dateTime | Create, Filter, Nillable, Sort, Update | 제품이 배송된 날짜. |
| DeliveredToId | reference | Create, Filter, Group, Nillable, Sort, Update | 제품이 배송된 사람/엔티티. Polymorphic. RelName: DeliveredTo; RelType: Lookup; Refers To: Group, User. |
| DeliveryMethodId | reference | Create, Filter, Group, Nillable, Sort, Update | shipment에 사용된 delivery method. v51.0+. |
| Description | textarea | Create, Nillable, Update | 제공 필드에 없는 세부 정보. |
| DestinationLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | 제품이 배송될 곳. RelName: DestinationLocation; RelType: Lookup; Refers To: Location. |
| ExpectedDeliveryDate | dateTime | Create, Filter, Nillable, Sort, Update | 제품이 배송될 것으로 예상되는 날짜. |
| FulfillmentOrderId | reference | Create, Filter, Group, Nillable, Sort, Update | shipment이 속한 fulfillment order. v51.0+. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 직·간접으로 마지막 상호작용한 시각. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 마지막으로 view한 시각. null이면 referenced만 됐을 수 있다. |
| OrderSummaryId | reference | Create, Filter, Group, Nillable, Sort, Update | shipment과 연결된 order summary. v51.0+. |
| OwnerId | reference | Create, Defaulted on create, Filter, Group, Sort, Update | shipment의 소유자. Polymorphic. RelName: Owner; RelType: Lookup; Refers To: Group, User. |
| Provider | picklist | Create, Filter, Group, Nillable, Sort, Update | 이전을 수행하는 회사/사람. |
| ReturnOrderId | reference | Create, Filter, Group, Nillable, Sort, Update | 반품 Shipment의 경우 연결된 ReturnOrder. v53.0+. |
| ShipFromAddress | address | Filter, Nillable | 제품이 출발하는 곳. ship to 주소의 compound form. 읽기 전용. Address Compound Fields 참조. |
| ShipFromCity | string | Create, Filter, Group, Nillable, Sort, Update | shipment 출발 주소의 도시. |
| ShipFromCountry | string | Create, Filter, Group, Nillable, Sort, Update | shipment 출발 주소의 국가. |
| ShipFromGeocodeAccuracy | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | shipment 출발 주소 geocode의 정확도. Compound Field Considerations and Limitations 참조. Note: API only. |
| ShipFromLatitude | double | Create, Filter, Nillable, Sort, Update | Longitude와 함께 shipment 출발 주소의 정밀 geolocation 지정. –90~90, 소수점 15자리까지. Note: API only. |
| ShipFromLongitude | double | Create, Filter, Nillable, Sort, Update | Latitude와 함께 shipment 출발 주소의 정밀 geolocation 지정. –180~180, 소수점 15자리까지. Note: API only. |
| ShipFromPostalCode | string | Create, Filter, Group, Nillable, Sort, Update | shipment 출발 주소의 우편번호. |
| ShipFromState | string | Create, Filter, Group, Nillable, Sort, Update | shipment 출발 주소의 주(state). |
| ShipFromStreet | textarea | Create, Filter, Group, Nillable, Sort, Update | shipment 출발 주소의 도로명. |
| ShipToAddress | address | Filter, Nillable | shipment이 배송되는 물리적 주소. ship to 주소의 compound form. 읽기 전용. Address Compound Fields 참조. |
| ShipToCity | string | Create, Filter, Group, Nillable, Sort, Update | shipment 배송 주소의 도시. |
| ShipToCountry | string | Create, Filter, Group, Nillable, Sort, Update | shipment 배송 주소의 국가. |
| ShipToGeocodeAccuracy | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | shipment 배송 주소 geocode의 정확도. Compound Field Considerations and Limitations 참조. Note: API only. |
| ShipToLatitude | double | Create, Filter, Nillable, Sort, Update | Longitude와 함께 shipment 배송 주소의 정밀 geolocation 지정. –90~90, 소수점 15자리까지. Note: API only. |
| ShipToLongitude | double | Create, Filter, Nillable, Sort, Update | Latitude와 함께 shipment 배송 주소의 정밀 geolocation 지정. –180~180, 소수점 15자리까지. Note: API only. |
| ShipToName | string | Create, Filter, Group, Sort, Update | shipment 수령인. |
| ShipToPostalCode | string | Create, Filter, Group, Nillable, Sort, Update | shipment 배송 주소의 우편번호. |
| ShipToState | string | Create, Filter, Group, Nillable, Sort, Update | shipment 배송 주소의 주(state). |
| ShipToStreet | textarea | Create, Filter, Group, Nillable, Sort, Update | shipment 배송 주소의 도로명. |
| ShipmentNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | shipment을 식별하는 자동 생성 번호. |
| SourceLocationId | reference | Create, Filter, Group, Nillable, Sort, Update | shipment이 출발하는 field service 위치. RelName: SourceLocation; RelType: Lookup; Refers To: Location. |
| Status | picklist | Create, Filter, Group, Nillable, Sort, Update | shipment 상태. 커스터마이즈 가능 picklist: Created — 생성됨; Delivered — 배송됨; In Transit — 운송 중; Shipped — 출하됨; Voided — 취소됨. |
| TotalItemsQuantity | double | Filter, Nillable, Sort | shipment에 포함된 항목 총 수량. shipment item 수량 합으로 계산. v51.0+. |
| TrackingNumber | string | Create, Filter, Group, Nillable, Sort, Update | shipment의 추적 번호. |
| TrackingUrl | url | Create, Filter, Group, Nillable, Sort, Update | shipment 추적에 사용하는 웹사이트 URL. |

**Associated Objects:** `ShipmentChangeEvent` (v48.0) — change events; `ShipmentFeed` — feed tracking; `ShipmentHistory` — history; `ShipmentOwnerSharingRule` — sharing rules; `ShipmentShare` — sharing.

---

## 관련 노트

- [[Field Service 개요와 데이터 모델]] — Inventory Management·Core Data Model ER 다이어그램과 이 클러스터의 데이터 모델상 위치
- [[Field Service Objects]] — FSL 표준 객체(ServiceAppointment·WorkOrder·ServiceResource 등) 색인
- [[객체 레퍼런스 — Service Appointment·Resource]] — 약속·리소스·위치 도메인 객체. ProductItem의 LocationId·ProductConsumed의 WorkOrderId 등이 이 도메인과 교차
- [[객체 레퍼런스 — Asset·Attribute·Warranty]] — Asset(ReturnOrderLineItem.AssetId·SerializedProduct.AssetId가 참조)·Warranty 도메인
- [[FSL Apex Namespace]] — Field Service Apex 네임스페이스
- [[Field Service REST API]] — Field Service REST 리소스
