---
tags: [lwc, lds, record-form, pattern]
source: lwc-recipes/recordFormDynamicContact, recordEditFormDynamicContact, recordViewFormDynamicContact; developer.salesforce.com/docs/component-library (lightning-record-form, lightning-record-edit-form, lightning-record-view-form specification)
created: 2026-05-17
aliases: [lightning-record-form, record-edit-form, record-view-form, 레코드 폼]
---

# Record Form 선택

> 레코드 표시/편집에 3가지 표준 컴포넌트. 필드 제어 수준과 편집 여부에 따라 선택.

---

## 결정 매트릭스

| 컴포넌트 | 저장 방식 | 편집 가능 | 필드 제어 | 사용 시점 |
|---|---|---|---|---|
| `lightning-record-form` | 자동 커밋 | ✅ (선택) | 낮음 (fields 배열) | 기본 CRUD 빠르게 |
| `lightning-record-edit-form` | 명시적 Submit | ✅ | 높음 (개별 input-field) | 복잡한 유효성, 다중 필드 |
| `lightning-record-view-form` | 읽기 전용 | ❌ | 낮음 (output-field) | 레코드 표시만 |

---

## lightning-record-form (가장 단순)

```html
<!-- 동적 objectApiName -->
<lightning-record-form
    object-api-name={objectApiName}
    record-id={recordId}
    fields={fields}
    layout-type="Full"
    columns="2"
    mode="view"
>
</lightning-record-form>
```

```javascript
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';

fields = [NAME_FIELD, PHONE_FIELD];
objectApiName = CONTACT_OBJECT;
```

**mode 옵션:**
- `view` — 보기 (편집 버튼 있음)
- `edit` — 편집 상태로 시작
- `readonly` — 완전 읽기 전용

---

## lightning-record-edit-form (세밀한 제어)

```html
<lightning-record-edit-form
    object-api-name={objectApiName}
    record-id={recordId}
    onsuccess={handleSuccess}
    onerror={handleError}
>
    <lightning-messages></lightning-messages>
    <lightning-input-field field-name="Name"></lightning-input-field>
    <lightning-input-field field-name="Phone"></lightning-input-field>
    <lightning-button type="submit" label="Save" variant="brand"></lightning-button>
    <lightning-button label="Cancel" onclick={handleCancel}></lightning-button>
</lightning-record-edit-form>
```

```javascript
handleSuccess(event) {
    const updatedRecord = event.detail.id;
    this.dispatchEvent(new ShowToastEvent({
        title: 'Success',
        message: 'Record saved',
        variant: 'success'
    }));
    // 폼 초기화
    this.template.querySelectorAll('lightning-input-field')
        .forEach(f => f.reset());
}
```

> [!tip] lightning-messages 필수
> `<lightning-messages>` 없으면 서버 측 유효성 에러가 UI에 표시되지 않음.

---

## lightning-record-view-form (읽기 전용)

```html
<lightning-record-view-form
    object-api-name={objectApiName}
    record-id={recordId}
>
    <lightning-output-field field-name="Name"></lightning-output-field>
    <lightning-output-field field-name="Phone"></lightning-output-field>
    <lightning-output-field field-name="Email"></lightning-output-field>
</lightning-record-view-form>
```

> `lightning-output-field`는 날짜, 전화번호, 이메일 등 Salesforce 형식 자동 적용.

---

## Dynamic vs Static Fields

```javascript
// Dynamic — 런타임 결정
fields = ['Name', 'Phone', 'Email', 'Title'];

// Static — @salesforce/schema import (권장: 컴파일 타임 검증)
import NAME_FIELD from '@salesforce/schema/Contact.Name';
fields = [NAME_FIELD, PHONE_FIELD];
```

---

## 3종 폼 속성·이벤트 전수 레퍼런스

### 주요 속성

| 속성 | record-form | record-edit-form | record-view-form | 값 / 설명 |
|---|---|---|---|---|
| `object-api-name` | ✅ (필수) | ✅ (필수) | ✅ (필수) | 대상 오브젝트 API명 |
| `record-id` | ✅ | ✅ | ✅ (필수) | 기존 레코드 조회/편집 시. record-form에서 생략하면 생성 모드 |
| `record-type-id` | ✅ | ✅ | ❌ | 레코드 타입이 여럿일 때 지정 (`getObjectInfo`로 조회). view는 레코드 자체 타입 사용 |
| `fields` | ✅ (배열) | — (자식 `input-field`) | — (자식 `output-field`) | record-form은 필드 API명 배열. edit/view는 자식 컴포넌트로 필드 선언 |
| `layout-type` | ✅ | ❌ | ❌ | `Full`(전체 페이지 레이아웃) / `Compact`(간편 레이아웃) — record-form 전용 |
| `columns` | ✅ | ❌ | ❌ | 그리드 열 수 — record-form 전용 |
| `mode` | ✅ | ❌ | ❌ | `view`(인라인 편집 가능 표시) / `edit`(편집 시작) / `readonly`(완전 읽기 전용) — record-form 전용 |
| `density` | ✅ | ✅ | ✅ | `auto`(Display Density 설정 감지, 기본) / `comfy`(라벨을 필드 위) / `compact`(라벨을 필드 옆, 좁으면 comfy 전환) |

> `layout-type`·`columns`·`mode`는 **record-form 전용**이다. edit/view-form은 자식 `lightning-input-field`/`lightning-output-field`로 필드와 배치를 직접 구성하므로 레이아웃 속성이 없다.

### 이벤트

| 이벤트 | record-form | record-edit-form | record-view-form | 발생 시점 / `event.detail` |
|---|---|---|---|---|
| `onload` | ✅ | ✅ | ✅ | 레코드 데이터·필드 정의 로드 시. record UI·picklist 값 반환. 초기화 후 여러 번 발생 가능 |
| `onsubmit` | ✅ | ✅ | ❌ | Submit 클릭 시. 편집 가능한 필드 객체 반환(읽기 전용 제외). `preventDefault()`로 취소 가능 |
| `onsuccess` | ✅ | ✅ | ❌ | 저장(생성/수정) 성공 후. 저장된 레코드 반환(`event.detail.id`). 취소 불가 |
| `onerror` | ✅ | ✅ | ❌ | 서버 측 에러 시. message·details·fieldErrors 반환 |
| `oncancel` | ✅ | ❌ (직접 버튼 구현) | ❌ | record-form의 Cancel 버튼 클릭 시. edit-form은 Cancel 버튼을 직접 만들고 핸들러 연결 |

> **읽기 전용인 record-view-form**은 제출 흐름이 없어 `onload`만 지원한다(submit/success/error/cancel 없음).

---

## 관련 노트

- [[uiRecordApi]] — 프로그래밍 방식 CRUD
- [[getRecord 패턴]] — wire 기반 레코드 조회
- [[ldsUtils reduceErrors]] — 에러 정규화
