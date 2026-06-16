---
tags: [integration, bulk-api, rest-api, async, data-load, etl]
source: api_asynch.pdf (Bulk API 2.0 and Bulk API Developer Guide v67.0, Summer '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/
created: 2026-06-14
updated: 2026-06-14
aliases: [Bulk API 2.0, Bulk API, 벌크 API, 대량 데이터 API, ingest job, query job, PK chunking, lineEnding, columnDelimiter, JobStateEnum]
---

# Bulk API 2.0

> 대량 레코드를 **비동기 잡(job)**으로 적재(ingest)/추출(query)하는 REST 기반 API. 2.0은 배치 분할·병렬을 **자동화**(CSV 업로드 후 결과 폴링), 구형 Bulk API(v1)는 배치 수동 관리. 잡당 **150MB**(base64), **1만 레코드당 배치**, 일 **1.5억** 레코드.

> [!note] *Bulk API 2.0 and Bulk API Developer Guide v67.0* 전수 정리. 클라이언트 사용은 [[Data Loader]].

---

## Bulk API 2.0 vs Bulk API (v1)

| 항목 | **Bulk API 2.0** | **Bulk API (v1)** |
|---|---|---|
| 인증 | 모든 OAuth 2.0 flow | `X-SFDC-Session`(SOAP `login()`로 취득) |
| 적재 포맷 | **CSV 전용** | CSV·XML·JSON·바이너리 첨부 |
| 배치 처리 | **자동** — 데이터 분할·병렬, 결과는 단일 엔드포인트 | **수동** — 커스텀 코드/수작업 배치 |
| 지원 API 버전 | 41.0+ (Ingest), 47.0+ (Query) | 21.0+ |
| Big Object | Ingest·Query | Ingest·Query |

→ 신규 통합은 **2.0 권장**. 단, 복잡한 트리거 오브젝트에 큰 배치는 비권장.

---

## 잡 상태 (JobStateEnum)

| 상태 | 의미 |
|---|---|
| **Open** | 잡 생성됨, 데이터 추가 가능 |
| **UploadComplete** | 새 데이터 추가 불가. 편집/저장 불가(Salesforce 처리 중) |
| **InProgress** | 처리 중 — 자동 최적 배치/청킹·연산 수행 (Query) |
| **Aborted** | 잡 중단됨(생성자 또는 "Manage Data Integrations" 권한자) |
| **JobComplete** | 처리 완료 |
| **Failed** | 일부 레코드 실패. 성공 처리분은 롤백되지 않음 |

---

## Ingest 잡 — 적재 (insert/update/upsert/delete/hardDelete)

### 1) Create a Job — `POST /jobs/ingest/`

```bash
curl https://MyDomain.my.salesforce.com/services/data/v67.0/jobs/ingest/ \
  -H "Authorization: Bearer <token>" -H "Content-Type: application/json" -d '{
    "object" : "Account", "operation" : "insert",
    "contentType" : "CSV", "lineEnding" : "LF", "columnDelimiter" : "COMMA"
  }'
```

**Request Body 필드 (전수)**

| 필드 | 타입 | 필수 | 설명 |
|---|---|---|---|
| `object` | string | ✔ | 처리할 오브젝트 타입(잡당 단일 타입) |
| `operation` | OperationEnum | ✔ | `insert` / `delete` / `hardDelete` / `update` / `upsert` |
| `contentType` | ContentType | | 유일·기본값 **CSV** |
| `lineEnding` | LineEndingEnum | | `LF`(기본) / `CRLF` |
| `columnDelimiter` | ColumnDelimiterEnum | | `COMMA`(기본·콤마) / `BACKQUOTE`(백쿼트) / `CARET`(캐럿) / `PIPE`(파이프) / `SEMICOLON`(세미콜론) / `TAB`(탭) |
| `externalIdFieldName` | string | upsert 시 ✔ | 업데이트 대상 오브젝트의 외부 ID 필드(CSV에도 값 존재해야) |
| `assignmentRuleId` | string | | Case/Lead용 배정 규칙 ID(active/inactive 가능, v49.0+) |

**Response Body 필드 (전수)** — 위 요청 필드 +

| 필드 | 타입 | 설명 |
|---|---|---|
| `id` | string | 잡 고유 ID |
| `state` | JobStateEnum | 현재 상태(생성 시 `Open`) |
| `contentUrl` | URL | 데이터 업로드용 URL(Open 상태에서만 유효) |
| `apiVersion` | string | 잡 생성 API 버전 |
| `jobType` | JobTypeEnum | `V2Ingest`(2.0) / `Classic`(1.0) / `BigObjectIngest` |
| `concurrencyMode` | enum | 현재 `Parallel`만(향후용, API가 자동 선택) |
| `createdById` | string | 생성 사용자 ID |
| `createdDate` | dateTime | 생성 일시(UTC) |
| `systemModstamp` | dateTime | 잡 완료 일시(UTC) |

### 2) Upload Job Data — `PUT {contentUrl}`

```bash
# 첫 행 = 필드명, 이후 행 = 레코드. contentUrl은 Create 응답에서 얻음
curl https://MyDomain.my.salesforce.com/services/data/v67.0/jobs/ingest/<jobId>/batches/ \
  -H "Authorization: Bearer <token>" -H "Content-Type: text/csv" \
  --data-binary @accounts.csv
# → 201 Created (데이터 수신 성공)
```

### 3) Close/Abort — `PATCH /jobs/ingest/{id}/`

```bash
# 업로드 완료 → 처리 시작
curl -X PATCH .../jobs/ingest/<jobId>/ -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" -d '{ "state" : "UploadComplete" }'
# 중단: { "state" : "Aborted" }
```

- **Delete a Job** — `DELETE /jobs/ingest/{id}/` → 204 (JobComplete/Aborted 상태만)
- **Get all jobs** — `GET /jobs/ingest/`

### 4) Get Job Info — `GET /jobs/ingest/{id}/`

처리 결과 메트릭(전수):

| 필드 | 타입 | 설명 |
|---|---|---|
| `numberRecordsProcessed` | int | 처리된 레코드 수 |
| `numberRecordsFailed` | int | 실패 레코드 수 |
| `retries` | int | 재시도 횟수 |
| `totalProcessingTime` | long | 총 처리 시간(ms) |
| `apiActiveProcessingTime` | long | 활성 처리 시간(ms, apexProcessingTime 포함, 대기 제외) |
| `apexProcessingTime` | long | 트리거 등 처리 시간(ms, 비동기/배치 Apex 제외, 트리거 없으면 0) |

### 5) 결과 조회

| 결과 | 엔드포인트 |
|---|---|
| 성공 레코드 | `GET /jobs/ingest/{id}/successfulResults/` |
| 실패 레코드 | `GET /jobs/ingest/{id}/failedResults/` |
| 미처리 레코드 | `GET /jobs/ingest/{id}/unprocessedrecords/` |

- 응답 CSV에 `sf__Id`·`sf__Error` 컬럼 추가됨.
- **응답 압축**: `gzip`(권장).

---

## Query 잡 — 추출

### Create a Query Job — `POST /jobs/query/`

```bash
curl .../services/data/v67.0/jobs/query/ -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" -d '{
    "operation" : "query",        # query | queryAll(삭제·아카이브 포함)
    "query" : "SELECT Id, Name FROM Account",
    "contentType" : "CSV", "columnDelimiter" : "COMMA", "lineEnding" : "LF"
  }'
```

### Get Results — `GET /jobs/query/{id}/results`

페이지네이션 헤더/파라미터:

| 항목 | 설명 |
|---|---|
| `maxRecords` (쿼리 파라미터) | 결과 1세트당 최대 레코드 수. 타임아웃 방지용으로 작게 분할 |
| `Sforce-Locator` (응답 헤더) | 다음 결과 세트 locator. 잡 존재 동안 불변, 재조회 가능. 마지막엔 `null` |
| `Sforce-NumberOfRecords` (응답 헤더) | 이 세트의 레코드 수 |

- **PK Chunking**: **1,000만 건 초과** 테이블 쿼리 시 권장. 청크 크기 **100,000~250,000** 권장(작으면 빈 배치).
- Query 잡 플랫폼 이벤트 구독(Beta)으로 완료 알림.

---

## 헤더

| 헤더 | 용도 |
|---|---|
| **Content-Type** | 업로드 `text/csv`, 잡 생성 `application/json` |
| **Line Ending** | (요청 필드 `lineEnding`) `LF`(Unix/기본) / `CRLF`(Windows) |
| **Sforce-Call-Options** | client 식별 등 호출 옵션 |

---

## 한도 (Limits)

- 잡당 업로드 **최대 150MB**(base64 인코딩 후). base64는 ~50% 증가하므로 **원본 ≤100MB** 권장.
- Salesforce가 잡 데이터를 **1만 레코드마다 별도 배치**로 분할, **일 최대 1.5억(150,000,000) 레코드**.
- 실패 배치는 **자동 최대 20회 재시도**, 그래도 실패 시 전체 잡 실패.
- 한도는 REST **`/limits`** 엔드포인트로 조회.
- Developer Edition은 데이터 저장 **5MB** 상한.

---

## 상태/에러 코드

| 코드 | 의미 |
|---|---|
| 201 Created | 잡 생성/데이터 수신 성공 |
| 200 OK | 조회 성공 |
| 204 No Content | 삭제 성공 |
| 300 | (upsert) 외부 ID 값이 유일하지 않음 — 매칭 레코드 목록 반환 |
| (24h 초과) | 지난 24시간 허용 잡/배치 수 초과 |

---

## 관련 노트

- 📖 공식: [Bulk API 2.0 and Bulk API Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/)
- [[Data Loader]] — Bulk API/2.0를 UI·CLI로 사용하는 클라이언트(최대 1.5억 건)
- [[대용량 데이터 (LDV) — 대량 로드·삭제]] — Bulk API 2.0가 LDV 대량 로드·hard delete 전략에서 차지하는 위치
- [[REST API]] — 소량~중간 동기 CRUD/쿼리
- [[Named Credential]] — 외부 호출 인증
- [[Compression Namespace]] — gzip 압축(Apex)
- [[통합 MOC]]
