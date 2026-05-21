---
tags: [sobject-reference, custom-objects, standard-fields, apex, s2s, partner-network]
source: object_reference.pdf pp.125-129 (v67.0 Summer '26)
created: 2026-05-22
aliases: [Custom Object Standard Fields, __c 표준 필드, 커스텀 오브젝트 시스템 필드, ConnectionReceivedId, ConnectionSentId, CurrencyIsoCode, LastReferencedDate, LastViewedDate]
---

# Custom Object Standard Fields `__c`

> 커스텀 Object 생성 시 Salesforce가 자동 추가하는 표준 필드 전수 참조표

---

## 개요

커스텀 Object 이름은 `CustomObject__c` 형식이다. 예: UI에서 "Issue"라는 Object는 API에서 `Issue__c`.

시스템 필드와 속성은 표준 Object와 동일하게 동작한다(아래 세부 사항 제외).

**지원 호출**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

---

## 전체 표준 필드 참조표

| 필드 | 타입 | 속성 | 설명 |
|---|---|---|---|
| `ConnectionReceivedId` | reference | Filter, Nillable | Salesforce to Salesforce(S2S) 활성화 시 사용. 이 레코드를 공유해 준 PartnerNetworkConnection ID |
| `ConnectionSentId` | reference | Filter, Nillable | S2S 활성화 시 사용. 이 레코드를 공유한 PartnerNetworkConnection ID. API v15.0 이전에만 지원. 이후 버전에서는 항상 null. 대신 `PartnerNetworkRecordConnection` Object 사용 |
| `CreatedById` | reference | Aggregatable, Defaulted on create, Filter, Group, Sort | 이 레코드를 생성한 User ID |
| `CreatedDate` | dateTime | Aggregatable, Defaulted on create, Filter, Sort | 레코드 생성 일시 |
| `CurrencyIsoCode` | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | 다중통화(Multicurrency) 기능 활성화 Org에서만 사용 가능. Org에서 허용된 통화의 ISO 코드 |
| `Id` | Id | Aggregatable, Defaulted on create, Filter, Group, idLookup, Sort | 레코드를 전역적으로 식별하는 고유 문자열. ID 필드 타입 상세는 Field Types 참조 |
| `IsDeleted` | boolean | Defaulted on create, Filter, Group, Sort | 레코드가 휴지통으로 이동됐는지 여부. `true` = 삭제됨. 레이블: Deleted |
| `LastActivityDate` | dateTime | Filter, Group, Nillable, Sort | 다음 중 가장 최근 값: 이 Object에 로그된 가장 최근 Event의 기한, 또는 이 Object와 연결된 가장 최근 완료 Task의 기한 |
| `LastModifiedDate` | dateTime | Aggregatable, Defaulted on create, Filter, Sort | 사용자가 마지막으로 이 레코드를 수정한 일시 |
| `LastModifiedById` | reference | Aggregatable, Defaulted on create, Filter, Group, Sort | 이 Object를 마지막으로 수정한 User ID |
| `LastReferencedDate` | dateTime | Aggregatable, Filter, Sort, Nillable | 현재 사용자가 마지막으로 이 레코드를 조회·수정하거나, 이 레코드에 연관된 레코드를 조회·수정하거나, 목록 뷰를 조회한 일시. null이면 현재 사용자가 이 Object의 관련 레코드를 한 번도 조회·수정하지 않은 것. **커스텀 Object 탭이 생성된 경우에만 존재** |
| `LastViewedDate` | dateTime | Aggregatable, Filter, Sort, Nillable | 현재 사용자가 마지막으로 이 레코드를 직접 조회·수정한 일시. null이면 조회·수정 이력 없음. **커스텀 Object 탭이 생성된 경우에만 존재** |
| `Name` | string | Aggregatable, Create, Defaulted on create, Filter, Group, idLookup, Sort, Update | Object 이름. 레이블: Object Name. 최대 80자. `update()` 호출 시 Name이 null이면 레코드 ID로 설정. `create()` 호출 시 초기값을 레코드 ID로 설정. null로 설정 불가 |
| `OwnerId` | reference | Aggregatable, Create, Defaulted on create, Filter, Group, Namepointing, Sort, Update | 현재 이 Object를 소유한 User ID. 기본값: `create()` 호출 시 API 로그인 사용자 |
| `RecordTypeId` | reference | Create, Filter, Nillable, Update | 이 Object에 지정된 레코드 타입 ID. 커스텀 또는 표준 Object에 레코드 타입이 최소 1개 이상 있어야 이 필드가 나타남 |
| `SystemModStamp` | dateTime | Aggregatable, Defaulted on create, Filter, Sort | 트리거·자동화 포함 마지막 수정 일시. 여기서 trigger는 표준 기능 구현을 위한 Salesforce 내부 코드 — Apex 트리거 아님 |

---

## 주요 동작 규칙

### Name 필드 null 처리

```apex
// create() 호출 시 — Name이 null이어도 레코드 ID로 자동 설정됨
Issue__c issue = new Issue__c();
// issue.Name = null  → Salesforce가 레코드 ID로 자동 채움

// update() 호출 시 — Name을 null로 설정하면 레코드 ID로 대체
Issue__c existing = [SELECT Id, Name FROM Issue__c LIMIT 1];
existing.Name = null;
update existing;
// 이후 existing.Name = existing.Id (레코드 ID값)
```

### ConnectionSentId 마이그레이션 패턴

```apex
// v15.0 이전 방식 (더 이상 권장하지 않음)
Issue__c rec = [SELECT ConnectionSentId FROM Issue__c WHERE Id = :recordId];
// v15.0 이상에서는 ConnectionSentId가 항상 null

// 권장 방식: PartnerNetworkRecordConnection 사용
List<PartnerNetworkRecordConnection> connections = [
    SELECT ConnectionId, LocalRecordId, Status
    FROM PartnerNetworkRecordConnection
    WHERE LocalRecordId = :recordId
];
```

### LastReferencedDate / LastViewedDate 사용 조건

```apex
// 커스텀 Object 탭이 존재하는 경우에만 필드가 나타남
// SOQL에서 활용 예: 최근 7일 내 조회된 레코드
List<Issue__c> recentlyViewed = [
    SELECT Id, Name, LastViewedDate
    FROM Issue__c
    WHERE LastViewedDate = LAST_N_DAYS:7
    ORDER BY LastViewedDate DESC
];
```

---

## 관련 노트

- [[4 Custom Objects]] — Custom Object·Metadata·Feed 챕터 개요 (부모 챕터)
- [[Custom Metadata Type (__mdt)]] — __mdt 표준 필드 참조표
- [[Custom Object Feed (__Feed)]] — __Feed 표준 필드 참조표
- [[System Fields]] — 표준 시스템 필드 (CreatedDate·OwnerId·RecordTypeId 등) 상세
- [[API Field Properties]] — Aggregatable·Nillable·idLookup 등 속성 정의
- [[Field Types]] — reference·dateTime·boolean 등 필드 타입 상세
