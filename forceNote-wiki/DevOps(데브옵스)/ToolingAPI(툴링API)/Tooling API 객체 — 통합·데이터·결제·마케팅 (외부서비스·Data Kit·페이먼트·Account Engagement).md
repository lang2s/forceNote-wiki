---
tags: [tooling-api, integration, data-360, data-kit, payment, account-engagement, marketing, sobject-reference, devops]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-30
aliases: [ActivationPlatform, CustomNotificationType, DataAssessmentConfigItem, DataIntegrationRecordPurchasePermission, DataSourceBundleDefinition, DataStreamTemplate, ExternalServiceRegistration, ExternalDataTransportFieldTemplate, ExternalDataTransportObjectTemplate, ExternalStringLocalization, GtwyProvPaymentMethodType, MarketingAppExtension, MarketingAppExtAssignment, MarketingAppExtActivity, MarketingAppExtAction, PardotTenant, PaymentGatewayProvider, Publisher, RecentlyViewed, RegisteredExternalService, RelatedListDefinition, StandardAction, QueryResult, QueryLocator, SOQLResult, CompactLayoutItemInfo, 외부서비스 등록, Data Kit, 데이터스트림, 결제 게이트웨이, Account Engagement, Pardot 비즈니스유닛, 마케팅앱확장, 최근 조회 항목, 쿼리 결과 타입, Tooling API에서 외부 서비스 등록 객체, Data 360 데이터 키트 객체, 결제 게이트웨이 프로바이더 객체, Account Engagement 마케팅 확장 객체, RecentlyViewed Tooling 쿼리]
---

# Tooling API 객체 — 통합·데이터·결제·마케팅 (외부서비스·Data Kit·페이먼트·Account Engagement)

> Tooling API의 통합·외부서비스, Data 360/Data Kit, 결제(Commerce Payments), 마케팅(Account Engagement), 스키마·UI·Misc 22개 sObject와 복합·결과 타입 3종(QueryResult·SOQLResult·CompactLayoutItemInfo)의 필드·SOAP/REST 호출·enum 전수 레퍼런스.

---

## 공통 enum 블록

이 노트의 다수 객체가 동일하게 공유하는 두 enum을 여기 한 곳에만 정의한다. 각 객체 본문에서는 "→ 공통 enum 블록 참조"로 가리킨다.

### ManageableState (8값 — 공통)

`ManageableState enumerated list` 타입. Properties는 대부분의 객체에서 `Filter, Group, Nillable, Restricted picklist, Sort`. AppExchange 패키지 컨텍스트에서 엔티티 상태를 나타낸다.

| 값 | 의미 |
|---|---|
| `beta` | Managed-Beta |
| `deleted` | Managed-Proposed-Deleted |
| `deprecated` | Managed-Proposed-Deprecated |
| `deprecatedEditable` | SecondGen-Installed-Deprecated |
| `installed` | Managed-Installed |
| `installedEditable` | SecondGen-Installed-Editable |
| `released` | Managed-Released |
| `unmanaged` | Unmanaged |

### Marketing 공통 Language (18값)

`MarketingAppExtension` · `MarketingAppExtActivity` · `PaymentGatewayProvider` · `RegisteredExternalService` · `ExternalServiceRegistration`(+부기 2건, 해당 섹션 참조)가 공유하는 Language picklist.

| 코드 | 언어 | 코드 | 언어 |
|---|---|---|---|
| `da` | Danish | `ko` | Korean |
| `de` | German | `nl_NL` | Dutch |
| `en_US` | English | `no` | Norwegian |
| `es` | Spanish | `pt_BR` | Portuguese (Brazil) |
| `es_MX` | Spanish (Mexico) | `ru` | Russian |
| `fi` | Finnish | `sv` | Swedish |
| `fr` | French | `th` | Thai |
| `it` | Italian | `zh_CN` | Chinese (Simplified) |
| `ja` | Japanese | `zh_TW` | Chinese (Traditional) |

> ⚠️ `DataSourceBundleDefinition`(~170값)·`DataStreamTemplate`(~215값)의 Language picklist는 값 집합이 위 18값과 **다르고 서로도 다르다**(국가 변종 포함). 따라서 공통 블록으로 묶지 않고 각 객체 섹션에 collapsible로 각각 전수한다.

대표 쿼리 구조는 다음과 같다(전 sObject 공통 패턴).

```sql
-- 구조 예시 — 실제 동작 코드 아님
-- Tooling API REST: GET /services/data/v67.0/tooling/query?q=<SOQL>
SELECT Id, DeveloperName, MasterLabel, ManageableState, NamespacePrefix
FROM ExternalServiceRegistration
ORDER BY DeveloperName
```

---

## ① 통합·외부서비스

### ExternalServiceRegistration (22 fields) [BOUNDARY]

**설명:** Represents the external service configuration for an org. **API version 39.0 and later.**
**Supported SOAP Calls:** `create()`, `delete()`, `query()`, `retrieve()`, `update()`, `upsert()`
**REST HTTP Methods:** GET, PUT, POST, DELETE
**Special Access Rules:** 없음

> 이 객체의 런타임/기능 facet은 [[External Services]](통합 본체)·[[ExternalService Namespace]](Apex 네임스페이스) 참조.

| Field | Type | Properties | Description / 값 |
|---|---|---|---|
| Description | string | Create, Filter, Group, Nillable, Sort, Update | external service 설명. |
| DeveloperName | string | Create, Filter, Group, Sort | external data source의 internal name(API명 규칙). |
| Language | string | Create, DefaultedOnCreate, Filter, Group, Nillable, RestrictedPicklist, Sort, Update | external service config 언어. → 공통 Marketing Language 18값 참조. **부기:** `es_MX`=고객정의 번역이 없으면 Spanish로 fallback · `th`=UI는 Thai 완전번역, Help은 영어. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | Label for the external service. |
| NamedCredential | string | Filter, Group, Nillable, Sort | service에 쓸 named credential의 name reference. |
| NamedCredentialReferenceId | reference | Filter, Group, Nillable, Sort | named credential name reference. References NamedCredential. API 52.0+. (rel Name=NamedCredentialReference, Type=Lookup, Refers To NamedCredential) |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | external service가 속한 package의 namespace. |
| ProviderAssetEndpoint | string | Filter, Group, Nillable, Sort | 외부 사이트의 최신 schema/metadata 위치 또는 ID. 현재 MuleSoft asset에만 적용. API 57.0+. |
| RegistrationProvider | string | Filter, Group, Nillable, Sort | registration provider 참조. `registrationProviderType=ExternalConnector`면 external connector name, `=Heroku`면 HerokuAppLink ID, 그 외엔 blank(reserved for future use). |
| RegistrationProviderAsset | string | Filter, Group, Nillable, Sort | external service registration 관련 asset명(polymorphic FK). named query면 named query API명, REST/aura-enabled Apex class면 Apex class명. API 66.0+. |
| RegistrationProviderType | string | Filter, Group, Nillable, Restricted picklist, Sort | schema provider 유형(API 56.0+). 값은 아래 RegistrationProviderType(17) 목록. |
| Schema | textarea | Create, Nillable, Update | OpenAPI 2.0 또는 3.0 schema 내용(JSON/YAML). |
| SchemaAbsoluteUrl | url | Create, Filter, Nillable, Sort, Update | schema의 full absolute URL. API 56.0+, registration시 Absolute URL 선택시 채워짐. |
| SchemaType | picklist | Create, Filter, Group, Nillable, RestrictedPicklist, Sort, Update | schema의 ID format. **API 48.0+ 유효값=`OpenApi`. API 47.0 이하=`InteragentHyperSchema`, `OpenApi`.** |
| SchemaUploadFileExtension | string | Create, Filter, Group, Nillable, Sort, Update | 파일 확장자. API 56.0+, Upload from local 선택시 채워짐. |
| SchemaUploadFileName | string | Create, Filter, Group, Nillable, Sort, Update | 확장자 제외 파일명. API 56.0+, Upload from local 선택시 채워짐. |
| SchemaUrl | url | Create, Filter, Group, Nillable, Sort, Update | service 등록시 정의한 schema URL. "/"로 시작하는 relative path. |
| ServiceBinding | string | Nillable | 비지원 media type을 지원 media type으로 매핑. API 53.0+. |
| ServiceName | string | Filter, Group, Nillable, Sort | external service registration이 속한 cataloged API service명. **API 63.0에서 추가 → API 65.0에서 제거됨.** |
| Status | picklist | Filter, Group, Nillable, RestrictedPicklist, Sort | service registration 완료 여부. 값: `complete`, `incomplete`. |
| SystemVersion | integer | Create, Filter, Group, Nillable, Sort, Update | external service registration revision 식별. 유효값은 Metadata API Developer Guide의 ExternalServiceRegistration 참조. |

**RegistrationProviderType picklist 전체 17값:**
`AgentActionOutputs`, `AgentToAgent`, `Anypoint`, `AnypointPublic`, `ApexRest`, `AuraEnabled`, `CodeExtension`, `ContextDef`, `Custom`, `CustomExternalConnector`, `DocumentProcessing`, `ExternalConnector`, `Heroku`, `MuleSoft`, `NamedQuery`, `SchemaInferred`, `Standard`

---

### RegisteredExternalService (15 fields)

**설명:** Represents a registered external service used to provide an extension or integration. **API version 49.0 and later.**
**Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
**Special Access Rules:** B2B Commerce 또는 D2C Commerce 라이선스가 활성화된 경우에만 사용 가능.

| Field | Type | Properties | Description / 값 |
|---|---|---|---|
| ConfigUrl | url | Filter, Nillable, Sort | integration 설정 페이지 링크. |
| Description | string | Filter, Group, Nillable, Sort | external service provider 설명. API 59.0+. |
| DeveloperName | string | Filter, Group, Sort | API name(규칙). Note: View DeveloperName 또는 View Setup and Configuration 권한 사용자만 view/group/sort/filter 가능. |
| DocumentationUrl | url | Filter, Nillable, Sort | registered external service 문서 링크. |
| ExtensionPointName | picklist | Filter, Group, Nillable, Restricted picklist, Sort | API 55.0+. extension point명. 값은 아래 ExtensionPointName(22) 목록. |
| ExternalServiceProviderId | reference | Filter, Group, Sort | Required. provider 기능 Apex class의 ID. interface 구현(`sfdc_checkout.CartInventoryValidation` / `CartPriceCalculations` / `CartShippingCharges` / `CartTaxCalculations`) 또는 extension base class 확장. (rel Name=ExternalServiceProvider, Type=Lookup, Refers To ApexClass) |
| ExternalServiceProviderType | picklist | Filter, Group, Restricted picklist, Sort | external service provider 유형. extension은 `Extension`+extensionPointName, integration은 다른 값(예: `Price`)+extensionPointName 생략. 값: `Extension`(API 55.0+), `Inventory`, `Price`, `Promotions`(API 53.0+), `Shipment`, `Tax`. |
| FullName | string | Create, Group, Nillable | Metadata API상 RegisteredExternalService 풀네임. |
| IconUri | url | Filter, Nillable, Sort | extension provider icon URI. API 59.0+. |
| IsApplication | boolean | Defaulted on create, Filter, Group, Sort | extension provider가 managed package 내인지. default false. API 59.0+. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | → 공통 Marketing Language 18값 참조. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| MasterLabel | string | Filter, Group, Sort | Label. |
| Metadata | flexipage metadata (Metadata API `meta_flexipage` 참조) | Create, Nillable, Update | RegisteredExternalService의 metadata. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | namespace prefix. Limit 15자. |

**ExtensionPointName picklist 전체 22값:**
`Commerce_Domain_Cart_Calculate`, `Commerce_Domain_Checkout_CreateOrder`, `Commerce_Domain_Inventory_CartCalculator`, `Commerce_Domain_Inventory_Service`, `Commerce_Domain_OrderManagement_Product`, `Commerce_Domain_Pricing_CartCalculator`, `Commerce_Domain_Pricing_Service`, `Commerce_Domain_Promotions_CartCalculator`, `Commerce_Domain_Promotions_ShippingCalculator`, `Commerce_Domain_Shipping_CartCalculator`, `Commerce_Domain_Shipping_SplitShipment`, `Commerce_Domain_Tax_CartCalculator`, `Commerce_Domain_Tax_Service`, `Commerce_Endpoint_Account_Address`, `Commerce_Endpoint_Account_Addresses`, `Commerce_Endpoint_Cart_Item`, `Commerce_Endpoint_Cart_ItemCollection`, `Commerce_Endpoint_Catalog_Product`, `Commerce_Endpoint_Catalog_Products`, `Commerce_Endpoint_Search_ProductSearch`, `Commerce_Endpoint_Search_Products`, `Commerce_Endpoint_Search_ProductsByCategory`

---

### ExternalStringLocalization (5 fields)

**설명:** Represents the translation of custom labels for a UI component represented by the ExternalString object. **API version 49.0 and later.**
**Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**REST HTTP Methods:** DELETE, GET, PATCH, POST
**Special Access Rules:**
- Professional, Enterprise, Performance, Unlimited, 또는 Developer edition이어야 함.
- org에서 Translation Workbench와 data translation이 활성화돼 있어야 함.
- 이 객체를 보려면 "View Setup and Configuration" 권한이 필요함.

**Limitations:** SOSL Limitations (PDF p.40).

| Field | Type | Properties | Description |
|---|---|---|---|
| ExternalStringId | reference | Create, Filter, Group, Sort | 번역 대상 custom label과 연관된 ExternalString의 ID. |
| Language | picklist | Create, Filter, Group, Restricted picklist, Sort | 번역 텍스트의 언어. **Note: 기존 ExternalString의 language는 변경할 수 없다.** |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | custom label이 속한 package의 namespace. |
| Value | string | Create, Filter, Sort, Update | 번역된 string값. 32,000자 또는 96,000 byte 제한(번역 길이까지). |

---

### ExternalDataTransportFieldTemplate (STUB)

Reserved for internal use. (필드·Supported Calls 등 섹션이 PDF에 없음 — 누락 아님.)

### ExternalDataTransportObjectTemplate (STUB)

Reserved for internal use. (필드·Supported Calls 등 섹션이 PDF에 없음 — 누락 아님.)

---

## ② 데이터 (Data 360 / Data Kit)

### DataStreamTemplate (20 fields)

**설명:** Represents metadata about the data stream that a user adds to a data kit. **API version 52.0 and later.**
**Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
**Special Access Rules:** Data 360 권한 필요.

| Field | Type | Properties | Description / 값 |
|---|---|---|---|
| DataSourceBundleDefinitionId | reference | Filter, Group, Sort | data stream template이 속한 stream bundle의 DataSourceBundleDefinition ID. (rel Name=DataSourceBundleDefinition, Type=Look up) |
| DataSourceObjectId | reference | Filter, Group, Sort | 데이터 소스 객체 DataSourceObject ID. (rel Name=DataSourceObject, Type=Look up) |
| DeveloperName | string | Filter, Group, Sort | unique name. FullName과 동일값. |
| FilterCriteria | textarea | Nillable | Data 360 전송 전 data stream에 적용되는 filter. |
| FullName | string | Create, Group, Nillable | Metadata API상 metadata object 풀네임. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | Languages supported in the deployment. (거대 picklist — 아래 collapsible 전수) |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| MasterLabel | string | Filter, Group, Sort | name of the bundle. |
| Metadata | complexvalue | Create, Nillable, Update | additional info for the data stream template. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | namespace prefix. |
| RefreshDayOfMonth | int | Filter, Group, Nillable, Sort | refresh되어야 하는 day of month. |
| RefreshDayOfWeek | int | Filter, Group, Nillable, Sort | refresh되어야 하는 day of week. |
| RefreshFrequency | picklist | Filter, Group, Nillable, Restricted picklist, Sort | refresh 빈도. 값은 아래 RefreshFrequency(13) 목록. |
| RefreshHours | multipicklist | Filter, Nillable | refresh 시각. 값: `0`–`23`(24값). 아래 RefreshHours 목록 참조. |
| RefreshMode | picklist | Filter, Group, Nillable, Restricted picklist, Sort | refresh 모드. 값은 아래 RefreshMode(7) 목록. |
| RefreshStartDate | date | Filter, Group, Nillable, Sort | refresh frequency 기준 데이터 조회 시작일. API 62.0+. |
| SourceObjectName | string | Filter, Group, Nillable, Sort | 데이터 스트리밍 원천 객체명. API 62.0+. |
| StreamType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | data stream 유형. API 62.0+. 값은 아래 StreamType(3) 목록. |
| StreamingAppDataConnectorType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | data streaming용 connector app. API 63.0+. 값은 아래 StreamingAppDataConnectorType(2) 목록. |
| TemplateVersion | int | Defaulted on create, Filter, Group, Nillable, Sort | template 버전번호. API 62.0+. |

**RefreshFrequency picklist 전체 13값:**
`BATCH`—Batch, `DAILY`—Daily, `EVERY_12_HOURS`—Every 12 Hours, `EVERY_4_HOURS`—Every 4 Hours, `HOURLY`—Hourly, `MINUTES_15`—15 Minutes, `MINUTES_30`—30 Minutes, `MINUTES_5`—5 Minutes, `MONTHLY`—Monthly, `NONE`—None, `NOT_APPLICABLE`—Not Applicable, `STREAMING`—Streaming, `WEEKLY`—Weekly

**RefreshMode picklist 전체 7값:**
`FULL_REFRESH`—Full Refresh, `INCREMENTAL`—Incremental, `NEAR_REAL_TIME_INCREMENTAL`—Near Real-time Incremental, `NOT_APPLICABLE`—Not Applicable, `PARTIAL_UPDATE`—Partial Update, `REPLACE`—Replace By Date, `UPSERT`—Upsert

**StreamType picklist 전체 3값:**
`DIRECT_ACCESS`—Direct Access, `DIRECT_ACCESS_ACCELERATED`—Direct Access (Accelerated), `INGEST`—Ingest

**StreamingAppDataConnectorType picklist 전체 2값:**
`MobileApp`—Mobile App, `WebApp`—Web App

**RefreshHours multipicklist 전체 24값(정규화 표기):**
`0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `10`, `11`, `12`, `13`, `14`, `15`, `16`, `17`, `18`, `19`, `20`, `21`, `22`, `23`
> PDF 원문 정렬(문자열 정렬): `0, 1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 2, 20, 21, 22, 23, 3, 4, 5, 6, 7, 8, 9`.

<details><summary>DataStreamTemplate Language picklist 전체값 (~215개 — 전수, DataSourceBundleDefinition 목록과 별도)</summary>

af—Afrikaans, am—Amharic, ar—Arabic, ar_AE—Arabic (United Arab Emirates), ar_BH—Arabic (Bahrain), ar_DZ—Arabic (Algeria), ar_EG—Arabic (Egypt), ar_IQ—Arabic (Iraq), ar_JO—Arabic (Jordan), ar_KW—Arabic (Kuwait), ar_LB—Arabic (Lebanon), ar_LY—Arabic (Libya), ar_MA—Arabic (Morocco), ar_OM—Arabic (Oman), ar_QA—Arabic (Qatar), ar_SA—Arabic (Saudi Arabia), ar_SD—Arabic (Sudan), ar_SY—Arabic (Syria), ar_TN—Arabic (Tunisia), ar_YE—Arabic (Yemen), bg—Bulgarian, bn—Bengali, bs—Bosnian, ca—Catalan, cac—Chuj, cak—Kaqchikel, cs—Czech, cy—Welsh, da—Danish, de—German, de_AT—German (Austria), de_BE—German (Belgium), de_CH—German (Switzerland), de_LI—German (Liechtenstein), de_LU—German (Luxembourg), el—Greek, el_CY—Greek (Cyprus), en_AD—English (Andorra), en_AE—English (United Arab Emirates), en_AG—English (Antigua and Barbuda), en_AL—English (Albania), en_AT—English (Austria), en_AU—English (Australian), en_BA—English (Bosnia and Herzegovina), en_BB—English (Barbados), en_BE—English (Belgium), en_BG—English (Bulgaria), en_BS—English (Bahamas), en_BZ—English (Belize), en_CA—English (Canadian), en_CH—English (Switzerland), en_CY—English (Cyprus), en_CZ—English (Czechia), en_DE—English (Germany), en_DK—English (Denmark), en_DM—English (Dominica), en_EE—English (Estonia), en_ES—English (Spain), en_FI—English (Finland), en_FR—English (France), en_GB—English (UK), en_GD—English (Grenada), en_GI—English (Gibraltar), en_GR—English (Greece), en_GY—English (Guyana), en_HK—English (Hong Kong), en_HR—English (Croatia), en_HU—English (Hungary), en_IE—English (Ireland), en_IL—English (Israel), en_IN—English (Indian), en_IS—English (Iceland), en_IT—English (Italy), en_JM—English (Jamaica), en_JP—English (Japan), en_KN—English (St. Kitts and Nevis), en_KR—English (South Korea), en_LC—English (St. Lucia), en_LI—English (Liechtenstein), en_LT—English (Lithuania), en_LU—English (Luxembourg), en_LV—English (Latvia), en_MC—English (Monaco), en_ME—English (Montenegro), en_MK—English (North Macedonia), en_MT—English (Malta), en_MY—English (Malaysian), en_NL—English (Netherlands), en_NO—English (Norway), en_NZ—English (New Zealand), en_PH—English (Phillipines), en_PL—English (Poland), en_PT—English (Portugal), en_RO—English (Romania), en_RS—English (Serbia), en_SE—English (Sweden), en_SG—English (Singapore), en_SI—English (Slovenia), en_SK—English (Slovakia), en_TH—English (Thailand), en_TR—English (Turkey), en_TT—English (Trinidad and Tobago), en_TW—English (Taiwan), en_US—English, en_VC—English (St. Vincent and the Grenadines), en_ZA—English (South Africa), eo—Esperanto (Pseudo), es—Spanish, es_AD—Spanish (Andorra), es_AR—Spanish (Argentina), es_BO—Spanish (Bolivia), es_CL—Spanish (Chile), es_CO—Spanish (Colombia), es_CR—Spanish (Costa Rica), es_DO—Spanish (Dominican Republic), es_EC—Spanish (Ecuador), es_GT—Spanish (Guatemala), es_HN—Spanish (Honduras), es_MX—Spanish (Mexico), es_NI—Spanish (Nicaragua), es_PA—Spanish (Panama), es_PE—Spanish (Peru), es_PR—Spanish (Puerto Rico), es_PY—Spanish (Paraguay), es_SV—Spanish (El Salvador), es_US—Spanish (United States), es_UY—Spanish (Uruguay), es_VE—Spanish (Venezuela), et—Estonian, eu—Basque, fa—Farsi, fi—Finnish, fr—French, fr_BE—French (Belgium), fr_CA—French (Canadian), fr_CH—French (Switzerland), fr_HT—French (Haiti), fr_LU—French (Luxembourg), fr_MA—French (Morocco), ga—Irish, gu—Gujarati, haw—Hawaiian, hi—Hindi, hmn—Hmong, hr—Croatian, ht—Haitian Creole, hu—Hungarian, hy—Armenian, in—Indonesian, is—Icelandic, it—Italian, it_CH—Italian (Switzerland), iw—Hebrew, iw_EO—Esperanto RTL (Pseudo), ja—Japanese, ji—Yiddish, ka—Georgian, kk—Kazakh, kl—Greenlandic, km—Khmer, kn—Kannada, ko—Korean, lb—Luxembourgish, lt—Lithuanian, lv—Latvian, mi—Te reo, mk—Macedonian, ml—Malayalam, mr—Marathi, ms—Malay, mt—Maltese, my—Burmese, nl_BE—Dutch (Belgium), nl_NL—Dutch, nl_SR—Dutch (Suriname), no—Norwegian, pa—Punjabi, pl—Polish, pt_BR—Portuguese (Brazil), pt_PT—Portuguese (European), quc—Kiche, rm—Romansh, ro—Romanian, ro_MD—Romanian (Moldova), ru—Russian, ru_AM—Russian (Armenia), ru_BY—Russian (Belarus), ru_KG—Russian (Kyrgyzstan), ru_KZ—Russian (Kazakhstan), ru_LT—Russian (Lithuania), ru_MD—Russian (Moldova), ru_PL—Russian (Poland), ru_UA—Russian (Ukraine), sh—Serbian (Latin), sh_ME—Montenegrin, sk—Slovak, sl—Slovene, sm—Samoan, sq—Albanian, sr—Serbian (Cyrillic), sv—Swedish, sv_FI—Swedish (Finland), sw—Swahili, ta—Tamil, te—Telugu, th—Thai, tl—Tagalog, tr—Turkish, uk—Ukrainian, ur—Urdu, vi—Vietnamese, xh—Xhosa, zh_CN—Chinese (Simplified), zh_HK—Chinese (Hong Kong), zh_MY—Chinese (Malaysia), zh_SG—Chinese (Singapore), zh_TW—Chinese (Traditional), zu—Zulu

</details>

---

### ActivationPlatform (17 fields)

**설명:** Represents metadata about ActivationPlatform, such as platform name, delivery schedule, output format, and destination folder. **API version 54.0 and later.**
**Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
**Special Access Rules:** 없음

| Field | Type | Properties | Description / 값 |
|---|---|---|---|
| Description | textarea | Nillable | The description for this ActivationPlatform. |
| DeveloperName | string | Filter, Group, Sort | ActivationPlatform 객체의 unique name(API명 규칙). Label=Record Type Name. 자동생성, API 생성시 직접지정 가능. |
| Enabled | boolean | Defaulted on create, Filter, Group, Sort | Activation Platform 활성화 여부. default false. |
| FullName | string | Create, Group, Nillable | Metadata API상 연관 ActivationPlatform 풀네임(namespace prefix 포함 가능). |
| IncludeSegmentNames | boolean | Defaulted on create, Filter, Group, Sort | 메타데이터에 segment name 포함 여부. default false. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | The language of the ActivationPlatform. org의 language값. |
| LogoUrl | textarea | Nillable | Logo for the activation channel destination. |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| MasterLabel | string | Filter, Group, Sort | Label for the ActivationPlatform. UI=ActivationPlatform. |
| Metadata | ActivationPlatform | Create, Nillable, Update | Provides access to the associated type. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace of the ActivationPlatform. |
| Notes | textarea | Nillable | Notes for this ActivationPlatform. |
| OutputFormat | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | output format of the file. 값: `CSV`, `JSON`, `PARQUET`. |
| OutputGrouping | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | grouping of the output. 값: `PER_ACCOUNT`, `PER_SEGMENT`. |
| PeriodicRefreshFrequecy [sic] | picklist | Filter, Group, Nillable, Restricted picklist, Sort | full refresh frequency in days for incremental refresh mode. API 54.0+. 값: `REFRESH_30`(Full refresh every 30 days), `REFRESH_60`(Full refresh every 60 days). `outputGrouping=PER_SEGMENT`이고 `refreshMode=INCREMENTAL`일 때만 적용. **(필드명은 PDF 원문 표기 그대로; 정상 단어는 "Frequency")** |
| RefreshFrequency | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | activation platform이 데이터 전달을 받는 빈도(시간). 값: `TWENTY_FOUR`. |
| RefreshMode | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | mode of refreshing the file. 값: `INCREMENTAL`. |

> 페이지 상단에 보이는 `ValueType`(account plan objective measure 관련)는 직전 객체 잔여로 ActivationPlatform 필드가 아니다.

---

### DataSourceBundleDefinition (10 fields)

**설명:** Represents the bundle of streams that a user adds to a data kit. **API version 52.0 and later.**
**Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**REST Methods:** DELETE, GET, HEAD, PATCH, POST, Query
**Special Access Rules:** Data 360 권한 필요.

| Field | Type | Properties | Description / 값 |
|---|---|---|---|
| Description | string | Filter, Group, Nillable, Sort | data source bundle 설명. API 55.0+. |
| DeveloperName | string | Filter, Group, Sort | unique name. FullName과 동일값. |
| FullName | string | Create, Group, Nillable | Metadata API상 연관 metadata object 풀네임. |
| Icon | string | Filter, Group, Nillable, Sort | deployment flow의 icon. API 55.0+. |
| IsMultiDeploymentSupported | boolean | Defaulted on create, Filter, Group, Sort | bundle 다중배포 가능 여부. default false. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | Languages supported in the deployment. (거대 picklist — 아래 collapsible 전수) |
| ManageableState | picklist | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| MasterLabel | string | Filter, Group, Sort | name of the bundle. |
| Metadata | complexvalue | Create, Nillable, Update | additional info necessary for the data source bundle. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | namespace prefix. |

<details><summary>DataSourceBundleDefinition Language picklist 전체값 (~170개 — 전수, DataStreamTemplate 목록과 별도)</summary>

af—Afrikaans, am—Amharic, ar—Arabic, ar_AE—Arabic (United Arab Emirates), ar_BH—Arabic (Bahrain), ar_DZ—Arabic (Algeria), ar_EG—Arabic (Egypt), ar_IQ—Arabic (Iraq), ar_JO—Arabic (Jordan), ar_KW—Arabic (Kuwait), ar_LB—Arabic (Lebanon), ar_LY—Arabic (Libya), ar_MA—Arabic (Morocco), ar_OM—Arabic (Oman), ar_QA—Arabic (Qatar), ar_SA—Arabic (Saudi Arabia), ar_SD—Arabic (Sudan), ar_SY—Arabic (Syria), ar_TN—Arabic (Tunisia), ar_YE—Arabic (Yemen), bg—Bulgarian, bn—Bengali, bs—Bosnian, ca—Catalan, cac—Chuj, cak—Kaqchikel, cs—Czech, cy—Welsh, da—Danish, de—German, de_AT—German (Austria), de_BE—German (Belgium), de_CH—German (Switzerland), de_LU—German (Luxembourg), el—Greek, el_CY—Greek (Cyprus), en_AE—English (United Arab Emirates), en_AU—English (Australian), en_BE—English (Belgium), en_CA—English (Canadian), en_CH—English (Switzerland), en_CY—English (Cyprus), en_CZ—English (Czechia), en_DE—English (Germany), en_DK—English (Denmark), en_ES—English (Spain), en_FR—English (France), en_GB—English (UK), en_HK—English (Hong Kong), en_HU—English (Hungary), en_IE—English (Ireland), en_IL—English (Israel), en_IN—English (Indian), en_IT—English (Italy), en_NL—English (Netherlands), en_NO—English (Norway), en_NZ—English (New Zealand), en_PH—English (Philippines), en_PL—English (Poland), en_RO—English (Romania), en_SE—English (Sweden), en_SG—English (Singapore), en_SK—English (Slovakia), en_US—English, en_ZA—English (South Africa), eo—Esperanto (Pseudo), es—Spanish, es_AR—Spanish (Argentina), es_BO—Spanish (Bolivia), es_CL—Spanish (Chile), es_CO—Spanish (Colombia), es_CR—Spanish (Costa Rica), es_DO—Spanish (Dominican Republic), es_EC—Spanish (Ecuador), es_GT—Spanish (Guatemala), es_HN—Spanish (Honduras), es_MX—Spanish (Mexico), es_NI—Spanish (Nicaragua), es_PA—Spanish (Panama), es_PE—Spanish (Peru), es_PR—Spanish (Puerto Rico), es_PY—Spanish (Paraguay), es_SV—Spanish (El Salvador), es_US—Spanish (United States), es_UY—Spanish (Uruguay), es_VE—Spanish (Venezuela), et—Estonian, eu—Basque, fa—Farsi, fi—Finnish, fr—French, fr_BE—French (Belgium), fr_CA—French (Canadian), fr_CH—French (Switzerland), fr_LU—French (Luxembourg), fr_MA—French (Morocco), ga—Irish, gu—Gujarati, haw—Hawaiian, hi—Hindi, hmn—Hmong, hr—Croatian, ht—Haitian Creole, hu—Hungarian, hy—Armenian, in—Indonesian, is—Icelandic, it—Italian, it_CH—Italian (Switzerland), iw—Hebrew, iw_EO—Esperanto RTL (Pseudo), ja—Japanese, ji—Yiddish, ka—Georgian, kk—Kazakh, kl—Greenlandic, km—Khmer, kn—Kannada, ko—Korean, lb—Luxembourgish, lt—Lithuanian, lv—Latvian, mi—Te reo, mk—Macedonian, ml—Malayalam, mr—Marathi, ms—Malay, mt—Maltese, my—Burmese, nl_BE—Dutch (Belgium), nl_NL—Dutch, no—Norwegian, pa—Punjabi, pl—Polish, pt_BR—Portuguese (Brazil), pt_PT—Portuguese (European), quc—Kiche, rm—Romansh, ro—Romanian, ro_MD—Romanian (Moldova), ru—Russian, ru_AM—Russian (Armenia), ru_BY—Russian (Belarus), ru_KG—Russian (Kyrgyzstan), ru_KZ—Russian (Kazakhstan), ru_LT—Russian (Lithuania), ru_MD—Russian (Moldova), ru_PL—Russian (Poland), ru_UA—Russian (Ukraine), sh—Serbian (Latin), sh_ME—Montenegrin, sk—Slovak, sl—Slovene, sm—Samoan, sq—Albanian, sr—Serbian (Cyrillic), sv—Swedish, sw—Swahili, ta—Tamil, te—Telugu, th—Thai, tl—Tagalog, tr—Turkish, uk—Ukrainian, ur—Urdu, vi—Vietnamese, xh—Xhosa, zh_CN—Chinese (Simplified), zh_HK—Chinese (Hong Kong), zh_MY—Chinese (Malaysia), zh_SG—Chinese (Singapore), zh_TW—Chinese (Traditional), zu—Zulu

</details>

---

### DataAssessmentConfigItem (3 fields)

**설명:** Represents a saved configuration for a specific vendor's package for data assessment. **API version 40.0 and later.**
**Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**REST HTTP Methods:** GET
**Special Access Rules:** 없음
**Usage:** external data source의 configuration 필드에 새 configuration을 추가하는 예.

```json
{
"SobjectType" : "01Ixx0000003S4f", //External object Id or api name
"DataAssessmentConfigField" : "00Nxx000001DRL8", //Custom field Id or api name
"DataAssessmentConfigValue" : "Salesforce" // value
}
```

| Field | Type | Properties | Description |
|---|---|---|---|
| DataAssessmentConfigField | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | external object상 특정 data package가 지원하는 필드 목록. |
| DataAssessmentConfigValue | string | Create, Filter, Group, Nillable, Sort, Update | DataAssessmentConfigField의 필드에 선택된 설정값. |
| SobjectType | picklist | Create, Filter, Group, Nillable | The object's API name. |

> 페이지 상단의 `Url`(external web-page tab) 필드는 직전 객체 잔여로 이 객체 필드가 아니다.

---

### DataIntegrationRecordPurchasePermission (3 fields)

**설명:** Represents Lightning Data purchase credits that a Salesforce admin has granted to users. **Available in Tooling API version 42.0 and later.**
**Supported SOAP Calls:** `create()`, `delete()`, `query()`, `retrieve()`, `update()`, `upsert()`
**REST HTTP Methods:** GET, HEAD, POST. (특정 객체 대상: GET, PATCH, DELETE, HEAD.)
**Special Access Rules:** Spring '20 이후 org의 internal user만 이 객체에 접근 가능.
**Usage:** Sample GET response.

```json
{
"attributes" : {
"type" : "DataIntegrationRecordPurchasePermission",
"url" : "/services/data/v42.0/tooling/sobjects/DataIntegrationRecordPurchasePermission/0GyR0000000009xKAA"
},
"Id" : "0GyR0000000009xKAA",
"IsDeleted" : false,
"CreatedDate" : "2017-11-02T22:02:36.000+0000",
"CreatedById" : "005R0000000F4ItIAK",
"LastModifiedDate" : "2017-12-12T18:22:35.000+0000",
"LastModifiedById" : "005R0000000F4ItIAK",
"SystemModstamp" : "2017-12-12T18:22:35.000+0000",
"UserId" : "005R0000000F4ItIAK",
"ExternalObject" : "managedPackageNamespace__CustomObject__x",
"UserRecordPurchaseLimit" : 300
}
```

| Field | Type | Properties | Description |
|---|---|---|---|
| ExternalObject | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 단일 값 보유: Salesforce 레코드에 매칭된 data service record의 이름. |
| UserId | reference | Create, Filter, Group, Sort, Update | purchase credit이 할당된 user의 ID. |
| UserRecordPurchaseLimit | int | Create, Filter, Group, Nillable, Sort, Update | user에게 할당된 purchase credit 수. |

---

## ③ 결제 (Commerce Payments)

### GtwyProvPaymentMethodType (13 fields)

**설명:** Represents a type that allows integrators and payment providers to choose an active payment to receive an order's payment data rather than allowing the Salesforce Order Management platform to select a default payment method. **API version 50.0 and later.**
**Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`
**REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
**Special Access Rules:** Commerce Payments 엔티티 접근에는 Payment Platform org 권한이 활성화된 Salesforce Order Management 라이선스가 필요. Commerce Payments 엔티티는 Lightning Experience에서만 사용 가능.
**Usage:** Order Management payment record의 `ProcessorId`는 payment gateway의 `ExternalReferenceId`와 같은 값이어야 함. gateway provider payment method type record는 연결하려는 payment method를 look up하는 `PaymentMethodType`를 가져야 하며, payment gateway와 gateway provider payment method type은 `PaymentGatewayProviderId`가 일치해야 함. 이 관계 후 payment record가 gateway provider payment method type record로부터 payment method를 추론.

| Field | Type | Properties | Description / 값 |
|---|---|---|---|
| Comments | textarea | Filter, Nillable, Sort | 추가 상세. Max 1000자. |
| DeveloperName | string | Filter, Group, Sort | API name(규칙). 자동생성, 직접지정 가능. Note: 대량 데이터 생성시 각 record에 unique DeveloperName 지정 권장(미지정시 성능저하). Note: View DeveloperName 또는 View Setup and Configuration 권한 사용자만 view/group/sort/filter 가능. |
| Fullname | string | Create, Group, Nillable | Metadata API상 gatewayProviderPaymentMethodType 풀네임. 단일 record 결과일 때만 query 가능(아니면 error). |
| GtwyProviderPaymentMethodType | string | Filter, Group, Nillable, Sort | Salesforce payment method를 Order Management storefront의 payment method에 연결. 값 예시(string): `CREDIT_CARD`, `BASIC_CREDIT`, `CreditCard`, `GooglePay`, `ApplePay`. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | payment gateway integration의 언어. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 현재 사용자가 마지막으로 view한 timestamp. null=referenced만 했고 view 안 함 가능. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| MasterLabel | string | Filter, Group, idLookup, Sort | Required. Label. UI=Gateway Provider Payment Method Type. |
| Metadata | GatewayProviderPaymentMethodType | Create, Nillable, Update | metadata. 단일 record 결과일 때만 query 가능. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | namespace prefix. Limit 15자. |
| PaymentGatewayProviderId | reference | Filter, Group, Nillable, Sort | Order Management가 결제처리에 쓸 payment gateway provider. 1 provider→다수 payment method type 가능. (rel Name=PaymentGatewayProvider, Type=Lookup, Refers To PaymentGatewayProvider) |
| PaymentMethodType | picklist | Filter, Group, Nillable, Restricted picklist, Sort | Order Management order에 쓰이는 payment method 유형. 값: `AlternativePaymentMethod`, `CardPaymentMethod`, `DigitalWallet`. |
| RecordTypeId | reference | Filter, Group, Nillable, Sort | record type ID. (rel Name=RecordType, Type=Lookup, Refers To RecordType) |

> 페이지 상단의 `Regular`/`Role`/`RoleAndSubordinates`(Group type) 목록은 직전 객체(Group) 잔여로 이 객체 값이 아니다.

---

### PaymentGatewayProvider (11 fields)

**설명:** Represents the payment gateway provider processing payments. **API version 48.0 and later.**
**Supported SOAP Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`
**REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query
**Special Access Rules:** API로 Salesforce Payments 객체에 접근하려면 org에 다음 라이선스 중 하나 이상 필요 — Salesforce Payments, Salesforce Order Management, B2B Commerce, D2C Commerce. Salesforce Payments 객체는 Lightning Experience에서만 사용 가능.

| Field | Type | Properties | Description / 값 |
|---|---|---|---|
| ApexAdapterId | reference | Filter, Group, Nillable, Sort | payment gateway용 Apex adapter 참조. org내 unique. (rel Name=ApexAdapter, Type=Lookup, Refers To ApexClass) |
| Comments | textarea | Filter, Nillable, Sort | 추가 상세. Max 1000자. |
| DeveloperName | string | Filter, Group, Sort | Required. API name(규칙). Label=Record Type Name. 자동생성, 직접지정 가능. |
| Fullname | string | Create, Group, Nillable | Metadata API상 풀네임(namespaceprefix 포함 가능). 단일 record 결과일 때만 query. |
| IdempotencySupported | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | idempotency 사용 가능 여부. 값: `No`, `Yes`. default No. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | → 공통 Marketing Language 18값 참조. |
| LastViewedDate | dateTime | Filter, Nillable, Sort | 마지막 view timestamp. null=referenced만 가능. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| MasterLabel | string | Filter, Group, idLookup, Sort | Label. UI=Payment Gateway Provider. |
| Metadata | PaymentGatewayProvider | Create, Nillable, Update | metadata. 단일 record 결과일 때만 query. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | namespace prefix. Limit 15자. |

> 페이지 상단의 `Information`/`Layout`(Valid values) 목록은 직전 객체 잔여로 이 객체 값이 아니다.

---

## ④ 마케팅 / Account Engagement

이 그룹의 **MarketingAppExtension이 부모 객체**이며, MarketingAppExtAssignment·MarketingAppExtActivity·MarketingAppExtAction가 이를 lookup으로 참조한다. (아래는 팀 컨벤션에 따라 필드수 내림차순 정렬.)

> **Pardot 명칭 주의:** Pardot은 현재 Marketing Cloud Account Engagement로 불린다. API reference·documentation 일부에는 이전 이름(Pardot)이 잔존한다.

### MarketingAppExtAction (10 fields)

**설명:** Represents an Action Type, which is an action that you can add to Engagement Studio programs in Account Engagement and execute in a third-party app. **API version 56.0 and later.**
**Supported SOAP Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**REST HTTP Methods:** DELETE, GET, HEAD, PATCH, POST, Query
**Special Access Rules:** Account Engagement Plus, Advanced, 또는 Premium edition 고객에게 제공.

| Field | Type | Properties | Description |
|---|---|---|---|
| ActionName | string | Create, Filter, Group, Sort, Update | internal용 action명. UI 표시. |
| ActionParams | textarea | Create, Nillable, Update | invocable action의 parameters. UI 표시. |
| ActionSchema | textarea | Create, Nillable, Update | invocable action의 JSON schema. UI 표시. |
| ActionSelector | string | Create, Filter, Group, Sort, Update | Invocable action selector. UI 표시. |
| ApiName | string | Create, Filter, Group, Sort, Update | API명(규칙). 자동생성, 직접지정 가능. UI 표시. |
| Description | textarea | Create, Nillable, Update | action의 internal 설명. UI 표시. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | default false. UI 표시. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| MarketingAppExtensionId | reference | Create, Filter, Group, Sort | relationship field. (rel Name=MarketingAppExtension, Type=Lookup, Refers To MarketingAppExtension) |
| Version | double | Create, Filter, Sort, Update | Reserved for future use. |

---

### MarketingAppExtActivity (9 fields)

**설명:** Represents an Activity Type, which is a prospect activity that occurs in a third-party app and can be used in Account Engagement automations. **API version 53.0 and later.**
**Supported SOAP Calls:** `create()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**REST HTTP Methods:** GET, HEAD, PATCH, POST, Query
**Special Access Rules:** Account Engagement Plus, Advanced, 또는 Premium edition 고객에게 제공.

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Create, Nillable, Update | activity의 internal 설명. UI 표시. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | unique name. UI=Extension API Name(/ API Name). (API명 규칙) |
| EndpointUrl | string | Filter, Nillable | 3rd-party app 연결 도움용 sample endpoint. UI 표시. |
| IsActive | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Activity Type를 automation에서 사용 가능. Label=Active in Automations. default false. |
| Language | picklist | Filter, Group, Restricted picklist, Sort | → 공통 Marketing Language 18값 참조. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| MarketingAppExtensionId | reference | Create, Filter, Group, Sort | Activity Type가 연관된 Marketing App Extension. (rel Name=MarketingAppExtension, Type=Lookup, Refers To MarketingAppExtension) |
| MasterLabel | string | Create, Filter, Group, Sort, Update | Label. UI=Activity Name. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | namespace prefix. Limit 15자. |

---

### PardotTenant (8 fields)

**설명:** Represents an Account Engagement business unit. **API version 56.0 and later.** 사용 가능한 SOAP call로 새 business unit을 생성하고, 기존 business unit의 정보를 query/update한다.
**Supported SOAP Calls:** `create()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**REST API Methods:** GET, HEAD, PATCH, POST, Query
**Special Access Rules:** 모든 Account Engagement edition 고객에게 제공.
**Usage:** business unit 생성에는 `InitialPardotAdminID`에 유효한 user ID와 `PardotTenantName` 값을 설정. business unit이 여러 개면 `PardotTenantName`은 unique해야 함. 상태 확인은 `PardotTenantID`를 query(`CREATING`=생성 중, `CREATED`=생성 완료). update는 `PardotTenantName` 변경과, 생성 중 오류 발생시 삭제로 제한. PardotTenant 삭제 조건:
- `CreationStatus`가 `ERROR`.
- `CreationStatus`가 `CREATING`/`UPDATING`/`DELETING`이고 시스템이 지난 1시간 동안 tenant를 업데이트하지 않은 경우.

| Field | Type | Properties | Description / 값 |
|---|---|---|---|
| CreationStatus | picklist | Create, Defaulted on create, Filter, Group, Restricted picklist, Sort, Update | business unit operational status. 값: `Backfilled`, `Created`, `Creating`, `Deleted`, `Deleting`, `Deprovisioned`, `Deprovisioning`, `Error`, `Updated`, `Updating`. default Creating. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | UUID. INSERT시 미제공이면 auto-generate. |
| InitialPardotAdminId | reference | Create, Filter, Group, Nillable, Sort | business unit을 설정한 Salesforce user. (rel Name=InitialPardotAdmin, Type=Lookup, Refers To User) |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | business unit의 언어. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | Account Engagement BU명. PardotTenantName과 sync. |
| PardotTenantId | string | Filter, Group, Nillable, Sort | BU의 numerical identifier. |
| PardotTenantName | string | Create, Filter, Group, Sort, Update | Account Engagement BU명. MasterLabel과 sync. |
| PardotTenantStatusCode | picklist | Filter, Group, Nillable, Restricted picklist, Sort | BU operational status. 값: `InsufficientLicenseLimits`, `InvalidRequest`, `PardotAccountNotFound`, `UnknownError`, `UsernameCollision`. |

---

### MarketingAppExtension (7 fields)

**설명:** Represents an integration with a third-party app or service that generates prospect external activity. **API version 53.0 and later.** (Assignment·Activity·Action의 부모 객체.)
**Supported SOAP Calls:** `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `search()`
**REST HTTP Methods:** GET, PATCH, POST
**Special Access Rules:** Account Engagement Plus, Advanced, 또는 Premium edition 고객에게 제공.

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | textarea | Nillable | activity의 internal 설명. UI 표시. |
| DeveloperName | string | Filter, Group, Sort | unique name. UI=API Name. (API명 규칙) |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | Account Engagement automation에서 사용 가능하게. Label=Active in Automations. default false. |
| Language | picklist | Filter, Group, Restricted picklist, Sort | → 공통 Marketing Language 18값 참조. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| MasterLabel | string | Filter, Group, idLookup, Sort | Label. UI=Extension Name. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | namespace prefix. Limit 15자. |

> 페이지 상단의 JSON(`My_Managed_Subscription`, `ManagedEventSubscription`)은 직전 객체(ManagedEventSubscription) Usage 잔여로 이 객체와 무관하다.

---

### MarketingAppExtAssignment (2 fields)

**설명:** Represents a Marketing App Extension Business Unit assignment, which dictates which Account Engagement business unit the external activity data is available in. **API version 53.0 and later.**
**Supported SOAP Calls:** `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
**REST HTTP Methods:** DELETE, GET, HEAD, PATCH, POST, Query
**Special Access Rules:** Account Engagement Plus, Advanced, 또는 Premium edition 고객에게 제공.

| Field | Type | Properties | Description |
|---|---|---|---|
| MarketingAppExtensionId | reference | Create, Filter, Group, Sort, Update | Business Unit Assignment이 연관된 Marketing App Extension. (rel Name=MarketingAppExtension, Type=Lookup, Refers To MarketingAppExtension) |
| ParentId | reference | Create, Filter, Group, Sort, Update | Account Engagement business unit의 ID. (rel Name=Parent, Type=Lookup, Refers To PardotTenant) |

---

## ⑤ 스키마·UI·Misc

### RecentlyViewed (16 fields) [BOUNDARY]

**설명:** Represents metadata entities typically found in Setup such as page layout definitions, workflow rule definitions, and email templates that the current user has recently viewed. **Tooling API version 33.0 and later.**
**Supported SOAP Calls:** `query()`, `update()`
**REST HTTP Methods:** GET
**Special Access Rules:** (명시적 섹션 없음)

> 이 객체의 쿼리 패턴 facet은 [[SOQL 패턴]] 참조.

**Usage:** 이종(heterogeneous) metadata type 목록으로 최근 조회 record를 구성. record는 사용자가 상세를 본 경우 viewed로 간주(목록에서 다른 record와 함께 본 것은 아님). `Type`으로 object type 필터링 가능. RecentlyViewed 데이터는 object당 200 record로 주기적으로 truncate되며, 90일간 보존 후 주기적으로 제거된다.

**지원 metadata entities (전수):** Apex classes, Apex triggers, Approval processes, Apps, Custom report types, Email templates, Fields, Objects, Page layouts, Permission sets, Profiles, Static resources, Tabs, Users, Validation rules, Visualforce pages, Visualforce components, Workflow email alerts, Workflow field updates, Workflow outbound messages, Workflow rules, Workflow tasks

```sql
SELECT Id, Name
FROM RecentlyViewed
WHERE LastViewedDate !=null
ORDER BY LastViewedDate DESC
```

```sql
SELECT Id, Name
FROM RecentlyViewed
WHERE Type IN ('CustomEntityDefinition', 'CustomFieldDefinition')
ORDER BY LastViewedDate DESC
```

| Field | Type | Properties | Description |
|---|---|---|---|
| Alias | string | Filter, Group, Nillable, Sort | item의 alias. |
| Email | email | Filter, Group, Nillable, Sort | item의 email 주소. |
| FirstName | string | Filter, Group, Nillable, Sort | item의 first name. |
| Id | ID | Defaulted on create, Filter, Group, Sort | recently viewed item의 ID. |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort | item이 active user인지(true). user일 때만 값 존재. |
| LastName | string | Filter, Group, Nillable, Sort | item의 last name. |
| LastReferencedDate | dateTime | Filter, Nillable, Sort, Update | 이 item 관련 item을 마지막 view한 timestamp. |
| LastViewedDate | dateTime | Filter, Nillable, Sort, Update | 이 item을 마지막 view한 timestamp. null=referenced만(LastReferencedDate). |
| Name | string | Filter, Group, Nillable, Sort | user면 FirstName+LastName 결합. |
| NetworkId | reference | Filter, Group, Nillable, Sort | item이 속한 Experience Cloud site ID. digital experiences 활성화시만. |
| Phone | phone | Filter, Group, Nillable, Sort | item의 전화번호. |
| ProfileId | reference | Filter, Group, Nillable, Sort | user면 user의 profile ID. |
| RelatedObject | picklist | Filter, Group, Nillable, Restricted picklist, Sort | item이 관련된 object. 예: Account Custom Field면 related object=Account. 모든 item이 related object를 갖지는 않음. |
| Title | string | Filter, Group, Nillable, Sort | user면 user의 title(예: CFO, CEO). |
| Type | picklist | Filter, Group, Nillable, Restricted picklist, Sort | item의 sObject type. |
| UserRoleId | reference | Filter, Group, Nillable, Sort | 이 object와 연관된 user role ID. |

> **PDF 셀 collapse 정정:** `Title`/`Type`/`UserRoleId`의 Properties가 PDF에서 붙어 출력됐다("FilterGrouplable, Sort" 등). 위 표는 정상 해석값(Title=Filter, Group, Nillable, Sort / Type=Filter, Group, Nillable, Restricted picklist, Sort / UserRoleId=Filter, Group, Nillable, Sort)으로 기재. `LastViewedDate`의 Type은 PDF에 "dateTimedateTime"으로 중복 출력됐으나 실제는 **dateTime**.
> 페이지 상단의 `QuickActionListId`/`SortOrder` + QuickActionListItem 코드는 직전 객체(QuickActionListItem) 잔여로 제외.

---

### RelatedListDefinition (10 fields)

**설명:** Represents information about a related list. A related list specifies a set of records for a related object, based on specific criteria. **API version 55.0 and later.**
**Supported SOAP Calls:** `describeSObjects()`, `query()`
**REST API Methods:** Query
**Special Access Rules:** This object is read-only.
**Usage:** 주어진 entity(예: Account record)에 대한 모든 related list 조회.

```sql
SELECT DurableId, Label, RelatedListName FROM RelatedListDefinition WHERE ParentEntityDefinitionId = 'Account'
```

| Field | Type | Properties | Description |
|---|---|---|---|
| DefaultSort | string | Filter, Group, Nillable, Sort | related list의 default sort string. |
| DurableId | string | Filter, Group, Nillable, Sort | related list의 unique identifier. release간 변할 수 있음. |
| EntityDefinitionId | string | Filter, Group, Nillable, Sort | related list를 포함하는 entity의 ID. (rel Name=EntityDefinition, Type=Lookup, Refers To EntityDefinition) |
| IsCustomizable | boolean | Defaulted on create, Filter, Group, Sort | related list 컬럼 customize 가능 여부. default false. |
| IsDescribable | boolean | Defaulted on create, Filter, Group, Sort | describeLayout 결과에 나타날 수 있는지. default false. |
| IsLayoutable | boolean | Defaulted on create, Filter, Group, Sort | layout에 할당 가능 여부. default false. |
| Label | string | Filter, Group, Nillable, Sort | related list의 label. |
| ParentEntityDefinitionId | string | Filter, Group, Nillable, Sort | related list rows와 연관된 ParentEntityDefinition ID. (rel Name=ParentEntityDefinition, Type=Lookup, Refers To EntityDefinition) |
| RelatedListId | string | Filter, Group, Nillable, Sort | related list의 ID. |
| RelatedListName | string | Filter, Group, Nillable, Sort | API상 related list unique name. |

> 페이지 상단의 Relationship Type Lookup/Refers To + RelatedListColumnDefinition SELECT는 직전 객체 잔여로 제외.

---

### CustomNotificationType (10 fields) [BOUNDARY]

**설명:** Stores information about custom notification types. **API version 46.0 and later.**
**Supported Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()` (REST 별도 명시 없음 — "Supported Calls"만 표기)
**Special Access Rules:** 아래 Note가 접근 규칙 역할.
**Note(전문):** CustomNotificationType is exposed in Tooling API to user profiles with the View Setup and Configuration permission. To create and edit notification types, the Customize Application permission is required.

> 이 객체의 런타임 발송 facet(Apex `Messaging.CustomNotification`)은 [[CustomNotification]] 참조.

| Field | Type | Properties | Description |
|---|---|---|---|
| CustomNotifTypeName | string | Create, Filter, Group, idLookup, Sort, Unique, Update | notification type name. org내 unique. Max 80자. |
| Description | textarea | Create, Filter, Group, Nillable, Sort, Update | 일반 설명, type name과 함께 표시. Max 255자. |
| Desktop | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | desktop delivery channel 활성화 여부. default false. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | API name of the notification type. |
| IsSlack | boolean | Reserved for future use. | Reserved for future use. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | custom notification type의 language. org의 language값. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | notification type label. |
| Mobile | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | mobile delivery channel 활성화 여부. default false. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | managed package 설치시 namespace. |

> 페이지 상단의 `TargetId` + "CustomNotifActionDef is exposed…" Note는 직전 객체(CustomNotifActionDef) 잔여로 제외.

---

### StandardAction (9 fields)

**설명:** Represents the buttons, links, and actions (standard actions) for a standard or custom object. **API version 34.0 and later.** object의 management settings → Buttons, Links, and Actions에서 standard action을 볼 수 있다.
**Supported SOAP Calls:** `query()`
**REST HTTP Methods:** GET
**Special Access Rules:** (명시적 섹션 없음; 아래 Note 참조)
**Note(전문):** StandardAction fields are exposed in SOAP API version 45.0 and later. You can use Tooling API to query for StandardAction fields in guest user mode in API version 44.0 and earlier. In API version 45.0 and later, use SOAP API to get this data in guest user mode. StandardAction is still exposed in Tooling API to User Profiles with the ViewSetup permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| ContentType | string | Filter, Group, Restricted picklist, Sort | button/link이 standard, URL, s-control, JavaScript action, Visualforce page 인지. UI의 Content Source 필드에 매핑. |
| Description | string | Filter, Group, Nillable, Sort | admin에게 standard action setup 페이지에 표시되는 텍스트. Label/Name과 다를 수 있음. |
| DurableId | string | Filter, Group, Nillable, Sort | field의 unique identifier. release간 변할 수 있음. |
| EntityDefinitionId | string | Filter, Group, Sort | 이 standard action이 정의된 standard/custom object의 ID. |
| IsOverridden | boolean | Defaulted on create, Filter, Group, Sort | 이 standard action이 override되었는지(true). |
| Label | string | Filter, Group, Nillable, Sort | UI에 표시되는 텍스트. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | → 공통 enum 블록 참조. |
| Name | string | Filter, Group, Sort | merge field에서 참조시 button/link unique name. (API명 규칙) |
| OverrideContentId | reference | Filter, Group, Nillable, Sort | OverrideContent record의 ID. |

> 페이지 상단의 SourceMember / SourceMember(Reserved…) / SourceMemberDeployRequest(Reserved…)는 직전 객체들 잔여로 제외.

---

### Publisher (6 fields)

**설명:** Represents the publisher of objects and fields. 예: 표준 객체의 publisher는 Salesforce, custom object의 publisher는 organization, 설치된 패키지의 publisher는 the package. **Available in Tooling API version 34.0 and later.**
**Supported SOAP Calls:** `query()`
**REST HTTP Methods:** GET
**Limitations:** SOQL Limitations (PDF p.38), SOSL Limitations (PDF p.40).
**Special Access Rules:** Spring '20 이후 authenticated internal·external user만 이 객체에 접근 가능.
**Note(전문):** Publisher fields are exposed in SOAP API version 46.0 and later. You can use Tooling API to query for Publisher fields in guest user mode in API version 45.0 and earlier. In API version 46.0 and later, use SOAP API to get this data in guest user mode. Publisher is still exposed in Tooling API to User Profiles with the ViewSetup permission.

| Field | Type | Properties | Description |
|---|---|---|---|
| DurableId | string | Filter, Group, Nillable, Sort | field의 unique identifier. release간 변할 수 있으니 사용 전 항상 조회. |
| IsSalesforce | boolean | Filter, Group, Nillable, Sort | Salesforce가 연관 object/field를 제공했는지(true). |
| MajorVersion | int | Filter, Group, Nillable, Sort | package version의 first number(x.y 또는 x.y.z의 x). |
| MinorVersion | int | Filter, Group, Nillable, Sort | package version의 second number(y). 미지정시 default=현재 released 패키지 minor+1(미released면 0). |
| Name | string | Filter, Group, Nillable, Sort | publisher의 presentation-friendly 이름. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | namespace prefix. Limit 15자. **publisher가 Salesforce면 null.** |

> 페이지 상단의 `LayoutId`/`ProfileId`/`RecordTypeId`/`TableEnumOrId`는 직전 객체 잔여로 제외.

---

## ⑥ 복합·결과 타입 (부록 — sObject 아님)

아래 3종은 **sObject가 아니며 SOAP/REST 호출 섹션이 없다(누락 아님).** 다른 객체의 결과/하위 타입으로 반환된다.

### QueryResult (7 fields) + QueryLocator Metadata 서브타입

**설명:** Represents the results of a query. 예: EntityDefinition을 query하면 해당 entity의 모든 layout이 Layouts 필드에 QueryResult 객체 배열로 반환된다. **Available in Tooling API version 34.0 and later.** **QueryResult is not an extension of sObject.**

| Field | Type | Description |
|---|---|---|
| done | boolean | true=더 이상 행 없음, false=잔여 행 있음. 결과 iteration의 loop condition으로 사용. |
| entityTypeName | string | object/entity type (예: ApexClass, CompactLayoutInfo). |
| nextRecordsUrl | string | 결과가 batch size 초과시 다음 record URL. REST resource queryAll에 채워짐. SOAP의 queryLocator와 유사. |
| queryLocator | QueryLocator | 결과 초과시 다음 batch 조회용 unique identifier. SOAP queryMore()에 채워짐. REST queryAll과 유사. 매 batch마다 새 값. |
| records | sObject | query에 매칭된 sObject 배열. |
| size | int | 반환된 총 행 수. 0이면 0. Enterprise/Partner WSDL의 QueryResult size와 동일. |
| totalSize | int | 반환된 총 행 수. 0보다 크면 행 있음. REST query/queryAll의 totalSize와 동일. |

**서브타입 — QueryLocator (Metadata):**

| Field | Type | Description |
|---|---|---|
| queryLocator | string | 결과가 batch size 초과시 identifier. SOAP queryMore() 호출로 다음 batch 조회. 매 batch마다 새 값. |

---

### SOQLResult (3 fields)

**설명:** A complex type that represents the result of a SOQL query in an **ApexExecutionOverlayResult** object. **Available from API version 28.0 or later.** (본체 객체는 [[Tooling API 객체 — Apex 코드·테스트·커버리지]]의 ApexExecutionOverlayResult.)

| Field | Type | Description |
|---|---|---|
| queryError | string | execution 실패시 반환되는 error 텍스트. |
| queryMetadata | QueryResultMetadata | 성공시 반환되는 structured result. `QueryResultMetadata` 포함 필드: `columnMetadata`, `entityName`, `groupBy`, `idSelected`, `keyPrefix`. |
| queryResult | array of MapValue | `MapValue`는 `MapEntry` 배열을 포함, `MapEntry` 포함 필드: `keyDisplayValue`, `value`(reference to StateValue). |

---

### CompactLayoutItemInfo (6 fields)

**설명:** Represents a field selected for a compact layout, and the order of that field in the compact layout. **API version 32.0 and later.** (본체 compact layout 객체는 [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]]의 CompactLayout / CompactLayoutInfo.)
**Supported SOAP Calls:** `query()` · **REST HTTP Methods:** GET — (이 타입은 sObject 형태로 query 가능하지만, compact layout에 종속된 Info 타입이므로 부록에 배치.)
**Limitations:** SOQL Limitations (PDF p.38), SOSL Limitations (PDF p.40).
**Special Access Rules:** 없음

| Field | Type | Properties | Description |
|---|---|---|---|
| CompactLayoutInfo | CompactLayoutInfo | Filter, Group, Nillable, Sort | 이 CompactLayoutItemInfo와 연관된 compact layout. |
| CompactLayoutInfoId | Id | Filter, Group, Nillable, Sort | 이 field와 연관된 compact layout의 ID. |
| DurableId | string | Filter, Group, Nillable, Sort | reserved for future use. Do not use. |
| FieldDefinition | FieldDefinition | Filter, Group, Nillable, Sort | Required. 이 field의 정의. |
| FieldDefinitionId | string | Filter, Group, Nillable, Sort | Required. 이 field의 ID. |
| SortOrder | int | Filter, Group, Nillable, Sort | compact layout에서 field 순서. 1이 첫번째. |

> 페이지 상단의 NamespacePrefix bullet + CompactLayoutInfo Note는 직전 객체(CompactLayoutInfo) 잔여로 제외.

---

## 관련 노트
- [[Tooling API — 개요·REST·SOAP 호출 기초]] — Tooling API 호출 기초·허브
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 전체 객체 분류 카탈로그
- [[Tooling API 객체 — Service·OmniChannel (라우팅·대화채널·서비스카탈로그·스케줄링)]] — 같은 C4-9 그룹
- [[Tooling API 객체 — 세일즈·예측·AI (포캐스팅·머신러닝·Einstein·Agentforce)]] — 같은 C4-9 그룹
- [[Tooling API 객체 — Experience·콘텐츠·커머스 (사이트·모더레이션·관리형콘텐츠·웹스토어)]] — 같은 C4-9 그룹 (커머스 결제·외부서비스 인접)
- [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]] — CompactLayoutItemInfo가 속한 CompactLayout 본체 / RelatedListDefinition·StandardAction UI 본체
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — SOQLResult가 종속된 ApexExecutionOverlayResult 본체
- [[CustomNotification]] — CustomNotificationType의 Apex 런타임 발송 facet
- [[SOQL 패턴]] — RecentlyViewed 쿼리 패턴 facet
- [[External Services]] — ExternalServiceRegistration의 통합 본체
- [[ExternalService Namespace]] — ExternalServiceRegistration의 Apex 네임스페이스 facet
