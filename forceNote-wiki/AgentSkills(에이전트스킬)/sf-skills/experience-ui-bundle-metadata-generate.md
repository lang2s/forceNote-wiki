---
tags: [agent-skill, sf-skills, experience, ui-bundle, metadata, csp-trusted-site]
source: forcedotcom/sf-skills (skills/experience-ui-bundle-metadata-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [experience-ui-bundle-metadata-generate, UI Bundle 메타데이터 생성, uibundle-meta.xml, ui-bundle.json routing headers, CSP Trusted Site 등록, sf template generate ui-bundle]
---

# experience-ui-bundle-metadata-generate — UI Bundle 메타데이터 생성 (스캐폴딩·meta XML·ui-bundle.json·CSP)

> React 기반 UI bundle 앱을 `sf template generate ui-bundle`로 스캐폴딩하고, `.uibundle-meta.xml`·`ui-bundle.json`(routing/headers/outputDir)·CSP Trusted Site 메타데이터를 구성할 때 쓰는 스킬.

## 목적과 활성화 조건

**활성화(MUST):** 프로젝트에 `uiBundles/*/src/` 디렉터리가 있고 새 UI bundle/앱을 스캐폴딩하거나, `ui-bundle.json`·`.uibundle-meta.xml`·CSP trusted site 파일을 편집할 때. 즉 `sf template generate ui-bundle`로 스캐폴딩, `ui-bundle.json`(routing, headers, outputDir) 구성, CSP Trusted Site 등록 작업. `*.uibundle-meta.xml`, `ui-bundle.json`, `cspTrustedSites/*.cspTrustedSite-meta.xml` 매칭 파일 작업 시 활성화.

## 워크플로 / 단계

### 새 UI Bundle 스캐폴딩

create-react-app·Vite 등 generic 스캐폴드가 아니라 **`sf template generate ui-bundle`**를 사용한다.

- **항상 `--template reactbasic`을 넘긴다** — React 기반 bundle 스캐폴딩.
- **UI bundle 이름 (`-n`):** 영숫자만 — 공백·하이픈·언더스코어·특수문자 불가.

```bash
sf template generate ui-bundle -n CoffeeBoutique --template reactbasic
```

생성 후:
1. 기본 boilerplate 전부 교체 — "React App", "Vite + React", 기본 `<title>`, placeholder 텍스트
2. 홈 페이지를 실제 콘텐츠로 채움 (landing section, banner, hero, navigation)
3. 네비게이션·placeholder 업데이트 (`experience-ui-bundle-frontend-generate` 스킬 참조)
4. **호스팅 target 구성** — meta XML에 `<target>`이 없는 UI bundle은 org에서 보이지 않는다. 내부(App Launcher) 앱은 `experience-ui-bundle-custom-app-generate`, 외부(Experience Site) 앱은 `experience-ui-bundle-site-generate` 사용.

UI bundle 디렉터리에서 스크립트 실행 전 항상 의존성을 먼저 설치한다.

### UIBundle 번들 구조

UIBundle 번들은 `uiBundles/<AppName>/` 아래에 있으며 다음을 포함해야 한다:

- `<AppName>.uibundle-meta.xml` — 파일명이 폴더명과 정확히 일치해야 함
- build 출력 디렉터리 (default: `dist/`) — 파일 최소 1개 포함

#### Meta XML

필수 필드: `masterLabel`, `version`(최대 20자), `isActive`(boolean).
선택: `description`(최대 255자), `target`.

##### Target 필드

`<target>` 요소는 UI bundle이 어디서 호스팅되는지 지정한다.

| 값 | Use Case | 동반 메타데이터 |
|----|----------|----------------|
| `Experience` | Digital Experience 통한 외부향 site | Network, CustomSite, DigitalExperienceConfig, DigitalExperienceBundle |
| `CustomApplication` | Lightning App Launcher 통한 내부 앱 | CustomApplication (`applications/*.app-meta.xml`) |

`<target>`은 org에서 앱에 접근하려면 **필수**다. target 없이 배포한 UI bundle은 어디에도 안 나타난다 — App Launcher 항목 없음, Experience Site URL 없음. 항상 다음 중 하나와 짝지운다:
- `experience-ui-bundle-site-generate` (`Experience` target)
- `experience-ui-bundle-custom-app-generate` (`CustomApplication` target)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<UIBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <masterLabel>propertyrentalapp</masterLabel>
    <description>A Salesforce UI Bundle.</description>
    <isActive>true</isActive>
    <version>1</version>
    <target>Experience</target>
</UIBundle>
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<UIBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <masterLabel>propertymanagementapp</masterLabel>
    <description>A Salesforce UI Bundle.</description>
    <isActive>true</isActive>
    <version>1</version>
    <target>CustomApplication</target>
</UIBundle>
```

### ui-bundle.json

선택 파일. 허용 top-level 키: `outputDir`, `routing`, `headers`.

**제약:**
- 유효 UTF-8 JSON, 최대 100 KB
- 루트는 non-empty object (절대 `{}`, 배열, primitive 금지)

**Path safety** (`outputDir`·`routing.fallback`에 적용): backslash 문자, leading slash 또는 leading backslash, `..` segment, null/control 문자, glob(`*`, `?`, `**`), `%` 거부. 모든 resolved path는 bundle 내부에 머물러야 한다.

- **outputDir** — subdirectory 참조 non-empty 문자열(`.` 또는 `./` 아님). 디렉터리가 존재하고 파일 최소 1개 포함.
- **routing** — 존재 시 non-empty object. 허용 키: `rewrites`, `redirects`, `fallback`, `trailingSlash`, `fileBasedRouting`.
  - `trailingSlash`: `"always"`, `"never"`, `"auto"`
  - `fileBasedRouting`: boolean
  - `fallback`: path safety 만족 non-empty 문자열; target 파일 존재해야 함
  - `rewrites`: `{ route?, rewrite }` 객체의 non-empty 배열 — 예: `{ "route": "/app/:path*", "rewrite": "/index.html" }`
  - `redirects`: `{ route?, redirect, statusCode? }` 객체의 non-empty 배열 — statusCode는 301, 302, 307, 308만
- **headers** — `{ source, headers: [{ key, value }] }` 객체의 non-empty 배열.

```json
{
  "routing": {
    "rewrites": [{ "route": "/app/:path*", "rewrite": "/index.html" }],
    "trailingSlash": "never"
  },
  "headers": [
    {
      "source": "/assets/**",
      "headers": [{ "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }]
    }
  ]
}
```

**절대 제안 금지:** 루트로 `{}`, 빈 `"routing": {}`, 빈 배열, `[{}]`, `"outputDir": "."`, `"outputDir": "./"`.

### CSP Trusted Sites

Salesforce는 CSP 헤더를 강제한다. CSP Trusted Site로 등록되지 않은 외부 도메인은 차단된다(이미지 안 뜸, API 호출 실패, 폰트 누락).

**언제 생성:** 앱이 새 외부 도메인 참조 시 — CDN 이미지, 외부 폰트, third-party API, map tile, iframe, 외부 stylesheet.

**단계:**
1. **외부 도메인 식별** — 각 외부 URL에서 origin(scheme + host) 추출
2. **기존 등록 확인** — `force-app/main/default/cspTrustedSites/` 확인
3. **리소스 타입 → CSP directive 매핑:**

| 리소스 타입 | Directive 필드 |
|------------|----------------|
| Images | `isApplicableToImgSrc` |
| API 호출 (fetch, XHR) | `isApplicableToConnectSrc` |
| Fonts | `isApplicableToFontSrc` |
| Stylesheets | `isApplicableToStyleSrc` |
| Video / audio | `isApplicableToMediaSrc` |
| Iframes | `isApplicableToFrameSrc` |

preflight/redirect 처리를 위해 항상 `isApplicableToConnectSrc`도 `true`로 설정.

4. **메타데이터 파일 생성** — `.cspTrustedSite-meta.xml` 포맷은 `implementation/csp-metadata-format.md` 참조. `force-app/main/default/cspTrustedSites/`에 배치.

#### CSP Trusted Site 파일 포맷 (implementation/csp-metadata-format.md)

파일 위치: `force-app/main/default/cspTrustedSites/{Name}.cspTrustedSite-meta.xml`. `cspTrustedSites/`는 `force-app/main/default/`의 직속 child여야 한다.

파일명은 XML 내부 `<fullName>` 값 + `.cspTrustedSite-meta.xml`. 예: `https://images.unsplash.com` → fullName `Unsplash_Images` → 파일명 `Unsplash_Images.cspTrustedSite-meta.xml`.

**네이밍 규칙:** PascalCase + 단어 구분 underscore (`Google_Fonts_Static`), provider+리소스 타입 기술(`Pexels_Videos`, `Pexels` 아님), org 전역 unique, 최대 80자.

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<CspTrustedSite xmlns="http://soap.sforce.com/2006/04/metadata">
    <fullName>{UNIQUE_NAME}</fullName>
    <description>{DESCRIPTION}</description>
    <endpointUrl>{HTTPS_ORIGIN}</endpointUrl>
    <isActive>true</isActive>
    <context>All</context>
    <isApplicableToConnectSrc>{true|false}</isApplicableToConnectSrc>
    <isApplicableToFontSrc>{true|false}</isApplicableToFontSrc>
    <isApplicableToFrameSrc>{true|false}</isApplicableToFrameSrc>
    <isApplicableToImgSrc>{true|false}</isApplicableToImgSrc>
    <isApplicableToMediaSrc>{true|false}</isApplicableToMediaSrc>
    <isApplicableToStyleSrc>{true|false}</isApplicableToStyleSrc>
</CspTrustedSite>
```

**필드 참조:**
- `fullName` (필수) — unique API name, 파일명과 일치
- `description` (필수) — "Allow access to..."로 시작
- `endpointUrl` (필수) — 외부 origin(scheme+host). `https://`로 시작, trailing slash·path 없음
- `isActive` (필수) — 신규는 `true`. 비활성화는 `false`(삭제 대신)
- `context` (필수) — `All`(전 컨텍스트). 기타: `LEX`, `Communities`, `VisualForce`. 특별한 이유 없으면 `All`
- `isApplicableToConnectSrc` — `fetch()`/`XMLHttpRequest`/WebSocket으로 호출 시 `true`
- `isApplicableToFontSrc` — 폰트 파일(`.woff`/`.woff2`/`.ttf`/`.otf`) 서빙 시 `true`
- `isApplicableToFrameSrc` — `<iframe>`/`<object>` 로딩 시 `true`
- `isApplicableToImgSrc` — 이미지(`<img>`, CSS `background-image`, `<svg>`) 서빙 시 `true`
- `isApplicableToMediaSrc` — 오디오/비디오(`<audio>`/`<video>`) 서빙 시 `true`
- `isApplicableToStyleSrc` — CSS stylesheet(`<link rel="stylesheet">`) 서빙 시 `true`

**자주 쓰는 외부 도메인별 directive (connect/font/frame/img/media/style 순):**

| Domain | connect | font | frame | img | media | style |
|--------|:---:|:---:|:---:|:---:|:---:|:---:|
| `images.unsplash.com` | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `images.pexels.com` | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `videos.pexels.com` | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ |
| `fonts.googleapis.com` | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| `fonts.gstatic.com` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `avatars.githubusercontent.com` | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `api.open-meteo.com` | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `nominatim.openstreetmap.org` | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `tile.openstreetmap.org` | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `api.mapbox.com` | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `cdn.jsdelivr.net` | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| `www.youtube.com` | ❌ | ❌ | ✅ | ✅ | ❌ | ❌ |
| `player.vimeo.com` | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| `res.cloudinary.com` | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |

> 위 매트릭스의 ✅/❌는 source 원본의 `true`/`false`를 그대로 옮긴 것이다.

**endpointUrl 규칙:** HTTPS 필수, trailing slash 없음, path 없음, port 없음(non-standard 제외), wildcard 없음. 각 subdomain은 별도 entry(예: `fonts.googleapis.com`·`fonts.gstatic.com` 별개).

**다중 도메인 필요 서비스:** Google Fonts = `fonts.googleapis.com`(CSS) + `fonts.gstatic.com`(폰트 파일); Mapbox = `api.mapbox.com` + `events.mapbox.com`; YouTube embed = `www.youtube.com`(iframe) + `i.ytimg.com`(thumbnail).

**CSP 위반 트러블슈팅:** 콘솔 CSP 에러 → 차단된 origin 추출 → directive 식별(`img-src`→`isApplicableToImgSrc`) → 기존 CSP Trusted Site 확인 → 없으면 생성 → 배포 후 새로고침.

## 핵심 규칙·가드레일

- generic 스캐폴드 금지, 항상 `sf template generate ui-bundle --template reactbasic`. bundle 이름은 영숫자만.
- meta XML 파일명 = 폴더명 정확히 일치. `<target>` 없으면 org에서 안 보임 — 항상 site 또는 custom-app 스킬과 짝지움.
- `ui-bundle.json` 루트는 non-empty object, path safety 규칙 준수, 빈 객체/배열 제안 금지.
- CSP: 새 외부 도메인은 모두 등록, 파일명=`fullName`, endpointUrl은 HTTPS origin만(path/slash/wildcard 금지), 각 subdomain 별도 entry, connect-src 기본 true.

## 번들 파일

| 파일 | 내용 |
|------|------|
| `implementation/csp-metadata-format.md` | `.cspTrustedSite-meta.xml` 포맷·필드 참조·도메인별 directive 매트릭스·완전 예시·트러블슈팅 |

## 관련 노트
- [[experience-ui-bundle-site-generate]]
- [[experience-ui-bundle-custom-app-generate]]
- [[experience-ui-bundle-frontend-generate]]
- [[experience-ui-bundle-app-coordinate]]
