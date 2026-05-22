---
tags: [sobject-reference, standard-objects, b2b-commerce, webcart, order-summary, buyer, commerce]
source: object_reference.pdf (v67.0 Summer '26)
created: 2026-05-22
aliases: [B2B Commerce Objects, WebCart, CartItem, OrderSummary, BuyerGroup, B2B상거래, 전자상거래]
---

# B2B Commerce Objects — B2B 상거래 오브젝트

> Object Reference v67.0 Ch6 — B2B Commerce(전자상거래) 도메인 표준 오브젝트 목록

---

## Buyer(구매자) 계열

| Object | 설명 |
|---|---|
| `BuyerAccount` | 구매자 계정 (Account-BuyerAccount 연결) |
| `BuyerCriteria` | 구매자 선별 조건 |
| `BuyerGroup` | 구매자 그룹 (가격표·카탈로그 공유 단위) |
| `BuyerGroupBuyerCriteria` | 구매자 그룹-구매자 조건 연결 |
| `BuyerGroupMember` | 구매자 그룹 멤버 |
| `BuyerGroupPricebook` | 그룹별 가격표 연결 |
| `BuyerGroupRelatedObject` | 구매자 그룹 관련 Object |
| `GuestBuyerProfile` | 비회원 구매자 프로필 |

---

## Cart(카트) 계열

| Object | 설명 |
|---|---|
| `WebCart` | 전자상거래 카트 (SalesTransaction 구현체) |
| `CartCheckoutSession` | 카트 체크아웃 세션 |
| `CartDeliveryGroup` | 배송 그룹 |
| `CartDeliveryGroupMethod` | 배송 방법 |
| `CartDeliveryGroupMethodAdj` | 배송 방법 가격 조정 |
| `CartItem` | 카트 항목 (제품 라인) |
| `CartItemAttribute` | 카트 항목 속성 |
| `CartItemPriceAdjustment` | 카트 항목 가격 조정 (PriceAdjustmentItem 구현) |
| `CartTax` | 카트 세금 |
| `CartValidationOutput` | 카트 유효성 검사 결과 |
| `WebCartAdjustmentGroup` | 카트 전체 가격 조정 그룹 (PriceAdjustmentGroup 구현) |

---

## Order Summary(주문 요약) 계열

| Object | 설명 |
|---|---|
| `OrderSummary` | 주문 요약 — B2B/B2C Commerce의 주문 관리 핵심 Object |
| `OrderSummaryAdditionalInfo` | 주문 요약 추가 정보 |
| `OrderSummaryRelationship` | 주문 요약 관계 |
| `OrderSummaryRoutingSchedule` | 주문 요약 라우팅 스케줄 |
| `PendingOrderSummary` | 대기 중인 주문 요약 |
| `OrderAdjustmentGroup` | 주문 가격 조정 그룹 |
| `OrderAdjustmentGroupSummary` | 주문 가격 조정 그룹 요약 |
| `OrderChangeLog` | 주문 변경 로그 |
| `OrderChgReasonCategMap` | 주문 변경 사유 카테고리 매핑 |
| `OrderDeliveryGroup` | 주문 배송 그룹 |
| `OrderDeliveryGroupSummary` | 주문 배송 그룹 요약 |
| `OrderDeliveryMethod` | 주문 배송 방법 |
| `OrderItemAdjustmentLineItem` | 주문 항목 가격 조정 라인 |
| `OrderItemAdjustmentLineSummary` | 주문 항목 가격 조정 라인 요약 |
| `OrderItemGroup` | 주문 항목 그룹 |
| `OrderItemRecipient` | 주문 항목 수령인 |
| `OrderItemRelationship` | 주문 항목 관계 |
| `OrderItemSummary` | 주문 항목 요약 |
| `OrderItemSummaryChange` | 주문 항목 요약 변경 |
| `OrderItemSummaryRelationship` | 주문 항목 요약 관계 |
| `OrderItemTaxLineItem` | 주문 항목 세금 라인 |
| `OrderItemTaxLineItemSummary` | 주문 항목 세금 라인 요약 |
| `OrderItemType` | 주문 항목 타입 피클리스트 |
| `OrderPaymentSummary` | 주문 결제 요약 |
| `OrderPaymentSummaryReference` | 주문 결제 요약 참조 |
| `OrderAction` | 주문 작업 |
| `OSAsyncChgCompletedEvent` | 주문 요약 비동기 변경 완료 이벤트 |

---

## FulfillmentOrder(이행 주문) 계열

| Object | 설명 |
|---|---|
| `FulfillmentOrder` | 이행 주문 — 배송·픽업 처리 단위 |
| `FulfillmentOrderItemAdjustment` | 이행 주문 항목 가격 조정 |
| `FulfillmentOrderItemTax` | 이행 주문 항목 세금 |
| `FulfillmentOrderLineItem` | 이행 주문 라인 항목 |

---

## ReturnOrder(반품 주문) 계열

| Object | 설명 |
|---|---|
| `ReturnOrder` | 반품 주문 |
| `ReturnOrderItemAdjustment` | 반품 주문 항목 가격 조정 |
| `ReturnOrderItemTax` | 반품 주문 항목 세금 |
| `ReturnOrderLineItem` | 반품 주문 라인 항목 |
| `ReturnOrderOwnerSharingRule` | ReturnOrder 소유자 공유 규칙 |

---

## Shipment · Inventory 계열

| Object | 설명 |
|---|---|
| `Shipment` | 배송 정보 |
| `ShipmentItem` | 배송 항목 |
| `ShippingCarrier` | 배송사 |
| `ShippingCarrierMethod` | 배송사 방법 |
| `ShippingConfigurationSet` | 배송 설정 집합 |
| `ShippingConfigSetProduct` | 배송 설정 집합 제품 |
| `ShippingRateArea` | 배송 요율 지역 |
| `ShippingRateGroup` | 배송 요율 그룹 |
| `StandardShippingRate` | 표준 배송 요율 |
| `InventoryItemReservation` | 재고 항목 예약 |
| `InventoryReservation` | 재고 예약 |
| `PickTicket` | 픽 티켓 (창고 피킹) |
| `PickTicketAssignment` | 픽 티켓 배정 |
| `PickTicketProduct` | 픽 티켓 제품 |
| `ProductItem` | 제품 재고 항목 |
| `ProductItemTransaction` | 제품 재고 트랜잭션 |
| `ProductRequest` | 제품 요청 (FSL/B2B 공용) |
| `ProductRequestLineItem` | 제품 요청 라인 |
| `ProductRequired` | 필요 제품 (WorkOrder 연결) |
| `ProductTransfer` | 제품 이전 |
| `ProductConsumed` | 소모된 제품 |
| `Location` | 창고·서비스 위치 |
| `LocationGroup` | 위치 그룹 |
| `LocationGroupAssignment` | 위치 그룹 배정 |
| `LocationShippingCarrierMethod` | 위치-배송사 방법 연결 |
| `LocationTrustMeasure` | 위치 신뢰 측정 |
| `AssociatedLocation` | 연결된 위치 |
| `LocationWaitlist` | 위치 대기자 목록 |
| `LocationWaitlistedParty` | 대기자 목록 파티 |
| `LocWaitlistMsgTemplate` | 대기자 목록 메시지 템플릿 |

---

## Payment(결제) 계열

| Object | 설명 |
|---|---|
| `Payment` | 결제 |
| `PaymentAuthAdjustment` | 결제 인증 조정 |
| `PaymentAuthorization` | 결제 승인 |
| `PaymentCredit` | 결제 크레딧 |
| `PaymentCreditLinePayment` | 크레딧 라인 결제 |
| `PaymentCreditTransaction` | 크레딧 트랜잭션 |
| `PaymentGateway` | 결제 게이트웨이 |
| `PaymentGatewayLog` | 결제 게이트웨이 로그 |
| `PaymentGatewayProvider` | 결제 게이트웨이 공급자 |
| `PaymentGroup` | 결제 그룹 |
| `PaymentInitiationSource` | 결제 시작 소스 |
| `PaymentIntent` | 결제 의도 |
| `PaymentIntentEvent` | 결제 의도 이벤트 |
| `PaymentLineInvoice` | 결제 라인-인보이스 연결 |
| `PaymentLink` | 결제 링크 |
| `PaymentLinkEvent` | 결제 링크 이벤트 |
| `PaymentMethod` | 결제 수단 |
| `CardPaymentMethod` | 카드 결제 수단 |
| `AlternativePaymentMethod` | 대체 결제 수단 |
| `DigitalWallet` | 디지털 지갑 |
| `SavedPaymentMethod` | 저장된 결제 수단 |
| `SavedPaymentMethodEvent` | 저장된 결제 수단 이벤트 |
| `MerchantAccount` | 판매자 계정 |
| `MerchantAccountEvent` | 판매자 계정 이벤트 |
| `MerchAccPaymentMethodSet` | 판매자 계정 결제 수단 집합 |
| `MerchAccPaymentMethodType` | 판매자 계정 결제 수단 타입 |
| `GtwyProvPaymentMethodType` | 게이트웨이 공급자 결제 수단 타입 |
| `Refund` | 환불 |
| `RefundLinePayment` | 환불 라인 결제 |
| `CreditMemo` | 크레딧 메모 |
| `CreditMemoAddressGroup` | 크레딧 메모 주소 그룹 |
| `CreditMemoInvApplication` | 크레딧 메모 인보이스 적용 |
| `CreditMemoLine` | 크레딧 메모 라인 |

---

## Invoice(인보이스) 계열

| Object | 설명 |
|---|---|
| `Invoice` | 인보이스 |
| `InvoiceAddressGroup` | 인보이스 주소 그룹 |
| `InvoiceBatchRun` | 인보이스 일괄 실행 |
| `InvoiceBatchRunCriteria` | 인보이스 일괄 실행 조건 |
| `InvoiceBatchRunRecovery` | 인보이스 일괄 실행 복구 |
| `InvoiceDocument` | 인보이스 문서 |
| `InvoiceLine` | 인보이스 라인 |
| `BillingBatchScheduler` | 청구 일괄 스케줄러 |
| `BillingPeriodItem` | 청구 기간 항목 |
| `BillingPolicy` | 청구 정책 |
| `BillingSchedule` | 청구 스케줄 |
| `BillingScheduleGroup` | 청구 스케줄 그룹 |
| `BillingTreatment` | 청구 처리 방식 |
| `BillingTreatmentItem` | 청구 처리 방식 항목 |
| `PaymentSchedule` | 결제 스케줄 |
| `PaymentScheduleItem` | 결제 스케줄 항목 |
| `PaymentSchedulePolicy` | 결제 스케줄 정책 |
| `PaymentScheduleTreatment` | 결제 스케줄 처리 방식 |
| `PaymentScheduleTreatmentDtl` | 결제 스케줄 처리 방식 상세 |
| `PymtSchdDistributionMethod` | 결제 스케줄 배분 방법 |
| `PaymentTerm` | 결제 조건 |
| `PaymentTermItem` | 결제 조건 항목 |

---

## Promotions(프로모션) 계열

| Object | 설명 |
|---|---|
| `Promotion` | 프로모션 |
| `PromotionLineItemRule` | 프로모션 라인 항목 규칙 |
| `PromotionMarketSegment` | 프로모션 마켓 세그먼트 |
| `PromotionQualifier` | 프로모션 자격 조건 |
| `PromotionSegment` | 프로모션 세그먼트 |
| `PromotionSegmentBuyerGroup` | 프로모션 세그먼트 구매자 그룹 |
| `PromotionSegmentSalesStore` | 프로모션 세그먼트 판매 스토어 |
| `PromotionTarget` | 프로모션 타겟 |
| `PromotionTier` | 프로모션 티어 |
| `Coupon` | 쿠폰 |
| `CouponCodeRedemption` | 쿠폰 코드 사용 |
| `PurchaseQuantityRule` | 구매 수량 규칙 |
| `PriceAdjustmentSchedule` | 가격 조정 스케줄 |
| `PriceAdjustmentTier` | 가격 조정 티어 |
| `PriceAdjustmentGroupShape` | 가격 조정 그룹 형태 |
| `PriceAdjustmentItemShape` | 가격 조정 항목 형태 |
| `PriceProtectionExecution` | 가격 보호 실행 |
| `PriceProtectExecLineItem` | 가격 보호 실행 라인 |
| `PriceProtectionTerm` | 가격 보호 조건 |

---

## Commerce Entitlement(상거래 권한)

| Object | 설명 |
|---|---|
| `CommerceEntitlementBuyerGroup` | 상거래 권한-구매자 그룹 |
| `CommerceEntitlementPolicy` | 상거래 권한 정책 |
| `CommerceEntitlementPolicyShare` | 상거래 권한 정책 공유 |
| `CommerceEntitlementProduct` | 상거래 권한 제품 |

---

## 세금·Sales Store·Subscription

| Object | 설명 |
|---|---|
| `TaxEngine` | 세금 엔진 |
| `TaxEngineInteractionLog` | 세금 엔진 인터랙션 로그 |
| `TaxEngineProvider` | 세금 엔진 공급자 |
| `TaxGeoConfig` | 세금 지리 설정 |
| `TaxPolicy` | 세금 정책 |
| `TaxRate` | 세금 요율 |
| `TaxTreatment` | 세금 처리 방식 |
| `SalesChannel` | 판매 채널 |
| `SalesStoreCatalog` | 판매 스토어 카탈로그 |
| `StoreIntegratedService` | 스토어 통합 서비스 |
| `SalesTransactionType` | 판매 트랜잭션 타입 |
| `SalesTransactionShape` | 판매 트랜잭션 형태 |
| `SalesTransactionItemShape` | 판매 트랜잭션 항목 형태 |
| `SalesTrxnItemRelationShape` | 판매 트랜잭션 항목 관계 형태 |
| `SalesWorkQueueSettings` | 판매 작업 큐 설정 |
| `Seller` | 판매자 |
| `Customer` | 고객 (Subscription Management) |
| `LegalEntity` | 법인 (청구 주체) |

---

## SOQL 패턴

```apex
// WebCart와 CartItem 조회
List<WebCart> carts = [
    SELECT Id, Name, Status, TotalAmount, CurrencyIsoCode,
           (SELECT Id, Name, Product2Id, Product2.Name,
                   Quantity, TotalPrice, Type
            FROM CartItems)
    FROM WebCart
    WHERE Status = 'Active'
    AND OwnerId = :UserInfo.getUserId()
    WITH USER_MODE
];

// OrderSummary + OrderItemSummary 조회
List<OrderSummary> orders = [
    SELECT Id, OrderNumber, Status, TotalAmount,
           BillingCity, BillingCountry,
           (SELECT Id, ProductCode, Quantity,
                   UnitPrice, TotalLineAmount
            FROM OrderItemSummaries)
    FROM OrderSummary
    WHERE Status != 'Cancelled'
    ORDER BY CreatedDate DESC
    LIMIT 50
    WITH USER_MODE
];
```

---

## 관련 노트

- [[6 Standard Objects]] — Ch6 전체 도메인 카탈로그 (상위 파일)
- [[Core CRM Objects]] — Account·Order (기본 Order)
- [[5 Object Interfaces]] — PriceAdjustmentGroup·SalesTransaction 인터페이스
- [[PriceAdjustmentGroup]] — B2B Commerce 가격 조정 그룹 상세
- [[SalesTransaction]] — 판매 트랜잭션 인터페이스 상세
- [[Field Service Objects]] — FSL ProductItem·ProductRequest 공용
