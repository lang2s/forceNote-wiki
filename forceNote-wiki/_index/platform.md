---
tags: [index, search, navigation]
created: 2026-05-21
---

# SEARCH INDEX — 플랫폼 (Architecture / Admin / Integration)
> VF·Site·Canvas·AppLauncher·VisualEditor·Enhanced Domains·Admin·외부연동 키워드 → 파일
> DevOps/DX(Salesforce DX·패키징·CI/CD·Metadata API)는 별도 샤드 `_index/platform-devops.md` 참조.
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.

## Architecture — Site Namespace

| 키워드 | 파일 |
|---|---|
| Site Namespace, Site.UrlRewriter, UrlRewriter, Sites URL 재작성, Force.com Sites, URL rewriting, generateUrlFor, mapRequestUrl, SEO 친화적 URL, Salesforce Sites URL | `Architecture(아키텍처)/Site Namespace.md` |
| Site.ExternalUserCreateException, 외부 사용자 생성 예외, getDisplayMessages, 커뮤니티 사용자 생성 실패 | `Architecture(아키텍처)/Site Namespace.md` |
| Site namespace와 Experience Cloud 차이, UrlRewriter 등록 방법, Sites URL rewrite setup | `Architecture(아키텍처)/Site Namespace.md` |
| Context Namespace, Context.IndustriesContext, IndustriesContext, Context Service Apex, Industries Context, 컨텍스트 서비스, Financial Services Cloud Context, Health Cloud Context, 비즈니스 컨텍스트 공유 | `Architecture(아키텍처)/Context Namespace.md` |

## Architecture — ApexPages Namespace

| 키워드 | 파일 |
|---|---|
| ApexPages Namespace, ApexPages 네임스페이스, Visualforce 컨트롤러, VF 컨트롤러, StandardController, StandardSetController, ApexPages.Action, ApexPages.Message, ApexPages.Component | `Architecture(아키텍처)/ApexPages Namespace.md` |
| StandardController 확장, 표준 컨트롤러 확장, getRecord, addFields, getId, save cancel delete edit view, 컨트롤러 확장 클래스, VF 표준 컨트롤러 | `Architecture(아키텍처)/ApexPages Namespace.md` |
| StandardSetController, 목록 컨트롤러, 페이지네이션, getRecords, getHasNext, getHasPrevious, setPageSize, getSelected, setSelected, getCompleteResult, 10000 레코드 한도 | `Architecture(아키텍처)/ApexPages Namespace.md` |
| ApexPages.Message, Severity enum, CONFIRM ERROR FATAL INFO WARNING, VF 유효성 검사 오류, 커스텀 컨트롤러 오류 처리 | `Architecture(아키텍처)/ApexPages Namespace.md` |
| IdeaStandardController, IdeaStandardSetController, getCommentList, getIdeaList, Idea 컨트롤러 | `Architecture(아키텍처)/ApexPages Namespace.md` |
| KnowledgeArticleVersionStandardController, Knowledge 문서 컨트롤러, getSourceId, setDataCategory | `Architecture(아키텍처)/ApexPages Namespace.md` |
| ApexPages.Component, childComponents, expressions, facets, 동적 Visualforce 컴포넌트, 동적 VF | `Architecture(아키텍처)/ApexPages Namespace.md` |

## Architecture — AppLauncher Namespace

| 키워드 | 파일 |
|---|---|
| AppLauncher Namespace, AppLauncher 네임스페이스, AppMenu, App Launcher Apex, 앱 런처 제어, 앱 가시성 설정, 앱 정렬 순서 | `Architecture(아키텍처)/AppLauncher Namespace.md` |
| setAppVisibility, 앱 숨기기, 앱 표시, AppMenuItem ApplicationId, App Launcher 앱 숨김 | `Architecture(아키텍처)/AppLauncher Namespace.md` |
| setOrgSortOrder, setUserSortOrder, 조직 정렬 순서, 사용자 정렬 순서, UserAppMenuItem AppMenuItemId | `Architecture(아키텍처)/AppLauncher Namespace.md` |

## Architecture — VisualEditor Namespace

| 키워드 | 파일 |
|---|---|
| VisualEditor Namespace, VisualEditor 네임스페이스, DynamicPickList, 동적 피클리스트, App Builder 피클리스트, Lightning App Builder 커스텀 피클리스트 | `Architecture(아키텍처)/VisualEditor Namespace.md` |
| DataRow, VisualEditor.DataRow, 피클리스트 행, label value selected, getLabel getValue isSelected, compareTo | `Architecture(아키텍처)/VisualEditor Namespace.md` |
| DesignTimePageContext, entityName pageType, HomePage AppPage RecordPage, 페이지 컨텍스트 Apex | `Architecture(아키텍처)/VisualEditor Namespace.md` |
| DynamicPickListRows, containsAllRows, addRow addAllRows getDataRows sort, 타입-어헤드 200개 한도 | `Architecture(아키텍처)/VisualEditor Namespace.md` |
| datasource="apex://", Aura design attribute datasource, DynamicPickList 상속, 앱 빌더 속성 드롭다운 | `Architecture(아키텍처)/VisualEditor Namespace.md` |


## Architecture — Enhanced Domains

| 키워드 | 파일 |
|---|---|
| Enhanced Domains, 향상된 도메인, My Domain 강화, 서드파티 쿠키 대응, Salesforce URL 변경, Visualforce URL 변경, Experience Cloud URL 변경, Winter 24 강제 적용, URL.getSalesforceBaseUrl, URL.getOrgDomainUrl, CORS 재설정, Connected App 콜백 URL 변경 | `Architecture(아키텍처)/Enhanced Domains.md` |

> DevOps / DX 도메인 (DevOps Center · Salesforce DX · Scratch Org · Unlocked/2GP 패키징 · CI/CD · Metadata API)은 별도 샤드로 분리됨 → `_index/platform-devops.md`

## Admin(어드민) — 일반 사용자 / 관리자

| 키워드 | 파일 |
|---|---|
| Salesforce 기초, Org, Object, Record, Field, App, Tab, Cloud, 플랫폼 개요, Sales Cloud, Service Cloud, Agentforce, 환경 종류, Sandbox, Scratch Org, Developer Edition | `Architecture(아키텍처)/Salesforce 플랫폼 개요.md` |
| Data Skew, 데이터 스큐, Account Data Skew, Ownership Skew, Lookup Skew, 소유권 스큐, 부모 레코드 잠금, record locking, 공유 재계산, defer sharing calculation, LDV 대용량 데이터, 1만 건 임계값 | `Architecture(아키텍처)/Data Skew.md` |
| Large Data Volumes, LDV, query optimizer, selectivity, skinny table, custom index, index table, divisions, 쿼리 옵티마이저, 선택도, 인덱스 임계값, 스키니 테이블, 커스텀 인덱스, 디비전, 대용량 데이터 읽기 성능, "대용량 데이터에서 인덱스가 언제 쓰이나", "SOQL이 느린 이유", "selectivity 임계값은 얼마", "리포트가 너무 느려요" | `Architecture(아키텍처)/대용량 데이터 (LDV) — 쿼리 옵티마이저·인덱싱.md` |
| Large Data Volumes, LDV, bulk load, Bulk API 2.0, hard delete, soft delete, truncate, getUpdated, getDeleted, bulk query, defer sharing, 대량 로드, 대량 삭제, 데이터 추출, 휴지통 15일, 순차 적재, 대용량 데이터 쓰기 성능, "수백만 건 로드/삭제 전략", "휴지통 15일 보관", "Bulk API로 대량 적재", "변경된 레코드만 추출" | `Architecture(아키텍처)/대용량 데이터 (LDV) — 대량 로드·삭제.md` |
| 레코드 액세스 설계, Record Access, 공유 재계산, sharing recalculation, 그룹 멤버십, group membership, 역할 계층 이동, implicit sharing, 암시적 공유, ownership data skew, deferred sharing calculation, 대규모 재편 realignment, record-level locking | `Architecture(아키텍처)/레코드 액세스 설계 (Enterprise Scale).md` |
| Salesforce 네비게이션, App Launcher, 앱 런처, 전역 검색, Global Search, 탐색바, 리스트뷰, 레코드 페이지, Lightning Experience, 홈 페이지 | `Admin(어드민)/Salesforce 네비게이션.md` |
| Data Loader, 데이터 로더, 대량 적재, CSV 임포트, bulk import export, insert update upsert delete, hard delete, Bulk API 2.0, process-conf.xml, CLI 배치, Data Import Wizard 비교, 1.5억 건 | `Admin(어드민)/Data Loader.md` |
| MFA, Multi-Factor Authentication, 다중 인증, Salesforce Authenticator, TOTP, 보안 키, FIDO2, Trusted IP Ranges, 신원 확인, 이중 인증, MFA 의무화 | `Admin(어드민)/Salesforce ID 인증.md` |
| AddressSettings, CountriesAndStates, State and Country Picklist, State and Country/Territory Picklists, `Settings:Address`, Address.settings, Country State isoCode integrationValue, 국가/주 피클리스트, 국가 영토 피클리스트, 주소 설정, 국가 주 활성화, 주 도 피클리스트, "국가/주 피클리스트를 메타데이터로 설정하려면?", "AddressSettings로 국가 주 값 편집", 텍스트 주소를 표준 피클리스트로 변환 | `Admin(어드민)/State and Country Picklist.md` |

---

## Integration(통합) — 외부 시스템 연동

| 키워드 | 파일 |
|---|---|
| Named Credential, callout:, 네임드 크레덴셜, 외부 URL 인증 | `Integration(통합)/Named Credential.md` |
| Bulk API 2.0, Bulk API, 벌크 API, 대량 데이터 적재, ingest job, query job, 비동기 잡, job state, UploadComplete, PK chunking, lineEnding LF CRLF, CSV 대량 import, 외부 시스템 대량 동기화 | `Integration(통합)/Bulk API 2.0.md` |
| REST API, 표준 REST API, services/data, sObjects CRUD, query queryAll SOQL REST, Composite Graph Batch, sObject Tree, sObject Collections 200건 allOrNone, Named Query API, OAuth Bearer, 동기 통합 | `Integration(통합)/REST API.md` |
| Actions API, Invocable Action, 인보커블 액션, actions/standard, actions/custom/apex, inputs JSON, describe 액션, QuickAction StandardButton, Apex 액션 REST 호출, 표준 액션 카탈로그, chatterPost | `Integration(통합)/Actions API.md` |
| CSP Trusted Site, Remote Site, 외부 이미지 로드, 외부 API 브라우저 | `Integration(통합)/CSP와 RemoteSite.md` |
| Queueable Callout, 비동기 외부 호출, DML+Callout 조합 | `Integration(통합)/Queueable + Callout 패턴.md` |
| Platform Event 통합, 이벤트 기반 통합, 시스템 간 느슨한 결합, LWC empApi | `Integration(통합)/Platform Event 통합 패턴.md` |
| External Services, 외부 서비스, OpenAPI Apex 통합, External Service Registration, 외부 서비스 등록, OpenAPI 2.0 스펙, 타입 안전 외부 호출, Binary File 지원, 3000 오브젝트, 700 등록 한도, Winter 26 한도 증가, Flow External Service Action | `Integration(통합)/External Services.md` |

---
