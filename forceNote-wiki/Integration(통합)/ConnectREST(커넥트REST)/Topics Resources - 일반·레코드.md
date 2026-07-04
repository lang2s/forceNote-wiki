---
tags: [integration, connect-rest-api, topics, topic-assignment, trending-topics]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p722–736; Tier 1/2)
created: 2026-07-04
aliases: [Topics, 토픽, Topic CRUD, 토픽 병합, merge topics, Trending Topics, Topic Suggestions, Topics on Records, 레코드 토픽, topic assignment]
---

# Topics Resources - 일반·레코드

> Connect REST API의 일반 토픽 리소스 — 토픽 조회·생성·수정·병합·삭제, article 할당, 할당 규칙, 제안·트렌딩, 관련 토픽, 그리고 레코드/피드 항목에 토픽을 붙이는 Topics on Records까지 10개 엔드포인트.

---

> [!note] 이 노트의 Topics는 **엔터티(Topic) 자체를 다루는 리소스**다.
> Chatter 클러스터의 Topics 리소스(토픽 endorsement, opt-out 등)와는 **별개**다 → [[Topics · Announcements · Q&A Resources]] 참조.
> Experience Cloud 사이트의 managed topic(계층·featured·navigational)은 자매 노트 [[Managed Topics Resources - Experience Cloud]] 소관.

## 레거시 경로 주의

- v28.0에서는 `/chatter/topics/...` 경로였다. **v29.0+는 `/connect/topics/...`** 로 이동했다.
- 개별 엔드포인트의 레거시 경로는 아래 표의 `v` 열에 병기했다.
- Experience Cloud 변형은 `/connect/communities/{communityId}/...` 접두를 쓴다(Topics on Records 참조).

base URI·페이지네이션·요청 헤더 규약은 [[Connect REST API 요청·응답 규약]] 참조. 응답 스키마(Topic, Topic Collection, Topic Suggestion Collection 등)의 전체 필드는 Reference 챕터 위임 — 이 노트는 엔드포인트·파라미터·Input body에 집중한다.

---

## A. Topics Resources (9)

> 개요: 토픽 조회·수정·병합·삭제, article에 토픽 할당/해제, 토픽·article 할당 규칙 조회·생성·재할당, 텍스트/피드 항목/레코드에 대한 제안 토픽 조회, 트렌딩 토픽 조회, 토픽에 최근 올라온 파일 조회, 관련 토픽 조회, 토픽의 최다 조회 article 조회.

| # | URI (`/connect/`) | 메서드 | 버전 | 응답 |
|---|---|---|---|---|
| A1 List of Topics | `topics` | GET / POST / HEAD (POST v36+) | 29.0 (v28 `/chatter/topics`) | GET→Topic Collection, POST→Topic |
| A2 Topic & Article Assignments | `topics/data-category-groups/{dcg}/data-categories/{dc}/articles` | POST | 40.0 | Topic Collection |
| A3 Topic & Article Assignment Rules | `topics/data-category-rules/data-category-groups/{dcg}/data-categories/{dc}` | GET / POST / PUT | 40.0 | Topic Collection |
| A4 Topics Suggestions | `topics/suggestions` | GET / HEAD | 29.0 | Topic Suggestion Collection |
| A5 Trending Topics | `topics/trending` | GET / HEAD | 29.0 (v24–28 `/chatter/topics/trending`) | Topic Collection |
| A6 Topic | `topics/{topicId}` | GET / PATCH / DELETE / HEAD | 29.0 (v28 `/chatter/topics/{id}`) | GET/PATCH→Topic, DELETE→204 |
| A7 Topic Files | `topics/{topicId}/files` | GET / HEAD | 29.0 | File Summary Page (최근 파일 5) |
| A8 Related Topics | `topics/{topicId}/related-topics` | GET / HEAD | 29.0 (v28 `/chatter/topics/{id}/relatedtopics` — 하이픈 없음) | Topic Collection |
| A9 Top Viewed Articles | `topics/{topicId}/top-viewed-articles` | GET | 41.0 | Knowledge Article Version Collection |

### A1 — List of Topics

토픽 목록 조회(GET), 신규 토픽 생성(POST v36+).

GET 파라미터:

| 파라미터 | 타입 | 버전 | 설명 |
|---|---|---|---|
| `exactMatch` | Boolean | 28.0 | `q`와 함께 정확 case-insensitive 매치. 기본 `false`. |
| `fallBackToRenamedTopics` | Boolean | 35.0 | `exactMatch=true`이고 매치가 없을 때, 최근 이름이 바뀐 토픽으로 폴백. |
| `page` | Integer | 28.0 | 기본 0. |
| `pageSize` | Integer | 28.0 | 1–100, 기본 25. |
| `q` | String | 28.0 | 2자 이상 검색어. |
| `sort` | String | 28.0 | `popularDesc`(기본) / `alphaAsc`. |

POST body root `<topic>`:

| 프로퍼티 | 타입 | 버전 |
|---|---|---|
| `description` | String | 36.0 |
| `name` | String | 36.0 |

예: `GET /connect/topics?sort=alphaAsc`

```json
// POST /connect/topics 요청 body (덤프 예시값)
{
  "description": "The World Wide Web Consortium (W3C) standards body.",
  "name": "W3C"
}
```

### A2 — Topic & Article Assignments (POST)

data category의 article에 토픽을 일괄 할당/해제.

POST body root `<ArticleTopicAssignmentJob>`:

| 프로퍼티 | 타입 | 필수 | 버전 | 설명 |
|---|---|---|---|---|
| `operation` | String | Req | 40.0 | enum `AssignTopicsToArticle` / `UnassignTopicsFromArticle` |
| `topicNames` | Topic Names Input | Req | 40.0 | 할당/해제할 토픽 이름 목록 (Input 스키마는 Reference 위임) |

```json
// POST .../articles 요청 body (덤프 예시값)
{
  "operation": "AssignTopicsToArticle",
  "topicNames": ["API", "Connect REST API", "ConnectApi"]
}
```

### A3 — Topic & Article Assignment Rules (GET / POST / PUT)

data category와 토픽 사이의 할당 규칙을 조회(GET)·생성(POST)·재할당(PUT). **PUT은 기존 규칙을 삭제한 뒤 다시 생성**한다(재할당).

body root `<topicNamesCollection>`:

| 프로퍼티 | 타입 | 필수 | 버전 | 설명 |
|---|---|---|---|---|
| `topicNames` | String[] | Req | 35.0 | feed item 최대 10개 · record 최대 100개 |
| `topicSuggestions` | String[] | Opt | 37.0 | |

### A4 — Topics Suggestions (GET)

텍스트, 피드 항목, 또는 레코드에 대한 제안 토픽 조회.

| 파라미터 | 타입 | 버전 | 설명 |
|---|---|---|---|
| `maxResults` | Integer | | Opt, 기본 5, `0 < n ≤ 25` |
| `recordId` | String | 30.0 | `text` 미사용 시 Req. 18자 feed item / record ID. 해당 객체에 토픽이 활성화돼 있어야 함. |
| `text` | String | | `recordId` 미사용 시 Req. |

예: `GET /connect/topics/suggestions?text=Working+on+the+planning+meeting...`

### A5 — Trending Topics (GET)

상위 5개 트렌딩 토픽.

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `maxResults` | Integer | 기본 5, `0 < n < 100` |

⚠️ **v28.0 미만**에서는 트렌딩 토픽 이름이 `#`로 시작한다(예: 응답 `{"name":"#API"}`). v28.0+ 응답은 `createdDate`·`id`·`description`·`talkingAbout`·`name`·`url`을 포함한다.

```json
// GET /connect/topics/trending 응답 (덤프 예시값 — v28 미만 형태)
{
  "name": "#API"
}
```

### A6 — Topic (GET / PATCH / DELETE)

단일 토픽 조회·수정·병합·삭제.

**권한:**

| 작업 | 필요 권한 |
|---|---|
| 이름·설명 수정 | Edit Topics 또는 Modify All Data |
| 병합·삭제 | Delete Topics 또는 Modify All Data |

PATCH body root `<topic>`:

| 프로퍼티 | 타입 | 버전 | 설명 |
|---|---|---|---|
| `description` | String | 28.0 | |
| `idsToMerge` | String[] | 33.0 | primary 토픽과 병합할 secondary 토픽 **최대 5개**. secondary가 navigational/featured면 type·images·children을 잃고, secondary의 feed item은 primary로 재할당. content 병합 시 association 보존. |
| `name` | String | 28.0 | 대소문자·띄어쓰기만 변경 가능. |

**DELETE는 비동기.** 삭제 완료 전에 해당 토픽을 요청하면 `200` + Topic의 `isBeingDeleted=true`(v33.0+)를 반환한다. 완료 후에는 `404`.

예: `PATCH /connect/topics/{topicId}?description=Edit+requests`

```json
// PATCH /connect/topics/{topicId} 요청 body (덤프 예시 — merge)
{
  "idsToMerge": ["0TOD000000000nmOAA", "0TOD000000000nnPBB"]
}
```

### A7 — Topic Files (GET)

토픽에 최근 올라온 파일 5개. 응답은 File Summary Page(대표 필드 — `checksum`·`contentSize`·`downloadUrl`·`fileType`·`owner`·`photo`; 전체 스키마는 Reference 위임).

### A8 — Related Topics (GET)

가장 관련이 큰 토픽 5개. **관련 규칙: 같은 feed item에 3회 이상 함께 할당된 두 토픽을 "관련"으로 본다.**

### A9 — Top Viewed Articles (GET)

토픽의 최다 조회 Knowledge article.

| 파라미터 | 타입 | 버전 | 설명 |
|---|---|---|---|
| `maxResults` | Integer | 41.0 | Opt, 1–25, 기본 5 |

---

## B. Topics on Records Resource (1)

> 개요: record/feed item에 할당된 토픽 조회, 추가·제거·교체. 향후 제안 개선을 위해 토픽 제안도 가능. **Assign Topics** 권한 = 기존 토픽 추가·제거, **Create Topics** 권한 = 신규 토픽 추가. 관리자가 해당 객체에 토픽을 활성화해 둬야 한다.

| URI | 메서드 | 버전 | 응답 |
|---|---|---|---|
| `records/{recordId}/topics` (EC: `/connect/communities/{cId}/records/{recordId}/topics`) | GET / DELETE / POST / PUT (PUT v35+) | 30.0 | POST→Topic, PUT→Topic Collection, DELETE→204 |

**DELETE 파라미터:**

| 파라미터 | 타입 | 필수 | 버전 |
|---|---|---|---|
| `topicId` | String | Req | 30.0 |

**POST** body root `<topicAssignment>`:

| 프로퍼티 | 타입 | 필수 | 버전 | 설명 |
|---|---|---|---|---|
| `topicId` | String | Req | 30.0 | `topicName` 미사용 시 · 기존 토픽에 사용 |
| `topicName` | String | Req | 30.0 | 신규 토픽에 사용 · `topicId` 미사용 시 · 기존 토픽에도 사용 가능 |

예: `POST /connect/records/006.../topics?topicId=0TOD...`

**PUT (전체 재할당)** body root `<topicNamesCollection>`:

| 프로퍼티 | 타입 | 필수 | 버전 | 설명 |
|---|---|---|---|---|
| `topicNames` | String[] | Req | 35.0 | feed item 최대 10개 · record 최대 100개 |
| `topicSuggestions` | String[] | Opt | 37.0 | |

PUT은 레코드의 토픽 전체를 넘긴 목록으로 교체한다.

```json
// PUT /connect/records/{recordId}/topics 요청 body (덤프 예시값)
{
  "topicNames": ["API", "Connect REST API", "ConnectApi"]
}
```

---

## enum 요약

| enum | 값 |
|---|---|
| `sort` (A1) | `popularDesc` · `alphaAsc` |
| `operation` (A2) | `AssignTopicsToArticle` · `UnassignTopicsFromArticle` |

Input 스키마명: **Topic Names Input**(A2) — 전체 필드는 Reference 챕터 위임.

---

## 관련 노트
- [[Managed Topics Resources - Experience Cloud]] — Experience Cloud 사이트의 managed topic(계층·featured·navigational), 일반 토픽과 대비
- [[Topics · Announcements · Q&A Resources]] — Chatter 클러스터의 Topics 리소스(endorsement 등), 이 노트와 별개
- [[Connect REST API 요청·응답 규약]] — base URI·페이지네이션·요청 헤더
- [[Connect REST API 개요]] — 상위 개요
