---
tags: [lwc, security, csp, trusted-sites, reference]
source: help.salesforce.com — "CSP Trusted Sites" · "Content Security Policy Protections"; developer.salesforce.com — LWC Dev Guide "Content Security Policy" (Tier 2)
created: 2026-07-08
aliases: [CSP, Content Security Policy, CSP Trusted Sites, Trusted URLs, connect-src, frame-src, img-src, style-src, font-src, media-src, CSP 신뢰 사이트, 콘텐츠 보안 정책]
---

# CSP · Trusted Sites 레퍼런스

> Content Security Policy는 브라우저가 로드·실행할 리소스 출처를 제한하는 정책이다. LEX/Experience Cloud는 엄격 CSP를 적용하므로, LWC가 외부 도메인에서 리소스를 로드하거나 API를 호출하려면 **CSP Trusted Sites**에 지시자(directive)별로 도메인을 등록해야 한다.

---

## CSP란 — 브라우저 레이어 정책

Content Security Policy(CSP)는 W3C 표준으로, 웹 페이지가 어떤 출처(origin)에서 스크립트·이미지·스타일·폰트·미디어·프레임·네트워크 연결을 허용할지 서버가 HTTP 응답 헤더(`Content-Security-Policy`)로 선언하는 방어 계층이다. 브라우저는 이 정책에 위배되는 리소스 로드를 **차단**하고 콘솔에 `Refused to ...` 에러를 남긴다. 주 목적은 XSS·데이터 인젝션 완화다.

Salesforce Lightning Experience(LEX)와 Experience Cloud LWR 사이트는 **엄격한(strict) CSP**를 브라우저에 강제한다. 개발자가 헤더를 직접 쓰는 게 아니라, 플랫폼이 정책을 발행하고 Trusted Sites 등록 내용을 그 정책에 반영한다.

### LEX 엄격 CSP가 금지하는 것

| 금지 대상 | 설명 |
|---|---|
| **인라인 스크립트** | `<script>...</script>`, `onclick="..."` 등 인라인 이벤트 핸들러 실행 불가 (`unsafe-inline` 미허용) |
| **`eval()` / `new Function()`** | 문자열을 코드로 컴파일하는 동적 실행 불가 (`unsafe-eval` 미허용) |
| **미등록 외부 도메인** | Trusted Site에 없는 도메인으로의 `<img>`·`fetch`·`<iframe>`·`@font-face` 등 차단 |
| **`javascript:` URL** | 링크·src의 `javascript:` 스킴 차단 |

> LWC는 표준·구조화된 렌더링만 허용하므로 애초에 인라인 스크립트를 쓸 수 없다. 이는 CSP 위반이 아니라 프레임워크 설계다. 외부 JS는 **Static Resource로 번들링**해 `loadScript()`로 로드하면 CSP 등록 없이 동작한다(같은 오리진).

---

## CSP 지시자(directive)와 LWC 영향

CSP Trusted Site를 등록할 때 도메인을 어떤 **지시자**에 허용할지 체크박스로 고른다. 각 지시자는 브라우저가 특정 리소스 유형을 로드할 때 검사하는 화이트리스트다.

| 지시자 | 제어하는 리소스 | LWC에서 발생하는 상황 |
|---|---|---|
| `connect-src` | `fetch()`, `XMLHttpRequest`, `WebSocket`, `EventSource`, `navigator.sendBeacon` | LWC가 외부 REST API를 직접 호출하거나 WebSocket을 연결할 때 |
| `frame-src` | `<iframe>` 소스 | LWC에서 외부 페이지를 iframe으로 임베드할 때 |
| `img-src` | `<img>`, CSS `background-image`, `favicon` | 외부 이미지/타일(예: 지도)을 로드할 때 |
| `style-src` | 외부 스타일시트(`<link rel="stylesheet">`) | 외부 CSS를 로드할 때 (인라인 `<style>`은 플랫폼이 별도 처리) |
| `font-src` | `@font-face`로 로드하는 웹폰트 | 외부 폰트 파일을 로드할 때 |
| `media-src` | `<audio>`, `<video>` 소스 | 외부 오디오/비디오를 재생할 때 |

> `script-src`는 **사용자가 임의 외부 도메인으로 열 수 없다.** 엄격 CSP의 핵심이 스크립트 출처 제한이기 때문이다. 외부 JS는 Static Resource(같은 오리진) 경로를 쓴다.

---

## CSP Trusted Sites 설정 (Setup UI)

**Setup → Security → CSP Trusted Sites → New**

| 필드 | 설명 |
|---|---|
| **Trusted Site Name** | API 이름. 문자로 시작, 영숫자/언더스코어만, 공백 불가 |
| **Trusted Site URL** | 허용할 출처. `https://` 스킴 포함 (예: `https://api.example.com`). 포트 지정 가능 |
| **Description** | (선택) 용도 메모 |
| **Active** | 체크 시 정책에 즉시 반영. 해제하면 등록은 남되 적용 안 됨 |
| **Context** | 이 사이트가 적용될 범위 (아래 표) |
| **CSP Directives** | 이 도메인을 허용할 지시자 체크박스: `connect-src` / `frame-src` / `img-src` / `style-src` / `font-src` / `media-src` |
| **Permissions** | (선택) `Allow site to access camera` · `Allow site to access microphone` — 미디어 장치 접근 허용 |

### Context 값

| UI 선택 | 메타데이터 `context` | 적용 범위 |
|---|---|---|
| All | `All` | LEX + Experience Cloud 모두 |
| Lightning Experience and Salesforce Mobile App | `LEX` | LEX / 모바일 앱만 |
| Communities / Sites | `Communities` | Experience Cloud 사이트만 |

> 두 환경을 모두 커버하려면 `All`. LEX용 등록은 Experience Cloud에 적용되지 않으므로 사이트에서 외부 리소스가 필요하면 별도 등록하거나 `All`로 만든다.

### 와일드카드 규칙

| 패턴 | 매칭 |
|---|---|
| `https://api.example.com` | 정확히 그 호스트만 |
| `https://*.example.com` | 모든 서브도메인 (`a.example.com`, `b.example.com`) — **`*`는 도메인 맨 앞에만** |
| `https://example.com:8443` | 포트까지 일치해야 함 |

`*` 를 중간·뒤에 두거나(`https://ex*.com`) 스킴 없이 등록하는 형태는 유효하지 않다. 서브도메인 와일드카드는 상위 도메인 이전(leftmost label)에만 허용된다.

### 메타데이터로 정의 (`CspTrustedSite`)

```xml
<!-- 구조 예시 — cspTrustedSites/apiExample.cspTrustedSite-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<CspTrustedSite xmlns="http://soap.sforce.com/2006/04/metadata">
    <endpointUrl>https://api.example.com</endpointUrl>
    <context>All</context>
    <isActive>true</isActive>
    <isApplicableToConnectSrc>true</isApplicableToConnectSrc>  <!-- fetch/XHR/WebSocket -->
    <isApplicableToImgSrc>true</isApplicableToImgSrc>
    <isApplicableToStyleSrc>false</isApplicableToStyleSrc>
    <isApplicableToFontSrc>false</isApplicableToFontSrc>
    <isApplicableToFrameSrc>false</isApplicableToFrameSrc>
    <isApplicableToMediaSrc>false</isApplicableToMediaSrc>
    <canAccessCamera>false</canAccessCamera>
    <canAccessMicrophone>false</canAccessMicrophone>
</CspTrustedSite>
```

---

## fetch / XHR / WebSocket을 위한 connect-src

LWC가 외부 API를 브라우저에서 직접 호출하는 경로다. `connect-src`가 등록돼 있지 않으면 `fetch()`는 `Refused to connect to '...' because it violates the ... Content Security Policy directive: "connect-src ..."` 로 실패한다.

```javascript
// 구조 예시 — 외부 API 호출 전 connect-src 등록 필요
const BASE_URL = 'https://api.example.com/';

async loadData(query) {
    // CSP Trusted Site: URL=https://api.example.com, connect-src 체크
    const res = await fetch(BASE_URL + encodeURIComponent(query));
    if (!res.ok) {
        throw new Error(`HTTP ${res.status}`);
    }
    return res.json();
}
```

> ⚠️ **CSP 등록은 절반일 뿐** — 브라우저에서 직접 호출(cross-origin)하면 **외부 서버도 CORS 응답 헤더(`Access-Control-Allow-Origin`)를 돌려줘야** 브라우저가 응답을 통과시킨다. CSP는 Salesforce(요청 측) 설정, CORS는 외부 서버(응답 측) 설정이라 둘 다 필요하다. 그래서 민감/인증이 필요한 호출은 브라우저 fetch보다 **Apex + Named Credential**이 권장된다(FLS/CRUD 검증·토큰 관리·CSP 불필요).

---

## Trusted URLs (Winter '23+) — 통합 관리 화면

Winter '23부터 Salesforce는 **CSP Trusted Sites와 Remote Site Settings를 하나의 관리 화면으로 통합**했다: **Setup → Security → Trusted URLs**. 이 페이지에서 두 종류의 신뢰 URL을 한곳에서 보고 편집할 수 있으며, 기존 CSP Trusted Sites / Remote Site Settings 개별 화면도 유지된다. 한 URL에 대해 CSP 지시자(브라우저)와 서버 콜아웃 허용(Remote Site)을 함께 관리하기 위한 것으로, 등록의 **의미 자체는 변하지 않는다** — 지시자 매핑·context·와일드카드 규칙은 위와 동일하다.

---

## CSP Trusted Site vs Remote Site Setting — 반드시 구분

두 설정은 **요청이 발생하는 레이어가 다르다.** 목적을 혼동하면 엉뚱한 곳에 등록하고 계속 막힌다.

| | CSP Trusted Site | Remote Site Setting |
|---|---|---|
| 레이어 | **브라우저** (LWC의 fetch/img/iframe 등) | **Salesforce 서버** (Apex `Http.send()`) |
| 검사 주체 | 사용자 브라우저 (CSP 헤더) | Salesforce 런타임 (엔드포인트 허용목록) |
| 미등록 시 오류 | 콘솔 `Refused to connect/load` | `System.CalloutException: Unauthorized endpoint` |
| 등록 대상 | 지시자별 도메인 | 콜아웃 대상 URL |
| 면제 경로 | Static Resource(같은 오리진) | Named Credential |

> 요청 방향까지 포함한 3-way(아웃바운드 서버 = Remote Site/Named Credential · 아웃바운드 브라우저 = CSP Trusted Site · 인바운드 = CORS allowlist) 결정표는 [[CSP와 RemoteSite]]에 정리돼 있다.

---

## 관련 노트

- [[LWC 보안 패턴]] — 외부 REST API 호출·권한 기반 UI 등 LWC 보안 패턴 모음
- [[CSP와 RemoteSite]] — CSP·Remote Site·CORS 3-way 결정표 및 메타데이터 상세
- [[LWC MOC]] — LWC 섹션 전체 목차
