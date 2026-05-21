---
tags: [sobject-reference, object-interfaces, price-adjustment, b2b-commerce, subscription-management, pricing, line-item]
source: object_reference.pdf pp.140-144 (v67.0 Summer '26)
created: 2026-05-22
aliases: [PriceAdjustmentItem, 라인 아이템 가격 조정, AdjustmentAmountScope, Total Unit 조정 범위, CartItemPriceAdjustment, 항목 레벨 할인]
---

# PriceAdjustmentItem

> 주문/카트의 특정 라인 아이템에 적용되는 항목 레벨 가격 조정 — API v55.0+

---

## 개요

`PriceAdjustmentItem`은 라인 아이템에 적용되는 가격 조정(예: 특정 주문 항목 할인)을 위한 비즈니스 로직을 정의하는 Object 인터페이스다.

**지원 호출**: `describeSObjects()`, `query()`, `retrieve()`

**사용 조건**: Subscription Management 또는 B2B Commerce 라이센스 필요

**구현 Object 예시**: `CartItemPriceAdjustment`, `OrderItemAdjustment`

---

## 전체 필드 참조표

| 필드 | 타입 | 속성 | 설명 |
|---|---|---|---|
| `AdjustmentAmountScope` | picklist | Filter, Group, Nillable, Restricted picklist, Sort | AdjustmentValue와 함께 조정 금액을 결정하는 범위. 값: `Total`(라인 합계에 직접 적용), `Unit`(단가×수량으로 적용). 아래 계산 예제 참조 |
| `AdjustmentSource` | picklist | Filter, Group, Restricted picklist, Sort | 조정 출처. 값: `Discretionary`(수동), `Promotion`(프로모션), `Rule`(미래 예약), `System`(가격 구성에 의한 것, 예: 할인 스케줄) |
| `AdjustmentType` | picklist | Filter, Group, Restricted picklist, Sort | 조정 방식. 값: `AdjustmentAmount`(금액), `AdjustmentPercentage`(퍼센트), `OverrideAmount`(덮어쓰기) |
| `AdjustmentValue` | double | Filter, Sort | 조정 값. AdjustmentAmountScope와 함께 최종 금액 결정 |
| `Description` | textarea | Nillable | 사용자가 입력한 가격 조정 아이템 설명. API v55.0~v57.0에서만 사용 가능 |
| `ImplementorType` | string | Filter, Group, Nillable, Sort | 이 Object 인터페이스를 구현하는 Object. 예: `CartItemPriceAdjustment` |
| `PriceAdjustmentCauseId` | reference → `PriceAdjCauseInterface` | Filter, Group, Nillable, Sort | 조정 원인 레코드 ID. 프로모션 조정이면 Promotion 레코드 ID, 가격 조정 티어이면 PriceAdjustmentTier 레코드 ID. 관계 이름: `PriceAdjustmentCause`, 타입: Lookup |
| `PriceAdjustmentGroupId` | reference → `PriceAdjustmentGroup` | Filter, Group, Nillable, Sort | 여러 가격 조정 아이템의 값을 집계하는 Object 인터페이스 또는 Object 참조. 연결된 엔터티가 Object인 경우 PriceAdjustmentGroup 인터페이스를 구현해야 함. 관계 이름: `PriceAdjustmentGroup`, 타입: Lookup |
| `Priority` | int | Filter, Group, Nillable, Sort | 같은 가격 조정 그룹 내 이 항목의 적용 순서. 1이 먼저. null이면 우선순위 있는 것 이후 적용. 같은 그룹 내 고유해야 함 |
| `SalesTransactionItemId` | reference → `SalesTransactionItem` | Filter, Group, Nillable, Sort | 이 가격 조정이 적용되는 판매 트랜잭션 항목 ID. 관계 이름: `SalesTransactionItem`, 타입: Lookup |
| `TotalAmount` | currency | Filter, Sort | 수량 및 구독 기간을 포함한 최종 조정 금액. 아래 계산 예제 참조 |

---

## AdjustmentAmountScope 수식 계산 예제

### Total 범위

```
조건: 수량 10, TotalLineAmount $1,000, AdjustmentValue -10, AdjustmentType AdjustmentAmount

계산:
  TotalAmount = TotalLineAmount + AdjustmentValue
             = $1,000 + (-$10)
             = $990

설명: $10 할인을 라인 합계에 직접 적용 — 수량 무관
```

### Unit 범위

```
조건: 수량 5, TotalLineAmount $1,000, AdjustmentValue -10, AdjustmentType AdjustmentAmount

계산:
  TotalAmount = TotalLineAmount + (AdjustmentValue × 수량)
             = $1,000 + (-$10 × 5)
             = $950

설명: 단위당 $10 할인 × 수량 5
```

### 구독 기간 포함 계산 (Unit + AdjustmentAmount)

```
조건:
  AdjustmentAmountScope = Unit
  AdjustmentType = AdjustmentAmount
  AdjustmentValue = -10
  수량 = 5
  PricingTermCount(구독 기간) = 12개월

계산:
  TotalAmount = 수량 × PricingTermCount × AdjustmentValue
             = 5 × 12 × (-10)
             = -600
```

---

## Priority 적용 규칙

```
규칙:
  1. Priority 명시(양의 정수) → 오름차순으로 적용 (1이 제일 먼저)
  2. Priority = null → 우선순위가 명시된 것 이후에 적용
  3. null Priority 아이템이 여러 개 → 퍼센트 먼저, 금액 나중
     (퍼센트 먼저 적용이 최종 조정액이 더 큼)

제약:
  · Priority 값은 같은 가격 조정 그룹 내에서 고유해야 함
  · 예: 같은 그룹에서 Priority 1이 두 개 존재 불가

예시:
  Spring_Promotion (10% 할인, Priority=1)
  Early_Renewal_Discount ($2,000 할인, Priority=2)
  → Spring_Promotion이 먼저 적용됨
```

---

## SOQL 패턴

```apex
// 특정 라인 아이템의 가격 조정 전수 조회
List<PriceAdjustmentItem> items = [
    SELECT AdjustmentAmountScope, AdjustmentType, AdjustmentValue,
           AdjustmentSource, Priority, TotalAmount,
           PriceAdjustmentGroupId, PriceAdjustmentCauseId, ImplementorType
    FROM PriceAdjustmentItem
    WHERE SalesTransactionItemId = :orderItemId
    ORDER BY Priority NULLS LAST
];

// 프로모션에 의한 조정만 조회
List<PriceAdjustmentItem> promoItems = [
    SELECT AdjustmentSource, AdjustmentType, AdjustmentValue, TotalAmount
    FROM PriceAdjustmentItem
    WHERE SalesTransactionItemId = :orderItemId
    AND AdjustmentSource = 'Promotion'
];

// Unit 범위 조정만 조회
List<PriceAdjustmentItem> unitItems = [
    SELECT AdjustmentAmountScope, AdjustmentValue, TotalAmount
    FROM PriceAdjustmentItem
    WHERE SalesTransactionItemId = :orderItemId
    AND AdjustmentAmountScope = 'Unit'
];
```

---

## 관련 노트

- [[5 Object Interfaces]] — Object 인터페이스 챕터 개요 (부모 챕터)
- [[PriceAdjustmentGroup]] — 주문/카트 전체 레벨 가격 조정 그룹
- [[SalesTransaction]] — 판매 트랜잭션 인터페이스 (Order·WebCart)
- [[6 Standard Objects]] — Order·WebCart 등 SalesTransaction 구현 Object 목록
