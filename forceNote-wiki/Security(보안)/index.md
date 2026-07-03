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
