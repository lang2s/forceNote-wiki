# Datatable

`lightning-datatable`  ·  카테고리: **Table & Tree**

정렬·인라인편집·선택이 되는 데이터 표.

## 기본 예제 (Example)

```html
<lightning-datatable key-field="id" data={data} columns={columns} onrowselection={handleSelect}></lightning-datatable>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-datatable` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 41.0

### 속성 (Attributes) — 35개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `aria-label` |  |  |  | Public property for passing `aria-label` down to the child table element. |
| `aria-labelled-by` |  |  |  | Public property for passing `aria-labelledby` down to the child table element. |
| `columns` | Array |  |  | Array of the columns object that's used to define the data types. Required properties include 'label', 'fieldName', and 'type'. The defaul… |
| `column-widths-mode` | String |  | fixed | Specifies how column widths are calculated. Set to 'fixed' for columns with equal widths. Set to 'auto' for column widths that are based o… |
| `data` | Array |  |  | The array of data to be displayed. |
| `default-sort-direction` | String |  | asc | Specifies the default sorting direction on an unsorted column. Valid options include 'asc' and 'desc'. The default is 'asc' for sorting in… |
| `disabled-rows` | list |  |  | Enables programmatic row disabling with a list of key-field values. |
| `draft-values` | Object |  |  | The current values per row that are provided during inline edit. |
| `enable-infinite-loading` | Boolean |  | false | If present, you can load a subset of data and then display more when users scroll to the end of the table. Use with the onloadmore event h… |
| `errors` | Object |  |  | Specifies an object containing information about cell level, row level, and table level errors. When it's set, error messages are displaye… |
| `hide-borders` | Boolean |  | false | If present, the table borders are hidden. Only valid when hide-table-header is true. |
| `hide-checkbox-column` | Boolean |  | false | If present, the checkbox or radio button column for row selection is hidden. |
| `hide-table-header` | Boolean |  | false | If present, the table header is hidden. |
| `is-loading` | Boolean |  | false | If present, a spinner is shown to indicate that more data is loading. |
| `key-field` | String | ✔ |  | Required for better performance. Associates each row with a unique ID. key-field is case sensitive and must match the value you provide in… |
| `load-more-offset` | Number |  | 20 | Determines when to trigger infinite loading based on how many pixels the table's scroll position is from the bottom of the table. The defa… |
| `max-column-width` | Number |  | 1000px | The maximum width for all columns. The default is 1000px. |
| `max-edit-limit` |  |  |  | Reserved for internal use. |
| `max-row-selection` | Number |  |  | The maximum number of rows that can be selected. Value should be a positive integer Checkboxes are used for selection by default, and radi… |
| `min-column-width` | Number |  | 50px | The minimum width for all columns. The default is 50px. |
| `render-config` |  |  |  | Reserved for internal use. |
| `render-mode` |  |  |  | The `role-based` option renders <div> and is reserved for internal use. / /** Opts-in to a more performant 'inline' table. Valid options a… |
| `resize-column-disabled` | Boolean |  | false | If present, column resizing is disabled. |
| `resize-step` | Number |  | 10px | The width to resize the column when a user presses left or right arrow. The default is 10px. |
| `row-number-offset` | Number |  | 0 | Determines where to start counting the row number. The default is 0. |
| `row-toggle-icon` | Object |  |  | Reserved for internal use. |
| `selected-rows` | list |  |  | Enables programmatic row selection with a list of key-field values. |
| `show-actions-menu` | Boolean |  | false | If present, the actions menu is displayed to enable users to do advanced sorting. |
| `show-row-number-column` | Boolean |  | false | If present, the row numbers are shown in the first column. |
| `single-row-selection-mode` | String |  |  | Specifies whether to render checkboxes instead of radio buttons. Use with max-row-selection. When max-row-selection is 1, radio buttons ar… |
| `sorted-by` | String\|String[] |  |  | The column key or fieldName(s) that controls the sorting order. Sort the data using the onsort event handler. |
| `sorted-direction` | String\|String[] |  |  | Specifies the sorting direction. Sort the data using the onsort event handler. Valid options include a single value of 'asc' or 'desc' or … |
| `suppress-bottom-bar` | Boolean |  | false | If present, the footer that displays the Save and Cancel buttons is hidden during inline editing. |
| `wrap-table-header` | String |  | none | Specifies how the table header is wrapped. Set to 'all' to wrap all column headers. Set to 'none' to clip all column headers. Set to 'by-c… |
| `wrap-text-max-lines` | Integer |  |  | This value specifies the number of lines after which the content will be cut off and hidden. It must be at least 1 or more. The text in th… |

### 메서드 (Methods) — 4개

| 메서드 | 설명 |
|---|---|
| `focus` | Focuses the current active cell in the datatable. |
| `get-selected-rows` | Returns data in each selected row. |
| `open-inline-edit` | Opens the inline edit panel for the datatable's currently active cell. If the active cell is not editable, then the panel is instead opene… |
| `scroll-to-top` | Scrolls to the top of the datatable. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-datatable/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-datatable/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-datatable/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-datatable.html

---
[← 전체 목록으로 돌아가기](../components.html)
