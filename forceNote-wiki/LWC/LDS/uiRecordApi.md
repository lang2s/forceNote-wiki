---
tags: [lwc, lds, uiRecordApi, createRecord, updateRecord, pattern]
source: lwc-recipes/ldsCreateRecord, ldsDeleteRecord, datatableInlineEditWithUiApi; ebikes-lwc-main/force-app/main/default/lwc/orderBuilder/orderBuilder.js; LWC Dev Guide — Data Guidelines (LDS 캐시 전파·getRecordNotifyChange deprecation)
created: 2026-05-17
aliases: [uiRecordApi, createRecord, updateRecord, deleteRecord, 낙관적 업데이트, optimistic update, 롤백, getRecordNotifyChange, notifyRecordUpdateAvailable, LDS 캐시, 캐시 전파]
---

# uiRecordApi — 프로그래밍 방식 레코드 CRUD

> `lightning/uiRecordApi`의 `createRecord`, `updateRecord`, `deleteRecord`로 LWC에서 직접 레코드 조작. Apex 없이 FLS/CRUD 자동 적용.

---

## createRecord

```javascript
import { createRecord } from 'lightning/uiRecordApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';

async createAccount() {
    const fields = {};
    fields[NAME_FIELD.fieldApiName] = this.name; // 'Name'
    const recordInput = {
        apiName: ACCOUNT_OBJECT.objectApiName,   // 'Account'
        fields
    };

    try {
        const account = await createRecord(recordInput);
        this.accountId = account.id;
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: `Account ${account.id} created`,
            variant: 'success'
        }));
    } catch (error) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error',
            message: reduceErrors(error).join(', '),
            variant: 'error'
        }));
    }
}
```

---

## updateRecord

```javascript
import { updateRecord } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Account.Id';

async updateAccount() {
    const fields = {};
    fields[ID_FIELD.fieldApiName] = this.recordId; // Id 필수
    fields['Name'] = this.newName;

    try {
        await updateRecord({ fields });
    } catch (error) {
        // 에러 처리
    }
}

// Datatable inline edit — 여러 레코드 병렬 업데이트
async handleSave(event) {
    const records = event.detail.draftValues.map(draft => ({
        fields: Object.assign({}, draft) // { Id: '...', Name: '...' }
    }));
    this.draftValues = [];

    try {
        await Promise.all(records.map(r => updateRecord(r)));
        await refreshApex(this.contacts); // 목록 새로고침
    } catch (error) {
        // 에러 처리
    }
}
```

---

## deleteRecord

```javascript
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

@wire(getAccountList)
wiredAccounts;

async handleDelete(event) {
    const recordId = event.target.dataset.recordid;
    try {
        await deleteRecord(recordId);
        await refreshApex(this.wiredAccounts); // wire 캐시 새로고침
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Record deleted',
            variant: 'success'
        }));
    } catch (error) {
        // 에러 처리
    }
}
```

---

## 실전 패턴 — 낙관적 UI 업데이트 + 실패 롤백 (ebikes orderBuilder)

> ebikes `orderBuilder`는 명령형 DML을 **낙관적 업데이트**로 감싼다: 서버 응답을 기다리지 않고 클라이언트 상태를 먼저 반영(즉각 반응성) → DML `.catch()`에서 이전 상태로 롤백 + `ShowToastEvent`. Apex wire 결과(`getOrderItems`)를 목록으로 쓰고, 개별 항목 CRUD는 `lightning/uiRecordApi`로 처리하는 혼합 구조다.

핵심 3단계:
1. **이전 상태 보존** — DML 직전 `const previousOrderItems = this.orderItems;`
2. **클라이언트 선반영** — 서버 응답 전에 `setOrderItems(...)`로 UI 즉시 갱신
3. **실패 롤백** — `.catch()`에서 `setOrderItems(previousOrderItems)` + 에러 토스트

### 업데이트 — 낙관적 반영 후 실패 시 롤백

```javascript
/** Handles event to change Order_Item__c details. */
handleOrderItemChange(evt) {
    const orderItemChanges = evt.detail;

    // optimistically make the change on the client
    const previousOrderItems = this.orderItems;
    const orderItems = this.orderItems.map((orderItem) => {
        if (orderItem.Id === orderItemChanges.Id) {
            // synthesize a new Order_Item__c SObject
            return Object.assign({}, orderItem, orderItemChanges);
        }
        return orderItem;
    });
    this.setOrderItems(orderItems);

    // update Order_Item__c on the server
    const recordInput = { fields: orderItemChanges };
    updateRecord(recordInput)
        .then(() => {
            // if there were triggers/etc that invalidate the Apex result then we'd refresh it
            // return refreshApex(this.wiredOrderItems);
        })
        .catch((e) => {
            // error updating server so rollback to previous data
            this.setOrderItems(previousOrderItems);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating order item',
                    message: reduceErrors(e).join(', '),
                    variant: 'error'
                })
            );
        });
}
```

### 삭제 — 필터로 선제거 후 실패 시 롤백

```javascript
/** Handles event to delete Order_Item__c. */
handleOrderItemDelete(evt) {
    const id = evt.detail.id;

    // optimistically make the change on the client
    const previousOrderItems = this.orderItems;
    const orderItems = this.orderItems.filter(
        (orderItem) => orderItem.Id !== id
    );
    this.setOrderItems(orderItems);

    // delete Order_Item__c SObject on the server
    deleteRecord(id)
        .then(() => {
            // return refreshApex(this.wiredOrderItems);
        })
        .catch((e) => {
            // error updating server so rollback to previous data
            this.setOrderItems(previousOrderItems);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error deleting order item',
                    message: reduceErrors(e).join(', '),
                    variant: 'error'
                })
            );
        });
}
```

> [!note] 롤백이 성립하는 이유
> `setOrderItems`가 `orderItems.slice()`로 **새 배열**을 만들고 요약값(수량·가격)을 재계산하므로, `previousOrderItems` 참조는 변형되지 않고 그대로 남는다 → catch에서 그 참조를 다시 넣기만 하면 UI가 원상 복구된다. 서버가 진실의 원천이고 클라이언트 반영은 잠정치라는 사고방식이다.

### recordInput 필드를 schema 임포트로 조립 (create)

drag-drop으로 새 `Order_Item__c`를 만들 때, `fields` 키를 문자열이 아니라 **schema 임포트의 `.fieldApiName`**으로 조립한다. `ORDER_FIELD.fieldApiName`이 곧 관계 필드 API명(`Order__c`)이며, 존재하지 않는 필드를 참조하면 컴파일/배포 시 검출된다.

```javascript
import ORDER_ITEM_OBJECT from '@salesforce/schema/Order_Item__c';
import ORDER_FIELD from '@salesforce/schema/Order_Item__c.Order__c';
import PRODUCT_FIELD from '@salesforce/schema/Order_Item__c.Product__c';
import PRICE_FIELD from '@salesforce/schema/Order_Item__c.Price__c';
import PRODUCT_MSRP_FIELD from '@salesforce/schema/Product__c.MSRP__c';

handleDrop(event) {
    event.preventDefault();
    const product = JSON.parse(event.dataTransfer.getData('product'));

    // build new Order_Item__c record — schema 임포트로 필드 API명 조립
    const fields = {};
    fields[ORDER_FIELD.fieldApiName] = this.recordId;      // 'Order__c'
    fields[PRODUCT_FIELD.fieldApiName] = product.Id;        // 'Product__c'
    fields[PRICE_FIELD.fieldApiName] = Math.round(
        getSObjectValue(product, PRODUCT_MSRP_FIELD) * DISCOUNT
    );

    // create Order_Item__c record on server
    const recordInput = {
        apiName: ORDER_ITEM_OBJECT.objectApiName,           // 'Order_Item__c'
        fields
    };
    createRecord(recordInput)
        .then(() => refreshApex(this.wiredOrderItems))       // 목록 새로고침
        .catch((e) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating order',
                    message: reduceErrors(e).join(', '),
                    variant: 'error'
                })
            );
        });
}
```

> **낙관적 업데이트를 안 쓰는 create 경로:** 여기서는 새 레코드의 서버측 Id·계산값이 필요하므로 선반영 대신 `refreshApex(this.wiredOrderItems)`로 서버 데이터를 다시 받는다. update/delete는 변경 내용이 클라이언트에 이미 있어 선반영이 가능하지만, create는 서버가 만든 결과를 받아야 하므로 refresh가 적합하다.

---

## LDS 캐시 전파 — 어떤 변경이 다른 컴포넌트를 자동 갱신하는가

같은 레코드를 보는 컴포넌트들(다른 컴포넌트의 `getRecord` wire, `lightning-record-*form`, 표준 레코드 상세 등)은 **하나의 클라이언트측 LDS 캐시**를 공유한다. 변경이 이 캐시를 **통과하느냐 우회하느냐**에 따라 자동 갱신 여부가 갈린다.

| 변경 경로 | LDS 캐시 | 같은 레코드를 wire한 다른 컴포넌트 |
|---|---|---|
| `createRecord` / `updateRecord` / `deleteRecord` (uiRecordApi) | **직접 갱신** | ✅ 자동 리렌더 — 추가 코드 불필요 |
| `lightning-record-form` / `record-edit-form` 저장 | LDS 경유 → 캐시 갱신 | ✅ 자동 리렌더 |
| **Apex DML** (imperative 호출·`@AuraEnabled` 저장) | **우회** — 캐시는 변경을 모름 | ❌ 갱신 안 됨 → DML 후 `notifyRecordUpdateAvailable([{recordId}])` 호출 필요 |
| 외부 변경 (다른 사용자·자동화·통합) | 우회 — 클라이언트가 알 수 없음 | ❌ 갱신 안 됨 → 알게 된 시점에 `notifyRecordUpdateAvailable` 등으로 무효화 |

```javascript
// 컴포넌트 A — updateRecord로 저장 (LDS 캐시 직접 갱신)
await updateRecord({ fields: { Id: this.recordId, Name: this.newName } });
// → 별도 코드 없이, 같은 레코드를 @wire(getRecord)로 보는 컴포넌트 B가 자동 리렌더
```

> [!tip] 판단 기준 한 줄
> **uiRecordApi/record-form으로 저장했으면 아무것도 안 해도 전파된다.** Apex DML·서버측 변경이면 LDS가 모르므로 `notifyRecordUpdateAvailable`로 직접 알려야 한다.

---

## notifyRecordUpdateAvailable — Apex 업데이트 후 캐시 무효화

> ⚠️ **구 API명 매핑:** `getRecordNotifyChange`(구명)는 **deprecated** — 동일 모듈(`lightning/uiRecordApi`)·동일 시그니처(`[{recordId}]` 배열)의 `notifyRecordUpdateAvailable`로 대체됐다. 옛 문서·코드의 `getRecordNotifyChange`는 이 함수로 읽으면 된다.

```javascript
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';

// Apex로 서버 데이터 변경 후 wire 캐시 무효화
async handleUpdate() {
    try {
        await updateContactApex({ recordId: this.recordId, ... });

        // wire 어댑터가 사용 중인 캐시를 무효화 → 자동 재조회
        notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
    } catch (error) {
        // 에러 처리
    }
}
```

> [!note] refreshApex vs notifyRecordUpdateAvailable
> - `refreshApex(wiredResult)` — 특정 wire 결과 강제 새로고침
> - `notifyRecordUpdateAvailable([{recordId}])` — recordId 기반 전체 캐시 무효화 (getRecord wire 포함)

---

## generateRecordInputForCreate

```javascript
import { generateRecordInputForCreate, getRecord } from 'lightning/uiRecordApi';

// 기존 레코드를 복제하여 새 레코드 생성 준비
@wire(getRecord, { recordId: '$recordId', fields })
record;

async cloneRecord() {
    const recordInput = generateRecordInputForCreate(
        this.record.data,
        this.objectInfo.data
    );
    // recordInput.fields에서 Id, SystemModstamp 등 자동 제거
    const newRecord = await createRecord(recordInput);
}
```

---

## Schema Import vs 문자열

```javascript
// ✅ Schema import (프로덕션 권장)
import NAME_FIELD from '@salesforce/schema/Account.Name';
fields[NAME_FIELD.fieldApiName] = value; // NAME_FIELD.fieldApiName = 'Name'

// 빠른 프로토타이핑
fields['Name'] = value;
```

---

## 관련 노트

- [[Record Form 선택]]
- [[getRecord 패턴]]
- [[ldsUtils reduceErrors]]

- [[UI API 개요]] — LDS 전체 구조, 캐시·ETag·HTTP 상태코드
- [[GraphQL 뮤테이션 (executeMutation) — Create·Update·Delete]] — `lightning/graphql`의 명령형 CRUD 대안 경로(createRecord/updateRecord/deleteRecord와 선택 기준)
- [[experience-lwc-generate]] (sf-skill — 실행형) — LDS wire 어댑터 활용 LWC 생성 실행형 스킬
