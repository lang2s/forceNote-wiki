---
tags: [integration, connect-rest-api, resource-url, filtering, status-codes]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p45–79 Introduction 챕터; Tier 1/2)
created: 2026-07-03
aliases: [Connect REST API 규약, Resource URL, filterGroup, exclude include 필터, Status Codes, 요청 응답 규약, multipart 업로드]
---

# Connect REST API 요청·응답 규약

> Connect REST API 요청을 어떻게 조립하고(리소스 URL·HTTP 메서드·입력) 응답을 어떻게 다듬는지(필터·인코딩·상태 코드)를 규정하는 wire-level 규약 노트.

> 용도·아키텍처·인증(OAuth)·Limits 등 상위 개념은 [[Connect REST API 개요]]를 참조. 이 노트는 실제 요청/응답을 조립하는 규칙만 다룬다.

---

## Build the Resource URL

리소스 URL은 **인스턴스 + 버전 + 리소스** 세 조각으로 조립한다.

```
https://instance_name / services/data/v67.0 / chatter/feeds/news/me/feed-elements
└── instance ──────┘ └── version ─────────┘ └── resource ─────────────────────┘
```

- 전체 예: `https://instance_name/services/data/v67.0/chatter/feeds/news/me/feed-elements`
- `instance_name`·access token은 인증 시 받은 값을 넣는다(위 값들은 예시).

### Experience Cloud site 요청

버전 뒤, 리소스 앞에 `/connect/communities/communityId`를 넣는다.

```
https://instance_name/services/data/v67.0/connect/communities/communityId/chatter/feeds/news/me/feed-elements
```

- **default site 단축:** site ID 대신 `internal` 키워드를 쓴다 → `/connect/communities/internal`. digital experiences가 활성화되지 않은 org에서도 사용할 수 있다.
- default site는 `/chatter`로 **직접** 호출할 수도 있다. 이 경우 응답 URL에 `/connect/communities/internal`이 포함되지 않는다.
- org의 site URL을 그대로 쓸 수도 있다:
  `https://MyDomainName.my.site.com/sitepath/services/data/v67.0/connect/communities/communityId/chatter/...`
- **Note:** 같은 이름의 객체(예: Groups)를 가진 site가 있으면 해당 site에서 요청해야 한다.

---

## Send HTTP Requests

요청은 다음으로 구성된다: **HTTP 메서드 / OAuth 2.0 access token / 리소스 URL / request param 또는 request body**. body는 JSON 또는 XML이다.

- resource-specific param과 request body를 **동시에** 전달하면 **param은 무시**된다.
- 비-리소스 param(bearer token URL param, `_HttpMethod`)은 body와 함께 처리된다.

| 메서드 | 용도 |
|---|---|
| **GET** | 리소스 조회(retrieve) |
| **POST** | 생성 — feed item·comment·like 작성, group 구독 |
| **PATCH** | 부분 업데이트(partial) — 예: 파일 이름 변경 |
| **PUT** | 전체 업데이트(whole) — 예: 대화를 read로 표시 |
| **DELETE** | 삭제 — feed element 삭제, group 구독 해제 |
| **HEAD** | 리소스 메타데이터 조회(GET과 유사하나 body 없음; 가용성 테스트) |

---

## HTTP Request Flow + 응답 바디

요청 흐름 4단계:

1. HTTP 요청 전송
2. 유저·앱 인증
3. 리소스 요청
4. HTTP 상태 코드 반환 + 선택적 응답 바디

각 리소스는 **URI + 메서드**로 식별된다. `me` 키워드는 현재 컨텍스트 유저를 가리킨다(`/chatter/users/me`). user ID로도 지정할 수 있다(`/chatter/users/005D0000001GLoh`).

성공하면 JSON(기본) 또는 XML 응답 바디를 받는다. **응답 바디는 다른 응답 바디를 중첩 포함**할 수 있다(address·motif·phone 등).

사용자 리소스 JSON 응답 예 (원문 오타 포함 — `formattedAdress`는 `d` 누락, `"userType": "Internal";`는 세미콜론 오류. 아래는 PDF 원문 그대로):

```json
{
"aboutMe": "I&#39;m excited to be part of the team focused on building out our apps business and showing our customers their future.",
"address": { "city":"Seattle","country":"US","state":"WA","street":"2001 8th Ave","zip":"98121" "formattedAdress":"2001 8th Ave\nSeattle, WA 98121\nUS" },
"chatterActivity": {"commentCount":0,"commentReceivedCount":1,"likeReceivedCount":0,"postCount":2},
"displayName":"Marion Raven","id":"005D0000001Kl6xIAC","isActive":true,
"motif":{"color":"20aeb8","largeIconUrl":"/img/icon/profile64.png","mediumIconUrl":"/img/icon/profile32.png","smallIconUrl":"/img/icon/profile16.png"},
"type":"User","url":"/services/data/v67.0/chatter/users/005D0000001Kl6xIAC","userType":"Internal";"username":"mraven@seattleapps.com"
}
```

> `formattedAdress` `[sic]`, `"userType":"Internal";` `[sic]` — PDF 원문 오타를 그대로 인용.

**Note:** `instance_name`은 인스턴스를 가리킨다. 상대 URL(`url` 속성 등)은 인증 시 받은 instance로 prepend한다.

---

## Inputs & Binary File Upload

POST/PATCH/PUT의 입력은 request param 또는 request body(JSON/XML)로 전달한다.

- **param 전달 시:** `Content-Type: application/x-www-form-urlencoded`
- **body 전달 시:** `Content-Type` + `Accept`를 `application/json` 또는 `application/xml`로.

### 바이너리 파일 업로드

바이너리는 `multipart/form-data`의 body part로 전송한다. 크기 한도:

| 대상 | 한도 |
|---|---|
| 일반 바이너리(헤더 포함) | **2GB** |
| external repository | **75MB** |
| bulk conversations | **512MB** |

- comment 텍스트(post 텍스트는 아님)는 같은 multipart의 JSON/XML **rich input part**로 함께 전송할 수 있다.
- **Important (v36.0+):** feed post 생성과 바이너리 업로드를 **같은 요청에서 함께 할 수 없다.** 파일을 먼저 업로드한 뒤 file ID로 첨부한다.
- CRLF/spacing이 중요하다. 예: `Content-Disposition: form-data; name="feedItemFileUpload"; title="2012_q1_review.ppt"` — CRLF 대신 spaces가 필요하다.

### 표 1 — Rich Input Body Part 헤더

| Header | Value | Description |
|---|---|---|
| Content-Disposition | `form-data; name="json"` / `name="xml"` | post/comment의 request body. JSON은 `"json"`, XML은 `"xml"`. |
| Content-Type | `application/json; charset=UTF-8` / `application/xml; charset=UTF-8` | data format·charset. |

> **Tip:** 브라우저는 non-binary part가 자체 Content-Type을 가지면 multipart 처리가 곤란하다. Content-Disposition의 name을 지정하면 Salesforce가 rich input의 Content-Type을 읽으므로, rich input body에는 Content-Type을 넣지 않아도 된다.

### 표 2 — Rich Input(브라우저) name 값

| name 값 | 용도 |
|---|---|
| `feedElement` | feed element + binary (v35.0 이하) |
| `comment` | comment + binary |
| `photo` | employee·user·group photo |
| `file` | Files home·external repository |
| `folderItem` | folder 업로드 |
| `ManagedContentInputParam` | managed content |
| `ManagedContentVariantInputParam` | variant 업데이트 |

전부 `Content-Disposition: form-data; name="..."` 형식.

### 표 3 — Binary Upload Body Part 헤더

| name 값 | 용도 |
|---|---|
| `feedElementFileUpload` | feed element + binary(v35.0 이하) / comment + binary |
| `fileUpload` | user/group photo |
| `fileData` | Files home / external repository (Note: filename param을 지정하되, Salesforce는 File Input의 `title` 속성 또는 Files Connect Item Input 메타데이터를 파일명으로 사용) |
| `audioFileData` | audio (지정 시 recordingURL·name은 지정 금지) |
| `contentData` | managed content / variant |
| `file` | translation workbench import job |

바이너리 part는 `Content-Type: application/octet-stream; charset=ISO-8859-1`(바이너리 media type·charset)을 붙인다.

### 대표 코드 예제

**예제 C — Post a comment with binary** (리소스 `/chatter/feed-elements/{id}/capabilities/comments/items`):

```bash
curl -H "X-PrettyPrint: 1" -F 'json={ "body":{ "messageSegments":[ { "type":"Text", "text":"Here'\''s another receipt." } ] }, "capabilities":{ "content":{ "title":"receipt2" } } };type=application/json' -F "feedElementFileUpload=@receipt2.txt;type=application/octet-stream" -X POST https://instance_name/services/data/v67.0/chatter/feed-elements/0D5RR0000004Grx/capabilities/comments/items -H 'Authorization: OAuth 00DRR0000000N0g!...' --insecure
```

**예제 E — Upload/crop user photo** (`/connect/user-profiles/me/photo`):

```bash
curl -H "X-PrettyPrint: 1" -F 'json={"cropX":"0","cropY":"0","cropSize":"200"};type=application/json' -F "fileUpload=@myPhoto.jpg;type=application/octet-stream" -X POST https://instance_name/services/data/v67.0/connect/user-profiles/me/photo -H 'Authorization: OAuth 00DRR0000000N0g!...' --insecure
```

> 추가 예제(A/B/D/F–L — batch·external repo·audio·CMS·translation 등, **전체 12개**)는 공식 문서(PDF p53–65) 참조.

---

## Wildcards

`q` param에 검색 문자열 + 와일드카드를 넣는다. 예: `/chatter/feed-elements?q=chat*`. Apex 대응: `ConnectApi.ChatterFeeds.searchFeedElements(null, 'chat*');`

| 와일드카드 | 의미 | 예 |
|---|---|---|
| `*` | 중간/끝에서 0개 이상 문자 | `john*` → john / johnson / johnny |
| `?` | 중간/끝에서 정확히 1개 문자 | `jo?n` → john / joan (jon·johan 아님) |

- 리터럴 `*`은 백슬래시(backslash)로 이스케이프한다.
- **lookup 검색에는 `?`를 사용할 수 없다.**
- 팁: 초점을 좁힐수록 빠르다(`prospect*` > `prosp*`). 변형을 포괄하려면(`propert*` → property/properties). 구두점은 인덱싱되므로 `*`/`?`를 구문 검색에 쓸 땐 따옴표 + 이스케이프(`"where are you\?"`).

---

## Specify Response Sizes (filterGroup / exclude / include)

응답 크기를 줄여 앱이 필요한 것만 받도록 조절한다.

### filterGroup (v29.0+)

- JSON 전용, DELETE·HEAD 제외.
- 값: **Big**(default, 전부) / **Medium**(Medium+Small) / **Small**(Small만).
- 크기 분류(Big/Medium/Small)는 문서에만 표기되고 응답 바디에는 보이지 않는다.
- include/exclude와 병용 가능(결과는 합집합).

**filterGroup 결정 매트릭스** (PDF 이미지 재구성 정본 — 셀 그대로):

| include 제공 | include에 속성 | exclude 제공 | exclude에 속성 | filterGroup 제공 | filterGroup에 속성 | → 응답 포함 |
|---|---|---|---|---|---|---|
| Yes | No | No | No | No | No | **No** |
| Yes | Yes | No | No | Yes or No | Yes or No | **Yes** |
| No | No | Yes | No | No | No | **Yes** |
| No | No | Yes | No | Yes | No | **No** |
| No | No | Yes | Yes | Yes or No | Yes or No | **No** |
| No | No | No | No | Yes | No | **No** |
| No | No | No | No | Yes | Yes | **Yes** |
| Yes | Yes or No | Yes | Yes or No | Yes or No | Yes or No | **Error (400)** |

### exclude (v27.0+)

- 속성 리스트를 bar(`|`)로 구분하고, URL 인코딩은 `%7C`. 각 속성명 앞에 `/`를 붙인다.
- 예: `/chatter/users/me?exclude=/aboutMe%7C/address`
- `/`가 없으면 **400 `INVALID_FILTER_VALUE`**.
- top-level 속성은 필터되지 않는다(에러 없이 무시). nested 속성은 부모명 세그먼트를 포함한다.

### include

- exclude와 대칭. 속성 리스트를 bar 구분(`%7C`), 앞에 `/`.
- 예: `/chatter/users/me?include=/aboutMe%7C/address`
- 나머지 규칙은 exclude와 동일.

> JSON에는 노드명이 없으므로, 노드 경로를 확인하려면 XML suffix를 쓴다:
> `.../feed-elements.xml?exclude=/elements/feedElement/actor`

---

## Response Body Encoding

응답은 기본적으로 **최소 HTML entity 인코딩**된다.

| 문자 | 인코딩 |
|---|---|
| `<` | `&lt;` |
| `>` | `&gt;` |
| `"` | `&quot;` |
| `'` | `&#39;` |
| 백슬래시(backslash) | `&#92;` |
| `&` | `&amp;` |

- URL 값은 특수 인코딩된다: main URL은 RFC2396 URL-encode, query string은 HTML-form encode. **URL 인코딩은 끌 수 없다.**
- **Warning:** 사용자 콘텐츠는 XSS 위험이 있다. 컨텍스트별로 인코딩을 처리해야 한다(HTML attribute·URL·JavaScript·`<script>`·CSS가 각기 다름 — OWASP 참조).
- raw 값을 원하면 요청에 `X-Chatter-Entity-Encoding: false` 헤더를 넣는다.

---

## Status Codes & Error Responses

| 코드 | 설명 |
|---|---|
| 200 | 성공. 반환 정보는 메서드에 따름 |
| 201 | 성공. 새 리소스 생성 |
| 202 | 처리 수락, 미완료 |
| 204 | 성공, 응답 내용 없음(DELETE 등) |
| 400 | 요청 이해 불가(보통 ID가 리소스에 부적합 — 예: groupId 자리에 userId) |
| 401 | 세션 ID/OAuth 만료·무효, 또는 guest 접근 불가 리소스. body에 message·errorCode |
| 403 | 거부. 권한/외부 유저 확인 |
| 404 | 리소스 없음/삭제됨 |
| 409 | 충돌(이미 승인/거부된 group join 업데이트 등) |
| 410 | 리소스 은퇴/제거 |
| 412 | precondition 실패(batch에서 haltOnError=true 후속 subrequest) |
| 422 | 무효 데이터로 처리 불가 |
| 429 | 24시간 내 요청 과다 |
| 500 | Salesforce 내부 오류 |
| 503 | 1시간 내 요청 과다 또는 유지보수 다운 |

에러 응답 예:

```
HTTP/1.1 400 Bad Request
Content-Type: application/json;charset=UTF-8
[ { "errorCode":"INVALID_ID_FIELD", "message":"Invalid identifier: 0D5D0000000XZoHKAW" } ]
```

---

## 핵심 헤더 요약

| 헤더 | 용도 |
|---|---|
| `Authorization` | OAuth access token / Bearer token |
| `Content-Type` | 입력 데이터 포맷(form-urlencoded / json / xml / octet-stream) |
| `Accept` | 응답 포맷(application/json · application/xml) |
| `Accept-Language` | 응답 지역화 언어 override |
| `X-Chatter-Entity-Encoding` | `false`로 raw(비인코딩) 응답 |
| `X-Connect-Theme` | UI 테마(`Classic` / `Salesforce1`, case-sensitive) |
| `X-Connect-Bearer-Urls` | bearer token URL 반환 활성화 |
| `X-PrettyPrint` | 응답 pretty-print |
| `_HttpMethod` | 메서드 override용 **param**(case-sensitive) |

---

## 관련 노트
- [[Connect REST API 개요]] — 자매 노트(용도·아키텍처·인증·Limits)
- [[ConnectApi Namespace 개요]] — Apex 측 짝(Connect in Apex)
- [[REST API]] — 표준 REST API와의 대비
