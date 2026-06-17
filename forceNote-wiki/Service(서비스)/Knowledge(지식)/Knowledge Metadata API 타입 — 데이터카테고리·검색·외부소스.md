---
tags: [Service, Knowledge, 지식, Metadata-API, DataCategoryGroup, SearchSettings, SynonymDictionary, ExternalDataSource, 데이터카테고리]
source: salesforce_knowledge_dev_guide.pdf (v67.0 Summer '26, Ch4 PDF p152–175)
created: 2026-06-17
aliases: [DataCategoryGroup, SearchSettings, SearchLayouts, SynonymDictionary, ExternalDataSource, 데이터 카테고리 그룹, 검색 설정 메타데이터, 동의어 사전, 외부 데이터 소스, Salesforce Connect adapter, customConfiguration]
---

# Knowledge Metadata API 타입 — 데이터카테고리·검색·외부소스

> Salesforce Knowledge Metadata API의 5개 타입 — DataCategoryGroup, SearchSettings, SearchLayouts, SynonymDictionary, ExternalDataSource — 의 필드·서브타입·예제 XML/JSON·Usage를 전수 정리한다. 아티클 타입·채널·설정 타입은 [[Knowledge Metadata API 타입 — 아티클·채널·설정]] 참조.

---

## ⑥ DataCategoryGroup — 데이터 카테고리 그룹 (API v18.0+)

data category group을 나타낸다. Metadata 타입을 확장하고 `fullName`을 상속.

> **Warning:** Metadata API로 한 org에서 다른 org로 category 변경을 deploy하면, XML 파일에 지정되지 않은 category와 record categorization이 영구 제거된다. sandbox→production 배포보다 Setup의 Data Categories에서 수동으로 data category와 record 연관을 만드는 것을 권장한다.

data category group은 데이터를 분류·필터링하고 사용자 간 공유하기 위해 제공된다. 각 group은 계층적으로 조직될 수 있는 item(data category)을 담는다. (예: Geography group → Worldwide → North America → United States of America / Canada / Mexico / Europe / Asia)

**File Suffix and Directory Location:** 접미사 `.datacategorygroup`. group당 하나의 파일, `datacategorygroups` 폴더에 저장.

**Fields (DataCategoryGroup):**

| Field Name | Field Type | Description |
|---|---|---|
| `active` | `boolean` | **Required.** category group의 상태. 활성(true)/비활성(false). |
| `dataCategory` | `DataCategory` | **Required.** data category group 내 최상위 category. |
| `description` | `string` | data category group 설명. |
| `fullName` | `string` | **Required.** data category group의 고유 이름. 생성 시 fullName과 파일 이름(접미사 제외)이 일치해야 함. underscore와 영숫자만 가능, 고유해야 하며 letter로 시작, 공백 불가, underscore로 끝날 수 없고, 연속 underscore 2개 불가. Metadata 컴포넌트에서 상속. |
| `label` | `string` | **Required.** Salesforce에서 객체를 나타내는 label. |
| `objectUsage` | `ObjectUsage` | data category group에 연관된 객체. |

**서브타입 — DataCategory:** data category group의 item. data category는 다른 data category 목록을 재귀적으로 담을 수 있다.

| Field Name | Field Type | Description |
|---|---|---|
| `dataCategory` | `DataCategory[]` | 하위 data category의 재귀 목록(예: 대륙 내 국가 목록). data category group당 최대 100개 category, 계층은 최대 5단계. |
| `label` | `string` | **Required.** Salesforce UI 전반에서 data category의 label. |
| `name` | `string` | **Required.** API 접근의 고유 식별자로 쓰이는 data category의 developer name. 문자·letter·underscore(_)만 가능, letter로 시작, underscore로 끝나거나 연속 underscore 2개 불가. **Important:** 이 값은 한 번 정의되면 변경 불가. **Warning:** 이미 존재하는 category group을 deploy하면 XML에 정의되지 않은 category는 org에서 영구 제거됨. |

**서브타입 — ObjectUsage:** data category group에 연관될 수 있는 객체. 객체를 data category로 분류·필터링하게 한다.

| Field Name | Field Type | Description |
|---|---|---|
| `object` | `string[]` | data category group에 연관될 수 있는 객체 이름 목록. 유효 값: **KnowledgeArticleVersion**(아티클 연관), **Question**(question 연관. Question 객체는 최대 하나의 category group에만 연관 가능). **Warning:** 이미 존재하는 category group을 deploy하면 XML에 정의되지 않은 객체 연관은 영구 제거됨. XML에 org의 모든 연관 레코드를 지정할 것. |

**Declarative Metadata Sample Definition (DataCategoryGroup):**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<DataCategoryGroup xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>Geography</label>
    <description>Geography structure of service center locations</description>
    <fullName>geo</fullName>
    <dataCategory>
        <name>WW</name>
        <label>Worldwide</label>
        <dataCategory>
            <name>AMER</name>
            <label>North America</label>
            <dataCategory>
                <name>USA</name>
                <label>United States of America</label>
            </dataCategory>
            <dataCategory>
                <name>CAN</name>
                <label>Canada</label>
            </dataCategory>
            <dataCategory>
                <name>MEX</name>
                <label>Mexico</label>
            </dataCategory>
        </dataCategory>
        <dataCategory>
            <name>EMEA</name>
            <label>Europe, Middle East, Africa</label>
            <dataCategory>
                <name>FR</name>
                <label>France</label>
            </dataCategory>
            <dataCategory>
                <name>SP</name>
                <label>Spain</label>
            </dataCategory>
            <dataCategory>
                <name>UK</name>
                <label>United-Kingdom</label>
            </dataCategory>
        </dataCategory>
        <dataCategory>
            <name>APAC</name>
            <label>Asia</label>
        </dataCategory>
    </dataCategory>
    <objectUsage>
        <object>KnowledgeArticleVersion </object>
    </objectUsage>
</DataCategoryGroup>
```

> 위 XML은 PDF 원문(pdftotext)에서 닫는 태그 들여쓰기가 평탄화되어 중첩 깊이가 모호하게 추출된 것을, 표준 XML 들여쓰기로 정리해 중첩 의미를 복원한 형태다.

**Usage:** category group XML 파일을 deploy하면 Metadata API는 대상 org에 category group이 존재하는지 확인한다. 없으면 생성, 있으면:
- XML에 정의된 새 category·object를 추가.
- XML에 정의되지 않은 category를 삭제. 삭제된 category에 연관된 레코드는 부모 category로 재연관.
- XML에 정의되지 않은 object 연관을 삭제.
- 계층 위치가 XML과 다르면 category를 이동.

> **Note:** category가 새 부모 category로 이동하면, 새 부모에 visibility가 없는 사용자는 재배치된 category에 대한 visibility를 잃는다.

> **Note:** category 삭제·재배치와 record categorization·visibility에 대한 영향은 Salesforce online help의 "Delete a Data Category", "Modify and Arrange Data Categories" 참조.

Metadata API로 org 간 category 변경을 deploy하면 XML에 지정되지 않은 category와 record categorization이 영구 제거된다(위 Warning과 동일).

### 배포 시나리오 (원문 서술)

PDF p158–160의 두 시나리오(원문에선 hierarchy 다이어그램으로 보강되나 pdftotext가 잡은 것은 서술 텍스트뿐):

1. **카테고리 교체:** Geography group XML을 이미 동일 group이 정의된 org에 배포하면, org에 `US` category가 있고 XML의 동일 계층 위치에 `USA`가 있을 때, 배포는 `US`를 삭제하고 `US`의 레코드 연관을 부모 `AMER`로 이동시키며 `AMER` 아래 `USA`를 추가한다. 이전에 `US`로 분류된 모든 레코드는 이제 `AMER`와 연관된다.

2. **카테고리 삭제/이동 후 배포:** sandbox에서 Hierarchy 1(초기) → Hierarchy 2(EMEA 아래 EU 추가, FR/SP/UK를 EU 아래로 이동) → Hierarchy 3(FR 삭제, 레코드를 새 부모 EU로 연관)으로 변경 후 production에 배포한다. Metadata API는 변경 순서 개념이 없고 단순히 한 org→다른 org로 변경을 배포한다. 배포 시 먼저 FR 삭제를 인지해 production에서 제거 → FR 레코드 연관을 부모 EMEA로 이동 → EU 추가 후 SP·UK를 EU 아래로 이동. 결과적으로 계층 모양은 같아 보이나, 원래 sandbox에서 FR과 연관됐던 레코드는 sandbox에선 EU와, production에선 EMEA와 연관되어 record categorization이 달라진다.

> 위 시나리오는 PDF에 hierarchy 1/2/3 다이어그램이 있으나 텍스트로 추출된 서술만 옮긴 것이다(다이어그램 미재현).

**Wildcard Support:** 이 타입은 package.xml에서 wildcard `*`를 지원한다.

---

## ⑦ SearchSettings — org의 검색 설정 (API v37.0+)

org의 검색 설정을 나타낸다. Metadata 타입을 확장하고 `fullName`을 상속. package manifest에서 Settings 이름으로 접근.

**File Suffix and Directory Location:** 단일 파일 `Search.settings`, `settings` 폴더에 저장.

**Fields (SearchSettings):**

| Field Name | Field Type | Description |
|---|---|---|
| `documentContentSearchEnabled` | `boolean` | full-text 문서 검색 수행 여부. |
| `enableAdvancedSearchInAlohaSidebar` | `boolean` | search sidebar에서 advanced search 가능 여부. Salesforce Classic only. API v46.0+. |
| `enableEinsteinSearchAssistantDialog` | `boolean` | Einstein search 경험 활성 여부. API v50.0+. |
| `enableEinsteinSearchEs4kPilot` | `boolean` | Einstein Search for Knowledge 향상 활성 여부. API v54.0+. Winter '23에 GA. API v56.0+에선 기본값 true. |
| `enableEinsteinSearchNaturalLanguage` | `boolean` | natural language search 활성 여부. API v50.0+. |
| `enableEinsteinSearchNLSFilters` | `boolean` | Natural Language Search Filters (Pilot) 활성 여부. API v54.0+. |
| `enableEinsteinSearchPersonalization` | `boolean` | search personalization 활성 여부. Lightning Experience only. API v47.0+. |
| `enablePersonalTagging` | `boolean` | 사용자가 여러 객체 레코드를 공통 테마로 묶을 수 있는지. personal tag는 해당 사용자에게만 보임. Salesforce Classic only. API v48.0+. |
| `enablePublicTagging` | `boolean` | 사용자가 여러 객체 레코드를 공통 테마로 묶을 수 있는지. (원문 설명: personal tag가 모든 사용자에게 보임.) Salesforce Classic only. API v48.0+. |
| `enableSalesforceGeneratedSynonyms` | `boolean` | search synonym 활성 여부. API v47.0+. |
| `enableSearchTermHistory` | `boolean` | 사용자가 여러 객체 레코드를 공통 테마로 묶을 수 있는지. (원문 설명: public tag가 org 전체에 보임.) Salesforce Classic only. API v48.0+. |
| `enableSetupSearch` | `boolean` | Setup sidebar의 검색 박스가 Enter 시 일치하는 custom field·custom object·기타 setup 항목을 반환하는지. Developer·Performance·Professional·Enterprise·Unlimited edition에선 기본 true, 그 외 false. API v47.0+. |
| `enableSuggestArticlesLinksOnly` | `boolean` | 현재 케이스와 유사한 케이스의 knowledge 아티클로 링크를 제공할지. API v48.0+. |
| `enableUseDefaultSearchEntity` | `boolean` | sidebar search에서 admin 지정 기본 entity 사용 여부. Salesforce Classic only. API v48.0+. |
| `optimizeSearchForCJKEnabled` | `boolean` | **Required.** 일본어·중국어·한국어 검색에 최적화 여부. sidebar search와 sidebar/global search의 lead 레코드 Find Duplicates의 account 검색에 영향. 주로 CJK로 검색하고 searchable field 텍스트가 CJK면 활성화. |
| `recentlyViewedUsersForBlankLookupEnabled` | `boolean` | **Required.** user autocomplete lookup·blank user lookup이 반환하는 레코드 목록을 사용자의 최근 본 user 레코드에서 가져올지(true). false면 org 전체의 최근 접근 user 레코드 목록. User 객체 blank lookup 검색에만 적용. |
| `searchSettingsByObject` | `SearchSettingsByObject` | **Required.** 각 객체의 검색 설정 목록. |
| `sidebarAutoCompleteEnabled` | `boolean` | **Required.** sidebar search에 autocomplete 활성 여부. 사용자가 search term 입력 시 최근 본 레코드 목록을 표시. |
| `sidebarDropDownListEnabled` | `boolean` | **Required.** sidebar search 섹션에 dropdown 목록 표시 여부. tag 내·특정 객체 내·모든 객체 검색을 선택 가능. |
| `sidebarLimitToItemsIOwnCheckboxEnabled` | `boolean` | **Required.** **Limit to Items I Own** 체크박스 표시 여부. sidebar 검색 시 레코드 소유자인 레코드만 포함하게 함. |
| `singleSearchResultShortcutEnabled` | `boolean` | **Required.** shortcut 활성 여부. 검색이 단일 item만 반환하면 결과 페이지를 건너뛰고 레코드 상세로 바로 이동. tag·case comment(advanced search)·global search에는 적용 안 됨. |
| `spellCorrectKnowledgeSearchEnabled` | `boolean` | **Required.** Knowledge 검색에 spell check 활성 여부. |

**서브타입 — SearchSettingsByObject:**

| Field Name | Field Type | Description |
|---|---|---|
| `searchSettingsByObject` | `ObjectSearchSetting` | 각 객체의 검색 설정 목록을 담음. |

**서브타입 — ObjectSearchSetting:** 각 객체의 검색 설정 목록.

| Field Name | Field Type | Description |
|---|---|---|
| `enhancedLookupEnabled` | `boolean` | **Required.** 객체에 enhanced lookup 활성 여부. |
| `lookupAutoCompleteEnabled` | `boolean` | **Required.** lookup search에 autocomplete 활성 여부. inline lookup field 편집 시 autosuggestion 선택. |
| `name` | `string` | **Required.** 구성 중인 객체의 entity 이름. |
| `resultsPerPageCount` | `int` | **Required.** 페이지당 검색 결과 수. |

**Declarative Metadata Sample Definition (SearchSettings):**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<SearchSettings xmlns="http://soap.sforce.com/2006/04/metadata">
    <enableSetupSearch>false</enableSetupSearch>
    <enableAdvancedSearchInAlohaSidebar>false</enableAdvancedSearchInAlohaSidebar>
    <enableQuerySuggestionPigOn>false</enableQuerySuggestionPigOn>
    <enableSalesforceGeneratedSynonyms>false</enableSalesforceGeneratedSynonyms>
    <enableSearchTermHistory>false</enableSearchTermHistory>
    <enablePublicTagging>false</enablePublicTagging>
    <enablePersonalTagging>false</enablePersonalTagging>
    <enableSuggestArticlesLinksOnly>false</enableSuggestArticlesLinksOnly>
    <enableUseDefaultSearchEntity>false</enableUseDefaultSearchEntity>
    <documentContentSearchEnabled>true</documentContentSearchEnabled>
    <optimizeSearchForCJKEnabled>true</optimizeSearchForCJKEnabled>
    <recentlyViewedUsersForBlankLookupEnabled>true</recentlyViewedUsersForBlankLookupEnabled>
    <searchSettingsByObject>
        <searchSettingsByObject>
            <enhancedLookupEnabled>false</enhancedLookupEnabled>
            <lookupAutoCompleteEnabled>false</lookupAutoCompleteEnabled>
            <name>Account</name>
            <resultsPerPageCount>25</resultsPerPageCount>
        </searchSettingsByObject>
        <searchSettingsByObject>
            <enhancedLookupEnabled>false</enhancedLookupEnabled>
            <lookupAutoCompleteEnabled>false</lookupAutoCompleteEnabled>
            <name>Activity</name>
            <resultsPerPageCount>25</resultsPerPageCount>
        </searchSettingsByObject>
        <searchSettingsByObject>
            <enhancedLookupEnabled>false</enhancedLookupEnabled>
            <lookupAutoCompleteEnabled>false</lookupAutoCompleteEnabled>
            <name>Asset</name>
            <resultsPerPageCount>25</resultsPerPageCount>
        </searchSettingsByObject>
    </searchSettingsByObject>
    <sidebarAutoCompleteEnabled>true</sidebarAutoCompleteEnabled>
    <sidebarDropDownListEnabled>true</sidebarDropDownListEnabled>
    <sidebarLimitToItemsIOwnCheckboxEnabled>true</sidebarLimitToItemsIOwnCheckboxEnabled>
    <singleSearchResultShortcutEnabled>true</singleSearchResultShortcutEnabled>
    <spellCorrectKnowledgeSearchEnabled>true</spellCorrectKnowledgeSearchEnabled>
    <enableEinsteinSearchPersonalization>true</enableEinsteinSearchPersonalization>
</SearchSettings>
```

> 예제의 `<enableQuerySuggestionPigOn>`은 위 Fields 표에 없는 field로, PDF 원문 예제에만 존재한다(원문 그대로 보존).

**Example Package Manifest:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>Search</members>
        <name>Settings</name>
    </types>
    <version>37.0</version>
</Package>
```

**Wildcard Support:** feature settings의 metadata 타입에는 wildcard `*`가 적용되지 않는다(모든 setting retrieve 시에만 적용).

---

## ⑧ SearchLayouts — 객체 검색 레이아웃 (custom v14.0+ / standard v27.0+)

객체의 search layout과 연결된 metadata. 검색 결과·검색 filter field·lookup dialog·탭 홈 페이지의 최근 레코드 목록에 표시할 field를 커스터마이즈한다. SearchLayouts는 이를 포함하는 CustomObject를 통해서만 접근할 수 있다.

**Version:** custom object의 search layout은 API v14.0+. standard object(event·task 제외)의 search layout 수정은 API v27.0+.

**Fields — 정의 시 주의사항(원문):**
- text 유형으로 정의된 Name field는 mandatory이며 검색 결과 페이지의 첫 컬럼으로 항상 표시된다. field 목록을 query하면 name field는 반환되지 않고 나머지 field는 모두 반환된다. Name field를 autonumber 유형으로 정의하면 mandatory가 아니라 목록에서 제거할 수 있으나, Metadata API로 search layout을 import하면 항상 Name field가 다시 추가된다. 이 규칙은 `customTabListAdditionalFields`, `lookupDialogsAdditionalFields`, `lookupPhoneDialogsAdditionalFields`, `searchResultsAdditionalFields`에 적용된다.
- custom object의 search layout은 field 이름(My Custom Field) 대신 API name(`MyCustomField__c`)을 쓴다.

**Fields (SearchLayouts):**

| Field | Field Type | Description |
|---|---|---|
| `customTabListAdditionalFields` | `string[]` | 객체의 Recent *Object Name* list view에 표시되는 field 목록. |
| `excludedStandardButtons` | `string[]` | search layout에서 제외된 standard button 목록. |
| `listViewButtons` | `string[]` | 객체의 list view에서 사용 가능한 button 목록. UI의 *Object Name* List View의 Buttons Displayed 값과 동일. |
| `lookupDialogsAdditionalFields` | `string[]` | 객체의 lookup dialog에 표시되는 field 목록. lookup search dialog는 편집 중인 레코드에 연관된 레코드 검색을 돕는다. lookup filter field로 custom field 목록으로 lookup 검색을 필터링할 수 있다. UI의 **Lookup Dialogs** related list와 동일. |
| `lookupFilterFields` | `string[]` | 객체의 enhanced lookup을 필터링하는 field 목록. enhanced lookup은 관리자가 선택적으로 활성화. UI의 **Lookup Filter Fields** related list와 동일. |
| `lookupPhoneDialogsAdditionalFields` | `string[]` | 객체의 lookup dialog에 표시되는 phone 관련 field 목록. softphone dial pad와 field 통합을 가능케 함. UI의 **Lookup Phone Dialogs** related list와 동일. |
| `massQuickActions` | `string[]` | 레코드에 mass quick action을 수행하는 action 목록. 기존 create/update action 추가에 사용. custom object와 quick action을 지원하고 Lightning Experience에 search layout이 있는 모든 standard object(case·lead·account·campaign·contact·opportunity·work order 등)에서 가능. |
| `searchFilterFields` | `string[]` | 객체 검색을 필터링하는 field 목록. UI의 **Search Filter Fields** related list와 동일. |
| `searchResultsAdditionalFields` | `string[]` | 객체의 검색 결과에 표시되는 field 목록. UI의 **Search Results** related list와 동일. |
| `searchResultsCustomButtons` | `string[]` | 객체의 검색 결과에 사용 가능한 custom button 목록. button에 연관된 action은 검색 결과 레코드에 적용 가능. |

**Declarative Metadata Sample Definition (SearchLayouts):**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
. . .
    <searchLayouts>
        <listViewButtons>New</listViewButtons>
        <listViewButtons>Accept</listViewButtons>
        <listViewButtons>ChangeOwner</listViewButtons>
        <lookupDialogsAdditionalFields>firstQuote__c</lookupDialogsAdditionalFields>
        <lookupDialogsAdditionalFields>finalQuote__c</lookupDialogsAdditionalFields>
        <massQuickActions>Create_MQA_Contact</massQuickActions>
        <searchResultsAdditionalFields>CREATEDBY_USER</searchResultsAdditionalFields>
    </searchLayouts>
. . .
</CustomObject>
```

**Wildcard Support:** 이 타입은 package.xml에서 wildcard `*`를 **지원하지 않는다**.

---

## ⑨ SynonymDictionary — 동의어 사전 (API v29.0+)

사용자 검색에서 동등하게 취급되는 단어·구의 group(synonym group) 집합. acronym·제품명 변형·조직 고유 용어에 대한 검색 결과를 최적화하는 데 쓴다. synonym은 Salesforce Knowledge 등 Service Cloud 기능에서 사용 가능. Metadata 타입을 확장하고 `fullName`을 상속.

**File Suffix and Directory Location:** 접미사 `.synonymDictionary`, `synonymDictionaries` 폴더에 저장.

**Special Access Rules:** org에 synonym이 활성화되어야 함. "Manage Synonyms" 권한 사용자만 접근 가능.

**Fields (SynonymDictionary):**

| Field Name | Field Type | Description |
|---|---|---|
| `groups` | `SynonymGroup` | 이 dictionary에 정의된 synonym group. |
| `isProtected` | `boolean` | 이 컴포넌트가 protected인지(true)/아닌지(false). protected 컴포넌트는 설치 org에서 만든 컴포넌트가 link/참조할 수 없음. |
| `label` | `string` | **Required.** synonym dictionary의 표시 이름. |

**서브타입 — SynonymGroup:** 동의어 단어·구의 group.

| Field Name | Field Type | Description |
|---|---|---|
| `languages` | `Language` | **Required.** synonym group이 적용되는 언어. 단일 언어에만 특정되면 그 언어만, 여러 언어면 한 group에 여러 언어 지정. |
| `terms` | `string` | **Required.** group 내 다른 term과 동의어인 단어·구. 최대 50자. group당 최소 2개 term. synonym group은 대칭적(symmetric)이라 oranges와 apples가 정의되면 oranges 검색이 apples를 매칭하고 그 반대도 성립. |

**Declarative Metadata Sample Definition (SynonymDictionary):**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<SynonymDictionary xmlns="http://soap.sforce.com/2006/04/metadata">
    <groups>
        <languages>en_US</languages>
        <terms>Salesforce</terms>
        <terms>salesforce.com</terms>
        <terms>The Customer Company</terms>
        <terms>SFDC</terms>
    </groups>
    <groups>
        <languages>fr</languages>
        <terms>renault</terms>
        <terms>clio</terms>
    </groups>
    <label>Sample Dictionary</label>
</SynonymDictionary>
```

예제 package.xml:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>Sample Dictionary</members>
        <name>SynonymDictionary</name>
    </types>
    <version></version>
</Package>
```

**Usage:** API v29.0 이전에 정의된 synonym group이 있으면, 기존 group은 `_Default`라는 기본 dictionary에 연관된다. 자주 갱신이 필요한 synonym set은 group 수가 적은 전용 dictionary에 할당하는 것을 권장. 기존 dictionary를 deploy할 때마다 모든 synonym group이 덮어쓰여진다. dictionary 내 단일 synonym group만 update하는 배포는 지원하지 않는다.

**Wildcard Support:** 이 타입은 wildcard `*`를 지원한다.

---

## ⑩ ExternalDataSource — 외부 데이터 소스 (API v28.0+)

external data source와 연결된 metadata. Salesforce org 외부에 저장된 데이터·콘텐츠와의 통합을 위한 연결 상세를 관리한다.

> **Note:** 이 entity에 저장된 모든 credential은 플랫폼의 다른 암호화 프레임워크와 일관된 프레임워크로 암호화된다. Salesforce는 org별 키를 자동 생성해 credential을 암호화한다. 이전 암호화 방식으로 암호화된 credential은 새 프레임워크로 마이그레이션된다.

Metadata 타입을 확장하고 `fullName`을 상속.

**File Suffix and Directory Location:** `dataSources` 디렉터리에 저장. 접미사 `.dataSource`, prefix는 external data source 이름.

**Special Access Rules:** Spring '20 이후로 인증된 internal·external 사용자만 이 타입에 접근 가능.

**Fields (ExternalDataSource):**

| Field Name | Field Type | Description |
|---|---|---|
| `authProvider` | `string` | AuthProvider 컴포넌트가 나타내는 authentication provider. |
| `certificate` | `string` | certificate를 지정하면 external 시스템과의 two-way SSL 연결마다 org가 제공. digital signature에 사용되어 요청이 org에서 옴을 검증. **Tip:** 최선의 성능을 위해 remote HTTPS 암호화 site에 OCSP stapling을 켤 것. |
| `customConfiguration` | `string` | external data source 유형에 특정한 구성 parameter 문자열. (Salesforce Connect—Cross-Org Adapter / OData 2.0·4.0 Adapter / Custom Adapter용 — 아래 참조) |
| `customHttpHeaders` | `CustomHttpHeaders[]` | OData 2.0/4.0 connector에 쓰는 custom HTTP header. API v43.0+. |
| `endpoint` | `string` | external 시스템의 URL, 또는 named credential에 정의된 경우 named credential URL. named credential URL은 `callout:` scheme, named credential 이름, 선택적 path를 담음. 예: `callout:My_Named_Credential/some_path`. `?`를 구분자로 query string을 붙일 수 있음. 예: `callout:My_Named_Credential/some_path?format=json`. |
| `externalDataSrcDescriptors` | `ExternalDataSrcDescriptors[]` | Amazon DynamoDB(API v55.0+)·Amazon Athena(API v56.0+)용 Salesforce Connect adapter의 schema descriptor. |
| `isWritable` | `boolean` | external data source에 연관된 external object에 대해 Lightning Platform과 org 사용자가 레코드를 create/update/delete하게 허용. 데이터는 org 외부 저장. 기본적으로 external object는 read-only. UI의 **Writable External Objects**와 대응. API v35.0+. 단 Salesforce Connect cross-org adapter는 API v39.0+에서만 true로 설정 가능. |
| `label` | `string` | external data source 이름. UI(list view 등)에 표시. 예: Acme Team Marketing Site, Acme SharePoint. |
| `namedCredential` | `string` | Amazon DynamoDB·Amazon Athena 유형 external data source의 참조 named credential 정의. |
| `oauthRefreshToken` | `string` | OAuth refresh token. token 만료 시 end user의 새 access token을 얻는 데 사용. |
| `oauthScope` | `string` | access token에 요청할 권한 scope. UI의 **Scope**와 대응. |
| `oauthToken` | `string` | external 시스템이 발급한 access token. |
| `password` | `string` | org가 external 시스템에 접근하는 데 쓰는 password. credential이 적절한 권한을 갖도록 함. |
| `principalType` | `ExternalPrincipalType` (enum of string) | 하나 또는 여러 credential set 사용 여부. UI의 **Identity Type**과 대응. 유효 값: **Anonymous**, **PerUser**, **NamedUser**. |
| `protocol` | `AuthenticationProtocol` (enum of string) | external 시스템 접근에 필요한 authentication protocol. 유효 값: **NoAuthentication**, **Oauth**, **Password**. 클라우드 기반 Files Connect는 Oauth 2.0, on-premises는 Password Authentication, Simple URL은 No Authentication 선택. |
| `repository` | `string` | SharePoint Online용. metadata 접근 불가 시 이 field로 table·기본 table field 생성. |
| `type` | `ExternalDataSourceType` (enum of string) | **Required.** Salesforce Connect에서 external 시스템에 연결하는 adapter. (유효 값 — 아래 참조) |
| `username` | `string` | org가 external 시스템에 접근하는 데 쓰는 user 이름. |
| `version` | `string` | 향후 사용 예약. |

### `type` 필드 — ExternalDataSourceType 전체 valid values

**For Salesforce Connect** (external 시스템 연결 adapter):
- `AmazonAthena` — Amazon Athena
- `AmazonDynamoDB` — Amazon DynamoDB
- `OData` — OData 2.0 adapter
- `OData4` — OData 4.0 adapter
- `SfdcOrg` — cross-org adapter
- `ApexClassId` — Apex Connector Framework로 만든 custom adapter를 정의하는 DataSource.Provider class

**For Files Connect** (data source 유형):
- `ContentHubSharepoint` — SharePoint 2010 or 2013
- `ContentHubSharepointOffice365` — SharePoint Online
- `ContentHubSharepointOneDrive` — OneDrive for Business
- `ContentHubGDrive` — Google Drive
- `ContenHubIsotope` — Isotope *(PDF 원문 철자 그대로 "ContenHub". 'tHub' 아님 — 오타 가능성 있으나 원문 보존)*

**If Chatter is enabled:**
- `SimpleURL` — 인증이 필요 없는 web server의 데이터 접근.
- `outgoingemail` — quick action으로 email을 보내는 data source.

**For Digital Lending Configurator:**
- `AFPPAttribute` — Application Form Product Proposal Attribute virtual object의 data source 이름.

**For federated search external data source type:**
- `OpenSearch`

**For Transaction Management in Revenue Cloud:**
- `ASPAttribute` — Asset State Period Attribute virtual object. API v63.0+.
- `OIAttribute` — Order Item Attribute virtual object. API v63.0+.
- `QLIAttribute` — Quote Line Item Attribute virtual object. API v63.0+.

**For SalesAgreement in Manufacturing Cloud:**
- `SAPAttribute` — SalesAgreement Product Attribute virtual object. API v60.0+.

**Reserved for internal use:**
- `AssetAttribute`, `ClaimAttributeDS`, `ClaimItemAttributeDS`, `CryptoTrEnvChgLogSnp`, `CtrtGrpPlnAttr`, `CtrtGrpPlnGrpClsAttr`, `FAAttribute`, `FLAttribute`, `IAItemProdtAttr`, `Identity`, `InsPolicyAttribute`, `IPAAttribute`, `IPCAttribute`, `IPCvrBnftAttribute`, `IPPAttribute`, `SdbOvenPODataSource`, `Wrapper`

**서브타입 — CustomHttpHeaders (API v43.0+):** OData 2.0/4.0 connector에 쓰는 custom HTTP header.

| Field Name | Field Type | Description |
|---|---|---|
| `description` | `string` | header field 목적의 text 설명. |
| `headerFieldName` | `string` | **Required.** header field 이름. 최소 하나의 영숫자 또는 underscore 포함. 아래 "headerFieldName 허용 특수문자" 참조의 문자도 가능. |
| `headerFieldValue` | `string` | **Required.** header 값으로 resolve되는 formula. 값은 string으로 평가되어야 함. formula가 null·empty string으로 resolve되면 header는 전송 안 됨. |
| `isActive` | `boolean` | custom HTTP header 사용 가능 여부(true)/불가(false). |

**headerFieldName 허용 특수문자** (PDF 원문 그대로):

```
! # $ % & ' * + - . ^ _ ` | ~
```

### customConfiguration 예제

**Salesforce Connect — Cross-Org Adapter** (type이 `SfdcOrg`일 때) JSON 인코딩 구성:

```json
{"apiVersion":"32.0","environment":"CUSTOM",
"searchEnabled":"true","timeout":"120"}
```
UI 대응: `apiVersion`—API Version / `environment`—Connect to / `searchEnabled`—Enable Search / `timeout`—Connection Timeout.

**Salesforce Connect — OData 2.0 or 4.0 Adapter** (type이 `OData`/`OData4`일 때):

```json
{"inlineCountEnabled":"true","csrfTokenName":"X-CSRF-Token",
"requestCompression":"false","pagination":"CLIENT",
"noIdMapping":"false","format":"ATOM",
"searchFunc":"","compatibility":"DEFAULT",
"csrfTokenEnabled":"true","timeout":"120",
"searchEnabled":"true"}
```
UI 대응: `compatibility`—Special Compatibility / `csrfTokenEnabled`—Cross-Site Request Forgery (CSRF) Protection / `csrfTokenName`—Anti-CSRF Token Name / `format`—Format / `inlineCountEnabled`—Request Row Counts / `noIdMapping`—High Data Volume / `pagination`—Server Driven Pagination / `requestCompression`—Compress Requests / `searchEnabled`—Enable Search / `searchFunc`—Custom Query Option for Salesforce Search / `timeout`—Connection Timeout.

**Salesforce Connect — Custom Adapter** (type이 `DataSource.Provider` class ID일 때):

```json
{"noIdMapping":"false"}
```
`noIdMapping` parameter는 UI의 **High Data Volume** field와 대응.

**Declarative Metadata Sample Definition: OData 2.0 or 4.0:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ExternalDataSource xmlns="http://soap.sforce.com/2006/04/metadata">
    <authProvider>FacebookAuth</authProvider>
    <customConfiguration>{"compatibility":"DEFAULT",
        "noIdMapping":"false","inlineCountEnabled":"true",
        "searchEnabled":"true","format":"ATOM",
        "requestCompression":"false","pagination":"SERVER",
        "timeout":"120"}</customConfiguration>
    <customHttpHeaders>
        <headerFieldName>X-User</headerFieldName>
        <headerFieldValue>$User.Username</headerFieldValue>
    </customHttpHeaders>
    <endpoint>http://myappname.herokuapp.com/DataHub.svc</endpoint>
    <label>DataHub</label>
    <principalType>NamedUser</principalType>
    <protocol>Oauth</protocol>
    <type>OData</type>
</ExternalDataSource>
```

**서브타입 — ExternalDataSrcDescriptors (Amazon DynamoDB·Amazon Athena용):** Salesforce Connect adapter의 schema descriptor. Amazon DynamoDB(API v55.0+)·Amazon Athena(API v56.0+)용.

| Field Name | Field Type | Description |
|---|---|---|
| `customObject` | `string` | 설정 시 descriptor에 연관된 external object. |
| `descriptor` | `string` | **Required.** metadata 정보를 담은 descriptor 문서. |
| `descriptorVersion` | `string` | external 시스템이 data source의 schema versioning을 지원하면, optional descriptor 문서 버전이 external 시스템의 schema 버전을 추적. 여러 버전의 descriptor가 활성일 수 있음. |
| `developerName` | `string` | **Required.** child-level setup entity의 고유 이름. |
| `externalDataSource` | `string` | **Required.** descriptor에 연관된 external data source 이름. |
| `subtype` | `ExternalDataSrcDescSubtype` (enum of string) | **Required.** descriptor의 subtype. 값: **SchemaTableMetadata**(external 시스템 정보 캐시), **SchemaTableQualifiers**(external 시스템에 대한 데이터 조회 query 커스터마이즈). |
| `systemVersion` | `int` | **Required.** descriptor 형식을 정의하고 Salesforce 릴리즈 간 descriptor 형식 호환성을 제공하는 버전. |
| `type` | `ExternalDataSrcDescType` (enum of string) | **Required.** descriptor의 유형. 유효 값: **Schema**. |

---

## 관련 노트

- [[Knowledge 데이터 모델 & API 개요]]
- [[Knowledge Metadata API 타입 — 아티클·채널·설정]]
- [[Knowledge REST API — Search & Support]]
- [[Metadata Types — Objects & Fields]]
- [[Metadata Types — Integration & Platform]]
