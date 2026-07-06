---
tags: [security, csp, remote-site, integration, pattern]
source: dreamhouse-lwc/cspTrustedSites, remoteSiteSettings; Salesforce REST API Developer Guide — Configure Salesforce CORS Allowlist (Tier 2)
created: 2026-05-17
aliases: [CSP Trusted Site, Remote Site, 외부 연동 보안, CORS, CORS allowlist, 인바운드 cross-origin]
---

# CSP Trusted Sites & Remote Site Settings

> 외부 서비스를 LWC 또는 Apex에서 사용할 때 반드시 등록해야 하는 두 가지 보안 설정. 미등록 시 브라우저 CSP 차단 또는 callout 오류 발생.

---

## 개념

Salesforce에서 외부 서비스를 연동할 때는 요청이 발생하는 **레이어에 따라 서로 다른 보안 설정**이 필요하다.

**CSP Trusted Site**는 브라우저 레이어에서 동작한다. 브라우저는 기본적으로 Same-Origin Policy에 따라 현재 도메인과 다른 도메인으로의 요청을 차단한다. Salesforce는 여기에 더해 Content Security Policy(CSP) 헤더를 통해 허용 도메인을 명시적으로 제한한다. LWC에서 외부 이미지를 `<img>` 태그로 로드하거나, `fetch()`로 외부 API를 직접 호출하거나, `loadScript()`로 외부 JS를 가져올 때 모두 브라우저가 CSP를 검사한다. 미등록 도메인은 브라우저 콘솔에 `Refused to connect` 에러가 발생한다.

**Remote Site Setting**은 서버 레이어에서 동작한다. Apex의 `Http.send()`는 브라우저가 아닌 Salesforce 서버에서 실행되므로 브라우저 CSP와 무관하다. 대신 Salesforce는 서버에서 나가는 HTTP callout 대상 URL을 허용 목록으로 관리한다. 미등록 URL로 callout을 시도하면 `System.CalloutException: Unauthorized endpoint` 에러가 발생한다.

Named Credential을 통한 callout은 Remote Site Setting 등록이 면제된다. Named Credential 자체가 허용된 엔드포인트를 정의하기 때문이다.

---

## 결정 매트릭스

| 사용 목적 | 필요한 설정 |
|---|---|
| LWC에서 외부 이미지 로드 | CSP Trusted Site (`isApplicableToImgSrc=true`) |
| LWC에서 외부 API 호출 (fetch) | CSP Trusted Site (`isApplicableToConnectSrc=true`) |
| LWC에서 외부 JS 로드 (`loadScript`) | Static Resource 사용 권장 (CSP 우회) |
| Apex에서 외부 HTTP callout | Remote Site Setting |
| Apex + Named Credential | Named Credential만 등록 (Remote Site 불필요) |

---

## CSP Trusted Site 메타데이터

```xml
<!-- cspTrustedSites/openStreetMap.cspTrustedSite-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<CspTrustedSite xmlns="http://soap.sforce.com/2006/04/metadata">
    <context>LEX</context>
    <endpointUrl>https://tile.openstreetmap.org</endpointUrl>
    <isActive>true</isActive>

    <!-- 이미지 src 허용 (img 태그, CSS background-image) -->
    <isApplicableToImgSrc>true</isApplicableToImgSrc>

    <!-- API 호출 허용 (fetch, XMLHttpRequest) -->
    <isApplicableToConnectSrc>false</isApplicableToConnectSrc>

    <!-- 폰트 파일 허용 -->
    <isApplicableToFontSrc>false</isApplicableToFontSrc>

    <!-- iframe 허용 -->
    <isApplicableToFrameSrc>false</isApplicableToFrameSrc>

    <!-- 미디어(video/audio) 허용 -->
    <isApplicableToMediaSrc>false</isApplicableToMediaSrc>

    <!-- 스타일시트 허용 -->
    <isApplicableToStyleSrc>false</isApplicableToStyleSrc>

    <!-- 카메라/마이크 -->
    <canAccessCamera>false</canAccessCamera>
    <canAccessMicrophone>false</canAccessMicrophone>
</CspTrustedSite>
```

### context 값

| 값 | 적용 범위 |
|---|---|
| `LEX` | Lightning Experience (기본) |
| `Communities` | Experience Cloud |
| `All` | LEX + Communities |

---

## Remote Site Setting 메타데이터

```xml
<!-- remoteSiteSettings/nominatim.remoteSite-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<RemoteSiteSetting xmlns="http://soap.sforce.com/2006/04/metadata">
    <disableProtocolSecurity>false</disableProtocolSecurity>
    <isActive>true</isActive>
    <url>https://nominatim.openstreetmap.org</url>
</RemoteSiteSetting>
```

> `disableProtocolSecurity=true` — HTTPS 검증 무시 (프로덕션에서는 절대 사용 금지).

---

## 실제 사용 예 (dreamhouse-lwc)

dreamhouse-lwc의 외부 연동 구조:

```
OpenStreetMap tiles (이미지)
  └── CSP Trusted Site: openStreetMap (isApplicableToImgSrc=true)
  └── Static Resource: leafletjs (JS/CSS — CSP 우회)

Nominatim Geocoding API (Apex callout)
  └── Remote Site Setting: nominatim_openstreetmap
  └── GeocodingService.cls → @InvocableMethod(callout=true)
```

---

## CSP vs Named Credential

| | CSP Trusted Site | Named Credential |
|---|---|---|
| 대상 | LWC (브라우저) | Apex callout |
| 인증 정보 | 없음 | OAuth / Basic Auth |
| URL 방식 | 도메인 등록 | `callout:NC_Name` |
| 관리 위치 | 메타데이터 XML | Setup > Named Credentials |

---

## CORS — 인바운드 cross-origin (방향이 반대)

> ⚠️ **CSP Trusted Site / Remote Site Setting과 CORS는 요청 방향이 정반대다.**

지금까지 다룬 CSP Trusted Site·Remote Site Setting은 모두 **Salesforce가 외부로 나가는(아웃바운드)** 요청을 허용하는 설정이다. 반대로 **CORS allowlist는 외부 웹페이지의 브라우저 JavaScript가 Salesforce API로 들어오는(인바운드) cross-origin 요청**을 허용하는 설정이다.

| | CSP Trusted Site / Remote Site | CORS allowlist |
|---|---|---|
| 방향 | **아웃바운드** (SF → 외부) | **인바운드** (외부 브라우저 JS → SF API) |
| 무엇을 허용 | SF가 외부 도메인에 접근 | 외부 오리진이 SF에 접근 |
| 등록 대상 | 외부 서비스 URL/도메인 | 요청을 보내는 **오리진**(`https://origin`) |

외부 도메인(예: `https://myapp.example.com`)에 호스팅된 웹앱의 브라우저 JS가 Salesforce REST API를 직접 호출하려 하면, 브라우저는 Same-Origin Policy에 따라 preflight(`OPTIONS`) 요청을 보낸다. 이때 **해당 오리진이 Salesforce CORS allowlist에 등록돼 있으면** Salesforce가 응답에 `Access-Control-Allow-Origin` 헤더로 그 오리진을 돌려주고, 브라우저가 실제 요청을 진행한다. 등록돼 있지 않으면 Salesforce는 **HTTP 403**을 반환하고 브라우저가 요청을 차단한다.

### 설정

**Setup → Security → CORS** → allowlist에 오리진을 추가한다.

| 항목 | 규칙 |
|---|---|
| 오리진 형식 | `https://origin`(+선택적 포트). HTTPS 프로토콜 필수 (localhost 제외) |
| 와일드카드 | `*`는 2차 도메인 **앞에만** 허용 — `https://*.example.com`(모든 서브도메인). `*example.com`, 도메인 없는 `*`는 무효 |
| 메타데이터 타입 | `CorsWhitelistOrigin` |

### 지원 API

REST API, Apex REST 리소스, Lightning Out을 비롯해 브라우저에서 호출 가능한 Salesforce API(Bulk API, Connect REST / Chatter REST, UI API, GraphQL 등)가 CORS allowlist를 통해 cross-origin으로 접근 가능하다.

### 인증은 여전히 필요

> CORS allowlist 등록은 **오리진 허용일 뿐 인증을 대체하지 않는다.** allowlist에 올라간 오리진이라도 요청에는 여전히 **유효한 인증(OAuth 액세스 토큰 등)** 이 필요하다. CORS는 "이 오리진의 브라우저 요청을 막지 않는다"는 게이트일 뿐, 데이터 접근 권한은 인증·공유·CRUD/FLS로 별도 결정된다.

---

## 3-way 결정표 — 방향별 필요한 설정

| 시나리오 | 요청 주체 (레이어) | 방향 | 필요한 설정 |
|---|---|---|---|
| Apex에서 외부 HTTP callout | Salesforce 서버 (Apex) | 아웃바운드 | **Remote Site Setting** (또는 Named Credential) |
| LWC(브라우저)에서 외부 API/이미지 로드 | 사용자 브라우저 (LWC) | 아웃바운드 | **CSP Trusted Site** |
| 외부 웹앱 브라우저 JS → Salesforce API 호출 | 외부 브라우저 (외부 오리진) | 인바운드 | **CORS allowlist** (+ 인증) |

> 셋을 헷갈리지 말 것: **아웃바운드 서버 = Remote Site/Named Credential**, **아웃바운드 브라우저 = CSP Trusted Site**, **인바운드 = CORS allowlist**.

---

## 주의사항

- **LWC에서 직접 외부 API 호출 시 CORS도 검토** — CSP Trusted Site를 등록해도 외부 서버가 CORS 헤더(`Access-Control-Allow-Origin`)를 응답에 포함하지 않으면 브라우저가 여전히 차단한다. CSP는 Salesforce 측 설정이고 CORS는 외부 서버 측 설정이다.
- **`disableProtocolSecurity=true` 프로덕션 금지** — Remote Site Setting에서 HTTPS 검증을 비활성화하면 중간자 공격에 취약해진다. 테스트 목적으로만 Sandbox에서 사용하고 프로덕션에는 절대 배포하지 않는다.
- **LWC에서 외부 JS 로드** — `loadScript()`로 CDN에서 JS를 직접 로드하면 Locker Service/LWS 제약과 CSP가 함께 작동한다. 외부 JS는 Static Resource로 번들링하는 것이 권장되며, 이 경우 CSP 등록도 불필요하다.
- **Experience Cloud(Communities)** — Context가 `LEX`이면 Experience Cloud 사이트에는 적용되지 않는다. 두 환경 모두 커버하려면 `All`로 설정.
- **URL 범위** — Remote Site Setting의 URL은 정확한 도메인 기반으로 매칭된다. 서브도메인이 다르면 별도 등록이 필요하다.

## 관련 노트

- [[Named Credential]]
- [[RestClient 패턴]]
- [[LWC 보안 패턴]]
- [[Static Resource 로딩]]
- [[Lightning Security 모델]] — CSP·LWS 등 Lightning 보안 모델 전반
- [[Secure Communications (TLS)]] — 외부 통신 TLS·HTTPS 강제 위협과 방어
- [[Platform Security FAQ]] — CSP·외부 도메인 허용 등 플랫폼 보안 공통 질문
