---
tags: [tooling-api, devops, lightning, aura, lwc, component-bundle]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-28
aliases: [AuraDefinition, AuraDefinitionBundle, LightningComponentBundle, LightningComponentResource, LightningOutApp, 라이트닝, 오라, Aura 번들, LWC 번들, 컴포넌트 번들, DefType, Lightning Out]
---

# Tooling API 객체 — Lightning (Aura·LWC 번들)

> Aura·LWC 컴포넌트 번들 Tooling sObject 5종 전수 — AuraDefinition(DefType 16)·AuraDefinitionBundle·LightningComponentBundle·LightningComponentResource·LightningOutApp. 개별 번들 멤버 소스(markup·controller·helper·style·css·html·js·svg·xml…)와 컨테이너 번들을 SOQL로 조회하고 MetadataContainer 계열 흐름으로 배포한다.

이 노트는 Tooling API Reference & Developer Guide v67.0(Summer '26)의 "Tooling API Objects" 챕터 중 **Aura·LWC 컴포넌트 번들 도메인 sObject 군**을 다룬다. `AuraDefinition`은 번들 구성원(컴포넌트 마크업·클라이언트측 컨트롤러·헬퍼·스타일·SVG 등) 개별 소스를 담고, `AuraDefinitionBundle`은 그 컨테이너다. LWC 쪽은 `LightningComponentBundle`(컨테이너)·`LightningComponentResource`(개별 리소스 — HTML·JS·CSS·SVG·XML config)가 대응 짝을 이루며, `LightningOutApp`은 Lightning Out 2.0 앱을 참조한다. 전부 `query()`로 SOQL 조회가 가능하고, 번들·정의는 `create()`/`update()`/`upsert()`로 배포·구성할 수 있다.

> [!warning] Tooling Ch4에 없는 Lightning 객체 (fabricate 금지 — 실제 coverage 신호)
> 아래 객체들은 Aura/LWC 번들 도메인에서 흔히 기대되지만 **Tooling API Ch4(Tooling API Objects)에는 존재하지 않는다.** 누락이 아니라 실제 coverage gap 신호이므로 "Tooling API로 다룰 수 있다"고 쓰면 안 된다.
> - **AuraDefinitionBundleInfo**
> - **AuraDefinitionBundleMember / AuraDefinitionMember**
> - **LightningComponentBundleMember**
> - **Aura/LWC용 deploy-`*Member` 객체는 존재하지 않는다.** Tooling API의 `*Member` 로스터는 **ApexClassMember · ApexComponentMember · ApexPageMember · ApexTriggerMember + CustomFieldMember + DelegateGroupMember + PlatformEventChannelMember + SourceMember** 뿐이다. Aura/LWC는 파일 단위 Member 추적 객체가 없다.

> [!important] 두 개의 서로 다른 `Format` enum (혼동 금지)
> 이 노트에는 이름이 같은 `Format` 픽리스트가 **두 개** 나오는데 값이 완전히 다르다. 합치거나 한쪽 값으로 다른 쪽을 채우지 말 것.
> - **AuraDefinition.Format** = 5개, **대문자**: `XML`, `JS`, `CSS`, `TEMPLATE_CSS`, `SVG`
> - **LightningComponentResource.Format** = 6개, **소문자**: `css`, `html`, `js`, `json`, `svg`, `xml`

> [!note] DefType·ApexComponent 경계
> - **AuraDefinition.DefType** 는 예약·폐기(deprecated) 값을 포함해 **16개**다(`PROVIDER` reserved, `MODEL` deprecated, `TESTSUITE` reserved, `MODULE` reserved). 이들도 enum의 일부이므로 전수 전사한다.
> - **ApexComponent** 는 Visualforce 컴포넌트이지 Aura가 아니다. 이름이 비슷해 혼동되지만 Aura 번들과 무관하며 → [[Tooling API 객체 — Apex 코드·테스트·커버리지]] 소관이다.

> 표기 규약: 필드표는 PDF `-layout` 추출본의 충실 transcription이며, 원문 오타/quirk는 `[sic]`로 보존한다. AuraDefinition.DefType(16값)은 물리 페이지 166→167 경계로 절단되었던 것을 pdftoppm @150dpi PNG로 교차검증해 stitch했고, LightningOutApp.MasterLabel은 물리 580→581 경계 stitch분을 포함했다(AP-09).

---

## 객체 빠른 색인

| 객체 | 분류 | 필드 수 | API 최소 버전 |
|---|---|---|---|
| [AuraDefinition](#auradefinition) | Aura 번들 | 5 | 32.0 |
| [AuraDefinitionBundle](#auradefinitionbundle) | Aura 번들 | 9 | 32.0 |
| [LightningComponentBundle](#lightningcomponentbundle) | LWC 번들 | 12 | 45.0 |
| [LightningComponentResource](#lightningcomponentresource) | LWC 번들 | 5 | 45.0 |
| [LightningOutApp](#lightningoutapp) | Lightning Out | 5 | 65.0 |

> 필드 수 합계 = **36** (5 + 9 + 12 + 5 + 5). PDF의 이 5개 객체 섹션에는 코드/SOQL 예제가 없다(필드표 + Usage 산문 링크만 존재). 아래 SOQL 블록은 위키 구조 규칙(코드 블록 ≥1)을 위해 작성한 구조 예시이며, PDF 원문에서 발췌한 것이 아니다.

```sql
// 구조 예시 — 실제 동작 코드 아님 (PDF 5개 섹션에 코드 예제 없음)
-- Aura 번들에 속한 정의를 타입·포맷별로 조회
SELECT Id, DefType, Format, Source
FROM AuraDefinition
WHERE AuraDefinitionBundleId = '<AuraDefinitionBundleId>'

-- LWC 번들의 개별 리소스 조회 (Format 은 소문자 enum)
SELECT Id, FilePath, Format, Source
FROM LightningComponentResource
WHERE LightningComponentBundleId = '<LightningComponentBundleId>'
```

---

### AuraDefinition

Represents an Aura component definition, such as component markup, a client-side controller, or an event. Available in API version 32.0 and later.

> Aura 컴포넌트 번들의 구조(마크업·컨트롤러·헬퍼·렌더러·스타일·SVG 등)는 [[Aura 컴포넌트 구조]] 참조. 이 객체는 그 번들의 **개별 구성원 소스**를 담는다.

- **Version:** API version 32.0 and later.
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH, DELETE
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| AuraDefinitionBundleId | reference | Create, Filter, Group, Sort | The ID of the bundle containing the definition. A bundle contains a Lightning definition and all its related resources. |
| DefType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The definition type. Valid values are listed in the DefType enum below (16 values). |
| Format | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The format of the definition. Valid values are listed in the Format enum below (5 values). |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. This field is available in API version 38.0 and later. |
| Source | textarea | Create, Update | The contents of the definition. This is all the markup or code for the definition. |

#### AuraDefinition `DefType` enum — FULL (16 values, verbatim; 물리 p.166→167 경계 stitch, PNG 교차검증)

예약(reserved)·폐기(deprecated) 값도 enum의 일부이므로 전수 전사한다.

- **APPLICATION** — Lightning Aura Components app
- **CONTROLLER** — client-side controller
- **COMPONENT** — component markup
- **EVENT** — event definition
- **HELPER** — client-side helper
- **INTERFACE** — interface definition
- **RENDERER** — client-side renderer
- **STYLE** — style (CSS) resource
- **PROVIDER** — reserved for future use
- **MODEL** — deprecated, do not use
- **TESTSUITE** — reserved for future use
- **DOCUMENTATION** — documentation markup
- **TOKENS** — tokens collection
- **DESIGN** — design definition
- **SVG** — SVG graphic resource
- **MODULE** — reserved for future use

#### AuraDefinition `Format` enum — FULL (5 values, verbatim; 대문자 — LightningComponentResource.Format 과 혼동 금지)

- **XML** — for component markup
- **JS** — for JavaScript code
- **CSS** — for styles
- **TEMPLATE_CSS** — reserved for future use
- **SVG** — for an SVG graphic

**Usage:** For more information, see the Lightning Aura Components Developer Guide.

---

### AuraDefinitionBundle

Represents a Lightning Aura component definition bundle, such as a component or application bundle. A bundle contains a Lightning Aura component definition and all its related resources. Available in API version 32.0 and later.

> 이 객체는 컨테이너이고, 그 안의 개별 정의 소스는 [AuraDefinition](#auradefinition) 이 담는다. Aura 번들의 전체 구조는 [[Aura 컴포넌트 구조]] 참조.

- **Version:** API version 32.0 and later.
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH, DELETE
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiVersion | double | Filter, Sort | The API version for this bundle. Every bundle has an API version specified at creation. |
| Description | textarea | Filter, Group, Sort | The text description of the bundle. Maximum size of 255 characters. |
| DeveloperName | string | Filter, Group, Sort | The unique name of the record in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated but you can supply your own value if you create the record using the API. **Note:** When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance slows down while Salesforce generates one for each record. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| FullName | string | Create, Group, Nillable | The unique name used as the AuraDefinitionBundle identifier for API access. The fullName can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the MasterLabel. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. This field is available in API version 38.0 and later. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | Master label for the Lightning bundle. This internal label doesn't get translated. |
| Metadata | mns:AuraDefinitionBundle | Create, Nillable, Update | The AuraDefinitionBundle metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the values described in the NamespacePrefix value list below. |

#### AuraDefinitionBundle `NamespacePrefix` 값 설명 (verbatim, 물리 p.170 연속분 포함)

- In Developer Edition orgs, NamespacePrefix is set to the namespace prefix of the org for all objects that support it, unless an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition org of the package developer.
- In orgs that are not Developer Edition orgs, NamespacePrefix is set only for objects that are part of an installed managed package. All other objects have no namespace prefix.

**Usage:** For more information, see the Lightning Aura Components Developer Guide.

---

### LightningComponentBundle

Represents a Lightning web component bundle. A bundle contains a Lightning web component and its related resources. Available in API version 45.0 and later.

> LWC 번들 구조와 오픈소스 런타임 관점은 [[LWC 오픈소스 아키텍처]] 참조. Aura 번들과의 차이는 [[Aura vs LWC]] 참조.

- **Version:** API version 45.0 and later.
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH, DELETE
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiVersion | double | Filter, Nillable, Sort | The API version for this bundle. Every bundle has an API version specified at creation. |
| Description | textarea | Filter, Group, Nillable, Sort | The text description of the bundle. Maximum size of 255 characters. |
| DeveloperName | string | Filter, Group, Sort | The unique name of the record in the API. This name can contain only underscores and alphanumeric characters, and must be unique in your org. It must begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. This field is automatically generated but you can supply your own value if you create the record using the API. **Note:** When creating large sets of data, always specify a unique DeveloperName for each record. If no DeveloperName is specified, performance slows down while Salesforce generates one for each record. **Note:** Only users with View DeveloperName OR View Setup and Configuration permission can view, group, sort, and filter this field. |
| FullName | string | Create, Group, Nillable | The unique name used as the LightningComponentBundle identifier for API access. The fullName can contain only underscores and alphanumeric characters. It must be unique, begin with a letter, not include spaces, not end with an underscore, and not contain two consecutive underscores. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| IsExplicitImport | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether imports between files are done explicitly by the developer (true) or implicitly by the framework (false). |
| IsExposed | boolean | Defaulted on create, Filter, Group, Sort | If true, the component is available to other namespaces, including namespaces outside of a managed package. If true and TargetConfigs is present, the component is also available to Salesforce builders such as Lightning App Builder and Experience Builder. If false, the component isn't available to builders and other namespaces. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the MasterLabel. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. *(이 객체의 ManageableState 설명에는 다른 객체와 달리 "available in API version 38.0 and later" 문장이 PDF에 없다 — verbatim)* |
| MasterLabel | string | Filter, Group, Sort | Master label for the Lightning bundle. This internal label doesn't get translated. |
| Metadata | mns:LightningComponentBundle | Create, Nillable, Update | The LightningComponentBundle metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix that is associated with this object. Each Developer Edition org that creates a managed package has a unique namespace prefix. Limit: 15 characters. You can refer to a component in a managed package by using the namespacePrefix__componentName notation. The namespace prefix can have one of the following values: • In Developer Edition orgs, NamespacePrefix is set to the namespace prefix of the org for all objects that support it, unless an object is in an installed managed package. In that case, the object has the namespace prefix of the installed managed package. This field's value is the namespace prefix of the Developer Edition org of the package developer. • In orgs that are not Developer Edition orgs, NamespacePrefix is set only for objects that are part of an installed managed package. All other objects have no namespace prefix. |
| TargetConfigs | textarea | Nillable | Configurations for each target. Each target is a Lightning page type that can be configured in Lightning App Builder. |

**Usage:** For more information about Lightning web components, see Lightning Web Components Developer Guide.

---

### LightningComponentResource

Represents a Lightning web component resource, such as HTML markup, JavaScript code, a CSS file, an SVG resource, or an XML configuration file. Available in API version 45.0 and later.

> 이 객체는 LWC 번들의 **개별 리소스 파일**을 담고, 컨테이너는 [LightningComponentBundle](#lightningcomponentbundle) 이다. LWC 번들 구조는 [[LWC 오픈소스 아키텍처]] 참조.

- **Version:** API version 45.0 and later.
- **Supported SOAP Calls:** create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH, DELETE
- **Special Access Rules:** As of Summer '20 and later, only your Salesforce org's internal users can access this object.

| Field | Type | Properties | Description |
|---|---|---|---|
| FilePath | string | Create, Filter, Group, Sort, Update | The path to the resource. |
| Format | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The format of the resource. The possible values are listed in the Format enum below (6 values). |
| LightningComponentBundleId | reference | Create, Filter, Group, Sort | The ID of the bundle containing the resource. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: beta, deleted, deprecated, deprecatedEditable, installed, installedEditable, released, unmanaged. This field is available in API version 38.0 and later. |
| Source | textarea | Create, Update | The contents of the definition. This is all the markup or code for the definition. |

#### LightningComponentResource `Format` enum — FULL (6 values, verbatim; **소문자** — AuraDefinition.Format 과 별개)

- **css**
- **html**
- **js**
- **json**
- **svg**
- **xml**

**Usage:** For more information about Lightning web components, see Lightning Web Components Developer Guide.

---

### LightningOutApp

Represents a Lightning Out 2.0 application. With a Lightning Out 2.0 app, you can embed Lightning web components (LWC) into external applications. This object is available in API version 65.0 and later.

> **Important:** Where possible, we changed noninclusive terms to align with our company value of Equality. We maintained certain terms to avoid any effect on customer implementations.

- **Version:** API version 65.0 and later.
- **Supported SOAP Calls:** create(), delete(), describeLayout(), describeSObjects(), query(), retrieve(), update(), upsert()
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** none stated.

| Field | Type | Properties | Description |
|---|---|---|---|
| ApplicationName | string | Create, Filter, Group, Sort, Update | The name of the Lightning Out 2.0 app. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | The unique API name of the Lightning Out 2.0 app. |
| IsEnabled | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether the Lightning Out 2.0 app is enabled (true) or disabled (false). The default value is false. If the app is disabled, then user authentication fails and the embedded components don't load in the external app. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | The language of the LightningOutApp. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | A user-friendly name for the LightningOutApp, which is defined when the LightningOutApp is created. *(AP-09: 이 필드의 Properties/Description은 물리 p.580에서 절단되어 p.581에서 stitch함)* |

**Usage:** See Extend Salesforce to External Apps with Lightning Out 2.0 in Salesforce Help and Use Components Outside Salesforce with Lightning Out 2.0 in the Lightning Web Components Developer Guide.

---

## 관련 노트

**Tooling API 형제 노트**
- [[Tooling API — 개요·REST·SOAP 호출 기초]]
- [[Tooling API — Objects and Namespaces (객체 분류)]]
- [[Tooling API — SOAP·REST 헤더]]
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — ApexComponent(Visualforce)·ApexComponentMember 등 `*Member` 로스터 소관
- [[Tooling API 객체 — Entity·Field·스키마]]
- [[Tooling API 객체 — 보안·권한]]
- [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]]
- [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]]
- [[Tooling API 객체 — 운영·라이프사이클 (Sandbox·배포·릴리즈)]] — org 운영·라이프사이클 sObject 18종(Sandbox·DeployRequest·ReleaseUpdate·SourceMember·My Domain 등)
- [[Tooling API 객체 — 패키징·브랜딩 (1GP·2GP·정적콘텐츠)]] — 패키징·브랜딩·정적콘텐츠 sObject 20종(MetadataPackage·Package2·SubscriberPackage·BrandingSet·StaticResource 등)
- [[Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널)]] — User·플랫폼이벤트·CDC 채널·이벤트 릴레이 sObject 7종

**Lightning 도메인**
- [[Aura 컴포넌트 구조]] — AuraDefinition·AuraDefinitionBundle 의 번들 구성
- [[LWC 오픈소스 아키텍처]] — LightningComponentBundle·LightningComponentResource 의 LWC 런타임
- [[Aura vs LWC]] — Aura 번들 ↔ LWC 번들의 차이
