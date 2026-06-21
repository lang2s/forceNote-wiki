---
tags: [analytics, crm-analytics, data-prep, recipe, rest-api, enum]
source: salesforce_recipes_api.pdf (Data Prep Recipe REST API Developer Guide, Summer '26)
created: 2026-06-21
aliases: [Recipe REST API Enums, CRM Analytics Recipe enum, RecipeNodeAction, RecipeDataType, 레시피 enum, Data Prep enum]
---

# Recipe REST API — Enums

> Data Prep Recipe REST API(`/wave/recipes`)에서 요청·응답에 쓰이는 47개 enum의 전수 목록 — 각 enum의 설명과 유효 값(valid value)을 빠짐없이 정리한다.

---

## 버전 정책 (섹션 머리 노트)

> **Enums are not versioned. Enum Values are returned in all API versions. Clients should handle values they don't understand gracefully.**

enum은 버전이 없으며 모든 API 버전에서 동일한 값이 반환된다. 따라서 클라이언트는 새 값이 추가되더라도 **모르는 값을 안전하게(gracefully) 처리**해야 한다 — 알 수 없는 값을 받아도 오류로 처리하지 않도록 설계한다.

네임스페이스: `/wave/recipes`

```jsonc
// 구조 예시 — 실제 동작 설정 아님
// 알 수 없는 enum 값을 안전하게 처리하는 패턴
{
  "nodeAction": "Bucket V2",        // RecipeNodeAction — 모르는 값이면 default 처리
  "dataType": "DateTime",            // RecipeDataType
  "runMode": "Incremental"           // RecipeRunMode / InputRunModeEnum
}
```

---

## ⚠️ 원문 표기 보존 항목

아래 값들은 공식 문서 원문 그대로이며 **임의 수정 금지**다(`[sic]`로 표기).

| Enum | 값 | 비고 |
|---|---|---|
| `RecipeD360OutputType` | `DateLakeObject` | "Date" 철자 — 원문 그대로 [sic] |
| `RecipeNodeAction` | `Bucket V2` | 공백 포함 [sic] |
| `RecipeNodeAction` | `Updatei` | 오타 의심 — 원문 그대로 [sic] |
| `RecipeExportFormat` | `CSV.` | 마침표 포함 [sic] |

---

## Connect 계열 enum

### ConnectAnalyticsLicenseTypeEnum
The Analytics license types.
- `Cdp` (Data 360)
- `DataPipelineQuery` (Data Pipeline Query)
- `EinsteinAnalytics` (CRM Analytics)
- `IntelligentApps` (Intelligent Apps)
- `MulesoftDataPath` (Mulesoft Data Works)
- `Sonic` (Salesforce Data Pipeline)

### ConnectEmailNotificationLevelEnum
Valid types of email notification levels you can set.
- `Always` · `Failures` · `Never` · `Warnings`

### ConnectRecipeConversionSeverityEnum
The severity of the conversion detail.
- `UserInfo` · `Warning`

### ConnectRecipeExecutionEngineEnum
The recipe's execution engine.
- `V1` · `V2`

### ConnectRecipeFormatTypeEnum
Returns a collection filtered by the format of the current recipe definition.
- `R2` (Data Prep Classic)
- `R3` (Data Prep)

### ConnectRecipePublishingTargetEnum
The target format or system to publish the recipe to.
- `Dataset` (Publish to Dataset)

### ConnectRecipeScheduleTypeEnum
The schedule type of the recipe.
- `EventDriven` · `TimeDriven`

### ConnectRecipeStatusEnum
The status of the recipe.
- `Cancelled` · `Failure` · `New` (Never run or has no recent run) · `Queued` · `Running` · `Success` · `Warning`

### ConnectRecipeValidationContextEnum
The recipe validation context.
- `Default` · `Editor`

### ConnectWaveDataConnectorTypeEnum
The type of Analytics connector. (39개 전수)
- `AmazonAthena` · `AmazonRedshiftOutput` · `AmazonS3` · `AmazonS3Output` · `AmazonS3Private` · `AwsRdsAuroraMySQL` · `AwsRdsAuroraPostgres` · `AwsRdsMariaDB` · `AwsRdsMySQL` · `AwsRdsPostgres` · `AwsRdsSqlServer` · `AzureDataLakeGen2Output` · `AzureSqlDatabase` · `AzureSqlDatawarehouse` · `Databricks` (Beta) · `GoogleAnalytics4` · `GoogleBigQuery` · `GoogleBigQueryDirect` · `GoogleBigQueryStandardSQL` · `GoogleSpanner` · `HerokuPostgres` · `HubSpot` · `MarketoV2` · `NetSuite` · `OracleEloqua` · `Redshift` · `RedshiftPrivate` · `SalesforceExternal` · `SalesforceMarketingCloudOAuth2` · `SapHanaCloud` · `SfdcLocal` · `SnowflakeComputing` · `SnowflakeDirect` · `SnowflakeOutput` · `SnowflakePrivate` · `SnowflakePrivateOutput` · `TableauOnline` · `TableauHyperOutput` · `Zendesk`

### ConnectWaveSortOrderTypeEnum
The type of sort order to be applied to the returned collection. (PDF에서 sort 파라미터 표 구조로 제시, Required or Optional = Optional. 18개 전수)
- `App` · `CreatedBy` · `CreatedById` · `CreatedDate` · `FolderName` · `LastModified` · `LastModifiedBy` · `LastModifiedById` · `LastModifiedDate` · `Location` · `Mru` (Most Recently Used, last viewed date) · `Name` · `Outcome` · `RefreshDate` (for assets like datasets) · `RunDate` (for assets like reports) · `Status` · `Title` · `Type`

### ConnectionModeEnum
The mode for accessing connected datasets.
- `AUTO` · `DIRECT` · `SYNCED`

---

## 노드/액션 계열 enum

### RecipeNodeAction
The recipe node action. ("Valid recipe actions are:") (34개 전수)
- `Aggregate` · `Append` · `Append_V2` · `Bucket` · `Bucket V2` [sic — 공백 포함, 원문 그대로] · `Clustering` · `ComputeRelative` · `DateFormatConversion` · `DetectSentiment` · `DiscoveryPredict` · `Export` · `Extension` · `Extract` · `Filter` · `Flatten` · `Formula` · `Join` · `Load` · `OptimizedAppendOutput` · `OptimizedUpdateOutput` · `OutputD360` · `OutputExternal` · `PredictMissingValues` · `Recommendation` · `Save` · `Schema` · `Split` · `SqlFilter` · `TimeSeries` · `TimeSeriesV2` · `TypeCast` · `Updatei` [sic — 오타 의심, 원문 그대로] · `UpdateDataCloudObject` · `WriteDataCloudObject`

### RecipeAggregateNodeEnum
The aggregate type for the node.
- `Hierarchical` · `Standard`

### RecipeAggregateType
The recipe aggregation type.
- `Avg` · `Count` · `Maximum` · `Median` · `Minimum` · `StdDev` · `StdDevP` · `Sum` · `Unique` · `Var` · `VarP`

### RecipeJoinType
The join type.
- `Cross` · `Inner` · `LeftOuter` · `Lookup` · `MultiValueLookup` · `Outer` · `RightOuter`

### RecipeSliceMode
The slice mode.
- `SELECT` · `DROP`

### RecipeSortOrderEnum
The recipe sort order.
- `Ascending` · `Descending`

### SampleType
The recipe sample type.
- `Custom` · `Random` · `TopN` · `Unique`

---

## 버킷/클러스터링 계열 enum

### RecipeBucketAlgorithmType
The recipe bucket field algorithm type.
- `TypographicClustering`

### RecipeBucketGrain
The recipe bucket date grain type.
- `AbsoluteDate` · `Days` · `FiscalQuarters` · `FiscalYears` · `Months` · `Quarters` · `Weeks` · `Years`

### MeasureScalingTypeEnum
The scaling type.
- `MinMaxScaling`

---

## 데이터 타입/날짜 계열 enum

### RecipeDataType
The recipe data type.
- `DateOnly` · `DateTime` · `Multivalue` · `Number` · `Text`

### RecipeDateGrain
The extract grain type.
- `Day` · `DayEpoch` · `FiscalMonth` · `FiscalQuarter` · `FiscalWeek` · `FiscalYear` · `Hour` · `Minute` · `Month` · `Quarter` · `Second` · `SecondEpoch` · `Week` · `Year`

### RecipeGroupDatesBy
The value to group dates by.
- `Year` · `YearMonth` · `YearMonthDay` · `YearQuarter` · `YearWeek`

### RecipeGroupDatesByV2
The value to group dates by.
- `FiscalYear` · `FiscalYearMonth` · `FiscalYearQuarter` · `FiscalYearWeek` · `YearMonth` · `YearMonthDay` · `YearQuarter` · `YearWeek`

### RecipeConfigurationFiscalOffsetYearBasedOnEnum
The recipe configuration fiscal offset year based on type.
- `End` · `Start`

### RecipeConfigurationFiscalTypeEnum
The recipe configuration fiscal type.
- `Offset`

---

## 입력/출력/실행 계열 enum

### InputRunModeEnum
The input run mode.
- `Full` · `Incremental` · `Streaming`

### RecipeRunMode
The recipe run mode.
- `Full` · `Incremental` · `Streaming`

### OperationEnum
The operation type for append.
- `Append` · `Delete` · `Upsert`

### OutputModeEnum
The output mode.
- `Append` · `Complete` · `Update`

### RecipeOutputExternalOperation
The output external operation type.
- `Empty` · `Insert` · `Update` · `Upsert`

### RecipeDatasetType
The type of the dataset.
- `Analytics` · `Connected` · `DataLakeObject` · `DataModelObject`

### RecipeD360OutputType
The output type.
- `DateLakeObject` [sic — "Date" 철자, 원문 그대로]

### RecipeDataCloudOutputTypeEnum
The output type.
- `DataLakeObject` · `DataModelObject`

### TriggerTypeEnum
The trigger type.
- `Fixed`

---

## Export 계열 enum

### RecipeExportFormat
The format of the export.
- `CSV.` [sic — 마침표 포함, 원문 그대로]

### RecipeExportCsvHeaderRowValueType
The type of the recipe export CSV header row value.
- `FullyQualifiedName` · `Label`

---

## 수식(Formula) 계열 enum

### RecipeFormulaExpressionType
The formula expression type.
- `Legacy` · `Sql`

---

## 감성 분석(Sentiment) 계열 enum

### DetectSentimentOutputTypeEnum
The output type.
- `Dimension` · `Measure`

### SentimentScoreTypeEnum
The sentiment score type.
- `All` · `None`

---

## 시계열(Time Series) 계열 enum

### RecipeTimeSeriesConfidenceIntervalType
The confidence interval.
- `Eighty` · `NinetyFive` · `None`

### RecipeTimeSeriesModel
The time series model.
- `Additive` · `Auto` · `Multiplicative`

### TimeSeriesV2ForecastAlgorithmEnum
The forecast algorithm.
- `HoltWinters`

### TimeSeriesV2ForecastLengthTypeEnum
The forecast length type.
- `Rolling`

### TimeSeriesV2PartialDataHandlingEnum
The partial data handling value.
- `IgnoreLast` · `None`

---

## 관련 노트
- [[Data Prep Recipe REST API — 개요·인증·엔드포인트]] — 도메인 허브 (개요·인증·엔드포인트)
- [[Recipe REST API — Bucket·Cluster 노드 Input]] — 이 enum들을 참조하는 대표 노드 Input 노트
- [[Recipe REST API — Response 표현형 (Bucket~Output)]] — 이 enum들을 참조하는 대표 Response 표현형 노트
