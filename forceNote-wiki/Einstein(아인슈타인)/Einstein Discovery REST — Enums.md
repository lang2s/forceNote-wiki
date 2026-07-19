---
tags: [einstein, einstein-discovery, rest-api, enums, reference]
source: bi_dev_guide_rest_sdd.pdf (Einstein Discovery REST API Developer Guide — Enums)
created: 2026-07-19
aliases: [Einstein Discovery REST Enums, SmartDataDiscovery Enum, predictionType, outcomeGoal, AIModelStatus, SortOrder, 열거형]
---

# Einstein Discovery REST — Enums

> Einstein Discovery REST API 열거형(enum) 64종 — 각 enum의 유효 값(Valid values) 전수 레퍼런스.

---

## 개요

`/smartdatadiscovery` 네임스페이스에 특화된 enum 64종의 전수 목록이다. 각 enum은 이름과 유효 값(Valid values)으로 구성되며, 표현형(Request/Response Bodies)·리소스 응답의 프로퍼티가 이 값들을 반환하거나 받는다.

> **버전 규칙 (원문 그대로):** Enums are not versioned. Enum Values are returned in all API versions. Clients should handle values they don't understand gracefully.
>
> 즉 enum 자체는 버전이 없고 값은 모든 API 버전에서 반환되므로, 클라이언트는 알지 못하는 값을 만나도 우아하게(gracefully) 처리해야 한다.

각 enum 값을 사용하는 표현형·리소스는 형제 노트(하단 [[#관련 노트]])를 참조한다.

### enum 값 사용 예 (형태)

```json
// 구조 예시 — 실제 동작 설정 아님
// 예: 예측 정의 컬렉션을 정렬·필터할 때 enum 값을 쿼리에 사용
{
  "sortOrder": "Ascending",                        // SmartDataDiscoverySortOrderEnum
  "sortOrderType": "PredictionType",               // PredictionDefinitionCollectionCollectionSortOrderTypeEnum
  "outcomeGoal": "Maximize",                        // ConnectSmartDataDiscoveryOutcomeGoalEnum
  "filterOperator": "GreaterThanOrEqual",          // ConnectSmartDataDiscoveryFilterOperatorEnum
  "predictionType": "Regression"                   // SmartDataDiscoveryPredictionTypeEnum
}
```

---

## Enum 전수 (64종)

각 셀의 유효 값은 소스 dump 원문을 전수 전사한 것이다. 설명 접두어(예: "The prediction type:")도 원문 그대로 보존한다. 괄호 안 부연(예: `Best (Model tournament)`)은 원문 설명이다.

| Enum | Valid values (전수) |
|---|---|
| AnalysisOutcomeTypeEnum | The analysis outcome type: Categorical, Count, Number, Text |
| AnalysisPredictionTypeEnum | The analysis prediction type: Binary, Count, MultiClass, None, Numeric |
| AnalysisSamplingStrategyEnum | The sampling strategy associated with the story version: Discovery, None, Random |
| AnalysisSetupScopeTypeEnum | The type of scope: CreatedByMe, SharedWithMe |
| AnalysisSetupSourceTypeEnum | The type of source: AnalyticsDataset, LiveDataset, Report |
| AnalysisSetupStatusEnum | The state of analysis performed by an Einstein Discovery service: Autopilot, DoneDescriptive, DoneFeatureEngineering, DoneModelMetrics, DonePredictive, Draft, Failed, Fetching, GenerateSetup, InProgress, Postprocessing, Preprocessing, Queued, QueuedForFetching, QueuedForPostprocessing, RequestToDelete, Resizing, RetryPreprocessing, RunningDescriptive, RunningFeatureEngineering, RunningModelMetrics, RunningPredictive, Success, TimedOut |
| ClassificationTypeEnum | The type of classification: Binary |
| ConnectEDInsightTypeEnum | The insight type to return: Descriptive, Summary |
| ConnectEDNarrativeTypeEnum | The narrative type to return: Positive, Negative |
| ConnectSmartDataDiscoveryFilterOperatorEnum | The operator to apply to this filter: Between, Contains, EndsWith, Equal, GreaterThan, GreaterThanOrEqual, InSet, LessThan, LessThanOrEqual, NotBetween, NotEqual, NotIn, StartsWith |
| ConnectSmartDataDiscoveryOutcomeGoalEnum | The outcome goal to filter the collection by: Maximize, Minimize, None |
| InsightsComparisonEnum | The insights score comparison criteria: Average, Other, UniformDistribution |
| InsightsConditionRestrictionEnum | The insights condition restriction: Included, NotIncluded |
| InsightsOutcomeChangeEnum | The change in outcome value: Decreased, Increased |
| InsightsResultCategoryEnum | The insights result category: Negative, Positive |
| InsightsResultsTypeEnum | The descriptive insights result type: FirstOrder, SecondOrder |
| InsightsTypeEnum | The analysis type for query insights: Descriptive, Diagnostic |
| MetricSpanEnum | The time span for the metrics: Day, Month, SinceLastAction, Week |
| PredictHistoryIntervalEnum | The interval for look back: None, Weekly |
| PredictionDefinitionCollectionCollectionSortOrderTypeEnum | The sort order type for the collection: LastUpdate, Name, OutcomeFieldLabel, PredictionType, SubscribedEntity |
| SmartDataDiscoveryAIModelCollectionSortOrderTypeEnum | The sort order type for the collection: CreatedDate, Description, Name, PredictionFieldName, PredictionType, RuntimeType |
| SmartDataDiscoveryAIModelStatusEnum | The model status: Disabled, Enabled, UploadCompleted, UploadFailed, Uploading, Validating, ValidationCompleted, ValidationFailed |
| SmartDataDiscoveryAIModelTransformationTypeEnum | The transformation type: CategoricalImputation (Replace categorical missing values), ExtractDayOfWeek (Extract day of week), ExtractMonthOfYear (Extract month of year), FreeTextClustering (Free text clustering), NumericalImputation (Replace numerical missing values), SentimentAnalysis (Detecting sentiment), TimeSeriesForecast (Projected predictions), TypographicClustering (Fuzzy matching) |
| SmartDataDiscoveryBucketingStrategyEnum | The bucketing strategy: EvenWidth, Manual, Percentage |
| SmartDataDiscoveryCategoricalImputationMethodEnum | The categorical imputation method: Auto |
| SmartDataDiscoveryClassificationAlgorithmTypeEnum | The classification algorithm type: Best (Model tournament), Drf (Distributed Random Forest), Gbm (GBM), Glm (GLM), Xgboost (XGBoost) |
| SmartDataDiscoveryDateIntervalEnum | The date interval for the field: Auto, Day, Month, None, Quarter, Year |
| SmartDataDiscoveryFieldMapSourceTypeEnum | The source type for the field mapping: AnalyticsDatasetField, SalesforceField |
| SmartDataDiscoveryFilterFieldTypeEnum | The filter field type: Boolean, Date, DateTime, Number, Text |
| SmartDataDiscoveryFilterValueTypeEnum | The type of the filter value: Constant, Placeholder |
| SmartDataDiscoveryImputeMethodEnum | The impute method: Mean, Median, Mode, None |
| SmartDataDiscoveryModelFieldTypeEnum | The type of the model field: Date, Number, Text |
| SmartDataDiscoveryModelRuntimeTypeEnum | The runtime type of the model: Discovery, H2O, Py36Tensorflow244 (TensorFlow), Py37Scikitlearn102 (Scikit Learn v1.0.2), Py37Tensorflow207 (TensorFlow v2.7.0) |
| SmartDataDiscoveryModelSourceTypeEnum | The model source type: Discovery, UserUpload |
| SmartDataDiscoveryNumericalImputationMethodEnum | The numerical imputation method: Mean, Median, Mode |
| SmartDataDiscoveryPeriodicDateIntervalEnum | The periodic date interval: Day_of_week, Month_of_year, Quarter_of_year |
| SmartDataDiscoveryPredictAggregateFunctionEnum | The predict aggregate function type: Average, Median, Sum |
| SmartDataDiscoveryPredictAggregateStatusEnum | The predict aggregate status: Error, Success |
| SmartDataDiscoveryPredictJobStatusEnum | The status of the predict job: Cancelled, Completed, Failed, InProgress, NotStarted, Paused |
| SmartDataDiscoveryPredictStatusEnum | The predict status: Error, Success |
| SmartDataDiscoveryPredictTypeEnum | The predict type: RawData (Represent rows within a two-dimensional array of row values), RecordOverrides (Represent records using Salesforce record Ids. Optionally override or append individual records with an array of row values), Records (Represent rows using Salesforce record Ids associated with the subscribedEntity of the prediction definition) |
| SmartDataDiscoveryPredictionTypeEnum | The prediction type: Classification, MulticlassClassification, Regression, Unknown |
| SmartDataDiscoveryProjectedPredictionsIntervalSettingTypeEnum | The projected predictions interval setting type: Count, CountFromDate, Date |
| SmartDataDiscoveryProjectedPredictionsIntervalTypeEnum | The projected predictions internal type: Day, Month, Quarter, Week  ⚠️ 원문 "internal type"(interval의 오기) 보존 |
| SmartDataDiscoveryProjectedPredictionsTypeEnum | The projected predictions type: Categorical, Numerical |
| SmartDataDiscoveryPushbackTypeEnum | The pushback type: AiRecordInsight, Direct |
| SmartDataDiscoveryOrderingEnum | The strategy for ordering text values: Alphabetical, Numeric, Occurrence |
| SmartDataDiscoveryRecipientTypeEnum | The type of the recipient: Group, User |
| SmartDataDiscoveryRefreshJobStatusEnum | The status of the refresh job: Cancelled, CompletedWithWarnings, Failure, NoRunnableTask, NotStarted, Running, ScoringJobFailed, Success, UserNotFound |
| SmartDataDiscoveryRefreshJobTypeEnum | The type of the refresh job: Scheduled, UserTriggered |
| SmartDataDiscoveryRefreshTaskStatusEnum | The status of the refresh task: AnalysisNotFound, Cancelled, DatasetJoinFieldsMissing, DatasetNotFound, DatasetNotUpdated, Failure, LimitsReached, ModelSchemaChanged, NotStarted, OutcomeValuesChanged, PoissonDistributionDisabled, Running, StoryCreationFailure, Success, UserNotFound, WarningThresholdReached |
| SmartDataDiscoveryRegressionAlgorithmTypeEnum | The regression algorithm type: Drf (Distributed Random Forest), Gbm (GBM), Glm (GLM), Xgboost (XGBoost) |
| SmartDataDiscoverySortOrderEnum | The sort order for the collection: Ascending, Descending |
| SmartDataDiscoveryTransformationFilterTypeEnum | The transformation filter type for the model: Number, Text |
| SmartDataDiscoveryStatusEnum | The status: Disabled, Enabled |
| StoryAnalysisTypeEnum | The analysis type: Count, Descriptive |
| StoryChartValueTypeEnum | The story chart value type: Average, Baseline, Impact, Prediction, SmallTerms, Unexplained, Value |
| StoryCountInsightsFrequencyChangeEnum | The story count insights frequency change: Down, Up |
| StoryCountInsightsFrequency;Enum | The story count imsights frequency: LessOften, MoreOften  ⚠️ 원문 enum명 "Frequency;Enum"(세미콜론 오타) + 설명 "imsights" 오타 보존. 실사용명은 StoryCountInsightsFrequencyEnum |
| StoryDescriptiveInsightsImpactEnum | The descriptive insights impact for the story: Improved, Worsened |
| StoryDescriptiveInsightsRatingEnum | The story descriptive insights rate: AboveAverage, BelowAverage, Higher, Lower |
| StoryFieldDetailTypeEnum | The field type: Field, Outcome |
| StoryNarrativeElementTypeEnum | The narrative element type: BadSelection, Body, BucketsMismatchSection, GoodSection, Heading, MissingValuesSection, NewValuesSection, NumberedList, OutcomeValue, Paragraph, SubHeading, UnorderedList |
| ValidationConfigurationStrategyEnum | The validation strategy for the configuration: Validation_Dataset, Validation_Set_Ratio |

---

## 원문 이상(⚠️) 주의 — verbatim 보존

소스 PDF에 존재하는 오타/이상 표기를 창작 없이 그대로 전사했다. 위 표에 인라인 ⚠️로 표시한 항목:

- **SmartDataDiscoveryProjectedPredictionsIntervalTypeEnum** — 설명이 "projected predictions **internal** type"으로 되어 있으나 문맥상 "interval type"의 오기다.
- **StoryCountInsightsFrequency;Enum** — enum 이름에 세미콜론(`;`)이 끼어 있고 설명에 "**imsights**"(insights) 오타가 있다. 실제 사용되는 enum 이름은 `StoryCountInsightsFrequencyEnum`이다.

이 두 항목은 PDF 원문 오류이며, 클라이언트 구현 시 정상 표기를 사용해야 한다.

---

## 관련 노트
- [[Einstein Discovery REST — 리소스 엔드포인트 레퍼런스]]
- [[Einstein Discovery REST — 개요·인증·예측 소비 흐름]]
- [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]]

> 아래 형제 노트는 동일 파이프라인에서 병렬 작성 중이라 아직 미생성이다. 생성되면 cross-linker가 위 목록에 편입한다.
> - [[Einstein Discovery REST — 요청 표현형 (Request Bodies)]]
> - [[Einstein Discovery REST — 응답 표현형 — 모델·필드·소스]]
> - [[Einstein Discovery REST — 응답 표현형 — 예측·잡·내러티브]]
> - [[Einstein Discovery REST — 응답 표현형 — 스토리·인사이트]]
