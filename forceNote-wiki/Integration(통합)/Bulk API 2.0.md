---
tags: [integration, bulk-api, rest-api, async, data-load, etl]
source: api_asynch.pdf (Bulk API 2.0 and Bulk API Developer Guide v67.0, Summer '26, Tier 2)
created: 2026-06-14
aliases: [Bulk API 2.0, Bulk API, 벌크 API, 대량 데이터 API, ingest job, query job, PK chunking, lineEnding]
---

# Bulk API 2.0

> 대량 레코드를 **비동기 잡(job)**으로 적재/추출하는 REST 기반 API. Bulk API 2.0은 배치 분할·병렬 처리를 **자동화**(CSV 업로드 후 결과 폴링)하고, 구형 Bulk API(v1)는 배치를 수동 관리한다.

> [!note] 공식 *Bulk API 2.0 and Bulk API Developer Guide v67.0* 발췌(핵심 digest). 전체 엔드포인트·필드는 가이드 참조.

---

## Bulk API 2.0 vs Bulk API (v1)

| 항목 | **Bulk API 2.0** | **Bulk API (v1)** |
|---|---|---|
| 인증 | 모든 OAuth 2.0 flow (다른 REST API와 동일) | `X-SFDC-Session` 헤더 (SOAP `login()`로 취득) |
| 적재 포맷 | **CSV 전용** | CSV·XML·JSON·바이너리 첨부 |
| 대용량 배치 | **자동** — 데이터 분할·병렬 처리를 플랫폼이 수행, 결과는 단일 엔드포인트 | **수동** — 커스텀 코드/수작업으로 배치 분할 |
| Big Object | Ingest·Query 지원 | Ingest·Query 지원 |

→ 신규 통합은 **Bulk API 2.0 권장**(배치 관리 불필요). 단, 복잡한 트리거가 있는 오브젝트에 큰 배치 적재는 비권장.

---

## 잡 상태 (Job States)

| 단계 | 상태 | 의미 |
|---|---|---|
| Creation | **Open** | ingest 잡 생성됨, 데이터 업로드 가능 |
| — | **UploadComplete** | (Ingest) 모든 데이터 업로드 완료, 처리 준비 / (Query) 처리 준비 |
| Processing | **InProgress** | Salesforce가 처리 중 — 자동 최적 배치/청킹·연산 수행 |
| Outcome | **JobComplete** | 처리 완료 |
| Outcome | **Aborted / Failed** | 중단/실패 |

---

## Ingest 흐름 (insert/update/upsert/delete/hardDelete)

```bash
# 1) 잡 생성 — POST /jobs/ingest  (object·operation·contentType·lineEnding)
curl https://MyDomain.my.salesforce.com/services/data/v67.0/jobs/ingest/ \
  -H "Authorization: Bearer <token>" -H "Content-Type: application/json" -d '{
    "object"      : "Account",
    "operation"   : "insert",
    "contentType" : "CSV",
    "lineEnding"  : "LF"
  }'
# → 응답: { "id":"750...", "state":"Open", "contentUrl":"services/data/67.0/jobs/ingest/750.../batches" }

# 2) CSV 데이터 업로드 — PUT {contentUrl}  (첫 행 = 필드명, 이후 행 = 레코드)
curl https://MyDomain.my.salesforce.com/services/data/v67.0/jobs/ingest/<jobId>/batches/ \
  -H "Authorization: Bearer <token>" -H "Content-Type: text/csv" --data-binary @accounts.csv

# 3) 업로드 완료 표시 — PATCH 잡 state = UploadComplete
curl -X PATCH .../jobs/ingest/<jobId>/ -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" -d '{ "state" : "UploadComplete" }'
```

- 처리 후 결과 조회: **successfulResults / failedResults / unprocessedrecords** (각 GET 엔드포인트)
- **upsert**: `operation:"upsert"` + 외부 ID 필드 지정
- 잡 관리: Get info / Delete / Abort / Get all jobs
- **응답 압축**: `gzip` (선택이나 권장)

### lineEnding
| 값 | OS |
|---|---|
| **LF** (`\n`, 기본값) | Unix / Linux / macOS |
| **CRLF** (`\r\n`) | Windows / DOS |

> CSV를 만든 텍스트 에디터의 줄바꿈 설정이 OS 기본을 덮어쓸 수 있으니, `lineEnding`을 CSV와 일치시킨다.

---

## Query 잡 + PK Chunking

- **Query 잡**: `POST /jobs/query`로 SOQL 쿼리 잡 생성 → InProgress → JobComplete → 결과 GET(병렬 결과·Locator 페이지네이션).
- **PK Chunking**: **1,000만 건 초과** 테이블 쿼리 시 권장. 청크 크기 **100,000~250,000** 권장(너무 작으면 빈 배치 생성).
- Query 잡 플랫폼 이벤트 구독(Beta)으로 완료 알림 가능.

---

## 한도 (Limits)

- Bulk API 2.0은 한도가 **단순화**되어 REST `/limits` 엔드포인트로 조회 가능.
- org는 24시간당 일정 수의 API 요청만 처리 → 전체 API 소비량을 통합별로 예산화.

---

## 관련 노트

- [[Data Loader]] — Bulk API/Bulk API 2.0를 UI·CLI로 사용하는 클라이언트
- [[Named Credential]] — 외부 호출 인증(OAuth) 구성
- [[Governor Limits]] — API 요청·대량 처리 한도
- [[Compression Namespace]] — gzip 등 압축 (Apex 측)
- [[통합 MOC]]
