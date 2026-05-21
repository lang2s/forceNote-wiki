---
tags: [sobject-reference, object-interfaces, price-adjustment, b2b-commerce, subscription-management, pricing]
source: object_reference.pdf pp.138-139 (v67.0 Summer '26)
created: 2026-05-22
aliases: [PriceAdjustmentGroup, 가격 조정 그룹, WebCartAdjustmentGroup, OrderAdjustmentGroup, 주문 레벨 가격 조정, AdjustmentSource picklist]
---

# PriceAdjustmentGroup

> 주문/카트 전체에 적용되는 상위 레벨 가격 조정 그룹 — API v55.0+

---

## 개요

`PriceAdjustmentGroup`은 전체 주문 또는 카트에 적용되는 가격 조정(예: 전체 주문 할인)을 위한 비즈니스 로직을 정의하는 Object 인터페이스다. 여러 `PriceAdjustmentItem`의 합산 값을 보유한다.

**지원 호출**: `describeSObjects()`, `query()`, `retrieve()`

**사용 조건**: Subscription Management 또는 B2B Commerce 라이센스 필요

**구현 Object 예시**: `WebCartAdjustmentGroup`, `OrderAdjustmentGroup`

---

## 전체 필드 참조표

| 필드 | 타입 | 속성 | 설명 |
|---|---|---|---|
| `AdjustmentSource` | picklist | Filter, Restricted picklist, Sort | 조정 출처 (B2B Commerce에서 사용 가능). 아래 picklist 값 참조 |
| `AdjustmentType` | picklist | Filter, Restricted picklist, Sort | 조정 방식. 값: `AdjustmentAmount`(미래용 예약), `AdjustmentPercentage`, `OverrideAmount` |
| `AdjustmentValue` | double | Filter, Sort | 조정 값. 할인을 나타내려면 음수 사용 |
| `Description` | textarea | Nillable | 사용자가 입력한 가격 조정 그룹 설명. API v55.0~v57.0에서만 사용 가능 |
| `ImplementorType` | string | Filter, Group, Nillable, Sort | 이 인터페이스를 구현하는 Object. 예: `WebCartAdjustmentGroup` |
| `PriceAdjustmentCauseId` | reference → `PriceAdjCauseInterface` | Filter, Nillable, Sort | 조정 원인 레코드 ID. 프로모션 조정이면 프로모션 레코드 ID, 가격 조정 티어에 의한 것이면 해당 티어 레코드 ID. 관계 이름: `PriceAdjustmentCause`, 타입: Lookup |
| `Priority` | int | Filter, Nillable, Sort | 같은 판매 트랜잭션 내 이 가격 조정 그룹의 적용 순서. 1이 먼저. null이면 우선순위 있는 것 이후 적용. 같은 트랜잭션 내 고유해야 함 |
| `SalesTransactionId` | reference → `SalesTransaction` | Filter, Group, Nillable, Sort | 이 가격 조정 그룹이 속한 판매 트랜잭션 ID. 관계 이름: `SalesTransaction`, 타입: Lookup |
| `TotalAmount` | currency | Filter, Sort | 관련 PriceAdjustmentItem의 TotalAmount 합산값 (수량·구독 기간 포함). 계산 필드 |

---

## AdjustmentSource picklist 전체 값

| 값 | 설명 |
|---|---|
| `Discretionary` | 수동 입력. 예: 영업 담당자가 직접 입력한 할인 |
| `Promotion` | 프로모션의 일부 |
| `Rule` | 미래 사용 예약 |
| `System` | 시스템 데이터로 구성된 조정. 예: 가격 규칙(pricing rule)이나 할인 스케줄 |

---

## Priority 적용 규칙

```
규칙:
  1. Priority 명시(양의 정수) → 숫자 오름차순으로 적용 (1이 제일 먼저)
  2. Priority = null → 우선순위가 명시된 그룹 이후에 적용
  3. null Priority 그룹이 여러 개 → 퍼센트 조정 먼저, 금액 조정 나중
     (이유: 퍼센트 먼저 적용하면 최종 총 조정액이 더 큼)

제약:
  · Priority 값은 같은 판매 트랜잭션 내에서 고유해야 함
```

---

## SOQL 패턴

```apex
// 특정 주문의 가격 조정 그룹 전수 조회 (Priority 오름차순)
List<PriceAdjustmentGroup> groups = [
    SELECT AdjustmentSource, AdjustmentType, AdjustmentValue,
           Priority, TotalAmount, SalesTransactionId,
           PriceAdjustmentCauseId, ImplementorType
    FROM PriceAdjustmentGroup
    WHERE SalesTransactionId = :orderId
    ORDER BY Priority NULLS LAST
];

// B2B Commerce 카트의 프로모션 조정 그룹만 조회
List<PriceAdjustmentGroup> promos = [
    SELECT AdjustmentSource, AdjustmentType, AdjustmentValue, TotalAmount
    FROM PriceAdjustmentGroup
    WHERE SalesTransactionId = :cartId
    AND AdjustmentSource = 'Promotion'
    ORDER BY Priority NULLS LAST
];
```

---

## 관련 노트

- [[5 Object Interfaces]] — Object 인터페이스 챕터 개요 (부모 챕터)
- [[PriceAdjustmentItem]] — 라인 아이템 레벨 가격 조정 상세
- [[SalesTransaction]] — 판매 트랜잭션 인터페이스 (Order·WebCart)
- [[6 Standard Objects]] — Order·WebCart 등 SalesTransaction 구현 Object 목록
