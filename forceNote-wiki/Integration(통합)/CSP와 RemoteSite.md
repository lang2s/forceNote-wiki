---
tags: [security, csp, remote-site, integration, pattern]
source: dreamhouse-lwc/cspTrustedSites, remoteSiteSettings
created: 2026-05-17
aliases: [CSP Trusted Site, Remote Site, 외부 연동 보안]
---

# CSP Trusted Sites & Remote Site Settings

> 외부 서비스를 LWC 또는 Apex에서 사용할 때 반드시 등록해야 하는 두 가지 보안 설정. 미등록 시 브라우저 CSP 차단 또는 callout 오류 발생.

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

## 관련 노트

- [[Named Credential]]
- [[RestClient 패턴]]
- [[LWC 보안 패턴]]
- [[Static Resource 로딩]]
