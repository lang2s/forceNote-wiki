---
tags: [analytics, crm-analytics, data-prep, recipe, rest-api, request-body, bucket]
source: salesforce_recipes_api.pdf (Data Prep Recipe REST API Developer Guide, Summer '26)
created: 2026-06-21
aliases: [Bucket Node Input, Bucket V2, Cluster Parameters, Typographic Cluster, 레시피 버킷 노드, 클러스터 노드]
---

# Recipe REST API — Bucket·Cluster 노드 Input

> Data Prep Recipe REST API 요청 본문에서 버킷(bucket)·V2 버킷·클러스터(cluster) 노드를 정의하는 26개 Input 표현형의 프로퍼티 전수 레퍼런스.

---

이 노트는 Data Prep Recipe REST API의 **버킷·클러스터 계열 Input 표현형 26종**을 다룬다. 버킷 노드는 소스 필드 값을 사용자 정의 그룹(버킷)으로 묶는 변환이고, 클러스터 노드는 머신러닝 기반 클러스터링을 수행한다. 각 노드(`BucketNodeInput`·`BucketV2NodeInput`·`ClusterNodeInput`)는 [[Recipe REST API — Recipe 구성 Input]]의 `RecipeNodeInput`을 상속한다.

- 각 표 5열: **Property Name / Type / Description / Required or Optional / Available Version**.
- Type명은 코드 표기(`Type`)로 두며 위키링크가 아니다. enum의 valid values는 [[Recipe REST API — Enums]] 참조.
- 일부 이름/설명은 원문 그대로 보존했다(`[sic]` 표시): `paramters`·`AbstractBucketAlgorithmtInput`·"bucket node"·"(true) or (not)".

```jsonc
// 구조 예시 — 실제 동작 설정 아님. 버킷 노드 요청 본문의 대략적 형태
{
  "nodeType": "BucketNode",
  "parameters": {
    "fields": [
      {
        "name": "AmountBucket",
        "label": "Amount Bucket",
        "bucketsSetup": {
          "sourceField": { "name": "Amount", "type": "Number" },
          "defaultBucketValue": "Other",
          "nullBucketValue": "Unknown",
          "isPassThroughEnabled": true,
          "buckets": [
            { "value": "Low",  "rangeStart": 0,    "rangeEnd": 1000 },
            { "value": "High", "rangeStart": 1000, "rangeEnd": 100000 }
          ]
        }
      }
    ]
  }
}
```

---

## 1. Abstract Bucket Algorithm Input

The base bucket algorithm for a recipe.

> 상속: Inherited by **Typographic Cluster Input**.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| type | `RecipeBucketAlgorithmType` | The algorithm type of the recipe bucket field. Valid values are: • `TypographicClustering` | Required | 52.0 |

---

## 2. Bucket Date Argument Input

The argument for a bucket node date field in a recipe.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| argument | `Long` | The date argument. | Required | 51.0 |
| type | `RecipeBucketGrain` | The bucket grain for the field. Valid values are: • `AbsoluteDate` • `Days` • `FiscalQuarters` • `FiscalYears` • `Months` • `Quarters` • `Weeks` • `Years` | Required | 51.0 |

---

## 3. Bucket Date Bucket Input

A bucket for a bucket node date field in a recipe.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| rangeEnd | `BucketDateArgumentInput` | The date range end. | Required | 51.0 |
| rangeStart | `BucketDateArgumentInput` | The date range start. | Required | 51.0 |
| value | `String` | The date value. | Required | 51.0 |

---

## 4. Bucket Date Only Field Input

A date only field for a bucket node in a recipe.

> 상속: Inherits properties from **Bucket Field Input** (`label`, `name`).

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| bucketsSetup | `BucketDateSetupInput` | The setup for the date bucket. | Required | 51.0 |

---

## 5. Bucket Date Setup Input

The date setup for a bucket node in a recipe.

> 상속: Inherits properties from **Bucket Setup Input** (`algorithm`, `defaultBucketValue`, `isPassThroughEnabled`, `nullBucketValue`).

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| buckets | `BucketDateBucketInput[]` | The list of buckets. | Required | 51.0 |
| sourceField | `BucketDateSourceFieldInput` | The source field. | Required | 51.0 |

---

## 6. Bucket Date Source Field Input

A date source field for a bucket node in a recipe.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| name | `String` | The name of the field. | Required | 51.0 |
| type | `RecipeDataType` | The recipe data type. Valid values are: • `DateOnly` • `DateTime` • `Multivalue` • `Number` • `Text` | Required | 51.0 |

---

## 7. Bucket Date Time Field Input

A date time field for a bucket node in a recipe.

> 상속: Inherits properties from **Bucket Field Input** (`label`, `name`).

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| bucketsSetup | `BucketDateSetupInput` | The setup for the date bucket. | Required | 51.0 |

---

## 8. Bucket Dimension Bucket Input

A bucket for a bucket node dimension field in a recipe.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| sourceValues | `String[]` | The list of source values. | Required | 51.0 |
| value | `String` | The dimension value. | Required | 51.0 |

---

## 9. Bucket Dimension Field Input

A dimension field for a bucket node in a recipe.

> 상속: Inherits properties from **Bucket Field Input** (`label`, `name`).

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| bucketsSetup | `BucketDimensionSetupInput` | The setup for a dimension field. | Required | 51.0 |

---

## 10. Bucket Dimension Setup Input

The dimension field setup for a bucket node in a recipe.

> 상속: Inherits properties from **Bucket Setup Input** (`algorithm`, `defaultBucketValue`, `isPassThroughEnabled`, `nullBucketValue`).

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| buckets | `BucketDimensionBucketInput[]` | The list of buckets. | Required | 51.0 |
| sourceField | `BucketDimensionSourceFieldInput` | The source field. | Required | 51.0 |

---

## 11. Bucket Dimension Source Field Input

A dimension source field for a bucket node in a recipe.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| name | `String` | The name of the field. | Required | 51.0 |
| type | `RecipeDataType` | The recipe data type. Valid values are: • `DateOnly` • `DateTime` • `Multivalue` • `Number` • `Text` | Required | 51.0 |

---

## 12. Bucket Field Input

A field for a bucket node in a recipe.

> 상속: Inherited by **Bucket Date Only Field Input**, **Bucket Date Time Field Input**, **Bucket Dimension Field Input**, and **Bucket Measure Field Input**.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| label | `String` | The bucket field property label. | Required | 51.0 |
| name | `String` | The bucket field property name. | Required | 51.0 |

---

## 13. Bucket Measure Bucket Input

A bucket for a bucket node measure field in a recipe.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| rangeEnd | `Double` | The range end. | Required | 51.0 |
| rangeStart | `Double` | The range start. | Required | 51.0 |
| value | `String` | The measure value. | Required | 51.0 |

---

## 14. Bucket Measure Field Input

A measure field for a bucket node in a recipe.

> 상속: Inherits properties from **Bucket Field Input** (`label`, `name`).

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| bucketsSetup | `BucketMeasureSetupInput` | The setup for a measure field. | Required | 51.0 |

---

## 15. Bucket Measure Setup Input

The measure field setup for a bucket node in a recipe.

> 상속: Inherits properties from **Bucket Setup Input** (`algorithm`, `defaultBucketValue`, `isPassThroughEnabled`, `nullBucketValue`).

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| buckets | `BucketMeasureBucketInput[]` | The list of buckets. | Required | 51.0 |
| sourceField | `BucketMeasureSourceFieldInput` | The source field. | Required | 51.0 |

---

## 16. Bucket Measure Source Field Input

A measure source field for a bucket node in a recipe.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| name | `String` | The name of the field. | Required | 51.0 |
| type | `RecipeDataType` | The recipe data type. Valid values are: • `DateOnly` • `DateTime` • `Multivalue` • `Number` • `Text` | Required | 51.0 |

---

## 17. Bucket Node Input

A bucket node in a recipe.

> 상속: Inherits properties from **Recipe Node Input** ([[Recipe REST API — Recipe 구성 Input]]).

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `BucketParametersInput` | The parameters for the bucket node. | Required | 51.0 |

---

## 18. Bucket Parameters

The parameters for a bucket node in a recipe.

> 참고: 원문 제목에 "Input" 접미사가 없다 (`Bucket Parameters`).

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| fields | `BucketFieldInput[]` | The list of fields for the node. Valid bucket fields are: • `BucketDateOnlyFieldInput` • `BucketDateTimeFieldInput` • `BucketDimensionFieldInput` • `BucketMeasureFieldInput` | Required | 51.0 |

---

## 19. Bucket Setup Input

The base field setup for a bucket node in a recipe.

> 상속: Inherited by **Bucket Date Setup Input**, **Bucket Dimension Setup Input**, and **Bucket Measure Setup Input**.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| algorithm | `AbstractBucketAlgorithmInput` | The bucketing algorithm. Valid values are: • `TypographicClusterInput` | Required | 52.0 |
| defaultBucketValue | `String` | The default bucket value. | Required | 51.0 |
| isPassThroughEnabled | `Boolean` | Indicates whether pass through is enabled (true) or not (false). | Required | 51.0 |
| nullBucketValue | `String` | The null bucket value | Required [sic — PDF에 R/O 셀이 분산되어 표시됨, Required로 보정] | 51.0 |

---

## 20. Bucket Term Input

A bucket term in a recipe node.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| opType | `RecipeDataType` | The recipe node data type. Valid recipe data types are: • `DateOnly` • `DateTime` • `Multivalue` • `Number` • `Text` | Required | 64.0 |
| operands | `Map<Object, Object>` | A map of operands for the bucket term. | Required | 64.0 |
| operator | `String` | The operator for the bucket term. | Required | 64.0 |

---

## 21. Bucket V2 Input

A version 2 bucket in a recipe.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| booleanLogic | `String` | A boolean expression for the bucket. | Optional | 64.0 |
| terms | `BucketTermInput[]` | The list of terms for the bucket. | Optional | 64.0 |
| value | `String` | The value for the bucket. | Required | 64.0 |

---

## 22. Bucket V2 Node Input

A version 2 bucket node in a recipe, with improved functionality.

> 상속: Inherits properties from **Recipe Node Input** ([[Recipe REST API — Recipe 구성 Input]]).

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `BucketV2ParametersInput` | The parameters for the V2 bucket node. | Required | 64.0 |

---

## 23. Bucket V2 Parameters Input

A paramters [sic — 원문 오타] for a version 2 bucket node in a recipe.

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| algorithm | `AbstractBucketAlgorithmInput[]` | The bucket algorithm. Valid bucket algorithms are: • `TypographicClusterInput` | Required | 64.0 |
| buckets | `BucketV2Input[]` | A list of the buckets for the node. | Required | 64.0 |
| defaultBucket | `Object` | A default bucket for the node. | Required | 64.0 |
| multiValueResult | `boolean` | Indicates whether the bucket result is multi-value (true) or not (false). | Optional | 64.0 |
| nullBucket | `Object` | A null bucket for the node. | Optional | 64.0 |
| passthroughEnabled | `boolean` | Indicates whether pass through is enabled for the bucket (true) or not (false). | Optional | 64.0 |
| sourceField | `String` | The source field for the bucket. | Required | 64.0 |
| targetField | `TargetFieldInput` | The target field for the bucket. | Required | 64.0 |

---

## 24. Cluster Node Input

A cluster node in a recipe.

> 상속: Inherits properties from **Recipe Node Input** ([[Recipe REST API — Recipe 구성 Input]]).

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `ClusterParametersInput` | The parameters for the bucket node. [sic — 원문 "bucket" 그대로] | Required | 51.0 |

---

## 25. Cluster Parameters

The parameters for a cluster node in a recipe.

> 참고: 원문 제목에 "Input" 접미사가 없다 (`Cluster Parameters`).

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| clusterCount | `Integer` | The cluster count. | Required | 51.0 |
| findOptimalClusters | `Boolean` | Indicates whether to find the optimal clusters (true) or (not). [sic] | Required | 53.0 |
| produceScaledColumns | `Boolean` | Indicates whether to produce scaled columns (true) or (not). [sic] | Required | 53.0 |
| scaling | `MeasureScalingTypeEnum` | The scaling type. Valid values are: • `MinMaxScaling` | Required | 53.0 |
| sourceFields | `String[]` | The source fields. | Required | 51.0 |
| targetField | `RecipeNameLabelInput` | The target field. | Required | 51.0 |
| targetScaledFields | `RecipeNameLabelInput[]` | A list of target scaled fields. | Required | 53.0 |

---

## 26. Typographic Cluster Input

The configuration for a typographic cluster algorithm.

> 상속: Inherits properties from **AbstractBucketAlgorithmtInput** [sic — 원문 오타].

| Property Name | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| distanceThreshold | `Integer` | The edit distance | Required | 52.0 |
| ignoreCase | `Boolean` | Indicates whether to ignore case (true) or not (false). | Required | 52.0 |

---

## 상속 관계 요약

```
// 구조 예시 — 실제 원본 다이어그램 아님. PDF의 상속 노트(Inherits/Inherited by)에서 재구성
AbstractBucketAlgorithmInput
  └─ inherited by → Typographic Cluster Input

Bucket Field Input
  └─ inherited by → Bucket Date Only / Date Time / Dimension / Measure Field Input

Bucket Setup Input
  └─ inherited by → Bucket Date / Dimension / Measure Setup Input

Recipe Node Input (→ Recipe REST API — Recipe 구성 Input)
  └─ inherited by → Bucket Node Input / Bucket V2 Node Input / Cluster Node Input
```

---

## 관련 노트
- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]]
- [[Recipe REST API — Recipe 구성 Input]]
- [[Recipe REST API — Enums]]
- [[Recipe REST API — Response 표현형 (Bucket~Output)]] — 이 노드들의 응답 측 표현형 (Input ↔ Response 짝)
