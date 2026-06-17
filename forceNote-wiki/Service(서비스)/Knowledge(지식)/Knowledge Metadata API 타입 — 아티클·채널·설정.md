---
tags: [Service, Knowledge, 지식, Metadata-API, ArticleType, ChannelLayout, KnowledgeSettings, CustomField, 아티클타입]
source: salesforce_knowledge_dev_guide.pdf (v67.0 Summer '26, Ch4 PDF p135–152)
created: 2026-06-17
aliases: [ArticleType, ArticleType Layout, ChannelLayout, ArticleType CustomField, KnowledgeSettings, Knowledge Metadata 타입, 아티클 타입 메타데이터, 채널 레이아웃, Knowledge 설정 메타데이터, suggestedArticles]
---

# Knowledge Metadata API 타입 — 아티클·채널·설정

> Salesforce Knowledge Metadata API의 5개 타입 — ArticleType(+Layout, +CustomField), ChannelLayout, KnowledgeSettings — 의 필드·서브타입·예제 XML을 전수 정리한다. 데이터 카테고리·검색·외부소스 타입은 [[Knowledge Metadata API 타입 — 데이터카테고리·검색·외부소스]] 참조.

---

## Metadata API 개요

Metadata API로 아티클·page layout·data category를 관리한다. 주 목적은 개발 과정에서 org 간 metadata를 옮기는 것이다. customization 정보(custom object 정의, page layout 등)를 deploy/retrieve/create/update/delete한다. Metadata API는 business data를 직접 다루지 않는다. 일반 정보는 *Metadata API Developer Guide* 참조. 이 노트의 타입들은 표준 Metadata API 타입(예: [[Metadata Types — Objects & Fields]])과 함께 쓰인다.

---

## ① ArticleType — article type과 연결된 메타데이터 (API v19.0+)

article type과 연결된 metadata를 나타낸다. Salesforce Knowledge의 모든 아티클은 article type에 할당된다. article type은 콘텐츠 유형·외관·접근 가능 사용자를 결정한다. article type 접근은 권한으로 제어되며, 관리자는 각 article type에 "Create"/"Read"/"Edit"/"Delete" 권한을 부여할 수 있다.

**File Suffix and Directory Location:** ArticleType은 custom object로 정의되어 `objects` 폴더에 저장. 접미사 `__kav`(custom object의 `__c` 대신). ArticleType field 이름은 다른 custom object처럼 `__c` 접미사를 가지며, 소속 article type 이름으로 dot-qualify해야 한다.

샘플 package.xml:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>articlefilemetadata</fullName>
    <apiAccessLevel>Unrestricted</apiAccessLevel>
    <types>
        <members>newarticle__kav.description__c</members>
        <name>CustomField</name>
    </types>
    <types>
        <members>newarticle__kav</members>
        <name>CustomObject</name>
    </types>
</Package>
```

**Fields (ArticleType):**

| Field Name | Field Type | Description |
|---|---|---|
| `articleTypeChannelDisplay` | `articleTypeChannelDisplay` | 채널별로 아티클을 표시하는 데 쓰는 article-type template. |
| `deploymentStatus` | `DeploymentStatus` (enum of string) | custom object/field의 배포 상태. 유효 값: **InDevelopment**, **Deployed**. |
| `description` | `string` | article type 설명. 최대 1000자. |
| `fields` | `CustomField[]` | article type의 하나 이상 field. |
| `gender` | `Gender` | 객체를 나타내는 명사의 성별. 단어가 성별에 따라 다르게 다뤄지는 언어용. |
| `label` | `string` | Salesforce UI 전반에서 객체를 나타내는 label. |
| `pluralLabel` | `string` | label 값의 복수형. |
| `startsWith` | `StartsWith` (enum of string) | 명사가 모음·자음·특수문자로 시작하는지 표시. 첫 글자에 따라 단어가 다르게 다뤄지는 언어용. 유효 값은 StartsWith 참조. |

**서브타입 — ArticleTypeChannelDisplay:** 채널별 article-type template을 결정. 별도 명시 없으면 모든 field는 createable·filterable·nillable.

| Field Name | Field Type | Description |
|---|---|---|
| `articleTypeTemplates` | `ArticleTypeTemplate[]` | 지정 채널에 적용되는 article-type template. |

**서브타입 — ArticleTypeTemplate:** 특정 채널의 article-type template 설정. 미지정 시 기본 template 적용.

| Field Name | Field Type | Description |
|---|---|---|
| `channel` | `string` | article-type template이 적용되는 채널: **AllChannels**(사용 가능한 모든 채널), **App**(Salesforce Knowledge의 Articles 탭), **Pkb**(public knowledge base), **Csp**(Customer Portal), **Prm**(partner portal). |
| `page` | `string` | custom article-type template으로 쓰는 custom Visualforce page 이름. template 값을 Page로 선택할 때 사용. |
| `template` | `string` | 지정 채널에 쓰는 article-type template: **Page**(custom Visualforce page. 이 값 지정 시 page field에 Visualforce page 이름도 설정), **Tab**(layout에서 정의한 section을 탭으로 표시), **Toc**(layout에서 정의한 section을 목차로 표시). |

**Declarative Metadata Sample Definition (ArticleType):**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <articleTypeChannelDisplay>
        <articleTypeTemplates>
            <channel>App</channel>
            <template>Tab</template>
        </articleTypeTemplates>
        <articleTypeTemplates>
            <channel>Prm</channel>
            <template>Tab</template>
        </articleTypeTemplates>
        <articleTypeTemplates>
            <channel>Csp</channel>
            <template>Tab</template>
        </articleTypeTemplates>
        <articleTypeTemplates>
            <channel>Pkb</channel>
            <template>Toc</template>
        </articleTypeTemplates>
    </articleTypeChannelDisplay>
    <deploymentStatus>Deployed</deploymentStatus>
    <description>Article type with custom fields</description>
    <fields>
        <fullName>description__c</fullName>
        <label>Description</label>
        <length>48</length>
        <type>Text</type>
    </fields>
    <label>newarticle</label>
    <pluralLabel>newarticles</pluralLabel>
</CustomObject>
```

**Wildcard Support:** 이 타입은 package.xml에서 wildcard `*`를 지원한다.

---

## ② ArticleType Layout — article type page layout (API v19.0+)

article type page layout과 연결된 metadata. layout은 사용자가 아티클 데이터 입력 시 보고 편집할 수 있는 field와, 아티클 조회 시 나타나는 section을 결정한다. 아티클 형식은 article-type template으로 정의된다. 각 article type은 layout이 하나뿐이지만, article type의 4개 채널마다 다른 template을 선택할 수 있다.

**File Suffix and Directory Location:** `layouts` 디렉터리에 저장. prefix는 article type API name과 일치. 확장자 `.layout`.

**Fields (ArticleType Layout):**

| Field Name | Field Type | Description |
|---|---|---|
| `layoutSections` | `LayoutSection[]` | 아티클 field를 담는 layout의 주 section. 여기 순서가 layout 순서를 결정. |

**서브타입 — LayoutSection:** ArticleType layout의 한 section.

| Field Name | Field Type | Description |
|---|---|---|
| `customLabel` | `boolean` | 이 section의 label이 custom인지 standard(built-in)인지. custom label은 임의 text이나 번역 필요. standard label은 사전 정의된 유효 값(예: 'System Information')을 가지며 자동 번역됨. |
| `label` | `string` | label. `customLabel` 플래그에 따라 standard 또는 custom. |
| `layoutColumns` | `LayoutColumn[]` | style에 따른 layout 컬럼. Salesforce Knowledge는 article type layout에서 한 컬럼만 지원. |
| `style` | `LayoutSectionStyle` (enum of string) | layout style. Salesforce Knowledge는 **OneColumn**(한 컬럼 페이지)만 지원. |

**서브타입 — LayoutColumn:** layout section 내 컬럼의 항목.

| Field Name | Field Type | Description |
|---|---|---|
| `layoutItems` | `LayoutItem[]` | 컬럼 내 개별 항목(위에서 아래 순서). |

**서브타입 — LayoutItem:** layout item을 정의하는 유효 값.

| Field Name | Field Type | Description |
|---|---|---|
| `field` | `string` | field 이름 reference. 예: `MyField__c`. |

**Declarative Metadata Sample Definition (ArticleType Layout):**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Layout xmlns="http://soap.sforce.com/2006/04/metadata">
    <layoutSections>
        <customLabel>true</customLabel>
        <label>Description</label>
        <layoutColumns>
            <layoutItems>
                <field>description__c</field>
            </layoutItems>
            <layoutItems>
                <field>dateTime__c</field>
            </layoutItems>
        </layoutColumns>
        <style>OneColumn</style>
    </layoutSections>
    <layoutSections>
        <label>Data Sheet</label>
        <layoutColumns>
            <layoutItems>
                <field>file__c</field>
            </layoutItems>
        </layoutColumns>
        <style>OneColumn</style>
    </layoutSections>
</Layout>
```

---

## ③ ChannelLayout — communication channel layout (API v32.0+)

communication channel layout과 연결된 metadata. 관리자가 아티클 콘텐츠를 communication channel(email publisher, Experience Builder site, social media publisher 등)에 inline으로 공유하게 한다. 각 channel에 대해 공유할 article type/record type field 목록을 만들고 field 순서를 커스터마이즈할 수 있다.

**File Suffix and Directory Location:** 접미사 `.channelLayout`, `channelLayouts` 폴더에 저장. prefix는 article type API name과 일치. Lightning Knowledge에선 prefix가 knowledge object의 API name과 일치해야 함.

**Fields (ChannelLayout):**

| Field Name | Field Type | Description |
|---|---|---|
| `doesExcludeFieldLabels` | `boolean` | 이 layout이 적용되는 channel에서 field label을 field 콘텐츠에서 제외할지(true)/안 할지(false). 기본 false(label 삽입). Lightning Knowledge 활성 시 API v48.0+. |
| `doesExcludeFiles` | `boolean` | 관련 파일을 email에서 제외할지(true)/첨부할지(false). 기본 false(첨부). Lightning Knowledge 활성 시 API v48.0+. |
| `enabledChannels` | `string[]` | 이 layout이 적용되는 channel. API v32.0~46.0에선 유일 유효 값 **Email**. Lightning Knowledge 활성 시 API v47.0+에선 **Chat**, **Messaging**, **Social** 추가. |
| `label` | `string` | **Required.** 이 구성의 label. |
| `layoutItems` | `ChannelLayoutItem[]` | layout에 담긴 아티클 field. 여기 순서가 field 순서를 결정. |
| `recordType` | `string` | channel layout이 적용되는 record type 이름. 기본은 primary record type. API v41.0+. |

**서브타입 — ChannelLayoutItem:**

| Field Name | Field Type | Description |
|---|---|---|
| `field` | `string` | **Required.** field 이름. 형식은 `ArticleTypeName.FieldName` 또는 Lightning Knowledge에선 `KnowledgeBaseName.FieldName`. |

**Declarative Metadata Sample Definition (ChannelLayout):**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ChannelLayout xmlns="http://soap.sforce.com/2006/04/metadata">
    <label>Layout for Email</label>
    <layoutItems>
        <field>Knowledge.Question</field>
    </layoutItems>
    <layoutItems>
        <field>Knowledge.Answer</field>
    </layoutItems>
    <enabledChannels>Email</enabledChannels>
    <enabledChannels>Social</enabledChannels>
    <enabledChannels>Chat</enabledChannels>
    <doesExcludeFiles>false</doesExcludeFiles>
    <doesExcludeFieldLabels>true</doesExcludeFieldLabels>
</ChannelLayout>
```

예제 package.xml:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>*</members>
        <name>ChannelLayout</name>
    </types>
    <version>41.0</version>
</Package>
```

---

## ④ ArticleType CustomField — article type custom field (API v19.0+)

article type custom field와 연결된 metadata. article type custom field 정의를 create/update/delete한다. 이 타입은 Metadata 타입을 확장하고 `fullName` field를 상속한다. create/update 시 항상 full name을 지정한다. 예: `MyArticleType__kav.MyCustomField__c`.

**File Suffix and Directory Location:** custom field는 article type의 일부로 정의된다. ArticleType field 이름은 `__c` 접미사를 가지며 소속 article type 이름으로 dot-qualify해야 한다.

**Retrieving Custom Fields:** 다음 package.xml 정의는 `objects/MyCustomObject__c.object`, `objects/Account.object`, `objects/MyArticleType__kav.object` 파일을 retrieve(각각 하나의 custom field 정의 포함):

```xml
<types>
    <members>MyCustomObject__c.MyCustomField__c</members>
    <members>Account.MyCustomAccountField__c</members>
    <members>MyArticleType__kav.MyOtherCustomField__c</members>
    <name>CustomField</name>
</types>
```

**Fields for ArticleType:** 별도 명시 없으면 모든 field는 createable·filterable·nillable.

> **Note:** knowledge validation rule을 만들면 오류는 항상 페이지 상단에 표시된다(field 옆에 추가해도 마찬가지). 따라서 작성자가 규칙을 만족하는 방법을 알 수 있게 오류를 서술적으로 작성하고, 어느 field가 오류를 내는지 식별한다. Salesforce Classic UI는 아티클의 field 수준 오류 메시지를 지원하지 않는다.

| Field Name | Field Type | Description |
|---|---|---|
| `defaultValue` | `string` | 지정 시 field의 기본값. API v48.0에서 deprecated. |
| `deleteConstraint` | `Metadata Field Types` (enum of string) | lookup 관계의 삭제 옵션. 유효 값: **Cascade**(lookup 레코드와 연관 lookup field 삭제), **Restrict**(lookup 관계에 있으면 레코드 삭제 방지), **SetNull**(기본값. lookup 레코드 삭제 시 lookup field clear). |
| `description` | `string` | field 설명. |
| `formula` | `string` | 지정 시 field의 formula. |
| `formulaTreatBlankAs` | `Metadata Field Types` (enum of string) | formula에서 blank 처리 방식. 유효 값: **BlankAsBlank**, **BlankAsZero**. |
| `fullName` | `string` | Metadata에서 상속. create/update/delete 시 지정해야 함. createMetadata() 예시 참조. null 불가. |
| `inlineHelpText` | `string` | field 수준 help의 콘텐츠. |
| `label` | `string` | field의 label. Title·UrlName·Summary 등 Article Type의 표준 field label은 update 불가. |
| `length` | `int` | field 길이. |
| `picklist` | `Picklist (Including Dependent Picklist)` | (Deprecated. API v37.0 이하에서만 사용. 이후엔 `valueSet` 사용.) 지정 시 field가 picklist이고 picklist 값·label을 열거. |
| `referenceTo` | `string` | 지정 시 이 field가 다른 객체에 대해 갖는 reference. |
| `relationshipLabel` | `string` | 관계의 label. |
| `relationshipName` | `string` | 지정 시 일대다 관계의 값. 예: YourObject에 관계를 가진 MyObject에서 관계 이름은 YourObjects. |
| `required` | `boolean` | 생성 시 값이 필요한지(true)/아닌지(false). |
| `type` | `FieldType` | **Required.** field 유형. 유효 값: **Checkbox**(v30.0+), **Currency**, **ArticleCurrency**, **Date**, **DateTime**, **Email**, **File**, **Formula**, **Html**, **Lookup**, **Number**, **Percent**, **Phone**, **Picklist**, **DependentPicklist**, **MultiselectPicklist**, **Text**, **TextArea**, **LongTextArea**, **URL**. |
| `visibleLines` | `int` | field에 표시되는 줄 수. |

**Declarative Metadata Sample Definition (ArticleType CustomField):**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <fields>
        <fullName>Comments__c</fullName>
        <description>add your comments about this object here</description>
        <label>Comments</label>
        <length>32000</length>
        <type>LongTextArea</type>
        <visibleLines>30</visibleLines>
    </fields>
</CustomObject>
```

---

## ⑤ KnowledgeSettings — Salesforce Knowledge 설정 (API v27.0+)

Salesforce Knowledge 설정을 관리하는 metadata. Metadata 타입을 확장하고 `fullName`을 상속. package manifest에서 모든 organization settings metadata 타입은 Settings 이름으로 접근한다.

**File Suffix and Directory Location:** 단일 파일 `Knowledge.settings`, `settings` 디렉터리에 저장. settings 컴포넌트당 하나만 존재.

**Fields (KnowledgeSettings):**

| Field Name | Field Type | Description |
|---|---|---|
| `answers` | `KnowledgeAnswerSettings` | Salesforce Knowledge와 Answers 설정. |
| `cases` | `KnowledgeCaseSettings` | Salesforce Knowledge와 Cases 설정. |
| `defaultLanguage` | `string` | **Required.** Salesforce Knowledge의 기본 언어. 언어 약어 사용(예: 미국 영어 en_US). |
| `enableChatterQuestionKBDeflection` | `boolean` | Chatter를 통한 case deflection 추적 활성 여부. |
| `enableCreateEditOnArticlesTab` | `boolean` | Articles 탭에서 아티클 create·edit 가능 여부. |
| `enableExternalMediaContent` | `boolean` | 외부 미디어 연결 활성 여부. |
| `enableKbStandardSharing` | `boolean` | 표준 Salesforce sharing 활성 여부. |
| `enableKnowledge` | `boolean` | Salesforce Knowledge 활성 여부. 기본 false. |
| `enableKnowledgeAgentContribution` | `boolean` | 사용자가 케이스에서 아티클을 만들 수 있는지. (Classic only) |
| `enableKnowledgeArticleTextHighlights` | `boolean` | 검색 결과의 text snippet highlight 활성 여부. 기본 true. API v47.0+. |
| `enableKnowledgeAnswersPromotion` | `boolean` | 사용자가 reply에서 아티클을 만들 수 있는지. (Classic Only) |
| `enableKnowledgeCaseRL` | `boolean` | 아티클에 연결된 case 목록 생성 활성 여부. (Classic Only) |
| `enableKnowledgeKeywordAutoComplete` | `boolean` | Knowledge 검색 시 keyword auto-complete 활성 여부. 기본 true. API v47.0+. |
| `enableKnowledgeTitleAutoComplete` | `boolean` | Knowledge 검색 시 아티클 title auto-complete 활성 여부. 기본 true. API v47.0+. |
| `enableLightningKbAutoLoadRichTextField` | `boolean` | Lightning Knowledge에서 아티클 로드 시 rich text field 편집 활성 여부. 기본 false. API v47.0+. |
| `enableLightningKnowledge` | `boolean` | Lightning Knowledge 활성 여부. |
| `languages` | `KnowledgeLanguageSettings` | Salesforce Knowledge에 활성화된 언어 목록. |
| `showArticleSummariesCustomerPortal` | `boolean` | Customer Portal에 아티클 요약 표시 여부. |
| `showArticleSummariesInternalApp` | `boolean` | internal knowledge base에 아티클 요약 표시 여부. |
| `showArticleSummariesPartnerPortal` | `boolean` | partner portal에 아티클 요약 표시 여부. |
| `showValidationStatusField` | `boolean` | 아티클에 validation status 표시 여부. |
| `suggestedArticles` | `KnowledgeSuggestedArticlesSettings` | 케이스에 아티클을 제안하는 케이스 field 설정. API v37.0+. |
| `votingEnabled` | `boolean` | true면 Vote를 쓰는 제품·기능(예: Knowledge의 Articles)에 사용자가 투표 가능. API v50.0+. |

**서브타입 — KnowledgeAnswerSettings:**

| Field Name | Field Type | Description |
|---|---|---|
| `assignTo` | `string` | Answers에서 아티클이 할당될 username. |
| `defaultArticleType` | `string` | Answers에서 만든 아티클의 기본 article type. article type의 API name 사용. |
| `enableArticleCreation` | `boolean` | Answers에서 아티클 create 가능 여부. |

**서브타입 — KnowledgeCaseSettings:**

| Field Name | Field Type | Description |
|---|---|---|
| `articlePDFCreationProfile` | `string` | Cases에서 아티클 PDF 생성에 쓰는 profile. |
| `articlePublicSharingSites` | `KnowledgeSitesSettings` | Salesforce Knowledge와 Sites 설정. |
| `articlePublicSharingCommunities` | `KnowledgeSitesSettings` | Salesforce Knowledge와 Experience Cloud sites 설정. |
| `articlePublicSharingSitesChatterAnswers` | `KnowledgeSitesSettings` | Chatter Answers가 있는 Sites 설정. |
| `assignTo` | `string` | Cases에서 아티클이 할당될 username. |
| `customizationClass` | `string` | customization에 쓰는 Apex class. |
| `defaultContributionArticleType` | `string` | Cases에서 만든 아티클의 기본 article type. |
| `editor` | `KnowledgeCaseEditor` (enum of string) | rich text editor 유형. 유효 값: **simple**, **standard**. |
| `enableArticleCreation` | `boolean` | Cases에서 아티클 create 가능 여부. KnowledgeCaseSettings의 다른 field 설정 가능 여부를 제어. |
| `enableArticlePublicSharingSites` | `boolean` | Cases에서 public site(URL)로 아티클 공유 가능 여부. |
| `enableCaseDataCategoryMapping` | `boolean` | Case Data Category mapping 활성 여부. |
| `useProfileForPDFCreation` | `boolean` | Cases에서 아티클 PDF 생성에 profile 사용 여부. |

**서브타입 — KnowledgeSitesSettings:**

| Field Name | Field Type | Description |
|---|---|---|
| `site` | `string[]` | Salesforce Knowledge와 Sites에 쓰는 site. |

**서브타입 — KnowledgeLanguageSettings (API v28.0+):**

| Field Name | Field Type | Description |
|---|---|---|
| `language` | `KnowledgeLanguage[]` | Salesforce Knowledge에 활성화된 언어 설정. |

**서브타입 — KnowledgeLanguage (API v28.0+):**

| Field Name | Field Type | Description |
|---|---|---|
| `active` | `boolean` | 언어 활성 여부. |
| `defaultAssignee` | `string` | 해당 언어 아티클의 기본 assignee. |
| `defaultAssigneeType` | `KnowledgeLanguageLookupValueType` (enum of string) | 기본 assignee 유형. 유효 값: **User**, **Queue**. |
| `defaultReviewer` | `string` | 해당 언어 아티클의 기본 reviewer. |
| `defaultReviewerType` | `KnowledgeLanguageLookupValueType` (enum of string) | 기본 reviewer 유형. 유효 값: **User**, **Queue**. |
| `name` | `string` | 언어 코드(예: English는 en). 지원 언어·코드 목록은 Salesforce Help 참조. |

**서브타입 — KnowledgeSuggestedArticlesSettings:** 케이스·work order·work order line item에 제안되는 아티클 설정. 연관 field 사용을 위해 org에 Work Order·Work Order Line Item 객체가 활성화되어야 한다.

| Field Name | Field Type | Description |
|---|---|---|
| `caseFields` | `KnowledgeCaseFieldsSettings` | 케이스에 아티클을 제안하는 케이스 field 목록. |
| `useSuggestedArticlesForCase` | `boolean` | 케이스 콘텐츠로 아티클을 제안할지 여부. |
| `workOrderFields` | `KnowledgeWorkOrderFieldsSettings` | work order에 아티클을 제안하는 work order field 목록. |
| `workOrderLineItemFields` | `KnowledgeWorkOrderLineItemFieldsSettings` | work order line item에 아티클을 제안하는 field 목록. |

**서브타입 — KnowledgeCaseFieldsSettings (API v37.0+):**

| Field Name | Field Type | Description |
|---|---|---|
| `field` | `KnowledgeCaseField[]` | 케이스에 아티클을 제안하는 케이스 field 이름. |

**서브타입 — KnowledgeCaseField (API v37.0+):**

| Field Name | Field Type | Description |
|---|---|---|
| `name` | `string` | 케이스에 아티클을 제안하는 케이스 field 이름. |

**서브타입 — KnowledgeWorkOrderFieldsSettings (API v39.0+):**

| Field Name | Field Type | Description |
|---|---|---|
| `field` | `KnowledgeWorkOrderField[]` | work order에 아티클을 제안하는 work order field 이름. |

**서브타입 — KnowledgeWorkOrderField (API v39.0+):**

| Field Name | Field Type | Description |
|---|---|---|
| `name` | `string` | work order에 아티클을 제안하는 work order field 이름. |

**서브타입 — KnowledgeWorkOrderLineItemFieldsSettings (API v39.0+):**

| Field Name | Field Type | Description |
|---|---|---|
| `field` | `KnowledgeWorkOrderLineItemField[]` | work order line item에 아티클을 제안하는 field 이름. |

**서브타입 — KnowledgeWorkOrderLineItemField (API v39.0+):**

| Field Name | Field Type | Description |
|---|---|---|
| `name` | `string` | work order line item에 아티클을 제안하는 field 이름. |

**Declarative Metadata Sample Definition (KnowledgeSettings):**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<KnowledgeSettings xmlns="http://soap.sforce.com/2006/04/metadata">
    <answers>
        <enableArticleCreation>false</enableArticleCreation>
    </answers>
    <cases>
        <articlePDFCreationProfile>partner portal knowledge
            profile</articlePDFCreationProfile>
        <articlePublicSharingSites>
            <site>KnowledgeSite</site>
            <site>PKB2Site</site>
            <site>ChatterAnswersSite</site>
        </articlePublicSharingSites>
        <articlePublicSharingSitesChatterAnswers>
            <site>ChatterAnswersSite</site>
        </articlePublicSharingSitesChatterAnswers>
        <assignTo>testall@kb.org</assignTo>
        <defaultContributionArticleType>Support</defaultContributionArticleType>
        <editor>simple</editor>
        <enableArticleCreation>true</enableArticleCreation>
        <enableArticlePublicSharingSites>true</enableArticlePublicSharingSites>
        <useProfileForPDFCreation>true</useProfileForPDFCreation>
    </cases>
    <defaultLanguage>ja</defaultLanguage>
    <enableCreateEditOnArticlesTab>true</enableCreateEditOnArticlesTab>
    <enableExternalMediaContent>true</enableExternalMediaContent>
    <enableKnowledge>true</enableKnowledge>
    <showArticleSummariesCustomerPortal>true</showArticleSummariesCustomerPortal>
    <showArticleSummariesInternalApp>true</showArticleSummariesInternalApp>
    <showArticleSummariesPartnerPortal>true</showArticleSummariesPartnerPortal>
    <showValidationStatusField>true</showValidationStatusField>
    <suggestedArticles>
        <caseFields>
            <field>
                <name>Subject</name>
            </field>
            <field>
                <name>SuppliedEmail</name>
            </field>
        </caseFields>
        <useSuggestedArticlesForCase>true</useSuggestedArticlesForCase>
    </suggestedArticles>
</KnowledgeSettings>
```

**Wildcard Support:** feature settings의 metadata 타입에는 wildcard `*`가 적용되지 않는다. wildcard는 개별 setting이 아니라 모든 setting을 retrieve할 때만 적용된다.

---

## 관련 노트

- [[Knowledge 데이터 모델 & API 개요]]
- [[Knowledge Metadata API 타입 — 데이터카테고리·검색·외부소스]]
- [[Knowledge SOAP API 객체 — 핵심 아티클 객체]]
- [[Metadata Types — Objects & Fields]]
- [[Metadata Types — Integration & Platform]]
