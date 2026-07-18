---
tags: [einstein, einstein-discovery, crm-analytics, rest-api, model-metrics, bias, disparate-impact, reference]
source: bi_dev_guide_rest_sdd.pdf (Einstein Discovery REST API Developer Guide)
created: 2026-07-18
aliases: [Einstein Discovery Metrics, Training Metrics, Disparate Impact, 모델 품질 지표, 편향 지표, RMSE MAE AUC, Story Potential Bias, disparate impact]
---

# Einstein Discovery REST — 모델 품질·편향 지표 표현형

> Einstein Discovery 모델의 품질 지표(회귀 RMSE·MAE·R²·잔차 / 분류 AUC·GINI·MCC·TP/FP/TN/FN rate)와 공정성·편향 지표(Disparate Impact·Potential Bias)를 담는 Einstein Discovery REST API 응답 표현형(response representation) 레퍼런스.

---

## 개요

Einstein Discovery REST API는 학습된 AI 모델의 **품질**과 **공정성(편향)** 을 조회하는 응답 표현형 계열을 제공한다. 이 노트는 그 표현형들의 프로퍼티를 소스 대비 전수 정리한 레퍼런스다. 표현형이 평가 대상으로 삼는 모델의 개념·저작은 [[Einstein Discovery — Model Builder·예측 모델]]을, REST 계열 전체의 인증·엔드포인트 지도는 [[CRM Analytics REST API — 개요·인증·asset 엔드포인트 지도]]를 참조한다.

핵심 구조 두 가지:

1. **품질 지표는 예측 타입별로 분리된다.** 추상 표현형 `AI Model Metrics`(base)를 상속하여 `Classification Metrics`(이항 분류), `Multiclass Metrics`(다중 분류), `Regression Metrics`(회귀)로 나뉜다. AUC·GINI·MCC 같은 분류 지표와 RMSE·R²·잔차 같은 회귀 지표는 **각 예측 타입 표현형에만** 존재한다.

2. **편향/공정성 지표는 별도 계열이다.** `Disparate Impact`(불균형 영향)와 `Potential Bias`(잠재 편향)는 품질 지표가 아니라 story 인사이트 계열의 표현형으로 존재하며, 상위 인사이트 표현형(`Story First Order Insights` 등)이 이들을 담는다.

> ⚠️ **자주 하는 오해 — "Training Metrics"에는 상세 지표가 없다.** `Training Metrics` 표현형은 프로퍼티가 **`mae` · `rowCount` · `value` 3개뿐**이다. RMSE·AUC·GINI·MCC 등 상세 품질 지표는 이 표현형이 아니라 **예측 타입별 Metrics 표현형**(Classification / Regression Metrics)에 담긴다. `Training Metrics`에서 세부 지표를 찾으려 하면 안 된다.

> Filter Group (Small): 이 가이드의 표현형들은 각 프로퍼티에 도입 버전(Available Version)을 명시한다. 아래 표의 마지막 열이 그 버전이다.

### 표현형 계층 (구조 예시)

```jsonc
// 구조 예시 — 실제 동작 설정 아님 (표현형 상속·중첩 관계를 나타낸 트리)
AI Model Metrics (abstract, base)
├── dataSegmentsUrl, featureImportancesUrl, predictionType, url
├──▶ Classification Metrics   // + auc, gini, mcc, TP/FP/TN/FN rate
├──▶ Multiclass Metrics       // base만 상속 (고유 프로퍼티 없음)
└──▶ Regression Metrics       // + mae, rmse, rsquared, residualsUrl

Metrics Collection
├── liveMetrics ──▶ Live Metrics ──▶ disparateImpacts[] ──▶ Live Metric Detail
└── trainingMetrics ──▶ Training Metrics { mae, rowCount, value }  // 3개뿐

Story First Order Insights
├── correlation, significantlyDifferent
├── storyHistory ──▶ Story Query Disparate Impact ──▶ Disparate Impact Detail[]
└── potentialBias[] ──▶ Story Potential Bias
```

---

## 모델 품질 지표

### Abstract AI Model Metrics (base)

`SmartDataDiscoveryAIModelMetrics` — The base Einstein Discovery AI model metric. 아래 Classification / Multiclass / Regression Metrics가 이 표현형을 상속한다.

| Property Name | Type | Description | Available Version |
|---|---|---|---|
| `dataSegmentsUrl` | String | The URL to the data segments metrics for the AI model. | 56.0 |
| `featureImportancesUrl` | String | The URL to the feature importances metrics for the AI model. | 56.0 |
| `predictionType` | SmartDataDiscoveryPredictionTypeEnum | The prediction type of the AI model. Valid values: `Classification` / `MulticlassClassification` / `Regression` / `Unknown` | 54.0 |
| `url` | String | The URL for the metrics | 54.0 |

### Classification Metrics

The binomial classification metrics for an Einstein Discovery AI model. **Abstract AI Model Metrics 상속** + 아래 고유 프로퍼티.

| Property Name | Type | Description | Available Version |
|---|---|---|---|
| `auc` | Double | The AUC for the model. | 54.0 |
| `falseNegativeRate` | Double | The false negative rate for the model. | 54.0 |
| `falsePositiveRate` | Double | The false positive rate for the model. | 54.0 |
| `gini` | Double | The GINI for the model. | 54.0 |
| `mcc` | Double | The MCC for the model. | 54.0 |
| `trueNegativeRate` | Double | The true negative rate for the model. | 54.0 |
| `truePositiveRate` | Double | The true positive rate for the model. | 54.0 |

### Multiclass Metrics

The multiclass metrics for an Einstein Discovery AI model. **Abstract AI Model Metrics만 상속하며 고유 프로퍼티가 없다.** (base의 `dataSegmentsUrl` · `featureImportancesUrl` · `predictionType` · `url` 이외에 추가 프로퍼티 없음.)

### Regression Metrics

The regression metrics for an Einstein Discovery AI model. **Abstract AI Model Metrics 상속** + 아래 고유 프로퍼티.

| Property Name | Type | Description | Available Version |
|---|---|---|---|
| `mae` | Double | The MAE for the model. | 54.0 |
| `residualsUrl` | String | The residuals URL for the model. | 55.0 |
| `rmse` | Double | The RMSE for the model. | 54.0 |
| `rsquared` | Double | The R Squared for the model. | 54.0 |

### Live Metric Detail

`SmartDataDiscoveryLiveMetricDetail` — A live AI Einstein Discovery metric.

| Property Name | Type | Description | Available Version |
|---|---|---|---|
| `endDate` | Date | The end date of this metric. | 50.0 |
| `rowCount` | Integer | The row count of this metric. | 50.0 |
| `startDate` | Date | The start date of this metric. | 50.0 |
| `value` | Map<Object,Object> | The complex value of this metric represented as a Map. | 50.0 |

### Live Metrics

`SmartDataDiscoveryLiveMetrics` — The categorized live AI Einstein Discovery metrics. 각 프로퍼티는 `Live Metric Detail`의 리스트다. `disparateImpacts`가 편향 지표를 라이브로 집계한다.

| Property Name | Type | Description | Available Version |
|---|---|---|---|
| `disparateImpacts` | SmartDataDiscoveryLiveMetricDetail[] | A list of disparateImpact metrics during the span. | 55.0 |
| `missingColumns` | SmartDataDiscoveryLiveMetricDetail[] | A list of missing column metrics during the span. | 50.0 |
| `outOfBoundsColumns` | SmartDataDiscoveryLiveMetricDetail[] | A list of out of bounds column metrics during the span. | 50.0 |
| `predictions` | SmartDataDiscoveryLiveMetricDetail[] | A list of the total predictions during the span. | 50.0 |
| `warnings` | SmartDataDiscoveryLiveMetricDetail[] | A list of the total warnings during the span. | 50.0 |

### Metrics Collection

A collection of Einstein Discovery metrics. 라이브 지표(`liveMetrics`)와 학습 지표(`trainingMetrics`)를 함께 담는 최상위 컬렉션이다.

| Property Name | Type | Description | Available Version |
|---|---|---|---|
| `liveMetrics` | SmartDataDiscoveryLiveMetrics | The live metrics from running predictions. | 50.0 |
| `totalActiveModels` | Integer | The total number of active models. | 51.0 |
| `totalModels` | Integer | The total number of models. | 51.0 |
| `trainingMetrics` | SmartDataDiscoveryTrainingMetrics | The model level metrics from training. | 50.0 |
| `url` | Integer¹ | The URL to get the metrics results. | 50.0 |

> ¹ **원문 표기 보존:** PDF 원문에서 `url` 프로퍼티의 타입이 `Integer`로 표기돼 있다(URL 문자열임에도). 오기로 보이나 소스 그대로 보존한다.

### Training Metrics

`SmartDataDiscoveryTrainingMetrics` — A collection of Einstein Discovery metrics from training a model. **프로퍼티는 정확히 아래 3개뿐이다.**

| Property Name | Type | Description | Available Version |
|---|---|---|---|
| `mae` | Double | The mean absolute error (mae) training metric. | 50.0 |
| `rowCount` | Integer | The number of rows this model was trained on. | 50.0 |
| `value` | Map<Object,Object> | The complex value of this training metric represented as a Map. | 50.0 |

> `precision` · `recall` · `f1` · `mape` · `mse` · `logLoss` · `accuracy` · `holdout` 같은 프로퍼티는 이 표현형(및 이 응답 바디)에 **존재하지 않는다.** 상세 품질 지표는 위의 예측 타입별 Metrics 표현형을 참조한다.

---

## 편향·공정성 지표

Disparate Impact(불균형 영향)는 특정 필드 값(예: 인구통계 그룹)이 예측 결과에서 불리하게 작용하는 정도를, Potential Bias(잠재 편향)는 편향 필드와 필터 필드 간 변이·유사도를 표현한다.

### Story Query Disparate Impact

A disparate impact for a story query.

| Property Name | Type | Description | Available Version |
|---|---|---|---|
| `details` | StoryQueryDisparateImpactDetail[] | A list of details for the disparate impact. | 54.0 |
| `referenceValue` | String | The reference field value used to calculate the disparate impact. | 54.0 |

### Story Query Disparate Impact Detail

The detail for a story query disparate impact.

| Property Name | Type | Description | Available Version |
|---|---|---|---|
| `adverseRatio` | Double | The adverse ratio value for a disparate impact. | 54.0 |
| `value` | String | The field value with adverse ratio. | 54.0 |

### Story Potential Bias

The potential bias for a story.

| Property Name | Type | Description | Available Version |
|---|---|---|---|
| `biasField` | StoryFieldLabelValueProperty | The details for the bias field. | 54.0 |
| `biasFieldVariation` | Double | The variation for the bias field. | 54.0 |
| `combinedVariation` | Double | The combined variation for the bias field and the filter field. | 54.0 |
| `filterFieldVariation` | Double | The variation for the filter field. | 54.0 |
| `similarity` | Double | The similarity between the bias field and the filter field. | 54.0 |

---

## 편향 지표를 담는 상위 인사이트

위 편향·공정성 표현형은 단독으로 반환되지 않고 story 인사이트 표현형에 중첩되어 반환된다.

### Story First Order Insights

The first order insights for a story. **Abstract Story Insights 상속**(`chart` / `details` / `filterField` / `narrative` / `type`) + 아래 고유 프로퍼티. `type`은 `InsightsResultsTypeEnum` (Valid values: `FirstOrder` / `SecondOrder`).

| Property Name | Type | Description | Available Version |
|---|---|---|---|
| `correlation` | Double | The correlation value with respect to the outcome variable. | 52.0 |
| `storyHistory`² | StoryQueryDisparateImpact | The disparate impact results for a story query. | 54.0 |
| `potentialBias` | StoryPotentialBias[] | A list of the potential bias results for a story query. | 54.0 |
| `significantlyDifferent` | Boolean | Indicates whether the insight is significantly different (true) or not (false). | 54.0 |

> ² **원문 표기 `storyHistory`** — 의미상 편향(disparate impact) 결과를 보유하는 프로퍼티이며 타입도 `StoryQueryDisparateImpact`이지만, PDF 원문의 프로퍼티 이름은 `storyHistory`다(plain·layout 양쪽 추출에서 동일 확인). `disparateImpact` 등으로 바꾸지 않고 원문대로 보존한다.

### Story Query Diagnostic Insights

A story query diagnostic insights.

| Property Name | Type | Description | Available Version |
|---|---|---|---|
| `changeInOutcome` | Double | The change in outcome because of selected condition. | 53.0 |
| `chart` | StoryChart | The chart for the diagnostic insight. | 54.0 |
| `conditionField` | StoryFieldLabelValueProperty | The condition selected for the diagnostic insight. | 53.0 |
| `details` | StoryDiagnosticInsightsDetail[] | A list of diagnostic insight records. | 53.0 |
| `details`³ | StoryQueryDisparateImpact | The disparate impact details for the diagnostic insight. | 54.0 |
| `narrative` | StoryNarrative | The disparate impact details for the diagnostic insight.⁴ | 54.0 |
| `outcomeClass` | String | The outcome class for the diagnostic insight. | 55.0 |
| `outcomeField` | SmartDataDiscoveryOutcome | The outcome field for the diagnostic insight. | 53.0 |
| `potentialBias` | StoryPotentialBias | The potential bias details for the diagnostic insight. | 54.0 |

> ³ **중복 `details` 원문 보존:** PDF 원문에 `details` 프로퍼티가 두 번 등장한다. 하나는 진단 인사이트 레코드 리스트(`StoryDiagnosticInsightsDetail[]`, v53.0), 다른 하나는 불균형 영향 상세(`StoryQueryDisparateImpact`, v54.0)다. 소스에 있는 그대로 둘 다 보존한다.
>
> ⁴ **복붙 설명 원문 보존:** `narrative`(타입 `StoryNarrative`)의 설명이 원문에서 "The disparate impact details for the diagnostic insight."로 표기돼 있다 — 위 `details`(v54.0)의 설명과 동일한 복사·붙여넣기로 보이나 소스 그대로 보존한다.

---

## 관련 노트

- [[Einstein Discovery — Model Builder·예측 모델]] — 이 지표들이 평가하는 Discovery 모델(개념·저작). 같은 폴더 형제.
- [[CRM Analytics REST API — 개요·인증·asset 엔드포인트 지도]] — Einstein Discovery REST는 CRM Analytics/BI REST 계열의 형제 가이드.
- [[ConnectApi CdpMachineLearning — Data 360 ML 예측]] — 예측 소비 Apex(별개 계열: Data 360 `CdpMl` vs Einstein Discovery `SmartDataDiscovery`). disambiguation.
