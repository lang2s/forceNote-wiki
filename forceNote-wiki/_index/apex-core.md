---
tags: [index, search, navigation]
created: 2026-05-21
---

# SEARCH INDEX — Apex 코어
> Apex 언어·데이터/SOQL·비동기·보안·테스트·System·Schema·트리거·컬렉션·한도·표준클래스 키워드 → 파일
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.

## 플랫폼 한도 / API 한도

| 키워드 | 파일 |
|---|---|
| Governor Limits 빠른 참조, API 한도, Concurrent API, 동시 API 요청, Total API 호출 수, 일일 API 한도, API 요청 할당, Enterprise API 한도, Unlimited API 한도 | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |
| Bulk API 한도, Bulk API 2.0 한도, 배치 할당, Ingest Job 한도, Query Job 한도, 15000 배치, 150000000 레코드, Bulk API 파일 크기 | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |
| SOAP API 한도, create 200, merge 200, describeSObjects 100, query 배치 크기 2000, SOAP call limit | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |
| Metadata 한도, 배포 파일 10000, zip 39MB, 600MB, Change Set 10000, rootTypesWithDependencies | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |
| SOQL 쿼리 길이, SOQL 100000자, junction IDs 500, WHERE 절 4000자, 관계 쿼리 한도, child-to-parent 55, parent-to-child 20, 5단계 깊이 | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |
| SOQL query timeout 32분, QUERY_TOO_COMPLICATED, Visualforce 한도, VF 뷰스테이트 170KB, VF 응답 15MB, StandardSetController 10000 | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |

## Apex — 아키텍처 / 트리거

| 키워드 | 파일 |
|---|---|
| 서비스 레이어, ServiceLayer, TriggerHandler, Trigger 계층, 비즈니스 로직 분리 | `Architecture(아키텍처)/서비스 레이어 패턴.md` |
| TriggerHandler, beforeInsert afterInsert, Trigger.new, 트리거 패턴 | `Apex/Trigger(트리거)/TriggerHandler 패턴.md` |
| Trigger 재귀 방지, 트리거 재귀, recursion, static 변수 firstRun, hasRun 플래그, Set<Id> 처리, 스택 깊이 16, maximum trigger depth, setMaxLoopCount, 무한 루프 트리거 | `Apex/Trigger(트리거)/Trigger 재귀 방지.md` |
| CMDT, Custom Metadata, 트리거 on/off, 메타데이터 트리거 제어 | `Apex/Trigger(트리거)/CMDT 메타데이터 트리거.md` |
| Trigger context variables, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap, Trigger.isInsert, Trigger.isBefore, Trigger.isAfter, Trigger.operationType, System.TriggerOperation enum, 트리거 컨텍스트 변수, 트리거 컨텍스트 변수 13종, before after 트리거 차이, 트리거 이벤트 종류, 트리거 정의 문법, trigger on syntax, merge recovered records, 트리거 이벤트 가용성 매트릭스, 트리거에서 뭘 쓸 수 있나 | `Apex/Trigger(트리거)/Trigger 컨텍스트 변수와 이벤트.md` |
| Order of Execution, save order, 실행 순서, 20단계 실행 순서, 트리거 저장 순서, before after trigger 순서, 저장 lifecycle, workflow flow roll-up summary 순서, validation rule 순서, duplicate rule 순서, recursive save skip, 재귀 save 건너뛰기, commit post-commit 순서, 트리거 언제 실행되나, Additional Considerations | `Architecture(아키텍처)/Trigger Order of Execution.md` |
| Bulk Trigger Idioms, 벌크 트리거 관용구, 트리거 벌크화, Map 부모 룩업, 관련 레코드 일괄 쿼리, addError, addError 레코드 vs 필드, 트리거 예외 마킹, 부분 저장 partial save, HTML escaping addError, Operations That Don't Invoke Triggers, 트리거 미발생 작업, cascade delete 트리거 안 됨, lead 변환 트리거, mass transfer 트리거, Fields Not Updateable in Before Triggers, before 트리거 갱신 불가 필드, 트리거에서 에러 어떻게 띄우나, 어떤 작업이 트리거를 안 부르나 | `Apex/Trigger(트리거)/Trigger 벌크 관용구·미발생 작업·예외.md` |
| FeedItem trigger, FeedComment trigger, FeedAttachment, KnowledgeArticleVersion trigger, KAV trigger, Triggers for Chatter Objects, 게시물 트리거, 채터 트리거, 피드 트리거, 지식 문서 트리거, 아티클 트리거, Chatter 객체에 트리거 작성, FeedItem에 트리거 되나, Knowledge 액션별 트리거 발화, KAV before insert, 표준 객체 트리거 고려사항, Lightning 마이그레이션 트리거 영향 | `Apex/Trigger(트리거)/특정 표준 객체 트리거 고려사항 — Chatter · Knowledge.md` |
| Custom Metadata Types 상세, __mdt, CustomMetadata__mdt, getAll, getInstance, 커스텀 메타데이터 Apex 조회, Metadata.CustomMetadata, Metadata.DeployContainer, enqueueDeployment, CMDT 배포, CMDT 캐시, 커스텀 메타데이터 타입 vs 커스텀 설정, 기능 플래그, Feature Flag, 요율표, 매핑 테이블, Protected Custom Metadata | `Architecture(아키텍처)/Custom Metadata Types.md` |
| Permission Set, 권한 설계 | `Architecture(아키텍처)/Permission Set 설계.md` |
| Validation Rules, 검증 규칙, REGEX 수식, SSN 형식 검증, 우편번호 ZIP 검증, 전화번호 검증, 날짜 검증 평일, 숫자 MOD 짝수 홀수, 소유자 검증, ISCHANGED, PRIORVALUE, ISNEW, ISPICKVAL, ISNUMBER, VLOOKUP 역할 한도, $User 커스텀 필드, $Profile.Name, 크로스 오브젝트 검증, IP 주소 검증, 신용카드 번호 검증, California 운전면허, 계정 번호 검증, 연간 매출 범위 | `Architecture(아키텍처)/Validation Rules 예제.md` |

## Apex — 보안 / FLS / DML (Auth 추가)

| 키워드 | 파일 |
|---|---|
| Safely, FLS, CRUD 보안, with sharing, 안전한 DML, 필드 레벨 보안, 공유 규칙 | `Apex/Security(보안)/Safely.md` |
| CanTheUser, 권한 확인, 삭제 가능 여부, isUpdatable | `Apex/Security(보안)/CanTheUser.md` |
| StripInaccessible, 접근 불가 필드 제거, POST 바디 보안 | `Apex/Security(보안)/StripInaccessible.md` |
| WITH USER_MODE, USER_MODE, SYSTEM_MODE, SOQL 보안 모드 | `Apex/Security(보안)/WITH USER_MODE.md` |
| DML, insert update delete, allOrNothing, SaveResult, 부분 성공 | `Apex/Data(데이터)/DML 패턴.md` |
| Auth.JWT, Auth.JWS, Auth.JWTBearerTokenExchange, OAuth JWT bearer token, JWT 서명, JWT 클레임, JWT flow, getAccessToken, getCompactSerialization | `Apex/Security(보안)/Auth Namespace.md` |
| Auth.SessionManagement, 세션 관리, MFA, TOTP, validateTotpTokenForUser, getQrCode, setSessionLevel, finishLoginFlow, generateVerificationUrl, inOrgNetworkRange, 커스텀 로그인 | `Apex/Security(보안)/Auth Namespace.md` |
| Auth.RegistrationHandler, SSO 프로비저닝, Auth.UserData, createUser updateUser, 사용자 자동 생성 | `Apex/Security(보안)/Auth Namespace.md` |
| TxnSecurity.EventCondition, TxnSecurity.AsyncCondition, Transaction Security Apex, 트랜잭션 보안 정책, evaluate() 정책 조건, Real-Time Event Monitoring 보안, ApiEvent 차단, 로그인 이벤트 차단, 실시간 이벤트 보안 정책, Apex 보안 정책 | `Apex/Security(보안)/TxnSecurity Namespace.md` |
| TxnSecurity.PolicyCondition, TxnSecurity.Event, 레거시 트랜잭션 보안, PolicyCondition evaluate, 구형 트랜잭션 보안 | `Apex/Security(보안)/TxnSecurity Namespace.md` |
| UserProvisioning Namespace, UserProvisioningLog, UserProvisioningPlugin, ConnectorTestUtil, 사용자 프로비저닝 Apex, 커넥티드 앱 프로비저닝, SCIM 프로비저닝, 아웃바운드 프로비저닝 | `Apex/Security(보안)/UserProvisioning Namespace.md` |
| UserProvisioning.UserProvisioningLog.log, 프로비저닝 로그, UPR 로깅, userProvisioningRequestId externalUserId | `Apex/Security(보안)/UserProvisioning Namespace.md` |
| UserProvisioningPlugin invoke buildDescribeCall, Process.PluginResult, reconOffset nextReconOffset reconState, 10000 DML 한도 우회 프로비저닝, Flow Builder 프로비저닝 플러그인 | `Apex/Security(보안)/UserProvisioning Namespace.md` |
| ConnectorTestUtil.createConnectedApp, 프로비저닝 테스트, UserProvisioningRequest, @isTest 커넥티드 앱 시뮬레이션 | `Apex/Security(보안)/UserProvisioning Namespace.md` |

## Apex — SOQL / SOSL

| 키워드 | 파일 |
|---|---|
| SOQL vs SOSL, 쿼리 언어 선택, SOQL 언제, SOSL 언제, CONTAINS 성능, CJKT 검색, 한국어 일본어 검색, 쿼리 성능 고려사항 | `Apex/SOQL(SOQL)/SOQL SOSL 소개.md` |
| SOQL, 쿼리 패턴, 벌크 쿼리, 거버너 한도, Database.query, 데이터 조회, SELECT FROM WHERE | `Apex/SOQL(SOQL)/SOQL 패턴.md` |
| SOQL 문법 레퍼런스, SOQL SELECT 전체 문법, FIELDS ALL CUSTOM STANDARD, 날짜 리터럴, TODAY YESTERDAY LAST_N_DAYS THIS_FISCAL_YEAR, 날짜 함수, CALENDAR_YEAR DAY_ONLY HOUR_IN_DAY, GROUP BY ROLLUP CUBE, GROUPING 함수, 세미조인, 안티조인, 관계 쿼리, 자식→부모 dot, 부모→자식 서브쿼리, TYPEOF 다형성, TYPEOF 제한사항, USING SCOPE, ContentDocumentLink 제한, Big Object 쿼리, SOQL 오브젝트 제한, FORMAT() SOQL, toLabel() SOQL, convertCurrency() SOQL, DISTANCE GEOLOCATION 위치 기반 쿼리, Location-Based SOQL, 관계 쿼리 제한사항, child-to-parent 55개 제한, KnowledgeArticleVersion 바인딩변수 불가, Data 360 SOQL 제한, UserRecordAccess 쿼리, Vote 쿼리, ContentHubItem 쿼리 | `Apex/SOQL(SOQL)/SOQL 문법 레퍼런스.md` |
| WITH DATA CATEGORY, Knowledge 카테고리 필터, KnowledgeArticleVersion 카테고리, Question 카테고리, AT ABOVE BELOW ABOVE_OR_BELOW, dataCategoryGroupName, filteringSelector, dataCategorySelection, PublishStatus online draft archived, RecordVisibilityContext, maxDescriptorPerRecord, supportsDomains supportsDelegates, VisibilityAttribute, 데이터 카테고리 SOQL | `Apex/SOQL(SOQL)/SOQL WITH DATA CATEGORY.md` |
| Syndication Feed SOQL, 피드 SOQL, RSS Atom 피드 매핑, 공개 사이트 피드, Public Site SOQL 피드 | `Apex/SOQL(SOQL)/Syndication Feed SOQL.md` |
| SOSL, FIND 구문, 전문 검색, IN NAME FIELDS, RETURNING, 여러 오브젝트 검색, List<List<SObject>>, WITH SNIPPET, WITH HIGHLIGHT, SOSL 레퍼런스, SOSL 전체 문법, FIND 와일드카드, SOSL 예약문자 이스케이프, SearchQuery 문자수 제한, SOSL ORDER BY, SOSL OFFSET, SOSL FORMAT(), SOSL toLabel, SOSL convertCurrency, USING Listview SOSL, UPDATE TRACKING SOSL, UPDATE VIEWSTAT SOSL, WITH HIGHLIGHT 지원 필드, WITH METADATA LABELS, WITH DivisionFilter, WITH PricebookId, WITH SPELL_CORRECTION, SOSL 검색 알고리즘, SOSL External Object 제한, SOSL WHERE 연산자, SOSL 이스케이프 시퀀스, SOSL vs SOQL | `Apex/SOQL(SOQL)/SOSL 패턴.md` |
| Dynamic SOQL, 동적 쿼리, String.escapeSingleQuotes, 바인딩 변수, Database.queryWithBinds, bindMap, getCursorWithBinds, SOQL 바인드 변수 동적 | `Apex/SOQL(SOQL)/Dynamic SOQL.md` |
| EntityDefinition, FieldDefinition, QualifiedApiName, IsCalculated, RelationshipName, DataType, getSObjects, metadata catalog SOQL, schema introspection, 메타데이터 카탈로그, 스키마 인트로스펙션, SOQL로 스키마 조회, 포뮬러 필드 찾기, 계산 필드 쿼리, 룩업 관계 필드 찾기, describe 대신 SOQL, 오브젝트 필드 메타데이터, SOQL로 스키마 조회하는 법, 조직의 모든 포뮬러 필드 찾는 법, 필드가 어떤 오브젝트를 룩업하는지 | `Apex/SOQL(SOQL)/메타데이터 카탈로그 SOQL (EntityDefinition·FieldDefinition).md` |

## Apex — 데이터 (DML / Namespace)

| 키워드 | 파일 |
|---|---|
| FormulaEval, Formula.builder, 동적 수식 평가, 포뮬러 필드 재계산, DML 없이 수식 계산, getReferencedFields, 수식 평가 Apex, 템플릿 수식, FormulaReturnType, FormulaGlobal | `Apex/Data(데이터)/FormulaEval Namespace.md` |
| Reports namespace, ReportManager, runReport, runAsyncReport, ReportResults, ReportMetadata, ReportFact, ReportFactWithDetails, SummaryValue, FactMap, 보고서 Apex 실행, 비동기 보고서, 보고서 필터 재정의, getFactMap, ReportFilter, BucketField, ReportInstance | `Apex/Data(데이터)/Reports Namespace.md` |
| BusinessHours, BusinessHours.diff, 영업시간 계산, SLA 준수 여부, 업무시간 경과, isWithin, nextStartDate, SLA 초과 | `Apex/Data(데이터)/BusinessHours 패턴.md` |
| Datacloud Namespace, Datacloud.FindDuplicates, FindDuplicatesByIds, DuplicateResult, MatchResult, MatchRecord, FieldDiff, findDuplicates, 중복 레코드 탐지 Apex, Duplicate Management Apex, 중복 규칙 Apex, 중복 차단 처리, DuplicateError 처리, 레코드 중복 검사 | `Apex/Data(데이터)/Datacloud Namespace.md` |
| Wave Namespace, wave namespace, CRM Analytics SDK, SAQL 빌더, SAQL 쿼리 Apex, QueryBuilder, QueryNode, ProjectionNode, CRM Analytics 쿼리 Apex, 애널리틱스 쿼리 | `Apex/Data(데이터)/Wave Namespace.md` |
| Wave.QueryBuilder.load, Wave.QueryBuilder.count, Wave.QueryBuilder.get, union, cogroup, 데이터셋 스트림 로드, SAQL union cogroup Apex | `Apex/Data(데이터)/Wave Namespace.md` |
| Wave.QueryNode, build, foreach, group by all, order SAQL, cap, filter predicate, execute ConnectApi.LiteralJson | `Apex/Data(데이터)/Wave Namespace.md` |
| Wave.ProjectionNode, sum avg min max unique alias, 집계 함수 체이닝 Apex, SAQL projection | `Apex/Data(데이터)/Wave Namespace.md` |
| Wave.Templates, getTemplate, getTemplateConfig, getTemplates, TemplatesSearchOptions, CRM Analytics 템플릿 조회, filterGroup options type | `Apex/Data(데이터)/Wave Namespace.md` |
| 페이징, PagedResult, 오프셋, OFFSET LIMIT, 페이지네이션, 무한 스크롤, infinite scroll, enable-infinite-loading, onloadmore, loadmore, datatable 무한스크롤 | `Apex/Data(데이터)/PagedResult 패턴.md` |
| ContentVersion, ContentDocumentLink, ContentDistribution, VersionData, PathOnClient, FirstPublishLocationId, ContentLocation, DistributionPublicUrl, ShareType, Visibility, Salesforce Files Apex, 파일 생성 Apex, 레코드에 파일 첨부, 레코드에 파일 붙이기, 공개 링크 생성, 파일 공개 URL 만들기, Apex로 파일 업로드, 파일 버전 추가, ContentDocument 자동 생성, Apex에서 파일 첨부하는 법, 인증 없는 공개 링크 배포 | `Apex/Data(데이터)/Apex에서 Salesforce Files 다루기 (ContentVersion·ContentDistribution).md` |
| Mixed DML, MIXED_DML_OPERATION, Setup Object, 세트업 오브젝트, 믹스드 DML, User와 Account 같이 insert, User·PermissionSet 함께 DML, System.runAs 분리, future Queueable 우회, Mixed DML 에러 해결, 테스트에서 setup 오브젝트 생성 | `Apex/Data(데이터)/Mixed DML 제약과 우회.md` |
| JSONParser, JSONGenerator, JSONToken, JSON 예약어 충돌, deserializeUntyped, deserializeStrict, JSON reserved word, from case currency 예약어 필드명, 예약어 필드명 파싱, 래퍼 클래스 컴파일 오류, JSON 토큰 순회, JSON 직렬화 심화 | `Apex/Data(데이터)/JSON 직렬화 심화 — JSONParser·JSONGenerator·예약어 충돌.md` |

## Apex — 비동기

| 키워드 | 파일 |
|---|---|
| 비동기 선택, 언제 future 언제 queueable 언제 batch, Cursor vs Batch, Database.Cursor 비동기, 페이지 기반 대용량 처리 | `Apex/Async(비동기)/비동기 컨텍스트 선택.md` |
| @future, future 메서드, fire and forget, callout=true | `Apex/Async(비동기)/Future 메서드.md` |
| Queueable, AllowsCallouts, 큐어블, SObject 파라미터 비동기 | `Apex/Async(비동기)/Queueable.md` |
| Queueable 체이닝, 연속 비동기, 다음 잡 실행 | `Apex/Async(비동기)/Queueable 체이닝.md` |
| Batch Apex, Database.Batchable, 대용량 처리, QueryLocator, Stateful, 수만건 처리, 배치 | `Apex/Async(비동기)/Batch Apex.md` |
| Scheduled Apex, Schedulable, 정기 실행, cron, 스케줄, 자동 실행, 매일 매주 | `Apex/Async(비동기)/Scheduled Apex.md` |

## Apex — 테스트

| 키워드 | 파일 |
|---|---|
| 테스트 전략, @isTest, TestSetup, Assert, startTest stopTest, 테스트 구조 | `Apex/Testing(테스트)/테스트 전략.md` |
| HttpCalloutMock, Callout 테스트, HTTP 모킹, Test.setMock | `Apex/Testing(테스트)/HttpCalloutMock.md` |
| StubProvider, 클래스 모킹, Test.createStub, 의존성 모킹 | `Apex/Testing(테스트)/StubProvider.md` |
| @testVisible, 회로차단기, 테스트 전용 플래그, private 접근 | `Apex/Testing(테스트)/testVisible 회로차단기.md` |
| SOSL 테스트, Test.setFixedSearchResults | `Apex/Testing(테스트)/SOSL 테스트 패턴.md` |

## Apex — System Namespace

| 키워드 | 파일 |
|---|---|
| System Namespace, System 네임스페이스, Apex 코어 네임스페이스, AccessLevel, AccessType, Assert 클래스, AsyncInfo, AsyncOptions, Callable, Domain, FeatureManagement, UserInfo, UUID, Request class, System.debug, System.enqueueJob, System.now, System.today, System.schedule | `Architecture(아키텍처)/System Namespace.md` |
| AccessLevel.USER_MODE, AccessLevel.SYSTEM_MODE, DML 실행 모드, 보안 모드 DML, Database.insert AccessLevel | `Architecture(아키텍처)/System Namespace.md` |
| AccessType CREATABLE READABLE UPDATABLE UPSERTABLE, stripInaccessible 접근 체크 타입 | `Architecture(아키텍처)/System Namespace.md` |
| AsyncInfo 스택 깊이, AsyncOptions 중복 시그니처, QueueableDuplicateSignature, enqueueJob 파라미터 | `Architecture(아키텍처)/System Namespace.md` |
| Request.getCurrent, getQuiddity, getRequestId, 현재 요청 컨텍스트 Apex | `Architecture(아키텍처)/System Namespace.md` |
| UserInfo.getUserId, getUserEmail, getOrganizationId, getTimeZone, isMultiCurrencyOrganization, 현재 사용자 정보 Apex | `Architecture(아키텍처)/System Namespace.md` |
| UUID.randomUUID, 랜덤 UUID 생성, Version 4 UUID Apex | `Architecture(아키텍처)/System Namespace.md` |
| Callable interface, 패키지 간 느슨한 결합, Type.forName 인스턴스화, 동적 호출 Apex | `Architecture(아키텍처)/System Namespace.md` |
| FeatureManagement, checkPackageBooleanValue, checkPackageIntegerValue, checkPermission, 커스텀 퍼미션 확인, Feature Parameter | `Architecture(아키텍처)/System Namespace.md` |
| DomainCreator, getVisualforceHostname, URL.getOrgDomainUrl, URL.getSalesforceBaseUrl, Org URL 조회 | `Architecture(아키텍처)/System Namespace.md` |
| withPermissionSetId, AccessLevel 권한 세트, DML 권한 세트 지정 | `Architecture(아키텍처)/System Namespace.md` |


## Apex — Flowtesting Namespace

| 키워드 | 파일 |
|---|---|
| flowtesting namespace, Flow Builder 테스트, Flow 단위 테스트, sf flow run test, Flow test CLI, 동적 Apex 클래스, flow test 실행 | `Apex/Testing(테스트)/Flowtesting Namespace.md` |
| Flow Builder flow test, Flow Interview 테스트 비교, Flow 검증, Decision 경로 테스트, Flow 출력변수 검증 | `Apex/Testing(테스트)/Flowtesting Namespace.md` |
| Apex에서 Flow 테스트하는 방법, flowtesting vs Flow.Interview, @isTest Flow 실행 패턴 | `Apex/Testing(테스트)/Flowtesting Namespace.md` |

## Apex — 언어 기초

| 키워드 | 파일 |
|---|---|
| Apex 데이터타입, Apex 원시 타입, Primitive 타입, Blob Boolean Date Datetime Decimal Double ID Integer Long Object String Time, sObject 타입, Collection 선언, 컬렉션 선언 문법, List Set Map 리터럴, Enum, System-defined enum, 변수 선언, 변수 명명 규칙, 상수 final, 연산자, 연산자 우선순위, Safe Navigation ?., Null Coalescing ??, 형 변환, Rules of Conversion, overflow underflow, Apex 데이터 타입이 뭐가 있나, Apex에서 변수 어떻게 선언하나, ?. ?? 연산자 뭔가 | `Apex/Apex 언어 기초 — 데이터타입과 변수.md` |
| Apex 제어 흐름, if else, switch when, switch 패턴, do-while while for 루프, 클래스 정의, inner 클래스, 생성자, this chaining, 메서드 오버로딩, 접근 제어자, private protected public global, static instance 초기화, Apex Properties, getter setter, 상속 extends, virtual abstract override, 다형성, 인터페이스 구현, Custom Iterator Iterable, final instanceof super this transient, with sharing without sharing inherited sharing, 클래스 캐스팅, name shadowing, Apex 클래스 작성법, with sharing 차이가 뭔가, Apex switch 문 어떻게 쓰나, virtual abstract 차이 | `Apex/Apex 언어 기초 — 제어 흐름과 클래스.md` |
| Apex 예외 처리, try catch finally, throw, 잡을 수 없는 예외, LimitException, DmlException ListException NullPointerException QueryException SObjectException, 예외 메서드 getMessage getCause getStackTraceString, 커스텀 예외, 커스텀 예외 만들기, 예외 클래스 extends Exception, rethrow inner exception, Apex 예약어, reserved keywords 목록, Apex 예외 어떻게 처리하나, 커스텀 예외 어떻게 만드나, Apex 예약어 목록 | `Apex/Apex 언어 기초 — 예외 처리와 예약어.md` |
| Introducing Apex, Apex 개요, Apex란 무엇인가, What is Apex, Apex 개발 프로세스, Apex 언제 쓰나, 강타입 객체지향 멀티테넌트, Apex 동작 방식, 개발 환경 org 타입, Apex 어떻게 개발하나, Apex 개발 테스트 배포 흐름, Apex 특징 | `Apex/Introducing Apex — 개요와 개발 프로세스.md` |
| Apex Versioned Behavior Changes, 버전별 동작 변경, API version behavior, versioned behavior, apiVersion 동작 차이, API 버전별 Apex 동작, v15 v34 v67 동작 변경, 버전 게이트 동작, 패키지 버전 동작 변경, Apex 버전 올리면 뭐가 바뀌나, API 버전에 따라 달라지는 동작 | `Apex/Apex 버전별 동작 변경 레퍼런스.md` |

## Apex — 표준 클래스 레퍼런스

| 키워드 | 파일 |
|---|---|
| Apex 표준 클래스, 표준 클래스 목록, Apex API 레퍼런스, 클래스 레퍼런스 | `Apex/Apex 표준 클래스 레퍼런스.md` |
| String 메서드, String.format, String.join, String.escapeSingleQuotes, String.template, 문자열 조작 | `Apex/Apex 표준 클래스 레퍼런스.md` |
| List 메서드, List.sort, List.add, List.remove, 리스트 정렬 | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Map 메서드, Map.get, Map.put, Map.containsKey, Map.keySet, Map.values | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Set 메서드, Set.add, Set.contains, Set.retainAll, Set.removeAll | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Database 클래스, Database.insert, Database.update, Database.query, Database.getCursor, SaveResult, UpsertResult, AccessLevel | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Crypto 클래스, 암호화, generateAESKey, encryptWithManagedIV, decryptWithManagedIV, generateDigest, generateMac, sign | `Apex/Apex 표준 클래스 레퍼런스.md` |
| JSON 클래스, JSON.serialize, JSON.deserialize, JSON.deserializeUntyped, JSON.createParser | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Schema 클래스, SObjectType, DescribeSObjectResult, DescribeFieldResult, getGlobalDescribe | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Limits 클래스, Limits.getQueries, Limits.getDMLRows, 거버너 한도 확인, 남은 DML | `Apex/Apex 표준 클래스 레퍼런스.md` |
| System 클래스, System.now, System.today, System.enqueueJob, System.scheduleBatch, System.debug | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Math 클래스, Math.max, Math.min, Math.abs, Math.random, Math.floor, Math.ceil | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Date DateTime Time, Date.today, DateTime.now, addDays addMonths daysBetween | `Apex/Apex 표준 클래스 레퍼런스.md` |
| UUID, UUID.randomUUID, Compression, Deflater, Inflater, DataWeave, DataWeaveScriptResource | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Comparator, Collator, 로케일 정렬, Collator.getInstance, STRENGTH_PRIMARY | `Apex/Apex 표준 클래스 레퍼런스.md` |

## Apex — 기타

| 키워드 | 파일 |
|---|---|
| Log 싱글턴, 로깅 패턴, Logger, 디버그 로그 | `Apex/Logging(로깅)/Log 싱글턴 패턴.md` |
| Apex Debug Log, 디버그 로그, 로그 카테고리, 로그 레벨, 로그 레벨 설정, 디버그 로그 안 보일 때, Apex 디버깅, NONE ERROR WARN INFO DEBUG FINE FINER FINEST, DebuggingHeader, LogCategory, LogCategoryLevel, Event Type 매트릭스, System.debug 로그, Developer Console 로그, 디버그 로그 한도, 로그 우선순위, Apex 디버깅 방법, 로그 카테고리 10종, 로그 레벨 8종, debug log limit | `Apex/Logging(로깅)/Apex Debug Log.md` |
| TraceFlag, DebugLevel, ApexLog, HeapDump, ApexExecutionOverlayAction, ApexExecutionOverlayResult, ExecuteAnonymousResult, executeAnonymous REST, Tooling API 로그 sObject, 프로그래밍 방식 로그 활성화, API로 디버그 로그 켜기, trace flag 만들기, TraceFlag 생성, DebugLevel 카테고리, LogType, 체크포인트, overlay action, 리플레이 디버거, Replay Debugger, 힙 덤프, heap dump, executeAnonymous REST 리소스, API로 로그 레벨 설정 | `Apex/Logging(로깅)/Tooling API 디버그·로그·리플레이 sObject.md` |
| Platform Cache, 캐시, CacheBuilder, Org Cache Session Cache | `Apex/PlatformCache(플랫폼캐시)/Platform Cache.md` |
| Cache Namespace, Cache.Org, Cache.Session, Cache.OrgPartition, Cache.SessionPartition, Cache.Visibility, 플랫폼 캐시 네임스페이스, doLoad, CacheBuilder 인터페이스 | `Apex/PlatformCache(플랫폼캐시)/Cache Namespace.md` |
| OrgShape, Org 설정 조회, 샌드박스 여부, 네임스페이스 | `Apex/ExecutionContext(실행컨텍스트)/OrgShape.md` |
| QuiddityGuard, Quiddity, 실행 컨텍스트, REST Trigger Batch 구분 | `Apex/ExecutionContext(실행컨텍스트)/QuiddityGuard.md` |
| Anonymous Apex, 익명 Apex, 익명 블록, execute anonymous, execute anonymous 실행, executeAnonymous, ExecuteAnonymousResult, Author Apex 권한, 익명 블록 제약, Forward Reference, 익명 Apex 실행 방법, Web Console, VS Code Apex 실행, Developer Console 익명 실행, sf apex run, anonymous block, 임시 코드 실행, Apex 한 번 실행 | `Apex/ExecutionContext(실행컨텍스트)/Anonymous Apex 실행.md` |
| Governor Limits, 거버너 한도, 실행 한도, SOQL 한도, DML 한도, Heap size, CPU time, Callout 한도, Limits 클래스, getQueries, getDmlStatements, getLimitQueries, getLimitDmlStatements, 거버너 리밋, Apex 실행 한도, 한도 초과 예외, LimitException, Per-Transaction Limits, 비동기 동기 한도 차이, Platform Apex Limits, Static Apex Limits | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |
| Platform Event 발행, EventBus.publish, 이벤트 트리거 수신 | `Apex/PlatformEvents(플랫폼이벤트)/Platform Event 발행.md` |
| Platform Event 정의, 구독, __e 객체, Publish Behavior, Publish Immediately, Publish After Commit, 고볼륨 표준볼륨 platform event, after insert 트리거 구독, Pub/Sub API, CometD, ReplayId, EventUuid, setResumeCheckpoint, RetryableException 재시도 | `Apex/PlatformEvents(플랫폼이벤트)/Platform Event 정의와 구독.md` |
| Platform Event 테스트, Test.getEventBus, deliver fail, 테스트 이벤트 버스, onSuccess onFailure 테스트, 플랫폼 이벤트 단위 테스트 | `Apex/PlatformEvents(플랫폼이벤트)/Platform Event Apex 테스트.md` |
| Platform Event 한도, allocations, 72시간 보관, 디커플드 발행 구독, decoupled, SOQL 불가, 이벤트 영구 삭제, PE vs CDC, 이벤트 종류 비교, /limits | `Apex/PlatformEvents(플랫폼이벤트)/Platform Event 한도와 고려사항.md` |
| ChangeEventHeader, CDC, Change Data Capture, changetype, recordids, changedfields, nulledfields, 변경 데이터 캡처, TriggerContext, RetryableException, TestBroker | `Apex/PlatformEvents(플랫폼이벤트)/ChangeEventHeader.md` |
| Change Data Capture 개발자 가이드, CDC 설정, CDC 구독 채널, AccountChangeEvent, ChangeEvent 트리거, after insert CDC, Automated Process 트리거, CDC 테스트 enableChangeDataCapture, Test.getEventBus().deliver, Gap Event, Overflow Event, GAP_OVERFLOW, 병합 이벤트, CDC 할당 한도, CDC 이벤트 전달 한도, 50000 이벤트, 25000 이벤트, CDC 보안 권한, EventBusSubscriber, CDC FLS, 실시간 데이터 동기화, CDC Reliability, replayId, 이벤트 신뢰성, 이벤트 보강, EnrichedFields, PlatformEventChannelMember enrichedFields, 필터 스트림, FilterExpression, 커스텀 채널 필터, 트랜잭션 복제, transactionKey sequenceNumber, 복합 필드 변경 이벤트, BillingAddress compound field, Pub/Sub API CDC, gRPC Avro 변경 이벤트, PlatformEventUsageMetric, CHANGE_EVENTS_DELIVERED, 이벤트 사용량 모니터링, diffFields, 대용량 텍스트 diff, 유니파이드 diff SHA-256, 표준 오브젝트 노트, Person Account 변경 이벤트, Lead Conversion 변경 이벤트, PricebookEntry CREATE, User preferences 변경 이벤트, GroupEventType 반복 활동, Event Invitees 이벤트, CDC 애드온 라이선스, 이벤트 전달 계산, API 버전 스키마, GetSchema RPC, 이벤트 스키마 조회 | `Apex/PlatformEvents(플랫폼이벤트)/ChangeEventHeader.md` |
| EventPublishFailureCallback, EventPublishSuccessCallback, 이벤트 발행 콜백, 발행 실패 콜백, 발행 성공 콜백, onFailure, onSuccess, getEventUuids, setResumeCheckpoint, 이벤트 부분 처리 재개, Automated Process 콜백 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Publish Callbacks.md` |
| EventBus Namespace, EventBus.publish 메서드 목록, TriggerContext, RetryableException, setResumeCheckpoint, publishWithAccessLevel, getOperationId, 이벤트버스 네임스페이스, 트리거 재시도, 이벤트 재개 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Namespace.md` |
| Approval.process, ProcessSubmitRequest, ProcessWorkitemRequest, 승인 제출, 승인 프로세스 Apex, Approval.lock, Approval.unlock, LockResult, UnlockResult | `Architecture(아키텍처)/Approval Namespace.md` |
| Messaging.sendEmail, SingleEmailMessage, 이메일 발송 Apex, setToAddresses, setHtmlBody, setTemplateId, setTargetObjectId, EmailFileAttachment, 첨부파일 이메일 | `Apex/Messaging(메시징)/SingleEmailMessage.md` |
| CustomNotification, 커스텀 알림, 인앱 알림, Messaging.CustomNotification, setNotificationTypeId, send 알림, 알림 발송 Apex | `Apex/Messaging(메시징)/CustomNotification.md` |
| Messaging Namespace, InboundEmail, InboundEmailHandler, InboundEmailResult, InboundEnvelope, 인바운드 이메일, 이메일 서비스, Email Service, ActionableNotification, MassEmailMessage, PushNotification, 인앱 알림 모바일 | `Apex/Messaging(메시징)/Messaging Namespace.md` |
| Mobile Notifications, PushNotification, PushNotificationPayload, customNotificationAction, Notification Builder, 모바일 알림, 푸시 알림, 인앱 알림, 커스텀 알림 액션, APNs FCM, Apex로 푸시 알림 보내는 방법, Notification Builder vs Apex 알림, 모바일 앱에 알림 전달 | `Apex/Messaging(메시징)/Mobile Notifications.md` |
| Flow.Interview, createInterview, 플로우 Apex 호출, Apex에서 Flow 실행, getVariableValue, Flow.Interview.start | `Flow/Flow Interview API.md` |
| SaveResult, UpsertResult, DeleteResult, MergeResult, UndeleteResult, EmptyRecycleBinResult, DML 결과, Database.Error, isSuccess, getErrors, getId, isCreated | `Apex/Data(데이터)/Database Namespace 상세.md` |
| Database.Cursor, getCursor, fetch, getNumRecords, PaginationCursor, fetchPage, CursorFetchResult, QueryLocator, QueryLocatorIterator, hasNext, next, DMLOptions, LeadConvert, convertLead | `Apex/Data(데이터)/Database Namespace 상세.md` |
| DMLOptions.AssignmentRuleHeader, useDefaultRule, assignmentRuleId, 배정 규칙, DMLOptions.DuplicateRuleHeader, allowSave, runAsCurrentUser, DMLOptions.EmailHeader, triggerAutoResponseEmail, localeOptions | `Apex/Data(데이터)/Database Namespace 상세.md` |
| Search.find, SOSL Apex, dynamic SOSL, SearchResult, SearchResults, getSObject, Search.suggest, SuggestionResult, KnowledgeSuggestionFilter, QuestionSuggestionFilter | `Apex/Data(데이터)/Search Namespace.md` |
| DescribeSObjectResult, DescribeFieldResult, getDescribe, getFields, isAccessible, isCreateable, getLabel, getKeyPrefix, getPicklistValues, RecordTypeInfo, getRecordTypeInfosByDeveloperName, ChildRelationship, getChildRelationships, Schema.getGlobalDescribe, DisplayType | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| SObjectType, SObjectField, newSObject, SObjectDescribeOptions, FieldDescribeOptions, SOAPType, SOAPType Enum, DescribeTabResult, DescribeTabSetResult, describeTabs, DataCategory, DescribeDataCategoryGroupResult, describeDataCategoryGroups, DescribeColorResult, DescribeIconResult | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| getAssociateEntityType, getAssociateParentEntity, isMruEnabled, getDataTranslationEnabled, getController 피클리스트, isDefaultedOnCreate, isHtmlFormatted, isIdLookup, isWriteRequiresMasterRead, isSearchPrefilterable | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| Collections, CollectionUtils, 컬렉션 유틸 | `Apex/Collections(컬렉션)/CollectionUtils.md` |
| Comparator, 정렬, List.sort, 커스텀 정렬, 리스트 정렬, 오름차순 내림차순 | `Apex/Collections(컬렉션)/Comparator 인터페이스.md` |
| Iterable, Iterator, 커스텀 이터레이터 | `Apex/Collections(컬렉션)/Iterable Iterator.md` |
| ApexDoc, Apex 주석, ApexDoc 주석 다는 법, 코드 주석 규약, JavaDoc 주석, 문서화 주석, @description @param @return @throws @see @group @example @author @deprecated @version @since, inline {@code} {@link} {@literal} {@hidden}, 공통 애노테이션, 구성요소 문서화, ApexDoc 작성법, Apex 코드 문서화, 주석 문법 가이드 | `Apex/ApexDoc 주석 작성 가이드.md` |


## Apex — Platform Encryption

| 키워드 | 파일 |
|---|---|
| Platform Encryption, 플랫폼 암호화, Shield Platform Encryption, 필드 암호화, 데이터베이스 암호화, Database Encryption GA, Field Audit Trail 보존 정책, AES-256, Tenant Secret, BYOK, Bring Your Own Key, Deterministic Encryption, Probabilistic Encryption, 암호화 필드 SOQL 제한, Tableau Next 암호화, Data Cloud 암호화, Winter 26 암호화 | `Apex/Security(보안)/Platform Encryption.md` |
| Shield, 규정 준수 암호화, HIPAA 암호화, GDPR 암호화, Crypto 클래스, encryptWithManagedIV, decryptWithManagedIV, generateAesKey, 커스텀 암호화, HMAC 서명, 데이터 무결성 | `Apex/Security(보안)/Platform Encryption.md` |

## Apex — Best Practices

| 키워드 | 파일 |
|---|---|
| Apex best practices, Apex 모범 사례, Apex 베스트 프랙티스, bulkify, 벌크화, 루프 내 DML 금지, SOQL 루프 금지, 하드코딩 ID 금지, with sharing, 단일 트리거, SOQL for 루프, 모듈화, 테스트 시나리오, 중첩 루프 금지, 네이밍 컨벤션, 트리거 비즈니스 로직 금지, AuraEnabled JSON 반환 금지, Apex 코딩 표준, Apex 성능, governor limits | `Apex/Apex Best Practices.md` |

---

