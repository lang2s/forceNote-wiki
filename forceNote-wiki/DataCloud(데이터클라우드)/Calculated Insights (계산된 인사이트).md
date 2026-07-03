---
tags: [data-cloud, data-360, calculated-insights, metrics, kpi]
source: help.salesforce.com (Salesforce Help — Calculated Insights in Data Cloud; 라이브 공식 문서, Tier 2, 접속 2026-07-03)
official_doc: https://help.salesforce.com/s/articleView?id=sf.c360_a_calculated_insights.htm&type=5
created: 2026-07-03
aliases: [Calculated Insights, 계산된 인사이트, 지표, KPI, Metrics]
---

# Calculated Insights (계산된 인사이트)

> Data Cloud 전체 데이터셋에 대해 지표·KPI를 계산하는 기능. unified profile·DMO 위에서 다차원 metric을 정의해 세그먼트·액티베이션·identity resolution 진단에 활용한다.

---

## 개념

**Calculated Insight(CI)** 는 Data Cloud 데이터 모델(DMO·unified profile) 위에서 **metric·측정값**을 계산하는 기능이다. 하나의 CI는 두 종류의 요소로 구성된다:

- **Dimension(차원)** — metric을 분류·집계하는 기준 축 (예: data source, contact point 유형).
- **Measure(측정값)** — 실제로 계산되는 수치 metric (예: 통합률, 프로파일당 contact point 수).

CI는 개별 레코드가 아니라 **Data Cloud 전체 데이터셋**에 대해 다차원 metric을 산출하므로, 조직 단위의 지표·KPI를 정의하는 데 쓰인다.

```
// 구조 예시 — Calculated Insights(실제 원본 다이어그램 아님)
DMO / Unified Profile ──▶ Calculated Insight (dimension + measure)
   활용: Segment 기준 · Activation · Identity Resolution 진단
   예: Consolidation Rate · Outlier Profiles · Contributing Contact Points
```

> CI 정의 문법·SQL 세부는 이 노트 범위 밖 — [공식 문서](https://help.salesforce.com/s/articleView?id=sf.c360_a_calculated_insights.htm&type=5) 참조.

---

## 활용

계산된 CI는 다음 세 가지 흐름에서 사용된다:

- **Segment 기준** — CI로 산출한 metric을 세그먼트 정의 조건으로 사용한다.
- **Activation** — CI 값을 액티베이션(외부 시스템으로의 세그먼트 전달)에 활용한다.
- **Identity Resolution 진단** — identity resolution 결과의 품질을 진단하는 데 사용한다.

또한 CI는 **Data Cloud 리포트**로 분석할 수 있다.

---

## Identity Resolution 진단용 CI 예시

Identity resolution 결과의 품질을 점검하기 위해 다음과 같은 CI를 정의해 활용한다:

| CI | 목적 | 시점 |
|---|---|---|
| **Consolidation Rates for Unified Profiles** | data source별 매칭 프로파일 **통합률** 측정 | unified profile 생성 후 |
| **Outlier Unified Profiles** | unified profile당 매칭 contact point 수가 많으면 **품질 문제 신호** | unified profile 생성 후 |
| **Contributing Contact Points** (데이터 품질) | Contact Point Address/Email/Phone·Party Identification의 **반복 값** 점검 | 데이터 수집 후·ruleset 생성 전 |

- **Consolidation Rates for Unified Profiles** — data source별로 매칭된 프로파일이 unified profile로 얼마나 통합되었는지(통합률)를 계산한다. unified profile이 생성된 후에 확인한다.
- **Outlier Unified Profiles** — 하나의 unified profile에 매칭된 contact point 수가 지나치게 많은 경우, 이는 데이터 품질 문제의 신호일 수 있다.
- **Contributing Contact Points** — 데이터 품질 점검용. Contact Point Address, Contact Point Email, Contact Point Phone, Party Identification의 반복 값을 점검한다. 데이터 수집 후, ruleset(match rule 집합) 생성 전에 확인한다.

---

## 관련 노트
- [[Data Cloud 개요]] — Data Cloud 시리즈 허브
- [[Identity Resolution (아이덴티티 해석)]] — CI로 결과 진단
- [[Segments (세그먼트)]] — CI를 세그먼트 기준으로 사용
