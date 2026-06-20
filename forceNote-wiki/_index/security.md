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

## XSS / 인코딩

| 키워드 | 파일 |
|---|---|
| XSS, Cross Site Scripting, 크로스사이트스크립팅, 출력 인코딩, 브라우저 파싱 컨텍스트, XSS 막으려면, 스크립트 주입 방어 | `Security(보안)/XSS 방어.md` |
| JSENCODE, HTMLENCODE, URLENCODE, JSINHTMLENCODE, VF 인코딩 함수, secureFilters, HTML 인코딩표, Visualforce 인코딩 함수 어떻게 | `Security(보안)/XSS 방어.md` |

## 인젝션

| 키워드 | 파일 |
|---|---|
| SOQL Injection, SOQL 인젝션, SQL Injection 방어, escapeSingleQuotes, bind variable 보안, 동적 SOQL에 입력값 넣어도 되나, isSafeObject, isSafeField, SOSL injection | `Security(보안)/SOQL Injection 위협.md` |

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

## Lightning 보안

| 키워드 | 파일 |
|---|---|
| Lightning Security, Lightning Locker, CSP Directives, Lightning component 보안, AuraEnabled 보안, with sharing controller, Lightning CRUD FLS, Lightning XSS, Lightning CSRF, unsafe attribute, secret inputs, LWC 보안 모델 | `Security(보안)/Lightning Security 모델.md` |
| Lightning Web Security, LWS, Lightning Locker, secure wrapper, namespace sandbox, cross-namespace, x-oasis-script, Privileged Script Tag, LWS 활성화, LWS vs Locker 차이, Locker에서 LWS 전환, LWR 보안, LWS 미지원 속성, third-party script LWR, GA/GTM LWR 사이트 | `Security(보안)/Lightning Web Security (LWS).md` |

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
