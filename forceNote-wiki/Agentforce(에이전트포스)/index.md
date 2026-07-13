---
tags: [index, agentforce, agent-script]
created: 2026-06-30
---

# Agentforce(에이전트포스) — 로컬 인덱스

> Agentforce Agent Script — Agentforce Builder에서 agent를 정의하는 언어. 개요·언어 특성·블록·실행 흐름·레퍼런스·패턴·배포.

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Agentforce 개요 — 제품·에이전트 유형·구성요소]] | 제품 오리엔테이션 — Agentforce란·에이전트 유형·Atlas Reasoning Engine·구성요소(Subagents/Actions)·Agentforce Studio/Builder·Prompt Builder 대비·에이전트 vs Flow 결정 가이드 | #overview #product-concept |
| [[Agent Script 개요와 언어 특성]] | Agent Script란·작성 3방식·Agentforce DX·언어 특성 9종·토큰 치트시트 | #overview |
| [[Agent Script 블록 8종 (System·Config·Subagent 등)]] | 블록 8종 목적·문법·속성·예제 전수 + Config 파라미터표 10행 | #reference |
| [[Agent Script 실행 흐름과 모델 설정]] | 3대 실행 경로(첫 요청·서브에이전트 처리·전환)·프롬프트 구성 11단계 + model_config·모델 우선순위·EinsteinHyperClassifier·model:// 식별자 | #flow #model-config |
| [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]] | 액션 정의·target URI 3종(apex/flow/prompt)·파라미터 타입 12·Action/Output Properties·결정적 호출 | #reference #actions |
| [[Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법)]] | 툴(reasoning actions) 문법(wrap·with·set·available when)·@utils 4종(transition·setVariables·escalate·end_session)·subagent 직접 참조 | #reference #tools |
| [[Agent Script 레퍼런스 — 변수·인스트럭션·표현식·연산자]] | 변수 3종(@variables·linked·system)·인스트럭션(Reasoning/Logic/Prompt + before/after_reasoning)·조건 표현식(if/else)·연산자 14종 + 문법 치트시트 38행 | #reference #variables #instructions #expressions #operators |
| [[Agent Script 패턴 — 라우팅·전환·필수 워크플로우]] | 에이전트 라우터(start_agent)·서브에이전트 전환(@utils.transition·조건 전환)·필수 워크플로우(신원확인 등) 강제 패턴 | #pattern #routing #transitions |
| [[Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링]] | 액션 보장 순차 실행·조건문(if/else) 결정적 제어·추론 전 데이터 페치·available when 필터링 패턴 | #pattern #actions #conditionals #fetch #filtering |
| [[Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드]] | 패턴 5종 — 변수 효과적 사용·리스트(컬렉션) 변수·리소스 직접 참조·시스템 오버라이드·멀티턴 워크플로우(슬롯 필링) 강제 | #pattern #variables #list-variables #resource-references #system-overrides #multi-turn |
| [[Agent Script 메타데이터 배포 (DX·패키징)]] | 에이전트를 다른 org로 — 메타데이터 타입 9종(Bot·BotVersion·GenAiPlannerBundle·AiAuthoringBundle 등)·draft/committed/legacy 구분·sf CLI 7단계 retrieve/deploy·매니페스트 3종·username 문자열 치환 | #deployment #metadata-api #package-xml #sf-cli |
| [[Agentforce 커스텀 Lightning Type — 에이전트 액션 입출력 UI]] | 에이전트 액션 입출력에 커스텀 LWC UI — Custom Lightning Types(lightning__AgentforceInput/Output)·Lightning Type Bundle(schema/editor/renderer.json)·componentOverrides·@apexClassType·valuechange | #reference #custom-ui |
| [[Agentforce Prompt Template 액션 — genAiPromptTemplate·Apex 그라운딩]] | 에이전트에서 프롬프트 템플릿 실행 — generatePromptResponse 액션·GenAiPromptTemplate 메타(templateVersions·templateDataProviders)·Apex data provider(InvocableMethod) 그라운딩·머지필드 | #reference #prompt-template |

---

## 빠른 선택

- Agentforce가 처음? (제품·에이전트 유형·구성요소·Atlas) → [[Agentforce 개요 — 제품·에이전트 유형·구성요소]]
- Agent Script가 처음? → [[Agent Script 개요와 언어 특성]]
- 블록 문법/속성 찾기? → [[Agent Script 블록 8종 (System·Config·Subagent 등)]]
- 에이전트 액션 입출력에 커스텀 LWC UI 붙이기? → [[Agentforce 커스텀 Lightning Type — 에이전트 액션 입출력 UI]]
- 에이전트에서 프롬프트 템플릿 실행·Apex 그라운딩? → [[Agentforce Prompt Template 액션 — genAiPromptTemplate·Apex 그라운딩]]

---

## 관련 폴더

- 실행 스킬(코딩 에이전트) → [[AgentSkills(에이전트스킬)/sf-skills/index|AgentSkills(에이전트스킬)]]
- GenAi 메타데이터/Tooling sObject → [[DevOps(데브옵스)/index|DevOps(데브옵스)]]
