---
tags: [einstein, einstein-discovery, rest-api, request-body, representation, reference]
source: bi_dev_guide_rest_sdd.pdf (Einstein Discovery REST API Developer Guide — Request Bodies)
created: 2026-07-19
aliases: [Einstein Discovery REST Request Bodies, Smart Data Discovery Input, AI Model Input, Predict Input, Predict Job Input, Story Query Input, Narrative Input, 요청 표현형, Model Runtime Input]
---

# Einstein Discovery REST — 요청 표현형 (Request Bodies)

> Einstein Discovery REST API 요청 바디(Input) 86종 — AI Model·Model Field·Runtime(H2O/Scikit/TensorFlow)·Source·Transformation·Predict·Predict Job·Projected Predictions·Story·Narrative Input의 프로퍼티 전수.

---

## 개요

이 노트는 Einstein Discovery REST API Developer Guide(`bi_dev_guide_rest_sdd.pdf`)의 **"Einstein Discovery REST API Request Bodies"** 챕터(PDF 물리 p.51–90)에 정의된 **86개 요청 표현형(Request Body / Input)** 을 전수 전사한다. 이 Input들을 실제 요청 바디로 소비하는 리소스·엔드포인트는 [[Einstein Discovery REST — 리소스 엔드포인트 레퍼런스]]를 참조한다.

### 표 스키마 (모든 프로퍼티 표 공통 5컬럼)

모든 프로퍼티 표는 다음 5컬럼을 가진다.

| 컬럼 | 의미 |
|---|---|
| **Property Name** | 프로퍼티(필드) 이름 |
| **Type** | 데이터 타입 (Enum·Input 표현형·String·Integer·Boolean 등) |
| **Description** | 설명 (enum이면 `Valid values are:` 로 유효 값 전수) |
| **Required or Optional** | 필수/선택 (일부 셀은 PDF 폰트 주석 누출로 `"Small, NN.0"` 표기 — 아래 "원문 이상" 참조) |
| **Available Version** | 도입된 API 버전 (예: `48.0`) |

> **Filter Group / Small 표기 주의:** PDF 표의 좌열에는 원본에 없던 `"Small, NN.0"` 문자열이 **Required or Optional 셀에 렌더링**되는 경우가 있다. 이는 폰트-크기 주석("Small,")이 표 셀로 새어 들어온 **추출 아티팩트**로, 실제 Required/Optional 값이 미표기된 것이다. 아래 표에서는 원문 그대로 `⚠️ "Small, NN.0"` 로 보존한다(창작으로 채우지 않음).

### abstract → 구체 상속 패턴

이 챕터의 표현형은 **abstract 베이스 → 구체 하위** 상속 계층으로 구성된다. `Abstract...Input`은 공통 프로퍼티(주로 `type` 판별자)를 정의하고, 구체 하위 표현형이 이를 상속(`Inherits properties from ...`)한다. 다수 표현형은 **자체 프로퍼티 표가 없고 상속-only 또는 type-only**다(각 항목에 명시). top-level가 아닌 request body는 root XML 태그가 없다(서두 예시: Comment request body `{ "body": "..." }` / XML `<comment><body>...</body></comment>`).

```text
// 구조 예시 — 실제 동작 설정 아님
AbstractSmartDataDiscoveryModelRuntimeInput  (type 판별자만 정의)
├── SmartDataDiscoveryDiscoveryModelRuntimeInput      (상속-only)
├── SmartDataDiscoveryH20ModelRuntimeInput            (상속-only)
├── SmartDataDiscoveryScikitLearn102ModelRuntimeInput (상속-only)
├── SmartDataDiscoveryTensorFlow27ModelRuntimeInput   (상속-only)
└── SmartDataDiscoveryTensorFlowModelRuntimeInput     (상속-only)
```

> **추출 아티팩트 고지:** 아래 표는 PDF의 5컬럼 표가 plain `pdftotext`에서 붕괴하여, **`pdftotext -layout` 버전을 정본**으로 재구성했다. 타입명·긴 프로퍼티명이 원본에서 여러 줄로 분리된 것은 논리 복원했다(예: `sourceField / Names` → `sourceFieldNames`). 이 챕터에는 다이어그램/figure/트리가 없다(전부 텍스트 표).

---

## 표현형 로스터 (Alphabetical, PDF ToC 순서 = 총 86개)

PDF 챕터 목차 순서. 다수는 abstract 또는 상속-only라 자체 프로퍼티 표가 없다(각 항목에서 명시).

| # | 표현형 | 설명 (PDF ToC) |
|---|---|---|
| 1 | Abstract Classification Threshold Input | The base classification threshold input. |
| 2 | Abstract Smart Data Discovery AI Model Source Input | The base source input for an Einstein Discovery AI model. |
| 3 | Abstract Smart Data Discovery Field Mapping Source Input | The base Einstein Discovery field mapping source input. |
| 4 | Abstract Smart Data Discovery Many To One Transformation Input | The base input to identify the transformation as many to one. |
| 5 | Abstract Smart Data Discovery Model Field Input | The base Einstein Discovery model field create or update. |
| 6 | Abstract Smart Data Discovery Model Runtime Input | The base Einstein Discovery model runtime input. |
| 7 | Abstract Smart Data Discovery One To One Transformation Input | The base input to identify the transformation as one to one. |
| 8 | Abstract Smart Data Discovery Predict Input | The base predict input for Einstein Discovery. |
| 9 | Abstract Smart Data Discovery Prediction Property Input | The base Einstein Discovery prediction property input. |
| 10 | Abstract Smart Data Discovery Projected Predictions Interval Setting Input | The base Einstein Discovery projected predictions interval settings input. |
| 11 | Abstract Smart Data Discovery Transformation Filter Input | The base Einstein Discovery transformation filter input. |
| 12 | Abstract Smart Data Discovery Transformation Input | The base Einstein Discovery transformation input. |
| 13 | Abstract Smart Data Discovery Transformation Override Input | The base Einstein Discovery transformation deploy override input. |
| 14 | Abstract Story Data Property Input | The base Einstein Discovery story data property filter. |
| 15 | Asset Reference Input | An Einstein Discovery asset reference. This wraps the BaseAssetReferenceInput. |
| 16 | Base Asset Reference Input | The base Einstein Discovery asset, inherited by AssetReferenceInput. |
| 17 | Binary Classification Threshold Input | A binary classification threshold input. |
| 18 | Predict History Input | The query input for prediction history. |
| 19 | Predict History Range Input | The range for prediction history query. |
| 20 | Smart Data Discovery AI Model Discovery Source Input | The discovery source input for a Smart Data Discovery AI Model. |
| 21 | Smart Data Discovery AI Model Input | The Einstein Discovery AI model to create or update. |
| 22 | Smart Data Discovery AI Model Transformation Input | The input for an Einstein Discovery AI model transformation. |
| 23 | Smart Data Discovery AI Model User Upload Source Input | The user upload source input for a Smart Data Discovery AI Model. |
| 24 | Smart Data Discovery Categorical Imputation Transformation Input | The input to identify the transformation as categorical imputation. |
| 25 | Smart Data Discovery Classification Prediction Property Input | The input to identify the prediction type as Classification. |
| 26 | Smart Data Discovery Cluster Input | The input for cluster definitions. |
| 27 | Smart Data Discovery Complex Filter Input | The complex filter input for Einstein Discovery. |
| 28 | Smart Data Discovery Custom Prescribable Field Definition Input | The input for a custom Einstein Discovery prescribable field definition to override default prescription text. |
| 29 | Smart Data Discovery Customizable Field Input | Input for an Einstein Discovery customizable field. |
| 30 | Smart Data Discovery Discovery Model Runtime Input | The input to identify the model runtime type as Discovery. |
| 31 | Smart Data Discovery Extract Day of Week Transformation Input | The input for an extract day of week transformation. |
| 32 | Smart Data Discovery Extract Month of Year Transformation Input | The input for an extract month of year transformation. |
| 33 | Smart Data Discovery Field Mapping Analytics Dataset Field Input | Input for an Einstein Discovery field mapped from an analytics dataset source. |
| 34 | Smart Data Discovery Field Mapping Input | An Einstein Discovery field mapping. |
| 35 | Smart Data Discovery Field Mapping Salesforce Field Input | Input for an Einstein Discovery field mapped from a Salesforce field source. |
| 36 | Smart Data Discovery Filter Input | The filter input for Einstein Discovery. |
| 37 | Smart Data Discovery Filter Value Input | The filter value input for Einstein Discovery. |
| 38 | Smart Data Discovery Free Text Clustering Transformation Input | The input for a free text clustering transformation. |
| 39 | Smart Data Discovery H20 Model Runtime Input | The input to identify the model runtime type as H20. |
| 40 | Smart Data Discovery Model Input | The Einstein Discovery model to create or update. |
| 41 | Smart Data Discovery Model Field Date Input | The Einstein Discovery date model field create or update. |
| 42 | Smart Data Discovery Model Field Numeric Input | The Einstein Discovery numeric model field create or update. |
| 43 | Smart Data Discovery Model Field Text Input | The Einstein Discovery text model field create or update. |
| 44 | Smart Data Discovery Multiclass Classification Prediction Property Input | The input to identify the prediction type as Multiclass Classification. |
| 45 | Smart Data Discovery Narrative Filter Input | The narrative filter metadata. |
| 46 | Smart Data Discovery Narrative Input | The Einstein Discovery story narrative to retrieve. |
| 47 | Smart Data Discovery Narrative Insight Input | The narrative insight metadata. |
| 48 | Smart Data Discovery Narrative Query Input | The query metadata for the Einstein Discovery story narrative to retrieve. |
| 49 | Smart Data Discovery Numeric Range Input | A numeric range for a field. |
| 50 | Smart Data Discovery Numeric Transformation Filter Input | The input for a numeric transformation filter. |
| 51 | Smart Data Discovery Numerical Imputation Transformation Input | The input for a numerical imputation transformation. |
| 52 | Smart Data Discovery Predict Extension Input | The predict record extension input for Einstein Discovery. |
| 53 | Smart Data Discovery Predict Input | The predict input for Einstein Discovery. |
| 54 | Smart Data Discovery Predict Nested Row List Input | The predict nested row list input for Einstein Discovery. |
| 55 | Smart Data Discovery Predict Job Input | The predict job input for Einstein Discovery. |
| 56 | Smart Data Discovery Predict Job Update Input | The input to update a predict job for Einstein Discovery. |
| 57 | Smart Data Discovery Predict Settings Input | The predict settings input for Einstein Discovery. |
| 58 | Smart Data Discovery Predict Raw Data Input | The predict raw data input for Einstein Discovery. |
| 59 | Smart Data Discovery Predict Record Overrides Input | The predict record overrides input for Einstein Discovery. |
| 60 | Smart Data Discovery Predict Record Input | The predict record input for Einstein Discovery. |
| 61 | Smart Data Discovery Prescribable Field Input | Input for an Einstein Discovery prescribable field. |
| 62 | Smart Data Discovery Projected Prediction Settings Input | The projected prediction settings input for Einstein Discovery. |
| 63 | Smart Data Discovery Projected Predictions Count From Date Interval Setting Input | The input for settings for an Einstein Discovery count from date based projection interval. |
| 64 | Smart Data Discovery Projected Predictions Count Interval Setting Input | The input for settings for an Einstein Discovery count based projection interval. |
| 65 | Smart Data Discovery Projected Predictions Date Interval Setting Input | The input for settings for an Einstein Discovery date interval. |
| 66 | Smart Data Discovery Projected Predictions Historical Dataset Source Input | The input for projected predictions transformation. |
| 67 | Smart Data Discovery Projected Predictions Override Input | The input for deploy time projected predictions transformation overrides. |
| 68 | Smart Data Discovery Projected Predictions Transformation Input | The input for a projected predictions transformation. |
| 69 | Smart Data Discovery Regression Prediction Property Input | The input to identify the prediction type as Regression. |
| 70 | Smart Data Discovery Scikit Learn 102 Model Runtime Input | The input to identify the model runtime type as Scikit Learn v1.0.2. |
| 71 | Smart Data Discovery Sentiment Analysis Transformation Input | The input for a sentiment analysis transformation. |
| 72 | Smart Data Discovery TensorFlow 27 Model Runtime Input | The input to identify the model runtime type as TensorFlow v2.7.0. |
| 73 | Smart Data Discovery TensorFlow Model Runtime Input | The input to identify the model runtime type as TensorFlow. |
| 74 | Smart Data Discovery Text Transformation Filter Input | The input for a text transformation filter. |
| 75 | Story Day Field Value Input | The story data day property. |
| 76 | Story Day of Week Field Value Input | The story data day of week property. |
| 77 | Story Field Only Input | The story data field property. |
| 78 | Story Month Field Value Input | The story data month property. |
| 79 | Story Month of Year Field Value Input | The story data month of year property. |
| 80 | Story Null Field Value Input | The story data null property. |
| 81 | Story Quarter Field Value Input | The story data quarter property. |
| 82 | Story Quarter of Year Field Value Input | The story data quarter of year property. |
| 83 | Story Query Input | The input to query an Einstein Discovery story. |
| 84 | Story Range Field Value Input | The story data range property. |
| 85 | Story Text Field Value Input | The story data text property. |
| 86 | Story Year Field Value Input | The story data year property. |

**총 86개 표현형.** (자체 프로퍼티 표 없이 상속-only/type-only인 것 다수 포함.)

---

## 자산 참조·분류 임계값 (Asset Reference / Classification Threshold)

### 15. Asset Reference Input
An Einstein Discovery asset reference. This wraps the BaseAssetReferenceInput.

**상속/구성:** Properties = Base Asset Reference Input (자체 프로퍼티 표 없음 — BaseAssetReferenceInput를 래핑). `id`/`name`/`namespace` 프로퍼티는 아래 #16 Base Asset Reference Input 참조.

### 16. Base Asset Reference Input
The base Einstein Discovery asset, inherited by AssetReferenceInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| id | String | The ID of the asset. | Required | 42.0 |
| name | String | The developer name of the asset. | Required | 42.0 |
| namespace | String | The namespace that qualifies the asset name. | Optional | 42.0 |

### 1. Abstract Classification Threshold Input
The base classification threshold input.

**상속:** Inherited by Binary Classification Threshold Input.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| type | ClassificationTypeEnum | The classification type. Valid values are: • Binary | Required | 47.0 |

### 17. Binary Classification Threshold Input
A binary classification threshold input.

**상속:** Inherits properties from AbstractClassificationThresholdInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| value | Double | The data for a source analysis. | Required | 47.0 |

---

## AI 모델·모델 (AI Model / Model)

### 21. Smart Data Discovery AI Model Input
The Einstein Discovery AI model to create or update.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| description | String | The description for the AI model. | Optional | 48.0 |
| input | AbstractSmartDataDiscoveryAIModelSourceInput | The input source for the AI model. Valid data properties are: • Smart Data Discovery AI Model Discovery Source Input • Smart Data Discovery AI Model User Upload Source Input | Required | 48.0 |
| label | String | The label for the AI model. | Optional | 48.0 |
| modelFields | AbstractSmartDataDiscoveryModelFieldInput[] | The list of model fields for the AI model. Valid values are: • SmartDataDiscoveryModelFieldDateInput • SmartDataDiscoveryModelFieldNumericInput • SmartDataDiscoveryModelFieldTextInput | Required | 48.0 |
| input ⚠️(중복 프로퍼티명) | AbstractSmartDataDiscoveryModelRuntimeInput | The runtime for the AI model. Valid runtimes are: • Smart Data Discovery Discovery Model Runtime Input • Smart Data Discovery H2O Model Runtime Input • Smart Data Discovery ScikitLearn 120 Model Runtime Input • Smart Data Discovery TensorFlow 27 Model Runtime Input • Smart Data Discovery TensorFlow Model Runtime Input | Required | 48.0 |
| name | String | The developer name for the AI model. | Required | 48.0 |
| predictedField | String | The field name that the AI model is trying to predict. | Optional | 48.0 |
| predictionProperty | AbstractSmartDataDiscoveryPredictionPropertyInput | The prediction property of the AI model. Valid prediction properties are: • Smart Data Discovery Classification Prediction Property Input • Smart Data Discovery Multiclass Classification Prediction Property Input • Smart Data Discovery Regression Prediction Property Input | Optional | 48.0 |
| status | ConnectEDInsightTypeEnum | The status of the AI model. Valid values are: • Disabled • Enabled • UploadCompleted • UploadFailed • Uploading • Validating • ValidationCompleted • ValidationFailed | Optional | 49.0 |
| transformations | Smart Data Discovery AI Model Transformation Input[] | A list of transformations associated with this AI model. | ⚠️ "Small, 48.0" | 48.0 |
| validationResult | Object | The validation result of the AI model. | Optional | 50.0 |

> **⚠️ 원문 이상 2건 (PDF 원문 그대로 보존):**
> 1. 프로퍼티명 `input`이 두 번 등장 — 하나는 source input(`AbstractSmartDataDiscoveryAIModelSourceInput`), 다른 하나는 runtime(`AbstractSmartDataDiscoveryModelRuntimeInput`). 서로 다른 타입인데 프로퍼티명이 동일하다.
> 2. `transformations`의 Required/Optional 셀에 `"Small, 48.0"` 렌더링(폰트 주석 누출) — 실제 R/O 값 미표기.
> - `status` enum 값 `ValidationCompleted`·`ValidationFailed`는 페이지 경계(p.65→66)에서 표가 절단되어 이어짐(AP-09 주의) — 이어짐 확인 완료.
> - runtime `input`의 valid runtimes에 나열된 `ScikitLearn 120`은 실제 표현형 `Scikit Learn 102`와 숫자 불일치, `H2O`는 표현형명 `H20`과 O/0 불일치(원문 보존).

### 40. Smart Data Discovery Model Input
The Einstein Discovery model to create or update.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| analysis | AssetReferenceInput | The analysis connected with the given model. | Optional | 46.0 |
| classificationThreshold | AbstractClassificationThresholdInput | The classification threshold for the model. Valid values are: • BinaryClassificationThresholdInput | Required | 48.0 |
| customizableFactors | SmartDataDiscoveryCustomizableFieldInput[] | A list of customizable top factors for the model. | Optional | 57.0 |
| fieldMapping | SmartDataDiscoveryFieldMappingInput[] | A list mapping the model fields to Salesforce fields. | Required | 48.0 |
| filterList | SmartDataDiscoveryComplexFilterInput[] | A list of filters used to determine whether a row can be evaluated by this model. | Required | 41.0 |
| isRefreshEnabled | Boolean | Indicates whether this model is included in the refresh schedule (true) or not (false). | Optional | 50.0 |
| label | String | The label of the model. | Required | 41.0 |
| model | AssetReferenceInput | A ID for the associated AI model. | Required | 48.0 |
| name | String | The developer name of the model. | ⚠️ "Small, 41.0" | 41.0 |
| prescribableFields | SmartDataDiscoveryPrescribableFieldInput[] | A list of the prescribable fields for the model. | Required | 48.0 |
| sortOrder | Integer | A unique number indicating the order in which this model's filters are evaluated compared to all other models in the parent prediction definition. | Required | 41.0 |
| status | SmartDataDiscoveryStatusEnum | The status of the model. Valid values are: • Disabled • Enabled | Required | 46.0 |
| transformationOverrides | AbstractSmartDataDiscoveryPrescribableField[] ⚠️ | A list of the transformation overrides for the model. Valid values are: • Smart Data Discovery Projected Predictions Override Input | Required | 48.0 |

> **⚠️ 원문 이상 2건 (PDF 원문 그대로 보존):**
> 1. `name`의 Required/Optional 셀에 `"Small, 41.0"` 렌더링(폰트 주석 누출) — 실제 R/O 값 미표기.
> 2. `transformationOverrides`의 Type이 `AbstractSmartDataDiscoveryPrescribableField[]`로 렌더링되나, valid value는 `Smart Data Discovery Projected Predictions Override Input`(= `AbstractSmartDataDiscoveryTransformationOverrideInput` 계열)이라 **타입명이 내용과 불일치**. 추출 컬럼 붕괴 가능성 또는 원문 오기 — 원문 그대로 보존.

---

## 모델 소스 (Model Source)

### 2. Abstract Smart Data Discovery AI Model Source Input
The base source input for an Einstein Discovery AI model.

**상속:** Inherited by Smart Data Discovery AI Model Discovery Source Input and Smart Data Discovery AI Model User Upload Source Input.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryModelSourceTypeEnum | The model source type. Valid values are: • Discovery • UserUpload | Required | 51.0 |

### 20. Smart Data Discovery AI Model Discovery Source Input
The discovery source input for a Smart Data Discovery AI Model.

**상속:** Inherits properties from AbstractSmartDataDiscoveryAIModelDiscoverySourceInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| runId | Asset Reference Input | The run ID that created this AI model. | Required | 48.0 |

> **⚠️ 원문 불일치 (보존):** inherits-from 문자열 `AbstractSmartDataDiscoveryAIModelDiscoverySourceInput`은, 로스터의 abstract가 `Abstract Smart Data Discovery AI Model Source Input`(= `AbstractSmartDataDiscoveryAIModelSourceInput`)이라 `Discovery`가 추가된 불일치.

### 23. Smart Data Discovery AI Model User Upload Source Input
The user upload source input for a Smart Data Discovery AI Model.

**상속:** Inherits properties from AbstractSmartDataDiscoveryAIModelDiscoverySourceInput. (자체 프로퍼티 표 없음.)

> **⚠️ 원문 불일치 (보존):** inherits-from에 `...Discovery...` 포함 — #20과 동일한 불일치 패턴.

---

## 모델 필드 (Model Field)

### 5. Abstract Smart Data Discovery Model Field Input
The base Einstein Discovery model field create or update.

**상속:** Inherited by Smart Data Discovery Model Field Date Input, Smart Data Discovery Model Numeric Field Input and Smart Data Discovery Model Field Text Input.
> **⚠️ 원문 불일치 (보존):** 상속-by 목록의 `Smart Data Discovery Model Numeric Field Input`은 실제 표현형명 `Smart Data Discovery Model Field Numeric Input`과 어순 불일치.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| disparateImpact | Boolean | Indicates whether the model field is disparate impact (true) or not (false). | Required | 55.0 |
| label | String | The label of the model field. | Required | 48.0 |
| name | String | The name of the model field. | Required | 48.0 |
| sensitive | Boolean | Indicates whether the model field is sensitive (true) or not (false). | Optional | 55.0 |
| type | SmartDataDiscoveryModelFieldTypeEnum | The type of the model field. Valid values are: • Date • Number • Text | ⚠️ "Small, 48.0" | 48.0 |

> **⚠️ 원문 이상 (보존):** `type`의 Required/Optional 셀에 `"Small, 48.0"` 렌더링(폰트 크기 주석 누출) — 실제 Required/Optional 값 미표기.

### 41. Smart Data Discovery Model Field Date Input
The Einstein Discovery date model field create or update.

**상속:** Inherits properties from AbstractSmartDataDiscoveryModelFieldInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| values | String[] | A list of model field unique values. | Required | 56.0 |

### 42. Smart Data Discovery Model Field Numeric Input
The Einstein Discovery numeric model field create or update.

**상속:** Inherits properties from AbstractSmartDataDiscoveryModelFieldInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| values | SmartDataDiscoveryNumericRangeInput[] | A list of model field unique values. | Required | 56.0 |

### 43. Smart Data Discovery Model Field Text Input
The Einstein Discovery text model field create or update.

**상속:** Inherits properties from AbstractSmartDataDiscoveryModelFieldInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| values | String[] | A list of model field unique values. | Required | 56.0 |

### 49. Smart Data Discovery Numeric Range Input
A numeric range for a field.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| max | Double | The maximum value for the range. | Required | 57.0 |
| min | Double | The minimum value for the range. | Required | 57.0 |

### 26. Smart Data Discovery Cluster Input
The input for cluster definitions.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| ignored | Boolean | Indicates whether the cluster is ignored (true) or not (false). | Required | 55.0 |
| label | String | The label for the cluster. | Optional | 55.0 |
| name | String | The name for the cluster. | Required | 55.0 |
| values | String[] | A list of values in the cluster. | Required | 55.0 |

---

## 모델 런타임 (Model Runtime)

### 6. Abstract Smart Data Discovery Model Runtime Input
The base Einstein Discovery model runtime input.

**상속:** Inherited by Smart Data Discovery Discovery Model Runtime Input, Smart Data Discovery H2O Model Runtime Input, Smart Data Discovery ScikitLearn 120 Model Runtime Input, Smart Data Discovery TensorFlow 27 Model Runtime Input, and Smart Data Discovery TensorFlow Model Runtime Input.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryModelRuntimeTypeEnum | The runtime type for the model. Valid values are: • Discovery • H2O • Py36Tensorflow244 (TensorFlow) • Py37Scikitlearn102 (Scikit Learn v1.0.2) • Py37Tensorflow207 (TensorFlow v2.7.0) | Required | 49.0 |

> **⚠️ 원문 불일치 (보존):** 상속-by 목록 `ScikitLearn 120`은 실제 표현형 `Scikit Learn 102`와 숫자 불일치, `H2O`는 표현형명 `H20`과 O/0 불일치.

### 30. Smart Data Discovery Discovery Model Runtime Input
The input to identify the model runtime type as Discovery.

**상속:** Inherits properties from AbstractSmartDataDiscoveryModelRuntimeInput. (자체 프로퍼티 표 없음.)

### 39. Smart Data Discovery H20 Model Runtime Input
The input to identify the model runtime type as H20.

**상속:** Inherits properties from AbstractSmartDataDiscoveryModelRuntimeInput. (자체 프로퍼티 표 없음.)

> **⚠️ 원문 불일치 (보존):** 표현형명·설명 모두 `H20`(숫자 0) 사용. 반면 상위 abstract의 enum 값·상속-by 목록은 `H2O`(문자 O) 사용.

### 70. Smart Data Discovery Scikit Learn 102 Model Runtime Input
The input to identify the model runtime type as Scikit Learn v1.0.2.

**상속:** Inherits properties from AbstractSmartDataDiscoveryModelRuntimeInput. (자체 프로퍼티 표 없음.)

### 72. Smart Data Discovery TensorFlow 27 Model Runtime Input
The input to identify the model runtime type as TensorFlow v2.7.0.

**상속:** Inherits properties from AbstractSmartDataDiscoveryModelRuntimeInput. (자체 프로퍼티 표 없음.)

### 73. Smart Data Discovery TensorFlow Model Runtime Input
The input to identify the model runtime type as TensorFlow.

**상속:** Inherits properties from AbstractSmartDataDiscoveryModelRuntimeInput. (자체 프로퍼티 표 없음.)

---

## 예측 속성 (Prediction Property)

### 9. Abstract Smart Data Discovery Prediction Property Input
The base Einstein Discovery prediction property input.

**상속:** Inherited by Smart Data Discovery Classification Prediction Property Input, Smart Data Discovery Multiclass Classification Prediction Property Input, and Smart Data Discovery Regression Prediction Property Input.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryPredictionTypeEnum | The prediction type for the model. Valid values are: • Classification • MulticlassClassification • Regression • Unknown | Required | 55.0 |

### 25. Smart Data Discovery Classification Prediction Property Input
The input to identify the prediction type as Classification.

**상속:** Inherits properties from AbstractSmartDataDiscoveryPredictionPropertyInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| algorithmType | SmartDataDiscoveryClassificationAlgorithmTypeEnum | The algorithm type for the classification. Valid values are: • Best (Model tournament) • Drf (Distributed Random Forest) • Gbm (GBM) • Glm (GLM) • Xgboost (XGBoost) | Required | 49.0 |
| classificationThreshold | AbstractClassificationThresholdInput | The classification threshold for the model. Valid values are: • BinaryClassificationThresholdInput | Required | 48.0 |

> `classificationThreshold`는 p.67→68 경계에서 이어짐(확인 완료).

### 44. Smart Data Discovery Multiclass Classification Prediction Property Input
The input to identify the prediction type as Multiclass Classification.

**상속:** Inherits properties from AbstractSmartDataDiscoveryPredictionPropertyInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| algorithmType | SmartDataDiscoveryClassificationAlgorithmTypeEnum | The algorithm type for the classification. Valid values are: • Best (Model tournament) • Drf (Distributed Random Forest) • Gbm (GBM) • Glm (GLM) • Xgboost (XGBoost) | Required | 52.0 |

### 69. Smart Data Discovery Regression Prediction Property Input
The input to identify the prediction type as Regression.

**상속:** Inherits properties from AbstractSmartDataDiscoveryPredictionPropertyInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| algorithmType | SmartDataDiscoveryRegressionAlgorithmTypeEnum | The algorithm type for the classification. Valid values are: • Drf (Distributed Random Forest) • Gbm (GBM) • Glm (GLM) • Xgboost (XGBoost) | Required | 52.0 |

> **⚠️ 원문 이상 (보존):** description `The algorithm type for the classification.`는 Regression 표현형인데 `classification`으로 오기. Classification enum과 달리 `Best` 값 없음.

---

## 필드 매핑 (Field Mapping)

### 3. Abstract Smart Data Discovery Field Mapping Source Input
The base Einstein Discovery field mapping source input.

**상속:** Inherited by Smart Data Discovery Field Mapping Analytics Dataset Field Input and Smart Data Discovery Field Mapping Salesforce Field Input.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryFieldMapSourceTypeEnum | The source type for the field mapping. Valid values are: • AnalyticsDatasetField • SalesforceField | Required | 48.0 |

### 33. Smart Data Discovery Field Mapping Analytics Dataset Field Input
Input for an Einstein Discovery field mapped from an analytics dataset source.

**상속:** Inherits properties from AbstractSmartDataDiscoveryFieldMappingSourceInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| sobjectFieldJoinKey | String | The sObject field name used as the join key. | Required | 48.0 |
| source | AssetReferenceInput | A source ID of the analytics dataset asset. | Required | 48.0 |
| sourceFieldJoinKey | String | The source dataset field name used as the join key. | Required | 48.0 |

### 34. Smart Data Discovery Field Mapping Input
An Einstein Discovery field mapping.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| input | AbstractSmartDataDiscoveryFieldMappingSourceInput | The field mapping source. Valid values are: • Smart Data Discovery Field Mapping Analytics Dataset Field Input • Smart Data Discovery Field Mapping Salesforce Field Input | Required | 48.0 |
| mappedFieldName | String | The mapped field name. | Required | 48.0 |
| modelFieldName | String | The model field. | Required | 48.0 |

### 35. Smart Data Discovery Field Mapping Salesforce Field Input
Input for an Einstein Discovery field mapped from a Salesforce field source.

**상속:** Inherits properties from AbstractSmartDataDiscoveryFieldMappingSourceInput. (자체 프로퍼티 표 없음.)

---

## 변환 (Transformation)

### 12. Abstract Smart Data Discovery Transformation Input
The base Einstein Discovery transformation input.

**상속:** Inherited by Abstract Smart Data Discovery Discovery Many To One Transformation Input and Abstract Smart Data Discovery Discovery One To One Transformation Input.
> **⚠️ 원문 불일치 (보존):** 상속-by 목록에 `Discovery Discovery`(중복 단어) — 실제는 `Abstract Smart Data Discovery Many/One To One Transformation Input`.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryAIModelTransformationTypeEnum | The runtime type for the model. Valid values are: • CategoricalImputation (Replace categorical missing values) • ExtractDayOfWeek (Extract day of week) • ExtractMonthOfYear (Extract month of year) • FreeTextClustering (Free text clustering) • NumericalImputation (Replace numerical missing values) • SentimentAnalysis (Detecting sentiment) • TimeSeriesForecast (Projected predictions) • TypographicClustering (Fuzzy matching) | Required | 55.0 |

> **⚠️ 원문 이상 (보존):** description `The runtime type for the model.`은 transformation type인데 `runtime`으로 오기(copy-paste 이상).

### 4. Abstract Smart Data Discovery Many To One Transformation Input
The base input to identify the transformation as many to one.

**상속:** Inherits properties from AbstractSmartDataDiscoveryTransformationInput. Inherited by Smart Data Discovery Categorical Imputation Transformation Input.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| postTransformationFilter | AbstractSmartDataDiscoveryTransformationFilterInput | The filter applied after the transformation is executed. Valid values are: • SmartDataDiscoveryNumericTransformationFilterInput • SmartDataDiscoveryTextTransformationFilterInput | Optional | 55.0 |
| sourceFieldNames | String[] | A list of field names for the data to transform. | Required | 55.0 |
| targetFieldName | String | The field name to write the transformed value to. | Required | 55.0 |

### 7. Abstract Smart Data Discovery One To One Transformation Input
The base input to identify the transformation as one to one.

**상속:** Inherits properties from AbstractSmartDataDiscoveryTransformationInput. Inherited by Smart Data Discovery Extract Day Of Week Transformation Input, Smart Data Discovery Extract Month Of Year Transformation Input, Smart Data Discovery Free Text Clustering Transformation Input, Smart Data Discovery Numerical Imputation Transformation Input, Smart Data Discovery Projected Predictions Transformation Input and Smart Data Discovery Sentiment Analysis Transformation Input.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| postTransformationFilter | AbstractSmartDataDiscoveryTransformationFilterInput | The filter applied after the transformation is executed. Valid values are: • SmartDataDiscoveryNumericTransformationFilterInput • SmartDataDiscoveryTextTransformationFilterInput | Optional | 55.0 |
| sourceFieldNames | String[] | A list of field names for the data to transform. | Required | 55.0 |
| targetFieldName | String | The field name to write the transformed value to. | Required | 55.0 |

### 22. Smart Data Discovery AI Model Transformation Input
The input for an Einstein Discovery AI model transformation.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| sourceFieldsNames | String[] | A list of the model field names to use as input parameters by the transformation. | Required | 54.0 |
| state | Object | The model transformation state. | Required | 51.0 |
| targetFieldsNames | String[] | A list of the model field names to modify with the transformation. | Required | 54.0 |
| type | SmartDataDiscoveryAIModelTransformationTypeEnum | The model transformation type. Valid values are: • CategoricalImputation (Replace categorical missing values) • ExtractDayOfWeek (Extract day of week) • ExtractMonthOfYear (Extract month of year) • FreeTextClustering (Free text clustering) • NumericalImputation (Replace numerical missing values) • SentimentAnalysis (Detecting sentiment) • TimeSeriesForecast (Projected predictions) • TypographicClustering (Fuzzy matching) | Required | 51.0 |

> 프로퍼티명 원문: `sourceFieldsNames`/`targetFieldsNames`(복수 `Fields`). enum 마지막 값 `TypographicClustering (Fuzzy matching)`은 p.66→67 경계에서 이어짐(확인 완료).

### 24. Smart Data Discovery Categorical Imputation Transformation Input
The input to identify the transformation as categorical imputation.

**상속:** Inherits properties from AbstractSmartDataDiscoveryManyToOneTransformationInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| imputeMethod | SmartDataDiscoveryCategoricalImputationMethodEnum | The algorithm type for the classification. Valid values are: • Auto | Required | 55.0 |

> **⚠️ 원문 이상 (보존):** description `The algorithm type for the classification.`는 categorical imputation인데 `classification`으로 오기. enum 값은 `Auto` 하나만 표기.

### 31. Smart Data Discovery Extract Day of Week Transformation Input
The input for an extract day of week transformation.

**상속:** Inherits properties from AbstractSmartDataDiscoveryOneToOneTransformationInput. (자체 프로퍼티 표 없음.)

### 32. Smart Data Discovery Extract Month of Year Transformation Input
The input for an extract month of year transformation.

**상속:** Inherits properties from AbstractSmartDataDiscoveryOneToOneTransformationInput. (자체 프로퍼티 표 없음.)

### 38. Smart Data Discovery Free Text Clustering Transformation Input
The input for a free text clustering transformation.

**상속:** Inherits properties from AbstractSmartDataDiscoveryOneToOneTransformationInput. (자체 프로퍼티 표 없음.)

### 51. Smart Data Discovery Numerical Imputation Transformation Input
The input for a numerical imputation transformation.

**상속:** Inherits properties from AbstractSmartDataDiscoveryOneToOneTransformationInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| imputeMethod | SmartDataDiscoveryNumericalImputationMethodEnum | The numerical imputation method. Valid values are: • Mean • Median • Mode | Required | 51.0 |

### 71. Smart Data Discovery Sentiment Analysis Transformation Input
The input for a sentiment analysis transformation.

**상속:** Inherits properties from AbstractSmartDataDiscoveryOneToOneTransformationInput. (자체 프로퍼티 표 없음.)

### 68. Smart Data Discovery Projected Predictions Transformation Input
The input for a projected predictions transformation.

**상속:** Inherits properties from AbstractSmartDataDiscoveryOneToOneTransformationInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| intervalOverride | AbstractSmartDataDiscoveryProjectedPredictionsIntervalSettingInput | The projected predictions interval settings. Valid values are: • Smart Data Discovery Projected Predictions Count From Date Interval Setting Input • Smart Data Discovery Projected Predictions Count Interval Setting Input • Smart Data Discovery Projected Predictions Date Interval Setting Input | Required | 55.0 |
| assetIdFieldName | String | The group by column, used for building time series for each asset ID. | Required | 55.0 |
| dateFieldName | String | The field used for the time series time axis. | Required | 55.0 |
| input | SmartDataDiscoveryProjectedPredictionsHistoricalDatasetSourceInput | The historical dataset input. | Required | 55.0 |
| numIntervals | Integer | The default number of intervals to project forward. | Required | 55.0 |
| projectedPredictionsIntervalType | SmartDataDiscoveryProjectedPredictionsIntervalTypeEnum | The interval type for forward projections. Valid values are: • Day • Month • Quarter • Week | Required | 55.0 |
| projectionFieldName | String | The time series y axis. This is the value column projected for each asset ID. | Required | 55.0 |
| seasonalityPeriod | Integer | The seasonality period. Use 0 for no seasonality, or [2-24]. | Required | 55.0 |

> `seasonalityPeriod`는 p.84 상단 running-header(`Regression...`) 아래에 있으나 실제로는 이 표현형(Projected Predictions Transformation Input)의 마지막 프로퍼티(AP-09 경계 절단 확인 완료).

---

## 변환 필터 (Transformation Filter)

### 11. Abstract Smart Data Discovery Transformation Filter Input
The base Einstein Discovery transformation filter input.

**상속:** Inherited by Smart Data Discovery Discovery Numeric Transformation Filter Input and Smart Data Discovery Discovery Text Transformation Filter Input.
> **⚠️ 원문 불일치 (보존):** 상속-by 목록에 `Discovery Discovery`(중복 단어) — 실제 표현형은 `Smart Data Discovery Numeric/Text Transformation Filter Input`.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryTransformationFilterTypeEnum | The transformation filter type for the model. Valid values are: • Number • Text | Required | 55.0 |

### 50. Smart Data Discovery Numeric Transformation Filter Input
The input for a numeric transformation filter.

**상속:** Inherits properties from AbstractSmartDataDiscoveryTransformationFilterInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| max | Double | The upper bound to be included. | Required | 55.0 |
| min | Double | The lower bound to be included. | Required | 55.0 |

### 74. Smart Data Discovery Text Transformation Filter Input
The input for a text transformation filter.

**상속:** Inherits properties from AbstractSmartDataDiscoveryTransformationFilterInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| clusters | SmartDataDiscoveryClusterInput[] | A list of clusters to filter the value with. | Required | 55.0 |
| includeOthers | Boolean | Indicates weher to include values that aren't defined in clusters (true) or not (false). | Required | 55.0 |

> **⚠️ 타이포 (보존):** `includeOthers` description의 `weher`(→ whether) 오타 그대로 보존.

---

## 변환 오버라이드 (Transformation Override)

### 13. Abstract Smart Data Discovery Transformation Override Input
The base Einstein Discovery transformation deploy override input.

**상속:** Inherited by Smart Data Discovery Projected Predictions Override Input.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| input | AssetReferenceInput | A transformation asset associated with the override settings. | Required | 55.0 |
| type | SmartDataDiscoveryAIModelTransformationTypeEnum | The transformation type. Valid values are: • CategoricalImputation (Replace categorical missing values) • ExtractDayOfWeek (Extract day of week) • ExtractMonthOfYear (Extract month of year) • FreeTextClustering (Free text clustering) • NumericalImputation (Replace numerical missing values) • SentimentAnalysis (Detecting sentiment) • TimeSeriesForecast (Projected predictions) • TypographicClustering (Fuzzy matching) | Required | 55.0 |

### 67. Smart Data Discovery Projected Predictions Override Input
The input for deploy time projected predictions transformation overrides.

**상속:** Inherits properties from AbstractSmartDataDiscoveryTransformationOverrideInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| assetIdField | String | The Salesforce object field name to use as a look-up for a record ID in a historical dataset. | Required | 55.0 |

---

## 필터 (Filter)

### 27. Smart Data Discovery Complex Filter Input
The complex filter input for Einstein Discovery.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| filters | SmartDataDiscoveryFilterInput[] | The list of filters that make up the complex filter. | Required | 46.0 |

### 36. Smart Data Discovery Filter Input
The filter input for Einstein Discovery.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| fieldName | String | The developer name of the field the filter applies to. | Required | 41.0 |
| filterValues | SmartDataDiscoveryFilterValueInput[] | An ordered list of the values to compare with. | Required | 50.0 |
| operator | ConnectSmartDataDiscoveryFilterOperatorEnum | The operator to use in the filter. Valid values are: • Between • Contains • EndsWith • Equal • GreaterThan • GreaterThanOrEqual • InSet • LessThan • LessThanOrEqual • NotBetween • NotEqual • NotIn • StartsWith | Required | 41.0 |
| type | SmartDataDiscoveryFilterFieldTypeEnum | The field type for the filter. Valid values are: • Boolean • Date • DateTime • Number • Text | Required | 48.0 |

### 37. Smart Data Discovery Filter Value Input
The filter value input for Einstein Discovery.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryFilterValueTypeEnum | The type of the filter value. Valid values are: • Constant • Placeholder | Required | 50.0 |
| value | String | The value for the filter. The value is a constant or a placeholder | Required | 50.0 |

---

## 처방 필드 (Prescribable Field)

### 28. Smart Data Discovery Custom Prescribable Field Definition Input
The input for a custom Einstein Discovery prescribable field definition to override default prescription text.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| filters | SmartDataDiscoveryFilterInput[] | A list of filter rules for enabling custom text. | Required | 50.0 |
| templateText | String | The template text to use in replacements. | Required | 50.0 |

> `templateText`는 p.68→69 경계에서 이어짐(확인 완료).

### 29. Smart Data Discovery Customizable Field Input
Input for an Einstein Discovery customizable field.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| customDefinitions | SmartDataDiscoveryCustomPrescribableFieldDefinitionInput[] | A list of custom field definitions. | Required | 57.0 |
| fieldName | String | The name of the customizable field. | Required | 57.0 |

### 61. Smart Data Discovery Prescribable Field Input
Input for an Einstein Discovery prescribable field.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| customDefinitions | SmartDataDiscoveryCustomPrescribableFieldDefinitionInput[] | A list of custom prescribable field definitions to override default prescription text. | Required | 50.0 |
| fieldName | String | The name of the prescribable field. | Required | 50.0 |

---

## 예측 (Predict)

### 8. Abstract Smart Data Discovery Predict Input
The base predict input for Einstein Discovery.

**상속:** Inherited by SmartDataDiscoveryPredictInput, SmartDataDiscoveryPredictRawDataInput, SmartDataDiscoveryPredictRecordOverridesInput, and SmartDataDiscoveryPredictRecordInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| model | Asset Reference Input | The model for the predict | Required | 48.0 |
| predictionDefinition | String | The prediction definition ID for the predict. | Required | 44.0 |
| settings | Smart Data Discovery Predict Settings Input | The settings to control the predict output. | Optional | 46.0 |
| type | SmartDataDiscoveryPredictTypeEnum | The predict type. Valid values are: • RawData (Represent rows within a two-dimensional array of row values) • RecordOverrides (Represent records using Salesforce record Ids. Optionally override or append individual records with an array of row values) • Records (Represent rows using Salesforce record Ids associated with the subscribedEntity of the prediction definition) | Required | 44.0 |

### 53. Smart Data Discovery Predict Input
The predict input for Einstein Discovery.

**상속:** Inherits properties from AbstractSmartDataDiscoveryPredictInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| entityId | String | The entity ID to run a prediction on. | Required | 43.0 |
| exploratoryValues | Map<String, String> | A map of data values. | Required | 43.0 |
| predictionDefinitionId | String | The model ID to use for the prediction. | Required | 43.0 |

### 52. Smart Data Discovery Predict Extension Input
The predict record extension input for Einstein Discovery.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| record | ID | The ID of the record. | Required | 44.0 |
| row | String[] | A list of the rows for the extension. | Required | 44.0 |

### 54. Smart Data Discovery Predict Nested Row List Input
The predict nested row list input for Einstein Discovery.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| row | String[] | A list of the rows. | Required | 44.0 |

### 57. Smart Data Discovery Predict Settings Input
The predict settings input for Einstein Discovery.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| aggregateFunctions | String[] | A list of the aggregate functions to use. | Optional | 55.0 |
| maxMiddleValues | Integer | The maximum middle value count. The default value is 0 and the allowed range is [0, 3]. | Optional | 50.0 |
| maxPrescriptions | Integer | The maximum prescription count. The default value is -1 (unlimited) and the allowed range is [-1, 200]. | Optional | 46.0 |
| prescriptionImpactPercentage | Integer | The impact percentage of the prescriptions. The default value is 0. | Optional | 47.0 |
| projectedPredictions | SmartDataDiscoveryProjectedPredictionSettingsInput | The setting overrides for projected predictions. | Optional | 54.0 |

### 58. Smart Data Discovery Predict Raw Data Input
The predict raw data input for Einstein Discovery.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| columnNames | String[] | A comma-separated list of column names representing the columns that the model analyzes. | Required | 44.0 |
| rows | SmartDataDiscoveryPredictNestedRowListInput[] | A list of row names and values. | Required | 44.0 |

### 59. Smart Data Discovery Predict Record Overrides Input
The predict record overrides input for Einstein Discovery.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| columnNames | String[] | A comma-separated list of column names representing the columns that the model analyzes. | Required | 44.0 |
| rows | SmartDataDiscoveryPredictExtensionInput[] | A list of containing the Salesforce record IDs. | Required | 44.0 |

> **⚠️ 원문 이상 (보존):** `rows` description `A list of containing the Salesforce record IDs.` — 문법 이상(`A list of containing`) 그대로 보존.

### 60. Smart Data Discovery Predict Record Input
The predict record input for Einstein Discovery.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| records | String[] | A list of comma-separated Salesforce record IDs associated with the subscribedEntity of the prediction definition. Maximum of 200 records allowed. | Required | 44.0 |

---

## 예측 잡·이력 (Predict Job / History)

### 55. Smart Data Discovery Predict Job Input
The predict job input for Einstein Discovery.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| filter | SmartDataDiscoveryComplexFilterInput | The filters to score a portion of the records. If no filters are specified, then all records are scored. If specified, use one type of filter, either useTerminalStateFilter or filters, but not both. | Optional | 48.0 |
| label | String | The label for the scoring job. | Required | 48.0 |
| predictionDefinition | AssetReferenceInput | The ID of the prediction definition for the scoring job. | Required | 48.0 |
| useTerminalStateFilter | Boolean | Indicates whether the job should score any record NOT matching the terminal state filter on the goal (true) or not (false). | Optional | 49.0 |

### 56. Smart Data Discovery Predict Job Update Input
The input to update a predict job for Einstein Discovery.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| status | SmartDataDiscoveryPredictJobStatusEnum | The status of the predict job. Valid values are: • Cancelled • Completed • Failed • InProgress • NotStarted • Paused | Required | 46.0 |

### 18. Predict History Input
The query input for prediction history.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| goalId | ID | The ID of the goal. | Required | 56.0 |
| range | PredictHistoryRangeInput | The range for the prediction history query. | Required | 56.0 |
| targets | String[] | The list of targets to query. | Optional | 56.0 |

### 19. Predict History Range Input
The range for prediction history query.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| interval | PredictHistoryIntervalEnum | The interval for look back. Valid values are: • None • Weekly | Optional | 56.0 |
| maxLookBack | Integer | The maximum look back period. | Optional | 56.0 |

---

## Projected Predictions (투영 예측)

### 62. Smart Data Discovery Projected Prediction Settings Input
The projected prediction settings input for Einstein Discovery.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| confidenceInterval | Integer | The confidence interval to display at each point. Allowed values are 80 and 95. | Optional | 55.0 |
| numberOfIntervalsToProjectAhead | Integer | Override the number of intervals to project ahead. The allowed range is [1, 12]. | Optional | 54.0 |
| showProjectedPredictionByInterval | Boolean | Indicates whether the projected prediction calculation is enabled for every interval into the future (true) or not (false). | Optional | 54.0 |

### 10. Abstract Smart Data Discovery Projected Predictions Interval Setting Input
The base Einstein Discovery projected predictions interval settings input.

**상속:** Inherited by Smart Data Discovery Projected Predictions Count From Date Interval Setting Input, Smart Data Discovery Projected Predictions Count Interval Setting Input, and Smart Data Discovery Projected Predictions Date Interval Setting Input.

| Property Name | Type | Description | Required and Optional | Available Version |
|---|---|---|---|---|
| type | SmartDataDiscoveryProjectedPredictionsIntervalSettingTypeEnum | The projected predictions interval setting type. Valid values are: • Count • CountFromDate • Date | Required | 55.0 |

> **⚠️ 컬럼 헤더 흔들림 (보존):** 이 표의 4번째 컬럼 헤더가 `Required and Optional`로 렌더링됨(다른 표는 `Required or Optional`).

### 63. Smart Data Discovery Projected Predictions Count From Date Interval Setting Input
The input for settings for an Einstein Discovery count from date based projection interval.

**상속:** Inherits properties from AbstractSmartDataDiscoveryProjectedPredictionsIntervalSettingInput.

| Property Name | Type | Description | Required and Optional | Available Version |
|---|---|---|---|---|
| dateField | String | The date field to use for calculating projection intervals. | Required | 55.0 |
| numIntervals | Integer | The number of intervals to project ahead. | Required | 55.0 |

> **⚠️ 컬럼 헤더 흔들림 (보존):** 이 표의 4번째 컬럼 헤더가 `Required and Optional`로 렌더링됨.

### 64. Smart Data Discovery Projected Predictions Count Interval Setting Input
The input for settings for an Einstein Discovery count based projection interval.

**상속:** Inherits properties from AbstractSmartDataDiscoveryProjectedPredictionsIntervalSettingInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| numIntervals | Integer | The number of intervals to project ahead. | Required | 55.0 |

### 65. Smart Data Discovery Projected Predictions Date Interval Setting Input
The input for settings for an Einstein Discovery date interval.

**상속:** Inherits properties from AbstractSmartDataDiscoveryProjectedPredictionsIntervalSettingInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| dateField | String | The date field to use for calculating projection intervals. | Required | 55.0 |

### 66. Smart Data Discovery Projected Predictions Historical Dataset Source Input
The input for projected predictions transformation.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| datasetId | ID | The ID of the historical dataset used to extract and build time series for each asset ID. | Required | 55.0 |
| datasetVersionId | ID | The ID of the specific dataset version used for extraction. | Required | 55.0 |

---

## 스토리 쿼리·데이터 속성 (Story Query / Data Property)

### 83. Story Query Input
The input to query an Einstein Discovery story.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| filters | AbstractStoryDataPropertyInput[] | A list of filters to use in the query. Valid values are: • Story Day Field Value Input • Story Day Of Week Field Value Input • Story Field Only Input • Story Month Field Value Input • Story Month Of Year Field Value Input • Story Null Field Value Input • Story Quarter Field Value Input • Story Quarter Of Year Field Value Input • Story Range Field Value Input • Story Text Field Value Input • Story Year Field Value Input | Required | 54.0 |
| includeChart | Boolean | Indicates whether to include the story chart in the query response (true) or not (false). | Optional | 54.0 |
| includeNarrative | Boolean | Indicates whether to include the story narrative in the query response (true) or not (false). | Optional | 54.0 |
| includeRegularFields | Boolean | Indicates whether to include regular fields in the query response (true) or not (false). | Optional | 54.0 |
| includeSensitiveFields | Boolean | Indicates whether to include sensitive fields in the query response (true) or not (false). | Optional | 54.0 |
| insightsType | InsightsTypeEnum | The analysis type for the query insights. Valid values are: • Descriptive • Diagnostic | Required | 52.0 |
| limit | Integer | The total number of insight cards in the query response. | Optional | 54.0 |
| offset | Integer | The insight card offset value. | Optional | 54.0 |

### 14. Abstract Story Data Property Input
The base Einstein Discovery story data property filter.

**상속:** Inherited by Story Day Field Value Input, Story Day Of Week Field Value Input, Story Field Only Input, Story Month Field Value Input, Story Month Of Year Field Value Input, Story Null Field Value Input, Story Quarter Field Value Input, Story Quarter Of Year Field Value Input, Story Range Field Value Input, Story Text Field Value Input, and Story Year Field Value Input.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| field | String | The filter field developer name. | Required | 52.0 |
| type | String | The filter field type. | Required | 52.0 |

### 75. Story Day Field Value Input
The story data day property.

**상속:** Inherits properties from AbstractStoryDataPropertyInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| day | Integer | The day in numeric value. | Required | 52.0 |
| fiscal | Boolean | Indicates whether the value is in a fiscal year (true) or not (false). | Required | 52.0 |
| month | Integer | The month in numeric value. | Required | 52.0 |
| rawValue | String | The raw value of the field. | Required | 52.0 |
| year | Integer | The year in numeric value. | Required | 52.0 |

### 76. Story Day of Week Field Value Input
The story data day of week property.

**상속:** Inherits properties from AbstractStoryDataPropertyInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| dayOfWeek | Integer | The day of week in numeric value. | Required | 52.0 |
| rawValue | String | The raw value of the field. | Required | 52.0 |

### 77. Story Field Only Input
The story data field property.

**상속:** Inherits properties from AbstractStoryDataPropertyInput. (자체 추가 프로퍼티 표 없음 — abstract 프로퍼티(`field`, `type`)만 상속.)

### 78. Story Month Field Value Input
The story data month property.

**상속:** Inherits properties from AbstractStoryDataPropertyInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| fiscal | Boolean | Indicates whether the value is in a fiscal year (true) or not (false). | Required | 52.0 |
| month | Integer | The month in numeric value. | Required | 52.0 |
| rawValue | String | The raw value of the field. | Required | 52.0 |
| year | Integer | The year in numeric value. | Required | 52.0 |

### 79. Story Month of Year Field Value Input
The story data month of year property.

**상속:** Inherits properties from AbstractStoryDataPropertyInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| month | Integer | The month of year in numeric value. | Required | 52.0 |
| rawValue | String | The raw value of the field. | Required | 52.0 |

### 80. Story Null Field Value Input
The story data null property.

**상속:** Inherits properties from AbstractStoryDataPropertyInput. (자체 추가 프로퍼티 표 없음.)

### 81. Story Quarter Field Value Input
The story data quarter property.

**상속:** Inherits properties from AbstractStoryDataPropertyInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| fiscal | Boolean | Indicates whether the value is in a fiscal year (true) or not (false). | Required | 52.0 |
| quarter | Integer | The quarter in numeric value. | Required | 52.0 |
| rawValue | String | The raw value of the field. | Required | 52.0 |
| year | Integer | The year in numeric value. | Required | 52.0 |

### 82. Story Quarter of Year Field Value Input
The story data quarter of year property.

**상속:** Inherits properties from AbstractStoryDataPropertyInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| fiscal | Boolean | Indicates whether the value is in a fiscal year (true) or not (false). | Required | 52.0 |
| quarter | Integer | The quarter in numeric value. | Required | 52.0 |
| rawValue | String | The raw value of the field. | Required | 52.0 |

### 84. Story Range Field Value Input
The story data range property.

**상속:** Inherits properties from AbstractStoryDataPropertyInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| endValue | String | The end value of the range. | Required | 52.0 |
| startValue | String | The start value of the range. | Required | 52.0 |

### 85. Story Text Field Value Input
The story data text property.

**상속:** Inherits properties from AbstractStoryDataPropertyInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| value | String | The text value of the field. | Required | 52.0 |

### 86. Story Year Field Value Input
The story data year property.

**상속:** Inherits properties from AbstractStoryDataPropertyInput.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| fiscal | Boolean | Indicates whether the value is in a fiscal year (true) or not (false). | Required | 52.0 |
| rawValue | String | The raw value of the field. | Required | 52.0 |
| year | Integer | The year in numeric value. | Required | 52.0 |

---

## 내러티브 (Narrative)

### 46. Smart Data Discovery Narrative Input
The Einstein Discovery story narrative to retrieve.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| includeWarnings | Boolean | Indicates whether the warning data should be included (true) or not (false). | Optional | 51.0 |
| query | SmartDataDiscoveryNarrativeQueryInput | The query body containing the information for generating the narrative. | Required | 51.0 |
| story | AssetReferenceInput | The story to use for generating the narrative. | Required | 51.0 |
| storyId | String | The ID of the story to use for generating the narrative. | Required | 51.0 |
| type | String | The type of the narrative source. | Required | 51.0 |

> `type` 프로퍼티는 p.75→76 경계에서 이어짐(확인 완료).

### 48. Smart Data Discovery Narrative Query Input
The query metadata for the Einstein Discovery story narrative to retrieve.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| filters | SmartDataDiscoveryNarrativeFilterInput[] | The list of filters for the query. | Required | 51.0 |
| insight | SmartDataDiscoveryNarrativeQueryInput ⚠️ | The insights for the query. | Required | 51.0 |

> **⚠️ 원문 이상 (보존):** `insight`의 Type이 `SmartDataDiscoveryNarrativeQueryInput`(자기 자신을 참조하는 self-referential)로 렌더링. description은 `The insights for the query`라 `NarrativeInsightInput` 계열이 맞을 것으로 보이나 PDF 원문은 `NarrativeQueryInput` — 원문 그대로 보존.

### 45. Smart Data Discovery Narrative Filter Input
The narrative filter metadata.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| columns | String | The columns to use in the filter. | Required | 51.0 |
| property | AbstractStoryDataPropertyInput | The filter for the query service to use. Valid data properties are: • Story Day Field Value Input • Story Day Field Value Input • Story Field Only Value Input • Story Month Field Value Input • Story Month Of Year Field Value Input • Story Null Field Value Input • Story Quarter Field Value Input • Story Quarter Of Year Field Value Input • Story Range Field Value Input • Story Text Field Value Input • Story Year Field Value Input | Required | 51.0 |
| values | String[] | The list of values to use with the fields in the filter. | Required | 51.0 |

> **⚠️ 원문 이상 (보존):** `property`의 valid values 목록에 `Story Day Field Value Input`이 **두 번** 나열되고(중복), `Story Field Only Value Input`은 실제 표현형명 `Story Field Only Input`과 불일치.

### 47. Smart Data Discovery Narrative Insight Input
The narrative insight metadata.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| insightType | ConnectEDInsightTypeEnum | The insight type to return. Valid values are: • Descriptive • Summary | Required | 51.0 |
| narrativeType | ConnectEDNarrativeTypeEnum | The narrative type to return. Valid values are: • Positive • Negative | Required | 51.0 |
| numInsights | Integer | The number of insights to return. | Required | 51.0 |

---

## 원문 이상·추출 아티팩트 (종합)

이 노트는 PDF 원문의 오기·불일치를 **정정하지 않고 그대로 보존**한다(창작 금지). 각 항목은 위 해당 표현형에도 `⚠️`로 표시했다.

### 원문 자체 이상 (PDF 오기·불일치)

1. **#21 AI Model Input** — 프로퍼티명 `input` 두 번 등장(source input용 `AbstractSmartDataDiscoveryAIModelSourceInput` + runtime용 `AbstractSmartDataDiscoveryModelRuntimeInput`). 서로 다른 타입.
2. **`"Small, NN.0"` 누출** — #5 Abstract Model Field Input `type`, #21 AI Model Input `transformations`, #40 Model Input `name`의 Required/Optional 셀에 폰트-크기 주석 `Small,`이 새어 들어와 실제 R/O 값이 미표기.
3. **#40 Model Input `transformationOverrides`** — Type이 `AbstractSmartDataDiscoveryPrescribableField[]`로 렌더되나 valid value는 Projected Predictions Override Input(TransformationOverride 계열)이라 타입-내용 불일치.
4. **#45 Narrative Filter Input `property`** — valid values에 `Story Day Field Value Input` 중복(2회), `Story Field Only Value Input`(실제명 `Story Field Only Input`) 불일치.
5. **#48 Narrative Query Input `insight`** — Type이 self-referential `SmartDataDiscoveryNarrativeQueryInput`(`NarrativeInsightInput`가 맞을 것으로 추정되나 원문 그대로).
6. **description 오기:** #12 Transformation Input `type`(`runtime type`→transformation type), #24 Categorical Imputation `imputeMethod`(`classification`→categorical), #69 Regression `algorithmType`(`classification`→regression).
7. **타이포:** #74 Text Transformation Filter `includeOthers` `weher`(→whether).
8. **컬럼 헤더 흔들림:** 대부분 `Required or Optional`이나 #10 Abstract Projected Predictions Interval Setting Input·#63 Count From Date Interval Setting Input은 `Required and Optional`.
9. **상속/이름 불일치:** `H2O` vs `H20`(#39 표현형명은 H20, abstract enum·상속목록은 H2O); `Scikit Learn 102` vs `ScikitLearn 120`(#70 vs #6 상속목록); `Model Numeric Field Input` vs `Model Field Numeric Input`(#5 상속목록 vs #42); `Discovery Discovery`(#11·#12 상속목록 중복 단어); #20·#23 inherits-from에 `...AIModelDiscoverySourceInput`(abstract 실명은 AIModelSourceInput 추정).
10. **grammatical:** #59 Predict Record Overrides Input `rows` `A list of containing the Salesforce record IDs.`

### 추출 아티팩트 (pdftotext) — 콘텐츠 아님

- **컬럼 붕괴:** plain 추출에서 5컬럼 표가 뒤섞여, `pdftotext -layout` 버전을 정본으로 재구성.
- **타입명·프로퍼티명 다중 줄 분리:** 대부분의 Enum·Input 타입명, camelCase 프로퍼티명이 2~4줄로 분리된 것을 논리 복원.
- **running-header 반복:** 각 페이지 상단에 `Einstein Discovery REST API Request Bodies` + 섹션명이 반복 삽입되어, 표 절단(AP-09)이 일부 표현형(#21 status enum, #22 type enum, #25 classificationThreshold, #28 templateText, #46 type, #68 seasonalityPeriod)에서 발생 — 모두 이어짐 확인 완료.
- **시각 자료:** 이 챕터(Request Bodies)에는 다이어그램/figure/트리가 **없다**(전부 텍스트 표).

### 범위 명시

- **커버:** "Einstein Discovery REST API Request Bodies" 챕터 전체(86 표현형, PDF 물리 p.51–90).
- **미커버(범위 밖):** 동 PDF의 다른 챕터 — Resources, Response Bodies, Headers, Status Codes 등. 이 노트는 Request Bodies만 대상.

---

## 관련 노트
- [[Einstein Discovery REST — 리소스 엔드포인트 레퍼런스]] — 이 Input들을 요청 바디로 소비하는 리소스·엔드포인트
- [[Einstein Discovery REST — 개요·인증·예측 소비 흐름]] — 인증·예측 소비 사용 예제
- [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]] — 형제 응답 표현형 노트(모델 품질·편향)
- [[Einstein Discovery REST — 응답 표현형 — 모델·필드·소스]] — Request Bodies의 대응 응답 표현형
- [[Einstein Discovery REST — Enums]] — 위 표에서 참조한 enum 타입의 값 정의 전수
