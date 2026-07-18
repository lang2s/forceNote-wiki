---
tags: [analytics, crm-analytics, data-prep, recipe, rest-api, request-body, load, output]
source: salesforce_recipes_api.pdf (Data Prep Recipe REST API Developer Guide, Summer '26)
created: 2026-06-21
aliases: [Load Node Input, Output Data Cloud Parameters Input, Time Series Parameters Input, Predict Values Node Input, Detect Sentiment, 레시피 로드 출력 노드, Data 360 출력]
---

# Recipe REST API — Load·Save·Output·ML 노드 Input

> Data Prep Recipe REST API에서 데이터 로드(Load)·저장(Save)·출력(Output D360/Data 360/External)·머신러닝(Detect Sentiment·Discovery·Predict Values·Time Series) 계열 노드를 정의하는 38개 request body 표현형 전수 — 각 Node Input은 Recipe Node Input을 상속한다.

---

이 노트는 Data Prep Recipe REST API의 **입출력(I/O) 및 머신러닝(ML) 계열 노드 input 표현형 38개**를 전수 정리한다. 각 노드는 `*Node Input`(노드 래퍼)과 `*Parameters Input`(파라미터 묶음) 쌍으로 구성되며, 보조 표현형(`Load Dataset Input` 계열, `Discovery Contributor Input`, `Predict Values Field Input` 등)이 파라미터를 채운다.

- **로드(Load)** — `Load Node Input` → `Load Parameters Input`. 데이터셋 종류(`Load Dataset Input` 4종 상속 계층)를 받아 레시피 입력을 정의.
- **저장(Save)** — `Save Node Input` → `Save Parameters Input` → `Save Dataset Input`.
- **출력(Output)** — D360 / Data 360(구 Data Cloud) / External 세 계열.
- **머신러닝(ML)** — Detect Sentiment · Einstein Discovery · Predict Values(결측치 예측) · Time Series · Time Series V2.

각 표 컬럼: **Property** · **Type** · **Description** · **Required or Optional** · **Available Version**. Type 명은 표현형 카탈로그(노이즈 방지)를 위해 wikilink 대신 `code`로만 표기한다.

> **상속 노트:** 아래 모든 `*Node Input` 표현형은 **Recipe Node Input**(`action`·`schema`·`sources`)을 상속한다. base 표현형의 속성은 [[Recipe REST API — Recipe 구성 Input]] 노트 참조. enum 값 전수(특히 `ConnectWaveDataConnectorTypeEnum` 39값)는 [[Recipe REST API — Enums]] 노트 참조.

---

## 로드 (Load)

### 1. Load Node Input

A load node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `LoadParametersInput` | The parameters for the node. | Required | 51.0 |

### 2. Load Parameters Input

The parameters for a load node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| dataset | `LoadDatasetInput` | The dataset to load. Valid values are: • Load Analytics Dataset Input • Load Connected Dataset Input • Load Data Lake Object Input • Load Data Model Object Input | Required | 51.0 |
| fields | `String[]` | The list of fields to load. | Required | 51.0 |
| preserveCurrencyFields | `String[]` | The list of fields to preserve currency for. | Optional | 65.0 |
| purgeCache | `Boolean` | Indicates whether to purge the cache (true) or not (false). | Optional | 57.0 |
| runMode | `InputRunModeEnum` | The input run mode. Valid values are: • Full • Incremental • Streaming | Optional | 57.0 |
| sampleDetails | `SampleParametersInput` | The sample parameters for the dataset load. | Required | 55.0 |
| sampleSize | `Integer` | The number of rows to load. | Required | 51.0 |

### 3. Load Dataset Input (base)

The base dataset for a load node in a recipe. Inherited by Load Analytics Dataset Input, Load Connected Dataset Input, Load Data Lake Object Input, Load Data Model Object Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| type | `RecipeDatasetType` | The type of the dataset. Valid values are: • Analytics • Connected • DataLakeObject • DataModelObject | Required | 51.0 |

### 4. Load Analytics Dataset Input

A CRM Analytics dataset to load. Inherits Load Dataset Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| name | `String` | The dataset name. | Required | 51.0 |

### 5. Load Connected Dataset Input

A connected dataset to load. Inherits Load Dataset Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| connectionName | `String` | The name of the connection. | Required | 51.0 |
| filter | `FilterParametersInput` | The pushdown filter. | Optional | 52.0 |
| mode | `ConnectedModeEnum` | The mode for accessing connected datasets. Valid values are: • AUTO • DIRECT • SYNCED | Optional | 65.0 |
| sourceObjectName | `String` | The name of the source object. | Required | 51.0 |

### 6. Load Data Lake Object Input

A data lake object to load. Inherits Load Dataset Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| name | `String` | The data lake object name. | Required | 56.0 |

### 7. Load Data Model Object Input

A data model object to load. Inherits Load Dataset Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| name | `String` | The data model object name. | Required | 56.0 |

---

## 저장 (Save)

### 8. Save Node Input

A save data node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `SaveParametersInput` | The parameters for the node. | Required | 49.0 |

### 9. Save Parameters Input

The parameters for a save node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| dataset | `SaveDatasetInput` | The dataset to save. | Required | 51.0 |
| dateConfigurationName | `String` | The date configuration name. | Required | 55.0 |
| fields | `String[]` | The list of fields to save. | Required | 51.0 |
| measuresToCurrencies | `MeasureToCurrencyInput[]` | A list of the measures to currencies. | Required | 56.0 |

### 10. Save Dataset Input

The dataset for a save node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| folderName | `String` | The analytics folder for the dataset. | Optional | 51.0 |
| isStaged | `Boolean` | Indicates whether the data is staged (true) or not (false). | Required | 53.0 |
| label | `String` | The label for the dataset. | Required | 51.0 |
| name | `String` | The name of the dataset. | Required | 51.0 |
| rowLevelSecurityFilter | `String` | The security predicate. | Required | 51.0 |
| rowLevelSharingSource | `String` | The sobject security sharing source. | Required | 51.0 |
| type | `String` | The type of the dataset. | Required | 51.0 |

---

## 출력 D360 (Output D360)

### 11. Output D360 Node Input

An output D360 node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `OutputD360ParametersInput` | The parameters for the node. | Required | 56.0 |

### 12. Output D360 Parameters Input

The parameters for an output D360 node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| fieldsMapping | `OutputD360FieldsMappingInput` | The list of field mappings. | Required | 56.0 |
| name | `String` | The name of the D360 object. | Required | 56.0 |
| streaming | `StreamingParametersInput[]` | The streaming parameters. | Required | 57.0 |
| type | `RecipeD360OutputType` | The output type. Valid values are: • DateLakeObject<sup>[sic]</sup> | Required | 56.0 |

> **[sic]** `type`의 valid value는 PDF 원문에 `DateLakeObject`(오타로 보이나 통상 *DataLakeObject*)로 표기되어 있다. 원문 그대로 보존한다.

### 13. Output D360 Fields Mapping Input

The fields mapping for an output D360 node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| sourceField | `String` | The name of the source field. | Required | 56.0 |
| targetField | `String` | The name of the target field. | Required | 56.0 |

---

## 출력 Data 360 (Output Data Cloud / Data 360)

> **Data 360 리브랜딩 노트 (원문 보존):** "As of October 14, 2025, Data Cloud has been rebranded to Data 360. During this transition, you may see references to Data Cloud in our application and documentation. While the name is new, the functionality and content remains unchanged."
> — 표현형명·Type명은 PDF 원문대로 `Output Data Cloud ...` / `ConnectWaveDataConnectorType...`을 유지하되, 설명문의 제품명은 Data 360을 따른다.

### 14. Output Data Cloud Node Input

An output Data 360 node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `OutputDataCloudParametersInput` | The parameters for the node. | Required | 60.0 |

### 15. Output Data Cloud Parameters Input

The parameters for an output Data 360 node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| category | `DataObjectCategoryInput` | The data category for the data lake object (DLO). | Required | 60.0 |
| connectorType | `ConnectWaveDataConnectorTypeEnum` | The output connector type. Valid values are: (39값 — `Recipe REST API — Enums` 노트 참조) | Required | 60.0 |
| dataspace | `AssetReferenceInput` | The dataspace to use in Data 360. | Required | DEPRECATED: min 60.0, max 64.0<sup>[sic]</sup> |
| dataspaces | `AssetReferenceInput[]` | A list of dataspaces to use in Data 360. | Required | 60.0 |
| dmoName | `String` | The name of the data model object (DMO). | Required | 67.0 |
| eventTimeField | `String` | The event time field. | Optional | 66.0 |
| fieldsMapping | `OutputDataCloudFieldsMappingInput[]` | The list of field mappings. | Required | 60.0 |
| label | `String` | The label of the Data 360 object. | Required | 60.0 |
| name | `String` | The name of the Data 360 object. | Required | 60.0 |
| primaryKey | `String` | The name of the primary key field for the Data 360 object. | Required | 60.0 |
| type | `RecipeDataCloudOutputTypeEnum` | The output type. Valid values are: • DateLakeObject<sup>[sic]</sup> | Required | 60.0 |

> **[sic] Version 셀:** `dataspace`의 Available Version 셀은 PDF 원문에 "DEPRECATED: min 60.0, max 64.0"로 기재되어 있다 — 통상의 단일 버전 번호가 아니라 deprecation 메모가 셀에 들어간 형태를 그대로 보존한다. 후속 대체 속성은 `dataspaces`(복수형).
> **[sic] type:** `type`의 valid value도 D360와 동일하게 `DateLakeObject`(원문 표기) 그대로.

### 16. Output Data Cloud Fields Mapping Input

The fields mapping for an output Data 360 node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| dataType | `String` | The data type of the target field. | Required | 60.0 |
| sourceField | `String` | The name of the source field. | Required | 60.0 |
| targetField | `String` | The name of the target field. | Required | 60.0 |
| targetLabel | `String` | The label of the target field. | Required | 60.0 |

---

## 출력 External (Output External)

### 17. Output External Node Input

An output external node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `OutputExternalParametersInput` | The parameters for the node. | Required | 56.0 |

### 18. Output External Parameters Input

The parameters for an output external node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| connectionName | `String` | The connection name. | Required | 51.0 |
| externalIdFieldName | `String` | The field name for the external ID. | Required | 51.0 |
| fieldsMapping | `OutputExternalFieldMappingInput[]` | The list of field mappings. | Required | 56.0 |
| hyperFileName | `String` | The name of hyper file. | Required | 54.0 |
| object | `String` | The object name. | Required | 51.0 |
| operation | `RecipeOutputExternalOperation` | The output external operation type. Valid values are: • Empty • Insert • Update • Upsert | Required | 51.0 |
| namedCredential | `Map<String,String>` | A map of key/value pairs of a named credential for a virtual private connection (VPC). | Optional | 65.0 |

### 19. Output External Fields Mapping Input

A field mapping for an output external node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| sourceField | `String` | The name of the source field. | Required | 51.0 |
| targetField | `String` | The name of the target field. | Required | 51.0 |

---

## ML — Detect Sentiment

### 20. Detect Sentiment Node Input

A detect sentiment node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `DetectSentimentParametersInput` | The parameters for the node. | Required | 51.0 |

### 21. Detect Sentiment Parameters Input

The parameters for a detect sentiment node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| outputType | `DetectSentimentOutputTypeEnum` | The output type. Valid values are: • Dimension • Measure | Required | 54.0 |
| sentimentScore | `SentimentScoreTypeEnum` | The sentiment score type. Valid values are: • All • None | Required | 54.0 |
| sourceField | `String` | The source field. | Required | 51.0 |
| targetField | `RecipeNameLabelInput` | The target field. | Required | 51.0 |
| targetSentimentScoreFields | `Map<String, Map<String, RecipeNameLabelInput>>` | The collection of target confidence fields. | Required | 54.0 |

---

## ML — Einstein Discovery

### 22. Discovery Node Input

An Einstein Discovery prediction node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `DiscoveryParametersInput` | The parameters for the node. | Required | 51.0 |

### 23. Discovery Parameters Input

The parameters for an Einstein Discovery prediction node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| columnMapping | `Map<String, String>` | The map of column mappings. | Required | 51.0 |
| multiClassFields | `DiscoveryContributorInput[]` | The list of multiclass fields. | Required | 56.0 |
| predictSource | `RecipeTypeNameInput` | The prediction source. | Required | 51.0 |
| predictionFactorFields | `DiscoveryContributorInput[]` | The list of prediction factor fields. | Required | 51.0 |
| predictionField | `RecipeNameLabelInput` | The prediction field. | Required | 51.0 |
| prescriptionFields | `DiscoveryContributorInput[]` | The list of prescription fields. | Required | 51.0 |

### 24. Discovery Contributor Input

The discovery contributor for an Einstein Discovery prediction field.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| field | `RecipeNameLabelInput` | The discovery field. | Required | 51.0 |
| impact | `RecipeNameLabelInput` | The discovery impact. | Required | 51.0 |

---

## ML — Extension

### 25. Extension Node Input

An extension node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `ExtensionParametersInput` | The parameters for the node. | Required | 51.0 |

### 26. Extension Parameters Input

The parameters for an extension node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| args | `Map<Object, Object>` | A map of extension arguments, defined by the extension definition | Required | 56.0 |
| name | `String` | The name of the extension. | Required | 56.0 |
| namespace | `String` | The namespace of the extension. | Required | 56.0 |
| version | `Double` | The version of the extension. | Required | 56.0 |

---

## ML — Predict Values (결측치 예측)

### 27. Predict Values Node Input

A predict missing values node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `PredictValuesParametersInput` | The parameters for the node. | Required | 51.0 |

### 28. Predict Values Parameters Input

The parameters for a predict values node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| fields | `PredictValuesFieldInput[]` | The list of fields. | Required | 51.0 |

### 29. Predict Values Field Input

A field for a predict values node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| label | `String` | The label for the field. | Required | 51.0 |
| name | `String` | The name for the field. | Required | 51.0 |
| predictionSetup | `PredictValuesSetupInput[]` | The setup for the field. | Required | 51.0 |

### 30. Predict Values Setup Input

The setup for a predict values node field.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| modelInputFields | `PredictValuesInputFieldInput[]` | The list of input fields for the model. | Required | 51.0 |
| sourceField | `PredictValuesInputFieldInput` | The source field. | Required | 51.0 |

### 31. Predict Values Input Field Input

An input field for a predict values node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| name | `String` | The field name. | Required | 51.0 |

---

## ML — Time Series

### 32. Time Series Node Input

A time series node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `TimeSeriesParametersInput` | The parameters for the node. | Required | 52.0 |

### 33. Time Series Parameters Input

The parameters for a time series node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| confidenceInterval | `RecipeTimeSeriesConfidenceIntervalType` | The confidence interval. Valid values are: • Eighty • NinetyFive • None | Required | 51.0 |
| confidenceIntervalFields | `Map<String, TimeSeriesInputConfidenceIntervalHighLow>` | The confidence interval field name and labels. | Required | 52.0 |
| dayField | `String` | The day field. | Required | 51.0 |
| forecastFields | `String[]` | The list of forecast fields. | Required | 51.0 |
| forecastLength | `Integer` | The forecast length. | Required | 51.0 |
| groupDatesBy | `RecipeGroupDatesBy` | The value to group dates by. Valid values are: • Year • YearMonth • YearMonthDay • YearQuarter • YearWeek | Required | 51.0 |
| ignoreLastTimePeriod | `Boolean` | Indicates whether to ignore the last time period (true) or not (false). | Required | 51.0 |
| model | `RecipeTimeSeriesModel` | The time series model. Valid values are: • Additive • Auto • Multiplicative | Required | 51.0 |
| seasonality | `Integer` | The seasonality. | Required | 51.0 |
| subYearField | `String` | The sub year field. | Required | 51.0 |
| targetDateField | `RecipeNameLabelInput` | The target date field. | Required | 51.0 |
| targetForecastFields | `RecipeNameLabelInput[]` | The list of target forecast fields. | Required | 51.0 |
| yearField | `String` | The year field. | Required | 51.0 |

### 34. Time Series Input Confidence Interval High Low

A confidence interval for a time series recipe node.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| high | `RecipeNameLabelInput` | The high confidence interval. | Required | 52.0 |
| low | `RecipeNameLabelInput` | The low confidence interval. | Required | 52.0 |

---

## ML — Time Series V2

### 35. Time Series V2 Node Input

A time series version 2 node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `TimeSeriesV2ParametersInput` | The parameters for the node. | Required | 54.0 |

### 36. Time Series V2 Parameters Input

The parameters for a time series version 2 node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| algorithm | `TimeSeriesV2ForecastAlgorithmEnum` | The forecast algorithm. Valid values are: • HoltWinters | Required | 54.0 |
| algorithmParameters | `TimeSeriesV2AlgorithmInput` | The parameters for the algorithm. | Required | 54.0 |
| confidenceInterval | `RecipeTimeSeriesConfidenceIntervalType` | The confidence interval. Valid values are: • Eighty • NinetyFive • None | Required | 54.0 |
| forecastDateField | `String` | The forecast date field. | Required | 54.0 |
| forecastDatesBy | `RecipeGroupDatesBy` | The value to group dates by. Valid values are: • FiscalYear • FiscalYearMonth • FiscalYearQuarter • FiscalYearWeek • YearMonth • YearMonthDay • YearQuarter • YearWeek | Required | 54.0 |
| forecastFields | `TimeSeriesV2ForecastInfoInput[]` | The list of forecast fields. | Required | 54.0 |
| forecastLength | `Integer` | The forecast length. | Required | 54.0 |
| forecastLengthType | `TimeSeriesV2ForecastLengthTypeEnum` | The forecast length type. Valid values are: • Rolling | Required | 54.0 |
| groupingFields | `ExtractGrainParameterInput[]` | The list of grouping fields. | Required | 54.0 |
| partialDataHandling | `TimeSeriesV2PartialDataHandlingEnum` | The partial data handling value. Valid values are: • IgnoreLast • None | Required | 54.0 |
| targetDateField | `RecipeNameLabelInput` | The target date field. | Required | 54.0 |

### 37. Time Series V2 Algorithm Input

The algorithm for a time series version 2 node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| model | `RecipeTimeSeriesModel` | The time series model. Valid values are: • Additive • Auto • Multiplicative | Required | 54.0 |
| seasonality | `Integer` | The seasonality value. | Required | 54.0 |

### 38. Time Series V2 Forecast Info Input

The forecast info for a time series version 2 node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| aggregate | `AggregateInput` | The aggregate data. | Required | 54.0 |
| confidenceIntervalFields | `TimeSeriesOutputConfidenceIntervalHighLow` | The confidence interval field name and labels. | Required | 54.0 |
| forecastField | `RecipeNameLabelInput` | The aggregate data.<sup>[sic — 중복 설명]</sup> | Small, v54.0<sup>[sic]</sup> | 54.0 |

> **[sic] forecastField:**
> - Description 셀이 PDF 원문에 "The aggregate data."로 적혀 있다 — 바로 위 `aggregate` 속성과 동일한 설명이 중복 기재된 상태를 그대로 보존한다.
> - Required/Optional 셀이 PDF 원문에 "Small, v54.0"로 기재되어 있다 — 통상의 Required/Optional 값이 아니라 그 자리에 다른 텍스트가 들어간 형태로, 원문 그대로 보존한다.

---

## request body 예시

```json
// 구조 예시 — 실제 동작 설정 아님 (위 표현형 조합 예시)
{
  "nodeType": "Load",
  "parameters": {
    "dataset": {
      "type": "Analytics",
      "name": "Opportunities"
    },
    "fields": ["Id", "Amount", "StageName"],
    "sampleSize": 1000,
    "runMode": "Full"
  }
}
```

---

## 관련 노트

- [[Einstein Discovery — Model Builder·예측 모델]]
- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]]
- [[Recipe REST API — Recipe 구성 Input]]
- [[Recipe REST API — Enums]]
