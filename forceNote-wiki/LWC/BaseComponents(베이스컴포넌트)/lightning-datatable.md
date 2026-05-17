---
tags: [lwc, base-component, datatable, table, reference]
source: TrailheadApp/lwc-recipes-main (Tier 1) + external-knowledge (Tier 3)
created: 2026-05-17
aliases: [lightning-datatable, 데이터 테이블, datatable, 인라인 편집]
---

# lightning-datatable

> 정렬·행 선택·인라인 편집·무한 스크롤·커스텀 셀 타입을 지원하는 데이터 테이블.

> [!warning] columns type 전체 목록 및 일부 속성은 외부 지식(Tier 3). 코드 예시는 `lwc-recipes-main` (Tier 1).

---

## 기본 구조

```html
<lightning-datatable
    key-field="Id"
    data={tableData}
    columns={columns}
></lightning-datatable>
```

```javascript
import { LightningElement } from 'lwc';

const COLUMNS = [
    { label: 'Name',  fieldName: 'Name' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Email', fieldName: 'Email', type: 'email' }
];

export default class BasicDatatable extends LightningElement {
    columns = COLUMNS;
    tableData = []; // Apex @wire 또는 imperative call로 채움
}
```

---

## 인라인 편집 + Apex 저장 *(lwc-recipes-main/datatableInlineEditWithApex — Tier 1)*

```html
<template>
    <lightning-card title="Datatable Inline Edit With Apex" icon-name="custom:custom62">
        <div class="slds-var-m-around_medium">
            <template lwc:if={contacts.data}>
                <lightning-datatable
                    key-field="Id"
                    data={contacts.data}
                    columns={columns}
                    onsave={handleSave}
                    draft-values={draftValues}
                    hide-checkbox-column
                ></lightning-datatable>
            </template>
            <template lwc:elseif={contacts.error}>
                <c-error-panel errors={contacts.error}></c-error-panel>
            </template>
        </div>
    </lightning-card>
</template>
```

```javascript
import { LightningElement, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContactList';
import updateContacts from '@salesforce/apex/ContactController.updateContacts';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLS = [
    { label: 'First Name', fieldName: 'FirstName', editable: true },
    { label: 'Last Name',  fieldName: 'LastName',  editable: true },
    { label: 'Title',      fieldName: 'Title',     editable: true },
    { label: 'Phone',      fieldName: 'Phone',     type: 'phone', editable: true },
    { label: 'Email',      fieldName: 'Email',     type: 'email', editable: true }
];

export default class DatatableInlineEditWithApex extends LightningElement {
    columns = COLS;
    draftValues = [];

    @wire(getContacts)
    contacts;

    async handleSave(event) {
        const updatedFields = event.detail.draftValues;
        this.draftValues = []; // 드래프트 초기화

        try {
            await updateContacts({ contactsForUpdate: updatedFields });
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success', message: 'Contacts updated', variant: 'success'
            }));
            await refreshApex(this.contacts); // 테이블 갱신
        } catch (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error', message: error.body.message, variant: 'error'
            }));
        }
    }
}
```

---

## 커스텀 데이터 타입 *(lwc-recipes-main/customDataTypes + datatableCustomDataType — Tier 1)*

```javascript
// customDataTypes.js — LightningDatatable 상속으로 커스텀 타입 등록
import LightningDatatable from 'lightning/datatable';
import customPicture from './customPicture.html'; // 셀 템플릿

export default class CustomDataTypes extends LightningDatatable {
    static customTypes = {
        customPictureType: {
            template: customPicture,
            standardCellLayout: true,
            typeAttributes: ['pictureUrl'] // 셀 템플릿에서 사용할 속성 이름
        }
    };
}
```

```javascript
// 사용하는 컴포넌트 — columns에 커스텀 타입 지정
const COLS = [
    { label: 'First Name', fieldName: 'FirstName' },
    { label: 'Last Name',  fieldName: 'LastName' },
    {
        label: 'Contact Picture',
        type: 'customPictureType',
        typeAttributes: {
            pictureUrl: { fieldName: 'Picture__c' }
        },
        cellAttributes: { alignment: 'center' }
    }
];
```

```html
<!-- 사용 시 c-custom-data-types 태그로 교체 -->
<c-custom-data-types
    key-field="Id"
    data={contacts.data}
    columns={columns}
    hide-checkbox-column="true"
></c-custom-data-types>
```

---

## 행 액션 (Row Actions)

```javascript
const ACTIONS = [
    { label: '상세 보기', name: 'view' },
    { label: '수정',      name: 'edit' },
    { label: '삭제',      name: 'delete' }
];

const COLS = [
    { label: 'Name', fieldName: 'Name' },
    { type: 'action', typeAttributes: { rowActions: ACTIONS } }
];
```

```html
<lightning-datatable
    key-field="Id"
    data={tableData}
    columns={columns}
    onrowaction={handleRowAction}
></lightning-datatable>
```

```javascript
handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row        = event.detail.row;

    switch (actionName) {
        case 'view':   this.handleView(row); break;
        case 'edit':   this.handleEdit(row); break;
        case 'delete': this.handleDelete(row); break;
    }
}
```

---

## 행 선택 (Row Selection)

```html
<lightning-datatable
    key-field="Id"
    data={tableData}
    columns={columns}
    max-row-selection="3"
    selected-rows={selectedRowIds}
    onrowselection={handleRowSelection}
></lightning-datatable>
```

```javascript
handleRowSelection(event) {
    const selectedRows = event.detail.selectedRows;
    this.selectedRowIds = selectedRows.map(row => row.Id);
}
```

---

## 정렬 (Sorting)

```javascript
const COLS = [
    { label: 'Name',  fieldName: 'Name',  sortable: true },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' }
];
```

```html
<lightning-datatable
    key-field="Id"
    data={tableData}
    columns={columns}
    sorted-by={sortedBy}
    sorted-direction={sortedDirection}
    onsort={handleSort}
></lightning-datatable>
```

```javascript
handleSort(event) {
    const { fieldName, sortDirection } = event.detail;
    this.sortedBy        = fieldName;
    this.sortedDirection = sortDirection;

    // 클라이언트 측 정렬 예시
    const data = [...this.tableData];
    data.sort((a, b) => {
        const val = sortDirection === 'asc' ? 1 : -1;
        return a[fieldName] > b[fieldName] ? val : -val;
    });
    this.tableData = data;
}
```

---

## columns 주요 속성

```javascript
{
    label: '컬럼 헤더',        // 표시 텍스트
    fieldName: 'ApiName',    // data 객체의 키
    type: 'text',            // 아래 타입 참조
    sortable: true,          // 정렬 가능 여부
    editable: true,          // 인라인 편집 가능 여부
    cellAttributes: {
        alignment: 'left'    // left | center | right
    },
    typeAttributes: { ... }, // type별 추가 설정
    initialWidth: 200,       // 초기 컬럼 너비(px)
    wrapText: true,          // 텍스트 줄바꿈
    hideDefaultActions: true // 컬럼 헤더 기본 메뉴 숨김
}
```

---

## columns type 목록

| type | 설명 | typeAttributes |
|---|---|---|
| `text` | 일반 텍스트 (기본값) | — |
| `number` | 숫자 | `minimumFractionDigits`, `maximumFractionDigits` |
| `currency` | 통화 | `currencyCode`, `minimumFractionDigits` |
| `percent` | 퍼센트 (0.5 → 50%) | `minimumFractionDigits` |
| `date` | 날짜 (로케일 포맷) | `year`, `month`, `day`, `hour`, `minute` |
| `date-local` | 타임존 없는 날짜 | `year`, `month`, `day` |
| `boolean` | 체크박스 (읽기 전용) | — |
| `url` | 링크 | `label: { fieldName: '...' }`, `target: '_blank'` |
| `email` | 이메일 링크 | — |
| `phone` | 전화번호 링크 | — |
| `button` | 인라인 버튼 | `label`, `variant`, `iconName`, `iconPosition`, `disabled` |
| `button-icon` | 인라인 아이콘 버튼 | `iconName`, `variant`, `iconClass`, `disabled` |
| `action` | 행 드롭다운 액션 | `rowActions: [{ label, name }]` |
| `custom` | 커스텀 셀 렌더러 | — (LightningDatatable 상속으로 등록) |

---

## 전체 컴포넌트 속성

| 속성 | 타입 | 설명 |
|---|---|---|
| `key-field` | string | 고유 식별자 필드명 (필수) |
| `data` | object[] | 행 데이터 배열 |
| `columns` | object[] | 컬럼 정의 배열 |
| `draft-values` | object[] | 인라인 편집 임시값 |
| `selected-rows` | string[] | 선택된 행의 key-field 값 배열 |
| `max-row-selection` | number | 최대 선택 가능 행 수 |
| `hide-checkbox-column` | boolean | 선택 체크박스 열 숨김 |
| `sorted-by` | string | 정렬 기준 fieldName |
| `sorted-direction` | string | `asc` / `desc` |
| `default-sort-direction` | string | 기본 정렬 방향 |
| `enable-infinite-loading` | boolean | 무한 스크롤 활성화 |
| `load-more-offset` | number | 무한 스크롤 트리거 행 수 (기본: 20) |
| `is-loading` | boolean | 테이블 하단 로딩 스피너 표시 |
| `resize-column-disabled` | boolean | 컬럼 너비 조정 비활성화 |
| `min-column-width` | number | 최소 컬럼 너비(px) (기본: 50) |
| `max-column-width` | number | 최대 컬럼 너비(px) (기본: 1000) |
| `column-widths-mode` | string | `fixed` / `auto` |
| `show-row-number-column` | boolean | 행 번호 열 표시 |
| `suppress-bottom-bar` | boolean | 인라인 편집 하단 저장/취소 바 숨김 |
| `errors` | object | 행·셀 수준 유효성 에러 객체 |

---

## 이벤트

| 이벤트 | 설명 | 주요 detail |
|---|---|---|
| `rowselection` | 행 선택 변경 | `event.detail.selectedRows` |
| `sort` | 컬럼 정렬 클릭 | `event.detail.fieldName`, `event.detail.sortDirection` |
| `save` | 인라인 편집 저장 | `event.detail.draftValues` |
| `cancel` | 인라인 편집 취소 | — |
| `rowaction` | 행 액션 선택 | `event.detail.action.name`, `event.detail.row` |
| `loadmore` | 무한 스크롤 하단 도달 | — |
| `resize` | 컬럼 너비 변경 | `event.detail.columnWidths` |
| `headeraction` | 컬럼 헤더 액션 | `event.detail.action.name`, `event.detail.columnDefinition` |
| `cellfocuschange` | 셀 포커스 변경 | `event.detail.rowKeyValue`, `event.detail.colKeyValue` |

---

## 인라인 편집 + UI API 저장 *(lwc-recipes-main/datatableInlineEditWithUiApi — Tier 1)*

Apex 대신 `updateRecord` (UI API)를 사용하면 여러 레코드를 병렬로 저장할 수 있다.

```javascript
import { updateRecord } from 'lightning/uiRecordApi';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD  from '@salesforce/schema/Contact.LastName';
import PHONE_FIELD     from '@salesforce/schema/Contact.Phone';

const COLS = [
    { label: 'First Name', fieldName: FIRSTNAME_FIELD.fieldApiName, editable: true },
    { label: 'Last Name',  fieldName: LASTNAME_FIELD.fieldApiName,  editable: true },
    { label: 'Phone',      fieldName: PHONE_FIELD.fieldApiName,     type: 'phone', editable: true }
];

async handleSave(event) {
    // draftValues → { fields: { Id, ... } } 형태로 변환
    const records = event.detail.draftValues.map(draft => ({
        fields: Object.assign({}, draft)
    }));
    this.draftValues = [];

    try {
        // 여러 레코드를 병렬 저장 (Promise.all)
        await Promise.all(records.map(record => updateRecord(record)));
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success', message: 'Contacts updated', variant: 'success'
        }));
        await refreshApex(this.contacts);
    } catch (error) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error', message: error.body.message, variant: 'error'
        }));
    }
}
```

**Apex vs UI API 인라인 편집 비교:**

| | Apex 저장 | UI API 저장 (`updateRecord`) |
|---|---|---|
| 병렬 저장 | 수동 구현 필요 | `Promise.all` 자동 |
| FLS 적용 | Apex 내 직접 제어 | 자동 적용 |
| 유효성 검사 | Apex에서 직접 구현 | UI API 자동 |
| 커스텀 로직 | 가능 | 불가 (표준 저장만) |

---

## 사용 고려사항

- `key-field`는 데이터 각 행에 반드시 존재해야 하며 고유해야 한다
- 인라인 편집 후 `draftValues = []` 초기화하지 않으면 저장 후에도 드래프트 표시가 남음
- `refreshApex` 호출 시 `@wire` 캐시가 갱신되므로 저장 후 항상 호출 권장
- 커스텀 타입: `LightningDatatable`를 상속한 래퍼 컴포넌트를 만들어 `static customTypes`에 등록

---

## 관련 노트

- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 목록
- [[Wire 패턴]] — `@wire`로 데이터 로드해 datatable에 바인딩
- [[uiRecordApi]] — 인라인 편집 저장에 `updateRecord` 활용 가능
- [[Toast & 모달 패턴]] — 저장 성공/실패 토스트 알림
