---
tags: [integration, connect-rest-api, users, conversations, following]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p998–1032 Users Resources; Tier 1/2)
created: 2026-07-03
aliases: [Users, 사용자, User Information, User Profile, Conversations, 비공개 대화, Messages, 비공개 메시지, Following, 팔로우, User Settings, User Followers]
---

# Users Resources - 프로필·대화·메시지·팔로우

> Connect REST API의 Users 리소스 전반부 — 사용자 정보 조회, 프로필 편집, 비공개 대화·메시지, 팔로우/팔로워, 그룹·토픽·설정을 다룬다.

---

Users 리소스로 org 내 사용자 정보(팔로워·추천 등)를 조회하고, 피드 아이템을 게시하며, 대화 상태를 업데이트한다.

공통 규약:
- 모든 리소스는 Experience Cloud 변형 `/connect/communities/{communityId}/...`이 병존한다(명시된 예외 제외).
- 특별히 명시하지 않으면 **Requires Chatter: Yes**.
- `userId`에는 실제 사용자 ID 또는 alias `me`를 쓸 수 있다. 일부 리소스(대화·메시지·설정)는 **`userId=me`만 허용**한다.
- 응답 바디는 이름만 표기한다. 전체 응답 스키마는 [[Connect REST API 요청·응답 규약]] 및 Reference 챕터 소관이다(본 노트에서 재서술하지 않음).

> ⚠️ **비공개 메시지(private message) ≠ 다이렉트 메시지(direct message).** 비공개 메시지는 이 노트의 Messages 리소스로 다루고, 다이렉트 메시지는 최신 방식으로 **Feed Elements의 Post**를 사용한다 → [[Feed Elements Resources]] 참조.

---

## 리소스 요약표

| # | 리소스 | URI | 메서드 | 최초 버전 |
|---|---|---|---|---|
| 4-1 | User Information | `/chatter/users` | GET/HEAD | v23.0 |
| 4-2 | User Profile Information | `/chatter/users/{userId}` | GET/HEAD/PATCH | v23.0 (PATCH v29.0) |
| 4-3 | Batch User Information | `/chatter/users/batch/{user_list}` | GET/HEAD | v23.0 |
| 4-4 | User Activity Export | `/chatter/users/{userId}/activities/export-job` | POST | v42.0 |
| 4-5 | User Activity Purge | `/chatter/users/{userId}/activities/purge-job` | POST | v42.0 |
| 4-6 | User Conversations General | `/chatter/users/{userId}/conversations` | GET/HEAD | v23.0 |
| 4-7 | User Conversations Specific | `/chatter/users/{userId}/conversations/{conversationId}` | GET/PATCH/HEAD | v23.0 |
| 4-8 | Unread Count | `/chatter/users/{userId}/conversations/unread-count` | GET/HEAD | v23.0 |
| 4-9 | User Followers | `/chatter/users/{userId}/followers` | GET/HEAD | v23.0 |
| 4-10 | Following | `/chatter/users/{userId}/following` | GET/POST/HEAD | v23.0 (토픽 v29.0) |
| 4-11 | User Groups | `/chatter/users/{userId}/groups` | GET/HEAD | v23.0 |
| 4-12 | Knowledgeable Topics | `/chatter/users/{userId}/knowledgeable-about-topics` | GET/HEAD | v30.0 |
| 4-13 | Knowledgeable Topics Batch | `/chatter/users/batch/{userIds}/knowledgeable-about-topics` | GET/HEAD | v36.0 |
| 4-14 | User Messages General | `/chatter/users/{userId}/messages` | GET/HEAD/POST | v23.0 |
| 4-15 | User Messages Specific | `/chatter/users/{userId}/messages/{messageId}` | GET/HEAD | v23.0 |
| 4-23 | User Settings | `/chatter/users/{userId}/settings` | GET/HEAD/PATCH | v27.0 |
| 4-24 | Topics Recently Used | `/chatter/users/{userId}/topics` | GET/HEAD | v28.0 |

> Recommendations(4-16~4-21)와 Reputation(4-22)은 [[Users Resources - Recommendations·Reputation]] 소관이다.

---

## 사용자 정보 조회

### 4-1. User Information — `/chatter/users`

org 내 모든 사용자 목록. v23.0, GET/HEAD.

| Param | Type | 설명 |
|---|---|---|
| page | Integer | 페이지 번호(기본 0) |
| pageSize | Integer | 페이지당 항목 수(**1–250**, 기본 25) |
| q | String | 검색어 — **사용자 이름만** 검색(이메일·직함 제외) |
| searchContextId | String | @mention 자동완성용 feed item ID(v28.0). 사용 시 **500건 초과 쿼리 불가·와일드카드 불가** |

응답: `User Page`. (v28.0부터 목록의 각 user는 항상 User Detail이며, 볼 수 없는 필드는 null.)

### 4-2. User Profile Information — `/chatter/users/{userId}`

특정 사용자 정보 조회 및 About Me 편집. v23.0(PATCH는 v29.0), GET/HEAD/PATCH.

- **GET 응답:** `User Detail`(v26.0+; external user는 User Summary와 공유되는 필드만 non-null) / `User Summary`(v25.0 이하).
- **PATCH 바디** (root `<user>`):

| 프로퍼티 | Type | 설명 |
|---|---|---|
| aboutMe | String | 프로필 "About Me" 섹션 텍스트. **최대 1000자**(v29.0) |

PATCH 응답: `User Detail`. 파라미터 형식으로도 `aboutMe` 전달 가능.

```json
// PDF 발췌 — PATCH 요청 바디 예
{ "aboutMe": "Staff Technical Writer..." }
```

```
// URI 파라미터 형식 예
PATCH /chatter/users/{userId}?aboutMe=Staff+Technical+Writer
GET   /chatter/users/{userId}?include=/chatterActivity   // 활동 통계 포함
```

### 4-3. Batch User Information — `/chatter/users/batch/{user_list}`

여러 사용자 정보 일괄 조회. v23.0, GET/HEAD.

- `user_list`: 콤마로 구분한 사용자 ID, **최대 500개**.
- 응답: `Batch Results`.

---

## 사용자 활동 익스포트·퍼지

### 4-4. User Activity Export — `/chatter/users/{userId}/activities/export-job`

Chatter 활동(북마크·토픽 추천·투표 등)을 export하는 작업 생성. v42.0, POST.

- POST에 파라미터·바디 **없음**.
- 응답: `User Activities Job`.

### 4-5. User Activity Purge — `/chatter/users/{userId}/activities/purge-job`

Chatter 활동을 purge하는 작업 생성. v42.0, POST. POST에 파라미터·바디 **없음**. 응답: `User Activities Job`.

Purge 가능한 활동 종류(10종):

| 활동 | 설명 |
|---|---|
| Bookmark | 북마크 |
| ChatterActivity | 게시/댓글 수 + 받은 좋아요·댓글 총계 |
| ChatterLike | 좋아요 |
| CompanyVerify | 댓글 검증 |
| DownVote | 반대 투표 |
| FeedEntityRead | 피드 엔티티 읽음 |
| FeedRead | 피드 읽음 |
| Mute | 음소거 |
| TopicEndorsement | 토픽 추천 |
| UpVote | 찬성 투표 |

> 게시물·댓글 자체 삭제는 이 리소스가 아니라 Feed Element·Comment 리소스로 처리한다.

---

## 비공개 대화 (Conversations)

### 4-6. User Conversations General — `/chatter/users/{userId}/conversations`

비공개 대화 조회·검색. v23.0, GET/HEAD. **`userId=me`만 허용.**

> ⚠️ 비공개 메시지(private)는 다이렉트 메시지(direct)와 다르다. 다이렉트 메시지는 최신 방식으로 Feed Elements의 Post를 사용한다.

| Param | Type | 설명 |
|---|---|---|
| page | String | 페이지 토큰(응답 NextPageUrl에서 얻음) |
| pageSize | Integer | **1–100**, 기본 25 |
| q | String | 검색어(**2자 이상**, 메시지 본문만 검색, v24.0) |

응답: `Conversation Summary Collection`.

### 4-7. User Conversations Specific — `/chatter/users/{userId}/conversations/{conversationId}`

특정 대화 조회 및 읽음 상태 변경. v23.0, GET/PATCH/HEAD. **`userId=me`만 허용.**

- **GET param:** `q`(2자 이상, 본문만 검색).
- **PATCH 바디** (root `<conversation>`):

| 프로퍼티 | Type | 설명 |
|---|---|---|
| read | Boolean | 읽음 상태 — unread=`false`, read=`true`(v24.0) |

PATCH는 파라미터 형식으로 `read`도 가능. GET/HEAD 응답: `Conversation Detail`.

### 4-8. Unread Count — `/chatter/users/{userId}/conversations/unread-count`

안 읽은 비공개 대화 수. v23.0, GET/HEAD. (원문에 Requires Chatter 명시 없음.) 응답: `Conversation Unread Count`.

---

## 팔로워·팔로잉

### 4-9. User Followers — `/chatter/users/{userId}/followers`

특정 사용자를 팔로우하는 사람들. v23.0, GET/HEAD.

| Param | Type | 설명 |
|---|---|---|
| page | Integer | 기본 0 |
| pageSize | Integer | **1–1000**, 기본 25 |

응답: `Follower Page`.

### 4-10. Following — `/chatter/users/{userId}/following`

사용자가 팔로우하는 사람·그룹·레코드·토픽·파일. 레코드 팔로우에도 사용한다. v23.0(토픽 팔로잉은 v29.0), GET/POST/HEAD. (그룹 멤버 추가는 groups 리소스로 처리.)

**GET 파라미터** (모두 Optional):

| Param | Type | 설명 |
|---|---|---|
| filterType | String | key prefix로 필터(예: User=`005`, Group=`0F9`) |
| page | Integer | 기본 0 |
| pageSize | Integer | **1–1000**, 기본 25 |

GET 응답: `Following Page`.

**POST 바디** (root `<following>`):

| 프로퍼티 | Type | 설명 |
|---|---|---|
| subjectId | String | 팔로우할 대상 ID(user·file·record 등; Topic ID는 v29.0; v23.0) |

POST는 파라미터 형식으로 `subjectId`도 가능. POST 응답: `Subscription`.

```
// 요청 예
GET  /chatter/users/{userId}/following?page=1
POST /chatter/users/{userId}/following   body: { "subjectId": "001D000000Iyu2p" }
POST /chatter/users/{userId}/following?subjectId=001D000000Iyu2p
```

---

## 그룹·토픽

### 4-11. User Groups — `/chatter/users/{userId}/groups`

사용자가 멤버인 그룹. v23.0, GET/HEAD.

| Param | Type | 설명 |
|---|---|---|
| page | String | 페이지 토큰(Optional) |
| pageSize | Integer | **1–250**, 기본 25 |
| q | String | 검색어(2자 이상, v30.0) |

응답: v45.0+ → `User Group Detail Collection` / v44.0 이하 → `User Group Page`. 예: `?q=co`

### 4-12. Knowledgeable Topics — `/chatter/users/{userId}/knowledgeable-about-topics`

사용자가 정통한 토픽. v30.0, GET/HEAD.

| Param | Type | 설명 |
|---|---|---|
| page | Integer | 기본 0 |
| pageSize | Integer | **1–100**, 기본 25 |

응답: `Topics People Are Knowledgeable About Collection`.

### 4-13. Knowledgeable Topics Batch — `/chatter/users/batch/{userIds}/knowledgeable-about-topics`

여러 사용자가 정통한 토픽 일괄 조회. v36.0, GET/HEAD.

- `userIds`: **최대 500개**. 각 사용자의 **상위 5개** 토픽 반환.
- 응답: `Batch Results`.

### 4-24. Topics Recently Used — `/chatter/users/{userId}/topics`

사용자가 최근 사용한 토픽 **최대 5개**. v28.0, GET/HEAD. 응답: `Topic Collection`.

---

## 비공개 메시지 (Messages)

### 4-14. User Messages General — `/chatter/users/{userId}/messages`

비공개 메시지 조회·검색·게시. v23.0, GET/HEAD/POST. **`userId=me`만 허용.**

**GET 파라미터:**

| Param | Type | 설명 |
|---|---|---|
| page | String | 페이지 토큰 |
| pageSize | Integer | **1–100**, 기본 25 |
| q | String | 검색어(2자 이상, 본문만, v24.0) |

GET 응답: `Message Collection`.

**POST 바디** (root `<message>`):

| 프로퍼티 | Type | 설명 |
|---|---|---|
| body | String | 메시지 텍스트 |
| inReplyTo | String | 기존 메시지 ID로 대화 식별. **`recipients`와 택1** |
| recipients | User Recipient List Input | 수신자(user ID 콤마, **최대 9명**). **`inReplyTo`와 택1** |

**POST 파라미터:** `inReplyTo` · `recipients`(택1) · `text`(String, **필수**, **최대 10,000자**). POST 응답: `Message`.

> `inReplyTo`(기존 대화에 답신)와 `recipients`(새 수신자 지정)는 **둘 중 하나만** 쓴다.

```json
// PDF 발췌 — POST 메시지 바디 예
{ "body": "Text of the message", "recipients": ["userID", "userID"], "inReplyTo": "messageID" }
```

### 4-15. User Messages Specific — `/chatter/users/{userId}/messages/{messageId}`

특정 비공개 메시지 조회. v23.0, GET/HEAD. **`userId=me`만 허용.** 응답: `Message`.

---

## 사용자 설정

### 4-23. User Settings — `/chatter/users/{userId}/settings`

사용자의 글로벌 Chatter 설정. v27.0, GET/HEAD/PATCH. **`userId=me`만 허용.**

**PATCH 바디** (root `<userChatterSettings>`):

| 프로퍼티 | Type | 설명 |
|---|---|---|
| defaultGroupEmailFrequency | String | 그룹 가입 시 기본 이메일 빈도. enum: **EachPost / DailyDigest / WeeklyDigest / Never**(v27.0) |

- 커뮤니티에서 `EachPost`를 선택한 멤버가 **10,000명을 초과**하면 해당 옵션이 비활성화되고 `DailyDigest`로 전환된다. 이미 멤버인 그룹에는 영향 없음.
- 파라미터 형식으로도 동일하게 전달. 응답: `User Chatter Settings`.

```json
// PDF 발췌 — GET 응답 예
{ "defaultGroupEmailFrequency": "Never" }
```

---

## 응답 바디 (Reference 위임)

아래 응답 바디·Input의 전체 스키마는 Request/Response Bodies Reference 챕터 소관이다. 여기서는 이름만 표기한다.

- 응답 바디: `User Page` · `User Detail` · `User Summary` · `Batch Results` · `User Activities Job` · `Conversation Summary Collection` · `Conversation Detail` · `Conversation Unread Count` · `Follower Page` · `Following Page` · `Subscription` · `User Group Detail Collection` · `User Group Page` · `Topics People Are Knowledgeable About Collection` · `Message Collection` · `Message` · `User Chatter Settings` · `Topic Collection`
- Input: `User Recipient List Input`

---

## 관련 노트
- [[Users Resources - Recommendations·Reputation]] — 같은 Users 챕터의 추천·평판 리소스(4-16~4-22)
- [[User Profiles · Subscriptions · Followers on Records Resources]] — 프로필 상세·구독·레코드 팔로워 리소스
- [[Feed Elements Resources]] — 다이렉트 메시지·피드 게시(Post)
- [[Connect REST API 요청·응답 규약]] — base URI·페이지네이션·응답 스키마 규약
- [[Connect REST API 개요]] — 상위 개요
