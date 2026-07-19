---
tags: [einstein, einstein-discovery, rest-api, response-body, prediction, job, narrative, reference]
source: bi_dev_guide_rest_sdd.pdf (Einstein Discovery REST API Developer Guide — Response Bodies)
created: 2026-07-19
aliases: [Predict List, Prediction Definition, Predict Job, Refresh Job, Predict History, Narrative, Projected Prediction, 응답 표현형 예측]
---

# Einstein Discovery REST — 응답 표현형 — 예측·잡·내러티브

> Einstein Discovery REST 응답 바디 중 예측 결과·Prediction Definition·Predict/Refresh Job·History·Projected Predictions·Narrative 계열 표현형 프로퍼티 전수.

---

이 노트는 Einstein Discovery(Smart Data Discovery) REST API의 **응답 표현형(Response Bodies)** 중 다음 계열을 다룬다: 예측 결과(Prediction·Predict·집계 예측), Prediction Definition, 모델·프리스크립션 필드, Projected Predictions, Predict/Refresh Job, Predict History, Narrative, 그리고 Insight·User·Outcome·Recipient 등 지원 표현형.

각 표현형의 프로퍼티는 `Property Name | Type | Description | Filter Group | Available Version` 형식으로 원문 그대로 전수 전사한다. `**Inherits properties from**` 표기는 상속 관계이며, 상속된 프로퍼티는 상위 추상 표현형(별도 노트 소관)에 정의된다 — 이 노트는 각 표현형의 **자체 추가 프로퍼티만** 전사한다.

> **범위 밖 (지표 표현형 노트 소관 — 이름만):** Training Metrics · Live Metric Detail · Live Metrics · Metrics Collection · Model Field Label Metrics · AI Model Classification Metrics 등 지표(metrics) 표현형은 이 노트에 포함하지 않는다.

```json
// 구조 예시 — 실제 동작 설정 아님. Predict List 응답의 대략적 형태(프로퍼티는 아래 표가 정본)
{
  "predictionDefinition": "0PS...",
  "predictionType": "Regression",
  "predictions": [
    {
      "model": { "id": "..." },
      "prediction": { "type": "...", "columns": [], "value": 0.0 },
      "prescriptions": [],
      "projectedPredictions": null
    }
  ],
  "aggregatePredictions": [],
  "settings": { "maxPrescriptions": 200 }
}
```

---

## 예측 결과 (Prediction · Predict 계열)

### Smart Data Discovery Prediction
An Einstein Discovery prediction result. **Inherits properties from** AbstractSmartDataDiscoveryPrediction.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| model | AssetReference | The model information of a success prediction. | Small, 47.0 | 47.0 |
| prediction | AbstractSmartDataDiscoveryPredict | The raw prediction, including prediction value, predictive factors, and warnings. Valid values are: • Smart Data Discovery Multiclass Prediction • Smart Data Discovery Predict Error • Smart Data Discovery Predict | Small, 41.0 | 41.0 |
| prescriptions | SmartDataDiscoveryPredictCondition[] | The details of how actionable values could be used to improve the prediction. | Small, 41.0 | 41.0 |
| projectedPredictions | SmartDataDiscoveryProjectedPredictions | The projected predictions for the prediction, if available. | Small, 54.0 | 54.0 |

### Smart Data Discovery Prediction Error
An Einstein Discovery prediction error. **Inherits properties from** AbstractSmartDataDiscoveryPrediction.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| errorCode | Integer | The error code. | Small, 44.0 | 44.0 |
| message | String | The error message. | Small, 44.0 | 44.0 |

### Smart Data Discovery Predict
An Einstein Discovery predict result. **Inherits properties from** AbstractSmartDataDiscoveryPredict. (자체 추가 프로퍼티 없음.)

### Smart Data Discovery Predict Error
An Einstein Discovery predict error result. **Inherits properties from** AbstractSmartDataDiscoveryPredict.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| errorCode | Integer | The error code. | Small, 44.0 | 44.0 |
| message | String | The error message. | Small, 44.0 | 44.0 |

### Smart Data Discovery Multiclass Predict
An Einstein Discovery multiclass predict result. **Inherits properties from** AbstractSmartDataDiscoveryPredict.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| classProbabilities | Map<Double, Double> | A map of predict probabilities for each class. | Small, 52.0 | 52.0 |
| predictedClass | String | The predict value. | Small, 52.0 | 52.0 |
| type | String | The type of the predict result. | Small, 52.0 | 52.0 |

### Smart Data Discovery Import Warnings
The import warnings for an Einstein Discovery prediction.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| mismatchedColumns | String[] | A list of mismatched columns for the predict result. | Small, 42.0 | 42.0 |
| missingColumns | String[] | A list of missing columns for the predict result. | Small, 42.0 | 42.0 |
| outOfBoundsColumns | SmartDataDiscoveryPredictColumn[] | A list of out of bounds columns for the predict result. | Small, 42.0 | 42.0 |

### Smart Data Discovery Predict Condition
An Einstein Discovery predict condition.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| columns | SmartDataDiscoveryPredictColumn[] | The list of column information for the prediction. | Small, 41.0 | 41.0 |
| value | Double | The value of the prediction. | Small, 41.0 | 41.0 |

### Smart Data Discovery Predict Column
A column given from an Einstein Discovery prediction.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| columnLabel | String | The label of the column. | Small, 51.0 | 51.0 |
| columnName | String | The name of the column. | Small, 41.0 | 41.0 |
| columnValue | String | The value of the column. | Small, 51.0 | 51.0 |
| customText | SmartDataDiscoveryPredictColumnCustomText | The custom text definition, if it's defined for the column name. | Small, 50.0 | 50.0 |
| inputValue | String | The input value that created this prediction column. | Small, 50.0 | 50.0 |

### Smart Data Discovery Predict Column Custom Text
The custom text for a predict column given by the Einstein Discovery prediction.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| mapping | Map<String, String> | A placeholder to the resolved value defined in the template text. The map is null if there are no placeholders. | Small, 50.0 | 50.0 |
| templateText | String | The template text if a custom override is defined for the column. When the column value should be skipped, this is an empty string. | Small, 50.0 | 50.0 |

### Smart Data Discovery Predict List
A list of Einstein Discovery predictions.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| aggregatePredictions | AbstractSmartDataDiscoveryAggregatePrediction[] | A list of aggregate prediction results. Valid values are: • SmartDataDiscoveryAggregatePrediction • SmartDataDiscoveryAggregatePredictionError | Small, 55.0 | 55.0 |
| predictionDefinition | String | The ID of the prediction definition used to make the prediction. | Small, 44.0 | 44.0 |
| predictionType | SmartDataDiscoveryPredictionTypeEnum | The prediction type. Valid values are: • Classification • MulticlassClassification • Regression • Unknown | Small, 55.0 | 55.0 |
| predictions | AbstractSmartDataDiscoveryPrediction[] | A list of predictions. Valid values are: • SmartDataDiscoveryPrediction • SmartDataDiscoveryPredictionError | Small, 55.0 | 55.0 |
| settings | SmartDataDiscoveryPredictSettings | The settings used for improvements. | Small, 46.0 | 46.0 |

### Smart Data Discovery Predict Settings
The settings for an Einstein Discovery prediction.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| aggregateFunctions | String[] | The list of the aggregate functions used to make the prediction. | Small, 55.0 | 55.0 |
| maxMiddleValues | Integer | The maximum middle values. Range is [0, 3]. | Small, 50.0 | 50.0 |
| maxPrescriptions | Integer | The maximum prescription count. Range is [-1, 200], where -1 indicates unlimited. | Small, 41.0 | 41.0 |
| prescriptionImpactPercentage | Integer | The impact percentage of prescriptions. If the value is 0, the default value, then all prescriptions are returned. If the value is 5, then only prescriptions that will improve the prediction by at least 5% are returned. | Small, 47.0 | 47.0 |
| settings | SmartDataDiscoveryProjectedPredictionSettings | The setting overrides for projected predictions. | Small, 54.0 | 54.0 |

---

## 집계 예측 (Aggregate Prediction 계열)

> 세 표현형 모두 `**Inherits properties from** AbstractSmartDataDiscoveryAggregatePrediction` (상위 추상 표현형은 별도 노트 소관).

### Smart Data Discovery Aggregate Predict Condition
The aggregate predict condition for a collection of Einstein Discover predictions. ⚠️(원문 "Discover" — Discovery 오타)

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| count | Integer | The count of rows included in the aggregate condition | Small, 55.0 | 55.0 |

### Abstract Smart Data Discovery Aggregate Prediction
The base Einstein Discovery aggregate prediction result. **Inherited by** Smart Data Discovery Aggregate Prediction and Smart Data Discovery Aggregate Prediction Error.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| aggregateFunction | SmartDataDiscoveryPredictAggregateFunctionEnum | The predict aggregate function. Valid values are: • Average • Median • Sum | Small, 55.0 | 55.0 |
| middleValues | SmartDataDiscoveryAggregatePredictCondition[] | The list of middle values. | Small, 55.0 | 55.0 |
| prescriptions | SmartDataDiscoveryAggregatePredictCondition[] | The list of prescriptions. | Small, 55.0 | 55.0 |
| status | SmartDataDiscoveryPredictAggregateStatusEnum | The predict aggregate status. Valid values are: • Error • Success | Small, 55.0 | 55.0 |

### Smart Data Discovery Aggregate Prediction Error
An Einstein Discovery aggregate prediction error. **Inherits properties from** AbstractSmartDataDiscoveryAggregatePrediction.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| errorCode | Integer | The error code. | Small, 55.0 | 55.0 |
| message | String | The error message. | Small, 55.0 | 55.0 |

### Smart Data Discovery Aggregate Prediction
An Einstein Discovery aggregate prediction result. **Inherits properties from** AbstractSmartDataDiscoveryAggregatePrediction.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| value | Double | The value of the aggregate result. | Small, 55.0 | 55.0 |

---

## Prediction Definition 계열

### Smart Data Discovery Prediction Definition
An Einstein Discovery prediction definition.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| countOfActiveModels | Integer | The number of active models currently present for the prediction model. | Small, 48.0 | 48.0 |
| countOfModels | Integer | The number of all models currently present for the prediction model. | Small, 41.0 | 41.0 |
| createdBy | SmartDataDiscoveryUser | The user who created the prediction definition. | Small, 41.0 | 41.0 |
| createdDate | Date | The creation date of the prediction definition. | Small, 41.0 | 41.0 |
| id | String | The ID of the prediction definition. | Small, 41.0 | 41.0 |
| label | String | The label of the prediction definition. | Small, 41.0 | 41.0 |
| lastModifiedBy | SmartDataDiscoveryUser | The user who last modified the prediction definition. | Small, 41.0 | 41.0 |
| lastModifiedDate | Date | The last modified date of the prediction definition. | Small, 41.0 | 41.0 |
| mappedOutcomeField | Integer | The mapped outcome field for Salesforce. | Small, 47.0 | 47.0 |
| modelsUrl | String | The URL for the prediction definition's models. | Small, 41.0 | 41.0 |
| name | String | The developer name of the prediction definition. | Small, 41.0 | 41.0 |
| namespace | String | The qualified namespace of the prediction definition. | Small, 51.0 | 51.0 |
| ninetyDayWarningCount | Integer | The total number of warnings for the prediction model over the last 90 days. | Supplemental, 50.0 | 50.0 |
| outcome | SmartDataDiscoveryPredDefOutcomeField | The outcome information of the prediction definition. | Small, 46.0 | 46.0 |
| predictionType | SmartDataDiscoveryPredictionTypeEnum | The prediction type. Valid values are: • Classification • MulticlassClassification • Regression • Unknown | Small, 48.0 | 48.0 |
| pushbackField | SmartDataDiscoveryPushbackField | The pushback of the prediction definition. | Small, 46.0 | 46.0 |
| pushbackType | SmartDataDiscoveryPushbackTypeEnum | The pushback type. Valid values are: • AiRecordInsight • Direct | Small, 52.0 | 52.0 |
| refreshConfig | SmartDataDiscoveryRefreshConfig | The refresh configuration of the prediction definition. | Small, 50.0 | 50.0 |
| status | SmartDataDiscoveryStatusEnum | The status of the prediction definition. Valid values are: • Disabled • Enabled | Small, 46.0 | 46.0 |
| subscribedEntity | String | The entity the prediction definition is subscribed to. | Small, 41.0 | 41.0 |
| terminalStateFilter | SmartDataDiscoveryFilterList | The terminal state filter of the prediction definition. | Small, 46.0 | 46.0 |
| totalPredictionsCount | Integer | The total number of predictions for the prediction definition. | Supplemental, 50.0 | 50.0 |
| totalWarningsCount | Integer | The total number of warnings for the prediction definition. | Supplemental, 50.0 | 50.0 |
| url | String | The URL for the prediction definition. | Small, 41.0 | 41.0 |

### Smart Data Discovery Prediction Definition Collection (1번째 — models[]/totalSize/url)
A collection of Einstein Discovery prediction definitions. (⚠️ PDF ToC에 이 표현형이 2회 등장 — p.132·p.140. 상세는 이 1개소만 프로퍼티 표 있음.)

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| models | SmartDataDiscoveryModel[] | The list of models. | Small, 41.0 | 41.0 |
| totalSize | Integer | The total count of items in the collection. | Small, 41.0 | 41.0 |
| url | String | The URL to get the collection. | Small, 41.0 | 41.0 |

### Smart Data Discovery Prediction Definition Collection (2번째 — p.140 동명 표현형)
A collection of Einstein Discovery prediction definitions.

> ⚠️ 동명 표현형 2개: (1) 위 1번째판 = models[]/totalSize/url, (2) 이 p.140판 = 아래. PDF ToC에도 2회(p.132·p.140) 등재. 원문 그대로 둘 다 보존.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| nextPageUrl | String | The URL to get the next page of results. | Small, 50.0 | 50.0 |
| predictionDefinitions | SmartDataDiscoveryPredictionDefinition[] | The list of prediction definitions. | Small, 41.0 | 41.0 |
| totalSize | Integer | The total count of items in the collection. | Small, 41.0 | 41.0 |
| url | String | The URL to get the collection. | Small, 41.0 | 41.0 |

### Smart Data Discovery Prediction Definition Outcome Field
An Einstein Discovery prediction definition outcome field.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| goal | ConnectSmartDataDiscoveryOutcomeGoalEnum | The prediction definition outcome goal. Valid values are: • Maximize • Minimize • None | Small, 46.0 | 46.0 |

### Smart Data Discovery Pushback Field
A pushback field for an Einstein Discovery prediction. **Inherits properties from** SmartDataDiscoveryField. (자체 추가 프로퍼티 없음.)

### Smart Data Discovery Prescribable Field
An Einstein Discovery prescribable field.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| customDefinitions | SmartDataDiscoveryCustomPrescribableFieldDefinition[] | A list of custom prescribable field definitions to override default prescription text. | Small, 50.0 | 50.0 |
| field | AbstractSmartDataDiscoveryModelField[] | A prescribable field. Valid values are: • SmartDataDiscoveryModelFieldDate • SmartDataDiscoveryModelFieldNumeric • SmartDataDiscoveryModelFieldText | Small, 50.0 | 50.0 |

### Smart Data Discovery Outcome
The analysis outcome for an Einstein Discovery story.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| predictionType | AnalysisPredictionTypeEnum | The analysis prediction type. Valid values are: • Binary • Count • MultiClass • None • Numeric | Small, 54.0 | 54.0 |
| type | AnalysisOutcomeTypeEnum | The analysis outcome type. Valid values are: • Categorical • Count • Number • Text | Small, 44.0 | 44.0 |

---

## 모델 · 모델 필드

### Smart Data Discovery Model
An Einstein Discovery model.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| classificationThreshold | AbstractClassificationThreshold | The classification threshold for the model. Valid values are: • BinaryClassificationThreshold | Small, 48.0 | 48.0 |
| createdBy | SmartDataDiscoveryUser | The user who created the model. | Small, 41.0 | 41.0 |
| createdDate | Date | The creation date of the model. | Small, 41.0 | 41.0 |
| customizableFactors | SmartDataDiscoveryCustomizableField[] | A list of customizable top factors for the model. | Small, 57.0 | 57.0 |
| fieldMappingList | SmartDataDiscoveryFieldMapping[] | A list mapping the model fields to Salesforce fields. | Small, 48.0 | 48.0 |
| filters | SmartDataDiscoveryFilter[] | A list of filters used to determine whether this model should be applied to a record. | Small, 41.0 | 41.0 |
| historyUrl | String | The URL for the model history. | Small, 49.0 | 49.0 |
| id | String | The ID of the model. | Small, 41.0 | 41.0 |
| isRefreshEnabled | Boolean | Indicates whether this model is included in the refresh schedule (true) or not (false). | Small, 50.0 | 50.0 |
| label | String | The label of the model. | Small, 41.0 | 41.0 |
| lastModifiedBy | SmartDataDiscoveryUser | The user who last modified the model. | Small, 41.0 | 41.0 |
| lastModifiedDate | Date | The last modified date of the model. | Small, 41.0 | 41.0 |
| model | AssetReference | A ID for the AI model. | Small, 48.0 | 48.0 |
| modelType | String | The type of the model. | Small, 47.0 | 47.0 |
| name | String | The developer name of the model. | Small, 41.0 | 41.0 |
| predictionDefinitionUrl | String | The URL to the prediction definition for the model. | Small, 41.0 | 41.0 |
| prescribableFields | SmartDataDiscoveryPrescribableField[] | A list of the prescribable fields for the model. | Small, 48.0 | 48.0 |
| sortOrder | Integer | A unique number indicating the order in which this model's filters are evaluated compared to all other models in the parent prediction definition. | Small, 41.0 | 41.0 |
| status | SmartDataDiscoveryStatusEnum | The status of the model. Valid values are: • Disabled • Enabled | Small, 46.0 | 46.0 |
| story | AssetReference | A story asset reference information. | Small, 52.0 | 52.0 |
| transformationOverrides | AbstractSmartDataDiscoveryTransformationOverride[] | A list of the transformation overrides for the model. Valid values are: • Smart Data Discovery Projected Predictions Override | Small, 55.0 | 55.0 |
| url | String | The URL for the model. | Small, 41.0 | 41.0 |

### Smart Data Discovery Model Card
An Einstein Discovery model card.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| contact | SmartDataDiscoveryContact | The contact person for the model card. | Small, 51.0 | 51.0 |
| createdBy | SmartDataDiscoveryUser | The user who created the model card. | Small, 51.0 | 51.0 |
| createdDate | Date | The creation date of the model card. | Small, 51.0 | 51.0 |
| id | String | The ID of the model card. | Small, 51.0 | 51.0 |
| label | String | The label of the model card. | Small, 51.0 | 51.0 |
| lastModifiedBy | SmartDataDiscoveryUser | The user who last modified the model card. | Small, 51.0 | 51.0 |
| lastModifiedDate | Date | The last modified date of the model card. | Small, 51.0 | 51.0 |
| sections | Map<Object, Object> | A map of the user customizable description for the model card. | Small, 51.0 | 51.0 |
| url | String | The URL for the model card. | Small, 51.0 | 51.0 |

### Smart Data Discovery Model Configuration
The configuration for an Einstein Discovery model.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| algorithmType | SmartDataDiscoveryClassificationAlgorithmTypeEnum | The algorithm type for the model. Valid values are: • Best (Model tournament) • Drf (Distributed Random Forest) • Gbm (GBM) • Glm (GLM) • Xgboost (XGBoost) | Small, 54.0 | 54.0 |

### Smart Data Discovery Model Field Date
An Einstein Discovery date model field. **Inherits properties from** AbstractSmartDataDiscoveryModelField.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| values | String[] | A list of model field unique values. | Small, 56.0 | 56.0 |

### Smart Data Discovery Model Field Numeric
An Einstein Discovery numeric model field. **Inherits properties from** AbstractSmartDataDiscoveryModelField.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| values | SmartDataDiscoveryNumericRange[] | A list of model field unique values. | Small, 56.0 | 56.0 |

### Smart Data Discovery Model Field Text
An Einstein Discovery text model field. **Inherits properties from** AbstractSmartDataDiscoveryModelField.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| values | String[] | A list of model field unique values. | Small, 56.0 | 56.0 |

### Smart Data Discovery Numeric Range
A numeric range for a field.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| max | Double | The maximum value for the range. | Small, 57.0 | 57.0 |
| min | Double | The minimum value for the range. | Small, 57.0 | 57.0 |

### Smart Data Discovery Multiclass Classification Prediction Property
The multiclass classification prediction model type. **Inherits properties from** AbstractSmartDataDiscoveryPredictionProperty.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| algorithmType | SmartDataDiscoveryClassificationAlgorithmTypeEnum | The classification algorithm type. Valid values are: • Best (Model tournament) • Drf (Distributed Random Forest) • Gbm (GBM) • Glm (GLM) • Xgboost (XGBoost) | Small, 49.0 | 49.0 |

### Smart Data Discovery Regression Classification Prediction Property
The regression classification prediction model type. **Inherits properties from** AbstractSmartDataDiscoveryPredictionProperty.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| algorithmType | SmartDataDiscoveryRegressionAlgorithmTypeEnum | The regression algorithm type. Valid values are: • Drf (Distributed Random Forest) • Gbm (GBM) • Glm (GLM) • Xgboost (XGBoost) | Small, 49.0 | 49.0 |
| classificationThreshold | BinaryClassificationThreshold | The classification threshold (e.g. binary classification threshold for logistic regression models). | Small, 48.0 | 48.0 |

---

## Projected Predictions 계열

### Abstract Smart Data Discovery Projected Prediction
The base Einstein Discovery projected prediction result. **Inherited by** Smart Data Discovery Catagorical Projected Prediction and Smart Data Discovery Numerical Projected Prediction. ⚠️(원문 오타 "Catagorical")

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryProjectedPredictionsTypeEnum | The projected predictions type. Valid values are: • Categorical • Numerical | Small, 54.0 | 54.0 |

### Abstract Smart Data Discovery Projected Predictions Interval Setting
The base Einstein Discovery projected predictions interval settings. **Inherited by** Smart Data Discovery Projected Predictions Count From Date Interval Setting, Smart Data Discovery Projected Predictions Count Interval Setting, and Smart Data Discovery Projected Predictions Date Interval Setting.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryProjectedPredictionsIntervalSettingTypeEnum | The projected predictions interval setting type. Valid values are: • Count • CountFromDate • Date | Small, 55.0 | 55.0 |

### Smart Data Discovery Numerical Projected Prediction
An Einstein Discovery numerical projected prediction. **Inherits properties from** AbstractSmartDataDiscoveryProjectedPrediction.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| prediction | String | The prediction outcome. | Small, 54.0 | 54.0 |

### Smart Data Discovery Projected Prediction Field
An Einstein Discovery projected prediction field.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| intervalType | SmartDataDiscoveryProjectedPredictionsIntervalTypeEnum | The projected predictions internal type. Valid values are: • Day • Month • Quarter • Week ⚠️(원문 "internal type" — interval 오타로 보임) | Small, 54.0 | 54.0 |
| name | String | The name of the field. | Small, 54.0 | 54.0 |
| numberOfIntervals | Integer | The number of intervals used to produce the results in projected prediction for all fields. | Small, 54.0 | 54.0 |
| projectedValues | SmartDataDiscoveryProjectedValue[] | A list of projected values for each interval. | Small, 54.0 | 54.0 |

### Smart Data Discovery Projected Prediction Settings
The settings for projected prediction fields.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| confidenceInterval | Integer | The confidence interval to display at each point. Allowed values are 80 and 95. | Small, 55.0 | 55.0 |
| numberOfIntervalsToPredictAhead | Integer | The override value for the number of intervals to predict ahead. Range is [1, 12]. | Small, 41.0 | 41.0 |
| showProjectedPredictionsByInterval | Boolean | Indicates whether to enable projected prediction calculation for every interval into the future (true) or not (false). | Small, 54.0 | 54.0 |

### Smart Data Discovery Projected Predictions Count From Date Interval Setting
The settings for an Einstein Discovery count from date based projection interval. **Inherits properties from** AbstractSmartDataDiscoveryProjectedPredictionsIntervalSetting.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| dateField | String | The date field to use for calculating projection intervals. | Small, 55.0 | 55.0 |
| dateFieldLabel | String | The label for the date field. | Small, 55.0 | 55.0 |
| numIntervals | Integer | The number of intervals to project ahead. | Small, 55.0 | 55.0 |

### Smart Data Discovery Projected Predictions Count Interval Setting
The settings for an Einstein Discovery count based projection interval. **Inherits properties from** AbstractSmartDataDiscoveryProjectedPredictionsIntervalSetting.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| numIntervals | Integer | The number of intervals to project ahead. | Small, 55.0 | 55.0 |

### Smart Data Discovery Projected Predictions Date Interval Setting
The settings for an Einstein Discovery date interval. **Inherits properties from** AbstractSmartDataDiscoveryProjectedPredictionsIntervalSetting.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| dateField | String | The date field to use for calculating projection intervals. | Small, 55.0 | 55.0 |
| dateFieldLabel | String | The label for the date field. | Small, 55.0 | 55.0 |

### Smart Data Discovery Projected Predictions Override
The settings for an Einstein Discovery projected predictions override. **Inherits properties from** AbstractSmartDataDiscoveryTransformationOverride.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| assetIdField | String | The Salesforce object field name to use as a look-up for a record ID in a historical dataset. | Small, 55.0 | 55.0 |
| intervalOverride | AbstractSmartDataDiscoveryProjectedPredictionsIntervalSetting | The projected predictions interval settings. Valid values are: • Smart Data Discovery Projected Predictions Count From Date Interval Setting • Smart Data Discovery Projected Predictions Count Interval Setting • Smart Data Discovery Projected Predictions Date Interval Setting | Small, 55.0 | 55.0 |

### Smart Data Discovery Projected Predictions
The projected predictions for an Einstein Discovery prediction result.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| fields | SmartDataDiscoveryProjectedPredictionField[] | The field level information for each projected prediction transformation. | Small, 54.0 | 54.0 |
| intervalSetting | AbstractSmartDataDiscoveryProjectedPredictionsIntervalSetting | The setting used for calculating projected prediction interval. Valid values are: • Smart Data Discovery Projected Predictions Count From Date Interval Setting • Smart Data Discovery Projected Predictions Count Interval Setting • Smart Data Discovery Projected Predictions Date Interval Setting | Small, 55.0 | 55.0 |
| intervalType | SmartDataDiscoveryProjectedPredictionsIntervalTypeEnum | The projected predictions interval type. Valid values are: • Day • Month • Quarter • Week | Small, 54.0 | 54.0 |
| numberOfIntervalsProjectedAhead | Integer | The number of intervals used to produce the results in projected prediction for all fields. | Small, 54.0 | 54.0 |
| predictions | AbstractSmartDataDiscoveryProjectedPrediction[] | A list of projected prediction results per interval. Valid values are: • Smart Data Discovery Catagorical Projected Prediction • Smart Data Discovery Numerical Projected Prediction ⚠️(원문 "Catagorical" 오타) | Small, 54.0 | 54.0 |

### Smart Data Discovery Projected Value
An Einstein Discovery projected value.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| confidenceIntervalLowerBound | Double | The confidence interval lower bound at the interval. | Small, 55.0 | 55.0 |
| confidenceIntervalUpperBound | Double | The confidence interval upper bound at the interval. | Small, 55.0 | 55.0 |
| value | Double | The projected value at the interval. | Small, 54.0 | 54.0 |

---

## Predict Job 계열

### Smart Data Discovery Predict Job Collection
A collection of Einstein Discovery predict jobs.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| predictJobs | SmartDataDiscoveryPredictJob[] | A list of predict jobs available to the current user. | Small, 48.0 | 48.0 |
| totalSize | Integer | The total size of the items in the collection. | Small, 48.0 | 48.0 |
| url | Integer | The URL to get the predict job results. ⚠️(원문 type "Integer" — String이 자연스러우나 원문대로) | Small, 48.0 | 48.0 |

### Smart Data Discovery Predict Job
An Einstein Discovery predict job.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| batchSize | Integer | The number of records processed per batch. | Small, 49.0 | 49.0 |
| createdBy | SmartDataDiscoveryUser | The user who created the predict job. | Small, 48.0 | 48.0 |
| createdDate | Date | The creation date of the predict job. | Small, 48.0 | 48.0 |
| failedRecords | Integer | The total number of records that failed to process. | Small, 49.0 | 49.0 |
| filters | SmartDataDiscoveryFilter[] | A list of filters applied to determine whether a row was scored by the predict job. | Small, 48.0 | 48.0 |
| id | String | The ID of the predict job. | Small, 48.0 | 48.0 |
| label | String | The label of the predict job. | Small, 48.0 | 48.0 |
| lastModifiedBy | SmartDataDiscoveryUser | The user who last modified the predict job. | Small, 48.0 | 48.0 |
| lastModifiedDate | Date | The last modified date of the predict job. | Small, 48.0 | 48.0 |
| message | String | The extended message for the status of the predict job, if available. | Small, 48.0 | 48.0 |
| name | String | The developer name of the predict job. | Small, 48.0 | 48.0 |
| predictionDefinition | AssetReference | The prediction definition information for the predict job. | Small, 48.0 | 48.0 |
| processedRecords | Integer | The total number of records that processed, including failures. | Small, 49.0 | 49.0 |
| status | SmartDataDiscoveryPredictJobStatusEnum | The status of the predict job. Valid values are: • Cancelled • Completed • Failed • InProgress • NotStarted • Paused | Small, 48.0 | 48.0 |
| subscribedEntity | String | The entity the predict job is subscribed to. | Small, 48.0 | 48.0 |
| totalRecords | Integer | The total number of records that processed. | Small, 49.0 | 49.0 |
| url | String | The URL for the predict job. | Small, 48.0 | 48.0 |
| useTerminalStateFilter | Boolean | Indicates whether the job scored any record NOT matching the terminal state filter on the goal (true) or not (false). | Small, 49.0 | 49.0 |

---

## Refresh Job · Task 계열

### Smart Data Discovery Refresh Config
The refresh configuration for an Einstein Discovery prediction.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| isEnabled | Boolean | Indicates whether scheduled refresh is enabled (true) or not (false). | Small, 50.0 | 50.0 |
| recipientList | SmartDataDiscoveryRecipient[] | A list of recipients for email notification. | Small, 50.0 | 50.0 |
| schedule | Schedule | The schedule for the refresh job. | Small, 50.0 | 50.0 |
| shouldScoreAfterRefresh | Boolean | Indicates whether to automatically rescore records after a successful refresh (true) or not (false). | Small, 50.0 | 50.0 |
| userContext | SmartDataDiscoveryUser | The user context for the refresh job. | Small, 50.0 | 50.0 |
| warningThresholdPercentage | Double | The refresh warning threshold percentage for auto model deploy. | Small, 50.0 | 50.0 |

### Smart Data Discovery Refresh Job Collection
A collection of Einstein Discovery refresh jobs.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| refreshJobs | SmartDataDiscoveryRefreshJob[] | The list of refresh jobs available to the current user. | Small, 50.0 | 50.0 |
| totalSize | Integer | The total count of items in the collection. | Small, 50.0 | 50.0 |
| url | String | The URL to get the collection. | Small, 50.0 | 50.0 |

### Smart Data Discovery Refresh Job
An Einstein Discovery refresh job.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| createdBy | SmartDataDiscoveryUser | The user who created the refresh job. | Small, 50.0 | 50.0 |
| createdDate | Date | The creation date of the refresh job. | Small, 50.0 | 50.0 |
| endTime | Date | The end time of the refresh job. | Small, 50.0 | 50.0 |
| id | String | The ID of the refresh job. | Small, 50.0 | 50.0 |
| message | String | The extended message for the status of the refresh job, if available. | Small, 50.0 | 50.0 |
| refreshTarget | AssetReference | The refresh target for the refresh job. | Small, 50.0 | 50.0 |
| refreshTasksUrl | String | The URL to the refresh tasks collection for the refresh job. | Small, 50.0 | 50.0 |
| startTime | Date | The start time of the refresh job. | Small, 50.0 | 50.0 |
| status | SmartDataDiscoveryRefreshJobStatusEnum | The status of the refresh job. Valid values are: • Cancelled • CompletedWithWarnings • Failure • NoRunnableTask • NotStarted • Running • ScoringJobFailed • Success • UserNotFound | Small, 50.0 | 50.0 |
| type | SmartDataDiscoveryRefreshJobTypeEnum | The type of the refresh job. Valid values are: • Scheduled • UserTriggered | Small, 50.0 | 50.0 |
| url | String | The URL for the predict job. ⚠️(원문 설명 "predict job" — refresh job의 오기로 보임) | Small, 48.0 | 48.0 |

> ⚠️ `type`·`url` 두 프로퍼티는 PDF 페이지 경계에서 이어진 것(dump의 별도 표 조각). 원문 그대로 하나의 Refresh Job 표에 통합.

### Smart Data Discovery Refresh Task Collection
A collection of Einstein Discovery refresh task.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| refreshTasks | SmartDataDiscoveryRefreshTask[] | The list of refresh task available to the current user. | Small, 50.0 | 50.0 |
| totalSize | Integer | The total count of items in the collection. | Small, 50.0 | 50.0 |
| url | String | The URL to get the collection. | Small, 50.0 | 50.0 |

### Smart Data Discovery Refresh Task Source
The source for an Einstein Discovery refresh task.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| datasetVersion | AssetReference | The specific dataset version used for this refresh. | Small, 50.0 | 50.0 |
| story | AssetReference | The specific story used for this refresh. | Small, 50.0 | 50.0 |
| storyVersion | AssetReference | The specific story version used for this refresh. | Small, 50.0 | 50.0 |

### Smart Data Discovery Refresh Task
An Einstein Discovery refresh task.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| createdBy | SmartDataDiscoveryUser | The user who created the refresh task. | Small, 50.0 | 50.0 |
| createdDate | Date | The creation date of the refresh task. | Small, 50.0 | 50.0 |
| endTime | Date | The end time of the refresh task. | Small, 50.0 | 50.0 |
| id | String | The ID of the refresh task. | Small, 50.0 | 50.0 |
| message | String | The extended message for the status of the refresh task, if available. | Small, 50.0 | 50.0 |
| refreshTarget | AssetReference | The refresh target for the refresh task. | Small, 50.0 | 50.0 |
| refreshedAIModel | AssetReference | The refreshed AI model. | Small, 50.0 | 50.0 |
| source | SmartDataDiscoveryRefreshTaskSource | The input source used for the refresh task. | Small, 50.0 | 50.0 |
| startTime | Date | The start time of the refresh job. ⚠️(원문 "refresh job" — refresh task의 오기로 보임) | Small, 50.0 | 50.0 |
| status | SmartDataDiscoveryRefreshTaskStatusEnum | The status of the refresh task. Valid values are: • AnalysisNotFound • Cancelled • DatasetJoinFieldsMissing • DatasetNotFound • DatasetNotUpdated • Failure • LimitsReached • ModelSchemaChanged • NotStarted • OutcomeValuesChanged • PoissonDistributionDisabled • Running • StoryCreationFailure • Success • UserNotFound • WarningThresholdReached | Small, 50.0 | 50.0 |
| url | String | The URL for the predict job. ⚠️(원문 설명 "predict job" — refresh task의 오기로 보임) | Small, 48.0 | 48.0 |

### Smart Data Discovery Recipient
An Einstein Discovery recipient.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| displayName | String | The display name of the recipient. | Small, 50.0 | 50.0 |
| id | String | The ID of the recipient. | Small, 50.0 | 50.0 |
| type | SmartDataDiscoveryRecipientTypeEnum | The type of the recipient. Valid values are: • Group • User | Small, 50.0 | 50.0 |

---

## Predict History 계열

### Predict History Collection
A collection of historical predictions for a goal.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| goal | AssetReference | The prediction goal. | Small, 56.0 | 56.0 |
| history | PredictHistory | The prediction history. | Small, 56.0 | 56.0 |
| range | PredictHistoryRange | The range used to query the prediction history. | Small, 56.0 | 56.0 |

### Predict History
The historical predictions for a target.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| predictions | PredictHistoryValue[] | A list of the predictions that were made. | Small, 56.0 | 56.0 |
| target | String | The ID of prediction target. | Small, 56.0 | 56.0 |

### Predict History Range
A range used for the historical prediction query.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| interval | PredictHistoryIntervalEnum | The interval for look back. Valid values are: • None • Weekly | Small, 56.0 | 56.0 |
| maxLookBack | Integer | The maximum look back period. | Small, 56.0 | 56.0 |

### Predict History Value
A historical prediction value at a specific point in time.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| createdDate | Date | The date the prediction was made. | Small, 56.0 | 56.0 |
| model | AssetReference | The model used to make the prediction. | Small, 56.0 | 56.0 |
| value | String | The prediction value. | Small, 56.0 | 56.0 |

---

## Narrative 계열

### Smart Data Discovery Narrative Details
The textual narrative data for an Einstein Discovery story.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| text | String | The text for the narrative data. | Small, 51.0 | 51.0 |

### Smart Data Discovery Narrative Field Collection
A collection of narrative data for an Einstein Discovery story.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| postBody | SmartDataDiscoveryNarrativePostBody | The live metrics from running predictions. ⚠️(원문 설명 오류 — 다른 표현형 설명 붙여넣기로 보임) | Small, 51.0 | 51.0 |
| results | SmartDataDiscoveryNarrativeField[] | The list of fields for the narrative. | Small, 51.0 | 51.0 |

### Smart Data Discovery Narrative Field
A single row of narrative data for an Einstein Discovery story.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| field | String | The field name for the narrative data. | Small, 51.0 | 51.0 |
| narrative | SmartDataDiscoveryNarrativeDetails | The interpreted narrative for the condition. | Small, 51.0 | 51.0 |
| score | Double | The score for the condition. | Small, 51.0 | 51.0 |

### Smart Data Discovery Narrative Post Body
A single row of narrative data for an Einstein Discovery story.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| includeWarnings | Boolean | Indicates whether warnings are detected in this narrative (true) or not (false). | Small, 51.0 | 51.0 |
| query | SmartDataDiscoveryNarrativePostBodyQuery | The query parameters passed for the narrative. | Small, 51.0 | 51.0 |
| story | AssetReference | The story for the narrative. | Small, 51.0 | 51.0 |
| storyId | String | The ID of the story for this narrative. | Small, 51.0 | 51.0 |

### Smart Data Discovery Narrative Post Body Query
A query for narrative data of an Einstein Discovery story.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| filters | SmartDataDiscoveryNarrativePostBodyFilter[] | The list of filters for the query. | Small, 51.0 | 51.0 |
| insight | SmartDataDiscoveryNarrativePostBodyInsight | The insight for the query. | Small, 51.0 | 51.0 |

### Smart Data Discovery Narrative Post Body Filter
A query filter for narrative data of an Einstein Discovery story.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| columns | String[] | The list of columns for filtering the query. | Small, 51.0 | 51.0 |
| property | AbstractStoryDataProperty | The filter for the query service to use. Valid data properties are: • Story All Other Field Value • Story Day Field Value • Story Day Field Value • Story Field Only Value • Story Month Field Value • Story Month Of Year Field Value • Story Null Field Value • Story Quarter Field Value • Story Quarter Of Year Field Value • Story Range Field Value • Story Text Field Value • Story Year Field Value ⚠️(원문 그대로: "Story Day Field Value" 2회 중복, "Story Field Only Value"는 표현형명 "Story Field Only"와 불일치) | Small, 52.0 | 52.0 |
| values | String[] | The list of values to used to filter the query. ⚠️(원문 "to used" 오타) | Small, 51.0 | 51.0 |

### Smart Data Discovery Narrative Post Body Insight
The narrative insight metadata.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| insightType | ConnectEDInsightTypeEnum | The requested insight type. Valid values are: • Descriptive • Summary | Small, 51.0 | 51.0 |
| narrativeType | ConnectEDNarrativeTypeEnum | The requested narrative type. Valid values are: • Positive • Negative | Small, 51.0 | 51.0 |
| numInsights | Integer | The number of insights returned. | Small, 51.0 | 51.0 |

---

## 지원 표현형 (Insight · User · Directory)

### Smart Data Discovery Insight
An insight for an Einstein Discovery analysis.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| id | ID | The id of the insight. | Small, 44.0 | 44.0 |
| properties | Map<Object, Object> | A map of the properties for the insight. | Small, 44.0 | 44.0 |
| sortOrder | Integer | The sort order of the insight. | Small, 44.0 | 44.0 |

### Smart Data Discovery User
An Einstein Discovery user.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| id | String | The ID of the user. | Small, 41.0 | 41.0 |
| name | String | The name of the user. | Small, 41.0 | 41.0 |
| profilePhotoUrl | String | The Chatter profile photo of the user. | Small, 41.0 | 41.0 |

### Directory Item Collection
A collection of directory items.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| items | String | A list of items in the collection and their URLs. | Small, 50.0 | 50.0 |

---

## 관련 노트
- [[Einstein Discovery REST — 요청 표현형 (Request Bodies)]]
- [[Einstein Discovery REST — 응답 표현형 — 모델·필드·소스]]
- [[Einstein Discovery REST — 응답 표현형 — 스토리·인사이트]]
- [[Einstein Discovery REST — 리소스 엔드포인트 레퍼런스]]
- [[Einstein Discovery REST — Enums]]
