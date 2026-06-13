---
tags: [lwc, base-component, table, slds, reference]
source: Salesforce Lightning Component Reference (cx-router 메타데이터, Tier 2) + lightningdesignsystem.com (SLDS 2)
created: 2026-06-13
aliases: [lightning-tree-grid, Tree Grid]
---

# lightning-tree-grid

> 트리 + 표가 결합된 계층형 데이터 그리드. · 카테고리: Table & Tree

> [!note] 속성·메서드·이벤트·슬롯 명세는 Salesforce 공식 cx-router 메타데이터(Tier 2)에서 추출했습니다. 속성 설명은 가독성을 위해 약 140자에서 줄였습니다 — 전체 문장은 공식 Specification 링크 참조.

---

## 기본 예제 (Example)

```html
<lightning-tree-grid columns={columns} data={data} key-field="id"></lightning-tree-grid>
```

> 위는 대표적인 기본 사용 예입니다. 실행 가능한 전체 예제와 모든 변형(variant)은 아래 **Example** 탭에서 직접 확인/편집할 수 있습니다.

## 개발 가이드 (Develop)

`lightning-tree-grid` 의 상세 사용법, 변형, 접근성(ARIA), 스타일링 훅 등 전체 설명은 공식 **Develop** 문서를 참고하세요. 이 컴포넌트는 SLDS 블루프린트를 구현하며, 조직 테마에 따라 SLDS 1 또는 SLDS 2 스타일로 렌더링됩니다.

## 명세 (Specification)

공식 cx-router 메타데이터에서 추출한 전체 명세입니다. (속성 설명은 약 140자에서 줄임 — 전체 문장은 아래 Specification 링크 참고)

지원 상태: **GA** · 최소 API 버전: 42.0

### 속성 (Attributes) — 21개

| 속성 (kebab) | 타입 | 필수 | 기본값 | 설명 |
|---|---|---|---|---|
| `aria-label` | string |  | '' | Public property for passing `aria-label` down to the child table element. |
| `columns` | array |  |  | Array of the columns object that's used to define the data types. Required properties include 'label', 'fieldName', and 'type'. The defaul… |
| `column-widths-mode` | string |  | fixed | Specifies how column widths are calculated. Set to 'fixed' for columns with equal widths. Set to 'auto' for column widths that are based o… |
| `data` | array |  |  | The array of data to be displayed. |
| `default-sort-direction` | string |  | asc | Specifies the default sorting direction on an unsorted column. Valid options include 'asc' and 'desc'. The default is 'asc' for sorting in… |
| `disabled-rows` | list |  |  | Enables programmatic row disabling with a list of key-field values. |
| `expanded-rows` | array |  |  | The array of unique row IDs for rows that are expanded. |
| `hide-borders` | Boolean |  | false | If present, the table borders are hidden. Only valid when hide-table-header is true. |
| `hide-checkbox-column` | boolean |  | false | If present, the checkbox column for row selection is hidden. |
| `hide-table-header` | boolean |  | false | If present, the table header is hidden. |
| `is-loading` | boolean |  | false | If present, a spinner is displayed to indicate that more data is being loaded. |
| `key-field` | string |  |  | Required for better performance. Associates each row with a unique ID. |
| `max-column-width` | number |  | 1000 | The maximum width for all columns. The default is 1000px. |
| `min-column-width` | number |  | 50 | The minimum width for all columns. The default is 50px. |
| `resize-column-disabled` | boolean |  | false | If present, column resizing is disabled. |
| `row-number-offset` | number |  | 0 | Determines where to start counting the row number. The default is 0. |
| `row-toggle-icon` | Object |  |  | Customizes the icon that toggles nested items on a row. Provide an icon for both the collapsed and expanded states, or provide different i… |
| `selected-rows` | list |  |  | Enables programmatic row selection with a list of key-field values. |
| `show-row-number-column` | boolean |  | false | If present, the row number column are shown in the first column. |
| `sorted-by` | string\|string[] |  |  | The column key or fieldName(s) that controls the sorting order. Sort the data using the onsort event handler. |
| `sorted-direction` | string\|string[] |  |  | Specifies the sorting direction. Sort the data using the onsort event handler. Valid options include a single value of 'asc' or 'desc' or … |

### 메서드 (Methods) — 4개

| 메서드 | 설명 |
|---|---|
| `collapse-all` | Collapse all rows |
| `expand-all` | Expand all rows with children content |
| `get-current-expanded-rows` | Returns an array of rows that are expanded. |
| `get-selected-rows` | Returns data in each selected row. |


## 공식 문서 링크

- ▶ **Example (실행 예제):** https://developer.salesforce.com/docs/component-library/bundle/lightning-tree-grid/example
- 📖 **Develop (개발 가이드):** https://developer.salesforce.com/docs/component-library/bundle/lightning-tree-grid/documentation
- 📋 **Specification (명세):** https://developer.salesforce.com/docs/component-library/bundle/lightning-tree-grid/specification
- 📚 가이드 페이지: https://developer.salesforce.com/docs/platform/lightning-component-reference/guide/lightning-tree-grid.html

## 관련 노트

- [[BaseComponents(베이스컴포넌트)/index|BaseComponents 색인]]
- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 카테고리 목록
- [[LWC MOC]]
