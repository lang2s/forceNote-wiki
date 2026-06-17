---
tags: [lwc, lds, ui-api, rest, reference, request-body, response-body, record-input, object-info, picklist-values, related-list, batch, layout, action]
source: api_ui.pdf (v67.0, Summer '26) — Ch3 Request Parameters / Ch4 Request Bodies / Ch5 Response Bodies
created: 2026-06-17
updated: 2026-06-17
aliases: [UI API Reference, Record Input, record-input, Object Info, object-info fields, Request Body, Response Body, layoutTypes, optionalFields, childRelationships, Picklist Values, RelatedList Input, Batch Record Input, ui-api reference]
---

# UI API 리소스 레퍼런스

> raw REST 요청 파라미터·요청 바디·응답 바디 스키마 전수 레퍼런스.

**상위:** [[UI API 개요]] → [[LWC MOC]]

> 엔드포인트 목록·wire 어댑터 매핑·HTTP 상태코드는 [[UI API 개요]] 참조. 이 노트는 필드 레벨 스키마만 다룬다.

---

## 0. PDF 표 컬럼 규칙 (읽는 법)

이 레퍼런스의 모든 표는 `api_ui.pdf`(v67.0) 원문 표를 그대로 옮긴 것이다. PDF 원문 표는 5컬럼으로 정렬돼 있으며, 컬럼 의미가 챕터마다 다르다.

- **Ch3 Request Parameters / Ch4 Request Bodies:** `Name · Type · Description · Required or Optional · Available Version`. 4번째 컬럼은 필수/선택 여부다. (단, Related List User Preferences Input(B-27)만 예외적으로 4번째 컬럼이 `Filter Group and Version` 형식 `Small, 55.0`로 표기됨 — 원문 그대로 보존.)
- **Ch5 Response Bodies:** `Property · Type · Description · Filter Group and Version · Available Version`. **4번째 컬럼(`Filter Group and Version`, 예: `Small, 41.0`)과 마지막 컬럼(`Available Version`)은 서로 다른 컬럼이다.** 둘이 같은 값일 때도 있지만(예: Record Collection의 `nextPageToken`은 양쪽 모두 `Small, 44.0`) 일반적으로 다르므로 별도 컬럼으로 유지한다.
- **버전 표기:** `41.0`=해당 버전부터 사용 가능, `43.0–46.0`/`61.0–66.0`=해당 범위에서만 유효, `42.0 only`/`41.0–41.0`=단일 버전 전용.
- **원문 오타 보존:** `picklistAtrributesValueType`, `ruleCritera`, `maybe null`, `ISO 8061`(Favorite.lastAccessDate) 등은 PDF 원문 표기 그대로 옮겼다. Salesforce 문서가 typo임을 명시한 항목은 표 안에 그대로 적었다.

---

## 1. Request Parameters (Ch3, 리소스별)

> 각 리소스 헤더의 Resource/Available/Response Body는 맥락 표기다. 엔드포인트 전체 목록은 [[UI API 개요]] §2 참조.

### 1-1. Get Record Data and Object Metadata
**Resource:** `GET /ui-api/record-ui/{recordIds}` (recordIds = comma-delimited 커스텀/지원 오브젝트 레코드 ID) · **Available 41.0** · **Response Body:** Record UI
**Example:** `GET /ui-api/record-ui/001R0000003I6CoIAK?childRelationships=Account.Contacts,Account.Opportunities`

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| childRelationships | String[] | A collection of child relationship names. The records with those child relationship names are included in the response. Specify names in the format `ObjectApiName.ChildRelationshipName` or `ObjectApiName.ChildRelationshipName.FieldApiName`. For example, to specify the Contacts relationship on an Account, use `Account.Contacts`. You can get child relationships one level deep. To get a relationship name, look in the Object Info response body. | Optional | 41.0 |
| formFactor | String | The layout display size for the record. One of: • Large—(Default) desktop display size. • Medium—tablet display size. • Small—phone display size. | Optional | 41.0 |
| layoutTypes | String[] | The layout type for the record. A collection of any of: • Compact—a layout that contains a record's key fields. • Full—(Default) a full layout. | Optional | 41.0 |
| modes | String[] | The access mode for the record. Determines which fields to get from a layout. Layouts have different fields for create, edit, and view modes. (formula fields rendered in view mode, not create mode). A collection of any of: • Create—used by `/ui-api/record-defaults/create/{apiName}` resource. • Edit—used by `/ui-api/record-defaults/clone/{recordId}` resource. • View—(Default) displays a record. | Optional | 41.0 |
| optionalFields | String[] | A collection of optional field names. If a field is accessible to the context user, it's included; if not, it isn't included but doesn't cause an error. Specify names in the format `ObjectApiName.FieldName`. You can get any field that has a named relationship to this record. No limit. | Optional | 41.0 |
| pageSize | Integer | The maximum number of child records to return on a page. | Optional | 41.0 |
| updateMru | Boolean | To add to the most recently used (MRU) list view, set to true. Default false. | Optional | 47.0 |

### 1-2. Get Record Layout Metadata
**Resource:** `GET /ui-api/layout/{objectApiName}` (objectApiName = supported object) · **Available 41.0** · **Response Body:** Record Layout

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| formFactor | String | Layout display size. One of: • Large—(Default) desktop. • Medium—tablet. • Small—phone. | Optional | 41.0 |
| layoutType | String | Layout type. One of: • Compact—record's key fields. • Full—(Default) full layout. | Optional | 41.0 |
| mode | String | Access mode (create/edit/view). One of: • Create—used by `/ui-api/record-defaults/create/{apiName}`. • Edit—used by `/ui-api/record-defaults/clone/{recordId}`. • View—(Default) displays a record. | Optional | 41.0 |
| recordTypeId | Id | The ID of the record type (RecordType object) for the new record. If not provided, the default record type is used. | Optional | 41.0 |

### 1-3. Get Values for a Picklist Field
**Resource:** `GET /ui-api/object-info/{objectApiName}/picklist-values/{recordTypeId}/{fieldApiName}` · **Available 41.0** · **Response Body:** Picklist Values
파라미터 표 없음 — URI path params만: `objectApiName`, `recordTypeId`, `fieldApiName`.

### 1-4. Get Values for All Picklist Fields of a Record Type
**Resource:** `GET /ui-api/object-info/{objectApiName}/picklist-values/{recordTypeId}` · **Available 42.0** · **Response Body:** Picklist Values Collection
> Apex static method available in API 66.0+: `getPicklistValuesByRecordType(objectApiName, recordTypeId)`.
> **Note:** Turn on source tracking in sandboxes for picklist values to appear correctly. Can also use Metadata API.

파라미터 표 없음.

### 1-5. Get Child Records
**Resource:** `GET /ui-api/records/${recordId}/child-relationships/${relationshipName}` · **Available 41.0** · **Response Body:** Record Collection
**Example:** `/ui-api/records/001R0000003I6CoIAK/child-relationships/Contacts` (paginated, default pageSize 5)

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| fields | String[] | Specifies the fields to return. If specified, the response is a union of `fields` and `optionalFields`. If the context user doesn't have access to a field, or the field doesn't exist, an error is returned. If unsure of access and you don't want failure, use `optionalFields`. Specify names in the format `ObjectApiName.FieldName`. No limit. | Optional | 41.0 |
| optionalFields | String[] | A collection of optional field names. Accessible fields included; inaccessible silently omitted (no error). Format `ObjectApiName.FieldName`. No limit. | Optional | 41.0 |
| page | Int | The page offset from which to begin returning records. Default 0 (first page). For page=2 and pageSize=10, the first record returned is the 21st record. | Optional | 41.0 |
| pageSize | Int | The maximum number of child records to return on a page. Default 5. | Optional | 41.0 |
| pageToken | String | A token that represents the page offset. | Optional | 44.0 |

### 1-6. Get a Record
**Resource:** `GET /ui-api/records/{recordId}` · **Available 41.0** · **Response Body:** Record
**Example:** `GET /ui-api/records/006R0000001rboIIAQ?layoutTypes=Compact&childRelationships=Opportunity.OpportunityCompetitors,Opportunity.Partners`

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| childRelationships | String[] | A collection of child relationship names included in the response. Format `ObjectApiName.ChildRelationshipName` or `ObjectApiName.ChildRelationshipName.FieldApiName`. e.g. `Account.Contacts`. One level deep. | Optional | 41.0 |
| includeFieldsInBody | Boolean | Specifies whether to return a field that's defined in the request body but not in the layout. Default false. When true, fields not in the layout are also included in the response body. | Optional | 59.0 |
| fields | String[] | Specifies the fields to return (union of `fields` and `optionalFields`). Access errors as above. Format `ObjectApiName.FieldName`. Child relationship records don't have layouts; specify them in `fields`. To return a base64 field, specify in `optionalFields`. **Note:** Polymorphic fields aren't supported (invalid field error). | In API 45.0+: either fields, optionalFields, or layoutTypes is required. Earlier: either fields or layoutTypes required. In all versions, to specify both fields and layoutTypes, must specify childRelationships. | 41.0 |
| layoutTypes | String[] | If specified, response is a union of `layoutTypes`, `modes`, and `optionalFields`. A collection of any of: • Compact—key fields. • Full—(Default) full layout. | In API 45.0+: either fields, optionalFields, or layoutTypes required. Earlier: either fields or layoutTypes required. In all versions, to specify both fields and layoutTypes, must specify childRelationships. | 41.0 |
| modes | String[] | Access mode (create/edit/view). A collection of any of: • Create—used by `/ui-api/record-defaults/create/{apiName}`. • Edit—used by `/ui-api/record-defaults/clone/{recordId}`. • View—(Default). | Optional if layoutTypes is specified. If layoutTypes not specified, this parameter is ignored. | 41.0 |
| optionalFields | String[] | Optional field names. Accessible included, inaccessible silently omitted. Format `ObjectApiName.FieldName`. To return a base64 field, specify here. | In API 45.0+: either fields, optionalFields, or layoutTypes required. Earlier: optionalFields is optional. | 41.0 |
| pageSize | Integer | The maximum number of child records to return on a page. | Optional | 41.0 |
| updateMru | Boolean | To add to the MRU list view, set true. Default false. | Optional | 47.0 |

### 1-7. Get a Batch of Records
**Resource:** `GET /ui-api/records/batch/{recordIds}` (comma-delimited) · **Available 41.0** · **Response Body:** Batch Results
**Example:** `GET /ui-api/records/batch/001R0000003I6CeIAK,001R0000003I6CgIAK?fields=Account.Name&childRelationships=Account.Contacts`

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| childRelationships | String[] | A collection of child relationship names included. Format `ObjectApiName.ChildRelationshipName` or `...FieldApiName`. e.g. `Account.Contacts`. One level deep. | Optional | 41.0 |
| includeFieldsInBody | Boolean | Whether to return a field defined in the request body but not in the layout. Default false. | Optional | 59.0 |
| fields | String[] | Union of fields and optionalFields. Access errors as above. Format `ObjectApiName.FieldName`. Child relationship records don't have layouts. base64 → optionalFields. Polymorphic fields aren't supported (invalid field error). | In API 45.0+: either fields, optionalFields, or layoutTypes required. Earlier: either fields or layoutTypes required. In all versions, to specify both fields and layoutTypes, must specify childRelationships. | 41.0 |
| layoutTypes | String[] | Union of layoutTypes, modes, optionalFields. Collection: • Compact—key fields. • Full—(Default). | Same requiredness logic as above. | 41.0 |
| modes | String[] | Access mode. • Create / • Edit / • View—(Default). | Optional if layoutTypes specified; else ignored. | 41.0 |
| optionalFields | String[] | Optional field names (accessible included, inaccessible omitted). Format `ObjectApiName.FieldName`. base64 → here. | In API 45.0+: fields/optionalFields/layoutTypes required. Earlier: optionalFields optional. | 41.0 |
| pageSize | Integer | Max child records per page. | Optional | 41.0 |
| updateMru | Boolean | Add to MRU. Default false. | Optional | 47.0 |

### 1-8. Create or Clone a Record
**Resource:** `POST /ui-api/records` · **Available 41.0** · **Response Body:** Record
**Usage:** Pass a Record Input request body. Find required fields/defaults via Get Default Values resources (Create/Create-Lightweight/Clone/Clone-Lightweight). Lookup/picklist values via Get Lookup Field Suggestions / Get Values for a Picklist Field / All Picklist Fields. As of API 43.0, passing read-only fields → Error with Output.
> **Note:** ProductMedia records can't be created with this resource. Use the ProductMedia object API instead.

**PDF 원문 예제:**
```
POST /ui-api/records
{
    "apiName": "Account",
    "fields": { "Name": "Universal Containers" }
}
// 주소 (compound field는 응답에만; 입력은 개별 필드)
{
    "apiName": "Account",
    "fields" : { "Name": "Local Boxes", "BillingState": "WA",
                 "BillingStreet" : "123 Main Street", "BillingCountry" : "USA" }
}
```

**Request Parameters:**

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| allowSaveOnDuplicate | Boolean | Whether to save a duplicate record. Default false. | Optional | 43.0 |
| handleOwnerChange | Boolean | Whether to return a 204 No Content if the context user loses access to the record during creation. Default false. When false, if user loses access during creation, creation completes but returns an incorrect 404 Not found. | Optional | 60.0 |
| triggerOtherEmail | Boolean | For a Case, whether to send email to users outside the organization (triggered by creating/editing/deleting a contact for a Case in the UI). Default false. See EmailHeader in SOAP API Developer Guide. | Optional | 51.0 |
| triggerUserEmail | Boolean | For a Case or Lead, whether to send email to users in the org (password reset, user creation, Case owner change, Case comments). For Case owner changes, also set useDefaultRule=true or no email sent. Default false. See EmailHeader in SOAP API Developer Guide. | Optional | 51.0 |
| useDefaultRule | Boolean | For a Case or Lead, whether to use the default (active) assignment rule. If specified, don't specify an assignmentRuleId. For Account, matching a territory filter assigns to that territory regardless of this setting. Default false. See AssignmentRuleHeader in SOAP API Developer Guide. | Optional | 51.0 |

**Request Body** = Record Input properties (1-8의 Record Input은 §2 B-23 Record Input과 동일 스키마):

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| allowSaveOnDuplicate | Boolean | Whether to save a duplicate record (true) or not (false). Default false. Don't specify this property when checking for duplicate records. | Optional | 43.0 |
| apiName | String | To create: specify the API name of an Object. To update: use null or don't pass. To check for duplicate records: specify the API name of the object for the duplicate check. | Required to create a record. Required to check for duplicate records. | 41.0 |
| fields | Map<String,Object> | Map of field names to field values. Format data types per rules: • Address—JSON String (compound; break into constituent fields). • Boolean—JSON Boolean. • Currency—JSON Number (67.54). • Date—JSON string (2020-04-20). • DateTime—JSON string ISO 8601 (2012-02-18T06:40:41.000Z). • Double—JSON Number. • Email—JSON String. • EncryptedString—JSON String. • Int—JSON Number. • Location—JSON String (compound). • MultiPicklist—JSON String (Dog;Cat;Fish). • Percent—JSON Number. • Phone—JSON String. • Picklist—JSON String. • Reference—JSON String. • String—JSON String. • TextArea—JSON String. • Time—JSON String HH:MM:SS. • Url—JSON String. To specify the main record type, either don't specify the RecordTypeId field, or set it to null. | Required | 41.0 |

> **참고 (별도 리소스, 같은 영역):** **Create a Batch of Records** — `POST /ui-api/records/batch`, Available 59.0. Request Body: `recordInput` (Batch Record Input, Required, 59.0). Request Parameter: `useDefaultRule` (Boolean, Optional, 64.0 — Case/Lead default assignment rule; Account default territory rules; default false). Response Body: Batch Results. Usage: must include required apiName in Batch Operation Input; don't include Id (else 400 INVALID_BATCH_REQUEST). 400 INVALID_INPUT causes: operations field missing/empty; operation type missing; operations missing records field or records empty.

### 1-9. Get Default Values to Clone a Record
**Resource:** `GET /ui-api/record-defaults/clone/{recordId}` · **Available 41.0** · **Response Body:** Record Defaults
> **Note:** For lightweight, use `/ui-api/record-defaults/template/clone/{recordId}`.

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| formFactor | String | Layout display size. • Large—(Default). • Medium. • Small. | Optional | 41.0 |
| optionalFields | String[] | Optional field names. Accessible included, inaccessible omitted (no error). Format `ObjectApiName.FieldName`. No limit. | Optional | 41.0 |
| recordTypeId | Id | ID of the record type for the new record. If not provided, the default record type is used. | Optional | 41.0 |

### 1-10. Get Default Values to Clone a Record—Lightweight
**Resource:** `GET /ui-api/record-defaults/template/clone/{recordId}` · **Available 49.0** · **Response Body:** Record Defaults Template Clone
**Example:** `GET /ui-api/record-defaults/template/clone/001d000000AtfRIAAZ?optionalFields=Account.OwnerId`

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| optionalFields | String[] | Optional field names (accessible included, inaccessible omitted). Format `ObjectApiName.FieldName`. No limit. If you don't pass any fields, the response includes only the ID of the cloned record in a field called CloneSourceId. | Optional | 49.0 |
| recordTypeId | Id | ID of the record type for the new record. Default record type if not provided. | Optional | 49.0 |

### 1-11. Get Default Values to Create a Record
**Resource:** `GET /ui-api/record-defaults/create/{objectApiName}` · **Available 41.0** · **Response Body:** Record Defaults
> **Note:** For lightweight, use `/ui-api/record-defaults/template/create/{objectApiName}`.

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| formFactor | String | Layout display size. • Large—(Default). • Medium. • Small. | Optional | 41.0 |
| optionalFields | String[] | Optional field names (accessible included, inaccessible omitted). Format `ObjectApiName.FieldName`. No limit. | Optional | 41.0 |
| recordTypeId | Id | ID of the record type for the new record. Default if not provided. | Optional | 41.0 |

### 1-12. Get Default Values to Create a Record—Lightweight
**Resource:** `GET /ui-api/record-defaults/template/create/{objectApiName}` · **Available 49.0** · **Response Body:** Record Defaults Template Create
**Example:** `GET /ui-api/record-defaults/template/create/Account?optionalFields=Account.OwnerId`

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| optionalFields | String[] | Optional field names (accessible included, inaccessible omitted). Format `ObjectApiName.FieldName`. No limit. If you don't pass any fields, the response doesn't include any fields. | Optional | 49.0 |
| recordTypeId | Id | ID of the record type for the new record. Default if not provided. | Optional | 49.0 |

### 1-13. Get Lookup Field Suggestions With POST
**Resource:** `POST /ui-api/lookups/{objectApiName}/{fieldApiName}` (objectApiName = source object; fieldApiName = lookup field on source object) · **Available 60.0** · **Response Body:** Lookup Values
**Examples:**
```
POST /ui-api/lookups/Opportunity/AccountId                         // Recent (default searchType)
POST /ui-api/lookups/Opportunity/AccountId?searchType=Search&q=ca
POST /ui-api/lookups/Opportunity/AccountId?searchType=TypeAhead&q=ta
```

**Request Parameters for POST:**

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| page | Integer | The page number. Default 1. | Optional | 60.0 |
| pageSize | Integer | The number of items per page. Default 25. | Optional | 60.0 |
| q | String | The term the user is searching for. When searchType=Search, specify at least 2 characters (trailing wildcard implied; q=ca returns Cat and Cats). When searchType=TypeAhead, specify at least 3 characters (trailing wildcard implied; can't use a `?`). | Required if searchType is TypeAhead. | 60.0 |
| searchType | String | Type of search. One of: • Recent—most recently used matches. • Search—records with searchable fields matching the query. • TypeAhead—records whose names start with the query term. Default Recent. | Optional | 60.0 |
| targetApiName | String[] | The API name of the object you want results for. Must correspond to one of the target objects of the lookup field. If not provided, results for all target objects are returned. If not specified, field configuration is used. For polymorphic fields, several queries considered → may cause performance issues. | Optional | 60.0 |

**Request Body for POST (Properties):**

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| orderBy | List Order By Input[] | Information describing how to order the results. | Optional | 63.0 |
| sourceRecord | Record Input | The source record in which the lookup relationship field is being edited. The presence of the source record "Id" is required within the "fields" property. Accepted values: "null" when creating a new record, valid record ID when updating. Some lookup fields have lookup filters restricting values by referencing fields on the source object (dependent lookup / controlling fields). You must pass all controlling fields and values within the "fields" property. To know whether a field is a lookup controlling field, check Object Info for a non-null filteredLookupInfo. Get field values from the Record response body. Both from `/ui-api/record-ui/{recordIds}`. Properties "allowSaveOnDuplicate" and "apiName" are not used. | Required | 60.0 |

**PDF 원문 예제 (dependent lookup):**
```
POST /ui-api/lookups/case/ContactId
{
    "sourceRecord": { "fields": { "Id": "500Z7000000bhdFIAQ", "AccountId": "001R0000003IG0MIAW" } },
    "orderBy": [ { "fieldApiName": "Name", "isAscending":true } ]
}
```

### 1-14. Check for Duplicate Records
**Resource:** `POST /ui-api/predupe` · **Available 50.0** · **Response Body:** Duplicates
> **Tip:** To learn when to check, see Get Duplicate Management Configuration for a Specified Object.

**PDF 원문 예제:**
```
ui-api/predupe{
"apiName" : "Movie__c",
"fields" : {"Name": "Aliens", "Year__c": "1986" }
```

**Request Body** (= Record Input subset):

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| allowSaveOnDuplicate | Boolean | Whether to save a duplicate record (true) or not (false). Default false. Don't specify this property when checking for duplicate records. | Optional | 43.0 |
| apiName | String | To create: API name of an Object. To update: null or don't pass. To check for duplicates: API name of the object for the check. | Required to create a record. Required to check for duplicate records. | 41.0 |
| fields | Map<String,Object> | Map of field names to field values. (Same data-type formatting rules as Record Input: Address/Boolean/Currency/Date/DateTime/Double/Email/EncryptedString/Int/Location/MultiPicklist/Percent/Phone/Picklist/Reference/String/TextArea/Time/Url — full list per Record Input.) | Required | 41.0 |

### 1-15. Get List View Records with URL Parameters
**Resource:** `GET /ui-api/list-records/${listViewId}` 또는 `GET /ui-api/list-records/${objectApiName}/${listViewApiName}` (listViewApiName 예: AllAccounts 또는 `__Recent`) · **Available 42.0** · **Response Body:** List Record Collection

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| fields | String[] | Additional fields queried for the records returned. These fields don't create visible columns. If the field isn't available to the user, an error occurs. | Optional | 42.0 |
| optionalFields | String[] | Additional fields queried. No visible columns. If unavailable to the user, no error occurs and the field isn't included. | Optional | 42.0 |
| pageSize | Integer | The number of list records viewed at one time. Default 50. Value 1–2000. | Optional | 42.0 |
| pageToken | String | A token that represents the page offset. Use with pageSize. Max offset 2000, default 0. | Optional | 42.0 |
| searchTerm | String | Search term to filter the results. Wildcards supported. | Optional | 61.0 |
| sortBy | String[] | API names of fields the list view is sorted by. Prefix `-` = descending (e.g. `Name` ascending, `-CreatedDate` descending). In API 63.0+, sort by up to five fields. | Optional | 42.0 |
| where | String | Filter applied to returned records, in GraphQL syntax. e.g. `{ and: [ { StageName: { eq: \"Prospecting\" } }, { Account: { Name: { eq: \"Dickenson plc\" } } } ] }`. | Optional | 61.0 |

**Request Body 변형 — Get List View Records with a Request Body:** `POST /ui-api/list-records/${objectApiName}/${listViewApiName}`, **Available 61.0**, Response List Record Collection.
**Request parameters for POST:**

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| listRecordsQuery | List Records Input | Record data to query for a list view. | Required | 61.0 |

**PDF 원문 예제:**
```
POST /services/data/v66.0/ui-api/list-records/Account/AllAccounts
{
    "fields": ["Name", "Type", "AnnualRevenue", "CreatedDate"],
    "pageSize" : 10, "sortBy": ["CreatedDate"],
    "searchTerm" : "United", "where": "{AnnualRevenue: { gt: 1000000}}"
}
```

### 1-16. Get Related List Records with URL Parameters
**Resource:** `GET /ui-api/related-list-records/${parentRecordId}/${relatedListId}` (relatedListId = API name of supported related list, e.g. Contracts; in API 62.0+ supports child relationship API name) · **Available 50.0** · **Response Body:** Related List Record Collection
> **Note:** To get record data without complex URL parameters, use POST (request body). See Get a Related List Records with a Request Body.

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| fields | String[] | Fields queried for the records returned. Included in the response body; don't create visible columns. If unavailable to the user, an error occurs. | Optional | 50.0 |
| optionalFields | String[] | Additional fields queried. Included; no visible columns. If unavailable, no error and field omitted. | Optional | 50.0 |
| pageSize | Integer | The number of list records viewed at one time. Default 50. Value 1–1999. | Optional | 50.0 |
| pageToken | String | The token for additional pages beyond the first. Use the value returned by `nextPageToken` from the previous page. | Optional | 50.0 |
| sortBy | String[] | API names of fields the related list is sorted by. Prefix `-` = descending. In API 63.0+, up to five fields. If a field is invalid or inaccessible, this parameter is ignored (no error). | Optional | 50.0 |
| where | String | **Note:** The where parameter isn't supported for GET requests. | Optional | 55.0 |

**Request Body 변형 — Get Related List Records with a Request Body:** `POST /ui-api/related-list-records/${parentRecordId}/${relatedListId}` (relatedListId 예: Contacts; API 62.0+ child relationship API name 지원), **Available 55.0**, Response Related List Record Collection.
**Request Parameters:**

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| listRecordsQuery | Related List Records Input | The record data for the related list. | Required | 55.0 |

**PDF 원문 예제:**
```
POST /ui-api/related-list-records/001xx000003GYOpAAO/Contacts
{
 "fields": ["Name", "Id", "Birthdate"], "optionalFields": ["Email"],
 "sortBy": ["CreatedDate"], "pageSize": 10,
 "where": "{ Account: { AnnualRevenue: { gt: 10000000 } }}"
}
```

---

## 2. Request Bodies (Ch4)

> 각 바디 표의 4번째 컬럼 = `Required or Optional`, 마지막 = `Available Version`. (예외: B-27만 4번째 컬럼이 `Filter Group and Version` 형식.)

### 2-B-1. Action Input
Get the actions on related lists on a record detail page.
**PDF 원문 예제:** `POST /services/data/v66.0/ui-api/actions/record/001R0000003IDlwIAG/related-list` body `{ "apiNames": ["New"], "retrievalMode": "All" }`

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| actionTypes | String[] | The action type. One or more of: • CustomButton—a button that opens a URL or Visualforce page or executes JavaScript. • ProductivityAction—a pre-defined Salesforce action, attached to a limited set of objects. • QuickAction—a global or object-specific action. • StandardButton—a pre-defined Salesforce button (New, Edit, Delete). | Optional | 57.0 |
| apiNames | String[] | The API names of one or more actions to be retrieved. Use only when passing retrievalMode=All. | Optional | 57.0 |
| formFactor | String | The layout display size. • Large—(Default). • Medium. • Small. | Optional | 57.0 |
| retrievalMode | String | When action context is Record, which actions to retrieve. • All—all actions specified in apiNames. • PageLayout—(Default) actions from the page layout. | Optional | 57.0 |
| sections | String[] | The section of the UI the actions reside in. One or more of: • ActivityComposer • CollaborateComposer • Page • SingleActionLinks | Optional | 57.0 |

### 2-B-2. Action Related List Single Batch Input
Get the actions on a batch of related lists for a record.
**PDF 원문 예제:** `POST .../actions/record/001R0000003IDlwIAG/related-list/batch` body `{ "relatedListsActionParameters": [ { "relatedListId": "Contacts", "apiNames": [ "New" ], "retrievalMode": "All" }, { "relatedListId": "Opportunities", "apiNames": ["New" ], "retrievalMode": "All" } ] }`

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| actionTypes | String[] | • CustomButton • ProductivityAction • QuickAction • StandardButton (same descriptions as Action Input). | Optional | 57.0 |
| apiNames | String[] | API names of actions; use only with retrievalMode=All. | Optional | 57.0 |
| formFactor | String | • Large—(Default) • Medium • Small. | Optional | 57.0 |
| relatedListId | String | The ID of the related list. | Optional | 57.0 |
| retrievalMode | String | • All • PageLayout—(Default). | Optional | 57.0 |
| sections | String[] | • ActivityComposer • CollaborateComposer • Page • SingleActionLinks. | Optional | 57.0 |

### 2-B-3. Action Related Lists Batch Input
Get the actions on a batch of related lists for a record.
**PDF 원문 예제:** (same as B-2 batch JSON).

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| relatedListsActionParameters | Action Related List Single Batch Input | Parameters for each related list in the batch request. | Required | 57.0 |

### 2-B-4. Batch Record Input
A description of multiple operations to create, update, or delete a batch of records.
**PDF 원문 예제:** `POST /ui-api/records/batch` body with `allOrNone:false`, `operations` containing CREATE (Account "ACCOUNT 1", Contact "Smith"), Update (Id 001xx000003Gaf9AAC, NumberOfEmployees 1000), Delete (Id 001xx000003GanDAAS).

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| allOrNone | Boolean | Whether to stop processing and rollback any changes when the request encounters an error. Default true. | Optional | 59.0 |
| operations | Batch Operation Input [] | A description of records and operation types. | Required | 59.0 |

### 2-B-5. Content Input
Upload a file or a new file version. To upload, provide the binary file in a multipart/form-data body part where name="fileData". See Upload Binary Files and Upload Files.
**PDF 원문 예제 (Uploading a File):** `POST /ui-api/records/content-documents/content-versions` body `{ "description": "A description of the product", "title": "product_image" }`
**PDF 원문 예제 (New Version):** `POST /ui-api/records/content-documents/0692L00000BDVevQAH/content-versions` body `{ "description": "Version 2 of the product image", "title": "product_image" }`

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| description | String | A description of the document or image to be uploaded. | Optional | 56.0 |
| title | String | The title of the document or image to be uploaded. | Optional | 56.0 |

### 2-B-6. Batch Operation Input
Represents the operation type and record data to create, update, and delete in a batch.
**PDF 원문 예제:** `"operations"` array with CREATE (Account "Global Media", Contact "Smith"), UPDATE (Id 001xx000003Gaf9AAC, NumberOfEmployees 1000), DELETE (Id 001xx000003GanDAAS).

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| type | String | The type of record operation. Valid values: • CREATE—Create a record or multiple records. • UPDATE—Update a record or multiple records. • DELETE—Delete a record or multiple records. | Required | 59.0 |
| records | Record Input [] | A description of a record or multiple records to create, update, and delete. | Required | 59.0 |

### 2-B-7. Favorite Batch Collection Input
A collection of all the favorites in a batch. Pass to update a batch of favorites.
**PDF 원문 예제:** `{ favorites: [ {id:"0MVR00000004DhnOAE", name:"Q4 Perf"}, {id:"0MVR00000004DhsOAE"}, {id:"0MVR00000004DiGOAU"}, {id:"0MVR000000001e2OAA", name:"Office Group"}, {id:"0MVR00000004GGlOAM"} ] }`

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| favorites | Favorite Batch Input[] | The list of favorites to keep and update. | Required | 41.0 |

### 2-B-8. Favorite Batch Input
Represents a single favorite when updating favorites in batch.
**PDF 원문 예제:** (same favorites array as B-7).

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| id | String | The ID of the favorite. | Required | 41.0 |
| name | String | The name of the favorite. | Required | 41.0 |

### 2-B-9. Favorite Input
A favorite to create or update.
**PDF 원문 예제:** `{ name: "Most Important Accounts", sortOrder: 1, target: "00BR0000000tTTwMAM", targetType: "ListView" }`

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| name | String | The name of the favorite. | Required for PATCH if sortOrder isn't specified. You may specify both. | 41.0 |
| sortOrder | Integer | The sort order of the favorite, from 1 to N. | Required for PATCH if name is unspecified. You may specify both. | 41.0 |
| target | String | The record, API name, or content being favorited. | Required in a POST request. Do not specify in a PATCH request. | 41.0 |
| targetType | String | The type of favorite. One of: • ListView—a favorited list view. • ObjectHome—a favorited object home. • Record—a favorited record. • Tab—a favorited tab. | Required in a POST request. Do not specify in a PATCH request. | 41.0 |

### 2-B-10. List Filter By Info Input
List filter by info to update or create.
**PDF 원문 예제:** `{ "fieldApiName": "Name", "operandLabels": [ "This", "That"], "operator": "Equals" }`

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| fieldApiName | String | API name for the field used to filter the list. | Optional | 61.0 |
| operandLabels | String[] | Values (or label if one exists) used to filter the list. | Optional | 61.0 |
| operator | String | Filter operator. Values: • Contains • Equals • Excludes • GreaterOrEqual • GreaterThan • Includes • LessOrEqual • LessThan • NotContain • NotEqual • StartsWith • Within | Optional | 61.0 |

### 2-B-11. List Info Input
Info to update a list.
**PDF 원문 예제:** `PATCH /services/data/v66.0/ui-api/list-info/Account/AllAccounts` with filteredByInfo (Name Equals This/That; Phone StartsWith 919; AnnualRevenue GreaterThan 1000000), filterLogicString "(1 OR 2) AND 3", label, scope (entity/00Gxx000000sjI8/701xx000003HZ7X), visibility Public.

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| displayColumns | String[] | Display columns (field API names) for the list. | Optional | 61.0 |
| filterLogicString | String | Filter logic string, such as (1 OR 2) and 3. Indexes start with 1. | Optional | 61.0 |
| filteredByInfo | List Filter By Info Input[] | Filtering information for the list. | Optional | 61.0 |
| label | String | List's display label, for example, All Accounts. | Optional | 61.0 |
| listShares | String[] | Objects the list is shared with, if visibility is shared. | Optional | 61.0 |
| scope | List Scope Input | Scope information for the list. | Optional | 61.0 |
| visibility | String | List's visibility. One of: • Private • Public • Shared | Optional | 61.0 |

### 2-B-12. List Info Post Input
Info to create a list.
**PDF 원문 예제:** `POST /services/data/v66.0/ui-api/list-info/Account` with listViewApiName "MyAccountListView", filteredByInfo (same 3 filters), filterLogicString, label, scope, visibility Public.

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| displayColumns | String[] | Display columns (field API names) for the list. | Optional | 61.0 |
| filterLogicString | String | Filter logic string, such as (1 OR 2) and 3. Indexes start with 1. | Optional | 61.0 |
| filteredByInfo | List Filter By Info Input[] | Filtering information for the list. | Optional | 61.0 |
| label | String | List's display label, for example, All Accounts. | Optional | 61.0 |
| listShares | String[] | Objects the list is shared with, if visibility is shared. For role sharing, use `Role.RoleAPIName`. For group sharing, use `groupType.GroupApiName`, where groupType is one of the type values for the Group object. | Optional | 61.0 |
| listViewApiName | String | API name for the list. Optional but strongly recommended. If unspecified, a default API name is generated. | Optional | 61.0 |
| scope | List Scope Input | Scope information for the list. | Optional | 61.0 |
| visibility | String | • Private • Public • Shared | Optional | 61.0 |

### 2-B-13. List Order By Input
Information describing how to order a related list (one field only). Use to update a related list.
**PDF 원문 예제:** `PATCH .../related-list-info/Account/Contracts` with orderedByInfo (Name isAscending true), userPreferences (columnWidths Name -1, columnWrap Name false).

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| fieldApiName | String | The API name for the field. | Optional | 50.0 |
| isAscending | Boolean | Indicates whether the list column is ascending or descending. | Optional | 50.0 |

### 2-B-14. List Preferences Input
List preferences to update.
**PDF 원문 예제:** `PATCH .../list-preferences/Account/AllAccounts` with columnWidths (Name 200), columnWrap (Name false), orderedBy (Name isAscending true).

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| columnWidths | Map<String,Integer> | Column width preferences to update. If you pass a null value, preferences reset to the default. | Optional | 61.0 |
| columnWrap | Map<String,Boolean> | Column wrap preferences to update. If you pass a null value, preferences reset to the default. | Optional | 61.0 |
| orderedBy | List Order By Input[] | Ordering preferences to update. If you pass a null value, preferences reset to the default. In API 63.0+, sort by up to five columns. Earlier versions sort by the first column. | Optional | 61.0 |

### 2-B-15. List Records Input
Record data to query for a list view.
**PDF 원문 예제:** `POST .../list-records/Account/AllAccounts` with fields, pageSize 10, sortBy CreatedDate, searchTerm "United", where "{AnnualRevenue: { gt: 1000000}}".

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| fields | String[] | Additional fields queried. Don't create visible columns. If unavailable to the user, an error occurs. | Optional | 61.0 |
| optionalFields | String[] | Additional fields queried. No visible columns. If unavailable, no error and field omitted. | Optional | 61.0 |
| pageSize | Integer | Number of list records viewed at one time. Default 50. Value 1–2000. | Optional | 61.0 |
| pageToken | String | A token that represents the page offset. Use with pageSize. Max offset 2000, default 0. | Optional | 61.0 |
| searchTerm | String | Search term to filter the results. Wildcards supported. | Optional | 61.0 |
| sortBy | String[] | API names of the fields the list view is sorted by. Prefix `-` = descending. In API 63.0+, up to five fields. | Optional | 61.0 |
| where | String | Filter applied in GraphQL syntax (e.g. `{ and: [ { StageName: { eq: \"Prospecting\" } }, { Account: { Name: { eq: \"Dickenson plc\" } } } ] }`). | Optional | 61.0 |

### 2-B-16. List Scope Input
List scope to update or create.
**PDF 원문 예제:** `{ "apiName": "entity", "entityId": "00Gxx000000sjI8", "relatedEntityId": "701xx000003HZ7X" }`

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| apiName | String | API name of the list's scope. | Optional | 61.0 |
| entityId | String | ID of the scope's entity. | Optional | 61.0 |
| relatedEntityId | String | ID of the related entity for the scope. | Optional | 61.0 |

### 2-B-17. List User Preference Input
A related list user preferences to update.
**PDF 원문 예제:** `PATCH .../related-list-info/Account/Contracts` with orderedByInfo + userPreferences (columnWidths Name -1, columnWrap Name false).

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| columnWidths | Map<String,Integer> | Column width preferences. -1 indicates default width. | Optional | 50.0 |
| columnWrap | Map<String,Boolean> | Indicates whether the column text wraps. | Optional | 50.0 |

### 2-B-18. Lookup Post Input
Get lookup field suggestions.
**PDF 원문 예제 (dependent lookup):** `POST /ui-api/lookups/case/ContactId` with sourceRecord (Id, AccountId) and orderBy (Name isAscending true). (전체 dependent-lookup 설명 JSON은 §1 1-13 예제와 동일 구조.)

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| orderBy | List Order By Input[] | Information describing how to order the results. | Optional | 63.0 |
| sourceRecord | Record Input | The source record in which the lookup relationship field is being edited. The presence of the source record "Id" is required within the "fields" property. Accepted values: "null" when creating a new record, valid record ID when updating. Some lookup fields have lookup filters (dependent lookup / controlling fields); you must pass all controlling fields and values within the "fields" property. To know whether a field is a lookup controlling field, check Object Info for a non-null filteredLookupInfo. Get field values from the Record response body. Both from `/ui-api/record-ui/{recordIds}`. Properties "allowSaveOnDuplicate" and "apiName" are not used. | Required | 60.0 |

### 2-B-19. Navigation Item Collection Input
A collection of all the navigation items (tabs) for an app. Pass to get or update a user's personalized navigation items.
**PDF 원문 예제:** `{ "navItems": [{ "id": "0QkRM00000058lN0AQ" }, { "id": "0QkRM00000058lR0AQ", "label": "My Top Account" }, { "pageReference": { "type": "standard__objectPage", "attributes": { "objectApiName": "Dashboard", "actionName": "home" }, "state": {} } }] }`

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| navItems | Navigation Item Input[] | The list of navigation items in the order that you want them to appear in the app. | Required | 47.0 |

### 2-B-20. Navigation Item Input
Represents the list of navigation items in the order that you want them to appear in the app.
**PDF 원문 예제:** `PUT /services/data/v66.0/ui-api/apps/06mRM000000U6pOYAS/user-nav-items` with navItems array (same as B-19).

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| id | String | The ID of the navigation item to include. | Required | 47.0 |
| label | String | The updated label for the navigation item in list views and records only. | Optional | 47.0 |
| pageReference | Page Reference Input | The page reference of the navigation item to add to the list. You can add one page reference per request. | Optional | 47.0 |

### 2-B-21. Page Reference Input
pageReference describing a navigation item's page type, attributes, and state.
**PDF 원문 예제:** `PUT .../apps/06mRM000000U6pOYAS/user-nav-items` with navItems array (same).

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| type | String | The page reference type generates a unique URL format and defines attributes that apply to all pages of that type. See PageReference Types. | Required | 47.0 |
| attributes | Map<String,Object> | Map of values for each attribute specified by the page definition, for example, objectAPIName or actionName. | Required | 47.0 |
| state | Map<String,Object> | Map of conditional values that customize content on the page, such as filterName. | Optional | 47.0 |

### 2-B-22. Perform Action Input
Perform a quick action that creates or updates a record.
**PDF 원문 예제:** `POST .../actions/perform-quick-action/Account.CreateContact` body `{ "apiName": "Contact", "contextId": "001RO000003zKtEYAU", "fields": { "LastName": "Rogers" "Title": "VP, Facilities" } }`

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| allowSaveOnDuplicate | Boolean | Whether to save a duplicate record (true) or not (false). Default false. | Optional | 57.0 |
| apiName | String | To API name of the object to create or update. | Required | 57.0 |
| contextId | String | The ID of the related record for the quick action. | Required for performing object-specific quick actions. Optional for performing global quick actions. | 57.0 |
| fields | Map<String,Object> | Map of field names to field values. | Required | 57.0 |

### 2-B-23. Record Input
A description of a record to use in a request to create or update a record or to check for duplicate records.
**PDF 원문 예제:** `POST /ui-api/records` body `{ "apiName": "Account", "fields": { "Name": "Universal Containers" } }` and the address variant (Local Boxes / BillingState WA / BillingStreet / BillingCountry USA).

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| allowSaveOnDuplicate | Boolean | Whether to save a duplicate record (true) or not (false). Default false. Don't specify this property when checking for duplicate records. | Optional | 43.0 |
| apiName | String | To create: API name of an Object. To update: null or don't pass. To check for duplicates: API name of the object. | Required to create a record. Required to check for duplicate records. | 41.0 |
| fields | Map<String,Object> | Map of field names to field values. Data-type rules: • Address—JSON String (compound). • Boolean—JSON Boolean. • Currency—JSON Number (67.54). • Date—JSON string (2020-04-20). • DateTime—JSON string ISO 8601 (2012-02-18T06:40:41.000Z). • Double—JSON Number. • Email—JSON String. • EncryptedString—JSON String. • Int—JSON Number. • Location—JSON String (compound). • MultiPicklist—JSON String (Dog;Cat;Fish). • Percent—JSON Number. • Phone—JSON String. • Picklist—JSON String. • Reference—JSON String. • String—JSON String. • TextArea—JSON String. • Time—JSON String HH:MM:SS. • Url—JSON String. To specify the main record type, either don't specify the RecordTypeId field, or set it to null. | Required | 41.0 |

### 2-B-24. Related List Input
A related list to update.
**PDF 원문 예제:** `PATCH .../related-list-info/Account/Contracts` with orderedByInfo + userPreferences.

| Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| orderedByInfo | List Order By Input[] | A related list's ordering information. In API 63.0+, sort by up to five fields. | Optional | 50.0 |
| userPreferences | List User Preference Input | A related list's user preferences. | Optional | 50.0 |

### 2-B-25. Related List Records Input
Get record data for up to 1,999 records in a related list.
**PDF 원문 예제:** `POST /ui-api/related-list-records/001xx000003GYOpAAO/Contacts` body `{ "fields": ["Name", "Id", "Birthdate"], "optionalFields": ["Email"], "sortBy": ["CreatedDate"], "pageSize": 10, "where": "{ Account: { AnnualRevenue: { gt: 10000000 } }}" }`

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| fields | String[] | Fields queried. Included in the response body; don't create visible columns. If unavailable, an error occurs. | Optional | 55.0 |
| includeColumnLabels | Boolean | Whether to include column labels in the results for localization (true) or not (false). Defaults to false if unspecified. | Optional | 65.0 |
| optionalFields | String[] | Additional fields queried. Included; no visible columns. If unavailable, no error and field omitted. | Optional | 55.0 |
| pageSize | Integer | Number of list records viewed at one time. Default 50. Value 1–1999. | Optional | 55.0 |
| pageToken | String | The token for additional pages beyond the first. Use `nextPageToken` from the previous page. | Optional | 55.0 |
| sortBy | String[] | API names of the fields the related list is sorted by. Prefix `-` = descending. In API 63.0+, up to five fields. If invalid/inaccessible, ignored (no error). | Optional | 55.0 |
| where | String | Filter applied in GraphQL syntax (e.g. `{ and: [ { StageName: { eq: \"Prospecting\" } }, { Account: { Name: { eq: \"Dickenson plc\" } } } ] }`). | Optional | 55.0 |

### 2-B-26. Related List Records Batch Input
Get record data for a batch of related lists.
**PDF 원문 예제:** `POST /ui-api/related-list-records/batch/001xx000003GYOpAAO` body with `relatedListParameters` array (Contacts + Opportunities, each with fields/optionalFields/sortBy/pageSize/where).

| Parameter Name | Type | Description | Req/Opt | Available |
|---|---|---|---|---|
| relatedListId | String | The ID of the related list that you want to get records for. | Required | 55.0 |
| fields | String[] | Fields queried. Included; no visible columns. If unavailable, an error occurs. | Optional | 55.0 |
| optionalFields | String[] | Additional fields queried. Included; no visible columns. If unavailable, no error and field omitted. | Optional | 55.0 |
| pageSize | Integer | The number of records from all lists in the request viewed at one time. Default 50. Value 1–1999. | Optional | 55.0 |
| sortBy | String[] | API names of the fields the related list is sorted by. Prefix `-` = descending. In API 63.0+, up to five fields. If invalid/inaccessible, ignored (no error). | Optional | 55.0 |
| where | String | Filter applied in GraphQL syntax (same example). | Optional | 55.0 |

### 2-B-27. Related List User Preferences Input
User preferences to update for a related list.
> ⚠️ 이 바디만 표 헤더가 `Property Name · Type · Description · Filter Group and Version · Available Version` 형식(다른 Ch4 바디와 다름). 4번째 컬럼 값은 `Small, 55.0`.
**PDF 원문 예제:** `PATCH .../related-list-preferences/Account.RelatedContactList` body `{ "columnWidths" : { "Name" : 200 }, "columnWrap" : { "Name" : false }, "orderedBy" : [{ "fieldApiName": "Name", "isAscending" : true }] }`

| Property Name | Type | Description | Filter Group and Version | Available |
|---|---|---|---|---|
| columnWidths | Map<String,Integer> | Column width preferences for the related list. -1 indicates default width. | Small, 55.0 | 55.0 |
| columnWrap | Map<String,Boolean> | Indicates whether the column text wraps. | Small, 55.0 | 55.0 |
| orderedBy | List Order By Input[] | Ordering information for the related list. In API 63.0+, sort by up to five fields. | Small, 55.0 | 55.0 |

---

## 3. Response Bodies (Ch5)

> 모든 Ch5 표: `Property · Type · Description · Filter Group and Version (FilterGrp,Ver) · Available Version (Avail)`. 4번째 컬럼과 5번째 컬럼은 별도 컬럼이다 (§0 참조).

### 3-1. Top-Level

#### Action
The actions for a single record or a collection of records.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| actions | Map<String, Object Action> | A map of record IDs to the actions for each record. | Small, 41.0 | 41.0 |
| url | String | The URL of the current request. | Big, 41.0 | 41.0 |

#### App
The metadata for a single app.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| appId | String | The unique ID of the app. | Small, 43.0 | 43.0 |
| description | String | A description of the app. | Small, 43.0 | 43.0 |
| developerName | String | The API name of the app. | Small, 43.0 | 43.0 |
| formFactors | String[] | The form factor of the app. One or more of: • Large—desktop. • Medium—tablet. • Small—phone. | Medium, 43.0 | 43.0 |
| headerColor | String | The primary color for the app as selected by an admin. e.g. #0070D2. | Small, 43.0 | 43.0 |
| iconUrl | String | The URL for the app's icon. | Small, 43.0 | 43.0 |
| isNavAutoTempTabsDisabled | Boolean | If true, the navigation automatically creates temporary tabs settings. | Small, 43.0 | 43.0 |
| isNavPersonalizationDisabled | Boolean | If true, navigation personalization is disabled. | Small, 43.0 | 43.0 |
| isNavTabPersistenceDisabled | Boolean | If true, workspace tabs are cleared for each new console session. | Small, 54.0 | 54.0 |
| isOmniPinnedViewEnabled | Boolean | If true, the Omni-Channel sidebar is enabled. | Small, 60.0 | 60.0 |
| label | String | The label of the app. | Small, 43.0 | 43.0 |
| logoUrl | String | The logo URL of the app as selected by the admin. | Medium, 43.0 | 43.0 |
| mobileStartUrl | String | The mobile launch URL for the app. Used with client apps and Experience Builder sites. For sites, a fully qualified domain name; for other apps, a relative URL. | Medium, 43.0 | 43.0 |
| navItems | Navigation Item[] | The metadata for the navigation tabs of the app. **Note:** Only navItems with supported formFactors values are returned. | Big, 43.0 | 43.0 |
| selected | Boolean | If true, this app is the default app for the user. | Big, 43.0 | 43.0 |
| startUrl | String | The launch URL of the app. | Medium, 43.0 | 43.0 |
| type | String | The type of the app. One of: • Classic • Community • Connected • ExternalClient • Lightning | Small, 47.0 | 47.0 |
| uiType | String | The UI type. One of: • Salesforce Classic • Lightning Experience. Deprecated in API 47.0; in 47.0+ use type instead. | Small, 43.0–46.0 | 43.0–46.0 |
| userNavItems | Navigation Item[] | The user's navigation tabs for the app. | Big, 43.0 | 43.0 |

#### Apps
A list of apps that the current user has access to.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apps | App[] | Metadata for an app. | Small, 43.0 | 43.0 |

#### Batch Results
The results from a request to a batch resource.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| hasErrors | Boolean | true if at least one of the results is an HTTP status code in the 400 or 500 range; false otherwise. | Small, 41.0 | 41.0 |
| results | Batch Result Item[] | Collection of batch result items. | Small, 41.0 | 41.0 |

#### Content Document Composite
The file and its relationship to a record.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| contentDocument | Record | The record associated with the content document. | Small, 56.0 | 56.0 |
| contentDocumentLinks | Record[] | The relationship between a record and a content document. | Small, 56.0 | 56.0 |
| contentVersion | Record | The record associated with the content document. Creating a new content version also creates a content document. | Small, 56.0 | 56.0 |

#### CSRF Token
Cross-Site Request Forgery (CSRF) token.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| csrfToken | String | CSRF token string. | Big, 67.0 | 67.0 |

#### Duplicates
The results of a check for duplicate records.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| allowSave | Boolean | Whether this duplicate record can be saved (true) or not (false). | Small, 50.0 | 50.0 |
| duplicateError | Boolean | Whether duplicate records exist (true) or not (false). | Small, 50.0 | 50.0 |
| duplicateRules | String[] | A list of the duplicate rules used to determine whether duplicate records exist. | Small, 50.0 | 50.0 |
| matches | Match[] | The IDs of the duplicate records. | Small, 50.0 | 50.0 |

#### Duplicates Configuration
Info about duplicate management config for an object.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | The API name of the object. | Small, 50.0 | 50.0 |
| dedupeEnabled | Boolean | Whether any duplicate rules are active for the object (true) or not (false). | Small, 50.0 | 50.0 |
| dedupeFields | String[] | The fields used to determine whether a record is a duplicate. Lists all fields used in all currently active matching rules. | Small, 50.0 | 50.0 |
| duplicateRules | Duplicate Rule[] | The duplicate rules active for the object. | Small, 50.0 | 50.0 |
| predupeEnabled | Boolean | Whether matching rules are active for the object (true) or not (false). | Small, 50.0 | 50.0 |

#### Favorite
A single favorite.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| accessCount | Integer | The number of times this favorite has been used. | Big, 41.0 | 41.0 |
| iconColor | String | The color of the icon for this favorite, usually the related object's color. | Big, 41.0 | 41.0 |
| iconUrl | String | The URL of the icon for the favorite, usually the related object's icon. | Big, 41.0 | 41.0 |
| id | String | The ID of the favorite. | Small, 41.0 | 41.0 |
| lastAccessDate | String | The last time this favorite was used. ISO 8061 date and time format. | Big, 41.0 | 41.0 |
| name | String | The name of the favorite. | Small, 41.0 | 41.0 |
| objectType | String | The developer name of the entity associated with this favorite, if any. | Medium, 41.0 | 41.0 |
| sortOrder | Integer | The sort order of the favorite, from 1 to N. | Small, 41.0 | 41.0 |
| subtitle | String | The subtitle of the favorite, usually the object's label. Provides additional info about the type of record or content being favorited. | Medium, 41.0 | 41.0 |
| target | String | The record, API name, or content being favorited. | Small, 41.0 | 41.0 |
| targetType | String | The type of record or content being favorited. One of: • ListView • ObjectHome • Record • Tab | Small, 41.0 | 41.0 |

#### Favorite Collection
A list of favorites.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| favorites | Favorite[] | A list of favorites. | Small, 41.0 | 41.0 |

#### List Info
Metadata that describes a list.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| cloneable | Boolean | Whether the list can be cloned. | Small, 42.0 | 42.0 |
| createable | Boolean | Whether a list for the object can be created. | Small, 42.0 | 42.0 |
| deletable | Boolean | Whether the list can be deleted. | Small, 42.0 | 42.0 |
| displayColumns | List Column[] | All display columns for the list. | Small, 42.0 | 42.0 |
| filterLogicString | String | The filter logic string, such as (1 OR 2) and 3. Indexes start with 1. | Small, 42.0 | 42.0 |
| filteredByInfo | List Filter by Info[] | Filtering information for the list. | Small, 42.0 | 42.0 |
| hasMassActions | Boolean | Whether the list has mass actions. | Small, 62.0 | 62.0 |
| id | List Reference | Identity information for the list. | Small, 42.0 | 42.0 only |
| inlineEditDetails | List Inline Edit Details | Inline edit details for the list. | Small, 61.0 | 61.0 |
| label | String | The list's display label. e.g. All Accounts. | Small, 42.0 | 42.0 |
| listReference | List Reference | Object representing the list. | Small, 43.0 | 43.0 |
| listShares | List Info Share Category | Items that the list is shared with. | Small, 61.0 | 61.0 |
| listViewApiName | String | The list's API name. e.g. AllAccounts or __Recent (MRU). | Small, 42.0 | 42.0 only |
| objectApiNames | String[] | API names of objects returned by the list. | Small, 61.0 | 61.0 |
| orderedByInfo | List Order By Info[] | Ordering information for the list. | Small, 42.0 | 42.0 |
| scope | List Scope | Scope information for the list. | Small, 61.0 | 61.0 |
| searchable | Boolean | Whether the list can be searched. | Small, 61.0 | 61.0 |
| updateable | Boolean | Whether the list can be updated. | Small, 42.0 | 42.0 |
| userPreferences | List User Preference | User preferences for the list. | Small, 42.0 | 42.0 |
| visibility | String | Visibility of the list. One of: • Private • Public • Shared | Small, 42.0 | 42.0 |
| visibilityEditable | Boolean | Whether the visibility of the list can be edited. | Small, 42.0 | 42.0 |

#### List Info Summary Collection
List info summary collection.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| count | Integer | Total count of lists returned. | Small, 61.0 | 61.0 |
| currentPageToken | String | Page token of the current page of lists. | Small, 61.0 | 61.0 |
| currentPageUrl | String | URL of the current page of lists. | Small, 61.0 | 61.0 |
| lists | List Info Summary[] | Collection of list summaries. | Small, 61.0 | 61.0 |
| nextPageToken | String | Page token of the next page of lists. | Small, 61.0 | 61.0 |
| nextPageUrl | String | URL of the next page of lists. | Small, 61.0 | 61.0 |
| objectApiName | String | API name of the object in the URL. | Small, 61.0 | 61.0 |
| pageSize | Integer | Page size specified in the query parameter or the default value. | Small, 61.0 | 61.0 |
| previousPageToken | String | Page token of the previous page of lists. | Small, 61.0 | 61.0 |
| previousPageUrl | String | URL of the previous page of lists. | Small, 61.0 | 61.0 |
| queryString | String | Query string specified in the query parameter or null. | Small, 61.0 | 61.0 |
| recentListsOnly | Boolean | Whether recent lists only were returned (true) or not (false). | Small, 61.0 | 61.0 |

#### List Object Info
List object info.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| availableScopes | List Object Scope[] | Information about available scopes for the object. | Small, 61.0 | 61.0 |
| columns | List Object Column[] | Information about available columns for the object. | Small, 61.0 | 61.0 |
| createable | Boolean | Whether a new list for the object can be created (true) or not (false). | Small, 61.0 | 61.0 |
| objectApiName | String | Object API name. | Small, 61.0 | 61.0 |
| publicCreatable | Boolean | Whether the context user can create a public list view for the object (true) or not (false). | Small, 67.0 | 67.0 |
| publicOrSharedCreatable | Boolean | Whether the context user can create a new public or shared list view (true) or not (false). In version 67.0+, use publicCreatable or sharedCreatable for this information. | Small, 61.0 | 61.0–66.0 |
| relatedEntityApiName | String | API name of the related object to which this list can be scoped, or null. | Small, 61.0 | 61.0 |
| sharedCreatable | Boolean | Whether the context user can create a shared list view for the object (true) or not (false). | Small, 67.0 | 67.0 |

#### List Preferences
List preferences.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| columnWidths | Map<String,Integer> | Column width preferences for the list. | Small, 61.0 | 61.0 |
| columnWrap | Map<String,Boolean> | Column wrapping preferences for the list. | Small, 61.0 | 61.0 |
| listReference | List Reference | Reference information for the list. | Small, 61.0 | 61.0 |
| orderedBy | List Order By Info[] | Ordering preference for the list. | Small, 61.0 | 61.0 |

#### List Record Collection
A collection of list view records.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| count | Integer | The total count of records returned. | Small, 43.0 | 43.0 |
| currentPageToken | String | The token for the current page of records. | Small, 43.0 | 43.0 |
| currentPageUrl | String | The URL of the current page of records. | Small, 43.0 | 43.0 |
| fields | String[] | List of fields specified in the request. If a field isn't available to the user, an error occurs. | Small, 48.0 | 48.0 |
| listInfoETag | String | An ETag that indicates whether the metadata has changed. | Small, 42.0 | 42.0 |
| listReference | List Reference | The list the records belong to. | Small, 48.0 | 48.0 |
| nextPageToken | String | The token for the next page of records. | Small, 43.0 | 43.0 |
| nextPageUrl | String | The URL of the next page of records. | Small, 43.0 | 43.0 |
| optionalFields | String[] | Optional fields specified in the request. If unavailable, no error and field omitted. | Small, 48.0 | 48.0 |
| pageSize | Integer | The number of list records viewed at one time. Default 50. | Small, 48.0 | 48.0 |
| previousPageToken | String | The token for the previous page of records. | Small, 43.0 | 43.0 |
| previousPageUrl | String | The URL of the previous page of records. | Small, 43.0 | 43.0 |
| records | Record[] | A collection of records. | Small, 43.0 | 43.0 |
| searchTerm | String | Search term specified in the request. | Small, 61.0 | 61.0 |
| sortBy | String | The API name of the field the list view is sorted by. Prefix `-` = descending. | Small, 48.0 | 48.0 |
| where | String | Where string specified in the request. | Small, 61.0 | 61.0 |

#### Lookup Values
Records, organized by object type, and metadata in a lookup relationship.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| lookupResults | Map<String, Record Collection> | A map of object API names to Record Collection response bodies containing the lookup results for that object type. | Small, 41.0 | 41.0 |
| metadata | Map<String, Lookup Metadata> | A map of object API names to Lookup Metadata response bodies containing the metadata results. | Small, 55.0 | 55.0 |

#### Navigation Items
An ordered list of navigation items (tabs) for the current user.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| navItems | Navigation Items[] | Metadata for navigation tabs. | Small, 43.0 | 43.0 |
| currentPageUrl | String | URL to the current page of navigation tabs. | Medium, 45.0 | 45.0 |
| nextPageUrl | String | URL to the next page of navigation tabs. | Medium, 45.0 | 45.0 |

#### Object Info
The metadata for an object.
> **Important (PDF callout):** Where possible, we changed noninclusive terms to align with our company value of Equality. Because changing terms in our code can break current implementations, we maintained this metadata type's name.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | The object's API name. | Small, 41.0 | 41.0 |
| associateEntityType | String | If the object is associated with a parent object, the type of association (such as History). Otherwise null. | Medium, 50.0 | 50.0 |
| associateParentEntity | String | If associated with a parent object, the parent object it's associated with. Otherwise null. | Medium, 50.0 | 50.0 |
| childRelationships | Child Relationship[] | The object's child relationships. | Medium, 41.0 | 41.0 |
| compactLayoutable | Boolean | Whether the object can have compact layouts. | Small, 60.0 | 60.0 |
| createable | Boolean | Whether the object can be created. | Small, 41.0 | 41.0 |
| custom | Boolean | Whether the object is custom. | Small, 41.0 | 41.0 |
| defaultRecordTypeId | String | The ID for the default record type for this object, if any. If no default, this is the master record type (012000000000000AAA). If the record is a nested record, the value is null. | Medium, 41.0 | 41.0 |
| deleteable | Boolean | Whether the object can be deleted. Only available in API version 41.0. In API version 42.0, we spelled it correctly. | Small, 41.0 | 41.0–41.0 |
| deletable | Boolean | Whether the object can be deleted. | Small, 42.0 | 42.0 |
| dependentFields | Map<String,Object> | A map of the dependent fields tree structure. Each nested object is another Map<String, Object>. When the object is empty, it's a leaf (a field that doesn't control other fields). An object can have multiple independent trees → multiple root objects. Example (Continents__c→Countries__c→Cities__c): `"dependentFields" : { "Continents__c" : { "Countries__c" : { "Cities__c" : { } } } }`. Field dependency dynamically filters picklist values based on a controlling field. Controlling fields: standard/custom checkboxes and picklists with ≥1 and <300 values. Dependent fields: custom picklists and multi-select picklists. | Big, 42.0 | 42.0 |
| feedEnabled | Boolean | Whether the object can have feeds. | Medium, 41.0 | 41.0 |
| fields | Map<String, Field> | A map of field API name to field info. Only contains fields relevant to the requested layout and mode. | Medium, 41.0 | 41.0 |
| keyPrefix | String | The key prefix for IDs of this object. | Medium, 41.0 | 41.0 |
| label | String | The object's display label. | Small, 41.0 | 41.0 |
| labelPlural | String | The plural form of the object's display label. | Medium, 41.0 | 41.0 |
| layoutable | Boolean | Whether the object can have a layout. | Small, 41.0 | 41.0 |
| mruEnabled | Boolean | Whether the object can appear in Most Recently Used lists. | Small, 41.0 | 41.0 |
| nameFields | String[] | A collection of the API names of the fields used to identify the name field. Typically one per object, except where FirstName and LastName are used. | Medium, 41.0 | 41.0 |
| queryable | Boolean | Whether the context user can query the object. | Small, 41.0 | 41.0 |
| recordTypeInfos | Map<String, Record Type Info> | A map of record type IDs to record type info. All record types are visible whether or not the user has access. | Medium, 41.0 | 41.0 |
| searchable | Boolean | Whether the object can be searched. | Small, 41.0 | 41.0 |
| searchLayoutable | Boolean | Whether the object can have search layouts. | Small, 60.0 | 60.0 |
| themeInfo | Theme Info | Theme information for the object. | Medium, 41.0 | 41.0 |
| updateable | Boolean | Whether the object can be updated. | Small, 41.0 | 41.0 |

#### Object Info Directory
A directory of objects supported by UI API and available to the context user.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| objects | Map<String, Object Info Directory Entry> | A map of objects supported by UI API to their object info directory entries. | Small, 42.0 | 42.0 |

#### Picklist Values
The picklist values for a field, scoped to a record type.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| controllerValues | Map<String,Integer> | If the picklist is dependent, a map of its immediate controlling field's picklist values to their indexes. If the controlling field is a picklist, the String is the picklist value and the integer is the value's index. If a checkbox, the values are "false": 0 and "true": 1. If the picklist is independent, the map is empty. | Small, 41.0 | 41.0 |
| defaultValue | Picklist Value | The default value for the picklist, or null if there isn't one. | Small, 41.0 | 41.0 |
| url | String | A UI API resource that represents this payload. | Small, 41.0 | 41.0 |
| values | Picklist Value[] | A list of values for this object, record type, field combination. | Small, 41.0 | 41.0 |

#### Picklist Values Collection
A collection of picklist values for all the picklists of a specified record type.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| picklistFieldValues | Map<String, Picklist Values> | A map of field names to Picklist Values response bodies. Contains all picklist values for all picklists of a specified record type, including dependent picklists. Non-picklist fields aren't represented. | Small, 42.0 | 42.0 |

#### Quick Action Execution
The results returned when a quick action executes.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| contextId | String | The ID of the related record for the quick action. | Small, 57.0 | 57.0 |
| feedItemId | String | The ID of the feed item that the action created. | Small, 57.0 | 57.0 |
| id | String | The ID of the record that the action created or updated. | Small, 57.0 | 57.0 |
| isCreated | Boolean | Whether the action created records (true) or not (false). | Small, 57.0 | 57.0 |
| isSuccess | Boolean | Whether the action executed successfully (true) or not (false). | Small, 57.0 | 57.0 |
| successMessage | String | The action's success message. | Small, 57.0 | 57.0 |

#### Quick Action Layout
The record layout used by the quick action.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| actionApiName | String | The name of the quick action. | Small, 58.0 | 58.0 |
| layout | Record Layout | Information about the layout used by the quick action. | Small, 58.0 | 58.0 |

#### Record
The field data, API name, child relationship data, and record type information for a record.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | The API name for this record. | Small, 41.0 | 41.0 |
| childRelationships | Map<String, Record Collection> | The child relationship data for this record. | Small, 41.0 | 41.0 |
| fields | Map<String, Field Value> | The field data for this record, matching the requested layout and mode. | Small, 41.0 | 41.0 |
| id | String | The ID of this record. | Small, 41.0 | 41.0 |
| lastModifiedById | String | The ID of the user who last updated this record. | Small, 44.0 | 44.0 |
| lastModifiedDate | String | The date and time when a user last modified this record. ISO 8601 format. | Small, 44.0 | 44.0 |
| recordTypeId | String | The record type ID for this record. | Small, 48.0 | 48.0 |
| recordTypeInfo | Record Type Info | The record type info for this record, if any. Returned for only two levels of nested records. Instead, use recordTypeId (returned for every record). | Small, 41.0 | 41.0 |
| systemModstamp | String | The date and time when a user or automated process (such as a trigger) last modified this record. ISO 8601 format. | Small, 44.0 | 44.0 |

#### Record Collection
A paginated collection of Record response bodies.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| count | Integer | The total count of records returned. | Small, 41.0 | 41.0 |
| currentPageToken | String | Token identifying the current page. | Small, 44.0 | 44.0 |
| currentPageUrl | String | UI API URL identifying the current page. | Small, 41.0 | 41.0 |
| nextPageToken | String | Token identifying the next page, or null if there isn't a next page. | Small, 44.0 | Small, 44.0 |
| nextPageUrl | String | UI API URL identifying the next page. | Small, 41.0 | Small, 41.0 |
| previousPageToken | String | Token identifying the previous page, or null if there isn't a previous page. | Small, 44.0 | 44.0 |
| previousPageUrl | String | UI API URL identifying the previous page. | Small, 41.0 | 41.0 |
| records | Record[] | A collection of records. | Small, 41.0 | 41.0 |

#### Record Defaults
Default information and data needed to create or clone a record (use in POST /ui-api/records).

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| layout | Record Layout | Record layout information. | Medium, 41.0 | 41.0 |
| objectInfo | Object Info | Object metadata. | Big, 41.0 | 41.0-41.0 |
| objectInfos | Map<String, Object Info> | A map of object metadata. | Big, 42.0 | 42.0 |
| record | Record | Pre-populated record data. | Small, 41.0 | 41.0 |

#### Record Defaults Template Clone
A record template for cloning a record.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| objectInfos | Map<String, Object Info> | A map of object metadata. | Big, 49.0 | 49.0 |
| record | Record Template Clone | Pre-populated record data. | Small, 49.0 | 49.0 |

#### Record Defaults Template Create
A record template for creating a record.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| objectInfos | Map<String, Object Info> | A collection of object metadata. | Big, 49.0 | 49.0 |
| record | Record Template Create | Pre-populated record data. | Small, 49.0 | 49.0 |

#### Record Layout
The layout information for a record.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| id | String | The layout ID. | Small, 41.0 | 41.0 |
| layoutType | String | The layout type. One of: • Compact—key fields. • Full—(Default) full layout. | Small, 41.0 | 41.0 |
| mode | String | The access mode. One of: • Create—used by `/ui-api/record-defaults/create/{apiName}`. • Edit—used by `/ui-api/record-defaults/clone/{recordId}`. • View—(Default). | Small, 41.0 | 41.0 |
| objectApiName | String | The API name of the object that the layout is associated with. | Small, 49.0 | 49.0 |
| recordTypeId | String | The record type ID for this record. | Small, 49.0 | 49.0 |
| saveOptions | Record Layout Save Option[] | The save options for the layout. | Small, 51.0 | 51.0 |
| sections | Record Layout Section[] | A collection of layout sections. | Small, 41.0 | 41.0 |

#### Record UI
The layout information, field information, and data for a record.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| layoutUserStates | Map<String, Record Layout User State> | A map of layout IDs to user state information. | Medium, 41.0 | 41.0 |
| layouts | Map<String, Map<String, Map<String, Map<String, Record Layout>>>> | A map of object API names to layout information for each object. | Medium, 41.0 | 41.0 |
| objectInfos | Map<String, Object Info> | A map of object API names to each object's metadata. | Big, 41.0 | 41.0 |
| records | Map<String, Record> | A map of record IDs to each record's data. | Small, 41.0 | 41.0 |

#### Related List Info
Metadata that describes a related list.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| cloneable | Boolean | Whether the related list can be cloned. | Small, 50.0 | 50.0 |
| createable | Boolean | Whether a new related list for this related list's object can be created. | Small, 50.0 | 50.0 |
| deletable | Boolean | Whether the related list can be deleted. | Small, 50.0 | 50.0 |
| displayColumns | Related List Column[] | All display columns for this related list. | Small, 50.0 | 50.0 |
| fieldApiName | String | The API name of the field in the child object that links to the parent object. | Small, 51.0 | 51.0 |
| fields | String[] | Related list fields queried. If specified and the user doesn't have access or it doesn't exist, an error occurs. | Small, 57.0 | 57.0 |
| filterable | Boolean | Whether users can apply quick filters to the related list. | Small, 58.0 | 58.0 |
| filterLogicString | String | The filter logic string, such as (1 OR 2) and 3. Related lists don't support saved filters, so the value is always empty. | Small, 50.0 | 50.0 |
| filteredByInfo | List Filter by Info[] | Filtering information. Related lists don't support saved filters, so always empty. | Small, 50.0 | 50.0 |
| label | String | The related list display label. e.g. Contracts. | Small, 50.0 | 50.0 |
| listReference | Related List Reference | A reference to the related list. | Small, 50.0 | 50.0 |
| objectApiNames | String[] | The API names for the objects returned in the related list. Depends on the parent object's layout. | Small, 51.0 | 51.0 |
| orderedByInfo | List Order By Info[] | Ordering information for the related list. | Small, 50.0 | 50.0 |
| optionalFields | String[] | Additional related list fields queried. If specified and the user doesn't have access, no error occurs. | Small, 57.0 | 57.0 |
| restrictColumnsToLayout | Boolean | Whether metadata was retrieved for only the list columns in the page layout (true) or all columns (false). | Small, 57.0 | 57.0 |
| updateable | Boolean | Whether the related list can be updated. | Small, 50.0 | 50.0 |
| userPreferences | List User Preference | User preferences for the related list. | Small, 50.0 | 50.0 |
| visibility | String | The related list's visibility. Related lists are always Public. | Small, 50.0 | 50.0 |
| visibilityEditable | Boolean | Whether the visibility of the related list can be edited. The value is always false. | Small, 50.0 | 50.0 |

#### Related List Info Summary Collection
A collection of related lists for a given object.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| parentObjectApiName | String | The API name of the parent object. | Small, 50.0 | 50.0 |
| parentRecordTypeId | ID | The record type ID of the parent. | Small, 50.0 | 50.0 |
| relatedLists | Related List Summary | Related list information. | Small, 50.0 | 50.0 |

#### Related List Record Collection
A collection of related list records.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| count | Integer | The total count of records returned. | Small, 50.0 | 50.0 |
| columnLabels | Map<String, String> | Map of column API name to column label. | Small, 65.0 | 65.0 |
| currentPageToken | String | The token for the current page of records. | Small, 50.0 | 50.0 |
| currentPageUrl | String | The URL of the current page of records. | Small, 50.0 | 50.0 |
| fields | String[] | The list of fields requested when these records were fetched. If a field isn't available, an error occurs. | Small, 50.0 | 50.0 |
| listInfoETag | String | An ETag that indicates whether the metadata has changed. | Small, 50.0 | 50.0 |
| listReference | Related List Reference | The reference to the related list that contains the records. | Small, 50.0 | 50.0 |
| nextPageToken | String | The token for the next page of records. | Small, 50.0 | 50.0 |
| nextPageUrl | String | The URL of the next page of records. | Small, 50.0 | 50.0 |
| optionalFields | String[] | The list of optional fields requested. If unavailable, no error and field omitted. | Small, 50.0 | 50.0 |
| pageSize | Integer | The number of list records viewed at one time. Default 50. | Small, 50.0 | 50.0 |
| previousPageToken | String | The token for the previous page of records. | Small, 50.0 | 50.0 |
| previousPageUrl | String | The URL of the previous page of records. | Small, 50.0 | 50.0 |
| records | Record[] | A collection of records. | Small, 50.0 | 50.0 |
| sortBy | String | The API name of the field the list view is sorted by. Prefix `-` = descending. | Small, 50.0 | 50.0 |
| where | String | The filter applied in GraphQL syntax (e.g. `{ and: [ { StageName: { eq: \"Prospecting\" } }, { Account: { Name: { eq: \"Dickenson plc\" } } } ] }`). | Small, 55.0 | 55.0 |

#### Related List Record Count
The number of records in a given related list.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| count | Integer | The number of records in the related list. | Small, 50.0 | 50.0 |
| hasMore | Boolean | Whether there are more records than the provided count. | Small, 50.0 | 50.0 |
| listReference | Related List Reference | The related list referenced. | Small, 50.0 | 50.0 |

#### Related List User Preferences
User preferences for a related list.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| columnWidths | Map<String,Integer> | Column width preferences for the related list. -1 indicates default width. | Small, 55.0 | 55.0 |
| columnWrap | Map<String,Boolean> | Whether the column text wraps. | Small, 55.0 | 55.0 |
| orderedBy | List Order By Info[] | Ordering information for the related list. | Small, 55.0 | 55.0 |
| preferencesId | String | The related list ID for the user preferences. | Small, 55.0 | 55.0 |

#### Simplified Batch Results
The simplified results from a request to a batch resource.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| results | Batch Result Item[] | Collection of batch result items. | Small, 50.0 | 50.0 |

#### Theme
A set of images and banners that make up a theme.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| brandColor | String | The brand color of the theme. | Small, 42.0 | 42.0 |
| brandImage | Theme Image | The brand image of the theme. | Small, 42.0 | 42.0 |
| brandImageDarkMode | Theme Image | Reserved for future use. | Small, 67.0 | 67.0 |
| defaultGroupBanner | Theme Banner | The default banner for groups (group's home page). | Small, 42.0 | 42.0 |
| defaultGroupImage | Theme Image | The default image for groups (beside a group name). | Small, 42.0 | 42.0 |
| defaultPageBanner | Theme Banner | The default banner for pages other than group and user pages. | Small, 42.0 | 42.0 |
| defaultUserBanner | Theme Banner | The default user banner (user's home page). | Small, 42.0 | 42.0 |
| defaultUserImage | Theme Image | The default user image (beside a username). | Small, 42.0 | 42.0 |
| density | String | The display density. One of: • ViewOne—lower density, more white space (Lightning: Comfy). • ViewTwo—higher density, least white space (Lightning: Compact). | Small, 44.0 | 44.0 |
| headerColor | String | The header color of the theme. | Small, 42.0 | 42.0 |
| linkColor | String | The link color of the theme. | Small, 42.0 | 42.0 |
| pageColor | String | The page color of the theme. | Small, 42.0 | 42.0 |

### 3-2. Nested

#### Advanced Lookup Display Info

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| fields | Advanced Lookup Display Info Field[] | Ordered list of advanced lookup display fields. | Small, 61.0 | 61.0 |

#### Advanced Lookup Display Info Field

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| fieldPath | String | Advanced lookup display field path. | Small, 61.0 | 61.0 |
| label | String | Advanced lookup display field label. | Small, 61.0 | 61.0 |
| objectApiName | String | Advanced lookup display field object API name. | Small, 61.0 | 61.0 |

#### Advanced Lookup Info

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| displayInfo | Advanced Lookup Display Info | Advanced lookup display information. | Small, 61.0 | 61.0 |

#### Batch Result Item
The results of one subrequest in a batch request.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| result | One of these types: • Error Message (if the result is an error, the type is a collection of error messages). • Record • Related List Info • Related List Record Count | A response body for a record or related list. | Small, 41.0 | 41.0 |
| statusCode | Integer | An HTTP status code indicating the status of this individual request in the batch. | Small, 41.0 | 41.0 |

#### Canvas Layout Component
A canvas component on a record page layout.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | The API name of the canvas app. | Small, 41.0 | 41.0 |
| componentType | String | The value is Canvas. | Small, 41.0 | 41.0 |
| displayLocation | String | The location in the application where the canvas app is called from. One of: • Chatter—called from the Chatter tab. • ChatterFeed—a Chatter canvas feed item. • MobileNav—the navigation menu in the Salesforce mobile app. • OpenCTI—an Open CTI component. • PageLayout—an element within a page layout (if PageLayout, a subLocation value can be returned). • Publisher—a canvas custom quick action. • ServiceDesk—a Salesforce Console component. • Visualforce—a Visualforce page. • None—the Canvas App Previewer. The sublocation (mobile) possible values: • S1MobileCardFullview—a mobile card. • S1MobileCardPreview—a mobile card preview. • S1RecordHomePreview—a record detail page preview. • S1RecordHomeFullview—a page layout. | Small, 41.0 | 41.0 |
| height | String | The height of the component. | Small, 41.0 | 41.0 |
| referenceId | String | The unique ID of the canvas app definition. | Small, 41.0 | 41.0 |
| showScroll | Boolean | Whether to show the scroll bar on the canvas component (true) or not (false). | Small, 41.0 | 41.0 |
| width | String | The width of the component. | Small, 41.0 | 41.0 |

#### Case Status Picklist Value Attributes
Additional picklist value attributes for case statuses.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| closed | Boolean | If this status indicates the case has been closed, the value is true, otherwise false. | Small, 48.0 | 48.0 |
| picklistAtrributesValueType | String | The value is CaseStatus. Indicates these value attributes are associated with the status of a case. See the CaseStatus object documentation. **The property picklistAtrributesValueType contains a typographical error.** | Small, 48.0 | 48.0 |

#### Child Relationship
The child relationship on a parent object.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| childObjectApiName | String | The API name of the child object. | Medium, 41.0 | 41.0 |
| fieldName | String | The field on the child object that contains the reference to the parent object. Salesforce uses reference fields (not primary/foreign keys); a reference field stores the ID of the related parent record. | Medium, 41.0 | 41.0 |
| junctionIdListNames | String[] | The names of the JunctionIdList fields associated with an object. Each ID is a polymorphic key (an ID that can refer to more than one type of object). | Medium, 41.0 | 41.0 |
| junctionReferenceTo | String[] | A collection of object names that the polymorphic keys in junctionIdListNames can reference. Queryable. | Medium, 41.0 | 41.0 |
| relationshipName | String | The name of the relationship. A name for the child relationship unique to the parent; the plural form of the child object name. e.g. Account has Assets, Cases, Contacts. | Medium, 41.0 | 41.0 |

#### Custom Link Layout Component
A custom link component on a record page layout.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | If a field powers this component, the API name of the field. | Small, 41.0 | 41.0 |
| behavior | String | How a link behaves on open. One of: • NewWindow—Open a new window. • NoSidebar—No sidebar. • OnClickJavaScript—run JavaScript on click. • Replace—Replace the current page. • Sidebar—Sidebar. | Small, 41.0 | 41.0 |
| componentType | String | The component type. The value is CustomLink. | Small, 41.0 | 41.0 |
| customLinkUrl | String | The custom link URL. | Small, 41.0 | 41.0 |
| label | String | The custom link label. | Small, 41.0 | 41.0 |

#### Display Layout
Search lookups target display layout metadata.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| displayFields | String[] | Fields to display in lookup results. | Small, 57.0 | 57.0 |

#### Display Layout and Matching Info
Search lookups target display layout and matching information.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| displayLayout | Display Layout | Display information for lookup results. | Small, 57.0 | 57.0 |
| matchingInfo | Matching Info | Information about matching fields. | Small, 57.0 | 57.0 |

#### Duplicate Record Error

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| matchResults | Match Result [] | A collection of duplicate rule match results. Each duplicate rule requires at least one matching rule. | Small, 41.0 | 41.0 |

#### Duplicate Result Info

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| allowSave | Boolean | Whether the duplicate record can be saved (true) or not (false). | Small, 50.0 | 50.0 |
| matchResultInfo | Match Result Info (on page 244) | Information about the match result. | Small, 50.0 | 50.0 |
| rule | String | Name of the duplicate rule. | Small, 50.0 | 50.0 |

#### Duplicate Rule

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| actionOnInsert | String | Whether users can create a duplicate record. • Allow—can be created. • Block—can't be created. | Small, 50.0 | 50.0 |
| actionOnUpdate | String | Whether users can create a duplicate record while editing. • Allow • Block. | Small, 50.0 | 50.0 |
| active | Boolean | Whether the duplicate rule is active (true) or not (false). | Small, 50.0 | 50.0 |
| duplicateRuleFilters | Duplicate Rule Filter[] | A list of filters used by the duplicate rule. | Small, 50.0 | 50.0 |
| matchRules | Match Rule[] | A list of the match rules used by the duplicate rule. | Small, 50.0 | 50.0 |
| name | String | The name of the duplicate rule. | Small, 50.0 | 50.0 |
| operationsOnInsert | String[] | Actions when a user creates a duplicate record. • Alert • Report. | Small, 50.0 | 50.0 |
| operationsOnUpdate | String[] | Actions when edits cause a duplicate. • Alert • Report. | Small, 50.0 | 50.0 |

#### Duplicate Rule Filter

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| booleanFilter | String | The filter's boolean logic. | Small, 50.0 | 50.0 |
| filterItems | Duplicate Rule Filter Item[] | A list of filter items. | Small, 50.0 | 50.0 |
| ruleCritera | String | The rule criteria. | Small, 50.0 | 50.0 |

#### Duplicate Rule Filter Item

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| field | String | The name of the field on which the condition is evaluated. | Small, 50.0 | 50.0 |
| operation | String | The condition operator. e.g. equals or includes. | Small, 50.0 | 50.0 |
| sortOrder | Integer | Conditions are applied in the specified order, starting with 1. | Small, 50.0 | 50.0 |
| value | String | The value of field that matches the condition. e.g. to specify a rule applies only to movies produced in the United States, set the value to United States. | Small, 50.0 | 50.0 |

#### Error Message

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| errorCode | String | An error code with information about the error, for example, INSUFFICIENT_PRIVILEGES. | Small, 41.0 | 41.0 |
| message | String | Description of error. | Small, 41.0 | 41.0 |

#### Error with Output
Contains extra information about errors. Enforces Salesforce validation rules.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| enhancedErrorType | String | Indicates the type of the output property. The value is either null or RecordError. | Small, 41.0 | 41.0 |
| message | String | Description of the error. | Small, 41.0 | 41.0 |
| output | Any response body | The response body returned by the requested resource. e.g. if a successful request returns Object Info but an error triggers Error with Output, the output value is an Object Info response body. When an error occurs related to record create or update, this value is Record Exceptions. | Small, 41.0 | 41.0 |

#### Field
A field's metadata.
> **Important (PDF callout):** Where possible, we changed noninclusive terms... Because changing the often-used term master-detail can break customer implementations, we maintained this reference.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | The API name for this field. | Small, 41.0 | 41.0 |
| calculated | Boolean | Whether the field is a custom formula field. | Small, 41.0 | 41.0 |
| compound | Boolean | Whether the field is a top-level compound field. If dataType is Location, this is usually false. | Small, 41.0 | 41.0 |
| compoundComponentName | String | If a component field of a compound field, the normalized component name; otherwise null. e.g. "BillingStreet" → "Street". | Small, 41.0 | 41.0 |
| compoundFieldName | String | If a component field of a compound field, the top-level compound field. Otherwise null. | Small, 41.0 | 41.0 |
| controllerName | String | If a dependent picklist, the name of the field that controls the values. | Small, 41.0 | 41.0 |
| controllingFields | String[] | If a dependent picklist, a collection of fields that control the values. For a hierarchy, the collection starts with the immediate parent and moves up the tree. | Small, 42.0 | 42.0 |
| createable | Boolean | Whether the field can be created. | Small, 41.0 | 41.0 |
| custom | Boolean | Whether the field is custom. | Small, 41.0 | 41.0 |
| dataType | String | Field type. One of: • Address • Anytype • Base64 • Boolean • ComboBox • ComplexValue—Complex Value Type (CVT). • Currency • Date • DateTime • Double • Email • EncryptedString • Int • JunctionIdList • Location • Long • MultiPicklist—populate via Get Values for a Picklist Field or All Picklist Fields. • Percent • Phone • Picklist—populate similarly. • Reference • String • TextArea • Time • Url | Small, 41.0 | 41.0 |
| defaultValue | String | Default value for the field. | Small, 66.0 | 66.0 |
| defaultedOnCreate | Boolean | Whether the field is automatically assigned a default value when a record is created. | Small, 66.0 | 66.0 |
| digits | Integer | For integer fields, the maximum number of digits. | Small, 65.0 | 65.0 |
| externalId | String | External ID of the field. | Small, 60.0 | 60.0 |
| extraTypeInfo | String | More data type information. One of: • ExternalLookup • ImageUrl • IndirectLookup • PersonName • PlainTextArea • RichTextArea • SwitchablePersonName. | Small, 41.0 | 41.0 |
| filterable | Boolean | Whether the field is filterable. If true, can be specified in a SOQL WHERE clause. | Small, 41.0 | 41.0 |
| filteredLookupInfo | Filtered Lookup Info | If a reference field with a lookup filter, the lookup information. | Small, 41.0 | 41.0 |
| highScaleNumber | Boolean | Whether the field stores numbers to 8 decimal places regardless of field details. | Small, 41.0 | 41.0 |
| htmlFormatted | Boolean | Whether the field is formatted for HTML and should be encoded for display. Also indicates a custom formula field with an IMAGE text function. | Small, 41.0 | 41.0 |
| inlineHelpText | String | The text in the field-level help hover text. | Medium, 41.0 | 41.0 |
| label | String | Text label next to the field in the UI. May be localized. | Small, 41.0 | 41.0 |
| length | Integer | For string fields, the maximum number of Unicode characters. | Small, 41.0 | 41.0 |
| maskType | String | Mask type of the field. | Small, 60.0 | 60.0 |
| nameField | Boolean | Whether the field is a name field. | Small, 41.0 | 41.0 |
| polymorphicForeignKey | Boolean | Whether the field is a foreign key over a domain of multiple objects. | Small, 41.0 | 41.0 |
| precision | Integer | For double fields, the maximum number of digits stored, on both sides of the decimal point. | Small, 41.0 | 41.0 |
| reference | Boolean | Whether the field is a foreign key to another record. Contains an ID value pointing to a unique record (usually the parent) on another object. | Small, 41.0 | 41.0 |
| referenceTargetField | String | For indirect lookup relationships on external objects, the target custom field of the referenced object. | Medium, 41.0 | 41.0 |
| referenceToInfos | Reference to Info[] | For fields that refer to other objects, info about the object types and name fields of the referenced objects. | Small, 41.0 | 41.0 |
| relationshipName | String | The name of the relationship, if this is a master-detail relationship field. | Small, 41.0 | 41.0 |
| required | Boolean | Whether the field is required when creating or editing a record. To determine which fields are required in a layout, use RecordLayoutItem.required. | Small, 41.0 | 41.0 |
| scale | Integer | For double fields, the number of digits to the right of the decimal point. | Small, 41.0 | 41.0 |
| searchPrefilterable | Boolean | Whether a foreign key (relationship field) can be included in a SOSL WHERE clause. | Big, 41.0 | 41.0 |
| sortable | Boolean | Whether the field is sortable. If true, can be specified in a SOQL ORDER BY clause. | Small, 41.0 | 41.0 |
| unique | Boolean | Whether a field's value must be unique. | Small, 41.0 | 41.0 |
| updateable | Boolean | Whether the field can be edited. | Small, 41.0 | 41.0 |

#### Field Layout Component
A field in a record layout.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | The API name of the field. | Small, 41.0 | 41.0 |
| componentType | String | The value is Field. | Small, 41.0 | 41.0 |
| label | String | The label of the field. | Small, 41.0 | 41.0 |

#### Field Value
The raw and displayable field values for a field in a record.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| displayValue | String | The displayable value for a field. Non-null when: • value can be localized to the context user's language. • value is a date or currency that can be formatted (Date/DateTime use short format; Currency uses the format in this table). • value is a related record. | Small, 41.0 | 41.0 |
| value | Object | The value of a field in its raw data form. If the field is a related record, the raw value contains a nested Record response body. If null, displayValue is also null. Date and time in ISO 8601 format. | Small, 41.0 | 41.0 |

#### Filtered Lookup Info
Metadata for a lookup filter.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| controllingFields | String[] | A collection of controlling fields when the lookup filter is dependent on the source object. | Small, 41.0 | 41.0 |
| dependent | Boolean | Whether the lookup filter is dependent on the source object. | Small, 41.0 | 41.0 |
| optionalFilter | Boolean | Whether the lookup filter is optional. | Small, 41.0 | 41.0 |

#### Lead Status Picklist Value Attributes

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| converted | Boolean | If this status indicates the lead has been converted, true; otherwise false. | Small, 41.0 | 41.0 |
| picklistAtrributesValueType | String | The value is LeadStatus. See LeadStatus object documentation. **The property picklistAtrributesValueType contains a typographical error.** | Small, 41.0 | 41.0 |

#### List Column
A column in a list.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| fieldApiName | String | The API name for the field. | Small, 42.0 | 42.0 |
| inlineEditAttributes | Map<String, List Column Inline Edit Attributes> | Map of record type ID to inline edit attributes for the column. | Small, 61.0 | 61.0 |
| label | String | The label of the field. | Small, 42.0 | 42.0 |
| lookupId | String | The ID of the field if the field is a reference. If not a reference, can be null. | Small, 58.0 | 58.0 |
| searchable | Boolean | Whether the list column is searchable. | Small, 61.0 | 61.0 |
| sortable | Boolean | Whether the list column is sortable. | Small, 42.0 | 42.0 |

#### List Column Inline Edit Attributes

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| editable | Boolean | Whether the column can be edited inline. | Small, 61.0 | 61.0 |
| required | Boolean | Whether the column is required to be populated when inline editing. | Small, 61.0 | 61.0 |

#### List Filter by Info
Information used to filter a list.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| fieldApiName | String | The API name for the field used to filter the list. | Small, 42.0 | 42.0 |
| label | String | The label for the field used to filter the list. | Small, 42.0 | 42.0 |
| operandLabels | String[] | The values (or label if one exists) used to filter the list. | Small, 42.0 | 42.0 |
| operator | String | The filter operator. One of: • Contains • Equals • Excludes • GreaterOrEqual • GreaterThan • Includes • LessOrEqual • LessThan • NotContain • NotEqual • StartsWith • Within | Small, 42.0 | 42.0 |

#### List Info Share

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| label | String | Label for the shared item. | Small, 61.0 | 61.0 |
| shareApiName | String | API name for the shared item. | Small, 61.0 | 61.0 |

#### List Info Share Category

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| shareType | String | Share type for the category. Values: • ChannelProgramGroup • Regular • Role • RoleAndSubordinates • RoleAndSubordinatesInternal • Territory • TerritoryAndSubordinates | Small, 61.0 | 61.0 |
| shares | List Info Share[] | Shares in the category. | Small, 61.0 | 61.0 |

#### List Info Summary

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | API name of the list. | Small, 61.0 | 61.0 |
| id | String | ID of the list. | Small, 61.0 | 61.0 |
| label | String | List's label. | Small, 61.0 | 61.0 |
| url | String | List's UI URL. | Small, 61.0 | 61.0 |

#### List Inline Edit Details

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| message | String | Message describing why inline edit is off. | Small, 61.0 | 61.0 |
| state | String | State of inline edit for the list. Values: • Disabled • Enabled • Off | Small, 61.0 | 61.0 |

#### List Object Column

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| alias | String | Alias for the column. | Small, 61.0 | 61.0 |
| dataType | String | Data type for the column. Values: • Address • Anytype • Base64 • Boolean • ComboBox • ComplexValue • Currency • Date • DateTime • Double • Email • EncryptedString • Int • JunctionIdList • Location • Long • MultiPicklist • Percent • Phone • Picklist • Reference • String • TextArea • Time • Url | Small, 61.0 | 61.0 |
| defaultFilterOperator | String | Default filter operator for the column. | Small, 61.0 | 61.0 |
| displayable | Boolean | Whether the column is displayable (true) or not (false). | Small, 61.0 | 61.0 |
| fieldApiName | String | Field API name for the column. | Small, 61.0 | 61.0 |
| filterable | Boolean | Whether the column is filterable (true) or not (false). | Small, 61.0 | 61.0 |
| label | String | Label for the column. | Small, 61.0 | 61.0 |
| picklistValues | List Object Picklist Value[] | List of allowed picklist values for the column. | Small, 61.0 | 61.0 |
| quickFilterOperator | String | Operator to use for quick filters on the column. | Small, 64.0 | 64.0 |
| quickFilterOverrides | List Object Quick Filter Overrides | Optional overrides to use for quick filters on the column. | Small, 64.0 | 64.0 |
| quickFilterable | Boolean | Whether the column can have quick filters (true) or not (false). | Small, 64.0 | 64.0 |
| sortable | Boolean | Whether the column is sortable (true) or not (false). | Small, 61.0 | 61.0 |
| supportedFilterOperators | String[] | Supported filter operators for the column. Values: • Contains • Equals • Excludes • GreaterOrEqual • GreaterThan • Includes • LessOrEqual • LessThan • NotContain • NotEqual • StartsWith • Within | Small, 61.0 | 61.0 |

#### List Object Picklist Value

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | API name for the picklist value. | Small, 61.0 | 61.0 |
| label | String | Label for the picklist value. | Small, 61.0 | 61.0 |

#### List Object Quick Filter Overrides

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| dataType | String | Data type to use for quick filters for the column. | Small, 64.0 | 64.0 |
| picklistValues | Map<String, String>[] | Picklist values to use for quick filters for the column. | Small, 64.0 | 64.0 |

#### List Object Scope

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | API name for the scope. | Small, 61.0 | 61.0 |
| availableEntities | List Object Scope Available Entity[] | Available entities, such as groups or queues, for the scope. | Small, 61.0 | 61.0 |
| label | String | Label for the scope. | Small, 61.0 | 61.0 |

#### List Object Scope Available Entity

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| id | String | ID for the available entity. | Small, 61.0 | 61.0 |
| label | String | Label for the available entity. | Small, 61.0 | 61.0 |

#### List Order By Info

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| fieldApiName | String | The API name for the field. | Small, 42.0 | 42.0 |
| isAscending | Boolean | Whether the list column is ascending or descending. | Small, 42.0 | 42.0 |
| label | String | The localized label of the field. | Small, 42.0 | 42.0 |

#### List Reference

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| id | String | The list view ID. | Small, 42.0 | 42.0 |
| listViewApiName | String | The list view's API name, for example, AllAccounts. | Small, 43.0 | 43.0 |
| objectApiName | String | A supported object, such as Account. | Small, 42.0 | 42.0 |
| type | String | The list view type. | Small, 42.0 | 42.0 |

#### List Scope

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | API name for the scope. | Small, 61.0 | 61.0 |
| entity | List Scope Entity | Entity for the scope. | Small, 61.0 | 61.0 |
| label | String | Label for the scope. | Small, 61.0 | 61.0 |
| relatedEntity | List Scope Related Entity | Related entity for the scope. | Small, 61.0 | 61.0 |

#### List Scope Entity

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| id | String | ID of the scope entity. | Small, 61.0 | 61.0 |
| label | String | Label for the scope entity. | Small, 61.0 | 61.0 |

#### List Scope Related Entity

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| id | String | ID of the scope entity. | Small, 61.0 | 61.0 |
| label | String | Label for the scope entity. | Small, 61.0 | 61.0 |
| type | String | Type of scope entity. | Small, 61.0 | 61.0 |

#### List User Preference
User preferences for the list view.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| columnWidths | Map<String,Integer> | Column width preferences for the list view. Maps a column name to a width. | Small, 42.0 | 42.0 |
| columnWrap | Map<String,Boolean> | Column wrapping preferences. Maps a column name to a boolean indicating whether the text wraps. | Small, 42.0 | 42.0 |

#### Location Field
A complex location value for a record field.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| latitude | Double | Gets the latitude. maybe null if both latitude and longitude are null. | Small, 41.0 | 41.0 |
| longitude | Double | Gets the longitude. maybe null if both latitude and longitude are null. | Small, 41.0 | 41.0 |

#### Lookup Metadata
Search lookups metadata.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| fieldApiName | String | API name of the lookup field. | Small, 57.0 | 57.0 |
| objectApiName | String | API name of the lookup field source object. | Small, 57.0 | 57.0 |
| secondaryField | String | API name of the field used as a secondary display field. | Small, 55.0 | 55.0 |
| targetInfo | Map<String, Lookup Metadata Target Info> | Map of lookup metadata target information. | Small, 57.0 | 57.0 |

#### Lookup Metadata Target Info
Search lookups target metadata.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| advancedLookupInfo | Advanced Lookup Info | Advanced lookup information. | Small, 61.0 | 61.0 |
| errorMessages | String[] | Error messages. | Small, 66.0 | 66.0 |
| fullSearchInfo | Display Layout and Matching Info | Full search display layout and matching information. | Small, 57.0 | 57.0–60.0 |
| objectApiName | String | Object API name. | Small, 57.0 | 57.0 |
| suggestionsInfo | Display Layout and Matching Info | Suggestions display layout and matching information. | Small, 57.0 | 57.0 |

#### Match
A group of records that match the duplicate rules.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| duplicateResultInfos | Map<String, Duplicate Result Info> | A map of the duplicate rules and the information about the duplicate match. | Small, 50.0 | 50.0 |
| objectApiName | String | The object's API name. | Small, 50.0 | 50.0 |
| recordIds | String[] | A list of IDs of the matching records. | Small, 50.0 | 50.0 |

#### Match Result
A duplicate rule match.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | The API name of the object. | Small, 41.0 | 41.0 |
| isAllowSave | Boolean | Whether the rule allows a duplicate to be saved. | Big, 41.0 | 41.0 |
| matchRecordIds | String[] | The IDs of the matching records. | Small, 41.0 | 41.0 |
| matchRule | String | The developer name of the matching duplicate rule. | Big, 41.0 | 41.0 |
| objectLabel | String | The object's label. | Small, 41.0 | 41.0 |
| objectLabelPlural | String | The object's label in plural form. | Small, 41.0 | 41.0 |
| themeInfo | Theme Info | Information about the object's color and icon. | Small, 41.0 | 41.0 |

#### Match Result Info

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| recordIds | String[] | A list of IDs of the matching records. | Small, 50.0 | 50.0 |
| rule | String | The name of the match rule used to match the records. | Small, 50.0 | 50.0 |

#### Match Rule
A match rule defines how duplicate records are identified.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| matchEngine | String | The type of matching used. • ExactMatchEngine—exact matching rules. • FuzzyMatchEngine—fuzzy matching rules. | Small, 50.0 | 50.0 |
| matchFields | String[] | Fields the match rule uses when checking for matching records. | Small, 50.0 | 50.0 |
| name | String | The name of the match rule. | Small, 50.0 | 50.0 |
| objectApiName | String | The API name of the object to which the match rule belongs. | Small, 50.0 | 50.0 |

#### Matching Info
Search lookups target matching information.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| matchingFields | String[] | Ordered list of fields to match on. | Small, 57.0 | 57.0 |

#### Navigation Item
The metadata for a single navigation item (tab).

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| availableInClassic | Boolean | If true, the tab is available for Salesforce Classic. | Medium, 43.0 | 43.0 |
| availableInLightning | Boolean | If true, the tab is available for Lightning Experience. | Medium, 43.0 | 43.0 |
| color | String | Color of the navigation tab. | Small, 43.0 | 43.0 |
| content | String | Launch URL of the navigation tab. | Small, 43.0 | 43.0 |
| custom | Boolean | If true, this navigation tab is a custom tab. | Small, 43.0 | 43.0 |
| developerName | String | API name of the navigation tab. | Small, 43.0 | 43.0 |
| iconUrl | String | URL of the icon of the navigation tab. | Medium, 43.0 | 43.0 |
| id | String | ID of the navigation tab. | Small, 43.0 | 43.0 |
| itemType | String | The navigation tab menu type. One of: • CanvasConnectedApp (matches Describe App Menu CanvasConnectedApp). • ConnectedApp (matches ConnectedApp). • Entity (from search-driven sections; not from Describe App Menu). • FullSite (not from Describe App Menu). • Help (not from Describe App Menu). • ListView (not from Describe App Menu). • Logout (not from Describe App Menu). • NotificationSettings (not from Describe App Menu). • Record (not from Describe App Menu). • Standard (matches Describe App Menu Standard.*; rest in standardType). • TabApexPage (matches Tab.apexPage). • TabAura (matches Tab.aura). • TabFlexiPage (matches Tab.flexiPage). • TabSObject (matches Tab.sObject). • TabWeb (Lightning Experience only; not from Describe App Menu). • UserProfile (not from Describe App Menu). | Small, 43.0 | 43.0 |
| label | String | Localized label name of the navigation tab. | Small, 43.0 | 43.0 |
| objectApiName | String | Corresponding object API name of the navigation tab. | Small, 43.0 | 43.0 |
| objectLabel | String | The label of the corresponding object. | Small, 44.0 | 44.0 |
| objectLabelPlural | String | The plural label of the corresponding object. | Small, 44.0 | 44.0 |
| pageReference | Page Reference | Corresponding page reference for the navigation tab. | Small, 43.0 | 43.0 |
| standardType | String | The subtype of a Standard menu type for the app. One of: • Dashboards • Events • Feeds • Groups • Home • MyDay • PendingInterviews • People • ProcessInstanceWorkitem • Reports • Tasks • Topics • News • DistributedMarketing • Forecasting3 • ForecastingLightning • Development (Lightning Development Experience) • AppLauncher (Lightning Experience App Launcher) • DataAssessmentLightning • DiscoveryForAccounts • WaveHome • WaveHomeLightning • WaveHomeLightningEacFree • B2bHome • B2bPardotCampaigns • B2bEmail • B2bMarketablePeople • B2bAutomation • B2bSocialSearch • B2bContent • B2bPardotSettings • OmniSupervisorLightning • ReactNative • LightningBoltHome • LightningInstrumentation | Small, 43.0 | 43.0 |

#### Object Action
The actions for an object.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| actions | Platform Action[] | A list of actions associated with the object. | Small, 41.0 | 41.0 |
| links | String[] | The subcontext URLs of the current request. | Big, 41.0 | 41.0 |
| url | String | The URL of the current request. | Big, 41.0 | 41.0 |

#### Object Info Directory Entry

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | The API name of the object. | Small, 42.0 | 42.0 |
| keyPrefix | String | The key prefix of the object. | Small, 47.0 | 47.0 |
| label | String | The label of the object. | Small, 42.0 | 42.0 |
| labelPlural | String | The plural label of the object. | Small, 42.0 | 42.0 |
| nameFields | String[] | A list of the API names of the name fields. Most objects have one (e.g. Order → OrderNumber). Objects with first/last name have multiple (Contact → FirstName, LastName, Name). | Small, 47.0 | 47.0 |
| objectInfoUrl | String | The URL to get a full object info response (`/ui-api/object-info/{objectApiName}`). | Small, 42.0 | 42.0 |

#### Opportunity Stage Picklist Value Attributes

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| closed | Boolean | Whether this opportunity stage value represents a closed opportunity. Multiple values can represent a closed opportunity. | Small, 41.0 | 41.0 |
| defaultProbability | Double | The default percentage estimate of confidence in closing. May be null if forecasting is not enabled. | Small, 41.0 | 41.0 |
| forecastCategoryName | String | The default forecast category value. May be null if forecasting is not enabled. | Small, 41.0 | 41.0 |
| picklistAtrributesValueType | String | The value is OpportunityStage. See OpportunityStage object documentation. **The property picklistAtrributesValueType contains a typographical error.** | Small, 41.0 | 41.0 |
| won | Boolean | Whether this opportunity stage value represents a won opportunity. Multiple values can represent a won opportunity. | Small, 41.0 | 41.0 |

#### Page Reference
A page reference.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| attributes | Map<String,Object> | Values for each attribute specified by the page definition. | Small, 43.0 | 43.0 |
| state | Map<String,Object> | Optional parameters that are not integral to the resolution of the reference. | Small, 43.0 | 43.0 |
| type | String | Name of the corresponding page definition. | Small, 43.0 | 43.0 |

#### Picklist Value
A single picklist value.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| attributes | Either null or one of these response bodies: • Case Status Picklist Value Attributes • Lead Status Picklist Value Attributes • Opportunity Stage Picklist Value Attributes • Work Step Status Picklist Value Attributes | This property might contain a nested response body to help consumers understand the meaning of the picklist value. | Small, 41.0 (The Work Step Picklist Value Attributes type is available in API version 58.0 and later.) | 41.0 (Work Step... 58.0+) |
| label | String | The displayable value of the picklist to use in a UI. | Small, 41.0 | 41.0 |
| validFor | Integer[] | If a dependent picklist, a list of the controlling value indexes for which this value is valid. If independent, the list is empty. | Small, 41.0 | 41.0 |
| value | String | The value of the picklist to use in the API. | Small, 41.0 | 41.0 |

#### Platform Action
The metadata, layout information, and data for a platform action.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| actionListContext | String | The context of the action. One of: • Chatter • Dockable • FlexiPage • Global • ListView • ListViewRecord • Lookup • MruList • ObjectHomeChart • Photo • Record • RecordEdit • RelatedList • RelatedListRecord | Small, 41.0 | 41.0 |
| actionTarget | String | The URL to invoke or describe the action when the action is invoked. Applies only to quick actions. | Big, 41.0 | 41.0 |
| actionTargetType | String | The type of the target. One of: • Describe—actions with a UI (quick actions). • Invoke—actions with no UI (action links or invocable actions). • Visualforce—standard buttons overridden by a Visualforce page. | Big, 41.0 | 41.0 |
| apiName | String | The API name of the action. In API 46.0+, for global actions the prefix `Global.` is prepended. | Small, 41.0 | 41.0 |
| externalId | String | External information associated with the action.¹ | Medium, 41.0 | 41.0 |
| iconUrl | String | The URL of the action's icon image. | Small, 41.0 | 41.0 |
| id | String | The ID of this platform action record (18-char PlatformAction SObject ID, prefix 0JV). | Small, 41.0 | 41.0 |
| isMassAction | String | Whether the action can be performed on multiple records. | Small, 41.0 | 41.0 |
| label | String | The label to display for this action. | Small, 41.0 | 41.0 |
| lwcComponent | String | The Lightning web component associated with this action. | Small, 56.0 | 56.0 |
| primaryColor | String | The primary color of the icon, in Hex color code. e.g. 7F8DE1. | Small, 41.0 | 41.0 |
| relatedListRecordId | String | When actionListContext is RelatedListRecord, the ID of the record in an object's related list. | Small, 41.0 | 41.0 |
| relatedSourceObject | String | When actionListContext is RelatedList or RelatedListRecord, the API name of the related list to which the action belongs. | Small, 41.0 | 41.0 |
| section | String | The section of the UI the action resides in. One of: • ActivityComposer • CollaborateComposer • Page • SingleActionLinks | Medium, 41.0 | 41.0 |
| sourceObject | String | The object that this action is associated with. Either an API name or record ID, depending on the resource. | Small, 41.0 | 41.0 |
| subtype | String | The subtype of the action. For quick actions: • Canvas • CaseComment • ChangeDueDate • ChangePriority • ChangeStatus • Create • Email • LightningComponent • LogACall • MobileCreateFull • MobileSmartActions • Post • SendEmail • SocialPost • Update • VisualforcePage. For custom buttons: • flow • javascript • page • sControl • url. For action links: • Api • ApiAsync • Download • Ui. Standard buttons and productivity actions have no subtype. | Medium, 41.0 | 41.0 |
| targetObject | String | The target object created when the action is invoked. | Small, 41.0 | 41.0 |
| targetUrl | String | The target URL for custom button actions. | Small, 41.0 | 41.0 |
| type | String | The type of the action. One of: • CustomButton—opens a URL or Visualforce page or executes JavaScript. • ProductivityAction—pre-defined Salesforce action attached to a limited set of objects. • QuickAction—global or object-specific. • StandardButton—pre-defined Salesforce button (New, Edit, Delete). | Small, 41.0 | 41.0 |

> **Footnote ¹ (PDF 원문):** The format for a quick action is: `OrgId:SourceObject::Context:deviceFormat::QuickActionDefinitionId`. For example: `00Dxx0000001gGh:x01xx0000000007AAA::Record:Phone:09Dxx00000000B6`. The format for a standard action is: `OrgId:SourceObject::Context:deviceFormat::StandardButton:ApiName`.

#### Record Exceptions
A collection of record exception errors.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| errors | Record Exception Error [] | General errors. | Small, 41.0 | 41.0 |
| fieldErrors | Map<String, Record Exception Error []> | A map of field IDs to field-specific errors. | Small, 41.0 | 41.0 |

#### Record Exception Error
Information about a record exception error.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| constituentField | String | If the field is a constituent of a compound field, the API name of the constituent field, and the field property contains the API name of the compound field. If not a constituent, or no field applies, null. | Small, 41.0 | 41.0 |
| duplicateRecordError | Duplicate Record Error | Information about possible duplicate records. When the error code is DUPLICATES_DETECTED, this might contain a value. | Small, 41.0 | 41.0 |
| errorCode | String | An error status code. | Small, 41.0 | 41.0 |
| field | String | A field API name. If no field applies, null. | Small, 41.0 | 41.0 |
| fieldLabel | String | A field label. If no field applies, null. | Small, 41.0 | 41.0 |
| message | String | An error message. | Small, 41.0 | 41.0 |

#### Record Layout Component
A concrete record layout component.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | If a field powers this component, the API name of the field. | Small, 41.0 | 41.0 |
| componentType | String | One of: • Canvas • CustomLink • EmptySpace • Field • ReportChart • VisualforcePage | Small, 41.0 | 41.0 |

#### Record Layout Item
An item in a record layout.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| editableForNew | Boolean | Whether the item can be edited when creating a record. | Small, 41.0 | 41.0 |
| editableForUpdate | Boolean | Whether the item can be edited when updating a record. | Small, 41.0 | 41.0 |
| label | String | The text label for the item. | Small, 41.0 | 41.0 |
| layoutComponents | Collection of components. Can contain any of: • Canvas Layout Component • Custom Link Layout Component • Field Layout Component • Record Layout Component • Report Layout Component • Visualforce Layout Component | A collection of components that make up the item. | Small, 41.0 | 41.0 |
| lookupIdApiName | String | The ID field name of a lookup field. | Small, 41.0 | 41.0 |
| required | Boolean | Whether the field is required in a layout when creating or updating a record. Useful to render required fields with a different treatment (e.g. a red outline). | Small, 41.0 | 41.0 |
| sortable | Boolean | Whether the layout item is sortable. | Small, 41.0 | 41.0 |
| uiBehavior | String | The layout item behavior on the specified layout (doesn't reflect user-level or profile-level access). Values: • Edit—can be edited but isn't required. • Required—can be edited and is required. • Readonly—read-only. Applies only to page layouts and mini layouts. For other types (compact, quick action), this field is null. | Small, 63.0 | 63.0 |

#### Record Layout Row
A row in a record layout.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| layoutItems | Record Layout Item[] | A collection of items in the row, from left to right. Might not extend to the last column. | Small, 41.0 | 41.0 |

#### Record Layout Save Option
The save option for a record layout.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| defaultValue | Boolean | Whether the save option defaults to enabled (true) or not (false). | Small, 51.0 | 51.0 |
| isDisplayed | Boolean | Whether the save option is displayed in the layout or not. | Small, 51.0 | 51.0 |
| label | String | Label for the save option. | Small, 51.0 | 51.0 |
| name | String | API name for the save option. | Small, 51.0 | 51.0 |
| restHeaderName | String | REST API header for the save option. | Small, 51.0 | 51.0 |
| soapHeaderName | String | SOAP API header for the save option. | Small, 51.0 | 51.0 |

#### Record Layout Section
A section in a record layout.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| collapsible | Boolean | Whether the section can be collapsed. | Medium, 41.0 | 41.0 |
| columns | Integer | The number of columns in the section. | Small, 41.0 | 41.0 |
| heading | String | The heading text for the section. | Small, 41.0 | 41.0 |
| id | String | The ID of the section. | Small, 41.0 | 41.0 |
| layoutRows | Record Layout Row[] | A collection of the rows in the section. | Small, 41.0 | 41.0 |
| rows | Integer | The number of rows in the section. | Small, 41.0 | 41.0 |
| tabOrder | String | Indicates the tab order for the items in the section during view and edit. Valid values: • LeftRight • TopDown | Small, 63.0 | 63.0 |
| useHeading | Boolean | Whether the heading text is expected to be displayed. | Medium, 41.0 | 41.0 |

#### Record Layout Section User State

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| collapsed | Boolean | Whether the section is initially displayed as collapsed (true) or expanded (false). | Small, 41.0 | 41.0 |
| id | String | The ID of a layout section. | Small, 41.0 | 41.0 |

#### Record Layout User State

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| id | String | The ID of a layout. | Small, 41.0 | 41.0 |
| sectionUserStates | Map<String, Record Layout Section User State> | A map of layout section user states, keyed to section IDs. | Small, 41.0 | 41.0 |

#### Record Template Clone
A record template for cloning a record.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | The record's object API name. | Small, 49.0 | 49.0 |
| cloneSourceId | String | The ID of the cloned record. This top-level property returns the same result as CloneSourceId in the fields property. | Small, 52.0 | 52.0 |
| fields | Map<String, Field Value> | A map of field data. The response includes only requested fields and CloneSourceId. If you don't pass any fields, the response includes only CloneSourceId. | Small, 49.0 | 49.0 |
| recordTypeId | String | The RecordType ID of the record. | Small, 49.0 | 49.0 |

#### Record Template Create
A record template for creating a record.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | The record's object API name. | Small, 49.0 | 49.0 |
| fields | Map<String, Field Value> | A map of field data. If you don't pass any fields, the response doesn't include any fields. | Small, 49.0 | 49.0 |
| recordTypeId | String | The RecordType ID of the record. | Small, 49.0 | 49.0 |

#### Record Type Info
Information about a record type.
> **Important (PDF callout):** ...we maintained this metadata type's name.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| available | Boolean | Whether this record type is available to the context user when creating a record. | Small, 41.0 | 41.0 |
| defaultRecordTypeMapping | Boolean | Whether this record type mapping is the default for the associated object. | Small, 41.0 | 41.0 |
| master | Boolean | Whether this record type is the master record type (default used when a record has no custom record type). | Small, 41.0 | 41.0 |
| name | String | The UI label of the record type. Can be translated into any language Salesforce supports. | Small, 41.0 | 41.0 |
| recordTypeId | String | The ID of the record type. | Small, 41.0 | 41.0 |

#### Reference To Info

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | The object API name of a type being referenced in a relationship. | Small, 41.0 | 41.0 |
| nameFields | String[] | A collection of names of the name fields for this object type. Combined with the relationship name, determines how to query this type's name fields (e.g. Parent.Name). Typically one per object, except where FirstName and LastName are used. | Small, 41.0 | 41.0 |

#### Related List Column
A column in a related list.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| dataType | String | Field type (lowercase). One of: • address • base64 • boolean • combobox • complexvalue—Complex Value type (cvt) • currency • date • datetime • double • email • encryptedstring • int • location • multipicklist • percent • phone • picklist • reference • string • textarea • time • url | Small, 57.0 | 57.0 |
| fieldApiName | String | The API name for the field. | Small, 42.0 | 42.0 |
| filterable | Boolean | Whether this column is filterable (true) or not (false). | Small, 57.0 | 57.0 |
| label | String | The label of the field. | Small, 42.0 | 42.0 |
| lookupId | String | The ID of the field if the field is a reference. If not a reference, can be null. | Small, 49.0 | 49.0 |
| picklistValues | String[] | The picklist values for this field. Null if not a picklist field. | Small, 57.0 | 57.0 |
| quickFilterOperator | String | The operator used for quick filters on this column. | Small, 57.0 | 57.0 |
| sortable | Boolean | Whether the list column is sortable. | Small, 42.0 | 42.0 |

#### Related List Info Summary
A summary of a related list for an object.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| entityLabel | String | The label for the related list object. | Small, 50.0 | 50.0 |
| entityLabelPlural | String | The plural label for the related list object. | Small, 50.0 | 50.0 |
| fieldApiName | String | The API name of the field in the child object that links to the parent object. | Small, 50.0 | 50.0 |
| keyPrefix | String | The key prefix for IDs of the object that populates the list. Can be null for some related lists. | Small, 50.0 | 50.0 |
| label | String | The related list label. | Small, 50.0 | 50.0 |
| objectApiName | String | The API name for the object. | Small, 50.0 | 50.0 |
| parentFieldApiName | String | The name of the field that relates the object to the parent object. | Small, 50.0 | 50.0 |
| relatedListId | String | The ID of the related list. | Small, 50.0 | 50.0 |
| relatedListInfoUrl | String | The URL to fetch the metadata for the related list. | Small, 50.0 | 50.0 |
| themeInfo | Theme Info | The theme info for the related list object. | Small, 50.0 | 50.0 |

#### Related List Reference
The related list referenced by the collection or metadata.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| id | String | ID of the related list reference. | Small, 50.0 | 50.0 |
| inContextOfRecordId | String | ID of the parent record for the related list. | Small, 50.0 | 50.0 |
| listViewApiName | String | API name of the related list, for example, Contacts. | Small, 50.0 | 50.0 |
| objectApiName | String | API name of the supported related list object, such as Contact. | Small, 50.0 | 50.0 |
| parentObjectApiName | String | API name for the parent object of the related list. | Small, 50.0 | 50.0 |
| recordTypeId | String | Record type ID for the parent of the related list. | Small, 50.0 | 50.0 |
| relatedListId | String | ID of the related list. | Small, 50.0 | 50.0 |
| type | String | Type of related list. | Small, 50.0 | 50.0 |

#### Report Layout Component
A report chart component on a record layout page.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | If a field powers this component, the API name of the field. | Small, 41.0 | 41.0 |
| cacheData | Boolean | Whether to cache data (true) or not (false). | Small, 41.0 | 41.0 |
| componentType | String | The value is ReportChart. | Small, 41.0 | 41.0 |
| error | String | An error message. | Small, 41.0 | 41.0 |
| filter | String | A filter for the report. | Small, 41.0 | 41.0 |
| hideOnError | Boolean | Whether to hide the component when there's an error (true) or not (false). | Small, 41.0 | 41.0 |
| placeholder | String | A placeholder for the report. | Small, 41.0 | 41.0 |
| reportId | String | The component's report ID. | Small, 41.0 | 41.0 |
| showTitle | Boolean | Whether to show the title of the report (true) or not (false). | Small, 41.0 | 41.0 |
| size | String | The size of the component. | Small, 41.0 | 41.0 |

#### Theme Banner
A theme banner image.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| fullSizeUrl | String | The URL of the banner image. | Small, 42.0 | 42.0 |

#### Theme Image
A theme image at three sizes (small, medium, large).

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| largeUrl | String | The URL of the large image. | Small, 42.0 | 42.0 |
| mediumUrl | String | The URL of the medium image. | Small, 42.0 | 42.0 |
| smallUrl | String | The URL of the small image. | Small, 42.0 | 42.0 |

#### Theme Info
Color and icon information for a theme.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| color | String | Color. | Small, 41.0 | 41.0 |
| iconUrl | String | Icon URL. | Small, 41.0 | 41.0 |

#### Visualforce Layout Component
A Visualforce component on a record layout page.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| apiName | String | If a field powers this component, the API name of the field. | Small, 41.0 | 41.0 |
| componentType | String | The value is VisualforcePage. | Small, 41.0 | 41.0 |
| height | String | The height of the component. | Small, 41.0 | 41.0 |
| showLabel | Boolean | Whether to show the section label with this Visualforce component (true) or not (false). | Small, 41.0 | 41.0 |
| showScroll | Boolean | Whether to show the scroll bar on the canvas component (true) or not (false). | Small, 41.0 | 41.0 |
| visualforceUrl | String | The Visualforce URL. | Small, 41.0 | 41.0 |
| width | String | The width of the component. | Small, 41.0 | 41.0 |

#### Work Step Status Picklist Value Attributes
Additional picklist value attributes for work step statuses.
> To use, you must have Field Service enabled in your org.

| Property | Type | Description | FilterGrp,Ver | Avail |
|---|---|---|---|---|
| picklistAtrributesValueType | String | The value is WorkStepStatus. See WorkStepStatus object documentation. **The property picklistAtrributesValueType contains a typographical error.** | Small, 58.0 | 58.0 |
| statusCode | String | Indicates the status category that this status belongs to. | Small, 58.0 | 58.0 |
| sortOrder | Integer | Indicates the order in which the work step statuses are displayed in the status category's picklist. | Small, 58.0 | 58.0 |

---

## 관련 노트

- [[UI API 개요]] — 엔드포인트 목록·wire 어댑터 매핑·HTTP 상태코드·Picklist 흐름·자식 레코드 흐름
- [[uiRecordApi]] — createRecord, updateRecord, deleteRecord (Record Input을 받는 명령형 함수)
- [[getRecord 패턴]] — @wire(getRecord), getFieldValue, Record 응답 바디 활용
- [[getPicklistValues 패턴]] — Picklist Values 응답 바디(controllerValues·validFor) 활용
