---
tags: [einstein, einstein-discovery, crm-analytics, rest-api, endpoints, resources, reference]
source: bi_dev_guide_rest_sdd.pdf (Einstein Discovery REST API Developer Guide, Summer '26)
created: 2026-07-19
aliases: [Einstein Discovery REST endpoints, smartdatadiscovery resources, Model Resource, Prediction Definition Resource, Predict Jobs, Refresh Jobs, Stories Resource, Predict History, 리소스 엔드포인트]
---

# Einstein Discovery REST — 리소스 엔드포인트 레퍼런스

> Einstein Discovery REST(`/smartdatadiscovery/*`) 전 리소스 엔드포인트 — Model·Prediction Definition·Predict/Refresh Jobs·Predict History·Stories의 URI·HTTP 메서드·파라미터·요청/응답 표현형 참조.

---

## 이 노트의 범위

Einstein Discovery REST API Developer Guide(Summer '26)의 **Ch3 Resources**(p.22–50) 엔드포인트 레퍼런스를 전수 정리한다. 각 리소스의 **Resource URL · 지원 HTTP 메서드 · 요청 파라미터/바디 · 응답 표현형 · Available Version**을 담는다.

- **사용 흐름·인증·요청/응답 JSON 예제**는 형제 노트 [[Einstein Discovery REST — 개요·인증·예측 소비 흐름]](Ch1–2) 소관 — 여기서는 엔드포인트 시그니처만.
- **60+ Input/Output 표현형(Request/Response Bodies, Ch4)의 필드 상세**는 이 노트 범위 밖이다. 각 리소스가 참조하는 **표현형 이름**만 기록한다(예: `Smart Data Discovery AI Model Collection`). Metrics·Feature Importances가 참조하는 지표 표현형은 [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]] 참조.

> Available Version은 리소스 헤더 값과 파라미터 표 값이 원문에서 불일치하는 곳이 여러 군데 있다(Model Cards, Story Histories 등). 각 해당 지점에 원문 그대로 병기하고 ⚠️로 표시했다.

---

## 베이스 URL 구성 (B0)

모든 Einstein Discovery REST 리소스는 아래 세 조각으로 접근한다.

```
// 구조 예시 — dump의 URL 구성 규칙을 조합한 것 (실제 인스턴스 값으로 치환)
<base URL>          예: https://yourInstance.salesforce.com
<version info>      예: /services/data/v53.0
<named resource>    예: /smartdatadiscovery

전체 URL 예: https://yourInstance.salesforce.com/services/data/v55.0/smartdatadiscovery
```

**Org and Object Identifiers:** Salesforce/Einstein Discovery의 Id는 보통 15자 base-62 case-sensitive 문자열이지만, Einstein Discovery REST API를 포함한 다수 API는 18자 case-insensitive 문자열을 쓴다(예: Story 리소스 `/smartdatadiscovery/stories/<storyID>`의 Id). 마지막 3자리는 앞 15자의 checksum이며, 18자 Id를 15자로 되돌리려면 마지막 3자를 제거하면 된다.

**Filtering REST Responses:** Einstein Discovery REST 입력 파라미터 외에 Connect REST API 입력 파라미터 **filterGroup**, **external**, **internal**으로 결과를 필터할 수 있다(상세는 Connect REST API Developer Guide의 Specifying Response Sizes).

### General Resources (최상위)

| Resource | 설명 | HTTP 메서드 | Resource URL |
|---|---|---|---|
| Metrics Resource | Returns the metrics for Einstein Discovery. | GET | `/smartdatadiscovery/metrics` |
| Narrative Resource | Returns the narrative data for an Einstein Discovery story. | POST | `/smartdatadiscovery/narrative` |
| Predict Resource | Creates an Einstein Discovery prediction. | POST | `/smartdatadiscovery/predict` |
| Predict History Resource | Query the history of Einstein Discovery predictions. | POST | `/smartdatadiscovery/predict-history` |
| Smart Data Discovery Resource | Lists the top-level resources available for Einstein Discovery. | GET | `/smartdatadiscovery` |

---

## Smart Data Discovery Resource (B1)

디렉터리 리소스 — Einstein Discovery의 최상위 리소스 목록을 반환한다.

```
GET /smartdatadiscovery
```

| 항목 | 값 |
|---|---|
| Formats | JSON |
| Available Version | 46.0 |
| HTTP Methods | GET |
| Response body (GET) | Directory Item Collection |

---

## Model Resources (B2)

`/smartdatadiscovery/models/*` 하위 7개 리소스. 모델 메타데이터·계수·파일·지표를 다룬다.

| Resource | 설명 | HTTP 메서드 | Resource URL |
|---|---|---|---|
| Models Resource | Returns a collection of Einstein Discovery models and creates a model. | GET POST | `/smartdatadiscovery/models` |
| Model Resource | Returns a model, updates a model, or deletes a model. | GET PATCH DELETE | `/smartdatadiscovery/models/<modelId>` |
| Model Coefficients Resource | Returns the coefficients for a model. | GET | `/smartdatadiscovery/models/<modelId>/coefficients` |
| Model File Resource | Returns a binary stream of the model file contents. | GET | `/smartdatadiscovery/models/<modelId>/file` |
| Model Metrics Resource | Returns the metrics for a specified model. | GET | `/smartdatadiscovery/models/<modelId>/metrics` |
| Model Metrics Residuals Resource | Returns the metrics residuals for a specified model. | GET | `/smartdatadiscovery/models/<modelId>/metrics/residuals` |
| Model Metrics Feature Importances Resource | Returns the importance metrics for a specified model. | GET | `/smartdatadiscovery/models/<modelId>/metrics/feature-importances` |

### Models Resource (B2a)

```
GET  /smartdatadiscovery/models     # 컬렉션 조회
POST /smartdatadiscovery/models     # 모델 생성
```

Formats JSON · Available Version 48.0 · HTTP Methods GET POST

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| order | SmartDataDiscoverySortOrderEnum | 컬렉션 정렬 순서. Valid values: Ascending, Descending | Optional | 48.0 |
| page | String | 반환할 모델 뷰를 나타내는 생성 토큰. | Optional | 48.0 |
| pageSize | Integer | 한 페이지에 반환할 항목 수. 최소 1, 최대 200, 기본 25. | Optional | 48.0 |
| q | String | 검색어(공백 구분). 마지막 토큰에 와일드카드 자동 부가. 따옴표·와일드카드·특수문자는 URI 쿼리에서 자동 제거. | Optional | 48.0 |
| sort | SmartDataDiscoveryAIModelCollectionSortOrderTypeEnum | 컬렉션 정렬 타입. Valid values: CreatedDate, Description, Name, PredictionFieldName, PredictionType, RuntimeType | Optional | 48.0 |
| sourceType | SmartDataDiscoveryModelSourceTypeEnum | source type으로 필터. Valid values: Discovery, UserUpload | Optional | 48.0 |
| status | SmartDataDiscoveryAIModelStatusEnum | status로 필터. Valid values: Disabled, Enabled, UploadCompleted, UploadFailed, Uploading, Validating, ValidationCompleted, ValidationFailed | Optional | 48.0 |
| storyHistoryId | String | story history ID(9B4)로 필터. | Optional | 48.0 |
| storyId | String | story ID(1Y3)로 필터. | Optional | 48.0 |

- Response body (GET): **Smart Data Discovery AI Model Collection**
- Request body (POST): **Smart Data Discovery AI Model Input**
- Response body (POST): **Smart Data Discovery AI Model**

### Model Resource (B2b)

```
GET    /smartdatadiscovery/models/<modelId>
PATCH  /smartdatadiscovery/models/<modelId>
DELETE /smartdatadiscovery/models/<modelId>
```

Formats JSON · HTTP Methods GET PATCH DELETE · **Available Version: 48.0(GET·DELETE), 50.0(PATCH)**

**Request parameters (GET, DELETE):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| modelId | String | 조회·수정·삭제할 모델 ID. | Required | 48.0 |

**Request parameters (PATCH):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| model | SmartDataDiscoveryAIModelInput | 수정할 모델 정보. | Required | 50.0 |
| modelId | String | 조회·수정·삭제할 모델 ID. | Required | 50.0 |

- Response body (GET, PATCH): **Smart Data Discovery AI Model**

### Model Coefficients Resource (B2c)

```
GET /smartdatadiscovery/models/<modelId>/coefficients
```

Formats JSON · Available Version 55.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| modelId | String | 계수를 조회할 모델 ID. | Required | 55.0 |
| page | String | 반환할 model metrics 뷰를 나타내는 생성 토큰. | Optional | 55.0 |
| pageSize | Integer | 한 페이지에 반환할 항목 수. 최소 1, 최대 200, 기본 25. | Optional | 55.0 |

- Response body (GET): **Smart Data Discovery AI Model Coefficient Collection**

### Model File Resource (B2d)

```
GET /smartdatadiscovery/models/<modelId>/file
```

Formats JSON · Available Version 49.0(GET) · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| modelId | String | 파일을 조회할 모델 ID. | Required | 49.0 |

- Response body (GET): **StreamedRepresentation** — "Returns a binary stream of the JSON contents of the specified file."

### Model Metrics Resource (B2e)

```
GET /smartdatadiscovery/models/<modelId>/metrics
```

Formats JSON · Available Version 54.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| modelId | String | 지표를 조회할 모델 ID. | Required | 54.0 |

- Response body (GET): **Abstract Smart Data Discovery AI Model Metrics** — 구체 구현: Smart Data Discovery AI Model Classification Metrics, Smart Data Discovery AI Model Multiclass Metrics, Smart Data Discovery AI Model Regression Metrics. (지표 필드 상세 → [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]])

### Model Metrics Residuals Resource (B2f)

```
GET /smartdatadiscovery/models/<modelId>/metrics/residuals
```

Formats JSON · Available Version 55.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| modelId | String | metrics residuals를 조회할 모델 ID. | Required | 55.0 |
| page | String | 반환할 metrics residuals 뷰를 나타내는 생성 토큰. | Optional | 55.0 |
| pageSize | Integer | 한 페이지에 반환할 항목 수. 최소 1, 최대 200, 기본 25. | Optional | 55.0 |

- Response body (GET): **Smart Data Discovery AI Model Residual Collection**

### Model Metrics Feature Importances Resource (B2g)

```
GET /smartdatadiscovery/models/<modelId>/metrics/feature-importances
```

> ⚠️ URL placeholder 표기가 원문에서 혼용됨 — 목록 표에서는 `<modelId>`, 상세에서는 `${modelId}`(`/smartdatadiscovery/models/${modelId}/metrics/feature-importances`). 둘 다 같은 path 파라미터를 가리킨다.

Formats JSON · Available Version 56.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| modelId | String | importance metrics를 조회할 모델 ID. | Required | 56.0 |

- Response body (GET): **Smart Data Discovery Feature Importance Metric** (표현형 상세 → [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]])

---

## Metrics Resource (B3)

Einstein Discovery의 metrics를 반환한다(General Resources).

```
GET /smartdatadiscovery/metrics
```

Formats JSON · Available Version 50.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| count | Integer | 컬렉션의 count. | Optional | 50.0 |
| span | MetricSpanEnum | metrics의 time span. Valid values: Day, Month, SinceLastAction, Week | Optional | 50.0 |

- Response body (GET): **Smart Data Discovery Metrics Collection**

---

## Narrative Resource (B4)

Einstein Discovery story의 narrative 데이터를 반환한다(General Resources).

```
POST /smartdatadiscovery/narrative
```

Formats JSON · Available Version 51.0 · HTTP Methods POST

**Request body (POST):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| narrative | SmartDataDiscoveryNarrativeInput | 데이터를 반환할 narrative. | Optional | 51.0 |

- Response body (POST): **Smart Data Discovery Narrative Field Collection**

---

## Prediction Definition Resources (B5)

`/smartdatadiscovery/predictiondefinitions/*` 하위 7개 리소스. path 파라미터 `<predictionDefinitionIdOrName>`은 prediction definition의 ID **또는** developer name을 받는다.

| Resource | 설명 | HTTP 메서드 | Resource URL |
|---|---|---|---|
| Prediction Definitions Resource | Returns a collection of Einstein Discovery prediction definitions. | GET | `/smartdatadiscovery/predictiondefinitions` |
| Prediction Definition Resource | Returns or deletes a prediction definition. | GET DELETE | `/smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>` |
| Prediction Definition Model Cards Resource | Returns a model card for an Einstein Discovery prediction definition. | GET | `/smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/modelcards` |
| Prediction Definition Model Card Resource | Deletes a prediction definition model card. | DELETE | `/smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/modelcards/<modelCardId>` |
| Prediction Definition Models Resource | Returns a collection of Einstein Discovery prediction definition models. | GET POST | `/smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/models` |
| Prediction Definition Model Resource | Returns or deletes a model for an Einstein Discovery prediction definition. | GET PATCH DELETE | `/smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/models/<modelId>` |
| Prediction Definition Model Metrics Resource | Returns a collection of metrics for a prediction definition model. | GET | `/smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/models/<modelId>/metrics` |

### Prediction Definitions Resource (B5a)

```
GET /smartdatadiscovery/predictiondefinitions
```

Formats JSON · Available Version 41.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| modelSource | SmartDataDiscoveryModelSourceTypeEnum | 필터할 model source type. Valid values: Discovery, UserUpload | Optional | 41.0 |
| order | SmartDataDiscoverySortOrderEnum | 컬렉션 정렬 순서. Valid values: Ascending, Descending | Optional | 41.0 |
| outcomeField | String | 필터할 outcome field. | Optional | 41.0 |
| outcomeGoal | ConnectSmartDataDiscoveryOutcomeGoalEnum | 필터할 outcome goal. Valid values: Maximize, Minimize, None | Optional | 41.0 |
| page | String | 반환할 모델 뷰를 나타내는 생성 토큰. | Optional | 41.0 |
| pageSize | Integer | 한 페이지에 반환할 항목 수. 최소 1, 최대 200, 기본 25. | Optional | 41.0 |
| predictionType | ConnectSmartDataDiscoveryPredictionTypeEnum | 필터할 prediction type. Valid values: Classification, MulticlassClassification, Regression, Unknown | Optional | 41.0 |
| q | String | 검색어(공백 구분). 마지막 토큰에 와일드카드 자동 부가. 따옴표·와일드카드·특수문자는 URI 쿼리에서 자동 제거. | Optional | 41.0 |
| sort | PredictionDefinitionCollectionSortOrderTypeEnum | 컬렉션 정렬 타입. Valid values: LastUpdate, Name, OutcomeFieldLabel, PredictionType, SubscribedEntity | Optional | 41.0 |
| sourceType | SmartDataDiscoveryModelSourceTypeEnum | source type으로 필터. Valid values: Discovery, UserUpload | Optional | 41.0 |
| status | SmartDataDiscoveryStatusEnum | status로 필터. Valid values: Disabled, Enabled | Optional | 41.0 |
| storyId | Id | story ID(1Y3)로 필터. | Optional | 41.0 |
| subscribedEntity | String | subscribed entity로 필터. | Optional | 41.0 |

- Response body (GET): **Smart Data Discovery Prediction Definition Collection**

### Prediction Definition Resource (B5b)

```
GET    /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>
DELETE /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>
```

Formats JSON · Available Version 41.0 · HTTP Methods GET DELETE

**Request parameters (GET, DELETE):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| predictionDefinitionIdOrName | String | 조회·삭제할 prediction definition의 ID 또는 developer name. | Required | 41.0 |

- Response body (GET): **Smart Data Discovery Prediction Definition**

### Prediction Definition Model Cards Resource (B5c)

```
GET /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/modelcards
```

Formats JSON · Available Version 51.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| predictionDefinitionIdOrName | String | model card를 조회할 prediction definition의 ID 또는 developer name. | Required | 41.0 ⚠️ |

> ⚠️ 리소스 헤더 Available Version은 51.0이나, 파라미터 표의 Avail Ver은 원문에서 41.0으로 표기됨 — 원문 그대로 보존.

- Response body (GET): **Smart Data Discovery Model Card**

### Prediction Definition Model Card Resource (B5d)

```
DELETE /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/modelcards/<modelCardId>
```

Formats JSON · Available Version 51.0 · HTTP Methods DELETE

**Request parameters (DELETE):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| modelCardId | String | 삭제할 model card의 ID. | Required | 41.0 |
| predictionDefinitionIdOrName | String | model card를 삭제할 prediction definition의 ID 또는 developer name. | Required | 41.0 |

### Prediction Definitions Models Resource (B5e)

```
GET  /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/models
POST /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/models
```

Formats JSON · Available Version 41.0 · HTTP Methods GET POST

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| predictionDefinitionIdOrName | String | 모델을 조회할 prediction definition의 ID 또는 developer name. | Required | 41.0 |
| status | SmartDataDiscoveryStatusEnum | status로 필터. Valid values: Disabled, Enabled | Optional | 41.0 |

- Response body (GET): **Smart Data Discovery Model Collection**

**Request parameters (POST):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| model | Smart Data Discovery Model Input | 생성할 모델. | Required | 41.0 |
| predictionDefinitionIdOrName | String | 모델을 생성할 prediction definition의 ID 또는 developer name. | Required | 41.0 |

- Response body (POST): **Smart Data Discovery Model**

### Prediction Definitions Model Resource (B5f)

```
GET    /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/models/<modelId>
PATCH  /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/models/<modelId>
DELETE /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/models/<modelId>
```

Formats JSON · Available Version 41.0 · HTTP Methods GET PATCH DELETE

**Request parameters (GET, DELETE):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| modelId | String | 조회·삭제할 모델 ID. | Required | 41.0 |
| predictionDefinitionIdOrName | String | 모델을 조회·삭제할 prediction definition의 ID 또는 developer name. | Required | 41.0 |

- Response body (GET, PATCH): **Smart Data Discovery Model**

> ⚠️ HTTP Methods는 GET PATCH DELETE이나, 원문에는 **"Request parameters for POST" 표도 존재**한다(모델 생성용). 원문 그대로 아래 포함.

**Request parameters (POST) — 원문 존재:**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| model | Smart Data Discovery Model Input | 생성할 모델. | Required | 41.0 |
| modelId | String | 조회·삭제할 모델 ID. | Required | 41.0 |
| predictionDefinitionIdOrName | String | 모델을 조회·삭제할 prediction definition의 ID 또는 developer name. | Required | 41.0 |

### Prediction Definitions Model Metrics Resource (B5g)

```
GET /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/models/<modelId>/metrics
```

Formats JSON · Available Version 50.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| count | Int | 반환할 metrics의 count. | Optional | 50.0 |
| modelId | String | 조회·삭제할 모델 ID. | Required | 41.0 |
| predictionDefinitionIdOrName | String | 모델을 조회·삭제할 prediction definition의 ID 또는 developer name. | Required | 41.0 |
| span | MetricSpanEnum | metrics의 time span. Valid values: Day, Month, SinceLastAction, Week | Optional | 50.0 |

- Response body (GET): **Smart Data Discovery Metrics Collection**

---

## Predict Jobs Resources (B6)

Bulk scoring(대량 채점) job 리소스 2종.

| Resource | 설명 | HTTP 메서드 | Resource URL |
|---|---|---|---|
| Predict Jobs Resource | Returns a collection of Einstein Discovery predict jobs and creates a predict job. | GET POST | `/smartdatadiscovery/predict-jobs` |
| Predict Job Resource | Returns an Einstein Discovery predict job. | GET PATCH DELETE | `/smartdatadiscovery/predict-jobs/<predictJobId>` |

### Predict Jobs Resource (B6a)

```
GET  /smartdatadiscovery/predict-jobs     # job 컬렉션 조회
POST /smartdatadiscovery/predict-jobs     # bulk scoring job 생성
```

Formats JSON · Available Version 48.0 · HTTP Methods GET POST

- Response body (GET): **Smart Data Discovery Predict Job Collection**

**Request body (POST):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| predictJob | SmartDataDiscoveryPredictJobInput | predict job 정보. | Required | 48.0 |

- Response body (POST): **Smart Data Discovery Predict Job**

### Predict Job Resource (B6b)

```
GET    /smartdatadiscovery/predict-jobs/<predictJobId>
PATCH  /smartdatadiscovery/predict-jobs/<predictJobId>
DELETE /smartdatadiscovery/predict-jobs/<predictJobId>
```

Formats JSON · Available Version 48.0 · HTTP Methods GET PATCH DELETE

**Request parameters (GET, DELETE):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| predictJobId | String | 조회·삭제할 predict job의 ID. | Required | 48.0 |

- Response body (GET, PATCH): **Smart Data Discovery Predict Job**

**Request parameters (PATCH):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| predictJob | SmartDataDiscoveryPredictJobUpdateInput | 수정할 predict job. | Required | 49.0 |
| predictJobId | String | 수정할 predict job의 ID. | Required | 49.0 |

---

## Predict Resource (B7)

Einstein Discovery 예측 1건을 생성한다(General Resources · Get Predictions의 리소스 레퍼런스).

```
POST /smartdatadiscovery/predict
```

Formats JSON · Available Version 41.0 · HTTP Methods POST

**Request body (POST):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| discoveryClient | String | discovery client. | Required | 41.0 |
| predict | AbstractSmartDataDiscoveryPredictInput | predict 정보. Valid values: SmartDataDiscoveryPredictInput, SmartDataDiscoveryPredictRawDataInput, SmartDataDiscoveryPredictRecordOverridesInput, SmartDataDiscoveryPredictRecordInput | Required | 41.0 |

- Response body (POST): **Smart Data Discovery Predict List**
- 사용 예제(records/RawData/RecordOverrides 형식, settings) → 형제 노트 [[Einstein Discovery REST — 개요·인증·예측 소비 흐름]].

---

## Predict History Resource (B8)

Einstein Discovery 예측 이력을 질의한다(General Resources).

```
POST /smartdatadiscovery/predict-history
```

Formats JSON · Available Version 56.0 · HTTP Methods POST

**Request body (POST):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| predictHistory | PredictHistoryInput | predict history 질의 입력. | Required | 56.0 |

- Response body (POST): **Predict History Collection**
- 사용 예제(goalId·targets·range의 maxLookBack·interval) → 형제 노트 [[Einstein Discovery REST — 개요·인증·예측 소비 흐름]].

---

## Refresh Jobs Resources (B9)

모델 refresh job 메타데이터 리소스 3종.

| Resource | 설명 | HTTP 메서드 | Resource URL |
|---|---|---|---|
| Refresh Jobs Resource | Returns a collection of Einstein Discovery refresh jobs. | GET | `/smartdatadiscovery/refresh-jobs` |
| Refresh Job Resource | Returns an Einstein Discovery refresh job. | GET | `/smartdatadiscovery/refresh-jobs/<refreshJobId>` |
| Refresh Job Refresh Tasks Resource | Returns a collection of refresh tasks for an Einstein Discovery refresh job. | GET | `/smartdatadiscovery/refresh-jobs/<refreshJobId>/refresh-tasks` |

### Refresh Jobs Resource (B9a)

```
GET /smartdatadiscovery/refresh-jobs
```

Formats JSON · Available Version 50.0 · **HTTP Methods GET POST**

> ⚠️ 목록 표에는 GET만, 상세 헤더에는 GET POST로 표기됨 — 원문 그대로 병기.

- Response body (GET): **Smart Data Discovery Refresh Job Collection**

### Refresh Job Resource (B9b)

```
GET /smartdatadiscovery/refresh-jobs/<refreshJobId>
```

Formats JSON · Available Version 50.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| refreshJobId | String | 조회할 refresh job의 ID. | Required | 50.0 |

- Response body (GET): **Smart Data Discovery Refresh Job**

### Refresh Job Refresh Tasks Resource (B9c)

```
GET /smartdatadiscovery/refresh-jobs/<refreshJobId>/refresh-tasks
```

Formats JSON · Available Version 50.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| refreshJobId | String | refresh tasks를 조회할 refresh job의 ID. | Required | 50.0 |

- Response body (GET): **Smart Data Discovery Refresh Task Collection**

---

## Stories Resources (B10)

`/smartdatadiscovery/stories/*` 하위 8개 리소스. Story·버전 이력·쿼리·요약을 다룬다.

| Resource | 설명 | HTTP 메서드 | Resource URL |
|---|---|---|---|
| Stories Resource | Returns a collection of Einstein Discovery stories. | GET | `/smartdatadiscovery/stories` |
| Story Resource | Returns an Einstein Discovery story. | GET | `/smartdatadiscovery/stories/<storyId>` |
| Story Query Resource | Runs a query on the current version of an Einstein Discovery story. | POST | `/smartdatadiscovery/stories/<storyId>/query` |
| Story Summary Resource | Returns a summary for the current version of an Einstein Discovery story. | GET | `/smartdatadiscovery/stories/<storyId>/summary` |
| Story Histories Resource | Returns a collection of Einstein Discovery story history items. | GET | `/smartdatadiscovery/stories/<storyId>/histories` |
| Story History Resource | Returns a specific Einstein Discovery story history item. | GET | `/smartdatadiscovery/stories/<storyId>/histories/<historyId>` |
| Story History Query Resource | Runs a query on an Einstein Discovery story history item. | POST | `/smartdatadiscovery/stories/<storyId>/histories/<historyId>/query` |
| Story History Summary Resource | Returns a summary for an Einstein Discovery story history item. | GET | `/smartdatadiscovery/stories/<storyId>/histories/<historyId>/summary` |

### Stories Resource (B10a)

```
GET /smartdatadiscovery/stories
```

Formats JSON · Available Version 48.0 · HTTP Methods GET
**Available Components:** LWC — `lightning/analyticSmartDataDiscoveryApi` `getStories()`

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| folderId | Id | CRM Analytics folder ID로 필터. | Optional | 48.0 |
| inputId | Id | story input ID로 필터. | Optional | 48.0 |
| page | String | 반환할 항목 뷰를 나타내는 생성 토큰. | Optional | 48.0 |
| pageSize | Integer | 한 페이지에 반환할 항목 수. 최소 1, 최대 200, 기본 25. | Optional | 48.0 |
| q | String | 검색어(공백 구분). 마지막 토큰에 와일드카드 자동 부가. 따옴표·와일드카드·특수문자는 URI 쿼리에서 자동 제거. | Optional | 48.0 |
| scope | AnalysisSetupScopeTypeEnum | scope 타입. Valid values: CreatedByMe, SharedWithMe | Optional | 48.0 |
| sourceType | AnalysisSetupSourceTypeEnum | source 타입. Valid values: AnalyticsDataset, LiveDataset, Report | Optional | 48.0 |
| sourceTypes | AnalysisSetupSourceTypeEnum[] | source 타입 목록. Valid values: AnalyticsDataset, LiveDataset, Report | Optional | 48.0 |

- Response body (GET): **Story Collection**

### Story Resource (B10b)

```
GET /smartdatadiscovery/stories/<storyId>
```

Formats JSON · Available Version 48.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| storyId | Id | 조회할 story의 ID. | Required | 48.0 |

- Response body (GET): **Story**

### Story Query Resource (B10c)

```
POST /smartdatadiscovery/stories/<storyId>/query
```

Formats JSON · Available Version 52.0 · HTTP Methods POST

**Request parameters (POST):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| queryPayload | StoryQueryInput | 쿼리 정보. | Required | 52.0 |
| storyId | String | 질의할 story의 ID. | Required | 52.0 |

- Response body (POST): **Story Query**

### Story Summary Resource (B10d)

```
GET /smartdatadiscovery/stories/<storyId>/summary
```

Formats JSON · Available Version 51.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| storyId | String | summary를 조회할 story의 ID. | Required | 51.0 |

- Response body (GET): **Story Summary Detail**

### Story Histories Resource (B10e)

```
GET /smartdatadiscovery/stories/<storyId>/histories
```

Formats JSON · Available Version 48.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| storyId | String | history items를 조회할 story의 ID. | Required | 51.0 ⚠️ |

> ⚠️ 리소스 Avail Ver은 48.0이나 파라미터 표엔 51.0으로 표기됨 — 원문 그대로 보존.

- Response body (GET): **Asset History Collection**

### Story History Resource (B10f)

```
GET /smartdatadiscovery/stories/<storyId>/histories/<historyId>
```

Formats JSON · Available Version 51.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| historyId | String | 조회할 story history의 ID. | Required | 51.0 |
| storyId | String | 조회할 story의 ID. | Required | 51.0 |

- Response body (GET): **Story Version**

### Story History Query Resource (B10g)

```
POST /smartdatadiscovery/stories/<storyId>/histories/<historyId>/query
```

Formats JSON · Available Version 52.0 · HTTP Methods POST

**Request parameters (POST):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| historyId | String | 질의할 story history의 ID. | Required | 52.0 |
| queryPayload | StoryQueryInput | 쿼리 정보. | Required | 52.0 |
| storyId | String | history 레코드를 조회할 story의 ID. | Required | 52.0 |

- Response body (POST): **Story Query**

### Story History Summary Resource (B10h)

```
GET /smartdatadiscovery/stories/<storyId>/histories/<historyId>/summary
```

Formats JSON · Available Version 51.0 · HTTP Methods GET

**Request parameters (GET):**

| Name | Type | 설명 | Req/Opt | Avail Ver |
|---|---|---|---|---|
| historyId | String | summary를 조회할 story history의 ID. | Required | 51.0 |
| storyId | String | history 레코드를 조회할 story의 ID. | Required | 51.0 |

- Response body (GET): **Story Summary Detail**

---

## 참조 표현형·Enum 이름 (상세는 범위 밖)

아래 이름은 위 리소스가 참조하는 **Request/Response Body 표현형**과 **Enum**이다. 필드 상세는 이 노트 범위 밖(Ch4 Request/Response Bodies, 별도 표현형 노트 소관). 지표 관련 표현형(Model Metrics·Feature Importances·Residuals)의 필드는 [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]] 참조.

**Input(요청):** Smart Data Discovery Predict Input · Smart Data Discovery Predict Raw Data Input · Smart Data Discovery Predict Record Overrides Input · Smart Data Discovery Predict Record Input · AbstractSmartDataDiscoveryPredictInput · SmartDataDiscoveryAIModelInput · SmartDataDiscoveryNarrativeInput · Smart Data Discovery Model Input · SmartDataDiscoveryPredictJobInput · SmartDataDiscoveryPredictJobUpdateInput · PredictHistoryInput · StoryQueryInput

**Output(응답):** Directory Item Collection · Smart Data Discovery AI Model Collection · Smart Data Discovery AI Model · Smart Data Discovery AI Model Coefficient Collection · StreamedRepresentation · Abstract Smart Data Discovery AI Model Metrics (구현: Classification / Multiclass / Regression Metrics) · Smart Data Discovery AI Model Residual Collection · Smart Data Discovery Feature Importance Metric · Smart Data Discovery Metrics Collection · Smart Data Discovery Narrative Field Collection · Smart Data Discovery Prediction Definition Collection · Smart Data Discovery Prediction Definition · Smart Data Discovery Model Card · Smart Data Discovery Model Collection · Smart Data Discovery Model · Smart Data Discovery Predict Job Collection · Smart Data Discovery Predict Job · Smart Data Discovery Predict List · Predict History Collection · Smart Data Discovery Refresh Job Collection · Smart Data Discovery Refresh Job · Smart Data Discovery Refresh Task Collection · Story Collection · Story · Story Query · Story Summary Detail · Asset History Collection · Story Version

**Enum(파라미터 참조 — 유효값은 각 파라미터 표에 전수 포함):** SmartDataDiscoverySortOrderEnum · SmartDataDiscoveryAIModelCollectionSortOrderTypeEnum · SmartDataDiscoveryModelSourceTypeEnum · SmartDataDiscoveryAIModelStatusEnum · MetricSpanEnum · ConnectSmartDataDiscoveryOutcomeGoalEnum · ConnectSmartDataDiscoveryPredictionTypeEnum · PredictionDefinitionCollectionSortOrderTypeEnum · SmartDataDiscoveryStatusEnum · AnalysisSetupScopeTypeEnum · AnalysisSetupSourceTypeEnum

---

## 관련 노트

- [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]] — Model Metrics·Residuals·Feature Importances 리소스가 참조하는 지표 표현형의 필드 상세.
- [[Einstein Discovery — Model Builder·예측 모델]] — 이 REST가 다루는 Discovery 모델·prediction definition의 제품 개념.
- [[Einstein Discovery REST — 개요·인증·예측 소비 흐름]] — 위 엔드포인트들의 실제 사용 예제(Ch1–2 인증·요청/응답 JSON).
- [[Einstein Discovery REST — 요청 표현형 (Request Bodies)]] — 이 엔드포인트들이 소비하는 요청 바디(Input) 86종의 프로퍼티 전수.
