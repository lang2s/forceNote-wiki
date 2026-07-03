---
tags: [integration, connect-rest-api, groups, group-membership, group-photo]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p938–965 Groups Resources; Tier 1/2)
created: 2026-07-03
aliases: [Groups, 그룹, Chatter Group, Group Members, 그룹 멤버, Group Photo, Group Announcements, Group Membership Request, 그룹 초대]
---

# Connect REST API — Groups Resources

> Chatter 그룹의 정보·멤버·사진·공지·초대를 다루는 Connect REST API 리소스 17종 — 그룹 생성/삭제, 멤버 추가, 사진 변경, 비공개 그룹 가입 요청 처리까지.

---

원문 개요: *"Information about groups, such as the group's members, photo, and the groups in the organization. Create and delete a group, add members to a group, and change the group photo."*

- 모든 리소스는 **Requires Chatter: Yes**. Group Invites 하나를 제외하고 전부 Experience Cloud 변형 `/connect/communities/{communityId}/chatter/...` 이 병존한다.
- URI의 `{groupId}`는 PDF가 `groupId`/`groupID`를 혼용하나 API는 대소문자 무관 — 이 노트는 **소문자 `groupId`로 정규화**한다.
- ⚠️ **groups 리소스는 피드가 아니다.** 그룹의 피드를 조회·게시하려면 record feed 리소스에 groupId를 넘긴다 → [[Feeds Resources]] 참조.
- 응답 바디의 전체 스키마는 이 노트가 아니라 **Response Bodies Reference 챕터 소관**이다(위임). 여기서는 응답 바디 *이름*만 표기하고 필드를 재서술하지 않는다.

---

## 리소스 지도 (17종 전수)

| # | 이름 | URI | 메서드 | v | 응답 |
|---|---|---|---|---|---|
| 1 | List of Groups | `/chatter/groups/` | GET, HEAD, POST(POST v29.0) | 23.0 | GET→Group Page, POST→Group Detail |
| 2 | Group Information | `/chatter/groups/{groupId}` | GET, DELETE, HEAD, PATCH(PATCH v28.0·DELETE v29.0) | 23.0 | GET/PATCH→Group Detail |
| 3 | Batch Group Information | `/chatter/groups/batch/{group_list}` | GET, HEAD | 23.0 | Batch Results (최대 500 group ID) |
| 4 | Group Announcements | `/chatter/groups/{groupId}/announcements` | GET, POST, HEAD | 31.0 | GET→Announcement Page, POST→Announcement |
| 5 | Group Banner Photo | `/chatter/groups/{groupId}/banner-photo` | GET, HEAD, DELETE, POST | 36.0 | GET/POST→Banner Photo, DELETE→204 |
| 6 | Group Files | `/chatter/groups/{groupId}/files` | GET, HEAD | 24.0 | File Summary Page |
| 7 | Group Members | `/chatter/groups/{groupId}/members` | GET, POST | 23.0 | GET→Group Member Page, POST→Group Member |
| 8 | Group Members—Private | `/chatter/groups/{groupId}/members/requests` | GET, HEAD, POST | 27.0 | GET→Group Membership Request Collection, POST→Group Membership Request |
| 9 | Group Membership Requests—Private | `/chatter/group-membership-requests/{requestId}` | GET, HEAD, PATCH | 27.0 | Group Membership Request |
| 10 | Group Memberships Information | `/chatter/group-memberships/{membershipId}` | GET, DELETE, HEAD, PATCH(PATCH v29.0) | 23.0 | GET/PATCH→Group Member |
| 11 | Batch Group Memberships | `/chatter/group-memberships/batch/{membershipIds}` | GET, HEAD | 27.0 | Batch Results (최대 500, 그룹 무관) |
| 12 | Group Photo | `/chatter/groups/{groupId}/photo` | GET, POST, DELETE, HEAD | 23.0 | Photo |
| 13 | Group Records | `/chatter/groups/{groupId}/records` | GET, HEAD, POST(POST v34.0) | 33.0 | GET→Group Record Page, POST→Group Record |
| 14 | Group Record | `/chatter/group-records/{groupRecordId}` | GET, DELETE, HEAD | 34.0 | GET→Group Record, DELETE→204 |
| 15 | Group Settings | `/chatter/groups/{groupId}/my-settings` | GET, HEAD, PATCH | 27.0 | Group Chatter Settings |
| 16 | Group Topics | `/chatter/groups/{groupId}/topics` | GET, HEAD | 28.0 | Topic Collection (최근 사용 최대 5 topic) |
| 17 | Group Invites | `/chatter/groups/group/{groupId}/invite` | POST | 39.0 | Invite Collection |

---

## 리소스 상세

### 1. List of Groups — `/chatter/groups/` (GET, HEAD, POST)

조직의 그룹 목록을 조회하거나(GET), 새 그룹을 생성(POST v29.0)한다.

**GET 파라미터**

| 파라미터 | 타입/값 | 기본 | v |
|---|---|---|---|
| `archiveStatus` | All / Archived / NotArchived | NotArchived | 29.0 |
| `page` | Integer | 0 | 23.0 |
| `pageSize` | Integer **1–250** | 25 | 23.0 |
| `q` | String (검색어) | — | 23.0 |

**POST 바디** — Group Input(root `<group>`) / **POST 파라미터**

| 프로퍼티 | 필수 | 설명 |
|---|---|---|
| `canHaveChatterGuests` | Opt | Boolean. true로 설정 후 false로 되돌릴 수 없음 |
| `description` | Opt | 그룹 설명 |
| `informationText` | Opt | 그룹 정보 본문 |
| `informationTitle` | Opt | 그룹 정보 제목 |
| `name` | **Req** | 그룹 이름 |
| `visibility` | **Req** | PrivateAccess / PublicAccess / Unlisted |

```json
// 그룹 생성 (POST body — Group Input)
{
  "name": "Chatter API",
  "visibility": "PublicAccess"
}
```
파라미터 방식: `POST /chatter/groups/?name=Chatter+API&visibility=PublicAccess`

### 2. Group Information — `/chatter/groups/{groupId}` (GET, DELETE, HEAD, PATCH)

단일 그룹 조회(GET)·수정(PATCH v28.0)·삭제(DELETE v29.0). 응답 GET/PATCH→Group Detail.

**PATCH 바디**: Group Input(root `<group>`)에 Group Information Input 중첩. **PATCH 파라미터:**

| 프로퍼티 | 설명 | v |
|---|---|---|
| `announcement` | feed item ID | 31.0 |
| `canHaveChatterGuests` | Boolean | — |
| `description` | 그룹 설명 | — |
| `informationText` | private 그룹이면 멤버만 조회 | 28.0 |
| `informationTitle` | 그룹 정보 제목 | 28.0 |
| `isArchived` | 아카이브 여부 | — |
| `isAutoArchiveDisabled` | 자동 아카이브 비활성 | — |
| `isBroadcast` | owner/manager만 게시 가능한 브로드캐스트 그룹 | 36.0 |
| `name` | 그룹 이름 | — |
| `owner` | **PATCH 전용** — 그룹 소유자 변경 | 29.0 |
| `visibility` | PrivateAccess / PublicAccess / Unlisted | — |

```json
// 그룹 정보 수정 (PATCH body)
{
  "information": {
    "text": "This is a private R&D group.",
    "title": "API Questions Group"
  }
}
```

### 3. Batch Group Information — `/chatter/groups/batch/{group_list}` (GET, HEAD)

`group_list`는 콤마로 구분한 **최대 500개** group ID. 응답 Batch Results.

### 4. Group Announcements — `/chatter/groups/{groupId}/announcements` (GET, POST, HEAD)

공지로 그룹 정보를 강조한다. 사용자는 공지에 대해 토론·좋아요·댓글할 수 있다. 해당 feed post를 삭제하면 공지도 삭제된다. 공지의 조회·수정·삭제는 **Announcements Resources**를 사용한다.

**GET 파라미터**: `page`(기본 0) · `pageSize`(**1–100**, 기본 25).

**POST 바디** — Announcement Input(root `<announcement>`):

| 프로퍼티 | 필수/설명 | v |
|---|---|---|
| `body` | Message Body Input. feedItemId 미지정 시 **생성에 Req**; 수정 시 미지정 | — |
| `expirationDate` | ISO 8601. UI는 이 날짜 23:59까지 표시하며 시간값은 무시. 생성 Req / 수정 Opt | — |
| `feedItemId` | AdvancedTextPost feed item ID. body 미지정 시 **생성에 Req** | 36.0 |
| `isArchived` | Boolean, Opt | 36.0 |
| `parentId` | 그룹 ID. feedItemId 미지정 시 **생성에 Req** | 36.0 |
| `sendEmails` | Boolean. 그룹 멤버 email 설정과 무관하게 발송. Chatter email 비활성 org는 미발송. 기본 false. Opt | 36.0 |

**POST 파라미터**: `expirationDate`(v31.0). 응답 GET→Announcement Page, POST→Announcement.

```json
// 공지 생성 (POST body — body 지정 방식)
{
  "body": {
    "messageSegments": [
      { "text": "Please install the updates...", "type": "Text" }
    ]
  },
  "parentId": "0F9B0000000004S",
  "expirationDate": "2016-02-22T00:00:00.000Z"
}
```
기존 feed item을 공지로 지정하는 방식: `{ "feedItemId": "0D5D0000000DaZBKA0", "expirationDate": "..." }`

### 5. Group Banner Photo — `/chatter/groups/{groupId}/banner-photo` (GET, HEAD, DELETE, POST)

owner/manager 또는 Manage All Data 권한자가 POST/DELETE 할 수 있다. `fileId` 프로퍼티/파라미터 또는 multipart 바이너리 업로드로 이미지를 지정한다.

**POST 바디** — root `<bannerPhoto>`:

| 프로퍼티 | 설명 | v |
|---|---|---|
| `cropHeight` | Integer, Opt | 36.0 |
| `cropWidth` | Integer, Opt | 36.0 |
| `cropX` | Integer, Opt | 36.0 |
| `cropY` | Integer, Opt | 36.0 |
| `fileId` | 18자, prefix `069`, 이미지 **2GB 미만**. Group/User 페이지에 업로드된 이미지는 fileId가 없어 사용 불가. 기존 파일 사용 시 Req | — |
| `versionNumber` | Opt | — |

> ⚠️ **PDF 원문 불일치 병기:** POST **바디**의 `fileId`는 "2GB 미만", POST **파라미터**의 `fileId`는 "less than 8 MB"로 적혀 있다. 원문이 서로 다르므로 추측으로 봉합하지 않고 양쪽 값을 그대로 병기한다.

**Note:** 사진은 비동기 처리되어 즉시 표시되지 않을 수 있다. 응답 GET/POST→Banner Photo, DELETE→204.

```json
// 배너 사진 설정 (POST body)
{
  "cropHeight": "120",
  "cropWidth": "240",
  "fileId": "069D00000001IOh"
}
```

### 6. Group Files — `/chatter/groups/{groupId}/files` (GET, HEAD)

파라미터: `page`(기본 0) · `pageSize`(**1–100**, 기본 25) · `q`(2자 이상 검색어, v27.0). 응답 File Summary Page.

### 7. Group Members — `/chatter/groups/{groupId}/members` (GET, POST)

**GET 파라미터**: `page`(기본 0) · `pageSize`(**1–1000**, 기본 25).

**POST 바디** — Group Member Input(root `<member>`):

| 프로퍼티 | 값 | v |
|---|---|---|
| `role` | GroupManager / StandardMember | 29.0 |
| `userId` | 사용자 ID | 23.0 |

POST 파라미터도 동일. 응답 GET→Group Member Page, POST→Group Member.

**Note:** 멤버를 추가하려면 context user가 owner/moderator여야 한다. private 그룹이면 403이 반환되며, 이 경우 가입 요청은 Group Members—Private(`/members/requests`)로 POST한다.

```json
// 멤버 추가 (POST body)
{ "userId": "005D0000001GpHp" }
```
파라미터 방식: `POST /chatter/groups/{groupId}/members?userId=005D0000001GpHp`

### 8. Group Members—Private — `/chatter/groups/{groupId}/members/requests` (GET, HEAD, POST)

private 그룹의 가입 요청을 생성(POST)하거나 목록을 조회(GET)한다.

**GET 파라미터**: `status`(Accepted / Declined / Pending, Opt, v27.0). 응답 GET/HEAD→Group Membership Request Collection, POST→Group Membership Request.

**HTTP 응답 코드 (이 리소스 고유):**

| 코드 | 의미 |
|---|---|
| 201 | 성공 또는 이미 요청이 존재함 |
| 204 | 이미 멤버임 |
| 403 | private 그룹 = `INSUFFICIENT_ACCESS_OR_READONLY` / 외부 사용자 = `INSUFFICIENT_ACCESS` |

### 9. Group Membership Requests—Private — `/chatter/group-membership-requests/{requestId}` (GET, HEAD, PATCH)

`requestId`는 `/members/requests` POST 응답에서 취득한다.

**PATCH 바디** — root `<groupMembershipRequestUpdate>`:

| 프로퍼티 | 설명 | v |
|---|---|---|
| `responseMessage` | 거부 메시지. status=Declined일 때만 유효. **최대 756자** | 27.0 |
| `status` | Accepted / Declined | 27.0 |

PATCH 파라미터도 동일. 응답 GET/PATCH→Group Membership Request.

```json
// 가입 요청 승인 (PATCH body — Pending→Accepted)
{ "status": "Accepted" }
```

### 10. Group Memberships Information — `/chatter/group-memberships/{membershipId}` (GET, DELETE, HEAD, PATCH)

`membershipId`는 `/chatter/groups/{groupId}/memberships`에서 반환된다.

**PATCH 바디** (v29.0) — root `<member>`: `role`(GroupManager/StandardMember, v29.0) · `userId`(v23.0).

**Note:** role만 업데이트하려면 role만 전달하고 `userId`는 넘기지 않는다. PATCH 파라미터는 role만 지원. 응답 GET/PATCH→Group Member.

```json
// 멤버십 수정 (PATCH body)
{
  "role": "GroupManager",
  "userId": "005B0000000Ge16"
}
```

### 11. Batch Group Memberships — `/chatter/group-memberships/batch/{membershipIds}` (GET, HEAD)

`membershipIds`는 콤마로 구분한 **최대 500개**(그룹 무관). membership ID는 Group Member 응답의 `id`이다. 응답 Batch Results(중첩 User Summary; 못 찾으면 statusCode 404).

### 12. Group Photo — `/chatter/groups/{groupId}/photo` (GET, POST, DELETE, HEAD)

`fileId` 또는 multipart로 그룹 사진을 지정한다.

**POST 바디** — root `<photo>`:

| 프로퍼티 | 설명 | v |
|---|---|---|
| `cropSize` | Integer. 업로드/기존 파일 crop에 Req | 29.0 |
| `cropX` | Integer. crop에 Req | 29.0 |
| `cropY` | Integer. crop에 Req | 29.0 |
| `fileId` | 18자, prefix `069`, 이미지 **2GB 미만**. Group/User 페이지 이미지는 사용 불가. 기존 파일 선택 시 Req | 25.0 |
| `versionNumber` | Opt | 25.0 |

POST 파라미터도 동일하며 `fileId`도 **2GB 미만**(배너와 달리 이 리소스는 바디·파라미터 모두 2GB로 일치). **Note:** 비동기 처리. 응답 GET/HEAD/POST→Photo.

```json
// 그룹 사진 설정 (POST body)
{
  "cropSize": "120",
  "cropX": "0",
  "cropY": "0",
  "fileId": "069D00000001IOh"
}
```

### 13. Group Records — `/chatter/groups/{groupId}/records` (GET, HEAD, POST v34.0)

**GET 파라미터**: `page`(기본 0) · `pageSize`(**1–100**, 기본 25). **POST 바디** — root `<groupRecord>`: `recordId`(**Req**, v34.0). POST 파라미터 recordId. 응답 GET→Group Record Page, POST→Group Record.

```json
// 그룹에 레코드 연결 (POST body)
{ "recordId": "001D000000Io9cD" }
```

### 14. Group Record — `/chatter/group-records/{groupRecordId}` (GET, DELETE, HEAD)

응답 GET→Group Record, DELETE→204.

### 15. Group Settings — `/chatter/groups/{groupId}/my-settings` (GET, HEAD, PATCH)

context user의 그룹별 알림 설정을 조회·수정한다.

**PATCH 바디** — root `<groupChatterSettings>`: `emailFrequency`(EachPost / DailyDigest / WeeklyDigest / Never).

> **Note:** Experience Cloud(커뮤니티)에서 한 그룹에 대해 **`EachPost`(모든 게시물마다 이메일)를 선택한 멤버 수가 10,000명을 초과**하면 그 옵션이 비활성화되고, 해당 옵션을 선택했던 멤버는 모두 자동으로 `DailyDigest`로 전환된다. (트리거는 그룹 전체 멤버 수가 아니라 EachPost 선택 멤버 수. v27.0)

PATCH 파라미터도 동일. 응답 Group Chatter Settings.

### 16. Group Topics — `/chatter/groups/{groupId}/topics` (GET, HEAD)

응답 Topic Collection(그룹에서 최근 사용된 최대 5개 topic).

### 17. Group Invites — `/chatter/groups/group/{groupId}/invite` (POST v39.0)

내부·외부 사용자를 그룹에 초대한다. (이 리소스는 Experience Cloud 변형이 명시되지 않음.)

**POST 바디** — Invite Collection Input(root `<inviteCollection>`):

| 프로퍼티 | 필수/설명 | v |
|---|---|---|
| `invitees` | String[]. 초대할 email 목록. **Req** | 39.0 |
| `message` | 초대 메시지. Opt | 39.0 |

응답 Invite Collection.

```json
// 그룹 초대 (POST body)
{
  "invitees": {
    "emails": [
      "a@internaldomain.com",
      "b@externaldomain.com"
    ]
  },
  "message": "Join this group..."
}
```

> ⚠️ **PDF 원문 불일치 병기:** 위 JSON 예제는 `invitees`가 `emails` 배열을 감싼 객체이지만, Input 스키마 표는 `invitees`를 `String[]`로 기재한다. PDF 원문이 서로 다르므로 그대로 병기한다.

---

## Input 스키마 (공유 참조)

여러 리소스가 아래 Input 바디를 공유한다.

| Input (root 요소) | 프로퍼티 | 비고 |
|---|---|---|
| **Group Input** (`<group>`) | announcement(String v31.0) · canHaveChatterGuests(Bool v29.0, true 후 false 불가) · description(String v29.0) · information(Group Information Input v28.0) · isArchived(Bool v29.0, 기본 false) · isAutoArchiveDisabled(Bool v29.0) · isBroadcast(Bool v36.0) · name(String v29.0) · owner(String v29.0, **PATCH 전용**) · visibility(String v29.0) | 리소스 1·2 |
| **Group Information Input** | text(String, HTML 미지원, **최대 4000자**, v28.0) · title(String, **최대 240자**, v28.0) | Group Input에 중첩 |
| **Group Member Input** (`<member>`) | role(GroupManager/StandardMember v29.0) · userId(String v23.0) | 리소스 7·10 |
| **Group Chatter Settings Input** (`<groupChatterSettings>`) | emailFrequency(EachPost/DailyDigest/WeeklyDigest/Never v27.0) | 리소스 15 |
| **Group Record Input** (`<groupRecord>`) | recordId(String, **Req**, v34.0) | 리소스 13 |
| **Announcement Input** (`<announcement>`) | body · expirationDate · feedItemId · isArchived · parentId · sendEmails | 리소스 4 상세 참조 |
| **Group Membership Request Update** (`<groupMembershipRequestUpdate>`) | responseMessage(최대 756자 v27.0) · status(Accepted/Declined v27.0) | 리소스 9 |
| **Photo Input** (`<photo>`) | cropSize · cropX · cropY · fileId · versionNumber | 리소스 12 상세 참조 |
| **Banner Photo Input** (`<bannerPhoto>`) | cropHeight · cropWidth · cropX · cropY · fileId · versionNumber | 리소스 5 상세 참조 |
| **Invite Collection Input** (`<inviteCollection>`) | invitees(String[]) · message | 리소스 17 상세 참조 |

---

## Enum 전수

| Enum (사용처) | 값 |
|---|---|
| **visibility** (Group) | `PrivateAccess`(멤버만 게시글 열람) · `PublicAccess`(Experience Cloud site 전체 열람) · `Unlisted`(Reserved for future use) |
| **archiveStatus** (List GET 파라미터) | `All` · `Archived` · `NotArchived`(기본) |
| **role** (Group Member) | `GroupManager` · `StandardMember` |
| **status** (멤버십 요청 GET 필터) | `Accepted` · `Declined` · `Pending` |
| **status** (멤버십 요청 PATCH) | `Accepted` · `Declined` |
| **emailFrequency** (Group Chatter Settings) | `EachPost` · `DailyDigest` · `WeeklyDigest` · `Never` |

---

## 응답 바디 (Reference 챕터 위임)

이 리소스들이 반환하는 응답 바디의 **전체 스키마는 Response Bodies Reference 챕터 소관**이다. 여기서는 이름만 나열한다(필드 재서술 금지):

Group Page · Group Detail · Batch Results · Announcement Page · Announcement · Banner Photo · File Summary Page · Group Member Page · Group Member · Group Membership Request Collection · Group Membership Request · Photo · Group Record Page · Group Record · Group Chatter Settings · Topic Collection · Invite Collection · User Summary(중첩) · 204: Successful Delete.

---

## 관련 노트
- [[Feeds Resources]] — 그룹의 피드는 groups 리소스가 아니라 record feed 리소스에 `groupId`를 넘겨 조회·게시한다(groups ≠ feed).
- [[Feed Elements Resources]] — 그룹에 게시하는 feed element(post) 처리.
- [[Topics · Announcements · Q&A Resources]] — 그룹 공지 게시(리소스 4)의 조회·수정·삭제는 이 노트의 Announcements 리소스가 담당.
- [[Connect REST API 요청·응답 규약]] — base URI·페이지네이션·바이너리(multipart) 업로드 규약.
- [[Connect REST API 개요]] — Connect REST API 상위 개요.
