---
tags: [einstein, einstein-discovery, crm-analytics, rest-api, prediction, smart-data-discovery, guide]
source: bi_dev_guide_rest_sdd.pdf (Einstein Discovery REST API Developer Guide, Summer '26)
created: 2026-07-19
aliases: [Einstein Discovery REST, Smart Data Discovery API, Get Predictions API, smartdatadiscovery predict, Prediction Definition 관리, Manage Models REST, Predict History, 예측 소비]
---

# Einstein Discovery REST — 개요·인증·예측 소비 흐름

> Einstein Discovery REST API(`/smartdatadiscovery/*`)로 예측을 요청·조회하고 Prediction Definition·Model·Job·History를 관리하는 사용 흐름 — 인증·`Get Predictions`(record IDs vs raw data)·관리 작업별 호출 예제.

---

## 개요·인증

Einstein Discovery REST API는 **Connect REST API 위에 얹힌** API 계열로, base 리소스 경로는 `/services/data/vXX.0/smartdatadiscovery` 이다. 예측(prediction)을 요청·조회하고, 예측을 뒷받침하는 Prediction Definition · Model · Prediction Job · Model Refresh Job · Prediction History 를 관리한다.

**인증 (OAuth):** Connect REST API의 OAuth 흐름을 그대로 사용한다.

> PDF 원문: *"Connect REST API uses OAuth to securely identify your application before connecting to Salesforce."*
> *"For current OAuth information, see OAuth and Connect REST API in the Connect REST API developer guide."*

참고 리소스(원문 More Resources):
- Salesforce Help: Connected Apps
- Salesforce Help: Authorize Apps with OAuth
- Salesforce Help: OpenID Connect Token Introspection
- Trailhead: Build Integrations Using Connected Apps

**Release Notes:** 신규·변경 리소스/바디는 Salesforce Release Notes의 **CRM Analytics** 항목에서 *"Einstein Discovery REST API"* 를 찾는다.

> PDF Note: *"If the API: New and Changed Items section in the Salesforce Release Notes isn't present, there aren't any updates for that release."*

### API End-of-Life 정책

> PDF 원문: *"Salesforce is committed to supporting each API version for a minimum of three years from the date of first release. In order to mature and improve the quality and performance of the API, versions that are more than three years old might cease to be supported. When an API version is to be deprecated, advance notice is given at least one year before support ends. Salesforce will directly notify customers using API versions planned for deprecation."*

Version Support Status:

| Version | Status | Retirement Info |
|---|---|---|
| Versions 31.0 through 67.0 | Supported. | — |
| Versions 21.0 through 30.0 | As of Summer '25, these versions are retired and unavailable. | Salesforce Platform API Versions 21.0 through 30.0 Retirement |
| Versions 7.0 through 20.0 | As of Summer '22, these versions are retired and unavailable. | Salesforce Platform API Versions 7.0 through 20.0 Retirement |

> PDF 원문: *"If you request any resource or use an operation from a retired API version, REST API returns 410:GONE error code. To identify requests made from old or unsupported API versions of REST API, access the free API Total Usage event type."*

### 요청 형식 Considerations

> PDF 원문: *"While using the Einstein Discovery REST API, keep this in mind:"*

- Request parameter는 리소스 URL의 일부로 넣을 수 있다(예: `/smartdatadiscovery/models?q=status`). request body는 요청에 포함하는 rich input이다. 한 리소스에 접근할 때 request body **또는** request parameter를 쓰되 **둘 다 동시에 쓸 수 없다.**
  > PDF 원문: *"When accessing a resource, you can use either a request body or request parameters. **You cannot use both.**"*
- request body를 쓸 때는 `Content-Type: application/json` 또는 `Content-Type: application/xml`.
- request parameter를 쓸 때는 `Content-Type: application/x-www-form-urlencoded`.

> 이 노트가 호출하는 각 엔드포인트의 URI·HTTP 메서드·request/response 파라미터 정본은 형제 노트 [[Einstein Discovery REST — 리소스 엔드포인트 레퍼런스]] 참조. 여기서는 **사용 흐름과 예제**에 집중한다.

### 사용 흐름 한눈에

각 use-case 챕터의 개요문(원문):

| 흐름 | 원문 개요 |
|---|---|
| Get Predictions | "The Einstein Prediction Service provides a REST API endpoint to request a prediction." |
| Manage Prediction Definitions | "A prediction definition specifies what the model is trying to predict and the Salesforce entity associated with the prediction. Each prediction definition has a unique id. Only certain attributes of a prediction definition can be modified." |
| Manage Models | "Each model has a unique id. A model is used to evaluate predictors and return predictions and improvements. These REST endpoints allow you to make updates to model metadata, but not update the actual predictive model." |
| Manage Prediction Jobs | "REST API endpoints to run bulk scoring jobs for a prediction. Bulk scoring jobs enable you to score predictions on multiple records at a time... You can score all records, a segment of the records, or records that haven't reached the terminal state." |
| Manage Model Refresh Jobs | "REST API endpoints to retrieve metadata for model refresh jobs." |
| Query Prediction History | "A REST API endpoint to query prediction histories." |

---

## Get Predictions

**Prediction Request:** `POST /smartdatadiscovery/predict`

request body는 다음 표현형 중 하나로 만든다: **Smart Data Discovery Predict Input**, **Smart Data Discovery Predict Raw Data Input**, **Smart Data Discovery Predict Record Overrides Input**, **Smart Data Discovery Predict Record Input**.

request body에는 사용할 prediction definition과, 점수를 매길 데이터 행(row)을 지정한다. 행은 세 가지 형식 중 하나로 지정한다:

| Format | Description |
|---|---|
| Records | Salesforce record Ids associated with the subscribedEntity of the prediction definition (retrieved using a SOQL query). |
| RawData | A two-dimensional array of row values in which each row is a comma-separated list of values. |
| RecordOverrides | Array of objects containing the Salesforce record Ids. Optionally, override or append values in individual records with an array of row values (in which each row is a comma-separated list of values). |

> PDF 원문: *"When you run a prediction, Salesforce applies the model specified in the prediction definition to the set of records and returns a prediction score for each record. If you specify 3 records, for example, you get 3 predictions in the order in which the records were specified in the request."*

### 요청 예제 — type이 Records

`records` 는 prediction definition의 subscribedEntity에 연결된 Salesforce record Id의 comma-separated 목록이다. 사용 가능한 prediction definition Id 목록은 `GET /smartdatadiscovery/predictiondefinitions` 로 조회한다. **최대 200개** record Id를 지정할 수 있다. 아래 예제는 record 2개:

```json
{
"predictionDefinition": "1ORRM00000000304AA",
"type": "Records",
"records": ["006RM000002bEfiYAE", "006RM000002bEflYAE" ]
}
```

### 요청 예제 — type이 RawData

컬럼 5개를 명명하고, 각 5개 데이터 값을 가진 record 2개를 지정한다. 컬럼은 story setup 과정에서 선택된다.

```json
{
"predictionDefinition": "0OR1H000000Gma9WAC",
"type": "RawData",
"columnNames": ["StageName","CloseDate","Account.BillingCountry","IsClosed","IsWon"],
"rows": [
["Prospecting","2020-06-30","USA","false","false"],
["Qualification","2020-08-30","EMEA", "false","false"]
]
}
```

### 요청 예제 — type이 RecordOverrides

row 데이터를 지정할 때:
- 각 Salesforce record Id는 prediction definition에 연결된 subscribedEntity의 한 record를 나타낸다.
- (Optional) 지정된 각 row는 해당 record에 지정된 데이터를 override하거나 append할 값을 담는다.

> PDF 원문: *"You can specify up to 200 entries (record entries plus row entries) in a request. For example, if you have 120 record entries, you can override up to 80 record entries with row entries. The following example specifies two columns with two record entries and two overrides."*

즉 record entry + row entry 합계 최대 200개다(예: record entry 120개면 row entry로 최대 80개까지 override). 아래 예제는 컬럼 2개, record entry 2개, override 2개:

```json
{
"predictionDefinition": "0OR1H000000Gma9WAC",
"type": "RecordOverrides",
"columnNames": ["StageName", "CloseDate"],
"rows": [
{
"record": "0061H00000dnhQEQAY",
"row": ["Prospecting", "2020-06-30"]
},
{
"record": "0061H00000dnhPzQAI",
"row": ["Qualification", "2020-08-30"]
}
]
}
```

### 요청 예제 — Predictive Factors and Improvements

> PDF 원문: *"Starting in 50.0, this API returns a single prediction value by default. To request prediction factors and improvements, you must ask for them explicitly in the request body."*

즉 50.0부터는 기본적으로 **단일 prediction 값만** 반환하며, top predictor와 improvement(prescription)를 받으려면 request body의 `settings` 로 명시 요청해야 한다.

```json
{
"predictionDefinition": "1ORB0000000TNYIOA4",
"type": "Records",
"records": ["006B0000002wvCtIAI"],
"settings": {"maxPrescriptions": 3,
"maxMiddleValues": 3,
"prescriptionImpactPercentage": 87
}
}
```

settings 설명(원문):
- `maxPrescriptions` — 응답에 반환할 improvement 최대 개수(1–3).
- `maxMiddleValues` — 응답에 반환할 top predictor 개수(1–3).
- `prescriptionImpactPercentage` — improvement가 반환되기 위한 threshold filter(outcome 개선 최소 %, 이 예에서는 87%).

> PDF 원문: *"To learn more about these settings and see these elements on an example Lightning page, see Add Einstein Predictions to a Lightning Page."*

### POST 응답 — Smart Data Discovery Predict List

응답은 **Smart Data Discovery Predict List** 이다. record별 예측이 요청 순서대로 배열로 반환되며, 각 항목은 `model` · `prediction`(baseLine · importWarnings · middleValues · other · smallTermCount · total) · `prescriptions` · `status` 를 담는다.

```json
{
"predictionDefinition" : "1ORRM0000000030",
"predictions" : [ {
"model" : {
"id" : "1OtRM000000002b0AA"
},
"prediction" : {
"baseLine" : 799315.4282959097,
"importWarnings" : {
"mismatchedColumns" : [ ],
"missingColumns" : [ "OpportunityAge", "Account.Owner.UniqueUserName",
"Account.Industry", "Account.AccountSource", "Account.Owner.Name", "Account.BillingCountry",
"Name" ],
"outOfBoundsColumns" : [ ]
},
"middleValues" : [ {
"columns" : [ {
"columnName" : "Has Line Item",
"columnValue" : "true"
} ],
"value" : 543763.66105859
} ],
"other" : 0.0,
"smallTermCount" : 0,
"total" : 1343079.0893544997
},
"prescriptions" : [ ],
"status" : "Success"
}, {
"model" : {
"id" : "1OtRM000000002b0AA"
},
"prediction" : {
"baseLine" : 799315.4282959097,
"importWarnings" : {
"mismatchedColumns" : [ ],
"missingColumns" : [ "OpportunityAge", "Account.Owner.UniqueUserName",
"Account.Industry", "Account.AccountSource", "Account.Owner.Name", "Account.BillingCountry",
"Name" ],
"outOfBoundsColumns" : [ ]
},
"middleValues" : [ {
"columns" : [ {
"columnName" : "Has Line Item",
"columnValue" : "true"
} ],
"value" : 543763.66105859
} ],
"other" : 0.0,
"smallTermCount" : 0,
"total" : 1343079.0893544997
},
"prescriptions" : [ ],
"status" : "Success"
} ],
"settings" : {
"maxPrescriptions" : 0,
"maxMiddleValues" : 0,
"prescriptionImpactPercentage" : 0
}
}
```

> `prediction` 값의 의미(baseLine · middleValues의 top predictor 기여 · total 등)와 model 품질/편향 지표의 표현형 상세는 [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]] 참조.

---

## Manage Prediction Definitions

prediction definition은 **모델이 무엇을 예측하는지와 연결된 Salesforce 엔티티**를 정의하며 고유 `id` 를 갖는다. 일부 속성만 수정 가능하다.

| 작업 | 호출 | 응답 표현형 |
|---|---|---|
| Get Available Prediction Definitions | `GET /smartdatadiscovery/predictiondefinitions` | Smart Data Discovery Prediction Definition Collection |
| Get Metadata for a Prediction Definition | `GET /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>` | Smart Data Discovery Prediction Definition |
| Delete a Prediction Definition | `DELETE /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>` | — |

### Get Available Prediction Definitions — 응답 예제

응답은 `200 OK` / `Content-Type: application/json;charset=UTF-8` 후 collection JSON(아래는 원문 4개 항목 배열). 각 항목 필드셋: `countOfActiveModels`, `countOfModels`, `createdBy{id,name,profilePhotoUrl}`, `createdDate`, `id`, `label`, `lastModifiedBy{...}`, `lastModifiedDate`, `modelsUrl`, `name`, `outcome{goal,label,name}`, `predictionType`, `status`, `url`.

```json
{
"nextPageUrl" : null,
"predictionDefinitions" : [ {
"countOfActiveModels" : 1,
"countOfModels" : 1,
"createdBy" : {
"id" : "005B0000001nz1lIAA",
"name" : "MyUserName",
"profilePhotoUrl" : "https://MyDomainName.file.force.com/profilephoto/729B00000008pwV/T"
},
"createdDate" : "2020-04-22T01:25:19.000Z",
"id" : "1ORB000000000bOOAQ",
"label" : "Maximize CLV - first version",
"lastModifiedBy" : { "id":"005B0000001nz1lIAA", "name":"MyUserName", "profilePhotoUrl":"https://MyDomainName.file.force.com/profilephoto/729B00000008pwV/T" },
"lastModifiedDate" : "2020-04-22T01:25:19.000Z",
"modelsUrl" : "/services/data/v52.0/smartdatadiscovery/predictiondefinitions/1ORB000000000bOOAQ/models",
"name" : "Maximize_CLV_first_version7c48e8db",
"outcome" : { "goal":"Maximize", "label":"CLV", "name":"CLV" },
"predictionType" : "Regression",
"status" : "Enabled",
"url" : "/services/data/v52.0/smartdatadiscovery/predictiondefinitions/1ORB000000000bOOAQ"
}, {
"countOfActiveModels" : 1, "countOfModels" : 1,
"id" : "1ORB00000004CAkOAM", "label" : "Won_Won",
"name" : "Won_Wone329300b",
"outcome" : { "goal":"Maximize", "label":"Won", "name":"Won" },
"predictionType" : "Classification", "status" : "Enabled",
"url" : "/services/data/v52.0/smartdatadiscovery/predictiondefinitions/1ORB00000004CAkOAM"
}, {
"countOfActiveModels" : 2, "countOfModels" : 2,
"id" : "1ORB00000004CApOAM", "label" : "CLV Prediction",
"name" : "CLV_Prediction3d72828a",
"outcome" : { "goal":"Maximize", "label":"CLV", "name":"CLV" },
"predictionType" : "Regression", "status" : "Enabled",
"url" : "/services/data/v52.0/smartdatadiscovery/predictiondefinitions/1ORB00000004CApOAM"
}, {
"countOfActiveModels" : 1, "countOfModels" : 1,
"id" : "1ORB00000004CCCOA2", "label" : "CLV_CLV",
"name" : "CLV_CLVa7cf508c",
"outcome" : { "goal":"Maximize", "label":"CLV", "name":"CLV" },
"predictionType" : "Regression", "status" : "Enabled",
"url" : "/services/data/v52.0/smartdatadiscovery/predictiondefinitions/1ORB00000004CCCOA2"
} ],
"totalSize" : 4,
"url" : "/services/data/v52.0/smartdatadiscovery/predictiondefinitions"
}
```

> 위 collection의 2~4번 항목은 원문상 첫 항목과 동일 구조(`createdBy`/`lastModifiedBy`/`createdDate`/`lastModifiedDate`/`modelsUrl` 블록 전수 존재)이며, 여기서는 각 항목을 구별하는 필드(`id`·`label`·`name`·`outcome`·`predictionType`·`status`·`url`) 위주로 발췌했다.

### Get Metadata for a Prediction Definition — 응답 예제

단일 객체이며, 자동 refresh 설정(`refreshConfig`) · `pushbackField` · `subscribedEntity` 등이 포함된다.

```json
{
"countOfActiveModels" : 1,
"countOfModels" : 1,
"createdBy" : { "id":"005B0000004iaa7IAA", "name":"Admin User", "profilePhotoUrl":"https://MyDomainName.file.force.com/profilephoto/729B0000000EmIX/T" },
"createdDate" : "2020-03-31T01:18:51.000Z",
"id" : "1ORB000000000JuOAI",
"label" : "ItalyInfo",
"lastModifiedBy" : { "id":"005B00000051RBqIAM", "name":"YourUserName", "profilePhotoUrl":"https://MyDomainName.file.force.com/profilephoto/729B00000003ARf/T" },
"lastModifiedDate" : "2020-08-18T23:09:25.000Z",
"modelsUrl" : "/services/data/v52.0/smartdatadiscovery/predictiondefinitions/1ORB000000000JuOAI/models",
"name" : "ItalyInfo9461190a",
"outcome" : { "goal":"Minimize", "label":"Total Cases", "name":"totale_casi" },
"predictionType" : "Regression",
"pushbackField" : { "label":"mypredField", "name":"Custom_Opportunity__c.mypredField__c" },
"refreshConfig" : {
"isEnabled" : true,
"recipientList" : [ { "displayName":"YourUserName", "id":"005B00000051RBqIAM", "type":"User" } ],
"schedule" : {
"dayInWeek" : "wednesday",
"frequency" : "monthlyrelative",
"nextScheduledDate" : "2020-10-08T02:00:00.000Z",
"time" : { "hour":19, "timeZone":{ "gmtOffset":-7.0, "name":"Pacific Daylight Time", "zoneId":"America/Los_Angeles" } },
"weekInMonth" : "first"
},
"shouldScoreAfterRefresh" : false,
"userContext" : { "id":"005B00000051RBqIAM" },
"warningThresholdPercentage" : 0.05
},
"status" : "Enabled",
"subscribedEntity" : "Custom_Opportunity__c",
"url" : "/services/data/v52.0/smartdatadiscovery/predictiondefinitions/1ORB000000000JuOAI"
}
```

> PDF 원문: *"The refreshConfig section describes model refresh jobs for this prediction. Model refresh jobs are configured in Model Manager as described in Configure Automatic Model Refresh for a Prediction."*

---

## Manage Models

model은 predictor를 평가해 예측·improvement를 반환하는 실체이며 고유 `id` 를 갖는다. 이 엔드포인트들은 **모델 메타데이터**를 수정할 뿐, 실제 예측 모델 자체는 갱신하지 않는다.

| 작업 | 호출 | 응답 표현형 |
|---|---|---|
| Get Available Models | `GET /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/models` | Smart Data Discovery Model Collection |
| Get Metadata for a Model | `GET /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/models/<modelId>` | — |
| Delete a Model | `DELETE /smartdatadiscovery/predictiondefinitions/<predictionDefinitionIdOrName>/models/<modelId>` | — |

### Get Available Models — 응답 예제

`200 OK` 후 **Smart Data Discovery Model Collection**(model 2개 배열). 각 model 객체는 `actionableVariables` · `createdBy` · `createdDate` · `fieldMappingList` · `filters` · `id` · `label` · `lastModifiedBy` · `lastModifiedDate` · `model{id}` · `modelType` · `name` · `predictionDefinitionUrl` · `sortOrder` · `status` · `url` 을 담는다.

```json
{
"models" : [ {
"actionableVariables" : [ { "label":"Type","name":"Type","type":"Text" }, { "label":"Ownership","name":"Ownership","type":"Text" }, { "label":"Rating","name":"Rating","type":"Text" }, { "label":"Division","name":"Division","type":"Text" }, { "label":"AccountScore","name":"AccountScore","type":"Text" } ],
"createdBy" : { "id":"005B0000002zz1lIAA","name":"MyUserName","profilePhotoUrl":"https://MyDomainName.file.force.com/profilephoto/729B00000009ttx/T" },
"createdDate" : "2020-01-17T00:24:35.000Z",
"fieldMappingList" : [ { "modelField":{"label":"CloseDate","name":"CloseDate","type":"Date"} }, { "modelField":{"label":"Industry","name":"Industry","type":"Text"} }, { "modelField":{"label":"StartDate","name":"StartDate","type":"Date"} }, { "modelField":{"label":"Ownership","name":"Ownership","type":"Text"} }, { "modelField":{"label":"Type","name":"Type","type":"Text"} }, { "modelField":{"label":"Rating","name":"Rating","type":"Text"} }, { "modelField":{"label":"BillingState","name":"BillingState","type":"Text"} }, { "modelField":{"label":"Division","name":"Division","type":"Text"} }, { "modelField":{"label":"AccountScore","name":"AccountScore","type":"Text"} } ],
"filters" : [ ],
"id" : "1OtB00000004CApKAM",
"label" : "CLV",
"lastModifiedBy" : { "id":"005B0000002zz1lIAA","name":"MyUserName","profilePhotoUrl":"https://MyDomainName.file.force.com/profilephoto/729B00000009ttx/T" },
"lastModifiedDate" : "2020-01-17T00:24:35.000Z",
"model" : { "id":"1OTB000000000ajOAA" },
"modelType" : "Regression",
"name" : "CLV",
"predictionDefinitionUrl" : "/services/data/v52.0/smartdatadiscovery/predictiondefinitions/1ORB00000004CApOAM",
"sortOrder" : 0,
"status" : "Enabled",
"url" : "/services/data/v52.0/smartdatadiscovery/predictiondefinitions/1ORB00000004CApOAM/models/1OtB00000004CApKAM"
}, {
"id" : "1OtB00000004CAqKAM",
"createdDate" : "2020-01-17T00:26:14.000Z",
"sortOrder" : 1,
"url" : "/services/data/v52.0/smartdatadiscovery/predictiondefinitions/1ORB00000004CApOAM/models/1OtB00000004CAqKAM"
} ],
"totalSize" : 2,
"url" : "/services/data/v52.0/smartdatadiscovery/predictiondefinitions/1ORB00000004CApOAM/models"
}
```

> 원문상 두 model은 구조가 동일하고 `actionableVariables` 순서만 약간 다르다(첫 model: Type / Ownership / Rating / Division / AccountScore, 둘째 model: Industry / Type / Ownership / Rating / Division). `fieldMappingList` 는 두 model 모두 9개 modelField로 동일하며, `model.id` 는 둘 다 `1OTB000000000ajOAA` 이다. 위 예제의 두 번째 항목은 이를 구별 필드 위주로 발췌했다.

---

## Manage Prediction Jobs

bulk scoring job은 여러 record를 한 번에 채점한다(예: 갱신 모델 배포 후 전체 prediction score 재계산, 과거 데이터로 모델 성능 검증). bulk scoring job은 Model Manager에서 구성한다(Score Records in Bulk 참조).

> PDF Note: *"If the daily predictions limit is reached in your org, active scoring jobs are paused, then resumed the next day."*

즉 org의 **daily predictions limit**에 도달하면 active scoring job은 일시정지되고 **다음 날 재개**된다.

### Run a Bulk Scoring Job for a Prediction

`POST /smartdatadiscovery/predict-jobs` — 요청 표현형 **Smart Data Discovery Job Predict Input**. request body에 bulk scoring 대상 prediction definition Id, user-defined label, 선택적 filter 설정을 지정한다.

```json
{
"predictionDefinition":{ "id":"{{predictionDefinitionId}}" },
"label":"{{label}}",
"useTerminalStateFilter" : false,
"filters":{
"filters":[
{
"fieldName":"Opportunity.Name",
"values":[ "My Opportunity" ],
"operator":"Equal"
}
]
}
}
```

> 사용 가능한 prediction definition Id는 `GET /smartdatadiscovery/predictiondefinitions` 로 조회한다.

### Get Scoring Jobs

`GET smartdatadiscovery/predict-jobs`

> ⚠️ 원문 Examples 챕터의 이 줄은 선행 슬래시 없이 `smartdatadiscovery/predict-jobs` 로 표기됐다. Resources 레퍼런스에서는 `/smartdatadiscovery/predict-jobs` 이다(정본은 형제 엔드포인트 노트).

---

## Manage Model Refresh Jobs

model refresh job은 Model Manager에서 구성한다(Configure Automatic Model Refresh for a Prediction Definition 참조). 이 엔드포인트들은 refresh job 메타데이터를 조회한다.

### Get Prediction Refresh Jobs

`GET /smartdatadiscovery/refresh-jobs` — 응답 표현형 **Smart Data Discovery Refresh Job Collection**.

```json
{
"refreshJobs" : [ {
"createdBy" : { "id":"005B0000006DdetIAC","name":"YourUserName","profilePhotoUrl":"https://MyDomainName.file.force.com/profilephoto/729B0000000Eqe5/T" },
"createdDate" : "2020-09-09T16:16:39.000Z",
"endTime" : "2020-09-09T16:20:02.000Z",
"id" : "1OXB00000008OIPOA2",
"refreshTarget" : { "id":"1ORB0000000TNXyOAO" },
"refreshTasksUrl" : "/services/data/v52.0/smartdatadiscovery/refresh-jobs/1OXB00000008OIPOA2/refresh-tasks",
"startTime" : "2020-09-09T16:16:41.000Z",
"status" : "Success",
"type" : "UserTriggered",
"url" : "/services/data/v52.0/smartdatadiscovery/refresh-jobs/1OXB00000008OIPOA2"
} ],
"totalSize" : 1,
"url" : "/services/data/v52.0/smartdatadiscovery/refresh-jobs"
}
```

### Get Prediction Refresh Job Details

`GET /smartdatadiscovery/refresh-jobs/<refreshJobId>` — 응답은 위 `refreshJobs` 배열의 단일 항목 구조와 동일하다.

### Get Prediction Refresh Job Task Details

`GET /smartdatadiscovery/refresh-jobs/<refreshJobId>/refresh-tasks` — 응답 표현형 **Smart Data Discovery Refresh Job**(원문 표기).

```json
{
"refreshTasks" : [ {
"createdBy" : { "id":"005B0000006DdetIAC","name":"YourUserName","profilePhotoUrl":"https://MyDomainName.file.force.com/profilephoto/729B0000000Eqe5/T" },
"createdDate" : "2020-09-09T16:16:39.000Z",
"endTime" : "2020-09-09T16:19:54.000Z",
"id" : "1OxB00000008OIKKA2",
"refreshTarget" : { "id":"1OtB0000000TNdAKAW","label":"IsWon","name":"IsWon" },
"refreshedAIModel" : { "id":"1OTB0000000PDeBOAW" },
"source" : { "story":{"id":"1Y3B00000004HOCKA2"}, "storyVersion":{"id":"9B4B00000008UrEKAU"} },
"startTime" : "2020-09-09T16:16:45.000Z",
"status" : "Success"
} ],
"totalSize" : 1,
"url" : "/services/data/v52.0/smartdatadiscovery/refresh-jobs/1OXB00000008OIPOA2/refresh-tasks"
}
```

---

## Query Prediction History

**Predict History Request:** `POST /smartdatadiscovery/predict-history` — 요청 표현형 **Predict History Input**. request body에 goal의 ID, prediction history range, target 목록을 지정한다.

| Field | Description |
|---|---|
| goalId | The ID of the prediction definition to query for historical predictions. |
| targets | A list of opportunity IDs as strings to use for the target entities of the query. The list is limited to 1 entry. |
| range | An optional range for the query. Use the **Predict History Range Input** to specify the range. |

`range` (Predict History Range Input)의 필드:
- **maxLookBack** — prediction history 값 개수. 유효 값 **1–3**, 기본값 **1**.
- **interval** — prediction history 간격. 유효 값 **Weekly** 또는 **None**, 기본값 **Weekly**.

### 요청 예제 — maxLookBack 2

`POST /smartdatadiscovery/predict-history`

```json
{
"targets" : [ "1Otxx00000000304AA" ],
"goalId" : "1ORxx00000000509BA",
"range" : {
"maxLookBack" : 2
}
}
```

### POST 응답 — Predict History Collection

응답은 **Predict History Collection** 이다.

```json
{
"history" : [
{
"target" : "006xx000001a2p3AAA",
"predictions" : [
{
"createdDate" : "2022-09-16T19:47:14.000Z",
"value" : "21.69962721629",
"model" { "id" : "1Otxx00000000304AA" }
},
{
"createdDate" : "2022-09-16T19:47:15.000Z",
"value" : "21.83126271983",
"model" { "id" : "1Otxx00000000304AA" }
}
]
}
],
"range" : {
"maxLookBack" : 2,
"interval" : "Weekly"
}
}
```

> ⚠️ 위 응답의 `"model" { "id" : ... }` 는 PDF 원문에 콜론 없이 표기된 오타를 **그대로 보존**한 것이다. 정상 JSON은 `"model": { "id": ... }` 이다.

---

## 혼동 주의 — SmartDataDiscovery vs CdpMl

이 API 계열(`/smartdatadiscovery/*`, 표현형 접두어 `SmartDataDiscovery...`)은 **Einstein Discovery**의 예측 소비다. Data 360(CDP)의 ML 예측은 별개 계열(Apex `ConnectApi.CdpMachineLearning`)이므로 표현형·엔드포인트가 다르다 — [[ConnectApi CdpMachineLearning — Data 360 ML 예측]] 참조.

---

## 관련 노트

- [[Einstein Discovery REST — 리소스 엔드포인트 레퍼런스]] — 이 흐름이 호출하는 각 엔드포인트의 URI·HTTP 메서드·request/response 파라미터 정본.
- [[Einstein Discovery REST — 요청 표현형 (Request Bodies)]] — 이 흐름의 요청 바디(Input) 표현형 86종 프로퍼티 전수.
- [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]] — 예측·model metrics 응답에 등장하는 품질·편향 지표 표현형 상세.
- [[Einstein Discovery — Model Builder·예측 모델]] — 이 REST로 소비하는 Discovery 예측 모델의 제품 개념·저작.
- [[ConnectApi CdpMachineLearning — Data 360 ML 예측]] — 별개 계열 disambiguation(Data 360 `CdpMl` vs Einstein Discovery `SmartDataDiscovery`).
