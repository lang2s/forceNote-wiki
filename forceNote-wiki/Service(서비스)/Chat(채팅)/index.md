---
tags: [index, service, chat, chat-rest, 채팅]
created: 2026-06-18
---

# Chat(채팅) — 로컬 인덱스

> Salesforce **Chat**(레거시 Live Agent) 위키 — 총 11개 노트. (A) chat_rest 기반 방문자측 **REST API** 7개 + (B) chat_dev_guide 기반 **Developer Guide**(Deployment API·Pre-Chat·Visualforce 커스텀 윈도우) 4개.

> [!warning] 레거시 Chat 제품은 2026년 2월 14일 은퇴했습니다. 신규 채널 구현은 권장되지 않으며 **Messaging for In-App and Web**으로 이전하세요. 이 노트들은 마이그레이션·이력 참조용입니다.

**상위:** [[Service(서비스)/index|Service Cloud]] → [[00 Home]]

---

## 파일 목록

### (A) Chat REST API — 방문자측 (chat_rest, ING-13a) — 7

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Chat REST API 개요 & 시작]] | Chat REST 개요·세션 시작/확인/종료 흐름·모든 요청 헤더 (Ch1-3) — 진입 허브 | #overview |
| [[Chat REST API 메시지 롱폴링 & 대기시간]] | long polling 루프·Messages 폴링 패턴·Estimated Wait Time (Beta) (Ch4-5) | #howto |
| [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]] | SessionId·ChasitorInit·ReconnectSession·ChasitorResyncState — 세션 생성·방문자 세션 리소스 (Ch6 grp1-2) | #reference |
| [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]] | Monitor Chat Activity 9개 리소스 + Messages 응답 객체 14종 (Ch6 grp3) | #reference |
| [[Chat REST API 리소스 — 방문자 경험 커스터마이즈]] | Settings·Availability·Breadcrumb·VisitorId·SensitiveDataRuleTriggered ×2 — 방문자 경험 커스터마이즈 리소스 (Ch6 grp4) | #reference |
| [[Chat REST API 요청 & 응답 바디]] | 요청 바디 9종(Ch7) + 응답 바디 19종(Ch8) 필드 전수 | #reference |
| [[Chat REST API 데이터 타입 & 상태 코드]] | 데이터 타입 11종(Ch9) + HTTP 상태 코드 10종(Ch10) | #reference |

### (B) Chat Developer Guide — Deployment/Pre-Chat/Visualforce (chat_dev_guide, ING-36) — 4

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼]] | Developer Guide 개요 + Deployment API: enableLogging·showWhenOnline/Offline·startChat·addButtonEventHandler·setChatWindowHeight — 로깅·윈도우·버튼 제어 | #overview #reference |
| [[Deployment API — 레코드 자동 검색·생성·자동 채팅 초대 & 코드 샘플]] | findOrCreate·doKnowledgeSearch·addCustomDetail — 레코드 자동 검색/생성·자동 채팅 초대 + 코드 샘플 | #howto #reference |
| [[Pre-Chat API — 방문자 정보 수집 & 컨텍스트 설정]] | doFind·isExactMatch·doCreate·displayToAgent·preChatInit·detailCallback — 채팅 시작 전 방문자 정보 수집·컨텍스트 설정 | #howto #reference |
| [[커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅]] | liveAgent VF 컴포넌트(clientChatMessages 등)로 커스텀 채팅 창·post-chat 페이지(disconnectedBy)·direct-to-agent/fallback 라우팅(domainMatcher) | #howto #reference |

---

## 빠른 선택

**REST API (방문자측)**
- 처음 시작 / Chat REST 흐름·요청 헤더 큰 그림 → [[Chat REST API 개요 & 시작]]
- 메시지 폴링 루프·예상 대기시간 → [[Chat REST API 메시지 롱폴링 & 대기시간]]
- 세션 생성(SessionId)·방문자 세션 초기화(ChasitorInit)·재연결 → [[Chat REST API 리소스 — 세션 생성 & 방문자 세션]]
- 모니터링 리소스·Messages 응답 객체(ChatMessage·ChatEnd 등) → [[Chat REST API 리소스 — 채팅 모니터링 & Messages 응답 객체]]
- 가용성·Settings·Breadcrumb·민감데이터 규칙 → [[Chat REST API 리소스 — 방문자 경험 커스터마이즈]]
- 요청/응답 바디 필드 찾을 때 → [[Chat REST API 요청 & 응답 바디]]
- 데이터 타입·HTTP 상태 코드 → [[Chat REST API 데이터 타입 & 상태 코드]]

**Developer Guide (Deployment/Pre-Chat/VF)**
- Deployment API 로깅·윈도우·버튼 제어 → [[Chat 개발자 가이드 개요 & Deployment API — 로깅·윈도우·버튼]]
- 레코드 자동 검색·생성·자동 채팅 초대 + 코드 샘플 → [[Deployment API — 레코드 자동 검색·생성·자동 채팅 초대 & 코드 샘플]]
- Pre-Chat 폼으로 방문자 정보 수집·컨텍스트 설정 → [[Pre-Chat API — 방문자 정보 수집 & 컨텍스트 설정]]
- Visualforce로 커스텀 채팅 창·post-chat·direct-to-agent/fallback 라우팅 → [[커스텀 Chat 윈도우(Visualforce) · Post-Chat · Direct-to-Agent 라우팅]]

---

## 관련 폴더

- 서비스 도메인 허브 → [[Service(서비스)/index|Service Cloud]]
- 후속(권장 이전 대상) Messaging → (위키 미작성)
