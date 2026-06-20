---
tags: [integration, rest-api, sobjects, composite, soql-rest]
source: api_rest.pdf (REST API Developer Guide v67.0, Summer '26, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/
created: 2026-06-14
updated: 2026-06-14
aliases: [REST API, 표준 REST API, sObjects REST, Composite, Composite Graph, sObject Tree, sObject Collections, queryAll, REST 헤더, REST status codes]
---

# REST API

> Salesforce **표준 REST API** — `/services/data/vXX.0/`로 레코드 CRUD·SOQL 쿼리·메타데이터·복합(Composite) 요청. 리소스 = URI로 노출되는 데이터(레코드·컬렉션·쿼리결과·메타데이터). OAuth 2.0, JSON/XML. 소량~중간 동기 통합(대량은 [[Bulk API 2.0]]).

> [!note] *REST API Developer Guide v67.0* 전수 정리. 📖 공식: [REST API Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/)

---

## 기본 구조

- **Base URI**: `https://MyDomain.my.salesforce.com/services/data/v67.0/`
- **인증**: External Client App / Connected App + **OAuth 2.0** (`Authorization: Bearer <token>`)
- **포맷**: JSON(기본)·XML, `Content-Type: application/json`

### 디스커버리 리소스
| 리소스 | 엔드포인트 |
|---|---|
| 버전 목록 | `GET /services/data/` |
| 사용 가능 리소스 | `GET /services/data/v67.0/` |
| org 한도 | `GET /services/data/v67.0/limits/` |
| 오브젝트 목록 | `GET /services/data/v67.0/sobjects/` |

> [!warning] macOS/Linux cURL에서 access token의 `!`는 에러 → `\!` 이스케이프 또는 토큰을 **작은따옴표**로 감싼다.

---

## 요청 헤더 (전수)

| 헤더 | 용도 |
|---|---|
| **Assignment Rule** (`Sforce-Auto-Assign`) | Case/Lead 생성·수정 시 배정 규칙 적용 여부 |
| **Call Options** (`Sforce-Call-Options`) | client 식별 등 호출 옵션 |
| **Compression** (`Accept-Encoding`/`Content-Encoding`) | `gzip`/`deflate` 압축 요청·응답 |
| **Conditional Request** (`If-Modified-Since`/`If-Unmodified-Since`/`If-Match`/`If-None-Match`) | 변경 시에만 처리(미변경 시 304) |
| **Duplicate Rule** (`Sforce-Duplicate-Rule-Header`) | 중복 규칙 적용·허용 제어 |
| **Limit Info** (`Sforce-Limit-Info`) | (응답) API 사용량/한도 정보 |
| **MRU** (`Sforce-Mru`) | 최근 사용(Most Recently Used) 목록 갱신 |
| **Package Version** (`Sforce-Package-Version`) | 설치 패키지 버전 지정 |
| **Query Options** (`Sforce-Query-Options`) | `batchSize`(쿼리 결과 배치 크기 200~2000) |
| **Warning** (`Sforce-Warning`) | (응답) 사용 중단 등 경고 |

---

## 레코드 CRUD (sObjects)

```bash
# 생성 — POST /sobjects/{Object}/   → 201 { "id":"001...", "success":true, "errors":[] }
curl https://MyDomain.my.salesforce.com/services/data/v67.0/sobjects/Account/ \
  -H "Authorization: Bearer <token>" -H "Content-Type: application/json" \
  --data-binary @new-account.json -X POST

# 조회 — GET /sobjects/{Object}/{id}        (특정 필드: ?fields=Name,Phone)
# 수정 — PATCH /sobjects/{Object}/{id}      (변경 필드만 JSON) → 204
# 삭제 — DELETE /sobjects/{Object}/{id}     → 204
# 메타데이터 — GET /sobjects/{Object}/describe/   (필드·관계 전체)
# 기본정보 — GET /sobjects/{Object}/         (urls: sobject/describe/rowTemplate)
```

| 리소스 | 엔드포인트 | 용도 |
|---|---|---|
| sObject Rows | `/sobjects/{Object}/{id}` | GET·PATCH·DELETE 단건 |
| sObject Basic Info | `/sobjects/{Object}/` | POST 생성, 메타 |
| sObject Describe | `/sobjects/{Object}/describe/` | 필드·관계 전체 describe |
| **Upsert (외부 ID)** | `PATCH /sobjects/{Object}/{ExtIdField}/{value}` | 매칭 시 update, 없으면 create |
| 외부 ID로 조회 | `GET /sobjects/{Object}/{ExtIdField}/{value}` | |
| Blob 필드 | `/sobjects/{Object}/{id}/{blobField}` | 첨부·문서 바이너리 |
| getDeleted / getUpdated | `/sobjects/{Object}/deleted/` · `/updated/` | 기간 내 삭제·변경 ID |
| Relationships | `/sobjects/{Object}/{id}/{relationshipField}` | 연결 레코드 탐색 |

---

## SOQL / SOSL 쿼리

```bash
# SOQL — GET /query?q=...
curl -G https://MyDomain.my.salesforce.com/services/data/v67.0/query \
  --data-urlencode "q=SELECT Id, Name FROM Account WHERE Industry='Tech'" \
  -H "Authorization: Bearer <token>"
# → { "totalSize":N, "done":true|false, "nextRecordsUrl":"/services/data/v67.0/query/01g...-2000", "records":[...] }
```

| 리소스 | 엔드포인트 |
|---|---|
| Query | `GET /query?q={SOQL}` |
| QueryAll (삭제·아카이브 포함) | `GET /queryAll?q={SOQL}` |
| 다음 페이지 | `GET {nextRecordsUrl}` (`done:false`일 때) |
| Query Explain (실행 계획) | `GET /query?explain={SOQL}` |
| SOSL Search | `GET /search?q={SOSL}` |
| Named Query API | 저장된 커스텀 SOQL을 REST로 (Spring '26 GA) |

---

## Composite — 한 번에 여러 작업

| 리소스 | 엔드포인트 | 한도/특징 |
|---|---|---|
| **Composite** | `POST /composite` | 최대 **25 서브요청**, 앞 결과를 `@{refId.field}`로 참조 |
| **Composite Graph** | `POST /composite/graph` | 의존 그래프, 서브요청 **최대 500**. 그래프 단위로 allOrNone=true 암시 |
| **Composite Batch** | `POST /composite/batch` | 독립 서브요청 묶음(서로 참조 불가) |
| **sObject Tree** | `POST /composite/tree/{Object}` | 부모-자식 **중첩 레코드 한 번에 생성** |
| **sObject Collections** | `/composite/sobjects` (POST/GET/PATCH/DELETE) | 레코드 **최대 200건**, `allOrNone` |

```bash
# sObject Collections — 여러 레코드 한 번에
curl https://MyDomain.my.salesforce.com/services/data/v67.0/composite/sobjects/ \
  -H "Authorization: Bearer <token>" -H "Content-Type: application/json" -d '{
    "allOrNone" : false,
    "records" : [
      { "attributes":{"type":"Account"}, "Name":"Acme" },
      { "attributes":{"type":"Account"}, "Name":"Global" }
    ]
  }'
```

> **allOrNone**: `true`면 하나라도 실패 시 전체 롤백. Composite가 sObject Collections를 포함하면 allOrNone 파라미터가 2개 이상 상호작용(외부 composite + 내부 collections). Composite Graph는 각 그래프가 암시적으로 allOrNone=true.

---

## 상태/에러 코드

| 코드 | 의미 |
|---|---|
| **200** OK | GET·HEAD·일부 PATCH 성공 |
| **201** Created | POST·일부 PATCH 성공 |
| **204** No Content | DELETE·일부 PATCH 성공 |
| **300** Multiple Choices | (upsert) 외부 ID 값이 유일하지 않음 — 매칭 레코드 목록 |
| **304** Not Modified | 조건부 요청에서 미변경(본문 없음) |
| **400** Bad Request | JSON/XML 본문 오류 등 요청 이해 불가 |
| **401** Unauthorized | 세션 만료/무효 (`errorCode`) |
| **403** Forbidden | 권한 부족·요청 거부 |
| **404** Not Found | 리소스 없음 |
| **405** Method Not Allowed | 해당 HTTP 메서드 미지원 |
| **415** Unsupported Media Type | 미지원 포맷 |
| **500** / **503** | 서버 오류 / 서비스 불가 |

에러 응답 본문: HTTP 코드 + 메시지 + (해당 시) 오류 발생 필드/오브젝트, `errorCode`.

---

## 날짜·시간 형식

- **dateTime**: `yyyy-MM-ddTHH:mm:ss.SSS+/-HH:mm` 또는 `...Z`(UTC). 예: `2002-10-10T12:00:00+05:00` = `2002-10-10T07:00:00Z`
- **date**: `yyyy-MM-dd` (offset 미지원)

---

## 비교 — 어떤 API를 쓰나

| 상황 | API |
|---|---|
| 소량~중간 동기 CRUD/쿼리 | **REST API** (본 노트) |
| 대량(수만~1.5억) 비동기 | [[Bulk API 2.0]] |
| 여러 작업 1 왕복 | Composite / sObject Collections |
| 액션 호출(표준/Apex) | [[Actions API]] |
| 외부 → SF 커스텀 엔드포인트 | [[Custom REST Endpoint]] |
| UI 메타데이터·레이아웃 인지 | [[UI API 개요]] |

---

## 관련 노트

- 📖 공식: [REST API Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/)
- [[Bulk API 2.0]] — 대량 비동기 데이터 API
- [[Actions API]] — Invocable Action REST 호출
- [[Custom REST Endpoint]] — Apex `@RestResource` 인바운드
- [[Named Credential]] — 외부 호출 인증·URL 관리
- [[UI API 개요]] — UI 인지 REST(LWC/모바일)
- [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] — 24시간 API 콜 할당량·동시 요청·타임아웃·`/limits`·요청 크기 한도 전체
- [[통합 MOC]]
