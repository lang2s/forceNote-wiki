---
tags: [sales-cloud, products, price-books, product-schedules, pricing]
source: help.salesforce.com (Salesforce Help — Sales Basics; Products and Price Books; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sales.products_pricebooks.htm&type=5
created: 2026-07-03
aliases: [Products, Price Books, 제품, 가격표, Standard Price Book, Custom Price Book, Price Book Entry, Product Schedule, List Price]
---

# Products & Price Books (제품·가격표)

> **제품**은 판매 항목·서비스의 기본 카탈로그(+표준가), **가격표(price book)**는 제품과 가격의 목록. 표준 가격표(전 제품 기본가)와 커스텀 가격표(세그먼트별 list price)로 나뉘며, 영업 시 선택한 가격표에서 가격이 자동으로 채워진다.

---

## 개념 — 제품과 가격표

**제품(Products)** 은 회사가 판매하는 모든 항목·서비스와 그 **표준가(standard price)** 를 담는 base catalog다. 무엇을 파는지에 대한 마스터 목록 역할을 한다.

**가격표(Price Book)** 는 제품과 그 가격의 **목록**이다. 고객에게 제공하는 제품·서비스의 가격을 추적하며, 조직은 상황에 따라 서로 다른 가격표를 사용해 같은 제품을 다른 가격에 판매할 수 있다.

가격표는 두 종류로 나뉜다.

| 구분 | 설명 |
|---|---|
| **Standard Price Book (표준 가격표)** | 모든 제품과 그 **default standard price(기본 표준가)** 의 master list. Salesforce가 생성하며, 커스텀 가격표를 몇 개 만들든 상관없이 **전 제품과 표준가**를 포함한다. |
| **Custom Price Book (커스텀 가격표)** | 커스텀 가격(**list price**)을 가진 제품들의 별도 목록. 서로 다른 **market segment·region·고객 subset**에 다른 가격을 제공하고자 할 때 이상적이다. |

## Price Book Entry (가격표 항목)

**Price Book Entry** 는 특정 가격표 안에서의 한 제품의 가격이다. 즉 **제품 × 가격표**의 교차점으로, 하나의 제품이 여러 가격표에 각각 다른 가격으로 등재될 수 있다. 표준 가격표의 항목은 표준가를 담고, 커스텀 가격표의 항목은 그 세그먼트에 맞는 list price를 담는다.

## Product Schedules (제품 스케줄)

**Product Schedules** 는 시간에 걸쳐 지불·배송되는 제품의 **payment·delivery 주기**를 결정한다.

- **Revenue schedule** — 지불(payment) 주기를 결정한다.
- **Quantity schedule** — 배송(delivery) 주기를 결정한다.

정기 구독이나 분할 납품처럼 한 번에 정산·배송되지 않는 제품에 사용한다.

## 동작 — 영업 시 가격 자동 채우기

영업 담당자(rep)가 거래에 제품을 추가할 때 가격은 다음 순서로 자동으로 채워진다.

1. 적절한 **price book을 먼저 선택**한다.
2. 제품을 deal(opportunity 등)에 추가한다.
3. 선택한 가격표에서 각 항목의 **가격이 자동으로 pull**된다.

이 흐름 덕분에 세그먼트·지역별로 다른 커스텀 가격표를 두면, 담당자는 올바른 가격표만 고르면 되고 개별 가격을 손으로 입력할 필요가 없다.

```
// 구조 예시 — Products & Price Books(실제 원본 다이어그램 아님)
Product(카탈로그) ──▶ Price Book Entry(가격) ──▶ Price Book
   Standard Price Book: 전 제품 + 표준가 (Salesforce 생성)
   Custom Price Book:   부분집합 + list price (세그먼트/지역별)
Opportunity/Quote: price book 선택 → 제품 추가 → 가격 자동 pull
Product Schedule: revenue(지불) · quantity(배송) 주기
```

## 관리 시 참고 사항

- **제품 커스터마이즈** — 필요에 따라 제품을 커스터마이즈할 수 있다.
- **삭제 전 고려사항** — 제품·가격표를 삭제하기 전 관련 considerations를 확인한다(이미 거래에 사용 중인 항목 등).
- **필드 참조** — product / price book / price book entry / product schedule 각 객체의 상세 field 정의는 공식 문서에 위임한다. → [공식 문서](https://help.salesforce.com/s/articleView?id=sales.products_pricebooks.htm&type=5)

## 관련 노트
- [[Sales Cloud 개요]] — Sales Cloud 시리즈 허브.
- [[Opportunities (기회)]] — opportunity product가 가격표에서 가격을 가져옴.
- [[Quotes (견적)]] — quote line item의 제품·가격 원천.
- [[Contracts & Orders (계약·주문)]] — order product의 제품·가격 소스.
