---
tags: [integration, connect-rest-api, feed-elements, capabilities, message-segment]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p797–853 Feed Elements Resources; Tier 1/2)
created: 2026-07-03
aliases: [Feed Elements, 피드 요소, Feed Element Capabilities, Message Segment, Feed Item Input, 피드 게시, capability]
---

# Connect REST API — Feed Elements Resources

> Chatter 피드 요소(feed element)를 조회·게시·검색·삭제하고, 각 요소의 capability(좋아요·댓글·투표·북마크·파일·주제 등)에 접근하는 `/chatter/feed-elements` 리소스 계열.

원문 개요: *"Information about feed elements. Access, edit, post, search, and delete feed elements. Access a feed element's capabilities, including bundles and their feed elements."*

- 모든 base `/chatter/...` URI에는 Experience Cloud용 `/connect/communities/{communityId}` 접두 버전이 병존한다.
- 피드 요소가 **어떤 피드에서 반환되는지**(feed type별 지도)는 [[Feeds Resources]] 소관이다. 이 노트는 요소 자체와 그 capability를 다룬다.

---

## 1. 핵심 리소스

| 리소스 | URI | v | 메서드 | 응답 |
|---|---|---|---|---|
| Post & Search | `/chatter/feed-elements` | 31.0 | GET, POST | GET → Feed Element Page, POST → Feed Item |
| Batch Post | `/chatter/feed-elements/batch` | 32.0 | POST, HEAD | Batch Results (최대 500) |
| Batch Get | `/chatter/feed-elements/batch/{feedElementIds}` | 31.0 | GET | Batch Results (최대 500, comma-separated) |
| 단건 | `/chatter/feed-elements/{feedElementId}` | 31.0 | GET, PATCH, DELETE | GET → Generic Feed Element 또는 Feed Item, PATCH → Feed Item(FeedItem만 편집 가능), DELETE → 204 |
| Capabilities 집합 | `/chatter/feed-elements/{feedElementId}/capabilities` | 31.0 | GET | Feed Element Capabilities |
| Publish draft | `/chatter/feed-elements/publish-draft` | 44.0 | POST | Feed Item |
| Related questions | `/chatter/feed-elements/{feedElementId}/related-posts` | 37.0 | GET | 연관 질문 (feedElementId는 question ID; 필터 `Answered`/`BestAnswer`/`Unanswered`) |

- **편집 제약:** 단건 PATCH는 `FeedItem` 타입 요소만 편집 가능하다.
- **배치:** batch 리소스는 최대 500개 요소를 한 번에 처리하며 comma-separated ID 목록을 받는다.

---

## 2. Capability 리소스 (전수)

각 capability는 `/chatter/feed-elements/{feedElementId}/capabilities/{cap}` 하위에 위치한다. 기본 메서드는 GET(또는 GET, HEAD)이며, **쓰기 메서드(POST/PATCH/DELETE)를 가진 것이 상호작용의 핵심**이다.

### 2.1 쓰기 메서드가 있는 capability (상호작용용)

| Capability | URI 조각 | v | 메서드 | 응답 / 동작 |
|---|---|---|---|---|
| **bookmarks** | `bookmarks` | 32.0 | GET, PATCH | Bookmarks Capability — 북마크 조회/추가 |
| **chatter-likes/items** | `chatter-likes/items` | 32.0 | GET, PATCH, POST | GET/PATCH → Like Page, POST → Like (좋아요/취소) |
| **comments/items** | `comments/items` | 32.0 | GET, POST | GET → Comment Page, POST → Comment (multipart로 파일 첨부 가능) |
| **moderation** | `moderation` | 31.0 | GET, POST, DELETE, HEAD | Moderation Capability — **Experience Cloud 전용, `/connect/communities` 접두 필수** |
| **poll** | `poll` | 32.0 | GET, PATCH | Poll Capability — 투표 |
| **read-by** | `read-by` | 40.0 | GET, PATCH | Read By Capability — 읽음 표시 |
| **topics** | `topics` | 32.0 | GET, POST, DELETE | POST → Topic, GET → Topics Capability |
| **up-down-vote** | `up-down-vote` | 41.0 | GET, PATCH | Up Down Vote Capability |
| close | `close` | 43.0 | GET, PATCH | (질문 종료 등) |
| direct-message | `direct-message` | 39.0 | GET, PATCH | |
| mute | `mute` | 35.0 | GET, HEAD, PATCH | Mute Capability |
| question-and-answers | `question-and-answers` | 32.0 | GET, PATCH | |
| status | `status` | 37.0 | GET, HEAD, PATCH | |
| batch read-by | `/chatter/feed-elements/batch/{ids}/capabilities/read-by` | 40.0 | PATCH | Batch Results (배치 읽음 표시) |

### 2.2 조회 중심 capability (GET / GET,HEAD)

| Capability | URI 조각 | v | 응답 / 비고 |
|---|---|---|---|
| approval | `approval` | 32.0 | Approval Capability (GET, HEAD) |
| associated-actions | `associated-actions` | 33.0 | Associated Actions |
| banner | `banner` | 32.0 | Banner |
| bundle | `bundle` | 31.0 | Generic Bundle 또는 Tracked Change Bundle Capability |
| bundle/feed-elements | `bundle/feed-elements` | 31.0 | Feed Element Page — *bundled posts = feed-tracked changes, record feeds 전용* |
| call-collaboration | `call-collaboration` | 51.0 | |
| canvas | `canvas` | 32.0 | |
| case-comment | `case-comment` | 32.0 | |
| chatter-likes | `chatter-likes` | 32.0 | Chatter Likes Capability |
| comments | `comments` | 32.0 | Comments Capability |
| content | `content` | 32.0 | |
| dashboard-component-snapshot | `dashboard-component-snapshot` | 32.0 | |
| direct-message/members | `direct-message/members` | 39.0 | Direct Message Member Collection |
| direct-message/original-members | `direct-message/original-members` | 40.0 | |
| direct-message/membership-activity | `direct-message/membership-activity` | 40.0 | |
| edit/is-editable-by-me | `edit/is-editable-by-me` | 34.0 | Feed Entity Is Editable |
| email-message | `email-message` | 32.0 | |
| enhanced-link | `enhanced-link` | 32.0 | |
| extensions | `extensions` | 40.0 | |
| feed-entity-share | `feed-entity-share` | 39.0 | |
| files | `files` | 37.0 | Files Capability |
| interactions | `interactions` | 37.0 | |
| link | `link` | 32.0 | |
| media-references | `media-references` | 41.0 | |
| origin | `origin` | 33.0 | 존재 시 feed action이 생성 |
| read-by/items | `read-by/items` | 40.0 | Read By Collection (누가 언제 읽었나) |
| recommendations | `recommendations` | 32.0 | |
| record-snapshot | `record-snapshot` | 32.0 | |
| social-post | `social-post` | 37.0 | (요약표 미기재) |
| tracked-changes | `tracked-changes` | 32.0 | |
| up-down-vote/items | `up-down-vote/items` | 42.0 | Vote Collection |

---

## 3. 검색 파라미터 (GET `/chatter/feed-elements`)

| Param | Type | 필수 | v | 설명 |
|---|---|---|---|---|
| page | String | Opt | 31.0 | 페이지 토큰(current/nextPageToken). null = 첫 페이지 |
| pageSize | Integer | Opt | 31.0 | 1–100, 기본 25 |
| q | String | **Req** | 31.0 | 검색 키워드(와일드카드 가능, 비-와일드카드는 2자 이상) |
| recentCommentCount | Integer | Opt | 31.0 | element당 comment 최대, 기본 3 |
| sort | String | Opt | 31.0 | 아래 enum |
| threadedCommentsCollapsed | Boolean | Opt | 44.0 | 기본 false |

**sort enum (5종) — 각 값의 피드 제약:**

| enum | 의미 | 제약 |
|---|---|---|
| `CreatedDateAsc` | 오래된 순 | DirectMessageModeration · Draft · Isolated · Moderation · PendingReview 피드 전용 |
| `CreatedDateDesc` | 최신 생성 순 | — |
| `LastModifiedDateDesc` | 최근 활동 순 | — |
| `MostViewed` | 조회 많은 순 | Home 피드 + `FeedFilter=UnansweredQuestions` 전용 |
| `Relevance` | 관련도 순 | Company · Home · Topics 피드 전용 |

---

## 4. POST — Feed Item Input

피드 아이템·댓글 body는 **10,000자 제한**이다. 정확한 길이는 `describeSObjects`로 `FeedItem.Body` / `FeedComment.CommentBody`를 확인한다.

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `feedElementType` | String | **Req** | 유일 값 `FeedItem` |
| `subjectId` | String | **Req** | 부모 ID(user/group/record) 또는 `me` |
| `body` | Message Body Input | 조건부 Req | content/link capability가 없으면 Req; 최대 25 mentions |
| `capabilities` | Feed Element Capabilities Input | Opt | files · poll · directMessage · feedEntityShare · bookmarks 등 중첩 |
| `visibility` | String | Opt | `AllUsers` / `InternalUsers` |
| `originalFeedElementId` | String | Opt | v31–38.0 전용 (v39.0+는 `capabilities.feedEntityShare` 사용) |

---

## 5. Message Segment Input (8종)

`body.messageSegments[]` 배열에 세그먼트를 나열해 리치 텍스트를 구성한다.

| type | v | 프로퍼티 |
|---|---|---|
| Text | 23.0 | `text` (plain; 링크처럼 보이면 자동 link, `#[..]`는 hashtag로 변환) |
| Mention | 23.0 (그룹 29.0) | `id`(user/group), `username`(v38.0, user만; id/username 택1). 최대 25 |
| Hashtag | 23.0 | `tag`(# 제외; `]` 미지원) |
| Link | 23.0 | `url` |
| InlineImage | 35.0 | `fileId` **Req**, `altText` Opt |
| MarkupBegin | 35.0 | `markupType` **Req**, `url`(Hyperlink 시 Req v45.0), `altText`(v45.0 Opt) |
| MarkupEnd | 35.0 | `markupType` **Req** |
| EntityLink | 43.0 | `entityId` **Req** (권한 있는 사용자에게만 표시) |

**markupType enum (10종):** `Bold`, `Code`, `Hyperlink`, `Italic`, `ListItem`, `OrderedList`, `Paragraph`, `Strikethrough`, `Underline`, `UnorderedList`.
(`Code`는 text segment만 포함 가능)

---

## 6. POST 예제

아래는 모두 공식 가이드에서 인용한 요청 바디다. `005D...`, `069...`, `0F9...` 등 ID는 **예시값**이며 실제 org의 ID로 대체해야 한다.

기본 텍스트 게시:

```json
{
  "body": { "messageSegments": [
    { "type": "Text", "text": "When should we meet for release planning? " }
  ] },
  "feedElementType": "FeedItem",
  "subjectId": "005D00000016Qxp"
}
```

@mention 포함:

```json
{
  "body": { "messageSegments": [
    { "type": "Text", "text": "When should we meet? " },
    { "type": "Mention", "id": "005T0000000mzCy" }
  ] },
  "feedElementType": "FeedItem",
  "subjectId": "005D00000016Qxp"
}
```

파일 첨부 (files capability):

```json
{
  "body": { "messageSegments": [
    { "type": "Text", "text": "Please take a look at these files." }
  ] },
  "capabilities": { "files": { "items": [
    { "id": "069D00000001IOh" },
    { "id": "069D00000002IOg" }
  ] } },
  "subjectId": "me",
  "feedElementType": "FeedItem"
}
```

투표 (poll capability):

```json
{
  "body": { "messageSegments": [
    { "type": "Text", "text": "When should we meet?" }
  ] },
  "capabilities": { "poll": { "choices": [ "Monday", "Tuesday" ] } },
  "feedElementType": "FeedItem",
  "subjectId": "me"
}
```

다이렉트 메시지 (directMessage capability):

```json
{
  "body": { "messageSegments": [
    { "type": "Text", "text": "Thanks for attending... Send me feedback." }
  ] },
  "capabilities": { "directMessage": {
    "membersToAdd": [ "005R0000000I2X4", "005R0000000I23Y" ],
    "subject": "Thank you!"
  } },
  "subjectId": "me",
  "feedElementType": "FeedItem"
}
```

**URL 파라미터 방식**(간단한 게시·검색은 body 없이 쿼리스트링으로도 가능):

```
POST /chatter/feed-elements?feedElementType=FeedItem&subjectId=0F9B000000000W2&text=New+post
GET  /chatter/feed-elements?q=track
```

---

## 7. 대표 응답 바디

> 전체 스키마·프로퍼티 전수는 **Response Bodies Reference 챕터로 위임**한다. 아래는 이 리소스가 반환하는 대표 바디의 요지만 수록한다.

**Feed Element Page** (feed-elements GET 표준 응답)
`currentPageToken`(37.0) · `currentPageUrl`(31.0) · `elements`(31.0; Generic Feed Element 또는 Feed Item 컬렉션) · `isModifiedToken`/`isModifiedUrl`(31.0, news polling) · `nextPageUrl`(31.0) · `updatesToken`(31.0) · `updatesUrl`(31.0).

**Feed Item** (feed element의 한 유형)
`actor`(29.0; Record Summary / User Summary / Unauthenticated User) · `body`(Feed Item Body 23.0) · `capabilities`(Feed Element Capabilities 31.0) · `canShare`(27–38.0; v39+ `isSharable`) · `clientInfo` · `feedElementType` · `createdDate` … (전체 Reference 위임)

**Feed Element Capabilities** (capability 컨테이너) — v31+ 모든 element가 보유. **프로퍼티가 존재하면 = 해당 capability를 사용 가능**(값이 비어 있어도 그렇다). 프로퍼티 전수:

```
approval(32) · associatedActions(31) · banner(31) · bookmarks(31) ·
bundle(31; Generic 또는 Tracked Change) · callCollaboration(51) · canvas(32) ·
caseComment(32) · chatterLikes(31) · close(43) · comments(31) ·
content(32–35, v36+ files) · dashboardComponent(32) · directMessage(39) ·
edit(34) · emailMessage(32) · enhancedLink(32) · extensions(40) ·
feedEntityShare(39) · files(36) · interactions(37) · link(32) ·
mediaReferences(41) · moderation(31) · mute(35) · origin(33) · pin(41) ·
poll(31) · questionAndAnswers(31) · readBy(40) · recommendations(32) ·
recordSnapshot(32) · socialPost(36) · status(37) · topics(31) ·
trackedChanges(32) · upDownVote(41)
```

**Feed** (feed-type URL GET 응답 — [[Feeds Resources]]에서 주로 사용)
`feedElementPostUrl`(31.0) · `feedElements`(Feed Element Page 40.0) · `feedElementsUrl`(31.0) · `feedItemsUrl`(23–31.0) · `isModifiedUrl`(23.0 news) · `pinnedFeedElementsUrl`(41.0) · `respectsMute`(35.0) … (전체 Reference 위임)

이름만 존재하고 스키마는 Reference 챕터 위임: Batch Results, Like / Like Page, Comment / Comment Page, Topic / Topics Capability, Generic Feed Element, Pinned Feed Element Collection, Vote Collection, Read By Collection, Direct Message Member Collection, Feed Entity Is Editable.

---

## 관련 노트
- [[Feeds Resources]] — feed type별 피드(이 리소스가 반환되는 피드)
- [[Comments · Likes · Mentions Resources]] — 개별 댓글·좋아요·멘션 레벨 리소스(comment 편집·스레드·verify·vote, like GET/DELETE, mention completions/validations)
- [[Files & Folders Resources]] — files capability로 피드에 첨부할 파일의 업로드·관리 리소스
- [[Connect REST API 요청·응답 규약]] — base URI · 필터 · 상태코드
- [[Connect REST API 개요]] — 상위 개요
- [[ConnectApi Chatter 패턴]] — Apex 측 피드 작업 짝
