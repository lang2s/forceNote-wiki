---
tags: [Security, SecureCoding, FAQ, HTTPHeaders, 보안가이드, 위협모델, false positive]
source: secure_coding (Secure Coding Guide, v67.0 Summer '26)
created: 2026-06-18
aliases: [Platform Security FAQ, 보안 FAQ, false positive, secure cookie sid, clickjacking, frame-ancestors, HSTS, HPKP, X-Content-Type-Options nosniff, FRONTDOOR.JSP, JSESSIONID, file upload scan]
---

# Platform Security FAQ

> App Cloud platform 보안 질문과, third-party Security Assessment에서 흔히 나오는 false positive에 대한 공식 설명.

---

## 개요

App Cloud platform 보안 질문과 third-party Security Assessment의 흔한 false positive를 다룬다. 아래 FAQ는 전수다.

Referer header 동작 예(원문) — Salesforce가 third-party domain으로 보낼 때 full URL이 아닌 domain만 노출된다:

```text
요청 URL: https://domain.my.salesforce.com/page.jsp?oid=...&secret=...
third-party로 전송되는 Referer: https://domain.my.salesforce.com
```

---

## FAQ (전수)

- **Secure Cookies** — salesforce.com domain의 일부 cookie가 secure/persistent가 아닌 것은 의도적이다. session 정보가 없는 functionality cookie다. **session cookie "sid"는 secure + non-persistent**다(브라우저를 닫으면 삭제).

- **Data validation** — data validation/quality는 security가 아니다. 대부분 client side에서 강제된다(picklist non-defined 값 API update, standard page edit POST). server side 강제 예: non-existent record ID lookup, field data type(number field에 text 불가), Object Validation Rules/Apex Triggers.

- **Clickjacking** — 사용자가 button/link를 클릭하도록 유도하는 공격. 대부분 Salesforce page는 같은 domain page만 inline frame이 가능하다. Experience Cloud site는 2부분(Experience Cloud site = Salesforce site detail page, Site.com site = Site.com config page) → 동일 값을 권장한다.

- **CSRF** — 기본 활성(Session Settings page). CSRF token은 user·entity·session scope이며 user session 내에서 reuse된다. randomly generated되며 sessionid만큼 획득이 어려워 reuse한다.

- **Cross-Site Scripting** — 모든 standard page가 proper context로 user-controlled data를 output encode한다. VF page는 모든 merge field를 기본 HTML encode한다. custom VF page의 XSS는 개발자 책임이다. context-specific output encoding을 구현한다. input encoding이 필요하면 custom trigger를 쓴다.

- **File Upload** — 악성 파일 업로드가 가능함을 인지한다. **Salesforce에 저장된 파일은 malicious content를 scan하지 않는다**(binary 저장). 일부 file type은 search indexing/preview용으로 파싱된다(isolated environment, limited privilege). multi-tenant model로 app layer가 infrastructure layer를 추상화한다. File Upload and Download Security(Setup)로 관리하고, custom Apex trigger로 extension을 제한할 수 있으며, 외부 add-on으로 모니터링한다.

- **Arbitrary SQL Query Execution** — finding은 SQL이 아닌 **SOQL**이므로 security impact가 없다. REST API call이 access control 기반 query이며 sharing·CRUD/FLS를 강제하므로 권한 없는 것은 미노출된다.

- **FRONTDOOR.JSP SID** — `frontdoor.jsp?sid=<sessionid>`는 login 시 사용할 수 없는 temporary session이다. (temporary session ID는 못 쓰나 SID가 login 시 생성됨)

- **JSESSIONID** — temporary session ID로 cookie exploit이 불가능하다. main session cookie = SID(secure 표시).

- **HTTP Header: X-Content-Type-Options: nosniff** — 악성 파일(JS, Style sheet)의 dynamic content 실행을 방지한다(MIME type 추론 방지). 활성·비활성이 불가능하다(임시 비활성은 Customer Support).

- **HTTP Header: Referer** — URL의 confidential info leak를 방지한다. Salesforce→third-party domain 시 Referer는 Salesforce domain만 담는다(full URL 아님 — 위 개요의 예 참조). 같은 domain 내에서는 unchanged. redirect scope는 외부 URL이 다른 Salesforce org인지에 따라 다르다.

- **HTTP Header: CSP frame-ancestors Directive** — clickjacking을 방어한다. Salesforce가 서빙하는 page는 frame-ancestors로 구현한다. **X-Frame-Options(obsolete)를 대체한다.** VF page는 기본적으로 iframe 로드가 가능하며, header가 있는 VF는 frame-ancestors가 부재하므로 clickjack protection 활성을 권장한다.

- **HTTP Header: Content-Security-Policy-Report-Only** — third-party asset 사용을 모니터링한다(HTTPS site의 HTTP content 탐지). browser(Chrome/Firefox/Safari, IE 아님)가 검사하나 미강제이며, 위반 시 report를 전송한다. 기본 활성(Classic). Lightning은 자체 CSP를 강제한다.

- **HTTP Headers: XSS Protection** — `X-XSS-Protection` header·`reflected-XSS` CSP directive는 모두 **deprecated**다. CSPTrustedSite metadata type 또는 Manage Trusted URLs를 사용한다.

- **HTTP Header: Strict-Transport-Security (HSTS)** — login.salesforce.com, MyDomain login URL, Lightning+content domain, VF, Experience Cloud/Salesforce Sites system-managed domain에 활성이다. 인증된 트래픽만(App Server). registrable custom domain은 setting으로 HSTS를 포함한다(Enable HSTS Preloading).

- **HTTP Public Key Pinning (HPKP)** — valid certificate list를 선언한다. SSL cert chain의 valid public key hash. Salesforce는 **report-only mode**다(cert mismatch 시 content를 차단하지 않음).

- **Browser Caching of HTTP Responses** — 성능용 caching으로 HTTP cache response directive로 제어한다. 주 이슈는 attacker가 local client에 접근하는 경우 → user browser를 not cache로 설정한다. case-by-case로 검토한다.

---

## 관련 노트
- [[Lightning Security 모델]]
- [[CSP와 RemoteSite]]
- [[CSRF 방어]]
- [[XSS 방어]]
- [[SOQL Injection 위협]]
- [[세션 ID와 브라우저 통신 위협]]
- [[Secure Coding 개요]]
