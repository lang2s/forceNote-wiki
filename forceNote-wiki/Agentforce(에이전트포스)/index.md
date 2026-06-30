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
| [[Agent Script 개요와 언어 특성]] | Agent Script란·작성 3방식·Agentforce DX·언어 특성 9종·토큰 치트시트 | #overview |
| [[Agent Script 블록 8종 (System·Config·Subagent 등)]] | 블록 8종 목적·문법·속성·예제 전수 + Config 파라미터표 10행 | #reference |
| [[Agent Script 실행 흐름과 모델 설정]] | 3대 실행 경로(첫 요청·서브에이전트 처리·전환)·프롬프트 구성 11단계 + model_config·모델 우선순위·EinsteinHyperClassifier·model:// 식별자 | #flow #model-config |
| [[Agent Script 레퍼런스 — 액션 (apex·flow·prompt)]] | 액션 정의·target URI 3종(apex/flow/prompt)·파라미터 타입 12·Action/Output Properties·결정적 호출 | #reference #actions |
| [[Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법)]] | 툴(reasoning actions) 문법(wrap·with·set·available when)·@utils 4종(transition·setVariables·escalate·end_session)·subagent 직접 참조 | #reference #tools |
| (N5 예정) 레퍼런스 — 변수·인스트럭션·표현식·연산자·Before/After | (작성 예정) | — |
| (N6 예정) 패턴 — 라우팅·전환·필수 워크플로우 | (작성 예정) | — |
| (N7 예정) 패턴 — 액션·조건·데이터·필터 | (작성 예정) | — |
| (N8 예정) 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드 | (작성 예정) | — |
| (N9 예정) 에이전트 메타데이터 배포 (Agentforce DX) | (작성 예정) | — |

---

## 빠른 선택

- Agent Script가 처음? → [[Agent Script 개요와 언어 특성]]
- 블록 문법/속성 찾기? → [[Agent Script 블록 8종 (System·Config·Subagent 등)]]

---

## 관련 폴더

- 실행 스킬(코딩 에이전트) → [[AgentSkills(에이전트스킬)/sf-skills/index|AgentSkills(에이전트스킬)]]
- GenAi 메타데이터/Tooling sObject → [[DevOps(데브옵스)/index|DevOps(데브옵스)]]
