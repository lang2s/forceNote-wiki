---
tags: [agent-skill, sf-skills, data-cloud, data360, retrieve, search-index]
source: forcedotcom/sf-skills (skills/data360-query/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [data360-query, 데이터클라우드 쿼리, Data Cloud Retrieve phase, Data Cloud SQL, vector search, hybrid search, 검색 인덱스, search index, async query]
---

# data360-query — Data Cloud Retrieve 단계

> Data Cloud 질의·검색·메타데이터 introspection: 동기 SQL, 페이지네이션 SQL, async query 워크플로, table describe, vector search, hybrid search, search index 작업.

## 목적과 활성화 조건

사용자가 Data Cloud의 **질의·검색·메타데이터 introspection**이 필요할 때 사용한다: 동기 SQL, 페이지네이션 SQL, async query, table describe, vector search, hybrid search, search index 작업.

- **TRIGGER:** Data Cloud SQL, describe, async query, vector search, search-index 워크플로, Data Cloud 객체 메타데이터 introspection 실행.
- **DO NOT TRIGGER:** 표준 CRM SOQL(platform-soql-query) / segment 생성·calculated insight 설계([[data360-segment]]) / STDM·세션 트레이싱·parquet 분석(agentforce-observe).
- **호환성:** 외부 커뮤니티 `sf data360` CLI 플러그인 + Data Cloud 활성화 org 필요.

### 이 스킬이 작업을 소유하는 경우
- `sf data360 query *` · `sf data360 search-index *` · `sf data360 metadata *`
- `sf data360 profile *` 또는 `sf data360 insight *` 검사
- Data Cloud SQL 결과·query shape 이해

위임: 표준 CRM SOQL만 → platform-soql-query / segment·calculated insight 자산 설계 → [[data360-segment]] / STDM·세션 트레이싱·parquet 텔레메트리 분석 → agentforce-observe.

### 먼저 수집할 컨텍스트
대상 org alias, quick count·medium result·large export·schema inspection·semantic search 중 필요한 것, 알려진 table/index 이름, 작업이 읽기 전용 SQL인지 search-index 라이프사이클 관리인지.

## 워크플로 / 단계

### 1. retrieve readiness 분류
```bash
node ../data360-orchestrate/scripts/diagnose-org.mjs -o <org> --phase retrieve --json
# optional query-plane probe, only with a real table name
node ../data360-orchestrate/scripts/diagnose-org.mjs -o <org> --phase retrieve --describe-table MyDMO__dlm --json
```

### 2. 가장 작은 올바른 query shape 선택
```bash
sf data360 query sql -o <org> --sql 'SELECT COUNT(*) FROM "ssot__Individual__dlm"' 2>/dev/null
sf data360 query sqlv2 -o <org> --sql 'SELECT * FROM "ssot__Individual__dlm"' 2>/dev/null
sf data360 query async-create -o <org> --sql 'SELECT * FROM "ssot__Individual__dlm"' 2>/dev/null
```

### 3. 필드 추측 전 describe 사용
```bash
sf data360 query describe -o <org> --table ssot__Individual__dlm 2>/dev/null
```

### 4. 인덱스가 존재할 때만 vector·hybrid search 사용
```bash
sf data360 search-index list -o <org> 2>/dev/null
sf data360 query vector -o <org> --index Knowledge_Index --query "reset password" --limit 5 2>/dev/null
sf data360 query hybrid -o <org> --index Knowledge_Index --query "reset password" --limit 5 2>/dev/null
sf data360 query hybrid -o <org> --index Insurance_Index --query "weather damage coverage" --prefilter "Type_of_Insurance__c='Home'" --limit 10 2>/dev/null
```

### 5. 인덱스 생성 시 큐레이트된 search-index 예제 재사용
처음부터 JSON을 발명하지 말고 단계 소유 예제를 사용: `examples/search-indexes/vector-knowledge.json`, `examples/search-indexes/hybrid-structured.json`.

## 핵심 규칙·가드레일

- Data Cloud SQL을 SOQL이 아닌 독자적 질의 언어로 취급한다.
- query/search 표면에 의존하기 전 공유 readiness 분류기를 실행한다.
- 컬럼 추측 전 describe를 사용한다.
- 더 큰 결과 집합엔 `sqlv2` 또는 async query 흐름을 선호한다.
- search index 라이프사이클이 건강할 때만 vector·hybrid search를 사용한다.
- STDM/parquet/세션 트레이싱 워크플로를 이 스킬 가족 밖으로 유지한다.

### High-Signal Gotchas
- Data Cloud SQL은 SOQL이 아니다.
- SQL에서 테이블 이름은 큰따옴표로 감싼다.
- 중간 결과 집합엔 ad hoc OFFSET 페이징보다 `sqlv2`가 낫다.
- 대량 결과엔 async query가 더 낫다.
- search-index 작업과 vector/hybrid query는 인덱스 라이프사이클이 건강한지에 의존한다.
- Hybrid search는 `--prefilter`를 쓸 수 있으나, search index 생성 시 prefilter-capable로 구성된 필드에만 가능하다.
- HNSW 인덱스 파라미터는 보통 create 시 읽기 전용 — 플랫폼이 명시적으로 문서화하지 않으면 `userValues: []`로 둔다.
- `query describe`는 범용 테넌트 프로브가 아니다 — 더 넓은 readiness 확인 후 알려진 DMO/DLO 테이블에만 실행.

### 출력 포맷
```text
Retrieve task: <sql / sqlv2 / async / describe / vector / search-index>
Target org: <alias>
Target object: <table or index>
Commands: <key commands run>
Verification: <query rows / schema / status>
Next step: <segment / harmonize / follow-up>
```

## 번들 파일

| 분류 | 파일 |
|---|---|
| examples/search-indexes (2) | `vector-knowledge.json`, `hybrid-structured.json` |
| 공유 참조 (orchestrate) | `assets/definitions/search-index.template.json`, `references/plugin-setup.md`, `references/feature-readiness.md` |

## 관련 노트
- [[data360-orchestrate]]
- [[data360-harmonize]]
- [[data360-segment]]
- [[data360-activate]]
