---
tags: [Service, Knowledge, 지식, REST-API, invocable-action, knowledgeManagement, 아티클관리, 발행, 번역]
source: salesforce_knowledge_dev_guide.pdf (v67.0 Summer '26, Ch3 PDF p81–108)
created: 2026-06-17
aliases: [Knowledge Actions, invocable actions Knowledge, archiveKnowledgeArticles, publishKnowledgeArticles, assignKnowledgeArticles, knowledgeManagement REST, Manage Knowledge REST API, masterVersions, translations, Knowledge 아티클 발행 REST]
---

# Knowledge REST API — Actions & Manage

> Lightning Knowledge용 invocable action 8종과 knowledgeManagement REST 리소스 19종으로 아티클·번역을 관리한다. 검색·Support REST는 [[Knowledge REST API — Search & Support]] 참조. REST API는 SOAP API와 동일한 데이터 모델·표준 객체를 쓴다.

---

## A. Invocable Actions for Lightning Knowledge (Knowledge Actions)

Lightning Knowledge의 action을 REST 엔드포인트에서 invoke해 아티클·아티클 version을 관리한다. invocable action 일반은 [[Actions API]] 참조.

> **Important:** 가능한 경우 Equality 가치에 맞춰 noninclusive 용어를 변경했다. 고객 구현에 영향을 주지 않기 위해 일부 용어는 유지했다.

- **버전:** **Assign**·**Publish** action은 API v44.0+, 나머지 action은 API v45.0+.
- Lightning Knowledge가 org에 설정되어야 하고, 사용자에게 아티클 관리 권한이 필요하다.
- invocable action에 여러 input을 쓸 수 있다. `restoreKnowledgeArticleVersion`처럼 list를 받지 않는 action에 유용하다.

### 공통 사양

- **Formats:** JSON, XML
- **HTTP Methods:** GET, HEAD, POST
- **Authentication:** `Authorization: Bearer token`
- **Other Information:** Error Response Types (아래 참조)

### URI 목록

| Action | URI |
|---|---|
| Archive Knowledge articles | `/services/data/vXX.X/actions/standard/archiveKnowledgeArticles` |
| Assign Knowledge articles | `/services/data/vXX.X/actions/standard/assignKnowledgeArticles` |
| Create draft from online Knowledge articles | `/services/data/vXX.X/actions/standard/createDraftFromOnlineKnowledgeArticle` |
| Delete Knowledge articles | `/services/data/vXX.X/actions/standard/deleteKnowledgeArticles` |
| Publish Knowledge articles | `/services/data/vXX.X/actions/standard/publishKnowledgeArticles` |
| Restore Knowledge article version | `/services/data/vXX.X/actions/standard/restoreKnowledgeArticleVersion` |
| Retrieve Smart Link URL | `/services/data/vXX.X/actions/standard/getArticleSmartLinkUrl` |
| Submit Knowledge article for translation | `/services/data/vXX.X/actions/standard/submitKnowledgeArticleForTranslation` |

---

### Action 1 — Archive Knowledge Articles

URI: `/services/data/vXX.X/actions/standard/archiveKnowledgeArticles`

| Input | Type | Description |
|---|---|---|
| `articleVersionIdList` | string | Required. 쉼표 구분 article version ID 목록. |

**Sample Input** (두 아티클 archive):

```json
{
"inputs" : [
{
"articleVersionIdList" : [ "ka0RM00000004VeYAI", "ka0RM00000003doYAA" ]
}
]
}
```

**Sample Output** (성공):

```json
[ {
"actionName" : "archiveKnowledgeArticles",
"errors" : null,
"isSuccess" : true,
"outputValues" : {
"ka0RM00000004Ve" : "Success",
"ka0RM00000003do" : "Success"
}
} ]
```

**Sample Output** (하나 성공·하나 실패):

```json
[ {
"actionName" : "archiveKnowledgeArticles",
"errors" : null,
"isSuccess" : false,
"outputValues" : {
"ka0RM00000004Ve" : "You can't perform this action. Be sure the action is valid for the current state of the article, and that you have permission to perform it.",
"ka0RM00000003do" : "Success"
}
} ]
```

---

### Action 2 — Assign Knowledge Articles

URI: `/services/data/vXX.X/actions/standard/assignKnowledgeArticles`

| Input | Type | Description |
|---|---|---|
| `articleVersionIdList` | string | Required. 쉼표 구분 article version ID 목록. |
| `assigneeId` | ID | Required. 할당 사용자 ID. |
| `assignAction` | string | Required. 할당 action. 유효 값: `ASSIGN_DRAFT_MASTER`, `ASSIGN_DRAFT_TRANSLATION` |
| `dueDate` | string | Optional. 할당 마감일. |
| `instruction` | string | Optional. assignee를 위한 지시사항. |
| `sendEmailNotification` | boolean | Optional. email 알림 전송 여부. 기본값 false. |

**Sample Input** (두 아티클을 번역에 할당):

```json
{
"inputs" : [
{
"articleVersionIdList" : [ "ka0RM00000004VeYAI", "ka0RM00000003doYAA" ]
"assigneeId" : "005RM00000AAAAAYA4",
"assignAction" : "ASSIGN_DRAFT_TRANSLATION"
}
]
}
```

**Sample Output:**

```json
[ {
"actionName" : "assignKnowledgeArticles",
"errors" : null,
"isSuccess" : true,
"outputValues" : {
"ka0RM00000004Ve" : "Success",
"ka0RM00000003do" : "Success"
}
} ]
```

---

### Action 3 — Create Draft from Online Knowledge Article

URI: `/services/data/vXX.X/actions/standard/createDraftFromOnlineKnowledgeArticle`

| Input | Type | Description |
|---|---|---|
| `action` | string | Required. primary 또는 translation 아티클의 edit action. 유효 값: `EDIT_AS_DRAFT_ARTICLE`, `EDIT_AS_DRAFT_TRANSLATION` |
| `unpublish` | boolean | Required. 아티클을 published 유지(false)할지 published 아티클을 archive(true)할지. false면 현재 online version을 유지하며 draft 생성. true면 현재 online version을 archive(knowledge base에서 제거)하고 draft 생성. |
| `articleVersionId` | string | online(published) translation에서 draft를 만들 때 Required. Article ID가 제공되면 online primary article에서 draft를 만들 때 Optional. |
| `articleId` | string | Article Version ID가 없을 때, online(published) primary article에서 draft를 만들 때 Required. |

**Sample Input** (primary article에서 draft 생성 + 원본 archive):

```json
{
"inputs" : [
{
"action" : "EDIT_AS_DRAFT_ARTICLE",
"unpublish" : true,
"articleId" : "kA0RM00000004pP0AQ"
}
]
}
```

**Sample Output:**

```json
[ {
"actionName" : "createDraftFromOnlineKnowledgeArticle",
"errors" : null,
"isSuccess" : true,
"outputValues" : {
"kA0RM00000004pP0AQ" : "Success"
}
} ]
```

---

### Action 4 — Delete Knowledge Articles

URI: `/services/data/vXX.X/actions/standard/deleteKnowledgeArticles`

| Input | Type | Description |
|---|---|---|
| `articleVersionIdList` | string | Required. 쉼표 구분 article version ID 목록. |

**Sample Input** (두 아티클 삭제):

```json
{
"inputs" : [
{
"articleVersionIdList" : [ "ka0RM00000004VeYAI", "ka0RM00000003doYAA" ]
}
]
}
```

**Sample Output:**

```json
[ {
"actionName" : "deleteKnowledgeArticles",
"errors" : null,
"isSuccess" : true,
"outputValues" : {
"ka0RM00000004Ve" : "Success",
"ka0RM00000003do" : "Success"
}
} ]
```

---

### Action 5 — Publish Knowledge Articles

URI: `/services/data/vXX.X/actions/standard/publishKnowledgeArticles`

| Input | Type | Description |
|---|---|---|
| `articleVersionIdList` | string | Required. 쉼표 구분 article version ID 목록. |
| `pubAction` | string | Required. 발행 action. 유효 값: `PUBLISH_ARTICLE`(최신 version을 대체), `PUBLISH_ARTICLE_NEW_VERSION`(새 version 생성), `SCHEDULE_ARTICLE_FOR_PUBLICATION`, `PUBLISH_TRANSLATION` |
| `pubDate` | string | Optional. ISO 8601 형식 `yyyy-MM-dd\'T\'HH:mm:ss.SSSZ`의 예약 발행 날짜. 예: 2023년 2월 8일 13:40 UTC+01:00 → `2023-02-08T13:40:00.000+0100`. |

**Sample Input** (두 아티클 발행):

```json
{
"inputs" : [
{
"articleVersionIdList" : [ "ka0RM00000004VeYAI", "ka0RM00000003doYAA" ],
"pubAction" : "PUBLISH_ARTICLE"
}
]
}
```

**Sample Output:**

```json
[ {
"actionName" : "publishKnowledgeArticles",
"errors" : null,
"isSuccess" : true,
"outputValues" : {
"ka0RM00000004Ve" : "Success",
"ka0RM00000003do" : "Success"
}
} ]
```

---

### Action 6 — Restore Knowledge Article Version

URI: `/services/data/vXX.X/actions/standard/restoreKnowledgeArticleVersion`

| Input | Type | Description |
|---|---|---|
| `action` | string | Required. 유일한 유효 action: `RESTORE_KNOWLEDGE_ARTICLE_VERSION` |
| `articleId` | string | Required. Article ID. |
| `versionNumber` | integer | Optional. 복원할 archived article version 번호. 기본값은 최신 archived version. |

**Sample Input** (최신 archived version 복원):

```json
{
"inputs" : [
{
"action" : "RESTORE_KNOWLEDGE_ARTICLE_VERSION",
"articleId" : "kA0RM00000004pP0AQ"
}
]
}
```

**Sample Input** (published 아티클의 과거 archived version 복원):

```json
{
"inputs" : [
{
"action" : "RESTORE_KNOWLEDGE_ARTICLE_VERSION",
"versionNumber":3,
"articleId" : "kA0RM00000004pP0AQ"
}
]
}
```

**Sample Input** (두 archived 아티클 복원):

```json
{
"inputs" : [
{
"action" : "RESTORE_KNOWLEDGE_ARTICLE_VERSION",
"articleId" : "kA0RM00000004pP0AQ"
},
{
"action" : "RESTORE_KNOWLEDGE_ARTICLE_VERSION",
"articleId" : "kA0RM00000004pP0AB"
}
]
}
```

**Sample Output:**

```json
[ {
"actionName" : "restoreKnowledgeArticleVersion",
"errors" : null,
"isSuccess" : true,
"outputValues" : {
"kA0RM00000004pP0AQ" : "Success"
}
} ]
```

---

### Action 7 — Retrieve Smart Link URL

URI: `/services/data/vXX.X/actions/standard/getArticleSmartLinkUrl`

| Input | Type | Description |
|---|---|---|
| `articleVersionId` | string | Required. Knowledge article version의 ID. |

**Sample Input:**

```json
{
"inputs":[
{
"articleVersionId":"ka0xx00000000cjAAA"
}
]
}
```

**Sample Output:**

```json
[
{
"actionName":"getArticleSmartLinkUrl",
"errors":null,
"isSuccess":true,
"outputValues":{
"articleSmartLinkUrl":"https://example.lightning.force.com/lightning/articles/Knowledge/Test-Redirection-1"
}
}
]
```

---

### Action 8 — Submit Knowledge Article for Translation

URI: `/services/data/vXX.X/actions/standard/submitKnowledgeArticleForTranslation`

**Inputs:**

| Input | Type | Description |
|---|---|---|
| `articleId` | string | Required. Article ID. |
| `language` | string | Required. 번역용 언어 코드. |
| `assigneeId` | ID | Required. 할당 사용자 ID. |
| `dueDate` | string | Optional. 할당 마감일. |
| `sendEmailNotification` | boolean | Optional. email 알림 전송 여부. 기본값 false. |

**Outputs:**

| Output | Type | Description |
|---|---|---|
| `articleId` | ID | Article ID. |
| `language` | string | 번역용 언어 코드. |

**Sample Input** (한 아티클을 스페인어로 번역 제출):

```json
{
"inputs" : [
{
"articleId" : "kA0RM00000004pP0AQ",
"language" : "es",
"assigneeId" : "005RM00000AAAAAYA4"
}
]
}
```

**Sample Output:**

```json
[ {
"actionName" : "submitKnowledgeArticleForTranslation",
"errors" : null,
"isSuccess" : true,
"outputValues" : {
"articleId" : "kA0RM00000004pP0AQ",
"language" : "es"
}
} ]
```

---

### Error Response Types

Knowledge action은 두 종류의 오류 응답을 낸다: **action-scoped error** 와 **item-scoped error**.

**Action-scoped error** — action 전체에 대한 오류. `message` 외에 `statusCode`를 가진다. 예(잘못된 input 값 전송):

```json
[ {
"actionName" : "restoreKnowledgeArticleVersion",
"errors" : [ {
"statusCode" : "INVALID_API_INPUT",
"message" : "You can't perform this action. Be sure the action is valid for the current state of the article, and that you have permission to perform it.",
"fields" : [ ]
} ],
"isSuccess" : false,
"outputValues" : null
} ]
```

**Item-scoped error** — action 내 특정 아티클/version의 문제. 예(`archiveKnowledgeArticles`에서 한 item 실패·한 item 성공):

```json
[ {
"actionName" : "archiveKnowledgeArticles",
"errors" : null,
"isSuccess" : false,
"outputValues" : {
"ka0RM00000004Ve" : "You can't perform this action. Be sure the action is valid for the current state of the article, and that you have permission to perform it.",
"ka0RM00000003do" : "Success"
}
} ]
```

어떤 종류든 오류가 발생하면 `isSuccess` field는 false다.

---

## B. Manage Knowledge with REST APIs

knowledgeManagement REST 리소스는 knowledge base·아티클·번역에 대해 수행할 수 있는 여러 동작에 프로그래밍 방식 접근을 제공한다. (M1–M19)

> 아래 리소스의 URI 버전 토큰(`v25.0`·`v46.0` 등)은 PDF 원문대로 각 리소스의 도입 버전을 고정 표기한 것이다. `vXX.X`는 가변 버전 자리표시자다.

### M1 — Archive the Primary Version of an Article

primary version을 archive한다. action은 리소스에 요청한 field 변경으로 정의된다. primary version archive에는 `"publishStatus":"Archived"`, archive 날짜 예약에는 `"archiveScheduleDate" : <date>`를 쓴다.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/masterVersions/<versionID>`
- **Formats:** JSON, XML — **HTTP Method:** PATCH — **Authentication:** `Authorization: OAuth accesstoken`

| Parameter | Description |
|---|---|
| `publishStatus` | 아티클의 발행 상태. archived 사용. |
| `archiveScheduleDate` | 아티클을 archive할 날짜. |

**Input** (Archive):

```json
{
"publishStatus":"Archived"
}
```

**Input** (archive 예약, GMT 날짜 형식):

```json
{
"archiveScheduleDate" : "2012-04-19T07:00:00.000+0000"
}
```

**Output:** 기존 레코드가 update되면 HTTP 상태 코드 204 반환.

### M2 — Assign a Task Related to a Primary Article

primary article에 대한 task를 사용자에게 할당(마감일·지시 포함).

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/masterVersions/<versionID>`
- **Formats:** JSON, XML — **HTTP Method:** PATCH — **Authentication:** `Authorization: OAuth accesstoken`

| Parameter | Description |
|---|---|
| `assigneeId` | primary article을 사용자 ID 또는 queue ID에 할당. |
| `dueDate` | task 마감일. |
| `instruction` | task 지시사항. |

**Input:**

```json
{
"assigneeId":"05Dxx0000dsads",
"dueDate":"2012-04-19T07:00:00.000+0000",
"instruction":"Please review."
}
```

**Output:** 기존 레코드 update 시 HTTP 204.

### M3 — Assign a Task Related to a Translation

translation에 대한 task 할당.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/translations/<translationVersionId>`
- **Formats:** JSON, XML — **HTTP Method:** PATCH — **Authentication:** `Authorization: OAuth accesstoken`

| Parameter | Description |
|---|---|
| `assigneeId` | primary article을 사용자 ID 또는 queue ID에 할당. *(PDF 원문 그대로 "primary article" 표기)* |
| `dueDate` | task 마감일. |
| `instruction` | task 지시사항. |

**Input:**

```json
{
"assigneeId":"05Dxx0000dsads",
"dueDate":"2012-04-19T07:00:00.000+0000",
"instruction":"Please review."
}
```

**Output:** 기존 레코드 update 시 HTTP 204.

### M4 — Delete a Primary Version of an Article

primary version 삭제.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/masterVersions/<versionID>`
- **Formats:** JSON, XML — **HTTP Method:** DELETE — **Authentication:** `Authorization: OAuth accesstoken`
- **Parameters:** 없음 — **Input:** 불필요
- **Output:** 기존 레코드 삭제 시 HTTP 204.

### M5 — Delete a Translated Version of an Article

translation version 삭제.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/translations/<versionID>`
- **Formats:** JSON, XML — **HTTP Method:** DELETE — **Authentication:** `Authorization: OAuth accesstoken`
- **Parameters:** 없음 — **Input:** 불필요
- **Output:** 기존 레코드 삭제 시 HTTP 204.

### M6 — Edit an Online Version of a Primary Article

primary article의 online version의 draft 복사본 생성. online version을 unpublish하지 않는다.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/masterVersions`
- **Formats:** JSON, XML — **HTTP Method:** POST — **Authentication:** `Authorization: OAuth accesstoken`

| Parameter | Description |
|---|---|
| `articleId` | 아티클의 ID. |

**Input:**

```json
{
"articleId":<articleID>
}
```

(이 action에는 PDF 원문에 Output 절이 없다.)

### M7 — Get a List of Salesforce Site and Experience Cloud Site URLs for an Online Article

Salesforce Sites·Experience Cloud site의 아티클 URL 목록을 반환한다. 아티클이 public knowledge base에 보이면 Salesforce Sites URL을, 파트너/고객에게 보이면 Experience Cloud URL을 반환. 이 API는 *Insert URL into Email* Lightning action용 URL을 만든다.

> org에 Lightning Knowledge가 활성화되고 Knowledge Settings에서 *Allow users to share articles via public URLs* 가 활성화되어야 한다. API 사용자는 Knowledge에 read 접근 권한이 필요하다. **API v46.0+.**

- **URI:** `/services/data/v46.0/knowledgeManagement/articles/siteListForOnlineArticle?articleId=articleId&language=xx_XX`
- **Formats:** JSON, XML — **HTTP Method:** GET — **Authentication:** `Authorization: OAuth accesstoken`

| Parameter | Description |
|---|---|
| `articleId` | article version ID의 15자리 또는 18자리 버전. |
| `language` | 선택 아티클의 언어. |

**Input:** 없음

### M8 — Publish the Primary Version of an Article

primary version 발행.

> minor version 발행에는 `"publishStatus":"Online"`, major version 발행에는 `"publishStatus":"Online"` + `"versionNumber":"NextVersion"`, 발행 날짜 예약에는 `"publishScheduleDate" : <date>`를 쓴다.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/masterVersions/<versionId>`
- **Formats:** JSON, XML — **HTTP Method:** PATCH — **Authentication:** `Authorization: OAuth accesstoken`

| Parameter | Description |
|---|---|
| `publishStatus` | 발행 상태. online 사용. |
| `versionNumber` | 아티클의 version. |
| `publishScheduleDate` | ISO 8601 형식 `YYYY-MM-DDTHH:mm:ss+/-HHmm`의 발행 날짜. 예: 2023년 2월 8일 13:40 UTC+01:00 → `2023-02-08T13:40:31+0100..` *(PDF 원문에 점 두 개 표기)* |

**Input** (minor version 발행):

```json
{
"publishStatus":"Online"
}
```

**Input** (major version 발행):

```json
{
"publishStatus":"Online",
"versionNumber":"NextVersion"
}
```

**Input** (발행 예약):

```json
{
"publishScheduleDate" : "2012-05-19T07:00:00+0000"
}
```

**Output:** 기존 레코드 update 시 HTTP 204.

### M9 — Restore an Archived Version of an Article

아티클의 archived version 복원. `versionNumber` 미지정 시 최신 archived version 복원.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/masterVersions/`
- **Formats:** JSON, XML — **HTTP Method:** POST — **Authentication:** `Authorization: OAuth accesstoken`

| Parameter | Description |
|---|---|
| `articleId` | 아티클의 ID. |
| `versionNumber` | 아티클의 version. 미지정 시 최신 archived version 복원. |

**Input:**

```json
{
"articleId":"<articleID>",
"versionNumber": <number>
}
```

### M10 — Retrieve Article Metadata

아티클의 metadata 조회.

- **URI:** `/services/data/v25.0/knowledgeManagement/articles/<articleId>`
- **Formats:** JSON, XML — **HTTP Method:** GET — **Authentication:** `Authorization: OAuth accesstoken`
- **Parameters:** 없음 — **Input:** 불필요

### M11 — Get Knowledge Language Settings

기존 Knowledge 언어 설정(기본 knowledge 언어, 지원 언어 정보 목록)을 가져온다. API v31.0+에서 사용 가능. Salesforce Knowledge가 활성화되어야 한다.

- **URI:** `/services/data/vXX.X/knowledgeManagement/settings`
- **Formats:** JSON, XML — **HTTP methods:** GET — **Authentication:** `Authorization: Bearer token`
- **Request body:** 불필요 — **Request parameters:** 없음

**Example Request:**

```
curl
https://MyDomainName.my.salesforce.com/services/data/v67.0/knowledgeManagement/settings
-H "Authorization: Bearer token"
```

**Example Response Body:**

```json
{
"defaultLanguage" : "en_US",
"knowledgeEnabled" : true,
"languages" : [ {
"active" : true,
"name" : "en_US"
}, {
"active" : true,
"name" : "it"
}, {
"active" : true,
"name" : "zh_CN"
}, {
"active" : true,
"name" : "fr"
} ]
}
```

### M12 — Retrieve a Version of an Article

아티클의 version ID 조회.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/masterVersions/<articleVersionId>`
- **Formats:** JSON, XML — **HTTP Method:** GET — **Authentication:** `Authorization: OAuth accesstoken`
- **Parameters:** 없음 — **Input:** 불필요

### M13 — Search for Metadata Elements of a Primary Version

아티클의 online primary version의 metadata 요소 검색.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/masterVersions?filterArticleId=value1&FilterPublishStatus=value2`
- **Formats:** JSON, XML — **HTTP Method:** GET — **Authentication:** `Authorization: OAuth accesstoken`

**Example** (primary article 'kA0x50000000jsh'의 online version 검색):

```
/services/data/v25.0/knowledgeManagement/articleVersions/masterVersions?filterArticleId=kA0x50000000jsh&filterPublishStatus=online"
```

### M14 — Search for Metadata Elements of a Translated Version

translation version의 metadata 요소 검색.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/translations?filterArticleId=value1&filterLanguage=value2&FilterPublishStatus=value3";`
- **Formats:** JSON, XML — **HTTP Method:** GET — **Authentication:** `Authorization: OAuth accesstoken`

**Example** (아티클 'kA0x50000000jsh'의 독일어 online 번역 검색):

```
/services/data/v25.0/knowledgeManagement/articleVersions/translations?filterArticleId=kA0x50000000jsh&filterLanguage=de&filterPublishStatus=online"
```

### M15 — Set a Translated Article Version to Complete

translation version을 complete로 설정.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/translations/<translationVersionID>`
- **Formats:** JSON, XML — **HTTP Method:** PATCH — **Authentication:** `Authorization: OAuth accesstoken`

| Parameter | Description |
|---|---|
| `complete` | 완료된 번역에 대해 true로 설정. |

**Input:**

```json
{
"complete":"true"
}
```

**Output:** 기존 레코드 update 시 HTTP 204.

### M16 — Set a Translated Article Version to Incomplete

translation version을 incomplete로 설정.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/translations/<translationVersionID>`
- **Formats:** JSON, XML *(PDF 원문에 `XML>` 오타 표기)* — **HTTP Method:** PATCH — **Authentication:** `Authorization: OAuth accesstoken`

| Parameter | Description |
|---|---|
| `complete` | 번역을 incomplete로 만들려면 false로 설정. |

**Input:**

```json
{
"complete":"false"
}
```

**Output:** 기존 레코드 update 시 HTTP 204.

### M17 — Submit an Article for Translation

여러 언어로 번역 제출. 비활성 언어의 번역은 차단된다.

- **URI:** `/knowledgeManagement/articleVersions/translations`
- **Available since release:** 25.0. 일부 parameter는 API v43.0+에서 지원.
- **Formats:** JSON, XML — **HTTP Method:** POST — **Authentication:** `Authorization: OAuth accesstoken`

| Parameter | Description | Available |
|---|---|---|
| `articleID` | String. Required. 아티클의 ID. | 25.0 |
| `assignments` | JSON Array. 할당 상세 배열. 각 할당은 다음 프로퍼티를 가진 list: • `language`: Required. 언어 코드. • `assigneeId`: 사용자 Id 또는 queue Id. • `dueDate`: task 마감일. 이 parameter를 쓰면 `language` parameter는 쓰지 않음. | 43.0 |
| `language` | String. 언어 코드. 이 parameter를 쓰면 `assignments` parameter는 쓰지 않음. | 25.0–42.0 |
| `sendEmailNotification` | Boolean. assignee에게 email 전송 여부(true/false). | 43.0 |

**Example Request Body:**

```json
{
"articleId":"kA0xx00000000BO",
"assignments":[
{
"language":"sq",
"assigneeId":"005xx000001T7MF",
"dueDate":""
},
{
"language":"zh_CN",
"assigneeId":"005xx000001T7MF",
"dueDate":""
}
],
"sendEmailNotification":true
}
```

### M18 — Unpublish the Primary Version of an Article

기존 draft 아티클이 없을 때 online primary version을 unpublish한다. primary version unpublish에는 `"publishStatus":"draft"`를 쓴다.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/masterVersions/<versionId>`
- **Formats:** JSON, XML — **HTTP Method:** PATCH — **Authentication:** `Authorization: OAuth accesstoken`

| Parameter | Description |
|---|---|
| `publishStatus` | 발행 상태. draft 사용. |

**Input:**

```json
{
"publishStatus":"draft"
}
```

**Output:** 기존 레코드 update 시 HTTP 204.

### M19 — Unpublish the Online Version of a Translated Article

translation의 online version을 unpublish한다. 번역을 편집하고 online 상태에서 제거하려면 `"publishStatus":"draft"`를 쓴다.

- **URI:** `/services/data/v25.0/knowledgeManagement/articleVersions/translations/<translationVersionID>`
- **Formats:** JSON, XML — **HTTP Method:** PATCH — **Authentication:** `Authorization: OAuth accesstoken`

| Parameter | Description |
|---|---|
| `publishStatus` | 발행 상태. draft 사용. |

**Input:**

```json
{
"publishStatus":"draft"
}
```

---

## 관련 노트

- [[Knowledge 데이터 모델 & API 개요]]
- [[Knowledge REST API — Search & Support]]
- [[Knowledge SOAP API 객체 — 핵심 아티클 객체]]
- [[Knowledge SOAP API 호출]]
- [[Lightning Knowledge 아티클 임포트]] — 아티클 임포트의 선언적 셋업 (이 발행·관리 API의 데이터 적재 측 대응)
- [[Lightning Knowledge 다국어 & 번역]] — 번역 발행·언어 셋업 how-to (이 API의 translations 관리 측 대응)
- [[Actions API]]
- [[REST API]]
