---
tags: [apex, pattern, pagination, aura-enabled]
source: dreamhouse-lwc/PropertyController, PagedResult, visualforce-to-lwc-main/classes/PaginatedListControllerLwc.cls, visualforce-to-lwc-main/lwc/listInfiniteScrolling
created: 2026-05-17
aliases: [PagedResult, 페이지네이션, paged, 무한 스크롤, infinite scroll, nextPageToken, 커서 페이지네이션]
---

# PagedResult 패턴

> `@AuraEnabled` 메서드에서 페이지네이션 결과를 반환하는 표준 DTO 패턴. LWC에서 이전/다음 페이지 버튼으로 대용량 데이터를 탐색할 때 사용.

---

## PagedResult 클래스

```apex
public with sharing class PagedResult {
    @AuraEnabled public Integer pageSize    { get; set; }
    @AuraEnabled public Integer pageNumber  { get; set; }
    @AuraEnabled public Integer totalItemCount { get; set; }
    @AuraEnabled public Object[] records   { get; set; }
}
```

> `Object[]` — 모든 SObject 타입에 재사용 가능.

---

## Controller 패턴

```apex
public with sharing class PropertyController {
    private static final Decimal DEFAULT_MAX_PRICE = 9999999;
    private static final Integer DEFAULT_PAGE_SIZE = 9;

    @AuraEnabled(cacheable=true scope='global')
    public static PagedResult getPagedPropertyList(
        String searchKey,
        Decimal maxPrice,
        Integer pageSize,
        Integer pageNumber
    ) {
        // ?? (null coalescing) — null 입력 방어
        Decimal safeMaxPrice    = maxPrice   ?? DEFAULT_MAX_PRICE;
        Integer safePageSize   = pageSize   ?? DEFAULT_PAGE_SIZE;
        Integer safePageNumber = pageNumber ?? 1;

        String pattern = '%' + searchKey + '%';
        Integer offset = (safePageNumber - 1) * safePageSize;

        PagedResult result = new PagedResult();
        result.pageSize       = safePageSize;
        result.pageNumber     = safePageNumber;

        // 1) COUNT — 전체 개수 (OFFSET 불가, LIMIT 없음)
        result.totalItemCount = [
            SELECT COUNT()
            FROM Property__c
            WHERE Name LIKE :pattern AND Price__c <= :safeMaxPrice
        ];

        // 2) 레코드 — 실제 페이지 데이터
        result.records = [
            SELECT Id, Name, Price__c, Beds__c, Baths__c
            FROM Property__c
            WHERE Name LIKE :pattern AND Price__c <= :safeMaxPrice
            WITH USER_MODE
            ORDER BY Price__c
            LIMIT :safePageSize
            OFFSET :offset
        ];
        return result;
    }
}
```

### 핵심 포인트

| 항목 | 설명 |
|---|---|
| `??` null coalescing | Apex 호환 (`maxPrice ?? DEFAULT`) — null 시 기본값 |
| `scope='global'` | 관리형 패키지에서 다른 패키지가 접근 가능하도록 |
| COUNT 쿼리 별도 | `totalItemCount` 계산 — SOQL에서 COUNT()에 LIMIT/OFFSET 불가 |
| `WITH USER_MODE` | 레코드 쿼리에만 적용 (COUNT 쿼리는 생략 가능) |
| `Object[]` records | 타입 유연성 — PagedResult를 여러 오브젝트에 재사용 |

---

## LWC 연결

```javascript
import getPagedPropertyList from '@salesforce/apex/PropertyController.getPagedPropertyList';

const PAGE_SIZE = 9;

export default class PropertyTileList extends LightningElement {
    pageNumber = 1;
    pageSize   = PAGE_SIZE;
    searchKey  = '';
    maxPrice   = 9999999;

    @wire(getPagedPropertyList, {
        searchKey:  '$searchKey',
        maxPrice:   '$maxPrice',
        pageSize:   '$pageSize',
        pageNumber: '$pageNumber'
    })
    properties;

    handlePreviousPage() { this.pageNumber -= 1; }
    handleNextPage()     { this.pageNumber += 1; }
}
```

```html
<!-- paginator 자식 컴포넌트로 위임 -->
<c-paginator
    page-number={properties.data.pageNumber}
    page-size={properties.data.pageSize}
    total-item-count={properties.data.totalItemCount}
    onprevious={handlePreviousPage}
    onnext={handleNextPage}
></c-paginator>
```

---

## 변형 — 무한 스크롤 + 커서(nextPageToken) 누적 로딩

위 패턴은 `pageNumber`로 이전/다음 오프셋 페이지를 **교체**한다(한 번에 한 페이지만 화면에 있음). `lightning-datatable`의 무한 스크롤은 여기서 두 가지가 달라진다.

- **커서 스타일 토큰**: `pageNumber` 대신 `nextPageToken`(다음 OFFSET 값)을 반환. **다음 페이지가 없으면 `null`** 을 반환해 클라이언트가 로딩을 멈출 신호로 쓴다.
- **누적 어셈블리**: 페이지를 교체하지 않고 `concat`으로 기존 배열 **뒤에 이어 붙인다**. 스크롤할수록 화면 레코드가 늘어난다.

### Apex — 커서 DTO + null 종료 토큰

```apex
public with sharing class PaginatedListControllerLwc {
    @AuraEnabled(cacheable=true)
    public static PaginatedAccounts getAccountsPaginated(
        Integer pageSize,
        Integer pageToken
    ) {
        PaginatedAccounts paginatedAccounts = new PaginatedAccounts();
        paginatedAccounts.records = [
            SELECT Name, Type, Phone, NumberOfEmployees, Owner.Name
            FROM Account
            WITH SECURITY_ENFORCED
            ORDER BY Name
            LIMIT :pageSize
            OFFSET :pageToken
        ];

        Integer totalCount = [SELECT COUNT() FROM Account];

        // 다음 OFFSET이 전체 개수를 넘으면 null → 클라이언트 로딩 종료 신호
        paginatedAccounts.nextPageToken = (pageToken + pageSize < totalCount)
            ? pageToken + pageSize
            : null;

        return paginatedAccounts;
    }

    public class PaginatedAccounts {
        @AuraEnabled
        public List<Account> records;
        @AuraEnabled
        public Integer nextPageToken;
    }
}
```

| 항목 | offset 페이지네이션(위) | 커서 무한 스크롤(여기) |
|---|---|---|
| 토큰 필드 | `pageNumber`(1-based) | `pageToken`(= OFFSET 값) |
| 진행 방식 | 클라이언트가 `pageNumber ± 1` 계산 | 서버가 다음 `nextPageToken` 반환 |
| 끝 판정 | `pageNumber × pageSize ≥ totalItemCount` 를 UI가 계산 | 서버가 **`null` 토큰** 반환 |
| DTO | `PagedResult`(pageSize·pageNumber·totalItemCount·records) | `PaginatedAccounts`(records·nextPageToken) |

> `pageToken`은 여기서 실제로는 OFFSET 정수다. 서버가 다음 값을 계산해 돌려주므로 클라이언트는 오프셋 산술을 몰라도 된다(커서 추상화).

### LWC — 반응형 wire 토큰 갱신 후 concat 누적

```javascript
import { LightningElement, wire } from 'lwc';
import getAccountsPaginated from '@salesforce/apex/PaginatedListControllerLwc.getAccountsPaginated';
// ... 필드 import 생략, COLUMNS 정의 생략 ...
const PAGE_SIZE = 5;

export default class ListInfiniteScrolling extends LightningElement {
    columns = COLUMNS;
    error;
    records = [];
    _currentPageToken = 0;    // wire의 반응형 파라미터 ($_currentPageToken)
    _nextPageToken = PAGE_SIZE;

    @wire(getAccountsPaginated, {
        pageSize: PAGE_SIZE,
        pageToken: '$_currentPageToken'   // 이 값이 바뀔 때마다 wire 재실행
    })
    wiredAccounts({ data, error }) {
        if (data) {
            // 교체가 아니라 concat — 기존 배열 뒤에 이어붙여 누적
            this.records = this.records.concat(data.records);
            this._nextPageToken = data.nextPageToken;
        } else if (error) {
            this.records = null;
            this.error = error;
        }
    }

    loadMoreData() {
        // 서버가 null을 주면(마지막 페이지) 토큰을 갱신하지 않아 wire 정지
        if (this._nextPageToken) {
            this._currentPageToken = this._nextPageToken;
        }
    }
}
```

```html
<!-- 이전/다음 버튼(paginator) 대신 datatable 자체 스크롤 이벤트 -->
<lightning-datatable
    key-field="id"
    data={records}
    columns={columns}
    enable-infinite-loading
    onloadmore={loadMoreData}
></lightning-datatable>
```

### 동작 흐름

1. 초기 `_currentPageToken = 0` → wire가 첫 5건 로드 → `records`에 concat, `_nextPageToken`에 서버가 준 `5` 저장.
2. 사용자가 테이블 하단까지 스크롤 → `lightning-datatable`이 `loadmore` 발생 → `loadMoreData()` 호출.
3. `_nextPageToken`이 truthy면 `_currentPageToken`에 대입 → **반응형 wire 파라미터 변경** → wire 재실행 → 다음 5건이 `concat`으로 누적.
4. 서버가 `nextPageToken = null`(마지막 페이지)을 반환하면 `loadMoreData()`의 `if`가 false → 토큰 미갱신 → wire 정지 → 스크롤 로딩 종료.

> `enable-infinite-loading` 속성과 `loadmore` 이벤트의 정의는 [[lightning-datatable]] 참조. 이 노트는 그 이벤트가 커서 토큰과 만나 **누적 어셈블리**되는 실전 결선을 다룬다.

> COUNT 쿼리로 `totalCount`를 매 페이지 재계산하는 점은 위 offset 패턴과 동일하다(대용량이면 비용 주의). 차이는 그 값을 UI에 노출하지 않고 **서버 내부에서 종료 토큰 계산에만** 쓴다는 것.

---

## scope='global' 사용 기준

| 상황 | 권장 |
|---|---|
| 단일 패키지 앱 | `@AuraEnabled(cacheable=true)` (기본) |
| 관리형 패키지 — 외부 패키지가 호출 | `scope='global'` 추가 |
| 내부 전용 유틸리티 | scope 생략 |

---

## 관련 노트

- [[SOQL 패턴]]
- [[Dynamic SOQL]]
- [[DML 패턴]]
- [[Wire 패턴]]
