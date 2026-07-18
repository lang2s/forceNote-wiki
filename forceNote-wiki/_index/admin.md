---
tags: [index, search, navigation]
created: 2026-07-03
---

# SEARCH INDEX — Admin(어드민)
> 어드민 종합 지식 이니셔티브의 홈 샤드 — 조직 설정·사용자 관리·보안·데이터·UI·자동화 어드민 태스크 키워드 → 파일
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.
> 참고: 커스터마이제이션 세부(Formula·Roll-Up·Page Layout·Record Type·Data Loader·DIW·Approval 등)는 `_index/platform.md`, OWD/공유는 `_index/security.md`, Reports/Dashboards는 `_index/analytics.md`도 참조.

## 🗺️ 진입점 / 개요 (Start Here)

| 키워드 | 파일 |
|---|---|
| Salesforce Admin, 어드민 개요, 관리자 개요, Admin Overview, 어드민 종합 지도, 어드민 시작, 무엇부터, 어드민 8도메인 진입 지도 | `Admin(어드민)/Salesforce 어드민 종합 개요.md` |

## 조직 설정 (Organization Setup)

| 키워드 | 파일 |
|---|---|
| Company Information, 회사 정보, Fiscal Year, 회계연도, org default, 조직 기본값, 회계연도 시작 월, locale, 언어, 통화, 라이선스, 스토리지, 표준 회계연도, 커스텀 회계연도 | `Admin(어드민)/OrgSetup(조직설정)/Company Information & Fiscal Year (회사 정보·회계연도).md` |
| Business Hours, Holidays, 영업 시간, 휴일, 지원 시간, escalation 기준, 에스컬레이션 경과시간, 지원 시간 설정, 휴일 관리 | `Admin(어드민)/OrgSetup(조직설정)/Business Hours & Holidays (영업 시간·휴일).md` |
| Multiple Currencies, 멀티 통화, multi-currency, corporate currency, 환율, dated exchange rate, 통화 관리, 멀티통화 비활성화 불가, 회사 통화 | `Admin(어드민)/OrgSetup(조직설정)/Multiple Currencies (멀티 통화).md` |
| Setup Audit Trail, 설정 감사 추적, audit trail, 변경 이력, 감사, 누가 바꿨나, 설정 변경 이력, 누가 무엇을 언제 | `Admin(어드민)/OrgSetup(조직설정)/Setup Audit Trail (설정 감사 추적).md` |

## 조직 관리·운영 (Org Management & Operations)

| 키워드 | 파일 |
|---|---|
| Release Updates, 릴리스 업데이트, Manage Release Updates, Critical Updates 대체, Test Run, 테스트 실행, 기한 활성화, enforced, Complete Steps By, Get Started, 릴리스 업데이트 어떻게 처리, 릴리스 업데이트 강제 적용 | `Admin(어드민)/OrgSetup(조직설정)/Release Updates 처리 (테스트 실행·기한 활성화).md` |
| System Overview, 시스템 개요, 조직 사용량, Salesforce Optimizer, 옵티마이저, 조직 건강 진단, org health, 미사용 필드, 한도 근접, org 정리 리포트, 사용량 카드, 조직 최적화 진단 | `Admin(어드민)/OrgSetup(조직설정)/System Overview & Salesforce Optimizer (조직 사용량·최적화 진단).md` |
| Installed Packages, 설치된 패키지, 패키지 관리, Manage Licenses, 패키지 라이선스 할당, Uninstall package, 패키지 제거, 패키지 업그레이드, 구독자 어드민, subscriber package admin, AppExchange 설치 | `Admin(어드민)/OrgSetup(조직설정)/Installed Packages 관리 (구독자 어드민 관점).md` |

## 사용자 관리 (User Management)

| 키워드 | 파일 |
|---|---|
| Users, 사용자, 사용자 관리, deactivate, 비활성화, freeze, 동결, user license, 사용자 라이선스, 로그인 차단, 사용자 생성, 라이선스 반환 | `Admin(어드민)/Users(사용자·접근)/Users (사용자 관리).md` |
| Roles, Role Hierarchy, 역할, 역할 계층, 레코드 접근, record access, role vs profile, 역할과 프로파일 차이, 수직 상속, 레코드 접근 확대 | `Admin(어드민)/Users(사용자·접근)/Roles & Role Hierarchy (역할·역할 계층).md` |
| Public Groups, 공개 그룹, 공용 그룹, 그룹, sharing 대상, 공유 그룹, 사용자 역할 묶음, 공유 대상 그룹 | `Admin(어드민)/Users(사용자·접근)/Public Groups (공개 그룹).md` |
| Delegated Administration, 위임 관리, delegated admin, 부분 관리 권한, 위임 관리자, 관리 권한 위임 | `Admin(어드민)/Users(사용자·접근)/Delegated Administration (위임 관리).md` |
| User Access Policies, 사용자 액세스 정책, 자동 프로비저닝, 대량 온보딩, grant revoke, 권한 자동 부여, 규칙 기반 권한 할당, Summer 24 GA, 사용자에게 권한 자동 배정 | `Admin(어드민)/Users(사용자·접근)/User Access Policies (사용자 액세스 정책).md` |
| User Management Settings, 사용자 관리 설정, Enhanced Profile User Interface, Enhanced Profile List Views, Login Access Policies, 로그인 대행, log in as, Grant Login Access, 관리자 로그인 대행, 사용자 계정 로그인 | `Admin(어드민)/Users(사용자·접근)/User Management Settings · Login Access Policies (사용자 관리 설정·로그인 대행).md` |
| User License, Permission Set License, Feature License, 라이선스 유형, PSL, Salesforce Platform license, Salesforce Integration license, Feature License 종류, 라이선스 소진, 이 기능 무슨 라이선스, 라이선스 층위 | `Admin(어드민)/Users(사용자·접근)/User Licenses · Permission Set Licenses · Feature Licenses (라이선스 유형).md` |

## 보안 설정 (Security Settings)

| 키워드 | 파일 |
|---|---|
| Session Settings, 세션 설정, session timeout, 세션 타임아웃, High Assurance, 세션 보안, 자동 로그아웃, 세션 보안 수준, IP 잠금, 로그인 보안 | `Admin(어드민)/LoginSecurity(로그인·세션보안)/Session Settings (세션 설정).md` |
| Password Policies, 비밀번호 정책, 암호 정책, lockout, 계정 잠금, 비밀번호 만료, 로그인 실패, 복잡도, 비밀번호 이력, 프로파일 override | `Admin(어드민)/LoginSecurity(로그인·세션보안)/Password Policies (비밀번호 정책).md` |
| Login IP Ranges, 로그인 IP 범위, Login Hours, 로그인 시간, Trusted IP, 신뢰 IP, Network Access, IP 제한, 프로파일 IP 하드 거부, org 챌린지, 로그인 시간 제한 | `Admin(어드민)/LoginSecurity(로그인·세션보안)/Login IP Ranges & Login Hours (로그인 IP·시간 제한).md` |
| Health Check, 보안 상태 점검, Security Health Check, baseline, 보안 점수, security score, 보안 baseline 부합도, 위험 수정 | `Admin(어드민)/LoginSecurity(로그인·세션보안)/Security Health Check (보안 상태 점검).md` |
| Field History Tracking, 필드 이력 추적, 필드 변경 추적, history related list, Field Audit Trail, 이전 이후 값, 최대 20필드, History 관련목록 | `Admin(어드민)/LoginSecurity(로그인·세션보안)/Field History Tracking (필드 이력 추적).md` |

## 모니터링 (Monitoring)

| 키워드 | 파일 |
|---|---|
| Login History, 로그인 이력, 로그인 감사, LoginHistory, Email Log Files, 이메일 로그, 로그인 실패 추적, Login Forensics, 20000 6개월, 이 메일이 전달됐나, 로그인 기록 다운로드 | `Admin(어드민)/LoginSecurity(로그인·세션보안)/Login History & Email Log Files (로그인·이메일 감사 로그).md` |
| Scheduled Jobs, Apex Jobs, Apex Flex Queue, Background Jobs, Bulk Data Load Jobs, 작업 모니터링, 예약 작업 관리, 배치 잡 중단, Abort Job, Holding, All Scheduled Jobs, 비동기 작업 모니터링, 벌크 로드 잡 | `Admin(어드민)/LoginSecurity(로그인·세션보안)/작업 모니터링 (Scheduled Jobs · Apex Jobs · Flex Queue · Bulk Data Load).md` |

## 데이터 관리 (Data Management)

| 키워드 | 파일 |
|---|---|
| Mass Transfer, 대량 이전, Mass Delete, 대량 삭제, 소유권 이전, 레코드 재배정, 대량 작업, 소유권 대량 이전, 레코드 대량 삭제 | `Admin(어드민)/Data(데이터관리)/Mass Transfer & Mass Delete (대량 이전·삭제).md` |
| Data Export, 데이터 내보내기, export service, 백업, storage, 스토리지, 용량, 주간 내보내기, 데이터 백업, 스토리지 사용량 | `Admin(어드민)/Data(데이터관리)/Data Export & Storage (데이터 내보내기·스토리지).md` |
| Data Protection and Privacy, 개인정보 보호, Individual object, Consent Management, 동의 관리, GDPR CCPA, Right to be Forgotten, ShouldForget, 개인정보 삭제, 프라이버시 선호, ContactPointConsent | `Admin(어드민)/LoginSecurity(로그인·세션보안)/Data Protection & Privacy (개인정보 보호·동의 관리).md` |

## 오브젝트·필드 커스터마이제이션 (Objects & Fields Customization)

| 키워드 | 파일 |
|---|---|
| Custom Objects, 커스텀 오브젝트, Custom Fields, 커스텀 필드, Object Manager, __c, 오브젝트 만들기, 필드 추가, 커스텀 오브젝트 생성 | `Admin(어드민)/ObjectsFields(오브젝트·필드)/Custom Objects & Custom Fields (커스텀 오브젝트·필드).md` |
| Picklists, 피클리스트, Global Value Set, 전역 값 집합, Dependent Picklist, 종속 피클리스트, controlling field, field dependency, 필드 종속성 | `Admin(어드민)/ObjectsFields(오브젝트·필드)/Picklists — Global Value Sets & Dependent Picklists (피클리스트).md` |
| Custom Settings, 커스텀 설정, List Custom Setting, Hierarchy Custom Setting, 캐시 설정, 구성 데이터, 리스트 커스텀 설정, 계층 커스텀 설정 | `Admin(어드민)/ObjectsFields(오브젝트·필드)/Custom Settings (커스텀 설정).md` |
| Custom Labels, 커스텀 레이블, 사용자 정의 레이블, 번역, localization, 지역화, 번역 가능한 텍스트 | `Admin(어드민)/ObjectsFields(오브젝트·필드)/Custom Labels (커스텀 레이블).md` |
| Field Sets, 필드 집합, 필드셋, 필드 세트, dynamic form, 동적 폼, FieldSet metadata, available fields, displayed fields, LWC VF Apex 필드셋, 필드 묶음 노출, 코드 수정 없이 필드 추가, 화면 필드 관리자가 바꾸기, 필드셋 어떻게 만드나 | `Admin(어드민)/ObjectsFields(오브젝트·필드)/Field Sets (필드 집합).md` |
| Lookup Filters, 룩업 필터, 조회 필터, 관계 값 제한, 후보 레코드 제한, Required Optional filter, dependent lookup, 종속 룩업, $Source, 참조 무결성, Lightning always required, 룩업에서 특정 레코드만 보이게, 관계 필드 후보 거르기 | `Admin(어드민)/ObjectsFields(오브젝트·필드)/Lookup Filters (룩업 필터).md` |
| Object Field Limits, 오브젝트 필드 한도, 오브젝트당 커스텀 필드, 커스텀 필드 몇 개까지, 에디션별 한도, edition allocations, relationships per object 40, custom fields 900, Roll-Up 25, 한도 수치 어디서 찾나, 커스텀 오브젝트 몇 개, 정적 설정 한도 | `Admin(어드민)/ObjectsFields(오브젝트·필드)/Object & Field Limits (오브젝트·필드 한도).md` |
| Custom Field Types, 필드 타입 선택, field type 선택, 어떤 필드 타입 쓰나, Text vs Long Text, Picklist vs Multi-Select, Formula vs Roll-Up, Lookup vs Master-Detail, 타입 변환 데이터 손실, 필드 타입 변경 제약, Encrypted Text 제약, Auto Number, Geolocation, 커스텀 필드 만들 때 타입 고르기 | `Admin(어드민)/ObjectsFields(오브젝트·필드)/필드 타입 선택 가이드 (어드민 빌드 관점).md` |

## UI 커스터마이제이션 (UI Customization)

| 키워드 | 파일 |
|---|---|
| Lightning App Builder, 라이트닝 앱 빌더, Lightning Pages, 라이트닝 페이지, FlexiPage, Record Page, App Page, Home Page, 페이지 조립, 커스텀 페이지 만들기, 페이지 활성화 | `Admin(어드민)/UI(사용자인터페이스)/Lightning App Builder & Pages (라이트닝 앱 빌더·페이지).md` |
| Lightning Apps, 라이트닝 앱, App Manager, Tabs, 탭, custom tab, 커스텀 탭, utility bar, 유틸리티 바, 웹탭, 앱 만들기, 탭 4유형 | `Admin(어드민)/UI(사용자인터페이스)/Lightning Apps & Tabs (라이트닝 앱·탭).md` |
| List Views, 리스트 뷰, 목록 보기, List View Button Layout, 리스트 뷰 버튼 레이아웃, Kanban, 칸반, mass quick action, 대량 퀵 액션, 필터 목록 | `Admin(어드민)/UI(사용자인터페이스)/List Views (리스트 뷰).md` |
| Quick Actions, 퀵 액션, 빠른 실행, Global Actions, 글로벌 액션, object-specific action, global publisher layout, 글로벌 퍼블리셔 레이아웃, action bar, 액션 바 | `Admin(어드민)/UI(사용자인터페이스)/Quick Actions & Global Actions (퀵 액션·글로벌 액션).md` |
| Compact Layouts, 컴팩트 레이아웃, highlights panel, 하이라이트 패널, key fields, 핵심 필드, 모바일 카드 필드 | `Admin(어드민)/UI(사용자인터페이스)/Compact Layouts (컴팩트 레이아웃).md` |
| Custom Buttons, 커스텀 버튼, Custom Links, 커스텀 링크, URL button, URL 버튼, Visualforce button, VF 버튼, JavaScript 버튼, 레거시 버튼 | `Admin(어드민)/UI(사용자인터페이스)/Custom Buttons & Links (커스텀 버튼·링크).md` |
| New Button or Link, 버튼 링크 생성, 버튼 만드는 법, Display Type, Detail Page Button, List Button, Behavior, Content Source, URL 버튼 생성, Visualforce 버튼 생성, Window Open Properties, merge field 버튼, Action Type, 액션 타입, Create a Record, Log a Call, Update a Record, Custom Action, object-specific global, 커스텀 버튼 어떻게 만드나, 액션 타입 종류 | `Admin(어드민)/UI(사용자인터페이스)/New Button or Link & Action 생성 가이드 (타입·설정·예시).md` |
| In-App Guidance, In App Guidance, Prompt metadata, promptVersions, displayType, FloatingPanel, DockedComposer, Targeted prompt, displayPosition, elementRelativePosition, targetPageType, targetPageKey1, targetPageKey2, stepNumber, walkthrough, single prompt, uiFormulaRule, userAccess, userProfileAccess, delayDays, timesToDisplay, 인앱 가이던스, 인앱 안내, 프롬프트, 워크스루, 멀티스텝, 사용자 온보딩, 기능 도입, 라이트닝 안내 메시지, 인앱 프롬프트 어떻게 만들어, 사용자 온보딩 투어 만들기, 프롬프트 메타데이터 배포, 특정 페이지에 안내 띄우기, 프로필별 안내 표시 | `Admin(어드민)/UI(사용자인터페이스)/In-App Guidance — 프롬프트·워크스루 (사용자 온보딩).md` |
| User Interface Settings, 사용자 인터페이스 설정, 인라인 편집 안 됨, Inline Editing, Collapsible Sections, Hover Details, Enhanced Lists, 전역 UI 토글, UI 동작 설정, 왜 이 UI 기능이 안 되나, org 전역 UI 켜고 끄기 | `Admin(어드민)/UI(사용자인터페이스)/User Interface Settings (사용자 인터페이스 설정).md` |
| Search Settings, 검색 설정, Search Layouts, 검색 레이아웃, 검색 결과 열, Lookup Dialog, Enhanced Lookups, Global Search, 글로벌 검색, 검색 열 구성, 조회 대화상자, 검색 결과에 어떤 열 나오게 | `Admin(어드민)/UI(사용자인터페이스)/Search Settings & Search Layouts (검색 설정·검색 레이아웃).md` |
| Path, 경로 가이드, Guidance for Success, Sales Path, 단계 안내, Key Fields, PathAssistant, Path Assistant, Opportunity Stage 안내, 셀레브레이션, Celebration, 레코드 단계 안내 만들기 | `Admin(어드민)/UI(사용자인터페이스)/Path (경로 가이드).md` |
| Themes and Branding, 테마 브랜딩, 커스텀 테마, Custom Theme, Rename Tabs, 탭 이름 변경, 오브젝트 라벨 변경, Rename Object Tab Field Labels, Account 거래처, org 브랜딩, 로고, 표준 오브젝트 이름 바꾸기 | `Admin(어드민)/UI(사용자인터페이스)/Themes and Branding & Rename Tabs and Labels (테마·브랜딩·라벨 변경).md` |
| Utility Bar, 유틸리티 바, App Menu, 앱 메뉴, Console Navigation, 콘솔 네비게이션, Split View, 분할 보기, workspace tab, subtab, Standard vs Console, 앱 네비게이션, 콘솔 앱과 표준 앱 차이 | `Admin(어드민)/UI(사용자인터페이스)/Utility Bar · App Menu · Console Navigation (유틸리티 바·앱 메뉴·콘솔 네비).md` |
| Translation Workbench, 번역 워크벤치, Language Settings, 언어 설정, 다국어, fully supported end-user platform-only, 번역 가능 유형, Override 번역, 현지화, localization, org 언어 번역하는 방법, picklist 라벨 번역 | `Admin(어드민)/UI(사용자인터페이스)/Translation Workbench & Language Settings (번역 워크벤치·언어 설정).md` |

## 자동화 (Automation)

| 키워드 | 파일 |
|---|---|
| Flow, 플로우, Flow Builder, 플로우 빌더, record-triggered flow, 레코드 트리거 플로우, screen flow, 화면 플로우, scheduled flow, 예약 플로우, 선언적 자동화, 자동화 유형 개요 | `Admin(어드민)/Automation(자동화)/Flow — 선언적 자동화 개요 (플로우).md` |
| Workflow Rules, 워크플로 규칙, Migrate to Flow, 플로우 이전, 레거시 자동화, time-dependent action, 시간 기반 액션, 워크플로 마이그레이션 | `Admin(어드민)/Automation(자동화)/Workflow Rules & Migrate to Flow (워크플로 규칙·플로우 이전).md` |
| Email Alerts, 이메일 알림, Email Templates, 이메일 템플릿, Auto-Response Rules, 자동 응답 규칙, merge field, 병합 필드, 이메일 발송 액션, 자동 회신 | `Admin(어드민)/Automation(자동화)/Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답).md` |
| Custom Notification Types, Notification Builder, 커스텀 알림, 알림 유형, Send Custom Notification, Notification Delivery Settings, 알림 전달 설정, 데스크톱 모바일 알림, 커스텀 알림 발송, 커스텀 알림 어떻게 보내나 | `Admin(어드민)/UI(사용자인터페이스)/Custom Notification Types (알림 유형·Notification Builder).md` |
| Process Automation Settings, 프로세스 자동화 설정, Default Workflow User, 기본 워크플로 사용자, Flow 오류 이메일 수신자, Send Process or Flow Email, Flow 오류 이메일 누구에게, 자동화 오류 알림, Let users pause flows, 인터뷰 일시정지, enhanced Flows page, 자동화 org 설정 | `Admin(어드민)/Automation(자동화)/Process Automation Settings (프로세스 자동화 설정).md` |

## 이메일 (Email)

| 키워드 | 파일 |
|---|---|
| Organization-Wide Email Addresses, 조직 전체 이메일 주소, 공통 발신 주소, Deliverability, 전달성, Access to Send Email, 이메일 발송 권한, 이메일 인증, 발송 전달성 | `Admin(어드민)/EmailAnalytics(이메일·분석)/Organization-Wide Email Addresses & Deliverability (조직 전체 이메일·전달성).md` |
| 이메일 전달성, Email Deliverability, DKIM Keys, DKIM 서명, DomainKeys Identified Mail, Email Relay, 이메일 릴레이, Bounce Management, 반송 처리, Test Deliverability, 전달성 테스트, SPF, 이메일 스푸핑 방지, Email Security Compliance, Compliance BCC, Email Footers, 이메일이 스팸으로 가요, 회사 SMTP 경유 발송 | `Admin(어드민)/EmailAnalytics(이메일·분석)/이메일 전달성 인프라 (Deliverability · DKIM · Email Relay · Bounce).md` |
| Letterheads, 레터헤드, Enhanced Letterheads, Mail Merge, 메일 머지, Extended Mail Merge, Email to Salesforce, My Email to Salesforce, 이메일 활동 로깅, BCC 이메일 로깅, Classic 이메일, 레거시 이메일 도구, Word 문서 병합, 외부 메일 자동 로깅 | `Admin(어드민)/EmailAnalytics(이메일·분석)/Letterheads · Mail Merge · Email to Salesforce (Classic 이메일 도구).md` |
