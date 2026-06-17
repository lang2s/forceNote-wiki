---
tags: [Service, Knowledge, 지식, REST-API, search, suggestions, support-API, autocomplete, data-category]
source: salesforce_knowledge_dev_guide.pdf (v67.0 Summer '26, Ch3 PDF p108–134)
created: 2026-06-17
aliases: [Knowledge search REST, parameterized search, suggestions resource, suggestTitleMatches, suggestSearchQueries, Support Knowledge REST, dataCategoryGroups REST, knowledgeArticles REST, articles list detail, 검색 자동완성 REST]
---

# Knowledge REST API — Search & Support

> Knowledge REST의 검색 계열 7개 리소스(Parameterized Search · Search · Search Scope and Order · Search Result Layouts · Suggestions · Suggest Title Matches · Suggest Search Queries)와 Support Knowledge 4개 리소스(Data Category Groups · Data Category Detail · Articles List · Articles Details)를 전수 정리한다. 아티클 관리·invocable action은 [[Knowledge REST API — Actions & Manage]] 참조.

> PDF 원문 예제 JSON/XML에는 표기 오류(잉여 `{`, 콤마 누락, `<?xml ?` 닫힘 누락, 곡선 따옴표, 외톨이 `:`, trailing 콤마 등)가 존재한다. 아래 코드 블록은 **PDF 원문 그대로 인용**하며, 정정하지 않았다.

---

## A. Search 계열

### S1 — Parameterized Search

SOSL 절 대신 parameter로 간단한 REST 검색을 실행한다. GET method로 URI에 parameter를 지정하거나, POST method로 request body에 복잡한 검색을 만든다. (별도 Syntax 블록은 PDF 본문에 없고 바로 Search로 이어진다.)

### S2 — Search

지정된 SOSL 검색을 실행한다. search string은 URL-encode되어야 한다. SOSL은 [[SOSL 패턴]] 참조.

- **URI:** `/services/data/vXX.X/search/?q=SOSL_searchString`
- **Formats:** JSON, XML — **HTTP Method:** GET — **Authentication:** `Authorization: Bearer token`

| Parameter | Description |
|---|---|
| `q` | 올바르게 URL-encode된 SOSL 문. |

**Example:** Search for a String 참조.

### S3 — Search Scope and Order

로그인 사용자의 기본 global search scope의 객체를 정렬된 목록으로 반환한다. global search는 사용자가 상호작용하는 객체와 빈도를 추적해 결과를 배열한다. 자주 쓰는 객체가 목록 상단에 온다. 반환 목록은 사용자의 기본 search scope의 객체 순서를 반영하며, 검색 결과 페이지에 고정(pin)된 객체도 포함한다. search string은 URL-encode되어야 한다.

- **URI:** `/services/data/vXX.X/search/scopeOrder`
- **Formats:** JSON, XML — **HTTP Method:** GET — **Authentication:** `Authorization: Bearer token`

**Example:** Get the Default Search Scope and Order 참조.

### S4 — Search Result Layouts

query string의 객체에 대한 검색 결과 layout 정보를 반환한다. 각 객체에 대해 결과 페이지에 컬럼으로 표시되는 field 목록, 첫 페이지 행 수, 결과 페이지 label을 반환. query당 최대 100개 객체의 bulk fetch를 지원.

- **URI:** `/services/data/vXX.X/search/layout/?q=commaDelimitedObjectList`
- **Formats:** JSON, XML — **HTTP Method:** GET — **Authentication:** `Authorization: Bearer token`

| Property | Type | Description |
|---|---|---|
| `field` | String | 점(.)으로 구분된 객체.field 이름. 예: `Account.Name`. |
| `format` | String | date field 유형(date only, date and time 등). date 관련 유형만 지정되고 아니면 null. |
| `label` | String | 사용자에게 보이는 이름. |
| `name` | String | API name. |

**Example:** Get Search Result Layouts for Objects 참조.

### S5 — Search for Records Suggested by Autocomplete and Instant Results

이름이 사용자 search string과 일치하는 추천 레코드 목록을 반환한다. suggestions 리소스는 사용자가 full search 전에 관련 레코드로 바로 이동하도록 autocomplete·instant result를 제공한다. **REST API v32.0+.**

레코드의 name field가 search string의 정확한 text를 포함할 때 반환된다. search string의 마지막 term은 단어 시작과 일치할 수 있다. 단어 안에 search string이 들어 있는 레코드는 일치로 간주되지 않는다.

> **Note:** 사용자 query에 따옴표나 wildcard가 포함되면 URI의 query string에서 자동 제거된다. 예: `national u`는 `national u*`로 처리되어 "National Utility", "National Urban Company", "First National University"를 반환한다.

표시 가능한 데이터를 반환하며, relevance 알고리즘이 결과 순서를 결정한다.

각 추천 레코드는 다음 요소를 담는다:

| Element | Description |
|---|---|
| Attributes | 레코드의 객체 유형과 접근 URL. 요청한 lookup field 값도 포함. 예: `fields=Id,Name` 요청 시 결과에 ID와 name 포함. |
| Name (or Title) | 레코드의 Name field. 표준 Name field가 없으면 다음 객체에 Title field 사용: Dashboard, Idea, IdeaTheme, Note, Question. Name/Title도 없으면 주 식별 field 사용(예: case는 Case Number). |
| Id | 레코드의 고유 식별자. |

suggestions 리소스는 다음을 **제외한** 모든 검색 가능 객체를 지원한다: ContentNote, Event, External objects, FeedComment, FeedPost, IdeaComment, Pricebook2, Reply, TagDefinition, Task.

- **URI:** `/services/data/vXX.X/search/suggestions?q=searchString&sobject=objectTypes`
- **Formats:** JSON, XML — **HTTP methods:** GET — **Authentication:** `Authorization: Bearer token`
- **Request body:** 불필요

| Parameter | Description |
|---|---|
| `fields` | Optional. lookup query 생성용. 쉼표 구분 list로 여러 field 지정. 응답에 반환할 lookup field 지정. |
| `dynamicFields` | Optional. API v48.0+. 추가 dynamic field 반환용. 쉼표 구분 list. 예: `dynamicFields=secondaryField`면 각 추천 레코드가 Id·Name(또는 Title) 외에 search layout의 다음 적격 field 기반 추가 field를 담음. |
| `groupId` | Optional. 반환할 question이 post된 group의 고유 식별자(들). 쉼표 구분 list. `type`이 `question`일 때만 적용. `userId`와 함께 쓰지 않음. |
| `ignoreUnsupportedSObjects` | Optional. 미지원 객체가 요청에 포함되면 취할 동작. false면 error 반환, true면 객체 무시·error 없음. 기본값 false. |
| `limit` | Optional. 반환 추천 레코드 최대 수. 미지정 시 기본 5개 반환. 한도 초과 시 응답 body의 `hasMoreResults`가 true. |
| `networkId` | Optional. 반환할 question의 Experience Cloud site 고유 식별자(들). 쉼표 구분 list. `type`이 `question`이거나 `sobject`가 `user`일 때만 적용. |
| `q` | Required. 올바르게 URL-encode된 사용자 query string. 최소 길이 충족 시에만 추천 반환: 중국어·일본어·한국어·태국어 1자, 그 외 언어 3자. 최대 길이 255자(공백 없는 연속 200자) 초과 시 error 반환. |
| `sobject` | Required. 검색 범위 객체(예: Account, offer__c). `feedItem`이면 `type` parameter가 Required이고 값이 `question`이어야 함. 쉼표 구분 list로 최대 10개 객체. 예: `sobject=Account,Contact,Lead`. 기능 활용을 위해 CrossObjectTypeahead 권한 활성화. 객체별 반환 field 지정 구문(sobject 소문자): `sobject=sobject.fields=fields`. 예: `&sobject=Account,Contact,Lead&account.fields=Website,Phone &contact.fields=Phone`. |
| `topicId` | Optional. 반환할 question에 태깅된 단일 topic의 고유 식별자. `type`이 `question`일 때만 적용. |
| `type` | `sobject`가 `feedItem`일 때 Required. 다른 sobject 값에는 영향 없음. Feed 유형이 question임을 지정. 유효 값: `question`. |
| `userId` | Optional. 반환할 question 작성자의 고유 식별자(들). 쉼표 구분 list. `type`이 `question`일 때만 적용. `groupId`와 함께 쓰지 않음. |
| `useSearchScope` | Optional. API v40.0+. 기본값 false. false면 요청 지정 객체로 추천. true면 요청 객체에 더해 사용자 search scope(가장 자주 쓰는 객체 목록)도 사용. • 요청에 객체 미지정 시 `useSearchScope=true` 사용. • true이고 search scope가 비면 기본 search scope 사용. • 보통 첫 10개 객체만 사용. 단 admin이 항상 고려되는 객체를 지정하면 최대 15개 사용. • `sobject` parameter 객체가 search scope 객체보다 우선. • `ignoreUnsupportedSObjects` 값은 search scope 객체에 적용 안 됨. 예: `.../search/suggestions?q=Acme&useSearchScope=true` / `.../search/suggestions?q=Acme&sobject=Account&useSearchScope=true`. |
| `where` | Optional. SOQL WHERE 절과 같은 구문의 filter. URL encode 필요. 객체별 또는 모든 호환 객체에 전역 적용. 객체별 예: `account.where=name%20LIKE%20%27Smith%25%27`. 전역 예: `where=name%20LIKE%20%27Smith%25%27`. parameter는 소문자. 객체별 where가 전역 where를 override. Question 객체에는 사용 불가. v38.0+. |

**`where` 멀티 엔티티 예제** (PDF 원문 그대로, 주석 포함):

```
...search/suggestions?q=Smith
&sobject=Account,Contact,KnowledgeArticleVersion,CollaborationGroup,Topic,FeedItem
// Specifies a global where clause (to filter Account and Contact)
&where=name%20LIKE%20%27Smith%25%27
// Overrides the global where clause for Knowledge Article (filtering by PublishStatus and Language is required for KnowledgeArticle)
&knowledgearticleversion.where=PublishStatus='online'+and+language='en_US'
// Overrides the global where clause for Topic
&topic.where=networkid=<1234567891>
// Overrides the global where clause for CollaborationGroup
&collaborationgroup.where=networkid=<1234567891>
// FeedItem-Question doesn't support where clauses, but we can filter the type and networkId
&type=question
&networkId==<1234567891>
```

**Example Response Body** (단일 객체 요청 — PDF 원문 그대로, 잉여 `{` 포함):

```json
{
"autoSuggestResults" : [ {
"attributes" : {
"type" : "Account",
"url" : "/services/data/v67.0/sobjects/Account/001xx000003DH6WAAW"
},
"Id" : "001xx000003DH6WAAW",
"Name" : "National Utility Service"
}, {
{
"attributes" : {
"type" : "Account",
"url" : "/services/data/v67.0/sobjects/Account/001xx000003DHJ4AAO"
},
"Id" : "001xx000003DHJ4AAO",
"Name" : "National Utility Service"
}, {
{
"attributes" : {
"type" : "Account",
"url" : "/services/data/v67.0/sobjects/Account/001xx000003DHscAAG"
},
"Id" : "001xx000003DHscAAG",
"Name" : "National Urban Technology Center"
} ],
"hasMoreResults" : false,
"meta" : {
"nameFields" : [ {
"entityApiName" : "Account",
"fieldApiName" : "Name"
} ],
"secondaryFields" : [ ]
}
}
```

**Example Response Body — Multiple Object Request** (PDF 원문 그대로, 콤마 누락·`001xx000003DLjvAAGO` 등 오타 포함):

```json
{
"autoSuggestResults" : [ {
"attributes" : {
"type" : "Account",
"url" : "/services/data/v67.0/sobjects/Account/001xx000003DMEKAA4"
},
"Id" : "001xx000003DMEKAA4"
"Name" : "Joe Doe Printing"
}, {
{
"attributes" : {
"type" : "Account",
"url" : "/services/data/v67.0/sobjects/Account/001xx000003DLjvAAG"
},
"Id" : "001xx000003DLjvAAGO"
"Name" : "Joe Doe Plumbing"
}, {
{
"attributes" : {
"type" : "Contact",
"url" : "/services/data/v67.0/sobjects/Contact/003xx000004U9Y9AAK"
},
"Id" : "003xx000004U9Y9AAK"
"Name" : "John Doe"
} ],
"hasMoreResults" : false,
"meta" : {
"nameFields" : [ {
"entityApiName" : "Account",
"fieldApiName" : "Name"
}, {
"entityApiName" : "Contact",
"fieldApiName" : "Name"
} ],
"secondaryFields" : [ ]
}
}
```

**Example XML Response Body** (PDF 원문 그대로, 첫 줄 닫힘 누락·곡선 따옴표 포함):

```xml
<?xml version=”1.0” encoding=”UTF-8”?
<suggestions>
<autoSuggestResults type="Account"
url="/services/data/v67.0/sobjects/Account/001xx000003DH6WAAW">
<Id>001xx000003DH6WAAW</Id>
<Name>National Utility Service</Name>
</autoSuggestResults>
<autoSuggestResults type="Account"
url="/services/data/v67.0/sobjects/Account/001xx000003DHJ4AAO">
<Id>001xx000003DHJ4AAO</Id>
<Name>National Utility Service</Name>
</autoSuggestResults>
<autoSuggestResults type="Account"
url="/services/data/v67.0/sobjects/Account/001xx000003DHscAAG">
<Id>001xx000003DHscAAG</Id>
<Name>National Urban Technology Center</Name>
</autoSuggestResults>
<hasMoreResults>true</hasMoreResults>
<meta>
<nameFields>
<entityApiName>Account</entityApiName>
<fieldApiName>Name</fieldApiName>
</nameFields>
<nameFields>
<entityApiName>ContentDocument</entityApiName>
<fieldApiName>Title</fieldApiName>
</nameFields>
</meta>
</suggestions>
```

### S6 — Search Suggested Article Title Matches

사용자 query string과 일치하는 Salesforce Knowledge 아티클 title 목록을 반환한다. full search 전에 관련 아티클로 바로 이동하는 단축 경로를 제공. **REST API v30.0+.**

Salesforce Knowledge가 활성화되고 사용자에게 "View Articles" 권한이 필요하다. 추천 아티클은 사용자가 data category·article type 권한으로 접근 가능한 것만 포함된다. title이 stopword(예: "a", "for", "the")를 제외한 전체 query string을 담을 때 추천된다. 예: `Backpacking for desert` 검색은 "Backpacking in the desert" 아티클을 반환.

> **Note:** stopword를 포함한 title(예: "Backpacking for desert survival")은 stopword 없는 일치 아티클보다 앞에 표시된다. query string 끝의 stopword는 search term으로 취급된다. query string의 마지막 token에는 wildcard가 자동 추가된다.

> **Note:** 따옴표·wildcard·기타 특수문자는 URI의 query string에서 자동 제거된다.

추천 수가 한도를 초과하면 응답 끝에 `hasMoreResults` field가 들어간다(부분집합이면 true, 아니면 false).

- **URI:** `/services/data/vXX.X/search/suggestTitleMatches?q=searchString&language=articleLanguage&publishStatus=articlePublicationStatus`
- **Formats:** JSON, XML — **HTTP methods:** GET — **Authentication:** `Authorization: Bearer token`
- **Request body:** 불필요

| Parameter | Description |
|---|---|
| `articleTypes` | Optional. 원하는 article type을 나타내는 3자리 ID 접두사. parameter 이름을 반복해 여러 값 지정 가능. 예: `articleTypes=ka0&articleTypes=ka1`. |
| `categories` | Optional. 원하는 아티클의 data category group 이름과 data category 이름을 JSON mapping으로. 여러 쌍 지정 가능. 예: `categories={"Regions":"Asia","Products":"Laptops"}`. URL 문자는 인코딩 필요할 수 있음. 예: `categories=%7B%22Regions%22%3A%22Asia%22%2C%22Products%22%3A%22Laptops%22%7D`. |
| `channel` | Optional. 일치 아티클이 보이는 채널. 유효 값: • `AllChannels`–접근 가능한 모든 채널 • `App`–internal Salesforce Knowledge 앱 • `Pkb`–public knowledge base • `Csp`–Customer Portal • `Prm`–Partner Portal. 미지정 시 기본값은 사용자 유형으로 결정: • guest=`Pkb` • Customer Portal=`Csp` • Partner Portal=`Prm` • 그 외=`App`. 지정 시 요건 때문에 실제 값이 다를 수 있음: • guest·Customer·Partner Portal 사용자는 지정 값이 사용자 유형의 기본값과 일치해야 함. 불일치하거나 `AllChannels`면 `App`로 대체. • 그 외 사용자: `Pkb`/`Csp`/`Prm`/`App` 지정 시 그 값 사용, `AllChannels` 지정 시 `App`로 대체. |
| `language` | Required. 사용자 query의 언어. 일치 아티클의 작성 언어를 지정. |
| `limit` | Optional. 반환 아티클 최대 수. 한도 초과 시 `hasMoreResults`가 true. |
| `publishStatus` | Required. 아티클의 발행 상태. 유효 값: • `Draft`–미발행 • `Online`–발행됨 • `Archived`–미발행, Archived Articles view에서 사용 가능. |
| `q` | Required. URL-encode된 query string. 최소 길이: 중국어·일본어·한국어 1자, 그 외 3자. 최대 250자 초과 시 error. |
| `topics` | Optional. 반환 아티클의 topic. 예: `topics=outlook&topics=email`. |
| `validationStatus` | Optional. 반환 아티클의 validation status. |

**Example Request:**

```
curl
https://MyDomainName.my.salesforce.com/services/data/v67.0/search/suggestTitleMatches?q=orange+banana&language=en_US&publishStatus=Online -H "Authorization: Bearer token"
```

**Example Response Body:**

```json
{
"autoSuggestResults" : [ {
"attributes" : {
"type" : "KnowledgeArticleVersion",
"url" : "/services/data/v67.0/sobjects/KnowledgeArticleVersion/ka0D00000004CcQ"
},
"Id" : "ka0D00000004CcQ",
"UrlName" : "orange-banana",
"Title" : "orange banana",
"KnowledgeArticleId" : "kA0D00000004Cfz"
} ],
"hasMoreResults" : false
}
```

### S7 — Search Suggested Queries

사용자 query string text가 다른 사용자가 Salesforce Knowledge에서 수행한 검색과 일치하는 추천 검색 목록을 반환한다. full search 전에 검색 효과를 개선하는 방법을 제공. **REST API v30.0+.** Salesforce Knowledge가 활성화되어야 한다.

query string text와 정확히 일치할 때 추천된다. text string은 query 내 prefix여야 하며 단어 안에 나타나면 일치로 보지 않는다. 예: `app`은 `apple banana`·`banana apples`는 반환하지만 `pineapple`은 반환하지 않는다. 추천 수가 한도를 초과하면 응답 끝에 `hasMoreResults`가 들어간다. 따옴표·wildcard는 URI에서 자동 제거된다.

- **URI:** `/services/data/vXX.X/search/suggestSearchQueries?q=searchString&language=languageOfQuery`
- **Formats:** JSON, XML — **HTTP methods:** GET — **Authentication:** `Authorization: Bearer token`
- **Request body:** 불필요

| Parameter | Description |
|---|---|
| `channel` | Optional. 아티클이 보이는 Salesforce Knowledge 채널. 유효 값: • `AllChannels` • `App` • `Pkb` • `Csp` • `Prm`. 미지정 시 기본값은 사용자 유형으로 결정(guest=`Pkb`, Customer Portal=`Csp`, Partner Portal=`Prm`, 그 외=`App`). 지정 시 처리 규칙은 S6 channel과 동일(guest·Customer·Partner Portal은 기본값과 일치해야 하며 불일치/AllChannels면 `App`로 대체; 그 외 사용자는 `Pkb`/`Csp`/`Prm`/`App` 지정값 사용, `AllChannels`는 `App`로 대체). |
| `language` | Required. 사용자 query의 언어. |
| `limit` | Optional. 반환 추천 검색 최대 수. 한도 초과 시 `hasMoreResults`가 true. |
| `q` | Required. URL-encode된 query string. 최소 길이: 중국어·일본어·한국어 1자, 그 외 3자. 최대 250자 초과 시 error. |

**Example Request:**

```
curl
https://MyDomainName.my.salesforce.com/services/data/v67.0/search/suggestSearchQueries?q=app&language=en_US -H "Authorization: Bearer token"
```

**Example Response Body** (PDF 원문 그대로, trailing 콤마 포함):

```json
{
"autoSuggestResults" : [ {
"0" : "apple",
"1" : "apple banana",
} ],
"hasMoreResults" : false
}
```

---

## B. Support Knowledge with REST API

Knowledge Support REST API는 인증·guest 사용자가 자신에게 보이는 data category와 연관 아티클을 조회하게 한다. **REST API v38.0+.**

- 인증 사용자: `UserProfile.apiEnabled` 권한, org에 Knowledge 활성화, article type에 read 권한, 그 외 아티클 visibility를 제어하는 knowledge 특정 권한/preference 필요.
- guest 사용자: 해당 Site에 *Guest Access to the Support API* preference 활성화, org에 Knowledge 활성화, article type과 article channel에 read 권한 필요.

- **URI:** `/services/data/vXX.X/support`
- **Method:** GET — **Formats:** JSON, XML — **Authentication:** `Authorization: Bearer token`

**Example Response Body** (PDF 원문 그대로, 외톨이 `:` 포함):

```json
{
"dataCategoryGroups" : "/services/data/vXX.X/support/dataCategoryGroups",
"knowledgeArticles" : "/services/data/vXX.X/support/knowledgeArticles"
:
}
```

리소스 목록: **Data Category Groups** · **Data Category Detail** · **Articles List** · **Articles Details** (모두 REST API v38.0+. Articles Details는 article URL name으로의 접근이 v44.0+).

### SK1 — Data Category Groups

현재 사용자에게 보이는 data category group을 가져온다. **REST API v38.0+.** Salesforce Knowledge가 활성화되어야 한다. 사용자에게 보이는 data category만 반환된다. 사용자가 group 내 여러 sub tree를 볼 수 있으므로, 각 group에서 사용자에게 보이는 top category가 반환된다.

- **URI:** `/services/data/vXX.X/support/dataCategoryGroups`
- **Method:** GET — **Formats:** JSON, XML — **Authentication:** `Authorization: Bearer token`

**HTTP headers:**
- `Accept`: Optional. `application/json` 또는 `application/xml`.
- `Accept-language`: Optional. category 번역 언어. ISO-639 언어 약어 + ISO-3166 국가 코드 subtag. 하나의 언어만 허용. 미지정 시 비번역 label 반환.

**Input:**
- `string sObjectName`: Required. `KnowledgeArticleVersion` 만.
- `boolean topCategoriesOnly`: Optional. 기본값 true. true면 top level category만, false면 전체 트리 반환.
- **Note:** 모든 input parameter는 case-sensitive.

**Output:** site context에서 현재 사용자에게 보이는 활성 data category group 목록. id, name, label, top level category(또는 전체 트리)를 반환. label은 가능하면 지정 언어로 번역.

- **Data Category Group List** — 활성 root Data Category Group 목록:

```json
{
"categoryGroups": [ Data Category Group, ....],
}
```
  - **Note:** `sObjectName`으로 주어진 entity에 연관된 활성 group만 반환. `KnowledgeArticleVersion`만 지원.

- **Data Category Group** — 개별 data category group과 root category:

```json
{
"name": String, // the unique name of the category group
"label": String, // returns the translated version if it is available
"objectUsage" : String, // currently only "KnowledgeArticleVersion" is available.
"topCategories": [ Data Category Summary, ....]
}
```

- **Data Category Summary** — data category 정보 요약:

```json
{
"name": String, // the unique name of the category
"label": String, // returns the translated version if it is available
"url": URL,     // the url points to the data category detail API
"childCategories": [ Data Category Summary, ....] // null if topCategoriesOnly is true
}
```
  - **Note:** URL 프로퍼티는 이 data category를 나타내는 고유 리소스에 대한 사전 계산 경로(Data Category Detail API).

**Example Request:**

```
curl
https://MyDomainName.my.salesforce.com/services/data/v67.0/support/dataCategoryGroups?sObjectName=KnowledgeArticleVersion
-H "Authorization: Bearer token"
```

**Example Response Body:**

```json
{
"categoryGroups" : [ {
"label" : "Doc",
"name" : "Doc",
"objectUsage" : "KnowledgeArticleVersion",
"topCategories" : [ {
"childCategories" : null,
"label" : "All",
"name" : "All",
"url" : "/services/data/v67.0/support/dataCategoryGroups/Doc/dataCategories/All?sObjectName=KnowledgeArticleVersion"
} ]
}, {
"label" : "Manual",
"name" : "Manual",
"objectUsage" : "KnowledgeArticleVersion",
"topCategories" : [ {
"childCategories" : null,
"label" : "All",
"name" : "All",
"url" : "/services/data/v67.0/support/dataCategoryGroups/Manual/dataCategories/All?sObjectName=KnowledgeArticleVersion"
} ]
} ]
}
```

### SK2 — Data Category Detail

주어진 category의 data category 상세와 child category를 가져온다. **API v38.0+.** Salesforce Knowledge가 활성화되어야 한다.

- **URI:** `/services/data/vXX.X/support/dataCategoryGroups/group/dataCategories/category`
- **Method:** GET — **Formats:** JSON, XML — **Authentication:** `Authorization: Bearer token`

**HTTP headers:**
- `Accept`: Optional. `application/json` 또는 `application/xml`.
- `Accept-language`: Optional. category 번역 언어. ISO-639 + ISO-3166. 하나의 언어만. 미지정 시 비번역 label.

**Input:** `string sObjectName`: Required. `KnowledgeArticleVersion` 만.

**Output:** category 상세와 child category 목록(name, label 등).

- **Data Category Detail** — data category의 계층 표현이 중요할 때 사용. child 프로퍼티가 child data category 목록을 담음:

```json
{
"name": String, // the unique name of the category
"label": String, // returns the translated version if it is available
"url": URL,
"childCategories": [ Data Category Summary, ....],
}
```
  - **Note:** category가 현재 사용자에게 보이지 않으면 반환은 empty.

**Example Request:**

```
curl
https://MyDomainName.my.salesforce.com/services/data/v67.0/support/dataCategoryGroups/Doc/dataCategories/All?sObjectName=KnowledgeArticleVersion
-H "Authorization: Bearer token"
```

**Example Response Body:**

```json
{
"childCategories" : [ {
"childCategories" : null,
"label" : "Help",
"name" : "Help",
"url" : "/services/data/v67.0/support/dataCategoryGroups/Doc/dataCategories/Help?sObjectName=KnowledgeArticleVersion"
}, {
"childCategories" : null,
"label" : "QA",
"name" : "QA",
"url" : "/services/data/v67.0/support/dataCategoryGroups/Doc/dataCategories/QA?sObjectName=KnowledgeArticleVersion"
} ],
"label" : "All",
"name" : "All",
"url" : "/services/data/v67.0/support/dataCategoryGroups/Doc/dataCategories/All?sObjectName=KnowledgeArticleVersion"
}
```

### SK3 — Articles List

주어진 언어·category의 online 아티클 한 페이지를 search 또는 query로 가져온다. **REST API v38.0+.**

- **URI:** `/services/data/vXX.X/support/knowledgeArticles`
- **Method:** GET — **Formats:** JSON, XML — **Authentication:** `Authorization: Bearer token`

**HTTP headers:**
- `Accept`: Optional. `application/json` 또는 `application/xml`.
- `Accept-language`: Required. 아티클은 사용자 org의 활성 언어여야 함. • 언어 코드가 유효하지 않으면: "The language code is not valid or not supported by Knowledge." • 유효하나 Knowledge가 지원 안 하면: "Invalid language code. Check that the language is included in your Knowledge language settings."

**Input:**
- `string q`: Optional. SOSL 검색 수행. query string이 null·empty·미지정이면 SOQL query 실행. `?`·`*`는 wildcard, `(`·`)`·`"`는 복합 search term에 사용.
- `string channel`: Optional, 기본값은 사용자 context. • `App`–internal 앱 • `Pkb`–public KB • `Csp`–Customer Portal • `Prm`–Partner Portal.
- `string categories` (map json `{"group1":"category1","group2":"category2",...}`): Optional, 기본값 None. group:category 쌍에서 category group이 고유해야 함, 아니면 `ARGUMENT_OBJECT_PARSE_ERROR`. data category 조건은 3개 한도, 초과 시 `INVALID_FILTER_VALUE`.
- `string queryMethod` 값: `AT`, `BELOW`, `ABOVE`, `ABOVE_OR_BELOW`. categories 지정 시에만 유효, 기본값 `ABOVE_OR_BELOW`.
- `string sort`: Optional. sortable field `LastPublishedDate`, `CreatedDate`, `Title`, `ViewScore`. 기본값은 query에 `LastPublishedDate`, search에 relevance.
  - **Note:** `ViewScore` 정렬은 query에만 가능(search 불가)하며 pagination 미지원. 결과 한 페이지만 받음.
- `string order`: Optional. `ASC` 또는 `DESC`, 기본값 `DESC`. sort 유효 시에만 유효.
- `integer pageSize`: Optional, 기본값 20. 유효 범위 1~100.
- `integer pageNumber`: Optional, 기본값 1.

**Output:** 주어진 언어·category에서 현재 사용자에게 보이는 online 아티클 한 페이지.

- **Article Page** — 아티클 한 페이지. 개별 항목은 article summary라 크기를 최소화:

```json
{
"articles": [ Article Summary, … ], // list of articles
"currentPageUrl": URL,    // the article list API with current page number
"nextPageUrl": URL,       // the article list API with next page number, which can be null if there are no more articles.
"pageNumber": Int         // the current page number, starting at 1.
}
```
  - **Note:** paging 지원. 각 응답 페이지는 자기 페이지 URL과 다음 페이지 URL을 포함.
  - **Note:** input parameter가 기본값이면 `currentPageUrl`·`nextPageUrl`에 표시 안 됨.

- **Article Summary** — 응답 list의 article 요약(Article Detail의 부분집합):

```json
{
"id": Id,    // articleId
"articleNumber": String,
"articleType": String, // apiName of the article type, available in API v44.0 and later
"title": String,
"urlName": String, // available in API v44.0 and later
"summary": String,
"url": URL, // to the Article Detail API
"viewCount": Int,    // view count in the interested channel
"viewScore": double (in xxx.xxxx precision),    // view score in the interested channel.
"upVoteCount": int, // up vote count in the interested channel.
"downVoteCount": int, // down vote count in the interested channel.
"lastPublishedDate": Date // last publish date in ISO8601 format
"categoryGroups": [ Data Category Group, …. ]}
```
  - "url" 프로퍼티는 항상 Article Details 리소스 엔드포인트를 가리킴.

- **Data Category Group** — 개별 data category group, root category, 선택된 data category 목록:

```json
{
"groupName": String, // the unique name of the category group
"groupLabel": String, // returns the translated version
"selectedCategories": [ Data Category Summary, … ]
}
```

- **Data Category Summary** — data category 정보 요약:

```json
{
"categoryName": String, // the unique name of the category
"categoryLabel": String, // returns the translated version, per the API language specified
"url": String // returns the url for the DataCategory REST API.
}
```
  - **Note:** Article List API의 Data Category Group·Data Category Summary 출력은 Data Category Groups API와 다르다.

**Example Request:**

```
curl
https://MyDomainName.my.salesforce.com/services/data/v67.0/support/knowledgeArticles?sort=ViewScore&channel=Pkb&pageSize=3
HTTP Headers:
Content-Type: application/json; charset=UTF-8
Accept: application/json
Accept-Language: en-US
```

**Example Response Body:**

```json
{
"articles" : [ {
"articleNumber" : "000001002",
"categoryGroups" : [ ],
"downVoteCount" : 0,
"id" : "kA0xx000000000BCAQ",
"lastPublishedDate" : "2015-02-25T02:07:18Z",
"summary" : "With this online Chinese input tool, you can type Chinese characters through your web browser without installing any Chinese input software in your system. The Chinese online input tool uses the popular Pin Yin input method. It is a fast and convenient tool to input Chinese on English OS environments.",
"title" : "Long text test",
"upVoteCount" : 0,
"url" : "/services/data/v67.0/support/knowledgeArticles/kA0xx000000000BCAQ",
"viewCount" : 4,
"viewScore" : 100.0
}, {
"articleNumber" : "000001004",
"categoryGroups" : [ ],
"downVoteCount" : 0,
"id" : "kA0xx000000000LCAQ",
"lastPublishedDate" : "2016-06-21T21:11:02Z",
"summary" : "The number of characters required for complete coverage of all these languages' needs cannot fit in the 256-character code space of 8-bit character encodings, requiring at least a 16-bit fixed width encoding or multi-byte variable-length encodings.\r\n\r\nAlthough CJK encodings have common character sets, the encodings often used to represent them have been developed separately by different East Asian governments and software companies, and are mutually incompatible. Unicode has attempted, with some controversy, to unify the character sets in a process known as Han unification.\r\n\r\nCJK character encodings should consist minimally of Han characters p",
"title" : "Test Images",
"upVoteCount" : 0,
"url" : "/services/data/v67.0/support/knowledgeArticles/kA0xx000000000LCAQ",
"viewCount" : 0,
"viewScore" : 0.0
}, {
"articleNumber" : "000001012",
"categoryGroups" : [ ],
"downVoteCount" : 0,
"id" : "kA0xx000000006GCAQ",
"lastPublishedDate" : "2016-06-21T21:10:48Z",
"summary" : null,
"title" : "Test Draft 2",
"upVoteCount" : 0,
"url" : "/services/data/v67.0/support/knowledgeArticles/kA0xx000000006GCAQ",
"viewCount" : 0,
"viewScore" : 0.0
} ],
"currentPageUrl" : "/services/data/v67.0/support/knowledgeArticles?channel=Pkb&amp;pageSize=3&amp;sort=ViewScore",
"nextPageUrl" : null,
"pageNumber" : 1
}
```

**Usage:** Salesforce Knowledge가 활성화되어야 한다. API v38.0+에서 사용 가능. Custom File Field는 binary stream 링크를 반환하므로 미지원.

**Valid channel Values:**
- 옵션 string `channel`에서 일치 아티클이 보이는 곳:
  - `App`–internal Salesforce Knowledge 앱 / `Pkb`–public knowledge base / `Csp`–Customer Portal / `Prm`–Partner Portal.
- 미지정 시 기본값은 사용자 유형으로 결정: guest=`Pkb`, Customer Portal=`Csp`, Partner Portal=`Prm`, 그 외=`App`.
- 지정 시 그 값으로 아티클을 가져올 수 있음:
  - guest·Customer·Partner Portal 사용자는 사용자에게 접근 가능한 채널 외의 채널을 지정하면 error 반환.
  - 그 외 사용자는 지정 채널 값 사용.

### SK4 — Articles Details

사용자가 접근 가능한 모든 online 아티클 field를 가져온다. **article ID로는 REST API v38.0+, article URL name으로는 v44.0+.** Salesforce Knowledge가 활성화되어야 한다. Custom File Field는 미지원.

**Guest user 가시성 제한:** lookup custom field는 lookup entity 유형에 따라 guest에게 보인다(예: User는 보이지만 Case·Account는 안 보임). 다음 표준 field는 layout에 있어도 guest에게 보이지 않는다: `archivedBy`, `isLatestVersion`, `translationCompletedDate`, `translationImportedDate`, `translationExportedDate`, `versionNumber`, `visibleInInternalApp`, `visibleInPKB`, `visibleToCustomer`, `visbileToPartner` *(PDF 원문 오타 "visbile" 그대로)*.

**Valid channel Values:** SK3와 동일(App/Pkb/Csp/Prm, 사용자 유형별 기본값, 지정값 처리 규칙 동일).

- **Method:** GET — **Formats:** JSON, XML — **Authentication:** `Authorization: Bearer token`
- **Endpoint:** `/services/data/vXX.X/support/knowledgeArticles/articleId_or_articleUrlName`

**HTTP headers:**
- `Accept`: Optional. `application/json` 또는 `application/xml`.
- `Accept-language`: Required. 아티클은 사용자 org의 활성 언어여야 함(오류 메시지는 SK3와 동일).

**Input:**
- `string channel`: Optional, 기본값 사용자 context. (App/Pkb/Csp/Prm)
- `boolean updateViewStat`: Optional, 기본값 true. true면 해당 채널 view count와 total view count를 갱신.
- `boolean isUrlName`: Optional, 기본값 false. true면 엔드포인트 마지막 부분이 article ID가 아닌 URL name임을 표시. API v44.0+.

**Output:** 아티클이 online이고 현재 사용자에게 보이면 아티클의 상세 field.

- **Article Detail** — 아티클의 전체 상세(완전한 metadata와 layout 기반 표시 field). Article Summary의 모든 프로퍼티를 포함:

```json
{
"id": Id,    // articleId,
"articleNumber": String,
"articleType": String, // apiName of the article type, available in API v44.0 and later
"title": String,
"urlName": String,    // available in API v44.0 and later
"summary": String,
"url": URL,
"versionNumber": Int,
"createdDate": Date, // in ISO8601 format
"createdBy": User Summary on page 126,
"lastModifiedDate": Date,    // in ISO8601 format
"lastModifiedBy": User Summary on page 126,
"lastPublishedDate": Date, // in ISO8601 format
"layoutItems": [ Article Field, ... ], // standard and custom fields visible to the user, sorted based on the layouts of the article type.
"categories": [ Data Category Groups, ... ],
"appUpVoteCount": Int,
"cspUpVoteCount": Int,
"prmUpVoteCount": Int,
"pkbUpVoteCount": Int,
"appDownVoteCount": Int,
"cspDownVoteCount": Int,
"prmDownVoteCount": Int,
"pkbDownVoteCount": Int,
"allViewCount": Int,
"appViewCount": Int,
"cspViewCount": Int,
"prmViewCount": Int,
"pkbViewCount": Int,
"allViewScore": Double,
"appViewScore": Double,
"cspViewScore": Double,
"prmViewScore": Double,
"pkbViewScore": Double
}
```

- **User Summary:**

```json
{
"id": String
"isActive": boolean    // true/false
"userName": String    // login name
"firstName": String
"lastName": String
"email": String
"url": String    // to the chatter user detail url: /services/data/vXX.X/chatter/users/{userId}, for guest user, it will return null.
}
```

- **Article Field** — 관리자 layout이 요구하는 순서로 Article Detail에 나열되는 개별 아티클 field:

```json
{
"type": Enum,    // see the Notes
"name": String,    // In API v43.0 and earlier, the developer name. In API v44.0 and later, the API name.
"label": String,    // label
"value": String,
}
```

**Example Request:**

```
curl
https://MyDomainName.my.salesforce.com/services/data/v67.0/support/knowledgeArticles/kA0xx000000000LCAQ
HTTP Headers:
Content-Type: application/json; charset=UTF-8
Accept: application/json
Accept-Language: en-US
```

**Example Response Body:**

```json
{
"allViewCount" : 17,
"allViewScore" : 100.0,
"appDownVoteCount" : 0,
"appUpVoteCount" : 0,
"appViewCount" : 17,
"appViewScore" : 100.0,
"articleNumber" : "000001004",
"categoryGroups" : [ ],
"createdBy" : {
"email" : "user@company.com",
"firstName" : "Test",
"id" : "005xx000001SvoMAAS",
"isActive" : true,
"lastName" : "User",
"url" : "/services/data/v67.0/chatter/users/005xx000001SvoMAAS",
"userName" : "admin@salesforce.org"
},
"createdDate" : "2016-06-21T21:10:54Z",
"cspDownVoteCount" : 0,
"cspUpVoteCount" : 0,
"cspViewCount" : 0,
"cspViewScore" : 0.0,
"id" : "kA0xx000000000LCAQ",
"lastModifiedBy" : {
"email" : "user@company.com",
"firstName" : "Test",
"id" : "005xx000001SvoMAAS",
"isActive" : true,
"lastName" : "User",
"url" : "/services/data/v67.0/chatter/users/005xx000001SvoMAAS",
"userName" : "admin@salesforce.org"
},
"lastModifiedDate" : "2016-06-21T21:11:02Z",
"lastPublishedDate" : "2016-06-21T21:11:02Z",
"layoutItems" : [ {
"label" : "Out of Date",
"name" : "IsOutOfDate",
"type" : "CHECKBOX",
"value" : "false"
}, {
"label" : "sample",
"name" : "sample",
"type" : "PICK_LIST",
"value" : null
}, {
"label" : "Language",
"name" : "Language",
"type" : "PICK_LIST",
"value" : "en_US"
}, {
"label" : "MyNumber",
"name" : "MyNumber",
"type" : "NUMBER",
"value" : null
}, {
"label" : "My File",
"name" : "My_File",
"type" : "FILE",
"value" : null
} ],
"pkbDownVoteCount" : 0,
"pkbUpVoteCount" : 0,
"pkbViewCount" : 0,
"pkbViewScore" : 0.0,
"prmDownVoteCount" : 0,
"prmUpVoteCount" : 0,
"prmViewCount" : 0,
"prmViewScore" : 0.0,
"summary" : "The number of characters required for complete coverage of all these languages' needs cannot fit in the 256-character code space of 8-bit character encodings, requiring at least a 16-bit fixed width encoding or multi-byte variable-length encodings.\r\n\r\nAlthough CJK encodings have common character sets, the encodings often used to represent them have been developed separately by different East Asian governments and software companies, and are mutually incompatible. Unicode has attempted, with some controversy, to unify the character sets in a process known as Han unification.\r\n\r\nCJK character encodings should consist minimally of Han characters p",
"title" : "Test Images",
"url" : "/services/data/v67.0/support/knowledgeArticles/kA0xx000000000LCAQ",
"versionNumber" : 7
}
```

> PDF 인쇄 p128에 "Usage" 헤더가 있으나 바로 Chapter 4가 시작되어 본문 콘텐츠가 비어 있다(원문에 Usage 본문 없음).

---

## 관련 노트

- [[Knowledge 데이터 모델 & API 개요]]
- [[Knowledge REST API — Actions & Manage]]
- [[Knowledge SOAP API 호출]]
- [[Knowledge Metadata API 타입 — 데이터카테고리·검색·외부소스]]
- [[REST API]]
- [[SOSL 패턴]]
