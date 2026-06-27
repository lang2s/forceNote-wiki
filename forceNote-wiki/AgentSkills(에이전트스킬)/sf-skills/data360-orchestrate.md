---
tags: [agent-skill, sf-skills, data-cloud, data360, orchestrator, pipeline]
source: forcedotcom/sf-skills (skills/data360-orchestrate/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [data360-orchestrate, 데이터클라우드 오케스트레이터, Data Cloud orchestrator, sf data360, 데이터 스페이스, data space, data kit]
---

# data360-orchestrate — Salesforce Data Cloud 오케스트레이터

> connect→prepare→harmonize→segment→act(→retrieve) 다단계 Data Cloud 파이프라인을 조율하고, 단일 명령군이 아닌 제품 수준의 워크플로·교차 단계 트러블슈팅·data space·data kit를 다루는 상위 스킬.

## 목적과 활성화 조건

Salesforce Data Cloud의 **제품 수준 워크플로 가이드**가 필요할 때 사용한다. 단일 고립 명령군이 아니라 파이프라인 셋업, 교차 단계 트러블슈팅, data space, data kit, 또는 작업이 Connect/Prepare/Harmonize/Segment/Act/Retrieve 중 어디에 속하는지 결정해야 할 때다.

이 스킬은 sf-skills 하우스 스타일을 따르되 런타임으로 외부 커뮤니티 `sf data360` 명령 표면을 사용한다. **플러그인은 이 레포에 벤더링되지 않는다.**

- **TRIGGER:** 다단계 Data Cloud 파이프라인이 필요하거나, 여러 단계에 걸쳐 Data Cloud를 설정·트러블슈팅하거나, data space/data kit를 관리하거나, 교차 단계 `sf data360` 워크플로를 원할 때.
- **DO NOT TRIGGER:** 작업이 단일 단계에 한정됨(해당 단계 전용 스킬 사용) / STDM·세션 트레이싱·parquet 텔레메트리(agentforce-observe 스킬) / 표준 CRM SOQL(platform-soql-query) / Apex 구현(platform-apex-generate).
- **호환성:** 외부 커뮤니티 `sf data360` CLI 플러그인 + Data Cloud 활성화 org 필요.

### 이 스킬이 작업을 소유하는 경우

- 다단계 Data Cloud 셋업 또는 교정
- data space (`sf data360 data-space *`)
- data kit (`sf data360 data-kit *`)
- 헬스 체크 (`sf data360 doctor`)
- CRM→통합 프로파일 파이프라인 설계
- ingestion → harmonization → segmentation → activation 이동 결정
- 근본 원인이 아직 불분명한 교차 단계 트러블슈팅

### 단계별 위임 라우팅

| Phase | 위임 스킬 | 전형적 범위 |
|---|---|---|
| Connect | [[data360-connect]] | connections, connectors, source discovery |
| Prepare | [[data360-prepare]] | data streams, DLOs, transforms, DocAI |
| Harmonize | [[data360-harmonize]] | DMOs, mappings, identity resolution, data graphs |
| Segment | [[data360-segment]] | segments, calculated insights |
| Act | [[data360-activate]] | activations, activation targets, data actions |
| Retrieve | [[data360-query]] | SQL, search indexes, vector search, async query |

가족 밖 위임: 세션 트레이싱/STDM/parquet → agentforce-observe / CRM SOQL → platform-soql-query / CRM 소스 데이터 로딩 → platform-data-manage / 누락 CRM 스키마 → platform-custom-object-generate·platform-custom-field-generate / 다운스트림 Apex·Flow → platform-apex-generate·automation-flow-generate.

## 워크플로 / 단계

### 1. 런타임과 인증 검증
`sf` 설치, 커뮤니티 Data Cloud 플러그인 링크, 대상 org 인증을 확인한다.

```bash
sf data360 man
sf org display -o <alias>
bash ./scripts/verify-plugin.sh <alias>
```

`sf data360 doctor`는 단독 게이트가 아니라 광범위 헬스 신호로 취급한다. 부분 프로비저닝된 org에서는 connectors·DMOs·segments 같은 읽기 전용 명령군이 동작해도 실패할 수 있다.

### 2. 변경 전 readiness 분류
공유 분류기를 먼저 실행한다.

```bash
node ./scripts/diagnose-org.mjs -o <org> --json
```

테이블명이 실재함을 알 때만 query-plane 프로브를 사용한다.

```bash
node ./scripts/diagnose-org.mjs -o <org> --phase retrieve --describe-table MyDMO__dlm --json
```

분류기로 구분: empty-but-enabled 모듈 / feature-gated 모듈 / query-plane 이슈 / 런타임·인증 실패.

### 3. 읽기 전용 명령으로 기존 상태 탐색

```bash
sf data360 doctor -o <org> 2>/dev/null
sf data360 data-space list -o <org> 2>/dev/null
sf data360 data-stream list -o <org> 2>/dev/null
sf data360 dmo list -o <org> 2>/dev/null
sf data360 identity-resolution list -o <org> 2>/dev/null
sf data360 segment list -o <org> 2>/dev/null
sf data360 activation platforms -o <org> 2>/dev/null
```

### 4. 단계 지역화 (phase localization)
- source/connector 이슈 → Connect
- ingestion/DLO/stream 이슈 → Prepare
- mapping/IR/통합 프로파일 이슈 → Harmonize
- audience/insight 이슈 → Segment
- 다운스트림 푸시 이슈 → Act
- SQL/search/index 이슈 → Retrieve

### 5. 가능하면 결정적 아티팩트 선택
일회성 수동 단계보다 JSON 정의 파일·반복 가능 스크립트를 선호한다. 제네릭 템플릿은 `assets/definitions/` (data-stream, dmo, mapping, relationship, identity-resolution, data-graph, calculated-insight, segment, activation-target, activation, data-action-target, data-action, search-index).

### 6. 각 단계 후 검증
stream/DLO 존재, DMO/mapping 존재, IR 실행 완료, 통합 레코드·세그먼트 카운트 정상, activation/search index 상태 정상.

## 핵심 규칙·가드레일

- 외부 `sf data360` 플러그인 런타임을 사용하고, 명령 레이어를 재구현·벤더링하지 **않는다**.
- 작업이 지역화되면 가능한 한 가장 작은 단계 전용 스킬을 선호한다.
- 변경이 많은 작업 전 readiness 분류를 실행한다 — 실패한 한 명령으로 추측하지 말고 `scripts/diagnose-org.mjs`를 선호.
- `sf data360` 명령은 링크된 플러그인 경고 노이즈를 `2>/dev/null`로 억제(stderr 디버깅 필요 시 제외).
- **Data Cloud SQL**과 CRM SOQL을 구분한다.
- `sf data360 doctor`를 전체 제품 readiness 체크로 취급하지 **않는다** — 현재 업스트림 명령은 search-index 표면만 점검한다.
- `query describe`를 범용 테넌트 프로브로 취급하지 **않는다** — readiness 확인 후 알려진 DMO/DLO 테이블에만 사용.
- 중요한 경우 Data Cloud 고유 API-버전 우회책을 보존한다.
- org 고유 워크숍 페이로드보다 제네릭·재사용 가능 JSON 정의 파일을 선호한다.

### High-Signal Gotchas
- `connection list`는 `--connector-type`이 필요하다.
- `dmo list --all`은 전체 카탈로그가 필요할 때 유용하나, readiness 체크엔 첫 페이지 `dmo list`가 더 빠르고 충분한 경우가 많다.
- Segment 생성은 `--api-version 64.0`이 필요할 수 있다.
- `segment members`는 불투명 ID를 반환 — 사람이 읽을 디테일엔 SQL join 사용.
- `sf data360 doctor`는 부분 프로비저닝 org에서 일부 읽기 전용 명령이 동작해도 실패할 수 있다 — 표적 스모크 체크로 폴백.
- `query describe`의 `Couldn't find CDP tenant ID` / `DataModelEntity ... not found` 오류는 query-plane 단서이지 제품 전체 비활성화 증거가 아니다.
- 명령이 빨리 반환돼도 많은 장기 작업은 실제로 비동기다.
- 일부 Data Cloud 작업은 여전히 CLI 런타임 밖 UI 셋업이 필요하다.

### 출력 포맷
완료 시 보고 순서: 1) Task classification 2) Runtime status 3) Readiness classification 4) Phase(s) 5) Commands/artifacts 6) Verification result 7) Next step.

```text
Data Cloud task: <setup / inspect / troubleshoot / migrate>
Runtime: <plugin ready / missing / partially verified>
Readiness: <ready / ready_empty / partial / feature_gated / blocked>
Phases: <connect / prepare / harmonize / segment / act / retrieve>
Artifacts: <json files, commands, scripts>
Verification: <passed / partial / blocked>
Next step: <next phase, setup guidance, or cross-skill handoff>
```

## 번들 파일

이 스킬은 6단계 가족의 공유 자산 허브다.

| 분류 | 파일 |
|---|---|
| references | `references/feature-readiness.md` (실패 분류: 런타임/인증/프로비저닝/게이팅/empty/잘못된 프로브), `references/plugin-setup.md` (커뮤니티 플러그인 셋업), `README.md`, `UPSTREAM.md` |
| scripts | `scripts/bootstrap-plugin.sh`, `scripts/verify-plugin.sh`, `scripts/diagnose-org.mjs` (공유 readiness 분류기), `scripts/generate-manifest.mjs` |
| assets/definitions (13 템플릿) | activation, activation-target, data-action, data-action-target, calculated-insight, data-graph, data-stream, dmo, identity-resolution, mapping, relationship, search-index, segment `.template.json` |

## 관련 노트
- [[data360-connect]]
- [[data360-prepare]]
- [[data360-harmonize]]
- [[data360-segment]]
- [[data360-activate]]
- [[data360-query]]
