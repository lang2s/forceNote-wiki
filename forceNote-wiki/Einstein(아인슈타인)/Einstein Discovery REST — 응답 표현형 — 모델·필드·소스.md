---
tags: [einstein, einstein-discovery, rest-api, response-body, representation, reference]
source: bi_dev_guide_rest_sdd.pdf (Einstein Discovery REST API Developer Guide — Response Bodies)
created: 2026-07-19
aliases: [Einstein Discovery REST Response Bodies, Smart Data Discovery AI Model, Model Field, Field Mapping, Source, Transformation, Bucketing Strategy, 응답 표현형 모델]
---

# Einstein Discovery REST — 응답 표현형 — 모델·필드·소스

> Einstein Discovery REST 응답 바디(Output) 중 AI Model·필드·소스·변환·필터·설정(Configuration) 계열 표현형 프로퍼티 전수.

---

## 개요

이 노트는 `bi_dev_guide_rest_sdd.pdf`의 **Einstein Discovery REST API Response Bodies** 챕터 중 **설정(Configuration)·필드(Field)·소스(Source)·필드 매핑(Field Mapping)·AI Model·필터(Filter) 계열** 표현형을 담당한다. 각 표현형은 이름 + 설명 + 상속 관계 + 프로퍼티 표(Property Name / Type / Description / Filter Group / Available Version)로 전수 전사했다.

담당 범위 밖의 계열은 형제 노트에 위임한다:

- **예측·잡·내러티브 계열**(Prediction / Predict / Aggregate Prediction / Predict History / Narrative / Refresh Job 등) → [[Einstein Discovery REST — 응답 표현형 — 예측·잡·내러티브]]
- **스토리·인사이트 계열**(Story / Story Insights / Diagnostic Insights / Story Chart 등) → [[Einstein Discovery REST — 응답 표현형 — 스토리·인사이트]]
- **모델 품질·편향 지표 계열**(AI Model Metrics · Live Metrics · Metrics Collection · Training Metrics · Model Field Label Metrics · Potential Bias · Disparate Impact 등) → [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]]
- **enum 값 정의** → [[Einstein Discovery REST — Enums]]

> ℹ️ 표의 **Filter Group** 컬럼은 PDF 원표의 "Filter Group and Version"(예: `Small, 54.0`)을, **Available Version** 컬럼은 별도 "Available Version"(예: `54.0`)을 각각 보존한 것이다.

### 상속 계층 (구조 예시)

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (dump의 "Inherited by" 문장을 트리로 재구성)
AbstractFieldConfiguration
├── AbstractDateFieldConfiguration → DateFieldConfiguration
├── AbstractNumericFieldConfiguration → NumericFieldConfiguration
└── AbstractTextFieldConfiguration → TextFieldConfiguration

AbstractBucketingStrategy
├── EvenWidthBucketingStrategy
├── ManualBucketingStrategy
└── PercentileBucketingStrategy

AbstractClassificationThreshold → BinaryClassificationThreshold

AbstractSmartDataDiscoveryAIModelSource
├── SmartDataDiscoveryAIModelDiscoverySource
└── SmartDataDiscoveryAIModelUserUploadSource

AbstractSmartDataDiscoveryModelField
├── SmartDataDiscoveryModelFieldDate
├── SmartDataDiscoveryModelFieldNumeric
└── SmartDataDiscoveryModelFieldText

AbstractSmartDataDiscoveryPredictionProperty
├── SmartDataDiscoveryClassificationPredictionProperty
├── SmartDataDiscoveryMulticlassClassificationPredictionProperty   (형제 노트 소관)
└── SmartDataDiscoveryRegressionClassificationPredictionProperty   (형제 노트 소관)

AbstractSmartDataDiscoveryFieldMappingSource
├── SmartDataDiscoveryFieldMappingAnalyticsDatasetField
└── SmartDataDiscoveryFieldMappingSalesforceField

AbstractStorySource → AnalyticsDatasetSource / ReportSource
BaseAssetReference ← AssetReference (wraps)
```

---

## 설정·필드 계열 (Configuration / Bucketing / Threshold / Impute)

### Abstract Field Configuration
The base Einstein Discovery field configuration. **Inherited by** AbstractDateFieldConfiguration, AbstractNumericFieldConfiguration, and AbstractTextFieldConfiguration.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| highCardinality | Boolean | Indicates whether the field is a high cardinality field (true) or not (false). | Small, 54.0 | 54.0 |
| ignored | Boolean | Indicates whether the field is ignored (true) or not (false). | Small, 54.0 | 54.0 |
| label | String | The developer name for the field. | Small, 54.0 | 54.0 |
| name | String | The display name for the field. | Small, 54.0 | 54.0 |
| sensitive | Boolean | Indicates whether the field is sensitive (true) or not (false). | Small, 54.0 | 54.0 |
| type | SmartDataDiscoveryFilterFieldTypeEnum | The field type. Valid values are: • Boolean • Date • DateTime • Number • Text | Small, 54.0 | 54.0 |

### Abstract Date Field Configuration
The base Einstein Discovery date field configuration. **Inherits properties from** AbstractFieldConfiguration. **Inherited by** DateFieldConfiguration.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| interval | SmartDataDiscoveryDateIntervalEnum | The date interval for the field. Valid values are: • Auto • Day • Month • None • Quarter • Year | Small, 54.0 | 54.0 |
| max | Date | The maximum date value for the field. | Small, 54.0 | 54.0 |
| min | Date | The minimum date value for the field. | Small, 54.0 | 54.0 |
| periodicIntervals | SmartDataDiscoveryPeriodicDateIntervalEnum[] | A list of the periodic date intervals for the field. Valid values are: • Day_of_week • Month_of_year • Quarter_of_year | Small, 54.0 | 54.0 |

### Abstract Numeric Field Configuration
The base Einstein Discovery numeric field configuration. **Inherits properties from** AbstractFieldConfiguration. **Inherited by** NumericFieldConfiguration.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| bucketingStrategy | AbstractBucketingStrategy | The bucketing strategy for the field. Valid values are: • EvenWidthBucketingStrategy • ManualBucketingStrategy • PercentileBucketingStrategy | Small, 54.0 | 54.0 |
| imputeStrategy | SmartDataDiscoveryImputeStrategy | The impute strategy for the field. | Small, 54.0 | 54.0 |
| max | Double | The maximum value for the field. | Small, 54.0 | 54.0 |
| min | Double | The minimum value for the field. | Small, 54.0 | 54.0 |

### Abstract Text Field Configuration
The base Einstein Discovery text field configuration. **Inherits properties from** AbstractFieldConfiguration. **Inherited by** TextFieldConfiguration.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| includeOther | Boolean | Indicates whether values that don't match the specified values should be grouped into other (true) or not (false). | Small, 54.0 | 54.0 |
| ordering | SmartDataDiscoveryOrderingEnum | The strategy for ordering text values. Valid values are: • Alphabetical • Numeric • Occurrence | Small, 54.0 | 54.0 |
| values | TextFieldValueConfiguration[] | A list of values for the field. | Small, 54.0 | 54.0 |

### Date Field Configuration
The date field configuration. **Inherits properties from** AbstractDateFieldConfiguration. (자체 추가 프로퍼티 없음.)

### Numeric Field Configuration
The numeric field configuration. **Inherits properties from** AbstractNumericFieldConfiguration. (자체 추가 프로퍼티 없음.)

> ℹ️ 구체 `Text Field Configuration` / `Text Field Value Configuration`은 이 노트 담당 범위(Impute Strategy까지) 밖이다 — 형제 노트 소관.

### Abstract Bucketing Strategy
The base bucketing strategy. **Inherited by** EvenWidthBucketingStrategy, ManualBucketingStrategy, and PercentileBucketingStrategy.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryBucketingStrategyEnum | The bucketing strategy. Valid values are: • EvenWidth • Manual • Percentage | Small, 54.0 | 54.0 |

### Even Width Bucketing Strategy
The even-width bucketing strategy. **Inherits properties from** AbstractBucketingStrategy.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| numberOfBuckets | Integer | The number of buckets for a numeric field. | Small, 54.0 | 54.0 |

### Manual Bucketing Strategy
The manual bucketing strategy. **Inherits properties from** AbstractBucketingStrategy.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| cutoffs | Double[] | A list of manual buckets for a numeric field. | Small, 54.0 | 54.0 |

### Percentile Bucketing Strategy
The percentile bucketing strategy. **Inherits properties from** AbstractBucketingStrategy.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| numberOfBuckets | Integer | The number of buckets for a numeric field. | Small, 54.0 | 54.0 |

### Abstract Classification Threshold
The base classification threshold. **Inherited by** Binary Classification Threshold.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| type | ClassificationTypeEnum | The classification type. Valid values are: • Binary | Small, 47.0 | 47.0 |

### Binary Classification Threshold
A binary classification threshold. **Inherits properties from** AbstractClassificationThreshold.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| value | Double | The data for a source analysis. | Small, 47.0 | 47.0 |

### Smart Data Discovery Impute Strategy
The impute strategy.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| groupByFieldName | String | The field name value to group by. | Small, 54.0 | 54.0 |
| method | SmartDataDiscoveryImputeMethodEnum | The impute method. Valid values are: • Mean • Median • Mode • None | Small, 54.0 | 54.0 |

---

## 모델 필드·예측 속성·변환 계열

### Abstract Smart Data Discovery Model Field
The base Einstein Discovery model field. **Inherited by** Smart Data Discovery Model Field Date, Smart Data Discovery Model Field Numeric and Smart Data Discovery Model Field Text.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| disparateImpact | Boolean | Indicates whether the model field is disparate impact (true) or not (false). | Small, 55.0 | 55.0 |
| label | String | The label of the model field. | Small, 48.0 | 48.0 |
| name | String | The name of the model field. | Small, 48.0 | 48.0 |
| sensitive | Boolean | Indicates whether the model field is sensitive (true) or not (false). | Small, 55.0 | 55.0 |
| type | SmartDataDiscoveryModelFieldTypeEnum | The type of the model field. Valid values are: • Date • Number • Text | Small, 48.0 | 48.0 |

> ℹ️ 구체 하위형 `Model Field Date` / `Model Field Numeric` / `Model Field Text`는 담당 범위 밖 — 형제 노트 소관.

### Abstract Smart Data Discovery Model Runtime
The base Einstein Discovery model run time.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryModelRuntimeTypeEnum | The run time type of the model. Valid values are: • Discovery • H2O • Py36Tensorflow244 (TensorFlow) • Py37Scikitlearn102 (Scikit Learn v1.0.2) • Py37Tensorflow207 (TensorFlow v2.7.0) | Small, 49.0 | 49.0 |

### Abstract Smart Data Discovery Prediction Property
The base Einstein Discovery AI model prediction property. **Inherited by** Smart Data Discovery Classification Prediction Property, Smart Data Discovery Multiclass Classification Prediction Property, and Smart Data Discovery Regression Classification Prediction Property.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryPredictionTypeEnum | The prediction type. Valid values are: • Classification • MulticlassClassification • Regression • Unknown | Small, 44.0 | 44.0 |

> ℹ️ 하위형 중 `Multiclass Classification Prediction Property`·`Regression Classification Prediction Property`는 담당 범위(Impute Strategy) 밖 — 형제 노트 소관. 여기서는 `Classification Prediction Property`만 전사.

### Smart Data Discovery Classification Prediction Property
The classification prediction model type. **Inherits properties from** AbstractSmartDataDiscoveryPredictionProperty.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| algorithmType | SmartDataDiscoveryClassificationAlgorithmTypeEnum | The classification algorithm type. Valid values are: • Best (Model tournament) • Drf (Distributed Random Forest) • Gbm (GBM) • Glm (GLM) • Xgboost (XGBoost) | Small, 49.0 | 49.0 |
| classificationThreshold | BinaryClassificationThreshold | The classification threshold (e.g. binary classification threshold for logistic regression models). | Small, 48.0 | 48.0 |

### Smart Data Discovery Categorical Projected Prediction
An Einstein Discovery categorical projected prediction. **Inherits properties from** AbstractSmartDataDiscoveryProjectedPrediction.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| classProbabilities | Double | The predict probabilities for each class. | Small, 55.0 | 55.0 |
| prediction | String | The prediction outcome. | Small, 54.0 | 54.0 |

> ⚠️ 상속원 `AbstractSmartDataDiscoveryProjectedPrediction`(투영 예측 계열)은 담당 범위 밖 — 형제 노트 소관. dump 원문상 그 base의 "Inherited by"에 `Catagorical`(오타, Categorical) 표기가 있었음.

### Abstract Smart Data Discovery Transformation Override
The base Einstein Discovery transformation deploy overrides. **Inherited by** Smart Data Discovery Projected Predictions Override.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| id | String | The ID of the override. | Small, 55.0 | 55.0 |
| input | AssetReference | A transformation asset associated with the override settings. | Small, 55.0 | 55.0 |
| type | SmartDataDiscoveryAIModelTransformationTypeEnum | The transformation type. Valid values are: • CategoricalImputation (Replace categorical missing values) • ExtractDayOfWeek (Extract day of week) • ExtractMonthOfYear (Extract month of year) • FreeTextClustering (Free text clustering) • NumericalImputation (Replace numerical missing values) • SentimentAnalysis (Detecting sentiment) • TimeSeriesForecast (Projected predictions) • TypographicClustering (Fuzzy matching) | Small, 55.0 | 55.0 |

### Abstract Smart Data Discovery Validation Configuration
The base validation configuration output. **Inherited by** Validation Dataset and Validation Ratio.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| strategy | ValidationConfigurationStrategyEnum | The validation strategy for the configuration. Valid values are: • Validation_Dataset • Validation_Set_Ratio | Small, 57.0 | 57.0 |

---

## AI Model 계열

### Smart Data Discovery AI Model
An Einstein Discovery AI model to retrieve.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| coefficientsUrl | String | The coefficients URL for the AI model. | Small, 55.0 | 55.0 |
| createdBy | SmartDataDiscoveryUser | The user that created the AI model. | Small, 48.0 | 48.0 |
| createdDate | Date | The date on which the AI model was created. | Small, 48.0 | 48.0 |
| description | String | The description for the AI model. | Small, 48.0 | 48.0 |
| id | String | The ID for the AI model. | Small, 48.0 | 48.0 |
| input | AbstractSmartDataDiscoveryAIModelSource | The input source for the AI model. Valid data properties are: • Smart Data Discovery AI Model Discovery Source • Smart Data Discovery AI Model User Upload Source | Small, 48.0 | 48.0 |
| label | String | The label for the AI model. | Small, 48.0 | 48.0 |
| lastModifiedBy | SmartDataDiscoveryUser | The user who last modified the AI model. | Small, 48.0 | 48.0 |
| lastModifiedDate | Date | The date on which the AI model was last modified. | Small, 48.0 | 48.0 |
| metricsUrl | String | The metrics URL for the AI model. | Small, 54.0 | 54.0 |
| modelFields | AbstractSmartDataDiscoveryModelField[] | The list of model fields for the AI model. Valid values are: • SmartDataDiscoveryModelFieldDate • SmartDataDiscoveryModelFieldNumeric • SmartDataDiscoveryModelFieldText | Small, 48.0 | 48.0 |
| modelFileUrl | String | The file URL for the AI model. | Small, 49.0 | 49.0 |
| modelRuntime | AbstractSmartDataDiscoveryModelRuntime | The run time model for the AI model. | Small, 48.0 | 48.0 |
| name | String | The developer name for the AI model. | Small, 48.0 | 48.0 |
| namespace | String | The namespace for the AI model. | Small, 51.0 | 51.0 |
| predictedField | String | The predicted field name for the AI model. | Small, 48.0 | 48.0 |
| predictionProperty | AbstractSmartDataDiscoveryPredictionProperty | The prediction property for the AI model. Valid prediction properties are: • Smart Data Discovery Classification Prediction Property • Smart Data Discovery Multiclass Classification Prediction Property • Smart Data Discovery Regression Classification Prediction Property | Small, 48.0 | 48.0 |
| status | SmartDataDiscoveryAIModelStatusEnum | The model status. Valid values are: • Disabled • Enabled • UploadCompleted • UploadFailed • Uploading • Validating • ValidationCompleted • ValidationFailed | Small, 48.0 | 48.0 |
| transformations | SmartDataDiscoveryAIModelTransformation[] | The list of transformations associated with the AI model. | Small, 48.0 | 48.0 |
| url | String | The URL for the AI model. | Small, 48.0 | 48.0 |
| validationResult | Map<Object, Object> | The validation result for the AI model, when available. | Small, 50.0 | 50.0 |

### Smart Data Discovery AI Model Collection
A collection of Einstein Discovery AI models.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| models | SmartDataDiscoveryAIModel[] | The list of AI models available to the current user. | Small, 48.0 | 48.0 |
| nextPageUrl | String | The URL to get the next page of results. | Small, 51.0 | 51.0 |
| totalSize | Integer | The total count of items in the collection. | Small, 48.0 | 48.0 |
| url | String | The URL to get the collection. | Small, 48.0 | 48.0 |

### Smart Data Discovery AI Model Coefficient Collection
A collection of Einstein Discovery AI model coefficients.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| coefficients | SmartDataDiscoveryPredictCondition[] | The list of coefficients for the model. | Small, 55.0 | 55.0 |
| nextPageUrl | String | The URL to get the next page of results. | Small, 55.0 | 55.0 |
| totalSize | Integer | The total count of items in the collection. | Small, 55.0 | 55.0 |
| url | String | The URL to get the collection. | Small, 55.0 | 55.0 |

### Smart Data Discovery AI Model Residual Collection
A collection of Einstein Discovery AI model residuals.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| nextPageUrl | String | The URL to get the next page of results. | Small, 55.0 | 55.0 |
| residuals | SmartDataDiscoveryAIModelResidual[] | The list of residuals for the model. | Small, 55.0 | 55.0 |
| totalSize | Integer | The total count of items in the collection. | Small, 55.0 | 55.0 |
| url | String | The URL to get the collection. | Small, 55.0 | 55.0 |

### Smart Data Discovery AI Model Residual
AnEinstein Discovery AI model residual. ⚠️ (원문 "AnEinstein" 붙여쓰기 — 그대로 보존)

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| actual | Double | The actual value. | Small, 55.0 | 55.0 |
| predicted | Double | The predicted value. | Small, 55.0 | 55.0 |

### Smart Data Discovery AI Model Transformation
An Einstein Discovery AI model transformation.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| id | String | The ID for the AI model. | Small, 55.0 | 55.0 |
| sourceFields | AbstractSmartDataDiscoveryModelField[] | A list of the model field names used as input parameters by the transformation. Valid values are: • SmartDataDiscoveryModelFieldDate • SmartDataDiscoveryModelFieldNumeric • SmartDataDiscoveryModelFieldText | Small, 54.0 | 54.0 |
| state | Map<Object, Object> | A map of the model transformation state. | Small, 51.0 | 51.0 |
| targetFields | AbstractSmartDataDiscoveryModelField[] | A list of the model field names modified by the transformation. Valid values are: • SmartDataDiscoveryModelFieldDate • SmartDataDiscoveryModelFieldNumeric • SmartDataDiscoveryModelFieldText | Small, 54.0 | 54.0 |
| type | SmartDataDiscoveryAIModelTransformationTypeEnum | The model transformation type. Valid values are: • CategoricalImputation (Replace categorical missing values) • ExtractDayOfWeek (Extract day of week) • ExtractMonthOfYear (Extract month of year) • FreeTextClustering (Free text clustering) • NumericalImputation (Replace numerical missing values) • SentimentAnalysis (Detecting sentiment) • TimeSeriesForecast (Projected predictions) • TypographicClustering (Fuzzy matching) | Small, 51.0 | 51.0 |

### Abstract Smart Data Discovery AI Model Source
The base Einstein Discovery AI model prediction property. **Inherited by** Smart Data Discovery AI Model Discovery Source and Smart Data Discovery AI Model User Upload Source.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryModelSourceTypeEnum | The source type of the AI model. Valid values are: • Discovery • UserUpload | Small, 48.0 | 48.0 |

### Smart Data Discovery AI Model Discovery Source
The discovery source for an AI model. **Inherits properties from** AbstractSmartDataDiscoveryAIModelSource.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| story | Asset Reference | The source story asset. | Small, 48.0 | 48.0 |
| storyHistory | Asset Reference | The source story history asset. | Small, 48.0 | 48.0 |

### Smart Data Discovery AI Model User Upload Source
The user upload source for an AI model. **Inherits properties from** AbstractSmartDataDiscoveryAIModelSource. (자체 추가 프로퍼티 없음.)

---

## 필드 매핑 계열

### Smart Data Discovery Field Mapping
An Einstein Discovery field mapping.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| input | AbstractSmartDataDiscoveryFieldMappingSource | The field mapping source. Valid values are: • Smart Data Discovery Field Mapping Analytics Dataset Field • Smart Data Discovery Field Mapping Salesforce Field | Small, 48.0 | 48.0 |
| mappedField | SmartDataDiscoveryFieldMappingMappedField | The mapped field. | Small, 48.0 | 48.0 |
| modelField | AbstractSmartDataDiscoveryModelField[] | The model field. Valid values are: • SmartDataDiscoveryModelFieldDate • SmartDataDiscoveryModelFieldNumeric • SmartDataDiscoveryModelFieldText | Small, 48.0 | 48.0 |

### Abstract Smart Data Discovery Field Mapping Source
The base Einstein Discovery field mapping source. **Inherited by** Smart Data Discovery Field Mapping Analytics Dataset Field and Smart Data Discovery Field Mapping Salesforce Field.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryFieldMapSourceTypeEnum | The source type for the field mapping. Valid values are: • AnalyticsDatasetField • SalesforceField | Small, 48.0 | 48.0 |

### Smart Data Discovery Field Mapping Analytics Dataset Field
An Einstein Discovery field mapped from an analytics dataset source. **Inherits properties from** AbstractSmartDataDiscoveryFieldMappingSource.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| sobjectFieldJoinKey | String | The sObject field name used as the join key. | Small, 48.0 | 48.0 |
| source | AssetReference | A source ID of the analytics dataset asset. | Small, 48.0 | 48.0 |
| sourceFieldJoinKey | String | The source dataset field name used as the join key. | Small, 48.0 | 48.0 |

### Smart Data Discovery Field Mapping Salesforce Field
An Einstein Discovery field mapped from a Salesforce field source. **Inherits properties from** AbstractSmartDataDiscoveryFieldMappingSource. (자체 추가 프로퍼티 없음.)

### Smart Data Discovery Field Mapping Mapped Field
A mapped field in a field mapping.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| label | String | The label of the mapped field. | Small, 48.0 | 48.0 |
| name | String | The name of the mapped field. | Small, 48.0 | 48.0 |
| type | String | The type of the mapped field. | Small, 48.0 | 48.0 |

### Smart Data Discovery Field
An Einstein Discovery field. **Inherited by** Smart Data Discovery Pushback Field.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| label | String | The label of the field. | Small, 46.0 | 46.0 |
| name | String | The name of the field. | Small, 46.0 | 46.0 |

---

## 소스·에셋 참조 계열

### Abstract Story Source
The base Einstein Discovery analysis source. **Inherited by** AnalyticsDatasetSource and ReportSource.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| type | AnalysisSetupSourceTypeEnum | The source type of the analysis. Valid values are: • AnalyticsDataset • LiveDataset • Report | Small, 45.0 | 45.0 |

### Analytics Dataset Source
An analytics dataset as the analysis source. **Inherits properties from** AbstractStorySource.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| dataset | Asset Reference | The dataset for an analysis source. | Small, 45.0 | 45.0 |
| datasetVersion | Asset Reference | The dataset version for an analysis source. | Small, 45.0 | 45.0 |

### Report Source
An analytics report as the analysis source. **Inherits properties from** AbstractStorySource.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| report | Asset Reference | The report for an analysis source. | Small, 45.0 | 45.0 |
| reportInstance | Asset Reference | The report instance for an analysis source. | Small, 45.0 | 45.0 |

### Abstract Story Data Property
The base Einstein Discovery story data property filter. **Inherited by** Story All Other Field Value, Story Day Field Value, Story Day Of Week Field Value, Story Field Only, Story Month Field Value, Story Month Of Year Field Value, Story Null Field Value, Story Quarter Field Value, Story Quarter Of Year Field Value, Story Range Field Value, Story Text Field Value, and Story Year Field Value.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| field | String | The filter field developer name. | Small, 52.0 | 52.0 |
| type | String | The filter field type. | Small, 52.0 | 52.0 |

> ℹ️ 위 "Inherited by"에 열거된 구체 Story*FieldValue 하위형들은 스토리·인사이트 형제 노트 소관.

### Asset Reference
An Einstein Discovery asset reference. This wraps the BaseAssetReference.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| (inherited) | Base Asset Reference | Properties: Base Asset Reference (wraps BaseAssetReference). | — | — |

### Asset History Collection
A collection of asset history items.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| histories | AssetHistory[] | The list of asset histories. | Small, 46.0 | 46.0 |

### Asset History
The asset history record.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| createdBy | WaveUser | The user who created the asset history record. | Small, 46.0 | 46.0 |
| createdDate | Date | The creation date of the asset history record. | Small, 46.0 | 46.0 |
| historyUrl | String | The URL to the asset history metadata details. | Small, 46.0 | 46.0 |
| id | String | The ID for the asset history record. | Small, 46.0 | 46.0 |
| isCurrent | Boolean | Indicates whether this history record is the current version of the asset (true) or not (false). | Small, 47.0 | 47.0 |
| label | String | The optional label tag for the asset history record. | Small, 46.0 | 46.0 |
| name | String | The developer name for the asset history record. | Small, 46.0 | 46.0 |
| previewUrl | String | The URL to preview how an asset looked at a particular point in time. This URL doesn't revert the current asset to the asset history record. | Small, 46.0 | 46.0 |
| revertUrl | String | The URL to revert the current asset to this asset history record. | Small, 46.0 | 46.0 |
| status | String | The status value of the asset. | Small, 49.0 | 49.0 |

### Base Asset Reference
The base Einstein Discovery asset, inherited by AssetReference.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| id | String | The ID of the asset. | Small, 42.0 | 42.0 |
| label | String | The label of the asset. | Small, 42.0 | 42.0 |
| name | String | The developer name of the asset. | Small, 42.0 | 42.0 |
| namespace | String | The namespace that qualifies the asset name. | Small, 42.0 | 42.0 |
| url | String | The URL of the asset. | Small, 42.0 | 42.0 |

---

## 필터 계열

### Smart Data Discovery Filter
An Einstein Discovery filter used to select a model.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| fieldName | String | The developer name of the field to apply the filter to. | Small, 41.0 | 41.0 |
| filterValues | SmartDataDiscoveryFilterValue[] | An ordered list of values to be applied in the filter. | Small, 50.0 | 50.0 |
| operator | ConnectSmartDataDiscoveryFilterOperatorEnum | The operator to apply to this filter. Valid values are: • Between • Contains • EndsWith • Equal • GreaterThan • GreaterThanOrEqual • InSet • LessThan • LessThanOrEqual • NotBetween • NotEqual • NotIn • StartsWith | Small, 54.0 | 54.0 |
| type | SmartDataDiscoveryFilterFieldTypeEnum | The filter field type. Valid values are: • Boolean • Date • DateTime • Number • Text | Small, 48.0 | 48.0 |

### Smart Data Discovery Filter List
A list of record filter conditions.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| filters | SmartDataDiscoveryFilter[] | The list of filter conditions. | Small, 46.0 | 46.0 |

### Smart Data Discovery Filter Value
The value used in an Einstein Discovery filter.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryFilterValueTypeEnum | The type of the filter value. Valid values are: • Constant • Placeholder | Small, 50.0 | 50.0 |
| value | String | The value of the filter. The value can be a constant or a valid placeholder. | Small, 50.0 | 50.0 |

---

## 기타 (연락처·커스터마이즈·설정)

### Autopilot
The setup for autopilot.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| enabled | Boolean | Indicates whether autopilot is enabled (true) or not (false). | Small, 55.0 | 55.0 |

### Smart Data Discovery Contact
An Einstein Discovery contact.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| email | String | The email for the contact. | Small, 51.0 | 51.0 |
| name | String | The name of the contact. | Small, 51.0 | 51.0 |

### Smart Data Discovery Customizable Field
An Einstein Discovery customizable field.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| customDefinitions | SmartDataDiscoveryCustomPrescribableFieldDefinition[] | A list of custom field definitions. | Small, 57.0 | 57.0 |
| fieldName | String | The name of the customizable field. | Small, 57.0 | 57.0 |

### Smart Data Discovery Custom Prescribable Field Definition
A custom Einstein Discovery prescribable field definition to override default prescription text.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| filters | SmartDataDiscoveryFilter[] | A list of filter rules for enabling custom text. | Small, 50.0 | 50.0 |
| templateText | String | The template text to use in replacements. | Small, 50.0 | 50.0 |

### Smart Data Discovery Feature Importance Metric
An importance metric for a Einstein Discovery model. ⚠️ (이름에 "Metric"이 있으나 지표 노트 제외 대상이 **아님** — 이 노트에서 전사.)

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| featureImportance | ModelFieldLabelMetrics[] | The list of importance metrics. | Small, 56.0 | 56.0 |
| url | String | The URL to the importance metrics. | Small, 56.0 | 56.0 |

> ℹ️ `featureImportance` 타입인 `ModelFieldLabelMetrics`의 프로퍼티 정의 자체는 지표 표현형 노트 소관. → [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]]

---

## 관련 노트
- [[Einstein Discovery REST — 요청 표현형 (Request Bodies)]] — 요청 바디(Input) 표현형
- [[Einstein Discovery REST — 응답 표현형 — 예측·잡·내러티브]] — 예측/Predict/Aggregate/Predict History/Narrative/Refresh Job 계열(형제)
- [[Einstein Discovery REST — 응답 표현형 — 스토리·인사이트]] — Story/Story Insights/Diagnostic Insights/Story Chart 계열(형제)
- [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]] — 이 노트에서 제외한 AI Model Metrics·Live Metrics·Model Field Label Metrics·편향 지표 계열
- [[Einstein Discovery REST — 리소스 엔드포인트 레퍼런스]] — 이 표현형들을 반환하는 리소스 엔드포인트
- [[Einstein Discovery REST — Enums]] — 위 표의 `...Enum` 타입 Valid values 정의
