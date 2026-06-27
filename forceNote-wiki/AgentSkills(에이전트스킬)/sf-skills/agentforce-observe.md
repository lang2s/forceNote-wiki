---
tags: [agent-skill, sf-skills, agentforce, observability, stdm, session-trace]
source: forcedotcom/sf-skills (skills/agentforce-observe/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [agentforce-observe, Agentforce 관측성, 프로덕션 에이전트 분석, STDM session 분석, observe-reproduce-improve, findSessions]
---

# agentforce-observe — Agentforce 관측성(Observe-Reproduce-Improve)

> 세션 트레이스 데이터와 live preview 테스트로 프로덕션 Agentforce 에이전트를 개선한다. 3단계 워크플로: Observe(STDM 쿼리 또는 fallback) → Reproduce(`sf agent preview`로 재현) → Improve(`.agent` 직접 편집·검증·publish·verify).

---

## 목적과 활성화 조건

`metadata.version: 1.0` · `allowed-tools: Bash Read Write Edit Glob Grep` · `compatibility: claude-code` · `argument-hint: "<org-alias> [--agent-file <path>] [--session-id <id>] [--days <n>]"`

**description (원문 인용):** *"Analyze production Agentforce agent behavior using session traces and Data Cloud. TRIGGER when: user queries STDM session data or Data Cloud trace records; investigates production agent failures, regressions, or performance issues; asks about session traces, conversation logs, or agent metrics; wants to reproduce a reported production issue in preview; runs findSessions or trace analysis queries."*

**DO NOT TRIGGER:** 개발 중 `.agent` 파일 생성/수정/디버그(→ [[agentforce-generate]]), test spec 작성/실행(→ [[agentforce-test]]), 로컬 개발 iteration용 `sf agent preview`, 에이전트 deploy/publish.

### Routing — 시작 전 입력 수집
- **Org alias** (필수) · **Agent API name** (preview·deploy 필수) · **Agent file path** (선택, 기본 `force-app/main/default/aiAuthoringBundles/<AgentName>/<AgentName>.agent`, auto-detect) · **Session IDs** (선택, 없으면 last 7 days) · **Days to look back** (선택, 기본 7)

| 사용자 의도 | 동작 |
|---|---|
| 특정 action 없음 | 3 phase 전부: Observe → 이슈 표면화 → Reproduce/Improve 여부 질의 |
| "analyze"/"sessions"/"what's wrong" | Phase 1만, 후 next step 제안 |
| "reproduce"/"test"/"preview" | Phase 2 (이슈 없으면 Phase 1 먼저) |
| "fix"/"improve"/"update" | Phase 3 (이슈 없으면 Phase 1 먼저) |

### Platform Notes
bash 예시 — Windows는 PowerShell/Git Bash; `python3`→`python`; `/tmp/`는 `$env:TEMP` (PowerShell)/`%TEMP%` (cmd); `jq` 미설치 시 `python -c "import json,sys; …"`.

---

## 워크플로 / 단계

### Resolve agent name (STDM 쿼리 전)
사용자 제공 agent name을 org에 대조해 정확한 `MasterLabel`·`DeveloperName` 획득:

```bash
sf data query --json \
  --query "SELECT Id, MasterLabel, DeveloperName FROM GenAiPlannerDefinition WHERE MasterLabel LIKE '%<user-provided-name>%' OR DeveloperName LIKE '%<user-provided-name>%'" \
  -o <org>
```

- `MasterLabel` = STDM `findSessions`·Agent Builder UI 표시명(예: "Order Service") → `AGENT_MASTER_LABEL`
- `DeveloperName` = version suffix 포함 API 명(예: "OrderService_v9")
- `sf agent preview/activate/publish`의 `--api-name`은 `_vN` suffix **없는** DeveloperName(예: "OrderService") → `AGENT_API_NAME`
- `PLANNER_ID` = 이 agent의 record ID

### Locate the .agent file
Step 1 로컬 검색 `find <project-root>/force-app/main/default/aiAuthoringBundles -name "*.agent"`. Step 2 없으면 org retrieve:

```bash
sf project retrieve start --json --metadata "AiAuthoringBundle:<AGENT_API_NAME>" -o <org>
```

> **Known bug:** retrieve가 이중 중첩 경로 `force-app/main/default/main/default/aiAuthoringBundles/...` 생성 → 직후 `force-app/main/default/aiAuthoringBundles/`로 복사 후 `main` 제거.

Step 3 검증: `.agent`에 `system: instructions:`, `config: developer_name:`, `start_agent`/`subagent` 블록의 `reasoning: instructions:` 존재 + 각 subagent의 `instructions:`가 distinct(동일 금지). 경로를 `AGENT_FILE`로 저장.

### Phase 0: Discover Data Space (STDM 쿼리 전)
정확한 Data Cloud Data Space API name 결정:

```bash
sf api request rest "/services/data/v63.0/ssot/data-spaces" -o <org>
```

> `sf api request rest`는 beta — `--json` 추가 금지(미지원, 에러). 응답 `dataSpaces[].name`이 `AgentforceOptimizeService`에 넘길 API name. 실패(404/권한) 시 `'default'` fallback + 가정 명시. `status: "Active"`만 필터. Active 1개면 자동 사용·확인, 복수면 list 제시·질의. 선택값을 `DATA_SPACE`로 저장.

**Prerequisite check: STDM DMOs** — helper class 배포(step 1.0) 후 STDM DMO 존재 probe:

```bash
sf apex run -o <org> -f /dev/stdin << 'APEX'
ConnectApi.CdpQueryInput qi = new ConnectApi.CdpQueryInput();
qi.sql = 'SELECT ssot__Id__c FROM "ssot__AiAgentSession__dlm" LIMIT 1';
try {
    ConnectApi.CdpQueryOutputV2 out = ConnectApi.CdpQuery.queryAnsiSqlV2(qi, '<DATA_SPACE>');
    System.debug('STDM_CHECK:OK rows=' + (out.data != null ? out.data.size() : 0));
} catch (Exception e) {
    System.debug('STDM_CHECK:FAIL ' + e.getMessage());
}
APEX
```

`STDM_CHECK:FAIL` → STDM 미활성, **Phase 1-ALT**로 전환(Setup→Data Cloud→Data Streams에서 "Agentforce Activity" 활성 안내). `STDM_CHECK:OK` → Phase 1.

### Phase 1-ALT: Observe Without STDM (Fallback)
test suite + `sf agent preview --authoring-bundle` + 로컬 trace 분석.

| Data source | 사용 시점 | Pros | Cons |
|---|---|---|---|
| STDM (Phase 1) | 과거 프로덕션 분석 | 실 사용자 데이터, 볼륨 | Data Cloud 필요, 15분 lag |
| test suites + local traces (1-ALT) | dev iteration, STDM 없는 org | 즉시, full LLM prompt, variable state | preview only, 실 사용자 데이터 없음 |

- **1-ALT.1** 기존 test suite 실행(`sf agent test list/run/results`)
- **1-ALT.2** test suite 없으면 `.agent`에서 utterance 도출(non-entry subagent별 1개, key action별 1개, guardrail 1개, multi-turn 1개)
- **1-ALT.3** `--authoring-bundle` preview로 로컬 trace 생성 → `.sfdx/agents/{BundleName}/sessions/{sessionId}/traces/{planId}.json`
- **1-ALT.4** 로컬 trace 진단(jq):

```bash
# Subagent misroute
jq -r '.plan[] | select(.type=="NodeEntryStateStep") | .data.agent_name' "$TRACE"
# Action not called
jq -r '.plan[] | select(.type=="EnabledToolsStep") | .data.enabled_tools[]' "$TRACE"
# LOW adherence
jq -r '.plan[] | select(.type=="ReasoningStep") | {category, reason}' "$TRACE"
```

> **DefaultTopic trace quirk:** `--authoring-bundle`에선 root `.topic`이 routing 정상이어도 종종 `"DefaultTopic"`; 실 subagent chain은 `NodeEntryStateStep.data.agent_name` 사용. **Entry answering directly (SMALL_TALK):** `start_agent` trace가 SMALL_TALK grounding + transition tool 보이나 미호출이면 instructions에 "You are a router only. Do NOT answer questions directly." 추가.

- **1-ALT.5** `references/issue-classification.md` 카테고리로 분류·제시, 후 agent config evidence 분석으로 자동 진행.

### Phase 1: Observe — Query STDM
- **1.0** helper class `AgentforceOptimizeService` org당 1회 배포(`SELECT Id, Name FROM ApexClass WHERE Name = 'AgentforceOptimizeService'`로 확인 먼저)
- **1.1** `findSessions()`로 최근 세션, Apex debug log의 `DEBUG|STDM_RESULT:` 파싱(empty면 Phase 1-ALT)
- **1.2** `getMultipleConversationDetails()` 최대 5세션(최신순) — turn별 message·step·topic·action 결과
- **1.2b** LOW adherence 시 `getLlmStepDetails()` 실제 LLM prompt/response
- **1.2c** (권장 first step) `getAggregatedMetrics()` 헬스 대시보드 — session rate, top intent, quality 분포, RAG 평균
- **1.2d** `getMomentInsights()` per-session intent summary·quality(1–5)·retriever metric
- **1.2e** `runObservabilityQuery()` RAG deep-dive: KnowledgeGap, Hallucination, RetrievalQuality, AnswerRelevancy, Leaderboard
- **1.3** `ConversationData` JSON에서 turn-by-turn timeline 재구성
- **1.4** 이슈 식별 — action error, subagent misroute, missing action, wrong input, variable capture fail, no transition, slow action, LOW adherence, abandoned, dead subagent, publish drift, dead hub anti-pattern, entry answering directly, safety. 우선순위 **P1**=action error·misroute·LOW adherence / **P2**=missing action·variable bug·knowledge gap / **P3**=performance·abandoned
- **1.5** findings + agent config evidence 제시, `.agent` 자동 분석(subagent count vs action block, dead hub, orphan action, cross-subagent 변수 의존)·STDM 증상 cross-reference

### Phase 2: Reproduce — Live Preview
Phase 1의 confirmed issue마다 1 scenario를 `sf agent preview --authoring-bundle`로 **3회** 실행·분류:

| Verdict | 기준 |
|---|---|
| `[CONFIRMED]` | 3/3 동일 실패 |
| `[INTERMITTENT]` | 1–2/3 실패 |
| `[NOT REPRODUCED]` | 3/3 pass |

`[CONFIRMED]`·`[INTERMITTENT]`만 Phase 3로. trace: `.sfdx/agents/{Name}/sessions/{sessionId}/traces/{planId}.json`.

### Phase 3: Improve — Edit .agent Directly
- **3.0 Pre-flight** — 편집 전 모든 action target이 org에 존재·등록 확인. 누락 시 옵션 제시(stub deploy / action 제거 / UI 등록 / routing-only fix)
- **3.1–3.3** issue→fix location 매핑(description, instructions, actions, bindings, transitions), Edit 도구 targeted 변경, instruction 원칙(action 명시 명명, pre-condition 명시, 좁게 scope, persona는 `system:`에만)
- **3.4 Regression prevention** — baseline 수립, 최소 편집, 편집마다 즉시 테스트, publish 주기당 1 fix, cross-subagent 의존·인접 subagent 테스트
- **3.5 Apply fixes** — `.agent` read, Edit(들여쓰기 탭), diff 표시
- **3.6 Validate/deploy/publish/activate:**

```bash
sf agent validate authoring-bundle --json --api-name <AGENT_API_NAME> -o <org>   # dry run
sf agent publish  authoring-bundle --json --api-name <AGENT_API_NAME> -o <org>   # compile+deploy+activate
```

> publish 실패 시 deploy+activate fallback(불완전 — `reasoning: actions:`를 live metadata로 propagate 못 함).

- **3.7 Verify** — Phase 2 scenario 재실행, trace로 routing·grounding·tool·variable 확인. 24–48h 후 Phase 1 재실행해 baseline 대비.
- **3.7b Safety re-verification (필수)** — 수정된 `.agent`에 safety review(/agentforce-generate Section 15) 재실행, BLOCK 발견 변경은 revert.
- **3.8** Testing Center YAML로 regression test case 생성(`sf agent test create`), 이전 broken scenario 전부 pass 확인.

---

## 핵심 규칙·가드레일

- STDM은 15분 lag — 과거 프로덕션 분석용; 즉시성·full prompt가 필요하면 1-ALT(preview).
- preview output만으론 진단 부족 — 항상 trace step 분석.
- publish 주기당 fix 1개, baseline 후 최소 편집(regression 방지).
- 모든 Improve 후 safety re-verification 필수.

### 전제조건 / Apex helper
- `sf` CLI(org 인증) · Python(jq fallback)
- `apex/AgentforceOptimizeService.cls`(+`.cls-meta.xml`) — STDM 쿼리 메서드(`findSessions`, `getMultipleConversationDetails`, `getLlmStepDetails`, `getAggregatedMetrics`, `getMomentInsights`, `runObservabilityQuery`)를 노출하는 helper, org당 1회 배포.

---

## 번들 파일

| 카테고리 | 내용 (개수) |
|---|---|
| `references/` | 5 — `stdm-queries.md`(STDM 쿼리 절차·Apex 배포·응답 파싱), `issue-classification.md`(이슈 패턴 표·root cause 카테고리·구조 분석 check), `reproduce-reference.md`(Phase 2 preview·trace 진단·분류 기준), `improve-reference.md`(Phase 3 편집·배포 chain·verify·safety·test case), `stdm-schema.md`(DMO 필드 스키마·data hierarchy·agent name resolution) |
| `apex/` | `AgentforceOptimizeService.cls` + `.cls-meta.xml` (STDM 쿼리 helper, org당 1회 배포) |
| 루트 | `SKILL.md` |

---

## 관련 노트
- [[agentforce-d360-analyze]]
- [[agentforce-test]]
- [[agentforce-generate]]
- [[agentforce-architecture-analyze]]
