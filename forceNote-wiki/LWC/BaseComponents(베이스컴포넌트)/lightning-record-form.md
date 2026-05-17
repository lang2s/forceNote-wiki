---
tags: [lwc, base-component, record-form, lds, reference]
source: TrailheadApp/lwc-recipes-main (Tier 1) + external-knowledge (Tier 3)
created: 2026-05-17
aliases: [lightning-record-form, lightning-record-edit-form, lightning-record-view-form, 레코드 폼]
---

# lightning-record-form / record-edit-form / record-view-form

> 레코드 생성·조회·수정을 위한 세 가지 폼 컴포넌트. 복잡도에 따라 선택한다.

> [!warning] 속성 세부사항 일부는 외부 지식(Tier 3). 코드 예시는 `lwc-recipes-main` (Tier 1).

---

## 세 가지 폼 비교

| 컴포넌트 | 복잡도 | 레이아웃 제어 | 이벤트 핸들링 | 사용 시나리오 |
|---|---|---|---|---|
| `lightning-record-form` | 낮음 | 자동 (페이지 레이아웃) | 최소 | 빠른 프로토타입, 표준 폼 |
| `lightning-record-edit-form` | 중간 | 수동 (필드 배치 직접) | load, submit, success, error | 커스텀 레이아웃, 버튼 제어 |
| `lightning-record-view-form` | 낮음 | 수동 | 없음 | 읽기 전용 커스텀 레이아웃 |

→ 선택 기준 상세: [[Record Form 선택]]

---

## lightning-record-form *(lwc-recipes-main/recordFormStaticContact — Tier 1)*

가장 간단한 방법. 필드 목록만 제공하면 자동으로 폼을 구성한다.

```html
<!-- recordFormStaticContact.html -->
<template>
    <lightning-card title="RecordFormStaticContact" icon-name="standard:contact">
        <div class="slds-var-m-around_medium">
            <lightning-record-form
                object-api-name={objectApiName}
                record-id={recordId}
                fields={fields}
            ></lightning-record-form>
        </div>
    </lightning-card>
</template>
```

```javascript
import { LightningElement, api } from 'lwc';
import NAME_FIELD   from '@salesforce/schema/Contact.Name';
import PHONE_FIELD  from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD  from '@salesforce/schema/Contact.Email';
import TITLE_FIELD  from '@salesforce/schema/Contact.Title';

export default class RecordFormStaticContact extends LightningElement {
    @api recordId;
    @api objectApiName;

    fields = [NAME_FIELD, PHONE_FIELD, EMAIL_FIELD, TITLE_FIELD];
}
```

### lightning-record-form 주요 속성

| 속성 | 타입 | 설명 |
|---|---|---|
| `object-api-name` | string | 오브젝트 API 이름 (필수) |
| `record-id` | string | 레코드 ID (미제공 시 생성 모드) |
| `fields` | string[] | 표시할 필드 API 이름 배열 |
| `mode` | string | `view`(기본) / `edit` / `readonly` |
| `layout-type` | string | `Full` / `Compact` (페이지 레이아웃 사용 시) |
| `record-type-id` | string | 레코드 타입 ID |
| `columns` | number | 컬럼 수 |
| `density` | string | `auto` / `comfy` / `compact` |

### lightning-record-form 이벤트

| 이벤트 | 설명 |
|---|---|
| `load` | 레코드 로드 완료 |
| `submit` | 폼 제출 시 (기본 동작 막기 가능) |
| `success` | 저장 성공 |
| `error` | 저장 실패 |
| `cancel` | 취소 클릭 (edit 모드) |

---

## lightning-record-edit-form *(lwc-recipes-main/recordEditFormStaticContact — Tier 1)*

필드 배치를 직접 제어하고 버튼을 커스텀할 수 있다. 내부에 `lightning-input-field`와 `lightning-messages`를 배치한다.

```html
<!-- recordEditFormStaticContact.html -->
<template>
    <lightning-card title="RecordEditFormStaticContact" icon-name="standard:contact">
        <div class="slds-var-m-around_medium">
            <lightning-record-edit-form
                object-api-name={objectApiName}
                record-id={recordId}
            >
                <lightning-messages></lightning-messages>
                <lightning-input-field field-name={accountField}></lightning-input-field>
                <lightning-input-field field-name={nameField}></lightning-input-field>
                <lightning-input-field field-name={titleField}></lightning-input-field>
                <lightning-input-field field-name={phoneField}></lightning-input-field>
                <lightning-input-field field-name={emailField}></lightning-input-field>
                <div class="slds-var-m-top_medium">
                    <lightning-button
                        variant="brand"
                        type="submit"
                        name="save"
                        label="Save"
                    ></lightning-button>
                </div>
            </lightning-record-edit-form>
        </div>
    </lightning-card>
</template>
```

```javascript
// recordEditFormStaticContact.js
import { LightningElement, api } from 'lwc';
import ACCOUNT_FIELD from '@salesforce/schema/Contact.AccountId';
import NAME_FIELD    from '@salesforce/schema/Contact.Name';
import TITLE_FIELD   from '@salesforce/schema/Contact.Title';
import PHONE_FIELD   from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD   from '@salesforce/schema/Contact.Email';

export default class RecordEditFormStaticContact extends LightningElement {
    accountField = ACCOUNT_FIELD;
    nameField    = NAME_FIELD;
    titleField   = TITLE_FIELD;
    phoneField   = PHONE_FIELD;
    emailField   = EMAIL_FIELD;

    @api recordId;
    @api objectApiName;
}
```

### 저장 이벤트 처리

```html
<lightning-record-edit-form
    object-api-name="Account"
    record-id={recordId}
    onsubmit={handleSubmit}
    onsuccess={handleSuccess}
    onerror={handleError}
>
    <lightning-messages></lightning-messages>
    <lightning-input-field field-name="Name"></lightning-input-field>
    <lightning-button type="submit" label="저장" variant="brand"></lightning-button>
</lightning-record-edit-form>
```

```javascript
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

handleSubmit(event) {
    // event.preventDefault()로 기본 저장 중단 후 커스텀 처리 가능
    event.preventDefault();
    const fields = event.detail.fields;
    fields.Name = fields.Name.toUpperCase(); // 값 변환
    this.template.querySelector('lightning-record-edit-form').submit(fields);
}

handleSuccess(event) {
    const recordId = event.detail.id;
    this.dispatchEvent(new ShowToastEvent({
        title: '저장 완료', message: '레코드가 저장되었습니다.', variant: 'success'
    }));
}

handleError(event) {
    console.error(event.detail);
}
```

### lightning-record-edit-form 이벤트

| 이벤트 | 설명 | detail |
|---|---|---|
| `load` | 레코드 데이터 로드 완료 | 레코드 데이터 |
| `submit` | 폼 제출 전 | `fields` 객체 |
| `success` | 저장 성공 | 저장된 레코드 정보 |
| `error` | 저장 실패 | 에러 메시지 |

---

## lightning-record-view-form *(lwc-recipes-main/recordViewFormStaticContact — Tier 1)*

읽기 전용 표시. 내부에 `lightning-output-field`를 배치한다.

```html
<!-- recordViewFormStaticContact.html -->
<template>
    <lightning-card title="RecordViewFormStaticContact" icon-name="standard:contact">
        <div class="slds-var-m-around_medium">
            <lightning-record-view-form
                object-api-name={objectApiName}
                record-id={recordId}
            >
                <lightning-output-field field-name={accountField}></lightning-output-field>
                <lightning-output-field field-name={nameField}></lightning-output-field>
                <lightning-output-field field-name={titleField}></lightning-output-field>
                <lightning-output-field field-name={phoneField}></lightning-output-field>
                <lightning-output-field field-name={emailField}></lightning-output-field>
            </lightning-record-view-form>
        </div>
    </lightning-card>
</template>
```

---

## 동적 오브젝트·레코드 타입 — Dynamic Schema

Record ID를 URL 파라미터로 받거나, 오브젝트 API 이름을 런타임에 결정하는 경우:

```javascript
import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

export default class RecordFormDynamic extends LightningElement {
    @api recordId;
    @api objectApiName;

    // getRecord로 오브젝트 타입 파악 후 fields를 동적으로 결정하는 패턴
}
```

---

## 새 레코드 생성 폼

`record-id`를 제공하지 않으면 생성 모드로 동작한다.

```html
<lightning-record-edit-form
    object-api-name="Contact"
    onsuccess={handleSuccess}
>
    <lightning-messages></lightning-messages>
    <lightning-input-field field-name="FirstName"></lightning-input-field>
    <lightning-input-field field-name="LastName"></lightning-input-field>
    <lightning-input-field field-name="Email"></lightning-input-field>
    <lightning-button type="submit" label="생성" variant="brand"></lightning-button>
</lightning-record-edit-form>
```

---

## lightning-input-field vs lightning-output-field

| | `lightning-input-field` | `lightning-output-field` |
|---|---|---|
| 사용 폼 | `record-edit-form` | `record-view-form` |
| 편집 가능 | 예 | 아니오 |
| 속성 | `field-name`, `disabled`, `readonly`, `value` | `field-name` |
| 자동 포맷 | 예 (Picklist, Lookup 등 자동) | 예 |

---

## 관련 노트

- [[Record Form 선택]] — 세 가지 폼 선택 기준 상세
- [[uiRecordApi]] — 폼 없이 레코드 CRUD (createRecord, updateRecord)
- [[lightning-record-picker]] — 레코드 검색·선택 위젯 (record-edit-form과 함께 사용)
- [[Lightning Base Components 레퍼런스]] — 전체 컴포넌트 목록
