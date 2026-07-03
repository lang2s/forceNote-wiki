---
tags: [integration, connect-rest-api, feeds, feed-types, news-feed]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p854–936 Feeds Resources; Tier 1/2)
created: 2026-07-03
aliases: [Feeds, 피드, Feed Types, 피드 타입, News Feed, Record Feed, Feed Directory, 피드 종류]
---

# Connect REST API — Feeds Resources

> 피드(feed)는 feed item으로 구성되며, feed type마다 어떤 feed item을 담을지 결정하는 고유 알고리즘이 있다. news·record·user-profile 피드만 GET+POST를 지원하고 나머지 feed type은 모두 GET만 지원한다.

---

## 개요

원문: *"Feeds are made up of feed items. There are many feed types. Each feed type has an algorithm that determines which feed items it contains. The news feed, record feed, and user profile feed support GET and POST requests. All other feeds support GET requests."*

- **피드 = feed item의 모음.** feed type마다 담기는 항목을 정하는 알고리즘이 다르다.
- **POST(글 작성) 가능한 feed type은 news·record·user-profile 3종뿐**이다. 나머지 feed type은 GET(+HEAD) 전용으로 조회만 한다.
  - POST 요청 바디는 이 노트가 아니라 [[Feed Elements Resources]]의 **Feed Item Input**을 그대로 사용한다. (pdftotext로 추출한 파라미터 표에는 GET,HEAD만 노출되지만, 인트로 근거상 위 3종은 POST 가능하다.)
- 모든 `/chatter/...` URI에는 Experience Cloud 사이트용으로 `/connect/communities/{communityId}` 접두를 붙인 버전이 병존한다. URI의 `{userId}`에는 실제 사용자 ID 또는 별칭 `me`를 쓸 수 있다.

### 리소스 → 응답 타입 규칙

각 feed type은 보통 두 개의 리소스로 나뉜다.

```
// 구조 예시 — 실제 URI 패턴 (feed type = record 예시)
GET /chatter/feeds/record/{recordId}                 → Feed           (피드 메타/URL 모음)
GET /chatter/feeds/record/{recordId}/feed-elements   → Feed Element Page (실제 항목 목록)
```

| 리소스 형태 | 응답 타입 |
|---|---|
| feed type URL 리소스 (`.../{type}`) | **Feed** — `feedElementsUrl`, `feedElementPostUrl` 등 URL 모음 |
| elements 리소스 (`.../{type}/feed-elements`) | **Feed Element Page** — 실제 feed element 컬렉션 |
| directory류 (`/chatter/feeds/`, `filter/{userId}`) | **Feed Directory** — 볼 수 있는 feed 목록 |

> Feed·Feed Element Page의 대표 프로퍼티는 아래 [응답 바디](#응답-바디-대표) 참조. 전체 스키마와 feed type별 개별 파라미터는 Reference 챕터로 위임.

---

## Feed Type 23종 전수

각 feed type = URL 리소스(`.../{type}` → **Feed**) + elements 리소스(`.../{type}/feed-elements` → **Feed Element Page**). 아래는 URL 리소스 기준 버전(v)·메서드 특이사항·설명.

| Feed Type | URI | v | 메서드 | 설명 |
|---|---|---|---|---|
| Bookmarks | `/chatter/feeds/bookmarks/{userId}` | 24.0 | GET, HEAD | 사용자가 북마크한 feed element |
| Company | `/chatter/feeds/company` | 23.0 | GET, HEAD | 회사 전체 피드 |
| Direct Messages | `/chatter/feeds/direct-messages` | 39.0 | GET, HEAD | DM(다이렉트 메시지) 피드 |
| DM Moderation | `/chatter/feeds/direct-message-moderation` | 40.0 | GET, HEAD | 플래그된 DM (Moderate Experiences Chatter Messages 권한 필요) |
| Draft | `/chatter/feeds/draft/me` | 44.0 | GET, HEAD | 초안(draft) 게시물 |
| Favorites | `/chatter/feeds/favorites/{userId}` | 24.0 | GET, HEAD, **POST** | 즐겨찾기 목록 (POST로 생성 — 아래 참조) |
| Feeds Directory | `/chatter/feeds/` | 23.0 | GET, HEAD | 볼 수 있는 모든 feed 목록 → **Feed Directory** 응답 |
| Files | `/chatter/feeds/files/{userId}` | 23.0 | GET, HEAD | 팔로우 대상이 올린 파일 게시물 |
| Filter | `/chatter/feeds/filter/{userId}` | 23.0 | GET, HEAD | news를 object type으로 필터 → **Feed Directory** 응답 (아래 참조) |
| EC Home | `/chatter/feeds/home` | 32.0 | GET, HEAD | Experience Cloud 사이트 홈 피드 |
| EC Moderation | `/chatter/feeds/moderation` | 32.0 | GET, HEAD | 사이트에서 플래그된 feed element |
| Groups | `/chatter/feeds/groups/{userId}` | 23.0 | GET | 소유·소속 그룹 전체 피드 |
| Isolated | `/chatter/feeds/isolated` | 60.0 | GET, HEAD | isolated 피드 (admin) |
| Landing | `/chatter/feeds/landing` | — | GET, HEAD | landing 정보 + feed element |
| Mute | `/chatter/feeds/mute/{userId}` | 35.0 | GET, HEAD | 사용자가 mute한 feed element |
| News | `/chatter/feeds/news/{userId}` | 23.0 | GET, HEAD (**POST 가능**) | 사용자 관심 feed element (뉴스 피드) |
| Pending Review | `/chatter/feeds/pending-review` | 39.0 | GET, HEAD | 검토 대기(pending review) 항목 |
| People | `/chatter/feeds/people/{userId}` | 23.0 | GET, HEAD | 팔로우하는 사람들의 피드 |
| Record | `/chatter/feeds/record/{recordId}` | 23.0 | GET, HEAD (**POST 가능**) | 레코드 피드 (다른 사용자도 조회 가능) |
| Streams | `/chatter/feeds/streams/{streamId}` | 39.0 | GET, HEAD | 스트림 피드 (아래 참조) |
| To | `/chatter/feeds/to/{userId}` | 23.0 | GET, HEAD | @멘션 + 타인이 올린 게시물 |
| Topics | `/chatter/feeds/topics/{topicId}` | 28.0 | GET, HEAD | 토픽 피드 |
| User Profile | `/chatter/feeds/user-profile/{userId}` | — | GET, HEAD (**POST 가능**) | 사용자가 생성/부모/멘션된 feed element (타 사용자 조회 가능) |

> **POST 가능 = News · Record · User Profile 3종.** 나머지 20종은 GET(+HEAD) 전용. (Favorites의 POST는 즐겨찾기 *생성*이지 feed element 게시가 아님 — 아래 특이 리소스 참조.)

---

## 특이 리소스

### Favorites — POST / PATCH / DELETE

| 리소스 | URI | v | 메서드 | 설명 |
|---|---|---|---|---|
| 목록 | `/chatter/feeds/favorites/{userId}` | 24.0 | GET, HEAD, POST | POST로 Favorite 생성 |
| 단건 | `/chatter/feeds/favorites/{userId}/{favoriteId}` | 24.0 | GET, HEAD, PATCH, DELETE | PATCH로 마지막 조회일 갱신, DELETE로 삭제 |
| elements | `/chatter/feeds/favorites/{userId}/{favoriteId}/feed-elements` | 31.0 | GET | Feed Element Page |

```json
// 구조 예시 — 실제 동작 설정 아님 (Favorite POST 바디)
{ "searchText": "release", "targetId": "0TO..." }
```

```json
// 구조 예시 — Favorite PATCH 바디 (마지막 조회일 갱신)
{ "updateLastViewDate": "true" }
```

### Record / Topics — pinned-feed-elements (핀 고정)

| 리소스 | URI | v | 메서드 | 응답 |
|---|---|---|---|---|
| Record pinned | `/chatter/feeds/record/{recordId}/pinned-feed-elements` | 41.0 | GET, PATCH | Pinned Feed Element Collection (pin/unpin) |
| Topics pinned | `/chatter/feeds/topics/{topicId}/pinned-feed-elements` | 41.0 | GET, PATCH | Pinned Feed Element Collection |

> Pinned Feed Element Collection 응답은 일부 capability 정보를 포함하지 않는다.

### News — is-modified (변경 폴링)

| 리소스 | URI | v | 메서드 | 설명 |
|---|---|---|---|---|
| News is-modified | `/chatter/feeds/news/{userId}/is-modified` | 26.0 | GET, HEAD | `since` 파라미터로 뉴스 피드 변경 여부 확인 |

### Filter — keyPrefix로 object type 필터

| 리소스 | URI | v | 메서드 | 설명 |
|---|---|---|---|---|
| Filter 목록 | `/chatter/feeds/filter/{userId}` | 23.0 | GET, HEAD | Feed Directory (User 005·Group 0F9 제외) |
| Filter specific | `/chatter/feeds/filter/{userId}/{keyPrefix}` | 23.0 | GET, HEAD | news를 object type으로 필터. `keyPrefix` = 레코드 ID 앞 3자(key prefix) |

### Streams — 스트림(최대 25)

`/chatter/feeds/streams/{streamId}` (v39.0, GET·HEAD) — 하나의 스트림은 **최대 25개**의 people·groups·records·topics를 묶어 볼 수 있다.

---

## feed-elements 공통 GET 파라미터

`.../{feedType}/feed-elements` 조회 시 공통으로 쓰는 파라미터. (feed type별 지원 파라미터는 상이하며 개별 표는 Reference 챕터로 위임.)

| Param | Type | 필수 | v | 설명 |
|---|---|---|---|---|
| density | String | Opt | 31.0 | `AllUpdates`(기본) / `FewerUpdates` |
| elementsPerBundle | Integer | Opt | 31.0 | 0–10, 기본 3 (번들 = record feed 전용) |
| pageSize | Integer | Opt | 31.0 | 1–100 |
| q | String | Opt | 31.0 | 검색어 (와일드카드 지원) |
| recentCommentCount | Integer | Opt | 31.0 | element당 comment 최대, 기본 3, 최대 25 |
| sort | String | Opt | 31.0 | 정렬 enum ([[Feed Elements Resources]]의 sort enum과 동일; 기본 `CreatedDateDesc`) |
| updatedSince | String | Opt | 31.0 | opaque 토큰 (Feed Element Page의 `updatesToken`에서 취득 — 직접 생성 금지) |

---

## 응답 바디 (대표)

> 대표 프로퍼티만 기재. 전체 스키마와 개별 feed 파라미터는 Reference 챕터로 위임. POST 요청 바디는 [[Feed Elements Resources]]의 Feed Item Input 참조.

### Feed (feed type URL GET 응답)

- `feedElementPostUrl` (31.0)
- `feedElements` (Feed Element Page, 40.0)
- `feedElementsUrl` (31.0)
- `feedItemsUrl` (23.0–31.0; `X-Connect-Bearer-Urls: true` 시 bearer token POST용)
- `isModifiedUrl` (23.0, news 폴링)
- `pinnedFeedElementsUrl` (41.0)
- `respectsMute` (35.0)
- `redirectedFeedType` / `redirectedFeedFilter` / `redirectedFeedSort` … (전체 Reference 위임)

### Feed Element Page (feed-elements GET 표준 응답)

- `currentPageToken` (37.0)
- `currentPageUrl` (31.0)
- `elements` (31.0; Generic Feed Element 또는 Feed Item 컬렉션)
- `isModifiedToken` / `isModifiedUrl` (31.0, news 폴링)
- `nextPageUrl` (31.0)
- `updatesToken` (31.0)
- `updatesUrl` (31.0)

---

## 관련 노트
- [[Feed Elements Resources]] — 피드가 담는 feed element, capability, POST용 Feed Item Input
- [[Connect REST API 요청·응답 규약]] — base URI·페이지네이션·헤더
- [[Connect REST API 개요]] — Connect REST API 상위 개요
