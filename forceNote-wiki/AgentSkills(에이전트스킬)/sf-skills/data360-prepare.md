---
tags: [agent-skill, sf-skills, data-cloud, data360, prepare, ingestion]
source: forcedotcom/sf-skills (skills/data360-prepare/SKILL.md, 공식 Salesforce)
created: 2026-06-26
aliases: [data360-prepare, 데이터클라우드 프리페어, Data Cloud Prepare phase, data stream, DLO, 데이터 스트림, ingestion, Document AI]
---

# data360-prepare — Data Cloud Prepare 단계

> Data Cloud ingestion·레이크 준비 작업: data streams, Data Lake Objects(DLO), transforms, Document AI, 비정형 ingestion, 커넥터 셋업에서 라이브 스트림으로의 핸드오프.

## 목적과 활성화 조건

사용자가 **ingestion 및 레이크 준비 작업**이 필요할 때 사용한다: data streams, DLO, transforms, Document AI, 비정형 ingestion, 커넥터 셋업에서 라이브 스트림으로의 핸드오프.

- **TRIGGER:** Data Cloud data streams/DLOs/transforms/Document AI 구성 생성·관리, Data Cloud로의 ingestion 질문.
- **DO NOT TRIGGER:** 연결 셋업만([[data360-connect]]) / DMO·identity resolution([[data360-harmonize]]) / query·search([[data360-query]]).
- **호환성:** 외부 `sf data360` CLI 플러그인 + Data Cloud 활성화 org 필요.

### 이 스킬이 작업을 소유하는 경우
- `sf data360 data-stream *` · `sf data360 dlo *` · `sf data360 transform *` · `sf data360 docai *`
- 데이터가 Data Cloud로 어떻게 들어올지 선택
- 소스 업데이트 후 ingestion 재실행·재스캔
- 커넥터 셋업 완료 후 Ingestion API 기반 스트림 준비

위임: 소스 연결 생성·테스트 → [[data360-connect]] / DMO 매핑·IR·data graph 설계 → [[data360-harmonize]] / ingested 데이터 질의 → [[data360-query]].

## 워크플로 / 단계

### 1. prepare readiness 분류
```bash
node ../data360-orchestrate/scripts/diagnose-org.mjs -o <org> --phase prepare --json
```

### 2. 기존 ingestion 자산 검사
```bash
sf data360 data-stream list -o <org> 2>/dev/null
sf data360 dlo list -o <org> 2>/dev/null
```

### 3. 생성 전 스트림 카테고리 확인
카테고리 제안 규칙:

| Category | 용도 | 전형적 요구사항 |
|---|---|---|
| `Profile` | 사람/엔티티 레코드 | primary key |
| `Engagement` | 시간 기반 이벤트·상호작용 | primary key + event time field |
| `Other` | 참조/설정/보조 데이터셋 | primary key |

소스가 모호하면 데이터셋을 `Profile`/`Engagement`/`Other` 중 무엇으로 다룰지 사용자에게 명시적으로 물어본다.

### 4. 스트림 생성·검사
```bash
sf data360 data-stream get -o <org> --name <stream> 2>/dev/null
sf data360 data-stream create-from-object -o <org> --object Contact --connection SalesforceDotCom_Home 2>/dev/null
sf data360 data-stream create -o <org> -f stream.json 2>/dev/null
sf data360 data-stream run -o <org> --name <stream> 2>/dev/null
```

### 5. DLO 형태 확인
```bash
sf data360 dlo get -o <org> --name Contact_Home__dll 2>/dev/null
```

### 6. 올바른 refresh 메커니즘 선택
```bash
sf data360 data-stream run -o <org> --name <stream> 2>/dev/null
sf data360 connection run-existing -o <org> --name <connection-id> 2>/dev/null
```
- `data-stream run`은 스트림 수준 refresh/재스캔에 가장 가깝다.
- `connection run-existing`은 연결 수준 실행으로 일부 커넥터 워크플로에 유용하나, 비정형 소스의 스트림 refresh를 신뢰성 있게 대체하지 못한다.
- 비정형 문서 커넥터에서 새 파일 재스캔이 목표면 `data-stream run`을 선호.

### 7. 비정형 소스를 의도적으로 처리
SharePoint식 문서 ingestion의 최소 비정형 DLO 페이로드 예:
```json
{
  "name": "my_udlo",
  "label": "My UDLO",
  "category": "Directory_Table",
  "dataSource": {
    "sourceType": "SF_DRIVE",
    "directoryAndFilesDetails": [
      {
        "dirName": "SPUnstructuredDocument/<CONNECTION_ID>/<SITE_ID>",
        "fileName": "*"
      }
    ],
    "sourceConfig": {
      "reservedPrefix": "$dcf_content$"
    }
  }
}
```
풍부한 end-to-end 파이프라인이 필요한 최초 비정형 셋업은 UI를 사용한다 — UI 경로는 CLI bare DLO create가 자동 프로비저닝하지 못하는 문서 메타데이터 필드·다운스트림 자산을 시드할 수 있다.

### 8. send-data 워크플로엔 로컬 Ingestion API 예제 사용
외부 시스템이 Data Cloud로 레코드를 푸시할 때:
1. [[data360-connect]]에서 커넥터 생성
2. `sf data360 connection schema-upsert`로 스키마 업로드
3. 필요 시 UI에서 스트림 생성
4. `examples/ingestion-api/`의 로컬 예제로 레코드 전송

```bash
cd examples/ingestion-api
cp .env.example .env
python3 send-data.py
```
핵심 디테일: 인증은 staged 흐름(JWT → Salesforce token → Data Cloud token); ingestion 엔드포인트는 Salesforce instance URL이 아니라 tenant URL 사용; `202`는 처리 수락이지 즉시 질의 가능 의미 아님; 검증 실패는 흔히 Problem Records DLO 가족에 나타남.

### 9. 그 후에만 harmonization으로 이동
스트림·DLO가 건강하면 [[data360-harmonize]]로 핸드오프.

## 핵심 규칙·가드레일

- Data Cloud 명령 실행 전 외부 플러그인 런타임을 검증.
- ingestion 자산 변경 전 공유 readiness 분류기 실행.
- 새 ingestion 자산 생성 전 기존 스트림·DLO 검사를 선호.
- 정상 사용 시 `2>/dev/null`로 경고 노이즈 억제.
- DLO 네이밍·필드 네이밍을 CRM-native가 아닌 Data Cloud 고유로 취급.
- 스트림 생성 전 각 데이터셋을 `Profile`/`Engagement`/`Other` 중 무엇으로 다룰지 확인.
- 비정형 소스에선 스트림 수준 refresh와 연결 수준 rerun을 구분.
- 최초 스트림·비정형 자산 생성이 플랫폼 게이팅이면 UI 셋업을 의도적으로 사용.
- ingestion 자산이 명확히 건강할 때만 Harmonize로 핸드오프.

### High-Signal Gotchas
- CRM 기반 스트림 동작은 완전 커스텀 커넥터 프레임워크 ingestion과 같지 않다.
- `data-stream run`과 `connection run-existing`은 교환 불가 — 비정형 재스캔엔 스트림 수준 refresh 선호.
- `SFDC` 스트림은 플랫폼 관리 스케줄로 동기화 — `data-stream run`은 CRM 커넥터 refresh의 일반 제어 경로가 아니다.
- 일부 외부 DB 커넥터는 API로 생성 가능하나 스트림 생성은 UI 흐름/org 고유 브라우저 자동화 필요 — 모든 커넥터 타입에 순수 CLI 스트림 생성 경로를 약속하지 않는다.
- 최초 SharePoint식 비정형 셋업은 최소 CLI DLO create보다 UI에서 더 풍부할 수 있다.
- 스트림 삭제는 delete mode가 달리 지정하지 않으면 연관 DLO도 삭제할 수 있다.
- DLO 필드 네이밍은 CRM과 다르다(`__c` → `_c` 변환 포함).
- DLO 레코드 카운트는 list 출력 가정 대신 Data Cloud SQL로 질의.
- `CdpDataStreams`는 스트림 모듈이 현재 org/user에 게이팅됨을 의미 — 맹목적 재시도 대신 프로비저닝/권한 검토로 안내.

### 출력 포맷
```text
Prepare task: <stream / dlo / transform / docai>
Source: <connection + object>
Target org: <alias>
Artifacts: <stream names / dlo names / json definitions>
Verification: <passed / partial / blocked>
Next step: <harmonize or retrieve>
```

## 번들 파일

| 분류 | 파일 |
|---|---|
| examples/ingestion-api | `README.md`, `send-data.py` (외부→Data Cloud staged-auth 전송 예제) |
| 공유 참조 (orchestrate) | `assets/definitions/data-stream.template.json`, `references/plugin-setup.md`, `references/feature-readiness.md` |

## 관련 노트
- [[data360-orchestrate]]
- [[data360-connect]]
- [[data360-harmonize]]
- [[data360-query]]
