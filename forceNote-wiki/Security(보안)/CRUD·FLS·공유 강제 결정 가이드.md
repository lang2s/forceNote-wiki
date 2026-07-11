---
tags: [Security, SecureCoding, AccessControl, CRUD, FLS, Sharing, UserMode, 보안가이드, 위협모델, 접근제어, 결정가이드]
source: secure_coding.pdf (Secure Coding Guide, v67.0 Summer '26) + 위키 노트 조합
created: 2026-07-11
aliases: [CRUD FLS Sharing 강제 결정, 접근 제어 수단 선택, USER_MODE vs stripInaccessible vs CanTheUser, access control decision guide, 언제 USER_MODE 언제 stripInaccessible, 동적 SOQL 접근제어, DML 사용자 권한 강제, 어떤 상황에 어떤 보안 수단, CRUD FLS 어떤 걸 써야 하나, as user queryWithBinds 선택]
---

# CRUD·FLS·공유 강제 결정 가이드

> "이 상황엔 이 수단" — 접근 제어 5수단(USER_MODE·queryWithBinds·as user/Safely·CanTheUser·stripInaccessible)과 sharing 키워드를 한 자리에서 결정만 내리는 노트. 각 수단의 문법·시그니처 상세는 링크된 Apex/Security 노트로 위임한다.

---

## 이 노트의 위치

Salesforce에서 "권한 없는 데이터가 새지 않게 하라"는 요구는 여러 수단으로 나뉘어 있어, 리뷰·구현 중 **무엇을 써야 하는지**가 가장 자주 막힌다. 이 노트는 그 결정만 모은다 — 각 수단이 **어떻게** 동작하는지(메서드 시그니처·enum·예외 타입)는 해당 Apex/Security 노트가 정본이며, 여기서 재서술하지 않는다.

> **근거 (Secure Coding Guide, Ch10 — Protect Your Application from CRUD/FLS Vulnerabilities · Protect Your Application from Sharing Violations):**
> *"By default, Apex data operations (SOQL, DML, and SOSL) run in system mode with full CRUD access to objects and fields."* → 기본이 무방비이므로 **명시적으로 강제 수단을 골라야** 한다.

---

## 먼저: 두 개의 독립 축

접근 제어는 **서로 직교하는 두 축**이다. 둘을 혼동하면 "sharing 걸었으니 안전하다"는 오해가 생긴다.

| 축 | 무엇을 거르나 | 제어 수단 |
|---|---|---|
| **행 (레코드 가시성)** | 공유 규칙상 접근 불가한 **레코드(행)** | `with` / `without` / `inherited sharing` 키워드 |
| **열·오브젝트 (CRUD/FLS)** | 접근 불가한 **오브젝트·필드(열)** | USER_MODE · `as user` · `CanTheUser` · `stripInaccessible` · describe |

> `with sharing`은 **행 필터일 뿐** 필드/오브젝트 권한을 적용하지 않는다. 완전한 방어는 **두 축 모두** 적용해야 한다 — 상세는 [[Sharing 키워드 (with·without·inherited sharing)]]·[[WITH USER_MODE]] 참조.

---

## 결정 매트릭스 — "이 상황엔 이 수단"

축: **쿼리 vs DML · 정적 vs 동적 · 사전체크 vs 사후정제 · 열(CRUD/FLS) vs 행(sharing)**.

| # | 상황 | 수단 | 왜 이것인가 | 상세 노트 |
|---|---|---|---|---|
| 1 | **정적 SOQL/SOSL**, 값만 사용자 입력 | `WITH USER_MODE` (SOSL은 `search.query(..., AccessLevel.USER_MODE)`) | 쿼리 모든 절에 FLS/CRUD/sharing을 한 번에 강제. `WITH SECURITY_ENFORCED`보다 우월(polymorphic·전체 FLS error·AppExchange 허용) | [[WITH USER_MODE]] |
| 2 | **동적 SOQL**(런타임 문자열 조립) | `Database.queryWithBinds(..., bindMap, AccessLevel.USER_MODE)` | 값 injection 방어(bindMap)와 접근제어(USER_MODE)를 동시에. accessLevel **필수** 메서드 | [[WITH USER_MODE]] · [[SOQL Injection 위협]] |
| 3 | **DML**(insert/update/upsert/delete) | `insert as user` / `Database.insert(recs, AccessLevel.USER_MODE)` — 부분성공·제거필드 감지 필요 시 `Safely` | 저장 시점에 오브젝트·필드 권한 강제. 위반 시 `DmlException`(`getFieldNames()`로 위반 필드) | [[WITH USER_MODE]] · [[Safely]] |
| 4 | **사전 분기** — UI 버튼 노출·HTTP 상태코드를 권한에 따라 결정 | `CanTheUser` / `Schema.DescribeSObjectResult`·`DescribeFieldResult` describe | DML/쿼리 **전에** Boolean으로 권한을 알아 흐름 제어(예: 권한 없으면 403). USER_MODE는 실행 시점에만 걸림 | [[CanTheUser]] |
| 5 | **신뢰 못 할 입력**(사용자 JSON·역직렬화 sObject) 정제 | `Security.stripInaccessible(AccessType, records)` | 접근 불가 필드를 **제거**하고 계속 진행(예외 대신). `getRemovedFields()`로 감사. USER_MODE 기본값과 무관하게 동작 | [[StripInaccessible]] · [[Safely]] |
| 6 | **행(레코드) 가시성** — 공유 규칙 적용 여부 | `with sharing`(기본·최소권한) / `without sharing`(표적 상승, 명시 필수) / `inherited sharing`(재사용 유틸) | 열이 아니라 **어떤 행을 볼 수 있나**. 트리거는 선언 불가→핸들러로 위임 | [[Sharing 키워드 (with·without·inherited sharing)]] |

### 빠른 판단 흐름

```text
// 구조 예시 — 실제 동작 코드 아님 (결정 흐름 개념)
데이터 작업인가?
├─ 쿼리(SOQL/SOSL)
│   ├─ 구조 고정, 값만 입력 ─────────────→ #1 WITH USER_MODE
│   └─ 문자열 런타임 조립 ───────────────→ #2 queryWithBinds + USER_MODE + 식별자 화이트리스트
├─ DML ──────────────────────────────────→ #3 insert/update as user (감지 필요 시 Safely)
├─ 실행 전에 권한 알아 분기해야 함 ───────→ #4 CanTheUser / describe
└─ 신뢰 못 할 JSON/역직렬화 입력 ─────────→ #5 stripInaccessible → DML
행(레코드)까지 걸러야 하나? ──────────────→ #6 sharing 키워드 (열 수단과 함께)
```

> **주의 (v67.0 기본값 변화):** Summer '26(API 67.0)부터 DB 작업의 기본 실행 모드가 **USER_MODE**, 선언 없는 클래스 기본이 **`with sharing`**으로 바뀌었다. 그래도 **명시**를 권장한다(의도 명확성). `WITH SECURITY_ENFORCED`는 v67.0에서 컴파일 오류이므로 `WITH USER_MODE`로 교체한다 — 상세 [[WITH USER_MODE]]·[[Safely]].

---

## 자주 틀리는 경계선

- **injection 방어 ≠ 접근 제어.** 값을 문법에서 분리(bind/화이트리스트)하는 것과, 누가 무엇을 볼 수 있나(USER_MODE/sharing)는 **별개 축**이다. 동적 SOQL은 #2처럼 둘 다 적용한다. → [[SOQL Injection 위협]]
- **USER_MODE는 예외를 던지고, stripInaccessible은 필드를 제거한다.** 사용자에게 부분 결과를 보여줘야 하거나 제거된 필드를 감사해야 하면 #5, 위반 시 중단이 맞으면 #1·#3. → [[StripInaccessible]] vs [[WITH USER_MODE]]
- **트리거는 명시적 sharing 선언이 불가**하고 `without sharing`으로 돈다. 데이터 접근 강제가 필요하면 로직을 핸들러 클래스로 위임한다. → [[Sharing 키워드 (with·without·inherited sharing)]]
- **CRUD/FLS·sharing 우회가 정당한 케이스**(Roll-Up·bespoke namespace 정책·guest 차단 등)는 AppExchange Security Review에 문서화 필수. → [[권한과 접근 제어 위협]]

---

## 관련 노트
- [[시큐어 코드 리뷰 체크리스트]] — 배포/PR 전 위협별 점검표(이 결정 가이드의 CRUD/FLS·Sharing 진입점)
- [[권한과 접근 제어 위협]] — CRUD/FLS bypass·sharing violation·privilege escalation 위협 모델
- [[WITH USER_MODE]] — USER_MODE/SYSTEM_MODE·AccessLevel·동적 SOQL accessLevel
- [[StripInaccessible]] — `Security.stripInaccessible`·`SObjectAccessDecision`·AccessType
- [[CanTheUser]] — CRUD/FLS 사전 체크·Schema describe 래퍼
- [[Safely]] — Fluent DML 보안 래퍼(부분성공·제거필드 감지)
- [[Sharing 키워드 (with·without·inherited sharing)]] — 행(레코드) 가시성 축
- [[SOQL Injection 위협]] — 값·식별자 injection 방어(직교 축)
- [[Secure Coding 개요]]
- [[Platform Security FAQ]]
