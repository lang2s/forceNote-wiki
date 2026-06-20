---
tags: [limits, allocations, api-limits, bulk-api, metadata, soql-limits, visualforce, governance, architecture]
source: salesforce_app_limits_cheatsheet.pdf (Salesforce Developer Limits and Allocations Quick Reference, Last updated May 8 2026, Tier 2)
created: 2026-06-20
aliases: [API Request Limits, Total API Request Allocations, Concurrent API Limits, Bulk API Limits, SOAP Call Limits, Metadata Limits, SOQL Search Limits, Visualforce Limits, API 호출 한도, 동시 API 한도, 벌크 한도, 메타데이터 한도, SOQL 한도, Visualforce 한도, 일일 API 콜 한도, 할당량 레퍼런스]
---

# Salesforce 한도·할당량 레퍼런스 (API·Bulk·Metadata·SOQL·VF)

> Salesforce **org·edition·플랫폼 레벨 정적 할당량** 레퍼런스 — API 요청(동시·타임아웃·24시간 콜)·Bulk API/2.0·SOAP 콜·Metadata·SOQL/SOSL 검색·Visualforce 한도. (`salesforce_app_limits_cheatsheet.pdf`, Last updated May 8 2026)

> [!note] Apex **트랜잭션 런타임** 거버너 한도(SOQL 100/DML 150·Heap·CPU·비동기)는 [[Governor Limits]] 참조 — 이 노트는 그와 별개의 org/플랫폼 레벨 할당량을 다룬다. 또 이 치트시트는 Storage·Email·Custom Object 수 등 edition 할당량은 **다루지 않는다**(Salesforce "Features and Edition Allocations" 문서 소관).

---

## 개요 (범위·범위 밖 명시)

이 노트는 Salesforce가 org/edition/플랫폼 레벨에서 정적으로 부과하는 할당량을 정리한 것이다. 트랜잭션마다 동적으로 재설정되는 Apex 거버너 한도와 구분된다.

**이 노트가 다루는 범위:**
- API 요청 한도와 할당량 (동시 요청·타임아웃·24시간 총 콜 할당량·요청 크기)
- Connect REST API 한도
- Bulk API 및 Bulk API 2.0 한도와 할당량 (Batch·General·Ingest·Query)
- API Query Cursor 한도
- SOAP API Call 한도
- Metadata API 한도
- SOQL·SOSL 검색 한도
- Visualforce 한도

**범위 밖 (이 PDF에 없음 — 만들어 넣지 않는다):**
- Apex 트랜잭션 런타임 거버너 한도 → [[Governor Limits]]
- Platform Event / Change Data Capture / Pub/Sub API 할당량 → [[Platform Event 한도와 고려사항]]
- Storage(데이터·파일) 할당량, Email 발송 한도, Custom Object 수 등 edition 기능 할당량 → Salesforce "Features and Edition Allocations" 문서 소관 (이 치트시트에 없음)
- Experience Cloud 한도 → Salesforce "Experience Cloud User Licenses" 문서

## 거버너 한도 vs 정적 할당량 구분

| 구분 | Apex 거버너 한도 ([[Governor Limits]]) | 이 노트의 정적 할당량 |
|---|---|---|
| 적용 단위 | Apex 트랜잭션 (실행마다 리셋) | org/edition/플랫폼 (24시간 롤링 등) |
| 예시 | SOQL 100건/트랜잭션, DML 150건, Heap 6/12MB, CPU 10/60초 | 24시간 총 API 콜 15,000~5,000,000, Batch 15,000/24h |
| 초과 시 | 트랜잭션 즉시 실패 (catch 불가 LimitException) | 요청 거부 또는 hard cap (예: `REQUEST_LIMIT_EXCEEDED`) |
| 소관 | Apex Developer Guide | 이 Quick Reference (`salesforce_app_limits_cheatsheet.pdf`) |

## ① Apex Governor Limits — 위임

> Apex 트랜잭션 런타임 거버너 한도(SOQL 쿼리 100/DML 150·Heap·CPU 시간·비동기 한도 등)는 [[Governor Limits]] 참조. 이 노트는 표를 재작성하지 않는다.

## API 요청 한도와 할당량

### 동시 API 요청 한도

다양한 org 유형에 대해, **20초 이상** 지속되는 인바운드 동시 요청(콜)에 적용되는 한도다.

| Org 유형 | 한도 |
|---|---|
| Developer Edition and Trial orgs | 5 |
| Production orgs and Sandboxes | 25 |

장기 실행 요청 수가 한도를 초과하면 API는 `REQUEST_LIMIT_EXCEEDED` 예외 코드를 반환한다. 허용 한도보다 요청 수가 적어질 때까지 새 동시 요청은 처리되지 않는다. 예를 들어 production org에서는 장기 실행 요청이 25건 미만이 될 때까지 새 동시 요청이 허용되지 않는다.

**20초 미만**의 동시 요청 수에는 한도가 없다.

### API 타임아웃 한도

- REST 및 SOAP API 콜의 타임아웃 한도는 **10분**이다. 단 query 콜은 예외 — query 콜의 타임아웃은 SOQL 한도가 결정한다(아래 SOQL 검색 한도 참조).
- 다른 Salesforce API(예: Bulk API)로 한 콜의 타임아웃은 해당 API 문서를 참조.
- 요청이 이 한도를 초과하면 API는 `REQUEST_RUNNING_TOO_LONG` 상태 코드(SOAP API) 또는 `QUERY_TIMEOUT` 예외 코드(REST API)를 반환한다.
- REST API의 Composite Resources 콜의 경우, 이 타임아웃은 각 서브리퀘스트가 아니라 **composite 요청 전체**에 적용된다.

### 총 API 요청 할당량 (edition별)

org당 24시간 기간 동안의 총 인바운드 API 요청(콜) 한도다.

> [!note] External Identity 라이선스 유형의 한도는 표시된 대로 다양하다(70,000 / 750,000 / 4,000,000 콜). 본인의 한도가 어느 것인지 확실하지 않으면 Salesforce 담당자에게 문의한다.

| Salesforce Edition | API Calls Per License Type Per 24-Hour Period | Total Calls Per 24-Hour Period |
|---|---|---|
| Developer Edition | N/A | 15,000 |
| • Enterprise Edition<br>• Professional Edition with API access enabled | • Salesforce: 1,000<br>• Salesforce Platform: 1,000<br>• Lightning Platform - One App: 200<br>• Customer Community: 0<br>• Customer Community Login: 0<br>• Customer Community Plus: 200<br>• Customer Community Plus Login: 10<br>• External Identity 25,000: 70,000<br>• External Identity 250,000: 750,000<br>• External Identity 1,000,000: 4,000,000<br>• Partner Community: 200<br>• Partner Community Login: 10<br>• Lightning Platform Starter: 200 per member for Enterprise Edition orgs<br>• Lightning Platform Plus: 1000 per member for Enterprise Edition orgs | 100,000 + (number of licenses x calls per license type) + purchased API Call Add-Ons |
| • Unlimited Edition<br>• Performance Edition | • Salesforce: 5,000<br>• Salesforce Platform: 5,000<br>• Lightning Platform - One App: 200<br>• Customer Community: 0<br>• Customer Community Login: 0<br>• Customer Community Plus: 200<br>• Customer Community Plus Login: 10<br>• External Identity 25,000: 70,000<br>• External Identity 250,000: 750,000<br>• External Identity 1,000,000: 4,000,000<br>• Partner Community: 200<br>• Partner Community Login: 10<br>• Lightning Platform Starter: 200 per member for Unlimited and Performance Edition orgs<br>• Lightning Platform Plus: 5,000 per member for Unlimited and Performance Edition orgs | 100,000 + (number of licenses x calls per license type) + purchased API Call Add-Ons |
| Full Sandbox | N/A | 5,000,000 — 이 한도는 템플릿으로 생성되지 **않은** Full Sandbox에만 적용된다. 템플릿으로 생성한 sandbox는 템플릿의 값이 한도를 결정한다(Salesforce Help: Sandbox Types and Templates 참조). |

> Experience Cloud 한도는 "Experience Cloud User Licenses" 참조.

이 할당량에 카운트되는 API: Lightning Platform REST API, Lightning Platform SOAP API, Bulk API, Bulk API 2.0, 대부분의 Connect REST API. 특정 Salesforce connected app(예: Salesforce 모바일 앱)이 발행한 API 콜은 카운트되지 않는다.

- `DebuggingHeader`를 포함하는 콜은 **24시간당 1,000콜**의 별도 할당량을 가진다. 이 콜은 org의 총 요청 한도에 도달한 후에도 계속 발행할 수 있다.
- 한도·할당량은 24시간 기간 동안 org에 대한 **모든 API 콜의 합계**에 대해 적용된다. 사용자별 단위가 아니다.
- Load·performance·기타 시스템 이슈로 24시간 기간 동안 전체 할당량을 사용하지 못할 수 있다.

### API 사용량 모니터링

org의 API 사용량·한도를 모니터링하는 리소스:
- Setup의 System Overview 페이지의 **API Usage** 섹션.
- Setup의 System Overview 페이지 Organization Detail 섹션의 **API Requests, Last 24 Hours** 항목.
- **API Request Limit per Month** usage-based entitlement — 30일간 집계된 org의 API 콜을 보여준다(Setup의 Company Information 페이지).
- REST API의 경우 **`Sforce-Limit-Info`** 응답 헤더에 반환되는 정보.
- SOAP API의 경우 응답 본문(`<type>API REQUESTS</type>`)에 반환되는 정보.
- Lightning Platform REST API의 **`/limits`** 콜.

API 요청이 할당량의 지정 percentage를 초과하면 지정 사용자에게 이메일이 발송되도록 org를 구성할 수 있다(Setup → Quick Find에 `API Usage Notifications` 입력 → API Usage Notifications 선택).

> [!note] 설치된 managed package에서 발행한 API 콜은 org 한도에 카운트된다.

```bash
# 구조 예시 — 실제 동작 코드 아님
# Lightning Platform REST API의 /limits 콜로 현재 사용량/할당량 조회
curl -H "Authorization: Bearer $ACCESS_TOKEN" \
  https://yourInstance.salesforce.com/services/data/v60.0/limits/
# 응답에 DailyApiRequests, DailyBulkV2QueryJobs,
# DailyBulkV2QueryFileStorageMB 등의 Max/Remaining 값이 포함된다.
```

### 한도 초과 시 동작 / 할당량 증설

**일일 API 요청 한도에 도달·초과 시:** org가 일일 API 요청 한도에 도달하거나 초과해도, Salesforce는 가능한 경우 일정량까지 작업을 계속 진행시킨다. 예기치 못한 워크로드 급증·간헐적 피크 기간 동안 워크플로 차단을 피하기 위함이다. 단, 플랫폼 리소스 보호를 위해 hard cap이 적용되어 일일 한도를 무제한 초과하지 못하게 한다.

> [!note]
> - 정상 일일 한도 초과 능력은 항상 instance 전체 건강을 보호하기 위한 제약을 받는다(Salesforce Trust에서 instance 건강 모니터링 가능).
> - 이 능력은 가끔씩 워크플로 중단을 피하는 용도로 설계되었다 — 상시 의존하지 말 것. 할당량을 늘리려면 Salesforce 계정 담당자에게 문의.
> - 이 능력은 **active 상태의 paid org에만** 적용된다. trial org·Developer Edition·sandbox에는 적용되지 않는다.

API 요청 활동은 계약 시작일 기준 30일 기간으로 집계되며, org의 권한 한도를 초과하는 콜을 포함한다.

**총 API 요청 할당량 증설:** 허용되는 총 API 요청 수는 org 내 사용자 라이선스로 정의된다. 더 많은 API 요청이 필요하면 Your Account App으로 추가 사용자 라이선스나 추가 API 콜을 구매한다(Salesforce Help: Add Products and Licenses with the Your Account App 참조 또는 account executive 문의). 구매 전 현재 사용량을 검토하고 가능하면 총 요청 수를 줄인다 — 클라이언트 앱을 최적화해 더 적은 콜로 동일 작업 수행, REST API Composite Resources로 클라이언트↔서버 왕복 최소화 등.

**API 사용량 메터링 계산 예시:**
- Salesforce 라이선스 15개를 가진 Enterprise Edition org의 경우, 요청 한도는 **115,000 requests**다(100,000 + 15 licenses × 1,000 calls).
- 수요일 오전 5시에 14,500콜, 수요일 오후 11시에 499콜을 한 Developer Edition org의 경우, 목요일 오전 5시까지 **한 콜만** 더 성공적으로 할 수 있다.

### 요청 크기 한도

| 항목 | 한도 |
|---|---|
| 각 REST 콜에서 URI + 헤더 결합 허용 길이 | 16,384 bytes — 초과 시 언제든 `431 Request Header Fields Too Large` 에러 반환. URI가 이를 초과하면 `414 URI Too Long` 에러 반환 |
| (공개 서비스 권장값) | URI 길이 2000자, 헤더 약 8000 bytes로 제한 권장 — 브라우저·로드밸런서 등 다른 요인이 최대 URI/헤더 길이를 낮출 수 있음 |
| 저장되는 third-party refresh·access token 길이 | Salesforce는 최대 10,000자 길이의 third-party access·refresh token을 저장한다 |

## Connect REST API 한도

한도는 공유 리소스를 보호한다. 이 한도는 Connect REST API 소비자에 적용된다.

- 대부분의 Connect REST API 요청은 다른 Salesforce API와 **동일한 rate limit**의 적용을 받는다. **Chatter REST API 리소스**(Connect REST API 리소스의 부분집합)에 대한 요청만 사용자별·애플리케이션별·시간별 rate limit의 적용을 받는다.
- rate limit 초과 시 Connect REST API 리소스는 `503 Service Unavailable` 에러 코드를 반환한다.
- Salesforce 세션 ID를 사용하는 애플리케이션의 경우 rate limit은 사용자별·시간별이며, 애플리케이션별 별도 버킷이 없다. 사용자가 세션 ID로 접근하는 모든 애플리케이션이 이 일반 할당량을 공유한다. 사용자별·애플리케이션별·시간별 한도를 활용하려면 OAuth 토큰을 사용한다.

> [!note] Load·performance·기타 시스템 이슈로 일부 한도에 도달하지 못할 수 있다. 한도는 통보 없이 변경될 수 있다. 애플리케이션이 가용 요청을 효율적으로 사용하고 `503` 에러 코드를 graceful하게 처리하도록 한다.

## Bulk API · Bulk API 2.0 한도와 할당량

2,000건을 초과하는 데이터 작업은 Bulk 프레임워크를 활용해 비동기 워크플로를 준비·실행·관리하는 Bulk API 2.0의 좋은 후보다. 2,000건 미만의 작업은 REST(예: Composite)나 SOAP에서 "bulkified" 동기 콜을 사용해야 한다.

### Batch 할당량

- 롤링 24시간 기간당 **최대 15,000 batches**를 제출할 수 있다. 이 할당량은 Bulk API와 Bulk API 2.0 간에 **공유**되므로, Bulk API 또는 Bulk API 2.0에서 처리되는 모든 batch가 이 할당량에 카운트된다.
- Bulk API 2.0에서는 **ingest job만** batch를 소비한다. Query job은 소비하지 않는다.
- Bulk API 2.0에서는 batch가 자동 생성된다. Bulk API에서는 직접 batch를 생성해야 한다.

### General Limits

| Item | Bulk API Limit | Bulk API 2.0 Limit |
|---|---|---|
| Batch and job lifespan | terminal state(completed, aborted, failed)인 batch는 7일보다 오래되면 큐에서 제거되며, 이는 해당 job 상태와 무관하다. 7일은 job에 연결된 가장 어린 batch 기준, batch가 없으면 job 나이 기준으로 측정된다. 24시간보다 오래된 job에는 batch를 생성할 수 없다. non-terminal state로 7일보다 오래된 batch는 해당 job과 함께 주기적으로 정리된다. | terminal state(completed, aborted, failed)로 7일보다 오래된 job은 삭제된다. non-terminal state로 7일보다 오래된 job은 주기적으로 정리된다. |
| Binary content | • 파일명 길이는 512 bytes를 초과할 수 없다.<br>• zip 파일은 10 MB를 초과할 수 없다.<br>• 압축 해제된 콘텐츠 총 크기는 20 MB를 초과할 수 없다.<br>• zip 파일에는 최대 1,000개 파일이 포함될 수 있다. 디렉터리는 이 총계에 카운트되지 않는다. | N/A |
| Maximum time that a job can remain open | 24 hours | The same. (But this only applies to ingest jobs, not query jobs.) |

### Ingest Jobs 한도

| Item | Bulk API Limit | Bulk API 2.0 Limit |
|---|---|---|
| Maximum number of records uploaded per 24-hour rolling period | 150,000,000 (15,000 batches x 10,000 records per batch maximum) | 150,000,000 |
| Batch processing time | Batch는 chunk 단위로 처리된다. chunk 크기는 API 버전에 따라 다르다. API 버전 20.0 이전은 chunk 크기 100 records, API 버전 21.0 이후는 200 records. 최대 batch 크기 10,000 records로 시작한다. Salesforce는 각 batch를 비동기 처리한다. 처리 시간에 따라 batch 크기를 조정한다. batch 처리가 너무 오래 걸리면 batch가 타임아웃되고 에러가 반환된다 — 그 경우 batch 크기를 줄여 재제출한다. job이 몇 초만 걸리면 batch 크기를 최대치까지 늘린다. batch가 작을수록 총 batch 수가 늘어 일일 batch 한도에 도달할 위험이 커지므로 작은 batch 사용을 피한다. | Same as Bulk API |
| Maximum time before a batch is retried | 5 minutes | API가 재시도를 자동 처리한다. API가 20회 넘게 재시도했다는 메시지를 받으면 더 작은 업로드 파일로 다시 시도한다. |
| Results lifespan | job 완료 후 7일 이내에 ingest job 결과(success, failed, unprocessed records)를 검색할 수 있다(명시적으로 job을 삭제하지 않은 한). | Same as Bulk API |
| Maximum file size | 10 MB per batch | 150 MB per job — Note: 요청은 base64 인코딩 콘텐츠 총 150 MB를 초과하지 않는 CSV 데이터를 제공할 수 있다. job 데이터 업로드 시 base64로 변환된다. 이 변환으로 데이터 크기가 약 50% 증가할 수 있다. base64 변환 증가를 고려해, 인코딩 전 100 MB를 초과하지 않는 데이터를 업로드한다. |
| Maximum number of characters in a field | 131072 | Same as Bulk API |
| Maximum number of fields in a record | 5,000 | Same as Bulk API |
| Maximum number of characters in a record | 400,000 | Same as Bulk API |
| Maximum number of records in a batch | 10,000 | N/A |
| Maximum number of characters for all the data in a batch | 10,000,000 | N/A |

### Query Jobs 한도

| Item | Bulk API Limit | Bulk API 2.0 Limit |
|---|---|---|
| Number of attempts to query | batch 처리에 5분씩 30 attempts. 또한 query 처리 시간에 2분 한도가 있다. query에 30회 넘는 시도가 이루어지면 "Tried more than thirty times" 에러 메시지가 반환된다. query 처리가 2분을 초과하면 `QUERY_TIMEOUT` 에러가 반환된다. | API가 재시도를 자동 처리한다. API가 15회 넘게 재시도했다는 메시지를 받으면 filter criteria를 적용해 다시 시도한다. |
| Batch size | PK chunking을 활성화하지 않으면 batch가 하나만 생성된다. PK chunking을 활성화해 batch를 생성하면, chunk 내 record 수에 따라 batch가 분할된다. 이는 100,000~250,000 records 범위가 될 수 있다. 작은 chunk 크기는 빈 batch가 생성·전송되게 할 수 있으므로 100,000~250,000 사이 chunk 크기를 권장한다. | API가 "batch" 관리를 자동 처리한다. |
| Number of retrieved files | 15 files. query가 15개 넘는 파일을 반환하면 filter를 추가해 더 적은 데이터를 반환한다. Bulk batch 크기는 bulk query에 사용되지 않는다. | N/A |
| Timeout for retrieving query results | 20 minutes | Same as Bulk API |
| Results lifespan | job 완료 후 7일 이내에 query job 결과를 검색할 수 있다. | Same as Bulk API |
| Maximum retrieved file size | 1 GB. batch 처리 결과가 1 GB의 검색 데이터가 되면, 그 결과는 디스크에 저장되고 batch는 큐에 다시 들어가 나중에 재개된다. 이는 15회 재시도 중 하나로도 카운트된다. | Same as Bulk API. 또한 API 클라이언트는 `locator`와 `maxRecords` query 파라미터를 사용해 전체 결과 집합을 탐색할 수 있다. 클라이언트는 파일 집합에 묶이지 않는다. |
| Number of query jobs that can be submitted per 24-hour rolling window | See Batch Allocations. | 10,000 — 현재 수는 `/vXX.X/limits/` REST API 메서드 응답의 `DailyBulkV2QueryJobs` 값에서 볼 수 있다. |
| Total query results that can be generated per 24 hour rolling window | N/A | 1 TB. — 현재 크기는 `/vXX.X/limits/` REST API 메서드 응답의 `DailyBulkV2QueryFileStorageMB` 값에서 볼 수 있다. |

> PK chunking·Bulk API 2.0의 동작 메커니즘은 [[Bulk API 2.0]] 참조.

## API Query Cursor 한도

- Cursor와 관련 query 결과는 nested query 결과를 포함해 **2일간** 사용 가능하다. 열린 cursor 수에는 한도가 없다.
- 대량·복잡한 query 결과를 단일 batch로 반환할 수 없을 때, 하나 이상의 server-side cursor와 대응 query locator가 자동 생성된다. cursor는 DB 내 추가 query 결과의 위치를 표시하고, query locator가 cursor를 찾는다. 추가 결과를 얻으려면 SOAP API의 `queryMore()` 콜이나 REST API의 `nextRecordUrl` 필드 같은 다른 콜 내에서 query locator를 사용한다.
- Salesforce cursor 한도는 **API 버전 56.0** 릴리스로 변경되었다. 이전에는 사용자당 최대 **10 cursors**가 동시에 접근 가능했고, query 결과·페이지네이션을 사용자당 10 result set으로 제한했다. 가장 오래된 cursor·result set은 15분의 비활성 후 만료되었다. cursor 한도 제거는 보편적이며, 모든 버전의 Apex, SOAP API, REST API, Bulk API, Bulk API 2.0 및 이 기술로 구축된 모든 기능에 적용된다.

## SOAP API Call 한도

| API Name | API Limit | Limit Description |
|---|---|---|
| `create()` | Maximum number of records created | 단일 `create()` 콜에서 최대 200 records 추가 가능. create 요청이 200 records를 초과하면 전체 작업이 실패한다. |
| `describeSObjects()` | Maximum number of objects returned | `describeSObjects()` 콜은 최대 100 objects 반환으로 제한된다. |
| `getDeleted()` | Limits for returned records | `getDeleted()` 콜이 600,000 records를 초과해 반환하면 `EXCEEDED_ID_LIMIT` 예외가 반환된다. |
| `login()` | Login request size limit | login 요청 크기는 10 KB로 제한된다. |
| `merge()` | Merge request limits | • 단일 SOAP 콜에서 최대 200 merge 요청 가능.<br>• 단일 요청에서 master record 포함 최대 3 records 병합 가능. 이는 Salesforce UI가 적용하는 한도와 동일하다. 3개 넘게 병합하려면 연속 merge를 수행한다.<br>• External ID 필드는 `merge()`에 사용할 수 없다.<br>• lead·contact 병합 시 가장 최근 업데이트된 data privacy record를 유지하는 옵션을 선택했으나, 호출자가 선택된 data privacy record에 대한 CRUD 권한이 없으면, merge 프로세스는 master record에 이미 연결된 data privacy record를 선택한다. |
| `update()` | Maximum number of records updated | 단일 `update()` 콜에서 최대 200 records 변경 가능. update 요청이 200 records를 초과하면 전체 작업이 실패한다. |
| `query()` and `queryMore()` | Batch size limits | 최대 batch 크기는 2,000 records이나, 이는 제안일 뿐이다. 성능 최대화를 위해 요청한 batch 크기가 반드시 실제 batch 크기는 아니다. WSC(Salesforce Web Service Connector) 클라이언트는 connection 객체에서 `setQueryOptions()`를 호출해 batch 크기를 설정할 수 있다. C# 클라이언트 애플리케이션은 `query()` 콜 호출 전 SOAP 헤더의 QueryOptions 부분에서 batch 크기를 변경할 수 있다. SOQL 문이 long text 타입 custom 필드를 2개 이상 선택하면 batch 크기는 200 records를 초과할 수 없다. 이 한도는 대형 SOAP 메시지 반환을 방지한다. |

## Metadata API 한도

다음 한도는 Salesforce Extensions for Visual Studio Code, Ant Migration Tool, Metadata API에 적용된다.

| Limit | Description |
|---|---|
| Retrieving and deploying metadata | 한 번에 최대 10,000 files를 deploy/retrieve할 수 있다. deploy/retrieve된 .zip 파일의 최대 크기는 39 MB다. 파일이 unzipped 폴더로 압축 해제되면 크기 한도는 600 MB 또는 629,145,600 bytes다(600 × 1024 × 1024로 계산). 참고: ① Metadata API는 컴포넌트 압축 후 base-64 인코딩한다. 결과 .zip 파일은 SOAP 메시지 한도인 50 MB를 초과할 수 없다. base-64 인코딩이 payload 크기를 늘리므로, 압축된 payload는 인코딩 전 약 39 MB를 초과할 수 없다. ② big object의 `retrieve()` 콜은 index가 정의된 경우에만 수행 가능하다. Setup에서 생성됐으나 아직 index가 정의되지 않은 big object는 retrieve할 수 없다. ③ 한도는 통보 없이 변경될 수 있다. |
| Change sets | inbound·outbound change set은 최대 10,000 files의 metadata를 가질 수 있다. |
| Retrieving metadata types with dependencies | • `rootTypesWithDependencies` 파라미터를 사용한 retrieve 요청은 하루 최대 25회.<br>• `rootTypesWithDependencies` 파라미터를 사용한 단일 retrieve 요청은 최대 100 components에 대한 dependency를 요청할 수 있다. |

> Metadata API 전반은 [[Metadata API 개요]] 참조.

## SOQL · SOSL 검색 한도

| Feature | Limit | Limit Description |
|---|---|---|
| SOQL statements | Maximum length of SOQL statements | 기본 100,000 characters. 긴 복잡한 SOQL 문(예: formula 필드가 많은 문)은 `QUERY_TOO_COMPLICATED` 에러를 일으킬 수 있다 — Salesforce가 처리 시 문을 내부적으로 확장하므로, 원본 SOQL 문이 100,000자 한도 미만이어도 발생한다. 이를 피하려면 SOQL 문의 복잡도를 줄인다. 250개 넘는 필드를 가진 Lightning 페이지 레이아웃도 `QUERY_TOO_COMPLICATED`를 유발할 수 있다(Lightning이 record 페이지 레이아웃 필드 검색에 auto-generated SOQL을 사용하므로 고객 작성 SOQL이 없어도 발생 가능). currency 필드를 너무 많이 포함해도 문자 한도에 도달할 수 있다(currency 필드는 SOQL이 format 메서드를 사용하게 해 currency 필드마다 API 필드명 길이가 대략 두 배가 됨). dynamic Apex로 SOQL을 사용할 때는 SOQL 문 문자 한도가 적용되지 않는다. |
| SOQL statements | Maximum number of junction IDs | query당 500 IDs. query가 501개 이상의 junction ID를 포함하면 query가 실패하고 `MALFORMED_QUERY` 예외를 반환한다. |
| SOQL WHERE clause | Strings in SOQL WHERE clauses | WHERE 절 내 각 문자열당 4,000 characters. |
| SOQL query results | Maximum rows returned | 요청당 2,000 results(API 버전 28.0 이후), query에 custom limit을 지정하지 않은 한. 이 한도는 child object의 결과를 포함한다. 이전 API 버전은 200 results 반환. Apex 클래스 내에서 query 실행 시 추가 한도가 적용된다(Apex Governor Limits 참조). |
| SOQL query results | Availability | 2 days, nested query 결과 포함. |
| SOQL query timeout | Maximum runtime for a SOQL query | 작업 실행과 결과 처리를 합쳐 총 32분이나, query는 실행 또는 처리 단계 어느 쪽에서든 타임아웃될 수 있다. query 작업은 실행에 2분, 결과 처리에 30분이 주어진 뒤 타임아웃이 발생한다. |
| SOSL statements | Maximum length of SOSL statements | 기본 100,000 characters. 이 한도는 org에 정의된 SOQL 문 문자 한도에 연동된다. |
| SOSL search query strings | Maximum length of SearchQuery string | SearchQuery 문자열이 10,000자보다 길면 result row가 반환되지 않는다. SearchQuery가 4,000자보다 길면 모든 logical operator가 제거된다. 예를 들어 SearchQuery가 4,001자인 문의 AND operator는 OR operator로 기본 변경되어, 예상보다 많은 결과를 반환할 수 있다. |
| SOSL query results | Maximum rows returned | 총 2,000 results(API 버전 28.0 이후), query에 custom limit을 지정하지 않은 한. 이 한도는 child object 결과를 포함한다. 이전 API 버전은 200 results 반환. |
| Relationship queries | Relationship query limits | • 한 query에 55개 넘는 child-to-parent 관계를 지정할 수 없다. custom object는 최대 40개 관계를 허용하므로, 한 query에서 custom object의 모든 child-to-parent 관계를 참조할 수 있다.<br>• polymorphic 필드의 단일 query는 child-to-parent 관계 한도에 여러 번 카운트될 수 있다.<br>• 한 query에 20개 넘는 parent-to-child 관계를 지정할 수 없다.<br>• 각 지정 관계에서 child-to-parent 관계는 5단계를 넘게 지정할 수 없다(예: `Contact.Account.Owner.FirstName` = 3단계).<br>• API 버전 57.0 이전은 query에 parent-to-child 관계 2단계만 지정 가능.<br>• API 버전 58.0 이후는 standard·custom object에 대해 REST·SOAP·Apex query 콜로 최대 5단계 parent-to-child 관계를 query할 수 있다. 5단계 parent-to-child 관계를 가진 SOQL query는 big object·external object·Bulk API·Bulk API 2.0에는 지원되지 않는다. |
| FOR VIEW and FOR REFERENCE | Maximum RecentlyViewed records allowed | RecentlyViewed object는 로그인 사용자가 record를 보거나 참조할 때마다 업데이트된다. SOQL query의 FOR VIEW 또는 FOR REFERENCE 절로 record를 검색할 때도 업데이트된다. 최신 데이터 가용성을 위해 RecentlyViewed 데이터는 object당 200 records로 주기적으로 truncate된다. RecentlyViewed 데이터는 90일간 보관된 후 주기적으로 제거된다. |
| OFFSET clause | Maximum number of rows skipped by OFFSET | 최대 offset은 2,000 rows다. 2,000을 초과하는 offset을 요청하면 `NUMBER_OUTSIDE_VALID_RANGE` 에러가 발생한다. |
| ORDER BY clause in SOQL statement | ORDER BY fields limit | SOQL query의 SELECT 문 ORDER BY 절은 query 결과 순서를 제어한다(예: z로 시작하는 알파벳 순). record가 null이면 ORDER BY로 빈 record를 처음 또는 마지막에 표시할 수 있다. |

> SOQL·SOSL 문법은 [[SOQL 문법 레퍼런스]] · [[SOSL 패턴]] 참조.

## Visualforce 한도

| Limit | Value |
|---|---|
| Maximum response size for a Visualforce page | Less than 15 MB |
| Maximum view state size in a Visualforce page | 170KB |
| Maximum size of a Visualforce email template | 1 MB |
| Maximum file size for a file uploaded using a Visualforce page | 10 MB |
| Maximum size of HTML response before rendering, when Visualforce page is rendered as PDF | Less than 15 MB |
| Maximum PDF file size for a Visualforce page rendered as a PDF | 60 MB |
| Maximum total size of all images included in a Visualforce page rendered as a PDF | 30 MB |
| Maximum header size of a Visualforce page | 8,192 bytes |
| Maximum request size of a JavaScript remoting call | 4 MB |
| Default timeout for a JavaScript remoting call | 30,000 milliseconds (30 seconds) |
| Maximum timeout for a JavaScript remoting call | 120,000 milliseconds (120 seconds) |
| Maximum rows retrieved by queries for a single Visualforce page request | 50,000 |
| Maximum rows retrieved by queries for a single Visualforce page request in read-only mode | 1,000,000 |
| Maximum collection items that can be iterated in an iteration component such as `<apex:pageBlockTable>` and `<apex:repeat>` | 1,000 |
| Maximum collection items that can be iterated in an iteration component such as `<apex:pageBlockTable>` and `<apex:repeat>` in read-only mode | 10,000 |
| Maximum field sets that can be displayed on a single Visualforce page. | 50 |
| Maximum field sets allowed per sObject. | 2,000 |
| Maximum fields through lookup relationships allowed per field set. | 25 |
| Maximum records that can be handled by StandardSetController | 10,000 |

## ⑩ Platform Event Allocations — 위임

> Platform Event / Change Data Capture / Pub/Sub API 할당량(이벤트 정의·발행·전달 한도, custom channel 수 등)은 [[Platform Event 한도와 고려사항]] 참조. 이 노트는 표를 재작성하지 않는다.

## 관련 노트
- [[Governor Limits]]
- [[Platform Event 한도와 고려사항]]
- [[Bulk API 2.0]]
- [[REST API]]
- [[Metadata API 개요]]
- [[SOQL 문법 레퍼런스]]
- [[SOSL 패턴]]
- [[Salesforce 플랫폼 개요]]
