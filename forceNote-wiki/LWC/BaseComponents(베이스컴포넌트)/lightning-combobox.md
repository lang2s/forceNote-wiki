---
tags: [lwc, base-component, combobox, input, dropdown, reference]
source: TrailheadApp/lwc-recipes-main (Tier 1) + external-knowledge (Tier 3)
created: 2026-05-17
aliases: [lightning-combobox, 드롭다운, 콤보박스, select box]
---

# lightning-combobox

> 단일 항목 선택 드롭다운. 읽기 전용 텍스트 필드 + 옵션 목록 형태로 구성된다.

> [!warning] 속성 세부사항은 외부 지식(Tier 3). 코드 예시는 `lwc-recipes-main` (Tier 1).

---

## 기본 사용 *(lwc-recipes-main/miscToastNotification — Tier 1)*

```html
<template>
    <lightning-combobox
        label="Variant"
        value={variant}
        options={variantOptions}
        onchange={handleVariantChange}
    ></lightning-combobox>
</template>
```

```javascript
import { LightningElement } from 'lwc';

export default class MiscToastNotification extends LightningElement {
    variant = 'error'; // 초기 선택값

    variantOptions = [
        { label: 'error',   value: 'error' },
        { label: 'warning', value: 'warning' },
        { label: 'success', value: 'success' },
        { label: 'info',    value: 'info' }
    ];

    handleVariantChange(event) {
        this.variant = event.target.value;
    }
}
```

---

## Apex 데이터 기반 동적 옵션 로드

```javascript
import { LightningElement, wire } from 'lwc';
import getStatusOptions from '@salesforce/apex/StatusController.getOptions';

export default class DynamicCombobox extends LightningElement {
    selectedValue = '';
    options = [];

    @wire(getStatusOptions)
    wiredOptions({ data, error }) {
        if (data) {
            // Apex에서 { label, value } 리스트 반환하는 경우
            this.options = data;
        }
    }

    handleChange(event) {
        this.selectedValue = event.target.value;
    }
}
```

---

## Picklist 값을 옵션으로 사용 *(getPicklistValues 패턴과 연동)*

```javascript
import { LightningElement, wire } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';

export default class IndustryCombobox extends LightningElement {
    picklistOptions = [];

    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    objectInfo;

    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: INDUSTRY_FIELD
    })
    wiredPicklist({ data, error }) {
        if (data) {
            this.picklistOptions = data.values.map(item => ({
                label: item.label,
                value: item.value
            }));
        }
    }
}
```

→ 자세한 패턴: [[getPicklistValues 패턴]]

---

## 필터 적용 드롭다운 *(lwc-recipes-main/stateManager — Tier 1)*

```html
<lightning-combobox
    name="opportunityFilter"
    label="Opportunity Filter"
    options={filters}
    value={filter}
    onchange={handleFilterChange}
></lightning-combobox>
```

```javascript
filters = [
    { label: 'All Opportunities',              value: 'ALL' },
    { label: 'Open Opportunities',             value: 'OPEN' },
    { label: 'Closed Opportunities',           value: 'CLOSED' },
    { label: 'Large Opportunities (> $100k)',  value: 'LARGE' }
];

handleFilterChange(event) {
    this.filter = event.target.value; // 선택된 value
}
```

---

## 전체 속성 레퍼런스

| 속성 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `label` | string | — | 필드 레이블 (필수) |
| `value` | string | — | 현재 선택값 (`options[].value`와 일치해야 함) |
| `options` | object[] | `[]` | 옵션 배열 `[{ label, value }]` |
| `placeholder` | string | `'Select an Option'` | 미선택 시 안내 텍스트 |
| `required` | boolean | `false` | 필수 여부 |
| `disabled` | boolean | `false` | 비활성화 |
| `read-only` | boolean | `false` | 읽기 전용 |
| `variant` | string | `standard` | `standard` / `label-hidden` / `label-inline` / `label-stacked` |
| `field-level-help` | string | — | 물음표 아이콘 도움말 |
| `dropdown-alignment` | string | `left` | `left` / `center` / `right` / `bottom-left` / `bottom-center` / `bottom-right` |
| `spinner-active` | boolean | `false` | 드롭다운에 로딩 스피너 표시 |
| `message-when-value-missing` | string | — | required 미충족 시 에러 메시지 |

**`options` 배열 항목 구조:**

```javascript
// 기본
{ label: '표시 텍스트', value: '전달 값' }

// 비활성 옵션
{ label: '이 항목 선택 불가', value: 'disabled_item', disabled: true }
```

---

## 이벤트

| 이벤트 | 설명 | 값 읽기 |
|---|---|---|
| `change` | 선택이 변경될 때 | `event.target.value` 또는 `event.detail.value` |
| `focus` | 포커스 획득 | — |
| `blur` | 포커스 이탈 | — |
| `open` | 드롭다운이 열릴 때 | — |
| `close` | 드롭다운이 닫힐 때 | — |

---

## `lightning-select` vs `lightning-combobox` 비교

| | `lightning-combobox` | `lightning-select` |
|---|---|---|
| 렌더링 | SLDS 커스텀 드롭다운 | HTML `<select>` 기반 |
| 모바일 | 커스텀 UI (일관성) | 모바일 네이티브 선택기 |
| 검색/필터 | 없음 | 없음 |
| 다중 선택 | 불가 | 불가 |
| SLDS 스타일 | 완전 지원 | 제한적 |
| 권장 | Lightning Experience | 모바일 우선 환경 |

다중 선택이 필요한 경우 → `lightning-dual-listbox` 사용

---

## 유효성 검사

```javascript
// reportValidity() 호출 시 선택 안 된 required 필드에 에러 표시
handleSave() {
    const combobox = this.template.querySelector('lightning-combobox');
    if (!combobox.checkValidity()) {
        combobox.reportValidity();
        return;
    }
}
```

---

## 관련 노트

- [[Lightning Base Components 레퍼런스]] — 전체 입력 컴포넌트 목록
- [[lightning-input]] — 텍스트·숫자 입력
- [[getPicklistValues 패턴]] — Picklist 옵션을 동적으로 로드해 combobox에 바인딩
- [[lightning-record-picker]] — 레코드 검색 선택 위젯 (검색 기능 있음)
