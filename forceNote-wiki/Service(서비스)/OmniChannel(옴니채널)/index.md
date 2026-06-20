---
tags: [index, service, omni-channel, 옴니채널]
created: 2026-06-20
---

# OmniChannel(옴니채널) — 로컬 인덱스

> Salesforce Service Cloud **Standard Omni-Channel** — 작업 라우팅·에이전트 프레즌스·서드파티 External Routing. (Omni-Channel Developer Guide v67.0 Summer '26)

> [!warning] **Standard Omni-Channel은 Summer '26(v67.0)으로 EOL(End of Life)에 도달했습니다.** 신규 구현은 **Enhanced Omni-Channel** 마이그레이션이 권고됩니다. 이 폴더의 객체·메타데이터·콘솔 API·External Routing은 모두 Standard Omni-Channel 기준입니다.

**상위:** [[Service(서비스)/index|Service Cloud]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]] | API 객체 24종(AgentWork·ServiceChannel·UserServicePresence·PendingServiceRouting 등)·Metadata API 타입 11종·Salesforce 콘솔 통합 컴포넌트(Lightning Console JS API + Classic Console Integration Toolkit) 레퍼런스 | #reference |
| [[Omni-Channel External Routing]] | 서드파티 라우팅 엔진 통합 — 기술 아키텍처·CDC 구독(Pub/Sub API & Apex Trigger)·AgentWork 생성·예상 동작 시나리오·트러블슈팅 | #reference |

---

## 빠른 선택

- Omni-Channel 객체·필드(AgentWork, ServiceChannel, UserServicePresence, PendingServiceRouting)가 필요할 때? → [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]]
- Omni-Channel 콘솔 메서드·이벤트(Lightning Console JS API / Console Integration Toolkit)가 필요할 때? → [[Omni-Channel 객체·메타데이터·콘솔 컴포넌트]]
- Omni-Channel을 서드파티 라우팅 엔진과 통합할 때(External Routing)? → [[Omni-Channel External Routing]]
- CDC(Pub/Sub API·Apex Trigger)로 PendingServiceRouting을 구독해 AgentWork를 생성할 때? → [[Omni-Channel External Routing]]

---

## 관련 폴더

- Service Cloud 허브 → [[Service(서비스)/index|Service Cloud]]
- 변경 데이터 캡처(CDC) 일반 → [[Apex/PlatformEvents(플랫폼이벤트)/index|PlatformEvents(플랫폼이벤트)]]
- Service Cloud 표준 Object 카탈로그 → [[Service Cloud Objects]]
