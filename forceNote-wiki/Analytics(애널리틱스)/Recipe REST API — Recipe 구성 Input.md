---
tags: [analytics, crm-analytics, data-prep, recipe, rest-api, request-body]
source: salesforce_recipes_api.pdf (Data Prep Recipe REST API Developer Guide, Summer '26)
created: 2026-06-21
aliases: [Recipe Input, Recipe Definition Input, Recipe Node Input, 레시피 구성, RecipeRunMode, 레시피 정의]
---

# Recipe REST API — Recipe 구성 Input

> Data Prep Recipe REST API의 레시피 그래프를 정의하는 11개 request body 표현형 — Recipe Input(최상위)·Recipe Definition Input(노드 맵)·Recipe Node Input(노드 부모) 중심.

---

이 노트는 Data Prep Recipe REST API에서 레시피를 생성·수정할 때 request body로 전송하는 **Recipe 구성(configuration) 계열 input 표현형 11개**를 전수 정리한다. 핵심 3개는 레시피 그래프 자체를 정의한다.

- **Recipe Input** — 레시피 한 건의 최상위 표현형 (포맷·폴더·실행 엔진·정의 등).
- **Recipe Definition Input** — R3 레시피의 정의. `name`으로 키잉된 노드 맵(`nodes`)을 담는다.
- **Recipe Node Input** — 모든 노드의 base(부모) 표현형. 33개 구체 노드 input이 이를 상속한다.

각 표 컬럼: **Property** · **Type** · **Description** · **Required or Optional** · **Available Version**. Type 명은 표현형 카탈로그(노이즈 방지)를 위해 wikilink 대신 `code`로만 표기한다.

> [!note] Data 360 리브랜딩 (원문 보존)
> As of October 14, 2025, Data Cloud has been rebranded to Data 360. During this transition, you may see references to Data Cloud in our application and documentation. While the name is new, the functionality and content remains unchanged.
>
> (이 노트는 Recipe Definition Input·Recipe Node Input 두 표현형에 명시된 원문 노트를 그대로 보존한다.)

---

## 1. Recipe Configuration Collection Input

A collection of data prep recipe configurations.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| recipeConfigurations | `RecipeConfigurationCollectionInput[]` | The list of recipe configurations to update. | Required | 54.0 |

## 2. Recipe Configuration Fiscal Input

The data prep recipe fiscal configuration data.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| firstDayOfWeek | `Integer` | The first day of week, calendar and fiscal. | Required | 55.0 |
| fiscalType | `RecipeConfigurationTypeEnum` | The recipe configuration fiscal type. (Valid values 아래) | Required | 54.0 |
| isDefault | `Boolean` | Indicates whether this recipe configuration is the default configuration (true) or not (false). | Required | 54.0 |

**`fiscalType` valid values:**

- `Offset` (Recipe Configuration Fiscal Offset Input)

## 3. Recipe Configuration Fiscal Offset Input

The data prep recipe fiscal offset configuration data.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| id | `String` | The ID of the recipe configuration. | Required | 54.0 |
| monthOffset | `String` | The month offset. | Required | 54.0 |
| yearBasedOn | `RecipeConfigurationFiscalOffsetYearBasedOnEnum` | The fiscal offset year based on for the recipe configuration. (Valid values 아래) | Required | 54.0 |

**`yearBasedOn` valid values:**

- `End`
- `Start`

## 4. Recipe Configuration

A data prep recipe configuration.

> 원문 제목에 "Input" 접미사가 없다 — 위 1~3과 달리 `Recipe Configuration`으로 표기됨(원문 그대로).

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| fiscalType | `RecipeConfigurationTypeEnum` | The recipe configuration fiscal type. (Valid values 아래) | Required | 54.0 |
| isDefault | `Boolean` | Indicates whether this recipe configuration is the default configuration (true) or not (false). | Required | 54.0 |

**`fiscalType` valid values:**

- `Fiscal` (Recipe Configuration Fiscal Input)
- `Offset` (Recipe Configuration Fiscal Offset Input)

## 5. Recipe Conversion Detail Input

The details for the upconversion of a data prep recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| conversionDetailId | `Integer` | The conversion detail ID. | Required | 52.0 |
| message | `String` | The conversion detail message. | Required | 52.0 |
| nodeName | `String` | The name of the node referenced in the conversion detail. | Required | 52.0 |
| severity | `ConnectRecipeConversionSeverityEnum` | The severity of the conversion detail. (Valid values 아래) | Required | 52.0 |

**`severity` valid values:**

- `UserInfo`
- `Warning`

## 6. Recipe Definition Input

The definition for a data prep recipe. Available on for R3 recipes. <!-- [sic] "Available on for" — 원문 그대로 -->

> 원문: "Available on for R3 recipes." — `Available on for`는 원문 오타다 [sic]. 위 Data 360 리브랜딩 노트가 이 표현형에 명시되어 있다.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| name | `String` | The recipe definition name. | Required | 49.0 |
| nodes | `Map<String, RecipeNodeInput>` | The map of recipe nodes by name. (Valid values 아래) | Required | 49.0 |
| runMode | `RecipeRunMode` | The recipe run mode. (Valid values 아래) | Required | 57.0 |
| version | `String` | The recipe definition version. | Required | 49.0 |
| ui | `Object` | The recipe definition UI metadata. | Required | 49.0 |

**`runMode` valid values:**

- `Full`
- `Incremental`
- `Streaming`

**`nodes` valid values (33개 전수)** — `nodes`는 노드 이름을 키로, 각 노드 input을 값으로 갖는 맵이다. 사용 가능한 노드 표현형은 다음과 같다 (`Bucket V@ Node Input`은 원문 오타 [sic]):

- Aggregate Node
- Append Node Input
- Append V2 Node Input
- Bucket Node Input
- Bucket V@ Node Input <!-- [sic] 원문 오타 ("V@"); Recipe Node Input의 상속 목록에서는 "Bucket V2 Node Input"으로 나옴 -->
- Cluster Node Input
- Compute Relative Node Input
- Detect Sentiment Node Input
- Discovery Node Input
- Export Node Input
- Extension Node Input
- Extract Grain Node Input
- Filter Node Input
- Flatten Node Input
- Format Date Node Input
- Formula Node Input
- Join Node Input
- Load Node Input
- Optimized Append Node Input
- Optimized Update Node Input
- Output D360 Node Input
- Output Data Cloud Node Input
- Output External Node Input
- Predict Values Node Input
- Recommendation Node Input
- Save Node Input
- Schema Node Input
- Split Node Input
- SQL Filter Node Input
- Time Series Node Input
- Time Series V2 Node Input
- Typecast Node Input
- Update Node Input

`nodes` 맵의 구조 예시:

```json
// 구조 예시 — 실제 동작 설정 아님
{
  "nodes": {
    "LOAD_DATASET0": { "action": "Load", "sources": [], "schema": { } },
    "FILTER0":       { "action": "Filter", "sources": ["LOAD_DATASET0"], "schema": { } },
    "OUTPUT0":       { "action": "OutputD360", "sources": ["FILTER0"], "schema": { } }
  }
}
```

> 위 예시는 `Map<String, RecipeNodeInput>`의 형태(노드 이름 키 → 노드 input 값, `sources`로 그래프 연결)를 보여주기 위한 것이며, 각 노드 input의 전체 property는 노드별 표현형 정의를 따른다.

## 7. Recipe Input

A data prep recipe. — 레시피 한 건의 최상위 request body 표현형.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| conversionDetails | `RecipeConversionDetailInput[]` | The list of conversion details when converting the recipe to R3 that are saved. | Optional | 51.0 |
| dataflowDefinition | `String` | The recipe's definition. | Optional | 38.0 |
| executionEngine | `ConnectRecipeExecutionEngineEnum` | The recipe's execution engine. (Valid values 아래) | Optional | 41.0 |
| fileContent | `String` | The recipe's JSON file content (see /wave/recipes/&lt;recipeId&gt;/file for more information). This property is internal to the recipe UI and is available for debugging and reference purposes only. This property is valid only for Data Prep Classic recipes. | Required for POST and PATCH | 38.0 |
| folder | `AssetReferenceInput` | The Analytics app the recipe is published in. | Required when dataflowDefinition is present | 38.0 |
| format | `ConnectRecipeFormatTypeEnum` | Specifies the format of the recipe. (Valid values 아래) | Required | 48.0 |
| historyLabel | `String` | A history label to tag the version of the recipe. | Optional | 51.0 |
| label | `String` | A short label for the recipe. | Optional | 38.0 |
| licenseAttributes | `LicensesAttributesInput` | The recipe license type and other properties. | Optional | 51.0 |
| publishingTarget | `ConnectRecipePublishingTargetEnum` | The target format or system to publish the recipe to. (Valid values 아래) | Optional | 42.0 |
| recipeDefinition | `RecipeDefinitionInput` | The recipe definition for the Data Prep recipe only. This property isn't supported for Data Prep Classic recipes. | Optional | 49.0 |
| rowLevelSecurityPredicate | `String` | The security predicate of the target dataset. | Optional | 38.0 |
| schedule | `String` | The recipe's schedule dataflow run. | Optional | 38.0 |
| sourceDataflow | `AssetReferenceInput` | The source dataflow asset used to upconvert to the recipe to R3. | Optional | 51.0 |

**`executionEngine` valid values:**

- `V1`
- `V2`

**`format` valid values:**

- `R2` (Data Prep Classic)
- `R3` (Data Prep)

**`publishingTarget` valid values:**

- `Dataset` (Publish to Dataset)

## 8. Recipe Name Label Input

The name and label for a field in a recipe node.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| label | `String` | The label of the field. | Required | 49.0 |
| name | `String` | The name of the field. | Required | 49.0 |
| valueCombinations | `String[]` | The list of value combinations for the pivot. | Required | 54.0 |

## 9. Recipe Node Input

The base node for a recipe. — 모든 구체 노드 input의 부모(base) 표현형.

> 이 표현형에도 위 Data 360 리브랜딩 노트가 원문에 명시되어 있다.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| action | `RecipeNodeAction` | The recipe node action. (Valid recipe actions 아래) | Required | 51.0 |
| schema | `SchemaNodeInput` | The schema changes for the node. | Required | 51.0 |
| sources | `String[]` | The source node ids. | Required | 51.0 |

**Inherited by (원문 그대로 보존)** — 다음 표현형들이 Recipe Node Input을 상속한다. 목록 끝의 `Update Node Inputand Update Node Input`은 원문에서 "Update Node Input" 항목이 중복·연결된 오타다 [sic]:

Aggregate Node, Append Node Input, Append V2 Node Input, Bucket Node Input, Bucket V2 Node Input, Cluster Node Input, Compute Relative Node Input, Detect Sentiment Node Input, Discovery Node Input, Export Node Input, Extension Node Input, Extract Grain Node Input, Filter Node Input, Flatten Node Input, Format Date Node Input, Formula Node Input, Join Node Input, Load Node Input, Optimized Append Node Input, Optimized Update Node Input, Output D360 Node Input, Output Data Cloud Node Input, Output External Node Input, Predict Values Node Input, Recommendation Node Input, Save Node Input, Schema Node Input, Split Node Input, SQL Filter Node Input, Time Series Node Input, Time Series V2 Node Input, Typecast Node Input, Update Node Input<!-- [sic] -->and Update Node Input.

**`action` valid recipe actions (34개 전수)** — `Updatei`는 원문 오타다 [sic]:

- `Aggregate`
- `Append`
- `Append_V2`
- `Bucket`
- `Bucket V2`
- `Clustering`
- `ComputeRelative`
- `DateFormatConversion`
- `DetectSentiment`
- `DiscoveryPredict`
- `Export`
- `Extension`
- `Extract`
- `Filter`
- `Flatten`
- `Formula`
- `Join`
- `Load`
- `OptimizedAppendOutput`
- `OptimizedUpdateOutput`
- `OutputD360`
- `OutputExternal`
- `PredictMissingValues`
- `Recommendation`
- `Save`
- `Schema`
- `Split`
- `SqlFilter`
- `TimeSeries`
- `TimeSeriesV2`
- `TypeCast`
- `Updatei` <!-- [sic] 원문 오타 -->
- `UpdateDataCloudObject`
- `WriteDataCloudObject`

## 10. Recipe Notification Input

A notification for a data prep recipe.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| longRunningAlertInMins | `Integer` | The number of minutes that a recipe can run before sending an alert. | Optional | 49.0 |
| notificationLevel | `ConnectEmailNotificationLevelEnum` | Valid types of email notification levels. (Valid values 아래) | Required | 49.0 |

**`notificationLevel` valid values:**

- `Always`
- `Failures`
- `Never`
- `Warnings`

## 11. Recipe Type Name Input

The name and type for a field in a recipe node.

| Property | Type | Description | Required or Optional | Available Version |
|---|---|---|---|---|
| name | `String` | The name of the field. | Required | 49.0 |
| type | `String` | The type of the field. | Required | 49.0 |

---

## 관련 노트

- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]]
- [[Recipe REST API — Response 표현형 (Recipe~Update)]]
- [[Recipe REST API — Enums]]
