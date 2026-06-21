---
tags: [analytics, crm-analytics, data-prep, recipe, rest-api, request-body, schema]
source: salesforce_recipes_api.pdf (Data Prep Recipe REST API Developer Guide, Summer '26)
created: 2026-06-21
aliases: [Filter Node Input, Schema Field Type Properties Input, Extract Grain Node Input, Sample Parameters Input, 레시피 필터 스키마 노드]
---

# Recipe REST API — Filter·Flatten·Extract·Schema Input

> Data Prep Recipe REST API의 변환 노드 계열 request body 표현형(23종) — Filter·SQL Filter·Flatten·Extract Grain·Schema 노드와 그 파라미터/필드 Input, 그리고 데이터 로딩용 Sample·Streaming 파라미터를 전수 정리한다.

---

이 노트는 레시피의 **변환/스키마/필터 노드 계열** Input 표현형을 다룬다. 각 표현형은 5열(Property·Type·Description·Required/Optional·Version)로 작성했고, enum 타입은 표현형마다 모든 값을 명시한다(요약 없음). `*Node Input`으로 끝나는 표현형은 **Recipe Node Input을 상속**하며, 상속받은 공통 프로퍼티는 [[Recipe REST API — Recipe 구성 Input]]을 참조한다. enum 타입의 정의는 [[Recipe REST API — Enums]]를 참조한다.

> [!note] 원문 표기 보존
> 아래 표현형 중 일부는 PDF 원문의 표기를 그대로(`[sic]`) 보존했다.
> - **Data Object Category Input**: 4번째 열 헤더가 원문에서 `Filter Group and Version`로 표기됨(문서 헤더 재사용으로 보이는 오류). 실제 값은 Required.
> - **Schema Parameters Input**: `fields`의 Type이 `SchemaFieldParametersInputRepresentation[]`로 표기됨(`Representation` 접미사가 원문 그대로).
> - **Target Field Input**: `type` 설명이 다른 표현형의 `Valid values are:`와 달리 `Valid recipe data types are:`로 표기됨.

---

## Filter 계열

### Filter Node Input
A filter node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `parameters` | `FilterParametersInput` | The parameters for the node. | Required | 51.0 |

### Filter Parameters Input
The parameters for a filter node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `filterBooleanLogic` | `String` | The filter boolean logic. | Optional | 52.0 |
| `filterExpressions` | `FilterExpressionInput[]` | The list of filter expressions. | Required | 51.0 |

### Filter Expression Input
A regex expression for a filter.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `field` | `String` | The field to filter on. | Required | 51.0 |
| `operands` | `Object[]` | The list of operands. | Required | 51.0 |
| `operator` | `String` | The operator to use for the filter. | Required | 51.0 |
| `type` | `RecipeDataType` | The recipe data type. Valid values are: • DateOnly • DateTime • Multivalue • Number • Text | Required | 51.0 |

### SQL Filter Node Input
A SQL filter node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `parameters` | `SQLFilterParametersInput` | The parameters for the node. | Required | 53.0 |

### SQL Filter Parameters Input
The parameters for a SQL filter node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `sqlFilterExpression` | `String` | The SQL filter expression. | Required | 53.0 |

---

## Flatten 계열

### Flatten Node Input
A flatten node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `parameters` | `FlattenParametersInput` | The parameters for the node. | Required | 51.0 |

### Flatten Parameters Input
The parameters for a flatten node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `includeSelfId` | `Boolean` | Indicates whether to include the self-ID (true) or not (false). | Required | 51.0 |
| `multiField` | `FlattenFieldInput` | The multi field. | Required | 51.0 |
| `parentField` | `String` | The parent field. | Required | 51.0 |
| `pathField` | `FlattenFieldInput` | The path field. | Required | 51.0 |
| `selfField` | `String` | The self-field. | Required | 51.0 |

### Flatten Field Input
A field for a flatten node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `isSystemField` | `Boolean` | Indicates whether the field is a system field (true) or not (false). | Required | 51.0 |
| `label` | `String` | The field label. | Required | 51.0 |
| `name` | `String` | The field name. | Required | 51.0 |

---

## Extract Grain 계열

### Extract Grain Node Input
An extract grain node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `parameters` | `ExtractGrainParametersInput` | The parameters for the node. | Required | 51.0 |

### Extract Grain Parameters Input
The parameters for an extract grain node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `dateConfigurationName` | `String` | The date configuration name. | Required | 55.0 |
| `grainExtractions` | `ExtractGrainParameterInput[]` | The date fields to extract grains for. | Required | 51.0 |

### Extract Grain Parameter Input
A parameter for an extract grain field.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `source` | `String` | The source field. | Required | 51.0 |
| `targets` | `ExtractGrainFieldInput[]` | The list of grain fields. | Required | 51.0 |

### Extract Grain Field Input
An extract grain field.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `grainType` | `RecipeDateGrain` | The extract grain type. Valid values are: • Day • DayEpoch • FiscalMonth • FiscalQuarter • FiscalWeek • FiscalYear • Hour • Minute • Month • Quarter • Second • SecondEpoch • Week • Year | Required | 51.0 |
| `label` | `String` | The extract field label. | Required | 51.0 |
| `name` | `String` | The extract field name. | Required | 51.0 |

---

## Schema 계열

### Schema Node Input
A schema node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `fields` | `SchemaParametersInput[]` | The schema fields for the node. | Required | 51.0 |

### Schema Parameters Input
The parameters for a schema node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `fields` | `SchemaFieldParametersInputRepresentation[]` [sic] | The schema fields for the node. | Required | 51.0 |
| `slice` | `SchemaSliceInput` | The schema slice definition for the node. | Required | 51.0 |

### Schema Slice Input
The slice definition for a schema node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `fields` | `String[]` | The list of fields for SELECT or DROP. | Required | 51.0 |
| `ignoreMissingFields` | `Boolean` | Indicates whether the node action ignores missing fields (true) or not (false). | Required | 51.0 |
| `mode` | `RecipeSliceMode` | The slice mode. Valid values are: • SELECT • DROP | Required | 51.0 |

### Schema Field Parameters Input
The field parameters for a schema node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `errorValue` | `String` | The value to output on error. | Optional | 52.0 |
| `name` | `String` | The schema field name. | Required | 51.0 |
| `newProperties` | `SchemaFieldPropertiesInput` | The schema field properties. | Required | 51.0 |

### Schema Field Properties Input
The field properties for a schema node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `label` | `String` | The new schema field property label. | Required | 51.0 |
| `name` | `String` | The new schema field property name. | Required | 51.0 |
| `typeProperties` | `SchemaFieldTypePropertiesInput` | The new schema type property type values. | Required | 51.0 |

### Schema Field Type Properties Input
The field type properties for a schema node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `format` | `String` | The DateTime format. | Optional | 51.0 |
| `length` | `Integer` | The total length of the text. | Required | 51.0 |
| `precision` | `Integer` | The length of an arbitrary precision value. | Optional | 51.0 |
| `scale` | `Integer` | The number of digits to the right of the decimal point. | Optional | 51.0 |
| `symbols` | `SchemaFieldFormatSymbolsInput` | The number format. | Optional | 51.0 |
| `type` | `RecipeDataType` | The recipe data type. Valid values are: • DateOnly • DateTime • Multivalue • Number • Text | Required | 51.0 |

### Schema Field Format Symbols Input
The field format symbols for a schema node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `currencySymbol` | `String` | The currency symbol format. | Optional | 51.0 |
| `decimalSymbol` | `String` | The decimal symbol format. | Optional | 51.0 |
| `groupingSymbol` | `String` | The grouping symbol format. | Optional | 51.0 |

---

## 데이터 로딩 파라미터

### Sample Parameters Input
The sample parameters for loading data.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `filters` | `FilterParametersInput` | The sample filters. | Required | 55.0 |
| `sortBy` | `String[]` | A list of fields to sort sample. | Required | 55.0 |
| `sortDirection` | `RecipeSortOrderEnum` | The sample sort direction. Valid values are: • Ascending • Descending | Required | 55.0 |
| `sampleType` | `SampleType` | The recipe sample type. Valid values are: • Custom • Random • TopN • Unique | Required | 55.0 |
| `uniqueSampleFieldName` | `String` | The field name for a unique sample. | Required | 55.0 |

### Streaming Parameters Input
The streaming parameters for loading data.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `outputMode` | `OutputModeEnum` | The output mode. Valid values are: • Append • Complete • Update | Required | 57.0 |
| `triggerIntervalSec` | `Integer` | The trigger interval in seconds. | Required | 57.0 |
| `triggerType` | `TriggerTypeEnum` | The trigger type. Valid values are: • Fixed | Required | 55.0 |

---

## 기타 Input

### Data Object Category Input
The data object category for an Output Data Cloud node.

> 원문 4번째 열 헤더가 `Filter Group and Version`로 표기되어 있으나(`[sic]`), 의미상 Required/Optional 열이다.

| Property | Type | Description | Filter Group and Version [sic] | Version |
|---|---|---|---|---|
| `categoryName` | `String` | The name of the data category. | Required | 60.0 |
| `label` | `String` | The label of the data category. | Required | 60.0 |

### Target Field Input
A target field for a recipe bucket.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| `label` | `String` | The label for the field. | Required | 64.0 |
| `name` | `String` | The name for the field. | Required | 64.0 |
| `type` | `RecipeDataType` | The data type. Valid recipe data types are: • DateOnly • DateTime • Multivalue • Number • Text | Required | 64.0 |

---

## 요청 예시

```json
// 구조 예시 — 실제 동작 설정 아님
{
  "filter": {
    "action": "filter",
    "parameters": {
      "filterBooleanLogic": "1 AND 2",
      "filterExpressions": [
        {
          "field": "Amount",
          "operator": ">",
          "operands": ["1000"],
          "type": "Number"
        }
      ]
    }
  }
}
```

---

## 관련 노트
- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]]
- [[Recipe REST API — Recipe 구성 Input]]
- [[Recipe REST API — Enums]]
