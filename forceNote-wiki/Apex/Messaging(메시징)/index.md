---
tags: [index, apex, messaging, email, notification]
created: 2026-05-17
---

# Messaging(메시징) — 로컬 인덱스

> Apex Messaging namespace — 이메일 발송, 커스텀 알림, Inbound Email 처리

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[SingleEmailMessage]] | Apex에서 단일 이메일 발송 — setToAddresses, setHtmlBody, setTemplateId | #reference |
| [[CustomNotification]] | Apex에서 커스텀 인앱 알림 발송 — setNotificationTypeId, send() | #reference |
| [[Messaging Namespace]] | Messaging 전체 클래스 레퍼런스 — InboundEmailHandler, ActionableNotification | #reference |
| [[Mobile Notifications]] | 모바일 push/in-app 알림 — Notification Builder vs Apex(레거시) 두 시스템, PushNotification/Payload, customNotificationAction, APNs/FCM 등록 | #reference |

---

## 빠른 선택

- Apex에서 이메일을 보내야 할 때? → [[SingleEmailMessage]]
- 사용자에게 인앱 알림을 보내야 할 때? → [[CustomNotification]]
- 모바일 앱에 푸시/인앱 알림(Notification Builder·Apex·APNs/FCM)을 보내야 할 때? → [[Mobile Notifications]]
- 수신 이메일을 Apex로 처리해야 할 때? → [[Messaging Namespace]] (InboundEmailHandler)
- Messaging 전체 클래스 목록이 필요할 때? → [[Messaging Namespace]]

## 관련 폴더

이벤트 기반 알림 → [[Apex/PlatformEvents(플랫폼이벤트)/index|PlatformEvents(플랫폼이벤트)]] | 통합 패턴 → [[Integration(통합)/통합 MOC]]
