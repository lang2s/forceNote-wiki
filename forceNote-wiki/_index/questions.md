---
tags: [index, search, navigation]
created: 2026-05-21
---

# SEARCH INDEX — 자연어 질문
> "~하는 방법" 형태 자연어 질문 → 파일 (교차 도메인 라우팅 보조)
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.

## 자연어 질문 패턴 → 파일

| 질문 | 파일 |
|---|---|
| Apex에서 LWC로 데이터 보내는 방법 | `LWC/ApexIntegration(Apex통합)/Wire 패턴.md` |
| LWC를 로컬에서 Vite로 어떻게 띄우나 / 로컬 프로토타이핑 스캐폴드 / SLDS 2 Starter Kit 시작 | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - 개요와 프로젝트 구조.md` |
| 클라이언트 사이드 라우팅 어떻게 / 멀티앱 셸 / SPA History API 라우터 | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - 라우팅과 멀티앱 셸.md` |
| SLDS 1과 2를 어떻게 전환하나 / 테마 다크모드 전환 / synthetic vs native shadow | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - SLDS 1·2 로더와 Shadow DOM.md` |
| LWC 아이콘 프리빌드 어떻게 / LightningModal 띄우기 / GitHub Pages로 LWC 배포 | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - 아이콘·모달·폼·배포.md` |
| 스타터킷의 헤더·내비게이션·패널은 어떻게 만들어졌나 / 글로벌 헤더 App Launcher 도킹 패널 구현 / 콘솔 object switcher | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - 셸 UI 컴포넌트.md` |
| SLDS 2 UI 코드 어떤 순서로 작성하나 / .builderrules 규칙 / 언제 base component 언제 blueprint 쓰나 / 스타일링 훅 시맨틱하게 쓰는 법 | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - UI 코딩 가이드라인.md` |
| 스타터킷 lwc.config.json·런타임 플래그 어떻게 설정하나 / index.html 진입점 / 로딩 끝나면 보여주는 reveal-on-ready | `LWC/SLDS(디자인시스템)/SLDS 2 Starter Kit - 빌드 설정과 진입 HTML.md` |
| gh로 깃허브 저장소 만들고 배포하는 법 / repo-setup·first-time-deploy 스킬 / GitHub Pages에 LWC 사이트 올리는 법 / gh-pages 브랜치 | `AgentSkills(에이전트스킬)/SLDS 2 Starter Kit - 저장소 설정과 배포 스킬.md` |
| 자식 컴포넌트에서 부모로 데이터 전달 | `LWC/Events(이벤트)/CustomEvent 패턴.md` |
| 관계없는 컴포넌트끼리 통신 | `LWC/Events(이벤트)/Lightning Message Service.md` |
| 다른 LWC의 함수 호출 | `LWC/ComponentAPI(컴포넌트API)/@api 패턴.md` + `LWC/Events(이벤트)/Lightning Message Service.md` |
| 외부 API 호출하는 방법 | `Apex/Integration(통합)/RestClient 패턴.md` + `Integration(통합)/Named Credential.md` |
| 외부에서 Salesforce API 호출 | `Apex/Integration(통합)/Custom REST Endpoint.md` |
| Trigger에서 HTTP 호출 | `Integration(통합)/Queueable + Callout 패턴.md` |
| 레코드 저장/수정/삭제 LWC에서 | `LWC/LDS/uiRecordApi.md` |
| LWC slot으로 부모 마크업 전달 / named slot·scoped slot 쓰는 법 | `LWC/CreateComponents(컴포넌트작성)/LWC Slots (기본·named·scoped).md` |
| LWC 언제 재렌더되나 / @track 이제 필요없나 / 배열 push 했는데 화면 안 바뀜 | `LWC/CreateComponents(컴포넌트작성)/LWC 리액티비티 (반응형 필드·재렌더 트리거).md` |
| LWC 단위 테스트 설정 어떻게 / @wire 목킹 어떻게 / Jest 설치 실행 | `LWC/Testing(테스트)/sfdx-lwc-jest 설정·실행.md` + `LWC/Testing(테스트)/Jest 테스트 패턴.md` |
| 리스트뷰/관련리스트를 wire로 조회 / Apex 없이 list view 레코드 가져오기 | `LWC/LDS/getListUi·관련리스트 wire 패턴.md` |
| LWS 켜기 / Locker에서 LWS로 마이그레이션 / 클라이언트 보안 롤백 | `LWC/Security(보안)/LWS 활성화·Locker 마이그레이션 절차.md` |
| SLDS 스타일링 훅 토큰 값 어디서 봐 / 다크모드·밀도 대응 / --slds-g-* 스케일 | `LWC/SLDS(디자인시스템)/SLDS 글로벌 스타일링 훅 토큰 레퍼런스.md` + `LWC/SLDS(디자인시스템)/SLDS 2 테마·다크모드·밀도.md` |
| 대용량 데이터 처리 | `Apex/Async(비동기)/Batch Apex.md` |
| 테스트에서 HTTP 호출 모킹 | `Apex/Testing(테스트)/HttpCalloutMock.md` |
| Flow에서 Apex 쓰는 방법 | `Flow/@InvocableMethod 패턴.md` |
| Apex에서 Flow 실행하는 방법 | `Flow/Flow Interview API.md` |
| Apex에서 이메일 보내는 방법 | `Apex/Messaging(메시징)/SingleEmailMessage.md` |
| 사용자에게 알림 보내는 방법 Apex | `Apex/Messaging(메시징)/CustomNotification.md` |
| 승인 프로세스 Apex로 제어 | `Architecture(아키텍처)/Approval Namespace.md` |
| 레코드 기본 표시 범위 어떻게 좁히나 / 공유 안 줄이고 보이는 레코드만 필터 / Scoping Rule 만드는 방법 / RestrictionRule | `Architecture(아키텍처)/Scoping Rules.md` |
| API 콜 한도 얼마야 / 일일 API 콜 제한 / 동시 API 호출 제한 / Bulk API 배치 한도 / Metadata API 한도 / VF view state 한도 / org 한도 어디서 봐 | `Architecture(아키텍처)/Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF).md` |
| CDC 트리거 변경 필드 확인 | `Apex/PlatformEvents(플랫폼이벤트)/ChangeEventHeader.md` |
| CDC 커스텀 채널을 Tooling API로 만드는 객체 / 커스텀 플랫폼 이벤트 채널을 SOQL로 조회 / 플랫폼 이벤트 트리거 배치 크기·실행 사용자를 설정하는 Tooling 객체 / Amazon EventBridge 이벤트 릴레이를 Tooling API로 설정 | `DevOps(데브옵스)/ToolingAPI(툴링API)/Tooling API 객체 — User·플랫폼이벤트 (이벤트·CDC 채널).md` |
| Einstein 예측 정의를 Tooling API로 조회하는 객체 / 머신러닝 모델 정의를 SOQL로 조회 / Agentforce 액션·플래너 메타데이터를 Tooling API로 조회 / 예측 유형(ForecastingType)을 프로그래밍으로 구성 / 기회 분할 유형을 Tooling API로 조회 / 추천 전략(RecommendationStrategy)을 SOQL로 조회 | `DevOps(데브옵스)/ToolingAPI(툴링API)/Tooling API 객체 — 세일즈·예측·AI (포캐스팅·머신러닝·Einstein·Agentforce).md` |
| DML 결과 에러 처리 방법 | `Apex/Data(데이터)/Database Namespace 상세.md` |
| 리드 전환 Apex | `Apex/Data(데이터)/Database Namespace 상세.md` |
| SOSL 검색 결과 Apex에서 | `Apex/Data(데이터)/Search Namespace.md` |
| 오브젝트 메타데이터 필드 목록 조회 | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| 레코드 타입 ID 코드에서 조회 | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| 피클리스트 값 Apex에서 가져오기 | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| 시스템 간 이벤트 연동 | `Integration(통합)/Platform Event 통합 패턴.md` |
| Connected App 대신 뭘 써야 하나 / ECA vs Connected App 차이 / Spring 26 새 Connected App 못 만든다 | `Integration(통합)/External Client App (외부 클라이언트 앱).md` |
| Named Credential 만들 때 뭘 입력하나 / External Credential 필드 전부 / Authentication Protocol 종류 / OAuth Flow Type 뭐 고르나 | `Integration(통합)/Named Credential·External Credential 생성 필드 전수 레퍼런스.md` |
| 서버간 통합 어떻게 세워 / JWT Bearer랑 Client Credentials 중 뭘 / 사용자 로그인 없이 API 인증 | `Integration(통합)/서버간 통합 구축 가이드 - External Client App·JWT Bearer·Client Credentials.md` |
| 레코드 삭제 LWC에서 | `LWC/LDS/uiRecordApi.md` |
| 정렬 Apex에서 | `Apex/Collections(컬렉션)/Comparator 인터페이스.md` |
| 스케줄 자동 실행 Apex | `Apex/Async(비동기)/Scheduled Apex.md` |
| 로그 남기는 방법 | `Apex/Logging(로깅)/Log 싱글턴 패턴.md` |
| Apex 디버깅 방법 / 디버그 로그 카테고리·레벨 설정 / System.debug 로그 보기 | `Apex/Logging(로깅)/Apex Debug Log.md` |
| Tooling API로 디버그 로그 어떻게 켜? / API로 trace flag 생성·로그 레벨 설정 / 프로그래밍 방식 로그 활성화 | `Apex/Logging(로깅)/Tooling API 디버그·로그·리플레이 sObject.md` |
| 리플레이 디버거 체크포인트 sObject가 뭐야? / 힙 덤프 캡처 / overlay action·result | `Apex/Logging(로깅)/Tooling API 디버그·로그·리플레이 sObject.md` |
| Aura/LWC 컴포넌트 소스를 Tooling API로 가져오는 객체? / AuraDefinition·LightningComponentBundle SOQL 조회 / Aura·LWC 번들 프로그래밍 방식 배포 / DefType·Lightning Out | `DevOps(데브옵스)/ToolingAPI(툴링API)/Tooling API 객체 — Lightning (Aura·LWC 번들).md` |
| 익명 Apex 실행 방법 / execute anonymous / 코드 한 번만 실행 / sf apex run | `Apex/ExecutionContext(실행컨텍스트)/Anonymous Apex 실행.md` |
| webservice 키워드 사용법 / Apex를 SOAP 웹서비스로 노출 / WSDL 생성 | `Apex/Integration(통합)/SOAP Web Services 노출 (webservice 키워드).md` |
| ApexDoc 작성법 / Apex 주석 문서화 / @param @return 태그 사용법 | `Apex/ApexDoc 주석 작성 가이드.md` |
| 레코드를 필드 값 기준으로 동적 공유 / Apex로 특정 레코드 공유 부여 / OWD Private에서 프로그래매틱 공유 | `Apex/Security(보안)/Apex Managed Sharing (프로그래매틱 공유).md` |
| with sharing과 without sharing 차이 / inherited sharing / sharing 선언 안 하면 기본값 뭐야 | `Apex/Security(보안)/Sharing 키워드 (with·without·inherited sharing).md` |
| 실행 컨텍스트란 뭐야 / static 변수 언제 리셋되나 / 무엇이 한 트랜잭션인가 / 트랜잭션 경계 | `Apex/ExecutionContext(실행컨텍스트)/실행 컨텍스트와 트랜잭션.md` |
| 테스트 데이터 어떻게 만드나 / 테스트 데이터 팩토리 패턴 / @TestSetup·Test.loadData | `Apex/Testing(테스트)/Test Data Factory 패턴.md` |
| 다른 사용자로 테스트 실행 / runAs로 권한·공유 검증 / 테스트 사용자 컨텍스트 | `Apex/Testing(테스트)/System.runAs (테스트 실행 컨텍스트).md` |
| 배포 커버리지 75% 규칙 / 코드 커버리지 확인 / 트리거 커버리지 요건 | `Apex/Testing(테스트)/코드 커버리지 규칙.md` |
| Queueable가 실패해도 실행되는 훅 / Transaction Finalizer / 비동기 잡 사후 복구·재시도 | `Apex/Async(비동기)/Transaction Finalizer.md` |
| String 메서드 뭐 있나 / isBlank·escapeSingleQuotes·format·join 사용법 | `Apex/Collections(컬렉션)/String 메서드 전수 레퍼런스.md` |
| Date·Datetime·Math 메서드 뭐 있나 / addDays·daysBetween·formatGmt / GMT vs 로컬 시간 | `Apex/Collections(컬렉션)/Date·Datetime·Math 메서드 전수 레퍼런스.md` |
| 캐시 사용하는 방법 | `Apex/PlatformCache(플랫폼캐시)/Platform Cache.md` |
| 공유 규칙 보안 적용 | `Apex/Security(보안)/Safely.md` |
| 데이터 조회 쿼리 | `Apex/SOQL(SOQL)/SOQL 패턴.md` |
| 여러 오브젝트에서 키워드 검색 | `Apex/SOQL(SOQL)/SOSL 패턴.md` |
| Aura 컴포넌트 만드는 방법 | `Aura(오라)/Aura 컴포넌트 구조.md` |
| Aura에서 LWC로 전환하는 방법 | `Aura(오라)/Aura vs LWC.md` |
| Salesforce 처음 사용법 | `Architecture(아키텍처)/Salesforce 플랫폼 개요.md` |
| Salesforce 로그인 MFA 설정 | `Admin(어드민)/LoginSecurity(로그인·세션보안)/Salesforce ID 인증.md` |
| 앱 런처 사용 방법 | `Admin(어드민)/OrgSetup(조직설정)/Salesforce 네비게이션.md` |
| Apex에서 Custom Metadata 레코드 만들기 | `Apex/Integration(통합)/Metadata Namespace.md` |
| DX 프로젝트 시작하는 방법 | `DevOps(데브옵스)/DX(DX개발환경)/Salesforce DX 개요.md` |
| Scratch Org 만드는 방법 | `DevOps(데브옵스)/DX(DX개발환경)/Scratch Org 패턴.md` |
| Jenkins로 Salesforce CI 구성 | `DevOps(데브옵스)/Deploy(배포·CICD)/CI CD 패턴.md` |
| 패키지 만들고 설치하는 방법 | `DevOps(데브옵스)/Packaging2GP(2세대패키징)/Unlocked Package 패턴.md` |
| DevOps Center를 scratch org에서 어떻게 켜나 / DevOpsCenter feature 활성화 | `Architecture(아키텍처)/DevOps Center.md` |
| DevOps Center 메타데이터 설정 / DevHubSettings enableDevOpsCenterGA | `Architecture(아키텍처)/DevOps Center.md` |
| DevOps Center Beta vs GA 차이 / next-generation AI-powered DevOps Center | `Architecture(아키텍처)/DevOps Center.md` |
| 워크플로우 룰을 Flow로 마이그레이션하는 Tooling 객체 / ProcessFlowMigration / Tooling API로 Flow·워크플로우·검증규칙 조회 | `DevOps(데브옵스)/ToolingAPI(툴링API)/Tooling API 객체 — 자동화 (Flow·Workflow·룰).md` |
| Sandbox를 Tooling API로 생성/새로고침하는 객체 / SandboxInfo·SandboxProcess / 메타데이터 배포 상태·소스 추적·릴리즈 업데이트·My Domain을 Tooling API로 조회 | `DevOps(데브옵스)/ToolingAPI(툴링API)/Tooling API 객체 — 운영·라이프사이클 (Sandbox·배포·릴리즈).md` |
| 2GP 패키지 버전을 Tooling API로 생성/조회하는 객체 / Package2·Package2Version·Package2VersionCreateRequest / 1GP MetadataPackage·구독자 패키지 설치·브랜딩·StaticResource 조회 | `DevOps(데브옵스)/ToolingAPI(툴링API)/Tooling API 객체 — 패키징·브랜딩 (1GP·2GP·정적콘텐츠).md` |
| Experience Cloud 모더레이션 룰을 Tooling API로 조회하는 객체 / ModerationRule·KeywordList·UserCriteria로 커뮤니티 모더레이션 구성 / Experience 사이트 상세(SiteDetail)·네비게이션 메뉴(MenuItem)를 SOQL로 조회 / 관리형 콘텐츠 타입(ManagedContentType)을 Tooling API로 조회 / 커머스 웹스토어 생성 템플릿(WebStoreTemplate)·제품 속성 세트를 SOQL로 조회 / 이메일 템플릿·오프라인 브리프케이스를 Tooling API로 조회 | `DevOps(데브옵스)/ToolingAPI(툴링API)/Tooling API 객체 — Experience·콘텐츠·커머스 (사이트·모더레이션·관리형콘텐츠·웹스토어).md` |
| 외부 서비스 등록(ExternalServiceRegistration·OpenAPI 스키마)을 Tooling API로 조회하는 객체 / 등록된 외부 서비스(RegisteredExternalService) SOQL 조회 / Data 360·Data Kit 데이터 스트림 템플릿(DataStreamTemplate)·ActivationPlatform을 Tooling API로 조회 / 결제 게이트웨이 프로바이더(PaymentGatewayProvider)·게이트웨이 결제 수단 유형을 SOQL로 조회 / Account Engagement·Pardot 마케팅 확장(MarketingAppExtension)·Pardot 비즈니스 유닛(PardotTenant)을 Tooling API로 조회 / 최근 조회 항목(RecentlyViewed)·커스텀 알림 유형(CustomNotificationType)을 SOQL로 조회 | `DevOps(데브옵스)/ToolingAPI(툴링API)/Tooling API 객체 — 통합·데이터·결제·마케팅 (외부서비스·Data Kit·페이먼트·Account Engagement).md` |
| Knowledge 아티클 Apex로 게시하는 방법 | `Apex/Integration(통합)/KbManagement Namespace.md` |
| Knowledge 아티클 번역 제출 Apex | `Apex/Integration(통합)/KbManagement Namespace.md` |
| Knowledge 아티클 보관 스케줄 Apex | `Apex/Integration(통합)/KbManagement Namespace.md` |
| Lightning Knowledge 어떻게 켜는지 / 활성화하는 방법 / 지식베이스 셋업 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 셋업 & 구성.md` |
| Lightning Knowledge가 Classic이랑 뭐가 다른지 / 마이그레이션 고려사항 / 한계 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 개요 — 계획·비교·한계.md` |
| csv로 아티클 임포트하는 방법 / 아티클 대량 등록 / zip 임포트 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 아티클 임포트.md` |
| 아티클 번역 / 다국어 지원하는 방법 / 번역 내보내기·가져오기 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 다국어 & 번역.md` |
| 데이터 카테고리 만드는 방법 / 누가 아티클 볼 수 있게 할지 / 카테고리 가시성 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 데이터 카테고리 & 공유.md` |
| 스마트링크 / 영구링크 / 아티클 검색·작성 액션 / 채널에 아티클 공유 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 사용 — 액션·검색·스마트링크·채널.md` |
| 아티클 리포트 만드는 방법 / 조회·투표 통계 리포팅 | `Service(서비스)/Knowledge(지식)/Lightning Knowledge 아티클 리포팅.md` |
| Knowledge 아티클(KAV)에 트리거 작성하는 방법 / 액션별(게시·번역·보관) 트리거 발화 / KAV before insert 가능한가 | `Apex/Trigger(트리거)/특정 표준 객체 트리거 고려사항 — Chatter · Knowledge.md` |
| Chatter FeedItem·FeedComment에 트리거 되나 / 채터 피드 트리거 작성 / 표준 객체 고유 트리거 제약 | `Apex/Trigger(트리거)/특정 표준 객체 트리거 고려사항 — Chatter · Knowledge.md` |
| Visualforce로 커스텀 채팅 창 만드는 방법 / liveAgent 컴포넌트 | `Service(서비스)/Chat(채팅)/커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅.md` |
| 채팅 종료 후 post-chat 페이지 / disconnectedBy 확인 | `Service(서비스)/Chat(채팅)/커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅.md` |
| 특정 상담원에게 직접 채팅 라우팅 / 폴백 라우팅 / direct-to-agent | `Service(서비스)/Chat(채팅)/커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅.md` |
| Chat Deployment API 로깅·윈도우·버튼 설정하는 방법 | `Service(서비스)/Chat(채팅)/Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼.md` |
| 채팅에서 레코드 자동 검색·생성 / 자동 채팅 초대 띄우는 방법 | `Service(서비스)/Chat(채팅)/Deployment API — 레코드 자동 검색·생성·자동 채팅 초대 & 코드 샘플.md` |
| Pre-Chat 폼으로 방문자 정보 수집하는 방법 / 채팅 전 컨텍스트 설정 | `Service(서비스)/Chat(채팅)/Pre-Chat API — 방문자 정보 수집 & 컨텍스트 설정.md` |
| 모바일 푸시 알림 Apex로 보내는 방법 / 모바일 앱에 인앱·push 알림 / Notification Builder vs Apex 알림 / APNs FCM 등록 | `Apex/Messaging(메시징)/Mobile Notifications.md` |
| Omni-Channel 객체·필드가 뭐야 / AgentWork·ServiceChannel·UserServicePresence·PendingServiceRouting / 옴니채널 콘솔 메서드 작업 수락 거절 | `Service(서비스)/OmniChannel(옴니채널)/Omni-Channel 객체·메타데이터·콘솔 컴포넌트.md` |
| Omni-Channel 외부 라우팅 통합하는 방법 / 서드파티 라우팅 엔진 연동 / CDC Pub/Sub·Apex Trigger로 PendingServiceRouting 구독해 AgentWork 생성 | `Service(서비스)/OmniChannel(옴니채널)/Omni-Channel External Routing.md` |
| 에이전트에게 다음 단계 액션 목록 띄우는 방법 / Actions & Recommendations 컴포넌트 / 레코드 페이지에 플로우·퀵액션·NBA 추천 / RecordAction 정션 객체 | `Service(서비스)/Lightning Flow for Service (Actions & Recommendations).md` |
| 메타데이터 배포하는 방법 | `DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API File-Based 호출.md` |
| Metadata API로 검색하는 방법 | `DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API File-Based 호출.md` |
| Metadata API Java 클라이언트 연결하는 방법 | `DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API Quick Start.md` |
| Metadata API 배포 REST로 하는 방법 | `DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API REST.md` |
| Metadata API CustomObject 코드로 생성하는 방법 | `DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API CRUD 호출.md` |
| 지원되는 메타데이터 타입 목록 조회하는 방법 | `DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API Utility Calls.md` |
| 배포 결과 파싱하는 방법 | `DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API Result Objects.md` |
| Metadata API 배포 시 AllOrNone 설정하는 방법 | `DevOps(데브옵스)/MetadataAPI(메타데이터API)/Metadata API Headers.md` |
| Dev Hub 활성화하는 방법 | `DevOps(데브옵스)/DX(DX개발환경)/DX 도구 접근 권한.md` |
| DX 도구 사용자 추가하는 방법 | `DevOps(데브옵스)/DX(DX개발환경)/DX 도구 접근 권한.md` |
| Sandbox CLI로 생성하는 방법 | `DevOps(데브옵스)/DX(DX개발환경)/Sandbox 관리.md` |
| Sandbox 새로고침 CLI 명령 | `DevOps(데브옵스)/DX(DX개발환경)/Sandbox 관리.md` |
| CLI로 레코드 조회하는 방법 | `DevOps(데브옵스)/DX(DX개발환경)/DX 데이터 작업.md` |
| Bulk API 2.0 대량 데이터 가져오는 방법 | `DevOps(데브옵스)/DX(DX개발환경)/DX 데이터 작업.md` |
| sObject Tree 데이터 import하는 방법 | `DevOps(데브옵스)/DX(DX개발환경)/DX 데이터 작업.md` |
| Org Development Model 배포 절차 | `DevOps(데브옵스)/Deploy(배포·CICD)/Metadata API 빌드·릴리스 워크플로.md` |
| 배포 검증만 하는 방법 project deploy validate | `DevOps(데브옵스)/Deploy(배포·CICD)/Metadata API 빌드·릴리스 워크플로.md` |
| Unlocked Package 처음 만드는 방법 | `DevOps(데브옵스)/Packaging2GP(2세대패키징)/Unlocked Package 개념과 준비.md` |
| Org-Dependent Unlocked Package란 | `DevOps(데브옵스)/Packaging2GP(2세대패키징)/Unlocked Package 개념과 준비.md` |
| sfdx-project.json 패키지 파라미터 설명 | `DevOps(데브옵스)/Packaging2GP(2세대패키징)/Unlocked Package 생성과 설정.md` |
| 패키지 버전 번호 NEXT 키워드 쓰는 방법 | `DevOps(데브옵스)/Packaging2GP(2세대패키징)/Unlocked Package 개발과 버전.md` |
| 패키지 버전 릴리스 promote하는 방법 | `DevOps(데브옵스)/Packaging2GP(2세대패키징)/Unlocked Package 개발과 버전.md` |
| 패키지 업그레이드 Push Upgrade하는 방법 | `DevOps(데브옵스)/Packaging2GP(2세대패키징)/Unlocked Package 릴리스와 설치.md` |
| 패키지 설치 sf package install 방법 | `DevOps(데브옵스)/Packaging2GP(2세대패키징)/Unlocked Package 릴리스와 설치.md` |
| CircleCI로 Salesforce 배포 자동화하는 방법 | `DevOps(데브옵스)/Deploy(배포·CICD)/CI 통합 전수 (CircleCI·Jenkins·Travis).md` |
| Jenkins Jenkinsfile Salesforce DX 예제 | `DevOps(데브옵스)/Deploy(배포·CICD)/CI 통합 전수 (CircleCI·Jenkins·Travis).md` |
| 서버 키 암호화해서 CI에 저장하는 방법 | `DevOps(데브옵스)/Deploy(배포·CICD)/CI 통합 전수 (CircleCI·Jenkins·Travis).md` |
| Locker랑 LWS 차이가 뭐야 / Lightning Web Security vs Lightning Locker / LWR 사이트 보안 모델 | `Security(보안)/Lightning Web Security (LWS).md` |
| LWR 사이트에서 Google Analytics·Tag Manager(third-party 스크립트) 넣는 방법 / Privileged Script Tag x-oasis-script | `Security(보안)/Lightning Web Security (LWS).md` |
| LWR 사이트 다국어/번역하는 방법·언어 추가·fallback | `LWC/UIPatterns(UI패턴)/LWR 다국어 사이트.md` |
| LWR Experience Delivery SSR이 뭐야·page load 빠르게 | `LWC/UIPatterns(UI패턴)/LWR Sites (Experience Cloud).md` |
| LWR 사이트에서 {!Route.term} 같은 표현식·동적 데이터 | `LWC/UIPatterns(UI패턴)/LWR Expressions 레퍼런스.md` |
| LWR 사이트 캐싱 TTL·왜 publish 해야 반영되나 | `LWC/UIPatterns(UI패턴)/LWR 동작·캐싱·제약.md` |
| LWR이 지원 안 하는 기능·제약·최대 route 수 | `LWC/UIPatterns(UI패턴)/LWR 동작·캐싱·제약.md` |
| LWR 사이트 데이터·인터랙션 어떻게 Data Cloud로 보내나 / Website Engagement DMO·experience_interaction | `LWC/UIPatterns(UI패턴)/LWR Tag Manager 데이터 관리.md` |
| Google Tag Manager·Experience Tag Manager를 LWR 사이트에 연동·인터랙션 이벤트 추적·Consent Opt-In | `LWC/UIPatterns(UI패턴)/LWR Tag Manager 데이터 관리.md` |
| B2C Commerce 주문이 Salesforce 어느 객체·필드로 매핑돼 / storefront 주문 데이터 맵 / Order XSD → SF 필드 | `Commerce(커머스)/B2C Commerce Storefront Order Data Map.md` |
| storefront 주문을 OM으로 import하는 방법 / OrderSummary 생성하는 방법 / 과거 주문 bulk load | `Commerce(커머스)/Order Management — Import·Fulfillment·Taxation.md` |
| 교환 RMA 처리 API / Preview·Submit Cart to Exchange Order / payment sequencing 결제 순서 제어 | `Commerce(커머스)/Order Management — Exchanges·Payment Sequencing·확장.md` |
| 에이전트 스크립트 어떻게 쓰나 / Agentforce 에이전트를 코드로 정의하는 법 / Agent Script가 뭐야 / Agentforce Builder로 에이전트 만드는 법 | `Agentforce(에이전트포스)/Agent Script 개요와 언어 특성.md` |
| Agent Script 변수 어떻게 써 / 리스트(컬렉션) 변수 다루는 법 / 멀티턴 순서 강제·슬롯 필링 / 시스템 인스트럭션 오버라이드 | `Agentforce(에이전트포스)/Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드.md` |
| 에이전트 다른 org로 배포 / Agentforce 에이전트를 샌드박스에서 프로덕션으로 옮기는 법 / sf CLI로 Bot·GenAiPlannerBundle 메타데이터 배포 / package.xml 매니페스트로 에이전트 retrieve·deploy | `Agentforce(에이전트포스)/Agent Script 메타데이터 배포 (DX·패키징).md` |
| 통합이 갑자기 invalid_grant로 죽어요 / refresh token이 왜 폐기되나 / access grant 5개 한도 | `Integration(통합)/Connected App (연결된 앱) — OAuth 클라이언트.md` |
| Invalid JWT Signature 원인 / JWT용 외부 개인키 JKS 변환 / keytool importkeystore | `Integration(통합)/Connected App (연결된 앱) — OAuth 클라이언트.md` |
| REST 호출에 401 INVALID_SESSION_ID 왜 나나 / 세션 만료 통합 오류 / 410 GONE API 버전 은퇴 | `Integration(통합)/REST API.md` |
| 외부 오브젝트가 복제보다 나은 때 / OData 외부 소스에서 행이 안 나올 때 / 데이터 복제 vs 페더레이션 | `sObject/External Objects.md` |
| 통합 사용자 어떻게 만드나 / API 전용 유저 라이선스 / 무료 통합 라이선스 5개 최소권한 | `Security(보안)/Integration User & API-Only User (통합 사용자).md` |
| 미들웨어(MuleSoft) 언제 쓰나 / point-to-point vs ESB / 통합 재시도·멱등성 설계 | `Integration(통합)/통합 아키텍처 결정 - 미들웨어·재시도·멱등성.md` |
| SOAP 콜아웃 테스트 어떻게 / Methods defined as testMethod do not support Web service callouts | `Apex/Testing(테스트)/WebServiceMock.md` |
| 외부 SOAP 서비스(ERP WSDL)를 Apex에서 호출 / Generate from WSDL 스텁 생성 / WSDL2Apex | `Apex/Integration(통합)/WSDL2Apex — 외부 SOAP 소비 (스텁 생성·구조·한도).md` |
| 대용량 XML 스트리밍 파싱/생성 / XmlStreamReader XmlStreamWriter / StAX Apex | `Apex/Integration(통합)/XmlStreamReader·XmlStreamWriter (스트리밍 XML).md` |
| 외부 방화벽이 Salesforce 콜아웃 허용하려면 / 아웃바운드 IP 범위·ip-ranges.json / Private Connect | `Integration(통합)/아웃바운드 연결 - IP allowlist·Private Connect.md` |
| SAP/Oracle/NetSuite/Informatica를 Salesforce와 어떻게 연동 / 실시간 vs 배치 통합 / 제품별 연동 지도 | `Integration(통합)/ERP·서드파티 제품 연동 지도.md` |
| Named Credential 커스텀 파라미터 헤더 / Custom 인증 프로토콜 / {!$Credential} 파라미터 | `Integration(통합)/Named Credential.md` |
| 사용자가 브라우저로 로그인하는 OAuth 어떻게 세워 / 웹 서버 플로우 구축 / authorization code + PKCE 절차 / code_verifier code_challenge 만드는 법 | `Integration(통합)/OAuth Web Server + PKCE 플로우 구축 가이드.md` |
| Connected App 만들 때 무슨 칸을 채우나 / External Client App OAuth 필드 전부 / Selected OAuth Scopes 목록 / Callback URL·Require PKCE·Permitted Users 뭐 고르나 | `Integration(통합)/OAuth 클라이언트(Connected App·External Client App) 생성 필드 전수 레퍼런스.md` |
| 소셜 로그인 어떻게 붙이나 / Google 로그인 버튼 만드는 법 / Auth Provider SSO 설정 절차 / Registration Handler로 JIT 사용자 자동 생성 | `Integration(통합)/Auth Provider 소셜 로그인·SSO 구축 가이드.md` |
| SOAP API 표준 오퍼레이션 뭐가 있나 / Enterprise vs Partner WSDL 차이 / login upsert convertLead getUpdated / 강타입 API 언제 REST 대신 쓰나 | `Integration(통합)/SOAP API (표준 오퍼레이션·enterprise·partner WSDL).md` |
| CometD로 이벤트 구독하는 법 / PushTopic Generic Streaming 차이 / replayId로 놓친 이벤트 재생 / 브라우저 Visualforce에서 push 구독 | `Integration(통합)/Streaming API (CometD·PushTopic·Generic Streaming).md` |
| gRPC로 Platform Event 구독 클라이언트 세우는 법 / Pub/Sub API 파이썬 예제 / proto stub 생성·credit flow control·Avro 디코드 / 외부에서 이벤트 발행 | `Integration(통합)/Pub-Sub API 클라이언트 구축 가이드 (gRPC 구독·발행).md` |
| 이벤트 기반 통합 처음부터 끝까지 어떻게 / Platform Event 정의→발행→구독→멱등→재시도 / event-driven integration 전체 흐름 | `Integration(통합)/이벤트 기반 통합 구축 가이드 (Platform Event end-to-end).md` |
| 비밀번호 정책·세션 타임아웃·로그인 IP를 어디서 설정하나 / 계정 잠금·비밀번호 만료 정책 / High Assurance 세션 / 로그인 시간 제한 (org 전역 설정·정책 → Admin) | `Admin(어드민)/LoginSecurity(로그인·세션보안)/Password Policies (비밀번호 정책).md` + `Admin(어드민)/LoginSecurity(로그인·세션보안)/Session Settings (세션 설정).md` + `Admin(어드민)/LoginSecurity(로그인·세션보안)/Login IP Ranges & Login Hours (로그인 IP·시간 제한).md` |
| 레코드 접근을 제한(좁히는) 규칙 만들기 / 표시 필터로 보이는 레코드 줄이기 / Restriction Rule (접근을 확대·기본값 정하는 OWD·공유 규칙은 [[조직 전체 공유 기본값(OWD)과 공유 규칙]] 참고 → Admin) | `Security(보안)/Restriction Rules (제한 규칙).md` |
| org 로그인 URL 바꾸기 / My Domain 설정 / SSO·외부 IdP(SAML)로 로그인 / 외부 아이덴티티 공급자 로그인·로그인 정책 | `Security(보안)/My Domain (마이 도메인).md` + `Security(보안)/Single Sign-On (SAML SSO 인바운드).md` |
