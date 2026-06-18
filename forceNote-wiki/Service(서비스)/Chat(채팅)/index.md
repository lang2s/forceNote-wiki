---
tags: [index, service, chat, chat-rest, 채팅]
created: 2026-06-18
---

# Chat(채팅) — 로컬 인덱스

> Salesforce **Chat REST API**(레거시 Live Agent) 위키 — chat_rest 가이드 기반 개요·시작·롱폴링·리소스·요청/응답 바디·데이터 타입·상태 코드 7개 노트.

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며 **Messaging for In-App and Web**으로 이전하세요. 이 노트들은 마이그레이션·이력 참조용입니다.

**상위:** [[Service(서비스)/index|Service Cloud]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Chat REST API 개요 & 시작]] | Chat REST 개요·세션 시작/확인/종료 흐름·모든 요청 헤더 (Ch1-3) — 진입 허브 | #overview |
| [[Chat REST API 메시지 롱폴링 & 대기시간]] | long polling 루프·Messages 폴링 패턴·Estimated Wait Time (Beta) (Ch4-5) | #howto |
| [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]] | SessionId·ChasitorInit·ReconnectSession·ChasitorResyncState — 세션 생성·방문자 세션 리소스 (Ch6 grp1-2) | #reference |
| [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]] | Monitor Chat Activity 9개 리소스 + Messages 응답 객체 14종 (Ch6 grp3) | #reference |
| [[Chat REST API 리소스 — 방문자 경험 커스터마이즈]] | Settings·Availability·Breadcrumb·VisitorId·SensitiveDataRuleTriggered ×2 — 방문자 경험 커스터마이즈 리소스 (Ch6 grp4) | #reference |
| [[Chat REST API 요청 & 응답 바디]] | 요청 바디 9종(Ch7) + 응답 바디 19종(Ch8) 필드 전수 | #reference |
| [[Chat REST API 데이터 타입 & 상태 코드]] | 데이터 타입 11종(Ch9) + HTTP 상태 코드 10종(Ch10) | #reference |

---

## 빠른 선택

- 처음 시작 / Chat REST 흐름·요청 헤더 큰 그림 → [[Chat REST API 개요 & 시작]]
- 메시지 폴링 루프·예상 대기시간 → [[Chat REST API 메시지 롱폴링 & 대기시간]]
- 세션 생성(SessionId)·방문자 세션 초기화(ChasitorInit)·재연결 → [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]]
- 모니터링 리소스·Messages 응답 객체(ChatMessage·ChatEnd 등) → [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]]
- 가용성·Settings·Breadcrumb·민감데이터 규칙 → [[Chat REST API 리소스 — 방문자 경험 커스터마이즈]]
- 요청/응답 바디 필드 찾을 때 → [[Chat REST API 요청 & 응답 바디]]
- 데이터 타입·HTTP 상태 코드 → [[Chat REST API 데이터 타입 & 상태 코드]]

---

## 관련 폴더

- 서비스 도메인 허브 → [[Service(서비스)/index|Service Cloud]]
- 후속(권장 이전 대상) Messaging → (위키 미작성)
