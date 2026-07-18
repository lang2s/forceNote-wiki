---
tags: [apex, connectapi, data-cloud, data-360, machine-learning, prediction, reference]
source: salesforce_apex_reference_guide.pdf (Apex Reference Guide v67.0)
created: 2026-07-18
aliases: [CdpMachineLearning, Data 360 ML Prediction, Data Cloud ML 예측, ConnectApi predict, CdpMlPredictResult, Data 360 머신러닝 예측]
---

# ConnectApi.CdpMachineLearning — Data 360 ML 예측

> Data 360(Data Cloud)의 배포된 ML 모델에 Apex에서 동기 예측을 요청하는 `ConnectApi.CdpMachineLearning.predict` API — 입력 표현형·예측 결과·집계(aggregate)·기여 요인(contribution)·enum 전수.

---

## 개요

`ConnectApi.CdpMachineLearning`은 **Data 360(Data Cloud)에 배포된 머신러닝 모델**에 Apex에서 **동기(synchronous)** 예측을 요청하는 클래스다. 단일 메서드 `predict`를 제공하며, 입력으로 모델 참조·설정·입력 데이터 타입을 담은 `CdpMlBasePredictInput`을 받아 `CdpMlPredictResult`를 반환한다.

입력 데이터 타입은 `CdpMlPredictTypeEnum`의 3가지 표현형으로 구분된다.

- **RawData** — Raw data (원시 데이터를 직접 전달)
- **Records** — Record IDs (레코드 ID로 참조)
- **RecordOverrides** — Record IDs with user-provided overrides (레코드 ID + 사용자 제공 오버라이드)

> ⚠️ 이 API는 예측형 AI 형제인 **Einstein Discovery의 `ConnectApi.SmartDataDiscovery.predict`와는 별개 계열**이다. Discovery는 Model Builder 기반 예측이고, 여기의 `CdpMachineLearning.predict`는 Data 360에 배포된 ML 모델을 대상으로 한다. 혼동에 주의한다 → [[Einstein Discovery — Model Builder·예측 모델]].

---

## CdpMachineLearning 클래스 · predict 메서드

원문 그대로의 실제 시그니처(검증된 코드):

```apex
public static ConnectApi.CdpMlPredictResult predict(ConnectApi.CdpMlBasePredictInput predict)
```

| 항목 | 값 |
|---|---|
| 파라미터 | `predict` — 타입 `ConnectApi.CdpMlBasePredictInput` |
| 반환 타입 | `ConnectApi.CdpMlPredictResult` |
| API Version | 59.0 |
| Requires Chatter | No |
| 실행 모드 | Synchronous(동기) |

> Apex Reference Guide v67.0 기준. 메서드 정의는 p.708.

---

## 입력 클래스

### CdpMlBasePredictInput

| Property | Type | Required/Optional | Description | Available Version |
|---|---|---|---|---|
| `model` | `ConnectApi.CdpAssetReferenceInput` | Required | A reference to the model to use to generate the prediction. | 59.0 |
| `settings` | `ConnectApi.CdpMlPredictSettingsInput` | Optional | The model configuration settings to use to generate the prediction. | 59.0 |
| `type` | `CdpMlPredictTypeEnum` | Required | Type of input data for the prediction. | 59.0 |

### CdpMlPredictSettingsInput

| Property | Type | Required/Optional | Description | Available Version |
|---|---|---|---|---|
| `aggregateFunctions` | `List<String>` | Optional | List of aggregate functions for the prediction. | 59.0 |
| `maxPrescriptions` | `Integer` | Optional | Maximum number of recommendations. The default value is -1 (unlimited) and the allowed range is -1 through 200. | 59.0 |
| `maxTopFactors` | `Integer` | Optional | Maximum number of top factors. The default value is 0 and the allowed range is 0 through 3. | 59.0 |
| `prescriptionImpactPercentage` | `Integer` | Optional | The minimum impact percentage of the prescriptions to return. Only prescriptions whose impact percentage is greater than or equal to the specified percentage are returned. The default value is 0 and the allowed range is 0 through 100. | 59.0 |

> 입력 클래스 정의는 p.2044–2045.

---

## 출력 클래스

### CdpMlPredictResult

| Property | Type | Description | Available Version |
|---|---|---|---|
| `aggregatePredictions` | `List<ConnectApi.CdpMlAggregatePrediction>` | List of aggregate results. | 59.0 |
| `model` | `ConnectApi.CdpAssetReference` | Model asset reference used as part of the prediction request. | 59.0 |
| `predictionType` | `CdpMlModelPredictionTypeEnum` | Type of the model prediction. | 59.0 |
| `predictions` | `List<ConnectApi.CdpMlPredictionBase>` | A list of prediction results. | 59.0 |
| `settings` | `ConnectApi.CdpMlPredictSettings` | Settings used for the prediction. | 59.0 |

### CdpMlPredictionBase

| Property | Type | Description | Available Version |
|---|---|---|---|
| `status` | `CdpMlPredictStatusEnum` | Status of the prediction. | 59.0 |

### CdpMlAggregatePrediction

| Property | Type | Description | Available Version |
|---|---|---|---|
| `factors` | `List<ConnectApi.CdpMlAggregatePredictCondition>` | Top factors associated with this aggregate prediction. | 59.0 |
| `prescriptions` | `List<ConnectApi.CdpMlAggregatePredictCondition>` | Prescriptions associated with this aggregate prediction. | 59.0 |
| `status` | `CdpMlPredictAggregateFunctionStatusEnum` | Status of the prediction aggregate function. | 59.0 |
| `type` | `CdpMlPredictAggregateFunctionTypeEnum` | Type of the prediction aggregate function. | 59.0 |
| `value` | `Double` | Value of the aggregate prediction. | 59.0 |

### CdpMlAggregatePredictCondition

가이드 원문 표에는 `count` 프로퍼티 하나만 정의돼 있다(클래스 설명은 "CDP machine-learning aggregate prediction contribution"이나 표에는 `count` 외 프로퍼티·상속 없음 — 추측 금지).

| Property | Type | Description | Available Version |
|---|---|---|---|
| `count` | `Integer` | Count of rows included in the aggregate condition. | 59.0 |

### CdpMlPredictSettings

| Property | Type | Description | Available Version |
|---|---|---|---|
| `aggregateFunctions` | `List<String>` | List of aggregate functions. | 59.0 |
| `maxPrescriptions` | `Integer` | Maximum number of recommendations. The default value is -1 (unlimited) and the allowed range is -1 through 200. | 59.0 |
| `maxTopFactors` | `Integer` | Maximum number of top factors. The default value is 0 and the allowed range is 0 through 3. | 59.0 |
| `prescriptionImpactPercentage` | `Integer` | Impact percentage of prescriptions. The default value is 0 and the range of values is 0 through 100. | 59.0 |

### CdpMlPredictionContributionBase

| Property | Type | Description | Available Version |
|---|---|---|---|
| `fields` | `List<ConnectApi.CdpMlPredictionContributionField>` | List of field and values that have the same contribution value | 59.0 |
| `value` | `Double` | Contribution value | 59.0 |

> **`CdpMlPredictionContributionField`**: 이 가이드에 **독립 클래스 정의가 없다**. `CdpMlPredictionContributionBase`의 `fields` 프로퍼티의 타입으로만 참조되며, 별도 프로퍼티 표가 존재하지 않는다(창작 금지).

> 출력 클래스 정의는 p.2276–2278.

---

## Enum 5종

| Enum | 값 | 설명 |
|---|---|---|
| `CdpMlModelPredictionTypeEnum`<br>(Type of the model prediction) | `BinaryClassification` | Binary classification. |
| | `Generic` | Generic/unknown. |
| | `MulticlassClassification` | Multiclass classification. |
| | `Regression` | Regression. |
| `CdpMlPredictAggregateFunctionStatusEnum`<br>(Status of the prediction aggregate function) | `Error` | (설명 없음) |
| | `Success` | (설명 없음) |
| `CdpMlPredictAggregateFunctionTypeEnum`<br>(Type of the prediction aggregate function) | `Average` | (설명 없음) |
| | `Median` | (설명 없음) |
| | `Sum` | (설명 없음) |
| `CdpMlPredictStatusEnum`<br>(Status of the prediction) | `Error` | (설명 없음) |
| | `Success` | (설명 없음) |
| `CdpMlPredictTypeEnum`<br>(Type of input data for the prediction) | `RawData` | Raw data. |
| | `RecordOverrides` | Record IDs with user-provided overrides. |
| | `Records` | Record IDs. |

> Enum 정의는 p.2649.

---

## 호출 흐름 (구조 예시)

가이드에 실제 예제가 없으므로 아래는 input 조립 → predict 호출 → result 소비의 골격만 보여주는 창작 예시다.

```apex
// 구조 예시 — 실제 동작 코드 아님
// input 조립 → predict 호출 → result 소비 골격
ConnectApi.CdpMlBasePredictInput input = new ConnectApi.CdpMlBasePredictInput();
input.model = new ConnectApi.CdpAssetReferenceInput();   // 모델 참조 (Required)
input.type = ConnectApi.CdpMlPredictTypeEnum.Records;    // 입력 데이터 타입 (Required)

ConnectApi.CdpMlPredictSettingsInput settings = new ConnectApi.CdpMlPredictSettingsInput();
settings.maxPrescriptions = 5;      // -1(unlimited) ~ 200
settings.maxTopFactors = 3;         // 0 ~ 3
input.settings = settings;          // Optional

ConnectApi.CdpMlPredictResult result = ConnectApi.CdpMachineLearning.predict(input);

for (ConnectApi.CdpMlPredictionBase prediction : result.predictions) {
    // prediction.status : CdpMlPredictStatusEnum (Success / Error)
    System.debug(prediction.status);
}

for (ConnectApi.CdpMlAggregatePrediction agg : result.aggregatePredictions) {
    // agg.type : Average / Median / Sum, agg.value : Double
    System.debug(agg.type + ' = ' + agg.value);
}
```

---

## 관련 노트
- [[ConnectApi Namespace 개요]] — 이 클래스가 속한 네임스페이스 허브
- [[Data Cloud 개요]] — Data 360 제품 맥락 (모델은 Data Cloud에서 배포)
- [[Einstein Discovery — Model Builder·예측 모델]] — 예측형 AI 형제(Discovery는 `ConnectApi.SmartDataDiscovery.predict` 별개 계열이라는 점 disambiguation)
