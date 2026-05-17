---
tags: [apex, pattern, pagination, aura-enabled]
source: dreamhouse-lwc/PropertyController, PagedResult
created: 2026-05-17
aliases: [PagedResult, 페이지네이션, paged]
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
