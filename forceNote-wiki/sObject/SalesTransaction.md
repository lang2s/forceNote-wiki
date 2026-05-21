---
tags: [sobject-reference, object-interfaces, sales-transaction, b2b-commerce, subscription-management, order, webcart]
source: object_reference.pdf pp.145-146 (v67.0 Summer '26)
created: 2026-05-22
aliases: [SalesTransaction, 판매 트랜잭션 인터페이스, TotalAdjustmentAmount, TotalListAmount, TotalProductAmount, Order WebCart 인터페이스]
---

# SalesTransaction

> 판매 트랜잭션(Order 또는 WebCart)을 나타내는 Object 인터페이스 — API v55.0+

---

## 개요

`SalesTransaction`은 판매 트랜잭션(예: 주문 또는 카트)을 위한 비즈니스 로직을 정의하는 Object 인터페이스다. `Order` 또는 `WebCart`가 이 인터페이스를 구현한다.

**지원 호출**: `describeSObjects()`, `query()`, `retrieve()`

**사용 조건**: Subscription Management 및 B2B Commerce 라이센스 필요

**구현 Object 예시**: `Order`, `WebCart`

---

## 전체 필드 참조표

| 필드 | 타입 | 속성 | 설명 |
|---|---|---|---|
| `ImplementorType` | string | Default on create, Filter, Group, Restricted picklist, Sort | 이 Object 인터페이스를 구현하는 Object. 예: `Order`, `WebCart` |
| `TotalAdjustmentAmount` | currency | Filter, Nillable, Sort | 판매 트랜잭션에 적용된 모든 조정 금액 합산 (수량·구독 기간 포함). 직접 적용된 조정 항목 및 분산 조정 항목 모두 포함. 계산 필드 = 관련 sales transaction items의 `TotalAdjustmentAmount` 합계 |
| `TotalAdjustmentDistAmount` | currency | Filter, Nillable, Sort | 관련 sales transaction items에 적용된 분산(distributed) 가격 조정 항목만의 합산 (수량·구독 기간 포함). 직접 적용된 조정 항목 미포함. 계산 필드 = 관련 sales transaction items의 `TotalAdjustmentDistAmount` 합계 |
| `TotalAmount` | currency | Filter, Nillable, Sort | 모든 조정 이후 판매 트랜잭션의 최종 가격 (수량·구독 기간 포함). 계산 필드 = 관련 sales transaction items의 `TotalPrice` 합계 |
| `TotalListAmount` | currency | Filter, Nillable, Sort | 관련 sales transaction items의 정가(list price) 합산 (수량·구독 기간 포함). 계산 필드 = 관련 sales transaction items의 `ListPriceTotal` 합계 |
| `TotalProductAmount` | currency | Filter, Nillable, Sort | Product 타입 라인 아이템의 가격 조정 전 소계 (수량·구독 기간 포함). 계산 필드 = Product 타입인 관련 sales transaction items의 `TotalLineAmount` 합계 |

---

## 구현체 Object 패턴

```
SalesTransaction 인터페이스를 구현하는 Object:
  · Order        — 표준 Salesforce Order Object
  · WebCart      — B2B Commerce 장바구니 Object

ImplementorType로 어떤 구현체인지 식별:
  · ImplementorType = 'Order'   → Order Object가 구현
  · ImplementorType = 'WebCart' → WebCart Object가 구현
```

### 가격 계산 관계도

```
SalesTransaction
├── TotalListAmount      = Σ SalesTransactionItem.ListPriceTotal
├── TotalProductAmount   = Σ SalesTransactionItem.TotalLineAmount (type=Product)
├── TotalAdjustmentAmount = Σ SalesTransactionItem.TotalAdjustmentAmount
│                           (직접 조정 + 분산 조정 포함)
├── TotalAdjustmentDistAmount = Σ SalesTransactionItem.TotalAdjustmentDistAmount
│                                (분산 조정만)
└── TotalAmount          = Σ SalesTransactionItem.TotalPrice
                           (모든 조정 이후 최종 금액)
```

---

## SOQL 패턴

```apex
// SalesTransaction 인터페이스로 Order 가격 정보 조회
List<SalesTransaction> txns = [
    SELECT ImplementorType,
           TotalAmount, TotalListAmount,
           TotalProductAmount,
           TotalAdjustmentAmount, TotalAdjustmentDistAmount
    FROM SalesTransaction
    WHERE ImplementorType = 'Order'
    LIMIT 50
];

// WebCart 트랜잭션만 조회
List<SalesTransaction> carts = [
    SELECT ImplementorType, TotalAmount, TotalAdjustmentAmount
    FROM SalesTransaction
    WHERE ImplementorType = 'WebCart'
    LIMIT 50
];

// 관련 PriceAdjustmentGroup과 함께 조회
List<SalesTransaction> txnsWithGroups = [
    SELECT ImplementorType, TotalAmount,
        (SELECT AdjustmentSource, AdjustmentType, AdjustmentValue, Priority, TotalAmount
         FROM PriceAdjustmentGroups
         ORDER BY Priority NULLS LAST)
    FROM SalesTransaction
    WHERE ImplementorType = 'Order'
    LIMIT 10
];
```

---

## 관련 노트

- [[5 Object Interfaces]] — Object 인터페이스 챕터 개요 (부모 챕터)
- [[PriceAdjustmentGroup]] — 주문/카트 전체 레벨 가격 조정 그룹
- [[PriceAdjustmentItem]] — 라인 아이템 레벨 가격 조정
- [[6 Standard Objects]] — Order·WebCart 등 SalesTransaction 구현 Object 목록
