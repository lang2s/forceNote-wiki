---
tags: [lwc, apex, wire, reactive, pattern]
source: lwc-recipes/apexWireMethodToProperty, apexWireMethodToFunction, apexWireMethodWithParams + developer.salesforce.com (LWC Developer Guide — refreshApex, Tier 2)
created: 2026-05-17
aliases: [@wire, Wire 어댑터, Reactive Property, refreshApex function 바인딩, wire 새로고침 안 됨]
---

# Wire 패턴

> `@wire`는 컴포넌트 연결 시 자동 실행되는 선언적 데이터 바인딩. property 바인딩(단순)과 function 바인딩(제어 필요) 두 가지 형태.

---

## 패턴 1: Property 바인딩 (가장 단순)

```javascript
import { LightningElement, wire } from 'lwc';
import getContactList from '@salesforce/apex/ContactController.getContactList';

export default class ContactList extends LightningElement {
    @wire(getContactList)
    contacts; // { data: [...], error: undefined } 또는 { data: undefined, error: {...} }
}
```

```html
<!-- 템플릿에서 .data / .error로 접근 -->
<template lwc:if={contacts.data}>
    <template for:each={contacts.data} for:item="contact">
        <p key={contact.Id}>{contact.Name}</p>
    </template>
</template>
<template lwc:elseif={contacts.error}>
    <c-error-panel errors={contacts.error}></c-error-panel>
</template>
<!-- 둘 다 undefined = 로딩 중 -->
```

---

## 패턴 2: Function 바인딩 (데이터 변환 / 추가 로직)

```javascript
@wire(getContactList)
wiredContacts({ error, data }) {
    if (data) {
        // 변환, 필터링 등 추가 로직 가능
        this.contacts = data.filter(c => c.Phone);
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.contacts = undefined;
    }
}
```

```html
<!-- 템플릿은 this.contacts 직접 접근 (더 간결) -->
<template lwc:if={contacts}>
    <template for:each={contacts} for:item="contact">
        <p key={contact.Id}>{contact.Name}</p>
    </template>
</template>
```

| | Property 바인딩 | Function 바인딩 |
|---|---|---|
| 코드량 | 최소 | 더 많음 |
| 데이터 변환 | ❌ | ✅ |
| 템플릿 접근 | `{contacts.data}` | `{contacts}` |
| 선택 기준 | 단순 표시 | 가공 필요 시 |

### Function 바인딩 + refreshApex — provisioned 결과 전체를 보관해야 함

`refreshApex()`의 인자는 **wire 서비스가 provision한 결과 전체**(`{valueProvisionedByApexWireService}`)다.

- **Property 바인딩**은 프로퍼티 자체가 그 결과이므로 `refreshApex(this.contacts)`처럼 그대로 넘기면 된다.
- **Function 바인딩**은 함수가 결과를 받고 사라지므로, `{ error, data }`로 구조 분해해 `data`만 저장하면 **refreshApex에 넘길 provisioned 결과가 남지 않는다** — 실무 최다 실패 케이스.

Function 바인딩에서는 함수 인자를 구조 분해하지 말고 **result 전체를 별도 프로퍼티에 저장**한 뒤 그 프로퍼티를 넘긴다.

```javascript
// 구조 예시 — 실제 동작 코드 아님
import { refreshApex } from '@salesforce/apex';

export default class ContactList extends LightningElement {
    contacts;
    error;
    wiredResult; // provisioned 결과 전체 보관용

    @wire(getContactList)
    wiredContacts(result) {
        this.wiredResult = result; // ✅ result 전체를 먼저 저장
        const { error, data } = result;
        if (data) {
            this.contacts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }

    async handleRefresh() {
        await refreshApex(this.wiredResult); // ✅ 저장해 둔 결과 전체를 전달
    }
}
```

> [!warning] `.data`를 넘기면 동작하지 않음
> `refreshApex(this.contacts)`(data만 저장한 프로퍼티)나 `refreshApex(result.data)`처럼 **데이터 페이로드만 넘기면 refresh가 일어나지 않는다.** wire 서비스가 캐시를 식별하는 메타데이터는 provisioned 결과 객체 전체에 들어 있기 때문. 반드시 `@wire` 프로퍼티 자체(property 바인딩) 또는 함수가 받은 인자 전체(function 바인딩)를 넘긴다.
> 또한 **비-Apex wire 어댑터**(예: `getRecord`)의 refresh에 `refreshApex`를 쓰는 것은 deprecated — record 데이터는 `notifyRecordUpdateAvailable(recordIds)`를 사용한다. import 문법·인자 상세는 [[@salesforce Modules 레퍼런스]] 참조.

---

## 패턴 3: Reactive Property (`$` 접두사)

```javascript
export default class SearchComponent extends LightningElement {
    searchKey = ''; // reactive property

    // searchKey 변경 시 자동 재호출
    @wire(findContacts, { searchKey: '$searchKey' })
    contacts;

    handleKeyChange(event) {
        // debouncing 필수 — 입력마다 Apex 호출 방지
        window.clearTimeout(this.delayTimeout);
        const value = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchKey = value; // 300ms 후 변경 → @wire 재실행
        }, 300);
    }
}
```

> [!warning] 객체/배열 reactive property — 참조 변경 필수
> 객체 속성만 수정하면 `@wire`가 재실행되지 않음. 반드시 새 객체를 생성해야 함.
>
> ```javascript
> // ❌ @wire 재실행 안 됨
> this.params.name = newValue;
>
> // ✅ 새 객체 생성 → @wire 재실행
> this.params = { ...this.params, name: newValue };
> ```

---

## Static Schema Import (타입 안전)

```javascript
import { getSObjectValue } from '@salesforce/apex';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

@wire(getSingleContact)
contact;

get name() {
    return this.contact.data
        ? getSObjectValue(this.contact.data, NAME_FIELD)
        : '';
}
```

> `@salesforce/schema/Object.Field` import — 컴파일 타임에 필드명 검증. 필드 삭제/변경 시 배포 단계에서 오류 감지.

---

## Apex 어노테이션 요건

```apex
// @wire에서 사용 → cacheable=true 필수
@AuraEnabled(cacheable=true)
public static List<Contact> getContactList() { ... }

// cacheable=true면 CUD 불가 → 읽기 전용만
```

---

## 관련 노트

- [[Wire vs Imperative 선택]]
- [[Imperative 호출 패턴]]
- [[getRecord 패턴]]
- [[GraphQL Wire Adapter]] — `lightning/graphql` GraphQL wire adapter (@wire 특화, LDS 기반)
- [[@salesforce Modules 레퍼런스]] — `@salesforce/apex`·`@salesforce/schema`·`getSObjectValue` import 문법 레퍼런스
