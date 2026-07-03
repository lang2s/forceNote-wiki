---
tags: [integration, connect-rest-api, user-profiles, subscriptions, followers]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p937·987·992–997; Tier 1/2)
created: 2026-07-03
aliases: [User Profiles, 사용자 프로필, Subscriptions, 구독, Followers on Records, 레코드 팔로워, Profile Photo, Banner Photo, 언팔로우]
---

# Connect REST API — User Profiles · Subscriptions · Followers on Records Resources

> 레코드 팔로워 조회(Followers on Records), 구독 조회·삭제를 통한 언팔로우(Subscriptions), Chatter 프로필 페이지를 채우는 프로필 상세·배너 사진·프로필 사진(User Profiles) 리소스.

> 특별 명시가 없으면 **Requires Chatter: Yes**. 각 리소스는 Experience Cloud 변형 `/connect/communities/{communityId}/...`가 병존한다.
> 응답 바디는 이름만 표기한다 — 전체 스키마는 [[Connect REST API 요청·응답 규약]] 및 Request/Response Bodies Reference 챕터로 위임한다.

---

## Followers on Records Resource

지정 레코드의 팔로워 정보를 조회한다.

| 항목 | 값 |
|---|---|
| URI | `/chatter/records/{recordId}/followers` |
| 버전 | v23.0 (**v29.0부터 `recordId`에 topic ID 사용 가능**) |
| 메서드 | GET, HEAD |
| 응답 | `Follower Page` |

**GET 파라미터**

| Param | Type | 설명 | 기본값 |
|---|---|---|---|
| `page` | Integer | 페이지 번호 | 0 |
| `pageSize` | Integer | 페이지당 항목 수 (1–1000) | 25 |

---

## Subscriptions Resource

지정 구독 정보를 조회하거나, 구독을 삭제해 **레코드/토픽을 언팔로우**하는 데 사용한다. subscription ID는 follower / following 리소스의 응답, group 및 user summary 등에서 반환된다.

| 항목 | 값 |
|---|---|
| URI | `/chatter/subscriptions/{subscriptionId}` |
| 버전 | v23.0 |
| 메서드 | GET, DELETE, HEAD |
| 응답 | GET → `Subscription` · DELETE → HTTP 204 |

**언팔로우 예시**

```
// 구조 예시 — 실제 동작 코드 아님
DELETE /chatter/subscriptions/0E8D00000001JkFKAU
```

---

## User Profiles Resources

3개 하위 리소스로 구성된다. 프로필 데이터는 Chatter 프로필 페이지를 채운다(주소·매니저·전화·capability·subtab 앱).

| 리소스 | URI |
|---|---|
| Profile 상세 | `/connect/user-profiles/{userId}` |
| Banner Photo | `/connect/user-profiles/{userId}/banner-photo` |
| Photo | `/connect/user-profiles/{userId}/photo` |

> `userId`는 실제 사용자 ID 또는 alias `me`.

### User Profiles Resource — 프로필 상세

| 항목 | 값 |
|---|---|
| URI | `/connect/user-profiles/{userId}` |
| 버전 | v29.0 |
| 메서드 | GET, HEAD |
| 응답 | `User Profile` |

프로필 상세를 조회한다. **capabilities**는 context user가 subject user에 대해 갖는 capability(채팅·DM 가능 여부 등)를 나타낸다.

### User Profiles Banner Photo

| 항목 | 값 |
|---|---|
| URI | `/connect/user-profiles/{userId}/banner-photo` |
| 버전 | v36.0 |
| 메서드 | GET, HEAD, POST, DELETE |
| POST body root | `<bannerPhoto>` |
| 응답 | GET / POST → `Banner Photo` · DELETE → HTTP 204 |

`fileId`(바디/파라미터) 또는 multipart 바이너리로 배너 이미지를 지정한다. User Profile 페이지에 업로드된 이미지는 `fileId`가 없어 사용할 수 없다. **처리는 비동기다.**

**POST body 프로퍼티**

| Property | Type | 필수 | 설명 | Ver |
|---|---|---|---|---|
| `cropHeight` | Integer | Opt | crop 높이 | 36.0 |
| `cropWidth` | Integer | Opt | crop 너비 | 36.0 |
| `cropX` | Integer | Opt | crop X 좌표 | 36.0 |
| `cropY` | Integer | Opt | crop Y 좌표 | 36.0 |
| `fileId` | String | 기존 파일 사용 시 Req | 18자, prefix `069` 이미지 파일 ID. **2GB 미만** | 36.0 |
| `versionNumber` | — | Opt | 버전 번호 | 36.0 |

> ⚠️ **원문 불일치(그대로 병기):** body 프로퍼티 문서는 `fileId`를 **2GB 미만**으로, param 문서는 동일 `fileId`를 **"less than 8 MB"**로 기술한다. PDF 원문이 서로 다르므로 봉합하지 않고 양쪽을 그대로 옮긴다.

```json
// 구조 예시 — 실제 동작 설정 아님 (PDF 예시값 반영)
{ "cropHeight": "120", "cropWidth": "240", "fileId": "069D00000001IOh" }
```

### User Profiles Photo

| 항목 | 값 |
|---|---|
| URI | `/connect/user-profiles/{userId}/photo` |
| 버전 | v35.0 |
| 메서드 | GET, DELETE, POST |
| POST body root | (body/param 모두 지원) |
| 응답 | GET / POST → `Photo` |

`fileId` 또는 multipart로 프로필 사진을 지정한다. 피드에 프로필 사진을 표시할 때 이를 캐시하며, `Photo` 응답의 `photoVersionId`로 갱신 여부를 판단한다(한도·모바일 성능 고려). **처리는 비동기다.**

**POST body / param 프로퍼티**

| Property | Type | 필수 | 설명 | Ver |
|---|---|---|---|---|
| `cropSize` | Integer | 업로드/기존 crop 시 Req | crop 크기 | 35.0 |
| `cropX` | Integer | 업로드/기존 crop 시 Req | crop X 좌표 | 35.0 |
| `cropY` | Integer | 업로드/기존 crop 시 Req | crop Y 좌표 | 35.0 |
| `fileId` | String | 기존 선택 시 Req | 18자, prefix `069` 이미지 파일 ID. **2GB 미만** | 35.0 |
| `versionNumber` | — | Opt | 버전 번호 | 35.0 |

```json
// 구조 예시 — 실제 동작 설정 아님 (PDF 예시값 반영)
{ "cropSize": "240", "cropX": "20", "cropY": "20", "fileId": "069D00000001IOh" }
```

param 형태:

```
// 구조 예시 — 실제 동작 코드 아님
?cropSize=240&cropX=20&cropY=20&fileId=069D00000001IOh
```

---

## 응답 바디 스키마

이 노트는 URI·메서드·버전·요청 Input 프로퍼티를 전수 수록하되, 응답 바디(`Follower Page`·`Subscription`·`User Profile`·`Banner Photo`·`Photo`)의 전체 필드 스키마는 Request/Response Bodies Reference 챕터로 위임한다. [[Connect REST API 요청·응답 규약]] 참조.

---

## 관련 노트
- [[Users Resources - 프로필·대화·메시지·팔로우]] — 사용자 코어 리소스(`users/{id}` 프로필 vs `user-profiles`)
- [[Feeds Resources]] — record feed·팔로우 대상 피드
- [[Connect REST API 요청·응답 규약]] — base URI·바이너리(multipart) 업로드 규약
- [[Connect REST API 개요]] — 상위 개요
