---
tags: [commerce, order-management, b2c-commerce, data-model, connect-api, platform-events, overview, hub]
source: order_management_developer_guide_html.pdf (Version 66.0, Spring '26, Tier 2) — Order Management Developer Resources(p.2-3)·Order Summary Entity Relationships(p.4)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.order_management_developer_guide.meta/order_management_developer_guide/
created: 2026-06-20
aliases: [Order Management, Salesforce Order Management, SOM, OM 개요, 주문 관리, OrderSummary Entity Relationships, OM Developer Resources, FulfillmentOrder, OrderSummary]
---

# Order Management 개요와 데이터 모델

> Salesforce Order Management은 **storefront·inventory·fulfillment 시스템과 통합되는 주문 처리 앱**. 이 노트는 OM 개발자 리소스 카탈로그와 OrderSummary 데이터 모델을 정리한 **허브**다. (`order_management_developer_guide_html.pdf` v66.0)

> 📂 OM 가이드 4노트: 이 허브 · [[B2C Commerce Storefront Order Data Map]] · [[Order Management — Import·Fulfillment·Taxation]] · [[Order Management — Exchanges·Payment Sequencing·확장]]

---

## 개요 — Order Management이란

Salesforce Order Management(SOM)은 storefront에서 들어온 주문을 받아 처리·이행하는 앱이다. PDF Chapter 1 인트로:

> "Customize Salesforce Order Management and integrate it with your storefront, inventory, and fulfillment systems."

즉 OM은 단독으로 동작하지 않고 **storefront·inventory·fulfillment 세 시스템과 통합**되는 것을 전제로 한다. 주문 한 건은 내부적으로 하나의 **order summary**와 그에 연결된 여러 레코드(item·delivery group·payment 등)로 표현된다(아래 [Order Summary Entity Relationships](#order-summary-entity-relationships) 참조).

이 가이드(`order_management_developer_guide_html.pdf`, v66.0 Spring '26)는 단일 챕터 아래 9개 절로 구성되며, 본 위키에서는 4개 노트로 분할해 다룬다.

| OM 가이드 노트 | 다루는 PDF 절 |
|---|---|
| **이 허브** (개요·데이터 모델) | Developer Resources(p.2)·Order Summary Entity Relationships(p.4) |
| [[B2C Commerce Storefront Order Data Map]] | B2C Commerce Storefront Order Data Map(p.5) |
| [[Order Management — Import·Fulfillment·Taxation]] | Importing Order Data(p.39)·Fulfillment Orders(p.47)·Taxation(p.50) |
| [[Order Management — Exchanges·Payment Sequencing·확장]] | API Framework for Exchanges(p.53)·Payment Sequencing(p.57)·Lightning Components(p.62) |

---

## Order Management Developer Resources

> PDF 원문: "In addition to the Order Management Developer Guide, these documentation resources can help you customize Salesforce and the Order Management app."

이 절(p.2~3)은 OM 가이드 **외부의** 관련 문서·API·리소스로 가는 **링크 목록**이다(본 PDF에는 링크 텍스트만 존재). 아래는 그 카탈로그를 전수 정리한 것이다. 각 항목의 상세 메서드·시그니처는 해당 네임스페이스 노트에 위임한다(중복 방지).

### Connect in Apex Classes (8종)

Order Management용 Connect in Apex 클래스 8종. **각 클래스의 메서드 시그니처·반환 타입 상세는 [[ConnectApi Namespace 개요]]에 위임** — 여기서는 카탈로그만.

| 클래스 | 역할 (PDF 카탈로그 분류) |
|---|---|
| `FulfillmentOrder` | 이행 주문(fulfillment order) 처리 |
| `OmnichannelInventoryService` | 옴니채널 인벤토리 서비스 |
| `OrderPaymentSummary` | 주문 결제 요약 |
| `OrderSummary` | 주문 요약 |
| `OrderSummaryCreation` | 주문 요약 생성 |
| `Repricing` | 재가격 산정(repricing) |
| `ReturnOrder` | 반품 주문 |
| `Routing` | 라우팅 |

> 메서드·input/output 클래스 전수는 [[ConnectApi Namespace 개요]] 참조.

### Connect REST API · Salesforce Flow

| 카테고리 | 항목 |
|---|---|
| **Connect REST API Resources** | B2B and B2B2C Commerce Resources · Salesforce Omnichannel Inventory Resources · Salesforce Order Management Resources |
| **Salesforce Flow** | Flow Builder · Salesforce Omnichannel Inventory Flow Core Actions · Salesforce Order Management Flow Core Actions · Salesforce Omnichannel Inventory Actions · Salesforce Order Management Actions · Presentation: Advanced Salesforce Order Management Flows (Video) · Example Custom Flow: Remorse Delay · Example Custom Flow: Bulk Order Cancel |

> Flow Core Actions / Invocable Actions의 일반 메커니즘은 [[Actions API]] 참조.

### Platform Events (7종)

OM이 발행하는 플랫폼 이벤트 7종(PDF 원문 순서 그대로). 이벤트 구독·재시도·한도는 [[Platform Event 한도와 고려사항]] 참조.

| 플랫폼 이벤트 | 발행 시점 (이름 기준) |
|---|---|
| `FOStatusChangedEvent` | FulfillmentOrder 상태 변경 |
| `FulfillOrdItemQtyChgEvent` | FulfillmentOrder item 수량 변경 |
| `OrderStatusChangedEvent` | Order 상태 변경 |
| `OrderSummaryCreatedEvent` | OrderSummary 생성됨 |
| `OrderSumStatusChangedEvent` | OrderSummary 상태 변경 |
| `PendingOrdSumProcEvent` | 대기 중 OrderSummary 처리 |
| `ProcessExceptionEvent` | 처리 예외(process exception) 발생 |

```apex
// 구조 예시 — 실제 동작 코드 아님 (Platform Event 구독 패턴 일반형)
// OrderSummaryCreatedEvent 구독 트리거 골격
trigger OrderSummaryCreatedTrigger on OrderSummaryCreatedEvent (after insert) {
    for (OrderSummaryCreatedEvent evt : Trigger.new) {
        // evt 필드 처리 (필드 목록은 본 PDF 카탈로그 범위 밖 — Object Reference 참조)
    }
}
```

> ⚠️ 위 이벤트 객체들의 **필드 목록**은 이 절(Developer Resources 카탈로그)에 없다 — `Object Reference for Salesforce and Lightning Platform`(아래 기타 리소스) 참조.

### Commerce Payments 데이터 모델

PDF는 Commerce Payments 관련 데이터 모델을 **CCS Order/Invoice 객체**와 **Commerce Payment 객체** 두 그룹으로 나눈다. **객체별 필드·메서드 상세는 [[CommercePayments Namespace]] 참조** — 여기서는 객체 카탈로그만.

| 그룹 | 객체 |
|---|---|
| **Data Models for CCS Order and Invoice Objects** (4종) | `CreditMemo` · `CreditMemoLine` · `Invoice` · `InvoiceLine` |
| **Data Models for Commerce Payment Objects** (8종) | `Payment` · `PaymentAuthorization` · `PaymentGateway` · `PaymentGatewayLog` · `PaymentGatewayProvider` · `PaymentGroup` · `PaymentLineInvoice` · `PaymentMethod` |
| **기타 Commerce Payments 리소스** | Commerce Payments Connect in REST Resources · Commerce Payments Resources · CommercePayments Apex Namespace · CommercePayments Namespace |

> Payment 객체 8종의 Apex 처리(`CommercePayments` 네임스페이스)는 [[CommercePayments Namespace]] 참조.

### Implementation·기타 리소스

| 카테고리 | 항목 |
|---|---|
| **Implementation** | Salesforce Order Management Implementation Guide for B2C Commerce (PDF) · Salesforce Order Management Implementation Guide for B2B and B2B2C Commerce (PDF) · Order Management with B2C Commerce Add Item Playbook (PDF) |
| **Distributed Order Management Routing Package** | Distributed Order Management Routing Package Documentation · Omnichannel Inventory Downtime Playbook |
| **Other Developer Resources** | Order Management Partner Pocket Guide · Object Reference for Salesforce and Lightning Platform · Standard Lightning Page Components |

---

## Order Summary Entity Relationships

> PDF 원문: "In Salesforce Order Management, each order is represented by an order summary and a number of other records linked to the order summary. This diagram illustrates some of the relationships between the OrderSummary object and other objects used in Salesforce Order Management."

OM에서 주문 한 건은 하나의 **order summary**(OrderSummary 객체)와 그에 연결된 여러 레코드로 표현된다. PDF p.4의 이 절은 OrderSummary 객체를 중심으로 한 객체 관계를 **다이어그램**으로 보여준다.

> ⚠️ **이 절의 관계 다이어그램은 원본에서 추출 불가.** pdftotext 미커버 + pdftoppm 렌더 실패(`Missing 'endstream'` 에러로 빈 PNG 생성)로, 다이어그램에서 추출 가능한 엔티티명·카디널리티 텍스트는 0건이다. 본 위키는 **추측 재현을 하지 않는다.** OrderSummary–OrderItemSummary–OrderDeliveryGroupSummary–OrderPaymentSummary 등의 구체적 카디널리티/관계선은 이 PDF의 이 절에서 텍스트로 확인되지 않았다. 구체 관계는 [[Order Management — Import·Fulfillment·Taxation]]의 Taxation 예제 등 **본문에 명시된 관계**(예: OrderItemTaxLineItemSummary → OrderItemSummary)를 참조하라.

조직 내 **전체 객체 관계 다이어그램**을 직접 보려면(PDF 본문 안내):

> Setup → Quick Find box에 `Schema Builder` 입력 → **Schema Builder** 선택.
> (참고: *Design Your Own Data Model* in *Extend Salesforce with Clicks, not Code*)

---

## 관련 노트
- [[B2C Commerce Storefront Order Data Map]]
- [[Order Management — Import·Fulfillment·Taxation]]
- [[Order Management — Exchanges·Payment Sequencing·확장]]
- [[ConnectApi Namespace 개요]]
- [[CommercePayments Namespace]]
- [[Actions API]]
- [[Platform Event 한도와 고려사항]]
