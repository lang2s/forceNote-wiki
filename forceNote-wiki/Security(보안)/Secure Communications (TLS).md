---
tags: [Security, SecureCoding, TLS, HTTPS, Secure Cookie, 보안가이드, 위협모델, 전송보안]
source: secure_coding (Secure Coding Guide, v67.0 Summer '26)
created: 2026-06-18
aliases: [Secure Communications, TLS 1.2, HTTPS 요구사항, Secure flag cookie, SSL cipher suite, session fixation, secure cookie]
---

# Secure Communications (TLS)

> Salesforce 외부 호스팅 또는 타 사이트와 중요 정보를 교환하는 앱은 HTTPS가 필수이며, 인증·PII cookie에는 Secure flag를 설정해야 한다 — Salesforce는 TLS 1.2 이상을 독점 사용한다.

---

## 위협 / 요구사항

Salesforce 외부에 호스팅되거나 타 사이트와 중요 정보를 교환하는 앱은 **HTTPS가 필수**다. 인증·인가·PII를 담은 cookie는 **Secure flag** 설정이 필수다(HTTPS로만 전송). Secure가 미설정이면 브라우저가 HTTP로도 cookie를 전송한다. HTTP/HTTPS 양쪽이 가용한 앱의 Salesforce 사용자는 secure site로만 제한한다.

> **Salesforce는 TLS 1.2 이상을 독점 사용하도록 요구한다.** null, export, 40-bit, DES cipher suite는 모두 비활성화되어 있다.

---

## Sample Vulnerability

Secure flag 미설정이 가장 흔한 취약점이다. HTTPS로 cookie를 설정해도 Secure가 없으면 HTTP로 반환된다. 다음을 외부 블로그에 삽입하면:

```html
<img src="http://app.example.com/example-logo.png" />
```

인증된 사용자의 브라우저가 HTTP로 cookie를 노출한다. 공개 Wi-Fi MiTM, SSL stripping으로 다운그레이드가 가능하다.

---

## 테스트

- 로그인 후 URL의 "https"를 "http"로 변경 → 여전히 로그인되면 취약.
- Firefox Cookie Inspector/Cookie Manager add-on으로 Secure flag 확인.
- SSL Labs(`https://www.ssllabs.com/ssldb/`)로 web server 설정 테스트, severe error는 AppExchange 통합 전 수정.
- SSLScan(GitHub)을 대안으로 사용.

---

## How Do I Protect My Apex and Visualforce Applications?

- 모든 리소스(이미지 포함)를 HTTPS로 로드.
- 모든 script를 static resource에서 로드(site, community, Lightning Component, VF page에 적용).
- HTTPS를 독점 사용. HTTP가 필요하면 해당 기능을 unauthenticated로 하거나 별도 session identifier 사용.
- session cookie 만료시간을 낮게(10–20분).
- cookie에 password·privilege level(`admin=true`) 저장 금지.
- URL rewriting 방식의 session 관리를 회피.
- 로그인 성공 시 새 session identifier cookie를 발급(session fixation 방지).

---

## 플랫폼별 가이드 (전수)

- **ASP.NET** — `web.config`의 `<httpCookies domain="www.example.com" requireSSL="true" />` 또는 `HttpCookie.Secure` property. IIS 7.0 SSL 설정.
- **Java** — `javax.servlet.http.Cookie`의 `setSecure(true)`. JSESSIONID/JSESSIONIDSSO는 container가 HTTPS session 생성 시 자동 설정. J2EE는 `web.xml`의 `<security-constraint>` + `<user-data-constraint>` + `<transport-guarantee>CONFIDENTIAL</transport-guarantee>`. Tomcat 5.5/6.0, GlassFish 2.1/3.0 `sun-web.xml`의 `cookieSecure`. Servlet 3.0 `javax.servlet.SessionCookieConfig`.
- **PHP** — `setcookie`의 secure 파라미터 true(기본 false). `session_regenerate_id`로 session fixation 방지.
- **Ruby on Rails** — `CGI::Cookie`의 secure true(기본 false). `reset_session`으로 session fixation 방지.

---

## Configuring Web/App Servers for Strong SSL Cipher Suites (전수)

- **IIS (Windows Server 2003-)** — Windows Registry `HKEY_LOCAL_MACHINE\...\SCHANNEL`. 2008/2008 R2는 Group Policy(`gpedit.msc` → Administrative Templates > Network > SSL Configuration Settings).
- **Apache** — `mod_ssl`의 `SSLCipherSuite`. HIGH ciphers만, SSLv2 비활성화.

성능: HTTPS가 성능 문제의 원인인 경우는 드물다. (Gmail optimization, Yahoo performance best practices 참조)

---

## 관련 노트
- [[CSP와 RemoteSite]]
- [[민감 데이터 저장]]
- [[Marketing Cloud API 보안]]
- [[세션 ID와 브라우저 통신 위협]]
- [[Secure Coding 개요]]
- [[Platform Security FAQ]]
