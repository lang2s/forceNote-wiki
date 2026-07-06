---
tags: [lwc, lds, getRecord, wire, schema, pattern, layoutTypes]
source: lwc-recipes/wireGetRecord, wireGetRecordDynamicContact, wireGetRecords, wireGetObjectInfo + api_ui.pdf (v67.0, Summer '26) Ch3 Request Parameters — layoutTypes·modes
created: 2026-05-17
aliases: [getRecord, getFieldValue, wireGetRecord, getRecord layoutTypes, 레이아웃 기반 조회]
---

# getRecord 패턴

> `@wire(getRecord)` — recordId + fields로 레코드 조회. Schema import(정적)와 문자열 배열(동적) 두 방식.

---

## Static Fields (권장)

```javascript
import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';

const FIELDS = [NAME_FIELD, PHONE_FIELD];

export default class WireGetRecord extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    contact;

    // getFieldValue로 안전하게 값 추출
    get name() {
        return getFieldValue(this.contact.data, NAME_FIELD);
    }
    get phone() {
        return getFieldValue(this.contact.data, PHONE_FIELD);
    }
}
```

---

## Dynamic Fields (런타임 결정)

```javascript
const FIELDS = ['Contact.Name', 'Contact.Title', 'Contact.Phone'];

@wire(getRecord, { recordId: '$recordId', fields: FIELDS })
contact;

// 문자열 방식은 getFieldValue 없이 직접 접근
get name() {
    return this.contact.data?.fields.Name.value;
}
```

---

## getFieldValue vs 직접 접근

```javascript
// getFieldValue — Schema import 기반, null 안전
get name() {
    return getFieldValue(this.contact.data, NAME_FIELD); // null 반환 (예외 없음)
}

// 직접 접근 — optional chaining 필수
get name() {
    return this.contact.data?.fields.Name.value; // undefined 반환
}
```

> [!tip] getFieldDisplayValue
> `getFieldDisplayValue(record, field)` — 포맷된 값 반환 (날짜→'Jan 1, 2024', 통화→'$1,000').

---

## optionalFields — 선택적 필드

```javascript
@wire(getRecord, {
    recordId: '$userId',
    fields: [NAME_FIELD],          // 필수 — 없으면 에러
    optionalFields: [EMAIL_FIELD]  // 선택 — FLS로 차단돼도 에러 없음
})
record;
```

---

## layoutTypes·modes — 레이아웃 기반 조회

`fields`로 필드를 직접 나열하는 대신, **레이아웃에 배치된 필드를 그대로** 가져올 수 있다.

```javascript
// 구조 예시 — 실제 동작 코드 아님 (문법은 api_ui.pdf 요청 파라미터 기준)
import { getRecord } from 'lightning/uiRecordApi';

export default class RecordByLayout extends LightningElement {
    @api recordId;

    @wire(getRecord, {
        recordId: '$recordId',
        layoutTypes: ['Full'],   // 'Compact' | 'Full'(기본)
        modes: ['View']          // 'Create' | 'Edit' | 'View'(기본)
    })
    record;
}
```

**either-or 요건** — `getRecord`가 래핑하는 REST `GET /ui-api/records/{recordId}` 기준:

| API 버전 | 요건 |
|---|---|
| **45.0+** | `fields` · `optionalFields` · `layoutTypes` **셋 중 하나 필수** |
| 44.0 이하 | `fields` 또는 `layoutTypes` 중 하나 필수 |

- `layoutTypes` 값: **Compact**(레코드 핵심 필드만) / **Full**(기본, 전체 레이아웃).
- `modes` 값: **Create / Edit / View**(기본). 레이아웃은 모드별로 필드가 다르다 — 예: formula 필드는 View 모드엔 렌더되지만 Create 모드엔 없음. `modes`는 **layoutTypes를 지정했을 때만 유효**하고, layoutTypes 없이 단독 지정하면 무시된다.
- `layoutTypes` 지정 시 응답 필드는 `layoutTypes` + `modes` + `optionalFields`의 **합집합**.
- `fields`와 `layoutTypes`를 **동시에** 지정하려면 (REST 레벨에서) `childRelationships`도 함께 지정해야 한다.

**fields vs layoutTypes 선택 기준:**

| | `fields` 지정 | `layoutTypes` 지정 |
|---|---|---|
| 필드 결정 주체 | 코드 (개발자) | 페이지 레이아웃 (어드민) |
| 반환 데이터 | 나열한 필드만 — 최소·예측 가능 | 레이아웃의 모든 필드 — 목록을 코드가 통제 못함 |
| 레이아웃 변경 시 | 영향 없음 | 자동 반영 (재배포 불필요) |
| 적합한 경우 | 컴포넌트가 쓸 필드가 명확할 때 (일반적 권장) | 레이아웃을 미러링하는 범용/디테일 UI, 필드 하드코딩을 피하고 싶을 때 |

> REST 파라미터 스키마 전체(childRelationships, pageSize 등)는 [[UI API 리소스 레퍼런스]] 참조.

---

## getRecords — 여러 레코드 동시 조회

```javascript
import { getRecords } from 'lightning/uiRecordApi';

@wire(getContactList)
wiredContacts({ data }) {
    if (data) {
        this.records = [
            {
                recordIds: [data[0].Id, data[1].Id],
                fields: [NAME_FIELD],
                optionalFields: [EMAIL_FIELD]
            }
        ];
    }
}

@wire(getRecords, { records: '$records' })
recordResults;
```

---

## getObjectInfo — 객체 메타데이터

```javascript
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

// 동적 objectApiName으로 메타데이터 조회
@wire(getObjectInfo, { objectApiName: '$objectApiName' })
objectInfo;

get recordTypeId() {
    return this.objectInfo.data?.defaultRecordTypeId;
}
```

---

## getPicklistValues — Picklist 옵션

```javascript
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import TYPE_FIELD from '@salesforce/schema/Account.Type';

@wire(getPicklistValues, {
    recordTypeId: '$recordTypeId', // getObjectInfo에서 가져온 값
    fieldApiName: TYPE_FIELD
})
picklistValues;

get typeOptions() {
    return this.picklistValues.data?.values; // [{ label, value }, ...]
}
```

---

## 관련 노트

- [[uiRecordApi]]
- [[Record Form 선택]]
- [[Wire 패턴]]
- [[ldsUtils reduceErrors]]

- [[UI API 개요]] — LDS 전체 구조, 캐시·ETag·HTTP 상태코드
- [[UI API 리소스 레퍼런스]] — layoutTypes·modes·optionalFields 등 REST 요청 파라미터 스키마 전체
- [[RefreshView API]] — `@wire(getRecord)` + `notifyRecordUpdateAvailable`로 record 데이터 refresh 개시(refresh 짝)
