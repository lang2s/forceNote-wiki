---
tags: [agent-skill, sf-skills, data-cloud, data360, harmonize, identity-resolution]
source: forcedotcom/sf-skills (skills/data360-harmonize/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [data360-harmonize, 데이터클라우드 하모나이즈, Data Cloud Harmonize phase, DMO, identity resolution, 통합 프로파일, data graph, universal id]
---

# data360-harmonize — Data Cloud Harmonize 단계

> Data Cloud 스키마 조화·통합 작업: DMO, 필드 매핑, 관계, identity resolution, 통합 프로파일(unified profiles), data graph, universal ID 조회.

## 목적과 활성화 조건

사용자가 **스키마 조화·통합 작업**이 필요할 때 사용한다: DMO, 필드 매핑, 관계, identity resolution, 통합 프로파일, data graph, universal ID 조회.

- **TRIGGER:** DMOs, mappings, relationships, identity resolution, unified profiles, data graphs, universal IDs 작업.
- **DO NOT TRIGGER:** 스트림·DLO만([[data360-prepare]]) / segments·insights([[data360-segment]]) / retrieval·search([[data360-query]]) / STDM·세션 트레이싱(agentforce-observe).
- **호환성:** 외부 커뮤니티 `sf data360` CLI 플러그인 + Data Cloud 활성화 org 필요.

### 이 스킬이 작업을 소유하는 경우
- `sf data360 dmo *` · `sf data360 identity-resolution *` · `sf data360 data-graph *` · `sf data360 profile *` · `sf data360 universal-id lookup`

위임: 스트림 ingestion·DLO 구축 → [[data360-prepare]] / segment 로직·calculated insight → [[data360-segment]] / SQL·describe·search-index → [[data360-query]].

### 먼저 수집할 컨텍스트
소스 DLO와 타겟 DMO 이름, 작업이 스키마 생성·매핑·IR·graph 관련 중 무엇인지, 대상 org alias, ruleset 기존 존재 여부, 사용자가 원하는 통합 엔티티 모델.

## 워크플로 / 단계

### 1. harmonize readiness 분류
```bash
node ../data360-orchestrate/scripts/diagnose-org.mjs -o <org> --phase harmonize --json
```

### 2. 카탈로그 검사
```bash
sf data360 dmo list --all -o <org> 2>/dev/null
sf data360 identity-resolution list -o <org> 2>/dev/null
```

### 3. 매핑 전 스키마 검사
```bash
sf data360 query describe -o <org> --table ssot__Individual__dlm 2>/dev/null
sf data360 dmo get -o <org> --name ssot__Individual__dlm --json 2>/dev/null
```

### 4. 매핑을 의도적으로 생성·검토
```bash
sf data360 dmo mapping-list -o <org> --source Contact_Home__dll --target ssot__Individual__dlm 2>/dev/null
sf data360 dmo map-to-canonical -o <org> --dlo Contact_Home__dll --dmo ssot__Individual__dlm --dry-run 2>/dev/null
```

### 5. 매핑이 신뢰 가능할 때만 IR 실행
```bash
sf data360 identity-resolution create -o <org> -f ir-ruleset.json 2>/dev/null
sf data360 identity-resolution run -o <org> --name Main 2>/dev/null
```

## 핵심 규칙·가드레일

- 매핑 생성 전 DMO 스키마를 검사한다.
- harmonization 자산 변경 전 공유 readiness 분류기를 실행한다.
- 카탈로그 브라우징엔 `dmo list --all`을 선호하되, 빠른 readiness 체크엔 첫 페이지 `dmo list`를 사용.
- 지원되지 않는 describe 흐름을 발명하지 말고 `query describe` 또는 `dmo get --json`을 사용.
- identity resolution 실행을 비동기로 취급하고 실행 후 결과를 검증.
- 통합 프로파일 작업을 STDM/세션 트레이싱 작업과 분리해서 유지.

### High-Signal Gotchas
- `dmo list`는 보통 `--all`을 써야 한다.
- `query describe` 또는 `dmo get --json`을 사용 — `dmo describe` 명령은 없다.
- 매핑 및 관련 명령은 API-버전 차이에 민감할 수 있다.
- 통합 DMO 이름은 제네릭이 아니라 ruleset 고유다.
- data graph 정의는 필드 선택·관계 형태에 민감하다.
- `dmo list`는 동작하나 `identity-resolution list`가 게이팅되면 전체 Data Cloud 장애가 아니라 단계 고유 갭으로 취급.

### 출력 포맷
```text
Harmonize task: <dmo / mapping / relationship / ir / data-graph>
Source/target: <dlo → dmo or ruleset/graph names>
Target org: <alias>
Artifacts: <json files / commands>
Verification: <passed / partial / blocked>
Next step: <segment / retrieve / follow-up>
```

## 번들 파일

| 분류 | 파일 |
|---|---|
| 공유 참조 (orchestrate) | `README.md`, `references/feature-readiness.md` |
| assets/definitions (5 템플릿) | `dmo.template.json`, `mapping.template.json`, `relationship.template.json`, `identity-resolution.template.json`, `data-graph.template.json` |

## 관련 노트
- [[data360-orchestrate]]
- [[data360-prepare]]
- [[data360-segment]]
- [[data360-query]]
