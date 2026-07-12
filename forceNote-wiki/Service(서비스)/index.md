---
tags: [index, service, service-cloud]
created: 2026-06-17
---

# Service(서비스) — 도메인 허브

> Salesforce Service Cloud — 고객 서비스·지원 도메인. Knowledge(지식)·Chat(채팅, 레거시 Live Agent REST)·OmniChannel(옴니채널, Standard v67.0 EOL)·Lightning Flow for Service(Actions & Recommendations)에 더해 케이스 관리 코어(Cases·배정/에스컬레이션·큐·Email/Web-to-Case·엔타이틀먼트/마일스톤)와 상담원 도구(서비스 콘솔·매크로·Open CTI 전화 통합)를 다룬다.

**상위:** [[00 Home]]

---

## 하위 영역

| 영역 | index | 내용 |
|---|---|---|
| [[Service(서비스)/Knowledge(지식)/index|Knowledge(지식)]] | `Knowledge(지식)/index.md` | (A) 개발자/API: 데이터 모델·SOAP/REST/Metadata/UI API 9개 + (B) 어드민/셋업: Lightning Knowledge 계획·셋업·사용·리포팅·임포트·번역·데이터 카테고리 7개 = 총 16개 노트 |
| [[Service(서비스)/Chat(채팅)/index|Chat(채팅)]] | `Chat(채팅)/index.md` | Chat(레거시 Live Agent, 2026-02-14 은퇴) 총 11개 노트: (A) REST API 7개 — 개요·시작·롱폴링·세션/모니터링/방문자 리소스·요청/응답 바디·데이터 타입·상태 코드 + (B) Developer Guide 4개 — Deployment API(로깅·윈도우·버튼, 레코드 자동검색·자동초대)·Pre-Chat API·Visualforce 커스텀 윈도우/Post-Chat/Direct-to-Agent 라우팅 |
| [[Service(서비스)/OmniChannel(옴니채널)/index|OmniChannel(옴니채널)]] | `OmniChannel(옴니채널)/index.md` | Standard Omni-Channel(v67.0 Summer '26 EOL) 총 2개 노트: 객체(24)·Metadata API 타입(11)·콘솔 통합 컴포넌트(Lightning Console JS API + Console Integration Toolkit) + External Routing(서드파티 라우팅 엔진 통합 — CDC Pub/Sub·Apex Trigger·AgentWork 생성) |
| [[Lightning Flow for Service (Actions & Recommendations)]] | `Lightning Flow for Service (Actions & Recommendations).md` | Actions & Recommendations 컴포넌트로 레코드 페이지에 논리적 다음 단계(플로우·퀵액션·NBA 추천) 목록 표시 — RecordAction 정션 객체·RecordActionDeployment, deployment/Process Builder/API 연결 |

---

## 케이스 관리 & 콘솔 (Service Cloud 코어)

| 노트 | 설명 |
|---|---|
| [[Service Cloud 개요]] | (허브) Service Cloud(=Agentforce Service) 기능 맵·case lifecycle — 케이스 관리부터 콘솔·생산성 도구까지 진입점 |
| [[Cases (케이스)]] | 고객 질문/피드백/이슈를 추적하는 case 레코드 — 케이스 관리 기본 |
| [[Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)]] | 케이스 자동 배정 규칙 + 시간(business hours) 기준 에스컬레이션 규칙 |
| [[Queues (큐)]] | 레코드 공유 대기열로 워크로드 분배 — Omni-Channel 라우팅 연계 |
| [[Email-to-Case & Web-to-Case (이메일·웹 투 케이스)]] | 이메일/웹 폼 유입을 case로 자동 생성 |
| [[Entitlements & Milestones (엔타이틀먼트·마일스톤)]] | SLA 관리 — 지원 수준(엔타이틀먼트)·시간 기준 단계(마일스톤: 첫 응답/해결 시간) |
| [[Service Console (서비스 콘솔)]] | 에이전트 워크스페이스 — Lightning Service Console·유틸리티 바 |
| [[Macros (매크로)]] | 반복 작업 자동화로 상담원 생산성 향상 — 매크로 빌더 |
| [[Open CTI & Telephony (전화 통합)]] | CTI 전화 통합(소프트폰·콜센터) — 은퇴 예정, Salesforce Voice로 전환 |
| [[Messaging for In-App and Web (MIAW)]] | 은퇴한 Chat(Live Agent)의 공식 후속 채널 — 실시간+비동기 메시징(웹·인앱·WhatsApp·SMS)을 MessagingChannel·MessagingSession으로 통합 |
| [[Service Cloud Voice]] | 콘솔 네이티브 클라우드 텔레포니 — 통화·실시간 전사·AI 인사이트(Amazon Connect·Partner Telephony·BYOT·VoiceCall), Open CTI 후속 |

---

## 빠른 선택

- Knowledge 객체·API 전반(개발자) → [[Service(서비스)/Knowledge(지식)/index|Knowledge(지식)]]
- Knowledge 데이터 모델부터 시작 → [[Knowledge 데이터 모델 & API 개요]]
- Lightning Knowledge 도입·셋업·운영(어드민) → [[Lightning Knowledge 개요 — 계획·비교·한계]]
- Lightning Knowledge 활성화·권한 설정 → [[Lightning Knowledge 셋업 & 구성]]
- 아티클 작성·검색·다국어·임포트·데이터 카테고리 → [[Service(서비스)/Knowledge(지식)/index|Knowledge(지식)]] 인덱스의 "어드민/셋업" 그룹
- Chat REST API(레거시 Live Agent) 세션·롱폴링·리소스·바디 → [[Service(서비스)/Chat(채팅)/index|Chat(채팅)]]
- Chat Developer Guide(Deployment API·Pre-Chat·Visualforce 커스텀 윈도우) → [[Service(서비스)/Chat(채팅)/index|Chat(채팅)]]
- Omni-Channel 객체·메타데이터·콘솔 메서드·External Routing(서드파티 라우팅 통합) → [[Service(서비스)/OmniChannel(옴니채널)/index|OmniChannel(옴니채널)]]
- 에이전트에게 "논리적 다음 단계" 액션 목록 띄우기(Actions & Recommendations·RecordAction) → [[Lightning Flow for Service (Actions & Recommendations)]]
- Service Cloud 전체 기능 맵·case lifecycle부터 시작 → [[Service Cloud 개요]]
- 케이스 관리·자동 배정·에스컬레이션·큐 → [[Cases (케이스)]] · [[Case Assignment & Escalation Rules (케이스 배정·에스컬레이션 규칙)]] · [[Queues (큐)]]
- 이메일/웹 폼으로 케이스 자동 생성 → [[Email-to-Case & Web-to-Case (이메일·웹 투 케이스)]]
- SLA(엔타이틀먼트·마일스톤: 첫 응답/해결 시간) → [[Entitlements & Milestones (엔타이틀먼트·마일스톤)]]
- 상담원 워크스페이스·생산성(콘솔·매크로) → [[Service Console (서비스 콘솔)]] · [[Macros (매크로)]]
- 전화 통합(Open CTI·소프트폰, Salesforce Voice 전환) → [[Open CTI & Telephony (전화 통합)]]
- 실시간+비동기 고객 메시징(웹·인앱·WhatsApp·SMS, Chat/Live Agent 후속) → [[Messaging for In-App and Web (MIAW)]]
- 콘솔 네이티브 클라우드 전화·통화 전사·AI 인사이트(Amazon Connect·Open CTI 후속) → [[Service Cloud Voice]]

---

## 확장 예정 (거점)

향후 Service Cloud 노트가 추가되면 이 허브 아래 하위 폴더(예: `Case(케이스)/`, `Entitlement(엔타이틀먼트)/`, `Messaging(메시징)/`)로 편성하고, 키워드는 `_index/service.md` 샤드에 누적한다. 샤드가 상한(~300줄/12k토큰)을 넘으면 하위 샤드로 분할한다. (`OmniChannel(옴니채널)/`은 위 하위 영역에 편성 완료.)

---

## 관련 폴더

- Service Cloud 표준 Object 카탈로그 → [[Service Cloud Objects]]
