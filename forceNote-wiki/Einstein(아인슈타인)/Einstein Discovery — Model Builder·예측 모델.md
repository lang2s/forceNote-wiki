---
tags: [Einstein, EinsteinDiscovery, ModelBuilder, CRMAnalytics, PredictiveAI, PrescriptiveAnalytics]
source: help.salesforce.com analytics.bi_edd / bi_edd_model_about / bi_edd_glossary.htm (2026-07-18 접속, Tier 2)
created: 2026-07-18
aliases: [Einstein Discovery, Model Builder, 예측 모델, Story, Discovery 스토리, 예측형 분석]
---

# Einstein Discovery — Model Builder·예측 모델

> 통계 모델링과 supervised ML로 비즈니스 데이터의 인사이트를 발견하고, 미래 결과를 예측(predictive)하며 개선 방법을 제안(prescriptive)하는 CRM Analytics 예측형 AI. "Story"는 이제 **model**로 리브랜딩되었다.

---

## 리브랜딩 — "stories are now models"

> PDF 원문(NOTE): "Einstein Discovery stories are now models. We wish we could snap our fingers to update the name everywhere, but you can expect to see the previous name in a few places until we replace it."

- 기능명은 여전히 **Einstein Discovery**.
- 구 개념 **Story → 현 Model**로 명칭 변경. 문서 곳곳에 옛 이름(Story)이 아직 남아 있다고 공식 명시.
- **Model Builder**는 별도 제품명이라기보다 Einstein Discovery의 모델 생성·관리 흐름(Create and Manage Models)을 가리킨다.

---

## Discovery 개념 — 4가지 분석

Einstein Discovery는 통계 모델링과 supervised machine learning으로 비즈니스 데이터의 인사이트를 식별·표면화·시각화한다. predictive·prescriptive 분석으로 미래 결과를 예측하고, 예측 결과를 개선할 방법을 제안한다.

| 분석 유형 | 무엇을 답하나 | 정의 |
|---|---|---|
| **Descriptive** | 무슨 일이 일어났나 (what happened) | 과거 데이터에서 descriptive analytics로 도출한 인사이트. 예: Einstein Discovery in Reports가 리포트에 대해 descriptive insight 생성. |
| **Diagnostic** | 왜 일어났나 (why) | 모델에서 도출한 인사이트. 상관관계를 파고들어 어떤 변수가 결과에 가장 크게 영향을 줬는지 이해. 여기서 "why"는 높은 통계적 **상관**을 뜻하며 반드시 인과관계는 아니다. |
| **Predictive** | 무슨 일이 일어날까 | AI·ML·predictive modeling·통계 기법으로 과거·현재 데이터를 분석해 패턴을 식별하고 확률적 미래 결과를 예측. |
| **Prescriptive** | 어떻게 개선하나 | 예측 결과를 개선할 액션(improvements)을 제안. |

예측형(비생성형) 전면 도구다 — supervised ML 기반. 생성형 요소는 없다.

---

## About Models

**Model**은 Einstein Discovery가 특정 결과를 예측하기 위해 사용하는 정교한 커스텀 수학적 구조물이다. 모델은 입력(하나 이상의 explanatory variable)을 받아 출력(예측 결과, top factor, improvement)을 낸다. 모델을 만들면 Einstein Discovery가 predictive·prescriptive 분석을 생성한다.

data mining·machine learning·predictive statistical modeling 기반:
- **Predictive analytics** — 과거 결과의 종합 분석을 바탕으로 미래 결과를 예측하는 실무.
- **Prescriptive analytics** — 예측 결과를 개선할 방법(improvements)을 제안하는 실무.

### 모델 유형 (3종)

모델 유형은 story(model)에 쓰인 outcome variable에 따라 결정된다.

| 유형 | 대상 필드 | 설명 |
|---|---|---|
| **Numeric** | Numeric 필드(measure) | 다양한 값을 가질 수 있는 숫자 필드 예측 = 자체 품질 지표를 가진 **regression** 문제. |
| **Binary Classification** | 두 개의 정성적 값을 가진 categorical(text) 필드 | true/false, public/private, churned/not churned처럼 데이터를 두 그룹으로 분리. **binary classification** 문제. |
| **Multiclass Classification** | **3~10개**의 가능한 class(outcome)를 가진 categorical(text) 필드 | 예: 제조사가 고객 속성 기반으로 6개 서비스 계약 중 어느 것을 고를지 예측. |

### 핵심 컨테이너 — prediction definition

- **prediction definition** — 하나 이상의 model을 담는 Einstein Discovery의 컨테이너 객체. 여러 모델을 담으면 각 모델이 데이터의 서로 다른 segment에 대한 예측을 생성한다. **prediction definition은 최대 10개의 active model을 담을 수 있다.**

> PDF 원문: "A prediction definition can contain up to ten active models."

- **segmentation** — 데이터의 서로 다른 segment(부분집합)를 타깃하는 모델을 배포하는 것. 예: 대/중/소 고객이 있고 조직이 고객 규모별로 구성돼 있으면, 각 그룹별로 별도 모델을 만들어 배포. filter로 각 그룹의 조건을 정의하는 segment로 지정. segmentation은 여러 모델을 담은 prediction definition을 수반한다.

### 모델 작업 시 고려사항

- numeric 변수인데 분석 중 Einstein Discovery가 **low cardinality(고유값 10개 이하)**를 발견하면, 생성 모델에서 이 변수의 데이터 타입은 numeric이 아니라 **text**가 된다.

---

## 배포·소비 경로

모델이 Salesforce에 배포된 후, Einstein Discovery는 이를 이용해 여러 방식으로 예측 결과와 개선 제안을 얻는다.

- **Lightning record page / Experience Cloud site page** — 예측 표시 (Automated Prediction Writeback 포함)
- **Flow Builder** — flow에서 예측 획득
- **Process Automation Formulas** — 프로세스 자동화 수식에서 예측 획득
- **Apex** — Apex에서 예측 획득
- **Einstein Prediction Service (REST 또는 Apex API 호출)** — 예측·improvement를 프로그래밍 방식으로 검색
- **Tableau** — Tableau 대시보드·calculated field·flow에 예측 임베드
- **CRM Analytics Data Prep** — recipe에서 예측 획득

```
// 구조 예시 — 실제 동작 코드/스키마 아님 (개념 관계도)
prediction definition (컨테이너, 최대 10 active model)
 ├─ model A  ← segment: 대형 고객   (outcome variable: Renewal)
 ├─ model B  ← segment: 중형 고객
 └─ model C  ← segment: 소형 고객
       입력: predictor variables(explanatory) →
       출력: prediction(점수) + top predictors + improvements(actionable)
             → prediction field / prediction column 에 저장
             → Lightning page · Flow · Apex · Prediction Service(REST/Apex) · Tableau 로 소비
```

> Einstein Prediction Service(REST/Apex)는 [[Einstein Prediction Builder]]와 공유되는 소비 계층이다. CRM Analytics recipe의 ML(예측) 노드로 예측을 데이터 파이프라인에 넣는 방법은 [[Recipe REST API — Load·Save·Output·ML 노드 Input]] 참조.

---

## 라이선스 · 에디션

- **Required License:** CRM Analytics Plus license **또는** Einstein Predictions license (둘 다 추가 비용).
- **Available in:** Lightning Experience
- **Supported Editions:** Enterprise, Performance, Unlimited, Developer

플랫폼·API·라이선스 전반 개요는 [[CRM Analytics 개요]] 참조.

---

## 핵심 용어집 (예측형)

소스 glossary에서 발췌한 예측형 핵심 용어. (전체 glossary에는 R2·RMSE·MAE·bias/disparate impact·holdout·cross-validation 등 품질/편향 지표가 더 있음 — 필요 시 후속 발췌.)

### 변수 유형

| 용어 | 정의 |
|---|---|
| **Outcome Variable** | 모델에서 분석·예측의 단일 primary focus로 선택된 컬럼. 모델의 목표는 이 outcome variable을 최대화 또는 최소화하는 것. response·target variable·dependent variable로도 불림. |
| **Explanatory Variable** | outcome variable에 영향을 줄 수 있는지·정도를 탐색하는 변수. Einstein Discovery가 explanatory variable과 outcome variable 사이 통계적 연관을 계산. input variable·feature·predictor variable·independent variable로도 불림. |
| **Predictor (Predictor Variable)** | 모델이 입력으로 기대하는 변수. 예측 요청은 모델이 요구하는 각 predictor 값을 전달하고, 모델의 equation이 그 입력으로 예측을 출력. feature·independent variable로도 불림. |
| **Actionable Variable** | 사람이 통제할 수 있는 explanatory variable (예: 특정 고객에 어떤 마케팅 캠페인을 쓸지). 통제 불가한 변수(고객 주소·나이 등)와 대비. actionable로 지정되면 모델이 prescriptive analytics로 improvement를 제안. |
| **Proxy Variable** | outcome variable 관점에서 다른 explanatory variable과 높은 상관을 갖는 변수. 예: 대출 신청자의 주소가 민족 같은 protected characteristic과 높은 상관이면 편향을 반영할 수 있다. Einstein Discovery가 proxy variable을 식별하도록 도와, 편향을 모델·인사이트·예측에서 제거하게 한다. |

### 예측·개선

| 용어 | 정의 |
|---|---|
| **Prediction** | 모델이 생성한 파생 값으로, 가능한 미래 결과를 나타냄. 모델이 받는 predictor 변수 입력에 기반한 predictive model의 출력. |
| **Top Predictor** | 예측 결과를 가장 유의하게 이끄는 condition. condition은 변수와 연관된 데이터 값. Einstein Discovery에서 predictor는 1~2개의 condition으로 구성. |
| **Improvement** | prescriptive analytics 기반의 제안 액션으로, 원하는 결과의 likelihood를 높인다. actionable variable과 연관. prescription과 유사. |
| **Actual Outcome** | outcome이 발생한 후 관측치 outcome variable의 실제 값. Einstein Discovery는 예측 결과가 실제 결과에 얼마나 가까운지 비교해 모델 성능을 계산. observed outcome이라고도 함. |

### 배포·저장

| 용어 | 정의 |
|---|---|
| **Prediction Definition** | 하나 이상의 모델을 담는 부모 리소스(Einstein Prediction Service). 여러 모델을 담으면 각 모델이 데이터의 다른 segment에 대한 예측을 생성. (최대 10 active model) |
| **Prediction Field** | Einstein이 Salesforce 객체의 예측 점수를 저장하는 필드. 배포 중 Einstein이 자동 생성(automated prediction field)하거나, 나중에 커스텀 prediction field를 생성. |
| **Prediction Column** | CRM Analytics 데이터셋에서 Einstein Discovery가 모델이 반환한 예측 값을 저장하는 컬럼. |

### 통계·알고리즘

| 용어 | 정의 |
|---|---|
| **Imputation** | 결측 numeric 값을 데이터의 다른 부분집합에서 파생된 값으로 대체하는 통계 기법. imputation을 켜면 결측치 관측도 분석 시 안전하게 계산됨. |
| **Modeling Algorithm** | Einstein Discovery가 모델을 만드는 데 쓰는 알고리즘. generalized linear model(GLM)은 regression 기반, gradient boosting machine(GBM)·XGBoost는 decision tree 기반. |
| **R2** | regression 모델이 outcome의 변동을 설명하는 능력을 측정. 하나 이상의 explanatory variable로 예측 가능한 outcome variable 분산의 비율. |

---

## 관련 노트

- [[Einstein 예측형 AI 개요 — 예측 vs 생성형·도구 지도]] — 예측형 AI 도구 지도
- [[Einstein Prediction Builder]] — point-click 예측(Einstein Prediction Service 소비 계층 공유)
- [[Next Best Action — Strategy Builder·Recommendations]] — Enhance 요소로 Discovery 예측을 추천에 결합
- [[CRM Analytics 개요]] — 플랫폼·라이선스 상위 컨텍스트
- [[Recipe REST API — Load·Save·Output·ML 노드 Input]] — 데이터 파이프라인의 ML(예측) 노드 연계
- [[ConnectApi CdpMachineLearning — Data 360 ML 예측]] — Data 360(Data Cloud) ML 예측 Apex API. Einstein Discovery(`SmartDataDiscovery.predict`)와 별개 계열.
- [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]] — 이 모델의 품질(RMSE·AUC·GINI 등)·편향(Disparate Impact·Potential Bias) 지표를 REST로 조회하는 응답 표현형 레퍼런스.
