---
tags: [agent-skill, sf-skills, data-cloud, data360, connect, connectors]
source: forcedotcom/sf-skills (skills/data360-connect/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [data360-connect, 데이터클라우드 커넥트, Data Cloud Connect phase, connection, connector, 소스 연결, sf data360 connection]
---

# data360-connect — Data Cloud Connect 단계

> Data Cloud 소스 연결 작업: 커넥터 발견, 연결 메타데이터, 연결 테스트, 소스 객체 브라우징, 커넥터 스키마 검사, 외부 소스용 커넥터 정의 페이로드 준비.

## 목적과 활성화 조건

사용자가 **소스 연결 작업**이 필요할 때 사용한다: 커넥터 발견, 연결 메타데이터, 연결 테스트, 소스 객체 브라우징, 커넥터 스키마 검사, Snowflake·SharePoint Unstructured·Ingestion API 소스용 커넥터 정의 준비.

- **TRIGGER:** Data Cloud connections/connectors/connector metadata 관리, 연결 테스트, source 객체·DB 브라우징, 새 소스 시스템 셋업.
- **DO NOT TRIGGER:** data stream·DLO([[data360-prepare]]) / DMO·identity resolution([[data360-harmonize]]) / retrieval·search([[data360-query]]) / STDM 텔레메트리(agentforce-observe).
- **호환성:** `sf data360` CLI 플러그인 + Data Cloud 활성화 org 필요.

### 이 스킬이 작업을 소유하는 경우
- `sf data360 connection *`
- 커넥터 카탈로그 검사
- 연결 생성·수정·테스트·삭제
- source 객체·필드·DB·스키마 브라우징
- 이미 사용 중인 커넥터 타입 식별
- Snowflake / SharePoint Unstructured / Ingestion API 소스용 커넥터 정의 준비

위임: data stream·DLO 생성 → [[data360-prepare]] / DMO·mapping·IR·data graph → [[data360-harmonize]] / Data Cloud SQL·search-index → [[data360-query]].

### 먼저 수집할 컨텍스트
대상 org alias, 커넥터 타입/소스 시스템, 검사만 vs 라이브 변경, 기존 연결명/ID, CLI 외부 자격증명 구성 여부, 연결 직후 stream 생성 기대 여부, 소스가 DB·비정형 문서·Ingestion API 피드 중 무엇인지.

## 워크플로 / 단계

### 1. connect 작업 readiness 분류
```bash
node ../data360-orchestrate/scripts/diagnose-org.mjs -o <org> --phase connect --json
```

### 2. 커넥터 타입 발견
```bash
sf data360 connection connector-list -o <org> 2>/dev/null
sf data360 data-stream list -o <org> 2>/dev/null
```

### 3. 타입별 연결 검사
```bash
sf data360 connection list -o <org> --connector-type SalesforceDotCom 2>/dev/null
sf data360 connection list -o <org> --connector-type REDSHIFT 2>/dev/null
sf data360 connection list -o <org> --connector-type SNOWFLAKE 2>/dev/null
```

### 4. 특정 연결 또는 업로드된 스키마 검사
```bash
sf data360 connection get -o <org> --name <connection> 2>/dev/null
sf data360 connection objects -o <org> --name <connection> 2>/dev/null
sf data360 connection fields -o <org> --name <connection> 2>/dev/null
sf data360 connection schema-get -o <org> --name <connection-id> 2>/dev/null
```

### 5. 발견 후에만 테스트·생성
```bash
sf data360 connection test -o <org> --name <connection> --connector-type <type> 2>/dev/null
sf data360 connection create -o <org> -f connection.json 2>/dev/null
```

### 6. 외부 커넥터는 큐레이트된 예제 페이로드에서 시작
처음부터 페이로드를 발명하지 말고 단계 소유 예제를 사용한다: `examples/connections/`의 heroku-postgres / redshift / sharepoint-unstructured / snowflake-connection / ingest-api-connection / ingest-api-schema.

전형적 Ingestion API 셋업 흐름:
```bash
sf data360 connection create -o <org> -f examples/connections/ingest-api-connection.json 2>/dev/null
sf data360 connection schema-upsert -o <org> --name <connector-id> -f examples/connections/ingest-api-schema.json 2>/dev/null
sf data360 connection schema-get -o <org> --name <connector-id> 2>/dev/null
```

### 7. 알 수 없는 커넥터 타입의 페이로드 필드 발견
UI에서 하나 만든 뒤 REST로 직접 검사한다:
```bash
sf api request rest "/services/data/v66.0/ssot/connections/<id>" -o <org>
```

## 핵심 규칙·가드레일

- 플러그인 런타임을 먼저 검증한다(`../data360-orchestrate/references/plugin-setup.md`).
- 연결 변경 전 공유 readiness 분류기를 실행한다.
- 연결 생성보다 읽기 전용 발견을 선호한다.
- 표준 사용 시 `2>/dev/null`로 linked-plugin 경고 노이즈를 억제.
- `connection list`는 `--connector-type`이 필요하다.
- `connection test`는 비-Salesforce 연결을 이름으로 해석할 때 `--connector-type`을 전달.
- org가 낯설면 stream에서 기존 커넥터 타입을 먼저 발견.
- 커넥터 고유 자격증명·파라미터를 발명하기 전에 큐레이트된 예제 페이로드를 사용.
- 예제 밖 커넥터 타입은 UI로 만든 known-good 연결을 REST로 검사한 뒤 JSON 구축.
- 연결 생성이 성공한다고 모든 커넥터 타입에 API 기반 stream 생성을 약속하지 않는다.

### High-Signal Gotchas
- `connection list`에는 진짜 전역 "list all" 모드가 없다 — 커넥터 타입으로 질의.
- 커넥터 카탈로그 이름과 연결 커넥터 타입 라벨이 항상 같지 않다.
- `connection test`는 소스가 기본 Salesforce 커넥터가 아니면 이름 해석에 `--connector-type`이 필요할 수 있다.
- 빈 연결 목록은 보통 "비활성"이 아니라 "활성이지만 아직 미구성"을 의미.
- Heroku Postgres·Redshift·Snowflake·SharePoint Unstructured·Ingestion API는 각기 다른 자격증명·파라미터 형태 — 추측 대신 큐레이트 예제 재사용.
- SharePoint Unstructured는 `credentials` 배열에 `clientId`·`clientSecret`·`tokenEndpoint`를 사용하고 `parameters` 배열은 불필요.
- Snowflake는 key-pair 인증을 쓰며 API로 생성 가능한 경우가 많으나, 다운스트림 stream 생성은 UI 전용으로 남을 수 있다.
- Ingestion API 커넥터 셋업은 `connection schema-upsert`로 객체 스키마를 업로드하기 전까지 미완성.
- 일부 외부 커넥터 자격증명 셋업은 여전히 UI 측 구성이나 외부 시스템 권한에 의존.

### 출력 포맷
```text
Connect task: <inspect / create / test / update>
Connector type: <SalesforceDotCom / REDSHIFT / SNOWFLAKE / SPUnstructuredDocument / IngestApi / ...>
Target org: <alias>
Commands: <key commands run>
Verification: <passed / partial / blocked>
Next step: <prepare phase or connector follow-up>
```

## 번들 파일

| 분류 | 파일 |
|---|---|
| examples/connections (6) | `heroku-postgres.json`, `redshift.json`, `sharepoint-unstructured.json`, `snowflake-connection.json`, `ingest-api-connection.json`, `ingest-api-schema.json` |
| 공유 참조 (orchestrate) | `plugin-setup.md`, `feature-readiness.md`, `UPSTREAM.md`, `README.md` |

## 관련 노트
- [[data360-orchestrate]]
- [[data360-prepare]]
- [[data360-harmonize]]
- [[data360-query]]
