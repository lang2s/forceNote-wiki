---
tags: [index, search, navigation]
created: 2026-05-21
---

# SEARCH INDEX — 프론트엔드 (LWC / Aura / Flow)
> LWC·Aura·Flow·Base Components 키워드 → 파일
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.

## LWC — Apex 호출 / 데이터 로드

| 키워드 | 파일 |
|---|---|
| @wire, wire 어댑터, cacheable, 자동 데이터 로드, reactive property, $변수 | `LWC/ApexIntegration(Apex통합)/Wire 패턴.md` |
| wire vs imperative, 언제 wire, 언제 직접 호출 | `LWC/ApexIntegration(Apex통합)/Wire vs Imperative 선택.md` |
| imperative, async await, 버튼 클릭 호출, 직접 Apex 호출, isLoading | `LWC/ApexIntegration(Apex통합)/Imperative 호출 패턴.md` |

## LWC — 컴포넌트 통신 / 이벤트

| 키워드 | 파일 |
|---|---|
| CustomEvent, 자식→부모, dispatchEvent, detail, bubbles, composed, 이벤트 버블링 | `LWC/Events(이벤트)/CustomEvent 패턴.md` |
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
| lightning-record-form, record-edit-form, record-view-form, 레코드 폼 선택 | `LWC/LDS/Record Form 선택.md` |
| getRecord, getFieldValue, static schema, @salesforce/schema | `LWC/LDS/getRecord 패턴.md` |
| createRecord, updateRecord, deleteRecord, uiRecordApi, notifyRecordUpdateAvailable, 레코드 생성 수정 삭제, LWC에서 DML | `LWC/LDS/uiRecordApi.md` |
| reduceErrors, 에러 정규화, ldsUtils | `LWC/LDS/ldsUtils reduceErrors.md` |
| getPicklistValues, Picklist 옵션 로드, 동적 Picklist, 종속 Picklist, validFor, controllerValues, LWC에서 콤보박스 옵션 | `LWC/LDS/getPicklistValues 패턴.md` |

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
| LWR Sites, Experience Cloud LWR, Build Your Own Microsite 템플릿, lightningCommunity__Page Page_Layout Theme_Layout Default, --dxp 스타일링 훅, dxp-g-brand, Experience Builder LWC, 커뮤니티 사이트 컴포넌트, Remove SLDS | `LWC/UIPatterns(UI패턴)/LWR Sites (Experience Cloud).md` |

## LWC — 보안 / 모바일

| 키워드 | 파일 |
|---|---|
| LWC 보안, CSP 브라우저, 권한 기반 UI, userId | `LWC/Security(보안)/LWC 보안 패턴.md` |
| 모바일, getBarcodeScanner, 바코드, getLocationService, GPS, isAvailable | `LWC/Mobile(모바일)/모바일 기능 패턴.md` |

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
| Aura 이벤트, Component Event, Application Event, aura:registerEvent, aura:handler, $A.get, force:navigateToSObject, force:showToast, 시스템 이벤트 init change render | `Aura(오라)/Aura 이벤트.md` |
| Aura vs LWC, Aura 마이그레이션, Aura 비교, 언제 LWC 언제 Aura, Aura 레거시, LWC 우선 정책 | `Aura(오라)/Aura vs LWC.md` |

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
| quickChoice, Flow Screen 선택기, render() 멀티 템플릿, Custom Property Editor, 카드 라디오 드롭다운 Flow | `Flow/quickChoice Screen Component.md` |
| CalculateBusinessHours, 영업시간 계산, GetRandomValue, FormatStringListAsCsv, PostRichChatter, GenerateFlowLink, LaunchAutolaunchedFlow | `Flow/Flow 유틸리티 액션 모음.md` |
| Flow 이름 규칙, Flow 네이밍, API 이름 접두어, Get_ Update_ Insert_ APEX_ SUB_ SC01_, Flow 요소 이름, 이벤트 약어 BI BU AI AU BD | `Flow/Flow 네이밍 컨벤션.md` |
| Flow 에러 처리, faultConnector, FaultMessage, Flow fault, Flow 오류 화면, Flow 에러 이메일, 에러 로그 레코드 | `Flow/Flow 에러 처리.md` |
| Flow 베스트 프랙티스, Fast Field Update, Flow 바이패스, 하드코딩 ID 금지, Flow 거버너, Mixed DML, Asynchronous Path, Flow 서킷 브레이커, Entry Criteria, Flow Trigger Explorer | `Flow/Flow 설계 베스트 프랙티스.md` |

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

## LWC Base Components 상세 레퍼런스 (개별 페이지)

| 키워드 | 파일 |
|---|---|
| lightning-accordion 아코디언, sectiontoggle, allow-multiple-sections-open, 접고 펼치기, active-section-name | `LWC/BaseComponents(베이스컴포넌트)/lightning-accordion.md` |
| lightning-tabset, 탭 컨테이너, 탭셋, ontabchange, active-tab-value, variant default scoped vertical, lightning-tab | `LWC/BaseComponents(베이스컴포넌트)/lightning-tabset.md` |
| lightning-input, 입력 필드 type, text number date email checkbox toggle file search, 유효성 검사, change commit 이벤트 | `LWC/BaseComponents(베이스컴포넌트)/lightning-input.md` |
| lightning-combobox, 드롭다운 단일 선택, options 배열, label value, Picklist 드롭다운 | `LWC/BaseComponents(베이스컴포넌트)/lightning-combobox.md` |
| lightning-datatable 상세, columns type, 인라인 편집 onsave draftValues, 행 선택 rowselection, 행 액션 rowaction, 정렬 onsort, 커스텀 타입 customTypes | `LWC/BaseComponents(베이스컴포넌트)/lightning-datatable.md` |
| lightning-modal 상세, LightningModal extends, open size, close 반환값, LightningAlert LightningConfirm LightningPrompt | `LWC/BaseComponents(베이스컴포넌트)/lightning-modal.md` |
| lightning-record-form 상세, lightning-record-edit-form, lightning-record-view-form, lightning-input-field, lightning-output-field, onsubmit onsuccess onerror | `LWC/BaseComponents(베이스컴포넌트)/lightning-record-form.md` |
| lightning-record-picker 상세, filter criteria, clearSelection, displayInfo matchingInfo, 다중 선택 pills, dynamic target | `LWC/BaseComponents(베이스컴포넌트)/lightning-record-picker.md` |
| lightning-button 상세, variant brand destructive inverse, button-icon, button-menu, menu-item, button-stateful, onselect | `LWC/BaseComponents(베이스컴포넌트)/lightning-button.md` |
| lightning-card 상세, title icon-name, actions 슬롯, footer 슬롯, variant narrow | `LWC/BaseComponents(베이스컴포넌트)/lightning-card.md` |
| lightning-spinner 상세, isLoading 패턴, alternative-text, size variant, try finally, 오버레이 스피너 | `LWC/BaseComponents(베이스컴포넌트)/lightning-spinner.md` |
| lightning-avatar, Avatar, 아바타, 사용자/객체를 나타내는 원형/사각 이미지. | `LWC/BaseComponents(베이스컴포넌트)/lightning-avatar.md` |
| lightning-badge, Badge, 배지, 상태/카운트를 나타내는 작은 라벨. | `LWC/BaseComponents(베이스컴포넌트)/lightning-badge.md` |
| lightning-breadcrumb, Breadcrumb, 빵부스러기 항목, 빵부스러기 경로의 개별 항목. | `LWC/BaseComponents(베이스컴포넌트)/lightning-breadcrumb.md` |
| lightning-breadcrumbs, Breadcrumbs, 빵부스러기 내비, 현재 위치 경로를 보여주는 빵부스러기 내비. | `LWC/BaseComponents(베이스컴포넌트)/lightning-breadcrumbs.md` |
| lightning-carousel, Carousel, 캐러셀, 이미지를 슬라이드로 넘겨 보는 캐러셀. | `LWC/BaseComponents(베이스컴포넌트)/lightning-carousel.md` |
| lightning-carousel-image, Carousel Image, 캐러셀 이미지, 캐러셀 안의 개별 이미지. | `LWC/BaseComponents(베이스컴포넌트)/lightning-carousel-image.md` |
| lightning-checkbox-group, Checkbox Group, 체크박스 그룹, 여러 개를 선택할 수 있는 체크박스 묶음. | `LWC/BaseComponents(베이스컴포넌트)/lightning-checkbox-group.md` |
| lightning-click-to-dial, Click To Dial, 클릭 투 다이얼, 클릭하면 전화 발신되는 전화번호 링크(Open CTI). | `LWC/BaseComponents(베이스컴포넌트)/lightning-click-to-dial.md` |
| lightning-dual-listbox, Dual Listbox, 이중 리스트박스, 좌→우로 항목을 옮겨 선택하는 이중 리스트. | `LWC/BaseComponents(베이스컴포넌트)/lightning-dual-listbox.md` |
| lightning-dynamic-icon, Dynamic Icon, 동적 아이콘, 애니메이션이 있는 동적 아이콘(예: strength, scoreboard). | `LWC/BaseComponents(베이스컴포넌트)/lightning-dynamic-icon.md` |
| lightning-empty-state, Empty State (Beta), 빈 상태, 데이터가 없을 때 보여주는 빈 상태 화면. | `LWC/BaseComponents(베이스컴포넌트)/lightning-empty-state.md` |
| lightning-file-upload, File Upload, 파일 업로드, 레코드에 파일을 업로드. | `LWC/BaseComponents(베이스컴포넌트)/lightning-file-upload.md` |
| lightning-flow, Flow, 플로우 실행, Salesforce Flow를 컴포넌트 안에서 실행. | `LWC/BaseComponents(베이스컴포넌트)/lightning-flow.md` |
| lightning-formatted-address, Formatted Address, 주소 표시, 주소를 형식에 맞게 표시(지도 링크 옵션). | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-address.md` |
| lightning-formatted-date-time, Formatted Date Time, 날짜시간 표시, 날짜/시간을 로케일 형식으로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-date-time.md` |
| lightning-formatted-email, Formatted Email, 이메일 표시, 이메일을 mailto 링크로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-email.md` |
| lightning-formatted-location, Formatted Location, 위치 표시, 위도/경도 좌표를 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-location.md` |
| lightning-formatted-name, Formatted Name, 이름 표시, 이름을 로케일 순서로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-name.md` |
| lightning-formatted-number, Formatted Number, 숫자/통화 표시, 숫자/통화/백분율을 로케일 형식으로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-number.md` |
| lightning-formatted-phone, Formatted Phone, 전화 표시, 전화번호를 tel 링크로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-phone.md` |
| lightning-formatted-rich-text, Formatted Rich Text, 리치텍스트 표시, HTML 서식 텍스트를 안전하게 렌더링. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-rich-text.md` |
| lightning-formatted-text, Formatted Text, 텍스트 표시, URL/이메일/전화를 자동 링크화해 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-text.md` |
| lightning-formatted-time, Formatted Time, 시간 표시, 시간을 로케일 형식으로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-time.md` |
| lightning-formatted-url, Formatted URL, URL 표시, URL을 하이퍼링크로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-formatted-url.md` |
| lightning-helptext, Helptext, 도움말 툴팁, 물음표 아이콘에 마우스를 올리면 뜨는 도움말 툴팁. | `LWC/BaseComponents(베이스컴포넌트)/lightning-helptext.md` |
| lightning-icon, Icon, 아이콘, SLDS 아이콘을 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-icon.md` |
| lightning-illustration, Illustration (Beta), 일러스트, 빈 상태/오류 등을 위한 일러스트 + 메시지. | `LWC/BaseComponents(베이스컴포넌트)/lightning-illustration.md` |
| lightning-input-rich-text, Input Rich Text, 리치 텍스트 에디터, 서식 있는 텍스트(리치 텍스트) 편집기. | `LWC/BaseComponents(베이스컴포넌트)/lightning-input-rich-text.md` |
| lightning-layout, Layout, 레이아웃, 행/열 기반 반응형 레이아웃 컨테이너(flex). | `LWC/BaseComponents(베이스컴포넌트)/lightning-layout.md` |
| lightning-layout-item, Layout Item, 레이아웃 아이템, Layout 안의 개별 칸(크기/패딩 지정). | `LWC/BaseComponents(베이스컴포넌트)/lightning-layout-item.md` |
| lightning-map, Map, 지도, 지도에 마커를 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-map.md` |
| lightning-pill, Pill, 필 태그, 제거 가능한 라벨(태그) 칩. | `LWC/BaseComponents(베이스컴포넌트)/lightning-pill.md` |
| lightning-pill-container, Pill Container, 필 컨테이너, 여러 pill을 묶어서 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-pill-container.md` |
| lightning-platform-show-toast-event, Platform Show Toast Event, 토스트 이벤트, Aura/이벤트 방식으로 토스트를 띄우는 이벤트. | `LWC/BaseComponents(베이스컴포넌트)/lightning-platform-show-toast-event.md` |
| lightning-progress-bar, Progress Bar, 진행 막대, 수평 진행 막대. | `LWC/BaseComponents(베이스컴포넌트)/lightning-progress-bar.md` |
| lightning-progress-indicator, Progress Indicator, 진행 인디케이터, 여러 단계의 진행 상태(스텝). | `LWC/BaseComponents(베이스컴포넌트)/lightning-progress-indicator.md` |
| lightning-progress-ring, Progress Ring, 원형 진행, 원형 진행 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-progress-ring.md` |
| lightning-progress-step, Progress Step, 진행 단계, 진행 인디케이터 안의 개별 단계. | `LWC/BaseComponents(베이스컴포넌트)/lightning-progress-step.md` |
| lightning-quick-action-panel, Quick Action Panel, 빠른 작업 패널, 화면 액션(Screen Action)의 본문 패널. | `LWC/BaseComponents(베이스컴포넌트)/lightning-quick-action-panel.md` |
| lightning-radio-group, Radio Group, 라디오 그룹, 하나만 선택하는 라디오 버튼 묶음. | `LWC/BaseComponents(베이스컴포넌트)/lightning-radio-group.md` |
| lightning-relative-date-time, Relative Date Time, 상대 시간, '3분 전'처럼 상대 시간으로 표시. | `LWC/BaseComponents(베이스컴포넌트)/lightning-relative-date-time.md` |
| lightning-rich-text-toolbar-button, Rich Text Toolbar Button, 리치텍스트 툴바 버튼, 리치 텍스트 편집기에 추가하는 커스텀 툴바 버튼. | `LWC/BaseComponents(베이스컴포넌트)/lightning-rich-text-toolbar-button.md` |
| lightning-rich-text-toolbar-button-group, Rich Text Toolbar Button Group, 리치텍스트 툴바 그룹, 커스텀 툴바 버튼들의 그룹. | `LWC/BaseComponents(베이스컴포넌트)/lightning-rich-text-toolbar-button-group.md` |
| lightning-select, Select, 네이티브 셀렉트, 네이티브 HTML select 기반 드롭다운. | `LWC/BaseComponents(베이스컴포넌트)/lightning-select.md` |
| lightning-slider, Slider, 슬라이더, 범위 값을 드래그로 조절하는 슬라이더. | `LWC/BaseComponents(베이스컴포넌트)/lightning-slider.md` |
| lightning-textarea, Text Area, 텍스트영역, 여러 줄 텍스트 입력. | `LWC/BaseComponents(베이스컴포넌트)/lightning-textarea.md` |
| lightning-tile, Tile, 타일, 레코드 요약을 보여주는 타일. | `LWC/BaseComponents(베이스컴포넌트)/lightning-tile.md` |
| lightning-toast, Toast, 토스트, 화면 모서리에 잠깐 뜨는 알림(LWR 사이트용). | `LWC/BaseComponents(베이스컴포넌트)/lightning-toast.md` |
| lightning-toast-container, Toast Container, 토스트 컨테이너, 여러 토스트의 위치/스택을 관리하는 컨테이너(LWR). | `LWC/BaseComponents(베이스컴포넌트)/lightning-toast-container.md` |
| lightning-tree, Tree, 트리, 펼침/접힘이 되는 계층 트리. | `LWC/BaseComponents(베이스컴포넌트)/lightning-tree.md` |
| lightning-tree-grid, Tree Grid, 트리 그리드, 트리 + 표가 결합된 계층형 데이터 그리드. | `LWC/BaseComponents(베이스컴포넌트)/lightning-tree-grid.md` |
| lightning-vertical-navigation, Vertical Navigation, 세로 내비게이션, 세로 사이드 내비게이션 메뉴. | `LWC/BaseComponents(베이스컴포넌트)/lightning-vertical-navigation.md` |
| lightning-vertical-navigation-item, Vertical Navigation Item, 세로 내비 항목, 세로 내비의 개별 항목. | `LWC/BaseComponents(베이스컴포넌트)/lightning-vertical-navigation-item.md` |
| lightning-vertical-navigation-item-badge, Vertical Navigation Item Badge, 세로 내비 배지, 배지(숫자)가 붙는 세로 내비 항목. | `LWC/BaseComponents(베이스컴포넌트)/lightning-vertical-navigation-item-badge.md` |
| lightning-vertical-navigation-item-icon, Vertical Navigation Item Icon, 세로 내비 아이콘, 아이콘이 붙는 세로 내비 항목. | `LWC/BaseComponents(베이스컴포넌트)/lightning-vertical-navigation-item-icon.md` |

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

