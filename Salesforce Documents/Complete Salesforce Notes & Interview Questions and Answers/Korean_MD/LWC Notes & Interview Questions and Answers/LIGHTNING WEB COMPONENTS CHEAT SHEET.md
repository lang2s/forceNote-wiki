# LWC 치트시트 (Santanu Boral)

## 개요
LWC는 HTML·최신 JavaScript(ES7+)를 쓰는 커스텀 HTML element. Salesforce 지원 모든 브라우저. Aura와 공존·상호운용. 웹 표준·고성능.

**기능·장점:** 웹 표준, 최신 JS, @wire로 데이터 접근 단순화, Shadow DOM, 렌더링 최적화·보안·캐싱.

## 시작
1. Setup → Develop → Lightning Components → Enable.
2. **SFDX 라이프사이클:**
- 프로젝트: `sfdx force:project:create --projectname MyLWC`
- 인증: `sfdx force:auth:web:login -d -a LWC-Hub`
- 컴포넌트: `sfdx force:lightning:component:create --type lwc -n myComponent -d force-app/main/default/lwc`
- 배포: `sfdx force:source:push`

## 컴포넌트 번들·규칙
필수 3개: HTML, JS(.js), Config(.js-meta.xml). 선택: CSS, SVG.
**폴더 규칙:** 소문자 시작, 영숫자·언더스코어만. 공백·끝 언더스코어·연속 언더스코어·하이픈 불가.

## HTML
```html
<template>
    <!-- 컴포넌트 HTML -->
</template>
```
렌더링 시 `<template>`이 `<c-my-component>`로 대체(c는 기본 네임스페이스). 서비스 컴포넌트는 HTML 불필요.

## Controller
```javascript
import { LightningElement } from 'lwc';
export default class MyComponent extends LightningElement {
    // 코드
}
```

## Configuration
```xml
<LightningComponentBundle xmlns="...">
    <apiVersion>45.0</apiVersion>
    <isExposed>false</isExposed>
</LightningComponentBundle>
```

## CSS·SVG
표준 CSS. SVG는 커스텀 아이콘(`<component>.svg`, 폴더당 1개).

## 데코레이터
반응형 속성: 값 변경 시 재렌더링.
- **@api:** public 속성(반응형).
- **@track:** private 반응형.
- **@wire:** 데이터 조회·바인딩.
- **setAttribute():** JS 속성을 HTML 속성에 반영.
```javascript
import { LightningElement, track, api } from 'lwc';
export default class myComponent extends LightningElement {
    @api title = 'Sample Example';
    @track itemName = 'Bike';
    handleClick(){ this.itemName = 'Cycle'; }
}
```

## Composition
- **Owner:** 템플릿 소유. composed 컴포넌트의 public 속성 설정·메서드 호출·이벤트 수신.
- **Container:** 다른 컴포넌트 포함(owner보다 약함). public 속성 읽기만.
- **Parent & Child:** 부모가 자식 포함.

**자식에 속성 설정:** owner가 속성 설정. 데이터 바인딩은 owner→child 단방향(Aura와 달리). 자식은 읽기 전용 취급, 변경하려면 부모에 이벤트.
```html
<!-- 부모 todoapp.html -->
<c-todoitem item-name={itemName}></c-todoitem>
```
```javascript
// 자식 c-todoitem.js
@api itemName;  // owner에서 전달된 값은 읽기 전용
```

**자식 메서드 호출:** owner·parent가 자식 JS 메서드 호출.
```javascript
// 부모
handlePlay() { this.template.querySelector('c-video-player').play(); }
// 자식
@api play() { this.template.querySelector('video').play(); }
```

**요소 접근:** `this.template.querySelector()`(첫 요소), `querySelectorAll()`(배열).
**Static Resource:** `import myResource from '@salesforce/resourceUrl/...'`
**Label:** `import labelName from '@salesforce/label/...'`
**Current UserId:** `import Id from '@salesforce/user/Id'`

## Shadow DOM
각 LWC 요소가 shadow tree에 캡슐화(문서에서 숨김). 스타일·동작 일관성 유지 웹 표준.

## 이벤트 통신
- **생성:** CustomEvent() 생성자.
- **발생:** `this.dispatchEvent(new CustomEvent('eventname'))`.
- **데이터 전달:** `new CustomEvent('selected', { detail: this.contact.Id })`.
- **선언적 리스너:** `<c-child onnotification={handleNotification}></c-child>`.
- **프로그래밍 리스너:** `this.template.addEventListener('notification', this.handleNotification.bind(this))`.
- **dispatcher 참조:** `evt.target.value`.

## Salesforce 데이터 작업
**LDS:** 컴포넌트·wire 어댑터·JS 함수. 레코드 캐시·공유, 서버 호출 최적화.
**기본 컴포넌트:** lightning-record-form, lightning-record-edit-form, lightning-record-view-form. 생성/업데이트는 lightning/uiRecordApi(CRUD·FLS·공유 준수).

**레코드 로드:**
```html
<lightning-record-form record-id={recordId} object-api-name="Account" layout-type="Compact" mode="view"></lightning-record-form>
```

**wire로 레코드 데이터 조회:**
```javascript
import { getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';
@wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_NAME_FIELD]}) record;
```

**레코드 생성(createRecord):**
```javascript
createAccount() {
    const fields = {};
    fields[NAME_FIELD.fieldApiName] = this.name;
    const recordInput = { apiName: ACCOUNT_OBJECT.objectApiName, fields };
    createRecord(recordInput)
        .then(account => { this.accountId = account.id; /* 성공 토스트 */ })
        .catch(error => { /* 오류 토스트 */ });
}
```

**오류 처리:**
```javascript
@wire(getRecord, { recordId: '$recordId', fields })
wiredRecord({error, data}) {
    if (error) { this.error = Array.isArray(error.body) ? error.body.map(e => e.message).join(', ') : error.body.message; }
    else if (data) { /* 처리 */ }
}
```

**Apex 호출:**
```apex
public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
        return [SELECT Id, Name FROM Contact WHERE Picture__c != null LIMIT 10];
    }
}
```
```javascript
import apexMethod from '@salesforce/apex/Namespace.Classname.apexMethod';
@wire(apexMethod, { apexMethodParams }) propertyOrFunction;
// 동적 매개변수
@wire(findContacts, { searchKey: '$searchKey' }) contacts;
```

## Aura 공존
LWC는 Aura/LWC의 자식만 될 수 있고 Aura의 부모는 될 수 없음. Aura 래퍼가 필요한 경우: 이름으로 직접 내비게이션, 네임스페이스 간 참조, 동적 컴포넌트, Refresh View, Flow, Lightning Out·Visualforce.
