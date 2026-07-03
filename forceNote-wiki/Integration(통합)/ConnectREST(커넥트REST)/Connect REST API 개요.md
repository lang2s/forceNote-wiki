---
tags: [integration, connect-rest-api, chatter-rest-api, rest, api-overview]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p45–79 Introduction 챕터; Tier 1/2)
created: 2026-07-03
aliases: [Connect REST API, Chatter REST API, 커넥트 REST API, 채터 REST API, Connect in Apex 관계, API 개요]
---

# Connect REST API 개요

> Connect REST API는 모바일·인트라넷·서드파티 웹앱을 Salesforce와 통합하는 API로, 응답이 지역화·프레젠테이션용으로 구조화·필터링된다. 동일 기능 대부분은 Apex의 `ConnectApi` 네임스페이스(Connect in Apex)로 HTTP callout 없이 호출할 수 있다.

---

## 문서 정의

Integrate mobile apps, intranet sites, and third-party web applications with Salesforce using Connect REST API. 응답은 지역화(localized)되고, 프레젠테이션용으로 구조화(structured for presentation)되며, 앱이 필요한 데이터만 담도록 필터링할 수 있다.

Connect REST API는 다음에 대한 프로그래밍 접근을 제공한다: B2B Commerce, CMS managed content, Experience Cloud sites, files, notifications, topics, and more. Connect REST API로 Chatter feeds, users, groups를 표시하며, 특히 모바일 애플리케이션에서 활용한다.

**EDITIONS:** Personal Edition을 제외한 모든 에디션에서 사용 가능. 일부 기능은 org에 Chatter가 활성화되어 있어야 한다.

### Connect in Apex와의 관계

많은 Connect REST API 리소스 작업(resource actions)이 `ConnectApi` 네임스페이스의 Apex 클래스에 static method로 노출되어 있다. 이 클래스들을 **Connect in Apex**라고 부른다. Apex가 활성화된 모든 org/edition에서 사용 가능하며, Apex에서 **HTTP callout 없이** Lightning Platform 위에서 동일 기능을 개발할 수 있다. 관련 문서는 *Apex Developer Guide* / *Apex Reference Guide*.

> Apex 측 짝은 [[ConnectApi Namespace 개요]] 참조.

---

## 언제 Connect REST API를 쓰는가 (When to Use)

Use Connect REST API to:
- Build a mobile app.
- Integrate a third-party web application with Salesforce so it can notify groups of users about events.
- Display a feed on an external system, such as an intranet site, after users are authenticated.
- Make feeds actionable and integrated with third-party sites. 예: 포스트에 `#tweet` 해시태그가 포함되면 Chatter 항목을 X(구 Twitter)에 게시하는 앱.
- Create simple games that interact with the feed for notifications.
- Creating a custom, branded skin for Chatter for your organization. [sic]

### 다른 Salesforce API와 무엇이 다른가 (vs REST API)

- **렌더링용 구조화:** 데이터가 웹사이트·모바일 디바이스에서 렌더링하기 좋게 구조화되어 반환된다.
- **지역화:** 반환 정보가 사용자의 time zone과 언어로 지역화된다.
- **value-pair 표현:** 피드에서 추적되는 변경된 값(changed values)이 value-pair 표현으로 반환된다.
- **rate limiting 차이:** Chatter REST API 리소스(전체의 일부 subset)에 대한 rate limiting은 **per user, per application, per hour**로 적용된다. Chatter가 필요 없는 리소스 요청은 Salesforce Platform total API request allocation(per org, 24-hour period)에 카운트된다.
- **ID 연계:** 필요하면 REST API에서 ID를 추출해 Connect REST API 요청에 사용할 수 있다.

> 요청·응답 규약(URL 구성·HTTP 메서드·필터·상태 코드)은 [[Connect REST API 요청·응답 규약]] 참조.

---

## 아키텍처 (Architecture)

- **Authentication:** OAuth 2.0. 통신은 HTTPS.
- **CORS:** CORS로 브라우저가 다른 origin의 리소스를 요청할 수 있다. 요청하려면 origin을 Salesforce CORS allowlist에 추가한다. (Salesforce Help: *Perform Cross-Origin Requests from Web Browsers*)
- **Default HTML entity encoding:** 응답은 기본적으로 최소한의 HTML entity 인코딩을 거친다. raw 콘텐츠를 원하면 `X-Chatter-Entity-Encoding: false` 헤더를 전달한다.
- **JSON / XML:**
  - JSON은 UTF-8, date-time은 ISO 8601. 기본 응답 포맷은 JSON.
  - XML 요청은 UTF-8/UTF-16, 응답은 UTF-8. XML을 받으려면 `Accept: application/xml` 헤더를 쓰거나 URI에 `.json` / `.xml` suffix를 붙인다 (예: `/chatter/feeds/filter/me/001/feed-elements.xml`).
  - Note: 모든 기능이 XML을 지원하는 것은 아니다.
- **Localized names/times:** 이름·datetime이 사용자 locale로 지역화된다. 미설정 시 org 기본값. `Accept-Language` 헤더로 override 가능. Summer '23 이후 생성된 org은 `Accept-Language`가 `language` query param과 동일해야 한다. ISO 8601 dates는 항상 GMT.
- **Salesforce ID length:** 응답 바디의 ID는 항상 18자. 요청 바디에는 15자 또는 18자 모두 사용 가능.
- **UI Themes:** `X-Connect-Theme` 헤더로 UI 테마를 지정한다. 값은 `Classic` / `Salesforce1` (case-sensitive)이며 각각 고유 motif 아이콘을 가진다.
- **Method overriding:** override용 request param `_HttpMethod`(case-sensitive)를 사용한다. 예 (`instance_name`·ID는 예시값):

```
POST https://instance_name/services/data/v67.0/chatter/users/me/conversations/03MD0000000008KMAQ?_HttpMethod=PATCH&read=true
```

---

## 한도 (Limits)

- 대부분의 요청은 다른 Salesforce API와 동일한 rate limit을 따른다. **Chatter REST API 리소스만** per user / per application / per hour rate limit이 적용되며, 초과 시 **503 Service Unavailable**을 반환한다.
- Chatter 리소스는 문서에 "Chatter required"가 명시된다. Chatter가 필요 없는 리소스 요청은 org당 24시간 Platform total API allocation에 카운트된다.
- session ID를 사용하는 앱은 per user / per hour로 계산된다(앱별 별도 버킷 없음). per user / per app / per hour의 이점을 원하면 OAuth 토큰을 사용한다.
- **가이드라인:**
  - 테스트 시 여러 유저로 시뮬레이션한다.
  - 피드 폴링은 분당 1회 이하(**≤ 1/min, 60/hour**). 결과가 더 필요하면 폴링을 늘리지 말고 page size를 늘린다.
  - private message 폴링은 시간당 60회 이하(**≤ 60/hour**).
  - 메터링되는 static asset(file·dashboard rendition)은 캐시한다. group/user 프로필 사진은 비메터링.
  - 자동 테스트 앱과 수동 테스트 앱을 분리한다.
  - 프로덕션 전용 client app을 사용하고, 앱 간에 client app을 공유하지 않는다.
- **Important — 데이터 추출 금지:** 데이터 추출에는 Connect REST API를 사용하지 않는다. sObject 조작에는 REST API / SOAP API를 쓴다. (user profile 마이그레이션·동기화, analytic app, record/field 쿼리 등)
- **Integer:** 대부분의 리소스는 64-bit integer를 지원한다. 2³¹−1을 초과하고 10¹⁸ 미만인 값은 quote(따옴표)로 감싸야 한다. 10¹⁸을 초과하는 값은 지원하지 않는다.

---

## OAuth 개요 + Bearer token URLs

- Connect REST API는 OAuth로 앱을 식별한다. REST entry point로 사용하려면 **external client app**을 생성해야 한다. (Step Two: Set Up Authorization)
- 표준과 앱 유형에 따라 여러 OAuth flow가 있으며, 성공 시 access token·refresh token을 수령한다.

### Bearer token URLs

Salesforce 밖의 HTML 페이지는 세션 쿠키가 없어 user/group 이미지 표시나 파일 첨부 폼 게시가 곤란하다. `<img>` / `<a>` / `<form>` 태그에는 OAuth 토큰을 전달할 수 없으므로, 리소스와 부착 토큰을 담은 self-authenticating **bearer token URL**을 사용한다.

- **절차:**
  1. bearer token URL 속성을 담은 리소스를 요청한다.
  2. `X-Connect-Bearer-Urls: true` 헤더를 전달한다.
  3. 응답에서 bearer URL을 파싱해 HTML 태그에 사용한다.
- **특성:** URL 전용(param을 추가하거나 재정렬하면 무효화된다). TTL은 **20분**. 리소스를 요청한 유저로 인증된다.
- **bearer URL을 반환하는 속성 예:** Banner Photo(`bannerPhotoUrl`, `url`*), Comment Page(`currentPageUrl`*), Content Capability(`downloadUrl`·`externalDocumentUrl`·`renditionUrl`·`repositoryFileUrl`), Feed(`feedElementPostUrl`*·`feedElementsUrl`*·`feedItemsUrl`*), Feed Item(`photoUrl`), File Detail/Summary(`downloadUrl`·`renditionUrl`·`renditionUrl240By180`·`renditionUrl720By480` 등), Photo(`largePhotoUrl`·`smallPhotoUrl`·`url`*), Mention Completion(`photoUrl`), Message Segment: Inline Image(`url`*) 등. (`*` 표시는 POST/PUT으로 바이너리를 포함하는 새 항목에 사용)

---

## 릴리즈 노트 / End-of-Life 정책

- **Release Notes:** Salesforce Release Notes의 "Connect REST API" 섹션.
- **EOL Policy:** 각 API 버전은 최소 **3년** 지원된다. 3년을 초과한 버전은 미지원될 수 있다. 폐기 예정 버전은 **최소 1년 전에 통지**한다.
- **버전 지원표:**

| 버전 | 상태 |
|---|---|
| v31.0 – v66.0 | Supported |
| v21.0 – v30.0 | Summer '25부터 retired · unavailable |
| v7.0 – v20.0 | Summer '22부터 retired · unavailable |

- 은퇴한 버전의 리소스/작업을 호출하면 `410: GONE`을 반환한다.
- 오래된 버전 사용을 식별하려면 무료 **API Total Usage** event type을 사용한다.

---

## Quick Start

### Prerequisites

- **cURL:** 클라이언트. Linux/Mac/Windows 다수에 프리인스톨. Windows에 없으면 curl.haxx.se에서 다운로드. Salesforce 미지원 오픈소스 도구.
- **JSON**, **OAuth 2.0** 이해.

### Step One — Sign up for Developer Edition

developer.salesforce.com/signup에서 가입. Dev Edition storage는 최대 **5MB**. 프로필에 **API Enabled** 권한이 있는지 확인한다.

### Step Two — Set Up Authorization

org에 external client app을 생성하고, OAuth를 활성화하고, OAuth flow를 구성한다. (Salesforce Help: *Create an External Client App* / *Set Up OAuth Flows*)

### Step Three — Connect Using OAuth

1. access token 생성 (Client Credentials Flow, `grant_type=client_credentials`). 아래는 공식 문서의 실제 예제 (`instance_name`·`client_id`·`client_secret`은 예시값):

```
curl -X POST https://instance_name.my.salesforce.com/services/oauth2/token -d 'grant_type=client_credentials' -d 'client_id=3MVG9...' -d 'client_secret=8A4BE698...'
```

응답 (토큰·서명은 예시값):

```json
{
"access_token": "00DS7000000oxzo!AR8AQ...",
"signature": "nUFHwtfIGLKDTHcLWmDBG8frv0t+HQGl/iCZFIQUarE=",
"token_format": "opaque",
"instance_url": "https://instance_name.my.salesforce.com"
"id": "https://login.salesforce.com/id/00Dd000000XXXXXXX/005d000000XXXXX",
"token_type": "Bearer",
"issued_at": "1678833535086"
}
```

2. 반환된 `instance_url` + `access_token`(Bearer)으로 리소스를 요청한다:

```
curl -X GET https://instance_name.my.salesforce.com/services/data/v67.0/chatter/users/me -H 'Authorization: Bearer 00DS7000000oxzo!AR8AQ...'
```

`unsupported_grant_type` 에러가 나면 cURL 문법을 확인한다 (Windows는 `'` → `"`로 교체).

### Connect to Experience Cloud Sites

authorize URL의 host를 site URL 전체 경로로 교체한다. (아래 예제는 원문 그대로 v29.0을 사용)

```
https://MyDomainName.my.site.com/services/oauth2/authorize?response_type=token&client_id=your_app_id&redirect_uri=your_redirect_uri
https://MyDomainName.my.site.com/services/oauth2/token
https://MyDomainName.my.site.com/services/data/v29.0/connect/communities/communityId/chatter/feeds/news/me/feed-elements
```

### Send a Request with Postman

Postman desktop app에서 Salesforce APIs collection을 fork한다. 예: `Connect > Chatter > User > User Photo`, POST URL `{{_endpoint}}/services/data/v{{version}}/connect/user-profiles/me/photo`.

---

## 관련 노트
- [[Connect REST API 요청·응답 규약]] — 자매 노트. URL 구성·HTTP 메서드·필터(filterGroup/include/exclude)·상태 코드·바이너리 업로드 규약.
- [[ConnectApi Namespace 개요]] — Apex 측 짝(Connect in Apex). HTTP callout 없이 동일 기능 호출.
- [[REST API]] — 대비되는 표준 REST API. sObject CRUD·데이터 추출용.
