---
tags: [integration, rest-api, sobjects, composite, soql-rest]
source: api_rest.pdf (REST API Developer Guide v67.0, Summer '26, Tier 2)
created: 2026-06-14
aliases: [REST API, 표준 REST API, sObjects REST, Composite, Composite Graph, sObject Tree, sObject Collections, /services/data, queryAll]
---

# REST API

> Salesforce **표준 REST API** — `/services/data/vXX.0/`로 레코드 CRUD·SOQL 쿼리·메타데이터·복합(Composite) 요청. OAuth 2.0 인증, JSON/XML. 소량~중간 규모 동기 통합에 적합(대량은 [[Bulk API 2.0]]).

> [!note] 공식 *REST API Developer Guide v67.0* 핵심 digest. 전체 리소스·헤더·필드는 가이드 참조.

---

## 기본 구조

- **Base URI**: `https://MyDomain.my.salesforce.com/services/data/v67.0/`
- **인증**: External Client App / Connected App + **OAuth 2.0** (`Authorization: Bearer <token>`)
- **포맷**: JSON(기본)·XML, `Content-Type: application/json`
- 버전 목록: `GET /services/data/`, 사용 가능 리소스: `GET /services/data/v67.0/`, org 한도: `GET /services/data/v67.0/limits/`

> [!warning] macOS/Linux cURL에서 access token의 `!`는 에러 유발 → `\!`로 이스케이프하거나 토큰을 **작은따옴표**로 감싼다.

---

## 레코드 CRUD (sObjects)

```bash
# 생성 — POST /sobjects/{Object}/
curl https://MyDomain.my.salesforce.com/services/data/v67.0/sobjects/Account/ \
  -H "Authorization: Bearer <token>" -H "Content-Type: application/json" \
  --data-binary @new-account.json -X POST
# → 201 { "id":"001...", "success":true, "errors":[] }

# 조회 — GET /sobjects/{Object}/{id}   (특정 필드: ?fields=Name,Phone)
curl .../sobjects/Account/001D000000INjVe -H "Authorization: Bearer <token>"

# 수정 — PATCH /sobjects/{Object}/{id}  (변경 필드만 JSON) → 204
curl .../sobjects/Account/001D000000INjVe -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" --data-binary @patch.json -X PATCH

# 삭제 — DELETE /sobjects/{Object}/{id} → 204
curl .../sobjects/Account/001D000000INjVe -X DELETE -H "Authorization: Bearer <token>"

# 메타데이터 — GET /sobjects/{Object}/describe/  (필드·관계 describe)
```

- **Upsert (외부 ID)**: `PATCH /sobjects/{Object}/{ExtIdField}/{value}`

---

## SOQL/SOSL 쿼리

```bash
# SOQL — GET /query?q=...
curl -G https://MyDomain.my.salesforce.com/services/data/v67.0/query \
  --data-urlencode "q=SELECT Id, Name FROM Account WHERE Industry='Tech'" \
  -H "Authorization: Bearer <token>"
# → { "totalSize":N, "done":true|false, "nextRecordsUrl":"...", "records":[...] }
```

- **queryAll** (`/queryAll`) — 삭제·아카이브 레코드 포함
- 페이지네이션: 응답의 `nextRecordsUrl`을 GET (`done:false`일 때)
- **Named Query API** — 저장된 커스텀 SOQL을 REST로 노출 (Spring '26 GA)

---

## Composite — 한 번에 여러 작업

| 리소스 | 용도 |
|---|---|
| **Composite** (`/composite`) | 최대 25개 서브요청을 1 호출로, 앞 요청 결과를 `@{refId.field}`로 참조 |
| **Composite Graph** (`/composite/graph`) | 의존 그래프로 대량 연관 레코드 생성(서브요청 한도 ↑) |
| **Composite Batch** (`/composite/batch`) | 독립 서브요청 묶음 실행 |
| **sObject Tree** (`/composite/tree/{Object}`) | 부모-자식 **중첩 레코드 한 번에 생성** |
| **sObject Collections** (`/composite/sobjects`) | 레코드 **최대 200건** CRUD, `allOrNone` 옵션 |

```bash
# sObject Collections — 여러 레코드 한 번에 (allOrNone로 부분 실패 제어)
curl https://MyDomain.my.salesforce.com/services/data/v67.0/composite/sobjects/ \
  -H "Authorization: Bearer <token>" -H "Content-Type: application/json" -d '{
    "allOrNone" : false,
    "records" : [
      { "attributes":{"type":"Account"}, "Name":"Acme" },
      { "attributes":{"type":"Account"}, "Name":"Global" }
    ]
  }'
```

> `allOrNone:true`면 하나라도 실패 시 전체 롤백. Composite가 sObject Collections를 쓰면 allOrNone 파라미터가 2개 이상 상호작용할 수 있다.

---

## 주요 헤더

Assignment Rule · Call Options · Compression(gzip) · Conditional Request(If-Modified-Since 등) · Duplicate Rule · Limit Info · Package Version · Query Options · Warning.

---

## 비교 — 어떤 API를 쓰나

| 상황 | API |
|---|---|
| 소량~중간 동기 CRUD/쿼리 | **REST API** (본 노트) |
| 대량(수만~1.5억) 비동기 적재/추출 | [[Bulk API 2.0]] |
| 여러 작업을 1 왕복으로 | Composite / sObject Collections |
| 외부 → Salesforce 커스텀 엔드포인트 | [[Custom REST Endpoint]] (`@RestResource`) |
| UI 메타데이터·레이아웃 인지 | [[UI API 개요]] |

---

## 관련 노트

- [[Bulk API 2.0]] — 대량 비동기 데이터 API
- [[Custom REST Endpoint]] — Apex `@RestResource` 인바운드 커스텀 API
- [[Named Credential]] — 외부 호출 시 인증·URL 관리
- [[UI API 개요]] — UI 인지 REST(LWC/모바일)
- [[통합 MOC]]
