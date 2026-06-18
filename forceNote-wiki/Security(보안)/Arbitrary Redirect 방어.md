---
tags: [Security, SecureCoding, OpenRedirect, Redirect, 보안가이드, 위협모델, 피싱]
source: secure_coding (Secure Coding Guide, v67.0 Summer '26)
created: 2026-06-18
aliases: [Arbitrary Redirect, Open Redirect, 임의 리다이렉트, retURL 조작, PageReference 감사, HTTP Response Splitting, allowlist redirect, open redirect 피싱, 리다이렉트 URL 파라미터 검증, retURL 외부 사이트로 보내져도 되나, 리다이렉트로 피싱 막는 법]
---

# Arbitrary Redirect 방어

> user-controlled value로 동적 redirect를 수행하면 임의 URL(피싱 사이트)로 redirect될 수 있다 — known-safe URL allowlist 매칭으로만 redirect한다.

---

## 위협

site의 redirect 메커니즘(server side: PHP/JSP/ASP, client side: JS)이 user-controlled value로 dynamic redirect를 수행하면, 임의 URL로 redirect가 가능하다.

세션 만료 후 page P로 복귀하는 hidden field 패턴이 흔하다:

```html
<input type="hidden" name="page" value="/someImportantAction.jsp" />
```
```
HTTP/1.1 302 Found
Location: /someImportantAction.jsp
```

문제는 **user-controlled value로 redirect**할 때다 → phishing(예: `retURL` 파라미터 조작, `%68%74%74%70...` URL 인코딩으로 evil.com 위장). referrer header로 GET request의 sensitive data가 leak된다. client side에서는 hash fragment redirect(`location.hash.substring(1)` → `window.location`)가 위험하다.

**HTTP Response Splitting:** `%0d%0a`(\r\n)를 주입해 `Set-Cookie` 등 header를 제어한다.

### Sample Vulnerability (C#)

```csharp
string url = request.QueryString["url"];
Response.Redirect(url);
```

---

## 테스트

다양한 URL scheme(`http://`, `https://`, `ftp://`, `data://`, `javascript:`)과 다양한 domain(example.com, evil.com 등)을 입력해 본다.

---

## How Do I Protect My Application?

known-safe URL/URI 패턴 매칭으로만 redirect한다(**allowlist**).

### Apex / Visualforce

- `PageReference` 사용을 audit(allowlist 확인).
- client side `window.location` 할당을 allowlist로 검증.
- **`retUrl`이 플랫폼에 의해 sanitize된다고 가정 금지.**

### General Guidance

hostname allowlist 검증(원문 C# 코드 — GoodDomains 배열 + `url.Host` 매칭), scheme 검사:

```csharp
// hostname allowlist + scheme 검사 (원문 패턴)
if (!url.Scheme.Equals("https")) {
  throw new Exception();
}
// GoodDomains 배열과 url.Host 매칭
```

### 플랫폼별 audit 대상 (전수)

- **ASP.NET** — `Response.Redirect()` audit.
- **Java** — `HttpServletResponse.sendRedirect()` audit.
- **PHP** — `header('location: <URL>')`, `fopen()` audit. `php.ini`의 `allow_url_fopen` off.
- **Ruby on Rails** — `redirect_to()` audit.

---

## Lightning에서의 Arbitrary Redirect

> Lightning component에서의 third-party redirect 방어(HTTPS 강제 + domain hardcode/custom setting)는 [[Lightning Security 모델]]의 "Arbitrary Redirect" 섹션 참조.

---

## 관련 노트
- [[Lightning Security 모델]]
- [[Secure Communications (TLS)]]
- [[XSS 방어]]
- [[Secure Coding 개요]]
- [[Platform Security FAQ]]
