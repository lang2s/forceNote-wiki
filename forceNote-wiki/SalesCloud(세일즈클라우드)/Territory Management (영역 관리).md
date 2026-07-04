---
tags: [sales-cloud, territory-management, enterprise-territory-management, territory-model, sales-territories]
source: help.salesforce.com (Salesforce Help — Sales Territories / Enterprise Territory Management; 라이브 공식 문서, Tier 2, 접속 2026-07-03) · help.salesforce.com — Enable Sales Territories (sales.tm2_enable_tm2, Tier 2) · help.salesforce.com — Allocations and Considerations for Territories (sf.tm2_allocations, Tier 2)
official_doc: https://help.salesforce.com/s/articleView?id=sales.tm2_intro.htm&type=5
created: 2026-07-03
aliases: [Territory Management, 영역 관리, Enterprise Territory Management, ETM, Sales Territories, Territory Model, Territory Hierarchy]
---

# Territory Management (영역 관리)

> 계정·리드를 영업 territory에 배정해 영업 조직을 구조화하는 Sales Cloud 기능(Enterprise Territory Management). territory model·hierarchy·assignment rule로 구성하며 활성 모델이 rep의 접근 범위를 제한한다.

---

## 개념

**Sales Territories(Enterprise Territory Management, ETM)** 는 계정·리드·사용자를 영업 territory에 배정해 영업 조직을 구조화하는 Sales Cloud 기능이다. 지역·산업·규모 등 조직이 정한 기준으로 영업 영역을 나누고, 그 영역에 rep을 배치해 담당 범위를 명확히 한다.

활성화된 territory model은 **접근 제어**로도 작동한다. sales rep은 자신에게 배정된 **account·lead·opportunity** 로만 접근이 제한된다.

## ⚠️ 전제조건 — Sales Territories 활성화

구축을 시작하기 전에 **Enterprise Territory Management를 먼저 Enable**해야 한다. 활성화 전에는 territory type·model 메뉴 자체가 나타나지 않는다.

- **활성화 경로:** Setup → **Territory Settings** 에서 **Sales Territories(Enterprise Territory Management)** 를 Enable.
- 활성화하지 않으면 아래 구축 프로세스의 territory type·territory model 관련 메뉴가 존재하지 않는다.

## 구축 프로세스

territory 관리를 설정하는 표준 흐름은 다음과 같다. (사전에 위 **전제조건** — Sales Territories 활성화 — 이 완료돼 있어야 한다.)

1. **territory type 생성** — territory를 분류하는 유형 정의.
2. **territory model 구축** — territory hierarchy와 배정 요소를 담는 모델 생성.
3. **account assignment rule 추가·테스트** — 규칙으로 account를 territory에 자동 배정하고 결과를 검증.
4. **모델 활성화(activate)** — 계획 상태의 모델을 실제 운영 모델로 전환.
5. **account·lead·user 배정** — 활성 모델에 실제 배정 적용.

## 핵심 구성 요소

| 요소 | 설명 |
|---|---|
| **Territory Model** | territory 관리 계획의 모든 요소(territory hierarchy, account·lead·user 배정, territory forecast)를 조직한다. 계획용으로 여러 모델을 둘 수 있으나 **활성 모델은 하나뿐**이다. |
| **Territory Hierarchy** | territory들의 계층 구조. 상위·하위 territory 관계를 나타낸다. |
| **Account/Lead Assignment Rule** | account·lead를 territory에 자동 배정하는 규칙. |
| **활성 모델(접근 제어)** | 활성화된 모델은 sales rep의 접근을 **자신에게 배정된 account·lead·opportunity로 제한**한다. |

## Forecast 통합

territory model을 **Collaborative Forecasts** 와 함께 활성화하면 **territory hierarchy 기반 territory forecast** 를 얻는다. 계층 구조를 따라 각 territory 단위로 예측을 집계할 수 있다.

> 예측 메커니즘 세부는 [[Collaborative Forecasts (예측)]] 참조.

## 한도·주의

| 항목 | 한도 |
|---|---|
| **model당 territory 수 (Enterprise Edition)** | 최대 **1,000** |
| **model당 territory 수 (Performance·Unlimited Edition)** | 최대 **20,000** |

- 위 하드 한도를 초과해야 하면 **Salesforce Support에 요청**해야 한다.
- 활성 모델은 조직당 **하나뿐**이며, 나머지 모델은 계획(planning) 상태로 유지된다.

## 구조 개념도

```
// 구조 예시 — Enterprise Territory Management(실제 원본 다이어그램 아님)
Territory Type → Territory Model(하나만 활성)
   Territory Hierarchy(계층)
     ├─ Account/Lead Assignment Rules(자동 배정)
     ├─ User 배정
     └─ Territory Forecast(Collaborative Forecasts 통합)
활성 모델 = rep 접근을 배정된 account·lead·opportunity로 제한
```

> territory type·assignment rule의 관리 세부 절차는 [공식 문서](https://help.salesforce.com/s/articleView?id=sales.tm2_intro.htm&type=5)를 참조한다.

## 관련 노트
- [[Sales Cloud 개요]] — Sales Cloud 시리즈 허브
- [[Collaborative Forecasts (예측)]] — territory forecast의 짝
- [[Accounts & Contacts (거래처·연락처)]] — territory에 배정되는 account
