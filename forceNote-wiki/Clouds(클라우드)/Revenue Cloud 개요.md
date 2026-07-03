---
tags: [revenue-cloud, cpq, billing, quote-to-cash, overview]
source: help.salesforce.com (Salesforce Help — Revenue Lifecycle Management / Revenue Cloud; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=ind.revenue_lifecycle_management.htm&type=5
created: 2026-07-03
aliases: [Revenue Cloud, 레비뉴 클라우드, Revenue Lifecycle Management, RLM, CPQ, Billing, Quote-to-Cash]
---

# Revenue Cloud 개요

> 견적부터 대금 수납까지(quote-to-cash) 매출 수명주기 전체를 관리하는 제품군 — CPQ(구성·가격·견적), 계약, 주문, billing, 구독/자산. Sales Cloud의 기본 Quotes보다 고급이다. 기술 상세는 위키 `CPQ(견적)/` 폴더 참조.

---

## 개념

**Revenue Cloud**(Revenue Lifecycle Management, **RLM**)는 **매출 수명주기 전체(quote-to-cash)**를 관리하는 제품군이다. 다음 단계를 아우른다.

- **CPQ** (Configure·Price·Quote) — 제품 구성, 가격 규칙, 견적 생성.
- **계약(Contract)** — 계약 관리.
- **주문(Order)** — 주문 처리.
- **Billing** — 청구·대금 수납.
- **구독(Subscription)·자산(Asset)** — 구독 및 자산 관리.

## 기본 Quotes와의 구분

Revenue Cloud는 Sales Cloud의 기본 **[[Quotes (견적)]]**(단순 견적)보다 복잡한 구성·가격·청구를 다루는 고급 제품이다. 단순한 견적 발행은 기본 Quotes로 충분하지만, 구성 가능한 제품·가격 규칙·구독·청구 스케줄이 필요하면 Revenue Cloud를 사용한다.

> CPQ 규칙, billing 스케줄, API 세부 등 기술 상세는 이 개요의 범위 밖이다 → 공식 문서 및 위키 `CPQ(견적)/` 폴더에 위임한다.

## 구성

```
// 구조 예시 — Revenue Cloud / Quote-to-Cash(실제 원본 다이어그램 아님)
CPQ(구성·가격·견적) → 계약(Contract) → 주문(Order) → Billing(청구·수납)
   + 구독(Subscription)·자산(Asset) 관리
Sales Cloud 기본 Quotes보다 고급 · 기술 상세 → CPQ(견적)/ 폴더
```

## 관련 노트

- [[Salesforce 제품 클라우드 개요]] — 전체 클라우드 지도 허브.
- [[Quotes (견적)]] — Sales Cloud 기본 견적(구분 대상).
- [[CPQ API Models]] — CPQ 기술 노트(구성·가격·견적 API 모델).
