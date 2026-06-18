---
tags: [Security, SecureCoding, MarketingCloud, API, OAuth, 보안가이드, 위협모델, 통합보안]
source: secure_coding (Secure Coding Guide, v67.0 Summer '26)
created: 2026-06-18
aliases: [Marketing Cloud Engagement API 보안, MC API security, least privilege OAuth, refresh token storage, XML API 금지, OWASP Top Ten checklist]
---

# Marketing Cloud API 보안

> Marketing Cloud Engagement API를 다른 API처럼 취급하되, least privilege·secure storage·TLS·금지 endpoint 등 추가 고려사항과 composite app의 OWASP Top Ten 검토를 적용한다.

---

## 위협 / 추가 고려사항 (전수)

MC Engagement API는 다른 API처럼 취급하며, 다음 추가 고려사항을 적용한다:

- **Enforce least privilege** — OAuth token에 최소 필요 scope만 요청.
- **Secure storage** — refresh token만 외부 web server에 저장, access token은 memory에만(필요 시 신규 요청). refresh token은 Salesforce credential처럼 취급.
- **Secure in transit** — MC API 호출 시 TLS 강제. access token은 Authorization header로만 전달(query parameter 금지). 최신 TLS 설정 유지.
- **Prohibited API endpoints** — **XML API 사용 금지**(미지원, Enterprise 2.0 account 비호환, AppExchange 불허).

> OAuth/Named Credentials의 secure storage 메커니즘은 [[민감 데이터 저장]]·[[Auth Namespace]] 참조. TLS 요구사항은 [[Secure Communications (TLS)]] 참조.

```javascript
// 구조 예시 — 실제 동작 코드 아님 (MC API 호출 시 권장 패턴 개념)
fetch("https://<subdomain>.rest.marketingcloudapis.com/...", {
  method: "GET",
  headers: { "Authorization": "Bearer " + accessToken } // header로만, query 금지
});
```

---

## Composite App Pentesting — OWASP Top Ten checklist

composite app pentesting은 OWASP Top Ten checklist를 사용한다. 구체 이슈(각 OWASP 링크 포함 — 전수):

- **Authentication (Session management)** — secure session 생성·관리·종료, session ID rotation·cookie flag, framework session 관리 기능 선호.
- **Access Control** — session·permission 검증(standard user의 admin page 접근, user A의 user B history 조회 방지).
- **Sensitive Information in errors** — stack trace·debug log 숨김(fingerprinting/enumeration 방지).
- **CSRF** — 인증된 사용자의 unwanted action 유도(URL/FORM crafting).
- **HTML injection and XSS** — 악성 HTML(예: `<iframe>`)/JS 주입.
- **Arbitrary Redirects** — user-controlled data redirect, permission check 우회.
- **Remote Code Execution** — 3 source(취약 service의 open port, 취약 component(gem/node/library, XML 파싱 등), serialized data deserialization).
- **Using Insecure Software** — third-party component를 최신 버전·known vuln 없는 버전으로.
- **SQL Injection** — input data로 SQL query 주입.
- **Storage of sensitive Data** — password/신용카드/SSN/PII 안전 저장.

---

## 관련 노트
- [[민감 데이터 저장]]
- [[Secure Communications (TLS)]]
- [[Auth Namespace]]
- [[SOQL Injection 위협]]
- [[XSS 방어]]
- [[CSRF 방어]]
- [[Arbitrary Redirect 방어]]
- [[Secure Coding 개요]]
- [[Platform Security FAQ]]
