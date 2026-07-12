---
tags: [sales-cloud, contracts, orders, order-products, agreements]
source: help.salesforce.com (Salesforce Help — Orders / Contracts; 라이브 공식 문서, Tier 2, 접속 2026-07-03) · help.salesforce.com — Enable Orders (Tier 2)
official_doc: https://help.salesforce.com/s/articleView?id=sales.order_overview.htm&type=5
enable_orders_doc: https://help.salesforce.com/s/articleView?id=sales.customize_order_enable.htm&type=5
created: 2026-07-03
aliases: [Contracts, Orders, 계약, 주문, Order Products, 주문 제품, Contract]
---

# Contracts & Orders (계약·주문)

> **Contract**는 거래처와의 정의된 조건을 담은 합의 레코드, **Order**는 고객에게 제공할 제품·서비스를 order product로 기록하는 레코드. order는 contract에 연결될 수 있다.

---

## Contract (계약)

**Contract**는 거래처(account)와의 **정의된 조건(terms)**을 담은 합의(agreement) 레코드다.

- 계약 기간·조건을 추적한다.
- 활성화(activation) 및 **갱신(renewal)** 대상이 된다.

> Contract의 개별 필드·상태 전이(status transition)·활성화 절차 등 세부는 이 노트 범위를 벗어난다 → [공식 문서](https://help.salesforce.com/s/articleView?id=sales.order_overview.htm&type=5) 참조.

## Order (주문)

**Order**는 고객이 요청한/제공할 **제품·서비스**를 추적하는 레코드다.

- **contract에 연결(associate)**되거나, 독립적으로 존재할 수 있다.

> ⚠️ **전제조건 — Orders 활성화 (기본 비활성)**
> Orders는 조직에서 **기본적으로 비활성**이다. 활성화하기 전에는 order 오브젝트·**Orders 탭**·order 관련 목록이 나타나지 않는다.
> - **Setup → Quick Find `Order Settings` → Enable Orders** 체크로 활성화한다.
> - **reduction order(감축 주문)**를 쓰려면 같은 화면에서 **Enable Reduction Orders**도 별도로 켜야 한다.
> 근거: [Enable Orders (Salesforce Help)](https://help.salesforce.com/s/articleView?id=sales.customize_order_enable.htm&type=5)

> 감축 order(reduction order) 등 order의 세부 유형·필드·상태 전이는 공식 문서 위임.

## Order Products (주문 제품)

**Order Products**는 order의 line item으로, **제품·수량·가격**을 담는다.

- order의 **관련 목록(related list)**으로 표시된다.
- order product의 제품·가격 소스는 [[Products & Price Books (제품·가격표)]]를 참조한다.

## 관계 구조

```
// 구조 예시 — Contracts & Orders(실제 원본 다이어그램 아님)
Account ──▶ Contract(정의된 조건·기간·갱신)
                 └─(연결 가능)─▶ Order(제공 제품·서비스)
                                    └─ Order Products(line item: 제품·수량·가격)
```

---

## 관련 노트
- [[Sales Cloud 개요]] — Sales Cloud 시리즈 허브
- [[Products & Price Books (제품·가격표)]] — order product의 제품·가격 소스
- [[Quotes (견적)]] — 견적 → 주문/계약으로 이어지는 영업 흐름
- [[Order Management 개요와 데이터 모델]] — 이름 혼동 주의: 표준 `Order` 객체는 이 노트 / 주문 관리(SOM·OrderSummary)는 Commerce 쪽 노트
