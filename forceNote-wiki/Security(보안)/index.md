---
tags: [index, security, securecoding, 보안, 위협모델]
created: 2026-06-18
---

# Security(보안) — 로컬 인덱스

> Salesforce Secure Coding Guide(v67.0 Summer '26) 기반 위협 모델 — XSS·SOQLi·CSRF·Open Redirect·TLS·민감데이터·CRUD/FLS·Lightning 보안·세션/브라우저 통신·MC API·FAQ. 각 위협 영역마다 "플랫폼이 제공하는 보호 + 개발자가 해야 할 방어"를 정리한다.

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Secure Coding 개요]] | 가이드 범위·핵심 보안 원칙·Flow 보안·실행 컨텍스트(User/System Mode) | #concept |
| [[XSS 방어]] | Cross Site Scripting — 브라우저 파싱 컨텍스트별 인코딩, VF 인코딩 함수(JSENCODE/HTMLENCODE/URLENCODE/JSINHTMLENCODE) | #security |
| [[SOQL Injection 위협]] | SOQL/SOSL 인젝션 — bind variable·escapeSingleQuotes·isSafeObject/isSafeField | #security |
| [[CSRF 방어]] | Cross Site Request Forgery — form 자동 보호 범위, page load DML 위험, GET CSRF 보호 | #security |
| [[Secure Communications (TLS)]] | HTTPS 필수·Secure flag cookie·TLS 1.2 독점·cipher suite | #security |
| [[민감 데이터 저장]] | PII·password·token 저장 — Protected CMT/CS, Apex Crypto, Encrypted Fields, Named Credentials | #security |
| [[Arbitrary Redirect 방어]] | Open Redirect — retURL 조작, PageReference 감사, allowlist 매칭 | #security |
| [[권한과 접근 제어 위협]] | CRUD/FLS bypass·sharing violation·privilege escalation — USER_MODE·sharing 키워드·describe·stripInaccessible | #security |
| [[Lightning Security 모델]] | Lightning Locker·CSP·component 레벨 sharing/CRUD/FLS/XSS/CSRF 강제 | #security |
| [[Lightning Web Security (LWS)]] | LWR 사이트 LWS(Locker 대체)·namespace sandbox·cross-namespace·미지원 속성 4종·Privileged Script Tag(x-oasis-script) | #security |
| [[세션 ID와 브라우저 통신 위협]] | managed package session ID·postMessage·WebSocket(CSWSH) cross-origin 통신 | #security |
| [[Marketing Cloud API 보안]] | MC Engagement API — least privilege OAuth·secure storage·금지 endpoint·OWASP Top Ten | #security |
| [[Platform Security FAQ]] | 보안 FAQ·HTTP 헤더(HSTS/frame-ancestors/nosniff)·false positive 공식 설명 | #reference |
| [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]] | 게스트/외부 사용자 접근 제어(declarative vs custom)·게스트 레코드 모드(system mode·without sharing)·Encrypt Record IDs·Apex/Flow 접근 제한·SOQL injection | #experiencecloud |
| [[Experience Cloud 사이트 — CSP·Locker·LWS]] | Aura 사이트 CSP(Relaxed/Strict)·Lightning Locker·LWS org/site 전환·third-party 컴포넌트 활성화·Adobe Analytics | #experiencecloud |
| [[시큐어 코드 리뷰 체크리스트]] | 배포/PR 전 위협별 점검표(XSS·SOQLi·CSRF·Redirect·CRUD/FLS·민감데이터·Sharing·세션·TLS) + Code Analyzer 정적분석 연동 — 8개 위협 노트를 묶는 리뷰 hub | #checklist |
| [[CRUD·FLS·공유 강제 결정 가이드]] | 접근 제어를 언제 무엇으로 강제 — WITH USER_MODE·queryWithBinds·as user/Safely·CanTheUser·stripInaccessible·with sharing 결정 매트릭스 | #decision |
| [[Restriction Rules (제한 규칙)]] | 레코드 접근을 좁히는(제한하는) 규칙 — Scoping Rules(표시 필터)와 구분(enforcementType)·recordFilter EQUALS·지원 오브젝트·View All/System Mode 우회 | #security #access |
| [[My Domain (마이 도메인)]] | org 고유 로그인 URL·로그인 정책(내 도메인으로만)·인증 서비스 노출·로그인 페이지 브랜딩·리디렉션 정책 | #identity |
| [[Single Sign-On (SAML SSO 인바운드)]] | 외부 IdP로 Salesforce 로그인 — SP/IdP-initiated 흐름·SAML 필드·JIT 프로비저닝(SamlJitHandler) | #identity #sso |
| [[Salesforce as Identity Provider (SF를 IdP로)]] | Salesforce를 IdP로 외부 앱에 SSO 제공 — Enable IdP·SP(Connected App) 정의·SAML/OIDC | #identity |
| [[Login Flows · OAuth Custom Scopes (로그인 흐름·커스텀 스코프)]] | 인증 후 커스텀 로그인 흐름(finishLoginFlow·강제 MFA/동의)·OAuth 커스텀 스코프 정의·할당 | #identity |
| [[Certificate and Key Management (인증서·키 관리)]] | 자체서명/CA서명 인증서 생성·가져오기 — mTLS 클라이언트·SAML 서명·JWT 서명 용도별 배선 | #security #certificate |
| [[Connected Apps OAuth Usage (OAuth 사용 모니터링)]] | Setup의 OAuth 사용 앱 현황(사용자 수·설치 상태·세션)·앱별 Install/Block/Uninstall — OAuth 토큰 감사·거버넌스 | #identity #oauth |
| [[Event Monitoring & 보안 감사 (EventLogFile · Real-Time Event Monitoring)]] | 관찰·감사 축 — EventLogFile(배치 로그) 조회·다운로드·보존·EventType 카탈로그, TxnSecurity 강제의 짝 | #audit #monitoring |
| [[Real-Time Event Monitoring & Threat Detection (실시간 이벤트 모니터링 · 위협 탐지)]] | 실시간 스트리밍/저장 이벤트 + ML 위협 탐지 5종(Session Hijacking·Credential Stuffing·Report/API Anomaly) | #audit #monitoring |

---

## 권한 모델 (Profile · Permission Set · 권한 종류)

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Salesforce 권한 모델 개요]] | (허브) 권한을 담는 그릇(Profile·Permission Set·PSG)과 대상(Object·Field·System·Custom 권한) 격자 + grant-only 원칙 | #concept |
| [[Profiles (프로파일)]] | 사용자당 1개 배정되는 기본 설정 그릇(user license type 1개)·page layout·login hours/IP 전용 | #permission |
| [[Permission Sets (권한 집합)]] | 특정 직무·작업 권한을 추가 부여(additive)·다중 할당 가능 | #permission |
| [[Permission Set Groups (권한 집합 그룹)]] | 직무별 permission set 묶음(combined permissions)·Muting으로 특정 권한 비활성화 | #permission |
| [[Object Permissions (오브젝트 권한 — CRUD·View All·Modify All)]] | 오브젝트별 CRUD base 접근·View All/Modify All Records는 공유 무시 | #permission |
| [[Field-Level Security (FLS, 필드 수준 보안)]] | 필드 view/edit 통제·전 채널(API·리포트 포함)·FLS vs 페이지 레이아웃 | #permission |
| [[User and System Permissions (사용자·시스템 권한)]] | 작업·기능 권한(App/System)·View All/Modify All Data 등 관리자 권한 | #permission |
| [[Custom Permissions (커스텀 권한)]] | 커스텀 프로세스/앱 access check·수식·Apex·Flow에서 체크 | #permission |
| [[Session-Based Permission Sets (세션 기반 권한 집합)]] | 특정 세션 동안만 권한 부여·세션마다 활성화(step-up) | #permission |
| [[Permission Set 접근 설정 (App·System·Apex·VF 접근)]] | permission set의 App/System 범주 + Apex 클래스·VF 페이지 등 Setup Entity Access | #permission |
| [[Integration User & API-Only User (통합 사용자)]] | 통합 실행 전용 사용자 — Salesforce Integration License(무료 5)·API-Only·Minimum Access + PSL·최소권한 설계 | #permission |

---

## 빠른 선택

- 입력값을 화면에 출력할 때 스크립트 주입을 막으려면? → [[XSS 방어]]
- 동적 SOQL에 user input을 넣어야 한다면? → [[SOQL Injection 위협]]
- VF/Lightning에서 요청 위조를 막으려면? → [[CSRF 방어]]
- 외부 호출·cookie를 안전하게 전송하려면(HTTPS/TLS)? → [[Secure Communications (TLS)]]
- 비밀번호·토큰·PII를 어디에 저장? → [[민감 데이터 저장]]
- retURL/redirect 파라미터를 신뢰해도 되나? → [[Arbitrary Redirect 방어]]
- Apex에서 CRUD/FLS·sharing을 어떻게 강제? → [[권한과 접근 제어 위협]]
- Lightning component(Aura/LWC) 보안 모델·CSP? → [[Lightning Security 모델]]
- LWR 사이트 LWS·Locker 대체·cross-namespace·미지원 속성·x-oasis-script(GA/GTM)? → [[Lightning Web Security (LWS)]]
- session ID 오용·postMessage·WebSocket 위협? → [[세션 ID와 브라우저 통신 위협]]
- Marketing Cloud API 통합 보안? → [[Marketing Cloud API 보안]]
- 보안 감사에서 나온 false positive 해명? → [[Platform Security FAQ]]
- 전체 가이드 범위·Flow 보안 원칙부터? → [[Secure Coding 개요]]
- 배포/PR 전에 위협별로 뭘 확인해야 하나(보안 리뷰 체크리스트)? → [[시큐어 코드 리뷰 체크리스트]]
- CRUD/FLS·sharing을 언제 무엇으로 강제하나(USER_MODE vs stripInaccessible vs CanTheUser)? → [[CRUD·FLS·공유 강제 결정 가이드]]
- Experience Cloud 사이트를 게스트/외부 사용자에게 안전하게 노출? → [[Experience Cloud 사이트 보안 — 인증·게스트 사용자]]
- Aura 사이트 CSP·Locker·LWS·third-party 컴포넌트 보안? → [[Experience Cloud 사이트 — CSP·Locker·LWS]]
- 권한을 어디서/무엇으로 관리하나(Profile·Permission Set 큰 그림)? → [[Salesforce 권한 모델 개요]]
- Profile vs Permission Set — 어느 것에 권한을 넣나? → [[Profiles (프로파일)]] · [[Permission Sets (권한 집합)]]
- 직무별로 permission set을 묶고 특정 권한만 끄려면(Muting)? → [[Permission Set Groups (권한 집합 그룹)]]
- 오브젝트 CRUD·View All/Modify All Records를 주려면? → [[Object Permissions (오브젝트 권한 — CRUD·View All·Modify All)]]
- 특정 필드를 숨기거나 read-only로(FLS)? → [[Field-Level Security (FLS, 필드 수준 보안)]]
- View All Data·API Enabled 같은 기능/시스템 권한? → [[User and System Permissions (사용자·시스템 권한)]]
- 커스텀 기능을 권한으로 게이트(수식·Apex·Flow 체크)? → [[Custom Permissions (커스텀 권한)]]
- 세션 동안만 권한을 부여(step-up)? → [[Session-Based Permission Sets (세션 기반 권한 집합)]]
- permission set에서 Apex 클래스·VF 페이지 접근을 열려면? → [[Permission Set 접근 설정 (App·System·Apex·VF 접근)]]
- 외부 시스템 통합을 실행할 전용 사용자(무료 통합 라이선스·API 전용·최소권한)를 만들려면? → [[Integration User & API-Only User (통합 사용자)]]
- 어떤 connected app이 OAuth로 org에 접속 중인지 보고 특정 앱을 차단(Block)하려면? → [[Connected Apps OAuth Usage (OAuth 사용 모니터링)]]
- 누가 언제 무엇을 보고/내보냈는지 로그로 감사하려면(EventLogFile)? → [[Event Monitoring & 보안 감사 (EventLogFile · Real-Time Event Monitoring)]]
- 세션 하이재킹·크리덴셜 스터핑 등 위협을 실시간으로 탐지·대응하려면? → [[Real-Time Event Monitoring & Threat Detection (실시간 이벤트 모니터링 · 위협 탐지)]]

---

## 챕터 매핑 (secure_coding v67.0 Summer '26)

| 챕터 | 파일 |
|---|---|
| Ch1 가이드라인 + Ch2 Flow 보안·실행 컨텍스트 | [[Secure Coding 개요]] |
| Ch3 Session ID (+ Ch13 postMessage + Ch14 WebSocket) | [[세션 ID와 브라우저 통신 위협]] |
| Ch4 XSS | [[XSS 방어]] |
| Ch5 SOQL/SOSL Injection | [[SOQL Injection 위협]] |
| Ch6 CSRF | [[CSRF 방어]] |
| Ch7 Secure Communications (TLS) | [[Secure Communications (TLS)]] |
| Ch8 Storing Sensitive Data | [[민감 데이터 저장]] |
| Ch9 Arbitrary Redirect | [[Arbitrary Redirect 방어]] |
| Ch10 Authorization & Access Control | [[권한과 접근 제어 위협]] |
| Ch11 Lightning Security | [[Lightning Security 모델]] |
| Ch12 Marketing Cloud API | [[Marketing Cloud API 보안]] |
| Ch15 FAQ | [[Platform Security FAQ]] |

---

## 관련 폴더

Apex 보안 구현(Safely·StripInaccessible·CanTheUser) → [[Apex/Security(보안)/index|Apex/Security(보안)]] | LWC 보안 패턴(CSP·DOM XSS) → [[LWC/Security(보안)/index|LWC/Security(보안)]] | 권한 설계 → [[Architecture(아키텍처)/index|Architecture(아키텍처)]]
