---
tags: [analytics, folders, rest-api, reports-dashboards-rest, folder-shares, analytics-folders-api]
source: salesforce_analytics_rest_api.pdf (Reports and Dashboards REST API Developer Guide, v67.0 Summer '26)
created: 2026-06-22
aliases: [Analytics Folders API, Folder Shares REST, 폴더 공유 REST, ConnectFolderShareTypeEnum, folder collections, share recipients]
---

# Reports and Dashboards REST API — Folders 표현형

> Analytics Folders API로 리포트·대시보드 폴더와 서브폴더의 생성·조회·이름 변경·삭제, 그리고 폴더 공유(share)·공유 수신자(recipient) 조회를 수행하는 6개 REST 리소스 — URI·메서드·권한·입력/출력 표현형·enum 3종을 전수 기록.

---

## Analytics Folders API 개요

Analytics Folders API는 리포트·대시보드 폴더에 대한 작업을 수행한다. **API 버전 41.0 이상에서 사용 가능.** 리소스는 `/services/data/<latest API version>/folders` 아래에 위치한다.

> 버전 주의: PDF의 URI 예시는 리소스별로 버전이 혼재한다 — Shares 계열(Folder Shares·Share by ID·Share Recipients)은 `v41.0`, Collections·Operations·Child Operations는 `v43.0`. 아래는 `<latest API version>` 표기를 권장하되 PDF 원문 버전을 병기한다.

### 리소스 요약

| Resource | URL | HTTP Method | Description |
|---|---|---|---|
| Folder Collections | `/services/data/<latest API version>/folders/` | POST, GET | Enables creation of report and dashboard folders and subfolders (POST). Gets the list of folders (GET). |
| Folder Operations | `/services/data/<latest API version>/folders/<folderid>` | GET, PATCH, DELETE | Enables renaming (PATCH), deleting (DELETE), and obtaining information (GET) on the report or dashboard folder or subfolder. |
| Folder Shares | `/services/data/<latest API version>/folders/<folderid>/shares` | GET, PUT, POST | Extracts a list of current folder shares (GET), adds new shares (POST), or replaces existing shares (PUT). |
| Folder Share by ID | `/services/data/<latest API version>/folders/<folderid>/shares/<shareid>` | GET, PATCH, DELETE | For a specified share ID, extracts the share information (GET), updates the access level on the share (PATCH), or deletes the share (DELETE). |
| Folder Share Recipients | `/services/data/<latest API version>/folders/<folderid>/share-recipients?shareType=<shareType>` | GET | Returns a list of folder share recipients (GET). |
| Folder Child Operations | `/services/data/<latest API version>/folders/<folderid>/children/` | GET | Returns a list of first-level child folders (subfolders) (GET). |

---

## 공통 enum 3종

아래 enum은 여러 리소스에서 재사용된다. 처음 여기서 전수 정의하고, 이후 리소스에서는 "위 enum 참조"로 표기한다.

### `ConnectFolderTypeEnum` (5)

| Type | Description |
|---|---|
| `Dashboard` | Dashboard folders. |
| `Document` | Document folders. |
| `Email` | Email folders. |
| `Insights` | Insights folders. |
| `Reports` | Reports folders. |

### `ConnectFolderAccessTypeEnum` (3)

| Type | Description |
|---|---|
| `View` | View access to the folder. |
| `Edit` | Edit access to the folder. |
| `Manage` | Manage access to the folder. |

### `ConnectFolderShareTypeEnum` (13)

| Type | Description |
|---|---|
| `Group` | Users in a specified public group. |
| `Role` | Users with a specified role. |
| `RoleAndSubordinates` | Users with a specified role and users with a role subordinate to that role. |
| `RoleAndSubordinatesInternal` | Users with a specified role and users with a role subordinate to that role, except public portal users. |
| `Organization` | All internal users. |
| `AllPrmUsers` | All PRM Portal users. |
| `User` | The specified individual user. |
| `PartnerUser` | The specified individual user of a partner portal. |
| `AllCspUsers` | All Customer Success Portal users. |
| `CustomerPortalUser` | The specified individual user of a customer portal. |
| `PortalRole` | Users with a specified role in a portal. |
| `PortalRoleAndSubordinates` | PortalRoleAndSubordinates. Portal users with a specified role, and portal users with a role subordinate to that role. |
| `ChannelProgramGroup` | PRM Portal users who are members of the specified channel programs and levels group. |

---

## [1] Folder Collections

- **권한:** POST = Create Dashboard Folders / Create Report Folders · GET = View access to the folder.
- **URI:** `/services/data/v43.0/folders/` · JSON
- **HTTP:** `POST` — Creates a new folder with the specified name, label, type, and parent ID (subfolders only). / `GET` — Gets the list of folders.

### POST Request Body

| Query Parameter Name | Group | Available Version | Values | Description |
|---|---|---|---|---|
| folder | Object | 42.0, 43.0 | `FolderInputRepresentation` | Specifies the folder name, label, type, and parent ID. |

#### `FolderInputRepresentation`

| Code | Type | Available Version | Description |
|---|---|---|---|
| `label` | String | 42.0 | Folder display name. |
| `name` | String | 42.0 | Folder unique name. This is a mandatory field for admins; for non-admins, it is auto-generated. |
| `type` | `ConnectFolderTypeEnum` | 42.0 | Defined by the type of entity the folder contains. |
| `parentId` | String | 43.0 | ID of the parent folder. This field is valid only for subfolders. |

> `type`은 위 `ConnectFolderTypeEnum`(5) 참조.

#### Sample Request Body

원문 그대로 — `"type"` 행 뒤 콤마 누락은 PDF 오류 [sic].

```json
{
"label": "report_folder",
"name": "report_folder1",
"type": "report"
"parentId": "00lxx000000fffffff"
}
```

#### Sample Output Response

원문 그대로 — `"type"` 행 뒤 콤마 누락은 PDF 오류 [sic].

```json
{
"id" : "00lxx000000flSFAAY",
"label" : "report_folder",
"name" : "report_folder1",
"shareRecipientsUrl" : "/services/data/v43.0/folders/00lxx000000flSFAAY/share-recipients?shareType=User&limit=100",
"sharesUrl" : "/services/data/v43.0/folders/00lxx000000flSFAAY/shares",
"supportedShareTypes" : [ "user", "role", "roleandsubordinates", "roleandsubordinatesinternal", "group", "portalrole", "portalroleandsubordinates", "customerportaluser" ],
"type" : "report"
"parentId" : "00lxx000000fffffff"
}
```

### GET Parameters

| Field | Type | Available Version | Description |
|---|---|---|---|
| `type` | `ConnectFolderTypeEnum` | 43.0 | Defined by the type of entity the folder contains. If not specified, returns all visible folders. If specified, returns visible folders of the specified type. |
| `page` | Integer | 43.0 | Integer that indicates which page of results to return. Default is 1. |
| `pageSize` | Integer | 43.0 | Integer that indicates how many results to return per page. Default is 10. |

### GET Output Payload: `FolderCollectionRepresentation`

| Field | Type | Available Version | Description |
|---|---|---|---|
| `folders` | `FolderSummaryRepresentation` | 43.0 | Collection of folders. |
| `totalSize` | Integer | 43.0 | Size of the folder collection. |
| `url` | ConnectUri | 43.0 | URL of the folder collection. |
| `nextPageurl` | ConnectUri | 43.0 | URL to the next page in the collection. |
| `previousPageurl` | ConnectUri | 43.0 | URL to the next page in the collection. [sic — 설명에 "next"로 적혀 있으나 previous 페이지 URL] |

#### `FolderSummaryRepresentation`

| Field | Type | Available Version | Description |
|---|---|---|---|
| `id` | ID | 43.0 | Unique identifier. |
| `label` | String | 43.0 | Display label. |
| `name` | String | 43.0 | Folder unique name. |
| `namespace` | String | 43.0 | Namespace prefix to differentiate custom object and field names from those in use by other organizations. |
| `type` | `ConnectFolderTypeEnum` | 43.0 | Defined by the type of entity the folder contains. |
| `parentId` | ID | 43.0 | ID of the parent folder. |
| `url` | ConnectUri | 43.0 | URL of the folder. |
| `childrenUrl` | ConnectUri | 43.0 | URL that represents the first level subfolders of the specified folder. |
| `depth` | Int | 43.0 | Depth of the folder in the tree. A folder with depth 0 is the root folder. |

#### Sample Output Response (GET list)

원문 그대로 — Asia / Europe / North America Sales 3 folders.

```json
{
"folders" : [
{ "childrenUrl" : "/services/data/v43.0/folders/00lRM000000jCWjYAM/children", "id" : "00lRM000000jCWjYAM", "label" : "Asia Sales", "name" : "Asia_Sales", "type" : "report", "url" : "/services/data/v43.0/folders/00lRM000000jCWjYAM" },
{ "childrenUrl" : "/services/data/v43.0/folders/00lRM000000jDmNYAU/children", "id" : "00lRM000000jDmNYAU", "label" : "Europe Sales", "name" : "Europe_Sales", "type" : "report", "url" : "/services/data/v43.0/folders/00lRM000000jDmNYAU" },
{ "childrenUrl" : "/services/data/v43.0/folders/00lRM000000jHKXYA2/children", "id" : "00lRM000000jHKXYA2", "label" : "North America Sales", "name" : "North_America_Sales", "type" : "report", "url" : "/services/data/v43.0/folders/00lRM000000jHKXYA2" }
],
"totalSize" : 3,
"url" : "/services/data/v43.0/folders?page=1&pageSize=10"
}
```

---

## [2] Folder Operations

- **권한:** GET = View access · PATCH/DELETE = Manage access.
- **URI:** `/services/data/v43.0/folders/<folderid>` · JSON
- **HTTP:**
  - `GET` — Gets information about the folder that has the specified folder ID.
  - `PATCH` — Updates the label or name. • All users with manage access can change the folder label. • Only admin users can change the folder name.
  - `DELETE` — Deletes the folder.
- **Parameters:** `folderId` — Specifies a unique folder ID.

### GET Output Payload: `FolderDetailRepresentatiion`

[sic — Representation의 오타 `Representatiion`을 PDF 원문대로 보존.] layout 검증본 13행.

| Field | Type | Available Version | Description |
|---|---|---|---|
| `id` | String | 42.0 | Unique folder identifier. |
| `label` | String | 42.0 | Folder display name. |
| `name` | String | 42.0 | Folder unique name. |
| `namespace` | String | 42.0 | Namespace prefix to differentiate custom object and field names from those in use by other organizations. |
| `type` | `ConnectFolderTypeEnum` | 42.0 | Defined by the type of entity the folder contains. |
| `parentId` | ID | 43.0 | ID of the parent folder. |
| `url` | ConnectUri | 43.0 | URL of the folder: `/services/data/v43.0/folders/<folderid>` |
| `childrenUrl` | ConnectUri | 43.0 | URL that represents the first level subfolders: `/services/data/v43.0/folders/<folderid>/children` |
| `depth` | Integer | 43.0 | Depth of the folder in the tree. A folder with depth 0 is the root folder. |
| `supportedShareTypess` | List `<supportedShareTypes>` | 43.0 | List of supported share types for the folder in the organization. [sic — 필드명 `supportedShareTypess`의 끝 `s` 중복, PDF 원문대로] |
| `sharesUrl` | ConnectUri | 43.0 | URL of the shares: `/services/data/v43.0/folders/<folderid>/shares` |
| `shareRecipientsUrl` | ConnectUri | 43.0 | URL of the recipients of the share: `/services/data/v43.0/folders/<folderid>/share-recipients` |
| `ancestors` | List `<FolderSummaryRepresentation>` | 43.0 | This folder's ancestor folders, ordered by depth. |

> `type`은 `ConnectFolderTypeEnum`(5), `ancestors`/`supportedShareTypess` 내 폴더 요약은 `FolderSummaryRepresentation`(9) 참조 — [1] 동일.

#### Sample Output Response (GET)

[1]의 Response와 유사 구조이며 추가로 `ancestors`(예: `[]`)와 `depth`(예: `0`)를 포함한다.

### PATCH Request Body

| Query Parameter Name | Group | Since Available Version | Description |
|---|---|---|---|
| folder | Object | 42.0 | Users with edit access on the folder can change `label`. Admins can change `name`. `type` cannot be changed. |

> 입력 본문은 `FolderInputRepresentation`(`label`/`name`/`type`/`parentId`) — [1]과 동일.

#### PATCH Sample Request Body

```json
{ "label": "report_folder1", "name": "report_folder1" }
```

### DELETE

Deletes the folder. (추가 body 없음)

---

## [3] Folder Shares

- **권한:** POST/PUT = Manage access · GET = View access.
- **URI:** `/services/data/v41.0/folders/<folderId>/shares` · JSON
- **HTTP:**
  - `GET` — Returns a list of current folder shares.
  - `PUT` — Creates new shares to replace the existing shares.
  - `POST` — Creates new shares and appends them to the existing share list.
- **Parameters:** `folderId` — Perform the operation for this unique folder ID.

### GET Response Body

| Property | Type | Description |
|---|---|---|
| `accessType` | `ConnectFolderAccessTypeEnum` | Defined by the type of folder access. |
| `shareId` | ID | Unique identifier of the share. |
| `shareType` | `ConnectFolderShareTypeEnum` | Defined by the type of folder share. |
| `sharedWithId` | ID | Unique identifier of the share recipient. |
| `sharedWithLabel` | String | Label of the share recipient. |
| `url` | ConnectUri | URL of the share. |

> `accessType`은 `ConnectFolderAccessTypeEnum`(3), `shareType`은 `ConnectFolderShareTypeEnum`(13) 참조.

#### Output Example 1 (folder not shared)

원문 그대로 — 줄바꿈 verbatim.

```json
{
"shares"

: []

}
```

#### Output Example 2 (shared with two users and a public group)

원문 그대로.

```json
{
"shares" : [
{ "accessType" : "view", "shareId" : "0AFR00000004LtpOAE", "shareType" : "group", "sharedWithId" : "00GR0000000Mi1nMAC", "sharedWithLabel" : "Demo Group", "url" : "/services/data/v41.0/folders/00lR0000000MQT5IAO/shares/0AFR00000004LtpOAE" },
{ "accessType" : "edit", "shareId" : "0AFR00000004LtkOAE", "shareType" : "user", "sharedWithId" : "005R0000000Kg8yIAC", "sharedWithLabel" : "Brian Alison", "url" : "/services/data/v41.0/folders/00lR0000000MQT5IAO/shares/0AFR00000004LtkOAE" },
{ "accessType" : "manage", "shareId" : "0AFR00000004LtlOAE", "shareType" : "user", "sharedWithId" : "005R0000000Kg8cIAC", "sharedWithLabel" : "Fred Williamson", "url" : "/services/data/v41.0/folders/00lR0000000MQT5IAO/shares/0AFR00000004LtlOAE" }
]
}
```

### PUT/POST Request Body

| Query Param Name | Group | Available Version | Values | Description |
|---|---|---|---|---|
| folder | Object | 41.0 | `FolderSharesInputRepresentation` | Folder input representation containing a list of shares. |

#### Sample Request Body

원문 그대로 — [sic] 응답에서는 `sharedWithId`였으나 요청 body는 `shareWithId`(중간 `d` 없음).

```json
{
"shares" : [
{ "accessType" : "view", "shareType" : "group", "shareWithId" : "00GR0000000Mi1nMAC" },
{ "accessType" : "edit", "shareType" : "user", "shareWithId" : "005R0000000Kg8yIAC" },
{ "accessType" : "manage", "shareType" : "user", "shareWithId" : "005R0000000Kg8cIAC" }
]
}
```

---

## [4] Folder Share by ID

- **권한:** PATCH/DELETE = Manage · GET = View.
- **URI:** `/services/data/v41.0/folders/<folderId>/shares/<shareId>` · JSON
- **HTTP:**
  - `GET` — Returns information for the specified folder share.
  - `PATCH` — Updates the access level on the specified folder share.
  - `POST` — Deletes the specified folder share. [sic — `POST`가 "Deletes"로 매핑됨, PDF 원문대로]
- **Parameters:** `folderId` — ID of the folder containing the share. · `shareId` — Perform the operation for this unique folder share ID.

### GET Response Body

[3]의 GET Response Body와 동일 — `accessType` / `shareId` / `shareType` / `sharedWithId` / `sharedWithLabel` / `url`. `ConnectFolderAccessTypeEnum`(3)·`ConnectFolderShareTypeEnum`(13) 참조.

#### Output Example

원문 그대로 — [sic] 키-값 사이 콤마 다수 누락은 PDF 오류.

```json
{
"shareId" : "004xx000001Sy1GAAS"
"accessType" : "manage",
"shareType" : "user"
"sharedWithId" : "005xx000001Sy1GAAS"
"sharedWithLabel" : "User1"
}
```

### PATCH Request Body

| Query Param Name | Group | Available Version | Values | Description |
|---|---|---|---|---|
| folder | Object | 41.0 | `FolderShareInputRepresentation` | Folder share input representation. |

#### `FolderShareInputRepresentation`

layout 검증본.

| Parameter | Type | Available Version | Description |
|---|---|---|---|
| `shareWithId` | ID | 41.0 | ID of the entity that the folder can be shared with. |
| `accessType` | `ConnectFolderAccessTypeEnum` | 41.0 | The access type for the recipient entity on the folder. |
| `shareType` |  | 41.0 | The type of the entity that the folder can be shared with. [sic — Type 셀이 PDF에서 공란] |

#### PATCH Sample Request Body

```json
{ "accessType" : "manage", "shareType" : "user", "shareWithId" : "005R0000000Kg8yIAC" }
```

### DELETE

Deletes the folder share. (추가 body 없음)

---

## [5] Folder Share Recipients

- **권한:** View access to the folder.
- **URI:** `/services/data/v41.0/folders/<folderId>/share-recipients?shareType=<shareType>` · JSON
- **HTTP:** `GET` — Returns a list of recipients with whom the folder can be shared.

### Parameters

| Parameter | Description | Default |
|---|---|---|
| `folderId` | Return data for this unique folder ID. | (없음) |
| `shareType` | Return data for the recipients of the specified type, such as user, group, or role. | User |
| `searchTerm` | Search to match share recipients names. | "" |
| `limit` | Limit to the number of search results. | 100 |

### GET Response Body

| Property | Type | Description |
|---|---|---|
| `shareRecipients` | `List<FolderShareRecipientRepresentation>` | List of recipients along with their share type. |
| `shareType` | `ConnectFolderShareTypeEnum` | Defined by the type of folder share. |
| `shareWithId` | ID | Return the URL for share recipients. |
| `shareWithLabel` | String | Label of the folder share recipient. |

#### `FolderShareRecipientRepresentation`

| Parameter | Type | Available Version | Description |
|---|---|---|---|
| `shareWithId` | ID | 41.0 | The ID of the folder share recipient. |
| `shareWithLabel` | String | 41.0 | The label of the folder share recipient. |
| `shareType` | `ConnectFolderShareTypeEnum` | 41.0 | The share type of the recipient. |
| `imageUrl` | ConnectUri | 42.0 | The url of the image for the recipient. |
| `imageColor` | String | 42.0 | The color of the image for the recipient. |

> `shareType`은 `ConnectFolderShareTypeEnum`(13) 참조.

#### Output Example 1 (shareType=User)

원문 그대로 — Hank Chen / Integration User / Nadia Smith / Sarah Vasquez.

```json
{ "shareRecipients" : [
{ "shareType":"user", "shareWithId":"005R0000000Kg8wIAC", "shareWithLabel":"Hank Chen" },
{ "shareType":"user", "shareWithId":"005R0000000KkU6IAK", "shareWithLabel":"Integration User" },
{ "shareType":"user", "shareWithId":"005R0000000Kg8xIAC", "shareWithLabel":"Nadia Smith" },
{ "shareType":"user", "shareWithId":"005R0000000Kg8zIAC", "shareWithLabel":"Sarah Vasquez" }
] }
```

#### Output Example 2 (shareType=Group&searchTerm=Group)

원문 그대로 — Finance / Marketing / Products / Sales / Technology.

```json
{ "shareRecipients" : [
{ "shareType":"group", "shareWithId":"00GR0000000EypUMAS", "shareWithLabel":"Finance" },
{ "shareType":"group", "shareWithId":"00GR0000000EypeMAC", "shareWithLabel":"Marketing" },
{ "shareType":"group", "shareWithId":"00GR0000000NvpIMAS", "shareWithLabel":"Products" },
{ "shareType":"group", "shareWithId":"00GR0000000EypZMAS", "shareWithLabel":"Sales" },
{ "shareType":"group", "shareWithId":"00GR0000000EypjMAC", "shareWithLabel":"Technology" }
] }
```

---

## [6] Folder Child Operations

- **권한:** GET = View access to the root folder in the tree.
- **URI:** `/services/data/v43.0/folders/<folderid>/children` · JSON
- **HTTP:** `GET` — Gets information about the child folders of the specified folder.

### Parameters

| Parameter | Type | Available Version | Description |
|---|---|---|---|
| `folderId` | String | 42.0 | Return data for this unique folder ID. |
| `page` | Integer | 43.0 | Integer that indicates which page of results to return. Default is 1. |
| `pageSize` | Integer | 43.0 | Integer that indicates how many results each page returns. Default is 10. |

### GET Output Payload: `FolderCollectionRepresentation`

`FolderCollectionRepresentation` + `FolderSummaryRepresentation` — [1] 재사용.

#### Sample Output Response

원문 그대로 — BW33 1 folder.

```json
{ "folders" : [
{ "childrenUrl":"/services/data/v43.0/folders/00lR0000000Mf56IAC/children", "id":"00lR0000000Mf56IAC", "label":"BW33", "name":"BW33", "parentId":"00lR0000000E84WIAS", "type":"report", "url":"/services/data/v43.0/folders/00lR0000000Mf56IAC" }
], "totalSize" : 1, "url" : "/services/data/v43.0/folders/00lR0000000E84WIAS/children?page=1&pageSize=10" }
```

---

## 관련 노트

- [[Reports and Dashboards REST API — 개요·Reports 예제]]
- [[Reports and Dashboards REST API — Report 표현형]]
- [[Reports and Dashboards REST API — Execute·Instances·Report List 표현형]]
