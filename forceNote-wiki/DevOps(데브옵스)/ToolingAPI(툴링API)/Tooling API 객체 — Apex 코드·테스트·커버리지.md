---
tags: [tooling-api, devops, apex, test, coverage]
source: api_tooling.pdf v67.0 (Summer '26); Winter27-v68-Docs/api_tooling.pdf (Tooling API Reference and Developer Guide v68.0 Winter '27, 2026-08-21 갱신) 인쇄 p.29–37 — symbols·apexCompileResults 절; Tier2 help.salesforce.com rn_deployment_ant_migration_tool_eol (Ant Migration Tool EOL Spring '24)
created: 2026-06-27
aliases: [ApexClass, ApexTrigger, ApexComponent, ApexPage, ApexPageInfo, ApexCodeCoverage, ApexCodeCoverageAggregate, ApexOrgWideCoverage, ApexTestQueueItem, ApexTestResult, ApexTestResultLimits, ApexTestRunResult, ApexTestSuite, TestSuiteMembership, ApexEmailNotification, ApexResult, SymbolTable, Apex Symbol API, symbols 리소스, typeStubs, apexCompileResults, type reference, compileError, 심볼 API, 무효 Apex 재컴파일, 컴파일 결과 조회, 코드 커버리지, 테스트 결과, 테스트 큐, 심볼 테이블, Apex 트리거 sObject]
---

# Tooling API 객체 — Apex 코드·테스트·커버리지

> Apex 클래스/트리거/Visualforce 컴포넌트·페이지의 저장본 sObject, 코드 커버리지, 테스트 실행·결과·한도, 그리고 SymbolTable 복합 타입까지 — Tooling API로 SOQL 조회·관리하는 Apex 코드 군 17객체 전수.

이 노트는 Tooling API Reference & Developer Guide v67.0(Summer '26)의 "Tooling API Objects" 챕터 중 **Apex 코드·테스트·커버리지 도메인 17객체**를 다룬다. 각 객체는 SOQL/SOSL로 조회 가능한 Tooling sObject다.

여기에 더해, **Winter '27(API 68.0)에서 신설된 Apex 도메인 REST 리소스 2개**(`/tooling/symbols` Beta · `/tooling/apexCompileResults`)의 레퍼런스를 노트 후반 [v68.0 신규 REST 리소스](#v680-신규-rest-리소스--apex-심볼컴파일-결과-winter-27) 절에 함께 둔다. 출처는 `Winter27-v68-Docs/api_tooling.pdf`(v68.0 Winter '27) 인쇄 p.29–37이다.

> [!note] 위임 경계 — 이 노트가 다루지 **않는** Apex 관련 객체
> 아래 객체는 다른 권위 노트가 소관한다. 여기서는 필드표를 복제하지 않고 링크만 둔다.
> - **편집/저장/컴파일용 *Member* 컨테이너 패밀리** — `ApexClassMember`·`ApexTriggerMember`·`ApexComponentMember`·`ApexPageMember` (+ MetadataContainer·ContainerAsyncRequest) → [[Tooling API 배포]] 참조
> - **디버그·로그·리플레이 패밀리** — `ApexLog`·`ApexExecutionOverlayAction`·`ApexExecutionOverlayResult` (+ TraceFlag·DebugLevel·HeapDump·ExecuteAnonymousResult) → [[Tooling API 디버그·로그·리플레이 sObject]] 참조
> - **Metadata API의 동명 *타입*** (declarative metadata `ApexClass` 등)은 Tooling sObject와 별개다 → [[Metadata Types — Apex & Code]] 참조(필드·용법 상이).

> [!important] Apex 클래스·트리거 생성/수정/삭제 제약
> `ApexClass`·`ApexTrigger`는 Create·Update 필드 속성을 갖지만, API로 직접 create/update/delete를 시도하면 런타임 예외가 발생한다. 실제 편집·저장·컴파일은 *Member* 컨테이너([[Tooling API 배포]])나 Salesforce CLI(`sf`) / Salesforce Extensions for VS Code로 한다. 또한 프로덕션 org에서는 클래스·트리거를 생성·편집·삭제할 수 없다.

> [!warning] Ant Migration Tool 은퇴(retired) — 후속: Salesforce CLI(`sf`)
> 예전 편집·저장·컴파일 경로로 함께 쓰이던 **Ant Migration Tool은 Spring '24부터 공식 End of Life(EOL)**로 미지원·미갱신 상태다(API v59.0 이후 기능이 반영되지 않는다). 신규 작업에서는 사용하지 말고, 후속 도구인 **Salesforce CLI(`sf`)**로 대체한다. 근거: [Ant Migration Tool End of Life](https://help.salesforce.com/s/articleView?id=release-notes.rn_deployment_ant_migration_tool_eol.htm) · [Moving on from the Ant Migration Tool to sf CLI](https://developer.salesforce.com/blogs/2024/01/moving-on-from-the-ant-migration-tool-to-sf-cli-v2).

---

## 객체 빠른 색인

| 객체 | 분류 | 필드 수 | API 최소 버전 |
|---|---|---|---|
| [ApexClass](#apexclass) | 코드 sObject | 12 | 28.0 |
| [ApexTrigger](#apextrigger) | 코드 sObject | 17 | 28.0 |
| [ApexComponent](#apexcomponent) | 코드 sObject | 1 | 28.0 |
| [ApexPage](#apexpage) | 코드 sObject | 13 | 28.0 |
| [ApexPageInfo](#apexpageinfo) | 코드 메타 | 9 | 37.0 |
| [ApexCodeCoverage](#apexcodecoverage) | 커버리지 | 6 | 29.0 |
| [ApexCodeCoverageAggregate](#apexcodecoverageaggregate) | 커버리지 | 4 | 29.0 |
| [ApexOrgWideCoverage](#apexorgwidecoverage) | 커버리지 | 1 | 29.0 |
| [ApexTestQueueItem](#apextestqueueitem) | 테스트 실행 | 6 | 30.0 |
| [ApexTestResult](#apextestresult) | 테스트 결과 | 15 | 30.0 |
| [ApexTestResultLimits](#apextestresultlimits) | 테스트 한도 | 13 | 37.0 |
| [ApexTestRunResult](#apextestrunresult) | 테스트 요약 | 15 | 37.0 |
| [ApexTestSuite](#apextestsuite) | 테스트 스위트 | 1(ens)/1(mns) | 36.0/38.0 |
| [TestSuiteMembership](#testsuitemembership) | 스위트 멤버십 | 2 | 36.0 |
| [ApexEmailNotification](#apexemailnotification) | 예외 알림 | 2 | 35.0 |
| [ApexResult](#apexresult) | 복합 타입 | 2 | 28.0 |
| [SymbolTable](#symboltable) | 복합 타입 | 11 | — |

**v68.0(Winter '27) 신규 — 이 노트가 함께 다루는 REST 리소스 2개** (sObject가 아니라 REST 엔드포인트)

| 리소스 | 메서드 | 최소 API | 상태 |
|---|---|---|---|
| [Apex Symbol API — `/tooling/symbols`](#apex-symbol-api-beta--get-toolingsymbols) | GET | 68.0 | Beta |
| [`/tooling/apexCompileResults`](#무효-apex-컴파일-결과--post-toolingapexcompileresults) | POST | 68.0 | (Beta 표기 없음) |

---

## 코드 sObject — 클래스·트리거·컴포넌트·페이지

### ApexClass

Apex 클래스의 저장본(saved copy). 사용 불가가 아닌 한 캐시된 버전을 사용한다. API 28.0 이상. 클래스를 편집·저장·컴파일하려면 `ApexClassMember`([[Tooling API 배포]])를 쓴다.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`
- **Supported REST API HTTP Methods:** GET, POST, PATCH, DELETE

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiVersion | double | Create, Filter, Sort, Update | The API version for this class. Every class has an API version specified at creation. |
| Body | textarea | Create, Nillable, Update | The data for the Apex class. |
| BodyCrc | double | Create, Defaulted on create, Filter, Nillable, Sort, Update | The CRC (cyclic redundancy check) of the class or trigger file. |
| FullName | string | Group, Nillable | The full name of the associated object in the Metadata API. Use to avoid race conditions on create, before you have IDs. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| IsValid | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether any dependent metadata has changed since the class was last compiled (true) or not (false). The default value is false. |
| LengthWithoutComments | int | Create, Filter, Group, Sort, Update | Length of the class without comments. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Indicates the manageable state of the specified component that is contained in a package: `beta`, `deleted`, `deprecated`, `deprecatedEditable`, `installed`, `installedEditable`, `released`, `unmanaged`. This field is available in API version 38.0 and later. |
| Metadata | ApexClassMetadata | Create, Nillable, Update | An object that describes the version, status, and packaged versions of the corresponding Apex class. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Name | string | Create, Filter, Group, Sort, Update | Name of the class. Limit: 255 characters. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix associated with this object. Each Developer Edition organization that creates a managed package has a unique namespace prefix. Limit: 15 characters. Refer to a component in a managed package via `namespacePrefix__componentName`. In Developer Edition orgs the prefix is the org's prefix for all supporting objects (exception: an object in an installed managed package takes that package's prefix). In non–Developer Edition orgs, NamespacePrefix is set only for objects that are part of an installed managed package; all other objects have no prefix. |
| Status | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The current status of the Apex class. Valid values: `Active`—the class is active. `Deleted`—the class is marked for deletion (useful for managed packages, allowing a class to be deleted when a managed package is updated). `Inactive`—unused and only supported for ApexTrigger. See the Metadata API Developer Guide. |
| SymbolTable | SymbolTable | Nillable | A complex type representing all user-defined tokens in the Body of an ApexClass, ApexClassMember, or ApexTriggerMember and their line/column locations within the Body. Null if the symbol table can't be created — e.g. another Apex compilation is in progress and holding a compile lock, or the Apex class is in an invalid state and can't compile successfully. See [SymbolTable](#symboltable). |

**Usage:** 클래스 정보를 조회하려면 해당 클래스를 참조하는 `ApexClass` 객체를 만든다(예제 코드는 SOAP Calls 참조). 편집·저장·컴파일은 `ApexClassMember`([[Tooling API 배포]]).

> Note: SymbolTable의 캐시 버전이 없으면 백그라운드에서 컴파일되어 쿼리가 예상보다 오래 걸릴 수 있다. `ApexClass`에서 반환된 SymbolTable에는 references가 포함되지 않는다. references가 있는 SymbolTable이 필요하면 `ApexClassMember`를 쓴다.

> 편집/저장/컴파일 단위인 `ApexClassMember`는 이 노트 범위 밖 — [[Tooling API 배포]] 참조.

### ApexTrigger

Apex 트리거의 저장본. 캐시 버전을 사용한다. API 28.0 이상. 편집·저장·컴파일은 `ApexTriggerMember`([[Tooling API 배포]]).

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API HTTP Methods:** Query, GET, POST, PATCH, DELETE

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiVersion | double | Create, Filter, Sort, Update | The API version for this trigger. Every trigger has an API version specified at creation. |
| Body | string | Create, Nillable, Update | The Apex trigger definition. Limit: 1 million characters. |
| BodyCrc | double | Create, Defaulted on create, Filter, Nillable, Sort, Update | The CRC (cyclic redundancy check) of the class or trigger file. |
| EntityDefinitionId | string | Filter, Group, Nillable, Sort | The Id of the EntityDefinition object associated with this object. |
| IsValid | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether any dependent metadata has changed since the trigger was last compiled (true) or not (false). |
| LengthWithoutComments | int | Create, Filter, Group, Sort, Update | Length of the trigger without comments. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state in a package: `beta`, `deleted`, `deprecated`, `deprecatedEditable`, `installed`, `installedEditable`, `released`, `unmanaged`. |
| Metadata | ApexTriggerMetadata | None | An object that describes the version, status, and packaged versions of the corresponding Apex trigger. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. |
| Status | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The status of the Apex trigger. Valid string values: `Active`—the trigger is active. `Inactive`—the trigger is inactive but not deleted. `Deleted`—the trigger is marked for deletion (useful for managed packages). Note: Apex triggers can't be deactivated via Tooling API; use Metadata API to deactivate. Consider custom metadata records plus logic in your trigger to bypass trigger configuration. See the Metadata API Developer Guide. |
| UsageAfterDelete | boolean | Create, Filter, Update | Specifies whether the trigger is an after delete trigger (true) or not (false). |
| UsageAfterInsert | boolean | Create, Filter, Update | Specifies whether the trigger is an after insert trigger (true) or not (false). |
| UsageAfterUndelete | boolean | Create, Filter, Update | Specifies whether the trigger is an after undelete trigger (true) or not (false). |
| UsageAfterUpdate | boolean | Create, Filter, Update | Specifies whether the trigger is an after update trigger (true) or not (false). |
| UsageBeforeDelete | boolean | Create, Filter, Update | Specifies whether the trigger is a before delete trigger (true) or not (false). |
| UsageBeforeInsert | boolean | Create, Filter, Update | Specifies whether the trigger is an before insert trigger (true) or not (false). |
| UsageBeforeUpdate | boolean | Create, Filter, Update | Specifies whether the trigger is an before update trigger (true) or not (false). |
| UsageIsBulk | boolean | Create, Filter, Update | Specifies whether the trigger is defined as a bulk trigger (true) or not (false). |

**Usage:** 트리거 정보를 조회하려면 `ApexTrigger` 객체를 만든다. 편집·저장·컴파일은 `ApexTriggerMember`([[Tooling API 배포]]). `ApexClass`와 마찬가지로 API로 직접 create/update/delete 시 런타임 예외가 나며, 프로덕션 org에서는 생성·편집·삭제 불가다.

> 편집/저장/컴파일 단위인 `ApexTriggerMember`는 이 노트 범위 밖 — [[Tooling API 배포]] 참조.

### ApexComponent

Visualforce 컴포넌트의 저장본. 캐시 버전을 사용한다. API 28.0 이상. 편집·저장·컴파일은 `ApexComponentMember`([[Tooling API 배포]]).

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API HTTP Methods:** Query, GET, POST, PATCH, DELETE

| Field | Type | Properties | Description |
|---|---|---|---|
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state in a package: `beta`, `deleted`, `deprecated`, `deprecatedEditable`, `installed`, `installedEditable`, `released`, `unmanaged`. This field is available in API version 38.0 and later. |

**Usage:** Visualforce 컴포넌트 정보를 조회하려면 `ApexComponent` 객체를 만든다. 편집·저장·컴파일은 `ApexComponentMember`([[Tooling API 배포]]).

> 편집/저장/컴파일 단위인 `ApexComponentMember`는 이 노트 범위 밖 — [[Tooling API 배포]] 참조.

### ApexPage

Visualforce 페이지의 저장본. 캐시 버전을 사용한다. API 28.0 이상. 편집·저장·컴파일은 `ApexPageMember`([[Tooling API 배포]]).

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `search()`, `update()`, `upsert()`
- **Supported REST API HTTP Methods:** Query, GET, POST, PATCH, DELETE

| Field | Type | Properties | Description |
|---|---|---|---|
| ApiVersion | double | Create, Filter, Sort, Update | The API version for the page. Every page has an API version at creation. If the API version is less than 15.0 and ApiVersion isn't specified, ApiVersion defaults to 15.0. Available in API version 30.0 and later. |
| ControllerKey | string | Create, Filter, Group, Nillable, Sort, Update | The identifier for the controller associated with this page. If ControllerType is Standard or StandardSet, this is the name of the sObject that defines the controller. If ControllerType is Custom, this is the name of the Apex class that defines the controller. Available in API version 30.0 and later. |
| ControllerType | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The type of controller for this Visualforce page. Possible values: `Not Specified` (neither standardController nor controller attribute on `<apex:page>`), `Standard` (standardController attribute), `StandardSet` (standardController + recordSetVar attributes), `Custom` (controller attribute). Available in API version 30.0 and later. |
| Description | textarea | Create, Filter, Nillable, Sort, Update | Description of the Visualforce page. Available in API version 30.0 and later. |
| FullName | string | Create, Filter, Group, idLookup, Sort, Update | The full name of the associated metadata object in Metadata API. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. Available in API version 36.0 and later. |
| IsAvailableInTouch | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if Visualforce tabs associated with the page can be used in the Salesforce mobile app (true) or not (false). (Use for Salesforce Touch is deprecated.) Available in API version 30.0 and later. Standard object tabs overridden with a Visualforce page aren't supported in the Salesforce mobile app even if this field is set; the default app page for the object is displayed instead. |
| IsConfirmationTokenRequired | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether GET requests for the page require a CSRF confirmation token (true) or not (false). Available in API version 30.0 and later. If you change this value from false to true, links to the page require a CSRF token to be added, or the page becomes inaccessible. |
| ManageableState | ManageableState enumerated list | Filter, Group, Nillable, Restricted picklist, Sort | Manageable state in a package: `beta`, `deleted`, `deprecated`, `deprecatedEditable`, `installed`, `installedEditable`, `released`, `unmanaged`. Available in API version 38.0 and later. |
| Markup | textarea | Create, Update | The Visualforce markup, HTML, JavaScript, and any other Web-enabled code that defines the content of the page. Available in API version 30.0 and later. |
| MasterLabel | string | Create, Filter, Group, Sort, Update | The text used to identify the Visualforce page in the Setup area. The Label is Label. Available in API version 30.0 and later. |
| Metadata | mns:ApexPage | Create, Nillable, Update | The Visualforce page metadata. Query this field only if the query result contains no more than one record. Otherwise, an error is returned. If more than one record exists, use multiple queries to retrieve the records. This limit protects performance. Available in API version 36.0 and later. |
| Name | string | Create, Filter, Group, idLookup, Sort, Update | Required. Name of this Visualforce page. Available in API version 30.0 and later. |
| NamespacePrefix | string | Filter, Group, Nillable, Sort | The namespace prefix associated with this object. Each Developer Edition org that creates a managed package has a unique prefix. Limit: 15 characters. In Developer Edition orgs the prefix is the org's prefix for all supporting objects unless an object is in an installed managed package (then it takes that package's prefix). In non–Developer Edition orgs, set only for objects that are part of an installed managed package; all others have none. Available in API version 30.0 and later. |

**Usage:** Visualforce 페이지 정보를 조회하려면 `ApexPage` 객체를 만든다. 편집·저장·컴파일은 `ApexPageMember`([[Tooling API 배포]]).

> 편집/저장/컴파일 단위인 `ApexPageMember`는 이 노트 범위 밖 — [[Tooling API 배포]] 참조.

### ApexPageInfo

Visualforce 페이지에 대한 메타데이터. API 37.0 이상. 페이지를 편집·저장·컴파일하려면 `ApexPageMember`([[Tooling API 배포]]), 마크업·기타 필드를 로드하려면 `ApexPage`를 쓴다.

- **Supported SOAP API Calls:** `describeSObjects()`, `query()`
- **Supported REST API HTTP Methods:** Query, GET
- **Special Access Rules:** Summer '20 이후, 특정 Visualforce 페이지를 볼 수 있는 사용자와 "View Setup and Configuration" 권한 사용자만 이 객체에 접근할 수 있다.

| Field | Type | Properties | Description |
|---|---|---|---|
| ApexPageId | reference | Filter, Group, Sort | ID for the Visualforce page. |
| ApiVersion | double | Filter, Sort | The API version for the page. Every page has an API version at creation. If the API version is less than 15.0 and ApiVersion isn't specified, ApiVersion defaults to 15.0. |
| Description | textarea | Filter, Nillable, Sort | Description of the Visualforce page. |
| DurableId | string | Filter, Group, Nillable, Sort | For internal use only. |
| IsAvailableInTouch | boolean | Defaulted on create, Filter, Group, Sort | Indicates whether Visualforce tabs associated with the page can be used in the Salesforce app (true) or not (false). The default value is false. |
| IsShowHeader | boolean | Filter, Group, Nillable, Sort | The showHeader value for the page. This is "unknown" if the page uses an expression to compute showHeader. The default setting is true. |
| MasterLabel | string | Filter, Group, Nillable, Sort | The text used to identify the page in the Setup area. |
| Name | string | Filter, Group, Sort | Developer name of the Visualforce page. |
| NameSpacePrefix | string | Filter, Nillable, Sort | The namespace prefix associated with this object. Each Developer Edition org that creates a managed package has a unique prefix. Limit: 15 characters. In Developer Edition orgs the prefix is the org's prefix for all supporting objects (if an object is in an installed managed package it takes that package's prefix). In non–Developer Edition orgs, set only for objects that are part of an installed managed package; objects outside have no prefix. |

**Usage:** Visualforce 페이지의 label·name을 조회하려면 이 객체를 쿼리한다(예제 코드는 SOAP Calls 참조).

---

## 코드 커버리지

### ApexCodeCoverage

Apex 클래스·트리거의 코드 커버리지 테스트 결과(테스트 클래스별). Tooling API 29.0 이상.

- **Supported SOAP API Calls:** `describeSObjects()`, `query()`, `retrieve()`
- **Supported REST API HTTP Methods:** Query, GET
- **Special Access Rules:** API 49.0 이상에서 "View Setup and Configuration"과 "View All Data" 권한이 필요하다.

| Field | Type | Properties | Description |
|---|---|---|---|
| ApexTestClassId | string | Filter, Group, Sort | The ID of the test class. |
| TestMethodName | string | Filter, Group, Sort | The name of the test method. |
| ApexClassorTriggerId | string | Filter, Group, Sort | The ID of the class or trigger under test. |
| NumLinesCovered | int | Filter, Group, Sort | The number of covered lines. |
| NumLinesUncovered | int | Filter, Group, Sort | The number of uncovered lines. |
| Coverage | complexvalue | None | Two lists of integers. The first is the covered lines, the second the uncovered lines. If a line is missing from both lists, the line isn't executable and doesn't require coverage. Coverage includes the fields: `coveredLines`, `namespace`, `uncoveredLines`. |

**Usage:** 특정 테스트 클래스가 커버하는 특정 클래스·트리거의 커버리지 조회:

```sql
SELECT Coverage
FROM ApexCodeCoverage
WHERE ApexClassOrTriggerId = '01pD000000066GR'
AND ApexTestClassId = '01pD000000064pu'
```

클래스 단위(모든 테스트 클래스 합산 전 행 단위) 조회:

```sql
SELECT Coverage
FROM ApexCodeCoverage
WHERE ApexClassOrTriggerId = '01pD000000066GR'
```

> Note: 이 경우 같은 클래스를 커버하는 테스트 클래스가 여러 개면 여러 행이 반환될 수 있다.

Coverage는 두 정수 리스트로 반환된다. 첫째는 covered lines, 둘째는 uncovered lines. 두 리스트 모두에 없는 라인은 실행 불가(non-executable)라 커버리지가 필요 없다. 예) covered = 2, 9, 11이고 uncovered = 3, 4, 5, 6이면 결과는 `{2,9,11},{3,4,5,6}`. 빠진 라인(1, 7, 8, 10)은 실행 불가다.

커버리지 퍼센트 = covered 수 / (covered 수 + uncovered 수). SOAP에서 계산 예:

```java
ApexCodeCoverage acc = null; //Query for an ApexCodeCoverage object
Coverage coverage = acc.coverage;
int[] covered = coverage.coveredLines;
int[] uncovered = coverage.uncoveredLines;
int percent = covered.length / (covered.length + uncovered.length);
System.out.println("Total class coverage is " + percent + "%.");
```

> Note: 단일 배포가 Apex 클래스 2,000개를 초과하면, 배포 실패·롤백 여부와 무관하게 배포된 클래스의 ApexCodeCoverage 객체가 삭제된다. ApexCodeCoverageAggregate 객체는 영향받지 않는다.

### ApexCodeCoverageAggregate

Apex 클래스·트리거의 **집계** 코드 커버리지 결과. Tooling API 29.0 이상.

- **Supported SOAP API Calls:** `describeSObjects()`, `query()`, `retrieve()`
- **Supported REST API HTTP Methods:** Query, GET, DELETE
- **Special Access Rules:** API 49.0 이상에서 "View Setup and Configuration" 권한이 필요하다.

| Field | Type | Properties | Description |
|---|---|---|---|
| ApexClassorTriggerId | string | Filter, Group, Sort | The ID of the class or trigger under test. |
| NumLinesCovered | int | Filter, Group, Sort | The number of covered lines. |
| NumLinesUncovered | int | Filter, Group, Sort | The number of uncovered lines. |
| Coverage | complexvalue | None | Two lists of integers. The first is the covered lines, the second the uncovered lines. If a line is missing from both lists, the line isn't executable and doesn't require coverage. Coverage includes the fields: `coveredLines`, `namespace`, `uncoveredLines`. |

**Usage:** 집계 커버리지를 조회하려면 Apex 테스트 클래스를 지정한다. 반환 JSON/XML에는 covered·uncovered 두 리스트가 담긴다. 예제는 ApexCodeCoverage 참조.

### ApexOrgWideCoverage

전체 org에 대한 코드 커버리지 결과. Tooling API 29.0 이상.

- **Supported SOAP API Calls:** `describeSObjects()`, `delete()`, `query()`, `retrieve()`
- **Supported REST API HTTP Methods:** Query, GET, DELETE
- **Special Access Rules:** API 49.0 이상에서 "View Setup and Configuration" 권한이 필요하다.

| Field | Type | Properties | Description |
|---|---|---|---|
| PercentCovered | int | Filter, Group, Nillable, Sort | The percentage of the code in the organization that is covered by tests. |

---

## 테스트 실행·결과·한도

### ApexTestQueueItem

Apex 작업 큐 안의 단일 Apex 클래스. API 30.0 이상.

- **Supported SOAP API Calls:** `create()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API HTTP Methods:** Query, GET, POST, PATCH

| Field | Type | Properties | Description |
|---|---|---|---|
| ApexClassId | reference | Create, Filter, Group, Sort | The Apex class whose tests are to be executed. This field can't be updated. |
| Status | picklist | Filter, Group, Restricted picklist, Sort, Update | The status of the test. Valid values: `Queued`, `Processing`, `Aborted`, `Completed`, `Failed`, `Preparing`, `Holding`. To abort a class in the Apex job queue, update the ApexTestQueueItem and set Status to `Aborted`. |
| ExtendedStatus | string | Filter, Nillable, Sort | The pass rate of the test run, e.g. "(4/6)" means four of six tests passed. If the class fails to execute, this field contains the cause of the failure. |
| ParentJobId | reference | Filter, Group, Nillable, Sort | Read-only. Points to the AsyncApexJob that represents the entire test run. If you insert multiple Apex test queue items in a single bulk operation, the queue items share the same parent job — so a test run can consist of executing the tests of several classes if all queue items are inserted in the same bulk operation. |
| ShouldSkipCodeCoverage | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates whether to opt out of collecting code coverage information during Apex test runs. Available in API version 43.0 and later. |
| TestRunResultID | reference | Filter, Group, Nillable, Sort | The ID of the associated ApexTestRunResult object. Available in API version 37.0 and later. |

**Usage:** ApexTestQueueItem을 insert하면 해당 Apex 클래스가 작업 큐에 들어가 실행된다. Apex 작업이 클래스의 테스트 메서드들을 실행한다.

아래 예제 `RunTestListener.java`는 `TestResult` 시스템 토픽을 구독해 `ApexTestQueueItem`과 `ApexTestResult`로 테스트 결과를 출력한다. 전제: (1) Streaming API용 Java 클라이언트 설정(Streaming API Developer Guide의 `org.cometd.client.BayeuxClient` 사용), (2) 로그인된 `com.sforce.soap.tooling.SoapConnection`, (3) `TestResult` 시스템 토픽 `/systemTopic/TestResult` 구독을 위한 "View All Data" 권한.

> Note: Streaming API 대신 Pub/Sub API를 쓸 수 있다. gRPC·HTTP/2 기반 Pub/Sub API는 Apache Avro 바이너리 이벤트를 전달하며 Streaming API보다 효율적이다. Pub/Sub API Documentation 참조.

ApexTestQueueItem 대신 Salesforce CLI 명령으로 테스트 메서드를 실행할 수도 있다(Salesforce DX Developer Guide의 Run Apex Tests 참조).

> Note: `RunTestListener.java`는 Streaming API 핸드셰이크 이후에 인스턴스화해야 한다. 예:

```java
SoapConnection toolingConn; //Already set and logged in
BayeuxClient client; //Already set and logged in


//Listen on the handshake event
boolean handshaken = client.waitFor(10 * 1000, BayeuxClient.State.CONNECTED);
if (!handshaken) {
     System.out.println("Failed to handshake: " + client);
     System.exit(1);
}
final RunTestListener = null;
client.getChannel(Channel.META_SUBSCRIBE).addListener(
     new ClientSessionChannel.MessageListener() {
          public void onMessage(ClientSessionChannel channel, Message message) {
             boolean success = message.isSuccessful();
             if (success) {
                  //Replace with your own classes and suites
                  String apexTestClassId1 = "01pD00000007M0CIAU";
                  String apexTestClassId2 = "01pD00000007NqtIAE";
                  String apexTestSuiteId1 = "05FD00000004CDBMA2";
                  String apexTestClassName1 = "Test_MyClass";
                  String apexTestSuiteName1 = "TestSuite_MySuite";
                  listener.runTests(new String[]{apexTestClassId1, apexTestClassId2},
                    new String[]{apexTestSuiteId1}, 1, new String[]{apexTestClassName1},
                    new String[]{apexTestSuiteName1});
              }
          }
     };
);
//This will subscribe to the TestRun system topic
listener = new RunTestListener(client, toolingConn);
```

```java
import java.util.HashMap;
import org.apache.commons.lang3.StringUtils;
import org.cometd.bayeux.Message;
import org.cometd.bayeux.client.ClientSessionChannel;
import org.cometd.bayeux.client.ClientSessionChannel.MessageListener;
import org.cometd.client.BayeuxClient;

import com.sforce.soap.tooling.ApexTestQueueItem;
import com.sforce.soap.tooling.ApexTestResult;
import com.sforce.soap.tooling.QueryResult;
import com.sforce.soap.tooling.SObject;
import com.sforce.soap.tooling.SoapConnection;
import com.sforce.soap.tooling.TestLevel;
import com.sforce.ws.ConnectionException;

public class RunTestListener {
   private static final String CHANNEL = "/systemTopic/TestResult";
   private SoapConnection conn;

    public RunTestListener(BayeuxClient client, SoapConnection conn) {
       this.conn = conn;
       System.out.println("Subscribing for channel: " + CHANNEL);
       client.getChannel(CHANNEL).subscribe(new MessageListener() {
          @Override
          public void onMessage(ClientSessionChannel channel, Message message) {
             HashMap data = (HashMap) message.getData();
             HashMap sobject = (HashMap) data.get("sobject");
             String id = (String) sobject.get("Id");
             System.out.println("\nAysncApexJob " + id);
             getTestQueueItems(id);
          }
      });
    }

    public void runTests(String[] apexTestClassIds, String[] apexTestSuiteIds,
       Integer maxFailedTests, String[] apexTestClassNames, String[] apexTestSuiteNames) {

        // All parameters are required

        if (apexTestClassIds == null && apexTestSuiteIds == null
           && apexTestClassNames == null && apexTestSuiteNames == null) {
           System.out.println("No tests to run");
           return;
        }
        String classIds = StringUtils.join(apexTestClassIds,", ");
        String suiteIds = StringUtils.join(apexTestSuiteIds,", ");
        String classNames = StringUtils.join(apexTestClassNames,", ");
        String suiteNames = StringUtils.join(apexTestSuiteNames,", ");

        String tests = null;
        Boolean skipCodeCover = false;

        try {
           System.out.println("Running async test run");
           conn.runTestsAsynchronous(classIds, suiteIds, maxFailedTests,
              TestLevel.RunSpecifiedTests, classNames, suiteNames, tests, skipCodeCover);
        } catch (ConnectionException e) {
           e.printStackTrace();
        }
    }
    public void createAndRunTestsNode(String apexTestClassName,
       String apexTestClassId, String[] apexTestMethods) {

        //Currently, the array size of TestNode objects must be 1

        //Provide a non-null class name or a non-null class ID
        if (apexTestClassName != null && apexTestClassId != null) {
           System.out.println("Specify a class name OR a class ID");
           return;
        } else if (apexTestClassName == null && apexTestClassId == null) {
           System.out.println("No tests to run");
           return;
        }

        TestsNode thisTestsNode = new TestsNode();
        thisTestsNode.setClassName(apexTestClassName);
        thisTestsNode.setClassId(apexTestClassId);
        thisTestsNode.setTestMethods(apexTestMethods);
        TestsNode[] tests = new TestsNode[] { thisTestsNode };

        try {
           System.out.println("Running async test run");
           conn.runTestsAsynchronous(null, null, -1, null, null, null, tests);
        } catch (ConnectionException e) {
           e.printStackTrace();
        }
    }

    private void getTestQueueItems(String asyncApexJobId) {
       try {
            QueryResult res = conn
               .query("SELECT Id, Status, ApexClassId FROM ApexTestQueueItem
                  WHERE ParentJobId = '" + asyncApexJobId + "'");
            if (res.getSize() > 0) {
               for (SObject o : res.getRecords()) {
                  ApexTestQueueItem atqi = (ApexTestQueueItem) o;
                  System.out.println("\tApexTestQueueItem - "+atqi.getStatus());
                  if (atqi.getStatus().equals("Completed")) {
                     getApexTestResults(atqi.getId());
                  }
               }
            } else {
               System.out.println("No queued items for " + asyncApexJobId);
            }
         } catch (ConnectionException e) {
            e.printStackTrace();
         }
    }

    private void getApexTestResults(String apexTestQueueItemId) {
       try {
          QueryResult res = conn
           .query("SELECT StackTrace,Message, AsyncApexJobId,MethodName, Outcome,ApexClassId

                  FROM ApexTestResult WHERE QueueItemId = '" + apexTestQueueItemId + "'");
            if (res.getSize() > 0) {
               for (SObject o : res.getRecords()) {
                  ApexTestResult atr = (ApexTestResult) o;
                  System.out.println("\tTest result for "
                     + atr.getApexClassId() + "." + atr.getMethodName());
                  String msg = atr.getOutcome().equals("Fail") ? " - "
                     + atr.getMessage() + " " + atr.getStackTrace() : "";
                  System.out.println("\t\tTest " + atr.getOutcome() + msg);
               }
            } else {
               System.out.println("No Test Results for " + apexTestQueueItemId);
            }
         } catch (ConnectionException e) {
             e.printStackTrace();
         }
    }
}
```

### ApexTestResult

Apex 테스트 메서드 실행 1건의 결과. API 30.0 이상.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`
- **Supported REST API HTTP Methods:** Query, GET

| Field | Type | Properties | Description |
|---|---|---|---|
| ApexClassId | reference | Create, Filter, Group, Sort, Update | The Apex class whose test methods were executed. |
| ApexLogId | reference | Create, Filter, Group, Nillable, Sort, Update | Points to the ApexLog for this test method execution if debug logging is enabled; otherwise, null. |
| ApexTestRunResultId | reference | Create, Filter, Group, Nillable, Sort, Update | The ID of the ApexTestRunResult that represents the entire test run. |
| AsyncApexJobId | reference | Create, Filter, Group, Nillable, Sort, Update | Points to the AsyncApexJob that represents the entire test run. Points to the same object as ApexTestQueueItem.ParentJobId. |
| IsTestSetup | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | Indicates if the results are for a test setup method. The default is false. |
| Message | string | Create, Filter, Nillable, Sort, Update | The exception error message if a test failure occurs; otherwise, null. |
| MethodName | string | Create, Filter, Group, Nillable, Sort, Update | The name of the test method. |
| Outcome | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | The result of the test. Valid values: `Pass`, `Fail`, `CompileFail`, `Skip`. |
| QueueItemId | reference | Create, Filter, Group, Nillable, Sort, Update | Points to the ApexTestQueueItem which is the class that this test method is part of. |
| RunTime | int | Create, Filter, Group, Nillable, Sort, Update | The time it took the test method to run, in seconds. |
| StackTrace | string | Create, Filter, Nillable, Sort, Update | The Apex stack trace if the test failed; otherwise, null. |
| TestCategory | string | Filter, Group, Nillable, Sort | The category of the test class. Available in API version 65.0 and later. Possible values: `Apex` (run Apex tests), `Flow` (run flow tests), `IntegrationTest` (run integration tests — available as a **Developer Preview** in API version 67.0 and later; see Apex Integration Tests for Agentforce and Data 360 Services (Developer Preview) in the Apex Developer Guide). |
| TestName | string | Create, Filter, Group, Nillable, Sort, Update | The name of the test class. Available in API version 65.0 and later. |
| TestNamespace | string | Create, Filter, Group, Nillable, Sort, Update | The namespace of the test class. Apex tests are in the default namespace, so the TestNamespace value for Apex tests is null. Flow tests are in the `FlowTesting` namespace. If a flow test is in a namespaced package or org, the value is `FlowTesting.<NamepacePrefix>`. Available in API version 65.0 and later. |
| TestTimestamp | dateTime | Create, Filter, Sort, Update | The start time of the test method. |

**Usage:** Apex 클래스 실행의 일부로 실행된 테스트 메서드에 대응하는 ApexTestResult 레코드의 필드를 쿼리할 수 있다. 각 ApexTestResult 레코드는 단일 테스트 메서드 실행을 나타낸다. 예) 테스트 클래스에 메서드 6개가 있으면 ApexTestResult 6개가 생성된다(클래스를 나타내는 ApexTestQueueItem 1건과 별도). 각 ApexTestResult에는 실행 중 사용된 Apex 한도를 담는 ApexTestResultLimits 레코드가 연결된다. 예제 코드는 ApexTestQueueItem 참조.

### ApexTestResultLimits

특정 테스트 메서드 실행에서 사용된 Apex 테스트 한도. 각 ApexTestResult에 1건씩 연결된다. API 37.0 이상.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`
- **Supported REST API HTTP Methods:** Query, GET

| Field | Type | Properties | Description |
|---|---|---|---|
| ApexTestResultId | reference | Create, Filter, Group, Sort | The ID of the associated ApexTestResult object. |
| AsyncCalls | int | Create, Filter, Group, Sort, Update | The number of asynchronous calls made during the test run. |
| Callouts | int | Create, Filter, Group, Sort, Update | The number of callouts made during the test run. |
| Cpu | int | Create, Filter, Group, Sort, Update | The amount of CPU used during the test run, in milliseconds. |
| Dml | int | Create, Filter, Group, Sort, Update | The number of DML statements made during the test run. |
| DmlRows | int | Create, Filter, Group, Sort, Update | The number of rows accessed by DML statements during the test run. |
| Email | int | Create, Filter, Group, Sort, Update | The number of email invocations made during the test run. |
| LimitContext | string | Create, Filter, Group, Nillable, Sort, Update | Indicates whether the test run was synchronous or asynchronous. |
| LimitExceptions | string | Create, Filter, Group, Nillable, Sort, Update | Indicates whether your org has any limits that differ from the default limits. |
| MobilePush | int | Create, Filter, Group, Sort, Update | The number of mobile push calls made during the test run. |
| QueryRows | int | Create, Filter, Group, Sort, Update | The number of rows queried during the test run. |
| Soql | int | Create, Filter, Group, Sort, Update | The number of SOQL queries made during the test run. |
| Sosl | int | Create, Filter, Group, Sort, Update | The number of SOSL queries made during the test run. |

**Usage:** ApexTestResultLimits는 각 테스트 메서드 실행마다 채워지며 `Test.startTest()`와 `Test.stopTest()` 사이에서 사용된 한도를 캡처한다. `startTest()`·`stopTest()`를 호출하지 않으면 한도 사용량이 캡처되지 않는다. 유의:
- 연결된 테스트 메서드는 비동기로 실행되어야 한다.
- 테스트 메서드 안에서 호출된 비동기 Apex 작업(batch·scheduled·future·queueable)의 한도는 캡처되지 않는다.
- 한도는 default 네임스페이스에 대해서만 캡처된다.

### ApexTestRunResult

특정 Apex 작업에서 실행된 모든 테스트 메서드의 요약 정보. API 37.0 이상.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`
- **Supported REST API HTTP Methods:** Query, GET

| Field | Type | Properties | Description |
|---|---|---|---|
| AsyncApexJobId | reference | Create, Filter, Group, Nillable, Sort, Update | The parent Apex job ID for the result. |
| ClassesCompleted | int | Create, Filter, Group, Nillable, Sort, Update | The total number of classes executed during the test run. |
| ClassesEnqueued | int | Create, Filter, Group, Sort, Update | The total number of classes enqueued during the test run. |
| EndTime | dateTime | Create, Filter, Nillable, Sort, Update | The time at which the test run ended. |
| IsAllTests | boolean | Create, Filter, Group, Sort, Update | Indicates whether all Apex test classes were run. |
| JobName | string | Create, Filter, Group, Nillable, Sort, Update | Reserved for future use. |
| MethodsCompleted | int | Create, Filter, Group, Nillable, Sort, Update | The total number of methods completed during the test run. Updated after each class is run. |
| MethodsEnqueued | int | Create, Filter, Group, Nillable, Sort, Update | The total number of methods enqueued for the test run. Initialized before the test runs. |
| MethodsFailed | int | Create, Filter, Group, Nillable, Sort, Update | The total number of methods that failed during this test run. Updated after each class is run. |
| Source | string | Create, Filter, Group, Nillable, Sort, Update | The source of the test run, such as the Developer Console. |
| StartTime | dateTime | Create, Filter, Sort, Update | The time at which the test run started. |
| Status | picklist | Create, Filter, Group, Sort, Update | The status of the test run. One of: `Queued`, `Preparing`, `Processing`, `Aborted`, `Completed`, `Failed`. |
| TestSetupTime | int | Create, Filter, Group, Nillable, Sort, Update | The time it took the setup methods to run, in milliseconds. |
| TestTime | int | Create, Filter, Group, Nillable, Sort, Update | The time it took the test to run, in milliseconds. |
| UserId | reference | Create, Filter, Group, Nillable, Sort, Update | The user who ran the test run. |

> 원문에 별도 Usage 단락 없음 — 필드표 종료 후 바로 다음 객체로 이어진다.

### ApexTestSuite

테스트 실행에 포함할 Apex 클래스들의 스위트. 각 클래스는 `TestSuiteMembership` 객체로 스위트에 연결된다. `ens` 네임스페이스에서는 Tooling API 36.0 이상, `mns` 네임스페이스에서는 38.0 이상 사용 가능.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API HTTP Methods:** Query, GET, POST, PATCH, DELETE

**Fields (ens Namespace):**

| Field | Type | Properties | Description |
|---|---|---|---|
| TestSuiteName | string | Create, Filter, Group, Sort, Unique, Update | The name of the Apex test suite. This label appears in the user interface. Case-sensitive and must be unique. |

**Fields (mns Namespace):** (표 형식이 다름 — Field / Field Type / Description)

| Field | Field Type | Description |
|---|---|---|
| testClassName | string[] | A list of Apex test classes, specified by name, to include in this test suite. |

**Usage:** TestSuiteMembership 객체를 API 호출로 insert하여 Apex 클래스를 ApexTestSuite에 연결한다(ApexTestSuite·TestSuiteMembership은 Apex DML로 편집 불가). 스위트에서 클래스를 제거하려면 TestSuiteMembership을 삭제한다. Apex 테스트 클래스나 스위트를 삭제하면 그 클래스·스위트를 포함하는 모든 TestSuiteMembership이 삭제된다. 멤버십 조회:

```sql
SELECT Id FROM TestSuiteMembership WHERE ApexClassId = '01pD0000000Fhy9IAC'
    AND ApexTestSuiteId = '05FD00000004CDBMA2'
```

### TestSuiteMembership

Apex 클래스를 ApexTestSuite에 연결하는 정션 객체. Tooling API 36.0 이상.

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API HTTP Methods:** Query, GET, POST, PATCH, DELETE

| Field | Type | Properties | Description | Relationship |
|---|---|---|---|---|
| ApexClassId | reference | Create, Filter, Group, Sort | The Apex class whose tests are to be executed. This is a relationship field. | Name: ApexClass · Type: Lookup · Refers To: ApexClass |
| ApexTestSuiteId | reference | Create, Filter, Group, Sort | The test suite to which the Apex class is assigned. This is a relationship field. | Name: ApexTestSuite · Type: Lookup · Refers To: ApexTestSuite |

**Usage:** ApexTestSuite와 동일 — TestSuiteMembership을 insert해 클래스를 스위트에 연결, delete로 제거. 위 ApexTestSuite의 SOQL 예제 참조.

---

## 예외 알림 · 복합 타입

### ApexEmailNotification

처리되지 않은 Apex 예외 발생 시 알림을 받을 Salesforce 사용자 ID 또는 외부 이메일 주소를 저장한다. API 35.0 이상.

> [!important] 인증되지 않은 이메일 전송 도메인에서 발생한 시스템 생성 이메일은 From 주소가 인증되어 있어도 전달되지 않는다. Requirements to Send Email from Salesforce 참조.

> Note: 각 ApexEmailNotification은 email 또는 user ID 중 하나만 담는다(둘 다 아님).

- **Supported SOAP API Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`
- **Supported REST API Methods:** DELETE, GET, HEAD, PATCH, POST, Query

| Field | Type | Properties | Description | Relationship |
|---|---|---|---|---|
| Email | string | Create, Filter, Group, idLookup, Nillable, Sort, Update | The external email address to which the notification is sent. Mutually exclusive with the UserId field. | — |
| UserId | reference | Create, Filter, Group, Nillable, Sort, Update | ID of the user to which the notification is sent. Mutually exclusive with the Email field. This is a relationship field. | Name: User · Type: Lookup · Refers To: User |

**Usage:** org 사용자에게 등록된 이메일로 알리려면 UserId를, 외부 사용자·대체 주소로 알리려면 Email을 쓴다.

**See Also:** Apex Developer Guide: Exceptions in Apex

### ApexResult

`ApexExecutionOverlayAction`의 일부로 실행된 Apex 코드의 결과를 나타내는 복합 타입으로, `ApexExecutionOverlayResult`에 담겨 반환된다. API 28.0 이상.

> ApexResult는 complex type이라 Supported SOAP/REST Calls 섹션이 없다(원문도 Fields만 존재). 이 결과를 담는 `ApexExecutionOverlayAction`·`ApexExecutionOverlayResult` 메커니즘은 이 노트 범위 밖 — [[Tooling API 디버그·로그·리플레이 sObject]] 참조.

| Field | Type | Description |
|---|---|---|
| apexError | string | The error text returned if the execution was unsuccessful. |
| apexExecutionResult | ExecuteAnonymousResult | The structured result returned from a successful execution. ExecuteAnonymousResult includes: `column`, `compileProblem`, `compiled`, `exceptionMessage`, `exceptionStackTrace`, `line`, `success`. (ExecuteAnonymousResult is outside the current execution context and doesn't provide access to variables in the heap.) |

**Usage:** 체크포인트에 Apex를 오버레이하여 구조화된 디버깅 정보를 캡처한다. 복합 타입을 다룰 때 SOQL 쿼리가 둘 이상의 레코드를 반환할 수 있으면 한 행만 선택한다(예: `LIMIT=1`, 또는 사용자가 검사할 행을 고르게 함).

### SymbolTable

`ApexClass`·`ApexClassMember`·`ApexTriggerMember`의 Body에 있는 모든 사용자 정의 토큰과, Body 내 라인·컬럼 위치를 나타내는 복합 타입.

> SymbolTable은 complex type — Supported SOAP/REST Calls 섹션이 없다(원문도 Fields 바로 시작).

| Field | Type | Description (+ 중첩 하위 타입 필드) |
|---|---|---|
| constructors | array of Constructor | Position, scope, and signature of constructors for the Apex class. Apex triggers don't have constructors. **Constructor includes:** `annotations`, `location`, `modifiers`, `name`, `references`, `visibility` (API 33.0 이하에서만; scope: Global·Public·Private), `parameters`. |
| externalReferences | array of ExternalReference | Name, namespace, external class, method, and variable references for the Apex class or trigger. Usable for symbol highlighting or code navigation. **ExternalReference includes:** `methods`, `name`, `namespace`, `references`, `variables`. |
| innerClasses | array of SymbolTable | Contains a symbol table for each inner class of the Apex class or trigger. (재귀: 하위 타입이 SymbolTable 자기 자신.) |
| interfaces | array of String | A set of strings for each interface with namespace and name, e.g. `['System.Batchable', 'MyNamespace.MyInterface']`. |
| methods | array of Method | Position, name, scope, signature, and return type of available Apex methods. **Method includes:** `annotations`, `location`, `modifiers`, `name`, `references`, `visibility` (API 33.0 이하에서만; scope: Global·Public·Private), `parameters`, `returnType`. |
| name | string | The name of the Apex class or trigger. |
| namespace | string | The namespace of the Apex class or trigger. Null if there is no namespace. |
| parentClass | string | Returns parents of inner classes and extending classes. |
| properties | array of VisibilitySymbol | Position, name, scope, and references of properties for the Apex class or trigger. **VisibilitySymbol includes:** `annotations`, `location`, `modifiers`, `name`, `references`, `visibility` (API 33.0 이하에서만; scope: Global·Public·Private). |
| tableDeclaration | array of Symbol | Position, name, and references of the Apex class or trigger. **Symbol includes:** `annotations`, `location`, `modifiers`, `name`, `references`. |
| variables | array of Symbol | Position, name, and references of related variables. **Symbol includes:** `annotations`, `location`, `modifiers`, `name`, `references`. |

**중첩 복합 하위 타입 (SymbolTable이 참조):** `Constructor`, `ExternalReference`, `Method`, `VisibilitySymbol`, `Symbol` — 각 하위 타입의 필드는 위 표에 전수 기재. `innerClasses`는 SymbolTable 자기 자신으로 재귀한다.

**Annotations** — `annotations` 필드에 들어갈 수 있는 값 (전수 15개):

`Deprecated`, `Future`, `HttpDelete`, `HttpGet`, `HttpPatch`, `HttpPost`, `HttpPut`, `InvocableMethod`, `InvocableVariable`, `IsTest`, `ReadOnly`, `RemoteAction`, `TestSetup`, `TestVisible`, `RestResource`

**Modifiers** — `modifiers` 필드는 클래스·메서드에 명시된 것보다 많은 값을 포함할 수 있다(암시적 modifier 포함). 예) 모든 `webservice` 메서드는 암시적 `global` modifier를 가진다. 필드·메서드는 별도 지정이 없으면 private이므로 `private` modifier가 기본 반환된다. `testMethod` modifier는 `testMethod` modifier나 `IsTest` annotation을 쓰면 반환된다. `modifiers` 필드에 들어갈 수 있는 값 (전수 15개):

`abstract`, `final`, `global`, `inherited sharing`, `override`, `private`, `protected`, `public`, `static`, `testMethod`, `transient`, `virtual`, `webService`, `with sharing`, `without sharing`

**Usage:** 파서·컴파일러를 직접 만드는 대신 심볼 테이블을 쓴다. 심볼 하이라이팅, 코드 네비게이션, 코드 자동완성, 심볼 검색 등에 활용한다. `ContentEntityId` 필드가 참조하는 콘텐츠가 심볼 테이블을 사용하지 않으면 심볼 테이블이 생성되지 않는다. `MetadataContainerId` 필드의 MetadataContainer 마지막 배포에 컴파일 오류가 있어도 심볼 테이블이 생성되지 않는다.

---

## v68.0 신규 REST 리소스 — Apex 심볼·컴파일 결과 (Winter '27)

Winter '27(API 68.0)에서 Apex 코드 도메인에 **REST 리소스 2개**가 추가됐다. 둘 다 sObject가 아니라 `/services/data/vXX.X/tooling/` 하위 REST 엔드포인트지만, 대상이 Apex 클래스·트리거이고 위 [SymbolTable](#symboltable)·[ApexClass](#apexclass)의 `IsValid`와 직접 맞물리는 영역이라 **레퍼런스 본문을 이 노트에 둔다**. REST 리소스 **카탈로그 목록**(전체 리소스 표·base URI 규칙)은 [[Tooling API — 개요·REST·SOAP 호출 기초]] 소관이다.

| 리소스 | 메서드 | 최소 API | 필요 권한 | 상태 |
|---|---|---|---|---|
| `/tooling/symbols` — Apex Symbol API | GET | 68.0 | **Author Apex**(org) + **View Setup**(user) | **Beta** |
| `/tooling/apexCompileResults` | POST | 68.0 | **Author Apex**(org) | (PDF에 Beta·pilot 표기 없음) |

> 출처: `Winter27-v68-Docs/api_tooling.pdf` (Tooling API Reference and Developer Guide **v68.0, Winter '27**, 2026-08-21 갱신) 인쇄 p.29–37.
> ⚠️ 레포의 `Salesforce Documents/api_tooling.pdf`(v67.0 Summer '26)에는 이 두 리소스가 **전혀 없다**(`apexCompileResults` 0회 · `typeStubs` 0회). 인용 경로는 항상 `Winter27-v68-Docs/` 하위 파일이다.

---

### Apex Symbol API (Beta) — `GET /tooling/symbols`

Apex Symbol API로 **built-in·custom·packaged·dynamic Apex 타입**의 상세 메타데이터(클래스·인터페이스·enum·메서드·트리거 포함)를 retrieve한다. API 68.0 이상. 이 리소스는 **Author Apex org 권한**과 **View Setup 사용자 권한**을 요구한다.

> [!important] Beta 서비스
> *Apex Symbol API is a pilot or beta service that is subject to the Beta Services Terms at Agreements and Terms or a written Unified Pilot Agreement if executed by Customer, and applicable terms in the Product Terms Directory. Use of this pilot or beta service is at the Customer's sole discretion.* (인쇄 p.31 원문)

#### Syntax

- **URI:** `/services/data/vXX.X/tooling/symbols/`
- **HTTPS Method:** GET
- **Authentication:** `Authorization: Bearer token`
- **Format:** JSON

> `/tests`와 달리 Syntax 목록에 **Response Encoding(`X-Chatter-Entity-Encoding`) 항목이 없다** — PDF 인쇄 p.31에는 URI·Method·Authentication·Format 4개만 기재돼 있다(없는 항목을 채워 넣지 않는다).

#### Request Query Parameters (인쇄 p.32 — 전수 3개)

| Name | Type | Description |
|---|---|---|
| `category` | String | **Required.** retrieve할 Apex 타입의 카테고리. 가능한 값: • `builtin` — standard Apex types, such as types in the System, Database, and Messaging namespaces. • `database` — custom and packaged Apex types. • `dynamic` — dynamic Apex types. |
| `namespace` | String | **Optional.** 결과를 특정 namespace로 필터. **local org namespace의 타입만 retrieve하려면 빈 문자열을 전달한다(`namespace=`).** 이 파라미터를 생략하면 해당 category의 **모든 namespace** Apex 타입이 반환된다. |
| `name` | String | **Optional.** 결과를 지정한 Apex 타입 이름으로 필터. `namespace`와 `name`을 **둘 다** 지정하면 결과는 **두 조건을 모두 만족**해야 한다. |

**Request Body Properties:** None.

#### Response Body Properties (인쇄 p.32)

| Name | Type | Description |
|---|---|---|
| `typeStubs` | Object[] | Apex 타입 배열. 각 객체는 Apex 클래스·인터페이스·enum·트리거 **하나**를 기술하며, 가능한 경우 field·property·method·annotation·documentation 같은 멤버를 포함한다. |

#### `typeStubs` 배열 요소 속성 (인쇄 p.32–33 — 전수 15개)

| Name | Type | Description |
|---|---|---|
| `name` | String | Apex 타입 stub의 developer name. |
| `namespacePrefix` | String | Apex 타입의 namespace. 타입에 namespace가 없으면 `null`. |
| `kind` | String | Apex 타입의 종류. 가능한 값은 `CLASS`, `INTERFACE`, `ENUM`, `TRIGGER`. |
| `modifiers` | String[] | 타입에 적용된 modifier — 예: `public`, `global`, `virtual`, `abstract`. |
| `annotations` | Object[] | 타입에 적용된 annotation — 예: `AuraEnabled`, `IsTest`, `NamespaceAccessible`. |
| `superClass` | Object | superclass에 대한 **type reference**. 타입에 superclass가 없으면 `null`. |
| `interfaces` | Object[] | 타입이 구현하는 인터페이스들의 **type reference**. |
| `fields` | Object[] | 타입에 선언된 field. field는 메서드 내부가 아니라 **타입 레벨에 선언된 변수**다. |
| `properties` | Object[] | 타입에 선언된 property. |
| `methods` | Object[] | 타입에 선언된 **메서드와 생성자**. |
| `innerTypes` | Object[] | 타입 내부에 선언된 중첩 Apex 타입. 각 중첩 타입은 **최상위 type stub과 동일한 구조**를 사용한다(재귀). |
| `triggerOperations` | String[] | 트리거의 경우 트리거 operation — 예: `BEFORE UPDATE`. 트리거가 아닌 타입에서는 `null`. |
| `documentation` | String | 타입의 문서. **built-in 타입**에서는 공식 usage guidance를 포함할 수 있고, **custom 타입**에서는 ApexDoc 주석을 포함할 수 있다. **API 68.0에서는 managed package의 ApexDoc 주석이 반환되지 않는다.** |
| `triggerObjectType` | Object | 트리거의 경우 트리거가 정의된 sObject에 대한 **type reference**. 트리거가 아닌 타입에서는 `null`. |
| `compileError` | String | 해당 타입의 심볼 추출 중 **컴파일 오류가 발생한 경우** 그 오류 메시지. 그렇지 않으면 `null`. |

#### Annotations 배열 속성 (인쇄 p.33)

`annotations` 배열의 각 객체가 가질 수 있는 속성.

| Name | Type | Description |
|---|---|---|
| `name` | String | annotation 이름. |
| `parameters` | Object[] | annotation 파라미터. |
| `documentation` | String | annotation 문서(있는 경우). |

#### Annotation Parameters 배열 속성 (인쇄 p.33–34)

annotation의 `parameters` 배열의 각 객체가 가질 수 있는 속성.

| Name | Type | Description |
|---|---|---|
| `name` | String | 파라미터 이름. |
| `type` | Object | 파라미터 타입에 대한 **type reference**. |
| `value` | String | 파라미터 값. |

#### Fields 배열 속성 (인쇄 p.34)

`fields` 배열의 각 객체가 가질 수 있는 속성.

| Name | Type | Description |
|---|---|---|
| `name` | String | field 이름. |
| `type` | Object | field 타입에 대한 **type reference**. |
| `modifiers` | String[] | field modifier. |
| `annotations` | Object[] | field annotation. |
| `documentation` | String | field 문서(있는 경우). |
| `definingType` | Object | 이 field를 **원래 선언한** Apex 타입에 대한 type reference. **상속된 field에만 설정**되며, field가 감싸는 타입에 직접 선언된 경우에는 **생략(omitted)** 된다. |

#### Properties 배열 속성 (인쇄 p.34)

`properties` 배열의 각 객체가 가질 수 있는 속성.

| Name | Type | Description |
|---|---|---|
| `name` | String | property 이름. |
| `type` | Object | property 타입에 대한 **type reference**. |
| `modifiers` | String[] | property modifier. |
| `annotations` | Object[] | property annotation. |
| `getter` | Object | property에 **get accessor가 있으면 존재**. 객체는 `modifiers` 배열과 `documentation` 속성을 포함한다. |
| `setter` | Object | property에 **set accessor가 있으면 존재**. 객체는 `modifiers` 배열과 `documentation` 속성을 포함한다. |
| `documentation` | String | property 문서(있는 경우). |
| `definingType` | Object | 이 property를 원래 선언한 Apex 타입에 대한 type reference. **상속된 property에만 설정**되며, 직접 선언된 경우 생략된다. |

#### Methods 배열 속성 (인쇄 p.35)

`methods` 배열의 각 객체가 가질 수 있는 속성.

| Name | Type | Description |
|---|---|---|
| `name` | String | 메서드 또는 생성자 이름. |
| `isConstructor` | Boolean | 멤버가 생성자면 `true`, 그렇지 않으면 **`null`**. |
| `returnType` | Object | 반환 타입에 대한 **type reference**. **생성자에서는 `null`**. |
| `modifiers` | String[] | 메서드 modifier. |
| `annotations` | Object[] | 메서드 annotation. |
| `parameters` | Object[] | 메서드 파라미터. |
| `documentation` | String | 메서드 문서(있는 경우). |
| `definingType` | Object | 이 메서드를 원래 선언한 Apex 타입에 대한 type reference. **상속된 메서드에만 설정**되며, 직접 선언된 경우 생략된다. |

#### Methods Parameter 배열 속성 (인쇄 p.35)

메서드의 `parameters` 배열의 각 객체가 가질 수 있는 속성.

| Name | Type | Description |
|---|---|---|
| `name` | String | 파라미터 이름. |
| `type` | Object | 파라미터 타입에 대한 **type reference**. |
| `annotations` | Object[] | 파라미터 annotation. |
| `documentation` | String | 파라미터 문서(있는 경우). |

#### Type Reference 속성 (인쇄 p.35–36)

응답의 여러 속성은 타입을 **문자열로 반환하지 않고 중첩 type reference 객체**로 반환한다. 이 구조는 타입을 개발 도구가 소비할 수 있는 조각으로 분리한다.

type reference가 나타나는 속성 (전수 7곳):

- `superClass`
- `interfaces` 배열의 객체
- field 또는 property의 `type` 속성
- 메서드의 `returnType` 속성
- 상속된 field·method·property의 `definingType` 속성
- 파라미터의 `type` 속성
- `triggerObjectType`

각 type reference 객체가 가질 수 있는 속성.

| Name | Type | Description |
|---|---|---|
| `namespacePrefix` | String | 참조된 타입의 namespace. 타입에 namespace가 없으면 `null`. |
| `name` | String | 참조된 타입의 이름. |
| `typeParameters` | Object[] | generic 타입 인자에 대한 type reference — 예: `List<String>`의 `String`. 타입이 parameterize되지 않았으면 `null`. |

#### Usage (인쇄 p.36)

Apex Symbol API로 다음과 같은 도구를 만든다.

- **full generic type support를 갖춘 code completion 제공.** 예: `List<Account>`가 내부 인코딩 대신 읽기 쉬운 타입 파라미터로 표시된다.
- built-in 타입의 **공식 문서(usage guidance·예제 포함) 표시**.
- custom 타입의 **ApexDoc 주석 표시**.
- **생성자 시그니처**를 파라미터 타입·annotation·modifier와 함께 표시.
- 소스 코드를 파싱하지 않고 **트리거 operation 식별**(예: `before insert`, `after update`).
- **모든 표준 Apex namespace**(예: System·Database·Messaging)의 타입 정보 접근.

#### Considerations (인쇄 p.36 — 전수 2건)

- **동시성 한도: org당 요청 1건.** 요청이 진행 중인 상태에서 같은 org에 대해 두 번째 요청이 들어오면 **두 번째 요청은 실패**한다. 같은 org에서 이 API를 **병렬 호출하지 않는다.**
- **API 68.0에서는 managed package의 ApexDoc 주석이 반환되지 않는다.** global identifier에 대한 packaged ApexDoc 주석은 **이후 API 버전에 예정**돼 있다.

#### Example (인쇄 p.36–37)

**Example Request** — System namespace의 built-in `ApexPages` 타입을 retrieve한다.

```bash
# Winter27-v68-Docs/api_tooling.pdf (v68.0) p.36 — Example Request 원문
GET
"https://MyDomain.my.salesforce.com/services/data/v68.0/tooling/symbols?category=builtin&namespace=System&name=ApexPages"
```

**Example Response Body (excerpt)** — PDF가 `(excerpt)`라고 명시한 발췌본이며, `documentation` 값도 원문에서 `...`으로 잘려 있다(그대로 옮긴다).

```json
// Winter27-v68-Docs/api_tooling.pdf (v68.0) p.36–37 — Example Response Body (excerpt) 원문
{
  "typeStubs": [
    {
      "name": "ApexPages",
      "namespacePrefix": "System",
      "kind": "CLASS",
      "modifiers": [
        "global"
      ],
      "annotations": [],
      "superClass": null,
      "interfaces": [],
      "fields": [],
      "properties": [],
      "methods": [
        {
          "name": "addMessage",
          "isConstructor": null,
          "returnType": {
            "namespacePrefix": null,
            "name": "void",
            "typeParameters": null
          },
          "modifiers": [
            "global",
            "static"
          ],
          "annotations": [],
          "parameters": [
            {
              "name": "message",
              "type": {
                "namespacePrefix": "ApexPages",
                "name": "Message",
                "typeParameters": null
              },
              "annotations": [],
              "documentation": ""
            }
          ],
          "documentation": "Add a message to the current page context."
        }
      ],
      "innerTypes": [],
      "triggerOperations": null,
      "documentation": "Use ApexPages to add and check for messages associated...",
      "triggerObjectType": null,
      "compileError": null
    }
  ]
}
```

#### Symbol API vs. `SymbolTable` 복합 타입 — 무엇을 쓰나

둘 다 Apex 타입의 심볼 정보를 주지만 **획득 경로와 커버리지가 다르다.**

| 관점 | `SymbolTable` (복합 타입) | Apex Symbol API (`/tooling/symbols`) |
|---|---|---|
| 획득 방법 | `ApexClass`·`ApexClassMember`·`ApexTriggerMember`의 필드로 반환 (SOQL/컨테이너 경유) | 전용 REST GET 리소스 직접 호출 |
| 대상 범위 | org의 **사용자 정의** 클래스·트리거 Body의 토큰 | `category`로 **built-in / custom·packaged / dynamic** 타입 |
| generic 표현 | `interfaces`가 `['System.Batchable', ...]` 문자열 집합 | **type reference 객체**(`typeParameters`로 `List<String>` 분해) |
| 문서 | 없음 | `documentation`(built-in usage guidance·custom ApexDoc) |
| 트리거 | Body 토큰 위주 | `triggerOperations`·`triggerObjectType` 명시 |
| API 버전 | 기존 | **68.0+ (Beta)** |

> 릴리즈 노트(help.salesforce.com `rn_apex_symbol_api`)는 이 API가 **Apex 컴파일러가 사용하는 것과 동일한 타입 정보**를 노출해 기존 `/completions` 엔드포인트와 `SymbolTable` 오브젝트가 남긴 공백을 메운다고 설명한다 — [[Winter '27/Development]] 참조. (이 문장의 출처는 PDF가 아니라 릴리즈 노트다.)

---

### 무효 Apex 컴파일 결과 — `POST /tooling/apexCompileResults`

**validation error가 있는** Apex 클래스·트리거의 컴파일 결과를 retrieve한다. 결과를 정기적으로 모니터링하면 컴파일 이슈를 탐지·대응할 수 있다. API 68.0 이상. 이 리소스는 **Author Apex org 권한**을 요구한다.

#### Syntax (인쇄 p.29)

- **URI:** `/services/data/vXX.X/tooling/apexCompileResults/`
- **HTTPS Method:** POST
- **Authentication:** `Authorization: Bearer token`
- **Format:** JSON

**Request Parameters:** None.

**Request Body:** 요청 본문은 **빈 JSON 객체(`{}`)여야 한다. 어떤 필드든 지정하면 오류가 반환된다.**

#### Response Body Properties (인쇄 p.29)

| Name | Type | Description |
|---|---|---|
| `status` | String | 컴파일의 **operation-level** 결과. 가능한 값: • `OK` — 모든 무효 Apex 클래스·트리거가 성공적으로 컴파일됐거나, 재컴파일이 필요한 무효 클래스·트리거가 **없었다**. • `PARTIAL_FAILURE` — **최소 하나**의 무효 Apex 클래스 또는 트리거가 컴파일에 실패했다. |
| `results` | Object[] | **컴파일에 실패한** Apex 클래스·트리거의 컴파일 결과 배열. 각 객체는 클래스·트리거 이름, namespace, 성공 지시자, 오류, 경고를 포함한다. **성공적으로 컴파일된 클래스·트리거는 포함되지 않는다.** **경고(warnings)는 해당 클래스·트리거에 컴파일 오류도 함께 있을 때만 포함된다.** 전체 컴파일이 실패 없이 성공하면 이 배열은 비어 있다. |

#### `results` 배열 요소 속성 (인쇄 p.30)

| Name | Type | Description |
|---|---|---|
| `name` | String | Apex 클래스 또는 트리거의 developer name. |
| `namespace` | String | Apex 클래스 또는 트리거의 namespace. **default namespace면 빈 문자열**. |
| `success` | Boolean | Apex 클래스·트리거가 성공적으로 컴파일됐는지 여부. 컴파일 문제가 **없으면 `true`**, 문제가 **하나 이상 있으면 `false`**. **경고만 있는 결과(warning-only outcomes)는 여전히 성공으로 간주되므로 `results` 배열에 반환되지 않는다.** |
| `problems` | Object[] | Apex 클래스·트리거의 컴파일 **오류** 배열. `success`가 `true`면 비어 있다. |
| `warnings` | Object[] | Apex 클래스·트리거의 컴파일 **경고** 배열. 경고는 **컴파일 오류도 함께 있는** 클래스·트리거에 대해서만 반환된다. |

#### `problems`·`warnings` 배열 요소 속성 (인쇄 p.30)

| Name | Type | Description |
|---|---|---|
| `line` | Integer | 오류·경고가 발생한 소스 **행**. 행이 해당되지 않으면 값은 `0`. |
| `column` | Integer | 문제·경고의 소스 **열**. 열이 해당되지 않으면 값은 `0`. |
| `message` | String | 컴파일 오류·경고에 대한 설명. |

#### Usage (인쇄 p.30 — 전수 2건)

- `apexCompileResults` 리소스는 **무효 Apex 클래스·트리거의 컴파일 결과를 retrieve**하는 용도다. 무효 클래스·트리거를 **재컴파일하려면** Setup의 Apex Classes / Apex Triggers 페이지에 있는 **"Compile only invalid classes"·"Compile only invalid triggers" 버튼**을 사용한다. PDF는 *"Setup 버튼을 통한 컴파일 성공은 해당 Apex 클래스·트리거의 `IsValid` 필드를 `true`로 갱신한다. `apexCompileResults`로 컴파일 결과를 retrieve하는 것은 이 필드를 갱신하지 않는다"* 고 기술한다.
  > ⚠️ **소스 충돌** — 릴리즈 노트는 이와 **정반대**(Setup 버튼으로 성공해도 `isValid`가 갱신되지 않고 `false`로 남는다)로 서술한다. 상세 대조는 [[Winter '27/Development]]에 기록돼 있으며, 여기서 임의로 한쪽을 채택하지 않는다. **API 조회가 필드를 갱신하지 않는다는 점만 양측이 일치**한다.
- **요청은 동기(synchronous)** 다.

관련 필드: 이 리소스가 말하는 "무효(invalid)" 상태와 맞물리는 sObject 필드는 [ApexClass](#apexclass)·[ApexTrigger](#apextrigger)의 `IsValid`다 — 각 필드 표의 원문 설명을 참조한다.

#### Example (인쇄 p.30–31)

**Example Request Body**

```json
// Winter27-v68-Docs/api_tooling.pdf (v68.0) p.30 — Example Request Body 원문
{}
```

**Example Response Body on Successful Compilation** — 모든 무효 Apex 클래스·트리거가 성공적으로 컴파일됐거나, 재컴파일이 필요한 것이 없을 때 반환된다.

```json
// Winter27-v68-Docs/api_tooling.pdf (v68.0) p.30 — Example Response Body (OK) 원문
{
  "status": "OK",
  "results": []
}
```

**Example Response Body on Partial Failure** — 최소 하나의 무효 Apex 클래스·트리거가 컴파일에 실패했을 때 반환된다.

```json
// Winter27-v68-Docs/api_tooling.pdf (v68.0) p.31 — Example Response Body (PARTIAL_FAILURE) 원문
{
  "status": "PARTIAL_FAILURE",
  "results": [
    {
      "name": "MyInvalidClass",
      "namespace": "MyNamespace",
      "success": false,
      "problems": [
        {
          "line": 14,
          "column": 9,
          "message": "Variable does not exist: var1"
        }
      ],
      "warnings": [
        {
          "line": 0,
          "column": 0,
          "message": "Apex API version 18.0 is scheduled for retirement. Update to the
latest API version to avoid compile failures."
        }
      ]
    }
  ]
}
```

> 위 코드 블록의 `message` 값이 두 줄로 끊긴 것은 **PDF 원문의 줄바꿈 그대로**다(임의로 잇지 않았다).

#### ⚠️ 미해결 소스 충돌 — "경고만 있는 결과"가 `results`에 반환되는가

두 Tier 2 공식 소스가 **정면으로 충돌**한다. 어느 쪽이 최종인지 임의로 판단하지 않고 양쪽을 그대로 기록한다(2026년 10월 GA 시점 재확인 대상).

| 소스 | 서술 |
|---|---|
| **`Winter27-v68-Docs/api_tooling.pdf` v68.0 (인쇄 p.29–30)** | `results`는 **컴파일에 실패한** 클래스·트리거만 담는다. `success`는 문제가 없으면 `true`이며, *"Warning-only outcomes are still considered successful, so these outcomes aren't returned in the `results` array."* — 즉 **경고만 있는 결과는 반환되지 않는다.** `warnings`는 **컴파일 오류가 함께 있을 때만** 반환된다. |
| **릴리즈 노트 (help.salesforce.com `rn_apex_recompile_invalid_apex`)** | 같은 `PARTIAL_FAILURE` 응답 예제에 결과가 **2건** 들어 있고, 그중 하나가 **`"success": true` · `"problems": []` · `warnings`만 채워진 항목**이다 — 즉 **경고만 있는 결과가 `results`에 그대로 반환된다.** |

- 두 소스는 같은 시나리오의 **예제 값도 다르다** — PDF 예제의 경고 메시지는 *"Apex API version 18.0 …"*, 릴리즈 노트 예제는 *"Apex API version 16.0 …"* 이다(둘 다 원문 그대로). 동일 응답의 서로 다른 판본으로 보인다.
- **실무 함의:** 클라이언트를 만들 때 `results` 항목에 `success == true`가 **올 수 있다고 가정하고 방어적으로** 처리하는 편이 안전하다(PDF 규칙이 맞더라도 손해가 없다).
- 충돌하는 **릴리즈 노트 측 예제 응답 원문**과 `IsValid` 충돌(충돌 1)의 전문은 [[Winter '27/Development]]에 기록돼 있다.

---

## 관련 노트

- [[Tooling API — 개요·REST·SOAP 호출 기초]] — 폴더 허브(REST/SOAP 호출 기초·When to Use)
- [[Tooling API — Objects and Namespaces (객체 분류)]] — 네임스페이스 4분류·System Fields·ApiFault 색인
- [[Tooling API 배포]] — `ApexClassMember`·`ApexTriggerMember`·`ApexComponentMember`·`ApexPageMember`·MetadataContainer·ContainerAsyncRequest (편집/저장/컴파일 컨테이너 패밀리)
- [[Tooling API 디버그·로그·리플레이 sObject]] — `ApexLog`·`ApexExecutionOverlayAction`·`ApexExecutionOverlayResult`·ExecuteAnonymousResult (디버그·리플레이 패밀리)
- [[Metadata Types — Apex & Code]] — Metadata API의 declarative `ApexClass`·`ApexTrigger` 타입(Tooling sObject와 별개)
- [[Tooling API 객체 — Entity·Field·스키마]] — 같은 Tooling 객체 패밀리의 스키마 군 형제 노트. `ApexTrigger.EntityDefinitionId`가 가리키는 EntityDefinition·FieldDefinition·CustomField 등 28객체.
- [[Tooling API 객체 — 보안·권한]] — 같은 Tooling 객체 패밀리의 보안·권한 군 형제 노트. 보안·권한·접근통제 sObject 38종(PermissionSet·Profile·NamedCredential·RestrictionRule 등).
- [[Tooling API 객체 — 자동화 (Flow·Workflow·룰)]] — 선언적 자동화 sObject 19종(Flow·Workflow·ValidationRule·MatchingRule 등) 형제 Ch4 도메인 노트. FlowTestCoverage·FlowElementTestCoverage가 본 노트의 ApexCodeCoverage와 같은 커버리지 도메인.
- [[Tooling API 객체 — UI·레이아웃 (페이지·액션·탭)]] — UI·레이아웃·페이지·액션 sObject 22종(FlexiPage·Layout·QuickAction·WebLink·Path 등) 형제 Ch4 도메인 노트. ApexPage/ApexComponent의 UI 짝(Layout·FlexiPage·CustomTab 등).
- [[Tooling API 객체 — Lightning (Aura·LWC 번들)]] — Aura·LWC 컴포넌트 번들 sObject 5종(AuraDefinition·LightningComponentBundle 등) 형제 Ch4 도메인 노트. 본 노트의 `ApexComponent`(Visualforce)는 Aura와 별개이며, Aura/LWC 번들 객체는 여기 소관.
- [[Tooling API 객체 — 운영·라이프사이클 (Sandbox·배포·릴리즈)]] — org 운영·라이프사이클 sObject 18종(Sandbox·DeployRequest·ReleaseUpdate·SourceMember·My Domain 등) 형제 Ch4 도메인 노트.
- [[Tooling API 객체 — 패키징·브랜딩 (1GP·2GP·정적콘텐츠)]] — 패키징·브랜딩·정적콘텐츠 sObject 20종(MetadataPackage·Package2·SubscriberPackage·BrandingSet·StaticResource 등) 형제 Ch4 도메인 노트.
- [[Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널)]] — User·플랫폼이벤트·CDC 채널·이벤트 릴레이 sObject 7종 형제 Ch4 도메인 노트.
- [[Tooling API 객체 — 통합·데이터·결제·마케팅 (외부서비스·Data Kit·페이먼트·Account Engagement)]] — SOQLResult 등 종속 복합타입의 Tooling API 정의(ApexExecutionOverlayResult 본체는 본 노트군).
- [[테스트 전략]] — Apex 테스트 작성·커버리지 패턴(질의가 아닌 작성 관점)
- [[Winter '27/Development]] — v68.0 릴리즈 맥락. Apex Symbol API(Beta)·`apexCompileResults`의 릴리즈 노트 측 서술과 **PDF와 충돌하는 2건**(`IsValid` 갱신 여부 · 경고만 있는 결과의 반환 여부) 전문이 여기 기록돼 있다.
