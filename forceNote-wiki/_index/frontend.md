---
tags: [index, search, navigation]
created: 2026-05-21
---

# SEARCH INDEX — 프론트엔드 (LWC / Aura / Flow)
> LWC·Aura·Flow·Base Components 키워드 → 파일
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.

## LWC — 개요 / 시작 (Get Started)

| 키워드 | 파일 |
|---|---|
| LWC, Lightning Web Components, LWC 개요, LWC 시작, get started, LWC란 무엇인가, web components, base components, 표준 웹 기술, W3C TC39, 오픈소스, Aura 상호운용, LWC vs Aura, choose LWC, 시작 경로, LWC 진입점 | `LWC/LWC 개요 (Get Started).md` |

## LWC — Create Components (컴포넌트 작성)

| 키워드 | 파일 |
|---|---|
| lifecycle hooks, LWC 라이프사이클, 생명주기, constructor, connectedCallback, disconnectedCallback, renderedCallback, errorCallback, error boundary, hasRendered, isConnected, 컴포넌트 렌더 후 실행, DOM 삽입 제거 시 코드 | `LWC/CreateComponents(컴포넌트작성)/Lifecycle Hooks.md` |
| LWC CSS, CSS 스타일시트, scoped CSS, :host selector, shadow DOM 스코핑, static stylesheets, cascade specificity inheritance, host-context ::part 미지원, LWC 스타일링, 컴포넌트 CSS | `LWC/CreateComponents(컴포넌트작성)/CSS 스타일시트와 스코핑.md` |
| 컴포넌트 접근성, accessibility, a11y, ARIA, aria-label, ariaLabel, aria-pressed, screen reader, label, WCAG, 기본 ARIA, role 고정, ID ARIA 링크, camel-case ARIA, 접근성 속성, LWC에서 aria 속성 어떻게, 스크린리더 대응 | `LWC/CreateComponents(컴포넌트작성)/컴포넌트 접근성 (ARIA·label).md` |

## LWC — Reference (레퍼런스)

| 키워드 | 파일 |
|---|---|
| LWC directives, HTML template directives, lwc:if lwc:elseif lwc:else, if:true, for:each for:item for:index, iterator, key, lwc:ref, lwc:dom, lwc:spread, lwc:on, lwc:slot-data slot-bind, lwc:is, 조건 렌더링, 리스트 렌더링, 슬롯 | `LWC/Reference(레퍼런스)/HTML 템플릿 Directives 레퍼런스.md` |
| @salesforce modules, salesforce 모듈, @salesforce/apex, @salesforce/schema, @salesforce/label, @salesforce/resourceUrl, @salesforce/contentAssetUrl, @salesforce/user, @salesforce/userPermission, @salesforce/customPermission, @salesforce/client/formFactor, @salesforce/community, @salesforce/site, @salesforce/messageChannel, getSObjectValue, refreshApex, import salesforce 리소스, LWC에서 Apex label 정적리소스 import | `LWC/Reference(레퍼런스)/@salesforce Modules 레퍼런스.md` |
| js-meta.xml, LWC 설정 파일, configuration file, targets, target, capability, isExposed, apiVersion, masterLabel, targetConfig, lightning__RecordPage, lightning__AppPage, lightning__FlowScreen, lightning__UrlAddressable, lightning__Tab, lightning__UtilityBar, lightning__HomePage, AgentforceInput, 컴포넌트 어디에 노출 | `LWC/Reference(레퍼런스)/XML Config File Elements (js-meta.xml) 레퍼런스.md` |
| PageReference, PageReference Types, NavigationMixin, standard__recordPage, standard__objectPage, standard__navItemPage, standard__component, standard__webPage, standard__flow, standard__quickAction, comm__namedPage, LWC 네비게이션 타입, 페이지 이동 | `LWC/Reference(레퍼런스)/PageReference Types 레퍼런스.md` |
| LWC API modules, lightning/uiRecordApi, lightning/graphql, lightning/uiObjectInfoApi, lightning/uiListsApi, lightning/uiRelatedListApi, lightning/empApi, lightning/mobileCapabilities, lightning/analyticsWaveApi, lightning/platformWorkspaceApi, lightning/platformUtilityBarApi, experience/cmsDeliveryApi, wire adapter 모듈, lightning 네임스페이스 API 모듈, First API Version, LWC에서 어떤 lightning API 모듈 쓰나 | `LWC/Reference(레퍼런스)/LWC API Modules 레퍼런스.md` |

## LWC — Apex 호출 / 데이터 로드

| 키워드 | 파일 |
|---|---|
| @wire, wire 어댑터, cacheable, 자동 데이터 로드, reactive property, $변수 | `LWC/ApexIntegration(Apex통합)/Wire 패턴.md` |
| wire vs imperative, 언제 wire, 언제 직접 호출, wire 파라미터 undefined, wire 호출 보류, $변수 undefined, wire가 실행 안 됨 | `LWC/ApexIntegration(Apex통합)/Wire vs Imperative 선택.md` |
| imperative, async await, 버튼 클릭 호출, 직접 Apex 호출, isLoading | `LWC/ApexIntegration(Apex통합)/Imperative 호출 패턴.md` |

## LWC — 컴포넌트 통신 / 이벤트

| 키워드 | 파일 |
|---|---|
| CustomEvent, 자식→부모, dispatchEvent, detail, bubbles, composed, 이벤트 버블링 | `LWC/Events(이벤트)/CustomEvent 패턴.md` |
| 이벤트 전파, event propagation, bubbles, composed, Event.target, currentTarget, composedPath, event retargeting, shadow 경계 이벤트, props down events up, 네임스페이스 이벤트, 이벤트가 부모로 전파, bubble 설정 | `LWC/Events(이벤트)/이벤트 전파 (bubbles·composed).md` |
| LMS, Lightning Message Service, 형제 컴포넌트, 크로스 컴포넌트, publish, subscribe, MessageContext, pubsub | `LWC/Events(이벤트)/Lightning Message Service.md` |
| @api property, @api method, 부모→자식, querySelector, getter setter, lwc:spread | `LWC/ComponentAPI(컴포넌트API)/@api 패턴.md` |
| LWC API 버전 관리, apiVersion, js-meta.xml, lwc:if, lwc:elseif, lwc:else, 동적 임포트, dynamic import, Lightning Web Security, LWS, if:true deprecated, createComponent, sfdx-project.json sourceApiVersion | `LWC/ComponentAPI(컴포넌트API)/LWC API 버전 관리.md` |
| 다른 컴포넌트 함수 호출, 컴포넌트 간 함수 실행 | `LWC/ComponentAPI(컴포넌트API)/@api 패턴.md` + `LWC/Events(이벤트)/Lightning Message Service.md` |
| 상태 관리, @lwc/state, atom, computed, 공유 상태, fromContext | `LWC/Events(이벤트)/상태 관리.md` |
| 컨테이너 컴포넌트, 프레젠테이션, 컴포지션, for:each, lwc:if | `LWC/ComponentAPI(컴포넌트API)/컴포지션 패턴.md` |

## LWC — LDS / 레코드 조작

| 키워드 | 파일 |
|---|---|
| UI API, User Interface API, ui-api, REST 엔드포인트, wire 어댑터 목록, uiRecordApi 모듈, uiObjectInfoApi, uiListsApi, uiRelatedListApi, RecordUI, ObjectInfo, getRelatedListInfo, getRelatedListRecords, getObjectInfo, getObjectInfos, getListUi, getListRecords, LDS REST API 전체 | `LWC/LDS/UI API 개요.md` |
| UI API reference, record-input, object-info fields, request body, response body, layoutTypes, optionalFields, childRelationships, picklist values 스키마, UI API 응답 바디, UI API 요청 파라미터, 레코드 인풋 | `LWC/LDS/UI API 리소스 레퍼런스.md` |
| lightning-record-form, record-edit-form, record-view-form, 레코드 폼 선택 | `LWC/LDS/Record Form 선택.md` |
| getRecord, getFieldValue, static schema, @salesforce/schema, layoutTypes, modes, 레이아웃 필드, 레이아웃 기반 레코드 조회 | `LWC/LDS/getRecord 패턴.md` |
| createRecord, updateRecord, deleteRecord, uiRecordApi, notifyRecordUpdateAvailable, 레코드 생성 수정 삭제, LWC에서 DML | `LWC/LDS/uiRecordApi.md` |
| reduceErrors, 에러 정규화, ldsUtils | `LWC/LDS/ldsUtils reduceErrors.md` |
| getPicklistValues, Picklist 옵션 로드, 동적 Picklist, 종속 Picklist, validFor, controllerValues, LWC에서 콤보박스 옵션 | `LWC/LDS/getPicklistValues 패턴.md` |
| GraphQL wire, lightning/graphql, gql, graphql wire adapter, GraphQL API LWC, variables getter, errors 프로퍼티, uiGraphQLApi, LWC에서 GraphQL 쿼리, 그래프QL, refresh | `LWC/LDS/GraphQL Wire Adapter.md` |
| RefreshView API, lightning/refresh, RefreshViewEvent, view refresh, 데이터 새로고침, refreshApex, refreshGraphQL, notifyRecordUpdateAvailable, 컴포넌트 데이터 갱신, 페이지 리로드 없이 갱신, 뷰 새로고침 어떻게, 표준 새로고침 API | `LWC/LDS/RefreshView API.md` |
| executeMutation, lightning/graphql mutation, gql mutation, AccountCreate, ContactUpdate, ContactDelete, RecordDelete, uiapi mutation input, GraphQL 뮤테이션, GraphQL 레코드 생성 수정 삭제, Apex 없이 CRUD, LWC에서 GraphQL로 레코드 만들기, graphql wire refresh, GraphQL variables 인젝션 방지 | `LWC/LDS/GraphQL 뮤테이션 (executeMutation) — Create·Update·Delete.md` |

## LWC — UI / 네비게이션 / 모달

| 키워드 | 파일 |
|---|---|
| Toast, ShowToastEvent, variant, success error warning info | `LWC/UIPatterns(UI패턴)/Toast & 모달 패턴.md` |
| 모달, LightningModal, modal open close, 확인 다이얼로그 | `LWC/UIPatterns(UI패턴)/Toast & 모달 패턴.md` |
| LightningAlert, alert.open, 단순 경고 다이얼로그, 차단 알림, OK 클릭 대기 | `LWC/UIPatterns(UI패턴)/Toast & 모달 패턴.md` |
| 에러 패널, errorPanel, 에러 표시 컴포넌트 | `LWC/UIPatterns(UI패턴)/에러 패널 패턴.md` |
| 공유 JS, 유틸리티 함수, named export, isExposed false | `LWC/UIPatterns(UI패턴)/공유 JS 모듈.md` |
| NavigationMixin, 페이지 이동, 레코드 페이지 이동, pageReference | `LWC/Navigation(네비게이션)/NavigationMixin 패턴.md` |
| Lightning Console API, Console JS API, workspaceAPI, platformWorkspaceApi, openTab openSubtab, getFocusedTabInfo, closeTab focusTab, utilityBarAPI 유틸리티 바, navigationItemAPI, Console Integration Toolkit, 콘솔 앱 탭 제어, Service Console | `LWC/Navigation(네비게이션)/Lightning Console JS API.md` |
| Static Resource, loadScript, loadStyle, 서드파티 라이브러리, renderedCallback | `LWC/UIPatterns(UI패턴)/Static Resource 로딩.md` |
| 파일 업로드, 이미지 처리, processImage, FileReader, ContentVersion | `LWC/UIPatterns(UI패턴)/파일 업로드와 이미지 처리.md` |
| CRM Analytics 대시보드 LWC, analytics__Dashboard, 대시보드 위젯, hasStep, step 쿼리, Wave 대시보드 커스텀 위젯, bindings 동적 속성 | `LWC/UIPatterns(UI패턴)/CRM Analytics 대시보드용 LWC.md` |
| LWR Sites, Experience Cloud LWR, Enhanced LWR, enhanced sites and content platform, Build Your Own Microsite 템플릿, Build Your Own vs Microsite, lightningCommunity__Page Page_Layout Theme_Layout Default, --dxp 스타일링 훅, dxp-g-brand, Experience Builder LWC, 커뮤니티 사이트 컴포넌트, Remove SLDS, partial deployment, expression-based visibility, site content search, GlobalSearchController, Editions, Experience Delivery, SSR, CSR, custom record component, logout link, secur/logout.jsp | `LWC/UIPatterns(UI패턴)/LWR Sites (Experience Cloud).md` |
| LWR 다국어, multilingual LWR site, 언어 추가, fallback language, automatic language detection, PreferredLanguage cookie, 번역 내보내기 가져오기, .xlf, ExperienceBundle translation, RTL, Language Selector, translatable=true, 다국어 제약 | `LWC/UIPatterns(UI패턴)/LWR 다국어 사이트.md` |
| LWR expressions, 표현식, {!Route.term}, {!CurrentUser}, {!cmsMedia.contentKey}, {!Item.field}, {!Site.basePath}, {!User.userId}, data binding, expression-based visibility, dynamic data | `LWC/UIPatterns(UI패턴)/LWR Expressions 레퍼런스.md` |
| LWR caching, 캐싱 정책, Caching TTL, CDN, LWR publishing model, new publishing model, frozen components, republish, Which Features Are Affected, custom URL paths, /s 제거, vforcesite, unauthenticated site, head markup, basePath versionKey, Light DOM, third-party analytics, LWR Template Limitations, Unsupported Features, 500 routes 250, dynamic import, statically analyzable, asset files in sandbox, F6 navigation, screen reader, ARIA-Live, LWR 동작 캐싱 제약, LWR 제약, 미지원 기능 | `LWC/UIPatterns(UI패턴)/LWR 동작·캐싱·제약.md` |
| LWR 컴포넌트 개발, LWR custom component, js-meta.xml targets, lightningCommunity__Page lightningCommunity__Page_Layout lightningCommunity__Theme_Layout lightningCommunity__Default, targetConfigs, Component Properties, @salesforce 모듈 LWR, 화면 크기 반응형, --dxp-c-screensize-property, screenResponsive, 커스텀 레이아웃 컴포넌트, custom layout component, 커스텀 내비게이션 메뉴, custom navigation menu, NavigationLinkSet, F6 navigation, LWR 컴포넌트 어떻게 만드나, Experience Builder 커스텀 컴포넌트 개발 | `LWC/UIPatterns(UI패턴)/LWR 컴포넌트 개발 심화.md` |
| LWR 스타일링 훅, --dxp 스타일링 훅, --dxp-g --dxp-s --dxp-c, dxp-g-brand, LWR 브랜딩, Brand Your LWR Site, LWR 사이트 색상 폰트 어떻게 바꾸나, Theme 패널 속성 매핑, Color Palette, Text Site Spacing 훅, Button Colors 훅, Site Logo 훅, 커스텀 폰트 Custom Fonts, Remove SLDS, Override Component Branding, 컴포넌트 브랜딩 오버라이드, part dxp, 커스텀 CSS 오버라이드, dxp 변수 의미 | `LWC/UIPatterns(UI패턴)/LWR --dxp 스타일링 훅 레퍼런스.md` |
| LWR Tag Manager, Experience Tag Manager, Google Tag Manager, GTM, LWR 데이터 관리, Manage Data, experience_interaction, Experience Data Layer, Tag Manager Event Reference, 인터랙션 이벤트 추적, Cart Catalog Consent Email Engagement Error Line Item Search Wish-List Interactions, set-consent, Consent Opt-In, Website Engagement DMO, Data Cloud, x-oasis-script, LWR 사이트 인터랙션 추적, LWR 사이트 데이터 어떻게 Data Cloud로 보내나, GTM LWR 연동 | `LWC/UIPatterns(UI패턴)/LWR Tag Manager 데이터 관리.md` |
| Lightning Out 2.0, Lightning Out, 외부 앱 임베드, lightning-out-application, frontdoor-url, app-id, LWR 외부, iframe LWC, closed shadow DOM, lo.application.ready, window.postMessage, 외부 사이트에 LWC 임베드, 비-Salesforce 앱에 LWC 넣기 | `LWC/UIPatterns(UI패턴)/Lightning Out 2.0 (외부 앱 임베드).md` |
| LWC drag and drop, HTML5 drag drop, dataTransfer, draggable, ondragstart, ondrop, ondragover, setData, getData, effectAllowed, dropEffect, preventDefault, setDragImage, dragenter, dragleave, dragend, SObject 직렬화, 레코드 드래그, 드래그앤드롭, 드래그 앤 드롭, 컴포넌트 간 데이터 전달, LWC에서 드래그로 레코드 옮기기, 드롭존 만들기 | `LWC/UIPatterns(UI패턴)/LWC 드래그앤드롭 패턴 (HTML5 dataTransfer).md` |

## LWC — 보안 / 모바일

| 키워드 | 파일 |
|---|---|
| LWC 보안, CSP 브라우저, 권한 기반 UI, userId | `LWC/Security(보안)/LWC 보안 패턴.md` |
| Lightning Web Security, LWS, Lightning Locker, 클라이언트 보안, client-side security, distortion, secure wrapper, JavaScript strict mode, CSP, Content Security Policy, 가상 JS 샌드박스, LWS vs Locker, 어떤 보안 아키텍처 | `LWC/Security(보안)/Lightning Web Security vs Lightning Locker.md` |
| 모바일, getBarcodeScanner, 바코드, getLocationService, GPS, isAvailable | `LWC/Mobile(모바일)/모바일 기능 패턴.md` |
| 모바일 오프라인, LWC Offline, Offline GraphQL, Briefcase 프라이밍, draft records 충돌, mobileCapabilities 전체 서비스, getBiometrics getNfc getContacts getCalendar getPayments getDocumentScanner getGeofencing, 오프라인 캐시 | `LWC/Mobile(모바일)/모바일 & 오프라인 (LWC).md` |

## LWC — Jest 테스트

| 키워드 | 파일 |
|---|---|
| LWC Jest 테스트, jest wire mock, @wire 테스트, registerTestWireAdapter, emit, emitError | `LWC/Testing(테스트)/Jest 테스트 패턴.md` |
| LWC DOM 이벤트 테스트, querySelector, dispatchEvent, CustomEvent 검증, 버튼 클릭 테스트 | `LWC/Testing(테스트)/Jest 테스트 패턴.md` |
| @salesforce/apex mock, jest.mock, mockResolvedValue, mockRejectedValue, virtual true, Apex 모킹 LWC | `LWC/Testing(테스트)/Jest 테스트 패턴.md` |

## LWC — 내부 구조 (Internals, Tier 1 오픈소스 소스)

| 키워드 | 파일 |
|---|---|
| LWC 오픈소스 아키텍처, lwc monorepo, @lwc/compiler, @lwc/engine-core, @lwc/engine-dom, @lwc/ssr-compiler, @lwc/ssr-runtime, @lwc/template-compiler, static content optimization, virtual DOM LWC, shadow DOM light DOM, LWC 패키지 구조 | `LWC/Internals(내부구조)/LWC 오픈소스 아키텍처.md` |
| @api 내부 동작, createPublicPropertyDescriptor, createPublicAccessorDescriptor, vm.cmpProps, @api 반응성 구현, 생성자에서 @api 읽기 금지, registerDecorators, PropType Field Set Get GetSet | `LWC/Internals(내부구조)/@api 데코레이터 내부 구조.md` |
| @track 내부 동작, internalTrackDecorator, getReactiveProxy, observable-membrane, vm.cmpFields, @track vs @api 저장 위치, 중첩 객체 반응성, track 함수 호출 | `LWC/Internals(내부구조)/@track 데코레이터 내부 구조.md` |
| LWC VM 인터페이스, VMState created connected disconnected, RenderMode Light Shadow, ShadowMode Native Synthetic, ViewModelReflection WeakMap, cmpProps cmpFields cmpSlots, LWC 컴포넌트 인스턴스 내부 구조 | `LWC/Internals(내부구조)/LWC VM 내부 구조.md` |
| @wire 내부 동작, WireAdapter 인터페이스, WireAdapterConstructor, createConnector, createConfigWatcher, ReactiveObserver, ENABLE_WIRE_SYNC_EMIT, legacy register WireEventTarget ValueChangedEvent, wire 어댑터 구현 | `LWC/Internals(내부구조)/@wire 어댑터 내부 구조.md` |
| LWC Signals, @lwc/signals, Signal 인터페이스, SignalBaseClass, addTrustedSignal, setTrustedSignalSet, isTrustedSignal, ENABLE_EXPERIMENTAL_SIGNALS, LWC 시그널, 외부 반응형 상태 | `LWC/Internals(내부구조)/LWC Signals.md` |
| LWC 런타임 플래그, lwcRuntimeFlags, setFeatureFlag, setFeatureFlagForTest, DISABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE, ENABLE_WIRE_SYNC_EMIT, DISABLE_SYNTHETIC_SHADOW, ENABLE_FROZEN_TEMPLATE, ENABLE_LEGACY_SCOPE_TOKENS, DISABLE_DETACHED_REHYDRATION, @lwc/features | `LWC/Internals(내부구조)/LWC 런타임 Feature Flags.md` |
| LWC 템플릿 컴파일러, @lwc/template-compiler, compile() 함수, TemplateCompileResult, RENDER_APIS, api_element api_custom_element api_text api_dynamic_text api_static_fragment, static content optimization, isStaticNode, optimizeStaticExpressions, stcN 호이스팅, LWC HTML 컴파일 출력 | `LWC/Internals(내부구조)/LWC 템플릿 컴파일러 파이프라인.md` |
| LWC Shadow DOM 모드, native shadow synthetic shadow light DOM 비교, RenderMode Light Shadow, ShadowMode Native Synthetic, shadowSupportMode any reset native, shadow migrate mode, applyShadowMigrateMode, DISABLE_SYNTHETIC_SHADOW, @lwc/synthetic-shadow 폴리필 | `LWC/Internals(내부구조)/LWC Shadow DOM 모드.md` |

---

## Aura(오라) — Aura 컴포넌트

| 키워드 | 파일 |
|---|---|
| Aura 컴포넌트, aura:component, .cmp, Controller.js, Helper.js, aura:attribute, aura:handler, aura:registerEvent, Aura 번들 구조, aura:iteration, aura:if | `Aura(오라)/Aura 컴포넌트 구조.md` |
| Aura 이벤트, Component Event, Application Event, aura:registerEvent, aura:handler, $A.get, force:navigateToSObject, force:showToast, 시스템 이벤트 init change render, getParam undefined, 이벤트 전파 단계, capture bubble, stopPropagation, preventDefault, includeFacets | `Aura(오라)/Aura 이벤트.md` |
| Aura vs LWC, Aura 마이그레이션, Aura 비교, 언제 LWC 언제 Aura, Aura 레거시, LWC 우선 정책 | `Aura(오라)/Aura vs LWC.md` |
| Aura to LWC, Aura LWC 마이그레이션, migrate aura, 번들 파일 매핑, cmp html, aura:attribute @api, controller helper renderer 하나의 js, Aura가 LWC 포함, 상호운용, Aura 컴포넌트를 LWC로 전환, 마이그레이션 치트시트 | `Aura(오라)/Aura → LWC 마이그레이션.md` |
| ui namespace deprecated, ui 네임스페이스 deprecated, ui:inputText 대체, ui:button 대체, ui:outputText 대체, ui:menu 대체, ui 컴포넌트 대체, Aura ui deprecated, ui to lightning migration, ui 컴포넌트 lightning 매핑, ui 컴포넌트 뭘로 바꿔, ui 컴포넌트 지원 종료 | `Aura(오라)/ui 네임스페이스 Deprecated — lightning 대체 매핑.md` |
| lightning:quickActionAPI, Sfdc.canvas.publisher, getAvailableActions, setActionFieldValues, publisher.selectAction, Quick Action JS API, Publisher JS API, 퀵액션 자바스크립트 API, Aura에서 퀵액션 제어, 케이스피드 액션 호출 | `Aura(오라)/Quick Action·Publisher JS API 레퍼런스.md` |
| apex:emailPublisher, apex:logCallPublisher, support:portalPublisher, support:caseArticles, support:CaseFeed, chatter:feed, Case Feed Visualforce, 케이스피드 커스터마이즈, VF 이메일 액션, 표준 케이스피드 복제, verticalResize, categoryMappingEnabled, insertLinkToEmail, VF 컴포넌트 속성표 | `Aura(오라)/Case Feed Visualforce 커스터마이즈.md` |
| forceCommunity:availableForAllPageTypes, forceCommunity:availableForRecordHome, forceCommunity:layout, forceCommunity:themeLayout, themeLayout, Experience Builder Aura 컴포넌트, Experience Builder Aura 사이트 개발, 커스텀 테마 레이아웃, swappable 검색/프로필 메뉴, Aura 사이트 expression, {!CurrentUser} {!Route}, design resource Experience Builder, Personalization Target, 개인정보 표시 설정, PII 숨기기 Experience, UserPreferencesShowEmailToGuestUsers, Aura 컴포넌트를 Experience Builder용으로 만들려면, Experience Cloud Aura 사이트 어떻게 개발 | `Aura(오라)/Experience Builder Aura 사이트 개발.md` |
| Pardot 추적 Experience Cloud, Pardot tracking Experience Builder, Edit Head Markup, Relaxed CSP Permit Inline Scripts, Salesforce CMS, CMS Connect, lightningcommunity:deflectionSignal, deflectionSignal, Case Deflection 컴포넌트, Case Create Deflection Signal, 케이스 deflection 리포트, Community Case Deflection Metrics, caseCreateDeflectionModal, Experience Cloud 사이트에 Pardot/CMS/Deflection 붙이기, 케이스 생성 회피 측정 어떻게 | `Aura(오라)/Experience Builder 사이트 — Pardot·CMS·Deflection.md` |

---

## Flow

| 키워드 | 파일 |
|---|---|
| @InvocableMethod, Flow Action, bulkInvoke, Flow에서 Apex 호출 | `Flow/@InvocableMethod 패턴.md` |
| Autolaunched Flow, 헤드리스 Flow, 레코드 CRUD Flow | `Flow/Autolaunched Flow 패턴.md` |
| Screen Flow, 다단계 마법사, 화면 Flow 설계 | `Flow/Screen Flow 설계.md` |
| Flow Screen LWC, FlowAttributeChangeEvent, @api validate, Flow 안 LWC | `Flow/Flow Screen LWC 패턴.md` |
| Flow 종류, processType, AutoLaunchedFlow, 변수 isInput isOutput | `Flow/Flow 종류와 변수.md` |
| Flow 요소, XML, recordLookups, decisions, assignments, actionCalls | `Flow/Flow 요소 참조.md` |
| 멀티 패키지, sfdx-project.json, 도메인별 패키지 | `Flow/멀티 패키지 구조.md` |
| AggregateRecordList, FilterRecords, DedupeRecordList, Flow 컬렉션 조작, Flow 리스트 필터 집계 정렬 | `Flow/Flow 레코드 컬렉션 조작.md` |
| ExecuteSOQLQuery, SaveRecordsAsync, Flow 동적 SOQL, Flow 비동기 저장, IsRecordLocked, SetRecordLock, 레코드 잠금 | `Flow/Flow 데이터 & 보안 액션.md` |
| quickChoice, Flow Screen 선택기, render() 멀티 템플릿, Custom Property Editor, 카드 라디오 드롭다운 Flow, CPE, builderContext, inputVariables, configuration_editor_input_value_changed, 커스텀 프로퍼티 에디터, Flow Builder 커스텀 설정 UI | `Flow/quickChoice Screen Component.md` |
| CalculateBusinessHours, 영업시간 계산, GetRandomValue, FormatStringListAsCsv, PostRichChatter, GenerateFlowLink, LaunchAutolaunchedFlow | `Flow/Flow 유틸리티 액션 모음.md` |
| Flow 이름 규칙, Flow 네이밍, API 이름 접두어, Get_ Update_ Insert_ APEX_ SUB_ SC01_, Flow 요소 이름, 이벤트 약어 BI BU AI AU BD | `Flow/Flow 네이밍 컨벤션.md` |
| Flow 에러 처리, faultConnector, FaultMessage, Flow fault, Flow 오류 화면, Flow 에러 이메일, 에러 로그 레코드 | `Flow/Flow 에러 처리.md` |
| Flow 베스트 프랙티스, Fast Field Update, Flow 바이패스, 하드코딩 ID 금지, Flow 거버너, Mixed DML, Asynchronous Path, Flow 서킷 브레이커, Entry Criteria, Flow Trigger Explorer | `Flow/Flow 설계 베스트 프랙티스.md` |
| Flow vs Apex Trigger, Record-Triggered Flow vs Apex, Apex vs Flow, 트리거 자동화 선택, 자동화 밀도, automation density, record-triggered automation decision, 트리거 선택 기준, Flow로 할까 Apex로 할까, 하이브리드 패턴, Flow Apex 혼용, Invocable Apex 오프로딩, 자동화 결정 가이드 | `Flow/Record-Triggered Flow vs Apex Trigger 선택.md` |
| availableForFlowActions, Flow local action, Aura local action, invoke method, lightning:navigation, navService.navigate, PageReference types, standard__recordPage, standard__objectPage, standard__navItemPage, force:utilityBarAPI, lightning:utilityBarAPI, minimizeUtility, getUtilityInfo, Flow 로컬 액션, 플로우 클라이언트 액션, Flow에서 페이지 이동, 유틸리티바 최소화, Screen Flow 네비게이션, Flow에서 레코드로 이동하려면, Flow에서 유틸리티바 닫는 법, 로컬 액션 vs 인보커블 | `Flow/Aura Flow 로컬 액션 (availableForFlowActions).md` |

---


## LWC — SLDS / 디자인 시스템

| 키워드 | 파일 |
|---|---|
| SLDS, SLDS 2, Lightning Design System, LWC 디자인 시스템, CSS Styling Hook, 스타일링 훅, CSS Custom Properties, Design Token, 전역 토큰, --slds-g-*, --slds-c-*, Dark Mode, 다크 모드, Density Styling Hook, 밀도 인식, 반응형 디자인, Winter 26 GA | `LWC/UIPatterns(UI패턴)/SLDS LWC 디자인 시스템.md` |
| SLDS 유틸리티 클래스, slds-grid, slds-col, slds-size, slds-m-*, slds-p-*, slds-text-heading, slds-button, slds-button_brand, slds-button_neutral, slds-button_destructive, slds-icon_container, Shadow DOM CSS 격리, light DOM CSS | `LWC/UIPatterns(UI패턴)/SLDS LWC 디자인 시스템.md` |
| SLDS 유틸리티 클래스, slds-m-_, slds-p-_, slds-grid, slds-col, slds-text-heading, slds-box, slds-truncate, 마진 패딩 클래스, 유틸리티 전수, SLDS Utilities | `LWC/SLDS(디자인시스템)/SLDS 유틸리티 클래스 레퍼런스.md` |
| SLDS 스타일링 훅, Styling Hooks, --slds-g-_, --slds-c-_, CSS Custom Properties, 테마 다크모드 훅, 색상 토큰 | `LWC/SLDS(디자인시스템)/SLDS 스타일링 훅.md` |
| SLDS 접근성, Accessibility, a11y, 색 대비, 포커스 관리, 키보드 인터랙션, WCAG, 모바일 접근성 | `LWC/SLDS(디자인시스템)/SLDS 접근성.md` |
| SLDS 모범 사례, Best Practices, SLDS1 vs SLDS2, 3단계 커스터마이즈 모델, 마이그레이션 | `LWC/SLDS(디자인시스템)/SLDS 모범 사례.md` |
| SLDS 개발 도구, SLDS Tools, Figma Kit, SLDS Linter, SLDS Validator, VS Code 확장 | `LWC/SLDS(디자인시스템)/SLDS 개발 도구.md` |
| SLDS 블루프린트, Blueprint, CSS 전용 컴포넌트, slds-timeline slds-tree, activity-timeline alert app-launcher, 블루프린트 카탈로그 | `LWC/SLDS(디자인시스템)/SLDS 블루프린트 카탈로그.md` |
| design-system-react, DSR, IconSettings, iconPath, onRequestIconPath, Icon category name, SLDS blueprint, SLDS React, React on Salesforce UI bundle, shadcn Tailwind SLDS, optimizeDeps CJS pre-bundle, @salesforce-ux/design-system, slds-card blueprint, slds-button variant, Lucide icons, SLDS React 컴포넌트, 리액트에서 SLDS UI 만들기, 아이콘 경로 설정, 카드 버튼 아이콘 세 방식 비교, React SLDS 스타일링, 리액트 SLDS 블루프린트 vs shadcn, React UI Bundle 스타일링 | `LWC/SLDS(디자인시스템)/design-system-react — SLDS React 컴포넌트 라이브러리.md` |
| Agentic Experiences, SLDS Agentic Experiences 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Agentic Experiences.md` |
| Builder, SLDS Builder 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Builder.md` |
| Charts, SLDS Charts 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Charts.md` |
| Conversation Design, SLDS Conversation Design 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Conversation Design.md` |
| Currency, SLDS Currency 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Currency.md` |
| Data Entry, SLDS Data Entry 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Data Entry.md` |
| Displaying Data, SLDS Displaying Data 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Displaying Data.md` |
| In App Feedback, SLDS In App Feedback 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - In App Feedback.md` |
| Interface Feedback, SLDS Interface Feedback 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Interface Feedback.md` |
| Layout, SLDS Layout 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Layout.md` |
| Loading, SLDS Loading 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Loading.md` |
| Localization, SLDS Localization 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Localization.md` |
| Markup and Style, SLDS Markup and Style 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Markup and Style.md` |
| Messaging UI, SLDS Messaging UI 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Messaging UI.md` |
| Metric Display, SLDS Metric Display 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Metric Display.md` |
| Navigation, SLDS Navigation 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Navigation.md` |
| Notifications, SLDS Notifications 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Notifications.md` |
| Prompt Design Guide, SLDS Prompt Design Guide 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Prompt Design Guide.md` |
| Rules, Filters, and Logic, SLDS Rules, Filters, and Logic 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Rules, Filters, and Logic.md` |
| Search, SLDS Search 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - Search.md` |
| User Engagement, SLDS User Engagement 패턴, 디자인 패턴, SLDS 2 pattern | `LWC/SLDS(디자인시스템)/SLDS 패턴 - User Engagement.md` |

## LWC — SLDS 2 Starter Kit (로컬 프로토타이핑)

| 키워드 | 파일 |
|---|---|
| SLDS 2 Starter Kit, design-system-2-starter-kit, LWC Vite 로컬 개발, LWC를 로컬에서 어떻게 띄우나, 프로토타이핑 스캐폴드, 프로젝트 구조, 컴포넌트 네임스페이스 shell page ui data, 기술 스택, vite config, 엔트리 플로우, 네이밍 컨벤션 | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - 개요와 프로젝트 구조.md` |
| SLDS 2 Starter Kit 라우팅, 클라이언트 라우터, router.js, routes.config.js, apps.config.js, 멀티앱 셸, Standard Console Builder 앱, ROUTE_COMPONENTS, navPage vs navHighlight, History API SPA, 클라이언트 사이드 라우팅 어떻게 | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - 라우팅과 멀티앱 셸.md` |
| SLDS 1 2 로더, slds-loader.js, SLDS 1과 2를 어떻게 전환하나, lazy CSS 로딩, 테마 전환 theme switcher, 다크모드 dark mode, synthetic shadow vs native shadow, Shadow DOM 모드 | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM.md` |
| SLDS 2 Starter Kit 아이콘 모달 폼 배포, prebuild-icons 아이콘 코드젠, LightningModal 패턴, Lightning Base Component 폼, GitHub Pages 배포, SLDS agent skills afv-library 스킬, 아이콘 프리빌드 | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - 아이콘·모달·폼·배포.md` |
| SLDS 2 Starter Kit 셸 UI 컴포넌트, globalHeader globalNavigation, 글로벌 헤더 내비게이션, App Launcher waffle, Console object switcher, Standard tabs, docked panel shell-panel ui-panel 4종, 도킹 패널, pageHeader homeIntro builderHeader, lightning-datatable contacts 페이지, contactDetail builder home 예제 페이지, data/contacts fixture, 스타터킷 헤더 내비 패널 컴포넌트 어떻게 구현 | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - 셸 UI 컴포넌트.md` |
| SLDS 2 Starter Kit UI 코딩 가이드라인, .builderrules, Salesforce UI Guidelines, LBC 우선, UI 코드 체크리스트, 스타일링 훅 시맨틱, explore_slds_blueprints, 컴포넌트 결정 트리, 5단계 결정 트리, blueprint utility styling hook hardcoded, UI 코드 어떤 순서로 작성 | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - UI 코딩 가이드라인.md` |
| SLDS 2 Starter Kit 빌드 설정, lwc.config.json, lwcRuntimeFlags, ENABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE, gate shim, gateComboboxElementInternalsClosed, index.html 엔트리, loading.css reveal on ready, gitignore nvmrc, 스타터킷 런타임 플래그 진입 HTML 어떻게 설정 | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - 빌드 설정과 진입 HTML.md` |

> **lightning-* 개별 베이스 컴포넌트 레퍼런스**(`LWC/BaseComponents(베이스컴포넌트)/`)는 별도 샤드로 분할됨 → `_index/frontend-basecomponents.md` 참조.

## LWC Base Components (베이스 컴포넌트)

| 키워드 | 파일 |
|---|---|
| lightning-input, lightning-textarea, lightning-combobox, lightning-select, 입력 컴포넌트 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-button, lightning-button-icon, lightning-button-menu, lightning-button-group | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-card, lightning-layout, lightning-accordion, lightning-tabset, 레이아웃 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-datatable, lightning-tree-grid, 데이터 테이블, columns 정의, key-field | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-record-form, lightning-record-edit-form, lightning-record-view-form | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-icon, 아이콘 이름, utility standard action doctype custom | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-modal, LightningModal, 모달, lightning-modal-header body footer | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-spinner, lightning-badge, lightning-avatar, lightning-progress-bar | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-formatted-number, lightning-formatted-date-time, 포맷팅 컴포넌트 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-file-upload, 파일 업로드 컴포넌트, 첨부 파일 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-map, 지도, 위치 표시 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-breadcrumbs, lightning-vertical-navigation, 네비게이션 컴포넌트 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| ShowToastEvent, lightning-toast, 토스트 알림 컴포넌트 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-dual-listbox, lightning-radio-group, lightning-checkbox-group, 다중선택 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-rich-text, 리치텍스트 에디터, WYSIWYG | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning/stateManager, lightning/logger, lightning/platformShowToastEvent, 유틸리티 모듈 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| 베이스 컴포넌트 목록, 어떤 컴포넌트 쓸지, LWC 컴포넌트 종류 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |

---

