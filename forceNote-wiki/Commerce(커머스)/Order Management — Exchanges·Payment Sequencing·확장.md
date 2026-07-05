---
tags: [commerce, order-management, exchanges, rma, payment-sequencing, lightning-components, apex-extension, connect-api]
source: order_management_developer_guide_html.pdf (Version 66.0, Spring '26, Tier 2) — Exchanges with RMA Returns(p.53-56)·Payment Sequencing(p.57-61)·Lightning Components·Order on Behalf Of(p.62)·Expand Data Sources for Return Insights(p.63-64)·API End-of-Life(p.65); CLI 현행화 근거(Tier 2): sfdx_cli_reference "Migrate sfdx-Style Commands to sf"(sfdx deprecated) + Commerce "Extensions" guide(sf plugins install @salesforce/commerce)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.order_management_developer_guide.meta/order_management_developer_guide/
created: 2026-06-20
aliases: [Exchanges RMA, Preview Cart, Submit Cart, Payment Sequencing, EnsureFunds, EnsureRefunds, ProductExpandService, commerce_ordermanagement, Order on Behalf Of, Return Insights, 교환, 결제 시퀀싱, 반품 인사이트]
---

# Order Management — Exchanges·Payment Sequencing·확장

> 불균등 교환(RMA)을 위한 **Preview/Submit Cart API**, 다중 결제 수단 분배를 제어하는 **Payment Sequencing**(Apex 예제 2종), OM Lightning 컴포넌트·외부 결제 OBO, Return Insights용 **ProductExpandService** 확장. (`order_management_developer_guide_html.pdf` p.53-65)

> 📍 허브: [[Order Management 개요와 데이터 모델]]

> **EDITIONS** — Exchanges/Preview/Submit Cart 기능은 Enterprise, Unlimited, Developer Editions에서 사용 가능. Exchange 워크플로우 구성에는 org에 **SalesforceOrderManagementGrowth** 라이선스가 필요하다.

---

## API Framework for Exchanges with RMA Returns

### 개요 · EnsureFunds/EnsureRefunds

교환(exchange) 기능을 확장해 고객 서비스 담당자(CSR)가 **불균등(uneven) 제품 교환**과 **이미 이행된(already-fulfilled) 주문의 제품 교환**을 처리할 수 있게 한다.

- CSR이 uneven 또는 post-fulfillment 교환을 하기 전, 조직은 **exchange flow**를 구현해야 한다. Spring '24 release 이후 exchanges invocable actions로 교환을 구성할 수 있다.
- 교환용 Connect API 2개: **Preview Cart to Exchange Order**, **Submit Cart to Exchange Order**. 두 API 각각에 대한 invocable action도 존재한다.
- 교환용 객체 2개: **OrderPaymentSummary**, **OrderPaymentSummaryReference**.

**완전 구현된 exchange flow 흐름:** order summary를 가져와 교환 정보를 수집 → return order에서 반품할 항목 선택 → 새 항목으로 cart 생성 → exchange order 실행(return order 항목을 cart 항목으로 교환) → 최종 summary가 추가 자금 필요/환불 필요/even exchange 여부를 표시.

> PDF에 흐름 다이어그램이 있을 가능성이 있으나(p.53), pdftotext가 잡은 텍스트가 없어 본 wiki에는 위 텍스트 설명만 둔다. 다이어그램은 추측 재현하지 않는다.

**EnsureFunds / EnsureRefunds 연동 — `isReservedBalanceAmountConsidered`**

Exchanges는 EnsureFunds와 EnsureRefunds 둘 다 지원한다. exchanges 구현 후, EnsureFunds 또는 EnsureRefunds를 쓰는 기존 flow에 대해 **`isReservedBalanceAmountConsidered = true`** 로 설정한다.

| 항목 | 내용 |
|---|---|
| EnsureFunds 적용 범위 | SourceProcess(Standard, OrderOnBehalfOf, Exchange)와 **무관하게 어떤 OrderSummary에든** 호출 가능. EnsureFunds·ApplyFunds 로직이 이제 공유된(shared) OrderPaymentSummaries를 고려한다. |
| `isReservedBalanceAmountConsidered` (EnsureFunds·ApplyFunds 계약) | optional boolean. EnsureFunds 로직이 shared OrderPaymentSummary의 ReservedBalanceAmount를 고려하는지 여부를 표시. |
| `isReservedBalanceAmountConsidered` (EnsureRefunds 계약) | optional boolean. EnsureRefunds 로직이 OrderPaymentSummary의 ReservedBalanceAmount를 고려하는지 표시. EnsureRefunds는 자식 exchange order가 reserve에 보유한 reserved balance amount를 고려해 exchange Order Summary를 완전히 펀딩한다. reserved balance amount는 payment record에 있고, **초과 balance만** EnsureRefunds 명령의 일부로 환불된다. |

- EnsureFunds 또는 EnsureRefunds flow를 쓰면, `isReservedBalanceAmountConsidered` 플래그를 포함하도록 flow를 업데이트한다.
- 추가/초과 자금에 대한 자금 계산 공식은 동일하게 유지된다. 모든 capture·refund·pending refund·return은 OrderSummary Relationship tree의 OrderPaymentSummaries에 관련된다.

> EnsureFunds/EnsureRefunds의 결제 캡처·환불 메커니즘 본체는 [[CommercePayments Namespace]] 참조. 비동기 호출 `ConnectApi.OrderSummary.ensureFundsAsync` / `ensureRefundsAsync` 시그니처는 [[ConnectApi Namespace 개요]] 참조.

**새 알고리즘 실행 순서 (excess funds 계산):**

```text
// PDF 원문 발췌 — 알고리즘 실행 순서
1. Order Summary에 관련된 모든 Order Summary ID를 가져온다.
   Note: OrderSummaryRelationship에서 root OrderSummary를 가져온 다음,
         그 root를 가진 모든 AssociatedOrderSummaries를 찾는다.
2. 모든 Order Payment Summary 엔티티를 가져온다.
3. 모든 OrderSummary total을 가져온다.
→ 이후 알고리즘은 기존 공식을 사용해 roll-up 필드를 기반으로 excess funds를 계산한다.
```

### Preview Cart for an Exchange Order

exchange 요청 제출 **전에** exchange order의 balance state를 미리보기하는 것이 권장된다. 특히 uneven exchange에 어떤 기능이 필요한지 판단하는 데 도움이 된다.

**Uneven exchange의 세 가지 결과 (공식):**

| 결과 | 조건 |
|---|---|
| Additional funds needed | `WebCart.GrandTotalAmount() > ReturnOrder.GrandTotalAmount()` |
| Refund needed | `WebCart.GrandTotalAmount() < ReturnOrder.GrandTotalAmount()` |
| Even exchange | `WebCart.GrandTotalAmount() = ReturnOrder.GrandTotalAmount()` |

**Preview 전제조건:**

- **`orderSummaryId` (mainOrderSummaryId)**, **`exchangeCartId`**, **`referenceId` (returnOrderId)** 를 null도 empty도 아니게 설정. 유효한 Salesforce ID여야 하고 유효한 엔티티를 나타내야 한다.
- `referenceId`는 **ReturnOrder** 타입이어야 한다. return order의 StatusCategory는 **activated**여야 한다. ReturnOrderId(referenceId)는 mainOrderSummaryId에 속해야 한다.
- 최소 cart는 **최소 1개 product와 1개 delivery group**을 포함해야 한다. cart가 OrderSummary와 같은 account에 속하는지 확인: `OrderSummary.Account` equals `cart.Account`.

**Preview 응답 예시 (JSON):**

```json
// PDF 원문 발췌 — Preview Cart 응답 (페이지 경계 걸침 재구성)
{
    "changeBalances": {
    "grandTotalAmount": -47.49,
    "totalAdjDeliveryAmtWithTax": 12.94
    "totalAdjDistAmountWithTax": 0,
    "totalAdjProductAmtWithTax": -60.44,
    "totalAdjustedDeliveryAmount": 11.99,
    "totalAdjustedDeliveryTaxAmount": 0.95,
    "totalAdjustedProductAmount": -55.96,
    "totalAdjustedProductTaxAmount": -4.48,
    "totalAdjustmentDistributedAmount": 0,
    "totalAdjustmentDistributedTaxAmount": 0,
    "totalAmount": -43.97,
    "totalExcessFundsAmount": 47.49,
    "totalFeeAmount": 0,
    "totalFeeTaxAmount": 0,
    "totalRefundableAmount": 47.49,
    "totalRequiredFundsAmount": 0,
    "totalTaxAmount": -3.52
    },
    "errors": [],
    "orderSummaryId": "1OsSB000000UdWz0AK",
    "success": true
    }
```

> ⚠️ `"totalAdjDeliveryAmtWithTax": 12.94` 뒤에 콤마가 없다 — **PDF 원문의 오타이며 그대로 보존**했다. 실제 호출 시 응답에는 콤마가 있을 것으로 본다.

### Submit Cart for an Exchange Order

cart preview 후 exchange를 제출한다. submit 생성 시 고려사항이 존재한다.

**Submit 전제조건:** submit order 생성 전 **`orderSummaryId` (mainOrderSummaryId)**, **`exchangeCartId`**, **`referenceId`** 가 다음을 만족하는지 검증한다.

- null 또는 empty가 아님 (Aren't null or empty)
- 유효한 Salesforce ID임 (Are valid Salesforce IDs)
- 유효한 엔티티를 나타냄 (Represent a valid entity)

추가 조건:

- `referenceId`는 **ReturnOrder** 타입이어야 한다. ReturnOrder의 StatusCategory는 **Activated 또는 Pending** 이어야 한다. (Preview는 activated만, Submit은 Activated 또는 Pending — 차이 주의)
- ReturnOrderId는 mainOrderSummaryId에 속해야 한다.
- exchange용 cart는 **최소 1개 product와 최소 1개 delivery group**이 필요하다. cart는 OrderSummary와 같은 account에 속해야 한다: `OrderSummary.Account` equals `cart.Account`.

**Input Fields for the Submit Cart to Exchange Order API Representation** (6 data row × 4 col):

| Name | Type | Description | Required or Optional |
|---|---|---|---|
| `mainOrderSummaryId` | String | ID of the main Order Summary. | Required |
| `exchangeCartId` | String | ID of the cart used for adding items to the exchange order. | Required |
| `referenceId` | String | Polymorphic Reference ID, which must be related to the main Order Summary. Only Return Order ID is supported. | Required |
| `paymentInfoList` | PaymentInfoInputRepresentationList | List of payment information if additional funds are needed for the new exchange order. (하위 필드 아래 참조) | Optional |
| `paymentInfoItems` | `Aray[PaymentInfoInputRepresentation]` [sic — 원문 오타, 정정: `Array[PaymentInfoInputRepresentation]`] | List of payment information if additional funds are needed for the new exchange order. | Optional |
| `SequenceOrderPaymentSummaryInputList` | Sequence | Ordered list of OrderPaymentSummaries and the reserved balance amounts to apply them to. (하위 필드 아래 참조) | Optional |

**`paymentInfoList` 하위 — PaymentInfoInputRepresentation 필드:**

```text
// PDF 원문 발췌 — PaymentInfoInputRepresentation
PaymentInfoInputRepresentation
  String        paymentAuthorizationId
  Array[String] paymentIds
  String        paymentMethodId          (optional)
  String        lastPaymentGatewayLogId  (optional)   // 원문 오타: "lastPaymentGatewayLogId(opitona)l"
  String        name                     (optional)
```

**`SequenceOrderPaymentSummaryInputList` 하위:**

```text
// PDF 원문 발췌 — SequenceOrderPaymentSummaryInputList
Array[SequenceOrderPaymentSummaryInputRepresentation] sequences
        // 원문 오타: "ar[yA SequenceOrderPaymentSummaryInputRepresentation] sequences"
  String orderPaymentSummaryId  (required)
  Number amount                 // zero 또는 미지정 시 전체 Order Payment Summary balance 사용
  Order Number                  // exchange가 지정된 order number로 생성되면, random guide를
                                //   order number로 사용해 exchange 생성
                                // (원문: "Order Number: If the exchange is created in the order
                                //   number specified, it creates an exchange with random guide
                                //   as the order number")
```

**Submit 응답 예시 (JSON):**

```json
// PDF 원문 발췌 — Submit Cart 응답 (페이지 경계 걸침 재구성)
{
    "changeBalances": {
    "grandTotalAmount": -47.49,
    "totalAdjDeliveryAmtWithTax": 12.94
    "totalAdjDistAmountWithTax": 0,
    "totalAdjProductAmtWithTax": -60.44,
    "totalAdjustedDeliveryAmount": 11.99,
    "totalAdjustedDeliveryTaxAmount": 0.95,
    "totalAdjustedProductAmount": -55.96,
    "totalAdjustedProductTaxAmount": -4.48,
    "totalAdjustmentDistributedAmount": 0,
    "totalAdjustmentDistributedTaxAmount": 0,
    "totalAmount": -43.97,
    "totalExcessFundsAmount": 47.49,
    "totalFeeAmount": 0,
    "totalFeeTaxAmount": 0,
    "totalRefundableAmount": 47.49,
    "totalRequiredFundsAmount": 0,
    "totalTaxAmount": -3.52
    },
    "errors": [],
    "exchangeOrderSummaryId": "1OsSB000000UdYb",
    "orderSummaryId": "1OsSB000000UdWz0AK",
    "success": true
    }
```

> Preview 응답 대비 차이: Submit 응답에는 추가로 **`"exchangeOrderSummaryId": "1OsSB000000UdYb"`** 필드가 있다. (PDF 원문 JSON에 동일하게 `totalAdjDeliveryAmtWithTax` 뒤 콤마 누락 — 그대로 보존.)

---

## Payment Sequencing

### 개요 · Default Sequence (Funds/Refunds)

여러 결제 수단(payment methods)을 포함하는 주문에 대해 ensure funds 또는 refunds를 할 때, 금액을 결제 수단에 적용하는 **순서(sequence)를 제어**할 수 있다.

- 예: 주문이 gift card로 일부 결제됐으면, 원래 결제 금액 분배 방식과 무관하게 **gift card를 먼저 환불**할 수 있다.
- 예: 서로 다른 fulfillment group이 이행되는 사이에 주문이 수정되면, 미래 주문 이행이 취소될 경우 gift card에서 부분 결제 금액을 먼저 capture하고 **전체 gift card 금액을 보존**할 수 있다.
- 기본 로직은 OrderPaymentSummary 금액에 금액을 매칭하는 것에 기반한다.

**Default Payment Sequence to Ensure Funds** — sequence 지정 없이 Ensure Funds 호출 시, OrderSummary에 속한 OrderPaymentSummaries 간에 다음 로직으로 자금을 분배한다. 단, 여러 order payment summary가 **동일한 BalanceAmount** 값을 가지면 선택 순서는 무작위(random)다.

1. invoice를 검사하고, OrderSummary에 연결된 모든 order payment summary의 총 BalanceAmount를 초과하지 않는지 확인. BalanceAmount가 invoice balance와 같으면, 그 order payment summary의 자금을 invoice에 적용.
   - 정확히 일치하는 것이 없으면, **BalanceAmount가 가장 큰** order payment summary의 자금을 invoice에 적용.
2. invoice에 여전히 balance가 있으면, captured funds가 남지 않을 때까지 step 1 반복.
   - invoice에 여전히 balance가 있고 authorized amount가 남은 invoice balance와 정확히 일치하는 order payment summary가 있으면, 그 order payment summary에서 capture·apply.
   - 정확히 일치하는 것이 없으면, **authorized amount가 가장 큰** order payment summary에서 capture·apply.
3. invoice에 여전히 balance가 있으면, 전체 invoice balance가 보장될 때까지 step 2 반복.

**Default Payment Sequence to Ensure Refunds** — sequence 지정 없이 Ensure Refunds 호출 시, OrderSummary에 속한 OrderPaymentSummaries 간에 다음 로직으로 환불을 분배한다. 단, 여러 OrderPaymentSummaries가 동일 금액이면 선택 순서 무작위다.

- **credit memo가 지정되면**, 해당 invoice에 적용된 captured amount를 가진 OrderPaymentSummaries 식별.
  - captured amount가 credit memo amount와 일치하는 것이 있으면 그 payment에 환불 적용.
  - 정확히 일치하는 것이 없으면, credit memo amount보다 큰 captured amount를 가진 OrderPaymentSummaries를 찾는다. 있으면 **가장 작은 것**에 환불 적용.
  - 더 큰 금액이 없으면, captured amount 기준 **큰 것부터 작은 것 순**으로 OrderPaymentSummaries를 순회하며 완전히 적용될 때까지 환불 적용.
- **excess funds amount가 지정되면**, 어떤 invoice에도 적용되지 않은 captured amount를 가진 OrderPaymentSummaries 식별.
  - captured amount가 excess funds amount와 일치하는 것이 있으면 그 payment에 환불 적용.
  - 정확히 일치하는 것이 없으면, excess funds amount보다 큰 captured amount를 가진 OrderPaymentSummaries를 찾는다. 있으면 **가장 작은 것**에 환불 적용.
  - 더 큰 금액이 없으면, captured amount 기준 큰 것부터 작은 것 순으로 순회하며 완전히 적용될 때까지 환불 적용.

### Specify the Sequence (isAllowPartial)

Ensure Funds 또는 Ensure Refunds 호출 시, **`isAllowPartial`** 과 **`sequences`** 값을 포함해 금액 분배를 시퀀싱할 수 있다.

| 파라미터 | 동작 |
|---|---|
| `isAllowPartial` | 지정한 분배 금액이 전체 금액을 커버하지 못할 때 동작 제어. **`true`** 면 남은 금액은 skip(credit memo에 속하면 credit memo에 그대로 남음). **`false`** 면 남은 금액에 default 로직 적용. |
| `sequences` | 금액과 OrderPaymentSummaries를 짝지은 **순서 있는 목록**. 각 금액은 짝지어진 OrderPaymentSummary에 펀딩/환불된다. 프로세스는 이 목록을 순서대로 순회하며 전체 금액을 펀딩/환불하면 멈춘다. |

### Apex 예제 — Ensure Funds

Ensure Funds를 `isAllowPartial`·`sequences` 값을 생성하는 코드로 래핑해 자체 default payment sequence를 구현할 수 있다. 아래 예시는 다른 결제 유형보다 **DigitalWallet 결제 수단에서 먼저 펀딩**을 시도한다.

- OrderSummary에 연결된 모든 OrderPaymentSummaries 수집. record ID의 **key prefix**로 payment type 식별.
- 전체 금액이 충족될 때까지 DigitalWallet인 각 OrderPaymentSummary에서 $10 펀딩.
- 금액이 남으면 default 로직에 따라 펀딩.
- 각 type의 key prefix에 연결된 금액을 바꿔 먼저 펀딩할 payment type 커스터마이즈 가능. 목록이 순서가 있으므로 예: 각 DigitalWallet에서 $10, 그다음 각 CardPaymentMethod에서 $10, 그다음 남은 금액에 default 로직.

```apex
// PDF 원문 발췌 — Custom Default Sequence to Ensure Funds
public class CreateSequenceOPSEnsureFundsInvocable {

      @InvocableMethod(label='Ensure Funds with Sequence OrderPaymentSummaries')
      public static void createSequenceOrderPaymentSummaryList(List<String> invoiceIds) {

            // DigitalWallet Key Prefix: 1DW
            // CardPaymentMethod Key Prefix: 03O
            // AlternativePaymentMethod Key Prefix: 8Z7
            Map<String, Double> sequencePrefixAndAmounts= new Map<String, Double>();
            sequencePrefixAndAmounts.put('1DW', 10.0);
            sequencePrefixAndAmounts.put('03O', 0.0);
            sequencePrefixAndAmounts.put('8Z7', 0.0);

            // Set is allowed partial to true/false
            Boolean isAllowPartial = true;

            Map<String, Double> sequenceOPSAndAmounts = new Map<String, Double>();

        ConnectApi.EnsureFundsAsyncInputRepresentation ensureFundsInput = new
ConnectApi.EnsureFundsAsyncInputRepresentation();
        ensureFundsInput.invoiceId = invoiceIds.get(0);
        ensureFundsInput.sequences = new
List<ConnectApi.SequenceOrderPaymentSummaryInputRepresentation>();
        ensureFundsInput.isAllowPartial = isAllowPartial;

        // Get the Id and ReferenceEntityID (OrderSummaryID) From the Invoice
        Invoice inv = [SELECT Id, ReferenceEntity.Id FROM Invoice WHERE Id = :invoiceIds
Limit 1];
        string orderSummaryId = inv.ReferenceEntityId;

        // Get list of OrderPaymentSummaries from the orderSummaryID
        List<OrderPaymentSummary> orderPaymentSummaries = [SELECT Id, PaymentMethod.Id,
Type FROM OrderPaymentSummary WHERE OrderSummary.Id = :orderSummaryId];

        Map<Id, OrderPaymentSummary> orderPaymentSummariesMap = new Map<Id,
OrderPaymentSummary>(orderPaymentSummaries);

        //Loop through the sequence of payment methods prefixes
        for(String keyPrefix: sequencePrefixAndAmounts.keySet()){
        // Loop through orderPaymentSummaries creating a map of sequence
            for(OrderPaymentSummary ops: orderPaymentSummaries){
                string paymentMethodId = ops.PaymentMethod.Id;
                if(paymentMethodId.startsWith(keyPrefix)){
                    sequenceOPSAndAmounts.put(ops.Id,
sequencePrefixAndAmounts.get(keyPrefix));
                    orderPaymentSummariesMap.remove(ops.Id);
                }
          }
        }

        // Create the list of sequences to add to EnsureFundsAsync input
        for(String orderPaymentSummarySequence: sequenceOPSAndAmounts.keySet()){
            ConnectApi.SequenceOrderPaymentSummaryInputRepresentation request = new
ConnectApi.SequenceOrderPaymentSummaryInputRepresentation();
            request.amount = sequenceOPSAndAmounts.get(orderPaymentSummarySequence);
            request.orderPaymentSummaryId = orderPaymentSummarySequence;
            ensureFundsInput.sequences.add(request);
        }

        ConnectApi.EnsureFundsAsyncOutputRepresentation result =
ConnectApi.OrderSummary.ensureFundsAsync(orderSummaryId, ensureFundsInput);

      }

}
```

### Apex 예제 — Ensure Refunds

Ensure Refunds를 `isAllowPartial`·`sequences` 값 생성 코드로 래핑해 자체 default payment sequence를 구현할 수 있다. 아래 예시는 다른 결제 유형보다 **DigitalWallet 결제 수단에 먼저 환불**을 시도한다. (이 예시는 `isAllowPartial = false` 로 partial refund를 항상 disallow 한다.)

- OrderSummary에 연결된 모든 OrderPaymentSummaries 수집. record ID의 key prefix로 payment type 식별.
- 전체 금액이 환불될 때까지 DigitalWallet인 각 OrderPaymentSummary에 $10 환불.
- 금액이 남으면 default 로직에 따라 환불.
- key prefix에 연결된 금액을 바꿔 먼저 환불할 payment type 커스터마이즈 가능. 순서 있는 목록이므로 예: 각 DigitalWallet에 $10, 그다음 각 CardPaymentMethod에 $10, 그다음 남은 금액에 default 로직.

```apex
// PDF 원문 발췌 — Custom Default Sequence to Ensure Refunds
public class CreateSequenceOPSRefundsInvocable {

      @InvocableMethod(label='EnsureRefunds with Sequenced OrderPaymentSummaries')
      public static void createSequenceOrderPaymentSummaryList(List<String> creditMemoIds)
{

            // When applying refunds, prefer DigitalWallets
            // DigitalWallet            Key Prefix: 1DW
            // CardPaymentMethod        Key Prefix: 03O
            // AlternativePaymentMethod Key Prefix: 8Z7
            Map<String, Double> sequencePrefixAndAmounts= new Map<String, Double>();
            sequencePrefixAndAmounts.put('1DW', 10.0);
            sequencePrefixAndAmounts.put('03O', 0.0);
            sequencePrefixAndAmounts.put('8Z7', 0.0);

        // Always disallow partial refunds -- if the sequence doesn't cover the full refund,
  then apply the default logic to the remaining amount
         Boolean isAllowPartial = false;

          Map<String, Double> sequenceOPSAndAmounts = new Map<String, Double>();

        ConnectApi.EnsureRefundsAsyncInputRepresentation ensureRefundsInput = new
ConnectApi.EnsureRefundsAsyncInputRepresentation();
        ensureRefundsInput.creditMemoId = creditMemoIds.get(0);
        ensureRefundsInput.sequences = new
List<ConnectApi.SequenceOrderPaymentSummaryInputRepresentation>();
        ensureRefundsInput.isAllowPartial = isAllowPartial;

        // Get the Id and ReferenceEntityID (OrderSummaryID) From the Credit Memo
        CreditMemo cm = [SELECT Id, ReferenceEntity.Id FROM CreditMemo WHERE Id =
:creditMemoIds Limit 1];
        string orderSummaryId = cm.ReferenceEntityId;

           // Get list of OrderPaymentSummaries from the orderSummaryID
           List<OrderPaymentSummary> orderPaymentSummaries = [SELECT Id, PaymentMethod.Id,
Type     FROM OrderPaymentSummary WHERE OrderSummary.Id = :orderSummaryId];

        Map<Id, OrderPaymentSummary> orderPaymentSummariesMap = new Map<Id,
OrderPaymentSummary>(orderPaymentSummaries);

        //Loop through the sequence of payment methods prefixes
        for(String keyPrefix: sequencePrefixAndAmounts.keySet()){
            // Loop through orderPaymentSummaries creating a map of sequence
            for(OrderPaymentSummary ops: orderPaymentSummaries){
                string paymentMethodId = ops.PaymentMethod.Id;
                if(paymentMethodId.startsWith(keyPrefix)){
                    sequenceOPSAndAmounts.put(ops.Id,
sequencePrefixAndAmounts.get(keyPrefix));
                    orderPaymentSummariesMap.remove(ops.Id);
                }
            }
        }

        // Create the sequence list and add it to the EnsureRefundsAsync input
        for(String orderPaymentSummarySequence: sequenceOPSAndAmounts.keySet()){
                ConnectApi.SequenceOrderPaymentSummaryInputRepresentation request = new
ConnectApi.SequenceOrderPaymentSummaryInputRepresentation();
                request.amount = sequenceOPSAndAmounts.get(orderPaymentSummarySequence);
                request.orderPaymentSummaryId = orderPaymentSummarySequence;
                ensureRefundsInput.sequences.add(request);
        }

        ConnectApi.EnsureRefundsAsyncOutputRepresentation result =
ConnectApi.OrderSummary.ensureRefundsAsync(orderSummaryId, ensureRefundsInput);

     }

}
```

### Edge Cases (4종, by design)

Spring '26에서 Ensure Funds용 Payment Sequencing 출시가 일부 예상치 못한 고객 동작을 도입했으나, 이 동작들은 **의도된(by design)** 것이다. Ensure Funds 사용 시 마주칠 수 있으니 검토한다.

1. **Zero amount and unspecified amounts provided for order payment summary result in same behavior.** zero를 제공하는 것은 amount를 지정하지 않은 것과 동일하게 취급된다. sequence의 어떤 Order Payment Summary에 zero를 amount로 제공하면 Ensure Funds는 amount 미지정으로 해석한다. 따라서 시스템은 엄격히 zero funds를 적용하는 대신 **가능한 한 많은 available funds를 가져오려 시도**한다.
2. **Reserved balance amount doesn't respect sequencing or amount limits.** reserved balance amount는 해당 order payment summary의 order summary에만 배타적으로 묶여 있고 다른 소스보다 먼저 전액 적용되므로 이는 의도된 동작이다. 다른 order summaries는 이 reserved portion을 사용할 수 없고, 제공한 sequence나 amount limit과 무관하게 **이 reserved portion이 먼저 소비**된다.
3. **Sequence not strictly reflected when `isAllowPartial = false`.** 의도된 동작이다. sequence가 제공되고 `isAllowPartial`이 false면, 시스템은 먼저 sequence에 따라 funds 적용을 시도한다. funds가 부족하면 **default strategy로 fallback**한다. 시스템은 올바른 최종 funded amount를 보장한다. invoice page의 sequence는 입력 sequence와 정확히 일치하지 않을 수 있다.
4. **Amount parameter limits pre-captured and available to capture funds.** 의도된 동작이다. amount parameter는 order payment summary에 대한 **pre-captured와 available to capture funds 양쪽을 합친 total cap**으로 취급된다.

---

## Lightning Components

Salesforce Order Management는 표준 Lightning components를 포함한다.

> 이 챕터는 아래 2개 컴포넌트만 본문에 정의한다. 다른 컴포넌트 목록은 PDF에 없다(추측 추가 금지).

### Order Product Summaries by Recipient

- **용도:** Order Summary record page에 order product details를 표시. Salesforce Order Management에서 사용 가능.
- order product summary 필드는 OrderDeliveryGroup 객체 page layout의 **Order Product Summaries related list**로 정의된다.
- order summary details page의 컬럼 수정: Order Summary page layout이 아니라 **Order Delivery Group page layout**의 related list를 편집한다.
- order delivery group summary record 표시 제어용 **custom filter** 생성 가능.

### Order Summary Totals

- **용도:** Order Summary record page에 financial totals를 표시. Salesforce Order Management에서 사용 가능.
- **panel title**과 표시할 값을 커스터마이즈 가능.

---

## Order on Behalf Of for External Payments

non-tokenized payments로 payment flow를 지원하려면 **External Payment Mode flow**를 구성한다. 이 flow는 tokenized payment flow를 우회하고 **Payment Authorize**를 직접 호출한다.

**절차:**

1. external payments용 flow 생성 전, **Order on Behalf Of**가 올바르게 구성됐는지 확인. (See *Configure Order on Behalf Of*.)
2. external payments용 flow 생성을 시작하려면 **External Payments Package**를 다운로드.
3. flow global variable **`externalPaymentMode`** 를 `true`로 설정.
4. payment 관리를 위해 Order on Behalf Of UI flow에 screen을 추가. 제공되는 것을 쓰거나 직접 페이지를 생성한다. 직접 만들면 담당자가 payment details와 billing address를 capture할 수 있게 보장.
5. flow에 이 screen 추가 후, 그 screen의 outputs에서 **PaymentAuthorize** invocable을 호출. flow에서 PaymentAuthorize용 input 구성.
6. 마지막으로 flow **Update Records** action으로 webcart의 billing details를 업데이트. 새 payment screen에서 BillingDetails 입력, PaymentAuthorize Invocable에서 PaymentMethod와 PaymentGroup 입력.

> PaymentAuthorize 등 invocable action의 입출력 표준은 [[Actions API]] 참조. 결제 게이트웨이 authorize/capture 메커니즘은 [[CommercePayments Namespace]] 참조.

---

## Expand Data Sources for Return Insights

### ProductExpandService 확장

**Extensions**는 Apex를 사용해 B2B·B2C Commerce storefront를 구동하는 기능을 커스터마이즈하는 메커니즘이다. extension을 구현하는 custom Apex class를 **extension provider**라 한다. Product Expand API 기능을 확장/오버라이드하려면 **Commerce Order Management Product Expand Extension**을 사용한다.

> Commerce storefront 확장 포인트 일반론·다른 B2B 확장 포인트 비교는 [[CommerceExtension Namespace]] 참조. 이 노트는 OM Return Insights용 `commerce_ordermanagement.ProductExpandService` 확장에 한정한다.

**참조 클래스/메서드 (네임스페이스 `commerce_ordermanagement`):**

| 클래스 | 멤버 | 시그니처/반환 |
|---|---|---|
| `ProductExpandService` (base class) | `returnReasons(ProductExpandRequest)` | returns `ProductExpandResponse` — 제품의 return reasons를 가져옴 |
| `ProductExpandRequest` | `getProducts()` | returns `List<ProductData>` |
| `ProductExpandResponse` | `setProductList(List<ProductData>)`, `setSucceed(Boolean)` | void |
| `ProductData` | `setReturnReasons(List<Reason>)` | void |
| `Reason` | `setReason(String)` | void |
| Extension point name | `Commerce_Domain_OrderManagement_Product` | — |

**(1) base class 확장** — 시작하려면 base class `commerce_ordermanagement.ProductExpandService`를 확장한다.

```apex
// PDF 원문 발췌 — extension provider 골격
public class ProductExpandServiceSample extends commerce_ordermanagement.ProductExpandService
 {
    // Extension code.
}
```

**(2) `returnReasons` 메서드 전체 교체** — `returnReasons` 메서드를 오버라이드(제품의 return reasons를 가져오는 데 사용). 이 예시는 전체 메서드를 custom logic으로 교체 — ProductExpandRequest에서 product data 추출, return reasons 설정, ProductExpandResponse 처리. external service에서 return reasons를 가져올 수도 있다.

```apex
// PDF 원문 발췌 — returnReasons 전체 교체 (response 변수 외부 선언 가정)
// Extract product data from the request with custom logic and get the product's return
reasons from an external service.

public override commerce_ordermanagement.ProductExpandResponse
returnReasons(commerce_ordermanagement.ProductExpandRequest productExpandRequest) {

             // Create a product expand response without the default processing.

        List<commerce_ordermanagement.ProductData> productList = new
List<commerce_ordermanagement.ProductData>();

        List<commerce_ordermanagement.Reason> returnReasons = new
List<commerce_ordermanagement.Reason>();

             commerce_ordermanagement.Reason reason1 = new commerce_ordermanagement.Reason();
             commerce_ordermanagement.Reason reason2 = new commerce_ordermanagement.Reason();

        //Set the reason in the response. You can also fetch the reasons from external
systems and set it.
        reason1.setReason('Size is big');
        reason2.setReason('Too big');

             returnReasons.add(reason1);
             returnReasons.add(reason2);

             for(commerce_ordermanagement.ProductData productData :
productExpandRequest.getProducts()) {
            // Set the return reasons for the products in the request
            productData.setReturnReasons(returnReasons);
            productList.add(productData);
        }

            response.setProductList(productList);
            response.setSucceed(true);

            // Process the product expand response with more custom logic.

            // Return the processed product expand response.
            return response;
      }
```

> PDF 원문 코드에 `response` 변수 선언이 본문에 보이지 않는다 — **외부 선언 가정**(원문 그대로 발췌). 실제 구현 시 메서드 내/외부에 `commerce_ordermanagement.ProductExpandResponse response`를 선언해야 한다.

**(3) `super()` 호출 패턴** — 전체 메서드를 custom logic으로 교체하는 대신 `super()` 메서드로 base method를 호출할 수 있다. `super()` 호출 전후에 custom logic을 삽입할 수 있다.

```apex
// PDF 원문 발췌 — super() 호출 패턴
public override commerce_ordermanagement.ProductExpandResponse
returnReasons(commerce_ordermanagement.ProductExpandRequest productExpandRequest) {
        // Get the product expand response using the default implementation of the
returnReasons method. Although returnReasons is called unmodified, we can supply it with
a modified version of the request.
        commerce_ordermanagement.ProductExpandResponse productExpandResponse =
super.returnReasons(productExpandRequest);

            // Modify the product return reasons response with custom logic.

            // Return the modified transactional return reasons response.
            return productExpandResponse;
      }
```

**(4) external service에서 return reasons 가져오기** — custom private method를 정의한다.

```apex
// PDF 원문 발췌 — external service 헬퍼 메서드 시그니처
private Map<String, ProductReturnReasonsDataFromExternalService>
getReturnReasonsFromExternalService(Set<String> productIds){
        // Custom logic.
    }
```

**extension class가 할 수 있는 작업:**

- 각 base class method의 전체 default 구현을 custom logic으로 교체.
- base class method의 default 구현 호출 **전에** custom logic 추가.
- base class method의 default 구현 호출 **후에** custom logic("customer logic") 추가.
- custom method와 class 추가.

> org에 자체 Apex class를 추가하는 방법은 Salesforce Help의 *Adding an Apex Class* 참조.

### extension provider 등록 · CLI 매핑

**(A) web store 생성** — custom extension provider로 extension slot을 채우기 전 web store를 생성한다. extension class를 등록(register)하고, extension class를 B2C 또는 D2C Commerce store에 매핑(map)한다. web store가 없으면 Developer Console에서 dummy web store를 생성한다. Debug → Execute Anonymous Window를 열고 이 코드를 붙여넣는다.

```apex
// PDF 원문 발췌 — dummy web store 생성 (Execute Anonymous)
WebStore store = new WebStore(
      Name = 'SiteGenesis',
      // Either NET or GROSS
      DefaultTaxLocaleType = 'NET',
      // Format expected is instanceId@siteName; example abc_123@SiteGenesis
      ExternalReference = 'bblz_stg@SiteGenesis',
      Type = 'B2CE'
    );
insert store;
```

Execute를 클릭한다. web store ID를 가져오려면 이 SOQL query를 실행한다.

```sql
-- PDF 원문 발췌 — web store ID 조회
SELECT Id FROM WebStore LIMIT 1
```

반환 값에서 web store ID를 선택한다. web store의 ID를 EPN에 매핑한다.

**(B) CLI / 플러그인으로 등록·매핑** — extension class 등록·매핑은 **Salesforce CLI**와 **Salesforce Commerce plug-in**으로 한다. extension 관리는 최신 버전 Salesforce CLI를 사용한다.

> [!warning] deprecated CLI — `sfdx` 실행파일·`sfdx`-스타일 콜론 명령은 비권장. 후속 권장: `sf` (v2) CLI
> 아래 PDF 원문 코드블록은 **`sfdx` (v7) 실행파일과 `sfdx`-스타일 콜론 명령(`sfdx commerce:extension:register` 등)**을 쓴다. **`sfdx` CLI는 2023년 4월 deprecated**됐고 **`sfdx`-스타일 명령 레퍼런스는 2024-06-12에 제거**됐다. 지원되는 후속은 **`sf` (v2) CLI**다. 또한 플러그인 패키지명도 아래의 `@salesforce-commerce`가 아니라 **`@salesforce/commerce`**가 올바른 현행 이름이다. 구 sfdx 명령을 그대로 실행하면 sf-only 환경에서 동작하지 않는다.
>
> **현행(`sf`) 형태 — 아래 sfdx 블록 대신 이것을 사용:**
> ```bash
> # 현행 Salesforce CLI (sf v2) — Commerce plug-in 설치 및 extension 등록/매핑
> # plug-in 설치 (패키지명 @salesforce/commerce)
> sf plugins install @salesforce/commerce
>
> # Register an extension class
> sf commerce extension register --target-org user@abc.com --apex-class-name ProductExpandServiceSample --extension-point-name Commerce_Domain_OrderManagement_Product --registered-extension-name ProductExpandServiceSample
>
> # Map an extension class  (store-ID는 web store ID)
> sf commerce extension map --registered-extension-name ProductExpandServiceSample --store-id <store_id>
>
> # Unmap an extension class
> sf commerce extension unmap --registered-extension-name ProductExpandServiceSample --store-id <store_id>
> ```
> 근거: [Migrate sfdx-Style Commands to sf](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_migrate.htm) · [Commerce Extensions guide](https://developer.salesforce.com/docs/commerce/salesforce-commerce/guide/extensions.html) (Tier 2)

plug-in 설치 (아래는 PDF 원문 발췌 — **deprecated `sfdx` 형태, 참고용 보존**. 실행은 위 `sf` 블록 사용):

```bash
# PDF 원문 발췌 (deprecated sfdx CLI — 위 sf 블록으로 대체) — Commerce plug-in 설치 및 extension 등록/매핑
# plug-in 설치
sfdx plugins:install @salesforce-commerce

# Register an extension class
sfdx commerce:extension:register --targetusername user@abc.com --apex-class-name ProductExpandServiceSample --extension-point-name Commerce_Domain_OrderManagement_Product --registered-extension-name ProductExpandServiceSample

# Map an extension class  (store-ID는 web store ID)
sfdx commerce:extension:map --registered-extension-name ProductExpandServiceSample --store-id <store_id>

# Unmap an extension class
sfdx commerce:extension:unmap --registered-extension-name ProductExpandServiceSample --store-id <store_id>
```

---

## API End-of-Life Policy

- Salesforce는 각 API version을 **첫 release일로부터 최소 3년간** 지원하기로 약속한다. API의 품질과 성능 향상을 위해, 3년 넘은 version은 때때로 더 이상 지원되지 않는다.
- Salesforce는 deprecation 예정인 API version을 사용하는 고객에게 **version 지원 종료 최소 1년 전에** 알린다.

---

## 관련 노트
- [[Order Management 개요와 데이터 모델]]
- [[Order Management — Import·Fulfillment·Taxation]]
- [[CommercePayments Namespace]]
- [[CommerceExtension Namespace]]
- [[Actions API]]
- [[ConnectApi Namespace 개요]]
