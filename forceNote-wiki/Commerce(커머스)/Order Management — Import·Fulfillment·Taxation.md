---
tags: [commerce, order-management, import, fulfillment, taxation, order-summary, bulk-api, location-capacity]
source: order_management_developer_guide_html.pdf (Version 66.0, Spring '26, Tier 2) — Importing Order Data(p.39-46)·Fulfillment Orders(p.47-49)·Taxation in Order Management(p.50-52); Enable High-Scale Integration for Order Management (help.salesforce.com/s/articleView?id=commerce.om_hi_scale.htm, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.order_management_developer_guide.meta/order_management_developer_guide/
created: 2026-06-20
aliases: [Importing Order Data, Order Management Import, Fulfillment Orders, OM Taxation, Location Capacity, High-Scale Orders, Deduplication, 주문 가져오기, 이행 주문, 세금 계산]
---

# Order Management — Import·Fulfillment·Taxation

> OM으로 주문 데이터를 가져오는 **레코드 생성 순서·필수 필드·OrderSummary 생성 방법**, Fulfillment Order 필수 필드와 Location 용량 관리, net/gross **세금 계산** 규칙. (`order_management_developer_guide_html.pdf` p.39-52)

> 📍 허브: [[Order Management 개요와 데이터 모델]]

---

## Importing Order Data

Salesforce Order Management은 storefront에서 가져온(imported) 주문 데이터를 처리한다. 레거시 시스템의 **과거 주문 데이터를 새 OM org로 bulk load**하거나, storefront의 **신규 주문을 위한 커스텀 import 프로세스**를 구현할 수 있다. (p.39)

### 개요·Managed vs Unmanaged (OrderLifecycleType)

OM에서 각 주문은 하나의 `OrderSummary` 레코드와 `OrderItemSummary`·`OrderDeliveryGroupSummary` 같은 supporting 레코드 집합으로 표현된다. 주문 데이터를 import할 때는 먼저 `Order` 레코드와 supporting 레코드(`OrderItem`·`OrderDeliveryGroup` 포함)를 만든 뒤, **Create Order Summary flow core action 또는 API로 주문을 처리**해 `OrderSummary`와 그 supporting 레코드를 생성한다. (p.40)

> [!note] Don't directly create OrderSummary records.
> OrderSummary 레코드를 **직접 생성하지 않는다.** 항상 flow core action을 실행하거나 API를 호출한다.

**import 방식 선택:**

- **대량 import** → Bulk API 2.0 사용 (Bulk API 2.0 Developer Guide 참조). → [[Bulk API 2.0]]
- **소량 import** → composite REST API 요청 가능. composite API 호출 1건은 **최대 200 레코드**를 포함한다. 이 200 한도는 주문만이 아니라 **모든 객체에 적용**된다. 예: 5 items + 각 item에 적용되는 order-level adjustment 1개 = 최소 11 레코드(1 order, 5 order items, 5 order item adjustments). (REST API Developer Guide의 Composite Resources 참조) → [[REST API]]
- API 호출은 **API limits에 count**된다. 과거 주문 import용 임시 증량은 Salesforce Customer Support 케이스로 요청할 수 있으며, Support 처리에 **최소 2주**가 소요된다. → 한도 상세는 [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]]

> 📌 200 레코드는 composite REST API 호출당 한도다 — Composite 한도 전반은 [[REST API]]·[[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] 참조.

**Managed Orders and Unmanaged Orders**

`OrderSummary` 필드 **`OrderLifecycleType`** 은 해당 주문이 Order Management 기능으로 관리되는지를 지정한다. 기본값은 `Managed`다. Create Order Summary action 또는 API request를 설정해 레코드 생성 시 `OrderLifecycleType`을 `Managed` 또는 `Unmanaged`로 지정할 수 있으나, **생성 후에는 변경할 수 없다.** (p.40)

- `Unmanaged` lifecycle type 예: 과거 주문(historical orders), 외부 시스템이 관리하는 주문.
- managed/unmanaged lifecycle의 차이는 "Order Lifecycle Management" 참조.

### 레코드 생성 순서 (14단계)

> storefront 데이터를 import할 때 **레코드를 만드는 순서가 중요**하다 — 객체 간 관계 때문이다. 예: `OrderItem` 레코드는 `Product2`·`PricebookEntry`·`Order`를 필요로 하므로, 이 세 관련 레코드가 존재하기 전에는 `OrderItem`을 만들 수 없다. (p.40)

각 import 주문에 대해 아래 순서로 레코드를 생성한다:

1. **Shopper data**
   - `Account`
   - `Contact` (account record type이 Person Account면 불필요)
2. `SalesChannel`
3. `Product2`
4. `PriceBookEntry` (Optional Price Books 사용 시 제외)
5. **Payment data** (payment 유형에 따라):
   - `AlternativePaymentMethod`
   - `CardPaymentMethod`
   - `DigitalWallet`
   - `GtwyProvPaymentMethodType`
   - `PaymentGatewayProvider`
   - `PaymentGateway`
6. `OrderDeliveryMethod` (optional)
7. `Order`
   > Order 이전에 생성된 레코드들은 한 order에 국한되지 않는다. 생성 시 **중복 확인**이 필요하다. 중복 자동 식별/처리 설정은 "Manage Duplicate Records" 참조.
8. `OrderItem` (**최소 1개**)
9. `OrderItemAdjustmentLineItem` (optional)
10. `OrderItemTaxLineItem` (optional)
11. `OrderDeliveryGroup` (**최소 1개**)
12. `PaymentGroup` (optional)
13. `PaymentAuthorization` (optional)
14. `Payment` (optional)

### Required Fields (객체별)

정상적으로 required인 필드 외에, OM은 일부 객체에 대해 **추가 필드 값**을 요구한다. 표의 객체 레코드를 만들 때는 나열된 모든 필드에 값을 정의한다. (p.41-43)

| Object | Required Fields |
|---|---|
| **Account** | `AccountNumber` · `BillingCity` · `BillingCountry` · `BillingCountryCode` · `BillingState` · `BillingStreet` · `FirstName`(Person Account인 경우) · `IsPersonAccount` · `LastName`(Person Account인 경우) · `Name`(Person Account가 아닌 경우) |
| **SalesChannel** | `SalesChannelName` |
| **Product2** | `Description` · `IsActive` · `Name` · `ProductCode` · `StockKeepingUnit` |
| **CardPaymentMethod** | `AccountId` · `CardCategory` · `CardHolderName` · `CardType` · `ExpiryMonth` · `ExpiryYear` · `InputCardNumber` · `ProcessingMode` · `Status` |
| **Order** | `AccountId` · `BillingCity` · `BillingCountry` · `BillingCountryCode` · `BillingEmailAddress` · `BillingState` · `BillingStreet` · `EffectiveDate` · `Name` · `OrderedDate` · `OrderReferenceNumber` · `SalesChannelId` · `Status`(신규 레코드엔 `Draft`로 설정하고, OrderSummary 생성 전 `Active`로 변경) |
| **OrderItem** | `Description` · `GrossUnitPrice` · `OrderDeliveryGroupId` · `OrderId` · `PricebookEntryId` · `Product2id` · `Quantity` · `TotalLineAmount` · `Type` · `UnitPrice` |
| **OrderItemAdjustmentLineItem** | `Amount` · `Description` · `Name` · `OrderItemId` |
| **OrderItemTaxLineItem** | `Amount` · `Description` · `Name` · `OrderItemAdjustmentLineItemId`(해당 시) · `OrderItemId` · `Rate` · `TaxEffectiveDate` · `Type` |
| **OrderDeliveryGroup** | `DeliverToCity` · `DeliverToCountry` · `DeliverToName` · `DeliverToPostalCode` · `DeliverToState` · `DeliverToStreet` · `EmailAddress` · `OrderDeliveryMethodId` · `OrderId` |
| **PaymentGroup** | `SourceObjectId` |
| **PaymentAuthorization** | `AccountId` · `Amount` · `PaymentGatewayId` · `PaymentGroupId` · `PaymentMethodId` · `ProcessingMode` · `Status` |
| **Payment** | `AccountId` · `Amount` · `Date` · `Email` · `PaymentGatewayId` · `PaymentGroupId` · `PaymentMethodId` · `Phone` · `ProcessingMode` · `Status` · `Type` |

> 표 = 12행(객체) × 2열(Object · Required Fields). Payment 행의 `ProcessingMode`/`Status`/`Type`은 PDF에서 페이지 경계(p.43)로 넘어가 분리 표시되었으나 동일 Payment 행에 속한다.

### OrderSummary 생성 방법 비교 (5×3)

imported order에 대한 order summary는 여러 방법으로 생성할 수 있다. 각 방법의 상세는 해당 developer guide를, 다양한 flow 유형은 Salesforce Flow Developer Center를 참조한다. (p.44)

> 비교표 = 5행(Method) × 3열(Method · Pros · Cons).

| Method | Pros | Cons |
|---|---|---|
| **Flow triggered by a platform event** | • 구현이 단순 • 주문 생성과 분리된 **비동기 트랜잭션**으로 성능 향상 | • 병렬 실행 없음 — 주문이 한 번에 하나씩 처리 • 타이밍 제어 불가 • 비동기 실행은 복잡한 에러 처리 필요 |
| **Flow triggered by a record change** (Order Status: Draft→Activated) | • 구현이 단순 • order summary를 주문과 병렬로 생성하는 멀티스레드 접근 허용 • Composite API 호출 1건으로 order와 order summary를 **같은 트랜잭션**에서 생성 가능 → 더 단순한 에러 처리. 예: 1) Order 레코드 생성하고 Status를 `Draft`로 설정 → 2) order items·order delivery groups 등 supporting 레코드 생성 → 3) order의 Status를 `Activated`로 변경 → 해당 order에 Create Order Summary flow 실행 트리거 | • order와 order summary를 같은 트랜잭션에서 만들 때 order summary가 실패하면 **order도 실패** • 큰 트랜잭션 • **성능이 가장 낮은** 방법 |
| **Apex triggered by a platform event** | • 주문 생성과 분리된 비동기 트랜잭션으로 성능 향상 • 멀티스레드 접근 허용 • **성능이 가장 좋은** 방법 | • 타이밍 제어 불가 • 비동기 실행은 복잡한 에러 처리 필요 |
| **Scheduled Apex job** | • 제어된 batch 실행 허용 | • 처리 레코드 수가 **Apex limits**에 종속 • 처리할 주문을 프로그래밍 방식으로 식별해야 함 • 처리할 주문이 없어도 실행됨 |
| **Direct calls to API resources** | • 외부 제어 허용 • 일부 클라이언트는 병렬 처리 허용 | • **API call limits**에 종속 • 외부 앱 설계·인증 등이 필요 |

> platform event 트리거 방식의 한도·고려사항은 [[Platform Event 한도와 고려사항]] 참조.

### Importing Custom Order Data

custom order data를 import하려면 `Order`·`OrderItem`·`OrderDeliveryGroup`에 custom field를 추가하고, **대응하는 summary 객체에 동일한 custom field**를 추가한다. base 레코드에 custom 값을 설정하면 Create Order Summary action 또는 API가 그 값을 대응하는 summary 레코드의 일치 필드로 복사한다. (p.45)

> 예: storefront 데이터에 `Shopper Category`라는 주문 값이 있다면 `ShopperCategory__c` custom field를 `Order`와 `OrderSummary` 양쪽에 추가한다. import 시 `Order` 레코드에 `ShopperCategory__c` 값을 설정하면, 해당 주문에 Create Order Summary action 실행/API 호출 시 그 값이 `OrderSummary`의 `ShopperCategory__c` 필드로 복사된다.

**Order summary creation이 지원하는 custom field 데이터 타입 (전수 12종):**

- Boolean
- Currency
- **Datetime** (Date는 미지원)
- Double
- Email
- Multipicklist
- Phone
- Picklist
- Reference
- String
- TextArea
- URL

### B2C Commerce 사용 시 import

B2C Commerce integration이 사용하는 데이터(product·shopper data 등)를 import할 때는 **B2C Commerce 데이터와 동기화**를 유지해야 한다. 그렇지 않으면 integration이 그 데이터를 인식하지 못한다. (p.45-46)

> 예: integration이 `OrderItem` 레코드를 만들 때, 주문 데이터의 product ID와 `ProductCode` 또는 `StockKeepingUnit`이 일치하는 `Product2` 레코드를 검색한다. catalog product data를 import했는데 `ProductCode`·`StockKeepingUnit` 값이 B2C Commerce의 product ID 값과 일치하지 않으면 integration이 그 product를 인식하지 못한다 → 주문에 **잘못된 product 추가**나 **중복 `Product2` 레코드 생성**이 발생할 수 있다.

**integration이 레코드 lookup에 사용하는 필드 매핑** (6행 × 2열):

| Order Management Object Field | B2C Commerce Data |
|---|---|
| `OrderDeliveryMethod.ReferenceID` | Shipping Method ID |
| `Product2.ProductCode` 또는 `Product2.StockKeepingUnit` | Product ID |
| `PaymentGateway.ReferenceID` | Payment Processor ID |
| `SalesChannel.SalesChannelName` | Site ID or Domain ID |
| (person account면) `Account.PersonEmail` / (그 외 account면) `Contact.Email` field | Customer Email Address |
| `Account.Name` | • 개인 shopper(person account 미사용): Customer Billing Address First Name + Last Name 결합 • 비즈니스 shopper: Customer Billing Address Company Name |

> 위 표는 integration이 **기존 레코드를 조회(lookup)** 하는 데 쓰는 필드 매핑이다. B2C Commerce 주문 데이터의 전체 필드 매핑(XSD 기반)은 [[B2C Commerce Storefront Order Data Map]] 참조.

**The OrderSummary ExternalReferenceIdentifier Field**

API version 55.0부터, B2C Commerce integration은 중복 주문을 방지하기 위해 `OrderSummary.ExternalReferenceIdentifier` 필드를 사용한다. B2C Commerce에서 주문이 ingest될 때 이 필드는 다음으로 설정된다:

```
B2C realm ID + "_" + B2C instance ID + "@" + B2C Commerce catalog/domain ID + "@" + B2C Commerce order number
```

Salesforce에서 다른 주문을 생성하면 **고유한 `ExternalReferenceIdentifier` 값**을 부여한다.

> [!note]
> High Scale Orders를 사용하면 `PendingOrderSummary.ExternalReferenceIdentifier` 필드도 설정된다.

> [!note]
> API version 55.0에서, 표준 B2C Commerce integration은 이 값을 `"SFDC" + "@" + nanotime + "@" + UUID`로 설정했고, High Scale Orders는 이후 버전에서 사용하는 값으로 설정했다.

### High-Scale Orders and Deduplication

> [!warning] ⚠️ 전제조건 — High-Scale Orders는 기본 활성 기능이 아니다
> `PendingOrderSummary`·**Pending Order Summaries REST API**·HSOI를 사용하려면 먼저 **High-Scale Orders 기능을 활성화**해야 한다. 이 기능은 org에 기본으로 켜져 있지 않다.
> - 활성화 절차: Setup의 **Enable High-Scale Integration for Order Management** (`help.salesforce.com` — Commerce/Order Management).
> - 개발자 가이드는 *"The High-Scale Orders feature must be active"* 라고 명시한다. 활성화 없이 `PendingOrderSummary`·Pending Order Summaries API 경로를 따라가면 막힌다.
> - **B2C Commerce 연결은 불필요** — High-Scale Orders 활성화만으로 이 API를 쓸 수 있다.

High-Scale Orders는 **Pending Order Summaries REST API**를 사용해 order summary graph로부터 summary를 생성한다. **request parameter에 포함된 엔티티는 deduplication rules의 적용을 받지 않는다.** (p.46)

request에 `PurchaseSupportDetails` 섹션의 엔티티 상세가 있으면, Pending Order Summaries REST API가 **deduplication logic**을 사용해 기존 레코드를 업데이트할지 새 레코드를 만들지 결정한다. 데이터베이스에 없는 request 내 중복 엔티티는 dedup되지 않는다.

> 부정확하거나 오래된 데이터로 주문을 보내면 나중에 고치기 어려운 문제가 생길 수 있다. OM에 주문을 보내기 **전에** `Account`·`Contact`·`Product2`·`PricebookEntry`·`Promotion`·`WebStore`·`SalesChannel`·`OrderDeliveryMethod`에 대한 새 정보를 업로드한다.

**Pending Order Summaries REST API 엔티티 ↔ deduplication logic** (8행 × 2열):

| Entity | Deduplication Logic |
|---|---|
| **Account, Person Account, Contact** | Account/Person Account/Contact Duplicate Rules 및 Matching Rules를 만들면 API가 이 규칙을 호출해 중복을 찾는다. Contact는 중복 규칙 사용에 `AccountId`가 필요하다. Person Account의 경우 Person Accounts가 활성화돼 있어야 한다. |
| **Pricebook2** | Standard Price Book lookup만 지원. Pricebook2 노드가 요청에 포함되면 Standard Price Book ID가 조회되어 사용된다. |
| **Product2** | `ProductCode` 기준 dedup. 동일 `ProductCode`의 기존 `Product2`가 있으면 그것을 사용. |
| **PricebookEntry** | single currency org: `Pricebook2Id` + `Product2Id` 기준. multicurrency org: `Pricebook2Id` + `Product2Id` + `CurrencyIsoCode` 기준. `CurrencyIsoCode` 미지정 시 default `CurrencyIsoCode` 사용. |
| **SalesChannel** | `SalesChannelName` 필드 기준. |
| **Promotion** | `Name` 필드 기준. |
| **WebStore** | `ExternalReference` 필드 기준. |
| **OrderDeliveryMethod** | `ReferenceNumber` 필드 기준. |

---

## Fulfillment Orders

`FulfillmentOrder` 레코드는 `FulfillmentOrderLineItem`·`FulfillmentOrderItemAdjustment`·`FulfillmentOrderItemTax` 등의 supporting 레코드 집합을 가진다. OM API나 flow core action을 호출해 fulfillment order를 만들면 supporting 레코드도 함께 생성된다. (p.47)

### 생성 방식·Required Fields

- **managed OrderSummary** → Apex, Connect API, 또는 flow core action으로 fulfillment order 생성. 이 방법은 fulfillment order line item 등 supporting 레코드도 생성한 뒤 새 fulfillment order의 `Status`를 **`Allocated`** 로 설정한다.
- **외부 생성** → sObject·Composite·Bulk API 2.0 같은 platform API로도 fulfillment order 생성 가능. **unmanaged OrderSummary**에 대한 fulfillment order는 **platform API만 사용**할 수 있다.
- platform API로 fulfillment order를 만들 때는 supporting 레코드도 직접 만든다. 이 경우 fulfillment order 생성 시 `Status`를 `Draft`로 설정하고, 모든 supporting 레코드를 만든 뒤 `Status`를 `Allocated`(또는 Activated Status Category에 연결된 custom status)로 변경한다.

정상 required 필드 외에, OM은 각 `FulfillmentOrder`와 supporting 레코드에 대해 특정 필드 값을 요구한다. (p.47-49)

**Fulfillment 객체별 Required Fields** (4행 × 2열):

| Object | Required Fields |
|---|---|
| **FulfillmentOrder** | `AccountId` · `DeliveryMethodId` · `FulfilledFromLocationId` · `FulfilledToCity` · `FulfilledToCountry` · `FulfilledToEmailAddress` · `FulfilledToLatitude` · `FulfilledToLongitude` · `FulfilledToName` · `FulfilledToPhone` · `FulfilledToPostalCode` · `FulfilledToState` · `FulfilledToStreet` · `OrderId` · `OrderSummaryId` · `Status` · `Type` |
| **FulfillmentOrderLineItem** | `Description` · `FulfillmentOrderId` · `GrossUnitPrice` · `OrderItemId` · `OrderItemSummaryId` · `OriginalQuantity` · `Product2Id` · `Quantity` · `TotalLineAmount` · `Type` · `TypeCode` · `UnitPrice` |
| **FulfillmentOrderItemAdjustment** | `Amount` · `Description` · `FulfillmentOrderId` · `FulfillmentOrderLineItemId` · `OrderItemAdjustLineSummaryId` |
| **FulfillmentOrderItemTax** | `Amount` · `Description` · `FulfillmentOrderId` · `FulfillmentOrderItemAdjustId`(해당 시) · `FulfillmentOrderLineItemId` · `OrderItemTaxLineItemSummaryId` · `Rate` · `TaxEffectiveDate` · `Type` |

> `FulfillmentOrderItemTax` 행은 PDF에서 p.48/p.49 페이지 경계로 분리 표시되었으나(Amount·Description은 p.48, 나머지는 p.49) 동일 행으로 병합 재구성했다.

### Location Capacity (3필드 + 4동작)

location의 **fulfillment order capacity**를 정의해 해당 location에 할당되는 fulfillment order 수를 제한할 수 있다. `Location` 객체는 fulfillment order capacity를 위한 **3개 필드**를 가진다. (p.49)

| 필드 | 의미 |
|---|---|
| **Track Fulfillment Order Capacity** | location의 capacity 추적 여부. default는 `false`. |
| **Fulfillment Order Capacity** | 사용자 정의 기간당 location에 할당 가능한 fulfillment order **최대 수**. `null`이면 capacity 무제한. |
| **Assigned Fulfillment Order Count** | 현재 location에 할당된 fulfillment order 수. 최대 capacity와 연관된 기간을 정의하려면 **지정 간격마다 이 값을 reset**한다. 예: 일별 capacity 추적은 자정(location 시간대)에 각 location의 이 값을 `0`으로 설정하는 자동 작업을 실행. |

Connect API 리소스 및 flow core action으로 location capacity를 관리하는 **4개 동작:**

- **Hold Fulfillment Order Capacity** — fulfillment order를 location에 할당하려 할 때 해당 location에 capacity를 hold한다. capacity가 없으면 에러를 반환한다.
  - `Free capacity = location의 fulfillment order capacity − (held capacity + assigned fulfillment orders의 합)`
- **Confirm Held Fulfillment Order Capacity** — fulfillment order를 location에 할당할 때 held capacity를 confirm한다. confirm 시 location의 **assigned fulfillment order count 증가**, held capacity 감소.
- **Release Fulfillment Order Capacity** — capacity를 hold 중인데 할당하지 않기로 하면 held capacity를 release한다. release 시 **assigned fulfillment order count 증가 없이** held capacity만 감소.
- **Get Fulfillment Order Capacity Values** — location의 maximum capacity, assigned fulfillment order count, capacity being held를 반환한다. **held quantity는 `Location` 객체의 필드로 표현되지 않으므로 이 함수가 유일한 조회 방법**이다.

> [!warning] held capacity는 assigned count reset과 독립적이다.
> location의 Assigned Fulfillment Order Count를 변경해도 held capacity에는 영향이 없다. 예를 들어 자정에 assigned count를 reset해도 미할당 fulfillment order의 held capacity는 제거되지 않는다. **held capacity를 줄이려면 반드시 confirm 또는 release** 해야 한다.

---

## Taxation in Order Management

세금 계산은 복잡할 수 있다 — 특히 multiple currency를 지원할 때 그렇다. 주문은 서로 다른 tax type을 가질 수 있고, 세금은 price adjustment의 영향을 받을 수 있다. (p.50)

### Tax Types (sales/VAT·net/gross)

주문은 두 가지 세금 유형을 포함할 수 있다: **sales tax**와 **value-added tax (VAT)**. (p.50)

| 유형 | 설명 | display type |
|---|---|---|
| **Sales tax** | 미국 등에서 상품·서비스의 판매 가격에 직접 부과. 세금 금액이 **상품 가격과 별도로 표시**된다. | **"net"** |
| **VAT** | 상품·서비스에 대한 간접세. **표시되는 상품 가격에 세금이 포함**된다. tax 필드가 나타나면 보통 금액 대신 "included"로 표시된다. | **"gross"** |

두 유형을 모두 지원하기 위해 OM 객체는 price amount·tax amount·combined amount, 그리고 주문이 net/gross taxation을 사용하는지에 대한 필드를 포함한다. business 요구에 맞는 필드를 보여주도록 page layout과 Salesforce Flow screen을 구성한다.

**핵심 필드·규칙:**

- **net taxation 표시:** order summary page layout에 `TotalAmount` + `TotalTaxAmount` 포함.
- **gross taxation 표시:** `GrandTotalAmount` 포함.
- order summary 레코드는 **항상 세 값을 모두 포함**하며, 다음이 **항상** 성립한다:

```
GrandTotalAmount = TotalAmount + TotalTaxAmount
```

- **Default page layout**은 net tax amount를 표시한다. sales tax locale만 지원하는 org는 default layout을 그대로 쓸 수 있다. VAT locale을 지원하는 org는 gross tax amount 필드를 표시하도록 page layout을 구성한다.
- **multicurrency org**는 일부 주문은 net, 일부는 gross로 표시할 수 있다. 그 경우 standard user profile을 clone해 gross tax locale의 service agent용 user profile을 만들고, gross tax amount 표시 page layout을 만든 뒤 새 profile에 할당한다. (→ [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]]와 무관, Multiple Currencies Help Topic 참조)
- price/tax 필드 상세는 Object Reference for Salesforce and Lightning Platform 참조.
- B2C Commerce integration의 세금 처리는 [[B2C Commerce Storefront Order Data Map]] 참조.

### Price Adjustments and Taxes (예제)

`OrderItemTaxLineItem` 객체는 order item에 적용된 세금, 또는 order item adjustment에 연관된 세금 변동을 나타낸다. (p.51-52)

> 예: `TotalPrice`가 100인 order item에 5% sales tax가 부과되면, `Amount` 5의 order item tax line item이 연관된다. **10% 할인**을 적용하면 `Amount` -10의 order item adjustment line item과 `Amount` -0.50의 order item tax line item이 생성된다. 이 adjustment order item tax line item은 자신이 조정하는 **order item adjustment line item과 원본 order item tax line item을 모두 참조**한다.

> 여러 order item tax line item을 가진 order item에 adjustment를 적용하면, 모든 tax adjustment가 **하나의 change order item tax line item으로 결합**된다. 예: order item에 `Amount` 1과 `Amount` 0.5 두 세금이 있을 때 10% 할인을 적용하면 `Amount` -0.15의 order item tax line item 하나가 생성된다.

> B2C Commerce integration은 각 order item의 세금을 단일 금액으로 결합한다. order item의 여러 세금을 구분하려면 custom attribute로 표현한다.

#### 전체 예제 — 10% 할인이 order item 세금 값에 미치는 영향

> 아래 레코드 값은 PDF p.51-52 원문 발췌(공식 예제, fabricate 아님).

**① 초기 상태** — order item `TotalPrice` 100, 10% sales tax:

```
OrderItem
  – TotalPrice 100
OrderItemTaxLineItem
  – Amount 10
  – OrderItemId pointing to the OrderItem
OrderItemSummary
  – TotalPrice 100
  – TotalTaxAmount 10
  – TotalAmtWithTax 110
  – OriginalOrderItemId pointing to the OrderItem
OrderItemTaxLineItemSummary
  – Amount 10
  – OrderItemSummaryId pointing to the OrderItem
  – OriginalOrderItemTaxLineItemId pointing to the OrderItemTaxLineItem
```

**② Adjust Order Item Summaries Submit action 호출** — OrderItem에 10% 할인 적용, 전달 값:

```
orderItemSummaryId — the ID of the OrderItemSummary
adjustmentType     — Percentage
discountValue      — -10
```

**③ 새로 생성된 레코드:**

```
OrderItemAdjustmentLineItem
  – Amount -10
  – TotalTaxAmount -1
  – TotalAmtWithTax -11
  – OrderItemId pointing to the OrderItem
OrderItemAdjustmentLineSummary
  – Amount -10
  – TotalTaxAmount -1
  – TotalAmtWithTax -11
  – OrderItemSummaryId pointing to the OrderItemSummary
  – OriginalOrderItemAdjustmentLineItemId pointing to the OrderItemAdjustmentLineItem
OrderItemTaxLineItem (for the adjustment)
  – Amount -1
  – OrderItemAdjustmentLineItemId pointing to the OrderItemAdjustmentLineItem
  – RelatedTaxLineItemId pointing to the original OrderItemTaxLineItem
OrderItemTaxLineItemSummary (for the adjustment)
  – Amount -1
  – OrderItemAdjustmentLineSummaryId pointing to the OrderItemAdjustmentLineSummary
  – OrderItemSummaryId pointing to the OrderItemSummary
  – OriginalOrderItemTaxLineItemId pointing to the new OrderItemTaxLineItem for the adjustment
```

**④ 기존 레코드의 변경 후 값:**

```
OrderItem (unchanged)
  – TotalPrice 100
OrderItemTaxLineItem (unchanged)
  – Amount 10
  – OrderItemId pointing to the OrderItem
OrderItemSummary
  – TotalPrice 90
  – TotalTaxAmount 9
  – TotalAmtWithTax 99
  – OriginalOrderItemId pointing to the OrderItem
  – TotalAdjustmentAmount -10
  – TotalAdjustmentTaxAmount -1
  – TotalAdjustmentAmtWithTax -11
OrderItemTaxLineItemSummary
  – Amount 9 (sum of both OrderItemTaxLineItems)
  – OrderItemSummaryId pointing to the OrderItem
  – OriginalOrderItemTaxLineItemId pointing to the original OrderItemTaxLineItem
```

---

## 관련 노트
- [[Order Management 개요와 데이터 모델]]
- [[B2C Commerce Storefront Order Data Map]]
- [[Order Management — Exchanges·Payment Sequencing·확장]]
- [[Bulk API 2.0]]
- [[REST API]]
- [[Platform Event 한도와 고려사항]]
- [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]]
