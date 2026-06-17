---
tags: [Service, Knowledge, 지식, SOAP-API, sObject, 통계, ViewStat, VoteStat, CaseArticle, LinkedArticle, TopicAssignment]
source: salesforce_knowledge_dev_guide.pdf (v67.0 Summer '26, Ch2 PDF p47–65)
created: 2026-06-17
aliases: [KnowledgeArticleVersionHistory, KnowledgeArticleViewStat, KnowledgeArticleVoteStat, CaseArticle, LinkedArticle, RecentlyViewed, SearchPromotionRule, TopicAssignment, Knowledge 통계 객체, 아티클 view vote 통계, 케이스 아티클 연관, linked article]
---

# Knowledge SOAP API 객체 — 통계·연관·주변 객체

> Knowledge SOAP API의 통계(VersionHistory/ViewStat/VoteStat)·연관(CaseArticle/LinkedArticle)·주변(RecentlyViewed/SearchPromotionRule/TopicAssignment) 8개 객체의 필드를 전수 정리한다. 핵심 아티클 객체는 [[Knowledge SOAP API 객체 — 핵심 아티클 객체]] 참조.

---

## Properties 약어 범례

| 약어 | 의미 |
|---|---|
| Filter | Filterable (WHERE) |
| Group | Groupable (GROUP BY) |
| Sort | Sortable (ORDER BY) |
| Create | Createable |
| Update | Updateable |
| Nillable | null 허용 |
| idLookup | upsert 외부 ID로 사용 가능 |
| Autonumber | 자동 채번 |
| Defaulted on create | create 시 기본값 부여 |
| Restricted picklist | 제한된 picklist |

---

## 7. KnowledgeArticleVersionHistory (PDF p47–50) — API v25.0+

아티클의 전체 히스토리에 대한 read-only 접근. **Knowledge__VersionHistory** 가 이 객체로부터 derived된다. 이 파생 객체에 접근하려면 Knowledge 객체의 field history tracking을 켠다.

- **Supported Calls:** `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`
  - API v42.0+에선 `delete()`도 활성화할 수 있다(Enable delete of Field History and Field History Archive 참조).
- **Special Access Rules:** Knowledge 활성화. field·entity·record 수준 보안을 따름. 히스토리에 접근하려면 article type 또는 field에 최소 "Read" 권한 필요. data category 보안의 경우, online version의 분류를 기준으로 접근을 결정하고, online이 없으면 archived, 그다음 draft version 기준으로 보안을 적용.

| Field Name | Type | Properties | Description |
|---|---|---|---|
| DataType | picklist | Filter, Group, Restricted picklist, Sort | history 테이블에서 추적되는 데이터 유형. API v50.0+. |
| EventType | picklist | Filter, Group, Restricted picklist, Sort | history 테이블에서 추적되는 event 유형. |
| FieldName | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 추적된 field 이름. |
| Language | picklist | Filter, Group, Restricted picklist, Sort | 아티클 작성 언어(예: French, Chinese (Traditional)). SOSL query/search 시 WHERE에 Language 지정, 모든 article type에 언어 동일. |
| NewValue | anyType | Nillable, Sort | 변경된 field의 새 값. |
| OldValue | anyType | Nillable, Sort | 변경 전 field의 가장 최근 값. |
| ParentId | reference | Filter, Group, Sort | 아티클의 ID. |
| ParentSobjectType | picklist | Filter, Group, Restricted picklist, Sort | field를 담는 객체의 유형. |
| VersionId | reference | Filter, Group, Nillable, Sort | 아티클 version에 부여된 ID. polymorphic 관계 field. |
| VersionNumber | int | Filter, Group, Sort | 아티클 version 번호. API v24.0+. |

**Usage:** 아티클 히스토리의 event를 query한다. 예: 특정 사용자가 아티클에 한 편집 수, 아티클이 발행된 횟수 등을 조회.

---

## 8. KnowledgeArticleViewStat (PDF p50–52) — API v20.0+

view 수에 대한 통계(published·archived만; draft는 추적 안 됨). Read-only. **Knowledge__ViewStat** 가 이 객체로부터 derived된다.

- **Supported Calls:** `describeSObjects()`, `query()`, `retrieve()`
- **Special Access Rules:** Knowledge 활성화. view를 가져오려면 아티클의 published·archived version에 접근 권한 필요.

| Field Name | Type | Properties | Description |
|---|---|---|---|
| Channel | picklist | Filter, Group, Restricted picklist, Sort | 아티클이 보여지는 채널: **AllChannels**(모든 채널의 view), **App**(internal Salesforce Knowledge 앱), **Pkb**(public knowledge base), **Csp**(Customer Portal), **Prm**(partner portal). |
| NormalizedScore | double | Filter, Nillable, Sort | 선택 채널에서 아티클의 가중 view. view가 가장 많은 아티클이 100점. 다른 아티클은 그 최고치 대비 상대적으로 계산. (예: 최다 read 아티클이 2000 view, 다른 게 1000 view면 각각 100, 50.) |
| ParentId | reference | Filter, Group, Sort | view된 아티클의 ID. KnowledgeArticle 레코드에 대응. |
| ViewCount | int | Filter, Group, Sort | 선택 채널에서 published/archived 아티클이 받은 고유 view 수. view가 많아도 항상 normalized score가 높지는 않음. normalized score는 시간에 따른 view로 계산되며 최근 view가 더 높은 점수를 받음. API v27.0+. |

**Usage:** 아티클 view에 대한 통계를 query/retrieve한다. 또는 article type API Name 뒤에 `__ViewStat`을 붙여 특정 article type의 최다 view 아티클을 query/retrieve할 수 있다.

```sql
SELECT Id, NormalizedScore, Parent.Id
FROM KnowledgeArticleViewStat where Channel = 'App'
ORDER BY NormalizedScore
```

```sql
SELECT Id, NormalizedScore, Parent.Id
FROM Offer__ViewStat where Channel = 'App'
ORDER BY NormalizedScore
```

---

## 9. KnowledgeArticleVoteStat (PDF p52–53) — API v20.0+

모든 article type에 걸친 1~5 척도의 가중 rating. Read-only. **Knowledge__VoteStat** 가 이 객체로부터 derived된다.

- **Supported Calls:** `describeSObjects()`, `query()`, `retrieve()`
- **Special Access Rules:** Knowledge 활성화. vote를 가져오려면 아티클의 published version에 접근 권한 필요.

| Field Name | Type | Properties | Description |
|---|---|---|---|
| Channel | picklist | Filter, Group, Restricted picklist, Sort | 아티클이 rate되는 채널: **AllChannels**, **App**, **Pkb**, **Csp**, **Prm**. |
| NormalizedScore | double | Filter, Nillable, Sort | 1~5 척도의 가중 점수. 점수가 높을수록 vote가 많음. 최근 vote가 없는 아티클은 평균 별 3개로 수렴. |
| ParentId | reference | Filter, Group, Sort | rate된 아티클. KnowledgeArticle 레코드에 대응. |

**Usage:** 아티클의 rating을 query/retrieve한다. 또는 article type API Name 뒤에 `__VoteStat`을 붙여 특정 article type의 rating을 query/retrieve할 수 있다. SOQL 샘플은 KnowledgeArticleViewStat 참조.

---

## 10. CaseArticle (PDF p53–55) — API v20.0+

Case와 KnowledgeArticle의 연관.

- **Supported Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`
- **Special Access Rules:** 부모 Case와 KnowledgeArticle로 접근 제어. 단 query 시에는 부모 Case로만 접근 제어. Customer Portal 사용자는 이 객체에 접근 불가.

| Field | Type | Properties | Description |
|---|---|---|---|
| ArticleLanguage | picklist | Filter, Restricted picklist | 케이스에 연관된 아티클의 언어. |
| ArticleVersionNumber | int | Create, Group, Nillable | 아티클 version 번호. API v24.0+. |
| CaseId | reference | Create, Filter, Group, Sort | KnowledgeArticle에 연관된 Case의 ID. |
| IsSharedByEmail | int | Create, Group, Nillable | 아티클이 email로 고객과 공유되었는지 표시. |
| KnowledgeArticleId | reference | Create, Filter, Group, Sort | Case에 연관된 KnowledgeArticle의 ID. |

**Usage:** knowledge article과 Case의 연관을 나타낸다. 아티클이 특정 이슈와 관련되거나, 상담원이 케이스를 해결하는 데 도움이 되거나, 상담원이 고객에게 아티클을 보낼 때 케이스와 연관된다. Apex·Visualforce에서 case-article 연관을 포함하는 데 쓸 수 있다. API로 이 객체를 update할 수 없다. 기존 레코드와 일치하는 레코드를 만들려 하면 create 요청은 기존 레코드를 그대로 반환한다.

---

## 11. LinkedArticle (PDF p55–57) — API v37.0+

work order, work order line item, work type에 첨부된 knowledge article.

- **Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`
- **Special Access Rules:** Knowledge 활성화. Field Service 활성화 필요. Knowledge 아티클과 그에 연결된 부모 레코드 모두에 접근 권한 있는 사용자만 접근. Salesforce Classic Knowledge에선 Work Order, Work Type, Work Order Line Item 등 Field Service 객체만 linked article로 지원. Lightning Knowledge에선 Chat, Messaging, Voice Call, Social Post 등 다른 social 객체도 지원. 아티클을 첨부/분리하려고 `update()`를 호출하려면 Knowledge 객체에 Read 권한, 갱신하는 객체에 Edit 권한을 켠다. API v58.0+.

| Field Name | Type | Properties | Description |
|---|---|---|---|
| CurrencyIsoCode | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | multicurrency 활성 org에서만. 조직이 허용하는 통화의 ISO 코드. |
| KnowledgeArticleId | reference | Create, Filter, Group, Nillable, Sort | 레코드에 첨부된 Knowledge 아티클의 ID. UI label: **Knowledge Article ID**. |
| KnowledgeArticleVersionId | reference | Create, Filter, Group, Nillable, Sort | 레코드에 첨부된 Knowledge 아티클의 version. 첨부된 version의 title을 표시하고 version으로 링크. UI label: **Article Version**. work order에 아티클을 첨부하면 이후 새 version이 발행되어도 그 version이 그대로 연관됨. 최신 version을 링크하려면 분리 후 재첨부. |
| LinkedEntityId | reference | Create, Filter, Group, Nillable, Sort | Knowledge 아티클이 첨부된 레코드의 ID. UI label: **Linked Record ID**. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | 아티클의 title. UI label: **Article Title**. |
| RecordTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | 사용 시 아티클의 record type ID. Lightning Knowledge에서만 사용 가능. |
| Type | string | Filter, Group, Nillable, Sort | (Read only) Knowledge 아티클이 첨부된 레코드의 유형. 예: work order. UI label: **Linked Object Type**. |

**Usage:** 관리자는 Setup의 Linked Articles 페이지에서 linked article의 page layout, field, validation rule 등을 커스터마이즈할 수 있다.

**Associated Objects:** 별도 명시 없으면 이 객체와 동일 API version에서 제공.
- **LinkedArticleChangeEvent** (API v62.0) — Change event 제공.
- **LinkedArticleFeed** — Feed tracking 제공.
- **LinkedArticleHistory** — tracked field에 대한 history 제공.

---

## 12. RecentlyViewed (PDF p57–61) — list view API v29.0+

현재 사용자가 최근 본/참조한 레코드 또는 list view.

- **Supported Calls:** `describeSObjects()`, `query()`, `update()`
- **Special Usage Rules:** RecentlyViewed는 Event, Task, Report, KnowledgeArticle, Article 객체를 지원하지 않는다. 특정 객체만 지원하며, 지원 객체에 대해서만 list view를 지원한다. 지원 객체는 LastReferencedDate·LastViewedDate field를 가진다.

> **Note:** 여러 community의 멤버인 사용자의 RecentlyViewed 레코드는 Apex로 map에 자동으로 가져올 수 없다. 다른 network의 레코드가 중복 ID를 만들 수 있어 map이 지원하지 않기 때문이다.

| Field | Type | Properties | Description |
|---|---|---|---|
| Alias | string | Filter, Group, Nillable, Sort | 레코드의 alias. |
| Email | email | Filter, Group, Nillable, Sort | 레코드의 email 주소. |
| FirstName | string | Filter, Group, Nillable, Sort | 레코드의 이름. 최근 본 레코드가 사용자면 사용자의 이름. |
| Id | ID | Defaulted on create, Filter, Group, Sort | 최근 본 레코드/list view의 ID. |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | 최근 본 레코드가 활성 사용자인지(true)/아닌지(false). 최근 본 레코드가 사용자일 때만 값을 가짐. |
| LastName | string | Filter, Group, Nillable, Sort | 레코드의 성. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort, Update | 현재 사용자가 이 레코드와 직간접적으로 마지막 상호작용한 timestamp. (레코드를 보거나 열기. lookup/related list 검색에서 레코드 선택.) |
| LastViewedDate | dateTime | Filter, Nillable, Sort, Update | 현재 사용자가 이 레코드/list view를 마지막으로 본 timestamp. null이면 접근만(LastReferencedDate) 했을 수 있음. |
| Name | string | Filter, Group, Nillable, Sort | 최근 본 레코드/list view의 이름. 레코드가 사용자·연락처·리드면 firstname과 lastname의 연결값. |
| NetworkId | reference | Filter, Group, Nillable, Sort | 이 group이 속한 Experience Cloud site의 ID. digital experiences 활성 시만. group 생성 시에만 NetworkId 추가 가능, 기존 group은 변경/추가 불가. API v27.0+. |
| Phone | phone | Filter, Group, Nillable, Sort | 레코드의 전화번호. |
| ProfileId | reference | Filter, Group, Nillable, Sort | 최근 본 레코드가 사용자면 사용자의 프로필 ID. Relationship Name: Profile. Type: Lookup. Refers To: Profile. |
| Title | string | Filter, Group, Nillable, Sort | 최근 본 레코드가 사용자면 사용자의 직함. 예: CFO, CEO. |
| Type | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 최근 본 레코드/list view의 객체 유형. RecentlyViewed가 지원하는 표준·커스텀 객체. |
| UserRoleId | reference | Filter, Group, Nillable, Sort | 이 객체에 연관된 user role의 ID. Relationship Name: UserRole. Type: Lookup. Refers To: UserRole. |

**Usage:** 최근 본 레코드, 최근 참조된 레코드(관련 레코드를 봤을 때), 최근 본 list view를 담은 이종(heterogeneous) 목록을 제공한다. 레코드는 사용자가 상세를 봤을 때 view로 간주되며, 다른 레코드와 함께 list에서 봤을 때는 아니다. 현재 사용자에 특화된 최근 본 항목 목록을 프로그래밍 방식으로 구성하는 데 쓴다(예: 커스텀 UI, 검색 자동완성 옵션). Type으로 필터링한 목록도 가져올 수 있다. RecentlyViewed 데이터는 주기적으로 200 레코드·200 list view로 truncate된다. RecentlyViewed 데이터는 90일간 보존되며, 이후 주기적으로 제거된다.

```sql
SELECT Id, Name
FROM RecentlyViewed
WHERE LastViewedDate !=null
ORDER BY LastViewedDate DESC
```

```sql
SELECT Id, Name
FROM RecentlyViewed
WHERE Type IN ('Account', 'Contact', 'Plan__c')
ORDER BY LastViewedDate DESC
```

```sql
SELECT Account.Name, Title, Email, Phone, Website__c
FROM Contact
WHERE LastViewedDate != NULL
ORDER BY LastViewedDate DESC
```

---

## 13. SearchPromotionRule (PDF p61–62) — API v31.0+

promoted search term(Knowledge 아티클에 연관된 keyword로, 검색 결과에서 먼저 반환됨).

- **Supported Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `undelete()`, `update()`, `upsert()`
- **Special Access Rules:** "Manage Promoted Search Terms" 권한 필요.

| Field Name | Type | Properties | Description |
|---|---|---|---|
| PromotedEntityId | reference | Create, Filter, Group, Nillable, Sort, Update | promoted search term이 연관된 KnowledgeArticleVersion의 ID. 아티클은 published 상태여야 함. |
| Query | string | Create, Filter, Group, Sort, Update | promoted search term의 텍스트. 최대 100자. 같은 term을 여러 아티클에 연관할 수 있음. 사용자 검색이 promoted term과 일치하면 연관된 모든 아티클이 relevancy 순으로 promote됨. 최선의 결과를 위해 promoted term을 선별적으로 만들고 term당 promote되는 아티클 수를 제한. |

**Usage:** Salesforce Knowledge의 아티클 검색 결과를 최적화하는 데 쓴다.

---

## 14. TopicAssignment (PDF p62–65) — API v28.0+

topic을 feed item, record, file에 할당. 관리자는 topic을 추가하기 전에 객체에 대해 topic을 활성화해야 한다. 대부분 객체의 topic은 API v30.0+, ContentDocument의 topic은 API v37.0+에서 제공.

- **Supported Calls:** `create()`, `describeSObjects()`, `delete()`, `getDeleted()`, `getUpdate()`, `query()`, `retrieve()`

| Field Name | Type | Properties | Description |
|---|---|---|---|
| EntityId | reference | Create, Filter, Group, Sort | feed item, record, file의 식별자. polymorphic 관계 field. Relationship Name: Entity. Type: Lookup. **Refers To:** Account, Asset, Campaign, Case, Contact, ContentDocument, Contract, Event, FeedItem, Lead, Opportunity, Order, ProductItem, ProductItemTransaction, ProductRequest, ProductRequestLineItem, ProductRequired, ProductTransfer, ResourceAbsence, ResourcePreference, ReturnOrder, ReturnOrderLineItem, ServiceAppointment, ServiceResource, ServiceResourceSkill, ServiceTerritory, ServiceTerritoryMember, Shift, Shipment, Solution, Task, WorkOrder, WorkOrderLineItem. |
| EntityKeyPrefix | string | Filter, Group, idLookup, Sort | EntityID field의 앞 세 자리로 객체 유형(account, opportunity 등)을 식별. Read-only. API v32.0+. interface label은 "Record Key Prefix"이며 report에만 표시. |
| EntityType | string | Filter, Group, Nillable, Sort | 객체 유형(account, opportunity 등)의 표준 이름. Read-only. API v33.0+. **Note:** ManagedContentVersion entity type의 topic assignment query는 미지원. interface label은 "Object Type"이며 report에만 표시. **Tip:** 대부분 EntityKeyPrefix 대신 이 field를 쓴다(EntityKeyPrefix는 주로 구형 report 지원용). |
| NetworkId | reference | Create, Filter, Group, Nillable, Sort | TopicAssignment이 속한 community의 식별자. digital experiences 활성 시만. |
| TopicId | reference | Create, Filter, Group, Sort | topic의 식별자. Relationship Name: Topic. Type: Lookup. Refers To: Topic. |

**Usage:** feed item, record, file에 대한 topic 할당을 query한다. topic을 할당/제거하려면 "Assign Topics" 권한 필요. SOQL SELECT 구문에서 nested semi-join을 지원하여 특정 topic에 할당된 Knowledge 아티클을 query할 수 있다. 예:

```sql
SELECT parentId FROM KnowledgeArticleViewStat
WHERE parentId in (SELECT KnowledgeArticleId FROM KnowledgeArticleVersion
WHERE publishStatus = 'Online' AND language = 'en_US'
AND Id in (select EntityId from TopicAssignment where TopicId ='0T0xx0000000xxx'))
```

로그인 사용자가 "View All Data" 권한이 있으면 SOQL 제한이 없다. 그 권한이 있는 경우 다음 중 하나를 한다:
- LIMIT 절을 1,100 레코드 이하로 지정.
- WHERE 절에서 `=`로 Id 또는 Entity 필터링.

> **Important:** 이 객체의 레코드를 삭제하면 모든 데이터가 제거된다. 되돌릴 수 없다.

> **Note:** TopicAssignment 객체에 report type을 만들면 모든 query가 SQL로 생성되며, 1,100 레코드 제한 절을 강제하지 않는다.

---

## 관련 노트

- [[Knowledge 데이터 모델 & API 개요]]
- [[Knowledge SOAP API 객체 — 핵심 아티클 객체]]
- [[Knowledge SOAP API 호출]]
- [[Knowledge UI API 제약]]
- [[Service Cloud Objects]]
- [[SOSL 패턴]]
