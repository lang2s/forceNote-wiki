---
tags: [tooling-api, devops, schema, entity, field, formula]
source: api_tooling.pdf v67.0 (Summer '26)
created: 2026-06-27
aliases: [EntityDefinition, FieldDefinition, EntityParticle, EntityLimit, CustomField, CustomFieldDisplay, CustomFieldMember, CustomObject, DataType, RecordType, RelationshipDomain, RelationshipInfo, ObjectHierarchyRelationship, LookupFilter, FieldSet, GlobalValueSet, FieldMapping, FieldMappingField, FieldMappingRow, FormulaFunction, FormulaFunctionAllowedType, FormulaOperator, Index, IndexField, OwnerChangeOptionInfo, EnrichedField, BusinessProcessDefinition, ServiceFieldDataType, 스키마 메타데이터, 엔티티 정의, 필드 정의, 행 기반 스키마, 룩업 필터, 글로벌 값 집합, 수식 함수]
---

# Tooling API 객체 — Entity·Field·스키마

> 표준/커스텀 객체와 필드에 행 기반(row-based)으로 접근하는 스키마 메타데이터 sObject 28종 전수 — EntityDefinition·FieldDefinition·EntityParticle을 중심으로 커스텀 필드·레코드 타입·관계·룩업 필터·수식 함수·인덱스까지 SOQL로 조회한다.

이 노트는 Tooling API Reference & Developer Guide v67.0(Summer '26)의 "Tooling API Objects" 챕터 중 **Entity·Field·스키마 도메인 28객체**를 다룬다. 이 군은 org의 스키마(객체·필드·관계·레코드 타입·수식)에 대한 **메타데이터를 SOQL/SOSL로 행 단위 조회**하는 Tooling sObject다. 대부분 읽기 전용에 가깝고(`query()` 중심), `EntityDefinition`/`FieldDefinition`/`EntityParticle`은 `describe` 호출을 SOQL로 대체할 수 있게 해준다.

> [!important] Tooling sObject ≠ Metadata API 동명 타입 (경계)
> `CustomField`·`CustomObject`·`RecordType`·`FieldSet`·`GlobalValueSet`·`LookupFilter` 등은 **Tooling API의 SOQL 가능 sObject**다. Metadata API에는 같은 이름의 **declarative metadata 타입**이 따로 있고, 필드 구성·용법이 다르다(전자는 행 기반 조회용, 후자는 파일 기반 배포용). Metadata API 타입 카탈로그는 [[Metadata Types — Objects & Fields]] 참조. 여기 등장하는 `Metadata` 필드(예: `EntityDefinition.Metadata = mns: CustomObject`)는 해당 sObject 안에서 Metadata 네임스페이스(mns)의 복합 타입을 노출하는 통로다.

> [!note] 도메인 경계 — 다른 노트 소관
> - **EnrichedField** 는 Change Data Capture Enrichment 객체다. CDC 채널·헤더 메커니즘은 [[ChangeEventHeader]] 참조(이 노트는 EnrichedField sObject의 필드·SOQL만 다룬다).
> - **BusinessProcessDefinition** 은 고객 라이프사이클 맵(customer lifecycle / 세일즈 프로세스)의 stage를 나타내는 객체로, 스키마 도메인에 포함해 전수한다.
> - Apex 코드·테스트 군은 [[Tooling API 객체 — Apex 코드·테스트·커버리지]], 전체 그림·REST/SOAP 호출 기초는 [[Tooling API — 개요·REST·SOAP 호출 기초]], 객체↔네임스페이스 분류는 [[Tooling API — Objects and Namespaces (객체 분류)]].

> 표기 규약: `ManageableState enumerated list` 의 가능 값은 모든 객체 공통으로 `beta`, `deleted`, `deprecated`, `deprecatedEditable`, `installed`, `installedEditable`, `released`, `unmanaged` 8종이다(아래 표에서는 "ManageableState 8값"으로 축약).

---

## 객체 빠른 색인

| 객체 | 분류 | 필드 수 | API 최소 버전 |
|---|---|---|---|
| [BusinessProcessDefinition](#businessprocessdefinition) | 라이프사이클 | 6 | 51.0 |
| [CustomField](#customfield) | 커스텀 필드 | 5 | 28.0 |
| [CustomFieldDisplay](#customfielddisplay) | 커스텀 필드 표시 | 7 | 63.0 |
| [CustomFieldMember](#customfieldmember) | 필드 워킹카피 | 6 | 33.0 |
| [CustomObject](#customobject) | 커스텀 객체 | 9 | 31.0 |
| [DataType](#datatype) | 데이터 타입 | 5 | 34.0 |
| [EnrichedField](#enrichedfield) | CDC enrichment | 3 | 51.0 |
| [EntityDefinition](#entitydefinition) | 엔티티 정의(대형) | 86 (+서브) | 32.0 |
| [EntityLimit](#entitylimit) | 엔티티 한도 | 7 | 34.0 |
| [EntityParticle](#entityparticle) | 필드 입자(대형) | 54 (+서브) | 34.0 |
| [FieldDefinition](#fielddefinition) | 필드 정의(대형) | 59 (+서브) | 32.0 |
| [FieldMapping](#fieldmapping) | 필드 매핑 | 5 | 38.0 |
| [FieldMappingField](#fieldmappingfield) | 매핑 필드 | 4 | 38.0 |
| [FieldMappingRow](#fieldmappingrow) | 매핑 행 | 4 | 38.0 |
| [FieldSet](#fieldset) | 필드 셋 | 5 | 33.0 |
| [FormulaFunction](#formulafunction) | 수식 함수 | 11 (+서브) | 39.0 |
| [FormulaFunctionAllowedType](#formulafunctionallowedtype) | 수식 함수 컨텍스트 | 3 | 48.0 |
| [FormulaOperator](#formulaoperator) | 수식 연산자 | 4 | 39.0 |
| [GlobalValueSet](#globalvalueset) | 글로벌 값 집합 | 5 (+서브) | 39.0 |
| [Index](#index) | 빅오브젝트 인덱스 | 7 | 41.0 |
| [IndexField](#indexfield) | 인덱스 필드 | 6 | 41.0 |
| [LookupFilter](#lookupfilter) | 룩업 필터 | 12 (+서브) | 34.0 |
| [ObjectHierarchyRelationship](#objecthierarchyrelationship) | 객체 계층 매핑 | 12 | 56.0 |
| [OwnerChangeOptionInfo](#ownerchangeoptioninfo) | 소유자 변경 옵션 | 8 | 35.0 |
| [RecordType](#recordtype) | 레코드 타입 | 10 | 32.0 |
| [RelationshipDomain](#relationshipdomain) | 관계 도메인 | 14 | 34.0 |
| [RelationshipInfo](#relationshipinfo) | 관계 정보 | 10 | 34.0 |
| [ServiceFieldDataType](#servicefielddatatype) | (제거됨) | — | 34.0 deprecated / 58.0 제거 |

---

## 스키마 코어 — 엔티티·필드·입자

> `EntityDefinition`(객체) ↔ `FieldDefinition`(Metadata API의 Field와 동등) ↔ `EntityParticle`(UI에 표시되는 필드 요소, describe와 동등)은 서로 보완 관계다. `EntityParticle`/`FieldDefinition`를 쿼리할 때는 반드시 `WHERE EntityDefinition.QualifiedApiName = '[ObjectAPIName]'` 구문으로 필터링해야 한다.

### EntityDefinition

표준·커스텀 객체의 메타데이터에 **행 기반(row-based)** 으로 접근한다. API 32.0 이상.

> Important: 비포용적(noninclusive) 용어를 회사 가치(Equality)에 맞춰 변경했으나, 코드 변경이 기존 구현을 깨뜨릴 수 있어 이 객체의 이름은 유지했다.

> Note: EntityDefinition 필드는 SOAP API 45.0 이상에서 노출된다. API 44.0 이하에서는 게스트 유저 모드로 Tooling API를 통해 EntityDefinition 필드를 쿼리할 수 있다. 45.0 이상에서는 게스트 유저 모드에서 이 데이터를 얻으려면 SOAP API를 쓴다. ViewSetup 권한이 있는 User Profile에는 여전히 Tooling API로 노출된다.

- **Supported SOAP Calls:** `query()`, `search()`
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOQL Limitations / SOSL Limitations ([[Tooling API — Objects and Namespaces (객체 분류)]] 참조)

| Field | Type | Properties | Description |
|---|---|---|---|
| ApexTriggers | QueryResult | Filter, Group, Nillable, Sort | 이 객체와 연결된 Apex 트리거. Tooling API 34.0 이상. 관계 필드이므로 서브쿼리에서만 사용. |
| AssignmentRules | QueryResult | Filter, Group, Nillable, Sort | 케이스를 적절한 유저/큐로 자동 라우팅하는 할당 규칙. Tooling API 34.0 이상. 서브쿼리 전용. |
| AutoResponseRules | QueryResult | Filter, Group, Nillable, Sort | 객체에 정의된 자동 응답 규칙. Tooling API 34.0 이상. 서브쿼리 전용. |
| BusinessProcesses | QueryResult | Filter, Group, Nillable, Sort | 객체에 정의된 비즈니스 프로세스. 프로필·레코드 타입에 따라 다른 picklist 값을 표시한다. Tooling API 34.0 이상. 서브쿼리 전용. |
| ChildRelationships | QueryResult | Filter, Group, Nillable, Sort | 객체에 정의된 자식 관계. Tooling API 34.0 이상. 서브쿼리 전용. |
| CompactLayouts | QueryResult | Filter, Group, Nillable, Sort | 객체에 정의된 compact layout. Tooling API 34.0 이상. 서브쿼리 전용. |
| CustomFields | QueryResult | Filter, Group, Nillable, Sort | 객체에 정의된 커스텀 필드. Tooling API 34.0 이상. 서브쿼리 전용. |
| DefaultCompactLayout | CompactLayoutInfo | Create, Nillable, Update | 이 객체의 기본 compact layout에 대한 메타데이터(있는 경우). |
| DefaultCompactLayoutId | string | Filter, Group, Nillable, Sort | 기본 compact layout의 ID(있는 경우). |
| DefaultImplementation | string | Filter, Group, Nillable, Sort | Reserved for future use. |
| DeploymentStatus | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 객체의 배포 상태. 커스텀 객체와 연관 탭·관련 목록·리포트가 비관리자 유저에게 보이는지 제어. Tooling API 37.0 이상. 값: `InDevelopment`, `Deployed`. |
| Description | string | Filter, Nillable, Sort | 객체 설명. 목록에서 커스텀 객체를 구분하기 쉽게 한다. Tooling API 37.0 이상. |
| DetailUrl | string | Filter, Group, Nillable, Sort | 이 객체의 읽기 전용 상세 페이지 URL. DescribeSobjectResult의 urlDetail에 대응. Tooling API 34.0 이상. |
| DeveloperName | string | Filter, Group, Nillable, Sort | 객체의 개발자 내부 이름. **고유하지 않다** — 이 필드로 쿼리하면 동일 DeveloperName(예: Account)을 가진 표준 객체·커스텀 객체·패키지 커스텀 객체가 여러 건 반환될 수 있다. 고유 식별이 필요하면 QualifiedApiName 사용. |
| DurableId | string | Filter, Group, Nillable, Sort | 필드의 고유 식별자. 릴리스 간 동일 보장이 없으므로 사용 전 항상 조회. 다중 쿼리 대신 이 필드로 쿼리를 단순화. |
| EditDefinitionUrl | string | Filter, Group, Nillable, Sort | Tooling API 34.0 이상. |
| EditUrl | string | Filter, Group, Nillable, Sort | 커스텀 객체 정의 편집 시 사용하는 URL. DescribeSobjectResult의 urlEdit에 대응. Tooling API 34.0 이상. |
| ExtendedBy | string | Filter, Group, Nillable, Sort | Reserved for future use. |
| ExtendsInterfaces | string | Filter, Group, Nillable, Sort | Reserved for future use. |
| ExternalSharingModel | picklist | Filter, Group, Restricted picklist, Sort | 외부 공유 모델. 값: `None`, `Read`, `Edit`, `ControlledByLeadOrContact`, `ControlledByCampaign`. Tooling API 38.0 이상. |
| FieldSets | QueryResult | Filter, Group, Nillable, Sort | 객체에 정의된 field set. 관계 필드이므로 서브쿼리 전용. |
| Fields | QueryResult | Filter, Group, Nillable, Sort | 이 객체에 정의된 표준·커스텀 필드. 관계 필드이므로 서브쿼리 전용. |
| FormulaVariables | QueryResult | Filter, Group, Nillable, Sort | 이 객체에 빌드된 수식. Tooling API 48.0 이상. |
| FullName | string | Create, Group, Nillable | 객체 이름. 필드인 경우 부모 객체를 명시해야 한다(예: `Account.FirstName`). 쿼리 결과가 1건 이하일 때만 쿼리(아니면 에러). 다건이면 다중 쿼리로 조회 — 성능 보호용 제한. |
| HelpSettingPageName | string | Filter, Group, Nillable, Sort | 커스텀 help 설정 페이지 이름. Tooling API 34.0 이상. |
| HelpSettingPageUrl | string | Filter, Group, Nillable, Sort | 커스텀 객체의 커스텀 help 설정 페이지 URL. Tooling API 34.0 이상. |
| ImplementedBy | string | Filter, Group, Nillable, Sort | Reserved for future use. |
| ImplementsInterfaces | string | Filter, Group, Nillable, Sort | Reserved for future use. |
| InternalSharingModel | picklist | Filter, Group, Restricted picklist, Sort | 내부 공유 모델. 값: `None`, `Read`, `Edit`, `ControlledByLeadOrContact`, `ControlledByCampaign`. Tooling API 38.0 이상. |
| IsActivityTrackable | boolean | Defaulted on create, Filter, Group, Sort | true면 커스텀 객체에 연관된 활동(task·예약 캘린더 이벤트)을 추적 가능. 커스텀 객체에만 활성화 가능. Tooling API 37.0 이상. |
| IsApexTriggerable | boolean | Defaulted on create, Filter, Group, Sort | true면 객체에 Apex 트리거를 정의할 수 있다. |
| IsAutoActivityCaptureEnabled | boolean | Defaulted on create, Filter, Group, Sort | true면 Einstein Activity Capture가 활성화된 객체. Tooling API 41.0 이상. |
| IsCompactLayoutable | boolean | Defaulted on create, Filter, Group, Sort | true면 compact layout을 지원(정의 가능, 시스템 compact layout 합성 가능, 또는 둘 다). |
| IsCreatable | boolean | Defaulted on create, Filter, Group, Sort | true면 객체 기반 레코드를 생성할 수 있다. **35.0부터 사용 불가** — 대신 UserEntityAccess의 IsCreatable 사용. |
| IsCustomSetting | boolean | Defaulted on create, Filter, Group, Sort | true면 객체가 custom setting. Tooling API 35.0 이상. |
| IsCustomizable | boolean | Defaulted on create, Filter, Group, Sort | true면 객체에 커스텀 필드를 정의할 수 있다. |
| IsDeletable | boolean | Defaulted on create, Filter, Group, Sort | true면 객체 삭제 가능. **35.0부터 사용 불가** — 대신 UserEntityAccess의 IsDeletable 사용. |
| IsDeprecatedAndHidden | boolean | Defaulted on create, Filter, Group, Sort | true면 현재 버전에서 사용 불가. Tooling API 35.0 이상. |
| IsEverCreatable | boolean | Defaulted on create, Filter, Group, Sort | true면 (적절한 권한 전제) API로 객체 생성 가능. false면 앱 서버가 객체를 관리하며 누구도 생성 불가. Tooling API 35.0 이상. |
| IsEverDeletable | boolean | Defaulted on create, Filter, Group, Sort | true면 (권한 전제) API로 생성 가능. false면 앱 서버가 관리하며 누구도 삭제 불가. Tooling API 35.0 이상. *(원문 description은 "created"로 적혀 있으나 의미상 deletable. 원문 보존)* |
| IsEverUpdatable | boolean | Defaulted on create, Filter, Group, Sort | true면 (권한 전제) API로 생성 가능. false면 앱 서버가 관리하며 누구도 수정 불가. Tooling API 35.0 이상. *(원문 description은 "created"로 적혀 있으나 의미상 updatable. 원문 보존)* |
| IsFeedEnabled | boolean | Defaulted on create, Filter, Group, Sort | true면 이 객체에 Chatter feed 활성화. Tooling API 34.0 이상. |
| IsFieldHistoryTracked | boolean | Defaulted on create, Filter, Group, Sort | true면 커스텀 객체 레코드의 필드 변경 추적. 리포팅용 이력 데이터 제공. 커스텀 객체에만 활성화 가능. Tooling API 37.0 이상. |
| IsFlsEnabled | boolean | Defaulted on create, Filter, Group, Sort | true면 해당 필드에 field-level security 설정 가능. Tooling API 35.0 이상. |
| IsIdEnabled | boolean | Defaulted on create, Filter, Group, Sort | true면 이 객체 쿼리의 SELECT 절에 Id 포함 가능. Tooling API 35.0 이상. 예: High Data Volume 옵션이 선택된 OData 데이터 소스 기반 객체의 IsIdEnabled는 false. |
| IsInterface | boolean | Defaulted on create, Filter, Group, Sort | Reserved for future use. |
| IsLayoutable | boolean | Defaulted on create, Filter, Group, Sort | true면 객체에 layout 정의 가능. Tooling API 35.0 이상. |
| IsMruEnabled | boolean | Defaulted on create, Filter, Group, Sort | true면 이 객체에 MRU(Most Recently Used) 목록 기능 활성화. Tooling API 37.0 이상. |
| IsQueryable | boolean | Defaulted on create, Filter, Group, Sort | true면 객체를 쿼리할 수 있다. |
| IsReplicateable | boolean | Defaulted on create, Filter, Group, Sort | true면 객체를 복제 가능. Tooling API 35.0 이상. |
| IsReportingEnabled | boolean | Defaulted on create, Filter, Group, Sort | true면 커스텀 객체 레코드 데이터를 리포팅에 사용 가능. 커스텀 객체에만 활성화 가능. Tooling API 37.0 이상. |
| IsRetrieveable | boolean | Defaulted on create, Filter, Group, Sort | true면 객체를 retrieve 가능. Tooling API 35.0 이상. |
| IsSearchable | boolean | Defaulted on create, Filter, Group, Sort | true면 이 객체 레코드가 검색용으로 인덱싱됨. Tooling API 35.0 이상. |
| IsSearchLayoutable | boolean | Defaulted on create, Filter, Group, Sort | true면 이 객체의 검색 layout을 커스터마이징 가능. Tooling API 35.0 이상. |
| IsTriggerable | boolean | Defaulted on create, Filter, Group, Sort | true면 이 객체에 트리거 사용 가능. Tooling API 35.0 이상. |
| IsWorkflowEnabled | boolean | Defaulted on create, Filter, Group, Sort | true면 객체에 workflow rule을 정의할 수 있다. |
| KeyPrefix | string | Filter, Group, Nillable, Sort | 객체 ID의 첫 세 자리. 객체 타입(예: Account, Opportunity)을 식별. |
| Label | string | Filter, Group, Nillable, Sort | 이 객체의 레이블. compact layout과 유저 언어 로케일에서 사용. |
| Layouts | QueryResult | Filter, Group, Nillable, Sort | 이 객체에 정의된 layout. Tooling API 34.0 이상. 서브쿼리 전용. |
| Limits | QueryResult | Filter, Group, Nillable, Sort | 이 객체에 정의된 한도. Setup의 각 표준 객체 Limits 페이지(또는 커스텀 객체의 Limits 관련 목록)에 대응. Tooling API 34.0 이상. 서브쿼리 전용. |
| LookupFilters | QueryResult | Filter, Group, Nillable, Sort | 이 객체에 정의된 룩업 필터. Tooling API 34.0 이상. 서브쿼리 전용. |
| MasterLabel | string | Filter, Group, Sort | Setup에 표시되는 객체 레이블. org 기본 언어 로케일 기준(없으면 en_US). |
| Metadata | mns: CustomObject | Create, Nillable, Update | 표준/커스텀 객체에 대한 메타데이터. Tooling API WSDL의 metadata 네임스페이스 CustomObject 항목 참조. 쿼리 결과 1건 이하일 때만 쿼리(아니면 에러) — 성능 보호. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체와 연관된 네임스페이스 접두. 관리 패키지를 만드는 각 Developer Edition org은 고유 접두를 가짐. 한도 15자. `namespacePrefix__componentName` 표기. Developer Edition org에서는 지원 객체 전부에 org 접두가 설정됨(설치된 관리 패키지의 객체는 그 패키지 접두). 비 Developer Edition org에서는 설치된 관리 패키지 일부 객체만 설정, 나머지는 접두 없음. |
| NewUrl | string | Filter, Group, Nillable, Sort | 새 표준/커스텀 레코드 편집 시 사용 URL. DescribeSobjectResult의 urlNew에 대응. Tooling API 34.0 이상. |
| OwnerChangeOptions | QueryResult | Filter, Group, Nillable, Sort | 서브쿼리 전용. Tooling API 35.0 이상. 관계 필드이므로 서브쿼리 전용. |
| Particles | QueryResult | Filter, Group, Nillable, Sort | 이 객체에 정의된 particle. Tooling API 34.0 이상. 서브쿼리 전용. |
| PluralLabel | string | Filter, Group, Nillable, Sort | 객체 Label의 복수형. |
| Publisher | Publisher | Create, Nillable, Update | 이 객체의 publisher(예: Salesforce, 유저, 패키지명). Tooling API 34.0 이상. |
| PublisherId | string | Filter, Group, Nillable, Sort | 이 객체와 연관된 publisher의 ID. Tooling API 34.0 이상. |
| QualifiedApiName | string | Filter, Group, Sort | 객체의 고유 외부 ID. 표준 객체는 `NamespacePrefix__DeveloperName`, 커스텀 객체는 `NamespacePrefix__DeveloperName__c` 형식. Custom Metadata Type 관계 필드를 SOQL로 쿼리할 때 완전한 네임스페이스를 얻으려면 이 필드 사용. |
| QuickActionDefinitions | QueryResult | Filter, Group, Nillable, Sort | 이 객체에 정의된 quick action. Tooling API 34.0 이상. 서브쿼리 전용. |
| RecordTypes | QueryResult | Filter, Group, Nillable, Sort | 이 객체에 정의된 레코드 타입. Tooling API 34.0 이상. 서브쿼리 전용. |
| RecordTypesSupported | RecordTypesSupported (서브 타입) | Nillable | 이 객체에 정의된 레코드 타입. Tooling API 34.0 이상. (아래 RecordTypesSupported Metadata 참조) |
| RelatedListDefinitions | QueryResult | Filter, Group, Nillable, Sort | 이 객체에 정의된 관련 목록. 관계 필드이므로 서브쿼리 전용. API 55.0 이상. |
| RelationshipDomains | QueryResult | Filter, Group, Nillable, Sort | 이 객체가 다른 객체와 갖는 관계 메타데이터. Tooling API 34.0 이상. 서브쿼리 전용. |
| RunningUserEntityAccess | UserEntityAccess | Create, Nillable, Update | 실행 유저의 이 객체에 대한 접근 권한. Tooling API 34.0 이상. |
| RunningUserEntityAccessId | string | Filter, Group, Nillable, Sort | 이 객체와 연관된 UserEntityAccess 레코드의 ID. Tooling API 34.0 이상. 관계 필드이므로 서브쿼리 전용. |
| SearchLayouts | QueryResult | Filter, Group, Nillable, Sort | 이 객체와 연관된 검색 layout. Tooling API 34.0 이상. 서브쿼리 전용. |
| StandardActions | QueryResult | Filter, Group, Nillable, Sort | 이 객체에 정의된 standard action. Tooling API 34.0 이상. 서브쿼리 전용. |
| ValidationRules | QueryResult | Filter, Group, Nillable, Sort | 이 객체에 정의된 검증 규칙. Tooling API 34.0 이상. 서브쿼리 전용. |
| WebLinks | QueryResult | Filter, Group, Nillable, Sort | 이 객체와 연관된 Weblink. Tooling API 34.0 이상. 서브쿼리 전용. |
| WorkflowAlerts | QueryResult | Filter, Group, Nillable, Sort | 이 객체와 연관된 workflow alert. Tooling API 34.0 이상. 서브쿼리 전용. |
| WorkflowFieldUpdates | QueryResult | Filter, Group, Nillable, Sort | 이 객체의 workflow field update. Tooling API 34.0 이상. 서브쿼리 전용. |
| WorkflowOutboundMessages | QueryResult | Filter, Group, Nillable, Sort | 이 객체와 연관된 workflow outbound message. Tooling API 34.0 이상. 서브쿼리 전용. |
| WorkflowTasks | QueryResult | Filter, Group, Nillable, Sort | 이 객체와 연관된 workflow task. Tooling API 34.0 이상. 서브쿼리 전용. |

**RecordTypesSupported Metadata** — `tns` 네임스페이스. 이 객체와 연관된 레코드 타입을 나타낸다.

| Field | Type | Description |
|---|---|---|
| recordTypeInfos | RecordTypeInfo | 객체의 RecordTypeInfo 레코드. 서브쿼리 전용. Tooling API 35.0 이상. |

**RecordTypeInfo Metadata** — `tns` 네임스페이스. 객체와 연관된 레코드 타입 하나를 나타낸다.

| Field | Type | Description |
|---|---|---|
| available | boolean | true면 이 레코드 타입을 사용 가능. Tooling API 35.0 이상. |
| defaultRecordTypeMapping | boolean | Tooling API 35.0 이상. |
| developerName | string | 레코드 타입의 developer name. API 43.0 이상. |
| master | boolean | Tooling API 35.0 이상. |
| name | string | 레코드 타입 이름. Tooling API 35.0 이상. |
| recordTypeId | Id | 레코드 타입 ID. Tooling API 35.0 이상. |

### EntityParticle

UI에 표시될 수 있는 필드의 각 요소를 나타낸다. Metadata API에 정의된 필드 요소를 나타내는 `FieldDefinition`과 대비되며, `EntityParticle`은 **describe와 동등**(엔티티의 API 접근 가능 필드만 반환)하다. Tooling API 34.0 이상.

> Important: 비포용적 용어를 Equality 가치에 맞춰 변경했으나 일부 용어는 고객 구현 영향을 피하려 유지했다.

> Note: EntityParticle 필드는 SOAP API 45.0 이상에서 노출. API 44.0 이하는 게스트 유저 모드로 Tooling API 쿼리 가능, 45.0 이상은 게스트 유저 모드에서 SOAP API 사용. ViewSetup 권한 User Profile에는 여전히 Tooling API로 노출.

- **Supported SOAP Calls:** `query()`
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOQL Limitations / SOSL Limitations

| Field | Type | Properties | Description |
|---|---|---|---|
| ByteLength | int | Filter, Group, Nillable, Sort | 이 EntityParticle가 나타내는 필드의 최대 길이(바이트). |
| DataType | string | Filter, Group, Nillable, Sort | 필드의 데이터 타입(예: textarea, datetime). API 데이터 타입명이 아니라 UI 값과 유사하게 정의됨. |
| DefaultValueFormula | string | Filter, Group, Nillable, Sort | 수식이 지정되지 않았을 때 필드에 지정된 기본값. 기본값이 없으면 반환되지 않음. |
| DeveloperName | string | Filter, Group, Nillable, Sort | API 내 객체의 고유 이름. 밑줄·영숫자만 허용, org 내 고유, 문자로 시작, 공백·끝 밑줄·연속 밑줄 불가. 관리 패키지에서 명명 충돌 방지. Label은 Record Type Name. |
| Digits | int | Filter, Group, Nillable, Sort | int 타입 필드의 최대 자릿수. 정수 값이 자릿수를 초과하면 API가 에러 반환. |
| DurableId | string | Filter, Group, Nillable, Sort | 필드의 고유 식별자. 릴리스 간 동일 보장 없음, 사용 전 항상 조회. 쿼리 단순화에 사용. |
| EntityDefinitionId | string | Filter, Group, Nillable, Sort | DurableId 필드에 정의된 객체의 ID. |
| ExtraTypeInfo | string | Filter, Group, Nillable, Sort | 타입의 추가 정의. textarea→`plaintextarea`/`richtextarea`; URL→`image`; reference→`externallookup`/`indirectlookup`; Account→`switchablepersonname`/`personname`. |
| FieldDefinitionId | string | Filter, Group, Nillable, Sort | 이 EntityParticle와 연관된 필드 정의의 ID. |
| InlineHelpText | string | Filter, Group, Nillable, Sort | field-level help 내용. Tooling API 35.0부터. |
| IsApiFilterable | boolean | Defaulted on create, Filter, Group, Sort | true면 이 EntityParticle 필드를 쿼리 WHERE 절에 지정 가능. **Restrictions:** compound 필드는 정렬·필터 불가 — compound 필드에서는 항상 false. |
| IsApiGroupable | boolean | Defaulted on create, Filter, Group, Sort | true면 SOQL의 GROUP BY 절에 포함 가능. |
| IsApiSortable | boolean | Defaulted on create, Filter, Group, Sort | true면 이 필드로 정렬 가능. **Restrictions:** compound 필드는 정렬·필터 불가 — 항상 false. |
| IsAutoNumber | boolean | Defaulted on create, Filter, Group, Sort | true면 레코드 생성 시 필드 값이 자동 할당. Tooling API 35.0부터. |
| IsCalculated | boolean | Defaulted on create, Filter, Group, Sort | true면 이 EntityParticle 필드가 계산됨(calculated). |
| IsCaseSensitive | boolean | Defaulted on create, Filter, Group, Sort | true면 대소문자 구분. Tooling API 35.0부터. |
| IsCompactLayoutable | boolean | Defaulted on create, Filter, Group, Sort | true면 compact layout에 포함 가능. |
| IsComponent | boolean | Defaulted on create, Filter, Group, Sort | true면 compound 필드의 component. 기본값 false. Tooling API 40.0부터. |
| IsCompound | boolean | Defaulted on create, Filter, Group, Sort | true면 다른 필드들의 compound. 기본값 false. Tooling API 38.0부터. |
| IsCreatable | boolean | Defaulted on create, Filter, Group, Sort | true면 이 EntityParticle 필드 값 생성 가능. Tooling API 35.0부터. |
| IsDefaultedOnCreate | boolean | Defaulted on create, Filter, Group, Sort | true이고 다른 값이 없으면 레코드 생성 시 기본값 적용. Tooling API 35.0부터. |
| IsDependentPicklist | boolean | Defaulted on create, Filter, Group, Sort | true면 dependent picklist. Tooling API 35.0부터. |
| IsDeprecatedAndHidden | boolean | Defaulted on create, Filter, Group, Sort | Reserved for future use. |
| IsDisplayLocationInDecimal | boolean | Defaulted on create, Filter, Group, Sort | true이고 Geolocation 커스텀 필드면 값이 소수 표기로 표시. false면 도·분·초. Tooling API 35.0부터. **Restrictions:** Geolocation이 아닌 커스텀 필드엔 효과 없음. |
| IsEncrypted | boolean | Defaulted on create, Filter, Group, Sort | true면 Classic Encryption 대상. Tooling API 35.0부터. |
| IsFieldHistoryTracked | boolean | Defaulted on create, Filter, Group, Sort | true면 필드 이력 추적 가능. |
| IsHighScaleNumber | boolean | Defaulted on create, Filter, Group, Sort | true면 필드 상세 설정과 무관하게 소수점 8자리까지 저장. 대량의 1센트 미만 통화 처리용. high-scale unit pricing 미활성 시 반환 안 됨. |
| IsHTMLFormatted | boolean | Defaulted on create, Filter, Group, Sort | true면 필드가 HTML 포함. |
| IsIdLookup | boolean | Defaulted on create, Filter, Group, Sort | true면 upsert 시 레코드 지정에 사용 가능. Tooling API 35.0부터. |
| IsLayoutable | boolean | Defaulted on create, Filter, Group, Sort | true면 layout에 할당 가능. Tooling API 35.0부터. |
| IsListVisible | boolean | Defaulted on create, Filter, Group, Sort | true면 관련 목록에 포함 가능. |
| IsNameField | boolean | Defaulted on create, Filter, Group, Sort | true면 name 필드. |
| IsNamePointing | boolean | Defaulted on create, Filter, Group, Sort | true면 polymorphic 관계. true일 때 동적 쿼리에서 런타임에 객체 타입 결정. Tooling API 35.0부터. |
| IsNillable | boolean | Defaulted on create, Filter, Group, Sort | true면 객체 쿼리에서 필드를 생략 가능. |
| IsPermissionable | boolean | Defaulted on create, Filter, Group, Sort | true면 필드에 field permission 지정 가능. Tooling API 35.0부터. |
| IsUnique | boolean | Defaulted on create, Filter, Group, Sort | true면 필드가 unique. Tooling API 35.0부터. |
| IsUpdatable | boolean | Defaulted on create, Filter, Group, Sort | true면 필드 업데이트 가능. Tooling API 35.0부터. |
| IsWorkflowFilterable | boolean | Defaulted on create, Filter, Group, Sort | true면 workflow용으로 필터 가능. |
| IsWriteRequiresMasterRead | boolean | Defaulted on create, Filter, Group, Sort | true면 detail 객체에 쓰기 시 부모의 read-write가 아닌 read sharing 필요. Tooling API 35.0부터. |
| Label | string | Filter, Group, Sort | UI에서 필드에 대응하는 레이블. 번역이 있으면 유저 언어로 반환. |
| Length | int | Filter, Group, Sort | 이 EntityParticle 필드 값 저장에 사용 가능한 최대 바이트 수. |
| Mask | string | Filter, Group, Nillable, Sort | Reserved for future use. |
| MaskType | string | Filter, Group, Nillable, Sort | Reserved for future use. |
| MasterLabel | string | Filter, Group, Sort | 이 객체의 기본 레이블. 번역되지 않는 내부 레이블. 한도 40자. |
| Name | string | Filter, Group, Nillable, Sort | 이 EntityParticle 필드의 객체 이름. API 35.0 이상. |
| NamespacePrefix | string | Filter, Group, Sort | 이 객체의 네임스페이스 접두. 관리 패키지를 만드는 각 Developer Edition org은 고유 접두 보유. 한도 15자. `namespacePrefix__componentName` 표기. (값 규칙은 EntityDefinition.NamespacePrefix와 동일.) |
| Precision | int | Filter, Group, Sort | 이 EntityParticle 필드에 허용되는 최대 자릿수. |
| QualifiedApiName | string | Filter, Group, Sort | 필드의 고유 외부 이름. |
| ReferenceTargetField | string | Filter, Group, Nillable, Sort | 외부 데이터 소스 값을 가진 indirect lookup 관계 필드를 매칭할 부모 객체의 커스텀 필드를 지정. 지정된 부모 필드는 IsIdLookup과 IsUnique가 모두 true여야 한다. API 35.0 이상. **Restrictions:** 외부 객체의 indirect lookup 관계 필드인 경우에만 사용 가능. |
| ReferenceTo | RelationshipReferenceTo (서브 타입) | Nillable | 이 필드의 값 배열은 참조 객체의 가능한 객체 타입을 나타낸다. 예: Events의 필드면 Contact, Lead, Events와 관계 있는 커스텀 객체. |
| RelationshipName | string | Filter, Group, Nillable, Sort | 이 EntityParticle가 master-detail 관계 필드면 값은 관계 이름. |
| RelationshipOrder | int | Filter, Group, Nillable, Sort | 0은 primary 관계, 1은 secondary 관계. 관계 필드에만 유효. |
| Scale | int | Filter, Group, Sort | 정수의 소수점 오른쪽 자릿수. 예: 3.00의 scale은 2. |
| ValueTypeId | string | Filter, Group, Nillable, Sort | 이 EntityParticle 필드의 value type ID(있는 경우). |

**RelationshipReferenceTo Type** — 이 EntityParticle가 관계를 가질 수 있는 객체 집합을 나타낸다.

| Field | Type | Description |
|---|---|---|
| referenceTo | string[] | 참조 가능한 객체 이름. 예: EntityParticle가 Event.WhoId를 나타내면 값은 최소 `[Contact, Lead]`. |

**쿼리 시 필수 구문:** `WHERE EntityDefinition.QualifiedApiName ='[ObjectAPIName]'`

```sql
-- 한 데이터 타입의 모든 필드 조회
SELECT EntityDefinitionId, QualifiedAPIName, FieldDefinitionId
FROM EntityParticle
WHERE EntityDefinition.QualifiedApiName ='Case'

-- Account의 모든 필드 조회
SELECT DataType, FieldDefinition.QualifiedApiName
FROM EntityParticle
WHERE EntityDefinition.QualifiedApiName ='Account'

-- 부모 객체 타입 찾기 (polymorphic: Event.WhoId는 Contact 또는 Lead)
SELECT QualifiedApiName, RelationshipName, ReferenceTo, ReferenceTargetField
FROM EntityParticle
WHERE EntityDefinition.QualifiedApiName = 'Event' AND QualifiedApiName = 'WhoId'
```

### FieldDefinition

표준/커스텀 필드를 나타내며 **필드 메타데이터에 행 기반 접근**을 제공한다. UI에 표시될 수 있는 필드 요소를 나타내는 `EntityParticle`과 대비되며, `FieldDefinition`은 **Metadata 타입 Field와 동등**하다. API 32.0 이상.

> Important: 비포용적 용어를 Equality 가치에 맞춰 변경했으나 일부 용어는 유지했다.

> Note: FieldDefinition 필드는 SOAP API 45.0 이상에서 노출. API 44.0 이하는 게스트 유저 모드로 Tooling API 쿼리, 45.0 이상은 게스트 유저 모드에서 SOAP API. ViewSetup 권한 User Profile에는 Tooling API로 노출.

- **Supported SOAP Calls:** `query()`, `describeSObject()`
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOQL Limitations / SOSL Limitations

| Field | Type | Properties | Description |
|---|---|---|---|
| BusinessOwnerId | reference | Filter, Group, Nillable, Sort | 이 필드와 연관된 사람/그룹. business owner는 필드 데이터의 중요도를 이해하고 최소 보안 분류 결정 책임을 질 수 있다. API 45.0 이상. |
| BusinessStatus | picklist | Filter, Group, Nillable, Sort | 필드가 사용 중인지 표시. 값: `Active`, `DeprecateCandidate`, `Hidden`. API 45.0 이상. |
| CompactLayoutItems | QueryResult | Filter, Group, Sort | 이 필드 정의와 연관된 CompactLayoutItemInfo 레코드. Tooling API 34.0부터. 관계 필드이므로 서브쿼리 전용. |
| ComplianceGroup | multipicklist | Filter, Nillable | 필드 데이터 관련 규정·정의. 값: `CCPA`, `COPPA`, `GDPR`, `HIPAA`, `PCI`, `PersonalInfo`(Enhanced Personal Information Management 기능용 — 해당 기능과 Digital Experiences 활성 시만), `PII`. API 47.0 이상. |
| ControlledFields | QueryResult | Filter, Group, Sort | dependent picklist의 controlled 필드. 쿼리 수를 줄이려 서브쿼리에서 사용. Tooling API 34.0부터. 관계 필드이므로 서브쿼리 전용. |
| ControllingFieldDefinition | FieldDefinition | Filter, Group, Sort | 이 필드가 dependent picklist면 controlling 필드의 정의. controlling 필드(picklist/checkbox)에서 선택한 값이 dependent 필드의 가용 값에 영향. API 14.0 이상. Tooling API 34.0부터. |
| ControllingFieldDefinitionId | string | Filter, Group, Sort | 이 필드의 ControllingFieldDefinition ID. Tooling API 34.0부터. |
| DataType | string | Filter, Group, Sort | 필드의 데이터 타입(예: Text(40), Date/Time). API 데이터 타입명이 아니라 UI 정의값. Tooling API 34.0부터. |
| Description | string | Filter, Nillable, Sort | 필드 정의 설명. |
| DeveloperName | string | Filter, Group, Sort | API 내 객체의 고유 이름. 밑줄·영숫자만, org 내 고유, 문자 시작, 공백·끝 밑줄·연속 밑줄 불가. Label은 Record Type Name. |
| DurableId | string | Filter, Group, Sort | 필드의 고유 식별자. 릴리스 간 동일 보장 없음, 사용 전 항상 조회. 쿼리 단순화에 사용. |
| EntityDefinition | EntityDefinition | Filter, Group, Sort | 이 필드를 포함하는 객체 타입에 대한 관계 룩업(예: account의 필드면 Account로 룩업). 직접 상호작용 불가 — 쿼리에서만 사용. |
| EntityDefinitionId | string | Filter, Group, Sort | EntityDefinition 필드에 정의된 객체의 durable ID. |
| ExtraTypeInfo | string | Filter, Group, Sort | 타입의 추가 정의. Tooling API 34.0부터. textarea→`plaintextarea`/`richtextarea`; URL→image; reference→`externallookup`/`indirectlookup`; Account→`switchablepersonname`/`personname`. |
| FullName | string | Create, Group, Nillable | Metadata API의 연관 메타데이터 객체 full name. 쿼리 결과 1건 이하일 때만 쿼리(아니면 에러) — 성능 보호. |
| IsApiFilterable | boolean | Defaulted on create, Filter, Group, Sort | true면 쿼리 WHERE 절에 지정 가능. Tooling API 34.0부터. compound 필드는 정렬·필터 불가 — 항상 false. |
| IsApiGroupable | boolean | Defaulted on create, Filter, Group, Sort | true면 SOQL GROUP BY 절에 포함 가능. Tooling API 34.0부터. |
| IsApiSortable | boolean | Defaulted on create, Filter, Group, Sort | true면 정렬 가능. Tooling API 34.0부터. compound 필드는 정렬·필터 불가 — 항상 false. |
| IsCalculated | boolean | Defaulted on create, Filter, Group, Sort | true면 필드 값이 계산됨. Tooling API 34.0부터. |
| IsCompactLayoutable | boolean | Defaulted on create, Filter, Group, Sort | true면 compact layout에 포함 가능. Tooling API 34.0부터. |
| IsCompound | boolean | Defaulted on create, Filter, Group, Sort | true면 다른 필드들의 compound. 기본값 false. Tooling API 38.0부터. |
| IsEverApiAccessible | boolean | Defaulted on create, Filter, Group, Sort | true면 필드를 API에서 describe 가능. 기본값 false. Tooling API 49.0부터. |
| IsFieldHistoryTracked | boolean | Defaulted on create, Filter, Group, Sort | true면 필드 이력 추적 가능. Tooling API 34.0부터. |
| IsFlsEnabled | boolean | Defaulted on create, Filter, Group, Sort | true면 이 필드에 field-level security 설정 가능. Tooling API 35.0부터. |
| IsHighScaleNumber | boolean | Defaulted on create, Filter, Group, Sort | true면 필드 상세와 무관하게 소수점 8자리까지 저장. 대량 1센트 미만 통화용. high-scale unit pricing 미활성 시 반환 안 됨. Tooling API 34.0부터. |
| IsHtmlFormatted | boolean | Defaulted on create, Filter, Group, Sort | true면 필드가 HTML 포함. Tooling API 34.0부터. |
| IsIndexed | boolean | Defaulted on create, Filter, Group, Sort | true면 DB에 인덱싱됨. API 35.0 이상. 내부(DB) 인덱싱은 검색 인덱싱과 다름. SOQL·리포트·목록 뷰의 응답 시간 개선을 위해 인덱싱된 필드를 타기팅 권장. |
| IsListFilterable | boolean | Defaulted on create, Filter, Group, Sort | true면 관련 목록용 필터 가능. Tooling API 34.0부터. |
| IsListSortable | boolean | Defaulted on create, Filter, Group, Sort | true면 관련 목록용 정렬 가능. Tooling API 34.0부터. |
| IsListVisible | boolean | Defaulted on create, Filter, Group, Sort | true면 관련 목록에 포함 가능. Tooling API 34.0부터. |
| IsNameField | boolean | Defaulted on create, Filter, Group, Sort | true면 name 필드. Tooling API 34.0부터. |
| IsNillable | boolean | Defaulted on create, Filter, Group, Sort | true면 객체 쿼리에서 필드 생략 가능. Tooling API 34.0부터. |
| IsPolymorphicForeignKey | boolean | Defaulted on create, Filter, Group, Sort | foreign key가 여러 객체 타입을 포함하는지(true) 여부. API 41.0 이상. |
| IsSearchPrefilterable | boolean | Defaulted on create, Filter, Group, Sort | SOSL WHERE 절에서 foreign key를 prefiltering에 포함 가능한지. prefiltering = 전체 검색 실행 전 특정 필드 값으로 필터. API 40.0 이상. WHERE 절의 등호(=) 연산자에서만 지원. |
| IsWorkflowFilterable | boolean | Defaulted on create, Filter, Group, Sort | true면 workflow용 필터 가능. Tooling API 34.0부터. |
| Label | string | Filter, Group, Sort | UI에서 필드에 대응하는 레이블. 번역됐으면 유저 언어로 반환. |
| Length | int | Filter, Group, Sort | 필드 값 저장에 사용 가능한 최대 바이트 수. Tooling API 34.0부터. |
| LookupFilters | QueryResult | Filter, Group, Nillable, Sort | 필드와 연관된 룩업 필터. 관계 필드이므로 서브쿼리 전용. (Note: LookupFilter는 article type 객체에서 미지원.) |
| MasterLabel | string | Filter, Group, Sort | 이 객체의 기본 레이블. 번역되지 않는 내부 레이블. 한도 40자. |
| Metadata | CustomField | Create, Nillable, Update | compact layout 메타데이터, mns 네임스페이스. 쿼리 결과 1건 이하일 때만 쿼리(아니면 에러) — 성능 보호. (필드 구성은 아래 CustomField Metadata 참조.) |
| NamespacePrefix | string | Filter, Group, Sort | 이 객체의 네임스페이스 접두. 관리 패키지를 만드는 각 Developer Edition org은 고유 접두 보유. 한도 15자. `namespacePrefix__componentName` 표기. (값 규칙은 EntityDefinition.NamespacePrefix와 동일.) |
| Particles | QueryResult | Filter, Group, Sort | 이 필드와 연관된 EntityParticle. Tooling API 34.0부터. 관계 필드이므로 서브쿼리 전용. |
| Precision | int | Filter, Group, Sort | 이 필드에 허용되는 최대 자릿수. Tooling API 34.0부터. |
| Publisher | Publisher | Filter, Group, Sort | 이 필드의 publisher(예: Salesforce, 유저, 패키지명). Tooling API 34.0부터. |
| PublisherId | string | Filter, Group, Sort | 이 필드와 연관된 publisher ID. Tooling API 34.0부터. |
| QualifiedApiName | string | Filter, Group, Sort | 필드의 고유 외부 이름. |
| ReferenceTargetField | string | Filter, Group, Sort | 외부 객체의 indirect lookup 관계 필드 전용. 외부 데이터 소스 값을 가진 이 필드를 매칭할 부모 객체 필드 지정. 지정 부모 커스텀 필드는 externalId와 unique가 모두 true여야 함. Tooling API 34.0부터. |
| ReferenceTo | RelationshipReferenceTo | Filter, Group, Sort | 값 배열은 참조 객체의 가능 객체 타입을 나타냄. 예: Event.WhoId면 Contact, Lead, Events와 관계 있는 커스텀 객체. Tooling API 34.0부터. |
| RelationshipDomains | QueryResult | Filter, Group, Sort | 이 필드가 다른 객체와 갖는 관계 메타데이터. Tooling API 34.0부터. 관계 필드이므로 서브쿼리 전용. |
| RelationshipName | string | Filter, Group, Sort | one-to-many 관계 값. 예: MyObject가 YourObject와 관계 있으면 관계 이름은 보통 YourObjects. Tooling API 34.0부터. |
| RunningUserFieldAccessId | string | (Properties 없음) | Reserved for internal use. Tooling API 34.0부터. |
| Scale | int | Filter, Group, Sort | 정수의 소수점 오른쪽 자릿수. 예: 3.00의 scale은 2. Tooling API 34.0부터. |
| SecurityClassification | picklist | Filter, Group, Nillable, Sort | 이 필드 데이터의 민감도. 값: `Public`, `Internal`, `Confidential`, `Restricted`, `MissionCritical`. API 45.0 이상. |
| ServiceDataType | DataType | Filter, Group, Sort | 이 필드의 service datatype. Tooling API 34.0부터. |
| ServiceDataTypeId | string | Filter, Group, Sort | ServiceDataType의 ID. Tooling API 34.0. **사용 금지** — 하위 호환용으로만 제공. |
| ServiceDataTypes | QueryResult | Filter, Group, Sort | 이 필드와 연관된 ServiceDataType. Tooling API 34.0부터. 관계 필드이므로 서브쿼리 전용. |
| ValueType | DataType | Filter, Group, Sort | 필드의 데이터 타입. Tooling API 35.0. |
| ValueTypeId | string | Filter, Group, Sort | ValueType의 ID. Tooling API 35.0. |
| WorkflowFieldUpdates | QueryResult | Filter, Group, Sort | 이 필드의 workflow field update. workflow rule 트리거 시 필드 값을 지정값으로 자동 업데이트. Tooling API 34.0부터. 관계 필드이므로 서브쿼리 전용. |

> Note: FieldDefinition 필드는 SOAP API 45.0 이상에서 노출(위 EntityParticle/EntityDefinition와 동일한 게스트 유저 모드 규칙).

**쿼리 시 필수 구문:** `WHERE EntityDefinition.QualifiedApiName ='[ObjectAPIName]'`

```sql
-- 커스텀 객체 필드 메타데이터 조회
SELECT DurableId, QualifiedApiName, Label, DataType, ValueTypeId, PublisherId,
       Length, Precision, Scale, EntityDefinitionId, RelationshipName
FROM FieldDefinition
WHERE EntityDefinition.QualifiedApiName = 'Customer_Sat_Survey__c'
ORDER BY Label ASC NULLS FIRST

-- 부모 객체 타입 찾기 (polymorphic Event.WhoId)
SELECT QualifiedApiName, RelationshipName, ReferenceTo, ReferenceTargetField
FROM FieldDefinition
WHERE EntityDefinition.QualifiedApiName = 'Event' AND QualifiedApiName = 'WhoId'

-- Account 필드의 데이터 타입 (서브쿼리 Particles)
SELECT QualifiedApiName, (SELECT DataType FROM Particles)
FROM FieldDefinition
WHERE EntityDefinition.QualifiedApiName ='Account'
```

**CustomField Metadata** — `FieldDefinition.Metadata`(mns: CustomField)에 노출되는 메타데이터 필드. (자세한 내용은 Metadata API Developer Guide의 CustomField 참조.)

| Field Name | Field Type | Description |
|---|---|---|
| caseSensitive | boolean | 필드가 대소문자 구분(true)인지. 외부 객체의 indirect lookup 관계 필드에서는 referenceTargetField 값 매칭 방식에 영향. |
| defaultValue | string | 지정 시 필드의 기본값. |
| deleteConstraint | DeleteConstraint (문자열 enum) | 룩업 관계의 삭제 옵션. `SetNull`(기본값 — 룩업 레코드 삭제 시 룩업 필드 비움), `Restrict`(룩업 관계에 있으면 삭제 방지), `Cascade`(룩업 레코드와 연관 룩업 필드 삭제). |
| description | string | 필드 설명. |
| displayFormat | string | 표시 형식. |
| displayLocationInDecimal | boolean | Geolocation 커스텀 필드 값 표시 방식. true면 소수 표기, false면 도·분·초. |
| externalDeveloperName | string | 외부 객체 전용. 이 커스텀 필드에 매핑되는 외부 데이터 소스의 테이블 컬럼 이름. UI의 External Column Name에 대응. API 32.0 이상. |
| externalId | boolean | external ID 필드(true)인지. |
| formula | string | 지정 시 필드의 수식. |
| formulaTreatBlankAs | TreatBlanksAs | 수식에서 blank 처리 방식. `BlankAsBlank` 또는 `BlankAsZero`. |
| fullName | string | Required. 객체의 내부 이름. 공백·특수문자는 유효성 위해 escape. 문자·숫자·밑줄 포함, 문자로 시작, 끝 밑줄·연속 밑줄 불가. |
| indexed | boolean | 필드 인덱싱 여부. unique이거나 externalId가 true면 isIndexed가 true로 설정. **14.0부터 deprecated** — 하위 호환용. |
| inlineHelpText | string | field-level help 내용. |
| isFilteringDisabled | boolean | 외부 객체 전용. 커스텀 필드가 필터에서 사용 가능한지. API 32.0 이상. |
| isNameField | boolean | text 타입 외부 객체 필드 전용. 외부 객체마다 한 필드를 name 필드로 지정 가능. true 설정 시 externalDeveloperName이 식별하는 외부 테이블 컬럼에 name 값이 있어야 함. API 32.0 이상. |
| isSortingDisabled | boolean | 외부 객체 전용. 커스텀 필드 정렬 가능 여부. API 32.0 이상. |
| reparentableMasterDetail | boolean | 커스텀 객체의 master-detail 관계 자식 레코드를 다른 부모로 reparent 가능한지. 기본값 false. API 25.0 이상. |
| label | string | 필드 레이블. 표준 picklist 필드(예: account의 Industry)의 레이블은 업데이트 불가. |
| length | int | 필드 길이. |
| lookupFilter | LookupFilter | 커스텀 필드의 룩업 필터 정의. API 30.0 이상. |
| maskChar | EncryptedFieldMaskChar | 암호화 필드의 마스크 문자. `asterisk`, `X`. |
| maskType | EncryptedFieldMaskType | 암호화 텍스트 필드의 마스크/비마스크 문자 형식. `all`(전체 숨김, Mask All Characters 등가), `creditCard`(앞 12자 숨김·뒤 4자 표시), `ssn`(앞 5자 숨김·뒤 4자 표시), `lastFour`(뒤 4자만 표시), `sin`(뒤 4자만 표시, Social Insurance Number 등가), `nino`(전체 숨김; 9자면 2자마다 공백 삽입, National Insurance Number 등가). |
| picklist | Picklist | 지정 시 필드가 picklist이며 값·레이블을 열거. (아래 Picklist Metadata 참조) |
| populateExistingRows | boolean | 기존 행을 채우는지(true). |
| precision | int | 숫자 값의 precision(숫자의 총 자릿수). 예: 256.99의 precision은 5. |
| referenceTargetField | string | 외부 객체의 indirect lookup 관계 필드 전용. 매칭할 부모 객체 커스텀 필드 지정(externalId·unique 모두 true 필요). API 32.0 이상. |
| referenceTo | string | 지정 시 이 필드가 다른 객체에 갖는 참조. |
| relationshipLabel | string | 관계 레이블. |
| relationshipName | string | 지정 시 one-to-many 관계 값. |
| relationshipOrder | int | 모든 master-detail 관계에 유효하나 junction 객체에서만 non-zero. junction 객체는 master-detail 2개를 가지며 한 부모를 primary(0), 다른 부모를 secondary(1)로 정의. junction이 아닌 객체는 항상 0. |
| required | boolean | 생성 시 필드 값 필수(true) 여부. |
| scale | int | 필드의 scale(소수점 오른쪽 자릿수). 예: 256.99의 scale은 2. |
| startingNumber | int | 지정 시 필드의 시작 번호. |
| stripMarkup | boolean | true면 markup 제거, false면 보존. rich text area를 long text area로 변환 시 사용. |
| summarizedField | string | summary 대상 detail 행 필드. SummaryOperation이 count가 아니면 null 불가. |
| summaryForeignKey | string | 부모-자식 관계를 정의하는 자식의 master-detail 필드. |
| summaryOperation | SummaryOperations (문자열 enum) | 수행할 sum 연산. `Count`, `Min`, `Max`, `Sum`. |
| trackFeedHistory | boolean | feed tracking 활성화 여부(true). API 18.0 이상. |
| trackHistory | boolean | history tracking 활성화 여부(true). 표준 객체 필드(picklist·lookup만)는 API 30.0 이상. |
| trackTrending | boolean | historical trending 데이터 캡처 여부(true). 한 필드라도 true면 객체가 historical trending 활성화. API 29.0 이상. |
| trueValueIndexed | boolean | checkbox 필드 전용. 설정 시 true 값이 인덱스에 빌드됨. **14.0부터 deprecated** — 하위 호환용. |
| type | FieldType (문자열 enum) | 필드 타입. `Address (beta)`, `AutoNumber`, `Lookup`, `MasterDetail`, `Checkbox`, `Currency`, `Date`, `DateTime`, `Email`, `EncryptedText`¹, `Number`, `Percent`, `Phone`, `Picklist`, `MultiselectPicklist`, `Summary`, `Text`, `TextArea`, `LongTextArea`, `Summary`, `Url`, `Hierarchy`, `File`, `Html`, `Geolocation`. 표준 객체의 표준 필드는 type이 선택적(일부 타입엔 포함, 일부엔 미포함). 커스텀 필드는 type 포함. *(원문에 Summary가 두 번 나열됨 — 원문 보존)* |
| unique | boolean | 필드가 unique(true) 여부. |
| visibleLines | int | 필드에 표시되는 줄 수. |
| writeRequiresMasterRead | boolean | 자식 레코드 생성·편집·삭제에 필요한 부모 레코드의 최소 sharing 접근 수준. master-detail/junction 커스텀 필드에만 적용. `true`(부모에 "Read" 접근 권한이면 자식 생성·편집·삭제 허용 — 덜 제한적), `false`(부모에 "Read/Write" 접근 필요 — 더 제한적, 기본값). junction 객체는 두 부모 중 더 제한적인 접근이 적용. |

> ¹ EncryptedText는 Classic Encryption(masked) 필드를 가리킨다. 원문 표에 위첨자 1로 표기되어 있으나 본문 footnote 텍스트는 PDF에 명시되지 않음.

**Picklist Metadata**

| Field Name | Field Type | Description |
|---|---|---|
| controllingField | string | 이 필드가 dependent picklist면 controlling 필드의 fullName. controlling 필드 값이 dependent 필드 옵션을 필터. API 14.0 이상. |
| picklistValues | PicklistValue[] | Required. picklist 값 집합. |
| sorted | boolean | Required. 값 정렬 여부(true). |

**PicklistValue Metadata** — picklist 값과 기본값 여부를 정의. Metadata를 extend하며 fullName 필드를 상속. (표준 객체 retrieve 시 모든 picklist 값 반환, deploy 시 필요에 따라 값 추가, 값을 inactive로 직접 설정 불가 — update에서 누락된 값이 inactive가 됨.)

| Field Name | Field Type | Description |
|---|---|---|
| allowEmail | boolean | 이 값이 유저의 quote PDF 이메일 발송 허용 여부(true). quote의 Status 필드 전용. API 18.0 이상. |
| closed | boolean | 이 값이 closed status 연관 여부(true). case·task의 표준 Status 필드 전용. API 16.0 이상. |
| color | string | 리포트·대시보드 차트에서 picklist 값에 할당된 색(16진수, 예: #FF6600). 미지정 시 차트 생성 중 동적 할당. API 17.0 이상. |
| controllingFieldValues | string[] | 이 picklist 값에 연결된 controlling 필드 값 목록. controlling 필드는 checkbox 또는 picklist. checkbox→checked/unchecked, picklist→controlling 필드 picklist 값의 fullName. API 14.0 이상. |
| converted | boolean | 이 값이 converted status 연관 여부(true). lead의 표준 Status 필드 전용. API 16.0 이상. |
| cssExposed | boolean | 이 값이 Self-Service Portal에서 가용 여부(true). case의 표준 Case Reason 필드 전용. (Note: Spring '12부터 새 org엔 Self-Service portal 미제공, 기존 org은 계속 접근.) API 16.0 이상. |
| default | boolean | Required. 이 값이 지정 picklist의 기본 picklist 값 여부(true). |
| description | string | 커스텀 picklist 값 설명. opportunity의 표준 Stage 필드 전용. API 16.0 이상. |
| forecastCategory | ForecastCategories (문자열 enum) | 이 값이 forecast category 연관 여부(true). opportunity의 표준 Stage 필드 전용. 값: `Omitted`, `Pipeline`, `BestCase`, `Forecast`, `Closed`. API 16.0 이상. |
| fullName | string | API 접근용 고유 식별자. 밑줄·영숫자만, 고유, 문자 시작, 공백·끝 밑줄·연속 밑줄 불가. Metadata에서 상속. |
| highPriority | boolean | 이 값이 high priority 항목 여부(true). task의 표준 Priority 필드 전용. API 16.0 이상. |
| probability | int | 이 값이 확률 percentage 여부(true). opportunity의 표준 Stage 필드 전용. API 16.0 이상. |
| reverseRole | string | partner의 reverse role 이름에 대응하는 picklist 값. 예: "subcontractor"의 reverse는 "general contractor". partner role 전용. API 18.0 이상. |
| reviewed | boolean | 이 값이 reviewed status 연관 여부(true). solution의 표준 Status 필드 전용. API 16.0 이상. |
| won | boolean | 이 값이 closed/won status 연관 여부(true). opportunity의 표준 Stage 필드 전용. API 16.0 이상. |

**RelationshipReferenceTo Type**

| Field | Type | Details |
|---|---|---|
| referenceTo | string[] | 이 FieldDefinition이 나타내는 필드와 관계를 가질 수 있는 객체. |

**WorkflowFieldUpdate Metadata** — WorkflowFieldUpdate에 대한 자세한 내용은 Metadata API Developer Guide 참조.

### EntityLimit

Setup UI에 표시되는 객체 한도를 나타낸다. API 34.0 이상.

- **Supported SOAP Calls:** `query()`
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOQL Limitations / SOSL Limitations

| Field | Type | Properties | Description |
|---|---|---|---|
| DurableId | string | Filter, Group, Nillable, Sort | 필드의 고유 식별자. 릴리스 간 동일 보장 없음, 사용 전 항상 조회. 쿼리 단순화에 사용. |
| EntityDefinition | EntityDefinition | Filter, Group, Sort | 이 한도가 적용되는 객체. |
| EntityDefinitionId | string | Filter, Group, Sort | 이 한도가 적용되는 객체의 ID. |
| Label | string | Filter, Group, Sort | 이 한도가 적용되는 객체의 레이블. |
| Max | int | Filter, Group, Sort | org이 가질 수 있는 객체의 최대 수. |
| Remaining | int | Filter, Group, Sort | 아직 사용 가능한 객체 수. 예: 커스텀 객체 한도 100, 75개 생성 시 이 값은 25. |
| Type | string | Filter, Group, Restricted picklist, Sort | 한도가 적용되는 컴포넌트 타입: `ActiveLookupFilters`, `ActiveRules`, `ActiveValidationRules`, `ApprovalProcesses`, `CbsSharingRules`, `CustomFields`, `CustomRelationship`, `RollupSummary`, `SharingRules`, `TotalRules`, `VLookup`. |

### DataType

필드의 데이터 타입을 나타낸다. `EntityDefinition`·`EntityParticle`·`FieldDefinition`과 함께 사용해 쿼리를 단순화. Tooling API 34.0 이상.

- **Supported SOAP Calls:** `query()`
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOQL Limitations (p38) / SOSL Limitations (p40)
- **Special Access Rules:** Spring '20 이상부터 인증된 internal·external 유저만 이 객체에 접근 가능.

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Nillable, Sort | API 내 객체의 고유 이름. 밑줄·영숫자만, org 내 고유, 문자 시작, 공백·끝 밑줄·연속 밑줄 불가. Label은 Record Type Name. |
| ContextServiceDataTypeId | (사용 금지) | — | 이 필드를 사용하지 말 것. future use 예약. 속성·동작이 변경될 수 있음. |
| ContextWsdlDataTypeId | (사용 금지) | — | 이 필드를 사용하지 말 것. future use 예약. 속성·동작이 변경될 수 있음. |
| DurableId | string | Filter, Group, Nillable, Sort | 필드의 고유 식별자. 릴리스 간 동일 보장 없음, 사용 전 항상 조회. 쿼리 단순화에 사용. |
| IsComplex | boolean | Defaulted on create, Filter, Group, Sort | true면 datatype이 다른 datatype을 포함(string 같은 simple datatype과 대비). |

> Note: DataType 필드는 SOAP API 45.0 이상에서 노출. API 44.0 이하는 게스트 유저 모드로 Tooling API 쿼리, 45.0 이상은 게스트 유저 모드에서 SOAP API. ViewSetup 권한 User Profile에는 Tooling API로 노출.

```sql
-- 한 객체에서 특정 datatype의 모든 필드 조회
SELECT DataType, QualifiedApiName
FROM EntityParticle
WHERE DataType = 'phone' AND
      EntityDefinition.QualifiedApiName = 'Account'
```

> **SOQL Limitations (DataType):** 이 객체는 일부 SOQL 연산을 지원하지 않는다.
> - **GROUP BY** — 예: `SELECT COUNT(qualifiedapiname), isfeedenabled FROM EntityDefinition GROUP BY isfeedenabled` → 에러: "The requested operation is not yet supported by this SObject storage type, contact salesforce.com support for more information."
> - **LIMIT, LIMIT OFFSET** — 예: `SELECT qualifiedapiname FROM EntityDefinition LIMIT 5` / `... LIMIT 5 OFFSET 10` → LIMIT·LIMIT OFFSET이 무시되어 부정확한 결과 반환.

---

## 커스텀 객체·필드·레코드 타입

### CustomObject

org에 고유한 데이터를 저장하는 커스텀 객체를 나타낸다. Salesforce Metadata API의 연관 CustomObject 객체·관련 필드에 대한 접근을 포함. API 31.0 이상.

> 경계: 같은 이름의 Metadata API 타입은 [[Metadata Types — Objects & Fields]] 참조(배포용 declarative metadata).

- **Supported SOAP Calls:** `query()`, `retrieve()`, `search()`
- **Supported REST HTTP Methods:** Query, GET

| Field Name | Type | Properties | Description |
|---|---|---|---|
| CustomHelpId | ID | Filter, Group, Nillable, Sort | 이 커스텀 객체가 커스텀 help 콘텐츠를 가지면 그 콘텐츠를 담는 control. |
| Description | string | Filter, Nillable, Sort | 객체 설명. 객체 생성 이유·용도 기술에 유용. |
| DeveloperName | string | Filter, Group, Sort | 커스텀 객체의 개발자 내부 이름. 예: 커스텀 객체 CO__c의 내부 이름은 CO. |
| ExternalName | string | Filter, Group, Nillable, Sort | 외부 데이터 소스의 테이블에 매핑. Validate and Sync로 외부 객체를 만들었다면 자동 생성. |
| ExternalRepository | string | Filter, Group, Nillable, Sort | 외부 데이터 소스의 테이블에 매핑. Validate and Sync로 만들었다면 자동 생성 — 수정 금지. |
| Language | string | Filter, Group, Restricted picklist, Sort | action의 언어. 값: 중국어 간체 `zh_CN`, 중국어 번체 `zh_TW`, 덴마크어 `da`, 네덜란드어 `nl_NL`, 영어 `en_US`, 핀란드어 `fi`, 프랑스어 `fr`, 독일어 `de`, 이탈리아어 `it`, 일본어 `ja`, 한국어 `ko`, 노르웨이어 `no`, 포르투갈어(브라질) `pt_BR`, 러시아어 `ru`, 스페인어 `es`, 스페인어(멕시코) `es_MX`(고객 정의 번역은 스페인어로 기본), 스웨덴어 `sv`, 태국어 `th`(UI는 완전 번역되나 Help는 영어). |
| ManageableState | ManageableState 8값 | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 내 컴포넌트의 manageable state. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 커스텀 객체가 속한 패키지의 네임스페이스. |
| SharingModel | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 공유 모델. 값: `Edit`, `ControlledByparent`, `None`, `Read`. *(원문 ControlledByparent — 소문자 p, 원문 보존)* |

### CustomField

org에 고유한 데이터를 저장하는 커스텀 객체의 커스텀 필드를 나타낸다. Salesforce Metadata API의 연관 CustomField 객체·관련 필드 접근 포함. API 28.0 이상.

> 경계: 같은 이름의 Metadata API 타입은 [[Metadata Types — Objects & Fields]] 참조.

- **Supported SOAP Calls:** `create()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH

| Field Name | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | 커스텀 필드의 개발자 내부 이름. 예: 커스텀 필드 CF__c의 내부 이름은 CF. |
| ManageableState | ManageableState 8값 | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 내 컴포넌트의 manageable state. |
| Metadata | CustomFieldMetadata | Create, Nillable, Update | CustomFieldMetadata가 포함하는 필드(자세한 내용은 Metadata API Developer Guide의 CustomField 참조). |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 커스텀 필드의 네임스페이스. 커스텀 필드는 객체와 다른 extension 네임스페이스에 있을 수 있다. |
| TableEnumOrId | Restricted picklist | Filter, Group, Sort | 이 필드가 있는 객체의 enum(예: Account) 또는 ID. |

**CustomFieldMetadata 포함 필드** (`Metadata` 필드가 노출):
`caseSensitive`, `complianceGroup`, `defaultValue`, `deleteConstraint`, `deprecated*`, `description`, `displayFormat`, `displayLocationInDecimal`, `elementType*`, `escapeMarkup`, `externalDeveloperName`, `externalId`, `formula`, `formulaTreatBlanksAs`, `inlineHelpText`, `isAIPredictionField`, `isFilteringDisabled`, `isNameField`, `isSortingDisabled`, `label`, `length`, `maskChar`, `maskType`, `picklist`, `populateExistingRows`, `precision`, `readOnlyProxy`, `referenceTo`, `relationshipLabel`, `relationshipName`, `relationshipOrder`, `reparentableMasterDetai`, `required`, `restrictedAdminField`, `scale`, `startingNumber`, `stripMarkup`, `summarizedField`, `summaryFilterItems`, `summaryForeignKey`, `summaryOperation`, `trackFeedHistory`, `trackHistory`, `type`, `unique`, `visibleLines`, `writeRequiresMasterRead`.

> `*` (deprecated, elementType) = Reserved for future use.
> `Metadata`·`FullName` 등은 쿼리 결과가 1건 이하일 때만 쿼리(아니면 에러) — 성능 보호.
> *(원문 `reparentableMasterDetai`는 끝이 잘린 표기 — 정확한 이름은 `reparentableMasterDetail`. 원문 보존.)*

### CustomFieldMember

`MetadataContainer`에서 편집·저장할 필드의 워킹 카피(working copy)를 나타낸다. API 33.0 이상.

> 컨테이너 기반 배포 메커니즘(MetadataContainer·ContainerAsyncRequest)은 [[Tooling API 배포]] 소관 — 여기서는 CustomFieldMember sObject의 필드만 전수.

- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH, DELETE
- **Special Access Rules:** CustomFieldMember 접근에는 **View All Data** 와 **Customize Application** 유저 권한이 모두 필요.

| Field Name | Type | Properties | Description |
|---|---|---|---|
| Content | string | None | 필드 메타데이터를 담은 CustomField의 문자열 표현. |
| ContentEntityId | ID | Create, Filter, Group, Sort | 커스텀 필드에 대한 참조. CustomField당 ContentEntityId는 하나만 가능 — 아니면 에러 보고. |
| FullName | string | Group, Nillable | Metadata API의 연관 객체 full name. ID가 생기기 전 create 시 race condition 회피용. 쿼리 결과 1건 이하일 때만 쿼리(아니면 에러). |
| IsDeleted | boolean | Group, Nillable | 객체가 삭제됨으로 표시(true)됐는지. |
| LastSyncDate | dateTime | Filter, Sort | 이 CustomField가 기반 엔티티에서 복제된 날짜. |
| Metadata | CustomField | None | 해당 CustomField의 버전·상태·패키지 버전을 기술하는 객체. 쿼리 결과 1건 이하일 때만 쿼리(아니면 에러). |

### CustomFieldDisplay

product attribute 커스텀 필드에 할당된 view 타입을 나타낸다. API 63.0 이상.

> Important: 비포용적 용어를 Equality 가치에 맞춰 변경했으나 일부 용어는 유지.

- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST HTTP Methods:** DELETE, GET, HEAD, PATCH, POST, Query
- **Special Access Rules:** B2B 또는 D2C Commerce 라이선스 활성 시에만 사용 가능.

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Create, Filter, Group, Sort, Update | API 내 객체의 고유 이름. 밑줄·영숫자만, org 내 고유, 문자 시작, 공백·끝 밑줄·연속 밑줄 불가. 관리 패키지에서 명명 충돌 방지. Label은 Record Type Name. 자동 생성되나 API로 레코드 생성 시 직접 값 지정 가능. |
| DisplayType | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | product attribute 커스텀 필드의 view 타입. 값: `ColorSwatch`, `Dropdown`, `Pill`. 기본값 `Dropdown`. |
| FieldApiName | string | Create, Filter, Group, idLookup, Sort, Update | product attribute의 고유 이름. 예: color_c. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | CustomFieldDisplay의 언어. |
| ManageableState | ManageableState 8값 | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 내 컴포넌트의 manageable state. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | CustomFieldDisplay의 레이블. UI에서는 Custom Field Display. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 객체와 연관된 네임스페이스 접두. 관리 패키지를 만드는 각 Developer Edition org은 고유 접두 보유. 한도 15자. `namespacePrefix__componentName` 표기. |

### RecordType

커스텀 레코드 타입을 나타낸다. API 32.0 이상.

> 경계: 같은 이름의 Metadata API 타입은 [[Metadata Types — Objects & Fields]] 참조.

- **Supported SOAP Calls:** `create()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST HTTP Methods:** GET, PATCH, POST

| Field | Type | Properties | Description |
|---|---|---|---|
| BusinessProcessId | ID | Create, Filter, Group, Nillable, Sort, Update | 연관된 BusinessProcess의 ID. |
| Description | string | Filter, Group, Nillable, Sort | 레코드 타입 설명. 255자 제한. |
| EntityDefinitionId | string | Filter, Group, Sort | 레코드를 포함하는 엔티티의 ID. |
| FullName | string | Create, Group, Nillable | Metadata API의 연관 메타데이터 객체 full name. 쿼리 결과 1건 이하일 때만 쿼리(아니면 에러). |
| IsActive | boolean | Defaulted on create, Filter, Group, Sort, Update | 레코드 활성 여부(true). active 레코드 타입만 레코드에 적용 가능. |
| ManageableState | ManageableState 8값 | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 내 컴포넌트의 manageable state. |
| Metadata | RecordTypeMetadata | Create, Nillable, Update | 레코드 메타데이터. 쿼리 결과 1건 이하일 때만 쿼리(아니면 에러). |
| Name | string | Nillable | 레코드 타입 이름. |
| NamespacePrefix | string | Nillable | 이 타입을 다른 타입과 구별하는 고유 문자열. |
| SobjectType | string | Filter, Group, Nillable, Sort | 이 레코드 타입이 파생된 표준 객체 타입. |

### BusinessProcessDefinition

고객 라이프사이클 맵(customer lifecycle map)의 stage 정보를 나타낸다. API 51.0 이상. (세일즈 프로세스/고객 라이프사이클 도메인 개념 — stage가 라이프사이클 맵에 속한다.)

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| BusinessProcessGroupId | reference | Create, Filter, Group, Sort | stage와 연관된 고객 라이프사이클 맵의 고유 식별자. |
| DeveloperName | string | Create, Filter, Group, Sort, Update | stage의 developer name. (Note: View DeveloperName 또는 View Setup and Configuration 권한이 있는 유저만 이 필드를 보고·group·sort·filter 가능.) |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | MasterLabel의 언어. (가능 값은 Salesforce 표준 언어 enum 전체 — 아래 목록.) |
| MasterLabel | string | Create, Filter, Group, Sort, Update | stage의 레이블. |
| ProcessDescription | textarea | Create, Nillable, Update | stage 설명. |
| SequenceNumber | int | Create, Filter, Group, Sort, Update | 연관된 고객 라이프사이클 맵 내 stage의 위치. |

> **Language 가능 값(전체):** `af`(Afrikaans), `am`(Amharic), `ar`(Arabic), `ar_AE`, `ar_BH`, `ar_DZ`, `ar_EG`, `ar_IQ`, `ar_JO`, `ar_KW`, `ar_LB`, `ar_LY`, `ar_MA`, `ar_OM`, `ar_QA`, `ar_SA`, `ar_SD`, `ar_SY`, `ar_TN`, `ar_YE`, `bg`(Bulgarian), `bn`(Bengali), `bs`(Bosnian), `ca`(Catalan), `cs`(Czech), `cy`(Welsh), `da`(Danish), `de`(German), `de_AT`, `de_BE`, `de_CH`, `de_LU`, `el`(Greek), `en_AU`, `en_CA`, `en_GB`, `en_HK`, `en_IE`, `en_IN`, `en_MY`, `en_NZ`, `en_PH`, `en_SG`, `en_US`(English), `en_ZA`, `es`(Spanish), `es_AR`, `es_BO`, `es_CL`, `es_CO`, `es_CR`, `es_DO`, `es_EC`, `es_GT`, `es_HN`, `es_MX`, `es_NI`, `es_PA`, `es_PE`, `es_PR`, `es_PY`, `es_SV`, `es_US`, `es_UY`, `es_VE`, `et`(Estonian), `eu`(Basque), `fa`(Farsi), `fi`(Finnish), `fr`(French), `fr_BE`, `fr_CA`, `fr_CH`, `fr_LU`, `ga`(Irish), `gu`(Gujarati), `hi`(Hindi), `hr`(Croatian), `hu`(Hungarian), `hy`(Armenian), `in`(Indonesian), `is`(Icelandic), `it`(Italian), `it_CH`, `iw`(Hebrew), `ja`(Japanese), `ka`(Georgian), `km`(Khmer), `kn`(Kannada), `ko`(Korean), `lb`(Luxembourgish), `lt`(Lithuanian), `lv`(Latvian), `mi`(Te reo), `mk`(Macedonian), `ml`(Malayalam), `mr`(Marathi), `ms`(Malay), `mt`(Maltese), `my`(Burmese), `nl_BE`, `nl_NL`(Dutch), `no`(Norwegian), `pl`(Polish), `pt_BR`, `pt_PT`, `rm`(Romansh), `ro`(Romanian), `ro_MD`, `ru`(Russian), `sh`(Serbian Latin), `sh_ME`(Montenegrin), `sk`(Slovak), `sl`(Slovene), `sq`(Albanian), `sr`(Serbian Cyrillic), `sv`(Swedish), `sw`(Swahili), `ta`(Tamil), `te`(Telugu), `th`(Thai), `tl`(Tagalog), `tr`(Turkish), `uk`(Ukrainian), `ur`(Urdu), `vi`(Vietnamese), `xh`(Xhosa), `zh_CN`, `zh_HK`, `zh_SG`, `zh_TW`, `zu`(Zulu).

### EnrichedField

채널·채널 멤버에 대해 Change Data Capture Enrichment용으로 선택된 필드를 나타낸다. 비어 있지 않은 enriched 필드는 변경되지 않았더라도 update·delete change event에 추가된다. API 51.0 이상.

> CDC 채널·헤더 메커니즘(채널 멤버 추가 등)은 [[ChangeEventHeader]] 및 Change Data Capture Developer Guide 소관 — 여기서는 EnrichedField sObject만 다룬다.

- **Supported SOAP API Calls:** `delete()`, `describeSObjects()`, `query()`, `retrieve()`
- **Supported REST API HTTP Methods:** DELETE, GET, HEAD, Query
- **Special Access Rules:**
  - 이 객체는 Change Data Capture Enrichment의 일부다.
  - EnrichedField 객체로 enriched 필드를 query·retrieve·delete한다. enriched 필드 추가는 PlatformEventChannelMember의 일부로 수행한다(자세한 내용은 Change Data Capture Developer Guide의 "Enrich Change Events..." 및 "Example: Add Event Enrichment Fields with Tooling API").
  - retrieve/query에는 **View Setup and Configuration** 권한, delete에는 **Customize Application** 권한 필요.

| Field | Type | Properties | Description |
|---|---|---|---|
| ChannelMemberId | reference | Create, Filter, Group, Sort | 이 필드가 속한 PlatformEventChannelMember의 ID. 예: AccountChangeEvent에 필드를 추가하면 ChannelMemberId는 해당 PlatformEventChannelMember 레코드의 ID. |
| Field | picklist | Create, Filter, Group, Restricted picklist, Sort | change event를 enrich할 필드 이름. 지원 필드 타입은 Change Data Capture Developer Guide 참조. |
| ManageableState | ManageableState 8값 | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 내 컴포넌트의 manageable state. |

```sql
-- 구성된 채널 멤버·필드 조회
SELECT ChannelMemberId, Field FROM EnrichedField ORDER BY ChannelMemberId
```

---

## 관계·계층·소유자 변경

### RelationshipDomain

객체가 다른 객체와 갖는 관계를 나타낸다. 더 단순한 쿼리를 가능케 한다 — 예: "ParentSobject에 정의된 객체의 자식 객체는 무엇인가"를 RelationshipDomain으로 쉽게 표현. Tooling API 34.0 이상.

- **Supported SOAP Calls:** `query()`
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOQL Limitations (p38) / SOSL Limitations (p40)

| Field | Type | Properties | Description |
|---|---|---|---|
| ChildSobject | EntityDefinition | Filter, Group, Sort | 자식 객체의 메타데이터(있는 경우). |
| ChildSobjectId | string | Filter, Group, Nillable, Sort | ChildSobject의 ID. |
| DurableId | string | Filter, Group, Nillable, Sort | 필드의 고유 식별자. 릴리스 간 동일 보장 없음, 사용 전 항상 조회. 쿼리 단순화에 사용. |
| Field | FieldDefinition | Filter, Group, Sort | ChildSobject 또는 ParentSobject로의 관계를 정의하는 이 객체의 관계 필드. |
| FieldId | string | Filter, Group, Nillable, Sort | Field의 ID. |
| IsCascadeDelete | boolean | Defaulted on create, Filter, Group, Sort | true면 이 객체의 모든 레코드가 삭제될 때까지 부모를 삭제할 수 없다. Metadata API의 DeleteConstraint Cascade 값에 대응. |
| IsDeprecatedAndHidden | boolean | Defaulted on create, Filter, Group, Sort | true면 현재 버전에서 사용 불가. |
| IsRestrictedDelete | boolean | Defaulted on create, Filter, Group, Sort | true면 이 객체를 삭제할 수 없다. Metadata API의 DeleteConstraint Restrict 값에 대응. |
| JunctionIdListNames | complexvalue | Nillable | 객체와 연관된 junction ID 목록들의 이름. 각 ID는 연관 객체와 관계 있는 객체를 나타낸다. |
| ParentSobject | EntityDefinition | Filter, Group, Sort | 부모 객체의 메타데이터(있는 경우). |
| ParentSobjectId | string | Filter, Group, Nillable, Sort | ParentSobject의 ID. |
| RelationshipInfo | RelationshipInfo | Filter, Group, Sort | 관계에 대한 속성. |
| RelationshipInfoId | string | Filter, Group, Nillable, Sort | 이 relationship domain의 RelationshipInfo ID. |
| RelationshipName | string | Filter, Group, Nillable, Sort | 이 관계의 이름. |

### RelationshipInfo

객체 간 관계의 속성을 나타낸다. RelationshipInfo로 쿼리를 단순화 — 예: "ChildSobject에 정의된 객체의 부모 객체는 무엇인가"에 답하기 쉽다. Tooling API 34.0 이상.

- **Supported SOAP Calls:** `query()`, `search()`
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOQL Limitations (p38) / SOSL Limitations (p40)

| Field | Type | Properties | Description |
|---|---|---|---|
| ChildSobject | EntityDefinition | Filter, Group, Sort | 자식 객체의 메타데이터(있는 경우). |
| ChildSobjectId | string | Filter, Group, Nillable, Sort | ChildSobject의 ID. |
| DurableId | string | Filter, Group, Nillable, Sort | 필드의 고유 식별자. 릴리스 간 동일 보장 없음, 사용 전 항상 조회. 쿼리 단순화에 사용. |
| Field | FieldDefinition | Filter, Group, Sort | ChildSobject 또는 ParentSobject로의 관계를 정의하는 관계 필드. |
| FieldId | string | Filter, Group, Nillable, Sort | Field의 ID. |
| IsCascadeDelete | boolean | Defaulted on create, Filter, Group, Sort | true면 이 객체의 모든 레코드가 삭제될 때까지 부모를 삭제할 수 없다. DeleteConstraint Cascade에 대응. |
| IsDeprecatedAndHidden | boolean | Defaulted on create, Filter, Group, Sort | true면 현재 버전에서 사용 불가. |
| IsRestrictedDelete | boolean | Defaulted on create, Filter, Group, Sort | true면 이 객체를 삭제할 수 없다. DeleteConstraint Restrict에 대응. |
| JunctionIdListNames | complexvalue | Nillable | 객체와 연관된 junction ID 목록들의 이름. 각 ID는 연관 객체와 관계 있는 객체를 나타낸다. |
| RelationshipDomains | QueryResult | Filter, Group, Sort | 이 객체와 연관된 RelationshipDomain 레코드. 관계 필드이므로 서브쿼리 전용. |

### ObjectHierarchyRelationship

input source 객체와 output target 객체 간의 매핑을 나타낸다. 예: 세일즈 quote를 세일즈 agreement로 변환하는 매핑 정보. API 56.0 이상.

> Important: 비포용적 용어를 Equality 가치에 맞춰 변경했으나 코드 변경이 기존 구현을 깨뜨릴 수 있어 이 객체 이름은 유지.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | object hierarchy relationship 레코드의 고유 이름. 밑줄·영숫자만, org 내 고유, 문자 시작, 공백·끝 밑줄·연속 밑줄 불가. Label은 Record Type Name. 자동 생성되나 API로 레코드 생성 시 직접 값 지정 가능. (Note: 대량 데이터 생성 시 각 레코드에 고유 DeveloperName을 지정 — 미지정 시 Salesforce가 생성하느라 성능 저하 가능.) |
| FullName | string | Create, Group, Nillable | Metadata API의 연관 object hierarchy relationship 레코드 full name. 쿼리 결과 1건 이하일 때만 쿼리(아니면 에러). |
| InputObjRecordsGrpFieldName | string | Filter, Group, Nillable, Sort | 레코드를 그룹화하는 input 객체의 필드 이름. |
| Language | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | ObjectHierarchyRelationship의 언어. |
| MappingType | picklist | Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort | source와 target 객체 간 관계 타입. 값: `ChildToChild`(Child to Child), `ParentToChild`(Parent to Child), `ParentToParent`(Parent to Parent), `Support`. 기본값 `ParentToParent`. |
| MasterLabel | string | Filter, Group, Sort | ObjectHierarchyRelationship 레코드의 레이블. |
| Metadata | complexvalue | Create, Nillable, Update | ObjectHierarchyRelationship의 메타데이터. 쿼리 결과 1건 이하일 때만 쿼리(아니면 에러). |
| OutputPntRelationshipFieldName | string | Filter, Group, Nillable, Sort | output 객체의 자식-부모 관계를 지정. |
| ParentRecordId | reference | Filter, Group, Nillable, Sort | 부모 객체 매핑 레코드의 ID. 관계 필드. Relationship Name: `ParentRecord`, Relationship Type: Lookup, Refers To: ObjectHierarchyRelationship. |
| ParentRelationshipFieldName | string | Filter, Group, Nillable, Sort | 부모-자식 관계를 정의하는 필드 이름. |
| SourceReferenceRelaFieldName | string | Filter, Group, Nillable, Sort | input·output 객체 간 관계를 정의하는 필드 이름. |
| UsageType | picklist | Filter, Group, Restricted picklist, Sort | usage 타입. 값: `CLMFieldMapping`, `ConvertToSalesAgreement`, `EligibleProgramRebateType`, `MapJournalToMemberAggregate`, `TransformationMapping`. |

### OwnerChangeOptionInfo

레코드 소유자 변경 시 수행 가능한 기본·선택 action을 나타낸다. Tooling API 35.0 이상.

- **Supported SOAP Calls:** `describeSObjects()`, `query()`
- **Supported REST HTTP Methods:** Query
- **Special Access Rules:** View Setup and Configuration 권한이 있는 user profile에 Tooling API로 접근 가능.

| Field | Type | Properties | Description |
|---|---|---|---|
| DefaultValue | boolean | Defaulted on create, Filter, Group, Sort | UI에서 이 옵션 checkbox의 기본값. |
| DurableId | string | Filter, Group, Nillable, Sort | 필드의 고유 식별자. 릴리스 간 동일 보장 없음, 사용 전 항상 조회. 쿼리 단순화에 사용. |
| EntityDefinition | EntityDefinition | Filter, Group, Sort | 이 변경이 적용되는 객체. |
| EntityDefinitionId | string | Filter, Group, Nillable, Sort | 레코드를 포함하는 EntityDefinition의 ID. |
| IsEditable | boolean | Defaulted on create, Filter, Group, Sort | OwnerChangeOptions SOAP 헤더로 소유자 업데이트 시 유저가 이 옵션을 편집할 수 있는지. |
| Label | string | Filter, Group, Nillable, Sort | UI에서 옵션에 대응하는 레이블. |
| Name | string | Filter, Group, Nillable, Sort | 옵션의 고유 이름. |
| ParentId | string | Filter, Group, Nillable, Sort | 부모 OwnerChangeOptionInfo 레코드의 durable ID. Tooling API 44.0 이상. |

---

## 룩업 필터·필드 셋·값 집합·매핑

### LookupFilter

lookup·master-detail·hierarchical 관계 필드의 유효 값과 lookup dialog 결과를 제한하는 룩업 필터를 나타낸다. Tooling API 34.0 이상.

> Important: 비포용적 용어를 Equality 가치에 맞춰 변경했으나 일부 용어는 유지.
> Note: LookupFilter는 article type 객체에서 미지원.

- **Supported SOAP Calls:** `query()`
- **Supported REST HTTP Methods:** GET

| Field Name | Type | Properties | Description |
|---|---|---|---|
| Active | boolean | Defaulted on create, Filter, Group, Sort | true면 룩업 필터가 active. |
| DeveloperName | string | Filter, Group, Namefield, Sort | API 내 객체의 고유 이름. 밑줄·영숫자만, org 내 고유, 문자 시작, 공백·끝 밑줄·연속 밑줄 불가. Label은 Record Type Name. |
| FullName | string | Filter, Group, Sort | Metadata API의 연관 메타데이터 객체 full name. 쿼리 결과 1건 이하일 때만 쿼리(아니면 에러). |
| IsOptional | boolean | Defaulted on create, Filter, Group, Sort | Required. true면 룩업 필터가 optional. |
| ManageableState | ManageableState 8값 | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 내 컴포넌트의 manageable state. |
| Metadata | LookupFilter | Create, Nillable, Update | 이 룩업 필터의 메타데이터. 쿼리 결과 1건 이하일 때만 쿼리(아니면 에러). |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 커스텀 필드의 네임스페이스(객체 네임스페이스와 다를 수 있음). |
| SourceFieldDefinition | string | Filter, Group, Sort | 이 필터가 적용되는 필드. |
| SourceFieldDefinitionId | string | Filter, Group, Sort | SourceFieldDefinition에 지정된 객체의 durable ID. |
| SourceObject | string | Filter, Group, Sort | 이 룩업 필터를 사용하는 룩업 필드를 포함하는 객체. 룩업 필터가 source 객체의 필드를 참조하지 않으면 null. |
| TargetEntityDefinition | EntityDefinition | Filter, Group, Sort | source 룩업 필드의 entity definition. |
| TargetEntityDefinitionId | string | Filter, Group, Sort | TargetEntityDefinition의 ID. |

> Example: Account의 Owner 필드는 특정 특성을 가진 user를 나타낸다. 이 경우 SourceFieldDefinition은 Account.Owner, TargetEntityDefinition은 User(Owner가 User로의 룩업 필드이므로).

**LookupFilter Metadata** — `Metadata` 필드에 반환되는 메타데이터.

| Field | Type | Description |
|---|---|---|
| active | boolean | Required. true면 룩업 필터가 active. |
| booleanFilter | string | Boolean 연산자(AND, OR, NOT)로 이 필터에 적용된 필터 로직(있는 경우). |
| description | string | 필터 설명. *(원문: "A description of the filter does." — 문장이 어색하나 원문 보존.)* |
| errorMessage | string | 룩업 필터 실패 시 에러 메시지. *(원문: "the error m." — 끝이 잘림. 원문 보존.)* |
| filterItems | FilterItem | Required. 필터 조건 집합. 각 룩업 필터는 최대 10개의 FilterItem을 가질 수 있다. |
| infoMessage | string | 유저를 돕기 위해 페이지에 표시되는 정보(예: 룩업 필터에서 일부 항목이 제외된 이유 설명). |
| isOptional | boolean | Required. true면 룩업 필터가 optional. |

**FilterItem Metadata** — 필터 조건 집합의 한 항목.

| Field | Type | Description |
|---|---|---|
| field | string | 필터에 지정된 필드. |
| operation | FilterOperation (문자열 enum) | 값: `equals`, `notEqual`, `lessThan`, `greaterThan`, `lessOrEqual`, `greaterOrEqual`, `contains`, `notContain`, `startsWith`, `includes`, `excludes`, `within`(DISTANCE 기준 전용). |
| value | string | 연산 대상 필터 항목의 값. 예: 필터가 `my_number_field__c > 1`이면 이 필드 값은 1. |
| valueField | string | 필터의 마지막 컬럼이 필드인지 필드 값인지 지정. Approval process는 필터 기준에서 이 필드를 미지원. |

### FieldSet

필드 그룹의 메타데이터를 나타낸다. API 33.0 이상.

> 경계: 같은 이름의 Metadata API 타입은 [[Metadata Types — Objects & Fields]] 참조.

- **Supported SOAP Calls:** `create()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST HTTP Methods:** GET, HEAD

| Field | Type | Properties | Description |
|---|---|---|---|
| Description | string | Filter, Group, Nillable, Sort | field set 설명. set 생성 이유·용도 기술에 유용. |
| DeveloperName | string | Filter, Group, Sort | field set의 API 이름. |
| ManageableState | ManageableState 8값 | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 내 컴포넌트의 manageable state. |
| MasterLabel | string | Filter, Group, Sort | set의 레이블. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | field set이 속한 패키지의 네임스페이스. |

### GlobalValueSet

global picklist가 사용하는 값 집합을 나타낸다. API 39.0 이상.

> Important: 비포용적 용어를 Equality 가치에 맞춰 변경했으나 일부 용어는 유지.

- **Supported SOAP Calls:** `create()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`
- **Supported REST HTTP Methods:** Query, GET, POST, PATCH

| Field Name | Type | Properties | Description |
|---|---|---|---|
| CustomValue | CustomValue[] | Filter, Group, Sort | global picklist 값 목록. |
| Description | string | Filter, Nillable, Sort | picklist 값 설명. 생성 이유 추적에 유용. 255자 제한. |
| FullName | string | Create, Group, Nillable | Metadata API의 연관 메타데이터 객체 full name. 쿼리 결과 1건 이하일 때만 쿼리(아니면 에러). **API 57.0 이상**에서 생성된 global value set은 FullName에 자동으로 `__gvs` 접미가 붙는다. GlobalValueSet 타입으로 CRUD 호출 시 타입 참조에 이 접미를 붙여야 한다. |
| MasterLabel | string | Filter, Group, Sort | *(원문에 Description 본문 비어 있음 — 원문 보존.)* |
| Sorted | boolean | Filter, Group, Sort | true면 picklist 값이 알파벳순 정렬. |

**CustomValue Metadata** — global value set 메타데이터가 `CustomValue` 필드에 반환된다.

| Field | Type | Description |
|---|---|---|
| Color | string | 리포트·대시보드 차트에서 picklist 값에 할당된 색(16진수, 예: #FF6600). 미지정 시 차트 생성 시 동적 할당. |
| Default | boolean | Required. 이 값이 global picklist 및 그 값 집합을 공유하는 커스텀 picklist의 기본 선택인지. 기본값 true. |
| Description | string | picklist 값 설명. 생성 이유 추적에 유용. 255자 제한. |
| IsActive | boolean | 값의 active/inactive 여부. 기본값 true. 유저는 active 값만 선택 가능. global picklist 값의 API retrieve는 active·inactive 값을 모두 반환하나, 비-global·unrestricted picklist는 active 값만 반환. |
| Label | string | global picklist 값의 레이블(API 이름). 생성 시 레이블 미지정이면 picklist 값(ValueName) 텍스트로 기본 설정. 레이블 업데이트 시 ValueName은 사용 안 됨. |
| ValueName | string | picklist 값의 텍스트. |

### FieldMapping

org 내 객체 필드와 data service 필드 간의 매핑을 나타낸다. data service는 두 개의 별도 field map을 사용한다: 하나는 객체에서 레코드를 매칭하는 방식, 다른 하나는 기존 레코드에 데이터를 추가·업데이트하는 방식을 제어. API 38.0 이상.

> data service 변형(FSL CleanRule 등)은 [[Field Service Metadata·Tooling API]] 노트가 권위 — 여기서는 기반 FieldMapping/FieldMappingField/FieldMappingRow sObject만 전수.

- **Supported SOAP Calls:** `query()`, `search()`
- **Supported REST HTTP Methods:** GET

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Create, Filter, Group, Sort, Update | 이 FieldMapping의 고유 이름. 밑줄·영숫자만, org 내 고유, 문자 시작, 공백·끝 밑줄·연속 밑줄 불가. 동일 MasterLabel을 가진 다른 패키지의 FieldMapping과 충돌 방지를 위한 전역 고유 식별자 제공. (Note: View DeveloperName 또는 View Setup and Configuration 권한 유저만 view·group·sort·filter 가능.) |
| FieldMappingClientId | reference | Create, Filter, Group, Sort, Update | 이 FieldMapping을 사용하는 CleanRule에 대한 foreign key 참조. |
| Language | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | FieldMapping의 언어. 지원 값: `zh_CN`, `zh_TW`, `da`, `nl_NL`, `en_US`, `fi`, `fr`, `de`, `it`, `ja`, `ko`, `no`, `pt_BR`, `ru`, `es`, `es_MX`(고객 정의 번역은 스페인어 기본), `sv`, `th`(UI는 완전 번역되나 Help는 영어). |
| MasterLabel | string | Create, Filter, Group, Sort, Update | 이 객체의 master 레이블. 번역되지 않는 내부 표시 값. |
| SobjectType | picklist | Create, Filter, Group, Restricted picklist, Sort | 이 FieldMapping이 작용하는 객체. picklist 값 집합은 org의 모든 표준·커스텀 객체 타입을 포함. 단 data service가 지원하지 않는 객체를 지정하면 API 호출이 에러 반환. |

### FieldMappingField

org 객체에서 data service 필드에 매핑되는 필드를 나타낸다. API 38.0 이상.

- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST HTTP Methods:** GET

| Field | Type | Properties | Description |
|---|---|---|---|
| DataServiceField | string | Create, Filter, Group, Nillable, Sort, Update | 이 FieldMappingField에 매핑되는 data service 필드의 표시 이름. |
| FieldMappingRowId | reference | Create, Filter, Group, Sort | 이 FieldMappingField 객체와 연관된 객체의 foreign key. |
| DataServiceObjectName | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort | 이 FieldMappingField가 나타내는 필드를 포함하는 data service 객체. picklist 값 집합은 data service에 정의된 모든 객체 타입을 포함. 존재하지 않는 객체 지정 시 API 호출이 에러 반환. |
| Priority | int | Create, Filter, Group, Nillable, Sort, Update | data service가 필드 업데이트 시 사용하는 우선순위(같은 필드의 다른 update 규칙 대비). |

### FieldMappingRow

data service 레코드의 필드가 org 객체 레코드의 필드에 매핑되는 것을 나타낸다. API 38.0 이상.

- **Supported SOAP Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST HTTP Methods:** GET

| Field | Type | Properties | Description |
|---|---|---|---|
| FieldMappingID | reference | Create, Filter, Group, Sort | 이 FieldMappingRow의 부모 FieldMapping에 대한 foreign key 참조. |
| FieldName | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort, Update | picklist 값 집합은 org의 모든 표준·커스텀 객체 타입을 포함. |
| Operation | picklist | Create¹, Defaulted on create¹, Filter, Group, Nillable¹, Restricted picklist¹, Sort, Update¹ | data service가 이 FieldMappingRow 값을 SObjectType에 지정된 객체의 매핑 필드와 비교할 때 적용하는 비교 연산. 지원 값: `Autofill`(빈 필드를 채우고 데이터가 있는 필드는 값 유지), `Overwrite`(빈 필드를 채우고 데이터가 있는 필드도 업데이트 — Overwrite 필드는 history tracking 필요). ¹ = reserved for future use. |
| SobjectType | picklist | CreateFilter, Group, Nillable, Restricted picklist, Sort | 이 FieldMappingRow가 매핑하는 필드를 포함하는 org의 표준/커스텀 객체. picklist 값 집합은 org의 모든 표준·커스텀 객체 타입 포함. data service 미지원 객체 지정 시 API 호출이 에러 반환. *(원문 Properties "CreateFilter" — Create와 Filter 사이 쉼표 누락으로 보임. 원문 보존.)* |

---

## 빅오브젝트 인덱스

### Index

custom big object 내에 정의된 인덱스를 나타낸다. Tooling API 41.0 이상.

- **Supported SOAP Calls:** `query()`, `retrieve()`
- **Supported REST HTTP Methods:** Query, GET
- **Limitations:** SOQL Limitations (p38) / SOSL Limitations (p40)

| Field | Type | Properties | Description |
|---|---|---|---|
| DeveloperName | string | Filter, Group, Sort | API 내 레코드의 고유 이름. 밑줄·영숫자만, org 내 고유, 문자 시작, 공백·끝 밑줄·연속 밑줄 불가. 자동 생성되나 API로 레코드 생성 시 직접 값 지정 가능. |
| Label | string | Filter, Group, Nillable, Sort | UI에서 big object를 참조하는 이름. API 41.0 이상. |
| ManageableState | ManageableState 8값 | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 내 컴포넌트의 manageable state. |
| MasterLabel | string | Filter, Group, Sort | Index의 master 레이블. 번역되지 않는 내부 레이블. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | 이 타입을 다른 타입과 구별하는 고유 문자열. |
| SobjectType | picklist | Filter, Group, Restricted picklist, Sort | 이 레코드 타입이 파생된 표준 객체 타입. 여기서는 부모 big object. |
| Type | picklist | Filter, Group, Restricted picklist, Sort | 인덱스 타입. 값: `PRIMARY` 또는 `SECONDARY`. |

### IndexField

custom big object의 인덱스 내 필드를 나타낸다. Tooling API 41.0 이상.

- **Supported SOAP Calls:** `query()`, `retrieve()`
- **Supported REST HTTP Methods:** GET
- **Limitations:** SOQL Limitations (p38) / SOSL Limitations (p40)

| Field | Type | Properties | Description |
|---|---|---|---|
| FieldId | reference | Filter, Group, Sort | 커스텀 필드 정의의 ID. |
| Id | ID | Filter, Group, Sort | 커스텀 인덱스 필드의 ID. |
| IndexId | reference | Filter, Group, Sort | 커스텀 인덱스의 ID. |
| ManageableState | ManageableState 8값 | Filter, Group, Nillable, Restricted picklist, Sort | 패키지 내 컴포넌트의 manageable state. |
| Ordinal | int | Filter, Group, Sort | 인덱스 내 필드 위치. 인덱스 내 필드 순서 결정에 사용. |
| SortDirection | picklist | Filter, Group, Restricted picklist, Sort | 인덱스 내 필드의 정렬 방향. 값: `ASC`(오름차순), `DESC`(내림차순). |

---

## 수식 함수·연산자

### FormulaFunction

수식 빌드 시 사용하는 함수(예제·용법 포함)를 나타낸다. Tooling API 39.0 이상.

- **Supported SOAP Calls:** `describeSObjects()`, `query()`
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** API 45.0 이상에서는 ViewSetup and Configuration 권한 유저만 FormulaFunction 또는 FormulaFunctionCategory에 접근 가능.

| Field | Type | Properties | Description |
|---|---|---|---|
| Category | FormulaFunctionCategory | Filter, Group, Nillable, Sort | 수식이 속한 FormulaFunctionCategory. |
| CategoryId | string | Filter, Group, Nillable, Sort | FormulaFunctionCategory의 ID. |
| Description | string | Filter, Group, Nillable, Sort | 수식 함수 설명. |
| DurableId | string | Filter, Group, Nillable, Sort | 필드의 고유 식별자. 릴리스 간 동일 보장 없음, 사용 전 항상 조회. 쿼리 단순화에 사용. |
| ExampleString | string | Filter, Group, Nillable, Sort | 함수와 사용 가능한 인자를 설명. |
| IsAllowedInEntityContext | boolean | Filter, Group, Nillable, Sort | **Removed.** Entity에서 함수 사용 가능(true) 여부. 예: 커스텀 Account 수식 필드에서 PRIORVALUE 사용 불가. API 39.0~47.0에서만 제공. 48.0 이상은 FormulaFunctionAllowedType 사용. |
| IsAllowedInFlowContext | boolean | Filter, Group, Nillable, Sort | **Removed.** 수식 함수가 Flow에서 허용(true) 여부. API 39.0~47.0에서만 제공. 48.0 이상은 FormulaFunctionAllowedType 사용. |
| IsAllowedInVisualforceContext | boolean | Filter, Group, Nillable, Sort | **Removed.** 수식 함수가 Visualforce에서 허용(true) 여부. API 39.0~47.0에서만 제공. 48.0 이상은 FormulaFunctionAllowedType 사용. |
| Label | string | Filter, Group, Nillable, Sort | UI에 표시되는 수식 함수 레이블. |
| Name | string | Filter, Group, Nillable, Sort | 수식 함수의 이름. |
| Types | QueryResult | Filter, Group, Nillable, RestrictedPicklist, Sort | 함수에 허용되는 수식 타입. Tooling API 48.0 이상. |

**FormulaFunctionCategory**

| Field Name | Type | Properties | Description |
|---|---|---|---|
| DurableId | string | Filter, Group, Nillable, Sort | 필드의 고유 식별자. 릴리스 간 동일 보장 없음, 사용 전 항상 조회. 쿼리 단순화에 사용. |
| Functions | QueryResult | Filter, Group, Nillable, Sort | FormulaFunctionCategory에 속한 함수 목록. |
| Label | string | Filter, Group, Nillable, Sort | UI에 표시되는 FormulaFunctionCategory 레이블. |
| Name | string | Filter, Group, Nillable, Sort | FormulaFunctionCategory의 이름. |

```apex
// REST: FormulaFunction의 모든 함수 가져오기
req.setEndpoint('http://instance.salesforce.com/services/data/v67.0/tooling/query?q=SELECT+label+FROM+FormulaFunction');
req.setMethod('GET');
```

```sql
-- 함수 카테고리의 DurableID 가져오기 (SOQL)
SELECT DurableID FROM FormulaFunctionCategory

-- 모든 카테고리와 그 함수 가져오기 (SOQL)
SELECT Name, Label, (SELECT Name, Label, Description, ExampleString FROM Functions) FROM FormulaFunctionCategory
```

### FormulaFunctionAllowedType

주어진 수식 컨텍스트에서 지원되는 함수를 나타낸다. API 48.0 이상. (39.0~47.0의 `FormulaFunction.IsAllowedIn*Context` 필드를 대체.)

- **Supported SOAP Calls:** `describeSObjects()`, `query()`
- **Supported REST HTTP Methods:** GET
- **Special Access Rules:** ViewSetup and Configuration 권한 유저만 접근 가능.

| Field | Type | Properties | Description |
|---|---|---|---|
| DurableId | string | Filter, Group, Nillable, Sort | 필드의 고유 식별자. 릴리스 간 동일 보장 없음, 사용 전 항상 조회. 쿼리 단순화에 사용. |
| FunctionId | string | Filter, Group, Nillable, Sort | 지원되는 함수의 고유 식별자. |
| Type | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 함수가 지원되는 수식 타입의 이름. 값: `FLOW`, `VALIDATION`, `VISUALFORCE`. |

### FormulaOperator

수식 빌드 시 사용하는 연산자(예제·용법 포함)를 나타낸다. Tooling API 39.0 이상.

> Note: API 45.0 이상에서는 "ViewSetup and Configuration" 권한 유저만 FormulaOperator에 접근 가능.

- **Supported SOAP Calls:** `query()`
- **Supported REST HTTP Methods:** GET

| Field | Type | Properties | Description |
|---|---|---|---|
| DurableId | string | Filter, Group, Nillable, Sort | 필드의 고유 식별자. 릴리스 간 동일 보장 없음, 사용 전 항상 조회. 쿼리 단순화에 사용. |
| Label | string | Filter, Group, Nillable, Sort | UI에 표시되는 수식 연산자 레이블. |
| Name | string | Filter, Group, Nillable, Sort | 수식 연산자의 이름. |
| Value | string | Filter, Group, Nillable, Sort | 수식 연산자의 값. |

```apex
// REST: FormulaOperator의 모든 연산자 가져오기
req.setEndpoint('http://instance.salesforce.com/services/data/v67.0/tooling/query?q=SELECT+name,+label,+value+FROM+FormulaOperator');
req.setMethod('GET');

// REST: ID로 연산자 가져오기
req.setEndpoint('http://instance.salesforce.com/services/data/v67.0/tooling/query?q=SELECT+name,+label,+value+FROM+FormulaOperator+WHERE+durableId=\'PLUS\'');
req.setMethod('GET');
```

---

## 제거된 객체

### ServiceFieldDataType

**API 34.0에서 deprecated, API 58.0 이상에서 제거됨.**

> ServiceFieldDataType 객체는 v34.0에서 deprecated되었고 v58.0 이상에서는 제거되었다. 현재 버전(v67.0)에서는 **필드표·Supported Calls가 존재하지 않는다** — PDF에 deprecation 문구만 남아 있어 이력 참고용 스텁으로만 보존한다.

---

## 관련 노트

- [[Tooling API — 개요·REST·SOAP 호출 기초]] — 폴더 허브. REST/SOQL 쿼리 리소스·헤더·composite·EOL 등 호출 기초.
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 객체↔네임스페이스 분류, SOQL/SOSL 한도, System Fields, ApiFault.
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — 형제 Ch4 도메인 노트(Apex 코드·테스트 sObject 군).
- [[Metadata Types — Objects & Fields]] — 같은 이름의 Metadata API **타입**(CustomField·CustomObject·RecordType·FieldSet 등) 카탈로그. 본 노트는 Tooling **sObject**(SOQL 조회), 그쪽은 배포용 declarative metadata.
- [[ChangeEventHeader]] — EnrichedField의 상위 도메인인 Change Data Capture(채널·헤더) 메커니즘.
