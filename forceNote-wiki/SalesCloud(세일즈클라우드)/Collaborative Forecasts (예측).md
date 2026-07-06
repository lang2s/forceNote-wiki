---
tags: [sales-cloud, forecasting, collaborative-forecasts, quotas, forecast-types]
source: help.salesforce.com (Salesforce Help — Collaborative Forecasts / Elements / Quotas / Forecast Types / Adjustments; 라이브 공식 문서, Tier 2, 접속 2026-07-03) + help.salesforce.com (Turn On Salesforce Forecasting and Define Forecast Settings; Show Quota Information in Collaborative Forecasts; Tier 2, 접속 2026-07-04) + help.salesforce.com (Enable Users in Collaborative Forecasts; Set Up Your Forecast Hierarchy in Collaborative Forecasts; Tier 2, 2026-07-06)
official_doc: https://help.salesforce.com/s/articleView?id=sf.forecasts3_overview.htm&type=5
created: 2026-07-03
aliases: [Collaborative Forecasts, 예측, 매출 예측, Forecast Types, Forecast Category, Quota, 할당량, Forecast Adjustment, Territory Forecast]
---

# Collaborative Forecasts (예측)

> opportunity 파이프라인을 기반으로 매출을 예측하는 Sales Cloud 기능. forecast type·category별로 예측을 집계하고, quota(할당량) 대비 진척을 보며, adjustment로 예측치를 보정한다.

---

## ⚠️ 전제조건 — 예측 활성화 (기본 비활성)

Collaborative Forecasts는 **기본으로 비활성**이다. 아래를 켜기 전에는 예측 탭 자체가 나타나지 않으며, forecast type·quota·adjustment를 사용할 수 없다.

1. **Setup → Quick Find에 `Forecast Settings` 입력 → Enable Forecasts**를 켠다.
2. 예측할 **forecast type을 추가·활성화**한다 — 각 유형에 예측할 **measure와 hierarchy(집계 기준)를 지정**해야 한다. forecast type을 하나 이상 활성화해야 예측 탭이 표시된다.
3. **예측에 참여할 사용자마다 User 레코드의 `Allow Forecasting`(예측 허용) 체크를 활성화**한다. org 레벨(1·2번)을 켜도 **이 체크가 꺼진 사용자는 forecast hierarchy에 나타나지 않는다** — "설정은 다 켰는데 특정 사용자가 예측 계층에 안 보인다"의 대표 함정이므로 가장 먼저 확인할 항목이다.

**Forecast hierarchy 구성** — Setup → Quick Find에 `Forecasts Hierarchy` 입력 → **Forecasts Hierarchy 페이지**에서 예측 계층을 구성한다. 예측 계층은 **user role hierarchy를 바탕으로** 만들어지며, 이 페이지에서 role별 **Enable Users**로 참여 사용자를 활성화(= 3번의 Allow Forecasting을 일괄 처리)하고, 하위 예측이 롤업되는 매니저 role에는 **forecast manager를 지정**한다. forecast manager로 지정된 사용자만 자기 아래 계층의 예측을 보고 조정(adjust)할 수 있다. `Allow Forecasting`이 켜진 사용자만 이 계층에서 선택 대상이 된다.

> 근거: [Turn On Salesforce Forecasting and Define Forecast Settings](https://help.salesforce.com/s/articleView?id=sales.forecasts3_defining_forecasts_settings.htm&type=5) · "Enable Users in Collaborative Forecasts" · "Set Up Your Forecast Hierarchy in Collaborative Forecasts" (help.salesforce.com, Tier 2)

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

### ⚠️ Quota 표시는 기본 숨김 — 'Show Quotas' 활성화 필요

Quota는 **기본으로 예측 페이지에 숨겨져 있다.** 관리자가 **Forecast Settings에서 'Show Quotas'를 켜야** 예측 페이지에 quota와 달성률이 나타난다(Show Quota Information in Collaborative Forecasts). 이 표시 옵션을 켜기 전에는 할당량이 예측 화면에 나오지 않는다.

활성화하면 이 목표치가 예측 화면에서 각 기간의 예측 금액과 나란히 표시되어, quota 대비 진척(달성률)을 한눈에 확인할 수 있게 된다.

> 근거: [Show Quota Information in Collaborative Forecasts](https://help.salesforce.com/s/articleView?id=sf.forecasts3_enabling_quotas_in_forecasts.htm&type=5) (Tier 2)

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
