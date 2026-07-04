---
tags: [lwc, moc, index]
created: 2026-05-17
---

# LWC — Map of Content

> 출처: [lwc-recipes](https://github.com/trailheadapps/lwc-recipes) (Salesforce 공식 학습 앱) 133개 컴포넌트 분석

---

## 🚀 개요 / 시작 (Get Started)

- [[LWC 개요 (Get Started)]] — LWC란 무엇인가·base components·표준 웹 기술(W3C/TC39)·Aura 상호운용·시작 경로 (LWC 섹션 개념 진입점)

---

## 📑 Reference (레퍼런스)

> LWC Dev Guide Reference 섹션 갭을 채우는 전수 레퍼런스. 전체 색인: [[LWC/Reference(레퍼런스)/index|Reference(레퍼런스) 색인]]

- [[HTML 템플릿 Directives 레퍼런스]] — HTML 템플릿 directive 전수(lwc:if/elseif/else·for:each/item/index·iterator·key·slot·lwc:ref/dom/spread/on/is) + 위치별 지원 매트릭스
- [[@salesforce Modules 레퍼런스]] — `@salesforce/*` 스코프드 모듈 전수(apex·schema·label·resourceUrl·contentAssetUrl·user·userPermission·customPermission·client/formFactor·community·site·messageChannel) + getSObjectValue·refreshApex
- [[XML Config File Elements (js-meta.xml) 레퍼런스]] — 컴포넌트 설정 파일 `*.js-meta.xml` 요소 전수(targets·capability·isExposed·apiVersion·targetConfig·lightning__ 타깃) — 컴포넌트 노출 위치 정의
- [[PageReference Types 레퍼런스]] — NavigationMixin PageReference 타입 전수(standard__recordPage·objectPage·navItemPage·component·webPage·flow·quickAction·comm__namedPage) — 페이지 이동 대상 정의

---

## 🏗️ Create Components (컴포넌트 작성)

> LWC Dev Guide **Create Components** 섹션 기초 갭 노트. 전체 색인: [[LWC/CreateComponents(컴포넌트작성)/index|CreateComponents(컴포넌트작성) 색인]]

- [[Lifecycle Hooks]] — 라이프사이클 훅 전수(constructor·connectedCallback·disconnectedCallback·renderedCallback·errorCallback) + hasRendered·isConnected·error boundary
- [[CSS 스타일시트와 스코핑]] — LWC CSS 스타일시트·scoped CSS·shadow DOM 스코핑·`:host` 셀렉터·static stylesheets·cascade/specificity/inheritance·미지원(`::part`/`:host-context`)

---

## ⚡ Apex 통합

- [[Wire vs Imperative 선택]] — @wire(property/function) vs async/await 결정 매트릭스
- [[Wire 패턴]] — property 바인딩, function 바인딩, reactive property ($변수)
- [[Imperative 호출 패턴]] — async/await, try/catch/finally, isLoading 패턴

## 🧩 컴포넌트 API & 컴포지션

- [[@api 패턴]] — property, method, getter/setter, lwc:spread
- [[컴포지션 패턴]] — Container vs Presentational, for:each, lwc:if/lwc:elseif/lwc:else
- [[LWC API 버전 관리]] — .js-meta.xml apiVersion 규칙, 버전별 기능, 동적 임포트

## 📡 이벤트 & 통신

- [[CustomEvent 패턴]] — detail 전달, bubbles, composed, 이벤트 위임
- [[Lightning Message Service]] — publish/subscribe, MessageContext, pubsub 대체
- [[상태 관리]] — @lwc/state, setter 기반 reactive, 단방향 데이터 흐름

## 🗃 LDS & 레코드 폼

- [[UI API 개요]] — UI API REST 엔드포인트 전체 + wire 어댑터 매핑 (v67.0 Summer '26)
- [[UI API 리소스 레퍼런스]] — Ch3-5 요청/응답 스키마 전수 (개요의 레퍼런스 spoke)
- [[Record Form 선택]] — lightning-record-form vs edit-form vs view-form 결정
- [[uiRecordApi]] — createRecord, updateRecord, deleteRecord, notifyRecordUpdateAvailable
- [[getRecord 패턴]] — static import, dynamic string, getFieldValue, getRecords
- [[ldsUtils reduceErrors]] — 에러 정규화 유틸리티
- [[getPicklistValues 패턴]] — Record Type별 Picklist 옵션 로드, 종속 Picklist validFor 필터링

## 📚 Base Components 상세 레퍼런스

> 각 컴포넌트의 속성·이벤트·코드 예시·접근성·사용 고려사항이 담긴 상세 페이지.

- [[lightning-accordion]] — 접고 펼치는 아코디언, sectiontoggle 이벤트, 다중 열기
- [[lightning-tabset]] — 탭 컨테이너, ontabchange 이벤트, variant(default/scoped/vertical)
- [[lightning-input]] — 14가지 type 변형, 유효성 검사, change·commit 이벤트
- [[lightning-combobox]] — 단일 선택 드롭다운, options 배열, Picklist 연동
- [[lightning-datatable]] — 정렬·인라인 편집·행 액션·커스텀 타입, columns 전체 type 목록
- [[lightning-modal]] — LightningModal 상속, open/close, LightningAlert·Confirm·Prompt
- [[lightning-record-form]] — record-form·record-edit-form·record-view-form 3종
- [[lightning-record-picker]] — 레코드 검색 선택, filter, 다중 선택 패턴, dynamic target
- [[lightning-button]] — button·button-icon·button-menu·button-group·stateful 패밀리
- [[lightning-button-icon]] — 아이콘만 있는 버튼, alternative-text 필수
- [[lightning-button-group]] — 연관 버튼을 한 묶음으로 붙여 표시하는 컨테이너
- [[lightning-button-stateful]] — 선택/비선택에 따라 라벨·아이콘이 바뀌는 버튼(팔로우/팔로잉)
- [[lightning-button-icon-stateful]] — 눌림(선택) 상태를 토글하는 아이콘 버튼(좋아요)
- [[lightning-button-menu]] — 드롭다운 메뉴 버튼 + menu-item·menu-divider·menu-subheader
- [[lightning-tab]] — tabset 안의 개별 탭, label·value·icon-name
- [[lightning-accordion-section]] — 아코디언 안의 개별 섹션, actions 슬롯
- [[lightning-input-field]] — edit form 안에서 객체 필드 하나를 편집
- [[lightning-output-field]] — view form 안에서 객체 필드 하나를 읽기 전용 표시
- [[lightning-record-edit-form]] — 레코드 생성·편집 폼, input-field 자식 배치
- [[lightning-record-view-form]] — 레코드 읽기 전용 폼, output-field 자식 배치
- [[lightning-alert]] — LightningAlert.open() 정적 메서드 호출형 알림 모달(OK)
- [[lightning-confirm]] — LightningConfirm.open() 확인/취소 모달, boolean 반환
- [[lightning-prompt]] — LightningPrompt.open() 입력 프롬프트 모달, 문자열 반환
- [[lightning-card]] — 카드 컨테이너, actions·footer 슬롯
- [[lightning-spinner]] — isLoading 패턴, try/finally, 인라인·오버레이
- [[lightning-avatar]] — 사용자/객체를 나타내는 원형/사각 이미지.
- [[lightning-badge]] — 상태/카운트를 나타내는 작은 라벨.
- [[lightning-breadcrumb]] — 빵부스러기 경로의 개별 항목.
- [[lightning-breadcrumbs]] — 현재 위치 경로를 보여주는 빵부스러기 내비.
- [[lightning-carousel]] — 이미지를 슬라이드로 넘겨 보는 캐러셀.
- [[lightning-carousel-image]] — 캐러셀 안의 개별 이미지.
- [[lightning-checkbox-group]] — 여러 개를 선택할 수 있는 체크박스 묶음.
- [[lightning-click-to-dial]] — 클릭하면 전화 발신되는 전화번호 링크(Open CTI).
- [[lightning-dual-listbox]] — 좌→우로 항목을 옮겨 선택하는 이중 리스트.
- [[lightning-dynamic-icon]] — 애니메이션이 있는 동적 아이콘(예: strength, scoreboard).
- [[lightning-empty-state]] — 데이터가 없을 때 보여주는 빈 상태 화면.
- [[lightning-file-upload]] — 레코드에 파일을 업로드.
- [[lightning-flow]] — Salesforce Flow를 컴포넌트 안에서 실행.
- [[lightning-formatted-address]] — 주소를 형식에 맞게 표시(지도 링크 옵션).
- [[lightning-formatted-date-time]] — 날짜/시간을 로케일 형식으로 표시.
- [[lightning-formatted-email]] — 이메일을 mailto 링크로 표시.
- [[lightning-formatted-location]] — 위도/경도 좌표를 표시.
- [[lightning-formatted-name]] — 이름을 로케일 순서로 표시.
- [[lightning-formatted-number]] — 숫자/통화/백분율을 로케일 형식으로 표시.
- [[lightning-formatted-phone]] — 전화번호를 tel 링크로 표시.
- [[lightning-formatted-rich-text]] — HTML 서식 텍스트를 안전하게 렌더링.
- [[lightning-formatted-text]] — URL/이메일/전화를 자동 링크화해 표시.
- [[lightning-formatted-time]] — 시간을 로케일 형식으로 표시.
- [[lightning-formatted-url]] — URL을 하이퍼링크로 표시.
- [[lightning-helptext]] — 물음표 아이콘에 마우스를 올리면 뜨는 도움말 툴팁.
- [[lightning-icon]] — SLDS 아이콘을 표시.
- [[lightning-illustration]] — 빈 상태/오류 등을 위한 일러스트 + 메시지.
- [[lightning-input-rich-text]] — 서식 있는 텍스트(리치 텍스트) 편집기.
- [[lightning-layout]] — 행/열 기반 반응형 레이아웃 컨테이너(flex).
- [[lightning-layout-item]] — Layout 안의 개별 칸(크기/패딩 지정).
- [[lightning-map]] — 지도에 마커를 표시.
- [[lightning-pill]] — 제거 가능한 라벨(태그) 칩.
- [[lightning-pill-container]] — 여러 pill을 묶어서 표시.
- [[lightning-platform-show-toast-event]] — Aura/이벤트 방식으로 토스트를 띄우는 이벤트.
- [[lightning-progress-bar]] — 수평 진행 막대.
- [[lightning-progress-indicator]] — 여러 단계의 진행 상태(스텝).
- [[lightning-progress-ring]] — 원형 진행 표시.
- [[lightning-progress-step]] — 진행 인디케이터 안의 개별 단계.
- [[lightning-quick-action-panel]] — 화면 액션(Screen Action)의 본문 패널.
- [[lightning-radio-group]] — 하나만 선택하는 라디오 버튼 묶음.
- [[lightning-relative-date-time]] — '3분 전'처럼 상대 시간으로 표시.
- [[lightning-rich-text-toolbar-button]] — 리치 텍스트 편집기에 추가하는 커스텀 툴바 버튼.
- [[lightning-rich-text-toolbar-button-group]] — 커스텀 툴바 버튼들의 그룹.
- [[lightning-select]] — 네이티브 HTML select 기반 드롭다운.
- [[lightning-slider]] — 범위 값을 드래그로 조절하는 슬라이더.
- [[lightning-textarea]] — 여러 줄 텍스트 입력.
- [[lightning-tile]] — 레코드 요약을 보여주는 타일.
- [[lightning-toast]] — 화면 모서리에 잠깐 뜨는 알림(LWR 사이트용).
- [[lightning-toast-container]] — 여러 토스트의 위치/스택을 관리하는 컨테이너(LWR).
- [[lightning-tree]] — 펼침/접힘이 되는 계층 트리.
- [[lightning-tree-grid]] — 트리 + 표가 결합된 계층형 데이터 그리드.
- [[lightning-vertical-navigation]] — 세로 사이드 내비게이션 메뉴.
- [[lightning-vertical-navigation-item]] — 세로 내비의 개별 항목.
- [[lightning-vertical-navigation-item-badge]] — 배지(숫자)가 붙는 세로 내비 항목.
- [[lightning-vertical-navigation-item-icon]] — 아이콘이 붙는 세로 내비 항목.

## 🧭 네비게이션 & UI

- [[Lightning Base Components 레퍼런스]] — lightning-* 전체 컴포넌트 목록 및 속성 빠른 참조
- [[NavigationMixin 패턴]] — pageReference 타입별 사용법
- [[Lightning Console JS API]] — 콘솔 워크스페이스 탭/서브탭·유틸리티 바(openTab/openSubtab, workspaceAPI)
- [[Toast & 모달 패턴]] — ShowToastEvent, variant, 모달 구현
- [[에러 패널 패턴]] — errorPanel, reduceErrors, 에러 타입별 처리
- [[공유 JS 모듈]] — c/ 네임스페이스 공유 함수, named export, isExposed: false
- [[CRM Analytics 대시보드용 LWC]] — analytics__Dashboard 타깃, step 쿼리 주입, hasStep, bindings
- [[LWR Sites (Experience Cloud)]] — Experience Cloud LWR 사이트, lightningCommunity__ 타깃, --dxp 브랜딩 훅
- [[LWR 다국어 사이트]] — 멀티링궐 LWR(언어 추가·fallback·자동감지·번역 export/import·제약)
- [[LWR Expressions 레퍼런스]] — LWR 표현식(Data Binding·Other Expressions·제약)
- [[LWR 동작·캐싱·제약]] — 퍼블리싱 모델·캐싱 TTL·커스텀 URL·head markup·Light DOM·LWR Template Limitations
- [[LWR 컴포넌트 개발 심화]] — js-meta.xml targets·targetConfigs·@salesforce 모듈·화면 크기 반응형·커스텀 레이아웃/내비게이션
- [[LWR --dxp 스타일링 훅 레퍼런스]] — LWR 브랜딩(--dxp-g/-s/-c 훅)·Theme 패널 속성 매핑·커스텀 폰트·Remove SLDS·컴포넌트 브랜딩 오버라이드
- [[LWR Tag Manager 데이터 관리]] — Experience/Google Tag Manager·experience_interaction 이벤트·Tag Manager Event Reference·Consent·Website Engagement DMO → Data Cloud

## 🎨 SLDS 디자인 시스템

> 전체 색인: [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]] · 개념·LWC 적용: [[SLDS LWC 디자인 시스템]]

- [[SLDS 유틸리티 클래스 레퍼런스]] — 마진·패딩·그리드·타이포 등 24개 카테고리 전수 + HTML 예제
- [[SLDS 스타일링 훅]] — `--slds-g-*`/`--slds-c-*` CSS 커스텀 속성, 테마·다크모드
- [[SLDS 접근성]] — 색 대비·포커스·키보드·모바일 9원칙
- [[SLDS 모범 사례]] — SLDS 1 vs 2, 3단계 커스터마이즈 모델
- [[SLDS 개발 도구]] — Figma Kit, SLDS Linter/Validator
- [[SLDS 블루프린트 카탈로그]] — CSS 전용 블루프린트 30종 인덱스
- **디자인 패턴 21종** (data-entry·search·navigation·charts 등) → [[SLDS(디자인시스템)/index|SLDS(디자인시스템) 색인]]

### SLDS 2 Starter Kit (로컬 프로토타이핑)

> design-system-2-starter-kit (GitHub, Tier 2) — LWC + Vite 로컬 프로토타이핑 스캐폴드

- [[SLDS 2 Starter Kit - 개요와 프로젝트 구조]] — 클러스터 허브: 프로젝트 구조·네임스페이스(shell/page/ui/data)·기술 스택·vite·엔트리 플로우
- [[SLDS 2 Starter Kit - 라우팅과 멀티앱 셸]] — 클라이언트 라우터·routes/apps.config·Standard/Console/Builder 앱·History API SPA
- [[SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM]] — slds-loader lazy CSS·테마/다크모드 전환·synthetic vs native shadow
- [[SLDS 2 Starter Kit - 아이콘·모달·폼·배포]] — 아이콘 prebuild·LightningModal·Base Component 폼·GitHub Pages 배포·agent skills
- [[SLDS 2 Starter Kit - 셸 UI 컴포넌트]] — 글로벌 헤더·내비(App Launcher/Console switcher/Standard tabs)·도킹 패널(ui-panel 4종)·재사용 블록·예제 페이지(contacts/builder/home)
- [[SLDS 2 Starter Kit - UI 코딩 가이드라인]] — `.builderrules` Salesforce UI Guidelines: UI 코드 5단계 결정 트리(LBC→blueprint→utility→styling hook→hardcoded)·스타일링 훅 시맨틱 사용
- [[SLDS 2 Starter Kit - 빌드 설정과 진입 HTML]] — lwc.config.json·lwcRuntimeFlags·게이트 심·index.html 엔트리·loading.css reveal-on-ready·.gitignore/.nvmrc

## 🔒 보안 & 권한

- [[LWC 보안 패턴]] — 권한 기반 UI, @api 노출 범위, userId, CSP

## 📱 모바일

- [[모바일 기능 패턴]] — getBarcodeScanner, getLocationService, isAvailable() 가드, mobile/browser fallback
- [[모바일 & 오프라인 (LWC)]] — mobileCapabilities 10종, LWC Offline·Offline GraphQL·Briefcase·draft records

## 📦 Static Resource & 파일

- [[Static Resource 로딩]] — loadScript/loadStyle, renderedCallback 3-state (NOT_LOADED/LOADING/READY)
- [[파일 업로드와 이미지 처리]] — processImage, FileReader→base64, refreshApex, ContentVersion URL

---

## 🔧 LWC 내부 구조 (Internals)

> 소스: `lwc-master/` (salesforce/lwc 오픈소스, Tier 1)

- [[LWC 오픈소스 아키텍처]] — 패키지 전체 구조, Compiler/Runtime/SSR 분리, static content optimization
- [[@api 데코레이터 내부 구조]] — `createPublicPropertyDescriptor`, vm.cmpProps, 반응성 연결
- [[@track 데코레이터 내부 구조]] — `internalTrackDecorator`, vm.cmpFields, observable-membrane reactive proxy
- [[LWC VM 내부 구조]] — VM 인터페이스 전체, VMState/RenderMode/ShadowMode enum, lifecycle 함수
- [[@wire 어댑터 내부 구조]] — WireAdapter 인터페이스, createConnector, configWatcher, legacy register()
- [[LWC Signals]] — Signal 인터페이스, SignalBaseClass, addTrustedSignal, setTrustedSignalSet
- [[LWC 런타임 Feature Flags]] — 13개 플래그 전체 목록, setFeatureFlag(), lwcRuntimeFlags 글로벌
- [[LWC 템플릿 컴파일러 파이프라인]] — compile() API, parse→codegen 2단계, RENDER_APIS, static content optimization
- [[LWC Shadow DOM 모드]] — Native/Synthetic/Light DOM 비교, shadowSupportMode, Shadow Migrate Mode

---

## 🧪 테스트

- [[Jest 테스트 패턴]] — @wire 어댑터 mock, DOM 이벤트 검증, @salesforce/apex mock 3종 패턴

---

## 빠른 의사결정

```
어떤 컴포넌트 쓸지?    → [[Lightning Base Components 레퍼런스]]
Apex 호출?             → [[Wire vs Imperative 선택]]
@wire 에러?            → [[Wire 패턴]] → function 바인딩
컴포넌트 통신?         → 부모↔자식: [[CustomEvent 패턴]] | 크로스 컴포넌트: [[Lightning Message Service]]
레코드 표시?           → [[Record Form 선택]] → lightning-record-form
레코드 수정?           → [[uiRecordApi]] → updateRecord 또는 [[Record Form 선택]]
상태 공유?             → [[상태 관리]] → @lwc/state
서드파티 라이브러리?   → [[Static Resource 로딩]] → loadScript/loadStyle
파일 업로드?           → [[파일 업로드와 이미지 처리]] → processImage
모바일 기기?           → [[모바일 기능 패턴]] → isAvailable() 먼저
LWC 컴포넌트 테스트?   → [[Jest 테스트 패턴]] → wire mock, DOM 이벤트, apex mock
```
