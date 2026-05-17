---
tags: [lwc, base-component, record-picker, search, reference]
source: TrailheadApp/lwc-recipes-main (Tier 1) + external-knowledge (Tier 3)
created: 2026-05-17
aliases: [lightning-record-picker, 레코드 검색, 레코드 선택, record picker]
---

# lightning-record-picker

> 레코드를 검색하고 선택하는 위젯. Spring '24 GA. 검색 입력 + 자동완성 드롭다운 형태.

> [!warning] 속성 세부사항 일부는 외부 지식(Tier 3). 코드 예시는 `lwc-recipes-main` (Tier 1).

---

## 기본 사용 *(lwc-recipes-main/recordPickerHello — Tier 1)*

```html
<template>
    <lightning-card title="RecordPickerHello" icon-name="standard:search">
        <div>
            <lightning-record-picker
                lwc:ref="recordPicker"
                object-api-name="Contact"
                placeholder="Search..."
                label="Select a record"
                onchange={handleChange}
            ></lightning-record-picker>
        </div>

        <template lwc:if={contact}>
            <!-- 선택된 레코드 상세 표시 -->
            <c-contact-tile contact={contact}></c-contact-tile>
        </template>
    </lightning-card>
</template>
```

```javascript
import { wire, LightningElement } from 'lwc';
import { gql, graphql } from 'lightning/graphql';

export default class RecordPickerHello extends LightningElement {
    selectedRecordId = '';
    contact;

    handleChange(event) {
        // change 이벤트에서 선택된 레코드 ID를 받음
        this.selectedRecordId = event.detail.recordId;
    }

    get variables() {
        return { selectedRecordId: this.selectedRecordId };
    }

    // 선택 후 GraphQL로 상세 정보 로드 (권장 패턴)
    @wire(graphql, {
        query: gql`
            query searchContacts($selectedRecordId: ID) {
                uiapi {
                    query {
                        Contact(where: { Id: { eq: $selectedRecordId } }, first: 1) {
                            edges {
                                node {
                                    Id
                                    Name     { value }
                                    Phone    { value displayValue }
                                    Title    { value }
                                }
                            }
                        }
                    }
                }
            }
        `,
        variables: '$variables'
    })
    wiredGraphQL({ data, errors }) {
        if (errors || !data) return;
        const edges = data.uiapi.query.Contact.edges;
        this.contact = edges.map(edge => ({
            Id:    edge.node.Id,
            Name:  edge.node.Name.value,
            Phone: edge.node.Phone.value,
            Title: edge.node.Title.value
        }))[0];
    }
}
```

---

## 다중 선택 패턴 *(lwc-recipes-main/recordPickerMultiValue — Tier 1)*

`lightning-record-picker`는 단일 선택만 지원하지만, `lightning-pill-container`와 `filter`를 조합해 다중 선택처럼 구현할 수 있다.

```html
<template>
    <lightning-record-picker
        lwc:ref="recordPicker"
        label="Contacts"
        placeholder="Search Contacts..."
        object-api-name="Contact"
        filter={recordPickerFilter}
        onchange={handleRecordPickerChange}
    ></lightning-record-picker>

    <!-- 선택된 항목을 Pill로 표시 -->
    <lightning-pill-container
        items={pillItems}
        onitemremove={handlePillRemove}
    ></lightning-pill-container>
</template>
```

```javascript
import { LightningElement, wire } from 'lwc';
import { gql, graphql } from 'lightning/graphql';

// 레코드 → Pill 항목 변환
const toContactPill = (record) => ({
    name:     record.id,
    label:    record.name,
    iconName: 'standard:contact',
    type:     'icon'
});

// 선택된 ID 목록 → filter 객체 변환 (이미 선택된 항목 제외)
const toRecordPickerFilter = (ids) => ({
    criteria: [{
        fieldPath: 'Id',
        operator:  'nin', // "not in" 연산자
        value:      ids
    }]
});

export default class RecordPickerMultiValue extends LightningElement {
    selectedRecordId;
    selectedRecords = [];

    // Pill 목록 생성
    get pillItems() {
        return this.selectedRecords.map(toContactPill);
    }

    // 이미 선택된 레코드를 검색 결과에서 제외
    get recordPickerFilter() {
        const ids = this.selectedRecords.map(r => r.id);
        return toRecordPickerFilter(ids);
    }

    get variables() {
        return this.selectedRecordId ? { selectedRecordId: this.selectedRecordId } : undefined;
    }

    @wire(graphql, {
        query: gql`
            query searchContacts($selectedRecordId: ID) {
                uiapi {
                    query {
                        Contact(where: { Id: { eq: $selectedRecordId } }, first: 1) {
                            edges { node { Id Name { value } } }
                        }
                    }
                }
            }
        `,
        variables: '$variables'
    })
    wiredGraphQL({ data, errors }) {
        if (this.variables === undefined || errors || !data) return;

        const record = data.uiapi.query.Contact.edges.map(edge => ({
            id:   edge.node.Id,
            name: edge.node.Name.value
        }))[0];

        this.selectedRecords = [...this.selectedRecords, record];
        this._clearRecordPickerSelection(); // 선택 후 picker 초기화
    }

    _clearRecordPickerSelection() {
        this.refs.recordPicker.clearSelection(); // clearSelection() 메서드로 입력 초기화
        this.selectedRecordId = undefined;
    }

    handlePillRemove(event) {
        const recordId = event.detail.item.name;
        this.selectedRecords = this.selectedRecords.filter(r => r.id !== recordId);
    }

    handleRecordPickerChange(event) {
        this.selectedRecordId = event.detail.recordId;
    }
}
```

---

## filter 속성으로 검색 범위 제한

```javascript
// 특정 조건의 레코드만 검색 결과에 표시
recordPickerFilter = {
    criteria: [
        {
            fieldPath: 'AccountId',
            operator:  'eq',
            value:     '001000000000001' // 특정 Account에 속한 Contact만
        },
        {
            fieldPath: 'IsActive__c',
            operator:  'eq',
            value:     true
        }
    ]
};

// 논리 연산자 (AND가 기본)
recordPickerFilter = {
    criteria: [ ... ],
    filterLogic: '1 AND 2' // 또는 '1 OR 2'
};
```

**지원 operator:**

| operator | 설명 |
|---|---|
| `eq` | 같음 |
| `ne` | 다름 |
| `in` | 목록 안에 있음 |
| `nin` | 목록 안에 없음 |
| `like` | 패턴 일치 |
| `gt` / `gte` | 크다 / 크거나 같다 |
| `lt` / `lte` | 작다 / 작거나 같다 |

---

## 동적 오브젝트 전환 패턴 *(lwc-recipes-main/recordPickerDynamicTarget — Tier 1)*

콤보박스로 오브젝트 타입을 먼저 선택한 뒤, 해당 타입의 레코드를 검색하는 패턴. `displayInfo`와 `matchingInfo`로 표시·검색 필드를 커스텀한다.

```html
<lightning-combobox
    label="Select a target sObject"
    variant="label-hidden"
    options={targetObjects}
    value={selectedTarget}
    onchange={handleTargetSelection}
></lightning-combobox>

<lightning-record-picker
    lwc:ref="recordPicker"
    object-api-name={selectedTarget}
    placeholder="Search..."
    label="Select a record"
    variant="label-hidden"
    display-info={displayInfo}
    matching-info={matchingInfo}
    onchange={handleRecordSelect}
></lightning-record-picker>
```

```javascript
export default class RecordPickerDynamicTarget extends LightningElement {
    targetObjects = [
        { label: 'Account', value: 'Account' },
        { label: 'Contact', value: 'Contact' }
    ];
    selectedTarget = 'Account';
    currentSelectedRecordId = null;

    // 오브젝트별 표시 필드 (선택 후 Pill에 보이는 추가 필드)
    displayInfos = {
        Account: { additionalFields: ['Type'] },
        Contact: { additionalFields: ['Phone'] }
    };

    // 오브젝트별 검색 매칭 필드 (검색 결과 목록에 표시)
    matchingInfos = {
        Account: { additionalFields: [{ fieldPath: 'Type' }] },
        Contact: { additionalFields: [{ fieldPath: 'Phone' }] }
    };

    get displayInfo()  { return this.displayInfos[this.selectedTarget];  }
    get matchingInfo() { return this.matchingInfos[this.selectedTarget]; }

    handleTargetSelection(event) {
        event.stopPropagation(); // combobox change 이벤트 버블링 방지
        this.selectedTarget = event.target.value;
        this.refs.recordPicker.clearSelection(); // 오브젝트 변경 시 선택 초기화
    }

    handleRecordSelect(event) {
        this.currentSelectedRecordId = event.detail.recordId;
    }
}
```

**`displayInfo` vs `matchingInfo`:**

| 속성 | 역할 | 예시 |
|---|---|---|
| `displayInfo` | 선택 후 Pill에 표시할 추가 필드 | Type, Phone 등 |
| `matchingInfo` | 검색 결과 드롭다운에 표시할 필드 | 검색어와 매칭될 추가 필드 |

---

## clearSelection() 메서드

선택을 프로그래밍 방식으로 초기화한다. `lwc:ref`로 참조를 얻어 호출한다.

```javascript
// clearSelection() — 선택 초기화
clearPicker() {
    this.refs.recordPicker.clearSelection();
}
```

---

## 전체 속성 레퍼런스

| 속성 | 타입 | 설명 |
|---|---|---|
| `object-api-name` | string | 검색할 오브젝트 API 이름 (필수) |
| `label` | string | 필드 레이블 |
| `placeholder` | string | 검색 입력 안내 텍스트 |
| `filter` | object | 검색 결과 필터 조건 (`{ criteria: [] }`) |
| `matching-info` | object | 검색 결과에 표시할 필드 커스텀 |
| `display-info` | object | 선택 후 Pill에 표시할 필드 커스텀 |
| `disabled` | boolean | 비활성화 |
| `required` | boolean | 필수 여부 |
| `variant` | string | `standard` / `label-hidden` / `label-inline` / `label-stacked` |

---

## 이벤트

| 이벤트 | 설명 | detail |
|---|---|---|
| `change` | 레코드 선택 변경 | `event.detail.recordId` (선택 시) / `null` (해제 시) |

---

## 사용 고려사항

- `lightning-record-picker`는 **단일 선택**만 지원 — 다중 선택은 `lightning-pill-container` + `filter` 조합으로 구현
- 선택 후 레코드 필드 읽기에는 **GraphQL** 사용 권장 (`getRecord`도 가능하나 GraphQL이 더 유연)
- `clearSelection()` 호출 후에도 `change` 이벤트는 발생하지 않음
- `filter`가 변경되면 현재 검색 결과가 자동으로 갱신됨
- Spring '24 GA — 이전 버전(v59 이하)에서는 사용 불가

---

## 관련 노트

- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 목록
- [[lightning-combobox]] — Picklist 값 기반 단일 선택 (ID 검색 불필요 시)
- [[Record Form 선택]] — 레코드 폼 패턴 선택 기준
- [[Wire 패턴]] — GraphQL @wire와 연동 패턴
