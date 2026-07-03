---
tags: [integration, connect-rest-api, comments, likes, mentions]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p768–970 Comments/Likes/Mentions Resources; Tier 1/2)
created: 2026-07-03
aliases: [Comments, 댓글, Likes, 좋아요, Mentions, 멘션, Mention Completions, Mention Validations, Threaded Comments, Verified Comment]
---

# Comments · Likes · Mentions Resources

> Connect REST API에서 개별 댓글의 조회·편집·스레드·status·업다운보트·검증·좋아요를 다루는 Comments 리소스, 개별 좋아요를 조회·삭제하는 Likes 리소스, 그리고 멘션 후보를 제안·검증하는 Mentions 리소스.

---

세 리소스 그룹 모두 **Requires Chatter: Yes**이며, 각 리소스는 Experience Cloud 변형 `/connect/communities/{communityId}/chatter/...` 형태가 병존한다. 아래 URI는 표준 `/chatter/...` 형태로 표기한다.

응답 바디는 이름만 표기하며 전체 스키마는 [[Connect REST API 요청·응답 규약]]과 별도의 Response Bodies Reference 챕터에 위임한다(여기서 재서술하지 않는다). 요청 Input 프로퍼티는 전수 기재한다.

> base URI·페이지네이션·상태코드 규약은 [[Connect REST API 요청·응답 규약]] 참조.

---

## Comments

> 댓글 하나에 대한 정보 조회·편집·좋아요·업보트·검증·삭제, 그리고 context user가 편집 가능한지 여부 판정.

### 엔드포인트 (11)

| # | 이름 | URI | 메서드 | v | 설명 |
|---|---|---|---|---|---|
| 1 | Comment | `/chatter/comments/{commentId}` | GET, DELETE, PATCH | 23.0 | 조회·수정·삭제 (PATCH=body 편집 v34.0+, capability 업데이트 불가) |
| 2 | Batch Get | `/chatter/comments/batch/{commentIds}` | GET | 42.0 | 최대 100개 일괄 조회 (로드 실패는 에러 반환) |
| 3 | Cap: Threaded Comments | `/chatter/comments/{commentId}/capabilities/comments` | GET | 44.0 | 댓글의 comments capability |
| 4 | Cap: Threaded Comments Items | `/chatter/comments/{commentId}/capabilities/comments/items` | GET | 44.0 | 스레드형 댓글 조회 |
| 5 | Cap: Editability | `/chatter/comments/{commentId}/capabilities/edit/is-editable-by-me` | GET | 34.0 | 편집 가능 여부 |
| 6 | Cap: Status | `/chatter/comments/{commentId}/capabilities/status` | GET, PATCH | 38.0 | 댓글 status 조회·설정 |
| 7 | Cap: Upvote/Downvote | `/chatter/comments/{commentId}/capabilities/up-down-vote` | GET, PATCH | 41.0 | 업/다운보트 |
| 8 | Cap: Upvote/Downvote Items | `/chatter/comments/{commentId}/capabilities/up-down-vote/items` | GET | 42.0 | 투표한 사용자 목록 |
| 9 | Cap: Verified | `/chatter/comments/{commentId}/capabilities/verified` | GET, PATCH | 41.0 | verified 상태 (질문 포스트 댓글만, 질문당 1개만 verified) |
| 10 | Comment Likes | `/chatter/comments/{commentId}/likes` | GET, PATCH, POST | 23.0 | 댓글 좋아요 (PATCH v39.0+) |
| 11 | Threaded Comment | `/chatter/comments/{commentId}/thread-context` | GET | 44.0 | 부모 댓글·포스트 맥락 스레드 조회 |

### Comment — 조회·편집·삭제

새 댓글 게시는 이 리소스가 아니라 Feed Elements의 Capability Comments Items를 사용한다(→ [[Feed Elements Resources]]). PATCH의 root XML 태그는 `<comment>`이며, 응답은 GET/PATCH → `Comment`, DELETE → `204`.

```json
// 공식 예제 (PATCH 요청 바디) — 댓글 body 편집
{ "body": { "messageSegments": [ { "type": "Text", "text": "I am definitely going to check that out." } ] } }
```

PATCH body 프로퍼티:

| 프로퍼티 | 타입 | 필수/버전 | 설명 |
|---|---|---|---|
| `attachment` | Attachment Input | Opt 24–31.0 / Req 23.0 | v32.0부터 `capabilities` 사용 권장. Attachment Input: Existing Content 또는 New File Upload |
| `body` | Message Body Input | — | comment body 10,000자. 편집 v34.0+, rich text·inline image v35.0+ (사전 업로드된 069 content), entity link v43.0+ |
| `capabilities` | Comment Capabilities Input | Opt v32.0 | body는 편집 가능하나 **capability는 업데이트 불가** |
| `threadParentId` | String | Opt | 스레드 부모 댓글 ID |

### Batch Get

GET → `Batch Results`. 최대 100개. 로드에 실패한 개별 항목은 에러로 반환된다.

### Cap: Threaded Comments (GET)

| Param | 타입 | 필수/버전 | 기본 | 설명 |
|---|---|---|---|---|
| `threadedCommentsCollapsed` | Boolean | Opt v44.0 | false | 스레드 댓글 접힘 여부 |

응답 `Comments Capability`. 미지원 시 404.

### Cap: Threaded Comments Items (GET)

| Param | 타입 | 필수/버전 | 기본 | 설명 |
|---|---|---|---|---|
| `page` | String | Opt v43.0 | — | 페이지 |
| `pageSize` | Integer | Opt v43.0 | 25 | 1–100 |

응답 `Comment Page`. 미지원 시 404.

### Cap: Editability (GET)

응답 `Feed Entity Is Editable`. 미지원 시 404.

### Cap: Status (GET, PATCH)

PATCH root 태그 `statusCapability`. 응답 `Status Capability`(미지원 404).

```json
// 공식 예제 (PATCH 요청 바디) — 댓글 status 설정
{ "feedEntityStatus": "Published" }
```

PATCH body/param `feedEntityStatus`(String, Req; body v37.0 / param v38.0).

**feedEntityStatus enum (4종):**

| 값 | 의미 |
|---|---|
| `Draft` | 미게시. author + Modify All Data / View All Data 권한자에게만 표시. **Comments can't be drafts.** |
| `Isolated` | 격리. admin에게만 표시 |
| `PendingReview` | 미승인. 미게시·비표시 |
| `Published` | 승인·표시 |

전환 제약:
- `PendingReview`/`Published` ↔ `Draft` 상호 변경 불가.
- `Isolated`로/에서 변경은 admin만 가능.

### Cap: Upvote/Downvote (GET, PATCH)

PATCH root 태그 `<upDownVoteCapability>`. 응답 `Up Down Vote Capability`(미지원 404).

```json
// 공식 예제 (PATCH 요청 바디) — 업/다운보트
{ "vote": "Up" }
```

PATCH body/param `vote`(String, Req v41.0).

**vote enum:** `Down` / `None` / `Up`.

### Cap: Upvote/Downvote Items (GET)

투표한 사용자 목록.

| Param | 타입 | 필수/버전 | 기본 | 설명 |
|---|---|---|---|---|
| `page` | Integer | Opt v42.0 | — | 0부터 |
| `pageSize` | Integer | Opt v42.0 | 25 | 1–100 |
| `vote` | String | **Req** v42.0 | — | `Down` / `Up` — **`None` 불가** |

응답 `Vote Collection`(미지원 404).

> Items 엔드포인트의 `vote`는 위 Upvote/Downvote의 3값 enum과 달리 `None`을 허용하지 않는다(`Down`/`Up`만).

### Cap: Verified (GET, PATCH)

제약: `commentId`는 **질문 포스트의 댓글 ID**여야 하며, 질문당 1개 댓글만 verified가 될 수 있다. PATCH root 태그 `<verifiedCapability>`. 응답 `Verified Capability`(미지원 404).

```json
// 공식 예제 (PATCH 요청 바디) — 댓글 verify
{ "isVerified": "true" }
```

PATCH body/param:

| 프로퍼티 | 타입 | 필수/버전 | 설명 |
|---|---|---|---|
| `isVerified` | Boolean | Req v41.0 | verified→unverified, unverified→verified 전환만 가능 |
| `isVerifiedByAnonymized` | Boolean | Opt v43.0 | verify 후 활동 삭제 요청 시 verification은 유지하고 lastVerifiedByUser를 익명화. `isVerified`와 동시 true 불가. `isVerified`가 이미 true일 때만 true로 설정 가능. false로는 설정 불가 — 되돌리려면 다른 사용자가 unverify 후 re-verify |

### Comment Likes (GET, PATCH, POST)

응답 GET/PATCH → `Like Page`, POST → `Like`.

- **GET** params `page`(Integer), `pageSize`(Integer, 1–100 기본 25). ⚠️ 원문에서 `page`·`pageSize`의 Required/Version 열이 공란이므로 여기서도 추측해 채우지 않는다.
- **PATCH** param `isLikedByCurrentUser`(Boolean, Req v39.0; true=좋아요 / false=취소).
- **POST** 파라미터·바디 없음.

### Threaded Comment (GET)

부모 댓글·포스트 맥락 스레드 조회.

| Param | 타입 | 필수/버전 | 기본 | 설명 |
|---|---|---|---|---|
| `pageSize` | Integer | Opt v44.0 | 25 | 1–100 |

응답 `Feed Item`. 미지원 시 404.

---

## Likes

> 지정한 좋아요(like)에 대한 정보 조회 및 삭제.

### 엔드포인트 (1)

| 이름 | URI | 메서드 | v | 설명 |
|---|---|---|---|---|
| Like | `/chatter/likes/{likeId}` | GET, DELETE, HEAD | 23.0 | 지정 like 조회·삭제 |

- 특정 like의 ID는 news feed·record feed 등 임의의 피드에서 얻을 수 있다.
- 응답 GET/HEAD → `Like`. DELETE = like 삭제(응답 별도 명시 없음).

---

## Mentions

> feed item body 또는 comment body에서 사용자가 멘션할 수 있는 사용자·그룹 정보. 멘션되면 해당 대상은 알림을 받는다. Completions로 제안 목록을 얻고, Validations로 context user에게 유효한지 판정한다.

### 엔드포인트 (2)

| 이름 | URI | 메서드 | v | 설명 |
|---|---|---|---|---|
| Mentions Completions | `/chatter/mentions/completions` | GET, HEAD | 29.0 | 멘션 제안 목록 생성 |
| Mentions Validations | `/chatter/mentions/validations` | GET, HEAD | 29.0 | 지정 멘션의 context user 유효성 판정 |

### Mentions Completions (GET, HEAD)

`@` + user/group 이름에 대한 멘션 제안 목록을 생성한다. 응답 `Mention Completion Page`.

| Param | 타입 | 필수 | v | 설명 |
|---|---|---|---|---|
| `contextId` | String | Opt | 29.0 | feed item ID(comment mention) 또는 feed subject ID(feed item mention). customer 허용 그룹은 group ID 사용 |
| `page` | Integer | Opt | 29.0 | 0부터. **결과 500개 초과 페이징 시 빈 응답** |
| `pageSize` | Integer | Opt | 29.0 | 1–100 기본 25. 500 초과 조회 시 빈 응답 |
| `q` | String | **Req** | 29.0 | user/group 이름 검색어. 그룹 최소 2자, 사용자는 최소 없음. **와일드카드 미지원** |
| `type` | String | Opt | 29.0 | `All` / `Group` / `User`. 기본 `All` |

**type enum:** `All`(모든 타입) / `Group`(그룹) / `User`(사용자).

```
GET /chatter/mentions/completions?contextId=0D5D0000000Hwky&q=g
```

### Mentions Validations (GET, HEAD)

지정한 멘션이 context user에게 유효한지 판정한다. 예를 들어 소속하지 않은 private 그룹은 멘션할 수 없으며, 이 경우 `Mention Validation`의 `hasErrors`=true, 해당 그룹의 `validationStatus`=`Disallowed`가 된다. 응답 `Mention Validation`(단수).

| Param | 타입 | 필수 | v | 설명 |
|---|---|---|---|---|
| `parentId` | String | **Req** | 29.0 | feed item parent ID |
| `recordIds` | String[] | **Req** | 29.0 | 멘션할 ID 콤마 목록. **최대 25** |
| `visibility` | String | **Req** | 29.0 | `AllUsers` / `InternalUsers` |

**visibility enum:** `AllUsers`(내부로 국한 안 됨) / `InternalUsers`(내부 제한).

**Usage:** 먼저 Completions로 제안 목록을 얻고, 이어서 Validations로 유효성을 판정한다.

---

## 관련 노트
- [[Feed Elements Resources]] — feed element 레벨의 comments·likes·votes capability (새 댓글 게시 포함)
- [[Connect REST API 요청·응답 규약]] — base URI·페이지네이션·상태코드·응답 바디 스키마
- [[Connect REST API 개요]] — Connect REST API 상위 개요
