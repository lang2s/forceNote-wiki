---
tags: [sales-cloud, forecasting, collaborative-forecasts, quotas, forecast-types]
source: help.salesforce.com (Salesforce Help — Collaborative Forecasts / Elements / Quotas / Forecast Types / Adjustments; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.forecasts3_overview.htm&type=5
created: 2026-07-03
aliases: [Collaborative Forecasts, 예측, 매출 예측, Forecast Types, Forecast Category, Quota, 할당량, Forecast Adjustment, Territory Forecast]
---

# Collaborative Forecasts (예측)

> opportunity 파이프라인을 기반으로 매출을 예측하는 Sales Cloud 기능. forecast type·category별로 예측을 집계하고, quota(할당량) 대비 진척을 보며, adjustment로 예측치를 보정한다.

---

## 개념

**Collaborative Forecasts**는 org의 **opportunity 파이프라인을 기반으로 매출을 예측**하는 Sales Cloud 기능이다. 영업 담당자와 관리자는 예측을 통해 각 기간(월/분기)의 매출 목표 달성 여부를 추적하고, 실제 파이프라인 대비 예측치를 조정하며, 조직 계층을 따라 집계된 예측을 함께 검토한다.

예측은 다음 네 가지 축으로 구성된다.

- **Forecast Types** — 무엇을(어떤 measure를) 어떤 계층 기준으로 예측할지 정의하는 예측 유형
- **Quotas** — 사용자/territory에 배정하는 기간별 매출 목표(할당량)
- **Forecast Adjustments** — 과대/과소 평가된 예측치를 보정
- **Territory Forecasts** — territory hierarchy 기반 예측(Enterprise Territory Management 통합 시)

---

## Forecast Types (예측 유형)

org에는 여러 개의 **pipeline forecast type**을 활성화할 수 있으며, 각 유형은 서로 다른 measure와 집계 기준을 가진다.

- **Sales Territories(Enterprise Territory Management)를 사용하면 territory hierarchy 기반으로 예측**할 수 있다 → Territory forecasts.
- 일반 forecast type은 **user role hierarchy**를 따라 집계되지만, **Territory forecast는 user role hierarchy가 아니라 territory hierarchy를 기준**으로 집계된다는 점이 다르다.
- **Territory forecast는 Lightning Experience와 Salesforce mobile app에서 active territory model만 지원**한다.

> Territory forecast의 territory hierarchy 상세는 [[Territory Management (영역 관리)]] 참조.

---

## Quotas (할당량)

**Quota**는 사용자 또는 territory에 배정되는 **월별/분기별 매출 목표**다.

- Quota 데이터는 **revenue(매출), quantity(수량), 또는 custom measure**를 사용할 수 있다.
- **여러 forecast type이 활성화되어 있으면, 각 forecast type이 별도의 quota 정보를 유지**한다. 즉 하나의 사용자가 여러 예측 유형에 대해 각기 다른 할당량을 가질 수 있다.

이 목표치는 예측 화면에서 각 기간의 예측 금액과 나란히 표시되어, quota 대비 진척(달성률)을 한눈에 확인할 수 있게 한다.

---

## Forecast Adjustments (예측 조정)

예측치가 실제 상황보다 과대 혹은 과소 평가되었다고 판단될 때, 관리자·담당자는 예측 값을 **조정(adjust)**하여 quota·forecast 달성 경로를 더 정확히 파악한다.

조정 대상이 되는 예측 값은 다음과 같다.

- **Best Case** — 낙관적 시나리오 예측
- **Most Likely** — 가장 가능성 높은 예측
- **Commit** — 확약(달성을 약속하는) 예측

조정은 원본 opportunity 데이터를 바꾸지 않고, 예측 롤업 값 위에 별도의 보정치를 얹는 방식으로 반영된다.

---

## Territory Forecasts와 Enterprise Territory Management 통합

**Collaborative Forecasts**와 **Enterprise Territory Management** 두 기능을 함께 활성화하면 **territory forecast**를 얻는다. 이때 예측 집계 기준이 user role hierarchy에서 territory hierarchy로 바뀌며, active territory model을 기준으로 예측이 롤업된다.

---

## 구조 개요

```
// 구조 예시 — Collaborative Forecasts(실제 원본 다이어그램 아님)
Opportunity 파이프라인 → Forecast (type별 집계)
   Forecast Types: 여러 유형 + Territory(territory hierarchy 기반, active model)
   Quota(월/분기 목표: revenue·quantity·custom) — type별 별도 유지
   Adjustment: Best Case · Most Likely · Commit 보정
```

---

## 관련 노트
- [[Sales Cloud 개요]] — Sales Cloud 시리즈 허브
- [[Opportunities (기회)]] — 예측의 소스가 되는 파이프라인
- [[Territory Management (영역 관리)]] — territory forecast의 territory hierarchy 기준
