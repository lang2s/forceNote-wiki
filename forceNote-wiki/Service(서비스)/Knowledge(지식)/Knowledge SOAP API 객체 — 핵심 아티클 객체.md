---
tags: [Service, Knowledge, 지식, SOAP-API, sObject, KnowledgeArticle, Knowledge__kav, Knowledge__ka, 아티클객체]
source: salesforce_knowledge_dev_guide.pdf (v67.0 Summer '26, Ch2 PDF p15–47)
created: 2026-06-17
aliases: [KnowledgeArticle, KnowledgeArticleVersion, Knowledge__DataCategorySelection, Knowledge__Feed, Knowledge__kav, Knowledge__ka, Knowledge SOAP 아티클 객체, 아티클 버전 객체, PublishStatus, IsMasterLanguage]
---

# Knowledge SOAP API 객체 — 핵심 아티클 객체

> Salesforce Knowledge SOAP API의 6개 핵심 아티클 객체 — KnowledgeArticle, KnowledgeArticleVersion, Knowledge__DataCategorySelection, Knowledge__Feed, Knowledge__kav, Knowledge__ka — 의 필드를 전수 정리한다. 통계·연관 객체는 [[Knowledge SOAP API 객체 — 통계·연관·주변 객체]] 참조.

---

## Properties 약어 범례

각 필드의 Properties 열은 SOAP API sObject 표준 표기다. (이 노트 전체에 1회 적용)

| 약어 | 의미 |
|---|---|
| Filter | Filterable — WHERE 절에 사용 가능 |
| Group | Groupable — GROUP BY에 사용 가능 |
| Sort | Sortable — ORDER BY에 사용 가능 |
| Create | Createable — create() 호출 시 설정 가능 |
| Update | Updateable — update() 호출 시 변경 가능 |
| Nillable | null 허용 |
| idLookup | upsert의 외부 ID로 사용 가능 |
| Autonumber | 자동 채번 |
| Defaulted on create | create 시 기본값 자동 부여 |
| Restricted picklist | 제한된 picklist 값만 허용 |

> 이 노트의 객체 이름 카탈로그·관계 다이어그램은 [[Knowledge 데이터 모델 & API 개요]] 소관이다. 여기서는 필드 상세만 다룬다.

---

## 1. KnowledgeArticle (PDF p15–17) — API v19.0+

아티클에 대한 read-only 접근과 primary article 삭제 기능. KnowledgeArticleVersion과 달리 KnowledgeArticle 레코드의 ID는 아티클의 version(상태)과 무관하게 동일하다. **Knowledge__ka** 가 이 객체로부터 derived된다.

- **Supported Calls:** `describeSObjects()`, `query()`, `retrieve()`
- **Special Access Rules:** Knowledge가 활성화되어야 함. 사용자에게 **View Articles** 권한 필요. Salesforce Knowledge 사용자(customer/partner 사용자와 달리)는 **Knowledge User feature license** 도 부여받아야 함.

| Field Name | Type | Properties | Description |
|---|---|---|---|
| ArchivedById | reference | Filter, Group, Nillable, Sort | 아티클을 archive한 사용자의 ID. |
| ArchivedDate | dateTime | Filter, Nillable, Sort | 아티클이 archive된 날짜. |
| ArticleNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | 아티클 생성 시 자동 부여되는 고유 번호. 형식이나 값을 변경할 수 없음. |
| CaseAssociationCount | int | Filter, Group, Sort | 아티클에 첨부된 케이스 수. |
| FirstPublishedDate | dateTime | Filter, Nillable, Sort | 아티클이 처음 발행된 날짜. |
| IsGeneratedByLlm | boolean | Defaulted on create, Filter, Group, Sort | 아티클의 첫 version이 LLM으로 생성되었으면 true. API v59.0+. |
| LastPublishedDate | dateTime | Filter, Nillable, Sort | 아티클이 마지막으로 발행된 날짜. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드, 관련 레코드, 또는 list view에 마지막으로 접근한 timestamp. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드/list view를 마지막으로 본 timestamp. null이면 사용자가 보지 않은 것(LastReferencedDate로 접근만 했을 수 있음). |
| MasterLanguage | picklist | Filter, Group, Restricted picklist, Sort | 아티클의 원본 언어. knowledge base가 다중 언어를 지원할 때만 접근 가능. |
| MigratedToFromArticle | string | Filter, Group, Nillable, Sort | 마이그레이션 전/후 대응 아티클의 ID. Classic→Lightning Knowledge 마이그레이션 org에서만 값을 가짐. API v45.0+. |
| TotalViewCount | int | Filter, Group, Nillable, Sort | 이 아티클의 총 view 수. API v39.0+. |

**Usage:** 아티클을 query/retrieve할 때 사용. KnowledgeArticle은 SOQL 절에 쓸 수 있으나 아티클의 field에는 접근할 수 없다. read-only 접근과 primary article 삭제 기능을 제공한다.

**SOQL with KnowledgeArticle (MigratedToFromArticle 노출):** sObject API에 migrated_to_from_id 컬럼을 노출하려면 KnowledgeArticle에서 MigratedToFromArticle을 노출한다. SOQL 시:
- MigratedToFromArticle로 필터링하려면 다른 모든 필터를 제거.
- 필터링 시 `=` 또는 `IN` 연산자 사용.
- 값이 null이거나 비어 있으면 안 됨.

---

## 2. KnowledgeArticleVersion (PDF p18–30) — API v18.0+

version에 따라 여러 유형의 표준 아티클 field를 전역적으로 보는 객체. 용도: 여러 유형의 아티클을 generic하게 query/search · 특정 version 필터링 · draft version의 표준 field 갱신. archived 아티클을 query하면 결과에 아티클과 그 archived version이 모두 포함된다. **Knowledge__kav** 가 이 객체로부터 derived된다.

- **Supported Calls:** `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `search()`
- **Note:**
  - draft version만 update할 수 있다.
  - knowledgeManagement REST API로는 draft 번역을 update할 수 없다.
  - Lightning Knowledge에서 아티클 version의 create/update/delete는 Knowledge__kav에 대한 호출을 쓴다(예: `Knowledge__kav.delete()`).
  - Salesforce Classic에서는 ArticleType__kav에 대한 호출을 쓴다(예: `ArticleType__kav.delete()`).
- **Special Access Rules:** Knowledge 활성화 · View Articles 권한 · Knowledge User feature license (KnowledgeArticle과 동일).

| Field Name | Type | Properties | Description |
|---|---|---|---|
| ArchivedById | reference | Filter, Group, Nillable, Sort | 아티클을 archive한 사용자의 ID. |
| ArchivedDate | dateTime | Filter, Nillable, Sort | 아티클 version이 archive된 날짜. |
| ArticleArchivedById | reference | Filter, Group, Nillable, Sort | 아티클을 archive한 사용자의 ID. |
| ArticleArchivedDate | dateTime | Filter, Nillable, Sort | 아티클이 archive된 날짜. |
| ArticleCaseAttachCount | int | Filter, Group, Nillable, Sort | 이 아티클이 첨부된 케이스 수. |
| ArticleCreatedById | reference | Filter, Group, Nillable, Sort | 아티클을 생성한 사용자의 ID. |
| ArticleCreatedDate | dateTime | Filter, Nillable, Sort | 아티클이 생성된 날짜. |
| ArticleMasterLanguage | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 아티클의 원본 언어. 다중 언어 지원 시만 접근 가능. |
| ArticleNumber | string | Autonumber, Defaulted on create, Filter, Sort | 아티클 생성 시 자동 부여되는 고유 번호. 형식·값 변경 불가. |
| ArticleTotalViewCount | int | Filter, Group, Nillable, Sort | 아티클의 총 view 수. |
| ArticleType | string | Defaulted on create, Filter | article type의 API Name. 생성 시 부여되며 값 변경 불가. Salesforce Classic 사용 org에서 API v26.0+ 제공. |
| AssignedById | reference | Filter, Group, Nillable, Sort | 아티클을 할당한 사용자의 ID. |
| AssignedToId | reference | Filter, Group, Nillable, Sort | 아티클이 할당된 사용자의 ID. |
| AssignmentDate | dateTime | Filter, Nillable, Sort | 아티클이 사용자에게 할당된 날짜. |
| AssignmentDueDate | dateTime | Filter, Nillable, Sort | 아티클 할당 시 마감일. |
| AssignmentNote | textarea | Filter, Nillable, Sort | 할당한 사용자가 assignee에게 남기는 노트. |
| FirstPublishedDate | dateTime | Filter, Nillable, Sort | 아티클이 처음 발행된 날짜. |
| IsLatestVersion | boolean | Defaulted on create, Filter, Group, Sort | 아티클이 최신 version인지(true)/아닌지(false). online/published version, 주 언어 draft, 번역 draft, 최신 archived version에서 true일 수 있음. online version은 곧 최신 version이므로 (PublishState='Online') AND (IsLatestVersion=false)로 필터 불가. API v24.0+. |
| IsMasterLanguage | boolean | Defaulted on create, Filter, Group, Sort | 아티클에 하나 이상의 번역이 연관되었는지(true)/아닌지(false). 다중 언어 지원 시만 접근 가능. |
| IsOutOfDate | boolean | Defaulted on create, Filter, Group, Sort | 이 번역 version 생성 이후 source 아티클이 갱신되었는지(true)/아닌지(false). 다중 언어 지원 시만 접근 가능. |
| IsVisibleInApp | boolean | Defaulted on create, Filter, Group, Sort | Required. Articles 탭에 아티클이 표시되는지(true)/아닌지(false). |
| IsVisibleInCsp | boolean | Defaulted on create, Filter, Group, Sort | Required. Customer Portal에 표시되는지(true)/아닌지(false). |
| IsVisibleInPkb | boolean | Defaulted on create, Filter, Group, Sort | Required. public knowledge base에 표시되는지(true)/아닌지(false). |
| IsVisibleInPrm | boolean | Defaulted on create, Filter, Group, Sort | Required. partner portal에 표시되는지(true)/아닌지(false). |
| KnowledgeArticleId | reference | Filter, Group, Sort | version과 독립적인 아티클의 ID. KnowledgeArticle 객체의 Id field에서 가져옴. |
| Language | picklist | Filter, Group, Restricted picklist, Sort | 아티클 작성 언어(예: French, Chinese (Traditional)). SOSL query/search 시 WHERE 절에 Language를 지정해야 하며, 모든 article type에 대해 언어가 같아야 함. API v47.0 이전엔 query 필터에 Language를 포함해야 함. v47.0+에선 query 대상에 따라 Language 유무 선택 가능. |
| LargeLanguageModel | string | Filter, Group, Nillable, Sort | 아티클 version 생성에 사용된 LLM. API v59.0+. |
| LastPublishedDate | dateTime | Filter, Nillable, Sort | 아티클이 마지막으로 발행된 날짜. |
| MasterVersionId | reference | Filter, Group, Nillable, Sort | 아티클이 source 아티클의 번역인 경우, source 아티클의 ID. 다중 언어 지원 시만 접근 가능. |
| MigratedToFromArticleVersion | string | Filter, Group, Nillable, Sort | 마이그레이션 전/후 대응 아티클 version의 ID. Classic→Lightning 마이그레이션 org에서만 값을 가짐. API v43.0+. |
| NextReviewDate | dateTime | Filter, Nillable, Sort | 아티클을 다음에 정확성 검토해야 하는 날짜. API v58.0+. |
| OwnerId | reference | Filter, Group, Sort | 아티클 소유자의 ID. |
| PublishStatus | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | 발행 상태: **Draft**(모든 draft 아티클), **Online**(Salesforce Knowledge에 발행됨), **Archived**(archive됨). Online 사용엔 "Manage Articles" 권한 필요. SOQL/SOSL의 아티클 query/search는 WHERE에 PublishStatus 또는 Id 중 하나를 지정해야 함. 단일 SOSL query에서 article type당 하나의 발행 상태만 검색 가능. Archived 검색 시 WHERE에서 IsLatestVersion이 false인지도 확인. |
| SourceId | reference | Filter, Group, Nillable, Sort | 아티클이 생성된 source의 ID (Case 또는 Reply). |
| Summary | textarea | Filter, Nillable, Sort | 아티클 요약. 최대 1000자. |
| Title | string | Filter, Group, idLookup, Sort | Required. 아티클 제목. 최대 255자. |
| TranslationCompletedDate | dateTime | Filter, Nillable, Sort | 아티클이 마지막으로 번역된 일시. 다중 언어 지원 시만 접근 가능. |
| TranslationExportedDate | dateTime | Filter, Nillable, Sort | 번역용으로 마지막 export된 일시. 다중 언어 지원 시만 접근 가능. |
| TranslationImportedDate | dateTime | Filter, Nillable, Sort | 번역용으로 마지막 import된 일시. 다중 언어 지원 시만 접근 가능. |
| UrlName | string | Filter, Group, idLookup, Sort | Required. 아티클 URL. 영숫자·하이픈 가능하나 하이픈으로 시작/종료 불가. 맥락과 무관하게 고유해야 함(SeeAllData=false인 Apex test에서 기대 결과를 위함). case-sensitive, 최대 255자. |
| ValidationStatus | picklist | Defaulted on create, Filter, Group | 아티클 콘텐츠 검증 여부. 가능 값: Validated, Not Validated. 기본값 Not Validated. API v24.0+. |
| VersionNumber | int | Group, Sort | 아티클 version에 부여된 번호. API v24.0+. |

**Usage:** version에 따라 모든 유형의 아티클을 query/retrieve/search한다. draft primary article은 update 가능, draft가 아닌 아티클은 delete 가능. 클라이언트는 KnowledgeArticleVersion을 `describeDataCategoryGroups()`·`describeDataCategoryGroupStructures()`와 함께 써서 category group/구조를 반환할 수 있다([[Knowledge SOAP API 호출]] 참조). version과 무관한 접근은 KnowledgeArticle을 쓴다. Lightning Knowledge에서 유형은 concrete 파생 객체(예: Knowledge__kav)의 RecordType field로, Classic에서는 ArticleType field로 결정된다.

**SOQL Samples:**

```sql
SELECT Title, Summary
FROM KnowledgeArticleVersion
WHERE PublishStatus='Online'
AND Language = 'en_US'
WITH DATA CATEGORY Geography__c ABOVE_OR_BELOW europe__c AND Product__c BELOW All__c
```

```sql
SELECT Id, Title
FROM Knowledge__kav
WHERE PublishStatus='Draft'
AND Language = 'en_US'
AND RecordTypeId = '<specify RecordTypeId for Offer here>'
WITH DATA CATEGORY Geography__c AT (france__c,usa__c) AND Product__c ABOVE dsl__c
```

```sql
SELECT Id, Title
FROM Offer__kav
WHERE PublishStatus='Draft'
AND Language = 'en_US'
WITH DATA CATEGORY Geography__c AT (france__c,usa__c) AND Product__c ABOVE dsl__c
```

```sql
SELECT Id
FROM KnowledgeArticleVersion
WHERE PublishStatus='Archived'
AND IsLatestVersion=false
AND KnowledgeArticleId='kA1D00000001PQ6KAM'
```

> 위 SOQL의 `WITH DATA CATEGORY` 절 문법은 [[SOQL WITH DATA CATEGORY]] 소관이다.

**SOQL and SOSL with KnowledgeArticleVersion:**
- 최선의 결과를 위해 PublishStatus 단일 값으로 필터링한다. 각 아티클의 모든 version을 찾으려면 PublishStatus 필터를 생략하되 하나 이상의 master key ID로 필터링한다. 주어진 아티클의 모든 archived version을 가져오려면 IsLatestVersion이 false인 SOQL 필터를 지정한다.
- API v46.0 이하에서 PublishStatus 필터 없는 query는 기본적으로 published 아티클을 반환한다. v47.0+에선 Lightning Knowledge 활성 시 draft·published·archived가 모두 반환된다.
- 보안을 위해, "View Draft Articles" 권한 사용자만 PublishStatus가 Draft인 아티클을 본다. "View Archived Articles" 권한 사용자만 Archived 아티클을 본다.
- archived version은 Knowledge__kav 객체에 저장된다. archived version을 query하려면 아티클 Id를 지정하고 IsLatestVersion='0'으로 설정한다.
- KnowledgeArticleVersion 객체로 하는 Apex SOQL에는 binding 변수를 쓸 수 없다. 컴파일 오류를 내는 예:

```apex
final String PUBLISH_STATUS_ONLINE = 'Online';
List<Knowledge__kav> articles = [
SELECT Id FROM Knowledge__kav
WHERE PublishStatus = :PUBLISH_STATUS_ONLINE
];
```

대신 dynamic SOQL을 쓴다:

```apex
final String PUBLISH_STATUS_ONLINE = 'Online';
final String q = 'SELECT Id, PublishStatus FROM Knowledge__kav
WHERE PublishStatus = :PUBLISH_STATUS_ONLINE';
List<Knowledge__kav> articles = Database.query(q);
```

**Other Usage (MigratedToFromArticleVersion 노출):** sObject API에 migrated_to_from_id를 노출하려면 KnowledgeArticleVersion에서 MigratedToFromArticleVersion을 노출한다.
- SOQL: 필터링하려면 다른 필터를 제거. `=`/`IN` 연산자 사용. 값이 null/empty면 안 됨.
- SOSL은 MigratedToFromArticleVersion을 지원하지 않는다.

**Associated Objects:** 별도 명시 없으면 이 객체와 동일 API version에서 제공.
- **KnowledgeArticleVersionHistory** — 객체의 tracked field에 대해 history 제공.

---

## 3. Knowledge__DataCategorySelection (PDF p30–31) — API v39.0+

아티클을 분류하는 data category. 기본 접두사는 Knowledge이며, Object Manager에서 Knowledge__kav 객체의 Object Name을 변경해 바꿀 수 있다.

- **Supported Calls:** `create()`, `delete()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`
- **Special Access Rules:** Lightning Knowledge가 활성화되어야 함.

| Field | Type | Properties | Description |
|---|---|---|---|
| DataCategoryGroupName | datacategorygroupreference | Create | 아티클에 연관된 category를 가진 data category group의 고유 이름. |
| DataCategoryName | datacategorygroupreference | Create | 아티클에 연관된 data category의 고유 이름. |
| ParentId | reference | Create, Filter, Group, Sort | data category selection에 연관된 아티클의 ID. |

**Usage:** 모든 아티클은 분류될 수 있다. data category selection은 아티클을 분류하기 위해 선택된 category를 나타낸다. 이 객체로 아티클 분류를 query/관리한다. 클라이언트는 Draft 상태 아티클에 대한 분류를 create할 수 있고, 분류를 delete/query할 수도 있다.

> **Note:** 이 객체로 아티클을 분류할 때, 한 category(예: USA)와 그 하위(California) 또는 상위(North America) category를 동시에 선택할 수 없다. 이 경우 첫 번째 category만 선택된다.

---

## 4. Knowledge__Feed (PDF p31–36) — API v39.0+

knowledge article의 feed. feed에 대한 추가 정보는 FeedItem 참조. 기본 접두사는 Knowledge이며 Object Manager에서 변경 가능.

- **Supported Calls:** `delete()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`
- **Special Access Rules:** Lightning Knowledge가 활성화되어야 함.

| Field | Type | Properties | Description |
|---|---|---|---|
| BestCommentId | reference | Filter, Group, Nillable, Sort | question post에서 best answer로 표시된 comment의 ID. |
| Body | textarea | Nillable, Sort | feed item의 본문. Type이 TextPost/AdvancedTextPost일 때 Required. ContentPost/LinkPost일 때 Optional. ContentPost는 Body 값이 없어도 되나 attachment가 필요. attachment가 없으면 API version에 따라 Type이 TextPost/AdvancedTextPost로 바뀜(이 둘은 Body 값 필요). **Tip:** rich text 본문에서 지원되는 HTML 태그 목록은 IsRichText field 참조. |
| CommentCount | int | Filter, Group, Sort | 이 feed item에 연관된 comment 수. **Tip:** pre-moderation을 지원하는 feed에서 CommentCount는 comment가 발행될 때까지 갱신되지 않음. moderated feed에선 admin 또는 Can Approve Feed Post and Comment / Modify All Data 권한자가 승인할 때까지 comment가 집계되지 않음. moderated feed에선 CommentCount를 순회하지 말고 comment 끝까지 pagination으로 가져온다. |
| InsertedById | reference | Group, Nillable, Sort | 이 item을 feed에 추가한 사용자의 ID. 예: 다른 앱에서 post/comment를 마이그레이션하면 InsertedBy 값이 context 사용자의 ID로 설정됨. |
| IsRichText | boolean | Defaulted on create, Filter, Group, Sort | feed item Body가 rich text를 담는지 여부. SOAP API로 rich text feed comment를 post하면 IsRichText를 true로 설정하고 본문의 HTML entity를 escape. 그렇지 않으면 plain text로 렌더됨. 지원 태그: `<p>` (**Tip:** `<br>`은 미지원이나 `<p>&nbsp;</p>`로 줄 생성 가능), `<a>`, `<b>`, `<code>`, `<i>`, `<u>`, `<s>`, `<ul>`, `<ol>`, `<li>`, `<img>`. `<img>` 태그는 API로만 접근 가능하며 Salesforce 내 파일을 참조해야 함: `<img src="sfdc://069B0000000omjh"></img>`. **Note:** API v35.0+에선 시스템이 rich text의 특수문자를 escape된 HTML로 대체. v34.0 이하에선 모든 rich text가 plain-text 표현으로 나타남. |
| LikeCount | int | Filter, Group, Sort | 이 feed item에 연관된 like 수. |
| LinkUrl | url | Nillable, Sort | LinkPost의 URL. |
| ParentId | reference | Filter, Group, Sort | feed item이 관련된 Knowledge 아티클의 ID. |
| RelatedRecordId | reference | Group, Nillable, Sort | ContentPost에 연관된 ContentVersion 레코드의 ID. WDC thanks post는 RypplePost에 연관된 WorkThanks 객체의 ID. ContentPost·RypplePost 외 대부분 post에서 null. 예: 이 field를 기존 ContentVersion ID로 설정하고 Type=ContentPost로 feed에 post. |
| Title | string | Group, Nillable, Sort | feed item의 제목. Type이 LinkPost일 때 LinkUrl이 URL이고 이 field가 link 이름. Type QuestionPost인 post에서 Title을 update할 수 있음. |
| Type | picklist | Filter, Group, Nillable, Restricted picklist, Sort | feed item의 유형. ContentPost·LinkPost·TextPost 외에는 API에서 직접 feed item을 만들지 말 것. (아래 Type 값 목록 참조) **Note:** Type을 ContentPost로 설정하면 ContentData·ContentFileName도 지정. |

**Type picklist 전체 값:**

| 값 | 설명 |
|---|---|
| ActivityEvent | 사용자/API가 feed-enabled 부모 레코드에 Task를 추가할 때 간접 생성되는 event(케이스의 email task 제외). 케이스 레코드에 Task/Event를 추가/갱신할 때도 발생(email·call logging 제외). CaseFeed 비활성 recurring Task는 series에 대해 1개 event. CaseFeed 활성 recurring Task는 series와 각 occurrence에 대해 event 생성. |
| AdvancedTextPost | 사용자가 group announcement를 post할 때, 그리고 Lightning Experience API v39.0+에서 사용자가 post를 공유할 때 생성. |
| AnnouncementPost | 사용되지 않음. |
| ApprovalPost | 사용자가 approval을 제출할 때 생성. |
| BasicTemplateFeedItem | 사용되지 않음. |
| CanvasPost | feed에 post된 canvas 앱의 post. |
| CollaborationGroupCreated | 사용자가 public group을 만들 때 생성. |
| CollaborationGroupUnarchived | 사용되지 않음. |
| ContentPost | 파일이 첨부된 post. |
| CreatedRecordEvent | 사용자가 publisher에서 레코드를 만들 때 생성. |
| DashboardComponentAlert | dashboard metric/gauge가 사용자 정의 임계값을 초과할 때 생성. |
| DashboardComponentSnapshot | 사용자가 dashboard snapshot을 feed에 post할 때 생성. |
| LinkPost | URL이 첨부된 post. |
| PollPost | feed에 post된 poll. |
| ProfileSkillPost | 사용자 Chatter 프로필에 skill이 추가될 때 생성. |
| QuestionPost | 사용자가 question을 post할 때 생성. |
| ReplyPost | Chatter Answers가 reply를 post할 때 생성. |
| RypplePost | 사용자가 WDC에서 Thanks badge를 만들 때 생성. |
| TextPost | feed에 직접 입력한 text. |
| TrackedChange | tracked field에 대한 변경(들). |
| UserStatus | 사용자가 post를 추가할 때 자동 생성. Deprecated. |

**CaseFeed에만 적용되는 Type 값** (모든 feed 객체의 Type picklist에 나타나지만 CaseFeed에만 해당):

| 값 | 설명 |
|---|---|
| AttachArticleEvent | 사용자가 케이스에 아티클을 첨부할 때 생성. |
| CallLogPost | 사용자가 UI로 케이스에 통화를 기록할 때 생성. CTI 통화도 이 event 생성. |
| CaseCommentPost | 사용자가 케이스 객체에 case comment를 추가할 때 생성. |
| ChangeStatusPost | 사용자가 케이스 상태를 변경할 때 생성. |
| ChatTranscriptPost | Chat transcript가 케이스에 저장될 때 생성. |
| EmailMessageEvent | 케이스 객체 관련 email이 송수신될 때 생성. |
| FacebookPost | 케이스에서 Facebook post가 생성될 때 생성. Deprecated. |
| MilestoneEvent | case milestone이 완료되거나 violation 상태에 도달할 때 생성. |
| SocialPost | 케이스에서 social post가 생성될 때 생성. |

---

## 5. Knowledge__kav (PDF p36–45) — API v39.0+

Knowledge 아티클 version을 나타내는 concrete 객체. 기본 접두사 Knowledge는 Object Manager에서 변경 가능. 이 객체는 **KnowledgeArticleVersion** 으로부터 derived된다.

- **Supported Calls:** `create()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`
  - 이 객체는 `<ActionOverrides>`를 retrieve하지 않는다.
- **Special Access Rules:** Lightning Knowledge 활성화 · View Articles 권한 · Knowledge User feature license.

| Field | Type | Properties | Description |
|---|---|---|---|
| ArchivedById | reference | Filter, Group, Nillable, Sort | 아티클을 archive한 사용자의 ID. |
| ArchivedDate | dateTime | Filter, Nillable, Sort | 아티클 version이 archive된 날짜. |
| ArticleArchivedById | reference | Filter, Group, Nillable, Sort | 아티클을 archive한 사용자의 ID. |
| ArticleArchivedDate | dateTime | Filter, Nillable, Sort | 아티클이 archive된 날짜. |
| ArticleCaseAttachCount | int | Filter, Group, Nillable, Sort | 이 아티클이 첨부된 케이스 수. |
| ArticleCreatedById | reference | Filter, Group, Nillable, Sort | 아티클을 생성한 사용자의 ID. |
| ArticleCreatedDate | dateTime | Filter, Nillable, Sort | 아티클이 생성된 날짜. |
| ArticleMasterLanguage | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 아티클의 원본 언어. 다중 언어 지원 시만 접근 가능. |
| ArticleNumber | string | Autonumber, Defaulted on create, Filter, Sort | 자동 부여 고유 번호. 형식·값 변경 불가. |
| ArticleTotalViewCount | int | Filter, Group, Nillable, Sort | 아티클의 총 view 수. |
| AssignedById | reference | Filter, Group, Nillable, Sort | 아티클을 할당한 사용자의 ID. |
| AssignedToId | reference | Filter, Group, Nillable, Sort | 아티클이 할당된 사용자의 ID. |
| AssignmentDate | dateTime | Filter, Nillable, Sort | 아티클이 할당된 날짜. |
| AssignmentDueDate | dateTime | Filter, Nillable, Sort | 아티클 할당 시 마감일. |
| AssignmentNote | textarea | Filter, Nillable, Sort | assignee에게 남기는 노트. |
| ExternalRef | string | Filter, Group, Nillable, Sort | 외부 시스템에서 참조되는 항목의 ID. 예: Google Drive 문서 ID, Confluence 페이지. |
| ExternalSourceId | reference | Filter, Group, Nillable, Sort | 외부 Knowledge 데이터 소스 객체에 대한 reference. |
| ExternalUrl | url | Filter, Nillable, Sort | 외부 시스템에서 참조되는 knowledge 콘텐츠의 URL. |
| FirstPublishedDate | dateTime | Filter, Nillable, Sort | 처음 발행된 날짜. |
| IsExternalData | boolean | Defaulted on create, Filter, Group, Sort | 데이터가 고객의 knowledge base 외부에 있는지(true)/아닌지(false). |
| IsLatestVersion | boolean | Defaulted on create, Filter, Group, Sort | 최신 version인지(true)/아닌지(false). online/published version, 주 언어 draft, 번역 draft, 최신 archived version에서 true 가능. (PublishState='Online') AND (IsLatestVersion=false) 필터 불가. API v24.0+. |
| IsMasterLanguage | boolean | Defaulted on create, Filter, Group, Sort | 하나 이상의 번역이 연관되었는지(true)/아닌지(false). |
| IsOutOfDate | boolean | Defaulted on create, Filter, Group, Sort | 번역 생성 이후 source 아티클이 갱신되었는지(true)/아닌지(false). |
| IsVisibleInApp | boolean | Defaulted on create, Filter, Group, Sort | Required. Articles 탭 표시 여부. |
| IsVisibleInCsp | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Required. Customer Portal 표시 여부. |
| IsVisibleInPkb | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Required. public knowledge base 표시 여부. |
| IsVisibleInPrm | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Required. partner portal 표시 여부. |
| KnowledgeArticleId | reference | Filter, Group, Sort | version과 독립적인 아티클의 ID. KnowledgeArticle의 Id field에서 가져옴. |
| Language | picklist | Create, Filter, Group, Restricted picklist, Sort | 아티클 작성 언어. SOSL query/search 시 WHERE에 Language 지정, 모든 article type에 언어 동일. v47.0 이전 query 필터에 Language 포함 필요, v47.0+ 선택 가능. |
| LastPublishedDate | dateTime | Filter, Nillable, Sort | 마지막 발행 날짜. |
| MasterVersionId | reference | Filter, Group, Nillable, Sort | source 아티클의 번역인 경우 source 아티클 ID. 다중 언어 지원 시만 접근 가능. |
| MigratedToFromArticleVersion | string | Filter, Group, Nillable, Sort | 마이그레이션 전/후 대응 version ID. Classic→Lightning 마이그레이션 org에서만. API v43.0+. |
| NextReviewDate | dateTime | Filter, Nillable, Sort | 다음 정확성 검토 날짜. API v58.0+. |
| OwnerId | reference | Filter, Group, Sort | 아티클 소유자 ID. |
| PublishStatus | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | 발행 상태: **Draft** / **Online** / **Archived**. Online엔 "Manage Articles" 권한 필요. query/search는 WHERE에 PublishStatus 또는 Id 지정. 단일 SOSL query에서 article type당 하나의 발행 상태만. Archived 검색 시 IsLatestVersion=false도 확인. |
| RecordTypeId | reference | Create, Filter, Group, Nillable, Sort, Update | 아티클 유형을 기술하는 API Name. record type으로 아티클 구조·기타 설정을 결정. |
| SourceId | reference | Filter, Group, Nillable, Sort | 아티클이 생성된 source(Case 또는 Reply)의 ID. API에서만 접근 가능, UI에는 안 보임. |
| Summary | textarea | Create, Filter, Nillable, Sort, Update | 아티클 요약. 최대 1000자. |
| Title | string | Create, Defaulted on create, Filter, Group, idLookup, Sort, Update | Required. 아티클 제목. 최대 255자. |
| TranslationCompletedDate | dateTime | Filter, Nillable, Sort | 마지막 번역 일시. 다중 언어 지원 시만. |
| TranslationExportedDate | dateTime | Filter, Nillable, Sort | 마지막 번역 export 일시. 다중 언어 지원 시만. |
| TranslationImportedDate | dateTime | Filter, Nillable, Sort | 마지막 번역 import 일시. 다중 언어 지원 시만. |
| UrlName | string | Create, Filter, Group, idLookup, Sort, Update | Required. 아티클 URL. 영숫자·하이픈 가능, 하이픈 시작/종료 불가. 고유 값 사용. case-sensitive, 최대 255자. |
| ValidationStatus | picklist | Defaulted on create, Filter, Group | 검증 여부. Validated / Not Validated. 기본값 Not Validated. API v24.0+. |
| VersionNumber | int | Group, Sort | 아티클 version 번호. API v24.0+. |

---

## 6. Knowledge__ka (PDF p45–47) — API v39.0+

Knowledge 아티클(아티클 version의 부모)을 나타내는 concrete 객체. 기본 접두사 Knowledge는 Object Manager에서 변경 가능. 이 객체는 **KnowledgeArticle** 로부터 derived된다.

- **Supported Calls:** `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `undelete()`
- **Special Access Rules:** Lightning Knowledge 활성화 · View Articles 권한 · Knowledge User feature license.

| Field | Type | Properties | Description |
|---|---|---|---|
| ArchivedById | reference | Filter, Group, Nillable, Sort | 아티클을 archive한 사용자의 ID. |
| ArchivedDate | dateTime | Filter, Nillable, Sort | 아티클이 archive된 날짜. |
| ArticleNumber | string | Autonumber, Defaulted on create, Filter, idLookup, Sort | 자동 부여 고유 번호. 형식·값 변경 불가. |
| CaseAssociationCount | int | Filter, Group, Sort | 아티클에 첨부된 케이스 수. |
| FirstPublishedDate | dateTime | Filter, Nillable, Sort | 처음 발행된 날짜. |
| LastPublishedDate | dateTime | Filter, Nillable, Sort | 마지막 발행 날짜. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드/관련 레코드/list view에 마지막 접근한 timestamp. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 이 레코드/list view를 마지막으로 본 timestamp. null이면 접근만(LastReferencedDate) 하고 보지 않았을 수 있음. |
| MasterLanguage | picklist | Filter, Group, Restricted picklist, Sort | 아티클의 원본 언어. 다중 언어 지원 시만 접근 가능. |
| MigratedToFromArticle | string | Filter, Group, Nillable, Sort | 마이그레이션 전/후 대응 아티클 ID. Classic→Lightning 마이그레이션 org에서만. API v45.0+. |
| TotalViewCount | int | Filter, Group, Nillable, Sort | 이 아티클의 총 view 수. API v39.0+. |

---

## 관련 노트

- [[Knowledge 데이터 모델 & API 개요]]
- [[Knowledge SOAP API 객체 — 통계·연관·주변 객체]]
- [[Knowledge SOAP API 호출]]
- [[Knowledge REST API — Actions & Manage]]
- [[Knowledge Metadata API 타입 — 아티클·채널·설정]]
- [[SOQL WITH DATA CATEGORY]]
- [[SOSL 패턴]]
- [[Service Cloud Objects]]
