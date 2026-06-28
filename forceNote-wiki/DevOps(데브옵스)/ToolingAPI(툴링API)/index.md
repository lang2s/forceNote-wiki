---
tags: [index, devops, tooling-api]
created: 2026-06-27
---

# ToolingAPI — 로컬 인덱스

> Salesforce Tooling API v67.0 (Summer '26) — 개발 도구용 메타데이터에 SOQL·REST·SOAP로 세밀하게 접근하는 API 전체 레퍼런스

**상위:** [[DevOps(데브옵스)/index]] | [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Tooling API — 개요·REST·SOAP 호출 기초]] | When to Use·REST Overview·REST 리소스 12개·단위테스트 REST·Composite·API EOL·SOAP 호출 16개 | #overview #reference |
| [[Tooling API — Objects and Namespaces (객체 분류)]] | WSDL 네임스페이스 4종·네임스페이스 4분류(Programming/Setup/Tooling/Operational)·객체↔네임스페이스 매핑·System Fields·SOQL/SOSL 제약·ApiFault·Tooling API Faults | #reference #namespace #soql |
| [[Tooling API — SOAP·REST 헤더]] | SOAP 헤더 8개(AllOrNoneHeader·AllowFieldTruncationHeader·CallOptions·DebuggingHeader·DisableFeedTrackingHeader·MetadataWarningsHeader·PackageVersionHeader·SessionHeader)·REST 헤더 4개(Call Options·Limit Info·Package Version·Query Options)·debugLevel/LogCategory/LogCategoryLevel enum | #reference #soap #rest #header |
| [[Tooling API 객체 — Apex 코드·테스트·커버리지]] | Apex 코드·테스트·커버리지 객체 17개(ApexClass·ApexTrigger·ApexComponent·ApexPage·ApexPageInfo·ApexCodeCoverage·ApexCodeCoverageAggregate·ApexOrgWideCoverage·ApexTestQueueItem·ApexTestResult·ApexTestResultLimits·ApexTestRunResult·ApexTestSuite·TestSuiteMembership·ApexEmailNotification·ApexResult·SymbolTable) | #reference #apex #testing #coverage |
| [[Tooling API 객체 — Entity·Field·스키마]] | 스키마 객체 28개(EntityDefinition·EntityParticle·FieldDefinition·CustomField·CustomObject·CustomFieldDisplay·CustomFieldMember·DataType·RecordType·RelationshipDomain·RelationshipInfo·ObjectHierarchyRelationship·Index·IndexField·LookupFilter·FieldSet·FieldMapping·FormulaFunction·GlobalValueSet·EntityLimit·OwnerChangeOptionInfo·BusinessProcessDefinition·EnrichedField·ServiceFieldDataType(제거)) | #reference #schema #entity #field |
| [[Tooling API 객체 — 보안·권한]] | 보안·권한·접근통제 객체 38종(PermissionSet·PermissionSetAssignment·PermissionSetGroup·PermissionSetGroupComponent·PermissionSetTabSetting·PermissionDependency·Profile·ProfileLayout·NamedCredential·ExternalCredential·ExternalDataSource·ExternalDataSrcDescriptor·ExternalAuthIdentityProvider·ExternalClientAppSettings·ConnectedApplication·RemoteProxy·CspTrustedSite·Certificate·AuthorizedEmailDomain·RestrictionRule·FieldRestrictionRule·UserAccessPolicy·UserAccessPolicyAction·UserAccessPolicyFilter·UserEntityAccess·UserFieldAccess·SecurityHealthCheck·SecurityHealthCheckRisks·TransactionSecurityPolicy·IPAddressRange·InboundNetworkConnection·InboundNetworkConnProperty·OutboundNetworkConnection·OutboundNetworkConnProperty·DelegateGroup·DelegateGroupGrant·DelegateGroupMember·Group) | #reference #security #permissions |

---

## 빠른 선택

- Tooling API가 뭔지, 언제 쓰는지? → [[Tooling API — 개요·REST·SOAP 호출 기초]]
- REST 리소스 URI·메서드 목록? → [[Tooling API — 개요·REST·SOAP 호출 기초]] → REST Resources
- 단위 테스트를 REST로 실행/조회? → [[Tooling API — 개요·REST·SOAP 호출 기초]] → REST Resources for Unit Testing
- SOAP 호출 목록? → [[Tooling API — 개요·REST·SOAP 호출 기초]] → SOAP Calls
- 네임스페이스 4분류·SOQL 제약·ApiFault가 필요하다 → [[Tooling API — Objects and Namespaces (객체 분류)]]
- SOAP/REST 호출에 세션·디버그·패키지 버전 헤더를 넣는 법, API 사용량 헤더? → [[Tooling API — SOAP·REST 헤더]]
- ApexClass·테스트 결과·코드 커버리지·SymbolTable이 필요하다 → [[Tooling API 객체 — Apex 코드·테스트·커버리지]]
- EntityDefinition·FieldDefinition·CustomField·스키마 메타데이터가 필요하다 → [[Tooling API 객체 — Entity·Field·스키마]]
- PermissionSet·Profile·NamedCredential·접근통제·보안 sObject가 필요하다 → [[Tooling API 객체 — 보안·권한]]
- 컨테이너 기반 Apex 배포? → [[Tooling API 배포]]
- TraceFlag·ApexLog·체크포인트 등 디버그/로그? → [[Tooling API 디버그·로그·리플레이 sObject]]

---

## 관련 폴더

- 메타데이터 타입(declarative) 카탈로그 → [[DevOps(데브옵스)/MetadataAPI(메타데이터API)/index|MetadataAPI]]
- 배포 경로 비교 → [[Apex 배포 방법]]
