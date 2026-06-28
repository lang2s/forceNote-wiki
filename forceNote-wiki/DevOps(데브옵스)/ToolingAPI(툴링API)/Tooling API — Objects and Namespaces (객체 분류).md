---
tags: [tooling-api, devops, soql, sosl, namespace, system-fields, apifault, metadata]
source: api_tooling.pdf v67.0 (Summer '26) — Ch3 Tooling API Objects and Namespaces
created: 2026-06-27
aliases: [Tooling API Namespaces, 네임스페이스 분류, Tooling API WSDL Namespaces, System Fields, ApiFault, SOQL Operation Limitations, SOSL Operation Limitations, Programming Objects, Setup Objects, Tooling Objects, Operational Objects]
---

# Tooling API — Objects and Namespaces (객체 분류)

> Tooling API 객체의 WSDL 네임스페이스 4종과, 객체를 기능별로 묶은 네임스페이스 4분류(Programming·Setup·Tooling·Operational) 색인. 더불어 대부분 객체에 공통으로 나타나는 System Fields, SOQL/SOSL 연산 제약, 활성 org에서의 CRUD 제약, ApiFault 요소를 정리한다.

> 이 노트는 Ch4 개별 객체 레퍼런스의 **분류 색인** 역할을 한다. 각 객체의 필드표·Supported SOAP Calls·REST Methods 상세는 후속 Tooling API 객체 노트(작성 예정)를 참조한다. 분류 목록에 나열된 객체명은 색인 항목이며, 일부 객체(컨테이너 배포 패밀리·디버그/로그 패밀리 등)의 상세는 별도 위임 노트가 권위를 가진다(맨 아래 `## 관련 노트` 참조).

---

## WSDL 네임스페이스 4종

Tooling API 객체는 데이터와 메타데이터에 프로그래밍 방식으로 접근하게 해준다. Tooling API WSDL은 네임스페이스 4개를 포함한다.

| Namespace | Used for | Prefix |
|---|---|---|
| `sobject.tooling.soap.sforce.com` | Tooling API sObjects. 일부 sObject는 `mns` 네임스페이스에 정의된 Metadata 필드를 가진다. 이 네임스페이스는 API version 37.0 이상에서 사용 가능. | `ens` |
| `fault.tooling.soap.sforce.com` | Tooling API error codes. 이 네임스페이스는 API version 37.0 이상에서 사용 가능. | `fns` |
| `tooling.soap.sforce.com` | General complex types, describe results, 그리고 Tooling API의 모든 enum types. | `tns` |
| `metadata.tooling.soap.sforce.com` | Metadata API WSDL과 Tooling API WSDL 양쪽에 모두 나타나는 객체·타입. 두 WSDL에서 요소가 다르게 정의될 수 있다. | `mns` |

**문서 위치 규칙 (원문 callout):**
- Tooling API와 Metadata API WSDL에서 **identical(동일)**한 객체·타입은 **Metadata API Developer Guide**에 문서화된다.
- Tooling API WSDL에서 **different(다르거나)** Tooling API에만 **occur only(존재)**하는 객체·타입은 이 가이드(Tooling API Developer Guide)에 문서화된다.
- 자주 나타나는 system field는 아래 [System Fields](#system-fields) 참조(원문: System Fields on page 41).
- 한 객체의 전체 필드 목록은 org의 Tooling API WSDL을 생성·검토해 확인할 수 있다.

---

## 네임스페이스 4분류 객체 목록

> 아래 목록 순서는 PDF 원문 그대로(알파벳 정렬 아님). 각 객체의 상세 필드는 Ch4 개별 객체 노트 소관.

### Programming Objects (14)

프로그래밍 산출물(Apex, Visualforce, Lightning)과 상호작용하는 객체.

| # | 객체 | 설명 |
|---|---|---|
| 1 | ApexClass | Apex 클래스의 저장본(saved copy). 사용 불가한 경우를 제외하면 캐시된 버전을 사용. |
| 2 | ApexClassMember | MetadataContainer 안에서 편집·저장·컴파일하기 위한 Apex 클래스의 working copy. |
| 3 | ApexComponent | Visualforce 컴포넌트의 저장본. 사용 불가한 경우를 제외하면 캐시된 버전을 사용. |
| 4 | ApexComponentMember | MetadataContainer 안에서 편집·저장·컴파일하기 위한 Visualforce 컴포넌트의 working copy. |
| 5 | ApexPage | Visualforce 페이지의 저장본. 사용 불가한 경우를 제외하면 캐시된 버전을 사용. |
| 6 | ApexExecutionOverlayAction | Apex 클래스/트리거의 특정 라인에서 실행할 Apex 코드 스니펫이나 SOQL 쿼리를 지정. 선택적으로 heap dump 생성. |
| 7 | ApexPageMember | MetadataContainer 안에서 편집·저장·컴파일하기 위한 Visualforce 페이지의 working copy. |
| 8 | ApexTrigger | Apex 트리거의 저장본. 사용 불가한 경우를 제외하면 캐시된 버전을 사용. |
| 9 | ApexTriggerMember | MetadataContainer 안에서 편집·저장·컴파일하기 위한 Apex 트리거의 working copy. |
| 10 | AuraDefinition | 컴포넌트 markup·client-side controller·event 같은 Aura 컴포넌트 정의. |
| 11 | AuraDefinitionBundle | Lightning Aura 컴포넌트 정의 번들(컴포넌트나 애플리케이션 번들). 번들은 Aura 컴포넌트 정의와 관련 리소스 전체를 포함. |
| 12 | LightningComponentBundle | Lightning web component 번들. 번들은 LWC와 관련 리소스를 포함. |
| 13 | LightningComponentResource | HTML markup·JavaScript·CSS·SVG·XML 구성 파일 같은 LWC 리소스. |
| 14 | StaticResource | 편집·저장을 위한 정적 리소스 파일의 working copy. 이미지·스타일시트·JavaScript 등 Visualforce 페이지에서 참조할 콘텐츠를 업로드. |

### Setup Objects (57)

선언적(declarative) 개발을 위한 메타데이터와 상호작용하는 객체. 예를 들어 자체 Setup 버전을 만들거나, 모바일에 푸시할 데이터 양을 제한할 수 있다.

| # | 객체 | 설명 |
|---|---|---|
| 1 | AuthorizedEmailDomain | 이메일 검증을 위한 인증 도메인. |
| 2 | BusinessProcess | 비즈니스 프로세스. |
| 3 | CleanDataService | org의 기존 레코드에 데이터를 추가·갱신하는 data service. |
| 4 | CleanRule | data service가 기존 레코드에 데이터를 추가·갱신하는 방식을 제어하는 데이터 통합 규칙. |
| 5 | CompactLayout | compact page layout을 정의하는 값. |
| 6 | CompactLayoutInfo | 커스텀/표준 compact layout의 메타데이터. |
| 7 | CompactLayoutItemInfo | compact layout에 선택된 필드와 compact layout 내 그 필드의 순서. |
| 8 | CustomField | org 고유 데이터를 저장하는 커스텀 객체의 커스텀 필드. |
| 9 | CustomFieldMember | MetadataContainer 안에서 편집·저장하기 위한 필드의 working copy. |
| 10 | CustomObject | org 고유 데이터를 저장하는 커스텀 객체. 연관된 Salesforce Metadata API의 CustomObject 객체·관련 필드 접근 포함. |
| 11 | CustomTab | 커스텀 탭. |
| 12 | DataAssessmentConfigItem | data assessment를 위한 특정 vendor 패키지의 저장된 구성. |
| 13 | DataIntegrationRecordPurchasePermission | Salesforce admin이 사용자에게 부여한 Lightning Data 구매 크레딧. |
| 14 | DuplicateJobDefinition | 글로벌하게 중복 레코드 항목을 식별하는 작업을 정의하는 Setup 객체. |
| 15 | DuplicateJobMatchingRuleDefinition | 하나의 DuplicateJobDefinition을 공유하는 DuplicateJob 인스턴스와 함께 사용할 MatchingRule을 지정하는 Setup 객체. |
| 16 | Document | 사용자가 업로드한 파일. Attachment 레코드와 달리 부모 객체에 첨부되지 않음. |
| 17 | EmailTemplate | 이메일·mass email·list email·HVS email용 템플릿. |
| 18 | EntityDefinition | 표준·커스텀 객체에 대한 메타데이터에 row 기반 접근 제공. |
| 19 | EntityLimit | Setup UI에 표시되는 객체의 한도. |
| 20 | FieldDefinition | 표준·커스텀 필드. 필드 메타데이터에 row 기반 접근 제공. UI에 표현될 수 있는 필드 요소 각각을 나타내는 EntityParticle와 대비됨. metadata type Field와 parity를 가짐. |
| 21 | FieldMapping | org의 객체 필드와 data service 필드 간 매핑. data service는 두 개의 별도 field map을 사용(하나는 매칭, 하나는 추가/갱신). |
| 22 | FieldMappingField | data service 필드에 매핑되는 org 객체 필드. |
| 23 | FieldMappingRow | org 객체 레코드 필드에 매핑되는 data service 레코드 필드. |
| 24 | FieldSet | 필드 그룹의 메타데이터. |
| 25 | FlexiPage | Lightning page. 영역(region)에 Lightning 컴포넌트를 담는 커스터마이즈 가능한 페이지. |
| 26 | Flow | 특정 flow 버전을 조회·갱신하는 데 사용. |
| 27 | FlowDefinition | flow 버전 집합의 부모. |
| 28 | Group | User 레코드 집합. 개별 사용자·다른 그룹·특정 role/territory의 사용자, 또는 계층상 특정 role/territory 하위 사용자 전체를 포함 가능. |
| 29 | HistoryRetentionJob | 아카이브로부터 보존된 데이터 본문과 아카이브된 데이터 상태. |
| 30 | KeywordList | Experience Cloud site 모더레이션에 사용되는 키워드 목록. |
| 31 | Layout | page layout. |
| 32 | LookupFilter | lookup·master-detail·hierarchical relationship 필드의 유효값과 lookup dialog 결과를 제한하는 lookup filter. |
| 33 | MatchingRule | 하나의 DuplicateJobDefinition을 공유하는 DuplicateJob 인스턴스와 함께 사용할 MatchingRule. Tooling API version 42.0 이상. |
| 34 | MenuItem | 메뉴 항목. |
| 35 | ModerationRule | Experience Cloud site에서 멤버 생성 콘텐츠를 모더레이션하는 규칙. |
| 36 | PermissionSet | 프로파일 변경·재할당 없이 사용자에게 더 많은 접근을 부여하는 권한 집합. API version 28.0 이상. |
| 37 | PermissionSetAssignment | permission set 또는 permission set group에 대한 사용자 할당. API version 22.0 이상. |
| 38 | PermissionSetGroup | permission set들과 그 안의 권한들의 그룹. 직무·작업 기준으로 권한을 조직하고 필요 시 패키징. Tooling API version 45.0 이상. |
| 39 | PermissionSetGroupComponent | PermissionSetGroup과 PermissionSet 객체를 각자의 ID로 연결하는 junction 객체. 그룹의 집계 권한 재계산을 가능케 함. Tooling API version 45.0 이상. |
| 40 | PermissionSetTabSetting | 프로파일/permission set의 탭 설정. 프로파일·permission set의 탭 가시성 조작에 사용. Tooling API version 37.0 이상. |
| 41 | Profile | 사용자 프로파일. Salesforce 내 여러 기능 수행 권한을 정의. |
| 42 | ProfileLayout | profile layout. |
| 43 | QuickActionDefinition | quick action의 정의. |
| 44 | QuickActionList | quick action 목록. |
| 45 | QuickActionListItem | quick action list의 항목. |
| 46 | RecentlyViewed | 현재 사용자가 최근 본, Setup에 흔히 있는 메타데이터 엔티티(page layout 정의·workflow rule 정의·email template 등). |
| 47 | RecordType | 커스텀 record type. |
| 48 | SearchLayout | 객체에 정의된 search layout. |
| 49 | Scontrol | 커스텀 s-control. 시스템이 호스팅하지만 클라이언트 앱이 실행하는 커스텀 콘텐츠. 웹 브라우저에서 표시·실행할 수 있는 모든 유형의 콘텐츠 포함 가능. |
| 50 | User | 사용자. Tooling API로 User의 표준 필드는 조회 가능하나 커스텀 필드는 조회 불가. |
| 51 | WebLink | 커스텀 버튼/링크. |
| 52 | ValidationRule | 조건 충족 시점의 수식을 지정하는 validation rule 또는 workflow rule. |
| 53 | WorkflowAlert | workflow alert. workflow rule이나 승인 프로세스가 생성해 지정 수신자에게 보내는 이메일. |
| 54 | WorkflowFieldUpdate | workflow field update. |
| 55 | WorkflowOutboundMessage | outbound message. 외부 서비스 같은 지정 endpoint로 정보를 전송. Setup에서 구성하며, 외부 endpoint 구성과 SOAP API listener 작성이 필요. |
| 56 | WorkflowRule | 지정 기준 충족 시 특정 workflow action을 실행하는 workflow rule. 연관된 Salesforce Metadata API의 WorkflowRule 객체 접근 포함. |
| 57 | WorkflowTask | 지정 기준 충족 시 특정 workflow action을 실행하는 workflow task. 연관된 Salesforce Metadata API의 WorkflowRule 객체 접근 포함. |

### Tooling Objects (12)

테스트 결과·디버깅·코드 커버리지 등을 둘러싼 도구를 구축하기 위한 객체.

| # | 객체 | 설명 |
|---|---|---|
| 1 | ApexCodeCoverage | Apex 클래스/트리거의 code coverage 테스트 결과. |
| 2 | ApexCodeCoverageAggregate | Apex 클래스/트리거의 집계 code coverage 테스트 결과. Tooling API version 29.0 이상. |
| 3 | ApexExecutionOverlayAction | Apex 클래스/트리거의 특정 라인에서 실행할 Apex 코드 스니펫이나 SOQL 쿼리를 지정. 선택적으로 heap dump 생성. |
| 4 | ApexExecutionOverlayResult | 연관된 ApexExecutionOverlayAction에 정의된 Apex 스니펫/SOQL 쿼리의 결과와, 반환된 경우의 heap dump. |
| 5 | ApexLog | debug log. |
| 6 | ApexOrgWideCoverage | 전체 org의 code coverage 테스트 결과. |
| 7 | ApexResult | ApexExecutionOverlayAction의 일부로 실행된 Apex 코드 결과를 나타내는 complex type. ApexExecutionOverlayResult에 반환됨. |
| 8 | ApexTestQueueItem | Apex job queue 안의 단일 Apex 클래스. |
| 9 | HeapDump | ApexExecutionOverlayResult 객체 안의 heap dump를 나타내는 complex type. |
| 10 | SOQLResult | ApexExecutionOverlayResult 객체 안의 SOQL 쿼리 결과를 나타내는 complex type. |
| 11 | SymbolTable | ApexClass·ApexClassMember·ApexTriggerMember의 Body 안 사용자 정의 토큰 전체와 Body 내 line·column 위치를 나타내는 complex type. |
| 12 | TraceFlag | 지정 logging level에서 Apex debug log를 트리거하는 trace flag. |

### Operational Objects (4 + Developer Console 내부 3)

Tooling API 작업(operations)에 사용하는 객체.

| # | 객체 | 설명 |
|---|---|---|
| 1 | ContainerAsyncRequest | MetadataContainer 객체를 컴파일하고 org에 비동기로 배포. |
| 2 | DeployDetails | ContainerAsyncRequest로 정의된 비동기 요청에서 보고된 compile 에러의 상세 XML을 담는 complex type. |
| 3 | MetadataContainer | ApexClassMember·ApexTriggerMember·ApexPageMember·ApexComponentMember의 working copy를 관리. 함께 배포할 객체 컬렉션 포함. |
| 4 | OperationLog | Tooling API로 트리거·추적되는 장기 실행/비동기 작업. |

**Developer Console 내부 전용 객체 (원문 note):** 다음 Tooling API 객체는 Developer Console에서 내부적으로 사용된다.
- IDEPerspective
- IDEWorkspace
- User.WorkspaceId

---

## System Fields

일부 필드는 system-generated이다. 대부분의 Tooling API 객체에 존재하며 read-only이다. 이 필드들은 API 작업 중 자동 갱신된다. 예를 들어 `Id` 필드는 레코드 생성 시 자동 생성되고, `LastModifiedDate`는 객체에 대한 어떤 작업에서든 자동 갱신된다.

| Field | Field Type | Description |
|---|---|---|
| Id | ID | 레코드를 식별하는 전역 고유 문자열. Id 필드는 Defaulted on create, Filter access를 가짐. |
| IsDeleted | boolean | 레코드가 Recycle Bin으로 이동했는지(true) 아닌지(false) 표시. 모든 객체에 나타나지는 않으므로 각 객체의 필드표에 개별 명시됨. |
| CreatedBy | User | 레코드를 생성한 사용자. CreatedBy 필드는 Defaulted on create, Filter, Group, Sort access를 가짐. |
| CreatedById | reference | 이 레코드를 생성한 User의 ID. CreatedById 필드는 Defaulted on create, Filter, Group, Sort access를 가짐. |
| CreatedDate | dateTime | 이 레코드가 생성된 날짜·시간. CreatedDate 필드는 Defaulted on create, Filter, Sort access를 가짐. |
| LastModifiedBy | User | 레코드를 마지막으로 수정한 사용자. LastModifiedBy 필드는 Defaulted on create, Filter, Group, Sort access를 가짐. |
| LastModifiedById | reference | 이 레코드를 마지막으로 갱신한 User의 ID. LastModifiedById 필드는 Defaulted on create, Filter, Group, Sort access를 가짐. |
| LastModifiedDate | dateTime | 사용자가 이 레코드를 마지막으로 수정한 날짜·시간. LastModifiedDate 필드는 Defaulted on create, Filter, Sort access를 가짐. |
| SystemModstamp | dateTime | 사용자 또는 자동화 프로세스(트리거 등)에 의해 이 레코드가 마지막 수정된 날짜·시간. SystemModstamp 필드는 Defaulted on create, Filter access를 가짐. |

객체에 어떤 필드가 있는지 확인하려면 Tooling API WSDL을 점검한다.

---

## SOQL Operation Limitations

일부 Tooling API 객체는 SOQL 제약을 가진다. 이 제약은 모든 **Metadata Catalog query**에 적용되며, 명시적으로 나열된 것뿐 아니라 **모든 Custom Metadata Types와 Metadata Catalog 엔티티**에 적용된다.

다음 객체들은 SOQL 연산 `COUNT()`, `GROUP BY`, `LIMIT`, `LIMIT OFFSET`, `OR`, `NOT`, `INCLUDES`를 지원하지 않는다.

**제약 적용 객체 (16):**
CompactLayoutInfo · CompactLayoutItemInfo · DataType · EntityDefinition · EntityLimit · EntityParticle · FieldDefinition · Publisher · RelationshipDomain · RelationshipInfo · SearchLayout · ServiceFieldDataType · StandardAction · TimeSheetTemplate · UserEntityAccess · UserFieldAccess

이들 객체에서 미지원 연산은 에러나 잘못된 결과를 반환한다. 아래는 그 예시다.

```sql
-- GROUP BY
SELECT COUNT(qualifiedapiname), isfeedenabled FROM EntityDefinition GROUP BY isfeedenabled
-- Error: The requested operation is not yet supported by this SObject storage type,
--        contact salesforce.com support for more information.

-- LIMIT, LIMIT OFFSET  (무시되어 잘못된 결과 반환)
SELECT qualifiedapiname FROM EntityDefinition LIMIT 5
SELECT qualifiedapiname FROM EntityDefinition LIMIT 5 OFFSET 10
-- An incorrect result is returned because LIMIT and LIMIT OFFSET are ignored.

-- NOT
SELECT qualifiedapiname FROM EntityDefinition WHERE qualifiedapiname!='Account'
-- Error: Only equals comparisons permitted

-- OR
SELECT qualifiedapiname, keyprefix FROM EntityDefinition
WHERE isdeletable=true OR (isfeedenabled=false AND keyprefix='01j')
-- Error: Disjunctions not supported

-- ORDER BY  (조인된 객체 필드로 정렬 시 에러 가능)
SELECT EntityDefinition.DeveloperName, ValidationName, Active, Description,
       ErrorDisplayField, ErrorMessage
FROM ValidationRule
ORDER BY EntityDefinition.DeveloperName ASC, ValidationName ASC
-- Error: ERROR: relation "core.virtual_standard_entity_data_template" does not exist
-- 쿼리 대상 객체 자체 필드로는 항상 정렬 가능하나, 조인된 객체 필드로 정렬하면 에러가 날 수 있음.

-- INCLUDES
SELECT ComplianceGroup FROM FieldDefinition
WHERE EntityDefinitionId = 'Account' AND ComplianceGroup includes('GDPR')
-- Error: Unsupported filter type
```

**추가 note:** MetadataComponentDependency (Pilot)는 `GROUP BY`와 `COUNT()` 외의 aggregate function을 지원하지 않는다.

**SOQL Queries in Scratch Orgs:** scratch org에서 Tooling API를 쿼리하면 최대 **2,000 records**가 반환될 수 있다. 그 외 모든 유형의 org에서는 쿼리가 단일 레코드(single record)를 반환한다.

---

## SOSL Operation Limitations

두 Tooling API 객체 **EntityDefinition**과 **FieldDefinition**은 일부 SOSL 제약을 가진다. **ExternalString**과 **MetadataComponentDependency (Beta)**는 SOSL 검색을 지원하지 않는다.

### EntityDefinition · FieldDefinition

EntityDefinition과 FieldDefinition은 다음 SOSL 연산(`FIND`)을 지원한다.

- **Literal text search:** `FIND {account}`
- **단일 wildcard 텍스트 검색:**
  ```sql
  FIND {account*} RETURNING EntityDefinition
  FIND {account?} RETURNING FieldDefinition
  FIND {account*fax} RETURNING EntityDefintion   -- (원문 오타 그대로)
  FIND {account?fax} RETURNING FieldDefinition
  ```
  wildcard는 검색어의 첫 문자가 될 수 없다(모든 객체에 공통되는 검색 동작).
- **Quotation marks** 지원.
- **Escape character `\ ` (역슬래시/slash)** 지원. 예를 들어 `*`(asterisk) 문자를 검색하려면 escape character를 포함한다:
  ```sql
  FIND {account\*}
  RETURNING EntityDefinition
  ```
- **`RETURNING` 필수:**
  ```sql
  FIND {MyString}
  RETURNING FieldDefinition
  ```
  - Multiple object type names 지원: `...RETURNING EntityDefinition, FieldDefinition`
  - Field list 지원: `... RETURNING EntityDefinition (MasterLabel, QualifiedApiName)`
  - `WHERE` 지원(단 논리 연산자는 미지원).
  - `LIMIT` 지원.

**Example (원문 그대로):**
```sql
FIND {account*}
RETURNING FieldDefinition (MasterLabel, NamespacePrefix
WHERE EntityDefinitionId='Account')
```

그 외 모든 SOSL 연산은 미지원이다. 검색어에 미지원 표현을 포함하면 그 표현은 무시되지만, 다음은 무시되지 않고 **에러를 발생**시킨다.
1. 검색어 내 multiple wildcards
2. 미지원 연산자 `OR` 또는 `NOT`
3. 연산자 grouping을 위한 괄호(parentheses)
4. Morphological tokenization
5. 단일 문자 검색의 끝에 asterisk wildcard가 추가되지 않음

### ExternalString
ExternalString은 SOSL 검색을 지원하지 않는다.

### MetadataComponentDependency (Beta)
MetadataComponentDependency는 virtual entity이므로 SOSL 검색을 지원하지 않는다.

---

## Considerations for CRUD Operations in Active Orgs

대부분의 Tooling API 객체에 대한 CRUD 작업은 다른 유형의 org에서와 마찬가지로 **API version 41.0 이상**에서 활성(active) org에서도 허용된다. 그러나 성능상의 이유로 일부 Tooling API 객체는 활성 org에서 CRUD 작업을 수행할 수 없다.

다음 Tooling API 객체에 대해 활성 org에서 CRUD 작업을 하면 에러 `Save or update not supported in active organizations`가 발생한다.

1. ApexClass
2. ApexComponent
3. ApexPage
4. ApexTrigger
5. CustomField
6. CustomObject

### Allow Metadata Save Operations to Complete with Returned Warnings

metadata save 작업이 경고를 생성하면 Tooling API의 기본 동작은 경고를 반환하지 않고 작업을 실패 처리하는 것이다. Tooling API와 Metadata API WSDL 양쪽에 모두 있는 객체에 대해서는, error-free save 작업이 경고를 반환하며 성공적으로 완료되도록 지정할 수 있다.

- 방법: HTTP 요청에 헤더 `ignoreSaveWarnings`를 지정한다.
- 경고가 반환되더라도 metadata를 저장하는 SOAP 헤더도 있다 → `MetadataWarningsHeader`(원문: on page 989) 참조. 헤더 상세는 [[Tooling API — SOAP·REST 헤더]] 소관.

---

## ApiFault Element

ApiFault 요소는 서비스 요청 처리 중 발생한 fault에 대한 정보를 담는다. ApiFault 요소는 다음 프로퍼티를 가진다.

| Property | Type | Description |
|---|---|---|
| exceptionCode | `fns:ExceptionCode` | 예외를 특징짓는 코드. 전체 exception code 목록은 org의 Tooling API WSDL 파일에서 확인 가능. |
| exceptionMessage | `string` | exception code에 연관된 메시지 텍스트. |
| extendedErrorDetails | `tns:ExtendedErrorDetails` | 향후 사용을 위해 예약(Reserved for future use). |
| upgradeURL | `string` | upgrade에 대한 추가 정보 위치를 제공하는 URL. |
| upgradeMessage | `string` | upgrade가 필요한 이유를 설명하는 메시지 텍스트. |

### Tooling API Faults (11)

다음 API fault 요소들은 발생할 수 있는 모든 Tooling API fault를 나타낸다. API version 37.0 이상에서 이 요소들은 Tooling API `fns` 네임스페이스(`fault.tooling.soap.sforce.com`)에 있다.

| Fault | Description |
|---|---|
| ApiQueryFault | 문제가 발생한 위치를 식별하는 row·column 번호. |
| InvalidFieldFault | `retrieve()` 또는 `query()` 호출에서 invalid field. |
| InvalidIdFault | `setPassword()` 또는 `resetPassword()` 호출에서 지정된 ID가 invalid. |
| InvalidNewPasswordFault | 지정된 새 비밀번호가 org의 비밀번호 요구사항(길이·문자 조합·이전 비밀번호 재사용 등)에 부합하지 않음. |
| InvalidOldPasswordFault | 지정된 비밀번호가 이전 비밀번호와 일치하지 않음. |
| InvalidQueryLocatorFault | `queryMore()` 호출에 전달된 queryLocator의 문제. |
| InvalidSObjectFault | `describeSObject()`, `describeSObjects()`, `describeLayout()`, `describeDataCategoryGroups()`, `describeDataCategoryGroupStructures()`, `create()`, `update()`, `retrieve()`, `query()` 호출에서 invalid sObject. |
| LoginFault | `login()` 호출 중 에러 발생. |
| MalformedQueryFault | `query()` 호출에 전달된 queryString의 문제. |
| MalformedSearchFault | `search()` 호출에 전달된 search의 문제. |
| UnexpectedErrorFault | 예상치 못한 에러 발생. 다른 어떤 API fault와도 연관되지 않음. |

---

## 관련 노트

- [[Tooling API — 개요·REST·SOAP 호출 기초]] — Tooling API 폴더 허브. REST/SOAP 호출 기초·When to Use.
- [[Tooling API — SOAP·REST 헤더]] — `MetadataWarningsHeader` 등 SOAP/REST 헤더 8+4개 상세(이 색인이 위임한 헤더 소관).
- [[Tooling API 배포]] — MetadataContainer·ContainerAsyncRequest·*Member 배포 패밀리 객체의 필드·용법 권위 노트(위 분류 목록에서 색인만 제공, 상세는 여기).
- [[Tooling API 디버그·로그·리플레이 sObject]] — TraceFlag·ApexLog·ApexExecutionOverlayAction/Result·HeapDump 등 디버그/로그 패밀리 권위 노트.
- [[Tooling API 객체 — Apex 코드·테스트·커버리지]] — ApexClass·ApexTrigger·ApexComponent·ApexPage·코드 커버리지·테스트 실행/결과/한도·SymbolTable 등 Apex 코드 군 17객체의 필드·용법 권위 노트.
- [[Tooling API 객체 — Entity·Field·스키마]] — EntityDefinition·FieldDefinition·EntityParticle·CustomField·RecordType·LookupFilter·FormulaFunction 등 스키마 메타데이터 군 28객체의 필드·용법 권위 노트.
- [[Tooling API 객체 — 보안·권한]] — PermissionSet·Profile·NamedCredential·ExternalCredential·CspTrustedSite·RestrictionRule·UserAccessPolicy 등 보안·권한·접근통제 군 38객체의 필드·용법 권위 노트(분류 목록 Setup Objects 중 보안 항목 상세).
- [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] — Flow·FlowDefinition·FlowTest·Workflow 액션·ValidationRule·배정/매칭/중복 룰 등 선언적 자동화 군 19객체의 필드·용법 권위 노트(분류 목록 Setup Objects 중 자동화 항목 상세).
- [[Field Service Metadata·Tooling API]] — CleanRule·TimeSheetTemplate 등 FSL 특화 Tooling 변형 객체 권위 노트.
