---
tags: [index, search, navigation]
created: 2026-06-18
---

# SEARCH INDEX — Security(보안)
> Secure Coding Guide(v67.0 Summer '26) 위협 모델 키워드 → 파일
> XSS·SOQLi·CSRF·Open Redirect·TLS·민감데이터·CRUD/FLS·Lightning보안·세션/브라우저 통신·MC API·FAQ
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.

## 개요 / 원칙

| 키워드 | 파일 |
|---|---|
| Secure Coding Guide, 시큐어코딩 개요, 보안 가이드 범위, Flow 보안, 플로우 실행컨텍스트, User Mode System Mode 플로우, OWASP 레퍼런스, 시큐어 코딩 시작점 | `Security(보안)/Secure Coding 개요.md` |
| secure code review checklist, 시큐어 코드 리뷰, 배포 전 보안 점검, PR 보안 체크리스트, 코드 리뷰 보안, 위협별 점검, XSS SOQL CSRF 점검, Code Analyzer 정적분석, 보안 리뷰 어떻게, 배포 전 뭘 확인 | `Security(보안)/시큐어 코드 리뷰 체크리스트.md` |

## XSS / 인코딩

| 키워드 | 파일 |
|---|---|
| XSS, Cross Site Scripting, 크로스사이트스크립팅, 출력 인코딩, 브라우저 파싱 컨텍스트, XSS 막으려면, 스크립트 주입 방어 | `Security(보안)/XSS 방어.md` |
| JSENCODE, HTMLENCODE, URLENCODE, JSINHTMLENCODE, VF 인코딩 함수, secureFilters, HTML 인코딩표, Visualforce 인코딩 함수 어떻게 | `Security(보안)/XSS 방어.md` |

## 인젝션

| 키워드 | 파일 |
|---|---|
| SOQL Injection, SOQL 인젝션, SQL Injection 방어, escapeSingleQuotes, bind variable 보안, 동적 SOQL에 입력값 넣어도 되나, isSafeObject, isSafeField, SOSL injection, queryWithBinds 방어, 화이트리스트 쿼리 | `Security(보안)/SOQL Injection 위협.md` |

## CSRF

| 키워드 | 파일 |
|---|---|
| CSRF, Cross Site Request Forgery, 크로스사이트요청위조, 요청위조 방어, page load DML, action 속성 CSRF, Require CSRF protection on GET, 자동 보호 범위 | `Security(보안)/CSRF 방어.md` |

## 전송 보안 (TLS)

| 키워드 | 파일 |
|---|---|
| Secure Communications, TLS 1.2, HTTPS 요구사항, Secure flag cookie, secure cookie, SSL cipher suite, session fixation, HTTPS로 안전하게 통신 | `Security(보안)/Secure Communications (TLS).md` |

## 민감 데이터 저장

| 키워드 | 파일 |
|---|---|
| Storing Sensitive Data, 민감 데이터 저장, PII 저장, Protected Custom Metadata, Protected Custom Settings, Apex Crypto, Encrypted Custom Fields, Named Credentials, salt hash, bcrypt, 비밀번호 토큰 어디 저장 | `Security(보안)/민감 데이터 저장.md` |

## 리다이렉트

| 키워드 | 파일 |
|---|---|
| Arbitrary Redirect, Open Redirect, 임의 리다이렉트, retURL 조작, PageReference 감사, HTTP Response Splitting, allowlist redirect, 리다이렉트 파라미터 신뢰, 피싱 우회 | `Security(보안)/Arbitrary Redirect 방어.md` |

## 권한 / 접근 제어

| 키워드 | 파일 |
|---|---|
| Authorization and Access Control, 권한 접근 제어, CRUD FLS bypass, AccessLevel, USER_MODE 장점, stripInaccessible, with sharing, inherited sharing, privilege escalation, Apex에서 권한 강제하는 법 | `Security(보안)/권한과 접근 제어 위협.md` |
| DescribeSObjectResult 권한, isAccessible, isCreateable, isUpdateable, isDeletable, sharing violation, 필드 레벨 보안 검사 | `Security(보안)/권한과 접근 제어 위협.md` |
| CRUD FLS 강제, 접근 제어 강제, WITH USER_MODE vs stripInaccessible, CanTheUser 언제, Safely 언제, with sharing FLS, 접근 제어 언제 뭘 쓰나, USER_MODE 결정, stripInaccessible 언제, sharing 키워드 선택, Apex 보안 강제 결정 | `Security(보안)/CRUD·FLS·공유 강제 결정 가이드.md` |

## 공유 모델 (OWD / 공유 규칙)

| 키워드 | 파일 |
|---|---|
| OWD, Organization-Wide Defaults, sharing rules, owner-based, criteria-based sharing rule, Grant Access Using Hierarchies, External Sharing Model, 조직 전체 기본값, 공유 규칙, 소유 기반 공유 규칙, 기준 기반 공유 규칙, OWD 어떻게 설정, 공유 규칙 만드는 법, 외부 사용자 공유 | `Admin(어드민)/조직 전체 공유 기본값(OWD)과 공유 규칙.md` |

## 권한 모델 (Profile · Permission Set · 권한 종류)

| 키워드 | 파일 |
|---|---|
| permissions model, 권한 모델, permissions and access settings, profile vs permission set, grant not deny, 권한 종류, 접근 설정, 권한 어디서 관리 | `Security(보안)/Salesforce 권한 모델 개요.md` |
| Profiles, 프로파일, standard profile, custom profile, Minimum Access Salesforce, login hours, login IP ranges, 프로파일이란 | `Security(보안)/Profiles (프로파일).md` |
| Permission Sets, 권한 집합, permset, standard/integration/session-based permission set, 권한 추가 부여, 권한 집합 할당 | `Security(보안)/Permission Sets (권한 집합).md` |
| Permission Set Groups, 권한 집합 그룹, PSG, muting permission set, 뮤팅, combined permissions, 직무별 권한 묶기 | `Security(보안)/Permission Set Groups (권한 집합 그룹).md` |
| Object Permissions, 오브젝트 권한, CRUD, create read edit delete, View All Records, Modify All Records, View All Fields, 오브젝트 권한 공유 무시 | `Security(보안)/Object Permissions (오브젝트 권한 — CRUD·View All·Modify All).md` |
| Field-Level Security, FLS, 필드 수준 보안, field permissions, 필드 권한, read-only field, FLS vs page layout, 필드 숨기기 | `Security(보안)/Field-Level Security (FLS, 필드 수준 보안).md` |
| User Permissions, System Permissions, App Permissions, 사용자 권한, 시스템 권한, View All Data, Modify All Data, API Enabled, View Setup and Configuration | `Security(보안)/User and System Permissions (사용자·시스템 권한).md` |
| Custom Permissions, 커스텀 권한, access check, FeatureManagement.checkPermission, $Permission, 커스텀 권한으로 기능 게이트 | `Security(보안)/Custom Permissions (커스텀 권한).md` |
| Session-Based Permission Sets, 세션 기반 권한 집합, SessionPermSetActivation, session activation required, step-up 접근 | `Security(보안)/Session-Based Permission Sets (세션 기반 권한 집합).md` |
| App Settings, System Settings, Apex class access, Visualforce page access, setup entity access, connected app access, 접근 설정 | `Security(보안)/Permission Set 접근 설정 (App·System·Apex·VF 접근).md` |
| Integration User, 통합 사용자, API-Only User, Salesforce Integration License, 통합 라이선스 무료 5개, Minimum Access API Only Integrations, Salesforce API Integration PSL, 통합 사용자 최소권한 설계 | `Security(보안)/Integration User & API-Only User (통합 사용자).md` |

## Lightning 보안

| 키워드 | 파일 |
|---|---|
| Lightning Security, Lightning Locker, CSP Directives, Lightning component 보안, AuraEnabled 보안, with sharing controller, Lightning CRUD FLS, Lightning XSS, Lightning CSRF, unsafe attribute, secret inputs, LWC 보안 모델 | `Security(보안)/Lightning Security 모델.md` |
| Lightning Web Security, LWS, Lightning Locker, secure wrapper, namespace sandbox, cross-namespace, x-oasis-script, Privileged Script Tag, LWS 활성화, LWS vs Locker 차이, Locker에서 LWS 전환, LWR 보안, LWS 미지원 속성, third-party script LWR, GA/GTM LWR 사이트 | `Security(보안)/Lightning Web Security (LWS).md` |

## Experience Cloud 사이트 보안

| 키워드 | 파일 |
|---|---|
| Experience Cloud site security, guest user security, 게스트 사용자 보안, Unauthenticated Guest User, 인증 안 된 게스트 사용자, declarative access control, custom access control, without sharing 게스트, system mode without sharing, 게스트 레코드 read create update, Encrypt Record IDs, 레코드 ID 암호화, UserCryptoHelper, encrypted token 패턴, Limit Access to Apex Classes, Flow Security 게스트, Experience Cloud SOQL injection, 게스트가 만든 레코드 나중에 읽기, Experience Cloud 사이트를 게스트에게 안전하게 노출하려면 | `Security(보안)/Experience Cloud 사이트 보안 — 인증·게스트 사용자.md` |
| Aura 사이트 Locker, Relaxed CSP, Strict CSP, allowInRelaxedCSP, lightningCommunity__RelaxedCSP, third-party 컴포넌트 Locker off, Adobe Analytics Aura, Lightning Locker 끄기, LWS org/site 레벨 전환, Experience Cloud CSP, Aura 사이트 보안 레이어, forceCommunity routeChange, Aura 사이트에서 third-party 컴포넌트 어떻게 실행, Locker 충돌 해결 | `Security(보안)/Experience Cloud 사이트 — CSP·Locker·LWS.md` |

## 세션 / 브라우저 통신

| 키워드 | 파일 |
|---|---|
| Session ID 보안, managed package session, namespace 보호 우회, postMessage, targetOrigin, Cross-Site WebSocket Hijacking, CSWSH, WSS, Same Origin Policy, JWT ECA, External Client App, 세션 ID 오용 | `Security(보안)/세션 ID와 브라우저 통신 위협.md` |

## 통합 보안 (Marketing Cloud)

| 키워드 | 파일 |
|---|---|
| Marketing Cloud Engagement API 보안, MC API security, least privilege OAuth, refresh token storage, XML API 금지, OWASP Top Ten checklist, MC 통합 보안 | `Security(보안)/Marketing Cloud API 보안.md` |

## FAQ / HTTP 헤더

| 키워드 | 파일 |
|---|---|
| Platform Security FAQ, 보안 FAQ, false positive, secure cookie sid, clickjacking, frame-ancestors, HSTS, HPKP, X-Content-Type-Options nosniff, FRONTDOOR.JSP, JSESSIONID, file upload scan, 보안 감사 오탐 | `Security(보안)/Platform Security FAQ.md` |
