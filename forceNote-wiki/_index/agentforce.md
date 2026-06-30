---
tags: [index, search, navigation]
created: 2026-06-30
---

# SEARCH INDEX — Agentforce (Agent Script)

> Agentforce Agent Script — Agentforce Builder에서 agent를 정의하는 언어. 키워드 → 파일.
> 루트 라우터: `00 SEARCH_INDEX.md` · 폴더 브라우즈: `Agentforce(에이전트포스)/index.md`.
> 실행 스킬(코딩 에이전트)은 `_index/agent-skills.md` 및 refs 샤드를 참조.

## Agent Script — 언어·블록 → 파일

| 키워드 | 파일 |
|---|---|
| Agent Script, 에이전트 스크립트, agent script 언어, 언어 특성, Compiled, Declarative, determinism plus reasoning, `->`, `\|`, `@actions`, `@variables`, `{!}`, run/with/set, 들여쓰기 규칙, 표현식 if else, Agent Script가 뭐야, 에이전트 스크립트 언어 특성, `->` 와 `\|` 차이, Agentforce Builder로 에이전트 만드는 법, Agentforce DX | `Agentforce(에이전트포스)/Agent Script 개요와 언어 특성.md` |
| Agent Script blocks, 에이전트 스크립트 블록, 블록 8종, system block, config block, variables block, language block, connection block, subagent, connected_subagent, start_agent, config 파라미터, developer_name, agent_type, escalation_message, 블록 종류, Agent Script 블록 종류, config 파라미터 뭐 있어, start_agent 가 뭐야, connected subagent 베타 | `Agentforce(에이전트포스)/Agent Script 블록 8종 (System·Config·Subagent 등).md` |
| flow of control, 실행 흐름, 실행 순서, 제어 흐름, execution path, 3대 실행 경로, first request, 첫 요청, processing a subagent, 서브에이전트 처리, transition, transitioning, 전환, 서브에이전트 전환, "@utils.transition", 프롬프트 구성 11단계, prompt construction, start_agent, agent router, model_config, 모델 설정, 모델 구성, 모델 override, 모델 우선순위, model priority, EinsteinHyperClassifier, "model://", model 식별자, subagent classification, 서브에이전트 분류, Agent Script 실행 순서, 에이전트 모델 어떻게 바꿔, 서브에이전트 전환 어떻게 동작해, 실행 흐름 어떻게 돼 | `Agentforce(에이전트포스)/Agent Script 실행 흐름과 모델 설정.md` |
| actions, 액션, action target, target URI, "apex://", "flow://", "prompt://", Apex 호출, Flow 호출, prompt template 호출, parameter types, 파라미터 타입 12종, Action Properties, Output Properties, inputs, outputs, filter_from_agent, 결정적 호출, 액션 변수 저장, AgentScript에서 액션 어떻게 정의해, action target URI 뭐가 있어, apex flow prompt 호출하는 법, 액션 출력 고객에게 표시 | `Agentforce(에이전트포스)/Agent Script 레퍼런스 — 액션 (apex·flow·prompt).md` |
| tools, 툴, reasoning actions, utils, 유틸, "@utils", "@utils.transition", "transition to", setVariables, escalate, end_session, 단방향 전이, 사람에게 에스컬레이션, tool 문법, wrap, with, set, "available when", 툴 가용 조건, subagent 직접 참조, 서브에이전트 참조, AgentScript에서 툴 어떻게 정의해, "@utils 함수 뭐가 있어", 사람에게 escalate 하는 법, 변수를 LLM이 설정하게 하려면, transition과 직접참조 차이 | `Agentforce(에이전트포스)/Agent Script 레퍼런스 — 툴과 유틸 (@utils·tool 문법).md` |
