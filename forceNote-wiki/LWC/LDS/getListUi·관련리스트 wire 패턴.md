---
tags: [LWC, LDS, uiListsApi, uiRelatedListApi, list-view, related-list, wire]
source: developer.salesforce.com LWC Developer Guide — reference-get-list-records-by-name / reference-get-list-info-by-name / reference-get-list-ui / reference-wire-adapters-get-related-list-records / -get-related-list-info / -get-related-list-count / -get-related-lists-info
created: 2026-07-08
aliases: [getListRecordsByName, getListInfoByName, getListUi, getRelatedListRecords, getRelatedListInfo, getRelatedListCount, getRelatedListsInfo, 리스트뷰 wire, 관련리스트 wire, list view records, related list records]
---

# getListUi·관련리스트 wire 패턴

> `lightning/uiListsApi`(리스트 뷰)와 `lightning/uiRelatedListApi`(관련 리스트)의 wire 어댑터로 Apex 없이 리스트 뷰·관련 리스트의 메타데이터와 레코드를 가져오고, `pageToken`/`pageSize`로 페이지네이션한다.

---

## 두 모듈 개요

| 모듈 | 대상 | 대표 어댑터 |
|---|---|---|
| `lightning/uiListsApi` | **리스트 뷰**(List View) — 오브젝트 탭의 저장된 뷰 | `getListRecordsByName`, `getListInfoByName`, `getListInfosByName` |
| `lightning/uiRelatedListApi` | **관련 리스트**(Related List) — 레코드 페이지에 딸린 자식 목록 | `getRelatedListRecords`, `getRelatedListInfo`, `getRelatedListCount`, `getRelatedListsInfo` |
| `lightning/uiListApi` (단수, **deprecated**) | 리스트 뷰(레코드+메타 통합) | `getListUi` — 신규 개발 금지, `getListInfoByName`+`getListRecordsByName`로 대체 |

> ⚠️ 모듈명 혼동 주의: 신규는 복수형 `uiLists**Api**`, 폐기된 것은 단수형 `uiList**Api**`(`getListUi`)다.

이 어댑터들은 모두 **Lightning Data Service(LDS)** 위에서 동작하므로 결과가 클라이언트 캐시에 저장되고, 같은 레코드를 다른 컴포넌트가 이미 로드했다면 서버 왕복 없이 캐시에서 제공된다. → [[LDS 개념 (Lightning Data Service)]]

---

## lightning/uiListsApi — 리스트 뷰

### getListRecordsByName — 리스트 뷰의 레코드

리스트 뷰의 API 이름으로 레코드 데이터를 가져온다.

```js
import { LightningElement, wire } from 'lwc';
import { getListRecordsByName } from 'lightning/uiListsApi';
```

**파라미터**

| 이름 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `objectApiName` | String | ✅ | 지원 오브젝트의 API 이름 |
| `listViewApiName` | String | ✅ | 리스트 뷰 API 이름 (예: `AllAccounts`) |
| `fields` | String[] | | 추가로 쿼리할 필드. 보이는 컬럼은 만들지 않음. 사용자에게 접근 권한이 없으면 **에러** |
| `optionalFields` | String[] | | 추가 필드. 접근 권한 없으면 에러 대신 결과에서 **제외** |
| `pageSize` | Integer | | 한 번에 볼 레코드 수. 기본 50, 유효 범위 1–2000 |
| `searchTerm` | String | | 결과를 필터링하는 검색어. 와일드카드 지원 |
| `sortBy` | String | | 정렬 필드 API 이름. `-` 접두 시 내림차순(예: `-CreatedDate`). **요청당 값 1개만** |
| `where` | String | | 반환 레코드에 적용하는 필터. **GraphQL 문법** (예: `{ and: [ { StageName: { eq: "Prospecting" } } ] }`) |
| `pageToken` | Integer | | 페이지 오프셋 토큰. `pageSize`와 함께 사용. 최대 오프셋 2000, 기본 0 |

- 반환: `data` → **List Record Collection**, `error` → FetchResponse
- 컬렉션에는 페이지네이션용 `nextPageToken`·`previousPageToken`이 포함된다.

```js
// 구조 예시 — 공식 문서에 서술된 페이지네이션 패턴을 따라 작성
export default class ListViewRecords extends LightningElement {
    // ⚠️ 리액티브 파라미터($)는 반드시 초기값을 준다. undefined면 wire가 발동하지 않음
    pageToken = null;

    @wire(getListRecordsByName, {
        objectApiName: 'Contact',
        listViewApiName: 'AllContacts',
        pageSize: 10,
        sortBy: 'Name',
        pageToken: '$pageToken'   // $ 접두 → 값이 바뀌면 wire 재실행
    })
    listView;

    get records() {
        return this.listView.data?.records?.records ?? [];
    }

    handleNextPage() {
        // 다음 페이지: 반환된 nextPageToken을 pageToken에 대입
        this.pageToken = this.listView.data?.records?.nextPageToken;
    }

    handlePreviousPage() {
        this.pageToken = this.listView.data?.records?.previousPageToken;
    }
}
```

> 페이지네이션 규칙: `$pageToken`을 쓰려면 클래스에 `pageToken = null;`이 있어야 한다. 리액티브 파라미터 중 하나라도 `undefined`면 config가 불완전해 wire가 절대 발동하지 않고 `data`/`error` 둘 다 `undefined`로 남는다.

### getListInfoByName — 리스트 뷰의 메타데이터

```js
import { getListInfoByName } from 'lightning/uiListsApi';
```

| 이름 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `objectApiName` | String | ✅ | 지원 오브젝트 API 이름 |
| `listViewApiName` | String | ✅ | 리스트 뷰 API 이름 |

- 반환: `data` → **List Info**(표시 컬럼 `displayColumns` 등), `error` → FetchResponse
- 여러 리스트 뷰의 메타를 한 번에 받으려면 **`getListInfosByName`** 사용.

```js
@wire(getListInfoByName, { objectApiName: 'Account', listViewApiName: 'AllAccounts' })
listInfo;

get columns() {
    return this.listInfo.data?.displayColumns ?? [];
}
```

### getListUi (Deprecated) — 레코드+메타 통합

> [!warning] `getListUi`는 **deprecated**다. 더 이상 업데이트되지 않고 Main Services Agreement의 "Services"에 포함되지 않으며 평가 목적 전용(프로덕션 금지)이다. 신규 개발에서는 `getListInfoByName`(메타) + `getListRecordsByName`(레코드)로 대체한다.

- 모듈이 단수형 `lightning/uiListApi`다: `import { getListUi } from 'lightning/uiListApi';`
- 4가지 호출 형태를 지원했다:
  - `objectApiName` + `listViewApiName` → 특정 리스트 뷰의 레코드+메타 (`data` = List UI)
  - `listViewId` → 리스트 뷰 ID로 조회 (`data` = List UI)
  - `objectApiName` + MRU `listViewApiName` → 최근 사용(MRU) 리스트 뷰 (`data` = MRU List UI Representation)
  - `objectApiName`만 → 오브젝트의 리스트 뷰 목록 (`data` = List View Summary Collection)
- Request Parameters 테이블의 추가 파라미터(`pageSize`·`sortBy`·`fields`·`optionalFields` 등)를 함께 전달 가능. 페이지 이동은 `nextPageToken`·`previousPageToken` 사용 — **세션·페이지 새로고침을 가로질러 pageToken을 재사용할 수 없다.**
- 반환 레코드에는 시스템 필드(`CreatedDate`, `Id`, `LastModifiedById`, `LastModifiedDate`, `SystemModstamp`)가 포함된다. 특정 필드가 필요하면 `fields`로 명시 요청해야 하며, 없으면 반환을 가정하지 말 것.

---

## lightning/uiRelatedListApi — 관련 리스트

관련 리스트는 특정 레코드에 연결된 레코드 목록(예: Account의 Contacts·Cases·Notes·Files)이다. `relatedListId`는 자식 관계 API 이름으로, `/ui-api/related-list-info/${parentObjectApiName}` 리소스로 조회할 수 있다.

```js
import {
    getRelatedListRecords,
    getRelatedListInfo,
    getRelatedListCount,
    getRelatedListsInfo
} from 'lightning/uiRelatedListApi';
```

### getRelatedListRecords — 관련 리스트 레코드

| 이름 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `parentRecordId` | String | ✅ | 부모 레코드 ID (예: Account ID) |
| `relatedListId` | String | ✅ | 관련 리스트/자식 관계 API 이름 (예: `Contacts`, `Opportunities`, `Cases`). 커스텀 오브젝트는 `Custom_Objects__r` 형식 |
| `fields` | String[] | | 관련 리스트 컬럼 필드의 API 이름. 커스텀 필드는 `Custom_Object__c.FieldName__c` 형식 |
| `optionalFields` | String[] | | 추가 필드. 접근 불가 시 에러 없이 제외 |
| `pageSize` | Number | | 페이지당 레코드 수. 기본 50, 범위 1–1999 |
| `sortBy` | String[] | | 정렬 필드 API 이름 배열. **요청당 값 1개만** |
| `where` | String | | 관련 리스트에 적용하는 필터. 세미조인·안티조인 미지원(`inq` 사용 시 Malformed Join Input Object 에러) |

- 반환: `data` → **Related List Record Collection**, `error` → FetchResponse

```js
// 구조 예시 — 문서 서술("parent ID·related list object로 레코드 조회 후 순회")을 따라 작성
import { api, wire } from 'lwc';

export default class AccountContacts extends LightningElement {
    @api recordId;   // 레코드 페이지에서 부모 레코드 ID 주입

    @wire(getRelatedListRecords, {
        parentRecordId: '$recordId',
        relatedListId: 'Contacts',
        fields: ['Contact.Name', 'Contact.Email'],
        pageSize: 20,
        sortBy: ['Contact.Name']
    })
    relatedContacts;

    get records() {
        return this.relatedContacts.data?.records ?? [];
    }
}
```

### getRelatedListInfo — 관련 리스트 메타데이터

| 이름 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `parentObjectApiName` | String | ✅ | 부모 오브젝트 API 이름 (예: Account) |
| `relatedListId` | String | ✅ | 관련 리스트 오브젝트 API 이름 |
| `recordTypeId` | String | | 부모 레코드 타입 ID. 미지정 시 기본 레코드 타입 |
| `fields` | Array of Strings | | 쿼리할 관련 리스트 필드. 접근 권한 없거나 미존재 시 에러 |
| `optionalFields` | Array of Strings | | 추가 필드. 접근 가능하면 포함, 아니면 에러 없이 제외 |
| `restrictColumnsToLayout` | Boolean | | 페이지 레이아웃의 컬럼만(true) 또는 전체 컬럼(false). **기본 true** |

- 반환: `data` → **Related List Info**(표시 컬럼 등), `error` → FetchResponse

### getRelatedListCount — 관련 리스트 레코드 수

| 이름 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `parentRecordId` | String | ✅ | 부모 레코드 ID |
| `relatedListId` | String | ✅ | 관련 리스트 오브젝트 API 이름 |
| `maxCount` | Number | | 반환할 최대 레코드 수. **기본 20** |

- 반환: `data` → **Related List Record Count**, `error` → FetchResponse

```js
@wire(getRelatedListCount, { parentRecordId: '$recordId', relatedListId: 'Cases' })
caseCount;

get total() {
    return this.caseCount.data?.count ?? 0;
}
```

### getRelatedListsInfo — 오브젝트 기본 레이아웃의 관련 리스트 목록

| 이름 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `parentObjectApiName` | String | ✅ | 부모 오브젝트 API 이름 |
| `recordTypeId` | String | | 부모 레코드 타입 ID |

- 반환: `data` → **Related List Summary Collection**, `error` → FetchResponse

---

## 페이지네이션·정렬 요약

| 항목 | 리스트 뷰 (`getListRecordsByName`) | 관련 리스트 (`getRelatedListRecords`) |
|---|---|---|
| 페이지 크기 | `pageSize` (기본 50, 1–2000) | `pageSize` (기본 50, 1–1999) |
| 페이지 이동 | `pageToken`(Integer 오프셋) + 응답의 `nextPageToken`/`previousPageToken` | 응답 토큰 기반 (컬렉션의 `nextPageToken` 등) |
| 정렬 | `sortBy`(String, 값 1개, `-` 내림차순) | `sortBy`(String[], 값 1개) |
| 필터 | `where`(GraphQL 문법) + `searchTerm` | `where`(세미조인·안티조인 미지원) |

- 리액티브 규칙: `$`가 붙은 모든 파라미터는 클래스에 초기값이 있어야 한다. 하나라도 `undefined`면 wire config가 불완전해 발동하지 않는다.
- 캐시: LDS가 결과를 캐싱하므로 같은 뷰/관련 리스트를 여러 컴포넌트가 요청해도 한 번만 서버를 친다. 명시적 재조회는 `refreshApex`/RefreshView로 한다 → [[RefreshView API]].

---

## 관련 노트
- [[getRecord 패턴]]
- [[UI API 리소스 레퍼런스]]
- [[LDS 개념 (Lightning Data Service)]]
- [[RefreshView API]]
- [[LWC MOC]]
