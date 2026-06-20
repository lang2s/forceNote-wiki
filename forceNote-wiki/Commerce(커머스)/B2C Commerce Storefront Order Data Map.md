---
tags: [commerce, order-management, b2c-commerce, data-map, integration, payment-gateway, field-mapping, xsd]
source: order_management_developer_guide_html.pdf (Version 66.0, Spring '26, Tier 2) — Salesforce B2C Commerce Storefront Order Data Map(p.5-38)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.order_management_developer_guide.meta/order_management_developer_guide/
created: 2026-06-20
aliases: [B2C Commerce Order Data Map, Storefront Order Data Map, B2C 주문 데이터 맵, XSD 매핑, Custom Payment Method, GtwyProvPaymentMethodType, 데이터 맵, 주문 필드 매핑]
---

# B2C Commerce Storefront Order Data Map

> B2C Commerce 주문 패킷의 XSD 값이 Salesforce Order Management의 **21개 객체 필드**로 어떻게 매핑되는지 — 통합 규칙·결제 게이트웨이 설정·커스텀 결제 수단·전수 매핑표. (`order_management_developer_guide_html.pdf` p.5-38)

> 📍 허브: [[Order Management 개요와 데이터 모델]]

---

## 개요

이 데이터 맵은 Salesforce B2C Commerce **주문 패킷(order packet)**의 데이터가 Salesforce Order Management의 레코드로 어떻게 매핑되는지 설명한다. 자체 스토어프론트 통합을 구현할 때 이 맵으로 주문 데이터 요구사항을 이해할 수 있다.

매핑표는 전 객체 공통으로 **3컬럼** 형식이다.

- **B2C Commerce XSD Value** — 소스. B2C 패킷의 XSD 경로(예: `order/billing-address/state-code`) 또는 `N/A`.
  - `N/A` = B2C 패킷에 대응 XSD 값이 없고, 시스템이 계산·조회로 값을 설정함을 의미.
- **Salesforce Object Field** — 타겟 SF 필드.
- **Notes** — 설명·계산식·조건.

> 계산식의 곡선따옴표(`" "`), `+" "+`, `+ "_" +`, `+ "-" +`, `+ ' ' +` 표기는 모두 PDF 원문 그대로 보존했다.

B2C Commerce 주문 데이터 포맷의 상세는 B2C Commerce Infocenter의 **Order XSD Schema**를 참조한다.

---

## 통합 규칙

### Integration Notes (General/Shopper)

#### General

- B2C Commerce는 **New 또는 Open 상태**의 주문을 Salesforce Order Management로 보낸다. 주문 전송을 지연하려면(예: fraud check 수행) **Created 상태**로 유지한다.
- B2C Commerce는 정해진 빈도(set frequency)로, 그리고 pending 주문 패킷이 일정 크기에 도달하면 주문 데이터를 보낸다. 이 과정은 Commerce Cloud Order Management에서 쓰는 것과 유사하다. 추가로 통합은 **5분마다** B2C Commerce에 pending 주문 데이터를 요청한다.
- B2C Integration은 **OrderItem + OrderItemAdjustmentLineItem 합계 200개 초과** 주문을 생성할 수 없다. 예: OrderItem 150개 + OrderItemAdjustmentLineItem 45개 주문은 생성 가능하나, OrderItem 110개 + 100개 주문은 불가. 이 한도를 초과하는 주문 import는 **Bulk API 2.0**을 사용한다.
  > 대량 import 절차는 [[Bulk API 2.0]] 참조. 수동 import 일반은 [[Order Management — Import·Fulfillment·Taxation]]의 Importing Order Data 참조.
- 통합은 B2C Commerce의 site를 Order Management의 **SalesChannel**과 연결한다. 주문 데이터의 `site/site-id` 값과 일치하는 `SalesChannelName` 값을 검색해 주문의 SalesChannel을 식별한다.
- B2C Integration 서비스 사용자는 internal Salesforce user다. 통합이 접근하는 객체에 internal organization-wide sharing default를 설정한다면 **Public Read/Write** 액세스로 설정한다.
  > Note: organization-wide sharing defaults는 Salesforce Help의 Organization-Wide Sharing Defaults 참조.
- Salesforce org ID나 login URL이 변경되거나, B2C Commerce 스토어프론트에서 **DBInit**을 실행하면 통합 갱신이 필요하다. 재프로비저닝은 Order Management Implementation Guide에 따라 Salesforce Customer Support에 케이스를 연다.
- 샌드박스 org을 refresh하거나 B2C Commerce 인스턴스의 **Tenant ID**를 변경하면 Implementation Guide의 구현 과정을 반복한다.
- 통합을 비활성화하려면 Salesforce Support에 케이스를 연다.
- 특정 site에서 주문 전송을 멈추려면 Business Manager에 로그인해 **Merchant Tools > Site Preferences > Order**로 이동, **Include in Order Management** 설정을 끈다.

#### Shopper Accounts

- 주문 데이터의 `order/billing-address/company-name` 값이 null이 아니면, Order Management는 **항상** standard account와 contact로 shopper를 표현한다.
- Person Account를 활성화한 경우, 두 default Account record type의 이름이나 API name을 변경하지 않는다. B2C Integration이 그 타입으로 shopper account를 표현한다.
- org의 duplicate·matching rule(Account·Contact·Person Account)을 적용해 기존 shopper를 식별하도록 통합을 구성할 수 있다. 활성화는 Setup의 Order Management Settings에서 **B2C Integration Data Matching Rules**를 켠다.
  > Note: matching rule이 여러 잠재 중복 레코드를 식별하면, 통합은 가장 높은 match score를 가진 것을 선택한다. 최고 점수가 동점이면 어느 것이 선택될지 보장할 수 없다.
  > Note: 복잡한 custom matching rule 적용은 통합 성능에 영향을 줄 수 있다.
- 통합은 Salesforce 객체의 **encrypted field를 조회할 수 없다.** 조회에 쓰는 필드를 암호화하면 주문 ingestion이 실패한다. `Account.Name`·`Account.PersonEmail`·`Contact.Email`을 암호화하려면 encrypted field를 쓰지 않는 custom duplicate·matching rule을 구현해야 한다.
- shopper account의 저장·식별 상세는 Salesforce Help의 Order Management Shopper Records 참조.

### International Considerations

- 주문의 `order/taxation` 값이 **net**이면, 통합은 각 OrderItem과 OrderItemAdjustmentLineItem 레코드마다 OrderItemTaxLineItem 레코드를 생성한다.
- Salesforce **state·country/territory picklist 미사용** 시:
  - `state-code` 값은 표준 2자 ISO state/province 코드와 일치해야 한다. 통합은 이를 Salesforce 레코드의 **State** 필드에 복사한다.
  - `country-code` 값은 표준 2자 ISO country/territory 코드와 일치해야 한다. 통합은 이를 **Country** 필드에 복사한다.
- Salesforce **state·country/territory picklist 사용** 시:
  - `state-code` 값은 Salesforce state picklist 엔트리의 state code와 일치해야 한다. 통합은 이를 **StateCode** 필드에 복사하고, 대응 **State** 필드는 picklist의 일치하는 integration value로 설정한다.
  - `country-code` 값은 country/territory picklist 엔트리의 코드와 일치해야 한다. 통합은 이를 **CountryCode** 필드에 복사하고, 대응 **Country** 필드는 picklist의 integration value로 설정한다.

### Payments

- 주문 데이터에는 주문에 연결된 각 결제마다 payment instrument와 payment transaction이 쌍으로 포함된다.
- `order/payments/payment/transaction-type` 값이 **auth로 시작**하면 통합은 그 트랜잭션에 대해 **PaymentAuthorization** 레코드를 생성한다. 값이 **sale 또는 capture**이면 **Payment** 레코드를 생성한다. 이 검사는 대소문자를 구분하지 않는다.
- credit/debit card 결제 타입의 경우, `payments/payment/credit-card/card-type` 값은 CardPaymentMethod 객체의 **CardType picklist** 값과 일치해야 한다.
- CardPaymentMethod CardType이나 DigitalWallet Type과 일치하지 않는 결제 수단을 처리하려면, 이 섹션 뒤의 **custom payment method**를 생성한다.
- Salesforce Payments를 사용하면, 통합은 AlternativePaymentMethod·CardPaymentMethod·DigitalWallet의 일부 필드에 다른 값을 설정한다. 상세는 각 매핑표에 있다.
- 통합은 `order/payments/payment`의 특정 custom attribute를 인식해 Salesforce **PaymentGatewayLog** 레코드의 standard field로 복사한다. 이 기능을 쓰려면 B2C Commerce의 **Order Payment Transaction 객체**에 다음 정확한 이름의 custom attribute를 생성·채운다.
  - `authCode` → `PaymentGatewayLog.GatewayAuthCode`
  - `avsResultCode` → `PaymentGatewayLog.GatewayAvsCode`
  - `approvalStatus` → `PaymentGatewayLog.GatewayResultCode`
- 통합은 `order/payments/payment`의 다른 custom attribute도 AlternativePaymentMethod·CardPaymentMethod·DigitalWallet·Payment·PaymentAuthorization 레코드의 standard field로 복사할 수 있다.
- B2C Commerce 주문의 OrderPaymentSummary는 **결제 수단이 credit card일 때만** FullName 값을 갖는다. 다른 결제 수단은 통합이 FullName 설정에 쓰는 데이터 값을 포함하지 않는다.

### Promotions

- 통합은 각 order-level `price-adjustments/price-adjustment/promotion-id`마다, 그리고 주문 내 둘 이상의 item에 적용되는 각 item-level `price-adjustments/price-adjustment/promotion-id`마다 **OrderAdjustmentGroup** 레코드를 생성한다. 각 OrderAdjustmentGroup에 대해, 연관 promotion이 적용되는 주문 내 각 OrderItem마다 OrderItemAdjustmentLineItem 레코드를 생성한다. 한 OrderItem이 여러 promotion의 영향을 받으면 각각에 대해 OrderItemAdjustmentLineItem을 가질 수 있다.
- 주문의 `order/taxation` 값이 **net**이면, 통합은 각 OrderItemAdjustmentLineItem 레코드마다 OrderItemTaxLineItem 레코드를 생성한다.

> Salesforce state·country/territory picklist 정보는 Salesforce Help의 Let Users Select State and Country from Picklists 참조.

---

## 결제 게이트웨이 설정

### Set Up Payment Gateways

각 merchant account마다 payment gateway adapter를 구성한다. 단일 payment processor를 통해 여러 통화·결제 수단을 쓰면, 선택적으로 그 processor에 여러 payment gateway를 설정할 수 있다. 기본적으로 Salesforce B2C Commerce와의 Order Management 통합은 **credit card와 digital wallet** 결제 타입만 지원하나, 자체 커스터마이징을 만들 수 있다.

Apex와 Connect REST API로 payment gateway를 설정할 수 있다.

> 게이트웨이 어댑터(`commercepayments` 네임스페이스, `PaymentGatewayAdapter` 인터페이스, request/response 클래스) 설정 상세는 [[CommercePayments Namespace]] 참조. (Apex Developer Guide의 *Use Cases for the commercepayments Namespace*, Connect REST API Developer Guide의 *Commerce Payments Resources*)

### Payment Method Processing

B2C Commerce 통합은 주문 데이터의 각 스토어프론트 결제 수단을 다음 순서로 처리한다.

1. 주문 데이터의 payment method ID가 다음 **non-case-sensitive 정규식**과 일치하는가? 일치하면 Salesforce에 **DigitalWallet** 레코드를 생성한다.
   ```
   paypal|visa_checkout|pay_by_check|.*(apple|google|android|amazon|ali).*(pay)*
   ```
2. payment method ID가 Salesforce **GtwyProvPaymentMethodType** 레코드의 Gateway Provider Payment Method Type과 일치하는가? 일치하면 그 GtwyProvPaymentMethodType의 Payment Method Type에 따라 레코드를 생성한다.
3. 주문 데이터의 card type이 CardPaymentMethod 객체의 **Card Type picklist** 엔트리와 일치하는가? 일치하면 **CardPaymentMethod** 레코드를 생성한다.
   > Note: Card Type picklist는 커스터마이징할 수 없다.
4. 결제 수단이 지원되지 않는다는 에러 메시지를 반환한다.

다른 결제 타입을 지원하려면 다음 섹션의 custom payment method를 설정한다.

### Create Custom Payment Methods

다음 두 조건을 모두 충족하는 스토어프론트 결제 수단에는 custom payment method를 구성한다.

- default 정규식이 이를 DigitalWallet 수단으로 식별하지 못함.
- CardPaymentMethod의 표준 card type 어느 것과도 일치하지 않음.

custom payment method를 **AlternativePaymentMethod**로 구성하려면, 먼저 AlternativePaymentMethod 객체의 **RecordType**을 생성한다. 결제 수단을 나타내는 이름을 record type에 부여한다.

**GtwyProvPaymentMethodType (Gateway Provider Payment Method Type)** 레코드를 생성해 custom payment method를 정의한다. 이 레코드는 custom 결제 수단을 payment gateway와 연결하고, AlternativePaymentMethod·CardPaymentMethod·DigitalWallet 중 하나로 정의한다.

> Note: GtwyProvPaymentMethodType 레코드는 Salesforce UI에서 생성·접근할 수 없다. 생성하려면 Postman이나 Apex 코드 같은 도구로 레코드를 insert한다. 객체의 API name은 `GtwyProvPaymentMethodType`, URL은 `/services/data/vversion/sobjects/GtwyProvPaymentMethodType`.

#### GtwyProvPaymentMethodType 필드 (6+1)

| 필드 | 설명 |
|---|---|
| **Comments** | 선택 설명(Optional description). |
| **Developer Name** | 레코드의 고유 API name. |
| **Master Label** | 사람이 읽을 수 있는 이름. |
| **Gateway Provider Payment Method Type** | 스토어프론트의 결제 수단 이름. 이 값은 B2C Commerce에서 쓰는 payment method ID와 **정확히 일치**해야 한다. |
| **Payment Gateway Provider Id** | 해당 결제 수단의 payment processor와 연결된 Payment Gateway Provider 레코드 참조. |
| **Payment Method Type** | `AlternativePaymentMethod`, `CardPaymentMethod`, 또는 `DigitalWallet`. AlternativePaymentMethod를 쓰려면 먼저 대응 RecordType 레코드를 생성. |
| **Record Type Id** | AlternativePaymentMethod 사용 시, RecordType 레코드 참조. |

gateway provider payment method 정의 예제:

```json
{
    "DeveloperName" : "BankTransfer"
    "MasterLabel" : "Bank Transfer",
    "GtwyProviderPaymentMethodType" : "directBanking",
    "PaymentGatewayProviderId" : "0cJaa0000000001E67",
    "PaymentMethodType" : "AlternativePaymentMethod",
    "RecordTypeId" : "012aa000000008A34F"
}
```

> PDF 원문 그대로 보존: 첫 줄 `"DeveloperName"` 뒤에 **콤마가 누락**되어 있고, `RecordTypeId` 키만 PDF에서 곡선따옴표(`" "RecordTypeId" "`)로 표기되어 있다. 실제 사용 시 콤마를 추가하고 모든 키를 곧은 따옴표로 통일해야 유효한 JSON이 된다.

---

## 커스텀 데이터 통합

### Integrate Custom B2C Storefront Data

통합은 특정 B2C Commerce 객체의 custom 데이터를 Order Management로 전달할 수 있다. 전송을 설정하려면 B2C Commerce 객체에 **custom attribute**를 추가하고, Order Management의 대응 객체에 일치하는 **custom field**를 추가한다. 통합은 B2C Commerce attribute ID와 Order Management field name을 **API 레벨**에서 비교한다(UI 레이블은 고려하지 않음). 둘이 일치하고 data type도 일치하면, Order Management 레코드 생성 시 그 값을 포함한다. 대응 summary 객체에도 일치하는 필드를 만들면, summary 레코드 생성 시 custom 데이터를 포함한다.

product line item으로 존재하는 product option에는 custom attribute를 추가할 수 있으나, parent product의 attribute로 존재하는 product option에는 추가할 수 없다. **attribute에 attribute를 추가할 수는 없다.**

flow에서 쓰는 객체에 custom field를 추가하면 그 field를 처리하도록 flow를 커스터마이징한다.

> Important: change order는 Order 레코드다. Order 객체에 **required** custom field를 추가하면, change order 생성 시 그 field를 설정하도록 service flow를 갱신한다. 그러지 않으면 flow가 실패한다.

주문 데이터에 custom attribute 값이 있으나 대응 Salesforce 객체에 일치하는 custom field가 없으면, 통합은 그 attribute를 무시한다. Salesforce에 custom field가 있으나 주문 데이터에 일치하는 custom attribute 값이 없으면, 통합은 이를 무시한다.

> Important: Salesforce의 custom field가 **required**이고 custom 스토어프론트 attribute에 대응하면, 주문 데이터에 반드시 그 attribute 값이 포함돼야 한다. 값이 없으면 통합이 대응 Salesforce 레코드를 생성하지 못하고 에러로 실패한다.

> Note: API 레벨에서 Salesforce custom field name은 항상 `__c`로 끝난다. 스토어프론트 객체의 일치 attribute 이름에는 `__c`를 **포함하지 않는다.** 단, custom field name에 custom namespace를 포함하면 일치 스토어프론트 attribute 이름에도 포함한다. 예: Salesforce custom field API name이 `mynamespace_FieldName__c`이면, 일치 스토어프론트 attribute는 `mynamespace_FieldName`으로 명명한다. custom field name은 **40자(37 + `__c`)**로 제한한다.

**Product bundle 지원:** 스토어프론트 line item 객체에 custom `guid` attribute를 정의하고, Salesforce에서 OrderItem과 OrderItemSummary에 일치 field를 정의해 product bundle association을 설정할 수 있다. 주문 생성 시 같은 묶음에 속한 line item에 동일 값을 할당한다. line item이 bundle의 일부임을 식별하는 다른 custom attribute를 정의하고, fulfillment 프로세스에 처리 로직을 넣을 수 있다.

> Note: bundle 지원에 custom attribute를 쓸 때, 비즈니스 규칙에 맞게 return·cancel flow를 커스터마이징한다. 예: bundle product를 취소하면 연관 bundle product도 함께 취소되도록 cancel 프로세스를 설계한다. return 프로세스는 bundle 내 일부 product만 반품하지 못하게 설계할 수 있다.

#### 매칭 가능한 객체 쌍

다음 객체 세트에서 custom attribute와 field를 매칭할 수 있다. **High-Scale Order Integration (HSOI)**에서는 custom field가 **summary 객체에만** 필요하다. HSOI는 이 field에 직접 매핑한다. HSOI 사용 시 standard 객체에 custom field를 추가하지 않는다 — custom field를 한 곳에 유지하면 설정이 간소화된다.

| B2C Commerce | Salesforce Order Management |
|---|---|
| Product line item, gift certificate line item, and shipping line item | OrderItem and OrderItemSummary |
| Order | Order and OrderSummary |
| Order payment instrument and order payment transaction | AlternativePaymentMethod, CardPaymentMethod, DigitalWallet, Payment, PaymentAuthorization, and PaymentGatewayLog (note 참조) |
| Shipment | OrderDeliveryGroup and OrderDeliveryGroupSummary |
| Buyer Address on Order | Account (including Person Account) and Contact |

> Note: PaymentGatewayLog 객체에는 custom field를 추가할 수 없다. 단, 통합은 `order/payments/payment`의 특정 custom attribute를 인식해 PaymentGatewayLog 레코드의 standard field로 복사한다. 이를 쓰려면 B2C Commerce의 Order Payment Transaction 객체에 다음 정확한 이름의 custom attribute를 생성·채운다.
> - `authCode` → `PaymentGatewayLog.GatewayAuthCode`
> - `avsResultCode` → `PaymentGatewayLog.GatewayAvsCode`
> - `approvalStatus` → `PaymentGatewayLog.GatewayResultCode`

#### 지원 데이터타입 (11종)

custom attribute·field 매칭에 통합이 지원하는 데이터타입:

- Boolean
- Currency
- Datetime (**Date는 미지원**)
- Double
- Email
- Multipicklist
- Phone
- Picklist
- String
- TextArea
- URL

#### 권한셋 절차 (Order Management B2C Service)

**Order Management B2C Service** 권한셋이 통합에 Salesforce 레코드 접근을 제공한다. Salesforce 객체에 custom field를 추가하면, 그 권한셋에 새 field의 read·edit 액세스를 추가한다. 또한 Order Management 사용자용 권한셋에도 edit 액세스를 추가해야 한다.

1. Setup의 Quick Find에 `Permission Sets` 입력 후 **Permission Sets** 선택.
2. **Order Management B2C Service** 선택.
3. Apps 섹션에서 **Object Settings** 클릭.
4. custom field가 있는 객체 선택.
5. **Edit** 클릭.
6. Field Permissions 섹션에서 custom field의 **Edit Access** 체크박스 선택.
7. **Save** 클릭.
8. Setup navigation menu에서 **Permission Sets** 선택해 권한셋 목록으로 복귀.
9. Order Management 사용자 접근을 제어하는 권한셋 선택(보통 **OM Console**).
10. Apps 섹션에서 **Object Settings** 클릭.
11. custom field가 있는 객체 선택.
12. **Edit** 클릭.
13. Field Permissions 섹션에서 custom field의 **Edit Access** 체크박스 선택.
14. **Save** 클릭.

### Sync Data with Manual Data Map Refresh

새 custom attribute 추가 후 등, Salesforce Order Management의 order data map을 B2C Commerce org과 동기화한다. data map refresh를 트리거하면 다음 예약 sync를 기다리지 않고 새 스키마 변경에 즉시 접근한다.

1. App Launcher 클릭 후 **Administration > Global Preferences > Salesforce Order Management Configuration** 선택.
2. **Refresh Data Map** 클릭.
3. 변경 사항 저장.

---

## 객체별 매핑표 (21개)

> 각 표는 PDF 원문 행·셀을 전수 보존한다. 컬럼: `B2C Commerce XSD Value | Salesforce Object Field | Notes`.

### Account (Standard or PersonAccount)

Order Management는 company name을 가진 shopper를 표현할 때 **항상 standard account**를 쓴다. 주문에 `order/billing-address/company-name` 값이 있고 일치하는 account 레코드가 없으면, **Person Accounts for Shoppers 설정과 무관하게** standard account를 생성한다. **Person Accounts for Shoppers** admin 설정 변경은 기존 shopper 데이터에 영향을 주지 않으나, B2C Integration이 새 shopper 데이터를 저장하는 방식과 기존 shopper 데이터를 인식할지 여부를 바꾼다.

> Note: B2C Integration Data Matching Rules 설정이 켜져 있으면, 이 동작은 org의 matching rule에 따라 달라질 수 있다.

- **standard account 사용 중:** 통합은 person account로 저장된 기존 shopper를 인식해 그들의 새 주문을 기존 person account와 연결한다. 기존 shopper가 두 타입 레코드를 모두 가지면, 새 주문을 standard account·contact와 연결한다.
- **person account 사용 중:** 통합은 standard account·contact로 저장된 기존 shopper를 인식하지 못한다. 그 shopper가 주문하면 통합은 person account 레코드를 생성하고 새 주문을 거기 연결한다. Order Management는 두 account를 별개 shopper로 취급한다. 기존 shopper가 두 타입 레코드를 모두 가지면, 통합은 새 주문을 person account와 연결한다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| order/billing-address/company-name or order/billing-address/first-name and order/billing-address/last-name | Name | If order/billing-address/company-name has a value in the order data packet, then it's copied to this value. If it has no value in the order data, this value is set as follows: • If this record is a person account, this value isn't set. • If this record isn't a person account, this value is set to order/billing-address/first-name +" "+ order/billing-address/last-name. |
| order/billing-address/first-name and order/billing-address/second-name | FirstName | This value is only set for person accounts. It's set to order/billing-address/first-name +" "+ order/billing-address/second-name. |
| order/billing-address/last-name | LastName | This value is only set for person accounts. |
| order/customer/customer-email | PersonEmail | This value is only set for person accounts. |
| order/billing-address/title | PersonTitle | This value is only set for person accounts. |
| order/billing-address/address1, order/billing-address/address2, and order/billing-address/address3 | BillingStreet | This value is only set for person accounts. It's set to order/billing-address/address1 +" "+ order/billing-address/address2 +" "+ order/billing-address/address3. |
| order/billing-address/city | BillingCity | This value is only set for person accounts. |
| order/billing-address/postal-code | BillingPostalCode | This value is only set for person accounts. |
| order/billing-address/state-code | BillingState | This value is only set for person accounts. Usage depends on whether state and country/territory picklists are enabled in Salesforce. • Picklists not enabled—This value is set to order/billing-address/state-code. It must be a standard 2-character ISO state or province code. • Picklists enabled—This value is set to the picklist integration value corresponding to the state code that matches order/billing-address/state-code. |
| order/billing-address/state-code | BillingStateCode | This value is only set for person accounts, and only when state and country/territory picklists are enabled on your org. order/billing-address/state-code must match the state code of an entry in the Salesforce state picklist. |
| order/billing-address/country-code | BillingCountry | This value is only set for person accounts. Usage depends on whether state and country/territory picklists are enabled in Salesforce. • Picklists not enabled—This value is set to order/billing-address/country-code. It must be a standard 2-character ISO country/territory code. • Picklists enabled—This value is set to the picklist integration value corresponding to the country/territory code that matches order/billing-address/country-code. |
| order/billing-address/country-code | BillingCountryCode | This value is only set for person accounts, and only when state and country/territory picklists are enabled on your org. order/billing-address/country-code must match the country/territory code of an entry in the Salesforce country/territory picklist. |
| order/billing-address/phone | Phone | This value is set for both person accounts and regular accounts. |

### AlternativePaymentMethod

통합은 주문 내 각 payment instrument의 `payment_method` 값을 확인한다. 그 값이 GtwyProvPaymentMethodType 레코드의 Gateway Provider Payment Method Type과 일치하면, GtwyProvPaymentMethodType의 Payment Method Type 값에 따라 레코드를 생성한다. Payment Method Type이 AlternativePaymentMethod이면, 연관 RecordType을 써서 AlternativePaymentMethod 레코드를 생성한다.

> Note: AlternativePaymentMethod를 쓰려면 먼저 Create Custom Payment Methods 섹션처럼 custom 결제 타입의 RecordType과 GtwyProvPaymentMethodType을 생성한다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| N/A | RecordTypeId | This value is set to the ID of the RecordType record assigned to the GtwyProvPaymentMethodType. |
| order/payments/payment/credit-card/card-token | GatewayToken | |
| order/customer/customer-email | Email | |
| N/A | Status | This picklist value is always set to Active. |
| order/billing-address/company-name | CompanyName | |
| payment instrument payment_type or payment_method | Type | The value depends on whether you're using Salesforce Payments. • Salesforce Payments—This value is set to the payment instrument payment_type. • Other Payment Processor—This value is set to the payment instrument payment_method. |
| payment instrument payment_type or payment_method | PaymentMethodType | The value depends on whether you're using Salesforce Payments. If the payment instrument value isn't present, a PaymentMethodType isn't set. |
| payment instrument payment_bank | PaymentMethodSubType | The value depends on whether you're using Salesforce Payments. If the payment instrument value isn't present, a PaymentMethodSubType isn't set. |
| payment instrument payment_account_last_digits | PaymentMethodDetails | |
| order/billing-address/address1, order/billing-address/address2, and order/billing-address/address3 | PaymentMethodStreet | This value is set to order/billing-address/address1 +" "+ order/billing-address/address2 +" "+ order/billing-address/address3. |
| order/billing-address/city | PaymentMethodCity | |
| order/billing-address/state-code | PaymentMethodState | Usage depends on whether state and country/territory picklists are enabled in Salesforce. • Picklists not enabled—This value is set to order/billing-address/state-code. It must be a standard 2-character ISO state or province code. • Picklists enabled—This value is set to the picklist integration value corresponding to the state code that matches order/billing-address/state-code. |
| order/billing-address/state-code | PaymentMethodStateCode | This value is only set when state and country/territory picklists are enabled on your org. order/billing-address/state-code must match the state code of an entry in the Salesforce state picklist. |
| order/billing-address/postal-code | PaymentMethodPostalCode | |
| order/billing-address/country-code | PaymentMethodCountry | Usage depends on whether state and country/territory picklists are enabled in Salesforce. • Picklists not enabled—This value is set to order/billing-address/country-code. It must be a standard 2-character ISO country/territory code. • Picklists enabled—This value is set to the picklist integration value corresponding to the country/territory code that matches order/billing-address/country-code. |
| order/billing-address/country-code | PaymentMethodCountryCode | This value is only set when state and country/territory picklists are enabled on your org. order/billing-address/country-code must match the country/territory code of an entry in the Salesforce country/territory picklist. |
| order/billing-address/phone | Phone | |
| orderremoteHost | IpAddress | |
| N/A | AccountId | This value is set to the ID of the Account or Person Account record associated with the shopper. |
| N/A | PaymentGatewayId | This value is set to the ID of the PaymentGateway record associated with the PaymentGatewayProvider record assigned to the GtwyProvPaymentMethodType. |
| N/A | ProcessingMode | This value is always set to External. It specifies that an external payment provider handles payment transactions. |
| order/payments/payment/custom_attribute or a custom attribute on the payment type | custom_attribute_name | If the Salesforce AlternativePaymentMethod object has a custom field matching a custom attribute on the storefront payment type or order payment transaction object, the value is copied to the AlternativePaymentMethod record. If a custom field is non-nillable, then order data must include a value for the corresponding custom attribute. If the value is missing, the integration fails. |

> PDF 원문 그대로(오타 보존): `orderremoteHost`는 `order/remoteHost`의 슬래시가 pdftotext 추출 과정에서 누락됐을 가능성이 있다. 원문 표기 그대로 보존.

### CardPaymentMethod

통합은 주문 내 각 payment instrument의 `payment_method` 값을 다음 regex와 대조한다. 일치하면 DigitalWallet 레코드를 생성한다. 불일치하면 `payment/credit-card/card-type` 값을 CardPaymentMethod 객체의 CardType picklist와 대조한다. picklist에 일치 항목이 있으면 CardPaymentMethod 레코드를 생성한다. 그렇지 않으면 해당 결제 수단을 지원하기 위해 custom payment method를 설정해야 한다.

```
paypal|visa_checkout|pay_by_check|.*(apple|google|android|amazon|ali).*(pay)*
```

> Note: regex는 대소문자를 구분하지 않는다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| payment instrument payment_brand or order/payments/payment/credit-card/card-type | CardType | The value depends on whether you're using Salesforce Payments. • Salesforce Payments—This value is set to the payment instrument payment_brand. • Other Payment Processor—This value is set to order/payments/payment/credit-card/card-type. The value must match a card type in the CardType picklist on the CardPaymentMethod object. To handle a different card type, create a custom payment method as described in the Order Management Implementation Guide. |
| order/payments/payment/credit-card/card-number | InputCardNumber | |
| order/payments/payment/credit-card/card-holder | CardHolderName | |
| order/payments/payment/credit-card/expiration-year | ExpiryYear | |
| order/payments/payment/credit-card/expiration-month | ExpiryMonth | |
| [order payment method] | CardCategory | This value can be CreditCard or DebitCard. The default value is CreditCard. |
| N/A | Status | This picklist value is always set to Active. |
| order/payments/payment/credit-card/card-token | GatewayToken | |
| payment instrument payment_brand or credit_card_type | PaymentMethodType | The value depends on whether you're using Salesforce Payments. If the payment instrument value isn't present, the value is set to Other. • Salesforce Payments—This value is set to the payment instrument payment_brand. • Other Payment Processor—This value is set to the payment instrument credit_card_type. |
| payment instrument payment_wallet_type or payment_method | PaymentMethodSubType | The value depends on whether you're using Salesforce Payments. • Salesforce Payments—This value is set to the payment instrument payment_wallet_type. • Other Payment Processor—This value is set to the payment instrument payment_method. |
| payment instrument payment_account_last_digits or masked_credit_card_number | PaymentMethodDetails | The value depends on whether you're using Salesforce Payments. • Salesforce Payments—This value is set to the payment instrument payment_account_last_digits. • Other Payment Processor—This value is set to the payment instrument masked_credit_card_number. |
| order/billing-address/address1, order/billing-address/address2, and order/billing-address/address3 | PaymentMethodStreet | This value is set to order/billing-address/address1 +" "+ order/billing-address/address2 +" "+ order/billing-address/address3. |
| order/billing-address/city | PaymentMethodCity | |
| order/billing-address/state-code | PaymentMethodState | Usage depends on whether state and country/territory picklists are enabled in Salesforce. • Picklists not enabled—This value is set to order/billing-address/state-code. It must be a standard 2-character ISO state or province code. • Picklists enabled—This value is set to the picklist integration value corresponding to the state code that matches order/billing-address/state-code. |
| order/billing-address/state-code | PaymentMethodStateCode | This value is only set when state and country/territory picklists are enabled on your org. order/billing-address/state-code must match the state code of an entry in the Salesforce state picklist. |
| order/billing-address/postal-code | PaymentMethodPostalCode | |
| order/billing-address/country-code | PaymentMethodCountry | Usage depends on whether state and country/territory picklists are enabled in Salesforce. • Picklists not enabled—This value is set to order/billing-address/country-code. It must be a standard 2-character ISO country/territory code. • Picklists enabled—This value is set to the picklist integration value corresponding to the country/territory code that matches order/billing-address/country-code. |
| order/billing-address/country-code | PaymentMethodCountryCode | This value is only set when state and country/territory picklists are enabled on your org. order/billing-address/country-code must match the country/territory code of an entry in the Salesforce country/territory picklist. |
| N/A | AccountId | This value is set to the ID of the Account or Person Account record associated with the CardPaymentMethod. |
| N/A | PaymentGatewayId | This value is set to the ID of the PaymentGateway record whose ExternalReference value matches the processor ID value of the order payment instrument. |
| N/A | ProcessingMode | This value is always set to External. It specifies that an external payment provider handles payment transactions. |
| order/payments/payment/custom_attribute or a custom attribute on the payment type | custom_attribute_name | If the Salesforce CardPaymentMethod object has a custom field matching a custom attribute on the storefront payment type or order payment transaction object, the value is copied to the CardPaymentMethod record. If a custom field is non-nillable, then order data must include a value for the corresponding custom attribute. If the value is missing, the integration fails. |

### Contact

person account 사용 시 shopper contact 데이터는 contact 레코드가 아니라 person account 레코드로 접근한다. standard account·contact 사용 시, 다음 객체의 **BillToContactId** 필드가 연관 contact 레코드를 가리킨다: Credit Memo, Fulfillment Order, Invoice, Order, Order Summary.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| N/A | AccountId | This value is set to the ID of the Account record that represents the shopper. |
| order/customer/customer-email | Email | |
| order/billing-address/first-name | FirstName | |
| order/billing-address/last-name | LastName | |
| order/billing-address/phone | Phone | |

### DigitalWallet

통합은 주문 내 각 payment instrument의 `payment_method` 값을 확인한다. 다음 regex와 일치하면 DigitalWallet 레코드를 생성한다. 불일치하면 AlternativePaymentMethod 또는 CardPaymentMethod 레코드 생성을 시도한다.

```
paypal|visa_checkout|pay_by_check|.(apple|google|android|amazon|ali).(pay)*
```

> Note: regex는 대소문자를 구분하지 않는다.

> 주: DigitalWallet regex의 누락 별표는 PDF pdftotext 추출 한계 가능성, 원문 그대로 보존. 위 regex는 CardPaymentMethod / Payment Method Processing 섹션의 `.*(apple|google|android|amazon|ali).*(pay)*` 와 달리 `.(apple...).( pay)*` 로 `*`가 누락되어 있다. 의미상으로는 다른 두 곳과 동일한 `.*(...).*(pay)*` 형태가 일관적이다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| N/A | Status | This picklist value is always set to Active. |
| payment instrument payment_type or payment_method | Type | The value depends on whether you're using Salesforce Payments. • Salesforce Payments—This value is set to the payment instrument payment_type. • Other Payment Processor—This value is set to the payment instrument payment_method. |
| order/payments/payment/credit-card/card-token | GatewayToken | |
| payment instrument payer_email | Email | |
| payment instrument payment_type or payment_method | PaymentMethodType | The value depends on whether you're using Salesforce Payments. • Salesforce Payments—This value is set to the payment instrument payment_type. • Other Payment Processor—This value is set to the payment instrument payment_method. |
| payment instrument payment_type or payment_method | PaymentMethodSubType | The value depends on whether you're using Salesforce Payments. • Salesforce Payments—This value is set to the payment instrument payment_type. • Other Payment Processor—This value is set to the payment instrument payment_method. |
| payment instrument payment_reference | PaymentMethodDetails | |
| order/billing-address/address1, order/billing-address/address2, and order/billing-address/address3 | PaymentMethodStreet | This value is set to order/billing-address/address1 +" "+ order/billing-address/address2 +" "+ order/billing-address/address3. |
| order/billing-address/city | PaymentMethodCity | |
| order/billing-address/state-code | PaymentMethodState | Usage depends on whether state and country/territory picklists are enabled in Salesforce. • Picklists not enabled—This value is set to order/billing-address/state-code. It must be a standard 2-character ISO state or province code. • Picklists enabled—This value is set to the picklist integration value corresponding to the state code that matches order/billing-address/state-code. |
| order/billing-address/state-code | PaymentMethodStateCode | This value is only set when state and country/territory picklists are enabled on your org. order/billing-address/state-code must match the state code of an entry in the Salesforce state picklist. |
| order/billing-address/postal-code | PaymentMethodPostalCode | |
| order/billing-address/country-code | PaymentMethodCountry | Usage depends on whether state and country/territory picklists are enabled in Salesforce. • Picklists not enabled—This value is set to order/billing-address/country-code. It must be a standard 2-character ISO country/territory code. • Picklists enabled—This value is set to the picklist integration value corresponding to the country/territory code that matches order/billing-address/country-code. |
| order/billing-address/country-code | PaymentMethodCountryCode | This value is only set when state and country/territory picklists are enabled on your org. order/billing-address/country-code must match the country/territory code of an entry in the Salesforce country/territory picklist. |
| N/A | AccountId | This value is set to the ID of the Account or Person Account record associated with the DigitalWallet. |
| N/A | PaymentGatewayId | This value is set to the ID of the PaymentGateway record whose ExternalReference value matches the processor ID value of the order payment instrument. |
| N/A | ProcessingMode | This value is always set to External. It specifies that an external payment provider handles payment transactions. |
| order/payments/payment/custom_attribute or a custom attribute on the payment type | custom_attribute_name | If the Salesforce DigitalWallet object has a custom field matching a custom attribute on the storefront payment type or order payment transaction object, the value is copied to the DigitalWallet record. If a custom field is non-nillable, then order data must include a value for the corresponding custom attribute. If the value is missing, the integration fails. |

### Order

통합은 `order/order-no`와 `catalog/catalog-id` 값을 모두 써서 중복 주문을 확인한다. order-no와 일치하는 OrderReferenceNumber, 그리고 catalog-id와 일치하는 SalesChannel을 가리키는 SalesChannelId를 가진 기존 order 레코드를 찾는다. 찾으면 중복 주문을 생성하지 않는다.

> Note: sales channel의 catalog ID가 바뀌고, 다른 catalog ID로 기존 주문이 수신되면, 통합은 이를 새 주문으로 간주해 중복 레코드를 생성한다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| N/A | Pricebook2Id | This value is set to the ID of the Pricebook2 record for the standard price book. |
| order/customer/customer-name | Name | |
| N/A | Status | When the Order record is created, this value is set to Draft. The last step in the Composite API call that creates the records related to the order sets this value to Active. |
| N/A | EffectiveDate | This value is set to the current datetime when the record is created. |
| catalog/catalog-id and order/order-no | OrderManagementReferenceIdentifier | This value is set to B2C realm ID + "_" + B2C instance ID + "@" + catalog/catalog-id + "@" + order/order-no. |
| order/order-no | OrderReferenceNumber | |
| order/billing-address/address1, order/billing-address/address2, and order/billing-address/address3 | BillingStreet | This value is set to order/billing-address/address1 +" "+ order/billing-address/address2 +" "+ order/billing-address/address3. |
| order/billing-address/city | BillingCity | |
| order/billing-address/state-code | BillingState | Usage depends on whether state and country/territory picklists are enabled in Salesforce. • Picklists not enabled—This value is set to order/billing-address/state-code. It must be a standard 2-character ISO state or province code. • Picklists enabled—This value is set to the picklist integration value corresponding to the state code that matches order/billing-address/state-code. |
| order/billing-address/state-code | BillingStateCode | This value is only set when state and country/territory picklists are enabled on your org. order/billing-address/state-code must match the state code of an entry in the Salesforce state picklist. |
| order/billing-address/postal-code | BillingPostalCode | |
| order/billing-address/country-code | BillingCountry | Usage depends on whether state and country/territory picklists are enabled in Salesforce. • Picklists not enabled—This value is set to order/billing-address/country-code. It must be a standard 2-character ISO country/territory code. • Picklists enabled—This value is set to the picklist integration value corresponding to the country/territory code that matches order/billing-address/country-code. |
| order/billing-address/country-code | BillingCountryCode | This value is only set when state and country/territory picklists are enabled on your org. order/billing-address/country-code must match the country/territory code of an entry in the Salesforce country/territory picklist. |
| order/billing-address/phone | BillingPhoneNumber | |
| order/order-date | OrderedDate | |
| order/customer/customer-email | BillingEmailAddress | |
| N/A | BillToContactId | This value is set to the ID of the Contact record that represents the shopper. When using person accounts, this value isn't set. In that case, access shopper contact information via the Account instead of the Contact. |
| N/A | AccountId | This value is set to the ID of the Account or Person Account record that represents the shopper. |
| catalog/catalog-id | SalesChannelId | This value is set to the ID of the SalesChannel record whose SalesChannelName field matches the catalog/catalog-id in the order data packet. |
| order/taxation | TaxLocaleType | This value is set to Net or Gross based on the value of order/taxation. If using Net taxation, this value is set to Net and the integration creates OrderItemTaxLineItem records for the order. If using Gross taxation, this value is set to Gross and the integration doesn't create OrderItemTaxLineItem records for the order. If the value isn't set, then the default value is Net. |
| order/currency | CurrencyIsoCode | This value is only set if the Salesforce org has Multicurrency enabled. |
| order/custom_attribute | custom_attribute_name | If the Salesforce Order object has a custom field matching a custom attribute on the storefront order object, the value is copied to the Order record. If the Salesforce OrderSummary object also has a matching custom field, it's copied to both records. If a custom field is non-nillable, then order data must include a value for the corresponding custom attribute. If the value is missing, the integration fails. |

### OrderAdjustmentGroup

통합은 주문 전체 또는 주문 내 여러 item에 적용되는 각 promotion마다 OrderAdjustmentGroup 레코드를 하나 생성한다. order-level promotion의 경우, 주문 내 각 OrderItem마다 OrderItemAdjustmentLineItem 레코드 하나에 OrderAdjustmentGroup을 할당한다. 주문에 OrderItem이 하나뿐이어도 OrderAdjustmentGroup을 생성한다. 여러 OrderItem에 적용되는 item-level promotion의 경우, promotion이 적용되는 각 OrderItem마다 OrderItemAdjustmentLineItem 하나에 OrderAdjustmentGroup을 할당한다. item-level promotion이 OrderItem 하나에만 적용되면 통합은 OrderAdjustmentGroup을 생성하지 않는다.

> Note: order-level promotion의 일부가 아닌 shipping adjustment는 item-level promotion으로 취급된다. order-level promotion의 예: "20% off and free shipping".

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| order/price-adjustments/price-adjustment/promotion-id | Name | |
| order/price-adjustments/price-adjustment/promotion-id | Description | |
| N/A | Type | This picklist value depends on the promotion level: • Order-level—This value is set to Header. • Item-level—This value is set to SplitLine. |
| N/A | OrderId | This value is set to the ID of the associated original Order record. |
| N/A | AdjustmentCauseId | This value is set to the ID of the associated Promotion record. |

### OrderDeliveryGroup

통합은 주문 데이터의 각 shipment(B2C Commerce에서 LineItemGroup이라고도 함)마다 OrderDeliveryGroup 레코드를 생성한다. prorated delivery amount를 포함하는 return·cancellation 같은 주문 변경의 경우, proration은 변경 대상 OrderItem을 포함하는 OrderDeliveryGroup을 고려한다. 예: 각각 여러 OrderItem을 가진 세 OrderDeliveryGroup이 있는 주문에서, 서로 다른 OrderDeliveryGroup의 OrderItem 두 개를 반품하면, 그 두 OrderDeliveryGroup의 총 delivery charge를 사용한다. 이를 OrderItem 가격으로 그 OrderDeliveryGroup 내 OrderItem에 prorate한다. shipping refund는 두 반품 OrderItem의 prorated delivery amount와 같다. return은 세 번째 OrderDeliveryGroup의 delivery charge를 고려하지 않는다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| order/customer/customer-email | EmailAddress | |
| order/shipments/shipment/shipping-address/city | DeliverToCity | |
| order/shipments/shipment/shipping-address/country-code | DeliverToCountry | Usage depends on whether state and country/territory picklists are enabled in Salesforce. • Picklists not enabled—This value is set to order/shipments/shipment/shipping-address/country-code. It must be a standard 2-character ISO country/territory code. • Picklists enabled—This value is set to the picklist integration value corresponding to the country/territory code that matches order/shipments/shipment/shipping-address/country-code. |
| order/shipments/shipment/shipping-address/country-code | DeliverToCountryCode | This value is only set when state and country/territory picklists are enabled on your org. order/shipments/shipment/shipping-address/country-code must match the country/territory code of an entry in the Salesforce country/territory picklist. |
| order/shipments/shipment/shipping-address/title, order/shipments/shipment/shipping-address/first-name, order/shipments/shipment/shipping-address/last-name, and order/shipments/shipment/shipping-address/suffix | DeliverToName | If the DeliveryGroup contains gift certificate items, this value will contain the buyer_name: firstName + ' ' + lastName. Otherwise, the shipping address name is set to: order/shipments/shipment/shipping-address/title +" "+ order/shipments/shipment/shipping-address/first-name +" "+ order/shipments/shipment/shipping-address/last-name +" "+ order/shipments/shipment/shipping-address/suffix. |
| order/shipments/shipment/shipping-address/postal-code | DeliverToPostalCode | |
| order/shipments/shipment/shipping-address/state-code | DeliverToState | Usage depends on whether state and country/territory picklists are enabled in Salesforce. • Picklists not enabled—This value is set to order/shipments/shipment/shipping-address/state-code. It must be a standard 2-character ISO state or province code. • Picklists enabled—This value is set to the picklist integration value corresponding to the state code that matches order/shipments/shipment/shipping-address/state-code. |
| order/shipments/shipment/shipping-address/state-code | DeliverToStateCode | This value is only set when state and country/territory picklists are enabled on your org. order/shipments/shipment/shipping-address/state-code must match the state code of an entry in the Salesforce country/territory picklist. |
| order/shipments/shipment/shipping-address/address1, order/shipments/shipment/shipping-address/address2, and order/shipments/shipment/shipping-address/address3 | DeliverToStreet | This value is set to order/shipments/shipment/shipping-address/address1 +" "+ order/shipments/shipment/shipping-address/address2 +" "+ order/shipments/shipment/shipping-address/address3. |
| order/shipments/shipment/shipping-address/phone | PhoneNumber | |
| order/shipments/shipment/gift | IsGift | This value is only populated if order/shipments/shipment/gift=true. |
| order/shipments/shipment/gift-message | GiftMessage | This value is only populated if order/shipments/shipment/gift=true. |
| order/shipments/shipment/shipping-method | OrderDeliveryMethodId | This value is set to the ID of the OrderDeliveryMethod record whose ReferenceNumber field matches the order/shipments/shipment/shipping-method value in the order data. |
| N/A | OrderId | This value is set to the ID of the associated original Order record. |
| order/shipments/shipment/custom_attribute | custom_attribute_name | If the Salesforce OrderDeliveryGroup object has a custom field matching a custom attribute on the storefront shipment object, the value is copied to the OrderDeliveryGroup record. If the Salesforce OrderDeliveryGroupSummary object also has a matching custom field, it's copied to both records. If a custom field is non-nillable, then order data must include a value for the corresponding custom attribute. If the value is missing, the integration fails. |

### OrderItem

주문의 TaxLocaleType이 Net이면, 통합은 각 OrderItem 레코드마다 OrderItemTaxLineItem 레코드도 생성한다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| order/product-lineitems/product-lineitem/lineitem-text | Description | If the record represents a shipping charge, this value is set to Shipping. Otherwise, it's set to order/product-lineitems/product-lineitem/lineitem-text. |
| N/A | Type | If the record represents a shipping charge, this picklist value is set to Delivery Charge. Otherwise, it's set to Order Product. |
| order/product-lineitems/product-lineitem/quantity | Quantity | |
| order/product-lineitems/product-lineitem/net-price | TotalLineAmount | |
| N/A | LineNumber | Each order's OrderItems that represent physical products and non-shipping charges are assigned sequential LineNumber values starting at 1. OrderItems that represent shipping charges are assigned sequential LineNumber values starting at 1000, so in order detail views, they appear after all other OrderItems. Each delivery group has it's own line numbering, so there may be multiple OrderItems with LineNumber: 1 if there are multiple delivery groups. Order Management doesn't directly support kit items or line item options, so it stores them as OrderItem records with their own LineNumbers. An OrderItem's LineNumber is unrelated to its order line position in B2C Commerce. |
| order/product-lineitems/product-lineitem/base-price or order/product-lineitems/product-lineitem/net-price and order/product-lineitems/product-lineitem/quantity | UnitPrice | The integration calculates this value to a limited number of decimal places and includes it for reference. Because the calculation can introduce small rounding errors, Order Management doesn't use this value for any processing. The calculation formula depends on the tax locale type of the order: • Net Taxation—base-price • Gross Taxation—net-price / quantity |
| order/product-lineitems/product-lineitem/base-price or order/product-lineitems/product-lineitem/gross-price and order/product-lineitems/product-lineitem/quantity | GrossUnitPrice | The integration calculates this value to a limited number of decimal places and includes it for reference. Because the calculation can introduce small rounding errors, Order Management doesn't use this value for any processing. The calculation formula depends on the tax locale type of the order: • Net Taxation—gross-price / quantity • Gross Taxation—base-price |
| order/product-lineitems/product-lineitem/base-price | ListPrice | This value is only set if the Optional Price Books feature is enabled. It's needed when the OrderItem has no associated PriceBookEntry. |
| N/A | OrderId | This value is set to the ID of the associated original Order record. |
| N/A | OrderDeliveryGroupId | This value is set to the ID of the associated OrderDeliveryGroup record. |
| N/A | PricebookEntryId | This value is set to the ID of the associated PriceBookEntry record. If the Optional Price Books feature is enabled, this value isn't set. |
| N/A | Product2Id | This value is set to the ID of the associated Product2 record. |
| order/product-lineitems/product-lineitem/custom_attribute, order/giftcertifcate-lineitems/giftcertifcate-lineitem/custom_attribute, or order/shipping-lineitems/shipping-lineitem/custom_attribute | custom_attribute_name | If the Salesforce OrderItem object has a custom field matching a custom attribute on the storefront product-lineitem object, giftcertificate-lineitem object, or shipping-lineitem object, the value is copied to the OrderItem record. If the Salesforce OrderItemSummary object also has a matching custom field, it's copied to both records. If a custom field is non-nillable, then order data must include a value for the corresponding custom attribute. If the value is missing, the integration fails. |

> PDF 원문 그대로(오타 보존): XSD Value 컬럼의 `order/giftcertifcate-lineitems/giftcertifcate-lineitem`은 PDF에서 `giftcertifcate`로 철자 오기되어 있다(원문 보존). Notes 컬럼에서는 `giftcertificate-lineitem object`로 정상 표기됨.

### OrderItemAdjustmentLineItem

OrderItemAdjustmentLineItem 레코드는 OrderItem 레코드에 promotion이 적용된 것을 나타낸다. 따라서 OrderItem 레코드는 자신에게 적용되는 각 promotion마다 연관 OrderItemAdjustmentLineItem 레코드를 하나씩 가진다. 주문의 TaxLocaleType이 Net이면, 통합은 각 OrderItemAdjustmentLineItem 레코드마다 OrderItemTaxLineItem 레코드도 생성한다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| order/product-lineitems/product-lineitem/product-id and order/price-adjustments/price-adjustment/lineitem-text | Name | This value is set to order/product-lineitems/product-lineitem/product-id + "-" + order/price-adjustments/price-adjustment/lineitem-text. |
| price-adjustments/price-adjustment/net-price | Amount | |
| price-adjustments/price-adjustment/tax | TotalTaxAmount | |
| order/price-adjustments/price-adjustment/lineitem-text | PromotionText | |
| N/A | OrderItemId | This value is set to the ID of the OrderItem record that the adjustment applies to. |
| N/A | OrderAdjustmentGroupId | For an order-level promotion, or an item-level promotion that applies to multiple OrderItems, this value is set to the ID of the parent OrderAdjustmentGroup record. For an item-level promotion that applies to only one OrderItem, it isn't set. |
| N/A | AdjustmentCauseId | This value is set to the ID of the associated Promotion record. |

### OrderItemTaxLineItem

주문의 TaxLocaleType이 Net이면, 통합은 주문 내 각 OrderItem과 OrderItemAdjustmentLineItem 레코드마다 OrderItemTaxLineItem 레코드를 생성한다. 주문의 TaxLocaleType이 Gross이면, OrderItemTaxLineItem 레코드를 전혀 생성하지 않는다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| See notes | Name | This value is generated based on the Type of the associated OrderItem or OrderItemAdjustmentLineItem record and, if applicable, the StockKeepingUnit of the associated Product2: • OrderItem: – Order Product—StockKeepingUnit + " - Tax" – Delivery Charge—"Delivery Charge - Tax" • OrderItemAdjustmentLineItem: – Product—StockKeepingUnit + " - Adjustment Tax" – Shipping—"Delivery Charge - Adjustment Tax" |
| N/A | Type | This picklist value is always set to Estimated. |
| order/product-lineitems/product-lineitem/tax | Amount | |
| order/product-lineitems/product-lineitem/tax-rate | Rate | |
| order/order-date | TaxEffectiveDate | |
| N/A | OrderItemId | If the tax applies to an OrderItem record, this value is set to the ID of that order item. If it applies to an OrderItemAdjustmentLineItem record, this value is set to the ID of the order item that the adjustment applies to. |
| N/A | OrderItemAdjustmentLineItemId | This value is only set for tax that applies to an OrderItemAdjustmentLineItem record. |

### Payment

`order/payments/payment/transaction-type` 값이 sale 또는 capture이면, 통합은 그 트랜잭션에 대해 Payment 레코드를 생성한다. 값이 auth로 시작하면 PaymentAuthorization 레코드를 생성한다. 이 검사는 대소문자를 구분하지 않는다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| N/A | PaymentGatewayId | This value is set to the ID of the PaymentGateway record whose ExternalReference value matches the processor ID value of the order payment instrument associated with the order payment transaction. |
| N/A | PaymentGatewayLogId | This value is set to the ID of the PaymentGatewayLog record associated with the payment. |
| order/payments/payment/amount | Amount | |
| N/A | ProcessingMode | This picklist value is always set to External. |
| N/A | Status | This picklist value is always set to Processed. |
| order/payments/payment/transaction-id | GatewayRefNumber | This value isn't required in the order data. The default value is null. |
| order/customer/customer-email | Email | |
| order/order-date | Date | |
| order/payments/payment/transaction-type | Type | |
| order/billing-address/phone | Phone | |
| N/A | PaymentGroupId | This value is set to the ID of the PaymentGroup record associated with the payment. |
| N/A | AccountId | This value is set to the ID of the Account or Person Account record associated with the shopper. |
| N/A | PaymentMethodId | This value is set to the ID of the CardPaymentMethod or DigitalWallet record associated with the payment. |
| order/currency | CurrencyIsoCode | This value is only set if the Salesforce org has Multicurrency enabled. |
| order/payments/payment/custom_attribute or a custom attribute on the payment type | custom_attribute_name | If the Salesforce Payment object has a custom field matching a custom attribute on the storefront payment type or order payment transaction object, the value is copied to the Payment record. If a custom field is non-nillable, then order data must include a value for the corresponding custom attribute. If the value is missing, the integration fails. |

### PaymentAuthorization

`order/payments/payment/transaction-type` 값이 auth로 시작하면, 통합은 그 트랜잭션에 대해 PaymentAuthorization 레코드를 생성한다. 값이 sale 또는 capture이면 Payment 레코드를 생성한다. 이 검사는 대소문자를 구분하지 않는다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| N/A | PaymentGatewayId | This value is set to the ID of the PaymentGateway record whose ExternalReference value matches the processor ID value of the order payment instrument associated with the order payment transaction. |
| N/A | PaymentGatewayLogId | This value is set to the ID of the PaymentGatewayLog record associated with the payment authorization. |
| order/payments/payment/amount | Amount | |
| N/A | ProcessingMode | This picklist value is always set to External. |
| N/A | Status | This picklist value is always set to Processed. |
| order/payments/payment/transaction-id | GatewayRefNumber | This value isn't required in the order data. The default value is null. |
| (custom attribute) order/payments/payment/authCode | GatewayAuthCode | The default Payment Transaction object in B2C Commerce doesn't include an authCode attribute. To use it, add it as a custom attribute and populate it before sending the order data. If you name it authCode, the integration automatically copies it to the GatewayAuthCode field. |
| N/A | PaymentGroupId | This value is set to the ID of the PaymentGroup record associated with the payment authorization. |
| N/A | AccountId | This value is set to the ID of the Account or Person Account record associated with the shopper. |
| N/A | PaymentMethodId | This value is set to the ID of the CardPaymentMethod or DigitalWallet record associated with the payment authorization. |
| order/currency | CurrencyIsoCode | This value is only set if the Salesforce org has Multicurrency enabled. |
| order/payments/payment/custom_attribute or a custom attribute on the payment type | custom_attribute_name | If the Salesforce PaymentAuthorization object has a custom field matching a custom attribute on the storefront payment type or order payment transaction object, the value is copied to the PaymentAuthorization record. If a custom field is non-nillable, then order data must include a value for the corresponding custom attribute. If the value is missing, the integration fails. |

### PaymentGatewayLog

(PDF에 도입 설명 없음 — 표만 존재.)

> PaymentGatewayLog 객체에는 custom field를 추가할 수 없으나, 통합은 `order/payments/payment`의 `authCode`·`avsResultCode`·`approvalStatus` custom attribute를 인식해 아래 standard field로 복사한다(위 "커스텀 데이터 통합" 참조).

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| N/A | PaymentGatewayId | This value is set to the ID of the PaymentGateway record whose ExternalReference value matches the processor ID value of the order payment instrument associated with the order payment transaction. |
| N/A | InteractionStatus | This picklist value is always set to Success. |
| order/payments/payment/transaction-type | InteractionType | The default value is Authorization. |
| (custom attribute) order/payments/payment/authCode | GatewayAuthCode | The default Payment Transaction object in B2C Commerce doesn't include an authCode attribute. To use it, add it as a custom attribute and populate it before sending the order data. If you name it authCode, the integration automatically copies it to the GatewayAuthCode field. |
| (custom attribute) order/payments/payment/avsResultCode | GatewayAvsCode | The default Payment Transaction object in B2C Commerce doesn't include an avsResultCode attribute. To use it, add it as a custom attribute and populate it before sending the order data. If you name it avsResultCode, the integration automatically copies it to the GatewayAvsCode field. |
| (custom attribute) order/payments/payment/approvalStatus | GatewayResultCode | The default Payment Transaction object in B2C Commerce doesn't include an approvalStatus field. To use it, add it as a custom attribute and populate it before sending the order data. If you name it approvalStatus, the integration automatically copies it to the GatewayResultCode field. |

### PaymentGroup

(PDF에 도입 설명 없음 — 표만 존재.)

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| N/A | SourceObjectId | This value is set to the ID of the original Order record that the payments in the group apply to. |
| order/currency | CurrencyIsoCode | This value is only set if the Salesforce org has Multicurrency enabled. |

### PendingOrderSummary

PendingOrderSummary는 **High Scale Orders에서만** 사용된다. ZOS로 ingest되어 Salesforce 레코드 생성을 대기 중인 주문 데이터를 보유한다. Salesforce UI의 Pending Order Summaries 페이지에서 PendingOrderSummary를 import하면 Summary 레코드를 포함한 레코드 생성을 트리거할 수 있다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| N/A | AccountId | This value is set to the ID of the Account or Person Account record that represents the shopper. |
| N/A | BillToContactId | This value is set to the ID of the Contact record that represents the shopper. When using person accounts, this value isn't set. In that case, access shopper contact information via the Account instead of the Contact. |
| order/customer/customer-email | BillingEmailAddress | |
| order/billing-address/phone | BillingPhoneNumber | |
| order/currency | CurrencyIsoCode | This value is only set if the Salesforce org has Multicurrency enabled. |
| catalog/catalog-id and order/order-no | ExternalReferenceIdentifier | Used internally to prevent duplicate records. This value is case-sensitive. On creation, this value is set to B2C realm ID + "_" + B2C instance ID + "@" + catalog/catalog-ID + "@" + order/order-no. |
| all price, adjustment, and tax values | GrandTotalAmount | Total amount, including adjustments and tax, of the order. |
| order/order-no | OrderNumber | |
| order/order-date | OrderedDate | |
| all data | Payload | This field contains the entire order data payload. |
| N/A | PayloadType | The datatype of the Payload. Possible values are JSON_GZIP or JSON_RAW. |
| catalog/catalog-id | SalesChannelId | This value is set to the ID of the SalesChannel record whose SalesChannelName field matches the catalog/catalog-id in the order data packet. |
| N/A | SalesStoreId | This value is set to the ID of the RetailStore or WebStore record associated with the order. |
| order/billing-address/first-name and order/billing-address/last-name | ShopperName | This value is set to order/billing-address/first-name +" "+ order/billing-address/last-name. |

> PDF 원문 그대로(대소문자 불일치 보존): ExternalReferenceIdentifier 계산식의 `catalog/catalog-ID`는 PDF에서 **대문자 ID**로 표기되어 있다. 타 객체(Order의 OrderManagementReferenceIdentifier, WebStore의 ExternalReference)에서는 소문자 `catalog/catalog-id`다.

### PricebookEntry

Salesforce Order Management는 PricebookEntry 객체를 사용하지 않는다. 단, OrderItem 객체가 PricebookEntryId 값을 요구하므로 각 Product2마다 PriceBookEntry 레코드를 생성한다.

> Note: Optional Price Books 기능을 켜면, Order Management는 주문 데이터로 생성한 product 레코드에 price book entry를 생성하지 않는다. 기능을 끄면 price book entry를 수동으로 추가해야 한다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| N/A | Pricebook2Id | This value is set to the ID of the Pricebook2 record for the standard price book. |
| N/A | Product2Id | This value is set to the ID of the associated Product2 record. |
| order/product-lineitems/product-lineitem/base-price | UnitPrice | This value is only set when the PriceBookEntry record is created. It isn't updated when an OrderItem associated with the same Product2 is created. It isn't used for any calculations in Order Management. |
| order/currency | CurrencyIsoCode | This value is only set if the Salesforce org has Multicurrency enabled. |

### Product2

통합은 먼저 주문 데이터의 product-id 값과 일치하는 ProductCode를 가진 Product2를 검색해 product를 식별한다. 없으면 product-id 값과 일치하는 StockKeepingUnit을 가진 Product2를 찾는다. 그래도 없으면 Product2 레코드를 생성한다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| order/product-lineitem/lineitem-text | Description | |
| order/product-lineitem/product-name | Name | |
| order/product-lineitem/product-id | StockKeepingUnit | If the product is an electronic gift certificate, this value is set to eGiftCertificate. |
| order/product-lineitem/product-id | ProductCode | If the product is an electronic gift certificate, this value is set to eGiftCertificate. |
| N/A | IsActive | The default value is true. |

### Promotion

Promotion 객체 정보는 Loyalty Management Developer Guide 참조.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| order/price-adjustments/price-adjustment/promotion-id | Name | |
| order/price-adjustments/price-adjustment/lineitem-text | DisplayName | |
| order/price-adjustments/price-adjustment/lineitem-text | Description | |
| N/A | StartDate | The default value is the current date. |
| N/A | IsCommercePromotion | The default value is true. |
| N/A | IsActive | The default value is true. |

### SalesChannel

통합은 B2C Commerce site ID를 Salesforce SalesChannel과 연결한다.

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| site/site-id | Description | |
| site/site-id | SalesChannelName | |
| N/A | Type | |

### WebStore

통합은 주문의 통화·locale과 일치하는 WebStore를 찾고, 필요하면 생성한다. 주문 데이터에 나타나는 통화·locale 조합마다 WebStore 하나를 연결한다. 예: US 주문을 USD로 지원하는 site 하나, UK 주문을 파운드·유로로 지원하고 프랑스 주문을 유로로 지원하는 두 번째 site가 있으면, 이를 표현하는 네 개의 Web Store를 생성한다.

```
// 구조 예시 — 실제 원본 다이어그램 아님 (PDF 원문 목록 그대로)
USD - en_US
GBP - en_GB
EUR - en_GB
EUR - fr_FR
```

| B2C Commerce XSD Value | Salesforce Object Field | Notes |
|---|---|---|
| catalog/catalog-id and order/currency | Name | For a single-currency org, this value is the order catalog/catalog-id, for example SiteGenesis. For a multicurrency org, it's the order catalog/catalog-id plus the currency associated with the WebStore, for example SiteGenesis USD. |
| order/currency | CurrencyIsoCode | This value is only set if the Salesforce org has Multicurrency enabled. |
| order/customer-locale | DefaultLanguage | The order locale ID must be a valid value for a WebStore DefaultLanguage. It can't be default. |
| order/taxation | DefaultTaxLocaleType | This value is set to Net or Gross based on the value of order/taxation. If using Net taxation, this value is set to Net. If using Gross taxation, this value is set to Gross. If the value isn't set, then the default value is Net. |
| order/order-no and catalog/catalog-id | ExternalReference | This value is set to B2C realm ID + "_" + B2C instance ID + "@" + catalog/catalog-id. |
| N/A | LocationId | The system creates a location and sets this value to its ID. It sets the new location's LocationType field to Virtual and its ExternalReference field to null. If you include any custom validations for the Location object, they must account for these values. |
| order/currency | SupportedCurrencies | This value is only set if the Salesforce org has Multicurrency enabled. It matches the value of CurrencyIsoCode. |
| order/customer-locale | SupportedLanguages | The order locale ID must be a valid value for a WebStore DefaultLanguage. It can't be default. It matches the value of DefaultLanguage. |
| N/A | Type | This value is always set to B2CE. |

---

## 관련 노트
- [[Order Management 개요와 데이터 모델]]
- [[Order Management — Import·Fulfillment·Taxation]]
- [[CommercePayments Namespace]]
- [[Bulk API 2.0]]
