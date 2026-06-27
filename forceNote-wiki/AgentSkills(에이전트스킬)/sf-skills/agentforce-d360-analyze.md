---
tags: [agent-skill, sf-skills, agentforce, data-cloud, session-trace, stdm]
source: forcedotcom/sf-skills (skills/agentforce-d360-analyze/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [agentforce-d360-analyze, Data Cloud 360 세션 뷰, 세션 트레이스, session reconstruction, STDM GenAI DMO, agent session 추적]
---

# agentforce-d360-analyze — Data Cloud 360° 세션 뷰

> 한 Agentforce 세션을 Data Cloud STDM + GenAI DMO에서 계층적으로 재구성한다. 3단계(fetch → assemble → render). DC가 materialize한 런타임 audit row만 읽는 DC-only 도구 — 런타임 가용성 도구가 아니다.

---

## 목적과 활성화 조건

`metadata.version: 1.0`

**description (원문 인용):** *"Data Cloud 360° view of a single Agentforce session. TRIGGER when user asks to trace, inspect, summarize, or describe a specific Agentforce session by session id (Agent Session UUID `019d…` or MessagingSession id `0Mw…`). Also triggers on session discovery — find/list/search sessions by time, agent, channel, outcome, or conversation text — when the user has no session id yet."*

**DO NOT TRIGGER:** design-time 아키텍처 질문(→ [[agentforce-architecture-analyze]]), Data Cloud 너머 플랫폼 텔레메트리가 필요한 런타임 perf/latency/SLO 질문.

일반 wall-clock: ~15턴 세션 기준 ~10–30초.

### 입력이 부족할 때
session id도 discovery 기준도 없으면 paraphrase·사전 실행 없이 "Which session should I pull from Data Cloud, and in which org?" 블록을 **verbatim** 출력. 필요: **Session id**(UUID `019db7f6-…` 또는 MessagingSession `0Mw…`) 또는 discovery 단서(최근성·agent·channel·outcome·대화 구절), **Org alias**.

### Session id 형태 — UUID 또는 MessagingSession id
`--session`에 두 형태 모두 허용:

| Form | 예시 | Resolution |
|---|---|---|
| Agent Session UUID | `019dface-0000-7000-8000-000000000002` | Pass-through |
| MessagingSession id (`0Mw` prefix) | `0MwTESTMSG12345AAA` | `resolve_session.py`로 resolve — 첫 fetch는 live DC lookup, 이후 disk-first |

**Multi-match 실재:** 한 MessagingSession id가 여러 Agent Session UUID에 매핑될 수 있다. multi-match 시 resolver가 모든 candidate를 출력하고 non-zero exit; 사용자가 특정 UUID로 재호출. messaging id는 lookup key일 뿐 디렉터리명이 되지 않는다. dominant agent(`sorted(agents_observed)`의 첫 번째)가 `<agent>__<ver>/` 세그먼트를 명명.

---

## 워크플로 / 단계

### 스크립트 prefix 해석
기본 설치는 runtime plugin root 아래. custom path로 clone했으면 `PLUGIN_ROOT`를 runtime skills 디렉터리로 지정.

```bash
prefix="${SKILL_ROOT:-${PLUGIN_ROOT:-$HOME/.vibe/skills}/agentforce-d360-analyze}/scripts"
```

### 세션 discovery (id 없을 때)
session id가 없으면 STDM session DMO에 대해 `discover_sessions.py` 실행. 번호 picker 출력 → 사용자가 하나 선택 → 그 UUID로 진행.

```bash
python3 "$prefix/discover_sessions.py" --org <alias> [filters...]
```

**Filters** (`--org` 외 전부 optional): `--since <expr>`(기본 last 24h; "last 2 hours"/"today"/ISO date), `--agent <api-name>`, `--channel <Messaging|Builder|Voice>`, `--outcome <USER_ENDED|ESCALATED|TRANSFERRED|TIMEOUT|NOT_SET>`, `--grep <substring>`(대화 텍스트), `--tz <IANA>`, `--limit <N>`(기본 20). **출력:** `#`·`UUID`·`Start (UTC)`·`Agent`·`Channel`·`Duration`·`Outcome` markdown 테이블.

### 파이프라인 — 3단계

```
fetch_dc.py     →  24 dc.<name>.json + dc._session_manifest.json   (DC Query REST waterfall, 5 waves)
assemble_dc.py  →  dc._session_tree.json                           (순수 in-memory 계층 join)
render_dc.py    →  dc._session_summary.md                          (사람용 멀티섹션 요약)
```

각 단계 독립 실행 가능. `fetch_dc.py --session <sid> --org <alias>`가 기본으로 셋 전부 chaining.

```bash
python3 "$prefix/fetch_dc.py" --session <session-id-or-messaging-id> --org <alias>
```

플래그: `--verbose`(per-DMO row count), `--no-assemble`/`--no-render`(조기 중단). 모든 entry 스크립트(`fetch_dc.py`, `assemble_dc.py`, `render_dc.py`, `resolve_session.py`, `discover_sessions.py`)는 `--data-dir`/`--cache-dir`로 기본 root 오버라이드 가능.

### 출력 artifact
`~/.vibe/data/agentforce-d360-analyze/<org_id15>/<agent>__<ver>/<session_id>/` 아래 24개 `dc.*.json`(sessions, interactions, participants, steps, messages, generations, gateway_requests/responses/request_llm/request_metadata/request_tags/records, content_quality, content_category, tags, tag_definitions, tag_associations, tag_definition_associations, feedback, feedback_details, moments, moment_interactions, telemetry_spans, app_generation) +

```
dc._session_manifest.json   (per-DMO row counts + empties)
dc._session_tree.json       (계층 join — session→interactions→steps→messages→generations→gateway)
dc._session_summary.md      (렌더된 사람용 요약)
```

Zero-row 쿼리는 manifest에 `status: empty`로 기록되고 파일은 쓰지 않음. `assemble_dc`는 missing file 허용. 전체 read order는 `references/artifacts.md`.

### 렌더된 summary의 top-level 섹션
1. **Session identity** — UUID, start/end, duration, agent, channel, end type, participant count
2. **Session bootstrap** — channel mode + bootstrap variables(`identity.mode`, `identity.bootstrap_variables`)
3. **ID reference** — 계층 trace에서 truncate된 전체 UUID
4. **Transcript** — TURN interaction별 USER ↔ AGENT 서사
5. **Complete hierarchical trace** — Interaction→Step→Generation→GatewayRequest, `+start + duration = +end` 수식
6. **Per-turn summary** — interaction당 1행
7. **Planner LLM calls (full prompts + responses)** — `--show-prompts` opt-in; 기본 suppress
8. **Visual analysis** — gantt + LLM-call overlay
9. **Session counts** — engineer용 manifest count 테이블
10. **Empties diagnostics** — `rows == 0` DMO마다 1행 + `_unavailable_reason`
11. **Catalog (session-filtered)** — 세션 내 관측 agent로 필터된 TagDefinitions/TagDefinitionAssociations/Tags

심층 분석은 `dc._session_tree.json`(요약의 single source of truth) 열기.

### 일반 프롬프트 매핑
| 사용자 발화 | 스킬 동작 |
|---|---|
| *"Trace session `<uuid>` in my-org"* | `fetch_dc.py --session <uuid> --org my-org` → assemble → render |
| *"Summarize what happened in `0Mw…`"* | `0Mw…` → UUID resolve, 후 전체 DC 파이프라인 |
| *"Find escalated sessions today on Messaging"* | `discover_sessions.py --since today --outcome ESCALATED --channel Messaging`, picker, 선택 후 DC 파이프라인 |

---

## 핵심 규칙·가드레일

### DC-only blind spot — root cause 확정 전 필독
DC는 **무엇이 일어났는가**(실행된 step, fire된 generation, 로깅된 gateway request)에만 답한다. **일어날 수 있었으나 안 일어난 것**에는 답하지 못함:
- 특정 턴에서 classifier에 **eligible했던 topic** (런타임 planner telemetry에 있음, DC 아님)
- topic에 **선언된 action** vs rule expression을 통과해 실제로 LLM에 제공된 action
- LLM이 왜 한 topic/action을 다른 것 대신 골랐는가 (full prompt+response는 planner 런타임 telemetry에만)

사용자 질문이 *왜 특정 topic/action이 쓰였/안 쓰였는가*면 DC-only로 거의 항상 불충분 → 사용자에게 "가용성 질문은 해당 턴의 런타임 planner trace가 필요하며 이 스킬의 Data Cloud 표면 밖"이라 알리고, 런타임 증거 없이 root cause를 fabricate하지 않는다.

### DC가 잘하는 것
- **무엇이 실행됐는가** — 모든 step·LLM call·gateway request+response, 순서·timestamp·duration 포함
- **사용자가 본 것** — full message transcript (user+agent), 순서대로
- **LLM이 생산한 것** — generations, token count, trust score (toxicity, instruction adherence, `content_quality`+`content_category`의 content-category breakdown)
- **Tool invocation** — action call, input, output, error (`gateway_request_metadata`+`gateway_records`)
- **Feedback + flags** — user feedback, escalation marker, session-end type
- **Audit integrity** — GatewayRequest:GatewayResponse 1:1 invariant 검사, drift는 `counts.audit_chain_1to1_ok`에 flag

### Caveats
- **`gateway_requests_dropped_by_stdm`** — DC가 zero gateway_requests를 보고하나 런타임상 LLM call이 fire됐을 때, "STDM exporter가 write를 drop"과 "source에서 로깅 비활성"을 확정 구분 불가. `planner_ran_no_gateway_logs`로 보고. (`references/dc_pipeline_contract.md` §2.8)
- **Latency** — Generation/GatewayRequest는 single-write timestamp(start/end pair 아님). renderer는 둘 사이 "latency"를 계산하지 않음 — 그 delta는 DC의 serialization 순서이지 LLM call 소요시간이 아님.
- **Data Cloud materialization lag** — fresh 세션은 STDM이 못 따라잡으면 `interactions_not_materialized_yet` 표시; 1–2분 후 재실행.

### 전제조건
| Tool | 필수 |
|---|---|
| `sf` CLI (대상 org 인증) | yes — `sf org login web --alias <alias>` |
| Data Cloud 활성화 | yes — STDM + GenAI DMO가 세션에 materialize돼야 함 |
| Python 3.10+ | yes |

---

## 번들 파일

| 카테고리 | 내용 (개수) |
|---|---|
| `references/` | `artifacts.md`(full read order), `dc_dmo_fields.md`(per-DMO 필드 reference), `dc_pipeline_contract.md`(파이프라인 contract, §2.8 dropped-by-stdm 포함) |
| `scripts/` | entry 6개(`fetch_dc.py`, `assemble_dc.py`, `render_dc.py`, `resolve_session.py`, `discover_sessions.py`, `dc.py`) + `config.py`·`storage.py` + `_shared/`(cli_override, fs_guard, paths, runtime, sql) + `tests/`(~26 pytest 파일 + synthetic_session fixture) |
| `assets/dc/` | 25개 `.sql`(sessions, interactions, participants, steps, messages, generations, gateway_requests/responses/request_llm/request_metadata/request_tags/records, content_quality, content_category, tags, tag_definitions, tag_associations, tag_definition_associations, feedback, feedback_details, moments, moment_interactions, telemetry_spans, app_generation, discover_sessions, messaging_session) |
| 루트 | `README.md` · `SKILL.md` |

---

## 관련 노트
- [[agentforce-architecture-analyze]]
- [[agentforce-observe]]
- [[agentforce-generate]]
- [[agentforce-test]]
