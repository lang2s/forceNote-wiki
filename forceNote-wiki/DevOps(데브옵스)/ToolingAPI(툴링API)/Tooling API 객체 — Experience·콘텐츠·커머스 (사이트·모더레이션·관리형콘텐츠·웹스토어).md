---
tags: [Tooling API, sObject, Experience Cloud, Moderation, Managed Content, Commerce, Email, DevOps]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-30
aliases: [BriefcaseDefinition, CommunityWorkspacesNode, Document, EmailTemplate, KeywordList, ManagedContentNodeType, ManagedContentType, MenuItem, ModerationRule, PostTemplate, ProductAttributeSet, SiteDetail, UserCriteria, WebStoreTemplate, 익스피리언스, 커뮤니티, 모더레이션, 관리형콘텐츠, 커머스, 웹스토어, 이메일템플릿, 브리프케이스, 사용자기준, 사이트, "Tooling API로 모더레이션 룰 조회", "Experience Cloud 사이트 sObject", "웹스토어 템플릿 필드", "관리형 콘텐츠 타입 Tooling"]
---

# Tooling API 객체 — Experience·콘텐츠·커머스 (사이트·모더레이션·관리형콘텐츠·웹스토어)

> Experience Cloud(사이트·워크스페이스·모더레이션), 관리형 콘텐츠, B2B/D2C 커머스, 이메일·승인 템플릿, 파일·브리프케이스를 다루는 Tooling API sObject 14종(150필드) 레퍼런스.

---

## 개요

| 객체 | 필드수 | API 버전 | 하위도메인 | 핵심 용도 |
|---|---|---|---|---|
| ModerationRule | 13 | 36.0+ | Experience 모더레이션 | 멤버 생성 콘텐츠 모더레이션 룰(차단·검토·rate limit) |
| CommunityWorkspacesNode | 10 | 39.0+ | Experience Cloud | Experience Workspaces 노드 |
| MenuItem | 8 | 32.0+ | Experience/네비게이션 | 앱·모바일·Digital Experiences 메뉴 항목 |
| KeywordList | 6 | 36.0+ | Experience 모더레이션 | 모더레이션용 키워드 목록 |
| UserCriteria | 6 | 39.0+ | Experience 모더레이션 | 모더레이션 룰 적용 대상 멤버 기준 |
| SiteDetail | 3 | 38.0+ | Experience Cloud | Salesforce/Experience 사이트 상세(읽기 전용) |
| Document | 20 | 38.0+ | 파일 | parent 없는 업로드 파일 객체 |
| EmailTemplate | 10 | 32.0+ | 이메일 템플릿 | 이메일/매스·리스트 이메일 템플릿(1GP only) |
| ManagedContentNodeType | 7 | 47.0+ | 관리형 콘텐츠 | 콘텐츠 타입 내 노드 타입 정의 |
| ManagedContentType | 6 | 47.0+ | 관리형 콘텐츠 | 표준·커스텀 콘텐츠 타입 |
| PostTemplate | 4 | 35.0+ | Chatter 승인 | Chatter 승인용 게시물 템플릿 |
| WebStoreTemplate | 39 | 49.0+ | 커머스(B2B/D2C) | 커머스 스토어 생성 구성 템플릿 |
| ProductAttributeSet | 8 | 55.0+ | 커머스(B2B/D2C) | 제품 variation 속성 그룹 |
| BriefcaseDefinition | 10 | 50.0+ | Field Service | 오프라인 브리프케이스 정의 |

이 14객체는 `api_tooling.pdf`(v67.0, Summer '26) 전역(인쇄 p170~965)에 **알파벳순으로 분산**되어 있다. 알파벳순은 독자에게 의미가 없으므로 이 노트는 **하위도메인 4그룹**(① Experience·모더레이션 / ② 관리형 콘텐츠·문서·템플릿 / ③ 커머스 / ④ Field Service)으로 재배열했다. `Language`(18값)·`ManageableState`(8값) enum은 여러 객체에 반복 등장하므로 **공통 enum 블록**(아래)에 1회 전수 게재하고 각 객체는 참조한다.

---

## 공통 enum 블록

여러 객체가 동일하게 공유하는 enum. 값이 동일한 객체만 이 블록을 참조한다. 값이 다르거나 PDF에 값 목록이 없는 경우(WebStoreTemplate·ManagedContentType의 `Language`)는 참조하지 않고 각 객체에서 별도로 표기한다.

### ManageableState (8값) — 공통

패키지 내 컴포넌트의 manageable 상태를 나타내는 enumerated list.

```
beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged
```

- **사용 객체(5):** BriefcaseDefinition · Document · EmailTemplate · ProductAttributeSet · WebStoreTemplate

### Language (18값) — 공통

| 코드 | 언어 | 코드 | 언어 |
|---|---|---|---|
| da | Danish | nl_NL | Dutch |
| de | German | no | Norwegian |
| en_US | English | pt_BR | Portuguese (Brazil) |
| es | Spanish | ru | Russian |
| es_MX | Spanish (Mexico) | sv | Swedish |
| fi | Finnish | th | Thai |
| fr | French | zh_CN | Chinese (Simplified) |
| it | Italian | zh_TW | Chinese (Traditional) |
| ja | Japanese | ko | Korean |

- **사용 객체(5, 값 동일):** BriefcaseDefinition · KeywordList · ModerationRule · ProductAttributeSet · UserCriteria
- **주석:** `es_MX`(Spanish (Mexico))는 고객 정의 번역 시 Spanish(`es`)로 폴백한다. `th`(Thai)는 UI가 완전 번역되나 Help는 영어로 제공된다.
- ⚠️ **WebStoreTemplate·ManagedContentType의 `Language`는 이 블록을 참조하지 않는다** — 두 객체는 PDF에 값 목록이 게재되어 있지 않다(아래 각 객체 참조).

---

## ① Experience Cloud · 모더레이션

### ModerationRule (13)

**설명:** Represents a rule used in your Experience Cloud site to moderate member-generated content. Moderation rules help protect your site from spammers, bots, and offensive or inappropriate content. Each rule specifies the member-generated content the rule applies to, the criteria to enforce the rule on, and the moderation action to take.

- **API 버전:** Tooling API version 36.0 and later
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), update()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Action | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist | Required. moderation action. (값 아래) |
| ActionLimit | int | Filter, Group, Nillable, Sort | moderation action limit (분 단위). API version 39.0 and later. |
| Active | boolean | Defaulted on create, Filter, Group, Sort | Required. moderation rule 활성(true)/비활성(false). |
| Description | textarea | Filter, Nillable, Sort | A description of the moderation rule. |
| DeveloperName | string | Filter, Group, Namefield, Sort | The developer's internal name for the moderation rule used in the API. |
| FullName | string | Create, Group, Nillable | The full name of the associated metadata object in Metadata API. (1레코드 초과 시 에러) |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the moderation rule. → 공통 블록 Language(18값) 참조. |
| MasterLabel | string | Filter, Group, Sort | Label for the moderation rule. |
| Metadata | mns:ModerationRule | Create, Nillable, Update | Moderation rule metadata. (1레코드 초과 시 에러) |
| NotifyLimit | int | Filter, Group, Nillable, Sort | notification limit (초 단위). API version 39.0 and later. |
| TimePeriod | RateLimitTimePeriod (enumeration of type string) | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | rate limiting rule이 적용되는 time-frame. "Short"=3분, "Medium"=15분. API version 39.0 and later. (값 아래) |
| Type | ModerationRuleType (enumeration of type string) | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | moderation rule 타입. Content rules=공격적 언어/부적절 콘텐츠 보호, Rate rules=spammer/bot 동일 메시지 반복 보호. API version 39.0 and later. (값 아래) |
| UserMessage | textarea | Filter, Nillable, Sort | content가 블록될 때 멤버에게 보이는 메시지. %BLOCKED_KEYWORD% 변수로 최대 5개 블록 단어 표시. 미지정 시 표준 메시지: "You can't use %BLOCKED_KEYWORD% or other inappropriate words in this site. Review your content and try again." |

**Action picklist 값 (5):** Block, Review, Replace, Flag, FreezeAndNotify (Reserved for future use.)
**TimePeriod (RateLimitTimePeriod) 값 (2):** Short (3분), Medium (15분)
**Type (ModerationRuleType) 값 (2):** Content, Rate

---

### CommunityWorkspacesNode (10)

**설명:** Represents a node used in Experience Workspaces.

- **API 버전:** Tooling API version 39.0 and later
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Description | string | Filter, Nillable, Sort | A description of the field. |
| DevName | string | Filter, Group, Nillable, Sort | API name of the chart. (underscores/alphanumeric만, 고유, 문자로 시작, 공백 없음, `_`로 끝나지 않음, 연속 `__` 없음. 관리 패키지 네이밍 충돌 방지) |
| ExternalId | string | Filter, Group, Nillable, Sort | A unique system-generated numerical identifier for the user. |
| HelpLocator | string | Filter, Group, Nillable, Sort | The URL for the help page. |
| Label | string | Filter, Group, Nillable, Sort | The display label of the Workspaces component. |
| Locator | string | Filter, Nillable, Sort | The aura component list (aura page) or page URL (aloha page). |
| NetworkID | string | Filter, Group, Nillable, Sort | The ID of the Experience Cloud site. |
| PageType | string | Filter, Group, Nillable, Sort | Type of page accessed within Experience Workspaces. |
| Parent | string | Filter, Group, Nillable, Sort | The devName of the parent node. |
| Workspace | string | Filter, Group, Nillable, Sort | The devName of the workspace the node belongs to. |

---

### MenuItem (8)

**설명:** Represents a menu item.

- **API 버전:** 32.0 and later
- **Supported SOAP Calls:** query(), update()
- **Supported REST HTTP Methods:** GET, POST
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Active | boolean | Defaulted on create, Filter, Group, Sort, Update | Indicates whether the item in the menu is active (true) or not (false). |
| AppId | string | Filter, Group, Sort | menu item이 연결된 앱 ID. enum(Feed, People 등) 또는 alphanumeric ID 가능. AppId를 menu item 고유 ID로 사용(Id 아님). |
| Color | string | Filter, Group, Nillable, Sort | UI에 표시되는 menu item 색. Web color RGB 형식(예: 00FF00). |
| IconURL | url | Filter, Group, Nillable, Sort | The URL of an icon in the menu item. |
| Label | string | Filter, Group, Nillable, Sort | UI에 표시되는 menu item label. |
| MenuType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | menu item이 속한 메뉴 타입. query()에 필수. (값 아래) |
| SortOrder | int | Filter, Group, Nillable, Sort, Update | menu item 표시 순서 결정. 0보다 큰 ordinal, 리스트 내 고유. Inactive는 -1. |
| Theme | string | Filter, Group, Nillable, Sort | 연결된 theme. Color·IconURL에 대해 query()에 필수. (값 아래) |

**MenuType picklist 값 (3):**
- **AppSwitcher** — the app menu, a drop-down menu that's displayed at the top of every app page
- **Salesforce1** — the Salesforce mobile app navigation menu
- **NetworkTabs** — the Digital Experiences tab set

**Theme 값 (4):**
- **theme2** — the Salesforce theme that was used prior to Spring '10
- **theme3** — the Salesforce theme that was introduced in Spring '10
- **theme4** — the theme that was introduced in Winter '14 for the mobile touchscreen version of Salesforce
- **custom** — the theme that's associated with a custom icon

**Usage / 코드예제 (PDF 원문 그대로 인용):**

```java
// PDF api_tooling.pdf 원문 인용 — 직접 작성 코드 아님
MenuItem can be queried and manipulated to change how menu items appear in Salesforce. The following example modifies the Salesforce mobile app navigation menu.

String query = "SELECT AppId, Label, Active, SortOrder FROM MenuItem "
+
"WHERE MenuType = 'Salesforce'";
SObject[] records = sforce.query(query).getRecords();
//Activate all menu items
for (int i = 0; i < records.length; i++) {
MenuItem item = (MenuItem)records[i];
item.setOrder(i + 1);
item.setActive(true);
}
sforce.update(records);
```

---

### KeywordList (6)

**설명:** Represents a list of keywords used in Experience Cloud site moderation. This keyword list is a type of moderation criteria that defines offensive language or inappropriate content that you don't want in your Experience Cloud site.

- **API 버전:** Tooling API version 36.0 and later
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), update()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Filter, Nillable, Sort | A description of the keyword list. |
| DeveloperName | string | Filter, Group, Namefield, Sort | The developer's internal name for the keyword list used in the API. |
| FullName | string | Create, Group, Nillable | The full name of the associated metadata object in Metadata API. (1레코드 초과 시 에러) |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the keyword list. → 공통 블록 Language(18값) 참조. |
| MasterLabel | string | Filter, Group, Sort | Label for the keyword list. |
| Metadata | mns:KeywordList | Create, Nillable, Update | KeywordList metadata. (1레코드 초과 시 에러) |

---

### UserCriteria (6)

**설명:** Represents the member criteria to use in Experience Cloud site moderation rules.

- **API 버전:** Tooling API version 39.0 and later
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Filter, Nillable, Sort | The description of the user criteria. |
| DeveloperName | string | Filter, Group, Sort | API name of the developer. (underscores/alphanumeric만, org 고유, 문자로 시작, 공백 없음, `_`로 끝나지 않음, 연속 `__` 없음) |
| FullName | string | Create, Group, Nillable | The full name of the associated metadata object in Metadata API. (1레코드 초과 시 에러) |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the moderation rule. → 공통 블록 Language(18값) 참조. |
| MasterLabel | string | Filter, Group, Sort | The label for the user criteria. |
| Metadata | mns:UserCriteria | Create, Nillable, Update | The user criteria metadata. (1레코드 초과 시 에러) |

> 정정: PDF는 `DeveloperName`을 "Developer Name"(공백)으로 렌더하는 추출 artifact가 있으나 실제 API 필드명은 **DeveloperName**이다.

---

### SiteDetail (3)

**설명:** Represents the details of a Salesforce site or Experience Cloud site. (읽기 전용)

- **API 버전:** API version 38.0 and later
- **Supported Calls:** describeSObjects(), query()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** 없음 (단 아래 Note 참조)

| 필드 | Type | Properties | Description |
|---|---|---|---|
| DurableId | string | Filter, Group, Nillable, Sort | The ID of the Site object. |
| IsRegistrationEnabled | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the site allows users to sign up. |
| SecureUrl | string | Filter, Group, Nillable, Sort | The URL of the website. |

> **Note (PDF 원문):** SiteDetail fields are exposed in SOAP API version 45.0 and later. You can use Tooling API to query for SiteDetail fields in guest user mode in API version 44.0 and earlier. In API version 45.0 and later, use SOAP API to get this data in guest user mode. SiteDetail is still exposed in Tooling API to User Profiles with the ViewSetup permission.

---

## ② 관리형 콘텐츠 · 문서 · 템플릿

### Document (20)

**설명:** Represents a file that a user has uploaded. Unlike Attachment records, documents are not attached to a parent object.

- **API 버전:** Tooling API version 38.0 and later
- **Supported SOAP Calls:** getDeleted(), getUpdated(), query(), retrieve(), search()
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOSL Limitations (인쇄 p40) 적용
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| AuthorId | reference | Filter, Group, Sort | ID of the user who is responsible for the document. |
| Body | base64 | Nillable | Required. Encoded file data. If specified, then do not specify a URL. |
| BodyLength | int | Filter, Group, Sort | Size of the file (in bytes). If specified, then do not specify a URL. |
| ContentType | string | Filter, Group, Nillable, Sort | Type of content. Label is Mime Type. Limit: 120 characters. (보안 설정 "Don't allow HTML uploads…" 활성 시 아래 확장자 업로드 불가) |
| Description | textarea | Filter, Group, Nillable, Sort | Text description of the document. Limit: 255 characters. |
| DeveloperName | string | Filter, Group, Sort | The unique name of the object in the API. Label is Document Unique Name. (Note: 대량 데이터 생성 시 반드시 고유 DeveloperName 지정 — 미지정 시 성능 저하) |
| FolderId | reference | Filter, Group, Sort | Required. ID of the folder that contains the document. |
| FullName | string | Create, Group, Nillable | The full name of the associated metadata object in Metadata API. (1레코드 초과 시 에러) |
| IsBodySearchable | boolean | Defaulted on create, Filter, Group, Sort | content를 SOSL FIND로 검색 가능한지. ALL FIELDS search group에 포함. |
| IsInternalUseOnly | boolean | Defaulted on create, Filter, Group, Sort | 내부 전용(true)/아님(false). Label is Internal Use Only. |
| IsPublic | boolean | Defaulted on create, Filter, Group, Sort | 외부 사용 가능(true)/아님(false). Label is Externally Available. |
| Keywords | string | Filter, Group, Nillable, Sort | Keywords. Limit: 255 characters. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort | current user가 이 레코드 관련 레코드를 마지막 본 시각. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | current user가 이 레코드를 마지막 본 시각. null이면 referenced만 되고 viewed 안 됐을 수 있음. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 블록 ManageableState(8값) 참조. |
| Metadata | complexvalue | Create, Nillable, Update | The metadata for this object as defined in the Metadata API. (1레코드 초과 시 에러) |
| Name | string | Filter, Group, idLookup, Sort | Required. Name of the document. Label is Document Name. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | namespace prefix (15자) |
| Type | string | Filter, Group, Nillable, Sort | File type of the document. (대개 확장자와 일치 — pdf, jpg). Label is File Extension. |
| Url | string | Filter, Group, Nillable, Sort | URL reference to the file (DB 저장 대신). 지정 시 Body/BodyLength 지정 금지. |

**HTML 업로드 제한:** 보안 설정 "Don't allow HTML uploads as attachments or document records"가 활성화되어 있으면 다음 확장자의 파일은 `ContentType`으로 업로드할 수 없다:
`.htm`, `.html`, `.htt`, `.htx`, `.mhtm`, `.mhtml`, `.shtm`, `.shtml`, `.acgi`, `.svg`

> Document는 Tooling API에서 신규로 다루는 sObject facet이다. Attachment와 달리 parent object에 첨부되지 않는 독립 파일 객체다.

---

### EmailTemplate (10)

**설명:** Represents a template for an email, mass email, list email, or Sales Engagement email. **Supported in first-generation managed packages only.** (2GP 미지원)

- **API 버전:** 32.0 and later
- **Supported SOAP Calls:** create(), getDeleted(), getUpdated(), query(), retrieve(), search()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST
- **Special Access Rules:** 없음

> ⚠️ EmailTemplate은 **1세대 관리 패키지(1GP)에서만** 지원된다. 2세대 관리 패키지(2GP)에서는 지원되지 않는다.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| ApiVersion | double | Filter, Nillable, Sort | The API version if this is a Visualforce email template. (모든 VF 이메일 템플릿은 생성 시 API 버전 지정됨) |
| Description | string | Filter, Nillable, Sort | The email template description. |
| FullName | string | Create, Group, Nillable | The unique name used as the template identifier for API access. (1레코드 초과 시 에러) |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 블록 ManageableState(8값) 참조. |
| Metadata | EmailTemplateMetadata | Create, Nillable, Update | Email template metadata. (1레코드 초과 시 에러) |
| Name | string | Filter, Group, idLookup, Sort | The email template name. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | A unique string to distinguish this template from any others. (flow에서 사용 시 NamespacePrefix로 다중 flow 인스턴스 템플릿 식별) |
| RelatedEntityType | picklist | Create, Filter, Group, Restricted picklist, Sort | UIType이 2(Lightning Experience) 또는 3(Lightning Experience Sample)일 때 이 템플릿이 사용될 엔터티 지정. entity API name("Account","Contact","Opportunity","Lead" 등). 커스텀 엔터티 가능, virtual/setup/platform 엔터티 불가. schema 레벨 제약 없음. |
| Subject | string | Group, Nillable, Sort | The email subject. 제한: Lightning 이메일 템플릿 1,000자, Classic 이메일 템플릿 230자. |
| UIType | picklist | Create, Filter, Group, Restricted picklist, Sort | 이 템플릿이 사용 가능한 UI. (값 아래) |

**UIType picklist 값 (3):** 1 (Salesforce Classic), 2 (Lightning Experience), 3 (Lightning Experience Sample)

---

### ManagedContentNodeType (7)

**설명:** Represents standard and custom content node types created for use with your org.

- **API 버전:** API version 47.0 and later
- **Supported SOAP Calls:** query(), retrieve()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| HelpText | textarea | Filter, Group, Nillable, Sort | UI에서 info bubble로 표시되는 보조 텍스트. 비어 있으면 info bubble 아이콘/텍스트 미표시. |
| NodeLabel | string | Filter, Group, Sort | UI에 나타나는 필드 라벨 선언. |
| NodeName | string | Filter, Group, Sort | content type 내 NodeType의 고유 이름. 최대 100 alphanumeric+underscore, 문자로 시작, 공백 없음, 연속 `__` 없음, `_`로 끝나지 않음. |
| NodeOptionsIsLocalizable | boolean | Filter | Digital Experiences 앱의 content translation service가 export하도록 localizable 선언(true)/아님(false). Default false. |
| NodeOptionsIsRequired | boolean | Filter | 필수 필드 선언(true)/아님(false). required는 빨간 별표. 값 없으면 폼 저장 불가 + 표준 에러. Default false. |
| NodeType | picklist | Filter, Group, Restricted picklist, Sort | node의 content 타입. string으로 전달. content type당 최대 15 node types. (값 아래) |
| PlaceholderText | textarea | Filter, Group, Nillable, Sort | UI에 placeholder/ghost text로 표시되는 보조 텍스트. 예: "Enter a title for your article..." |

**NodeType picklist 값 (8):**
- **TEXT** — Simple text node (maximum length 255 characters)
- **MTEXT** — Multi-line text node (maximum length 2000 characters)
- **RTE** — Rich text node (maximum length 65536 characters)
- **IMG** — Image node
- **URL** — URL node (maximum length 255 characters). URL accepts protocol string values starting with `http://`, `https://`, `mailto:`, `tel:`, and `/`.
- **DATE** — Date node. DATE accepts dates only in the format `yyyy-MM-dd`.
- **DATETIME** — Datetime node. DATETIME accepts date and time in the format: `yyyy-MM-dd'T'HH:mm:ss.SSS'Z'` (UTC datetime in ISO 8601 format).
- **NAMEFIELD** — Declares the field as the name that represents the content when referenced in the UI. Declare only one NodeType as NAMEFIELD. NAMEFIELD is a string type of 200 characters or less. When NAMEFIELD is used, isRequired must also be set to True for the field.

---

### ManagedContentType (6)

**설명:** Represents standard and custom content types created for use with your org.

- **API 버전:** API version 47.0 and later
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** GET, POST, DELETE
- **Note:** You can delete a content type only if no content has been created based on that content type.
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Filter, Group, Nillable, Sort | Describes the custom content type defined in this ManagedContentType declaration. |
| DeveloperName | string | Filter, Group, Sort | Unique name for the custom content type. 예: OurSpecialContent_c |
| FullName | string | Create, Group, Nillable | The full name of the content type in Metadata API. (org 전체 고유, underscores/alphanumeric만, 문자로 시작, `_`로 끝나지 않음, 연속 `__` 없음. 1레코드 초과 시 에러) |
| Language | picklist | Defaulted on create, Group, Nillable, Restricted picklist, Sort | The language of the content type. **PDF에 값 목록 없음** (공통 블록 참조하지 않음). |
| MasterLabel | string | Filter, Group, Sort | Declares the name of the content type as it appears in the UI. |
| Metadata | mns:ManagedContentType | (Properties 행 없음) | content type definition의 metadata object. active 버전·description 정보 포함. (1레코드 초과 시 에러) |

---

### PostTemplate (4)

**설명:** Represents an approval post template for Approvals in Chatter.

- **API 버전:** 35.0 and later
- **Supported SOAP Calls:** query(), retrieve(), search(), update()
- **Supported REST HTTP Methods:** GET, PATCH
- **Special Access Rules:** 없음

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Description | string | Create, Filter, Group, Nillable, Sort, Update | A description of the feed post template, limited to 255 characters. |
| EntityDefinition | EntityDefinition | Filter, Group, Sort | 이 PostTemplate에 연결된 object type으로의 relationship lookup. 직접 상호작용 불가 — query에서만 사용. |
| EntityDefinitionId | string | Filter, Group, Sort | The durable ID for the object defined in the EntityDefinition field. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | The template name. |

---

## ③ 커머스 (B2B / D2C)

### WebStoreTemplate (39)

**설명:** Represents a configuration for creating commerce stores.

- **API 버전:** API version 49.0 and later
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve()
- **Supported REST API Methods:** DELETE, GET, HEAD, POST, Query
- **Special Access Rules:** A B2B Commerce or D2C Commerce license and access to Commerce objects is required.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| CheckoutTimeToLive | int | Filter, Group, Nillable, Sort | checkout이 만료되지 않고 active 유지되는 시간(분). Null=만료 없음, 0=checkout 비활성. API 50.0+. |
| CheckoutValidAfterDate | dateTime | Filter, Nillable, Sort | 기본 서버 타임존(GMT) timestamp. 이 날짜 이전 시작 checkout은 expired. Null=모든 checkout 유효. 예: 2020-07-14T14:27:00.000Z. API 50.0+. |
| Country | picklist | Filter, Group, Nillable, Restricted picklist, Sort | store 국가의 2자리 ISO 코드. 할당된 국가로만 배송. D2C stores만 유효. API 56.0+. |
| DefaultCurrency | string | Filter, Group, Sort | 신규 레코드 기본 통화. |
| DefaultLanguage | string | Filter, Group, Sort | Required. 신규 레코드 기본 언어. |
| DefaultTaxLocaleType | picklist | Filter, Group, Restricted picklist, Sort | Required. webstore 기본 tax type. 값: Gross, Net. API 55.0+. |
| Description | textarea | Nillable | The description of the template. |
| DeveloperName | string | Filter, Group, Sort | Required. unique name in API. Label is Record Type Name. |
| FullName | string | Create, Group, Nillable | The full name of the associated WebStoreTemplate in Metadata API. namespaceprefix 포함 가능. (1레코드 초과 시 에러) |
| GuestCartTimeToLive | int | Filter, Group, Nillable, Sort | guest cart 유효 시간. Default 168시간(7일), 최대 720시간(30일). API 52.0+. |
| Language | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | The language of the WebStoreTemplate. **PDF에 값 목록 없음** (공통 블록 참조하지 않음). |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 블록 ManageableState(8값) 참조. |
| MasterLabel | string | Filter, Group, Sort | Label for the WebStoreTemplate. |
| MaxValuesPerFacet | int | Filter, Group, Nillable, Sort | Maximum number of values that can be added to a facet. |
| Metadata | WebStoreTemplate | Create, Nillable, Update | The metadata for the WebStoreTemplate. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | namespace prefix (15자) |
| OptionsAutoFacetingEnabled | boolean | Filter | 활성(True) 시 가장 관련성 높은 search facet을 구성된 facet에 더해 자동 반환. 비활성(False) 시 구성된 facet만. Default False. API 50.0+. |
| OptionsCartAsyncProcessingEnabled | boolean | Filter | add-to-cart 요청 비동기 처리(True)/아님(False). Default True. API 59.0+. |
| OptionsCartCalculateEnabled | boolean | Filter | cart calculate extension 활성(True)/아님(False). Default False. API 59.0+. |
| OptionsCartToOrderAutoCustomFieldMapping | boolean | Filter | cart·order object 커스텀 필드 매핑 활성(True)/아님(False). Default True. API 57.0+. |
| OptionsCommerceEinsteinActivitiesTracked | boolean | Filter | Commerce Einstein activities tracking 활성(true)/아님(false). |
| OptionsCommerceEinsteinDeployed | boolean | Filter | Commerce Einstein deployed(true)/아님(false). |
| OptionsDuplicateCartItemsEnabled | boolean | Filter | cart에 동일 product ID 다중 항목 포함 가능(True)/아님(False). Default False. API 59.0+. |
| OptionsGuestBrowsingEnabled | boolean | Filter | guest browsing 활성 여부. True 시 guest buyer가 store 제품 접근. |
| OptionsGuestCartEnabled | boolean | Filter | Required. LWR 템플릿 store의 guest cart access 활성. True 시 guest 접근. API 58.0+. |
| OptionsGuestCheckoutEnabled | boolean | Filter | Required. LWR 템플릿 store의 guest checkout access 활성. True 시 guest 접근. API 58.0+. |
| OptionsPreserveGuestCartEnabled | boolean | Filter | Required. guest 로그인 시 cart 내용 보존 여부. True 시 보존. API 60.0+. |
| OptionsSkipAdditionalEntitlementCheckForSearch | boolean | Filter | 기본적으로 search index 재빌드 시·product search 결과 반환 시 2회 entitlement check. True 시 2번째 check 생략(검색 성능 향상). API 52.0+. |
| OptionsSkuDetectionEnabled | boolean | Filter | SKU detection 활성(true)/아님(false). |
| OptionsSplitShipmentEnabled | boolean | Filter | Required. split shipments 활성(true)/아님(false). |
| OrderActivationStatus | string | Filter, Group, Nillable, Sort | Status of the order. 값: Activated, Draft. |
| OrderLifeCycleType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | order life cycle type. 값: MANAGED, UNMANAGED. |
| PaginationSize | int | Filter, Group, Nillable, Sort | Number of results displayed per search results page. |
| PricingStrategy | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | Required. buyer에게 표시할 가격. 값: LowestPrice, Priority. Default LowestPrice. |
| ProductGrouping | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | 검색결과에서 product variation 개별 표시 여부. NoGrouping=개별 표시, VariationParent=부모 제품 반환(자식 링크). Default VariationParent. API 52.0+. |
| SupportedCurrencies | textarea | (Properties 없음) | Currencies supported for store template. |
| SupportedLanguages | textarea | (Properties 없음) | Required. Languages supported for store template. |
| SupportedShipToCountries | textarea | Nillable | Countries that a store created from the template can ship to. |
| Type | picklist | Defaulted on create, Filter, Group, Restricted picklist, Sort | Required. 값: B2B, B2C, B2CE, OMS. Default B2B. |

**enum 전수:**
- **DefaultTaxLocaleType (2):** Gross, Net
- **OrderActivationStatus (2):** Activated, Draft
- **OrderLifeCycleType (2):** MANAGED, UNMANAGED
- **PricingStrategy (2):** LowestPrice, Priority (Default LowestPrice)
- **ProductGrouping (2):** NoGrouping, VariationParent (Default VariationParent)
- **Type (4):** B2B, B2C, B2CE, OMS (Default B2B)
- **Options\* boolean (14):** 각 필드의 True/False 의미·Default·API 버전은 위 필드 표에 전수 보존. (OptionsAutoFacetingEnabled · OptionsCartAsyncProcessingEnabled · OptionsCartCalculateEnabled · OptionsCartToOrderAutoCustomFieldMapping · OptionsCommerceEinsteinActivitiesTracked · OptionsCommerceEinsteinDeployed · OptionsDuplicateCartItemsEnabled · OptionsGuestBrowsingEnabled · OptionsGuestCartEnabled · OptionsGuestCheckoutEnabled · OptionsPreserveGuestCartEnabled · OptionsSkipAdditionalEntitlementCheckForSearch · OptionsSkuDetectionEnabled · OptionsSplitShipmentEnabled)
- **ManageableState:** → 공통 블록 참조
- **Language:** PDF에 값 목록 없음 (공통 블록 참조 금지)

---

### ProductAttributeSet (8)

**설명:** Used to group variation attributes that apply to one or more products.

- **API 버전:** API version 55.0 and later
- **Important (PDF 원문):** Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** B2B Commerce or D2C Commerce must be enabled.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Filter, Group, Nillable, Sort | A meaningful description of the product attribute set. Limited to 255 characters. |
| DeveloperName | string | Filter, Group, Sort | Required. unique name in API. Label is Record Type Name. 자동 생성 가능(API 생성 시 직접 지정 가능). (Note: 대량 생성 시 고유 DeveloperName 지정 권장 — 미지정 시 성능 저하) |
| FullName | string | Create, Group, Nillable | The full name of the associated ProductAttributeSet in Metadata API. namespace prefix 포함 가능. (1레코드 초과 시 에러) |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the product attribute set. → 공통 블록 Language(18값) 참조. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 블록 ManageableState(8값) 참조. |
| MasterLabel | string | Filter, Group, Sort | Label for the product attribute set. |
| Metadata | mns:ProductAttributeSet | Create, Nillable, Update | The ProductAttributeSet's metadata. (1레코드 초과 시 에러) |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | namespace prefix (15자) |

> 정정: PDF는 `ManageableState`에 픽리스트 헤더 중복 렌더 artifact가 있으나 실제는 단일 **ManageableState enumerated list**다.

---

## ④ Field Service — Briefcase

### BriefcaseDefinition (10)

**설명:** Represents a briefcase definition. A briefcase makes selected records available for users and groups to view when they're offline in the Salesforce Field Service mobile app for iOS and Android.

- **API 버전:** 50.0 and later
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** This object is available in orgs that have Briefcase Builder and Field service enabled.

| 필드 | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Filter, Nillable, Sort | Description of the briefcase definition. Limited to 1024 characters. |
| DeveloperName | string | Filter, Group, Sort | The unique name of the object in the API. (underscores/alphanumeric만, 문자로 시작, 공백 없음, `_`로 끝나지 않음, 연속 `__` 없음. 관리 패키지 네이밍 충돌 방지) |
| FullName | string | Create, Group, Nillable | The unique name used as the briefcase definition identifier for API access. (1레코드 초과 시 에러 — multiple queries 사용) |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the briefcase is available for use (true) or not (false). Default false. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language for the briefcase. Defaults to user's language unless multi-language enabled. → 공통 블록 Language(18값) 참조. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 블록 ManageableState(8값) 참조. |
| MasterLabel | string | Filter, Group, Sort | The unique label for the briefcase definition. This internal label doesn't get translated. |
| Metadata | complexvalue | Create, Nillable, Update | The BriefcaseDefinition metadata, which includes rules and rule filters. (1레코드 초과 시 에러) |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | namespace prefix (15자, namespacePrefix__componentName 표기) |
| Type | picklist | Aggregate, Filter, Group, Nillable, Restricted picklist, Sort | briefcase 타입. (값 아래) |

**Type picklist 값 (3):**
- **Standard** — Standard briefcase that can be used with priming APIs.
- **HighVolume** — Increased-capacity briefcase that's used with performance priming in the Salesforce Field Service mobile app.
- **MobileAppSync** — Automatically generated briefcase that's used for performance priming in the Salesforce Field Service mobile app.

> BriefcaseDefinition은 Field Service 모바일 앱의 오프라인 priming용 브리프케이스를 **Tooling API로 정의**하는 sObject facet이다. Field Service 모바일 관점은 [[Field Service Mobile App (LWC)]], 메타데이터/Tooling 관점은 [[Field Service Metadata·Tooling API]] 참조.

---

## 관련 노트
- [[Tooling API — 개요·REST·SOAP 호출 기초]] — Tooling API 호출 기초·허브
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 전체 객체 분류 카탈로그
- [[Tooling API 객체 — Service·OmniChannel (라우팅·대화채널·서비스카탈로그·스케줄링)]] — 같은 C4-9 Service/버티컬 그룹 형제 노트
- [[Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널)]] — 같은 폴더 형제(직전 사이클)
- [[Tooling API 객체 — 패키징·브랜딩 (1GP·2GP·정적콘텐츠)]] — EmailTemplate 1GP·ManageableState 패키징 맥락
- [[Field Service Mobile App (LWC)]] — BriefcaseDefinition: Field Service 모바일 오프라인 priming
- [[Field Service Metadata·Tooling API]] — BriefcaseDefinition: Field Service 메타데이터/Tooling facet
