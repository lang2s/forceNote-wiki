---
tags: [admin, notification-builder, custom-notification, notification-type, setup, declarative]
source: help.salesforce.com (Salesforce Help — Notification Builder / Custom Notifications / Notification Delivery Settings; 라이브 공식 문서, Tier 2, 접속 2026-07-12)
created: 2026-07-12
aliases: [Custom Notification Type, Notification Builder, 커스텀 알림 유형, 알림 유형, Notification Delivery Settings, 알림 전달 설정, CustomNotificationType 설정]
---

# Custom Notification Types (알림 유형·Notification Builder)

> Setup의 **Notification Builder**에서 커스텀 알림 유형을 **선언적으로 정의**하고(채널·API 이름), **Notification Delivery Settings**로 유형별 전달 채널을 켜고 끄는 어드민 관점. 실제 발송 코드는 Flow/Apex 노트에 위임한다.

---

## 개요 — Notification Builder의 두 Setup 페이지

Notification Builder는 Chatter 등을 구동하는 core notifications framework와 통합된 알림 플랫폼이다. 어드민은 두 개의 Setup 페이지를 다룬다.

| Setup 페이지 | 역할 |
|---|---|
| **Custom Notifications** | 커스텀 알림 **유형(type)** 을 정의 — 이름·API 이름·지원 채널. 발송 코드가 이 유형을 ID로 참조한다. |
| **Notification Delivery Settings** | **표준·커스텀** 알림 유형별로 실제 전달 **채널(desktop/mobile/Slack)** 을 활성화·비활성화. |

> "유형을 만든다"(Custom Notifications)와 "그 유형을 어느 채널로 전달할지 설정한다"(Delivery Settings)는 별개 단계다.

---

## 1. Custom Notification Type 생성 (Setup → Notification Builder → Custom Notifications)

절차:

```
// 구조 예시 — 실제 Setup 화면 캡처 아님 (공식 절차를 텍스트로 표현)
Setup → Quick Find 상자에 "Notification Builder" 입력 → Custom Notifications 선택
  → [New] 클릭
    · Custom Notification Name  : 표시 이름
    · API Name                  : 발송 코드/Flow가 참조하는 고유 개발자 이름
    · Supported Channels        : Desktop / Mobile (하나 이상 선택)
  → [Save]
```

**지원 채널(Supported Channels):** Desktop, Mobile, 또는 둘 다 선택할 수 있다.

| 채널 | 동작 |
|---|---|
| **Desktop** | 데스크톱 알림 트레이(bell 아이콘)로 알림 전송. |
| **Mobile** | 활성화된 지원 앱으로 **in-app + push** 알림 전송. Mobile 채널을 켜면 **Notification Delivery Settings에서 지원 앱을 반드시 활성화**해야 한다. |

**한도:** 한 org당 최대 **500개**의 커스텀 알림 유형을 만들 수 있다.

---

## 2. 발송 방법 (유형을 정의한 뒤 트리거)

커스텀 알림 유형은 **선언적으로 만들지만 발송은 자동화/코드**로 한다. 발송 경로:

| 발송 방법 | 요약 | 상세 |
|---|---|---|
| **Flow — Send Custom Notification 액션** | Flow Builder의 core action. 코드 없이 트리거. | 아래 구조 참조 |
| **Apex — `Messaging.CustomNotification`** | Apex 클래스로 발송. | 발송 코드 상세는 [[CustomNotification]] 위임 |
| **Invocable Action API / Process Builder** | REST invocable action 또는 (레거시) Process Builder | — |

### Flow "Send Custom Notification" 액션 파라미터

```
// 구조 예시 — 실제 동작 Flow 아님 (액션 입력 파라미터 구조)
Send Custom Notification (Core Action)
  · Custom Notification Type ID : CustomNotificationType 레코드의 Id (Get Records로 조회)
  · Notification Title          : 제목 텍스트/리소스
  · Notification Body           : 본문 텍스트/리소스
  · Target Id                   : 클릭 시 이동할 레코드 Id
  · Recipient Ids               : 수신자 Id 컬렉션 (Text Collection 변수)
```

**대상(수신자, Recipient Ids):** 컬렉션에 넣는 Id로 여러 유형을 혼합할 수 있다.

- 개별 **사용자**(User Id)
- **그룹**/큐(Public Group·Queue Id) — 확장되어 소속 사용자에게 전달
- **레코드 소유자**(record owner) 등 레코드 관련 사용자 Id

> Recipient Ids는 하드코딩이 아니라 **Collection 변수 + Assignment 요소**로 채운 뒤 액션에 넘긴다.

---

## 3. Notification Delivery Settings (Setup → Notification Builder → Notification Delivery Settings)

표준 알림과 커스텀 알림 유형 **모두**의 전달 채널을 관리한다.

```
// 구조 예시 — 실제 Setup 화면 아님
Setup → Quick Find "Notification Builder" → Notification Delivery Settings
  → (org에서 사용 가능한 알림 유형만 목록에 표시)
  → 유형 선택 → 드롭다운에서 [Edit]
    · Desktop / Mobile : 전달 채널(또는 mobile delivery 앱) 선택
    · Slack            : Slack 전달 채널 활성/비활성
```

핵심 동작:

- **표준·커스텀 유형 공통.** 목록에는 해당 org에서 사용 가능한 알림 유형만 나온다.
- **채널 비활성화 = 전달 일시중지.** 채널을 끄면 전달이 멈추지만, 트리거될 때 **알림 자체는 여전히 생성·저장**된다(나중에 채널을 다시 켜면 재개).
- **채널이 목록에 있으나 unavailable**로 표시되면, **Custom Notifications**(1번 페이지)에서 해당 채널(Desktop/Mobile)을 지원 채널로 켜야 활성화된다.
- Mobile 채널을 쓰려면 여기서 **지원 앱(mobile delivery apps)** 을 활성화한다.

---

## 4. 고려사항·한도 (Considerations)

| 항목 | 값 |
|---|---|
| 커스텀 알림 유형 최대 개수 | 500개 / org |
| 알림당 최대 수신자 | 10,000명 (그룹·큐·팀 확장 후 기준) |
| 시간당 알림 액션 실행 한도 | 10,000회 / org·시간 (초과 시 그 시간 미발송분은 손실) |
| 데스크톱 실시간 동시 전달 | 동시 로그인 최대 1,000명에게 실시간 전달 |
| 알림 보관 | 최근 100만 건까지 트레이 조회용 보관 |
| 데스크톱 제목 표시 한도 | 최대 120자 |
| 데스크톱 본문 표시 한도 | 최대 320자 (초과분은 말줄임표(…)로 절단) |

> 위 제목/본문 수치는 **데스크톱 렌더링 표시 한도**다. Apex `Messaging.CustomNotification`의 필드 setter 한도(제목 250·본문 750)와는 층위가 다르다 — 자세한 발송측 한도는 [[CustomNotification]] 참조.

---

## 관련 노트

- [[CustomNotification]] — 발송측 Apex 클래스 `Messaging.CustomNotification`(setter·send·ActionGroup). 이 노트가 정의한 유형을 코드로 발송하는 쪽.
- [[Mobile Notifications]] — Notification Builder vs Apex 두 알림 시스템·모바일 push/in-app 구현·`customNotificationAction` invocable 레퍼런스.
- [[Flow — 선언적 자동화 개요 (플로우)]] — Send Custom Notification은 Flow core action. Flow 기반 선언적 발송의 상위 맥락.
- [[Public Groups (공개 그룹)]] — Recipient Ids에 넣는 그룹/큐 수신자 정의.
