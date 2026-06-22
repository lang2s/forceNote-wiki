---
tags: [home, index, salesforce]
created: 2026-05-17
---

# Salesforce 개발자 두 번째 뇌

> Salesforce 공식 프로젝트(apex-recipes, lwc-recipes, dreamhouse-lwc 등) 분석 기반의 검증된 패턴 모음.

---

## 📂 카테고리

### [[Apex MOC|Apex]]
Salesforce Apex 백엔드 개발 — 패턴, 보안, 테스트, 비동기, 통합

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[비동기 컨텍스트 선택]] | @future, Queueable, Batch, Scheduled |
| [[DML 패턴]] | insert as user, Safely, AccessLevel |
| [[SOQL 패턴]] | WITH USER_MODE, SOQL for loop |
| [[Dynamic SOQL]] | queryWithBinds, 인젝션 방어 |
| [[TriggerHandler 패턴]] | abstract class, bypass, ServiceLayer |
| [[CMDT 메타데이터 트리거]] | MetadataTriggerHandler, 동적 디스패치 |
| [[Safely]] | DML Fluent API |
| [[CanTheUser]] | CRUD 체크 |
| [[StripInaccessible]] | AccessType, FLS 필드 제거 |
| [[RestClient 패턴]] | virtual class, Named Credential, PATCH 우회 |
| [[Custom REST Endpoint]] | @RestResource, global, RestContext |
| [[Comparator 인터페이스]] | List.sort, null 처리, ASCENDING/DESCENDING |
| [[StubProvider]] | System.StubProvider, Test.createStub |
| [[testVisible 회로차단기]] | @testVisible, Boolean/Exception 회로 차단기 |
| [[QuiddityGuard]] | 실행 컨텍스트 가드, trusted/untrusted |
| [[Log 싱글턴 패턴]] | add/publish, Platform Event 기반 |
| [[서비스 레이어 패턴]] | TriggerHandler-ServiceLayer 브로커 |

### [[LWC MOC|LWC]]
Lightning Web Component — Wire 어댑터, LDS, 컴포넌트 통신, Flow Screen

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Wire vs Imperative 선택]] | @wire, async/await, 결정 매트릭스 |
| [[Wire 패턴]] | property/function 바인딩, reactive $변수 |
| [[Imperative 호출 패턴]] | try/catch/finally, isLoading |
| [[@api 패턴]] | property, method, getter/setter, lwc:spread |
| [[CustomEvent 패턴]] | detail, bubbles, composed |
| [[Lightning Message Service]] | publish/subscribe, MessageContext |
| [[Record Form 선택]] | record-form vs edit-form vs view-form |
| [[ldsUtils reduceErrors]] | 8가지 에러 타입 정규화 |
| [[LWC 보안 패턴]] | customPermission, CSP, DOM XSS |
| [[Flow Screen LWC 패턴]] | FlowAttributeChangeEvent, validate() |
| [[모바일 기능 패턴]] | getBarcodeScanner, getLocationService, isAvailable() |
| [[Static Resource 로딩]] | loadScript/loadStyle, renderedCallback 3-state |
| [[파일 업로드와 이미지 처리]] | processImage, refreshApex, ContentVersion |

### [[Flow MOC|Flow]]
Salesforce Flow — 자동화, Screen Flow, Autolaunched Flow, Apex 액션

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Flow 종류와 변수]] | processType, isInput/isOutput, $Flow |
| [[Flow 요소 참조]] | recordLookups/Creates/decisions/actionCalls |
| [[Screen Flow 설계]] | flowruntime:, LWC 삽입, faultConnector |
| [[Autolaunched Flow 패턴]] | 헤드리스, Agent Action, Apex에서 호출 |
| [[@InvocableMethod 패턴]] | bulkInvoke, InputParameters, OutputParameters |

### Architecture(아키텍처)
설계 패턴 / 플랫폼 기초 개념 — 서비스 레이어, 권한 설계, Salesforce 개요

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Salesforce 플랫폼 개요]] | Org, Object, Record, Cloud 종류, 환경 |
| [[서비스 레이어 패턴]] | TriggerHandler-ServiceLayer 브로커 |
| [[Permission Set 설계]] | objectPermissions, fieldPermissions |
| [[Approval Namespace]] | ProcessSubmitRequest, ProcessWorkitemRequest |
| [[Schema Namespace 상세]] | DescribeSObjectResult, RecordTypeInfo |

### Aura(오라)
Aura 컴포넌트 — 레거시 컴포넌트 프레임워크 (신규 개발은 LWC 권장)

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Aura 컴포넌트 구조]] | aura:component, Controller/Helper 번들 |
| [[Aura 이벤트]] | Component/Application Event, $A.get |
| [[Aura vs LWC]] | 기능 비교, 마이그레이션 전략 |

### [[Visualforce(비주얼포스)/index|Visualforce(비주얼포스)]]
Visualforce Developer Guide v67.0 — Salesforce Classic 기반 태그형 마크업 UI 프레임워크(레거시). 신규 UI는 LWC/Aura 권장이나 PDF 렌더·표준 페이지/버튼 오버라이드·이메일 템플릿·기존 자산 유지보수엔 여전히 유효. (Part A 개념·컨트롤러 11노트 + Part B 표준 컴포넌트 레퍼런스 5노트)

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Visualforce 개요 — 도구·퀵스타트]] | apex:page, 마크업/컨트롤러 구조, Development Mode, 퀵스타트 |
| [[표준 컨트롤러·표준 리스트 컨트롤러]] | standardController, recordSetVar, pagination, 코드 없는 표준 동작 |
| [[동적 Visualforce — 바인딩·동적 컴포넌트]] | 동적 바인딩, Component.Apex, field set, 런타임 결정 |
| [[Visualforce 베스트 프랙티스]] | View State 관리, 성능 최적화, transient, 보안 권고 |
| [[apex 컴포넌트 — 페이지·레이아웃 구조]] | apex:page/pageBlock/panel*/form, 표준 컴포넌트 레퍼런스 |

### Admin(어드민)
일반 사용자 / 관리자 가이드 — 네비게이션, 인증, 기초 개념

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Salesforce 네비게이션]] | App Launcher, 전역 검색, 리스트뷰 |
| [[Salesforce ID 인증]] | MFA, Salesforce Authenticator, Trusted IP |

### [[Service(서비스)/index|Service Cloud]]
고객 서비스·지원 — Knowledge(지식)·Chat(채팅, 레거시)·Omni-Channel(Standard, v67.0 EOL)·Lightning Flow for Service

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Knowledge 데이터 모델 & API 개요]] | abstract/concrete 객체, 채널, 발행 주기, data category, API EOL |
| [[Knowledge SOAP API 객체 — 핵심 아티클 객체]] | KnowledgeArticle, __kav, __ka, PublishStatus |
| [[Knowledge REST API — Actions & Manage]] | invocable actions, 아티클 발행·번역 관리 |
| [[Knowledge Metadata API 타입 — 아티클·채널·설정]] | ArticleType, ChannelLayout, KnowledgeSettings |
| [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]] | AgentWork, ServiceChannel, UserServicePresence, PendingServiceRouting, 콘솔 메서드 |
| [[Omni-Channel External Routing]] | 서드파티 라우팅 통합, CDC Pub/Sub·Apex Trigger, AgentWork 생성 |
| [[Lightning Flow for Service (Actions & Recommendations)]] | RecordAction, RecordActionDeployment, guided engagement, NBA 추천 |

### [[Commerce(커머스)/index|Commerce(커머스)]]
Salesforce Order Management — 주문 데이터 모델·B2C Commerce 주문 데이터 맵·Import/Fulfillment/Taxation·Exchanges(RMA)/Payment Sequencing

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Order Management 개요와 데이터 모델]] | OrderSummary, FulfillmentOrder, OM 개발자 리소스, 엔티티 관계 |
| [[B2C Commerce Storefront Order Data Map]] | XSD 매핑, 21개 객체 필드, GtwyProvPaymentMethodType, 커스텀 결제 수단 |
| [[Order Management — Import·Fulfillment·Taxation]] | Create Order Summary, OrderLifecycleType, Location Capacity, net/gross 세금 |
| [[Order Management — Exchanges·Payment Sequencing·확장]] | Preview/Submit Cart, Payment Sequencing, EnsureFunds, ProductExpandService |

### [[CPQ(견적)/index|CPQ(견적)]]
Salesforce CPQ(`SBQQ` managed package) 개발자 가이드(v65.0 Winter '26) — API 데이터 모델·Quote/Configuration/Contract API·플러그인 (platform-native RLM과 별개 제품)

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[CPQ API Models]] | QuoteModel, ProductModel, ConfigurationModel, OptionModel, 11개 모델 |
| [[CPQ Quote API]] | SBQQ.ServiceRouter, QuoteSaver, QuoteCalculator, Save/Calculate/Read API |
| [[CPQ Configuration·Contract API]] | Configuration Loader/Validator, Contract Amender/Renewer, 번들 구성 |
| [[CPQ 기타 API — Document·Router·Quickstart·Triggers·Approvals]] | Generate Quote Document, TriggerControl, Advanced Approvals(SBAA) |
| [[JavaScript Quote Calculator Plugin]] | JSQCP, onAfterCalculate, Page Security, 커스텀 계산 |
| [[CPQ Plugins — Search·Recommended·Configurator·기타]] | Product Search, Recommended Products, E-Signature, 9개 플러그인 |

### [[Analytics(애널리틱스)/index|Analytics(애널리틱스)]]
CRM Analytics(Tableau CRM) Data Prep Recipe REST API(Summer '26) — 레시피로 데이터를 변환·정제하는 REST API의 개요·인증·엔드포인트·노드 Input·Response·Enum

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Data Prep Recipe REST API — 개요·인증·엔드포인트]] | Recipe REST API, 6개 엔드포인트, OAuth, Examples 워크플로, EOL |
| [[Recipe REST API — Bucket·Cluster 노드 Input]] | Bucket, Cluster, 버킷팅, 클러스터링, 노드 Input |
| [[Recipe REST API — Aggregate·Append·Join·Compute·Pivot Input]] | Aggregate, Join, Compute, Pivot, 집계·조인·피벗 |
| [[Recipe REST API — Load·Save·Output·ML 노드 Input]] | Load, Save, Output, ML, 소스 로드·저장·예측 |
| [[Recipe REST API — Enums]] | node type·action·data type·join type, 47개 enum |

### [[Security(보안)/index|Security(보안)]]
Secure Coding Guide(v67.0) 위협 모델 — XSS·SQLi·CSRF·Redirect·TLS·민감데이터·CRUD/FLS·Lightning 보안·세션/브라우저 통신

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[XSS 방어]] | Cross Site Scripting, JSENCODE/HTMLENCODE, 브라우저 파싱 컨텍스트 |
| [[권한과 접근 제어 위협]] | CRUD/FLS bypass, USER_MODE, stripInaccessible, sharing |
| [[Lightning Security 모델]] | Lightning Locker, CSP, AuraEnabled 보안 |
| [[SOQL Injection 위협]] | escapeSingleQuotes, bind variable, 동적 SOQL 방어 |
| [[민감 데이터 저장]] | Protected CMT/CS, Apex Crypto, Named Credentials |

### DevOps(데브옵스)
Salesforce DX — 소스 중심 개발, Scratch Org, Unlocked Package, CI/CD

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Salesforce DX 개요]] | sfdx-project.json, sf CLI, Source Format |
| [[Scratch Org 패턴]] | Dev Hub, org create scratch, Snapshot |
| [[Unlocked Package 패턴]] | sf package create/install, 2GP |
| [[CI CD 패턴]] | Jenkins, CircleCI, JWT 인증 자동화 |
| [[2GP — Prepare to Distribute]] | sf package version promote, AppExchange 등록, 코드 커버리지 75%, Installation Key |

### [[통합 MOC|Integration(통합)]]
외부 시스템 연동 — Named Credential, Callout, REST/SOAP

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Named Credential]] | External Credential, callout: 접두어 |
| [[RestClient 패턴]] | virtual class, PATCH 우회 |
| [[CSP와 RemoteSite]] | CspTrustedSite, RemoteSiteSetting, LWC vs Apex 외부 연동 |
| [[Custom REST Endpoint]] | @RestResource, RestContext |

### [[sObject/index|sObject Reference]]
Salesforce Platform Object Reference v67.0 — Field 타입, Object 그룹, 표준 Object 카탈로그

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[1 Overview]] | Primitive 타입, Field 타입, Compound Fields, Big Objects, External Objects |
| [[2 Object Behavior]] | Object 그룹, Data Cloud, DLO·DMO·CIO·DG, Object Types 접미사 |
| [[3 Associated Objects]] | Feed·History·Share·OwnerSharingRule·ChangeEvent(CDC) 패턴 |
| [[4 Custom Objects]] | __mdt 필드, __c 표준 필드, __Feed 표준 필드 |
| [[5 Object Interfaces]] | PriceAdjustmentGroup·PriceAdjustmentItem·SalesTransaction |
| [[6 Standard Objects]] | Account·Case·Opportunity·ApexClass 등 도메인별 카탈로그 |

### [[_active/index|Active — 진행 중]]
지금 집중해서 공부 중인 노트. 완성되면 도메인 폴더로 이동.

---

### [[Release MOC|Release Notes]]
Salesforce 연 3회 릴리즈 추적 — 신규 기능, Deprecated, 거버너 한도 변경

| 릴리즈 | API 버전 | 상태 |
|---|---|---|
| [[Summer '26]] | v67.0 | ✅ |
| [[Winter '26]] | v65.0 | ✅ |
| [[Summer '25]] | v64.0 | ✅ |
| [[Spring '25]] | v63.0 | ✅ |
| [[Winter '25]] | v62.0 | ✅ |
| [[Summer '24]] | v61.0 | ✅ |
| [[Spring '24]] | v60.0 | ✅ |
| [[Winter '24]] | v59.0 | ✅ |

---

## 🔖 태그 인덱스

- `#pattern` — 검증된 구현 패턴
- `#anti-pattern` — 피해야 할 구현
- `#decision` — 의사결정 매트릭스
- `#security` — 보안 관련
- `#async` — 비동기 처리
- `#testing` — 테스트 패턴
- `#integration` — 외부 연동
- `#release/apex` — Apex 릴리즈 변경
- `#release/lwc` — LWC 릴리즈 변경
- `#release/flow` — Flow 릴리즈 변경
- `#release/deprecated` — Deprecated 항목

---

## 📌 자주 찾는 패턴

| 상황 | 바로가기 |
|---|---|
| DML 앞에 보안 적용 | [[Safely]] · [[StripInaccessible]] |
| 비동기 방식 선택 | [[비동기 컨텍스트 선택]] |
| 동적 SOQL 안전하게 | [[Dynamic SOQL]] |
| 트리거 구조 잡기 | [[TriggerHandler 패턴]] |
| HTTP 호출 추상화 | [[RestClient 패턴]] |
| 외부 의존성 모킹 | [[StubProvider]] |
| 실행 환경 확인 | [[QuiddityGuard]] · [[OrgShape]] |
