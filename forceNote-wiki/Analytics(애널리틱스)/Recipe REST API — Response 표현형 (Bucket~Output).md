---
tags: [analytics, crm-analytics, data-prep, recipe, rest-api, response-body]
source: salesforce_recipes_api.pdf (Data Prep Recipe REST API Developer Guide, Summer '26)
created: 2026-06-21
aliases: [Recipe REST API Response, Recipe response 표현형, Aggregate Response, Bucket Response, Output Data Cloud Parameters response, 레시피 응답 바디]
---

# Recipe REST API — Response 표현형 (Bucket~Output)

> Data Prep Recipe REST API(`/wave/recipes`) 응답 바디의 표현형(representation) 전반부 — Abstract Bucket Algorithm부터 Predict Values Setup까지 86개 표현형을 전수 정리한다. 각 표현형의 프로퍼티는 5열(Property Name · Type · Description · Filter Group and Version · Available Version)로 원문 그대로 옮긴다.

---

## 읽는 법 (섹션 머리 노트)

- **Response 표현형의 4번째 열은 "Filter Group and Version"** 이다(Request의 Required/Optional 열과 다름). 값은 보통 `Small, vNN.0` 또는 `Small, NN.0` 형태이며, 일부는 `Required`·`DEPRECATED: ...` 같은 예외 값이 들어간다. **원문 표기를 그대로 보존**한다(쉼표 유무·`v` 접두사 유무 포함).
- **Type 명은 코드(`code`)로만 표기**하며 위키링크가 아니다. 타입이 다른 표현형을 가리키는 경우에도 본 노트 또는 후속 노트의 동명 섹션을 의미한다.
- **상속(Inherits / Inherited by) 노트**는 각 표현형 설명에 그대로 보존한다.
- 원문의 [sic] 오타·표기 이상(예: `paramters`, `forumla`, `LoadAnalyticsDatatset`, 마침표 2개 등)은 **수정하지 않고 그대로 둔다**.
- enum 타입의 유효 값(valid values)이 표현형 표에 나열된 경우 그대로 옮긴다. `ConnectWaveDataConnectorTypeEnum`(39값)은 [[Recipe REST API — Enums]] 노트를 참조한다.

```jsonc
// 구조 예시 — 실제 동작 설정 아님
// Response 표현형이 응답 JSON에서 어떻게 중첩되는지(개념 예시)
{
  "nodeType": "AGGREGATE",
  "parameters": {              // Aggregate Parameters
    "aggregations": [          // Aggregate[]
      { "action": "Sum", "label": "Total", "name": "amt", "source": "amount" }
    ],
    "groupings": ["region"]
  }
}
```

---

## Abstract Bucket Algorithm

The base bucket algorithm for a recipe. **Inherited by** Typographic Cluster.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| type | `RecipeBucketAlgorithmType` | The algorithm type of the recipe bucket field. Valid values are: • TypographicClustering | Small, 52.0 | 52.0 |

## Aggregate

The aggregate data for a recipe node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| action | `RecipeAggregateType` | The recipe aggregation type. Valid values are: • Avg • Count • Maximum • Median • Minimum • StdDev • StdDevP • Sum • Unique • Var • VarP | Small, v51.0 | 51.0 |
| label | `String` | The label for the aggregate data. | Small, v51.0 | 51.0 |
| name | `String` | The name for the aggregate data. | Small, v51.0 | 51.0 |
| source | `String` | The source for the aggregate data. | Small, v51.0 | 51.0 |

## Aggregate Node

An aggregate data node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `AggregateParameters` | The parameters for the node. | Small, v51.0 | 51.0 |

## Aggregate Parameters

The parameters for an aggregate data node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| aggregations | `Aggregate[]` | The list of aggregations for the node. | Small, v51.0 | 51.0 |
| groupings | `String[]` | The list of groupings for the node. | Small, v51.0 | 51.0 |
| nodeType | `RecipeAggregateNodeEnum` | The aggregate type for the node. Valid values are: • Hierarchical • Standard | Small, v53.0 | 53.0 |
| parentField | `String` | The parent field for the node | Small, v53.0 | 53.0 |
| percentageField | `String` | The percentage field for the node | Small, v53.0 | 53.0 |
| pivot_v2 | `PivotV2[]` | The pivot v2 data for the node. | Small, v54.0 | 54.0 |
| pivots | `Pivot[]` | The list of pivots for the node. | Small, v51.0 | 51.0 |
| selfField | `String` | The self field for the node | Small, v53.0 | 53.0 |

## Append Mapping

A field mapping for an append node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| bottom | `String` | The bottom dataset field. | Small, v51.0 | 51.0 |
| top | `String` | The top dataset field. | Small, v51.0 | 51.0 |

## Append Node

An append node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `AppendParameters` | The parameters for the node. | Small, v51.0 | 51.0 |

## Append Parameters

The parameters for an append node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| allowImplicitDisjointSchema | `Boolean` | Indicates whether disjoint schema merge is allowed when automatically mapping fields (true) or not (false). | Small, v55.0 | 55.0 |
| fieldMappings | `AppendMapping[]` | The list of mappings for the node. | Small, v51.0 | 51.0 |

## AppendV2 Node

A version 2 append node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `AppendParameters` | The parameters for the node. | Small, v51.0 | 51.0 |

## Bucket Date Argument

A date bucket argument for a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| argument | `Long` | The date argument. | Small, 49.0 | 49.0 |
| type | `RecipeBucketGrain` | The recipe bucket date grain type. Valid values are: • AbsoluteDate • Days • FiscalQuarters • FiscalYears • Months • Quarters • Weeks • Years | Small, 49.0 | 49.0 |

## Bucket Date Bucket

A date bucket field for a recipe. **Inherits** Bucket.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| rangeEnd | `BucketDateArgument` | The date range end. | Small, 49.0 | 49.0 |
| rangeStart | `BucketDateArgument` | The date range start. | Small, 49.0 | 49.0 |

## Bucket Dimension Bucket

A dimension bucket field for a recipe. **Inherits** Bucket.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| sourceValues | `String[]` | The list of source values | Small, 49.0 | 49.0 |

## Bucket Field

A field for a bucket node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| bucketsSetup | `BucketSetup` | The bucket field property label. [sic] | Small, v49.0 | 49.0 |
| label | `String` | The bucket field property label. | Small, v49.0 | 49.0 |
| name | `String` | The bucket field property name. | Small, v49.0 | 49.0 |
| type | `RecipeDataType` | The recipe data type. Valid values are: • DateOnly • DateTime • Multivalue • Number • Text | Small, v49.0 | 49.0 |

> [sic] `bucketsSetup`의 설명이 `label`과 동일한 "The bucket field property label."로 표기됨 — 원문 그대로 보존.

## Bucket Measure Bucket

A date bucket field for a recipe. [sic — 측정(measure) 버킷이나 설명은 "date bucket field"] **Inherits** Bucket.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| rangeEnd | `Double` | The range end. | Small, 49.0 | 49.0 |
| rangeStart | `Double` | The range start. | Small, 49.0 | 49.0 |

## Bucket Node

A bucket node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `BucketParameters` | The parameters for the node. | Small, v49.0 | 49.0 |

## Bucket Parameters

The parameters for a bucket node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| fields | `BucketField[]` | The list of fields for the node. | Small, v49.0 | 49.0 |

## Bucket Setup

The setup for a bucket node field in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| algorithm | `AbstractBucketAlgorithm` | The bucketing algorithm. Valid values are: • TypographicCluster | Small, v52.0 | 52.0 |
| buckets | `Bucket` | The buckets. Valid values are: • BucketDateBucket • BucketDimensionBucket • BucketMeasureBucket | Small, v51.0 | 51.0 |
| defaultBucketValue | `String` | The default bucket value. | Small, v51.0 | 51.0 |
| isPassThroughEnabled | `Boolean` | Indicates whether pass through is enabled (true) or not (false). | Small, v51.0 | 51.0 |
| nullBucketValue | `String` | The null bucket value | Small, v51.0 | 51.0 |
| sourceField | `BucketSourceField` | The bucket source fields. | Small, v51.0 | 51.0 |

## Bucket Source Field

The source field for a bucket node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| name | `String` | The bucket source field name. | Small, 49.0 | 49.0 |
| type | `RecipeDataType` | The recipe data type. Valid values are: • DateOnly • DateTime • Multivalue • Number • Text | Small, v49.0 | 49.0 |

## Bucket V2

A version 2 bucket in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| booleanLogic | `String` | A boolean expression for the bucket. | Small 64.0 | 64.0 |
| terms | `BucketTerm[]` | The list of terms for the bucket. | Small 64.0 | 64.0 |
| value | `String` | The value for the bucket. | Small 64.0 | 64.0 |

> [sic] Filter Group and Version 열이 `Small 64.0`로, 다른 표현형과 달리 쉼표(`,`)가 없음 — 원문 그대로 보존.

## Bucket Term

A bucket term in a recipe node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| opType | `RecipeDataType` | The recipe node data type. Valid recipe data types are: • DateOnly • DateTime • Multivalue • Number • Text | Small, 64.0 | 64.0 |
| operands | `Map<Object, Object>` | A map of operands for the bucket term. | Small, 64.0 | 64.0 |
| operator | `String` | The operator for the bucket term. | Small, 64.0 | 64.0 |

## Bucket V2 Node

A version 2 bucket node in a recipe, with improved functionality. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `BucketV2Parameters` | The parameters for the V2 bucket node. | Small, 64.0 | 64.0 |

## Bucket V2 Parameters

A paramters [sic] for a version 2 bucket node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| algorithm | `AbstractBucketAlgorithm[]` | The bucket algorithm. Valid bucket algorithms are: • TypographicCluster | Small, 64.0 | 64.0 |
| buckets | `BucketV2[]` | A list of the buckets for the node. | Small, 64.0 | 64.0 |
| defaultBucket | `Object` | A default bucket for the node. | Small, 64.0 | 64.0 |
| multiValueResult | `boolean` | Indicates whether the bucket result is multi-value (true) or not (false). | Small, 64.0 | 64.0 |
| nullBucket | `Object` | A null bucket for the node. | Small, 64.0 | 64.0 |
| passthroughEnabled | `boolean` | Indicates whether pass through is enabled for the bucket (true) or not (false). | Small, 64.0 | 64.0 |
| sourceField | `String` | The source field for the bucket. | Small, 64.0 | 64.0 |
| targetField | `TargetField` | The target field for the bucket. | Small, 64.0 | 64.0 |

## Bucket

The base bucket for a recipe. **Inherited by** Bucket Date Bucket, Bucket Dimension Bucket, Bucket Measure Bucket.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| value | `String` | The bucket value. | Small, 49.0 | 49.0 |

## Cluster Node

A cluster node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `ClusterParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Cluster Parameters

The parameters for a cluster node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| clusterCount | `Integer` | The cluster count. | Small, v49.0 | 49.0 |
| findOptimalClusters | `Boolean` | Indicates whether to find the optimal clusters (true) or (not). | Small, v53.0 | 53.0 |
| produceScaledColumns | `Boolean` | Indicates whether to produce scaled columns (true) or (not). | Small, v53.0 | 53.0 |
| scaling | `MeasureScalingTypeEnum` | The scaling type. Valid values are: • MinMaxScaling | Small, v53.0 | 53.0 |
| sourceFields | `String[]` | The source fields. | Small, v51.0 | 51.0 |
| targetField | `RecipeNameLabel` | The target field. | Small, v51.0 | 51.0 |
| targetScaledFields | `RecipeNameLabel[]` | A list of target scaled fields. | Small, v53.0 | 53.0 |

> [sic] `findOptimalClusters`·`produceScaledColumns`의 설명이 "(true) or (not)" 형태 — 다른 항목의 "(true) or not (false)"와 달리 원문이 축약형. 원문 그대로 보존.

## Compute Relative Node

A compute relative node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `ComputeRelativeParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Compute Relative Parameters

The parameters for a compute relative node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| expressionType | `RecipeFormulaExpressionType` | The formula expression type. Valid values are: • Legacy • Sql | Small, v51.0 | 51.0 |
| fields | `SqlFormulaField[]` | The list of formula fields. Valid values are: • SQL Formula Date Field • SQL Formula Multivalue Field • SQL Formula Numeric Field • SQL Formula Text Field | Small, v51.0 | 51.0 |
| orderBy | `ComputeRelativeSortParameters[]` | The list of sort fields. | Small, v51.0 | 51.0 |
| partitionBy | `String[]` | The list of partition by values. | Small, v51.0 | 51.0 |

## Compute Relative Sort Parameters

The sort direction parameters for a compute relative node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| direction | `RecipeSortOrderEnum` | The sort direction. Valid values are: • Ascending • Descending | Small, v51.0 | 51.0 |
| fieldName | `String` | The field name. | Small, v51.0 | 51.0 |

## Data Object Category

The data object category for an Output Data Cloud node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| categoryName | `String` | The name of the data category. | Small, 60.0 | 60.0 |
| label | `String` | The label of the data category. | Small, 60.0 | 60.0 |

## Detect Sentiment Node

A detect sentiment node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `DetectSentimentParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Detect Sentiment Parameters

The parameters for a detect sentiment node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| outputType | `DetectSentimentOutputTypeEnum` | The output type. Valid values are: • Dimension • Measure | Small, v54.0 | 54.0 |
| sentimentScore | `SentimentScoreTypeEnum` | The sentiment score type. Valid values are: • All • Dimension • Measure • None | Small, v54.0 | 54.0 |
| sourceField | `String` | The source field. | Small, v51.0 | 51.0 |
| targetField | `RecipeNameLabel` | The target field. | Small, v51.0 | 51.0 |
| targetSentimentScoreFields | `Map<String, Map<String, RecipeNameLabel>>` | The collection of target confidence fields. | Small, v54.0 | 54.0 |

> [sic] `sentimentScore`의 유효 값이 Response 표에는 4값(All / Dimension / Measure / None)으로 표시됨 — [[Recipe REST API — Enums]]의 `SentimentScoreTypeEnum`은 All / None만 정의하나, 본 표현형 표의 원문 4값을 그대로 보존.

## Discovery Contributor

The discovery information for an Einstein Discovery prediction field.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| field | `RecipeNameLabel` | The discovery field. | Small, v51.0 | 51.0 |
| impact | `RecipeNameLabel` | The discovery impact. | Small, v51.0 | 51.0 |

## Discovery Node

An Einstein Discovery predict node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `DiscoveryParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Discovery Parameters

The parameters for an Einstein Discovery predict node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| columnMapping | `Map<String, String>` | The map of column mappings. | Small, v51.0 | 51.0 |
| multiClassFields | `DiscoveryContributor[]` | The list of multiclass fields. | Small, v56.0 | 56.0 |
| predictSource | `DiscoverySource` | The prediction source. | Small, v51.0 | 51.0 |
| predictionFactorFields | `DiscoveryContributor[]` | The list of prediction factor fields. | Small, v51.0 | 51.0 |
| predictionField | `RecipeNameLabel` | The prediction field. | Small, v51.0 | 51.0 |
| prescriptionFields | `DiscoveryContributor[]` | The list of prescription fields. | Small, v51.0 | 51.0 |

## Discovery Source

The discovery information for an Einstein Discovery source field.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| name | `String` | The name of the source. | Small, v51.0 | 51.0 |
| type | `String` | The type of source. | Small, v51.0 | 51.0 |

## Export Limits

The limits for an export node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| maxFileSizeInBytes | `Integer` | The maximum file size for the export partition. | Small, v51.0 | 51.0 |
| maxRowCount | `Integer` | The maximum row count for the export partition. | Small, v51.0 | 51.0 |

## Export Node

An export node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `ExportParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Export Parameters

The parameters for an export node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| csvHeaderRowValueType | `RecipeExportCsvHeaderRowValueType` | The type of the recipe export CSV header row value. Valid values are: • FullyQualifiedName • Label | Small, v53.0 | 53.0 |
| fields | `String[]` | The list of fields to select. | Small, v51.0 | 51.0 |
| format | `RecipeExportFormat` | The format of the export. Valid values are: • CSV. | Small, v51.0 | 51.0 |
| limitsPerPart | `ExportLimits` | The limits to export. | Small, v51.0 | 51.0 |
| userId | `String` | The user ID with access to the exported data. | Small, v51.0 | 51.0 |

## Extension Node

An extension node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `ExtensionParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Extension Parameters

The parameters for an extension node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| args | `Map<Object, Object>` | A map of extension arguments, defined by the extension definition | Small, v56.0 | 56.0 |
| name | `String` | The name of the extension. | Small, v56.0 | 56.0 |
| namespace | `String` | The namespace of the extension. | Small, v56.0 | 56.0 |
| version | `Double` | The version of the extension. | Small, v56.0 | 56.0 |

## Extract Field

An extract grain field.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| grainType | `RecipeDateGrain` | The extract grain type. Valid values are: • Day • DayEpoch • FiscalMonth • FiscalQuarter • FiscalWeek • FiscalYear • Hour • Minute • Month • Quarter • Second • SecondEpoch • Week • Year | Small, v51.0 | 51.0 |
| label | `String` | The extract field label. | Small, v51.0 | 51.0 |
| name | `String` | The extract field name. | Small, v51.0 | 51.0 |

## Extract Node

An extract grain node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `ExtractParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Extract Parameter

A parameter for an extract grain field.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| source | `String` | The source field. | Small, v51.0 | 51.0 |
| targets | `ExtractField[]` | The list of grain fields. | Small, v51.0 | 51.0 |

## Extract Parameters

The parameters for an extract grain node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| dateConfigurationName | `String` | The date configuration name. | Small, v55.0 | 55.0 |
| grainExtractions | `ExtractParameter[]` | The date fields to extract grains for. | Small, v51.0 | 51.0 |

## Filter Expression

A regex expression for a filter.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| field | `String` | The field to filter on. | Small, v51.0 | 51.0 |
| operands | `Object[]` | The list of operands. | Small, v51.0 | 51.0 |
| operator | `String` | The operator to use for the filter. | Small, v51.0 | 51.0 |
| type | `RecipeDataType` | The recipe data type. Valid values are: • DateOnly • DateTime • Multivalue • Number • Text | Small, v51.0 | 51.0 |

## Filter Node

A filter node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `FilterParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Filter Parameters

The parameters for a filter node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| filterBooleanLogic | `String` | The filter boolean logic. | Small, v52.0 | 52.0 |
| filterExpressions | `FilterExpression[]` | The list of filter expressions. | Small, v51.0 | 51.0 |

## Flatten Field

A field for a flatten node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| isSystemField | `Boolean` | Indicates whether the field is a system field (true) or not (false). | Small, v51.0 | 51.0 |
| label | `String` | The field label. | Small, v51.0 | 51.0 |
| name | `String` | The field name. | Small, v51.0 | 51.0 |

## Flatten Node

A flatten node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `FlattenParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Flatten Parameters

The parameters for a flatten node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| includeSelfId | `Boolean` | Indicates whether to include the self-ID (true) or not (false).. [sic] | Small, v51.0 | 51.0 |
| multiField | `FlattenField` | The multi field. | Small, v51.0 | 51.0 |
| parentField | `String` | The parent field. | Small, v51.0 | 51.0 |
| pathField | `FlattenField` | The path field. | Small, v51.0 | 51.0 |
| selfField | `String` | The self-field. | Small, v51.0 | 51.0 |

> [sic] `includeSelfId` 설명 끝에 마침표가 2개("(false)..") — 원문 그대로 보존.

## Format Date Node

A date format conversion node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `FormatDateParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Format Date Parameters

The parameters for a date format conversion node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| sourceField | `String` | The source field. | Small, v51.0 | 51.0 |
| sourceFormats | `FormatDatePattern[]` | The list of source date formats. | Small, v51.0 | 51.0 |
| targetField | `RecipeNameLabel` | The target field. | Small, v51.0 | 51.0 |
| targetFormat | `FormatDatePattern` | The target date format. | Small, v51.0 | 51.0 |

## Format Date Pattern

The pattern for a date format conversion.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| construction | `String[]` | A list of values for the construction of the date format. | Small, v51.0 | 51.0 |
| groups | `String[]` | The list of date format groups. | Small, v51.0 | 51.0 |
| regex | `String` | The regular expression for the date format. | Small, v51.0 | 51.0 |

## Formula Node

A formula node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `FormulaParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Formula Parameters

The parameters for a formula node in a recipe. **Inherited by** LegacyFormulaParameters and SqlFormulaParameters.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| expressionType | `RecipeFormulaExpressionType` | The forumla [sic] expression type. Valid values are: • Legacy • Sql | Small, v51.0 | 51.0 |

> [sic] 설명에 `forumla`(formula 오타) — 원문 그대로 보존.

## Join Node

A join node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `JoinParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Join Parameters

The parameters for a join node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| joinType | `RecipeJoinType` | The join type. Valid values are: • Cross • Inner • LeftOuter • Lookup • MultiValueLookup • Outer • RightOuter | Small, v51.0 | 51.0 |
| leftKeys | `String[]` | The list of left keys. | Small, v51.0 | 51.0 |
| leftQualifier | `String` | The left qualifier. | Small, v51.0 | 51.0 |
| rightKeys | `String[]` | The list of right keys. | Small, v51.0 | 51.0 |
| rightQualifier | `String` | The right qualifier. | Small, v51.0 | 51.0 |

## Load Analytics Dataset

A CRM Analytics dataset for a load node in a recipe. **Inherits** Load Dataset.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| name | `String` | The dataset name. | Small, v51.0 | 51.0 |

## Load Connected Dataset

A connected dataset for a load node in a recipe. **Inherits** Load Dataset.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| connectionName | `String` | The name of the connection. | Small, v51.0 | 51.0 |
| filter | `FilterParameters` | The pushdown filter. | Small, v52.0 | 52.0 |
| mode | `ConnectedModeEnum` | The mode for accessing connected datasets. Valid values are: • AUTO • DIRECT • SYNCED | Small, v65.0 | 65.0 |
| sourceObjectName | `String` | The name of the source object. | Small, v51.0 | 51.0 |

## Load Data Lake Object

A data lake object for a load node in a recipe. **Inherits** Load Dataset.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| name | `String` | The data lake object name. | Small, v56.0 | 56.0 |

## Load Data Model Object

A data model object for a load node in a recipe. **Inherits** Load Dataset.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| name | `String` | The data model object name. | Small, 57.0 | 57.0 |

## Load Dataset

The base dataset for a load node in a recipe. **Inherited by** Load Analytics Dataset, Load Connected Dataset, Load Data Lake Object, Load Data Model Object.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| label | `String` | The dataset label. | Small, v51.0 | 51.0 |
| type | `RecipeDatasetType` | The type of the dataset. Valid values are: • Analytics • Connected • DataLakeObject • DataModelObject | Small, v51.0 | 51.0 |

## Load Node

A load node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `LoadParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Load Parameters

The parameters for a load node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| dataset | `LoadDataset` | The dataset to load. Valid values are: • Load Analytics Dataset • Load Connected Dataset • Load Data Lake Object • Load Data Model Object | Small, v51.0 | 51.0 |
| fields | `String[]` | The list of fields to load. | Small, v51.0 | 51.0 |
| preserveCurrencyFields | `String[]` | The list of fields to preserve currency for. | Small, v65.0 | 65.0 |
| purgeCache | `Boolean` | Indicates whether to purge the cache (true) or not (false). | Small, v57.0 | 57.0 |
| runMode | `InputRunModeEnum` | The input run mode. Valid values are: • Full • Incremental • Streaming | Small, v57.0 | 57.0 |
| sampleDetails | `SampleParameters` | The sample parameters for the dataset load. | Small, v55.0 | 55.0 |
| sampleSize | `Integer` | The number of rows to load. | Small, v51.0 | 51.0 |

## Legacy Formula Field

A legacy formula field for a formula. **Inherits** Formula Parameters.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| formulaExpression | `String` | The formula expression. | Small, 51.0 | 51.0 |
| label | `String` | The field label. | Small, 51.0 | 51.0 |
| name | `String` | The field name. | Small, 51.0 | 51.0 |

## Legacy Formula Parameters

The legacy formula parameters for a formula. **Inherits** Formula Parameters.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| fields | `LegacyFormulaField[]` | The list of fields. | Required [sic] | 51.0 |

> [sic] 이 Response 표현형의 4번째 열 값이 다른 표현형과 달리 `Required`로 표기됨(보통 `Small, ...`) — 원문 그대로 보존.

## Measure To Currency

The conversion information for currency measure field.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| conversionRateDateField | `String` | The conversion rate date field. | Small, v56.0 | 56.0 |
| measureField | `String` | The measure field. | Small, v56.0 | 56.0 |

## Optimized Append Node

An optimized append node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `OptimizedAppendParameters` | The parameters for the node. | Small, 62.0 | 62.0 |

## Optimized Append Parameters

The parameters for an optimized append node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| allowImplicitDisjointSchema | `Boolean` | Indicates whether disjoint schema merge is allowed (true) or not (false). | Small, 62.0 | 62.0 |
| dataset | `LoadAnalyticsDatatset` | The base dataset to append. | Small, 62.0 | 62.0 |
| dateConfigurationName | `String` | The name of the date configuration. | Small, 62.0 | 62.0 |

> [sic] `dataset`의 Type이 `LoadAnalyticsDatatset`(LoadAnalyticsDataset 오타) — 원문 그대로 보존.

## Optimized Update Node

An optimized update node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `OptimizedUpdateParameters` | The parameters for the node. | Small, 64.0 | 64.0 |

## Optimized Update Parameters

The parameters for an optimized update node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| allowImplicitDisjointSchema | `Boolean` | Indicates whether disjoint schema merge is allowed (true) or not (false). | Small, 64.0 | 64.0 |
| dataset | `LoadAnalyticsDatatset` | The base dataset to update. | Small, 64.0 | 64.0 |
| dateConfigurationName | `String` | The name of the date configuration. | Small, 64.0 | 64.0 |
| operation | `OperationEnum` | The update operation type. Valid operation types are: • Append • Delete • Upsert | Small, 64.0 | 64.0 |
| primaryKey | `String` | The name of the primary key field. | Small, 67.0 | 67.0 |

> [sic] `dataset`의 Type이 `LoadAnalyticsDatatset`(LoadAnalyticsDataset 오타) — 원문 그대로 보존.

## Output D360 Fields Mapping

The fields mapping for an output D360 node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| sourceField | `String` | The name of the source field. | Small, v56.0 | 56.0 |
| targetField | `String` | The name of the target field. | Small, v56.0 | 56.0 |

## Output D360 Node

An output D360 node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `OutputD360Parameters` | The parameters for the node. | Small, 56.0 | 56.0 |

## Output D360 Parameters

The parameters for an output D360 node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| fieldsMapping | `OutputD360FieldsMapping[]` | The list of field mappings. | Small, v56.0 | 56.0 |
| name | `String` | The name of the D360 object. | Small, v56.0 | 56.0 |
| streaming | `StreamingParameters[]` | The streaming parameters. | Small, v57.0 | 57.0 |
| type | `RecipeD360OutputType` | The output type. Valid values are: • DateLakeObject | Small, v56.0 | 56.0 |

> [sic] `type`의 유효 값이 `DateLakeObject`(DataLakeObject 오타) — 원문 그대로 보존.

## Output Data Cloud Fields Mapping

The fields mapping for an output Data 360 node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| dataType | `RecipeDataType` | The data type of the target field. Valid values are: • DateOnly • DateTime • Multivalue • Number • Text | Small, v60.0 | 60.0 |
| sourceField | `String` | The name of the source field. | Small, v56.0 | 56.0 |
| targetField | `String` | The name of the target field. | Small, v56.0 | 56.0 |

## Output Data Cloud Node

An output node in a recipe to write to Data 360. **Inherits** Recipe Node.

> **리브랜딩 노트 (원문):** *"As of October 14, 2025, Data Cloud has been rebranded to Data 360..."* — Data Cloud가 Data 360으로 리브랜딩됨. 표현형 명칭은 `Output Data Cloud Node`로 유지되나 설명·프로퍼티는 Data 360 용어를 사용한다.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `OutputDataCloudParameters` | The parameters for the node. | Small, 60.0 | 60.0 |

## Output Data Cloud Parameters

The parameters for an output Data 360 node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| category | `DataObjectCategory` | The data category for the data lake object (DLO). | Small, v60.0 | 60.0 |
| connectorType | `ConnectWaveDataConnectorTypeEnum` | The connector type. Valid values are: (39값 — [[Recipe REST API — Enums]] 노트 참조) | Small, v62.0 | 62.0 |
| dataspace | `AssetReference` | The dataspace to use in Data 360. | Small, v60.0 | DEPRECATED: min 60.0, max 64.0 |
| dataspaces | `AssetReference[]` | A list of dataspaces to use in Data 360. | Small, v65.0 | 65.0 |
| dmoName | `String` | The name of the data model object (DMO). | Small, v67.0 | 67.0 |
| eventTimeField | `String` | The event time field. | Small, v66.0 | 66.0 |
| fieldsMapping | `OutputDataCloudFieldsMapping[]` | The list of field mappings. | Small, v60.0 | 60.0 |
| label | `String` | The label of the Data 360 object. | Small, v62.0 | 62.0 |
| name | `String` | The name of the Data 360 object. | Small, v60.0 | 60.0 |
| primaryKey | `String` | The name of the primary key field for the Data 360 object. | Small, v60.0 | 60.0 |
| type | `RecipeDataCloudOutputTypeEnum` | The output type. Valid values are: • DataLakeObject • DataModelObject | Small, v60.0 | 60.0 |

> [sic] `dataspace`의 Available Version 열이 `DEPRECATED: min 60.0, max 64.0`로 표기됨 — 원문 그대로 보존. `connectorType`의 39개 유효 값은 [[Recipe REST API — Enums]]의 `ConnectWaveDataConnectorTypeEnum` 참조.

## Output External Field Mapping

A field mapping for an output external node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| sourceField | `String` | The name of the source field. | Small, v51.0 | 51.0 |
| targetField | `String` | The name of the target field. | Small, v51.0 | 51.0 |

## Output External Node

An output external node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `OutputExternalParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Output External Parameters

The parameters for an output external node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| connectionName | `String` | The connection name. | Small, v51.0 | 51.0 |
| externalIdFieldName | `String` | The field name for the external ID. | Small, v51.0 | 51.0 |
| fieldsMapping | `OutputExternalFieldMapping[]` | The list of field mappings. | Small, v51.0 | 51.0 |
| hyperFileName | `String` | The name of hyper file. | Small, v54.0 | 54.0 |
| object | `String` | The object name. | Small, v51.0 | 51.0 |
| operation | `RecipeOutputExternalOperation` | The output external operation type. Valid values are: • Empty • Insert • Update • Upsert | Small, v51.0 | 51.0 |
| namedCredential | `Map<String,String>` | A map of key/value pairs of a named credential for a virtual private connection (VPC). | Small, v65.0 | 65.0 |

## Pivot

A pivot for an aggregate data node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| source | `String` | The source for the pivot. | Small, v51.0 | 51.0 |
| values | `String[]` | The list of values for the pivot. | Small, v51.0 | 51.0 |

## PivotV2

A version 2 pivot for an aggregate data node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| pivotFieldsInfo | `Map<RecipeNameLabel, List` | The map of the pivot fields information. | Small, v54.0 | 54.0 |
| sourceFields | `String[]` | The list of source fields for the pivot. | Small, v54.0 | 54.0 |
| valueCombinations | `String[]` | The list of value combinations for the pivot. | Small, v54.0 | 54.0 |

> [sic] `pivotFieldsInfo`의 Type이 `Map<RecipeNameLabel, List`로 닫힘 괄호(`>`)가 누락됨 — 원문 그대로 보존.

## Predict Values Field

A field for a predict values node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| label | `String` | The label for the field. | Small, v51.0 | 51.0 |
| name | `String` | The name for the field. | Small, v51.0 | 51.0 |
| predictionSetup | `PredictValuesSetup[]` | The setup for the predict field. | Small, v51.0 | 51.0 |

## Predict Values Input Field

An input field for a predict values node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| name | `String` | The field name. | Small, v51.0 | 51.0 |

## Predict Values Node

A predict missing values node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `PredictValuesParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Predict Values Parameters

The parameters for a predict values node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| fields | `PredictValuesField[]` | The list of fields. | Small, v51.0 | 51.0 |

## Predict Values Setup

The setup for a predict values node field.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| modelInputFields | `PredictValuesInputField[]` | The list of input fields for the model. | Small, v51.0 | 51.0 |
| sourceField | `PredictValuesInputField` | The source field. | Small, v51.0 | 51.0 |

---

## 관련 노트

- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]]
- [[Recipe REST API — Response 표현형 (Recipe~Update)]] — Recipe~Update 범위 Response 표현형 (자매 노트)
- [[Recipe REST API — Bucket·Cluster 노드 Input]] — 이 응답 표현형의 요청 측 노드 Input (Input ↔ Response 짝)
- [[Recipe REST API — Enums]]
