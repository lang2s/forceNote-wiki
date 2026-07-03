---
tags: [sales-cloud, agentforce-sales, overview, sales-process]
source: help.salesforce.com (Salesforce Help — Sales Basics; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sales.sales_core.htm&type=5
created: 2026-07-03
aliases: [Sales Cloud, Agentforce Sales, 세일즈 클라우드, Sales Basics, Seller Home]
---

# Sales Cloud 개요

> 리드 생성부터 파이프라인의 기회 관리, 고객 관계 육성까지 영업 전 과정을 다루는 Salesforce 제품군. **현재 명칭은 Agentforce Sales**(구 Sales Cloud). 이 노트는 Sales Cloud 기능 맵의 허브다.

---

## Sales Cloud란

Sales Cloud는 **비즈니스의 영업 측(sales side) 전부**를 제공한다. 최고의 리드를 생성하고, 영업 파이프라인을 통해 opportunity를 관리하며, 고객 관계를 육성하는 것까지 — 영업 조직이 필요로 하는 전 과정을 하나의 플랫폼에서 다룬다.

> [!note] 브랜딩 변경
> **Sales Cloud is now Agentforce Sales.** 제품이 Agentforce Sales로 리브랜딩되었으나, 애플리케이션 UI와 문서에서는 여전히 "Sales Cloud" 표기를 볼 수 있다. 두 명칭은 같은 제품을 가리킨다.

핵심 흐름은 다음과 같다.

```
// 구조 예시 — Sales Cloud(Agentforce Sales) 기능 맵(실제 원본 다이어그램 아님)
리드 생성 → 파이프라인 관리 → 관계 육성
  Seller Home · Labels · Sales Console (작업 환경)
  Campaigns → Leads → Opportunities → (Quote/Contract/Order)
  Accounts & Contacts · Products & Price Books
  Forecasting · Territories · Teams · Maps
  Einstein AI (전 단계 자동화·예측)  ·  Import(최대 5만 lead/contact)
```

---

## 기능 맵 (전수)

| 기능 | 설명 |
|---|---|
| **Seller Home** | 비즈니스를 한눈에 보는 조감뷰(bird's-eye view). 핵심 정보를 표시한다. |
| **Generative AI** | Einstein을 통해 핵심 레코드 정보에 빠르게 접근한다. |
| **Labels** | 레코드에 직접 라벨을 붙여 정리·추적·검색한다. |
| **가이드 워크스페이스 (Guided workspace)** | AI 기반으로 핵심 인사이트와 추천을 표면화한다. |
| **Campaigns** | 마케팅 활동을 정리하고 추적한다. |
| **Opportunities** | 영업 프로세스로 진행하며 무엇을 얼마에 파는지 추적한다. |
| **Accounts & Contacts** | 거래 상대(사람·회사)를 추적하고, 정보를 저장하며, 협업한다. |
| **Maps** | 지도에서 고객·잠재고객을 식별하고 방문을 계획한다. |
| **Forecasting · Territories · Teams** | 파이프라인 기반으로 매출을 예측하고, 영업 territory를 설정하며, 팀을 구성한다. |
| **Einstein AI** | 데이터 입력 자동화 등 영업 프로세스를 단계마다 스마트하게 만든다. |
| **Sales Console / 디지털 채널** | Lightning Sales Console로 잠재고객과 연결을 유지한다. |
| **Import** | 권한이 있으면 contact·lead를 한 번에 **최대 50,000건** 임포트한다. |

> Sales Cloud 사용에는 usage restriction(사용 제한)이 적용될 수 있으므로, 해당 공식 문서를 함께 참조한다.

---

## 작업 환경 요약

- **Seller Home**은 영업 담당자의 시작점으로, 비즈니스 현황을 조감한다.
- **Lightning Sales Console**은 잠재고객과의 연결을 유지하는 작업 공간이다.
- **Labels**와 **가이드 워크스페이스**는 레코드 정리·인사이트 표면화를 돕는다.
- **Einstein AI / Generative AI**는 위 전 단계에 걸쳐 데이터 입력 자동화, 레코드 정보 접근, 인사이트·추천을 제공한다.

---

## Sales Cloud 시리즈 노트

영업 흐름 순서로 그룹핑한 이 시리즈의 스포크 노트들이다.

- **수요 창출**: [[Campaigns (캠페인)]] · [[Leads (리드)]]
- **거래**: [[Opportunities (기회)]] · [[Quotes (견적)]] · [[Contracts & Orders (계약·주문)]]
- **대상·가격**: [[Accounts & Contacts (거래처·연락처)]] · [[Products & Price Books (제품·가격표)]]
- **실행·계획**: [[Activities — Tasks & Events (활동)]] · [[Collaborative Forecasts (예측)]] · [[Territory Management (영역 관리)]]

---

## 관련 노트
- [[Data Import Wizard]] — lead·contact를 한 번에 최대 5만 건 임포트
- [[CPQ API Models]] — 복잡한 견적·구성(CPQ)으로 영업 프로세스 확장
