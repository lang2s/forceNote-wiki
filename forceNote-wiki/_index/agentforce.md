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
| variables, 변수, 변수 3종, "@variables", linked variables, 연결 변수, system variables, "@system_variables", 시스템 변수, instructions, 인스트럭션, Reasoning Instructions, Logic Instructions, Prompt Instructions, before_reasoning, after_reasoning, 추론 전후 실행, expressions, 표현식, 조건 표현식, if else, "else if", conditional expressions, operators, 연산자, 연산자 14종, supported operators, syntax cheatsheet, 문법 치트시트, Agent Script 변수 타입 뭐 있어, "-> 와 \| 차이가 뭐야", else if 되나, after_reasoning 언제 실행돼, Agent Script 연산자 목록, 인스트럭션 종류 뭐 있어 | `Agentforce(에이전트포스)/Agent Script 레퍼런스 — 변수·인스트럭션·표현식·연산자.md` |
| patterns, 패턴, agent router, 에이전트 라우터, start_agent 라우팅, 라우팅 패턴, transitions, "@utils.transition", "transition to", 전환, 서브에이전트 전환, conditional transition, 조건 전환, required workflow, required subagent workflow, 필수 워크플로우, 필수 단계 강제, 신원확인 강제, "available when", topic selector, 토픽 선택, Agent Script 라우팅 패턴, 서브에이전트 간 이동 어떻게, start_agent 로 라우팅하는 법, 신원확인 강제 라우팅, 서브에이전트 전환 어떻게 해 | `Agentforce(에이전트포스)/Agent Script 패턴 — 라우팅·전환·필수 워크플로우.md` |
| action chaining, 액션 체이닝, 액션 순차 실행, action sequencing, 보장된 순서, conditionals, 조건, 조건문, if else, fetch data, 데이터 페치, 추론 전 데이터, fetch data before reasoning, before_reasoning, filtering, 필터링, "available when", "is None", 빈 문자열 vs None, run action, run/with/set, Agent Script 액션 여러 개 순서대로, 조건에 따라 액션 실행, 추론 전 데이터 가져오기, available when 으로 액션 숨기기, is None vs 빈 문자열 차이 | `Agentforce(에이전트포스)/Agent Script 패턴 — 액션 체이닝·조건·데이터 페치·필터링.md` |
| variables pattern, using variables effectively, 변수 효과적 사용, 변수 패턴, list variables, 리스트 변수, collection variables, 컬렉션 변수, resource references, reference resources directly, 리소스 직접 참조, system overrides, instruction overrides, 시스템 오버라이드, 인스트럭션 오버라이드, multi-turn workflows, 멀티턴 워크플로우, slot filling, 슬롯 필링, 순서 강제, Agent Script에서 변수 어떻게 써, 리스트 변수 어떻게 다뤄, 리소스를 직접 참조하는 법, 시스템 인스트럭션 덮어쓰기, 멀티턴 순서 어떻게 강제해, 슬롯 필링 어떻게 해 | `Agentforce(에이전트포스)/Agent Script 패턴 — 변수·리스트·리소스 참조·시스템 오버라이드.md` |
| metadata deploy, 메타데이터 배포, agent deploy, 에이전트 배포, sf CLI, sf project retrieve start, sf project deploy start, sf template generate project, sf org login web, package.xml, manifest, 매니페스트, Bot, BotVersion, GenAiPlannerBundle, AiAuthoringBundle, GenAiPlugin, GenAiFunction, GenAiPromptTemplate, draft committed legacy, draft 커밋 레거시, string replacement, TARGET_AGENT_USER, username 치환, 에이전트 다른 org로 이동, 샌드박스에서 프로덕션으로 에이전트 옮기기, Agent Script 메타데이터 배포 어떻게 해, 에이전트를 다른 org로 옮기는 법, package.xml 매니페스트 뭐 넣어, draft committed legacy 차이 | `Agentforce(에이전트포스)/Agent Script 메타데이터 배포 (DX·패키징).md` |
