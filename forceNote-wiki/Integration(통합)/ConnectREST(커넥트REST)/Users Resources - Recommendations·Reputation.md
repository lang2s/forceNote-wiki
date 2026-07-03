---
tags: [integration, connect-rest-api, recommendations, reputation, users]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p1014–1029 User Recommendations/Reputation; Tier 1/2)
created: 2026-07-03
aliases: [User Recommendations, 추천, Chatter Recommendations, Reputation, 평판, channel, People Also Viewed, static recommendation]
---

# Users Resources — Recommendations·Reputation

> Chatter 추천(팔로우·가입·조회) 6개 리소스와 Experience Cloud 사용자 평판(Reputation) 리소스. `/chatter/users/{userId}/recommendations` 아래 action·objectCategory·keyPrefix·objectId·static 계층으로 좁혀 조회하며, `me` alias 사용 가능.

---

## 개요

이 노트는 [[Users Resources - 프로필·대화·메시지·팔로우]] 챕터의 후반부 — **추천(Recommendations) 6리소스 + 평판(Reputation)** 을 다룬다. 추천 4개 리소스가 동일한 GET 파라미터 6개를 공유하므로, 공통 파라미터와 `channel` enum을 먼저 1회 정의한 뒤 리소스별로 달라지는 유효값(action / objectCategory / idPrefix / objectId / objectEnum)만 표로 정리한다.

- 모든 추천 리소스 응답: `Chatter Recommendations` (전체 스키마는 Request/Response Bodies Reference 챕터 위임 — [[Connect REST API 요청·응답 규약]] 참조).
- `userId`는 실제 사용자 ID 또는 alias `me`.

---

## 추천 공통 GET 파라미터 (6개 — 1회 정의)

아래 파라미터는 General·+Action·+ObjectCategory·+KeyPrefix 등 추천 조회 리소스가 공통으로 받는다.

| Param | Type | 설명 | Ver |
|---|---|---|---|
| `channel` | String | 커스텀 추천을 묶는 방식(UI 위치·시간·지역 등). 값은 아래 channel enum | 36.0 |
| `contextAction` | String | 방금 수행한 action. 값 `follow` / `view`. `contextObjectId`와 함께 사용 | 33.0 |
| `contextObjectId` | String | 방금 action을 수행한 객체 ID. `follow`면 user·file·record·topic(36.0+); `view`면 user·file·group·record·article(37.0+) | 33.0 |
| `followed` | String | 지정 user ID를 context로 한 새 추천. **⚠️ 33.0+에서는 대신 `contextAction`·`contextObjectId` 사용** | 23.0–32.0 |
| `maxResults` | Integer | 최대 결과 수. 기본 10, 유효 범위 1–99 | 23.0 |
| `viewed` | String | 지정 file ID를 context로 한 새 추천. **⚠️ 33.0+에서는 대신 `contextAction`·`contextObjectId` 사용** | 23.0–33.0 |

### channel enum

| 값 | 설명 |
|---|---|
| `CustomChannel1` ~ `CustomChannel5` | 기본적으로 미사용. community manager와 협의해 정의 |
| `DefaultChannel` | 기본값. Customer Service·Partner Central 템플릿의 Home·Question Detail·mobile web 피드에 추천 표시 |

---

## 추천 리소스 (6개)

각 리소스는 상위 URI `/chatter/users/{userId}/recommendations`를 계층적으로 좁힌다. 특별 표기 없으면 응답은 `Chatter Recommendations`.

### 4-16. General — `/chatter/users/{userId}/recommendations`
- **버전** v24.0 · **메서드** GET
- 지정 사용자의 전체 추천. 위 공통 GET 파라미터 사용.

### 4-17. + Action — `/…/recommendations/{action}`
- **버전** v24.0 · **메서드** GET
- `{action}` 유효값 및 대상 객체 타입:

| action | 대상 객체 타입 (버전) |
|---|---|
| `follow` | user · file · record · topic(v36.0+) |
| `join` | group |
| `view` | user · file · group · record(v25.0+) · custom(v34.0+) · static(v35.0+) · article(v37.0+) |

### 4-18. + Action + ObjectCategory — `/…/recommendations/{action}/{objectCategory}`
- **버전** v23.0 · **메서드** GET
- `{objectCategory}` 유효값 매트릭스:

| action | objectCategory 유효값 |
|---|---|
| `follow` | `users` · `files` · `records` · `topics`(v36.0+) |
| `join` | `groups` |
| `view` | `users` · `files` · `groups` · `records` · `custom`(v34.0+) · `apps`(v35.0+) · `articles`(v37.0+) |

### 4-19. + Action + KeyPrefix — `/…/recommendations/{action}/{idPrefix}`
- **버전** v26.0 · **메서드** GET
- `{idPrefix}` = 대상 객체 ID의 앞 3자. action별 유효 idPrefix:

| action | idPrefix (객체) |
|---|---|
| `follow` | `005`(users) · `069`(files) · `0TO`(topics) · records |
| `join` | `0F9`(groups) |
| `view` | `005` · `069` · `0F9` · records · `0RD`(custom, v34.0+) · `T`(static, v35.0+) · `kA0`(articles, v37.0+) |

- 예: `view/001`

### 4-20. + Action + ObjectId — `/…/recommendations/{action}/{objectId}`
- **버전** v24.0 · **메서드** GET / DELETE
- `{objectId}` 유효값:

| action | objectId 유효값 |
|---|---|
| `follow` | user · file · record · topic ID(v36.0+) |
| `join` | group ID |
| `view` | user · file · group · record ID · custom ID(v34.0+) · static `Today`(v35.0+) · article ID(v37.0+) |

- **DELETE**(추천 제거)가 유효한 리소스:
  - `follow/{userId · fileId · recordId · topicId}`
  - `join/{groupId}`
  - `view/{customRecId}`
  - `view/Today`
  - `view/{articleId}`
- 응답: GET → `Chatter Recommendations`, DELETE → 204.

### 4-21. + Action + ObjectType (static) — `/…/recommendations/{action}/{objectEnum}`
- **버전** v34.0 · **메서드** GET / DELETE
- action은 `view`. `{objectEnum}` = `Today` (ID 없는 static 추천). static 추천 삭제에도 사용.
- 응답: GET → `Chatter Recommendations`, DELETE → 204.

---

## 4-22. User Reputation — `/connect/communities/{communityId}/chatter/users/{userId}/reputation`
- **버전** v32.0 · **메서드** GET / HEAD
- **⚠️ Experience Cloud 전용** — `/chatter/…` 단독 변형이 없다(반드시 `communityId` 경로 포함). 사이트 내 지정 사용자의 평판 조회.
- 응답: `Reputation`.

---

## 추천 URL 예제

```
// 구조 예시 — 실제 동작 코드 아님 (URI 패턴·예시값 참고용)

# People Also Viewed — 방금 조회한 파일(069…) context로 view 추천
GET /services/data/v67.0/chatter/users/me/recommendations/view/files
      ?contextAction=view&contextObjectId=069D00000001IOh

# 방금 팔로우한 사용자(005…) context로 follow 추천
GET /services/data/v67.0/chatter/users/me/recommendations/follow/users
      ?contextAction=follow&contextObjectId=005D0000001abcXYZ

# static "Today" 추천 제거
DELETE /services/data/v67.0/chatter/users/me/recommendations/view/Today

# Experience Cloud 사용자 평판
GET /services/data/v67.0/connect/communities/{communityId}/chatter/users/me/reputation
```

> 응답 바디(`Chatter Recommendations` · `Reputation`)의 전체 스키마는 Request/Response Bodies Reference 챕터로 위임한다 — [[Connect REST API 요청·응답 규약]] 참조.

---

## 관련 노트
- [[Users Resources - 프로필·대화·메시지·팔로우]] — 같은 Users 챕터의 코어 리소스(프로필·대화·메시지·팔로우·설정)
- [[Connect REST API 요청·응답 규약]] — base URI·요청/응답 바디 규약
- [[Connect REST API 개요]] — 상위 개요
