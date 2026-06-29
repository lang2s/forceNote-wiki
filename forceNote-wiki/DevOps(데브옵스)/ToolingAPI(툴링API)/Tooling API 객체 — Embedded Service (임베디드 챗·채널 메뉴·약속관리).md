---
tags: [tooling-api, devops, embedded-service, snap-ins, embedded-chat, channel-menu, appointment-management, messaging]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-29
aliases: [EmbeddedServiceBranding, EmbeddedServiceConfig, EmbeddedServiceCustomComponent, EmbeddedServiceCustomization, EmbeddedServiceCustomLabel, EmbeddedServiceFieldService, EmbeddedServiceFlow, EmbeddedServiceFlowConfig, EmbeddedServiceLiveAgent, EmbeddedServiceMenuItem, EmbeddedServiceMenuSettings, EmbeddedServiceQuickAction, EmbeddedServiceResource, 임베디드 서비스, 스냅인, 임베디드 챗, 채팅 위젯, 채널 메뉴, 약속 관리, 사전 채팅 폼, Embedded Service 배포 객체, 임베디드 챗 위젯 설정, 채널 메뉴 항목 추가, Tooling API로 채팅 위젯 만들기]
---

# Tooling API 객체 — Embedded Service (임베디드 챗·채널 메뉴·약속관리)

> Embedded Service(스냅인) 배포용 Tooling sObject 13종 전수 — 임베디드 챗(LiveAgent·QuickAction)·채널 메뉴(MenuSettings·MenuItem)·약속관리(FieldService)·Flow 임베딩(Flow·FlowConfig)·배포 핵심(Config·Branding)·커스터마이즈(CustomComponent·CustomLabel·Customization·Resource)를 SOQL 조회 / create·update로 운영한다.

이 노트는 Tooling API Reference & Developer Guide v67.0(Summer '26)의 "Tooling API Objects" 챕터 중 **Embedded Service(스냅인) 배포 도메인 sObject 군**을 다룬다. Embedded Service는 웹 페이지·모바일 앱에 채팅 위젯, 채널 메뉴, 약속 예약, Flow를 임베드하는 기능이다. 모든 배포의 중심 노드는 **EmbeddedServiceConfig**(배포 setup node)이며, 그 위에 채팅(LiveAgent)·채널 메뉴(MenuSettings)·약속관리(FieldService)·Flow(Flow/FlowConfig) 기능 객체가 얹히고, CustomComponent·CustomLabel·Customization·Resource로 룩앤필을 커스터마이즈한다. 대부분 `query()`로 SOQL 조회가 가능하며 `create()`/`update()`/`upsert()`로 구성한다.

> 표기 규약: 필드표는 PDF 추출본의 충실 transcription이다. 여러 객체에서 동일 verbatim으로 반복되는 boilerplate 필드(**NamespacePrefix**, **FullName**·**Metadata**의 쿼리 제한 문구)는 노트 하단 "공통 블록"으로 1회 정의하고 각 표에서 참조한다(값/규칙 자체는 공통 블록에 전부 보존 — 누락 아님). **Language** 피클리스트는 객체군에 따라 값 목록이 다른 **2종(A형 19값 / B형 18값)**으로 갈리므로 절대 합치지 않고 공통 블록 2개로 분리한다.

> Removed 필드(EmbeddedServiceConfig.CustomMinimizedComponentId, EmbeddedServiceLiveAgent.CustomPrechatComponent, EmbeddedServiceLiveAgent.HeaderBackgroundImg)는 원문이 더 이상 사용하지 않음을 명시하나, 검색 혼동 방지를 위해 표 행을 삭제하지 않고 `Removed.` 마커와 버전 정보를 그대로 보존한다.

---

## 객체 빠른 색인

| 객체 | 기능 분류 | 필드 수 | API 최소 버전 |
|---|---|---|---|
| [EmbeddedServiceConfig](#embeddedserviceconfig) | 배포 핵심 | 17 | 38.0 |
| [EmbeddedServiceBranding](#embeddedservicebranding) | 배포 핵심 (브랜딩) | 15 | 39.0 (Tooling) |
| [EmbeddedServiceLiveAgent](#embeddedserviceliveagent) | 임베디드 챗 | 24 | 38.0 (Tooling) |
| [EmbeddedServiceQuickAction](#embeddedservicequickaction) | 임베디드 챗 (사전채팅 폼) | 4 | 39.0 (Tooling) |
| [EmbeddedServiceMenuSettings](#embeddedservicemenusettings) | 채널 메뉴 | 9 | 47.0 |
| [EmbeddedServiceMenuItem](#embeddedservicemenuitem) | 채널 메뉴 (항목) | 15 | 47.0 |
| [EmbeddedServiceFieldService](#embeddedservicefieldservice) | 약속 관리 (beta) | 17 | 43.0 (Tooling) |
| [EmbeddedServiceFlow](#embeddedserviceflow) | Flow 임베딩 | 5 | 45.0 |
| [EmbeddedServiceFlowConfig](#embeddedserviceflowconfig) | Flow 임베딩 | 4 | 45.0 |
| [EmbeddedServiceCustomComponent](#embeddedservicecustomcomponent) | 커스터마이즈 | 4 | 44.0 |
| [EmbeddedServiceCustomLabel](#embeddedservicecustomlabel) | 커스터마이즈 | 5 | 44.0 |
| [EmbeddedServiceCustomization](#embeddedservicecustomization) | 커스터마이즈 | 3 | 52.0 |
| [EmbeddedServiceResource](#embeddedserviceresource) | 커스터마이즈 (리소스) | 3 | 50.0 |

> 필드 수 합계 = **125** (Config 17 · Branding 15 · LiveAgent 24 · QuickAction 4 · MenuSettings 9 · MenuItem 15 · FieldService 17 · Flow 5 · FlowConfig 4 · CustomComponent 4 · CustomLabel 5 · Customization 3 · Resource 3). Removed 필드 3개(Config 1 + LiveAgent 2)는 각 객체 필드 수에 포함되어 행으로 보존된다.

---

## 1. 배포 핵심 (Config · Branding)

> Embedded Service 배포의 중심 setup node와 브랜딩 색상/폰트. 다른 모든 기능 객체는 `EmbeddedServiceConfigId`로 Config를 참조한다.

### EmbeddedServiceConfig

Represents a setup node for creating an Embedded Service deployment.

- **Version:** Available in API version 38.0 and later.
- **Supported Calls:** create(), delete(), describeSObjects(), describeLayout(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** GET, POST, PATCH, DELETE
- **Special Access Rules:** 없음

| Field | Type | Properties | Description |
|---|---|---|---|
| AreGuestUsersAllowed | boolean | Defaulted on Create, Filter, Group, Sort | Specifies whether a user must be logged in to access an embedded component. Available in API version 45.0 and later. |
| AuthMethod | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Type of login method selected for this Embedded Service deployment. Valid values are: CommunitiesLogin, CustomLogin. Available in API version 43.0 and later. |
| BrandingId | reference | Filter, Group, Nillable, Sort | The developer name of the associated BrandingSet. Used only for Embedded Service Deployments of the Messaging type. Used only when DeploymentFeature is EmbeddedMessaging. Available in API version 52.0 and later. This is a relationship field. Relationship Name: Branding. Relationship Type: Lookup. Refers To: BrandingSet |
| CustomMinimizedComponentId | reference | Filter, Group, Nillable, Sort | **Removed.** The custom Lightning component that's used for the minimized state for this Embedded Chat deployment. Available in API version 38.0 to 45.0. |
| DeveloperName | string | Filter, Group, Sort | Unique name for the Embedded Service configuration setup node. *Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field.* |
| DeploymentFeature | picklist | Filter, Group, Restricted picklist, Sort | Where the Embedded Service deployment is used. After the value is set, it can't be updated. Available in API version 52.0 and later. Possible values are: EmbeddedMessaging, FieldService, Flows, LiveAgent, None |
| DeploymentType | picklist | Filter, Group, Restricted picklist, Sort | Set a conversation type for your embedded deployment. This field is available in version 51.0 and later. Possible values are: Mobile, Web |
| FullName | string | Create, Group, Nillable | The unique name used for this Embedded Service deployment. The fullName can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. (쿼리 제한: 공통 블록 D 참조) |
| IsEnabled | boolean | Defaulted on Create, Filter, Group, Sort | Specifies if the Embedded Service Deployment is enabled for use. Available in API version 52.0 and later. |
| isTermsAndConditionsEnabled | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether Terms and Conditions are displayed. Displaying Terms and Conditions is supported if the deploymentFeature is either EmbeddedMesssaging or LiveAgent. Available in API version 59.0 and later. The default value is false. |
| isTermsAndConditionsRequired | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether acceptance of the Terms and Conditions is required before starting a chat. Displaying Terms and Conditions is supported if the deploymentFeature is either EmbeddedMesssaging or LiveAgent. Available in API version 59.0 and later. The default value is false. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | Languages supported in the Embedded Service deployment. (값 목록: **공통 Language 블록 B형(18값)** 참조) |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| MasterLabel | string | Filter, Group, Sort | Name of the embedded service configuration node. |
| Metadata | mns:EmbeddedServiceConfig | Create, Nillable, Update | The Embedded Service configuration metadata. (쿼리 제한: 공통 블록 D 참조) |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. (공통 boilerplate — 공통 블록 C 참조) |
| ShouldHideAuthDialog | boolean | Defaulted on create, Filter, Group, Sort | Specifies whether the prompt that the customer login again during a flow is hidden (true) or not (false). When it's hidden, the customer is taken directly to your login page. This field is set to false by default. Available in API version 43.0 and later. |

### EmbeddedServiceBranding

Represents branding for each Embedded Service deployment.

- **Version:** Available in Tooling API version 39.0 and later.
- **Supported SOAP Calls:** create(), delete(), describe(), query(), retrieve(), update()
- **Supported REST HTTP Methods:** DELETE, GET, HEAD, PATCH, POST, PUT, Query
- **Special Access Rules:** 없음

| Field | Type | Properties | Description |
|---|---|---|---|
| ContrastInvertedColor | string | Filter, Group, Nillable, Sort | Accent branding color used in the embedded component, displayed as a hexadecimal value. Changes made to this field in the API aren't reflected in the embedded component. Available in API version 43.0 and later. |
| ContrastPrimaryColor | string | Filter, Group, Nillable, Sort | Accent branding color used in the embedded component, displayed as a hexadecimal value. |
| DeveloperName | string | Filter, Group, Sort | The unique name of the branding component. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated, but you can supply your own value if you create the record using the API. *Note: When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance may slow while Salesforce generates one for each record.* *Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field.* |
| Font | string | Create, Filter, Group, Sort, Update | Font used in the text of the embedded component. |
| FullName | string | Create, Group, Nillable | The full name of the associated EmbeddedServiceBranding in Metadata API. The full name can include a namespaceprefix. (쿼리 제한: 공통 블록 D 참조) |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the embedded component. (값 목록: **공통 Language 블록 A형(19값)** 참조) |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| MasterLabel | string | Filter, Group, Sort | Label for the embedded component. |
| Metadata | EmbeddedServiceBranding | Create, Nillable, Update | The embedded service branding's metadata. (쿼리 제한: 공통 블록 D 참조) |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. (공통 boilerplate — 공통 블록 C 참조) |
| NavBarColor | string | Create, Filter, Group, Sort, Update | Color used for the navigation bar in the embedded component. |
| NavBarTextColor | string | Filter, Group, Nillable, Sort | Color used for the text and icons in the header in the embedded component, displayed as a hexadecimal value. Available in API version 49.0 and later. |
| PrimaryColor | string | Create, Filter, Group, Sort, Update | Primary branding color used in the embedded component. |
| SecondaryColor | string | Create, Filter, Group, Sort, Update | Secondary branding color used in the embedded component. |
| SecondaryNavBarColor | string | Filter, Group, Nillable, Sort | Secondary branding color used for the header in the embedded component, displayed as a hexadecimal value. It applies to the header in the chat feature when it's trying to reconnect because of lost internet connection. Available in API version 49.0 and later. |

---

## 2. 임베디드 챗 (Chat / Live Agent)

> 웹 페이지에 추가하는 Chat 위젯 배포와 사전 채팅(pre-chat) 폼 quick action. 런타임 배포 API(로깅·윈도우·버튼)는 [[Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼]] 참조.

### EmbeddedServiceLiveAgent

Represents a setup node for creating an Embedded Chat deployment.

- **Version:** Available in Tooling API version 38.0 and later.
- **Supported Calls:** create(), delete(), describeLayout(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, HEAD, PATCH, POST, PUT, Query
- **Special Access Rules:** To access EmbeddedServiceLiveAgent, your org must have Service Cloud with Chat enabled.

| Field | Type | Properties | Description |
|---|---|---|---|
| AvatarImg | url | Filter, Group, Nillable, Sort | URL of the image used as the agent avatar image. Available in API version 43.0 and later. |
| CustomPrechatComponent | string | Filter, Group, Nillable, Sort | **Removed.** The ID of the custom Lightning Component that's used for the pre-chat page in this embedded deployment. Available in API versions 38.0 to 45.0. Removed in API version 46.0 and later. |
| DeveloperName | string | Filter, Group, Sort | The unique name for the EmbeddedServiceLiveAgent object. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated, but you can supply your own value if you create the record using the API. *Note: When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance may slow while Salesforce generates one for each record.* *Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field.* |
| EmbeddedServiceConfigId | reference | Filter, Group, Sort | Unique name for the embedded chat deployment ID. |
| Enabled | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether this embedded chat deployment is enabled (true). Available in API version 43.0 and later. |
| FontSize | picklist | Filter, Group, Restricted picklist, Sort | Font size for the chat window. Available in API version 43.0 and later. Possible values are: Small, Medium, Large. Available in API version 43.0 and later. |
| FullName | string | Create, Group, Nillable | The unique name used for this embedded chat deployment. The fullName can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. (쿼리 제한: 공통 블록 D 참조) |
| HeaderBackgroundImg | url | Filter, Group, Nillable, Sort | **Removed.** URL of the image used for the header background in the embedded chat window. Available in API version 43.0. Removed in API version 49.0 and later. |
| IsOfflineCaseEnabled | boolean | Defaulted on create, Filter, Group, Sort | Specifies whether offline support is enabled for this embedded chat deployment (true) or not (false). Available in API version 43.0 and later. |
| IsQueuePositionEnabled | boolean | Defaulted on create, Filter, Group, Sort | Specifies whether queue position (displaying the customer's place in line while they wait for an agent) is enabled for this embedded chat deployment (true) or not (false). Available in API version 43.0 and later. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | Languages supported in the embedded chat deployment. (값 목록: **공통 Language 블록 B형(18값)** 참조) |
| LiveAgentChatUrl | url | Filter, Group, Nillable, Sort | The REST endpoint for Chat. Available in API version 43.0 and later. |
| LiveAgentContentUrl | url | Filter, Group, Nillable, Sort | The REST endpoint for Chat content. Available in API version 43.0 and later. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. Available in API version 43.0 and later. |
| MasterLabel | string | Filter, Group, Sort | Name of the embedded chat deployment. |
| Metadata | mns:EmbeddedServiceLiveAgent | Create, Nillable, Update | The embedded chat metadata. (쿼리 제한: 공통 블록 D 참조) |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. (공통 boilerplate — 공통 블록 C 참조) Available in API version 43.0 and later. |
| OfflineCaseBackgroundImg | string | Filter, Group, Nillable, Sort | URL of the image used for the background for the offline support case form in an embedded chat window. Available in API version 43.0 and later. |
| PrechatBackgroundImg | string | Filter, Group, Nillable, Sort | URL of the image used for the background for the pre-chat form in an embedded chat window. Available in API version 43.0 and later. |
| PreChatEnabled | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether the pre-chat form is enabled for this embedded chat deployment. |
| PrechatJson | string | Nillable | JSON object of all the fields of the selected pre-chat form in Chat setup. Available in API version 43.0 and later. |
| Scenario | picklist | Filter, Group, Restricted picklist, Sort | The type of use case that is selected for the pre-chat form. Valid values are: Basic, Sales, Service |
| SmallCompanyLogoImg | url | Filter, Group, Nillable, Sort | URL of the logo image used with embedded chat. Available in API version 43.0 and later. |
| WaitingStateBackgroundImg | url | Filter, Group, Nillable, Sort | URL of the image used for the background image in an embedded chat window while the customer waits to be connected with a support agent. Available in API version 43.0 and later. |

**Usage:** EmbeddedServiceLiveAgent represents a Chat configuration that is added to your web page. The EmbeddedServiceLiveAgent record contains a unique combination of a Chat button and the Chat deployment that the administrator selects during setup. To create an EmbeddedServiceLiveAgent record, create a Chat Deployment, a Chat Button, and an EmbeddedServiceConfig record. Then, set the fields for these records as references on the EmbeddedServiceLiveAgent record.

### EmbeddedServiceQuickAction

Returns a quick action that is associated with an EmbeddedServiceLiveAgent setup. The quick action includes the pre-chat form fields that the embedded chat window displays and shows the order in which the fields are displayed.

- **Version:** Available in Tooling API version 39.0 and later.
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, POST, PUT, PATCH
- **Special Access Rules:** 없음

| Field | Type | Properties | Description |
|---|---|---|---|
| EmbeddedServiceLiveAgentId | reference | Create, Filter, Group, Sort | Reference to the embedded chat deployment. |
| Order | int | Create, Filter, Group, Sort, Update | Order in which this quick action appears in the embedded chat pre-chat form. |
| QuickActionDefinitionId | reference | Create, Filter, Group, Sort, Update | Reference to a quick action. |
| QuickActionType | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | Quick action type. One of the following values: • Prechat — Pre-chat • OfflineCase — Offline support (Cases). Available in API version 43.0 and later. |

---

## 3. 채널 메뉴 (Channel Menu)

> 채널 메뉴는 고객이 비즈니스에 연락할 수 있는 방법(채팅·전화·메시징·커스텀 URL)을 나열한다. MenuSettings는 배포(부모), MenuItem은 개별 메뉴 항목(자식)이다.

### EmbeddedServiceMenuSettings

Represents a setup node for creating a channel menu deployment. Channel menus list the ways in which customers can contact your business.

> **Important:** Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

- **Version:** Available in API version 47.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeLayout(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** This type is available only if Salesforce Experiences and Salesforce Sites are enabled in your org. To access this type, you need the Customize Application user permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| BrandingId | reference | Filter, Group, Nillable, Sort | The developer name of the associated BrandingSet. |
| DeveloperName | string | Filter, Group, Sort | The unique name for the embedded service menu settings. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated, but you can supply your own value if you create the record using the API. *Note: When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance may slow while Salesforce generates one for each record.* *Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field.* |
| FullName | string | Create, Group, Nillable | The full name of the associated EmbeddedServiceMenuSettings in Metadata API. The full name can include a namespaceprefix. (쿼리 제한: 공통 블록 D 참조) |
| IsEnabled | boolean | Defaulted on create, Filter, Group, Sort | Specifies whether the channel menu is deployed (true) or not (false). |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the embedded service menu. (값 목록: **공통 Language 블록 A형(19값)** 참조) |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. |
| MasterLabel | string | Filter, Group, Sort | Label for the embedded service menu setting. In the UI, this field is Channel Menu Deployment Name. |
| Metadata | EmbeddedServiceMenuSettings | Create, Nillable, Update | The EmbeddedServiceMenuSettings's metadata. (쿼리 제한: 공통 블록 D 참조) |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. (공통 boilerplate — 공통 블록 C 참조) |

> 표기: 위 `ManageableState`의 Type은 PDF 추출 과정에서 중복 표기되었으나 실제 Type은 다른 객체와 동일한 `ManageableState enumerated list`다.

**Usage:** An EmbeddedServiceMenuSettings record creates a channel menu. A channel menu lists the ways in which customers can contact your business. A channel is created using EmbeddedServiceMenuItem and is a child record of EmbeddedServiceMenuSettings. Here you can specify the Site name, BrandingSet name, and whether the channel menu is deployed or not. The Site field is not exposed in the Tooling API but you can edit it using the following Metadata block.

```json
{
"FullName" : "embeddedServiceMenuSettingsName",
"Metadata" : {
"branding" : "brandingSetRecordDevName",
"isEnabled" : true,
"masterLabel" : "embeddedServiceMenuSettingsName",
"site" : "siteRecordDevName"
}
}
```

### EmbeddedServiceMenuItem

Represents the information needed to configure a Channel Menu item.

- **Version:** Available in API version 47.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** This type is available only if Salesforce Experiences and Salesforce Sites are enabled in your org. To access this type, you need the Customize Application user permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| ChannelId | reference | Create, Filter, Group, Nillable, Sort, Update | The unique ID of an EmbeddedServiceConfig (the Embedded Service deployment) if ChannelType is one of the following. Otherwise, this field is null. • EmbeddedServiceConfig • MessagingChannel |
| ChannelType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The channel the customer uses to contact your business. The possible values are: • CustomURL • EmbeddedServiceConfig • MessagingChannel • Phone |
| CustomUrl | url | Create, Filter, Nillable, Sort, Update | The custom URL of the menu item if ChannelType is CustomURL. Otherwise, this field is null. |
| DisplayOrder | int | Create, Filter, Group, Sort, Update | The order that the menu items are displayed in the UI. Only positive values are supported. |
| EmbeddedServiceMenuId | reference | Create, Filter, Group, Sort | Required. The unique ID of the parent record EmbeddedServiceMenuSettings. |
| IconUrl | url | Create, Filter, Nillable, Sort, Update | The URL of the icon used for the menu item. |
| IsDisplayedOnPageLoad | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Specifies whether the menu item is dynamically displayed (true) or hidden (false) during runtime. The default value is false. |
| ItemName | string | Create, Filter, Group, Sort, Update | The unique name used on the Setup for admins to identify the Channel Menu item. Conforms to the same properties as a developer name. |
| OsOptionsHideInIOS | boolean | Create, Filter, Update | Specifies whether to hide the menu item on iOS platforms (true) or not (false). |
| OsOptionsHideInLinuxOS | boolean | Create, Filter, Update | Specifies whether to hide the menu item on Linux platforms (true) or not (false). |
| OsOptionsHideInMacOS | boolean | Create, Filter, Update | Specifies whether to hide the menu item on macOS platforms (true) or not (false). |
| OsOptionsHideInOtherOS | boolean | Create, Filter, Update | Specifies whether to hide the menu item on any other platforms not mentioned here (true) or not (false). |
| OsOptionsHideInWindowsOS | boolean | Create, Filter, Update | Specifies whether to hide the menu item on Windows platforms (true) or not (false). |
| PhoneNumber | phone | Create, Filter, Group, Nillable, Sort, Update | The phone number of menu items with ChannelType value Phone. Otherwise, the value is null. |
| ShouldOpenUrlInSameTab | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Specifies whether a URL is opened in the same tab (true) or not (false). This field only applies for menu items with ChannelType value CustomURL. |

> 표기: PDF 추출 과정에서 위 객체의 REST Methods 줄(DELETE, GET, HEAD, PATCH, POST, Query)이 "Special Access Rules" 헤딩 아래로 잘못 붙어 추출되었다. 위 섹션은 원문 의미대로 교정됨 — REST Methods는 메서드 목록, Special Access Rules는 Experiences·Sites + Customize Application 권한 문단이다.

**Usage:** The EmbeddedServiceMenuItem object provides configuration information for a Channel Menu. A channel menu lists the ways in which customers can contact your business. A channel menu deployment is tied to a EmbeddedServiceMenuSettings record, which can have one or more EmbeddedServiceMenuItem objects associated with it.

---

## 4. 약속 관리 (Appointment Management / Field Service, beta)

> 웹에 임베드된 약속 예약/변경/취소(Appointment Management beta) 배포. Field Service 약속 플로우를 임베디드 위젯으로 노출한다.

### EmbeddedServiceFieldService

Represents a setup node for creating an embedded Appointment Management (beta) deployment.

- **Version:** Available in Tooling API version 43.0 and later.
- **Supported Calls:** create(), delete(), describeLayout(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** GET, POST, PATCH, DELETE
- **Special Access Rules:** 없음

| Field | Type | Properties | Description |
|---|---|---|---|
| AppointmentBookingFlowName | string | Filter, Group, Nillable, Sort | Name of the appointment booking flow for this Embedded Service deployment. |
| CancelApptBookingFlowName | string | Filter, Group, Nillable, Sort | Name of the appointment cancellation flow for this embedded Appointment Management (beta) deployment. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | Unique name for the embedded Appointment Management configuration setup node. *Note: Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field.* |
| EmbeddedServiceConfigId | EmbeddedServiceConfig | Create, Filter, Group, Sort, Update | Unique ID for the embedded Appointment Management (beta) deployment. |
| Enabled | boolean | Defaulted on create, Filter, Group, Sort | Specifies whether Field Service is enabled for this Embedded Service deployment (true) or not (false). |
| FieldServiceConfirmCardImg | string | Filter, Group, Nillable, Sort | URL of the image used for the confirmation card in embedded Appointment Management (beta). |
| FieldServiceHomeImg | string | Filter, Group, Nillable, Sort | URL of the image used for the home screen in embedded Appointment Management (beta). |
| FieldServiceLogoImg | string | Filter, Group, Nillable, Sort | URL of the logo used for the home screen in embedded Appointment Management (beta). |
| FullName | string | Create, Group, Nillable | The unique name used for this Embedded Service deployment. The fullName can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. (쿼리 제한: 공통 블록 D 참조) |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | Languages supported in the Embedded Service deployment. (값 목록: **공통 Language 블록 B형(18값)** 참조) |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged |
| MasterLabel | string | Create, Filter, Group, Sort, Update | Name of the Embedded Service deployment. |
| Metadata | mns:EmbeddedServiceFieldService | Create, Nillable, Update | The embedded Appointment Management (beta) metadata. (쿼리 제한: 공통 블록 D 참조) |
| ModifyApptBookingFlowName | string | Filter, Group, Nillable, Sort | Name of the appointment modification flow for this embedded Appointment Management (beta) deployment. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. (공통 boilerplate — 공통 블록 C 참조) |
| ShouldShowExistingAppointment | boolean | Defaulted on create, Filter, Group, Sort | Specifies whether to display a button on the home screen for customers to access their existing appointments (true) or not (false) for embedded Appointment Management (beta). |
| ShouldShowNewAppointment | boolean | Defaulted on create, Filter, Group, Sort | Specifies whether to display a button on the home screen for customers to create a new appointment (true) or not (false) for embedded Appointment Management (beta). |

---

## 5. Flow 임베딩

> Flow 기능을 Embedded Service 배포에 연결한다. EmbeddedServiceFlow는 어떤 FlowDefinition을 사용할지, EmbeddedServiceFlowConfig는 Flow 기능 활성화 여부를 제어한다. FlowDefinition 객체는 [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] 참조.

### EmbeddedServiceFlow

Represents a Flow Definition used by an Embedded Service deployment.

- **Version:** Available in API version 45.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** To access this type, you need the Customize Application user permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| EmbeddedServiceConfigId | reference | Create, Filter, Group, Sort | The unique ID of EmbeddedServiceConfig (the Embedded Service deployment). |
| Feature | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The Embedded Service feature that uses this flow. This is a read-only field. Possible values are: FieldService, Flows, LiveAgent |
| Flow | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The flow definition name. Use one of the listed standard flows or an ID of a FlowDefinition that you created. Possible standard flow values are: runtime_sales_see__SEE, setup_service_experience__Create_Case, setup_service_experience__Verify_Cust |
| FlowType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The flow type used in a Flow (FL), Appointment Booking (FS), or Chat (LA) feature of Embedded Service. Possible values are: FL_Flow, FS_CancelAppointment, FS_ModifyAppointment, FS_NewAppointment, LA_Survey |
| IsAuthenticationRequired | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Specifies whether authentication is required for this flow (true) or not (false). Authentication is required if the FlowType is an Appointment Booking type. Default is false. |

**Usage:** The EmbeddedServiceFlow specifies which FlowDefinitions are used by the Embedded Service features Appointment Booking, Chat, and Flow. A FlowDefinition executes a Flow object. A FlowDefinition can have more than one version of a Flow object but only the active one is executed. Only certain ProcessType values of the Flow object are supported depending on which FlowType you select in the EmbeddedServiceFlow object. • Appointment Booking features, where the FlowType starts with "FS", only support FieldServiceWeb and Appointments values for ProcessType. • Chat features, where the FlowType starts with "LA", only support the Flow value for ProcessType. • Flow features, where the FlowType starts with "FL", only support the Survey value for ProcessType.

### EmbeddedServiceFlowConfig

Represents whether an Embedded Service Flow feature is enabled or not.

- **Version:** Available in API version 45.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeLayout(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** To access this type, you need the Customize Application user permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| EmbeddedServiceConfigId | reference | Filter, Group, Sort | The unique ID of an EmbeddedServiceConfig (the Embedded Service deployment) that the flow config is associated with. |
| Enabled | boolean | Defaulted on create, Filter, Group, Sort | Specifies whether the embedded flow is enabled (true) or not (false). Defaults to false. |
| FullName | string | Create, Group, Nillable | The full name of the parent object EmbeddedServiceConfig in Metadata API. The full name can include a namespaceprefix. (쿼리 제한: 공통 블록 D 참조) |
| Metadata | EmbeddedServiceFlowConfig | Create, Nillable, Update | The embedded service flow config's metadata. (쿼리 제한: 공통 블록 D 참조) |

**Usage:** To get a Flow feature working, you need three things: an EmbeddedServiceConfig deployment, an EmbeddedServiceFlowConfig record, and an EmbeddedServiceFlow record with the type set to FL_Flow. The EmbeddedServiceFlowConfig record controls whether the Flow feature associated with this deployment is enabled or disabled.

---

## 6. 커스터마이즈 · 리소스

> Embedded Chat의 룩앤필을 커스텀 LWC/Aura 컴포넌트, 커스텀 라벨, 정적 리소스로 교체한다. CustomComponent(컴포넌트 매핑)·CustomLabel(라벨)·Customization(리소스 세트 매핑)·Resource(개별 정적 리소스)의 계층 관계로 동작한다.

### EmbeddedServiceCustomComponent

Represents a custom component created for an Embedded Service feature. The custom components can be an Aura or Lightning Web Component.

- **Version:** Available in API version 44.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** This type is available only if Salesforce Experiences and Salesforce Sites are enabled in your org. To access this type, you need the Customize Application user permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| CustomComponentId | reference | Create, Filter, Group, Sort, Update | The unique ID of the LightningComponentBundle or AuraDefinitionBundle component to be used in the Embedded Service. |
| CustomComponentType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The embedded component type associated with the chosen Feature that you want to customize. The possible values are: • LA_ChatHeader — Not supported for AuraDefinitionBundle components • LA_Minimized • LA_PlainTextChatMessage — Not supported for AuraDefinitionBundle components • LA_Prechat |
| EmbeddedServiceConfigId | reference | Create, Filter, Group, Sort | The unique ID of the EmbeddedServiceConfig object that this custom component is associated with. |
| Feature | picklist | Filter, Group, Nillable, Restricted picklist, Sort | The Embedded Service feature that uses the custom component. The possible values are: • Base • ChannelMenu • FieldService • Flows • LiveAgent • NotInUse |

**Usage:** Each Embedded Service feature has a defined set of components that can be customized. You can customize the feature using your own Lightning Web Components or Aura Components. Right now, you can only customize components of the Embedded Service Chat feature. For example, you can customize the prechat form, minimized state, chat bubble, and chat header of a Chat widget. To customize a component, link the Lightning Web Component or Aura Component to an Embedded Service Custom Component object. Then link an Embedded Service Configuration to this object. The Embedded Service Configuration represents the Chat widget that you want to customize.

### EmbeddedServiceCustomLabel

Represents a customized label that appears in the embedded component for a particular Embedded Service deployment. Labels can be customized for both Embedded Chat and embedded Appointment Management (beta).

- **Version:** Available in API version 44.0 and later.
- **Supported Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** DELETE, GET, POST, PUT, PATCH
- **Special Access Rules:** 없음

| Field | Type | Properties | Description |
|---|---|---|---|
| CustomLabel | CustomLabel | Filter, Group, Nillable, Sort | The developer name of the custom label that appears in the embedded component. |
| CustomLabelId | ID | Create, Filter, Group, Nillable, Sort, Update | The label record ID for the custom label. |
| EmbeddedServiceConfig | EmbeddedServiceConfig | Filter, Group, Nillable, Sort | The EmbeddedServiceConfig setup associated with the Embedded Service deployment. |
| EmbeddedServiceConfigId | ID | Create, Filter, Group, Nillable, Sort | Unique ID for the Embedded Service deployment. |
| LabelKey | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The type of label for this embedded component. The value corresponds to the label within a label group (substate of chat state or page type). |

### EmbeddedServiceCustomization

Represents a mapping between the EmbeddedServiceCustomization record parent and the EmbeddedServiceConfiguration or EmbeddedServiceMenuSettings, for a set of Embedded Service resources. Each resource is set of customizations applied via an uploaded static resource for your Embedded Chat.

- **Version:** Available in API version 52.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음

| Field | Type | Properties | Description |
|---|---|---|---|
| CustomizationName | string | Create, Filter, Group, Sort, Update | The name of the custom set of resources you create for your embedded component. |
| Description | textarea | Create, Filter, Nillable, Sort, Update | Used to describe a set of custom resources. |
| ParentId | reference | Create, Filter, Group, Sort | The ID of the EmbeddedServiceConfig or EmbeddedServiceMenuSettings parent record. This is a polymorphic relationship field. Relationship Name: Parent. Relationship Type: Lookup. Refers To: EmbeddedServiceConfig, EmbeddedServiceMenuSettings |

### EmbeddedServiceResource

Represents a mapping from an EmbeddedServiceCustomization record parent to a set of resources. Each resource is a set of customizations applied via an uploaded static resource for your Embedded Chat.

- **Version:** Available in API version 50.0 and later.
- **Supported SOAP API Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** 없음

| Field | Type | Properties | Description |
|---|---|---|---|
| ParentId | reference | Create, Filter, Group, Sort | The ID of the EmbeddedServiceCustomization parent record. This is a relationship field. Relationship Name: Parent. Relationship Type: Lookup. Refers To: EmbeddedServiceCustomization |
| ResourceId | reference | Create, Filter, Group, Sort, Update | The ID of an uploaded static resource. This is a relationship field. Relationship Name: Resource. Relationship Type: Lookup. Refers To: StaticResource |
| ResourceType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The resource type to be customized. Possible values are: • ChatInvitation • SettingsFile |

---

## 공통 블록 — 반복 필드·피클리스트

여러 객체에서 동일 verbatim으로 반복되는 boilerplate와 두 종류의 Language 피클리스트를 1회 정의한다. 각 객체 표는 이 블록을 참조하므로 값/규칙은 전수 보존된다.

### 공통 Language 블록 A형 (19값) — "embedded component / menu" 언어

적용 객체: **EmbeddedServiceBranding**, **EmbeddedServiceMenuSettings**

Possible values:
- ar — Arabic
- da — Danish
- de — German
- en_US — English
- es — Spanish
- fi — Finnish
- fr — French
- iw — Hebrew
- ja — Japanese
- ko — Korean
- nl_BE — Dutch (Belgium)
- no — Norwegian
- pt_BR — Portuguese (Brazil)
- ru — Russian
- sv — Swedish
- th — Thai
- ur — Urdu
- zh_CN — Chinese (Simplified)
- zh_TW — Chinese (Traditional)

### 공통 Language 블록 B형 (18값) — "deployment" 언어

적용 객체: **EmbeddedServiceConfig**, **EmbeddedServiceFieldService**, **EmbeddedServiceLiveAgent**

Languages supported in the Embedded Service deployment:
- zh_CN — Chinese (Simplified)
- zh_TW — Chinese (Traditional)
- da — Danish
- nl_NL — Dutch
- en_US — English
- fi — Finnish
- fr — French
- de — German
- it — Italian
- ja — Japanese
- ko — Korean
- no — Norwegian
- pt_BR — Portuguese (Brazil)
- ru — Russian
- es — Spanish
- es_MX — Spanish (Mexico) *(Spanish (Mexico) defaults to Spanish for customer-defined translations.)*
- sv — Swedish
- th — Thai *(The Salesforce user interface is fully translated to Thai, but Help is in English.)*

> A형과 B형의 차이: A형에만 `ar`(Arabic)·`iw`(Hebrew)·`nl_BE`(Dutch Belgium)·`ur`(Urdu)가 있고, B형에만 `it`(Italian)·`nl_NL`(Dutch)·`es_MX`(Spanish Mexico)가 있다. 두 목록을 합치지 않는다.

### 공통 블록 C — NamespacePrefix (boilerplate)

해당 객체: EmbeddedServiceConfig, EmbeddedServiceBranding, EmbeddedServiceLiveAgent(+ "Available in API version 43.0 and later."), EmbeddedServiceFieldService, EmbeddedServiceMenuSettings. 모든 객체에서 아래 동일 문구다.

> The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values. • In Developer Edition orgs, NamespacePrefix is set to the namespace prefix of the org for all objects that support it, unless an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition org of the package developer. • In orgs that are not Developer Edition orgs, NamespacePrefix is set only for objects that are part of an installed managed package. All other objects have no namespace prefix.

### 공통 블록 D — FullName / Metadata 쿼리 제한 (boilerplate)

FullName·Metadata 필드 설명 끝에 동일하게 붙는 문구다.

> Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance.

---

## 관련 노트
- [[Tooling API — 개요·REST·SOAP 호출 기초]] — Tooling API 호출 기초·허브
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 전체 객체 분류 카탈로그
- [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]] — QuickAction·MenuItem 등 UI 인접 객체
- [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] — EmbeddedServiceFlow가 참조하는 Flow 객체
- [[Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼]] — 임베디드 챗(Live Agent) 런타임 배포 API (Service 도메인)
