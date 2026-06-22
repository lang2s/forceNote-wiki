---
tags: [visualforce, vf, component-reference, datatable, charting, maps, legacy]
source: salesforce_pages_developers_guide.pdf (Visualforce Developer Guide, v67.0 Summer '26)
created: 2026-06-21
aliases: [apex:dataTable, apex:pageBlockTable, apex:repeat, apex:chart, apex:map, Visualforce 차트 컴포넌트, apex:relatedList]
---

# apex 컴포넌트 — 출력·데이터·반복·차트

> [!note] Visualforce는 레거시 기술이다. 신규 개발은 Lightning Web Components(LWC) 권장.

> Visualforce Developer Guide v67.0 Summer '26 Chapter 24 표준 컴포넌트 레퍼런스 중 **데이터 표시·반복(iteration)·차팅·맵** 계열 28개 `apex:` 컴포넌트의 설명·예제·attribute 전수 레퍼런스.

---

## 이 노트의 범위

Chapter 24 Standard Visualforce Component Reference 중 아래 28개 컴포넌트를 다룬다. Ch24의 입력/폼/패널/Chatter/액션 컴포넌트는 범위 밖이다(다른 노트 담당).

| 분류 | 컴포넌트 |
|---|---|
| 리포트·차트 컨테이너 | `analytics:reportChart`, `apex:chart`, `apex:axis`, `apex:legend`, `apex:chartLabel`, `apex:chartTips` |
| 차트 데이터 시리즈 | `apex:areaSeries`, `apex:barSeries`, `apex:lineSeries`, `apex:pieSeries`, `apex:radarSeries`, `apex:scatterSeries`, `apex:gaugeSeries` |
| 데이터 표·리스트 | `apex:dataTable`, `apex:pageBlockTable`, `apex:column`, `apex:dataList` |
| 반복(iteration) | `apex:repeat` |
| 레코드·관련 리스트 | `apex:detail`, `apex:relatedList`, `apex:listViews`, `apex:enhancedList` |
| 이미지·기타 | `apex:image`, `apex:milestoneTracker`, `apex:vote` |
| 맵 | `apex:map`, `apex:mapMarker`, `apex:mapInfoWindow` |

**표 읽는 법:** 각 attribute 표는 6열(Attribute / Type / Required? / API Version / Access / Description). **Required? 빈칸 = 필수 아님.** **Access 빈칸 = global 아님(빈칸).** 코드 예제는 모두 PDF 원문 verbatim이다.

---

## 1. analytics:reportChart

**설명:** Use this component to add Salesforce report charts to a Visualforce page. You can filter chart data to show specific results. The component is available in API version 29.0 or later. Before you add a report chart, check that the source report has a chart in Salesforce app.

> PDF에 reportChart 단독 코드 예제 없음.

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| cacheAge | Long | | 29.0 | | The length of time that an embedded chart can cache data, in milliseconds (for example, 24 hours = 86,400,000 ms). The maximum length of time is 24 hours. |
| cacheResults | Boolean | | 29.0 | | A Boolean indicating whether to use cached data when displaying the chart. When the attribute is set to true, data is cached for 24 hours, but you can modify the length of time with the cacheAge attribute. If the attribute is set to false, the report is run every time the page is refreshed. |
| developerName | string | | 29.0 | | The unique developer name of the report. You can get a report's developer name from the report properties in the Report Builder. This attribute can be used instead of reportId. It can't be included if reportId has been set and vice versa. One of the two is required. |
| filter | string | | 29.0 | | Filter a report chart by fields in addition to field filters already in the report to get specific data. Note that a report can have up to 20 field filters. A filter has these attributes in the form of a JSON string: • column: The API name of the field that you want to filter on. • operator: The API name of the condition you want to filter a field by. For example, to filter by "not equal to," use the API name "notEqual." • value: The filter criteria. For example, `[{column:'STAGE_NAME',operator:'equals',value:'Prospecting'},{column:'EXP_AMOUNT',operator:'greaterThan',value:'75000'}]`. To get the API name of the field and the operator, make a describe request via the Analytics REST API or Analytics Apex Library. Analytics API `/services/data/v29.0/analytics/reports/00OD0000001ZbNHMA0/describe`. Analytics Apex Library — 1. get report metadata from a describe request `Reports.ReportManager.describeReport(00OD0000001ZbNHMA0)`; 2. get operators based on the field's data type `Reports.ReportManager.getDatatypeFilterOperatorMap()`. |
| hideOnError | Boolean | | 29.0 | | Use the attribute to control whether users see a chart that has an error. When there's an error and this attribute is not set, the chart will not show any data except the error. An error can happen for many reasons, for example, when a user doesn't have access to fields used by the chart or a chart has been removed from the report. Set the attribute to true to hide the chart from a page. |
| id | String | | 14.0 | global | An identifier that allows the component to be referenced by other components in the page. |
| rendered | Boolean | | 14.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| reportId | string | | 29.0 | | The unique ID of the report. You can get a report's ID from the report URL in Salesforce, or request it through the API. |
| showRefreshButton | Boolean | | 29.0 | | A Boolean indicating whether to add a refresh button to the chart. |
| size | string | | 29.0 | | Specify a chart's size with one of these values: • tiny • small • medium • large • huge. When not specified, the chart size is medium. |

---

## 2. apex:chart

**설명:** A Visualforce chart. Defines general characteristics of the chart, including size and data binding.

```html
<!-- Page: -->
<apex:chart data="{!pieData}">
<apex:pieSeries labelField="name" dataField="data1"/>
</apex:chart>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| animate | Boolean | | 23.0 | | A Boolean value that specifies whether to animate the chart when it is first rendered. If not specified, this value defaults to true. |
| background | String | | 26.0 | | A string that specifies the color to use for the background of the chart, as an HTML-style (hexadecimal) color. If not specified, charts use a plain white background. |
| colorSet | String | | 26.0 | | A set of colors to be used by each child series. Colors are specified as HTML-style (hexadecimal) colors, and should be comma separated. For example, #00F,#0F0,#F00. These colors override the default colors used by Visualforce charts. These colors can in turn be overridden by colorSets provided to individual data series. |
| data | Object | Yes | 23.0 | | Specifies the data binding for the chart. This can be a controller method that returns an expression, a JavaScript function, or an array. In all cases, the result must be an array of data objects, with named values referenced in child data series components. |
| floating | Boolean | | 23.0 | | A Boolean value that specifies whether to float the chart outside the regular HTML document flow using CSS absolute positioning. |
| height | String | Yes | 23.0 | | The height of the chart rectangle, in pixels when given as an integer, or as a percentage of the height of the containing HTML element, when given as a number followed by a percent sign. Use pixels for consistent behavior across browsers and data sets. Use a percentage when dealing with varying data sets that can produce very tall and short charts. It's most useful for horizontal bar charts with many bars. Note: It's a known issue that percentage heights don't work in Firefox. |
| hidden | Boolean | | 23.0 | | A Boolean value that specifies whether to show or hide the chart initially. Set to true to render the chart but hide it when the page is first displayed. |
| id | String | | 23.0 | global | An identifier that allows the chart component to be referenced by other components on the page. |
| legend | Boolean | | 23.0 | | A Boolean value that specifies whether to display the default chart legend. Add an `<apex:legend>` component to the chart for more options. If not specified, this value defaults to true. |
| name | String | | 23.0 | | Name of generated JavaScript object used to provide additional configuration, or perform dynamic operations. Name must be unique across all chart components. If the encompassing top-level component (`<apex:page>` or `<apex:component>`) is namespaced, the chart name will be prefixed with the namespace, for example, MyNamespace.MyChart. |
| rendered | Boolean | | 23.0 | | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| renderTo | String | | 23.0 | | A string to specify the ID of the DOM element to render the chart into. |
| resizable | Boolean | | 23.0 | | A Boolean value that specifies whether or not the chart is resizable after rendering. |
| theme | String | | 26.0 | | A string specifying the name of the chart theme to use. Themes provide pre-defined sets of colors. Available themes are: • Salesforce • Blue • Green • Red • Purple • Yellow • Sky • Category1 • Category2 • Category3 • Category4 • Category5 • Category6. The default, "Salesforce", provides colors which match charts in Salesforce reports and analytics. Use colorSet to define your own colors for charting components. |
| width | String | Yes | 23.0 | | The width of the chart rectangle, in pixels when given as an integer, or as a percentage of the width of the containing HTML element, when given as a number followed by a percent sign. Use pixels for consistent behavior across browsers and data sets. Use a percentage when you want the chart to stretch with the width of the browser window. |

---

## 3. apex:axis

**설명:** Defines an axis for a chart. Use this to set the units, scale, labeling, and other visual options for the axis. You can define up to four axes for a single chart, one for each edge.

> Note: This component must be enclosed within an `<apex:chart>` component.

```html
<!-- Page: -->
<apex:chart height="400" width="700" data="{!data}">
<apex:axis type="Numeric" position="left" fields="data1"
title="Opportunities Closed" grid="true"/>
<apex:axis type="Numeric" position="right" fields="data3"
title="Revenue (millions)"/>
<apex:axis type="Category" position="bottom" fields="name"
title="Month of the Year">
<apex:chartLabel rotate="315"/>
</apex:axis>
<apex:barSeries title="Monthly Sales" orientation="vertical" axis="right"
xField="name" yField="data3"/>
<apex:lineSeries title="Closed-Won" axis="left" xField="name" yField="data1"/>
</apex:chart>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| dashSize | Integer | | 23.0 | | The size of the dash marker, in pixels. If not specified, this value defaults to 3. |
| fields | String | | 23.0 | | The field(s) in each record of the chart data from which to retrieve axis label values. You can specify more than one field, to increase the range of the axis scale to include all values. Fields must exist in every record in the chart data. |
| grid | Boolean | | 23.0 | | A Boolean value specifying whether to draw gridlines in the background of the chart. If true for a vertical axis, vertical lines are drawn, and likewise for horizontal axis. A proper grid can be drawn by setting grid to true on both a horizontal and a vertical axis of a chart. If not specified, this value defaults to false. |
| gridFill | Boolean | | 23.0 | | A Boolean value specifying whether to fill in alternating grid intervals with a background color. If not specified, this value defaults to false. |
| id | String | | 23.0 | global | An identifier that enables the chart component to be referenced by other components on the page. |
| margin | Integer | | 26.0 | | An integer value that specifies the distance between the outer edge of the chart and the baseline of the axis label text. Negative values are permitted, and move the labels inside the chart edge. Valid only when the axis type (and chart) is Gauge. If not specified, this value defaults to 10. |
| maximum | Integer | | 23.0 | | The maximum value for the axis. If not set, the maximum is calculated automatically from the values in fields. |
| minimum | Integer | | 23.0 | | The minimum value for the axis. If not set, the minimum is calculated automatically from the values in fields. |
| position | String | Yes | 23.0 | | The edge of the chart to which to bind the axis. Valid options are: • left • right • top • bottom • gauge • radial. The first four positions correspond to the edges of a standard linear chart. "gauge" is specific to an axis used by `<apex:gaugeSeries>`, and "radial" is specific to an axis used by `<apex:radarSeries>`. |
| rendered | Boolean | | 23.0 | | A Boolean value that specifies whether the axis elements are rendered with the chart. If not specified, this value defaults to true. |
| steps | Integer | | 26.0 | | An integer value that specifies the number of tick marks to places on the axis. If set, it overrides the automatic calculation of tick marks for the axis. Valid only when the axis type is Numeric. |
| title | String | | 23.0 | | The label for the axis. |
| type | String | Yes | 23.0 | | Specifies the type of the axis, which is used to calculate axis intervals and spacing. Valid options are: • "Category" for non-numeric information, such as names or types of items, and so on. • "Numeric" for quantitative values. • "Gauge" is used only with, and required by, `<apex:gaugeSeries>`. • "Radial" is used only with, and required by, `<apex:radarSeries>`. |

---

## 4. apex:areaSeries

**설명:** A data series to be rendered as shaded areas in a Visualforce chart. It's similar to a line series with the fill attribute set to true, except that multiple Y values for each X will "stack" as levels upon each other. At a minimum you must specify the fields in the data collection to use as X and Y values for each point along the line that defines the amount of area each point represents, as well as the X and Y axes to scale against. Add multiple Y values to add levels to the chart. Each level takes a new color.

> Note: This component must be enclosed within an `<apex:chart>` component. You can have multiple `<apex:areaSeries>` components in a single chart, and you can add `<apex:barSeries>`, `<apex:lineSeries>`, and `<apex:scatterSeries>` components, but the results might not be very readable.

An area chart with three Y values to plot as levels on the chart:

```html
<apex:chart height="400" width="700" animate="true" legend="true" data="{!data}">
<apex:legend position="left"/>
<apex:axis type="Numeric" position="left" fields="data1,data2,data3"
title="Closed Won" grid="true">
<apex:chartLabel/>
</apex:axis>
<apex:axis type="Category" position="bottom" fields="name"
title="Month of the Year">
<apex:chartLabel rotate="315"/>
</apex:axis>
<apex:areaSeries axis="left" xField="name" yField="data1,data2,data3" tips="true"/>
</apex:chart>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| axis | String | Yes | 26.0 | | Which axis this chart series should bind to. Must be one of the four edges of the chart: • left • right • top • bottom. The axis bound to must be defined by a sibling `<apex:axis>` component. |
| colorSet | String | | 26.0 | | A set of color values used, in order, as level area fill colors. Colors are specified as HTML-style (hexadecimal) colors, and should be comma separated. For example, #00F,#0F0,#F00. |
| highlight | Boolean | | 23.0 | | A Boolean value that specifies whether each level should be highlighted when the mouse pointer passes over it. If not specified, this value defaults to true. |
| highlightLineWidth | Integer | | 26.0 | | An integer that specifies the width in pixels of the line that surrounds a level when it's highlighted. |
| highlightOpacity | String | | 26.0 | | A decimal number between 0 and 1 representing the opacity of the color overlayed on a level when it's highlighted. |
| highlightStrokeColor | String | | 26.0 | | A string that specifies the HTML-style color of the line that surrounds a level when it's highlighted. |
| id | String | | 26.0 | global | An identifier that allows the chart component to be referenced by other components on the page. |
| opacity | String | | 26.0 | | A decimal number between 0 and 1 representing the opacity of the filled area for this level of the series. |
| rendered | Boolean | | 26.0 | | A Boolean value that specifies whether the chart series is rendered in the chart. If not specified, this value defaults to true. |
| rendererFn | String | | 26.0 | | A string that specifies the name of a JavaScript function that augments or overrides how each data point is rendered. Implement to provide additional styling or to augment data. |
| showInLegend | Boolean | | 26.0 | | A Boolean value that specifies whether this chart series should be added to the chart legend. If not specified, this value defaults to true. |
| tips | Boolean | | 26.0 | | A Boolean value that specifies whether to display a tooltip for each data point marker when the mouse pointer passes over it. The format of the tip is xField: yField. If not specified, this value defaults to true. |
| title | String | | 26.0 | | The title of this chart series, which is displayed in the chart legend. For stacked charts with multiple data series in the yField, separate each series title with a comma. For example: title="MacDonald,Picard,Worle". |
| xField | String | Yes | 26.0 | | The field in each record provided in the chart data from which to retrieve the x-axis value for each data point in the series. This field must exist in every record in the chart data. |
| yField | String | Yes | 26.0 | | The field in each record provided in the chart data from which to retrieve the y-axis value for each data point in the series. This field must exist in every record in the chart data. |

---

## 5. apex:barSeries

**설명:** A data series to be rendered as bars in a Visualforce chart. At a minimum you must specify the fields in the data collection to use as X and Y values for each bar, as well as the X and Y axes to scale against. Add multiple Y values to add grouped or stacked bar segments to the chart. Each segment takes a new color.

> Note: This component must be enclosed within an `<apex:chart>` component. You can have multiple `<apex:barSeries>` and `<apex:lineSeries>` components in a single chart. You can also add `<apex:areaSeries>` and `<apex:scatterSeries>` components, but the results might not be very readable.

```html
<!-- Page: -->
<apex:chart height="400" width="700" data="{!data}">
<apex:axis type="Numeric" position="left" fields="data1"
title="Opportunities Closed" grid="true"/>
<apex:axis type="Numeric" position="right" fields="data3"
title="Revenue (millions)"/>
<apex:axis type="Category" position="bottom" fields="name"
title="Month of the Year"/>
<apex:barSeries title="Monthly Sales" orientation="vertical" axis="right"
xField="name" yField="data3">
<apex:chartTips height="20" width="120"/>
</apex:barSeries>
<apex:lineSeries title="Closed-Won" axis="left" xField="name" yField="data1"/>
</apex:chart>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| axis | String | Yes | 23.0 | | Which axis this chart series should bind to. Must be one of the four edges of the chart: • left • right • top • bottom. The axis bound to must be defined by a sibling `<apex:axis>` component. |
| colorSet | String | | 26.0 | | A set of color values used, in order, as bar fill colors. Colors are specified as HTML-style (hexadecimal) colors, and should be comma separated. For example, #00F,#0F0,#F00. |
| colorsProgressWithinSeries | Boolean | | 26.0 | | A Boolean value that specifies how to progress through the values of the colorSet attribute. • When set to true, the first color in the colorSet is used for the first bar (or bar segment, when the `<apex:barSeries>` is stacked) in an `<apex:barSeries>`, the second color for the second bar, and so on. Colors restart at the beginning for each `<apex:barSeries>`. • When set to false, the default, the first color in the colorSet is used for all bars in the first `<apex:barSeries>`, the second color is used for bars in the second `<apex:barSeries>`, and so on. |
| groupGutter | Integer | | 26.0 | | An integer specifying the spacing between groups of bars, as a percentage of the bar width. |
| gutter | Integer | | 26.0 | | An integer specifying the spacing between individual bars, as a percentage of the bar width. |
| highlight | Boolean | | 23.0 | | A Boolean value that specifies whether each bar should be highlighted when the mouse pointer passes over it. If not specified, this value defaults to true. |
| highlightColor | String | | 26.0 | | A string that specifies the HTML-style color overlayed on a bar when it's highlighted. |
| highlightLineWidth | Integer | | 26.0 | | An integer that specifies the width in pixels of the line that surrounds a bar when it's highlighted. |
| highlightOpacity | String | | 26.0 | | A decimal number between 0 (transparent) and 1 (opaque) representing the opacity of the color overlayed on a bar when it's highlighted. |
| highlightStroke | String | | 26.0 | | A string that specifies the HTML-style color of the line that surrounds a bar when it's highlighted. |
| id | String | | 23.0 | global | An identifier that allows the chart component to be referenced by other components on the page. |
| orientation | String | Yes | 23.0 | | The direction of the bars in the chart. Valid options are: • horizontal • vertical. |
| rendered | Boolean | | 23.0 | | A Boolean value that specifies whether the chart series is rendered in the chart. If not specified, this value defaults to true. |
| rendererFn | String | | 26.0 | | A string that specifies the name of a JavaScript function that augments or overrides how each bar is rendered. Implement to provide additional styling or to augment data. |
| showInLegend | Boolean | | 23.0 | | A Boolean value that specifies whether this chart series should be added to the chart legend. If not specified, this value defaults to true. |
| stacked | Boolean | | 26.0 | | A Boolean value that specifies whether to group or stack bar values. |
| tips | Boolean | | 23.0 | | A Boolean value that specifies whether to display a tool tip for each bar when the mouse pointer passes over it. The format of the tip is xField: yField. If not specified, this value defaults to true. |
| title | String | | 23.0 | | The title of this chart series, which is displayed in the chart legend. |
| xField | String | Yes | 23.0 | | The field in each record provided in the chart data from which to retrieve the x-axis value for each data point in the series. This field must exist in every record in the chart data. |
| yField | String | Yes | 23.0 | | The field in each record provided in the chart data from which to retrieve the y-axis value for each data point in the series. This field must exist in every record in the chart data. |

---

## 6. apex:lineSeries

**설명:** A data series to be rendered as connected points in a linear Visualforce chart. At a minimum you must specify the fields in the data collection to use as X and Y values for each point, as well as the X and Y axes to scale against.

> Note: This component must be enclosed within an `<apex:chart>` component. You can have multiple `<apex:barSeries>` and `<apex:lineSeries>` components in a single chart. You can also add `<apex:areaSeries>` and `<apex:scatterSeries>` components, but the results might not be very readable.

```html
<!-- Page: -->
<apex:chart height="400" width="700" data="{!data}">
<apex:axis type="Numeric" position="left" fields="data1,data2"
title="Opportunities Closed" grid="true"/>
<apex:axis type="Category" position="bottom" fields="name"
title="Month of the Year"/>
<apex:lineSeries title="Closed-Won" axis="left" xField="name" yField="data1"
fill="true" markerType="cross" markerSize="4" markerFill="#FF0000"/>
<apex:lineSeries title="Closed-Lost" axis="left" xField="name" yField="data2"
markerType="circle" markerSize="4" markerFill="#8E35EF"/>
</apex:chart>
```

> ⚠️ `apex:lineSeries`는 `highlightStrokeWidth`(String) attribute를 쓴다. `apex:areaSeries`·`apex:barSeries`의 `highlightLineWidth`(Integer)와는 **별개의 attribute**다. 혼동 금지.

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| axis | String | Yes | 23.0 | | Which axis this chart series should bind to. Must be one of the four edges of the chart: • left • right • top • bottom. The axis bound to must be defined by a sibling `<apex:axis>` component. |
| fill | Boolean | | 23.0 | | A Boolean value that specifies whether the area under the line should be filled or not. If not specified, this value defaults to false. |
| fillColor | String | | 26.0 | | A string that specifies the color to use to fill the area under the line, specified as an HTML-style (hexadecimal) color. If not specified, the fill color matches the line color. Only used if fill is set to true. |
| highlight | Boolean | | 23.0 | | A Boolean value that specifies whether each point of the series line should be highlighted when the mouse pointer passes over it. If not specified, this value defaults to true. |
| highlightStrokeWidth | String | | 26.0 | | A string that specifies the width of the line that is drawn over the series line when it's highlighted. |
| id | String | | 23.0 | global | An identifier that allows the chart component to be referenced by other components on the page. |
| markerFill | String | | 23.0 | | The color of data point markers for this series, specified as an HTML-style (hexadecimal) color. If not specified, the marker color matches the line color. |
| markerSize | Integer | | 23.0 | | The size of each data point marker for this series. If not specified, this value defaults to "3". |
| markerType | String | | 23.0 | | The shape of each data point marker for this series. Valid options are: • circle • cross. If not specified, the marker shape is chosen from a sequence of shapes. |
| opacity | String | | 26.0 | | A decimal number between 0 and 1 representing the opacity of the filled area under the line for the series. If not specified, defaults to "0.3". Only used if fill is set to true. |
| rendered | Boolean | | 23.0 | | A Boolean value that specifies whether the chart series is rendered in the chart. If not specified, this value defaults to true. |
| rendererFn | String | | 26.0 | | A string that specifies the name of a JavaScript function that augments or overrides how each data point is rendered. Implement to provide additional styling or to augment data. |
| showInLegend | Boolean | | 23.0 | | A Boolean value that specifies whether this chart series should be added to the chart legend. If not specified, this value defaults to true. |
| smooth | Integer | | 26.0 | | An integer specifying the amount of smoothing for the line, with lower numbers applying more smoothing. 0 (zero) disables smoothing, and uses straight lines between the points in the series. |
| strokeColor | String | | 26.0 | | A string specifying the color of the line for this series, specified as an HTML-style (hexadecimal) color. If not specified, colors are used in sequence from the chart colorSet or theme. |
| strokeWidth | String | | 26.0 | | An integer specifying the width of the line for this series. |
| tips | Boolean | | 23.0 | | A Boolean value that specifies whether to display a tooltip for each data point marker when the mouse pointer passes over it. The format of the tip is `<xField>: <yField>`. If not specified, this value defaults to true. |
| title | String | | 23.0 | | The title of this chart series, which is displayed in the chart legend. |
| xField | String | Yes | 23.0 | | The field in each record provided in the chart data from which to retrieve the x-axis value for each data point in the series. This field must exist in every record in the chart data. |
| yField | String | Yes | 23.0 | | The field in each record provided in the chart data from which to retrieve the y-axis value for each data point in the series. This field must exist in every record in the chart data. |

---

## 7. apex:pieSeries

**설명:** A data series to be rendered as wedges in a Visualforce pie chart. At a minimum you must specify the fields in the data collection to use as label and value pairs for each pie wedge.

> Note: This component must be enclosed within an `<apex:chart>` component. You can only have one `<apex:pieSeries>` in a chart.

```html
<!-- Page: -->
<apex:chart data="{!pieData}" height="300" width="400">
<apex:pieSeries labelField="name" dataField="data1"/>
</apex:chart>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| colorSet | String | | 23.0 | | A set of color values used, in order, as the pie wedge fill colors. Colors are specified as HTML-style (hexadecimal) colors, and should be comma separated. For example, #00F,#0F0,#F00. |
| dataField | String | Yes | 23.0 | | The field in each record provided in the chart data from which to retrieve the data value for each pie wedge in the series. This field must exist in every record in the chart data. |
| donut | Integer | | 26.0 | | An integer representing the radius of the hole to place in the center of the pie chart, as a percentage of the radius of the pie. If no value is specified, 0 is used, which creates a normal pie chart, with no hole. |
| highlight | Boolean | | 23.0 | | A Boolean value that specifies whether each pie wedge should be highlighted when the mouse pointer passes over it. If not specified, this value defaults to true. |
| id | String | | 23.0 | global | An identifier that allows the chart component to be referenced by other components on the page. |
| labelField | String | | 23.0 | | The field in each record provided in the chart data from which to retrieve the label for each pie wedge in the series. This field must exist in every record in the chart data. If not specified, this value defaults to "name". |
| rendered | Boolean | | 23.0 | | A Boolean value that specifies whether the chart series is rendered in the chart. If not specified, this value defaults to true. |
| rendererFn | String | | 26.0 | | A string that specifies the name of a JavaScript function that augments or overrides how each pie wedge is rendered. Implement to provide additional styling or to augment data. |
| showInLegend | Boolean | | 23.0 | | A Boolean value that specifies whether to show this series in the chart legend, if a legend is enabled. If not specified, this value defaults to true. |
| tips | Boolean | | 23.0 | | A Boolean value that specifies whether to display a tooltip for each pie wedge when the mouse pointer passes over it. The format of the tip is `<labelField>: <dataField>`. If not specified, this value defaults to true. |

---

## 8. apex:radarSeries

**설명:** A data series to be rendered as the area inside a series of connected points in a radial Visualforce chart. Radar charts are also sometimes called "spider web" charts. At a minimum you must specify the fields in the data collection to use as X and Y values for each point, as well as a radial axis to scale against.

> Note: This component must be enclosed within an `<apex:chart>` component. You can have multiple `<apex:radarSeries>` components in a single chart.

```html
<!-- Page: -->
<apex:chart height="530" width="700" legend="true" data="{!data}">
<apex:legend position="left"/>
<apex:axis type="Radial" position="radial">
<apex:chartLabel/>
</apex:axis>
<apex:radarSeries xField="name" yField="data1" tips="true" opacity="0.4"/>
<apex:radarSeries xField="name" yField="data2" tips="true" opacity="0.4"/>
<apex:radarSeries xField="name" yField="data3" tips="true"
markerType="cross" strokeWidth="2" strokeColor="#f33" opacity="0.4"/>
</apex:chart>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| fill | String | | 26.0 | | A string that specifies the color to use to fill the area inside the line, specified as an HTML-style (hexadecimal) color. If not specified, colors are used in sequence from the chart colorSet or theme. Set fill to "none" for an unfilled chart, with lines and markers only. If you do so, be sure to set stroke and marker attributes, which by default aren't visible. |
| highlight | Boolean | | 26.0 | | A Boolean value that specifies whether each point should be highlighted when the mouse pointer passes over it. If not specified, this value defaults to true. |
| id | String | | 26.0 | global | An identifier that allows the chart component to be referenced by other components on the page. |
| markerFill | String | | 23.0 | | The color of data point markers for this series, specified as an HTML-style (hexadecimal) color. You must set at least one marker attribute for markers for a series to appear on the chart. |
| markerSize | Integer | | 23.0 | | The size of each data point marker for this series. You must set at least one marker attribute for markers for a series to appear on the chart. |
| markerType | String | | 23.0 | | The shape of each data point marker for this series. Valid options are: • circle • cross. You must set at least one marker attribute for markers for a series to appear on the chart. |
| opacity | Integer | | 26.0 | | A decimal number between 0 and 1 representing the opacity of the filled area for the series. Only has an effect if fill is set. |
| rendered | Boolean | | 26.0 | | A Boolean value that specifies whether the chart series is rendered in the chart. If not specified, this value defaults to true. |
| showInLegend | Boolean | | 26.0 | | A Boolean value that specifies whether this chart series should be added to the chart legend. If not specified, this value defaults to true. |
| strokeColor | String | | 26.0 | | A string specifying the color of the line for this series, specified as an HTML-style (hexadecimal) color. If not specified, the line will be the same color as the fill, which effectively renders it invisible. |
| strokeWidth | Integer | | 26.0 | | An integer specifying the width of the line for this series. If not specified, no line will be drawn. If fill is also set to "none", this series won't display on the chart. |
| tips | Boolean | | 26.0 | | A Boolean value that specifies whether to display a tooltip for each data point marker when the mouse pointer passes over it. The format of the tip is `<xField>: <yField>`. If not specified, this value defaults to true. |
| title | String | | 26.0 | | The title of this chart series, which is displayed in the chart legend. |
| xField | String | Yes | 26.0 | | The field in each record provided in the chart data from which to retrieve the x-axis value for each data point in the series. The x-axis in a radar chart is the perimeter circle. This field must exist in every record in the chart data. |
| yField | String | Yes | 26.0 | | The field in each record provided in the chart data from which to retrieve the y-axis value for each data point in the series. The y-axis in a radar chart is the vertical line running from the center of the radar plot out to the edge. This field must exist in every record in the chart data. |

---

## 9. apex:scatterSeries

**설명:** A data series to be rendered as individual (not connected) points in a linear Visualforce chart. At a minimum you must specify the fields in the data collection to use as X and Y values for each point, as well as the X and Y axes to scale against.

> Note: This component must be enclosed within an `<apex:chart>` component. You can have multiple `<apex:scatterSeries>` components in a single chart. You can also add `<apex:areaSeries>`, `<apex:barSeries>`, and `<apex:lineSeries>` components, but the results might not be very readable.

```html
<!-- Page: -->
<apex:chart height="530" width="700" animate="true" data="{!data}">
<apex:scatterSeries xField="data1" yField="data2"
markerType="circle" markerSize="3"/>
<apex:axis type="Numeric" position="bottom" fields="data1"
title="Torque" grid="true">
<apex:chartLabel/>
</apex:axis>
<apex:axis type="Numeric" position="left" fields="data2"
title="Lateral Motion" grid="true">
<apex:chartLabel/>
</apex:axis>
</apex:chart>
```

> ⚠️ `apex:scatterSeries`의 `axis`는 **필수가 아니다**(area/bar/lineSeries의 `axis`는 Yes).

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| axis | String | | 26.0 | | Which axis this chart series should bind to. Must be one of the four edges of the chart: • left • right • top • bottom. The axis bound to must be defined by a sibling `<apex:axis>` component. |
| highlight | Boolean | | 26.0 | | A Boolean value that specifies whether each point should be highlighted when the mouse pointer passes over it. If not specified, this value defaults to true. |
| id | String | | 26.0 | global | An identifier that allows the chart component to be referenced by other components on the page. |
| markerFill | String | | 26.0 | | The color of data point markers for this series, specified as an HTML-style (hexadecimal) color. |
| markerSize | Integer | | 26.0 | | The size of each data point marker for this series. |
| markerType | String | | 26.0 | | The shape of each data point marker for this series. Valid options are: • circle • cross. If not specified, the marker shape is chosen from a sequence of shapes. |
| rendered | Boolean | | 26.0 | | A Boolean value that specifies whether the chart series is rendered in the chart. If not specified, this value defaults to true. |
| rendererFn | String | | 26.0 | | A string that specifies the name of a JavaScript function that augments or overrides how each data point is rendered. Implement to provide additional styling or to augment data. |
| showInLegend | Boolean | | 26.0 | | A Boolean value that specifies whether this chart series should be added to the chart legend. If not specified, this value defaults to true. |
| tips | Boolean | | 26.0 | | A Boolean value that specifies whether to display a tooltip for each data point marker when the mouse pointer passes over it. The format of the tip is `<xField>: <yField>`. If not specified, this value defaults to true. |
| title | String | | 26.0 | | The title of this chart series, which is displayed in the chart legend. |
| xField | String | Yes | 26.0 | | The field in each record provided in the chart data from which to retrieve the x-axis value for each data point in the series. This field must exist in every record in the chart data. |
| yField | String | Yes | 26.0 | | The field in each record provided in the chart data from which to retrieve the y-axis value for each data point in the series. This field must exist in every record in the chart data. |

---

## 10. apex:gaugeSeries

**설명:** A data series that shows progress along a specific metric. At a minimum you must specify the fields in the data collection to use as label and value pair for the gauge level to be shown. The readability of a gauge chart benefits when you specify meaningful values for the minimum and maximum along the associated `<apex:axis>`, which must be of type "gauge".

> Note: This component must be enclosed within an `<apex:chart>` component. You should put only one `<apex:gaugeSeries>` in a chart.

```html
<!-- Page: -->
<apex:chart height="250" width="450" animate="true" legend="true" data="{!data}">
<apex:axis type="gauge" position="left" margin="-10"
minimum="0" maximum="100" steps="10"/>
<apex:gaugeSeries dataField="data1" highlight="true" tips="true" donut="25"
colorSet="#F49D10, #ddd">
<apex:chartLabel display="over"/>
</apex:gaugeSeries>
</apex:chart>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| colorSet | String | | 26.0 | | A set of color values used as the gauge level fill colors. Colors are specified as HTML-style (hexadecimal) colors, and should be comma separated. For example, #00F,#0F0. |
| dataField | String | Yes | 26.0 | | The field in the records provided in the chart data from which to retrieve the data value for the gauge level. Only the first record is used. |
| donut | Integer | | 26.0 | | An integer representing the radius of the hole to place in the center of the gauge chart, as a percentage of the radius of the gauge. The default of 0 creates a gauge chart with no hole, that is, a half-circle. |
| highlight | Boolean | | 26.0 | | A Boolean value that specifies whether each gauge level should be highlighted when the mouse pointer passes over it. If not specified, this value defaults to true. |
| id | String | | 26.0 | global | An identifier that allows the chart component to be referenced by other components on the page. |
| labelField | String | | 23.0 | | The field in the records provided in the chart data from which to retrieve the label for the gauge level. Only the first record is used. If not specified, this value defaults to "name". |
| needle | Boolean | | 26.0 | | A Boolean value that specifies whether to show the gauge needle or not. Defaults to false, don't show the needle. |
| rendered | Boolean | | 26.0 | | A Boolean value that specifies whether the chart series is rendered in the chart. If not specified, this value defaults to true. |
| rendererFn | String | | 26.0 | | A string that specifies the name of a JavaScript function that augments or overrides how gauge elements are rendered. Implement to provide additional styling or to augment data. |
| tips | Boolean | | 26.0 | | A Boolean value that specifies whether to display a tooltip for the gauge level when the mouse pointer passes over it. The format of the tip is `<labelField>: <dataField>`. If not specified, this value defaults to true. |

---

## 11. apex:chartLabel

**설명:** Defines how labels are displayed. Depending on what component wraps it, `<apex:chartLabel>` gives you options for affecting the display of data series labels, pie chart segment labels, and axes labels.

> Note: This component must be enclosed by a data series component or an `<apex:axis>` component.

```html
<!-- Page: -->
<apex:chart height="400" width="700" data="{!data}">
<apex:axis type="Numeric" position="left" fields="data1"
title="Opportunities Closed" grid="true"/>
<apex:axis type="Category" position="bottom" fields="name"
title="Month of the Year">
<apex:chartLabel rotate="315"/>
</apex:axis>
<apex:lineSeries title="Closed-Won" axis="left" xField="name" yField="data1"/>
<apex:lineSeries title="Closed-Lost" axis="left" xField="name" yField="data2"/>
</apex:chart>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| color | String | | 23.0 | | The color of the label text specified as an HTML-style (hexadecimal) color. If not specified, this value defaults to "#000" (black). |
| display | String | | 23.0 | | Specifies the position of labels, or disables the display of labels. Valid options are: • rotate • middle • insideStart • insideEnd • outside • over • under • none (to hide labels). If not specified, this value defaults to "middle". |
| field | String | | 23.0 | | The field in each record provided in the chart data from which to retrieve the label for each data point in the series. This field must exist in every record in the chart data. If not specified, this value defaults to "name". |
| font | String | | 23.0 | | The font to use for the label text, as a CSS-style font definition. If not specified, this value defaults to "11px Helvetica, sans-serif". |
| id | String | | 23.0 | global | An identifier that allows the chart component to be referenced by other components on the page. |
| minMargin | Integer | | 23.0 | | Specifies the minimum distance from a label to the origin of the visualization, in pixels. If not specified, this value defaults to 50. |
| orientation | String | | 23.0 | | Display the label text characters normally, or stacked vertically. Valid options are: • horizontal • vertical. If not specified, this value defaults to "horizontal" for normal left-to-right text. |
| rendered | Boolean | | 23.0 | | A Boolean value that specifies whether the chart label is rendered with the chart. If not specified, this value defaults to true. |
| rendererFn | String | | 26.0 | | A string that specifies the name of a JavaScript function that augments or overrides label rendering for axis or series labels. |
| rotate | Integer | | 23.0 | | Degrees to rotate the label text. If not specified, this value defaults to 0. |

---

## 12. apex:chartTips

**설명:** Defines tooltips which appear on mouseover of data series elements. This component offers more configuration options than the default tooltips displayed by setting the tips attribute of a data series component to true.

> Note: This component must be enclosed by a data series component.

```html
<!-- Page: -->
<apex:chart height="400" width="700" data="{!data}">
<apex:axis type="Numeric" position="left" fields="data1"
title="Millions" grid="true"/>
<apex:axis type="Category" position="bottom" fields="name"
title="Month of the Year"/>
<apex:barSeries title="Monthly Sales" orientation="vertical" axis="left"
xField="name" yField="data1">
<apex:chartTips height="20" width="120"/>
</apex:barSeries>
</apex:chart>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| height | Integer | | 23.0 | | The height of the tooltip, in pixels. |
| id | String | | 23.0 | global | An identifier that allows the chart component to be referenced by other components on the page. |
| labelField | String | | 23.0 | | The field in each record of the chart data to use as the label for the tooltip for each data point in the series. Tooltips will be displayed as `<label>: <value>`. This field must exist in every record in the chart data. If not specified, this value defaults to the labelField for pie and gauge series, and the xField for other data series. |
| rendered | Boolean | | 23.0 | | A Boolean value that specifies whether the tooltips for the data series are rendered with the chart. If not specified, this value defaults to true. |
| rendererFn | String | | 26.0 | | A string that specifies the name of a JavaScript function that augments or overrides tooltip rendering for chart tips. |
| trackMouse | Boolean | | 23.0 | | A Boolean value that specifies whether the chart tips should follow the mouse pointer. If not specified, this value defaults to true. |
| valueField | String | | 23.0 | | The field in each record of the chart data to use as the value for the tooltip for each data point in the series. Tooltips will be displayed as `<label>: <value>`. This field must exist in every record in the chart data. If not specified, this value defaults to the dataField for pie and gauge series, and the yField for other data series. |
| width | Integer | | 23.0 | | The width of the tooltip, in pixels. |

---

## 13. apex:legend

**설명:** Defines a chart legend. This component offers additional configuration options beyond the defaults used by the legend attribute of the `<apex:chart>` component.

> Note: This component must be enclosed within an `<apex:chart>` component.

```html
<!-- Page: -->
<apex:chart height="400" width="700" data="{!data}">
<apex:legend position="right"/>
<apex:axis type="Numeric" position="left" fields="data1,data2"
title="Opportunities Closed" grid="true"/>
<apex:axis type="Category" position="bottom" fields="name"
title="Month of the Year"/>
<apex:lineSeries title="Closed-Won" axis="left" xField="name" yField="data1"/>
<apex:lineSeries title="Closed-Lost" axis="left" xField="name" yField="data2"/>
</apex:chart>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| font | String | | 23.0 | | The font to be used for the legend text, as a CSS-style font definition. If not specified, this value defaults to "12px Helvetica". |
| id | String | | 23.0 | global | An identifier that allows the chart component to be referenced by other components on the page. |
| padding | Integer | | 23.0 | | The amount of spacing between the legend border and the contents of the legend, in pixels. |
| position | String | Yes | 23.0 | | The position of the legend, in relation to the chart. Valid options are: • left • right • top • bottom. |
| rendered | Boolean | | 23.0 | | A Boolean value that specifies whether the chart legend is rendered with the chart. If not specified, this value defaults to true. |
| spacing | Integer | | 23.0 | | The amount of spacing between legend items, in pixels. |

---

## 14. apex:column

**설명:** A single column in a table. An `<apex:column>` component must always be a child of an `<apex:dataTable>` or `<apex:pageBlockTable>` component. Note that if you specify an sObject field as the value attribute for an `<apex:column>`, the associated label for that field is used as the column header by default. To override this behavior, use the headerValue attribute on the column, or the column's header facet. This component supports HTML pass-through attributes using the "html-" prefix. Pass-through attributes are attached to the generated `<td>` tag for the column in every row of the table.

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL.
For example, if 001D000000IRt53 is the account ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<apex:page standardController="Account">
<apex:pageBlock title="My Content">
<apex:pageBlockTable value="{!account.Contacts}" var="item">
<apex:column value="{!item.name}"/>
<apex:column value="{!item.phone}"/>
</apex:pageBlockTable>
</apex:pageBlock>
</apex:page>
```

**Attributes** (전부 API 10.0 · Access global). 다수의 `footer*`/`header*` attribute는 API 16.0에서 deprecated되어 페이지에 효과 없음.

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| breakBefore | Boolean | | 10.0 | global | A Boolean value that specifies whether the column should begin a new row in the table. If set to true, the column begins a new row. If not specified, this value defaults to false. |
| colspan | Integer | | 10.0 | global | The number of columns that this column spans in the table. Note that this value does not apply to the header and footer cells. |
| dir | String | | 10.0 | global | The direction in which text in the generated column should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). Note that this value does not apply to the header and footer cells. |
| footerClass | String | | 10.0 | global | The style class used to display the column footer, if defined. This attribute is used primarily to designate which CSS styles are applied when using an external CSS stylesheet. |
| footercolspan | String | | 10.0 | global | This attribute was deprecated in Salesforce API version 16.0 and has no effect on the page. |
| footerdir | String | | 10.0 | global | This attribute was deprecated in Salesforce API version 16.0 and has no effect on the page. |
| footerlang | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footeronclick | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footerondblclick | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footeronkeydown | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footeronkeypress | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footeronkeyup | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footeronmousedown | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footeronmousemove | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footeronmouseout | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footeronmouseover | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footeronmouseup | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footerstyle | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footertitle | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| footerValue | String | | 12.0 | global | The text that should be displayed in the column footer. If you specify a value for this attribute, you cannot use the column's footer facet. |
| headerClass | String | | 10.0 | global | The style class used to display the table header, if defined. This attribute is used primarily to designate which CSS styles are applied when using an external CSS stylesheet. |
| headercolspan | String | | 10.0 | global | The number of columns that the header column spans in the table, if defined. This attribute cannot be used in Visualforce page versions 16.0 and above. |
| headerdir | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headerlang | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headeronclick | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headerondblclick | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headeronkeydown | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headeronkeypress | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headeronkeyup | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headeronmousedown | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headeronmousemove | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headeronmouseout | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headeronmouseover | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headeronmouseup | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headerstyle | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headertitle | String | | 10.0 | global | Deprecated in API 16.0; no effect on the page. |
| headerValue | String | | 12.0 | global | The text that should be displayed in the column header. If you specify a value for this attribute, you cannot use the column's header facet. Note also that specifying a value for this attribute overrides the default header label that appears if you use an inputField or outputField in the column body. |
| id | String | | 10.0 | global | An identifier that allows the column component to be referenced by other components in the page. |
| lang | String | | 10.0 | global | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. |
| onclick | String | | 10.0 | global | The JavaScript invoked if the onclick event occurs in the column --that is, if the column is clicked. Note that this value does not apply to the header and footer cells. |
| ondblclick | String | | 10.0 | global | The JavaScript invoked if the ondblclick event occurs in the column--that is, if the column is clicked twice. Note that this value does not apply to the header and footer cells. |
| onkeydown | String | | 10.0 | global | The JavaScript invoked if the onkeydown event occurs in the column --that is, if the user presses a keyboard key. Note that this value does not apply to the header and footer cells. |
| onkeypress | String | | 10.0 | global | The JavaScript invoked if the onkeypress event occurs in the column--that is, if the user presses or holds down a keyboard key. Note that this value does not apply to the header and footer cells. |
| onkeyup | String | | 10.0 | global | The JavaScript invoked if the onkeyup event occurs in the column--that is, if the user releases a keyboard key. Note that this value does not apply to the header and footer cells. |
| onmousedown | String | | 10.0 | global | The JavaScript invoked if the onmousedown event occurs in the column--that is, if the user clicks a mouse button. Note that this value does not apply to the header and footer cells. |
| onmousemove | String | | 10.0 | global | The JavaScript invoked if the onmousemove event occurs in the column--that is, if the user moves the mouse pointer. Note that this value does not apply to the header and footer cells. |
| onmouseout | String | | 10.0 | global | The JavaScript invoked if the onmouseout event occurs in the column--that is, if the user moves the mouse pointer away from the column. Note that this value does not apply to the header and footer cells. |
| onmouseover | String | | 10.0 | global | The JavaScript invoked if the onmouseover event occurs in the column--that is, if the user moves the mouse pointer over the column. Note that this value does not apply to the header and footer cells. |
| onmouseup | String | | 10.0 | global | The JavaScript invoked if the onmouseup event occurs in the column--that is, if the user releases the mouse button. Note that this value does not apply to the header and footer cells. |
| rendered | Boolean | | 10.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| rowspan | Integer | | 10.0 | global | The number of rows that each cell of this column takes up in the table. |
| style | String | | 10.0 | global | The style used to display the column, used primarily for adding inline CSS styles. Note that this value does not apply to the header and footer cells. |
| styleClass | String | | 10.0 | global | The style class used to display the column, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. Note that this value does not apply to the header and footer cells. |
| title | String | | 10.0 | global | The text to display as a tooltip when the user's mouse pointer hovers over this component. |
| value | String | | 12.0 | global | The text that should be displayed in every cell of the column, other than its header and footer cells. If you specify a value for this attribute, you cannot add any content between the column's opening and closing tags. |
| width | String | | 10.0 | global | The width of the column in pixels (px) or percentage (%). If not specified, this value defaults to 100 pixels. |

**Facets:**

| Facet | API | Description |
|---|---|---|
| footer | 10.0 | The components that appear in the footer cell for the column. Note that the order in which a footer facet appears in the body of a column component does not matter, because any facet with name="footer" will control the appearance of the final cell in the column. If you use a footer facet, you cannot specify a value for the column's footerValue attribute. |
| header | 10.0 | The components that appear in the header cell for the column. Note that the order in which a header facet appears in the body of a column component does not matter, because any facet with name="header" will control the appearance of the first cell in the column. If you use a header facet, you cannot specify a value for the column's headerValue attribute. Note also that specifying a value for this facet overrides the default header label that appears if you use an inputField or outputField in the column body. |

---

## 15. apex:dataList

**설명:** An ordered or unordered list of values that is defined by iterating over a set of data. The body of the `<apex:dataList>` component specifies how a single item should appear in the list. The data set can include up to 1,000 items.

```html
<!-- Page: -->
<apex:page controller="dataListCon">
<apex:dataList value="{!accounts}" var="account">
<apex:outputText value="{!account.Name}"/>
</apex:dataList>
</apex:page>
/*** Controller: ***/
public class dataListCon {
List<Account> accounts;
public List<Account> getAccounts() {
if(accounts == null) accounts = [SELECT Name FROM Account LIMIT 10];
return accounts;
}
}
```

The example above renders the following HTML:

```html
<ul id="thePage:theList">
<li id="thePage:theList:0">Bass Manufacturing</li>
<li id="thePage:theList:1">Ball Corp</li>
<li id="thePage:theList:2">Wessler Co.</li>
</ul>
```

**Attributes** (전부 API 10.0 · Access global):

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| dir | String | | 10.0 | global | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). |
| first | Integer | | 10.0 | global | The first element in the iteration that is visibly rendered in the list, where 0 is the index of the first element in the set of data specified by the value attribute. For example, if you did not want to display the first two elements in the set of records specified by the value attribute, set first="2". |
| id | String | | 10.0 | global | An identifier that allows the dataList component to be referenced by other components in the page. |
| lang | String | | 10.0 | global | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. |
| onclick | String | | 10.0 | global | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the list. |
| ondblclick | String | | 10.0 | global | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the list twice. |
| onkeydown | String | | 10.0 | global | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. |
| onkeypress | String | | 10.0 | global | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. |
| onkeyup | String | | 10.0 | global | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. |
| onmousedown | String | | 10.0 | global | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. |
| onmousemove | String | | 10.0 | global | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. |
| onmouseout | String | | 10.0 | global | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the list. |
| onmouseover | String | | 10.0 | global | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the list. |
| onmouseup | String | | 10.0 | global | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. |
| rendered | Boolean | | 10.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| rows | Integer | | 10.0 | global | The maximum number of items to display in the list. If not specified, this value defaults to 0, which displays all possible list items. |
| style | String | | 10.0 | global | The style used to display the dataList component, used primarily for adding inline CSS styles. |
| styleClass | String | | 10.0 | global | The style class used to display the dataList component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. |
| title | String | | 10.0 | global | The text to display as a tooltip when the user's mouse pointer hovers over this component. |
| type | String | | 10.0 | global | The type of list that should display. For ordered lists, possible values include "1", "a", "A", "i", or "I". For unordered lists, possible values include "disc", "square", and "circle". If not specified, this value defaults to "disc". |
| value | Object | | 10.0 | global | The collection of data displayed in the list. |
| var | String | Yes | 10.0 | global | The name of the variable that should represent one element in the collection of data specified by the value attribute. You can use this variable to display the element in the body of the dataList component tag. |

---

## 16. apex:dataTable

**설명:** An HTML table that's defined by iterating over a set of data, displaying information about one item of data per row. The body of the `<apex:dataTable>` contains one or more column components that specify what information should be displayed for each item of data. The data set can include up to 1,000 items, or 10,000 items when the page is executed in read-only mode. For Visualforce pages running API version 20.0 or higher, an `<apex:repeat>` tag can be contained within this component to generate columns. See also: `<apex:panelGrid>`. This component supports HTML pass-through attributes using the "html-" prefix. Pass-through attributes are attached to the generated table's `<tbody>` tag.

```html
<!-- Page: -->
<apex:page controller="dataTableCon" id="thePage">
<apex:dataTable value="{!accounts}" var="account" id="theTable"
rowClasses="odd,even" styleClass="tableClass">
<apex:facet name="caption">table caption</apex:facet>
<apex:facet name="header">table header</apex:facet>
<apex:facet name="footer">table footer</apex:facet>
<apex:column>
<apex:facet name="header">Name</apex:facet>
<apex:facet name="footer">column footer</apex:facet>
<apex:outputText value="{!account.name}"/>
</apex:column>
<apex:column>
<apex:facet name="header">Owner</apex:facet>
<apex:facet name="footer">column footer</apex:facet>
<apex:outputText value="{!account.owner.name}"/>
</apex:column>
</apex:dataTable>
</apex:page>
/*** Controller: ***/
public class dataTableCon {
List<Account> accounts;
public List<Account> getAccounts() {
if(accounts == null)
accounts = [SELECT name, owner.name FROM account LIMIT 10];
return accounts;
}
}
```

**Attributes** (전부 API 10.0 · Access global):

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| align | String | | 10.0 | global | The position of the rendered HTML table with respect to the page. Possible values include "left", "center", or "right". If left unspecified, this value defaults to "left". |
| bgcolor | String | | 10.0 | global | The background color of the rendered HTML table. |
| border | String | | 10.0 | global | The width of the frame around the rendered HTML table, in pixels. |
| captionClass | String | | 10.0 | global | The style class used to display the caption for the rendered HTML table, if a caption facet is specified. This attribute is used primarily to designate which CSS styles are applied when using an external CSS stylesheet. |
| captionStyle | String | | 10.0 | global | The style used to display the caption for the rendered HTML table, if a caption facet is specified. This attribute is used primarily for adding inline CSS styles. |
| cellpadding | String | | 10.0 | global | The amount of space between the border of each table cell and its contents. If the value of this attribute is a pixel length, all four margins are this distance from the contents. If the value of the attribute is a percentage length, the top and bottom margins are equally separated from the content based on a percentage of the available vertical space, and the left and right margins are equally separated from the content based on a percentage of the available horizontal space. |
| cellspacing | String | | 10.0 | global | The amount of space between the border of each table cell and the border of the other cells surrounding it and/or the table's edge. This value must be specified in pixels or percentage. |
| columnClasses | String | | 10.0 | global | A comma-separated list of one or more classes associated with the table's columns, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. If more than one class is specified, the classes are applied in a repeating fashion to all columns. For example, if you specify columnClasses="classA, classB", then the first column is styled with classA, the second column is styled with classB, the third column is styled with classA, the fourth column is styled with classB, and so on. |
| columns | Integer | | 10.0 | global | The number of columns in this table. |
| columnsWidth | String | | 10.0 | global | A comma-separated list of the widths applied to each table column. Values can be expressed as pixels (for example, columnsWidth="100px, 100px"). |
| dir | String | | 10.0 | global | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). |
| first | Integer | | 10.0 | global | The first element in the iteration visibly rendered in the table, where 0 is the index of the first element in the set of data specified by the value attribute. For example, if you did not want to display the first two elements in the set of records specified by the value attribute, set first="2". |
| footerClass | String | | 10.0 | global | The style class used to display the footer (bottom row) for the rendered HTML table, if a footer facet is specified. This attribute is used primarily to designate which CSS styles are applied when using an external CSS stylesheet. |
| frame | String | | 10.0 | global | The borders drawn for this table. Possible values include "none", "above", "below", "hsides", "vsides", "lhs", "rhs", "box", and "border". If not specified, this value defaults to "border". |
| headerClass | String | | 10.0 | global | The style class used to display the header for the rendered HTML table, if a header facet is specified. This attribute is used primarily to designate which CSS styles are applied when using an external CSS stylesheet. |
| id | String | | 10.0 | global | An identifier that allows the dataTable component to be referenced by other components in the page. |
| lang | String | | 10.0 | global | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. |
| onclick | String | | 10.0 | global | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the data table. |
| ondblclick | String | | 10.0 | global | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the data table twice. |
| onkeydown | String | | 10.0 | global | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. |
| onkeypress | String | | 10.0 | global | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. |
| onkeyup | String | | 10.0 | global | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. |
| onmousedown | String | | 10.0 | global | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. |
| onmousemove | String | | 10.0 | global | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. |
| onmouseout | String | | 10.0 | global | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the data table. |
| onmouseover | String | | 10.0 | global | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the data table. |
| onmouseup | String | | 10.0 | global | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. |
| onRowClick | String | | 10.0 | global | The JavaScript invoked if the onRowClick event occurs--that is, if the user clicks a row in the data table. |
| onRowDblClick | String | | 10.0 | global | The JavaScript invoked if the onRowDblClick event occurs--that is, if the user clicks a row in the data table twice. |
| onRowMouseDown | String | | 10.0 | global | The JavaScript invoked if the onRowMouseDown event occurs--that is, if the user clicks a mouse button in a row of the data table. |
| onRowMouseMove | String | | 10.0 | global | The JavaScript invoked if the onRowMouseMove event occurs--that is, if the user moves the mouse pointer over a row of the data table. |
| onRowMouseOut | String | | 10.0 | global | The JavaScript invoked if the onRowMouseOut event occurs--that is, if the user moves the mouse pointer away from a row in the data table. |
| onRowMouseOver | String | | 10.0 | global | The JavaScript invoked if the onRowMouseOver event occurs--that is, if the user moves the mouse pointer over a row in the data table. |
| onRowMouseUp | String | | 10.0 | global | The JavaScript invoked if the onRowMouseUp event occurs--that is, if the user releases the mouse button over a row in the data table. |
| rendered | Boolean | | 10.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| rowClasses | String | | 10.0 | global | A comma-separated list of one or more classes associated with the table's rows, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. If more than one class is specified, the classes are applied in a repeating fashion to all rows. For example, if you specify columnRows="classA, classB", then the first row is styled with classA, the second row is styled with classB, the third row is styled with classA, the fourth row is styled with classB, and so on. *[sic — PDF says "columnRows"]* |
| rows | Integer | | 10.0 | global | The number of rows in this table. |
| rules | String | | 10.0 | global | The borders drawn between cells in the table. Possible values include "none", "groups", "rows", "cols", and "all". If not specified, this value defaults to "none". |
| style | String | | 10.0 | global | The style used to display the dataTable component, used primarily for adding inline CSS styles. |
| styleClass | String | | 10.0 | global | The style class used to display the dataTable component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. |
| summary | String | | 10.0 | global | A summary of the table's purpose and structure for Section 508 compliance. |
| title | String | | 10.0 | global | The text to display as a tooltip when the user's mouse pointer hovers over this component. |
| value | Object | Yes | 10.0 | global | The collection of data displayed in the table. |
| var | String | Yes | 10.0 | global | The name of the variable that represents one element in the collection of data specified by the value attribute. You can then use this variable to display the element itself in the body of the dataTable component tag. |
| width | String | | 10.0 | global | The width of the entire table, expressed either as a relative percentage to the total amount of available horizontal space (for example, width="80%"), or as the number of pixels (for example, width="800px"). |

> `apex:dataTable`는 `caption`/`header`/`footer` facet과 column 단위 `header`/`footer` facet을 지원한다(위 예제 참조).

---

## 17. apex:pageBlockTable

**설명:** A list of data displayed as a table within either an `<apex:pageBlock>` or `<apex:pageBlockSection>` component, similar to a related list or list view in a standard Salesforce page. Like an `<apex:dataTable>`, an `<apex:pageBlockTable>` is defined by iterating over a set of data, displaying information about one item of data per row. The set of data can contain up to 1,000 items, or 10,000 items when the page is executed in read-only mode. The body of the `<apex:pageBlockTable>` contains one or more column components that specify what information should be displayed for each item of data, similar to a table. Unlike the `<apex:dataTable>` component, the default styling for `<apex:pageBlockTable>` matches standard Salesforce styles. Any additional styles specified with `<apex:pageBlockTable>` attributes are appended to the standard Salesforce styles. Note that if you specify an sObject field as the value attribute for a column, the associated label for that field is used as the column header by default. To override this behavior, use the headerValue attribute on the column, or the column's header facet. For Visualforce pages running API version 20.0 or higher, an `<apex:repeat>` tag can be contained within this component to generate columns. This component supports HTML pass-through attributes using the "html-" prefix. Pass-through attributes are attached to the generated table's `<tbody>` tag.

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL.
For example, if 001D000000IRt53 is the account ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<!-- Page: -->
<apex:page standardController="Account">
<apex:pageBlock title="My Content">
<apex:pageBlockTable value="{!account.Contacts}" var="item">
<apex:column value="{!item.name}"/>
</apex:pageBlockTable>
</apex:pageBlock>
</apex:page>
```

**Attributes** (전부 API 12.0 · Access global):

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| align | String | | 12.0 | global | The position of the rendered HTML table with respect to the page. Possible values include "left", "center", or "right". If left unspecified, this value defaults to "left". |
| bgcolor | String | | 12.0 | global | This attribute was deprecated in Salesforce API version 18.0 and has no effect on the page. |
| border | String | | 12.0 | global | The width of the frame around the rendered HTML table, in pixels. |
| captionClass | String | | 12.0 | global | The style class used to display the caption for the rendered HTML table, if a caption facet is specified. This attribute is used primarily to designate which CSS styles are applied when using an external CSS stylesheet. |
| captionStyle | String | | 12.0 | global | The style used to display the caption for the rendered HTML table, if a caption facet is specified. This attribute is used primarily for adding inline CSS styles. |
| cellpadding | String | | 12.0 | global | The amount of space between the border of each list cell and its content. If the value of this attribute is a pixel length, all four margins are this distance from the content. If the value of the attribute is a percentage length, the top and bottom margins are equally separated from the content based on a percentage of the available vertical space, and the left and right margins are equally separated from the content based on a percentage of the available horizontal space. |
| cellspacing | String | | 12.0 | global | The amount of space between the border of each list cell and the border of the other cells surrounding it and/or the list's edge. This value must be specified in pixels or percentage. |
| columnClasses | String | | 12.0 | global | A comma-separated list of one or more classes associated with the list's columns, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. If more than one class is specified, the classes are applied in a repeating fashion to all columns. For example, if you specify columnClasses="classA, classB", then the first column is styled with classA, the second column is styled with classB, the third column is styled with classA, the fourth column is styled with classB, and so on. |
| columns | Integer | | 12.0 | global | The number of columns in this page block table. |
| columnsWidth | String | | 12.0 | global | A comma-separated list of the widths applied to each list column. Values can be expressed as pixels (for example, columnsWidth="100px, 100px"). |
| dir | String | | 12.0 | global | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). |
| first | Integer | | 12.0 | global | The first element in the iteration visibly rendered in the page block table, where 0 is the index of the first element in the set of data specified by the value attribute. For example, if you did not want to display the first two elements in the set of records specified by the value attribute, set first="2". |
| footerClass | String | | 12.0 | global | The style class used to display the footer (bottom row) for the rendered HTML table, if a footer facet is specified. This attribute is used primarily to designate which CSS styles are applied when using an external CSS stylesheet. |
| frame | String | | 12.0 | global | The borders drawn for this page block table. Possible values include "none", "above", "below", "hsides", "vsides", "lhs", "rhs", "box", and "border". If not specified, this value defaults to "border". |
| headerClass | String | | 12.0 | global | The style class used to display the header for the rendered HTML table, if a header facet is specified. This attribute is used primarily to designate which CSS styles are applied when using an external CSS stylesheet. |
| id | String | | 12.0 | global | An identifier that allows the pageBlockTable component to be referenced by other components in the page. |
| lang | String | | 12.0 | global | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. |
| onclick | String | | 12.0 | global | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the page block table. |
| ondblclick | String | | 12.0 | global | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the page block table twice. |
| onkeydown | String | | 12.0 | global | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. |
| onkeypress | String | | 12.0 | global | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. |
| onkeyup | String | | 12.0 | global | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. |
| onmousedown | String | | 12.0 | global | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. |
| onmousemove | String | | 12.0 | global | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. |
| onmouseout | String | | 12.0 | global | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the page block table. |
| onmouseover | String | | 12.0 | global | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the page block table. |
| onmouseup | String | | 12.0 | global | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. |
| onRowClick | String | | 12.0 | global | The JavaScript invoked if the onRowClick event occurs--that is, if the user clicks a row in the page block table. |
| onRowDblClick | String | | 12.0 | global | The JavaScript invoked if the onRowDblClick event occurs--that is, if the user clicks a row in the page block list table. |
| onRowMouseDown | String | | 12.0 | global | The JavaScript invoked if the onRowMouseDown event occurs--that is, if the user clicks a mouse button in a row of the page block table. |
| onRowMouseMove | String | | 12.0 | global | The JavaScript invoked if the onRowMouseMove event occurs--that is, if the user moves the mouse pointer over a row of the page block table. |
| onRowMouseOut | String | | 12.0 | global | The JavaScript invoked if the onRowMouseOut event occurs--that is, if the user moves the mouse pointer away from a row in the page block table. |
| onRowMouseOver | String | | 12.0 | global | The JavaScript invoked if the onRowMouseOver event occurs--that is, if the user moves the mouse pointer over a row in the page block table. |
| onRowMouseUp | String | | 12.0 | global | The JavaScript invoked if the onRowMouseUp event occurs--that is, if the user releases the mouse button over a row in the page block table. |
| rendered | Boolean | | 12.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| rowClasses | String | | 12.0 | global | A comma-separated list of one or more classes associated with the page block table's rows, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. If more than one class is specified, the classes are applied in a repeating fashion to all rows. For example, if you specify columnRows="classA, classB", then the first row is styled with classA, the second row is styled with classB, the third row is styled with classA, the fourth row is styled with classB, and so on. *[sic — PDF says "columnRows"]* |
| rows | Integer | | 12.0 | global | The number of rows in this page block table. |
| rules | String | | 12.0 | global | The borders drawn between cells in the page block table. Possible values include "none", "groups", "rows", "cols", and "all". If not specified, this value defaults to "none". |
| style | String | | 12.0 | global | The style used to display the pageBlockTable component, used primarily for adding inline CSS styles. |
| styleClass | String | | 12.0 | global | The style class used to display the pageBlockTable component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. |
| summary | String | | 12.0 | global | A summary of the page block table's purpose and structure for Section 508 compliance. |
| title | String | | 12.0 | global | The text to display as a tooltip when the user's mouse pointer hovers over this component. |
| value | Object | Yes | 12.0 | global | The collection of data displayed in the page block table. |
| var | String | Yes | 12.0 | global | The name of the variable that represents one element in the collection of data specified by the value attribute. You can then use this variable to display the element itself in the body of the pageBlockTable component tag. |
| width | String | | 12.0 | global | The width of the entire pageBlockTable, expressed either as a relative percentage to the total amount of available horizontal space (for example, width="80%"), or as the number of pixels (for example, width="800px"). |

**Facets:**

| Facet | API | Description |
|---|---|---|
| caption | 12.0 | The components that appear in the caption for the page block table. Note that the order in which a caption facet appears in the body of a pageBlockTable component does not matter, because any facet with name="caption" will control the appearance of the table's caption. |
| footer | 12.0 | The components that appear in the footer row for the page block table. Note that the order in which a footer facet appears in the body of a pageBlockTable component does not matter, because any facet with name="footer" will control the appearance of the final row in the table. |
| header | 12.0 | The components that appear in the header row for the page block table. Note that the order in which a header facet appears in the body of a pageBlockTable component does not matter, because any facet with name="header" will control the appearance of the first row in the table. |

---

## 18. apex:repeat

**설명:** An iteration component that allows you to output the contents of a collection according to a structure that you specify. The collection can include up to 1,000 items. Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields. Note that if used within an `<apex:pageBlockSection>` or `<apex:panelGrid>` component, all content generated by a child `<apex:repeat>` component is placed in a single `<apex:pageBlockSection>` or `<apex:panelGrid>` cell. This component can't be used as a direct child of the following components: • `<apex:panelBar>` • `<apex:selectCheckboxes>` • `<apex:selectList>` • `<apex:selectRadio>` • `<apex:tabPanel>`

```html
<!-- Page: -->
<apex:page controller="repeatCon" id="thePage">
<apex:repeat value="{!strings}" var="string" id="theRepeat">
<apex:outputText value="{!string}" id="theValue"/><br/>
</apex:repeat>
</apex:page>

/*** Controller: ***/
public class repeatCon {
public String[] getStrings() {
return new String[]{'ONE','TWO','THREE'};
}
}
```

The example above renders the following HTML:

```html
<span id="thePage:theRepeat:0:theValue">ONE</span><br/>
<span id="thePage:theRepeat:1:theValue">TWO</span><br/>
<span id="thePage:theRepeat:2:theValue">THREE</span><br/>
```

Standard Component Example:

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL.
For example, if 001D000000IRt53 is the account ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<!-- Page: -->
<apex:page standardController="Account">
<table border="0" >
<tr>
<th>Case Number</th><th>Origin</th>
<th>Creator Email</th><th>Status</th>
</tr>
<apex:repeat var="cases" value="{!Account.Cases}">
<tr>
<td>{!cases.CaseNumber}</td>
<td>{!cases.Origin}</td>
<td>{!cases.Contact.email}</td>
<td>{!cases.Status}</td>
</tr>
</apex:repeat>
</table>
</apex:page>
```

**Attributes** (전부 API 10.0 · Access global; 필수 attribute 없음):

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| first | Integer | | 10.0 | global | The first element in the collection visibly rendered, where 0 is the index of the first element in the set of data specified by the value attribute. For example, if you did not want to display the first two elements in the set of records specified by the value attribute, set first="2". |
| id | String | | 10.0 | global | An identifier that allows the repeat component to be referenced by other components in the page. |
| rendered | Boolean | | 10.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| rows | Integer | | 10.0 | global | The maximum number of items in the collection that are rendered. If this value is less than the number of items in the collection, the items at the end of the collection are not repeated. |
| value | Object | | 10.0 | global | The collection of data that is iterated over. |
| var | String | | 10.0 | global | The name of the variable that represents the current item in the iteration. |

---

## 19. apex:detail

**설명:** The standard detail page for a particular object, as defined by the associated page layout for the object in Setup. This component includes attributes for including or excluding the associated related lists, related list hover links, and title bar that appear in the standard Salesforce application interface.

> Note: Don't wrap `<apex:detail>` in an `<apex:form>` component. `<apex:detail>` already provides a `<form>` element.

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL.
For example, if 001D000000IRt53 is the account ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<apex:page standardController="Account">
<apex:detail subject="{!account.ownerId}" relatedList="false" title="false"/>
</apex:page>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| id | String | | 10.0 | global | An identifier that allows the detail component to be referenced by other components in the page. |
| inlineEdit | Boolean | | 20.0 | | Controls whether the component supports inline editing. See also: `<apex:inlineEditSupport>` |
| oncomplete | String | | 20.0 | | The JavaScript invoked if the oncomplete event occurs--that is, when the tab has been selected and its content rendered on the page. This attribute only works if inlineEdit or showChatter are set to true. |
| relatedList | Boolean | | 10.0 | global | A Boolean value that specifies whether the related lists are included in the rendered component. If true, the related lists are displayed. If not specified, this value defaults to true. |
| relatedListHover | Boolean | | 10.0 | global | A Boolean value that specifies whether the related list hover links are included in the rendered component. If true, the related list hover links are displayed. If not specified, this value defaults to true. Note that this attribute is ignored if the relatedList attribute is false, or if the "Enable Related List Hover Links" option is not selected under Setup \| Customize \| User Interface. |
| rendered | Boolean | | 10.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| rerender | Object | | 20.0 | | The ID of one or more components that are redrawn when the result of an AJAX update request returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. This attribute only works if inlineEdit or showChatter are set to true. |
| showChatter | Boolean | | 20.0 | | A Boolean value that specifies whether to display the Chatter information and controls for the record. If this is true, and showHeader on `<apex:page>` is false, then the layout looks exactly as if the `<chatter:feedWithFollowers>` is being used. If this is true, and showHeader on `<apex:page>` is true, then the layout looks like the regular Chatter UI. |
| subject | String | | 10.0 | global | The ID of the record that should provide data for this component. |
| title | Boolean | | 10.0 | global | A Boolean value that specifies whether the title bar is included in the rendered component. If true, the title bar is displayed. If not specified, this value defaults to true. |

---

## 20. apex:relatedList

**설명:** A list of Salesforce records that are related to a parent record with a lookup or master-detail relationship.

```html
<!-- For this example to render properly, you must associate the Visualforce page
with a valid account record in the URL.
For example, if 001D000000IRt53 is the account ID, the resulting URL should be:
https://MyDomain_login_URL/apex/myPage?id=001D000000IRt53
See the Visualforce Developer's Guide Quick Start Tutorial for more information. -->
<apex:page standardController="Account">
<apex:pageBlock>
You're looking at some related lists for {!account.name}:
</apex:pageBlock>
<apex:relatedList list="Opportunities" />
<apex:relatedList list="Contacts">
<apex:facet name="header">Titles can be overriden with facets</apex:facet>
</apex:relatedList>
<apex:relatedList list="Cases" title="Or you can keep the image, but change the text" />
</apex:page>
```

**Attributes** (전부 API 10.0 · Access global):

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| id | String | | 10.0 | global | An identifier that allows the relatedList component to be referenced by other components in the page. |
| list | String | Yes | 10.0 | global | The related list to display. This does not need to be on an object's page layout. To specify this value, use the name of the child relationship to the related object. For example, to display the Contacts related list that would normally display on an account detail page, use list="Contacts". |
| pageSize | Integer | | 10.0 | global | The number of records to display by default in the related list. If not specified, this value defaults to 5. |
| rendered | Boolean | | 10.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| subject | String | | 10.0 | global | The parent record from which the data and related list definition are derived. If not specified, and if using a standard controller, this value is automatically set to the value of the ID query string parameter in the page URL. |
| title | String | | 10.0 | global | The text displayed as the title of the related list. If not specified, this value defaults to the title specified in the application. |

**Facets:**

| Facet | API | Description |
|---|---|---|
| body | 10.0 | The components that appear in the body of the related list. Note that the order in which a body facet appears in a relatedList component does not matter, because any facet with name="body" will control the appearance of the related list body. If specified, this facet overrides any other content in the related list tag. |
| footer | 10.0 | The components that appear in the footer area of the related list. Note that the order in which a footer facet appears in the body of a relatedList component does not matter, because any facet with name="footer" will control the appearance of the bottom of the related list. |
| header | 10.0 | The components that appear in the header area of the related list. Note that the order in which a header facet appears in the body of a relatedList component does not matter, because any facet with name="header" will control the appearance of the top of the related list. |

---

## 21. apex:listViews

**설명:** The list view picklist for an object, including its associated list of records for the currently selected view. In standard Salesforce applications this component is displayed on the main tab for a particular object. See also: `<apex:enhancedList>`.

```html
<apex:page showHeader="true" tabstyle="Case">
<apex:ListViews type="Case" />
<apex:ListViews type="MyCustomObject__c" />
</apex:page>
```

**Attributes** (전부 API 10.0 · Access global):

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| id | String | | 10.0 | global | An identifier that allows the listViews component to be referenced by other components in the page. |
| rendered | Boolean | | 10.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| type | String | Yes | 10.0 | global | The Salesforce object for which list views are displayed, for example, type="Account" or type="My_Custom_Object__c". |

**Facets:**

| Facet | API | Description |
|---|---|---|
| body | 10.0 | The components that should appear in the body of the displayed list of records. Note that the order in which a body facet appears in a listViews component does not matter, because any facet with name="body" will control the appearance of the body of the displayed list. Also note that if you define a body facet, it replaces the list of records that would normally display as part of the list view. |
| footer | 10.0 | The components that should appear in the footer of the displayed list of records. Note that the order in which a footer facet appears in the body of a listViews component does not matter, because any facet with name="footer" will control the appearance of the bottom of the displayed list. |
| header | 10.0 | The components that should appear in the header of the displayed list of records. Note that the order in which a header facet appears in the body of a listViews component does not matter, because any facet with name="header" will control the appearance of the top of the displayed list. |

---

## 22. apex:enhancedList

**설명:** The list view picklist for an object, including its associated list of records for the currently selected view. In standard Salesforce applications this component is displayed on the main tab for a particular object. This component has additional attributes that can be specified, such as the height and rows per page, as compared to `<apex:listView>`.

> Note: When an `<apex:enhancedList>` is rerendered through another component's rerender attribute, the `<apex:enhancedList>` must be inside of an `<apex:outputPanel>` component that has its layout attribute set to "block". The `<apex:enhancedList>` component is not allowed on pages that have the attribute showHeader set to false. You can only have five `<apex:enhancedList>` components on a single page. Ext JS versions less than 3 should not be included on pages that use this component. See also: `<apex:listView>`.

```html
<apex:page>
<apex:enhancedList type="Account" height="300" rowsPerPage="10" id="AccountList" />
<apex:enhancedList type="Lead" height="300" rowsPerPage="25"
id="LeadList" customizable="False" />
</apex:page>
```

**Attributes** (전부 API 14.0):

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| customizable | Boolean | | 14.0 | | A Boolean value that specifies whether the list can be customized by the current user. If not specified, the default value is true. If this attribute is set to false, the current user will not be able to edit the list definition or change the list name, filter criteria, columns displayed, column order, or visibility. However, the current user's personal preferences can still be set, such as column width or sort order. |
| height | Integer | Yes | 14.0 | | An integer value that specifies the height of the list in pixels. This value is required. |
| id | String | | 14.0 | global | An identifier that allows the component to be referenced by other components in the page. |
| listId | String | | 14.0 | | The database ID of the desired list view. When editing a list view definition, this ID is the 15-character string after 'fcf=' in the browser's address bar. This value is required if type is not specified. |
| oncomplete | String | | 14.0 | | The JavaScript that runs after the page is refreshed in the browser. Note that refreshing the page automatically calls this JavaScript, while an inline edit and subsequent save does not. |
| rendered | Boolean | | 14.0 | | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| reRender | Object | | 14.0 | | The ID of one or more components that are redrawn when the result of an AJAX update request returns to the client. This value can be a single ID, a comma-separated list of IDs, or a merge field expression for a list or collection of IDs. Note: When an enhancedList is rerendered through another component's rerender attribute, the enhanceList must be inside of an apex:outputPanel component that has layout attribute set to "block". |
| rowsPerPage | Integer | | 14.0 | | An integer value that specifies the number of rows per page. The default value is the preference of the current user. Possible values are 10, 25, 50, 100, 200. Note: If you set the value for greater than 100, a message is automatically displayed to the user, warning of the potential for performance degradation. |
| type | String | | 14.0 | | The Salesforce object for which views are displayed, for example, type="Account" or type="My_Custom_Object__c". |
| width | Integer | | 14.0 | | An integer value that specifies the width of the list in pixels. The default value is the available page width, or the width of the browser if the list is not displayed in the initially viewable area of the viewport. |

---

## 23. apex:image

**설명:** A graphic image, rendered with the HTML `<img>` tag. Use this component to get user input for a controller method that does not correspond to a field on an sObject. Only `<apex:inputField>` and `<apex:outputField>` can be used with sObject fields. This component supports HTML pass-through attributes using the "html-" prefix. Pass-through attributes are attached to the generated `<img>` tag.

```html
<apex:image id="theImage" value="/img/myimage.gif" width="220" height="55" alt="Description of image here"/>
```

The example above renders the following HTML:

```html
<img id="theImage" src="/img/myimage.gif" width="220" height="55" alt="Description of image here"/>
```

Resource Example:

```html
<apex:image id="theImage" value="{!$Resource.myResourceImage}" width="200" height="200" alt="Description of image here"/>
```

renders:

```html
<img id="theImage" src="<generatedId>/myResourceImage" width="200" height="200" alt="Description of image here"/>
```

Zip Resource Example:

```html
<apex:image url="{!URLFOR($Resource.TestZip, 'images/Bluehills.jpg')}" width="50" height="50" alt="Description of image here"/>
```

renders (PDF 원문에 `<img` 누락된 채로 인쇄됨 [sic]):

```html
<id="theImage" src="[generatedId]/images/Bluehills.jpg" width="50" height="50" alt="Description of image here"/>
```

IMAGEPROXYURL Example:

```html
<apex:image id="theImage" value="{ !IMAGEPROXYURL('http://somedomain.com/pic.png')}" alt="Description of image here"/>
```

renders:

```html
<img id="theImage" src="https://MyDomainName--UniqueID.file.force-user-content.com?url=http://somedomain.com/pic.png&hash=...." alt="Description of image here"/>
```

**Attributes** (전부 API 10.0 · Access global):

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| alt | String | | 10.0 | global | An alternate text description of the image, used for Section 508 compliance. |
| dir | String | | 10.0 | global | The direction in which the generated HTML component should be read. Possible values include "RTL" (right to left) or "LTR" (left to right). |
| height | String | | 10.0 | global | The height at which this image should be displayed, expressed either as a relative percentage of the total available vertical space (for example, height="50%") or as a number of pixels (for example, height="100px"). If not specified, this value defaults to the dimension of the source image file. |
| id | String | | 10.0 | global | An identifier that allows the image component to be referenced by other components in the page. |
| ismap | Boolean | | 10.0 | global | A Boolean value that specifies whether this image should be used as an image map. If set to true, the image component must be a child of a commandLink component. If not specified, this value defaults to false. |
| lang | String | | 10.0 | global | The base language for the generated HTML output, for example, "en" or "en-US". For more information on this attribute, see the W3C specifications. |
| longdesc | String | | 10.0 | global | A URL that links to a longer description of the image. |
| onclick | String | | 10.0 | global | The JavaScript invoked if the onclick event occurs--that is, if the user clicks the image. |
| ondblclick | String | | 10.0 | global | The JavaScript invoked if the ondblclick event occurs--that is, if the user clicks the image twice. |
| onkeydown | String | | 10.0 | global | The JavaScript invoked if the onkeydown event occurs--that is, if the user presses a keyboard key. |
| onkeypress | String | | 10.0 | global | The JavaScript invoked if the onkeypress event occurs--that is, if the user presses or holds down a keyboard key. |
| onkeyup | String | | 10.0 | global | The JavaScript invoked if the onkeyup event occurs--that is, if the user releases a keyboard key. |
| onmousedown | String | | 10.0 | global | The JavaScript invoked if the onmousedown event occurs--that is, if the user clicks a mouse button. |
| onmousemove | String | | 10.0 | global | The JavaScript invoked if the onmousemove event occurs--that is, if the user moves the mouse pointer. |
| onmouseout | String | | 10.0 | global | The JavaScript invoked if the onmouseout event occurs--that is, if the user moves the mouse pointer away from the image. |
| onmouseover | String | | 10.0 | global | The JavaScript invoked if the onmouseover event occurs--that is, if the user moves the mouse pointer over the image. |
| onmouseup | String | | 10.0 | global | The JavaScript invoked if the onmouseup event occurs--that is, if the user releases the mouse button. |
| rendered | Boolean | | 10.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| style | String | | 10.0 | global | The style used to display the image component, used primarily for adding inline CSS styles. |
| styleClass | String | | 10.0 | global | The style class used to display the image component, used primarily to designate which CSS styles are applied when using an external CSS stylesheet. |
| title | String | | 10.0 | global | The text to display as a tooltip when the user's mouse pointer hovers over this component. |
| url | String | | 10.0 | global | The path to the image displayed, expressed either as a URL or as a static resource or document merge field. |
| usemap | String | | 10.0 | global | The name of a client-side image map (an HTML map element) for which this element provides the image. |
| value | Object | | 10.0 | global | The path to the image displayed, expressed either as a URL or as a static resource or document merge field. |
| width | String | | 10.0 | global | The width at which this image should be displayed, expressed either as a relative percentage of the total available horizontal space (for example, width="50%") or as a number of pixels (for example, width="100px"). If not specified, this value defaults to the dimension of the source image file. |

---

## 24. apex:milestoneTracker

**설명:** Displays the milestone tracker.

```html
<apex:page standardController="Case" showHeader="true">
<apex:milestoneTracker entityId="{!case.id}"/>
</apex:page>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| entityId | String | Yes | 29.0 | | Entity ID of the record for which to display the milestones. |
| id | String | | 14.0 | global | An identifier that allows the component to be referenced by other components in the page. |
| rendered | Boolean | | 14.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |

---

## 25. apex:vote

**설명:** A component that displays the vote control for an object that supports it.

> PDF에 `apex:vote` 단독 코드 예제 없음.

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| id | String | | 14.0 | global | An identifier that allows the component to be referenced by other components in the page. |
| objectId | String | Yes | 26.0 | global | An identifier for the object to vote on. |
| rendered | Boolean | | 14.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| rerender | String | | 43.0 | | The area(s) of the page that are refreshed when the action is taken. |

---

## 26. apex:map

**설명:** Display an interactive, JavaScript-based map, complete with zooming, panning, and markers based on your Salesforce or other data. `<apex:map>` doesn't, by itself, display map markers, even for the center point. To display up to 100 markers, add child `<apex:mapMarker>` components.

Street Map Showing an Account Location:

```html
<apex:page standardController="Account">
<!-- This page must be accessed with an Account Id in the URL. For example:
https://MyDomainName--c.vf.force.com/apex/AccountLocation?id=001D000000JRBet -->
<apex:pageBlock >
<apex:pageBlockSection title="{! Account.Name } Location">
<!-- Display the text version of the address -->
<apex:outputPanel >
<apex:outputField value="{!Account.BillingStreet}"/><br/>
<apex:outputField value="{!Account.BillingCity}"/>, &nbsp;
<apex:outputField value="{!Account.BillingState}"/> &nbsp;
<apex:outputField value="{!Account.BillingPostalCode}"/><br/>
<apex:outputField value="{!Account.BillingCountry}"/>
</apex:outputPanel>
<!-- Display the address on a map -->
<apex:map width="600px" height="400px" mapType="roadmap" zoomLevel="17"
center="{!Account.BillingStreet},{!Account.BillingCity},{!Account.BillingState}">
</apex:map>
</apex:pageBlockSection>
</apex:pageBlock>
</apex:page>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| center | Object | (조건부) | 32.0 | global | Specifies the location of the map center. There are several ways to define the center: • A string representing an address. For example, "1 Market Street, San Francisco, CA". The address is automatically geocoded to determine its actual latitude and longitude. • A string representing a JSON object with latitude and longitude attributes that specify location coordinates. For example, "{latitude: 37.794, longitude: -122.395}". • An Apex map object of type Map<String, Double>, with latitude and longitude keys to specify location coordinates. This attribute is required if `<apex:map>` doesn't have any child `<apex:mapMarker>` tags. When center isn't set, the map is centered to display all the markers. |
| height | String | Yes | 32.0 | | The height of the map, expressed either as a percentage of the available vertical space (for example, height="50%"), or as a number of pixels (for example, height="200px"). Note: This value is passed through to the generated HTML for the map. If you provide an invalid value, your map might not render. |
| id | String | | 32.0 | global | An identifier that allows other components in the page to reference this component. |
| mapType | String | | 32.0 | | The type of map to display. Must be one of the following: • hybrid • roadmap • satellite. If not specified, this value defaults to roadmap. |
| rendered | Boolean | | 32.0 | | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| scrollBasedZooming | Boolean | | 37.0 | | A Boolean value that specifies whether zooming via scroll wheel is enabled on the map. If not specified, this value defaults to true. |
| showOnlyActiveInfoWindow | Boolean | | 34.0 | | A Boolean value that specifies whether multiple info windows can be displayed on the map at the same time. If not specified, this value defaults to true and only one info window is displayed at a time. That is, when you click another marker, the first info window disappears and the new info window appears. |
| width | String | Yes | 32.0 | | The width of the map, expressed either as a percentage of the available horizontal space (for example, width="50%"), or as a number of pixels (for example, width="200px"). Note: This value is passed through to the generated HTML for the map. If you provide an invalid value, your map might not render. |
| zoomLevel | Integer | | 32.0 | | The initial map zoom level, defined as integer from 0 to 18. Higher values are more completely zoomed in. When child `<apex:mapMarker>` tags are present and zoomLevel isn't set, the map is zoomed and centered to display all of the markers. If not specified and there are no markers, the default value is 15. |

> `center`는 `<apex:map>`에 자식 `<apex:mapMarker>`가 없을 때 필수다.

---

## 27. apex:mapMarker

**설명:** Defines a marker to be displayed at a location on an `<apex:map>`.

> Note: This component must be enclosed within an `<apex:map>` component. You can add up to 100 `<apex:mapMarker>` components to a single map.

Map of Contacts for an Account:

```html
<apex:page standardController="Account">
<!-- This page must be accessed with an Account Id in the URL. For example:
https://MyDomainName--c.vf.force.com/apex/NearbyContacts?id=001D000000JRBet -->
<apex:pageBlock >
<apex:pageBlockSection title="Contacts For {! Account.Name }">
<apex:dataList value="{! Account.Contacts }" var="contact">
<apex:outputText value="{! contact.Name }" />
</apex:dataList>
</apex:pageBlockSection>
</apex:pageBlock>
<apex:map width="600px" height="400px" mapType="roadmap"
center="{!Account.BillingStreet},{!Account.BillingCity},{!Account.BillingState}">
<apex:repeat value="{! Account.Contacts }" var="contact">
<apex:mapMarker title="{! contact.Name }"
position="{!contact.MailingStreet},{!contact.MailingCity},{!contact.MailingState}"
/>
</apex:repeat>
</apex:map>
</apex:page>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| icon | String | | 34.0 | | An absolute or fully qualified URL of the icon to be displayed for this marker. If you use images from a static resource, use the URLFOR() function to obtain the image URL. |
| id | String | | 32.0 | | An identifier that allows other components in the page to reference this component. |
| position | Object | Yes | 32.0 | global | Specifies the location of the marker. There are several ways to define the location: • A string representing an address. For example, "1 Market Street, San Francisco, CA". The address is automatically geocoded to determine its actual latitude and longitude. • A string representing a JSON object with latitude and longitude attributes that specify location coordinates. For example, "{latitude: 37.794, longitude: -122.395}". • An Apex map object of type Map<String, Double>, with latitude and longitude keys to specify location coordinates. Note: You can have up to 10 geocoded address lookups per map. Lookups for both the center attribute of the `<apex:map>` component and the position attribute of the `<apex:mapMarker>` component count against this limit. To display more markers, provide position values that don't require geocoding. Locations that exceed the geocoding limit are skipped. |
| rendered | Boolean | | 32.0 | | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |
| title | String | | 32.0 | | Text to display when the user's cursor moves over the marker. That is, when the marker's mouseover event is triggered. |

---

## 28. apex:mapInfoWindow

**설명:** Defines an info window for the marker displayed at a location on an `<apex:map>`. The body of the `<apex:mapInfoWindow>` component is displayed in the info window when users click or tap the marker. The body of the `<apex:mapInfoWindow>` can be Visualforce markup, HTML and CSS, or even plain text. By default only one info window displays at a time. That is, when you click another marker, the first info window disappears and the new info window appears. To display multiple info windows at once, set showOnlyActiveInfoWindow to false on the containing `<apex:map>` component.

> Note: This component must be enclosed within an `<apex:mapMarker>` component.

Map of Contacts for an Account:

```html
<apex:page standardController="Account">
<!-- This page must be accessed with an Account Id in the URL. For example:
https://MyDomainName--c.vf.force.com/apex/NearbyContacts?id=001D000000JRBet -->
<apex:pageBlock >
<apex:pageBlockSection title="Contacts For {! Account.Name }">
<apex:dataList value="{! Account.Contacts }" var="contact">
<apex:outputText value="{! contact.Name }" />
</apex:dataList>
</apex:pageBlockSection>
</apex:pageBlock>
<apex:map width="600px" height="400px" mapType="roadmap"
center="{!Account.BillingStreet},{!Account.BillingCity},{!Account.BillingState}">
<apex:repeat value="{! Account.Contacts }" var="contact">
<apex:mapMarker title="{! contact.Name }"
position="{!contact.MailingStreet},{!contact.MailingCity},{!contact.MailingState}">
<apex:mapInfoWindow>
<apex:outputPanel layout="block" style="font-weight: bold;">
<apex:outputText>{! contact.Name }</apex:outputText>
</apex:outputPanel>
<apex:outputPanel layout="block">
<apex:outputText>
{!contact.MailingStreet},{!contact.MailingCity},{!contact.MailingState}
</apex:outputText>
</apex:outputPanel>
</apex:mapInfoWindow>
</apex:mapMarker>
</apex:repeat>
</apex:map>
</apex:page>
```

| Attribute | Type | Required? | API | Access | Description |
|---|---|---|---|---|---|
| id | String | | 34.0 | | An identifier that allows other components in the page to reference this component. |
| maxWidth | Integer | | 34.0 | | Maximum width of the info window, regardless of content's width. |
| rendered | Boolean | | 34.0 | global | A Boolean value that specifies whether the component is rendered on the page. If not specified, this value defaults to true. |

---

## 관련 노트

- [[Visualforce 개요 — 도구·퀵스타트]]
- [[표준 컨트롤러·표준 리스트 컨트롤러]]
- [[페이지 출력 제어 — HTML·PDF·SLDS]]
- [[이메일·차트·맵·Flow·템플릿]]
- [[동적 Visualforce — 바인딩·동적 컴포넌트]]
- [[Visualforce 베스트 프랙티스]]
- [[apex 컴포넌트 — 페이지·레이아웃 구조]] — `apex:page`·`apex:pageBlock` 등 컨테이너 컴포넌트
- [[apex 컴포넌트 — 입력·폼]] — `apex:inputField`·`apex:form` 등 입력 컴포넌트
