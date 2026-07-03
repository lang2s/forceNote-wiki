---
tags: [commerce-cloud, b2c-commerce, b2b-commerce, ecommerce, overview]
source: help.salesforce.com (Salesforce Help — Commerce Cloud; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=commerce.overview.htm&type=5
created: 2026-07-03
aliases: [Commerce Cloud, 커머스 클라우드, B2C Commerce, B2B Commerce, 이커머스, Storefront]
---

# Commerce Cloud 개요

> B2C·B2B 온라인 커머스(스토어프론트·카탈로그·주문)를 구축·운영하는 Salesforce 제품. 위키의 기술 상세는 `Commerce(커머스)/` 폴더 참조.

---

## 개념

**Commerce Cloud**는 **온라인 커머스** 경험(storefront)을 구축·운영하는 Salesforce 제품군이다. 대상 고객에 따라 두 갈래로 나뉜다.

- **B2C Commerce** — 소비자(Business-to-Consumer) 대상 온라인 스토어.
- **B2B Commerce** — 기업 간(Business-to-Business) 거래 대상 스토어.

## 주요 기능 (개요)

storefront를 중심으로 다음 요소를 제공한다(예시 수준):

- **Storefront** — 온라인 상점 화면.
- **상품 카탈로그** — 판매 상품 목록·구성.
- **장바구니(Cart)** — 구매 대상 담기.
- **주문(Order)** — 구매 처리.

분석·운영 보조 기능으로는 다음이 있다.

- **Commerce Orders Dashboard** — 주문 추세(trend)를 분석.
- **장바구니 이탈 알림** — 고객이 장바구니를 이탈(abandon)하면 알림을 받는다.

> 구축·설정·API 등 기술 세부는 이 개요의 범위 밖이다 → 공식 문서 및 위키 `Commerce(커머스)/` 폴더에 위임한다.

## 구성

```
// 구조 예시 — Commerce Cloud(실제 원본 다이어그램 아님)
B2C Commerce (소비자) · B2B Commerce (기업)
  Storefront · 상품 카탈로그 · 장바구니 · 주문
  분석: Commerce Orders Dashboard · 장바구니 이탈 알림
기술 상세 → Commerce(커머스)/ 폴더
```

## 관련 노트

- [[Salesforce 제품 클라우드 개요]] — 전체 클라우드 지도 허브.
- [[Commerce(커머스)/index]] — Commerce 기술 노트 폴더 인덱스.
