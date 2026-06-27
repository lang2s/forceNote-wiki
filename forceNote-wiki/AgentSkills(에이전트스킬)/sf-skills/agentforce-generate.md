---
tags: [agent-skill, sf-skills, agentforce, agent-script, aiAuthoringBundle, agent-spec]
source: forcedotcom/sf-skills (skills/agentforce-generate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [agentforce-generate, Agent Script 스킬, 에이전트 작성·배포, .agent 파일, AiAuthoringBundle, subagent FSM, Agent Spec]
---

# agentforce-generate — Agent Script 작성·수정·디버그·배포

> Atlas Reasoning Engine 위에서 차세대 AI 에이전트를 작성하는 Salesforce 스크립팅 언어 Agent Script로 에이전트를 build/modify/debug/deploy한다. `.agent` 파일(AiAuthoringBundle) 작성, 검증, preview, publish, activate의 전체 라이프사이클을 다룬다.

---

## 목적과 활성화 조건

`metadata.version: 1.0` · `compatibility: Requires Agentforce license, API v66.0+, Einstein Agent User`

**description (원문 인용):** *"Build, modify, debug, and deploy agents with Agentforce Agent Script. TRIGGER when: user creates, modifies, or asks about .agent files or aiAuthoringBundle metadata; changes agent behavior, responses, or conversation logic; designs agent actions, tools, subagents, or flow control; writes or reviews an Agent Spec; previews, debugs, deploys, publishes, or tests agents; uses Agent Script CLI commands (sf agent generate/preview/publish/test)."*

**DO NOT TRIGGER:** Apex 개발, Flow 빌딩, Prompt Template 작성, Experience Cloud 설정, Agent Script 무관 일반 Salesforce CLI 작업.

> **⚠️CRITICAL:** Agent Script는 AppleScript·JavaScript·Python 등 어떤 언어도 아니다. 2025년 도입, 어떤 AI 모델에도 training data가 없다. Agent Script 구문·의미를 학습된 다른 언어와 혼동하지 말 것. 에이전트는 `AiAuthoringBundle` 메타데이터(= Agent Script 소스를 담은 `.agent` 파일 + `bundle-meta.xml`)로 정의되며, utterance를 subagent로 routing해 처리한다.

---

## 항상 적용되는 규칙 (Rules That Always Apply)

1. **Always `--json`.** 모든 `sf` CLI 명령에 `--json` 포함. `jq`·`2>/dev/null` 파이프 금지 — full JSON 직접 read.
2. **Verify target org.** org 상호작용 전 `sf config get target-org --json`로 확인. 없으면 사용자에게 `sf config set target-org <alias>` 요청.
3. **Diagnose before you fix.** 검증/디버그 시 ALWAYS `--use-live-actions`로 authoring bundle preview. utterance 보내고 session trace 읽어 동작을 grounding. trace는 subagent 선택·action I/O·LLM reasoning을 드러냄. 이 grounding 없이 `.agent`/backing logic 수정 금지.
4. **Spec approval is a hard gate.** Agent Spec 생성 후 명시적 user 승인 없이 진행 금지.

---

## 워크플로 / 단계 (Task Domains)

각 도메인의 **Required Steps**는 순서대로 verbatim 따른다. 핵심 CLI 라이프사이클(generate → validate → preview → publish → activate):

```bash
sf agent generate authoring-bundle --json --no-spec --name "<Label>" --api-name <Developer_Name>
sf agent validate authoring-bundle --json --api-name <Developer_Name>
sf agent preview start  --json --use-live-actions --authoring-bundle <Developer_Name>
sf agent preview send   --json --authoring-bundle <Developer_Name> --session-id <ID> -u "<message>"
sf agent publish  authoring-bundle --json --api-name <Developer_Name>
sf agent activate --json --api-name <Developer_Name>
sf agent preview start --json --api-name <Developer_Name>   # activation 후 검증: --api-name 사용
```

### Create an Agent (신규 에이전트, ALWAYS Agent Script)
1. **Design** — Agent Spec 초안. 기존 backing logic 스캔 여부 항상 질문. 스캔 시 `sfdx-project.json`→package dir, 각 dir에서 `classes/`의 `@InvocableMethod`·`flows/`의 `AutoLaunchedFlow`·`promptTemplates/`의 template metadata 검색. 매치=`EXISTS`, 미매치 action=`NEEDS STUB`. `objects/`의 `.object-meta.xml`로 커스텀 객체 발견. **Agent Spec은 항상 파일로 저장.**
2. **STOP for user approval** — Agent Spec 승인 없이 진행 금지.
3. **Validate environment prerequisites** — agent type별: **Employee agent**는 config 블록에 `default_agent_user`·`connection messaging:`·MessagingSession 연결 변수 없어야(있으면 제거); **Service agent**는 org에서 Einstein Agent User 쿼리, 없으면 생성 안내.
4. **Generate authoring bundle** — `sf agent generate authoring-bundle --json --no-spec --name "<Label>" --api-name <Developer_Name>`
5. **Write code** — Core Language reference로 생성된 `.agent` 편집. `.agent`/`bundle-meta.xml` 수동 생성 금지.
6. **Validate compilation** — `sf agent validate authoring-bundle --json --api-name <Developer_Name>` (실패 시 진단·수정·재검증. backing logic 생성 전 syntax/structural error 먼저 수정.)
7. **Generate backing logic** — NEEDS STUB마다 `sf template generate apex class --name <ClassName> --output-dir <PACKAGE_DIR>/main/default/classes`, invocable 패턴으로 body 교체, ALWAYS `sf project deploy start --json --metadata ApexClass:<ClassName>`. 다음 stub 전 deploy error 먼저 수정.
8. **Validate behavior** — `sf agent preview start --json --use-live-actions --authoring-bundle <Developer_Name>`. 데이터 쿼리 시 `sf data query --json -q "SELECT … FROM <SObject> LIMIT 100"`로 utterance grounding, `sf agent preview send --json --authoring-bundle <Developer_Name> --session-id <ID> -u "<message>"`로 전송. **CHECKPOINT** — validate 0 error · 대표 utterance로 live preview · trace 확인 · user 명시 승인, 전부 true 아니면 Publish 진행 금지.
9. **Publish** — `sf agent publish authoring-bundle --json --api-name <Developer_Name>` (metadata 구조만 검증, 동작 아님. 매 publish가 영구 version 번호 생성.)
10. **Activate** — `sf agent activate --json --api-name <Developer_Name>`
11. **Verify published agent** — activation 후 `sf agent preview start --json --api-name <Developer_Name>` (`--authoring-bundle` 아닌 `--api-name`).
12. **Configure end-user access** — employee agent만.

### Comprehend an Existing Agent
1. agent locate(`sfdx-project.json`→`AiAuthoringBundle`) → 2. Core Language로 `.agent` read → 3. `target` action별 backing logic 매핑 → 4. Agent Spec 역공학·파일 저장 → 5. Subagent Map Mermaid 다이어그램 → 6. (요청 시) 소스 inline 주석 → 7. user에 제시 + Anti-Pattern flag.

### Modify an Existing Agent
1. Comprehend(Spec 없으면 역공학) → 2. Agent Spec 업데이트(신규 action backing logic 스캔) → 3. **STOP for approval** → 4. code 편집 → 5. validate → 6. 신규 NEEDS STUB backing logic 생성·deploy → 7. validate behavior(변경 경로 먼저, 인접 경로로 regression 확인) **CHECKPOINT** → 8. publish → 9. activate → 10. verify(`--api-name`).

### Diagnose Compilation Errors
1. reproduce(`sf agent validate`; 안 나오면 `preview start --use-live-actions`) → 2. error 분류 → 3. fault locate → 4. fix(Anti-Pattern 확인) → 5. re-validate(validate 후 preview start) → 6. Core Language 실행 모델로 설명.

### Diagnose Behavioral Issues (compile OK, behavior wrong)
1. baseline(Agent Spec) → 2. hypotheses(routing·gating·action availability·instruction·variable·timing) → 3. preview reproduce(subagent마다 메시지, 1개로 불충분) → 4. **session trace 분석**(skip 금지 — preview output만으론 부족) → 5. root cause 매칭 → 6. fix(flow control 변경 시 Spec 갱신) → 7. re-validate·re-preview·인접 경로 → 8. 설명.

### Deploy, Publish, and Activate
1. validate → 2. bundle+dependency(Apex/Flow/Prompt Template) deploy → 3. live preview **CHECKPOINT** → 4. publish(dev/test inner loop에서 publish 금지, activate 직전 FINAL step만) → 5. activate → 6. verify(`--api-name`) → 7. end-user access(employee만).

### Diagnose Production Issues (published·active 후 문제)
1. issue 분류(billing/cost·runtime limit·naming conflict·tooling·preview-vs-prod 동작차) → 2. Production Gotchas 확인 → 3. preview vs production 비교(`--api-name` vs `--authoring-bundle --use-live-actions`) → 4. Known Issues 확인 → 5. fix·republish → 6. 진단 설명.

### Delete or Rename an Agent
1. current state(published? version 수? active?) → 2. active면 `sf agent deactivate --json --api-name <Developer_Name>`(active는 삭제·rename 불가) → 3. delete/rename 실행 → 4. orphan 정리(Bot, BotVersion, GenAiPlannerBundle, GenAiPlugin, GenAiFunction) → 5. validate.

### Test an Agent
1. coverage baseline(Agent Spec, subagent/action/flow path 매핑) → 2. test scenario 설계(**agentforce-test** 스킬이 모든 테스트 컨텐츠 소유) → 3. test spec YAML(`specs/<Agent_API_Name>-testSpec.yaml`) → 4. `AiEvaluationDefinition` 생성 → 5. deploy → 6. run → 7. 결과 분석 → 8. iterate.

---

## 핵심 규칙·가드레일

### The Agent Spec
이 스킬이 생산·소비하는 중심 artifact. 에이전트의 purpose·subagent graph·backing logic 매핑된 action·variable·gating·behavioral intent를 담은 구조화 설계 문서. creation 때 sparse, build 때 flesh out, comprehend 때 역공학, troubleshooting의 expected vs actual 기준, testing의 coverage 기준. 에이전트를 바꾸거나 분석하는 모든 작업의 첫 단계로 생산/갱신.

### Syntax Quick Reference
- 블록 순서: `system:` → `config:` → `variables:` → `connection:` → `knowledge:` → `language:` → `start_agent agent_router:` → `subagent:` 블록
- **들여쓰기 4 spaces** (탭 금지, 혼용 시 parser 깨짐)
- Boolean: `True`/`False` (대문자) · String: 항상 double-quote
- Numeric action I/O: bare `number`는 변수엔 되지만 **publish 시 실패** → `object` + `complex_data_type_name` 사용
- `after_reasoning:`는 `instructions:` wrapper 없음 · `else if` 없음(compound `if x and y:` 또는 순차 flat if)
- 예약 `@InvocableVariable` 명: `model`, `description`, `label` — Apex 파라미터명 불가
- `@inputs`/`@outputs`는 ephemeral: `@inputs`는 `with`에서만, `@outputs`는 action 직후 `set`/`if`에서만. `set`의 `@inputs`는 silent failure.

### Architecture Patterns (3 FSM 패턴)
- **Hub-and-Spoke**(최빈): `start_agent`가 전문 subagent로 routing, 각 subagent는 "back to hub" transition. 별도 routing subagent 만들지 말 것.
- **Verification Gate**: protected subagent 전 identity 검증, protected transition에 `available when` guard.
- **Post-Action Loop**: `instructions: ->` 최상단의 post-action check가 action 완료 후 re-resolution에 trigger.

### 채점·리뷰·안전
- **Scoring Rubric** 100점/7카테고리: Structure(15)·Safety(15)·Deterministic Logic(20)·Instruction Resolution(20)·FSM Architecture(10)·Action Configuration(10)·Deployment Readiness(10).
- **Review Mode**: `.agent` 제공 시 read→100점 채점→카테고리별 이슈→교정 snippet→fix 적용 제안.
- **Safety Review**: 7카테고리(Identity & Transparency, User Safety, Data Handling, Content Safety, Fairness, Deception, Scope & Boundaries), authoring·deployment의 Phase 0에 통합.

### Important Constraints
- Salesforce CLI·org만 사용(다른 skill/MCP/외부 tooling 의존 금지, 모두 `sf`).
- action backing은 일부 type만 valid(예: invocable Apex만, arbitrary Apex 불가).
- `sf agent generate test-spec`은 agentic용 아님(interactive REPL) — test spec은 assets boilerplate에서 시작.
- **CRITICAL (Discover & Scaffold):** stub은 `'TODO'`가 아니라 realistic data 반환. placeholder는 LLM이 training data로 fallback → SMALL_TALK grounding 유발.

### Common Issues Quick Reference
| 증상 | 원인/조치 |
|---|---|
| publish 시 `Internal Error, try again later` | invalid/missing `default_agent_user` — 쿼리 재실행, username 발명 금지 |
| preview 시 `Unable to access Salesforce Agent APIs…` | `default_agent_user` 권한 부족 — publish로 fix 금지(`--use-live-actions`는 published 불필요) |
| 현재 subagent action은 되는데 권한 에러 | planner가 모든 subagent action을 startup에 검증; 한 권한 누락이 전체 fail |
| live preview에서 Apex action 빈 결과(simulated는 OK) | `WITH USER_MODE` + object 권한 누락 = silent failure(0 rows, no error) |

---

## 번들 파일

| 카테고리 | 내용 (개수) |
|---|---|
| `references/` | 24개 — `salesforce-cli-for-agents.md`, `agent-script-core-language.md`, `agent-design-and-spec-creation.md`, `agent-subagent-map-diagrams.md`, `agent-user-setup.md`, `agent-metadata-and-lifecycle.md`, `agent-validation-and-debugging.md`, `agent-access-guide.md`, `known-issues.md`, `architecture-patterns.md`, `complex-data-types.md`, `safety-review-reference.md`, `discover-reference.md`, `scaffold-reference.md`, `deploy-reference.md`, `scoring-rubric.md`, `production-gotchas.md`, `instruction-resolution.md`, `feature-validity.md`, `examples.md`, `minimal-examples.md`, `action-prompt-templates.md`, `actions-reference.md`, `version-history.md` |
| `assets/` (루트 템플릿) | `agent-spec-template.md`, `local-info-agent-annotated.agent`, `template-single-subagent.agent`, `template-multi-subagent.agent`, `invocable-apex-template.cls`, `minimal-starter.agent`, `bundle-meta.xml` + 패턴 `.agent`(deterministic-routing, escalation-pattern, flow-action-lookup, hub-and-spoke, prompt-rag-search, verification-gate 등) |
| `assets/agents/` | 7 — hello-world, simple-qa, multi-subagent, production-faq(+bundle-meta.xml), order-service, verification-gate |
| `assets/patterns/` | 11+ 재사용 패턴 — action-callbacks, advanced-input-bindings, bidirectional-routing, critical-input-collection, delegation-routing, lifecycle-events, llm-controlled-actions, multi-step-workflow, open-gate-routing, procedural-instructions, prompt-template-action, system-instruction-overrides |
| `assets/components/` | apex-action, error-handling, escalation-setup, flow-action, n-ary-conditions, subagent-with-actions |
| `assets/apex/` | `models-api-queueable.cls` |
| `assets/metadata/` | 6 — basic-prompt-template, genai-function-apex, genai-function-flow, genai-plugin, http-callout-flow, record-grounded-prompt |
| 루트 | `README.md` · `README-legacy.md` · `SKILL.md` |

---

## 관련 노트
- [[agentforce-test]]
- [[agentforce-observe]]
- [[agentforce-architecture-analyze]]
- [[agentforce-d360-analyze]]
