---
tags: [einstein, einstein-discovery, rest-api, response-body, story, insights, narrative, reference]
source: bi_dev_guide_rest_sdd.pdf (Einstein Discovery REST API Developer Guide — Response Bodies)
created: 2026-07-19
aliases: [Story, Story Query, Story Insights, Story Chart, Story Field Value, Story Narrative, Descriptive Insights, 응답 표현형 스토리]
---

# Einstein Discovery REST — 응답 표현형 — 스토리·인사이트

> Einstein Discovery REST 응답 바디 중 Story·Insights(Descriptive/Count/Second Order)·Chart·Field Value·Narrative Element 계열 표현형 프로퍼티 전수. (편향/First Order Insights는 지표 노트 소관.)

---

이 노트는 Einstein Discovery REST API 응답 바디 중 **스토리(Story) 인사이트 계열** 표현형을 다룬다. 각 표현형은 프로퍼티명·타입·설명·Filter Group·Available Version을 원문 그대로 전사한다. 상속 관계(`Inherits properties from` / `Inherited by`)와 enum의 `Valid values`도 전수 보존한다.

> **⛔ 이 노트의 담당 범위 밖 (지표·편향 노트 소관):** `Story First Order Insights`, `Story Potential Bias`, `Story Query Diagnostic Insights`, `Story Query Disparate Impact`, `Story Query Disparate Impact Detail` — 편향(bias)·disparate impact 계열은 [[Einstein Discovery REST — 모델 품질·편향 지표 표현형|모델 품질·편향 지표 표현형]]에 있다.

> ⚠️ 아래 표의 `⚠️(...)` 주석은 원본 PDF의 오기·복붙 오류로 의심되는 지점을 표시한 것이다(원문 값은 그대로 보존).

---

## 추상 베이스 표현형 (Abstract)

### Abstract Story Data Property
The base Einstein Discovery story data property filter. **Inherited by** Story All Other Field Value, Story Day Field Value, Story Day Of Week Field Value, Story Field Only, Story Month Field Value, Story Month Of Year Field Value, Story Null Field Value, Story Quarter Field Value, Story Quarter Of Year Field Value, Story Range Field Value, Story Text Field Value, and Story Year Field Value.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| field | String | The filter field developer name. | Small, 52.0 | 52.0 |
| type | String | The filter field type. | Small, 52.0 | 52.0 |

### Abstract Story Insights Case
The base story insights case. **Inherited by** StoryDescriptiveInsightsCase and StoryCountInsightsCase.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| field | StoryFieldLabelValueProperty | The case field for the story insight. | Small, 54.0 | 54.0 |
| type | StoryAnalysisTypeEnum | The analysis type. Valid values are: • Count • Descriptive | Small, 52.0 | 52.0 |
| value | String | The field value for the story insight. | Small, 52.0 | 52.0 |

### Abstract Story Insights
The base story insights. **Inherited by** StoryFirstOrderInsights and StorySecondOrderInsights.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| chart | StoryChart | The insights chart for the story. | Small, 54.0 | 54.0 |
| details | StoryInsightsDetail[] | A list of insight details for the story. | Small, 52.0 | 52.0 |
| filterField | StoryFieldLabelValueProperty | The insights filter field details for the story. | Small, 52.0 | 52.0 |
| narrative | StoryNarrative | The insights narrative for the story. | Small, 54.0 | 54.0 |
| type | InsightsResultsTypeEnum | The descriptive insights result type. Valid values are: • FirstOrder • SecondOrder | Small, 52.0 | 52.0 |

### Abstract Story Narrative Element
The base story narrative element. **Inherited by** StoryNarrativeElementText.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| type | StoryNarrativeElementTypeEnum | The narrative element type. Valid values are: • BadSelection • Body • BucketsMismatchSection • GoodSection • Heading • MissingValuesSection • NewValuesSection • NumberedList • OutcomeValue • Paragraph • SubHeading • UnorderedList | Small, 54.0 | 54.0 |

### Abstract Story Source
The base Einstein Discovery analysis source. **Inherited by** AnalyticsDatasetSource and ReportSource.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| type | AnalysisSetupSourceTypeEnum | The source type of the analysis. Valid values are: • AnalyticsDataset • LiveDataset • Report | Small, 45.0 | 45.0 |

---

## 스토리 요약·상세 (Summary / Details / Correlation)

### Story Summary Detail
The summary detail for a story. (⚠️ featureImportances 프로퍼티는 ModelFieldLabelMetrics[]를 참조하나 이 표현형 자체는 스토리 소관 — 추출.)

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| averageOutcome | Double | The statistical mean for outcome variable. | Small, 51.0 | 51.0 |
| correlations | StoryFieldCorrelation[] | A summary of each field in the dataset selected for story creation. | Small, 51.0 | 51.0 |
| featureImportances | ModelFieldLabelMetrics[] | A list of importance metrics for the AI model. | Small, 56.0 | 56.0 |
| negativeFactors | StoryDetails[] | A list of the top negative factors contributing to the outcome. | Small, 51.0 | 51.0 |
| positiveFactors | StoryDetails[] | A list of the top positive factors contributing to the outcome. | Small, 51.0 | 51.0 |
| rowCount | Long | The total number of rows in the dataset. | Small, 51.0 | 51.0 |
| url | String | The URL for the story summary detail. | Small, 51.0 | 51.0 |

### Story Details
The details for a story. These details are the top positive and negative factors contributing to story outcome.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| condition | StoryField[] | The field value combination that contributed to the outcome result. | Small, 51.0 | 51.0 |
| count | Long | The count of the condition records. | Small, 51.0 | 51.0 |
| diffFromAverage | Double | The difference between the mean and the global average for analysis with outcome. | Small, 51.0 | 51.0 |
| diffFromExpected | Double | The difference between the mean and the global average for count analysis. | Small, 51.0 | 51.0 |
| diffFromUsual | Double | The difference between the mean with constraing and without constraint for count analysis. ⚠️(원문 "constraing" 오타) | Small, 51.0 | 51.0 |
| percentage | Double | The percentage value. | Small, 51.0 | 51.0 |
| rateOfOccurrence | Double | The occurrence count. | Small, 51.0 | 51.0 |
| score | Double | The score of the condition field. | Small, 51.0 | 51.0 |

### Story Field Correlation
The summary of each field in the dataset selected for story creation.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| correlationToOutcome | Double | The field correlation to outcome value. | Small, 51.0 | 51.0 |
| fieldLabel | String | The label for the dataset field. | Small, 51.0 | 51.0 |
| fieldName | String | The name for the dataset field. | Small, 51.0 | 51.0 |

---

## 필드 값 데이터 프로퍼티 (Story Field Value 계열)

모두 `AbstractStoryDataProperty`를 상속한다(field·type 프로퍼티는 베이스 참조). 아래는 각 타입이 **추가로** 갖는 프로퍼티다.

### Story All Other Field Value
The story data property for all other values in a field. **Inherits properties from** AbstractStoryDataProperty. (자체 추가 프로퍼티 없음.)

### Story Field Only
The story data field property. **Inherits properties from** AbstractStoryDataProperty. (자체 추가 프로퍼티 없음.)

### Story Null Field Value
The story data null property. **Inherits properties from** AbstractStoryDataProperty. (자체 추가 프로퍼티 없음.)

### Story Text Field Value
The story data text property. **Inherits properties from** AbstractStoryDataProperty.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| value | String | The text value of the field. | Small, 52.0 | 52.0 |

### Story Range Field Value
The story data range property. **Inherits properties from** AbstractStoryDataProperty.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| endValue | String | The end value of the range. | Small, 52.0 | 52.0 |
| startValue | String | The start value of the range. | Small, 52.0 | 52.0 |

### Story Day Field Value
The story data day property. **Inherits properties from** AbstractStoryDataProperty.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| day | Integer | The day in numeric value. | Small, 52.0 | 52.0 |
| fiscal | Boolean | Indicates whether the value is in a fiscal year (true) or not (false). | Small, 52.0 | 52.0 |
| month | Integer | The month in numeric value. | Small, 52.0 | 52.0 |
| rawValue | String | The raw value of the field. | Small, 52.0 | 52.0 |
| year | Integer | The year in numeric value. | Small, 52.0 | 52.0 |

### Story Day of Week Field Value
The story data day of week property. **Inherits properties from** AbstractStoryDataProperty.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| dayOfWeek | Integer | The day of week in numeric value. | Small, 52.0 | 52.0 |
| rawValue | String | The raw value of the field. | Small, 52.0 | 52.0 |

### Story Month Field Value
The story data month property. **Inherits properties from** AbstractStoryDataProperty.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| fiscal | Boolean | Indicates whether the value is in a fiscal year (true) or not (false). | Small, 52.0 | 52.0 |
| month | Integer | The month in numeric value. | Small, 52.0 | 52.0 |
| rawValue | String | The raw value of the field. | Small, 52.0 | 52.0 |
| year | Integer | The year in numeric value. | Small, 52.0 | 52.0 |

### Story Month of Year Field Value
The story data month of year property. **Inherits properties from** AbstractStoryDataProperty.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| month | Integer | The month of year in numeric value. | Small, 52.0 | 52.0 |
| rawValue | String | The raw value of the field. | Small, 52.0 | 52.0 |

### Story Quarter Field Value
The story data quarter property. **Inherits properties from** AbstractStoryDataProperty.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| fiscal | Boolean | Indicates whether the value is in a fiscal year (true) or not (false). | Small, 52.0 | 52.0 |
| quarter | Integer | The quarter in numeric value. | Small, 52.0 | 52.0 |
| rawValue | String | The raw value of the field. | Small, 52.0 | 52.0 |
| year | Integer | The year in numeric value. | Small, 52.0 | 52.0 |

### Story Quarter of Year Field Value
The story data quarter of year property. **Inherits properties from** AbstractStoryDataProperty.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| fiscal | Boolean | Indicates whether the value is in a fiscal year (true) or not (false). | Small, 52.0 | 52.0 |
| quarter | Integer | The quarter in numeric value. | Small, 52.0 | 52.0 |
| rawValue | String | The raw value of the field. | Small, 52.0 | 52.0 |

### Story Year Field Value
The story data year property. **Inherits properties from** AbstractStoryDataProperty.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| fiscal | Boolean | Indicates whether the value is in a fiscal year (true) or not (false). | Small, 52.0 | 52.0 |
| rawValue | String | The raw value of the field. | Small, 52.0 | 52.0 |
| year | Integer | The year in numeric value. | Small, 52.0 | 52.0 |

---

## 필드 참조 표현형 (Field / Impact)

### Story Field
The field value combination that contributed to the story outcome result.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| fieldName | String | The name for the story field. | Small, 51.0 | 51.0 |
| property | AbstractStoryDataProperty | The field property. Valid values are: • Story All Other Field Value • Story Day Field Value • Story Day Of Week Field Value • Story Field Only • Story Month Field Value • Story Month Of Year Field Value • Story Null Field Value • Story Quarter Field Value • Story Quarter Of Year Field Value • Story Range Field Value • Story Text Field Value • Story Year Field Value | Small, 52.0 | 52.0 |
| type | StoryFieldDetailTypeEnum | The field type. Valid values are: • Field • Outcome | Small, 54.0 | 54.0 |
| value | String | The value for the field. | Small, 51.0 | 51.0 |

### Story Field Label Value Property
A story field.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| label | String | The label for the story field. | Small, 52.0 | 52.0 |
| property | AbstractStoryDataProperty | The data property of the story field. Valid values are: • Story Day Field Value • Story Day Of Week Field Value • Story Field Only • Story Month Field Value • Story Month Of Year Field Value • Story Null Field Value • Story Quarter Field Value • Story Quarter Of Year Field Value • Story Range Field Value • Story Text Field Value • Story Year Field Value | Small, 52.0 | 52.0 |
| value | String | The value for the story field. | Small, 52.0 | 52.0 |

### Story Field Impact Detail
A story field impact details.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| impactField | StoryFieldLabelValueProperty | A details of the field impacting the story result. | Small, 52.0 | 52.0 |

---

## 인사이트 (Insights)

### Story Insights Detail
The insights detail for a story.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| cases | AbstractStoryInsightsCase[] | A list of story insights cases. Valid values are: • StoryDescriptiveInsightsCase • StoryCountInsightsCase | Small, 52.0 | 52.0 |
| category | InsightsResultCategoryEnum | The insights result category. Valid values are: • Negative • Positive | Small, 52.0 | 52.0 |
| comparedWith | InsightsComparisonEnum | The insights score comparison criteria. Valid values are: • Average • Other • UniformDistribution | Small, 52.0 | 52.0 |
| hasMoreCases | Boolean | Indicates whether there are more cases (true) or not (false). | Small, 55.0 | 55.0 |
| outcomeClass | String | The outcome class for the story insight. | Small, 55.0 | 55.0 |

### Story Descriptive Insights Case
A descriptive story insights case. **Inherits properties from** AbstractStoryInsightsCase.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| change | Double | The changed value for the insights case | Small, 52.0 | 52.0 |
| frequencyChange | StoryDescriptiveInsightsImpactEnum | The impact on the result. Valid values are: • Improved • Worsened | Small, 52.0 | 52.0 |
| impactDetails | StoryFieldImpactDetail[] | A list of field values that impact the result. | Small, 52.0 | 52.0 |
| mean | Double | The mean value for the insights case | Small, 54.0 | 54.0 |
| rating | StoryDescriptiveInsightsRatingEnum | The score rating of the average outcome. Valid values are: • AboveAverage • BelowAverage • Higher • Lower | Small, 52.0 | 52.0 |

### Story Count Insights Case
A count story insights case. **Inherits properties from** AbstractStoryInsightsCase.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| count | Double | The count for the insights case | Small, 54.0 | 54.0 |
| countChangeFrom | Double | The count change from for the insights case | Small, 54.0 | 54.0 |
| frequency | Double | The summary statistics frequency value for the insights case | Small, 52.0 | 52.0 |
| frequencyChange | StoryCountInsightsFrequencyChangeEnum | The impact due to changed summary value. Valid values are: • Down • Up | Small, 52.0 | 52.0 |
| frequencyChangeFrom | Double | The change in the summary statistics value for the insights case | Small, 52.0 | 52.0 |
| frequencyRate | StoryCountInsightsFrequencyEnum | The occurrence frequency rate for the insights case. Valid values are: • LessOften • MoreOften | Small, 52.0 | 52.0 |
| multiplier | Double | The score of the field value for the insights case | Small, 52.0 | 52.0 |
| sum | Double | The sum value for the insights case | Small, 54.0 | 54.0 |
| sumChangeFrom | Double | The sum change from value for the insights case | Small, 54.0 | 54.0 |

### Story Second Order Insights
The second order insights for a story. **Inherits properties from** AbstractStoryInsights.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| conditionField | StoryFieldLabelValueProperty | The condition field used for second order analysis. | Small, 52.0 | 52.0 |

### Story Diagnostic Insights Detail
The detail for story diagnostic insights. (⚠️ 이름에 "Diagnostic Insights"가 있으나 편향 계열이 아니므로 **제외 대상 아님** — 추출.)

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| category | InsightsResultCategoryEnum | The insights result category. Valid values are: • Negative • Positive | Small, 53.0 | 53.0 |
| conditionRestriction | InsightsConditionRestrictionEnum | The insights condition restriction. Valid values are: • Included • NotIncluded | Small, 53.0 | 53.0 |
| details | DiagnosticInsightsCase[] | A list of the case details for a diagnostic insight. | Small, 53.0 | 53.0 |
| impact | StoryDescriptiveInsightsImpactEnum | The descriptive insights impact for the story. Valid values are: • Improved • Worsened | Small, 53.0 | 53.0 |

### Diagnostic Insights Case
A story query diagnostic insights.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| changeInOutcome | Double | The change in outcome score. | Small, 53.0 | 53.0 |
| fields | StoryFieldLabelValueProperty[] | A list of fields responsible for impact on outcome due to the selected condition. | Small, 53.0 | 53.0 |
| globalMean | Double | The global mean without any condition. | Small, 53.0 | 53.0 |
| hasDemographicChanged | Boolean | Indicates whether the demographic changed due to this case (true) or not (false). | Small, 53.0 | 53.0 |
| meanWithCondition | Double | The mean with the primary condition selected for diagnostic insight. | Small, 53.0 | 53.0 |
| outcomeChangeType | InsightsOutcomeChangeEnum | The change in outcome value. Valid values are: • Decreased • Increased | Small, 53.0 | 53.0 |

---

## 차트 (Chart)

### Story Chart
A story chart.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| categoryLabel | String | The category label for the story chart. | Small, 54.0 | 54.0 |
| metricLabel | String | The metric label for the story chart. | Small, 54.0 | 54.0 |
| values | StoryChartValue[] | A list of the story chart values. | Small, 54.0 | 54.0 |

### Story Chart Value
A value in a story chart.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| classDetails | StoryChartValueDetail[] | A list of the story chart value class specific details. | Small, 54.0 | 54.0 |
| details | StoryChartValueDetail[] | A list of the story chart value details. | Small, 54.0 | 54.0 |
| dimensions | StoryFieldLabelValueProperty[] | A list of the story chart value dimensions. | Small, 54.0 | 54.0 |
| type | StoryChartValueTypeEnum | The story chart value type. Valid values are: • Average • Baseline • Impact • Prediction • SmallTerms • Unexplained • Value | Small, 54.0 | 54.0 |
| value | Double | The value of the story chart. | Small, 54.0 | 54.0 |

### Story Chart Value Detail
The detail for a value in a story chart.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| allOthersCount | Double | The count of all others. | Small, 54.0 | 54.0 |
| allOthersCountRatio | Double | The ratio of the all others count. | Small, 54.0 | 54.0 |
| average | Double | The average of the value. | Small, 54.0 | 54.0 |
| baseCoefficient | Double | The base coefficient of the value. | Small, 54.0 | 54.0 |
| bucketRange | String | The range of the bucket during story version comparison. | Small, 54.0 | 54.0 |
| changeFromAverage | Double | The change from average for the value. | Small, 54.0 | 54.0 |
| changeFromAverageForOtherBuckets | Double | The change from average for other buckets for the value. | Small, 54.0 | 54.0 |
| changeFromExpected | Double | The change from expected for the value. | Small, 54.0 | 54.0 |
| changeFromOverall | Double | The change from overall for the value. | Small, 54.0 | 54.0 |
| changeFromUsual | Double | The change from usual for the value. | Small, 54.0 | 54.0 |
| coefficient | Double | The coefficient for the value. | Small, 54.0 | 54.0 |
| combinedImpact | Double | The impact of combined terms for the value. | Small, 54.0 | 54.0 |
| conditionalFrequency | Double | The conditional frequency for the value. | Small, 54.0 | 54.0 |
| frequency | Double | The frequency for the value. | Small, 54.0 | 54.0 |
| globalCount | Double | The global count for the value. | Small, 54.0 | 54.0 |
| globalMean | Double | The global mean for the value. | Small, 54.0 | 54.0 |
| impact | Double | The impact for the value. | Small, 54.0 | 54.0 |
| isReferenceGroup | Boolean | Indicates whether the value is a reference group (true) or not (false). | Small, 54.0 | 54.0 |
| isSignificantlyDifferent | Boolean | Indicates whether the value is significantly different (true) or not (false). | Small, 54.0 | 54.0 |
| leftFrequency | Double | The left frequency for the value. | Small, 54.0 | 54.0 |
| leftImpact | Double | The left impact for the value. | Small, 54.0 | 54.0 |
| order | Integer | The order for the value. | Small, 54.0 | 54.0 |
| precludedCount | Integer | The precluded count for the value. | Small, 54.0 | 54.0 |
| precludedSum | Double | The precluded sum for the value. | Small, 54.0 | 54.0 |
| ratioDifference | Double | The ratio difference for the value. | Small, 55.0 | 55.0 |
| rightFrequency | Double | The right frequency for the value. | Small, 54.0 | 54.0 |
| rightImpact | Double | The right impact for the value. | Small, 54.0 | 54.0 |
| rowCount | Long | The row count for the value. | Small, 54.0 | 54.0 |
| rowCountRatio | Double | The row count ratio for the value. | Small, 54.0 | 54.0 |
| standardDeviation | Double | The standard deviation for the value. | Small, 54.0 | 54.0 |
| termsCombined | Integer | The number of combined terms for the value. | Small, 54.0 | 54.0 |
| total | Double | The total for the value. | Small, 54.0 | 54.0 |

---

## 내러티브 (Narrative)

### Story Narrative
A narrative for a story.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| body | AbstractStoryNarrativeElement | The body of the narrative. Valid values are: • StoryNarrativeElementText | Small, 54.0 | 54.0 |
| header | AbstractStoryNarrativeElement | The body of the narrative. Valid values are: • StoryNarrativeElementText ⚠️(원문 설명 "The body of..." — header인데 body로 복붙된 오류로 보임) | Small, 54.0 | 54.0 |
| title | AbstractStoryNarrativeElement | The body of the narrative. Valid values are: • StoryNarrativeElementText ⚠️(원문 설명 "The body of..." — title인데 body로 복붙된 오류로 보임) | Small, 54.0 | 54.0 |

### Story Narrative Element Text
The text element for a story narrative. **Inherits properties from** AbstractStoryNarrativeElement.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| conditionField | AbstractStoryDataProperty | The narrative text with data properties. Valid values are: • Story All Other Field Value • Story Day Field Value • Story Day Of Week Field Value • Story Field Only • Story Month Field Value • Story Month Of Year Field Value • Story Null Field Value • Story Quarter Field Value • Story Quarter Of Year Field Value • Story Range Field Value • Story Text Field Value • Story Year Field Value | Small, 54.0 | 54.0 |
| value | String | The value for the narrative text. | Small, 54.0 | 54.0 |

---

## 쿼리 (Query)

### Story Query
A query for story insights.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| descriptiveInsights | AbstractStoryInsights[] | A list of descriptive story insights. Valid values are: • StoryFirstOrderInsights • StorySecondOrderInsights | Small, 52.0 | 52.0 |
| diagnosticInsights | StoryQueryDiagnosticInsights[] | A list of diagnostic story insights. | Small, 53.0 | 53.0 |
| includeChart | Boolean | Indicates whether to include the story chart in the query response (true) or not (false). | Small, 54.0 | 54.0 |
| includeNarrative | Boolean | Indicates whether to include the story narrative in the query response (true) or not (false). | Small, 54.0 | 54.0 |
| includeRegularFields | Boolean | Indicates whether to include regular fields in the query response (true) or not (false). | Small, 54.0 | 54.0 |
| includeSensitiveFields | Boolean | Indicates whether to include sensitive fields in the query response (true) or not (false). | Small, 54.0 | 54.0 |
| limit | Integer | The total number of insight cards in the query response. | Small, 54.0 | 54.0 |
| offset | Integer | The insight card offset value. | Small, 54.0 | 54.0 |
| query | StoryQueryInputParameter | The story query input parameters. | Small, 52.0 | 52.0 |
| totalSize | Integer | The total insight count for the story. | Small, 52.0 | 52.0 |
| url | String | The URL for the story query. | Small, 52.0 | 52.0 |

> ⚠️ `diagnosticInsights`가 참조하는 `StoryQueryDiagnosticInsights`는 편향 계열이라 이 노트 범위 밖 — [[Einstein Discovery REST — 모델 품질·편향 지표 표현형|모델 품질·편향 지표 표현형]] 참조.

### Story Query Input Parameter
The input parameter for a story query.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| filters | AbstractStoryDataPropertyInput[] | A list of filter fields used to query insights. Valid values are: • Story Day Field Value Input • Story Day Of Week Field Value Input • Story Field Only Input • Story Month Field Value Input • Story Month Of Year Field Value Input • Story Null Field Value Input • Story Quarter Field Value Input • Story Quarter Of Year Field Value Input • Story Range Field Value Input • Story Text Field Value Input • Story Year Field Value Input | Small, 52.0 | 52.0 |
| insightsType | InsightsTypeEnum | The insights type. Valid values are: • Descriptive • Diagnostic | Small, 52.0 | 52.0 |

> ⚠️ `filters`의 `...Input` 타입들은 **요청 바디** 계열 — [[Einstein Discovery REST — 요청 표현형 (Request Bodies)|요청 표현형]] 참조.

---

## 버전·컬렉션 (Version Reference / Collection)

### Story Version Reference
The basic information for an Einstein Discovery story version.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| createdDate | Date | The creation date of the story version. | Small, 51.0 | 51.0 |
| id | String | The ID of the story version. | Small, 51.0 | 51.0 |
| url | String | The URL for the story version. | Small, 51.0 | 51.0 |

### Story Collection
A collection of Einstein Discovery stories.

| Property Name | Type | Description | Filter Group | Available Version |
|---|---|---|---|---|
| nextPageUrl | Integer | The URL to get the next page of items for the collection. ⚠️(원문 type "Integer") | Small, 48.0 | 48.0 |
| stories | Story[] | A list of stories available to the current user. | Small, 48.0 | 48.0 |
| totalSize | Integer | The total size of the items in the collection. | Small, 48.0 | 48.0 |
| url | Integer | The URL to get the predict job results. ⚠️(원문 type "Integer", 설명도 "predict job" 오기로 보임) | Small, 48.0 | 48.0 |

---

## 응답 파싱 구조 예시

```json
// 구조 예시 — 실제 동작 설정 아님. StorySummaryDetail 응답 형태를 위 프로퍼티로 조립한 것.
{
  "averageOutcome": 0.42,
  "rowCount": 12000,
  "positiveFactors": [
    {
      "condition": [
        { "fieldName": "Region", "type": "Field", "value": "West",
          "property": { "field": "Region", "type": "Text" } }
      ],
      "count": 3400,
      "diffFromAverage": 0.08,
      "score": 0.12
    }
  ],
  "correlations": [
    { "fieldName": "Region", "fieldLabel": "Region", "correlationToOutcome": 0.31 }
  ],
  "url": "/services/data/vXX.0/smartdatadiscovery/.../summaryDetail"
}
```

---

## 관련 노트
- [[Einstein Discovery REST — 요청 표현형 (Request Bodies)|요청 표현형]]
- [[Einstein Discovery REST — 응답 표현형 — 모델·필드·소스|응답 표현형 — 모델·필드·소스]] (형제)
- [[Einstein Discovery REST — 응답 표현형 — 예측·잡·내러티브|응답 표현형 — 예측·잡·내러티브]] (형제)
- [[Einstein Discovery REST — 모델 품질·편향 지표 표현형]] — 편향·First Order Insights·Disparate Impact 계열
- [[Einstein Discovery REST — Enums|Enums]]
- [[Einstein Discovery REST — 개요·인증·예측 소비 흐름]]
- [[Einstein Discovery REST — 리소스 엔드포인트 레퍼런스]]
