---
tags: [agent-skill, sf-skills, agentforce, architecture, metadata, mermaid]
source: forcedotcom/sf-skills (skills/agentforce-architecture-analyze/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [agentforce-architecture-analyze, Agentforce 아키텍처 스냅샷, 선언적 아키텍처 분석, design-time metadata, agent action tree, planner topic 인벤토리]
---

# agentforce-architecture-analyze — Agentforce 선언적 아키텍처 스냅샷

> 한 Agentforce 에이전트의 design-time 메타데이터(planner→topics→actions→flows→Apex→prompts→NGA plugins)를 읽어 사람이 읽을 수 있는 아키텍처 문서 + Mermaid 호출 그래프를 inline 파이프라인으로 생성한다. 런타임 audit이 아니라 선언된 메타데이터만 읽는다.

---

## 목적과 활성화 조건

`metadata.version: 1.0`

**description (원문 인용):** *"Declared architecture snapshot for one Agentforce agent: planner, topics, actions, flows, Apex, prompt templates, and NGA plugins. Renders a human-readable architecture document and Mermaid invocation graph from design-time metadata (not runtime audit rows)."*

**TRIGGER when:** 사용자가 특정 org 내 특정 에이전트(agent API name 기준)의 아키텍처 / action tree / topic structure / tool inventory를 **describe, diagram, inventory, audit, document, 또는 diff(예: v3 vs v5)** 하라고 요청할 때.

**DO NOT TRIGGER:** 런타임 세션 트레이스, 대화 transcript, generation timing, gateway audit chain 요청 — 이 스킬은 design-time 메타데이터만 읽는다. 세션 트레이스는 [[agentforce-d360-analyze]] 사용.

읽는 메타데이터: `BotDefinition`, `GenAiPlanner*`, `GenAiPlugin*`, `GenAiFunction*`, `Flow`, `ApexClass`, `GenAiPromptTemplate`. 런타임 audit row는 읽지 않는다.

**런타임 예산:** 일반 30–45초, hard cap ≤60초(reference fixture 기준). 순차 baseline이면 90–220초이지만 병렬 Tooling SOQL fan-out으로 3–5× 가속. **subagent 없이 inline 실행** — 모든 phase가 결정론적 파일 처리.

### 입력이 부족할 때
`agent_api_name`도 org alias도 없이 호출되면, paraphrase·사전 스크립트 실행 없이 "Which agent should I document, and in which org?" 안내 블록을 **verbatim** 출력한다. 필요: **Agent API name**(`BotDefinition.DeveloperName`, label 아님), **Org alias**. 선택: `--version`, `--force`, `--reprobe`.

---

## 워크플로 / 단계

### 입력 (Inputs)

| Input | Flag | 필수 | 기본값 |
|---|---|---|---|
| `org_alias` | `--org` | yes | — |
| `agent_api_name` | `--agent` | yes | — |
| `agent_version_api_name` | `--version` | no | active BotVersion |
| `force_refresh` | `--force` | no | false (캐시 사용) |
| `reprobe` | `--reprobe` | no | false (7일 channel-probe 캐시 사용) |
| `parallelism` | `--parallelism` | no | 5 |
| `max_mermaid_nodes` | `--max-mermaid-nodes` | no | 80 |
| `data_dir` | `--data-dir` | no | `~/.vibe/data/agentforce-architecture-analyze` |
| `cache_dir` | `--cache-dir` | no | `~/.vibe/cache/agentforce-architecture-analyze` |

### 파이프라인 호출

`--org <alias>` + `--agent <api_name>`가 주어지면 단일 `python3` 호출이 전체 파이프라인을 구동한다. `main.py`가 `.emit_ctx.json`을 쓰고, `emit_result.py`가 그것을 읽어 최종 `=== RESULT ===` 블록을 마지막으로 stdout에 출력한다. 필수 플래그(`--org`/`--agent`)가 없으면 usage 블록을 stderr로 verbatim 출력하고 `exit 2`(main.py를 사전 실행하지 않음).

```bash
SKILL_ROOT="${SKILL_ROOT:-${PLUGIN_ROOT:-$HOME/.vibe/skills}/agentforce-architecture-analyze}"

# 경계에서 입력 검증 — fs_guard가 실패 시 INVALID_INPUT RESULT 블록 출력 + exit 1
python3 "$SKILL_ROOT/scripts/_shared/fs_guard.py" "$ARG_AGENT" agent_api_name api_name || exit 1
python3 "$SKILL_ROOT/scripts/_shared/fs_guard.py" "$ARG_ORG" org_alias not_empty || exit 1
python3 "$SKILL_ROOT/scripts/_shared/fs_guard.py" "$WORK_DIR" WORK_DIR symlink || exit 1
python3 "$SKILL_ROOT/scripts/_shared/fs_guard.py" "$WORK_DIR" WORK_DIR owned || exit 1

# 단일 python3 호출이 모든 파이프라인 phase 구동
python3 "$SKILL_ROOT/scripts/main.py" "${_main_args[@]}"
_rc=$?
WORK_DIR="$WORK_DIR" python3 "$SKILL_ROOT/tools/emit_result.py"
exit "$_rc"
```

> zsh는 배열이 1-indexed라 인자 파서 블록 상단에서 `[ -n "${ZSH_VERSION:-}" ] && setopt KSH_ARRAYS`로 0-indexed로 맞춘다(bash에선 no-op). 인자 파서는 `--org foo`와 `--org=foo` 모두 허용.

### 파이프라인 단계 (inline, no subagent)

```
resolve_bot.py        → BotDefinition + BotVersion + planner name lookup
retrieve_planner.py   → GenAiPlannerBundle Metadata API zip retrieve (+NGA plugins if present)
parallel_retrieve.py  → planner id에서 6개 병렬 Tooling SOQL 채널 fan-out
                          (planner_definition_by_agent_chain seed query로 resolve):
                          - plugins_by_planner (GenAiPluginDefinition)
                          - planner_bundle_functions (GenAiPlannerFunctionDef join)
                          - functions_by_plugins (GenAiFunctionDefinition)
                          - planner_attrs_by_parent_ids (GenAiPlannerAttrDefinition)
                          - plugin_functions_by_plugin_ids (GenAiPluginFunctionDef join)
                          - plugin_instructions_by_plugin_ids (GenAiPluginInstructionDef)
parse_bundle.py       → retrieved XML을 normalized node shape로 파싱
parse_wave.py         → BFS 확장: node에서 발견된 flow/apex/prompt ref
                          → Flow/Apex body SOQL(id list batch)
                          → GenAiPromptTemplate만 Metadata retrieve (+NGA external plugin 조건부)
finalize.py           → wave를 metadata_tree.json으로 merge
render_architecture.py → <agent>_<ver>_architecture.md + Mermaid 호출 그래프(--max-mermaid-nodes 상한)
```

**채널 전략 — SOQL-first.** 모든 normalized tree node는 Tooling SOQL(planner id 키 6병렬 채널). Flow(by id)/Apex(by id or name) body는 Data API SOQL(batched). Metadata retrieve는 단 두 경우만: (a) `GenAiPromptTemplate`(prompt body가 Tooling SOQL로 깔끔히 안 나옴), (b) planner가 NGA shape일 때 NGA **external plugin**(classic ReAct는 skip). 이 SOQL-first 전략이 3–5× 가속의 출처 — 병렬 Tooling SOQL이 tree의 ~80%를 한 fan-out으로 커버.

### 출력 (Outputs)

기본 위치 `~/.vibe/data/agentforce-architecture-analyze/<org_id15>/<agent_api_name>__<agent_version>/`:

```
<agent>_<ver>_metadata_tree.json   primary artifact — normalized planner/topic/action/flow/apex/prompt/plugin tree
<agent>_<ver>_architecture.md      H1 + 7 numbered sections + 조건부 Dependency graph appendix.
                                   Mermaid는 Action tree·Data flow·Dependency graph 섹션에 embed
```

---

## 핵심 규칙·가드레일

### Planner shape — classic ReAct vs NGA
두 planner family를 단일 tree shape로 정규화한다.

| Shape | `GenAiPlannerDefinition.PlannerType` | InvocationTarget 스타일 | NGA plugins? |
|---|---|---|---|
| **Classic ReAct** | `ReactAiPlannerV1` / `SequentialPlannerIntentClassifier` 등 | DeveloperName 문자열 | no |
| **NGA** | `ConcurrentMultiAgentOrchestration` / `AnthropicCompatibleV1` 등 | 때때로 15/18자 Id(ID-prefix routed) | yes (external plugin via Metadata retrieve) |

`resolve_invocation_target.py`의 ID-prefix router가 둘을 구분: id처럼 보이는 NGA InvocationTarget(`01p…`=ApexClass, `301…`=Flow 등)은 id-scoped SOQL로, DeveloperName target은 name-scoped SOQL로 resolve. 미지의 prefix는 `_unresolved[]`에 `reason="unknown-id-prefix:<prefix>"`로 표면화 — **절대 silent drop 안 함**.

### 캐싱
- **Tree cache:** `--force` 없으면 `metadata_tree.json` 재사용. 캐시 키는 번들된 모든 `.soql`/`.yaml`/`.mmd` 템플릿의 asset-hash 포함 — 템플릿 변경 시 캐시 자동 무효화.
- **Channel probe cache:** per-org `sf sobject describe` 결과에 7일 TTL(모든 SOQL asset 필드명 검증). Salesforce 분기 릴리스가 필드 rename/remove 시 `status: PROBE_FAILED`; `--reprobe`로 강제 갱신.

### Invariants
- **결정론적:** 같은 `(org, agent, version)` + 정적 org 메타데이터 → byte-identical 출력. manifest timestamp만 drift.
- **Forward-only traversal:** 발견된 모든 ref는 planner→children 방향으로만. backward lookup 없음.
- **Partial 결과는 표면화, silence 안 함:** 미해결 ref는 `_unresolved[]`에 `reason=...`. 채널 실패 시 `STATUS=PARTIAL_OK`, 클린 런만 `STATUS=OK`.
- **Cycle detection은 per-branch:** 같은 flow가 자기 ancestor chain에서 재방문되면 recurse 대신 `_cycle_back_to:<path>` emit. 방어선 `MAX_BFS_DEPTH=20`. (과거 hard cap 5는 `handleFlowFault` 같은 공용 utility flow가 매번 trip시켜 폐기됨.)
- **Child 정렬:** `api_name` 알파벳순(case-insensitive). root level에서 Topic이 non-topic plannerAction보다 먼저. Flow-actionCall 순서는 정렬 안 함(flow 작성자의 실행 순서 유지).

### 전제조건
| Tool | 필수 |
|---|---|
| `sf` CLI (대상 org 인증) | yes — `sf org login web --alias <alias>` |
| Python 3.10+ | yes |

---

## 번들 파일

| 카테고리 | 내용 (개수) |
|---|---|
| `references/` | `soql_fields.md`(13 sObject 필드 reference, `[mandatory]`/`[optional]` 태그), `contract.json`(`metadata_tree.json` 머신 스키마), `architecture_sections.md`(렌더된 문서 섹션 구조) — eager load 금지, 필요 시만 |
| `scripts/` | 파이프라인 18개(`main.py`, `resolve_bot.py`, `retrieve_planner.py`, `parallel_retrieve.py`, `parse_bundle.py`, `parse_wave.py`, `finalize.py`, `render_architecture.py`, `fetch_soql.py`, `resolve_invocation_target.py`, `summarize_tree.py`, `sf_cli.py`, `rest_client.py`, `soql_loader.py`, `config.py`, `cache_check.py`, `metadata_listing.py`, `probe_channels.py`) + `_shared/`(fs_guard, paths, runtime, sql) + `tests/`(~35 pytest 파일 + fixtures) |
| `tools/` | `emit_env.py`, `emit_result.py`, `sanitize.py`, `write_emit_ctx.py` |
| `assets/cli/` | 6개 CLI recipe YAML(describe_sobject, describe_tooling_sobject, list_metadata_genaiprompttemplate, org_display, retrieve_genai_plugin, show_access_token) |
| `assets/mermaid/` | 5개 `.mmd` 템플릿(action_tree, data_flow, dependency_graph, invocation_sequence, planner_state) |
| `assets/soql/` | 16개 `.soql`(plugins_by_planner, planner_bundle_functions, functions_by_plugins, planner_attrs_by_parent_ids, plugin_functions_by_plugin_ids, plugin_instructions_by_plugin_ids, planner_definition_by_agent_chain, bot_definition_details, bot_version_lookup, flow_definition_*, apex_class_bodies_by_* 등) |
| 루트 | `README.md` · `SKILL.md` |

---

## 관련 노트
- [[agentforce-d360-analyze]]
- [[agentforce-observe]]
- [[agentforce-generate]]
- [[agentforce-test]]
