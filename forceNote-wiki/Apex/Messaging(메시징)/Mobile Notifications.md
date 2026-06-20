---
tags: [apex, messaging, mobile, push-notification, notification-builder, custom-notification, connect-rest, invocable-action, reference]
source: salesforce_mobile_push_notifications_implementation.pdf (Salesforce Mobile Notifications Implementation Guide, Summer '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.pushImplementation.meta/pushImplementation/
created: 2026-06-20
aliases: [Mobile Notifications, Push Notification, PushNotification, PushNotificationPayload, customNotificationAction, Notification Builder, 모바일 알림, 푸시 알림, 인앱 알림, 커스텀 알림 액션, APNs, FCM]
---

# Mobile Notifications

> Salesforce 모바일 알림(push + in-app)을 보내는 두 서버측 시스템 — **Notification Builder**(UI/invocable·조회) vs **Apex**(레거시, push 전용) — 의 구현·등록·레퍼런스. (`salesforce_mobile_push_notifications_implementation.pdf` Summer '26)

---

## 개요 — 두 알림 시스템

Lightning Platform은 **두 개의 서버측 알림 시스템**을 제공한다. 모바일 앱 개발자가 고객 org에서 비즈니스 이벤트가 발생할 때 고객에게 알릴 수 있게 한다. 알림은 기기로 **푸시(push)** 하거나 앱 안에서 **전달(in-app)** 할 수 있다. 모든 알림은 Salesforce 앱과 커스텀 앱 양쪽을 지원한다.

| 시스템 | 성격 |
|---|---|
| **Notification Builder** | Full-featured, UI 중심 플랫폼. Chatter 등을 구동하는 core notifications framework와 통합돼 있어, Process Builder·Flow·REST API로 invocable action 알림을 보낼 수 있다. 과거 알림을 조회해 커스텀 in-app 알림 화면에 사용할 수 있다. Salesforce 앱·고객 앱 양쪽에 발송 가능. |
| **Apex** | **레거시** 코드 기반 플랫폼, **push 전용**. Apex 트리거가 고객 org의 비즈니스 이벤트를 포착하고, Apex 또는 Connect REST API로 push를 보낸다. **Apex push는 발송한 payload를 보존하지 않는다**(이후 재사용 불가). |

> 플랫폼 선택 가이드: 기존 Apex push 구현이 있으면 레거시 플랫폼은 **완전히 지원(fully supported)** 된다. 새 기능(구독·스케줄·invocable·in-app·조회·암호화)이 필요하면 Notification Builder를 쓴다.

> ℹ️ 이 가이드는 **Marketing Cloud 앱에는 적용되지 않는다.** Marketing Cloud MobilePush는 MobilePush / Journey Builder for Apps SDK를 참조.

### Notification Builder vs Apex Push 비교표

> Pattern B-1 셀별 매핑: PDF 표(raw L113-128)의 모든 값은 Apex Push 열이 `Push notifications`만 **Supported**, 나머지 7행은 모두 **Not supported**, Notification Builder 열은 8행 전부 **Supported**. → ✅ = Supported, ❌ = Not supported.

| Type 또는 Feature | Apex Push | Notification Builder Platform |
|---|---|---|
| Push notifications | ✅ Supported | ✅ Supported |
| Subscriptions | ❌ Not supported | ✅ Supported |
| Scheduled notifications | ❌ Not supported | ✅ Supported |
| Invocable action notifications | ❌ Not supported | ✅ Supported |
| In-app notifications | ❌ Not supported | ✅ Supported |
| Retrievable payloads | ❌ Not supported | ✅ Supported |
| Custom notification types | ❌ Not supported | ✅ Supported |
| Encryption | ❌ Not supported | ✅ Supported |

두 시스템 모두 payload와 수신자 목록을 기기 OS 벤더 서비스(**Apple, Google**)로 전달해 고객 모바일 기기에 배달한다. Notification Builder는 보낸 알림을 보존하고 조회 API를 제공한다. Apex 트리거가 잡을 수 없는 이벤트(예: Salesforce 외부 소스)는 **Connect REST API**가 대체 발송 경로를 제공한다 — Connect REST로 Apex push 또는 Notification Builder invocable action 둘 다 보낼 수 있다.

### 알림 종류

PDF가 분류하는 알림 종류(raw L81-102):

- **Mobile push notifications** — 이벤트에 반응해 보내는 알림. 보통 고객이 앱을 보지 않을 때 모바일 기기로 도착한다. push는 두 종류: **Apex push**(전통적 "send, fire, and forget" 메커니즘)와 **Notification Builder push**(더 풍부한 기능). Notification Builder push는 보낼 custom notification type에 external client app을 **구독(subscribe)** 시켜야 한다.
- **In-app notifications** — Salesforce 모바일 앱·다른 Salesforce 앱·올바르게 구성된 커스텀 앱을 사용 중일 때 전달되는 알림. Salesforce 모바일 앱에서는 **Notification Bell**에 표시된다. 다른 클라이언트 앱은 Notification Builder API로 자체 알림 화면을 구현할 수 있다.
- **Custom notification types** — Setup의 Notification Builder로 만드는 알림 유형. Process Builder·Flow Builder·invocable action API로 발송한다.
- **Configurable delivery settings and preferences** — custom notification type별로 전달 채널(desktop / mobile / both)을 선택. external client app을 type에 구독시켜 커스텀 in-app 알림 tray로 API가 반환하게 하거나, 구독 알림을 push로도 보낼 수 있다.
- **Invocable action notifications** — `customNotificationAction` API로 커스텀 알림을 invocable action으로 발송.
- **Scheduled notifications** — Process Builder에서 레코드 변경·플랫폼 이벤트·프로세스 트리거 시 알림 스케줄. Flow Builder에서 `customNotificationAction` API를 정해진 간격으로 스케줄.

---

## 등록 & 흐름 (Push Notification Registration and Flow)

push를 활성화하려면 여러 엔티티에 등록하고 필요한 설정을 구성한다. push 발송에 관여하는 엔티티(raw L179-182):

- 알림을 기기로 배달하는 **OS 벤더**
- 알림을 보내는 **Salesforce 조직**
- 알림을 받아 표시하는 **모바일 기기**

개발자 등록 절차 개요(raw L184-191):

1. push 서비스를 위해 모바일 OS 벤더(Apple 또는 Google)에 등록한다.
2. Salesforce에서 **external client app**을 만들어 push 자격증명(iOS `.p12` 인증서 또는 Android 토큰)을 업로드한다.
3. Salesforce Mobile SDK로 모바일 클라이언트 앱이 push를 처리하도록 활성화한다.
4. 특정 이벤트가 Salesforce 레코드에 발생할 때 push를 보내는 Apex 트리거를 작성한다.
5. (파트너 전용) 다른 고객 org용 push 트리거를 개발하는 파트너는, external client app과 Apex 트리거를 담은 **2세대 관리형 패키지**를 만들어 고객 org에 배포한다.

> 📊 PDF에 다이어그램 있음 — 본 wiki에는 텍스트 설명만. PDF는 "Push Notification Flow for Customers"와 "Push Notification Flow for Partners and Customers" 두 개의 figure를 포함하나 pdftotext가 이미지를 잡지 못한다. 산문으로 명시된 흐름: ① OS 벤더(figure에서는 Apple) 개발자 등록 → ② Salesforce external client app 설정 → ③ Salesforce org에서 트리거로 push 발송 → ④ OS 벤더가 모바일 기기로 push 배달. Push Notification Service는 Apex `Messaging.PushNotification` 클래스의 `send` 호출에 지정된 사용자에게 메시지를 보낸다.

모바일 알림을 받으려는 모든 앱이 요구하는 것(raw L139-150):

- **Salesforce external client app 구성**(서버측) — 모든 Salesforce 모바일 알림은 external client app 프레임워크를 사용. 사내 자체 제작 앱, App Store/Google Play로 배포되는 Mobile SDK 앱, 관리형 패키지로 설치되는 파트너/ISV 앱을 지원.
- **대상 OS 벤더(Apple·Google) 등록** — 알림 수신 앱의 개발자로 등록. 이는 앱이 런타임에 수행하는 등록과는 별개.
- **클라이언트 앱의 최소 코딩** — Mobile SDK가 알림 등록 boilerplate를 제공.
- **서버측 코딩** — 메커니즘에 따라 Apex 트리거 또는 REST API 호출 코딩 필요.

---

## 구현 단계 (Setup) ※ 요약 — 상세는 공식 문서

> 아래 4단계는 절차 프로즈(UI·콘솔 클릭)라 본 노트는 요약만 담고, 깊이는 API 섹션에 둔다. 상세 절차는 [공식 가이드](https://developer.salesforce.com/docs/atlas.en-us.pushImplementation.meta/pushImplementation/)를 참조.

### Step 1. OS 벤더 등록 (APNs / FCM)

대상 모바일 OS의 절차를 따른다(raw L256-264).

- **Android (FCM)** — Android Developer Program 회원이어야 한다. FCM push는 Android Market 앱 또는 Google Play Services가 설치된 **실제 Android 기기에서만** 테스트 가능 — **에뮬레이터에서는 동작하지 않는다**. Salesforce는 **Firebase Cloud Messaging (FCM)** 프레임워크로 Android 앱에 push를 보낸다. 시작하려면 FCM for Android 기능을 활성화한 Google API 프로젝트를 만든다.
  > ⚠️ 레거시 Cloud Messaging API 사용자는 **2024년 6월까지** 새 Firebase Cloud Messaging API(**HTTP v1**)로 마이그레이션해야 한다(raw L1096).
- **Apple iOS (APNs)** — Apple Push Notification Service를 통해 발송. external client app에 iOS `.p12` 인증서를 업로드.

### Step 2. External Client App + 권한·Test Notification

OS 벤더 push 서비스에 등록한 뒤, Salesforce에서 external client app을 만든다(Android용 / Apple iOS용 각각 생성). 구성 후 **Test Push Notification** 페이지로 push 설정을 테스트한다 — 각 테스트 push는 **수신자 1명으로 제한**되며 org의 시간당 push 한도에 포함된다(raw L1728).

> external client app으로 push를 보내려면 다음 중 하나가 충족돼야 한다(raw L1102-1104): ① Apex 트리거가 external client app이 만들어진 **같은 org**에 추가됐거나, ② Apex 트리거가 external client app과 함께 **파트너 제공 관리형 패키지**로 설치됐다.

### Step 3. Mobile SDK 앱 구성

Mobile SDK 앱에서 Salesforce·기기 OS가 요구하는 push 프로토콜을 구현한다 — Android / iOS / Hybrid 앱 각각의 활성화, 알림 암호화 처리(Notification Builder는 RSA 공개키 기반 암호화 지원), 자체 In-App Notification 기능 구축.

### Step 4. Packaging (2GP)

Apex 트리거와 external client app을 고객에게 배포하려면 파트너가 **관리형 패키지(2세대)** 를 만든다.

---

## Apex Push 발송 (레거시)

OS 벤더 push 등록과 external client app 생성 후, **Apex 트리거**로 모바일 클라이언트 앱에 push를 보낼 수 있다. push 트리거는 Apex `Messaging.PushNotification`·`Messaging.PushNotificationPayload` 클래스의 메서드를 사용한다.

### 샘플 트리거 (iOS payload)

> 아래 트리거는 `Test_App`(iOS 모바일 클라이언트에 대응하는 external client app)에 push를 보낸다. Case가 update된 후 발화하며, case 소유자와 마지막 수정자 두 사용자에게 push한다. (raw L1112-1158, 실제 PDF 코드 발췌)

```apex
trigger caseAlert on Case (after update) {

    for(Case cs : Trigger.New)
    {
        // Instantiating a notification
        Messaging.PushNotification msg =
            new Messaging.PushNotification();

        // Assembling the necessary payload parameters for Apple.
        // Apple params are:
        // (<alert text>,<alert sound>,<badge count>,
        // <free-form data>)
        // This example doesn't use badge count or free-form data.
        // The number of notifications that haven't been acted
        // upon by the intended recipient is best calculated
        // at the time of the push. This timing helps
        // ensure accuracy across multiple target devices.
        Map<String, Object> payload =
            Messaging.PushNotificationPayload.apple(
                'Case ' + cs.CaseNumber + ' status changed to: '
                + cs.Status, '', null, null);

        // Adding the assembled payload to the notification
        msg.setPayload(payload);

        // Getting recipient users
        String userId1 = cs.OwnerId;
        String userId2 = cs.LastModifiedById;

        // Adding recipient users to list
        Set<String> users = new Set<String>();
        users.add(userId1);
        users.add(userId2);

        // Sending the notification to the specified app and users.
        // Here we specify the API name of the external client app.
        msg.send('Test_App', users);
    }
}
```

**Android payload** — Android는 iOS와 달리 payload에 특별한 속성·요구사항이 없고 JSON 형식이기만 하면 된다. Apex에서는 `Map<String, Object>` 객체로 만들고, `Messaging.PushNotification`이 JSON 변환을 처리한다(raw L1162-1170, 실제 PDF 코드 발췌).

```apex
Map<String, Object> androidPayload = new Map<String, Object>();
androidPayload.put('number', '1');
androidPayload.put('name', 'test');
```

### Messaging.PushNotification 클래스

push를 구성하고 Apex 트리거에서 발송하는 데 사용. **Namespace: `Messaging`**.

**생성자 (raw L1234-1264):**

| 생성자 | 시그니처 | 설명 |
|---|---|---|
| `PushNotification()` | `public PushNotification()` | `Messaging.PushNotification`의 새 인스턴스 생성. |
| `PushNotification(payload)` | `public PushNotification(Map<String,Object> payload)` | 지정한 payload(key-value 맵)로 새 인스턴스 생성. 이 생성자를 쓰면 `setPayload`를 별도로 호출할 필요 없음. |

`PushNotification(payload)`의 파라미터 `payload` — Type `Map<String, Object>`, key-value 쌍의 맵으로 표현된 payload.

**메서드 (raw L1267-1330) — 모두 global:**

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `send(application, users)` | `public void send(String application, Set<String> users)` | 지정 사용자에게 push 메시지 발송. |
| `setPayload(payload)` | `public void setPayload(Map<String,Object> payload)` | push 메시지의 payload 설정. |
| `setTtl(ttl)` | `public void setTtl(Integer ttl)` | **Reserved for future use.** |

- `send` 파라미터:
  - `application` — Type `String`. connected app API name. 알림을 보낼 모바일 클라이언트 앱에 대응.
  - `users` — Type `Set`. 알림을 받을 사용자의 user ID 집합.
- `setPayload` 파라미터:
  - `payload` — Type `Map<String, Object>`. key-value 쌍의 맵. payload 파라미터는 모바일 OS 벤더마다 다를 수 있다. Apple device용 payload 생성은 아래 `PushNotificationPayload`를 사용.
- `setTtl` 파라미터:
  - `ttl` — Type `Integer`. **Reserved for future use.**

### PushNotificationPayload 클래스

**Apple device용** 알림 메시지 payload를 만드는 메서드를 담는다. **Namespace: `Messaging`**. Apple은 payload에 특정 요구사항이 있어 이 클래스가 helper 메서드를 제공한다. 메서드는 **모두 global static**. (raw L1572-1706)

PDF는 `apple()`의 **두 오버로드**를 정의한다.

#### apple(alert, sound, badgeCount, userData) — 4-param

```apex
public static Map<String,Object> apple(String alert, String sound, Integer badgeCount,
    Map<String,Object> userData)
```

| 파라미터 | Type | 설명 |
|---|---|---|
| `alert` | String | 모바일 클라이언트에 보낼 알림 메시지. |
| `sound` | String | 알림 시 재생할 사운드 파일 이름. 모바일 앱 번들에 있어야 한다. |
| `badgeCount` | Integer | 앱 아이콘 배지로 표시할 숫자. |
| `userData` | Map<String, Object> | 알림 맥락을 제공하는 추가 데이터의 key-value 맵. 예: 알림을 유발한 레코드 ID들. 모바일 클라이언트 앱이 이 ID로 레코드를 표시할 수 있다. |

- **반환값:** `Map<String, Object>` — 지정 인자를 모두 포함한 형식화된 payload.
- **Usage:** 유효한 payload를 만들려면 `alert`, `sound`, `badgeCount` 중 **최소 하나**에 값을 줘야 한다.

#### apple(alertBody, actionLocKey, locKey, locArgs, launchImage, sound, badgeCount, userData) — 8-param

```apex
public static Map<String,Object> apple(String alertBody, String actionLocKey, String
    locKey, String[] locArgs, String launchImage, String sound, Integer badgeCount,
    Map<String,Object> userData)
```

| 파라미터 | Type | 설명 |
|---|---|---|
| `alertBody` | String | alert 메시지 텍스트. |
| `actionLocKey` | String | 값이 지정되면 **버튼 2개**가 있는 alert를 표시. 오른쪽 버튼 제목으로 쓸 `Localizable.strings` 파일의 localized string 키. |
| `locKey` | String | 현재 로케일의 `Localizable.strings` 파일 내 alert 메시지 문자열 키. |
| `locArgs` | List<String> | `locKey`의 포맷 지정자 자리에 들어갈 가변 문자열 값들. |
| `launchImage` | String | 앱 번들 내 이미지 파일 이름. |
| `sound` | String | 알림 시 재생할 사운드 파일 이름. 모바일 앱 번들에 있어야 한다. |
| `badgeCount` | Integer | 앱 아이콘 배지로 표시할 숫자. |
| `userData` | Map<String, Object> | 알림 맥락을 제공하는 추가 데이터의 key-value 맵. 예: 알림을 유발한 레코드 ID들. |

- **반환값:** `Map<String, Object>` — 지정 인자를 모두 포함한 형식화된 payload.
- **Usage:** 유효한 payload를 만들려면 `alert`, `sound`, `badgeCount` 중 **최소 하나**에 값을 줘야 한다.

---

## Connect REST — Push 발송

Apex 엔진을 거치지 않고 단순 메시지를 한 모바일 기기의 external client app에서 다른 기기로 push하려면 **Connect REST API push notification resource**를 쓴다. Salesforce 외부 이벤트를 모바일 external client app 안에서 전부 처리할 때 유용. native/hybrid Mobile SDK 앱이나 HTML5 앱 어디서든 사용 가능. (raw L1333-1391, L1550-1560)

조건:

- 보내는 앱과 받는 앱은 같은 org에서 개발되거나 같은 패키지에서 설치돼야 한다.
- **받는 앱만** Apple/Google에 push 등록이 필요하다.
- **받는 앱만** Salesforce Mobile SDK push 프로토콜 구현이 필요하다.
- 각 앱은 external client app이 필요하지만, **받는 external client app만** push용으로 구성돼야 한다.

**Push Notifications Resource:**

- **Resource:** `/connect/notifications/push`
- **Available version:** 31.0
- **HTTP methods:** POST

POST 요청 본문 Root XML tag: `<pushNotification>`. JSON 예(raw L1356-1360, 실제 PDF 발췌):

```json
{
  "appName" : "TestApp",
  "namespace" : "abc",
  "userIds" : ["005x00000013dPK", "005x00000013dPL"],
  "payload" : "{'aps':{'alert':'test', 'badge':0, 'sound':'default'}}"
}
```

**POST 속성 / 파라미터(raw L1364-1391):**

| 이름 | Type | 설명 | 필수 여부 | Version |
|---|---|---|---|---|
| `appName` | String | push를 보낼 클라이언트 앱의 API name. | Required | 31.0 |
| `namespace` | String | push를 보낼 클라이언트 앱의 namespace. | namespace가 설정된 경우 Required | 31.0 |
| `payload` | String | JSON 형식의 push payload. | Required | 31.0 |
| `userIds` | String[] | push 수신자 user ID들. | Required | 31.0 |

---

## Custom Notification Actions (invocable REST)

데스크톱 또는 모바일 채널로 커스텀 알림을 보낸다. 보내기 전에 먼저 **notification type**을 만들어야 한다. 이 object는 **API 46.0 이상**에서 사용 가능. (raw L1395-1541)

> ⚠️ Winter '21 이후 생성된 org에서는, 사용자 컨텍스트로 실행되는 flow·REST API 호출·Apex callout에서 Send Custom Notification 액션을 트리거하려면 **Send Custom Notifications 사용자 권한**이 필요하다. 시스템 컨텍스트로 실행되는 process·flow에서는 이 권한이 필요 없다.

> 🔀 **동명이의 구분:** 이 `customNotificationAction`(표준 **invocable action REST**)은 Apex의 `Messaging.CustomNotification` 클래스([[CustomNotification]])와 **다른 메커니즘**이다. 같은 "custom notification"이라는 이름이지만 호출 방식·수신자 허용 범위가 다르다.

| 구분 | `customNotificationAction` (이 노트) | `Messaging.CustomNotification` ([[CustomNotification]]) |
|---|---|---|
| 종류 | 표준 invocable action **REST** (`/actions/standard/customNotificationAction`) | **Apex 클래스** |
| 호출 | REST(GET/HEAD/POST)·Process Builder·Flow | Apex 코드 `.send(Set<String>)` |
| 수신자 | `recipientIds`: **User 외에 Account/Opportunity/Group/Queue** ID도 허용 | `send(Set<String> recipientIds)`: User ID 집합 |
| 최대 수신자 | 리스트로 최대 **500개** 값 | — |

**Supported REST HTTP Methods (raw L1413-1421):**

- **URI:** `/services/data/vXX.X/actions/standard/customNotificationAction`
- **Formats:** JSON, XML
- **HTTP Methods:** GET, HEAD, POST
- **Authentication:** `Authorization: Bearer token`

**Inputs (raw L1424-1492):**

| Input | Type | 필수 | 설명 |
|---|---|---|---|
| `actionGroup` | string | Optional | custom notification type의 action group. 모바일 push를 actionable하게 만든다. |
| `customNotifTypeId` | reference | **Required** | 사용할 Custom Notification Type의 ID. |
| `recipientIds` | reference | **Required** | 수신자 또는 수신자 타입의 ID. 아래 값 허용. 리스트로 **최대 500개**까지 결합 가능. |
| `senderId` | reference | Optional | 알림 발신자의 User ID. |
| `title` | string | **Required** | 수신자에게 보이는 알림 제목. 최대 **250자**. 모바일 push 내용은 content push notification 설정에 따른다. |
| `body` | string | **Required** | 수신자에게 보이는 알림 본문. 최대 **750자**. 모바일 push 내용은 content push notification 설정에 따른다. |
| `targetId` | reference | Optional | 알림 대상 레코드의 Record ID. `targetId` 또는 `targetPageRef` 중 하나는 지정해야 함. |
| `targetPageRef` | string | Optional | 알림 내비게이션 대상의 PageReference. `targetId` 또는 `targetPageRef` 중 하나는 지정해야 함. |

`recipientIds`가 허용하는 수신자/수신자 타입 값(raw L1442-1453):

- **UserId** — 이 사용자가 active면 해당 사용자에게 발송.
- **AccountId** — 이 account의 Account Team 멤버인 모든 active 사용자에게 발송. (org에 account team이 활성화된 경우 유효)
- **OpportunityId** — 이 opportunity의 Opportunity Team 멤버인 모든 active 사용자에게 발송. (org에 team selling이 활성화된 경우 유효)
- **GroupId** — 이 group의 멤버인 모든 active 사용자에게 발송.
- **QueueId** — 이 queue의 멤버인 모든 active 사용자에게 발송.

**GET 예시 (raw L1500-1503, 실제 PDF 발췌):**

```bash
curl --include --request GET \
--header "Authorization: Authorization: Bearer 00DR...xyz" \
--header "Content-Type: application/json" \
"https://instance.salesforce.com/services/data/v46.0/actions/standard/customNotificationAction"
```

**POST 예시 (raw L1515-1529, 실제 PDF 발췌):**

```bash
curl --include --request POST \
--header "Authorization: Authorization: Bearer 00DR...xyz" \
--header "Content-Type: application/json" \
--data '{ "inputs" :
  [
  {
    "customNotifTypeId" : "0MLR0000000008eOAA",
    "recipientIds" : ["005R0000000LSqtIAG"],
    "title" : "Custom Notification",
    "body" : "This is a custom notification.",
    "targetId" : "001R0000003fSUDIA2"
  }
  ]
}' \
"https://instance.salesforce.com/services/data/v46.0/actions/standard/customNotificationAction"
```

**응답 (raw L1532-1541, 실제 PDF 발췌):**

```json
[
    {
        "actionName" : "customNotificationAction",
        "errors" : null,
        "isSuccess" : true,
        "outputValues" : {
            "SuccessMessage" : "Your custom notification is processed successfully."
        }
    }
]
```

---

## Notifications Resources (Connect REST — 조회/관리)

알림을 조회·업데이트하고, 알림에 액션을 실행하고, 상태를 조회하고, 지원되는 알림 타입 상세·액션을 얻는다. (raw L1760-2617)

**사용 가능한 리소스 개요(raw L1773-1784):**

| Resource | 설명 |
|---|---|
| `/connect/notifications` | context user의 알림 조회. read/unread/seen/unseen 표시. |
| `/connect/notifications/notificationId` | context user의 단일 알림 조회. read/unread/seen/unseen 표시. |
| `/connect/notifications/notificationId/actionKey` | 알림에 액션 실행. |
| `/connect/notifications/status` | context user 알림의 상태 조회. |
| `/connect/notifications/types` | 지원되는 알림 타입 상세·액션 조회. |

### Notification — `/connect/notifications/notificationId`

- **Available since version:** 49.0
- **HTTP methods:** GET, PATCH

**GET 파라미터:** `trimMessages` (Boolean, Optional, 50.0) — 알림 내용을 자를지(true) 전체 반환할지(false). true면 제목 최대 120자·본문 최대 320자, false면 제목 최대 250자·본문 최대 750자. 미지정 시 기본 **true**.

**PATCH 본문** Root XML tag `<notification>`, JSON 예 `{ "read" : "true" }`. 속성/파라미터:

| 이름 | Type | 필수 | 설명 |
|---|---|---|---|
| `read` | Boolean | seen 미지정 시 Required (49.0) | 알림을 read(true)/unread(false). read=true면 seen도 됨. read=true·seen=false로 설정하면 에러. |
| `seen` | Boolean | read 미지정 시 Required (49.0) | 알림을 seen(true)/unseen(false). |

응답 본문(GET·PATCH): **Notification**.

**Notification 응답 속성(raw L1892-1949):**

| Property | Type | Filter Group / Version | 설명 |
|---|---|---|---|
| `actionGroup` | Notification Action Group | Small, 67.0 | 알림의 action group. |
| `additionalData` | String | Small, 49.0 | Reserved for future use. |
| `communityId` | String | Small, 49.0 | 알림의 Experience Cloud 사이트 ID. |
| `communityName` | String | Small, 49.0 | 알림의 Experience Cloud 사이트 이름. |
| `count` | Integer | Small, 49.0 | 알림의 총 이벤트 수. 서드파티 노출 커스텀 알림은 값이 1. |
| `id` | String | Small, 49.0 | 알림 ID. |
| `image` | String | Medium, 49.0 | 알림 연관 이미지 URL. |
| `lastModified` | String | Small, 49.0 | 알림 마지막 수정 일시. |
| `messageBody` | String | Small, 49.0 | 알림 메시지 본문. |
| `messageTitle` | String | Small, 49.0 | 알림 메시지 제목. |
| `mostRecentActivityDate` | String | Small, 49.0 | 알림의 가장 최근 활동 일시. |
| `organizationId` | String | Small, 49.0 | 알림 수신자 org ID. |
| `read` | Boolean | Small, 49.0 | read(true)/unread(false) 여부. |
| `recipientId` | String | Small, 49.0 | 알림 수신자 ID. |
| `seen` | Boolean | Small, 49.0 | seen(true)/unseen(false) 여부. |
| `target` | String | Medium, 49.0 | 알림 연관 레코드 ID. |
| `targetPageRef` | String | Medium, 50.0 | 알림 대상의 page reference. |
| `type` | String | Small, 49.0 | 알림 타입. 커스텀 알림은 custom notification type ID. |
| `url` | String | Small, 49.0 | 알림 URL. |

- **Notification Collection** — `notifications` (Notification[], Small, 49.0): 알림 컬렉션.
- **Notification Status** — `lastActivity`·`oldestUnread`·`oldestUnseen` (String, Small, 49.0, 각각 최근 활동/가장 오래된 unread/unseen 일시 또는 없으면 현재 시각), `unreadCount`·`unseenCount` (Integer, Small, 49.0).

### Notifications — `/connect/notifications`

- **Available since version:** 49.0
- **HTTP methods:** GET, PATCH

context user가 GET하면 해당 user 알림 반환. 클라이언트 앱이 GET하면 org-level 설정이 적용된, 그 앱이 구독한 타입의 커스텀 알림만 반환(예: admin이 비활성화한 타입은 제외). 서드파티(클라이언트 앱 아님)가 GET하면 desktop용으로 활성화된 타입의 커스텀 알림만 반환.

**GET 파라미터(raw L2004-2032):**

| Parameter | Type | 필수 | 설명 |
|---|---|---|---|
| `after` | String | Optional (49.0) | 이 ISO 8601 날짜 이후 발생 알림을 표시 대상으로. `before`와 함께 못 씀. |
| `before` | String | Optional (49.0) | 이 ISO 8601 날짜 이전 발생 알림. 미지정 시 기본은 현재 일시. |
| `size` | Integer | Optional (49.0) | 반환할 알림 수. 1~50. 50 초과 지정 시 50개만 반환. 미지정 시 기본 **10**. |
| `trimMessages` | Boolean | Optional (50.0) | 내용 자름 여부. true: 제목 120자·본문 320자, false: 제목 250자·본문 750자. 기본 **true**. |

**PATCH 본문** Root XML tag `<notifications>`, JSON 예 `{ "before": "2019-06-25T18:24:31.000Z", "read" : "true" }`. 속성/파라미터:

| 이름 | Type | 필수 | 설명 |
|---|---|---|---|
| `before` | String | Optional (49.0) | 이 ISO 8601 날짜 이전 알림을 표시 대상으로. 미지정 시 기본은 현재 일시. |
| `notificationIds` | String[] | Optional (49.0) | 표시할 알림 ID 최대 **50개** 리스트. `before`와 함께 못 씀. |
| `read` | Boolean | seen 미지정 시 Required (49.0) | read(true)/unread(false). read=true면 seen도 됨. read=true·seen=false면 에러. |
| `seen` | Boolean | read 미지정 시 Required (49.0) | seen(true)/unseen(false). |

응답 본문(GET·PATCH): **Notification Collection**.

### Notifications Status — `/connect/notifications/status`

- **Available since version:** 49.0
- **HTTP methods:** GET
- 응답 본문(GET): **Notification Status**.

### Notification App Setting — `/connect/notifications/app-settings/organization/notificationTypeOrId`

org의 notification **app** setting을 조회·설정·리셋. app setting 기본값은 notification type 정의·application 설정에서 옴. admin은 기본 활성화된 표준 app setting을 비활성화할 수 있으나 기본 비활성화된 것을 활성화할 수는 없다. 앱이 커스텀 app setting을 허용하면 admin이 기본 비활성화 커스텀 app setting을 활성화할 수 있다. (raw L2123-2226)

- **Available version:** 47.0
- **HTTP methods:** GET, POST, DELETE

> ℹ️ API 64.0부터 Notification App Setting Input 요청 본문이 connected app 외에 **external client app**도 지원(beta).

**파라미터/속성:**

| 이름 | Type | 필수 | 설명 |
|---|---|---|---|
| `applicationId` (GET/POST/DELETE) | String | Optional (47.0; DELETE는 40.0) | connected app 또는 external client app ID. 미지정·앱에서 호출 시 세션 앱 정보로 기본. |
| `enabled` (POST 본문/파라미터) | Boolean | Optional (47.0) | 해당 앱에 대해 알림 타입 전달 활성화(true)/비활성화(false). |

- POST 본문 Root XML tag `<notificationAppSetting>`, JSON 예 `{ "enabled":"false" }`. 응답: **Notification App Setting**.
- GET 응답: **Notification App Settings Collection**. DELETE: 기본값으로 리셋, 응답 `204: Successful Delete`.

### Notification App Settings — `/connect/notifications/app-settings/organization`

org의 notification app settings 조회. (raw L2229-2313)

- **Available version:** 47.0 (API 64.0부터 external client app 지원)
- **HTTP methods:** GET
- GET 파라미터: `applicationId` (String, Optional, 47.0). 응답: **Notification App Settings Collection**.

**Notification App Setting 속성(raw L2273-2304):**

| Property | Type | Filter Group/Version | 설명 |
|---|---|---|---|
| `applicationDevName` | String | Medium, 47.0 | 클라이언트 앱 developer name. |
| `applicationId` | String | Small, 47.0 | 클라이언트 앱 ID. |
| `applicationName` | String | Small, 47.0 | 클라이언트 앱 이름. |
| `applicationNamespace` | String | Medium, 47.0 | 관리형 패키지로 설치된 경우 클라이언트 앱 namespace. |
| `enabled` | Boolean | Small, 47.0 | 클라이언트 앱에 알림 타입 활성화(true) 여부. true면 tray에 표시. |
| `notificationLabel` | String | Small, 47.0 | 알림 표시 label. |
| `notificationTypeName` | String | Medium, 47.0 | custom notification type API name. |
| `notificationTypeNamespace` | String | Medium, 47.0 | 관리형 패키지 설치 시 custom notification type namespace. |
| `notificationTypeOrId` | String | Small, 47.0 | notification type 또는 custom notification type ID. |
| `pushEnabled` | Boolean | Small, 47.0 | 클라이언트 앱에서 해당 type push 활성화(true) 여부. |

- **Notification App Settings Collection** — `notificationAppSettings` (Notification App Setting[], Small, 47.0).

### Notification Setting — `/connect/notifications/settings/organization/notificationTypeOrId`

org의 notification setting 조회·설정·리셋. 기본값은 notification type 정의·application 설정에서 옴. admin은 기본 활성화된 setting을 비활성화할 수 있으나 기본 비활성화된 것을 활성화할 수는 없다. (raw L2317-2461)

- **Available version:** 47.0
- **HTTP methods:** GET, POST, DELETE

POST 본문 Root XML tag `<notificationTargetSetting>`, JSON 예 `{ "desktopEnabled":"false" }`. 속성/파라미터(모두 Optional):

| 이름 | Type | Version | 설명 |
|---|---|---|---|
| `desktopEnabled` | Boolean | 47.0 | desktop 전달 활성화 여부. 미지정 시 변경 안 함. |
| `emailEnabled` | Boolean | 47.0 | email 전달 활성화 여부. 미지정 시 변경 안 함. |
| `mobileEnabled` | Boolean | 47.0 | mobile 전달 활성화 여부. 미지정 시 변경 안 함. |
| `slackEnabled` | Boolean | 52.0 | **Reserved for future use.** |

- 응답 본문(GET·POST): **Notification Setting**. DELETE: 기본값으로 리셋, `204: Successful Delete`.

**Notification Setting 속성(raw L2415-2461):**

| Property | Type | Filter Group/Version | 설명 |
|---|---|---|---|
| `advancedEmailEnabled` | Boolean | Small, 67.0 | Reserved for future use. |
| `advancedSlackEnabled` | Boolean | Small, 67.0 | Reserved for future use. |
| `advancedTeamsEnabled` | Boolean | Small, 67.0 | Reserved for future use. |
| `desktopEnabled` | Boolean | Small, 47.0 | desktop 전달 활성화 여부. |
| `emailEnabled` | Boolean | Small, 47.0 | email 전달 활성화 여부. |
| `mobileEnabled` | Boolean | Small, 47.0 | mobile 전달 활성화 여부. |
| `notificationLabel` | String | Small, 47.0 | 알림 표시 label. |
| `notificationTypeName` | String | Medium, 47.0 | custom notification type API name. |
| `notificationTypeNamespace` | String | Medium, 47.0 | 관리형 패키지 설치 시 custom notification type namespace. |
| `notificationTypeOrId` | String | Small, 47.0 | notification type 또는 custom notification type ID. |
| `slackEnabled` | Boolean | Small, 52.0 | Reserved for future use. |

### Notification Settings — `/connect/notifications/settings/organization`

org의 notification settings 조회. (raw L2464-2488)

- **Available version:** 47.0
- **HTTP methods:** GET
- 응답: **Notification Settings Collection** — `notificationSettings` (Notification Setting[], Small, 47.0).

### CustomNotificationType (Tooling API)

custom notification type 정보를 저장. **API 46.0 이상**에서 사용 가능. Tooling API에서 **View Setup and Configuration** 권한 사용자에게 노출되며, 생성·편집에는 **Customize Application** 권한이 필요. (raw L2498-2615)

- **Supported Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`

**Fields:**

| Field | Type | Properties | 설명 |
|---|---|---|---|
| `CustomNotifTypeName` | string | Create, Filter, Group, idLookup, Sort, Unique, Update | notification type 이름. org 내 unique. 최대 80자. |
| `Description` | textarea | Create, Filter, Group, Nillable, Sort, Update | notification type 일반 설명. 이름과 함께 표시. 최대 255자. |
| `Desktop` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | desktop 전달 채널 활성화(true) 여부. 기본 false. |
| `DeveloperName` | string | Create, Filter, Group, Sort, Update | notification type API name. |
| `IsSlack` | boolean | **Reserved for future use.** | Reserved for future use. |
| `Language` | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | custom notification type 언어. 값은 org의 언어 값. |
| `ManageableState` | ManageableState enum | Filter, Group, Nillable, Restricted picklist, Sort | 패키지에 포함된 컴포넌트의 manageable state: beta / deleted / deprecated / deprecatedEditable / installed / installedEditable / released / unmanaged. |
| `MasterLabel` | string | Create, Filter, Group, Sort, Update | notification type label. |
| `Mobile` | boolean | Create, Defaulted on create, Filter, Group, Sort, Update | mobile 전달 채널 활성화(true) 여부. 기본 false. |
| `NamespacePrefix` | string | Filter, Group, Nillable, Sort | 관리형 패키지 설치 시 notification type namespace. |

### Notification Builder Platform Push Payloads / Invocable Actions Custom

- **Notification Builder Platform Push Payloads (raw L2618-2630):** iOS 앱은 **APNs**, Android 앱은 **FCM**으로 push 제공. 모바일 앱이 push 등록 시 RSA 공개 암호화 키를 제공하면 payload가 **암호화**돼 전송되고, 앱이 처리·복호화한다. 키를 제공하지 않으면 **비암호화** 내용으로 전송. 자세한 내용은 Mobile SDK Development Guide 참조.
- **Invocable Actions Custom (raw L2633-2634):** 정적으로 호출 가능한 커스텀 invocable action을 나타낸다. 각 action 타입의 기본 정보도 얻을 수 있다.

---

## 한도 & 디버그

### Apex Limits Functions for Push Notifications

push 사용량 정보를 얻는 `System.Limits` 클래스 함수(raw L1707-1713):

| 함수 | 반환 |
|---|---|
| `getLimitMobilePushApexCalls()` | 모바일 push에 대해 **트랜잭션당 허용되는** Apex 호출 총수. |
| `getMobilePushApexCalls()` | 현재 metering interval 동안 모바일 push가 **사용한** Apex 호출 수. |

### Push Notification Limits

> 시간당 push 한도(iOS 20,000 / Android 10,000 등)의 수치·계산 규칙은 [[Governor Limits]]에 정리돼 있다 → **본 노트에서 재작성하지 않고 위임**. 요점만: 테스트 push도 한도에 포함되고, 한도 초과 시에도 알림은 in-app 표시·REST 조회용으로는 계속 생성된다. (raw L1723-1730)

### Debug Log Events

모바일 push 서비스가 Apex 디버그 로그에 기록하는 이벤트 6종(raw L1748-1755):

- `PUSH_NOTIFICATION_INVALID_APP`
- `PUSH_NOTIFICATION_INVALID_CERTIFICATE`
- `PUSH_NOTIFICATION_INVALID_NOTIFICATION`
- `PUSH_NOTIFICATION_NO_DEVICES`
- `PUSH_NOTIFICATION_NOT_ENABLED`
- `PUSH_NOTIFICATION_SENT`

이벤트·로그 레벨·카테고리, Developer Console 사용법은 Apex Code Developer's Guide 참조.

---

## 관련 노트
- [[Messaging Namespace]]
- [[CustomNotification]]
- [[Governor Limits]]
- [[Actions API]]
- [[ConnectApi Namespace 개요]]
