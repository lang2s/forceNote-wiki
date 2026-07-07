---
tags: [Integration, SOAP, API, WSDL, enterprise-wsdl, partner-wsdl, SessionHeader]
source: Salesforce SOAP API Developer Guide (developer.salesforce.com/docs/atlas.en-us.api.meta) — v67.0 Summer '26
created: 2026-07-07
aliases: [SOAP API, SOAP 표준 API, Enterprise WSDL, Partner WSDL, SessionHeader, convertLead, getUpdated, getDeleted, 강타입 API]
---

# SOAP API (표준 오퍼레이션·enterprise·partner WSDL)

> Salesforce가 org 데이터를 XML/SOAP로 노출하는 강타입 웹서비스 API — WSDL로 스텁을 생성해 CRUD·쿼리·메타데이터·유틸리티 콜을 호출한다. 강타입·트랜잭션(AllOrNone)·성숙한 SOAP 툴 생태계가 필요할 때 REST 대신 쓴다.

---

## SOAP API가 무엇 · 언제 REST 대신 쓰나

SOAP API는 org의 표준/커스텀 오브젝트, 메타데이터, 유틸리티 기능을 **WSDL 계약**으로 노출하는 XML 기반 웹서비스다. 클라이언트는 WSDL을 소비(consume)해 언어별 스텁 클래스를 생성한 뒤 강타입 메서드로 호출한다.

| SOAP를 고르는 이유 | 설명 |
|---|---|
| 강타입(strongly typed) | Enterprise WSDL이 org의 오브젝트·필드를 정확한 데이터 타입으로 생성 → 컴파일 타임 검증 |
| 트랜잭션 원자성 | `AllOrNoneHeader`로 배치 전체를 한 번에 롤백 |
| 레거시/엔터프라이즈 툴 | SOAP만 지원하는 ESB·미들웨어(구버전 MuleSoft, BizTalk, JAX-WS 등)와 연동 |
| 확정된 콜 셋 | 승인 프로세스(`process`), 리드 전환(`convertLead`), 병합(`merge`) 등 REST에 없거나 다른 형태인 오퍼레이션 |

> REST vs SOAP 상세 비교(경량 JSON·모던 툴·리소스 지향 vs XML 계약·강타입)는 [[REST API]]로 위임. 신규 통합은 대부분 REST가 권장이며, SOAP는 위 사유가 명확할 때 선택한다.

---

## 인증 · 절차 (login → SessionHeader)

```
1. login(username, password+securityToken) 호출
     → LoginResult { sessionId, serverUrl, userId, ... } 반환
2. serverUrl 을 후속 콜의 엔드포인트로 사용 (인스턴스별 URL)
3. sessionId 를 SOAP SessionHeader 에 넣어 모든 후속 콜에 전달
   (또는 OAuth 로 획득한 access_token 을 sessionId 로 사용)
```

```xml
<!-- 구조 예시 — 실제 동작 envelope 아님 -->
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                  xmlns:urn="urn:enterprise.soap.sforce.com">
  <soapenv:Header>
    <urn:SessionHeader>
      <urn:sessionId>00D...!AQ4AQ...</urn:sessionId>   <!-- login() 반환 sessionId -->
    </urn:SessionHeader>
  </soapenv:Header>
  <soapenv:Body>
    <urn:query><urn:queryString>SELECT Id, Name FROM Account LIMIT 10</urn:queryString></urn:query>
  </soapenv:Body>
</soapenv:Envelope>
```

- **엔드포인트**: 로그인은 `https://login.salesforce.com/services/Soap/c/<version>`(enterprise) 또는 `/services/Soap/u/<version>`(partner). 로그인 후에는 `LoginResult.serverUrl`이 지정한 인스턴스 URL로 콜한다.
- **login() deprecation 주의**: username/password 방식 `login()`은 단계적 폐지 대상이다. 신규/레거시 통합 모두 **OAuth 흐름으로 획득한 access_token을 sessionId로 사용**하도록 마이그레이션이 권장된다. OAuth 상세는 [[Connected App (연결된 앱) — OAuth 클라이언트]] 참조.
- **세션/rate limit**: sessionId는 세션 타임아웃까지 유효(재로그인 대신 재사용). concurrent 세션 수·API 요청 수는 org 한도에 걸린다.

---

## 핵심 콜 레퍼런스 (전수)

### 세션

| 콜 | 목적 | 반환 |
|---|---|---|
| `login()` | 로그인 서버에 인증, 클라이언트 세션 시작 (deprecated — OAuth 권장) | `LoginResult`(sessionId, serverUrl, userId, userInfo …) |
| `logout()` | 로그인 사용자의 세션 종료(무효화) | void |

### CRUD (배치 최대 200 레코드)

| 콜 | 목적 | 반환 |
|---|---|---|
| `create()` | 하나 이상의 새 레코드 추가 | `SaveResult[]`(id, success, errors) |
| `update()` | 기존 레코드 갱신 | `SaveResult[]` |
| `upsert()` | 외부 ID/커스텀 필드로 존재 판단해 있으면 update·없으면 create (멱등, 중복 회피에 권장) | `UpsertResult[]`(id, created, success, errors) |
| `delete()` | ID로 레코드 삭제(휴지통으로) | `DeleteResult[]`(id, success, errors) |
| `undelete()` | 휴지통의 레코드 복원 (`queryAll()`로 찾은 삭제 레코드) | `UndeleteResult[]` |
| `emptyRecycleBin()` | 휴지통에서 즉시 영구 삭제 | `EmptyRecycleBinResult[]` |

### 쿼리·검색·조회

| 콜 | 목적 | 반환 |
|---|---|---|
| `query()` | SOQL 실행, 조건 매칭 레코드 반환 (`QueryOptions.batchSize`로 배치 크기 제어) | `QueryResult`(records, done, queryLocator, size) |
| `queryMore()` | `queryLocator`로 다음 배치 조회(`done=false`일 때 반복) | `QueryResult` |
| `queryAll()` | 삭제·아카이브된 레코드까지 포함해 조회 (isDeleted, 태스크 아카이브 등) | `QueryResult` |
| `search()` | SOSL 텍스트 검색 실행 | `SearchResult`(searchRecords[]) |
| `retrieve()` | 오브젝트 타입·ID 목록·필드 목록을 지정해 레코드 조회(쿼리 아님) | `sObject[]` |

### 메타데이터 describe

| 콜 | 목적 | 반환 |
|---|---|---|
| `describeSObjects()` | 지정 오브젝트들의 메타데이터(필드·관계·CRUD 가능 여부 등). 한 번에 최대 100 타입 | `DescribeSObjectResult[]`(fields, childRelationships, recordTypeInfos …) |
| `describeGlobal()` | org의 모든 접근 가능 오브젝트 목록·기본 속성 | `DescribeGlobalResult`(sobjects[]) |
| `describeLayout()` | 오브젝트의 페이지 레이아웃·레코드 타입 매핑 | `DescribeLayoutResult` |

### 유틸리티·특수 오퍼레이션

| 콜 | 목적 | 반환 |
|---|---|---|
| `getUserInfo()` | 현재 로그인 사용자 정보(userId, orgId, 언어, 통화, 이메일 등) | `GetUserInfoResult` |
| `getUpdated()` | 지정 오브젝트에서 주어진 시간 범위 내 추가/변경된 레코드 ID 목록 (동기화 폴링용) | `GetUpdatedResult`(ids[], latestDateCovered) |
| `getDeleted()` | 지정 오브젝트에서 시간 범위 내 삭제된 레코드 ID 목록 | `GetDeletedResult`(deletedRecords[], earliestDateAvailable, latestDateCovered) |
| `getServerTimestamp()` | 서버 현재 시각(getUpdated/getDeleted 범위 산정 기준) | `GetServerTimestampResult`(timestamp) |
| `merge()` | 같은 타입 레코드 병합(마스터 + 최대 2개 병합, 자식 재부모화) | `MergeResult[]`(id, mergedRecordIds, updatedRelatedIds, success, errors) |
| `convertLead()` | 리드를 Account·Contact·(선택)Opportunity로 전환 | `LeadConvertResult[]`(accountId, contactId, opportunityId, leadId, success, errors) |
| `process()` | 승인 프로세스 인스턴스 제출/승인/반려 (`ProcessSubmitRequest`, `ProcessWorkitemRequest`) | `ProcessResult[]` |
| `setPassword()` | 지정 사용자 비밀번호를 특정 값으로 설정(관리자) | `SetPasswordResult` |
| `resetPassword()` | 사용자 비밀번호를 시스템 생성 임시 값으로 리셋 | `ResetPasswordResult`(password) |

> `create`/`update`/`upsert`/`delete`는 한 콜에 최대 200 레코드. `describeSObjects`는 최대 100 타입. `query`의 서버 반환 배치는 `QueryOptions.batchSize`(기본 500, 200~2000)로 제어.

---

## SOAP 헤더 (call 동작 제어)

SOAP envelope의 `<soapenv:Header>`에 넣어 콜 동작을 바꾼다.

| 헤더 | 필드 | 용도 |
|---|---|---|
| `SessionHeader` | `sessionId` | 로그인 세션(또는 OAuth 토큰). **모든 콜에 필수** |
| `CallOptions` | `client`, `defaultNamespace` | 클라이언트 식별자·기본 네임스페이스 지정(주로 파트너 WSDL) |
| `AssignmentRuleHeader` | `assignmentRuleId`, `useDefaultRule` | Case/Lead create·update 시 할당 규칙 적용 여부/규칙 지정 |
| `MruHeader` | `updateMru` | "최근 사용(MRU)" 목록 갱신 여부 |
| `AllOrNoneHeader` | `allOrNone` | true면 배치 중 하나라도 실패 시 전체 롤백(트랜잭션 원자성) |
| `QueryOptions` | `batchSize` | query/queryMore가 한 배치에 반환할 행 수(200~2000, 기본 500) |
| `EmailHeader` | `triggerAutoResponseEmail`, `triggerOtherEmail`, `triggerUserEmail` | DML 시 자동응답/알림 이메일 발송 트리거 여부 |
| `LocaleOptions` | `language` | describe 결과 등의 언어 로케일 |
| `DuplicateRuleHeader` | `allowSave`, `includeRecordDetails`, `runAsCurrentUser` | 중복 규칙 동작(중복이어도 저장 허용 등) 제어 |

---

## Enterprise WSDL vs Partner WSDL

| 구분 | Enterprise WSDL | Partner WSDL |
|---|---|---|
| 타이핑 | **강타입** — org의 오브젝트·필드가 구체 타입/필드로 생성 | **약타입(name-value)** — `sObject`가 필드 이름-값 배열로 일반화 |
| 대상 | **단일 org** 통합(사내 앱) | **다중 org** 통합(ISV·파트너, org마다 스키마가 다름) |
| 코드 편의 | 필드 접근이 타입 세이프(컴파일 검증) | 런타임에 필드명 문자열로 접근 |
| 스키마 변경 시 | org의 오브젝트/필드가 바뀌면 **WSDL 재다운로드·재소비 필요** | 스키마를 담지 않으므로 **버전당 한 번만** 소비하면 됨 |
| 전형적 사용자 | 자사 org에 붙는 백오피스 통합 | 여러 고객 org에 배포되는 패키지/커넥터 |

- 둘 다 같은 오퍼레이션 셋(위 표)을 제공한다. 차이는 sObject를 어떻게 표현하느냐다.
- Enterprise WSDL은 org 스키마 스냅샷이므로, 필드 추가 등 변경이 잦은 환경에서는 재다운로드 부담이 있다. 다중 org를 하나의 코드로 다뤄야 하는 ISV는 Partner WSDL을 쓴다.
- WSDL은 Setup → API 페이지에서 다운로드(Generate Enterprise/Partner WSDL).

> **소비 방향 구분**: 이 노트는 **외부 클라이언트가 Salesforce의 SOAP API를 호출**하는 표준 API다. 반대로 **Apex가 외부 SOAP 서비스를 소비**(외부 WSDL→Apex 스텁)하는 것은 [[WSDL2Apex — 외부 SOAP 소비 (스텁 생성·구조·한도)]], **Apex 메서드를 SOAP 웹서비스로 노출**하는 것은 [[SOAP Web Services 노출 (webservice 키워드)]]이다. 셋은 방향이 다르다.

---

## 관련 노트
- [[REST API]]
- [[SOAP Web Services 노출 (webservice 키워드)]]
- [[WSDL2Apex — 외부 SOAP 소비 (스텁 생성·구조·한도)]]
- [[통합 MOC]]
