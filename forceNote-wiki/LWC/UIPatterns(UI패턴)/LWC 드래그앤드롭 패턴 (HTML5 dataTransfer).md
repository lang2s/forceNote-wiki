---
tags: [LWC, UIPatterns, drag-and-drop, HTML5, dataTransfer, dragstart, drop, dragover, SObject]
source: ebikes-lwc-main/force-app/main/default/lwc/productTile + orderBuilder (실전 예시) + developer.mozilla.org/en-US/docs/Web/API/HTML_Drag_and_Drop_API (레퍼런스)
created: 2026-07-04
aliases: [LWC drag and drop, HTML5 drag drop, dataTransfer, draggable, ondragstart, ondrop, ondragover, effectAllowed, dropEffect, setData, getData, 드래그앤드롭, 드래그 앤 드롭, 레코드 드래그, SObject 전달]
---

# LWC 드래그앤드롭 패턴 (HTML5 dataTransfer)

> LWC에는 전용 드래그앤드롭 베이스 컴포넌트가 없다. 표준 **HTML5 Drag and Drop API**(`draggable` 속성 + 드래그 이벤트 + `DataTransfer`)를 그대로 써서, 소스 컴포넌트에서 SObject를 JSON 문자열로 직렬화해 드롭 타깃 컴포넌트로 전달한다.

---

## 1. 핵심 개념 — 왜 문자열 직렬화인가

`DataTransfer`의 데이터 스토어는 **문자열(MIME 타입별)과 File만** 담을 수 있다. JavaScript 객체(SObject 레코드)를 그대로 넘길 수 없으므로, `dragstart`에서 `JSON.stringify(record)`로 직렬화해 넣고, `drop`에서 `JSON.parse(getData(...))`로 복원한다. 이는 드래그가 컴포넌트 경계(심지어 윈도우 경계)를 넘어도 안전하게 동작하게 만드는 표준 계약이다.

세 개의 필수 조각:

| 조각 | 위치 | 역할 |
|---|---|---|
| `draggable` 속성 + `ondragstart` | **소스** 컴포넌트 | 무엇을 끌 수 있는지 + 무슨 데이터를 실을지 |
| `ondragover` + `preventDefault()` | **타깃** 컴포넌트 | "여긴 드롭 가능 구역" 선언 (없으면 drop 안 됨) |
| `ondrop` | **타깃** 컴포넌트 | 데이터 복원 + 실제 처리(DML 등) |

---

## 2. 전체 API 레퍼런스 (HTML5 표준)

### 2-1. `draggable` 속성

```html
<!-- 구조 예시 -->
<div draggable="true">끌 수 있는 요소</div>
<div draggable="false">끌 수 없음</div>
```

- 이미지·링크·선택된 텍스트는 기본적으로 draggable. 그 외 요소는 명시적으로 `draggable="true"` 필요.
- 게차: 요소가 draggable이면 마우스로 텍스트를 선택하려면 Alt를 눌러야 한다(그냥 드래그하면 선택이 아니라 드래그가 시작됨).

### 2-2. 드래그 이벤트 7종

| 이벤트 | 발생 시점 | 발생 대상 |
|---|---|---|
| `dragstart` | 드래그 시작 | 끌리는 요소(소스) |
| `drag` | 드래그 중 (수백 ms마다 반복) | 소스 |
| `dragenter` | 끌린 요소가 타깃에 진입 | 드롭 타깃 |
| `dragleave` | 끌린 요소가 타깃을 벗어남 | 드롭 타깃 |
| `dragover` | 타깃 위에 있는 동안 (수백 ms마다 반복) | 드롭 타깃 |
| `drop` | 타깃에 놓임 | 드롭 타깃 |
| `dragend` | 드래그 종료(성공/취소 무관) | 소스 |

> 제약: OS 파일을 브라우저로 끌 때는 `dragstart`/`drag`/`dragend`가 발생하지 않고, 브라우저 밖으로 끌 때는 `dragenter`/`dragleave`/`dragover`/`drop`이 발생하지 않는다.

LWC 마크업에서는 이벤트 핸들러를 kebab이 아니라 `on<event>` 형태로 바인딩한다: `ondragstart`, `ondragover`, `ondrop`, `ondragenter`, `ondragleave`, `ondragend`, `ondrag`.

### 2-3. `DataTransfer` 객체 — 프로퍼티

| 프로퍼티 | 타입 | 접근 | 설명 |
|---|---|---|---|
| `dropEffect` | string | dragover/drop에서 읽기·쓰기 | 시각 피드백. `"none"` · `"copy"` · `"move"` · `"link"` |
| `effectAllowed` | string | dragstart에서 쓰기 | 허용 연산 집합(아래 표) |
| `files` | FileList | 읽기 전용 | 끌어온 OS 파일 목록 |
| `items` | DataTransferItemList | 읽기 전용 | 끌린 항목 목록 |
| `types` | string[] | dragover/drop에서 읽기 | 스토어에 담긴 데이터의 MIME 타입 배열 |

### 2-4. `DataTransfer` — 메서드

```javascript
// 구조 예시
ev.dataTransfer.setData("text/plain", "내용");        // dragstart에서만 쓰기
ev.dataTransfer.setData("product", jsonString);        // 커스텀 타입 키도 허용
const data = ev.dataTransfer.getData("product");       // drop에서만 읽기
ev.dataTransfer.clearData();                           // dragstart에서만
ev.dataTransfer.setDragImage(imageEl, xOffset, yOffset); // 커스텀 드래그 이미지
```

> 데이터 스토어는 **`dragstart`에서만 쓰기 가능**하고 **`drop`에서만 읽기 가능**하다. 그 외 이벤트(dragover 등)에서 `getData`를 호출하면 빈 문자열이 온다(protected mode).

### 2-5. `effectAllowed` 값

`dragstart`에서 설정. 이 드래그로 허용되는 연산을 선언.

`"none"` · `"copy"` · `"move"` · `"link"` · `"copyMove"` · `"copyLink"` · `"linkMove"` · `"all"` · `"uninitialized"`(기본 = 전부 허용)

### 2-6. `dropEffect` 값

`dragover`/`drop`에서 설정. 커서 아이콘으로 사용자에게 어떤 연산이 일어날지 표시.

`"none"`(드롭 불가) · `"copy"` · `"move"` · `"link"`

`effectAllowed`가 허용하지 않는 `dropEffect`를 주면 드롭이 거부된다(예: `effectAllowed="copy"`인데 `dropEffect="move"`).

### 2-7. ⚠️ 가장 흔한 함정 — `preventDefault()`

브라우저의 기본 동작은 "드롭 불가"다. 따라서 **`dragover`에서 `event.preventDefault()`를 호출하지 않으면 `drop` 이벤트가 아예 발생하지 않는다.** `drop` 핸들러에서도 브라우저의 기본 처리(예: 파일을 새 탭에서 열기)를 막기 위해 `preventDefault()`를 호출한다.

---

## 3. 실전 예시 (ebikes-lwc) — SObject를 컴포넌트 간 전달

Trailhead ebikes 앱의 주문 빌더: 제품 타일(`productTile`)을 주문 드롭존(`orderBuilder`)으로 끌어다 놓으면 `Order_Item__c` 레코드가 생성된다.

### 3-1. 소스 컴포넌트 — `productTile`

`draggable`은 `@api`로 노출해 부모가 켤 수 있게 하고, `dragstart`에서 `Product__c` SObject를 통째로 직렬화한다.

```javascript
// productTile.js (실제 코드)
import { LightningElement, api } from 'lwc';

export default class ProductTile extends LightningElement {
    /** Whether the tile is draggable. */
    @api draggable;

    _product;
    @api
    get product() {
        return this._product;
    }
    set product(value) {
        this._product = value;
        this.pictureUrl = value.Picture_URL__c;
        this.name = value.Name;
        this.msrp = value.MSRP__c;
    }

    handleDragStart(event) {
        event.dataTransfer.setData('product', JSON.stringify(this.product));
    }
}
```

```html
<!-- productTile.html (실제 코드) -->
<template>
    <div draggable={draggable} ondragstart={handleDragStart}>
        <a onclick={handleClick}>
            <div class="content">
                <img src={pictureUrl} alt="Product picture" />
                ...
            </div>
        </a>
    </div>
</template>
```

포인트:
- `draggable={draggable}` — 불리언 프로퍼티를 표현식으로 바인딩. 부모가 `draggable`을 넘겨야 실제로 끌린다.
- `setData('product', ...)` — `'product'`라는 커스텀 MIME 키를 쓴다. 타깃은 동일 키로 `getData('product')` 해야 한다.

### 3-2. 타깃 컴포넌트 — `orderBuilder`

드롭존 `<div>`에 `ondrop` + `ondragover`를 건다.

```html
<!-- orderBuilder.html (실제 코드) -->
<div
    class="drop-zone slds-var-p-around_x-small"
    ondrop={handleDrop}
    ondragover={handleDragOver}
>
    <template for:each={orderItems} for:item="orderItem">
        <c-order-item-tile key={orderItem.Id} order-item={orderItem}>
        </c-order-item-tile>
    </template>
    <template lwc:if={hasNoOrderItems}>
        <c-placeholder
            message="Drag products here to add items to the order"
        ></c-placeholder>
    </template>
</div>
```

```javascript
// orderBuilder.js (실제 코드 — 발췌)
import { createRecord } from 'lightning/uiRecordApi';
import { refreshApex, getSObjectValue } from '@salesforce/apex';
import ORDER_ITEM_OBJECT from '@salesforce/schema/Order_Item__c';
import ORDER_FIELD from '@salesforce/schema/Order_Item__c.Order__c';
import PRODUCT_FIELD from '@salesforce/schema/Order_Item__c.Product__c';
import PRICE_FIELD from '@salesforce/schema/Order_Item__c.Price__c';
import PRODUCT_MSRP_FIELD from '@salesforce/schema/Product__c.MSRP__c';

const DISCOUNT = 0.6;

export default class OrderBuilder extends LightningElement {
    @api recordId;

    /** 새 제품을 드롭해 Order_Item__c를 생성한다. */
    handleDrop(event) {
        event.preventDefault();
        // Product__c from LDS — 직렬화된 문자열을 복원
        const product = JSON.parse(event.dataTransfer.getData('product'));

        // 새 Order_Item__c 레코드 필드 구성
        const fields = {};
        fields[ORDER_FIELD.fieldApiName] = this.recordId;
        fields[PRODUCT_FIELD.fieldApiName] = product.Id;
        fields[PRICE_FIELD.fieldApiName] = Math.round(
            getSObjectValue(product, PRODUCT_MSRP_FIELD) * DISCOUNT
        );

        const recordInput = {
            apiName: ORDER_ITEM_OBJECT.objectApiName,
            fields
        };
        createRecord(recordInput)
            .then(() => refreshApex(this.wiredOrderItems))
            .catch((e) => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error creating order',
                    message: reduceErrors(e).join(', '),
                    variant: 'error'
                }));
            });
    }

    /** dragover에서 preventDefault를 호출해야 drop이 발생한다. */
    handleDragOver(event) {
        event.preventDefault();
    }
}
```

포인트:
- `handleDragOver`가 하는 일은 오직 `preventDefault()` 하나다 — 이게 없으면 `handleDrop`이 절대 호출되지 않는다.
- `getData('product')` 키가 소스의 `setData('product', ...)` 키와 정확히 일치.
- 복원한 `product`(LDS SObject 형태)에서 필드를 꺼낼 때 `getSObjectValue(product, PRODUCT_MSRP_FIELD)`를 쓴다 — 값이 `{ value, displayValue }` 래핑 형태이기 때문. (평범한 SOQL/Apex 객체라면 `product.MSRP__c`로 직접 접근)
- 드롭 결과로 `createRecord`(LDS DML)를 호출해 서버에 실제 레코드를 만든다. 드래그앤드롭은 UI 제스처일 뿐, 영속화는 별도 DML.

---

## 4. 전체 데이터 흐름

```
// 구조 예시 — 실제 원본 다이어그램 아님
[productTile]  사용자가 타일을 끌기 시작
   dragstart → dataTransfer.setData('product', JSON.stringify(product))
        │  (product SObject → JSON 문자열)
        ▼
[orderBuilder .drop-zone]  타일이 위에 있는 동안
   dragover → event.preventDefault()      ← 이게 없으면 drop 안 옴
        │
        ▼  사용자가 놓음
   drop → event.preventDefault()
        → JSON.parse(dataTransfer.getData('product'))  (문자열 → SObject 복원)
        → createRecord(Order_Item__c)  → refreshApex
```

---

## 5. 대안 비교 — 언제 무엇을 쓰나

| 방식 | 데이터 전달 | 적합한 경우 | 한계 |
|---|---|---|---|
| **HTML5 Drag & Drop (이 노트)** | `dataTransfer` 문자열 직렬화 | 컴포넌트 간(부모-자식 아닌) 시각적 드래그 이동, 목록↔목록 | 문자열만, 터치 기기 지원 제한적, 접근성 별도 처리 필요 |
| **`lightning-datatable` 행 재정렬** | 컴포넌트 내부 상태 | 테이블 내 정렬/선택 | 컴포넌트 경계를 넘는 드래그 불가 |
| CustomEvent / LMS | 이벤트 detail 객체 | 클릭·선택 기반 상호작용 | 드래그 제스처 아님(끌어놓기 UX 없음) |
| `pubsub` / wire | 상태 공유 | 데이터 동기화 | UI 드래그와 무관 |

드래그앤드롭이 **꼭 필요한** 경우(끌어놓는 물리적 UX)에만 HTML5 API를 쓰고, 단순 "선택→전달"이면 CustomEvent가 더 단순하다.

---

## 6. 제약·게차 체크리스트

- ❗ `dragover`에 `preventDefault()` 없으면 `drop` 미발생 — 1순위 버그 원인.
- 데이터 스토어는 `dragstart`에서만 쓰고 `drop`에서만 읽는다. dragover에서 `getData` 하면 빈 문자열.
- JS 객체 직접 전달 불가 → `JSON.stringify`/`JSON.parse` 필수. 순환 참조 객체는 stringify 실패.
- `setData`/`getData`의 MIME(또는 커스텀) 키는 소스·타깃이 정확히 일치해야 한다.
- 터치 스크린은 HTML5 DnD를 기본 지원하지 않는 경우가 많다 — 모바일이면 pointer 이벤트 기반 대안 검토.
- 접근성: 드래그앤드롭만 제공하면 키보드 사용자가 조작 불가. 대체 경로(버튼·클릭) 병행 권장.
- 커스텀 SObject를 직렬화하면 서버에서 재조회하지 않는 한 stale 가능 — ebikes는 드롭 후 `createRecord` + `refreshApex`로 서버 진실을 다시 가져온다.

---

## 관련 노트
- [[CustomEvent 패턴]] — 드래그가 아닌 선택·전달 기반 컴포넌트 통신
- [[이벤트 전파 (bubbles·composed)]] — DOM 이벤트가 컴포넌트 경계를 넘는 방식
- [[uiRecordApi]] — 드롭 결과를 영속화하는 createRecord/deleteRecord
- [[파일 업로드와 이미지 처리]] — dataTransfer.files 기반 파일 드롭과의 접점
- [[상태 관리]] — 드롭으로 갱신된 목록의 클라이언트 상태 관리
