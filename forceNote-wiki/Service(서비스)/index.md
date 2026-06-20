---
tags: [index, service, service-cloud]
created: 2026-06-17
---

# Service(서비스) — 도메인 허브

> Salesforce Service Cloud — 고객 서비스·지원 도메인. 현재는 Knowledge(지식)·Chat(채팅, 레거시 Live Agent REST)·OmniChannel(옴니채널, Standard v67.0 EOL)·Lightning Flow for Service(Actions & Recommendations)를 다루며, 향후 Case·Entitlement·Messaging 등으로 확장되는 거점이다.

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

---

## 확장 예정 (거점)

향후 Service Cloud 노트가 추가되면 이 허브 아래 하위 폴더(예: `Case(케이스)/`, `Entitlement(엔타이틀먼트)/`, `Messaging(메시징)/`)로 편성하고, 키워드는 `_index/service.md` 샤드에 누적한다. 샤드가 상한(~300줄/12k토큰)을 넘으면 하위 샤드로 분할한다. (`OmniChannel(옴니채널)/`은 위 하위 영역에 편성 완료.)

---

## 관련 폴더

- Service Cloud 표준 Object 카탈로그 → [[Service Cloud Objects]]
