---
tags: [analytics, crm-analytics, data-prep, recipe, rest-api, request-body]
source: salesforce_recipes_api.pdf (Data Prep Recipe REST API Developer Guide, Summer '26)
created: 2026-06-21
aliases: [Aggregate Node Input, Join Parameters Input, Pivot V2 Input, Recommendation Node Input, 레시피 집계 조인 노드]
---

# Recipe REST API — Aggregate·Append·Join·Compute·Pivot Input

> Data Prep Recipe REST API에서 데이터 변환 노드(집계·추가·조인·상대계산·피벗·추천·분할)를 정의하는 20개 request body 표현형 전수 — 각 Node Input은 Recipe Node Input을 상속한다.

---

이 노트는 Data Prep Recipe REST API의 **데이터 변환(transform) 계열 노드 input 표현형 20개**를 전수 정리한다. 각 노드는 `*Node Input`(노드 래퍼)과 `*Parameters Input`(파라미터 묶음) 쌍으로 구성되며, 보조 표현형(Aggregate Input·Append Mapping Input·Pivot Input 등)이 파라미터를 채운다.

- **집계(Aggregate)** — Aggregate Node Input → Aggregate Parameters Input. 집계·그룹핑·피벗을 정의.
- **추가(Append)** — Append / Append V2 / Optimized Append 세 계열.
- **조인(Join)** — Join Node Input → Join Parameters Input.
- **상대 계산(Compute Relative)** — 정렬·파티션 기반 윈도우 계산.
- **피벗(Pivot)** — Pivot Input(v1) / Pivot V2 Input.
- **추천(Recommendation)·분할(Split)** — 별도 노드.

각 표 컬럼: **Property** · **Type** · **Description** · **Required or Optional** · **Available Version**. Type 명은 표현형 카탈로그(노이즈 방지)를 위해 wikilink 대신 `code`로만 표기한다.

> **상속 노트:** 아래 모든 `*Node Input` 표현형(Aggregate / Append / Append V2 / Optimized Append / Join / Compute Relative / Recommendation / Split Node Input)은 **Recipe Node Input**을 상속한다. base 표현형의 속성은 [[Recipe REST API — Recipe 구성 Input]] 노트 참조.

---

## 집계 (Aggregate)

### 1. Aggregate Input

The aggregate data for a recipe node.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| action | `RecipeAggregateType` | The recipe aggregation type. (Valid values 아래) | Required | 49.0 |
| label | `String` | The label for the aggregate data. | Required | 49.0 |
| name | `String` | The name for the aggregate data. | Required | 49.0 |
| source | `String` | The source for the aggregate data. | Required | 49.0 |

**`action` valid values:** `Avg` · `Count` · `Maximum` · `Median` · `Minimum` · `StdDev` · `StdDevP` · `Sum` · `Unique` · `Var` · `VarP`

### 2. Aggregate Node Input

An aggregate data node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `AggregateParametersInput` | The parameters for the node. | Required | 49.0 |

### 3. Aggregate Parameters Input

The parameters for an aggregate data node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| aggregations | `AggregateInput[]` | The list of aggregations for the node. | Required | 49.0 |
| groupings | `String[]` | The list of groupings for the node. | Required | 49.0 |
| nodeType | `RecipeAggregateNodeEnum` | The aggregate type for the node. (Valid values 아래) | Required | 49.0 |
| parentField | `String` | The parent field for the node | Required | 53.0 |
| percentageField | `String` | The percentage field for the node | Required | 53.0 |
| pivot_v2 | `PivotV2Input[]` | The pivot v2 data for the node. | Optional | 54.0 |
| pivots | `PivotInput[]` | The list of pivots for the node. | Required | 51.0 |
| selfField | `String` | The self field for the node | Required | 53.0 |

**`nodeType` valid values:** `Hierarchical` · `Standard`

---

## 추가 (Append)

### 4. Append Mapping Input

A mapping for an append node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| bottom | `String` | The bottom dataset field. | Required | 51.0 |
| top | `String` | The top dataset field. | Required | 51.0 |

### 5. Append Node Input

An append node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `AppendParametersInput` | The parameters for the node. | Required | 49.0 |

### 6. Append Parameters Input

The parameters for an append node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| allowImplicitDisjointSchema | `Boolean` | Indicates whether disjoint schema merge is allowed when automatically mapping fields (true) or not (false). | Optional | 55.0 |
| fieldMappings | `AppendMappingInput[]` | The list of mappings for the node. | Required | 51.0 |

### 7. Append V2 Node Input

A version 2 append node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `AppendParametersInput` | The parameters for the node. | Required | 49.0 |

### 8. Optimized Append Node Input

An optimized append node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `OptimizedAppendParametersInput` | The parameters for the node. | Required | 62.0 |

### 9. Optimized Append Parameters Input

The parameters for an optimized append node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| allowImplicitDisjointSchema | `Boolean` | Indicates whether disjoint schema merge is allowed (true) or not (false). | Required | 62.0 |
| dataset | `LoadAnalyticsDatatsetInput` [sic] | The base dataset to append. | Required | 62.0 |
| dateConfigurationName | `String` | The name of the date configuration. | Required | 62.0 |
| operation | `OperationEnum` | The append operation type. (Valid values 아래) | Required | 64.0 |

> [!note] `dataset` Type 오타 (원문 보존)
> PDF 원문은 `LoadAnalyticsDatatsetInput`로 표기되어 있으며 "Datatset"는 **`LoadAnalyticsDatasetInput`의 오타**로 보인다. 위 표는 원문을 그대로 보존했다(`[sic]`).

**`operation` valid values:** `Append` · `Delete` · `Upsert`

---

## 조인 (Join)

### 10. Join Node Input

A join node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `JoinParametersInput` | The parameters for the node. | Required | 51.0 |

### 11. Join Parameters Input

The parameters for a join node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| joinType | `RecipeJoinType` | The join type. (Valid values 아래) | Required | 51.0 |
| leftKeys | `String[]` | The list of left keys. | Required | 51.0 |
| leftQualifier | `String` | The left qualifier. | Required | 51.0 |
| rightKeys | `String[]` | The list of right keys. | Required | 51.0 |
| rightQualifier | `String` | The right qualifier. | Required | 51.0 |

**`joinType` valid values:** `Cross` · `Inner` · `LeftOuter` · `Lookup` · `MultiValueLookup` · `Outer` · `RightOuter`

---

## 상대 계산 (Compute Relative)

### 12. Compute Relative Node Input

A compute relative node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `ComputeRelativeParametersInput` | The parameters for the node. | Required | 51.0 |

### 13. Compute Relative Parameters Input

The parameters for a compute relative node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| expressionType | `RecipeFormulaExpressionType` | The formula expression type. (Valid values 아래) | Optional | 51.0 |
| fields | `SqlFormulaFieldInput[]` | The list of formula fields. (Valid values 아래) | Required | 51.0 |
| orderBy | `ComputeRelativeSortParametersInput[]` | The list of sort fields. | Optional | 51.0 |
| partitionBy | `String[]` | The list of partition by values. | Optional | 51.0 |

> [!note] `expressionType`는 **Optional** (이미지 검증)
> PDF 본문 텍스트로는 Required로 오인되기 쉬우나, 원문 표 이미지 확인 결과 **Optional**이 정확하다.

**`expressionType` valid values:** `Legacy` · `Sql`

**`fields` valid values (구체 표현형):** `SQL Formula Date Only Field Input` · `SQL Formula Date Time Field Input` · `SQL Formula Multivalue Field Input` · `SQL Formula Numeric Field Input` · `SQL Formula Text Field Input`

### 14. Compute Relative Sort Parameters Input

The sort parameters for a compute relative node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| direction | `RecipeSortOrderEnum` | The sort direction. (Valid values 아래) | Required | 51.0 |
| fieldName | `String` | The field name. | Required | 51.0 |

**`direction` valid values:** `Ascending` · `Descending`

---

## 피벗 (Pivot)

### 15. Pivot Input

A pivot for an aggregate data node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| source | `String` | The source for the pivot. | Required | 51.0 |
| values | `String[]` | The list of values for the pivot. | Required | 51.0 |

### 16. Pivot V2 Input

A version 2 pivot for an aggregate data node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| pivotFieldsInfo | `Map<RecipeNameLabelInput, List` [sic] | The map of the pivot fields information. | Required | 54.0 |
| sourceFields | `String[]` | The list of source fields for the pivot. | Required | 54.0 |
| valueCombinations | `String[]` | The list of value combinations for the pivot. | Required | 54.0 |

> [!note] `pivotFieldsInfo` Type 닫힘 누락 (원문 보존)
> PDF 원문에 `Map<RecipeNameLabelInput, List`로 표기되어 generic 닫힘 괄호(`>`)와 List 요소 타입이 누락돼 있다. 위 표는 원문을 그대로 보존했다(`[sic]`).
> 추측 보충 시 형태는 다음으로 추정된다(공식 확인 안 됨):
> ```text
> // 구조 예시 — 실제 동작 코드 아님 (PDF 원문 닫힘 누락 추측 보충)
> Map<RecipeNameLabelInput, List<...>>
> ```

---

## 추천 (Recommendation)

### 17. Recommendation Node Input

A recommendation node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `RecommendationParametersInput` | The parameters for the node. | Required | 53.0 |

### 18. Recommendation Parameters Input

The parameters for a recommendation node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| custIdField | `String` | The customer ID field. | Required | 53.0 |
| excludePreviousRecommendations | `Boolean` | Indicates whether to exclude previous recommendations (true) or not (false). | Required | 53.0 |
| productIdField | `String` | The product ID field. | Required | 53.0 |
| productRecommendations | `Integer` | The product recommendations field. | Required | 53.0 |
| ratingField | `String` | The rating field. | Required | 53.0 |
| targetField | `RecipeNameLabelInput` | The target field. | Required | 53.0 |
| targetRankField | `RecipeNameLabelInput` | The target rank field. | Required | 53.0 |
| targetRatingField | `RecipeNameLabelInput` | The target rating field. | Required | 53.0 |
| useImplicitRatings | `Boolean` | Indicates whether to use implicit ratings (true) or not (false). | Required | 53.0 |

---

## 분할 (Split)

### 19. Split Node Input

A split node in a recipe. Inherits Recipe Node Input.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| parameters | `SplitParametersInput` | The parameters for the node. | Required | 49.0 |

### 20. Split Parameters Input

The parameters for a split node in a recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| delimiter | `String` | The split delimiter. | Required | 51.0 |
| sourceField | `String` | The source field. | Required | 51.0 |
| targetFields | `RecipeNameLabelInput[]` | The list of target fields. | Required | 51.0 |

---

## request body 예시

```json
// 구조 예시 — 실제 동작 설정 아님 (위 표현형 조합 예시)
{
  "nodeType": "Aggregate",
  "parameters": {
    "groupings": ["Industry"],
    "aggregations": [
      { "action": "Sum", "name": "TotalAmount", "label": "Total Amount", "source": "Amount" }
    ],
    "nodeType": "Standard"
  }
}
```

---

## 관련 노트

- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]]
- [[Recipe REST API — Recipe 구성 Input]]
- [[Recipe REST API — Enums]]
