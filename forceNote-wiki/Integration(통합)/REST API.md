---
tags: [integration, rest-api, sobjects, composite, soql-rest]
source: api_rest.pdf (REST API Developer Guide v67.0, Summer '26, Tier 2) + SOAP API Developer Guide (developer.salesforce.com, v64.0/258.0 라이브 문서, Tier 2)
official_doc: https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/
created: 2026-06-14
updated: 2026-07-06
aliases: [REST API, 표준 REST API, sObjects REST, Composite, Composite Graph, sObject Tree, sObject Collections, queryAll, REST 헤더, REST status codes, REST vs SOAP, SOAP API 선택, enterprise WSDL, partner WSDL, SOAP login]
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

## 호출 전제조건 · 최소 권한

REST API를 호출하려면 **org 단위 API 접근**과 **사용자 단위 권한** 두 가지가 모두 필요하다.

| 층위 | 조건 |
|---|---|
| **org (에디션)** | API 접근이 **Enterprise·Performance·Unlimited·Developer Edition에서 기본 활성**. Professional Edition은 애드온으로 추가 가능. API 접근이 없는 org에 요청하면 `API_DISABLED_FOR_ORG` 에러 반환 |
| **사용자 (권한)** | 모든 API 호출은 사용자에게 **`API Enabled` 시스템 권한**이 켜져 있어야 한다. 일부 프로필(Developer Edition의 다수 프로필 포함)은 기본 활성 |

- **`API Enabled` 위치**: Setup → 프로필(Profile) 또는 권한 집합(Permission Set) → **System Permissions** → `API Enabled` 체크. (사용자에게 할당된 프로필/권한셋에 있어야 함)
- 시스템-대-시스템 통합 전용 사용자는 **Salesforce Integration user license**로 org 전체 접근을 주되 **API 전용(API-only) 작업으로 제한**할 수 있다.
- 격리 원칙: 프로덕션 대신 **Developer Edition·샌드박스·스크래치 org**에서 개발·테스트 후 이관 권장.

---

## API 버전 선택 · 하위호환

- **URI에 버전을 항상 명시**한다 (`/services/data/v67.0/…`). 버전을 고정하면 org 스키마·플랫폼이 바뀌어도 동작이 안정적이다. **현재 최신은 v67.0 (Summer '26)**.
- **지원 기간(End-of-Life 정책)**: Salesforce는 각 API 버전을 **최초 릴리스로부터 최소 3년** 지원한다. 3년이 넘은 버전은 지원 종료될 수 있으며, **지원 종료(deprecation) 최소 1년 전에 사용 고객에게 통지**한다.
- **은퇴(retirement) 사례**: 버전 **21.0–30.0은 Summer '25부로 은퇴·사용 불가**, 버전 **7.0–20.0은 Summer '22부로 은퇴·사용 불가**. 은퇴 버전의 리소스/오퍼레이션을 호출하면 **`410 GONE`** 에러를 반환한다.
- **경고 신호**: deprecated 버전 사용 시 응답 `Warning` 헤더에 **`warningCode 299`** 경고가 실린다 (예: `299 - "This API is deprecated and will be removed by …"`).
- **버전 목록 조회**: `GET /services/data/` (인증 불필요) → 사용 가능한 각 버전의 `version`·`label`·`url` 반환. 오래된/미지원 버전에서 온 요청은 **API Total Usage** 이벤트 타입으로 식별한다.

> [!tip] `409 Conflict`는 "요청한 리소스와 API 버전이 호환되지 않음"을 의미할 수 있다 — 버전과 리소스 조합을 점검한다.

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
| **Warning** (`Warning`) | (응답) 사용 중단 등 경고 — 표준 HTTP `Warning` 헤더에 `warningCode 299`로 실린다(deprecated 버전 등) |

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

### sObject Tree 요청 본문 — 부모·자식 중첩 생성

`POST /composite/tree/{Object}`는 **단일 루트 레코드 타입을 공유하는 중첩(부모-자식) 트리**를 한 번에 생성한다. 각 레코드는 `attributes`에 `type`과 **`referenceId`**(호출자가 정하는 임시 식별자)를 두고, 자식은 부모 안의 **관계명 키**(예: `Contacts`) 아래 `records` 배열로 중첩한다. 생성 후 부모-자식은 ID로 자동 링크되며, 응답은 `referenceId → 생성된 id` 매핑을 돌려준다.

```json
// composite/tree/Account 요청 본문 — Account 1건 + 자식 Contact 2건 중첩
{
  "records" : [{
    "attributes" : { "type" : "Account", "referenceId" : "ref1" },
    "name" : "SampleAccount",
    "phone" : "1234567890",
    "website" : "www.salesforce.com",
    "numberOfEmployees" : "100",
    "industry" : "Banking",
    "Contacts" : {
      "records" : [{
        "attributes" : { "type" : "Contact", "referenceId" : "ref2" },
        "lastname" : "Smith",
        "title" : "President",
        "email" : "sample@salesforce.com"
      },{
        "attributes" : { "type" : "Contact", "referenceId" : "ref3" },
        "lastname" : "Evans",
        "title" : "Vice President",
        "email" : "sample@salesforce.com"
      }]
    }
  },{
    "attributes" : { "type" : "Account", "referenceId" : "ref4" },
    "name" : "SampleAccount2",
    "phone" : "1234567890",
    "industry" : "Banking"
  }]
}
// 성공 응답: { "hasErrors": false, "results": [ { "referenceId":"ref1", "id":"001..." }, ... ] }
// 실패 시: hasErrors=true + 오류를 낸 레코드의 referenceId·errorCode만 반환 (전체 요청 실패)
```

**sObject Tree 한도·규칙** (요청당):
- **총 200 레코드** — 모든 트리에 걸쳐 합산 (트리가 단일 레코드면 동일 타입 최대 200 무관계 레코드 생성에도 사용 가능)
- **서로 다른 타입 최대 5종**
- **트리 깊이 최대 5레벨** (child-to-parent 관계 순회도 5레벨 초과 불가)
- **원자성**: 한 레코드라도 생성 실패하면 **전체 요청 실패**. 레코드는 요청에 나열된 순서대로 생성되며, 전체가 **API 한도상 1회 콜**로 계상
- 트리거·프로세스·워크플로 규칙은 레벨별 동일 타입 그룹 단위로 발화(루트 그룹, 2레벨 Contact 그룹, 3레벨 …)

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

### INVALID_SESSION_ID (401) — 원인·해결

`401`은 "세션 ID 또는 OAuth 토큰이 만료·무효"이며 응답 본문에 `message`와 `errorCode: INVALID_SESSION_ID`가 담긴다. 세션 만료 외에 **인가 구성 문제**로도 자주 발생한다.

| 원인 | 해결 |
|---|---|
| **세션/토큰 만료** | refresh_token으로 토큰 재발급 (OAuth 토큰 엔드포인트에 refresh token·client_id·client_secret로 POST → 새 access token). Connected App에 refresh token 스코프(`Perform requests at any time` = `refresh_token, offline_access`)가 있어야 응답에 refresh token이 실린다 |
| **`api` 스코프 누락** (특히 client_credentials 플로우) | Connected App/External Client App의 OAuth 스코프에 **`api` (Manage user data via APIs)** 를 포함해야 REST API 호출 가능. 스코프가 없으면 토큰이 발급돼도 API 호출이 거부됨 |
| **API Client Whitelisting / IP 제약** | org에 "API Client Whitelisting(API Access Control)"이 켜져 있으면 **승인되지 않은 Connected App의 세션이 무효화**된다 → 해당 앱을 허용 목록에 등록. Connected App의 IP Relaxation·로그인 IP 범위 밖 요청도 세션 거부 |
| **비밀번호 변경 시 토큰 revoke** | 사용자 비밀번호 변경·리셋 시 기존 액세스/리프레시 토큰이 **revoke**될 수 있음 → 재인증으로 새 토큰 획득 |
| **잘못된 인스턴스 URL** | 토큰 응답의 `instance_url`(My Domain)을 그대로 엔드포인트로 사용. 다른 인스턴스로 보내면 세션 무효 |

> [!tip] Apex 콜아웃에서 `INVALID_SESSION_ID`가 나면 자기 org를 세션 ID로 재호출하는 안티패턴일 수 있다 — [[Named Credential]]로 인증을 위임한다.

---

## 날짜·시간 형식

- **dateTime**: `yyyy-MM-ddTHH:mm:ss.SSS+/-HH:mm` 또는 `...Z`(UTC). 예: `2002-10-10T12:00:00+05:00` = `2002-10-10T07:00:00Z`
- **date**: `yyyy-MM-dd` (offset 미지원)

---

## REST vs SOAP API — 언제 뭘 고르나

> 둘 다 **코어 데이터 API**(레코드 CRUD·SOQL/SOSL·describe)로 기능이 크게 겹친다. 선택 기준은 기능이 아니라 **프로토콜·타입 계약·인증·클라이언트 자산**이다. REST 가이드 원문: *"It's simpler to use than SOAP API but still provides plenty of functionality."*

| 기준 | **REST API** (본 노트) | **표준 SOAP API** (enterprise/partner WSDL) |
|---|---|---|
| 프로토콜·포맷 | HTTP verbs(GET/POST/PATCH/DELETE) + JSON(기본)/XML | SOAP/XML 웹서비스 — WSDL이 호출·오브젝트·필드를 정의 |
| 계약·타입 | 스키마 계약 없음 — `describe`로 런타임 조회 | **WSDL 계약** — enterprise WSDL은 강타입(int·string 등 구체 타입), partner WSDL은 name-value 쌍의 느슨한 타입 |
| 툴링 | 별도 툴링 거의 불필요 (cURL/모든 HTTP 클라이언트) | WSDL을 개발 플랫폼(Java·.NET)에 임포트해 **클라이언트 스텁 생성** 필요 |
| 인증 | External Client App/Connected App + **OAuth 2.0** (`Authorization: Bearer`) | `SessionHeader`의 sessionId. 전통 방식은 `login()` 세션이지만 아래 제약 참고 — SOAP도 External Client App/Connected App + OAuth 2.0 인가를 지원 |
| org 스키마 변경 시 | 영향 없음 (URI·JSON 동일) | **enterprise WSDL은 재다운로드·재소비 필요**, partner WSDL은 API 버전당 1회면 됨 |
| 신규 통합 | ✅ 권장 (간단·경량·OAuth 표준) | 신규 도입 비권장 — 아래 유지 케이스일 때만 |

### enterprise vs partner WSDL (SOAP 선택 시)

| | **Enterprise WSDL** | **Partner WSDL** |
|---|---|---|
| 대상 | 단일 org용 사내(enterprise) 클라이언트 | 여러 org를 다루는 메타데이터 주도·동적 클라이언트(파트너/ISV) |
| 타입 | 강타입 — org의 표준·커스텀 오브젝트/필드가 구체 타입으로 포함 | 느슨한 타입 — 필드명·값의 name-value 쌍, 어떤 org에도 사용 가능 |
| 유지보수 | org의 커스텀 오브젝트/필드 변경 또는 API 버전 변경 시 재다운로드·재소비 | API 버전당 1회 다운로드 |
| 다운로드 | Setup → Quick Find "API" → Generate Enterprise WSDL (Modify All Data 권한 필요) | 같은 페이지 → Generate Partner WSDL |

### SOAP `login()` 세션 인증 — 현재 제약

```java
// SOAP API Developer Guide의 공식 시그니처
LoginResult = connection.login(string username, string password);
// → LoginResult: sessionId + serverUrl(이후 호출 대상) + userId
```

- **`login()`은 API v64.0 이하에서만 제공**되며, **신규 org에서는 기본 비활성**. 활성화: Setup → User Interface → *Enable SOAP API login()* (UI에서 한 번 켜면 UI로는 되돌릴 수 없음 — 이후 관련 release update의 test run으로만 토글).
- 비밀번호 뒤에 **security token**을 이어 붙여 전달 (`mypasswordXXXXXXXXXX`). 신뢰 IP 목록에 등록된 IP면 토큰 생략 가능.
- 획득한 `sessionId`를 이후 모든 호출의 SOAP `SessionHeader`에, `serverUrl`을 엔드포인트로 지정.
- 한도: **사용자당 시간당 3,600회** login() 호출 (초과 시 "Login Rate Exceeded", 1시간 차단). login() 호출은 로그인 rate limit에 계상.
- 결론: **신규 통합은 REST + OAuth 2.0**. SOAP를 쓰더라도 username-password login()이 아니라 OAuth 인가를 사용.

### SOAP를 유지/선택하는 케이스

- **기존 SOAP 클라이언트 자산** — enterprise/partner WSDL 스텁 기반으로 이미 구축된 엔터프라이즈 미들웨어·ETL은 재작성 비용 대비 유지가 합리적
- WSDL **강타입 계약**(컴파일 타임 타입 체크)이 조직 표준인 Java/.NET SOA 환경
- 그 외 신규 요구는 REST(본 노트) 또는 대량이면 [[Bulk API 2.0]]

> SOAP 호출 전수(describeSObjects·merge·convertLead·SessionHeader·Enterprise/Partner WSDL 등)는 [[SOAP API (표준 오퍼레이션·enterprise·partner WSDL)]] 참조.

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
| 기존 WSDL 스텁 기반 클라이언트 유지 | 표준 SOAP API (위 "REST vs SOAP" 섹션) |

---

## 관련 노트

- 📖 공식: [REST API Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/)
- [[Bulk API 2.0]] — 대량 비동기 데이터 API
- [[Actions API]] — Invocable Action REST 호출
- [[Custom REST Endpoint]] — Apex `@RestResource` 인바운드
- [[SOAP API (표준 오퍼레이션·enterprise·partner WSDL)]] — 강타입 표준 SOAP API(core calls·SessionHeader·WSDL)
- [[Named Credential]] — 외부 호출 인증·URL 관리
- [[UI API 개요]] — UI 인지 REST(LWC/모바일)
- [[Connect REST API 개요]] — 프레젠테이션 지향 REST(Chatter·Experience·CMS·파일). sObject CRUD·데이터 추출은 이 표준 REST API, 지역화·렌더링용 피드는 Connect REST
- [[Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)]] — 24시간 API 콜 할당량·동시 요청·타임아웃·`/limits`·요청 크기 한도 전체
- [[통합 MOC]]
