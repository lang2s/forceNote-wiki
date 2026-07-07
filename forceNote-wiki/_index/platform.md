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
| Scoping Rules, RestrictionRule, 스코핑 룰, 범위 규칙, enforcementType, recordFilter, targetEntity, Filter by scope, USING SCOPE EVERYTHING, 기본 표시 레코드 좁히기, 기본 레코드 범위 제한, Branch Management, Wealth Management, "레코드 기본 표시 범위 어떻게 좁히나", "공유 안 줄이고 보이는 레코드만 필터" | `Architecture(아키텍처)/Scoping Rules.md` |
| API Request Limits, Total API Allocations, Concurrent API Limits, Bulk API limits, SOAP call limits, Metadata API limits, SOQL search limits, Visualforce limits, view state, 일일 API 콜 한도, 동시 API 한도, 벌크 한도, 메타데이터 한도, SOQL 검색 한도, VF 한도, view state 한도, org 한도 어디서 봐, "API 콜 한도 얼마야", "동시 API 호출 제한", "Bulk API 배치 한도", "VF view state 한도" | `Architecture(아키텍처)/Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF).md` |
| Salesforce 네비게이션, App Launcher, 앱 런처, 전역 검색, Global Search, 탐색바, 리스트뷰, 레코드 페이지, Lightning Experience, 홈 페이지 | `Admin(어드민)/Salesforce 네비게이션.md` |
| Data Loader, 데이터 로더, 대량 적재, CSV 임포트, bulk import export, insert update upsert delete, hard delete, Bulk API 2.0, process-conf.xml, CLI 배치, Data Import Wizard 비교, 1.5억 건 | `Admin(어드민)/Data Loader.md` |
| Data Import Wizard, 데이터 임포트 마법사, CSV 임포트, import records, 데이터 가져오기, 50000 레코드 한도, 어떤 객체 임포트 가능, Launch Wizard, 마법사로 데이터 올리기 | `Admin(어드민)/Data Import Wizard.md` |
| Approval Process, Classic Approval Process, approval workflow, Jump Start Wizard, Standard Wizard, approval steps, assigned approver, delegated approver, record locking, outbound message, 승인 프로세스, 승인 워크플로, 승인 단계, 위임 승인자, 레코드 잠금, 승인 프로세스 만드는 법, Flow Approval Processes | `Admin(어드민)/Approval Process (승인 프로세스).md` |
| MFA, Multi-Factor Authentication, 다중 인증, Salesforce Authenticator, TOTP, 보안 키, FIDO2, Trusted IP Ranges, 신원 확인, 이중 인증, MFA 의무화 | `Admin(어드민)/Salesforce ID 인증.md` |
| AddressSettings, CountriesAndStates, State and Country Picklist, State and Country/Territory Picklists, `Settings:Address`, Address.settings, Country State isoCode integrationValue, 국가/주 피클리스트, 국가 영토 피클리스트, 주소 설정, 국가 주 활성화, 주 도 피클리스트, "국가/주 피클리스트를 메타데이터로 설정하려면?", "AddressSettings로 국가 주 값 편집", 텍스트 주소를 표준 피클리스트로 변환 | `Admin(어드민)/State and Country Picklist.md` |
| Formula Field, 수식 필드, 포뮬러 필드, cross-object formula, 크로스오브젝트 수식, Check Syntax, 계산 필드, read-only 필드, 10 관계 한도, "다른 필드로 값 자동 계산", "formula 필드 만드는 법", "부모 객체 값 가져오는 수식" | `Admin(어드민)/Formula 필드.md` |
| Roll-Up Summary, 롤업 요약 필드, 집계 필드, COUNT SUM MIN MAX, master-detail 집계, 자식 레코드 합계, 부모 필드 집계, "자식 레코드 개수 세기", "detail 레코드 합계 구하기", "master 레코드에서 집계" | `Admin(어드민)/Roll-Up Summary 필드.md` |
| Page Layouts, 페이지 레이아웃, enhanced page layout editor, mini page layout, feed-based layout, 레이아웃 할당, 필드 배치, 버튼 관련목록 배치, 프로파일 레코드타입 레이아웃, "레코드 페이지에 필드 배치", "페이지 레이아웃 만드는 법", "프로파일별 레이아웃 할당" | `Admin(어드민)/Page Layouts (페이지 레이아웃).md` |
| Record Types, 레코드 타입, business process, 비즈니스 프로세스, Master record type, sales process, support process, 레코드 타입 할당, 피클리스트 값 제어, "사용자별 다른 페이지 레이아웃", "레코드 타입 만드는 법", "비즈니스 프로세스 분기" | `Admin(어드민)/Record Types (레코드 타입).md` |
| Duplicate Rules, Matching Rules, 중복 규칙, 매칭 규칙, duplicate management, match key, matching method, Allow Block Report, 중복 방지, 데이터 품질, "중복 레코드 막는 법", "매칭 규칙으로 중복 탐지", "중복 발견 시 차단" | `Admin(어드민)/Duplicate & Matching Rules (중복·매칭 규칙).md` |
| Schema Builder, 스키마 빌더, data model, 데이터 모델, ERD, custom object 관계, 스키마 시각화, 드래그앤드롭 오브젝트, "데이터 모델 시각화", "오브젝트 관계 보기", "스키마 빌더로 필드 추가" | `Admin(어드민)/Schema Builder (스키마 빌더).md` |

---

## Integration(통합) — 외부 시스템 연동

| 키워드 | 파일 |
|---|---|
| Named Credential, callout:, 네임드 크레덴셜, 외부 URL 인증, mutual TLS, two-way SSL, 상호 TLS, 클라이언트 인증서, setClientCertificateName, Named Principal, Per-User Principal, Custom 인증 프로토콜, named authentication parameter, {!$Credential.ExtCred.Param}, Profile principal 배포 안 됨, Permission Set 매핑 배포 | `Integration(통합)/Named Credential.md` |
| Bulk API 2.0, Bulk API, 벌크 API, 대량 데이터 적재, ingest job, query job, 비동기 잡, job state, UploadComplete, PK chunking, lineEnding LF CRLF, CSV 대량 import, 외부 시스템 대량 동기화 | `Integration(통합)/Bulk API 2.0.md` |
| REST API, 표준 REST API, services/data, sObjects CRUD, query queryAll SOQL REST, Composite Graph Batch, sObject Tree, sObject Collections 200건 allOrNone, Named Query API, OAuth Bearer, 동기 통합, API Enabled, API 접근 권한, API 버전, 하위호환, 버전 은퇴 retirement, 410 GONE, INVALID_SESSION_ID, sObject tree, referenceId, 중첩 레코드 | `Integration(통합)/REST API.md` |
| Actions API, Invocable Action, 인보커블 액션, actions/standard, actions/custom/apex, inputs JSON, describe 액션, QuickAction StandardButton, Apex 액션 REST 호출, 표준 액션 카탈로그, chatterPost | `Integration(통합)/Actions API.md` |
| CSP Trusted Site, Remote Site, 외부 이미지 로드, 외부 API 브라우저 | `Integration(통합)/CSP와 RemoteSite.md` |
| Queueable Callout, 비동기 외부 호출, DML+Callout 조합, uncommitted work pending, You have uncommitted work pending, CalloutException, DML 후 콜아웃 에러, 콜아웃 전 DML 금지, 콜아웃 안 될 때, 콜아웃 순서 | `Integration(통합)/Queueable + Callout 패턴.md` |
| Platform Event 통합, 이벤트 기반 통합, 시스템 간 느슨한 결합, LWC empApi | `Integration(통합)/Platform Event 통합 패턴.md` |
| External Services, 외부 서비스, OpenAPI Apex 통합, External Service Registration, 외부 서비스 등록, OpenAPI 2.0 스펙, 타입 안전 외부 호출, Binary File 지원, 3000 오브젝트, 700 등록 한도, Winter 26 한도 증가, Flow External Service Action | `Integration(통합)/External Services.md` |
| Auth Provider, 인증 공급자, 소셜 로그인, SSO, RegistrationHandler, AuthProviderPluginClass, Custom Auth Provider, 외부 IdP 인증 | `Integration(통합)/Auth Provider (인증 공급자).md` |
| Connected App, 연결된 앱, Consumer Key, Consumer Secret, OAuth Scope, OAuth Flow, JWT Bearer, External Client App, OAuth 클라이언트, invalid_grant, expired refresh token, access grant 5개 한도, refresh token 폐기, Invalid JWT Signature, keytool importkeystore, JKS import | `Integration(통합)/Connected App (연결된 앱) — OAuth 클라이언트.md` |
| External Client App, ECA, 외부 클라이언트 앱, ExternalClientApplication, ExtlClntAppOauthSettings, Connected App 후속, Spring 26 신규 앱 차단, OAuth 클라이언트 차세대 | `Integration(통합)/External Client App (외부 클라이언트 앱).md` |
| Named Credential 생성 필드, External Credential 필드, Authentication Protocol 선택값, OAuth Authentication Flow Type, Browser Flow, Client Credentials, Enabled for Callouts, Generate Authorization Header, Principal Authentication Parameters, AWS Sig v4, JWT Issuer Subject Audience, Custom Header, 생성 화면 필드 카탈로그 | `Integration(통합)/Named Credential·External Credential 생성 필드 전수 레퍼런스.md` |
| JWT Bearer flow, Client Credentials flow, server-to-server, 서버간 통합, 헤드리스 통합, External Client App 설정, grant_type jwt-bearer, run-as user, 사용자 개입 없는 OAuth | `Integration(통합)/서버간 통합 구축 가이드 - External Client App·JWT Bearer·Client Credentials.md` |
| Pub/Sub API, PubSub API, gRPC subscribe, ManagedSubscribe, ReplayPreset, FetchRequest, num_requested, flow control, Avro decode, CometD replacement, custom channel filter, Platform Event 외부 구독, CDC 구독 API, gRPC 이벤트 구독, replay 재생, durable 구독, 외부에서 Platform Event 구독하려면, CometD 대신 뭘 쓰나, replayId로 이벤트 재생 | `Integration(통합)/Pub-Sub API (gRPC) — Platform Event·CDC 구독.md` |
| 통합 아키텍처 결정, middleware vs point-to-point, ESB, MuleSoft 언제, hub-spoke, N×M 연결 폭발, retry 재시도, idempotency 멱등성, at-least-once, External Id upsert 중복 방지, Outbound Message, 아웃바운드 통지 비교, 실시간 vs 배치, API 한도 관리 전략, /limits 모니터링 | `Integration(통합)/통합 아키텍처 결정 - 미들웨어·재시도·멱등성.md` |
| outbound IP allowlist, ip-ranges.json, Private Connect, OutboundNetworkConnection, InboundNetworkConnection, AWS PrivateLink, Hyperforce 사설연결, 콜아웃 방화벽 허용, 아웃바운드 IP 범위 | `Integration(통합)/아웃바운드 연결 - IP allowlist·Private Connect.md` |
| ERP 연동, SAP Salesforce, Oracle ERP, NetSuite, Informatica IICS, MuleSoft API-led connectivity, System Process Experience API 3계층, 서드파티 제품 연동, 실시간 vs 배치 통합, 데이터 가상화 vs 복제 | `Integration(통합)/ERP·서드파티 제품 연동 지도.md` |
| OAuth web server flow, authorization code, PKCE, code_verifier, code_challenge, S256, refresh_token, redirect_uri, 사용자 위임 OAuth, 브라우저 로그인 OAuth | `Integration(통합)/OAuth Web Server + PKCE 플로우 구축 가이드.md` |
| Connected App 생성 필드, External Client App 필드, Enable OAuth Settings, Selected OAuth Scopes, Callback URL, Require PKCE, Permitted Users, IP Relaxation, Refresh Token Policy, ExtlClntAppOauthSettings, OAuth 클라이언트 필드 카탈로그 | `Integration(통합)/OAuth 클라이언트(Connected App·External Client App) 생성 필드 전수 레퍼런스.md` |
| Auth Provider social login, 소셜 로그인 구축, SSO 설정 절차, Registration Handler 작성, JIT 프로비저닝, Google 로그인, Experience Cloud 소셜 로그인 버튼 | `Integration(통합)/Auth Provider 소셜 로그인·SSO 구축 가이드.md` |
| SOAP API, login, upsert, convertLead, getUpdated, getDeleted, describeSObjects, Enterprise WSDL, Partner WSDL, SessionHeader, SOAP 표준 오퍼레이션, 강타입 API | `Integration(통합)/SOAP API (표준 오퍼레이션·enterprise·partner WSDL).md` |
| Streaming API, CometD, Bayeux, PushTopic, Generic Streaming, StreamingChannel, Durable Streaming, replayId, long polling, 코멧D, 푸시토픽 | `Integration(통합)/Streaming API (CometD·PushTopic·Generic Streaming).md` |
| pub-sub client, grpcio-tools, proto stub, FetchRequest, num_requested credit, Avro decode, Publish, gRPC 클라이언트 구축, 구독 루프, Pub/Sub 클라이언트 세우기 | `Integration(통합)/Pub-Sub API 클라이언트 구축 가이드 (gRPC 구독·발행).md` |
| Platform Event end-to-end, 이벤트 기반 통합 구축, event-driven integration how-to, Platform Event 정의 발행 구독 멱등 재시도, 이벤트 통합 처음부터 끝까지 | `Integration(통합)/이벤트 기반 통합 구축 가이드 (Platform Event end-to-end).md` |

---
