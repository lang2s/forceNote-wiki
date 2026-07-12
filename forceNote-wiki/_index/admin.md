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
| Company Information, 회사 정보, Fiscal Year, 회계연도, org default, 조직 기본값, 회계연도 시작 월, locale, 언어, 통화, 라이선스, 스토리지, 표준 회계연도, 커스텀 회계연도 | `Admin(어드민)/Company Information & Fiscal Year (회사 정보·회계연도).md` |
| Business Hours, Holidays, 영업 시간, 휴일, 지원 시간, escalation 기준, 에스컬레이션 경과시간, 지원 시간 설정, 휴일 관리 | `Admin(어드민)/Business Hours & Holidays (영업 시간·휴일).md` |
| Multiple Currencies, 멀티 통화, multi-currency, corporate currency, 환율, dated exchange rate, 통화 관리, 멀티통화 비활성화 불가, 회사 통화 | `Admin(어드민)/Multiple Currencies (멀티 통화).md` |
| Setup Audit Trail, 설정 감사 추적, audit trail, 변경 이력, 감사, 누가 바꿨나, 설정 변경 이력, 누가 무엇을 언제 | `Admin(어드민)/Setup Audit Trail (설정 감사 추적).md` |

## 사용자 관리 (User Management)

| 키워드 | 파일 |
|---|---|
| Users, 사용자, 사용자 관리, deactivate, 비활성화, freeze, 동결, user license, 사용자 라이선스, 로그인 차단, 사용자 생성, 라이선스 반환 | `Admin(어드민)/Users (사용자 관리).md` |
| Roles, Role Hierarchy, 역할, 역할 계층, 레코드 접근, record access, role vs profile, 역할과 프로파일 차이, 수직 상속, 레코드 접근 확대 | `Admin(어드민)/Roles & Role Hierarchy (역할·역할 계층).md` |
| Public Groups, 공개 그룹, 공용 그룹, 그룹, sharing 대상, 공유 그룹, 사용자 역할 묶음, 공유 대상 그룹 | `Admin(어드민)/Public Groups (공개 그룹).md` |
| Delegated Administration, 위임 관리, delegated admin, 부분 관리 권한, 위임 관리자, 관리 권한 위임 | `Admin(어드민)/Delegated Administration (위임 관리).md` |
| User Access Policies, 사용자 액세스 정책, 자동 프로비저닝, 대량 온보딩, grant revoke, 권한 자동 부여, 규칙 기반 권한 할당, Summer 24 GA, 사용자에게 권한 자동 배정 | `Admin(어드민)/User Access Policies (사용자 액세스 정책).md` |
| User Management Settings, 사용자 관리 설정, Enhanced Profile User Interface, Enhanced Profile List Views, Login Access Policies, 로그인 대행, log in as, Grant Login Access, 관리자 로그인 대행, 사용자 계정 로그인 | `Admin(어드민)/User Management Settings · Login Access Policies (사용자 관리 설정·로그인 대행).md` |
| User License, Permission Set License, Feature License, 라이선스 유형, PSL, Salesforce Platform license, Salesforce Integration license, Feature License 종류, 라이선스 소진, 이 기능 무슨 라이선스, 라이선스 층위 | `Admin(어드민)/User Licenses · Permission Set Licenses · Feature Licenses (라이선스 유형).md` |

## 보안 설정 (Security Settings)

| 키워드 | 파일 |
|---|---|
| Session Settings, 세션 설정, session timeout, 세션 타임아웃, High Assurance, 세션 보안, 자동 로그아웃, 세션 보안 수준, IP 잠금, 로그인 보안 | `Admin(어드민)/Session Settings (세션 설정).md` |
| Password Policies, 비밀번호 정책, 암호 정책, lockout, 계정 잠금, 비밀번호 만료, 로그인 실패, 복잡도, 비밀번호 이력, 프로파일 override | `Admin(어드민)/Password Policies (비밀번호 정책).md` |
| Login IP Ranges, 로그인 IP 범위, Login Hours, 로그인 시간, Trusted IP, 신뢰 IP, Network Access, IP 제한, 프로파일 IP 하드 거부, org 챌린지, 로그인 시간 제한 | `Admin(어드민)/Login IP Ranges & Login Hours (로그인 IP·시간 제한).md` |
| Health Check, 보안 상태 점검, Security Health Check, baseline, 보안 점수, security score, 보안 baseline 부합도, 위험 수정 | `Admin(어드민)/Security Health Check (보안 상태 점검).md` |
| Field History Tracking, 필드 이력 추적, 필드 변경 추적, history related list, Field Audit Trail, 이전 이후 값, 최대 20필드, History 관련목록 | `Admin(어드민)/Field History Tracking (필드 이력 추적).md` |

## 데이터 관리 (Data Management)

| 키워드 | 파일 |
|---|---|
| Mass Transfer, 대량 이전, Mass Delete, 대량 삭제, 소유권 이전, 레코드 재배정, 대량 작업, 소유권 대량 이전, 레코드 대량 삭제 | `Admin(어드민)/Mass Transfer & Mass Delete (대량 이전·삭제).md` |
| Data Export, 데이터 내보내기, export service, 백업, storage, 스토리지, 용량, 주간 내보내기, 데이터 백업, 스토리지 사용량 | `Admin(어드민)/Data Export & Storage (데이터 내보내기·스토리지).md` |

## 오브젝트·필드 커스터마이제이션 (Objects & Fields Customization)

| 키워드 | 파일 |
|---|---|
| Custom Objects, 커스텀 오브젝트, Custom Fields, 커스텀 필드, Object Manager, __c, 오브젝트 만들기, 필드 추가, 커스텀 오브젝트 생성 | `Admin(어드민)/Custom Objects & Custom Fields (커스텀 오브젝트·필드).md` |
| Picklists, 피클리스트, Global Value Set, 전역 값 집합, Dependent Picklist, 종속 피클리스트, controlling field, field dependency, 필드 종속성 | `Admin(어드민)/Picklists — Global Value Sets & Dependent Picklists (피클리스트).md` |
| Custom Settings, 커스텀 설정, List Custom Setting, Hierarchy Custom Setting, 캐시 설정, 구성 데이터, 리스트 커스텀 설정, 계층 커스텀 설정 | `Admin(어드민)/Custom Settings (커스텀 설정).md` |
| Custom Labels, 커스텀 레이블, 사용자 정의 레이블, 번역, localization, 지역화, 번역 가능한 텍스트 | `Admin(어드민)/Custom Labels (커스텀 레이블).md` |

## UI 커스터마이제이션 (UI Customization)

| 키워드 | 파일 |
|---|---|
| Lightning App Builder, 라이트닝 앱 빌더, Lightning Pages, 라이트닝 페이지, FlexiPage, Record Page, App Page, Home Page, 페이지 조립, 커스텀 페이지 만들기, 페이지 활성화 | `Admin(어드민)/Lightning App Builder & Pages (라이트닝 앱 빌더·페이지).md` |
| Lightning Apps, 라이트닝 앱, App Manager, Tabs, 탭, custom tab, 커스텀 탭, utility bar, 유틸리티 바, 웹탭, 앱 만들기, 탭 4유형 | `Admin(어드민)/Lightning Apps & Tabs (라이트닝 앱·탭).md` |
| List Views, 리스트 뷰, 목록 보기, List View Button Layout, 리스트 뷰 버튼 레이아웃, Kanban, 칸반, mass quick action, 대량 퀵 액션, 필터 목록 | `Admin(어드민)/List Views (리스트 뷰).md` |
| Quick Actions, 퀵 액션, 빠른 실행, Global Actions, 글로벌 액션, object-specific action, global publisher layout, 글로벌 퍼블리셔 레이아웃, action bar, 액션 바 | `Admin(어드민)/Quick Actions & Global Actions (퀵 액션·글로벌 액션).md` |
| Compact Layouts, 컴팩트 레이아웃, highlights panel, 하이라이트 패널, key fields, 핵심 필드, 모바일 카드 필드 | `Admin(어드민)/Compact Layouts (컴팩트 레이아웃).md` |
| Custom Buttons, 커스텀 버튼, Custom Links, 커스텀 링크, URL button, URL 버튼, Visualforce button, VF 버튼, JavaScript 버튼, 레거시 버튼 | `Admin(어드민)/Custom Buttons & Links (커스텀 버튼·링크).md` |
| New Button or Link, 버튼 링크 생성, 버튼 만드는 법, Display Type, Detail Page Button, List Button, Behavior, Content Source, URL 버튼 생성, Visualforce 버튼 생성, Window Open Properties, merge field 버튼, Action Type, 액션 타입, Create a Record, Log a Call, Update a Record, Custom Action, object-specific global, 커스텀 버튼 어떻게 만드나, 액션 타입 종류 | `Admin(어드민)/New Button or Link & Action 생성 가이드 (타입·설정·예시).md` |
| In-App Guidance, In App Guidance, Prompt metadata, promptVersions, displayType, FloatingPanel, DockedComposer, Targeted prompt, displayPosition, elementRelativePosition, targetPageType, targetPageKey1, targetPageKey2, stepNumber, walkthrough, single prompt, uiFormulaRule, userAccess, userProfileAccess, delayDays, timesToDisplay, 인앱 가이던스, 인앱 안내, 프롬프트, 워크스루, 멀티스텝, 사용자 온보딩, 기능 도입, 라이트닝 안내 메시지, 인앱 프롬프트 어떻게 만들어, 사용자 온보딩 투어 만들기, 프롬프트 메타데이터 배포, 특정 페이지에 안내 띄우기, 프로필별 안내 표시 | `Admin(어드민)/In-App Guidance — 프롬프트·워크스루 (사용자 온보딩).md` |

## 자동화 (Automation)

| 키워드 | 파일 |
|---|---|
| Flow, 플로우, Flow Builder, 플로우 빌더, record-triggered flow, 레코드 트리거 플로우, screen flow, 화면 플로우, scheduled flow, 예약 플로우, 선언적 자동화, 자동화 유형 개요 | `Admin(어드민)/Flow — 선언적 자동화 개요 (플로우).md` |
| Workflow Rules, 워크플로 규칙, Migrate to Flow, 플로우 이전, 레거시 자동화, time-dependent action, 시간 기반 액션, 워크플로 마이그레이션 | `Admin(어드민)/Workflow Rules & Migrate to Flow (워크플로 규칙·플로우 이전).md` |
| Email Alerts, 이메일 알림, Email Templates, 이메일 템플릿, Auto-Response Rules, 자동 응답 규칙, merge field, 병합 필드, 이메일 발송 액션, 자동 회신 | `Admin(어드민)/Email Alerts, Templates & Auto-Response Rules (이메일 알림·템플릿·자동 응답).md` |

## 이메일 (Email)

| 키워드 | 파일 |
|---|---|
| Organization-Wide Email Addresses, 조직 전체 이메일 주소, 공통 발신 주소, Deliverability, 전달성, Access to Send Email, 이메일 발송 권한, 이메일 인증, 발송 전달성 | `Admin(어드민)/Organization-Wide Email Addresses & Deliverability (조직 전체 이메일·전달성).md` |
