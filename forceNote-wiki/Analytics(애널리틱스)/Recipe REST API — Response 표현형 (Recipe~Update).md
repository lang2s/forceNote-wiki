---
tags: [analytics, crm-analytics, data-prep, recipe, rest-api, response-body]
source: salesforce_recipes_api.pdf (Data Prep Recipe REST API Developer Guide, Summer '26)
created: 2026-06-21
aliases: [Recipe response, Recipe Definition response, Recipe Node response, Recipe Validation Detail, Time Series Parameters response, 레시피 응답 바디 Recipe]
---

# Recipe REST API — Response 표현형 (Recipe~Update)

> Data Prep Recipe REST API(`/wave/recipes`) 응답 바디 표현형(representation)의 후반부 — Recipe Collection부터 Update Parameters까지 50개 표현형을 전수 정리한다. 각 표현형의 프로퍼티는 5열(Property Name · Type · Description · Filter Group and Version · Available Version)로 원문 그대로 옮긴다. (전반부 Bucket~Output은 [[Recipe REST API — Response 표현형 (Bucket~Output)]] 참조.)

---

## 읽는 법 (섹션 머리 노트)

- **Response 표현형의 4번째 열은 "Filter Group and Version"** 이다(Request의 Required/Optional 열과 다름). 값은 보통 `Small, vNN.0` 또는 `Small, NN.0`·`Medium, NN.0` 형태이며, 일부는 `Optional`·`Required` 같은 예외 값이 들어간다. **원문 표기를 그대로 보존**한다(쉼표 유무·`v` 접두사 유무 포함).
- **Type 명은 코드(`code`)로만 표기**하며 위키링크가 아니다. 타입이 다른 표현형을 가리키는 경우에도 본 노트 또는 형제 노트의 동명 섹션을 의미한다.
- **상속(Inherits / Inherited by) 노트**는 각 표현형 설명에 그대로 보존한다.
- 원문의 [sic] 오타·표기 이상(예: `Updatei`, `forumla`, `DateLakeObject`, 미완결 문장, 중복 설명 등)은 **수정하지 않고 그대로 둔다**.
- `ConnectWaveDataConnectorTypeEnum`(39값)의 유효 값은 본 노트에 나열하지 않고 [[Recipe REST API — Enums]] 노트를 참조한다(위임).

```jsonc
// 구조 예시 — 실제 동작 설정 아님
// Recipe Definition이 응답 JSON에서 어떻게 중첩되는지(개념 예시)
{
  "name": "myRecipe",
  "version": "57.0",
  "runMode": "Full",
  "nodes": {                       // Map<String, RecipeNode>
    "LOAD_0": { "action": "Load", "sources": [], "schema": {} },
    "SAVE_1": { "action": "Save", "sources": ["LOAD_0"] }
  }
}
```

---

## Recipe Collection

A collection of data prep recipes.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| nextPageUrl | `String` | The URL to retrieve the next page of contents in the collection. | Small, 52.0 | 52.0 |
| recipes | `Recipe[]` | A list of recipes. | Small, 38.0 | 38.0 |
| totalSize | `Integer` | The total count of the elements in the collection, including all pages. | Medium, 52.0 | 52.0 |
| url | `String` | The URL to retrieve the collection. | Small, 52.0 | 52.0 |

## Recipe Configuration Collection

A collection of data prep recipe configurations.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| configurations | `RecipeConfiguration[]` | A list of recipe configurations. | Small, 54.0 | 54.0 |

## Recipe Configuration Fiscal

The data prep recipe fiscal configuration data.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| firstDayOfWeek | `Integer` | The first day of week, calendar and fiscal. | Small, 55.0 | 55.0 |
| fiscalType | `RecipeConfigurationTypeEnum` | The recipe configuration fiscal type. Valid values are: • Offset (Recipe Configuration Fiscal Offset) | Small, 54.0 | 54.0 |
| isDefault | `Boolean` | Indicates whether this recipe configuration is the default configuration (true) or not (false). | Small, 54.0 | 54.0 |

## Recipe Configuration Fiscal Offset

The data prep recipe fiscal offset configuration data.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| monthOffset | `String` | The month offset. | Small, 54.0 | 54.0 |
| yearBasedOn | `RecipeConfigurationFiscalOffsetYearBasedOnEnum` | The fiscal offset year based on for the recipe configuration. Valid values are: • End • Start | Small, 54.0 | 54.0 |

## Recipe Configuration

The data prep recipe configuration data.

**상속:** Recipe Configuration inherits properties from the abstract Base Wave Asset.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| configurationType | `RecipeConfigurationTypeEnum` | The recipe configuration type. Valid values are: • Fiscal (Recipe Configuration Fiscal) | Small, 54.0 | 54.0 |

## Recipe Conversion Detail

The details for the upconversion of a data prep recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| conversionDetailId | `Integer` | The conversion detail ID. | Small, 52.0 | 52.0 |
| message | `String` | The conversion detail message. | Small, 52.0 | 52.0 |
| nodeName | `String` | The name of the node referenced in the conversion detail. | Small, 52.0 | 52.0 |
| severity | `ConnectRecipeConversionSeverityEnum` | The severity of the conversion detail. Valid values are: • UserInfo • Warning | Small, 52.0 | 52.0 |

## Recipe Definition

The definition for a data prep recipe. Available on for R3 recipes. [sic]

> 원문 노트: "As of October 14, 2025, Data Cloud has been rebranded to Data 360..." (Data Cloud → Data 360 리브랜딩)

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| name | `String` | The recipe definition name. | Small, 49.0 | 49.0 |
| nodes | `Map<String, RecipeNode>` | The map of recipe nodes by name. Valid values are: • Aggregate Node • Append Node • Append V2 Node • Bucket Node • Bucket V2 Node • Cluster Node • Compute Relative Node • Detect Sentiment Node • Discovery Node • Export Node • Extension Node • Extract Node • Filter Node • Flatten Node • Format Date Node • Formula Node • Join Node • Load Node • Optimized Append Node • Optimized Update Node • Output D360 Node • Output Data Cloud Node • Output External Node • Predict Values Node • Recommendation Node • Save Node • Schema Node • Split Node • SQL Filter Node • Time Series Node • Time Series V2 Node • Typecast Node • Update Node | Small, 51.0 | 51.0 |
| runMode | `RecipeRunMode` | The recipe run mode. Valid values are: • Full • Incremental • Streaming | Small, v57.0 | 57.0 |
| version | `String` | The recipe definition version. | Small, 49.0 | 49.0 |
| ui | `Object` | The recipe definition UI metadata. | Small, 49.0 | 49.0 |

## Recipe Name Label

The name and label for a field in a recipe node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| label | `String` | The label of the field. | Small, v51.0 | 51.0 |
| name | `String` | The name of the field. | Small, v51.0 | 51.0 |

## Recipe Node

The base node for a recipe.

> 원문 노트: Data Cloud → Data 360 리브랜딩.

**Inherited by** Aggregate Node, Append Node, Append V2 Node, Bucket Node, Bucket V2 Node, Cluster Node, Compute Relative Node, Detect Sentiment Node, Discovery Node, Export Node, Extension Node, Extract Node, Filter Node, Flatten Node, Format Date Node, Formula Node, Join Node, Load Node, Optimized Append Node, Optimized Update Node, Output D360 Node, Output Data Cloud Node, Output External Node, Predict Values Node, Recommendation Node, Save Node, Schema Node, Split Node, SQL Filter Node, Time Series Node, Time Series V2 Node, Typecast Node, Update Data Cloud Object Node, and Update Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| action | `RecipeNodeAction` | The recipe node action. Valid recipe actions are: • Aggregate • Append • Append_V2 • Bucket • Bucket V2 • Clustering • ComputeRelative • DateFormatConversion • DetectSentiment • DiscoveryPredict • Export • Extension • Extract • Filter • Flatten • Formula • Join • Load • OptimizedAppendOutput • OptimizedUpdateOutput • OutputD360 • OutputExternal • PredictMissingValues • Recommendation • Save • Schema • Split • SqlFilter • TimeSeries • TimeSeriesV2 • TypeCast • Updatei [sic] • UpdateDataCloudObject • WriteDataCloudObject | Small, v51.0 | 51.0 |
| schema | `SchemaNode` | The schema changes for the node. | Small, v51.0 | 51.0 |
| sources | `String[]` | The input node ids. | Small, v51.0 | 51.0 |

## Recipe Notification

A notification for a data prep recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| longRunningAlertInMins | `Integer` | The number of minutes that a recipe can run before sending an alert. | Small, 49.0 | 49.0 |
| notificationLevel | `ConnectEmailNotificationLevelEnum` | Valid types of email notification levels. Valid values are: • Always • Failures • Never • Warnings | Small, 49.0 | 49.0 |
| recipe | `AssetReference` | The recipe this notification belongs to. | Small, 54.0 | 54.0 |

## Recipe Validation Detail

The validation details for a data prep recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| message | `String` | The message for the validation detail. | Small, 50.0 | 50.0 |
| nodeName | `String` | The name of the node referenced in the validation detail. | Small, 50.0 | 50.0 |
| nodeType | `String` | The type of node referenced in the validation detail. | Small, 50.0 | 50.0 |
| severity | `ConnectRecipeValidationSeverityEnum` | The severity of the validation detail. Valid values are: • Error - The recipe is non-runnable and can't be saved. • Fatal - The validation process is stopped. The recipe is non-runnable and can't be saved. • Warning - The recipe is non-runnable, but can be saved. | Small, 50.0 | 50.0 |
| validationAction | `String` | The validation action. | Small, 50.0 | 50.0 |
| validationCode | `Integer` | The validation code. | Small, 50.0 | 50.0 |

## Recipe

A data prep recipe.

**상속:** Recipe inherits properties from the abstract Base Wave Asset.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| conversionDetails | `RecipeConversionDetail[]` | The list of upconversion details when converting the recipe to R3. | Small, 51.0 | 51.0 |
| dataflowLastUpdate | `Date` | The date of the last recipe dataflow update. | Small, 38.0 | 38.0 |
| dataset | `AssetReference` | The target dataset. | Small, 38.0 | 38.0 |
| fileUrl | `String` | The URL to get the recipe's JSON file content (see /wave/recipes/<recipeId>/file for more information). | Small, 38.0 | 38.0 |
| format | `ConnectRecipeFormatTypeEnum` | Specifies the format of the returned recipe. Valid values are: • R2 (Data Prep Classic) • R3 (Data Prep) | Small, 48.0 | 48.0 |
| historiesUrl | `String` | The URL for the version histories associated with the recipe. | Small, 51.0 | 51.0 |
| licenseType | `ConnectAnalyticsLicenseTypeEnum` | The Analytics license type. Valid values are • Cdp (Data 360) • DataPipelineQuery (Data Pipeline Query) • EinsteinAnalytics (CRM Analytics) • IntelligentApps (Intelligent Apps) • MulesoftDataPath (Mulesoft Data Works) • Sonic (Salesforce Data Pipeline) | Small, 52.0 | 52.0 |
| nextScheduledDate | `Date` | The next scheduled run of this recipe. | Small, 47.0 | 47.0 |
| publishingTarget | `ConnectRecipePublishingTargetEnum` | The target format or system to publish the recipe to. Valid values are: • Dataset (Publish to Dataset) | Small, 42.0 | 42.0 |
| recipeDefinition | `RecipeDefinition` | The recipe definition for the Data Prep recipe only. This property isn't supported for Data Prep Classic recipes. | Small, 49.0 | 49.0 |
| rowLevelSecurityPredicate | `String` | The security predicate of the target dataset. | Small, 38.0 | 38.0 |
| schedule | `String` | The schedule cron expression for the current dataflow. | Small, 38.0 | 38.0 |
| scheduleAttributes | `Schedule` | The schedule for the recipe. | Small, 53.0 | 53.0 |
| scheduleType | `ConnectRecipeScheduleTypeEnum` | The schedule type of the recipe. Valid values are: • EventDriven • TimeDriven | Small, 49.0 | 49.0 |
| sourceDataflow | `String` | The dataflow used to upconvert or revert the current recipe. | Small, v51.0 | 51.0 |
| sourceRecipe | `String` | The recipe used to upconvert or revert the current recipe. | Small, 50.0 | 50.0 |
| status | `ConnectRecipeStatusEnum` | The status of the recipe. Valid values are: • Cancelled • Failure • New (Never run or has no recent run) • Queued • Running • Success • Warning | Small, 54.0 | 54.0 |
| targetDataflowId | `String` | The target dataflow ID. | Small, 42.0 | 42.0 |
| validationDetails | `RecipeValidationDetail[]` | The collection of validation details for a Data Prep recipe. This property isn't supported for Data Prep Classic recipes. | Small, 50.0 | 50.0 |

## Recommendation Node

A recommendation node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `RecommendationParameters` | The parameters for the node. | Small, 53.0 | 53.0 |

## Recommendation Parameters

The parameters for a recommendation node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| custIdField | `String` | The customer ID field. | Small, v53.0 | 53.0 |
| excludePreviousRecommendations | `Boolean` | Indicates whether to exclude previous recommendations (true) or not (false). | Small, v53.0 | 53.0 |
| productIdField | `String` | The product ID field. | Small, v53.0 | 53.0 |
| productRecommendations | `Integer` | The product recommendations field. | Small, v53.0 | 53.0 |
| ratingField | `String` | The rating field. | Small, v53.0 | 53.0 |
| targetField | `RecipeNameLabel` | The target field. | Small, v53.0 | 53.0 |
| targetRankField | `RecipeNameLabel` | The target rank field. | Small, v53.0 | 53.0 |
| targetRatingField | `RecipeNameLabel` | The target rating field. | Small, v53.0 | 53.0 |
| useImplicitRatings | `Boolean` | Indicates whether to use implicit ratings (true) or not (false). | Small, v53.0 | 53.0 |

## Sample Parameters

The sample parameters for loading data.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| filters | `FilterParameters` | The sample filters. | Small, v55.0 | 55.0 |
| sortBy | `String[]` | A list of fields to sort sample. | Small, v55.0 | 55.0 |
| sortDirection | `RecipeSortOrderEnum` | The sample sort direction. Valid values are: • Ascending • Descending | Small, v55.0 | 55.0 |
| sampleType | `SampleType` | The recipe sample type. Valid values are: • Custom • Random • TopN • Unique | Small, v55.0 | 55.0 |
| uniqueSampleFieldName | `String` | The field name for a unique sample. | Small, v55.0 | 55.0 |

## Save Dataset

The dataset for a save node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| folderName | `String` | The analytics folder for the dataset. | Small, v51.0 | 51.0 |
| isStaged | `Boolean` | Indicates whether the data is staged (true) or not (false). | Small, v53.0 | 53.0 |
| label | `String` | The label for the dataset. | Small, v51.0 | 51.0 |
| name | `String` | The name of the dataset. | Small, v51.0 | 51.0 |
| rowLevelSecurityFilter | `String` | The security predicate. | Small, v51.0 | 51.0 |
| rowLevelSharingSource | `String` | The sObject security sharing source. | Small, v51.0 | 51.0 |
| type | `String` | The type of the dataset. | Small, v51.0 | 51.0 |

## Save Node

A save data node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `SaveParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Save Parameters

The parameters for a save node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| dataset | `SaveDataset` | The dataset to save. | Small, v51.0 | 51.0 |
| dateConfigurationName | `String` | The date configuration name. | Small, v55.0 | 55.0 |
| fields | `String[]` | The list of fields to save. | Small, v51.0 | 51.0 |
| measuresToCurrencies | `MeasureToCurrency[]` | A list of the measures to currencies. | Small, v56.0 | 56.0 |

## Schema Field Format Symbols

The field format symbols for a schema node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| currencySymbol | `String` | The currency symbol format. | Small, v51.0 | 51.0 |
| decimalSymbol | `String` | The decimal symbol format. | Small, v51.0 | 51.0 |
| groupingSymbol | `String` | The grouping symbol format. | Small, v51.0 | 51.0 |

## Schema Field

The field for a schema node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| errorValue | `String` | The value to output on error. | Small, v52.0 | 52.0 |
| name | `String` | The schema field name. | Small, v49.0 | 49.0 |
| newProperties | `SchemaFieldNewProperties` | The new schema field properties. | Small, v49.0 | 49.0 |

## Schema Field New Properties

The new field properties for a schema node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| label | `String` | The schema field property label. | Small, v49.0 | 49.0 |
| name | `String` | The schema field property name. | Small, v49.0 | 49.0 |
| typeProperties | `SchemaFieldTypeProperties` | The new schema field type properties. | Small, v49.0 | 49.0 |

## Schema Field Type Properties

The field type properties for a schema node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| format | `String` | The DateTime format. | Small, v51.0 | 51.0 |
| length | `Integer` | The total length of the text. | Small, v51.0 | 51.0 |
| precision | `Integer` | The length of an arbitrary precision value. | Optional | 51.0 |
| scale | `Integer` | The number of digits to the right of the decimal point. | Small, v51.0 | 51.0 |
| symbols | `SchemaFieldFormatSymbols` | The number format. | Small, v51.0 | 51.0 |
| type | `RecipeDataType` | The recipe data type. Valid values are: • DateOnly • DateTime • Multivalue • Number • Text | Small, v51.0 | 51.0 |

## Schema Node

A schema node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| fields | `SchemaParameters[]` | The schema fields for the node. | Small, v51.0 | 51.0 |

## Schema Parameters

The parameters for a schema node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| fields | `SchemaField[]` | The schema fields for the node. | Small, v51.0 | 51.0 |
| slice | `SchemaSlice` | The schema slice definition for the node. | Small, v51.0 | 51.0 |

## Schema Slice

The slice definition for a schema node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| fields | `String[]` | The list of fields for SELECT or DROP. | Small, v51.0 | 51.0 |
| ignoreMissingFields | `Boolean` | Indicates whether the node action ignores missing fields (true) or not (false). | Small, v51.0 | 51.0 |
| mode | `String` | The slice mode. Valid values are: • SELECT • DROP | Small, v51.0 | 51.0 |

## Split Node

A split node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `SplitParameters` | The parameters for the node. | Small, 49.0 | 49.0 |

## Split Parameters

The parameters for a split node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| delimiter | `String` | The split delimiter. | Small, v51.0 | 51.0 |
| sourceField | `String` | The source field. | Small, v51.0 | 51.0 |
| targetFields | `RecipeNameLabel[]` | The list of target fields. | Small, v51.0 | 51.0 |

## SQL Filter Node

A SQL filter node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `SQLFilterParameters` | The parameters for the node. | Small, 53.0 | 53.0 |

## SQL Filter Parameters

The parameters for a SQL filter node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| sqlFilterExpression | `String` | The SQL filter expression. | Small, v53.0 | 53.0 |

## SQL Formula Date Field

The SQL formula date field for a recipe node. **Inherits** SQL Formula Field.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| format | `String` | The format for the date field. | Small, v51.0 | 51.0 |

## SQL Formula Field

The base SQL formula field for a recipe node. **Inherited by** SQL Formula Date Field, SQL Formula Multivalue Field, SQL Formula Numeric Field, and SQL Formula Text Field.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| defaultValue | `String` | The default value for the field. | Small, v51.0 | 51.0 |
| formulaExpression | `String` | The formula expression. | Small, v51.0 | 51.0 |
| label | `String` | The formula label. | Small, v51.0 | 51.0 |
| name | `String` | The formula name. | Small, v51.0 | 51.0 |
| type | `RecipeDataType` | The recipe data type. Valid values are: • DateOnly • DateTime • Multivalue • Number • Text | Small, v51.0 | 51.0 |

## SQL Formula Parameters

The SQL formula parameters for a formula. **Inherits** Formula Parameters.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| fields | `SQLFormulaField[]` | The list of fields. | Required | 51.0 |

## SQL Formula Multivalue Field

The SQL formula multivalue field for a recipe node. **Inherits** SQL Formula Field.

> 자체 프로퍼티 없음 — SQL Formula Field에서 상속한 프로퍼티만 갖는다.

## SQL Formula Numeric Field

The SQL formula numeric field for a recipe node. **Inherits** SQL Formula Field.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| precision | `Integer` | The precision for the numeric field. | Small, v51.0 | 51.0 |
| scale | `Integer` | The scale for the numeric field. | Small, v51.0 | 51.0 |

## SQL Formula Text Field

The SQL formula text field for a recipe node. **Inherits** SQL Formula Field.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| precision | `Integer` | The precision for the text field. | Small, v51.0 | 51.0 |

## Streaming Parameters

The streaming parameters for data output.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| outputMode | `OutputModeEnum` | The output mode. Valid values are: • Append • Complete • Update | Small, 57.0 | 57.0 |
| triggerIntervalSec | `Integer` | The trigger interval in seconds. | Small, 57.0 | 57.0 |
| triggerType | `TriggerTypeEnum` | The trigger type. Valid values are: • Fixed | Small, 57.0 | 57.0 |

## Target Field

A target field for a recipe bucket.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| label | `String` | The label for the field. | Small, 64.0 | 64.0 |
| name | `String` | The name for the field. | Small, 64.0 | 64.0 |
| type | `RecipeDataType` | The data type. Valid recipe data types are: • DateOnly • DateTime • Multivalue • Number • Text | Small, 64.0 | 64.0 |

## Time Series Node

A time series node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `TimeSeriesParameters` | The parameters for the node. | Small, 52.0 | 52.0 |

## Time Series Output Confidence Interval High Low

A confidence interval for a time series recipe node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| high | `RecipeNameLabel` | The high confidence interval. | Small, v52.0 | 52.0 |
| low | `RecipeNameLabel` | The low confidence interval. | Small, v52.0 | 52.0 |

## Time Series Parameters

The parameters for a time series node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| confidenceInterval | `RecipeTimeSeriesConfidenceIntervalType` | The confidence interval. Valid values are: • Eighty • NinetyFive • None | Small, v51.0 | 51.0 |
| confidenceIntervalFields | `Map<String, TimeSeriesOutputConfidenceIntervalHighLow>` | The confidence interval field name and labels. | Small, v52.0 | 52.0 |
| dayField | `String` | The day field. | Small, v51.0 | 51.0 |
| forecastFields | `String[]` | The list of forecast fields. | Small, v51.0 | 51.0 |
| forecastLength | `Integer` | The forecast length. | Small, v51.0 | 51.0 |
| groupDatesBy | `RecipeGroupDatesBy` | The value to group dates by. Valid values are: • Year • YearMonth • YearMonthDay • YearQuarter • YearWeek | Small, v51.0 | 51.0 |
| ignoreLastTimePeriod | `Boolean` | Indicates whether to ignore the last time period (true) or not (false). | Small, v51.0 | 51.0 |
| model | `RecipeTimeSeriesModel` | The time series model. Valid values are: • Additive • Auto • Multiplicative | Small, v51.0 | 51.0 |
| seasonality | `Integer` | The seasonality. | Small, v51.0 | 51.0 |
| subYearField | `String` | The sub year field. | Small, v51.0 | 51.0 |
| targetDateField | `RecipeNameLabel` | The target date field. | Small, v51.0 | 51.0 |
| targetForecastFields | `RecipeNameLabel[]` | The list of target forecast fields. | Small, v51.0 | 51.0 |
| yearField | `String` | The year field. | Small, v51.0 | 51.0 |

## Time Series V2 Algorithm Parameters

The algorithm parameters for a time series version 2 node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| model | `RecipeTimeSeriesModel` | The time series model. Valid values are: • Additive • Auto • Multiplicative | Small, v54.0 | 54.0 |
| seasonality | `Integer` | The seasonality value. | Small, v54.0 | 54.0 |

## Time Series V2 Forecast Info

The forecast information for a time series version 2 node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| aggregate | `Aggregate` | The aggregate data. | Small, v54.0 | 54.0 |
| confidenceIntervalFields | `TimeSeriesOutputConfidenceIntervalHighLow` | The confidence interval field name and labels. | Small, v54.0 | 54.0 |
| forecastField | `RecipeNameLabel` | The aggregate data. [sic — Time Series V2 Forecast Info aggregate와 동일 설명이 중복됨] | Small, v54.0 | 54.0 |

## Time Series V2 Node

A time series version 2 node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `TimeSeriesV2Parameters` | The parameters for the node. | Small, 54.0 | 54.0 |

## Time Series V2 Parameters

The parameters for a time series version 2 node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| algorithm | `TimeSeriesV2ForecastAlgorithmEnum` | The forecast algorithm. Valid values are: • HoltWinters | Small, v54.0 | 54.0 |
| algorithmParameters | `TimeSeriesV2AlgorithmParameters` | The parameters for the algorithm. | Small, v54.0 | 54.0 |
| confidenceInterval | `RecipeTimeSeriesConfidenceIntervalType` | The confidence interval. Valid values are: • Eighty • NinetyFive • None | Small, v54.0 | 54.0 |
| forecastDateField | `String` | The forecast date field. | Small, v54.0 | 54.0 |
| forecastDatesBy | `RecipeGroupDatesBy` | The value to group dates by. Valid values are: • FiscalYear • FiscalYearMonth • FiscalYearQuarter • FiscalYearWeek • YearMonth • YearMonthDay • YearQuarter • YearWeek | Small, v54.0 | 54.0 |
| forecastFields | `TimeSeriesV2ForecastInfo[]` | The list of forecast fields. | Small, v54.0 | 54.0 |
| forecastLength | `Integer` | The forecast length. | Small, v54.0 | 54.0 |
| forecastLengthType | `TimeSeriesV2ForecastLengthTypeEnum` | The forecast length type. Valid values are: • Rolling | Small, v54.0 | 54.0 |
| groupingFields | `ExtractParameter[]` | The list of partition groupings. | Small, v54.0 | 54.0 |
| partialDataHandling | `TimeSeriesV2PartialDataHandlingEnum` | The partial data handling value. Valid values are: • IgnoreLast • None | Small, v54.0 | 54.0 |
| targetDateField | `RecipeNameLabel` | The target date field. | Small, v54.0 | 54.0 |

## Typecast Node

A typecast node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `TypecastParameters` | The parameters for the node. | Small, 51.0 | 51.0 |

## Typecast Parameters

The parameters for a typecast node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| fields | `SchemaField[]` | The list of fields to typecast. | Small, v51.0 | 51.0 |

## Typographic Cluster

The configuration for a typographic cluster algorithm. **Inherits** AbstractBucketAlgorithm.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| distanceThreshold | `Integer` | The edit distance [sic — 원문 문장 미완결] | Small, v52.0 | 52.0 |
| ignoreCase | `Boolean` | Indicates whether to ignore case (true) or not (false). | Small, v52.0 | 52.0 |

## Update Data Cloud Object Node

A Data 360 object update node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `UpdateDataCloudObjectParameters` | The parameters for the node. | Small, v66.0 | 66.0 |

## Update Data Cloud Object Parameters

The parameters for an update data cloud object node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| connectorType | `ConnectWaveDataConnectorTypeEnum` | The connector type. Valid values are: (39값 — [[Recipe REST API — Enums]] 참조) | Small, v66.0 | 66.0 |
| fieldMappings | `List[OutputDataCloudFieldsMapping]` | The list of the Data 360 field mappings. | Small, v66.0 | 66.0 |
| name | `String` | The name of the Data 360 object to update. | Small, v66.0 | 66.0 |
| operation | `OperationEnum` | The update operation. Valid values are: • Append • Delete • Upsert | Small, v66.0 | 66.0 |
| primaryKey | `String` | The name of the primary key field. | Small, v66.0 | 66.0 |
| type | `RecipeDataCloudOutputTypeEnum` | The output type. Valid values are: • DateLakeObject [sic] | Small, v66.0 | 66.0 |

## Update Node

An update node in a recipe. **Inherits** Recipe Node.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| parameters | `UpdateParameters` | The parameters for the node. | Small, v51.0 | 51.0 |

## Update Parameters

The parameters for an update node in a recipe.

| Property Name | Type | Description | Filter Group and Version | Available Version |
|---|---|---|---|---|
| leftKeys | `String[]` | The list of left keys. | Small, v54.0 | 54.0 |
| rightKeys | `String[]` | The right of left keys. [sic] | Small, v54.0 | 54.0 |
| updateColumns | `Map<String, String>` | The map of columns to update. | Small, v54.0 | 54.0 |

---

## 관련 노트

- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]]
- [[Recipe REST API — Response 표현형 (Bucket~Output)]]
- [[Recipe REST API — Recipe 구성 Input]]
- [[Recipe REST API — Enums]]
