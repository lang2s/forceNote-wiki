---
tags: [index, commerce, order-management]
created: 2026-06-20
---

# Commerce(커머스) — 로컬 인덱스

> Salesforce Commerce 도메인 — Order Management(주문 관리) 개발자 가이드(v66.0 Spring '26) 기반 데이터 모델·B2C Commerce 주문 데이터 맵·Import/Fulfillment/Taxation·Exchanges/Payment Sequencing 4노트

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Order Management 개요와 데이터 모델]] | OM 개발자 리소스 카탈로그·OrderSummary 엔티티 관계 데이터 모델 — 진입 허브 | #overview |
| [[B2C Commerce Storefront Order Data Map]] | B2C Commerce 주문 패킷 XSD → SF Order Management 21개 객체 필드 전수 매핑·결제 게이트웨이·커스텀 결제 수단 | #reference |
| [[Order Management — Import·Fulfillment·Taxation]] | 주문 데이터 import 레코드 생성 순서·OrderSummary 생성·Fulfillment Order·Location 용량·net/gross 세금 계산 | #reference |
| [[Order Management — Exchanges·Payment Sequencing·확장]] | 불균등 교환(RMA) Preview/Submit Cart API·Payment Sequencing Apex·Lightning 컴포넌트·OBO·ProductExpandService 확장 | #reference |

---

## 빠른 선택

- 처음 시작 / OM 개발자 리소스·OrderSummary 데이터 모델 큰 그림 → [[Order Management 개요와 데이터 모델]]
- B2C Commerce 주문이 SF 어느 객체·필드로 매핑되는지 / XSD 매핑·커스텀 결제 수단 → [[B2C Commerce Storefront Order Data Map]]
- 주문 데이터 import 순서·OrderSummary 생성·Fulfillment Order·세금 계산 → [[Order Management — Import·Fulfillment·Taxation]]
- 교환(RMA) Cart API·Payment Sequencing·OM Lightning 컴포넌트·Return Insights 확장 → [[Order Management — Exchanges·Payment Sequencing·확장]]

---

## 관련 폴더

- B2B Commerce Order/Checkout Apex(CommerceOrders·Sfdc_Checkout 네임스페이스) → [[Apex/Integration(통합)/CommerceOrders Namespace]] · [[Apex/Integration(통합)/Sfdc_Checkout Namespace]]
- 결제 게이트웨이 어댑터 Apex → [[Apex/Integration(통합)/CommercePayments Namespace]]
- 세금 엔진 어댑터 Apex → [[Apex/Integration(통합)/CommerceTax Namespace]]
