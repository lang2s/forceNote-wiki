---
tags: [lwc, interview-notes, korean, tier3]
source: Complete Salesforce Notes & Interview Questions and Answers (제3자 학습노트 한글 변환, Tier 3)
created: 2026-06-14
aliases: [Wire adapters and Wire functions]
---

# Wire 어댑터와 Wire 함수

> [!warning] 제3자 학습노트(면접 Q&A)를 한글로 변환한 **Tier 3** 자료입니다. 공식 소스와 대조되지 않았으니 정확도는 공식 문서로 검증하세요.

LWC에서 wire 어댑터·wire 함수는 컴포넌트를 Salesforce org 데이터에 연결하는 선언적 방법.

## Wire 어댑터
Salesforce 제공 사전 정의 함수(레코드·메타데이터·선택 목록 조회).

**1. 단일 레코드(getRecord):**
```javascript
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = ['Account.Name', 'Account.Industry'];
export default class FetchSingleRecord extends LightningElement {
    recordId = '001XXX';
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS }) account;
    get accountName() { return this.account.data ? this.account.data.fields.Name.value : 'N/A'; }
}
```
**2. 선택 목록 값(getPicklistValues):**
```javascript
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import ACCOUNT_INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
@wire(getPicklistValues, { fieldApiName: ACCOUNT_INDUSTRY_FIELD, recordTypeId: '012XXX' }) industryPicklist;
```
**3. 메타데이터(getObjectInfo):**
```javascript
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
@wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT }) accountMetadata;
```

## Wire 함수
커스텀 Apex 메서드로 데이터 조회·처리. 커스텀 비즈니스 로직에 유용.
```apex
public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT Id, Name, Email FROM Contact LIMIT 10];
    }
}
```
```javascript
import getContacts from '@salesforce/apex/ContactController.getContacts';
export default class FetchContacts extends LightningElement {
    @wire(getContacts) contacts;
    get contactList() { return this.contacts.data ? this.contacts.data : []; }
}
```

## 반응형 매개변수
`$variable` 구문으로 동적 데이터 조회·새로고침.
```javascript
@api recordId;
@wire(getRecord, { recordId: '$recordId', fields: FIELDS }) account;
```

## Wire 어댑터 vs Wire 함수
| 기능 | Wire 어댑터 | Wire 함수 |
|---|---|---|
| 정의 | 사전 정의 데이터 조회 | 커스텀 Apex 로직 |
| 데이터 소스 | Salesforce 제공 API | 커스텀 Apex |
| 캐시 | 자동 | Apex에 명시 시 |
| 예 | getRecord, getPicklistValues | getContacts |

## 추가 사항
- **자동 새로고침:** 데이터 변경 시 자동 갱신.
- **반응형 매개변수:** $variable.
- **오류 처리:** data·error 출력.
- **Wire 라이프사이클:** DOM 연결 시·반응형 매개변수 변경 시 호출.
- **읽기 전용:** CRUD는 Apex/imperative.
- **제한:** 복잡 로직·조건 흐름은 imperative.
- **컨텍스트:** LWC에서만.
- **성능:** 캐싱으로 최적화.

**로딩·오류 상태 처리:**
```javascript
@wire(getRecord, { recordId: '$recordId', fields: FIELDS })
wiredRecord({ error, data }) {
    if (data) { this.data = data; this.error = undefined; }
    else if (error) { this.error = error; this.data = undefined; }
}
```

**핵심 어댑터:**

getRecord(단일 레코드), getObjectInfo(메타데이터), getPicklistValues(선택 목록), getListUi(리스트 뷰), 커스텀 Apex(커스텀 로직).

**선택:**

표준 데이터는 Wire 어댑터, 커스텀 로직·필터링은 Wire 함수. 대부분 둘 다 사용.
