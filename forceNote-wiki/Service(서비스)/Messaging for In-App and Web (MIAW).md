---
tags: [service-cloud, messaging, miaw, enhanced-messaging, channel, omni-channel]
source: help.salesforce.com + developer.salesforce.com (Messaging Object Model / MessagingChannel Metadata / Reimagine MIAW; 라이브 공식 문서, Tier 2, 접속 2026-07-12)
created: 2026-07-12
aliases: [MIAW, Messaging for In-App and Web, Enhanced Messaging, Enhanced Chat, MessagingChannel, MessagingSession, MessagingEndUser, 인앱 웹 메시징, 메시징 채널, WhatsApp 채널, Chat 후속, Live Agent 후속]
---

# Messaging for In-App and Web (MIAW)

> 은퇴한 **Chat(Live Agent, 2026-02-14 은퇴)**의 공식 후속 채널. **실시간 + 비동기** 고객 메시징을 하나의 세션으로 다루는 **Enhanced Messaging** 기반이며, 웹 임베디드·모바일 인앱·WhatsApp·SMS·Facebook·Apple 등 다채널을 `MessagingChannel`·`MessagingSession`·`MessagingEndUser` 객체로 통합 관리한다.

> [!note] Setup 라벨 캐비엇 (2026-07-12)
> Salesforce Help가 이 기능을 **"Enhanced Chat" / "Enhanced Messaging"**으로 리브랜딩하는 중이라, Setup·문서의 UI 라벨(예: "Messaging Settings" ↔ "Enhanced Chat")이 org 버전에 따라 다를 수 있다. 아래 절차·라벨은 접속 시점(2026-07-12) 기준이며, 실제 Setup에서 최신 라벨을 확인한다.

---

## 개념 — MIAW란 무엇인가

**Messaging for In-App and Web(MIAW)**는 고객이 웹사이트·모바일 앱·서드파티 메시징 앱을 통해 상담원(또는 봇/Agentforce)과 **대화형 메시징**을 하도록 하는 Service Cloud 채널이다.

| 구분 | 레거시 Chat (Live Agent, 은퇴) | MIAW (Enhanced Messaging) |
|---|---|---|
| 대화 방식 | **동기(실시간) only** — 창을 닫으면 세션 종료 | **실시간 + 비동기** — 나중에 다시 이어서 대화 가능 |
| 세션 지속성 | 세션 단발 | `MessagingSession`으로 지속·재개 |
| 채널 | 웹 채팅 위주 | 웹·인앱·WhatsApp·SMS·Facebook·Apple·LINE 등 다채널 |
| 라우팅 | Live Agent / Omni-Channel | **Omni-Channel**(Flow·Queue) 통합 |
| 데이터 모델 | Chasitor/Visitor 세션 개념 | `MessagingChannel`·`MessagingSession`·`MessagingEndUser` 표준 객체 |
| 상태 | 2026-02-14 은퇴, 유지보수 종료 | 권장 후속 채널 |

레거시 Chat 사용자는 서비스 중단을 피하기 위해 MIAW로 **마이그레이션**하도록 공식 안내된다(레거시 Chat 노트의 은퇴 경고 참조).

---

## 채널 유형 (Channel Types)

메시징 채널은 `MessagingChannel` 메타데이터 타입의 **`messagingChannelType`** enum으로 구분된다(Metadata API Developer Guide 기준):

| `messagingChannelType` 값 | 채널 | 최초 API 버전 |
|---|---|---|
| `EmbeddedMessaging` | 웹 임베디드 메시징 / 인앱(모바일 SDK) | (기본) |
| `Text` | SMS / 텍스트 메시징 | (기본) |
| `WhatsApp` | WhatsApp | 65.0+ |
| `Facebook` | Facebook Messenger | 65.0+ |
| `AppleMessagesForBusiness` | Apple Messages for Business | 65.0+ |
| `Line` | LINE | 65.0+ |
| `Custom` | 커스텀 채널 | 61.0+ |
| `Voice` | 음성 | 58.0+ |
| `PstnVoice` / `SipVoice` / `WhatsAppVoice` | 음성(PSTN·SIP·WhatsApp 음성) | 65.0+ |

> [!warning] 서드파티 채널 셋업 주의
> 공식 문서 노트: **"Third-party Messaging channels in Salesforce, such as WhatsApp and Facebook Messenger, don't use this metadata type."** — WhatsApp·Facebook 등 서드파티 채널은 `MessagingChannel` 메타데이터로 직접 만들지 않고, 각 채널 전용 셋업(계정 연동·Setup 마법사)을 거친다. 제품 레벨에서 흔히 소개되는 채널: **In-App(모바일 SDK)·Web(임베디드 메시징)·WhatsApp·Text/SMS·Facebook Messenger·Apple Messages for Business·LINE**.

---

## 데이터 모델 (Messaging Object Model)

MIAW 대화는 아래 표준 객체로 저장된다(Messaging Object Model, developer.salesforce.com):

```text
// 구조 예시 — 실제 원본 다이어그램 아님 (객체 관계 요약)
MessagingChannel  (채널: SMS 번호·WhatsApp·임베디드 등)   ── v40.0+
   └─ MessagingEndUser (MEU)  (채널당 한 명의 종단 사용자 주소)  ── v40.0+
        └─ MessagingSession   (한 채널에서의 메시징 세션)          ── v47.0+
             ├─ MessagingSessionMetrics (응답시간·메시지 수 등 KPI)
             └─ Conversation → ConversationEntry (개별 메시지/이벤트, 오프플랫폼)
                  └─ (ConversationParticipant / Participant — 개발자는 보통 MEU 사용)
```

| 객체 | 표현하는 것 | API 버전 |
|---|---|---|
| `MessagingChannel` | 종단 사용자가 상담원에게 메시지를 보내는 통신 채널(SMS 번호·Facebook 페이지 등) | 40.0+ |
| `MessagingSession` | 메시징 채널에서 발생한 종단 사용자와의 세션. **Messaging Sessions 탭**에서 관리 | 47.0+ |
| `MessagingEndUser` (MEU) | 하나의 채널과 통신하는 단일 주소(전화번호·Facebook 페이지 등). 채널당 MEU 1개 | 40.0+ |
| `MessagingSessionMetrics` | Enhanced 메시징 세션 KPI(평균 응답시간·메시지 수). 리포팅용 | — |
| `Conversation` | 특정 메시징 사용자·채널이 관여한 하나 이상의 세션/음성콜 묶음. 개발자 직접 접근 드묾 | — |
| `ConversationEntry` | 상담원/봇과 종단 사용자 간 메시지·이벤트. **오프플랫폼**(실시간 성능용 별도 DB) 저장 | — |
| `Participant` / `ConversationParticipant` | 대화 참여자·참여 인스턴스. 개발자는 보통 `MessagingEndUser`를 대신 사용 | — |

> 개발자·관리자는 실무에서 `ConversationParticipant` 대신 **`MessagingEndUser`**, `Conversation` 대신 **`MessagingSession`**을 다룬다(공식 권장).

---

## 설정 절차 (Setup)

MIAW를 켜는 대표 흐름(Prepare a Salesforce Org for MIAW 기준):

1. **Omni-Channel 활성화** — MIAW 라우팅의 전제. Setup에서 Omni-Channel Settings 활성화. (라우팅 상세는 실재 Omni-Channel 노트로 위임 → 아래 관련 노트)
2. **Messaging Settings(= Enhanced Chat) 활성화** — 조직 레벨에서 메시징 기능 켜기.
3. **Messaging Channel 생성** — 채널 유형 선택(임베디드/SMS 등). 서드파티(WhatsApp·Facebook 등)는 각 전용 셋업으로 계정 연동.
4. **Embedded Service Deployment 구성**(웹/인앱) — 웹사이트·모바일 앱에 메시징 위젯을 배포하는 배포 설정. `EmbeddedMessaging` 채널과 연결.
5. **Omni-Channel 라우팅 연결** — 채널의 세션 핸들러(`sessionHandlerType`)를 **Queue·Flow·User·AgentforceServiceAgent** 중 하나로 지정해 들어온 세션을 라우팅.
6. **사용자 접근 부여** — 상담원에게 권한 세트로 Messaging 접근 부여, `MessagingSession`/`MessagingEndUser` 탭·객체 접근 설정.

### `MessagingChannel` 메타데이터 주요 필드

`MessagingChannel` 메타데이터 타입(Metadata API Developer Guide):

```xml
<!-- 구조 예시 — 실제 동작 설정 아님 (MessagingChannel 메타데이터 필드 구성) -->
<MessagingChannel xmlns="http://soap.sforce.com/2006/04/metadata">
    <masterLabel>Web Support</masterLabel>            <!-- 필수: 채널 라벨 -->
    <messagingChannelType>EmbeddedMessaging</messagingChannelType> <!-- 필수: 채널 유형 enum -->
    <sessionHandlerType>Flow</sessionHandlerType>     <!-- 필수: Queue|Flow|User|AgentforceServiceAgent -->
    <sessionHandlerQueue>Support_Queue</sessionHandlerQueue> <!-- 라우팅 큐 -->
    <sessionHandlerFlow>Route_Messaging</sessionHandlerFlow> <!-- 폴백/라우팅 Flow -->
    <description>Embedded web messaging channel</description>
</MessagingChannel>
```

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `masterLabel` | string | Yes | 채널 라벨 |
| `messagingChannelType` | MessagingChannelType(enum) | Yes | 채널 유형(위 표) |
| `sessionHandlerType` | enum | Yes | 라우팅 방식: `Queue`·`Flow`·`User`·`AgentforceServiceAgent` |
| `sessionHandlerQueue` | string | Yes | 메시지 라우팅 큐 |
| `sessionHandlerFlow` | string | No | 라우팅/폴백 Flow |
| `description` | string | No | 채널 설명 |

---

## 인용 출처 (Tier 2)

- Messaging Object Model — https://developer.salesforce.com/docs/service/messaging-object-model/guide/messaging-object-model.html
- MessagingChannel (Metadata API) — https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_messagingchannel.htm
- MessagingChannel / MessagingSession / MessagingEndUser (Object Reference) — https://developer.salesforce.com/docs/atlas.en-us.object_reference.meta/object_reference/sforce_api_objects_messagingchannel.htm
- Messaging for In-App and Web / Prepare Org — https://help.salesforce.com/s/articleView?id=sf.reimagine_miaw.htm · https://help.salesforce.com/s/articleView?id=sf.miaw_prepare_org_1.htm

---

## 관련 노트
- [[Chat REST API 개요 & 시작]] — 은퇴한 레거시 Chat(Live Agent)과 MIAW 마이그레이션 안내
- [[Service Cloud 개요]] — MIAW가 속한 Service(Agentforce Service) 기능 맵 허브
- [[Omni-Channel 라우팅 유형 — Queue 기반 vs Skills 기반]] — MIAW 세션 라우팅(Queue/Skills) 상세
- [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]] — 라우팅 객체·메타데이터·콘솔 연동
