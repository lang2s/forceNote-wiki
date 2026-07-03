---
tags: [integration, connect-rest-api, notifications, push-notifications, notification-settings]
source: salesforce_chatter_rest_api.pdf (Connect REST API Developer Guide, Version 67.0 Summer '26; PDF p525–534·579–580; Tier 1/2)
created: 2026-07-03
aliases: [Notifications, 알림, in-app notification, 인앱 알림, Push Notifications, 푸시 알림, Notification Settings, 알림 설정, Notification Types]
---

# Connect REST API — Notifications Resources

> 플랫폼 in-app/푸시 알림 API. 알림 설정을 org·앱 단위로 조회·설정·리셋하고(Settings 4), 컨텍스트 사용자의 알림을 조회·read/seen 표시·action 실행하고(Notifications 5), 모바일 기기로 푸시 알림을 전송한다(Push 1) — 총 10개 리소스. (Analytics 알림과는 별개 API다.)

---

## 개요

이 클러스터는 세 그룹으로 나뉜다.

- **Notification Settings (4)** — *"Get, set, and reset notification settings and notification app settings."* org 단위 알림 설정과 앱 단위 알림 설정을 조회·변경·리셋.
- **Notifications (5)** — *"Get or update notifications. Execute an action for a notification. Get the status. Get supported notification type details and actions."* 컨텍스트 사용자의 알림 조회·표시, action 실행, 상태 조회, 지원 type 조회.
- **Push Notifications (1)** — *"Send a mobile push notification to client apps on users' devices."* 사용자 기기의 클라이언트 앱으로 모바일 푸시 전송.

> ⚠️ 이 3그룹에는 원문상 **"Requires Chatter" 표기가 없고**, `/connect/communities/{communityId}` 같은 **Experience Cloud 변형 URI도 없다** — 이 노트에서도 만들지 않는다.
>
> 응답 바디는 이름만 기재한다. 전체 응답 스키마와 프로퍼티는 **Reference 챕터로 위임** — 여기서 재서술하지 않는다.

---

## Notification Settings

알림 설정(notification setting)은 각 notification type이 정의하는 기본값이고, 앱 설정(notification app setting)은 앱별 활성/비활성 상태다. **어드민은 기본 활성 설정을 비활성으로만 바꿀 수 있다**(기본 비활성인 설정을 활성화할 수는 없다). 단, 커스텀 앱 설정은 앱이 커스텀을 허용하면 기본 비활성을 활성화할 수 있다.

| # | 리소스 | URI | 메서드 | v | 응답 |
|---|---|---|---|---|---|
| A1 | Notification Settings | `/connect/notifications/settings/organization` | GET | 47.0 | Notification Settings Collection |
| A2 | Notification Setting | `/connect/notifications/settings/organization/{notificationTypeOrId}` | GET, POST, DELETE | 47.0 | GET/POST → Notification Setting · DELETE → 204 (기본값 리셋) |
| A3 | Notification App Settings | `/connect/notifications/app-settings/organization` | GET | 47.0 | Notification App Settings Collection |
| A4 | Notification App Setting | `/connect/notifications/app-settings/organization/{notificationTypeOrId}` | GET, POST, DELETE | 47.0 | GET → Notification App Settings Collection · POST → Notification App Setting · DELETE → 204 |

> ⚠️ **A4 GET 응답 원문 주의:** 리소스는 단건(`.../{notificationTypeOrId}`)인데 원문의 GET 응답 타입은 복수형 **"Notification App Settings *Collection*"**으로 표기돼 있다. 원문 그대로 기록한다(오기 가능성 병기).

### A2 — Notification Setting POST 입력

POST 바디 루트는 `<notificationTargetSetting>`. 미지정 필드는 값이 변경되지 않는다. DELETE는 이 설정을 기본값으로 리셋한다. POST 파라미터도 동일 필드.

| 필드 | Type | 필수 | v | 설명 |
|---|---|---|---|---|
| desktopEnabled | Boolean | Opt | 47.0 | 데스크톱 알림 활성 여부 |
| emailEnabled | Boolean | Opt | 47.0 | 이메일 알림 활성 여부 |
| mobileEnabled | Boolean | Opt | 47.0 | 모바일 알림 활성 여부 |
| slackEnabled | Boolean | Opt | 52.0 | Slack 알림 — **Reserved for future use** |

```json
// 구조 예시 — 실제 동작 설정 아님 (A2 Notification Setting POST 바디)
{ "desktopEnabled": "false" }
```

### A4 — Notification App Setting POST 입력

표준 앱 설정은 기본 활성만 비활성 가능; 커스텀 앱 설정은 앱이 커스텀을 허용하면 기본 비활성도 활성 가능. POST 바디 루트는 `<notificationAppSetting>`.

| 필드 | Type | 필수 | v | 설명 |
|---|---|---|---|---|
| applicationId | String | Opt | 47.0 | connected app 또는 external client app ID |
| enabled | Boolean | Opt | 47.0 | 앱 알림 활성 여부 |

- **GET 파라미터:** `applicationId` (String, Opt, v47.0). 미지정 상태로 앱이 호출하면 세션 앱이 기본값.
- **DELETE 파라미터:** `applicationId` (Opt, **v40.0**). ⚠️ 다른 필드는 v47.0인데 DELETE의 applicationId만 원문이 **v40.0**으로 표기 — 원문 그대로 기록(오기 가능성 병기).
- **POST Note:** v64.0부터 **external client app 지원(beta)** — connected app 외에도 사용 가능.

```json
// 구조 예시 — 실제 동작 설정 아님 (A4 Notification App Setting POST 바디)
{ "enabled": "false" }
```

> **A3 Note:** v64.0부터 mobile·push·notification plugin에 **external client app**을 지원한다(connected app 외). GET 파라미터 `applicationId`(String, Opt, v47.0)는 connected/external client app ID이며, 미지정 상태로 앱이 호출하면 세션 앱이 기본값.

---

## Notifications

컨텍스트 사용자의 알림을 조회하고 read/unread·seen/unseen을 표시하며, 알림에 대한 action을 실행하고, 상태·지원 type을 조회한다.

| # | 리소스 | URI | 메서드 | v | 응답 |
|---|---|---|---|---|---|
| B1 | Notifications | `/connect/notifications` | GET, PATCH | 49.0 | Notification Collection |
| B2 | Notification | `/connect/notifications/{notificationId}` | GET, PATCH | 49.0 | Notification |
| B3 | Notification Action | `/connect/notifications/{notificationId}/actions/{actionKey}` | POST | 66.0 | Action Result |
| B4 | Notifications Status | `/connect/notifications/status` | GET | 49.0 | Notification Status |
| B5 | Notifications Types | `/connect/notifications/types` | GET | 66.0 | Notification Type Collection |

> ⚠️ **B3 URI 불일치 병기:** 원문의 **요약표**는 B3를 `/connect/notifications/{notificationId}/{actionKey}`로, **상세 정의**는 `/connect/notifications/{notificationId}/actions/{actionKey}`로 표기한다. 상세(`actions/`) 쪽이 정식으로 보이나 원문에 둘 다 있으므로 병기한다.

### B1 — Notifications GET

컨텍스트 사용자의 알림을 조회한다. 요청 클라이언트 앱의 컨텍스트에 맞는 type만 반환된다 — 앱은 자신이 구독한 type의 custom 알림만(그리고 org 설정이 적용됨), 서드파티 앱은 desktop이 활성인 custom 알림만.

| Param | Type | 필수 | v | 설명 |
|---|---|---|---|---|
| after | String (ISO 8601) | Opt | 49.0 | 이 시각 이후 알림. `before`와 **병용 불가** |
| before | String (ISO 8601) | Opt | 49.0 | 이 시각 이전 알림. 미지정 시 현재 시각 |
| size | Integer | Opt | 49.0 | 1–50. 50 초과 시 50으로 처리. 기본 10 |
| trimMessages | Boolean | Opt | 50.0 | true → title 120자·body 320자 / false → title 250자·body 750자. 기본 **true** |

### B1 — Notifications PATCH (read/seen 표시)

PATCH 바디 루트는 `<notifications>`. read/seen 규칙에 주의:

| 필드 | Type | 필수 | v | 설명 |
|---|---|---|---|---|
| before | String | Opt | 49.0 | 이 시각 이전 알림 대상 |
| notificationIds | String[] | Opt | 49.0 | 대상 알림 ID **최대 50개**. `before`와 **병용 불가** |
| read | Boolean | 조건부 | 49.0 | `seen` 미지정 시 필수. **read=true면 seen도 true**로 처리. **read=true·seen=false 조합은 에러** |
| seen | Boolean | 조건부 | 49.0 | `read` 미지정 시 필수 |

```json
// 구조 예시 — 실제 동작 설정 아님 (B1 Notifications PATCH 바디)
{ "before": "2019-06-25T18:24:31.000Z", "read": "true" }
```

### B2 — Notification (단건)

단건 알림을 조회·표시한다. GET 파라미터 `trimMessages`(Boolean, Opt, v50.0). PATCH 바디 루트는 `<notification>`이며 `read`·`seen`은 B1과 동일 규칙(read=true → seen=true, read=true·seen=false는 에러).

```json
// 구조 예시 — 실제 동작 설정 아님 (B2 Notification PATCH 바디)
{ "read": "true" }
```

### B3 — Notification Action

알림에 대해 action을 실행한다. `actionKey`는 **Notifications Types(B5)** 리소스에서 취득한다. **POST 파라미터·바디 없음.** 응답은 Action Result.

### B4 — Notifications Status

컨텍스트 사용자의 알림 상태를 조회한다. 응답 Notification Status.

### B5 — Notifications Types

지원되는 notification type의 상세 정보와 action을 조회한다. 응답 Notification Type Collection. (여기서 얻은 action이 B3의 `actionKey` 입력이 된다.)

---

## Push Notifications

사용자 기기의 클라이언트 앱으로 모바일 푸시 알림을 전송한다. 이 리소스는 **수신자 클라이언트 앱과 같은 org에서 개발됐거나 같은 패키지에 설치된** 클라이언트 앱으로 세션이 성립됐을 때만 접근 가능하다.

| 리소스 | URI | 메서드 | v | 응답 |
|---|---|---|---|---|
| Push Notification | `/connect/notifications/push` | POST | 31.0 | ⚠️ 원문 미표기 (아래) |

POST 바디 루트는 `<pushNotification>`. POST 파라미터도 동일 필드.

| 필드 | Type | 필수 | 설명 |
|---|---|---|---|
| appName | String | **Req** | 대상 클라이언트 앱의 API 이름 |
| namespace | String | 조건부 | namespace가 설정돼 있으면 Req |
| payload | String | **Req** | JSON 형식의 푸시 페이로드 |
| userIds | String[] | **Req** | 수신자 user ID |

```json
// 구조 예시 — 실제 동작 설정 아님 (Push Notification POST 바디)
{
  "appName": "TestApp",
  "namespace": "abc",
  "userIds": ["005x00000013dPK", "005x00000013dPL"],
  "payload": "{'aps':{'alert':'test','badge':0,'sound':'default'}}"
}
```

> ⚠️ **Push POST 응답 바디는 원문에 표기가 없다.** 임의로 채우지 않는다 — 응답 바디명은 미상.

---

## 응답 바디명 (Reference 위임)

전체 스키마·프로퍼티는 Reference 챕터에 있으며, 이 노트는 응답 타입 이름만 기록한다.

`Notification Settings Collection` · `Notification Setting` · `Notification App Settings Collection` · `Notification App Setting` · `Notification Collection` · `Notification` · `Action Result` · `Notification Status` · `Notification Type Collection`

---

## 관련 노트
- [[Connect REST API 요청·응답 규약]] — base URI·페이지네이션·헤더 규약
- [[Connect REST API 개요]] — Connect REST API 상위 개요
