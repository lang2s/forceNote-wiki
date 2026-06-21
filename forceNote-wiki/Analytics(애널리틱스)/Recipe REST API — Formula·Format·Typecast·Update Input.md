---
tags: [analytics, crm-analytics, data-prep, recipe, rest-api, request-body, formula]
source: salesforce_recipes_api.pdf (Data Prep Recipe REST API Developer Guide, Summer '26)
created: 2026-06-21
aliases: [Formula Node Input, SQL Formula Field Input, Typecast Parameters Input, Update Data Cloud Object, 레시피 수식 노드, 형변환 노드]
---

# Recipe REST API — Formula·Format·Typecast·Update Input

> Data Prep Recipe REST API 요청 본문 중 수식(Formula)·날짜 형식 변환(Format Date)·형변환(Typecast)·업데이트(Update / Optimized Update / Update Data Cloud Object) 계열 노드의 입력(Input) 타입 23개를 전수 정리한다.

---

이 노트는 Recipe 요청 본문에서 다음 4개 노드 계열의 Input 타입을 다룬다.

- **Formula** — 레거시 수식과 SQL 수식, 그리고 각 데이터 타입별 SQL 수식 필드
- **Format Date** — 날짜 형식 변환 노드와 그 패턴
- **Typecast** — 필드 형변환 노드
- **Update 계열** — Update, Optimized Update, Update Data Cloud Object(Data 360)

각 표는 소스 가이드의 5열(Property · Type · Description · Required/Optional · Version)을 그대로 옮긴 것이다. `Type` 열은 다른 Input 타입을 가리키더라도 wikilink가 아니라 `code`로 표기한다(API 식별자 정확성 보존). 노드 Input은 모두 `Recipe Node Input`을 상속하며, 상속 관계는 맨 아래 [상속 요약](#상속-요약)에 정리했다.

> 일부 Description은 소스 원문의 오기·구두점 누락을 그대로 보존했다(`[sic]` 표기). API 문서 대조 시 원문과 일치시키기 위함이다.

```jsonc
// 구조 예시 — 실제 동작 설정 아님 (Formula 노드 요청 본문 골격)
{
  "action": "formula",
  "parameters": {
    "expressionType": "Sql",
    "fields": [
      {
        "name": "Discounted_Price",
        "label": "Discounted Price",
        "type": "Number",
        "formulaExpression": "Price * 0.9",
        "precision": 18,
        "scale": 2
      }
    ]
  }
}
```

---

## Formula 계열

### Formula Node Input

A formula node in a recipe. Inherits `Recipe Node Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| parameters | `FormulaParametersInput` | The parameters for the node. Valid values are: • `LegacyFormulaParametersInput` • `SqlFormulaParametersInput` | Required | 51.0 |

### Formula Parameters Input

The base parameters for a formula node in a recipe. Inherited by `LegacyFormulaParametersInput` and `SqlFormulaParametersInput`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| expressionType | `RecipeFormulaExpressionType` | The formula expression type. Valid values are: • `Legacy` • `Sql` | Required | 51.0 |

### Legacy Formula Field Input

A legacy formula field for a formula.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| formulaExpression | `String` | The formula expression. | Required | 51.0 |
| label | `String` | The field label. | Required | 51.0 |
| name | `String` | The field name. | Required | 51.0 |

### Legacy Formula Parameters Input

The legacy formula parameters for a formula. Inherits `Formula Parameters Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| fields | `LegacyFormulaFieldInput[]` | The list of fields. | Required | 51.0 |

### SQL Formula Field Input

The base SQL formula field for a recipe node. Inherited by `SQL Formula Date Only Field Input`, `SQL Formula Date Time Field Input`, `SQL Formula Multivalue Field Input`, `SQL Formula Numeric Field Input`, and `SQL Formula Text Field Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| formulaExpression | `String` | The formula expression [sic — 원문 마침표 없음] | Required | 51.0 |
| label | `String` | The formula label. | Required | 51.0 |
| name | `String` | The formula name. | Required | 51.0 |
| type | `RecipeDataType` | The recipe data type. Valid values are: • `DateOnly` • `DateTime` • `Multivalue` • `Number` • `Text` | Required | 51.0 |

### SQL Formula Date Only Field Input

The SQL formula date only field for a recipe node. Inherits `SQL Formula Field Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| defaultValue | `String` | The default value for the date field. | Required | 51.0 |
| format | `String` | The format for the date field. | Required | 51.0 |

### SQL Formula Date Time Field Input

The SQL formula date time field for a recipe node. Inherits `SQL Formula Field Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| defaultValue | `String` | The default value for the date field. [sic — date time 노드인데 원문은 "date field"] | Required | 51.0 |
| format | `String` | The format for the date field. [sic] | Required | 51.0 |

### SQL Formula Multivalue Field Input

The SQL formula multivalue field for a recipe node. Inherits `SQL Formula Field Input`.

이 타입은 **자체 추가 프로퍼티가 없다.** `SQL Formula Field Input`에서 상속한 `formulaExpression` · `label` · `name` · `type`만 가진다.

### SQL Formula Numeric Field Input

The SQL formula numeric field for a recipe node. Inherits `SQL Formula Field Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| defaultValue | `String` | The default value for the numeric field. | Optional | 51.0 |
| precision | `Integer` | The precision of the numeric field. | Required | 51.0 |
| scale | `Integer` | The scale of the numeric field. | Required | 51.0 |

### SQL Formula Text Field Input

The SQL formula text field for a recipe node. Inherits `SQL Formula Field Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| defaultValue | `String` | The default value for the text field. | Optional | 51.0 |
| precision | `Integer` | The precision of the text field. | Required | 51.0 |

### SQL Formula Parameters Input

The SQL formula parameters for a formula. Inherits `Formula Parameters Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| fields | `SqlFormulaFieldInput[]` | The list of formula fields. Valid values are: • `SQL Formula Date Only Field Input` • `SQL Formula Date Time Field Input` • `SQL Formula Multivalue Field Input` • `SQL Formula Numeric Field Input` • `SQL Formula Text Field Input` | Required | 51.0 |

---

## Format Date 계열

### Format Date Node Input

A date format conversion node in a recipe. Inherits `Recipe Node Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| parameters | `FormatDateParametersInput` | The parameters for the node. | Required | 51.0 |

### Format Date Parameters Input

The parameters for a date format conversion node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| sourceField | `String` | The source field. | Required | 51.0 |
| sourceFormats | `FormatDatePatternInput[]` | The list of source date formats. | Required | 51.0 |
| targetField | `RecipeNameLabelInput` | The target field. | Required | 51.0 |
| targetFormat | `FormatDatePatternInput` | The target date format. | Required | 51.0 |

### Format Date Pattern Input

The pattern for date format conversion.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| construction | `String[]` | The list of values for construction of the date format. | Required | 51.0 |
| groups | `String[]` | The list of date format groups. | Required | 51.0 |
| regex | `String` | The regular expression for the date format. | Optional | 51.0 |

### Measure To Currency Input

The conversion information for currency measure field.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| conversionRateDateField | `String` | The conversion rate date field. | Required | 56.0 |
| measureField | `String` | The measure field. | Required | 56.0 |

---

## Typecast 계열

### Typecast Node Input

A typecast node in a recipe. Inherits `Recipe Node Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| parameters | `TypecastParametersInput` | The parameters for the node. | Required | 51.0 |

### Typecast Parameters Input

The parameters for a typecast node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| fields | `SchemaFieldParametersInput[]` | The list of fields to typecast. | Required | 51.0 |

---

## Update 계열

### Update Node Input

An update node in a recipe. Inherits `Recipe Node Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| parameters | `UpdateParametersInput` | The parameters for the node. | Required | 51.0 |

### Update Parameters Input

The parameters for an update node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| leftKeys | `String[]` | The list of left keys. | Required | 54.0 |
| rightKeys | `String[]` | The right of left keys. [sic — 원문 그대로] | Required | 54.0 |
| updateColumns | `Map<String, String>` | The map of columns to update. | Required | 54.0 |

### Optimized Update Node Input

An optimized append node in a recipe. [sic — Update 노드인데 원문은 "append"] Inherits `Recipe Node Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| parameters | `OptimizedUpdateParametersInput` | The parameters for the node. | Required | 62.0 |

### Optimized Update Parameters Input

The parameters for an optimized update node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| allowImplicitDisjointSchema | `Boolean` | Indicates whether disjoint schema merge is allowed (true) or not (false). | Required | 64.0 |
| dataset | `LoadAnalyticsDatasetInput` | The base dataset to append. | Required | 64.0 |
| dateConfigurationName | `String` | The name of the date configuration. | Required | 64.0 |
| operation | `OperationEnum` | The append operation type. Valid operation types are: • `Append` • `Delete` • `Upsert` | Required | 64.0 |
| primaryKey | `String` | The name of the primary key field. | Required | 67.0 |

### Update Data Cloud Object Node Input

A Data 360 object update node in a recipe. Inherits `Recipe Node Input`.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| parameters | `UpdateDataCloudObjectParametersInput` | The parameters for the node. | Required | 66.0 |

### Update Data Cloud Object Parameters Input

The parameters for an update data cloud object node in a recipe.

| Property | Type | Description | Required/Optional | Version |
|---|---|---|---|---|
| connectorType | `ConnectWaveDataConnectorTypeEnum` | The connector type. Valid values are: (`ConnectWaveDataConnectorTypeEnum` 39값 — [[Recipe REST API — Enums]] 참조) | Required | 66.0 |
| fieldMappings | `List[OutputDataCloudFieldsMapping]` | The list of the Data 360 field mappings. | Required | 66.0 |
| name | `String` | The name of the Data 360 object to update. | Required | 66.0 |
| operation | `OperationEnum` | The update operation. Valid values are: • `Append` • `Delete` • `Upsert` | Required | 66.0 |
| primaryKey | `String` | The name of the primary key field. | Required | 66.0 |
| type | `RecipeDataCloudOutputTypeEnum` | The output type. Valid values are: • `DateLakeObject` [sic — 원문 그대로] | Required | 66.0 |

---

## 상속 요약

- `FormulaParametersInput` ← `LegacyFormulaParametersInput`, `SqlFormulaParametersInput`
- `SqlFormulaFieldInput` ← `SqlFormulaDateOnlyFieldInput`, `SqlFormulaDateTimeFieldInput`, `SqlFormulaMultivalueFieldInput`(자체 프로퍼티 없음), `SqlFormulaNumericFieldInput`, `SqlFormulaTextFieldInput`
- 모든 `*Node Input` ← `Recipe Node Input`

---

## 관련 노트

- [[Recipe REST API — Enums]] — `RecipeFormulaExpressionType` · `RecipeDataType` · `OperationEnum` · `ConnectWaveDataConnectorTypeEnum` · `RecipeDataCloudOutputTypeEnum` 등 enum 전수
- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]]
- [[Recipe REST API — Recipe 구성 Input]]
