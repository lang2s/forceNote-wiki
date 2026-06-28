---
tags: [tooling-api, devops, ui, layout, lightning-page, quickaction]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-28
aliases: [AnimationRule, CompactLayout, CompactLayoutInfo, CustomApplication, CustomHelpMenuSection, CustomTab, FlexiPage, HomePageComponent, HomePageLayout, IconDefinition, Layout, PathAssistant, PathAssistantStepInfo, PathAssistantStepItem, QuickActionDefinition, QuickActionList, QuickActionListItem, RecordActionDeployment, RelatedListColumnDefinition, SearchLayout, TabDefinition, WebLink, UI, 레이아웃, 페이지 레이아웃, 라이트닝 페이지, 컴팩트 레이아웃, 퀵액션, 커스텀 탭, 커스텀 앱, 경로, 패스, 관련 목록, 검색 레이아웃, 웹링크, 커스텀 버튼]
---

# Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)

> UI·레이아웃·페이지·액션 Tooling sObject 22종 전수 — FlexiPage·Layout·QuickAction·Path·WebLink·CustomTab·CustomApplication 등. 페이지 레이아웃·라이트닝 페이지·컴팩트 레이아웃·퀵액션·경로(Path)·관련 목록·검색 레이아웃·탭·앱·웹링크를 SOQL로 조회하거나 일부는 MetadataContainer로 배포한다.

이 노트는 Tooling API Reference & Developer Guide v67.0(Summer '26)의 "Tooling API Objects" 챕터 중 **UI 표현·레이아웃·내비게이션 도메인 sObject 군**을 다룬다. 이 군은 페이지 레이아웃(Layout)·라이트닝 페이지(FlexiPage)·컴팩트 레이아웃(CompactLayout·CompactLayoutInfo)·홈페이지(HomePageLayout·HomePageComponent), 앱·탭·내비게이션(CustomApplication·CustomTab·TabDefinition·CustomHelpMenuSection·IconDefinition), 액션·버튼(QuickActionDefinition·QuickActionList·QuickActionListItem·WebLink·RecordActionDeployment), 경로·관련 목록·검색(PathAssistant·PathAssistantStepInfo·PathAssistantStepItem·RelatedListColumnDefinition·SearchLayout·AnimationRule)으로 구성된다. 대부분 `query()`로 SOQL 조회가 가능하며, 일부(Layout·FlexiPage·CompactLayout·QuickActionDefinition 등)는 `create()`/`update()`로 배포·구성할 수 있다.

> [!warning] Tooling Ch4에 없는 UI 객체 (Metadata API/regular SOAP 전용)
> 아래 객체들은 UI/레이아웃 객체로 흔히 기대되지만 **Tooling API Ch4(Tooling API Objects)에는 존재하지 않는다.** Metadata API 전용이거나 표준 SOAP sObject이므로 "Tooling API로 다룰 수 있다"고 쓰면 안 된다(검색 시 혼동 방지 — 실제 coverage gap 신호이지 누락이 아니다).
> - **AppMenuItem**
> - **ListView**
> - **CustomPageWebLink**
> - **ActionOverride / AppActionOverride** — Tooling 객체 없음.
> - **RecordActionRecommendation** — Tooling 객체 없음. v67.0에서 액션 영역에 존재하는 Tooling sObject는 **RecordActionDeployment 하나뿐**이며, RecordActionRecommendation은 `RecordActionDeployment.Recommendation` 안의 서브타입(`mns:RecordActionRecommendation`)으로만 나타난다.
> - **WebLink** 은 v67.0에서 **`Behavior` 필드도 `ContentSource` 필드도 없다.** (작업 힌트가 이 둘을 거론했으나 v67.0 실제 필드에는 부재 — fabricate 금지. 렌더/동작은 `LinkType`·`OpenType`·`DisplayType`으로 표현된다.)

> [!note] 도메인 경계 — 다른 그룹/노트 소관
> - **ProfileLayout · PermissionSetTabSetting** 은 이미 [[Tooling API 객체 — 보안·권한]]에 작성됨(프로파일/권한셋의 접근 통제 탭·레이아웃 관점). 여기서 재작성하지 않고 링크만 둔다.
> - **EmbeddedService\* 11종**(EmbeddedServiceConfig·EmbeddedServiceFlow·EmbeddedServiceBranding 등)은 UI를 렌더하지만 Service Cloud 도메인이므로 → 차기 C4-9a Service 소관.
> - **RecordType · FieldSet · CompactLayout 의 필드 컬럼**(어떤 필드가 레이아웃에 들어가는지)은 [[Tooling API 객체 — Entity·Field·스키마]] 참조. 단 **CompactLayout/SearchLayout 객체 자체의 정본은 이 노트**다.

> [!note] 콘텐츠 갭
> 선언적 페이지 레이아웃 편집·Lightning App Builder·Dynamic Forms how-to 전용 노트는 위키에 아직 없음(ADMIN-3 갭). 본 노트는 Tooling sObject 필드만 다룬다.

> 표기 규약: 필드표는 PDF `-layout` 추출본의 충실 transcription이며, 원문 오타/quirk는 `[sic]` 인라인으로 보존한다. AP-09 페이지 경계로 절단되었던 필드(CustomTab.Url, IconDefinition.Width, HomePageComponent.ShowLabel/ShowScrollbars 등)는 인접 페이지에서 stitch해 전부 포함했다.

---

## 객체 빠른 색인

| 객체 | 분류 | 필드 수 | API 최소 버전 |
|---|---|---|---|
| [AnimationRule](#animationrule) | Path·관련목록·검색 | 12 | 46.0 |
| [CompactLayout](#compactlayout) | 페이지·라이트닝 | 7 | 32.0 |
| [CompactLayoutInfo](#compactlayoutinfo) | 페이지·라이트닝 | 10 | 32.0 |
| [CustomApplication](#customapplication) | 앱·탭·내비 | 14 | 42.0 (Tooling) |
| [CustomHelpMenuSection](#customhelpmenusection) | 앱·탭·내비 | 7 | 45.0 |
| [CustomTab](#customtab) | 앱·탭·내비 | 13 | 33.0 (Tooling) |
| [FlexiPage](#flexipage) | 페이지·라이트닝 | 11 | 31.0 |
| [HomePageComponent](#homepagecomponent) | 페이지·라이트닝 | 7 | 35.0 |
| [HomePageLayout](#homepagelayout) | 페이지·라이트닝 | 4 | 35.0 |
| [IconDefinition](#icondefinition) | 앱·탭·내비 | 7 | 43.0 |
| [Layout](#layout) | 페이지·라이트닝 | 9 | 32.0 |
| [PathAssistant](#pathassistant) | Path·관련목록·검색 | 13 | 36.0 (Tooling) |
| [PathAssistantStepInfo](#pathassistantstepinfo) | Path·관련목록·검색 | 5 | 36.0 (Tooling) |
| [PathAssistantStepItem](#pathassistantstepitem) | Path·관련목록·검색 | 5 | 36.0 (Tooling) |
| [QuickActionDefinition](#quickactiondefinition) | 액션·버튼 | 22 | 32.0 |
| [QuickActionList](#quickactionlist) | 액션·버튼 | 1 | 32.0 |
| [QuickActionListItem](#quickactionlistitem) | 액션·버튼 | 3 | 32.0 |
| [RecordActionDeployment](#recordactiondeployment) | 액션·버튼 | 16 | 45.0 |
| [RelatedListColumnDefinition](#relatedlistcolumndefinition) | Path·관련목록·검색 | 10 | 55.0 |
| [SearchLayout](#searchlayout) | Path·관련목록·검색 | 10 (+서브) | 34.0 (Tooling) |
| [TabDefinition](#tabdefinition) | 앱·탭·내비 | 11 | 43.0 |
| [WebLink](#weblink) | 액션·버튼 | 25 | 34.0 (Tooling) |

> 필드 수 합계 = **222** (배치 A 101 + 배치 B 121). SearchLayout의 서브객체 복합 타입(SearchLayoutButtonsDisplayed·SearchLayoutButton·SearchLayoutFieldsDisplayed·SearchLayoutField) 필드는 222에 포함하지 않는다.

---

## 페이지 레이아웃 & 라이트닝 페이지 (Page Layouts & Lightning Pages)

> 클래식 페이지 레이아웃(Layout), 라이트닝 페이지(FlexiPage), 컴팩트 레이아웃(CompactLayout·CompactLayoutInfo), 홈페이지(HomePageLayout·HomePageComponent). 클래식 레이아웃의 구조·Visualforce 임베드 맥락은 [[apex 컴포넌트 — 페이지·레이아웃 구조]] 참조.

### Layout

Represents a page layout. This object is available in API version 32.0 and later.

> 클래식 페이지 레이아웃의 구조·렌더링 맥락(Visualforce 페이지·인라인 편집·관련 목록 배치)은 [[apex 컴포넌트 — 페이지·레이아웃 구조]] 참조.

- **Version:** API version 32.0 and later.
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| EntityDefinitionId | string | Filter, Group, Sort | The Id of the EntityDefinition object associated with this object. |
| FullName | string | Create, Group, Nillable | The unique name of the layout used as the identifier for API access. The fullName can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| LayoutType | picklist | Filter, Group, Restricted picklist, Sort | Indicates the type of the layout. Valid values are: **GlobalQuickActionList**, **ProcessDefinition**, **Standard**. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| Metadata | mns:Layout | Create, Nillable, Update | Layout metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Name | string | Filter, Group, idLookup, Nillable, Sort | The layout name. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | A unique string to distinguish this layout from any others. For example, if this layout is being using by a flow, use the NamespacePrefix to uniquely identify the layouts in multiple flow instances. |
| ShowSubmitAndAttachButton | boolean | Defaulted on create, Filter, Group, Sort | Only allowed on Case layout. If true, Submit & Add Attachment displays on case edit pages to portal users in the Customer Portal. |
| TableEnumOrId | picklist | Filter, Group, Restricted picklist, Sort | The enum (for example, Account) or ID of the object this layout is on. |

### FlexiPage

Represents a Lightning page. A Lightning page is a customizable page composed of regions containing Lightning components. Includes access to the associated FlexiPage object in the Metadata API. Available from API version 31.0 or later.

> ⚙️ sf-skill: 라이트닝 페이지(FlexiPage) 생성/스캐폴딩 실행은 [[platform-flexipage-generate]] 참조(지식=위키·실행=스킬 프로토콜).

Lightning pages are used in several places.
- In the Salesforce mobile app, a Lightning page is the home page for an app that appears in the navigation menu.
- In Lightning Experience, Lightning pages can be used:
  - To customize the layout of record pages, the Salesforce Home page, and the Email Application pane in the Outlook and Gmail integrations.
  - As the home page for an app.
  - As the utility bar for a Lightning app.

> **Note:** These pages are known as FlexiPages in the API, but are referred to as Lightning pages in the rest of the Salesforce documentation and UI.

> **Note:** In API version 49.0 and later, arrays in a FlexiPage are represented as valueList. Each array element is represented as valueListItem, and the element name is represented as value. In API version 48.0 and earlier, arrays are represented as value and array elements are formatted as a comma-separated list. Any FlexiPage retrieved using API version 49.0 or later uses valueList to represent component property array values, regardless of which API version was used to create the FlexiPage.

- **Version:** API version 31.0 or later.
- **Supported SOAP Calls:** create(), delete(), describeLayout(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** `DELETE,GET, HEAD,PATCH,POST` [sic — irregular spacing as printed]
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | string | Filter, Group, Nillable, Sort | The page description. This field can be useful to describe the reason for creating the page or its intended use. |
| DeveloperName | string | Filter, Group, Sort | The API name of the Lightning page. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| EntityDefinitionId | string | Filter, Group, Nillable, Sort | The name of the standard object or ID of the custom object that the Lightning page is associated with. For Lightning pages of type AppPage or HomePage, this field is null. This field is available in API version 39.0 and later. |
| FullName | string | Create, Group, Nillable | The full name of the associated FlexiPage object in Metadata API. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. This field is available in API version 38.0 and later. |
| MasterLabel | string | Filter, Group, Sort | The page's label. |
| Metadata | FlexiPageMetadata | Create, Nillable, Update | Lightning page metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace of the package of which the FlexiPage is a part. |
| ParentFlexiPage | string | Filter, Group, Nillable, Sort | The name of the FlexiPage that this page inherits behavior from. Available in API version 37.0 or later. |
| SobjectType | string | Filter, Group, Nillable, Sort | The object the Lightning page is associated with. For Lightning pages of type AppPage or HomePage, this field is null. Available in API version 37.0 and 38.0. Deprecated as of API version 39.0. Use EntityDefinitionId instead. |
| Type | picklist | Filter, Group, Restricted picklistSort [sic] | Required. The type of the Lightning page. Valid values are (full enum below). Available in API version 32.0 or later. In API versions 32.0 through 36.0, this field can only have a value of AppPage. |

#### FlexiPage `Type` picklist — FULL enum (verbatim, PDF 순서)

`CommFlowPage`는 PDF에 **두 번** 나타난다([sic], 둘 다 전사). `CommOrderComfirmationPage`는 원문 오탈자([sic — "Comfirmation"]).

- **CdpRecordPage** — A Lightning page that is used to override a CDPNearCoreObject record page in Lightning Experience. This value is available in API version 54.0 and later for orgs that have Data 360 enabled.
- **AppPage** — A Lightning page that is used as the home page for a custom app.
- **CommAppPage** — A Lightning page that is used to represent a custom page, as created in the Experience Builder. This value is available in API version 37.0 and later.
- **CommContractDetailViewPage** — This value is available in API version 64.0 and later.
- **CommCheckoutPage** — A Lightning page that is used to create a B2B Commerce checkout, as created in the Experience Builder. This value is available in API version 46.0 and later.
- **CommFlowPage** — A Lightning page used to override a flow page, as created in the Experience Builder. This value is available in API version 45.0 and later. *(CommFlowPage가 PDF에 두 번 나타남 [sic])*
- **CommForgotPasswordPage** — A Lightning page that's used to override a forgot-password page, as created in Experience Builder. This value is available in API version 39.0 and later.
- **CommFlowPage** — An out-of-the-box flow page, as created in Experience Builder. This value is available in API version 45.0 and later. *(두 번째, 중복 CommFlowPage 항목 [sic])*
- **CommGlobalSearchResultPage** — A Lightning page used to override the global search result page, as created in Experience Builder. This value is available in API version 41.0 and later.
- **CommLoginPage** — A Lightning page that's used to override the login page, as created in Experience Builder. This value is available in API version 39.0 and later.
- **CommNoSearchResultsPage** — An Experience Builder site page for B2B searches that return no results. The URL for this page is no-results/:term. The page starts out empty. You can add any component to it that accepts parameters to achieve the desired "no results" experience. For example, you can place an HTML Editor component or CMS components for recommendations, banners, help, and support. This value is available in API version 48.0 and later.
- **CommObjectPage** — A Lightning page used to override an object page, as created in Experience Builder. This value is available in API version 38.0 and later.
- **CommOrderComfirmationPage** [sic] — A Lightning page that is used to create a B2B Commerce order confirmation page in checkout, as created in the Experience Builder. This value is available in API version 46.0 and later.
- **CommQuickActionCreatePage** — A Lightning page used to override the create record page, as created in Experience Builder. This value is available in API version 38.0 and later.
- **CommRecordPage** — A Lightning page used to override a record page, as created in the Experience Builder. This value is available in API version 38.0 and later.
- **CommRelatedListPage** — A Lightning page used to override a related list page, as created in the Experience Builder. This value is available in API version 38.0 and later.
- **CommSearchResultPage** — A Lightning page used to override the search result page, as created in Experience Builder. This value is available in API version 38.0 and later.
- **CommSelfRegisterPage** — A Lightning page used to override the self-registration page, as created in Experience Builder. This value is available in API version 39.0 and later.
- **CommThemeLayoutPage** — A Lightning page used to override a theme layout page, as created in the Experience Builder. This value is available in API version 38.0 and later.
- **EmbeddedServicePage** — This value is available in API version 45.0 and later.
- **EmailContentPage** — A page that contains the builder markup for your email content. When you edit email content in the builder, the FlexiPage object remembers where you put the components. Because they include builder markup, you can't retrieve or deploy FlexiPages when type is EmailContentPage.
- **EmailTemplatePage** — A page that contains the builder markup for your email template. When you edit an email template in the builder, the FlexiPage object remembers where you put the components. Because they include builder markup, you can't retrieve or deploy FlexiPages when type is EmailTemplatePage or EmailContentPage.
- **ForecastingPage** — A Lightning page that is used to override the default forecasts page in Lightning Experience. This value is available in API version 57.0 and later.
- **HomePage** — A Lightning page that is used to override the Home page in Lightning Experience. This value is available in API version 37.0 and later.
- **MailAppAppPage** — An email application pane used to override the default layout in the Outlook and Gmail integrations. This value is available in API version 38.0 and later.
- **OmniSupervisorPageType** — A Lightning page used to customize the user interface on the Omni-Channel Supervisor page. This value is available in API version 60.0 and later.
- **RecordPage** — A Lightning page used to override an object record page in Lightning Experience. This value is available in API version 37.0 and later.
- **RecordPreview** — A Lightning page used to override standard lookup previews when hovering over previewable records in Lightning Experience. This value is available in API version 45.0 and later.
- **UtilityBar** — A Lightning page used as the utility bar in Lightning Experience apps. This value is available in API version 38.0 and later.
- **VoiceExtension** — A Lightning page used to customize user interfaces and agent actions in the Omni-Channel widget for Service Cloud Voice. This value is available in API version 57.0 and later.

(Type 필드 말미 주석:) Available in API version 32.0 or later. In API versions 32.0 through 36.0, this field can only have a value of AppPage.

#### FlexiPage — Sample Code (verbatim)

> This code sample creates a Lightning page with a single Recent Items component, that shows recently used Accounts and MyCustomObject__cs [sic]

```java
ComponentInstance recentItems = new ComponentInstance();
recentItems.setComponentName("flexipage:recentItems");
ComponentInstanceProperty cip = new ComponentInstanceProperty();
cip.setName("entityNames");
cip.setValue("Account,MyCustomObject__c");
recentItems.setComponentInstanceProperties(new ComponentInstanceProperty[]{cip});

FlexiPageRegion mainRegion = new FlexiPageRegion();
mainRegion.setName("main");
mainRegion.setType(FlexiPageRegionType.Region)
mainRegion.setComponentInstances(new ComponentInstance[] { recentItems });

FlexiPageMetadata fpMetadata = new FlexiPageMetadata();
fpMetadata.setFlexiPageRegions(new FlexiPageRegion[]{mainRegion});
fpMetadata.setMasterLabel("My FlexiPage");
fpMetadata.setDescription("A FlexiPage with a recent items component");
fpMetadata.setType(FlexiPageType.AppPage);

FlexiPage flexiPage = new FlexiPage();
flexiPage.setFullName("MyFlexiPageDevName");
flexiPage.setMetadata(fpMetadata);

// Create
SaveResult saveResult = soapConnection.create(new SObject[] { flexiPage });
```

### CompactLayout

Represents the values that define a compact page layout. This object is available in API version 32.0 and later.

> RecordType·FieldSet 등에서 어떤 필드가 컴팩트 레이아웃 컬럼에 들어가는지는 [[Tooling API 객체 — Entity·Field·스키마]] 참조. 단 CompactLayout 객체 자체의 정본은 여기다.

- **Version:** API version 32.0 and later.
- **Supported SOAP Calls:** create(), delete(), getDeleted(), getUpdated(), query(), retrieve(), search(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST
- **Special Access Rules:** (마지막 필드 뒤 Note) **CompactLayout is exposed in Tooling API to user profiles with the View Setup and Configuration permission.**

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | The developer's internal name for the compact layout (for example, "CL_c") used in the API. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| FullName | string | Create, Group, Nillable | The unique name used as the compact layout identifier for API access. The fullName can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. This field is available in API version 38.0 and later. |
| MasterLabel | string | Filter, Group, Sort | The name of the compact layout in Setup. |
| Metadata | mns:CompactLayout | Create, Nillable, Update | The compact layout metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace of the package of which the compact layout is a part. |
| SobjectType | Restricted picklist | Filter, Group, Restricted picklist, Sort | The type of object used in the layout, such as an Account or Lead. |

### CompactLayoutInfo

Represents the metadata for a custom or standard compact layout. This object is available in API version 32.0 and later.

- **Version:** API version 32.0 and later.
- **Supported SOAP Calls:** query()
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOQL Limitations on page 38; SOSL Limitations on page 40.
- **Special Access Rules:** (마지막 필드 뒤 Note) **CompactLayoutInfo is exposed in Tooling API to user profiles with the View Setup and Configuration permission.**

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Nillable, Sort | The developer's internal name for the compact layout (for example, CL_c) used in the API. |
| DurableId | string | Filter, Group, Sort | Unique identifier for the field. Always retrieve this value before using it, as the value isn't guaranteed to stay the same from one release to the next. To simplify queries, use this field. |
| EntityDefinition | EntityDefinition | Filter, Group, Sort | Required. Available starting with version 32.0. The entity definition for the object associated with this CompactLayoutInfo. |
| EntityDefinitionId | string | Filter, Group, Nillable, Sort | Required. ID of the record associated with this CompactLayoutInfo. The record's object type is in EntityDefinition. |
| FullName | string | Filter, Group, Sort | The unique name used as the compact layout identifier for API access. The fullName can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| IsDefault | boolean | Defaulted on create, Filter, Group, Sort | If true, this compact layout is the default for the associated object. |
| Items | QueryResult | Filter, Group, Sort | A foreign key field pointing to CompactLayoutItemsInfo. Because this field represents a relationship, use only in subqueries. |
| Label | string | Filter, Group, Nillable, Sort | The compact layout's label. |
| Metadata | mns:CompactLayout (on page 208) | Create, Nillable, Update | Metadata that defines compact layouts. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Sort | The namespace prefix associated with this object. Each Developer Edition organization that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the `namespacePrefix__componentName` notation. The namespace prefix can have one of the following values: • In Developer Edition organizations, the namespace prefix is set to the namespace prefix of the organization for all objects that support it. There is an exception if an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition organization of the package developer. • In organizations that are not Developer Edition organizations, NamespacePrefix is only set for objects that are part of an installed managed package. There is no namespace prefix for all other objects. |

### HomePageLayout

Represents a home page layout. This object is available in API version 35.0 and later.

- **Version:** API version 35.0 and later.
- **Supported SOAP Calls:** query(), retrieve(), search()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| Id | string | Defaulted on create, Filter, Group, idLookup, Sort | ID of the home page layout. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| Name | string | Filter, Group, idLookup, Namefield, Sort | The home page layout name. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | A unique string to distinguish this type from any others. |

### HomePageComponent

Represents a home page component. This object is available in API version 35.0 and later.

- **Version:** API version 35.0 and later.
- **Supported SOAP Calls:** query(), retrieve(), search()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| Body | string | Nillable | If this component is an HTML page component, this field is the body of the HTML. |
| Height | int | Filter, Group, Nillable, Sort | Required for Visualforce Area components. Indicates the height (in pixels) of the component. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| Name | string | Filter, Group, idLookup, Namefield, Sort | The name of the home page component. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | A unique string to distinguish this type from any others. |
| ShowLabel | boolean | Defaulted on create, Filter, Group, Sort | ID of the home page layout. [sic — Description은 원문의 copy-paste 오류로 보임] |
| ShowScrollbars | boolean | Defaulted on create, Filter, Group, Sort | ID of the home page layout. [sic — 원문에 동일하게 잘못된 Description] |

---

## 앱, 탭 & 내비게이션 (Apps, Tabs & Nav)

> 커스텀/표준 앱(CustomApplication), 커스텀 탭(CustomTab)과 읽기 전용 탭 카탈로그(TabDefinition), 라이트닝 도움말 메뉴 섹션(CustomHelpMenuSection), 탭 아이콘 정의(IconDefinition).

### CustomApplication

Represents a custom or standard application. An application is a list of tab references, a description, and a logo. It also includes access to the associated CustomApplication type and related fields in Metadata API. Available in Tooling API version 42.0 or later.

- **Version:** Tooling API version 42.0 or later.
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update()
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | string | Filter, Group, Nillable, Sort | The optional description of the application. |
| DeveloperName | string | Filter, Group, Nillable, Sort | The developer name of the application. |
| FullName | string | Create, Group, Nillable | The full name of the application. |
| IsNavAutoTempTabsDisabled | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the navigation automatically creates temporary tabs settings. Defaults to false. Available in API version 43.0 and later. |
| IsNavPersonalizationDisabled | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether navigation personalization is disabled. Defaults to false. Available in API version 43.0 and later. |
| IsNavTabPersistenceDisabled | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether workspace tabs are cleared for each new console session (true) or not (false). Defaults to false. Available in API version 54.0 and later. |
| Label | string | Filter, Group, Nillable, Sort | The label of the application. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| Metadata | mns:CustomApplication | Create, Nillable, Update | Provides access to the associated CustomApplication type and related fields in Metadata API. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix of the application. |
| NavType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Not updateable. The type of navigation the application uses. Valid values are: **Console**, **Standard**. |
| UiType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The type of user interface that the application uses. Valid values are: **Aloha**, **Lightning**. |
| UtilityBar | FlexiPage | Filter, Group, Nillable, Sort | The Lightning page used as the utility bar for the application. |
| UtilityBarId | reference | Filter, Group, Nillable, Sort | The ID of the utility bar associated with this application. |

### CustomTab

Represents a custom tab. This object is available in the Tooling API version 33.0 and later.

- **Version:** Tooling API version 33.0 and later.
- **Supported Calls:** create(), delete(), query(), retrieve(), update()
- **Supported REST HTTP Methods:** *(PDF에 별도의 "Supported REST HTTP Methods" 라인이 없다 — CustomTab은 "Supported Calls" 라인만 인쇄됨)* [sic]
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| ContentId | reference | Filter, Group, Nillable, Sort | Read-only. The ID of the item that the custom tab points to. For Lightning components, this is the ID of the component bundle. For custom object tabs, this field is null. |
| Description | string | Filter, Nillable, Sort | The tab's description. |
| DeveloperName | string | Filter, Group, Nillable, Sort | The developer's internal name for the custom tab. |
| EncodingKey | string | Filter, Group, Nillable, Sort | Read-only. Type of encoding assigned to the URL called by the tab. The default encoding setting is Unicode: UTF-8. Change it if you are passing information to a URL that requires data in a different format. This option is available when the value URL is selected in the tab type. Valid values are: • UTF-8—Unicode (UTF-8) • ISO-8859-1—General US & Western Europe (ISO-8859–1, ISO-LATIN-1) • Shift_JIS—Japanese (Shift-JIS) • ISO-2022-JP—Japanese (JIS) • EUC-JP—Japanese (EUC-JP) • x-SJIS_0213—Japanese (Shift-JIS_2004) • ks_c_5601-1987—Korean (ks_c_5601-1987) • Big5—Traditional Chinese (Big5) • GB2312—Simplified Chinese (GB2312) • Big5-HKSCS—Traditional Chinese Hong Kong (Big5–HKSCS) |
| FullName | string | Create, Group, Nillable | The name of the tab. The value of this field depends on the type of tab, and the API version. • For custom object tabs, the fullName is the developer-assigned name of the custom object (MyCustomObject__c, for example). • For Web tabs, the fullName is the developer-assigned name of the tab (MyWebTab, for example). Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| HasSidebar | boolean | Defaulted on create, Filter, Group, Sort | Indicates if the tab displays the sidebar panel. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Filter, Group, idLookup, Nillable, Sort | Required. The label for the custom tab, which displays in Setup. |
| Metadata | CustomTabMetadata | Create, Nillable, Update | Custom tab metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| MotifName | string | Filter, Group, Sort | Read-only. The name of the tab style assigned to the custom tab. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace of the package of which the custom tab is a part. |
| Type | picklist | Filter, Group, Restricted picklist, Sort | The type of custom tab. Valid values are: **apexPage**, **aura**, **customObject**, **flexiPage**, **sControl**, **url**. |
| Url | string | Filter, Nillable, Sort | The URL for the external web-page to embed in this tab. |

### TabDefinition

Represents a tab, and returns all tabs available in the org. Available in API version 43.0 and later.

> **Note:** In API version 45.0 and later, only users with the "ViewSetup and Configuration" permission can access TabDefinition. [sic — "ViewSetup" 띄어쓰기 없음, verbatim]

- **Version:** API version 43.0 and later.
- **Supported SOAP Calls:** query(), search()
- **Supported REST HTTP Methods:** Query, GET
- **Special Access Rules:** (위 Note 외 별도 없음)

| Field | Type | Properties | Description |
|---|---|---|---|
| DurableId | string | Filter, Group, Nillable, Sort | Unique identifier for the field. Always retrieve this value before using it, as the value isn't guaranteed to stay the same from one release to the next. To simplify queries, use this field. |
| IsAvailableInAloha | boolean | Defaulted on create, Filter, Group, Sort | Set to true if the tab is available in the Salesforce Classic user interface. If a tab is available in Salesforce Classic, then IsAvailableInMobile is false. |
| IsAvailableInDesktop | boolean | Defaulted on create, Filter, Group, Sort | Set to true if the tab is available in the desktop user interface. |
| IsAvailableInMobile | boolean | Defaulted on create, Filter, Group, Sort | Set to true if the tab is available in the Salesforce mobile app. |
| IsAvailableInLightning | boolean | Defaulted on create, Filter, Group, Sort | Set to true if the tab is available in the Lightning Experience user interface. |
| IsCustom | boolean | Defaulted on create, Filter, Group, Sort | Set to true if the tab is a custom tab. |
| Label | string | Filter, Group, Nillable, Sort | The tab label in the Salesforce org. |
| MobileUrl | string | Filter, Group, Nillable, Sort | If the tab is available in mobile, this is the URL that the tab directs the user to in the Salesforce mobile app. If the tab isn't available in mobile, this is set to null. |
| Name | string | Filter, Group, Nillable, Sort | The name of the tab. |
| SobjectName | string | Filter, Group, Nillable, Sort | Used with REST to retrieve the metadata for the tab. |
| Url | string | Filter, Group, Nillable, Sort | The URL for where the tab directs the user. |

### CustomHelpMenuSection

Represents a section of the Lightning Experience help menu that the admin added to display custom, org-specific help resources. Available in API version 45.0 and later.

- **Version:** API version 45.0 and later.
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update()
- **Supported REST HTTP Methods:** Query, DELETE, GET, POST, PATCH
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | The unique name of the custom help section in the API. This name can contain only underscores and alphanumeric characters and must be unique in your organization. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. The label corresponds to section title in the user interface. Limit: 80 characters. **Note:** When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance slows down while Salesforce generates one for each record. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| Fullname | string | Create, Group, Nillable | The full name of the associated metadata object in Metadata API. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | Required. Language of the label. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Filter, Group, Sort | The name of the resource. Specify up to 100 characters. |
| Metadata | mns:CustomHelpMenuSection | Create, Nillable, Update | Metadata for the item contained in the custom help section, including label, URL, and sort order. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the `namespacePrefix__componentName` notation. The namespace prefix can have one of the following values. • In Developer Edition orgs, NamespacePrefix is set to the namespace prefix of the org for all objects that support it, unless an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition org of the package developer. • In orgs that are not Developer Edition orgs, NamespacePrefix is set only for objects that are part of an installed managed package. All other objects have no namespace prefix. |

### IconDefinition

Represents an icon, such as used for a tab. Available in API version 43.0 and later.

> **Note:** In API version 45.0 and later, only users with the "ViewSetup and Configuration" [sic — 띄어쓰기 없음] permission can access IconDefinition.

- **Version:** API version 43.0 and later.
- **Supported SOAP Calls:** query()
- **Supported REST HTTP Methods:** Query, GET
- **Special Access Rules:** (위 Note에 따라) In API version 45.0 and later, only users with the "View Setup and Configuration" permission can access IconDefinition.

| Field | Type | Properties | Description |
|---|---|---|---|
| ContentType | string | Filter, Group, Nillable, Sort | The tab icon's content type, for example, image/png. |
| DurableId | string | Filter, Group, Nillable, Sort | Unique identifier for the field. Always retrieve this value before using it, as the value isn't guaranteed to stay the same from one release to the next. To simplify queries, use this field. |
| Height | int | Filter, Group, Nillable, Sort | Height of the icon in pixels. If the icon content type is SVG, the Height and Width values are not used. |
| TabDefinitionId | string | Filter, Nillable, Sort | The ID of the tab this definition belongs to. Defaults to null. |
| Theme | string | Filter, Group, Nillable, Sort | The user interface theme this definition is associated with. |
| Url | string | Filter, Group, Nillable, Sort | The fully qualified URL for this icon. The default icon is a cloud. |
| Width | int | Filter, Group, Nillable, Sort | The icon's width in pixels. If the icon content type is SVG, the Height and Width values are not used. |

---

## 액션 & 버튼 (Actions & Buttons)

> 퀵액션 정의(QuickActionDefinition)와 그 목록·항목(QuickActionList·QuickActionListItem), 커스텀 버튼/링크(WebLink), Actions & Recommendations 배포(RecordActionDeployment). 퍼블리셔/퀵액션의 클라이언트 JS API는 [[Quick Action·Publisher JS API 레퍼런스]] 참조.

### QuickActionDefinition

Represents the definition of a quick action. This object is available in API version 32.0 and later.

> 퍼블리셔/퀵액션의 클라이언트측 JS API(`force:recordData`·`e.force:closeQuickAction` 등)는 [[Quick Action·Publisher JS API 레퍼런스]] 참조. 이 객체는 퀵액션의 *정의(서버 메타데이터)*를 다룬다.

- **Version:** API version 32.0 and later.
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| ActionSubtype | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The subtype of the action. Valid values are: • Action • ScreenAction. This field is available in API version 50.0 and later. This field is available only for Lightning web component quick actions. |
| Description | textarea | Filter, Group, Nillable, Sort | The description of the action. |
| DeveloperName | string | Filter, Group, Sort | The unique name of the action in the API. This field corresponds to the Name field in the user interface. Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| EntityDefinitionId | string | Filter, Group, Nillable, Sort | The ID of the object associated with the quick action. **Relationship Name:** EntityDefinition · **Relationship Type:** Lookup · **Refers To:** EntityDefinition |
| FullName | string | Create, Group, Nillable | The full name of the associated metadata object in Metadata API. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Height | int | Filter, Group, Nillable, Sort | The height of the action, in pixels. This field is set only when the quick action has a custom icon. |
| IconId | reference | Filter, Group, Nillable, Sort | The ID of the action icon. This field is set only when the quick action has a custom icon. **Relationship Name:** Icon · **Relationship Type:** Lookup · **Refers To:** StaticResource |
| Label | string | Filter, Group, Nillable, Sort | The action label that corresponds to the Label field in the user interface. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the action. Valid values are: (PathAssistant와 동일한 Language enum — zh_CN … th, 아래 §공유 enum 참조) |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. This field is available in API version 38.0 and later. |
| MasterLabel | string | Filter, Group, Sort | The action label. |
| Metadata | QuickAction | Create, Nillable, Update | The metadata for the quick action. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace of the action. |
| OptionsCreateFeedItem | boolean | Filter, (Group/Sort per source) | Indicates whether successful completion of the action creates a feed item (true) or not (false). Applies only to Create Record, Update Record, and Log a Call quick action types. Available in API version 36.0 and later. |
| SobjectType | picklist | Filter, Group, Restricted picklist, Sort | The associated object's API name. For example, FeedItem. |
| StandardLabel | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The standard label for the action. Valid values are: (StandardLabel enum 아래 참조) |
| SuccessMessage | string | Filter, Group, Nillable, Sort | The message that displays to the user upon successful completion of the action. Available in API version 36.0 and later. |
| TargetField | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The API name of the parent object for the record created by this quick action. For example, CollaborationGroup. |
| TargetRecordTypeId | reference | Filter, Group, Nillable, Sort | The ID of the target record type. **Relationship Name:** TargetRecordType · **Relationship Type:** Lookup · **Refers To:** RecordType |
| TargetSobjectType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The API name of the type of object record this action creates. For example, OpportunityLineItem. |
| Type | picklist | Filter, Group, Restricted picklist, Sort | The type of action. Valid values are: (Type enum 아래 참조) |
| Width | int | Filter, Group, Nillable, Sort | The width of the action, in pixels. This field is set only when the quick action has a custom icon. |

#### QuickActionDefinition `StandardLabel` enum — FULL value list (verbatim, 버전 주석 포함)

- AddRecord
- AddMember
- ChangeDueDate
- ChangePriority
- ChangeStatus
- CreateNew
- CreateNewRecordType  (For example, a label with something like "Create New Idea")
- Defer
- EditDescription
- EnrollInProgram  (Available in API versions 46.0 and later only if the org has Health Cloud enabled)
- Escalate
- EscalateToRecord
- Forward  (Available in API version 42.0 and later)
- LogACall
- LogANote
- ModifyAppointment  (Available in API version 47.0 and later)
- New  (A new record)
- NewChild  (A new child record)
- NewChildRecordType
- NewRecordType  (For example, a label with something like "New Idea")
- OfferFeedback
- PatientDetails  (Available in API version 57.0 and later if the org has Health Cloud enabled)
- PerformCount  (Available in API version 63.0 and later.)
- Quick  (A quick record)
- QuickRecordType
- RelocateAsset  (Available in API version 63.0 and later)
- ReplaceAsset  (Available in API version 63.0 and later)
- Reply  (Available in API version 42.0 and later)
- ReplyAll  (Available in API version 42.0 and later)
- RequestFeedback
- SendEmail  (This value is available in API version 31.0 and later.)
- Update

#### QuickActionDefinition `Type` enum — FULL value list (verbatim, 버전 주석 포함)

- Canvas
- Create
- Flow  (This value is available as a Beta in API version 41.0 and later.)
- LightningComponent  (This value is available in API version 38.0 and later.)
- LogACall
- Post
- SendEmail
- SocialPost
- Update
- VisualforcePage

#### QuickActionDefinition — Usage (verbatim)

A QuickActionDefinition represents information about a quick action. The following example creates a global quick action that lets users quickly create a task.

```java
QuickActionDefinition qad = new QuickActionDefinition();
qad.setDeveloperName("MyQuickCreateTaskAction");
qad.setSobjectType("Global");
qad.setTargetSobjectType("Task");
qad.setMasterLabel("Quick create a task");
qad.setType(QuickActionType.Create);
qad.setDescription("Quickly creates a Task");

sforce.create(new SObject[]{qad});
```

### QuickActionList

Represents a list of quick actions. This object is available in API version 32.0 and later.

- **Version:** API version 32.0 and later.
- **Supported SOAP Calls:** create(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| LayoutId | reference | Create, Filter, Group, Sort | The ID of the associated layout. |

#### QuickActionList — Usage (verbatim)

A QuickActionList is a junction between QuickActionListItem objects and a layout. If a layout doesn't have an associated QuickActionList, it inherits the actions from the global page layout.
The following example retrieves all quick action lists in an organization and their associated layout ID.

```java
String query = "SELECT Id,LayoutId FROM QuickActionList";
SObject[] records = sforce.query(query).getRecords();

for (int i = 0; i < records.length; i++) {
   QuickActionList list = (QuickActionList)records[i];
   String relatedLayoutId = list.get("LayoutId");
}
```

### QuickActionListItem

Represents an item in a quick action list. This object is available in API version 32.0 and later.

- **Version:** API version 32.0 and later.
- **Supported SOAP Calls:** create(), delete(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| QuickActionDefinition | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The enum name or ID of the QuickActionDefinition that's associated with this list item. Valid values are: (아래 picklist enum 참조) |
| QuickActionListId | reference | Create, Filter, Group, Sort | The ID of the QuickActionList associated with this list item. |
| SortOrder | int | Create, Filter, Group, Sort, Update | The order in which this list item appears in the picklist. This field must be an ordinal number greater than 0, and must be unique in the list. |

#### QuickActionListItem `QuickActionDefinition` 필드 — picklist 유효 값 (verbatim, 완전 — 페이지 경계 전 종료, 연속 없음)

- Case.ChangeStatus
- Case.LogACall
- FeedItem.ContentPost
- FeedItem.LinkPost
- FeedItem.MobileSmartActions
- FeedItem.PollPost
- FeedItem.QuestionPost
- FeedItem.TextPost

#### QuickActionListItem — Usage (verbatim)

A QuickActionListItem associates a QuickActionDefinition with a QuickActionList. You can query to find out which quick actions are in a list, insert or delete to add or remove quick actions from a list, and update to change the order of quick actions in the list.
The following example reverses the order in the list of the actions, and then removes the first action from the list.

```java
String query = "SELECT Id,SortOrder FROM QuickActionListItem Where QuickActionListId='" +
 listId + "'"
SObject[] records = sforce.query(query).getRecords();

for(int i=0;i<records.length;i++) {
   QuickActionListItem item = (QuickActionListItem)records[i];
   item.setSortOrder(records.length-i);
}

sforce.update(records);

// Last record in array is first record in reordered list
sforce.delete(records[records.length-1].getId());
```

### WebLink

Represents a custom button or link. Available in the Tooling APIfrom API version 34.0 or later. [sic — 원문이 "Tooling APIfrom" 띄어쓰기 없음]

> AP-08: v67.0 WebLink에는 **`Behavior` 필드도 `ContentSource` 필드도 없다.** 렌더/동작은 `LinkType`·`OpenType`·`DisplayType`으로 표현된다 — 두 필드를 fabricate하지 않는다.

- **Version:** Tooling API 34.0 or later.
- **Supported SOAP Calls:** getUpdated(), query(), retrieve(), search()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | string | Filter, Nillable, Sort | A description of the button or link. |
| DisplayType | string | Filter, Group, Restricted picklist, Sort | Represents how the button or link is rendered. Valid values are: • link for a hyperlink • button for a button • massActionButton for a button attached to a related list |
| EncodingKey | string | Filter, Sort | Valid values include: (EncodingKey enum 아래 참조) |
| EntityDefinition | EntityDefinition | Filter, Group, Sort. | Required. Available in API version 34.0. The entity definition for the object associated with this button or link. |
| EntityDefinitionId | string | Filter, Group, Sort. | Required. ID of the record associated with the button or link. The record's object type is in EntityDefinition. |
| FullName | string | Filter, Group, Sort. | The full name of the associated metadata object in Metadata API. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| HasMenubar | boolean | Defaulted on create, Filter, Group, Sort. | If OpenType is newWindow, this field indicates whether to show the browser menu bar for the popup window (true, or not (false). For other values of OpenType, don't specify a value here. [sic — "(true," 닫는 괄호 누락] |
| HasScrollbars | boolean | Defaulted on create, Filter, Group, Sort. | If the value of OpenType is newWindow, this field indicates whether to show the scroll bars for the window (true) or not (false). For other values of OpenType, don't specify a value here. |
| HasToolbar | boolean | Defaulted on create, Filter, Group, Sort. | If the value of OpenType is newWindow, this field indicates whether to show the browser toolbar for the window (true) or not (false). For other values of OpenType, don't specify a value here. |
| Height | int | Filter, Group, Nillable, Sort. | Required if the value of OpenType is newWindow. Height in pixels of the window opened by the button or link. For other values of OpenType, don't specify a value here. |
| IsResizable | boolean | Defaulted on create, Filter, Group, Sort. | If the value of OpenType is newWindow, this field indicates whether to allow resizing of the window (true) or not (false). For other values of OpenType, don't specify a value here. |
| LinkType | WebLinkType enumerated list | Filter, Group, Restricted picklist, Sort | Required. Represents whether the content of the button or link is specified by a URL, an sControl, a JavaScript code block, or a Visualforce page. • url • sControl • javascript • page • flow—Reserved for future use. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Filter, Group, Nillable, Sort, Update | Master label for this object. This display value is the internal label that is not translated. Limit: 240 characters. |
| Metadata | mns:WebLink | Filter, Group, idLookup, Sort | The metadata for this object as defined in the Metadata API. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Name | string | Filter, Group, idLookup, Sort | Required. Name to display on the page. |
| NamespacePrefix | string | Filter, Group, Sort. | The namespace prefix associated with this object. Each Developer Edition organization that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values: • In Developer Edition organizations, the namespace prefix is set to the namespace prefix of the organization for all objects that support it. There is an exception if an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition organization of the package developer. • In organizations that are not Developer Edition organizations, NamespacePrefix is only set for objects that are part of an installed managed package. There is no namespace prefix for all other objects. |
| OpenType | WebLinkWindowType enumerated list | Filter, Group, Sort | The window style used to display the content. Valid values are: • newWindow • sidebar • noSidebar • replace • onClickJavaScript |
| Position | WebLinkPosition enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | If the value of OpenType is newWindow, this field indicates how the new window should be displayed. Otherwise, don't specify a value. Valid values are: • fullScreen • none • topLeft |
| RequireRowSelection | boolean | Defaulted on create, Filter, Group, Sort | If the value of OpenType is massAction, this field indicates whether to require individual row selection to execute the action for this button (true) or not (false). Otherwise, leave this field empty. |
| Scontrol | string | Filter, Group, Sort | If the value of LinkType is sControl, this field represents the name of the sControl. Otherwise, leave this field empty. |
| ShowsLocation | boolean | Filter, Group, Sort | If the value of OpenType is newWindow, this field indicates whether to show the browser location bar for the window (true) or not (false). Otherwise, leave this field empty. |
| ShowsStatus | boolean | Filter, Group, Sort | If the value of OpenType is newWindow, show the browser status bar for the window (true. Otherwise, don't specify a value. [sic — "(true." 닫는 괄호 누락] |
| Url | string | Filter, Group, Nillable, Sort | Required. Represents the URL of the page to link to. Can include fields as tokens within the URL. Limit: 1,024 KB. If the value of LinkType is url, this field represents the URL value. If the value of LinkType is javascript, this field represents the JavaScript content. For other values of LinkType, leave this field empty. Content must be escaped in a manner consistent with XML parsing rules. |
| Width | int | Filter, Group, Nillable, Sort | The width in pixels of the window opened by the button or link. Required if the value of OpenType is newWindow. Otherwise, leave this field empty. |

#### WebLink `EncodingKey` enum — FULL value list (verbatim)

- UTF-8—Unicode (UTF-8)
- ISO-8859-1—General US & Western Europe (ISO-8859–1, ISO-LATIN-1)
- Shift_JIS—Japanese (Shift-JIS)
- ISO-2022-JP—Japanese (JIS)
- EUC-JP—Japanese (EUC-JP)
- x-SJIS_0213—Japanese (Shift-JIS_2004)
- ks_c_5601-1987—Korean (ks_c_5601-1987)
- Big5—Traditional Chinese (Big5)
- GB2312—Simplified Chinese (GB2312)
- Big5-HKSCS—Traditional Chinese Hong Kong (Big5–HKSCS)

#### WebLink 기타 enum (verbatim)

- **LinkType (WebLinkType):** url · sControl · javascript · page · flow (Reserved for future use.)
- **DisplayType:** link (for a hyperlink) · button (for a button) · massActionButton (for a button attached to a related list)
- **OpenType (WebLinkWindowType):** newWindow · sidebar · noSidebar · replace · onClickJavaScript
- **Position (WebLinkPosition):** fullScreen · none · topLeft

### RecordActionDeployment

Represents configuration settings for the Actions & Recommendations, Action Launcher, and Bulk Action Panel components. RecordActionDeployment is available in API version 45.0 and later.

> C4-3(Actions & Recommendations)에서 이연된 객체. Tooling API v67.0의 액션 영역에는 이 객체만 존재하며, `RecordActionRecommendation`은 아래 `Recommendation` 필드의 서브타입(`mns:RecordActionRecommendation`)으로만 나타난다. `RecordActionRecommendation`·`ActionOverride` 독립 Tooling 객체는 없다.

- **Version:** API version 45.0 and later.
- **Supported SOAP Calls:** create(), delete(), describeLayout(), describeSObject(), query(), retrieve(), update()upsert()  [sic — 원문에 `update()`와 `upsert()` 사이 콤마/공백 없음]
- **Supported REST HTTP Methods:** GET, HEAD, PATCH, POST, DELETE
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| ChannelConfigurations | mns:RecordActionDeploymentChannel | Not applicable. | Channel default settings for the deployment. This field is visible only in the metadata for a record. |
| ComponentName | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Specifies the name of the component used in the deployment. Possible values are: • ActionsAndRecommendations—0 • ActionLauncher—1 • BulkActionPanel—2. This value is available in API version 60.0 and later. For example, a value of 1 indicates that 1 is stored in the database if Action Launcher is used to create a deployment. Available in API version 56.0 and later. Available in API version 56.0 and later. [sic — 문장이 원문에서 중복됨] |
| DeploymentContexts | mns:RecordActionDeploymentContext | Not applicable. | Object context for the deployment. This field is visible only in the metadata for a record. Available in API version 46.0 and later. |
| DeveloperName | string | Filter, Group, Sort | A unique name for this record action deployment. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. Provides a globally unique identifier for the record action deployment, which prevents conflicts with other record action deployments that have the same MasterLabel. Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| FullName | string | Filter, Group, Sort | The unique name used as the record action deployment identifier for API access. The fullName can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| HasGuidedActions | boolean | Defaulted on create, Filter, Group, Sort | If true, indicates that the component shows standard actions; for example, flows and quick actions. Available in API version 46.0 and later. |
| HasComponents | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the record actions deployment includes components (true) or not (false). |
| HasOmniscripts | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the record actions deployment includes OmniScripts (true) or not (false). Available in API version 56.0 and later. The default value is false. |
| HasRecommendations | boolean | Defaulted on create, Filter, Group, Sort | If true, indicates that the component shows recommendations from a Next Best Action strategy. Available in API version 46.0 and later. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The language of the record action deployment. The following values are supported: (PathAssistant와 동일한 Language enum — zh_CN … th, 아래 §공유 enum 참조) |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Filter, Group, Sort | The name of the deployment. |
| Metadata | mns:RecordActionDeployment | Create, Nillable, Update | Metadata that defines record action deployments. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix associated with the record action deployment, which is assigned to the AppExchange package. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. The namespace helps differentiate custom objects and fields from those in use by other record action deployments. |
| Recommendation | mns:RecordActionRecommendation | Not applicable. | Settings for how Next Best Action recommendations appear. This field is visible only in the metadata for a record. Available in API version 46.0 and later. |
| SelectableItems | mns:RecordActionSelectableItem | Not applicable. | A subset of actions that users can launch at runtime. This field is visible only in the metadata for a record. |

> 참조 서브객체(metadata-only 복합 타입, 자체 Tooling 페이지 없음): RecordActionDeploymentChannel · RecordActionDeploymentContext · RecordActionRecommendation · RecordActionSelectableItem.

---

## 경로 · 관련 목록 · 검색 (Path & Related Lists & Search)

> 경로(PathAssistant·PathAssistantStepInfo·PathAssistantStepItem)·관련 목록 컬럼(RelatedListColumnDefinition)·검색 레이아웃(SearchLayout)·Path 애니메이션 규칙(AnimationRule).

### PathAssistant

Represents a Path. Available in Tooling API version 36.0 and later.

> **Important:** Where possible, we changed noninclusive terms to align with our company value of Equality. Because changing terms in our code can break current implementations, we maintained this object's name.

- **Version:** Tooling API 36.0 and later.
- **Supported SOAP Calls:** retrieve(), query()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | The unique name of the path in the API. |
| FullName | string | Group, Nillable | The name of the path in the Metadata API. Query this field only if the query result contains no more than 1 record. Otherwise, an error is returned. If more than 1 record exists, use multiple queries to retrieve the records. This limit protects performance. |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the path is active (true) or inactive (false). |
| IsDeleted | boolean | Sort | Indicates whether the record has been moved to the Recycle Bin (true) or not (false). |
| IsMasterRecordType | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether this path is for the main record type (true) or not (false). |
| Language | string | Filter, Group, Restricted picklist, Sort | The language of the path. Valid values are: (아래 §공유 enum — Language 참조) |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: (아래 §공유 enum — ManageableState 참조) |
| MasterLabel | string | Filter, Group, Sort | Label for this path. |
| Metadata | msn:PathAssistant | Create, Nillable, Update | Path metadata from the msn namespace. Query this field only if the query result contains no more than 1 record. Otherwise, an error is returned. If more than 1 record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values. • In Developer Edition orgs, NamespacePrefix is set to the namespace prefix of the org for all objects that support it, unless an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition org of the package developer. • In orgs that are not Developer Edition orgs, NamespacePrefix is set only for objects that are part of an installed managed package. All other objects have no namespace prefix. This field can't be accessed unless the logged-in user has the "Customize Application" permission. |
| RecordTypeId | ID | Filter, Group, Nillable, Sort | The unique identifier for a record type. |
| SobjectProcessField | string | Filter, Group, Restricted picklist, Sort | Name of the picklist field which determines the steps you can use in the path. For example, OpportunityStage in the case of opportunities or LeadStatus in the case of leads. |
| SobjectType | string | Filter, Group, Restricted picklist, Sort | The object this path relates to. Valid values are: Opportunity, Lead, Quote, or the API name of a custom object. |

#### §공유 enum — Language (Restricted picklist)

PathAssistant · PathAssistantStepInfo · QuickActionDefinition · RecordActionDeployment이 공유하는 Language enum (verbatim, 전수):

- Chinese (Simplified): zh_CN
- Chinese (Traditional): zh_TW
- Danish: da
- Dutch: nl_NL
- English: en_US
- Finnish: fi
- French: fr
- German: de
- Italian: it
- Japanese: ja
- Korean: ko
- Norwegian: no
- Portuguese (Brazil): pt_BR
- Russian: ru
- Spanish: es
- Spanish (Mexico): es_MX  (Spanish (Mexico) defaults to Spanish for customer-defined translations.)
- Swedish: sv
- Thai: th  (The Salesforce user interface is fully translated to Thai, but Help is in English.)

#### §공유 enum — ManageableState

이 배치 다수 객체가 공유 (verbatim, 전수):

- beta
- deleted
- deprecated
- deprecatedEditable
- installed
- installedEditable
- released
- unmanaged

### PathAssistantStepInfo

Represents guidance for a step on a Path. Available in Tooling API version 36.0 and later.

- **Version:** Tooling API 36.0 and later.
- **Supported SOAP Calls:** update(), query()
- **Supported REST HTTP Methods:** GET, PATCH
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | The unique name of the path guidance information. |
| Info | string | Filter, Nillable, Sort | The text of the guidance displayed to the user in the user interface. |
| IsDeleted | boolean | Sort | Indicates whether the record has been moved to the Recycle Bin (true) or not (false). |
| Language | string | Filter, Group, Restricted picklist, Sort | The language of the path. Valid values are: (PathAssistant와 동일한 Language enum — zh_CN … th, §공유 enum 참조) |
| MasterLabel | string | Filter, Group, Sort | Label for this path guidance information record. |

### PathAssistantStepItem

Represents layout or guidance details for a step on a Path. Available in Tooling API version 36.0 and later.

- **Version:** Tooling API 36.0 and later.
- **Supported SOAP Calls:** query()
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| IsDeleted | boolean | Sort | Indicates whether the record has been moved to the Recycle Bin (true) or not (false). |
| ItemId | ID | Filter, Group, Sort | A foreign key field pointing to the Type field that represents either the layout (if Type is set to Layout) or the PathAssistantStepInfo (if Type is set to Information) of this guidance detail. |
| PathAssistantId | ID | Filter, Group, Sort | ID of the PathAssistant related to this step. |
| RecordTypeId | ID | Filter, Group, Nillable, Sort | ID of the record type associated with this path. |
| Type | string | Filter, Group, Sort | The type of data that ItemId refers to. Valid values are: • Information • Layout |

### RelatedListColumnDefinition

Represents information about a column in a related list. A related list specifies a set of records for a related object, based on specific criteria. This object is available in API version 55.0 and later.

- **Version:** API version 55.0 and later.
- **Supported SOAP API Calls:** describeSObjects(), query()
- **Supported REST API Methods:** Query
- **Special Access Rules:** This object is read-only.

| Field | Type | Properties | Description |
|---|---|---|---|
| Alias | string | Filter, Group, Nillable, Sort | The unique alias of the column in the related list. |
| ColumnSoql | string | Filter, Group, Nillable, Sort | The SOQL query string used in a SELECT clause for the column. |
| DataType | string | Filter, Group, Nillable, Sort | The field type of the column. |
| DurableId | string | Filter, Group, Nillable, Sort | The unique identifier for the column. Always retrieve this value before using it, as the value can change from one release to the next. Simplify queries by using this field instead of making multiple queries. |
| FieldDefinitionId | string | Filter, Group, Nillable, Sort | The ID of the FieldDefinition associated with the column, if applicable. This is a relationship field. **Relationship Name:** FieldDefinition · **Relationship Type:** Lookup · **Refers To:** FieldDefinition |
| IsDefault | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the column appears on the related list by default (true) or not (false). The default value is false. |
| IsDescribable | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the column can appear in the results of a describeLayout call containing the related list (true) or not (false). The default value is false. |
| Label | string | Filter, Group, Nillable, Sort | The label for the column. |
| LookupId | string | Filter, Group, Nillable, Sort | The lookup ID for the column. |
| RelatedListDefinitionId | string | Filter, Group, Nillable, Sort | The ID of the RelatedListDefinition that contains the column. This is a relationship field. **Relationship Name:** RelatedListDefinition · **Relationship Type:** Lookup · **Refers To:** RelatedListDefinition |

#### RelatedListColumnDefinition — Usage (verbatim)

Find all available columns on a related list definition.

```sql
SELECT Alias, ColumnSoql, DurableId FROM RelatedListColumnDefinition WHERE
RelatedListDefinitionId = 'Account.Opportunities'
```

### SearchLayout

Represents a search layout defined for an object. This object is available in the Tooling API version 34.0 and later.

- **Version:** Tooling API 34.0 and later.
- **Supported SOAP Calls:** describeObjects(), query()  [sic — 원문이 "describeObjects()"]
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOQL Limitations on page 38 · SOSL Limitations on page 40.
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| ButtonsDisplayed | SearchLayoutButtonsDisplayed | Nillable | The list of buttons available in list views for an object. This field is equivalent to the Buttons Displayed value in Object Name List View in the Search Layouts related list on the object detail page. It's also equivalent to the listViewButtons field on SearchLayouts in Metadata API. |
| DurableId | string | Filter, Group, Nillable, Sort | Unique identifier for the field. Always retrieve this value before using it, as the value isn't guaranteed to stay the same from one release to the next. DurableId in queries allows you to find the right record without having to retrieve the entire record. |
| EntityDefinition | string | Filter, Group, Nillable, Sort | The name of the object associated with this search layout. Use in subqueries. |
| EntityDefinitionId | string | Filter, Group, Nillable, Sort | ID of the record in EntityDefinition. Use in subqueries. |
| FieldsDisplayed | SearchLayoutFieldsDisplayed | Nillable | The list of fields displayed in a search result for the object. The name field is required. It's always displayed as the first column header, so it isn't included in this list; all additional fields are included. The field name relative to the object name, for example MyCustomField__c, is specified for each custom field. This field is equivalent to the Search Results in the Search Layouts related list on the object detail page in the application user interface. It's also equivalent to searchResultsAdditionalFields in Metadata API. |
| Label | string | Filter, Group, Nillable, Sort | The label for this search layout. |
| LayoutType | string | Filter, Group, Nillable, Sort | The type of search layout. |
| ListLayout | string | Filter, Group, Nillable, Sort | Unique identifier for the field. Identifies the list layout a search layout is related to. Available in API version 48.0 and later. |
| Profile | string | Filter, Group, Nillable, Sort | Unique identifier for the field. Identifies the profile to which a search layout applies. Available in API version 48.0 and later. |
| ProfileName | string | Filter, Group, Nillable, Sort | The name of the profile to which a search layout applies. Available in API version 48.0 and later. |

#### SearchLayout — 서브객체 복합 타입 (verbatim)

`ButtonsDisplayed`/`FieldsDisplayed` 필드가 사용하는 복합 타입 (SearchLayout 바로 뒤에 문서화됨):

*SearchLayoutButtonsDisplayed* (ButtonsDisplayed가 사용):

| Field | Type | Description |
|---|---|---|
| applicable | boolean | If true, the buttons listed in buttons apply to the object associated with this search layout. |
| buttons | SearchLayoutButton | The list of buttons on the object associated with this search layout. |

*SearchLayoutButton:*

| Field | Type | Description |
|---|---|---|
| apiName | string | The API name of the button. |
| label | string | The button's label text. |

*SearchLayoutFieldsDisplayed* (FieldsDisplayed가 사용):

| Field | Type | Description |
|---|---|---|
| applicable | boolean | If true, the fields listed in fields are available in the object associated with this search layout. |
| fields | string | The list of fields on the object associated with this search layout. |

*SearchLayoutField:*

| Field | Type | Description |
|---|---|---|
| apiName | string | The API name of the field. |
| label | string | The field's label text. |
| sortable | boolean | If true, the fields can be sorted. |

### AnimationRule

Represents criteria for determining when an animation is displayed to Path users. Available in API version 46.0 and later.

> **Important:** Where possible, we changed noninclusive terms to align with our company value of Equality. Because changing terms in our code can break current implementations, we maintained this object's name.

- **Version:** API version 46.0 and later.
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, PATCH, POST
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| AnimationFrequency | picklist | Filter, Group, Restricted picklist, Sort | Required. The frequency with which an animation is displayed when a user selects the designated picklist values in a path. Valid values are: **always**, **often**, **sometimes**, **rarely**. A value of `always` triggers an animation every time. The values `often`, `sometimes`, and `rarely` trigger an animation progressively less frequently. |
| DeveloperName | string | Filter, Group, Sort, Update | The developer name for the animation rule. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| FullName | string | Create, Group, Nillable | The full name of the associated metadata object in Metadata API. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the animation rule is active (true) or not (false). |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The language in the user's personal settings. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | The label for the animation rule. |
| Metadata | complexvalue | Create, Nillable, Update | AnimationRule metadata from the mns namespace. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| RecordTypeContext | picklist | Filter, Group, Restricted picklist, Sort | An enum to track whether this AnimationRule applies to all record types for the associated sObject, or only to a single or main record type. Valid values are **All**, **Custom**, and **Master**. |
| RecordTypeId | reference | Filter, Group, Nillable, Sort | The record type selected for the sObject in which the animation is displayed. |
| SobjectType | string | Filter, Group, Restricted picklist, Sort | The object on which the animation rule is run. |
| TargetField | string | Filter, Group, Restricted picklist, Sort | Name of the field used to determine when to display an animation. |
| TargetFieldChangeToValues | string | Filter, Group, Sort | Values used to determine when to display an animation. When a user selects a value in TargetField that matches a value stored in TargetFieldChangeToValues, the animation is displayed. |

---

## 관련 노트

- [[Tooling API — 개요·REST·SOAP 호출 기초]] — 폴더 허브. REST/SOQL 쿼리 리소스·헤더·composite·EOL 등 호출 기초.
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 객체↔네임스페이스 분류, SOQL/SOSL 한도, System Fields, ApiFault.
- [[Tooling API — SOAP·REST 헤더]] — 호출 시 사용하는 SOAP/REST 헤더.
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — 형제 Ch4 도메인 노트(Apex 코드·테스트 sObject 군).
- [[Tooling API 객체 — Entity·Field·스키마]] — 형제 Ch4 도메인 노트. RecordType·FieldSet·CompactLayout 필드 컬럼, ValidationRule 관계 언급.
- [[Tooling API 객체 — 보안·권한]] — 형제 Ch4 도메인 노트. ProfileLayout·PermissionSetTabSetting의 정본.
- [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] — 형제 Ch4 도메인 노트(자동화 sObject 군). RecordActionDeployment의 C4-3→C4-4 이연 출발점.
- [[Quick Action·Publisher JS API 레퍼런스]] — (Aura) 퀵액션/퍼블리셔의 클라이언트측 JS API. QuickActionDefinition의 런타임 짝.
- [[apex 컴포넌트 — 페이지·레이아웃 구조]] — (Visualforce) 클래식 페이지 레이아웃의 구조·렌더링 맥락. Layout 객체의 응용.
- ⚙️ [[platform-flexipage-generate]] — (sf-skill) FlexiPage(라이트닝 페이지) 생성/스캐폴딩 실행 대응(지식=위키·실행=스킬 프로토콜).
